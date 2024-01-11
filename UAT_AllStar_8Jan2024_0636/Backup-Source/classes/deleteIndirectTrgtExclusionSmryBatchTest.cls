@isTest
public class deleteIndirectTrgtExclusionSmryBatchTest {
    
    @isTest
    public static void test1()
    {
        
        Indirect_TargetExclusion_Summary__c t1 = new Indirect_TargetExclusion_Summary__c();
        t1.Indirect_Billing_Date__c = system.today();
        t1.Indirect_Customer_Name__c = 'test';
        t1.Indirect_Product__c = 'test1';
        insert t1;
        
        Indirect_TargetExclusion_Summary__c t2 = new Indirect_TargetExclusion_Summary__c();
        t2.Indirect_Billing_Date__c = system.today();
        t2.Indirect_Customer_Name__c = 'test';
        t2.Indirect_Product__c = 'test1';
        insert t2;
        
        
        Database.executeBatch(new deleteIndirectTrgtExclusionSummaryBatch());
    }

}