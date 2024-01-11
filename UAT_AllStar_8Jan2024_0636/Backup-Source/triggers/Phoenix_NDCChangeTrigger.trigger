trigger Phoenix_NDCChangeTrigger on Phoenix_NDC_Change__c (before insert, after insert, before update, after update, before delete, after delete, after undelete) {
    List<Trigger_Validation__c> tv = Trigger_Validation__c.getall().values();
    boolean proceedOrNot = true;
    if(tv.size()>0){
        if(!tv[0].NDC_Change_Trigger__c)
            proceedOrNot = false;
    }
    if(proceedOrNot)
        new Phoenix_NDCChangeTriggerHandler().run();
}