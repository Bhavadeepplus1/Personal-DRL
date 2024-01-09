/**
* @description       : 
* @author            : Surender Patel (Dhruvsoft)
* @group             : 
* @last modified on  : 23-07-2021
* @last modified by  : Surender Patel (Dhruvsoft)
* Modifications Log 
* Ver   Date         Author                       Modification
* 1.0   20-07-2021   Surender Patel (Dhruvsoft)   Initial Version
**/
public class Phoenix_BidVIPRebateChangeReqCtrl {
    
    public static List<Phoenix_VIP_Rebate_Line__c> sortLineItems(List<Phoenix_VIP_Rebate_Line__c> quoteList){
        List<Integer> tierNumber = new List<Integer>();
        Map<Integer, Phoenix_VIP_Rebate_Line__c> lineItemMap = new Map<Integer, Phoenix_VIP_Rebate_Line__c>();
        for(Phoenix_VIP_Rebate_Line__c lineObj : quoteList){
            Integer vipTier = 0;
            if(lineObj.Phoenix_Tier__c.contains('Tier')){
                vipTier = Integer.valueOf(lineObj.Phoenix_Tier__c.subStringAfter(' '));
            }
            else
                vipTier = Integer.valueOf(lineObj.Phoenix_Tier__c);
            tierNumber.add(vipTier);
            lineItemMap.put(vipTier,lineObj);
        }
        Integer n = tierNumber.size();
        for(Integer i=0; i<n-1; i++){
            Boolean swapped = false;
            for(Integer j =0; j<n-1-i; j++){
                if(tierNumber[j] > tierNumber[j+1]){
                    Integer temp = tierNumber[j];
                    tierNumber.Set(j,tierNumber[j+1]); 
                    tierNumber.Set(j+1,temp);
                    swapped = true;
                }
            }
            if(!swapped){
                break;
            }
        }
        quoteList = new List<Phoenix_VIP_Rebate_Line__c>();
        for(Integer tierInt : tierNumber){
            quoteList.add(lineItemMap.get(tierInt));
        }
        return quoteList;
    }
    @auraEnabled
    public static Integer checkForProposedRebate(String bidId){
        Integer propCount = [SELECT count() FROM Phoenix_Bid_VIP_Rebate__c 
                             WHERE Phoenix_Bid__c =: bidId
                             AND Phoenix_Status__c = 'Proposed'];
        return propCount;
    }
    @auraEnabled
    public static Wrapper getVipRebateByType(String selectedType, String bidId, String customerId){
        Wrapper wrapperObject = new Wrapper();
        Phoenix_Bid__c bid = [SELECT Id, Name, Phoenix_Bid_Type__c, Phoenix_Current_VIP_Rebate__c, Phoenix_Proposed_VIP_Rebate__c,
                              Phoenix_Customer__r.Name, Phoenix_Customer__c, Phoenix_Bid_Name__c, Phoenix_Approval_Status__c,
                              Phoenix_Business_Approval__c, Phoenix_Business_Approval_Comments__c, Phoenix_Finance_Approval__c,
                              Phoenix_Customer_Approval__c, Phoenix_Customer_Approval_Comments__c, Phoenix_Vistex_Update__c, Phoenix_Vistex_Update_Comments__c,
                              Phoenix_Finance_Approval_Comments__c, Phoenix_Contracts_Approval__c, Phoenix_Contracts_Approval_Comments__c 
                              FROM Phoenix_Bid__c 
                              WHERE Id =: bidId];
        List < ContentDocumentLink > entries = [SELECT Id, LinkedEntityId, ContentDocument.Title, ContentDocument.FileExtension, ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId =: bidId];
        String SobjectApiName = 'Phoenix_VIP_Rebate_Line__c';
        Map < String, Schema.SObjectType > schemaMap = Schema.getGlobalDescribe();
        Map < String, Schema.SObjectField > fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();
        String strFields = '';
        for (String fieldName: fieldMap.keyset()) {
            if (strFields == null || strFields == '') {
                strFields = fieldName;
            } else {
                strFields = strFields + ',' + fieldName;
            }
        }
        List < Phoenix_Bid_VIP_Rebate__c > vipCurrent = [SELECT Id, Name, Phoenix_Start_Date__c, Phoenix_End_Date__c, Phoenix_Type__c, Phoenix_Exclusions__c, createdDate, LastModifiedDate, Phoenix_Exclusion_details__c FROM Phoenix_Bid_VIP_Rebate__c 
                                                         WHERE Phoenix_Status__c = 'Current' //Phoenix_Bid__c =: bidId
                                                         AND Phoenix_Customer__c =: customerId AND Phoenix_Type__c =: selectedType ORDER BY Phoenix_End_Date__c DESC];
        String query = '';
        if (!vipCurrent.isEmpty()) {
            Id vipCurrentId = vipCurrent[0].Id;
            query = 'select '+ strFields + ' from '+ SobjectApiName+' where Phoenix_VIP_Rebate__c =:vipCurrentId  ORDER BY Phoenix_Tier__c';
            list < Phoenix_VIP_Rebate_Line__c > quoteList = Database.query(query);
            if(quoteList.size()>0){
                quoteList = sortLineItems(quoteList);
            }
            wrapperObject.rebatesList = quoteList;
            wrapperObject.currentRebate = vipCurrentId;
            wrapperObject.currentRebateName = vipCurrent[0].Name;
            wrapperObject.strtDate = vipCurrent[0].Phoenix_Start_Date__c;
            wrapperObject.endDate = vipCurrent[0].Phoenix_End_Date__c;
            wrapperObject.type = vipCurrent[0].Phoenix_Type__c;
            wrapperObject.exclusions = vipCurrent[0].Phoenix_Exclusions__c;
            wrapperObject.excDetails = vipCurrent[0].Phoenix_Exclusion_details__c;
        }
        List < Phoenix_Bid_VIP_Rebate__c > vipProposed = [SELECT Id, Name, Phoenix_Start_Date__c, Phoenix_End_Date__c, Phoenix_Type__c, Phoenix_Exclusions__c, Phoenix_Exclusion_details__c FROM Phoenix_Bid_VIP_Rebate__c 
                                                          WHERE Phoenix_Bid__c =: bidId AND Phoenix_Status__c = 'Proposed' AND Phoenix_Customer__c =: customerId];
        
        if (!vipProposed.isEmpty()) {
            Id vipProposedId = vipProposed[0].Id;
            query = 'select' + ' ' + strFields + ' ' + 'from' + ' ' + SobjectApiName + ' ' + 'where Phoenix_VIP_Rebate__c =:vipProposedId ORDER BY Phoenix_Tier__c';
            list < Phoenix_VIP_Rebate_Line__c > quoteListPro = Database.query(query);
            if(quoteListPro.size()>0){
                quoteListPro = sortLineItems(quoteListPro);
            }
            wrapperObject.rebatesListProposed = quoteListPro;
            wrapperObject.proposedRebate = vipProposedId;
            wrapperObject.proposedRebateName = vipProposed[0].Name;
            wrapperObject.strtDatePro = vipProposed[0].Phoenix_Start_Date__c;
            wrapperObject.endDatePro = vipProposed[0].Phoenix_End_Date__c;
            wrapperObject.typePro = vipProposed[0].Phoenix_Type__c;
            wrapperObject.exclusionsPro = vipProposed[0].Phoenix_Exclusions__c;
            wrapperObject.excDetailsPro = vipProposed[0].Phoenix_Exclusion_details__c;
        }
        wrapperObject.bidRecord = bid;
        wrapperObject.bidType = bid.Phoenix_Bid_Type__c;
        wrapperObject.custName = bid.Phoenix_Customer__r.Name;
        wrapperObject.approvalStatus = bid.Phoenix_Approval_Status__c;
        wrapperObject.loggedInUserId = UserInfo.getName();
        if (!entries.isEmpty()) {
            wrapperObject.conDocLink = entries;
        }
        return wrapperObject;
    }
    
    
    @auraEnabled
    public static Wrapper getVipAndRelatedListByType(String selectedType, String bidId, String customerId){
        Wrapper wrapperObject = new Wrapper();
        Phoenix_Bid__c bid = [SELECT Id, Name, Phoenix_Bid_Type__c, Phoenix_Current_VIP_Rebate__c, Phoenix_Proposed_VIP_Rebate__c,
                              Phoenix_Customer__r.Name, Phoenix_Customer__c, Phoenix_Bid_Name__c, Phoenix_Approval_Status__c, Phoenix_Business_Approval__c, Phoenix_Business_Approval_Comments__c, Phoenix_Finance_Approval__c,
                              Phoenix_Customer_Approval__c, Phoenix_Customer_Approval_Comments__c, Phoenix_Vistex_Update__c, Phoenix_Vistex_Update_Comments__c,
                              Phoenix_Finance_Approval_Comments__c, Phoenix_Contracts_Approval__c, Phoenix_Contracts_Approval_Comments__c FROM Phoenix_Bid__c WHERE Id =: bidId];
        List < ContentDocumentLink > entries = [SELECT Id, LinkedEntityId, ContentDocument.Title, ContentDocument.FileExtension, ContentDocumentId
                                                FROM ContentDocumentLink 
                                                WHERE LinkedEntityId =: bidId];
        String SobjectApiName = 'Phoenix_VIP_Rebate_Line__c';
        Map < String, Schema.SObjectType > schemaMap = Schema.getGlobalDescribe();
        Map < String, Schema.SObjectField > fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();
        String strFields = '';
        for (String fieldName: fieldMap.keyset()) {
            if (strFields == null || strFields == '') {
                strFields = fieldName;
            } else {
                strFields = strFields + ',' + fieldName;
            }
        }
        List < Phoenix_Bid_VIP_Rebate__c > vipCurrent = [SELECT Id, Name, Phoenix_Start_Date__c, Phoenix_End_Date__c, 
                                                         Phoenix_Type__c, Phoenix_Exclusions__c, createdDate, LastModifiedDate, Phoenix_Exclusion_details__c 
                                                         FROM Phoenix_Bid_VIP_Rebate__c WHERE Phoenix_Status__c = 'Current' //Phoenix_Bid__c =: bidId
                                                         AND Phoenix_Customer__c =: customerId AND Phoenix_Type__c=: selectedType ORDER BY Phoenix_End_Date__c DESC];
        String query = '';
        if (!vipCurrent.isEmpty()) {
            Id vipCurrentId = vipCurrent[0].Id;
            query = 'select '+ strFields + ' from '+ SobjectApiName+' where Phoenix_VIP_Rebate__c =:vipCurrentId  ORDER BY Phoenix_Tier__c';
            list < Phoenix_VIP_Rebate_Line__c > quoteList = Database.query(query);
            wrapperObject.rebatesList = quoteList;
            wrapperObject.currentRebate = vipCurrentId;
            wrapperObject.currentRebateName = vipCurrent[0].Name;
            wrapperObject.strtDate = vipCurrent[0].Phoenix_Start_Date__c;
            wrapperObject.endDate = vipCurrent[0].Phoenix_End_Date__c;
            wrapperObject.type = vipCurrent[0].Phoenix_Type__c;
            wrapperObject.exclusions = vipCurrent[0].Phoenix_Exclusions__c;
            wrapperObject.excDetails = vipCurrent[0].Phoenix_Exclusion_details__c;
        }
        List < Phoenix_Bid_VIP_Rebate__c > vipProposed = [SELECT Id, Name, Phoenix_Start_Date__c, Phoenix_End_Date__c, 
                                                          Phoenix_Type__c, Phoenix_Exclusions__c, Phoenix_Exclusion_details__c 
                                                          FROM Phoenix_Bid_VIP_Rebate__c WHERE Phoenix_Bid__c =: bidId AND Phoenix_Status__c = 'Proposed' AND Phoenix_Customer__c =: customerId];
        
        if (!vipProposed.isEmpty()) {
            Id vipProposedId = vipProposed[0].Id;
            query = 'select' + ' ' + strFields + ' ' + 'from' + ' ' + SobjectApiName + ' ' + 'where Phoenix_VIP_Rebate__c =:vipProposedId ORDER BY Phoenix_Tier__c';
            list < Phoenix_VIP_Rebate_Line__c > quoteListPro = Database.query(query);
            wrapperObject.rebatesListProposed = quoteListPro;
            wrapperObject.proposedRebate = vipProposedId;
            wrapperObject.proposedRebateName = vipProposed[0].Name;
            wrapperObject.strtDatePro = vipProposed[0].Phoenix_Start_Date__c;
            wrapperObject.endDatePro = vipProposed[0].Phoenix_End_Date__c;
            wrapperObject.typePro = vipProposed[0].Phoenix_Type__c;
            wrapperObject.exclusionsPro = vipProposed[0].Phoenix_Exclusions__c;
            wrapperObject.excDetailsPro = vipProposed[0].Phoenix_Exclusion_details__c;
        }
        wrapperObject.bidRecord = bid;
        wrapperObject.bidType = bid.Phoenix_Bid_Type__c;
        wrapperObject.custName = bid.Phoenix_Customer__r.Name;
        wrapperObject.approvalStatus = bid.Phoenix_Approval_Status__c;
        wrapperObject.loggedInUserId = UserInfo.getName();
        if (!entries.isEmpty()) {
            wrapperObject.conDocLink = entries;
        }
        return wrapperObject;
    }
    
    
    @auraEnabled
    public static List<Wrapper> getBidVipRebateCount(Id bidId){
        List<Wrapper> wrapList = new List<Wrapper>();
        Phoenix_Bid__c bidRec = [select Id, Name, Phoenix_Bid_Type__c, Phoenix_Current_VIP_Rebate__c, Phoenix_Proposed_VIP_Rebate__c,
                                 Phoenix_Customer__r.Name, Phoenix_Customer__c, Phoenix_Bid_Name__c, Phoenix_Approval_Status__c,
                                 Phoenix_Business_Approval__c, Phoenix_Business_Approval_Comments__c, Phoenix_Finance_Approval__c,
                                 Phoenix_Customer_Approval__c, Phoenix_Customer_Approval_Comments__c, 
                                 Phoenix_Vistex_Update__c, Phoenix_Vistex_Update_Comments__c,
                                 Phoenix_Finance_Approval_Comments__c, Phoenix_Contracts_Approval__c, 
                                 Phoenix_Contracts_Approval_Comments__c, Phoenix_Customer__r.Phoenix_Contracts_Approver__c, Phoenix_Customer__r.Phoenix_Customer_Service_Approver__c FROM Phoenix_Bid__c WHERE Id =: bidId LIMIT 1];
        
        List<Phoenix_Bid_VIP_Rebate__c> vipList = [SELECT Id, Phoenix_Bid__c, Phoenix_Customer__c,Rx_SRx_OTC__c,Payment_Frequency__c,Net_Contract__c,Vistex_Agreement__c,
                                                   Phoenix_Customer__r.Name FROM Phoenix_Bid_VIP_Rebate__c WHERE Phoenix_Bid__c =: bidId];//Phoenix_Customer__c =: bidRec.Phoenix_Customer__c];//
        List < ContentDocumentLink > entries = [SELECT Id, LinkedEntityId, ContentDocument.Title, ContentDocument.FileExtension, ContentDocumentId
                                                FROM ContentDocumentLink  WHERE LinkedEntityId =: bidId];
        Map < String, String > userTeamUserIdMap = new Map < String, String > ();
        for (Phoenix_User_Approval_Matrix__c matrix: [Select Id, Name, RecordType.DeveloperName, Phoenix_Approver__r.Name, User_Group__r.Phoenix_Approver_Group_Name__c, Phoenix_Approval_Group_Behavior__c, 
                                                      Phoenix_Approver__c, Phoenix_Approver__r.Email, Phoenix_Approver_Group_Name__c, Phoenix_Is_Active_User__c, Phoenix_Is_Approval_Process_User__c, User_Group__c 
                                                      from Phoenix_User_Approval_Matrix__c limit 1000]) {
            String userTeamUserIdMapKey = matrix.User_Group__r.Phoenix_Approver_Group_Name__c + '-' + matrix.Phoenix_Approver__c;
            userTeamUserIdMap.put(userTeamUserIdMapKey, matrix.Phoenix_Approver__r.Name);
        }
        string isBusinessApprovePerson;
        string isFinanceApprovePerson;
        string isContractsApprovePerson;
        string isCustomerApprovePerson;
        string isVistexApprovePerson;
        if (userTeamUserIdMap.containsKey('Business Head-' + UserInfo.getUserId())) {
            isBusinessApprovePerson = userTeamUserIdMap.get(('Business Head-' + UserInfo.getUserId()));
        }
        if (userTeamUserIdMap.containsKey('Finance-' + UserInfo.getUserId())) {
            isFinanceApprovePerson = userTeamUserIdMap.get(('Finance-' + UserInfo.getUserId()));
        }
        if (bidRec.Phoenix_Customer__r.Phoenix_Contracts_Approver__c == UserInfo.getUserId() || userTeamUserIdMap.containsKey('Contracts-' + UserInfo.getUserId())) {
            isContractsApprovePerson = UserInfo.getName();
        }
        if (bidRec.Phoenix_Customer__r.Phoenix_Contracts_Approver__c == UserInfo.getUserId() || userTeamUserIdMap.containsKey('Contracts-' + UserInfo.getUserId())) {
            isCustomerApprovePerson = UserInfo.getName();
        }
        
        if (userTeamUserIdMap.containsKey('Home Office-' + UserInfo.getUserId())) {
            isVistexApprovePerson = userTeamUserIdMap.get(('Home Office-' + UserInfo.getUserId()));
        }
        
        Wrapper wrapObj = new Wrapper();
        for(Phoenix_Bid_VIP_Rebate__c vipObj : vipList){
            wrapObj = new Wrapper();
            wrapObj.customerName = vipObj.Phoenix_Customer__r.Name;
            wrapObj.customerId = vipObj.Phoenix_Customer__c;
            wrapObj.existingVIPrebate = true;
            wrapObj.vipRebate = vipObj;
            wrapList.add(wrapObj);
        }
        if(wrapList.size() == 0){
            wrapObj = new Wrapper();
            wrapObj.customerName = bidRec.Phoenix_Customer__r.Name;
            wrapObj.customerId = bidRec.Phoenix_Customer__c;
            wrapObj.existingVIPrebate = true;
            wrapList.add(wrapObj);
        }
        wrapList[0].bidRecord = bidRec;
        wrapList[0].bidType = bidRec.Phoenix_Bid_Type__c;
        wrapList[0].custName = bidRec.Phoenix_Customer__r.Name;
        wrapList[0].approvalStatus = bidRec.Phoenix_Approval_Status__c;
        wrapList[0].loggedInUserId = UserInfo.getName();
        wrapList[0].isBusinessApprovePerson = isBusinessApprovePerson;
        wrapList[0].isFinanceApprovePerson = isFinanceApprovePerson;
        wrapList[0].isContractsApprovePerson = isContractsApprovePerson;
        wrapList[0].isCustomerApprovePerson = isCustomerApprovePerson;
        wrapList[0].isVistexApprovePerson = isVistexApprovePerson;
        if (!entries.isEmpty()) {
            wrapList[0].conDocLink = entries;
        }
        return wrapList;
    }
    
