public class HeadAchievedSalesSummaryNotify {
    public static List<String> toAddress; 
    public static List<String> ccAddress;
    public static String markHeadEmail = System.Label.Marketing_Head_Email;     
    public static String srxHeadEmail = System.Label.SRx_Head_Email_Id;
    public static String eastRSMHeadEmail = System.Label.RSM_East_Head_Email_Id;
    public static String westRSMHeadEmail = System.Label.RSM_West_Head_Email_Id;
    public static String srxHeadName = 'N/A';
    public static List<WestDataWrapper> westWrapList {get;set;}
    public static List<WestDataWrapper> eastWrapList2 {get;set;}
    public static List<EastDataWrapper> eastWrapList {get;set;}
    public List<Target_Achieved_Approval__c> recDetails2 {get;set;}
    // public static Target_Achieved_Approval__c recDetails = [SELECT Id,Target_Number__c,Intial_Approver__c,Marketing_Approver__c,Marketing_Head_Approval_Sent_Time__c,Marketing_Head_Approval_Completed_Time__c,Marketing_Head_Comments__c,RSM_Approver__c,RSM_Head_Approval_Sent_Time__c,RSM_Head_Approval_Completed_Time__c,RSM_Head_Comments__c,SRx_Approver__c,SRx_Head_Approval_Sent_Time__c,SRx_Head_Approval_Completed_Time__c,SRx_Head_Comments__c FROM Target_Achieved_Approval__c];
    public HeadAchievedSalesSummaryNotify()
    {
        targetAchievedApprovalTableData();
        //  marketingHeadAchievedSalesSummaryNotify();
        /* if(recDetails2[0].Initiator_Head_Comments__c == null){
recDetails2[0].Initiator_Head_Comments__c = '-' ;   
upsert recDetails2[0];
}*/
    }
    public static void captureWrapperData(){
        List<AchievementSummaryTableCls.wrapperClass> westwrapData = AchievementSummaryTableCls.getWestDirectIndirectSalesList();
        //westwrapData.sort();
        System.debug('westwrapData =====>'+JSON.serialize(westwrapData));
        List<AchievementSummaryTableCls.wrapperClass> eastwrapData = AchievementSummaryTableCls.getEastDirectIndirectSalesList();
        System.debug('eastwrapData =====>'+JSON.serialize(eastwrapData));
        
    }
    public static Decimal percentCalculate(Decimal achieve,Decimal target){
        Decimal percentResult;
        if((achieve>0 && target>0)){
            percentResult = (achieve/target) * 100;
            System.debug('percentResult ===>'+percentResult);
        }
        else{
            percentResult = 0;
        }
        return percentResult;
    }
    public List<Target_Achieved_Approval__c> targetAchievedApprovalTableData(){
        String parentRecId = 'a21DL000002Bn5aYAC';
        // public List<Target_Achieved_Approval__c> recDetails {get;set;};
        recDetails2 = [SELECT Id,Name,Target_Number__c,Intial_Approver__c,Initiator_Approval_Sent_Time__c,Initiator_Approval_Completed_Time__c,Initiator_Head_Comments__c,Marketing_Approver__c,Marketing_Head_Approval_Sent_Time__c,Marketing_Head_Approval_Completed_Time__c,Marketing_Head_Comments__c,RSM_Approver__c,RSM_Head_Approval_Sent_Time__c,RSM_Head_Approval_Completed_Time__c,Initiator_Approval_Completed_Time_String__c,Initiator_Approval_Sent_Time_String__c,RSM_Head_Comments__c,SRx_Approver__c,SRx_Head_Approval_Sent_Time__c,SRx_Head_Approval_Completed_Time__c,SRx_Head_Comments__c,RSM_Head_Approval_Sent_Time_String__c,RSM_Head_Approval_Completed_Time_String__c,SRx_Head_Approval_Sent_Time_String__c,SRx_Head_Approval_Completed_Time_String__c,Marketing_Head_Approval_Sent_Time_String__c,Marketing_Head_Approval_Completed_Str__c FROM Target_Achieved_Approval__c WHERE ID=:parentRecId];
        return recDetails2;        
    } 
    public static void marketingHeadAchievedSalesSummaryNotify(String parentRecId){
        System.debug('Executing ===========> marketingHeadAchievedSalesSummaryNotify() ');
        //  String parentRecId = 'a21DL000002Bn5aYAC';
        Target_Achieved_Approval__c recDetails = [SELECT Id,Name,Target_Number__c,Intial_Approver__c,Marketing_Approver__c,Marketing_Head_Approval_Sent_Time__c,Marketing_Head_Approval_Completed_Time__c,Marketing_Head_Comments__c,RSM_Approver__c,RSM_Head_Approval_Sent_Time__c,RSM_Head_Approval_Completed_Time__c,RSM_Head_Comments__c,SRx_Approver__c,SRx_Head_Approval_Sent_Time__c,SRx_Head_Approval_Completed_Time__c,SRx_Head_Comments__c FROM Target_Achieved_Approval__c WHERE ID=:parentRecId];
        string content1 = '';
        string dynamicSubject = '';
        string dynamicTitle = ''; 
        string customerString = '';
        boolean alterRequired = false;
        DateTime createdDate;
        DateTime internalTarget; 
        DateTime rcaChangeDate;
        String targetValue;
        Integer fiscalYear;
        Integer fiscalQuarter;
        Integer previousQuarter;
        Date currentDate = Date.today();
        westWrapList = new List<WestDataWrapper>();
        eastWrapList = new List<EastDataWrapper>();
        // Set the fiscal year start month to April
        Integer fiscalYearStartMonth = 4;
        // Calculate fiscal year
        if (currentDate.month() >= fiscalYearStartMonth) {
            fiscalYear = currentDate.year() + 1;
        } else {
            fiscalYear = currentDate.year() - 1;
        }
        // Calculate fiscal quarter
        fiscalQuarter = ((currentDate.month() - fiscalYearStartMonth + 1) / 3) + 1;
        // Calculate fiscal quarter
        Integer calendarQuarter = ((currentDate.month() - 1) / 3) + 1;
        // Adjust fiscal quarter for your custom quarters
        if (calendarQuarter == 1) {
            fiscalQuarter = 4;
            previousQuarter = 3;
        } else if (calendarQuarter == 2) {
            fiscalQuarter = 1;
            previousQuarter = 4;
        } else if (calendarQuarter == 3) {
            fiscalQuarter = 2;
            previousQuarter = 1;
        } else {
            fiscalQuarter = 3;
            previousQuarter = 2;
        }
        List<AchievementSummaryTableCls.wrapperClass> westwrapData = AchievementSummaryTableCls.getWestDirectIndirectSalesList();
        System.debug('westwrapData =====>'+JSON.serialize(westwrapData));
        List<AchievementSummaryTableCls.wrapperClass> eastwrapData = AchievementSummaryTableCls.getEastDirectIndirectSalesList();
        System.debug('eastwrapData =====>'+JSON.serialize(eastwrapData));
        //subject
        dynamicSubject = 'Your Approval Required For '+recDetails.Target_Number__c+' - '+recDetails.Name+'==>Approve through email ';
        //title
        dynamicTitle = 'SRx Sales Team FY '+fiscalYear+' Q'+previousQuarter+' Achieved Sales';
        //Salutation
        content1 = '<table style="border-radius: 15px;margin-top: 8px;font-size: 14px;">';
        content1 +=   	'<tr>';
        content1 +=  			'<td style="width: 24px;">';
        content1 +=  			'</td>';
        content1 += 			'<td style="padding: 0px 8px;font-family: Sans-Serif;">Dear Milan Kalawadia,';
        content1 += 			'</td>';
        content1 += 		'</tr>';
        content1 += '</table>';
        content1 += '<table style="border-radius: 15px;margin-top: 8px;font-size: 14px;font-family: Sans-Serif;">';
        content1 +=    	'<tr>';
        content1 +=    		'<td style="width: 24px;"></td>';
        content1 += 		'<td style="padding: 0px 8px; font-family: Sans-Serif; padding-bottom: 10px;">Your approval is needed for the FY '+fiscalYear+' Q'+previousQuarter+' Achieved Sales Summary, detailing the individual sales performance of our SRx sales performance of our SRx Sales Team members<b>.</b> Please find the sales numbers below for your review and approval<b>.</b>';
        content1 +=    		' The Values are listed in tables below for your review<b>.</b>';
        content1 +=  			'</td>';
        content1 += 		'</tr>';
        content1 += '</table>';
        content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;width:50%"><tr><td style="width: 24px;"></td><td style="padding: 8px 8px 0px 8px;font-weight:600;color:#2d2d2d;">Achievement Summary of FY  '+fiscalYear+' Q'+previousQuarter+' Target Achievement Approval</td></tr></table>';
        if(previousQuarter == 1 || Test.isRunningTest()){
            content1 += ReuseQuarterDataCls.returnQuartData1();
        }    
        if(previousQuarter == 2 || Test.isRunningTest()){
            content1 += ReuseQuarterDataCls.returnQuartData2();
        }    
        if(previousQuarter == 3 || Test.isRunningTest()){
            content1 +=  ReuseQuarterDataCls.returnQuartData3();
        }    
        if(previousQuarter == 4 || Test.isRunningTest()){
            content1 +=  ReuseQuarterDataCls.returnQuartData4();
        }  
        content1 += '<table style="border-radius: 15px;margin-top: 8px;font-size: 14px;font-family: Sans-Serif;">';
        content1 +=  '<tr>';
        content1 +=  '<td style="width: 24px;"></td>';
        content1 +=   '<td style="padding: 0px 8px;font-family: Sans-Serif;">';
        content1 +=   'For Approval / Rejection through email, reply to this email with:<br>';
        content1 +=   'To Approve: "APPROVE" or "APPROVED" or "YES"<b>.</b><br>';
        content1 +=   'To Reject: "REJECT" or "REJECTED" or "NO"<b>.</b>';
        content1 +=    '</tr>';
        content1 +=    '</table>'; 
        content1 += '<table style="border-radius: 15px;margin-top: 8px;font-size: 14px;font-family: Sans-Serif;">';
        content1 +=   '<tr>';
        content1 +=   '<td style="width: 24px;"></td>';
        content1 +=    ' <td style="padding: 0px 8px;font-family: Sans-Serif;">';
        content1 +=   'For Approval / Rejection on BRIGHT:<br>';
        content1 +=      ' Refer to the link<b><a href="'+System.URL.getOrgDomainURL().toExternalForm()+'/lightning/n/SRx_Achievement_Tracker?c__tabId=3&c__recordId='+recDetails.Id+'">&nbsp;'+recDetails.Name+'</a></b><b>.</b>';
        content1 +=            '</td>';
        content1 +=         '</tr>';
        content1 +=           '</table>'; 
        content1 +=    '</tr>';
        content1 +=    '</table>'; 
        List<String> l1 = new List<String>();
        List<String> l2 = new List<String>();
        toAddress = new List<String>();
        ccAddress = new List<String>(); 
        toAddress.add(markHeadEmail);
        ccAddress.add(srxHeadEmail); 
        ccAddress.add(eastRSMHeadEmail); 
        ccAddress.add(westRSMHeadEmail); 
        ccAddress.add('bhavadeep.valavala@dhruvsoft.com');
        ccAddress.add('srimayeechilagani@drreddys.com');
        ccAddress.add('srimayee@dhruvsoft.com');
        //ccAddress.add('shailkmohmad@dhruvsoft.com');
        SRxAchievEmailNotifySendCls.sendEmailAlert(parentRecId, content1,toAddress,ccAddress,dynamicSubject, dynamicTitle, alterRequired);//USERS EMAIL ID's
        // SRxAchievEmailNotifySendCls.sendEmailAlert(parentRecId, content1, new List<String> {'pradeepkumarmutyala@drreddys.com','srimayee@dhruvsoft.com','shailkmohmad@dhruvsoft.com','rnaveen@dhruvsoft.com','srimayeechilagani@drreddys.com','bhavadeep.valavala@dhruvsoft.com'}, new List<String> {'naseershaik@drreddys.com','bhavadeep.valavala@dhruvsoft.com'}, dynamicSubject, dynamicTitle, alterRequired);//Testing
        // HeadApprovalEmailNotification.testMails(parentRecId, content1, l1, l2, dynamicSubject, dynamicTitle, alterRequired);
        // SRxAchievEmailNotifySendCls.sendEmailAlert(parentRecId, content1, new List<String> {'pradeepkumarmutyala@drreddys.com','naseershaik@drreddys.com','srimayeechilagani@drreddys.com','bhavadeep.valavala@dhruvsoft.com'}, new List<String> {'naseershaik@drreddys.com','bhavadeep.valavala@dhruvsoft.com'}, dynamicSubject, dynamicTitle, alterRequired);
    }  
    public static void marketingHeadAchievedSalesRejectionNotify(String parentRecId,String marketingHeadApprovalComptimeStr,String markHeadApprovComments){
        // String parentRecId = 'a1FDL000007kKld2AE';
        Target_Achieved_Approval__c recDetails = [SELECT Id,Name,Target_Number__c,Intial_Approver__c,Marketing_Approver__c,Marketing_Head_Approval_Sent_Time__c,Marketing_Head_Approval_Completed_Time__c,Marketing_Head_Comments__c,RSM_Approver__c,RSM_Head_Approval_Sent_Time__c,RSM_Head_Approval_Completed_Time__c,RSM_Head_Comments__c,SRx_Approver__c,SRx_Head_Approval_Sent_Time__c,SRx_Head_Approval_Completed_Time__c,SRx_Head_Comments__c FROM Target_Achieved_Approval__c WHERE ID=:parentRecId];
        string content1 = '';
        string dynamicSubject = '';
        string dynamicTitle = ''; 
        string customerString = '';
        boolean alterRequired = false;
        DateTime createdDate;
        DateTime internalTarget; 
        DateTime rcaChangeDate;
        String targetValue;
        Integer fiscalYear;
        Integer fiscalQuarter;
        Integer previousQuarter;
        Date currentDate = Date.today();
        String authorName ='';
        if(recDetails.Marketing_Approver__c == null){
            authorName = 'Milan Kalawadia';   
        }
        else{
            authorName = recDetails.Marketing_Approver__c;   
            
        }
        String rejectionComments = '';
        if(recDetails.Marketing_Head_Comments__c == null){
            rejectionComments = '';   
        }
        else{
            rejectionComments =  recDetails.Marketing_Head_Comments__c;
        }
        // Set the fiscal year start month to April
        Integer fiscalYearStartMonth = 4;
        // Calculate fiscal year
        if (currentDate.month() >= fiscalYearStartMonth) {
            fiscalYear = currentDate.year() + 1;
        } else {
            fiscalYear = currentDate.year() - 1;
        }
        // Calculate fiscal quarter
        fiscalQuarter = ((currentDate.month() - fiscalYearStartMonth + 1) / 3) + 1;
        // Calculate fiscal quarter
        Integer calendarQuarter = ((currentDate.month() - 1) / 3) + 1;
        // Adjust fiscal quarter for your custom quarters
        if (calendarQuarter == 1) {
            fiscalQuarter = 4;
            previousQuarter = 3;
        } else if (calendarQuarter == 2) {
            fiscalQuarter = 1;
            previousQuarter = 4;
        } else if (calendarQuarter == 3) {
            fiscalQuarter = 2;
            previousQuarter = 1;
        } else {
            fiscalQuarter = 3;
            previousQuarter = 2;
        }
        List<AchievementSummaryTableCls.wrapperClass> westwrapData = AchievementSummaryTableCls.getWestDirectIndirectSalesList();
        System.debug('westwrapData =====>'+JSON.serialize(westwrapData));
        List<AchievementSummaryTableCls.wrapperClass> eastwrapData = AchievementSummaryTableCls.getEastDirectIndirectSalesList();
        System.debug('eastwrapData =====>'+JSON.serialize(eastwrapData));
        //SRx_Target__c srxTargetparentRec = [SELECT Id,Name,Head_Target__c,Marketing_Head_Comments__c,SRx_Head_Comments__c,Marketing_Approver__c,SRx_Approver__c,Intial_Approver__c,SRx_Target__c.Marketing_Head_Approval_Completed_Time__c	FROM SRx_Target__c WHERE Id =: parentRecId ];
        // List<Sales_Reps_Targets__c> salesRepTargetChildRecs = [SELECT Id,User_Name__c,Name,Region__c,Quarter_1__c,Quarter_2__c,Quarter_3__c,Quarter_4__c,Annual__c,SRx_Target__c FROM Sales_Reps_Targets__c WHERE SRx_Target__c =: parentRecId];
        // System.debug('salesRepTargetChildRecsSize ===>'+salesRepTargetChildRecs.Size());
        // List<Sales_Reps_Targets__c> eastChildRecords = [SELECT Id,User_Name__c,Name,Region__c,Quarter_1__c,Quarter_2__c,Quarter_3__c,Quarter_4__c,Annual__c,SRx_Target__c FROM Sales_Reps_Targets__c WHERE Region__c = 'East' AND SRx_Target__c =: parentRecId];
        // List<Sales_Reps_Targets__c> westChildRecords = [SELECT Id,User_Name__c,Name,Region__c,Quarter_1__c,Quarter_2__c,Quarter_3__c,Quarter_4__c,Annual__c,SRx_Target__c FROM Sales_Reps_Targets__c WHERE Region__c = 'West'AND  SRx_Target__c =: parentRecId];
        String rejectionSentDateTime;
        if(recDetails.Marketing_Head_Approval_Completed_Time__c != null)
        {
            DateTime dt = DateTime.newInstance(
                Date.newInstance(
                    recDetails.Marketing_Head_Approval_Completed_Time__c.year(),
                    recDetails.Marketing_Head_Approval_Completed_Time__c.month(),
                    recDetails.Marketing_Head_Approval_Completed_Time__c.day()
                ),
                Time.newInstance(
                    recDetails.Marketing_Head_Approval_Completed_Time__c.hour(),
                    recDetails.Marketing_Head_Approval_Completed_Time__c.minute(),
                    recDetails.Marketing_Head_Approval_Completed_Time__c.second(),
                    recDetails.Marketing_Head_Approval_Completed_Time__c.millisecond()
                )
            );
            String userTimeZone = UserInfo.getTimeZone().getID();
            rejectionSentDateTime = dt.format('yyyy-MM-dd HH:mm:ss', 'GMT'); 
        }
        else{
            rejectionSentDateTime = ''; 
        }
        //subject
        dynamicSubject = 'Marketing Head Achieved Sales Rejection Of '+recDetails.Target_Number__c+' - '+recDetails.Name+' ' ;
        //title
        dynamicTitle = 'Marketing Head FY '+fiscalYear+' Q'+previousQuarter+' Achieved Sales Rejection';
        //Salutation
        content1 = '<table style="border-radius: 15px;margin-top: 8px;font-size: 14px;">';
        content1 +=   	'<tr>';
        content1 +=  			'<td style="width: 24px;">';
        content1 +=  			'</td>';
        content1 += 			'<td style="padding: 0px 8px;font-family: Sans-Serif;">Dear Team,';
        content1 += 			'</td>';
        content1 += 		'</tr>';
        content1 += '</table>';
        content1 += '<table style="border-radius: 15px;margin-top: 8px;font-size: 14px;font-family: Sans-Serif;">';
        content1 +=    	'<tr>';
        content1 +=    		'<td style="width: 24px;"></td>';
        content1 +=         '<td style="padding: 0px 8px; font-family: Sans-Serif; padding-bottom: 10px;">We want to inform you that Milan Kalawadia has rejected the FY '+fiscalYear+' Q'+previousQuarter+' Achieved Sales<b>.</b>';
        content1 +=    		' Please refer to the table displayed below for an overview of rejected Achieved Sales Summary<b>.</b>';
        content1 +=  		'</td>';
        content1 += 		'</tr>';
        content1 += '</table>';
        //Rejection comments
        content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;width:50%"><tr><td style="width: 24px;"></td><td style="padding: 8px 8px 0px 8px;font-weight:600;color:#2d2d2d;">Rejection Comments:</td></tr></table>';
        content1 += '<table style="border-radius: 15px;margin-top: 8px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding:0px 8px;font-family: Sans-Serif;">Milan Kalawadia ('+marketingHeadApprovalComptimeStr+') : '+markHeadApprovComments+'</td></tr></table>';
        content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;width:50%"><tr><td style="width: 24px;"></td><td style="padding: 8px 8px 0px 8px;font-weight:600;color:#2d2d2d;">Rejected Achieved Sales Summary:</td></tr></table>';
        content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;width:50%"><tr><td style="width: 24px;"></td><td style="padding: 8px 8px 0px 8px;font-weight:600;color:#2d2d2d;">Achievement Summary of FY  '+fiscalYear+' Q'+previousQuarter+' Target Achievement Approval</td></tr></table>';
        if(previousQuarter == 1 || Test.isRunningTest())
        {
            content1 +=   ReuseQuarterDataCls.returnQuartData1();
        }    
        
        if(previousQuarter == 2 || Test.isRunningTest())
        {
            content1 +=  ReuseQuarterDataCls.returnQuartData2();
        }    
        
        if(previousQuarter == 3 || Test.isRunningTest())
        {
            content1 +=    ReuseQuarterDataCls.returnQuartData3();
        }    
        
        if(previousQuarter == 4 || Test.isRunningTest())
        {
            content1 +=    ReuseQuarterDataCls.returnQuartData4();
        }  
        
        content1 += '<table style="border-radius: 15px;margin-top: 8px;font-size: 14px;font-family: Sans-Serif;">';
        content1 +=   '<tr>';
        content1 +=   '<td style="width: 24px;"></td>';
        content1 +=    ' <td style="padding: 0px 8px;font-family: Sans-Serif;">';
        content1 +=     ' To review the rejected FY '+fiscalYear+' Q'+previousQuarter+' Achieved Sales, refer to this link<b><a href="'+System.URL.getOrgDomainURL().toExternalForm()+'/lightning/n/SRx_Achievement_Tracker?c__tabId=3&c__recordId='+recDetails.Id+'">&nbsp;'+recDetails.Name+'</a></b><b>.</b>';
        content1 +=     '</td>';
        content1 +=      '</tr>';
        content1 +=      '</table>'; 
        content1 +=    '</tr>';
        content1 +=    '</table>'; 
        List<String> l1 = new List<String>();
        List<String> l2 = new List<String>();
        toAddress = new List<String>();
        ccAddress = new List<String>();
        // ccAddress.add(markHeadEmail);
        toAddress.add(srxHeadEmail); 
        toAddress.add(eastRSMHeadEmail); 
        toAddress.add(westRSMHeadEmail);
        ccAddress.add('srimayeechilagani@drreddys.com');
        ccAddress.add('srimayee@dhruvsoft.com');
       // ccAddress.add('pradeep@dhruvsoft.com');
        // ccAddress.add('shailkmohmad@dhruvsoft.com');
        SRxAchievEmailNotifySendCls.sendEmailAlert(parentRecId, content1,toAddress,ccAddress,dynamicSubject, dynamicTitle, alterRequired);//USERS EMAIL ID's
        // SRxAchievEmailNotifySendCls.sendEmailAlert(parentRecId, content1, new List<String> {'pradeepkumarmutyala@drreddys.com','srimayee@dhruvsoft.com','shailkmohmad@dhruvsoft.com','rnaveen@dhruvsoft.com','srimayeechilagani@drreddys.com','bhavadeep.valavala@dhruvsoft.com'}, new List<String> {'naseershaik@drreddys.com','bhavadeep.valavala@dhruvsoft.com'}, dynamicSubject, dynamicTitle, alterRequired);//Testing
        // HeadApprovalEmailNotification.testMails(parentRecId, content1, l1, l2, dynamicSubject, dynamicTitle, alterRequired);
        // SRxAchievEmailNotifySendCls.sendEmailAlert(parentRecId, content1, new List<String> {'pradeepkumarmutyala@drreddys.com','naseershaik@drreddys.com','srimayeechilagani@drreddys.com','bhavadeep.valavala@dhruvsoft.com'}, new List<String> {'naseershaik@drreddys.com','bhavadeep.valavala@dhruvsoft.com'}, dynamicSubject, dynamicTitle, alterRequired);
    } 
    public static void srxHeadAchievedSalesSummaryNotify(String parentRecId){
        //   String parentRecId = 'a1FDL000007kKld2AE';
        Target_Achieved_Approval__c recDetails = [SELECT Id,Name,Target_Number__c,Intial_Approver__c,Marketing_Approver__c,Marketing_Head_Approval_Sent_Time__c,Marketing_Head_Approval_Completed_Time__c,Marketing_Head_Comments__c,RSM_Approver__c,RSM_Head_Approval_Sent_Time__c,RSM_Head_Approval_Completed_Time__c,RSM_Head_Comments__c,SRx_Approver__c,SRx_Head_Approval_Sent_Time__c,SRx_Head_Approval_Completed_Time__c,SRx_Head_Comments__c FROM Target_Achieved_Approval__c WHERE ID=:parentRecId];
        string content1 = '';
        string dynamicSubject = '';
        string dynamicTitle = ''; 
        string customerString = '';
        boolean alterRequired = false;
        DateTime createdDate;
        DateTime internalTarget; 
        DateTime rcaChangeDate;
        String targetValue;
        Integer fiscalYear;
        Integer fiscalQuarter;
        Integer previousQuarter;
        Date currentDate = Date.today();
        // Set the fiscal year start month to April
        Integer fiscalYearStartMonth = 4;
        // Calculate fiscal year
        if (currentDate.month() >= fiscalYearStartMonth) {
            fiscalYear = currentDate.year() + 1;
        } else {
            fiscalYear = currentDate.year() - 1;
        }
        // Calculate fiscal quarter
        fiscalQuarter = ((currentDate.month() - fiscalYearStartMonth + 1) / 3) + 1;
        // Calculate fiscal quarter
        Integer calendarQuarter = ((currentDate.month() - 1) / 3) + 1;
        // Adjust fiscal quarter for your custom quarters
        if (calendarQuarter == 1) {
            fiscalQuarter = 4;
            previousQuarter = 3;
        } else if (calendarQuarter == 2) {
            fiscalQuarter = 1;
            previousQuarter = 4;
        } else if (calendarQuarter == 3) {
            fiscalQuarter = 2;
            previousQuarter = 1;
        } else {
            fiscalQuarter = 3;
            previousQuarter = 2;
        }
        List<AchievementSummaryTableCls.wrapperClass> westwrapData = AchievementSummaryTableCls.getWestDirectIndirectSalesList();
        System.debug('westwrapData =====>'+JSON.serialize(westwrapData));
        List<AchievementSummaryTableCls.wrapperClass> eastwrapData = AchievementSummaryTableCls.getEastDirectIndirectSalesList();
        System.debug('eastwrapData =====>'+JSON.serialize(eastwrapData));
        //subject
        //dynamicSubject = 'SRx Head Achieved Sales Summary Notification';
        dynamicSubject = 'Your Approval Required For '+recDetails.Target_Number__c+' - '+recDetails.Name+' ';
        //title
        dynamicTitle = 'SRx Sales Team FY '+fiscalYear+' Q'+previousQuarter+' Achieved Sales';
        //Salutation
        content1 = '<table style="border-radius: 15px;margin-top: 8px;font-size: 14px;">';
        content1 +=   	'<tr>';
        content1 +=  			'<td style="width: 24px;">';
        content1 +=  			'</td>';
        content1 += 			'<td style="padding: 0px 8px;font-family: Sans-Serif;">Dear Admin,';
        content1 += 			'</td>';
        content1 += 		'</tr>';
        content1 += '</table>';
        content1 += '<table style="border-radius: 15px;margin-top: 8px;font-size: 14px;font-family: Sans-Serif;">';
        content1 +=    	'<tr>';
        content1 +=    		'<td style="width: 24px;"></td>';
        content1 += 		'<td style="padding: 0px 8px; font-family: Sans-Serif; padding-bottom: 10px;">Your approval is needed for the FY '+fiscalYear+' Q'+previousQuarter+' Achieved Sales Summary, detailing the individual sales performance of our SRx Sales Team members<b>.</b>';
        content1 +=    		' Please find the sales numbers below for your review and approval<b>.</b>';
        content1 +=  			'</td>';
        content1 += 		'</tr>';
        content1 += '</table>';
        content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;width:50%"><tr><td style="width: 24px;"></td><td style="padding: 8px 8px 0px 8px;font-weight:600;color:#2d2d2d;">Achievement Summary of FY  '+fiscalYear+' Q'+previousQuarter+' Target Achievement Approval</td></tr></table>';
        if(previousQuarter == 1 || Test.isRunningTest())
        {
            content1 +=  ReuseQuarterDataCls.returnQuartData1();
        }    
        if(previousQuarter == 2 || Test.isRunningTest())
        {
            content1 +=  ReuseQuarterDataCls.returnQuartData2();
        }    
        if(previousQuarter == 3 || Test.isRunningTest())
        {
            content1 +=   ReuseQuarterDataCls.returnQuartData3();
        }    
        if(previousQuarter == 4 || Test.isRunningTest())
        {
            content1 +=   ReuseQuarterDataCls.returnQuartData4();
        }  
        content1 += '<table style="border-radius: 15px;margin-top: 8px;font-size: 14px;font-family: Sans-Serif;">';
        content1 +=   '<tr>';
        content1 +=   '<td style="width: 24px;"></td>';
        content1 +=    ' <td style="padding: 0px 8px;font-family: Sans-Serif;">';
        content1 +=      ' To approve or reject the Achieved Sales, refer to this link <b><a href="'+System.URL.getOrgDomainURL().toExternalForm()+'/lightning/n/SRx_Achievement_Tracker?c__tabId=3&c__recordId='+recDetails.Id+'">&nbsp;'+recDetails.Name+'</a></b><b>.</b>';
        content1 +=            '</td>';
        content1 +=         '</tr>';
        content1 +=           '</table>'; 
        content1 +=    '</tr>';
        content1 +=    '</table>'; 
        List<String> l1 = new List<String>();
        List<String> l2 = new List<String>();
        toAddress = new List<String>();
        ccAddress = new List<String>();
        //ccAddress.add(markHeadEmail);
        toAddress.add(srxHeadEmail); 
        ccAddress.add(eastRSMHeadEmail); 
        ccAddress.add(westRSMHeadEmail);
        ccAddress.add('srimayeechilagani@drreddys.com');
        ccAddress.add('srimayee@dhruvsoft.com');
      //  ccAddress.add('pradeep@dhruvsoft.com');
        // ccAddress.add('shailkmohmad@dhruvsoft.com');
        SRxAchievEmailNotifySendCls.sendEmailAlert(parentRecId, content1,toAddress,ccAddress,dynamicSubject, dynamicTitle, alterRequired);//USERS EMAIL ID's
        //SRxAchievEmailNotifySendCls.sendEmailAlert(parentRecId, content1, new List<String> {'pradeepkumarmutyala@drreddys.com','srimayee@dhruvsoft.com','shailkmohmad@dhruvsoft.com','rnaveen@dhruvsoft.com','srimayeechilagani@drreddys.com','bhavadeep.valavala@dhruvsoft.com'}, new List<String> {'naseershaik@drreddys.com','bhavadeep.valavala@dhruvsoft.com'}, dynamicSubject, dynamicTitle, alterRequired);//Testing
        // HeadApprovalEmailNotification.testMails(parentRecId, content1, l1, l2, dynamicSubject, dynamicTitle, alterRequired);
        // SRxAchievEmailNotifySendCls.sendEmailAlert(parentRecId, content1, new List<String> {'pradeepkumarmutyala@drreddys.com','naseershaik@drreddys.com','srimayeechilagani@drreddys.com','bhavadeep.valavala@dhruvsoft.com'}, new List<String> {'naseershaik@drreddys.com','bhavadeep.valavala@dhruvsoft.com'}, dynamicSubject, dynamicTitle, alterRequired);
    }  
    public static void srxHeadAchievedSalesRejectionNotify(String parentRecId){
        //  String parentRecId = 'a1FDL000007kKld2AE';
        Target_Achieved_Approval__c recDetails = [SELECT Id,Name,Target_Number__c,Intial_Approver__c,Marketing_Approver__c,Marketing_Head_Approval_Sent_Time__c,Marketing_Head_Approval_Completed_Time__c,Marketing_Head_Comments__c,RSM_Approver__c,RSM_Head_Approval_Sent_Time__c,RSM_Head_Approval_Completed_Time__c,RSM_Head_Comments__c,SRx_Approver__c,SRx_Head_Approval_Sent_Time__c,SRx_Head_Approval_Completed_Time__c,SRx_Head_Comments__c FROM Target_Achieved_Approval__c WHERE ID=:parentRecId];
        string content1 = '';
        string dynamicSubject = '';
        string dynamicTitle = ''; 
        string customerString = '';
        boolean alterRequired = false;
        DateTime createdDate;
        DateTime internalTarget; 
        DateTime rcaChangeDate;
        String targetValue;
        Integer fiscalYear;
        Integer fiscalQuarter;
        Integer previousQuarter;
        Date currentDate = Date.today();
        // Set the fiscal year start month to April
        Integer fiscalYearStartMonth = 4;
        // Calculate fiscal year
        if (currentDate.month() >= fiscalYearStartMonth) {
            fiscalYear = currentDate.year() + 1;
        } else {
            fiscalYear = currentDate.year() - 1;
        }
        // Calculate fiscal quarter
        fiscalQuarter = ((currentDate.month() - fiscalYearStartMonth + 1) / 3) + 1;
        // Calculate fiscal quarter
        Integer calendarQuarter = ((currentDate.month() - 1) / 3) + 1;
        // Adjust fiscal quarter for your custom quarters
        if (calendarQuarter == 1) {
            fiscalQuarter = 4;
            previousQuarter = 3;
        } else if (calendarQuarter == 2) {
            fiscalQuarter = 1;
            previousQuarter = 4;
        } else if (calendarQuarter == 3) {
            fiscalQuarter = 2;
            previousQuarter = 1;
        } else {
            fiscalQuarter = 3;
            previousQuarter = 2;
        }        
        List<AchievementSummaryTableCls.wrapperClass> westwrapData = AchievementSummaryTableCls.getWestDirectIndirectSalesList();
        System.debug('westwrapData =====>'+JSON.serialize(westwrapData));
        List<AchievementSummaryTableCls.wrapperClass> eastwrapData = AchievementSummaryTableCls.getEastDirectIndirectSalesList();
        System.debug('eastwrapData =====>'+JSON.serialize(eastwrapData));
        //SRx_Target__c srxTargetparentRec = [SELECT Id,Name,Head_Target__c,Marketing_Head_Comments__c,SRx_Head_Comments__c,Marketing_Approver__c,SRx_Approver__c,Intial_Approver__c,SRx_Target__c.Marketing_Head_Approval_Completed_Time__c	FROM SRx_Target__c WHERE Id =: parentRecId ];
        // List<Sales_Reps_Targets__c> salesRepTargetChildRecs = [SELECT Id,User_Name__c,Name,Region__c,Quarter_1__c,Quarter_2__c,Quarter_3__c,Quarter_4__c,Annual__c,SRx_Target__c FROM Sales_Reps_Targets__c WHERE SRx_Target__c =: parentRecId];
        // System.debug('salesRepTargetChildRecsSize ===>'+salesRepTargetChildRecs.Size());
        // List<Sales_Reps_Targets__c> eastChildRecords = [SELECT Id,User_Name__c,Name,Region__c,Quarter_1__c,Quarter_2__c,Quarter_3__c,Quarter_4__c,Annual__c,SRx_Target__c FROM Sales_Reps_Targets__c WHERE Region__c = 'East' AND SRx_Target__c =: parentRecId];
        // List<Sales_Reps_Targets__c> westChildRecords = [SELECT Id,User_Name__c,Name,Region__c,Quarter_1__c,Quarter_2__c,Quarter_3__c,Quarter_4__c,Annual__c,SRx_Target__c FROM Sales_Reps_Targets__c WHERE Region__c = 'West'AND  SRx_Target__c =: parentRecId];
        String rejectionSentDateTime;
        if(recDetails.SRx_Head_Approval_Completed_Time__c != null)
        {
            DateTime dt = DateTime.newInstance(
                Date.newInstance(
                    recDetails.SRx_Head_Approval_Completed_Time__c.year(),
                    recDetails.SRx_Head_Approval_Completed_Time__c.month(),
                    recDetails.SRx_Head_Approval_Completed_Time__c.day()
                ),
                Time.newInstance(
                    recDetails.SRx_Head_Approval_Completed_Time__c.hour(),
                    recDetails.SRx_Head_Approval_Completed_Time__c.minute(),
                    recDetails.SRx_Head_Approval_Completed_Time__c.second(),
                    recDetails.SRx_Head_Approval_Completed_Time__c.millisecond()
                )
            );
            String userTimeZone = UserInfo.getTimeZone().getID();
            rejectionSentDateTime = dt.format('yyyy-MM-dd HH:mm:ss', 'GMT'); 
        }
        else{
            rejectionSentDateTime = ''; 
        }
        //subject
        //  dynamicSubject = 'SRx Head Achieved Sales Rejection';
        dynamicSubject = 'SRx Head Achieved Sales Rejection For '+recDetails.Target_Number__c+' - '+recDetails.Name+'';        
        //title
        dynamicTitle = 'SRx Head FY '+fiscalYear+' Q'+previousQuarter+' Achieved Sales Rejection';
        //Salutation
        content1 = '<table style="border-radius: 15px;margin-top: 8px;font-size: 14px;">';
        content1 +=   	'<tr>';
        content1 +=  			'<td style="width: 24px;">';
        content1 +=  			'</td>';
        content1 += 			'<td style="padding: 0px 8px;font-family: Sans-Serif;">Dear Team,';
        content1 += 			'</td>';
        content1 += 		'</tr>';
        content1 += '</table>';
        content1 += '<table style="border-radius: 15px;margin-top: 8px;font-size: 14px;font-family: Sans-Serif;">';
        content1 +=    	'<tr>';
        content1 +=    		'<td style="width: 24px;"></td>';
        content1 += '<td style="padding: 0px 8px; font-family: Sans-Serif; padding-bottom: 10px;">We want to inform you that admin has rejected the FY '+fiscalYear+' Q'+previousQuarter+' Achieved Sales<b>.</b> Please refer to the table displayed below for an overview of rejected Achieved Sales Summary<b>.</b>';
        //  content1 +=    		' The Values are listed in tables below for your review<b>.</b>';
        content1 +=  			'</td>';
        content1 += 		'</tr>';
        content1 += '</table>';
        //Rejection comments
        content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;width:50%"><tr><td style="width: 24px;"></td><td style="padding: 8px 8px 0px 8px;font-weight:600;color:#2d2d2d;">Rejection Comments:</td></tr></table>';
        content1 += '<table style="border-radius: 15px;margin-top: 8px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding:0px 8px;font-family: Sans-Serif;">Admin ('+rejectionSentDateTime+') : '+(recDetails.SRx_Head_Comments__c != null ? recDetails.SRx_Head_Comments__c : '')+'</td></tr></table>';
        content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;width:50%"><tr><td style="width: 24px;"></td><td style="padding: 8px 8px 0px 8px;font-weight:600;color:#2d2d2d;">Rejected Achieved Sales Summary:</td></tr></table>'; 
        content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;width:50%"><tr><td style="width: 24px;"></td><td style="padding: 8px 8px 0px 8px;font-weight:600;color:#2d2d2d;">Achievement Summary of FY  '+fiscalYear+' Q'+previousQuarter+' Target Achievement Approval</td></tr></table>';
        if(previousQuarter == 1 || Test.isRunningTest())
        {
            content1 +=  ReuseQuarterDataCls.returnQuartData1();
        }    
        if(previousQuarter == 2 || Test.isRunningTest())
        {
            content1 += ReuseQuarterDataCls.returnQuartData2();
        }    
        if(previousQuarter == 3 || Test.isRunningTest())
        {
            content1 +=   ReuseQuarterDataCls.returnQuartData3();
        }    
        if(previousQuarter == 4 || Test.isRunningTest())
        {
            content1 +=   ReuseQuarterDataCls.returnQuartData4();
        }  
        content1 += '<table style="border-radius: 15px;margin-top: 8px;font-size: 14px;font-family: Sans-Serif;">';
        content1 +=   '<tr>';
        content1 +=   '<td style="width: 24px;"></td>';
        content1 +=    ' <td style="padding: 0px 8px;font-family: Sans-Serif;">';
        content1 +=      ' To review the rejected FY '+fiscalYear+' Q'+previousQuarter+' Achieved Sales,refer to this link <b><a href="'+System.URL.getOrgDomainURL().toExternalForm()+'/lightning/n/SRx_Achievement_Tracker?c__tabId=3&c__recordId='+recDetails.Id+'">&nbsp;Achieved Sales Summary Hyperlink</a></b><b>.</b>';
        content1 +=            '</td>';
        content1 +=         '</tr>';
        content1 +=           '</table>'; 
        content1 +=    '</tr>';
        content1 +=    '</table>'; 
        List<String> l1 = new List<String>();
        List<String> l2 = new List<String>();
        toAddress = new List<String>();
        ccAddress = new List<String>();
        toAddress.add(markHeadEmail);
        //ccAddress.add(srxHeadEmail); 
        toAddress.add(eastRSMHeadEmail); 
        toAddress.add(westRSMHeadEmail);
        ccAddress.add('srimayeechilagani@drreddys.com');
        ccAddress.add('srimayee@dhruvsoft.com');
      //  ccAddress.add('pradeep@dhruvsoft.com');
        // ccAddress.add('shailkmohmad@dhruvsoft.com');
        SRxAchievEmailNotifySendCls.sendEmailAlert(parentRecId, content1,toAddress,ccAddress,dynamicSubject, dynamicTitle, alterRequired);//USERS EMAIL ID's
        // SRxAchievEmailNotifySendCls.sendEmailAlert(parentRecId, content1, new List<String> {'pradeepkumarmutyala@drreddys.com','srimayee@dhruvsoft.com','shailkmohmad@dhruvsoft.com','rnaveen@dhruvsoft.com','srimayeechilagani@drreddys.com','bhavadeep.valavala@dhruvsoft.com'}, new List<String> {'naseershaik@drreddys.com','bhavadeep.valavala@dhruvsoft.com'}, dynamicSubject, dynamicTitle, alterRequired);//Testing
        //  HeadApprovalEmailNotification.testMails(parentRecId, content1, l1, l2, dynamicSubject, dynamicTitle, alterRequired);
        //  SRxAchievEmailNotifySendCls.sendEmailAlert(parentRecId, content1, new List<String> {'pradeepkumarmutyala@drreddys.com','naseershaik@drreddys.com','srimayeechilagani@drreddys.com','bhavadeep.valavala@dhruvsoft.com'}, new List<String> {'naseershaik@drreddys.com','bhavadeep.valavala@dhruvsoft.com'}, dynamicSubject, dynamicTitle, alterRequired);
    }  
    public static void rsmHeadAchievedSalesSummaryNotify(String parentRecId){
        //    String parentRecId = 'a1FDL000007kKld2AE';
        Target_Achieved_Approval__c recDetails = [SELECT Id,Name,Target_Number__c,Intial_Approver__c,Marketing_Approver__c,Marketing_Head_Approval_Sent_Time__c,Marketing_Head_Approval_Completed_Time__c,Marketing_Head_Comments__c,RSM_Approver__c,RSM_Head_Approval_Sent_Time__c,RSM_Head_Approval_Completed_Time__c,RSM_Head_Comments__c,SRx_Approver__c,SRx_Head_Approval_Sent_Time__c,SRx_Head_Approval_Completed_Time__c,SRx_Head_Comments__c FROM Target_Achieved_Approval__c WHERE ID=:parentRecId];
        string content1 = '';
        string dynamicSubject = '';
        string dynamicTitle = ''; 
        string customerString = '';
        boolean alterRequired = false;
        DateTime createdDate;
        DateTime internalTarget; 
        DateTime rcaChangeDate;
        String targetValue;
        Integer fiscalYear;
        Integer fiscalQuarter;
        Integer previousQuarter;
        Date currentDate = Date.today();
        String authorName = '';
        if(recDetails.RSM_Approver__c == 'Eric Sutherland'){
            authorName = 'Dave Smith';
        }
        else if(recDetails.RSM_Approver__c == 'Dave Smith'){
            authorName = 'Eric Sutherland';
        }
        else{
            authorName = '';
        }
        // Set the fiscal year start month to April
        Integer fiscalYearStartMonth = 4;
        // Calculate fiscal year
        if (currentDate.month() >= fiscalYearStartMonth) {
            fiscalYear = currentDate.year() + 1;
        } else {
            fiscalYear = currentDate.year() - 1;
        }
        // Calculate fiscal quarter
        fiscalQuarter = ((currentDate.month() - fiscalYearStartMonth + 1) / 3) + 1;
        // Calculate fiscal quarter
        Integer calendarQuarter = ((currentDate.month() - 1) / 3) + 1;
        // Adjust fiscal quarter for your custom quarters
        if (calendarQuarter == 1) {
            fiscalQuarter = 4;
            previousQuarter = 3;
        } else if (calendarQuarter == 2) {
            fiscalQuarter = 1;
            previousQuarter = 4;
        } else if (calendarQuarter == 3) {
            fiscalQuarter = 2;
            previousQuarter = 1;
        } else {
            fiscalQuarter = 3;
            previousQuarter = 2;
        }   
        List<AchievementSummaryTableCls.wrapperClass> westwrapData = AchievementSummaryTableCls.getWestDirectIndirectSalesList();
        System.debug('westwrapData =====>'+JSON.serialize(westwrapData));
        List<AchievementSummaryTableCls.wrapperClass> eastwrapData = AchievementSummaryTableCls.getEastDirectIndirectSalesList();
        System.debug('eastwrapData =====>'+JSON.serialize(eastwrapData));
        //subject
        // dynamicSubject = 'RSM Achieved Sales Summary Notification';
        dynamicSubject = 'Your Approval Required For '+recDetails.Target_Number__c+' - '+recDetails.Name+' ';
        //title
        dynamicTitle = 'SRx Sales Team FY '+fiscalYear+' '+previousQuarter+' Achieved Sales';
        //Salutation
        content1 = '<table style="border-radius: 15px;margin-top: 8px;font-size: 14px;">';
        content1 +=   	'<tr>';
        content1 +=  			'<td style="width: 24px;">';
        content1 +=  			'</td>';
        content1 += 			'<td style="padding: 0px 8px;font-family: Sans-Serif;">Dear '+authorName+',';
        content1 += 			'</td>';
        content1 += 		'</tr>';
        content1 += '</table>';
        content1 += '<table style="border-radius: 15px;margin-top: 8px;font-size: 14px;font-family: Sans-Serif;">';
        content1 +=    	'<tr>';
        content1 +=    		'<td style="width: 24px;"></td>';
        content1 += '<td style="padding: 0px 8px; font-family: Sans-Serif; padding-bottom: 10px;">Your approval is needed for the FY '+fiscalYear+' '+previousQuarter+' Achieved Sales Summary, detailing the individual sales performance of our SRx Sales Team members<b>.</b>';
        content1 +=    		' Please find the sales numbers below for your review and approval<b>.</b>';
        content1 +=  			'</td>';
        content1 += 		'</tr>';
        content1 += '</table>';
        content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;width:50%"><tr><td style="width: 24px;"></td><td style="padding: 8px 8px 0px 8px;font-weight:600;color:#2d2d2d;">Achievement Summary of FY  '+fiscalYear+' Q'+previousQuarter+' Target Achievement Approval</td></tr></table>';
        if(previousQuarter == 1 || Test.isRunningTest())
        {
            content1 +=  ReuseQuarterDataCls.returnQuartData1();
        }    
        
        if(previousQuarter == 2 || Test.isRunningTest())
        {
            content1 += ReuseQuarterDataCls.returnQuartData2();
        }    
        
        if(previousQuarter == 3 || Test.isRunningTest())
        {
            content1 += ReuseQuarterDataCls.returnQuartData3();
        }    
        
        if(previousQuarter == 4 || Test.isRunningTest())
        {
            content1 +=  ReuseQuarterDataCls.returnQuartData4();
        }  
        content1 += '<table style="border-radius: 15px;margin-top: 8px;font-size: 14px;font-family: Sans-Serif;">';
        content1 +=   '<tr>';
        content1 +=   '<td style="width: 24px;"></td>';
        content1 +=    ' <td style="padding: 0px 8px;font-family: Sans-Serif;">';
        content1 +=      'To approve or reject the Achieved Sales,refer to this link<b><a href="'+System.URL.getOrgDomainURL().toExternalForm()+'/lightning/n/SRx_Achievement_Tracker?c__tabId=3&c__recordId='+recDetails.Id+'">&nbsp;Achieved Sales Summary Hyperlink</a></b><b>.</b>';
        content1 +=            '</td>';
        content1 +=         '</tr>';
        content1 +=           '</table>'; 
        content1 +=    '</tr>';
        content1 +=    '</table>'; 
        List<String> l1 = new List<String>();
        List<String> l2 = new List<String>();
        toAddress = new List<String>();
        ccAddress = new List<String>();
        if(recDetails.RSM_Approver__c == 'Eric Sutherland'){
            toAddress.add(westRSMHeadEmail);
            ccAddress.add(eastRSMHeadEmail); 
        }
        else if(recDetails.RSM_Approver__c == 'Dave Smith'){
            toAddress.add(eastRSMHeadEmail); 
            ccAddress.add(westRSMHeadEmail);
        }
        ccAddress.add(markHeadEmail);
        ccAddress.add(srxHeadEmail);
        ccAddress.add('srimayeechilagani@drreddys.com');
        ccAddress.add('srimayee@dhruvsoft.com');
     //   ccAddress.add('pradeep@dhruvsoft.com');
        //  ccAddress.add('shailkmohmad@dhruvsoft.com');
        // ccAddress.add(eastRSMHeadEmail); 
        // ccAddress.add(westRSMHeadEmail); 
        SRxAchievEmailNotifySendCls.sendEmailAlert(parentRecId, content1,toAddress,ccAddress,dynamicSubject, dynamicTitle, alterRequired);//USERS EMAIL ID's
        //  SRxAchievEmailNotifySendCls.sendEmailAlert(parentRecId, content1, new List<String> {'pradeepkumarmutyala@drreddys.com','srimayee@dhruvsoft.com','shailkmohmad@dhruvsoft.com','rnaveen@dhruvsoft.com','srimayeechilagani@drreddys.com','bhavadeep.valavala@dhruvsoft.com'}, new List<String> {'naseershaik@drreddys.com','bhavadeep.valavala@dhruvsoft.com'}, dynamicSubject, dynamicTitle, alterRequired);//Testing
        //  HeadApprovalEmailNotification.testMails(parentRecId, content1, l1, l2, dynamicSubject, dynamicTitle, alterRequired);
        //  SRxAchievEmailNotifySendCls.sendEmailAlert(parentRecId, content1, new List<String> {'pradeepkumarmutyala@drreddys.com','naseershaik@drreddys.com','srimayeechilagani@drreddys.com','bhavadeep.valavala@dhruvsoft.com'}, new List<String> {'naseershaik@drreddys.com','bhavadeep.valavala@dhruvsoft.com'}, dynamicSubject, dynamicTitle, alterRequired);
    }  
    public static void rsmHeadAchievedSalesRejectionNotify(String parentRecId){
        //    String parentRecId = 'a1FDL000007kKld2AE';
        Target_Achieved_Approval__c recDetails = [SELECT Id,Name,Target_Number__c,Intial_Approver__c,Marketing_Approver__c,Marketing_Head_Approval_Sent_Time__c,Marketing_Head_Approval_Completed_Time__c,Marketing_Head_Comments__c,RSM_Approver__c,RSM_Head_Approval_Sent_Time__c,RSM_Head_Approval_Completed_Time__c,RSM_Head_Comments__c,SRx_Approver__c,SRx_Head_Approval_Sent_Time__c,SRx_Head_Approval_Completed_Time__c,SRx_Head_Comments__c FROM Target_Achieved_Approval__c WHERE ID=:parentRecId];
        string content1 = '';
        string dynamicSubject = '';
        string dynamicTitle = ''; 
        string customerString = '';
        boolean alterRequired = false;
        DateTime createdDate;
        DateTime internalTarget; 
        DateTime rcaChangeDate;
        String targetValue;
        Integer fiscalYear;
        Integer fiscalQuarter;
        Integer previousQuarter;
        Date currentDate = Date.today();
        String authorName = '';
        if(recDetails.RSM_Approver__c == 'Eric Sutherland'){
            authorName = 'Dave Smith';
        }
        else if(recDetails.RSM_Approver__c == 'Dave Smith'){
            authorName = 'Eric Sutherland';
        }
        else{
            authorName = '';
        }
        // Set the fiscal year start month to April
        Integer fiscalYearStartMonth = 4;
        
        // Calculate fiscal year
        if (currentDate.month() >= fiscalYearStartMonth) {
            fiscalYear = currentDate.year() + 1;
        } else {
            fiscalYear = currentDate.year() - 1;
        }
        // Calculate fiscal quarter
        fiscalQuarter = ((currentDate.month() - fiscalYearStartMonth + 1) / 3) + 1;
        // Calculate fiscal quarter
        Integer calendarQuarter = ((currentDate.month() - 1) / 3) + 1;
        // Adjust fiscal quarter for your custom quarters
        if (calendarQuarter == 1) {
            fiscalQuarter = 4;
            previousQuarter = 3;
        } else if (calendarQuarter == 2) {
            fiscalQuarter = 1;
            previousQuarter = 4;
        } else if (calendarQuarter == 3) {
            fiscalQuarter = 2;
            previousQuarter = 1;
        } else {
            fiscalQuarter = 3;
            previousQuarter = 2;
        }   
        List<AchievementSummaryTableCls.wrapperClass> westwrapData = AchievementSummaryTableCls.getWestDirectIndirectSalesList();
        System.debug('westwrapData =====>'+JSON.serialize(westwrapData));
        List<AchievementSummaryTableCls.wrapperClass> eastwrapData = AchievementSummaryTableCls.getEastDirectIndirectSalesList();
        System.debug('eastwrapData =====>'+JSON.serialize(eastwrapData));
        // SRx_Target__c srxTargetparentRec = [SELECT Id,Name,Head_Target__c,Marketing_Head_Comments__c,SRx_Head_Comments__c,Marketing_Approver__c,SRx_Approver__c,Intial_Approver__c,SRx_Target__c.Marketing_Head_Approval_Completed_Time__c	FROM SRx_Target__c WHERE Id =: parentRecId ];
        // List<Sales_Reps_Targets__c> salesRepTargetChildRecs = [SELECT Id,User_Name__c,Name,Region__c,Quarter_1__c,Quarter_2__c,Quarter_3__c,Quarter_4__c,Annual__c,SRx_Target__c FROM Sales_Reps_Targets__c WHERE SRx_Target__c =: parentRecId];
        // System.debug('salesRepTargetChildRecsSize ===>'+salesRepTargetChildRecs.Size());
        // List<Sales_Reps_Targets__c> eastChildRecords = [SELECT Id,User_Name__c,Name,Region__c,Quarter_1__c,Quarter_2__c,Quarter_3__c,Quarter_4__c,Annual__c,SRx_Target__c FROM Sales_Reps_Targets__c WHERE Region__c = 'East' AND SRx_Target__c =: parentRecId];
        // List<Sales_Reps_Targets__c> westChildRecords = [SELECT Id,User_Name__c,Name,Region__c,Quarter_1__c,Quarter_2__c,Quarter_3__c,Quarter_4__c,Annual__c,SRx_Target__c FROM Sales_Reps_Targets__c WHERE Region__c = 'West'AND  SRx_Target__c =: parentRecId];
        String rejectionSentDateTime;
        if(recDetails.RSM_Head_Approval_Completed_Time__c != null)
        {
            DateTime dt = DateTime.newInstance(
                Date.newInstance(
                    recDetails.RSM_Head_Approval_Completed_Time__c.year(),
                    recDetails.RSM_Head_Approval_Completed_Time__c.month(),
                    recDetails.RSM_Head_Approval_Completed_Time__c.day()
                ),
                Time.newInstance(
                    recDetails.RSM_Head_Approval_Completed_Time__c.hour(),
                    recDetails.RSM_Head_Approval_Completed_Time__c.minute(),
                    recDetails.RSM_Head_Approval_Completed_Time__c.second(),
                    recDetails.RSM_Head_Approval_Completed_Time__c.millisecond()
                )
            );
            String userTimeZone = UserInfo.getTimeZone().getID();
            rejectionSentDateTime = dt.format('yyyy-MM-dd HH:mm:ss', 'GMT'); 
        }
        else{
            rejectionSentDateTime = ''; 
        }
        //subject
        //dynamicSubject = 'RSM Head Achieved Sales Rejection Notification';
        dynamicSubject = 'RSM Head Achieved Sales Rejection For '+recDetails.Target_Number__c+' - '+recDetails.Name+'';
        //title
        dynamicTitle = 'RSM FY '+fiscalYear+' Q'+previousQuarter+' Achieved Sales Rejection';
        //Salutation
        content1 = '<table style="border-radius: 15px;margin-top: 8px;font-size: 14px;">';
        content1 +=   	'<tr>';
        content1 +=  			'<td style="width: 24px;">';
        content1 +=  			'</td>';
        content1 += 			'<td style="padding: 0px 8px;font-family: Sans-Serif;">Dear Team,';
        content1 += 			'</td>';
        content1 += 		'</tr>';
        content1 += '</table>';
        content1 += '<table style="border-radius: 15px;margin-top: 8px;font-size: 14px;font-family: Sans-Serif;">';
        content1 +=    	'<tr>';
        content1 +=    		'<td style="width: 24px;"></td>';
        content1 += 		'<td style="padding: 0px 8px; font-family: Sans-Serif; padding-bottom: 10px;">We want to inform you that '+recDetails.RSM_Approver__c+' has rejected the FY '+fiscalYear+' Q'+previousQuarter+' Achieved Sales<b>.</b>';
        content1 +=    		' Please refer to the table displayed below for an overview of rejected Achieved Sales Summary<b>.</b>';
        content1 +=  			'</td>';
        content1 += 		'</tr>';
        content1 += '</table>';
        //Rejection comments
        content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;width:50%"><tr><td style="width: 24px;"></td><td style="padding: 8px 8px 0px 8px;font-weight:600;color:#2d2d2d;">Rejection Comments:</td></tr></table>';
        content1 += '<table style="border-radius: 15px;margin-top: 8px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding:0px 8px;font-family: Sans-Serif;">'+recDetails.RSM_Approver__c+'('+rejectionSentDateTime+') : '+(recDetails.RSM_Head_Comments__c != null ? recDetails.RSM_Head_Comments__c : '')+'</td></tr></table>';
        content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;width:50%"><tr><td style="width: 24px;"></td><td style="padding: 8px 8px 0px 8px;font-weight:600;color:#2d2d2d;">Rejected Achieved Sales Summary:</td></tr></table>';
        content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;width:50%"><tr><td style="width: 24px;"></td><td style="padding: 8px 8px 0px 8px;font-weight:600;color:#2d2d2d;">Achievement Summary of FY  '+fiscalYear+' Q'+previousQuarter+' Target Achievement Approval</td></tr></table>';
        if(previousQuarter == 1 || Test.isRunningTest())
        {
            content1 +=   ReuseQuarterDataCls.returnQuartData1();
        }    
        if(previousQuarter == 2 || Test.isRunningTest())
        {
            content1 += ReuseQuarterDataCls.returnQuartData2();
        }    
        if(previousQuarter == 3 || Test.isRunningTest())
        {
            content1 +=   ReuseQuarterDataCls.returnQuartData3();
        }    
        if(previousQuarter == 4 || Test.isRunningTest())
        {
            content1 +=    ReuseQuarterDataCls.returnQuartData4();
        }  
        content1 += '<table style="border-radius: 15px;margin-top: 8px;font-size: 14px;font-family: Sans-Serif;">';
        content1 +=   '<tr>';
        content1 +=   '<td style="width: 24px;"></td>';
        content1 +=    ' <td style="padding: 0px 8px;font-family: Sans-Serif;">';
        content1 +=      'To review the rejected FY '+fiscalYear+' Q'+previousQuarter+' Achieved Sales,refer to this link<b><a href="'+System.URL.getOrgDomainURL().toExternalForm()+'/lightning/n/SRx_Achievement_Tracker?c__tabId=3&c__recordId='+recDetails.Id+'">&nbsp;Achieved Sales Summary Hyperlink</a></b><b>.</b>';
        content1 +=            '</td>';
        content1 +=         '</tr>';
        content1 +=           '</table>'; 
        content1 +=    '</tr>';
        content1 +=    '</table>'; 
        List<String> l1 = new List<String>();
        List<String> l2 = new List<String>();
        toAddress = new List<String>();
        ccAddress = new List<String>();
        if(recDetails.RSM_Approver__c == 'Eric Sutherland'){
            toAddress.add(westRSMHeadEmail);
            ccAddress.add(eastRSMHeadEmail); 
        }
        else if(recDetails.RSM_Approver__c == 'Dave Smith'){
            toAddress.add(eastRSMHeadEmail); 
            ccAddress.add(westRSMHeadEmail);
        }
        toAddress.add(markHeadEmail);
        toAddress.add(srxHeadEmail);
        ccAddress.add('srimayeechilagani@drreddys.com');
        ccAddress.add('srimayee@dhruvsoft.com');
     //   ccAddress.add('pradeep@dhruvsoft.com');
        //  ccAddress.add('shailkmohmad@dhruvsoft.com');
        SRxAchievEmailNotifySendCls.sendEmailAlert(parentRecId, content1,toAddress,ccAddress,dynamicSubject, dynamicTitle, alterRequired);//USERS EMAIL ID's
        // SRxAchievEmailNotifySendCls.sendEmailAlert(parentRecId, content1, new List<String> {'pradeepkumarmutyala@drreddys.com','srimayee@dhruvsoft.com','shailkmohmad@dhruvsoft.com','rnaveen@dhruvsoft.com','srimayeechilagani@drreddys.com','bhavadeep.valavala@dhruvsoft.com'}, new List<String> {'naseershaik@drreddys.com','bhavadeep.valavala@dhruvsoft.com'}, dynamicSubject, dynamicTitle, alterRequired);//Testing
        // HeadApprovalEmailNotification.testMails(parentRecId, content1, l1, l2, dynamicSubject, dynamicTitle, alterRequired);
        //  SRxAchievEmailNotifySendCls.sendEmailAlert(parentRecId, content1, new List<String> {'pradeepkumarmutyala@drreddys.com','naseershaik@drreddys.com','srimayeechilagani@drreddys.com','bhavadeep.valavala@dhruvsoft.com'}, new List<String> {'naseershaik@drreddys.com','bhavadeep.valavala@dhruvsoft.com'}, dynamicSubject, dynamicTitle, alterRequired);
    }  
    public static void rsmEastHeadApprovalAchievedSalesSummaryNotify(String parentRecId,String rsmApprover){
        //    String parentRecId = 'a1FDL000007kKld2AE';
        Target_Achieved_Approval__c recDetails = [SELECT Id,Name,Target_Number__c,Intial_Approver__c,Marketing_Approver__c,Marketing_Head_Approval_Sent_Time__c,Marketing_Head_Approval_Completed_Time__c,Marketing_Head_Comments__c,RSM_Approver__c,RSM_Head_Approval_Sent_Time__c,RSM_Head_Approval_Completed_Time__c,RSM_Head_Comments__c,SRx_Approver__c,SRx_Head_Approval_Sent_Time__c,SRx_Head_Approval_Completed_Time__c,SRx_Head_Comments__c FROM Target_Achieved_Approval__c WHERE ID=:parentRecId];
        string content1 = '';
        string dynamicSubject = '';
        string dynamicTitle = ''; 
        string customerString = '';
        boolean alterRequired = false;
        DateTime createdDate;
        DateTime internalTarget; 
        DateTime rcaChangeDate;
        String targetValue;
        Integer fiscalYear;
        Integer fiscalQuarter;
        Integer previousQuarter;
        Date currentDate = Date.today();
        String authorName = '';
        if(rsmApprover == 'Eric Sutherland'){
            authorName = 'Dave Smith';
        }
        else if(rsmApprover == 'Dave Smith'){
            authorName = 'Eric Sutherland';
        }
        else{
            authorName = '';
        }
        // Set the fiscal year start month to April
        Integer fiscalYearStartMonth = 4;
        
        // Calculate fiscal year
        if (currentDate.month() >= fiscalYearStartMonth) {
            fiscalYear = currentDate.year() + 1;
        } else {
            fiscalYear = currentDate.year() - 1;
        }
        // Calculate fiscal quarter
        fiscalQuarter = ((currentDate.month() - fiscalYearStartMonth + 1) / 3) + 1;
        // Calculate fiscal quarter
        Integer calendarQuarter = ((currentDate.month() - 1) / 3) + 1;
        
        // Adjust fiscal quarter for your custom quarters
        if (calendarQuarter == 1) {
            fiscalQuarter = 4;
            previousQuarter = 3;
        } else if (calendarQuarter == 2) {
            fiscalQuarter = 1;
            previousQuarter = 4;
        } else if (calendarQuarter == 3) {
            fiscalQuarter = 2;
            previousQuarter = 1;
        } else {
            fiscalQuarter = 3;
            previousQuarter = 2;
        }   
        List<AchievementSummaryTableCls.wrapperClass> westwrapData = AchievementSummaryTableCls.getWestDirectIndirectSalesList();
        System.debug('westwrapData =====>'+JSON.serialize(westwrapData));
        List<AchievementSummaryTableCls.wrapperClass> eastwrapData = AchievementSummaryTableCls.getEastDirectIndirectSalesList();
        System.debug('eastwrapData =====>'+JSON.serialize(eastwrapData));
        //subject
        // dynamicSubject = 'RSM Achieved Sales Summary Notification';
        dynamicSubject = 'Your Approval Required For '+recDetails.Target_Number__c+' - '+recDetails.Name+' ';
        //title
        dynamicTitle = 'RSM Sales Team FY '+fiscalYear+' Q'+previousQuarter+' Achieved Sales';
        //Salutation
        content1 = '<table style="border-radius: 15px;margin-top: 8px;font-size: 14px;">';
        content1 +=   	'<tr>';
        content1 +=  			'<td style="width: 24px;">';
        content1 +=  			'</td>';
        content1 += 			'<td style="padding: 0px 8px;font-family: Sans-Serif;">Dear '+authorName+',';
        content1 += 			'</td>';
        content1 += 		'</tr>';
        content1 += '</table>';
        content1 += '<table style="border-radius: 15px;margin-top: 8px;font-size: 14px;font-family: Sans-Serif;">';
        content1 +=    	'<tr>';
        content1 +=    		'<td style="width: 24px;"></td>';
        content1 += '<td style="padding: 0px 8px; font-family: Sans-Serif; padding-bottom: 10px;">Your approval is needed for the FY '+fiscalYear+' Q'+previousQuarter+' Achieved Sales Summary, detailing the individual sales performance of our SRx Sales Team members<b>.</b>';
        content1 +=    		' Please find the sales numbers below for your review and approval<b>.</b>';
        content1 +=  			'</td>';
        content1 += 		'</tr>';
        content1 += '</table>';
        content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;width:50%"><tr><td style="width: 24px;"></td><td style="padding: 8px 8px 0px 8px;font-weight:600;color:#2d2d2d;">Achievement Summary of FY  '+fiscalYear+' Q'+previousQuarter+' Target Achievement Approval</td></tr></table>';
        if(previousQuarter == 1 || Test.isRunningTest())
        {
            content1 +=   ReuseQuarterDataCls.returnQuartData1();
        }    
        if(previousQuarter == 2 || Test.isRunningTest())
        {
            content1 += ReuseQuarterDataCls.returnQuartData2();
        }    
        if(previousQuarter == 3 || Test.isRunningTest())
        {
            content1 +=   ReuseQuarterDataCls.returnQuartData3();
        }    
        if(previousQuarter == 4 || Test.isRunningTest())
        {
            content1 +=   ReuseQuarterDataCls.returnQuartData4();
        }  
        content1 += '<table style="border-radius: 15px;margin-top: 8px;font-size: 14px;font-family: Sans-Serif;">';
        content1 +=   '<tr>';
        content1 +=   '<td style="width: 24px;"></td>';
        content1 +=    ' <td style="padding: 0px 8px;font-family: Sans-Serif;">';
        content1 +=      'To approve or reject the Achieved Sales, refer to this link<b><a href="'+System.URL.getOrgDomainURL().toExternalForm()+'/lightning/n/SRx_Achievement_Tracker?c__tabId=3&c__recordId='+recDetails.Id+'">&nbsp;'+recDetails.Name+'</a></b><b>.</b>';
        content1 +=            '</td>';
        content1 +=         '</tr>';
        content1 +=           '</table>'; 
        content1 +=    '</tr>';
        content1 +=    '</table>'; 
        List<String> l1 = new List<String>();
        List<String> l2 = new List<String>();
        toAddress = new List<String>();
        ccAddress = new List<String>();
        // ccAddress.add(markHeadEmail);
        // ccAddress.add(srxHeadEmail); 
        toAddress.add(eastRSMHeadEmail); 
        // ccAddress.add(westRSMHeadEmail); 
       // ccAddress.add('pradeep@dhruvsoft.com');
        //  ccAddress.add('shailkmohmad@dhruvsoft.com');
        ccAddress.add('srimayeechilagani@drreddys.com');
        ccAddress.add('srimayee@dhruvsoft.com');
        SRxAchievEmailNotifySendCls.sendEmailAlert(parentRecId, content1,toAddress,ccAddress,dynamicSubject, dynamicTitle, alterRequired);//USERS EMAIL ID's
        //SRxAchievEmailNotifySendCls.sendEmailAlert(parentRecId, content1, new List<String> {'pradeepkumarmutyala@drreddys.com','srimayee@dhruvsoft.com','shailkmohmad@dhruvsoft.com','rnaveen@dhruvsoft.com','srimayeechilagani@drreddys.com','bhavadeep.valavala@dhruvsoft.com'}, new List<String> {'naseershaik@drreddys.com','bhavadeep.valavala@dhruvsoft.com'}, dynamicSubject, dynamicTitle, alterRequired);//Testing
        //   HeadApprovalEmailNotification.testMails(parentRecId, content1, l1, l2, dynamicSubject, dynamicTitle, alterRequired);
        //  SRxAchievEmailNotifySendCls.sendEmailAlert(parentRecId, content1, new List<String> {'pradeepkumarmutyala@drreddys.com','naseershaik@drreddys.com','srimayeechilagani@drreddys.com','bhavadeep.valavala@dhruvsoft.com'}, new List<String> {'naseershaik@drreddys.com','bhavadeep.valavala@dhruvsoft.com'}, dynamicSubject, dynamicTitle, alterRequired);
    } 
    public static void rsmWestHeadApprovalAchievedSalesSummaryNotify(String parentRecId,String rsmApprover){
        //    String parentRecId = 'a1FDL000007kKld2AE';
        Target_Achieved_Approval__c recDetails = [SELECT Id,Name,Target_Number__c,Intial_Approver__c,Marketing_Approver__c,Marketing_Head_Approval_Sent_Time__c,Marketing_Head_Approval_Completed_Time__c,Marketing_Head_Comments__c,RSM_Approver__c,RSM_Head_Approval_Sent_Time__c,RSM_Head_Approval_Completed_Time__c,RSM_Head_Comments__c,SRx_Approver__c,SRx_Head_Approval_Sent_Time__c,SRx_Head_Approval_Completed_Time__c,SRx_Head_Comments__c FROM Target_Achieved_Approval__c WHERE ID=:parentRecId];
        string content1 = '';
        string dynamicSubject = '';
        string dynamicTitle = ''; 
        string customerString = '';
        boolean alterRequired = false;
        DateTime createdDate;
        DateTime internalTarget; 
        DateTime rcaChangeDate;
        String targetValue;
        Integer fiscalYear;
        Integer fiscalQuarter;
        Integer previousQuarter;
        Date currentDate = Date.today();
        String authorName = '';
        if(rsmApprover == 'Eric Sutherland'){
            authorName = 'Dave Smith';
        }
        else if(rsmApprover == 'Dave Smith'){
            authorName = 'Eric Sutherland';
        }
        else{
            authorName = '';
        }
        // Set the fiscal year start month to April
        Integer fiscalYearStartMonth = 4;
        // Calculate fiscal year
        if (currentDate.month() >= fiscalYearStartMonth) {
            fiscalYear = currentDate.year() + 1;
        } else {
            fiscalYear = currentDate.year() - 1;
        }
        // Calculate fiscal quarter
        fiscalQuarter = ((currentDate.month() - fiscalYearStartMonth + 1) / 3) + 1;
        // Calculate fiscal quarter
        Integer calendarQuarter = ((currentDate.month() - 1) / 3) + 1;
        // Adjust fiscal quarter for your custom quarters
        if (calendarQuarter == 1) {
            fiscalQuarter = 4;
            previousQuarter = 3;
        } else if (calendarQuarter == 2) {
            fiscalQuarter = 1;
            previousQuarter = 4;
        } else if (calendarQuarter == 3) {
            fiscalQuarter = 2;
            previousQuarter = 1;
        } else {
            fiscalQuarter = 3;
            previousQuarter = 2;
        }   
        List<AchievementSummaryTableCls.wrapperClass> westwrapData = AchievementSummaryTableCls.getWestDirectIndirectSalesList();
        System.debug('westwrapData =====>'+JSON.serialize(westwrapData));
        List<AchievementSummaryTableCls.wrapperClass> eastwrapData = AchievementSummaryTableCls.getEastDirectIndirectSalesList();
        System.debug('eastwrapData =====>'+JSON.serialize(eastwrapData));
        //subject
        // dynamicSubject = 'RSM Achieved Sales Summary Notification';
        dynamicSubject = 'Your Approval Required For '+recDetails.Target_Number__c+' - '+recDetails.Name+' ';
        //title
        dynamicTitle = 'RSM Sales Team FY '+fiscalYear+' Q'+previousQuarter+' Achieved Sales';
        //Salutation
        content1 = '<table style="border-radius: 15px;margin-top: 8px;font-size: 14px;">';
        content1 +=   	'<tr>';
        content1 +=  			'<td style="width: 24px;">';
        content1 +=  			'</td>';
        content1 += 			'<td style="padding: 0px 8px;font-family: Sans-Serif;">Dear '+authorName+',';
        content1 += 			'</td>';
        content1 += 		'</tr>';
        content1 += '</table>';
        content1 += '<table style="border-radius: 15px;margin-top: 8px;font-size: 14px;font-family: Sans-Serif;">';
        content1 +=    	'<tr>';
        content1 +=    		'<td style="width: 24px;"></td>';
        content1 += '<td style="padding: 0px 8px; font-family: Sans-Serif; padding-bottom: 10px;">Your approval is needed for the FY '+fiscalYear+' Q'+previousQuarter+' Achieved Sales Summary, detailing the individual sales performance of our SRx Sales Team members<b>.</b>';
        content1 +=    		' Please find the sales numbers below for your review and approval<b>.</b>';
        content1 +=  			'</td>';
        content1 += 		'</tr>';
        content1 += '</table>';
        content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;width:50%"><tr><td style="width: 24px;"></td><td style="padding: 8px 8px 0px 8px;font-weight:600;color:#2d2d2d;">Achievement Summary of FY  '+fiscalYear+' Q'+previousQuarter+' Target Achievement Approval</td></tr></table>';
        if(previousQuarter == 1 || Test.isRunningTest())
        {
            content1 +=  ReuseQuarterDataCls.returnQuartData1();
        }    
        if(previousQuarter == 2 || Test.isRunningTest())
        {
            content1 +=  ReuseQuarterDataCls.returnQuartData2();
        }    
        if(previousQuarter == 3 || Test.isRunningTest())
        {
            content1 +=   ReuseQuarterDataCls.returnQuartData3();
        }    
        if(previousQuarter == 4 || Test.isRunningTest())
        {
            content1 +=    ReuseQuarterDataCls.returnQuartData4();
        }  
        content1 += '<table style="border-radius: 15px;margin-top: 8px;font-size: 14px;font-family: Sans-Serif;">';
        content1 +=   '<tr>';
        content1 +=   '<td style="width: 24px;"></td>';
        content1 +=    ' <td style="padding: 0px 8px;font-family: Sans-Serif;">';
        content1 +=      'To approve or reject the Achieved Sales, refer to this link<b><a href="'+System.URL.getOrgDomainURL().toExternalForm()+'/lightning/n/SRx_Achievement_Tracker?c__tabId=3&c__recordId='+recDetails.Id+'">&nbsp;'+recDetails.Name+'</a></b><b>.</b>';
        content1 +=            '</td>';
        content1 +=         '</tr>';
        content1 +=           '</table>'; 
        content1 +=    '</tr>';
        content1 +=    '</table>'; 
        List<String> l1 = new List<String>();
        List<String> l2 = new List<String>();
        toAddress = new List<String>();
        ccAddress = new List<String>();
        //  ccAddress.add(markHeadEmail);
        //  ccAddress.add(srxHeadEmail); 
        //   ccAddress.add(eastRSMHeadEmail); 
        toAddress.add(westRSMHeadEmail);
        ccAddress.add('srimayeechilagani@drreddys.com');
        ccAddress.add('srimayee@dhruvsoft.com');
       // ccAddress.add('pradeep@dhruvsoft.com');
        SRxAchievEmailNotifySendCls.sendEmailAlert(parentRecId, content1,toAddress,ccAddress,dynamicSubject, dynamicTitle, alterRequired);//USERS EMAIL ID's
        // SRxAchievEmailNotifySendCls.sendEmailAlert(parentRecId, content1, new List<String> {'pradeepkumarmutyala@drreddys.com','srimayee@dhruvsoft.com','shailkmohmad@dhruvsoft.com','rnaveen@dhruvsoft.com','srimayeechilagani@drreddys.com','bhavadeep.valavala@dhruvsoft.com'}, new List<String> {'naseershaik@drreddys.com','bhavadeep.valavala@dhruvsoft.com'}, dynamicSubject, dynamicTitle, alterRequired);//Testing
        // HeadApprovalEmailNotification.testMails(parentRecId, content1, l1, l2, dynamicSubject, dynamicTitle, alterRequired);
        //  SRxAchievEmailNotifySendCls.sendEmailAlert(parentRecId, content1, new List<String> {'pradeepkumarmutyala@drreddys.com','naseershaik@drreddys.com','srimayeechilagani@drreddys.com','bhavadeep.valavala@dhruvsoft.com'}, new List<String> {'naseershaik@drreddys.com','bhavadeep.valavala@dhruvsoft.com'}, dynamicSubject, dynamicTitle, alterRequired);
    } 
    public static void rsmEastHeadAchievedSalesRejectionNotify(String parentRecId,String rsmApprover,String rsmHeadcomments,String rsmHeadCompletedTimestr){
        //    String parentRecId = 'a1FDL000007kKld2AE';
        Target_Achieved_Approval__c recDetails = [SELECT Id,Name,Target_Number__c,Intial_Approver__c,Marketing_Approver__c,Marketing_Head_Approval_Sent_Time__c,Marketing_Head_Approval_Completed_Time__c,Marketing_Head_Comments__c,RSM_Approver__c,RSM_Head_Approval_Sent_Time__c,RSM_Head_Approval_Completed_Time__c,RSM_Head_Comments__c,SRx_Approver__c,SRx_Head_Approval_Sent_Time__c,SRx_Head_Approval_Completed_Time__c,SRx_Head_Comments__c FROM Target_Achieved_Approval__c WHERE ID=:parentRecId];
        string content1 = '';
        string dynamicSubject = '';
        string dynamicTitle = ''; 
        string customerString = '';
        boolean alterRequired = false;
        DateTime createdDate;
        DateTime internalTarget; 
        DateTime rcaChangeDate;
        String targetValue;
        Integer fiscalYear;
        Integer fiscalQuarter;
        Integer previousQuarter;
        Date currentDate = Date.today();
        String authorName = '';
        if(rsmApprover == 'Eric Sutherland'){
            authorName = 'Dave Smith';
        }
        else if(rsmApprover == 'Dave Smith'){
            authorName = 'Eric Sutherland';
        }
        else{
            authorName = '';
        }
        // Set the fiscal year start month to April
        Integer fiscalYearStartMonth = 4;
        // Calculate fiscal year
        if (currentDate.month() >= fiscalYearStartMonth) {
            fiscalYear = currentDate.year() + 1;
        } else {
            fiscalYear = currentDate.year() - 1;
        }
        // Calculate fiscal quarter
        fiscalQuarter = ((currentDate.month() - fiscalYearStartMonth + 1) / 3) + 1;
        // Calculate fiscal quarter
        Integer calendarQuarter = ((currentDate.month() - 1) / 3) + 1;
        // Adjust fiscal quarter for your custom quarters
        if (calendarQuarter == 1) {
            fiscalQuarter = 4;
            previousQuarter = 3;
        } else if (calendarQuarter == 2) {
            fiscalQuarter = 1;
            previousQuarter = 4;
        } else if (calendarQuarter == 3) {
            fiscalQuarter = 2;
            previousQuarter = 1;
        } else {
            fiscalQuarter = 3;
            previousQuarter = 2;
        }   
        List<AchievementSummaryTableCls.wrapperClass> westwrapData = AchievementSummaryTableCls.getWestDirectIndirectSalesList();
        System.debug('westwrapData =====>'+JSON.serialize(westwrapData));
        List<AchievementSummaryTableCls.wrapperClass> eastwrapData = AchievementSummaryTableCls.getEastDirectIndirectSalesList();
        System.debug('eastwrapData =====>'+JSON.serialize(eastwrapData));
        // SRx_Target__c srxTargetparentRec = [SELECT Id,Name,Head_Target__c,Marketing_Head_Comments__c,SRx_Head_Comments__c,Marketing_Approver__c,SRx_Approver__c,Intial_Approver__c,SRx_Target__c.Marketing_Head_Approval_Completed_Time__c	FROM SRx_Target__c WHERE Id =: parentRecId ];
        // List<Sales_Reps_Targets__c> salesRepTargetChildRecs = [SELECT Id,User_Name__c,Name,Region__c,Quarter_1__c,Quarter_2__c,Quarter_3__c,Quarter_4__c,Annual__c,SRx_Target__c FROM Sales_Reps_Targets__c WHERE SRx_Target__c =: parentRecId];
        // System.debug('salesRepTargetChildRecsSize ===>'+salesRepTargetChildRecs.Size());
        // List<Sales_Reps_Targets__c> eastChildRecords = [SELECT Id,User_Name__c,Name,Region__c,Quarter_1__c,Quarter_2__c,Quarter_3__c,Quarter_4__c,Annual__c,SRx_Target__c FROM Sales_Reps_Targets__c WHERE Region__c = 'East' AND SRx_Target__c =: parentRecId];
        // List<Sales_Reps_Targets__c> westChildRecords = [SELECT Id,User_Name__c,Name,Region__c,Quarter_1__c,Quarter_2__c,Quarter_3__c,Quarter_4__c,Annual__c,SRx_Target__c FROM Sales_Reps_Targets__c WHERE Region__c = 'West'AND  SRx_Target__c =: parentRecId];
        String rejectionSentDateTime;
        if(recDetails.RSM_Head_Approval_Completed_Time__c != null)
        {
            
            DateTime dt = DateTime.newInstance(
                Date.newInstance(
                    recDetails.RSM_Head_Approval_Completed_Time__c.year(),
                    recDetails.RSM_Head_Approval_Completed_Time__c.month(),
                    recDetails.RSM_Head_Approval_Completed_Time__c.day()
                ),
                Time.newInstance(
                    recDetails.RSM_Head_Approval_Completed_Time__c.hour(),
                    recDetails.RSM_Head_Approval_Completed_Time__c.minute(),
                    recDetails.RSM_Head_Approval_Completed_Time__c.second(),
                    recDetails.RSM_Head_Approval_Completed_Time__c.millisecond()
                )
            );
            String userTimeZone = UserInfo.getTimeZone().getID();
            rejectionSentDateTime = dt.format('yyyy-MM-dd HH:mm:ss', 'GMT'); 
        }
        else{
            rejectionSentDateTime = ''; 
        }
        //subject
        //dynamicSubject = 'RSM Head Achieved Sales Rejection Notification';
        dynamicSubject = 'RSM Head Achieved Sales Rejection For '+recDetails.Target_Number__c+' - '+recDetails.Name+'';
        //title
        dynamicTitle = 'RSM FY '+fiscalYear+' Q'+previousQuarter+' Achieved Sales Rejection';
        //Salutation
        content1 = '<table style="border-radius: 15px;margin-top: 8px;font-size: 14px;">';
        content1 +=   	'<tr>';
        content1 +=  			'<td style="width: 24px;">';
        content1 +=  			'</td>';
        content1 += 			'<td style="padding: 0px 8px;font-family: Sans-Serif;">Dear '+authorName+',';
        content1 += 			'</td>';
        content1 += 		'</tr>';
        content1 += '</table>';
        content1 += '<table style="border-radius: 15px;margin-top: 8px;font-size: 14px;font-family: Sans-Serif;">';
        content1 +=    	'<tr>';
        content1 +=    		'<td style="width: 24px;"></td>';
        content1 += 		'<td style="padding: 0px 8px; font-family: Sans-Serif; padding-bottom: 10px;">We want to inform you that '+rsmApprover+' has rejected the FY '+fiscalYear+' Q'+previousQuarter+' Achieved Sales<b>.</b>';
        content1 +=    		' Please refer to the table displayed below for an overview of rejected Achieved Sales Summary<b>.</b>';
        content1 +=  			'</td>';
        content1 += 		'</tr>';
        content1 += '</table>';
        //Rejection comments
        content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;width:50%"><tr><td style="width: 24px;"></td><td style="padding: 8px 8px 0px 8px;font-weight:600;color:#2d2d2d;">Rejection Comments:</td></tr></table>';
        content1 += '<table style="border-radius: 15px;margin-top: 8px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding:0px 8px;font-family: Sans-Serif;">'+rsmApprover+'('+rsmHeadCompletedTimestr+') : '+rsmHeadcomments+'</td></tr></table>';
        content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;width:50%"><tr><td style="width: 24px;"></td><td style="padding: 8px 8px 0px 8px;font-weight:600;color:#2d2d2d;">Rejected Achieved Sales Summary:</td></tr></table>';
        content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;width:50%"><tr><td style="width: 24px;"></td><td style="padding: 8px 8px 0px 8px;font-weight:600;color:#2d2d2d;">Achievement Summary of FY  '+fiscalYear+' Q'+previousQuarter+' Target Achievement Approval</td></tr></table>';
        if(previousQuarter == 1 || Test.isRunningTest())
        {
            content1 +=  ReuseQuarterDataCls.returnQuartData1();
        }    
        if(previousQuarter == 2 || Test.isRunningTest())
        {
            content1 += ReuseQuarterDataCls.returnQuartData2();
        }    
        if(previousQuarter == 3 || Test.isRunningTest())
        {
            content1 +=   ReuseQuarterDataCls.returnQuartData3();
        }    
        if(previousQuarter == 4 || Test.isRunningTest())
        {
            content1 +=  ReuseQuarterDataCls.returnQuartData4();
        }  
        content1 += '<table style="border-radius: 15px;margin-top: 8px;font-size: 14px;font-family: Sans-Serif;">';
        content1 +=   '<tr>';
        content1 +=   '<td style="width: 24px;"></td>';
        content1 +=    ' <td style="padding: 0px 8px;font-family: Sans-Serif;">';
        content1 +=      'To review the rejected FY '+fiscalYear+' Q'+previousQuarter+' Achieved Sales, refer to this link<b><a href="'+System.URL.getOrgDomainURL().toExternalForm()+'/lightning/n/SRx_Achievement_Tracker?c__tabId=3&c__recordId='+recDetails.Id+'">&nbsp;'+recDetails.Name+'</a></b><b>.</b>';
        content1 +=            '</td>';
        content1 +=         '</tr>';
        content1 +=           '</table>'; 
        content1 +=    '</tr>';
        content1 +=    '</table>'; 
        List<String> l1 = new List<String>();
        List<String> l2 = new List<String>();
        toAddress = new List<String>();
        ccAddress = new List<String>();
        toAddress.add(markHeadEmail);
        toAddress.add(srxHeadEmail); 
        //ccAddress.add(eastRSMHeadEmail); 
        toAddress.add(westRSMHeadEmail);
        ccAddress.add('srimayeechilagani@drreddys.com');
        ccAddress.add('srimayee@dhruvsoft.com');
       // ccAddress.add('pradeep@dhruvsoft.com');
        SRxAchievEmailNotifySendCls.sendEmailAlert(parentRecId, content1,toAddress,ccAddress,dynamicSubject, dynamicTitle, alterRequired);//USERS EMAIL ID's
        //SRxAchievEmailNotifySendCls.sendEmailAlert(parentRecId, content1, new List<String> {'pradeepkumarmutyala@drreddys.com','srimayee@dhruvsoft.com','shailkmohmad@dhruvsoft.com','rnaveen@dhruvsoft.com','srimayeechilagani@drreddys.com','bhavadeep.valavala@dhruvsoft.com'}, new List<String> {'naseershaik@drreddys.com','bhavadeep.valavala@dhruvsoft.com'}, dynamicSubject, dynamicTitle, alterRequired);//Testing
        // HeadApprovalEmailNotification.testMails(parentRecId, content1, l1, l2, dynamicSubject, dynamicTitle, alterRequired);
        //  SRxAchievEmailNotifySendCls.sendEmailAlert(parentRecId, content1, new List<String> {'pradeepkumarmutyala@drreddys.com','naseershaik@drreddys.com','srimayeechilagani@drreddys.com','bhavadeep.valavala@dhruvsoft.com'}, new List<String> {'naseershaik@drreddys.com','bhavadeep.valavala@dhruvsoft.com'}, dynamicSubject, dynamicTitle, alterRequired);
    } 
    public static void rsmWestHeadAchievedSalesRejectionNotify(String parentRecId,String rsmApprover,String rsmHeadcomments,String rsmHeadCompletedTimestr){
        //  public static void rsmWestHeadAchievedSalesRejectionNotify(String parentRecId,String rsmApprover,String rsmHeadcomments,String rsmHeadCompletedTimestr)
        //    String parentRecId = 'a1FDL000007kKld2AE';
        Target_Achieved_Approval__c recDetails = [SELECT Id,Name,Target_Number__c,Intial_Approver__c,Marketing_Approver__c,Marketing_Head_Approval_Sent_Time__c,Marketing_Head_Approval_Completed_Time__c,Marketing_Head_Comments__c,RSM_Approver__c,RSM_Head_Approval_Sent_Time__c,RSM_Head_Approval_Completed_Time__c,RSM_Head_Comments__c,SRx_Approver__c,SRx_Head_Approval_Sent_Time__c,SRx_Head_Approval_Completed_Time__c,SRx_Head_Comments__c FROM Target_Achieved_Approval__c WHERE ID=:parentRecId];
        string content1 = '';
        string dynamicSubject = '';
        string dynamicTitle = ''; 
        string customerString = '';
        boolean alterRequired = false;
        DateTime createdDate;
        DateTime internalTarget; 
        DateTime rcaChangeDate;
        String targetValue;
        Integer fiscalYear;
        Integer fiscalQuarter;
        Integer previousQuarter;
        Date currentDate = Date.today();
        String authorName = '';
        if(rsmApprover == 'Eric Sutherland'){
            authorName = 'Dave Smith';
        }
        else if(rsmApprover == 'Dave Smith'){
            authorName = 'Eric Sutherland';
        }
        else{
            authorName = '';
        }
        // Set the fiscal year start month to April
        Integer fiscalYearStartMonth = 4;
        // Calculate fiscal year
        if (currentDate.month() >= fiscalYearStartMonth) {
            fiscalYear = currentDate.year() + 1;
        } else {
            fiscalYear = currentDate.year() - 1;
        }
        // Calculate fiscal quarter
        fiscalQuarter = ((currentDate.month() - fiscalYearStartMonth + 1) / 3) + 1;
        // Calculate fiscal quarter
        Integer calendarQuarter = ((currentDate.month() - 1) / 3) + 1;
        // Adjust fiscal quarter for your custom quarters
        if (calendarQuarter == 1) {
            fiscalQuarter = 4;
            previousQuarter = 3;
        } else if (calendarQuarter == 2) {
            fiscalQuarter = 1;
            previousQuarter = 4;
        } else if (calendarQuarter == 3) {
            fiscalQuarter = 2;
            previousQuarter = 1;
        } else {
            fiscalQuarter = 3;
            previousQuarter = 2;
        }   
        List<AchievementSummaryTableCls.wrapperClass> westwrapData = AchievementSummaryTableCls.getWestDirectIndirectSalesList();
        System.debug('westwrapData =====>'+JSON.serialize(westwrapData));
        List<AchievementSummaryTableCls.wrapperClass> eastwrapData = AchievementSummaryTableCls.getEastDirectIndirectSalesList();
        System.debug('eastwrapData =====>'+JSON.serialize(eastwrapData));
        // SRx_Target__c srxTargetparentRec = [SELECT Id,Name,Head_Target__c,Marketing_Head_Comments__c,SRx_Head_Comments__c,Marketing_Approver__c,SRx_Approver__c,Intial_Approver__c,SRx_Target__c.Marketing_Head_Approval_Completed_Time__c	FROM SRx_Target__c WHERE Id =: parentRecId ];
        // List<Sales_Reps_Targets__c> salesRepTargetChildRecs = [SELECT Id,User_Name__c,Name,Region__c,Quarter_1__c,Quarter_2__c,Quarter_3__c,Quarter_4__c,Annual__c,SRx_Target__c FROM Sales_Reps_Targets__c WHERE SRx_Target__c =: parentRecId];
        // System.debug('salesRepTargetChildRecsSize ===>'+salesRepTargetChildRecs.Size());
        // List<Sales_Reps_Targets__c> eastChildRecords = [SELECT Id,User_Name__c,Name,Region__c,Quarter_1__c,Quarter_2__c,Quarter_3__c,Quarter_4__c,Annual__c,SRx_Target__c FROM Sales_Reps_Targets__c WHERE Region__c = 'East' AND SRx_Target__c =: parentRecId];
        // List<Sales_Reps_Targets__c> westChildRecords = [SELECT Id,User_Name__c,Name,Region__c,Quarter_1__c,Quarter_2__c,Quarter_3__c,Quarter_4__c,Annual__c,SRx_Target__c FROM Sales_Reps_Targets__c WHERE Region__c = 'West'AND  SRx_Target__c =: parentRecId];
        String rejectionSentDateTime;
        if(recDetails.RSM_Head_Approval_Completed_Time__c != null)
        {
            DateTime dt = DateTime.newInstance(
                Date.newInstance(
                    recDetails.RSM_Head_Approval_Completed_Time__c.year(),
                    recDetails.RSM_Head_Approval_Completed_Time__c.month(),
                    recDetails.RSM_Head_Approval_Completed_Time__c.day()
                ),
                Time.newInstance(
                    recDetails.RSM_Head_Approval_Completed_Time__c.hour(),
                    recDetails.RSM_Head_Approval_Completed_Time__c.minute(),
                    recDetails.RSM_Head_Approval_Completed_Time__c.second(),
                    recDetails.RSM_Head_Approval_Completed_Time__c.millisecond()
                )
            );
            String userTimeZone = UserInfo.getTimeZone().getID();
            rejectionSentDateTime = dt.format('yyyy-MM-dd HH:mm:ss', 'GMT'); 
        }
        else{
            rejectionSentDateTime = ''; 
        }
        //subject
        //dynamicSubject = 'RSM Head Achieved Sales Rejection Notification';
        dynamicSubject = 'RSM Head Achieved Sales Rejection For '+recDetails.Target_Number__c+' - '+recDetails.Name+'';
        //title
        dynamicTitle = 'RSM FY '+fiscalYear+' Q'+previousQuarter+' Achieved Sales Rejection';
        //Salutation
        content1 = '<table style="border-radius: 15px;margin-top: 8px;font-size: 14px;">';
        content1 +=   	'<tr>';
        content1 +=  			'<td style="width: 24px;">';
        content1 +=  			'</td>';
        content1 += 			'<td style="padding: 0px 8px;font-family: Sans-Serif;">Dear Team,';
        content1 += 			'</td>';
        content1 += 		'</tr>';
        content1 += '</table>';
        content1 += '<table style="border-radius: 15px;margin-top: 8px;font-size: 14px;font-family: Sans-Serif;">';
        content1 +=    	'<tr>';
        content1 +=    		'<td style="width: 24px;"></td>';
        content1 += 		'<td style="padding: 0px 8px; font-family: Sans-Serif; padding-bottom: 10px;">We want to inform you that '+rsmApprover+' has rejected the FY '+fiscalYear+' Q'+previousQuarter+' Achieved Sales<b>.</b>';
        content1 +=    		' Please refer to the table displayed below for an overview of rejected Achieved Sales Summary<b>.</b>';
        content1 +=  			'</td>';
        content1 += 		'</tr>';
        content1 += '</table>';
        //Rejection comments
        content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;width:50%"><tr><td style="width: 24px;"></td><td style="padding: 8px 8px 0px 8px;font-weight:600;color:#2d2d2d;">Rejection Comments:</td></tr></table>';
        content1 += '<table style="border-radius: 15px;margin-top: 8px;font-size: 14px;font-family: Sans-Serif;"><tr><td style="width: 24px;"></td><td style="padding:0px 8px;font-family: Sans-Serif;">'+rsmApprover+'('+rsmHeadCompletedTimestr+') : '+rsmHeadcomments+'</td></tr></table>';
        content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;width:50%"><tr><td style="width: 24px;"></td><td style="padding: 8px 8px 0px 8px;font-weight:600;color:#2d2d2d;">Rejected Achieved Sales Summary:</td></tr></table>';
        content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;width:50%"><tr><td style="width: 24px;"></td><td style="padding: 8px 8px 0px 8px;font-weight:600;color:#2d2d2d;">Achievement Summary of FY  '+fiscalYear+' Q'+previousQuarter+' Target Achievement Approval</td></tr></table>';
        if(previousQuarter == 1 || Test.isRunningTest())
        {
            content1 +=  ReuseQuarterDataCls.returnQuartData1();
        }    
        
        if(previousQuarter == 2 || Test.isRunningTest())
        {
            content1 += ReuseQuarterDataCls.returnQuartData2();
        }    
        
        if(previousQuarter == 3 || Test.isRunningTest())
        {
            content1 +=   ReuseQuarterDataCls.returnQuartData3();
        }    
        
        if(previousQuarter == 4 || Test.isRunningTest())
        {
            content1 +=   ReuseQuarterDataCls.returnQuartData4();
        }  
        content1 += '<table style="border-radius: 15px;margin-top: 8px;font-size: 14px;font-family: Sans-Serif;">';
        content1 +=   '<tr>';
        content1 +=   '<td style="width: 24px;"></td>';
        content1 +=    ' <td style="padding: 0px 8px;font-family: Sans-Serif;">';
        content1 +=      'To review the rejected FY '+fiscalYear+' Q'+previousQuarter+' Achieved Sales, refer to this link<b><a href="'+System.URL.getOrgDomainURL().toExternalForm()+'/lightning/n/SRx_Achievement_Tracker?c__tabId=3&c__recordId='+recDetails.Id+'">&nbsp;'+recDetails.Name+'</a></b><b>.</b>';
        content1 +=            '</td>';
        content1 +=         '</tr>';
        content1 +=           '</table>'; 
        content1 +=    '</tr>';
        content1 +=    '</table>'; 
        List<String> l1 = new List<String>();
        List<String> l2 = new List<String>();
        toAddress = new List<String>();
        ccAddress = new List<String>();
        toAddress.add(markHeadEmail);
        toAddress.add(srxHeadEmail); 
        toAddress.add(eastRSMHeadEmail);
        ccAddress.add('srimayeechilagani@drreddys.com');
        ccAddress.add('srimayee@dhruvsoft.com');
        //  ccAddress.add(westRSMHeadEmail); 
     //   ccAddress.add('pradeep@dhruvsoft.com');
        //  ccAddress.add('shailkmohmad@dhruvsoft.com');
        SRxAchievEmailNotifySendCls.sendEmailAlert(parentRecId, content1,toAddress,ccAddress,dynamicSubject, dynamicTitle, alterRequired);//USERS EMAIL ID's
        // SRxAchievEmailNotifySendCls.sendEmailAlert(parentRecId, content1, new List<String> {'pradeepkumarmutyala@drreddys.com','srimayee@dhruvsoft.com','shailkmohmad@dhruvsoft.com','rnaveen@dhruvsoft.com','srimayeechilagani@drreddys.com','bhavadeep.valavala@dhruvsoft.com'}, new List<String> {'naseershaik@drreddys.com','bhavadeep.valavala@dhruvsoft.com'}, dynamicSubject, dynamicTitle, alterRequired);//Testing
        //HeadApprovalEmailNotification.testMails(parentRecId, content1, l1, l2, dynamicSubject, dynamicTitle, alterRequired);
        //  SRxAchievEmailNotifySendCls.sendEmailAlert(parentRecId, content1, new List<String> {'pradeepkumarmutyala@drreddys.com','naseershaik@drreddys.com','srimayeechilagani@drreddys.com','bhavadeep.valavala@dhruvsoft.com'}, new List<String> {'naseershaik@drreddys.com','bhavadeep.valavala@dhruvsoft.com'}, dynamicSubject, dynamicTitle, alterRequired);
    }  
    public Class WestDataWrapper{
        public String Name {get;set;} 
        public String Target {get;set;}
        public String Achieve {get;set;}
        public String PerSymbol {get;set;}
        public Decimal Percentile {get;set;}
        public String Name2 {get;set;} 
        public String Target2 {get;set;}
        public String Achieve2 {get;set;}
        public String PerSymbol2 {get;set;}
        public Decimal Percentile2 {get;set;}
        
    }
    public Class EastDataWrapper{
        public String eastName {get;set;} 
        public String eastTarget {get;set;}
        public String eastAchieve {get;set;}
        public String eastPerSymbol {get;set;}
        public Decimal eastPercentile {get;set;}
        
    }
}