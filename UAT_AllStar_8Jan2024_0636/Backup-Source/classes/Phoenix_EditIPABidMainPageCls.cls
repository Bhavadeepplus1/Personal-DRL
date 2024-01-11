/**
* @description       : 
* @author            : Surender Patel (Dhruvsoft)
* @group             : 
* @last modified on  : 20-07-2021
* @last modified by  : Surender Patel (Dhruvsoft)
* Modifications Log 
* Ver   Date         Author                       Modification
* 1.0   25-05-2021   Surender Patel (Dhruvsoft)   Initial Version
**/
public class Phoenix_EditIPABidMainPageCls {
    
    
    @AuraEnabled
    public static Wrapper getRelatedList(Id bidId) {
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
        query = 'select Phoenix_Contract__r.Name,Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_Contracts_Approver__r.Name,Phoenix_Contract__r.Id,Phoenix_Customer__r.Name,Phoenix_Customer__r.Id, Phoenix_Product__r.Name,Phoenix_Bid__r.Phoenix_Bid_Name__c, ' + strFields + ' from ' + SobjectApiName + ' where Phoenix_Bid__c = : bidId and Phoenix_Product__r.Phoenix_Is_IPA_Product__c=true and Phoenix_Final_Status__c !=: notApproved ORDER BY Phoenix_Product__r.Name ASC ';
        
        list < Phoenix_Bid_Line_Item__c > quoteList = Database.query(query);
        system.debug('quoteList--->' + quoteList);
        
        boolean showProceedBtn = true;
        boolean showProceedContrBtn = true;
        boolean conditionApproval = false;
        for (Phoenix_Bid_Line_Item__c lineItem: quoteList) {
            
            
            
            if (lineItem.Phoenix_Product_Director1__c != null && lineItem.Phoenix_Marketing_Final_Approval__c != null && lineItem.Phoenix_Marketing_Final_Approval__c == true && lineItem.Phoenix_Product_Director1__c == userinfo.getName()) {
                system.debug('In mARKETING APProval');
                showProceedBtn = false;
            }
            
            
            if (lineItem.Phoenix_Proposed_IPA_Price__c > 0 && (lineItem.Phoenix_Proposed_IPA_Price__c < lineItem.Phoenix_IPA_Floor_Price1__c || lineItem.Phoenix_IPA_Floor_Price1__c == null )) {
                conditionApproval = true;
            }
        }
        
        Map < String, String > userTeamUserIdMap = new Map < String, String > ();
        for (Phoenix_User_Approval_Matrix__c matrix: [Select Id, Name, RecordType.DeveloperName, User_Group__r.Phoenix_Approver_Group_Name__c, Phoenix_Approval_Group_Behavior__c, Phoenix_Approver__c, Phoenix_Approver__r.Email, Phoenix_Approver_Group_Name__c, Phoenix_Is_Active_User__c, Phoenix_Is_Approval_Process_User__c, User_Group__c from Phoenix_User_Approval_Matrix__c limit 1000]) {
            String userTeamUserIdMapKey = matrix.User_Group__r.Phoenix_Approver_Group_Name__c + '-' + matrix.Phoenix_Approver__c;
            userTeamUserIdMap.put(userTeamUserIdMapKey, matrix.Phoenix_Approver__c);
        }
        
        boolean isFinanceApprovePerson = false;
        string isMarketingApprovePerson;
        boolean isSRxApprovePerson = false;
        boolean isVistexApprovePerson = false;
        
        
        if (userTeamUserIdMap.containsKey('Finance-' + UserInfo.getUserId())) {
            isFinanceApprovePerson = true;
        }
        if (userTeamUserIdMap.containsKey('SRx IPA Contracts Approver-' + UserInfo.getUserId())) {
            isSRxApprovePerson = true;
        }
        
        if (userTeamUserIdMap.containsKey('Home Office-' + UserInfo.getUserId())) {
            isVistexApprovePerson = true;
        }
        
        
        
        if (userTeamUserIdMap.containsKey('Marketing-' + UserInfo.getUserId())) {
            isMarketingApprovePerson = userTeamUserIdMap.get(('Marketing-' + UserInfo.getUserId()));
        }
        //boolean showProceedBtn=true; 
        
        
        
        Phoenix_Bid__c bid = [SELECT Id, Phoenix_Contracts_Approval_Comments__c, Phoenix_Contracts_Approval__c, Phoenix_Customer__r.Phoenix_Contracts_Approver__r.Name, Name, Phoenix_Approval_Status__c, Phoenix_Customer__r.Name, Phoenix_Bid_Name__c, Phoenix_Bid_Type__c FROM Phoenix_Bid__c WHERE Id =: bidId];
        
        wrapperObject.lineItemsList = quoteList;
        wrapperObject.bidRecord = bid;
        wrapperObject.loggedInUserName = UserInfo.getName();
        wrapperObject.loggedInUserId = UserInfo.getUserId();
        wrapperObject.conditionApproval = conditionApproval;
        wrapperObject.isFinanceApprovePerson = isFinanceApprovePerson;
        wrapperObject.isMarketingApprovePerson = isMarketingApprovePerson;
        wrapperObject.isVistexApprovePerson = isVistexApprovePerson;
        wrapperObject.isSRxApprovePerson = isSRxApprovePerson;
        
        wrapperObject.showProceedBtn = showProceedBtn;
        
        system.debug(';loggedInUserName' + wrapperObject.loggedInUserName);
        return wrapperObject;
        
    }
    @AuraEnabled
    public static Phoenix_Bid__c saveTobid(string bidId, string comments, string status) {
        Phoenix_Bid__c bidRecord = new Phoenix_Bid__c(Id = bidId, Phoenix_Contracts_Approval__c = status, Phoenix_Contracts_Approval_Comments__c = comments);
        update bidRecord;
        return bidRecord;
    }
    
