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
public class Phoenix_AllocationReviewBidType {
    @AuraEnabled
    public static Phoenix_Bid__c getbidInfo(String bidId) {
        Phoenix_Bid__c bidWrap = new Phoenix_Bid__c();
        if (bidId != null) {
            Phoenix_Bid__c bid = new Phoenix_Bid__c();
            bid = [SELECT Id, Phoenix_Review_Details__c, Phoenix_Bid_Type__c, Phoenix_Customer__c FROM Phoenix_Bid__c WHERE Id =: bidId LIMIT 1];
            bidWrap = bid;
        }

        return bidWrap;
    }
}