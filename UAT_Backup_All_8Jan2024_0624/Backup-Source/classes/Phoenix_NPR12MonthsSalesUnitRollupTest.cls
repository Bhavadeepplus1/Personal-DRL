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
public class Phoenix_NPR12MonthsSalesUnitRollupTest {
    @isTest
    public static void setupTestData1() {
        Account acc = new Account();
        acc.Name = 'Test';
        acc.AccountNumber = '1234';
        insert acc;
        Product2 pro = new Product2();
        pro.Name = 'Test';
        pro.Family = 'Test';
        pro.Phoenix_Throughput_cost__c = 2;
        pro.ProductCode = '30000001';
        insert pro;

        Phoenix_Contract__c cont = new Phoenix_Contract__c();
        cont.Name = 'Test';
        cont.Phoenix_Contract_Number__c = '1234';
        cont.Phoenix_Customer__c = acc.Id;
        insert cont;

        Phoenix_NPR_Data__c npr = new Phoenix_NPR_Data__c();
        npr.Phoenix_Account__c = acc.Id;
        npr.Phoenix_Contract__c = cont.Id;
        npr.Phoenix_Product__c = pro.Id;
        npr.Phoenix_Add_ABS_Value__c = 2.00;
        npr.Phoenix_NPR_Status__c = 'Active';
        npr.Phoenix_Dead_Net_Tracking_GR__c = 2;
        insert npr;

        Phoenix_NPR_Volume__c nprVol = new Phoenix_NPR_Volume__c();
        nprVol.Phoenix_NPR_Data__c = npr.Id;
        nprVol.Phoenix_Volume__c = 10;
        nprVol.Phoenix_Date__c = System.today().addMonths(-1).toStartOfMonth();
        nprVol.Name = 'test';
        insert nprVol;

        Phoenix_NPR12MonthsSalesUnitRollup processProd = new Phoenix_NPR12MonthsSalesUnitRollup();
        Test.startTest();
        DataBase.executeBatch(processProd);
        Test.stopTest();
    }
}