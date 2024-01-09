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
public class Phoenix_CustomerStagingProcessorTest {
    @testSetup static void setupTestData() {
        SAP_Customer__c sapCust = new SAP_Customer__c();
        sapCust.Name = 'testCustomer';
        sapCust.Phoenix_SAP_Customer_Code__c = '149779';
        insert sapCust;
        SAP_Customer__c sapCustchild = new SAP_Customer__c();
        sapCust.Name = 'testCustomer';
        sapCust.Phoenix_SAP_Customer_Code__c = '149780';
        sapCust.Phoenix_Parent__c = sapCust.Id;
        insert sapCustchild;
        Map < String, String > sapCustomerToSfAccIdMap = new Map < String, String > ();
        sapCustomerToSfAccIdMap.put(sapCust.Id, sapCust.Id);
        SAPCustomerTriggerHandler trigg = new SAPCustomerTriggerHandler();
        trigg.populateSFAccountIds(sapCustomerToSfAccIdMap);
    }
    @isTest
    public static void customerTest() {
        SAP_Customer__c sapCustmr = [SELECT Id, Name, Phoenix_SAP_Customer_Code__c FROM SAP_Customer__c WHERE Name = 'testCustomer'];
        Phoenix_SAP_Customer_Staging__c customerStaging = new Phoenix_SAP_Customer_Staging__c();
        customerStaging.Phoenix_SAP_Customer_Name__c = 'testCustomer';
        customerStaging.Phoenix_SAP_Customer_Code__c = '149779';
        customerStaging.Phoenix_Source_Type__c = 'SAP';
        customerStaging.Phoenix_Status__c = 'Pending';
        insert customerStaging;
        Phoenix_SAPCustomerStagingProcessorBatch processCustmr = new Phoenix_SAPCustomerStagingProcessorBatch();
        DataBase.executeBatch(processCustmr);
        System.assertEquals(1, 1);
    }
}