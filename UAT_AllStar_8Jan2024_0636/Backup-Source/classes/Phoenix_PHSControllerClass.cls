public class Phoenix_PHSControllerClass {
    public static Map<Id, String> recordtypemap;
    
    @AuraEnabled        
    
    public static Map<Id, String> fetchRecordTypeValues(String objectName){
        List<Schema.RecordTypeInfo> recordtypes = Schema.getGlobalDescribe().get(objectName).getDescribe().getRecordTypeInfos();    
        recordtypemap = new Map<Id, String>();
        for(RecordTypeInfo rt : recordtypes){  
            if(rt.getName() != 'Master' && rt.getName().trim() != '')
                recordtypemap.put(rt.getRecordTypeId(), rt.getName());
        }        
        return recordtypemap;
    }
    
    @AuraEnabled
    public static wrapperClass getDataFromCustomSettings(){
        wrapperClass wrap = new wrapperClass();
        List<Phoenix_PHS_Data__c> customData = Phoenix_PHS_Data__c.getall().values();
        wrap.PHSCustomData = customData;
        return wrap;
    }
    
    @AuraEnabled
    public static List<Product2> getProductInfo(String productId){
        List<Product2> productInfo = new List<Product2>();
        productInfo = [SELECT Id, Name, Phoenix_NDC_11__c, ProductCode FROM Product2 WHERE Id=: productId LIMIT 1];
        return productInfo;
    }
    
    @AuraEnabled
    public static List<Phoenix_PHS_Price_Change_Line__c> savePriceChangeLine(Id recordId, List<Phoenix_PHS_Price_Change_Line__c> linesList){
        upsert linesList;
        List<Phoenix_PHS_Price_Change_Line__c> recordData = new List<Phoenix_PHS_Price_Change_Line__c>();
        recordData = Database.query('Select Phoenix_Product_Name__r.Name,' + Phoenix_Util.phsChangeLineFields+ 'FROM Phoenix_PHS_Price_Change_Line__c where Phoenix_PHS_Price_Change__c=:recordId');
		return recordData;
    }

    
    @AuraEnabled
    public static wrapperClass getNPRData(String contractId, String apexusContractId){
        wrapperClass wrap = new wrapperClass();
        List<Phoenix_NPR_Data__c> products = new List<Phoenix_NPR_Data__c>();
        List<Phoenix_NPR_Data__c> products2 = new List<Phoenix_NPR_Data__c>();
        Map<Id, Decimal> priceList = new Map<Id, Decimal>();
        Map<Id, Decimal> priceList2 = new Map<Id, Decimal>();
        Map<Id, Decimal> newPricelist = new  Map<Id, Decimal>();
        products = [SELECT Phoenix_Product__c, Phoenix_Product__r.Name, Phoenix_NDC_11__c, Phoenix_Contract_Price__c, Phoenix_SalesUnit_90__c, Phoenix_Product__r.ProductCode FROM Phoenix_NPR_Data__c WHERE Phoenix_Contract__c=:contractId AND Phoenix_NPR_Status__c=: 'Active' ORDER BY Phoenix_Product__r.Name]; //Add this condition before moving - AND Phoenix_NPR_Status__c=: 'Active'
        products2 = [SELECT Phoenix_Product__c, Phoenix_Product__r.Name, Phoenix_NDC_11__c, Phoenix_Contract_Price__c, Phoenix_SalesUnit_90__c, Phoenix_Product__r.ProductCode FROM Phoenix_NPR_Data__c WHERE Phoenix_Contract__c=:apexusContractId AND Phoenix_NPR_Status__c=: 'Active' ORDER BY Phoenix_Product__r.Name];  //Add this condition before moving - AND Phoenix_NPR_Status__c=: 'Active'
        for(Phoenix_NPR_Data__c item: products){
            priceList.put(item.Phoenix_Product__c, item.Phoenix_Contract_Price__c);
        }
        for(Phoenix_NPR_Data__c item: products2){
            priceList2.put(item.Phoenix_Product__c, item.Phoenix_Contract_Price__c);
        }
        for(Id productId : priceList.keySet()){
            newPricelist.put(productId, priceList2.get(productId));
        }        
        wrap.products = products;
        wrap.priceList = newPricelist;
        return wrap;
    }
    
    public class wrapperClass{
        
        @AuraEnabled public List<Phoenix_NPR_Data__c> products; 
        @AuraEnabled public Map<Id, Decimal> priceList;
        @AuraEnabled public List<Phoenix_PHS_Data__c> PHSCustomData;
        wrapperClass(){
            products = new List<Phoenix_NPR_Data__c>();
            priceList = new Map<Id, Decimal>();
            PHSCustomData = new List<Phoenix_PHS_Data__c>();
        }
    }
    
    
    @AuraEnabled  
    public static List<ContentDocumentLink> getDocs(String recordId)
    {
        return [SELECT Id, LinkedEntityId, ContentDocument.Title,ContentDocument.FileExtension,ContentDocumentId FROM ContentDocumentLink where LinkedEntityId=:recordId];
    }
    
    @AuraEnabled
    public static void deleteAttachments(String attachId){
        List<ContentDocument> contentDocumentIds = [select Id from ContentDocument WHERE Id=:attachId];
        delete contentDocumentIds;   
    }
    
   /* @AuraEnabled
    public static List < sObject > fetchLookUpValues(String searchKeyWord, String ObjectName) {
        
        List < sObject > returnList = new List < sObject > ();
        List < sObject > data = [SELECT Id, Name FROM Phoenix_Contract__c WHERE Phoenix_Customer__r.Id=:'0010m00000g50UKAAY'];
        
        for (sObject obj: data) {
            returnList.add(obj);
        }
        system.debug(':::Return List:: '+returnList);
        return returnList;
    }*/
    
    @AuraEnabled
    public static Map<String, String> csvFileRead(Id contentDocumentId){
        Map<String, String> csvData = new Map<String, String>();
        list<String> csvRecordsList = new list<String>();
        if(contentDocumentId != null) {
            
            // Fetch File Data based on the basic of document id 
            ContentVersion contentVersionObj = [SELECT Id, VersionData FROM ContentVersion WHERE ContentDocumentId =:contentDocumentId];
            // split the file data
            csvRecordsList = contentVersionObj.VersionData.toString().split('\n');
            for(Integer i = 1; i < csvRecordsList.size(); i++){
                list<String> csvRowData = csvRecordsList[i].split(',');
                //System.debug('csvRowData====> '+csvRowData);
                csvData.put(csvRowData[0], csvRowData[5]);
            }
        }
        return csvData;    
    }
    
    @AuraEnabled
    public static List<Product2> getProducts(List<String> selectedProducts){
        List<Product2> listOfProducts = [SELECT Id, Name FROM Product2 WHERE Phoenix_Is_Exclude_Bid__c =: false AND IsActive=: true AND Id NOT IN: selectedProducts];
        return listOfProducts;
    }
    
    @AuraEnabled
    public static List<Phoenix_PHS_Price_Change__c> getPriceChangeData(Id recordId){
        List<Phoenix_PHS_Price_Change__c> PHSData = [SELECT Name, Phoenix_Contract__c, Phoenix_Contract__r.Name, RecordTypeId, Phoenix_Record_Type__c, Phoenix_Price_Start_Date__c, Phoenix_Price_End_Date__c, Phoenix_Approval_Status__c FROM Phoenix_PHS_Price_Change__c WHERE Id=:recordId LIMIT 1];
        return PHSData;
    }
    
    @AuraEnabled
    public static List<Phoenix_PHS_Price_Change_Line__c> getPriceChangeLineData(Id recordId){
        List<Phoenix_PHS_Price_Change_Line__c> PHSLineData = [SELECT Phoenix_Product_Name__c, Phoenix_Product_Name__r.Name, Phoenix_Material_Code__c, Phoenix_NDC_11__c, Phoenix_Provisional_PHS_Price__c, Phoenix_Price_Start_Date__c, Phoenix_Price_End_Date__c, Phoenix_Old_PHS_Price__c, Phoenix_New_PHS_Price__c, Phoenix_Change_in_Price__c, Phoenix_Last_90_days_PHS_Units__c, Phoenix_Sales_Difference__c, Phoenix_Diff_in_Apexus_Sub_Ceiling_Price__c, Apexus_Sub_Ceiling_Price_Change_Required__c, Phoenix_Remarks__c FROM Phoenix_PHS_Price_Change_Line__c WHERE Phoenix_PHS_Price_Change__r.Id=:recordId];
        return PHSLineData;
    }
    
    @AuraEnabled
    public static String deletePHSLine(String recordId) {
        if(recordId != null){
            Phoenix_PHS_Price_Change_Line__c PHSLineData = [Select Id from Phoenix_PHS_Price_Change_Line__c where Id=:recordId];
            delete PHSLineData;
        }
        return 'Success';
    }
    
    @AuraEnabled
    public static wrapperClassChangeLine getChangeLineQuarterly(Id recordId, Id apexusContractId){
        wrapperClassChangeLine wrap = new wrapperClassChangeLine();
        List<Phoenix_PHS_Price_Change_Line__c> PHSLineData = new List<Phoenix_PHS_Price_Change_Line__c>();
        List<Phoenix_NPR_Data__c> nprPriceList = new List<Phoenix_NPR_Data__c>();
        Map<Id, String> priceList = new Map<Id, String>();
        Map<Id, Decimal> priceList2 = new Map<Id, Decimal>();
        Map<Id, Decimal> newPricelist = new  Map<Id, Decimal>();
        PHSLineData = [SELECT Phoenix_Product_Name__c, ProductName__c, Phoenix_Product_Name__r.Name, Phoenix_Material_Code__c, Phoenix_NDC_11__c, Phoenix_Provisional_PHS_Price__c, Phoenix_Price_Start_Date__c, Phoenix_Price_End_Date__c, Phoenix_Old_PHS_Price__c, Phoenix_New_PHS_Price__c, Phoenix_Change_in_Price__c, Phoenix_Last_90_days_PHS_Units__c, Phoenix_Sales_Difference__c, Phoenix_Diff_in_Apexus_Sub_Ceiling_Price__c, Price_in_Apexus_Sub_Ceiling_Contract__c, Apexus_Sub_Ceiling_Price_Change_Required__c, Phoenix_Remarks__c, Phoenix_Finance_Approval__c,Phoenix_Finance_Approval_Remarks__c  FROM Phoenix_PHS_Price_Change_Line__c WHERE Phoenix_PHS_Price_Change__r.Id=:recordId];
        nprPriceList = [SELECT Phoenix_Product__c, Phoenix_Product__r.Name, Phoenix_NDC_11__c, Phoenix_Contract_Price__c, Phoenix_SalesUnit_90__c, Phoenix_Product__r.ProductCode FROM Phoenix_NPR_Data__c WHERE Phoenix_Contract__c=:apexusContractId AND Phoenix_NPR_Status__c=: 'Active' ORDER BY Phoenix_Product__r.Name];
        for(Phoenix_PHS_Price_Change_Line__c item: PHSLineData){
            priceList.put(item.Phoenix_Product_Name__c, item.Phoenix_Material_Code__c);
        }
        for(Phoenix_NPR_Data__c item: nprPriceList){
            priceList2.put(item.Phoenix_Product__c, item.Phoenix_Contract_Price__c);
        }
        for(Id productId : priceList.keySet()){
            newPricelist.put(productId, priceList2.get(productId));
        }        
        wrap.PHSLineData = PHSLineData;
        wrap.priceList = newPricelist;
        return wrap;
    }
    
    public class wrapperClassChangeLine{
        
        @AuraEnabled public List<Phoenix_PHS_Price_Change_Line__c> PHSLineData; 
        @AuraEnabled public Map<Id, Decimal> priceList;
        wrapperClassChangeLine(){
            PHSLineData = new List<Phoenix_PHS_Price_Change_Line__c>();
            priceList = new Map<Id, Decimal>();
        }
    }
    @AuraEnabled
    public static List<Phoenix_PHS_Price_Change_Line__c> updatePHSChangeLineItems(List<Phoenix_PHS_Price_Change_Line__c> listLineItems){
      
        
        update listLineItems;
        return listLineItems;
    }
    
    @AuraEnabled
    public static void deleteLineItems(String LineItemId) {
        if (LineItemId != null) {
            Phoenix_PHS_Price_Change_Line__c deletedLineItem = [SELECT Id FROM Phoenix_PHS_Price_Change_Line__c WHERE Id =: LineItemId];
            delete deletedLineItem;
        }
    }
    
    @AuraEnabled
    public static string getSubmitBidInfo(Id bidId) {
       string response = Phoenix_SubmitBidForApprovalCtrl.submitPHSPriceChange(bidId);
        //system.debug('warpper---' + warpper.error);
       // string response = Phoenix_SubmitBidForApprovalCtrl.submitBid(warpper);
        //system.debug('response--' + response);
        return response;
    }
    @AuraEnabled
    public static list < Phoenix_PHS_Price_Change_Line__c > getupdatedforExport(Id bidId) {
        String query = '';
        String SobjectApiName = 'Phoenix_PHS_Price_Change_Line__c';
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
        query = 'select Phoenix_PHS_Price_Change__r.Phoenix_Approval_Status__c,Phoenix_Product_Name__r.Name,  ' + strFields + ' from ' + SobjectApiName + ' where Phoenix_PHS_Price_Change__c = : bidId AND Phoenix_Final_Status__c !=: notApproved';
        list < Phoenix_PHS_Price_Change_Line__c > quoteList = Database.query(query);
        return quoteList;
    }
  @AuraEnabled
    public static Wrapper getRelatedList(Id recordId){
        
        
      
        
        Wrapper wrapperObject = new Wrapper();
        List < String > leadValues = new List < String > ();
        String query = '';
        String SobjectApiName = 'Phoenix_PHS_Price_Change_Line__c';
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
        Phoenix_PHS_Price_Change__c bid = [SELECT Id, Name,RecordType.Name,Phoenix_Approval_Status__c FROM Phoenix_PHS_Price_Change__c WHERE Id =: recordId];
        string loggedUserName = UserInfo.getName();
        string notApproved = 'Not Approved';
       
        query = 'select Phoenix_PHS_Price_Change__r.Phoenix_Approval_Status__c,Phoenix_Product_Name__r.Name, ' + strFields + ' from ' + SobjectApiName + ' where Phoenix_PHS_Price_Change__c = : recordId and Phoenix_Final_Status__c !=: notApproved';

       
        list < Phoenix_PHS_Price_Change_Line__c > quoteList = Database.query(query);
        system.debug('quoteList--->' + quoteList);
     
     
    
    
        

        Map < String, String > userTeamUserIdMap = new Map < String, String > ();
        for (Phoenix_User_Approval_Matrix__c matrix: [Select Id, Name, RecordType.DeveloperName, User_Group__r.Phoenix_Approver_Group_Name__c, Phoenix_Approval_Group_Behavior__c, Phoenix_Approver__c, Phoenix_Approver__r.Email, Phoenix_Approver_Group_Name__c, Phoenix_Is_Active_User__c, Phoenix_Is_Approval_Process_User__c, User_Group__c from Phoenix_User_Approval_Matrix__c limit 1000]) {
            String userTeamUserIdMapKey = matrix.User_Group__r.Phoenix_Approver_Group_Name__c + '-' + matrix.Phoenix_Approver__c;
            userTeamUserIdMap.put(userTeamUserIdMapKey, matrix.Phoenix_Approver__c);
        }
      
        boolean isFinanceApprovePerson = false;
      
        boolean isVistexApprovePerson = false;

       
        if (userTeamUserIdMap.containsKey('Sr Director or VP Finance-' + UserInfo.getUserId())) {
            isFinanceApprovePerson = true;
        }
      
        if (userTeamUserIdMap.containsKey('Home Office-' + UserInfo.getUserId())) {
            isVistexApprovePerson = true;
        }

       
       wrapperObject.lineItemsList = quoteList;
       wrapperObject.bidRecord = bid;
       wrapperObject.loggedInUserName = UserInfo.getName();
       wrapperObject.loggedInUserId = UserInfo.getUserId();
       wrapperObject.isFinanceApprovePerson = isFinanceApprovePerson;
       wrapperObject.isVistexApprovePerson = isVistexApprovePerson;
       
      
      system.debug(';loggedInUserName' + wrapperObject.loggedInUserName);
      return wrapperObject;
    }
  
    
   
    @AuraEnabled
    public static list < Phoenix_PHS_Price_Change_Line__c > submitToProceddStep1(string bidId) {
        String query = '';
        String SobjectApiName = 'Phoenix_PHS_Price_Change_Line__c';
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
        query = 'select Phoenix_PHS_Price_Change__r.Phoenix_Approval_Status__c,Phoenix_Product_Name__r.Name, ' + strFields + ' from ' + SobjectApiName + ' where Phoenix_PHS_Price_Change__c  = : bidId AND Phoenix_Final_Status__c !=: notApproved';
       
        list < Phoenix_PHS_Price_Change_Line__c > bidLinesList = Database.query(query);
        return bidLinesList;

    }
  
    @AuraEnabled
    public static WrapperForNextSteps makeApprovals(String bidId, List < Phoenix_PHS_Price_Change_Line__c > bidlines, boolean approveStatusFlag,boolean isFinance,boolean isVistex) {
       boolean vistexNextStepFlag = false;
        for (Phoenix_PHS_Price_Change_Line__c line: bidlines) {
           


            if (isFinance) {
                line.Phoenix_Final_Finance_Approval__c = true;
                if (line.Phoenix_Finance_Approval__c == 'Not Approved') {
                    line.Phoenix_Final_Status__c = 'Not Approved';
                }
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
        list < Phoenix_Bid_Process_Steps__c > bidProcessStepList = [SELECT Id, Name, Phoenix_PHS_Price_Change__c,Phoenix_NDC_Change__c,Phoenix_Bid__c, Phoenix_Process_Step__c, Phoenix_Step__c, Phoenix_Approver__r.Name,Phoenix_Approver__r.Email, Phoenix_Approver__c, Phoenix_Status__c, Phoenix_Approver_Team__c FROM Phoenix_Bid_Process_Steps__c where Phoenix_PHS_Price_Change__c =: bidId];
        list < Phoenix_Bid_Process_Steps__c > contractsStepLsit = new list < Phoenix_Bid_Process_Steps__c > ();
        for (Phoenix_Bid_Process_Steps__c step: bidProcessStepList) {

          
            if (step.Phoenix_Approver_Team__c == 'Sr Director or VP Finance' && isFinance) {
                step.Phoenix_Status__c = approveStatusFlag == true ? 'Completed' : 'Do Not Bid';
                 step.Phoenix_Approver__c=UserInfo.getUserId();
                contractsStepLsit.add(step);
            }
         
             if (step.Phoenix_Approver_Team__c == 'Home Office' && isVistex) {
                step.Phoenix_Status__c = (approveStatusFlag == true && vistexNextStepFlag==false) ? 'Completed' : 'In Process';
                 
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
     public static void updateNextProcesSteps(string bidId, list < Phoenix_Bid_Process_Steps__c > processStepLsit,boolean vistexNextStepFlag, boolean isFinance,boolean isVistex) {
      
        system.debug('In vistexNextStepFlag' + vistexNextStepFlag);
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
            
             list < Phoenix_PHS_Price_Change_Line__c > bidLinesUpdate = [select id, Phoenix_Final_Status__c from Phoenix_PHS_Price_Change_Line__c where Phoenix_PHS_Price_Change__c =: bidId];
        boolean isAllRejectedCaseFound = true;
        for (Phoenix_PHS_Price_Change_Line__c lineItem: bidLinesUpdate) {
            if (lineItem.Phoenix_Final_Status__c != 'Not Approved') {
                isAllRejectedCaseFound = false;
            }
        }
        if (isAllRejectedCaseFound) {
            
             if(isFinance){
            integer currentStepNum = stepnameNoMap.get('Sr Director or VP Finance');
            for (Phoenix_Bid_Process_Steps__c prcsStep: processStepLsit) {
                if (prcsStep.Phoenix_Approver_Team__c == 'Sr Director or VP Finance') {
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
            Phoenix_PHS_Price_Change__c bid = new Phoenix_PHS_Price_Change__c(id = bidId, Phoenix_Approval_Status__c = 'Sr Director or VP Finance Rejected');
            update bid;
        }
             
            
            
             
              
           
           
        }
            
            else{  
        
            List < Phoenix_Bid_Process_Steps__c > nextSteps = new list < Phoenix_Bid_Process_Steps__c > ();
            Integer stepNo;
          

              if(isFinance){
                   stepNo = stepnameNoMap.get('Sr Director or VP Finance') + 1;
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
                  Phoenix_PHS_Price_Change__c bid = new Phoenix_PHS_Price_Change__c(id = bidId);

              if(isFinance){
                  bid.Phoenix_Approval_Status__c='Vistex Update';
            }
             
              if(isVistex){
                    bid.Phoenix_Approval_Status__c='Closed';
            }
              
                update bid;
                Phoenix_SubmitBidForApprovalCtrl.approvalRequestNotification(bidId,nextSteps);
            }
            }
            
        } 
         
             else {
                 if(vistexNextStepFlag){
                      Phoenix_PHS_Price_Change__c bid = new Phoenix_PHS_Price_Change__c(id = bidId, Phoenix_Approval_Status__c = 'Vistex Update');
            update bid;
                   
                 }
                     
                     else{
                         
                   Phoenix_PHS_Price_Change__c bid = new Phoenix_PHS_Price_Change__c(id = bidId, Phoenix_Approval_Status__c = 'Closed');
            update bid;
                     }
        }
    }
 public class WrapperForNextSteps {
        @AuraEnabled public list < Phoenix_Bid_Process_Steps__c > updateProcessStepList;
     
     
        @AuraEnabled public boolean contractNextStepFlag;

        WrapperForNextSteps() {
            updateProcessStepList = new List < Phoenix_Bid_Process_Steps__c > ();
          
            
            contractNextStepFlag = false;
        }
    }
    public class Wrapper {

        @AuraEnabled public List < Phoenix_PHS_Price_Change_Line__c > lineItemsList;
        @AuraEnabled public Phoenix_PHS_Price_Change__c bidRecord;
        @AuraEnabled public string loggedInUserName;
        @AuraEnabled public string loggedInUserId;
        @AuraEnabled public boolean isVistexApprovePerson;
        @AuraEnabled public boolean isFinanceApprovePerson;
    Wrapper() {

            lineItemsList = new List < Phoenix_PHS_Price_Change_Line__c > ();
            bidRecord = new Phoenix_PHS_Price_Change__c();
         
           
            loggedInUserName = '';
        
            loggedInUserId = '';

          
        }
    }
    
}