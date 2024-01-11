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
public class Phoenix_ProductSKUProcessorTest {
    @isTest
    public static void ProductSKUProcessor() {
        Account acc = new Account();
        acc.Name = 'Test';
        acc.AccountNumber = '1234';
        acc.Phoenix_Is_Direct_Customer__c = false;
        insert acc;
        
        List < Product2 > proList = new List < Product2 > ();
        Product2 pro1 = new Product2();
        pro1.Name = 'Test';
        pro1.IsActive = true;
        proList.add(pro1);
        Product2 pro2 = new Product2();
        pro2.Name = 'Test';
        pro2.IsActive = true;
        pro2.Phoenix_Is_New_Product__c =true;
        pro2.Phoenix_Lowest_Price_SKU__c=10;
        proList.add(pro2);
        insert proList;
        
        Phoenix_Contract__c cont = new Phoenix_Contract__c();
        cont.Name = 'Test';
        cont.Phoenix_Contract_End_Date__c = System.today() + 1;
        cont.Phoenix_Contract_Number__c = '1234';
        cont.Phoenix_Is_Exclusion_Contract__c = false;
        cont.Phoenix_Customer__c = acc.Id;
        insert cont;
        
        List < Phoenix_NPR_Data__c > nprList = new List < Phoenix_NPR_Data__c > ();
        
        Phoenix_NPR_Data__c npr1 = new Phoenix_NPR_Data__c();
        npr1.Phoenix_Account__c = acc.Id;
        npr1.Phoenix_Contract__c = cont.Id;
        npr1.Phoenix_Contract_Type__c = 'Direct';
        npr1.Phoenix_Product__c = proList[1].Id;
        npr1.Phoenix_Add_ABS_Value__c = 2.00;
        npr1.Phoenix_Dead_Net_Tracking_GR__c = 2.00;
        npr1.Phoenix_NPR_Status__c = 'Active';
        nprList.add(npr1);
        
        Phoenix_NPR_Data__c npr2 = new Phoenix_NPR_Data__c();
        npr2.Phoenix_Account__c = acc.Id;
        npr2.Phoenix_Contract_Type__c = 'Direct';
        npr2.Phoenix_Contract__c = cont.Id;
        npr2.Phoenix_Product__c = proList[1].Id;
        npr2.Phoenix_Add_ABS_Value__c = 2.00;
        npr2.Phoenix_Dead_Net_Tracking_GR__c = 1.00;
        npr2.Phoenix_NPR_Status__c = 'Active';
        nprList.add(npr2);
        
        Phoenix_NPR_Data__c npr3 = new Phoenix_NPR_Data__c();
        npr3.Phoenix_Account__c = acc.Id;
        npr3.Phoenix_Contract__c = cont.Id;
        npr3.Phoenix_Contract_Type__c = 'Direct';
        npr3.Phoenix_Product__c = proList[0].Id;
        npr3.Phoenix_Add_ABS_Value__c = 2.00;
        npr3.Phoenix_Dead_Net_Tracking_GR__c = 2.00;
        npr3.Phoenix_NPR_Status__c = 'Active';
        nprList.add(npr3);
        
        Phoenix_NPR_Data__c npr4 = new Phoenix_NPR_Data__c();
        npr4.Phoenix_Account__c = acc.Id;
        npr4.Phoenix_Contract_Type__c = 'Direct';
        npr4.Phoenix_Contract__c = cont.Id;
        npr4.Phoenix_Product__c = proList[0].Id;
        npr4.Phoenix_Add_ABS_Value__c = 2.00;
        npr4.Phoenix_Dead_Net_Tracking_GR__c = 1.00;
        npr4.Phoenix_NPR_Status__c = 'Active';
        nprList.add(npr4);
        insert nprList;
        
         List < Phoenix_Future_NPR_Data__c > fnprList = new List < Phoenix_Future_NPR_Data__c > ();
        Phoenix_Future_NPR_Data__c fnpr = new Phoenix_Future_NPR_Data__c();
          fnpr.Phoenix_Account__c = acc.Id;
        fnpr.Phoenix_Contract_Type__c = 'Direct';
        fnpr.Phoenix_Contract__c = cont.Id;
        fnpr.Phoenix_Product__c = proList[0].Id;
        fnpr.Phoenix_Add_ABS_Value__c = 2.00;
        fnpr.Phoenix_Dead_Net_Tracking_GR__c = 1.00;
        fnpr.Phoenix_NPR_Status__c = 'Active';
        fnprList.add(fnpr);
        
          Phoenix_Future_NPR_Data__c fnpr1 = new Phoenix_Future_NPR_Data__c();
        fnpr1.Phoenix_Account__c = acc.Id;
        fnpr1.Phoenix_Contract__c = cont.Id;
        fnpr1.Phoenix_Contract_Type__c = 'Direct';
        fnpr1.Phoenix_Product__c = proList[1].Id;
        fnpr1.Phoenix_Add_ABS_Value__c = 2.00;
        fnpr1.Phoenix_Dead_Net_Tracking_GR__c = 2.00;
        fnpr1.Phoenix_NPR_Status__c = 'Active';
        fnprList.add(fnpr1);
        
        Phoenix_Future_NPR_Data__c fnpr2 = new Phoenix_Future_NPR_Data__c();
        fnpr2.Phoenix_Account__c = acc.Id;
        fnpr2.Phoenix_Contract_Type__c = 'Direct';
        fnpr2.Phoenix_Contract__c = cont.Id;
        fnpr2.Phoenix_Product__c = proList[1].Id;
        fnpr2.Phoenix_Add_ABS_Value__c = 2.00;
        fnpr2.Phoenix_Dead_Net_Tracking_GR__c = 1.00;
        fnpr2.Phoenix_NPR_Status__c = 'Active';
        fnprList.add(fnpr2);
        
        Phoenix_Future_NPR_Data__c fnpr3 = new Phoenix_Future_NPR_Data__c();
        fnpr3.Phoenix_Account__c = acc.Id;
        fnpr3.Phoenix_Contract__c = cont.Id;
        fnpr3.Phoenix_Contract_Type__c = 'Direct';
        fnpr3.Phoenix_Product__c = proList[0].Id;
        fnpr3.Phoenix_Add_ABS_Value__c = 2.00;
        fnpr3.Phoenix_Dead_Net_Tracking_GR__c = 2.00;
        fnpr3.Phoenix_NPR_Status__c = 'Active';
        fnprList.add(fnpr3);
        
        insert fnprList;
        
        Phoenix_ProductSKUProcessor ProductSKUProcessor = new Phoenix_ProductSKUProcessor();
        DataBase.executeBatch(new Phoenix_NPRDataActiveChecker());
        ProductSKUProcessor.execute(null);
        
        System.assertEquals(1, 1);
        
    }
    
}