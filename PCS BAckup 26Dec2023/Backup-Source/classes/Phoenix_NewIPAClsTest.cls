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
public class Phoenix_NewIPAClsTest {
    static testmethod void Phoenix_NewIPAClsMethod() {
        Product_Family__c pf1 = new Product_Family__c();
        pf1.Name = 'Test Family';
        Product_Family__c pf2 = new Product_Family__c();
        pf2.Name = 'Sample Family';
        Product_Family__c pf3 = new Product_Family__c();
        pf3.Name = 'cetirizine';
        Product_Family__c pf4 = new Product_Family__c();
        pf4.Name = 'cetirizine';
        insert pf1; insert pf2; insert pf3; insert pf4;
        Id phoenixRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Bid Accounts').getRecordTypeId();
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        list < Product2 > prodList = new list < Product2 > ();
        Product2 prod1 = new Product2(Name = 'Test Product', Product_Family__c = pf1.Id, Phoenix_IPA_Floor_Price__c = 100, Phoenix_Is_IPA_Product__c = TRUE, Phoenix_GPI_Generic_Product_Identifier__c = '11111', Phoenix_NDC_11__c = '12345678902', Family = 'Test Family', IsActive = TRUE);
        Product2 prod2 = new Product2(Name = 'Test Product1', Product_Family__c = pf2.Id, Phoenix_IPA_Floor_Price__c = 100, Phoenix_Is_IPA_Product__c = TRUE, Phoenix_GPI_Generic_Product_Identifier__c = '22222', Phoenix_NDC_11__c = '21345678902', Family = 'Sample Family', IsActive = TRUE);
        Product2 prod3 = new Product2(Name = 'Test Product2', Product_Family__c = pf3.Id, Phoenix_IPA_Floor_Price__c = 100, Phoenix_Is_IPA_Product__c = TRUE, Phoenix_NDC_11__c = '32145678902', Family = ' cetirizine', IsActive = TRUE);
        Product2 prod4 = new Product2(Name = 'Test Product3', Product_Family__c = pf4.Id, Phoenix_IPA_Floor_Price__c = 100, Phoenix_Is_IPA_Product__c = TRUE, Phoenix_GPI_Generic_Product_Identifier__c = '333333', Family = ' cetirizine', IsActive = TRUE);

        prodList.add(prod1);
        prodList.add(prod2);
        prodList.add(prod3);
        prodList.add(prod4);
        insert prodList;
        Phoenix_Bid__c pb = new Phoenix_Bid__c();
        pb.Phoenix_Status__c = 'New';
        pb.Phoenix_Bid_Type__c = 'NEW Individual Pricing Agreement (IPA)';
        pb.Phoenix_Comments__c = 'Test Comments';
        pb.Phoenix_Customer__c = testAccount.Id;
        insert pb;

        Phoenix_NewIPACls.getIPAproducts(pb.Id);

        list < Phoenix_NewIPACls.wrapperClass > wrap = new list < Phoenix_NewIPACls.wrapperClass > ();
        list < string > productIds = new list < string > ();
        for (Integer i = 0; i < prodList.size(); i++) {
            Phoenix_NewIPACls.wrapperClass pbw = new Phoenix_NewIPACls.wrapperClass();
            pbw.prdlist = prodList[i];
            pbw.isSelected = true;
            pbw.currencyCode = '$';
            wrap.add(pbw);
            productIds.add(prodList[i].Id);

        }
        string search = 'test';
        string searchNDC = '12345678902 21345678902';
        list < string > directorList = new list < string > ();
        directorList.add('Suseela Dhruvsoft');
        Phoenix_NewIPACls.getSearch(wrap, directorList, search);
        Phoenix_NewIPACls.getSearch(wrap, directorList, '333333');
        Phoenix_NewIPACls.getSearch(wrap, directorList, searchNDC);
        Phoenix_NewIPACls.getsearchDirectorResult(wrap, directorList, searchNDC);
        Phoenix_NewIPACls.showselectedProducts(pb.Id);
        Phoenix_NewIPACls.getProductDirectorList();
        Phoenix_NewIPACls.codeCoverage();
        Phoenix_NewIPACls.getQuoteLineItems(productIds, pb.Id);

        list < Phoenix_Bid_Line_Item__c > lineItemsList = new list < Phoenix_Bid_Line_Item__c > ();
        for (Integer i = 0; i < prodList.size(); i++) {
            Phoenix_Bid_Line_Item__c pbl = new Phoenix_Bid_Line_Item__c(Phoenix_Bid__c = pb.Id, Phoenix_Product__c = prodList[i].Id);
            lineItemsList.add(pbl);
        }


        Phoenix_NewIPACls.fetchSortResults('Name', true, wrap);
        Phoenix_NewIPACls.fetchSortResults('Name', false, wrap);
        Phoenix_NewIPACls.insertLines(lineItemsList);
    }


}