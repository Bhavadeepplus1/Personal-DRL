trigger Phoenix_PHSTrigger on Phoenix_PHS_Price_Change__c (before insert, after insert, before update, after update, before delete, after delete, after undelete) {
    List<Trigger_Validation__c> tv = Trigger_Validation__c.getall().values();
    boolean proceedOrNot = true;
    if(tv.size()>0){
        if(!tv[0].Phs_Trigger__c)
            proceedOrNot = false;
    }
    if(proceedOrNot)
        new Phoenix_PHSTriggerHandler().run();
}