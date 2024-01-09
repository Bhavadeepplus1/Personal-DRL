@isTest
public class deleteDirectSalesSummaryBatchTest {
    
    @isTest
    public static void testmethod1()
    {
        
        SRx_DirectSales_SummaryTable__c s1 = new SRx_DirectSales_SummaryTable__c();
        s1.Customer_Name__c = 'test';
        s1.Billing_Date__c = system.today();
        s1.Region__c = 'west';
        insert s1;
        
        SRx_DirectSales_SummaryTable__c s2 = new SRx_DirectSales_SummaryTable__c();
        s2.Customer_Name__c = 'test';
        s2.Billing_Date__c = system.today();
        s2.Region__c = 'west';
        insert s2;
        
        Database.executeBatch(new deleteDirectSalesSummaryBatch());
        
    }

}