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
public class Phoenix_AddIPAProdcutsCtrl {


    public static Phoenix_Bid__c bid;
    public static BidWrapper wrapper;

    static {
        bid = new Phoenix_Bid__c();
        wrapper = new BidWrapper();
    }

    @AuraEnabled
    public static BidWrapper getbidInfo(String bidId) {
        BidWrapper wrapperCls = new BidWrapper();

        if (bidId != null) {
            wrapperCls.bid = Database.query('SELECT ' + Phoenix_Util.getsObjectFieds('Phoenix_Bid__c') + ' FROM Phoenix_Bid__c WHERE Id =: bidId LIMIT 1');
            list < Phoenix_Bid_Line_Item__c > bidlineList = [select Id, Phoenix_Product__c from Phoenix_Bid_Line_Item__c where Phoenix_Bid__c =: bidId];


            set < Id > prodIds = new set < Id > ();
            if (bidlineList.size() > 0) {
                for (Phoenix_Bid_Line_Item__c pbl: bidlineList) {
                    prodIds.add(pbl.Phoenix_Product__c);
                }
            }
            if (prodIds.size() > 0) {
                wrapperCls.recordCount = prodIds.size();
            }
        }

        return wrapperCls;
    }
    @AuraEnabled
    public static List < string > getProductDirectorList(BidWrapper bidwrap) {
        Phoenix_Bid__c bid = bidwrap.bid;
        String query = '';
        String SobjectApiName = 'Product2';
        Map < String, Schema.SObjectType > schemaMap = Schema.getGlobalDescribe();
        Map < String, Schema.SObjectField > fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();
        /* Added to avoid Duplicate Production 
        List<wrapperClass> wrExistingProdlist=new List<wrapperClass>();
		Set<Id> duplicatePrdCheck=new Set<Id>();
		wrExistingProdlist=Phoenix_AddIPAProdcutsCtrl.showselectedProducts(bid.Id);
        for(wrapperClass wr:wrExistingProdlist){
            duplicatePrdCheck.add(wr.prdlist.Id);
        } */
        String strFields = '';

        for (String fieldName: fieldMap.keyset()) {
            if (strFields == null || strFields == '') {
                strFields = fieldName;
            } else {
                strFields = strFields + ' , ' + fieldName;
            }
        }

        query = 'select Phoenix_Product_Director__r.Name,' + strFields + ' from Product2 where (IsActive = true AND Phoenix_Is_Exclude_Bid__c=false AND Phoenix_Is_IPA_Product__c=true   ) ORDER BY Name ASC NULLS LAST LIMIT 30000 ';

        list < Product2 > quoteList = Database.query(query);
        system.debug('quoteList--->' + quoteList);


        List < String > productDirectorList = new List < String > ();

        for (Product2 lineItem: quoteList) {


            if (lineItem.Phoenix_Product_Director__r.Name != null && !productDirectorList.contains(lineItem.Phoenix_Product_Director__r.Name)) {
                productDirectorList.add(lineItem.Phoenix_Product_Director__r.Name);
            }

        }
        return productDirectorList;


    }
    @AuraEnabled
    public static List < wrapperClass > getIPAproducts(string recordId) {
        Phoenix_Bid__c bid = new Phoenix_Bid__c();
        List < wrapperClass > wrlist = new List < wrapperClass > ();
        Set < id > pids = new Set < id > ();
        Map < Id, Product2 > pdMap = new Map < Id, Product2 > ();
        bid = [select Id, Phoenix_Bid_Type__c from Phoenix_Bid__c where Id =: recordId];
        /*Added to avoid Duplicate Production */
        List < wrapperClass > wrExistingProdlist = new List < wrapperClass > ();
        Set < Id > duplicatePrdCheck = new Set < Id > ();
        wrExistingProdlist = Phoenix_AddIPAProdcutsCtrl.showselectedProducts(bid.Id);
        for (wrapperClass wr: wrExistingProdlist) {
            duplicatePrdCheck.add(wr.prdlist.Id);
        }

        if (bid.Phoenix_Bid_Type__c == 'SRx IPA Price Change' || bid.Phoenix_Bid_Type__c == 'SRx IPA Product Addition' || bid.Phoenix_Bid_Type__c == 'IPA Floor Pricing Update') {




            string query = '';
            if (bid.Phoenix_Bid_Type__c == 'IPA Floor Pricing Update') {
                query = 'SELECT Phoenix_Product_Director__r.Name,Product_Family__r.Name,' + Phoenix_Util.getsObjectFieds('Product2') + ' FROM Product2 WHERE (IsActive = true AND Phoenix_Is_Exclude_Bid__c=false AND Phoenix_Is_IPA_Product__c=TRUE  AND Id NOT in :duplicatePrdCheck ) ORDER BY Name ASC NULLS LAST LIMIT 30000';

            } else {
                query = 'SELECT Phoenix_Product_Director__r.Name,Product_Family__r.Name,' + Phoenix_Util.getsObjectFieds('Product2') + ' FROM Product2 WHERE (IsActive = true AND Phoenix_Is_Exclude_Bid__c=false AND Phoenix_Is_IPA_Product__c=TRUE   ) ORDER BY Name ASC NULLS LAST LIMIT 30000';

            }

            List < Product2 > prlist = Database.query(query);


            for (Product2 pr: prlist) {
                pids.add(pr.Id);
                pdMap.put(pr.Id, pr);
            }


            if (prlist.size() > 0) {
                for (Product2 pr: prlist) {
                    wrapperClass wr = new wrapperClass();
                    wr.prdlist = pr;
                    if (pr.Phoenix_IPA_Floor_Price__c != null) {
                        wr.currencyCode = '$';
                    }
                    if (pr.Phoenix_WAC__c != null) {
                        wr.currencyCode1 = '$';
                    }
                    wr.isSelected = false;
                    wrlist.add(wr);
                }
            }


        }


        return wrlist;
    }
    @AuraEnabled
    public static List < wrapperClass > showselectedProducts(string bidId) {
        list < Phoenix_Bid_Line_Item__c > bidlineList = [select Id, Phoenix_Product__c from Phoenix_Bid_Line_Item__c where Phoenix_Bid__c =: bidId];
        list < Product2 > productList = new list < Product2 > ();
        list < wrapperClass > wrapList = new list < wrapperClass > ();
        set < Id > prodIds = new set < Id > ();
        if (bidlineList.size() > 0) {
            for (Phoenix_Bid_Line_Item__c pbl: bidlineList) {
                prodIds.add(pbl.Phoenix_Product__c);
            }
        }
        if (prodIds.size() > 0) {
            productList = [select Name,Phoenix_NDC_11__c,ProductCode,Family,Product_Family__r.Name from Product2 where Id IN: prodIds ORDER BY Name ASC NULLS LAST LIMIT 30000];

            for (Product2 pr: productList) {
                wrapperClass wr = new wrapperClass();
                wr.prdlist = pr;
                wrapList.add(wr);
            }
        }

        return wrapList;

    }