    @AuraEnabled
    public static list < Phoenix_Bid_Line_Item__c > submitToProceddStep1(string bidId, boolean isMarketing, boolean isFinance, boolean isContracts) {
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
        string loggerUserName = UserInfo.getName();
        query = 'select Phoenix_Product__r.Phoenix_Rx_SRx_OTC__c,Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_Contracts_Approver__r.Name, Phoenix_Product__r.name,Phoenix_Bid__r.Phoenix_Bid_Name__c, ' + strFields + ' from ' + SobjectApiName + ' where Phoenix_Bid__c = : bidId AND Phoenix_Final_Status__c !=: notApproved';
        if (isMarketing == true) {
            query += ' and Phoenix_Product_Director1__c=:loggerUserName';
        }
        list < Phoenix_Bid_Line_Item__c > bidLinesList = Database.query(query);
        return bidLinesList;
        
    }
    @AuraEnabled
    public static WrapperForNextSteps makeApprovals(String bidId, List < Phoenix_Bid_Line_Item__c > bidlines, boolean approveStatusFlag) {
        for (Phoenix_Bid_Line_Item__c line: bidlines) {
            line.Phoenix_Marketing_Final_Approval__c = true;
            if (line.Phoenix_Marketing_Approval__c == 'Not Approved') {
                line.Phoenix_Final_Status__c = 'Not Approved';
            }
        }
        if (bidlines.size() > 0) {
            update bidlines;
        }
        
        list < Phoenix_Bid_Process_Steps__c > bidProcessStepList = [SELECT Id, Name, Phoenix_Bid__c,Phoenix_Approver__r.Email, Phoenix_Is_Criteria_Step__c, Phoenix_Process_Step__c, Phoenix_Step__c, Phoenix_Approver__c, Phoenix_Status__c, Phoenix_Approver_Team__c FROM Phoenix_Bid_Process_Steps__c where Phoenix_Bid__c =: bidId order by Phoenix_Step__c];
        list < Phoenix_Bid_Line_Item__c > bidLinesUpdate = [select id,Phoenix_Marketing_Final_Approval__c,Phoenix_Contracts_Final_Approval__c,Phoenix_Customer_Final_Approval__c,Phoenix_Final_Status__c from Phoenix_Bid_Line_Item__c where Phoenix_Bid__c =: bidId];
        WrapperForNextSteps wrapSteps = new WrapperForNextSteps();
        boolean isAllRejectedCaseFound = true;
        boolean isMarketingCompleted = true;
        for (Phoenix_Bid_Line_Item__c lineItem: bidLinesUpdate) {
            if (lineItem.Phoenix_Final_Status__c != 'Not Approved') {
                isAllRejectedCaseFound = false;
            }
            if(!lineItem.Phoenix_Marketing_Final_Approval__c && lineItem.Phoenix_Final_Status__c != 'Not Approved')
                isMarketingCompleted = false;
        }
        Phoenix_Bid__c bidRec = new Phoenix_Bid__c(id = bidId, Phoenix_Bid_Marketing_Approved_Date__c = system.today()); //Closed
        if(bidRec != null && (isMarketingCompleted || isAllRejectedCaseFound))
        	update bidRec;
        
        if (isAllRejectedCaseFound) {
            
            integer currentStepNum; 
            
            
            for (Phoenix_Bid_Process_Steps__c prcsStep: bidProcessStepList) {
                if (prcsStep.Phoenix_Approver_Team__c == 'Marketing') {
                    currentStepNum = integer.valueOf(prcsStep.Phoenix_Step__c);
                }
            }
            for (Phoenix_Bid_Process_Steps__c prcsStep: bidProcessStepList) {
                if (prcsStep.Phoenix_Approver_Team__c == 'Marketing' && prcsStep.Phoenix_Approver__c == Userinfo.getUserId()) {
                    
                    prcsStep.Phoenix_Status__c = 'Completed';
                    
                }
                if (prcsStep.Phoenix_Step__c > currentStepNum) {
                    if (prcsStep.Name.contains('Closed')) {
                        prcsStep.Phoenix_Status__c = 'Completed';
                    } 
                    else {
                        prcsStep.Phoenix_Status__c = 'Not Applicable';
                    }
                }
            }
            update bidProcessStepList;
            Phoenix_Bid__c bid = new Phoenix_Bid__c(id = bidId, Phoenix_Approval_Status__c = 'Marketing Rejected');
            update bid;
            
            
            
            wrapSteps.updateProcessStepList = bidProcessStepList;
            wrapSteps.flagMarketStop = true;
            
            
            
            
            
            
        }
        else{
            list < Phoenix_Bid_Process_Steps__c > marketStepLsit = new list < Phoenix_Bid_Process_Steps__c > ();
            
            boolean flagMarketStop = false;
            for (Phoenix_Bid_Process_Steps__c step: bidProcessStepList) {
                if (step.Phoenix_Approver_Team__c == 'Marketing' && step.Phoenix_Approver__c == Userinfo.getUserId()) {
                    step.Phoenix_Status__c = 'Completed'; //approveStatusFlag==true?'Completed':'Do Not Bid';
                    // step.Phoenix_Status__c=approveStatusFlag==true?'Completed':'';
                    marketStepLsit.add(step);
                }
                //if(step.Phoenix_Approver_Team__c=='Supply Chain' && step.Phoenix_Status__c!='Completed'){
                // flagSCMStop=true;
                //}
                
                if (step.Phoenix_Approver_Team__c == 'Marketing' && step.Phoenix_Status__c != 'Completed') {
                    if (step.Phoenix_Status__c != 'Not Applicable') {
                        flagMarketStop = true;
                    }
                }
            }
            //   WrapperForNextSteps wrapSteps = new WrapperForNextSteps();
            if (!marketStepLsit.isEmpty()) {
                update marketStepLsit;
                wrapSteps.updateProcessStepList = bidProcessStepList;
                
                wrapSteps.flagMarketStop = flagMarketStop;
            }
        }
        
        return wrapSteps;
    }
    public class WrapperForNextSteps {
        @AuraEnabled public list < Phoenix_Bid_Process_Steps__c > updateProcessStepList;
        
