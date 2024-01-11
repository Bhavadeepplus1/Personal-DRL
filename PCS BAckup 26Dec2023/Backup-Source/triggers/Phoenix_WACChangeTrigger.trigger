trigger Phoenix_WACChangeTrigger on Phoenix_WAC_Change__c (before insert, after insert, before update, after update, before delete, after delete, after undelete) {
    new Phoenix_WacChangeTriggerHandler().run();
}