    @auraEnabled
    public static Wrapper getVipAndRelatedList(String bidId, String divisionTab, String customerId){
        system.debug('divisionTab: '+divisionTab);
        system.debug('customerId: '+customerId);
        system.debug('bidId: '+bidId);
        Wrapper wrapperObject = new Wrapper();
        Phoenix_Bid__c bid = [SELECT Id, Name, Phoenix_Bid_Type__c, Phoenix_Current_VIP_Rebate__c, Phoenix_Proposed_VIP_Rebate__c,
                              Phoenix_Customer__r.Name, Phoenix_Customer__c, Phoenix_Bid_Name__c, Phoenix_Approval_Status__c,
                              Phoenix_Business_Approval__c, Phoenix_Business_Approval_Comments__c, Phoenix_Finance_Approval__c,
                              Phoenix_Customer_Approval__c, Phoenix_Customer_Approval_Comments__c, Phoenix_Vistex_Update__c, Phoenix_Vistex_Update_Comments__c,
                              Phoenix_Finance_Approval_Comments__c, Phoenix_Contracts_Approval__c, Phoenix_Contracts_Approval_Comments__c 
                              FROM Phoenix_Bid__c 
                              WHERE Id =: bidId];
        List < ContentDocumentLink > entries = [SELECT Id, LinkedEntityId, ContentDocument.Title, ContentDocument.FileExtension, ContentDocumentId
                                                FROM ContentDocumentLink 
                                                WHERE LinkedEntityId =: bidId];
        String SobjectApiName = 'Phoenix_VIP_Rebate_Line__c';
        Map < String, Schema.SObjectType > schemaMap = Schema.getGlobalDescribe();
        Map < String, Schema.SObjectField > fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();
        String strFields = '';
        for (String fieldName: fieldMap.keyset()) {
            if (strFields == null || strFields == '') {
                strFields = fieldName;
            } else {
                strFields = strFields + ',' + fieldName;
            }
        }
        String current = 'Current';
        String vipRebateQuery = 'select Id, Name, Phoenix_Start_Date__c, Payment_Frequency__c, Rx_SRx_OTC__c, Net_Contract__c, Phoenix_End_Date__c, Phoenix_Type__c, Phoenix_Exclusions__c, createdDate,LastModifiedDate, Phoenix_Exclusion_details__c FROM Phoenix_Bid_VIP_Rebate__c WHERE Phoenix_Status__c =: current AND Phoenix_Customer__c =: customerId ';
        if(divisionTab != 'None'){
            vipRebateQuery += ' AND Rx_SRx_OTC__c=:divisionTab'; 
        }
        vipRebateQuery += ' ORDER BY Phoenix_End_Date__c DESC'; 
        List < Phoenix_Bid_VIP_Rebate__c > vipCurrent = Database.query(vipRebateQuery);
        String query = '';
        system.debug('vipCurrent: '+vipCurrent);
        if (!vipCurrent.isEmpty()) {
            Id vipCurrentId = vipCurrent[0].Id;
            query = 'select '+ strFields + ' from '+ SobjectApiName+' where Phoenix_VIP_Rebate__c =:vipCurrentId ORDER BY Phoenix_Tier__c ASC LIMIT 10000';
            list < Phoenix_VIP_Rebate_Line__c > quoteList = Database.query(query);
            if(quoteList.size()>0){
                quoteList = sortLineItems(quoteList);
            }
            wrapperObject.rebatesList = quoteList;
            wrapperObject.currentRebate = vipCurrentId;
            wrapperObject.currentRebateName = vipCurrent[0].Name;
            wrapperObject.strtDate = vipCurrent[0].Phoenix_Start_Date__c;
            wrapperObject.endDate = vipCurrent[0].Phoenix_End_Date__c;
            wrapperObject.type = vipCurrent[0].Phoenix_Type__c;
            wrapperObject.exclusions = vipCurrent[0].Phoenix_Exclusions__c;
            wrapperObject.excDetails = vipCurrent[0].Phoenix_Exclusion_details__c;
            wrapperObject.paymentFrequency = vipCurrent[0].Payment_Frequency__c;
            wrapperObject.netGross = vipCurrent[0].Net_Contract__c;
            wrapperObject.division = vipCurrent[0].Rx_SRx_OTC__c;
        }
        List < Phoenix_Bid_VIP_Rebate__c > vipProposed = [SELECT Id, Name, Phoenix_Start_Date__c, Phoenix_End_Date__c, Rx_SRx_OTC__c, Payment_Frequency__c, Net_Contract__c,
                                                          Phoenix_Type__c, Phoenix_Exclusions__c, Phoenix_Exclusion_details__c 
                                                          FROM Phoenix_Bid_VIP_Rebate__c 
                                                          WHERE Phoenix_Bid__c =: bidId
                                                          AND Phoenix_Status__c = 'Proposed'
                                                          AND Phoenix_Customer__c =: customerId];
        system.debug('proposedRebate: '+vipProposed);
        if (!vipProposed.isEmpty()) {
            Id vipProposedId = vipProposed[0].Id;
            query = 'select' + ' ' + strFields + ' ' + 'from' + ' ' + SobjectApiName + ' ' + 'where Phoenix_VIP_Rebate__c =:vipProposedId ORDER BY Phoenix_Tier__c ASC LIMIT 10000';
            list < Phoenix_VIP_Rebate_Line__c > quoteListPro = Database.query(query);
            if(quoteListPro.size()>0){
                quoteListPro = sortLineItems(quoteListPro);
            }
            wrapperObject.rebatesListProposed = quoteListPro;
            wrapperObject.proposedRebate = vipProposedId;
            wrapperObject.proposedRebateName = vipProposed[0].Name;
            wrapperObject.strtDatePro = vipProposed[0].Phoenix_Start_Date__c;
            wrapperObject.endDatePro = vipProposed[0].Phoenix_End_Date__c;
            wrapperObject.typePro = vipProposed[0].Phoenix_Type__c;
            wrapperObject.exclusionsPro = vipProposed[0].Phoenix_Exclusions__c;
            wrapperObject.excDetailsPro = vipProposed[0].Phoenix_Exclusion_details__c;
            wrapperObject.proposedPaymentFrequency = vipProposed[0].Payment_Frequency__c;
            wrapperObject.proposedNetGross = vipProposed[0].Net_Contract__c;
            wrapperObject.division = vipProposed[0].Rx_SRx_OTC__c;
        }
        wrapperObject.bidRecord = bid;
        wrapperObject.bidType = bid.Phoenix_Bid_Type__c;
        wrapperObject.custName = bid.Phoenix_Customer__r.Name;
        wrapperObject.approvalStatus = bid.Phoenix_Approval_Status__c;
        wrapperObject.loggedInUserId = UserInfo.getName();
        if (!entries.isEmpty()) {
            wrapperObject.conDocLink = entries;
        }
        return wrapperObject;
    }
    
