@isTest
public class VisionBidAnalysisTestCls {
    static testmethod void  test(){
        Account acc = new Account();
        acc.Name = 'Test Account';
        insert acc;
        Product2 prod = new Product2();
        prod.Name = 'Test Product';
        prod.ProductCode = '1234567';
        insert prod;    
        Product2 prod2 = new Product2();
        prod2.Name = 'Test Product2';
        prod2.ProductCode = '1234568';
        insert prod2; 
        
        Phoenix_Contract__c cont = new Phoenix_Contract__c();
        cont.Name = 'Test';
        cont.Phoenix_Contract_Number__c = '1234';
        cont.Phoenix_Customer__c = acc.Id;
        insert cont;
        
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
        bid.Phoenix_Bid_Submitted_Date__c = system.today();
        bid.Phoenix_Sent_to_Customer_Date__c = system.today();
        insert bid;
        Phoenix_Bid_Line_Item__c bidLine = new Phoenix_Bid_Line_Item__c();
        bidLine.Phoenix_Bid__c = bid.id;
        bidLine.Phoenix_Customer_Response_Line__c = crLine.Id;
        bidLine.Phoenix_Product__c = prod.Id;
        bidLine.Phoenix_Contract__c = cont.Id;
        bidLine.Phoenix_Bid_Status__c = 'Pending';
        bidLine.Phoenix_Proposed_Sales__c = 1000;
        bidLine.Phoenix_Final_Status__c = '';
        insert bidLine;
        Phoenix_BidLineItemExtn__c bidExtnObj = new Phoenix_BidLineItemExtn__c();
        bidExtnObj.Phoenix_Bid_Line_Item__c = bidLine.Id;
        bidExtnObj.Vision_Category__c = 'No Effect';
        insert bidExtnObj;
        
        Phoenix_Customer_Response__c custResponse = new Phoenix_Customer_Response__c();
        custResponse.Phoenix_Customer_Response_Date__c = system.today();
        custResponse.Phoenix_Bid_No__c = bid.Id;
        insert custResponse;
        Phoenix_Customer_Response_Line__c custResponseLine = new Phoenix_Customer_Response_Line__c();
        custResponseLine.Phoenix_Bid__c = bid.Id;
        custResponseLine.Phoenix_Bid_Line_Item__c = bidLine.Id;
        custResponseLine.Bid_Line_Item_Extn__c = bidExtnObj.Id;
        custResponseLine.Phoenix_Bid_Status__c = 'Awarded';
        custResponseLine.Phoenix_Customer_Response__c = custResponse.Id;
        custResponseLine.Phoenix_Supply_Effective_Date__c = system.today();
        insert custResponseLine;
        
        Phoenix_Bid__c bid2 = new Phoenix_Bid__c();
        bid2.Phoenix_Bid_Name__c = 'Test Bid2';
        bid2.Phoenix_Bid_Type__c = 'Product Discontinuation Process';
        bid2.Phoenix_Customer__c = acc.id;
        bid2.Phoenix_Approval_Status__c = 'Closed';
        bid2.Phoenix_Bid_Submitted_Date__c = system.today();
        bid2.Phoenix_Sent_to_Customer_Date__c = system.today();
        insert bid2;
        Phoenix_Bid_Line_Item__c bidLine2 = new Phoenix_Bid_Line_Item__c();
        bidLine2.Phoenix_Bid__c = bid2.id;
        bidLine2.Phoenix_Customer_Response_Line__c = crLine.Id;
        bidLine2.Phoenix_Product__c = prod.Id;
        bidLine2.Phoenix_Bid_Status__c = 'Awarded';
        bidLine2.Phoenix_Proposed_Sales__c = 1000;
        insert bidLine2;
        Phoenix_BidLineItemExtn__c bidExtnObj2 = new Phoenix_BidLineItemExtn__c();
        bidExtnObj2.Phoenix_Bid_Line_Item__c = bidLine2.Id;
        bidExtnObj2.Vision_Category__c = 'No Effect';
        insert bidExtnObj2;
        Phoenix_Bid__c bid3 = new Phoenix_Bid__c();
        bid3.Phoenix_Bid_Name__c = 'Test Bid3';
        bid3.Phoenix_Bid_Type__c = 'OTC New Product';
        bid3.Phoenix_Customer__c = acc.id;
        bid3.Phoenix_Approval_Status__c = 'Closed';
        bid3.Phoenix_Customer_Type__c = 'Net Indirect Pricing';
        bid3.Phoenix_Bid_Submitted_Date__c = system.today();
        bid3.Phoenix_Sent_to_Customer_Date__c = system.today();
        insert bid3;
        Phoenix_Bid_Line_Item__c bidLine3 = new Phoenix_Bid_Line_Item__c();
        bidLine3.Phoenix_Bid__c = bid3.id;
        bidLine3.Phoenix_Customer_Response_Line__c = crLine.Id;
        bidLine3.Phoenix_Customer_Approval_OTC__c = '';
        bidLine3.Phoenix_Product__c = prod.Id;
        bidLine3.Phoenix_Contract__c = cont.Id;
        bidLine3.Phoenix_Bid_Status__c = 'Awarded';
        bidLine3.Phoenix_Proposed_Sales__c = 1000;
        insert bidLine3;
        Phoenix_Bid_Line_Item__c bidLine4 = new Phoenix_Bid_Line_Item__c();
        bidLine4.Phoenix_Bid__c = bid3.id;
        bidLine4.Phoenix_Customer_Response_Line__c = crLine.Id;
        bidLine4.Phoenix_Customer_Approval_OTC__c = 'Not Approved';
        bidLine4.Phoenix_Product__c = prod.Id;
        bidLine4.Phoenix_Contract__c = cont.Id;
        bidLine4.Phoenix_Bid_Status__c = 'Awarded';
        bidLine4.Phoenix_Proposed_Sales__c = 1000;
        insert bidLine4;
        Phoenix_BidLineItemExtn__c bidExtnObj3 = new Phoenix_BidLineItemExtn__c();
        bidExtnObj3.Phoenix_Bid_Line_Item__c = bidLine3.Id;
        bidExtnObj3.Vision_Category__c = 'No Effect';
        insert bidExtnObj3;
        Phoenix_BidLineItemExtn__c bidExtnObj4 = new Phoenix_BidLineItemExtn__c();
        bidExtnObj4.Phoenix_Bid_Line_Item__c = bidLine4.Id;
        bidExtnObj4.Vision_Category__c = 'No Effect';
        insert bidExtnObj4;        
        
        Phoenix_Bid__c bid4 = new Phoenix_Bid__c();
        bid4.Phoenix_Bid_Name__c = 'Test Bid3';
        bid4.Phoenix_Bid_Type__c = 'OTC New Product';
        bid4.Phoenix_Customer__c = acc.id;
        bid4.Phoenix_Approval_Status__c = 'Closed';
        bid4.Phoenix_Bid_Submitted_Date__c = system.today();
        bid4.Phoenix_Sent_to_Customer_Date__c = system.today();
        insert bid4;
        Phoenix_Bid_Line_Item__c bidLine11 = new Phoenix_Bid_Line_Item__c();
        bidLine11.Phoenix_Bid__c = bid4.id;
        bidLine11.Phoenix_Customer_Response_Line__c = crLine.Id;
        bidLine11.Phoenix_Customer_Approval_OTC__c = 'Not Approved';
        bidLine11.Phoenix_Product__c = prod.Id;
        bidLine11.Phoenix_Contract__c = cont.Id;
        bidLine11.Phoenix_Bid_Status__c = 'Awarded';
        bidLine11.Phoenix_Proposed_Sales__c = 1000;
        insert bidLine11;
        
        Phoenix_NPR_Data__c npr = new Phoenix_NPR_Data__c();
        npr.Phoenix_Account__c = acc.Id;
        npr.Phoenix_Contract__c = cont.Id;
        npr.Phoenix_Product__c = prod2.Id;
        npr.Phoenix_12Months_Sales_Unit__c = 40;
        npr.Phoenix_Dead_Net_Tracking_GR__c = 60;
        insert npr;
        
        VisionBidAnalysisCls.getData(bid.Id);
        VisionBidAnalysisCls.getData(bid2.Id);
        VisionBidAnalysisCls.getData(bid3.Id);
        VisionBidAnalysisCls.getData(bid4.Id);
        VisionBidAnalysisCls.testCoverage();
        //VisionBidAnalysisCls.getSearchRelatedData('Bid2');
        //VisionBidAnalysisCls.getSelectedData(bid.Id);
    }
    static testmethod void  test2(){
        Account acc = new Account();
        acc.Name = 'Test Account';
        insert acc;
        Product2 prod = new Product2();
        prod.Name = 'Test Product';
        prod.ProductCode = '1234567';
        insert prod;    
        Product2 prod2 = new Product2();
        prod2.Name = 'Test Product2';
        prod2.ProductCode = '1234568';
        insert prod2; 
        
        Phoenix_Contract__c cont = new Phoenix_Contract__c();
        cont.Name = 'Test';
        cont.Phoenix_Contract_Number__c = '1234';
        cont.Phoenix_Customer__c = acc.Id;
        insert cont;
        
        Phoenix_Bid__c bid5 = new Phoenix_Bid__c();
        bid5.Phoenix_Bid_Name__c = 'Test Bid';
        bid5.Phoenix_Bid_Type__c = 'Product Addition';
        bid5.Phoenix_Customer_Type__c = 'BASE/DSH';
        bid5.Phoenix_Customer__c = acc.id;
        bid5.Phoenix_Approval_Status__c = 'Closed';
        bid5.Phoenix_Bid_Submitted_Date__c = system.today();
        bid5.Phoenix_Sent_to_Customer_Date__c = system.today();
        insert bid5;
        Phoenix_Bid_Line_Item__c bidLine5 = new Phoenix_Bid_Line_Item__c();
        bidLine5.Phoenix_Bid__c = bid5.id;
        bidLine5.Phoenix_Product__c = prod.Id;
        bidLine5.Phoenix_Contract__c = cont.Id;
        bidLine5.Phoenix_Bid_Status__c = 'Awarded';
        bidLine5.Phoenix_Proposed_Sales__c = 1000;
        insert bidLine5;
        Phoenix_BidLineItemExtn__c bidExtnObj5 = new Phoenix_BidLineItemExtn__c();
        bidExtnObj5.Phoenix_Bid_Line_Item__c = bidLine5.Id;
        bidExtnObj5.Vision_Category__c = 'No Effect';
        insert bidExtnObj5;
        
        Phoenix_Customer_Response__c custResponse5 = new Phoenix_Customer_Response__c();
        custResponse5.Phoenix_Bid_No__c = bid5.Id;
        insert custResponse5;
        Phoenix_Customer_Response_Line__c custResponseLine5 = new Phoenix_Customer_Response_Line__c();
        custResponseLine5.Phoenix_Bid__c = bid5.Id;
        custResponseLine5.Phoenix_Bid_Line_Item__c = bidLine5.Id;
        custResponseLine5.Bid_Line_Item_Extn__c = bidExtnObj5.Id;
        custResponseLine5.Phoenix_Bid_Status__c = 'Awarded';
        custResponseLine5.Phoenix_Customer_Response__c = custResponse5.Id;
        custResponseLine5.Phoenix_Price_Effective_Date__c = system.today();
        insert custResponseLine5;
        
        
        Phoenix_NPR_Data__c npr = new Phoenix_NPR_Data__c();
        npr.Phoenix_Account__c = acc.Id;
        npr.Phoenix_Contract__c = cont.Id;
        npr.Phoenix_Product__c = prod2.Id;
        npr.Phoenix_12Months_Sales_Unit__c = 40;
        npr.Phoenix_Dead_Net_Tracking_GR__c = 60;
        insert npr;
        
        VisionBidAnalysisCls.getData(bid5.Id);
    }
    static testmethod void  test3(){
        Account acc = new Account();
        acc.Name = 'Test Account';
        insert acc;
        Product2 prod = new Product2();
        prod.Name = 'Test Product';
        prod.ProductCode = '1234567';
        insert prod;    
        Product2 prod2 = new Product2();
        prod2.Name = 'Test Product2';
        prod2.ProductCode = '1234568';
        insert prod2; 
        
        Phoenix_Contract__c cont = new Phoenix_Contract__c();
        cont.Name = 'Test';
        cont.Phoenix_Contract_Number__c = '1234';
        cont.Phoenix_Customer__c = acc.Id;
        insert cont;
        
        Phoenix_Bid__c bid6 = new Phoenix_Bid__c();
        bid6.Phoenix_Bid_Name__c = 'Test Bid';
        bid6.Phoenix_Bid_Type__c = 'Product Addition';
        bid6.Phoenix_Customer_Type__c = 'ROS';
        bid6.Phoenix_Customer__c = acc.id;
        bid6.Phoenix_Approval_Status__c = 'Closed';
        bid6.Phoenix_Bid_Submitted_Date__c = system.today();
        bid6.Phoenix_Sent_to_Customer_Date__c = system.today();
        insert bid6;
        Phoenix_Bid_Line_Item__c bidLine6 = new Phoenix_Bid_Line_Item__c();
        bidLine6.Phoenix_Bid__c = bid6.id;
        bidLine6.Phoenix_Product__c = prod.Id;
        bidLine6.Phoenix_Contract__c = cont.Id;
        bidLine6.Phoenix_Bid_Status__c = 'Awarded';
        bidLine6.Phoenix_Proposed_Sales__c = 1000;
        insert bidLine6;
        Phoenix_BidLineItemExtn__c bidExtnObj6 = new Phoenix_BidLineItemExtn__c();
        bidExtnObj6.Phoenix_Bid_Line_Item__c = bidLine6.Id;
        bidExtnObj6.Vision_Category__c = 'No Effect';
        insert bidExtnObj6;
        
        Phoenix_Customer_Response__c custResponse6 = new Phoenix_Customer_Response__c();
        custResponse6.Phoenix_Bid_No__c = bid6.Id;
        insert custResponse6;
        Phoenix_Customer_Response_Line__c custResponseLine6 = new Phoenix_Customer_Response_Line__c();
        custResponseLine6.Phoenix_Bid__c = bid6.Id;
        custResponseLine6.Phoenix_Bid_Line_Item__c = bidLine6.Id;
        custResponseLine6.Bid_Line_Item_Extn__c = bidExtnObj6.Id;
        custResponseLine6.Phoenix_Bid_Status__c = 'Awarded';
        custResponseLine6.Phoenix_Customer_Response__c = custResponse6.Id;
        insert custResponseLine6;
        
        
        Phoenix_NPR_Data__c npr = new Phoenix_NPR_Data__c();
        npr.Phoenix_Account__c = acc.Id;
        npr.Phoenix_Contract__c = cont.Id;
        npr.Phoenix_Product__c = prod2.Id;
        npr.Phoenix_12Months_Sales_Unit__c = 40;
        npr.Phoenix_Dead_Net_Tracking_GR__c = 60;
        insert npr;
        
        VisionBidAnalysisCls.getData(bid6.Id);
    }
    static testmethod void  test4(){
        Account acc = new Account();
        acc.Name = 'Test Account';
        insert acc;
        Product2 prod = new Product2();
        prod.Name = 'Test Product';
        prod.ProductCode = '1234567';
        insert prod;    
        Product2 prod2 = new Product2();
        prod2.Name = 'Test Product2';
        prod2.ProductCode = '1234568';
        insert prod2; 
        
        Phoenix_Contract__c cont = new Phoenix_Contract__c();
        cont.Name = 'Test';
        cont.Phoenix_Contract_Number__c = '1234';
        cont.Phoenix_Customer__c = acc.Id;
        insert cont;
                
        
        Phoenix_Bid__c bid7 = new Phoenix_Bid__c();
        bid7.Phoenix_Bid_Name__c = 'Test Bid';
        bid7.Phoenix_Bid_Type__c = 'Product Addition';
        bid7.Phoenix_Customer_Type__c = 'RXSS';
        bid7.Phoenix_Customer__c = acc.id;
        bid7.Phoenix_Approval_Status__c = 'Closed';
        bid7.Phoenix_Bid_Submitted_Date__c = system.today();
        bid7.Phoenix_Sent_to_Customer_Date__c = system.today();
        insert bid7;
        Phoenix_Bid_Line_Item__c bidLine7 = new Phoenix_Bid_Line_Item__c();
        bidLine7.Phoenix_Bid__c = bid7.id;
        bidLine7.Phoenix_Product__c = prod.Id;
        bidLine7.Phoenix_Contract__c = cont.Id;
        bidLine7.Phoenix_Bid_Status__c = 'Awarded';
        bidLine7.Phoenix_Proposed_Sales__c = 1000;
        insert bidLine7;
        Phoenix_BidLineItemExtn__c bidExtnObj7 = new Phoenix_BidLineItemExtn__c();
        bidExtnObj7.Phoenix_Bid_Line_Item__c = bidLine7.Id;
        bidExtnObj7.Vision_Category__c = 'No Effect';
        insert bidExtnObj7;
        
        Phoenix_Customer_Response__c custResponse7 = new Phoenix_Customer_Response__c();
        custResponse7.Phoenix_Bid_No__c = bid7.Id;
        insert custResponse7;
        Phoenix_Customer_Response_Line__c custResponseLine7 = new Phoenix_Customer_Response_Line__c();
        custResponseLine7.Phoenix_Bid__c = bid7.Id;
        custResponseLine7.Phoenix_Bid_Line_Item__c = bidLine7.Id;
        custResponseLine7.Bid_Line_Item_Extn__c = bidExtnObj7.Id;
        custResponseLine7.Phoenix_Bid_Status__c = 'Awarded';
        custResponseLine7.Phoenix_Customer_Response__c = custResponse7.Id;
        insert custResponseLine7;
        
        
        Phoenix_NPR_Data__c npr = new Phoenix_NPR_Data__c();
        npr.Phoenix_Account__c = acc.Id;
        npr.Phoenix_Contract__c = cont.Id;
        npr.Phoenix_Product__c = prod2.Id;
        npr.Phoenix_12Months_Sales_Unit__c = 40;
        npr.Phoenix_Dead_Net_Tracking_GR__c = 60;
        insert npr;
        
        VisionBidAnalysisCls.getData(bid7.Id);
        
    }
    
