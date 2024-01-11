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
public class Phoenix_RedirectClass {
    @AuraEnabled
    public static Phoenix_Bid__c getBid(String bidId) {
        system.debug('bidId' + bidId);
        Phoenix_Bid__c bid = [SELECT Id, Name, Phoenix_Bid_Type__c, Phoenix_Customer_Type__c FROM Phoenix_Bid__c WHERE Id =: bidId];
        return bid;
    }

}