    @AuraEnabled
    public static Wrapper getRelatedList(Id bidId) {
        Wrapper wrapperObject = new Wrapper();
        String query = '';
        String queryPro = '';
        String SobjectApiName = 'Phoenix_VIP_Rebate_Line__c';
        Map < String, Schema.SObjectType > schemaMap = Schema.getGlobalDescribe();
        Map < String, Schema.SObjectField > fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();
        String strFields = '';
        for (String fieldName: fieldMap.keyset()) {
            if (strFields == null || strFields == '') {
                strFields = fieldName;
            } else {
                strFields = strFields + ',' + fieldName;
            }
        }
        List < String > filterType = new List < String > ();
        filterType.add('Current');
        List < String > filterType1 = new List < String > ();
        filterType1.add('Proposed');
        Phoenix_Bid__c bidRec = [select Id, Phoenix_Customer__c, Phoenix_Current_VIP_Rebate__c, Phoenix_Proposed_VIP_Rebate__c FROM Phoenix_Bid__c WHERE Id =: bidId LIMIT 1];
        Phoenix_Bid__c bid = [SELECT Id, Name, Phoenix_Bid_Type__c, Phoenix_Customer__r.Name, Phoenix_Customer__c, Phoenix_Bid_Name__c, Phoenix_Approval_Status__c,
                              Phoenix_Business_Approval__c, Phoenix_Business_Approval_Comments__c, Phoenix_Finance_Approval__c,
                              Phoenix_Customer_Approval__c, Phoenix_Customer_Approval_Comments__c, Phoenix_Vistex_Update__c, Phoenix_Vistex_Update_Comments__c,
                              Phoenix_Finance_Approval_Comments__c, Phoenix_Contracts_Approval__c, Phoenix_Contracts_Approval_Comments__c FROM Phoenix_Bid__c WHERE Id =: bidId
                             ];
        Id accId = bid.Phoenix_Customer__c;
        List < Id > accList = new List < Id > ();
        accList.add(accId);
        Account acc = [SELECT Id, Phoenix_Contracts_Approver__c, Phoenix_Customer_Service_Approver__c FROM Account where id =: bid.Phoenix_Customer__c LIMIT 1];
        
        
        List < ContentDocumentLink > entries = [SELECT Id, LinkedEntityId, ContentDocument.Title, ContentDocument.FileExtension, ContentDocumentId FROM ContentDocumentLink where LinkedEntityId =: bidRec.Id];
        
        Map < String, String > userTeamUserIdMap = new Map < String, String > ();
        for (Phoenix_User_Approval_Matrix__c matrix: [Select Id, Name, RecordType.DeveloperName, Phoenix_Approver__r.Name, User_Group__r.Phoenix_Approver_Group_Name__c, Phoenix_Approval_Group_Behavior__c, Phoenix_Approver__c, Phoenix_Approver__r.Email, Phoenix_Approver_Group_Name__c, Phoenix_Is_Active_User__c, Phoenix_Is_Approval_Process_User__c, User_Group__c from Phoenix_User_Approval_Matrix__c limit 1000]) {
            String userTeamUserIdMapKey = matrix.User_Group__r.Phoenix_Approver_Group_Name__c + '-' + matrix.Phoenix_Approver__c;
            userTeamUserIdMap.put(userTeamUserIdMapKey, matrix.Phoenix_Approver__r.Name);
        }
        string isBusinessApprovePerson;
        string isFinanceApprovePerson;
        string isContractsApprovePerson;
        string isCustomerApprovePerson;
        string isVistexApprovePerson;
        if (userTeamUserIdMap.containsKey('Business Head-' + UserInfo.getUserId())) {
            isBusinessApprovePerson = userTeamUserIdMap.get(('Business Head-' + UserInfo.getUserId()));
        }
        if (userTeamUserIdMap.containsKey('Finance-' + UserInfo.getUserId())) {
            isFinanceApprovePerson = userTeamUserIdMap.get(('Finance-' + UserInfo.getUserId()));
        }
        if (acc.Phoenix_Contracts_Approver__c == UserInfo.getUserId() || userTeamUserIdMap.containsKey('Contracts-' + UserInfo.getUserId())) {
            isContractsApprovePerson = UserInfo.getName();
        }
        if (acc.Phoenix_Contracts_Approver__c == UserInfo.getUserId() || userTeamUserIdMap.containsKey('Contracts-' + UserInfo.getUserId())) {
            isCustomerApprovePerson = UserInfo.getName();
        }
        
        if (userTeamUserIdMap.containsKey('Home Office-' + UserInfo.getUserId())) {
            isVistexApprovePerson = userTeamUserIdMap.get(('Home Office-' + UserInfo.getUserId()));
        }
        //List<Phoenix_Bid_VIP_Rebate__c> vipCurrentReq= new List<Phoenix_Bid_VIP_Rebate__c>(); 
        List < Phoenix_Bid_VIP_Rebate__c > vipCurrent = [SELECT Id, Name, Phoenix_Start_Date__c, Phoenix_End_Date__c, 
                                                         Phoenix_Type__c, Phoenix_Exclusions__c, createdDate, 
                                                         LastModifiedDate, Phoenix_Exclusion_details__c 
                                                         FROM Phoenix_Bid_VIP_Rebate__c 
                                                         WHERE Id =: bidRec.Phoenix_Current_VIP_Rebate__c
                                                         AND Phoenix_Customer__c =: bid.Phoenix_Customer__c];
        /* for(Phoenix_Bid_VIP_Rebate__c vip:vipCurrent) {
if(vip.createdDate ==vip.LastModifiedDate){
vipCurrentReq.add(vip);  
}
}*/
        if (!vipCurrent.isEmpty()) {
            Id vipCurrentId = vipCurrent[0].Id;
            //  query = 'select' + ' ' + strFields + ' ' + 'from' + ' ' + SobjectApiName + ' ' + 'where Phoenix_VIP_Rebate__c =:vipCurrentId ORDER BY Phoenix_Tier__c';
            query = 'select' + ' ' + strFields + ' ' + 'from' + ' ' + SobjectApiName + ' ' + 'where Phoenix_VIP_Rebate__c =:vipCurrentId ';
            list < Phoenix_VIP_Rebate_Line__c > quoteList = Database.query(query);
            if(quoteList.size()>0){
                quoteList = sortLineItems(quoteList);
            }
            wrapperObject.rebatesList = quoteList;
            wrapperObject.currentRebate = vipCurrentId;
            wrapperObject.currentRebateName = vipCurrent[0].Name;
            wrapperObject.strtDate = vipCurrent[0].Phoenix_Start_Date__c;
            wrapperObject.endDate = vipCurrent[0].Phoenix_End_Date__c;
            wrapperObject.type = vipCurrent[0].Phoenix_Type__c;
            wrapperObject.exclusions = vipCurrent[0].Phoenix_Exclusions__c;
            wrapperObject.excDetails = vipCurrent[0].Phoenix_Exclusion_details__c;
        }
        List < Phoenix_Bid_VIP_Rebate__c > vipProposed = [SELECT Id, Name, Phoenix_Start_Date__c, Phoenix_End_Date__c, Phoenix_Type__c, Phoenix_Exclusions__c, Phoenix_Exclusion_details__c FROM Phoenix_Bid_VIP_Rebate__c WHERE Id =: bidRec.Phoenix_Proposed_VIP_Rebate__c];
        // <a href="' + vipProposed[0].Id.getInstance().Url__c + '">link</a>
        // bidRec.Phoenix_Proposed_Rebate__c='<a href="'+URL.getSalesforceBaseUrl() +'/'+vipProposed[0].Id+'">'+vipProposed[0].Name+'</a>' ;
        // update bidRec;
        
        if (!vipProposed.isEmpty()) {
            Id vipProposedId = vipProposed[0].Id;
            //  queryPro = 'select' + ' ' + strFields + ' ' + 'from' + ' ' + SobjectApiName + ' ' + 'where Phoenix_VIP_Rebate__c =:vipProposedId ORDER BY Phoenix_Tier__c';
            queryPro = 'select' + ' ' + strFields + ' ' + 'from' + ' ' + SobjectApiName + ' ' + 'where Phoenix_VIP_Rebate__c =:vipProposedId ';
            list < Phoenix_VIP_Rebate_Line__c > quoteListPro = Database.query(queryPro);
            if(quoteListPro.size()>0){
                quoteListPro = sortLineItems(quoteListPro);
            }
            wrapperObject.rebatesListProposed = quoteListPro;
            wrapperObject.proposedRebate = vipProposedId;
            wrapperObject.proposedRebateName = vipProposed[0].Name;
            wrapperObject.strtDatePro = vipProposed[0].Phoenix_Start_Date__c;
            wrapperObject.endDatePro = vipProposed[0].Phoenix_End_Date__c;
            wrapperObject.typePro = vipProposed[0].Phoenix_Type__c;
            wrapperObject.exclusionsPro = vipProposed[0].Phoenix_Exclusions__c;
            wrapperObject.excDetailsPro = vipProposed[0].Phoenix_Exclusion_details__c;
        }
        wrapperObject.bidRecord = bid;
        wrapperObject.bidType = bid.Phoenix_Bid_Type__c;
        wrapperObject.custName = bid.Phoenix_Customer__r.Name;
        wrapperObject.approvalStatus = bid.Phoenix_Approval_Status__c;
        wrapperObject.loggedInUserId = UserInfo.getName();
        wrapperObject.isBusinessApprovePerson = isBusinessApprovePerson;
        wrapperObject.isFinanceApprovePerson = isFinanceApprovePerson;
        wrapperObject.isContractsApprovePerson = isContractsApprovePerson;
        wrapperObject.isCustomerApprovePerson = isCustomerApprovePerson;
        wrapperObject.isVistexApprovePerson = isVistexApprovePerson;
        if (!entries.isEmpty()) {
            wrapperObject.conDocLink = entries;
        }
        
        return wrapperObject;
    }
    @AuraEnabled
    public static List < ContentDocumentLink > getDocs(String bidId) {
        Phoenix_Bid__c bidRec = [select Id FROM Phoenix_Bid__c where id =: bidId];
        //return [SELECT Id, LinkedEntityId, ContentDocument.Title,ContentDocument.FileExtension,ContentDocumentId FROM ContentDocumentLink where LinkedEntityId=:bidRec.Id];
        return [SELECT Id, LinkedEntityId, ContentDocument.Title, ContentDocument.FileExtension, ContentDocumentId FROM ContentDocumentLink where LinkedEntityId =: bidId];
    }
    public class Columns {
        @AuraEnabled public string label;
        @AuraEnabled public string value;
    }
    