    static testmethod void  test5(){
        Account acc = new Account();
        acc.Name = 'Test Account';
        insert acc;
        Product2 prod = new Product2();
        prod.Name = 'Test Product';
        prod.ProductCode = '1234567';
        insert prod;    
        Product2 prod2 = new Product2();
        prod2.Name = 'Test Product2';
        prod2.ProductCode = '1234568';
        insert prod2; 
        
        Phoenix_Contract__c cont = new Phoenix_Contract__c();
        cont.Name = 'Test';
        cont.Phoenix_Contract_Number__c = '1234';
        cont.Phoenix_Customer__c = acc.Id;
        insert cont;
                
        
        Phoenix_Bid__c bid7 = new Phoenix_Bid__c();
        bid7.Phoenix_Bid_Name__c = 'Test Bid';
        bid7.Phoenix_Bid_Type__c = 'Product Addition';
        bid7.Phoenix_Customer_Type__c = 'ClarusOne';
        bid7.Phoenix_Customer__c = acc.id;
        bid7.Phoenix_Approval_Status__c = 'Closed';
        bid7.Phoenix_Bid_Submitted_Date__c = system.today();
        bid7.Phoenix_Sent_to_Customer_Date__c = system.today();
        insert bid7;
        Phoenix_Bid_Line_Item__c bidLine7 = new Phoenix_Bid_Line_Item__c();
        bidLine7.Phoenix_Bid__c = bid7.id;
        bidLine7.Phoenix_Product__c = prod.Id;
        bidLine7.Phoenix_Contract__c = cont.Id;
        bidLine7.Phoenix_Bid_Status__c = 'Awarded';
        bidLine7.Phoenix_Proposed_Sales__c = 1000;
        insert bidLine7;
        Phoenix_BidLineItemExtn__c bidExtnObj7 = new Phoenix_BidLineItemExtn__c();
        bidExtnObj7.Phoenix_Bid_Line_Item__c = bidLine7.Id;
        bidExtnObj7.Vision_Category__c = 'No Effect';
        insert bidExtnObj7;
        
        Phoenix_Customer_Response__c custResponse7 = new Phoenix_Customer_Response__c();
        custResponse7.Phoenix_Bid_No__c = bid7.Id;
        insert custResponse7;
        Phoenix_Customer_Response_Line__c custResponseLine7 = new Phoenix_Customer_Response_Line__c();
        custResponseLine7.Phoenix_Bid__c = bid7.Id;
        custResponseLine7.Phoenix_Bid_Line_Item__c = bidLine7.Id;
        custResponseLine7.Bid_Line_Item_Extn__c = bidExtnObj7.Id;
        custResponseLine7.Phoenix_Bid_Status__c = 'Awarded';
        custResponseLine7.Phoenix_Customer_Response__c = custResponse7.Id;
        insert custResponseLine7;
        
        
        Phoenix_NPR_Data__c npr = new Phoenix_NPR_Data__c();
        npr.Phoenix_Account__c = acc.Id;
        npr.Phoenix_Contract__c = cont.Id;
        npr.Phoenix_Product__c = prod2.Id;
        npr.Phoenix_12Months_Sales_Unit__c = 40;
        npr.Phoenix_Dead_Net_Tracking_GR__c = 60;
        insert npr;
        
        VisionBidAnalysisCls.getData(bid7.Id);
        
    }
    
