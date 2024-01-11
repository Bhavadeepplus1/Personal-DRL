trigger PhoenixTermsMatrixTrigger on Phoenix_Terms_Matrix__c (before insert, after update, before update) {
	new PhoenixTermsMatrixTriggerHandler().run();
}