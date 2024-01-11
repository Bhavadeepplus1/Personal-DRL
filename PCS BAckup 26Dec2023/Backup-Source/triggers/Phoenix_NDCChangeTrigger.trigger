trigger Phoenix_NDCChangeTrigger on Phoenix_NDC_Change__c (before insert, after insert, before update, after update, before delete, after delete, after undelete) {
  new Phoenix_NDCChangeTriggerHandler().run();
}