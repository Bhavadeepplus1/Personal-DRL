/**
 * @description       : 
 * @author            : Mamatha Neela(Dhruvsoft)
 * This controller is referenced in Bid WAC Change process(i.e.,used in Pheonix_BidWACChangeController apex class).
 **/
public class Phoenix_BidWACCreatorCtrl {
    public static Phoenix_Bid__c bid;
    public static BidWrapper wrapper;
    public static List<ContentDocumentLink> conDocLink;        
    
    
    static{
        bid = new Phoenix_Bid__c();
        wrapper = new BidWrapper();
        conDocLink=new List<ContentDocumentLink>();
    }
    
    @AuraEnabled
    public static BidWrapper getbidInfo(String recordId){
        String SobjectApiName = 'Phoenix_Bid__c';
        String query ='';
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Map<String, Schema.SObjectField> fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();
        String strFields = '';
        for(String fieldName : fieldMap.keyset() )
        {
            if(strFields == null || strFields == '')
            {
                strFields = fieldName;
            }
            else{
                strFields = strFields + ' , ' + fieldName;
            }  
        }
        query = 'select'+' '+ strFields + ' '+'from' +' '+SobjectApiName+' '+'where Id =:recordId LIMIT 1';
        
        
        
        BidWrapper wrapperCls = new BidWrapper();
        if (recordId != null)
            wrapperCls.bid = Database.query(query);
        List<ContentDocumentLink> entries=[SELECT Id, LinkedEntityId, ContentDocument.Title,ContentDocument.FileExtension,ContentDocumentId FROM ContentDocumentLink where LinkedEntityId=:recordId];
        wrapperCls.conDocLink=entries;
        
        
        Map<String, String> userTeamUserIdMap = new Map<String, String>();
        for(Phoenix_User_Approval_Matrix__c matrix : [Select Id, Name,RecordType.DeveloperName,Phoenix_Approver__r.Name,User_Group__r.Phoenix_Approver_Group_Name__c, Phoenix_Approval_Group_Behavior__c,Phoenix_Approver__c,Phoenix_Approver__r.Email,Phoenix_Approver_Group_Name__c,Phoenix_Is_Active_User__c,Phoenix_Is_Approval_Process_User__c,User_Group__c from Phoenix_User_Approval_Matrix__c limit 1000]){
            String userTeamUserIdMapKey = matrix.User_Group__r.Phoenix_Approver_Group_Name__c+'-'+ matrix.Phoenix_Approver__c;
            userTeamUserIdMap.put(userTeamUserIdMapKey, matrix.Phoenix_Approver__r.Name);
        }
        string isBusinessApprovePerson;
        string isCountryApprovePerson;
        
        string isFinanceApprovePerson;
        string isContractsApprovePerson;
        if(userTeamUserIdMap.containsKey('Business Head-'+UserInfo.getUserId())){
            isBusinessApprovePerson=userTeamUserIdMap.get(('Business Head-'+UserInfo.getUserId()));
        }
        if(userTeamUserIdMap.containsKey('Country Head-'+UserInfo.getUserId())){
            isCountryApprovePerson=userTeamUserIdMap.get(('Country Head-'+UserInfo.getUserId()));
        }
        if(userTeamUserIdMap.containsKey('Finance-'+UserInfo.getUserId())){
            isFinanceApprovePerson=userTeamUserIdMap.get(('Finance-'+UserInfo.getUserId()));
        }
        if(userTeamUserIdMap.containsKey('Contracts-'+UserInfo.getUserId())){
            isContractsApprovePerson=userTeamUserIdMap.get(('Contracts-'+UserInfo.getUserId()));
        }
        
        wrapperCls.loggedInUserId=UserInfo.getName();
        wrapperCls.approvalStatus=bid.Phoenix_Approval_Status__c;
        
        wrapperCls.isBusinessApprovePerson=isBusinessApprovePerson;
        wrapperCls.isCountryApprovePerson=isCountryApprovePerson;
        wrapperCls.isFinanceApprovePerson=isFinanceApprovePerson;
        wrapperCls.isContractsApprovePerson=isContractsApprovePerson;
        return wrapperCls;
    }
    