    static testmethod void  test6(){
        Account acc = new Account();
        acc.Name = 'Test Account';
        insert acc;
        Product2 prod = new Product2();
        prod.Name = 'Test Product';
        prod.ProductCode = '1234567';
        insert prod;    
        Product2 prod2 = new Product2();
        prod2.Name = 'Test Product2';
        prod2.ProductCode = '1234568';
        insert prod2; 
        
        Phoenix_Contract__c cont = new Phoenix_Contract__c();
        cont.Name = 'Test';
        cont.Phoenix_Contract_Number__c = '1234';
        cont.Phoenix_Customer__c = acc.Id;
        insert cont;
                
        
        Phoenix_Bid__c bid7 = new Phoenix_Bid__c();
        bid7.Phoenix_Bid_Name__c = 'Test Bid';
        bid7.Phoenix_Bid_Type__c = 'Product Addition';
        bid7.Phoenix_Customer_Type__c = 'Sams Club';
        bid7.Phoenix_Customer__c = acc.id;
        bid7.Phoenix_Approval_Status__c = 'Closed';
        bid7.Phoenix_Bid_Submitted_Date__c = system.today();
        bid7.Phoenix_Sent_to_Customer_Date__c = system.today();
        insert bid7;
        Phoenix_Bid_Line_Item__c bidLine7 = new Phoenix_Bid_Line_Item__c();
        bidLine7.Phoenix_Bid__c = bid7.id;
        bidLine7.Phoenix_Product__c = prod.Id;
        bidLine7.Phoenix_Contract__c = cont.Id;
        bidLine7.Phoenix_Bid_Status__c = 'Awarded';
        bidLine7.Phoenix_Proposed_Sales__c = 1000;
        insert bidLine7;
        Phoenix_BidLineItemExtn__c bidExtnObj7 = new Phoenix_BidLineItemExtn__c();
        bidExtnObj7.Phoenix_Bid_Line_Item__c = bidLine7.Id;
        bidExtnObj7.Vision_Category__c = 'No Effect';
        insert bidExtnObj7;
        
        Phoenix_Customer_Response__c custResponse7 = new Phoenix_Customer_Response__c();
        custResponse7.Phoenix_Bid_No__c = bid7.Id;
        insert custResponse7;
        Phoenix_Customer_Response_Line__c custResponseLine7 = new Phoenix_Customer_Response_Line__c();
        custResponseLine7.Phoenix_Bid__c = bid7.Id;
        custResponseLine7.Phoenix_Bid_Line_Item__c = bidLine7.Id;
        custResponseLine7.Bid_Line_Item_Extn__c = bidExtnObj7.Id;
        custResponseLine7.Phoenix_Bid_Status__c = 'Awarded';
        custResponseLine7.Phoenix_Customer_Response__c = custResponse7.Id;
        insert custResponseLine7;
        
        
        Phoenix_NPR_Data__c npr = new Phoenix_NPR_Data__c();
        npr.Phoenix_Account__c = acc.Id;
        npr.Phoenix_Contract__c = cont.Id;
        npr.Phoenix_Product__c = prod2.Id;
        npr.Phoenix_12Months_Sales_Unit__c = 40;
        npr.Phoenix_Dead_Net_Tracking_GR__c = 60;
        insert npr;
        
        VisionBidAnalysisCls.getData(bid7.Id);
        
    }
    