    @AuraEnabled
    public static List < wrapperClass > getsearchDirectorResult(List < wrapperClass > pItem, list < string > SearchKeyWordPD, string searchName, BidWrapper quotewrap) {

        List < wrapperClass > wralist = new List < wrapperClass > ();
        list < string > searchupdateList = new list < string > ();
        String query1;
        String searchText;

        list < string > productDirectors = new list < string > ();
        list < string > NewproductDirectors;
        string searchPD;

        /* Added to avoid Duplicate Production  */
        List < wrapperClass > wrExistingProdlist = new List < wrapperClass > ();
        Set < Id > duplicatePrdCheck = new Set < Id > ();
        wrExistingProdlist = Phoenix_AddIPAProdcutsCtrl.showselectedProducts(bid.Id);
        for (wrapperClass wr: wrExistingProdlist) {
            duplicatePrdCheck.add(wr.prdlist.Id);
        }



        List < String > searchList;
        list < Product2 > prodNameList = new list < Product2 > ();



        // system.debug('searchText---'+searchText);


        if (string.isNotBlank(searchName)) {
            searchText = searchName.trim();
            searchText = searchText.replace('\\s+', ' ');



            prodNameList = [select Id, Name from Product2 where IsActive = true AND Phoenix_Is_Exclude_Bid__c = false AND Phoenix_Is_IPA_Product__c = true AND Name =: searchText];
            if (prodNameList.size() == 0) {
                searchList = searchText.split(' ');
                for (string str: searchList) {
                    string searchItem = '%' + str + '%';
                    searchupdateList.add(searchItem);

                }
            } else {
                searchupdateList.add('%' + searchText + '%');
            }
        }

        query1 = 'SELECT Id,Product_Family__r.Name,Phoenix_Product_Director__r.Name,Phoenix_Date_of_Discontinuation__c ,Phoenix_Product_Type_for_CM_Fee__c,Phoenix_Rx_SRx_OTC__c,Name,ProductCode,Phoenix_NDC_11__c,Phoenix_GCN_Generic_Code_Number__c,Phoenix_GCN_Sequence_Number__c,Phoenix_NDC_11_Dashes__c,Phoenix_GPI_Generic_Product_Identifier__c,Phoenix_GPI_Dashes__c,Family,Phoenix_Strength__c,Phoenix_Pkg_Size__c,Phoenix_WAC__c,Phoenix_Product_Director__c,Phoenix_Compare_to_Brand_Name__c FROM Product2 WHERE (IsActive = true AND Phoenix_Is_IPA_Product__c=true AND Phoenix_Is_Exclude_Bid__c=false AND Phoenix_Product_Director__r.Name like :SearchKeyWordPD  ) ORDER BY Name ASC NULLS LAST LIMIT 30000';

        list < Product2 > productList = Database.query(query1);

        if (productList.size() > 0 && string.isNotBlank(searchName)) {
            string query3;
            query3 = 'SELECT Id,Product_Family__r.Name,Phoenix_Product_Director__r.Name,Phoenix_Date_of_Discontinuation__c ,Phoenix_Product_Type_for_CM_Fee__c,Phoenix_Rx_SRx_OTC__c,Name,ProductCode,Phoenix_NDC_11__c,Phoenix_GCN_Generic_Code_Number__c,Phoenix_GCN_Sequence_Number__c,Phoenix_NDC_11_Dashes__c,Phoenix_GPI_Generic_Product_Identifier__c,Phoenix_GPI_Dashes__c,Family,Phoenix_Strength__c,Phoenix_Pkg_Size__c,Phoenix_WAC__c,Phoenix_Product_Director__c,Phoenix_Compare_to_Brand_Name__c FROM Product2 WHERE (ID IN:productList AND Phoenix_Is_IPA_Product__c=true AND (Name like :searchupdateList OR Phoenix_Compare_to_Brand_Name__c like :searchupdateList OR Phoenix_UPC_Universal_Product_Code__c like :searchupdateList OR Phoenix_NDC_11__c like :searchupdateList OR ProductCode like :searchupdateList OR Phoenix_NDC_11_Dashes__c like :searchupdateList OR Phoenix_GPI_Generic_Product_Identifier__c like :searchupdateList OR Phoenix_GPI_Dashes__c like :searchupdateList OR Phoenix_GCN_Generic_Code_Number__c like :searchupdateList OR Phoenix_GCN_Sequence_Number__c like :searchupdateList)  ) ORDER BY Name ASC NULLS LAST LIMIT 30000';
            productList = Database.query(query3);
        }


        system.debug('productList----' + productList);
        Map < Id, Product2 > productMap = new map < Id, Product2 > (productList);
        for (wrapperClass w: pItem) {
            if (productMap.containskey(w.prdlist.Id))
                wralist.add(w);

        }
        system.debug('wralist----' + wralist);


        return wralist;
    }

