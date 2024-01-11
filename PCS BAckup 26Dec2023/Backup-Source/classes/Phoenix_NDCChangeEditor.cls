public class Phoenix_NDCChangeEditor {
    
    
    @AuraEnabled
    public static List<Map<String, String>> getActiveBidProductFamilies() {
        List <Product2> productFamilies = new List <Product2> ();
        productFamilies = [SELECT Product_Family__c, Product_Family__r.Name FROM Product2 WHERE IsActive =: true AND Phoenix_Is_Exclude_Bid__c =: false AND Product_Family__c != null ORDER BY Product_Family__r.Name ASC];
        List<Map<String, String>> listOfFamilies = new List<Map<String, String>>();
        Set<string> families = new Set<string>();
        Map<String, String> productFamilyMap = new Map<String, String>();
        for(Product2 item: productFamilies) {
            families.add(item.Product_Family__r.Name);
            productFamilyMap.put(item.Product_Family__c, item.Product_Family__r.Name);
        }
        for(String key: productFamilyMap.keySet()){
            listOfFamilies.add(new Map<String, String>{key => productFamilyMap.get(key)});
        }
        /*for(string item: families) {
            listOfFamilies.add(item);
        }*/
        return listOfFamilies;
    }
        
    
    @AuraEnabled
    public static productsDataWrapper getProductsInfo(string CurrentProductFamily, string ProposedProductFamily) {
        productsDataWrapper dataWrapper = new productsDataWrapper();
        List<Product2> productData = new List<Product2>();
        List<Product2> products = new List<Product2>();
        try {
            productData = [SELECT Name, Phoenix_NDC_11_Dashes__c, Phoenix_Pkg_Size__c, ProductCode FROM Product2 WHERE IsActive =: true AND Phoenix_Is_Exclude_Bid__c =: false AND Product_Family__c=:CurrentProductFamily ORDER BY Name ASC];
            products = [SELECT Name, Phoenix_NDC_11_Dashes__c, Phoenix_Pkg_Size__c, ProductCode FROM Product2 WHERE IsActive =: true AND Phoenix_Is_Exclude_Bid__c =: false AND Product_Family__c=:ProposedProductFamily ORDER BY Name ASC];
            dataWrapper.productData = productData;
            dataWrapper.products = products;

        }
        Catch(Exception e) {
            Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'Phoenix_SubmitBidForApprovalCtrl', Phoenix_Method_Name__c = 'calculateFinanceGrid', Phoenix_Error_Message__c = e.getMessage(), Phoenix_Issue_Status__c = 'Pending', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
            insert exp;
        }
        return dataWrapper;
    }
    
    
    @AuraEnabled
    public static List<Product2> getProducts(List<string> selectedProducts, String currentProductFamily) {
        List<Product2> products = new List<Product2>();
        try {
            products = [SELECT Name, Phoenix_NDC_11_Dashes__c, Phoenix_Pkg_Size__c, ProductCode FROM Product2 WHERE IsActive =: true AND Phoenix_Is_Exclude_Bid__c =: false AND Product_Family__c=:currentProductFamily AND Id NOT IN:selectedProducts ORDER BY Name ASC];
        }
        Catch(Exception e) {
            Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'Phoenix_SubmitBidForApprovalCtrl', Phoenix_Method_Name__c = 'calculateFinanceGrid', Phoenix_Error_Message__c = e.getMessage(), Phoenix_Issue_Status__c = 'Pending', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
            insert exp;
        }
        return products;
    }
    
    public class productsDataWrapper {
        @AuraEnabled public List < Product2 > productData;
        @AuraEnabled public List < Product2 > products;
        
        productsDataWrapper() {
            productData = new List < Product2 > ();
            products = new List < Product2 > ();
        }
    }
    
    @AuraEnabled
    public static List<product2> getProposedProductInfo(Id productId) {
        List<Product2> productData = new List<Product2>();
        productData = [SELECT Name, Phoenix_NDC_11_Dashes__c, Phoenix_Pkg_Size__c, ProductCode FROM Product2 WHERE Id=:productId LIMIT 1];
        return productData;
    }
    
    @AuraEnabled
    public static List<Phoenix_NDC_Change__c> getNDCChangeInfo(Id recordId) {
        List<Phoenix_NDC_Change__c> recordData = new List<Phoenix_NDC_Change__c>();
        //recordData = [SELECT Name, Phoenix_Date__c, Phoenix_Description__c, Phoenix_Status__c, Phoenix_Current_Product_Family__c, Phoenix_Proposed_Product_Family__c FROM Phoenix_NDC_Change__c WHERE Id=:recordId LIMIT 1];
        
     recordData = Database.query('Select' + Phoenix_Util.ndcChangeFields + ',(Select Id FROM NDC_Change_Line_Items__r) FROM Phoenix_NDC_Change__c where Id=:recordId');

        return recordData;
    }
    
    @AuraEnabled
    public static List<Phoenix_NPR_Data__c> getNPRData(List<string> recordIds, List<string> existingNPRIds) {
        set<Id> productIds = new set<Id>();
        for(string prodId: recordIds){
            productIds.add(prodId);
        }
        set<Id> nprIds = new set<Id>();
        for(string prodId: existingNPRIds){
            nprIds.add(prodId);
        }
        List<Phoenix_NPR_Data__c> nprData = new List<Phoenix_NPR_Data__c>();
        nprData = [SELECT Id, Phoenix_Account__c, Phoenix_Account__r.Name, Phoenix_Contract__c,Phoenix_Awarded_Quantity__c,Phoenix_Product_Position__c,Phoenix_12Months_Sales_Unit__c, Phoenix_Material_Number__c, Phoenix_Contract__r.Name, Phoenix_Contract__r.Id, Name, Phoenix_12Months_Actual_Sales_Unit__c, Phoenix_Product__r.Id, Phoenix_Product__r.Name, Phoenix_Product__r.Phoenix_NDC_11_Dashes__c, Phoenix_Product__r.Phoenix_Pkg_Size__c, Phoenix_Contract__r.Phoenix_Contract_Internal_Description__c, Phoenix_Contract_Price__c FROM Phoenix_NPR_Data__c WHERE Phoenix_Product__r.Id IN: productIds AND Id NOT IN: nprIds AND Phoenix_NPR_Status__c=: 'Active'];
        return nprData;
    }
    
    @AuraEnabled
    public static List<Phoenix_NDC_Change_Line_Item__c> getNDCLineItems(String recordId){
        List<Phoenix_NDC_Change_Line_Item__c> ndcProducts = [SELECT Phoenix_Account__c, Phoenix_Account__r.Name, Phoenix_Contract__c, Phoenix_Contract__r.Name, Phoenix_Contract_Internal_Description__c, Phoenix_Current_NPR__c, Phoenix_Current_NPR__r.Name, Phoenix_Current_Product__c, Phoenix_Current_Product__r.Name, Phoenix_Current_Product_NDC__c, Phoenix_Current_Product_Pack_Size__c, Phoenix_Proposed_Product__c, Phoenix_Proposed_Product__r.Name, Phoenix_Proposed_Product_NDC__c, Phoenix_Proposed_Product_Pack_Size__c, Phoenix_Contract_Price__c, Phoenix_Actual_Quantity_Last_12m__c, Phoenix_Awarded_Quantity__c FROM Phoenix_NDC_Change_Line_Item__c WHERE Phoenix_NDC_Change__c=: recordId];
        return ndcProducts;
    }
    
    @AuraEnabled
    public static List<Phoenix_NDC_Change_Product__c> saveNDCChangeProducts(List<Phoenix_NDC_Change_Product__c> listProducts){
        upsert listProducts;
        /*List<Phoenix_NDC_Change_Product__c> newIds = new List<Phoenix_NDC_Change_Product__c>();
        for(Phoenix_NDC_Change_Product__c item: listProducts) {
            //system.debug(':: '+item);
            newIds.push(item);
        }*/
        return listProducts;
    }
    
    @AuraEnabled
    public static String deleteNDCProduct(String recordId) {
        if(recordId != null){
            Phoenix_NDC_Change_Product__c delNDCChangeProduct = [Select Id from Phoenix_NDC_Change_Product__c where Id=:recordId];
            delete delNDCChangeProduct;
        }
        return 'Success';
    }
    
    @AuraEnabled
    public static List < Phoenix_NDC_Change_Line_Item__c > getSearch(string search,string ndcId,List<Phoenix_NDC_Change_Line_Item__c> productList) {
        String searchText = search.trim();
        //system.debug('searchText---' + searchText);
        searchText = searchText.replace('\\s+', ' ');
        //system.debug('searchText---' + searchText);
        list < string > searchupdateList = new list < string > ();
       
        

    
            List < String > searchList = searchText.split(' ');
            for (string str: searchList) {
                string searchItem = '%' + str + '%';
                searchupdateList.add(searchItem);
                
            }
      
        //system.debug('searchupdateList----' + searchupdateList);
        String query = '';
        String SobjectApiName = 'Phoenix_NDC_Change_Line_Item__c';
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
        query = 'select Phoenix_NDC_Change__r.Phoenix_Approval_Status__c,Phoenix_Account__r.Name,Phoenix_Contract__r.Name,Phoenix_Current_NPR__r.Name,Phoenix_Current_Product__r.Name,Phoenix_Current_Product__r.ProductCode,Phoenix_Proposed_Product__r.Name,Phoenix_Proposed_Product__r.ProductCode, Phoenix_Current_Product__r.Phoenix_NDC_11__c, Phoenix_Proposed_Product__r.Phoenix_NDC_11__c,  ' + strFields + ' from ' + SobjectApiName + ' where (Phoenix_NDC_Change__c = : ndcId AND Phoenix_Final_Status__c !=: notApproved AND (Phoenix_Account__r.Name like :searchupdateList OR Phoenix_Contract__r.Name like :searchupdateList OR Phoenix_Current_Product__r.Name like :searchupdateList OR Phoenix_Proposed_Product__r.Name like :searchupdateList OR Phoenix_Current_Product_NDC__c like :searchupdateList OR Phoenix_Proposed_Product_NDC__c like :searchupdateList OR Phoenix_Material_Code__c like :searchupdateList OR Phoenix_Current_Product__r.ProductCode like :searchupdateList  OR Phoenix_Proposed_Product__r.ProductCode like :searchupdateList  OR Phoenix_Current_Product__r.Phoenix_NDC_11__c  like :searchupdateList  OR Phoenix_Proposed_Product__r.Phoenix_NDC_11__c  like :searchupdateList  )) ORDER BY Name ASC NULLS LAST LIMIT 30000';
      
                
        
        list < Phoenix_NDC_Change_Line_Item__c > productList1 = Database.query(query);
       
        return productList1;
    }
    
    @AuraEnabled
    public static String deleteNDCLineItems(List<String> recordIds) {
        set<Id> productIds = new set<Id>();
        for(string prodId: recordIds){
            productIds.add(prodId);
        }
        for(String item: productIds){
         	Phoenix_NDC_Change_Line_Item__c delNDCLineItems = [Select Id from Phoenix_NDC_Change_Line_Item__c where Id =:item];   
            delete delNDCLineItems;
        }
        return 'Success';
    }
    
    @AuraEnabled
    public static List<Phoenix_NDC_Change_Line_Item__c> getLineItemIdsToDelete(Id recordId){
        List<Phoenix_NDC_Change_Line_Item__c> LineItems = [Select Id from Phoenix_NDC_Change_Line_Item__c where Phoenix_NDC_Change_Product__r.Id =:recordId];
        return LineItems;
    }
    
    
    @AuraEnabled
    public static List<Phoenix_NDC_Change_Line_Item__c> saveNDCChangeLineItems(List<Phoenix_NDC_Change_Line_Item__c> selectedProducts){
        upsert selectedProducts;
        return selectedProducts;
    }
    
    @AuraEnabled
    public static List<Phoenix_NDC_Change_Line_Item__c> updateNDCChangeLineItems(List<Phoenix_NDC_Change_Line_Item__c> listLineItems,string recordId){
        Integer count=0;
        for(Phoenix_NDC_Change_Line_Item__c ndcLine: listLineItems){
            if(ndcLine.Pheonix_Customer_Approval__c=='Not Required'){
                count++;
                ndcLine.Phoenix_Customer_Final_Approval__c=true;
                
}
}
        if(listLineItems.size()==count){
            list < Phoenix_Bid_Process_Steps__c > bidProcessStepList = [SELECT Id, Name, Phoenix_NDC_Change__c,Phoenix_Bid__c, Phoenix_Process_Step__c, Phoenix_Step__c, Phoenix_Approver__r.Name, Phoenix_Approver__c, Phoenix_Status__c, Phoenix_Approver_Team__c FROM Phoenix_Bid_Process_Steps__c where Phoenix_NDC_Change__c =: recordId];
        list < Phoenix_Bid_Process_Steps__c > contractsStepLsit = new list < Phoenix_Bid_Process_Steps__c > ();
        for (Phoenix_Bid_Process_Steps__c step: bidProcessStepList) {

            if (step.Phoenix_Approver_Team__c == 'Contracts' && step.Phoenix_Status__c=='In Process') {
                step.Phoenix_Status__c = 'Completed';
                contractsStepLsit.add(step);
            }
            if (step.Phoenix_Approver_Team__c == 'Home Office') {
                step.Phoenix_Status__c = 'In Process';
                contractsStepLsit.add(step);
            }
             
        }
         
     
           
       
        if (!contractsStepLsit.isEmpty()) {
            update contractsStepLsit;
            
        }
               Phoenix_NDC_Change__c bid = new Phoenix_NDC_Change__c(id = recordId);
               bid.Phoenix_Approval_Status__c='Vistex Update';
            update bid;
      
        }   
        
        
        update listLineItems;
        return listLineItems;
    }
    
    @AuraEnabled
    public static List<Phoenix_NDC_Change_Product__c> getNDCChangeProductInfo(Id recordId) {
        List<Phoenix_NDC_Change_Product__c> recordData = new List<Phoenix_NDC_Change_Product__c>();
        recordData = [SELECT Phoenix_Current_Product__c, Phoenix_Current_Product__r.Name, Phoenix_Current_NDC__c, Phoenix_Current_Pack_Size__c, Phoenix_Current_SAP_Number__c, Phoenix_Proposed_Product__c,Phoenix_Proposed_Product__r.Name, Phoenix_Proposed_NDC__c, Phoenix_Proposed_Pack_Size__c, Phoenix_Proposed_SAP_Number__c, Phoenix_NDC_Change_Name__r.Phoenix_Current_Product_Family__c, Phoenix_NDC_Change_Name__r.Phoenix_Proposed_Product_Family__c FROM Phoenix_NDC_Change_Product__c WHERE Phoenix_NDC_Change_Name__c=:recordId];
        return recordData;
    }
    
    
    @AuraEnabled
    public static void deleteLineItems(String LineItemId) {
        if (LineItemId != null) {
            Phoenix_NDC_Change_Line_Item__c deletedLineItem = [SELECT Id FROM Phoenix_NDC_Change_Line_Item__c WHERE Id =: LineItemId];
            delete deletedLineItem;
        }
    }
    
    @AuraEnabled
    public static List < Phoenix_NDC_Change_Line_Item__c > fetchSortResults(string sortField, boolean isAsc, List < Phoenix_NDC_Change_Line_Item__c > productList) {
        set < Id > prodIds = new set < Id > ();
        list < Phoenix_NDC_Change_Line_Item__c > sortResults = new list < Phoenix_NDC_Change_Line_Item__c > ();
        for (Phoenix_NDC_Change_Line_Item__c w: productList) {
            prodIds.add(w.Id);
        }
        string notApproved = 'Not Approved';
        String sSoql = 'select Phoenix_NDC_Change__r.Phoenix_Approval_Status__c,Phoenix_Account__r.Name,Phoenix_Contract__r.Name,Phoenix_Current_NPR__r.Name,Phoenix_Current_Product__r.Name,Phoenix_Proposed_Product__r.Name, '  + Phoenix_Util.ndcChangeLineItemFields +  ' FROM Phoenix_NDC_Change_Line_Item__c where Phoenix_Final_Status__c !=: notApproved and ID IN:prodIds';
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
        return sortResults;
    }
    
    
    @AuraEnabled
    public static list < Phoenix_NDC_Change_Line_Item__c > getupdatedforExport(Id bidId) {
        String query = '';
        String SobjectApiName = 'Phoenix_NDC_Change_Line_Item__c';
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
        query = 'select Phoenix_NDC_Change__r.Phoenix_Approval_Status__c,Phoenix_Account__r.Name,Phoenix_Contract__r.Name,Phoenix_Current_NPR__r.Name,Phoenix_Current_Product__r.Name,Phoenix_Proposed_Product__r.Name,  ' + strFields + ' from ' + SobjectApiName + ' where Phoenix_NDC_Change__c = : bidId AND Phoenix_Final_Status__c !=: notApproved';
        list < Phoenix_NDC_Change_Line_Item__c > quoteList = Database.query(query);
        return quoteList;
    }
    

    
    @AuraEnabled
    public static Wrapper getRelatedList(Id recordId){
        
        
      
        
        Wrapper wrapperObject = new Wrapper();
        List < String > leadValues = new List < String > ();
        String query = '';
        String SobjectApiName = 'Phoenix_NDC_Change_Line_Item__c';
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
        Phoenix_NDC_Change__c bid = [SELECT Id, Name, Phoenix_NDC_Change_Name__c,Phoenix_Approval_Status__c FROM Phoenix_NDC_Change__c WHERE Id =: recordId];
        string loggedUserName = UserInfo.getName();
        string notApproved = 'Not Approved';
       
        query = 'select Phoenix_NDC_Change__r.Phoenix_Approval_Status__c,Phoenix_Account__r.Name,Phoenix_Contract__r.Name,Phoenix_Current_NPR__r.Name,Phoenix_Current_Product__r.Name,Phoenix_Proposed_Product__r.Name, ' + strFields + ' from ' + SobjectApiName + ' where Phoenix_NDC_Change__c = : recordId and Phoenix_Final_Status__c !=: notApproved';

       
        list < Phoenix_NDC_Change_Line_Item__c > quoteList = Database.query(query);
        boolean vistexCompleted=true;
        for(Phoenix_NDC_Change_Line_Item__c ndcline:quoteList){
            if(ndcline.Phoenix_Customer_Final_Approval__c==true && ndcline.Phoenix_Vistex_Final_Approval__c==false){
                vistexCompleted=false;
            }
            
        }
    
    
        

        Map < String, String > userTeamUserIdMap = new Map < String, String > ();
        for (Phoenix_User_Approval_Matrix__c matrix: [Select Id, Name, RecordType.DeveloperName, User_Group__r.Phoenix_Approver_Group_Name__c, Phoenix_Approval_Group_Behavior__c, Phoenix_Approver__c, Phoenix_Approver__r.Email, Phoenix_Approver_Group_Name__c, Phoenix_Is_Active_User__c, Phoenix_Is_Approval_Process_User__c, User_Group__c from Phoenix_User_Approval_Matrix__c limit 1000]) {
            String userTeamUserIdMapKey = matrix.User_Group__r.Phoenix_Approver_Group_Name__c + '-' + matrix.Phoenix_Approver__c;
            userTeamUserIdMap.put(userTeamUserIdMapKey, matrix.Phoenix_Approver__c);
        }
        boolean isSCMApprovePerson = false;
        boolean isFinanceApprovePerson = false;
        boolean isContractsApprovePerson;
        boolean isSRxApprovePerson = false;
        boolean isVistexApprovePerson = false;

        if (userTeamUserIdMap.containsKey('Supply Chain-' + UserInfo.getUserId())) {
            isSCMApprovePerson = true;
        }
        if (userTeamUserIdMap.containsKey('Finance-' + UserInfo.getUserId())) {
            isFinanceApprovePerson = true;
        }
      
        if (userTeamUserIdMap.containsKey('Home Office-' + UserInfo.getUserId())) {
            isVistexApprovePerson = true;
        }

        if (userTeamUserIdMap.containsKey('Contracts-' + UserInfo.getUserId())) {
            isContractsApprovePerson = true;
        }
        string isMarketingApprovePerson;

        if (userTeamUserIdMap.containsKey('Marketing-' + UserInfo.getUserId())) {
            isMarketingApprovePerson = userTeamUserIdMap.get(('Marketing-' + UserInfo.getUserId()));
        }
      

     
 Schema.DescribeFieldResult fieldResult1 = Phoenix_NDC_Change_Line_Item__c.Phoenix_Lead_Time__c.getDescribe();
        List < Schema.PicklistEntry > pList1 = fieldResult1.getPicklistValues();
        for (Schema.PicklistEntry p: pList1) {
            leadValues.add(p.getLabel());
        }


        wrapperObject.lineItemsList = quoteList;
         wrapperObject.leadValues = leadValues;
        wrapperObject.bidRecord = bid;
        wrapperObject.loggedInUserName = UserInfo.getName();
        wrapperObject.loggedInUserId = UserInfo.getUserId();
     
        wrapperObject.isFinanceApprovePerson = isFinanceApprovePerson;
        wrapperObject.isVistexApprovePerson = isVistexApprovePerson;
        wrapperObject.isMarketingApprovePerson = isMarketingApprovePerson;
        wrapperObject.isSCMApprovePerson = isSCMApprovePerson;
         wrapperObject.vistexCompleted = vistexCompleted;
      
        wrapperObject.isContractsApprovePerson = isContractsApprovePerson;
      
       
     
        //system.debug(';loggedInUserName' + wrapperObject.loggedInUserName);
        return wrapperObject;
    }
    
  // method for fetch picklist values dynamic  
    /*@AuraEnabled
    public static List < String > getselectOptions(sObject objObject, string fld) {
        List < String > allOpts = new list < String > ();
        // Get the object type of the SObject.
        Schema.sObjectType objType = objObject.getSObjectType();
        
        // Describe the SObject using its object type.
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        
        // Get a map of fields for the SObject
        map < String, Schema.SObjectField > fieldMap = objDescribe.fields.getMap();
        
        // Get the list of picklist values for this field.
        list < Schema.PicklistEntry > values =
            fieldMap.get(fld).getDescribe().getPickListValues();
        
        // Add these values to the selectoption list.
        for (Schema.PicklistEntry a: values) {
            allOpts.add(a.getValue());
        }
        allOpts.sort();
        return allOpts;
    }*/
    
    
    @AuraEnabled
    public static boolean getApprovals(String ndcChangeId){
        Map<String, String> userTeamUserIdMap = new Map<String, String>();
        for(Phoenix_User_Approval_Matrix__c matrix : [Select Id, Name,RecordType.DeveloperName,User_Group__r.Phoenix_Approver_Group_Name__c, Phoenix_Approval_Group_Behavior__c,Phoenix_Approver__c,Phoenix_Approver__r.Email,Phoenix_Approver_Group_Name__c,Phoenix_Is_Active_User__c,Phoenix_Is_Approval_Process_User__c,User_Group__c from Phoenix_User_Approval_Matrix__c limit 1000]){
            String userTeamUserIdMapKey = matrix.User_Group__r.Phoenix_Approver_Group_Name__c+'-'+ matrix.Phoenix_Approver__c;
            userTeamUserIdMap.put(userTeamUserIdMapKey, matrix.Phoenix_Approver__c);
        }
        boolean isSCMApprovePerson=false;
        
        if(userTeamUserIdMap.containsKey('Supply Chain-'+UserInfo.getUserId())){
            isSCMApprovePerson=true;
        }
        return isSCMApprovePerson;
    }
    @AuraEnabled
    public static list < Phoenix_NDC_Change_Line_Item__c > submitToProceddStep1(string bidId) {
        String query = '';
        String SobjectApiName = 'Phoenix_NDC_Change_Line_Item__c';
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
        string loggerUserName = UserInfo.getName();
        query = 'select Phoenix_NDC_Change__r.Phoenix_Approval_Status__c,Phoenix_Account__r.Name,Phoenix_Contract__r.Name,Phoenix_Current_NPR__r.Name,Phoenix_Current_Product__r.Name,Phoenix_Proposed_Product__r.Name, ' + strFields + ' from ' + SobjectApiName + ' where Phoenix_NDC_Change__c  = : bidId AND Phoenix_Final_Status__c !=: notApproved';
       
        list < Phoenix_NDC_Change_Line_Item__c > bidLinesList = Database.query(query);
        return bidLinesList;

    }
    @AuraEnabled
    public static WrapperForNextSteps makeContractsApprovals(String bidId, List < Phoenix_NDC_Change_Line_Item__c > bidlines, boolean approveStatusFlag) {
       boolean vistexNextStepFlag = false;
        for (Phoenix_NDC_Change_Line_Item__c line: bidlines) {
            

            if(line.Phoenix_Final_Finance_Approval__c==true && line.Phoenix_Contracts_Final_Approval__c==false){
                if(line.Phoenix_Contracts_Approval__c!='None'  && line.Phoenix_Contracts_Approval__c!=''&& line.Phoenix_Contracts_Approval__c!=null){
                 line.Phoenix_Contracts_Final_Approval__c = true;
                 }
               
                 if (line.Phoenix_Contracts_Approval__c == 'No') {
                    line.Phoenix_Final_Status__c = 'Not Approved';
                }
             
            }
           
            
           else if(line.Phoenix_Contracts_Final_Approval__c==true && line.Phoenix_Customer_Final_Approval__c==false){
                if(line.Pheonix_Customer_Approval__c!='None'  && line.Pheonix_Customer_Approval__c!=''&& line.Pheonix_Customer_Approval__c!=null) {
                    line.Phoenix_Customer_Final_Approval__c = true;
                    Phoenix_SubmitBidForApprovalCtrl.sendNDCEmailToVistexTeam(bidId);
                }
               
                if (line.Pheonix_Customer_Approval__c == 'Not Approved') {
                    line.Phoenix_Final_Status__c = 'Not Approved';
                }
            }
            else if(line.Phoenix_Customer_Final_Approval__c==true && line.Phoenix_Vistex_Final_Approval__c==false){
                if(line.Phoenix_Vistex_Approval__c == 'Updated'){
                    
                    line.Phoenix_Vistex_Final_Approval__c=true;
                }
               
                if (line.Phoenix_Vistex_Approval__c == 'Pending') {
                 
                       vistexNextStepFlag = true;
                }
          
            
        }
        }
        if (bidlines.size() > 0) {
            update bidlines;
        }
         list < Phoenix_Bid_Process_Steps__c > bidProcessStepList = [SELECT Id,Phoenix_Is_Criteria_Step__c, Name, Phoenix_NDC_Change__c,Phoenix_Bid__c, Phoenix_Process_Step__c,Phoenix_Approver__r.Email, Phoenix_Step__c, Phoenix_Approver__r.Name, Phoenix_Approver__c, Phoenix_Status__c, Phoenix_Approver_Team__c FROM Phoenix_Bid_Process_Steps__c where Phoenix_NDC_Change__c =: bidId];
        list < Phoenix_Bid_Process_Steps__c > contractsStepLsit = new list < Phoenix_Bid_Process_Steps__c > ();
         WrapperForNextSteps wrapSteps = new WrapperForNextSteps();
     
           
       
        if (!contractsStepLsit.isEmpty()) {
            update contractsStepLsit;
             wrapSteps.updateProcessStepList = bidProcessStepList;
         
            wrapSteps.contractNextStepFlag = vistexNextStepFlag;
        }
        return wrapSteps;
    }
    @AuraEnabled
    public static WrapperForNextSteps makeApprovals(String bidId, List < Phoenix_NDC_Change_Line_Item__c > bidlines, boolean approveStatusFlag, boolean isSCM, boolean isFinance,boolean isContracts,boolean isCustomer,boolean isVistex) {
       boolean vistexNextStepFlag = false;
        for (Phoenix_NDC_Change_Line_Item__c line: bidlines) {
            if (isSCM) {
                line.Phoenix_SCM_Final_Approval__c = true;
                if (line.Phoenix_SCM_Approval_Y_N__c == 'Not Approved') {
                    line.Phoenix_Final_Status__c = 'Not Approved';
                }
            }


            if (isFinance) {
                line.Phoenix_Final_Finance_Approval__c = true;
                if (line.Phoenix_Finance_Approval__c == 'Not Approved') {
                    line.Phoenix_Final_Status__c = 'Not Approved';
                }
            }
             if (isContracts) {
                line.Phoenix_Contracts_Final_Approval__c = true;
                if (line.Phoenix_Contracts_Approval__c == 'No') {
                    line.Phoenix_Final_Status__c = 'Not Approved';
                }
            }
             if (isCustomer) {
                line.Phoenix_Customer_Final_Approval__c = true;
                if (line.Pheonix_Customer_Approval__c == 'Not Approved') {
                    line.Phoenix_Final_Status__c = 'Not Approved';
                }
                 Phoenix_SubmitBidForApprovalCtrl.sendNDCEmailToVistexTeam(bidId);
            }
             if (isVistex) {
               if(line.Phoenix_Vistex_Approval__c == 'Updated'){
                    
                    line.Phoenix_Vistex_Final_Approval__c=true;
                }
                if (line.Phoenix_Vistex_Approval__c == 'Pending') {
                    //line.Phoenix_Final_Status__c = 'Not Approved';
                       vistexNextStepFlag = true;
                }
            }
            
        }
        if (bidlines.size() > 0) {
            update bidlines;
        }
        boolean flag=true;
        list < Phoenix_Bid_Process_Steps__c > bidProcessStepList = [SELECT Id,Phoenix_Is_Criteria_Step__c, Name, Phoenix_NDC_Change__c,Phoenix_Bid__c, Phoenix_Process_Step__c, Phoenix_Step__c, Phoenix_Approver__r.Name,Phoenix_Approver__r.Email, Phoenix_Approver__c, Phoenix_Status__c, Phoenix_Approver_Team__c FROM Phoenix_Bid_Process_Steps__c where Phoenix_NDC_Change__c =: bidId];
        list < Phoenix_Bid_Process_Steps__c > contractsStepLsit = new list < Phoenix_Bid_Process_Steps__c > ();
        for (Phoenix_Bid_Process_Steps__c step: bidProcessStepList) {

            if (step.Phoenix_Approver_Team__c == 'Supply Chain' && isSCM) {
                step.Phoenix_Status__c = approveStatusFlag == true ? 'Completed' : 'Do Not Bid';
                step.Phoenix_Approver__c=UserInfo.getUserId();
                contractsStepLsit.add(step);
            }
            if (step.Phoenix_Approver_Team__c == 'Finance' && isFinance) {
                step.Phoenix_Status__c = approveStatusFlag == true ? 'Completed' : 'Do Not Bid';
                step.Phoenix_Approver__c=UserInfo.getUserId();
                contractsStepLsit.add(step);
            }
            if (step.Phoenix_Approver_Team__c == 'Contracts' && isContracts && flag ) {
                step.Phoenix_Status__c = approveStatusFlag == true ? 'Completed' : 'Do Not Bid';
                step.Phoenix_Approver__c=UserInfo.getUserId();
                flag=false;
                contractsStepLsit.add(step);
            }

          if (step.Phoenix_Approver_Team__c == 'Contracts' && isCustomer) {
                step.Phoenix_Status__c = approveStatusFlag == true ? 'Completed' : 'Do Not Bid';
                step.Phoenix_Approver__c=UserInfo.getUserId();
                contractsStepLsit.add(step);
            }
             if (step.Phoenix_Approver_Team__c == 'Home Office' && isVistex) {
                step.Phoenix_Status__c =  (approveStatusFlag == true && vistexNextStepFlag==false) ? 'Completed' : 'In Process';
               
                 step.Phoenix_Approver__c=UserInfo.getUserId();
               
                contractsStepLsit.add(step);
                 
            }
        }
          WrapperForNextSteps wrapSteps = new WrapperForNextSteps();
     
           
       
        if (!contractsStepLsit.isEmpty()) {
            update contractsStepLsit;
             wrapSteps.updateProcessStepList = bidProcessStepList;
         
            wrapSteps.contractNextStepFlag = vistexNextStepFlag;
        }
        return wrapSteps;
    }
      @AuraEnabled
     public static void updateNextProcesSteps(string bidId, string bidName,list < Phoenix_Bid_Process_Steps__c > processStepLsit,boolean vistexNextStepFlag, boolean isSCM, boolean isFinance,boolean isContracts,boolean isCustomer,boolean isVistex) {
        //system.debug('In Contracts');

        //system.debug('In processStepLsit' + processStepLsit.size());
        if (vistexNextStepFlag == false && !processStepLsit.isEmpty()) {
              //system.debug('vistexNextStepFlag----'+vistexNextStepFlag);
               //system.debug('isVistex----'+isVistex);
            Map < Integer, List < Phoenix_Bid_Process_Steps__c >> stepMap = new Map < Integer, List < Phoenix_Bid_Process_Steps__c >> ();
            Map < String, List < Phoenix_Bid_Process_Steps__c >> stepNamesMap = new Map < String, List < Phoenix_Bid_Process_Steps__c >> ();
            Map < String, Integer > stepnameNoMap = new Map < String, Integer > ();
            for (Phoenix_Bid_Process_Steps__c step: processStepLsit) {

                Integer stepNo = Integer.valueOf(step.Phoenix_Step__c);
                if (stepMap.get(stepNo) != null) {
                    List < Phoenix_Bid_Process_Steps__c > adededSteps = stepMap.get(stepNo);
                    adededSteps.add(step);
                    stepMap.put(stepNo, adededSteps);
                } else {
                    stepMap.put(stepNo, new List < Phoenix_Bid_Process_Steps__c > {
                        step
                    });
                }

                String stepName = step.Phoenix_Approver_Team__c;
                if (stepNamesMap.get(stepName) != null) {
                    List < Phoenix_Bid_Process_Steps__c > adededSteps = stepNamesMap.get(stepName);
                    adededSteps.add(step);
                    stepNamesMap.put(stepName, adededSteps);
                } else {
                    stepNamesMap.put(stepName, new List < Phoenix_Bid_Process_Steps__c > {
                        step
                    });
                }
                stepnameNoMap.put(stepName, stepNo);

            }
             string notApproved = 'Not Approved';
             list < Phoenix_NDC_Change_Line_Item__c > bidLinesUpdate = [select id,Phoenix_Contracts_Final_Approval__c,Phoenix_Customer_Final_Approval__c,Phoenix_Vistex_Final_Approval__c,Phoenix_Final_Status__c from Phoenix_NDC_Change_Line_Item__c where Phoenix_NDC_Change__c =: bidId];
            list < Phoenix_NDC_Change_Line_Item__c > bidlines = [select id,Phoenix_NDC_Change__r.Phoenix_Approval_Status__c,Phoenix_Contracts_Final_Approval__c,Phoenix_Vistex_Approval__c,Phoenix_Customer_Final_Approval__c,Phoenix_Vistex_Final_Approval__c,Phoenix_Final_Status__c from Phoenix_NDC_Change_Line_Item__c where Phoenix_NDC_Change__c =: bidId AND Phoenix_Final_Status__c !=: notApproved];
            string bidStatus=bidlines[0].Phoenix_NDC_Change__r.Phoenix_Approval_Status__c;
           
           Integer countApproved=0;
           Integer countVistexApproved=0;
            boolean IsvistexStatus=false;
             for (Phoenix_NDC_Change_Line_Item__c lineItem: bidlines) {
            if (lineItem.Phoenix_Final_Status__c != 'Not Approved') {
                if(lineItem.Phoenix_Contracts_Final_Approval__c==true && lineItem.Phoenix_Customer_Final_Approval__c==true && lineItem.Phoenix_Vistex_Final_Approval__c==true ){
                    countApproved++;
                }
                 if(lineItem.Phoenix_Contracts_Final_Approval__c==true && lineItem.Phoenix_Customer_Final_Approval__c==true){
                      countVistexApproved++;
                     if(lineItem.Phoenix_Vistex_Approval__c != 'Updated'){
                         IsvistexStatus=true;
                     }
                   
                }
                
                //isAllRejectedCaseFound = false;
            }
        }
            
            boolean isAllRejectedCaseFound = true;
        for (Phoenix_NDC_Change_Line_Item__c lineItem: bidLinesUpdate) {
            if (lineItem.Phoenix_Final_Status__c != 'Not Approved') {
                isAllRejectedCaseFound = false;
            }
        }
        if (isAllRejectedCaseFound) {
             if(isSCM){
                  integer currentStepNum = stepnameNoMap.get('Supply Chain');
            for (Phoenix_Bid_Process_Steps__c prcsStep: processStepLsit) {
                if (prcsStep.Phoenix_Approver_Team__c == 'Supply Chain') {
                    prcsStep.Phoenix_Status__c = 'Completed';
                    prcsStep.Phoenix_Approver__c = userinfo.getuserid();
                }
                if (prcsStep.Phoenix_Step__c > currentStepNum) {
                    if (prcsStep.Name.contains('Closed')) {
                        prcsStep.Phoenix_Status__c = 'Completed';
                    } else {
                        prcsStep.Phoenix_Status__c = 'Not Applicable';
                    }
                }
            }
            update processStepLsit;
            Phoenix_NDC_Change__c bid = new Phoenix_NDC_Change__c(id = bidId, Phoenix_Approval_Status__c = 'Supply Chain Rejected');
            update bid;
            Phoenix_SubmitBidForApprovalCtrl.SCMProductRejectionNotification(bidId);

        }
             if(isFinance){
            integer currentStepNum = stepnameNoMap.get('Finance');
            for (Phoenix_Bid_Process_Steps__c prcsStep: processStepLsit) {
                if (prcsStep.Phoenix_Approver_Team__c == 'Finance') {
                    prcsStep.Phoenix_Status__c = 'Completed';
                    prcsStep.Phoenix_Approver__c = userinfo.getuserid();
                }
                if (prcsStep.Phoenix_Step__c > currentStepNum) {
                    if (prcsStep.Name.contains('Closed')) {
                        prcsStep.Phoenix_Status__c = 'Completed';
                    } else {
                        prcsStep.Phoenix_Status__c = 'Not Applicable';
                    }
                }
            }
            update processStepLsit;
            Phoenix_NDC_Change__c bid = new Phoenix_NDC_Change__c(id = bidId, Phoenix_Approval_Status__c = 'Finance Rejected');
            update bid;
        }
             
            
            
              if(isContracts){
                   integer currentStepNum = 4;
            for (Phoenix_Bid_Process_Steps__c prcsStep: processStepLsit) {
                if (prcsStep.Phoenix_Approver_Team__c == 'Contracts' && prcsStep.Phoenix_Status__c!='Completed' ) {
                    prcsStep.Phoenix_Status__c = 'Completed';
                    prcsStep.Phoenix_Approver__c = userinfo.getuserid();
                }
                if (prcsStep.Phoenix_Step__c > currentStepNum) {
                    if (prcsStep.Name.contains('Closed')) {
                        prcsStep.Phoenix_Status__c = 'Completed';
                    } else {
                        prcsStep.Phoenix_Status__c = 'Not Applicable';
                    }
                }
            }
            update processStepLsit;
            Phoenix_NDC_Change__c bid = new Phoenix_NDC_Change__c(id = bidId, Phoenix_Approval_Status__c = 'Contracts Rejected');
            update bid;
        }
              
             if(isCustomer){
                  integer currentStepNum = 5;
            for (Phoenix_Bid_Process_Steps__c prcsStep: processStepLsit) {
                if (prcsStep.Phoenix_Approver_Team__c == 'Contracts' && prcsStep.Phoenix_Status__c!='Completed') {
                    prcsStep.Phoenix_Status__c = 'Completed';
                    prcsStep.Phoenix_Approver__c = userinfo.getuserid();
                }
                if (prcsStep.Phoenix_Step__c > currentStepNum) {
                    if (prcsStep.Name.contains('Closed')) {
                        prcsStep.Phoenix_Status__c = 'Completed';
                    } else {
                        prcsStep.Phoenix_Status__c = 'Not Applicable';
                    }
                }
            }
            update processStepLsit;
            Phoenix_NDC_Change__c bid = new Phoenix_NDC_Change__c(id = bidId, Phoenix_Approval_Status__c = 'Customer\'s Update Rejected	');
            update bid;
             }
            
            
            //close the bid other step not applicable
           
        }
            
            else{  
           
            List < Phoenix_Bid_Process_Steps__c > nextSteps = new list < Phoenix_Bid_Process_Steps__c > ();
            Integer stepNo;
          
            if(isSCM){
                   stepNo = stepnameNoMap.get('Supply Chain') + 1;
            }
              if(isFinance){
                   stepNo = stepnameNoMap.get('Finance') + 1;
            }
              if(isContracts){
                 
                   stepNo = 4 + 1;
            }
              if(isCustomer){
                   stepNo =5 + 1;
            }
             
              if(isVistex){
                   stepNo = stepnameNoMap.get('Home Office') + 1;
            }
            
         
            
          
            nextSteps = stepMap.get(stepNo);

   
            for (Phoenix_Bid_Process_Steps__c step: nextSteps) {
                if (step.Name.contains('Closed')) {
                    step.Phoenix_Status__c = 'Completed';
                } 
                else {
                    step.Phoenix_Status__c = 'In Process';
                } //'In Process' Submitted //Diff b/w them            
            }
            
         
                string str='%'+'Closed'+'%';
                if(countApproved==bidlines.size() && !nextSteps.isEmpty()){
                nextSteps = [SELECT Id, Phoenix_Is_Criteria_Step__c,Name, Phoenix_NDC_Change__c,Phoenix_Bid__c, Phoenix_Process_Step__c, Phoenix_Step__c, Phoenix_Approver__r.Name, Phoenix_Approver__c, Phoenix_Status__c, Phoenix_Approver_Team__c FROM Phoenix_Bid_Process_Steps__c where Phoenix_NDC_Change__c =: bidId and (Phoenix_Approver_Team__c = 'Contracts' OR Phoenix_Approver_Team__c = 'Home Office' OR Name like: str)];
                      for (Phoenix_Bid_Process_Steps__c step: nextSteps) {
                              step.Phoenix_Status__c = 'Completed';
                    }
                 
                    update nextSteps;
                   
                    
                    
                      Phoenix_NDC_Change__c bid = new Phoenix_NDC_Change__c(id = bidId);
                    bid.Phoenix_Approval_Status__c='Closed'; 
                    update bid;
                Phoenix_SubmitBidForApprovalCtrl.approvalRequestNotification(bidId, nextSteps);
                    
                }
                else if(countVistexApproved==bidlines.size() && bidStatus=='Contracts' && IsvistexStatus){
                    nextSteps = [SELECT Id, Name, Phoenix_Is_Criteria_Step__c,Phoenix_NDC_Change__c,Phoenix_Bid__c, Phoenix_Process_Step__c, Phoenix_Step__c, Phoenix_Approver__r.Name, Phoenix_Approver__c, Phoenix_Status__c, Phoenix_Approver_Team__c FROM Phoenix_Bid_Process_Steps__c where Phoenix_NDC_Change__c =: bidId and (Phoenix_Approver_Team__c = 'Contracts' OR Phoenix_Approver_Team__c = 'Home Office')];
                      for (Phoenix_Bid_Process_Steps__c step: nextSteps) {
                          if(step.Phoenix_Approver_Team__c=='Contracts'){
                              step.Phoenix_Status__c = 'Completed';
                          }
                          if(step.Phoenix_Approver_Team__c=='Home Office'){
                               step.Phoenix_Status__c = 'In Process';
                          }
                    }
                 
                    update nextSteps;
                   
                    
                    
                      Phoenix_NDC_Change__c bid = new Phoenix_NDC_Change__c(id = bidId);
                    bid.Phoenix_Approval_Status__c='Vistex Update'; 
                    update bid;
                Phoenix_SubmitBidForApprovalCtrl.approvalRequestNotification(bidId, nextSteps);
                    
                }
            else if (!nextSteps.isEmpty()) {
                update nextSteps;
                  Phoenix_NDC_Change__c bid = new Phoenix_NDC_Change__c(id = bidId);
                 if(isSCM){
                 bid.Phoenix_Approval_Status__c='Finance';
            }
              if(isFinance){
                  bid.Phoenix_Approval_Status__c='Contracts';
            }
              if(isContracts){
                  bid.Phoenix_Approval_Status__c='Customer\'s Update';
            }
              if(isCustomer){
                  bid.Phoenix_Approval_Status__c='Vistex Update';
            }
             
              if(isVistex){
                    bid.Phoenix_Approval_Status__c='Closed';
            }
              
              update bid;
                Phoenix_SubmitBidForApprovalCtrl.approvalRequestNotification(bidId, nextSteps); 
            }
                 
            }
            
        } 
         
             else {
                 if(vistexNextStepFlag){
                      Phoenix_NDC_Change__c bid = new Phoenix_NDC_Change__c(id = bidId, Phoenix_Approval_Status__c = 'Vistex Update');
            update bid;
            //list < Phoenix_Bid_Process_Steps__c > nextSteps = new list<Phoenix_Bid_Process_Steps__c>();
               //nextSteps=[SELECT Id, Name, Phoenix_NDC_Change__c,Phoenix_Bid__c, Phoenix_Process_Step__c, Phoenix_Step__c, Phoenix_Approver__r.Name, Phoenix_Approver__c, Phoenix_Status__c, Phoenix_Approver_Team__c FROM Phoenix_Bid_Process_Steps__c where Phoenix_NDC_Change__c =: bidId and Name='Closed'];

                       //SPhoenix_SubmitBidForApprovalCtrl.approvalRequestNotification(bidId, nextSteps);
                 }
                     
                     else{
                         
                   Phoenix_NDC_Change__c bid = new Phoenix_NDC_Change__c(id = bidId, Phoenix_Approval_Status__c = 'Closed');
            update bid;
                     }
        }
    }
 public class WrapperForNextSteps {
        @AuraEnabled public list < Phoenix_Bid_Process_Steps__c > updateProcessStepList;
        @AuraEnabled public boolean flagSCMStop;
        @AuraEnabled public boolean flagMarketStop;
        @AuraEnabled public boolean contractNextStepFlag;

        WrapperForNextSteps() {
            updateProcessStepList = new List < Phoenix_Bid_Process_Steps__c > ();
            flagSCMStop = false;
            flagMarketStop = false;
            contractNextStepFlag = false;
        }
    }
    public class Wrapper {

        @AuraEnabled public List < Phoenix_NDC_Change_Line_Item__c > lineItemsList;
        @AuraEnabled public Phoenix_NDC_Change__c bidRecord;
        @AuraEnabled public List < String > productDirectorList;
        @AuraEnabled public List < String > leadValues;
        @AuraEnabled public string loggedInUserName;
        @AuraEnabled public string loggedInUserId;
        @AuraEnabled public boolean isSCMApprovePerson;
        @AuraEnabled public boolean conditionApproval;
        @AuraEnabled public boolean isVistexApprovePerson;
        @AuraEnabled public boolean isSRxApprovePerson;
        @AuraEnabled public boolean isFinanceApprovePerson;
        @AuraEnabled public boolean isContractsApprovePerson;
        @AuraEnabled public string BidContractPerson;
        @AuraEnabled public string isMarketingApprovePerson;
        @AuraEnabled public boolean showProceedBtn;
        @AuraEnabled public boolean showProceedContrBtn;
         @AuraEnabled public boolean vistexCompleted;
        Wrapper() {

            lineItemsList = new List < Phoenix_NDC_Change_Line_Item__c > ();
            bidRecord = new Phoenix_NDC_Change__c();
            productDirectorList = new list < string > ();
            leadValues=new list < string > ();
            loggedInUserName = '';
            BidContractPerson = '';
            loggedInUserId = '';

            isMarketingApprovePerson = '';
        }
    }
}