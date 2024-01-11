trigger Phoenix_PHSTrigger on Phoenix_PHS_Price_Change__c (before insert, after insert, before update, after update, before delete, after delete, after undelete) {
    new Phoenix_PHSTriggerHandler().run();
}