    @AuraEnabled
    public static List < wrapperClass > getContractSearch(List < wrapperClass > pItem, string search) {
        List < wrapperClass > wralist = new List < wrapperClass > ();
          String query1;
        set<Id>contractIds=new set<Id>();
        for(wrapperClass w: pItem){
            contractIds.add(w.contrt.Id);
}
        
        
          list < string > searchupdateList = new list < string > ();
        String searchText = search.trim();
        searchText = searchText.replace('\\s+', ' ');
        searchupdateList.add('%' + searchText + '%');
        system.debug('searchText-----' + searchText);
        
         query1 = 'select Id, Name, Product_Family__r.Name,Phoenix_Contract_External_Description__c, Phoenix_Contract_Internal_Description__c, OwnerId, Owner.Name, Phoenix_Customer__c, Phoenix_Customer__r.Name, Phoenix_Customer_Number__c, Phoenix_Contract_Number__c from Phoenix_Contract__c where ((ID IN:contractIds ) AND(Name like :searchupdateList OR Owner.Name like :searchupdateList OR Phoenix_Contract_External_Description__c like :searchupdateList OR Phoenix_Contract_Internal_Description__c like :searchupdateList OR Phoenix_Customer__r.Name like :searchupdateList OR Phoenix_Contract_Number__c like :searchupdateList)  )  LIMIT 30000';

        list < Phoenix_Contract__c > productList = Database.query(query1);
        /*for (wrapperClass w: pItem) {
            if (w.contrt.Phoenix_Customer__r.Name != null) {
                system.debug('w.contrt.Name' + w.contrt.Name);
                system.debug('w.contrt.Phoenix_Customer__r' + w.contrt.Phoenix_Customer__r.Name);
                system.debug('w.contrt.Owner.Name' + w.contrt.Owner.Name);
                system.debug('w.contrt.Phoenix_Contract_Number__c' + w.contrt.Phoenix_Contract_Number__c);

                if (w.contrt.Name.startsWithIgnoreCase(searchText) || w.contrt.Name.containsIgnoreCase(searchText) || w.contrt.Phoenix_Contract_External_Description__c.containsIgnoreCase(searchText) || w.contrt.Phoenix_Contract_Internal_Description__c.containsIgnoreCase(searchText) || w.contrt.Phoenix_Customer__r.Name.startsWithIgnoreCase(searchText) || w.contrt.Phoenix_Customer__r.Name.containsIgnoreCase(searchText) || w.contrt.Owner.Name.startsWithIgnoreCase(searchText) || w.contrt.Owner.Name.containsIgnoreCase(searchText) || ( w.contrt.Phoenix_Contract_Number__c!=null && w.contrt.Phoenix_Contract_Number__c.startsWith(searchText))) {

                    wralist.add(w);
                }
            }
else {
                if (w.contrt.Name.startsWithIgnoreCase(searchText) || w.contrt.Name.containsIgnoreCase(searchText) || w.contrt.Owner.Name.startsWithIgnoreCase(searchText) || w.contrt.Phoenix_Contract_External_Description__c.containsIgnoreCase(searchText) || w.contrt.Phoenix_Contract_Internal_Description__c.containsIgnoreCase(searchText) || w.contrt.Phoenix_Customer__r.Name.containsIgnoreCase(searchText) || w.contrt.Phoenix_Contract_Number__c.startsWith(searchText) || w.contrt.Phoenix_Contract_Number__c.contains(searchText)) {

                    wralist.add(w);
                }

            }

        }*/
        
         Map < Id, Phoenix_Contract__c > productMap = new map < Id, Phoenix_Contract__c > (productList);
        for (wrapperClass w: pItem) {
            if (productMap.containskey(w.contrt.Id))
                wralist.add(w);

        }
        system.debug('wralist------' + wralist);
        if (wralist.size() > 0) {
            return wralist;
        } else {
            return null;
        }

    }

