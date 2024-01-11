@isTest 
public class Phoenix_BidItemHandlerRxSSTest {
    @testSetup static void setupTestData() {
        Account testAccount = new Account(Name = 'Test Account', Phoenix_Customer_Class_Bid_Template__c = 'RXSS');
        insert testAccount;
        Phoenix_Bid__c pb = new Phoenix_Bid__c();
        pb.Phoenix_Status__c = 'New';
        pb.Phoenix_Bid_Type__c = 'RFP Bids';
        pb.Phoenix_Comments__c = 'Test Comments';
        pb.Phoenix_Customer__c = testAccount.Id;
        //	pb.Phoenix_Customer_Bid_Deadline_Date_Time__c = DateTime.now();
        pb.Phoenix_Customer_Bid_Deadline_Time_zone__c = 'PST';
        pb.Phoenix_Customer_Bid_Deadline_Time__c = '6 PM';
        pb.Phoenix_Customer_Type__c = 'ClarusOne';
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
        update bl;
        
    }
    static testmethod void getBid2() {
        Phoenix_Bid_Line_Item__c bl = [SELECT Id from Phoenix_Bid_Line_Item__c WHERE Phoenix_Final_Status__c = 'Approved'];
        bl.Phoenix_Proposed_Indirect_Selling_Unit__c = 10;
        bl.Phoenix_Proposed_Direct_Selling_Unit__c = 10;
        bl.Phoenix_SCM_Approval_Y_N__c = 'Y- Only Current Monthly Demand Approved';
        update bl;
    }
   /* static testmethod void getBid3() {
        Phoenix_Bid_Line_Item__c bl = [SELECT Id from Phoenix_Bid_Line_Item__c WHERE Phoenix_Final_Status__c = 'Approved'];
        bl.Phoenix_Proposed_Direct_Selling_Unit__c = 10;
        bl.Phoenix_Proposed_Indirect_Selling_Unit__c=10;
        bl.Phoenix_Proposed_Direct_Selling_Unit__c=10;
        //update bl;
    }
    */static testmethod void getBid4() {
        Phoenix_Bid_Line_Item__c bl = [SELECT Id from Phoenix_Bid_Line_Item__c WHERE Phoenix_Final_Status__c = 'Approved'];
        bl.Phoenix_Proposed_Direct_Selling_Unit__c = 10;
        bl.Phoenix_SCM_Approval_Y_N__c = 'Y- Current + Inc Demand Approved';
        update bl;
    }
    static testmethod void getBid5() {
        Phoenix_Bid_Line_Item__c bl = [SELECT Id from Phoenix_Bid_Line_Item__c WHERE Phoenix_Final_Status__c = 'Approved'];
        bl.Phoenix_Proposed_Indirect_Selling_Unit__c = 10;
        bl.Phoenix_SCM_Approval_Y_N__c = 'Y- Current + Inc Demand Approved';
        update bl;
    }
    static testmethod void getBid6() {
        Phoenix_Bid_Line_Item__c bl = [SELECT Id from Phoenix_Bid_Line_Item__c WHERE Phoenix_Final_Status__c = 'Approved'];
        bl.Phoenix_SCM_Final_Approval__c = false;
        //  bl.Phoenix_Gross_Contract_Sales__c=10;
        //  bl.Phoenix_Value_Rebate__c=10;
        update bl;
    }
    

}