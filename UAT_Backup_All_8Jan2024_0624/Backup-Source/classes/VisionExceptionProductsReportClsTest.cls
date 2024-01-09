@isTest
public class VisionExceptionProductsReportClsTest {
    static testmethod void  test(){
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User u = new User(Alias = 'standt', Email='testmmm@testorg.com', EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='America/Los_Angeles', UserName='testmmm@testorg.com', Division='Rx');
        insert u;
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.Owner = u;
        insert acc;
        Product_Family__c pf = new Product_Family__c();
        pf.Name = 'Test Family';
        insert pf;
        Product_Family__c pf1 = new Product_Family__c();
        pf1.Name = 'Test Family2';
        insert pf1;
        Product_Family__c pf2 = new Product_Family__c();
        pf2.Name = 'Test Family3';
        insert pf2;
        Product2 prod = new Product2();
        prod.Name = 'Test Product';
        prod.ProductCode = '1234567';
        prod.Phoenix_Rx_SRx_OTC__c = 'Rx';
        prod.Family = 'Test Family';
        prod.Product_Family__c = pf.Id;
        prod.Phoenix_Is_Exclude_Bid__c = false;
        prod.IsActive = true;
        insert prod;    
        Product2 prod2 = new Product2();
        prod2.Name = 'Test Product2';
        prod2.ProductCode = '1234568';
        prod2.Phoenix_Rx_SRx_OTC__c = 'SRx';
        prod2.Family = 'Test Family2';
        prod2.Product_Family__c = pf1.Id;
        prod2.Phoenix_Is_Exclude_Bid__c = false;
        prod2.IsActive = true;
        insert prod2;
        Product2 prod3 = new Product2();
        prod3.Name = 'Test Product3';
        prod3.ProductCode = '1234569';
        prod3.Phoenix_Rx_SRx_OTC__c = 'OTC';
        prod3.Family = 'Test Family3';
        prod3.Product_Family__c = pf2.Id;
        prod3.Phoenix_Is_Exclude_Bid__c = false;
        prod3.IsActive = true;
        insert prod3;
        Product2 prod4 = new Product2();
        prod4.Name = 'Test Product4';
        prod4.ProductCode = '1234570';
        prod4.Phoenix_Rx_SRx_OTC__c = 'Rx';
        prod4.Family = 'Test Family3';
        prod4.Product_Family__c = pf2.Id;
        prod4.Phoenix_Is_Exclude_Bid__c = false;
        prod4.IsActive = true;
        insert prod4;
        Product2 prod5 = new Product2();
        prod5.Name = 'Test Product5';
        prod5.ProductCode = '1234571';
        prod5.Phoenix_Rx_SRx_OTC__c = 'SRx';
        prod5.Family = 'Test Family3';
        prod5.Product_Family__c = pf2.Id;
        prod5.Phoenix_Is_Exclude_Bid__c = false;
        prod5.IsActive = true;
        insert prod5;
        
        Phoenix_Customer_Response_Line__c crLine = new Phoenix_Customer_Response_Line__c();
        crLine.Phoenix_Award_Position__c = 'P1';
        //crLine.Customer_Response_Duration__r= system.today();
        insert crLine;
        
        Phoenix_Bid__c bid = new Phoenix_Bid__c();
        bid.Phoenix_Bid_Name__c = 'Test Bid';
        bid.Phoenix_Bid_Type__c = 'Product Addition';
        bid.Phoenix_Customer_Type__c = 'Net Indirect Pricing';
        bid.Phoenix_Customer__c = acc.id;
        bid.Phoenix_Approval_Status__c = 'Customer\'s Update';
        bid.Phoenix_Bid_Submitted_Date__c = system.today()-5;
        bid.Phoenix_Sent_to_Customer_Date__c = system.today()-2;
        insert bid;

        Phoenix_Bid_Line_Item__c bidLine = new Phoenix_Bid_Line_Item__c();
        bidLine.Phoenix_Bid__c = bid.id;
        bidLine.Phoenix_Customer_Response_Line__c = crLine.Id;
        bidLine.Phoenix_Product__c = prod.Id;
        bidLine.Product_Family__c = prod.Product_Family__c;
        insert bidLine;
        
        Phoenix_Bid__c bid2 = new Phoenix_Bid__c();
        bid2.Phoenix_Bid_Name__c = 'Test Bid';
        bid2.Phoenix_Bid_Type__c = 'Product Addition';
        bid2.Phoenix_Customer_Type__c = 'Net Indirect Pricing';
        bid2.Phoenix_Customer__c = acc.id;
        bid2.Phoenix_Approval_Status__c = 'Customer\'s Update';
        bid2.Phoenix_Bid_Submitted_Date__c = system.today()-5;
        bid2.Phoenix_Sent_to_Customer_Date__c = system.today()-2;
        insert bid2;

        Phoenix_Bid_Line_Item__c bidLine2 = new Phoenix_Bid_Line_Item__c();
        bidLine2.Phoenix_Bid__c = bid2.id;
        bidLine2.Phoenix_Customer_Response_Line__c = crLine.Id;
        bidLine2.Phoenix_Product__c = prod2.Id; 
        bidLine2.Product_Family__c = prod2.Product_Family__c;
        insert bidLine2;
        
        Phoenix_Bid__c bid3 = new Phoenix_Bid__c();
        bid3.Phoenix_Bid_Name__c = 'Test Bid';
        bid3.Phoenix_Bid_Type__c = 'Product Addition';
        bid3.Phoenix_Customer_Type__c = 'Net Indirect Pricing';
        bid3.Phoenix_Customer__c = acc.id;
        bid3.Phoenix_Approval_Status__c = 'Customer\'s Update';
        bid3.Phoenix_Bid_Submitted_Date__c = system.today()-20;
        bid3.Phoenix_Sent_to_Customer_Date__c = system.today()-15;
        insert bid3;

        Phoenix_Bid_Line_Item__c bidLine3 = new Phoenix_Bid_Line_Item__c();
        bidLine3.Phoenix_Bid__c = bid3.id;
        bidLine3.Phoenix_Customer_Response_Line__c = crLine.Id;
        bidLine3.Phoenix_Product__c = prod4.Id; 
        bidLine3.Product_Family__c = prod4.Product_Family__c;
        insert bidLine3;
        
        Phoenix_Bid__c bid4 = new Phoenix_Bid__c();
        bid4.Phoenix_Bid_Name__c = 'Test Bid';
        bid4.Phoenix_Bid_Type__c = 'Product Addition';
        bid4.Phoenix_Customer_Type__c = 'Net Indirect Pricing';
        bid4.Phoenix_Customer__c = acc.id;
        bid4.Phoenix_Approval_Status__c = 'Customer\'s Update';
        bid4.Phoenix_Bid_Submitted_Date__c = system.today()-20;
        bid4.Phoenix_Sent_to_Customer_Date__c = system.today()-15;
        insert bid4;

        Phoenix_Bid_Line_Item__c bidLine4 = new Phoenix_Bid_Line_Item__c();
        bidLine4.Phoenix_Bid__c = bid4.id;
        bidLine4.Phoenix_Customer_Response_Line__c = crLine.Id;
        bidLine4.Phoenix_Product__c = prod5.Id; 
        bidLine4.Product_Family__c = prod5.Product_Family__c;
        insert bidLine4;
        
        Date d1 = system.today()-5;
        Date d2 = system.today();
        List<String> selections = new List<String>{'Rx', 'SRx', 'OTC'};
        VisionExceptionProductsReportCls.getData(d1, d2, selections);
    }
}