    @AuraEnabled
    public static List < wrapperClass > getSearch(List < wrapperClass > pItem, list < string > SearchKeyWordPD, string search, BidWrapper quotewrap) {

        List < wrapperClass > wralist1 = new List < wrapperClass > ();
        String searchText = search.trim();

        /* Added to avoid Duplicate Production 
        List<wrapperClass> wrExistingProdlist=new List<wrapperClass>();
		Set<Id> duplicatePrdCheck=new Set<Id>();
		wrExistingProdlist=Phoenix_AddIPAProdcutsCtrl.showselectedProducts(bid.Id);
        for(wrapperClass wr:wrExistingProdlist){
            duplicatePrdCheck.add(wr.prdlist.Id);
        } */



        system.debug('searchText---' + searchText);
        searchText = searchText.replace('\\s+', ' ');
        system.debug('searchText---' + searchText);
        set < Id > RxProdIds = new set < Id > ();
        list < string > searchupdateList = new list < string > ();
        String query1;
        list < Product2 > prodNameList = new list < Product2 > ();

        prodNameList = [select Id, Name from Product2 where IsActive = true AND Phoenix_Is_Exclude_Bid__c = false AND Phoenix_Is_IPA_Product__c = true AND Name =: searchText];

        if (prodNameList.size() == 0) {
            List < String > searchList = searchText.split(' ');
            for (string str: searchList) {
                string searchItem = '%' + str + '%';
                searchupdateList.add(searchItem);

            }
        } else {
            searchupdateList.add('%' + searchText + '%');
        }
        system.debug('searchupdateList----' + searchupdateList);




        query1 = 'SELECT Id,Product_Family__r.Name,Phoenix_Product_Director__r.Name,Phoenix_Date_of_Discontinuation__c ,Phoenix_Product_Type_for_CM_Fee__c,Phoenix_Rx_SRx_OTC__c,Name,ProductCode,Phoenix_NDC_11__c,Phoenix_GCN_Generic_Code_Number__c,Phoenix_GCN_Sequence_Number__c,Phoenix_NDC_11_Dashes__c,Phoenix_GPI_Generic_Product_Identifier__c,Phoenix_GPI_Dashes__c,Family,Phoenix_Strength__c,Phoenix_Pkg_Size__c,Phoenix_WAC__c,Phoenix_Product_Director__c,Phoenix_Compare_to_Brand_Name__c FROM Product2 WHERE ((IsActive = true AND Phoenix_Is_IPA_Product__c=true AND Phoenix_Is_Exclude_Bid__c=false ) AND(Name like :searchupdateList OR Phoenix_Compare_to_Brand_Name__c like :searchupdateList OR Phoenix_UPC_Universal_Product_Code__c like :searchupdateList OR Phoenix_NDC_11__c like :searchupdateList OR ProductCode like :searchupdateList OR Phoenix_NDC_11_Dashes__c like :searchupdateList OR Phoenix_GPI_Generic_Product_Identifier__c like :searchupdateList OR Phoenix_GPI_Dashes__c like :searchupdateList OR Phoenix_GCN_Generic_Code_Number__c like :searchupdateList OR Phoenix_GCN_Sequence_Number__c like :searchupdateList OR Product_Family__r.Name like :searchupdateList )  ) ORDER BY Name ASC NULLS LAST LIMIT 30000';

        list < Product2 > productList = Database.query(query1);


        if (productList.size() > 0 && SearchKeyWordPD != null && !SearchKeyWordPD.isEmpty()) {
            string query4;
            query4 = 'SELECT Id,Product_Family__r.Name,Phoenix_Product_Director__r.Name,Phoenix_Date_of_Discontinuation__c ,Phoenix_Product_Type_for_CM_Fee__c,Phoenix_Rx_SRx_OTC__c,Name,ProductCode,Phoenix_NDC_11__c,Phoenix_GCN_Generic_Code_Number__c,Phoenix_GCN_Sequence_Number__c,Phoenix_NDC_11_Dashes__c,Phoenix_GPI_Generic_Product_Identifier__c,Phoenix_GPI_Dashes__c,Family,Phoenix_Strength__c,Phoenix_Pkg_Size__c,Phoenix_WAC__c,Phoenix_Product_Director__c,Phoenix_Compare_to_Brand_Name__c FROM Product2 WHERE (ID IN:productList AND Phoenix_Is_IPA_Product__c=true AND Phoenix_Product_Director__r.Name like :SearchKeyWordPD  ) ORDER BY Name ASC NULLS LAST LIMIT 30000';
            productList = Database.query(query4);
        }

        Map < Id, Product2 > productMap = new map < Id, Product2 > (productList);
        for (wrapperClass w: pItem) {
            if (productMap.containskey(w.prdlist.Id))
                wralist1.add(w);

        }

        return wralist1;
    }