    static testmethod void  test7(){
        Account acc = new Account();
        acc.Name = 'Test Account';
        insert acc;
        Product2 prod = new Product2();
        prod.Name = 'Test Product';
        prod.ProductCode = '1234567';
        insert prod;    
        Product2 prod2 = new Product2();
        prod2.Name = 'Test Product2';
        prod2.ProductCode = '1234568';
        insert prod2; 
        
        Phoenix_Contract__c cont = new Phoenix_Contract__c();
        cont.Name = 'Test';
        cont.Phoenix_Contract_Number__c = '1234';
        cont.Phoenix_Customer__c = acc.Id;
        insert cont;
                
        
        Phoenix_Bid__c bid7 = new Phoenix_Bid__c();
        bid7.Phoenix_Bid_Name__c = 'Test Bid';
        bid7.Phoenix_Bid_Type__c = 'Product Addition';
        bid7.Phoenix_Customer_Type__c = 'Humana Indirect retail';
        bid7.Phoenix_Customer__c = acc.id;
        bid7.Phoenix_Approval_Status__c = 'Closed';
        bid7.Phoenix_Bid_Submitted_Date__c = system.today();
        bid7.Phoenix_Sent_to_Customer_Date__c = system.today();
        insert bid7;
        Phoenix_Bid_Line_Item__c bidLine7 = new Phoenix_Bid_Line_Item__c();
        bidLine7.Phoenix_Bid__c = bid7.id;
        bidLine7.Phoenix_Product__c = prod.Id;
        bidLine7.Phoenix_Contract__c = cont.Id;
        bidLine7.Phoenix_Bid_Status__c = 'Awarded';
        bidLine7.Phoenix_Proposed_Sales__c = 1000;
        insert bidLine7;
        Phoenix_BidLineItemExtn__c bidExtnObj7 = new Phoenix_BidLineItemExtn__c();
        bidExtnObj7.Phoenix_Bid_Line_Item__c = bidLine7.Id;
        bidExtnObj7.Vision_Category__c = 'No Effect';
        insert bidExtnObj7;
        
        Phoenix_Customer_Response__c custResponse7 = new Phoenix_Customer_Response__c();
        custResponse7.Phoenix_Bid_No__c = bid7.Id;
        insert custResponse7;
        Phoenix_Customer_Response_Line__c custResponseLine7 = new Phoenix_Customer_Response_Line__c();
        custResponseLine7.Phoenix_Bid__c = bid7.Id;
        custResponseLine7.Phoenix_Bid_Line_Item__c = bidLine7.Id;
        custResponseLine7.Bid_Line_Item_Extn__c = bidExtnObj7.Id;
        custResponseLine7.Phoenix_Bid_Status__c = 'Awarded';
        custResponseLine7.Phoenix_Customer_Response__c = custResponse7.Id;
        insert custResponseLine7;
        
        
        Phoenix_NPR_Data__c npr = new Phoenix_NPR_Data__c();
        npr.Phoenix_Account__c = acc.Id;
        npr.Phoenix_Contract__c = cont.Id;
        npr.Phoenix_Product__c = prod2.Id;
        npr.Phoenix_12Months_Sales_Unit__c = 40;
        npr.Phoenix_Dead_Net_Tracking_GR__c = 60;
        insert npr;
        
        VisionBidAnalysisCls.getData(bid7.Id);
        
    }
    
}