@isTest
public class Phoenix_OTCSPAHistoryClsTest {
    @isTest
    public static void testSPADataMethod(){
        
        Product2 p = new Product2();
        p.Name = 'test';
        insert p;
        Account acc = new Account();
        acc.Name ='Test Account';
        insert acc;
        Opportunity opty = new Opportunity();
        opty.Name= 'test';
        opty.CloseDate = system.today();
        opty.AccountId =acc.Id;
        opty.StageName = 'Open';
        insert opty;
        Phoenix_Bid__c bid = new Phoenix_Bid__c();
        bid.Phoenix_Bid_Name__c = 'Test Bid';
        bid.Phoenix_Customer__c = acc.Id;
        bid.Phoenix_Bid_Type__c = 'RFP Bids';
        bid.Phoenix_Approval_Status__c = 'Closed';
        insert bid;
        Phoenix_Bid_Line_Item__c bidLine = new Phoenix_Bid_Line_Item__c();
        bidLine.Phoenix_Bid__c =bid.Id;
        bidLine.Phoenix_Product__c = p.Id;
        insert bidLine;
        OTC_SPA__c otcSPA = new OTC_SPA__c();
        otcSPA.Current_Contract_Price__c = '10';
        otcSPA.Price__c = 10;
        otcSPA.Price_Effective_Date__c =system.today();
        otcSPA.OPT__c=opty.Id;
        otcSPA.Estimate_in_DC_Date__c=system.today();
        otcSPA.Price_Intelligence__c='test';
        insert otcSPA;
        Phoenix_OTCSPAHistoryCls.getFilterData(bidLine.Id, false, false, 'Rejectted', 'Closed','','test','test',true);
        Phoenix_OTCSPAHistoryCls.getFilterData(bidLine.Id, true, false, 'Rejectted', 'Closed','test','test','',false);
        Phoenix_OTCSPAHistoryCls.getFilterData(bidLine.Id, true, true, 'Rejectted', 'Closed','test','','test',true);
        Phoenix_OTCSPAHistoryCls.getFilterData(bidLine.Id, false, true, 'Rejectted', 'Closed','test','','test',true);
        Phoenix_OTCSPAHistoryCls.getSPAHistory(bidLine.Id, false, true,false);
        Phoenix_OTCSPAHistoryCls.getSPAHistory(bidLine.Id, true, true,true);
        
    }

}