    @AuraEnabled
    public static List < wrapperClass > getQuoteLineItems(List < String > prdlist) {

        list < Product2 > prodList = [select Name,Product_Family__r.Name, Family, Phoenix_NDC_11__c, Phoenix_Date_of_Discontinuation__c, Phoenix_Throughput_cost__c, Phoenix_IPA_Floor_Price__c, Phoenix_Case_Pack__c, Phoenix_WAC__c, Phoenix_Minimum_Order_Quantity__c
            from Product2
            where ID IN: prdlist
        ];
        Map < Id, Product2 > mpdlist = new Map < Id, Product2 > ();
        for (Product2 pr: prodList) {
            mpdlist.put(pr.Id, pr);
        }
        // system.debug('mpdlist--------' + mpdlist);


        List < wrapperClass > wrlist = new List < wrapperClass > ();

        List < Phoenix_Bid_Line_Item__c > qnewlist = new List < Phoenix_Bid_Line_Item__c > ();
        if (prdlist.size() > 0) {
            for (String prId: prdlist) {
                Phoenix_Bid_Line_Item__c ql = new Phoenix_Bid_Line_Item__c(Phoenix_Product__c = prId);
                wrapperClass wr1 = new wrapperClass();
                wr1.qlItem = ql;
                wr1.prodName = mpdlist.get(prId).Name;
                if (mpdlist.get(prId).Phoenix_IPA_Floor_Price__c != null) {
                    wr1.currencyCode = '$';
                    wr1.IPAPrice = mpdlist.get(prId).Phoenix_IPA_Floor_Price__c;

                }
                if (mpdlist.get(prId).Product_Family__c != null && mpdlist.get(prId).Phoenix_NDC_11__c != null) {
                    wr1.family = mpdlist.get(prId).Product_Family__r.Name;
                    wr1.familyId = mpdlist.get(prId).Product_Family__c;
                    wr1.NDC = mpdlist.get(prId).Phoenix_NDC_11__c;
                }

                wrlist.add(wr1);
            }
        }
        return wrlist;
    }