    @AuraEnabled
    public static list<Phoenix_Bid_Line_Item__c> saveQuoteItems(list<wrapperClass> saveitems, BidWrapper bidWrapper){
        list<Phoenix_Bid_Line_Item__c> newItems = new list<Phoenix_Bid_Line_Item__c>();
        list<Product2>prodList;
        list<Phoenix_Bid_Fee_Master__c>feeList=new list<Phoenix_Bid_Fee_Master__c>();        
        string bidId=bidWrapper.bid.Id;
        system.debug('bidId--------'+bidId);
        Id accountId=bidWrapper.bid.Phoenix_Customer__c;
        system.debug('accountId--------'+accountId);
        Account acc;
        if(accountId!=null){
            acc=[select Id,Phoenix_Is_Govt_Customer__c,Phoenix_Preferred_Wholesaler__c from Account where Id=:accountId];
            feeList=[select Id,Phoenix_Customer_Type__c,Phoenix_Fee__c,Phoenix_Preferred_Wholesaler__c,Phoenix_Fee_Type__c,Phoenix_Product_Type_for_CM_Fee__c from Phoenix_Bid_Fee_Master__c where Phoenix_Preferred_Wholesaler__c=:acc.Phoenix_Preferred_Wholesaler__c limit 30000];     
        }
        for (wrapperClass wr : saveitems){
            Phoenix_Bid_Line_Item__c pbl=new Phoenix_Bid_Line_Item__c();
            if(wr.qlItem.Phoenix_New_WAC__c!=null){
                System.debug('----------saveitems-----wac----'+wr.qlItem.Phoenix_New_WAC__c);
                pbl.Phoenix_New_WAC__c= wr.qlItem.Phoenix_New_WAC__c;  
            }
           /* if(wr.qlItem.Phoenix_Effective_Date__c!=null){
                System.debug('----------saveitems-----wac----'+wr.qlItem.Phoenix_New_WAC__c);
                pbl.Phoenix_Effective_Date__c= wr.qlItem.Phoenix_Effective_Date__c;  
            }*/
            pbl.Phoenix_Bid__c = bidId;
            pbl.Phoenix_Product__c=wr.prdlist.Id;
            pbl.Phoenix_Product_Family1__c=wr.prdlist.family;
            pbl.Product_Family__c=wr.prdlist.Product_Family__c;
            pbl.Phoenix_Pkg_Size1__c=wr.prdlist.Phoenix_Pkg_Size__c;
            pbl.Phoenix_WAC1__c=wr.prdlist.Phoenix_WAC__c;
            pbl.Phoenix_Throughput_Cost1__c=wr.prdlist.Phoenix_Throughput_Cost__c;
            pbl.Phoenix_Product_Director1__c=wr.prdlist.Phoenix_Product_Director__c;
            pbl.Phoenix_Compare_To_Brand_Name1__c=wr.prdlist.Phoenix_Compare_To_Brand_Name__c;
            pbl.Phoenix_Case_Pack1__c=wr.prdlist.Phoenix_Case_Pack__c;
            newItems.add(pbl);
        }
        if (newItems.size() > 0){
            system.debug('In saving methods'+newItems);
            upsert newItems;
        }
        return newItems;
    }
    @AuraEnabled
    public static list<Phoenix_Bid_Line_Item__c> editQuoteItems(list<wrapperClass> saveitems, BidWrapper bidWrapper, date effDt){
        system.debug('=============saveitems============'+saveitems);
        list<Phoenix_Bid_Line_Item__c> newItems = new list<Phoenix_Bid_Line_Item__c>();
        
        string bidId=bidWrapper.bid.Id;
        system.debug('bidId--------'+bidId);
        Id accountId=bidWrapper.bid.Phoenix_Customer__c;
        system.debug('accountId--------'+accountId);
        Account acc;
        for (wrapperClass wr : saveitems){
            Phoenix_Bid_Line_Item__c pbl=new Phoenix_Bid_Line_Item__c();
            Phoenix_Bid_Line_Item__c test=[SELECT Id,Name FROM Phoenix_Bid_Line_Item__c WHERE Id=:wr.qlItem.Id];
            system.debug('=============test============'+test);
            pbl.Id = test.Id;
            pbl.Phoenix_New_WAC__c = wr.qlItem.Phoenix_New_WAC__c;
            pbl.Phoenix_Effective_Date__c=effDt;
            newItems.add(pbl);
        }
        if (newItems.size()> 0){
            system.debug('In saving methods'+newItems);
            update newItems;
        }
        return newItems;
    } 
    
    
    @AuraEnabled
    public static List<wrapperClass> showselectedProducts(string bidId){
        list<Phoenix_Bid_Line_Item__c>bidlineList=[select Id,Phoenix_Product__c from Phoenix_Bid_Line_Item__c where Phoenix_Bid__c=:bidId];
        list<Product2>productList=new list<Product2>();
        list<wrapperClass>wrapList=new list<wrapperClass>();
        set<Id>prodIds=new set<Id>();
        if(bidlineList.size()>0){
            for(Phoenix_Bid_Line_Item__c pbl: bidlineList){
                prodIds.add(pbl.Phoenix_Product__c);  
            }
        }
        if(prodIds.size()>0){
            productList=[select Name,Family, Product_Family__r.Name, Product_Family__c from Product2 where Id IN:prodIds ORDER BY Name ASC NULLS LAST LIMIT 30000];
            
            for(Product2 pr:productList){
                wrapperClass wr =new wrapperClass();
                wr.prdlist=pr;
                wrapList.add(wr);
            }
        }
        
        return wrapList;
        
    }
    
     @AuraEnabled
    public static List<wrapperClass> getproducts1(BidWrapper quotewrap){
        
        Phoenix_Bid__c bid = quotewrap.bid;
        
        List<wrapperClass> wrlist = new List<wrapperClass>();
        String query ='';
        String SobjectApiName = 'Product2';
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Map<String, Schema.SObjectField> fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();
        List<wrapperClass> wrExistingProdlist=new List<wrapperClass>();
		Set<Id> duplicatePrdCheck=new Set<Id>();
		wrExistingProdlist=Phoenix_BidWACCreatorCtrl.showselectedProducts(bid.Id);
        for(wrapperClass wr:wrExistingProdlist){
            duplicatePrdCheck.add(wr.prdlist.Id);
        }
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
            
         query = 'select Phoenix_Product_Director__r.Name,Phoenix_Product_Director__r.FirstName,Phoenix_Product_Director__r.LastName,Phoenix_Royalty_Partner_Name__r.Name,Phoenix_PS_Partner_2_Name__r.Name,Phoenix_PS_Partner_1_Name__r.Name, ' + strFields + ' from Product2 where (IsActive = true AND Phoenix_Is_Exclude_Bid__c=false AND ID not in:duplicatePrdCheck) ORDER BY Name ASC NULLS LAST LIMIT 30000'  ;   
     
        
        List<Product2> prlist = Database.query(query);
        
        Set<id> pids = new Set<id>();
        Map<Id, Product2> pdMap = new Map<Id, Product2>();
        for (Product2 pr : prlist){
            pids.add(pr.Id);
            pdMap.put(pr.Id, pr);
        }
        
        
        if (prlist.size() > 0){
            for (Product2 pr : prlist){
                wrapperClass wr = new wrapperClass();
                wr.prdlist = pr;
                if (pr.Phoenix_WAC__c!= null){
                    wr.currencyCode = '$';
                }
                
                wr.isSelected = false;
                wrlist.add(wr);
            }
        }
        
        return wrlist;
    }
    
