trigger SAPCustomerTrigger on SAP_Customer__c (before insert, after insert, before update, after update, before delete, after delete, after undelete) {
	new SAPCustomerTriggerHandler().run();
}