    @AuraEnabled
    public static list < Phoenix_Bid_Line_Item__c > insertContrProducts(list < Phoenix_Bid_Line_Item__c > saveitems, list < Phoenix_Contract__c > savecontrs, string bidId) {
        // system.debug('In savequoteitems');
        string query;
        list < Phoenix_Bid_Line_Item__c > newItems = new list < Phoenix_Bid_Line_Item__c > ();
        list < Phoenix_Bid_Line_Item__c > insertItems = new list < Phoenix_Bid_Line_Item__c > ();
        insertItems = [select Phoenix_Product__c, Phoenix_Product__r.Name, Phoenix_Contract__c, Phoenix_Contract__r.Name from Phoenix_Bid_Line_Item__c where Phoenix_Bid__c =: bidId];
        list < string > productContractList = new list < string > ();
        for (Phoenix_Bid_Line_Item__c pbl: insertItems) {
            string prodContractName = pbl.Phoenix_Product__c + '-' + pbl.Phoenix_Contract__c;
            productContractList.add(prodContractName);

        }
        // system.debug('updated saveContracts'+ savecontrs);
        query = 'SELECT Phoenix_Product_Director__r.Name,Product_Family__r.Name,Phoenix_Product_Director__r.FirstName,Phoenix_Product_Director__r.LastName,Phoenix_Royalty_Partner_Name__r.Name,Phoenix_PS_Partner_2_Name__r.Name,Phoenix_PS_Partner_1_Name__r.Name ,' + Phoenix_Util.getsObjectFieds('Product2') + ' FROM Product2 WHERE (IsActive = true AND Phoenix_Is_Exclude_Bid__c=false AND Phoenix_Is_IPA_Product__c=TRUE) ORDER BY Name ASC NULLS LAST LIMIT 30000';

        Map < Id, Product2 > proMap = new map < Id, Product2 > ((list < Product2 > ) Database.query(query));




        for (Phoenix_Contract__c cont: savecontrs) {

            for (Phoenix_Bid_Line_Item__c qli: saveitems) {
                if (!productContractList.contains(qli.Phoenix_Product__c + '-' + cont.Id)) {
                    Phoenix_Bid_Line_Item__c pbl = new Phoenix_Bid_Line_Item__c();
                    pbl.Phoenix_Product__c = qli.Phoenix_Product__c;
                    pbl.Phoenix_Proposed_IPA_Price__c = qli.Phoenix_Proposed_IPA_Price__c;
                    pbl.Phoenix_IDN_Usage__c = qli.Phoenix_IDN_Usage__c;
                    pbl.Phoenix_ProposedContractBidPriceMktng__c = qli.Phoenix_Proposed_IPA_Price__c;
                    pbl.Phoenix_Proposed_Direct_Selling_Unit__c = qli.Phoenix_IDN_Usage__c;
                    pbl.Phoenix_Bid__c = bidId;
                    pbl.Phoenix_Contract__c = cont.Id;
                    pbl.Phoenix_Customer__c = cont.Phoenix_Customer__c;
                    pbl.Phoenix_NDC__c = proMap.get(qli.Phoenix_Product__c).Phoenix_NDC_11_Dashes__c;
                    pbl.Phoenix_NDC_Without_Dashes__c = proMap.get(qli.Phoenix_Product__c).Phoenix_NDC_11__c;
                    pbl.Phoenix_IPA_Floor_Price1__c = proMap.get(qli.Phoenix_Product__c).Phoenix_IPA_Floor_Price__c;
                    pbl.Phoenix_Direct_Order_Price1__c = proMap.get(qli.Phoenix_Product__c).Phoenix_Direct_Order_Price__c;
                    pbl.Phoenix_Product_Code1__c = proMap.get(qli.Phoenix_Product__c).ProductCode;
                    pbl.Phoenix_Pkg_Size1__c = proMap.get(qli.Phoenix_Product__c).Phoenix_Pkg_Size__c;
                    pbl.Phoenix_Case_Pack1__c = proMap.get(qli.Phoenix_Product__c).Phoenix_Case_Pack__c;
                    pbl.Phoenix_MOQ1__c = proMap.get(qli.Phoenix_Product__c).Phoenix_Minimum_Order_Quantity__c;
                    pbl.Phoenix_Product_Family1__c = proMap.get(qli.Phoenix_Product__c).Family;
                    pbl.Product_Family__c = proMap.get(qli.Phoenix_Product__c).Product_Family__c; //Added by Naseer
                    pbl.Phoenix_Compare_To_Brand_Name1__c = proMap.get(qli.Phoenix_Product__c).Phoenix_Compare_to_Brand_Name__c;
                    if (proMap.get(qli.Phoenix_Product__c).Phoenix_Product_Director__c != null) {


                        pbl.Phoenix_Product_Director1__c = proMap.get(qli.Phoenix_Product__c).Phoenix_Product_Director__r.FirstName + ' ' + proMap.get(qli.Phoenix_Product__c).Phoenix_Product_Director__r.LastName;
                    }
                    pbl.Phoenix_Orange_Book_Rating1__c = proMap.get(qli.Phoenix_Product__c).Phoenix_Orange_Book_Rating__c;
                    pbl.Phoenix_Throughput_Cost1__c = proMap.get(qli.Phoenix_Product__c).Phoenix_Throughput_cost__c;
                    pbl.Phoenix_WAC1__c = proMap.get(qli.Phoenix_Product__c).Phoenix_WAC__c;
                    pbl.Phoenix_Budgeted_ASP1__c = proMap.get(qli.Phoenix_Product__c).Phoenix_Current_Budgeted_ASP__c;
                    pbl.Phoenix_Lowest_Price_SKU1__c = proMap.get(qli.Phoenix_Product__c).Phoenix_Lowest_Price_SKU__c;
                    pbl.Phoenix_Comm_Exps1__c = proMap.get(qli.Phoenix_Product__c).Phoenix_Comm_Exps__c;
                    if (proMap.get(qli.Phoenix_Product__c).Phoenix_PS_Partner_1_Name__r.Name != null) {
                        pbl.Phoenix_PS_Partner_11__c = proMap.get(qli.Phoenix_Product__c).Phoenix_PS_Partner_1_Name__r.Name;
                    }
                    pbl.Phoenix_PS_Partner_1percent__c = proMap.get(qli.Phoenix_Product__c).Phoenix_PS_Partner_1__c;
                    if (proMap.get(qli.Phoenix_Product__c).Phoenix_PS_Partner_2_Name__r.Name != null) {
                        pbl.Phoenix_PS_Partner_21__c = proMap.get(qli.Phoenix_Product__c).Phoenix_PS_Partner_2_Name__r.Name;
                    }
                    pbl.Phoenix_PS_Partner_2percent__c = proMap.get(qli.Phoenix_Product__c).Phoenix_PS_Partner_2__c;
                    if (proMap.get(qli.Phoenix_Product__c).Phoenix_Royalty_Partner_Name__r.Name != null) {
                        pbl.Phoenix_Royalty_Partner_Name1__c = proMap.get(qli.Phoenix_Product__c).Phoenix_Royalty_Partner_Name__r.Name;
                    }
                    pbl.Phoenix_Royaltypercent__c = proMap.get(qli.Phoenix_Product__c).Phoenix_Royalty__c;
                    pbl.Phoenix_Min_profit_share_Partner_21__c = proMap.get(qli.Phoenix_Product__c).Phoenix_Per_Unit_Profit_Partner_2__c;
                    pbl.Phoenix_Min_profit_share_Partner_11__c = proMap.get(qli.Phoenix_Product__c).Phoenix_Per_Unit_Profit_Partner_1__c;
                    pbl.Phoenix_UPC_Universal_Product_Code__c = proMap.get(qli.Phoenix_Product__c).Phoenix_UPC_Universal_Product_Code__c;
                    pbl.Phoenix_Latest_Estimate__c = proMap.get(qli.Phoenix_Product__c).Phoenix_Latest_Estimate__c;
                    pbl.Phoenix_REMS__c = proMap.get(qli.Phoenix_Product__c).Phoenix_REMS__c;
                    //  system.debug('pbl-----------'+pbl);
                    newItems.add(pbl);
                }
            }
        }

        if (newItems.size() > 0) {
            // system.debug('In saving methods newItems'+newItems);
            insert newItems;
        }
        return newItems;
    }

