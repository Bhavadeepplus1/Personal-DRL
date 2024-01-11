public class Phoenix_WAC_Change_Controller {
    
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
    public static List<Phoenix_WAC_Change__c> getWACChangeInfo(Id recordId){
        List<Phoenix_WAC_Change__c> recordData = new List<Phoenix_WAC_Change__c>();
        recordData = Database.query('Select' + Phoenix_Util.wacChangeFields+ 'FROM Phoenix_WAC_Change__c where Id=:recordId');
		return recordData;
    }
    @AuraEnabled
    public static string getSubmitBidInfo(Id bidId) {
        System.debug('in getSubmitBidInfo');
        string response = Phoenix_SubmitBidForApprovalCtrl.submitWACChange(bidId);
       
        return response;
    }
    
    @AuraEnabled  
    public static List<ContentDocumentLink> getDocs(Id recordId)
    {
        return [SELECT Id, LinkedEntityId, ContentDocument.Title,ContentDocument.FileExtension,ContentDocumentId FROM ContentDocumentLink where LinkedEntityId=:recordId];
    }
    
    @AuraEnabled
    public static List<List<String>> csvFileRead(Id contentDocumentId){
        //Map<String, List<String>> csvData = new Map<String, List<String>>();
        List<List<String>> csvData = new List<List<String>>();
        List<Map<String, String>> data = new List<Map<String, String>>();
        list<String> csvRecordsList = new list<String>();
        if(contentDocumentId != null) {
            
            // Fetch File Data based on the basic of document id 
            ContentVersion contentVersionObj = [SELECT Id, VersionData FROM ContentVersion WHERE ContentDocumentId =:contentDocumentId];
            // split the file data
            csvRecordsList = contentVersionObj.VersionData.toString().split('\n');
            for(Integer i = 1; i < csvRecordsList.size(); i++){
                list<String> csvRowData = csvRecordsList[i].split(',');
                csvData.add(csvRowData);
            }
        }
        return csvData;    
    }
    
    
    @AuraEnabled
    public static Map<String, Phoenix_NPR_Data__c> getNPRData(List<String> Material_ContractsList){
        List<Phoenix_NPR_Data__c> nprData = new List<Phoenix_NPR_Data__c>();
        Map<String, Phoenix_NPR_Data__c> newMap = new  Map<String, Phoenix_NPR_Data__c>();
        nprData = [SELECT Id, Phoenix_Product__r.Product_Family__c,Phoenix_Product__r.Product_Family__r.Name, Phoenix_Product__c, Phoenix_Product__r.Name, Phoenix_Product__r.Family, Phoenix_NDC_11__c, Phoenix_Account__c, Phoenix_Account__r.Name, Phoenix_Account__r.Id, Name, Phoenix_WAC__c, Phoenix_Contract_Price__c, Phoenix_NPR_Customer_Name__c, Phoenix_NPR_Ref_SF__c FROM Phoenix_NPR_Data__c WHERE Phoenix_NPR_Ref_SF__c IN: Material_ContractsList]; //add this before moving- AND Phoenix_NPR_Status__c=: 'Active'
        for(Phoenix_NPR_Data__c item: nprData){
            newMap.put(item.Phoenix_NPR_Ref_SF__c, item);
        } 
        return newMap;
    }
    
    @AuraEnabled
    public static List<Phoenix_WAC_Change_Line_Item__c> getWACLineItemsList(Id recordId){
        List<Phoenix_WAC_Change_Line_Item__c> recordData = new List<Phoenix_WAC_Change_Line_Item__c>();
        recordData = Database.query('Select Phoenix_Account__r.Name, Phoenix_Product__r.Name, Product_Family__r.Name, Phoenix_NPR__r.Name,' + Phoenix_Util.wacChangeLineItemFields+ 'FROM Phoenix_WAC_Change_Line_Item__c where Phoenix_WAC_Change__c=:recordId');
		return recordData;
    }
    
    @AuraEnabled
    public static List<Phoenix_WAC_Change_Line_Item__c> updateWACLineItems(Id recordId, List<Phoenix_WAC_Change_Line_Item__c> lineItems){
        upsert lineItems;
        List<Phoenix_WAC_Change_Line_Item__c> recordData = new List<Phoenix_WAC_Change_Line_Item__c>();
        recordData = Database.query('Select Phoenix_Account__r.Name, Phoenix_Product__r.Name, Product_Family__r.Name, Phoenix_NPR__r.Name,' + Phoenix_Util.wacChangeLineItemFields+ 'FROM Phoenix_WAC_Change_Line_Item__c where Phoenix_WAC_Change__c=:recordId');
		return recordData;
    }
    
    @AuraEnabled
    public static Wrapper getRelatedList(Id recordId){
        Wrapper wrapperObject = new Wrapper();
        List < String > leadValues = new List < String > ();
        String query = '';
        String SobjectApiName = 'Phoenix_WAC_Change_Line_Item__c';
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
        Phoenix_WAC_Change__c bid = Database.query('Select ' + Phoenix_Util.wacChangeFields+ 'FROM Phoenix_WAC_Change__c WHERE Id=:recordId');
        
        string loggedUserName = UserInfo.getName();
        string notApproved = 'Not Approved';
        
        query = 'select Phoenix_Account__r.Name, Phoenix_Product__r.Name,Product_Family__r.Name, Phoenix_NPR__r.Name,Phoenix_WAC_Change__r.Phoenix_Approval_Status__c, ' + strFields + ' from ' + SobjectApiName + ' where Phoenix_WAC_Change__c = : recordId';//and Phoenix_Final_Status__c !=: notApproved
        
        string MarketingHeadUser ='';
        list < Phoenix_WAC_Change_Line_Item__c > quoteList = Database.query(query);
        system.debug('quoteList--->' + quoteList);
        Map < String, String > userTeamUserIdMap = new Map < String, String > ();
        for (Phoenix_User_Approval_Matrix__c matrix: [Select Id, Name, RecordType.DeveloperName, User_Group__r.Phoenix_Approver_Group_Name__c, Phoenix_Approval_Group_Behavior__c, Phoenix_Approver__c, Phoenix_Approver__r.Email, Phoenix_Approver_Group_Name__c, Phoenix_Is_Active_User__c, Phoenix_Is_Approval_Process_User__c, User_Group__c from Phoenix_User_Approval_Matrix__c limit 1000]) {
            String userTeamUserIdMapKey = matrix.User_Group__r.Phoenix_Approver_Group_Name__c + '-' + matrix.Phoenix_Approver__c;
            userTeamUserIdMap.put(userTeamUserIdMapKey, matrix.Phoenix_Approver__c);
            if(matrix.User_Group__r.Phoenix_Approver_Group_Name__c=='Marketing Head'){
                
                MarketingHeadUser= matrix.Phoenix_Approver__c;
            }
        }
        for (String key : userTeamUserIdMap.keySet()) {
            // The "key" variable is also available inside the loop
            String userMapData = userTeamUserIdMap.get(key);
            system.debug('User:: '+key);
            // ... emailing logic
        }
        boolean isMarketingHeadApprovePerson = false;
        boolean isContractsApprovePerson;
        boolean isVistexApprovePerson = false;
        
        
        
       
      
        if (userTeamUserIdMap.containsKey('Marketing Head-' + UserInfo.getUserId())) {
            isMarketingHeadApprovePerson = true;
        }
          if (userTeamUserIdMap.containsKey('Contracts-' + UserInfo.getUserId())) {
            isContractsApprovePerson = true;
            system.debug('isContractsApprovePerson---' + isContractsApprovePerson);
        }
          if (userTeamUserIdMap.containsKey('Home Office-' + UserInfo.getUserId())) {
            isVistexApprovePerson = true;
        }


        
        wrapperObject.lineItemsList = quoteList;
        wrapperObject.bidRecord = bid;
        wrapperObject.loggedInUserName = UserInfo.getName();
        wrapperObject.loggedInUserId = UserInfo.getUserId();
        wrapperObject.isMarketingHeadApprovePerson = isMarketingHeadApprovePerson;
        wrapperObject.isContractsApprovePerson = isContractsApprovePerson;
        wrapperObject.isVistexApprovePerson = isVistexApprovePerson;
       
        wrapperObject.MarketingHeadUser = MarketingHeadUser;
        
        system.debug(';loggedInUserName' + wrapperObject.loggedInUserName);
        return wrapperObject;
    }
    
    @AuraEnabled
    public static String deleteWACLineItems(List<Id> recordIds) {
        List<Phoenix_WAC_Change_Line_Item__c> deletedLineData = [SELECT Id FROM Phoenix_WAC_Change_Line_Item__c WHERE Id IN: recordIds];
        delete deletedLineData;
        return 'Success';
    }
     @AuraEnabled
    public static List<Phoenix_WAC_Change_Line_Item__c> updateWACItems(Id recordId, List<Phoenix_WAC_Change_Line_Item__c> lineItems){
        upsert lineItems;
       
		return lineItems;
    }
    
    
    @AuraEnabled
    public static void deleteAttachments(String attachId){
        List<ContentDocument> contentDocumentIds = [select Id from ContentDocument WHERE Id=:attachId];
        delete contentDocumentIds;   
    }
    @AuraEnabled
    public static void deleteLineItems(String LineItemId) {
        if (LineItemId != null) {
            Phoenix_WAC_Change_Line_Item__c deletedLineItem = [SELECT Id FROM Phoenix_WAC_Change_Line_Item__c WHERE Id =: LineItemId];
            delete deletedLineItem;
        }
    }
    
     @AuraEnabled
    public static List < Phoenix_WAC_Change_Line_Item__c > getSearch(string search,string ndcId,List<Phoenix_WAC_Change_Line_Item__c> productList) {
        String searchText = search.trim();
        system.debug('searchText---' + searchText);
        searchText = searchText.replace('\\s+', ' ');
        system.debug('searchText---' + searchText);
        list < string > searchupdateList = new list < string > ();
       
        

    
            List < String > searchList = searchText.split(' ');
            for (string str: searchList) {
                string searchItem = '%' + str + '%';
                searchupdateList.add(searchItem);
                
            }
      
        system.debug('searchupdateList----' + searchupdateList);
        String query = '';
        String SobjectApiName = 'Phoenix_WAC_Change_Line_Item__c';
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
        query = 'select Phoenix_Account__r.Name, Phoenix_Product__r.Name,Product_Family__r.Name, Phoenix_NPR__r.Name,Phoenix_WAC_Change__r.Phoenix_Approval_Status__c,  ' + strFields + ' from ' + SobjectApiName + ' where (Phoenix_WAC_Change__c = : ndcId AND Phoenix_Final_Status__c !=: notApproved AND (Phoenix_Contr_Number__c like :searchupdateList OR Phoenix_Cust_Name__c like :searchupdateList OR Phoenix_Cust_Number__c like :searchupdateList OR Phoenix_Product__r.Name like :searchupdateList OR Phoenix_Matl_No__c like :searchupdateList OR Phoenix_NDC11__c like :searchupdateList  )) ORDER BY Name ASC NULLS LAST LIMIT 30000';
      
                
        
        list < Phoenix_WAC_Change_Line_Item__c > productList1 = Database.query(query);
        system.debug('productList1--size'+productList1.size());
         system.debug('productList1---results'+productList1);
        return productList1;
    }
    
    @AuraEnabled
    public static Wrapper getRelatedList1(Id recordId){
        Wrapper wrapperObject = new Wrapper();
        List < String > leadValues = new List < String > ();
        String query = '';
        String SobjectApiName = 'Phoenix_WAC_Change_Line_Item__c';
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
        Phoenix_WAC_Change__c bid = Database.query('Select ' + Phoenix_Util.wacChangeFields+ 'FROM Phoenix_WAC_Change__c WHERE Id=:recordId');
        
        string loggedUserName = UserInfo.getName();
        string notApproved = 'Not Approved';
        
        query = 'select Phoenix_Account__r.Name, Phoenix_Product__r.Name,Product_Family__r.Name, Phoenix_NPR__r.Name,Phoenix_WAC_Change__r.Phoenix_Approval_Status__c, ' + strFields + ' from ' + SobjectApiName + ' where Phoenix_WAC_Change__c = : recordId and Phoenix_Final_Status__c !=: notApproved';
        
        string MarketingHeadUser ='';
        list < Phoenix_WAC_Change_Line_Item__c > quoteList = Database.query(query);
        system.debug('quoteList--->' + quoteList);
        Map < String, String > userTeamUserIdMap = new Map < String, String > ();
        for (Phoenix_User_Approval_Matrix__c matrix: [Select Id, Name, RecordType.DeveloperName, User_Group__r.Phoenix_Approver_Group_Name__c, Phoenix_Approval_Group_Behavior__c, Phoenix_Approver__c, Phoenix_Approver__r.Email, Phoenix_Approver_Group_Name__c, Phoenix_Is_Active_User__c, Phoenix_Is_Approval_Process_User__c, User_Group__c from Phoenix_User_Approval_Matrix__c limit 1000]) {
            String userTeamUserIdMapKey = matrix.User_Group__r.Phoenix_Approver_Group_Name__c + '-' + matrix.Phoenix_Approver__c;
            userTeamUserIdMap.put(userTeamUserIdMapKey, matrix.Phoenix_Approver__c);
            if(matrix.User_Group__r.Phoenix_Approver_Group_Name__c=='Marketing Head'){
                
                MarketingHeadUser= matrix.Phoenix_Approver__c;
            }
        }
        for (String key : userTeamUserIdMap.keySet()) {
            // The "key" variable is also available inside the loop
            String userMapData = userTeamUserIdMap.get(key);
            system.debug('User:: '+key);
            // ... emailing logic
        }
        boolean isMarketingHeadApprovePerson = false;
        boolean isContractsApprovePerson;
        boolean isVistexApprovePerson = false;
        
        
        
       
      
        if (userTeamUserIdMap.containsKey('Marketing Head-' + UserInfo.getUserId())) {
            isMarketingHeadApprovePerson = true;
        }
          if (userTeamUserIdMap.containsKey('Contracts-' + UserInfo.getUserId())) {
            isContractsApprovePerson = true;
            system.debug('isContractsApprovePerson---' + isContractsApprovePerson);
        }
          if (userTeamUserIdMap.containsKey('Home Office-' + UserInfo.getUserId())) {
            isVistexApprovePerson = true;
        }


        
        wrapperObject.lineItemsList = quoteList;
        wrapperObject.bidRecord = bid;
        wrapperObject.loggedInUserName = UserInfo.getName();
        wrapperObject.loggedInUserId = UserInfo.getUserId();
        wrapperObject.isMarketingHeadApprovePerson = isMarketingHeadApprovePerson;
        wrapperObject.isContractsApprovePerson = isContractsApprovePerson;
        wrapperObject.isVistexApprovePerson = isVistexApprovePerson;
       
        wrapperObject.MarketingHeadUser = MarketingHeadUser;
        
        system.debug(';loggedInUserName' + wrapperObject.loggedInUserName);
        return wrapperObject;
    }
    @AuraEnabled
    public static list < Phoenix_WAC_Change_Line_Item__c > getupdatedforExport(Id bidId) {
        String query = '';
        String SobjectApiName = 'Phoenix_WAC_Change_Line_Item__c';
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
        query = 'select Phoenix_Account__r.Name, Phoenix_Product__r.Name, Product_Family__r.Name,Phoenix_NPR__r.Name,Phoenix_WAC_Change__r.Phoenix_Approval_Status__c,  ' + strFields + ' from ' + SobjectApiName + ' where Phoenix_WAC_Change__c = : bidId AND Phoenix_Final_Status__c !=: notApproved';
        list < Phoenix_WAC_Change_Line_Item__c > quoteList = Database.query(query);
        for(Phoenix_WAC_Change_Line_Item__c line : quoteList){
            line.Phoenix_Contracts_Comments__c = line.Phoenix_Contracts_Comments__c!=null ? line.Phoenix_Contracts_Comments__c.replace('#',' '):line.Phoenix_Contracts_Comments__c;
            line.Phoenix_Contr_IntDesc__c = line.Phoenix_Contr_IntDesc__c!=null ? line.Phoenix_Contr_IntDesc__c.replace('#',' '):line.Phoenix_Contr_IntDesc__c;
            line.Phoenix_Vistex_Remarks__c = line.Phoenix_Vistex_Remarks__c!=null ? line.Phoenix_Vistex_Remarks__c.replace('#',' '):line.Phoenix_Vistex_Remarks__c;
            line.Phoenix_Customer_Update_Remarks__c = line.Phoenix_Customer_Update_Remarks__c!=null ? line.Phoenix_Customer_Update_Remarks__c.replace('#',' '):line.Phoenix_Customer_Update_Remarks__c;
            line.Phoenix_Head_of_PM_Comments__c = line.Phoenix_Head_of_PM_Comments__c!=null ? line.Phoenix_Head_of_PM_Comments__c.replace('#',' '):line.Phoenix_Head_of_PM_Comments__c;
            line.Phoenix_Comments__c = line.Phoenix_Comments__c!=null ? line.Phoenix_Comments__c.replace('#',' '):line.Phoenix_Comments__c;
        
        }
        return quoteList;
    }
    
    @AuraEnabled
    public static List < Phoenix_WAC_Change_Line_Item__c > fetchSortResults(string sortField, boolean isAsc, List < Phoenix_WAC_Change_Line_Item__c > productList) {
        system.debug(sortField+' '+isAsc+' ');
        
         String query = '';
        String SobjectApiName = 'Phoenix_WAC_Change_Line_Item__c';
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
        set < Id > prodIds = new set < Id > ();
        list < Phoenix_WAC_Change_Line_Item__c > sortResults = new list < Phoenix_WAC_Change_Line_Item__c > ();
        for (Phoenix_WAC_Change_Line_Item__c w: productList) {
            prodIds.add(w.Id);
        }
       
        String sSoql = 'select Phoenix_Account__r.Name,Product_Family__r.Name, Phoenix_Product__r.Name, Phoenix_NPR__r.Name,Phoenix_WAC_Change__r.Phoenix_Approval_Status__c,  ' + strFields + ' FROM Phoenix_WAC_Change_Line_Item__c where Phoenix_Final_Status__c !=: notApproved and ID IN:prodIds';
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
        system.debug('Result:: '+sortResults);
        return sortResults;
    }
    
     @AuraEnabled
    public static list < Phoenix_WAC_Change_Line_Item__c > submitToProceddStep1(string bidId) {
        String query = '';
        String SobjectApiName = 'Phoenix_WAC_Change_Line_Item__c';
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
        query = 'select Phoenix_Account__r.Name,Product_Family__r.Name,  Phoenix_Product__r.Name, Phoenix_NPR__r.Name,Phoenix_WAC_Change__r.Phoenix_Approval_Status__c, ' + strFields + ' from ' + SobjectApiName + ' where Phoenix_WAC_Change__c  = : bidId AND Phoenix_Final_Status__c !=: notApproved';
       
        list < Phoenix_WAC_Change_Line_Item__c > bidLinesList = Database.query(query);
        return bidLinesList;

    }
  
    @AuraEnabled
    public static WrapperForNextSteps makeApprovals(String bidId, List < Phoenix_WAC_Change_Line_Item__c > bidlines, boolean approveStatusFlag, boolean isFinance,boolean isContracts,boolean isCustomer,boolean isVistex) {
       boolean vistexNextStepFlag = false;
        for (Phoenix_WAC_Change_Line_Item__c line: bidlines) {
            


            if (isFinance) {
                line.Phoenix_Final_Head_of_PM_Approval__c = true;
                if (line.Phoenix_Head_of_PM_Group_Approval__c == 'Not Approved') {
                    line.Phoenix_Final_Status__c = 'Not Approved';
                }
            }
             if (isContracts) {
                line.Phoenix_Final_Contracts_Approval__c = true;
                if (line.Phoenix_Contracts_Approval__c == 'Not processed') {
                    line.Phoenix_Final_Status__c = 'Not Approved';
                }
            }
             if (isCustomer) {
                line.Phoenix_Final_Customer_Update_Approval__c = true;
                if (line.Phoenix_Customer_Update_Approval__c == 'Not Accepted') {
                    line.Phoenix_Final_Status__c = 'Not Approved';
                }
                 //Phoenix_SubmitBidForApprovalCtrl.sendNDCEmailToVistexTeam(bidId);
            }
             if (isVistex) {
               if(line.Phoenix_Vistex_Update_Approval__c == 'Updated'){
                    
                    line.Phoenix_Final_Vistex_Approval__c=true;
                }
                if (line.Phoenix_Vistex_Update_Approval__c == 'Not updated') {
                    //line.Phoenix_Final_Status__c = 'Not Approved';
                       vistexNextStepFlag = true;
                }
            }
            
        }
        if (bidlines.size() > 0) {
            update bidlines;
        }
        boolean flag=true;
        list < Phoenix_Bid_Process_Steps__c > bidProcessStepList = [SELECT Id,Phoenix_Is_Criteria_Step__c, Name, Phoenix_WAC_Change__c,Phoenix_Bid__c, Phoenix_Process_Step__c, Phoenix_Step__c, Phoenix_Approver__r.Name,Phoenix_Approver__r.Email, Phoenix_Approver__c, Phoenix_Status__c, Phoenix_Approver_Team__c FROM Phoenix_Bid_Process_Steps__c where Phoenix_WAC_Change__c =: bidId];
        list < Phoenix_Bid_Process_Steps__c > contractsStepLsit = new list < Phoenix_Bid_Process_Steps__c > ();
        for (Phoenix_Bid_Process_Steps__c step: bidProcessStepList) {

          
            if (step.Phoenix_Approver_Team__c == 'Marketing Head' && isFinance) {
                step.Phoenix_Status__c = approveStatusFlag == true ? 'Completed' : 'Do Not Bid';
                step.Phoenix_Approver__c=UserInfo.getUserId();
                contractsStepLsit.add(step);
            }
            if (step.Phoenix_Approver_Team__c == 'Contracts' && isContracts && step.Phoenix_Step__c==3) {
                step.Phoenix_Status__c = approveStatusFlag == true ? 'Completed' : 'Do Not Bid';
                step.Phoenix_Approver__c=UserInfo.getUserId();
                flag=false;
                contractsStepLsit.add(step);
            }

          if (step.Phoenix_Approver_Team__c == 'Contracts' && isCustomer && step.Phoenix_Step__c==4) {
                step.Phoenix_Status__c = approveStatusFlag == true ? 'Completed' : 'Do Not Bid';
              if( step.Phoenix_Status__c=='Completed'){
                 
                step.Phoenix_Approver__c=UserInfo.getUserId();
              }
       
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
     public static void updateNextProcesSteps(string bidId, string bidName,list < Phoenix_Bid_Process_Steps__c > processStepLsit,boolean vistexNextStepFlag, boolean isFinance,boolean isContracts,boolean isCustomer,boolean isVistex) {
      

        system.debug('In processStepLsit' + processStepLsit.size());
        if (vistexNextStepFlag == false && !processStepLsit.isEmpty()) {
           
              
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
             list < Phoenix_WAC_Change_Line_Item__c > bidLinesUpdate = [select id,Phoenix_Final_Contracts_Approval__c,Phoenix_Final_Customer_Update_Approval__c,Phoenix_Final_Vistex_Approval__c,Phoenix_Final_Status__c from Phoenix_WAC_Change_Line_Item__c where Phoenix_WAC_Change__c =: bidId];
           /* list < Phoenix_WAC_Change_Line_Item__c > bidlines = [select id,Phoenix_WAC_Change__r.Phoenix_Approval_Status__c,Phoenix_Final_Contracts_Approval__c,Phoenix_Vistex_Update_Approval__c,Phoenix_Final_Customer_Update_Approval__c,Phoenix_Final_Vistex_Approval__c,Phoenix_Final_Status__c from Phoenix_WAC_Change_Line_Item__c where Phoenix_WAC_Change__c =: bidId AND Phoenix_Final_Status__c !=: notApproved];
            string bidStatus=bidlines[0].Phoenix_WAC_Change__r.Phoenix_Approval_Status__c;
           
           Integer countApproved=0;
           Integer countVistexApproved=0;
            boolean IsvistexStatus=false;
             for (Phoenix_WAC_Change_Line_Item__c lineItem: bidlines) {
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
        }*/
            
            boolean isAllRejectedCaseFound = true;
        for (Phoenix_WAC_Change_Line_Item__c lineItem: bidLinesUpdate) {
            if (lineItem.Phoenix_Final_Status__c != 'Not Approved') {
                isAllRejectedCaseFound = false;
            }
        }
        if (isAllRejectedCaseFound) {
            
             if(isFinance){
            integer currentStepNum = stepnameNoMap.get('Marketing Head');
            for (Phoenix_Bid_Process_Steps__c prcsStep: processStepLsit) {
                if (prcsStep.Phoenix_Approver_Team__c == 'Marketing Head') {
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
            Phoenix_WAC_Change__c bid = new Phoenix_WAC_Change__c(id = bidId, Phoenix_Approval_Status__c = 'Marketing Head Rejected');
            update bid;
        }
             
            
            
              if(isContracts){
                   integer currentStepNum = 3;
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
            Phoenix_WAC_Change__c bid = new Phoenix_WAC_Change__c(id = bidId, Phoenix_Approval_Status__c = 'Contracts Rejected');
            update bid;
        }
              
             if(isCustomer){
                  integer currentStepNum = 4;
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
            Phoenix_WAC_Change__c bid = new Phoenix_WAC_Change__c(id = bidId, Phoenix_Approval_Status__c = 'Customer\'s Update Rejected	');
            update bid;
             }
            
            
            //close the bid other step not applicable
           
        }
            
            else{  
           
            List < Phoenix_Bid_Process_Steps__c > nextSteps = new list < Phoenix_Bid_Process_Steps__c > ();
            Integer stepNo;
          
            
              if(isFinance){
                   stepNo = stepnameNoMap.get('Marketing Head') + 1;
            }
              if(isContracts){
                 
                   stepNo = 3 + 1;
            }
              if(isCustomer){
                   stepNo =4 + 1;
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
            
         
               
             if (!nextSteps.isEmpty()) {
                update nextSteps;
                  Phoenix_WAC_Change__c bid = new Phoenix_WAC_Change__c(id = bidId);
               
              if(isFinance){
                  bid.Phoenix_Approval_Status__c='Contracts';
                  Phoenix_SubmitBidForApprovalCtrl.sendWACChangeEmailToFinanceTeam(bidId);
            }
              if(isContracts){
                  bid.Phoenix_Approval_Status__c='Customer\'s Update';
            }
              if(isCustomer){
                 bid.Phoenix_Approval_Status__c='Vistex Update';
                 Phoenix_SubmitBidForApprovalCtrl.sendWACChangeEmailToVistexTeam(bidId);
                  
            }
             
              if(isVistex){
                    bid.Phoenix_Approval_Status__c='Closed';
            }
              
              update bid;
               Phoenix_SubmitBidForApprovalCtrl.approvalRequestNotification(bidId , nextSteps);
            }
                 
            }
            
        } 
         
             else {
                 if(vistexNextStepFlag){
                      Phoenix_WAC_Change__c bid = new Phoenix_WAC_Change__c(id = bidId, Phoenix_Approval_Status__c = 'Vistex Update');
            update bid;
                  
           
                 }
                     
                     else{
                         
                   Phoenix_WAC_Change__c bid = new Phoenix_WAC_Change__c(id = bidId, Phoenix_Approval_Status__c = 'Closed');
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
        
        @AuraEnabled public List < Phoenix_WAC_Change_Line_Item__c > lineItemsList;
        @AuraEnabled public Phoenix_WAC_Change__c bidRecord;
        @AuraEnabled public string loggedInUserName;
        @AuraEnabled public string loggedInUserId;
        @AuraEnabled public string MarketingHeadUser;
        @AuraEnabled public boolean IsMarketingLeadUser;
        @AuraEnabled public boolean isMarketingHeadApprovePerson;
        @AuraEnabled public boolean isVistexApprovePerson;
        @AuraEnabled public boolean isContractsApprovePerson;
        Wrapper() {
            
            lineItemsList = new List < Phoenix_WAC_Change_Line_Item__c > ();
            bidRecord = new Phoenix_WAC_Change__c();
            
            
            loggedInUserName = '';
            
            loggedInUserId = '';
            
            
        }
    }
}