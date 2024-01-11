@isTest 
public class Phoenix_BidItemHandlerROSTest {
    @testSetup static void setupTestData() {
        try{
               Account testAccount = new Account(Name = 'Test Account', Phoenix_Customer_Class_Bid_Template__c = 'ROS');
        insert testAccount;
        Phoenix_Bid__c pb = new Phoenix_Bid__c();
        pb.Phoenix_Status__c = 'New';
        pb.Phoenix_Bid_Type__c = 'IPA Floor Pricing Update';
        pb.Phoenix_Comments__c = 'Test Comments';
        pb.Phoenix_Customer__c = testAccount.Id;
        pb.Phoenix_Customer_Bid_Deadline_Time_zone__c = 'PST';
        pb.Phoenix_Customer_Bid_Deadline_Time__c = '6 PM';
        pb.Phoenix_Customer_Type__c = 'ROS';
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
        bl.Phoenix_SCM_Approval_Y_N__c = 'Y- Only Current Monthly Demand Approved';
        bl.Phoenix_Final_Direct_Selling_Units_Calc__c = 10;
        bl.Phoenix_Final_Indirect_Selling_Units_Cal__c = 10;
        bl.Phoenix_Estimated_Medicaid_Returns__c = 120.0;
        insert bl;
        
        Phoenix_BidLineItemExtn__c bliExtn1 = new Phoenix_BidLineItemExtn__c();
        bliExtn1.Phoenix_Bid_Line_Item__c = bl.Id;
        insert bliExtn1;
        }
        catch(exception e){}
            
    }
    static testmethod void getBid1() {
  
        Phoenix_Bid_Line_Item__c bl1 = [SELECT Id from Phoenix_Bid_Line_Item__c WHERE Phoenix_Final_Status__c = 'Approved'];
        bl1.Phoenix_Proposed_Indirect_Selling_Unit__c = 12;
        bl1.Phoenix_Final_Status__c = 'Approved';
        bl1.Phoenix_SCM_Final_Approval__c = false;
        bl1.Phoenix_Proposed_Direct_Selling_Unit__c=10;
    }
    static testmethod void getBid2() {
        Phoenix_Bid_Line_Item__c bl = [SELECT Id from Phoenix_Bid_Line_Item__c WHERE Phoenix_Final_Status__c = 'Approved'];
        bl.Phoenix_Proposed_Indirect_Selling_Unit__c = 10;
        bl.Phoenix_Proposed_Direct_Selling_Unit__c = 10;
        bl.Phoenix_SCM_Approval_Y_N__c = 'Y- Only Current Monthly Demand Approved';
        update bl;
    }
   static testmethod void getBid4() {
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
        update bl;
    }
      static testmethod void getBid7() {
        Phoenix_Bid_Line_Item__c bl = [SELECT Id from Phoenix_Bid_Line_Item__c WHERE Phoenix_Final_Status__c = 'Approved'];
        bl.Phoenix_Proposed_Indirect_Selling_Unit__c = 10;
        bl.Phoenix_Proposed_Direct_Selling_Unit__c = 10;
        bl.Phoenix_SCM_Approval_Y_N__c = 'Y- Current + Inc Demand Approved';
        update bl;
          Phoenix_BidLineItemExtn__c bliExtn1 = new Phoenix_BidLineItemExtn__c();
        bliExtn1.Phoenix_Bid_Line_Item__c = bl.Id;
       
           bliExtn1.Phoenix_Proposed_CVS_DirSellingUnits__c=10;
               insert bliExtn1;  
    }
}