    @AuraEnabled
    public static List<wrapperClass> getproductsrelatedtoBid(BidWrapper quotewrap){
        bid = quotewrap.bid;
        List<wrapperClass> wrlist = new List<wrapperClass>();
        list<Phoenix_Bid_Line_Item__c> ItemsList = new list<Phoenix_Bid_Line_Item__c>();
        ItemsList = [select Id, Phoenix_Product__c
                     from Phoenix_Bid_Line_Item__c
                     where Phoenix_Bid__c = :bid.Id];
        set<Id> productIds = new set<Id>();
        for (Phoenix_Bid_Line_Item__c pbl : ItemsList){
            productIds.add(pbl.Id);
            
        }
        String query;
       // If (ItemsList.size() > 0){
            query = 'SELECT Id,Phoenix_Product__c,Phoenix_Product__r.Name,Phoenix_Product_Code__c,Phoenix_Product_Family__c,Phoenix_Product_Family1__c,Phoenix_WAC__c,Phoenix_WAC1__c,Phoenix_NDC_National_Drug_Code__c,Phoenix_New_WAC__c,Phoenix_Effective_Date__c FROM Phoenix_Bid_Line_Item__c WHERE Id IN:productIds ORDER BY Name ASC NULLS LAST LIMIT 30000';
       // } else{
            // query = 'SELECT Phoenix_Product_Director__r.Name,Phoenix_Product_Type_for_CM_Fee__c,Phoenix_Rx_SRx_OTC__c,Name,Id,ProductCode,Phoenix_NDC_11__c,Phoenix_GCN_Generic_Code_Number__c,Phoenix_GCN_Sequence_Number__c,Phoenix_NDC_11_Dashes__c,Phoenix_GPI_Generic_Product_Identifier__c,Phoenix_GPI_Dashes__c,Family,Phoenix_Strength__c,Phoenix_Pkg_Size__c,Phoenix_WAC__c,Phoenix_Product_Director__c,Phoenix_Compare_to_Brand_Name__c FROM Product2 WHERE (IsActive = true AND Phoenix_Is_Exclude_Bid__c=false) ORDER BY Name ASC NULLS LAST LIMIT 30000';
      //  }
        List<Phoenix_Bid_Line_Item__c> prlist = Database.query(query);
        Set<id> pids = new Set<id>();
        Map<Id, Phoenix_Bid_Line_Item__c> pdMap = new Map<Id, Phoenix_Bid_Line_Item__c>();
        for (Phoenix_Bid_Line_Item__c pr : prlist){
            pids.add(pr.Id);
            pdMap.put(pr.Id, pr);
        }
        if (prlist.size() > 0){
            for (Phoenix_Bid_Line_Item__c pr : prlist){
                wrapperClass wr = new wrapperClass();
                wr.qlItem = pr;
                if (pr.Phoenix_WAC__c!= null){
                    wr.currencyCode = '$';
                }
                if (pr.Phoenix_New_WAC__c!= null){
                    wr.currencyCode1 = '$';
                }
                wrlist.add(wr);
            }
        }
        
        return wrlist;
    }
    @AuraEnabled
    public static List<string> getProductDirectorList(BidWrapper  bidwrap){
        Phoenix_Bid__c bid = bidwrap.bid;
        String query ='';
        String SobjectApiName = 'Product2';
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
        if(bid.Phoenix_Bid_Type__c=='IPA Floor Pricing Update'){
            query = 'select Phoenix_Product_Director__r.Name,' + strFields + ' from Product2 where (IsActive = true AND Phoenix_Is_Exclude_Bid__c=false AND Phoenix_Is_IPA_Product__c=true) ORDER BY Name ASC NULLS LAST LIMIT 30000 '  ;
        }
        else{
            query = 'select Phoenix_Product_Director__r.Name,' + strFields + ' from Product2 where (IsActive = true AND Phoenix_Is_Exclude_Bid__c=false) ORDER BY Name ASC NULLS LAST LIMIT 30000'  ;
            
        }
        list<Product2> quoteList =Database.query(query);
        system.debug('quoteList--->'+quoteList);
        
        
        List<String> productDirectorList = new List<String>();
        
        for(Product2 lineItem : quoteList  ){
            
            
            if(lineItem.Phoenix_Product_Director__r.Name!=null && !productDirectorList.contains(lineItem.Phoenix_Product_Director__r.Name)){
                productDirectorList.add(lineItem.Phoenix_Product_Director__r.Name);
            }
            
        }
        return productDirectorList;
        
        
    }
    
    
   @AuraEnabled
    public static List<wrapperClass> getsearchDirectorResult(List<wrapperClass> pItem, list<string> SearchKeyWordPD, string Family,string searchName,list<string>RxSrxList,BidWrapper quotewrap){
   
         List<wrapperClass> wralist = new List<wrapperClass>();
        list<string>searchupdateList=new list<string>();
        String query1;
        String searchText;
        string searchfamily;
        list<string>productDirectors=new list<string>();
        list<string>NewproductDirectors;
        string searchPD;
       /* Added to avoid Duplicate Production */
        List<wrapperClass> wrExistingProdlist=new List<wrapperClass>();
		Set<Id> duplicatePrdCheck=new Set<Id>();
		wrExistingProdlist=Phoenix_BidWACCreatorCtrl.showselectedProducts(bid.Id);
        for(wrapperClass wr:wrExistingProdlist){
            duplicatePrdCheck.add(wr.prdlist.Id);
        }   
        
        
        List<String> searchList;
        list<Product2>prodNameList=new list<Product2>();
         if(string.isNotBlank(Family)){
            searchfamily=Family.trim(); 
            
        }
       
        
        
        searchfamily='%'+searchfamily+'%';    
        
        
       // system.debug('searchText---'+searchText);
        
        
        if(string.isNotBlank(searchName)){
            searchText=searchName.trim(); 
            searchText=searchText.replace('\\s+',' ');
            
            
            if(quotewrap.bid.Phoenix_Bid_Type__c=='IPA Floor Pricing Update'){
                prodNameList=[select Id,Name from Product2 where IsActive = true AND Phoenix_Is_Exclude_Bid__c=false AND Phoenix_Is_IPA_Product__c=true  AND Name=:searchText];   
            }
            else{
                prodNameList=[select Id,Name from Product2 where IsActive = true AND Phoenix_Is_Exclude_Bid__c=false  AND Name=:searchText];
            }            if(prodNameList.size()==0){
                searchList = searchText.split(' ');
                for(string str:searchList){
                    string searchItem='%'+str+'%';
                    searchupdateList.add(searchItem);
                    
                }    
            }
            else{
                searchupdateList.add('%'+searchText+'%');  
            }
        }
        
        
        
        
        system.debug('searchupdateList----'+searchupdateList);
        
        
        
        
        
        
        system.debug('productIds---in else-');
        query1 = 'SELECT Id,Phoenix_Product_Director__r.Name,Phoenix_Date_of_Discontinuation__c ,Phoenix_Product_Type_for_CM_Fee__c,Phoenix_Rx_SRx_OTC__c,Name,ProductCode,Phoenix_NDC_11__c,Phoenix_GCN_Generic_Code_Number__c,Phoenix_GCN_Sequence_Number__c,Phoenix_NDC_11_Dashes__c,Phoenix_GPI_Generic_Product_Identifier__c,Phoenix_GPI_Dashes__c,Family,Phoenix_Strength__c,Phoenix_Pkg_Size__c,Phoenix_WAC__c,Phoenix_Product_Director__c,Phoenix_Compare_to_Brand_Name__c FROM Product2 WHERE (IsActive = true AND Phoenix_Is_Exclude_Bid__c=false AND Phoenix_Product_Director__r.Name like :SearchKeyWordPD  AND ID not in:duplicatePrdCheck) ORDER BY Name ASC NULLS LAST LIMIT 30000';
        
        list<Product2> productList =Database.query(query1);
        if(RxSrxList!=null && ! RxSrxList.isEmpty() &&productList.size()>0){
            string query2;
            query2 = 'SELECT Id,Phoenix_Product_Director__r.Name,Phoenix_Date_of_Discontinuation__c ,Phoenix_Product_Type_for_CM_Fee__c,Phoenix_Rx_SRx_OTC__c,Name,ProductCode,Phoenix_NDC_11__c,Phoenix_GCN_Generic_Code_Number__c,Phoenix_GCN_Sequence_Number__c,Phoenix_NDC_11_Dashes__c,Phoenix_GPI_Generic_Product_Identifier__c,Phoenix_GPI_Dashes__c,Family,Phoenix_Strength__c,Phoenix_Pkg_Size__c,Phoenix_WAC__c,Phoenix_Product_Director__c,Phoenix_Compare_to_Brand_Name__c FROM Product2 WHERE ( Phoenix_Rx_SRx_OTC__c like :RxSrxList AND ID IN:productList  AND ID not in:duplicatePrdCheck ) ORDER BY Name ASC NULLS LAST LIMIT 30000';   
            productList=Database.query(query2);    
        }
        if(productList.size()>0 && string.isNotBlank(searchName)){
            string query3;
            query3 = 'SELECT Id,Phoenix_Product_Director__r.Name,Phoenix_Date_of_Discontinuation__c ,Phoenix_Product_Type_for_CM_Fee__c,Phoenix_Rx_SRx_OTC__c,Name,ProductCode,Phoenix_NDC_11__c,Phoenix_GCN_Generic_Code_Number__c,Phoenix_GCN_Sequence_Number__c,Phoenix_NDC_11_Dashes__c,Phoenix_GPI_Generic_Product_Identifier__c,Phoenix_GPI_Dashes__c,Family,Phoenix_Strength__c,Phoenix_Pkg_Size__c,Phoenix_WAC__c,Phoenix_Product_Director__c,Phoenix_Compare_to_Brand_Name__c FROM Product2 WHERE (ID IN:productList AND (Name like :searchupdateList OR Phoenix_Compare_to_Brand_Name__c like :searchupdateList OR Phoenix_UPC_Universal_Product_Code__c like :searchupdateList OR Phoenix_NDC_11__c like :searchupdateList OR ProductCode like :searchupdateList OR Phoenix_NDC_11_Dashes__c like :searchupdateList OR Phoenix_GPI_Generic_Product_Identifier__c like :searchupdateList OR Phoenix_GPI_Dashes__c like :searchupdateList OR Phoenix_GCN_Generic_Code_Number__c like :searchupdateList OR Phoenix_GCN_Sequence_Number__c like :searchupdateList)  AND ID not in:duplicatePrdCheck ) ORDER BY Name ASC NULLS LAST LIMIT 30000';
            productList=Database.query(query3);   
        }
        if(productList.size()>0 && string.isNotBlank(Family)){
            string query4;
            query4 = 'SELECT Id,Phoenix_Product_Director__r.Name,Phoenix_Date_of_Discontinuation__c ,Phoenix_Product_Type_for_CM_Fee__c,Phoenix_Rx_SRx_OTC__c,Name,ProductCode,Phoenix_NDC_11__c,Phoenix_GCN_Generic_Code_Number__c,Phoenix_GCN_Sequence_Number__c,Phoenix_NDC_11_Dashes__c,Phoenix_GPI_Generic_Product_Identifier__c,Phoenix_GPI_Dashes__c,Family,Phoenix_Strength__c,Phoenix_Pkg_Size__c,Phoenix_WAC__c,Phoenix_Product_Director__c,Phoenix_Compare_to_Brand_Name__c FROM Product2 WHERE (ID IN:productList AND IsActive = true AND Phoenix_Is_Exclude_Bid__c=false AND Product_Family__r.Name like :searchfamily) ORDER BY Name ASC NULLS LAST LIMIT 30000';
            productList=Database.query(query4);   
        }
        
        system.debug('productList----'+productList);
        Map<Id,Product2>productMap=new map<Id,Product2>(productList);
        for(wrapperClass w : pItem){
            if (productMap.containskey(w.prdlist.Id))
                wralist.add(w);
            
        }
        system.debug('wralist----'+wralist);
        
        
        return wralist;
    }
    