    @AuraEnabled
    public static List < wrapperClass > fetchSortResults(string sortField, boolean isAsc, List < wrapperClass > productList) {
        set < Id > prodIds = new set < Id > ();
        list < Product2 > sortResults = new list < Product2 > ();
        List < wrapperClass > wrlist = new List < wrapperClass > ();
        for (wrapperClass w: productList) {
            prodIds.add(w.prdlist.Id);

        }
        String sSoql = 'SELECT ' + Phoenix_Util.getsObjectFieds('Product2') + ' FROM Product2 WHERE ID IN:prodIds';
        //sSoql += 'From contact';
        //  system.debug('sortField-->' + sortField);



        if (sortField != null && sortField != '') {
            sSoql += ' order by ' + sortField;
            if (isAsc) {
                sSoql += ' ASC ';
            } else {
                sSoql += ' DESC ';
            }
        }
        sSoql += ' NULLS LAST LIMIT 100 ';
        sortResults = Database.query(sSoql);
        for (Product2 pr: sortResults) {
            for (wrapperClass wr: productList) {
                if (wr.prdlist.Id == pr.Id) {
                    wrlist.add(wr);

                }
            }
        }

        return wrlist;
    }

    @AuraEnabled
    public static List < wrapperClass > fetchContrSortResults(string sortField, boolean isAsc, List < wrapperClass > contractList) {
        set < Id > contractIds = new set < Id > ();
        list < Phoenix_Contract__c > sortResults = new list < Phoenix_Contract__c > ();
        List < wrapperClass > wrlist = new List < wrapperClass > ();
        for (wrapperClass w: contractList) {
            contractIds.add(w.contrt.Id);

        }
        string Active = 'Active';
        String sSoql = 'SELECT ' + Phoenix_Util.getsObjectFieds('Phoenix_Contract__c') + ' FROM Phoenix_Contract__c WHERE ID IN:contractIds AND  Phoenix_Contract_Status__c=:Active AND Phoenix_Is_IPA_Contract__c=TRUE';
        //sSoql += 'From contact';
        //system.debug('sortField-->' + sortField);



        if (sortField != null && sortField != '') {
            sSoql += ' order by ' + sortField;
            if (isAsc) {
                sSoql += ' ASC ';
            } else {
                sSoql += ' DESC ';
            }
        }
        sSoql += ' NULLS LAST LIMIT 50000 ';
        sortResults = Database.query(sSoql);
        for (Phoenix_Contract__c pr: sortResults) {
            for (wrapperClass wr: contractList) {
                if (wr.contrt.Id == pr.Id) {
                    wrlist.add(wr);

                }
            }
        }

        return wrlist;
    }
    @AuraEnabled
    public static List < wrapperClass > getContractData(list < string > prodIds, BidWrapper quotewrap) {
        List < wrapperClass > wrlist = new List < wrapperClass > ();
        set < Id > IPAcontracts = new set < Id > ();
        list < Phoenix_Bid_Line_Item__c > pblList = new list < Phoenix_Bid_Line_Item__c > ();
        string bidtype = quotewrap.bid.Phoenix_Bid_Type__c;
        list < Phoenix_NPR_Data__c > nprList = new list < Phoenix_NPR_Data__c > ();
        list < Phoenix_Contract__c > contrList = new list < Phoenix_Contract__c > ();

        nprList = [select Id, Phoenix_Contract__c, Phoenix_Product__c from Phoenix_NPR_Data__c where Phoenix_Product__c IN: prodIds and Phoenix_Contract__r.Phoenix_Contract_Status__c = 'Active'];
        for (Phoenix_NPR_Data__c npr: nprList) {
            IPAcontracts.add(npr.Phoenix_Contract__c);
        }



        if (IPAcontracts.size() > 0 && bidtype == 'SRx IPA Price Change') {

            contrList = [select Id, Name, Phoenix_Contract_External_Description__c, Phoenix_Contract_Internal_Description__c, OwnerId, Owner.Name, Phoenix_Customer__c, Phoenix_Customer__r.Name, Phoenix_Customer_Number__c, Phoenix_Contract_Number__c from Phoenix_Contract__c where ID IN: IPAcontracts AND Phoenix_Is_IPA_Contract__c = TRUE AND Phoenix_Contract_Status__c = 'Active'
                limit 30000
            ];

        }

        if (bidtype == 'SRx IPA Product Addition') {


            if (IPAcontracts.size() > 0) {

                contrList = [select Id, Name, Phoenix_Contract_External_Description__c, Phoenix_Contract_Internal_Description__c, OwnerId, Owner.Name, Phoenix_Customer__c, Phoenix_Customer__r.Name, Phoenix_Customer_Number__c, Phoenix_Contract_Number__c from Phoenix_Contract__c where ID NOT IN: IPAcontracts AND Phoenix_Is_IPA_Contract__c = TRUE AND Phoenix_Contract_Status__c = 'Active'
                    limit 30000
                ];


            } else {
                contrList = [select Id, Name, Phoenix_Contract_External_Description__c, Phoenix_Contract_Internal_Description__c, OwnerId, Owner.Name, Phoenix_Customer__c, Phoenix_Customer__r.Name, Phoenix_Customer_Number__c, Phoenix_Contract_Number__c from Phoenix_Contract__c where Phoenix_Is_IPA_Contract__c = TRUE AND Phoenix_Contract_Status__c = 'Active'
                    limit 30000
                ];

            }
        }




        if (contrList.size() > 0) {
            for (Phoenix_Contract__c cont: contrList) {
                wrapperClass wr = new wrapperClass();
                wr.contrFlag = false;
                wr.contrt = cont;
                wrlist.add(wr);
            }
        }





        if (wrlist.size() > 0) {
            return wrlist;

        } else {
            return null;
        }




    }

