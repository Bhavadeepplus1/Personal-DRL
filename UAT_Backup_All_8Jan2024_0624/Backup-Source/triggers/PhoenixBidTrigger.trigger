trigger PhoenixBidTrigger on Phoenix_Bid__c (before insert, after insert, before update, after update, before delete, after delete, after undelete) {
  new PhoenixBidTriggerHandler().run();
}