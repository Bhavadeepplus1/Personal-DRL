@isTest
public class deleteDirectTgtExclusionSummaryBatchTest {
    
    @isTest
    public static void test1()
    {
        Target_Exclusion_Summary__c t1 = new Target_Exclusion_Summary__c();
        t1.Direct_Billing_Date__c = system.today();
        t1.Direct_Customer_Name__c = 'test';
        t1.Direct_Product__c = 'test1';
        insert t1;
        
        Target_Exclusion_Summary__c t2 = new Target_Exclusion_Summary__c();
        t2.Direct_Billing_Date__c = system.today();
        t2.Direct_Customer_Name__c = 'test';
        t2.Direct_Product__c = 'test1';
        insert t2;
        
        
        Database.executeBatch(new deleteDirectTargetExclusionSummaryBatch());
    }
    

}