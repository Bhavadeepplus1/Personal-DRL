@isTest
public class Vision_ProductAnalysisTestCls {
    @isTest
    public static void getProductAnalysisData1(){
        /*Phoenix_Bid__c bid1 = new Phoenix_Bid__c();
bid1.Phoenix_Bid_Type__c = 'RFP Bids';
INSERT bid1;*/
        Account acc = new Account();
        acc.name='test';
        INSERT acc;
        
        Vision_ProductAnalysisCls.getProductAnalysisData(System.today()-10,system.today(),acc.Id,'Custom');
        //Vision_ProductAnalysisCls.coverageBlock();
    }
    @isTest
    public static void getProductAnalysisData2(){
        
        Account acc = new Account();
        acc.name='test';
        INSERT acc;
        
        Vision_ProductAnalysisCls.getProductAnalysisData(System.today()-10,system.today(),null,'Custom');
        
    }
    @isTest
    public static void getProductAnalysisData3(){
        Account acc = new Account();
        acc.name='test';
        INSERT acc;
        Phoenix_Bid__c bid = new Phoenix_Bid__c(
Phoenix_Bid_Type__c='Product Addition'        
        );
        
        insert bid;
      //  Product2 prod = new Product2();
        
       // insert prod;
        Phoenix_Customer_Response_Line__c cusRes = new Phoenix_Customer_Response_Line__c(
       // Phoenix_Customer_Response_Date__c = System.today()
        );
        
        insert cusRes;
        Phoenix_Bid_Line_Item__c bidLineItem = new Phoenix_Bid_Line_Item__c();
        bidLineItem.Phoenix_Bid__c = bid.Id;  
        //bidLineItem.Phoenix_Product__c = prod.Id;
        bidLineItem.Phoenix_Awarded_Quantity__c=2;
      //  bidLineItem.Phoenix_Customer_Response__c='Test5';
        bidLineItem.Phoenix_Price_Effective_Date__c=system.today();
      //  bidLineItem.Phoenix_Product__r.Name='Demo1';
        bidLineItem.Phoenix_Bid_Status__c='Awarded';
        bidLineItem.Phoenix_Proposed_Sales__c=3;
        bidLineItem.Phoenix_Customer_Response_Line__c = cusRes.Id;
        insert bidLineItem;
        
        
        Vision_ProductAnalysisCls.getProductAnalysisData(System.today()-10,system.today(),acc.Id,'Custom');
        
    }
    @isTest
    public static void getProductAnalysisData(){
        Phoenix_Bid__c bid1 = new Phoenix_Bid__c();
        bid1.Phoenix_Bid_Type__c = 'RFP Bids';
        INSERT bid1;
        Phoenix_Bid_Line_Item__c obj = new Phoenix_Bid_Line_Item__c();
        obj.Phoenix_Bid__c=bid1.Id;
        
        INSERT obj;
        //Vision_ProductAnalysisCls.getProductAnalysisData(obj.Id);
        Vision_ProductAnalysisCls.coverageBlock();
    }
    
}