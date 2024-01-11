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
public class Phoenix_AddProdcutRemDiscCtrl2Test {
    static testmethod void Phoenix_AddProdcutRemDisc() {
        Id phoenixRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Bid Accounts').getRecordTypeId();
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        list < Product2 > prodList1 = new list < Product2 > ();
        Product2 prod1 = new Product2(Name = 'Test Product', Phoenix_IPA_Floor_Price__c = 100, Phoenix_Is_IPA_Product__c = TRUE, Phoenix_GPI_Generic_Product_Identifier__c = '11111', Phoenix_NDC_11__c = '12345678902', Family = 'Test Family', IsActive = TRUE);
        Product2 prod2 = new Product2(Name = 'Test Product1', Phoenix_IPA_Floor_Price__c = 100, Phoenix_Is_IPA_Product__c = TRUE, Phoenix_GPI_Generic_Product_Identifier__c = '22222', Phoenix_NDC_11__c = '21345678902', Family = 'Sample Family', IsActive = TRUE);
        Product2 prod3 = new Product2(Name = 'Test Product2', Phoenix_IPA_Floor_Price__c = 100, Phoenix_Is_IPA_Product__c = TRUE, Phoenix_NDC_11__c = '32145678902', Family = ' cetirizine', IsActive = TRUE);
        Product2 prod4 = new Product2(Name = 'Test Product3', Phoenix_IPA_Floor_Price__c = 100, Phoenix_Is_IPA_Product__c = TRUE, Phoenix_GPI_Generic_Product_Identifier__c = '333333', Family = ' cetirizine', IsActive = TRUE);

        prodList1.add(prod1);
        prodList1.add(prod2);
        prodList1.add(prod3);
        prodList1.add(prod4);
        insert prodList1;
        Phoenix_Bid__c pb = new Phoenix_Bid__c();
        pb.Phoenix_Status__c = 'New';
        pb.Phoenix_Bid_Type__c = 'Mass Product Removals';
        pb.Phoenix_Comments__c = 'Test Comments';
        pb.Phoenix_Customer__c = testAccount.Id;
        insert pb;
        Phoenix_AddProdcutRemDiscCtrl2.BidWrapper pbWrapper = new Phoenix_AddProdcutRemDiscCtrl2.BidWrapper();
        pbWrapper = Phoenix_AddProdcutRemDiscCtrl2.getbidInfo(pb.Id);
        Phoenix_AddProdcutRemDiscCtrl2.getDocs(pb.Id);
         Phoenix_AddProdcutRemDiscCtrl2.getExistingDocs(pb.Id);
        Phoenix_AddProdcutRemDiscCtrl2.BidWrapper pbWrapper1 = new Phoenix_AddProdcutRemDiscCtrl2.BidWrapper();
        pbWrapper1.bid = pb;
        pbWrapper1.isBidCreated = true;
        Phoenix_AddProdcutRemDiscCtrl2.getIPAproducts(pb.Id);

        list < Phoenix_AddProdcutRemDiscCtrl2.wrapperClass > wrap = new list < Phoenix_AddProdcutRemDiscCtrl2.wrapperClass > ();
        list < string > productIds = new list < string > ();
        for (Integer i = 0; i < prodList1.size(); i++) {
            Phoenix_AddProdcutRemDiscCtrl2.wrapperClass pbw = new Phoenix_AddProdcutRemDiscCtrl2.wrapperClass();
            pbw.prdlist = prodList1[i];
            pbw.isSelected = true;
            pbw.currencyCode = '$';
            wrap.add(pbw);
            productIds.add(prodList1[i].Id);

        }
        string search = 'test';
        string searchFamily = 'test';
        list < string > RxSrxList = new list < string > ();
        RxSrxList.add('Rx');
        list < string > directorList = new list < string > ();
        directorList.add('Suseela Dhruvsoft');
        string searchNDC = '12345678902 21345678902';
      /*  Phoenix_AddProdcutRemDiscCtrl2.getSearch(wrap, directorList, search, searchFamily, RxSrxList);
        Phoenix_AddProdcutRemDiscCtrl2.getSearch(wrap, directorList, '333333', searchFamily, RxSrxList);
        Phoenix_AddProdcutRemDiscCtrl2.getSearch(wrap, directorList, searchNDC, searchFamily, RxSrxList);*/
        Phoenix_AddProdcutRemDiscCtrl2.getSearchFamily(wrap, directorList, searchFamily, search, RxSrxList); 
        Phoenix_AddProdcutRemDiscCtrl2.getsearchDirectorResult(wrap, directorList, searchFamily, search, RxSrxList);
        Phoenix_AddProdcutRemDiscCtrl2.findBySrxOtc(RxSrxList, directorList, search, searchFamily, wrap);
        Phoenix_AddProdcutRemDiscCtrl2.getProductDirectorList(pbWrapper);
        Phoenix_AddProdcutRemDiscCtrl2.showselectedProducts(pb.Id);
        list < Phoenix_Contract__c > pcList = new list < Phoenix_Contract__c > ();
        Phoenix_Contract__c pc1 = new Phoenix_Contract__c(Name = 'Test Contract1', Phoenix_Contract_Number__c = '1234567', Phoenix_Is_IPA_Contract__c = true, Phoenix_Customer__c = testAccount.Id,	Phoenix_Contract_Start_Date__c=date.newInstance(2022, 06, 27),	Phoenix_Contract_End_Date__c=date.newInstance(2028, 06, 27));
        Phoenix_Contract__c pc2 = new Phoenix_Contract__c(Name = 'Test Contract2', Phoenix_Contract_Number__c = '5671234', Phoenix_Is_IPA_Contract__c = true, Phoenix_Customer__c = testAccount.Id);
        Phoenix_Contract__c pc3 = new Phoenix_Contract__c(Name = 'Test Contract3', Phoenix_Contract_Number__c = '6754321', Phoenix_Is_IPA_Contract__c = true, Phoenix_Customer__c = testAccount.Id);
        Phoenix_Contract__c pc4 = new Phoenix_Contract__c(Name = 'Test Contract4', Phoenix_Contract_Number__c = '67004321', Phoenix_Is_IPA_Contract__c = true, Phoenix_Customer__c = testAccount.Id);

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
        Phoenix_AddProdcutRemDiscCtrl2.getQuoteLineItems(productIds, pb.Id);
		Phoenix_AddProdcutRemDiscCtrl2.codeCoverage();


        //Phoenix_AddIPAProdcutsCtrl.savequoteitems(lineItemsList, pb.Id);
        Phoenix_AddProdcutRemDiscCtrl2.fetchSortResults('Name', true, wrap);
        Phoenix_AddProdcutRemDiscCtrl2.fetchSortResults('Name', false, wrap);
        //Phoenix_AddProdcutRemDiscCtrl2.getContractData(productIds, pbWrapper1);
       // Phoenix_AddProdcutRemDiscCtrl2.finalSearchResult(pbWrapper, 'productIds', 'searchFamily', 'searchFamily', 'RxSrxList', pbWrapper);



        list < Phoenix_AddProdcutRemDiscCtrl2.wrapperClass > wrapper = new list < Phoenix_AddProdcutRemDiscCtrl2.wrapperClass > ();
        for (Integer i = 0; i < nprList.size(); i++) {
            Phoenix_AddProdcutRemDiscCtrl2.wrapperClass pbw = new Phoenix_AddProdcutRemDiscCtrl2.wrapperClass();
            pbw.npr = nprList[i];
            pbw.contrt = pcList[i];
            pbw.contrFlag = true;
            pbw.family = prodList1[i].Family;
            pbw.NDC = prodList1[i].Phoenix_NDC_11__c;
            pbw.prodName = prodList1[i].Name;

            //pbw.currencyCode = '$';
            wrapper.add(pbw);


        }
        string searchContr = 'suseela';

        Phoenix_AddProdcutRemDiscCtrl2.fetchContrSortResults('Phoenix_Contract_External_Description__c', true, wrapper);
        Phoenix_AddProdcutRemDiscCtrl2.fetchContrSortResults('Phoenix_Contract_External_Description__c', false, wrapper);

        Phoenix_AddProdcutRemDiscCtrl2.insertContrProducts(wrapper, pb.Id);
        Phoenix_AddProdcutRemDiscCtrl2.getContractSearch(wrapper, 'test');
        list < Phoenix_Bid_Line_Item__c > lineItemsList = new list < Phoenix_Bid_Line_Item__c > ();
        for (Integer i = 0; i < prodList1.size(); i++) {
            Phoenix_Bid_Line_Item__c pbl = new Phoenix_Bid_Line_Item__c(Phoenix_Bid__c = pb.Id, Phoenix_Product__c = prodList1[i].Id, Phoenix_Contract__c = pcList[i].Id, Phoenix_SCM_Notes__c = 'test scm comments');
            lineItemsList.add(pbl);
        }
        insert lineItemsList;
        Phoenix_AddProdcutRemDiscCtrl2.updateContrProducts(lineItemsList);

        Phoenix_Bid__c bid2 = new Phoenix_Bid__c();
        bid2.Phoenix_Bid_Type__c = 'Customer Rebate Change';
        insert bid2;

        Phoenix_Bid_Line_Item__c bidLi = new Phoenix_Bid_Line_Item__c();
        bidLi.Phoenix_Bid__c = bid2.Id;
        insert bidLi;

        Phoenix_Customer_Response__c recb2 = new Phoenix_Customer_Response__c();
        recb2.Phoenix_Bid_No__c = bid2.Id;
        insert recb2;

        Phoenix_Customer_Response_Line__c recb3 = new Phoenix_Customer_Response_Line__c();
        recb3.Phoenix_Awarded_Quantity__c = 210;
        recb3.Phoenix_Customer_Response__c = recb2.Id;
        recb3.Phoenix_Bid_Line_Item__c = bidLi.Id;
        recb3.Phoenix_Customer_status_internal_use__c = 'Not Approved';
        recb3.Phoenix_Bid_Status__c = 'Awarded';
        insert recb3;

        Phoenix_Customer_Response_Line__c recb5 = new Phoenix_Customer_Response_Line__c();
        recb5.Phoenix_Awarded_Quantity__c = 210;
        recb5.Phoenix_Customer_Response__c = recb2.Id;
        //recb5.Phoenix_Bid_Line_Item__c = bdli4.Id;
        recb5.Phoenix_Customer_status_internal_use__c = 'Not Approved';
        recb5.Phoenix_Bid_Status__c = 'Awarded';
        insert recb5;


        Phoenix_Customer_Response_Line__c recb1 = new Phoenix_Customer_Response_Line__c();
        recb1.Phoenix_Awarded_Quantity__c = 5999;
        recb1.Phoenix_Customer_Response__c = recb2.Id;
        recb1.Phoenix_Bid_Status__c = 'Awarded';
        recb1.Phoenix_Customer_status_internal_use__c = 'Not Approved';
        recb1.Phoenix_Bid__c = bid2.Id;
        insert recb1;

        Phoenix_Bid_Line_Item__c bdli4 = new Phoenix_Bid_Line_Item__c(Id = bidLi.Id);
        bdli4.Phoenix_Customer_Response_Line__c = recb1.Id;
        bdli4.Phoenix_Customer_Response__c = recb2.Id;
        update bdli4;

        Phoenix_Customer_Response_Line__c recb12 = new Phoenix_Customer_Response_Line__c(Id = recb1.Id);
        recb12.Phoenix_Bid_Line_Item__c = bdli4.Id;
        //recb12.Phoenix_Bid_Line_Item__r.Name = bdli4.Name;
        update recb12;

        Phoenix_Bid_Process_Steps__c bps = new Phoenix_Bid_Process_Steps__c();
        bps.Name = 'test';
        bps.Phoenix_Bid__c = bid2.Id;
        insert bps;


        List < Phoenix_Customer_Response_Line__c > crLIList = new List < Phoenix_Customer_Response_Line__c > ();
        crLIlist.add(recb12);
        //crLIlist.add(recb3);
        //crLIlist.add(recb5);
	Phoenix_CustomerResponseViewController.codeCoverageBlock();
		List<String> prodDir = new List<String>();
        prodDir.add('Anupama');
        List<String> segmentList = new List<String>();
        prodDir.add('Rx');
         prodDir.add('SRx');
          prodDir.add('OTC');
        Phoenix_CustomerResponseViewController.getLoginUserDetails(bid2.Id);
       // Phoenix_CustomerResponseViewController.getLoginUserDetailsVU(bid2.Id);
       
        Phoenix_CustomerResponseViewController.getBid(recb2.Id);
       // Phoenix_CustomerResponseViewController.getDocs(bid2.Id);
        Phoenix_CustomerResponseViewController.getCRLineItems(recb2.Id);
       Phoenix_AddProdcutRemDiscCtrl2.getSearchFamily(wrapper,prodDir,'Alluop','cetre',segmentList);
        Phoenix_AddProdcutRemDiscCtrl2.finalSearchResult(wrapper,prodDir,'Alluop','cetre',segmentList,pbWrapper);
       // Phoenix_AddProdcutRemDiscCtrl2.justIncrement();
       // Phoenix_AddProdcutRemDiscCtrl2.finalSearchResult(pbWrapper,productIds,searchFamily,searchFamily,RxSrxList,pbWrapper);
        //Phoenix_CustomerResponseViewController.updateBidLineItemsWithVistex(recb2.Id);
        //Phoenix_CustomerResponseViewController.updateCRLIRealatedBidLI(crLIList, bid2.Id);
    }

		
    
}