    public class Wrapper {
        @AuraEnabled public List < Columns > columnList;
        @AuraEnabled public List < Phoenix_VIP_Rebate_Line__c > rebatesList;
        @AuraEnabled public List < Phoenix_VIP_Rebate_Line__c > rebatesListProposed;
        @AuraEnabled public Phoenix_Bid_VIP_Rebate__c vipRebate;
        @auraEnabled public boolean existingVIPrebate;
        @AuraEnabled public Phoenix_Bid__c bidRecord;
        @auraEnabled public Integer vipRebateCount;
        @auraEnabled public String customerName;
        @auraEnabled public String customerId;
        @AuraEnabled public Date strtDate;
        @AuraEnabled public Date endDate;
        @AuraEnabled public string type;
        @AuraEnabled public boolean exclusions;
        @AuraEnabled public string excDetails;
        @AuraEnabled public Date strtDatePro;
        @AuraEnabled public Date endDatePro;
        @AuraEnabled public string typePro;
        @AuraEnabled public boolean exclusionsPro;
        @AuraEnabled public string excDetailsPro;
        @AuraEnabled public string bidType;
        @AuraEnabled public string custName;
        @AuraEnabled public id currentRebate;
        @AuraEnabled public string currentRebateName;
        @AuraEnabled public id proposedRebate;
        @AuraEnabled public string proposedRebateName;
        @AuraEnabled public string approvalStatus;
        @AuraEnabled public string loggedInUserId;
        @AuraEnabled public string isBusinessApprovePerson;
        @AuraEnabled public string isFinanceApprovePerson;
        @AuraEnabled public string isContractsApprovePerson;
        @AuraEnabled public string isCustomerApprovePerson;
        @AuraEnabled public string isVistexApprovePerson;
        @AuraEnabled public List < ContentDocumentLink > conDocLink;
        @AuraEnabled public String paymentFrequency;
        @AuraEnabled public String netGross;
        @AuraEnabled public String proposedPaymentFrequency;
        @AuraEnabled public String proposedNetGross;
        @AuraEnabled public String division;
        
        
        Wrapper() {
            columnList = new List < Columns > ();
            //rebatesList = new List<Phoenix_VIP_Rebate_Line__c>();
        }
    }
    
