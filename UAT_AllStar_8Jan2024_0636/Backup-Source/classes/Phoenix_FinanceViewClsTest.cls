/**
 * @description       : 
 * @author            : Surender Patel (Dhruvsoft)
 * @group             : 
 * @last modified on  : 25-05-2021
 * @last modified by  : Surender Patel (Dhruvsoft)
 * Modifications Log 
 * Ver   Date         Author                       Modification
 * 1.0   25-05-2021   Surender Patel (Dhruvsoft)   Initial Version
**/
@isTest
public class Phoenix_FinanceViewClsTest {
    @isTest static void testFinanceView() {
        Product_Family__c pf = new Product_Family__c();
        pf.Name = 'ALLOPURINOL';
        insert pf;
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
        pb.Phoenix_Bid_Deadline_Date__c = System.today();
        pb.Phoenix_Bid_Type__c = 'RFP Bids';
        pb.Phoenix_Approval_Status__c = 'Draft';
        insert pb;
        Product2 p2 = new Product2();
        p2.Family = 'Allopurinol';
        p2.Product_Family__c = pf.Id;
        p2.Name = 'Test';
        insert p2;
        Phoenix_Approval_Delegation_History__c PDH = new Phoenix_Approval_Delegation_History__c();
        PDH.Phoenix_Delegation_Start_Time__c = system.now();
        PDH.Phoenix_Delegation_End_Time__c = system.now() +1 ;
        PDH.Phoenix_Delegated_Approver__c = UserInfo.getUserId();
        PDH.Phoenix_Is_Active_delegator__c = true;
        insert PDH;
            
        Phoenix_Bid_Line_Item__c bl = new Phoenix_Bid_Line_Item__c();
        bl.Phoenix_Bid__c = pb.Id;
        bl.Phoenix_Current_Direct_Price__c = 10;
        bl.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        bl.Phoenix_Product__c = p2.Id;
        bl.Phoenix_Throughput_Cost1__c = 100;
        bl.Phoenix_WAC1__c = 120;
        bl.Phoenix_Budgeted_ASP1__c = 120;
        bl.Phoenix_Product_Family1__c = 'Allopurinol';
        bl.Product_Family__c = pf.Id;
        bl.Phoenix_Proposed_Direct_Selling_Unit__c = 1000;
        bl.Phoenix_Proposed_Indirect_Selling_Unit__c = 1550;
        Map < String, String > financeApprovalMap = new Map < String, String > ();
        Map < String, String > financeCommentMap = new Map < String, String > ();
        financeApprovalMap.put('Daptomycin Inj 500mg US', 'Approved');
        financeCommentMap.put('Daptomycin Inj 500mg US', 'test');
        insert bl;
         Phoenix_Approval_Delegation_History__c deleHistory = new Phoenix_Approval_Delegation_History__c();
        deleHistory.Phoenix_Delegation_Start_Time__c =  system.now();
        deleHistory.Phoenix_Delegation_End_Time__c = datetime.newInstance(2023, 9, 15, 12, 30, 0); 
        deleHistory.Phoenix_Delegated_Approver__c=userInfo.getUserId();
    deleHistory.Phoenix_Is_Active_delegator__c = True;
        insert deleHistory;
        Phoenix_FinanceViewCls.getProductFamlilyRollups(pb.id);
        Phoenix_FinanceViewCls.updateLineItems(pb.id, financeApprovalMap, financeCommentMap, 'Approved', true);
        Phoenix_TestDataCreator testData = new Phoenix_TestDataCreator();
        //testData.generateBids();
        Phoenix_SubmitBidForApprovalCtrl.BidWrapper wrap = new Phoenix_SubmitBidForApprovalCtrl.BidWrapper();
        wrap.bid = pb;

        testData.generateApprovalMatrix();

        System.runAs(testData.users[0]) {
            Phoenix_SubmitBidForApprovalCtrl.submitBid(wrap);
            Phoenix_FinanceViewCls.makeApprovals(wrap.bid.id);
        }
    }
}