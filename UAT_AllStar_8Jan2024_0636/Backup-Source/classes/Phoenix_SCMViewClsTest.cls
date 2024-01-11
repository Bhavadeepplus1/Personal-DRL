/**
* @description       : 
* @author            : Surender Dhruvsoft
* @group             : 
* @last modified on  : 25-05-2021
* @last modified by  : Surender Dhruvsoft
* Modifications Log 
* Ver   Date         Author               Modification
* 1.0   25-05-2021   Surender Dhruvsoft   Initial Version
**/
@isTest
public class Phoenix_SCMViewClsTest {
    @isTest static void testSCMView() {
         Phoenix_Approval_Delegation_History__c deleHistory = new Phoenix_Approval_Delegation_History__c();
        deleHistory.Phoenix_Delegation_Start_Time__c =  system.now();
        deleHistory.Phoenix_Delegation_End_Time__c = datetime.newInstance(2023, 9, 15, 12, 30, 0); 
        deleHistory.Phoenix_Delegated_Approver__c=userInfo.getUserId();
    deleHistory.Phoenix_Is_Active_delegator__c = True;
        insert deleHistory;
        Account testAccount = new Account(Name = 'Test Account');
        testAccount.Phoenix_Contracts_Approver__c = Userinfo.getUserId();
        insert testAccount;
        Phoenix_Bid__c pb = new Phoenix_Bid__c();
        pb.Phoenix_Status__c = 'New';
        pb.Phoenix_Comments__c = 'Test Comments';
        pb.Phoenix_Customer__c = testAccount.Id;
        pb.Phoenix_Customer_Bid_Deadline_Date_Time__c = DateTime.now();
        pb.Phoenix_Customer_Bid_Deadline_Time_zone__c = 'PST';
        pb.Phoenix_Customer_Bid_Deadline_Time__c = '6 PM';
        pb.Phoenix_Customer_Type__c = 'Direct and Indirect';
        pb.Phoenix_Bid_Deadline_Date__c = System.today();
        pb.Phoenix_Bid_Type__c = 'RFP Bids';
        pb.Phoenix_Approval_Status__c = 'Draft';
        insert pb;
        Product_Family__c pf = new Product_Family__c();
        pf.Name = 'Daptomycin Inj 500mg US';
        insert pf;
        Product2 p2 = new Product2();
        p2.Family = 'Daptomycin Inj 500mg US';
        p2.Name = 'Test';
        p2.ProductCode = '300029858';
        p2.Product_Family__c = pf.Id;
        insert p2;
        Product_Family__c pf2 = new Product_Family__c();
        pf2.Name = 'Abiraterone Acetate Tab';
        insert pf2;
        Product2 p3 = new Product2();
        p3.Family = 'Abiraterone Acetate Tab';
        p3.ProductCode = '300029858';
        p3.Name = 'Test Product';
        p3.Product_Family__c = pf2.Id;
        insert p3;
        Phoenix_Bid_Line_Item__c bl = new Phoenix_Bid_Line_Item__c();
        bl.Phoenix_Bid__c = pb.Id;
        bl.Product_Family__c = pf.Id;
        bl.Phoenix_Current_Direct_Price__c = 10;
        bl.Phoenix_Product_Code1__c = '300029858';
        bl.Phoenix_Product_Family1__c = 'Daptomycin Inj 500mg US';
        bl.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        bl.Phoenix_Product__c = p2.Id;
        bl.Phoenix_Final_Status__c = 'Approved';
        bl.Phoenix_SCM_Approval_Y_N__c = 'Y- Only Current Monthly Demand Approved';
        bl.Phoenix_Marketing_Final_Approval__c = true;
        insert bl;
        Phoenix_Bid_Line_Item__c bl1 = new Phoenix_Bid_Line_Item__c();
        bl1.Phoenix_Bid__c = pb.Id;
        bl1.Product_Family__c = pf2.Id;
        bl1.Phoenix_Final_Status__c = 'Approved';
        bl1.Phoenix_Current_Direct_Price__c = 10;
        bl1.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        bl1.Phoenix_Product__c = p3.Id;
        bl1.Phoenix_SCM_Approval_Y_N__c = 'Y- Only Current Monthly Demand Approved';
        bl1.Phoenix_Marketing_Final_Approval__c = true;
        insert bl1;
        
        Map < String, Map < String, String >> financeApprovalMap = new Map < String, Map < String, String >> ();
        Map < String, Map < String, String >> financeCommentMap = new Map < String, Map < String, String >> ();
        Map < String, String > fieldsMap = new Map < String, String > ();
        Map < String, String > fieldsMap1 = new Map < String, String > ();
        fieldsMap.put('SCM Comments', 'test');
        fieldsMap1.put('SCM Rejection Reason', 'test');
        financeApprovalMap.put(bl.Id, fieldsMap);
        financeCommentMap.put(bl1.Id, fieldsMap1);
        
        Phoenix_TestDataCreator testData = new Phoenix_TestDataCreator();
        testData.generateBids();
        testData.generateApprovalMatrix();
        
        
        Phoenix_SCMViewCls.getScmData(pb.id);
        Phoenix_NDCFinanceView.getScmData(pb.id);
        Phoenix_CompactView.getScmData(pb.id);
        Map < String, Map < String, String >> scmApprovalMap = new Map < String, Map < String, String >> ();
        Map < String, Map < String, String >> scmApprovalQtyMap = new Map < String, Map < String, String >> ();
        Map < String, Map < String, String >> estimatedDaysMap = new Map < String, Map < String, String >> ();
        Map < String, Map < String, String >> scmRejReason = new Map < String, Map < String, String >> ();
        Map < String, Map < String, String >> scmCommentsMap = new Map < String, Map < String, String >> ();
        Map < String, Map < String, String >> initialVolumeMap = new Map < String, Map < String, String >> ();
        Map < String, Map < String, String >> initialCommentsMap = new Map < String, Map < String, String >> ();
        Map < String, Map < String, Date >> revisitedDateMap = new Map < String, Map < String, Date >> ();
        Map < String, Map < String, Date > > nextReviewDateMap = new Map < String, Map < String, Date > > ();
        String scmApproval = bl1.Phoenix_SCM_Approval_Y_N__c;
        Boolean isSCMApproved = true;
        //(String bidId , Map<String, Map<String,String> > scmApprovalMap, Map<String, Map<String,String> > scmApprovalQtyMap,Map<String, Map<String,String> > estimatedDaysMap, Map<String, Map<String,String> > scmRejReason,Map<String, Map<String,String> > scmCommentsMap,Map<String, Map<String,String> > initialVolumeMap, Map<String, Map<String,String> > initialCommentsMap,Map<String, Map<String,Date> > revisitedDateMap,Map<String, Map<String,Date> > nextReviewDateMap , string scmApproval , boolean isSCMApproved){
        
        Phoenix_SCMViewCls.updateLineItems(pb.id, scmApprovalMap, scmApprovalQtyMap, estimatedDaysMap, scmRejReason, scmCommentsMap, initialVolumeMap, initialCommentsMap, revisitedDateMap, nextReviewDateMap, scmApproval, isSCMApproved);
        
        Phoenix_SubmitBidForApprovalCtrl.BidWrapper wrap = new Phoenix_SubmitBidForApprovalCtrl.BidWrapper();
        wrap.bid = pb;
        
        Phoenix_SubmitBidForApprovalCtrl.SCMProductRejectionNotification(wrap.bid.Id);
        
        Phoenix_SubmitBidForApprovalCtrl.getBidInfo(wrap.bid.Id);
        Phoenix_SubmitBidForApprovalCtrl.calculateFinanceGrid(wrap.bid.Id);
        // System.runAs(testData.users[0]){
        Phoenix_SubmitBidForApprovalCtrl.submitBid(wrap);
        //Phoenix_SCMViewCls.makeApprovals(wrap.bid.id);
        //    }
        
    }
    @isTest static void testSCMView1() {
         Phoenix_Approval_Delegation_History__c deleHistory = new Phoenix_Approval_Delegation_History__c();
        deleHistory.Phoenix_Delegation_Start_Time__c =  system.now();
        deleHistory.Phoenix_Delegation_End_Time__c = datetime.newInstance(2023, 9, 15, 12, 30, 0); 
        deleHistory.Phoenix_Delegated_Approver__c=userInfo.getUserId();
    deleHistory.Phoenix_Is_Active_delegator__c = True;
        insert deleHistory;
        Account testAccount = new Account(Name = 'Test Account');
        testAccount.Phoenix_Contracts_Approver__c = Userinfo.getUserId();
        insert testAccount;
        Phoenix_Bid__c pb = new Phoenix_Bid__c();
        pb.Phoenix_Status__c = 'New';
        pb.Phoenix_Comments__c = 'Test Comments';
        pb.Phoenix_Customer__c = testAccount.Id;
        pb.Phoenix_Customer_Bid_Deadline_Date_Time__c = DateTime.now();
        pb.Phoenix_Customer_Bid_Deadline_Time_zone__c = 'PST';
        pb.Phoenix_Customer_Bid_Deadline_Time__c = '6 PM';
        pb.Phoenix_Customer_Type__c = 'Direct and Indirect';
        pb.Phoenix_Bid_Deadline_Date__c = System.today();
        pb.Phoenix_Bid_Type__c = 'RCA Member Addition';
        pb.Phoenix_Approval_Status__c = 'Draft';
        insert pb;
        Product_Family__c pf = new Product_Family__c();
        pf.Name = 'Daptomycin Inj 500mg US';
        insert pf;
        Product_Family__c pf2 = new Product_Family__c();
        pf2.Name = 'Abiraterone Acetate Tab';
        insert pf2;
        Product2 p2 = new Product2();
        p2.Family = 'Daptomycin Inj 500mg US';
        p2.Name = 'Test';
        p2.ProductCode = '300029858';
        p2.Product_Family__c = pf.Id;
        insert p2;
        Product2 p3 = new Product2();
        p3.Family = 'Abiraterone Acetate Tab';
        p3.ProductCode = '300029858';
        p3.Name = 'Test Product';
        p3.Product_Family__c = pf2.Id;
        insert p3;
        Phoenix_Bid_Line_Item__c bl = new Phoenix_Bid_Line_Item__c();
        bl.Phoenix_Bid__c = pb.Id;
        bl.Product_Family__c = pf.Id;
        bl.Phoenix_Current_Direct_Price__c = 10;
        bl.Phoenix_Product_Code1__c = '300029858';
        bl.Phoenix_Product_Family1__c = 'Daptomycin Inj 500mg US';
        bl.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        bl.Phoenix_Product__c = p2.Id;
        bl.Phoenix_Final_Status__c = 'Approved';
        bl.Phoenix_SCM_Approval_Y_N__c = 'Y- Only Current Monthly Demand Approved';
        bl.Phoenix_Marketing_Final_Approval__c = true;
        insert bl;
        Phoenix_Bid_Line_Item__c bl1 = new Phoenix_Bid_Line_Item__c();
        bl1.Phoenix_Bid__c = pb.Id;
        bl1.Product_Family__c = pf2.Id;
        bl1.Phoenix_Final_Status__c = 'Approved';
        bl1.Phoenix_Current_Direct_Price__c = 10;
        bl1.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        bl1.Phoenix_Product__c = p3.Id;
        bl1.Phoenix_SCM_Approval_Y_N__c = 'Y- Only Current Monthly Demand Approved';
        bl1.Phoenix_Marketing_Final_Approval__c = true;
        insert bl1;
        Map < String, Map < String, String >> financeApprovalMap = new Map < String, Map < String, String >> ();
        Map < String, Map < String, String >> financeCommentMap = new Map < String, Map < String, String >> ();
        Map < String, String > fieldsMap = new Map < String, String > ();
        Map < String, String > fieldsMap1 = new Map < String, String > ();
        fieldsMap.put('SCM Comments', 'test');
        fieldsMap1.put('SCM Rejection Reason', 'test');
        financeApprovalMap.put(bl.Id, fieldsMap);
        financeCommentMap.put(bl1.Id, fieldsMap1);
        
        Phoenix_SCMViewCls.getScmData(pb.id);
        Phoenix_NDCFinanceView.getScmData(pb.id);
        Phoenix_CompactView.getScmData(pb.id);
        //  Phoenix_SCMViewCls.updateLineItems(pb.id,financeApprovalMap,null,null,financeApprovalMap,financeCommentMap,null,null,null,bl1.Phoenix_SCM_Approval_Y_N__c , true);
        Phoenix_TestDataCreator testData = new Phoenix_TestDataCreator();
        Phoenix_SubmitBidForApprovalCtrl.BidWrapper wrap = new Phoenix_SubmitBidForApprovalCtrl.BidWrapper();
        wrap.bid = pb;
        testData.generateApprovalMatrix();
        Phoenix_SubmitBidForApprovalCtrl.SCMProductRejectionNotification(wrap.bid.Id);
        
        Phoenix_SubmitBidForApprovalCtrl.getBidInfo(wrap.bid.Id);
        Phoenix_SubmitBidForApprovalCtrl.calculateFinanceGrid(wrap.bid.Id);
        // System.runAs(testData.users[0]){
        Phoenix_SubmitBidForApprovalCtrl.submitBid(wrap);
        Phoenix_SCMViewCls.updateCoItems('testAcc');
        //Phoenix_SCMViewCls.makeApprovals(wrap.bid.id);
        //    }
        
    }
    @isTest static void testSCMView2() {
         Phoenix_Approval_Delegation_History__c deleHistory = new Phoenix_Approval_Delegation_History__c();
        deleHistory.Phoenix_Delegation_Start_Time__c =  system.now();
        deleHistory.Phoenix_Delegation_End_Time__c = datetime.newInstance(2023, 9, 15, 12, 30, 0); 
        deleHistory.Phoenix_Delegated_Approver__c=userInfo.getUserId();
    deleHistory.Phoenix_Is_Active_delegator__c = True;
        insert deleHistory;
        Account testAccount = new Account(Name = 'Test Account');
        testAccount.Phoenix_Contracts_Approver__c = Userinfo.getUserId();
        insert testAccount;
        Phoenix_Bid__c pb = new Phoenix_Bid__c();
        pb.Phoenix_Status__c = 'New';
        pb.Phoenix_Comments__c = 'Test Comments';
        pb.Phoenix_Customer__c = testAccount.Id;
        pb.Phoenix_Customer_Bid_Deadline_Date_Time__c = DateTime.now();
        pb.Phoenix_Customer_Bid_Deadline_Time_zone__c = 'PST';
        pb.Phoenix_Customer_Bid_Deadline_Time__c = '6 PM';
        pb.Phoenix_Customer_Type__c = 'ROS';
        pb.Phoenix_Bid_Deadline_Date__c = System.today();
        pb.Phoenix_Bid_Type__c = 'Product Addition';
        pb.Phoenix_Approval_Status__c = 'Draft';
        insert pb;
        Product_Family__c pf = new Product_Family__c();
        pf.Name = 'Daptomycin Inj 500mg US';
        insert pf;
        Product_Family__c pf2 = new Product_Family__c();
        pf2.Name = 'Abiraterone Acetate Tab';
        insert pf2;
        Product2 p2 = new Product2();
        p2.Family = 'Daptomycin Inj 500mg US';
        p2.Name = 'Test';
        p2.ProductCode = '300029858';
        p2.Product_Family__c = pf.Id;
        insert p2;
        Product2 p3 = new Product2();
        p3.Family = 'Abiraterone Acetate Tab';
        p3.ProductCode = '300029858';
        p3.Name = 'Test Product';
        p3.Product_Family__c = pf2.Id;
        insert p3;
        Phoenix_Bid_Line_Item__c bl = new Phoenix_Bid_Line_Item__c();
        bl.Phoenix_Bid__c = pb.Id;
        bl.Product_Family__c = pf.Id;
        bl.Phoenix_Current_Direct_Price__c = 10;
        bl.Phoenix_Product_Code1__c = '300029858';
        bl.Phoenix_Product_Family1__c = 'Daptomycin Inj 500mg US';
        bl.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        bl.Phoenix_Product__c = p2.Id;
        bl.Phoenix_Final_Status__c = 'Approved';
        bl.Phoenix_SCM_Approval_Y_N__c = 'Y- Only Current Monthly Demand Approved';
        bl.Phoenix_Marketing_Final_Approval__c = true;
        insert bl;
        Phoenix_Bid_Line_Item__c bl1 = new Phoenix_Bid_Line_Item__c();
        bl1.Phoenix_Bid__c = pb.Id;
        bl1.Product_Family__c = pf2.Id;
        bl1.Phoenix_Final_Status__c = 'Approved';
        bl1.Phoenix_Current_Direct_Price__c = 10;
        bl1.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        bl1.Phoenix_Product__c = p3.Id;
        bl1.Phoenix_SCM_Approval_Y_N__c = 'Y- Only Current Monthly Demand Approved';
        bl1.Phoenix_Marketing_Final_Approval__c = true;
        insert bl1;
        
        Phoenix_BidLineItemExtn__c bliExtn1 = new Phoenix_BidLineItemExtn__c();
        bliExtn1.Phoenix_Bid_Line_Item__c = bl1.Id;
        insert bliExtn1;
        
        Map < String, Map < String, String >> financeApprovalMap = new Map < String, Map < String, String >> ();
        Map < String, Map < String, String >> financeCommentMap = new Map < String, Map < String, String >> ();
        Map < String, String > fieldsMap = new Map < String, String > ();
        Map < String, String > fieldsMap1 = new Map < String, String > ();
        fieldsMap.put('SCM Comments', 'test');
        fieldsMap1.put('SCM Rejection Reason', 'test');
        financeApprovalMap.put(bl.Id, fieldsMap);
        financeCommentMap.put(bl1.Id, fieldsMap1);
        
        Phoenix_SCMViewCls.getScmData(pb.id);
        Phoenix_NDCFinanceView.getScmData(pb.id);
        Phoenix_CompactView.getScmData(pb.id);
        //  Phoenix_SCMViewCls.updateLineItems(pb.id,financeApprovalMap,null,null,financeApprovalMap,financeCommentMap,null,null,null,bl1.Phoenix_SCM_Approval_Y_N__c , true);
        /* Phoenix_TestDataCreator testData = new Phoenix_TestDataCreator();
Phoenix_SubmitBidForApprovalCtrl.BidWrapper wrap = new Phoenix_SubmitBidForApprovalCtrl.BidWrapper();
wrap.bid = pb;
testData.generateApprovalMatrix();
Phoenix_SubmitBidForApprovalCtrl.SCMProductRejectionNotification(wrap.bid.Id);

Phoenix_SubmitBidForApprovalCtrl.getBidInfo(wrap.bid.Id);
Phoenix_SubmitBidForApprovalCtrl.calculateFinanceGrid(wrap.bid.Id);
// System.runAs(testData.users[0]){
Phoenix_SubmitBidForApprovalCtrl.submitBid(wrap);
Phoenix_SCMViewCls.makeApprovals(wrap.bid.id);
//    }
*/
    }
   @isTest static void testSCMView3() {
        Phoenix_Approval_Delegation_History__c deleHistory = new Phoenix_Approval_Delegation_History__c();
        deleHistory.Phoenix_Delegation_Start_Time__c =  system.now();
        deleHistory.Phoenix_Delegation_End_Time__c = datetime.newInstance(2023, 9, 15, 12, 30, 0); 
        deleHistory.Phoenix_Delegated_Approver__c=userInfo.getUserId();
    deleHistory.Phoenix_Is_Active_delegator__c = True;
        insert deleHistory;
        Account testAccount = new Account(Name = 'Test Account');
        testAccount.Phoenix_Contracts_Approver__c = Userinfo.getUserId();
        insert testAccount;
        list<Phoenix_Bid_Line_Item__c> pblntm = new list<Phoenix_Bid_Line_Item__c>();
        Map <Id, Phoenix_BidLineItemExtn__c> bliExtnMap = new Map<Id, Phoenix_BidLineItemExtn__c>(); 
        
        Phoenix_Bid__c pb = new Phoenix_Bid__c();
        pb.Phoenix_Status__c = 'New';
        pb.Phoenix_Comments__c = 'Test Comments';
        pb.Phoenix_Customer__c = testAccount.Id;
        pb.Phoenix_Customer_Bid_Deadline_Date_Time__c = DateTime.now();
        pb.Phoenix_Customer_Bid_Deadline_Time_zone__c = 'PST';
        pb.Phoenix_Customer_Bid_Deadline_Time__c = '6 PM';
        pb.Phoenix_Customer_Type__c = 'ROS';
        pb.Phoenix_Bid_Deadline_Date__c = System.today();
        pb.Phoenix_Bid_Type__c = 'Product Addition';
        pb.Phoenix_Approval_Status__c = 'Draft';
        insert pb;
        Product_Family__c pf = new Product_Family__c();
        pf.Name = 'Daptomycin Inj 500mg US';
        insert pf;
        Product_Family__c pf2 = new Product_Family__c();
        pf2.Name = 'Abiraterone Acetate Tab';
        insert pf2;
        Product2 p2 = new Product2();
        p2.Family = 'Daptomycin Inj 500mg US';
        p2.Name = 'Test';
        p2.ProductCode = '300029858';
       p2.Product_Family__c = pf.Id;
        insert p2;
        Product2 p3 = new Product2();
        p3.Family = 'Abiraterone Acetate Tab';
        p3.ProductCode = '300029858';
        p3.Name = 'Test Product';
       p3.Product_Family__c = pf2.Id;
        insert p3;
        
        
        
        Phoenix_Bid_Line_Item__c bl = new Phoenix_Bid_Line_Item__c();
        bl.Phoenix_Bid__c = pb.Id;
       bl.Product_Family__c = pf.Id;
        bl.Phoenix_Current_Direct_Price__c = 10;
        bl.Phoenix_Product_Code1__c = '300029858';
        bl.Phoenix_Product_Family1__c = 'Daptomycin Inj 500mg US';
        bl.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        bl.Phoenix_Product__c = p2.Id;
        bl.Phoenix_Final_Status__c = 'Approved';
        bl.Phoenix_SCM_Approval_Y_N__c = 'Y- Only Current Monthly Demand Approved';
        bl.Phoenix_Marketing_Final_Approval__c = true;
        insert bl;
        
        
        Phoenix_BidLineItemExtn__c bliExtn1 = new Phoenix_BidLineItemExtn__c();
        bliExtn1.Phoenix_Bid_Line_Item__c = bl.Id;
        insert bliExtn1;
        bliExtnMap.put(bl.id,bliExtn1); 
        

        Phoenix_SCMViewCls.getScmData(pb.id);
        Phoenix_NDCFinanceView.getScmData(pb.id);
        Phoenix_CompactView.getScmData(pb.id);
       Phoenix_SCMViewCls.updatedLineItems(pb.id);
        
    }
    
}