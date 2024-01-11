public with sharing class Phoenix_BidDropCls {
    @AuraEnabled
    public static void dropBid(String bidId,String comments){
        Phoenix_Bid__c bid = new Phoenix_Bid__c(id=bidId, Phoenix_Approval_Status__c='Dropped', Phoenix_Dropped_Comments__c=comments);
        update bid;
        List<Phoenix_Bid_Line_Item__c> bidLines = [Select Id,Phoenix_Bid_Line_Item_Approval_Status__c FROM Phoenix_Bid_Line_Item__c WHERE Phoenix_Bid__c=:bidId];
        for(Phoenix_Bid_Line_Item__c bidLine : bidLines){
            bidLine.Phoenix_Bid_Line_Item_Approval_Status__c = 'Dropped';
        }
        update bidLines;
    }

}