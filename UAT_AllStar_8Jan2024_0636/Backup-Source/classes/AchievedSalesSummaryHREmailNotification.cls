public class AchievedSalesSummaryHREmailNotification {
    
    public AchievedSalesSummaryHREmailNotification() {
        String recId =  ApexPages.currentPage().getParameters().get('id');
        targetAchievedApprovalTableData(recId);
        achievedTargetData(recId);
    }
    
    public AchievedSalesSummaryHREmailNotification(String recId) {
        targetAchievedApprovalTableData(recId);
        achievedTargetData(recId);
    }
    
    public static List<DataWrapper>westWrapList {get;set;}
    public static List<DataWrapper>eastWrapList {get;set;}
    public List<Target_Achieved_Approval__c> recDetails2 {get;set;}
    public static String daveEmployeeId {get;set;}{daveEmployeeId = 'P00075889';}
    public static String ericEmployeeId {get;set;}{ericEmployeeId = '';}
    public static String daveSmith {get;set;}{daveSmith = 'Dave Smith';}
    public static String ericSutherLand {get;set;}{ericSutherLand = 'Eric SutherLand';}
    public static String markHeadEmail = System.Label.Marketing_Head_Email;     
    public static String srxHeadEmail = System.Label.SRx_Head_Email_Id;
    public static String eastRSMHeadEmail = System.Label.RSM_East_Head_Email_Id;
    public static String westRSMHeadEmail = System.Label.RSM_West_Head_Email_Id;
    public static List<AchievementSummaryTableCls.wrapperClass> westwrapData{get;set;}
    public static List<AchievementSummaryTableCls.wrapperClass> eastwrapData{get;set;}
    public static Map<String,String> quarterUsersMap = new Map<String,String>();
    public static String emails = System.Label.AchievedSalesRepEmailIds;
    public static List<String> teamEmails = new List<String>(emails.split(','));
    public static List<User> usersList = [SELECT Id, Name, EmployeeNumber,Email FROM User WHERE Email IN :teamEmails];
    public static String employeeId = '';
    public static Blob csvBody {get;set;}
    public static String recId {get;set;}
    public static Blob csvBlob {get;set;}
    public static String csvname {get;set;}
    public static String pdfname {get;set;}
    public static String dynamicSubject {get;set;}
    
    public static String content1 ;
    public static list<String> l1;
    public static list<String> l2;
    
    public static Messaging.EmailFileAttachment csvAttc{get;set;}
    public static List<Target_Achieved_Approval__c> recDetails {get;set;}
    public string ids {
        get;
        set;
    }
    Static {
        westwrapData = AchievementSummaryTableCls.getWestDirectIndirectSalesList();
        eastwrapData = AchievementSummaryTableCls.getEastDirectIndirectSalesList();
    }
    
    public static List<Target_Achieved_Approval__c> targetAchievedApprovalTableData(String parentRecId2){
        recDetails = [SELECT Id, Name,RSM_Head_Status__c,RSM_Head_Comments__c,RSM_Head_Approval_Sent_Time_String__c,RSM_Head_Approval_Sent_Time__c,RSM_Head_Approval_Completed_Time_String__c,
                      RSM_Head_Approval_Completed_Time__c,RSM_Approver__c, Approval_Status__c, Financial_Year__c, Marketing_Approver__c,Intial_Approver__c,SRx_Approver__c,
                      Initiator_Status__c, SRx_Head_Status__c, Marketing_Head_Status__c, SRx_Head_Comments__c, Marketing_Head_Comments__c,
                      Initiator_Approval_Sent_Time_String__c,Initiator_Approval_Completed_Time_String__c,Initiator_Approval_Completed_Time__c,Initiator_Head_Comments__c,Marketing_Head_Approval_Completed_Str__c,
                      Marketing_Head_Approval_Completed_Time__c,Marketing_Head_Approval_Sent_Time_String__c,Marketing_Head_Approval_Sent_Time__c,SRx_Head_Approval_Completed_Time_String__c,
                      SRx_Head_Approval_Completed_Time__c,SRx_Head_Approval_Sent_Time_String__c,SRx_Head_Approval_Sent_Time__c,
                      RSM_West_Head_Status__c,RSM_West_Head_Comments__c,RSM_West_Head_Approval_Sent_Time__c,RSM_West_Approver__c,RSM_West_Approval_Sent_Time_String__c,RSM_West_Approval_Completed_Time_String__c,RSM_West_Approval_Completed_Time__c FROM Target_Achieved_Approval__c where Id =: parentRecId2 ];
        
        return recDetails;        
    } 
    public static String conversion(Decimal num) {
        String formattedAnnual;
        
        if (num >= 1000000) {
            Decimal roundedValue = num / 1000000;
            formattedAnnual = '$' + roundedValue.setScale(1, System.RoundingMode.HALF_UP).toPlainString() + 'M';
        } else if (num >= 1000) {
            Decimal roundedValue = num / 1000;
            formattedAnnual = '$' + roundedValue.setScale(1, System.RoundingMode.HALF_UP).toPlainString() + 'k';
            // Remove trailing ".0"
            formattedAnnual = formattedAnnual.replace('.0k', 'k');
        } else if (num >= 0 && num < 1000) {
            formattedAnnual = '$' + String.valueOf(num.setScale(0, System.RoundingMode.HALF_UP));
        } else if (num == null) {
            formattedAnnual = ' ';
        } else {
            System.debug('null');
            formattedAnnual = ' ';
        }
        
        System.debug('formattedAnnual =========>' + formattedAnnual);
        return formattedAnnual;
    }

public static String getCurrencyFormatted(Decimal value){
        String formattedCurrency = '';
        if(value != null && value < 0){
            String tempFormattedCurrency = value.format();
            List<String> splittedData = tempFormattedCurrency.split('-');
            formattedCurrency = '-$' + splittedData[1]; 
        } else if(value != null && value >= 0){
            formattedCurrency = '$' + value.format();
        }   
        return formattedCurrency;
    }
    
    public static void achievedTargetData(String parentRecId){
        DataWrapper Wrapper = new DataWrapper();
        String columnDivider = ',';
        String head2 = 'Hello';
        String daveRecordString;
        String ericRecordString;
        //String csvColumnHeader1 = 'SRx Team,FY Quarter 3\n';
        String csvColumnHeader2 = 'SRx Team West,Employee ID,Target,Achieved,%\n';
        String csvColumnHeader3 = 'SRx Team East,Employee ID,Target,Achieved,%\n';
        String csvcolumnHeader4 = 'S NO.,SUBMISSION STATUS,APPROVER,APPROVAL SENT TIME,APPROVAL COMPLETED TIME,COMMENTS\n';
        string finalstr =  csvColumnHeader2;
        String finalstr2 = csvColumnHeader3;
        String finalstr1 = csvColumnHeader4;
        String recordString;
        String recordString2;
        String recordString3;
        String recordStringmultiples;
        String sno0 = '0';
        String sno1 = '1';
        String sno2 = '2';
        String sno3 = '3';
        String sno4 = '4';
        content1 = '';
        String content2 = '';
        dynamicSubject = '';
        String dynamicTitle = ''; 
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
        
        
        Target_Achieved_Approval__c recDetails2 = [SELECT Id, Name,RSM_Head_Status__c,RSM_Head_Comments__c,RSM_Head_Approval_Sent_Time_String__c,RSM_Head_Approval_Sent_Time__c,RSM_Head_Approval_Completed_Time_String__c,
                                                   RSM_Head_Approval_Completed_Time__c,RSM_Approver__c, Approval_Status__c, Financial_Year__c, Marketing_Approver__c,Intial_Approver__c,SRx_Approver__c,
                                                   Initiator_Status__c, SRx_Head_Status__c, Marketing_Head_Status__c, SRx_Head_Comments__c, Marketing_Head_Comments__c,
                                                   Initiator_Approval_Sent_Time_String__c,Initiator_Approval_Completed_Time_String__c,Initiator_Approval_Completed_Time__c,Initiator_Head_Comments__c,Marketing_Head_Approval_Completed_Str__c,
                                                   Marketing_Head_Approval_Completed_Time__c,Marketing_Head_Approval_Sent_Time_String__c,Marketing_Head_Approval_Sent_Time__c,SRx_Head_Approval_Completed_Time_String__c,
                                                   SRx_Head_Approval_Completed_Time__c,SRx_Head_Approval_Sent_Time_String__c,SRx_Head_Approval_Sent_Time__c,
                                                   RSM_West_Head_Status__c,RSM_West_Head_Comments__c,RSM_West_Head_Approval_Sent_Time__c,RSM_West_Approver__c,RSM_West_Approval_Sent_Time_String__c,RSM_West_Approval_Completed_Time_String__c,RSM_West_Approval_Completed_Time__c FROM Target_Achieved_Approval__c where Id =: parentRecId ];
        //subject
        dynamicSubject = 'Achieved Sales Summary HR';
        //title
        dynamicTitle = 'SRx Sales Team Q'+previousQuarter+' Achieved Sales';
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
        content1 += '<td style="padding: 0px 8px; font-family: Sans-Serif; padding-bottom: 10px;">We want to inform you of the Achieved Sales Summary by each Sales Team member for the FY ' + fiscalYear + ' Quarter ' + previousQuarter + '<b>.</b>';
        content1 +=    		' Please refer to the tables displayed below for an overview of the Achieved Sales percentages to calculate appropriate bonuses for this quarter<b>.</b>';
        content1 +=  			'</td>';
        content1 += 		'</tr>';
        content1 += '</table>';
        content1 += '<table style="border-radius: 15px;font-size: 14px;font-family: Sans-Serif;width:50%"><tr><td style="width: 24px;"></td><td style="padding: 8px 8px 0px 8px;font-weight:600;color:#2d2d2d;">Achievement Summary of FY  '+fiscalYear+' Q'+previousQuarter+' Target Achievement Approval</td></tr></table>';
       if(previousQuarter == 1 || Test.isRunningTest()){
            // Table container start
            content1 += '<table style="width: 100%;margin-left:auto;margin-right:auto;border-radius: 15px;font-size: 14px;font-family: Sans-Serif;">';
            content1 +=  '<tr><td style="width:42%;">';   //left table start                         
            content1 += '<table align="left" style="width: 100%;margin-left:auto;margin-right:auto;border-collapse: collapse;padding:4px;font-size: 14px;font-family: Sans-Serif;">';
            content1 +=  '<thead>';
            content1 +=  '<tr>';
            content1 +=  '<tr>';
            content1 +=  '<th style="width: 36px;height: 20px;"></th>';
            content1 +=  '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-left:1px solid;border-right: 1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;background-color:#D0C7E9;">SRx Team West</th>';
            content1 += '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;background-color:#D0C7E9;">Employee Id</th>';
            content1 += '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;background-color:#D0C7E9;">Target</th>';
            content1 += '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;background-color:#D0C7E9;">Achieved</th>';
            content1 += '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-right: 1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;background-color:#D0C7E9;">%</th>';
            content1 += '</tr></thead>';
            String westCSV;
            String targetCSV;
            String achivedCSV;
            String percentCSV;
            westWrapList = new List<DataWrapper>();
            for (AchievementSummaryTableCls.wrapperClass lineItem: westwrapData) {
                DataWrapper westWrap = new DataWrapper();
                if(lineItem.salesRepName != null){
                    westCSV = (lineItem.salesRepName).replaceAll(',', '');
                }
                else{
                    westCSV = '';
                }
                String colorStyle;
                Decimal quarter_one_Target = lineItem.quarter_one_Target;
                Decimal quarter_one_Achieved = lineItem.quarter_one_Achieved;
                Decimal percentData;
                percentData =  percentCalculate(quarter_one_Achieved,quarter_one_Target);
                percentData = percentData.setScale(0);
                if(percentData > 90){
                    colorStyle  = 'color:green;color:#579857;';  
                }
                else if(percentData > 50 && percentData < 90 ){
                    colorStyle  = 'color:blue;color:#5072F1;';  
                }
                else{
                    colorStyle  = 'color:red;color:#EB4747;';    
                }
                String formattedQuarter1target;
                Decimal quart1tar;
                quart1tar = lineItem.quarter_one_Target;
                formattedQuarter1target =  conversion(quart1tar);
                String formattedQuarter1achieved;
                Decimal quart1ach;
                quart1ach = lineItem.quarter_one_Achieved;
                formattedQuarter1achieved =  conversion(quart1ach);
                Integer quarterOneTargetInteger = reduceDecimal(lineItem.quarter_one_Target);
                String formattedQuarter1targetUS = getCurrencyFormatted(lineItem.quarter_one_Target);
                String trimmedQuarter1target = '$' + quarterOneTargetInteger;
                Integer quarterOneAchievedInteger = reduceDecimal(lineItem.quarter_one_Achieved);
                String formattedQuarter1achievedUS = getCurrencyFormatted(lineItem.quarter_one_Achieved);
                String trimmedQuarter1achieved = '$' + quarterOneAchievedInteger;
                String employeeeId = employeeDetails(lineItem.salesRepEmailId);
                content1 += '<tbody>';
                content1 += '<tr ><td style="width: 26px;height: 20px;"></td><td style="height: 20px;padding: 8px;border-right:1px solid;border-left:1px solid;border-top:1px solid;border-bottom:1px solid;border-color:#ddd;text-align:left;">'+lineItem.salesRepName+'</td>';
                content1 += '<td style="height: 20px;padding: 8px;border-bottom:1px solid #ddd;border-color:#ddd;text-align:center;">'+employeeeId+'</td>';
                content1 += '<td style="height: 20px;padding: 8px;border-bottom:1px solid #ddd;border-color:#ddd;text-align:center;">'+formattedQuarter1targetUS+'</td>';
                content1 += '<td style="height: 20px;padding: 8px;border-bottom:1px solid #ddd;border-color:#ddd;text-align:center;">'+formattedQuarter1achievedUS+'</td>';
                content1 += '<td style="height: 20px;padding: 8px;border-bottom:1px solid #ddd;border-color:#ddd;text-align:center;border-right : 1px solid #ddd;'+colorStyle+'">'+percentData+'%</td>';  
                westWrap.westName = lineItem.salesRepName;
                westWrap.westTarget = formattedQuarter1target;
                westWrap.westAchieve = formattedQuarter1achieved;
                westWrap.westPercentile = percentData;
                westWrap.westPerSymbol = String.valueOf(percentData)+'%';
                westWrap.westEmployeeId = lineItem.empId;
                westWrapList.add(westWrap);
                recordString = westCSV +','+employeeeId+','+trimmedQuarter1target+','+trimmedQuarter1achieved+','+percentData+'\n';
                finalstr += recordString;
            }
            content1 += '</tbody></table>';
            content1 += '</td>'; // Close the left table cell      
            content1 += '<td style="width:42%;">';
            content1 += '<table align="left" style="width: 100%;margin-left:auto;margin-right:auto;border-collapse: collapse;padding:4px;font-size: 14px;font-family: Sans-Serif;">';
            content1 +=  '<thead>';
            content1 +=  '<tr>';
            content1 +=  '<th style="width: 36px;height: 20px;"></th>';
            content1 +=  '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-left:1px solid;border-right: 1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;background-color:#D0C7E9;">SRx Team East</th>';
            content1 += '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;background-color:#D0C7E9;">Employee Id</th>';
            content1 += '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;background-color:#D0C7E9;">Target</th>';
            content1 += '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;background-color:#D0C7E9;">Achieved</th>';
            content1 += '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-right: 1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;background-color:#D0C7E9;">%</th>';
            content1 += '</tr></thead>';
            String eastCSV;
            String easttargetCSV;
            String eastachivedCSV;
            String eastpercentCSV;
            eastWrapList = new List<DataWrapper>();
            for (AchievementSummaryTableCls.wrapperClass lineItem: eastwrapData) {
                DataWrapper eastWrap = new DataWrapper();
                 String colorStyle;
                Decimal quarter_one_Target = lineItem.quarter_one_Target;
                Decimal quarter_one_Achieved = lineItem.quarter_one_Achieved;
                Decimal percentData;
                percentData =  percentCalculate(quarter_one_Achieved,quarter_one_Target);
                percentData = percentData.setScale(0);
                if(percentData > 90){
                    colorStyle  = 'color:green;color:#579857;';  
                }
                else if(percentData > 50 && percentData < 90 ){
                    colorStyle  = 'color:blue;color:#5072F1;';  
                }
                else{
                    colorStyle  = 'color:red;color:#EB4747;';    
                }
                String formattedQuarter1target;
                Decimal quart1tar;
                quart1tar = lineItem.quarter_one_Target;
                formattedQuarter1target =  conversion(quart1tar);
                String formattedQuarter1achieved;
                Decimal quart1ach;
                quart1ach = lineItem.quarter_one_Achieved;
                formattedQuarter1achieved =  conversion(quart1ach);
                Integer quarterOneTargetInteger = reduceDecimal(lineItem.quarter_one_Target);
                String formattedQuarter1targetUS = getCurrencyFormatted(lineItem.quarter_one_Target);
                String trimmedQuarter1target = '$' + quarterOneTargetInteger;
                Integer quarterOneAchievedInteger = reduceDecimal(lineItem.quarter_one_Achieved);
                String formattedQuarter1achievedUS = getCurrencyFormatted(lineItem.quarter_one_Achieved);
                String trimmedQuarter1achieved = '$' + quarterOneAchievedInteger;
                String employeeeId = employeeDetails(lineItem.salesRepEmailId);         
                content1 += '<tbody>';
                content1 += '<tr ><td style="width: 26px;height: 20px;"></td><td style="height: 20px;padding: 8px;border-right:1px solid;border-left:1px solid;border-top:1px solid;border-bottom:1px solid;border-color:#ddd;text-align:left;">'+lineItem.salesRepName+'</td>';
                content1 += '<td style="height: 20px;padding: 8px;border-bottom:1px solid #ddd;border-color:#ddd;text-align:center;">'+employeeeId+'</td>';
                content1 += '<td style="height: 20px;padding: 8px;border-bottom:1px solid #ddd;border-color:#ddd;text-align:center;">'+formattedQuarter1targetUS+'</td>';
                content1 += '<td style="height: 20px;padding: 8px;border-bottom:1px solid #ddd;border-color:#ddd;text-align:center;">'+formattedQuarter1achievedUS+'</td>';
                content1 += '<td style="height: 20px;padding: 8px;border-bottom:1px solid #ddd;border-color:#ddd;text-align:center;border-right : 1px solid #ddd;'+colorStyle+'">'+percentData+'%</td>';  
                eastWrap.eastName = lineItem.salesRepName;
                eastWrap.eastTarget = formattedQuarter1target;
                eastWrap.eastAchieve = formattedQuarter1achieved;
                eastWrap.eastPercentile = percentData;
                eastWrap.eastPerSymbol = String.valueOf(percentData)+'%';
                eastWrap.eastEmployeeId = lineItem.empId;
                eastWrapList.add(eastWrap);
                recordString2 = lineItem.salesRepName+','+employeeeId+','+trimmedQuarter1target+','+trimmedQuarter1achieved+','+percentData+'\n';
                finalstr2 += recordString2;
            }
            recordString3 = sno0 + ',' + 'Initial Submission' + ',' + recDetails2.Intial_Approver__c + ',' +
                recDetails2.Initiator_Approval_Sent_Time_String__c + ',' + recDetails2.Initiator_Approval_Completed_Time_String__c + ',' +
                (String.isBlank(recDetails2.Initiator_Head_Comments__c) ? '' : recDetails2.Initiator_Head_Comments__c) + ',' + '\n' +
                sno1 + ',' + 'East RSM' + ',' + recDetails2.RSM_Approver__c + ',' +
                recDetails2.RSM_Head_Approval_Sent_Time_String__c + ',' + recDetails2.RSM_Head_Approval_Completed_Time_String__c + ',' +
                (String.isBlank(recDetails2.RSM_Head_Comments__c) ? '' : recDetails2.RSM_Head_Comments__c) + ',' + '\n' +
                sno2 + ',' + 'West RSM' + ',' + recDetails2.RSM_West_Approver__c + ',' +
                recDetails2.RSM_West_Approval_Sent_Time_String__c + ',' + recDetails2.RSM_West_Approval_Completed_Time_String__c + ',' +
                (String.isBlank(recDetails2.RSM_West_Head_Comments__c) ? '' : recDetails2.RSM_West_Head_Comments__c) + ',' + '\n' +
                sno3 + ',' + 'SRx Head' + ',' + 'Automatic BRIGHT' + ',' +
                recDetails2.SRx_Head_Approval_Sent_Time_String__c + ',' + recDetails2.SRx_Head_Approval_Completed_Time_String__c + ',' +
                (String.isBlank(recDetails2.SRx_Head_Comments__c) ? '' : recDetails2.SRx_Head_Comments__c) + ',' + '\n' +
                sno4 + ',' + 'Marketing Head' + ',' + recDetails2.Marketing_Approver__c + ',' +
                recDetails2.Marketing_Head_Approval_Sent_Time_String__c + ',' + recDetails2.Marketing_Head_Approval_Completed_Str__c + ',' +
                (String.isBlank(recDetails2.Marketing_Head_Comments__c) ? '' : recDetails2.Marketing_Head_Comments__c) + ',' + '\n';
            finalstr1 += recordString3;
            recordStringmultiples = finalstr1+'\n'+ finalstr+'\n'+finalstr2;
            content1 += '</tbody></table>';
            content1 += '</td>'; // Close the left table cell      
            content1 += '<td style="width:16%;"></td>';
            content1 += '<table align="left" style="width: 100%;margin-left:auto;margin-right:auto;border-collapse: collapse;padding:4px;font-size: 14px;font-family: Sans-Serif;">';
            content1 += '</table>';
            content1 += '</tr></table>';
        }    
        if(previousQuarter == 2 || Test.isRunningTest()){
            // Table container start
            content1 += '<table style="width: 100%;margin-left:auto;margin-right:auto;border-radius: 15px;font-size: 14px;font-family: Sans-Serif;">';
            content1 +=  '<tr><td style="width:42%;">';   //left table start                         
            content1 += '<table align="left" style="width: 100%;margin-left:auto;margin-right:auto;border-collapse: collapse;padding:4px;font-size: 14px;font-family: Sans-Serif;">';
            content1 +=  '<thead>';
            content1 +=  '<tr>';
            /*  content1 +=  '<th style="width: 36px;height: 20px;"></th>';
content1 +=  '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-left:1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;background-color:#D0C7E9;">SRx Team</th>';
content1 +=  '<th colspan="3" style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-right:1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;background-color:#D0C7E9;">FY 24 Quarter 2</th>';
content1 +=  '</tr>';*/
            content1 +=  '<tr>';
            content1 +=  '<th style="width: 36px;height: 20px;"></th>';
            content1 +=  '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-left:1px solid;border-right: 1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;background-color:#D0C7E9;">SRx Team West</th>';
            content1 += '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;background-color:#D0C7E9;">Employee Id</th>';
            content1 += '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;background-color:#D0C7E9;">Target</th>';
            content1 += '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;background-color:#D0C7E9;">Achieved</th>';
            content1 += '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-right: 1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;background-color:#D0C7E9;">%</th>';
            content1 += '</tr></thead>';
            //  content1 +=  '<tr>';
            /*    String colorStylehead;
Decimal quarter_Total_Target = westDaveWrapData.q2target;
Decimal quarter_Total_Achieved = westDaveWrapData.q2total;
Decimal percentDataTotal;
percentDataTotal =  percentCalculate(quarter_Total_Achieved,quarter_Total_Target);
percentDataTotal = percentDataTotal.setScale(0);
if(percentDataTotal > 90){
colorStylehead  = 'color:green;color:#579857;';  
}
else if(percentDataTotal > 50 && percentDataTotal < 90 ){
colorStylehead  = 'color:blue;color:#5072F1;';  
}
else{
colorStylehead  = 'color:red;color:#EB4747;';    
}
String formattedQuarterfinaltarget;
formattedQuarterfinaltarget =  conversion(quarter_Total_Target);
String formattedQuarterfinalachieved;
formattedQuarterfinalachieved =  conversion(quarter_Total_Achieved);*/
            /*       content1 += '<tr>';
content1 += '<td style="width: 26px;height: 20px;"></td><td style="height: 20px;padding: 8px;border-right:1px solid;border-left:1px solid;border-top:1px solid;border-bottom:1px solid;border-color:#ddd;text-align:left;">'+daveSmith+'</td>';
content1 += '<td style="height: 20px;padding: 8px;border-bottom:1px solid #ddd;border-color:#ddd;text-align:center;">'+daveEmployeeId+'</td>';
content1 += '<td style="height: 20px;padding: 8px;border-bottom:1px solid #ddd;border-color:#ddd;text-align:center;">'+daveWrapperDataQ2[0].formattedQuarterfinaltarget+'</td>';
content1 += '<td style="height: 20px;padding: 8px;border-bottom:1px solid #ddd;border-color:#ddd;text-align:center;">'+daveWrapperDataQ2[0].formattedQuarterfinalachieved+'</td>';
content1 += '<td style="height: 20px;padding: 8px;border-bottom:1px solid #ddd;border-color:#ddd;text-align:center;border-right : 1px solid #ddd;'+daveWrapperDataQ2[0].colorHead+'">'+daveWrapperDataQ2[0].formattedQuarterfinalpercent+'</td>';
content1 += '</tr>';
daveRecordString = daveSmith + ',' + daveEmployeeId + ',' + daveWrapperDataQ2[0].formattedQuarterfinaltarget + ',' + daveWrapperDataQ2[0].formattedQuarterfinalachieved + ',' + daveWrapperDataQ2[0].formattedQuarterfinalpercent.removeEnd('%') + ',' +' \n'; // continue with other values
finalstr += daveRecordString;*/
            //   content1 += '</tr>;
            //integer i = 1;
            String westCSV;
            String targetCSV;
            String achivedCSV;
            String percentCSV;
            westWrapList = new List<DataWrapper>();
            for (AchievementSummaryTableCls.wrapperClass lineItem: westwrapData) {
                DataWrapper westWrap = new DataWrapper();
                if(lineItem.salesRepName != null){
                    westCSV = (lineItem.salesRepName).replaceAll(',', '');
                }
                else{
                    westCSV = '';
                }
                String colorStyle;
                Decimal quarter_Two_Target = lineItem.quarter_Two_Target;
                //DaveTarget += quarter_Two_Target;
                Decimal quarter_two_Achieved = lineItem.quarter_two_Achieved;
                Decimal percentData;
                percentData =  percentCalculate(quarter_two_Achieved,quarter_Two_Target);
                percentData = percentData.setScale(0);
                if(percentData > 90){
                    colorStyle  = 'color:green;color:#579857;';  
                }
                else if(percentData > 50 && percentData < 90 ){
                    colorStyle  = 'color:blue;color:#5072F1;';  
                }
                else{
                    colorStyle  = 'color:red;color:#EB4747;';    
                }
               // String formattedQuarter2targetUS;
                String formattedQuarter2target;
                Decimal quart2tar;
                quart2tar = lineItem.quarter_Two_Target;
                formattedQuarter2target =  conversion(quart2tar);
               // formattedQuarter2targetUS = getCurrencyFormatted(Decimal.valueOf(formattedQuarter2target));
                String formattedQuarter2achieved;
                Decimal quart2ach;
                quart2ach = lineItem.quarter_two_Achieved;
                formattedQuarter2achieved =  conversion(quart2ach);
                /*   String empId = '';
if(String.isBlank(lineItem.empId)){
lineItem.empId = '';  
}
*/
                Integer quarterTwoTargetInteger = reduceDecimal(lineItem.quarter_Two_Target);
                String formattedQuarter2targetUS = getCurrencyFormatted(lineItem.quarter_Two_Target);
                String trimmedQuarter2target = '$' + quarterTwoTargetInteger;
                Integer quarterTwoAchievedInteger = reduceDecimal(lineItem.quarter_two_Achieved);
                String formattedQuarter2achievedUS = getCurrencyFormatted(lineItem.quarter_Two_Target);
                String trimmedQuarter2achieved = '$' + quarterTwoTargetInteger;
                String employeeeId = employeeDetails(lineItem.salesRepEmailId);
                content1 += '<tbody>';
                content1 += '<tr ><td style="width: 26px;height: 20px;"></td><td style="height: 20px;padding: 8px;border-right:1px solid;border-left:1px solid;border-top:1px solid;border-bottom:1px solid;border-color:#ddd;text-align:left;">'+lineItem.salesRepName+'</td>';
                content1 += '<td style="height: 20px;padding: 8px;border-bottom:1px solid #ddd;border-color:#ddd;text-align:center;">'+employeeeId+'</td>';
                content1 += '<td style="height: 20px;padding: 8px;border-bottom:1px solid #ddd;border-color:#ddd;text-align:center;">'+formattedQuarter2targetUS+'</td>';
                content1 += '<td style="height: 20px;padding: 8px;border-bottom:1px solid #ddd;border-color:#ddd;text-align:center;">'+formattedQuarter2achievedUS+'</td>';
                content1 += '<td style="height: 20px;padding: 8px;border-bottom:1px solid #ddd;border-color:#ddd;text-align:center;border-right : 1px solid #ddd;'+colorStyle+'">'+percentData+'%</td>';  
                westWrap.westName = lineItem.salesRepName;
                westWrap.westTarget = formattedQuarter2target;
                westWrap.westAchieve = formattedQuarter2achieved;
                westWrap.westPercentile = percentData;
                westWrap.westPerSymbol = String.valueOf(percentData)+'%';
                westWrap.westEmployeeId = lineItem.empId;
                westWrapList.add(westWrap);
                recordString = westCSV +','+employeeeId+','+trimmedQuarter2target+','+trimmedQuarter2achieved+','+percentData+'\n';
                finalstr += recordString;
            }
            content1 += '</tbody></table>';
            content1 += '</td>'; // Close the left table cell      
            content1 += '<td style="width:42%;">';
            content1 += '<table align="left" style="width: 100%;margin-left:auto;margin-right:auto;border-collapse: collapse;padding:4px;font-size: 14px;font-family: Sans-Serif;">';
            content1 +=  '<thead>';
            /*     content1 +=  '<tr>';
content1 +=  '<th style="width: 36px;height: 20px;"></th>';
content1 +=  '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-left:1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;background-color:#D0C7E9;">SRx Team</th>';
content1 +=  '<th colspan="3" style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-right:1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;background-color:#D0C7E9;">FY 24 Quarter 2</th>';
content1 +=  '</tr>';*/
            content1 +=  '<tr>';
            content1 +=  '<th style="width: 36px;height: 20px;"></th>';
            content1 +=  '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-left:1px solid;border-right: 1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;background-color:#D0C7E9;">SRx Team East</th>';
            content1 += '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;background-color:#D0C7E9;">Employee Id</th>';
            content1 += '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;background-color:#D0C7E9;">Target</th>';
            content1 += '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;background-color:#D0C7E9;">Achieved</th>';
            content1 += '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-right: 1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;background-color:#D0C7E9;">%</th>';
            content1 += '</tr></thead>';
            /*    content1 += '<tr>';
content1 += '<td style="width: 26px;height: 20px;"></td><td style="height: 20px;padding: 8px;border-right:1px solid;border-left:1px solid;border-top:1px solid;border-bottom:1px solid;border-color:#ddd;text-align:left;">'+ericSutherLand+'</td>';
content1 += '<td style="height: 20px;padding: 8px;border-bottom:1px solid #ddd;border-color:#ddd;text-align:center;">'+ericEmployeeId+'</td>';
content1 += '<td style="height: 20px;padding: 8px;border-bottom:1px solid #ddd;border-color:#ddd;text-align:center;">'+ericWrapperDataQ2[0].formattedQuarterfinaltarget+'</td>';
content1 += '<td style="height: 20px;padding: 8px;border-bottom:1px solid #ddd;border-color:#ddd;text-align:center;">'+ericWrapperDataQ2[0].formattedQuarterfinalachieved+'</td>';
content1 += '<td style="height: 20px;padding: 8px;border-bottom:1px solid #ddd;border-color:#ddd;text-align:center;border-right : 1px solid #ddd;'+ericWrapperDataQ2[0].colorHead+'">'+ericWrapperDataQ2[0].formattedQuarterfinalpercent+'</td>';
content1 += '</tr>';
ericRecordString = ericSutherLand + ',' + ericEmployeeId + ',' + ericWrapperDataQ2[0].formattedQuarterfinaltarget + ',' + ericWrapperDataQ2[0].formattedQuarterfinalachieved + ',' + ericWrapperDataQ2[0].formattedQuarterfinalpercent.removeEnd('%') + ',' +' \n'; // continue with other values
finalstr += ericRecordString;*/
            //integer i = 1;
            String eastCSV;
            String easttargetCSV;
            String eastachivedCSV;
            String eastpercentCSV;
            eastWrapList = new List<DataWrapper>();
            for (AchievementSummaryTableCls.wrapperClass lineItem: eastwrapData) {
                DataWrapper eastWrap = new DataWrapper();
                String colorStyle;
                Decimal quarter_Two_Target = lineItem.quarter_Two_Target;
                Decimal quarter_two_Achieved = lineItem.quarter_two_Achieved;
                Decimal percentData;
                percentData =  percentCalculate(quarter_two_Achieved,quarter_Two_Target);
                percentData = percentData.setScale(0);
                if(percentData > 90){
                    colorStyle  = 'color:green;color:#579857;';  
                }
                else if(percentData > 50 && percentData < 90 ){
                    colorStyle  = 'color:blue;color:#5072F1;';  
                }
                else{
                    colorStyle  = 'color:red;color:#EB4747;';    
                }
                
                if(String.isBlank(lineItem.empId)){
                    lineItem.empId = '';  
                }
                String formattedQuarter2target;
                Decimal quart2tar;
                quart2tar = lineItem.quarter_Two_Target;
                formattedQuarter2target =  conversion(quart2tar);
                String formattedQuarter2achieved;
                Decimal quart2ach;
                quart2ach = lineItem.quarter_two_Achieved;
                formattedQuarter2achieved =  conversion(quart2ach);
                String empId = '';
                  Integer quarterTwoTargetInteger = reduceDecimal(lineItem.quarter_Two_Target);
                String formattedQuarter2targetUS = getCurrencyFormatted(lineItem.quarter_Two_Target);
                String trimmedQuarter2target = '$' + quarterTwoTargetInteger;
                Integer quarterTwoAchievedInteger = reduceDecimal(lineItem.quarter_two_Achieved);
                String formattedQuarter2achievedUS = getCurrencyFormatted(lineItem.quarter_Two_Target);
                String trimmedQuarter2achieved = '$' + quarterTwoTargetInteger;
                String employeeeId = employeeDetails(lineItem.salesRepEmailId);              
                content1 += '<tbody>';
                content1 += '<tr ><td style="width: 26px;height: 20px;"></td><td style="height: 20px;padding: 8px;border-right:1px solid;border-left:1px solid;border-top:1px solid;border-bottom:1px solid;border-color:#ddd;text-align:left;">'+lineItem.salesRepName+'</td>';
                content1 += '<td style="height: 20px;padding: 8px;border-bottom:1px solid #ddd;border-color:#ddd;text-align:center;">'+employeeeId+'</td>';
                content1 += '<td style="height: 20px;padding: 8px;border-bottom:1px solid #ddd;border-color:#ddd;text-align:center;">'+formattedQuarter2targetUS+'</td>';
                content1 += '<td style="height: 20px;padding: 8px;border-bottom:1px solid #ddd;border-color:#ddd;text-align:center;">'+formattedQuarter2achievedUS+'</td>';
                content1 += '<td style="height: 20px;padding: 8px;border-bottom:1px solid #ddd;border-color:#ddd;text-align:center;border-right : 1px solid #ddd;'+colorStyle+'">'+percentData+'%</td>';  
                eastWrap.eastName = lineItem.salesRepName;
                eastWrap.eastTarget = formattedQuarter2target;
                eastWrap.eastAchieve = formattedQuarter2achieved;
                eastWrap.eastPercentile = percentData;
                eastWrap.eastPerSymbol = String.valueOf(percentData)+'%';
                eastWrap.eastEmployeeId = lineItem.empId;
                eastWrapList.add(eastWrap);
                recordString2 = lineItem.salesRepName+','+employeeeId+','+trimmedQuarter2target+','+trimmedQuarter2achieved+','+percentData+'\n';
                finalstr2 += recordString2;
            }
            recordString3 = sno0 + ',' + 'Initial Submission' + ',' + recDetails2.Intial_Approver__c + ',' +
                recDetails2.Initiator_Approval_Sent_Time_String__c + ',' + recDetails2.Initiator_Approval_Completed_Time_String__c + ',' +
                (String.isBlank(recDetails2.Initiator_Head_Comments__c) ? '' : recDetails2.Initiator_Head_Comments__c) + ',' + '\n' +
                sno1 + ',' + 'East RSM' + ',' + recDetails2.RSM_Approver__c + ',' +
                recDetails2.RSM_Head_Approval_Sent_Time_String__c + ',' + recDetails2.RSM_Head_Approval_Completed_Time_String__c + ',' +
                (String.isBlank(recDetails2.RSM_Head_Comments__c) ? '' : recDetails2.RSM_Head_Comments__c) + ',' + '\n' +
                sno2 + ',' + 'West RSM' + ',' + recDetails2.RSM_West_Approver__c + ',' +
                recDetails2.RSM_West_Approval_Sent_Time_String__c + ',' + recDetails2.RSM_West_Approval_Completed_Time_String__c + ',' +
                (String.isBlank(recDetails2.RSM_West_Head_Comments__c) ? '' : recDetails2.RSM_West_Head_Comments__c) + ',' + '\n' +
                sno3 + ',' + 'SRx Head' + ',' + 'Automatic BRIGHT' + ',' +
                recDetails2.SRx_Head_Approval_Sent_Time_String__c + ',' + recDetails2.SRx_Head_Approval_Completed_Time_String__c + ',' +
                (String.isBlank(recDetails2.SRx_Head_Comments__c) ? '' : recDetails2.SRx_Head_Comments__c) + ',' + '\n' +
                sno4 + ',' + 'Marketing Head' + ',' + recDetails2.Marketing_Approver__c + ',' +
                recDetails2.Marketing_Head_Approval_Sent_Time_String__c + ',' + recDetails2.Marketing_Head_Approval_Completed_Str__c + ',' +
                (String.isBlank(recDetails2.Marketing_Head_Comments__c) ? '' : recDetails2.Marketing_Head_Comments__c) + ',' + '\n';
            finalstr1 += recordString3;
            //  recordStringmultiples = finalstr+finalstr2+finalstr3;
            recordStringmultiples = finalstr1+'\n'+ finalstr+'\n'+finalstr2;
            content1 += '</tbody></table>';
            content1 += '</td>'; // Close the left table cell      
            //content1 += '<td style="width: 33%;height: 20px;">';
            // content1 += '</td>';
            // Close the table container
            content1 += '<td style="width:16%;"></td>';
            content1 += '<table align="left" style="width: 100%;margin-left:auto;margin-right:auto;border-collapse: collapse;padding:4px;font-size: 14px;font-family: Sans-Serif;">';
            content1 += '</table>';
            content1 += '</tr></table>';
        }    
         if(previousQuarter == 3 || Test.isRunningTest()){
            // Table container start
            content1 += '<table style="width: 100%;margin-left:auto;margin-right:auto;border-radius: 15px;font-size: 14px;font-family: Sans-Serif;">';
            content1 +=  '<tr><td style="width:42%;">';   //left table start                         
            content1 += '<table align="left" style="width: 100%;margin-left:auto;margin-right:auto;border-collapse: collapse;padding:4px;font-size: 14px;font-family: Sans-Serif;">';
            content1 +=  '<thead>';
            content1 +=  '<tr>';
            content1 +=  '<tr>';
            content1 +=  '<th style="width: 36px;height: 20px;"></th>';
            content1 +=  '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-left:1px solid;border-right: 1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;background-color:#D0C7E9;">SRx Team West</th>';
            content1 += '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;background-color:#D0C7E9;">Employee Id</th>';
            content1 += '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;background-color:#D0C7E9;">Target</th>';
            content1 += '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;background-color:#D0C7E9;">Achieved</th>';
            content1 += '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-right: 1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;background-color:#D0C7E9;">%</th>';
            content1 += '</tr></thead>';
            String westCSV;
            String targetCSV;
            String achivedCSV;
            String percentCSV;
            westWrapList = new List<DataWrapper>();
            for (AchievementSummaryTableCls.wrapperClass lineItem: westwrapData) {
                DataWrapper westWrap = new DataWrapper();
                if(lineItem.salesRepName != null){
                    westCSV = (lineItem.salesRepName).replaceAll(',', '');
                }
                else{
                    westCSV = '';
                }
                String colorStyle;
                Decimal quarter_Three_Target = lineItem.quarter_Three_Target;
                Decimal quarter_three_Achieved = lineItem.quarter_three_Achieved;
                Decimal percentData;
                percentData =  percentCalculate(quarter_three_Achieved,quarter_Three_Target);
                percentData = percentData.setScale(0);
                if(percentData > 90){
                    colorStyle  = 'color:green;color:#579857;';  
                }
                else if(percentData > 50 && percentData < 90 ){
                    colorStyle  = 'color:blue;color:#5072F1;';  
                }
                else{
                    colorStyle  = 'color:red;color:#EB4747;';    
                }
                String formattedQuarter3target;
                Decimal quart3tar;
                quart3tar = lineItem.quarter_Three_Target;
                formattedQuarter3target =  conversion(quart3tar);
                String formattedQuarter3achieved;
                Decimal quart3ach;
                quart3ach = lineItem.quarter_three_Achieved;
                formattedQuarter3achieved =  conversion(quart3ach);
                Integer quarterThreeTargetInteger = reduceDecimal(lineItem.quarter_Three_Target);
                String formattedQuarter3targetUS = getCurrencyFormatted(lineItem.quarter_Three_Target);
                String trimmedQuarter3target = '$' + quarterThreeTargetInteger;
                Integer quarterThreeAchievedInteger = reduceDecimal(lineItem.quarter_three_Achieved);
                String formattedQuarter3achievedUS = getCurrencyFormatted(lineItem.quarter_three_Achieved);
                String trimmedQuarter3achieved = '$' + quarterThreeAchievedInteger;
                String employeeeId = employeeDetails(lineItem.salesRepEmailId);
                content1 += '<tbody>';
                content1 += '<tr ><td style="width: 26px;height: 20px;"></td><td style="height: 20px;padding: 8px;border-right:1px solid;border-left:1px solid;border-top:1px solid;border-bottom:1px solid;border-color:#ddd;text-align:left;">'+lineItem.salesRepName+'</td>';
                content1 += '<td style="height: 20px;padding: 8px;border-bottom:1px solid #ddd;border-color:#ddd;text-align:center;">'+employeeeId+'</td>';
                content1 += '<td style="height: 20px;padding: 8px;border-bottom:1px solid #ddd;border-color:#ddd;text-align:center;">'+formattedQuarter3targetUS+'</td>';
                content1 += '<td style="height: 20px;padding: 8px;border-bottom:1px solid #ddd;border-color:#ddd;text-align:center;">'+formattedQuarter3achievedUS+'</td>';
                content1 += '<td style="height: 20px;padding: 8px;border-bottom:1px solid #ddd;border-color:#ddd;text-align:center;border-right : 1px solid #ddd;'+colorStyle+'">'+percentData+'%</td>';  
                westWrap.westName = lineItem.salesRepName;
                westWrap.westTarget = formattedQuarter3target;
                westWrap.westAchieve = formattedQuarter3achieved;
                westWrap.westPercentile = percentData;
                westWrap.westPerSymbol = String.valueOf(percentData)+'%';
                westWrap.westEmployeeId = lineItem.empId;
                westWrapList.add(westWrap);
                recordString = westCSV +','+employeeeId+','+trimmedQuarter3target+','+trimmedQuarter3achieved+','+percentData+'\n';
                finalstr += recordString;
            }
            content1 += '</tbody></table>';
            content1 += '</td>'; // Close the left table cell      
            content1 += '<td style="width:42%;">';
            content1 += '<table align="left" style="width: 100%;margin-left:auto;margin-right:auto;border-collapse: collapse;padding:4px;font-size: 14px;font-family: Sans-Serif;">';
            content1 +=  '<thead>';
            content1 +=  '<tr>';
            content1 +=  '<th style="width: 36px;height: 20px;"></th>';
            content1 +=  '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-left:1px solid;border-right: 1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;background-color:#D0C7E9;">SRx Team East</th>';
            content1 += '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;background-color:#D0C7E9;">Employee Id</th>';
            content1 += '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;background-color:#D0C7E9;">Target</th>';
            content1 += '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;background-color:#D0C7E9;">Achieved</th>';
            content1 += '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-right: 1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;background-color:#D0C7E9;">%</th>';
            content1 += '</tr></thead>';
            String eastCSV;
            String easttargetCSV;
            String eastachivedCSV;
            String eastpercentCSV;
            eastWrapList = new List<DataWrapper>();
            for (AchievementSummaryTableCls.wrapperClass lineItem: eastwrapData) {
                DataWrapper eastWrap = new DataWrapper();
                 String colorStyle;
                Decimal quarter_Three_Target = lineItem.quarter_Three_Target;
                Decimal quarter_three_Achieved = lineItem.quarter_three_Achieved;
                Decimal percentData;
                percentData =  percentCalculate(quarter_three_Achieved,quarter_Three_Target);
                percentData = percentData.setScale(0);
                if(percentData > 90){
                    colorStyle  = 'color:green;color:#579857;';  
                }
                else if(percentData > 50 && percentData < 90 ){
                    colorStyle  = 'color:blue;color:#5072F1;';  
                }
                else{
                    colorStyle  = 'color:red;color:#EB4747;';    
                }
                String formattedQuarter3target;
                Decimal quart3tar;
                quart3tar = lineItem.quarter_Three_Target;
                formattedQuarter3target =  conversion(quart3tar);
                String formattedQuarter3achieved;
                Decimal quart3ach;
                quart3ach = lineItem.quarter_three_Achieved;
                formattedQuarter3achieved =  conversion(quart3ach);
                Integer quarterThreeTargetInteger = reduceDecimal(lineItem.quarter_Three_Target);
                String formattedQuarter3targetUS = getCurrencyFormatted(lineItem.quarter_Three_Target);
                String trimmedQuarter3target = '$' + quarterThreeTargetInteger;
                Integer quarterThreeAchievedInteger = reduceDecimal(lineItem.quarter_three_Achieved);
                String formattedQuarter3achievedUS = getCurrencyFormatted(lineItem.quarter_three_Achieved);
                String trimmedQuarter3achieved = '$' + quarterThreeAchievedInteger;
                String employeeeId = employeeDetails(lineItem.salesRepEmailId);    
                content1 += '<tbody>';
                content1 += '<tr ><td style="width: 26px;height: 20px;"></td><td style="height: 20px;padding: 8px;border-right:1px solid;border-left:1px solid;border-top:1px solid;border-bottom:1px solid;border-color:#ddd;text-align:left;">'+lineItem.salesRepName+'</td>';
                content1 += '<td style="height: 20px;padding: 8px;border-bottom:1px solid #ddd;border-color:#ddd;text-align:center;">'+employeeeId+'</td>';
                content1 += '<td style="height: 20px;padding: 8px;border-bottom:1px solid #ddd;border-color:#ddd;text-align:center;">'+formattedQuarter3targetUS+'</td>';
                content1 += '<td style="height: 20px;padding: 8px;border-bottom:1px solid #ddd;border-color:#ddd;text-align:center;">'+formattedQuarter3achievedUS+'</td>';
                content1 += '<td style="height: 20px;padding: 8px;border-bottom:1px solid #ddd;border-color:#ddd;text-align:center;border-right : 1px solid #ddd;'+colorStyle+'">'+percentData+'%</td>';  
                eastWrap.eastName = lineItem.salesRepName;
                eastWrap.eastTarget = formattedQuarter3target;
                eastWrap.eastAchieve = formattedQuarter3achieved;
                eastWrap.eastPercentile = percentData;
                eastWrap.eastPerSymbol = String.valueOf(percentData)+'%';
                eastWrap.eastEmployeeId = lineItem.empId;
                eastWrapList.add(eastWrap);
                recordString2 = lineItem.salesRepName+','+employeeeId+','+trimmedQuarter3target+','+trimmedQuarter3achieved+','+percentData+'\n';
                finalstr2 += recordString2;
            }
            recordString3 = sno0 + ',' + 'Initial Submission' + ',' + recDetails2.Intial_Approver__c + ',' +
                recDetails2.Initiator_Approval_Sent_Time_String__c + ',' + recDetails2.Initiator_Approval_Completed_Time_String__c + ',' +
                (String.isBlank(recDetails2.Initiator_Head_Comments__c) ? '' : recDetails2.Initiator_Head_Comments__c) + ',' + '\n' +
                sno1 + ',' + 'East RSM' + ',' + recDetails2.RSM_Approver__c + ',' +
                recDetails2.RSM_Head_Approval_Sent_Time_String__c + ',' + recDetails2.RSM_Head_Approval_Completed_Time_String__c + ',' +
                (String.isBlank(recDetails2.RSM_Head_Comments__c) ? '' : recDetails2.RSM_Head_Comments__c) + ',' + '\n' +
                sno2 + ',' + 'West RSM' + ',' + recDetails2.RSM_West_Approver__c + ',' +
                recDetails2.RSM_West_Approval_Sent_Time_String__c + ',' + recDetails2.RSM_West_Approval_Completed_Time_String__c + ',' +
                (String.isBlank(recDetails2.RSM_West_Head_Comments__c) ? '' : recDetails2.RSM_West_Head_Comments__c) + ',' + '\n' +
                sno3 + ',' + 'SRx Head' + ',' + 'Automatic BRIGHT' + ',' +
                recDetails2.SRx_Head_Approval_Sent_Time_String__c + ',' + recDetails2.SRx_Head_Approval_Completed_Time_String__c + ',' +
                (String.isBlank(recDetails2.SRx_Head_Comments__c) ? '' : recDetails2.SRx_Head_Comments__c) + ',' + '\n' +
                sno4 + ',' + 'Marketing Head' + ',' + recDetails2.Marketing_Approver__c + ',' +
                recDetails2.Marketing_Head_Approval_Sent_Time_String__c + ',' + recDetails2.Marketing_Head_Approval_Completed_Str__c + ',' +
                (String.isBlank(recDetails2.Marketing_Head_Comments__c) ? '' : recDetails2.Marketing_Head_Comments__c) + ',' + '\n';
            finalstr1 += recordString3;
            recordStringmultiples = finalstr1+'\n'+ finalstr+'\n'+finalstr2;
            content1 += '</tbody></table>';
            content1 += '</td>'; // Close the left table cell      
            content1 += '<td style="width:16%;"></td>';
            content1 += '<table align="left" style="width: 100%;margin-left:auto;margin-right:auto;border-collapse: collapse;padding:4px;font-size: 14px;font-family: Sans-Serif;">';
            content1 += '</table>';
            content1 += '</tr></table>';
        }    
        if(previousQuarter == 4 || Test.isRunningTest()){
            // Table container start
            content1 += '<table style="width: 100%;margin-left:auto;margin-right:auto;border-radius: 15px;font-size: 14px;font-family: Sans-Serif;">';
            content1 +=  '<tr><td style="width:42%;">';   //left table start                         
            content1 += '<table align="left" style="width: 100%;margin-left:auto;margin-right:auto;border-collapse: collapse;padding:4px;font-size: 14px;font-family: Sans-Serif;">';
            content1 +=  '<thead>';
            content1 +=  '<tr>';
            content1 +=  '<tr>';
            content1 +=  '<th style="width: 36px;height: 20px;"></th>';
            content1 +=  '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-left:1px solid;border-right: 1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;background-color:#D0C7E9;">SRx Team West</th>';
            content1 += '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;background-color:#D0C7E9;">Employee Id</th>';
            content1 += '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;background-color:#D0C7E9;">Target</th>';
            content1 += '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;background-color:#D0C7E9;">Achieved</th>';
            content1 += '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-right: 1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;background-color:#D0C7E9;">%</th>';
            content1 += '</tr></thead>';
            String westCSV;
            String targetCSV;
            String achivedCSV;
            String percentCSV;
            westWrapList = new List<DataWrapper>();
            for (AchievementSummaryTableCls.wrapperClass lineItem: westwrapData) {
                DataWrapper westWrap = new DataWrapper();
                if(lineItem.salesRepName != null){
                    westCSV = (lineItem.salesRepName).replaceAll(',', '');
                }
                else{
                    westCSV = '';
                }
                String colorStyle;
                Decimal quarter_Four_Target = lineItem.quarter_Four_Target;
                Decimal quarter_four_Achieved = lineItem.quarter_four_Achieved;
                Decimal percentData;
                percentData =  percentCalculate(quarter_four_Achieved,quarter_Four_Target);
                percentData = percentData.setScale(0);
                if(percentData > 90){
                    colorStyle  = 'color:green;color:#579857;';  
                }
                else if(percentData > 50 && percentData < 90 ){
                    colorStyle  = 'color:blue;color:#5072F1;';  
                }
                else{
                    colorStyle  = 'color:red;color:#EB4747;';    
                }
                String formattedQuarter4target;
                Decimal quart4tar;
                quart4tar = lineItem.quarter_Four_Target;
                formattedQuarter4target =  conversion(quart4tar);
                String formattedQuarter4achieved;
                Decimal quart4ach;
                quart4ach = lineItem.quarter_four_Achieved;
                formattedQuarter4achieved =  conversion(quart4ach);
                Integer quarterFourTargetInteger = reduceDecimal(lineItem.quarter_Four_Target);
                String formattedQuarter4targetUS = getCurrencyFormatted(lineItem.quarter_Four_Target);
                String trimmedQuarter4target = '$' + quarterFourTargetInteger;
                Integer quarterFourAchievedInteger = reduceDecimal(lineItem.quarter_four_Achieved);
                String formattedQuarter4achievedUS = getCurrencyFormatted(lineItem.quarter_four_Achieved);
                String trimmedQuarter4achieved = '$' + quarterFourAchievedInteger;
                String employeeeId = employeeDetails(lineItem.salesRepEmailId);
                content1 += '<tbody>';
                content1 += '<tr ><td style="width: 26px;height: 20px;"></td><td style="height: 20px;padding: 8px;border-right:1px solid;border-left:1px solid;border-top:1px solid;border-bottom:1px solid;border-color:#ddd;text-align:left;">'+lineItem.salesRepName+'</td>';
                content1 += '<td style="height: 20px;padding: 8px;border-bottom:1px solid #ddd;border-color:#ddd;text-align:center;">'+employeeeId+'</td>';
                content1 += '<td style="height: 20px;padding: 8px;border-bottom:1px solid #ddd;border-color:#ddd;text-align:center;">'+formattedQuarter4targetUS+'</td>';
                content1 += '<td style="height: 20px;padding: 8px;border-bottom:1px solid #ddd;border-color:#ddd;text-align:center;">'+formattedQuarter4achievedUS+'</td>';
                content1 += '<td style="height: 20px;padding: 8px;border-bottom:1px solid #ddd;border-color:#ddd;text-align:center;border-right : 1px solid #ddd;'+colorStyle+'">'+percentData+'%</td>';  
                westWrap.westName = lineItem.salesRepName;
                westWrap.westTarget = formattedQuarter4target;
                westWrap.westAchieve = formattedQuarter4achieved;
                westWrap.westPercentile = percentData;
                westWrap.westPerSymbol = String.valueOf(percentData)+'%';
                westWrap.westEmployeeId = lineItem.empId;
                westWrapList.add(westWrap);
                recordString = westCSV +','+employeeeId+','+trimmedQuarter4target+','+trimmedQuarter4achieved+','+percentData+'\n';
                finalstr += recordString;
            }
            content1 += '</tbody></table>';
            content1 += '</td>'; // Close the left table cell      
            content1 += '<td style="width:42%;">';
            content1 += '<table align="left" style="width: 100%;margin-left:auto;margin-right:auto;border-collapse: collapse;padding:4px;font-size: 14px;font-family: Sans-Serif;">';
            content1 +=  '<thead>';
            content1 +=  '<tr>';
            content1 +=  '<th style="width: 36px;height: 20px;"></th>';
            content1 +=  '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-left:1px solid;border-right: 1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;background-color:#D0C7E9;">SRx Team East</th>';
            content1 += '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;background-color:#D0C7E9;">Employee Id</th>';
            content1 += '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;background-color:#D0C7E9;">Target</th>';
            content1 += '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;background-color:#D0C7E9;">Achieved</th>';
            content1 += '<th style="height: 20px;text-align:center;border-bottom:1px solid;border-top:1px solid;border-right: 1px solid;border-color:#ddd;padding-top: 5px;padding-bottom: 5px;background-color:#D0C7E9;">%</th>';
            content1 += '</tr></thead>';
            String eastCSV;
            String easttargetCSV;
            String eastachivedCSV;
            String eastpercentCSV;
            eastWrapList = new List<DataWrapper>();
            for (AchievementSummaryTableCls.wrapperClass lineItem: eastwrapData) {
                DataWrapper eastWrap = new DataWrapper();
                 String colorStyle;
                Decimal quarter_Four_Target = lineItem.quarter_Four_Target;
                Decimal quarter_four_Achieved = lineItem.quarter_four_Achieved;
                Decimal percentData;
                percentData =  percentCalculate(quarter_four_Achieved,quarter_Four_Target);
                percentData = percentData.setScale(0);
                if(percentData > 90){
                    colorStyle  = 'color:green;color:#579857;';  
                }
                else if(percentData > 50 && percentData < 90 ){
                    colorStyle  = 'color:blue;color:#5072F1;';  
                }
                else{
                    colorStyle  = 'color:red;color:#EB4747;';    
                }
                String formattedQuarter4target;
                Decimal quart4tar;
                quart4tar = lineItem.quarter_Four_Target;
                formattedQuarter4target =  conversion(quart4tar);
                String formattedQuarter4achieved;
                Decimal quart4ach;
                quart4ach = lineItem.quarter_four_Achieved;
                formattedQuarter4achieved =  conversion(quart4ach);
                Integer quarterFourTargetInteger = reduceDecimal(lineItem.quarter_Four_Target);
                String formattedQuarter4targetUS = getCurrencyFormatted(lineItem.quarter_Four_Target);
                String trimmedQuarter4target = '$' + quarterFourTargetInteger;
                Integer quarterFourAchievedInteger = reduceDecimal(lineItem.quarter_four_Achieved);
                String formattedQuarter4achievedUS = getCurrencyFormatted(lineItem.quarter_four_Achieved);
                String trimmedQuarter4achieved = '$' + quarterFourAchievedInteger;
                String employeeeId = employeeDetails(lineItem.salesRepEmailId); 
                content1 += '<tbody>';
                content1 += '<tr ><td style="width: 26px;height: 20px;"></td><td style="height: 20px;padding: 8px;border-right:1px solid;border-left:1px solid;border-top:1px solid;border-bottom:1px solid;border-color:#ddd;text-align:left;">'+lineItem.salesRepName+'</td>';
                content1 += '<td style="height: 20px;padding: 8px;border-bottom:1px solid #ddd;border-color:#ddd;text-align:center;">'+employeeeId+'</td>';
                content1 += '<td style="height: 20px;padding: 8px;border-bottom:1px solid #ddd;border-color:#ddd;text-align:center;">'+formattedQuarter4targetUS+'</td>';
                content1 += '<td style="height: 20px;padding: 8px;border-bottom:1px solid #ddd;border-color:#ddd;text-align:center;">'+formattedQuarter4achievedUS+'</td>';
                content1 += '<td style="height: 20px;padding: 8px;border-bottom:1px solid #ddd;border-color:#ddd;text-align:center;border-right : 1px solid #ddd;'+colorStyle+'">'+percentData+'%</td>';  
                eastWrap.eastName = lineItem.salesRepName;
                eastWrap.eastTarget = formattedQuarter4target;
                eastWrap.eastAchieve = formattedQuarter4achieved;
                eastWrap.eastPercentile = percentData;
                eastWrap.eastPerSymbol = String.valueOf(percentData)+'%';
                eastWrap.eastEmployeeId = lineItem.empId;
                eastWrapList.add(eastWrap);
                recordString2 = lineItem.salesRepName+','+employeeeId+','+trimmedQuarter4target+','+trimmedQuarter4achieved+','+percentData+'\n';
                finalstr2 += recordString2;
            }
            recordString3 = sno0 + ',' + 'Initial Submission' + ',' + recDetails2.Intial_Approver__c + ',' +
                recDetails2.Initiator_Approval_Sent_Time_String__c + ',' + recDetails2.Initiator_Approval_Completed_Time_String__c + ',' +
                (String.isBlank(recDetails2.Initiator_Head_Comments__c) ? '' : recDetails2.Initiator_Head_Comments__c) + ',' + '\n' +
                sno1 + ',' + 'East RSM' + ',' + recDetails2.RSM_Approver__c + ',' +
                recDetails2.RSM_Head_Approval_Sent_Time_String__c + ',' + recDetails2.RSM_Head_Approval_Completed_Time_String__c + ',' +
                (String.isBlank(recDetails2.RSM_Head_Comments__c) ? '' : recDetails2.RSM_Head_Comments__c) + ',' + '\n' +
                sno2 + ',' + 'West RSM' + ',' + recDetails2.RSM_West_Approver__c + ',' +
                recDetails2.RSM_West_Approval_Sent_Time_String__c + ',' + recDetails2.RSM_West_Approval_Completed_Time_String__c + ',' +
                (String.isBlank(recDetails2.RSM_West_Head_Comments__c) ? '' : recDetails2.RSM_West_Head_Comments__c) + ',' + '\n' +
                sno3 + ',' + 'SRx Head' + ',' + 'Automatic BRIGHT' + ',' +
                recDetails2.SRx_Head_Approval_Sent_Time_String__c + ',' + recDetails2.SRx_Head_Approval_Completed_Time_String__c + ',' +
                (String.isBlank(recDetails2.SRx_Head_Comments__c) ? '' : recDetails2.SRx_Head_Comments__c) + ',' + '\n' +
                sno4 + ',' + 'Marketing Head' + ',' + recDetails2.Marketing_Approver__c + ',' +
                recDetails2.Marketing_Head_Approval_Sent_Time_String__c + ',' + recDetails2.Marketing_Head_Approval_Completed_Str__c + ',' +
                (String.isBlank(recDetails2.Marketing_Head_Comments__c) ? '' : recDetails2.Marketing_Head_Comments__c) + ',' + '\n';
            finalstr1 += recordString3;
            recordStringmultiples = finalstr1+'\n'+ finalstr+'\n'+finalstr2;
            content1 += '</tbody></table>';
            content1 += '</td>'; // Close the left table cell      
            content1 += '<td style="width:16%;"></td>';
            content1 += '<table align="left" style="width: 100%;margin-left:auto;margin-right:auto;border-collapse: collapse;padding:4px;font-size: 14px;font-family: Sans-Serif;">';
            content1 += '</table>';
            content1 += '</tr></table>';
        }    
        l1 = new List<String>();
        l2 = new List<String>();
        l1.add('pradeepkumarmutyala@drreddys.com');
        l1.add('pradeep@dhruvsoft.com');
        l1.add('bhavadeep.valavala@dhruvsoft.com');
        //ccAddress.add('pradeep@dhruvsoft.com');
        l2.add(westRSMHeadEmail);
        l2.add(eastRSMHeadEmail);
        l2.add('srimayeechilagani@drreddys.com');
        l2.add('srimayee@dhruvsoft.com');
        l2.add(srxHeadEmail);
        
        
        
        
        //CSV Attachment
        csvAttc = new Messaging.EmailFileAttachment();
        csvBlob = Blob.valueOf(recordStringmultiples);
        
        
        DateTime todayDate = DateTime.newInstance(System.today(), Time.newInstance(0, 0, 0, 0));
        csvname = 'Q'+ previousQuarter + ' FY ' + fiscalYear + ' SRx Target Sales Achievement.csv';
        pdfname = 'Q'+ previousQuarter + ' FY ' + fiscalYear + ' SRx Target Sales Achievement.pdf';
        
        
    }  
    
    
    
    public static Integer reduceDecimal(Decimal decimalValue){
        Integer integerValue = (Integer)decimalValue;
        return integerValue;
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
    public static String employeeDetails(String salesRepEmailId)
    {
        //Fetching quarterUsers Employee numbers into a map
        for (User u : usersList) {
            quarterUsersMap.put(u.Email,u.EmployeeNumber);
        } 
        if (quarterUsersMap.containsKey(salesRepEmailId)) {
            employeeId = quarterUsersMap.get(salesRepEmailId);
            System.debug('Employee Number for ' + salesRepEmailId + ': ' + employeeId);
        } else {
            employeeId = '';
            System.debug('Employee Number not found for ' +salesRepEmailId);
        }
        return employeeId;
    }
    
    /*String recId, Blob csvBlob,String csvname,String dynamicSubject, 
String content1, list<String> l1, list<String> l2,
Messaging.EmailFileAttachment csvAttc*/
    
    public static void SendEmail(String recId)
    {
        //get PDF Body
      //  PageReference pdfPage = Page.HR_PDF_VF;
      //  pdfPage.getParameters().put('id', recId); // Pass necessary parameters
      //  Blob pdfBlob = pdfPage.getContentAsPDF();
        targetAchievedApprovalTableData(recId);
        achievedTargetData(recId);
        List < Messaging.SingleEmailMessage > mailsList = new List < Messaging.SingleEmailMessage > ();
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        csvAttc.setFileName(csvname);
        csvAttc.setBody(csvBlob);
        
        
        
        //PDF Attachment
        Messaging.EmailFileAttachment pdfAttachmentFile = new Messaging.EmailFileAttachment();
      //  pdfAttachmentFile.setFileName(pdfname);
       // pdfAttachmentFile.setBody(pdfBlob);
      //  email.setFileAttachments(new Messaging.EmailFileAttachment[] { pdfAttachmentFile });
        
        email.setSubject(dynamicSubject);
        email.setHtmlBody(content1);
        email.setToAddresses(l1);
        email.setCCAddresses(l2);    
        email.setOrgWideEmailAddressId(Phoenix_Util.orgWideEmailId);
       // email.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttc,pdfAttachmentFile});
       email.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttc});
        mailsList.add(email);
        
        Messaging.sendEmail(mailsList);
        
    }
    public Class DataWrapper{
        public String westName {get;set;} 
        public String  westTarget {get;set;}
        public String westAchieve {get;set;}
        public String westPerSymbol {get;set;}
        public Decimal westPercentile {get;set;}
        public String westEmployeeId {get;set;}
        public String eastName {get;set;} 
        public String eastTarget {get;set;}
        public String eastAchieve {get;set;}
        public String eastPerSymbol {get;set;}
        public Decimal eastPercentile {get;set;}
        public String eastEmployeeId {get;set;}
        
    }
}