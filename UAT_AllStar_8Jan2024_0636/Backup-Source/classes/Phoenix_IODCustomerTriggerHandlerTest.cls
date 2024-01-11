@isTest
public class Phoenix_IODCustomerTriggerHandlerTest {
	 @testSetup static void setupTestData() {
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        Phoenix_Bid__c pb = new Phoenix_Bid__c();
        pb.Phoenix_Status__c = 'New';
        pb.Phoenix_Bid_Type__c = 'Initial Order Discount for WAC Customers (No-Contract Price Offering)';
        pb.Phoenix_Comments__c = 'Test Comments';
        pb.Phoenix_Customer__c = testAccount.Id;
        //	pb.Phoenix_Customer_Bid_Deadline_Date_Time__c = DateTime.now();
        pb.Phoenix_Customer_Bid_Deadline_Time_zone__c = 'PST';
        pb.Phoenix_Customer_Bid_Deadline_Time__c = '6 PM';
        //pb.Phoenix_Customer_Type__c = 'Econdisc';
        pb.Phoenix_Bid_Deadline_Date__c = System.today();
        insert pb;
        Product2 prod1 = new Product2(Name = 'Test Product', Family = 'Test Family', IsActive = TRUE, ProductCode = '324');
        prod1.Phoenix_Product_Director__c = UserInfo.getUserId();
        prod1.Phoenix_Marketing_Lead__c = UserInfo.getUserId();
        insert prod1;
        Phoenix_Bid_Line_Item__c bl = new Phoenix_Bid_Line_Item__c();
        bl.Phoenix_Bid__c = pb.Id;
        bl.Phoenix_Current_Direct_Price__c = 10;
        bl.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        bl.Phoenix_Product__c = prod1.id;
        bl.Phoenix_Final_Status__c = 'Approved';
        bl.Phoenix_SCM_Final_Approval__c = true;
        bl.Phoenix_Final_Direct_Selling_Units_Calc__c = 10;
        bl.Phoenix_Final_Indirect_Selling_Units_Cal__c = 10;
        bl.Phoenix_Estimated_Medicaid_Returns__c = 120.0;
        //  bl.Phoenix_SCM_Approval_Y_N__c = 'Y- Current + Inc Demand Approved';
        insert bl;
    }
    static testmethod void getBid1() {
        Phoenix_Bid_Line_Item__c bl = [SELECT Id from Phoenix_Bid_Line_Item__c WHERE Phoenix_Final_Status__c = 'Approved' LIMIT 1];
        bl.Phoenix_Proposed_Indirect_Selling_Unit__c = 12;
        // bl.Phoenix_Bid_Template_Refrence__c='ABC Progen';
        //bl.Phoenix_Proposed_Indirect_Selling_Unit__c=10;
         bl.Phoenix_Final_Status__c = 'Approved';
        bl.Phoenix_SCM_Final_Approval__c = true;
        bl.Phoenix_Proposed_Direct_Selling_Unit__c=10;
        //update bl;
        
    }
    static testmethod void getBid2() {
        Phoenix_Bid_Line_Item__c bl = [SELECT Id from Phoenix_Bid_Line_Item__c WHERE Phoenix_Final_Status__c = 'Approved'];
        bl.Phoenix_Proposed_Indirect_Selling_Unit__c = 10;
        bl.Phoenix_Proposed_Direct_Selling_Unit__c = 10;
        bl.Phoenix_SCM_Approval_Y_N__c = 'Y- Only Current Monthly Demand Approved';
        update bl;
    }
}