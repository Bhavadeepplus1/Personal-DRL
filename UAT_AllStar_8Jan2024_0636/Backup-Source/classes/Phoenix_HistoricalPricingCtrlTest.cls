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
@istest
public class Phoenix_HistoricalPricingCtrlTest {

    static testmethod void HistoricalPricingTestMethod() {
        Id phoenixRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Bid Accounts').getRecordTypeId();
        Account testAccount = new Account(Name = 'Test Account', Phoenix_Customer_Group_Type__c = 'Clinics');
        insert testAccount;
        Account testAccount1 = new Account(Name = 'Test Account1', ParentId = testAccount.Id, Phoenix_Customer_Group_Type__c = 'Clinics');
        insert testAccount1;
        Account testAccount2 = new Account(Name = 'Test Account2', Phoenix_Customer_Group_Type__c = 'Clinics');

        insert testAccount2;
        testAccount.ParentId = testAccount2.Id;
        update testAccount;
        list < Product2 > prodList = new list < Product2 > ();
        Product2 prod1 = new Product2(Name = 'Test Product', Family = 'Test Family', IsActive = TRUE);
        Product2 prod2 = new Product2(Name = 'Test Product1', Family = 'Sample Family', IsActive = TRUE);
        Product2 prod3 = new Product2(Name = 'Test Product2', Family = ' cetirizine', IsActive = TRUE);
        prodList.add(prod1);
        prodList.add(prod2);
        prodList.add(prod3);
        insert prodList;


        update prodList[1];
        Phoenix_Bid__c pb = new Phoenix_Bid__c();
        pb.Phoenix_Status__c = 'New';
        pb.Phoenix_Comments__c = 'Test Comments';
        pb.Phoenix_Customer__c = testAccount1.Id;
        insert pb;

        list < Phoenix_Bid_Line_Item__c > lineItemsList = new list < Phoenix_Bid_Line_Item__c > ();
        for (Integer i = 0; i < prodList.size(); i++) {
            Phoenix_Bid_Line_Item__c pbl = new Phoenix_Bid_Line_Item__c(Phoenix_Bid__c = pb.Id, Phoenix_Product__c = prodList[i].Id);
            lineItemsList.add(pbl);
        }
        insert lineItemsList;
        Phoenix_Contract__c pc = new Phoenix_Contract__c();
        pc.Name = 'Test Contract';
        insert pc;
        list < Phoenix_NPR_Data__c > nprList = new list < Phoenix_NPR_Data__c > ();
        for (Integer i = 0; i < 4; i++) {
            Phoenix_NPR_Data__c npr = new Phoenix_NPR_Data__c();
            // npr.Name='Test NPR'+i;
            npr.Phoenix_Contract__c = pc.Id;
            npr.Phoenix_Product__c = lineItemsList[0].Phoenix_Product__c;

            if (i == 0) {
                npr.Phoenix_Account__c = pb.Phoenix_Customer__c;
                npr.Phoenix_Contract_Price__c = 1000;
                npr.Phoenix_Dead_Net_High_GR__c = 5000;
                npr.Phoenix_Price_Effective_Value_From__c = System.today();
            } else if (i == 1) {
                npr.Phoenix_Account__c = testAccount1.Id;
                npr.Phoenix_Contract_Price__c = 2000;
                npr.Phoenix_Dead_Net_High_GR__c = 1000;
                npr.Phoenix_Price_Effective_Value_From__c = System.today() - 3;

            } else if (i == 2) {
                npr.Phoenix_Account__c = testAccount.Id;
                npr.Phoenix_Contract_Price__c = 2000;
                npr.Phoenix_Dead_Net_High_GR__c = 1000;
                npr.Phoenix_Price_Effective_Value_From__c = System.today() - 4;

            } else {
                npr.Phoenix_Account__c = testAccount2.Id;
                npr.Phoenix_Contract_Price__c = 500;
                npr.Phoenix_Dead_Net_High_GR__c = 120;
                npr.Phoenix_Price_Effective_Value_From__c = System.today() - 5;

            }



            nprList.add(npr);
        }
        insert nprList;
        Phoenix_HistoricalPricingCtrl.getHistoricalData(lineItemsList[0].Id, true, false);
        Phoenix_HistoricalPricingCtrl.getHistoricalData(lineItemsList[0].Id, false, true);


    }
}