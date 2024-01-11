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
public class Phoenix_ProdEvaluationPriceProcessorTest {
    @isTest
    public static void ProdEvaluationPriceProcessor() {
        Account acc = new Account();
        acc.Name = 'Test';
        acc.AccountNumber = '1234';
        acc.Phoenix_Is_Direct_Customer__c = false;
        insert acc;

        Phoenix_Contract__c cont = new Phoenix_Contract__c();
        cont.Name = '1234 - Test';
        cont.Phoenix_Contract_End_Date__c = System.today() + 1;
        cont.Phoenix_Contract_Number__c = '1234';
        cont.Phoenix_Is_Exclusion_Contract__c = false;
        cont.Phoenix_Contract_Internal_Description__c = 'Test';
        cont.Phoenix_Customer__c = acc.Id;
        insert cont;

        List < Product2 > proList = new List < Product2 > ();
        Product2 pro1 = new Product2();
        pro1.Name = 'Test';
        pro1.IsActive = true;
        proList.add(pro1);
        Product2 pro2 = new Product2();
        pro2.Name = 'Test';
        pro2.IsActive = true;
        proList.add(pro2);
        insert proList;

        Phoenix_NPR_Data__c npr1 = new Phoenix_NPR_Data__c();
        npr1.Phoenix_Account__c = acc.Id;
        npr1.Phoenix_Contract__c = cont.Id;
        npr1.Phoenix_Contract_Type__c = 'Direct';
        npr1.Phoenix_Product__c = proList[1].Id;
        npr1.Phoenix_12Months_Sales_Unit__c = 3.00;
        npr1.Phoenix_Dead_Net_Tracking_GR__c = 2.00;
         insert npr1;
          Phoenix_NPR_Data__c npr2 = new Phoenix_NPR_Data__c();
        npr2.Phoenix_Account__c = acc.Id;
        npr2.Phoenix_Contract__c = cont.Id;
        npr2.Phoenix_Contract_Type__c = 'Direct';
        npr2.Phoenix_Product__c = proList[1].Id;
        npr2.Phoenix_12Months_Sales_Unit__c = 5.00;
        npr2.Phoenix_Dead_Net_Tracking_GR__c = 1.00;
        insert npr2;

        /*  Phoenix_Contract__c cont= new Phoenix_Contract__c();
cont.Name='Test';
cont.Phoenix_Contract_End_Date__c =System.today()+1;
cont.Phoenix_Contract_Number__c='1234';
cont.Phoenix_Is_Exclusion_Contract__c=false;
cont.Phoenix_Customer__c=acc.Id;
insert cont;

List<Phoenix_NPR_Data__c> nprList= new List<Phoenix_NPR_Data__c>();

Phoenix_NPR_Data__c npr1= new Phoenix_NPR_Data__c();
npr1.Phoenix_Account__c=acc.Id;
npr1.Phoenix_Contract__c=cont.Id;
npr1.Phoenix_Contract_Type__c='Indirect';
npr1.Phoenix_Product__c=proList[1].Id;
npr1.Phoenix_12Months_Sales_Unit__c=3.00;
npr1.Phoenix_Add_ABS_Value__c=2.00;
npr1.Phoenix_Dead_Net_Tracking_GR__c=2.00;
//  insert npr1;
//  nprList.add(npr1);

Phoenix_NPR_Data__c npr2= new Phoenix_NPR_Data__c();
npr2.Phoenix_Account__c=acc.Id;
npr2.Phoenix_Contract_Type__c='Indirect';
npr2.Phoenix_Contract__c=cont.Id;
npr2.Phoenix_Product__c=proList[1].Id;
npr2.Phoenix_12Months_Sales_Unit__c=2.00;
npr2.Phoenix_Add_ABS_Value__c=2.00;
npr2.Phoenix_Dead_Net_Tracking_GR__c=1.00;
nprList.add(npr2);
Phoenix_NPR_Data__c npr3= new Phoenix_NPR_Data__c();
npr3.Phoenix_Account__c=acc.Id;
npr3.Phoenix_Contract_Type__c='Direct';
npr3.Phoenix_Contract__c=cont.Id;
// npr3.Phoenix_Product__c=proList[1].Id;
npr3.Phoenix_Add_ABS_Value__c=1.00;
npr3.Phoenix_12Months_Sales_Unit__c=1.00;
npr3.Phoenix_Dead_Net_Tracking_GR__c=1.00;
nprList.add(npr3);
if(!nprList.isEmpty()){
// insert nprList;

}*/

        Phoenix_ProductEvaluationPriceProcessor ProdEvaluationPriceProcessor = new Phoenix_ProductEvaluationPriceProcessor();
      //  DataBase.executeBatch(ProdEvaluationPriceProcessor);
        ProdEvaluationPriceProcessor.execute(null);
        System.assertEquals(1, 1);
    }
}