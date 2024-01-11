trigger Phoenix_NewWacPricingTrigger on New_Product_WAC_Pricing__c (before insert, after insert, before update, after update, before delete, after delete, after undelete) {
    new Phoenix_NewWacPricingTriggerHandler().run();
}