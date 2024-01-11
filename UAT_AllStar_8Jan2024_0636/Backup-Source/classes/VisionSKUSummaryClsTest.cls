@istest
public class VisionSKUSummaryClsTest {
    static testmethod void  test(){
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User u = new User(Alias = 'standt', Email='testmmm@testorg.com', EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='America/Los_Angeles', UserName='testmmm@testorg.com', Division='Rx');
        insert u;
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.Owner = u;
        insert acc;
        Product2 prod = new Product2();
        prod.Name = 'Test Product';
        prod.ProductCode = '1234567';
        prod.Phoenix_Rx_SRx_OTC__c = 'Rx';
        prod.Family = 'Test Family';
        insert prod;    
        Product2 prod2 = new Product2();
        prod2.Name = 'Test Product2';
        prod2.ProductCode = '1234568';
        prod2.Phoenix_Rx_SRx_OTC__c = 'SRx';
        prod2.Family = 'Test Family2';
        insert prod2; 
        
        Phoenix_Contract__c cont = new Phoenix_Contract__c();
        cont.Name = 'Test';
        cont.Phoenix_Contract_Number__c = '1234';
        cont.Phoenix_Customer__c = acc.Id;
        insert cont;
        
        
        Phoenix_Bid__c bid = new Phoenix_Bid__c();
        bid.Phoenix_Bid_Name__c = 'Test Bid';
        bid.Phoenix_Bid_Type__c = 'Product Addition';
        bid.OwnerId = u.Id;
        bid.Phoenix_Customer_Type__c = 'Net Indirect Pricing';
        bid.Phoenix_Customer__c = acc.id;
        bid.Phoenix_Approval_Status__c = 'Customer\'s Update';
        bid.Phoenix_Bid_Submitted_Date__c = system.today();
        bid.Phoenix_Sent_to_Customer_Date__c = system.today();
        insert bid;

        Phoenix_Bid_Line_Item__c bidLine = new Phoenix_Bid_Line_Item__c();
        bidLine.Phoenix_Bid__c = bid.id;
        bidLine.Phoenix_Product__c = prod.Id;
        bidLine.Phoenix_Contract__c = cont.Id;
        bidLine.Phoenix_Bid_Status__c = '';
        bidLine.Phoenix_Proposed_Sales__c = 1000;
        bidLine.Phoenix_Current_Direct_Price__c = 100;
        insert bidLine;
        Phoenix_Bid_Line_Item__c bidLine12 = new Phoenix_Bid_Line_Item__c();
        bidLine12.Phoenix_Bid__c = bid.id;
        bidLine12.Phoenix_Product__c = prod.Id;
        bidLine12.Phoenix_Contract__c = cont.Id;
        bidLine12.Phoenix_Bid_Status__c = '';
        bidLine12.Phoenix_Proposed_Sales__c = 1000;
        bidLine12.Phoenix_Current_Direct_Price__c = 0;
        bidLine12.Phoenix_Current_Indirect_Price__c = 0;
        insert bidLine12;
        
        
        Phoenix_Bid__c bid31 = new Phoenix_Bid__c();
        bid31.Phoenix_Bid_Name__c = 'Test Bid3';
        bid31.Phoenix_Bid_Type__c = 'OTC New Product';
        bid31.Phoenix_Customer__c = acc.id;
        bid31.Phoenix_Approval_Status__c = 'Closed';
        bid31.Phoenix_Customer_Type__c = 'Net Indirect Pricing';
        bid31.Phoenix_Bid_Submitted_Date__c = system.today();
        bid31.Phoenix_Sent_to_Customer_Date__c = system.today();
        insert bid31;
        Phoenix_Bid_Line_Item__c bidLine31 = new Phoenix_Bid_Line_Item__c();
        bidLine31.Phoenix_Bid__c = bid31.id;
        bidLine31.Phoenix_Customer_Approval_OTC__c = '';
        bidLine31.Phoenix_Product__c = prod.Id;
        bidLine31.Phoenix_Contract__c = cont.Id;
        bidLine31.Phoenix_Bid_Status__c = '';
        bidLine31.Phoenix_Proposed_Sales__c = 1000;
        insert bidLine31;
        Phoenix_Bid_Line_Item__c bidLine41 = new Phoenix_Bid_Line_Item__c();
        bidLine41.Phoenix_Bid__c = bid31.id;
        bidLine41.Phoenix_Customer_Approval_OTC__c = 'Not Approved';
        bidLine41.Phoenix_Product__c = prod.Id;
        bidLine41.Phoenix_Contract__c = cont.Id;
        bidLine41.Phoenix_Bid_Status__c = 'Awarded';
        bidLine41.Phoenix_Proposed_Sales__c = 1000;
        insert bidLine41;
        
        Phoenix_Bid__c bid3 = new Phoenix_Bid__c();
        bid3.Phoenix_Bid_Name__c = 'Test Bid3';
        bid3.Phoenix_Bid_Type__c = 'OTC New Product';
        bid3.Phoenix_Customer__c = acc.id;
        bid3.Phoenix_Customer_Type__c = 'Net Indirect Pricing';
        bid3.OwnerId = u.Id;
        bid3.Phoenix_Approval_Status__c = 'Cus';
        bid3.Phoenix_Bid_Submitted_Date__c = system.today();
        bid3.Phoenix_Sent_to_Customer_Date__c = system.today();
        insert bid3;
        Phoenix_Bid_Line_Item__c bidLine3 = new Phoenix_Bid_Line_Item__c();
        bidLine3.Phoenix_Bid__c = bid3.id;
        bidLine3.Phoenix_Customer_Approval_OTC__c = '';
        bidLine3.Phoenix_Product__c = prod.Id;
        bidLine3.Phoenix_Contract__c = cont.Id;
        bidLine3.Phoenix_Bid_Status__c = 'Awarded';
        bidLine3.Phoenix_Proposed_Sales__c = 1000;
        insert bidLine3;
        Phoenix_Bid_Line_Item__c bidLine4 = new Phoenix_Bid_Line_Item__c();
        bidLine4.Phoenix_Bid__c = bid3.id;
        bidLine4.Phoenix_Customer_Approval_OTC__c = '';
        bidLine4.Phoenix_Product__c = prod.Id;
        bidLine4.Phoenix_Contract__c = cont.Id;
        bidLine4.Phoenix_Bid_Status__c = 'Awarded';
        bidLine4.Phoenix_Proposed_Sales__c = 1000;
        insert bidLine4;      
        
        List<String> selectedBidIds = new List<String>();
        selectedBidIds.add(bidLine.Id);
        selectedBidIds.add(bidLine31.Id);
        Phoenix_NPR_Data__c npr = new Phoenix_NPR_Data__c();
        npr.Phoenix_Account__c = acc.Id;
        npr.Phoenix_Contract__c = cont.Id;
        npr.Phoenix_Product__c = prod2.Id;
        npr.Phoenix_12Months_Sales_Unit__c = 40;
        npr.Phoenix_Dead_Net_Tracking_GR__c = 60;
        insert npr;
        List<String> selections = new List<String>{'Rx', 'SRx', 'OTC'};
        Date d1=Date.newInstance(2022,01,01);
        Date d2=Date.newInstance(2022,12,31);
        
        
        VisionSKUSummaryCls.getIMSMarketShare(bidLine.Id);
        VisionSKUSummaryCls.IMSData(selectedBidIds);
    }    
}