@isTest
public class Vision_COLO_Controller_Test {
    static testmethod void  test(){
        
        Product_Family__c prodFamily = new Product_Family__c();
        prodFamily.Name = 'Test Family';
        insert prodFamily;
        
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
        
        Date d1=Date.newInstance(2022,01,01);
        Date d2=Date.newInstance(2022,03,31);
        
        Phoenix_Customer_Response__c custResponse = new Phoenix_Customer_Response__c();
        insert custResponse;
        Phoenix_Customer_Response_Line__c custResponseLine = new Phoenix_Customer_Response_Line__c();
        custResponseLine.Phoenix_Customer_Response__c = custResponse.Id;
        insert custResponseLine;
        
        Phoenix_Bid__c bid = new Phoenix_Bid__c();
        bid.Phoenix_Bid_Name__c = 'Test Bid';
        bid.Phoenix_Bid_Type__c = 'Product Addition';
        bid.OwnerId = u.Id;
        bid.Phoenix_Customer_Type__c = 'Net Indirect Pricing';
        bid.Phoenix_Customer__c = acc.id;
        bid.Phoenix_Approval_Status__c = 'Closed';
        bid.Phoenix_Bid_Closed_Date__c = Date.newInstance(2022,02,01);
        bid.Phoenix_Bid_Submitted_Date__c = Date.newInstance(2022,01,01);
        bid.Phoenix_Sent_to_Customer_Date__c = Date.newInstance(2022,01,01);
        insert bid;

        Phoenix_Bid_Line_Item__c bidLine = new Phoenix_Bid_Line_Item__c();
        bidLine.Phoenix_Bid__c = bid.id;
        bidLine.Phoenix_Customer_Response_Line__c = custResponseLine.Id;
        bidLine.Phoenix_Product__c = prod.Id;
        bidLine.Phoenix_Contract__c = cont.Id;
        bidLine.Phoenix_Bid_Status__c = '';
        bidLine.Phoenix_Proposed_Sales__c = 1000;
        bidLine.Phoenix_Current_Direct_Price__c = 100;
        bidLine.Finance_Current_Sales__c = 100;
        insert bidLine;
        
        custResponse.Phoenix_Bid_No__c = bid.Id;
        upsert custResponse;
        
        custResponseLine.Phoenix_Bid__c = bid.Id;
        custResponseLine.Phoenix_Bid_Line_Item__c = bidLine.Id;
        custResponseLine.Phoenix_Bid_Status__c = 'Awarded';
        custResponseLine.Phoenix_Customer_Response__c = custResponse.Id;
        upsert custResponseLine;

        Phoenix_Customer_Response__c custResponse2 = new Phoenix_Customer_Response__c();
        insert custResponse2;
        Phoenix_Customer_Response_Line__c custResponseLine2 = new Phoenix_Customer_Response_Line__c();
        custResponseLine2.Phoenix_Customer_Response__c = custResponse2.Id;
        insert custResponseLine2;
        
        Phoenix_Bid__c bid2 = new Phoenix_Bid__c();
        bid2.Phoenix_Bid_Name__c = 'Test Bid';
        bid2.Phoenix_Bid_Type__c = 'New Product Launch';
        bid2.OwnerId = u.Id;
        bid2.Phoenix_Customer_Type__c = 'Net Indirect Pricing';
        bid2.Phoenix_Customer__c = acc.id;
        bid2.Phoenix_Approval_Status__c = 'Closed';
        bid2.Phoenix_Bid_Closed_Date__c = Date.newInstance(2022,02,01);
        bid2.Phoenix_Bid_Submitted_Date__c = Date.newInstance(2022,01,01);
        bid2.Phoenix_Sent_to_Customer_Date__c = Date.newInstance(2022,01,01);
        insert bid2;

        Phoenix_Bid_Line_Item__c bidLine2 = new Phoenix_Bid_Line_Item__c();
        bidLine2.Phoenix_Bid__c = bid2.id;
        bidLine2.Phoenix_Customer_Response_Line__c = custResponseLine2.Id;
        bidLine2.Phoenix_Product__c = prod.Id;
        bidLine2.Phoenix_Contract__c = cont.Id;
        bidLine2.Phoenix_Bid_Status__c = '';
        bidLine2.Phoenix_Proposed_Sales__c = 1000;
        bidLine2.Phoenix_Current_Direct_Price__c = 100;
        bidLine2.Finance_Current_Sales__c = 200;
        insert bidLine2;
        
        custResponse2.Phoenix_Bid_No__c = bid2.Id;
        upsert custResponse2;
        
        custResponseLine2.Phoenix_Bid__c = bid2.Id;
        custResponseLine2.Phoenix_Bid_Line_Item__c = bidLine2.Id;
        custResponseLine2.Phoenix_Bid_Status__c = 'Awarded';
        custResponseLine2.Phoenix_Customer_Response__c = custResponse2.Id;
        upsert custResponseLine2;

        
        Phoenix_Customer_Response__c custResponse3 = new Phoenix_Customer_Response__c();
        insert custResponse3;
        Phoenix_Customer_Response_Line__c custResponseLine3 = new Phoenix_Customer_Response_Line__c();
        custResponseLine3.Phoenix_Customer_Response__c = custResponse3.Id;
        insert custResponseLine3;
        
        Phoenix_Bid__c bid3 = new Phoenix_Bid__c();
        bid3.Phoenix_Bid_Name__c = 'Test Bid';
        bid3.Phoenix_Bid_Type__c = 'Price Change';
        bid3.OwnerId = u.Id;
        bid3.Phoenix_Customer_Type__c = 'Net Indirect Pricing';
        bid3.Phoenix_Customer__c = acc.id;
        bid3.Phoenix_Approval_Status__c = 'Closed';
        bid3.Phoenix_Bid_Closed_Date__c = Date.newInstance(2022,02,01);
        bid3.Phoenix_Bid_Submitted_Date__c = Date.newInstance(2022,01,01);
        bid3.Phoenix_Sent_to_Customer_Date__c = Date.newInstance(2022,01,01);
        insert bid3;
        
        Phoenix_Bid_Line_Item__c bidLine3 = new Phoenix_Bid_Line_Item__c();
        bidLine3.Phoenix_Bid__c = bid3.id;
        bidLine3.Phoenix_Customer_Response_Line__c = custResponseLine3.Id;
        bidLine3.Phoenix_Product__c = prod.Id;
        bidLine3.Phoenix_Contract__c = cont.Id;
        bidLine3.Phoenix_Bid_Status__c = '';
        bidLine3.Phoenix_Proposed_Sales__c = 1000;
        bidLine3.Phoenix_Current_Direct_Price__c = 100;
        bidLine3.Finance_Current_Sales__c = 200;
        insert bidLine3;
        
        custResponse3.Phoenix_Bid_No__c = bid3.Id;
        upsert custResponse3;
        
        custResponseLine3.Phoenix_Bid__c = bid3.Id;
        custResponseLine3.Phoenix_Bid_Line_Item__c = bidLine3.Id;
        custResponseLine3.Phoenix_Bid_Status__c = 'Awarded';
        custResponseLine3.Phoenix_Customer_Response__c = custResponse3.Id;
        upsert custResponseLine3;
        
        Supply_Issue__c supIssue = new Supply_Issue__c();
        supIssue.Product_Family__c = prodFamily.Id;
        insert supIssue;
        
        Vision_COLO_Controller.getDataBasedOnQuarter(new List<Integer> {1}, new List<Integer> {2022}, 'Rx', '');
        Vision_COLO_Controller.getDataBasedOnQuarter(new List<Integer> {1}, new List<Integer> {2022}, 'Rx+SRx', '');
        Vision_COLO_Controller.getDataBasedOnQuarter(new List<Integer> {1}, new List<Integer> {2022}, 'Rx+OTC', '');
        Vision_COLO_Controller.getDataBasedOnQuarter(new List<Integer> {1}, new List<Integer> {2022}, 'SRx+OTC', '');
        Vision_COLO_Controller.getDataBasedOnQuarter(new List<Integer> {1}, new List<Integer> {2022}, 'SRx', '');
        Vision_COLO_Controller.getDataBasedOnQuarter(new List<Integer> {1}, new List<Integer> {2022}, 'OTC', '');
        Vision_COLO_Controller.getDataBasedOnQuarter(new List<Integer> {1}, new List<Integer> {2022}, 'All', '');
        Vision_COLO_Controller.getDataBasedOnQuarter(new List<Integer> {2}, new List<Integer> {2022}, 'Rx', '');
        Vision_COLO_Controller.getDataBasedOnQuarter(new List<Integer> {2}, new List<Integer> {2022}, 'Rx+SRx', '');
        Vision_COLO_Controller.getDataBasedOnQuarter(new List<Integer> {2}, new List<Integer> {2022}, 'Rx+OTC', '');
        Vision_COLO_Controller.getDataBasedOnQuarter(new List<Integer> {2}, new List<Integer> {2022}, 'SRx+OTC', '');
        Vision_COLO_Controller.getDataBasedOnQuarter(new List<Integer> {2}, new List<Integer> {2022}, 'SRx', '');
        Vision_COLO_Controller.getDataBasedOnQuarter(new List<Integer> {2}, new List<Integer> {2022}, 'OTC', '');
        Vision_COLO_Controller.getDataBasedOnQuarter(new List<Integer> {2}, new List<Integer> {2022}, 'All', '');
        Vision_COLO_Controller.getUserName(u.Id);
        Vision_COLO_Controller.upsertRecords(supIssue);
        Vision_COLO_Controller.getExistingSupplyIssues(new List<String> {prodFamily.Name});
        //Vision_COLO_Controller.codeCoverage();
    }

}