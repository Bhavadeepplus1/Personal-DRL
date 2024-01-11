@isTest
public class Phoenix_bidLineExtnUpdateTest {
    @testSetup static void setupTestData() {
        Account testAccount = new Account(Name = 'Test Account', Phoenix_Customer_Class_Bid_Template__c = 'Walgreens');
        insert testAccount;
        Phoenix_Bid__c pb = new Phoenix_Bid__c();
        pb.Phoenix_Status__c = 'New';
        pb.Phoenix_Bid_Type__c = 'IPA Floor Pricing Update';
        pb.Phoenix_Comments__c = 'Test Comments';
        pb.Phoenix_Customer__c = testAccount.Id;
        //	pb.Phoenix_Customer_Bid_Deadline_Date_Time__c = DateTime.now();
        pb.Phoenix_Customer_Bid_Deadline_Time_zone__c = 'PST';
        pb.Phoenix_Customer_Bid_Deadline_Time__c = '6 PM';
        pb.Phoenix_Customer_Type__c = 'Direct and Indirect';
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
        bl.Phoenix_Proposed_Indirect_Selling_Unit__c=10;
        bl.Phoenix_Proposed_Direct_Selling_Unit__c=10;
        //bl.Phoenix_Total_SCM_Approved_Qty__c=10;
        insert bl;
        
        
        Phoenix_BidLineItemExtn__c bliExtn2 = new Phoenix_BidLineItemExtn__c();
        bliExtn2.Phoenix_Bid_Line_Item__c = bl.Id;
        bliExtn2.Phoenix_Proposed_CVS_DirSellingUnits__c = 10000;
        bliExtn2.Phoenix_Proposed_CVS_IndirSellingUnits__c = 12000;
        bliExtn2.Phoenix_Proposed_Major_Units__c = 14000;
        insert bliExtn2;
        
    }
    static testmethod void getBid() {
        Phoenix_Bid_Line_Item__c bl = [SELECT Id from Phoenix_Bid_Line_Item__c WHERE Phoenix_Final_Status__c = 'Approved'];
        bl.Phoenix_Current_Direct_Selling_Unit__c = 10;
        bl.Phoenix_SCM_Approval_Y_N__c = 'Y- Only Current Monthly Demand Approved';
        
        update bl;
        
        Phoenix_BidLineItemExtn__c bliExtn2 = [SELECT Id, Phoenix_Proposed_CVS_DirSellingUnits__c from Phoenix_BidLineItemExtn__c WHERE Phoenix_Proposed_CVS_DirSellingUnits__c = 10000 LIMIT 1];
        bliExtn2.Phoenix_Proposed_CVS_DirSellingUnits__c = 20000;
        update bliExtn2;
    }
    static testmethod void getBid1() {
        Phoenix_Bid_Line_Item__c bl = [SELECT Id from Phoenix_Bid_Line_Item__c WHERE Phoenix_Final_Status__c = 'Approved'];
        bl.Phoenix_Proposed_Indirect_Selling_Unit__c = 12;
        bl.Phoenix_Final_Status__c = 'Approved';
        bl.Phoenix_SCM_Final_Approval__c = true;
        bl.Phoenix_Proposed_Direct_Selling_Unit__c=10;
        update bl;
        Phoenix_BidLineItemExtn__c bliExtn2 = [SELECT Id, Phoenix_Proposed_CVS_DirSellingUnits__c from Phoenix_BidLineItemExtn__c WHERE Phoenix_Proposed_CVS_DirSellingUnits__c = 10000 LIMIT 1];
        bliExtn2.Phoenix_Proposed_CVS_DirSellingUnits__c = 20000;
        update bliExtn2;
    }
    static testmethod void getBid2() {
        Phoenix_Bid_Line_Item__c bl = [SELECT Id from Phoenix_Bid_Line_Item__c WHERE Phoenix_Final_Status__c = 'Approved'];
        bl.Phoenix_Proposed_Indirect_Selling_Unit__c = 10;
        bl.Phoenix_Proposed_Direct_Selling_Unit__c = 10;
        bl.Phoenix_SCM_Approval_Y_N__c = 'Y- Only Current Monthly Demand Approved';
        update bl;
        Phoenix_BidLineItemExtn__c bliExtn2 = [SELECT Id, Phoenix_Proposed_CVS_DirSellingUnits__c from Phoenix_BidLineItemExtn__c WHERE Phoenix_Proposed_CVS_DirSellingUnits__c = 10000 LIMIT 1];
        bliExtn2.Phoenix_Proposed_CVS_DirSellingUnits__c = 20000;
        update bliExtn2;
    }
    
    static testmethod void getBid4() {
        Phoenix_Bid_Line_Item__c bl = [SELECT Id from Phoenix_Bid_Line_Item__c WHERE Phoenix_Final_Status__c = 'Approved'];
        bl.Phoenix_Proposed_Direct_Selling_Unit__c = 10;
        bl.Phoenix_SCM_Approval_Y_N__c = 'Y- Current + Inc Demand Approved';
        update bl;
        Phoenix_BidLineItemExtn__c bliExtn2 = [SELECT Id, Phoenix_Proposed_CVS_DirSellingUnits__c from Phoenix_BidLineItemExtn__c WHERE Phoenix_Proposed_CVS_DirSellingUnits__c = 10000 LIMIT 1];
        bliExtn2.Phoenix_Proposed_CVS_DirSellingUnits__c = 20000;
        update bliExtn2;
    }
    static testmethod void getBid5() {
        Phoenix_Bid_Line_Item__c bl = [SELECT Id from Phoenix_Bid_Line_Item__c WHERE Phoenix_Final_Status__c = 'Approved'];
        bl.Phoenix_Proposed_Indirect_Selling_Unit__c = 10;
        bl.Phoenix_SCM_Approval_Y_N__c = 'Y- Current + Inc Demand Approved';
        update bl;
        Phoenix_BidLineItemExtn__c bliExtn2 = [SELECT Id, Phoenix_Proposed_CVS_DirSellingUnits__c from Phoenix_BidLineItemExtn__c WHERE Phoenix_Proposed_CVS_DirSellingUnits__c = 10000 LIMIT 1];
        bliExtn2.Phoenix_Proposed_CVS_DirSellingUnits__c = 20000;
        update bliExtn2;
    }
    static testmethod void getBid6() {
        Phoenix_Bid_Line_Item__c bl = [SELECT Id from Phoenix_Bid_Line_Item__c WHERE Phoenix_Final_Status__c = 'Approved'];
        bl.Phoenix_SCM_Final_Approval__c = false;
        update bl;
        Phoenix_BidLineItemExtn__c bliExtn2 = [SELECT Id, Phoenix_Proposed_CVS_DirSellingUnits__c from Phoenix_BidLineItemExtn__c WHERE Phoenix_Proposed_CVS_DirSellingUnits__c = 10000 LIMIT 1];
        bliExtn2.Phoenix_Proposed_CVS_DirSellingUnits__c = 20000;
        update bliExtn2;
    }
    
}