        @AuraEnabled public boolean flagMarketStop;
        @AuraEnabled public boolean contractNextStepFlag;
        
        WrapperForNextSteps() {
            updateProcessStepList = new List < Phoenix_Bid_Process_Steps__c > ();
            contractNextStepFlag = false;
            flagMarketStop = false;
        }
    }
    @AuraEnabled
    public static void updateNextMarketingProcessSteps(string bidId, string bidName, list < Phoenix_Bid_Process_Steps__c > processStepLsit, boolean flagMarketStop) {
        system.debug('In Marketing');
        if (flagMarketStop == false && !processStepLsit.isEmpty()) {
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
            query = 'select Phoenix_Contract__r.Name,Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_Contracts_Approver__r.Name,Phoenix_Contract__r.Id,Phoenix_Customer__r.Name,Phoenix_Customer__r.Id, Phoenix_Product__r.Name,Phoenix_Bid__r.Phoenix_Bid_Name__c, ' + strFields + ' from ' + SobjectApiName + ' where Phoenix_Bid__c = : bidId and Phoenix_Product__r.Phoenix_Is_IPA_Product__c=true and Phoenix_Final_Status__c !=: notApproved ORDER BY Phoenix_Product__r.Name ASC ';
            
            list < Phoenix_Bid_Line_Item__c > quoteList = Database.query(query);
            boolean conditionalApproval=false;
            for(Phoenix_Bid_Line_Item__c lineItem:quoteList){
                if (lineItem.Phoenix_Proposed_IPA_Price__c > 0 && lineItem.Phoenix_Proposed_IPA_Price__c < lineItem.Phoenix_IPA_Floor_Price1__c) {
                    conditionalApproval = true;
                }
            }
            
            
            
            system.debug('stepnamemap--' + stepnameNoMap.get('Marketing') + 1);
            system.debug('stepnamemap--' + stepMap.get(4));
            List < Phoenix_Bid_Process_Steps__c > nextSteps = new list < Phoenix_Bid_Process_Steps__c > ();
            List < Phoenix_Bid_Process_Steps__c > nextStepscopy = new list < Phoenix_Bid_Process_Steps__c > ();
            Integer stepNo;
            
            
            
            if (conditionalApproval == true) {
                stepNo = stepnameNoMap.get('Marketing') + 1;
                nextSteps = stepMap.get(stepNo);
            } else {
                stepNo = stepnameNoMap.get('Marketing') + 2;
                system.debug('stepNo' + stepNo);
                system.debug('stepMap' + stepMap);
                
                nextSteps = stepMap.get(stepNo);
                stepNo = stepnameNoMap.get('Marketing') + 1;
                nextStepscopy = stepMap.get(stepNo);
                for (Phoenix_Bid_Process_Steps__c bstep: nextStepscopy) {
                    nextSteps.add(bstep);
                }
            }
            
            
            for (Phoenix_Bid_Process_Steps__c step: nextSteps) {
                if (step.Name.contains('Closed')) {
                    step.Phoenix_Status__c = 'Completed';
                } else if (conditionalApproval == false && step.Name.contains('Finance')) {
                    step.Phoenix_Status__c = 'Not Applicable';
                } else {
                    step.Phoenix_Status__c = 'In Process';
                } //'In Process' Submitted //Diff b/w them            
            }
            if (!nextSteps.isEmpty()) {
                update nextSteps;
                if(conditionalApproval==true){
                    Phoenix_Bid__c bid = new Phoenix_Bid__c(id = bidId, Phoenix_Approval_Status__c = nextSteps[0].Phoenix_Approver_Team__c);
                    update bid;
                    
                }
                else{
                    Phoenix_Bid__c bid = new Phoenix_Bid__c(id = bidId, Phoenix_Approval_Status__c = 'Contracts');
                    update bid;   
                }
                Phoenix_SubmitBidForApprovalCtrl.approvalRequestNotification(bidId , nextSteps);


                
                //Phoenix_SubmitBidForApprovalCtrl.sendForApproval(bidId,'Approval Required for '+bidName,nextSteps,'Bid_Approval');
            } else {
                Phoenix_Bid__c bid = new Phoenix_Bid__c(id = bidId, Phoenix_Approval_Status__c = 'Closed');
                update bid;
            }
            
        }
    }
    @AuraEnabled
    public static list < Phoenix_Bid_Process_Steps__c > makeApprovalsContracts(String bidId, List < Phoenix_Bid_Line_Item__c > bidlines, boolean approveStatusFlag, boolean isContracts, boolean isFinance) {
       
        for (Phoenix_Bid_Line_Item__c line: bidlines) {
            if (isContracts) {
                line.Phoenix_Contracts_Final_Approval__c = true;
                if (line.Phoenix_Contract_Approval__c == 'Line Error- Not Sent') {
                    line.Phoenix_Final_Status__c = 'Not Approved';
                }
            }
            
            
            if (isFinance) {
                line.Phoenix_Final_Finance_Approval__c = true;
                if (line.Phoenix_Finance_Approval__c == 'Not Approved') {
                    line.Phoenix_Final_Status__c = 'Not Approved';
                }
            }
        }
        if (bidlines.size() > 0) {
            update bidlines;
        }
        list < Phoenix_Bid_Process_Steps__c > bidProcessStepList = [SELECT Id, Name, Phoenix_Is_Criteria_Step__c,Phoenix_Bid__c, Phoenix_Process_Step__c,Phoenix_Step__c, Phoenix_Approver__r.Name, Phoenix_Approver__r.Email, Phoenix_Approver__c, Phoenix_Status__c, Phoenix_Approver_Team__c FROM Phoenix_Bid_Process_Steps__c where Phoenix_Bid__c =: bidId];
        list < Phoenix_Bid_Process_Steps__c > contractsStepLsit = new list < Phoenix_Bid_Process_Steps__c > ();
        System.debug('approveStatusFlag-->'+approveStatusFlag);
        for (Phoenix_Bid_Process_Steps__c step: bidProcessStepList) {
            System.debug('approver team-->'+step.Phoenix_Approver_Team__c);
            if (step.Phoenix_Approver_Team__c == 'SRx IPA Contracts Approver' && isContracts) {
                step.Phoenix_Status__c = approveStatusFlag == true ? 'Completed' : 'Completed';
                //Do Not Bid
                step.Phoenix_Approver__c=UserInfo.getUserId();
                contractsStepLsit.add(step);
               System.debug('step-->'+step); 
               System.debug('contractsStepLsit-->'+contractsStepLsit);

            }
            if (step.Phoenix_Approver_Team__c == 'Finance' && isFinance) {
                step.Phoenix_Status__c = approveStatusFlag == true ? 'Completed' : 'Completed';
                  step.Phoenix_Approver__c=UserInfo.getUserId();
                contractsStepLsit.add(step);
            }
        }
        if (!contractsStepLsit.isEmpty()) {
            update contractsStepLsit;
        }
       System.debug('updated contractsStepLsit-->'+contractsStepLsit.size());
		System.debug('bidProcessStepList-->'+bidProcessStepList);
        return bidProcessStepList;
    }
    @AuraEnabled
    public static void updateNextFinanceProcessSteps(string bidId, string bidName, list < Phoenix_Bid_Process_Steps__c > processStepLsit) {
        system.debug('In Finance');
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
        list < Phoenix_Bid_Line_Item__c > bidLinesUpdate = [select id,Phoenix_Contracts_Final_Approval__c,Phoenix_Customer_Final_Approval__c,Phoenix_Final_Status__c from Phoenix_Bid_Line_Item__c where Phoenix_Bid__c =: bidId];
        
        boolean isAllRejectedCaseFound = true;
        for (Phoenix_Bid_Line_Item__c lineItem: bidLinesUpdate) {
            if (lineItem.Phoenix_Final_Status__c != 'Not Approved') {
                isAllRejectedCaseFound = false;
            }
        }
        if (isAllRejectedCaseFound) {
            
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
            Phoenix_Bid__c bid = new Phoenix_Bid__c(id = bidId, Phoenix_Approval_Status__c = 'Finance Rejected');
            update bid;
            
            
            
            
            
            
        }
        
        else{
            
            List < Phoenix_Bid_Process_Steps__c > nextSteps = new list < Phoenix_Bid_Process_Steps__c > ();
            Integer stepNo;
            
            stepNo = stepnameNoMap.get('Finance') + 1;
            system.debug('stepNo' + stepNo);
            system.debug('stepMap' + stepMap);
            nextSteps = stepMap.get(stepNo);
            
            
            for (Phoenix_Bid_Process_Steps__c step: nextSteps) {
                if (step.Name.contains('Closed')) {
                    step.Phoenix_Status__c = 'Completed';
                } else {
                    step.Phoenix_Status__c = 'In Process';
                } //'In Process' Submitted //Diff b/w them            
            }
            if (!nextSteps.isEmpty()) {
                update nextSteps;
                
                Phoenix_Bid__c bid = new Phoenix_Bid__c(id = bidId, Phoenix_Approval_Status__c = 'Contracts');
                update bid;
                   Phoenix_SubmitBidForApprovalCtrl.approvalRequestNotification(bidId , nextSteps);
                
                //Phoenix_SubmitBidForApprovalCtrl.sendForApproval(bidId,'Approval Required for '+bidName,nextSteps,'Bid_Approval');
            } else {
                Phoenix_Bid__c bid = new Phoenix_Bid__c(id = bidId, Phoenix_Approval_Status__c = 'Closed');
                update bid;
            }
        }
    }
    @AuraEnabled
    public static void updateNextContractsProcessSteps(string bidId, string bidName, list < Phoenix_Bid_Process_Steps__c > processStepLsit) {
        system.debug('In Contracts');
        
        system.debug('In processStepLsit' + processStepLsit.size());
        
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
        
        
        list < Phoenix_Bid_Line_Item__c > bidLinesUpdate = [select id,Phoenix_Contracts_Final_Approval__c,Phoenix_Customer_Final_Approval__c,Phoenix_Final_Status__c from Phoenix_Bid_Line_Item__c where Phoenix_Bid__c =: bidId];
        
        boolean isAllRejectedCaseFound = true;
        for (Phoenix_Bid_Line_Item__c lineItem: bidLinesUpdate) {
            if (lineItem.Phoenix_Final_Status__c != 'Not Approved') {
                isAllRejectedCaseFound = false;
            }
        }
        if (isAllRejectedCaseFound) {
            
            
            integer currentStepNum =stepnameNoMap.get('SRx IPA Contracts Approver');
            for (Phoenix_Bid_Process_Steps__c prcsStep: processStepLsit) {
                if (prcsStep.Phoenix_Approver_Team__c == 'SRx IPA Contracts Approver' && prcsStep.Phoenix_Status__c!='Completed' ) {
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
            Phoenix_Bid__c bid = new Phoenix_Bid__c(id = bidId, Phoenix_Approval_Status__c = 'Contracts Rejected');
            update bid;
            
            //close the bid other step not applicable
            
        }
        
        else{
            system.debug('stepnamemap--' + stepnameNoMap.get('SRx IPA Contracts Approver') + 1);
            system.debug('stepnamemap--' + stepMap.get(4));
            List < Phoenix_Bid_Process_Steps__c > nextSteps = new list < Phoenix_Bid_Process_Steps__c > ();
            Integer stepNo;
            
            stepNo = stepnameNoMap.get('SRx IPA Contracts Approver') + 1;
            system.debug('stepNo' + stepNo);
            system.debug('stepMap' + stepMap);
            nextSteps = stepMap.get(stepNo);
            
            
            for (Phoenix_Bid_Process_Steps__c step: nextSteps) {
                if (step.Name.contains('Closed')) {
                    step.Phoenix_Status__c = 'Completed';
                } else {
                    step.Phoenix_Status__c = 'In Process';
                } //'In Process' Submitted //Diff b/w them            
            }
            if (!nextSteps.isEmpty()) {
                update nextSteps;
                
                Phoenix_Bid__c bid = new Phoenix_Bid__c(id = bidId, Phoenix_Approval_Status__c = 'Vistex Update');
                update bid;
                   Phoenix_SubmitBidForApprovalCtrl.approvalRequestNotification(bidId , nextSteps);
                
                //Phoenix_SubmitBidForApprovalCtrl.sendForApproval(bidId,'Approval Required for '+bidName,nextSteps,'Bid_Approval');
            } else {
                Phoenix_Bid__c bid = new Phoenix_Bid__c(id = bidId, Phoenix_Approval_Status__c = 'Closed');
                update bid;
            }
        }
        
    }
    @AuraEnabled
    public static void makeApprovalsIPAContracts(String bidId, string comments, string status) {
        
        Phoenix_Bid_Process_Steps__c currentStep = [SELECT Id, Name, Phoenix_Bid__c, Phoenix_Process_Step__c, Phoenix_Step__c, Phoenix_Approver__c, Phoenix_Status__c, Phoenix_Approver_Team__c FROM Phoenix_Bid_Process_Steps__c where Phoenix_Bid__c =: bidId AND(Phoenix_Status__c = 'In Process'
                                                                                                                                                                                                                                                                    OR Phoenix_Status__c = 'Not Processed') limit 1];
        List < Phoenix_Bid_Process_Steps__c > processStepLsit = [SELECT Id, Name, Phoenix_Bid__c, Phoenix_Process_Step__c, Phoenix_Step__c, Phoenix_Approver__c, Phoenix_Status__c, Phoenix_Approver_Team__c FROM Phoenix_Bid_Process_Steps__c where Phoenix_Bid__c =: bidId];
        
        
        if (string.isNotBlank(status) && status == 'Processed') {
            system.debug('status------' + status);
            
            
            for (Phoenix_Bid_Process_Steps__c step: processStepLsit) {
                if (step.Name.contains('Closed')) {
                    step.Phoenix_Status__c = 'Completed';
                }
            }
            
            if (!processStepLsit.isEmpty()) {
                update processStepLsit;
                currentStep.Phoenix_Status__c = 'Completed';
                currentStep.Phoenix_Approver__c = userinfo.getuserid();
                currentStep.Phoenix_Description__c = comments;
                update currentStep;
                Phoenix_Bid__c bid = new Phoenix_Bid__c(id = bidId, Phoenix_Contracts_Approval__c = status, Phoenix_Contracts_Approval_Comments__c = comments, Phoenix_Approval_Status__c = 'Closed');
                update bid;
            }
        } else {
            
            system.debug('currentStep----' + currentStep);
            
            for (Phoenix_Bid_Process_Steps__c step: processStepLsit) {
                if (step.Name.contains('Closed')) {
                    step.Phoenix_Status__c = 'Not Initiated';
                }
            }
            
            if (!processStepLsit.isEmpty()) {
                update processStepLsit;
                currentStep.Phoenix_Status__c = 'Not Processed';
                currentStep.Phoenix_Approver__c = userinfo.getuserid();
                currentStep.Phoenix_Description__c = comments;
                update currentStep;
                Phoenix_Bid__c bid = new Phoenix_Bid__c(id = bidId, Phoenix_Contracts_Approval__c = status, Phoenix_Contracts_Approval_Comments__c = comments, Phoenix_Approval_Status__c = 'Contracts');
                update bid;
            }
        }
    }
    
    
    
    
    
    
    
    
    public class Wrapper {
        
        @AuraEnabled public List < Phoenix_Bid_Line_Item__c > lineItemsList;
        @AuraEnabled public Phoenix_Bid__c bidRecord;
        
        @AuraEnabled public string loggedInUserName;
        @AuraEnabled public string loggedInUserId;
        
        @AuraEnabled public boolean conditionApproval;
        @AuraEnabled public boolean isSRxApprovePerson;
        @AuraEnabled public boolean isFinanceApprovePerson;
        @AuraEnabled public boolean isVistexApprovePerson;
        @AuraEnabled public string isMarketingApprovePerson;
        @AuraEnabled public boolean showProceedBtn;
        
        Wrapper() {
            
            lineItemsList = new List < Phoenix_Bid_Line_Item__c > ();
            bidRecord = new Phoenix_Bid__c();
            
            loggedInUserName = '';
            
            loggedInUserId = '';
            
            isMarketingApprovePerson = '';
        }
    }
    @AuraEnabled
    public static void deleteLineItems(String LineItemId) {
        if (LineItemId != null) {
            Phoenix_Bid_Line_Item__c deletedLineItem = [SELECT Id FROM Phoenix_Bid_Line_Item__c WHERE Id =: LineItemId];
            delete deletedLineItem;
        }
    }
    @AuraEnabled
    public static list < Phoenix_Bid_Line_Item__c > saveLineItems(List < Phoenix_Bid_Line_Item__c > LineItemList) {
        for (Phoenix_Bid_Line_Item__c pbl: LineItemList) {
            pbl.Phoenix_ProposedContractBidPriceMktng__c = pbl.Phoenix_Proposed_IPA_Price__c;
            pbl.Phoenix_Proposed_Direct_Selling_Unit__c = pbl.Phoenix_IDN_Usage__c;
        }
        update LineItemList;
        return LineItemList;
    }
    @AuraEnabled
    public static list < Phoenix_Bid_Line_Item__c > submitToProceedVistex(string bidId) {
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
        string loggerUserName = UserInfo.getName();
        query = 'select Phoenix_Product__r.Phoenix_Rx_SRx_OTC__c,Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_Contracts_Approver__r.Name, Phoenix_Product__r.name,Phoenix_Bid__r.Phoenix_Bid_Name__c, ' + strFields + ' from ' + SobjectApiName + ' where Phoenix_Bid__c = : bidId AND Phoenix_Final_Status__c !=: notApproved';
        
        list < Phoenix_Bid_Line_Item__c > bidLinesList = Database.query(query);
        return bidLinesList;
    }
    @AuraEnabled
    public static WrapperForNextSteps makeApprovalsVistex(String bidId, List < Phoenix_Bid_Line_Item__c > bidlines, boolean approveStatusFlag) {
        boolean vistexNextStepFlag = false;
        for (Phoenix_Bid_Line_Item__c line: bidlines) {
            
              if(line.Phoenix_Vistex_Status__c == 'Updated'){
                    
                    line.Phoenix_Vistex_Update_Final_Approval__c=true;
                }
         
            if (line.Phoenix_Vistex_Status__c == 'Pending') {
                //line.Phoenix_Final_Status__c = 'Not Approved';
                vistexNextStepFlag = true;
            }
            
            
            
        }
        if (bidlines.size() > 0) {
            update bidlines;
        }
        
        
        list < Phoenix_Bid_Process_Steps__c > bidProcessStepList = [SELECT Id, Name, Phoenix_Is_Criteria_Step__c,Phoenix_Bid__c, Phoenix_Process_Step__c, Phoenix_Step__c,Phoenix_Approver__r.Email, Phoenix_Approver__c, Phoenix_Status__c, Phoenix_Approver_Team__c FROM Phoenix_Bid_Process_Steps__c where Phoenix_Bid__c =: bidId];
        list < Phoenix_Bid_Process_Steps__c > contractsStepLsit = new list < Phoenix_Bid_Process_Steps__c > ();
        for (Phoenix_Bid_Process_Steps__c step: bidProcessStepList) {
            
            
            
            if (step.Phoenix_Approver_Team__c == 'Home Office' && vistexNextStepFlag == false) {
                step.Phoenix_Status__c = approveStatusFlag == true ? 'Completed' : 'Do Not Bid';
                step.Phoenix_Approver__c=UserInfo.getUserId();
                contractsStepLsit.add(step);
            }
            
        }
        if (!contractsStepLsit.isEmpty()) {
            update contractsStepLsit;
        }
        WrapperForNextSteps wrapSteps = new WrapperForNextSteps();
        
        wrapSteps.updateProcessStepList = bidProcessStepList;
        
        wrapSteps.contractNextStepFlag = vistexNextStepFlag;
        
        
        return wrapSteps;
        
    }
    @AuraEnabled
    public static void updateNextVistexProcessSteps(string bidId, string bidName, list < Phoenix_Bid_Process_Steps__c > processStepLsit, boolean vistexNextStepFlag) {
        system.debug('In Contracts');
        
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
            system.debug('stepnamemap--' + stepnameNoMap.get('Home Office') + 1);
            
            List < Phoenix_Bid_Process_Steps__c > nextSteps = new list < Phoenix_Bid_Process_Steps__c > ();
            Integer stepNo;
            
            stepNo = stepnameNoMap.get('Home Office') + 1;
            system.debug('stepNo' + stepNo);
            system.debug('stepMap' + stepMap);
            nextSteps = stepMap.get(stepNo);
            
            
            for (Phoenix_Bid_Process_Steps__c step: nextSteps) {
                if (step.Name.contains('Closed')) {
                    step.Phoenix_Status__c = 'Completed';
                } else {
                    step.Phoenix_Status__c = 'In Process';
                } //'In Process' Submitted //Diff b/w them            
            }
            if (!nextSteps.isEmpty()) {
                update nextSteps;
                
                Phoenix_Bid__c bid = new Phoenix_Bid__c(id = bidId, Phoenix_Approval_Status__c = 'Closed');
                update bid;
            }
            //Phoenix_SubmitBidForApprovalCtrl.sendForApproval(bidId,'Approval Required for '+bidName,nextSteps,'Bid_Approval');
        } else {
            Phoenix_Bid__c bid = new Phoenix_Bid__c(id = bidId, Phoenix_Approval_Status__c = 'Closed');
            update bid;
        }
    }
    
}