@isTest
public class SRxDirectSalesSummaryBatchClsTest {
    
    @isTest
    public static void test1()
    {
        list<Phoenix_SRx_Direct_Sales_Data__c> directsaleslist = new list<Phoenix_SRx_Direct_Sales_Data__c>{};
        
        Phoenix_SRx_Direct_Sales_Data__c salesdata1 = new Phoenix_SRx_Direct_Sales_Data__c();
        salesdata1.Phoenix_Sales_Rep__c = 'Eric Sutherland';
        Date today = System.today();
		DateTime todayDateTime = DateTime.newInstance(today.year(), today.month(), today.day());
		String todayString = todayDateTime.format('yyyy-MM-dd');
        salesdata1.Phoenix_Billing_Date__c = todayString;
        salesdata1.Phoenix_Gross__c = '1260.0';
        salesdata1.Phoenix_Sold_To_Rebate_Recipient__c='370617';
        salesdata1.Phoenix_Exclude_Flag__c='NO';
        directsaleslist.add(salesdata1);
        
        Phoenix_SRx_Direct_Sales_Data__c salesdata2 = new Phoenix_SRx_Direct_Sales_Data__c();
        salesdata2.Phoenix_Sales_Rep__c = 'Dave Smith';
        Date today1 = System.today();
		DateTime todayDateTime1 = DateTime.newInstance(today1.year(), today1.month(), today1.day());
		String todayString1 = todayDateTime1.format('yyyy-MM-dd');
        salesdata2.Phoenix_Billing_Date__c = todayString1;
        salesdata2.Phoenix_Gross__c = '2520.0';
        salesdata2.Phoenix_Sold_To_Rebate_Recipient__c='370618';
        salesdata2.Phoenix_Exclude_Flag__c='NO';
        directsaleslist.add(salesdata2);
        
        insert directsaleslist;
        
        Database.executeBatch(new SRxDirectSalesSummaryBatchCls());
        
        
    }
    
    @isTest
    public static void test2()
    {
        
        Phoenix_SRx_Direct_Sales_Data__c salesdata1 = new Phoenix_SRx_Direct_Sales_Data__c();
        salesdata1.Phoenix_Sales_Rep__c = 'Eric Sutherland';
        Date today = System.today();
		DateTime todayDateTime = DateTime.newInstance(today.year(), today.month(), today.day());
		String todayString = todayDateTime.format('yyyy-MM-dd');
        salesdata1.Phoenix_Billing_Date__c = todayString;
        salesdata1.Phoenix_Gross__c = '1310.0';
        salesdata1.Phoenix_Sold_To_Rebate_Recipient__c='370617';
        salesdata1.Phoenix_Exclude_Flag__c='NO';
        insert salesdata1;
        
        Phoenix_SRx_Direct_Sales_Data__c salesdata2 = new Phoenix_SRx_Direct_Sales_Data__c();
        salesdata2.Phoenix_Sales_Rep__c = 'Dave Smith';
        Date today1 = System.today().addmonths(-2);
		DateTime todayDateTime1 = DateTime.newInstance(today1.year(), today1.month(), today1.day());
		String todayString1 = todayDateTime1.format('yyyy-MM-dd');
        salesdata2.Phoenix_Billing_Date__c = todayString1;
        salesdata2.Phoenix_Gross__c = '2700.0';
        salesdata2.Phoenix_Sold_To_Rebate_Recipient__c='370618';
        salesdata2.Phoenix_Exclude_Flag__c='NO';
        insert salesdata2;
        
        Phoenix_SRx_Direct_Sales_Data__c salesdata3 = new Phoenix_SRx_Direct_Sales_Data__c();
        salesdata3.Phoenix_Sales_Rep__c = 'Dave Smith';
        Date today2 = System.today().addmonths(-3);
		DateTime todayDateTime2 = DateTime.newInstance(today2.year(), today2.month(), today2.day());
		String todayString2 = todayDateTime2.format('yyyy-MM-dd');
        salesdata3.Phoenix_Billing_Date__c = todayString2;
        salesdata3.Phoenix_Gross__c = '2700.0';
        salesdata3.Phoenix_Sold_To_Rebate_Recipient__c='370618';
        salesdata3.Phoenix_Exclude_Flag__c='NO';
        insert salesdata3;
        
        Phoenix_SRx_Direct_Sales_Data__c salesdata4 = new Phoenix_SRx_Direct_Sales_Data__c();
        salesdata4.Phoenix_Sales_Rep__c = 'Dave Smith';
        Date today3 = System.today().addmonths(-3);
		DateTime todayDateTime3 = DateTime.newInstance(today3.year(), today3.month(), today3.day());
		String todayString3 = todayDateTime3.format('yyyy-MM-dd');
        salesdata4.Phoenix_Billing_Date__c = todayString3;
        salesdata4.Phoenix_Gross__c = '2300.0';
        salesdata4.Phoenix_Sold_To_Rebate_Recipient__c='370618';
        salesdata4.Phoenix_Exclude_Flag__c='NO';
        insert salesdata4;
        
        Database.executeBatch(new SRxDirectSalesSummaryBatchCls());
        
        
    }
}