    public class BidWrapper {
        @AuraEnabled
        public Phoenix_Bid__c bid {
            get;
            set;
        }

        @AuraEnabled
        public Boolean isBidCreated {
            get;
            set;
        }
        @AuraEnabled
        public Integer recordCount {
            get;
            set;
        }

        public BidWrapper() {
            bid = new Phoenix_Bid__c();
        }
    }

    public class wrapperClass {
        @AuraEnabled
        public Product2 prdlist {
            get;
            set;
        }

        @AuraEnabled
        public Phoenix_Bid_Line_Item__c qlItem {
            get;
            set;
        }

        @AuraEnabled
        public Phoenix_Contract__c contrt {
            get;
            set;
        }

        @AuraEnabled
        public String prodName {
            get;
            set;
        }

        @AuraEnabled
        public String custName {
            get;
            set;
        }

        @AuraEnabled
        public String family {
            get;
            set;
        }
        @AuraEnabled
        public String familyId {
            get;
            set;
        }

        @AuraEnabled
        public Decimal IPAPrice {
            get;
            set;
        }

        @AuraEnabled
        public String NDC {
            get;
            set;
        }

        @AuraEnabled
        public String currencyCode {
            get;
            set;
        }

        @AuraEnabled
        public String currencyCode1 {
            get;
            set;
        }

        @AuraEnabled
        public Boolean isSelected {
            get;
            set;
        }

        @AuraEnabled
        public Boolean contrFlag {
            get;
            set;
        }
    }

}