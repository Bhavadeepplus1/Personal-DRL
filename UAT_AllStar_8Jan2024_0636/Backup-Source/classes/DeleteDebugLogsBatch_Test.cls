/**
 * @description       : 
 * @author            : Surender Dhruvsoft
 * @group             : 
 * @last modified on  : 25-05-2021
 * @last modified by  : Surender Dhruvsoft
 * Modifications Log 
 * Ver   Date         Author               Modification
 * 1.0   25-05-2021   Surender Dhruvsoft   Initial Version
**/
@isTest
public class DeleteDebugLogsBatch_Test {
    static testmethod void test1() {
        Test.startTest();
        Phoenix_Bid__c bid = new Phoenix_Bid__c();
        insert bid;
        Database.executeBatch(new DeleteDebugLogsBatch());
        Test.stopTest();
    }
}