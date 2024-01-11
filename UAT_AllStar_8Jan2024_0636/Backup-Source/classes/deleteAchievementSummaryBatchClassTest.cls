@isTest
public class deleteAchievementSummaryBatchClassTest {
    
    @isTest
    public static void test1()
    {
        
        Achievement_Summary_Table__c ac1 = new Achievement_Summary_Table__c();
        ac1.Name = 'CB-1200491';
        ac1.Sales_Rep_Name__c= 'Doris Hartell';
        ac1.Direct_Sales_Billing_Date__c = date.newinstance(2023, 04, 27);
        ac1.Direct_Sales__c= 1608199.82;
        insert ac1;
        
        Achievement_Summary_Table__c ac2 = new Achievement_Summary_Table__c();
        ac2.Name = 'CB-1207172';
        ac2.Sales_Rep_Name__c= 'Erica Bass';
        ac2.Direct_Sales_Billing_Date__c = date.newinstance(2023, 04, 28);
        ac2.Direct_Sales__c= 63263.91;
        insert ac2;
        Database.executeBatch(new deleteAchievementSummaryBatchClass());
    }

}