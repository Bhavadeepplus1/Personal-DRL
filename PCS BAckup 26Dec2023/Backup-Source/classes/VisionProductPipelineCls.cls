public without sharing class VisionProductPipelineCls {
    public List < Product_Pipeline__c > pipelineData {get;set;}
    public List < Product_Pipeline__c > pplist {
        get;
        set;
    }
    @AuraEnabled
    public static List<Account> getAccountInPreview(String accountId){
        List<Account> accountList = [SELECT ID, Name ,BillingAddress,BillingCity,BillingCountry,BillingPostalCode,BillingState,BillingStreet FROM Account WHERE Id =: accountId ];
        return accountList;
    }
    
    @AuraEnabled
    public static PipelineWrap getProductPipelines() {
        List<String> apexClassList = new List<String>();
        apexClassList.add('GoogleProductPipelineDataFetch');
        
       PipelineWrap wrap = new PipelineWrap ();
        wrap.isProcessed =  Vision_Rx_Compliance_NPR.apexJobStatus(apexClassList);

       
        String query = '';
        String SobjectApiName = 'Product_Pipeline__c';
        Map < String, Schema.SObjectType > schemaMap = Schema.getGlobalDescribe();
        Map < String, Schema.SObjectField > fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();
        List < wrapperClass > wrExistingProdlist = new List < wrapperClass > ();
        Set < Id > duplicatePrdCheck = new Set < Id > ();
        String strFields = '';
       List<Product_Pipeline__c> pipelineList = [SELECT Id,GCP_Updated_Date__c,Vision_Updated_Date__c FROM Product_Pipeline__c LIMIT 1];
        for (String fieldName: fieldMap.keyset()) {
            if (strFields == null || strFields == '') {
                strFields = fieldName;
            } else {
                strFields = strFields + ' , ' + fieldName;
            }
        }        
        query = 'select ' + strFields + ' from Product_Pipeline__c ORDER BY Vision_GCP_Product_Family__c ASC NULLS LAST';
        List < Product_Pipeline__c > prlist = Database.query(query);
        Set < id > pids = new Set < id > ();
        Map < Id, Product_Pipeline__c > pdMap = new Map < Id, Product_Pipeline__c > ();
        for (Product_Pipeline__c pr: prlist) {
            pids.add(pr.Id);
            pdMap.put(pr.Id, pr);
        }
        wrap.prismUpdateDate = pipelineList[0].GCP_Updated_Date__c;
        wrap.visionUpdateDate = pipelineList[0].Vision_Updated_Date__c;
        wrap.pipelineList = prlist;
        return wrap;
    }
    
    @AuraEnabled
    public static List < Product_Pipeline__c > fetchSortResults(string sortField, boolean isAsc, List < Product_Pipeline__c > productList) {
        set < Id > prodIds = new set < Id > ();
        list < Product_Pipeline__c > sortResults = new list < Product_Pipeline__c > ();
        List < Product_Pipeline__c > wrlist = new List < Product_Pipeline__c > ();
        String SobjectApiName = 'Product_Pipeline__c';
        Map < String, Schema.SObjectType > schemaMap = Schema.getGlobalDescribe();
        Map < String, Schema.SObjectField > fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();
        for (Product_Pipeline__c w: productList) {
         
            prodIds.add(w.Id);
            
        }
        String strFields = '';
        
        for (String fieldName: fieldMap.keyset()) {
            if (strFields == null || strFields == '') {
                strFields = fieldName;
            } else {
                strFields = strFields + ' , ' + fieldName;
            }
        }
        
        String sSoql = 'select ' + strFields + ' from Product_Pipeline__c WHERE ID IN:prodIds';
        if (sortField != null && sortField != '') {
            sSoql += ' order by ' + sortField;
            if (isAsc) {
                sSoql += ' ASC NULLS LAST';
            } else {
                sSoql += ' DESC NULLS LAST';
            }
        } 
        //sSoql += ' NULLS LAST LIMIT 100 ';
        sortResults = Database.query(sSoql);
        for (Product_Pipeline__c pr: sortResults) {
            for (Product_Pipeline__c wr: productList) {
                if (wr.Id == pr.Id) {
                    wrlist.add(wr);
                    
                }
            }
        }
        
        return wrlist;
    }
    
    @AuraEnabled
    public static List < Product_Pipeline__c > getSearch(List < Product_Pipeline__c > pItem, string search, list < string > RxSrxList) {
        
        List < Product_Pipeline__c > wralist1 = new List < Product_Pipeline__c > ();
        String searchText = search.trim();
        string searchfamily;
        /* Added to avoid Duplicate Production */
        List < Product_Pipeline__c > wrExistingProdlist = new List < Product_Pipeline__c > ();
        Set < Id > duplicatePrdCheck = new Set < Id > ();
        for (Product_Pipeline__c wr: wrExistingProdlist) {
            duplicatePrdCheck.add(wr.Id);
        }
        
        //searchText=searchText.replace('-','');
       
        searchText = searchText.replace('\\s+', ' ');
     
        set < Id > RxProdIds = new set < Id > ();
        list < string > searchupdateList = new list < string > ();
        String query1;
        list < Product_Pipeline__c > prodNameList = new list < Product_Pipeline__c > ();
        
        prodNameList = [select Id, Vision_GCP_Product_Family__c from Product_Pipeline__c where Vision_GCP_Product_Family__c =: searchText AND ID not in: duplicatePrdCheck];
        
        if (prodNameList.size() == 0) {
            List < String > searchList = searchText.split(' ');
            for (string str: searchList) {
                string searchItem = '%' + str + '%';
                searchupdateList.add(searchItem);
                
            }
        } else {
            searchupdateList.add('%' + searchText + '%');
        }
        
        String SobjectApiName = 'Product_Pipeline__c';
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
        
        
        query1 = 'SELECT '+strFields+' FROM Product_Pipeline__c WHERE ((Vision_GCP_Product_Family__c like :searchupdateList) AND ID not in:duplicatePrdCheck ) ORDER BY Vision_GCP_Product_Family__c ASC NULLS LAST LIMIT 30000';
        
        list < Product_Pipeline__c > productList = Database.query(query1);
        if (RxSrxList != null && !RxSrxList.isEmpty() && productList.size() > 0) {
            string query2;            
            query2 = 'SELECT '+strFields+' FROM Product_Pipeline__c WHERE ( Vision_GCP_Product_Family__c like :RxSrxList AND ID IN:productList  AND ID not in:duplicatePrdCheck ) ORDER BY Vision_GCP_Product_Family__c ASC NULLS LAST LIMIT 30000';
            productList = Database.query(query2);
        }
        
        Map < Id, Product_Pipeline__c > productMap = new map < Id, Product_Pipeline__c > (productList);
        for (Product_Pipeline__c w: pItem) {            
            if (productMap.containskey(w.Id)) 
                wralist1.add(w);
        }
        return wralist1;
    }
    
  /*  @AuraEnabled
    public static List < Product_Pipeline__c > findBySrxOtc(List < String > searchKey,string searchName, List < Product_Pipeline__c > productList) {
        List < Product_Pipeline__c > wralist = new List < Product_Pipeline__c > ();
        list < string > searchupdateList = new list < string > ();
        list < Product_Pipeline__c > prodNameList = new list < Product_Pipeline__c > ();
        List < Product_Pipeline__c > wrExistingProdlist = new List < Product_Pipeline__c > ();
        Set < Id > duplicatePrdCheck = new Set < Id > ();
        for (Product_Pipeline__c wr: wrExistingProdlist) {
            duplicatePrdCheck.add(wr.Id);
        }
        String query1;
        String searchText;
        List < String > searchList;
        system.debug('searchText---' + searchText);
        if (string.isNotBlank(searchName)) {
            searchText = searchName.trim();
            searchText = searchText.replace('\\s+', ' ');
            prodNameList = [select Id, Vision_GCP_Product_Family__c from Product_Pipeline__c where Vision_GCP_Product_Family__c =: searchText];
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
        String SobjectApiName = 'Product_Pipeline__c';
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
        list < Product_Pipeline__c > productItemList;
        if (searchKey != null && !searchKey.isEmpty()) {
            query1 = 'SELECT '+strFields+' FROM Product_Pipeline__c WHERE (Vision_Segment__c like :searchKey  AND ID not in:duplicatePrdCheck) ORDER BY Vision_GCP_Product_Family__c ASC NULLS LAST LIMIT 30000';
            
            productItemList = Database.query(query1);
        }
        if (searchKey == null || searchKey.size() == 0) {
            query1 = 'SELECT '+strFields+' FROM Product_Pipeline__c WHERE (ID not in:duplicatePrdCheck) ORDER BY Vision_GCP_Product_Family__c ASC NULLS LAST LIMIT 30000';
            
            productItemList = Database.query(query1);
        }
        if (productItemList.size() > 0 && string.isNotBlank(searchName)) {
            string query3;
            query3 = 'SELECT '+strFields+' FROM Product_Pipeline__c WHERE (ID IN:productItemList AND Name like :searchupdateList AND ID not in:duplicatePrdCheck) ORDER BY Vision_GCP_Product_Family__c ASC NULLS LAST LIMIT 30000';
            productItemList = Database.query(query3);
        }
        
       
        Map < Id, Product_Pipeline__c > productMap = new map < Id, Product_Pipeline__c > (productItemList);
        for (Product_Pipeline__c w: productList) {
            if (productMap.containskey(w.Id))
                wralist.add(w);
            
        }
       
        
        
        return wralist;
        
    } */
    
    @AuraEnabled
    public static string generateDocument(List<Product_Pipeline__c> ppList) {
    
        string ids='';        
       if(ppList!=null && ppList.size()>0 ){
            for(Product_Pipeline__c rec: ppList)
                ids+=rec.Id+','; 
            
        }
        
       PageReference pageRef= Page.Generate_Pdf;
       // PageReference pageRef = new PageReference('/apex/Generate_Pdf');
        pageRef.getParameters().put('id',ids);
        String endUrl = '';
             if(!test.isRunningTest()){
                endUrl = EncodingUtil.base64Encode(pageRef.getContentAsPDF());
             }
		//String endUrl = EncodingUtil.base64Encode(pageRef.getContentAsPDF());
        return endUrl;
        
    }
    @AuraEnabled
    public static List < accountWrapper > getAccounts(){
        List<accountWrapper> acctWrapperList = new List<accountWrapper>();
        String currentUserId = userInfo.getUserId();
        List < Account > wrapperObject = new List < Account >();
        String query = '';
        String SobjectApiName = 'Account';
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
        query = 'select Owner.Name, ' + strFields + ' from Account WHERE Phoenix_Is_Bid_Account__c = true AND OwnerId =: currentUserId ORDER BY Name';
        List < Account > acclist = Database.query(query);
        Set < id > accids = new Set < id > ();
        Map < Id, Account > accMap = new Map < Id, Account > ();
        for (Account pr: acclist) {
            accountWrapper accWrap = new accountWrapper(); accWrap.acc = pr; accWrap.isSelected = false; acctWrapperList.add(accWrap); accids.add(pr.Id); accMap.put(pr.Id, pr);
        }
        return acctWrapperList;
    }
    
    @AuraEnabled
    public static List < accountWrapper > getFilterAccounts(String searchText, Map<String , boolean> allAccounts){
        String currentUserId =  userInfo.getUserId();
        List<accountWrapper> acctWrapperList = new List<accountWrapper>();
        
        List < Account > wrapperObject = new List < Account >();
        String query = '';
        String SobjectApiName = 'Account';
        searchText = '%'+searchText+'%';
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
        if(searchText != null && searchText !=''){
            System.debug('Inside IF');
            query = 'select Owner.Name, ' + strFields + ' from Account WHERE Phoenix_Is_Bid_Account__c = true AND OwnerId =: currentUserId AND (Name like : searchText OR AccountNumber like : searchText OR Owner.Name like : searchText) ORDER BY Name';
        }else{
            System.debug('Inside else');
            query = 'select Owner.Name, ' + strFields + ' from Account WHERE Phoenix_Is_Bid_Account__c = true AND OwnerId =: currentUserId ORDER BY Name';
        }
        List < Account > acclist = Database.query(query);
        Set < id > accids = new Set < id > ();
        Map < Id, Account > accMap = new Map < Id, Account > ();
        for (Account pr: acclist) {  accountWrapper accWrap = new accountWrapper(); accWrap.acc = pr;  accWrap.isSelected = allAccounts.get(pr.id);   acctWrapperList.add(accWrap);  accids.add(pr.Id);    accMap.put(pr.Id, pr);
                                  }
        return acctWrapperList;
    }
    @auraEnabled
    public static Wrapper getOTCData(List<Product_Pipeline__c> otcPreviewList){
        Wrapper wrapper = new Wrapper();
        List<Id> ids = new List<Id>(); 
        for(Product_Pipeline__c item: otcPreviewList){
            ids.add(item.Id);
        }
        System.debug('ids--->'+ ids);
        List<Product_Pipeline__c> otcList=[select Id,Vision_GCP_Product_Family__c,Vision_Generic_Name__c,Vision_Potential_Launch_date__c,Vision_Therapeutic_Area__c,Vision_Segment__c,GCP_Launch_Year__c,Vision_Strength__c,Vision_Size__c,Vision_Launch_Month__c,Vision_Launch_Year1__c,Vision_Dosage_Form__c,Vision_Reference_Brand__c,Vision_Launch_Qtr__c,Vision_Api_Vertically_Integrated__c,Vision_Comments__c,Vision_Launch_Type__c,Vision_GPI__c,Vision_GCN__c from Product_Pipeline__c where Id=:ids];
        map<String,List<Product_Pipeline__c>> pipelineMap = new map<String,List<Product_Pipeline__c>>();
        for(Product_Pipeline__c item : otcList){
            if(pipelineMap.containsKey(item.Vision_Therapeutic_Area__c)){
                List<Product_Pipeline__c> sdList = pipelineMap.get(item.Vision_Therapeutic_Area__c);
                sdList.add(item);
                pipelineMap.put(item.Vision_Therapeutic_Area__c,sdList);
            }
            else{
                pipelineMap.put(item.Vision_Therapeutic_Area__c,new List<Product_Pipeline__c>{item});
            }
        }
       
        List<pipelineWrapper> pipelineWrapList = new List<pipelineWrapper>();
        for(string therapeuticArea : pipelineMap.keySet()){
            pipelineWrapper pipeWrap = new pipelineWrapper();
            List<Product_Pipeline__c> pipelineList = pipelineMap.get(therapeuticArea); 
            pipeWrap.therapeuticArea = therapeuticArea;
            pipeWrap.pipelineWrapper = pipelineList;
          
            
            pipelineWrapList.add(pipeWrap);
        }
        
        
        wrapper.pipelineWrapperList = pipelineWrapList;
        return Wrapper;
    }
    
    public class Wrapper {
        @AuraEnabled public List < pipelineWrapper > pipelineWrapperList;
        @AuraEnabled public List < Account > accounts;
        Wrapper() { 
            accounts = new List < Account > ();
            pipelineWrapperList = new List < pipelineWrapper > (); 
        }
    }
    Public class pipelineWrapper{
        @AuraEnabled public String therapeuticArea;
        @AuraEnabled public List<Product_Pipeline__c> pipelineWrapper;
        pipelineWrapper() { 
            pipelineWrapper = new List < Product_Pipeline__c > (); 
        }
        
    } 
    //Added by Srimayee
    Public class accountWrapper{
        @AuraEnabled public boolean isSelected;
        @AuraEnabled public Account acc;
        accountWrapper(){
            acc = new Account();
        }
    }
    Public class accountSearchWrapper{
        @AuraEnabled public boolean isSelected;
        @AuraEnabled public Account acc;
        accountSearchWrapper(){
            acc = new Account();
        }
    }
    public class wrapperClass {
        @AuraEnabled
        public Product_Pipeline__c prdlist {
            get;
            set;
        }
        @AuraEnabled
        public Boolean isSelected {
            get;
            set;
        }
    }
     Public class PipelineWrap{
         @AuraEnabled public Boolean isProcessed;
        @auraEnabled public Date prismUpdateDate;
         @auraEnabled public Date visionUpdateDate;
        @AuraEnabled public List<Product_Pipeline__c> pipelineList;
  		PipelineWrap() { 
            pipelineList = new List < Product_Pipeline__c > (); 
        }
     }
}