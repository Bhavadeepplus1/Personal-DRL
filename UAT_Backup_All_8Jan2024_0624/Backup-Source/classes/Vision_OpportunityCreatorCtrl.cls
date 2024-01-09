public class Vision_OpportunityCreatorCtrl {
    public static Opportunity oppty;
    public static BidWrapper wrapper;
    
    static {
        oppty = new Opportunity();
        wrapper = new BidWrapper();
    }
    
    @AuraEnabled
    public static BidWrapper getbidInfo(String recordId) {
        BidWrapper wrapperCls = new BidWrapper();
        String query = 'SELECT '+Phoenix_Util.getsObjectFieds('Opportunity')+' FROM Opportunity WHERE Id=: recordId';
        if (recordId != null)
            wrapperCls.oppty = Database.query(query);
        return wrapperCls;
    }
    @AuraEnabled
    public static List < string > getProductDirectorList(BidWrapper bidwrap) {
        Opportunity oppty = bidwrap.oppty;
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
        query = 'select Phoenix_Product_Director__r.Name,' + strFields + ' from Product2 where (IsActive = true AND Phoenix_Is_Exclude_Bid__c=false) ORDER BY Name ASC NULLS LAST LIMIT 30000';
        
        list < Product2 > quoteList = Database.query(query);
        
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
        
        Opportunity oppty = quotewrap.oppty;
        
        List < wrapperClass > wrlist = new List < wrapperClass > ();
        String query = '';
        String SobjectApiName = 'Product2';
        Map < String, Schema.SObjectType > schemaMap = Schema.getGlobalDescribe();
        Map < String, Schema.SObjectField > fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();
        List < wrapperClass > wrExistingProdlist = new List < wrapperClass > ();
        Set < Id > duplicatePrdCheck = new Set < Id > ();
        system.debug('oppty.Id :: --->'+oppty.Id);
        if(oppty.Id != null){
            wrExistingProdlist = Vision_OpportunityCreatorCtrl.showselectedProducts(oppty.Id);
            for (wrapperClass wr: wrExistingProdlist) {
                duplicatePrdCheck.add(wr.prdlist.Id);
            }
        }
        String strFields = '';
        
        for (String fieldName: fieldMap.keyset()) {
            if (strFields == null || strFields == '') {
                strFields = fieldName;
            } else {
                strFields = strFields + ' , ' + fieldName;
            }
        }
        if(duplicatePrdCheck.size() > 0){
            query = 'select Product_Family__r.Name,Phoenix_Product_Director__r.Name,Phoenix_Product_Director__r.FirstName,Phoenix_Product_Director__r.LastName,Phoenix_Royalty_Partner_Name__r.Name, Phoenix_PS_Partner_2_Name__r.Name,Phoenix_PS_Partner_1_Name__r.Name, ' + strFields + ' from Product2 where (IsActive = true AND Phoenix_Is_Exclude_Bid__c=false AND ID not in:duplicatePrdCheck)'+
                +' ORDER BY Name ASC NULLS LAST LIMIT 30000';
        }
        else{
            query = 'select Product_Family__r.Name,Phoenix_Product_Director__r.Name,Phoenix_Product_Director__r.FirstName,Phoenix_Product_Director__r.LastName,Phoenix_Royalty_Partner_Name__r.Name,'+
                +'Phoenix_PS_Partner_2_Name__r.Name,Phoenix_PS_Partner_1_Name__r.Name, ' + strFields + ' from Product2 where (IsActive = true AND Phoenix_Is_Exclude_Bid__c=false)'+
                +' ORDER BY Name ASC NULLS LAST LIMIT 30000';
        }
        List < Product2 > prlist = Database.query(query);
        
        Set < id > pids = new Set < id > ();
        Map < Id, Product2 > pdMap = new Map < Id, Product2 > ();
        for (Product2 pr: prlist) {
            pids.add(pr.Id);
            pdMap.put(pr.Id, pr);
        }
        if (prlist.size() > 0) {
            for (Product2 pr: prlist) {
                wrapperClass wr = new wrapperClass();
                wr.prdlist = pr;
                if (pr.Phoenix_WAC__c != null) {
                    wr.currencyCode = '$';
                }
                wr.isSelected = false;
                wrlist.add(wr);
            }
        }
        return wrlist;
    }
    
    @AuraEnabled
    public static List < wrapperClass > finalSearchResult(List < wrapperClass > pItem, list < string > SearchKeyWordPD, string searchName, string Family, list < string > RxSrxList, BidWrapper quotewrap) {
		system.debug('Final Search called: '+searchName);
        Set < Id > duplicatePrdCheck = new Set < Id > ();
        /* Added to avoid Duplicate Production */
        List < wrapperClass > wrExistingProdlist = new List < wrapperClass > ();
        if(quotewrap.oppty != null && quotewrap.oppty.Id != null ){
            wrExistingProdlist = Vision_OpportunityCreatorCtrl.showselectedProducts(quotewrap.oppty.Id);
        }
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
        String bidCustomer = quotewrap.oppty.AccountId;
        if (string.isNotBlank(family)) {
            searchfamily = family.trim();
            
        }
        searchfamily = '%' + searchfamily + '%';
        list < string > searchList = new List<String>();
        if(searchName != null && string.isNotBlank(searchName)){
            searchText = searchName.deleteWhitespace();
            searchName = searchName.replaceAll('-', '');
            searchText=searchText.replaceAll('-', '');
            system.debug('searchName=---->'+searchName);
            searchList = searchName.split(' ');
            Pattern isnumbers = Pattern.Compile('^[0-9]+$');
            Matcher postalMatch = isnumbers.matcher(searchText);
            if(postalMatch.Matches()){
                //system.debug('in numbers ');
                searchText = '';
                for (string str: searchList) {
                    string searchItem = '%' + str + '%';
                    searchupdateList.add(searchItem);
                    
                }
            }else{
                searchText = '%' + searchName + '%';
            }
        }
        //system.debug('searchupdateList--->'+searchupdateList);
        query1 = 'SELECT Product_Family__r.Name,Phoenix_Product_Director__r.Name, '+Phoenix_Util.productFields+' From '+productObjName+' WHERE IsActive = true';
        if(duplicatePrdCheck != null && duplicatePrdCheck.size()>0){
            query1 = query1 + ' AND ID not in:duplicatePrdCheck';
        }
        if (string.isNotBlank(searchText)) {
            system.debug('in searchText--'+searchText);
            //Family = Family.trim();
            query1 = query1 + ' AND (Product_Family__r.Name like :searchText OR Name like:searchText)';
            
        }if(searchupdateList != null && searchupdateList.size()>0){
            query1 = query1 + ' AND (Name like :searchupdateList OR Phoenix_Compare_to_Brand_Name__c like :searchupdateList OR Phoenix_UPC_Universal_Product_Code__c like :searchupdateList OR Phoenix_NDC_11__c like :searchupdateList OR ProductCode like :searchupdateList OR Phoenix_NDC_11_Dashes__c like :searchupdateList OR Phoenix_GPI_Generic_Product_Identifier__c like :searchupdateList OR Phoenix_GPI_Dashes__c like :searchupdateList OR Phoenix_GCN_Generic_Code_Number__c like :searchupdateList OR Phoenix_GCN_Sequence_Number__c like :searchupdateList OR Family like :searchupdateList )';
        }if(SearchKeyWordPD != null && SearchKeyWordPD.size()>0){
            query1 = query1 + ' AND Phoenix_Product_Director__r.Name like :SearchKeyWordPD';
        }if(RxSrxList != null && RxSrxList.size()>0){
            query1 = query1 + ' AND Phoenix_Rx_SRx_OTC__c like :RxSrxList';
        }
        if (quotewrap.oppty.Bid_Type__c == 'New Product Launch'&& quotewrap.oppty.Account.Phoenix_Is_GPO_Customer__c ==false){
            query1 = query1 + ' AND Phoenix_Is_New_Product__c = true AND Phoenix_Is_Exclude_Bid__c = false';
        }else if (quotewrap.oppty.Bid_Type__c == 'New Product Launch' && quotewrap.oppty.Account.Phoenix_Is_GPO_Customer__c) {
            query1 = query1 + ' AND Phoenix_Is_New_Product__c = true AND Phoenix_Shields__c =false AND Phoenix_Is_Exclude_Bid__c = false';//Phoenix_Shields__c =false         
        }else if ((quotewrap.oppty.Bid_Type__c == 'RFP Bids'||quotewrap.oppty.Bid_Type__c == 'Short Dated OTB'||quotewrap.oppty.Bid_Type__c == 'Good Dated OTB' ||quotewrap.oppty.Bid_Type__c == 'Price Change')&& quotewrap.oppty.Account.Phoenix_Is_GPO_Customer__c ==false) {
            query1 = query1 + ' AND Phoenix_Is_Exclude_Bid__c = false';        
        }else if ((quotewrap.oppty.Bid_Type__c == 'RFP Bids'||quotewrap.oppty.Bid_Type__c == 'Short Dated OTB'||quotewrap.oppty.Bid_Type__c == 'Good Dated OTB' ||quotewrap.oppty.Bid_Type__c == 'Price Change') && quotewrap.oppty.Account.Phoenix_Is_GPO_Customer__c){
            query1 = query1 + ' AND Phoenix_Shields__c = false AND Phoenix_Is_Exclude_Bid__c = false';
        }else if (quotewrap.oppty.Bid_Type__c == 'IPA Floor Pricing Update'||quotewrap.oppty.Bid_Type__c == 'Direct Order Form Pricing Update') {
            query1 = query1 + ' AND Phoenix_Is_Exclude_Bid__c = false';        
        }else if(quotewrap.oppty.Account.Phoenix_Is_GPO_Customer__c && quotewrap.oppty.Bid_Type__c != 'Initial Order Discount for WAC Customers (No-Contract Price Offering)') {
            query1 = query1 + ' AND Phoenix_Is_Exclude_Bid__c = false AND Phoenix_Is_New_Product__c = false AND Phoenix_Shields__c =false';        
        }else if(quotewrap.oppty.Bid_Type__c == 'Initial Order Discount for WAC Customers (No-Contract Price Offering)' && !quotewrap.oppty.Account.Phoenix_Is_GPO_Customer__c){
            query1 = query1 + ' AND Phoenix_Is_Exclude_Bid__c = false';        
        }else if(quotewrap.oppty.Bid_Type__c == 'Initial Order Discount for WAC Customers (No-Contract Price Offering)' && quotewrap.oppty.Account.Phoenix_Is_GPO_Customer__c){
            query1 = query1 + ' AND Phoenix_Is_Exclude_Bid__c = false AND Phoenix_Shields__c =false';        
        }
        query1 = query1 + ' ORDER BY Name ASC NULLS LAST LIMIT 3000';
        system.debug('query1--->'+query1);
        list < Product2 > produtsList = new list < Product2 > ();
        produtsList = Database.query(query1);
        system.debug('produtsList---->'+produtsList.size());
        Map < Id, wrapperClass > productMap = new map < Id, wrapperClass > ();
        for (wrapperClass w: pItem) {
            productMap.put(w.prdlist.Id,w);
        }
        for(Product2 pr : produtsList){
            wrapperClass wrapper = new wrapperClass();
            wrapper.prdlist = pr;
            if(productMap != null && productMap.size()>0 && productMap.containsKey(pr.Id)){
                wrapper.isSelected = true;
            }
            wralist.add(wrapper);
        }
        //system.debug('wralist--->'+wralist);
        return wralist;
    }
    
    @AuraEnabled
    public static List < wrapperClass > getproductsForSelectedCnts(BidWrapper quotewrap, List < Id > productIdList) {
        
        Opportunity oppty = quotewrap.oppty;
        
        List < wrapperClass > wrlist = new List < wrapperClass > ();
        String query = '';
        String SobjectApiName = 'Product2';
        Map < String, Schema.SObjectType > schemaMap = Schema.getGlobalDescribe();
        Map < String, Schema.SObjectField > fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();
        List < wrapperClass > wrExistingProdlist = new List < wrapperClass > ();
        Set < Id > duplicatePrdCheck = new Set < Id > ();
        wrExistingProdlist = Vision_OpportunityCreatorCtrl.showselectedProducts(oppty.Id);
        for (wrapperClass wr: wrExistingProdlist) {
            duplicatePrdCheck.add(wr.prdlist.Id);
        }
        String strFields = '';
        
        for (String fieldName: fieldMap.keyset()) {
            if (strFields == null || strFields == '') {
                strFields = fieldName;
            } else {
                strFields = strFields + ' , ' + fieldName;
            }
        }
        
        query = 'select Product_Family__r.Name,Phoenix_Product_Director__r.Name,Phoenix_Product_Director__r.FirstName,Phoenix_Product_Director__r.LastName,Phoenix_Royalty_Partner_Name__r.Name,Phoenix_PS_Partner_2_Name__r.Name,Phoenix_PS_Partner_1_Name__r.Name, ' + strFields + ' from Product2 where Id IN : productIdList AND (IsActive = true AND Phoenix_Is_Exclude_Bid__c=false  AND ID not in:duplicatePrdCheck) ORDER BY Name ASC NULLS LAST LIMIT 30000';
      
        
        List < Product2 > prlist = Database.query(query);
        
        Set < id > pids = new Set < id > ();
        Map < Id, Product2 > pdMap = new Map < Id, Product2 > ();
        /*for (Product2 pr: prlist) {
            pids.add(pr.Id);
            pdMap.put(pr.Id, pr);
        }*/
        
        
        if (prlist.size() > 0) {
            for (Product2 pr: prlist) {
                wrapperClass wr = new wrapperClass();
                wr.prdlist = pr;
                if (pr.Phoenix_WAC__c != null) {
                    wr.currencyCode = '$';
                }
                
                wr.isSelected = false;
                wrlist.add(wr);
            }
        }
        
        return wrlist;
    }
    
    @AuraEnabled
    public static List < wrapperClass > getproductsForSelectedCnts(BidWrapper quotewrap) {
        
        Opportunity oppty = quotewrap.oppty;
        
        List < wrapperClass > wrlist = new List < wrapperClass > ();
        String query = '';
        String SobjectApiName = 'Product2';
        Map < String, Schema.SObjectType > schemaMap = Schema.getGlobalDescribe();
        Map < String, Schema.SObjectField > fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();
        List < wrapperClass > wrExistingProdlist = new List < wrapperClass > ();
        Set < Id > duplicatePrdCheck = new Set < Id > ();
        wrExistingProdlist = Vision_OpportunityCreatorCtrl.showselectedProducts(oppty.Id);
        for (wrapperClass wr: wrExistingProdlist) {
            duplicatePrdCheck.add(wr.prdlist.Id);
        }
        String strFields = '';
        
        for (String fieldName: fieldMap.keyset()) {
            if (strFields == null || strFields == '') {
                strFields = fieldName;
            } else {
                strFields = strFields + ' , ' + fieldName;
            }
        }
        
       	query = 'select Product_Family__r.Name,Phoenix_Product_Director__r.Name,Phoenix_Product_Director__r.FirstName,Phoenix_Product_Director__r.LastName,Phoenix_Royalty_Partner_Name__r.Name,Phoenix_PS_Partner_2_Name__r.Name,Phoenix_PS_Partner_1_Name__r.Name, ' + strFields + ' from Product2 where Id IN : productsIdSet (IsActive = true AND Phoenix_Is_Exclude_Bid__c=false  AND ID not in:duplicatePrdCheck) ORDER BY Name ASC NULLS LAST LIMIT 30000';
        
        List < Product2 > prlist = Database.query(query);
        
        Set < id > pids = new Set < id > ();
        Map < Id, Product2 > pdMap = new Map < Id, Product2 > ();
        /*for (Product2 pr: prlist) {
            pids.add(pr.Id);
            pdMap.put(pr.Id, pr);
        }*/
        
        
        if (prlist.size() > 0) {
            for (Product2 pr: prlist) {
                wrapperClass wr = new wrapperClass();
                wr.prdlist = pr;
                if (pr.Phoenix_WAC__c != null) {
                    wr.currencyCode = '$';
                }
                
                wr.isSelected = false;
                wrlist.add(wr);
            }
        }
        
        return wrlist;
    }
    
    @AuraEnabled
    public static List < wrapperClass > showselectedProducts(string bidId) {
        list < Product_Opportunity__c > opporunityProducts = [select Id, Product__c from Product_Opportunity__c where Opportunity__c =: bidId];
        list < Product2 > productList = new list < Product2 > ();
        list < wrapperClass > wrapList = new list < wrapperClass > ();
        set < Id > prodIds = new set < Id > ();
        if (opporunityProducts.size() > 0) {
            for (Product_Opportunity__c pbl: opporunityProducts) {
                prodIds.add(pbl.Product__c);
            }
        }
        if (prodIds.size() > 0) {
            productList = [select Name, Product_Family__r.Name, Product_Family__c, Family, ProductCode, Phoenix_NDC_11__c from Product2 where Id IN: prodIds ORDER BY Name ASC NULLS LAST LIMIT 30000];
            
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
        list < string > searchupdateList = new list < string > ();
        String query1;
        String searchText;
        string searchfamily;
        list < string > productDirectors = new list < string > ();
        list < string > NewproductDirectors;
        string searchPD;
        /* Added to avoid Duplicate Production */
        List < wrapperClass > wrExistingProdlist = new List < wrapperClass > ();
        Set < Id > duplicatePrdCheck = new Set < Id > ();
        wrExistingProdlist = Vision_OpportunityCreatorCtrl.showselectedProducts(oppty.Id);
        for (wrapperClass wr: wrExistingProdlist) {
            duplicatePrdCheck.add(wr.prdlist.Id);
        }
        
        
        List < String > searchList;
        list < Product2 > prodNameList = new list < Product2 > ();
        if (string.isNotBlank(Family)) {
            searchfamily = Family.trim();
            
        }
        
        
        
        searchfamily = '%' + searchfamily + '%';
        if (string.isNotBlank(searchName)) {
            searchText = searchName.trim();
            searchText = searchText.replace('\\s+', ' ');
            
          
            prodNameList = [select Id, Name,Product_Family__r.Name,Product_Family__c from Product2 where IsActive = true AND Phoenix_Is_Exclude_Bid__c = false AND Name =: searchText];
         
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
        
        query1 = 'SELECT Id,Product_Family__r.Name,Phoenix_Product_Director__r.Name,Phoenix_Date_of_Discontinuation__c ,Phoenix_Product_Type_for_CM_Fee__c,Phoenix_Rx_SRx_OTC__c,Name,ProductCode,Phoenix_NDC_11__c,Phoenix_GCN_Generic_Code_Number__c,Phoenix_GCN_Sequence_Number__c,Phoenix_NDC_11_Dashes__c,Phoenix_GPI_Generic_Product_Identifier__c,Phoenix_GPI_Dashes__c,Family,Phoenix_Strength__c,Phoenix_Pkg_Size__c,Phoenix_WAC__c,Phoenix_Product_Director__c,Phoenix_Compare_to_Brand_Name__c FROM Product2 WHERE (IsActive = true AND Phoenix_Is_Exclude_Bid__c=false AND Phoenix_Product_Director__r.Name like :SearchKeyWordPD  AND ID not in:duplicatePrdCheck) ORDER BY Name ASC NULLS LAST LIMIT 30000';
        
        list < Product2 > productList = Database.query(query1);
        if (RxSrxList != null && !RxSrxList.isEmpty() && productList.size() > 0) {
            string query2;
            query2 = 'SELECT Id,Product_Family__r.Name,Phoenix_Product_Director__r.Name,Phoenix_Date_of_Discontinuation__c ,Phoenix_Product_Type_for_CM_Fee__c,Phoenix_Rx_SRx_OTC__c,Name,ProductCode,Phoenix_NDC_11__c,Phoenix_GCN_Generic_Code_Number__c,Phoenix_GCN_Sequence_Number__c,Phoenix_NDC_11_Dashes__c,Phoenix_GPI_Generic_Product_Identifier__c,Phoenix_GPI_Dashes__c,Family,Phoenix_Strength__c,Phoenix_Pkg_Size__c,Phoenix_WAC__c,Phoenix_Product_Director__c,Phoenix_Compare_to_Brand_Name__c FROM Product2 WHERE ( Phoenix_Rx_SRx_OTC__c like :RxSrxList AND ID IN:productList  AND ID not in:duplicatePrdCheck ) ORDER BY Name ASC NULLS LAST LIMIT 30000';
            productList = Database.query(query2);
        }
        if (productList.size() > 0 && string.isNotBlank(searchName)) {
            string query3;
            query3 = 'SELECT Id,Product_Family__r.Name,Phoenix_Product_Director__r.Name,Phoenix_Date_of_Discontinuation__c ,Phoenix_Product_Type_for_CM_Fee__c,Phoenix_Rx_SRx_OTC__c,Name,ProductCode,Phoenix_NDC_11__c,Phoenix_GCN_Generic_Code_Number__c,Phoenix_GCN_Sequence_Number__c,Phoenix_NDC_11_Dashes__c,Phoenix_GPI_Generic_Product_Identifier__c,Phoenix_GPI_Dashes__c,Family,Phoenix_Strength__c,Phoenix_Pkg_Size__c,Phoenix_WAC__c,Phoenix_Product_Director__c,Phoenix_Compare_to_Brand_Name__c FROM Product2 WHERE (ID IN:productList AND (Name like :searchupdateList OR Phoenix_Compare_to_Brand_Name__c like :searchupdateList OR Phoenix_UPC_Universal_Product_Code__c like :searchupdateList OR Phoenix_NDC_11__c like :searchupdateList OR ProductCode like :searchupdateList OR Phoenix_NDC_11_Dashes__c like :searchupdateList OR Phoenix_GPI_Generic_Product_Identifier__c like :searchupdateList OR Phoenix_GPI_Dashes__c like :searchupdateList OR Phoenix_GCN_Generic_Code_Number__c like :searchupdateList OR Phoenix_GCN_Sequence_Number__c like :searchupdateList)  AND ID not in:duplicatePrdCheck ) ORDER BY Name ASC NULLS LAST LIMIT 30000';
            productList = Database.query(query3);
        }
        if (productList.size() > 0 && string.isNotBlank(Family)) {
            string query4;
            query4 = 'SELECT Id,Product_Family__r.Name,Phoenix_Product_Director__r.Name,Phoenix_Date_of_Discontinuation__c ,Phoenix_Product_Type_for_CM_Fee__c,Phoenix_Rx_SRx_OTC__c,Name,ProductCode,Phoenix_NDC_11__c,Phoenix_GCN_Generic_Code_Number__c,Phoenix_GCN_Sequence_Number__c,Phoenix_NDC_11_Dashes__c,Phoenix_GPI_Generic_Product_Identifier__c,Phoenix_GPI_Dashes__c,Family,Phoenix_Strength__c,Phoenix_Pkg_Size__c,Phoenix_WAC__c,Phoenix_Product_Director__c,Phoenix_Compare_to_Brand_Name__c FROM Product2 WHERE (ID IN:productList AND IsActive = true AND Phoenix_Is_Exclude_Bid__c=false AND Family like :searchfamily) ORDER BY Name ASC NULLS LAST LIMIT 30000';
            productList = Database.query(query4);
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
    public static List < wrapperClass > getSearch(List < wrapperClass > pItem, list < string > SearchKeyWordPD, string search, string family, list < string > RxSrxList, BidWrapper quotewrap) {
        system.debug('Called');
        List < wrapperClass > wralist1 = new List < wrapperClass > ();
        String searchText = search.trim();
        string searchfamily;
        /* Added to avoid Duplicate Production */
        List < wrapperClass > wrExistingProdlist = new List < wrapperClass > ();
        Set < Id > duplicatePrdCheck = new Set < Id > ();
        wrExistingProdlist = Vision_OpportunityCreatorCtrl.showselectedProducts(oppty.Id);
        for (wrapperClass wr: wrExistingProdlist) {
            duplicatePrdCheck.add(wr.prdlist.Id);
        }
        if (string.isNotBlank(family)) {
            searchfamily = family.trim();
            
        }
        searchfamily = '%' + searchfamily + '%';
        
        //searchText=searchText.replace('-','');
        system.debug('searchText---' + searchText);
        searchText = searchText.replace('\\s+', ' ');
        system.debug('searchText---' + searchText);
        set < Id > RxProdIds = new set < Id > ();
        list < string > searchupdateList = new list < string > ();
        String query1;
        list < Product2 > prodNameList = new list < Product2 > ();
       
        prodNameList = [select Id, Name,Product_Family__r.Name, Product_Family__c from Product2 where IsActive = true AND Phoenix_Is_Exclude_Bid__c = false AND Name =: searchText AND ID not in: duplicatePrdCheck];
      
        if (prodNameList.size() == 0) {
            List < String > searchList = searchText.split(' ');
            for (string str: searchList) {
                string searchItem = '%' + str + '%';
                searchupdateList.add(searchItem);
                
            }
        } else {
            searchupdateList.add('%' + searchText + '%');
        }
        
        
        
        
        query1 = 'SELECT Id,Product_Family__r.Name,Phoenix_Product_Director__r.Name,Phoenix_Date_of_Discontinuation__c ,Phoenix_Product_Type_for_CM_Fee__c,Phoenix_Rx_SRx_OTC__c,Name,ProductCode,Phoenix_NDC_11__c,Phoenix_GCN_Generic_Code_Number__c,Phoenix_GCN_Sequence_Number__c,Phoenix_NDC_11_Dashes__c,Phoenix_GPI_Generic_Product_Identifier__c,Phoenix_GPI_Dashes__c,Family,Phoenix_Strength__c,Phoenix_Pkg_Size__c,Phoenix_WAC__c,Phoenix_Product_Director__c,Phoenix_Compare_to_Brand_Name__c FROM Product2 WHERE ((IsActive = true AND Phoenix_Is_Exclude_Bid__c=false ) AND(Name like :searchupdateList OR Phoenix_Compare_to_Brand_Name__c like :searchupdateList OR Phoenix_UPC_Universal_Product_Code__c like :searchupdateList OR Phoenix_NDC_11__c like :searchupdateList OR ProductCode like :searchupdateList OR Phoenix_NDC_11_Dashes__c like :searchupdateList OR Phoenix_GPI_Generic_Product_Identifier__c like :searchupdateList OR Phoenix_GPI_Dashes__c like :searchupdateList OR Phoenix_GCN_Generic_Code_Number__c like :searchupdateList OR Phoenix_GCN_Sequence_Number__c like :searchupdateList OR Family like :searchupdateList )  AND ID not in:duplicatePrdCheck ) ORDER BY Name ASC NULLS LAST LIMIT 30000';
        
        list < Product2 > productList = Database.query(query1);
        if (RxSrxList != null && !RxSrxList.isEmpty() && productList.size() > 0) {
            string query2;            query2 = 'SELECT Id,Product_Family__r.Name,Phoenix_Product_Director__r.Name,Phoenix_Date_of_Discontinuation__c ,Phoenix_Product_Type_for_CM_Fee__c,Phoenix_Rx_SRx_OTC__c,Name,ProductCode,Phoenix_NDC_11__c,Phoenix_GCN_Generic_Code_Number__c,Phoenix_GCN_Sequence_Number__c,Phoenix_NDC_11_Dashes__c,Phoenix_GPI_Generic_Product_Identifier__c,Phoenix_GPI_Dashes__c,Family,Phoenix_Strength__c,Phoenix_Pkg_Size__c,Phoenix_WAC__c,Phoenix_Product_Director__c,Phoenix_Compare_to_Brand_Name__c FROM Product2 WHERE ( Phoenix_Rx_SRx_OTC__c like :RxSrxList AND ID IN:productList  AND ID not in:duplicatePrdCheck ) ORDER BY Name ASC NULLS LAST LIMIT 30000';
            productList = Database.query(query2);
        }
        if (productList.size() > 0 && string.isNotBlank(family)) {
            string query3;            query3 = 'SELECT Id,Product_Family__r.Name,Phoenix_Product_Director__r.Name,Phoenix_Date_of_Discontinuation__c ,Phoenix_Product_Type_for_CM_Fee__c,Phoenix_Rx_SRx_OTC__c,Name,ProductCode,Phoenix_NDC_11__c,Phoenix_GCN_Generic_Code_Number__c,Phoenix_GCN_Sequence_Number__c,Phoenix_NDC_11_Dashes__c,Phoenix_GPI_Generic_Product_Identifier__c,Phoenix_GPI_Dashes__c,Family,Phoenix_Strength__c,Phoenix_Pkg_Size__c,Phoenix_WAC__c,Phoenix_Product_Director__c,Phoenix_Compare_to_Brand_Name__c FROM Product2 WHERE (ID IN:productList AND Family like :searchfamily AND ID not in:duplicatePrdCheck ) ORDER BY Name ASC NULLS LAST LIMIT 30000';
            productList = Database.query(query3);
        }
        if (productList.size() > 0 && SearchKeyWordPD != null && !SearchKeyWordPD.isEmpty()) {
            string query4;            query4 = 'SELECT Id,Product_Family__r.Name,Phoenix_Product_Director__r.Name,Phoenix_Date_of_Discontinuation__c ,Phoenix_Product_Type_for_CM_Fee__c,Phoenix_Rx_SRx_OTC__c,Name,ProductCode,Phoenix_NDC_11__c,Phoenix_GCN_Generic_Code_Number__c,Phoenix_GCN_Sequence_Number__c,Phoenix_NDC_11_Dashes__c,Phoenix_GPI_Generic_Product_Identifier__c,Phoenix_GPI_Dashes__c,Family,Phoenix_Strength__c,Phoenix_Pkg_Size__c,Phoenix_WAC__c,Phoenix_Product_Director__c,Phoenix_Compare_to_Brand_Name__c FROM Product2 WHERE (ID IN:productList AND Phoenix_Product_Director__r.Name like :SearchKeyWordPD  AND ID not in:duplicatePrdCheck) ORDER BY Name ASC NULLS LAST LIMIT 30000';
            productList = Database.query(query4);
        }
        
        Map < Id, Product2 > productMap = new map < Id, Product2 > (productList);
        for (wrapperClass w: pItem) {            if (productMap.containskey(w.prdlist.Id))                wralist1.add(w);
            
        }
        
        return wralist1;
    }
    
    @AuraEnabled
    public static List < wrapperClass > getSearchFamily(List < wrapperClass > pItem, list < string > SearchKeyWordPD, string search, string searchName, list < string > RxSrxList, BidWrapper quotewrap) {
        
        List < wrapperClass > wralist = new List < wrapperClass > ();
        list < string > searchupdateList = new list < string > ();
        /* Added to avoid Duplicate Production */
        List < wrapperClass > wrExistingProdlist = new List < wrapperClass > ();
        Set < Id > duplicatePrdCheck = new Set < Id > ();
        wrExistingProdlist = Vision_OpportunityCreatorCtrl.showselectedProducts(oppty.Id);
        for (wrapperClass wr: wrExistingProdlist) {
            duplicatePrdCheck.add(wr.prdlist.Id);
        }
        String query1;
        String searchText;
        string searchfamily;
        List < String > searchList;
        list < Product2 > prodNameList = new list < Product2 > ();
        if (string.isNotBlank(search)) {            searchfamily = search.trim();
        }
        
        
        searchfamily = '%' + searchfamily + '%';
        
        if (string.isNotBlank(searchName)) {            searchText = searchName.trim();
            searchText = searchText.replace('\\s+', ' ');
            
            
            prodNameList = [select Id, Name,Product_Family__r.Name, Product_Family__c from Product2 where IsActive = true AND Phoenix_Is_Exclude_Bid__c = false AND Name =: searchText AND ID not in: duplicatePrdCheck];
       
            if (prodNameList.size() == 0) {
                searchList = searchText.split(' ');
                for (string str: searchList) {
                    string searchItem = '%' + str + '%';
                    searchupdateList.add(searchItem);
                    
                }
            } else {                searchupdateList.add('%' + searchText + '%');
            }
        }        
        list < Product2 > productList = new list < Product2 > ();
        if (string.isNotBlank(search)) {            query1 = 'SELECT Id,Product_Family__r.Name,Phoenix_Product_Director__r.Name,Phoenix_Date_of_Discontinuation__c ,Phoenix_Product_Type_for_CM_Fee__c,Phoenix_Rx_SRx_OTC__c,Name,ProductCode,Phoenix_NDC_11__c,Phoenix_GCN_Generic_Code_Number__c,Phoenix_GCN_Sequence_Number__c,Phoenix_NDC_11_Dashes__c,Phoenix_GPI_Generic_Product_Identifier__c,Phoenix_GPI_Dashes__c,Family,Phoenix_Strength__c,Phoenix_Pkg_Size__c,Phoenix_WAC__c,Phoenix_Product_Director__c,Phoenix_Compare_to_Brand_Name__c FROM Product2 WHERE (IsActive = true AND Phoenix_Is_Exclude_Bid__c=false AND Family like :searchfamily  AND ID not in:duplicatePrdCheck) ORDER BY Name ASC NULLS LAST LIMIT 30000';
            
            productList = Database.query(query1);
        }
        
        if (RxSrxList != null && !RxSrxList.isEmpty()) {
            if (productList.size() > 0) {
                string query2;                query2 = 'SELECT Id,Product_Family__r.Name,Phoenix_Product_Director__r.Name,Phoenix_Date_of_Discontinuation__c ,Phoenix_Product_Type_for_CM_Fee__c,Phoenix_Rx_SRx_OTC__c,Name,ProductCode,Phoenix_NDC_11__c,Phoenix_GCN_Generic_Code_Number__c,Phoenix_GCN_Sequence_Number__c,Phoenix_NDC_11_Dashes__c,Phoenix_GPI_Generic_Product_Identifier__c,Phoenix_GPI_Dashes__c,Family,Phoenix_Strength__c,Phoenix_Pkg_Size__c,Phoenix_WAC__c,Phoenix_Product_Director__c,Phoenix_Compare_to_Brand_Name__c FROM Product2 WHERE ( Phoenix_Rx_SRx_OTC__c like :RxSrxList AND ID IN:productList  AND ID not in:duplicatePrdCheck) ORDER BY Name ASC NULLS LAST LIMIT 30000';
                productList = Database.query(query2);
            }
            /*else{
string query2;
query2 = 'SELECT Id,Phoenix_Product_Director__r.Name,Phoenix_Date_of_Discontinuation__c ,Phoenix_Product_Type_for_CM_Fee__c,Phoenix_Rx_SRx_OTC__c,Name,ProductCode,Phoenix_NDC_11__c,Phoenix_GCN_Generic_Code_Number__c,Phoenix_GCN_Sequence_Number__c,Phoenix_NDC_11_Dashes__c,Phoenix_GPI_Generic_Product_Identifier__c,Phoenix_GPI_Dashes__c,Family,Phoenix_Strength__c,Phoenix_Pkg_Size__c,Phoenix_WAC__c,Phoenix_Product_Director__c,Phoenix_Compare_to_Brand_Name__c FROM Product2 WHERE ( Phoenix_Rx_SRx_OTC__c like :RxSrxList) ORDER BY Name ASC NULLS LAST LIMIT 30000';   
productList=Database.query(query2);    
}*/
        }
        if (string.isNotBlank(searchName)) {
            if (productList.size() > 0) {
                string query3;                query3 = 'SELECT Id,Product_Family__r.Name,Phoenix_Product_Director__r.Name,Phoenix_Date_of_Discontinuation__c ,Phoenix_Product_Type_for_CM_Fee__c,Phoenix_Rx_SRx_OTC__c,Name,ProductCode,Phoenix_NDC_11__c,Phoenix_GCN_Generic_Code_Number__c,Phoenix_GCN_Sequence_Number__c,Phoenix_NDC_11_Dashes__c,Phoenix_GPI_Generic_Product_Identifier__c,Phoenix_GPI_Dashes__c,Family,Phoenix_Strength__c,Phoenix_Pkg_Size__c,Phoenix_WAC__c,Phoenix_Product_Director__c,Phoenix_Compare_to_Brand_Name__c FROM Product2 WHERE (ID IN:productList AND (Name like :searchupdateList OR Phoenix_Compare_to_Brand_Name__c like :searchupdateList OR Phoenix_UPC_Universal_Product_Code__c like :searchupdateList OR Phoenix_NDC_11__c like :searchupdateList OR ProductCode like :searchupdateList OR Phoenix_NDC_11_Dashes__c like :searchupdateList OR Phoenix_GPI_Generic_Product_Identifier__c like :searchupdateList OR Phoenix_GPI_Dashes__c like :searchupdateList OR Phoenix_GCN_Generic_Code_Number__c like :searchupdateList OR Phoenix_GCN_Sequence_Number__c like :searchupdateList)  AND ID not in:duplicatePrdCheck ) ORDER BY Name ASC NULLS LAST LIMIT 30000';
                productList = Database.query(query3);
            }
            /*else{
string query3;
query3 = 'SELECT Id,Phoenix_Product_Director__r.Name,Phoenix_Date_of_Discontinuation__c ,Phoenix_Product_Type_for_CM_Fee__c,Phoenix_Rx_SRx_OTC__c,Name,ProductCode,Phoenix_NDC_11__c,Phoenix_GCN_Generic_Code_Number__c,Phoenix_GCN_Sequence_Number__c,Phoenix_NDC_11_Dashes__c,Phoenix_GPI_Generic_Product_Identifier__c,Phoenix_GPI_Dashes__c,Family,Phoenix_Strength__c,Phoenix_Pkg_Size__c,Phoenix_WAC__c,Phoenix_Product_Director__c,Phoenix_Compare_to_Brand_Name__c FROM Product2 WHERE ( (Name like :searchupdateList OR Phoenix_Compare_to_Brand_Name__c like :searchupdateList OR Phoenix_UPC_Universal_Product_Code__c like :searchupdateList OR Phoenix_NDC_11__c like :searchupdateList OR ProductCode like :searchupdateList OR Phoenix_NDC_11_Dashes__c like :searchupdateList OR Phoenix_GPI_Generic_Product_Identifier__c like :searchupdateList OR Phoenix_GPI_Dashes__c like :searchupdateList OR Phoenix_GCN_Generic_Code_Number__c like :searchupdateList OR Phoenix_GCN_Sequence_Number__c like :searchupdateList)) ORDER BY Name ASC NULLS LAST LIMIT 30000';
productList=Database.query(query3);    
}*/
        }
        if (SearchKeyWordPD != null && !SearchKeyWordPD.isEmpty()) {
            if (productList.size() > 0) {
                string query4;                query4 = 'SELECT Id,Product_Family__r.Name,Phoenix_Product_Director__r.Name,Phoenix_Date_of_Discontinuation__c ,Phoenix_Product_Type_for_CM_Fee__c,Phoenix_Rx_SRx_OTC__c,Name,ProductCode,Phoenix_NDC_11__c,Phoenix_GCN_Generic_Code_Number__c,Phoenix_GCN_Sequence_Number__c,Phoenix_NDC_11_Dashes__c,Phoenix_GPI_Generic_Product_Identifier__c,Phoenix_GPI_Dashes__c,Family,Phoenix_Strength__c,Phoenix_Pkg_Size__c,Phoenix_WAC__c,Phoenix_Product_Director__c,Phoenix_Compare_to_Brand_Name__c FROM Product2 WHERE (ID IN:productList AND Phoenix_Product_Director__r.Name like :SearchKeyWordPD  AND ID not in:duplicatePrdCheck) ORDER BY Name ASC NULLS LAST LIMIT 30000';
                productList = Database.query(query4);
            }
            /*else{
string query4;
query4 = 'SELECT Id,Phoenix_Product_Director__r.Name,Phoenix_Date_of_Discontinuation__c ,Phoenix_Product_Type_for_CM_Fee__c,Phoenix_Rx_SRx_OTC__c,Name,ProductCode,Phoenix_NDC_11__c,Phoenix_GCN_Generic_Code_Number__c,Phoenix_GCN_Sequence_Number__c,Phoenix_NDC_11_Dashes__c,Phoenix_GPI_Generic_Product_Identifier__c,Phoenix_GPI_Dashes__c,Family,Phoenix_Strength__c,Phoenix_Pkg_Size__c,Phoenix_WAC__c,Phoenix_Product_Director__c,Phoenix_Compare_to_Brand_Name__c FROM Product2 WHERE ( Phoenix_Product_Director__r.Name like :SearchKeyWordPD) ORDER BY Name ASC NULLS LAST LIMIT 30000';
productList=Database.query(query4); 
}*/
        }
        Map < Id, Product2 > productMap = new map < Id, Product2 > (productList);
        for (wrapperClass w: pItem) {if (productMap.containskey(w.prdlist.Id))wralist.add(w);}
        return wralist;
    }
    
    
    @AuraEnabled
    public static list < Product_Opportunity__c > savequoteitems(list < wrapperClass > saveitems, BidWrapper bidWrapper, List < string > selectrcs) {
        
        list < Product_Opportunity__c > newItems = new list < Product_Opportunity__c > ();
        list < Product2 > prodList;
        list < Phoenix_Bid_Fee_Master__c > feeList = new list < Phoenix_Bid_Fee_Master__c > ();
        list < Phoenix_Bid_Fee_Master__c > feeListRos = new list < Phoenix_Bid_Fee_Master__c > ();
        list < Phoenix_Bid_Fee_Master__c > feeListForRos = new list < Phoenix_Bid_Fee_Master__c > ();
        // Extension records for ROSS created By Ashok Alli.
        list<Phoenix_BidLineItemExtn__c> bidLineItemExtList = new List<Phoenix_BidLineItemExtn__c> ();  
        //Other templates does not need these extension records.
        string oppty = bidWrapper.oppty.Id;
        Id accountId = bidWrapper.oppty.AccountId;
        Account acc=new Account();
        if (accountId != null) {
            acc = [select Id,Name,Phoenix_NLC__c,Phoenix_Admin_Fee_Sec_Template__c,Phoenix_Rebate_Secondary_Template__c, AccountNumber,Phoenix_Is_Govt_Customer__c, Phoenix_Cash_Discount__c, Phoenix_Fee__c,Phoenix_Order_Analytics_Fee__c, Fee_Type__c, Rebate_Type__c, Phoenix_Indirect_Cash_Discount__c, Phoenix_Rebates__c,Phoenix_Rebate_Pharmagen__c, Phoenix_Preferred_Wholesaler__c, Phoenix_Local_VIP__c, Phoenix_CM_Fees__c, Phoenix_RDC_NLC__c, Cash_Terms__c from Account where Id =: accountId];
            
            
            
            feeList = [select Id, Phoenix_Customer_Type__c, Phoenix_Fee__c, Phoenix_Preferred_Wholesaler__c, Phoenix_Fee_Type__c, Phoenix_Product_Type_for_CM_Fee__c from Phoenix_Bid_Fee_Master__c where Phoenix_Preferred_Wholesaler__c =: acc.Phoenix_Preferred_Wholesaler__c limit 30000];
            
            
        }
        if(bidWrapper.oppty.Vision_Bid_Template__c == 'ROS'){
            
            feeListRos = [select Id, Phoenix_Customer_Type__c, Phoenix_Fee__c, Phoenix_Preferred_Wholesaler__c, Phoenix_Fee_Type__c, Phoenix_Product_Type_for_CM_Fee__c 
                          from Phoenix_Bid_Fee_Master__c where Phoenix_Preferred_Wholesaler__c = 'McKesson' limit 30000];
            
        }
        if(bidWrapper.oppty.Vision_Bid_Template__c == 'ROS' || acc.AccountNumber == '370337'){
            feeListForRos = [select Id, Phoenix_Customer_Type__c, Phoenix_Fee__c, Phoenix_Preferred_Wholesaler__c, Phoenix_Fee_Type__c, Phoenix_Product_Type_for_CM_Fee__c from Phoenix_Bid_Fee_Master__c where Phoenix_Preferred_Wholesaler__c = 'Cardinal' AND Phoenix_Fee_Type__c = 'RDC/NLC %' limit 30000];
        }
        //added by srimayee start
         List<Id> prodIds = new List<Id>();
         set<String> conNos = new set<String>();
                Map<String,List<Phoenix_Inclusion_Contract_Pharmabid__c>> exContractsMap = new Map<String,List<Phoenix_Inclusion_Contract_Pharmabid__c>>();
                Map<String,List<String>> contractsMap = new Map<String,List<String>>();
                Map<Id,List<Phoenix_NPR_Data__c>> nprDataMap = new Map<Id,List<Phoenix_NPR_Data__c>>();
                Map<String,String> cptMap = new Map<String,String>();
                List<Phoenix_Inclusion_Contract_Pharmabid__c> InclusionContractsList= [SELECT Id, Customer_Number__c, Name, Group_Customer_Name__r.Name,Customer_Name__r.Name, Group_Customer_Number__c, Contract_Number__c FROM Phoenix_Inclusion_Contract_Pharmabid__c];
                    if(acc.AccountNumber == '164498'){
                        for(Phoenix_Inclusion_Contract_Pharmabid__c con : InclusionContractsList){
                            conNos.add(con.Contract_Number__c);
                            if(exContractsMap.containsKey(con.Contract_Number__c)){
                    List<Phoenix_Inclusion_Contract_Pharmabid__c> conSet = exContractsMap.get(con.Contract_Number__c);
                    conSet.add(con);
                    exContractsMap.put(con.Contract_Number__c,conSet);
                }
                else{
                    exContractsMap.put(con.Contract_Number__c,new List<Phoenix_Inclusion_Contract_Pharmabid__c>{con});
                }
                  if(contractsMap.containsKey(con.Contract_Number__c)){
                    List<String> conSet = contractsMap.get(con.Contract_Number__c);
                    conSet.add(con.Customer_Name__r.Name);
                    contractsMap.put(con.Contract_Number__c,conSet);
                }
                else{
                    contractsMap.put(con.Contract_Number__c,new List<String>{con.Customer_Name__r.Name});
                }    
            }
              
            set<String> uniqueNPRList =new set<String>();
            List<Phoenix_NPR_Data__c> nprData = [SELECT Id,Phoenix_12Months_Actual_Sales_Unit__c,Phoenix_Product__c,Phoenix_Contract_Number__c,Phoenix_Contract_Price__c,Phoenix_Awarded_Position__c,Phoenix_Product_Position__c, Phoenix_Material_Number__c  
                                                 from Phoenix_NPR_Data__c where Phoenix_Product__c IN: prodIds AND Phoenix_Contract_Number__c IN:conNos];
           system.debug('nprData=='+nprData.size());
                for(Phoenix_NPR_Data__c npr:nprData){
                String identifier = npr.Phoenix_Material_Number__c+'_'+npr.Phoenix_Contract_Number__c;
                    system.debug('identifier=='+identifier);
                uniqueNPRList.add(identifier);
                if(nprDataMap.containsKey(npr.Phoenix_Product__c)){
                    List<Phoenix_NPR_Data__c> nprList = nprDataMap.get(npr.Phoenix_Product__c);
                    nprList.add(npr);
                    nprDataMap.put(npr.Phoenix_Product__c,nprList);
                }
                else{
                    nprDataMap.put(npr.Phoenix_Product__c,new List<Phoenix_NPR_Data__c>{npr});
                }
            }
            List<Vision_Customer_Product_Tracker__c> cptList = [SELECT Id, General_Category__c,Vision_Current_Product_Position__c,category__c,Vision_Unique_Identifier__c,Vision_Product_Code__c,Vision_Contract_Number__c from Vision_Customer_Product_Tracker__c where Vision_Unique_Identifier__c IN:uniqueNPRList];
            for(Vision_Customer_Product_Tracker__c cpt : cptList){
                system.debug('Vision_Unique_Identifier__c=='+cpt.Vision_Unique_Identifier__c);
                system.debug('General_Category__c=='+cpt.General_Category__c);
               cptMap.put(cpt.Vision_Unique_Identifier__c,cpt.General_Category__c);
            }
            }
                                    Map<String,String> custNamesMap = new Map<String,String>();

        //added by srimayee end
        for (wrapperClass wr: saveitems) {
             Product_Opportunity__c pbl = new Product_Opportunity__c();
            
            pbl.Name = wr.prdlist.Family;
            pbl.Opportunity__c = oppty;
            pbl.Product__c = wr.prdlist.Id;
            pbl.NDC_11__c = wr.prdlist.Phoenix_NDC_11_Dashes__c;
            pbl.NDC_Without_Dashes__c = wr.prdlist.Phoenix_NDC_11__c;
            pbl.Product_Code__c = wr.prdlist.ProductCode;
            pbl.Pkg_Size__c = wr.prdlist.Phoenix_Pkg_Size__c;
            pbl.Case_Pack__c = wr.prdlist.Phoenix_Case_Pack__c;
            pbl.MOQ__c = wr.prdlist.Phoenix_Minimum_Order_Quantity__c;
            pbl.Product_Family__c = wr.prdlist.Family;
            pbl.GCN_Generic_Code_Number__c = wr.prdlist.Phoenix_GCN_Generic_Code_Number__c;
            pbl.GSN__c = wr.prdlist.Phoenix_GCN_Sequence_Number__c;
            pbl.GPI_Generic_Product_Identifier__c = wr.prdlist.Phoenix_GPI_Generic_Product_Identifier__c;
                pbl.GCP_Product_Family__c = wr.prdlist.Product_Family__c;
           // pbl.Phoenix_Direct_Order_Price1__c = wr.prdlist.Phoenix_Direct_Order_Price__c;
            pbl.Compare_to_Brand_Name__c = wr.prdlist.Phoenix_Compare_to_Brand_Name__c;
            // pbl.Phoenix_Approved_Lowest_Price_SKU__c = wr.prdlist.Phoenix_Approved_Lowest_Price_SKU__c;
            if (wr.prdlist.Phoenix_Product_Director__c != null) {
                pbl.Product_Director_Name__c = wr.prdlist.Phoenix_Product_Director__r.FirstName + ' ' + wr.prdlist.Phoenix_Product_Director__r.LastName;
            }
            pbl.Orange_Book_Rating__c = wr.prdlist.Phoenix_Orange_Book_Rating__c;
            //if (wr.prdlist.Phoenix_Throughput_cost__c != null) pbl.Phoenix_Throughput_cost__c = wr.prdlist.Phoenix_Throughput_cost__c.setScale(2);
            pbl.WAC__c = wr.prdlist.Phoenix_WAC__c;
            pbl.Budgeted_ASP__c = wr.prdlist.Phoenix_Current_Budgeted_ASP__c;
            pbl.Lowest_Price_SKU__c = wr.prdlist.Phoenix_Lowest_Price_SKU__c;
            pbl.Comm_Exps__c = wr.prdlist.Phoenix_Comm_Exps__c;
            if (wr.prdlist.Phoenix_PS_Partner_1_Name__r.Name != null) {
                pbl.PS_Partner_1__c = wr.prdlist.Phoenix_PS_Partner_1_Name__r.Name;
            }
            pbl.PS_Partner_1_Percent__c = wr.prdlist.Phoenix_PS_Partner_1__c;
            if (wr.prdlist.Phoenix_PS_Partner_2_Name__r.Name != null) {
                pbl.PS_Partner_2__c = wr.prdlist.Phoenix_PS_Partner_2_Name__r.Name;
            }
            pbl.PS_Partner_2_Percent__c = wr.prdlist.Phoenix_PS_Partner_2__c;
            if (wr.prdlist.Phoenix_Royalty_Partner_Name__r.Name != null) {
                pbl.Royalty_Partner_Name__c = wr.prdlist.Phoenix_Royalty_Partner_Name__r.Name;
            }
            pbl.Royalty_Percent__c = wr.prdlist.Phoenix_Royalty__c;
            pbl.Min_profit_share_Partner_2__c = wr.prdlist.Phoenix_Per_Unit_Profit_Partner_2__c;
            pbl.Min_profit_share_Partner_1__c = wr.prdlist.Phoenix_Per_Unit_Profit_Partner_1__c;
            pbl.UPC_Universal_Product_Code__c = wr.prdlist.Phoenix_UPC_Universal_Product_Code__c;
            //pbl.Phoenix_IPA_Floor_Price1__c = wr.prdlist.Phoenix_IPA_Floor_Price__c;
            //pbl.Phoenix_UPC_Universal_Product_Code__c = wr.prdlist.Phoenix_UPC_Universal_Product_Code__c;
            //pbl.Phoenix_Latest_Estimate__c= wr.prdlist.Phoenix_Latest_Estimate__c!=null?wr.prdlist.Phoenix_Latest_Estimate__c.setScale(2):0;
            pbl.REMS__c = wr.prdlist.Phoenix_REMS__c;
            //pbl.Phoenix_IMS_Market_Share__c = wr.prdlist.Phoenix_IMS_Market_Share__c;
            decimal mediciadReturns = wr.prdlist.Phoenix_Medicaid_Per_Unit__c != null ? wr.prdlist.Phoenix_Medicaid_Per_Unit__c : 0;
            decimal returnPerUnit = wr.prdlist.Phoenix_Return_Per_Unit__c != null ? wr.prdlist.Phoenix_Return_Per_Unit__c : 0;
           // pbl.Phoenix_Estimated_Medicaid_Returns__c = mediciadReturns + returnPerUnit;
            pbl.Estimated_Medicaid_Returns__c = mediciadReturns.setScale(2) + returnPerUnit.setScale(2);
            if (bidWrapper.oppty.Bid_Type__c == 'Short Dated OTB' || bidWrapper.oppty.Bid_Type__c == 'Good Dated OTB') {
                pbl.Estimated_Medicaid_Returns__c = mediciadReturns;
            }
           // if (accountId != null) {
            //    pbl.Phoenix_Current_Rebate__c = acc.Phoenix_Rebates__c;
             //   pbl.Phoenix_Rebate_G_N__c = acc.Rebate_Type__c;
           //     pbl.Phoenix_Fee_G_N__c= acc.Fee_Type__c;
            //}
          /*  if (bidWrapper.bid.Phoenix_Customer_Type__c == 'ROS' && feeListRos.size() > 0) {
                for(Phoenix_Bid_Fee_Master__c pbf: feeListRos){
                    if(pbf.Phoenix_Fee_Type__c=='RDC/NLC %'){
                        system.debug('Inside McKesson*****');
                        pbl.Phoenix_RDC_NLC__c = pbf.Phoenix_Fee__c !=null ? wr.prdlist.Phoenix_WAC__c * (pbf.Phoenix_Fee__c/100) : 0;
                        if(feeListForRos.size()!=0){
                            system.debug('Inside feeListforROS*****');
                            pbl.Phoenix_NLC__c = feeListForRos[0].Phoenix_Fee__c !=null ? wr.prdlist.Phoenix_WAC__c * (feeListForRos[0].Phoenix_Fee__c/100) : 0;
                            pbl.Phoenix_Proposed_Current_Rebate__c = feeListForRos[0].Phoenix_Fee__c;
                        }
                    }
                }
            }
            if (feeList.size() > 0) {
                for(Phoenix_Bid_Fee_Master__c pbf: feeList){
                    if(wr.prdlist.Phoenix_Product_Type_for_CM_Fee__c==pbf.Phoenix_Product_Type_for_CM_Fee__c && pbf.Phoenix_Fee_Type__c=='CM Fee%' && (acc.Phoenix_Is_Govt_Customer__c==true && pbf.Phoenix_Customer_Type__c=='Govt business')){
                        pbl.Phoenix_Contract_Mngment_Fee_Wholesaler__c= pbf.Phoenix_Fee__c ;
                        if(bidWrapper.bid.Phoenix_Customer_Type__c == 'ClarusOne'){                            pbl.Phoenix_Local_VIP__c=pbf.Phoenix_Fee__c; // Fee % for C1
                        }
                    } 
                    if(wr.prdlist.Phoenix_Product_Type_for_CM_Fee__c==pbf.Phoenix_Product_Type_for_CM_Fee__c && pbf.Phoenix_Fee_Type__c=='CM Fee%' && (acc.Phoenix_Is_Govt_Customer__c==false && pbf.Phoenix_Customer_Type__c=='Non Govt business')){
                        pbl.Phoenix_Contract_Mngment_Fee_Wholesaler__c= pbf.Phoenix_Fee__c ;
                        if(bidWrapper.bid.Phoenix_Customer_Type__c == 'ClarusOne'){                            pbl.Phoenix_Local_VIP__c=pbf.Phoenix_Fee__c; // Fee % for C1
                        }
                    }
                    
                    if(pbf.Phoenix_Fee_Type__c=='RDC/NLC %'){
                        
                        if(bidWrapper.bid.Phoenix_Customer_Type__c == 'ROS' && pbf.Phoenix_Preferred_Wholesaler__c == 'McKesson'){
                            /*system.debug('Inside McKesson*****');
                            pbl.Phoenix_RDC_NLC__c = pbf.Phoenix_Fee__c !=null ? wr.prdlist.Phoenix_WAC__c * (pbf.Phoenix_Fee__c/100) : 0;
                            if(feeListForRos.size()!=0){
                                system.debug('Inside feeListforROS*****');
                                pbl.Phoenix_NLC__c = feeListForRos[0].Phoenix_Fee__c !=null ? wr.prdlist.Phoenix_WAC__c * (feeListForRos[0].Phoenix_Fee__c/100) : 0;
                                pbl.Phoenix_Proposed_Current_Rebate__c = feeListForRos[0].Phoenix_Fee__c;
                            }
                        }
                        else {
                            pbl.Phoenix_RDC_NLC__c=pbf.Phoenix_Fee__c;
                        }
                        if(bidWrapper.bid.Phoenix_Customer_Type__c == 'ClarusOne' && pbf.Phoenix_Preferred_Wholesaler__c == 'McKesson'){                            pbl.Phoenix_Proposed_Current_Rebate__c=pbf.Phoenix_Fee__c; // RDC % for C1
                        }
                    }
                       if(bidWrapper.bid.Phoenix_Customer_Type__c == 'OneTimeBuy' && acc.Name=='Walgreen Company'){
                        //pbl.Phoenix_Contract_Mngment_Fee_Wholesaler__c=pbf.Phoenix_Fee__c-acc.Phoenix_Order_Analytics_Fee__c;
                        
                    }
                  if( (bidWrapper.bid.Phoenix_Bid_Type__c == 'Good Dated OTB' || bidWrapper.bid.Phoenix_Bid_Type__c == 'Short Dated OTB') && acc.Name=='Walgreen Company'){
                        //pbl.Phoenix_Contract_Mngment_Fee_Wholesaler__c=(pbf.Phoenix_Fee__c !=null !=null ? pbf.Phoenix_Fee__c:0)-(acc.Phoenix_Order_Analytics_Fee__c != null ? acc.Phoenix_Order_Analytics_Fee__c:0);
                        //pbl.Phoenix_Contract_Mngment_Fee_Wholesaler__c=(pbf.Phoenix_Fee__c !=null ? pbf.Phoenix_Fee__c:0)-(acc.Phoenix_Order_Analytics_Fee__c != null ? acc.Phoenix_Order_Analytics_Fee__c:0);
                        //pbl.Phoenix_Contract_Mngment_Fee_Wholesaler__c = pbl.Phoenix_Contract_Mngment_Fee_Wholesaler__c!=null?pbl.Phoenix_Contract_Mngment_Fee_Wholesaler__c-acc.Phoenix_Order_Analytics_Fee__c:acc.Phoenix_CM_Fees__c-acc.Phoenix_Order_Analytics_Fee__c ;
                        if(acc.Phoenix_CM_Fees__c == null){
                          // acc cm fee - order an fee
                            //pbl.Phoenix_Contract_Mngment_Fee_Wholesaler__c=((pbf.Phoenix_Fee__c !=null ? pbf.Phoenix_Fee__c:0)-(acc.Phoenix_Order_Analytics_Fee__c != null ? acc.Phoenix_Order_Analytics_Fee__c:0))>0 ? ((pbf.Phoenix_Fee__c !=null ? pbf.Phoenix_Fee__c:0)-(acc.Phoenix_Order_Analytics_Fee__c != null ? acc.Phoenix_Order_Analytics_Fee__c:0)) : pbl.Phoenix_Contract_Mngment_Fee_Wholesaler__c ;
                          pbl.Phoenix_Contract_Mngment_Fee_Wholesaler__c=((pbf.Phoenix_Fee__c !=null ? pbf.Phoenix_Fee__c:0))>0 ? ((pbf.Phoenix_Fee__c !=null ? pbf.Phoenix_Fee__c:0)) : pbl.Phoenix_Contract_Mngment_Fee_Wholesaler__c ;
                          
                            decimal va=pbl.Phoenix_Contract_Mngment_Fee_Wholesaler__c;
                           
                            system.debug('value cm fee '+va);
                        }
                        else{
                          //pbl.Phoenix_Contract_Mngment_Fee_Wholesaler__c=(acc.Phoenix_CM_Fees__c !=null ? acc.Phoenix_CM_Fees__c:0)-(acc.Phoenix_Order_Analytics_Fee__c != null ? acc.Phoenix_Order_Analytics_Fee__c:0);
                           pbl.Phoenix_Contract_Mngment_Fee_Wholesaler__c=(acc.Phoenix_CM_Fees__c !=null ? acc.Phoenix_CM_Fees__c:0);
                         
                            decimal va=pbl.Phoenix_Contract_Mngment_Fee_Wholesaler__c;
                            system.debug('cm fee value'+va); 
                        }
                        //pbl.Phoenix_Contract_Mngment_Fee_Wholesaler__c = pbl.Phoenix_Contract_Mngment_Fee_Wholesaler__c!=null?pbl.Phoenix_Contract_Mngment_Fee_Wholesaler__c-acc.Phoenix_Order_Analytics_Fee__c:acc.Phoenix_CM_Fees__c-acc.Phoenix_Order_Analytics_Fee__c ;
                
                    }
                    
                }
            }
            if(bidWrapper.bid.Phoenix_Customer_Type__c == 'Indirect' && acc.AccountNumber == '370337'){
                system.debug('cardinal Fee--->'+feeListForRos[0].Phoenix_Fee__c);
                if(feeListForRos.size()!=0){ 
                    pbl.Phoenix_RDC_NLC__c=feeListForRos[0].Phoenix_Fee__c;
                }
            }
            if(bidWrapper.bid.Phoenix_Bid_Type__c=='Direct Order Form Pricing Update'){
                pbl.Phoenix_Proposed_Direct_Selling_Unit__c = 1;
                pbl.Phoenix_Fee_G_N__c = 'Net';
            }
            if (bidWrapper.bid.Phoenix_Bid_Type__c == 'IPA Floor Pricing Update') {
                pbl.Phoenix_Proposed_Indirect_Selling_Unit__c = 1;
                pbl.Phoenix_Fee_G_N__c = 'Net';
            }
            
            system.debug('Phoenix_Customer_Type__c ----->' + bidWrapper.bid.Phoenix_Customer_Type__c);
            if (bidWrapper.bid.Phoenix_Customer_Type__c == 'Walgreens' || bidWrapper.bid.Phoenix_Customer_Type__c == 'ABC Progen' || bidWrapper.bid.Phoenix_Customer_Type__c == 'Econdisc' 
                || bidWrapper.bid.Phoenix_Customer_Type__c == 'RXSS' || bidWrapper.bid.Phoenix_Customer_Type__c == 'ClarusOne' || bidWrapper.bid.Phoenix_Customer_Type__c == 'Net Indirect Pricing' 
                 || bidWrapper.bid.Phoenix_Customer_Type__c == 'ABC Pharmagen'  || bidWrapper.bid.Phoenix_Customer_Type__c == 'Sams Club' 
                || bidWrapper.bid.Phoenix_Customer_Type__c == 'BASE/DSH'|| bidWrapper.bid.Phoenix_Customer_Type__c == 'Government Pricing' || bidWrapper.bid.Phoenix_Customer_Type__c == 'ROS' 
               ) {
                   pbl.Phoenix_Fee_G_N__c = 'Net';
                   if (bidWrapper.bid.Phoenix_Customer_Type__c != 'ClarusOne' && bidWrapper.bid.Phoenix_Customer_Type__c != 'Costco' && bidWrapper.bid.Phoenix_Customer_Type__c != 'ABC Pharmagen' && bidWrapper.bid.Phoenix_Customer_Type__c != 'ROS')
                       pbl.Phoenix_Proposed_Current_Rebate__c=acc.Phoenix_Rebates__c;
                   pbl.Phoenix_Current_Rebate__c=acc.Phoenix_Rebates__c;
               }
            if(bidWrapper.bid.Phoenix_Customer_Type__c == 'ROS'){
                pbl.Phoenix_NLC__c = acc.Phoenix_NLC__c;
            } 
            if(bidWrapper.bid.Phoenix_Customer_Type__c == 'Costco'){               
                pbl.Phoenix_Proposed_Current_Rebate__c=0;
                pbl.Phoenix_Current_Rebate__c=0;
                                                                   
             }
            if(bidWrapper.bid.Phoenix_Customer_Type__c == 'ABC Pharmagen'){               
                pbl.Phoenix_Proposed_Current_Rebate__c=acc.Phoenix_Rebate_Pharmagen__c;
                pbl.Phoenix_Current_Rebate__c=acc.Phoenix_Rebate_Pharmagen__c;
                                                                   
             }
            if (bidWrapper.bid.Phoenix_Customer_Type__c != 'ClarusOne'){
                pbl.Phoenix_Current_Admin_Fee__c = acc.Phoenix_Fee__c;
                pbl.Phoenix_RDC_NLC__c = pbl.Phoenix_RDC_NLC__c!=null?pbl.Phoenix_RDC_NLC__c:acc.Phoenix_RDC_NLC__c ;
                pbl.Phoenix_Cash_Terms__c = acc.Cash_Terms__c;
                if(bidWrapper.bid.Phoenix_Customer_Type__c == 'Walgreens'){
                    pbl.Phoenix_Contract_Mngment_Fee_Wholesaler__c = pbl.Phoenix_Contract_Mngment_Fee_Wholesaler__c!=null?pbl.Phoenix_Contract_Mngment_Fee_Wholesaler__c-acc.Phoenix_Order_Analytics_Fee__c:acc.Phoenix_CM_Fees__c-acc.Phoenix_Order_Analytics_Fee__c ;
                } else{
                    pbl.Phoenix_Contract_Mngment_Fee_Wholesaler__c = pbl.Phoenix_Contract_Mngment_Fee_Wholesaler__c!=null?pbl.Phoenix_Contract_Mngment_Fee_Wholesaler__c:acc.Phoenix_CM_Fees__c ;
                    
                } 
                if (bidWrapper.bid.Phoenix_Customer_Type__c != 'BASE/DSH' ){
                    if(acc.Phoenix_Local_VIP__c != null)
                        pbl.Phoenix_Local_VIP__c = acc.Phoenix_Local_VIP__c ;
                    pbl.Phoenix_Indirect_CD_Per__c=(acc.Phoenix_Indirect_Cash_Discount__c!=null && acc.Phoenix_Indirect_Cash_Discount__c>0) ?acc.Phoenix_Indirect_Cash_Discount__c:acc.Phoenix_Cash_Discount__c;
                }
                else{
                    pbl.Phoenix_Local_VIP__c = bidWrapper.bid.Phoenix_Proposed_Value_Est_VIP__c ;
                    pbl.Phoenix_Indirect_CD_Per__c=bidWrapper.bid.Phoenix_Current_CD__c ;
                }
                if (bidWrapper.bid.Phoenix_Bid_Type__c == 'Short Dated OTB' || bidWrapper.bid.Phoenix_Bid_Type__c == 'Good Dated OTB'){
                    pbl.Phoenix_Indirect_CD_Per__c=bidWrapper.bid.Phoenix_Current_CD__c ;
                }
                if (bidWrapper.bid.Phoenix_Template_Type__c == 'Indirect' && acc.AccountNumber == '370337'){
                    pbl.Phoenix_Proposed_Current_Rebate__c = acc.Phoenix_Rebate_Secondary_Template__c;
                    pbl.Phoenix_Current_Admin_Fee__c = acc.Phoenix_Admin_Fee_Sec_Template__c;
                    pbl.Phoenix_Current_Rebate__c = acc.Phoenix_Rebate_Secondary_Template__c;
                    
                }
            }
            */
            /*if (bidWrapper.bid.Phoenix_Bid_Type__c == 'Short Dated OTB' || bidWrapper.bid.Phoenix_Bid_Type__c == 'Good Dated OTB' || bidWrapper.bid.Phoenix_Bid_Type__c == 'Platform OTB' || bidWrapper.bid.Phoenix_Bid_Type__c == 'Platform PO OTB'){
                if(acc.AccountNumber == '117866'){
                	pbl.Phoenix_Proposed_Current_Rebate__c = acc.Phoenix_Fee__c;
                } 
            }
            if(bidWrapper.bid.Phoenix_Bid_Type__c == 'Platform OTB' || bidWrapper.bid.Phoenix_Bid_Type__c == 'Platform PO OTB'){
               if(acc.AccountNumber != '117866'){
                	pbl.Phoenix_Proposed_Current_Rebate__c = acc.Phoenix_Rebates__c;
                } 
            }*/
            //added by srimayee start
            if(acc.AccountNumber == '164498'){
                List<Phoenix_NPR_Data__c> nprList = nprDataMap.get( pbl.Product__c) != null ? nprDataMap.get( pbl.Product__c) : null;
                system.debug('nprList=='+nprList);
                if(nprList != null){
                        for(Phoenix_NPR_Data__c npr : nprList){
                            String identifier = npr.Phoenix_Material_Number__c+'_'+npr.Phoenix_Contract_Number__c;
                            List<Phoenix_Inclusion_Contract_Pharmabid__c> custList =exContractsMap.get(npr.Phoenix_Contract_Number__c);
                            for(Phoenix_Inclusion_Contract_Pharmabid__c cust :custList){
                                if(cptMap.get(identifier) == 'Secondary' && cust.Group_Customer_Name__r.Name != null){
                                   String temp = 'All members of '+ cust.Group_Customer_Name__r.Name; 
                                    custNamesMap.put(identifier,temp);  
                                }
                                else if(cptMap.get(identifier) == 'Secondary'){
                                     custNamesMap.put(identifier,cust.Customer_Name__r.Name);   
                                }
                                if(cptMap.get(identifier) == 'Primary' && cust.Group_Customer_Name__r.Name != null){
                                    String temp = 'All members of '+ cust.Group_Customer_Name__r.Name; 
                                    custNamesMap.put(identifier,temp);  
                                }
                                else if(cptMap.get(identifier) == 'Primary'){
                                   custNamesMap.put(identifier,cust.Customer_Name__r.Name);   
                                }
                                
                                
                            }
                        }
                          for(Phoenix_NPR_Data__c npr : nprList){
                        String identifier = npr.Phoenix_Material_Number__c+'_'+npr.Phoenix_Contract_Number__c;
                         system.debug('identifier=='+identifier);
                        set<String> custNameSet = new set<String>();
                        custNameSet.addAll(contractsMap.get(npr.Phoenix_Contract_Number__c)); 
                              if(cptMap.get(identifier) == 'Primary' ){
                             system.debug('Primary=='+custNamesMap.get(identifier));
                            if(pbl.Primary_Exclusion_Customers__c != null && pbl.Primary_Exclusion_Customers__c != null && !pbl.Primary_Exclusion_Customers__c.contains(custNamesMap.get(identifier))){
                            pbl.Primary_Exclusion_Customers__c = pbl.Primary_Exclusion_Customers__c+', '+custNamesMap.get(identifier);    
                            }
                            else{
                             pbl.Primary_Exclusion_Customers__c = custNamesMap.get(identifier);
                            }
                            for(String str :custNameSet){
                            if(pbl.Primary_Grp_Exclusion_Customers__c != null && pbl.Primary_Grp_Exclusion_Customers__c != null && !pbl.Primary_Grp_Exclusion_Customers__c.contains(str.trim())){
                             //   prd.Primary_Grp_Exclusion_Customers__c = prd.Primary_Grp_Exclusion_Customers__c + ', '+ String.join(new List<String>(custNameSet),',');
                                 pbl.Primary_Grp_Exclusion_Customers__c = pbl.Primary_Grp_Exclusion_Customers__c + ', '+str;   
                                }
                           
                            else{
                                pbl.Primary_Grp_Exclusion_Customers__c = str;//String.join(new List<String>(custNameSet),', ');
                                
                            }
                           }  
                        }
                        if(cptMap.get(identifier) == 'Secondary'){
                            system.debug('secondary=='+custNamesMap.get(identifier));
                             if(pbl.Secondary_Backup_Exclusion_Customers__c != null && pbl.Secondary_Backup_Exclusion_Customers__c != null && !pbl.Secondary_Backup_Exclusion_Customers__c.contains(custNamesMap.get(identifier))){
                            pbl.Secondary_Backup_Exclusion_Customers__c = pbl.Secondary_Backup_Exclusion_Customers__c+', '+custNamesMap.get(identifier);    
                            }
                            else{
                             pbl.Secondary_Backup_Exclusion_Customers__c = custNamesMap.get(identifier);
                            }
                            for(String str :custNameSet){

                            if(pbl.Secondary_Backup_Grp_Exclusion_Customers__c != null && pbl.Secondary_Backup_Exclusion_Customers__c != null && !pbl.Secondary_Backup_Grp_Exclusion_Customers__c.contains(custNamesMap.get(identifier))){
                                
                                // prd.Secondary_Backup_Grp_Exclusion_Customers__c = prd.Secondary_Backup_Grp_Exclusion_Customers__c + ', '+ String.join(new List<String>(custNameSet),',');
                                pbl.Secondary_Backup_Grp_Exclusion_Customers__c = pbl.Secondary_Backup_Grp_Exclusion_Customers__c + ', '+str;   

                            }
                            else{
                               // prd.Secondary_Backup_Grp_Exclusion_Customers__c = String.join(new List<String>(custNameSet),', ');
                               pbl.Secondary_Backup_Grp_Exclusion_Customers__c = str; 
                            }
                            }
                        }
                               
                      /*   identifier = identifier + '_' +cptMap.get(identifier);
                               if(custNamesMap.get(identifier) != null && custNamesMap.get(identifier).contains('Primary')) {
                                   //opp.Secondary_Backup_Grp_Exclusion_Customers__c   
                               }     
                               if(custNamesMap.get(identifier) != null && custNamesMap.get(identifier).contains('Secondary')) {
                                   opp.Secondary_Backup_Grp_Exclusion_Customers__c = custNamesMap.get(identifier);
                                   //opp.Secondary_Backup_Grp_Exclusion_Customers__c   
                               } */
                        pbl.Final_Exclusion_Customers__c = pbl.Primary_Exclusion_Customers__c;
                    }
                    }
            }
            //code by srimayee end
            newItems.add(pbl);
        }
           
        if (newItems.size() > 0) {
            insert newItems;
        }
        
        
        //added by satya
      /*  String query = '';
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
        }*/
        
        //query = 'select ' + strFields + ' from ' + SobjectApiName + ' where Id = : newItems ORDER BY Phoenix_Product_Family__c ASC';
       // List < Phoenix_Bid_Line_Item__c > bidLineItemsList = Database.query(query);
        //List < Phoenix_Bid_Line_Item__c > bidlinesList = new List < Phoenix_Bid_Line_Item__c > ();
        Decimal Annualized_TP_Impact = 0;
        //Map < String, List < Phoenix_Bid_Line_Item__c > > productFamilyLines = new Map < String, List < Phoenix_Bid_Line_Item__c > > ();
        /*for (Phoenix_Bid_Line_Item__c bidline: bidLineItemsList) {
            if (bidline.Phoenix_Product_Family__c != null && !productFamilyLines.containsKey(bidline.Phoenix_Product_Family__c)) {
                bidlinesList.add(bidline);
                productFamilyLines.put(bidline.Phoenix_Product_Family__c, bidlinesList);
            } else if (bidline.Phoenix_Product_Family__c != null) {
                bidlinesList.add(bidline);
                productFamilyLines.put(bidline.Phoenix_Product_Family__c, bidlinesList);
            }
        }*/
        
        
        //if (productFamilyLines != null) {
            
          //  for (Product_Opportunity__c bidline: bidLineItemsList) {                Annualized_TP_Impact += bidline.Budgeted_ASP__c;
          //  }
       // }
        //List<Wrapper> wrapperList = new List<Wrapper>();
        
        //end by satya
        
        //ROSS LOGIC for new child records by Ashok.
        //Phoenix_BidLineItemExtn__c> bidLineItemExtList
       /* if (bidWrapper.bid.Phoenix_Customer_Type__c == 'ROS'){
            for(Phoenix_Bid_Line_Item__c itemObj : bidLineItemsList){
                Phoenix_BidLineItemExtn__c bidLineItemExtObj = new Phoenix_BidLineItemExtn__c();
                bidLineItemExtObj.Phoenix_Bid_Line_Item__c = itemObj.Id;
                bidLineItemExtObj.Phoenix_Preferred_Cardinal_Rebate_per__c = acc.Phoenix_Rebates__c;
                bidLineItemExtObj.Phoenix_Major_Rebate_per__c = acc.Phoenix_Rebates__c;
                bidLineItemExtList.add(bidLineItemExtObj);
            }
            if (bidLineItemExtList.size() > 0) {
                insert bidLineItemExtList;
            }
        }*/
        
        //Updating the Bid Phoenix_Reference_Contracts__c fields with selected contracts names
        String selectedContNames = '';
        if (!selectrcs.isEmpty()) {
            List < String > selectrcsWithoutDup = new List < String > ();
            selectedContNames = String.isNotBlank(bidWrapper.oppty.Vision_Reference_Contract__c) && bidWrapper.oppty.Vision_Reference_Contract__c != null ? bidWrapper.oppty.Vision_Reference_Contract__c : '';
            system.debug('selectedContNames--->'+selectedContNames);
            for (String s: selectrcs) {
                if (string.isNotBlank(selectedContNames) && !selectedContNames.contains(s)) {
                    selectrcsWithoutDup.add(s);
                }
            }
            if (string.isNotBlank(selectedContNames) && !selectrcsWithoutDup.isEmpty()) selectedContNames += ',';
            if (string.isBlank(selectedContNames)) {                selectedContNames += string.join(selectrcs, ',');
            } else {                selectedContNames += string.join(selectrcsWithoutDup, ',');
            }
            Opportunity opptyRec = new Opportunity(id = bidWrapper.oppty.Id, Vision_Reference_Contract__c = selectedContNames);
            update opptyRec;
        }
        // This below code for Contract View 
        List < String > bidTypes = new List < String > {
            'Price Change',
                'Customer Rebate Change',
                'Volume Review Only',
                'Sales Out Rebate'
                };
                    /*String bidType = bidWrapper.bid.Phoenix_Bid_Type__c;
        String templateType = bidWrapper.bid.Phoenix_Customer_Type__c;
        if (String.isNotBlank(bidType) && bidTypes.contains(bidType)) {
            if (String.isNotBlank(templateType) && (templateType == 'Walgreens' || templateType == 'ABC Progen' || templateType == 'Econdisc' || templateType == 'Costco' || templateType == 'Sams Club' || templateType == 'Net Indirect Pricing' || templateType == 'Government Pricing')) {
                Phoenix_WalgreensCls.getNPRData(selectedContNames.split(','), bidId, templateType);
            } else if (templateType == 'RXSS') {  Phoenix_WalgreensCls.getNPRDataRXSS(selectedContNames.split(','), bidId, templateType);
            } 
            else if (templateType == 'BASE/DSH') { Phoenix_WalgreensCls.getNPRDataDSH(selectedContNames.split(','), bidId, templateType);
            }
            else if (templateType == 'ClarusOne') {
                system.debug('In c1 getNpr method');
                Phoenix_ClarusOneCls.getNPRData(selectedContNames.split(','), bidId, templateType);
            } 
            else if (templateType == 'ABC Pharmagen') {
                Phoenix_WalgreensCls.getNPRDataABCPharmagen(selectedContNames.split(','), bidId, templateType);
            } 
            else if (templateType == 'ROS') {
                system.debug('In ROS getNpr method');
                Phoenix_RosController.getNPRData(selectedContNames.split(','), bidId, templateType);
            } 
            else {
                Phoenix_BidLineItemEditDemoCls.getNPRData(selectedContNames.split(','), bidId, templateType);
            }
        }*/
        //logic for other bid types if products added after added contracts
       /* else {
            string contracts = bidWrapper.bid.Phoenix_Reference_Contracts__c;
            if (string.isNotBlank(contracts)) {
                if (String.isNotBlank(templateType) && ( templateType == 'Walgreens' || templateType == 'ABC Progen' || templateType == 'Econdisc' || templateType == 'Costco' || templateType == 'Sams Club' || templateType == 'Net Indirect Pricing' || templateType == 'Government Pricing')) {
                    Phoenix_WalgreensCls.getNPRData(contracts.split(','), bidId, templateType);
                } else if (templateType == 'RXSS') {
                    
                    Phoenix_WalgreensCls.getNPRDataRXSS(contracts.split(','), bidId, templateType);
                } 
                else if (templateType == 'BASE/DSH') {
                    
                    Phoenix_WalgreensCls.getNPRDataDSH(contracts.split(','), bidId, templateType);
                }
                else if (templateType == 'ClarusOne') {
                    system.debug('In c1 getNpr method');
                    Phoenix_ClarusOneCls.getNPRData(contracts.split(','), bidId, templateType);
                } 
                else if (templateType == 'ABC Pharmagen') {Phoenix_WalgreensCls.getNPRDataABCPharmagen(contracts.split(','), bidId, templateType);
}
                else if (templateType == 'ROS') {
                    Phoenix_RosController.getNPRData(selectedContNames.split(','), bidId, templateType);
                } 
                else {
                    Phoenix_BidLineItemEditDemoCls.getNPRData(contracts.split(','), bidId, templateType);
                }
            }
            
        }*/
        
        return newItems;
    }
    @AuraEnabled
    public static List < wrapperClass > findBySrxOtc(List < String > searchKey, list < string > SearchKeyWordPD, string searchName, string family, List < wrapperClass > productList, BidWrapper quotewrap) {
        List < wrapperClass > wralist = new List < wrapperClass > ();
        list < string > searchupdateList = new list < string > ();
        list < Product2 > prodNameList = new list < Product2 > ();
        /* Added to avoid Duplicate Production */
        List < wrapperClass > wrExistingProdlist = new List < wrapperClass > ();
        Set < Id > duplicatePrdCheck = new Set < Id > ();
        wrExistingProdlist = Vision_OpportunityCreatorCtrl.showselectedProducts(oppty.Id);
        for (wrapperClass wr: wrExistingProdlist) {
            duplicatePrdCheck.add(wr.prdlist.Id);
        }
        String query1;
        String searchText;
        string searchfamily;
        List < String > searchList;
        if (string.isNotBlank(family)) {
            searchfamily = family.trim();
            searchfamily = '%' + searchfamily + '%';
        }
        
        if (string.isNotBlank(searchName)) {
            searchText = searchName.trim();
            searchText = searchText.replace('\\s+', ' ');
            prodNameList = [select Id, Name from Product2 where IsActive = true AND Phoenix_Is_Exclude_Bid__c = false AND Name =: searchText];
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
        list < Product2 > productItemList;
        if (searchKey != null && !searchKey.isEmpty()) {
            query1 = 'SELECT Id,Product_Family__r.Name, Phoenix_Product_Director__r.Name,Phoenix_Date_of_Discontinuation__c ,Phoenix_Product_Type_for_CM_Fee__c,Phoenix_Rx_SRx_OTC__c,Name,ProductCode,Phoenix_NDC_11__c,Phoenix_GCN_Generic_Code_Number__c,Phoenix_GCN_Sequence_Number__c,Phoenix_NDC_11_Dashes__c,Phoenix_GPI_Generic_Product_Identifier__c,Phoenix_GPI_Dashes__c,Family,Phoenix_Strength__c,Phoenix_Pkg_Size__c,Phoenix_WAC__c,Phoenix_Product_Director__c,Phoenix_Compare_to_Brand_Name__c FROM Product2 WHERE (IsActive = true AND Phoenix_Is_Exclude_Bid__c=false AND Phoenix_Rx_SRx_OTC__c like :searchKey  AND ID not in:duplicatePrdCheck) ORDER BY Name ASC NULLS LAST LIMIT 30000';
            
            productItemList = Database.query(query1);
        }
        if (string.isNotBlank(family) && productItemList.size() > 0) {
            string query2;
            query2 = 'SELECT Id,Product_Family__r.Name, Phoenix_Product_Director__r.Name,Phoenix_Date_of_Discontinuation__c ,Phoenix_Rx_SRx_OTC__c,Name,ProductCode,Phoenix_NDC_11__c,Phoenix_GCN_Generic_Code_Number__c,Phoenix_GCN_Sequence_Number__c,Phoenix_NDC_11_Dashes__c,Phoenix_GPI_Generic_Product_Identifier__c,Phoenix_Product_Type_for_CM_Fee__c,Phoenix_GPI_Dashes__c,Family,Phoenix_Strength__c,Phoenix_Pkg_Size__c,Phoenix_WAC__c,Phoenix_Product_Director__c,Phoenix_Compare_to_Brand_Name__c FROM Product2 WHERE ( Family like :searchfamily AND ID IN:productItemList  AND ID not in:duplicatePrdCheck) ORDER BY Name ASC NULLS LAST LIMIT 30000';
            productItemList = Database.query(query2);
        }
        if (productItemList.size() > 0 && string.isNotBlank(searchName)) {
            string query3;
            query3 = 'SELECT Id,Product_Family__r.Name, Phoenix_Product_Director__r.Name,Phoenix_Date_of_Discontinuation__c ,Phoenix_Product_Type_for_CM_Fee__c,Phoenix_Rx_SRx_OTC__c,Name,ProductCode,Phoenix_NDC_11__c,Phoenix_GCN_Generic_Code_Number__c,Phoenix_GCN_Sequence_Number__c,Phoenix_NDC_11_Dashes__c,Phoenix_GPI_Generic_Product_Identifier__c,Phoenix_GPI_Dashes__c,Family,Phoenix_Strength__c,Phoenix_Pkg_Size__c,Phoenix_WAC__c,Phoenix_Product_Director__c,Phoenix_Compare_to_Brand_Name__c FROM Product2 WHERE (ID IN:productItemList AND (Name like :searchupdateList OR Phoenix_NDC_11__c like :searchupdateList OR Phoenix_Compare_to_Brand_Name__c like :searchupdateList OR Phoenix_UPC_Universal_Product_Code__c like :searchupdateList OR ProductCode like :searchupdateList OR Phoenix_NDC_11_Dashes__c like :searchupdateList OR Phoenix_GPI_Generic_Product_Identifier__c like :searchupdateList OR Phoenix_GPI_Dashes__c like :searchupdateList OR Phoenix_GCN_Generic_Code_Number__c like :searchupdateList OR Phoenix_GCN_Sequence_Number__c like :searchupdateList)  AND ID not in:duplicatePrdCheck) ORDER BY Name ASC NULLS LAST LIMIT 30000';
            productItemList = Database.query(query3);
        }
        if (productItemList.size() > 0 && SearchKeyWordPD != null && !SearchKeyWordPD.isEmpty()) {
            string query4;
            query4 = 'SELECT Id,Product_Family__r.Name, Phoenix_Product_Director__r.Name,Phoenix_Date_of_Discontinuation__c ,Phoenix_Product_Type_for_CM_Fee__c,Phoenix_Rx_SRx_OTC__c,Name,ProductCode,Phoenix_NDC_11__c,Phoenix_GCN_Generic_Code_Number__c,Phoenix_GCN_Sequence_Number__c,Phoenix_NDC_11_Dashes__c,Phoenix_GPI_Generic_Product_Identifier__c,Phoenix_GPI_Dashes__c,Family,Phoenix_Strength__c,Phoenix_Pkg_Size__c,Phoenix_WAC__c,Phoenix_Product_Director__c,Phoenix_Compare_to_Brand_Name__c FROM Product2 WHERE (ID IN:productItemList AND Phoenix_Product_Director__r.Name like :SearchKeyWordPD  AND ID not in:duplicatePrdCheck) ORDER BY Name ASC NULLS LAST LIMIT 30000';
            productItemList = Database.query(query4);
        }
        
        system.debug('productList----' + productList);
        Map < Id, Product2 > productMap = new map < Id, Product2 > (productItemList);
        for (wrapperClass w: productList) {
            if (productMap.containskey(w.prdlist.Id))
                wralist.add(w);
            
        }
        system.debug('wralist----' + wralist);
        
        
        return wralist;
        
    }
    
    @AuraEnabled
    public static List < wrapperClass > fetchSortResults(string sortField, boolean isAsc, List < wrapperClass > productList) {
        set < Id > prodIds = new set < Id > ();
        list < Product2 > sortResults = new list < Product2 > ();
        List < wrapperClass > wrlist = new List < wrapperClass > ();
        for (wrapperClass w: productList) {
            prodIds.add(w.prdlist.Id);
            
        }
        String sSoql = 'SELECT Phoenix_Product_Director__r.Name,Product_Family__r.Name, Phoenix_Date_of_Discontinuation__c,Phoenix_Product_Type_for_CM_Fee__c,Phoenix_Rx_SRx_OTC__c,Name,Id,ProductCode,Phoenix_NDC_11__c,Phoenix_GCN_Generic_Code_Number__c,Phoenix_GCN_Sequence_Number__c,Phoenix_NDC_11_Dashes__c,Phoenix_GPI_Generic_Product_Identifier__c,Phoenix_GPI_Dashes__c,Family,Phoenix_Strength__c,Phoenix_Pkg_Size__c,Phoenix_WAC__c,Phoenix_Product_Director__c,Phoenix_Compare_to_Brand_Name__c FROM Product2 WHERE ID IN:prodIds';
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
    
    public class BidWrapper {
        @AuraEnabled
        public Opportunity oppty{get;set;}
       
        @AuraEnabled
        public Boolean isBidCreated{get;set;}
        
        public BidWrapper() {
            oppty = new Opportunity();
        }
    }
    
    public class wrapperClass {
        @AuraEnabled
        public Product2 prdlist{get;set;}
        
        @AuraEnabled
        public Product_Opportunity__c qlItem{get;set;}
        
        @AuraEnabled
        public Phoenix_Contract__c contrt{get;set;}
        
        @AuraEnabled
        public String prodName{get;set;}
        
        @AuraEnabled
        public String custName{get;set;}
        
        @AuraEnabled
        public String family{get;set;}
        
        @AuraEnabled
        public Decimal IPAPrice{get;set;}
        
        @AuraEnabled
        public String NDC{get;set;}
        
        @AuraEnabled
        public String currencyCode{get;set;}
        
        @AuraEnabled
        public Boolean isSelected{get;set;}
        
        @AuraEnabled
        public Boolean contrFlag{get;set;}
    }
}