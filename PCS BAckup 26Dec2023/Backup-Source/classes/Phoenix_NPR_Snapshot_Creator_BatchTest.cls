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
public class Phoenix_NPR_Snapshot_Creator_BatchTest {
    static testmethod void test1() {
        Test.startTest();
        Phoenix_Contract__c cont = new Phoenix_Contract__c(name = 'Test contract');
        insert cont;
        Phoenix_NPR_Data__c nprData = new Phoenix_NPR_Data__c();
        nprData.Phoenix_Contract__c = cont.Id;

        insert nprData;

        Phoenix_NPR_Snapshot_Creator_Batch snapShotBatch = new Phoenix_NPR_Snapshot_Creator_Batch();
        snapShotBatch.execute(null);
        Test.stopTest();
    }

}