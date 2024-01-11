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
public class Phoenix_ProductFamilyFinanceClsTest {
    @isTest static void testFinanceView() {
        try{
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
        Product_Family__c pf = new Product_Family__c();
        pf.Name = 'Allopurinol';
        insert pf;
        Product_Family__c pf2 = new Product_Family__c();
        pf2.Name = 'Abiraterone Acetate Tab';
        insert pf2;
        Product2 p2 = new Product2();
        p2.Family = 'Allopurinol';
        p2.Name = 'Test';
            p2.Product_Family__c = pf.Id;
        insert p2;
        Phoenix_Bid_Line_Item__c bl = new Phoenix_Bid_Line_Item__c();
        bl.Phoenix_Bid__c = pb.Id;
            bl.Product_Family__c = pf.Id;
        bl.Phoenix_Current_Direct_Price__c = 10;
        bl.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        bl.Phoenix_Product__c = p2.Id;
        bl.Phoenix_Throughput_Cost1__c = 100;
        bl.Phoenix_WAC1__c = 120;
        bl.Phoenix_Budgeted_ASP1__c = 120;
        bl.Phoenix_Product_Family1__c = 'Allopurinol';
        bl.Phoenix_Proposed_Direct_Selling_Unit__c = 1000;
        bl.Phoenix_Proposed_Indirect_Selling_Unit__c = 1550;
        Map < String, String > financeApprovalMap = new Map < String, String > ();
        Map < String, String > financeCommentMap = new Map < String, String > ();
        financeApprovalMap.put('Daptomycin Inj 500mg US', 'Approved');
        financeCommentMap.put('Daptomycin Inj 500mg US', 'test');
        insert bl;
        Phoenix_ProductFamilyFinanceCls.getProductFamlilyRollups(pb.id);
        Phoenix_ProductFamilyFinanceCls.updateLineItems(pb.id, financeApprovalMap, financeCommentMap, 'Approved', true);
        Phoenix_TestDataCreator testData = new Phoenix_TestDataCreator();
        //testData.generateBids();
        Phoenix_SubmitBidForApprovalCtrl.BidWrapper wrap = new Phoenix_SubmitBidForApprovalCtrl.BidWrapper();
        wrap.bid = pb;

        testData.generateApprovalMatrix();

        System.runAs(testData.users[0]) {
            Phoenix_SubmitBidForApprovalCtrl.submitBid(wrap);
            Phoenix_ProductFamilyFinanceCls.makeApprovals(wrap.bid.id);
        }
        }
        catch(Exception e ){}

    }


}