   @AuraEnabled
    public static List<wrapperClass> getSearch(List<wrapperClass> pItem, list<string> SearchKeyWordPD,string search, string family,list<string>RxSrxList,BidWrapper quotewrap){
        
        List<wrapperClass> wralist1 = new List<wrapperClass>();
        String searchText = search.trim();
        string searchfamily;
        /* Added to avoid Duplicate Production */
        List<wrapperClass> wrExistingProdlist=new List<wrapperClass>();
		Set<Id> duplicatePrdCheck=new Set<Id>();
		wrExistingProdlist=Phoenix_BidWACCreatorCtrl.showselectedProducts(bid.Id);
        for(wrapperClass wr:wrExistingProdlist){
            duplicatePrdCheck.add(wr.prdlist.Id);
        }  
        if(string.isNotBlank(family)){
            searchfamily=family.trim(); 
            
        }
        searchfamily='%'+searchfamily+'%';    
        
        //searchText=searchText.replace('-','');
        system.debug('searchText---'+searchText);
        searchText=searchText.replace('\\s+',' ');
        system.debug('searchText---'+searchText);
        set<Id> RxProdIds=new set<Id>();
        list<string>searchupdateList=new list<string>();
        String query1;
        list<Product2>prodNameList=new list<Product2>();
        if(quotewrap.bid.Phoenix_Bid_Type__c=='IPA Floor Pricing Update'){
            prodNameList=[select Id,Name from Product2 where IsActive = true AND Phoenix_Is_Exclude_Bid__c=false AND Phoenix_Is_IPA_Product__c=true  AND Name=:searchText  AND ID not in:duplicatePrdCheck];   
        }
        else{
            prodNameList=[select Id,Name from Product2 where IsActive = true AND Phoenix_Is_Exclude_Bid__c=false  AND Name=:searchText  AND ID not in:duplicatePrdCheck];
        }
        if(prodNameList.size()==0){
            List<String> searchList = searchText.split(' ');
            for(string str:searchList){
                string searchItem='%'+str+'%';
                searchupdateList.add(searchItem);
                
            }    
        }
        else{
            searchupdateList.add('%'+searchText+'%');  
        }
        system.debug('searchupdateList----'+searchupdateList);
        
        
        
        
        query1 = 'SELECT Id,Phoenix_Product_Director__r.Name,Phoenix_Date_of_Discontinuation__c ,Phoenix_Product_Type_for_CM_Fee__c,Phoenix_Rx_SRx_OTC__c,Name,ProductCode,Phoenix_NDC_11__c,Phoenix_GCN_Generic_Code_Number__c,Phoenix_GCN_Sequence_Number__c,Phoenix_NDC_11_Dashes__c,Phoenix_GPI_Generic_Product_Identifier__c,Phoenix_GPI_Dashes__c,Family,Phoenix_Strength__c,Phoenix_Pkg_Size__c,Phoenix_WAC__c,Phoenix_Product_Director__c,Phoenix_Compare_to_Brand_Name__c FROM Product2 WHERE ((IsActive = true AND Phoenix_Is_Exclude_Bid__c=false ) AND(Name like :searchupdateList OR Phoenix_Compare_to_Brand_Name__c like :searchupdateList OR Phoenix_UPC_Universal_Product_Code__c like :searchupdateList OR Phoenix_NDC_11__c like :searchupdateList OR ProductCode like :searchupdateList OR Phoenix_NDC_11_Dashes__c like :searchupdateList OR Phoenix_GPI_Generic_Product_Identifier__c like :searchupdateList OR Phoenix_GPI_Dashes__c like :searchupdateList OR Phoenix_GCN_Generic_Code_Number__c like :searchupdateList OR Phoenix_GCN_Sequence_Number__c like :searchupdateList OR Product_Family__r.Name like :searchupdateList )  AND ID not in:duplicatePrdCheck ) ORDER BY Name ASC NULLS LAST LIMIT 30000';
        
        list<Product2> productList =Database.query(query1);
        if(RxSrxList!=null && ! RxSrxList.isEmpty() && productList.size()>0){
            string query2;
            query2 = 'SELECT Id,Phoenix_Product_Director__r.Name,Phoenix_Date_of_Discontinuation__c ,Phoenix_Product_Type_for_CM_Fee__c,Phoenix_Rx_SRx_OTC__c,Name,ProductCode,Phoenix_NDC_11__c,Phoenix_GCN_Generic_Code_Number__c,Phoenix_GCN_Sequence_Number__c,Phoenix_NDC_11_Dashes__c,Phoenix_GPI_Generic_Product_Identifier__c,Phoenix_GPI_Dashes__c,Family,Phoenix_Strength__c,Phoenix_Pkg_Size__c,Phoenix_WAC__c,Phoenix_Product_Director__c,Phoenix_Compare_to_Brand_Name__c FROM Product2 WHERE ( Phoenix_Rx_SRx_OTC__c like :RxSrxList AND ID IN:productList  AND ID not in:duplicatePrdCheck ) ORDER BY Name ASC NULLS LAST LIMIT 30000';   
            productList=Database.query(query2);    
        }
        if(productList.size()>0 && string.isNotBlank(family)){
            string query3;
            query3 = 'SELECT Id,Phoenix_Product_Director__r.Name,Phoenix_Date_of_Discontinuation__c ,Phoenix_Product_Type_for_CM_Fee__c,Phoenix_Rx_SRx_OTC__c,Name,ProductCode,Phoenix_NDC_11__c,Phoenix_GCN_Generic_Code_Number__c,Phoenix_GCN_Sequence_Number__c,Phoenix_NDC_11_Dashes__c,Phoenix_GPI_Generic_Product_Identifier__c,Phoenix_GPI_Dashes__c,Family,Phoenix_Strength__c,Phoenix_Pkg_Size__c,Phoenix_WAC__c,Phoenix_Product_Director__c,Phoenix_Compare_to_Brand_Name__c FROM Product2 WHERE (ID IN:productList AND Product_Family__r.Name like :searchfamily AND ID not in:duplicatePrdCheck ) ORDER BY Name ASC NULLS LAST LIMIT 30000';
            productList=Database.query(query3);   
        }
          if(productList.size()>0 && SearchKeyWordPD!=null && ! SearchKeyWordPD.isEmpty()){
            string query4;
            query4 = 'SELECT Id,Phoenix_Product_Director__r.Name,Phoenix_Date_of_Discontinuation__c ,Phoenix_Product_Type_for_CM_Fee__c,Phoenix_Rx_SRx_OTC__c,Name,ProductCode,Phoenix_NDC_11__c,Phoenix_GCN_Generic_Code_Number__c,Phoenix_GCN_Sequence_Number__c,Phoenix_NDC_11_Dashes__c,Phoenix_GPI_Generic_Product_Identifier__c,Phoenix_GPI_Dashes__c,Family,Phoenix_Strength__c,Phoenix_Pkg_Size__c,Phoenix_WAC__c,Phoenix_Product_Director__c,Phoenix_Compare_to_Brand_Name__c FROM Product2 WHERE (ID IN:productList AND Phoenix_Product_Director__r.Name like :SearchKeyWordPD  AND ID not in:duplicatePrdCheck) ORDER BY Name ASC NULLS LAST LIMIT 30000';
            productList=Database.query(query4);   
        }
        
        Map<Id,Product2>productMap=new map<Id,Product2>(productList);
        for(wrapperClass w : pItem){
            if (productMap.containskey(w.prdlist.Id))
                wralist1.add(w);
            
        }
        
        return wralist1; 
    }
    
    
    @AuraEnabled
    public static List<wrapperClass> getSearchFamily(List<wrapperClass> pItem,list<string> SearchKeyWordPD, string search,string searchName,list<string>RxSrxList,BidWrapper quotewrap){
        
        List<wrapperClass> wralist = new List<wrapperClass>();
        list<string>searchupdateList=new list<string>();
        String query1;
        String searchText;
        string searchfamily;
        List<String> searchList;
        list<Product2>prodNameList=new list<Product2>();
        if(string.isNotBlank(search)){
            searchfamily=search.trim();
        }
        
        
        searchfamily='%'+searchfamily+'%';    
        
        
        system.debug('searchfamily---'+searchfamily);
        
        
        if(string.isNotBlank(searchName)){
            searchText=searchName.trim(); 
            searchText=searchText.replace('\\s+',' ');
            
            
            if(quotewrap.bid.Phoenix_Bid_Type__c=='IPA Floor Pricing Update'){
                prodNameList=[select Id,Name from Product2 where IsActive = true AND Phoenix_Is_Exclude_Bid__c=false AND Phoenix_Is_IPA_Product__c=true  AND Name=:searchText];   
            }
            else{
                prodNameList=[select Id,Name from Product2 where IsActive = true AND Phoenix_Is_Exclude_Bid__c=false  AND Name=:searchText];
            }            if(prodNameList.size()==0){
                searchList = searchText.split(' ');
                for(string str:searchList){
                    string searchItem='%'+str+'%';
                    searchupdateList.add(searchItem);
                    
                }    
            }
            else{
                searchupdateList.add('%'+searchText+'%');  
            }
        }
        
        
        
        
        system.debug('searchupdateList----'+searchupdateList);
        
        
        
        
        
        list<Product2> productList=new list<Product2>();
        system.debug('productIds---in else-');
        if(string.isNotBlank(search)){
            query1 = 'SELECT Id,Phoenix_Product_Director__r.Name,Phoenix_Date_of_Discontinuation__c ,Phoenix_Product_Type_for_CM_Fee__c,Phoenix_Rx_SRx_OTC__c,Name,ProductCode,Phoenix_NDC_11__c,Phoenix_GCN_Generic_Code_Number__c,Phoenix_GCN_Sequence_Number__c,Phoenix_NDC_11_Dashes__c,Phoenix_GPI_Generic_Product_Identifier__c,Phoenix_GPI_Dashes__c,Family,Phoenix_Strength__c,Phoenix_Pkg_Size__c,Phoenix_WAC__c,Phoenix_Product_Director__c,Phoenix_Compare_to_Brand_Name__c FROM Product2 WHERE (IsActive = true AND Phoenix_Is_Exclude_Bid__c=false AND Product_Family__r.Name like :searchfamily) ORDER BY Name ASC NULLS LAST LIMIT 30000';
            
            productList =Database.query(query1);
        }
        
        if(RxSrxList!=null && ! RxSrxList.isEmpty()){
            if(productList.size()>0){
                string query2;
                query2 = 'SELECT Id,Phoenix_Product_Director__r.Name,Phoenix_Date_of_Discontinuation__c ,Phoenix_Product_Type_for_CM_Fee__c,Phoenix_Rx_SRx_OTC__c,Name,ProductCode,Phoenix_NDC_11__c,Phoenix_GCN_Generic_Code_Number__c,Phoenix_GCN_Sequence_Number__c,Phoenix_NDC_11_Dashes__c,Phoenix_GPI_Generic_Product_Identifier__c,Phoenix_GPI_Dashes__c,Family,Phoenix_Strength__c,Phoenix_Pkg_Size__c,Phoenix_WAC__c,Phoenix_Product_Director__c,Phoenix_Compare_to_Brand_Name__c FROM Product2 WHERE ( Phoenix_Rx_SRx_OTC__c like :RxSrxList AND ID IN:productList ) ORDER BY Name ASC NULLS LAST LIMIT 30000';   
                productList=Database.query(query2);    
            }
            /*else{
string query2;
query2 = 'SELECT Id,Phoenix_Product_Director__r.Name,Phoenix_Date_of_Discontinuation__c ,Phoenix_Product_Type_for_CM_Fee__c,Phoenix_Rx_SRx_OTC__c,Name,ProductCode,Phoenix_NDC_11__c,Phoenix_GCN_Generic_Code_Number__c,Phoenix_GCN_Sequence_Number__c,Phoenix_NDC_11_Dashes__c,Phoenix_GPI_Generic_Product_Identifier__c,Phoenix_GPI_Dashes__c,Family,Phoenix_Strength__c,Phoenix_Pkg_Size__c,Phoenix_WAC__c,Phoenix_Product_Director__c,Phoenix_Compare_to_Brand_Name__c FROM Product2 WHERE ( Phoenix_Rx_SRx_OTC__c like :RxSrxList) ORDER BY Name ASC NULLS LAST LIMIT 30000';   
productList=Database.query(query2);    
}*/
        }
        if(string.isNotBlank(searchName)){
            if(productList.size()>0){
                string query3;
                query3 = 'SELECT Id,Phoenix_Product_Director__r.Name,Phoenix_Date_of_Discontinuation__c ,Phoenix_Product_Type_for_CM_Fee__c,Phoenix_Rx_SRx_OTC__c,Name,ProductCode,Phoenix_NDC_11__c,Phoenix_GCN_Generic_Code_Number__c,Phoenix_GCN_Sequence_Number__c,Phoenix_NDC_11_Dashes__c,Phoenix_GPI_Generic_Product_Identifier__c,Phoenix_GPI_Dashes__c,Family,Phoenix_Strength__c,Phoenix_Pkg_Size__c,Phoenix_WAC__c,Phoenix_Product_Director__c,Phoenix_Compare_to_Brand_Name__c FROM Product2 WHERE (ID IN:productList AND (Name like :searchupdateList OR Phoenix_Compare_to_Brand_Name__c like :searchupdateList OR Phoenix_UPC_Universal_Product_Code__c like :searchupdateList OR Phoenix_NDC_11__c like :searchupdateList OR ProductCode like :searchupdateList OR Phoenix_NDC_11_Dashes__c like :searchupdateList OR Phoenix_GPI_Generic_Product_Identifier__c like :searchupdateList OR Phoenix_GPI_Dashes__c like :searchupdateList OR Phoenix_GCN_Generic_Code_Number__c like :searchupdateList OR Phoenix_GCN_Sequence_Number__c like :searchupdateList)) ORDER BY Name ASC NULLS LAST LIMIT 30000';
                productList=Database.query(query3);   
            }
            /*else{
string query3;
query3 = 'SELECT Id,Phoenix_Product_Director__r.Name,Phoenix_Date_of_Discontinuation__c ,Phoenix_Product_Type_for_CM_Fee__c,Phoenix_Rx_SRx_OTC__c,Name,ProductCode,Phoenix_NDC_11__c,Phoenix_GCN_Generic_Code_Number__c,Phoenix_GCN_Sequence_Number__c,Phoenix_NDC_11_Dashes__c,Phoenix_GPI_Generic_Product_Identifier__c,Phoenix_GPI_Dashes__c,Family,Phoenix_Strength__c,Phoenix_Pkg_Size__c,Phoenix_WAC__c,Phoenix_Product_Director__c,Phoenix_Compare_to_Brand_Name__c FROM Product2 WHERE ( (Name like :searchupdateList OR Phoenix_Compare_to_Brand_Name__c like :searchupdateList OR Phoenix_UPC_Universal_Product_Code__c like :searchupdateList OR Phoenix_NDC_11__c like :searchupdateList OR ProductCode like :searchupdateList OR Phoenix_NDC_11_Dashes__c like :searchupdateList OR Phoenix_GPI_Generic_Product_Identifier__c like :searchupdateList OR Phoenix_GPI_Dashes__c like :searchupdateList OR Phoenix_GCN_Generic_Code_Number__c like :searchupdateList OR Phoenix_GCN_Sequence_Number__c like :searchupdateList)) ORDER BY Name ASC NULLS LAST LIMIT 30000';
productList=Database.query(query3);    
}*/
        }
        if( SearchKeyWordPD!=null && ! SearchKeyWordPD.isEmpty()){
            if(productList.size()>0){
                string query4;
                query4 = 'SELECT Id,Phoenix_Product_Director__r.Name,Phoenix_Date_of_Discontinuation__c ,Phoenix_Product_Type_for_CM_Fee__c,Phoenix_Rx_SRx_OTC__c,Name,ProductCode,Phoenix_NDC_11__c,Phoenix_GCN_Generic_Code_Number__c,Phoenix_GCN_Sequence_Number__c,Phoenix_NDC_11_Dashes__c,Phoenix_GPI_Generic_Product_Identifier__c,Phoenix_GPI_Dashes__c,Family,Phoenix_Strength__c,Phoenix_Pkg_Size__c,Phoenix_WAC__c,Phoenix_Product_Director__c,Phoenix_Compare_to_Brand_Name__c FROM Product2 WHERE (ID IN:productList AND Phoenix_Product_Director__r.Name like :SearchKeyWordPD) ORDER BY Name ASC NULLS LAST LIMIT 30000';
                productList=Database.query(query4);   
            }
            /*else{
string query4;
query4 = 'SELECT Id,Phoenix_Product_Director__r.Name,Phoenix_Date_of_Discontinuation__c ,Phoenix_Product_Type_for_CM_Fee__c,Phoenix_Rx_SRx_OTC__c,Name,ProductCode,Phoenix_NDC_11__c,Phoenix_GCN_Generic_Code_Number__c,Phoenix_GCN_Sequence_Number__c,Phoenix_NDC_11_Dashes__c,Phoenix_GPI_Generic_Product_Identifier__c,Phoenix_GPI_Dashes__c,Family,Phoenix_Strength__c,Phoenix_Pkg_Size__c,Phoenix_WAC__c,Phoenix_Product_Director__c,Phoenix_Compare_to_Brand_Name__c FROM Product2 WHERE ( Phoenix_Product_Director__r.Name like :SearchKeyWordPD) ORDER BY Name ASC NULLS LAST LIMIT 30000';
productList=Database.query(query4); 
}*/
        }
        
        system.debug('productList----'+productList);
        Map<Id,Product2>productMap=new map<Id,Product2>(productList);
        for(wrapperClass w : pItem){
            if (productMap.containskey(w.prdlist.Id))
                wralist.add(w);
            
        }
        system.debug('wralist----'+wralist);
        
        
        return wralist;
    }
    @AuraEnabled
    public static List<wrapperClass>findBySrxOtc(List<String> searchKey,list<string> SearchKeyWordPD,string searchName,string family,List<wrapperClass> productList,BidWrapper quotewrap){
        List<wrapperClass> wralist = new List<wrapperClass>();
        list<string>searchupdateList=new list<string>();
        list<Product2>prodNameList=new list<Product2>();
        String query1;
        String searchText;
        string searchfamily;
        List<String> searchList;
        if(string.isNotBlank(family)){
            searchfamily=family.trim();
            searchfamily='%'+searchfamily+'%'; 
        }
        
        //searchText=searchText.replace('-','');
        system.debug('searchText---'+searchText);
        
        
        
        if(string.isNotBlank(searchName)){
            searchText=searchName.trim(); 
            searchText=searchText.replace('\\s+',' ');
            
            if(quotewrap.bid.Phoenix_Bid_Type__c=='IPA Floor Pricing Update'){
                prodNameList=[select Id,Name from Product2 where IsActive = true AND Phoenix_Is_Exclude_Bid__c=false AND Phoenix_Is_IPA_Product__c=true  AND Name=:searchText];   
            }
            else{
                prodNameList=[select Id,Name from Product2 where IsActive = true AND Phoenix_Is_Exclude_Bid__c=false  AND Name=:searchText];
            }            if(prodNameList.size()==0){
                searchList = searchText.split(' ');
                for(string str:searchList){
                    string searchItem='%'+str+'%';
                    searchupdateList.add(searchItem);
                    
                }    
            }
            else{
                searchupdateList.add('%'+searchText+'%');  
            }
        }
        
        
        
        
        system.debug('searchupdateList----'+searchupdateList);
        
        
        
        
        
        
        
        list<Product2> productItemList;
        system.debug('productIds---in else-');
        if(searchKey!=null && !searchKey.isEmpty()){
            query1 = 'SELECT Id,Phoenix_Product_Director__r.Name,Phoenix_Date_of_Discontinuation__c ,Phoenix_Product_Type_for_CM_Fee__c,Phoenix_Rx_SRx_OTC__c,Name,ProductCode,Phoenix_NDC_11__c,Phoenix_GCN_Generic_Code_Number__c,Phoenix_GCN_Sequence_Number__c,Phoenix_NDC_11_Dashes__c,Phoenix_GPI_Generic_Product_Identifier__c,Phoenix_GPI_Dashes__c,Family,Phoenix_Strength__c,Phoenix_Pkg_Size__c,Phoenix_WAC__c,Phoenix_Product_Director__c,Phoenix_Compare_to_Brand_Name__c FROM Product2 WHERE (IsActive = true AND Phoenix_Is_Exclude_Bid__c=false AND Phoenix_Rx_SRx_OTC__c like :searchKey) ORDER BY Name ASC NULLS LAST LIMIT 30000';
            
            productItemList =Database.query(query1);
        }
        if( string.isNotBlank(family) &&productItemList.size()>0){
            string query2;
            query2 = 'SELECT Id,Phoenix_Product_Director__r.Name,Phoenix_Date_of_Discontinuation__c ,Phoenix_Rx_SRx_OTC__c,Name,ProductCode,Phoenix_NDC_11__c,Phoenix_GCN_Generic_Code_Number__c,Phoenix_GCN_Sequence_Number__c,Phoenix_NDC_11_Dashes__c,Phoenix_GPI_Generic_Product_Identifier__c,Phoenix_Product_Type_for_CM_Fee__c,Phoenix_GPI_Dashes__c,Family,Phoenix_Strength__c,Phoenix_Pkg_Size__c,Phoenix_WAC__c,Phoenix_Product_Director__c,Phoenix_Compare_to_Brand_Name__c FROM Product2 WHERE ( Product_Family__r.Name like :searchfamily AND ID IN:productItemList) ORDER BY Name ASC NULLS LAST LIMIT 30000';
            productItemList=Database.query(query2);    
        }
        if(productItemList.size()>0 && string.isNotBlank(searchName)){
            string query3;
            query3 = 'SELECT Id,Phoenix_Product_Director__r.Name,Phoenix_Date_of_Discontinuation__c ,Phoenix_Product_Type_for_CM_Fee__c,Phoenix_Rx_SRx_OTC__c,Name,ProductCode,Phoenix_NDC_11__c,Phoenix_GCN_Generic_Code_Number__c,Phoenix_GCN_Sequence_Number__c,Phoenix_NDC_11_Dashes__c,Phoenix_GPI_Generic_Product_Identifier__c,Phoenix_GPI_Dashes__c,Family,Phoenix_Strength__c,Phoenix_Pkg_Size__c,Phoenix_WAC__c,Phoenix_Product_Director__c,Phoenix_Compare_to_Brand_Name__c FROM Product2 WHERE (ID IN:productItemList AND (Name like :searchupdateList OR Phoenix_NDC_11__c like :searchupdateList OR Phoenix_Compare_to_Brand_Name__c like :searchupdateList OR Phoenix_UPC_Universal_Product_Code__c like :searchupdateList OR ProductCode like :searchupdateList OR Phoenix_NDC_11_Dashes__c like :searchupdateList OR Phoenix_GPI_Generic_Product_Identifier__c like :searchupdateList OR Phoenix_GPI_Dashes__c like :searchupdateList OR Phoenix_GCN_Generic_Code_Number__c like :searchupdateList OR Phoenix_GCN_Sequence_Number__c like :searchupdateList)) ORDER BY Name ASC NULLS LAST LIMIT 30000';
            productItemList=Database.query(query3);   
        }
        if(productItemList.size()>0 && SearchKeyWordPD!=null && ! SearchKeyWordPD.isEmpty()){
            string query4;
            query4 = 'SELECT Id,Phoenix_Product_Director__r.Name,Phoenix_Date_of_Discontinuation__c ,Phoenix_Product_Type_for_CM_Fee__c,Phoenix_Rx_SRx_OTC__c,Name,ProductCode,Phoenix_NDC_11__c,Phoenix_GCN_Generic_Code_Number__c,Phoenix_GCN_Sequence_Number__c,Phoenix_NDC_11_Dashes__c,Phoenix_GPI_Generic_Product_Identifier__c,Phoenix_GPI_Dashes__c,Family,Phoenix_Strength__c,Phoenix_Pkg_Size__c,Phoenix_WAC__c,Phoenix_Product_Director__c,Phoenix_Compare_to_Brand_Name__c FROM Product2 WHERE (ID IN:productItemList AND Phoenix_Product_Director__r.Name like :SearchKeyWordPD) ORDER BY Name ASC NULLS LAST LIMIT 30000';
            productItemList=Database.query(query4);   
        }
        
        system.debug('productList----'+productList);
        Map<Id,Product2>productMap=new map<Id,Product2>(productItemList);
        for(wrapperClass w : productList){
            if (productMap.containskey(w.prdlist.Id))
                wralist.add(w);
            
        }
        system.debug('wralist----'+wralist);
        
        
        return wralist;  
        
    }
    
