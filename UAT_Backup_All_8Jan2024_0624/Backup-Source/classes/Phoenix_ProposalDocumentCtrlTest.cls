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
@IsTest
public class Phoenix_ProposalDocumentCtrlTest {
    static testMethod void test1() {
        Phoenix_Bid__c bid = new Phoenix_Bid__c();
        bid.Phoenix_Bid_Type__c = 'Customer Rebate Change';
        insert bid;
        Phoenix_ProposalDocumentCtrl.generateDocument(bid.Id);

    }
}