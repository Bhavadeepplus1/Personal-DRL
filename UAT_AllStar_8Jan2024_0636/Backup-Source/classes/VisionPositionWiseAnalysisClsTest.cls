@isTest
public class VisionPositionWiseAnalysisClsTest {
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

        Phoenix_Bid__c bid = new Phoenix_Bid__c();
        bid.Phoenix_Bid_Name__c = 'Test Bid';
        bid.Phoenix_Bid_Type__c = 'RFP Bids';
        bid.OwnerId = u.Id;
        bid.Phoenix_Customer__c = acc.id;
        bid.Phoenix_Approval_Status__c = 'Closed';
        bid.Phoenix_Bid_Submitted_Date__c = system.today();
        bid.Phoenix_Sent_to_Customer_Date__c = system.today();
        insert bid;

        Phoenix_Bid_Line_Item__c bidLine = new Phoenix_Bid_Line_Item__c();
        bidLine.Phoenix_Bid__c = bid.id;
        bidLine.Phoenix_Product__c = prod.Id;
        bidLine.Phoenix_Bid_Status__c = '';
        bidLine.Phoenix_Proposed_Sales__c = 1000;
        bidLine.Phoenix_Current_Direct_Price__c = 0;
        bidLine.Phoenix_Current_Indirect_Price__c = 0;
        insert bidLine;
        
        Phoenix_Customer_Response__c custResponse = new Phoenix_Customer_Response__c();
        custResponse.Phoenix_Bid_No__c = bid.Id;
        insert custResponse;
        
        Phoenix_Customer_Response_Line__c custResponseLine = new Phoenix_Customer_Response_Line__c();
        custResponseLine.Phoenix_Bid__c = bid.Id;
        custResponseLine.Phoenix_Bid_Line_Item__c = bidLine.Id;
        custResponseLine.Phoenix_Bid_Status__c = 'Declined by Customer';
        custResponseLine.Phoenix_Customer_Response__c = custResponse.Id;
        custResponseLine.General_Category__c = 'Primary';
        insert custResponseLine;
        bidLine.Phoenix_Customer_Response_Line__c = custResponseLine.Id;
        upsert bidLine;
        
        List<String> bids = new List<String> {bid.Id};
        
