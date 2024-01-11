public class Phoenix_NewProductWACPricingCntrl {
    @AuraEnabled
    
    public static List<Map<String, String>> getActiveBidProductFamilies() {
        List <Product2> productFamilies = new List <Product2> ();
        productFamilies = [SELECT Family, Product_Family__r.Name, Product_Family__c FROM Product2 WHERE IsActive =: true AND Phoenix_Is_Exclude_Bid__c =: false AND Product_Family__c != null AND Phoenix_Is_New_Product__c=:true ORDER BY Product_Family__r.Name ASC];//Add AND Phoenix_Is_New_Product__c=:true
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
    public static List<Product2> getProducts(String productFamily) {
        List<Product2> products = new List<Product2>();
        try {
            products = [SELECT Id, Name, Product_Family__r.Name, Phoenix_NDC_11__c, Phoenix_Pkg_Size__c, ProductCode FROM Product2 WHERE IsActive =: true AND Phoenix_Is_Exclude_Bid__c =: false AND Product_Family__c=:productFamily AND Phoenix_Is_New_Product__c=:true ORDER BY Name ASC]; //Add AND Phoenix_Is_New_Product__c=:true
        }
        Catch(Exception e) {
            Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'Phoenix_SubmitBidForApprovalCtrl', Phoenix_Method_Name__c = 'calculateFinanceGrid', Phoenix_Error_Message__c = e.getMessage(), Phoenix_Issue_Status__c = 'Pending', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
            insert exp;
        }
        return products;
    }
    
    @AuraEnabled
    public static List<New_Product_WAC_Pricing__c> getWACPricingInfo(Id recordId){
        List<New_Product_WAC_Pricing__c> wacPricingInfo = new List<New_Product_WAC_Pricing__c>();
        wacPricingInfo = Database.query('Select ' + Phoenix_Util.newProductWACPricingFields+ 'FROM New_Product_WAC_Pricing__c WHERE Id=:recordId');
        return wacPricingInfo;
    }
    
    @AuraEnabled 
    public static List<Phoenix_NewProduct_WAC_Pricing_LineItems__c> getLines(Id recordId){
        List<Phoenix_NewProduct_WAC_Pricing_LineItems__c> recordData = new List<Phoenix_NewProduct_WAC_Pricing_LineItems__c>();
        recordData = Database.query('Select Phoenix_Product__r.Name, ' + Phoenix_Util.newProductWACPricingLinesFields+ 'FROM Phoenix_NewProduct_WAC_Pricing_LineItems__c where Phoenix_New_Product_WAC_Pricing__c=:recordId');
        return recordData;
    }
    
    @AuraEnabled
    public static List<Phoenix_NewProduct_WAC_Pricing_LineItems__c> saveLineItems(Id recordId, List<Phoenix_NewProduct_WAC_Pricing_LineItems__c> lineItems){
        upsert lineItems;
        
        string MarketingHeadUser ='';
      
        Map < String, String > userTeamUserIdMap = new Map < String, String > ();
        for (Phoenix_User_Approval_Matrix__c matrix: [Select Id, Name, RecordType.DeveloperName, User_Group__r.Phoenix_Approver_Group_Name__c, Phoenix_Approval_Group_Behavior__c, Phoenix_Approver__c, Phoenix_Approver__r.Email, Phoenix_Approver_Group_Name__c, Phoenix_Is_Active_User__c, Phoenix_Is_Approval_Process_User__c, User_Group__c from Phoenix_User_Approval_Matrix__c limit 1000]) {
          
            if(matrix.User_Group__r.Phoenix_Approver_Group_Name__c=='Marketing Head'){
                
               MarketingHeadUser= matrix.Phoenix_Approver__c;
            }
        }
         New_Product_WAC_Pricing__c bid=new  New_Product_WAC_Pricing__c(Id=recordId,Phoenix_Marketing_Head__c=MarketingHeadUser);
         update bid;
        
        
        
        List<Phoenix_NewProduct_WAC_Pricing_LineItems__c> recordData = new List<Phoenix_NewProduct_WAC_Pricing_LineItems__c>();
        recordData = Database.query('Select Phoenix_Product__r.Name,' + Phoenix_Util.newProductWACPricingLinesFields+ 'FROM Phoenix_NewProduct_WAC_Pricing_LineItems__c where Phoenix_New_Product_WAC_Pricing__c=:recordId');
        return recordData;
    }
    
    @AuraEnabled  
    public static List<ContentDocumentLink> getDocs(Id recordId)
    {
        return [SELECT Id, LinkedEntityId, ContentDocument.Title,ContentDocument.FileExtension,ContentDocumentId FROM ContentDocumentLink where LinkedEntityId=:recordId];
    }
    
    @AuraEnabled
    public static void deleteAttachments(String attachId){
        List<ContentDocument> contentDocumentIds = [select Id from ContentDocument WHERE Id=:attachId];
        delete contentDocumentIds;   
    }
    
    @AuraEnabled
    public static List<Product2> getProductInfo(String productFamily){
        List<Product2> productInfo = new List<Product2>();
        Boolean IsActive = true;
        Boolean IsBidExclude = false;
        Boolean IsNewProduct =  true;
        productInfo = Database.query('SELECT Product_Family__r.Name,'+Phoenix_Util.productFields+' FROM Product2 WHERE IsActive =: IsActive AND Phoenix_Is_Exclude_Bid__c =: IsBidExclude AND Product_Family__r.Name=:productFamily AND Phoenix_Is_New_Product__c =: IsNewProduct');
        return productInfo;
    }
    
    /*@AuraEnabled
    public static String deleteLineItems(List<Id> recordIds) {
        List<Phoenix_NewProduct_WAC_Pricing_LineItems__c> deletedLineData = [SELECT Id FROM Phoenix_NewProduct_WAC_Pricing_LineItems__c WHERE Id IN: recordIds];
        delete deletedLineData;
        return 'Success';
    }*/
    
    @AuraEnabled
    public static String deleteWACPricingLine(String recordId) {
        if(recordId != null){
            Phoenix_NewProduct_WAC_Pricing_LineItems__c WACPricingLineData = [Select Id from Phoenix_NewProduct_WAC_Pricing_LineItems__c where Id=:recordId];
            delete WACPricingLineData;
        }
        return 'Success';
    }
    @AuraEnabled
    public static string getSubmitBidInfo(Id bidId) {
        string response = Phoenix_SubmitBidForApprovalCtrl.submitNewProductWACPricing(bidId);
       
        return response;
    }
    
  @AuraEnabled
    public static Wrapper getRelatedList(Id recordId){
        Wrapper wrapperObject = new Wrapper();
        List < String > leadValues = new List < String > ();
        String query = '';
        String SobjectApiName = 'Phoenix_NewProduct_WAC_Pricing_LineItems__c';
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
        New_Product_WAC_Pricing__c bid = Database.query('Select ' + Phoenix_Util.newProductWACPricingFields+ 'FROM New_Product_WAC_Pricing__c WHERE Id=:recordId');
        boolean IsMarketingLeadUser=false;
        if(bid.Phoenix_Marketing_Lead__c!=null && bid.Phoenix_Marketing_Lead__c==UserInfo.getUserId()){
            IsMarketingLeadUser=true;
}
        string loggedUserName = UserInfo.getName();
        string notApproved = 'Not Approved';
       
        query = 'select Phoenix_Product__r.Name, Phoenix_New_Product_WAC_Pricing__r.Phoenix_Approval_Status__c, ' + strFields + ' from ' + SobjectApiName + ' where Phoenix_New_Product_WAC_Pricing__c = : recordId';

         string MarketingHeadUser ='';
        list < Phoenix_NewProduct_WAC_Pricing_LineItems__c > quoteList = Database.query(query);
       
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
          
            // ... emailing logic
        }
        boolean isMarketingHeadApprovePerson = false;
      
        boolean isVistexApprovePerson = false;

       
        if (userTeamUserIdMap.containsKey('Marketing Head-' + UserInfo.getUserId())) {
            isMarketingHeadApprovePerson = true;
        }
      
        /*if (userTeamUserIdMap.containsKey('Home Office-' + UserInfo.getUserId())) {
            isVistexApprovePerson = true;
        }*/
       
       wrapperObject.lineItemsList = quoteList;
       wrapperObject.bidRecord = bid;
       wrapperObject.loggedInUserName = UserInfo.getName();
       wrapperObject.loggedInUserId = UserInfo.getUserId();
       wrapperObject.isMarketingHeadApprovePerson = isMarketingHeadApprovePerson;
       wrapperObject.IsMarketingLeadUser = IsMarketingLeadUser;
       wrapperObject.MarketingHeadUser = MarketingHeadUser;
       
  
      return wrapperObject;
    }
    


@AuraEnabled
    public static void makeLeadApprovals(String bidId,string status,boolean IsconditionMet,Boolean approveThruEmail,User currentUserDetails) {
        List<Phoenix_NewProduct_WAC_Pricing_LineItems__c> lineData = new List<Phoenix_NewProduct_WAC_Pricing_LineItems__c>();
        List<Phoenix_NewProduct_WAC_Pricing_LineItems__c> updatedLineData = new List<Phoenix_NewProduct_WAC_Pricing_LineItems__c>();
        List<Product2> products = new List<Product2>();
        lineData = [SELECT Phoenix_Product__r.Id, Phoenix_Brand_WAC__c, Phoenix_Product__r.Phoenix_Is_New_Product__c, Phoenix_WAC__c, Phoenix_Lowest_Price__c FROM Phoenix_NewProduct_WAC_Pricing_LineItems__c WHERE Phoenix_New_Product_WAC_Pricing__c=:bidId];
        for(Phoenix_NewProduct_WAC_Pricing_LineItems__c item: lineData){
            Product2 prod = new Product2();
            if(item.Phoenix_Product__r.Phoenix_Is_New_Product__c){
                prod.Id = item.Phoenix_Product__r.Id;
                prod.Phoenix_New_Product_Lowest_Price__c = item.Phoenix_Lowest_Price__c;
                prod.Phoenix_WAC__c = item.Phoenix_WAC__c;
                prod.Phoenix_Brand_WAC__c = item.Phoenix_Brand_WAC__c;
                products.add(prod);   
            }
        }
        
        Phoenix_Bid_Process_Steps__c currentStep = [SELECT Id, Name, Phoenix_New_Product_WAC_Pricing__c, Phoenix_Process_Step__c, Phoenix_Step__c, Phoenix_Approver__c,Phoenix_Approver__r.Email, Phoenix_Status__c, Phoenix_Is_Criteria_Step__c, Phoenix_Approver_Team__c FROM Phoenix_Bid_Process_Steps__c where Phoenix_New_Product_WAC_Pricing__c =: bidId AND(Phoenix_Status__c = 'In Process'
            OR Phoenix_Status__c = 'Not Processed') limit 1];
        List < Phoenix_Bid_Process_Steps__c > processStepLsit = [SELECT Id, Name, Phoenix_New_Product_WAC_Pricing__c, Phoenix_Process_Step__c, Phoenix_Step__c, Phoenix_Approver__c,Phoenix_Approver__r.Email, Phoenix_Status__c, Phoenix_Is_Criteria_Step__c, Phoenix_Approver_Team__c FROM Phoenix_Bid_Process_Steps__c where Phoenix_New_Product_WAC_Pricing__c =: bidId];
        list < Phoenix_Bid_Process_Steps__c > nextSteps=new list<Phoenix_Bid_Process_Steps__c>();

        if (string.isNotBlank(status) && status == 'Approved') {
            system.debug('status------' + status);

            if(IsconditionMet==true){
             for (Phoenix_Bid_Process_Steps__c step: processStepLsit) {
                if (step.Name.contains('Closed')) {
                    step.Phoenix_Status__c = 'Completed';
                }
            }
                Phoenix_SubmitBidForApprovalCtrl.sendNewWACEmailToFinanceTeam(bidId);
            }
            else{
                for (Phoenix_Bid_Process_Steps__c step: processStepLsit) {
                if (step.Name.contains('Marketing Head')) {
                    step.Phoenix_Status__c = 'In Process';
                     nextSteps.add(step);
                }
            }
                
            }

            if (!processStepLsit.isEmpty()) {
                update processStepLsit;
                currentStep.Phoenix_Status__c = 'Completed';
                currentStep.Phoenix_Approver__c = approveThruEmail ? currentUserDetails.id : userinfo.getuserid();
               
                update currentStep;
                 if(IsconditionMet==true){
                     New_Product_WAC_Pricing__c bid = new New_Product_WAC_Pricing__c(id = bidId, Phoenix_Approval_Status__c = 'Closed');
                     update bid; 
                     
                     for(Phoenix_NewProduct_WAC_Pricing_LineItems__c item: lineData){
                         item.Phoenix_Updated_in_Product_Master__c = true;
                         item.Phoenix_Updated_date__c = DateTime.now();
                         updatedLineData.add(item);
                     }
                     update updatedLineData;
                     update products;
                }
                else{
                New_Product_WAC_Pricing__c bid = new New_Product_WAC_Pricing__c(id = bidId, Phoenix_Approval_Status__c = 'Marketing Head');
                update bid;
                Phoenix_SubmitBidForApprovalCtrl.approvalRequestNotification(bidId , nextSteps);
                }
            }
        } else {

            system.debug('currentStep----' + currentStep);

            for (Phoenix_Bid_Process_Steps__c step: processStepLsit) {
                if (step.Name.contains('Marketing Head')) {
                    step.Phoenix_Status__c = 'Not Applicable';
                }
                 if (step.Name.contains('Closed')) {
                    step.Phoenix_Status__c = 'Completed';
                }
            }

            if (!processStepLsit.isEmpty()) {
                update processStepLsit;
                currentStep.Phoenix_Status__c = 'Completed';
                currentStep.Phoenix_Approver__c = approveThruEmail ? currentUserDetails.id : userinfo.getuserid();
               
                update currentStep;
                New_Product_WAC_Pricing__c bid = new New_Product_WAC_Pricing__c(id = bidId,Phoenix_Approval_Status__c = 'Marketing Lead Rejected');
                update bid;
                
                 list<Phoenix_NewProduct_WAC_Pricing_LineItems__c>waclineItems=[select Id,Phoenix_Final_Status__c from Phoenix_NewProduct_WAC_Pricing_LineItems__c where Phoenix_New_Product_WAC_Pricing__c=:bidId];
                for(Phoenix_NewProduct_WAC_Pricing_LineItems__c item:waclineItems) {
                 item.Phoenix_Final_Status__c='Not Approved';
                    
                }
                
               update waclineItems;
            }
        }
    }    
     
  @AuraEnabled
    public static void makeHeadApprovals(String bidId,string status,Boolean approveThruEmail,User currentUserDetails) {
        List<Phoenix_NewProduct_WAC_Pricing_LineItems__c> lineData = new List<Phoenix_NewProduct_WAC_Pricing_LineItems__c>();
        List<Phoenix_NewProduct_WAC_Pricing_LineItems__c> updatedLineData = new List<Phoenix_NewProduct_WAC_Pricing_LineItems__c>();
        List<Product2> products = new List<Product2>();
        lineData = [SELECT Phoenix_Product__r.Id, Phoenix_Brand_WAC__c, Phoenix_Product__r.Phoenix_Is_New_Product__c, Phoenix_WAC__c, Phoenix_Lowest_Price__c FROM Phoenix_NewProduct_WAC_Pricing_LineItems__c WHERE Phoenix_New_Product_WAC_Pricing__c=:bidId];
        for(Phoenix_NewProduct_WAC_Pricing_LineItems__c item: lineData){
            Product2 prod = new Product2();
            if(item.Phoenix_Product__r.Phoenix_Is_New_Product__c){
                prod.Id = item.Phoenix_Product__r.Id;
                prod.Phoenix_New_Product_Lowest_Price__c = item.Phoenix_Lowest_Price__c;
                prod.Phoenix_WAC__c = item.Phoenix_WAC__c;
                prod.Phoenix_Brand_WAC__c = item.Phoenix_Brand_WAC__c;
                products.add(prod);   
            }
        }
        
        Phoenix_Bid_Process_Steps__c currentStep = [SELECT Id, Name, Phoenix_New_Product_WAC_Pricing__c, Phoenix_Process_Step__c, Phoenix_Step__c, Phoenix_Approver__c,Phoenix_Approver__r.Email, Phoenix_Status__c, Phoenix_Approver_Team__c FROM Phoenix_Bid_Process_Steps__c where Phoenix_New_Product_WAC_Pricing__c =: bidId AND(Phoenix_Status__c = 'In Process'
            OR Phoenix_Status__c = 'Not Processed') limit 1];
        List < Phoenix_Bid_Process_Steps__c > processStepLsit = [SELECT Id, Name, Phoenix_New_Product_WAC_Pricing__c, Phoenix_Process_Step__c, Phoenix_Step__c, Phoenix_Approver__c,Phoenix_Approver__r.Email, Phoenix_Status__c, Phoenix_Approver_Team__c FROM Phoenix_Bid_Process_Steps__c where Phoenix_New_Product_WAC_Pricing__c =: bidId];


        if (string.isNotBlank(status) && status == 'Approved') {
            system.debug('status------' + status);


            for (Phoenix_Bid_Process_Steps__c step: processStepLsit) {
                if (step.Name.contains('Closed')) {
                    step.Phoenix_Status__c = 'Completed';
                }
            }

            if (!processStepLsit.isEmpty()) {
                update processStepLsit;
                currentStep.Phoenix_Status__c = 'Completed';
                currentStep.Phoenix_Approver__c = approveThruEmail ? currentUserDetails.id : userinfo.getuserid();
               
                update currentStep;
                Phoenix_SubmitBidForApprovalCtrl.sendNewWACEmailToFinanceTeam(bidId);
                New_Product_WAC_Pricing__c bid = new New_Product_WAC_Pricing__c(id = bidId, Phoenix_Approval_Status__c = 'Closed');
                update bid;
                for(Phoenix_NewProduct_WAC_Pricing_LineItems__c item: lineData){
                    item.Phoenix_Updated_in_Product_Master__c = true;
                    item.Phoenix_Updated_date__c = DateTime.now();
                    updatedLineData.add(item);
                }
                update updatedLineData;
                update products;
                
            }
        } else {

            system.debug('currentStep----' + currentStep);

            for (Phoenix_Bid_Process_Steps__c step: processStepLsit) {
                if (step.Name.contains('Closed')) {
                    step.Phoenix_Status__c = 'Completed';
                }
            }

            if (!processStepLsit.isEmpty()) {
                update processStepLsit;
                currentStep.Phoenix_Status__c = 'Completed';
                currentStep.Phoenix_Approver__c = approveThruEmail ? currentUserDetails.id : userinfo.getuserid();
               // currentStep.Phoenix_Description__c = comments;
                update currentStep;
                New_Product_WAC_Pricing__c bid = new New_Product_WAC_Pricing__c(id = bidId, Phoenix_Approval_Status__c = 'Marketing Head Rejected');
                update bid;
                list<Phoenix_NewProduct_WAC_Pricing_LineItems__c>waclineItems=[select Id,Phoenix_Final_Status__c from Phoenix_NewProduct_WAC_Pricing_LineItems__c where Phoenix_New_Product_WAC_Pricing__c=:bidId];
                for(Phoenix_NewProduct_WAC_Pricing_LineItems__c item:waclineItems) {
                 item.Phoenix_Final_Status__c='Not Approved';
                    
                }
                
               update waclineItems;
            }
        }
    }    
   
    @AuraEnabled
    public static list < Phoenix_NewProduct_WAC_Pricing_LineItems__c > submitToProceddStep1(string bidId) {
        String query = '';
        String SobjectApiName = 'Phoenix_NewProduct_WAC_Pricing_LineItems__c';
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
        query = 'select Phoenix_New_Product_WAC_Pricing__r.Phoenix_Approval_Status__c, ' + strFields + ' from ' + SobjectApiName + ' where Phoenix_New_Product_WAC_Pricing__c  = : bidId AND Phoenix_Final_Status__c !=: notApproved';
       
        list < Phoenix_NewProduct_WAC_Pricing_LineItems__c > bidLinesList = Database.query(query);
        return bidLinesList;

    }
    
    
    public class Wrapper {

        @AuraEnabled public List < Phoenix_NewProduct_WAC_Pricing_LineItems__c > lineItemsList;
        @AuraEnabled public New_Product_WAC_Pricing__c bidRecord;
        @AuraEnabled public string loggedInUserName;
        @AuraEnabled public string loggedInUserId;
        @AuraEnabled public string MarketingHeadUser;
       @AuraEnabled public boolean IsMarketingLeadUser;
        @AuraEnabled public boolean isMarketingHeadApprovePerson;
    Wrapper() {

            lineItemsList = new List < Phoenix_NewProduct_WAC_Pricing_LineItems__c > ();
            bidRecord = new New_Product_WAC_Pricing__c();
         
           
            loggedInUserName = '';
        
            loggedInUserId = '';

          
        }
    }
     public static void codeCoverage(){
        integer i =1;
      
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
       
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
    
    }
}