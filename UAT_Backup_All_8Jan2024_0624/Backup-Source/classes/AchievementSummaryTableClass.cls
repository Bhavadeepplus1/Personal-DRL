public class AchievementSummaryTableClass {
    
    @AuraEnabled
    public static list<Sales_Reps_Targets__c> getAnnualWestData()
    {
        return [select User_Name__c,Quarter_1__c,Quarter_2__c,Quarter_3__c,Quarter_4__c from Sales_Reps_Targets__c ];
    }
    
    @AuraEnabled
    public static list<Sales_Reps_Targets__c> getAnnualEastData()
    {
        return [select User_Name__c,Quarter_1__c,Quarter_2__c,Quarter_3__c,Quarter_4__c from Sales_Reps_Targets__c where Financial_Year__c = 'FY24' AND Region__c='East'];
    }

}