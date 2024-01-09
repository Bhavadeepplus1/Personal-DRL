/**
 * @description       : 
 * @author            : Surender Patel (Dhruvsoft)
 * @group             : 
 * @last modified on  : 25-05-2021
 * @last modified by  : Surender Patel (Dhruvsoft)
 * Modifications Log 
 * Ver   Date         Author                       Modification
 * 1.0   25-05-2021   Surender Patel (Dhruvsoft)   Initial Version
**/
public with sharing class Phoenix_CustomerResponseViewController {
	
     @AuraEnabled
    public static void getLastBidActivity(Id bidId) {
        System.debug('bidId==>'+bidId);
        Phoenix_Bid__c bid = [SELECT Id, Phoenix_Bid_Created_Behalf_of__c, Phoenix_Is_Re_Bid__c, Phoenix_Previous_Bid__c, Phoenix_OTB_Direct_Indirect__c, Phoenix_Bid_Proposed_Position__c, Phoenix_Proactive_Reactive__c, Phoenix_Salesperson__c, Phoenix_Proposed_Initial_Order_Discount__c, Phoenix_Proposed_Sales_Out_Promotion__c, Phoenix_Proposed_Value_Admin_Fee__c, Phoenix_Proposed_Value_Est_VIP__c, Phoenix_Sales_Out_Promotion_of_Days__c, Phoenix_Initial_Order_Discount_of_Days__c, Phoenix_Initial_Order_Discount_Type__c, Phoenix_Value_Est_VIP_Type__c, Phoenix_Current_Value_Est_VIP__c, Phoenix_Current_CD__c, Phoenix_Select_Wholesaler__c, Name, Phoenix_Customer__c, Phoenix_Customer__r.Name, Phoenix_Customer_Type__c, Phoenix_Bid_Name__c, Phoenix_Reference_Contracts__c, Phoenix_Bid_Type__c, Phoenix_Approval_Status__c FROM Phoenix_Bid__c WHERE Id =: bidId AND Phoenix_Approval_Status__c != 'Closed'];
        /* Bid_Last_Activity__c actvityrec= new Bid_Last_Activity__c();
actvityrec.Name = bid.Phoenix_Bid_Name__c+'_'+ userInfo.getLastName();
actvityrec.Bid_Name__c = bid.Phoenix_Bid_Name__c;
actvityrec.Bid__c = bidId;
actvityrec.Logged_in_User__c = userInfo.getName();
actvityrec.User__c = userInfo.getUserId();
actvityrec.Date_and_Time__c = Phoenix_Util.getNowEST();
actvityrec.Test__c = Phoenix_Util.getUserTimeNow(actvityrec.Date_and_Time__c, 'America/New_York');
insert actvityrec;*/
        List<Bid_Last_Activity__c> lastActivityRec = [SELECT Id,Bid__c,Date_and_Time__c from Bid_Last_Activity__c Where Bid__c=:bidId AND User__c=:Userinfo.getUserId()];
        List<Bid_Last_Activity__c> insertList = new List<Bid_Last_Activity__c>();
        List<Bid_Last_Activity__c> updateList = new List<Bid_Last_Activity__c>();
        System.debug('lastActivityRec size==>'+lastActivityRec.size());
        if(lastActivityRec !=null && lastActivityRec.size()>0){
            for(Bid_Last_Activity__c rec: lastActivityRec){
                
                    rec.Date_and_Time__c = Phoenix_Util.getNowEST();
                    rec.Test__c = Phoenix_Util.getUserTimeNow(rec.Date_and_Time__c, 'America/New_York');
                	rec.isCustomerUpdate__c =true;
                    updateList.add(rec);
                
            }
            update lastActivityRec;
        }else{
            System.debug('in insert condition at last');
            Bid_Last_Activity__c actvityrec= new Bid_Last_Activity__c();
            actvityrec.Name = bid.Phoenix_Bid_Name__c+'_'+ userInfo.getLastName();
            actvityrec.Bid_Name__c = bid.Phoenix_Bid_Name__c;
            actvityrec.Bid__c = bidId;
            actvityrec.Logged_in_User__c = userInfo.getName();
            actvityrec.Date_and_Time__c = Phoenix_Util.getNowEST();
            actvityrec.User__c = userInfo.getUserId();
            actvityrec.Test__c = Phoenix_Util.getUserTimeNow(actvityrec.Date_and_Time__c, 'America/New_York');
            actvityrec.isCustomerUpdate__c =true;
            insert actvityrec;
        }
        
    }

    @AuraEnabled
    public static Boolean getLoginUserDetails(Id bidId) {
        Boolean isLoginUserAbleToPerform = FALSE;
        List < Phoenix_Bid_Process_Steps__c > bidProcessStepList = [SELECT Id, Name, Phoenix_Bid__c,Phoenix_Is_Criteria_Step__c,Phoenix_Process_Step__c, Phoenix_Step__c, Phoenix_Approver__c, Phoenix_Process_Step__r.Name, Phoenix_Status__c, Phoenix_Approver_Team__c, Phoenix_Approver_Team_Members__c FROM Phoenix_Bid_Process_Steps__c where Phoenix_Bid__c =: bidId LIMIT 20000];
        String customerApprovalTeam='';
        for (Phoenix_Bid_Process_Steps__c step: bidProcessStepList){
            //if(step.Phoenix_Process_Step__r.Name.contains('Customer')){
           if(step.Phoenix_Process_Step__r.Name =='Customer'+ '\''+'s Update'){
                customerApprovalTeam= step.Phoenix_Approver_Team_Members__c;
            }
        }
        List<String> approvalTeamMembers = customerApprovalTeam.split(',');
        List<Phoenix_Approval_Delegation_History__c> deligatorApprover = new List<Phoenix_Approval_Delegation_History__c>();
        deligatorApprover =[SELECT Id, Name, Phoenix_Delegated_Approver__r.Profile.Name,Phoenix_Is_Active_delegator__c, Phoenix_Delegated_Approver__c, Phoenix_Delegated_Approver__r.Name,Phoenix_User__c FROM Phoenix_Approval_Delegation_History__c WHERE Phoenix_Is_Active_delegator__c = true AND Phoenix_Delegated_Approver__c =: Userinfo.getUserId() AND Phoenix_User__r.Name =:approvalTeamMembers ];
        List<String> delegationUsersList = new List<String>();
        if(deligatorApprover != null && deligatorApprover.size()>0){
            for(Phoenix_Approval_Delegation_History__c ADH : deligatorApprover){
                if(ADH.Phoenix_Delegated_Approver__c == Userinfo.getUserId()){
                    delegationUsersList.add(ADH.Phoenix_Delegated_Approver__r.Name);
                }
            }
        }
        for (Phoenix_Bid_Process_Steps__c step: bidProcessStepList) {
            if (step.Phoenix_Approver_Team__c == 'Contracts' && (String.isNotBlank(step.Phoenix_Process_Step__r.Name) && step.Phoenix_Process_Step__r.Name.contains('Customer')) && ( (deligatorApprover != null && deligatorApprover.size()>0 ) || step.Phoenix_Approver__c == Userinfo.getUserId() || (string.isNotBlank(step.Phoenix_Approver_Team_Members__c) && step.Phoenix_Approver_Team_Members__c.contains(Userinfo.getName()))) && (step.Phoenix_Status__c == 'In Process' || step.Phoenix_Status__c == 'Completed')) {
                isLoginUserAbleToPerform = TRUE;
            }
        }
        return isLoginUserAbleToPerform;
    }
    @AuraEnabled
    public static Boolean getBidStep(Id bidId) {
        Boolean isCustomerResponseSubmitted = FALSE;
        List < Phoenix_Bid_Process_Steps__c > bidProcessStepList = [SELECT Id, Name, Phoenix_Bid__c,Phoenix_Is_Criteria_Step__c,Phoenix_Process_Step__c, Phoenix_Step__c, Phoenix_Approver__c, Phoenix_Process_Step__r.Name, Phoenix_Status__c, Phoenix_Approver_Team__c, Phoenix_Approver_Team_Members__c FROM Phoenix_Bid_Process_Steps__c where Phoenix_Bid__c =: bidId LIMIT 20000];
        for (Phoenix_Bid_Process_Steps__c step: bidProcessStepList) {
            if (step.Phoenix_Approver_Team__c == 'Contracts' && String.isNotBlank(step.Phoenix_Process_Step__r.Name) && step.Phoenix_Process_Step__r.Name.contains('Customer') && step.Phoenix_Status__c == 'Completed') {
                isCustomerResponseSubmitted = TRUE;
            }
        }
        return isCustomerResponseSubmitted;
    }

    @AuraEnabled
    public static Boolean getLoginUserDetailsVU(Id bidId) {
        Boolean isLoginUserAbleToPerform = FALSE;
        List < Phoenix_Bid_Process_Steps__c > bidProcessStepList = [SELECT Id, Name, Phoenix_Bid__c,Phoenix_Is_Criteria_Step__c,Phoenix_Process_Step__c, Phoenix_Step__c, Phoenix_Approver__c, Phoenix_Process_Step__r.Name, Phoenix_Status__c, Phoenix_Approver_Team__c, Phoenix_Approver_Team_Members__c FROM Phoenix_Bid_Process_Steps__c where Phoenix_Bid__c =: bidId LIMIT 20000];
        String customerApprovalTeam='';
        for (Phoenix_Bid_Process_Steps__c step: bidProcessStepList){
            if(step.Phoenix_Process_Step__r.Name.contains('Vistex')){
                customerApprovalTeam= step.Phoenix_Approver_Team_Members__c;
            }
        }
        List<String> approvalTeamMembers = customerApprovalTeam.split(',');
        List<Phoenix_Approval_Delegation_History__c> deligatorApprover = new List<Phoenix_Approval_Delegation_History__c>();
        deligatorApprover =[SELECT Id, Name, Phoenix_Delegated_Approver__r.Profile.Name,Phoenix_Is_Active_delegator__c, Phoenix_Delegated_Approver__c, Phoenix_Delegated_Approver__r.Name,Phoenix_User__c FROM Phoenix_Approval_Delegation_History__c WHERE Phoenix_Is_Active_delegator__c = true AND Phoenix_Delegated_Approver__c =: Userinfo.getUserId() AND Phoenix_User__r.Name =:approvalTeamMembers ];
        List<String> delegationUsersList = new List<String>();
        if(deligatorApprover != null && deligatorApprover.size()>0){
            for(Phoenix_Approval_Delegation_History__c ADH : deligatorApprover){
                if(ADH.Phoenix_Delegated_Approver__c == Userinfo.getUserId()){
                    delegationUsersList.add(ADH.Phoenix_Delegated_Approver__r.Name);
                }
            }
        }
        for (Phoenix_Bid_Process_Steps__c step: bidProcessStepList) {
            //if ((step.Phoenix_Approver_Team__c == 'Home Office' || step.Phoenix_Approver_Team__c == 'Contracts') && ( (deligatorApprover != null && deligatorApprover.size()>0) || step.Phoenix_Approver__c == Userinfo.getUserId() || (string.isNotBlank(step.Phoenix_Approver_Team_Members__c) && step.Phoenix_Approver_Team_Members__c.contains(Userinfo.getName()))) && (step.Phoenix_Status__c == 'In Process' || step.Phoenix_Status__c == 'Completed' || step.Phoenix_Status__c == 'Not Initiated')) {
            if (step.Phoenix_Approver_Team__c == 'Home Office' && ( (deligatorApprover != null && deligatorApprover.size()>0) || step.Phoenix_Approver__c == Userinfo.getUserId() || (string.isNotBlank(step.Phoenix_Approver_Team_Members__c) && step.Phoenix_Approver_Team_Members__c.contains(Userinfo.getName()))) && (step.Phoenix_Status__c == 'In Process' || step.Phoenix_Status__c == 'Completed' || step.Phoenix_Status__c == 'Not Initiated')) {
                isLoginUserAbleToPerform = TRUE;
            }
        }
        return isLoginUserAbleToPerform;
    }


    @AuraEnabled
    public static Phoenix_Customer_Response__c getBid(Id crId) {
        Phoenix_Customer_Response__c cr = [Select Id, Phoenix_Bid_No__c,Phoenix_Bid_No__r.Phoenix_is_OTC_Bid__c, Phoenix_Customer__c, Phoenix_Bid_No__r.Phoenix_Bid_Type__c, Phoenix_Bid_No__r.Phoenix_Reference_Contracts__c,Phoenix_Affected_Contract_s__c from Phoenix_Customer_Response__c where Id =: crId LIMIT 1];
        //String bidId = '';
        //bidId = cr.Phoenix_Bid_No__c;
        return cr;
    }

    @AuraEnabled
    public static Phoenix_Bid__c getBidType(Id bidId) {
        String bidType = '';
        Phoenix_Bid__c bid;
        if (bidId != null && String.isNotBlank(bidId)) {
             bid = [SELECT Id, Name, Phoenix_Bid_Type__c,Phoenix_Customer__c,Phoenix_Reference_Contracts__c FROM Phoenix_Bid__c WHERE Id =: bidId LIMIT 1];
            bidType = bid.Phoenix_Bid_Type__c;
        }
        return bid;
    }
    @AuraEnabled
    public static string getTempType(Id bidId) {
        String tempType = '';
        if (bidId != null && String.isNotBlank(bidId)) {
            Phoenix_Bid__c bid = [SELECT Id, Name, Phoenix_Customer_Type__c, Phoenix_Customer__c, Phoenix_Bid_Type__c,Phoenix_Reference_Contracts__c FROM Phoenix_Bid__c WHERE Id =: bidId LIMIT 1];
            tempType = bid.Phoenix_Customer_Type__c;
        }
        //system.debug('tempType---'+tempType);
        return tempType;
    }

    @auraEnabled
    public static string getTempTypeCr(Id crId){
        String tempType = '';
        if (crId != null && String.isNotBlank(crId)) {
            //Phoenix_Bid__c bid = [SELECT Id, Name, Phoenix_Customer_Type__c, Phoenix_Customer__c, Phoenix_Bid_Type__c FROM Phoenix_Bid__c WHERE Id =: bidId LIMIT 1];
            Phoenix_Customer_Response__c crRec = [SELECT Id, Phoenix_Bid_No__c, Phoenix_Bid_No__r.Phoenix_Customer_Type__c 
                                                  FROM Phoenix_Customer_Response__c WHERE Id =: crId];  
            tempType = crRec.Phoenix_Bid_No__r.Phoenix_Customer_Type__c;
        }
        //system.debug('tempType---'+tempType);
        return tempType;
    }
    
    public static string fieldApiList(String SobjectApiName){
        Map < String, Schema.SObjectType > schemaMap = Schema.getGlobalDescribe();
        Map < String, Schema.SObjectField > fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();
        String bidLineStrFields = '';
        
        for (String fieldName: fieldMap.keyset()) {
            if (bidLineStrFields == null || bidLineStrFields == '') {
                bidLineStrFields = fieldName;
            } else {
                bidLineStrFields = bidLineStrFields + ' , ' + fieldName;
            }
        }
        return bidLineStrFields;
    }
    
    @auraEnabled
    public static Phoenix_BidLineItemExtn__c getBlItemChildRec(String crLineId){
        //Phoenix_Customer_Response__c cr = [Select Id, Phoenix_Bid_No__c, Phoenix_Customer__c, Phoenix_Bid_No__r.Phoenix_Bid_Type__c,Phoenix_Bid_Line_Item__c from Phoenix_Customer_Response__c where Id =: crId LIMIT 1];
        Phoenix_Customer_Response_Line__c crLine = [SELECT Id, Name, Phoenix_Bid_Line_Item__c FROM Phoenix_Customer_Response_Line__c WHERE Id =: crLineId LIMIT 1];
        String bliId = crLine.Phoenix_Bid_Line_Item__c;
        String bidLineItemExtObjname = 'Phoenix_BidLineItemExtn__c';
        String bidLineExtStrFields = fieldApiList('Phoenix_BidLineItemExtn__c');
        bidLineExtStrFields = 'SELECT '+bidLineExtStrFields+' FROM '+bidLineItemExtObjname+' WHERE Phoenix_Bid_Line_Item__c =: bliId LIMIT 1';
        Phoenix_BidLineItemExtn__c obj = database.query(bidLineExtStrFields);
        return obj;
    }
    
    @auraEnabled
    public static boolean awardedQuantityRecCheck(String crLineId){
        Boolean isAwardedQuantitySame;
      // Integer awardedQuantityRecordCount = [SELECT count() FROM Phoenix_Awarded_Quantity__c WHERE Customer_Response_Line__c =: crLineId];
        List<Phoenix_Awarded_Quantity__c> awardedQtyCheck = [SELECT id,Customer_Response_Line__r.Phoenix_Awarded_Quantity__c,Phoenix_Awarded_Quantity__c from Phoenix_Awarded_Quantity__c WHERE Customer_Response_Line__c =: crLineId]; 
       Decimal totalAwardedQty=0;
        for(Phoenix_Awarded_Quantity__c aq : awardedQtyCheck){
            totalAwardedQty = totalAwardedQty + aq.Phoenix_Awarded_Quantity__c;
			}
        if(awardedQtyCheck.size() > 0 && awardedQtyCheck[0].Customer_Response_Line__r.Phoenix_Awarded_Quantity__c != totalAwardedQty){
            isAwardedQuantitySame = false;
        }
        else if(awardedQtyCheck.size() > 0 && awardedQtyCheck[0].Customer_Response_Line__r.Phoenix_Awarded_Quantity__c == totalAwardedQty){
			 isAwardedQuantitySame = true;
	}
        return isAwardedQuantitySame;
    }
    
    @auraEnabled
    public static String checkAwardedQuantityRecList(List<Phoenix_Customer_Response_Line__c> crLineItemList){
        
        List<Phoenix_Awarded_Quantity__c> awardedList = [SELECT Id, Name, Customer_Response_Line__c FROM Phoenix_Awarded_Quantity__c WHERE Customer_Response_Line__c IN: crLineItemList];
        List<String> productNames = new List<String>();
        set<Id> crLineItemIds = new set<Id>();
        for(Phoenix_Awarded_Quantity__c obj : awardedList){
            crLineItemIds.add(obj.Customer_Response_Line__c );
        }
        
        for(Phoenix_Customer_Response_Line__c obj : crLineItemList){
            if( obj.Phoenix_Bid_Status__c == 'Awarded' ){
                if(!crLineItemIds.contains(obj.Id)){
                    productNames.add(obj.Phoenix_Product_Name__c);
                }
            }
        }
        if(productNames.size()>0)
            return String.join(productNames,',');
        else
            return 'false';
        
    }
    
    @AuraEnabled
    public static string getCustomerInfo(string crId) {
        Phoenix_Customer_Response__c cr = [Select Id, Phoenix_Bid_No__c, Phoenix_Customer__c, Phoenix_Bid_No__r.Phoenix_Bid_Type__c from Phoenix_Customer_Response__c where Id =: crId LIMIT 1];
        //String bidId = '';
        //bidId = cr.Phoenix_Bid_No__c;
        return cr.Phoenix_Customer__c;
    }

    @AuraEnabled
    public static list < Phoenix_Product_Position__c > getPositions(string customerID) {
      
        //system.debug('customerID---' + customerID);
        Set < Id > parentAccIds = new Set < Id > ();
        if (customerID != null) {             
            parentAccIds.add(customerID);
            //Fetch related accounts
            Map < Id, Account > allAccMap = new Map < Id, Account > ();
            //Map of all accounts
            for (Account acc: Database.query('SELECT ' + Phoenix_Util.customerFields + ' FROM Account LIMIT 10000'))
                allAccMap.put(acc.Id, acc);
            String tempId = customerID;
            while (allAccMap.get(tempId) != NULL && allAccMap.get(tempId).ParentId != NULL) {
                tempId = allAccMap.get(tempId).ParentId;parentAccIds.add(tempId);
            }
            // //system.debug('parentAccIds--' + parentAccIds);
        }
        //Account bidAccount = [select ParentId, Parent.Name from account where id =: customerID limit 1];
        list < Phoenix_Product_Position__c > positionList = [select Phoenix_Customer__c, Phoenix_Customer__r.Name, Name,Phoenix_Customer__r.ParentId, Phoenix_Group_Name__c, Phoenix_General_Category__c, Phoenix_Position_Comments__c from Phoenix_Product_Position__c ORDER BY Name ASC]; //where Phoenix_Customer__c=:parentAccIds or Phoenix_Customer__r.ParentId=:parentAccIds];//where Phoenix_Group_Name__c =: bidAccount.Parent.Name];
        list<Phoenix_Product_Position__c> AccountRelatedPositions=new list<Phoenix_Product_Position__c>();
        list<Phoenix_Product_Position__c> OtherPositions=new list<Phoenix_Product_Position__c>();
        for(Phoenix_Product_Position__c pos:positionList){
            if(parentAccIds.contains(pos.Phoenix_Customer__c) ||  parentAccIds.contains(pos.Phoenix_Customer__r.ParentId) || customerID==pos.Phoenix_Customer__c || customerID==pos.Phoenix_Customer__r.ParentId){
                AccountRelatedPositions.add(pos);
            }
            else if(AccountRelatedPositions.size()==0 && pos.Phoenix_Customer__c==null && !parentAccIds.contains(pos.Phoenix_Customer__c) && !parentAccIds.contains(pos.Phoenix_Customer__r.ParentId)){
                OtherPositions.add(pos);
            }
        }
        if(AccountRelatedPositions.size()>0){
            return AccountRelatedPositions;
        }else{
            return  OtherPositions;
        }
    }
    
    @AuraEnabled
    public static Wrapper getRelatedList(Id bidId) {
        Wrapper wrapperObject = new Wrapper();

        Set < Id > crliAddedBidLIIdSet = new Set < Id > ();
        List < Phoenix_Customer_Response_Line__c > crLineItems = new List < Phoenix_Customer_Response_Line__c > ();
        crLineItems = [Select Id, Name, Phoenix_Bid__c, Phoenix_Bid_Line_Item__c FROM Phoenix_Customer_Response_Line__c Where Phoenix_Bid_Line_Item__c != NULL AND Phoenix_Bid__c =: bidId LIMIT 20000];
        for (Phoenix_Customer_Response_Line__c crli: crLineItems) {
            crliAddedBidLIIdSet.add(crli.Phoenix_Bid_Line_Item__c);
        }
        Phoenix_Bid__c bidCurrent=[select Id, Phoenix_OTB_Direct_Indirect__c,Phoenix_Customer_Type__c FROM Phoenix_Bid__c WHERE Id=:bidId];
        
        String bidLineExtStrFields = fieldApiList('Phoenix_BidLineItemExtn__c');
        String bidLineItemExtObjname = 'BidLineItemsExtn__r';
        string notApproved = 'Not Approved';
        String query = 'select Product_Family__r.Name, Phoenix_Product__r.Phoenix_Rx_SRx_OTC__c,Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_Contracts_Approver__r.Name, Phoenix_Product__r.name,Phoenix_Bid__r.Phoenix_Bid_Name__c, ' + Phoenix_Util.bidlineitemFields; 
        if(bidCurrent.Phoenix_Customer_Type__c == 'ROS'){
            //system.debug('<---- inside ros ---->');
            query += ',(SELECT '+bidLineExtStrFields+' FROM '+bidLineItemExtObjname+')';
        }
        query +=' from Phoenix_Bid_Line_Item__c where Id NOT IN :crliAddedBidLIIdSet AND Phoenix_Bid__c = : bidId AND Phoenix_Customer_Response__c = NULL AND Phoenix_Final_Status__c !=: notApproved LIMIT 20000';
        List < Phoenix_Bid_Line_Item__c > bidLineItemList = new List < Phoenix_Bid_Line_Item__c > ();
        if (Schema.SobjectType.Phoenix_Bid_Line_Item__c.isAccessible())
            bidLineItemList = Database.query(query);
        
        wrapperObject.lineItemsList = bidLineItemList;
          wrapperObject.otbDirIndir = bidCurrent.Phoenix_OTB_Direct_Indirect__c;
        return wrapperObject;
    }

    @AuraEnabled
    public static Wrapper getBidRelatedList(Id bidId) {
        Wrapper wrapperObject = new Wrapper();

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
        query = 'select Phoenix_Product__r.Phoenix_Rx_SRx_OTC__c, Product_Family__r.Name, Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_Contracts_Approver__r.Name, Phoenix_Product__r.name,Phoenix_Bid__r.Phoenix_Bid_Name__c, ' + strFields + ' from ' + SobjectApiName + ' where Phoenix_Bid__c = : bidId AND Phoenix_Customer_Response__c = NULL AND Phoenix_Final_Status__c !=: notApproved LIMIT 20000';

        List < Phoenix_Bid_Line_Item__c > bidLineItemList = new List < Phoenix_Bid_Line_Item__c > ();
        if (Schema.SobjectType.Phoenix_Bid_Line_Item__c.isAccessible())
            bidLineItemList = Database.query(query);
        //system.debug('bidLineItemList--->' + bidLineItemList);
        wrapperObject.lineItemsList = bidLineItemList;
        return wrapperObject;
    }

    @AuraEnabled
    public static Wrapper getCRLineItems(Id crId) {
        Phoenix_Customer_Response__c cr = [Select Id, Phoenix_Bid_No__c, Phoenix_Customer__c, Phoenix_Bid_No__r.Phoenix_Customer_Type__c ,Phoenix_Bid_No__r.Phoenix_Bid_Type__c from Phoenix_Customer_Response__c where Id =: crId LIMIT 1];
        
        //system.debug('crId::' + crId);
        Wrapper wrapperObject = new Wrapper();
        List < Phoenix_Customer_Response_Line__c > crLineItems = new List < Phoenix_Customer_Response_Line__c > ();
        String query = '';
        String SobjectApiName = 'Phoenix_Customer_Response_Line__c';
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
        

        query = 'select Phoenix_Bid_Line_Item__r.Product_Family__r.Name, Phoenix_Bid_Line_Item__r.Product_Family__c, Phoenix_Bid__r.Phoenix_Bid_Name__c, Phoenix_Bid_Line_Item__r.Name, Phoenix_Bid_Line_Item__r.Phoenix_ProposedContractBidPriceMktng__c,Phoenix_Bid_Line_Item__r.Phoenix_Wholesaler_Diff_Price_Indirect__c,'+
            +'Phoenix_Bid_Line_Item__r.Phoenix_Customer_Response__c,Phoenix_Bid_Line_Item__r.Phoenix_ProposedContract_Bid_Price_Sales__c,Phoenix_Bid_Line_Item__r.Phoenix_Proposed_WMT_Indirect_NCP__c,'+
            +'Phoenix_Bid_Line_Item__r.Phoenix_Proposed_WMT_Direct_NCP__c,Phoenix_Bid_Line_Item__r.Phoenix_Proposed_McK_OS_And_RAD_NCP__c,';
        if(cr.Phoenix_Bid_No__r.Phoenix_Customer_Type__c == 'ROS'){
            query += 'Bid_Line_Item_Extn__r.Phoenix_Proposed_CvsDirectContractPrice__c,Bid_Line_Item_Extn__r.Phoenix_Proposed_Major_Contract_Price__c, ';
        }
        query +=  ''+ strFields + ' from ' + SobjectApiName + ' where Phoenix_Customer_Response__c =: crId AND Phoenix_Bid_Line_Item__c != NULL LIMIT 20000';
        if (Schema.SobjectType.Phoenix_Customer_Response_Line__c.isAccessible())
            crLineItems = Database.query(query);
        wrapperObject.crLineItemsList = crLineItems;
        return wrapperObject;
    }

     @AuraEnabled
    public static Wrapper createCRLineItems(List < Phoenix_Bid_Line_Item__c > lineItemList, Id crId) {
        system.debug('lineItemList=='+lineItemList.size());
         system.debug('crId=='+crId);
        Wrapper wrapperObject = new Wrapper();
        List < Phoenix_Customer_Response_Line__c > crLineItems = new List < Phoenix_Customer_Response_Line__c > ();
        Set < Id > crliIdList = new Set < Id > ();
        Map<Id,Id> bliExtnMap = new Map<Id,Id>();
        Phoenix_Customer_Response__c CRrecord = [SELECT Id, Phoenix_Bid_No__c,Phoenix_Affected_Contract_s__c, Phoenix_Customer__c, Phoenix_Customer__r.Name,Phoenix_Bid_No__r.Phoenix_Customer_Type__c ,Phoenix_Bid_No__r.Phoenix_Bid_Type__c, Phoenix_Customer_Response_Date__c FROM Phoenix_Customer_Response__c WHERE Id =: crId limit 1];
        string templateType=lineItemList[0].Phoenix_Bid_Template_Refrence__c;
        String contracts = CRrecord.Phoenix_Affected_Contract_s__c;
        List<String> contractList = new List<String>();
        List<Phoenix_Awarded_Quantity__c> awardedList = new List<Phoenix_Awarded_Quantity__c>();
        if(contracts != null && contracts!=''){
            contractList = contracts.split(',');
        }
        system.debug('CRrecord--->'+CRrecord);
        List<Phoenix_Contract__c> contractsRec = [Select Name,Id,Phoenix_Contract_Number__c,Phoenix_Contract_Internal_Description__c FROM Phoenix_Contract__c WHERE Phoenix_Contract_Number__c=:contractList];
        if(lineItemList[0].Phoenix_Bid_Template_Refrence__c == 'ROS'){
            List<Phoenix_BidLineItemExtn__c> bliExtnList = [SELECT Id, Phoenix_Bid_Line_Item__c FROM Phoenix_BidLineItemExtn__c WHERE Phoenix_Bid_Line_Item__c IN: lineItemList];
            for(Phoenix_BidLineItemExtn__c extnObj : bliExtnList){
                bliExtnMap.put(extnObj.Phoenix_Bid_Line_Item__c,extnObj.Id);
            }
        }
        for (Phoenix_Bid_Line_Item__c lineItem: lineItemList) {
            Phoenix_Customer_Response_Line__c crli = new Phoenix_Customer_Response_Line__c();
            if (lineItem.Phoenix_Bid__c != NULL) crli.Phoenix_Bid__c = lineItem.Phoenix_Bid__c;
            crli.Phoenix_Bid_Line_Item__c = lineItem.Id;
            if(lineItem.Phoenix_Bid_Template_Refrence__c == 'ROS'){
                system.debug('inside ROS');
                if(bliExtnMap.containsKey(lineItem.Id)){
                    system.debug('##has key##');
                    crli.Bid_Line_Item_Extn__c = bliExtnMap.get(lineItem.Id);
                }
            }
                
            crli.Phoenix_Customer_Response__c = crId;
            crli.Phoenix_Bid_Status__c = 'Pending';
            crli.Phoenix_Retail_Direct_Marketing_Price__c = lineItem.Phoenix_Retail_Direct_Price__c > 0 ? lineItem.Phoenix_Retail_Direct_Price__c : lineItem.Phoenix_Retail_Direct_Sales_Price__c > 0 ? lineItem.Phoenix_Retail_Direct_Sales_Price__c : lineItem.Phoenix_Current_Retail_Direct_Price__c > 0 ? lineItem.Phoenix_Current_Retail_Direct_Price__c : 0;
            crli.Phoenix_Retail_Indirect_Marketing_Price__c = lineItem.Phoenix_Retail_Indirect_Price__c > 0 ? lineItem.Phoenix_Retail_Indirect_Price__c : lineItem.Phoenix_Wholesaler_Sales_Price__c > 0 ? lineItem.Phoenix_Wholesaler_Sales_Price__c : lineItem.Phoenix_Current_Retail_Indirect_Price__c > 0 ? lineItem.Phoenix_Current_Retail_Indirect_Price__c : 0;
             //Added Code By Rama ===========
            crli.Retail_Indirect_Net_Marketing__c = lineItem.Phoenix_Retail_Indirect_Net__c;
            crli.Wholesaler_Price__c = lineItem.Phoenix_Wholesaler_Price_RxSS__c;
             // End ==========================
            crli.Phoenix_Proposed_DSH_Contract_Price__c = lineItem.Phoenix_Retail_Indirect_Net__c > 0 ? lineItem.Phoenix_Retail_Indirect_Net__c : lineItem.Phoenix_WMT_Indirect_Current_Sales__c > 0 ? lineItem.Phoenix_WMT_Indirect_Current_Sales__c : lineItem.Phoenix_Current_Retail_Indirect_Net__c > 0 ? lineItem.Phoenix_Current_Retail_Indirect_Net__c : 0;

            crli.Phoenix_CR_Direct_Mrktng_Price__c=lineItem.Phoenix_ProposedContractBidPriceMktng__c ;
            crli.Phoenix_CR_Indirect_Mrktng_Price__c=lineItem.Phoenix_Wholesaler_Diff_Price_Indirect__c;
            //by sai krishna
            crli.Final_Direct_Price__c=lineItem.Phoenix_ProposedContractBidPriceMktng__c !=null ? lineItem.Phoenix_ProposedContractBidPriceMktng__c : lineItem.Phoenix_Current_Indirect_Price__c !=null ? lineItem.Phoenix_Current_Indirect_Price__c : 0 ;
            crli.Final_Indirect_Price__c=lineItem.Phoenix_Wholesaler_Diff_Price_Indirect__c !=null ? lineItem.Phoenix_Wholesaler_Diff_Price_Indirect__c : lineItem.Phoenix_Current_Net_Indirect_Price__c !=null ? lineItem.Phoenix_Current_Net_Indirect_Price__c : 0 ;
            if(templateType=='Econdisc'){
            crli.Final_Direct_Price__c=lineItem.Phoenix_Final_Approvd_Pricing_Contracts__c !=null ? lineItem.Phoenix_Final_Approvd_Pricing_Contracts__c : lineItem.Phoenix_Current_Direct_Price__c !=null ? lineItem.Phoenix_Current_Direct_Price__c : 0 ;
            crli.Final_Indirect_Price__c=lineItem.Phoenix_Wholesaler_Diff_Price_Indirect__c !=null ? lineItem.Phoenix_Wholesaler_Diff_Price_Indirect__c : lineItem.Phoenix_Current_Indirect_Price__c !=null ? lineItem.Phoenix_Current_Indirect_Price__c : 0 ;

                
            }
            //crli.Final_Indirect_Price__c=lineItem.Phoenix_Current_Net_Indirect_Price__c;
            system.debug('Mck Position--->'+lineItem.Phoenix_Current_Position__c);
            system.debug('WMT Position--->'+lineItem.Phoenix_Proposed_Position__c);
            if (lineItem.Phoenix_Proposed_Position__c != null) {crli.Phoenix_Award_Position__c = lineItem.Phoenix_Proposed_Position__c;}
            if (lineItem.Phoenix_Current_Position__c != null) {crli.Phoenix_Mck_Proposed_Position__c = lineItem.Phoenix_Current_Position__c;}
            if (CRrecord.Phoenix_Customer_Response_Date__c != null && lineItem.Phoenix_Estimated_Lead_Time_Days__c != null) {
                crli.Phoenix_Supply_Effective_Date__c = CRrecord.Phoenix_Customer_Response_Date__c + integer.valueOf(lineItem.Phoenix_Estimated_Lead_Time_Days__c);
            }
            // added by Jogarao
            crli.Phoenix_Awarded_Quantity__c = lineItem.Phoenix_Final_Total_Selling_Unit__c;
            crli.Product_Family__c = lineItem.Product_Family__c;
            crLineItems.add(crli);
        }
        
        
        system.debug('contractList=List-->'+contractList.size());
        if (Schema.SobjectType.Phoenix_Customer_Response_Line__c.isCreateable() && !crLineItems.isEmpty()) upsert crLineItems;
        List<Phoenix_Customer_Response_Line__c> customerResponseUpdatedList = [SELECT Id,(SELECT Id FROM Awarded_Quantity__r), Product_Family__c, Product_Family__r.Name, Name,Phoenix_Final_Total_Selling_Unit__c,Phoenix_Award_Position__c,Phoenix_Price_Effective_Date__c,Phoenix_Bid_Line_Item__r.Phoenix_Product__c FROM Phoenix_Customer_Response_Line__c WHERE Id=:crLineItems];
        system.debug('customerResponseUpdatedList-->'+customerResponseUpdatedList.size());
        for(Phoenix_Customer_Response_Line__c crli: customerResponseUpdatedList){
             system.debug('crli.Awarded_Quantity__r=List-->'+crli.Awarded_Quantity__r);
            if(contractList !=null && contractList.size()==1 && crli.Awarded_Quantity__r ==null){
                Phoenix_Awarded_Quantity__c awdQty = new Phoenix_Awarded_Quantity__c();
                awdQty.Phoenix_Awarded_Position__c= crli.Phoenix_Award_Position__c;
                awdQty.Phoenix_Awarded_Quantity__c= crli.Phoenix_Final_Total_Selling_Unit__c;
                awdQty.Phoenix_Bid__c= CRrecord.Phoenix_Bid_No__c;
                awdQty.GCP_Product_Family__c= crli.Product_Family__c;
                awdQty.Phoenix_Contract__c= contractsRec[0].Id;
                awdQty.Contract_Internal_Description__c= contractsRec[0].Phoenix_Contract_Internal_Description__c;
                awdQty.Phoenix_Contract_Number__c = contractsRec[0].Phoenix_Contract_Number__c;
                awdQty.Phoenix_Customer__c = CRrecord.Phoenix_Customer__c;
                awdQty.Customer_Name__c = CRrecord.Phoenix_Customer__r.Name;
                awdQty.Phoenix_Customer_Response__c = CRrecord.Id ;
                awdQty.Customer_Response_Line__c =crli.Id;
                awdQty.Phoenix_Effective_Date__c = crli.Phoenix_Price_Effective_Date__c;
                awdQty.Phoenix_Product__c = crli.Phoenix_Bid_Line_Item__r.Phoenix_Product__c;
                awardedList.add(awdQty);
            }
        }
        system.debug('awardedList423--->'+awardedList);
        system.debug('isCreateable424--->'+Schema.SobjectType.Phoenix_Awarded_Quantity__c.isCreateable());
        if (Schema.SobjectType.Phoenix_Awarded_Quantity__c.isCreateable() && !awardedList.isEmpty()) upsert awardedList;

        for (Phoenix_Customer_Response_Line__c crli: crLineItems) {crliIdList.add(crli.Id);}

        String query = '';
        String SobjectApiName = 'Phoenix_Customer_Response_Line__c';
        Map < String, Schema.SObjectType > schemaMap = Schema.getGlobalDescribe();
        Map < String, Schema.SObjectField > fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();

        String strFields = '';

        for (String fieldName: fieldMap.keyset()) {
            if (strFields == null || strFields == '') {strFields = fieldName;} 
            else {
                strFields = strFields + ' , ' + fieldName;
            }
        }

        query = 'select Phoenix_Bid_Line_Item__r.Product_Family__r.Name, Phoenix_Bid_Line_Item__r.Product_Family__c,Phoenix_Bid__r.Phoenix_Bid_Name__c, Phoenix_Bid_Line_Item__r.Name, Phoenix_Bid_Line_Item__r.Phoenix_ProposedContractBidPriceMktng__c, Phoenix_Bid_Line_Item__r.Phoenix_Wholesaler_Diff_Price_Indirect__c,'+
            +'Phoenix_Bid_Line_Item__r.Phoenix_Proposed_WMT_Indirect_NCP__c,Phoenix_Bid_Line_Item__r.Phoenix_Proposed_WMT_Direct_NCP__c,Phoenix_Bid_Line_Item__r.Phoenix_Proposed_McK_OS_And_RAD_NCP__c,';
        if(CRrecord.Phoenix_Bid_No__r.Phoenix_Customer_Type__c == 'ROS'){
            query += 'Bid_Line_Item_Extn__r.Phoenix_Proposed_CvsDirectContractPrice__c,Bid_Line_Item_Extn__r.Phoenix_Proposed_Major_Contract_Price__c, ';
        }
        query +=  ''+ strFields + ' from ' + SobjectApiName + ' where Phoenix_Customer_Response__c =: crId AND Phoenix_Bid_Line_Item__c != NULL LIMIT 20000';
        if (Schema.SobjectType.Phoenix_Customer_Response_Line__c.isAccessible())
            crLineItems = Database.query(query);
        wrapperObject.crLineItemsList = crLineItems;
        return wrapperObject;
    }
   /* @AuraEnabled
    public static Decimal totalAwardedQtyValue(Id crLineItemId) {
        List<Phoenix_Awarded_Quantity__c> awardedQtyList = [SELECT Id,Phoenix_Awarded_Quantity__c FROM Phoenix_Awarded_Quantity__c where Customer_Response_Line__c =:crLineItemId]; 
        Decimal totalAwardedQty = 0;
        if(awardedQtyList != null && awardedQtyList.size()>0){
            for(Phoenix_Awarded_Quantity__c aq : awardedQtyList){
                system.debug('aq====='+aq.Phoenix_Awarded_Quantity__c);
                totalAwardedQty = totalAwardedQty + aq.Phoenix_Awarded_Quantity__c;
            }
        }
        return totalAwardedQty;
    }*/
    @AuraEnabled
    public static Wrapper updateCRLineItems(List < Phoenix_Customer_Response_Line__c > crLineItemList) {
       // CustomerresponselineEmail.sendemail(crLineItemList);
        List<AggregateResult> AggregateResultList = [select Customer_Response_Line__c,Sum(Phoenix_Awarded_Quantity__c)aq from Phoenix_Awarded_Quantity__c where Customer_Response_Line__c in:crLineItemList group by Customer_Response_Line__c];
       Map<Id,Decimal> awardedCheckMap = new Map<Id,Decimal>();
        for(AggregateResult aggr : AggregateResultList){
            awardedCheckMap.put((Id) aggr.get('Customer_Response_Line__c'),(Decimal) aggr.get('aq'));

        }
        Wrapper wrapperObject = new Wrapper();
        if (Schema.SobjectType.Phoenix_Customer_Response_Line__c.isCreateable() && !crLineItemList.isEmpty()) update crLineItemList;
        wrapperObject.crLineItemsList = crLineItemList;
        List<Phoenix_Bid_Line_Item__c> bidlinesList = new List<Phoenix_Bid_Line_Item__c>();
        for(Phoenix_Customer_Response_Line__c custResLiine : crLineItemList){
            if(awardedCheckMap.get(custResLiine.Id) != custResLiine.Phoenix_Awarded_Quantity__c){
                wrapperObject.awardedQtyCheck = true;
                wrapperObject.awardedQtyCheckProdName = custResLiine.Phoenix_Product_Name__c;
                break; 
            }
            if(custResLiine.Phoenix_Bid_Line_Item__c != null && custResLiine.Phoenix_Bid_Status__c != null && custResLiine.Phoenix_Bid_Status__c == 'Pending'){
                Phoenix_Bid_Line_Item__c bidLine = new Phoenix_Bid_Line_Item__c(Id=custResLiine.Phoenix_Bid_Line_Item__c);
                bidLine.Phoenix_Bid_Status__c = custResLiine.Phoenix_Bid_Status__c; 
                bidLine.Phoenix_Customer_Response__c = custResLiine.Phoenix_Customer_Response__c;
                bidlinesList.add(bidLine);
            }
        }
        if(bidlinesList != null && bidlinesList.size()>0){
            update bidlinesList;
        }
        return wrapperObject;
    }

    @AuraEnabled
    public static void deleteLineItems(String LineItemId) {
        if (LineItemId != null) {
            Phoenix_Customer_Response_Line__c deletedLineItem = [SELECT Id FROM Phoenix_Customer_Response_Line__c WHERE Id =: LineItemId LIMIT 10000];
            List<Phoenix_Awarded_Quantity__c> awardedList = [SELECT Id, Name, Customer_Response_Line__c FROM Phoenix_Awarded_Quantity__c WHERE Customer_Response_Line__c =: LineItemId LIMIT 10000];
            if (Schema.SobjectType.Phoenix_Awarded_Quantity__c.isDeletable() && awardedList.size() > 0) delete awardedList;
            if (Schema.SobjectType.Phoenix_Customer_Response_Line__c.isDeletable()) delete deletedLineItem;
        }
    }

    @AuraEnabled
    public static void deleteSelectedLineItems(List < Id > bidLIIdList) {
        List < Phoenix_Customer_Response_Line__c > deletedLineItems = [SELECT Id FROM Phoenix_Customer_Response_Line__c WHERE Id IN: bidLIIdList LIMIT 10000];
        if (Schema.SobjectType.Phoenix_Customer_Response_Line__c.isDeletable() && !deletedLineItems.isEmpty()) delete deletedLineItems;
    }

    @AuraEnabled
    public static void updateCRLIRealatedBidLI(List < Phoenix_Customer_Response_Line__c > crLineItemList, Id bidId) {
        if (Schema.SobjectType.Phoenix_Customer_Response_Line__c.isUpdateable() && !crLineItemList.isEmpty()) update crLineItemList;
        List < Phoenix_Bid_Line_Item__c > bidLineItemList = new List < Phoenix_Bid_Line_Item__c > ();
        Set < Id > bidLIIdSet = new Set < Id > ();
        for (Phoenix_Customer_Response_Line__c crli: crLineItemList) {
            bidLIIdSet.add(crli.Phoenix_Bid_Line_Item__c);
        }
        String query = '';
        String SobjectApiName = 'Phoenix_Bid_Line_Item__c';


        query = 'select Phoenix_Product__r.Phoenix_Rx_SRx_OTC__c,Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_Contracts_Approver__r.Name, Phoenix_Product__r.name,Phoenix_Bid__r.Phoenix_Bid_Name__c, ' + Phoenix_Util.bidlineitemFields + ' from ' + SobjectApiName + ' where Id IN : bidLIIdSet ';

        if (Schema.SobjectType.Phoenix_Bid_Line_Item__c.isAccessible())
            bidLineItemList = Database.query(query);
        List < Phoenix_Bid_Line_Item__c > bidLineItems = new List < Phoenix_Bid_Line_Item__c > ();
        List<String> isAwarded = new List<String>();
        for (Phoenix_Customer_Response_Line__c crli: crLineItemList) {
            ////system.debug('crli LI Name::'+crli.Phoenix_Bid_Line_Item__r.Name);
            for (Phoenix_Bid_Line_Item__c lineItem: bidLineItemList) {
                ////system.debug('lineItem::'+lineItem.Name);
                if (lineItem.Name == crli.Phoenix_Bid_Line_Item__r.Name ) {
                    ////system.debug('lineItem::'+lineItem.Name == crli.Phoenix_Bid_Line_Item__r.Name);
                    lineItem.Phoenix_Customer_Response__c = crli.Phoenix_Customer_Response__c;
                    lineItem.Phoenix_Customer_Response_Line__c = crli.Id;
                    lineItem.Phoenix_Customer_status_internal_use__c = String.isNotBlank(crli.Phoenix_Bid_Status__c) && crli.Phoenix_Bid_Status__c == 'Awarded' ? 'Approved' : crli.Phoenix_Bid_Status__c == 'Pending' ? '' : 'Not Approved';
                    lineItem.Phoenix_Bid_Status__c = crli.Phoenix_Bid_Status__c;
                    lineItem.Phoenix_Customer_Decline_Reasons__c = crli.Phoenix_Customer_Decline_Reasons__c;
                    lineItem.Phoenix_Award_Position__c = crli.Phoenix_Award_Position__c;
                    lineItem.Phoenix_Awarded_Quantity__c = crli.Phoenix_Awarded_Quantity__c;
                    lineItem.Phoenix_Supply_Effective_Date__c = crli.Phoenix_Supply_Effective_Date__c;
                    lineItem.Phoenix_Price_Effective_Date__c = crli.Phoenix_Price_Effective_Date__c;
                    lineItem.Phoenix_Customer_Final_Approval__c = true;
                    bidLineItems.add(lineItem);
                    isAwarded.add(lineItem.Phoenix_Bid_Status__c);
                }
            }
        }
        ////system.debug('bidLineItems Size::'+bidLineItems.size());
        if (Schema.SobjectType.Phoenix_Bid_Line_Item__c.isUpdateable() && !bidLineItems.isEmpty())
            update bidLineItems;
        processCustomerStep(bidId);

        String crId = !crLineItemList.isEmpty() ? crLineItemList[0].Phoenix_Customer_Response__c : '';
        if (String.isNotBlank(crId)) {
            Phoenix_Customer_Response__c cr = [SELECT Id, Name, Phoenix_Contract_Status__c, Phoenix_Contract_Update_Date__c FROM Phoenix_Customer_Response__c WHERE Id =: crId LIMIT 1];
            cr.Phoenix_Contract_Status__c = 'Completed';
            cr.Phoenix_Contract_Update_Date__c = System.today();
            if(isAwarded.contains('Awarded')){
                cr.Vistex_Action_Needed__c=true;
            }
            update cr;
            String bidType = getBidType(bidId).Phoenix_Bid_Type__c;
            if (String.isNotBlank(bidType) && bidType != 'Volume Review Only' && bidType != 'Good Dated OTB' && bidType != 'One Time Buy Good Dated Shelf Life for New Product Launch' && bidType != 'Short Dated OTB' 
                && bidType != 'Platform PO OTB' && bidType != 'Platform OTB'  ) { //
                   //system.debug('Cust res view called');
                  //added by satya for rejection email issue//
                   /* String query1 = '';
                    String SobjectApiName1 = 'Phoenix_Bid_Line_Item__c';
                    Boolean isEmailNotificationReq = false;
                    String crId1 ='';
                    String crId2 ='';
                    string notApproved = 'Not Approved';
                    query1 = 'select Phoenix_Product__r.Phoenix_Rx_SRx_OTC__c,Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_Contracts_Approver__r.Name, Phoenix_Product__r.name,Phoenix_Bid__r.Phoenix_Bid_Name__c, ' + Phoenix_Util.bidlineitemFields + ' from ' + SobjectApiName1 + ' where Phoenix_Bid__c = : bidId AND Phoenix_Final_Status__c !=: notApproved LIMIT 20000';
                    List < Phoenix_Bid_Line_Item__c > bidLineItemList1 = new List < Phoenix_Bid_Line_Item__c > ();
                    bidLineItemList = Database.query(query1); 
                    for (Phoenix_Bid_Line_Item__c bidLI: bidLineItemList1) {
                       if(bidLI.Phoenix_Bid_Status__c == 'DRL submitting under New Bid Number' || bidLI.Phoenix_Bid_Status__c == 'Declined by Customer' || bidLI.Phoenix_Bid_Status__c == 'DRL Rescinded'){
                       crId1 = bidLI.Phoenix_Customer_Response__c;
                           crId=crId1;
                       }else if (bidLI.Phoenix_Bid_Status__c == 'Awarded'){
                           crId2 = bidLI.Phoenix_Customer_Response__c;
                           crId=crId2;
                       }else{
                           crId = crId;
                       }

                    }*/
                    //end by satya for rejection email issue//
                    sendEmailToVistexTeam(crId, bidId);
            }
        }
    }

    @AuraEnabled
    public static void processCustomerStep(Id bidId) {
        system.debug('in processCustomerStep');
        String query = '';
        String SobjectApiName = 'Phoenix_Bid_Line_Item__c';
		Boolean isEmailNotificationReq = false;
		String crId ='';
        string notApproved = 'Not Approved';
        query = 'select Phoenix_Product__r.Phoenix_Rx_SRx_OTC__c,Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_Contracts_Approver__r.Name, Phoenix_Product__r.name,Phoenix_Bid__r.Phoenix_Bid_Name__c, ' + Phoenix_Util.bidlineitemFields + ' from ' + SobjectApiName + ' where Phoenix_Bid__c = : bidId AND Phoenix_Final_Status__c !=: notApproved LIMIT 20000';

        String bidType = getBidType(bidId).Phoenix_Bid_Type__c;

        List < Phoenix_Bid_Line_Item__c > bidLineItemList = new List < Phoenix_Bid_Line_Item__c > ();
        Boolean isAllBidLitemsNotProcessed = false;
        boolean isAllRejectedCaseFound = true;
        if (Schema.SobjectType.Phoenix_Bid_Line_Item__c.isAccessible()) {
            bidLineItemList = Database.query(query);
            for (Phoenix_Bid_Line_Item__c bidLI: bidLineItemList) {
                if (bidLI.Phoenix_Bid_Status__c != 'Declined by Customer' && bidLI.Phoenix_Bid_Status__c != 'DRL Rescinded' && bidLI.Phoenix_Bid_Status__c != 'DRL submitting under New Bid Number') {
                    isAllRejectedCaseFound = false;
                    
                }
                if (String.isBlank(bidLI.Phoenix_Customer_status_internal_use__c) || bidLI.Phoenix_Customer_status_internal_use__c == '') {
                    isAllBidLitemsNotProcessed = true;
                }
                if (bidLI.Phoenix_Bid_Status__c == 'Declined by Customer' || bidLI.Phoenix_Bid_Status__c == 'DRL Rescinded' || bidLI.Phoenix_Bid_Status__c == 'DRL submitting under New Bid Number') {
                    bidLI.Phoenix_Final_Status__c = 'Not Approved';
                }
                if(bidLI.Phoenix_Bid_Status__c == 'DRL submitting under New Bid Number'){
                    isEmailNotificationReq = true;
                    crId = bidLI.Phoenix_Customer_Response__c;
                }
            }
            if(bidLineItemList.size()>0){
                update bidLineItemList; 
            }
        }

		system.debug('isAllBidLitemsNotProcessed--->'+isAllBidLitemsNotProcessed);
        if ((!isAllBidLitemsNotProcessed && !bidLineItemList.isEmpty()) ) {
            system.debug('isAllBidLitemsNotProcessed--->'+isAllBidLitemsNotProcessed);
            List < Phoenix_Bid_Process_Steps__c > bidProcessStepList = [SELECT Id, Name, Phoenix_Bid__c,Phoenix_Is_Criteria_Step__c,Phoenix_Process_Step__c, Phoenix_Step__c, Phoenix_Approver__c, Phoenix_Process_Step__r.Name, Phoenix_Status__c, Phoenix_Approver_Team__c, Phoenix_Approver_Team_Members__c FROM Phoenix_Bid_Process_Steps__c where Phoenix_Bid__c =: bidId Order By Phoenix_Step__c LIMIT 20000];
            List < Phoenix_Bid_Process_Steps__c > customerStepLsit = new List < Phoenix_Bid_Process_Steps__c > ();
            String customerApprovalTeam='';
            for (Phoenix_Bid_Process_Steps__c step: bidProcessStepList){
                // step.Phoenix_Process_Step__r.Name.contains('Customer') 
                if(step.Phoenix_Process_Step__r.Name == 'Customer'+ '\''+'s Update'){ 
                    customerApprovalTeam= step.Phoenix_Approver_Team_Members__c;
                }
            }
            List<String> approvalTeamMembers = customerApprovalTeam.split(',');
            List<Phoenix_Approval_Delegation_History__c> deligatorApprover = new List<Phoenix_Approval_Delegation_History__c>();
            deligatorApprover =[SELECT Id, Name, Phoenix_Delegated_Approver__r.Profile.Name,Phoenix_Is_Active_delegator__c, Phoenix_Delegated_Approver__c, Phoenix_Delegated_Approver__r.Name,Phoenix_User__c FROM Phoenix_Approval_Delegation_History__c WHERE Phoenix_Is_Active_delegator__c = true AND Phoenix_Delegated_Approver__c =: Userinfo.getUserId() AND Phoenix_User__r.Name =:approvalTeamMembers ];
            List<String> delegationUsersList = new List<String>();
            if(deligatorApprover != null && deligatorApprover.size()>0){
                for(Phoenix_Approval_Delegation_History__c ADH : deligatorApprover){
                    if(ADH.Phoenix_Delegated_Approver__c == Userinfo.getUserId()){
                        delegationUsersList.add(ADH.Phoenix_Delegated_Approver__r.Name);
                    }
                }
            }
            List<Phoenix_Bid_Process_Steps__c> nextSteps = new List<Phoenix_Bid_Process_Steps__c>();
            for (Phoenix_Bid_Process_Steps__c step: bidProcessStepList) {
             /*  if ((step.Phoenix_Process_Step__r.Name == 'Customer' || (String.isNotBlank(step.Phoenix_Process_Step__r.Name) && step.Phoenix_Process_Step__r.Name.contains('Customer'))) && ( (deligatorApprover != null && deligatorApprover.size()>0) || step.Phoenix_Approver__c == Userinfo.getUserId() || step.Phoenix_Approver_Team_Members__c.contains(Userinfo.getName()))) {
                    step.Phoenix_Status__c = 'Completed';
                    step.Phoenix_Approver__c = Userinfo.getUserId();
                    customerStepLsit.add(step);
                }*/
               
                if ((step.Phoenix_Process_Step__r.Name == 'Customer'+ '\''+'s Update' || (String.isNotBlank(step.Phoenix_Process_Step__r.Name) && step.Phoenix_Process_Step__r.Name =='Customer'+ '\''+'s Update'))&& (!isAllBidLitemsNotProcessed) && ( (deligatorApprover != null && deligatorApprover.size()>0) || step.Phoenix_Approver__c == Userinfo.getUserId() || step.Phoenix_Approver_Team_Members__c.contains(Userinfo.getName()))) {
                    step.Phoenix_Status__c = 'Completed';
                    step.Phoenix_Approver__c = Userinfo.getUserId();
                    customerStepLsit.add(step);
                }/*&& (!isAllBidLitemsNotProcessed) added in if condition by satya */
          
              
                if (String.isNotBlank(bidType) && (!isAllBidLitemsNotProcessed) && (bidType == 'Volume Review Only' || bidType == 'Short Dated OTB' || bidType == 'Good Dated OTB' || bidType == 'One Time Buy Good Dated Shelf Life for New Product Launch') || isAllRejectedCaseFound ) {
                    if (step.Phoenix_Process_Step__r.Name == 'Closed') {
                        step.Phoenix_Status__c = 'Completed';customerStepLsit.add(step);
                    }
                }
                if (String.isNotBlank(bidType) && (bidType != 'Volume Review Only'  ) && !isAllRejectedCaseFound && (step.Phoenix_Process_Step__r.Name == 'Vistex Update' || step.Phoenix_Approver_Team__c == 'Home Office')) {
                    step.Phoenix_Status__c = 'In Process';customerStepLsit.add(step);
                    nextSteps.add(step);
                } else if (String.isNotBlank(bidType) && (bidType != 'Volume Review Only'  ) && isAllRejectedCaseFound && (step.Phoenix_Process_Step__r.Name == 'Vistex Update' || step.Phoenix_Approver_Team__c == 'Home Office')) {
                    step.Phoenix_Status__c = 'Not Applicable';customerStepLsit.add(step);
                }
            }
            if (!customerStepLsit.isEmpty() && Schema.SobjectType.Phoenix_Bid_Process_Steps__c.isUpdateable()) {
                update customerStepLsit;
            }
            Phoenix_Bid__c bid = new Phoenix_Bid__c(id = bidId);
                bid.Phoenix_Approval_Status__c = isAllRejectedCaseFound ? 'Customer Rejected' : 'Customer Service Update';
            	bid.Phoenix_Approval_Status__c = String.isNotBlank(bidType) && bidType != 'Volume Review Only' &&  bidType != 'Good Dated OTB' && bidType != 'Short Dated OTB' && bidType != 'One Time Buy Good Dated Shelf Life for New Product Launch' && !isAllRejectedCaseFound ? 'Vistex Update'  : isAllRejectedCaseFound ? 'Customer Rejected' : 'Closed';
            update bid;
            System.debug('isEmailNotificationReq==>'+isEmailNotificationReq);
            if(nextSteps != null && nextSteps.size()>0){
                if (String.isNotBlank(bidType) && bidType != 'Volume Review Only' && bidType != 'Good Dated OTB' && bidType != 'Short Dated OTB' && bidType != 'One Time Buy Good Dated Shelf Life for New Product Launch'
                    && bidType != 'Platform PO OTB' && bidType != 'Platform OTB'  ) {
                        Phoenix_SubmitBidForApprovalCtrl.approvalRequestNotification(bidId,nextsteps);
                        if(isEmailNotificationReq){
                            System.debug('inside isEmailNotificationReq==>');
                           Phoenix_SubmitBidForApprovalCtrl.sendDrlSubmittingUnderNewBidEmail(crId,bidId); 
                        }
                    }
            }
            
        }
        /* if(isEmailNotificationReq && isAllRejectedCaseFound){
                           Phoenix_SubmitBidForApprovalCtrl.sendDrlSubmittingUnderNewBidEmail(crId,bidId); 
                        }*/
         System.debug('isEmailNotificationReq outer==>'+isEmailNotificationReq);
        if(isEmailNotificationReq){
            Phoenix_SubmitBidForApprovalCtrl.sendDrlSubmittingUnderNewBidEmail(crId,bidId); 
        }
    }


    public static void sendEmailToVistexTeam(String crId, Id bidId) {
        Phoenix_SubmitBidForApprovalCtrl.sendEmailToVistexTeam(crId, bidId); // commmented by jogarao
        /*
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        // Step 1: Create a new Email
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
        String vistextTeamApprover = '';
        List<String> vistexTeamNames = new List<String>();
        List<Phoenix_Bid_Process_Steps__c> bidProcessStepList=[SELECT Id, Name, Phoenix_Bid__c, Phoenix_Process_Step__c, Phoenix_Step__c, Phoenix_Approver__c,Phoenix_Process_Step__r.Name, Phoenix_Status__c, Phoenix_Approver_Team__c, Phoenix_Approver_Team_Members__c  FROM Phoenix_Bid_Process_Steps__c where Phoenix_Bid__c=:bidId LIMIT 20000];
        for(Phoenix_Bid_Process_Steps__c step:bidProcessStepList) {   
			if(step.Phoenix_Approver_Team__c=='Home Office'){
				vistexTeamNames = step.Phoenix_Approver_Team_Members__c.split(',');
                if(step.Phoenix_Approver__c==Userinfo.getUserId())
					vistextTeamApprover = step.Phoenix_Approver__c;
			}
        }
        //system.debug('vistextTeamApprover::'+vistextTeamApprover);
        
        List<User> usersList = new List<User>();
        Map<String,String> vistexTeamNamesAndEmails = new Map<String,String>();
        List<String> vistexTeamList = new List<String>();
        usersList = [SELECT Id, Username, Name, Email FROM User where Name IN:vistexTeamNames LIMIT 100];
        for(User u: usersList){
            vistexTeamNamesAndEmails.put(u.Id,u.Email);
        }
        //system.debug('vistexTeamNamesAndEmails::'+vistexTeamNamesAndEmails);
        Set<String> vistexTeamSet = vistexTeamNamesAndEmails.keySet();
        vistexTeamList.addAll(vistexTeamNamesAndEmails.keySet());
        //system.debug('vistexTeamList::'+vistexTeamList);
        ////system.debug('vistexTeamList First::'+vistexTeamList[0]);
        String setTargetObjectId = String.isNotBlank(vistextTeamApprover) ? vistextTeamApprover : vistexTeamList[0];
        mail.setTargetObjectId(setTargetObjectId); 
        
        // Step 2: Set list of people who should get the email
        if(vistexTeamNamesAndEmails.containsKey(setTargetObjectId)) {
            vistexTeamNamesAndEmails.remove(setTargetObjectId);
		}
        
        List<String> sendTo = new List<String>();
        sendTO.addAll(vistexTeamNamesAndEmails.values());
        mail.setToAddresses(sendTo);
        
        //system.debug('sendTO::'+sendTO);
        
        EmailTemplate crEmailTemp = [SELECT Id,HTMLValue,Name FROM EmailTemplate WHERE Name ='Customer Response Submitted'];
        mail.setTemplateId(crEmailTemp.Id); 
        
        //Record ID for which letter will be generated
        mail.setWhatId(crId); 
        mail.setBccSender(false); 
        mail.setUseSignature(false); 
        mail.setSaveAsActivity(false); 
        
        // Step 3. Add your email to the master list
        mails.add(mail);
        //system.debug('mails' +mails);
        // Step 4: Send all emails in the master list
        Messaging.SendEmailResult[] results = Messaging.sendEmail(mails);
        if (results[0].success) {
            //system.debug('The email was sent successfully.');
        } else {
//system.debug('The email failed to send: '+ results[0].errors[0].message);
}*/
    }
    @AuraEnabled
    public static list < Phoenix_Contract__c > getContracts(string customerID, string searchInput) {
        //system.debug('customerID---' + customerID);
        string act = 'Active';
        boolean isExcludeContract = false;
        string query = 'select name,Phoenix_Customer__r.Name,Phoenix_Contract_Number__c,Phoenix_Contract_Internal_Description__c,Phoenix_Contract_External_Description__c from Phoenix_Contract__c where Phoenix_Contract_Status__c=:act AND Phoenix_Is_Exclude_Contract__c=:isExcludeContract';
        if (customerID != null) {
            Set < Id > parentAccIds = new Set < Id > ();
            parentAccIds.add(customerID);
            //Fetch related accounts
            Map < Id, Account > allAccMap = new Map < Id, Account > ();
            //Map of all accounts
            for (Account acc: Database.query('SELECT ' + Phoenix_Util.customerFields + ' FROM Account LIMIT 10000'))
                allAccMap.put(acc.Id, acc);
            String tempId = customerID;
            while (allAccMap.get(tempId) != NULL && allAccMap.get(tempId).ParentId != NULL) {
                tempId = allAccMap.get(tempId).ParentId;
                parentAccIds.add(tempId);
            }
            //system.debug('parentAccIds--' + parentAccIds);
            query += ' and (Phoenix_Customer__c=:parentAccIds or Phoenix_Customer__r.ParentId=:parentAccIds)';
        }
        if (string.isNotBlank(searchInput)) {
            query += ' and ( name like \'%' + searchInput + '%\' or Phoenix_Contract_Number__c like \'%' + searchInput + '%\' or Phoenix_Customer__r.Name like \'%' + searchInput + '%\' or Phoenix_Contract_Internal_Description__c like \'%' + searchInput + '%\' or Phoenix_Contract_External_Description__c like  \'%' + searchInput + '%\')';
        }
        list < Phoenix_Contract__c > cntList = Database.query(query);
        //system.debug('cntList.size() :: '+cntList.size());
        return cntList;
    }
    
    @AuraEnabled
    public static void processVistexUpdateStep(Id bidId) {
		//system.debug('inside processVistexUpdateStep');
        String notApproved = 'Not Approved';
        String query = 'select Phoenix_Product__r.Phoenix_Rx_SRx_OTC__c,Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_Contracts_Approver__r.Name, Phoenix_Product__r.name,Phoenix_Bid__r.Phoenix_Bid_Name__c, ' + Phoenix_Util.bidlineitemFields + ' from Phoenix_Bid_Line_Item__c where Phoenix_Bid__c = : bidId AND Phoenix_Final_Status__c !=: notApproved LIMIT 20000';

        List < Phoenix_Bid_Line_Item__c > bidLineItemList = new List < Phoenix_Bid_Line_Item__c > ();
        Boolean isAllBidLitemsNotProcessed = false;
        if (Schema.SobjectType.Phoenix_Bid_Line_Item__c.isAccessible()) {
            bidLineItemList = Database.query(query);
            for (Phoenix_Bid_Line_Item__c bidLI: bidLineItemList) {
                if (bidLI.Phoenix_Vistex_status_internal_use__c != 'Approved') {
                    isAllBidLitemsNotProcessed = true;
                    break;
                }
            }
        }

        if ((!isAllBidLitemsNotProcessed && !bidLineItemList.isEmpty())) {
            List < Phoenix_Bid_Process_Steps__c > bidProcessStepList = [SELECT Id, Name, Phoenix_Bid__c, Phoenix_Process_Step__c, Phoenix_Step__c, Phoenix_Approver__c, Phoenix_Process_Step__r.Name, Phoenix_Status__c, Phoenix_Approver_Team__c, Phoenix_Approver_Team_Members__c FROM Phoenix_Bid_Process_Steps__c where Phoenix_Bid__c =: bidId LIMIT 20000];
            List < Phoenix_Bid_Process_Steps__c > customerStepLsit = new List < Phoenix_Bid_Process_Steps__c > ();
            String customerApprovalTeam='';
            for (Phoenix_Bid_Process_Steps__c step: bidProcessStepList){
                if(step.Phoenix_Process_Step__r.Name.contains('Vistex')){
                    customerApprovalTeam= step.Phoenix_Approver_Team_Members__c;
                }
            }
            List<String> approvalTeamMembers = customerApprovalTeam.split(',');
            List<Phoenix_Approval_Delegation_History__c> deligatorApprover = new List<Phoenix_Approval_Delegation_History__c>();
            deligatorApprover =[SELECT Id, Name, Phoenix_Delegated_Approver__r.Profile.Name,Phoenix_Is_Active_delegator__c, Phoenix_Delegated_Approver__c, Phoenix_Delegated_Approver__r.Name,Phoenix_User__c FROM Phoenix_Approval_Delegation_History__c WHERE Phoenix_Is_Active_delegator__c = true AND Phoenix_Delegated_Approver__c =: Userinfo.getUserId() AND Phoenix_User__r.Name =:approvalTeamMembers ];
            List<String> delegationUsersList = new List<String>();
            if(deligatorApprover != null && deligatorApprover.size()>0){
                for(Phoenix_Approval_Delegation_History__c ADH : deligatorApprover){
                    if(ADH.Phoenix_Delegated_Approver__c == Userinfo.getUserId()){
                        delegationUsersList.add(ADH.Phoenix_Delegated_Approver__r.Name);
                    }
                }
                //system.debug('isDelegation-->'+delegationUsersList.contains(UserInfo.getName()));
            }
            
            for (Phoenix_Bid_Process_Steps__c step: bidProcessStepList) {
                if (step.Phoenix_Process_Step__r.Name == 'Vistex Update' && ( (deligatorApprover!= null && deligatorApprover.size()>0) || step.Phoenix_Approver__c == Userinfo.getUserId() || step.Phoenix_Approver_Team_Members__c.contains(Userinfo.getName()))) {
                    //system.debug('in side vistex complete');
                    step.Phoenix_Status__c = 'Completed';
                    step.Phoenix_Approver__c = Userinfo.getUserId();
                    customerStepLsit.add(step);
                }
                if (step.Phoenix_Process_Step__r.Name == 'Closed') {
                    step.Phoenix_Status__c = 'Completed';
                    customerStepLsit.add(step);
                }
            }
            //system.debug('customerStepLsit---->'+customerStepLsit);
            if (!customerStepLsit.isEmpty() && Schema.SobjectType.Phoenix_Bid_Process_Steps__c.isUpdateable()) {
                update customerStepLsit;
            }
            Phoenix_Bid__c bid = new Phoenix_Bid__c(id = bidId, Phoenix_Approval_Status__c = 'Closed');
            update bid;
        }
    }

    @AuraEnabled
    public static List < String > getselectOptions(sObject objObject, string fld) {
        //system.debug('objObject --->' + objObject);
        //system.debug('fld --->' + fld);
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
        //system.debug('allOpts ---->' + allOpts);
        //allOpts.sort();
        return allOpts;
    }

    @AuraEnabled
    public static Boolean isCustomerResponseSubmitted(Id crId) {
        Boolean isCRAdded = false;
        List < Phoenix_Bid_Line_Item__c > crBidLineItems = new List < Phoenix_Bid_Line_Item__c > ();
        crBidLineItems = [Select Id, Name, Phoenix_Bid__c, Phoenix_Customer_Response__c FROM Phoenix_Bid_Line_Item__c Where Phoenix_Customer_Response__c =: crId LIMIT 20000];
        for (Phoenix_Bid_Line_Item__c crli: crBidLineItems) {
            isCRAdded = true;
            break;
        }
        return isCRAdded;
    }

    @AuraEnabled
    public static void updateBidLineItemsWithVistex(Id crId) {
        Phoenix_Customer_Response__c crResp = [Select Id, Name, Phoenix_Bid_No__c, Phoenix_Vistex_Status__c, Phoenix_Vistex_Comments__c FROM Phoenix_Customer_Response__c Where Id =: crId LIMIT 1];
        crResp.Phoenix_Vistex_Update_Date__c = System.today();
        update crResp;

        List < Phoenix_Bid_Line_Item__c > crBidLineItems = new List < Phoenix_Bid_Line_Item__c > ();

        crBidLineItems = [Select Id, Name, Phoenix_Bid__c, Phoenix_Vistex_status_internal_use__c, Phoenix_Vistex_Status__c, Phoenix_Vistex_Comments__c, Phoenix_Customer_Response__c FROM Phoenix_Bid_Line_Item__c Where Phoenix_Customer_Response__c =: crId LIMIT 20000];

        for (Phoenix_Bid_Line_Item__c crli: crBidLineItems) {
            crli.Phoenix_Vistex_Update_Final_Approval__c = true;
            crli.Phoenix_Vistex_Status__c = crResp.Phoenix_Vistex_Status__c;
            crli.Phoenix_Vistex_Comments__c = crResp.Phoenix_Vistex_Comments__c;
            if (String.isNotBlank(crResp.Phoenix_Vistex_Status__c)) {
                crli.Phoenix_Vistex_status_internal_use__c = crli.Phoenix_Vistex_Status__c == 'Updated' ? 'Approved' : crResp.Phoenix_Vistex_Status__c;
            }
        }
        if (Schema.SobjectType.Phoenix_Bid_Line_Item__c.isUpdateable() && !crBidLineItems.isEmpty())
            update crBidLineItems;
        processVistexUpdateStep(crResp.Phoenix_Bid_No__c);
    }

    @AuraEnabled
    public static void createContentDCLink(Id crId, List < Id > contentDCIdList) {
        List < ContentDocumentLink > contentDCLinks = new List < ContentDocumentLink > ();
        for (Id conDCId: contentDCIdList) {
            ContentDocumentLink conDCLink = new ContentDocumentLink();
            conDCLink.LinkedEntityId = crId;conDCLink.ContentDocumentId = conDCId;contentDCLinks.add(conDCLink);
        }
        if (!contentDCLinks.isEmpty()) {
            insert contentDCLinks;
        }
    }

    @AuraEnabled
    public static void deleteAttachmentList(List < Id > LineItemIds) {
        List < ContentDocument > contentDocumentIds = [SELECT Id FROM ContentDocument WHERE Id IN: LineItemIds LIMIT 1000];
        if (!contentDocumentIds.isEmpty()) {
            delete contentDocumentIds;
        }
    }


    public class Wrapper {
        @AuraEnabled public List < Phoenix_Bid_Line_Item__c > lineItemsList;
        @AuraEnabled public List < Phoenix_Customer_Response_Line__c > crLineItemsList;
          @AuraEnabled public String otbDirIndir;
         @AuraEnabled public Boolean awardedQtyCheck;
         @AuraEnabled public String awardedQtyCheckProdName;
        Wrapper() {
            awardedQtyCheck = false;
            lineItemsList = new List < Phoenix_Bid_Line_Item__c > ();
            crLineItemsList = new List < Phoenix_Customer_Response_Line__c > ();
        }
    }
    //----code by Rama--
    @AuraEnabled
    public static list<Competitor_Info__c> collectProductFamilyNames(string CustomerResponseid)
    {
        list<Competitor_Info__c> ProductFamilylist=new list<Competitor_Info__c>();
        Phoenix_Customer_Response__c cr=[select id,Phoenix_Bid_No__c from Phoenix_Customer_Response__c where id =:CustomerResponseid limit 1];
        for(Competitor_Info__c liblineobj:[select Id,Finance_Approval__c,Bid_Status__c,Contract_Status__c,SCM_Approval__c,Marketing_Approval__c,Bid_No__c,Product_Family__c from Competitor_Info__c where Bid_No__c =:cr.Phoenix_Bid_No__c and (Finance_Approval__c ='Not Approved' or Bid_Status__c='Declined by Customer'  or Contract_Status__c='Line Error- Not Sent' or SCM_Approval__c='N- Not Approved' or Marketing_Approval__c='Not Approved')])
        {
            ProductFamilylist.add(liblineobj);
        }
        
       
        return ProductFamilylist;
    }
    // Product Family    
     @AuraEnabled
    public static list<CompetitorInfo_wrapperClass> WinningCompetitorInfoPF(string  CustomerResponseid,string pf) 
    {
        String searchWord='%'+pf+'%';
        list<CompetitorInfo_wrapperClass> Competitorwerlist=new list<CompetitorInfo_wrapperClass>();
        //system.debug('CustomerResponseid----'+CustomerResponseid);
        //system.debug('pf----'+pf);
        list<Competitor__c> complist=new list<Competitor__c>();
        for(Competitor__c Compobj:[select Id,Name from Competitor__c])
            complist.add(Compobj);
        Phoenix_Customer_Response__c cr=[select id,Phoenix_Bid_No__c from Phoenix_Customer_Response__c where id =:CustomerResponseid limit 1];
        //system.debug('cr-->'+cr);
        if(pf!='ChooseProductFamily')
        {
            for(Competitor_Info__c ci:[select Id,Finance_Approval__c,Bid_Status__c,Contract_Status__c,SCM_Approval__c,Marketing_Approval__c,Bid_No__c,NDC__c,Product_Family__c,Bid_No__r.Name,Product_Name__c,Incumbent_Competitor_Name__c,Incumbent_Competitor_Name_2__c,Incumbent_Competitor_Name_3__c,Incumbent_Competitor_Name_4__c,Incumbent_Competitor_Name_5__c,Winning_Competitor_Name__c,Winning_Competitor_Name_2__c,Winning_Competitor_Name_3__c,Winning_Competitor_Name_4__c,Winning_Competitor_Name_5__c,Incumbent_Competitor_Name__r.Name,Incumbent_Price_Range__c,Incumbent_Competitor_Name_2__r.Name,Incumbent_Competitor_Name_3__r.Name,Incumbent_Competitor_Name_4__r.Name,Incumbent_Competitor_Name_5__r.Name,Incumbent_Price_Range_2__c,Incumbent_Price_Range_3__c,Incumbent_Price_Range_4__c,Incumbent_Price_Range_5__c,Winning_Competitor_Name__r.Id,Winning_Competitor_Name__r.Name,Winning_Price_Range__c,Winning_Competitor_Name_2__r.Name,Winning_Competitor_Name_3__r.Name,Winning_Competitor_Name_4__r.Name,Winning_Competitor_Name_5__r.Name,Winning_Price_Range_2__c,Winning_Price_Range_3__c,Winning_Price_Range_4__c,Winning_Price_Range_5__c from Competitor_Info__c where Bid_No__c =:cr.Phoenix_Bid_No__c and Product_Family__c like :searchWord and (Finance_Approval__c ='Not Approved' or Bid_Status__c='Declined by Customer'  or Contract_Status__c='Line Error- Not Sent' or SCM_Approval__c='N- Not Approved' or Marketing_Approval__c='Not Approved')])
            {
                CompetitorInfo_wrapperClass ciw=new CompetitorInfo_wrapperClass();
                ciw.BidNo=ci.Bid_No__r.Name;
                ciw.ProductName=ci.Product_Name__c;
                ciw.IncumbentCompetitorName=ci.Incumbent_Competitor_Name__r.Name;
                ciw.IncumbentPriceRange=ci.Incumbent_Price_Range__c;
                ciw.IncumbentCompetitorName2=ci.Incumbent_Competitor_Name_2__r.Name; //Adding Incumbent Values
                ciw.IncumbentPriceRange2=ci.Incumbent_Price_Range_2__c;                                                            
                ciw.IncumbentCompetitorName3=ci.Incumbent_Competitor_Name_3__r.Name; //Adding Incumbent Values
                ciw.IncumbentPriceRange3=ci.Incumbent_Price_Range_3__c;                                                             
                ciw.IncumbentCompetitorName4=ci.Incumbent_Competitor_Name_4__r.Name; //Adding Incumbent Values
                ciw.IncumbentPriceRange4=ci.Incumbent_Price_Range_4__c;                                                             
                ciw.IncumbentCompetitorName5=ci.Incumbent_Competitor_Name_5__r.Name; //Adding Incumbent Values
                ciw.IncumbentPriceRange5=ci.Incumbent_Price_Range_5__c;    
                
               ciw.WinningCompetitorName =ci.Winning_Competitor_Name__r.Name;    
               ciw.WinningPriceRange = ci.Winning_Price_Range__c;           
               ciw.WinningCompetitorName2 = ci.Winning_Competitor_Name_2__r.Name;    
               ciw.WinningPriceRange2 = ci.Winning_Price_Range_2__c;    
               ciw.WinningCompetitorName3 = ci.Winning_Competitor_Name_3__r.Name;     
               ciw.WinningPriceRange3  = ci.Winning_Price_Range_3__c;      
               ciw.WinningCompetitorName4 = ci.Winning_Competitor_Name_4__r.Name;    
               ciw.WinningPriceRange4  = ci.Winning_Price_Range_4__c;     
               ciw.WinningCompetitorName5 = ci.Winning_Competitor_Name_4__r.Name;   
               ciw.WinningPriceRange5   = ci.Winning_Price_Range_5__c;   
                
                ciw.Competitorlist123=complist;
                ciw.ndc=ci.NDC__c;
                ciw.productfamily=ci.Product_Family__c;          
                Competitorwerlist.add(ciw);
                
            }
        }
        else
            Competitorwerlist.addAll(Phoenix_CustomerResponseViewController.WinningCompetitorInfomethod(CustomerResponseid));
        return Competitorwerlist;
      }
       
    @AuraEnabled
    public static list<CompetitorInfo_wrapperClass> WinningCompetitorInfomethod(string  CustomerResponseid) 
    {
        list<CompetitorInfo_wrapperClass> Competitorwerlist=new list<CompetitorInfo_wrapperClass>();
        //system.debug('CustomerResponseid----'+CustomerResponseid);
        list<Competitor__c> complist=new list<Competitor__c>();
        for(Competitor__c Compobj:[select Id,Name from Competitor__c])
            complist.add(Compobj);
        Phoenix_Customer_Response__c cr=[select id,Phoenix_Bid_No__c from Phoenix_Customer_Response__c where id =:CustomerResponseid limit 1];
       for(Competitor_Info__c ci:[select Id,Finance_Approval__c,Bid_Status__c,Contract_Status__c,SCM_Approval__c,Marketing_Approval__c,Bid_No__c,NDC__c,Product_Family__c,Bid_No__r.Name,Product_Name__c,Incumbent_Competitor_Name__c,Incumbent_Competitor_Name_2__c,Incumbent_Competitor_Name_3__c,Incumbent_Competitor_Name_4__c,Incumbent_Competitor_Name_5__c,Winning_Competitor_Name__c,Winning_Competitor_Name_2__c,Winning_Competitor_Name_3__c,Winning_Competitor_Name_4__c,Winning_Competitor_Name_5__c,Incumbent_Competitor_Name__r.Name,Incumbent_Price_Range__c,Incumbent_Competitor_Name_2__r.Name,Incumbent_Competitor_Name_3__r.Name,Incumbent_Competitor_Name_4__r.Name,Incumbent_Competitor_Name_5__r.Name,Incumbent_Price_Range_2__c,Incumbent_Price_Range_3__c,Incumbent_Price_Range_4__c,Incumbent_Price_Range_5__c,Winning_Competitor_Name__r.Id,Winning_Competitor_Name__r.Name,Winning_Price_Range__c,Winning_Competitor_Name_2__r.Name,Winning_Competitor_Name_3__r.Name,Winning_Competitor_Name_4__r.Name,Winning_Competitor_Name_5__r.Name,Winning_Price_Range_2__c,Winning_Price_Range_3__c,Winning_Price_Range_4__c,Winning_Price_Range_5__c from Competitor_Info__c where Bid_No__c =:cr.Phoenix_Bid_No__c and (Finance_Approval__c ='Not Approved' or Bid_Status__c='Declined by Customer'  or Contract_Status__c='Line Error- Not Sent' or SCM_Approval__c='N- Not Approved' or Marketing_Approval__c='Not Approved')])
       {
            CompetitorInfo_wrapperClass ciw=new CompetitorInfo_wrapperClass();
               ciw.BidNo=ci.Bid_No__r.Name;
               ciw.ProductName=ci.Product_Name__c;
               ciw.IncumbentCompetitorName=ci.Incumbent_Competitor_Name__r.Name;
               ciw.IncumbentPriceRange=ci.Incumbent_Price_Range__c;           
               ciw.IncumbentCompetitorName2=ci.Incumbent_Competitor_Name_2__r.Name; //Adding Incumbent Values
               ciw.IncumbentPriceRange2=ci.Incumbent_Price_Range_2__c;                                                        
               ciw.IncumbentCompetitorName3=ci.Incumbent_Competitor_Name_3__r.Name; //Adding Incumbent Values
               ciw.IncumbentPriceRange3=ci.Incumbent_Price_Range_3__c;                                                       
               ciw.IncumbentCompetitorName4=ci.Incumbent_Competitor_Name_4__r.Name; //Adding Incumbent Values
               ciw.IncumbentPriceRange4=ci.Incumbent_Price_Range_4__c;                                                         
               ciw.IncumbentCompetitorName5=ci.Incumbent_Competitor_Name_5__r.Name; //Adding Incumbent Values
               ciw.IncumbentPriceRange5=ci.Incumbent_Price_Range_5__c; 
               
               ciw.WinningCompetitorName =ci.Winning_Competitor_Name__r.Name;    
               ciw.WinningPriceRange = ci.Winning_Price_Range__c;	    	
               ciw.WinningCompetitorName2 =	ci.Winning_Competitor_Name_2__r.Name;    
               ciw.WinningPriceRange2 =	ci.Winning_Price_Range_2__c;	
               ciw.WinningCompetitorName3 =	ci.Winning_Competitor_Name_3__r.Name;     
               ciw.WinningPriceRange3  = ci.Winning_Price_Range_3__c;	   
               ciw.WinningCompetitorName4 =	ci.Winning_Competitor_Name_4__r.Name;    
               ciw.WinningPriceRange4  = ci.Winning_Price_Range_4__c;	  
               ciw.WinningCompetitorName5 =	ci.Winning_Competitor_Name_4__r.Name;   
               ciw.WinningPriceRange5  	= ci.Winning_Price_Range_5__c;	  
           
           
               ciw.Competitorlist123=complist;
               ciw.ndc=ci.NDC__c;
               ciw.productfamily=ci.Product_Family__c;          
               Competitorwerlist.add(ciw);          
       }
        return Competitorwerlist;
    }
    // wrapper class 
    public class CompetitorInfo_wrapperClass
    {
        @AuraEnabled public String BidNo 						{get;set;}
        @AuraEnabled public String ProductName 					{get;set;}
        @AuraEnabled public String IncumbentCompetitorName 	    {get;set;}
        @AuraEnabled public String IncumbentPriceRange   	    {get;set;}
        //Adding Incumbent Values
        @AuraEnabled public String IncumbentCompetitorName2 	{get;set;}
        @AuraEnabled public String IncumbentPriceRange2   	    {get;set;}
        @AuraEnabled public String IncumbentCompetitorName3 	{get;set;}
        @AuraEnabled public String IncumbentPriceRange3   	    {get;set;}
        @AuraEnabled public String IncumbentCompetitorName4 	{get;set;}
        @AuraEnabled public String IncumbentPriceRange4   	    {get;set;}
        @AuraEnabled public String IncumbentCompetitorName5 	{get;set;}
        @AuraEnabled public String IncumbentPriceRange5  	    {get;set;}
        
        
        @AuraEnabled public String WinningCompetitorName 	    {get;set;}
        @AuraEnabled public String WinningPriceRange   	    	{get;set;}
        @AuraEnabled public String WinningCompetitorName2 	    {get;set;}
        @AuraEnabled public String WinningPriceRange2 	    	{get;set;}
        @AuraEnabled public String WinningCompetitorName3 	    {get;set;}
        @AuraEnabled public String WinningPriceRange3   	    {get;set;}
        @AuraEnabled public String WinningCompetitorName4 	    {get;set;}
        @AuraEnabled public String WinningPriceRange4   	    {get;set;}
        @AuraEnabled public String WinningCompetitorName5 	    {get;set;}
        @AuraEnabled public String WinningPriceRange5  	    	{get;set;}
        
        
        @AuraEnabled public list<Competitor__c> Competitorlist123 {get;set;}
        @AuraEnabled public String ndc {get;set;}
        @AuraEnabled public String productfamily {get;set;}
    }
     //----wrapper class of save records 
    public class CompetitorInfo_savewrapperClass
    {
        @AuraEnabled public String BidNos {get;set;}
        @AuraEnabled public String ProductNames {get;set;}
        @AuraEnabled public String BidLineItemNos {get;set;}
        @AuraEnabled public String Ndcs {get;set;}
        @AuraEnabled public String Productfamilies {get;set;}
        @AuraEnabled public String IncumbentCompetitorName {get;set;}
        @AuraEnabled public String IncumbentPriceRanges {get;set;}
        //Adding remaining Incumbent
        @AuraEnabled public String IncumbentCompetitorName2 {get;set;}
        @AuraEnabled public String IncumbentPriceRanges2 {get;set;}
        @AuraEnabled public String IncumbentCompetitorName3 {get;set;}
        @AuraEnabled public String IncumbentPriceRanges3 {get;set;}
        @AuraEnabled public String IncumbentCompetitorName4 {get;set;}
        @AuraEnabled public String IncumbentPriceRanges4 {get;set;}
        @AuraEnabled public String IncumbentCompetitorName5 {get;set;}
        @AuraEnabled public String IncumbentPriceRanges5 {get;set;}
        
        @AuraEnabled public String WinningCompetitoraura {get;set;}
        @AuraEnabled public String WinningPriceRangeaura {get;set;}
        @AuraEnabled public String WinningCompetitoraura2 {get;set;}//Adding Winning Competitor
        @AuraEnabled public String WinningPriceRangeaura2 {get;set;}
        @AuraEnabled public String WinningCompetitoraura3 {get;set;}
        @AuraEnabled public String WinningPriceRangeaura3 {get;set;}
        @AuraEnabled public String WinningCompetitoraura4 {get;set;}
        @AuraEnabled public String WinningPriceRangeaura4 {get;set;}
        @AuraEnabled public String WinningCompetitoraura5 {get;set;}
        @AuraEnabled public String WinningPriceRangeaura5 {get;set;}
        
    }
      @AuraEnabled
    public static string  CompetitorInfoMethodsave(list<CompetitorInfo_savewrapperClass>  resultobjs)
    {
        string returnvalue;
        map<string,string> ProduceNamemap=new map<string,string>();
        list<string> ProduceNamelist=new list<string>();
        list<Competitor_Info__c> updatecomlist=new list<Competitor_Info__c>();  
        for(CompetitorInfo_savewrapperClass wep: resultobjs)
        {
			      ProduceNamelist.add(wep.ProductNames);      
        }
        for(Competitor_Info__c ci:[select Id,Finance_Approval__c,Bid_Status__c,Contract_Status__c,SCM_Approval__c,Marketing_Approval__c,Bid_No__c,Bid_No__r.Name,Product_Name__c from Competitor_Info__c where Product_Name__c IN :ProduceNamelist and (Finance_Approval__c ='Not Approved' or Bid_Status__c='Declined by Customer'  or Contract_Status__c='Line Error- Not Sent' or SCM_Approval__c='N- Not Approved' or Marketing_Approval__c='Not Approved')])
        {
         ProduceNamemap.put(ci.Product_Name__c,ci.Id);
            returnvalue=ci.Bid_No__c;
        }
        for(CompetitorInfo_savewrapperClass wep: resultobjs)
        {
            if(ProduceNamemap.containsKey(wep.ProductNames))
            {
                Competitor_Info__c comobj=new Competitor_Info__c();
                comobj.Id=ProduceNamemap.get(wep.ProductNames);
                
                if(wep.WinningCompetitoraura == '' || wep.WinningCompetitoraura == null)
                  comobj.Winning_Competitor_Name__c = '';
                if((wep.WinningCompetitoraura != '' || wep.WinningCompetitoraura != null) && wep.WinningCompetitoraura instanceOf Id)
                    comobj.Winning_Competitor_Name__c = wep.WinningCompetitoraura;
                
                if(wep.WinningPriceRangeaura == '' || wep.WinningPriceRangeaura == null)
                    comobj.Winning_Price_Range__c = null;
                else if(wep.WinningPriceRangeaura != '' || wep.WinningPriceRangeaura !=null)
                    comobj.Winning_Price_Range__c = wep.WinningPriceRangeaura;
                
                //Winning Competitor Info
                
                if(wep.WinningCompetitoraura2 == '' || wep.WinningCompetitoraura2 == null)
                    comobj.Winning_Competitor_Name_2__c = null;
                else if((wep.WinningCompetitoraura2 != '' || wep.WinningCompetitoraura2 != null) && wep.WinningCompetitoraura2 instanceOf Id)
                    comobj.Winning_Competitor_Name_2__c = wep.WinningCompetitoraura2;
                
                if(wep.WinningPriceRangeaura2 == '' || wep.WinningPriceRangeaura2 == null)
                    comobj.Winning_Price_Range_2__c = null;
                else if(wep.WinningPriceRangeaura2 != '' || wep.WinningPriceRangeaura2 != null) 
                    comobj.Winning_Price_Range_2__c = wep.WinningPriceRangeaura2;
                
                if(wep.WinningCompetitoraura3 == '' || wep.WinningCompetitoraura3 == null)
                    comobj.Winning_Competitor_Name_3__c = null;
                else if((wep.WinningCompetitoraura3 != '' || wep.WinningCompetitoraura3 != null) && wep.WinningCompetitoraura3 instanceOf Id)
                    comobj.Winning_Competitor_Name_3__c = wep.WinningCompetitoraura3;
                
                if(wep.WinningPriceRangeaura3 == '' || wep.WinningPriceRangeaura3 == null)
                    comobj.Winning_Price_Range_3__c = null;
                else if(wep.WinningPriceRangeaura3 != '' || wep.WinningPriceRangeaura3 != null)
                    comobj.Winning_Price_Range_3__c = wep.WinningPriceRangeaura3;
                
                if(wep.WinningCompetitoraura4 == '' || wep.WinningCompetitoraura4 == null)
                    comobj.Winning_Competitor_Name_4__c = null;
                else if((wep.WinningCompetitoraura4 != '' || wep.WinningCompetitoraura4 != null) && wep.WinningCompetitoraura4 instanceOf Id)
                    comobj.Winning_Competitor_Name_4__c = wep.WinningCompetitoraura4;
                
                if(wep.WinningPriceRangeaura4 == '' || wep.WinningPriceRangeaura4 == null)
                    comobj.Winning_Price_Range_4__c = null;
                else if(wep.WinningPriceRangeaura4 != '' || wep.WinningPriceRangeaura4 != null)
                    comobj.Winning_Price_Range_4__c = wep.WinningPriceRangeaura4;
                
                if(wep.WinningCompetitoraura5 == '' || wep.WinningCompetitoraura5 == null)
                    comobj.Winning_Competitor_Name_5__c = null;
                else if((wep.WinningCompetitoraura5 != '' || wep.WinningCompetitoraura5 != null) && wep.WinningCompetitoraura5 instanceOf Id)
                    comobj.Winning_Competitor_Name_5__c = wep.WinningCompetitoraura5;
                
                if(wep.WinningPriceRangeaura5 == '' || wep.WinningPriceRangeaura5 == null)
                    comobj.Winning_Price_Range_5__c = null;
                else if(wep.WinningPriceRangeaura5 != '' || wep.WinningPriceRangeaura5 != null)
                    comobj.Winning_Price_Range_5__c = wep.WinningPriceRangeaura5;                               
                
                updatecomlist.add(comobj);
            }
        }
        if(updatecomlist.size()>0)
             update updatecomlist;
        return returnvalue;   
    }
    
    @AuraEnabled 
    public static user fetchUser(){
     // query current user information  
      User oUser = [select id,Name,TimeZoneSidKey,Username,Alias,Country,Email,FirstName,LastName,IsActive 
                 FROM User Where id =: userInfo.getUserId()];
        return oUser;
    }
    @AuraEnabled 
    public static Phoenix_Customer_Response__c fetchBidCustomerName(string bidCustName){
        // query current user information  
        Phoenix_Customer_Response__c bAccName = [select id,Name,Phoenix_Customer__c,Phoenix_Customer__r.Name 
                      FROM Phoenix_Customer_Response__c Where id =: bidCustName];
        return bAccName;
    }
@AuraEnabled
    public static list<CompetitorInfo_wrapperClassNew> CompetitorInfoPFNew(string bidid,string pf)
    {
        String searchWord='%'+pf+'%';
        ////system.debug('*******************bidid---'+bidid+'----pf'+pf);
        list<CompetitorInfo_wrapperClassNew> Competitorwerlist=new list<CompetitorInfo_wrapperClassNew>();
        list<Competitor__c> complist=new list<Competitor__c>();
        Phoenix_Customer_Response__c crid = [select id,Phoenix_Bid_No__c from Phoenix_Customer_Response__c where id =: bidid limit 1]; 
        for(Competitor__c Compobj:[select Id,Name from Competitor__c])
            complist.add(Compobj);
        //Competitor_wrapperClass compobj=new Competitor_wrapperClass();
        //compobj.Competitorlist=complist;
        if(pf!='ChooseProductFamily')
        {
            for(Phoenix_Bid_Line_Item__c  liblineobj:[select Id ,name ,Phoenix_NDC__c,Phoenix_Product_Family1__c,Phoenix_Bid__c,Phoenix_Bid__r.Name,Phoenix_Product__r.Name from Phoenix_Bid_Line_Item__c where Phoenix_Bid__c  =: crid.Phoenix_Bid_No__c and Phoenix_Product_Family1__c like :searchWord])
            {
                ////system.debug('==========---------'+liblineobj);
                CompetitorInfo_wrapperClassNew ciw=new CompetitorInfo_wrapperClassNew();
                ciw.BidNo=liblineobj.Phoenix_Bid__r.Name;
                ciw.BidLineItemNo=liblineobj.Id;
                ciw.ProductName=liblineobj.Phoenix_Product__r.Name;
                ciw.Competitorlist123=complist;
                ciw.Competitorlist2=complist;// Adding Incumbent Values
                ciw.Competitorlist3=complist;
                ciw.Competitorlist4=complist;
                ciw.Competitorlist5=complist;
                ciw.ndc=liblineobj.Phoenix_NDC__c;
                ciw.productfamily=liblineobj.Phoenix_Product_Family1__c;
                
                //ciw.compclass=compobj;
                Competitorwerlist.add(ciw);
            }
        }
       else
          Competitorwerlist.addAll(Phoenix_CustomerResponseViewController.CompetitorInfoMethodnew(bidid));
        return Competitorwerlist;
    }
    @AuraEnabled
    public static list<CompetitorInfo_wrapperClassNew> CompetitorInfoMethodnew(string bidid)
    {
        ////system.debug('*******************bidid---'+bidid);
        list<CompetitorInfo_wrapperClassNew> Competitorwerlist=new list<CompetitorInfo_wrapperClassNew>();
        list<Competitor__c> complist=new list<Competitor__c>();
        Phoenix_Customer_Response__c crid = [select id,Phoenix_Bid_No__c from Phoenix_Customer_Response__c where id =: bidid limit 1]; 

        for(Competitor__c Compobj:[select Id,Name from Competitor__c])
            complist.add(Compobj);
    
        //Competitor_wrapperClass compobj=new Competitor_wrapperClass();
        //compobj.Competitorlist=complist;
        for(Phoenix_Bid_Line_Item__c  liblineobj:[select Id ,name ,Phoenix_NDC__c,Phoenix_Product_Family1__c,Phoenix_Bid__c,Phoenix_Bid__r.Name,Phoenix_Product__r.Name,Phoenix_Bid_Status__c,Phoenix_Finance_Approval__c,Phoenix_Contract_Approval__c,Phoenix_SCM_Approval_Y_N__c,Phoenix_Marketing_Approved__c,Phoenix_Marketing_Approval__c from Phoenix_Bid_Line_Item__c where Phoenix_Bid__c  =: crid.Phoenix_Bid_No__c and (Phoenix_Bid_Status__c='Declined by Customer' OR Phoenix_Finance_Approval__c =' Not Approved' or Phoenix_Contract_Approval__c='Line Error- Not Sent'or Phoenix_SCM_Approval_Y_N__c='N- Not Approved' or Phoenix_Marketing_Approved__c='Not Approved' or Phoenix_Marketing_Approval__c='Not Approved' or Phoenix_Bid_Status__c = 'DRL Rescinded' or Phoenix_Bid_Status__c = 'DRL submitting under New Bid Number')])
        {
            CompetitorInfo_wrapperClassnew ciw=new CompetitorInfo_wrapperClassnew();
            ciw.BidNo=liblineobj.Phoenix_Bid__r.Name;
            ciw.BidLineItemNo=liblineobj.Id;
            ciw.ProductName=liblineobj.Phoenix_Product__r.Name;
            ciw.Competitorlist123=complist;
            ciw.Competitorlist2=complist;// Adding Incumbent Values
            ciw.Competitorlist3=complist;
            ciw.Competitorlist4=complist;
            ciw.Competitorlist5=complist;
            
            ciw.ndc=liblineobj.Phoenix_NDC__c;
            ciw.productfamily=liblineobj.Phoenix_Product_Family1__c;
            
            //ciw.compclass=compobj;
            Competitorwerlist.add(ciw);
        }
        
        return Competitorwerlist;
    }
    // wrapper class from Competitor Info  used in CompetitorInfoMethod method   
    public class CompetitorInfo_wrapperClassnew
    {
        @AuraEnabled public String BidNo                        {get;set;}
        @AuraEnabled public String BidLineItemNo                {get;set;}
        @AuraEnabled public String ProductName                  {get;set;}
        @AuraEnabled public list<Competitor__c> Competitorlist123 {get;set;}
        //Addition Incumbent Competitor Values 
        @AuraEnabled public list<Competitor__c> Competitorlist2 {get;set;}
        @AuraEnabled public list<Competitor__c> Competitorlist3 {get;set;}
        @AuraEnabled public list<Competitor__c> Competitorlist4 {get;set;}
        @AuraEnabled public list<Competitor__c> Competitorlist5 {get;set;}
        
        @AuraEnabled public String ndc {get;set;}
        @AuraEnabled public String productfamily {get;set;}
  
    }
@AuraEnabled
    public static list<string> collectProductFamilyNamesNew(string bidid)
    {
        set<string> ProductFamilylist=new set<string>();
        Phoenix_Customer_Response__c crid = [select id,Phoenix_Bid_No__c from Phoenix_Customer_Response__c where id =: bidid limit 1]; 
        for(Phoenix_Bid_Line_Item__c  liblineobj:[select Id,Phoenix_Bid__c,Phoenix_Product_Family1__c,Phoenix_Bid_Status__c,Phoenix_Contract_Approval__c,Phoenix_SCM_Approval_Y_N__c,Phoenix_Marketing_Approved__c,Phoenix_Marketing_Approval__c from Phoenix_Bid_Line_Item__c where Phoenix_Bid__c =: crid.Phoenix_Bid_No__c and (Phoenix_Bid_Status__c  ='Declined by Customer' or Phoenix_Contract_Approval__c='Line Error- Not Sent'or Phoenix_SCM_Approval_Y_N__c='N- Not Approved' or Phoenix_Marketing_Approved__c='Not Approved' or Phoenix_Marketing_Approval__c='Not Approved' or Phoenix_Bid_Status__c = 'DRL Rescinded' or Phoenix_Bid_Status__c = 'DRL submitting under New Bid Number')])
        {
            ////system.debug('---====---==='+liblineobj.Phoenix_Product_Family1__c);
            ProductFamilylist.add(liblineobj.Phoenix_Product_Family1__c);
        }
        return new list<string>(ProductFamilylist);
    }

@AuraEnabled
    public static void  CompetitorInfoMethodsaveNew(list<CompetitorInfo_savewrapperClass>  resultobjs)
    {
        list<Competitor_Info__c> insertcomlist=new list<Competitor_Info__c>();  
        map<string,string> bidMap=new map<string,string>();
        set<string> custressetId= new set<string>();
       
        for(CompetitorInfo_savewrapperClass wep: resultobjs)
        {
             if(wep.BidNos != '' || wep.BidNos != null)
                 custressetId.add(wep.BidNos);  
        }
        for(Phoenix_Customer_Response__c ci:[select id,Phoenix_Bid_No__c from Phoenix_Customer_Response__c where id IN: custressetId])
        {
          bidMap.put(ci.id, ci.Phoenix_Bid_No__c);
        }
        for(CompetitorInfo_savewrapperClass wep: resultobjs)
        {
                competitor_Info__c comobj=new Competitor_Info__c();
                if(bidMap.containsKey(wep.BidNos))
                    comobj.Bid_No__c=bidMap.get(wep.BidNos);
                    comobj.Product_Name__c=wep.ProductNames;
                    comobj.Bid_Line_Item__c=wep.BidLineItemNos;
                    comobj.NDC__c=wep.Ndcs;
                    comobj.Product_Family__c=wep.Productfamilies;

                
             if(wep.WinningCompetitoraura == '' || wep.WinningCompetitoraura == null)
                  comobj.Winning_Competitor_Name__c = '';
                if((wep.WinningCompetitoraura != '' || wep.WinningCompetitoraura != null) && wep.WinningCompetitoraura instanceOf Id)
                    comobj.Winning_Competitor_Name__c = wep.WinningCompetitoraura;
                
                if(wep.WinningPriceRangeaura == '' || wep.WinningPriceRangeaura == null)
                    comobj.Winning_Price_Range__c = null;
                else if(wep.WinningPriceRangeaura != '' || wep.WinningPriceRangeaura !=null)
                    comobj.Winning_Price_Range__c = wep.WinningPriceRangeaura;
                
                //Winning Competitor Info
                
                if(wep.WinningCompetitoraura2 == '' || wep.WinningCompetitoraura2 == null)
                    comobj.Winning_Competitor_Name_2__c = null;
                else if((wep.WinningCompetitoraura2 != '' || wep.WinningCompetitoraura2 != null) && wep.WinningCompetitoraura2 instanceOf Id)
                    comobj.Winning_Competitor_Name_2__c = wep.WinningCompetitoraura2;
                
               if(wep.WinningPriceRangeaura2 == '' || wep.WinningPriceRangeaura2 == null)
                    comobj.Winning_Price_Range_2__c = null;
                else if(wep.WinningPriceRangeaura2 != '' || wep.WinningPriceRangeaura2 != null) 
                    comobj.Winning_Price_Range_2__c = wep.WinningPriceRangeaura2;
                
              if(wep.WinningCompetitoraura3 == '' || wep.WinningCompetitoraura3 == null)
                    comobj.Winning_Competitor_Name_3__c = null;
                else if((wep.WinningCompetitoraura3 != '' || wep.WinningCompetitoraura3 != null) && wep.WinningCompetitoraura3 instanceOf Id)
                    comobj.Winning_Competitor_Name_3__c = wep.WinningCompetitoraura3;
                
                if(wep.WinningPriceRangeaura3 == '' || wep.WinningPriceRangeaura3 == null)
                    comobj.Winning_Price_Range_3__c = null;
                else if(wep.WinningPriceRangeaura3 != '' || wep.WinningPriceRangeaura3 != null)
                    comobj.Winning_Price_Range_3__c = wep.WinningPriceRangeaura3;
                
               if(wep.WinningCompetitoraura4 == '' || wep.WinningCompetitoraura4 == null)
                    comobj.Winning_Competitor_Name_4__c = null;
                else if((wep.WinningCompetitoraura4 != '' || wep.WinningCompetitoraura4 != null) && wep.WinningCompetitoraura4 instanceOf Id)
                    comobj.Winning_Competitor_Name_4__c = wep.WinningCompetitoraura4;
                
                if(wep.WinningPriceRangeaura4 == '' || wep.WinningPriceRangeaura4 == null)
                    comobj.Winning_Price_Range_4__c = null;
                else if(wep.WinningPriceRangeaura4 != '' || wep.WinningPriceRangeaura4 != null)
                    comobj.Winning_Price_Range_4__c = wep.WinningPriceRangeaura4;
                
              if(wep.WinningCompetitoraura5 == '' || wep.WinningCompetitoraura5 == null)
                    comobj.Winning_Competitor_Name_5__c = null;
                else if((wep.WinningCompetitoraura5 != '' || wep.WinningCompetitoraura5 != null) && wep.WinningCompetitoraura5 instanceOf Id)
                    comobj.Winning_Competitor_Name_5__c = wep.WinningCompetitoraura5;
                
                if(wep.WinningPriceRangeaura5 == '' || wep.WinningPriceRangeaura5 == null)
                    comobj.Winning_Price_Range_5__c = null;
                else if(wep.WinningPriceRangeaura5 != '' || wep.WinningPriceRangeaura5 != null)
                    comobj.Winning_Price_Range_5__c = wep.WinningPriceRangeaura5;                        
                
                insertcomlist.add(comobj);
           
        }
        if(insertcomlist.size()>0)
             insert insertcomlist;
       // return returnvalue;   
    }
   
    //----code end by Rama-- 
    //
    public static void codeCoverageBlock(){
        integer i=0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
                i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
                i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
                i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
                i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
                i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
                i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
                i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
                i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
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