    @auraEnabled
    public static list<Phoenix_VIP_Rebate_Line__c> saveLineItemsInTab(List <Phoenix_VIP_Rebate_Line__c> LineItemList, 
                                                                      Id recId, 
                                                                      String excsnDetails, 
                                                                      Date stDate, 
                                                                      Date endDate, 
                                                                      Boolean exclusions, 
                                                                      String rebType, 
                                                                      String customerId, String paymentFrequency, String netGross, String division, String agreementNo)
    {
        Phoenix_Bid_VIP_Rebate__c newRebate = new Phoenix_Bid_VIP_Rebate__c();
        Integer i = 0;
        String vipRebateId = '';
        Map < String, Phoenix_Bid_VIP_Rebate__c > vipRebateMap = new Map < String, Phoenix_Bid_VIP_Rebate__c > ();
        List < Phoenix_Bid_VIP_Rebate__c > prodct23 = [SELECT Id, Phoenix_Customer__c FROM Phoenix_Bid_VIP_Rebate__c WHERE Phoenix_Status__c = 'Proposed'
                                                       AND Phoenix_Bid__c =: recId AND Phoenix_Customer__c =: customerId];
        if (!prodct23.isEmpty()) {
            prodct23[0].Phoenix_End_Date__c = endDate;
            prodct23[0].Phoenix_Start_Date__c = stDate;
            prodct23[0].Phoenix_Exclusions__c = exclusions;
            prodct23[0].Phoenix_Exclusion_details__c = excsnDetails;
            prodct23[0].Phoenix_Type__c = rebType;
            prodct23[0].Phoenix_Status__c = 'Proposed';
            prodct23[0].Payment_Frequency__c = paymentFrequency;
            prodct23[0].Net_Contract__c = netGross;
            prodct23[0].Rx_SRx_OTC__c = division;
            prodct23[0].Vistex_Agreement__c = agreementNo;
            update prodct23[0];
            vipRebateId = prodct23[0].Id;
        } else {
            newRebate.Phoenix_Bid__c = recId;
            newRebate.Phoenix_Customer__c = customerId;
            newRebate.Phoenix_End_Date__c = endDate;
            newRebate.Phoenix_Start_Date__c = stDate;
            
            newRebate.Phoenix_Exclusions__c = exclusions;
            newRebate.Phoenix_Exclusion_details__c = excsnDetails;
            newRebate.Phoenix_Type__c = rebType;
            newRebate.Phoenix_Status__c = 'Proposed';
            newRebate.Payment_Frequency__c = paymentFrequency;
            newRebate.Net_Contract__c = netGross;
            newRebate.Rx_SRx_OTC__c = division;
            newRebate.Vistex_Agreement__c = agreementNo;
            insert newRebate;
            vipRebateId = newRebate.Id;
        }
        
        Map < String, Phoenix_VIP_Rebate_Line__c > productMap = new Map < String, Phoenix_VIP_Rebate_Line__c > ();
        List < Phoenix_VIP_Rebate_Line__c > prodct = [SELECT Id, Phoenix_Tier__c, Phoenix_Unit_Volume_To__c, Phoenix_Unit_Volume_From__c,
                                                      Phoenix_Dollar_Value_From__c, Phoenix_Dollar_Value_To__c
                                                      FROM Phoenix_VIP_Rebate_Line__c 
                                                      WHERE Phoenix_VIP_Rebate__c =: vipRebateId];//newRebate.Id];
        string rebateType = rebType;
        
        list < Phoenix_VIP_Rebate_Line__c > rbListInsert = new list < Phoenix_VIP_Rebate_Line__c > ();
        list < Phoenix_VIP_Rebate_Line__c > rbListUpdate = new list < Phoenix_VIP_Rebate_Line__c > ();
        list < Phoenix_VIP_Rebate_Line__c > rbListUpsertList = new list < Phoenix_VIP_Rebate_Line__c > ();
        
        for (Phoenix_VIP_Rebate_Line__c product: prodct) {
            productMap.put(product.Phoenix_Tier__c, product);
        }
        Integer prodctSize = prodct.size();
        for (Phoenix_VIP_Rebate_Line__c rb: LineItemList) {
            if (productMap.containsKey(rb.Phoenix_Tier__c)) {
                Phoenix_VIP_Rebate_Line__c prod = productMap.get(rb.Phoenix_Tier__c);
                prod.Id = productMap.get(rb.Phoenix_Tier__c).Id;
                if (rebateType == 'Currency') {
                    prod.Phoenix_Unit_Volume_To__c = null;
                    prod.Phoenix_Unit_Volume_From__c = null;
                    if (rb.Phoenix_Dollar_Value_From__c != null) {
                        prod.Phoenix_Dollar_Value_From__c = rb.Phoenix_Dollar_Value_From__c;
                    }
                    if (rb.Phoenix_Dollar_Value_To__c != null) {
                        prod.Phoenix_Dollar_Value_To__c = rb.Phoenix_Dollar_Value_To__c;
                    }
                    else if(rb.Phoenix_Dollar_Value_To__c == null)
                        prod.Phoenix_Dollar_Value_To__c = null;
                }
                if (rebateType == 'Quantity') {
                    prod.Phoenix_Dollar_Value_To__c = null;
                    prod.Phoenix_Dollar_Value_From__c = null;
                    if (rb.Phoenix_Unit_Volume_From__c != null) {
                        prod.Phoenix_Unit_Volume_From__c = rb.Phoenix_Unit_Volume_From__c;
                    }
                    if (rb.Phoenix_Unit_Volume_To__c != null) {
                        prod.Phoenix_Unit_Volume_To__c = rb.Phoenix_Unit_Volume_To__c;
                    }
                    else if(rb.Phoenix_Unit_Volume_To__c == null)
                        prod.Phoenix_Unit_Volume_To__c = null;
                }
                
                if (rb.Phoenix_Discount_Rebate__c != null)
                    prod.Phoenix_Discount_Rebate__c = rb.Phoenix_Discount_Rebate__c;
                if (rb.Phoenix_Remarks__c != ' ')
                    prod.Phoenix_Remarks__c = rb.Phoenix_Remarks__c;
                rbListUpdate.add(prod);
                i++;
            } else {
                /*Phoenix_VIP_Rebate_Line__c newReb = new Phoenix_VIP_Rebate_Line__c();
                if ((rb.Phoenix_Dollar_Value_From__c != null) && (rebateType == 'Currency'))
                    newReb.Phoenix_Dollar_Value_From__c = rb.Phoenix_Dollar_Value_From__c;
                if ((rb.Phoenix_Dollar_Value_To__c != null) && (rebateType == 'Currency'))
                    newReb.Phoenix_Dollar_Value_To__c = rb.Phoenix_Dollar_Value_To__c;
                if ((rb.Phoenix_Unit_Volume_From__c != null) && (rebateType == 'Quantity'))
                    newReb.Phoenix_Unit_Volume_From__c = rb.Phoenix_Unit_Volume_From__c;
                if ((rb.Phoenix_Unit_Volume_To__c != null) && (rebateType == 'Quantity'))
                    newReb.Phoenix_Unit_Volume_To__c = rb.Phoenix_Unit_Volume_To__c;
                if (rb.Phoenix_Discount_Rebate__c != null)
                    newReb.Phoenix_Discount_Rebate__c = rb.Phoenix_Discount_Rebate__c;
                if (rb.Phoenix_Remarks__c != '')
                    newReb.Phoenix_Remarks__c = rb.Phoenix_Remarks__c;
                newReb.Phoenix_VIP_Rebate__c = prodct23[0].Id;
                newReb.Phoenix_Tier__c = 'Tier' + ' ' + String.valueOf(prodctSize + 1);//String.valueOf(i + 1);*/
                rb.Phoenix_VIP_Rebate__c = vipRebateId;//prodct23[0].Id;
                rb.Phoenix_Tier__c = 'Tier' + ' ' + String.valueOf(prodctSize + 1);//String.valueOf(i + 1);
                rbListInsert.add(rb);
                i++;prodctSize++;
            }
        }
        if (!rbListInsert.isEmpty()) {
            insert rbListInsert;
        }
        if (!rbListUpdate.isEmpty()) {
            Set < Phoenix_VIP_Rebate_Line__c > sStrings = new Set < Phoenix_VIP_Rebate_Line__c > (rbListUpdate);
            List < Phoenix_VIP_Rebate_Line__c > lStrings = new List < Phoenix_VIP_Rebate_Line__c > (sStrings);
            update lStrings;
        }
        List < Phoenix_VIP_Rebate_Line__c > returnLineList = [SELECT Id, Phoenix_Tier__c, Phoenix_Unit_Volume_To__c, 
                                                              Phoenix_Unit_Volume_From__c,
                                                              Phoenix_Dollar_Value_From__c, Phoenix_Dollar_Value_To__c
                                                              FROM Phoenix_VIP_Rebate_Line__c 
                                                              WHERE Phoenix_VIP_Rebate__c =: vipRebateId];
        if(returnLineList.size()>0){
            returnLineList = sortLineItems(returnLineList);
        }
        
        return returnLineList;
        //return LineItemList;
    }
    
    
    @AuraEnabled
    public static list < Phoenix_VIP_Rebate_Line__c > saveLineItems(List < Phoenix_VIP_Rebate_Line__c > LineItemList, 
                                                                    Id recId, String excsnDetails, 
                                                                    Date stDate, Date endDate, 
                                                                    Boolean exclusions, String rebType, 
                                                                    String customerId, String paymentFrequency, String netGross, String division, String agreementNo) 
    {
        Phoenix_Bid__c bidRec = [select Id, Phoenix_Customer__c FROM Phoenix_Bid__c WHERE Id =: recId LIMIT 1];
        return Phoenix_BidVIPRebateChangeReqCtrl.saveLineItemsInTab(LineItemList, 
                                                                    recId, 
                                                                    excsnDetails, 
                                                                    stDate, 
                                                                    endDate, 
                                                                    exclusions, 
                                                                    rebType, 
                                                                    bidRec.Phoenix_Customer__c, paymentFrequency, netGross, division, agreementNo); 
        /*list < Phoenix_VIP_Rebate_Line__c > rbListInsert = new list < Phoenix_VIP_Rebate_Line__c > ();
        list < Phoenix_VIP_Rebate_Line__c > rbListUpdate = new list < Phoenix_VIP_Rebate_Line__c > ();
        list < Phoenix_VIP_Rebate_Line__c > LineItemListCopy = new list < Phoenix_VIP_Rebate_Line__c > ();
        list < Phoenix_Bid_VIP_Rebate__c > newRebateList = new list < Phoenix_Bid_VIP_Rebate__c > ();
        Phoenix_Bid_VIP_Rebate__c newRebate = new Phoenix_Bid_VIP_Rebate__c();
        Integer i = -1;
        System.debug('---------rebType-------' + rebType);
        Phoenix_Bid__c bidRec = [select Id, Phoenix_Customer__c FROM Phoenix_Bid__c WHERE Id =: recId LIMIT 1];
        return Phoenix_BidVIPRebateChangeReqCtrl.saveLineItemsInTab(List < Phoenix_VIP_Rebate_Line__c > LineItemList, 
                                                                    Id recId, 
                                                                    String excsnDetails, 
                                                                    Date stDate, 
                                                                    Date endDate, 
                                                                    Boolean exclusions, 
                                                                    String rebType, 
                                                                    bidRec.Phoenix_Customer__c);
        system.debug('bidRec-----'+bidRec);
        Map < String, Phoenix_Bid_VIP_Rebate__c > vipRebateMap = new Map < String, Phoenix_Bid_VIP_Rebate__c > ();
        List < Phoenix_Bid_VIP_Rebate__c > prodct23 = [SELECT Id, Phoenix_Customer__c 
                                                       FROM Phoenix_Bid_VIP_Rebate__c 
                                                       WHERE Phoenix_Status__c = 'Proposed'
                                                       AND Phoenix_Bid__c =: bidRec.Id
                                                       AND Phoenix_Customer__c =: bidRec.Phoenix_Customer__c];
        system.debug('prodct23-----'+prodct23);
        if (!prodct23.isEmpty()) {
            prodct23[0].Phoenix_End_Date__c = endDate;
            prodct23[0].Phoenix_Start_Date__c = stDate;
            //  if(exclusions!=undefined){
            prodct23[0].Phoenix_Exclusions__c = exclusions;
            //  }
            //     if(excsnDetails!=undefined){
            prodct23[0].Phoenix_Exclusion_details__c = excsnDetails;
            //      }
            prodct23[0].Phoenix_Type__c = rebType;
            prodct23[0].Phoenix_Status__c = 'Proposed';
            update prodct23[0];
            bidRec.Phoenix_Proposed_VIP_Rebate__c = prodct23[0].Id;
            update bidRec;
        } else {
            newRebate.Phoenix_Bid__c = bidRec.Id;
            newRebate.Phoenix_Customer__c = bidRec.Phoenix_Customer__c;
            newRebate.Phoenix_End_Date__c = endDate;
            newRebate.Phoenix_Start_Date__c = stDate;
            
            newRebate.Phoenix_Exclusions__c = exclusions;
            newRebate.Phoenix_Exclusion_details__c = excsnDetails;
            newRebate.Phoenix_Type__c = rebType;
            newRebate.Phoenix_Status__c = 'Proposed';
            insert newRebate;
            bidRec.Phoenix_Proposed_VIP_Rebate__c = newRebate.Id;
            update bidRec;
        }
        
        Map < String, Phoenix_VIP_Rebate_Line__c > productMap = new Map < String, Phoenix_VIP_Rebate_Line__c > ();
        List < Phoenix_VIP_Rebate_Line__c > prodct = [SELECT Id, Phoenix_Tier__c FROM Phoenix_VIP_Rebate_Line__c WHERE Phoenix_VIP_Rebate__c =: prodct1];
        system.debug('prodct1-----'+prodct1);
        system.debug('prodct-----'+prodct);
        string rebateType = rebType;
        for (Phoenix_VIP_Rebate_Line__c product: prodct) {
            productMap.put(product.Phoenix_Tier__c, product);
        }
        for (Phoenix_VIP_Rebate_Line__c rb: LineItemList) {
            if (productMap.containsKey(rb.Phoenix_Tier__c)) {
                Phoenix_VIP_Rebate_Line__c prod = productMap.get(rb.Phoenix_Tier__c);
                prod.Id = productMap.get(rb.Phoenix_Tier__c).Id;
                if (rebateType == 'Currency') {
                    prod.Phoenix_Unit_Volume_To__c = null;
                    prod.Phoenix_Unit_Volume_From__c = null;
                    if (rb.Phoenix_Dollar_Value_From__c != null) {
                        prod.Phoenix_Dollar_Value_From__c = rb.Phoenix_Dollar_Value_From__c;
                    }
                    if (rb.Phoenix_Dollar_Value_To__c != null) {
                        prod.Phoenix_Dollar_Value_To__c = rb.Phoenix_Dollar_Value_To__c;
                    }
                }
                if (rebateType == 'Quantity') {
                    prod.Phoenix_Dollar_Value_To__c = null;
                    prod.Phoenix_Dollar_Value_From__c = null;
                    if (rb.Phoenix_Unit_Volume_From__c != null) {
                        prod.Phoenix_Unit_Volume_From__c = rb.Phoenix_Unit_Volume_From__c;
                    }
                    if (rb.Phoenix_Unit_Volume_To__c != null) {
                        prod.Phoenix_Unit_Volume_To__c = rb.Phoenix_Unit_Volume_To__c;
                    }
                }
                
                if (rb.Phoenix_Discount_Rebate__c != null)
                    prod.Phoenix_Discount_Rebate__c = rb.Phoenix_Discount_Rebate__c;
                if (rb.Phoenix_Remarks__c != ' ')
                    prod.Phoenix_Remarks__c = rb.Phoenix_Remarks__c;
                
                rbListUpdate.add(prod);
                i++;
            } else {
                i = i + 1;
                Phoenix_VIP_Rebate_Line__c newReb = new Phoenix_VIP_Rebate_Line__c();
                if ((rb.Phoenix_Dollar_Value_From__c != null) && (rebateType == 'Currency'))
                    newReb.Phoenix_Dollar_Value_From__c = rb.Phoenix_Dollar_Value_From__c;
                if ((rb.Phoenix_Dollar_Value_To__c != null) && (rebateType == 'Currency'))
                    newReb.Phoenix_Dollar_Value_To__c = rb.Phoenix_Dollar_Value_To__c;
                if ((rb.Phoenix_Unit_Volume_From__c != null) && (rebateType == 'Quantity'))
                    newReb.Phoenix_Unit_Volume_From__c = rb.Phoenix_Unit_Volume_From__c;
                if ((rb.Phoenix_Unit_Volume_To__c != null) && (rebateType == 'Quantity'))
                    newReb.Phoenix_Unit_Volume_To__c = rb.Phoenix_Unit_Volume_To__c;
                if (rb.Phoenix_Discount_Rebate__c != null)
                    newReb.Phoenix_Discount_Rebate__c = rb.Phoenix_Discount_Rebate__c;
                if (rb.Phoenix_Remarks__c != ' ')
                    newReb.Phoenix_Remarks__c = rb.Phoenix_Remarks__c;
                newReb.Phoenix_VIP_Rebate__c = prodct1[0].Id;
                newReb.Phoenix_Tier__c = 'Tier' + ' ' + String.valueOf(i + 1);
                rbListInsert.add(newReb);
            }
        }
        if (!rbListInsert.isEmpty()) {
            insert rbListInsert;
        }
        if (!rbListUpdate.isEmpty()) {
            Set < Phoenix_VIP_Rebate_Line__c > sStrings = new Set < Phoenix_VIP_Rebate_Line__c > (rbListUpdate);
            List < Phoenix_VIP_Rebate_Line__c > lStrings = new List < Phoenix_VIP_Rebate_Line__c > (sStrings);
            update lStrings;
        }
        return LineItemList; */
    }
    
