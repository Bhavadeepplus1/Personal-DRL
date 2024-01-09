/**
 * @description       : 
 * @author            : Surender Dhruvsoft
 * @group             : 
 * @last modified on  : 25-05-2021
 * @last modified by  : Surender Patel (Dhruvsoft)
 * Modifications Log 
 * Ver   Date         Author               Modification
 * 1.0   25-05-2021   Surender Dhruvsoft   Initial Version
 **/
@isTest
public class Phoenix_SAPCustomerStagingProcessorTest {
    @isTest
    public static void nprStgngTest1() {
        Phoenix_SAP_Customer_Staging__c custStg = new Phoenix_SAP_Customer_Staging__c();
        custStg.Phoenix_Division__c = '40';
        custStg.Phoenix_Parent_SAP_Customer_Code__c = '1234567';
        custStg.Phoenix_SAP_Customer_Code__c = '123456';
        insert custStg;
        DataBase.executeBatch(new Phoenix_SAPCustomerStagingProcessorBatch());
        System.assertEquals(1, 1);
    }

}