        VisionPositionWiseAnalysisCls.getData(bids);
        VisionPositionWiseAnalysisCls.getRFPBids(bid.Phoenix_Bid_Name__c);
    }
    
    static testmethod void  test2(){
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

        Phoenix_Bid__c bid = new Phoenix_Bid__c();
        bid.Phoenix_Bid_Name__c = 'Test Bid';
        bid.Phoenix_Bid_Type__c = 'RFP Bids';
        bid.OwnerId = u.Id;
        bid.Phoenix_Customer__c = acc.id;
        bid.Phoenix_Approval_Status__c = 'Closed';
        bid.Phoenix_Bid_Submitted_Date__c = system.today();
        bid.Phoenix_Sent_to_Customer_Date__c = system.today();
        insert bid;

        Phoenix_Bid_Line_Item__c bidLine = new Phoenix_Bid_Line_Item__c();
        bidLine.Phoenix_Bid__c = bid.id;
        bidLine.Phoenix_Product__c = prod.Id;
        bidLine.Phoenix_Bid_Status__c = '';
        bidLine.Phoenix_Proposed_Sales__c = 1000;
        bidLine.Phoenix_Current_Direct_Price__c = 0;
        bidLine.Phoenix_Current_Indirect_Price__c = 0;
        insert bidLine;
        
        Phoenix_Customer_Response__c custResponse = new Phoenix_Customer_Response__c();
        custResponse.Phoenix_Bid_No__c = bid.Id;
        insert custResponse;
        
        Phoenix_Customer_Response_Line__c custResponseLine = new Phoenix_Customer_Response_Line__c();
        custResponseLine.Phoenix_Bid__c = bid.Id;
        custResponseLine.Phoenix_Bid_Line_Item__c = bidLine.Id;
        custResponseLine.Phoenix_Bid_Status__c = 'Awarded';
        custResponseLine.Phoenix_Customer_Response__c = custResponse.Id;
        custResponseLine.General_Category__c = 'Primary';
        custResponseLine.Awarded_General_Category__c = 'Primary';
        insert custResponseLine;
        bidLine.Phoenix_Customer_Response_Line__c = custResponseLine.Id;
        upsert bidLine;
        
        List<String> bids = new List<String> {bid.Id};
        
        VisionPositionWiseAnalysisCls.getData(bids);
        VisionPositionWiseAnalysisCls.getRFPBids(bid.Phoenix_Bid_Name__c);
    }
    
    static testmethod void  test3(){
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

        Phoenix_Bid__c bid = new Phoenix_Bid__c();
        bid.Phoenix_Bid_Name__c = 'Test Bid';
        bid.Phoenix_Bid_Type__c = 'RFP Bids';
        bid.OwnerId = u.Id;
        bid.Phoenix_Customer__c = acc.id;
        bid.Phoenix_Approval_Status__c = 'Closed';
        bid.Phoenix_Bid_Submitted_Date__c = system.today();
        bid.Phoenix_Sent_to_Customer_Date__c = system.today();
        insert bid;

        Phoenix_Bid_Line_Item__c bidLine = new Phoenix_Bid_Line_Item__c();
        bidLine.Phoenix_Bid__c = bid.id;
        bidLine.Phoenix_Product__c = prod.Id;
        bidLine.Phoenix_Bid_Status__c = '';
        bidLine.Phoenix_Proposed_Sales__c = 1000;
        bidLine.Phoenix_Current_Direct_Price__c = 0;
        bidLine.Phoenix_Current_Indirect_Price__c = 0;
        insert bidLine;
        
        Phoenix_Customer_Response__c custResponse = new Phoenix_Customer_Response__c();
        custResponse.Phoenix_Bid_No__c = bid.Id;
        insert custResponse;
        
        Phoenix_Customer_Response_Line__c custResponseLine = new Phoenix_Customer_Response_Line__c();
        custResponseLine.Phoenix_Bid__c = bid.Id;
        custResponseLine.Phoenix_Bid_Line_Item__c = bidLine.Id;
        custResponseLine.Phoenix_Bid_Status__c = 'Awarded';
        custResponseLine.Phoenix_Customer_Response__c = custResponse.Id;
        custResponseLine.General_Category__c = 'Backup';
        custResponseLine.Awarded_General_Category__c = 'Primary';
        insert custResponseLine;
        bidLine.Phoenix_Customer_Response_Line__c = custResponseLine.Id;
        upsert bidLine;
        
        List<String> bids = new List<String> {bid.Id};
        
        VisionPositionWiseAnalysisCls.getData(bids);
        VisionPositionWiseAnalysisCls.getRFPBids(bid.Phoenix_Bid_Name__c);
    }
    static testmethod void  test4(){
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

        Phoenix_Bid__c bid = new Phoenix_Bid__c();
        bid.Phoenix_Bid_Name__c = 'Test Bid';
        bid.Phoenix_Bid_Type__c = 'RFP Bids';
        bid.OwnerId = u.Id;
        bid.Phoenix_Customer__c = acc.id;
        bid.Phoenix_Approval_Status__c = 'Closed';
        bid.Phoenix_Bid_Submitted_Date__c = system.today();
        bid.Phoenix_Sent_to_Customer_Date__c = system.today();
        insert bid;

        Phoenix_Bid_Line_Item__c bidLine = new Phoenix_Bid_Line_Item__c();
        bidLine.Phoenix_Bid__c = bid.id;
        bidLine.Phoenix_Product__c = prod.Id;
        bidLine.Phoenix_Bid_Status__c = '';
        bidLine.Phoenix_Proposed_Sales__c = 1000;
        bidLine.Phoenix_Current_Direct_Price__c = 0;
        bidLine.Phoenix_Current_Indirect_Price__c = 0;
        insert bidLine;
        
        Phoenix_Customer_Response__c custResponse = new Phoenix_Customer_Response__c();
        custResponse.Phoenix_Bid_No__c = bid.Id;
        insert custResponse;
        
        Phoenix_Customer_Response_Line__c custResponseLine = new Phoenix_Customer_Response_Line__c();
        custResponseLine.Phoenix_Bid__c = bid.Id;
        custResponseLine.Phoenix_Bid_Line_Item__c = bidLine.Id;
        custResponseLine.Phoenix_Bid_Status__c = 'Awarded';
        custResponseLine.Phoenix_Customer_Response__c = custResponse.Id;
        custResponseLine.General_Category__c = 'Backup';
        custResponseLine.Awarded_General_Category__c = 'Backup';
        insert custResponseLine;
        bidLine.Phoenix_Customer_Response_Line__c = custResponseLine.Id;
        upsert bidLine;
        
        List<String> bids = new List<String> {bid.Id};
        
        VisionPositionWiseAnalysisCls.getData(bids);
        VisionPositionWiseAnalysisCls.getRFPBids(bid.Phoenix_Bid_Name__c);
    }
    static testmethod void  test5(){
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

        Phoenix_Bid__c bid = new Phoenix_Bid__c();
        bid.Phoenix_Bid_Name__c = 'Test Bid';
        bid.Phoenix_Bid_Type__c = 'RFP Bids';
        bid.OwnerId = u.Id;
        bid.Phoenix_Customer__c = acc.id;
        bid.Phoenix_Approval_Status__c = 'Closed';
        bid.Phoenix_Bid_Submitted_Date__c = system.today();
        bid.Phoenix_Sent_to_Customer_Date__c = system.today();
        insert bid;

        Phoenix_Bid_Line_Item__c bidLine = new Phoenix_Bid_Line_Item__c();
        bidLine.Phoenix_Bid__c = bid.id;
        bidLine.Phoenix_Product__c = prod.Id;
        bidLine.Phoenix_Bid_Status__c = '';
        bidLine.Phoenix_Proposed_Sales__c = 1000;
        bidLine.Phoenix_Current_Direct_Price__c = 0;
        bidLine.Phoenix_Current_Indirect_Price__c = 0;
        insert bidLine;
        
        Phoenix_Customer_Response__c custResponse = new Phoenix_Customer_Response__c();
        custResponse.Phoenix_Bid_No__c = bid.Id;
        insert custResponse;
        
        Phoenix_Customer_Response_Line__c custResponseLine = new Phoenix_Customer_Response_Line__c();
        custResponseLine.Phoenix_Bid__c = bid.Id;
        custResponseLine.Phoenix_Bid_Line_Item__c = bidLine.Id;
        custResponseLine.Phoenix_Bid_Status__c = 'Declined by Customer';
        custResponseLine.Phoenix_Customer_Response__c = custResponse.Id;
        custResponseLine.General_Category__c = 'Backup';
        insert custResponseLine;
        bidLine.Phoenix_Customer_Response_Line__c = custResponseLine.Id;
        upsert bidLine;
        
        List<String> bids = new List<String> {bid.Id};
        
        VisionPositionWiseAnalysisCls.getData(bids);
        VisionPositionWiseAnalysisCls.getRFPBids(bid.Phoenix_Bid_Name__c);
    }
    
    static testmethod void  test6(){
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

        Phoenix_Bid__c bid = new Phoenix_Bid__c();
        bid.Phoenix_Bid_Name__c = 'Test Bid';
        bid.Phoenix_Bid_Type__c = 'RFP Bids';
        bid.OwnerId = u.Id;
        bid.Phoenix_Customer__c = acc.id;
        bid.Phoenix_Approval_Status__c = 'Closed';
        bid.Phoenix_Bid_Submitted_Date__c = system.today();
        bid.Phoenix_Sent_to_Customer_Date__c = system.today();
        insert bid;

        Phoenix_Bid_Line_Item__c bidLine = new Phoenix_Bid_Line_Item__c();
        bidLine.Phoenix_Bid__c = bid.id;
        bidLine.Phoenix_Product__c = prod.Id;
        bidLine.Phoenix_Bid_Status__c = '';
        bidLine.Phoenix_Proposed_Sales__c = 1000;
        bidLine.Phoenix_Current_Direct_Price__c = 0;
        bidLine.Phoenix_Current_Indirect_Price__c = 0;
        insert bidLine;
        
        Phoenix_Customer_Response__c custResponse = new Phoenix_Customer_Response__c();
        custResponse.Phoenix_Bid_No__c = bid.Id;
        insert custResponse;
        
        Phoenix_Customer_Response_Line__c custResponseLine = new Phoenix_Customer_Response_Line__c();
        custResponseLine.Phoenix_Bid__c = bid.Id;
        custResponseLine.Phoenix_Bid_Line_Item__c = bidLine.Id;
        custResponseLine.Phoenix_Bid_Status__c = 'Declined by Customer';
        custResponseLine.Phoenix_Customer_Response__c = custResponse.Id;
        insert custResponseLine;
        bidLine.Phoenix_Customer_Response_Line__c = custResponseLine.Id;
        upsert bidLine;
        
        List<String> bids = new List<String> {bid.Id};
        
        VisionPositionWiseAnalysisCls.getData(bids);
        VisionPositionWiseAnalysisCls.getRFPBids(bid.Phoenix_Bid_Name__c);
    }
    
    static testmethod void  test7(){
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

        Phoenix_Bid__c bid = new Phoenix_Bid__c();
        bid.Phoenix_Bid_Name__c = 'Test Bid';
        bid.Phoenix_Bid_Type__c = 'RFP Bids';
        bid.OwnerId = u.Id;
        bid.Phoenix_Customer__c = acc.id;
        bid.Phoenix_Approval_Status__c = 'Closed';
        bid.Phoenix_Bid_Submitted_Date__c = system.today();
        bid.Phoenix_Sent_to_Customer_Date__c = system.today();
        insert bid;

        Phoenix_Bid_Line_Item__c bidLine = new Phoenix_Bid_Line_Item__c();
        bidLine.Phoenix_Bid__c = bid.id;
        bidLine.Phoenix_Product__c = prod.Id;
        bidLine.Phoenix_Bid_Status__c = '';
        bidLine.Phoenix_Proposed_Sales__c = 1000;
        bidLine.Phoenix_Current_Direct_Price__c = 0;
        bidLine.Phoenix_Current_Indirect_Price__c = 0;
        insert bidLine;
        
        Phoenix_Customer_Response__c custResponse = new Phoenix_Customer_Response__c();
        custResponse.Phoenix_Bid_No__c = bid.Id;
        insert custResponse;
        
        Phoenix_Customer_Response_Line__c custResponseLine = new Phoenix_Customer_Response_Line__c();
        custResponseLine.Phoenix_Bid__c = bid.Id;
        custResponseLine.Phoenix_Bid_Line_Item__c = bidLine.Id;
        custResponseLine.Phoenix_Bid_Status__c = 'Awarded';
        custResponseLine.Phoenix_Customer_Response__c = custResponse.Id;
        //custResponseLine.General_Category__c = 'Backup';
        custResponseLine.Awarded_General_Category__c = 'Backup';
        insert custResponseLine;
        bidLine.Phoenix_Customer_Response_Line__c = custResponseLine.Id;
        upsert bidLine;
        
        List<String> bids = new List<String> {bid.Id};
        
        VisionPositionWiseAnalysisCls.getData(bids);
        VisionPositionWiseAnalysisCls.getRFPBids(bid.Phoenix_Bid_Name__c);
    }
    
    static testmethod void  test8(){
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

        Phoenix_Bid__c bid = new Phoenix_Bid__c();
        bid.Phoenix_Bid_Name__c = 'Test Bid';
        bid.Phoenix_Bid_Type__c = 'RFP Bids';
        bid.OwnerId = u.Id;
        bid.Phoenix_Customer__c = acc.id;
        bid.Phoenix_Approval_Status__c = 'Closed';
        bid.Phoenix_Bid_Submitted_Date__c = system.today();
        bid.Phoenix_Sent_to_Customer_Date__c = system.today();
        insert bid;

        Phoenix_Bid_Line_Item__c bidLine = new Phoenix_Bid_Line_Item__c();
        bidLine.Phoenix_Bid__c = bid.id;
        bidLine.Phoenix_Product__c = prod.Id;
        bidLine.Phoenix_Bid_Status__c = '';
        bidLine.Phoenix_Proposed_Sales__c = 1000;
        bidLine.Phoenix_Current_Direct_Price__c = 0;
        bidLine.Phoenix_Current_Indirect_Price__c = 0;
        insert bidLine;
        
        Phoenix_Customer_Response__c custResponse = new Phoenix_Customer_Response__c();
        custResponse.Phoenix_Bid_No__c = bid.Id;
        insert custResponse;
        
        Phoenix_Customer_Response_Line__c custResponseLine = new Phoenix_Customer_Response_Line__c();
        custResponseLine.Phoenix_Bid__c = bid.Id;
        custResponseLine.Phoenix_Bid_Line_Item__c = bidLine.Id;
        custResponseLine.Phoenix_Bid_Status__c = 'Awarded';
        custResponseLine.Phoenix_Customer_Response__c = custResponse.Id;
        //custResponseLine.General_Category__c = 'Backup';
        custResponseLine.Awarded_General_Category__c = 'Primary';
        insert custResponseLine;
        bidLine.Phoenix_Customer_Response_Line__c = custResponseLine.Id;
        upsert bidLine;
        
        List<String> bids = new List<String> {bid.Id};
        
        VisionPositionWiseAnalysisCls.getData(bids);
        VisionPositionWiseAnalysisCls.getRFPBids(bid.Phoenix_Bid_Name__c);
    }
}