    @AuraEnabled
    public static List<wrapperClass> fetchSortResults(string sortField,boolean isAsc,List<wrapperClass> productList){
        set<Id> prodIds=new set<Id>();
        list<Product2>sortResults=new list<Product2>();
        List<wrapperClass> wrlist = new List<wrapperClass>();
        for (wrapperClass w : productList){
            prodIds.add(w.prdlist.Id);
            
        }
        String sSoql = 'SELECT Phoenix_Product_Director__r.Name,Phoenix_Date_of_Discontinuation__c,Phoenix_Product_Type_for_CM_Fee__c,Phoenix_Rx_SRx_OTC__c,Name,Id,ProductCode,Phoenix_NDC_11__c,Phoenix_GCN_Generic_Code_Number__c,Phoenix_GCN_Sequence_Number__c,Phoenix_NDC_11_Dashes__c,Phoenix_GPI_Generic_Product_Identifier__c,Phoenix_GPI_Dashes__c,Family,Phoenix_Strength__c,Phoenix_Pkg_Size__c,Phoenix_WAC__c,Phoenix_Product_Director__c,Phoenix_Compare_to_Brand_Name__c FROM Product2 WHERE ID IN:prodIds';
        if(sortField!=null && sortField!=''){
            sSoql += ' order by ' + sortField;
            if(isAsc){
                sSoql += ' ASC '; 
            }
            else{
                sSoql += ' DESC ';
            }    
        }
        sSoql += ' NULLS LAST LIMIT 100 ';
        sortResults=Database.query(sSoql);
        for(Product2 pr:sortResults){
            for(wrapperClass wr:productList){
                if(wr.prdlist.Id==pr.Id){
                    wrlist.add(wr);   
                    
                }
            }
        }
        
        return wrlist;  
    }
    
    
    
    
    public class BidWrapper{
        @AuraEnabled
        public Phoenix_Bid__c bid{ get; set; }
        
