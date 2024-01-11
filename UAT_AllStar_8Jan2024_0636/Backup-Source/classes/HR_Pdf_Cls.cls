public class HR_Pdf_Cls {
    
    public HR_Pdf_Cls()
    {
        targetAchievedApprovalTableData();
        returnSomething();
    }
    public static Integer num = 1;
	public static List<AchievementSummaryTableCls.wrapperClass> westwrapData = AchievementSummaryTableCls.getWestDirectIndirectSalesList();
    public static List<AchievementSummaryTableCls.wrapperClass> eastwrapData = AchievementSummaryTableCls.getEastDirectIndirectSalesList();
    public static List<Target_Achieved_Approval__c> recDetails {get;set;}
    public static String parentRecId = 'a21DL000002BnEnYAK';
    public static List<DataWrapper> eastWrapList {get;set;}
    public static List<DataWrapper> westWrapList{get;set;}
    public static Map<String,String> quarterUsersMap = new Map<String,String>();
   // public static List<Target_Achieved_Approval__c> recDetails = new List<Target_Achieved_Approval__c>();

   
    public List<Target_Achieved_Approval__c> targetAchievedApprovalTableData(){
	recDetails = [SELECT Id, Name,RSM_Head_Status__c,RSM_Head_Comments__c,RSM_Head_Approval_Sent_Time_String__c,RSM_Head_Approval_Sent_Time__c,RSM_Head_Approval_Completed_Time_String__c,
                                                   RSM_Head_Approval_Completed_Time__c,RSM_Approver__c, Approval_Status__c, Financial_Year__c, Marketing_Approver__c,Intial_Approver__c,SRx_Approver__c,
                                                   Initiator_Status__c, SRx_Head_Status__c, Marketing_Head_Status__c, SRx_Head_Comments__c, Marketing_Head_Comments__c,
                                                   Initiator_Approval_Sent_Time_String__c,Initiator_Approval_Completed_Time_String__c,Initiator_Approval_Completed_Time__c,Initiator_Head_Comments__c,Marketing_Head_Approval_Completed_Str__c,
                                                   Marketing_Head_Approval_Completed_Time__c,Marketing_Head_Approval_Sent_Time_String__c,Marketing_Head_Approval_Sent_Time__c,SRx_Head_Approval_Completed_Time_String__c,
                                                   SRx_Head_Approval_Completed_Time__c,SRx_Head_Approval_Sent_Time_String__c,SRx_Head_Approval_Sent_Time__c,
                                                   RSM_West_Head_Status__c,RSM_West_Head_Comments__c,RSM_West_Head_Approval_Sent_Time__c,RSM_West_Approver__c,RSM_West_Approval_Sent_Time_String__c,RSM_West_Approval_Completed_Time_String__c,RSM_West_Approval_Completed_Time__c FROM Target_Achieved_Approval__c where Id =: parentRecId ];
    return recDetails;        
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
 /*   public static String employeeDetails(String salesRepEmailId)
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
    }*/
     
    public static void returnSomething(){
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
            previousQuarter = 1;
        } else if (calendarQuarter == 3) {
            fiscalQuarter = 2;
            previousQuarter = 4;
        } else {
            fiscalQuarter = 3;
            previousQuarter = 2;
        }   
        
         if(num != null){
            westWrapList = new List<DataWrapper>();
            for (AchievementSummaryTableCls.wrapperClass lineItem: westwrapData) {
                DataWrapper westWrap = new DataWrapper();
                Decimal quarter_one_Target = lineItem.quarter_one_Target;
                Decimal quarter_one_Achieved = lineItem.quarter_one_Achieved;
                Decimal percentData;
                percentData =  percentCalculate(quarter_one_Achieved,quarter_one_Target);
                percentData = percentData.setScale(0);
                String formattedQuarter1target;
                Decimal quart1tar;
                quart1tar = lineItem.quarter_one_Target;
                formattedQuarter1target =  HeadApprovalEmailNotification.conversion(quart1tar);
                String formattedQuarter1achieved;
                Decimal quart1ach;
                quart1ach = lineItem.quarter_one_Achieved;
                formattedQuarter1achieved =  HeadApprovalEmailNotification.conversion(quart1ach);
                Integer quarterOneTargetInteger = reduceDecimal(lineItem.quarter_one_Target);
                String trimmedQuarter1target = '$' + quarterOneTargetInteger;
                Integer quarterOneAchievedInteger = reduceDecimal(lineItem.quarter_one_Achieved);
                String trimmedQuarter1achieved = '$' + quarterOneAchievedInteger;
              // String employeeeId = employeeDetails(lineItem.salesRepEmailId);
                
                westWrap.westName = lineItem.salesRepName;
                westWrap.westTarget = formattedQuarter1target;
                westWrap.westAchieve = formattedQuarter1achieved;
                westWrap.westPercentile = percentData;
                westWrap.westPerSymbol = String.valueOf(percentData)+'%';
                westWrap.westEmployeeId = lineItem.empId;
                westWrapList.add(westWrap);
                
            } 
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
                formattedQuarter1target =  HeadApprovalEmailNotification.conversion(quart1tar);
                String formattedQuarter1achieved;
                Decimal quart1ach;
                quart1ach = lineItem.quarter_one_Achieved;
                formattedQuarter1achieved =  HeadApprovalEmailNotification.conversion(quart1ach);
                Integer quarterOneTargetInteger = reduceDecimal(lineItem.quarter_one_Target);
                String trimmedQuarter1target = '$' + quarterOneTargetInteger;
                Integer quarterOneAchievedInteger = reduceDecimal(lineItem.quarter_one_Achieved);
                String trimmedQuarter1achieved = '$' + quarterOneAchievedInteger;
               // String employeeeId = employeeDetails(lineItem.salesRepEmailId);
                eastWrap.eastName = lineItem.salesRepName;
                eastWrap.eastTarget = formattedQuarter1target;
                eastWrap.eastAchieve = formattedQuarter1achieved;
                eastWrap.eastPercentile = percentData;
                eastWrap.eastPerSymbol = String.valueOf(percentData)+'%';
                eastWrap.eastEmployeeId = lineItem.empId;
                eastWrapList.add(eastWrap);
            }
           
        }    
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