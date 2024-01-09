@isTest
public class deleteIndirectSalesSummaryBatchTest {
    
    @isTest
    public static void test1()
    {
        SRx_IndirectSales_Summary_Table__c s1 = new SRx_IndirectSales_Summary_Table__c();
        s1.Hospital_Name__c = 'test';
        s1.Settlement_Paid_Date__c = system.today();
        s1.Product__c = 'test';
        insert s1;
        
        SRx_IndirectSales_Summary_Table__c s2 = new SRx_IndirectSales_Summary_Table__c();
        s2.Hospital_Name__c = 'test';
        s2.Settlement_Paid_Date__c = system.today();
        s2.Product__c = 'test';
        insert s2;
        
        Database.executeBatch(new deleteIndirectSalesSummaryBatch());
    }

}