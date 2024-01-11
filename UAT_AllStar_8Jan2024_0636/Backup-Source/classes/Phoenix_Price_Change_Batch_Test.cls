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
public class Phoenix_Price_Change_Batch_Test {
    static testmethod void test1() {
        Test.startTest();
        Account acc = new Account(name = 'Test Account');
        Account acc2 = new Account(name = 'Test Account2');
        List < Account > accoutsList = new List < Account > {
            acc,
            acc2
        };
        Insert accoutsList;

        Phoenix_Contract__c cont = new Phoenix_Contract__c(name = 'Test contract');
        Phoenix_Contract__c cont2 = new Phoenix_Contract__c(name = 'Test contract2');
        List < Phoenix_Contract__c > contData = new List < Phoenix_Contract__c > {
            cont,
            cont2
        };

        insert contData;

        Product2 prod = new Product2(name = 'Test Product', ProductCode = '1234');
        prod.Phoenix_Tracking_Customer__c = acc.Id;
        prod.Phoenix_Tracking_Customer_price__c = 10;
        prod.Phoenix_Contract_for_Tracking_Customer__c = cont.Id;
        Product2 prod2 = new Product2(name = 'Test Product2', ProductCode = '12345');
        prod.Phoenix_Tracking_Customer__c = acc2.Id;
        prod.Phoenix_Tracking_Customer_price__c = 15;
        prod.Phoenix_Contract_for_Tracking_Customer__c = cont2.Id;
        List < Product2 > productsList = new List < Product2 > {
            prod,
            prod2
        };
        Insert productsList;

        Phoenix_NPR_Data__c npr = new Phoenix_NPR_Data__c();
        npr.Phoenix_Material_Number__c = prod.ProductCode;
        npr.Phoenix_Product__c = prod.Id;
        npr.Phoenix_Account__c = acc2.Id;
        npr.Phoenix_Contract__c = cont2.Id;
        npr.Phoenix_Net_Price_w_o_Fees__c = 8;
        Phoenix_NPR_Data__c npr1 = new Phoenix_NPR_Data__c();
        npr1.Phoenix_Material_Number__c = prod.ProductCode;
        npr1.Phoenix_Product__c = prod.Id;
        npr1.Phoenix_Account__c = acc.Id;
        npr1.Phoenix_Contract__c = cont.Id;
        npr1.Phoenix_Net_Price_w_o_Fees__c = 9;
        Phoenix_NPR_Data__c npr2 = new Phoenix_NPR_Data__c();
        npr2.Phoenix_Material_Number__c = prod2.ProductCode;
        npr2.Phoenix_Product__c = prod2.Id;
        npr2.Phoenix_Account__c = acc2.Id;
        npr2.Phoenix_Contract__c = cont2.Id;
        npr2.Phoenix_Net_Price_w_o_Fees__c = 8;
        List < Phoenix_NPR_Data__c > nprData = new List < Phoenix_NPR_Data__c > {
            npr,
            npr1,
            npr2
        };
        Insert nprData;
        Phoenix_Price_Change_Batch priceChangeBatch = new Phoenix_Price_Change_Batch();
        priceChangeBatch.execute(null);
        Test.stopTest();
    }

}