        @AuraEnabled
        public Boolean isBidCreated{ get; set; }
        @AuraEnabled public List<ContentDocumentLink> conDocLink{ get; set; }
        @AuraEnabled public string approvalStatus{ get; set; }
        
        @AuraEnabled public string isBusinessApprovePerson{ get; set; }
        @AuraEnabled public string isCountryApprovePerson{ get; set; }
        @AuraEnabled public string isFinanceApprovePerson{ get; set; }
        @AuraEnabled public string isContractsApprovePerson{ get; set; }
        @AuraEnabled public string loggedInUserId;
        
        public BidWrapper(){
            bid = new Phoenix_Bid__c();
        }
    }
    public class wrapperClass{
        @AuraEnabled
        public Product2 prdlist{ get; set; }
        @AuraEnabled
        public Phoenix_Bid_Line_Item__c qlItem{ get; set; }
        @AuraEnabled
        public String prodName{ get; set; }
        @AuraEnabled
        public String custName{ get; set; }
        @AuraEnabled
        public String family{ get; set; }
        @AuraEnabled
        public Decimal IPAPrice{ get; set; }
        @AuraEnabled
        public String NDC{ get; set; }
        @AuraEnabled
        public String currencyCode{ get; set; }
        @AuraEnabled
        public String currencyCode1{ get; set; }
        @AuraEnabled
        public Boolean isSelected{ get; set; }
        
        
    }
}