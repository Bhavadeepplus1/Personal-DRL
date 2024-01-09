trigger PhoenixContractTrigger on Phoenix_Contract__c (before insert,before update,after update) {
    new PhoenixContractTriggerHandler().run();
}