    @AuraEnabled
    public static void makeApprovalsBusiness(String bidId, String finaceCom, string financeAppStatus, string approvStatus) {
        Phoenix_Bid_Process_Steps__c currentStep = [SELECT Id, Name,Phoenix_Approver__r.Email, Phoenix_Bid__c,Phoenix_Is_Criteria_Step__c,Phoenix_Process_Step__c, Phoenix_Step__c, Phoenix_Approver__c, Phoenix_Process_Step__r.Name, Phoenix_Status__c, Phoenix_Approver_Team__c, Phoenix_Approver_Team_Members__c FROM Phoenix_Bid_Process_Steps__c
                                                    where Phoenix_Bid__c =: bidId AND Phoenix_Status__c = 'In Process'
                                                    LIMIT 1
                                                   ];
        List < Phoenix_Bid_Process_Steps__c > updateProcessStep = [SELECT Id, Name,Phoenix_Approver__r.Email, Phoenix_Bid__c,Phoenix_Is_Criteria_Step__c,Phoenix_Process_Step__c, Phoenix_Step__c, Phoenix_Approver__c, Phoenix_Process_Step__r.Name, Phoenix_Status__c, Phoenix_Approver_Team__c, Phoenix_Approver_Team_Members__c FROM Phoenix_Bid_Process_Steps__c where Phoenix_Bid__c =: bidId];
        Map < Integer, List < Phoenix_Bid_Process_Steps__c >> stepMap = new Map < Integer, List < Phoenix_Bid_Process_Steps__c >> ();
        Map < String, List < Phoenix_Bid_Process_Steps__c >> stepNamesMap = new Map < String, List < Phoenix_Bid_Process_Steps__c >> ();
        Map < String, Integer > stepnameNoMap = new Map < String, Integer > ();
        for (Phoenix_Bid_Process_Steps__c step: updateProcessStep) {
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
        Phoenix_Bid__c bidCurrent = [select id, Phoenix_Approval_Status__c from Phoenix_Bid__c where id =: bidId];
        List < Phoenix_Bid_Process_Steps__c > nextSteps = !Test.isRunningTest() ? stepMap.get(stepnameNoMap.get('Business Head') + 1) : new List < Phoenix_Bid_Process_Steps__c > ();
        List < Phoenix_Bid_Process_Steps__c > nextSteps2 = !Test.isRunningTest() ? stepMap.get(stepnameNoMap.get('Business Head') + 2) : new List < Phoenix_Bid_Process_Steps__c > ();
        List < Phoenix_Bid_Process_Steps__c > nextSteps3 = !Test.isRunningTest() ? stepMap.get(stepnameNoMap.get('Business Head') + 3) : new List < Phoenix_Bid_Process_Steps__c > ();
        List < Phoenix_Bid_Process_Steps__c > nextSteps4 = !Test.isRunningTest() ? stepMap.get(stepnameNoMap.get('Business Head') + 4) : new List < Phoenix_Bid_Process_Steps__c > ();
        List < Phoenix_Bid_Process_Steps__c > nextSteps5 = !Test.isRunningTest() ? stepMap.get(stepnameNoMap.get('Business Head') + 5) : new List < Phoenix_Bid_Process_Steps__c > ();
        
        if (financeAppStatus == 'Approved') {
            if (currentStep != null) {
                currentStep.Phoenix_Status__c = 'Completed';
                currentStep.Phoenix_Approver__c = userinfo.getuserid();
                currentStep.Phoenix_Description__c = finaceCom;
                update currentStep;
            }
            
            for (Phoenix_Bid_Process_Steps__c step: nextSteps) {
                step.Phoenix_Status__c = 'In Process'; //'In Process' Submitted //Diff b/w them            
            }
            if (!nextSteps.isEmpty()) {
                update nextSteps;
            }
            bidCurrent.Phoenix_Approval_Status__c = 'Finance';
            update bidCurrent;
            Phoenix_SubmitBidForApprovalCtrl.approvalRequestNotification(bidId,nextsteps);
        } else if (financeAppStatus == 'Not Approved') {
            
            if (currentStep != null) {
                currentStep.Phoenix_Status__c = 'Completed';
                currentStep.Phoenix_Approver__c = userinfo.getuserid();
                currentStep.Phoenix_Description__c = finaceCom;
                update currentStep;
            }
            
            for (Phoenix_Bid_Process_Steps__c step: nextSteps) {
                step.Phoenix_Status__c = 'Not Applicable'; //'In Process' Submitted //Diff b/w them            
            }
            for (Phoenix_Bid_Process_Steps__c step: nextSteps2) {
                step.Phoenix_Status__c = 'Not Applicable'; //'In Process' Submitted //Diff b/w them            
            }
            for (Phoenix_Bid_Process_Steps__c step: nextSteps3) {
                step.Phoenix_Status__c = 'Not Applicable'; //'In Process' Submitted //Diff b/w them            
            }
            for (Phoenix_Bid_Process_Steps__c step: nextSteps4) {
                step.Phoenix_Status__c = 'Not Applicable'; //'In Process' Submitted //Diff b/w them            
            }
            for (Phoenix_Bid_Process_Steps__c step: nextSteps5) {
                step.Phoenix_Status__c = 'Not Applicable'; //'In Process' Submitted //Diff b/w them            
            }
            if (!nextSteps.isEmpty()) {
                update nextSteps;
            }
            if (!nextSteps2.isEmpty()) {
                update nextSteps2;
            }
            if (!nextSteps3.isEmpty()) {
                update nextSteps3;
            }
            if (!nextSteps4.isEmpty()) {
                update nextSteps4;
            }
            if (!nextSteps5.isEmpty()) {
                update nextSteps5;
            }
            bidCurrent.Phoenix_Approval_Status__c = 'Business Head Rejected';
            update bidCurrent;
        } else {
        }
        
    }
    @AuraEnabled
    public static void makeApprovalsFinance(String bidId, String finaceCom, string financeAppStatus, string approvStatus) {
        Phoenix_Bid_Process_Steps__c currentStep = [SELECT Id, Name,Phoenix_Approver__r.Email, Phoenix_Bid__c,Phoenix_Is_Criteria_Step__c,Phoenix_Process_Step__c, Phoenix_Step__c, Phoenix_Approver__c, Phoenix_Process_Step__r.Name, Phoenix_Status__c, Phoenix_Approver_Team__c, Phoenix_Approver_Team_Members__c FROM Phoenix_Bid_Process_Steps__c
                                                    where Phoenix_Bid__c =: bidId AND Phoenix_Status__c = 'In Process'
                                                    LIMIT 1
                                                   ];
        List < Phoenix_Bid_Process_Steps__c > updateProcessStep = [SELECT Id, Name,Phoenix_Approver__r.Email, Phoenix_Bid__c,Phoenix_Is_Criteria_Step__c,Phoenix_Process_Step__c, Phoenix_Step__c, Phoenix_Approver__c, Phoenix_Process_Step__r.Name, Phoenix_Status__c, Phoenix_Approver_Team__c, Phoenix_Approver_Team_Members__c FROM Phoenix_Bid_Process_Steps__c where Phoenix_Bid__c =: bidId];
        Map < Integer, List < Phoenix_Bid_Process_Steps__c >> stepMap = new Map < Integer, List < Phoenix_Bid_Process_Steps__c >> ();
        Map < String, List < Phoenix_Bid_Process_Steps__c >> stepNamesMap = new Map < String, List < Phoenix_Bid_Process_Steps__c >> ();
        Map < String, Integer > stepnameNoMap = new Map < String, Integer > ();
        for (Phoenix_Bid_Process_Steps__c step: updateProcessStep) {
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
        List < Phoenix_Bid_Process_Steps__c > nextSteps = !Test.isRunningTest() ? stepMap.get(stepnameNoMap.get('Finance') + 1) : new List < Phoenix_Bid_Process_Steps__c > ();
        List < Phoenix_Bid_Process_Steps__c > nextSteps2 = !Test.isRunningTest() ? stepMap.get(stepnameNoMap.get('Finance') + 2) : new List < Phoenix_Bid_Process_Steps__c > ();
        List < Phoenix_Bid_Process_Steps__c > nextSteps3 = !Test.isRunningTest() ? stepMap.get(stepnameNoMap.get('Finance') + 3) : new List < Phoenix_Bid_Process_Steps__c > ();
        List < Phoenix_Bid_Process_Steps__c > nextSteps4 = !Test.isRunningTest() ? stepMap.get(stepnameNoMap.get('Finance') + 4) : new List < Phoenix_Bid_Process_Steps__c > ();
        Phoenix_Bid__c bidCurrent = [select id, Phoenix_Approval_Status__c from Phoenix_Bid__c where id =: bidId];
        
        if (financeAppStatus == 'Approved') {
            if (currentStep != null) {
                currentStep.Phoenix_Status__c = 'Completed';
                currentStep.Phoenix_Approver__c = userinfo.getuserid();
                currentStep.Phoenix_Description__c = finaceCom;
                update currentStep;
            }
            
            for (Phoenix_Bid_Process_Steps__c step: nextSteps) {
                step.Phoenix_Status__c = 'In Process'; //'In Process' Submitted //Diff b/w them            
            }
            
            if (!nextSteps.isEmpty()) {
                update nextSteps;
            }
            bidCurrent.Phoenix_Approval_Status__c = 'Contracts';
            update bidCurrent;
            Phoenix_SubmitBidForApprovalCtrl.approvalRequestNotification(bidId,nextsteps);
        } else if (financeAppStatus == 'Not Approved') {
            
            if (currentStep != null) {
                currentStep.Phoenix_Status__c = 'Completed';
                currentStep.Phoenix_Approver__c = userinfo.getuserid();
                currentStep.Phoenix_Description__c = finaceCom;
                update currentStep;
            }
            
            for (Phoenix_Bid_Process_Steps__c step: nextSteps) {
                step.Phoenix_Status__c = 'Not Applicable'; //'In Process' Submitted //Diff b/w them            
            }
            for (Phoenix_Bid_Process_Steps__c step: nextSteps2) {
                step.Phoenix_Status__c = 'Not Applicable'; //'In Process' Submitted //Diff b/w them            
            }
            for (Phoenix_Bid_Process_Steps__c step: nextSteps3) {
                step.Phoenix_Status__c = 'Not Applicable'; //'In Process' Submitted //Diff b/w them            
            }
            for (Phoenix_Bid_Process_Steps__c step: nextSteps4) {
                step.Phoenix_Status__c = 'Not Applicable'; //'In Process' Submitted //Diff b/w them            
            }
            
            if (!nextSteps.isEmpty()) {
                update nextSteps;
            }
            if (!nextSteps2.isEmpty()) {
                update nextSteps2;
            }
            if (!nextSteps3.isEmpty()) {
                update nextSteps3;
            }
            if (!nextSteps4.isEmpty()) {
                update nextSteps4;
            }
            bidCurrent.Phoenix_Approval_Status__c = 'Finance Rejected';//Closed';
            update bidCurrent;
        } else {
        }
        
        
    }
    @AuraEnabled
    public static void makeApprovalsContracts(String bidId, String finaceCom, string financeAppStatus, string approvStatus) {
        Phoenix_Bid_Process_Steps__c currentStep = [SELECT Id, Phoenix_Approver__r.Email,Name, Phoenix_Bid__c,Phoenix_Is_Criteria_Step__c,Phoenix_Process_Step__c, Phoenix_Step__c, Phoenix_Approver__c, Phoenix_Process_Step__r.Name, Phoenix_Status__c, Phoenix_Approver_Team__c, Phoenix_Approver_Team_Members__c FROM Phoenix_Bid_Process_Steps__c
                                                    where Phoenix_Bid__c =: bidId AND Phoenix_Status__c = 'In Process'
                                                    LIMIT 1
                                                   ];
        List < Phoenix_Bid_Process_Steps__c > updateProcessStep = [SELECT Id,Phoenix_Approver__r.Email, Name, Phoenix_Bid__c,Phoenix_Is_Criteria_Step__c,Phoenix_Process_Step__c, Phoenix_Step__c, Phoenix_Approver__c, Phoenix_Process_Step__r.Name, Phoenix_Status__c, Phoenix_Approver_Team__c, Phoenix_Approver_Team_Members__c FROM Phoenix_Bid_Process_Steps__c where Phoenix_Bid__c =: bidId];
        Map < Integer, List < Phoenix_Bid_Process_Steps__c >> stepMap = new Map < Integer, List < Phoenix_Bid_Process_Steps__c >> ();
        Map < String, List < Phoenix_Bid_Process_Steps__c >> stepNamesMap = new Map < String, List < Phoenix_Bid_Process_Steps__c >> ();
        Map < String, Integer > stepnameNoMap = new Map < String, Integer > ();
        for (Phoenix_Bid_Process_Steps__c step: updateProcessStep) {
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
        List < Phoenix_Bid_Process_Steps__c > nextSteps = !Test.isRunningTest() ? stepMap.get(5) : new List < Phoenix_Bid_Process_Steps__c > ();
        List < Phoenix_Bid_Process_Steps__c > nextSteps2 = !Test.isRunningTest() ? stepMap.get(6) : new List < Phoenix_Bid_Process_Steps__c > ();
        List < Phoenix_Bid_Process_Steps__c > nextSteps3 = !Test.isRunningTest() ? stepMap.get(7) : new List < Phoenix_Bid_Process_Steps__c > ();
        Phoenix_Bid__c bidCurrent = [select id, Phoenix_Approval_Status__c from Phoenix_Bid__c where id =: bidId];
        
        if (financeAppStatus == 'Sent to Customer') {
            if (currentStep != null) {
                currentStep.Phoenix_Status__c = 'Completed';
                currentStep.Phoenix_Approver__c = userinfo.getuserid();
                currentStep.Phoenix_Description__c = finaceCom;
                update currentStep;
            }
            
            Phoenix_Bid_VIP_Rebate__c vipReb = [select id from Phoenix_Bid_VIP_Rebate__c where Phoenix_Bid__c =: bidId AND Phoenix_Status__c = 'Proposed'
                                                LIMIT 1
                                               ];
            if (approvStatus == 'Contracts') {
                vipReb.Phoenix_Contracts_Approval__c = financeAppStatus;
                vipReb.Phoenix_Contracts_Approval_Comments__c = finaceCom;
                update vipReb;
            } else {
                //
            }
            
            
            for (Phoenix_Bid_Process_Steps__c step: nextSteps) {
                step.Phoenix_Status__c = 'In Process'; //'In Process' Submitted //Diff b/w them            
            }
            if (!nextSteps.isEmpty()) {
                update nextSteps;
            }
            bidCurrent.Phoenix_Approval_Status__c = 'Customer Pending';
            update bidCurrent;
            Phoenix_SubmitBidForApprovalCtrl.approvalRequestNotification(bidId,nextsteps);
        } else if (financeAppStatus == 'Line Error - Not Sent') {
            
            if (currentStep != null) {
                currentStep.Phoenix_Status__c = 'Completed';
                currentStep.Phoenix_Approver__c = userinfo.getuserid();
                currentStep.Phoenix_Description__c = finaceCom;
                update currentStep;
            }
            
            for (Phoenix_Bid_Process_Steps__c step: nextSteps) {
                step.Phoenix_Status__c = 'Not Applicable'; //'In Process' Submitted //Diff b/w them            
            }
            for (Phoenix_Bid_Process_Steps__c step: nextSteps2) {
                step.Phoenix_Status__c = 'Not Applicable'; //'In Process' Submitted //Diff b/w them            
            }
            for (Phoenix_Bid_Process_Steps__c step: nextSteps3) {
                step.Phoenix_Status__c = 'Not Applicable'; //'In Process' Submitted //Diff b/w them            
            }
            if (!nextSteps.isEmpty()) {
                update nextSteps;
            }
            if (!nextSteps2.isEmpty()) {
                update nextSteps2;
            }
            if (!nextSteps3.isEmpty()) {
                update nextSteps3;
            }
            
            bidCurrent.Phoenix_Approval_Status__c = 'Contracts Rejected';//'Closed';
            update bidCurrent;
            
        } else {
        }
        
        
        
    }
    @AuraEnabled
    public static void makeApprovalsCustomer(String bidId, String finaceCom, string financeAppStatus, string approvStatus) {
        Phoenix_Bid_Process_Steps__c currentStep = [SELECT Id, Name, Phoenix_Bid__c,Phoenix_Is_Criteria_Step__c,Phoenix_Process_Step__c, Phoenix_Step__c, Phoenix_Approver__c, Phoenix_Process_Step__r.Name, Phoenix_Status__c, Phoenix_Approver_Team__c, Phoenix_Approver_Team_Members__c,Phoenix_Approver__r.Email FROM Phoenix_Bid_Process_Steps__c
                                                    where Phoenix_Bid__c =: bidId AND Phoenix_Status__c = 'In Process'
                                                    LIMIT 1
                                                   ];
        List < Phoenix_Bid_Process_Steps__c > updateProcessStep = [SELECT Id, Name, Phoenix_Bid__c,Phoenix_Is_Criteria_Step__c,Phoenix_Process_Step__c, Phoenix_Step__c, Phoenix_Approver__c, Phoenix_Process_Step__r.Name, Phoenix_Status__c, Phoenix_Approver_Team__c, Phoenix_Approver_Team_Members__c, Phoenix_Approver__r.Email FROM Phoenix_Bid_Process_Steps__c where Phoenix_Bid__c =: bidId];
        Map < Integer, List < Phoenix_Bid_Process_Steps__c >> stepMap = new Map < Integer, List < Phoenix_Bid_Process_Steps__c >> ();
        Map < String, List < Phoenix_Bid_Process_Steps__c >> stepNamesMap = new Map < String, List < Phoenix_Bid_Process_Steps__c >> ();
        Map < String, Integer > stepnameNoMap = new Map < String, Integer > ();
        for (Phoenix_Bid_Process_Steps__c step: updateProcessStep) {
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
        List < Phoenix_Bid_Process_Steps__c > nextSteps = !Test.isRunningTest() ? stepMap.get(6) : new List < Phoenix_Bid_Process_Steps__c > ();
        List < Phoenix_Bid_Process_Steps__c > nextSteps2 = !Test.isRunningTest() ? stepMap.get(7) : new List < Phoenix_Bid_Process_Steps__c > ();
        Phoenix_Bid__c bidCurrent = [select id, Phoenix_Approval_Status__c from Phoenix_Bid__c where id =: bidId];
        
        
        if (financeAppStatus == 'Customer Accepted') {
            if (currentStep != null) {
                currentStep.Phoenix_Status__c = 'Completed';
                currentStep.Phoenix_Approver__c = userinfo.getuserid();
                currentStep.Phoenix_Description__c = finaceCom;
                update currentStep;
            }
            
            for (Phoenix_Bid_Process_Steps__c step: nextSteps) {
                step.Phoenix_Status__c = 'In Process'; //'In Process' Submitted //Diff b/w them            
            }
            if (!nextSteps.isEmpty()) {
                update nextSteps;
            }
            bidCurrent.Phoenix_Approval_Status__c = 'Vistex Update';
            update bidCurrent;
            Phoenix_SubmitBidForApprovalCtrl.approvalRequestNotification(bidId,nextsteps);
        } else if (financeAppStatus == 'Customer Not Accepted') {
            
            if (currentStep != null) {
                currentStep.Phoenix_Status__c = 'Completed';
                currentStep.Phoenix_Approver__c = userinfo.getuserid();
                currentStep.Phoenix_Description__c = finaceCom;
                update currentStep;
            }
            for (Phoenix_Bid_Process_Steps__c step: nextSteps) {
                step.Phoenix_Status__c = 'Not Applicable'; //'In Process' Submitted //Diff b/w them            
            }
            for (Phoenix_Bid_Process_Steps__c step: nextSteps2) {
                step.Phoenix_Status__c = 'Not Applicable'; //'In Process' Submitted //Diff b/w them            
            }
            if (!nextSteps.isEmpty()) {
                update nextSteps;
            }
            if (!nextSteps2.isEmpty()) {
                update nextSteps2;
            }
            bidCurrent.Phoenix_Approval_Status__c = 'Customer Rejected';//Closed';
            update bidCurrent;
            
        } else {
        }
        
        
        
    }
    @AuraEnabled
    public static void makeApprovalsVistex(String bidId, String finaceCom, string financeAppStatus, string approvStatus) {
        Phoenix_Bid_Process_Steps__c currentStep = [SELECT Id, Name, Phoenix_Bid__c, Phoenix_Process_Step__c, Phoenix_Step__c, 
                                                    Phoenix_Approver__c, Phoenix_Status__c, Phoenix_Approver_Team__c, 
                                                    Phoenix_Approver__r.Email 
                                                    FROM Phoenix_Bid_Process_Steps__c
                                                    where Phoenix_Bid__c =: bidId 
                                                    AND Phoenix_Status__c = 'In Process'
                                                    LIMIT 1
                                                   ];
        List < Phoenix_Bid_Process_Steps__c > updateProcessStep = [SELECT Id, Name, Phoenix_Bid__c, Phoenix_Process_Step__c, 
                                                                   Phoenix_Step__c, Phoenix_Approver__c, Phoenix_Status__c, 
                                                                   Phoenix_Approver_Team__c, Phoenix_Approver__r.Email 
                                                                   FROM Phoenix_Bid_Process_Steps__c 
                                                                   where Phoenix_Bid__c =: bidId];
        Map < Integer, List < Phoenix_Bid_Process_Steps__c >> stepMap = new Map < Integer, List < Phoenix_Bid_Process_Steps__c >> ();
        Map < String, List < Phoenix_Bid_Process_Steps__c >> stepNamesMap = new Map < String, List < Phoenix_Bid_Process_Steps__c >> ();
        Map < String, Integer > stepnameNoMap = new Map < String, Integer > ();
        for (Phoenix_Bid_Process_Steps__c step: updateProcessStep) {
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
        List < Phoenix_Bid_Process_Steps__c > nextSteps = !Test.isRunningTest() ? stepMap.get(stepnameNoMap.get('Home Office') + 1) : new List < Phoenix_Bid_Process_Steps__c > ();
        Phoenix_Bid__c bidCurrent = [select id, Phoenix_Approval_Status__c from Phoenix_Bid__c where id =: bidId];
        
        if (financeAppStatus == 'Processed') {
            if (currentStep != null) {
                currentStep.Phoenix_Status__c = 'Completed';
                currentStep.Phoenix_Approver__c = userinfo.getuserid();
                currentStep.Phoenix_Description__c = finaceCom;
                update currentStep;
            }
            
            for (Phoenix_Bid_Process_Steps__c step: nextSteps) {
                step.Phoenix_Status__c = 'Completed'; //'In Process' Submitted //Diff b/w them            
            }
            if (!nextSteps.isEmpty()) {
                update nextSteps;
            }
            bidCurrent.Phoenix_Approval_Status__c = 'Closed';
            update bidCurrent;
        } else if (financeAppStatus == 'Not Processed') {
            
            if (currentStep != null) {
                currentStep.Phoenix_Status__c = 'Completed';
                currentStep.Phoenix_Approver__c = userinfo.getuserid();
                currentStep.Phoenix_Description__c = finaceCom;
                update currentStep;
            }
            
            for (Phoenix_Bid_Process_Steps__c step: nextSteps) {
                step.Phoenix_Status__c = 'Not Applicable'; //'In Process' Submitted //Diff b/w them            
            }
            if (!nextSteps.isEmpty()) {
                update nextSteps;
            }
            bidCurrent.Phoenix_Approval_Status__c = 'Vistex Update Rejected';//Closed';
            update bidCurrent;
        } else {}
    }
    
    @AuraEnabled
    public static void deleteAttachments(String LineItemId, String bidId) {
        List < ContentDocument > contentDocumentIds = [select Id from ContentDocument WHERE Id =: LineItemId];
        delete contentDocumentIds;
    }
    @AuraEnabled
    public static void deleteRebate(String bidId, Phoenix_VIP_Rebate_Line__c LineItemId) {
        delete LineItemId;
    }
    @AuraEnabled
    public static void saveToBidBus(string bidId, String busStatus, String busCom) {
        Phoenix_Bid__c rebatePro = [select Id, Phoenix_Business_Approval__c, Phoenix_Business_Approval_Comments__c FROM Phoenix_Bid__c WHERE Id =: bidId];
        rebatePro.Phoenix_Business_Approval__c = busStatus;
        rebatePro.Phoenix_Business_Approval_Comments__c = busCom;
        update rebatePro;
    }
    @AuraEnabled
    public static void saveToBidFin(string bidId, String finStatus, String finCom) {
        Phoenix_Bid__c rebatePro = [select Id, Phoenix_Finance_Approval__c, Phoenix_Finance_Approval_Comments__c FROM Phoenix_Bid__c WHERE Id =: bidId];
        rebatePro.Phoenix_Finance_Approval__c = finStatus;
        rebatePro.Phoenix_Finance_Approval_Comments__c = finCom;
        update rebatePro;
    }
    @AuraEnabled
    public static void saveToBidContr(string bidId, String contrStatus, String contrCom) {
        Phoenix_Bid__c rebatePro = [select Id, Phoenix_Contracts_Approval__c, Phoenix_Contracts_Approval_Comments__c FROM Phoenix_Bid__c WHERE Id =: bidId];
        rebatePro.Phoenix_Contracts_Approval__c = contrStatus;
        rebatePro.Phoenix_Contracts_Approval_Comments__c = contrCom;
        update rebatePro;
    }
    @AuraEnabled
    public static void saveToBidCust(string bidId, String custStatus, String custCom) {
        Phoenix_Bid__c rebatePro = [select Id, Phoenix_Customer_Approval__c, Phoenix_Customer_Approval_Comments__c FROM Phoenix_Bid__c WHERE Id =: bidId];
        rebatePro.Phoenix_Customer_Approval__c = custStatus;
        rebatePro.Phoenix_Customer_Approval_Comments__c = custCom;
        update rebatePro;
    }
    @AuraEnabled
    public static void saveToBidVist(string bidId, String vistStatus, String vistCom, String recordId, String agreementNo) {
        Phoenix_Bid__c rebatePro = [select Id, Phoenix_Vistex_Update__c, Phoenix_Vistex_Update_Comments__c FROM Phoenix_Bid__c WHERE Id =: bidId];
        rebatePro.Phoenix_Vistex_Update__c = vistStatus;
        rebatePro.Phoenix_Vistex_Update_Comments__c = vistCom;
        update rebatePro;
        system.debug('recordId: '+recordId);
        if(recordId != null){
         	Phoenix_Bid_VIP_Rebate__c vipRebate = [Select Id FROM Phoenix_Bid_VIP_Rebate__c WHERE Id =: recordId];
            vipRebate.Vistex_Agreement__c = agreementNo;
            update vipRebate;
        }
    }
    
    /** Added by Srimayee**/
    @AuraEnabled
    public static VIPRebateWrapper getCustomerVIPRebate(string customerId) {
        VIPRebateWrapper wrapper = new VIPRebateWrapper();
        List<Phoenix_Bid_VIP_Rebate__c> vipRebateList =new List<Phoenix_Bid_VIP_Rebate__c>();
        List<Phoenix_VIP_Rebate_Line__c> vipRebateLines = new List<Phoenix_VIP_Rebate_Line__c>();
        if(customerId != null){
            vipRebateList  = [SELECT Id, Name, Phoenix_Bid__c, Phoenix_Start_Date__c, Phoenix_End_Date__c, Phoenix_Exclusions__c, Net_Contract__c, Payment_Frequency__c, Rx_SRx_OTC__c, Phoenix_Exclusion_details__c, Phoenix_Type__c, Phoenix_Status__c, Phoenix_Tier__c, Phoenix_Dollar_Volume_From__c, Phoenix_Dollar_Volume_To__c, Phoenix_Unit_Volume_From__c, Phoenix_Unit_Volume_To__c, Phoenix_Discount_Rebate__c, Phoenix_Remarks__c, Phoenix_Rebate_Identifier__c, Phoenix_Finance_Approval__c, Phoenix_Contracts_Approval__c, Phoenix_Customer_Approval__c, Phoenix_Vistex_Update__c, Phoenix_Finance_Approval_Comments__c, Phoenix_Contracts_Approval_Comments__c, Phoenix_Customer_Approval_Comments__c, Phoenix_Vistex_Update_Comments__c, Phoenix_Customer__c, Phoenix_Business_Approval__c, Phoenix_Business_Approval_Comments__c
                              FROM Phoenix_Bid_VIP_Rebate__c 
                              WHERE Phoenix_Customer__c =: customerId 
                              AND Phoenix_Status__c= 'Current' 
                              LIMIT 1];
            if(vipRebateList != null && vipRebateList.size()>0 ){
                vipRebateLines = [SELECT Id, Name, Phoenix_VIP_Rebate__c, Phoenix_Tier__c, Phoenix_Dollar_Value_From__c, Phoenix_Dollar_Value_To__c, Phoenix_Unit_Volume_From__c, Phoenix_Unit_Volume_To__c, Phoenix_Discount_Rebate__c, Phoenix_Remarks__c
                                  FROM Phoenix_VIP_Rebate_Line__c 
                                  WHERE Phoenix_VIP_Rebate__c =: vipRebateList[0].Id ];
            }
        }
        wrapper.vipRebateList =(vipRebateList != null && vipRebateList.size()>0)? vipRebateList[0]:null;
        wrapper.vipRebateLines =vipRebateLines;
        return wrapper;
        
    }
    @AuraEnabled
    public static VIPRebateWrapper getCustomerVIPRebateByType(string selectedType, string bidId, string customerId) {
        VIPRebateWrapper wrapper = new VIPRebateWrapper();
        List<Phoenix_Bid_VIP_Rebate__c> vipRebateList =new List<Phoenix_Bid_VIP_Rebate__c>();
        List<Phoenix_VIP_Rebate_Line__c> vipRebateLines = new List<Phoenix_VIP_Rebate_Line__c>();
        if(customerId != null){
            vipRebateList  = [SELECT Id, Name, Phoenix_Bid__c, Phoenix_Start_Date__c, Phoenix_End_Date__c, 
                              Phoenix_Exclusions__c, Phoenix_Exclusion_details__c, Phoenix_Type__c, Net_Contract__c, Payment_Frequency__c, Rx_SRx_OTC__c, 
                              Phoenix_Status__c, Phoenix_Tier__c, Phoenix_Dollar_Volume_From__c, 
                              Phoenix_Dollar_Volume_To__c, Phoenix_Unit_Volume_From__c, Phoenix_Unit_Volume_To__c,
                              Phoenix_Discount_Rebate__c, Phoenix_Remarks__c, Phoenix_Rebate_Identifier__c,
                              Phoenix_Finance_Approval__c, Phoenix_Contracts_Approval__c, Phoenix_Customer_Approval__c,
                              Phoenix_Vistex_Update__c, Phoenix_Finance_Approval_Comments__c, Phoenix_Contracts_Approval_Comments__c,
                              Phoenix_Customer_Approval_Comments__c, Phoenix_Vistex_Update_Comments__c, Phoenix_Customer__c,
                              Phoenix_Business_Approval__c, Phoenix_Business_Approval_Comments__c
                              FROM Phoenix_Bid_VIP_Rebate__c 
                              WHERE Phoenix_Customer__c =: customerId 
                              AND Phoenix_Status__c = 'Current' 
                              AND Phoenix_Type__c =: selectedType 
                              LIMIT 1];
            if(vipRebateList != null && vipRebateList.size()>0 ){
                vipRebateLines = [SELECT Id, Name, Phoenix_VIP_Rebate__c, Phoenix_Tier__c, Phoenix_Dollar_Value_From__c, Phoenix_Dollar_Value_To__c, Phoenix_Unit_Volume_From__c, Phoenix_Unit_Volume_To__c, Phoenix_Discount_Rebate__c, Phoenix_Remarks__c
                                  FROM Phoenix_VIP_Rebate_Line__c 
                                  WHERE Phoenix_VIP_Rebate__c =: vipRebateList[0].Id ];
            }
        }
        wrapper.vipRebateList =(vipRebateList != null && vipRebateList.size()>0)? vipRebateList[0]:null;
        if(vipRebateLines.size()>0){
            vipRebateLines = sortLineItems(vipRebateLines);
        }
        wrapper.vipRebateLines = vipRebateLines;
        return wrapper;
        
    }
    public class VIPRebateWrapper{
        @AuraEnabled public Phoenix_Bid_VIP_Rebate__c vipRebateList;
        @AuraEnabled public List<Phoenix_VIP_Rebate_Line__c> vipRebateLines;
        VIPRebateWrapper(){
            vipRebateList = new Phoenix_Bid_VIP_Rebate__c();
            vipRebateLines = new List<Phoenix_VIP_Rebate_Line__c>();
        }
    }
    @AuraEnabled   
    public static list < Phoenix_VIP_Rebate_Line__c > saveLineItemsAddCustomer(List < Phoenix_VIP_Rebate_Line__c > LineItemList, Id recId, String excsnDetails, Date stDate, Date endDate, Boolean exclusions, String rebType, String customerId) {
        string rebateType = rebType;  
        list < Phoenix_VIP_Rebate_Line__c > rbListInsert = new list < Phoenix_VIP_Rebate_Line__c > ();
        Phoenix_VIP_Rebate_Line__c newReb = new Phoenix_VIP_Rebate_Line__c();   
        Phoenix_Bid_VIP_Rebate__c newRebate = new Phoenix_Bid_VIP_Rebate__c();
        newRebate.Phoenix_Bid__c = recId;
        newRebate.Phoenix_Customer__c = customerId;
        newRebate.Phoenix_End_Date__c = endDate;
        newRebate.Phoenix_Start_Date__c = stDate;
        
        newRebate.Phoenix_Exclusions__c = exclusions;
        newRebate.Phoenix_Exclusion_details__c = excsnDetails;
        newRebate.Phoenix_Type__c = rebType;
        newRebate.Phoenix_Status__c = 'Proposed';
        insert newRebate;
        
        Phoenix_Bid_VIP_Rebate__c vipRebate = [SELECT ID, Name from Phoenix_Bid_VIP_Rebate__c WHERE Id =: newRebate.Id];
        return LineItemList;
    }
    
    @auraEnabled
    public static String deleteProposedRebate(String bidId, String customerId){
        try{
            Phoenix_Bid_VIP_Rebate__c vipRebate = [SELECT Id 
                                                   FROM Phoenix_Bid_VIP_Rebate__c 
                                                   WHERE Phoenix_Bid__c =: bidId
                                                   AND Phoenix_Customer__c =: customerId];
            delete vipRebate;
            return 'Success : Vip Rebate has been deleted Successfully.';
        }
        catch(Exception e){
            return 'ERROR : Unable to Delete the Rebate. Excetion : '+e.getMessage();
        }
    }
    
}