trigger Phoenix_NewWacPricingTrigger on New_Product_WAC_Pricing__c (before insert, after insert, before update, after update, before delete, after delete, after undelete) {
    List<Trigger_Validation__c> tv = Trigger_Validation__c.getall().values();
    boolean proceedOrNot = true;
    if(tv.size()>0){
        if(!tv[0].New_WacPricing_Trigger__c)
            proceedOrNot = false;
    }
    if(proceedOrNot)
        new Phoenix_NewWacPricingTriggerHandler().run();
}