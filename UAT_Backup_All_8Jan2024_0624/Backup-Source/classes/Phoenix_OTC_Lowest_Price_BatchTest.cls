@isTest
public class Phoenix_OTC_Lowest_Price_BatchTest {
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
     cont.Phoenix_Contract_End_Date__c  =system.today();
     cont.Phoenix_Is_Exclusion_Contract__c =False;
     Phoenix_Contract__c cont2 = new Phoenix_Contract__c(name = 'Test contract2');
     cont2.Phoenix_Contract_End_Date__c  =system.today();
     cont2.Phoenix_Is_Exclusion_Contract__c =False;
     List < Phoenix_Contract__c > contData = new List < Phoenix_Contract__c > {
         cont,
             cont2
             };

        insert contData;

        Product2 prod = new Product2(name = 'Test Product', ProductCode = '1234');
        prod.IsActive =true;
        prod.OTC_Customer__c =acc.Id;
        prod.Phoenix_Is_Private_Label_OTC__c =true;
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
        npr.Phoenix_Dead_Net_Tracking_GR__c =20;
        npr.Phoenix_NPR_Status__c ='Active';
        npr.Phoenix_Product__c = prod.Id;
        npr.Phoenix_Account__c = acc2.Id;
        npr.Phoenix_Contract__c = cont2.Id;
        npr.Phoenix_Net_Price_w_o_Fees__c = 8;
        Phoenix_NPR_Data__c npr1 = new Phoenix_NPR_Data__c();
        npr1.Phoenix_Dead_Net_Tracking_GR__c =20;
        npr1.Phoenix_NPR_Status__c ='Active';
        npr1.Phoenix_Dead_Net_Tracking_GR__c =20;
        npr1.Phoenix_Material_Number__c = prod.ProductCode;
        npr1.Phoenix_Product__c = prod.Id;
        npr1.Phoenix_Account__c = acc.Id;
        npr1.Phoenix_Contract__c = cont.Id;
        npr1.Phoenix_Net_Price_w_o_Fees__c = 9;
        Phoenix_NPR_Data__c npr2 = new Phoenix_NPR_Data__c();
        npr2.Phoenix_NPR_Status__c ='Active';
        npr2.Phoenix_Material_Number__c = prod2.ProductCode;
        npr2.Phoenix_Dead_Net_Tracking_GR__c =20;
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
        Phoenix_OTC_Lowest_Price_Batch priceChangeBatch = new Phoenix_OTC_Lowest_Price_Batch();
        priceChangeBatch.execute(null);
        Test.stopTest();
    }

}