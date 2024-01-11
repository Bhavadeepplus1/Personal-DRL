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
public class Phoenix_AddIPAProdcutsCtrlTest {
    static testmethod void AddIPAProductMethod() {
        Id phoenixRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Bid Accounts').getRecordTypeId();
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
   
        string loggedInUser = UserInfo.getUserId();
        list < Product2 > prodList = new list < Product2 > ();
        Product2 prod1 = new Product2(Name = 'Test Product', Phoenix_Product_Director__c = loggedInUser, Phoenix_IPA_Floor_Price__c = 100, Phoenix_Is_IPA_Product__c = TRUE, Phoenix_GPI_Generic_Product_Identifier__c = '11111', Phoenix_NDC_11__c = '12345678902', Family = 'Test Family', IsActive = TRUE);
        Product2 prod2 = new Product2(Name = 'Test Product1', Phoenix_Product_Director__c = loggedInUser, Phoenix_IPA_Floor_Price__c = 100, Phoenix_Is_IPA_Product__c = TRUE, Phoenix_GPI_Generic_Product_Identifier__c = '22222', Phoenix_NDC_11__c = '21345678902', Family = 'Sample Family', IsActive = TRUE);
        Product2 prod3 = new Product2(Name = 'Test Product2', Phoenix_Product_Director__c = loggedInUser, Phoenix_IPA_Floor_Price__c = 100, Phoenix_Is_IPA_Product__c = TRUE, Phoenix_NDC_11__c = '32145678902', Family = ' cetirizine', IsActive = TRUE);
        Product2 prod4 = new Product2(Name = 'Test Product3', Phoenix_Product_Director__c = loggedInUser, Phoenix_IPA_Floor_Price__c = 100, Phoenix_Is_IPA_Product__c = TRUE, Phoenix_GPI_Generic_Product_Identifier__c = '333333', Family = ' cetirizine', IsActive = TRUE);

        prodList.add(prod1);
        prodList.add(prod2);
        prodList.add(prod3);
        prodList.add(prod4);
        insert prodList;
        Phoenix_Bid__c pb = new Phoenix_Bid__c();
        pb.Phoenix_Status__c = 'New';
        pb.Phoenix_Bid_Type__c = 'SRx IPA Price Change';
        //pb.Phoenix_Comments__c = 'Test Comments';
        pb.Phoenix_Customer__c = testAccount.Id;
        insert pb;
        Phoenix_AddIPAProdcutsCtrl.BidWrapper pbWrapper = new Phoenix_AddIPAProdcutsCtrl.BidWrapper();
        pbWrapper = Phoenix_AddIPAProdcutsCtrl.getbidInfo(pb.Id);

        Phoenix_AddIPAProdcutsCtrl.BidWrapper pbWrapper1 = new Phoenix_AddIPAProdcutsCtrl.BidWrapper();
        pbWrapper1.bid = pb;
        pbWrapper1.isBidCreated = true;
        pbWrapper1.recordCount=12;
        //pbWrapper1.NDC='test2';
        //pbWrapper1.currencyCode1='Euro';
        Phoenix_AddIPAProdcutsCtrl.getIPAproducts(pb.Id);

        list < Phoenix_AddIPAProdcutsCtrl.wrapperClass > wrap = new list < Phoenix_AddIPAProdcutsCtrl.wrapperClass > ();
        list < string > productIds = new list < string > ();
        for (Integer i = 0; i < prodList.size(); i++) {
            Phoenix_AddIPAProdcutsCtrl.wrapperClass pbw = new Phoenix_AddIPAProdcutsCtrl.wrapperClass();
            pbw.prdlist = prodList[i];
            pbw.isSelected = true;
            pbw.currencyCode = '$';
           // pbw.currencyCode1 = '$';
            wrap.add(pbw);
            productIds.add(prodList[i].Id);

        }
        string search = 'test';
        list < string > directorList = new list < string > ();
        directorList.add('Suseela Dhruvsoft');
        string searchNDC = '12345678902 21345678902';
        Phoenix_AddIPAProdcutsCtrl.BidWrapper quotewrap = new Phoenix_AddIPAProdcutsCtrl.BidWrapper();
        quotewrap.bid = pb;
        Phoenix_AddIPAProdcutsCtrl.getSearch(wrap, directorList, search, quotewrap);
        Phoenix_AddIPAProdcutsCtrl.getSearch(wrap, directorList, '333333', quotewrap);
        Phoenix_AddIPAProdcutsCtrl.getSearch(wrap, directorList, searchNDC, quotewrap);

        Phoenix_AddIPAProdcutsCtrl.getsearchDirectorResult(wrap, directorList, searchNDC, quotewrap);
        Phoenix_AddIPAProdcutsCtrl.showselectedProducts(pb.Id);
        Phoenix_AddIPAProdcutsCtrl.getProductDirectorList(quotewrap);


        Phoenix_AddIPAProdcutsCtrl.getQuoteLineItems(productIds);
        list < Phoenix_Contract__c > pcList = new list < Phoenix_Contract__c > ();
        Phoenix_Contract__c pc1 = new Phoenix_Contract__c(Name = 'Test Contract1', Phoenix_Contract_Number__c = '1234567', Phoenix_Is_IPA_Contract__c = true);
        Phoenix_Contract__c pc2 = new Phoenix_Contract__c(Name = 'Test Contract2', Phoenix_Contract_Number__c = '5671234', Phoenix_Is_IPA_Contract__c = true);
        Phoenix_Contract__c pc3 = new Phoenix_Contract__c(Name = 'Test Contract3', Phoenix_Contract_Number__c = '6754321', Phoenix_Is_IPA_Contract__c = true);
        Phoenix_Contract__c pc4 = new Phoenix_Contract__c(Name = 'Test Contract4', Phoenix_Contract_Number__c = '67004321', Phoenix_Is_IPA_Contract__c = true);

        pcList.add(pc1);
        pcList.add(pc2);
        pcList.add(pc3);
        pcList.add(pc4);
        insert pcList;
        list < Phoenix_NPR_Data__c > nprList = new list < Phoenix_NPR_Data__c > ();
        Phoenix_NPR_Data__c npr1 = new Phoenix_NPR_Data__c(Phoenix_Contract__c = pcList[0].Id, Phoenix_Product__c = productIds[0]);
        Phoenix_NPR_Data__c npr2 = new Phoenix_NPR_Data__c(Phoenix_Contract__c = pcList[1].Id, Phoenix_Product__c = productIds[1]);
        Phoenix_NPR_Data__c npr3 = new Phoenix_NPR_Data__c(Phoenix_Contract__c = pcList[2].Id, Phoenix_Product__c = productIds[2]);
        Phoenix_NPR_Data__c npr4 = new Phoenix_NPR_Data__c(Phoenix_Contract__c = pcList[3].Id, Phoenix_Product__c = productIds[3]);
        nprList.add(npr1);
        nprList.add(npr2);
        nprList.add(npr3);
        nprList.add(npr4);
        insert nprList;
        list < Phoenix_Bid_Line_Item__c > lineItemsList = new list < Phoenix_Bid_Line_Item__c > ();
        for (Integer i = 0; i < prodList.size(); i++) {
            Phoenix_Bid_Line_Item__c pbl = new Phoenix_Bid_Line_Item__c(Phoenix_Bid__c = pb.Id, Phoenix_Product__c = prodList[i].Id, Phoenix_Contract__c = pcList[i].Id);
            lineItemsList.add(pbl);
        }


        Phoenix_AddIPAProdcutsCtrl.fetchSortResults('Name', true, wrap);
        Phoenix_AddIPAProdcutsCtrl.fetchSortResults('Name', false, wrap);
        Phoenix_AddIPAProdcutsCtrl.getContractData(productIds, pbWrapper1);



        list < Phoenix_AddIPAProdcutsCtrl.wrapperClass > wrapper = new list < Phoenix_AddIPAProdcutsCtrl.wrapperClass > ();
        for (Integer i = 0; i < pcList.size(); i++) {
            Phoenix_AddIPAProdcutsCtrl.wrapperClass pbw = new Phoenix_AddIPAProdcutsCtrl.wrapperClass();
            pbw.contrt = pcList[i];
            pbw.contrFlag = true;
            pbw.currencyCode = '$';
            wrapper.add(pbw);


        }


        Phoenix_AddIPAProdcutsCtrl.fetchContrSortResults('Phoenix_Contract_External_Description__c', true, wrapper);
        Phoenix_AddIPAProdcutsCtrl.fetchContrSortResults('Phoenix_Contract_External_Description__c', false, wrapper);
        pb.Phoenix_Bid_Type__c = 'SRx IPA Product Addition';
        update pb;
        Phoenix_AddIPAProdcutsCtrl.insertContrProducts(lineItemsList, pcList, pb.Id);
    }

}