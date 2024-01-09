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
public class Phoenix_Best_Price_Batch_Test {
    static testmethod void test1() {
        Test.startTest();
        Account acc = new Account(name = 'Test Account');
        Insert acc;

        Product2 prod = new Product2(name = 'Test Product', ProductCode = '1234');
        prod.Phoenix_Best_Price__c = 10;
        prod.Phoenix_Type__c = 'NDA';
        prod.Phoenix_Track_Best_price__c = true;
        Insert prod;

        Phoenix_Contract__c cont = new Phoenix_Contract__c(name = 'Test contract');
        Phoenix_Contract__c cont2 = new Phoenix_Contract__c(name = 'Test contract2');
        List < Phoenix_Contract__c > contData = new List < Phoenix_Contract__c > {
            cont,
            cont2
        };

        insert contData;

        Phoenix_NPR_Data__c npr = new Phoenix_NPR_Data__c();
        npr.Phoenix_Material_Number__c = prod.ProductCode;
        npr.Phoenix_Product__c = prod.Id;
        npr.Phoenix_Account__c = acc.Id;
        npr.Phoenix_Contract__c = cont.Id;
        npr.Phoenix_Net_Price_w_o_fee_CD__c = 9;
        npr.Phoenix_Contract_Number__c = '1234';
        npr.Phoenix_GR_HighTier_in__c = 2;
        Phoenix_NPR_Data__c npr2 = new Phoenix_NPR_Data__c();
        npr2.Phoenix_Material_Number__c = prod.ProductCode;
        npr2.Phoenix_Product__c = prod.Id;
        npr2.Phoenix_Account__c = acc.Id;
        npr2.Phoenix_Contract__c = cont2.Id;
        npr2.Phoenix_Contract_Number__c = '12345';
        npr2.Phoenix_Net_Price_w_o_fee_CD__c = 8;
        npr2.Phoenix_GR_HighTier_in__c = 1;
        List < Phoenix_NPR_Data__c > nprData = new List < Phoenix_NPR_Data__c > {
            npr,
            npr2
        };
        Insert nprData;
        Phoenix_Best_Price_Batch bestPriceBatch = new Phoenix_Best_Price_Batch();
        bestPriceBatch.execute(null);
        Test.stopTest();
    }

}