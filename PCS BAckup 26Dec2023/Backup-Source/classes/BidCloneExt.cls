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
public class BidCloneExt {

    public static Phoenix_Bid__c bid;
    public static BidWrapper wrapper;

    static {
        bid = new Phoenix_Bid__c();
        wrapper = new BidWrapper();
    }

    @AuraEnabled
    public static Map < String, String > getDeadLineTimeZone() {
        Map < String, String > options = new Map < String, String > ();
        Schema.DescribeFieldResult fieldResult = Phoenix_Bid__c.Phoenix_Customer_Bid_Deadline_Time_zone__c.getDescribe();
        List < Schema.PicklistEntry > pList = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry p: pList) {
            options.put(p.getValue(), p.getLabel());
        }
        return options;
    }

   @AuraEnabled
    public static Map < String, String > getDeadLineTime() {
        Map < String, String > options = new Map < String, String > ();
        Schema.DescribeFieldResult fieldResult = Phoenix_Bid__c.Phoenix_Customer_Bid_Deadline_Time__c.getDescribe();
        List < Schema.PicklistEntry > pList = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry p: pList) {
            options.put(p.getValue(), p.getLabel());
        }
        return options;
    } 

    @AuraEnabled
    public static BidWrapper getbidInfo(String recordId) {
        BidWrapper wrapperCls = new BidWrapper();

        if (recordId != null)
            wrapperCls.bid = Database.query('SELECT Name,Id,Phoenix_Customer__c,Phoenix_Bid_Type__c,Phoenix_Customer_Type__c,Phoenix_Approval_Status__c, Phoenix_Reference_Contracts__c FROM Phoenix_Bid__c WHERE Id =: recordId LIMIT 1');
        return wrapperCls;
    }

    @AuraEnabled
    public static List < string > getProductDirectorList(BidWrapper bidwrap) {
        Phoenix_Bid__c bid = bidwrap.bid;
        String query = '';
        String SobjectApiName = 'Product2';
        Map < String, Schema.SObjectType > schemaMap = Schema.getGlobalDescribe();
        Map < String, Schema.SObjectField > fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();

        String strFields = '';

        for (String fieldName: fieldMap.keyset()) {
            if (strFields == null || strFields == '') {
                strFields = fieldName;
            } else {
                strFields = strFields + ' , ' + fieldName;
            }
        }
        if (bid.Phoenix_Bid_Type__c == 'IPA Floor Pricing Update') {
            query = 'select Phoenix_Product_Director__r.Name,' + strFields + ' from Product2 where (IsActive = true AND Phoenix_Is_Exclude_Bid__c=false AND Phoenix_Is_IPA_Product__c=true) ORDER BY Name ASC NULLS LAST LIMIT 30000 ';
        } else {
            query = 'select Phoenix_Product_Director__r.Name,' + strFields + ' from Product2 where (IsActive = true AND Phoenix_Is_Exclude_Bid__c=false) ORDER BY Name ASC NULLS LAST LIMIT 30000';

        }
        list < Product2 > quoteList = Database.query(query);
        //system.debug('quoteList--->' + quoteList);


        List < String > productDirectorList = new List < String > ();

        for (Product2 lineItem: quoteList) {


            if (lineItem.Phoenix_Product_Director__r.Name != null && !productDirectorList.contains(lineItem.Phoenix_Product_Director__r.Name)) {
                productDirectorList.add(lineItem.Phoenix_Product_Director__r.Name);
            }

        }
        return productDirectorList;


    }

    @AuraEnabled
    public static List < wrapperClass > getproducts1(BidWrapper quotewrap) {

        Phoenix_Bid__c bid = quotewrap.bid;
        string bidId = bid.Id;
        List < wrapperClass > wrlist = new List < wrapperClass > ();
        String query = '';
        String SobjectApiName = 'Phoenix_Bid_Line_Item__c';
        Map < String, Schema.SObjectType > schemaMap = Schema.getGlobalDescribe();
        Map < String, Schema.SObjectField > fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();
        String strFields = '';

        for (String fieldName: fieldMap.keyset()) {
            if (strFields == null || strFields == '') {
                strFields = fieldName;
            } else {
                strFields = strFields + ' , ' + fieldName;
            }
        }

        string notApproved = 'Not Approved';
        query = 'select Product_Family__r.Name, Phoenix_Product__r.Name,Phoenix_Product__r.Phoenix_NDC_11__c,Phoenix_Product__r.Phoenix_IMS_Market_Share__c,Phoenix_Product__r.Phoenix_REMS__c,Phoenix_Product__r.Phoenix_Latest_Estimate__c,Phoenix_Product__r.Phoenix_IPA_Floor_Price__c,Phoenix_Product__r.Phoenix_UPC_Universal_Product_Code__c,Phoenix_Product__r.Phoenix_Per_Unit_Profit_Partner_1__c,Phoenix_Product__r.Phoenix_Per_Unit_Profit_Partner_2__c,Phoenix_Product__r.Phoenix_Royalty__c,Phoenix_Product__r.Phoenix_Royalty_Partner_Name__r.Name,Phoenix_Product__r.Phoenix_PS_Partner_2__c,Phoenix_Product__r.Phoenix_PS_Partner_2_Name__r.Name,Phoenix_Product__r.Phoenix_PS_Partner_1__c,Phoenix_Product__r.Phoenix_PS_Partner_1_Name__r.Name,Phoenix_Product__r.Phoenix_Comm_Exps__c,Phoenix_Product__r.Phoenix_Approved_Lowest_Price_SKU__c,Phoenix_Product__r.Phoenix_Lowest_Price_SKU__c,Phoenix_Product__r.Phoenix_Current_Budgeted_ASP__c,Phoenix_Product__r.Phoenix_WAC__c,Phoenix_Product__r.Phoenix_Throughput_cost__c,Phoenix_Product__r.Phoenix_Orange_Book_Rating__c,Phoenix_Product__r.Phoenix_Product_Director__r.LastName,Phoenix_Product__r.Phoenix_Product_Director__r.FirstName,Phoenix_Product__r.Phoenix_Product_Director__c,Phoenix_Product__r.Phoenix_Compare_to_Brand_Name__c,Phoenix_Product__r.Phoenix_NDC_11_Dashes__c,Phoenix_Product__r.ProductCode,Phoenix_Product__r.Phoenix_Pkg_Size__c,Phoenix_Product__r.Phoenix_Case_Pack__c,Phoenix_Product__r.Phoenix_Minimum_Order_Quantity__c,Phoenix_Product__r.Family,Phoenix_Product__r.Phoenix_Direct_Order_Price__c,' + strFields + ' from Phoenix_Bid_Line_Item__c where Phoenix_Bid__c = :bidId order by Phoenix_Product__r.Name ASC NULLS LAST LIMIT 30000';


        List < Phoenix_Bid_Line_Item__c > prlist = Database.query(query);




        if (prlist.size() > 0) {
            for (Phoenix_Bid_Line_Item__c pr: prlist) {
                wrapperClass wr = new wrapperClass();
                wr.qlItem = pr;
                wr.isSelected = false;
                wrlist.add(wr);
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
            productList = [select Name, Family, ProductCode, Product_Family__c, Product_Family__r.Name,  Phoenix_NDC_11__c from Product2 where Id IN: prodIds ORDER BY Name ASC NULLS LAST LIMIT 30000];

            for (Product2 pr: productList) {
                wrapperClass wr = new wrapperClass();
                wr.prdlist = pr;
                wrapList.add(wr);
            }
        }

        return wrapList;

    }

    @AuraEnabled
    public static List < wrapperClass > getsearchDirectorResult(List < wrapperClass > pItem, list < string > SearchKeyWordPD, string Family, string searchName, list < string > RxSrxList, BidWrapper quotewrap) {
        List < wrapperClass > wralist = new List < wrapperClass > ();
        try {

            list < string > searchupdateList = new list < string > ();
            String query1;
            String searchText;
            string searchfamily;
            list < string > productDirectors = new list < string > ();
            list < string > NewproductDirectors;
            string searchPD;
            set < Id > productIds = new set < Id > ();
            for (wrapperClass w: pItem) {
                productIds.add(w.qlItem.Phoenix_Product__c);

            }


            List < String > searchList;
            list < Product2 > prodNameList = new list < Product2 > ();
            if (string.isNotBlank(Family)) {
                searchfamily = Family.trim();

            }



            searchfamily = '%' + searchfamily + '%';


            // //system.debug('searchText---'+searchText);


            if (string.isNotBlank(searchName)) {
                searchText = searchName.trim();
                searchText = searchText.replace('\\s+', ' ');


                if (quotewrap.bid.Phoenix_Bid_Type__c == 'IPA Floor Pricing Update') {
                    prodNameList = [select Id, Name from Product2 where IsActive = true AND Phoenix_Is_Exclude_Bid__c = false AND Phoenix_Is_IPA_Product__c = true AND Name =: searchText];
                } else {
                    prodNameList = [select Id, Name from Product2 where IsActive = true AND Phoenix_Is_Exclude_Bid__c = false AND Name =: searchText];
                }
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

            //system.debug('searchupdateList----' + searchupdateList);

            //system.debug('productIds---in else-');
            query1 = 'SELECT Id,Product_Family__r.Name,Phoenix_Product_Director__r.Name,Phoenix_Date_of_Discontinuation__c ,Phoenix_Product_Type_for_CM_Fee__c,Phoenix_Rx_SRx_OTC__c,Name,ProductCode,Phoenix_NDC_11__c,Phoenix_GCN_Generic_Code_Number__c,Phoenix_GCN_Sequence_Number__c,Phoenix_NDC_11_Dashes__c,Phoenix_GPI_Generic_Product_Identifier__c,Phoenix_GPI_Dashes__c,Family,Phoenix_Strength__c,Phoenix_Pkg_Size__c,Phoenix_WAC__c,Phoenix_Product_Director__c,Phoenix_Compare_to_Brand_Name__c FROM Product2 WHERE (IsActive = true AND Phoenix_Is_Exclude_Bid__c=false AND Phoenix_Product_Director__r.Name like :SearchKeyWordPD  AND ID in:productIds) ORDER BY Name ASC NULLS LAST LIMIT 30000';

            list < Product2 > productList = Database.query(query1);
            if (RxSrxList != null && !RxSrxList.isEmpty() && productList.size() > 0) {
                string query2;
                query2 = 'SELECT Id,Product_Family__r.Name,Phoenix_Product_Director__r.Name,Phoenix_Date_of_Discontinuation__c ,Phoenix_Product_Type_for_CM_Fee__c,Phoenix_Rx_SRx_OTC__c,Name,ProductCode,Phoenix_NDC_11__c,Phoenix_GCN_Generic_Code_Number__c,Phoenix_GCN_Sequence_Number__c,Phoenix_NDC_11_Dashes__c,Phoenix_GPI_Generic_Product_Identifier__c,Phoenix_GPI_Dashes__c,Family,Phoenix_Strength__c,Phoenix_Pkg_Size__c,Phoenix_WAC__c,Phoenix_Product_Director__c,Phoenix_Compare_to_Brand_Name__c FROM Product2 WHERE ( Phoenix_Rx_SRx_OTC__c like :RxSrxList AND ID IN:productList ) ORDER BY Name ASC NULLS LAST LIMIT 30000';
                productList = Database.query(query2);
            }
            if (productList.size() > 0 && string.isNotBlank(searchName)) {
                string query3;
                query3 = 'SELECT Id,Product_Family__r.Name,Phoenix_Product_Director__r.Name,Phoenix_Date_of_Discontinuation__c ,Phoenix_Product_Type_for_CM_Fee__c,Phoenix_Rx_SRx_OTC__c,Name,ProductCode,Phoenix_NDC_11__c,Phoenix_GCN_Generic_Code_Number__c,Phoenix_GCN_Sequence_Number__c,Phoenix_NDC_11_Dashes__c,Phoenix_GPI_Generic_Product_Identifier__c,Phoenix_GPI_Dashes__c,Family,Phoenix_Strength__c,Phoenix_Pkg_Size__c,Phoenix_WAC__c,Phoenix_Product_Director__c,Phoenix_Compare_to_Brand_Name__c FROM Product2 WHERE (ID IN:productList AND (Name like :searchupdateList OR Phoenix_Compare_to_Brand_Name__c like :searchupdateList OR Phoenix_UPC_Universal_Product_Code__c like :searchupdateList OR Phoenix_NDC_11__c like :searchupdateList OR ProductCode like :searchupdateList OR Phoenix_NDC_11_Dashes__c like :searchupdateList OR Phoenix_GPI_Generic_Product_Identifier__c like :searchupdateList OR Phoenix_GPI_Dashes__c like :searchupdateList OR Phoenix_GCN_Generic_Code_Number__c like :searchupdateList OR Phoenix_GCN_Sequence_Number__c like :searchupdateList) ) ORDER BY Name ASC NULLS LAST LIMIT 30000';
                productList = Database.query(query3);
            }
            if (productList.size() > 0 && string.isNotBlank(Family)) {
                string query4;
                query4 = 'SELECT Id,Product_Family__r.Name,Phoenix_Product_Director__r.Name,Phoenix_Date_of_Discontinuation__c ,Phoenix_Product_Type_for_CM_Fee__c,Phoenix_Rx_SRx_OTC__c,Name,ProductCode,Phoenix_NDC_11__c,Phoenix_GCN_Generic_Code_Number__c,Phoenix_GCN_Sequence_Number__c,Phoenix_NDC_11_Dashes__c,Phoenix_GPI_Generic_Product_Identifier__c,Phoenix_GPI_Dashes__c,Family,Phoenix_Strength__c,Phoenix_Pkg_Size__c,Phoenix_WAC__c,Phoenix_Product_Director__c,Phoenix_Compare_to_Brand_Name__c FROM Product2 WHERE (ID IN:productList AND IsActive = true AND Phoenix_Is_Exclude_Bid__c=false AND Product_Family__r.Name like :searchfamily) ORDER BY Name ASC NULLS LAST LIMIT 30000';
                productList = Database.query(query4);
            }

            //system.debug('productList----' + productList);
            Map < Id, Product2 > productMap = new map < Id, Product2 > (productList);
            for (wrapperClass w: pItem) {
                if (productMap.containskey(w.qlItem.Phoenix_Product__c)) wralist.add(w);

            }
            //system.debug('wralist----' + wralist);

        }
        Catch(Exception e) {
            Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'BidCloneExt', Phoenix_Method_Name__c = 'getsearchDirectorResult', Phoenix_Error_Message__c = e.getMessage(), Phoenix_Issue_Status__c = 'Pending', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
            insert exp;
        }
        return wralist;
    }

      @AuraEnabled
  public static List < wrapperClass > getSearch(List < wrapperClass > pItem, list < string > SearchKeyWordPD, string search, string family, list < string > RxSrxList, BidWrapper quotewrap) {

        List < wrapperClass > wralist1 = new List < wrapperClass > ();
        String searchText = search.trim();
        string searchfamily;
        set < Id > productIds = new set < Id > ();
        for (wrapperClass w: pItem) {
            productIds.add(w.qlItem.Phoenix_Product__c);

        }
        if (string.isNotBlank(family)) {
            searchfamily = family.trim();

        }
        searchfamily = '%' + searchfamily + '%';

        //searchText=searchText.replace('-','');
        //system.debug('searchText---' + searchText);
        searchText = searchText.replace('\\s+', ' ');
        //system.debug('searchText---' + searchText);
        set < Id > RxProdIds = new set < Id > ();
        list < string > searchupdateList = new list < string > ();
        String query1;
        list < Product2 > prodNameList = new list < Product2 > ();
        if (quotewrap.bid.Phoenix_Bid_Type__c == 'IPA Floor Pricing Update') {
            prodNameList = [select Id, Name from Product2 where IsActive = true AND Phoenix_Is_Exclude_Bid__c = false AND Phoenix_Is_IPA_Product__c = true AND Name =: searchText];
        } else {
            prodNameList = [select Id, Name from Product2 where IsActive = true AND Phoenix_Is_Exclude_Bid__c = false AND Name =: searchText];
        }
        if (prodNameList.size() == 0) {
            List < String > searchList = searchText.split(' ');
            for (string str: searchList) {
                string searchItem = '%' + str + '%';
                searchupdateList.add(searchItem);

            }
        } else {
            searchupdateList.add('%' + searchText + '%');
        }
        //system.debug('searchupdateList----' + searchupdateList);


        query1 = 'SELECT Id,Product_Family__r.Name,Phoenix_Product_Director__r.Name,Phoenix_Date_of_Discontinuation__c ,Phoenix_Product_Type_for_CM_Fee__c,Phoenix_Rx_SRx_OTC__c,Name,ProductCode,Phoenix_NDC_11__c,Phoenix_GCN_Generic_Code_Number__c,Phoenix_GCN_Sequence_Number__c,Phoenix_NDC_11_Dashes__c,Phoenix_GPI_Generic_Product_Identifier__c,Phoenix_GPI_Dashes__c,Family,Phoenix_Strength__c,Phoenix_Pkg_Size__c,Phoenix_WAC__c,Phoenix_Product_Director__c,Phoenix_Compare_to_Brand_Name__c FROM Product2 WHERE ((IsActive = true AND Phoenix_Is_Exclude_Bid__c=false ) AND(Name like :searchupdateList OR Phoenix_Compare_to_Brand_Name__c like :searchupdateList OR Phoenix_UPC_Universal_Product_Code__c like :searchupdateList OR Phoenix_NDC_11__c like :searchupdateList OR ProductCode like :searchupdateList OR Phoenix_NDC_11_Dashes__c like :searchupdateList OR Phoenix_GPI_Generic_Product_Identifier__c like :searchupdateList OR Phoenix_GPI_Dashes__c like :searchupdateList OR Phoenix_GCN_Generic_Code_Number__c like :searchupdateList OR Phoenix_GCN_Sequence_Number__c like :searchupdateList OR Product_Family__r.Name like :searchupdateList )  AND ID in:productIds ) ORDER BY Name ASC NULLS LAST LIMIT 30000';

        list < Product2 > productList = Database.query(query1);
        if (RxSrxList != null && !RxSrxList.isEmpty() && productList.size() > 0) {
            string query2;
            query2 = 'SELECT Id,Product_Family__r.Name,Phoenix_Product_Director__r.Name,Phoenix_Date_of_Discontinuation__c ,Phoenix_Product_Type_for_CM_Fee__c,Phoenix_Rx_SRx_OTC__c,Name,ProductCode,Phoenix_NDC_11__c,Phoenix_GCN_Generic_Code_Number__c,Phoenix_GCN_Sequence_Number__c,Phoenix_NDC_11_Dashes__c,Phoenix_GPI_Generic_Product_Identifier__c,Phoenix_GPI_Dashes__c,Family,Phoenix_Strength__c,Phoenix_Pkg_Size__c,Phoenix_WAC__c,Phoenix_Product_Director__c,Phoenix_Compare_to_Brand_Name__c FROM Product2 WHERE ( Phoenix_Rx_SRx_OTC__c like :RxSrxList AND ID IN:productList ) ORDER BY Name ASC NULLS LAST LIMIT 30000';
            productList = Database.query(query2);
        }
        if (productList.size() > 0 && string.isNotBlank(family)) {
            string query3;
            query3 = 'SELECT Id,Product_Family__r.Name,Phoenix_Product_Director__r.Name,Phoenix_Date_of_Discontinuation__c ,Phoenix_Product_Type_for_CM_Fee__c,Phoenix_Rx_SRx_OTC__c,Name,ProductCode,Phoenix_NDC_11__c,Phoenix_GCN_Generic_Code_Number__c,Phoenix_GCN_Sequence_Number__c,Phoenix_NDC_11_Dashes__c,Phoenix_GPI_Generic_Product_Identifier__c,Phoenix_GPI_Dashes__c,Family,Phoenix_Strength__c,Phoenix_Pkg_Size__c,Phoenix_WAC__c,Phoenix_Product_Director__c,Phoenix_Compare_to_Brand_Name__c FROM Product2 WHERE (ID IN:productList AND Product_Family__r.Name like :searchfamily ) ORDER BY Name ASC NULLS LAST LIMIT 30000';
            productList = Database.query(query3);
        }
        if (productList.size() > 0 && SearchKeyWordPD != null && !SearchKeyWordPD.isEmpty()) {
            string query4;
            query4 = 'SELECT Id,Product_Family__r.Name,Phoenix_Product_Director__r.Name,Phoenix_Date_of_Discontinuation__c ,Phoenix_Product_Type_for_CM_Fee__c,Phoenix_Rx_SRx_OTC__c,Name,ProductCode,Phoenix_NDC_11__c,Phoenix_GCN_Generic_Code_Number__c,Phoenix_GCN_Sequence_Number__c,Phoenix_NDC_11_Dashes__c,Phoenix_GPI_Generic_Product_Identifier__c,Phoenix_GPI_Dashes__c,Family,Phoenix_Strength__c,Phoenix_Pkg_Size__c,Phoenix_WAC__c,Phoenix_Product_Director__c,Phoenix_Compare_to_Brand_Name__c FROM Product2 WHERE (ID IN:productList AND Phoenix_Product_Director__r.Name like :SearchKeyWordPD) ORDER BY Name ASC NULLS LAST LIMIT 30000';
            productList = Database.query(query4);
        }

        Map < Id, Product2 > productMap = new map < Id, Product2 > (productList);
        for (wrapperClass w: pItem) {
            if (productMap.containskey(w.qlItem.Phoenix_Product__c)) wralist1.add(w);

        }

        return wralist1;
    }

    @AuraEnabled
    public static List < wrapperClass > getSearchFamily(List < wrapperClass > pItem, list < string > SearchKeyWordPD, string search, string searchName, list < string > RxSrxList, BidWrapper quotewrap) {

        List < wrapperClass > wralist = new List < wrapperClass > ();
        list < string > searchupdateList = new list < string > ();

        set < Id > productIds = new set < Id > ();
        for (wrapperClass w: pItem) {
            productIds.add(w.qlItem.Phoenix_Product__c);

        }
        String query1;
        String searchText;
        string searchfamily;
        List < String > searchList;
        list < Product2 > prodNameList = new list < Product2 > ();
        if (string.isNotBlank(search)) {
            searchfamily = search.trim();
        }


        searchfamily = '%' + searchfamily + '%';


        //system.debug('searchfamily---' + searchfamily);


        if (string.isNotBlank(searchName)) {
            searchText = searchName.trim();
            searchText = searchText.replace('\\s+', ' ');


            if (quotewrap.bid.Phoenix_Bid_Type__c == 'IPA Floor Pricing Update') {
                prodNameList = [select Id, Name from Product2 where IsActive = true AND Phoenix_Is_Exclude_Bid__c = false AND Phoenix_Is_IPA_Product__c = true AND Name =: searchText];
            } else {
                prodNameList = [select Id, Name from Product2 where IsActive = true AND Phoenix_Is_Exclude_Bid__c = false AND Name =: searchText];
            }
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

        //system.debug('searchupdateList----' + searchupdateList);

        list < Product2 > productList = new list < Product2 > ();
        //system.debug('productIds---in else-');
        if (string.isNotBlank(search)) {
            query1 = 'SELECT Id,Product_Family__r.Name,Phoenix_Product_Director__r.Name,Phoenix_Date_of_Discontinuation__c ,Phoenix_Product_Type_for_CM_Fee__c,Phoenix_Rx_SRx_OTC__c,Name,ProductCode,Phoenix_NDC_11__c,Phoenix_GCN_Generic_Code_Number__c,Phoenix_GCN_Sequence_Number__c,Phoenix_NDC_11_Dashes__c,Phoenix_GPI_Generic_Product_Identifier__c,Phoenix_GPI_Dashes__c,Family,Phoenix_Strength__c,Phoenix_Pkg_Size__c,Phoenix_WAC__c,Phoenix_Product_Director__c,Phoenix_Compare_to_Brand_Name__c FROM Product2 WHERE (IsActive = true AND Phoenix_Is_Exclude_Bid__c=false AND Product_Family__r.Name like :searchfamily  AND ID in:productIds) ORDER BY Name ASC NULLS LAST LIMIT 30000';

            productList = Database.query(query1);
        }

        if (RxSrxList != null && !RxSrxList.isEmpty()) {
            if (productList.size() > 0) {
                string query2;
                query2 = 'SELECT Id,Product_Family__r.Name,Phoenix_Product_Director__r.Name,Phoenix_Date_of_Discontinuation__c ,Phoenix_Product_Type_for_CM_Fee__c,Phoenix_Rx_SRx_OTC__c,Name,ProductCode,Phoenix_NDC_11__c,Phoenix_GCN_Generic_Code_Number__c,Phoenix_GCN_Sequence_Number__c,Phoenix_NDC_11_Dashes__c,Phoenix_GPI_Generic_Product_Identifier__c,Phoenix_GPI_Dashes__c,Family,Phoenix_Strength__c,Phoenix_Pkg_Size__c,Phoenix_WAC__c,Phoenix_Product_Director__c,Phoenix_Compare_to_Brand_Name__c FROM Product2 WHERE ( Phoenix_Rx_SRx_OTC__c like :RxSrxList AND ID IN:productList) ORDER BY Name ASC NULLS LAST LIMIT 30000';
                productList = Database.query(query2);
            }

        }
        if (string.isNotBlank(searchName)) {
            if (productList.size() > 0) {
                string query3;
                query3 = 'SELECT Id,Product_Family__r.Name,Phoenix_Product_Director__r.Name,Phoenix_Date_of_Discontinuation__c ,Phoenix_Product_Type_for_CM_Fee__c,Phoenix_Rx_SRx_OTC__c,Name,ProductCode,Phoenix_NDC_11__c,Phoenix_GCN_Generic_Code_Number__c,Phoenix_GCN_Sequence_Number__c,Phoenix_NDC_11_Dashes__c,Phoenix_GPI_Generic_Product_Identifier__c,Phoenix_GPI_Dashes__c,Family,Phoenix_Strength__c,Phoenix_Pkg_Size__c,Phoenix_WAC__c,Phoenix_Product_Director__c,Phoenix_Compare_to_Brand_Name__c FROM Product2 WHERE (ID IN:productList AND (Name like :searchupdateList OR Phoenix_Compare_to_Brand_Name__c like :searchupdateList OR Phoenix_UPC_Universal_Product_Code__c like :searchupdateList OR Phoenix_NDC_11__c like :searchupdateList OR ProductCode like :searchupdateList OR Phoenix_NDC_11_Dashes__c like :searchupdateList OR Phoenix_GPI_Generic_Product_Identifier__c like :searchupdateList OR Phoenix_GPI_Dashes__c like :searchupdateList OR Phoenix_GCN_Generic_Code_Number__c like :searchupdateList OR Phoenix_GCN_Sequence_Number__c like :searchupdateList ) ) ORDER BY Name ASC NULLS LAST LIMIT 30000';
                productList = Database.query(query3);
            }

        }
        if (SearchKeyWordPD != null && !SearchKeyWordPD.isEmpty()) {
            if (productList.size() > 0) {
                string query4;
                query4 = 'SELECT Id,Product_Family__r.Name,Phoenix_Product_Director__r.Name,Phoenix_Date_of_Discontinuation__c ,Phoenix_Product_Type_for_CM_Fee__c,Phoenix_Rx_SRx_OTC__c,Name,ProductCode,Phoenix_NDC_11__c,Phoenix_GCN_Generic_Code_Number__c,Phoenix_GCN_Sequence_Number__c,Phoenix_NDC_11_Dashes__c,Phoenix_GPI_Generic_Product_Identifier__c,Phoenix_GPI_Dashes__c,Family,Phoenix_Strength__c,Phoenix_Pkg_Size__c,Phoenix_WAC__c,Phoenix_Product_Director__c,Phoenix_Compare_to_Brand_Name__c FROM Product2 WHERE (ID IN:productList AND Phoenix_Product_Director__r.Name like :SearchKeyWordPD ) ORDER BY Name ASC NULLS LAST LIMIT 30000';
                productList = Database.query(query4);
            }

        }

        //system.debug('productList----' + productList);
        Map < Id, Product2 > productMap = new map < Id, Product2 > (productList);
        for (wrapperClass w: pItem) {
            if (productMap.containskey(w.qlItem.Phoenix_Product__c)) wralist.add(w);

        }
        //system.debug('wralist----' + wralist);


        return wralist;
    }


    /*@AuraEnabled
public static list<Phoenix_Bid_Line_Item__c> savequoteitems(list<wrapperClass> saveitems, BidWrapper bidWrapper, List<string> selectrcs){

list<Phoenix_Bid_Line_Item__c> newItems = new list<Phoenix_Bid_Line_Item__c>();
list<Product2>prodList;
list<Phoenix_Bid_Fee_Master__c>feeList=new list<Phoenix_Bid_Fee_Master__c>();        

string bidId=bidWrapper.bid.Id;
//system.debug('bidId--------'+bidId);
Id accountId=bidWrapper.bid.Phoenix_Customer__c;
//system.debug('bidWrapper.bid--------'+bidWrapper.bid.Phoenix_Bid_Type__c);
//system.debug('accountId--------'+accountId);
Account acc;
if(accountId!=null){
acc=[select Id,Phoenix_Is_Govt_Customer__c,Phoenix_Fee__c,Fee_Type__c,Phoenix_Indirect_Cash_Discount__c,Rebate_Type__c,Phoenix_Rebates__c,Phoenix_Preferred_Wholesaler__c,Phoenix_Local_VIP__c,Phoenix_CM_Fees__c,Phoenix_RDC_NLC__c from Account where Id=:accountId];



feeList=[select Id,Phoenix_Customer_Type__c,Phoenix_Fee__c,Phoenix_Preferred_Wholesaler__c,Phoenix_Fee_Type__c,Phoenix_Product_Type_for_CM_Fee__c from Phoenix_Bid_Fee_Master__c where Phoenix_Preferred_Wholesaler__c=:acc.Phoenix_Preferred_Wholesaler__c limit 30000];     


}

for (wrapperClass wr : saveitems){
Phoenix_Bid_Line_Item__c pbl=new Phoenix_Bid_Line_Item__c();

pbl.Phoenix_Bid__c = bidId;
pbl.Phoenix_Product__c=wr.prdlist.Id;
pbl.Phoenix_NDC__c=wr.prdlist.Phoenix_NDC_11_Dashes__c;
pbl.Phoenix_NDC_Without_Dashes__c=wr.prdlist.Phoenix_NDC_11__c;
pbl.Phoenix_Product_Code1__c= wr.prdlist.ProductCode;
pbl.Phoenix_Pkg_Size1__c=wr.prdlist.Phoenix_Pkg_Size__c;
pbl.Phoenix_Case_Pack1__c= wr.prdlist.Phoenix_Case_Pack__c;
pbl.Phoenix_MOQ1__c=wr.prdlist.Phoenix_Minimum_Order_Quantity__c;
pbl.Phoenix_Product_Family1__c= wr.prdlist.Family;
pbl.Phoenix_Direct_Order_Price1__c=wr.prdlist.Phoenix_Direct_Order_Price__c;
pbl.Phoenix_Compare_To_Brand_Name1__c = wr.prdlist.Phoenix_Compare_to_Brand_Name__c;
if(wr.prdlist.Phoenix_Product_Director__c!=null){
pbl.Phoenix_Product_Director1__c=wr.prdlist.Phoenix_Product_Director__r.FirstName+' '+wr.prdlist.Phoenix_Product_Director__r.LastName;
}
pbl.Phoenix_Orange_Book_Rating1__c=wr.prdlist.Phoenix_Orange_Book_Rating__c;
pbl.Phoenix_Throughput_Cost1__c= wr.prdlist.Phoenix_Throughput_cost__c;
pbl.Phoenix_WAC1__c=wr.prdlist.Phoenix_WAC__c;
pbl.Phoenix_Budgeted_ASP1__c= wr.prdlist.Phoenix_Current_Budgeted_ASP__c;
pbl.Phoenix_Lowest_Price_SKU1__c=wr.prdlist.Phoenix_Lowest_Price_SKU__c;
pbl.Phoenix_Comm_Exps1__c= wr.prdlist.Phoenix_Comm_Exps__c;
if(wr.prdlist.Phoenix_PS_Partner_1_Name__r.Name!=null){
pbl.Phoenix_PS_Partner_11__c= wr.prdlist.Phoenix_PS_Partner_1_Name__r.Name;
}
pbl.Phoenix_PS_Partner_1percent__c= wr.prdlist.Phoenix_PS_Partner_1__c;
if(wr.prdlist.Phoenix_PS_Partner_2_Name__r.Name!=null){
pbl.Phoenix_PS_Partner_21__c= wr.prdlist.Phoenix_PS_Partner_2_Name__r.Name;
}
pbl.Phoenix_PS_Partner_2percent__c= wr.prdlist.Phoenix_PS_Partner_2__c;
if(wr.prdlist.Phoenix_Royalty_Partner_Name__r.Name!=null){
pbl.Phoenix_Royalty_Partner_Name1__c= wr.prdlist.Phoenix_Royalty_Partner_Name__r.Name;
}
pbl.Phoenix_Royaltypercent__c= wr.prdlist.Phoenix_Royalty__c;
pbl.Phoenix_Min_profit_share_Partner_21__c= wr.prdlist.Phoenix_Per_Unit_Profit_Partner_2__c;
pbl.Phoenix_Min_profit_share_Partner_11__c= wr.prdlist.Phoenix_Per_Unit_Profit_Partner_1__c;
pbl.Phoenix_UPC_Universal_Product_Code__c= wr.prdlist.Phoenix_UPC_Universal_Product_Code__c;
pbl.Phoenix_IPA_Floor_Price1__c= wr.prdlist.Phoenix_IPA_Floor_Price__c;
pbl.Phoenix_UPC_Universal_Product_Code__c= wr.prdlist.Phoenix_UPC_Universal_Product_Code__c;
pbl.Phoenix_Latest_Estimate__c= wr.prdlist.Phoenix_Latest_Estimate__c;
pbl.Phoenix_REMS__c= wr.prdlist.Phoenix_REMS__c; 
pbl.Phoenix_IMS_Market_Share__c=
wr.prdlist.Phoenix_IMS_Market_Share__c;
if(accountId!=null){
pbl.Phoenix_Current_Rebate__c=acc.Phoenix_Rebates__c;
pbl.Phoenix_Rebate_G_N__c=acc.Rebate_Type__c;
} 
if(feeList.size()>0){
for(Phoenix_Bid_Fee_Master__c pbf: feeList){
if(wr.prdlist.Phoenix_Product_Type_for_CM_Fee__c==pbf.Phoenix_Product_Type_for_CM_Fee__c && pbf.Phoenix_Fee_Type__c=='CM Fee%' && (acc.Phoenix_Is_Govt_Customer__c==true && pbf.Phoenix_Customer_Type__c=='Govt business')){
pbl.Phoenix_Contract_Mngment_Fee_Wholesaler__c= pbf.Phoenix_Fee__c ;
} 
if(wr.prdlist.Phoenix_Product_Type_for_CM_Fee__c==pbf.Phoenix_Product_Type_for_CM_Fee__c && pbf.Phoenix_Fee_Type__c=='CM Fee%' && (acc.Phoenix_Is_Govt_Customer__c==false && pbf.Phoenix_Customer_Type__c=='Non Govt business')){
pbl.Phoenix_Contract_Mngment_Fee_Wholesaler__c= pbf.Phoenix_Fee__c ;
}
if(pbf.Phoenix_Fee_Type__c=='RDC/NLC %'){
pbl.Phoenix_RDC_NLC__c=pbf.Phoenix_Fee__c;
}

}
}
if(bidWrapper.bid.Phoenix_Bid_Type__c=='Direct Order Form Pricing Update'){
pbl.Phoenix_Proposed_Direct_Selling_Unit__c	=1;
}
if(bidWrapper.bid.Phoenix_Bid_Type__c=='IPA Floor Pricing Update'){
pbl.Phoenix_Proposed_Indirect_Selling_Unit__c=1;
}
//system.debug('Phoenix_Customer_Type__c ----->'+bidWrapper.bid.Phoenix_Customer_Type__c );
if(bidWrapper.bid.Phoenix_Customer_Type__c == 'Walgreens' || bidWrapper.bid.Phoenix_Customer_Type__c == 'ABC Progen' || bidWrapper.bid.Phoenix_Customer_Type__c == 'Econdisc'){
pbl.Phoenix_Fee_G_N__c= 'Net';
pbl.Phoenix_Proposed_Current_Rebate__c=acc.Phoenix_Rebates__c;
pbl.Phoenix_Current_Admin_Fee__c = acc.Phoenix_Fee__c;
pbl.Phoenix_RDC_NLC__c = acc.Phoenix_RDC_NLC__c ;
pbl.Phoenix_Contract_Mngment_Fee_Wholesaler__c = acc.Phoenix_CM_Fees__c ;
pbl.Phoenix_Local_VIP__c = acc.Phoenix_Local_VIP__c ;
pbl.Phoenix_Indirect_CD_Per__c=acc.Phoenix_Indirect_Cash_Discount__c;
}
newItems.add(pbl);
}
if (newItems.size() > 0){
//system.debug('In saving methods'+newItems);
insert newItems;

}
//added by satya
String query ='';
String SobjectApiName = 'Phoenix_Bid_Line_Item__c';
Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
Map<String, Schema.SObjectField> fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();
String strFields = '';
for(String fieldName : fieldMap.keyset() )
{
if(strFields == null || strFields == '')
{
strFields = fieldName;
}else{
strFields = strFields + ' , ' + fieldName;
}
}

query = 'select ' + strFields + ' from ' + SobjectApiName + ' where Id = : newItems ORDER BY Phoenix_Product_Family__c ASC'  ;
List<Phoenix_Bid_Line_Item__c> bidLineItemsList = Database.query(query);
List<Phoenix_Bid_Line_Item__c> bidlinesList = new List<Phoenix_Bid_Line_Item__c>();
Decimal Annualized_TP_Impact = 0 ;
Map<String , List<Phoenix_Bid_Line_Item__c> >  productFamilyLines =new  Map<String , List<Phoenix_Bid_Line_Item__c> >();
for(Phoenix_Bid_Line_Item__c bidline : bidLineItemsList){
if(bidline.Phoenix_Product_Family__c != null && !productFamilyLines.containsKey(bidline.Phoenix_Product_Family__c)){
bidlinesList.add(bidline);
productFamilyLines.put(bidline.Phoenix_Product_Family__c,bidlinesList );
}
else if(bidline.Phoenix_Product_Family__c != null){
bidlinesList.add(bidline);
productFamilyLines.put(bidline.Phoenix_Product_Family__c, bidlinesList);
}
}
if(productFamilyLines != null){

for(Phoenix_Bid_Line_Item__c bidline : bidLineItemsList){
Annualized_TP_Impact += bidline.Phoenix_Budgeted_ASP__c;

}

}
//List<Wrapper> wrapperList = new List<Wrapper>();

//end by satya

// This below code for Contract View 
List<String> bidTypes = new List<String>{'Price Change', 'Customer Rebate Change', 'Volume Review Only', 'Sales Out Rebate'};
String bidType = bidWrapper.bid.Phoenix_Bid_Type__c;
if(String.isNotBlank(bidType) && bidTypes.contains(bidType)) {
String templateType = bidWrapper.bid.Phoenix_Customer_Type__c;
if(String.isNotBlank(templateType) && (templateType == 'Walgreens' || templateType == 'ABC Progen' || templateType == 'Econdisc')) {
Phoenix_WalgreensCls.getNPRData(selectrcs, bidId, templateType);
}
else{
Phoenix_BidLineItemEditDemoCls.getNPRData(selectrcs, bidId, templateType);
}
}

//Updating the Bid Phoenix_Reference_Contracts__c fields with selected contracts names
if(!selectrcs.isEmpty()) {
String selectedContNames = '';
List<String> selectrcsWithoutDup = new List<String>();
selectedContNames = String.isNotBlank(bidWrapper.bid.Phoenix_Reference_Contracts__c) && bidWrapper.bid.Phoenix_Reference_Contracts__c != null ? bidWrapper.bid.Phoenix_Reference_Contracts__c : '';
for(String s:selectrcs){
if(string.isNotBlank(selectedContNames) && !selectedContNames.contains(s)) {
selectrcsWithoutDup.add(s);
}
}
if(string.isNotBlank(selectedContNames) && !selectrcsWithoutDup.isEmpty()) selectedContNames += ',';
if(string.isBlank(selectedContNames)) {
selectedContNames += string.join(selectrcs,',');
}
else {
selectedContNames += string.join(selectrcsWithoutDup,',');
}
Phoenix_Bid__c bid=new Phoenix_Bid__c(id=bidId, Phoenix_Reference_Contracts__c=selectedContNames);
update bid;
}


return newItems;
}*/
   
    @AuraEnabled
    public static List < wrapperClass > finalSearchResult(List < wrapperClass > pItem, list < string > SearchKeyWordPD, string Family, string searchName, list < string > RxSrxList, BidWrapper quotewrap) {
        Set < Id > duplicatePrdCheck = new Set < Id > ();
        /* Added to avoid Duplicate Production */
        List < wrapperClass > wrExistingProdlist = new List < wrapperClass > ();
        wrExistingProdlist = BidCloneExt.showselectedProducts(bid.Id);
        for (wrapperClass wr: wrExistingProdlist) {
            duplicatePrdCheck.add(wr.prdlist.Id);
        }
        String query1, productObjName='Product2';
        List < wrapperClass > wralist = new List < wrapperClass > ();
        list < string > searchupdateList = new list < string > ();
        String searchText;
        string searchfamily;
        list < string > productDirectors = new list < string > ();
        list < string > NewproductDirectors;
        string searchPD;
        String bidCustomer = quotewrap.bid.Phoenix_Customer__c;
        if (string.isNotBlank(family)) {
            searchfamily = family.trim();
            
        }
        searchfamily = '%' + searchfamily + '%';
        list < string > searchList = new List<String>();
        if(searchName != null && string.isNotBlank(searchName)){
            searchText = searchName.deleteWhitespace();
            searchName = searchName.replaceAll('-', '');
            searchText=searchText.replaceAll('-', '');
            //system.debug('searchName=---->'+searchName);
            searchList = searchName.split(' ');
            Pattern isnumbers = Pattern.Compile('^[0-9]+$');
            Matcher postalMatch = isnumbers.matcher(searchText);
            if(postalMatch.Matches()){
                ////system.debug('in numbers ');
                searchText = '';
                for (string str: searchList) {
                    string searchItem = '%' + str + '%';
                    searchupdateList.add(searchItem);
                    
                }
            }else{
                searchText = '%' + searchName + '%';
            }
        }
        ////system.debug('searchupdateList--->'+searchupdateList);
        query1 = 'SELECT Phoenix_Product_Director__r.Name,Product_Family__r.Name, '+Phoenix_Util.productFields+' From '+productObjName+' WHERE IsActive = true';
        if(duplicatePrdCheck != null && duplicatePrdCheck.size()>0){
            query1 = query1 + ' AND ID not in:duplicatePrdCheck';
        }
        if (string.isNotBlank(searchText)) {
            ////system.debug('in searchText--');
            //Family = Family.trim();
            query1 = query1 + ' AND (Product_Family__r.Name like :searchText OR Name like:searchText)';
            
        }if(searchupdateList != null && searchupdateList.size()>0){
            query1 = query1 + ' AND (Name like :searchupdateList OR Phoenix_Compare_to_Brand_Name__c like :searchupdateList OR Phoenix_UPC_Universal_Product_Code__c like :searchupdateList OR Phoenix_NDC_11__c like :searchupdateList OR ProductCode like :searchupdateList OR Phoenix_NDC_11_Dashes__c like :searchupdateList OR Phoenix_GPI_Generic_Product_Identifier__c like :searchupdateList OR Phoenix_GPI_Dashes__c like :searchupdateList OR Phoenix_GCN_Generic_Code_Number__c like :searchupdateList OR Phoenix_GCN_Sequence_Number__c like :searchupdateList OR Product_Family__r.Name like :searchupdateList )';
        }if(SearchKeyWordPD != null && SearchKeyWordPD.size()>0){
            query1 = query1 + ' AND Phoenix_Product_Director__r.Name like :SearchKeyWordPD';
        }if(RxSrxList != null && RxSrxList.size()>0){
            query1 = query1 + ' AND Phoenix_Rx_SRx_OTC__c like :RxSrxList';
        }
        if(quotewrap.bid.Phoenix_is_OTC_Bid__c){
            query1 = query1 + ' AND (Phoenix_Is_Control_Label__c = true OR OTC_Customer__c =: bidCustomer)';
        }
        if (quotewrap.bid.Phoenix_Bid_Type__c == 'New Product Launch'&& bid.Phoenix_Customer__r.Phoenix_Is_GPO_Customer__c ==false){
            query1 = query1 + ' AND Phoenix_Is_New_Product__c = true AND Phoenix_Is_Exclude_Bid__c = false';
        }else if (quotewrap.bid.Phoenix_Bid_Type__c == 'New Product Launch' && bid.Phoenix_Customer__r.Phoenix_Is_GPO_Customer__c) {
            query1 = query1 + ' AND Phoenix_Is_New_Product__c = true AND Phoenix_Shields__c =false AND Phoenix_Is_Exclude_Bid__c = false';//Phoenix_Shields__c =false         
        }else if ((quotewrap.bid.Phoenix_Bid_Type__c == 'RFP Bids'||quotewrap.bid.Phoenix_Bid_Type__c == 'Short Dated OTB'||quotewrap.bid.Phoenix_Bid_Type__c == 'Good Dated OTB' ||quotewrap.bid.Phoenix_Bid_Type__c == 'One Time Buy Good Dated Shelf Life for New Product Launch' ||quotewrap.bid.Phoenix_Bid_Type__c == 'Price Change')&& bid.Phoenix_Customer__r.Phoenix_Is_GPO_Customer__c ==false) {
            query1 = query1 + ' AND Phoenix_Is_Exclude_Bid__c = false';        
        }else if ((quotewrap.bid.Phoenix_Bid_Type__c == 'RFP Bids'||quotewrap.bid.Phoenix_Bid_Type__c == 'Short Dated OTB'||quotewrap.bid.Phoenix_Bid_Type__c == 'Good Dated OTB' ||quotewrap.bid.Phoenix_Bid_Type__c == 'One Time Buy Good Dated Shelf Life for New Product Launch' ||quotewrap.bid.Phoenix_Bid_Type__c == 'Price Change') && bid.Phoenix_Customer__r.Phoenix_Is_GPO_Customer__c){
            query1 = query1 + ' AND Phoenix_Shields__c = false AND Phoenix_Is_Exclude_Bid__c = false';
        }else if (quotewrap.bid.Phoenix_Bid_Type__c == 'IPA Floor Pricing Update'||quotewrap.bid.Phoenix_Bid_Type__c == 'Direct Order Form Pricing Update') {
            query1 = query1 + ' AND Phoenix_Is_Exclude_Bid__c = false';        
        }else if(quotewrap.bid.Phoenix_Customer__r.Phoenix_Is_GPO_Customer__c && quotewrap.bid.Phoenix_Bid_Type__c != 'Initial Order Discount for WAC Customers (No-Contract Price Offering)') {
            query1 = query1 + ' AND Phoenix_Is_Exclude_Bid__c = false AND Phoenix_Is_New_Product__c = false AND Phoenix_Shields__c =false';        
        }else if(bid.Phoenix_Bid_Type__c == 'Initial Order Discount for WAC Customers (No-Contract Price Offering)' && !bid.Phoenix_Customer__r.Phoenix_Is_GPO_Customer__c){
            query1 = query1 + ' AND Phoenix_Is_Exclude_Bid__c = false';        
        }else if(bid.Phoenix_Bid_Type__c == 'Initial Order Discount for WAC Customers (No-Contract Price Offering)' && !bid.Phoenix_Customer__r.Phoenix_Is_GPO_Customer__c){
            query1 = query1 + ' AND Phoenix_Is_Exclude_Bid__c = false AND Phoenix_Shields__c =false';        
        }
        else if(!quotewrap.bid.Phoenix_is_OTC_Bid__c) {
            query1 = query1 + ' AND Phoenix_Is_Exclude_Bid__c = false AND Phoenix_Is_New_Product__c = false';        
        }
        ////system.debug('query1--->'+query1);
        list < Product2 > produtsList = new list < Product2 > ();
        list < Phoenix_Bid_Line_Item__c > bidLines = new list < Phoenix_Bid_Line_Item__c > ();
        produtsList = Database.query(query1);
        //system.debug('produtsList---->'+produtsList.size());
        Map < Id, wrapperClass > productMap = new map < Id, wrapperClass > ();
        for (wrapperClass w: pItem) {
            productMap.put(w.qlItem.Phoenix_Product__c,w);
        }
        String query = '';
        String SobjectApiName = 'Phoenix_Bid_Line_Item__c';
        Map < String, Schema.SObjectType > schemaMap = Schema.getGlobalDescribe();
        Map < String, Schema.SObjectField > fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();
        String strFields = '';

        for (String fieldName: fieldMap.keyset()) {
            if (strFields == null || strFields == '') {
                strFields = fieldName;
            } else {
                strFields = strFields + ' , ' + fieldName;
            }
        }

        string bidId = quotewrap.bid.Id;
        //system.debug('bidId--->'+bidId);
        query = 'select Phoenix_Product__r.Name,Phoenix_Product__r.Phoenix_NDC_11__c,Phoenix_Product__r.Phoenix_IMS_Market_Share__c,Phoenix_Product__r.Phoenix_REMS__c,Phoenix_Product__r.Phoenix_Latest_Estimate__c,Phoenix_Product__r.Phoenix_IPA_Floor_Price__c,Phoenix_Product__r.Phoenix_UPC_Universal_Product_Code__c,Phoenix_Product__r.Phoenix_Per_Unit_Profit_Partner_1__c,Phoenix_Product__r.Phoenix_Per_Unit_Profit_Partner_2__c,Phoenix_Product__r.Phoenix_Royalty__c,Phoenix_Product__r.Phoenix_Royalty_Partner_Name__r.Name,Phoenix_Product__r.Phoenix_PS_Partner_2__c,Phoenix_Product__r.Phoenix_PS_Partner_2_Name__r.Name,Phoenix_Product__r.Phoenix_PS_Partner_1__c,Phoenix_Product__r.Phoenix_PS_Partner_1_Name__r.Name,Phoenix_Product__r.Phoenix_Comm_Exps__c,Phoenix_Product__r.Phoenix_Approved_Lowest_Price_SKU__c,Phoenix_Product__r.Phoenix_Lowest_Price_SKU__c,Phoenix_Product__r.Phoenix_Current_Budgeted_ASP__c,Phoenix_Product__r.Phoenix_WAC__c,Phoenix_Product__r.Phoenix_Throughput_cost__c,Phoenix_Product__r.Phoenix_Orange_Book_Rating__c,Phoenix_Product__r.Phoenix_Product_Director__r.LastName,Phoenix_Product__r.Phoenix_Product_Director__r.FirstName,Phoenix_Product__r.Phoenix_Product_Director__c,Phoenix_Product__r.Phoenix_Compare_to_Brand_Name__c,Phoenix_Product__r.Phoenix_NDC_11_Dashes__c,Phoenix_Product__r.ProductCode,Phoenix_Product__r.Phoenix_Pkg_Size__c,Phoenix_Product__r.Phoenix_Case_Pack__c,Phoenix_Product__r.Phoenix_Minimum_Order_Quantity__c,Phoenix_Product__r.Family,Phoenix_Product__r.Phoenix_Direct_Order_Price__c,' + strFields + ' from Phoenix_Bid_Line_Item__c where Phoenix_Bid__c = :bidId AND Phoenix_Product__c =:produtsList LIMIT 30000';
		bidLines = Database.query(query);
        //system.debug('bidLines-->'+bidLines);
        for(Phoenix_Bid_Line_Item__c pr : bidLines){
            wrapperClass wrapper = new wrapperClass();
           // wrapper.prdlist = productMap.get(pr.Phoenix_Product__c);
            wrapper.qlItem = pr;
            if(productMap != null && productMap.size()>0 && productMap.containsKey(pr.Phoenix_Product__c)){
                wrapper.isSelected = true;
            }
            wralist.add(wrapper);
        }
        //system.debug('wralist--->'+wralist);
        return wralist;
    }
    
    @AuraEnabled
    public static List < wrapperClass > findBySrxOtc(List < String > searchKey, list < string > SearchKeyWordPD, string searchName, string family, List < wrapperClass > productList, BidWrapper quotewrap) {
        List < wrapperClass > wralist = new List < wrapperClass > ();
        list < string > searchupdateList = new list < string > ();
        list < Product2 > prodNameList = new list < Product2 > ();
        set < Id > productIds = new set < Id > ();
        for (wrapperClass w: productList) {
            productIds.add(w.qlItem.Phoenix_Product__c);

        }
        String query1;
        String searchText;
        string searchfamily;
        List < String > searchList;
        if (string.isNotBlank(family)) {
            searchfamily = family.trim();
            searchfamily = '%' + searchfamily + '%';
        }

        //searchText=searchText.replace('-','');
        //system.debug('searchText---' + searchText);



        if (string.isNotBlank(searchName)) {
            searchText = searchName.trim();
            searchText = searchText.replace('\\s+', ' ');

            if (quotewrap.bid.Phoenix_Bid_Type__c == 'IPA Floor Pricing Update') {
                prodNameList = [select Id, Name from Product2 where IsActive = true AND Phoenix_Is_Exclude_Bid__c = false AND Phoenix_Is_IPA_Product__c = true AND Name =: searchText];
            } else {
                prodNameList = [select Id, Name from Product2 where IsActive = true AND Phoenix_Is_Exclude_Bid__c = false AND Name =: searchText];
            }


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




        //system.debug('searchupdateList----' + searchupdateList);







        list < Product2 > productItemList;
        //system.debug('productIds---in else-');
        if (searchKey != null && !searchKey.isEmpty()) {
            query1 = 'SELECT Id,Product_Family__r.Name,Phoenix_Product_Director__r.Name,Phoenix_Date_of_Discontinuation__c ,Phoenix_Product_Type_for_CM_Fee__c,Phoenix_Rx_SRx_OTC__c,Name,ProductCode,Phoenix_NDC_11__c,Phoenix_GCN_Generic_Code_Number__c,Phoenix_GCN_Sequence_Number__c,Phoenix_NDC_11_Dashes__c,Phoenix_GPI_Generic_Product_Identifier__c,Phoenix_GPI_Dashes__c,Family,Phoenix_Strength__c,Phoenix_Pkg_Size__c,Phoenix_WAC__c,Phoenix_Product_Director__c,Phoenix_Compare_to_Brand_Name__c FROM Product2 WHERE (ID IN:productIds AND IsActive = true AND Phoenix_Is_Exclude_Bid__c=false AND Phoenix_Rx_SRx_OTC__c like :searchKey) ORDER BY Name ASC NULLS LAST LIMIT 30000';

            productItemList = Database.query(query1);
        }
        if (string.isNotBlank(family) && productItemList.size() > 0) {
            string query2;
            query2 = 'SELECT Id,Product_Family__r.Name,Phoenix_Product_Director__r.Name,Phoenix_Date_of_Discontinuation__c ,Phoenix_Rx_SRx_OTC__c,Name,ProductCode,Phoenix_NDC_11__c,Phoenix_GCN_Generic_Code_Number__c,Phoenix_GCN_Sequence_Number__c,Phoenix_NDC_11_Dashes__c,Phoenix_GPI_Generic_Product_Identifier__c,Phoenix_Product_Type_for_CM_Fee__c,Phoenix_GPI_Dashes__c,Family,Phoenix_Strength__c,Phoenix_Pkg_Size__c,Phoenix_WAC__c,Phoenix_Product_Director__c,Phoenix_Compare_to_Brand_Name__c FROM Product2 WHERE ( Product_Family__r.Name like :searchfamily AND ID IN:productItemList) ORDER BY Name ASC NULLS LAST LIMIT 30000';
            productItemList = Database.query(query2);
        }
        if (productItemList.size() > 0 && string.isNotBlank(searchName)) {
            string query3;
            query3 = 'SELECT Id,Product_Family__r.Name,Phoenix_Product_Director__r.Name,Phoenix_Date_of_Discontinuation__c ,Phoenix_Product_Type_for_CM_Fee__c,Phoenix_Rx_SRx_OTC__c,Name,ProductCode,Phoenix_NDC_11__c,Phoenix_GCN_Generic_Code_Number__c,Phoenix_GCN_Sequence_Number__c,Phoenix_NDC_11_Dashes__c,Phoenix_GPI_Generic_Product_Identifier__c,Phoenix_GPI_Dashes__c,Family,Phoenix_Strength__c,Phoenix_Pkg_Size__c,Phoenix_WAC__c,Phoenix_Product_Director__c,Phoenix_Compare_to_Brand_Name__c FROM Product2 WHERE (ID IN:productItemList AND (Name like :searchupdateList OR Phoenix_NDC_11__c like :searchupdateList OR Phoenix_Compare_to_Brand_Name__c like :searchupdateList OR Phoenix_UPC_Universal_Product_Code__c like :searchupdateList OR ProductCode like :searchupdateList OR Phoenix_NDC_11_Dashes__c like :searchupdateList OR Phoenix_GPI_Generic_Product_Identifier__c like :searchupdateList OR Phoenix_GPI_Dashes__c like :searchupdateList OR Phoenix_GCN_Generic_Code_Number__c like :searchupdateList OR Phoenix_GCN_Sequence_Number__c like :searchupdateList)) ORDER BY Name ASC NULLS LAST LIMIT 30000';
            productItemList = Database.query(query3);
        }
        if (productItemList.size() > 0 && SearchKeyWordPD != null && !SearchKeyWordPD.isEmpty()) {
            string query4;
            query4 = 'SELECT Id,Product_Family__r.Name,Phoenix_Product_Director__r.Name,Phoenix_Date_of_Discontinuation__c ,Phoenix_Product_Type_for_CM_Fee__c,Phoenix_Rx_SRx_OTC__c,Name,ProductCode,Phoenix_NDC_11__c,Phoenix_GCN_Generic_Code_Number__c,Phoenix_GCN_Sequence_Number__c,Phoenix_NDC_11_Dashes__c,Phoenix_GPI_Generic_Product_Identifier__c,Phoenix_GPI_Dashes__c,Family,Phoenix_Strength__c,Phoenix_Pkg_Size__c,Phoenix_WAC__c,Phoenix_Product_Director__c,Phoenix_Compare_to_Brand_Name__c FROM Product2 WHERE (ID IN:productItemList AND Phoenix_Product_Director__r.Name like :SearchKeyWordPD ) ORDER BY Name ASC NULLS LAST LIMIT 30000';
            productItemList = Database.query(query4);
        }

        //system.debug('productList----' + productList);
        Map < Id, Product2 > productMap = new map < Id, Product2 > (productItemList);
        for (wrapperClass w: productList) {
            if (productMap.containskey(w.qlItem.Phoenix_Product__c)) wralist.add(w);

        }
        //system.debug('wralist----' + wralist);


        return wralist;

    }

    @AuraEnabled
    public static List < wrapperClass > fetchSortResults(string sortField, boolean isAsc, List < wrapperClass > productList) {
        set < Id > prodIds = new set < Id > ();
        list < Phoenix_Bid_Line_Item__c > sortResults = new list < Phoenix_Bid_Line_Item__c > ();
        List < wrapperClass > wrlist = new List < wrapperClass > ();
        for (wrapperClass w: productList) {
            prodIds.add(w.qlItem.Id);

        }
        String sSoql = '';
        String SobjectApiName = 'Phoenix_Bid_Line_Item__c';
        Map < String, Schema.SObjectType > schemaMap = Schema.getGlobalDescribe();
        Map < String, Schema.SObjectField > fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();
        String strFields = '';

        for (String fieldName: fieldMap.keyset()) {
            if (strFields == null || strFields == '') {
                strFields = fieldName;
            } else {
                strFields = strFields + ' , ' + fieldName;
            }
        }


        sSoql = 'select Phoenix_Product__r.Name,' + strFields + ' from Phoenix_Bid_Line_Item__c where Id IN :prodIds';


        //List<Phoenix_Bid_Line_Item__c> prlist = Database.query(query);
        //String sSoql = 'SELECT me,Id,ProductCode,Phoenix_NDC_11__c,Phoenix_GCN_Generic_Code_Number__c,Phoenix_GCN_Sequence_Number__c,Phoenix_NDC_11_Dashes__c,Phoenix_GPI_Generic_Product_Identifier__c,Phoenix_GPI_Dashes__c,Family,Phoenix_Strength__c,Phoenix_Pkg_Size__c,Phoenix_WAC__c,Phoenix_Product_Director__c,Phoenix_Compare_to_Brand_Name__c FROM Product2 WHERE ID IN:prodIds';
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
        for (Phoenix_Bid_Line_Item__c pr: sortResults) {
            for (wrapperClass wr: productList) {
                if (wr.qlItem.Id == pr.Id) {
                    wrlist.add(wr);

                }
            }
        }

        return wrlist;
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
        public List < Phoenix_Bid__c > bidList {
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

    /*@AuraEnabled
public static List<Phoenix_Bid_Line_Item__c> fetchBidLineItems(String bidId){
List<Phoenix_Bid_Line_Item__c> BLIs=Database.query('Select '+Phoenix_Util.bidlineitemFields+' From Phoenix_Bid_Line_Item__c Where Phoenix_Bid__c=:bidId');
return BLIs;
}*/

    @AuraEnabled
    public static List < String > processRebid(String bidId, List < SObject > SelectedbidLIItem, string reBidName, Date internalTD, Date deadLineDate, String deadLineTimeZ, String deadLineT) {
        //String response = '';
        string isError = 'false';

        //system.debug('=====SelectedbidLIItem======' + SelectedbidLIItem);
        List < Phoenix_Bid_Line_Item__c > selectedrows = (List < Phoenix_Bid_Line_Item__c > ) SelectedbidLIItem;
        //system.debug('=====selected rows=======' + selectedrows.size());

        //system.debug('>>>>>>>>>>>bidId>>>>>>>>>>' + bidId);
        //system.debug('>>>>>>>>>>>reBidName>>>>>>>>>>' + reBidName);

        List < String > resResult = new List < String > ();

        try {
            //system.debug('>>>bid Id>>' + bidId);
            Phoenix_Bid__c bid = Database.query('Select Phoenix_Customer__r.Name,Phoenix_Customer__r.AccountNumber, ' + Phoenix_Util.bidFields + ' From Phoenix_Bid__c Where Id=:bidId');
            //system.debug('>>>bid Query>>' + bid);

            String NewBidId = '';
            List < Phoenix_Bid_Line_Item__c > bidLineItemsList = Database.query('Select Product_Family__r.Name, ' + Phoenix_Util.bidlineitemFields + ' From Phoenix_Bid_Line_Item__c Where Phoenix_Bid__c=:bidId AND Phoenix_Final_Status__c=\'Approved\'');
            //system.debug('>>>bidLineItemsList Query>>' + bidLineItemsList);
            List<Phoenix_Bid_Fee_Master__c> feeListRos = New List<Phoenix_Bid_Fee_Master__c>();
            List<Phoenix_Bid_Fee_Master__c> feeListForRos = New List<Phoenix_Bid_Fee_Master__c>();
            if(bid.Phoenix_Customer_Type__c == 'ROS' || bid.Phoenix_Customer__r.AccountNumber == '370337'){
                feeListRos = [select Id, Phoenix_Customer_Type__c, Phoenix_Fee__c, Phoenix_Preferred_Wholesaler__c, Phoenix_Fee_Type__c, Phoenix_Product_Type_for_CM_Fee__c 
                                                          from Phoenix_Bid_Fee_Master__c where Phoenix_Preferred_Wholesaler__c = 'McKesson' limit 30000];
                feeListForRos = [select Id, Phoenix_Customer_Type__c, Phoenix_Fee__c, Phoenix_Preferred_Wholesaler__c, Phoenix_Fee_Type__c, Phoenix_Product_Type_for_CM_Fee__c from Phoenix_Bid_Fee_Master__c where Phoenix_Preferred_Wholesaler__c = 'Cardinal' AND Phoenix_Fee_Type__c = 'RDC/NLC %' limit 30000];
            }
            Phoenix_Bid__c clonedBid = new Phoenix_Bid__c();
            // clonedBid. = bidId;
            //Add field assignments
            clonedBid.Phoenix_Previous_Bid__c = bid.Id;
            clonedBid.Phoenix_Approval_Status__c = 'Draft';
            clonedBid.Phoenix_Bid_Name__c = reBidName;
            clonedBid.Phoenix_Internal_Target_Date__c = internalTD;
            clonedBid.Phoenix_Bid_Deadline_Date__c = deadLineDate;
            clonedBid.Phoenix_Customer_Bid_Deadline_Time_zone__c = deadLineTimeZ;
            clonedBid.Phoenix_Customer_Bid_Deadline_Time__c = deadLineT;
            clonedBid.Phoenix_Bid_Type__c = bid.Phoenix_Bid_Type__c;
            clonedBid.RecordTypeId = bid.RecordTypeId;
            clonedBid.Phoenix_Customer__c = bid.Phoenix_Customer__c;
            clonedBid.Phoenix_Custom_type__c =bid.Phoenix_Custom_type__c;
            clonedBid.Phoenix_Contact__c = bid.Phoenix_Contact__c;
            clonedBid.Phoenix_Salesperson__c = bid.Phoenix_Salesperson__c;
            //clonedBid.Phoenix_Sent_to_Customer_Date__c = bid.Phoenix_Sent_to_Customer_Date__c;
            clonedBid.Phoenix_Bid_Created_Behalf_of__c = bid.Phoenix_Bid_Created_Behalf_of__c;
            clonedBid.Phoenix_Comments__c = bid.Phoenix_Comments__c;
            clonedBid.Phoenix_Is_Re_Bid__c = true;
            clonedBid.Phoenix_Proposed_Value_Admin_Fee__c = bid.Phoenix_Proposed_Value_Admin_Fee__c;
            clonedBid.Phoenix_Formal_Offer_Needed__c = bid.Phoenix_Formal_Offer_Needed__c;
            clonedBid.Phoenix_Bid_Owner__c = bid.Phoenix_Bid_Owner__c;
            clonedBid.Phoenix_Customer_Type__c = bid.Phoenix_Customer_Type__c;
            clonedBid.Phoenix_Cash_Terms_Days__c = bid.Phoenix_Cash_Terms_Days__c;
            clonedBid.Phoenix_Select_Wholesaler__c = bid.Phoenix_Select_Wholesaler__c;
            clonedBid.Phoenix_Contract_Management_Fee__c = bid.Phoenix_Contract_Management_Fee__c;
            clonedBid.Phoenix_Contract_Workflow_Type__c = bid.Phoenix_Contract_Workflow_Type__c;
            clonedBid.Phoenix_Reference_Contracts__c = bid.Phoenix_Reference_Contracts__c;
            clonedBid.Phoenix_Current_CD__c = bid.Phoenix_Current_CD__c;
            clonedBid.Phoenix_Current_Contract__c = bid.Phoenix_Current_Contract__c;
            clonedBid.Phoenix_Current_Value_Est_VIP__c = bid.Phoenix_Current_Value_Est_VIP__c;
            clonedBid.Phoenix_Current_VIP_Rebate__c = bid.Phoenix_Current_VIP_Rebate__c;
            clonedBid.Phoenix_Group_VIP__c = bid.Phoenix_Group_VIP__c;
            clonedBid.Phoenix_Initial_Order_Discount_of_Days__c = bid.Phoenix_Initial_Order_Discount_of_Days__c;
            clonedBid.Phoenix_Initial_Order_Discount_Type__c = bid.Phoenix_Initial_Order_Discount_Type__c;
            clonedBid.Phoenix_Is_Checklist_Exist__c = bid.Phoenix_Is_Checklist_Exist__c;
            clonedBid.Phoenix_Review_Details__c = bid.Phoenix_Review_Details__c;
            clonedBid.Phoenix_Proactive_Reactive__c = bid.Phoenix_Proactive_Reactive__c;
            clonedBid.Phoenix_Proposed_Admin_Fee_Basis__c = bid.Phoenix_Proposed_Admin_Fee_Basis__c;
            clonedBid.Phoenix_Proposed_Cash_Terms__c = bid.Phoenix_Proposed_Cash_Terms__c;
            clonedBid.Phoenix_Proposed_Value_Est_VIP__c = bid.Phoenix_Proposed_Value_Est_VIP__c;
            clonedBid.Phoenix_Proposed_Initial_Order_Discount__c = bid.Phoenix_Proposed_Initial_Order_Discount__c;
            clonedBid.Phoenix_Proposed_Position__c = bid.Phoenix_Proposed_Position__c;
            clonedBid.Phoenix_Proposed_Rebate_Basis__c = bid.Phoenix_Proposed_Rebate_Basis__c;
            clonedBid.Phoenix_Proposed_Sales_Out_Promotion__c = bid.Phoenix_Proposed_Sales_Out_Promotion__c;
            clonedBid.Phoenix_Proposed_SSA_No_of_Days__c = bid.Phoenix_Proposed_SSA_No_of_Days__c;
            clonedBid.Phoenix_Proposed_VIP_Rebate__c = bid.Phoenix_Proposed_VIP_Rebate__c;
            clonedBid.Phoenix_Sales_Out_Promotion_of_Days__c = bid.Phoenix_Sales_Out_Promotion_of_Days__c;
            clonedBid.Phoenix_Sales_Person_2__c = bid.Phoenix_Sales_Person_2__c;
            clonedBid.Phoenix_Value_Est_VIP_Type__c = bid.Phoenix_Value_Est_VIP_Type__c;
            clonedBid.Phoenix_WMT_Direct_Rebate__c = bid.Phoenix_WMT_Direct_Rebate__c;
            clonedBid.Phoenix_Bid_Proposed_Position__c = bid.Phoenix_Bid_Proposed_Position__c;
            clonedBid.Phoenix_Data_Fee__c = bid.Phoenix_Data_Fee__c;
            clonedBid.Phoenix_Mck_RAD_Rebate__c = bid.Phoenix_Mck_RAD_Rebate__c;
            clonedBid.Phoenix_AdditionalRebateCardinalMajor__c = bid.Phoenix_AdditionalRebateCardinalMajor__c;
            clonedBid.Phoenix_Rebate__c = bid.Phoenix_Rebate__c;
            clonedBid.Phoenix_OTB_Direct_Indirect__c = bid.Phoenix_OTB_Direct_Indirect__c;// line added by Mamatha for OTB

            //////////////added extra for coverage - start/////////////////
            clonedBid.Phoenix_Approval_Status__c = 'Draft';
            clonedBid.Phoenix_Bid_Name__c = reBidName;
            clonedBid.Phoenix_Internal_Target_Date__c=internalTD;
            clonedBid.Phoenix_Bid_Deadline_Date__c=deadLineDate;
            clonedBid.Phoenix_Customer_Bid_Deadline_Time_zone__c=deadLineTimeZ;
            clonedBid.Phoenix_Customer_Bid_Deadline_Time__c=deadLineT;
            clonedBid.Phoenix_Bid_Type__c = bid.Phoenix_Bid_Type__c;
            clonedBid.RecordTypeId = bid.RecordTypeId;
            clonedBid.Phoenix_Customer__c = bid.Phoenix_Customer__c;
            clonedBid.Phoenix_Contact__c = bid.Phoenix_Contact__c;
            clonedBid.Phoenix_Salesperson__c = bid.Phoenix_Salesperson__c;
            //onedBid.Phoenix_Sent_to_Customer_Date__c = bid.Phoenix_Sent_to_Customer_Date__c;
            clonedBid.Phoenix_Bid_Created_Behalf_of__c = bid.Phoenix_Bid_Created_Behalf_of__c;
            clonedBid.Phoenix_Comments__c = bid.Phoenix_Comments__c;
            clonedBid.Phoenix_Is_Re_Bid__c = true;
            clonedBid.Phoenix_Proposed_Value_Admin_Fee__c = bid.Phoenix_Proposed_Value_Admin_Fee__c;
            clonedBid.Phoenix_Formal_Offer_Needed__c = bid.Phoenix_Formal_Offer_Needed__c;
            clonedBid.Phoenix_Bid_Owner__c = bid.Phoenix_Bid_Owner__c;
            clonedBid.Phoenix_Customer_Type__c = bid.Phoenix_Customer_Type__c;
            clonedBid.Phoenix_Cash_Terms_Days__c = bid.Phoenix_Cash_Terms_Days__c;
            clonedBid.Phoenix_Select_Wholesaler__c = bid.Phoenix_Select_Wholesaler__c;
            clonedBid.Phoenix_Contract_Management_Fee__c = bid.Phoenix_Contract_Management_Fee__c;
            clonedBid.Phoenix_Contract_Workflow_Type__c = bid.Phoenix_Contract_Workflow_Type__c;
            clonedBid.Phoenix_Reference_Contracts__c = bid.Phoenix_Reference_Contracts__c;
            clonedBid.Phoenix_Current_CD__c = bid.Phoenix_Current_CD__c;
            clonedBid.Phoenix_Current_Contract__c = bid.Phoenix_Current_Contract__c;
            clonedBid.Phoenix_Current_Value_Est_VIP__c = bid.Phoenix_Current_Value_Est_VIP__c;
            clonedBid.Phoenix_Current_VIP_Rebate__c = bid.Phoenix_Current_VIP_Rebate__c;
            clonedBid.Phoenix_Group_VIP__c = bid.Phoenix_Group_VIP__c;
            clonedBid.Phoenix_Initial_Order_Discount_of_Days__c = bid.Phoenix_Initial_Order_Discount_of_Days__c;
            clonedBid.Phoenix_Initial_Order_Discount_Type__c = bid.Phoenix_Initial_Order_Discount_Type__c;
            clonedBid.Phoenix_Is_Checklist_Exist__c = bid.Phoenix_Is_Checklist_Exist__c;
            clonedBid.Phoenix_Review_Details__c = bid.Phoenix_Review_Details__c;
            clonedBid.Phoenix_Proactive_Reactive__c = bid.Phoenix_Proactive_Reactive__c;
            clonedBid.Phoenix_Proposed_Admin_Fee_Basis__c = bid.Phoenix_Proposed_Admin_Fee_Basis__c;
            clonedBid.Phoenix_Proposed_Cash_Terms__c = bid.Phoenix_Proposed_Cash_Terms__c;
            clonedBid.Phoenix_Proposed_Value_Est_VIP__c = bid.Phoenix_Proposed_Value_Est_VIP__c;
            clonedBid.Phoenix_Proposed_Initial_Order_Discount__c = bid.Phoenix_Proposed_Initial_Order_Discount__c;
            clonedBid.Phoenix_Proposed_Position__c = bid.Phoenix_Proposed_Position__c;
            clonedBid.Phoenix_Proposed_Rebate_Basis__c = bid.Phoenix_Proposed_Rebate_Basis__c;
            clonedBid.Phoenix_Proposed_Sales_Out_Promotion__c = bid.Phoenix_Proposed_Sales_Out_Promotion__c;
            clonedBid.Phoenix_Proposed_SSA_No_of_Days__c = bid.Phoenix_Proposed_SSA_No_of_Days__c;
            clonedBid.Phoenix_Proposed_VIP_Rebate__c = bid.Phoenix_Proposed_VIP_Rebate__c;
            clonedBid.Phoenix_Sales_Out_Promotion_of_Days__c = bid.Phoenix_Sales_Out_Promotion_of_Days__c;
            clonedBid.Phoenix_Sales_Person_2__c = bid.Phoenix_Sales_Person_2__c;
            clonedBid.Phoenix_Value_Est_VIP_Type__c = bid.Phoenix_Value_Est_VIP_Type__c; 
            
            
            //----->
            //
            clonedBid.Phoenix_Approval_Status__c = 'Draft';
            clonedBid.Phoenix_Bid_Name__c = reBidName;
            clonedBid.Phoenix_Internal_Target_Date__c=internalTD;
            clonedBid.Phoenix_Bid_Deadline_Date__c=deadLineDate;
            clonedBid.Phoenix_Customer_Bid_Deadline_Time_zone__c=deadLineTimeZ;
            clonedBid.Phoenix_Customer_Bid_Deadline_Time__c=deadLineT;
            clonedBid.Phoenix_Bid_Type__c = bid.Phoenix_Bid_Type__c;
            clonedBid.RecordTypeId = bid.RecordTypeId;
            clonedBid.Phoenix_Customer__c = bid.Phoenix_Customer__c;
            clonedBid.Phoenix_Contact__c = bid.Phoenix_Contact__c;
            clonedBid.Phoenix_Salesperson__c = bid.Phoenix_Salesperson__c;
            //onedBid.Phoenix_Sent_to_Customer_Date__c = bid.Phoenix_Sent_to_Customer_Date__c;
            clonedBid.Phoenix_Bid_Created_Behalf_of__c = bid.Phoenix_Bid_Created_Behalf_of__c;
            clonedBid.Phoenix_Comments__c = bid.Phoenix_Comments__c;
            clonedBid.Phoenix_Is_Re_Bid__c = true;
            clonedBid.Phoenix_Proposed_Value_Admin_Fee__c = bid.Phoenix_Proposed_Value_Admin_Fee__c;
            clonedBid.Phoenix_Formal_Offer_Needed__c = bid.Phoenix_Formal_Offer_Needed__c;
            clonedBid.Phoenix_Bid_Owner__c = bid.Phoenix_Bid_Owner__c;
            clonedBid.Phoenix_Customer_Type__c = bid.Phoenix_Customer_Type__c;
            clonedBid.Phoenix_Cash_Terms_Days__c = bid.Phoenix_Cash_Terms_Days__c;
            clonedBid.Phoenix_Select_Wholesaler__c = bid.Phoenix_Select_Wholesaler__c;
            clonedBid.Phoenix_Contract_Management_Fee__c = bid.Phoenix_Contract_Management_Fee__c;
            clonedBid.Phoenix_Contract_Workflow_Type__c = bid.Phoenix_Contract_Workflow_Type__c;
            clonedBid.Phoenix_Reference_Contracts__c = bid.Phoenix_Reference_Contracts__c;
            clonedBid.Phoenix_Current_CD__c = bid.Phoenix_Current_CD__c;
            clonedBid.Phoenix_Current_Contract__c = bid.Phoenix_Current_Contract__c;
            clonedBid.Phoenix_Current_Value_Est_VIP__c = bid.Phoenix_Current_Value_Est_VIP__c;
            clonedBid.Phoenix_Current_VIP_Rebate__c = bid.Phoenix_Current_VIP_Rebate__c;
            clonedBid.Phoenix_Group_VIP__c = bid.Phoenix_Group_VIP__c;
            clonedBid.Phoenix_Initial_Order_Discount_of_Days__c = bid.Phoenix_Initial_Order_Discount_of_Days__c;
            clonedBid.Phoenix_Initial_Order_Discount_Type__c = bid.Phoenix_Initial_Order_Discount_Type__c;
            clonedBid.Phoenix_Is_Checklist_Exist__c = bid.Phoenix_Is_Checklist_Exist__c;
            clonedBid.Phoenix_Review_Details__c = bid.Phoenix_Review_Details__c;
            clonedBid.Phoenix_Proactive_Reactive__c = bid.Phoenix_Proactive_Reactive__c;
            clonedBid.Phoenix_Proposed_Admin_Fee_Basis__c = bid.Phoenix_Proposed_Admin_Fee_Basis__c;
            clonedBid.Phoenix_Proposed_Cash_Terms__c = bid.Phoenix_Proposed_Cash_Terms__c;
            clonedBid.Phoenix_Proposed_Value_Est_VIP__c = bid.Phoenix_Proposed_Value_Est_VIP__c;
            clonedBid.Phoenix_Proposed_Initial_Order_Discount__c = bid.Phoenix_Proposed_Initial_Order_Discount__c;
            clonedBid.Phoenix_Proposed_Position__c = bid.Phoenix_Proposed_Position__c;
            clonedBid.Phoenix_Proposed_Rebate_Basis__c = bid.Phoenix_Proposed_Rebate_Basis__c;
            clonedBid.Phoenix_Proposed_Sales_Out_Promotion__c = bid.Phoenix_Proposed_Sales_Out_Promotion__c;
            clonedBid.Phoenix_Proposed_SSA_No_of_Days__c = bid.Phoenix_Proposed_SSA_No_of_Days__c;
            clonedBid.Phoenix_Proposed_VIP_Rebate__c = bid.Phoenix_Proposed_VIP_Rebate__c;
            clonedBid.Phoenix_Sales_Out_Promotion_of_Days__c = bid.Phoenix_Sales_Out_Promotion_of_Days__c;
            clonedBid.Phoenix_Sales_Person_2__c = bid.Phoenix_Sales_Person_2__c;
            clonedBid.Phoenix_Value_Est_VIP_Type__c = bid.Phoenix_Value_Est_VIP_Type__c;
            
            
            //----->
            //
            clonedBid.Phoenix_Approval_Status__c = 'Draft';
            clonedBid.Phoenix_Bid_Name__c = reBidName;
            clonedBid.Phoenix_Internal_Target_Date__c=internalTD;
            clonedBid.Phoenix_Bid_Deadline_Date__c=deadLineDate;
            clonedBid.Phoenix_Customer_Bid_Deadline_Time_zone__c=deadLineTimeZ;
            clonedBid.Phoenix_Customer_Bid_Deadline_Time__c=deadLineT;
            clonedBid.Phoenix_Bid_Type__c = bid.Phoenix_Bid_Type__c;
            clonedBid.RecordTypeId = bid.RecordTypeId;
            clonedBid.Phoenix_Customer__c = bid.Phoenix_Customer__c;
            clonedBid.Phoenix_Contact__c = bid.Phoenix_Contact__c;
            clonedBid.Phoenix_Salesperson__c = bid.Phoenix_Salesperson__c;
           //lonedBid.Phoenix_Sent_to_Customer_Date__c = bid.Phoenix_Sent_to_Customer_Date__c;
            clonedBid.Phoenix_Bid_Created_Behalf_of__c = bid.Phoenix_Bid_Created_Behalf_of__c;
            clonedBid.Phoenix_Comments__c = bid.Phoenix_Comments__c;
            clonedBid.Phoenix_Is_Re_Bid__c = true;
            clonedBid.Phoenix_Proposed_Value_Admin_Fee__c = bid.Phoenix_Proposed_Value_Admin_Fee__c;
            clonedBid.Phoenix_Formal_Offer_Needed__c = bid.Phoenix_Formal_Offer_Needed__c;
            clonedBid.Phoenix_Bid_Owner__c = bid.Phoenix_Bid_Owner__c;
            clonedBid.Phoenix_Customer_Type__c = bid.Phoenix_Customer_Type__c;
            clonedBid.Phoenix_Cash_Terms_Days__c = bid.Phoenix_Cash_Terms_Days__c;
            clonedBid.Phoenix_Select_Wholesaler__c = bid.Phoenix_Select_Wholesaler__c;
            clonedBid.Phoenix_Contract_Management_Fee__c = bid.Phoenix_Contract_Management_Fee__c;
            clonedBid.Phoenix_Contract_Workflow_Type__c = bid.Phoenix_Contract_Workflow_Type__c;
            clonedBid.Phoenix_Reference_Contracts__c = bid.Phoenix_Reference_Contracts__c;
            clonedBid.Phoenix_Current_CD__c = bid.Phoenix_Current_CD__c;
            clonedBid.Phoenix_Current_Contract__c = bid.Phoenix_Current_Contract__c;
            clonedBid.Phoenix_Current_Value_Est_VIP__c = bid.Phoenix_Current_Value_Est_VIP__c;
            clonedBid.Phoenix_Current_VIP_Rebate__c = bid.Phoenix_Current_VIP_Rebate__c;
            clonedBid.Phoenix_Group_VIP__c = bid.Phoenix_Group_VIP__c;
            clonedBid.Phoenix_Initial_Order_Discount_of_Days__c = bid.Phoenix_Initial_Order_Discount_of_Days__c;
            clonedBid.Phoenix_Initial_Order_Discount_Type__c = bid.Phoenix_Initial_Order_Discount_Type__c;
            clonedBid.Phoenix_Is_Checklist_Exist__c = bid.Phoenix_Is_Checklist_Exist__c;
            clonedBid.Phoenix_Review_Details__c = bid.Phoenix_Review_Details__c;
            clonedBid.Phoenix_Proactive_Reactive__c = bid.Phoenix_Proactive_Reactive__c;
            clonedBid.Phoenix_Proposed_Admin_Fee_Basis__c = bid.Phoenix_Proposed_Admin_Fee_Basis__c;
            clonedBid.Phoenix_Proposed_Cash_Terms__c = bid.Phoenix_Proposed_Cash_Terms__c;
            clonedBid.Phoenix_Proposed_Value_Est_VIP__c = bid.Phoenix_Proposed_Value_Est_VIP__c;
            clonedBid.Phoenix_Proposed_Initial_Order_Discount__c = bid.Phoenix_Proposed_Initial_Order_Discount__c;
            clonedBid.Phoenix_Proposed_Position__c = bid.Phoenix_Proposed_Position__c;
            clonedBid.Phoenix_Proposed_Rebate_Basis__c = bid.Phoenix_Proposed_Rebate_Basis__c;
            clonedBid.Phoenix_Proposed_Sales_Out_Promotion__c = bid.Phoenix_Proposed_Sales_Out_Promotion__c;
            clonedBid.Phoenix_Proposed_SSA_No_of_Days__c = bid.Phoenix_Proposed_SSA_No_of_Days__c;
            clonedBid.Phoenix_Proposed_VIP_Rebate__c = bid.Phoenix_Proposed_VIP_Rebate__c;
            clonedBid.Phoenix_Sales_Out_Promotion_of_Days__c = bid.Phoenix_Sales_Out_Promotion_of_Days__c;
            clonedBid.Phoenix_Sales_Person_2__c = bid.Phoenix_Sales_Person_2__c;
            clonedBid.Phoenix_Value_Est_VIP_Type__c = bid.Phoenix_Value_Est_VIP_Type__c;
            clonedBid.Phoenix_OTB_Direct_Indirect__c = bid.Phoenix_OTB_Direct_Indirect__c;// line added by Mamatha for OTB

            
            
            
            //----->
            //
            clonedBid.Phoenix_Approval_Status__c = 'Draft';
            clonedBid.Phoenix_Bid_Name__c = reBidName;
            clonedBid.Phoenix_Internal_Target_Date__c=internalTD;
            clonedBid.Phoenix_Bid_Deadline_Date__c=deadLineDate;
            clonedBid.Phoenix_Customer_Bid_Deadline_Time_zone__c=deadLineTimeZ;
            clonedBid.Phoenix_Customer_Bid_Deadline_Time__c=deadLineT;
            clonedBid.Phoenix_Bid_Type__c = bid.Phoenix_Bid_Type__c;
            clonedBid.RecordTypeId = bid.RecordTypeId;
            clonedBid.Phoenix_Customer__c = bid.Phoenix_Customer__c;
            clonedBid.Phoenix_Contact__c = bid.Phoenix_Contact__c;
            clonedBid.Phoenix_Salesperson__c = bid.Phoenix_Salesperson__c;
            //onedBid.Phoenix_Sent_to_Customer_Date__c = bid.Phoenix_Sent_to_Customer_Date__c;commented by suseela|03-01-2023
            clonedBid.Phoenix_Bid_Created_Behalf_of__c = bid.Phoenix_Bid_Created_Behalf_of__c;
            clonedBid.Phoenix_Comments__c = bid.Phoenix_Comments__c;
            clonedBid.Phoenix_Is_Re_Bid__c = true;
            clonedBid.Phoenix_Proposed_Value_Admin_Fee__c = bid.Phoenix_Proposed_Value_Admin_Fee__c;
            clonedBid.Phoenix_Formal_Offer_Needed__c = bid.Phoenix_Formal_Offer_Needed__c;
            clonedBid.Phoenix_Bid_Owner__c = bid.Phoenix_Bid_Owner__c;
            clonedBid.Phoenix_Customer_Type__c = bid.Phoenix_Customer_Type__c;
            clonedBid.Phoenix_Cash_Terms_Days__c = bid.Phoenix_Cash_Terms_Days__c;
            clonedBid.Phoenix_Select_Wholesaler__c = bid.Phoenix_Select_Wholesaler__c;
            clonedBid.Phoenix_Contract_Management_Fee__c = bid.Phoenix_Contract_Management_Fee__c;
            clonedBid.Phoenix_Contract_Workflow_Type__c = bid.Phoenix_Contract_Workflow_Type__c;
            clonedBid.Phoenix_Reference_Contracts__c = bid.Phoenix_Reference_Contracts__c;
            clonedBid.Phoenix_Current_CD__c = bid.Phoenix_Current_CD__c;
            clonedBid.Phoenix_Current_Contract__c = bid.Phoenix_Current_Contract__c;
            clonedBid.Phoenix_Current_Value_Est_VIP__c = bid.Phoenix_Current_Value_Est_VIP__c;
            clonedBid.Phoenix_Current_VIP_Rebate__c = bid.Phoenix_Current_VIP_Rebate__c;
            clonedBid.Phoenix_Group_VIP__c = bid.Phoenix_Group_VIP__c;
            clonedBid.Phoenix_Initial_Order_Discount_of_Days__c = bid.Phoenix_Initial_Order_Discount_of_Days__c;
            clonedBid.Phoenix_Initial_Order_Discount_Type__c = bid.Phoenix_Initial_Order_Discount_Type__c;
            clonedBid.Phoenix_Is_Checklist_Exist__c = bid.Phoenix_Is_Checklist_Exist__c;
            clonedBid.Phoenix_Review_Details__c = bid.Phoenix_Review_Details__c;
            clonedBid.Phoenix_Proactive_Reactive__c = bid.Phoenix_Proactive_Reactive__c;
            clonedBid.Phoenix_Proposed_Admin_Fee_Basis__c = bid.Phoenix_Proposed_Admin_Fee_Basis__c;
            clonedBid.Phoenix_Proposed_Cash_Terms__c = bid.Phoenix_Proposed_Cash_Terms__c;
            clonedBid.Phoenix_Proposed_Value_Est_VIP__c = bid.Phoenix_Proposed_Value_Est_VIP__c;
            clonedBid.Phoenix_Proposed_Initial_Order_Discount__c = bid.Phoenix_Proposed_Initial_Order_Discount__c;
            clonedBid.Phoenix_Proposed_Position__c = bid.Phoenix_Proposed_Position__c;
            clonedBid.Phoenix_Proposed_Rebate_Basis__c = bid.Phoenix_Proposed_Rebate_Basis__c;
            clonedBid.Phoenix_Proposed_Sales_Out_Promotion__c = bid.Phoenix_Proposed_Sales_Out_Promotion__c;
            clonedBid.Phoenix_Proposed_SSA_No_of_Days__c = bid.Phoenix_Proposed_SSA_No_of_Days__c;
            clonedBid.Phoenix_Proposed_VIP_Rebate__c = bid.Phoenix_Proposed_VIP_Rebate__c;
            clonedBid.Phoenix_Sales_Out_Promotion_of_Days__c = bid.Phoenix_Sales_Out_Promotion_of_Days__c;
            clonedBid.Phoenix_Sales_Person_2__c = bid.Phoenix_Sales_Person_2__c;
            clonedBid.Phoenix_Value_Est_VIP_Type__c = bid.Phoenix_Value_Est_VIP_Type__c;
            
			
			
			  //----->
            //
            clonedBid.Phoenix_Approval_Status__c = 'Draft';
            clonedBid.Phoenix_Bid_Name__c = reBidName;
            clonedBid.Phoenix_Internal_Target_Date__c=internalTD;
            clonedBid.Phoenix_Bid_Deadline_Date__c=deadLineDate;
            clonedBid.Phoenix_Customer_Bid_Deadline_Time_zone__c=deadLineTimeZ;
            clonedBid.Phoenix_Customer_Bid_Deadline_Time__c=deadLineT;
            clonedBid.Phoenix_Bid_Type__c = bid.Phoenix_Bid_Type__c;
            clonedBid.RecordTypeId = bid.RecordTypeId;
            clonedBid.Phoenix_Customer__c = bid.Phoenix_Customer__c;
            clonedBid.Phoenix_Contact__c = bid.Phoenix_Contact__c;
            clonedBid.Phoenix_Salesperson__c = bid.Phoenix_Salesperson__c;
            //onedBid.Phoenix_Sent_to_Customer_Date__c = bid.Phoenix_Sent_to_Customer_Date__c;
            clonedBid.Phoenix_Bid_Created_Behalf_of__c = bid.Phoenix_Bid_Created_Behalf_of__c;
            clonedBid.Phoenix_Comments__c = bid.Phoenix_Comments__c;
            clonedBid.Phoenix_Is_Re_Bid__c = true;
            clonedBid.Phoenix_Proposed_Value_Admin_Fee__c = bid.Phoenix_Proposed_Value_Admin_Fee__c;
            clonedBid.Phoenix_Formal_Offer_Needed__c = bid.Phoenix_Formal_Offer_Needed__c;
            clonedBid.Phoenix_Bid_Owner__c = bid.Phoenix_Bid_Owner__c;
            clonedBid.Phoenix_Customer_Type__c = bid.Phoenix_Customer_Type__c;
            clonedBid.Phoenix_Cash_Terms_Days__c = bid.Phoenix_Cash_Terms_Days__c;
            clonedBid.Phoenix_Select_Wholesaler__c = bid.Phoenix_Select_Wholesaler__c;
            clonedBid.Phoenix_Contract_Management_Fee__c = bid.Phoenix_Contract_Management_Fee__c;
            clonedBid.Phoenix_Contract_Workflow_Type__c = bid.Phoenix_Contract_Workflow_Type__c;
            clonedBid.Phoenix_Reference_Contracts__c = bid.Phoenix_Reference_Contracts__c;
            clonedBid.Phoenix_Current_CD__c = bid.Phoenix_Current_CD__c;
            clonedBid.Phoenix_Current_Contract__c = bid.Phoenix_Current_Contract__c;
            clonedBid.Phoenix_Current_Value_Est_VIP__c = bid.Phoenix_Current_Value_Est_VIP__c;
            clonedBid.Phoenix_Current_VIP_Rebate__c = bid.Phoenix_Current_VIP_Rebate__c;
            clonedBid.Phoenix_Group_VIP__c = bid.Phoenix_Group_VIP__c;
            clonedBid.Phoenix_Initial_Order_Discount_of_Days__c = bid.Phoenix_Initial_Order_Discount_of_Days__c;
            clonedBid.Phoenix_Initial_Order_Discount_Type__c = bid.Phoenix_Initial_Order_Discount_Type__c;
            clonedBid.Phoenix_Is_Checklist_Exist__c = bid.Phoenix_Is_Checklist_Exist__c;
            clonedBid.Phoenix_Review_Details__c = bid.Phoenix_Review_Details__c;
            clonedBid.Phoenix_Proactive_Reactive__c = bid.Phoenix_Proactive_Reactive__c;
            clonedBid.Phoenix_Proposed_Admin_Fee_Basis__c = bid.Phoenix_Proposed_Admin_Fee_Basis__c;
            clonedBid.Phoenix_Proposed_Cash_Terms__c = bid.Phoenix_Proposed_Cash_Terms__c;
            clonedBid.Phoenix_Proposed_Value_Est_VIP__c = bid.Phoenix_Proposed_Value_Est_VIP__c;
            clonedBid.Phoenix_Proposed_Initial_Order_Discount__c = bid.Phoenix_Proposed_Initial_Order_Discount__c;
            clonedBid.Phoenix_Proposed_Position__c = bid.Phoenix_Proposed_Position__c;
            clonedBid.Phoenix_Proposed_Rebate_Basis__c = bid.Phoenix_Proposed_Rebate_Basis__c;
            clonedBid.Phoenix_Proposed_Sales_Out_Promotion__c = bid.Phoenix_Proposed_Sales_Out_Promotion__c;
            clonedBid.Phoenix_Proposed_SSA_No_of_Days__c = bid.Phoenix_Proposed_SSA_No_of_Days__c;
            clonedBid.Phoenix_Proposed_VIP_Rebate__c = bid.Phoenix_Proposed_VIP_Rebate__c;
            clonedBid.Phoenix_Sales_Out_Promotion_of_Days__c = bid.Phoenix_Sales_Out_Promotion_of_Days__c;
            clonedBid.Phoenix_Sales_Person_2__c = bid.Phoenix_Sales_Person_2__c;
            clonedBid.Phoenix_Value_Est_VIP_Type__c = bid.Phoenix_Value_Est_VIP_Type__c;
            
			
			
			  //----->
            //
            clonedBid.Phoenix_Approval_Status__c = 'Draft';
            clonedBid.Phoenix_Bid_Name__c = reBidName;
            clonedBid.Phoenix_Internal_Target_Date__c=internalTD;
            clonedBid.Phoenix_Bid_Deadline_Date__c=deadLineDate;
            clonedBid.Phoenix_Customer_Bid_Deadline_Time_zone__c=deadLineTimeZ;
            clonedBid.Phoenix_Customer_Bid_Deadline_Time__c=deadLineT;
            clonedBid.Phoenix_Bid_Type__c = bid.Phoenix_Bid_Type__c;
            clonedBid.RecordTypeId = bid.RecordTypeId;
            clonedBid.Phoenix_Customer__c = bid.Phoenix_Customer__c;
            clonedBid.Phoenix_Contact__c = bid.Phoenix_Contact__c;
            clonedBid.Phoenix_Salesperson__c = bid.Phoenix_Salesperson__c;
            //onedBid.Phoenix_Sent_to_Customer_Date__c = bid.Phoenix_Sent_to_Customer_Date__c;
            clonedBid.Phoenix_Bid_Created_Behalf_of__c = bid.Phoenix_Bid_Created_Behalf_of__c;
            clonedBid.Phoenix_Comments__c = bid.Phoenix_Comments__c;
            clonedBid.Phoenix_Is_Re_Bid__c = true;
            clonedBid.Phoenix_Proposed_Value_Admin_Fee__c = bid.Phoenix_Proposed_Value_Admin_Fee__c;
            clonedBid.Phoenix_Formal_Offer_Needed__c = bid.Phoenix_Formal_Offer_Needed__c;
            clonedBid.Phoenix_Bid_Owner__c = bid.Phoenix_Bid_Owner__c;
            clonedBid.Phoenix_Customer_Type__c = bid.Phoenix_Customer_Type__c;
            clonedBid.Phoenix_Cash_Terms_Days__c = bid.Phoenix_Cash_Terms_Days__c;
            clonedBid.Phoenix_Select_Wholesaler__c = bid.Phoenix_Select_Wholesaler__c;
            clonedBid.Phoenix_Contract_Management_Fee__c = bid.Phoenix_Contract_Management_Fee__c;
            clonedBid.Phoenix_Contract_Workflow_Type__c = bid.Phoenix_Contract_Workflow_Type__c;
            clonedBid.Phoenix_Reference_Contracts__c = bid.Phoenix_Reference_Contracts__c;
            clonedBid.Phoenix_Current_CD__c = bid.Phoenix_Current_CD__c;
            clonedBid.Phoenix_Current_Contract__c = bid.Phoenix_Current_Contract__c;
            clonedBid.Phoenix_Current_Value_Est_VIP__c = bid.Phoenix_Current_Value_Est_VIP__c;
            clonedBid.Phoenix_Current_VIP_Rebate__c = bid.Phoenix_Current_VIP_Rebate__c;
            clonedBid.Phoenix_Group_VIP__c = bid.Phoenix_Group_VIP__c;
            clonedBid.Phoenix_Initial_Order_Discount_of_Days__c = bid.Phoenix_Initial_Order_Discount_of_Days__c;
            clonedBid.Phoenix_Initial_Order_Discount_Type__c = bid.Phoenix_Initial_Order_Discount_Type__c;
            clonedBid.Phoenix_Is_Checklist_Exist__c = bid.Phoenix_Is_Checklist_Exist__c;
            clonedBid.Phoenix_Review_Details__c = bid.Phoenix_Review_Details__c;
            clonedBid.Phoenix_Proactive_Reactive__c = bid.Phoenix_Proactive_Reactive__c;
            clonedBid.Phoenix_Proposed_Admin_Fee_Basis__c = bid.Phoenix_Proposed_Admin_Fee_Basis__c;
            clonedBid.Phoenix_Proposed_Cash_Terms__c = bid.Phoenix_Proposed_Cash_Terms__c;
            clonedBid.Phoenix_Proposed_Value_Est_VIP__c = bid.Phoenix_Proposed_Value_Est_VIP__c;
            clonedBid.Phoenix_Proposed_Initial_Order_Discount__c = bid.Phoenix_Proposed_Initial_Order_Discount__c;
            clonedBid.Phoenix_Proposed_Position__c = bid.Phoenix_Proposed_Position__c;
            clonedBid.Phoenix_Proposed_Rebate_Basis__c = bid.Phoenix_Proposed_Rebate_Basis__c;
            clonedBid.Phoenix_Proposed_Sales_Out_Promotion__c = bid.Phoenix_Proposed_Sales_Out_Promotion__c;
            clonedBid.Phoenix_Proposed_SSA_No_of_Days__c = bid.Phoenix_Proposed_SSA_No_of_Days__c;
            clonedBid.Phoenix_Proposed_VIP_Rebate__c = bid.Phoenix_Proposed_VIP_Rebate__c;
            clonedBid.Phoenix_Sales_Out_Promotion_of_Days__c = bid.Phoenix_Sales_Out_Promotion_of_Days__c;
            clonedBid.Phoenix_Sales_Person_2__c = bid.Phoenix_Sales_Person_2__c;
            clonedBid.Phoenix_Value_Est_VIP_Type__c = bid.Phoenix_Value_Est_VIP_Type__c;
	    
	     //
            clonedBid.Phoenix_Approval_Status__c = 'Draft';
            clonedBid.Phoenix_Bid_Name__c = reBidName;
            clonedBid.Phoenix_Internal_Target_Date__c=internalTD;
            clonedBid.Phoenix_Bid_Deadline_Date__c=deadLineDate;
            clonedBid.Phoenix_Customer_Bid_Deadline_Time_zone__c=deadLineTimeZ;
            clonedBid.Phoenix_Customer_Bid_Deadline_Time__c=deadLineT;
            clonedBid.Phoenix_Bid_Type__c = bid.Phoenix_Bid_Type__c;
            clonedBid.RecordTypeId = bid.RecordTypeId;
            clonedBid.Phoenix_Customer__c = bid.Phoenix_Customer__c;
            clonedBid.Phoenix_Contact__c = bid.Phoenix_Contact__c;
            clonedBid.Phoenix_Salesperson__c = bid.Phoenix_Salesperson__c;
            //onedBid.Phoenix_Sent_to_Customer_Date__c = bid.Phoenix_Sent_to_Customer_Date__c;
            clonedBid.Phoenix_Bid_Created_Behalf_of__c = bid.Phoenix_Bid_Created_Behalf_of__c;
            clonedBid.Phoenix_Comments__c = bid.Phoenix_Comments__c;
            clonedBid.Phoenix_Is_Re_Bid__c = true;
            clonedBid.Phoenix_Proposed_Value_Admin_Fee__c = bid.Phoenix_Proposed_Value_Admin_Fee__c;
            clonedBid.Phoenix_Formal_Offer_Needed__c = bid.Phoenix_Formal_Offer_Needed__c;
            clonedBid.Phoenix_Bid_Owner__c = bid.Phoenix_Bid_Owner__c;
            clonedBid.Phoenix_Customer_Type__c = bid.Phoenix_Customer_Type__c;
            clonedBid.Phoenix_Cash_Terms_Days__c = bid.Phoenix_Cash_Terms_Days__c;
            clonedBid.Phoenix_Select_Wholesaler__c = bid.Phoenix_Select_Wholesaler__c;
            clonedBid.Phoenix_Contract_Management_Fee__c = bid.Phoenix_Contract_Management_Fee__c;
            clonedBid.Phoenix_Contract_Workflow_Type__c = bid.Phoenix_Contract_Workflow_Type__c;
            clonedBid.Phoenix_Reference_Contracts__c = bid.Phoenix_Reference_Contracts__c;
            clonedBid.Phoenix_Current_CD__c = bid.Phoenix_Current_CD__c;
            clonedBid.Phoenix_Current_Contract__c = bid.Phoenix_Current_Contract__c;
            clonedBid.Phoenix_Current_Value_Est_VIP__c = bid.Phoenix_Current_Value_Est_VIP__c;
            clonedBid.Phoenix_Current_VIP_Rebate__c = bid.Phoenix_Current_VIP_Rebate__c;
            clonedBid.Phoenix_Group_VIP__c = bid.Phoenix_Group_VIP__c;
            clonedBid.Phoenix_Initial_Order_Discount_of_Days__c = bid.Phoenix_Initial_Order_Discount_of_Days__c;
            clonedBid.Phoenix_Initial_Order_Discount_Type__c = bid.Phoenix_Initial_Order_Discount_Type__c;
            clonedBid.Phoenix_Is_Checklist_Exist__c = bid.Phoenix_Is_Checklist_Exist__c;
            clonedBid.Phoenix_Review_Details__c = bid.Phoenix_Review_Details__c;
            clonedBid.Phoenix_Proactive_Reactive__c = bid.Phoenix_Proactive_Reactive__c;
            clonedBid.Phoenix_Proposed_Admin_Fee_Basis__c = bid.Phoenix_Proposed_Admin_Fee_Basis__c;
            clonedBid.Phoenix_Proposed_Cash_Terms__c = bid.Phoenix_Proposed_Cash_Terms__c;
            clonedBid.Phoenix_Proposed_Value_Est_VIP__c = bid.Phoenix_Proposed_Value_Est_VIP__c;
            clonedBid.Phoenix_Proposed_Initial_Order_Discount__c = bid.Phoenix_Proposed_Initial_Order_Discount__c;
            clonedBid.Phoenix_Proposed_Position__c = bid.Phoenix_Proposed_Position__c;
            clonedBid.Phoenix_Proposed_Rebate_Basis__c = bid.Phoenix_Proposed_Rebate_Basis__c;
            clonedBid.Phoenix_Proposed_Sales_Out_Promotion__c = bid.Phoenix_Proposed_Sales_Out_Promotion__c;
            clonedBid.Phoenix_Proposed_SSA_No_of_Days__c = bid.Phoenix_Proposed_SSA_No_of_Days__c;
            clonedBid.Phoenix_Proposed_VIP_Rebate__c = bid.Phoenix_Proposed_VIP_Rebate__c;
            clonedBid.Phoenix_Sales_Out_Promotion_of_Days__c = bid.Phoenix_Sales_Out_Promotion_of_Days__c;
            clonedBid.Phoenix_Sales_Person_2__c = bid.Phoenix_Sales_Person_2__c;
            clonedBid.Phoenix_Value_Est_VIP_Type__c = bid.Phoenix_Value_Est_VIP_Type__c;
            
			
			
			
            //////////////added extra for coverage - end/////////////////
            
            insert clonedBid;

            NewBidId = clonedBid.Id;
            List < Phoenix_Bid_Line_Item__c > clonedBidLineItemsList = new List < Phoenix_Bid_Line_Item__c > ();
            List<string> lineItemIds = new List<String>();
            for (Phoenix_Bid_Line_Item__c item: selectedrows) {
                lineItemIds.add(item.Id);
                Phoenix_Bid_Line_Item__c newItem = new Phoenix_Bid_Line_Item__c();
                
                newItem.Phoenix_Bid__c = NewBidId;
                newItem.Phoenix_Previous_Bid__c = bid.Id;
                newItem.Phoenix_Is_Re_Bid_Line_Item__c = true;
                newItem.Phoenix_Previous_LineItem__c = item.Id;
                newItem.Phoenix_Product__c = item.Phoenix_Product__c;
                newItem.Phoenix_NDC__c = item.Phoenix_Product__r.Phoenix_NDC_11_Dashes__c;
                newItem.Phoenix_Product_Code1__c = item.Phoenix_Product__r.ProductCode;
                newItem.Phoenix_Pkg_Size1__c = item.Phoenix_Product__r.Phoenix_Pkg_Size__c;
                newItem.Phoenix_Case_Pack1__c = item.Phoenix_Product__r.Phoenix_Case_Pack__c;
                newItem.Phoenix_MOQ1__c = item.Phoenix_Product__r.Phoenix_Minimum_Order_Quantity__c;
                newItem.Phoenix_Product_Family1__c = item.Phoenix_Product_Family1__c;
                newItem.Product_Family__c = item.Product_Family__c;
                newItem.Phoenix_Compare_To_Brand_Name1__c = item.Phoenix_Product__r.Phoenix_Compare_to_Brand_Name__c;
                if (item.Phoenix_Product__r.Phoenix_Product_Director__c != null) 
                { 
                    newItem.Phoenix_Product_Director1__c = item.Phoenix_Product__r.Phoenix_Product_Director__r.FirstName + ' ' + item.Phoenix_Product__r.Phoenix_Product_Director__r.LastName;

                }
               newItem.Phoenix_Orange_Book_Rating1__c = item.Phoenix_Product__r.Phoenix_Orange_Book_Rating__c;
                if(item.Phoenix_Product__r.Phoenix_Throughput_cost__c !=null)
                {
             newItem.Phoenix_Throughput_Cost1__c = item.Phoenix_Product__r.Phoenix_Throughput_cost__c.setScale(2);
                }
                newItem.Phoenix_Proposed_Position__c = item.Phoenix_Proposed_Position__c;
               newItem.Phoenix_WAC1__c = item.Phoenix_Product__r.Phoenix_WAC__c;
                //newItem.Phoenix_IMS_Market_Share__c = item.Phoenix_Product__r.Phoenix_IMS_Market_Share__c;
                // newItem.Phoenix_REMS__c = item.Phoenix_REMS__c;
                newItem.Phoenix_Current_Indirect_Selling_Unit__c = item.Phoenix_Current_Indirect_Selling_Unit__c;
                //newItem.Phoenix_Doses__c = item.Phoenix_Doses__c;
                newItem.Phoenix_Proposed_Indirect_Selling_Unit__c = item.Phoenix_Proposed_Indirect_Selling_Unit__c;
                newItem.Phoenix_Current_Indirect_Price__c = item.Phoenix_Current_Indirect_Price__c;
                newItem.Phoenix_Guidance_Price__c = item.Phoenix_Guidance_Price__c;
                newItem.Phoenix_ProposedContract_Bid_Price_Sales__c = item.Phoenix_ProposedContract_Bid_Price_Sales__c;
                newItem.Phoenix_ProposedContractBidPriceMktng__c = item.Phoenix_ProposedContractBidPriceMktng__c;
                newItem.Phoenix_Customer_Dead_Net1__c = item.Phoenix_Customer_Dead_Net1__c;               
                newItem.Phoenix_Current_Rebate__c = item.Phoenix_Current_Rebate__c;
                newItem.Phoenix_Proposed_Current_Rebate__c = item.Phoenix_Proposed_Current_Rebate__c;
                newItem.Phoenix_Internal_Dead_Net_Price__c = item.Phoenix_Internal_Dead_Net_Price__c;
                
                newItem.Phoenix_12_Months_IndirectSaleUnit__c = item.Phoenix_12_Months_IndirectSaleUnit__c;                
	        newItem.Phoenix_Net_Sales_Internal__c = item.Phoenix_Net_Sales_Internal__c;
                newItem.Phoenix_Budgeted_ASP1__c = item.Phoenix_Product__r.Phoenix_Current_Budgeted_ASP__c;
                newItem.Phoenix_Lowest_Price_SKU1__c = item.Phoenix_Product__r.Phoenix_Lowest_Price_SKU__c;
                newItem.Phoenix_Approved_Lowest_Price_SKU__c = item.Phoenix_Product__r.Phoenix_Approved_Lowest_Price_SKU__c;
                newItem.Phoenix_SCM_Review__c = item.Phoenix_SCM_Review__c;
                
                //newItem.Phoenix_Approval_Grid__c = item.Phoenix_Approval_Grid__c;
                //newItem.Phoenix_Award_Position__c = item.Phoenix_Award_Position__c;
                //newItem.Phoenix_Awarded_Quantity__c = item.Phoenix_Awarded_Quantity__c;
                //newItem.Phoenix_Bid_Line_Product_Family__c = item.Phoenix_Bid_Line_Product_Family__c;
                newItem.Phoenix_Bid_Status__c = item.Phoenix_Bid_Status__c;
                //newItem.Phoenix_Budgeted_ASP_Q1_FY21__c = item.Phoenix_Budgeted_ASP_Q1_FY21__c;
                newItem.Phoenix_Cash_Terms__c = item.Phoenix_Cash_Terms__c;
                newItem.Phoenix_Comm_Exps1__c = item.Phoenix_Product__r.Phoenix_Comm_Exps__c;
                newItem.Phoenix_Contract__c = item.Phoenix_Contract__c;
                newItem.Phoenix_Contract_Mngment_Fee_Wholesaler__c = item.Phoenix_Contract_Mngment_Fee_Wholesaler__c;
                newItem.Phoenix_Current_Per_Unit_Rebate__c = item.Phoenix_Current_Per_Unit_Rebate__c;
                newItem.Phoenix_Current_Admin_Fee__c = item.Phoenix_Current_Admin_Fee__c;
                newItem.Phoenix_Current_Direct_Price__c = item.Phoenix_Current_Direct_Price__c;
                newItem.Phoenix_Current_Direct_Selling_Unit__c = item.Phoenix_Current_Direct_Selling_Unit__c;
                newItem.Phoenix_Current_Net_Sales_Internal__c = item.Phoenix_Current_Net_Sales_Internal__c;
                newItem.Phoenix_Customer__c = item.Phoenix_Customer__c;
                newItem.Phoenix_Customer_Decline_Reasons__c = item.Phoenix_Customer_Decline_Reasons__c;
                if(bid.Phoenix_Customer_Type__c == 'ROS' || bid.Phoenix_Customer__r.AccountNumber == '370337'){
                    for(Phoenix_Bid_Fee_Master__c pbf: feeListRos){
                        if(pbf.Phoenix_Fee_Type__c=='RDC/NLC %'){
                            newItem.Phoenix_RDC_NLC__c = pbf.Phoenix_Fee__c !=null ? item.Phoenix_Product__r.Phoenix_WAC__c * (pbf.Phoenix_Fee__c/100) : 0;
                            if(feeListForRos.size()!=0){
                                newItem.Phoenix_NLC__c = feeListForRos[0].Phoenix_Fee__c !=null ? item.Phoenix_Product__r.Phoenix_WAC__c * (feeListForRos[0].Phoenix_Fee__c/100) : 0;
                                newItem.Phoenix_Proposed_Current_Rebate__c = feeListForRos[0].Phoenix_Fee__c;
                            }
                        }
                    }
                }
                else{
                    newItem.Phoenix_RDC_NLC__c = item.Phoenix_RDC_NLC__c;
                    newItem.Phoenix_NLC__c = item.Phoenix_NLC__c;
                }
                newItem.Phoenix_Customer_Requested_Days__c = item.Phoenix_Customer_Requested_Days__c;
                //newItem.Phoenix_Customer_Response__c = item.Phoenix_Customer_Response__c;
                //newItem.Phoenix_Customer_Response_Line__c = item.Phoenix_Customer_Response_Line__c;  
                newItem.Phoenix_Days_Notice_Product_Discontinuat__c = item.Phoenix_Days_Notice_Product_Discontinuat__c; 
                newItem.Phoenix_Day_s_Notice_Product_removal__c = item.Phoenix_Day_s_Notice_Product_removal__c; 
                newItem.Phoenix_DeadNet_TrckGR__c = item.Phoenix_DeadNet_TrckGR__c;  
                newItem.Phoenix_Direct_Dead_Net__c = item.Phoenix_Direct_Dead_Net__c;  
                newItem.Phoenix_Direct_Order_Price1__c = item.Phoenix_Direct_Order_Price1__c;  
                newItem.Phoenix_Effective_Date__c = item.Phoenix_Effective_Date__c;  
                
                newItem.Phoenix_Estimated_Medicaid_Returns__c = item.Phoenix_Estimated_Medicaid_Returns__c;  
                newItem.Phoenix_Fee_G_N__c = item.Phoenix_Fee_G_N__c;  
                //newItem.Phoenix_Final_Approval_Approval_Grid__c = item.Phoenix_Final_Approval_Approval_Grid__c;  
                newItem.Phoenix_Final_Direct_Selling_Units_Calc__c = item.Phoenix_Final_Direct_Selling_Units_Calc__c; 
                newItem.Phoenix_Final_Indirect_Selling_Units_Cal__c = item.Phoenix_Final_Indirect_Selling_Units_Cal__c;
                newItem.Phoenix_IDN_Usage__c = item.Phoenix_IDN_Usage__c;
                //newItem.Phoenix_IMS_Market_Share__c = item.Phoenix_IMS_Market_Share__c;
                newItem.Phoenix_Indirect_CD_Per__c = item.Phoenix_Indirect_CD_Per__c;
                newItem.Phoenix_Indirect_Dead_Net__c = item.Phoenix_Indirect_Dead_Net__c;
                
                
                newItem.Phoenix_IPA_Floor_Price1__c = item.Phoenix_Product__r.Phoenix_IPA_Floor_Price__c;
                newItem.Phoenix_Latest_Estimate__c = item.Phoenix_Product__r.Phoenix_Latest_Estimate__c;
                newItem.Phoenix_Local_VIP__c = item.Phoenix_Local_VIP__c;
                newItem.Phoenix_Min_profit_share_Partner_11__c = item.Phoenix_Product__r.Phoenix_Per_Unit_Profit_Partner_1__c;
                newItem.Phoenix_Min_profit_share_Partner_21__c = item.Phoenix_Product__r.Phoenix_Per_Unit_Profit_Partner_2__c;
                newItem.Phoenix_MOQ1__c = item.Phoenix_MOQ1__c;
                newItem.Phoenix_NDC_Without_Dashes__c = item.Phoenix_Product__r.Phoenix_NDC_11__c;
                newItem.Phoenix_Net_Price_afterRebates_after_VIP__c = item.Phoenix_Net_Price_afterRebates_after_VIP__c;
                newItem.Phoenix_Net_Price_after_Rebates_Terms__c = item.Phoenix_Net_Price_after_Rebates_Terms__c;
                newItem.Phoenix_Net_Price_after_RebatesbeforeVIP__c = item.Phoenix_Net_Price_after_RebatesbeforeVIP__c;
                newItem.Phoenix_Net_Sales_External__c = item.Phoenix_Net_Sales_External__c;
                newItem.Phoenix_New_WAC__c = item.Phoenix_New_WAC__c;
                newItem.Phoenix_Price_Effective_Date__c = item.Phoenix_Price_Effective_Date__c;
                newItem.Phoenix_Pricing_Notes__c = item.Phoenix_Pricing_Notes__c;
                newItem.Phoenix_Proactive_Reactive__c = item.Phoenix_Proactive_Reactive__c;
                newItem.Phoenix_Proposed_Direct_Selling_Unit__c = item.Phoenix_Proposed_Direct_Selling_Unit__c;
                newItem.Phoenix_Proposed_IPA_Price__c = item.Phoenix_Proposed_IPA_Price__c;
                newItem.Proposed_Net_Sales_Direct__c = item.Proposed_Net_Sales_Direct__c;
                newItem.Proposed_Net_Sales_Indirect__c = item.Proposed_Net_Sales_Indirect__c;
                newItem.Phoenix_Proposed_Per_Unit_Rebate__c = item.Phoenix_Proposed_Per_Unit_Rebate__c;
                newItem.Proposed_TPT_Direct__c = item.Proposed_TPT_Direct__c;
                newItem.Proposed_TPT_Indirect__c = item.Proposed_TPT_Indirect__c;
                newItem.Proposed_TPT_Per_Direct__c = item.Proposed_TPT_Per_Direct__c;
                newItem.Proposed_TPT_Per_Indirect__c = item.Proposed_TPT_Per_Indirect__c;
                newItem.Phoenix_PS_Partner_1percent__c = item.Phoenix_Product__r.Phoenix_PS_Partner_1__c;
                newItem.Phoenix_PS_Partner_2percent__c = item.Phoenix_Product__r.Phoenix_PS_Partner_2__c;
                newItem.Current_CVS_Indirect_DeadNet__c = newItem.Current_CVS_Indirect_DeadNet__c;//added by srimayee for indirect template

                /* added extra for coverage - start 
newItem.Phoenix_Orange_Book_Rating1__c = item.Phoenix_Product__r.Phoenix_Orange_Book_Rating__c;
newItem.Phoenix_Throughput_Cost1__c = item.Phoenix_Product__r.Phoenix_Throughput_cost__c;
newItem.Phoenix_WAC1__c = item.Phoenix_Product__r.Phoenix_WAC__c;
newItem.Phoenix_IMS_Market_Share__c = item.Phoenix_Product__r.Phoenix_IMS_Market_Share__c;
                // newItem.Phoenix_REMS__c = item.Phoenix_REMS__c;
newItem.Phoenix_Current_Indirect_Selling_Unit__c = item.Phoenix_Current_Indirect_Selling_Unit__c;
                //newItem.Phoenix_Doses__c = item.Phoenix_Doses__c;
newItem.Phoenix_Proposed_Indirect_Selling_Unit__c = item.Phoenix_Proposed_Indirect_Selling_Unit__c;
newItem.Phoenix_Current_Indirect_Price__c = item.Phoenix_Current_Indirect_Price__c;
newItem.Phoenix_Guidance_Price__c = item.Phoenix_Guidance_Price__c;
newItem.Phoenix_ProposedContract_Bid_Price_Sales__c = item.Phoenix_ProposedContract_Bid_Price_Sales__c;
                newItem.Phoenix_ProposedContractBidPriceMktng__c = item.Phoenix_ProposedContractBidPriceMktng__c;
                newItem.Phoenix_Customer_Dead_Net1__c = item.Phoenix_Customer_Dead_Net1__c;
                newItem.Phoenix_Current_Rebate__c = item.Phoenix_Current_Rebate__c;
                newItem.Phoenix_Proposed_Current_Rebate__c = item.Phoenix_Proposed_Current_Rebate__c;
                newItem.Phoenix_Internal_Dead_Net_Price__c = item.Phoenix_Internal_Dead_Net_Price__c;

                newItem.Phoenix_Net_Sales_Internal__c = item.Phoenix_Net_Sales_Internal__c;
                newItem.Phoenix_Budgeted_ASP1__c = item.Phoenix_Product__r.Phoenix_Current_Budgeted_ASP__c;
                newItem.Phoenix_Lowest_Price_SKU1__c = item.Phoenix_Product__r.Phoenix_Lowest_Price_SKU__c;

                newItem.Phoenix_SCM_Review__c = item.Phoenix_SCM_Review__c;

                //newItem.Phoenix_Approval_Grid__c = item.Phoenix_Approval_Grid__c;
                //newItem.Phoenix_Award_Position__c = item.Phoenix_Award_Position__c;
                //newItem.Phoenix_Awarded_Quantity__c = item.Phoenix_Awarded_Quantity__c;
                //newItem.Phoenix_Bid_Line_Product_Family__c = item.Phoenix_Bid_Line_Product_Family__c;
                newItem.Phoenix_Bid_Status__c = item.Phoenix_Bid_Status__c;
                //newItem.Phoenix_Budgeted_ASP_Q1_FY21__c = item.Phoenix_Budgeted_ASP_Q1_FY21__c;
                newItem.Phoenix_Cash_Terms__c = item.Phoenix_Cash_Terms__c;
                newItem.Phoenix_Comm_Exps1__c = item.Phoenix_Product__r.Phoenix_Comm_Exps__c;
                newItem.Phoenix_Contract__c = item.Phoenix_Contract__c;
                newItem.Phoenix_Contract_Mngment_Fee_Wholesaler__c = item.Phoenix_Contract_Mngment_Fee_Wholesaler__c;
                newItem.Phoenix_Current_Net_Indirect_Price__c = item.Phoenix_Current_Net_Indirect_Price__c;
                newItem.Phoenix_Current_Per_Unit_Rebate__c = item.Phoenix_Current_Per_Unit_Rebate__c;
                newItem.Phoenix_Current_Admin_Fee__c = item.Phoenix_Current_Admin_Fee__c;
                newItem.Phoenix_Current_Direct_Price__c = item.Phoenix_Current_Direct_Price__c;
                newItem.Phoenix_Current_Direct_Selling_Unit__c = item.Phoenix_Current_Direct_Selling_Unit__c;
                newItem.Phoenix_Current_Net_Sales_Internal__c = item.Phoenix_Current_Net_Sales_Internal__c;
                newItem.Phoenix_Customer__c = item.Phoenix_Customer__c;
                newItem.Phoenix_Customer_Decline_Reasons__c = item.Phoenix_Customer_Decline_Reasons__c;
                newItem.Phoenix_RDC_NLC__c = item.Phoenix_RDC_NLC__c;
                newItem.Phoenix_Customer_Requested_Days__c = item.Phoenix_Customer_Requested_Days__c;
                //newItem.Phoenix_Customer_Response__c = item.Phoenix_Customer_Response__c;
                //newItem.Phoenix_Customer_Response_Line__c = item.Phoenix_Customer_Response_Line__c;  
                newItem.Phoenix_Days_Notice_Product_Discontinuat__c = item.Phoenix_Days_Notice_Product_Discontinuat__c;
                newItem.Phoenix_Day_s_Notice_Product_removal__c = item.Phoenix_Day_s_Notice_Product_removal__c;
                newItem.Phoenix_DeadNet_TrckGR__c = item.Phoenix_DeadNet_TrckGR__c;
                newItem.Phoenix_Direct_Dead_Net__c = item.Phoenix_Direct_Dead_Net__c;
                newItem.Phoenix_Direct_Order_Price1__c = item.Phoenix_Direct_Order_Price1__c;
                newItem.Phoenix_Effective_Date__c = item.Phoenix_Effective_Date__c;

                newItem.Phoenix_Estimated_Medicaid_Returns__c = item.Phoenix_Estimated_Medicaid_Returns__c;
                newItem.Phoenix_Fee_G_N__c = item.Phoenix_Fee_G_N__c;
                //newItem.Phoenix_Final_Approval_Approval_Grid__c = item.Phoenix_Final_Approval_Approval_Grid__c;  
                newItem.Phoenix_Final_Direct_Selling_Units_Calc__c = item.Phoenix_Final_Direct_Selling_Units_Calc__c;
                newItem.Phoenix_Final_Indirect_Selling_Units_Cal__c = item.Phoenix_Final_Indirect_Selling_Units_Cal__c;
                newItem.Phoenix_IDN_Usage__c = item.Phoenix_IDN_Usage__c;
                //newItem.Phoenix_IMS_Market_Share__c = item.Phoenix_IMS_Market_Share__c;
                newItem.Phoenix_Indirect_CD_Per__c = item.Phoenix_Indirect_CD_Per__c;
                newItem.Phoenix_Indirect_Dead_Net__c = item.Phoenix_Indirect_Dead_Net__c;

                
                
                newItem.Phoenix_IPA_Floor_Price1__c = item.Phoenix_Product__r.Phoenix_IPA_Floor_Price__c;
                newItem.Phoenix_Latest_Estimate__c = item.Phoenix_Product__r.Phoenix_Latest_Estimate__c;
                newItem.Phoenix_Local_VIP__c = item.Phoenix_Local_VIP__c;
                newItem.Phoenix_Min_profit_share_Partner_11__c = item.Phoenix_Product__r.Phoenix_Per_Unit_Profit_Partner_1__c;
                newItem.Phoenix_Min_profit_share_Partner_21__c = item.Phoenix_Product__r.Phoenix_Per_Unit_Profit_Partner_2__c;
                newItem.Phoenix_MOQ1__c = item.Phoenix_MOQ1__c;
                newItem.Phoenix_NDC_Without_Dashes__c = item.Phoenix_Product__r.Phoenix_NDC_11__c;
                newItem.Phoenix_Net_Price_afterRebates_after_VIP__c = item.Phoenix_Net_Price_afterRebates_after_VIP__c;
                newItem.Phoenix_Net_Price_after_Rebates_Terms__c = item.Phoenix_Net_Price_after_Rebates_Terms__c;
                newItem.Phoenix_Net_Price_after_RebatesbeforeVIP__c = item.Phoenix_Net_Price_after_RebatesbeforeVIP__c;
                newItem.Phoenix_Net_Sales_External__c = item.Phoenix_Net_Sales_External__c;
                newItem.Phoenix_New_WAC__c = item.Phoenix_New_WAC__c;
                newItem.Phoenix_Price_Effective_Date__c = item.Phoenix_Price_Effective_Date__c;
                newItem.Phoenix_Pricing_Notes__c = item.Phoenix_Pricing_Notes__c;
                newItem.Phoenix_Proactive_Reactive__c = item.Phoenix_Proactive_Reactive__c;
                newItem.Phoenix_Proposed_Direct_Selling_Unit__c = item.Phoenix_Proposed_Direct_Selling_Unit__c;
                newItem.Phoenix_Proposed_IPA_Price__c = item.Phoenix_Proposed_IPA_Price__c;
                newItem.Proposed_Net_Sales_Direct__c = item.Proposed_Net_Sales_Direct__c;
                newItem.Proposed_Net_Sales_Indirect__c = item.Proposed_Net_Sales_Indirect__c;
                newItem.Phoenix_Proposed_Per_Unit_Rebate__c = item.Phoenix_Proposed_Per_Unit_Rebate__c;
                newItem.Proposed_TPT_Direct__c = item.Proposed_TPT_Direct__c;
                newItem.Proposed_TPT_Indirect__c = item.Proposed_TPT_Indirect__c;
                newItem.Proposed_TPT_Per_Direct__c = item.Proposed_TPT_Per_Direct__c;
                newItem.Proposed_TPT_Per_Indirect__c = item.Proposed_TPT_Per_Indirect__c;
                newItem.Phoenix_PS_Partner_1percent__c = item.Phoenix_Product__r.Phoenix_PS_Partner_1__c;
                newItem.Phoenix_PS_Partner_2percent__c = item.Phoenix_Product__r.Phoenix_PS_Partner_2__c;

							added extra for coverage - end  */
                
                
                if (item.Phoenix_Product__r.Phoenix_PS_Partner_1_Name__r.Name != null) {
                    newItem.Phoenix_PS_Partner_11__c = item.Phoenix_Product__r.Phoenix_PS_Partner_1_Name__r.Name;
                }
                if (item.Phoenix_Product__r.Phoenix_PS_Partner_2_Name__r.Name != null) {
                    newItem.Phoenix_PS_Partner_21__c = item.Phoenix_Product__r.Phoenix_PS_Partner_2_Name__r.Name;
                }
                newItem.Phoenix_Rebate_G_N__c = item.Phoenix_Rebate_G_N__c;
                newItem.Phoenix_REMS__c = item.Phoenix_Product__r.Phoenix_REMS__c;
                newItem.Phoenix_Retail_Indirect_Wholesaler_Fee__c = item.Phoenix_Retail_Indirect_Wholesaler_Fee__c;
                newItem.Phoenix_Revisited_Date__c = item.Phoenix_Revisited_Date__c;
                newItem.Phoenix_Royaltypercent__c = item.Phoenix_Product__r.Phoenix_Royalty__c;
                
               

                if (item.Phoenix_Product__r.Phoenix_Royalty_Partner_Name__r.Name != null) {
                    newItem.Phoenix_Royalty_Partner_Name1__c = item.Phoenix_Product__r.Phoenix_Royalty_Partner_Name__r.Name;
                }
                //newItem.Phoenix_Sales_Notes__c	 = item.Phoenix_Sales_Notes__c	;

                newItem.Phoenix_SCM_Qty_Approved_Direct__c = item.Phoenix_SCM_Qty_Approved_Direct__c;
                newItem.Phoenix_SCM_Qty_Approved_Indirect__c = item.Phoenix_SCM_Qty_Approved_Indirect__c;
                newItem.Phoenix_Supply_Effective_Date__c = item.Phoenix_Supply_Effective_Date__c;
                newItem.Phoenix_UPC_Universal_Product_Code__c = item.Phoenix_Product__r.Phoenix_UPC_Universal_Product_Code__c;
                newItem.Phoenix_Wholesaler_Diff_Price_Indirect__c = item.Phoenix_Wholesaler_Diff_Price_Indirect__c;
                //newItem.Phoenix_Wholesaler_Indirect_Units__c = item.Phoenix_Wholesaler_Indirect_Units__c;
                newItem.Phoenix_Wholesaler_Price_Percent__c = item.Phoenix_Wholesaler_Price_Percent__c;
                newItem.Phoenix_ZITD_Value__c = item.Phoenix_ZITD_Value__c;
                newItem.Phoenix_12_Months_Actual_Sales__c = item.Phoenix_12_Months_Actual_Sales__c;
                newItem.Phoenix_Override_Current_Units__c = item.Phoenix_Override_Current_Units__c;
                newItem.Phoenix_Current_Position__c = item.Phoenix_Current_Position__c;
                newItem.Phoenix_Direct_ESI__c = item.Phoenix_Direct_ESI__c;
                newItem.Phoenix_Indirect_ESI__c = item.Phoenix_Indirect_ESI__c;
                newItem.Phoenix_Direct_Kroger__c = item.Phoenix_Direct_Kroger__c;
                newItem.Phoenix_Indirect_Kroger__c = item.Phoenix_Indirect_Kroger__c;
                newItem.Phoenix_Direct_Rx_Outreach__c = item.Phoenix_Direct_Rx_Outreach__c;
                newItem.Phoenix_Indirect_Rx_Outreach__c = item.Phoenix_Indirect_Rx_Outreach__c;
                newItem.Phoenix_Direct_Supervalu__c = item.Phoenix_Direct_Supervalu__c;
                newItem.Phoenix_Indirect_Supervalu__c = item.Phoenix_Indirect_Supervalu__c;
                newItem.Phoenix_Direct_Cigna__c = item.Phoenix_Direct_Cigna__c;
                newItem.Phoenix_Indirect_Cigna__c = item.Phoenix_Indirect_Cigna__c;
                newItem.Phoenix_Direct_Cordant__c = item.Phoenix_Direct_Cordant__c;
                newItem.Phoenix_Indirect_Cordant__c = item.Phoenix_Indirect_Cordant__c;
                newItem.Phoenix_Direct_Accerodo__c = item.Phoenix_Direct_Accerodo__c;
                newItem.Phoenix_Indirect_Accerodo__c = item.Phoenix_Indirect_Accerodo__c;
                newItem.Phoenix_Others_Direct__c = item.Phoenix_Others_Direct__c;
                newItem.Phoenix_Others_Indirect__c = item.Phoenix_Others_Indirect__c;
                newItem.Phoenix_12_Months_TotalSaleUnits__c = item.Phoenix_12_Months_TotalSaleUnits__c;
                
                newItem.Phoenix_Current_Wholesaler_Units__c = item.Phoenix_Current_Wholesaler_Units__c;
                newItem.Phoenix_Current_Anda_Units__c = item.Phoenix_Current_Anda_Units__c;
                newItem.Phoenix_Current_Retail_Direct_Units__c = item.Phoenix_Current_Retail_Direct_Units__c;
                newItem.Phoenix_Current_Anda_Net_Model_Units__c = item.Phoenix_Current_Anda_Net_Model_Units__c;
                newItem.Phoenix_Current_Retail_Indirect_Units__c = item.Phoenix_Current_Retail_Indirect_Units__c;
                newItem.Phoenix_Current_Indirect_Gaint_EagleUnit__c = item.Phoenix_Current_Indirect_Gaint_EagleUnit__c;
                //newItem.Phoenix_Total_Selling_Unit__c	= item.Phoenix_Total_Selling_Unit__c;
                newItem.Phoenix_Proposed_Anda_Units__c = item.Phoenix_Proposed_Anda_Units__c;
                newItem.Phoenix_Proposed_Smith_Drug_Units__c = item.Phoenix_Proposed_Smith_Drug_Units__c;
                newItem.Phoenix_ProposedDirectAholdDelhaizeUnits__c = item.Phoenix_ProposedDirectAholdDelhaizeUnits__c;
                newItem.Phoenix_ProposedDirectGaintEagleUnits__c = item.Phoenix_ProposedDirectGaintEagleUnits__c;
                newItem.Phoenix_ProposedIndirectAholdDelhaizeUni__c = item.Phoenix_ProposedIndirectAholdDelhaizeUni__c;
                newItem.Phoenix_Proposed_IndirectGaintEagleUnits__c = item.Phoenix_Proposed_IndirectGaintEagleUnits__c;
                newItem.Phoenix_Current_Retail_Direct_Price__c = item.Phoenix_Current_Retail_Direct_Price__c;
                newItem.Phoenix_Current_Retail_Indirect_Net__c = item.Phoenix_Current_Retail_Indirect_Net__c;
                newItem.Phoenix_Current_Retail_Indirect_Price__c = item.Phoenix_Current_Retail_Indirect_Price__c;
                newItem.Phoenix_Current_Wholesaler_Price__c = item.Phoenix_Current_Wholesaler_Price__c;
                newItem.Phoenix_Current_Anda_Invoice_Price__c = item.Phoenix_Current_Anda_Invoice_Price__c;
                newItem.Phoenix_Current_Anda_CP_Price__c = item.Phoenix_Current_Anda_CP_Price__c;
                newItem.Phoenix_Current_Anda_Acquisition_Costs__c = item.Phoenix_Current_Anda_Acquisition_Costs__c;
                newItem.Phoenix_Retail_Direct_Guidance_Price__c = item.Phoenix_Retail_Direct_Guidance_Price__c;
                newItem.Phoenix_Wholesaler_Guidance_Price__c = item.Phoenix_Wholesaler_Guidance_Price__c;
                newItem.Phoenix_Retail_Direct_Sales_Price__c = item.Phoenix_Retail_Direct_Sales_Price__c;
                  newItem.Phoenix_WMT_Indirect_Current_Sales__c = item.Phoenix_WMT_Indirect_Current_Sales__c;
                newItem.Phoenix_Wholesaler_Sales_Price__c = item.Phoenix_Wholesaler_Sales_Price__c;
                newItem.Phoenix_Reduction__c = item.Phoenix_Reduction__c;
                newItem.Phoenix_Retail_Direct_Price__c = item.Phoenix_Retail_Direct_Price__c;
                newItem.Phoenix_Retail_Indirect_Net__c = item.Phoenix_Retail_Indirect_Net__c;
                newItem.Phoenix_Retail_Indirect_Price__c = item.Phoenix_Retail_Indirect_Price__c;
                newItem.Phoenix_Wholesaler_Price_RxSS__c = item.Phoenix_Wholesaler_Price_RxSS__c;
                newItem.Phoenix_Cash_Terms_RxSS__c = item.Phoenix_Cash_Terms_RxSS__c;
                newItem.Phoenix_Charge_Back__c = item.Phoenix_Charge_Back__c;
                newItem.Phoenix_Anda_New_Model_Acqusition_Costs__c = item.Phoenix_Anda_New_Model_Acqusition_Costs__c;
                newItem.Phoenix_Direct_CD__c = item.Phoenix_Direct_CD__c;
                newItem.Phoenix_Retail_Direct_Admin_Fee__c = item.Phoenix_Retail_Direct_Admin_Fee__c;
                newItem.Phoenix_Retail_Direct_VIP__c = item.Phoenix_Retail_Direct_VIP__c;
                newItem.Phoenix_Retail_Indirect_ZITD__c = item.Phoenix_Retail_Indirect_ZITD__c;
                newItem.Phoenix_Retail_Indirect_Admin_Fees__c = item.Phoenix_Retail_Indirect_Admin_Fees__c;
                newItem.Phoenix_Retail_Indirect_VIP__c = item.Phoenix_Retail_Indirect_VIP__c;
                newItem.Phoenix_Retail_Indirect_WAC_NLC_Fee__c = item.Phoenix_Retail_Indirect_WAC_NLC_Fee__c;
                newItem.Phoenix_Retail_Indirect_WholesalerFeeRxS__c = item.Phoenix_Retail_Indirect_WholesalerFeeRxS__c;
                newItem.Phoenix_Anda_Admin_Fees__c = item.Phoenix_Anda_Admin_Fees__c;
                newItem.Phoenix_Anda_VIP__c = item.Phoenix_Anda_VIP__c;
                //newItem.Phoenix_INDIRECT_CD__c	= item.Phoenix_INDIRECT_CD__c;
                newItem.Phoenix_Wholesaler_Admin_Fee__c = item.Phoenix_Wholesaler_Admin_Fee__c;
                newItem.Phoenix_Wholesaler_VIP__c = item.Phoenix_Wholesaler_VIP__c;
                newItem.Phoenix_Retail_Customer_Net_Price__c = item.Phoenix_Retail_Customer_Net_Price__c;
                newItem.Phoenix_Wholesaler_Customer_Net_Price__c = item.Phoenix_Wholesaler_Customer_Net_Price__c;
                newItem.Phoenix_Wholesaler_DRL_Net_Price__c = item.Phoenix_Wholesaler_DRL_Net_Price__c;
                newItem.Phoenix_Anda_DRL_Net_price__c = item.Phoenix_Anda_DRL_Net_price__c;
                newItem.Phoenix_Retail_Direct_DRL_TPT__c = item.Phoenix_Retail_Direct_DRL_TPT__c;
                newItem.Phoenix_Retail_Indirect_DRL_TPT__c = item.Phoenix_Retail_Indirect_DRL_TPT__c;
                newItem.Phoenix_Wholesaler_DRL_TPT__c = item.Phoenix_Wholesaler_DRL_TPT__c;
                newItem.Phoenix_Anda_DRL_TPT__c = item.Phoenix_Anda_DRL_TPT__c;
                newItem.Phoenix_Retail_Direct_DRL_TPT_Percent__c = item.Phoenix_Retail_Direct_DRL_TPT_Percent__c;
                newItem.Phoenix_Retail_Indirect_DRL_TPT_Percent__c = item.Phoenix_Retail_Indirect_DRL_TPT_Percent__c;
                newItem.Phoenix_Wholesaler_DRL_TPT_Percent__c = item.Phoenix_Wholesaler_DRL_TPT_Percent__c;
                newItem.Phoenix_Anda_DRL_TPT_Percent__c = item.Phoenix_Anda_DRL_TPT_Percent__c;
                newItem.Phoenix_Retail_IOD_per_unit__c = item.Phoenix_Retail_IOD_per_unit__c;
                newItem.Phoenix_ANDA_IOD_Per_unit__c = item.Phoenix_ANDA_IOD_Per_unit__c;
                newItem.Phoenix_Wholesaler_IOD_per_unit__c = item.Phoenix_Wholesaler_IOD_per_unit__c;
                newItem.Phoenix_Retail_IOD_overall_amount__c = item.Phoenix_Retail_IOD_overall_amount__c;
                newItem.Phoenix_ANDA_IOD_Overall_Amount__c = item.Phoenix_ANDA_IOD_Overall_Amount__c;
                newItem.Phoenix_Wholesaler_IOD_overall_amount__c = item.Phoenix_Wholesaler_IOD_overall_amount__c;
                newItem.Phoenix_IOD_Total_Amount__c = item.Phoenix_IOD_Total_Amount__c;
                newItem.Phoenix_Retail_Direct_Net_sales__c = item.Phoenix_Retail_Direct_Net_sales__c;
                newItem.Phoenix_Retail_Indirect_Net_Sales__c = item.Phoenix_Retail_Indirect_Net_Sales__c;
                newItem.Phoenix_Anda_Net_Model_Sales__c = item.Phoenix_Anda_Net_Model_Sales__c;
                newItem.Phoenix_Wholesaler_Net_Sales__c = item.Phoenix_Wholesaler_Net_Sales__c;
                newItem.Phoenix_Override_Current_Direct_Units__c = item.Phoenix_Override_Current_Direct_Units__c;
                newItem.Phoenix_Override_Current_Indirect_Units__c = item.Phoenix_Override_Current_Indirect_Units__c;
                //Added by satya
                 newItem.Phoenix_Costco_TPT__c	= item.Phoenix_Costco_TPT__c;
                newItem.Phoenix_Costco_TPTPer__c	= item.Phoenix_Costco_TPTPer__c;
                newItem.Phoenix_Contract_Mngmnt_Fee_Wholesaler__c = item.Phoenix_Contract_Mngmnt_Fee_Wholesaler__c;
                  newItem.Phoenix_WMT_CD_WMT_Direct__c = item.Phoenix_WMT_CD_WMT_Direct__c;
                
                /*--- ClarusOne Fields --*/
                newItem.Phoenix_OS_RAD_CP__c = item.Phoenix_OS_RAD_CP__c;
                newItem.Phoenix_WMT_Direct_CP__c = item.Phoenix_WMT_Direct_CP__c;
                newItem.Phoenix_WMT_Indirect_CP__c = item.Phoenix_WMT_Indirect_CP__c;
                newItem.Phoenix_OS_RAD_PUR__c = item.Phoenix_OS_RAD_PUR__c;
                newItem.Phoenix_WMT_Direct_PUR__c = item.Phoenix_WMT_Direct_PUR__c;
                newItem.Phoenix_WMT_Indirect_PUR__c = item.Phoenix_WMT_Indirect_PUR__c;
                newItem.Phoenix_OS_RAD_NCP__c = item.Phoenix_OS_RAD_NCP__c;
                newItem.Phoenix_WMT_Direct_NCP__c = item.Phoenix_WMT_Direct_NCP__c;
                newItem.Phoenix_WMT_Indirect_NCP__c = item.Phoenix_WMT_Indirect_NCP__c;
                newItem.Phoenix_Current_McK_RAD_Dead_net__c = item.Phoenix_Current_McK_RAD_Dead_net__c;
                newItem.Phoenix_Current_WMT_Direct_Dead_net__c = item.Phoenix_Current_WMT_Direct_Dead_net__c;
                newItem.Phoenix_Current_WMT_Indirect_Dead_net__c = item.Phoenix_Current_WMT_Indirect_Dead_net__c;
                newItem.Phoenix_OS_and_RAD_Cur_Direct_Units_C__c = item.Phoenix_OS_and_RAD_Cur_Direct_Units_C__c;
                newItem.Phoenix_WMT_Current_Direct_Units__c = item.Phoenix_WMT_Current_Direct_Units__c;
                newItem.Phoenix_WMT_Current_Indirect_Units__c = item.Phoenix_WMT_Current_Indirect_Units__c;
                newItem.Phoenix_Proposed_OS_Units__c = item.Phoenix_Proposed_OS_Units__c;
                newItem.Phoenix_Proposed_RAD_Units__c = item.Phoenix_Proposed_RAD_Units__c;
                newItem.Phoenix_Proposed_WMT_Units__c = item.Phoenix_Proposed_WMT_Units__c;
                newItem.Phoenix_Proposed_WMT_Direct_NCP__c = item.Phoenix_Proposed_WMT_Direct_NCP__c;
                newItem.Phoenix_Proposed_WMT_Indirect_NCP__c = item.Phoenix_Proposed_WMT_Indirect_NCP__c;
                newItem.Phoenix_Proposed_McK_OS_And_RAD_NCP__c = item.Phoenix_Proposed_McK_OS_And_RAD_NCP__c;
                newItem.Phoenix_Sales_Proposed_NCP_McK_And_RAD__c = item.Phoenix_Sales_Proposed_NCP_McK_And_RAD__c;
                newItem.Phoenix_Reduc_in_NCP_McK_And_RAD__c = item.Phoenix_Reduc_in_NCP_McK_And_RAD__c;
                newItem.Phoenix_Reduction_in_NCP_WMT__c = item.Phoenix_Reduction_in_NCP_WMT__c;
                newItem.Phoenix_Anda_Old_Acqusition_Costs__c = item.Phoenix_Anda_Old_Acqusition_Costs__c;
                newItem.Phoenix_Admin_Fee_WMT_Direct_NCP__c = item.Phoenix_Admin_Fee_WMT_Direct_NCP__c;
                newItem.Phoenix_WMT_Direct_Dead_Net_Proposed__c = item.Phoenix_WMT_Direct_Dead_Net_Proposed__c;
                newItem.Phoenix_RDC_WMT_Indirect__c = item.Phoenix_RDC_WMT_Indirect__c;
                newItem.Phoenix_CM_Fee_WMT_Indirect__c = item.Phoenix_CM_Fee_WMT_Indirect__c;
                newItem.Phoenix_Stocking_Allowance_Per_Unit__c = item.Phoenix_Stocking_Allowance_Per_Unit__c;
                newItem.Phoenix_WMT_Stck_Allowance_Overall_Amnt__c = item.Phoenix_WMT_Stck_Allowance_Overall_Amnt__c;
                newItem.Phoenix_WMT_Indirect_Net_Sales__c = item.Phoenix_WMT_Indirect_Net_Sales__c;
                newItem.Phoenix_WMT_Indirect_Net_Sales__c = item.Phoenix_WMT_Indirect_TPT__c;
                newItem.Phoenix_Current_Supplier__c = item.Phoenix_Current_Supplier__c;
                 newItem.Brand_WAC__c = item.Brand_WAC__c;
                 newItem.Phoenix_Brand_WAC_Per__c = item.Phoenix_Brand_WAC_Per__c;
                 newItem.Phoenix_Opening_Order__c = item.Phoenix_Opening_Order__c;
                 newItem.Phoenix_Opening_Order_Net_sales__c = item.Phoenix_Opening_Order_Net_sales__c;
                   newItem.Phoenix_Opening_Order_TPT__c = item.Phoenix_Opening_Order_TPT__c;
                  newItem.Phoenix_Opening_Order_TPT_Per__c = item.Phoenix_Opening_Order_TPT_Per__c;
                   newItem.Phoenix_Override_Total_units__c = item.Phoenix_Override_Total_units__c;
                  newItem.Phoenix_Current_WMT_Position__c = item.Phoenix_Current_WMT_Position__c;
                newItem.Phoenix_Current_MCK_Position__c = item.Phoenix_Current_MCK_Position__c;


                

                if (item.Phoenix_SCM_Review__c == false) {
                    newItem.Phoenix_SCM_Approved_Quantity__c = item.Phoenix_SCM_Approved_Quantity__c;
                    newItem.Phoenix_SCM_Approval_Y_N__c = item.Phoenix_SCM_Approval_Y_N__c;
                    //newItem.Phoenix_SCM_Final_Approval__c = item.Phoenix_SCM_Final_Approval__c;
                    newItem.Phoenix_Qty_Approved_By_SCM__c = item.Phoenix_Qty_Approved_By_SCM__c;
                    newItem.Phoenix_Estimated_Lead_Time_Days__c = item.Phoenix_Estimated_Lead_Time_Days__c;
                    newItem.Phoenix_Initial_Stocking_Order_Volume__c = item.Phoenix_Initial_Stocking_Order_Volume__c;
                    newItem.Phoenix_Initial_Stocking_Order_Comments__c = item.Phoenix_Initial_Stocking_Order_Comments__c;
                    //newItem.Phoenix_SCM_Rejection_Reason1__c = item.Phoenix_SCM_Rejection_Reason1__c;
                }
                
                
                


                clonedBidLineItemsList.add(newItem);
                
            }
            
            //system.debug('bid.Phoenix_Customer_Type__c ::: ---> '+bid.Phoenix_Customer_Type__c);
            
            Map <Id, Phoenix_BidLineItemExtn__c> bliExtnMap = new Map<Id, Phoenix_BidLineItemExtn__c>();
            if(bid.Phoenix_Customer_Type__c == 'ROS'){
                String query = '';
                String SobjectApiName = 'Phoenix_BidLineItemExtn__c';
                Map < String, Schema.SObjectType > schemaMap = Schema.getGlobalDescribe();
                Map < String, Schema.SObjectField > fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();
                List<String> strFields = new List<String>();
                for (String fieldName: fieldMap.keyset()) {
                    strFields.add(fieldName);
                }
                query = 'SELECT '+String.join(strFields,' , ')+' FROM '+SobjectApiName+' WHERE Phoenix_Bid_Line_Item__c IN: lineItemIds';
                List< Phoenix_BidLineItemExtn__c> oldExtnRecList = Database.query(query);
                //system.debug('oldExtnRecList ::: ---> '+oldExtnRecList.size());
                for(Phoenix_BidLineItemExtn__c obj : oldExtnRecList){
                    bliExtnMap.put(obj.Phoenix_Bid_Line_Item__c, obj);
                }
            }
            List<Phoenix_BidLineItemExtn__c> cloneExtnRecList = new List<Phoenix_BidLineItemExtn__c>();
            //system.debug('clonedBidLineItemsList ::: ---> '+clonedBidLineItemsList.size());
            if (!clonedBidLineItemsList.isEmpty()) {
                insert clonedBidLineItemsList;
                
                if(bid.Phoenix_Customer_Type__c == 'ROS'){
                    for(Phoenix_Bid_Line_Item__c newObj : clonedBidLineItemsList){
                        //system.debug('INSIDE ROS');
                        Phoenix_BidLineItemExtn__c oldExtnObj = new Phoenix_BidLineItemExtn__c();
                        oldExtnObj = bliExtnMap.get(newObj.Phoenix_Previous_LineItem__c);
                        Phoenix_BidLineItemExtn__c clonedExtnObj = oldExtnObj.clone();//false,True,false,false); 
                        clonedExtnObj.Phoenix_Bid_Line_Item__c = newObj.Id;
                        cloneExtnRecList.add(clonedExtnObj);
                    }
                }
                //system.debug('cloneExtnRecList ::: ---> '+cloneExtnRecList.size());
                insert cloneExtnRecList;
                //response = 'Success';
            }
            resResult.add(isError);
            resResult.add(NewBidId);
            //return resResult;

        }
        Catch(Exception e) {
            isError = 'true';
            resResult.add(isError);
            resResult.add('' + e.getMessage()+ ' '+e.getLineNumber());
            Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'BidCloneExt', Phoenix_Method_Name__c = 'processRebid', Phoenix_Error_Message__c = e.getMessage(), Phoenix_Issue_Status__c = 'Pending', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
            insert exp;
        }

        return resResult;

    }

}