/**
 * @description       : 
 * @author            : Surender Patel (Dhruvsoft)
 * @group             : 
 * @last modified on  : 25-05-2021
 * @last modified by  : Surender Patel (Dhruvsoft)
 * Modifications Log 
 * Ver   Date         Author                       Modification
 * 1.0   25-05-2021   Surender Patel (Dhruvsoft)   Initial Version
**/
@isTest
public class PhoenixContractTriggerHandlerTest {
    public static testmethod void testContractTrigger() {
        Id phoenixRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Bid Accounts').getRecordTypeId();
        Account acc = new Account(Name = 'contract Account', RecordTypeId = phoenixRecordTypeId);
        insert acc;
        List < Phoenix_NPR_Data__c > nprDataList = new List < Phoenix_NPR_Data__c > ();
        Phoenix_Contract__c contract = new Phoenix_Contract__c(Name = 'test contract', Phoenix_Contract_Start_Date__c = system.today(), Phoenix_Contract_End_Date__c = system.today() + 3);
        insert contract;
        Phoenix_NPR_Data__c npdData = new Phoenix_NPR_Data__c(Phoenix_ABS_in__c = 123, Phoenix_Bonafied_G_N_Indicator__c = 'test', Phoenix_Contract__c = contract.Id);
        Phoenix_NPR_Data__c npdData2 = new Phoenix_NPR_Data__c(Phoenix_ABS_in__c = 123, Phoenix_Bonafied_G_N_Indicator__c = 'test', Phoenix_Contract__c = contract.Id);
        Phoenix_NPR_Data__c npdData3 = new Phoenix_NPR_Data__c(Phoenix_ABS_in__c = 123, Phoenix_Bonafied_G_N_Indicator__c = 'test', Phoenix_Contract__c = contract.Id);
        nprDataList.add(npdData);
        nprDataList.add(npdData2);
        nprDataList.add(npdData3);
        insert nprDataList;
        Phoenix_Contract__c updateContract = [SELECT ID, Phoenix_Customer__c FROM Phoenix_Contract__c WHERE ID =: contract.Id LIMIT 1];
        updateContract.Phoenix_Customer__c = acc.Id;
        update updateContract;
    }

}