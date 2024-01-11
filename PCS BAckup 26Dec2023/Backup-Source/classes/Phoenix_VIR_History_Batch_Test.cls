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
public class Phoenix_VIR_History_Batch_Test {
    static testmethod void test1() {

        Account acc = new Account(name = 'Test Account',Phoenix_Is_Bid_Account__c=true);
        acc.Phoenix_Contract_Number__c = '1234';
        acc.Phoenix_Is_Bid_Account__c=True;
        Account acc2 = new Account(name = 'Test Account2');
        acc2.Phoenix_Contract_Number__c = '1234567';
        acc2.Phoenix_Is_Bid_Account__c = True;
        List < Account > accountList = new List < Account > {
            acc,
            acc2
        };
        Insert accountList;
        Phoenix_Contract__c cont = new Phoenix_Contract__c(name = 'Test contract');
        cont.Phoenix_Customer__c = acc.Id;
        cont.Phoenix_Contract_Number__c = '1234';
        Insert cont;
        Phoenix_NPR_Data__c npr1 = new Phoenix_NPR_Data__c();
        npr1.Phoenix_Account__c = acc.Id;
        npr1.Phoenix_Contract__c = cont.Id;
        npr1.Phoenix_GR_TrackingTier__c = 15;
        Phoenix_NPR_Data__c npr2 = new Phoenix_NPR_Data__c();
        npr2.Phoenix_Account__c = acc.Id;
        npr2.Phoenix_Contract__c = cont.Id;
        npr2.Phoenix_GR_TrackingTier__c = 20;
        Phoenix_NPR_Data__c npr3 = new Phoenix_NPR_Data__c();
        npr3.Phoenix_Account__c = acc2.Id;
        npr3.Phoenix_Contract__c = cont.Id;
        npr3.Phoenix_GR_TrackingTier__c = 25;
        List < Phoenix_NPR_Data__c > nprdata = new List < Phoenix_NPR_Data__c > {
            npr1,
            npr2,
            npr3
        };
        Insert nprdata;
        Test.startTest();
        Phoenix_VIR_History_Batch virHistoryBatch = new Phoenix_VIR_History_Batch();
        virHistoryBatch.execute(null);
        Database.executeBatch(new Phoenix_VIR_History_Batch(), 200);
        Test.stopTest();
    }

}