/**
* @description       : 
* @author            : Surender Dhruvsoft
* @group             : 
* @last modified on  : 23-07-2021
* @last modified by  : Surender Patel (Dhruvsoft)
* Modifications Log 
* Ver   Date         Author               Modification
* 1.0   25-05-2021   Surender Dhruvsoft   Initial Version
**/
public class Phoenix_AddIPABidMainPageCls {
    
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
        Phoenix_Bid__c bid = [SELECT Id, Phoenix_Sent_to_Customer_Date__c,Phoenix_Customer__r.Phoenix_Customer_Service_Approver__c,Phoenix_Customer__r.Phoenix_Contracts_Approver__r.Name, Name, Phoenix_Approval_Status__c, Phoenix_Customer__r.Name, Phoenix_Bid_Name__c, Phoenix_Bid_Type__c FROM Phoenix_Bid__c WHERE Id =: bidId];
        string bidCustomerServiceUser='';
        if(bid.Phoenix_Customer__r.Phoenix_Customer_Service_Approver__c!=null){
            bidCustomerServiceUser=bid.Phoenix_Customer__r.Phoenix_Customer_Service_Approver__c;
            
        }
        
        
        string loggedUserName = UserInfo.getName();
        string notApproved = 'Not Approved';
        //if(bid.Phoenix_Approval_Status__c=='Marketing'){
        //query = 'select Phoenix_Contract__r.Name,Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_Contracts_Approver__r.Name,Phoenix_Contract__r.Id,Phoenix_Customer__r.Name,Phoenix_Customer__r.Id, Phoenix_Product__r.name,Phoenix_Bid__r.Phoenix_Bid_Name__c, ' + strFields + ' from ' + SobjectApiName + ' where Phoenix_Bid__c = : bidId and Phoenix_Product__r.Phoenix_Is_IPA_Product__c=true and Phoenix_Final_Status__c !=: notApproved and Phoenix_Product_Director1__c=:loggedUserName ORDER BY Phoenix_Product__r.Name ASC'  ;
        // }
        //else{
        query = 'select Phoenix_Contract__r.Name,Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_Contracts_Approver__r.Name,Phoenix_Contract__r.Id,Phoenix_Customer__r.Name,Phoenix_Customer__r.Id, Phoenix_Product__r.name,Phoenix_Bid__r.Phoenix_Bid_Name__c,Phoenix_Bid__r.Phoenix_Approval_Status__c, ' + strFields + ' from ' + SobjectApiName + ' where Phoenix_Bid__c = : bidId and Phoenix_Product__r.Phoenix_Is_IPA_Product__c=true and Phoenix_Final_Status__c !=: notApproved ORDER BY Phoenix_Product__r.Name ASC ';
        
        //}
        list < Phoenix_Bid_Line_Item__c > quoteList = Database.query(query);
        system.debug('quoteList--->' + quoteList);
        List < String > productDirectorList = new List < String > ();
        boolean showProceedBtn = true;
        boolean showProceedContrBtn = true;
        boolean showProceedVistexBtn = true;
        boolean showProceedCusServcBtn = true;
        
        
        boolean conditionApproval = false;
        for (Phoenix_Bid_Line_Item__c lineItem: quoteList) {
            
            
            if (lineItem.Phoenix_Product_Director1__c != null && !productDirectorList.contains(lineItem.Phoenix_Product_Director1__c)) {
                productDirectorList.add(lineItem.Phoenix_Product_Director1__c);
            }
            if (lineItem.Phoenix_Product_Director1__c != null && lineItem.Phoenix_Marketing_Final_Approval__c != null && lineItem.Phoenix_Marketing_Final_Approval__c == true && lineItem.Phoenix_Product_Director1__c == userinfo.getName()) {
                system.debug('In mARKETING APProval');
                showProceedBtn = false;
            }
            if (lineItem.Phoenix_Product_Director1__c != null && lineItem.Phoenix_Product_Director1__c != userinfo.getName()) {
                //showProceedBtn=false;  
            }
            // if(lineItem.Phoenix_Conditional_Approval_Req_for_Flo__c==false){
            system.debug('In Condition');
            //showProceedBtn=false;
            //}
            if (lineItem.Phoenix_Contracts_Final_Approval__c != null && lineItem.Phoenix_Contracts_Final_Approval__c == false) {
                showProceedContrBtn = false;
            }
  
                 if (lineItem.Phoenix_Proposed_IPA_Price__c > 0 && (lineItem.Phoenix_Proposed_IPA_Price__c <= lineItem.Phoenix_IPA_Floor_Price1__c || lineItem.Phoenix_IPA_Floor_Price1__c == null)) {
               		 conditionApproval = true;
           		 }
           
           
            if (lineItem.Phoenix_Vistex_Update_Final_Approval__c != null && lineItem.Phoenix_Vistex_Update_Final_Approval__c == false) {
                showProceedVistexBtn = false;
            }
            if (lineItem.Phoenix_Customer_Final_Approval__c != null && lineItem.Phoenix_Customer_Final_Approval__c == false) {
                showProceedCusServcBtn = false;
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
        boolean isCustomerServiceApprovePerson = false;
        
        if (userTeamUserIdMap.containsKey('Supply Chain-' + UserInfo.getUserId())) {
            isSCMApprovePerson = true;
        }
        if (userTeamUserIdMap.containsKey('Finance-' + UserInfo.getUserId())) {
            isFinanceApprovePerson = true;
        }
        if (userTeamUserIdMap.containsKey('SRx IPA Contracts Approver-' + UserInfo.getUserId())) {
            isSRxApprovePerson = true;
        }
        if (userTeamUserIdMap.containsKey('Home Office-' + UserInfo.getUserId())) {
            isVistexApprovePerson = true;
        }
        
        if (userTeamUserIdMap.containsKey('Contracts-' + UserInfo.getUserId())) {
            isContractsApprovePerson = true;
            system.debug('isContractsApprovePerson---' + isContractsApprovePerson);
        }
        system.debug('isSCMApprovePerson---' + isSCMApprovePerson);
        string isMarketingApprovePerson;
        
        if (userTeamUserIdMap.containsKey('Marketing-' + UserInfo.getUserId())) {
            isMarketingApprovePerson = userTeamUserIdMap.get(('Marketing-' + UserInfo.getUserId()));
        }
        if (userTeamUserIdMap.containsKey('Customer Service-' + UserInfo.getUserId())) {
            isCustomerServiceApprovePerson=true;
        }
        /*if(bidCustomerServiceUser==UserInfo.getUserId()){
            isCustomerServiceApprovePerson=true;
        }*/
        //boolean showProceedBtn=true; 
        
        system.debug('showProceedBtn---' + showProceedBtn);
        
        
        wrapperObject.lineItemsList = quoteList;
        wrapperObject.bidRecord = bid;
        wrapperObject.loggedInUserName = UserInfo.getName();
        wrapperObject.loggedInUserId = UserInfo.getUserId();
        wrapperObject.conditionApproval = conditionApproval;
        wrapperObject.isFinanceApprovePerson = isFinanceApprovePerson;
        wrapperObject.isVistexApprovePerson = isVistexApprovePerson;
        wrapperObject.isMarketingApprovePerson = isMarketingApprovePerson;
        wrapperObject.isSCMApprovePerson = isSCMApprovePerson;
        wrapperObject.productDirectorList = productDirectorList;
        wrapperObject.isCustomerServiceApprovePerson = isCustomerServiceApprovePerson;
        wrapperObject.isContractsApprovePerson = isContractsApprovePerson;
        wrapperObject.isSRxApprovePerson = isSRxApprovePerson;
        if (bid.Phoenix_Customer__r.Phoenix_Contracts_Approver__r.Name != null) {
            wrapperObject.BidContractPerson = bid.Phoenix_Customer__r.Phoenix_Contracts_Approver__c;
        }
        wrapperObject.showProceedBtn = showProceedBtn;
        wrapperObject.showProceedContrBtn = showProceedContrBtn;
        wrapperObject.showProceedVistexBtn = showProceedVistexBtn;
        wrapperObject.showProceedCusServcBtn = showProceedCusServcBtn;
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
    public static list < Phoenix_Bid_Line_Item__c > submitToProceddStep(string bidId) {
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
        query = 'select Phoenix_Product__r.Phoenix_Rx_SRx_OTC__c,Phoenix_Bid__r.Phoenix_Approval_Status__c,Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_Contracts_Approver__r.Name, Phoenix_Product__r.name,Phoenix_Bid__r.Phoenix_Bid_Name__c, ' + strFields + ' from ' + SobjectApiName + ' where Phoenix_Bid__c = : bidId AND Phoenix_Final_Status__c !=: notApproved';
        
        list < Phoenix_Bid_Line_Item__c > bidLinesList = Database.query(query);
        return bidLinesList;
        
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
        query = 'select Phoenix_Product__r.Phoenix_Rx_SRx_OTC__c,Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_Contracts_Approver__r.Name,Phoenix_Bid__r.Phoenix_Approval_Status__c, Phoenix_Product__r.name,Phoenix_Bid__r.Phoenix_Bid_Name__c, ' + strFields + ' from ' + SobjectApiName + ' where Phoenix_Bid__c = : bidId AND Phoenix_Final_Status__c !=: notApproved';
        
        list < Phoenix_Bid_Line_Item__c > bidLinesList = Database.query(query);
        return bidLinesList;
    }
    @AuraEnabled
    public static list < Phoenix_Bid_Line_Item__c > submitToProceddStep1(string bidId, boolean isContracts) {
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
        query = 'select Phoenix_Product__r.Phoenix_Rx_SRx_OTC__c,Phoenix_Bid__r.Phoenix_Approval_Status__c,Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_Contracts_Approver__r.Name, Phoenix_Product__r.name,Phoenix_Bid__r.Phoenix_Bid_Name__c, ' + strFields + ' from ' + SobjectApiName + ' where Phoenix_Bid__c = : bidId AND Phoenix_Final_Status__c !=: notApproved';
        if (isContracts != true) {
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
        
        list < Phoenix_Bid_Process_Steps__c > bidProcessStepList = [SELECT Id, Name, Phoenix_Bid__c, Phoenix_Is_Criteria_Step__c, Phoenix_Process_Step__c, Phoenix_Step__c, Phoenix_Approver__c, Phoenix_Status__c,Phoenix_Approver__r.Email, Phoenix_Approver_Team__c FROM Phoenix_Bid_Process_Steps__c where Phoenix_Bid__c =: bidId order by Phoenix_Step__c];
        list < Phoenix_Bid_Line_Item__c > bidLinesUpdate = [select id,Phoenix_Marketing_Final_Approval__c,Phoenix_Bid__r.Phoenix_Approval_Status__c,Phoenix_Contracts_Final_Approval__c,Phoenix_Customer_Final_Approval__c,Phoenix_Final_Status__c from Phoenix_Bid_Line_Item__c where Phoenix_Bid__c =: bidId];
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
            System.debug('bidProcessStepList-->'+bidProcessStepList);
            if(bidProcessStepList != null && bidProcessStepList.size() > 0){
            System.debug('bidProcessStepList-->'+bidProcessStepList);
            update bidProcessStepList;
            }
            Phoenix_Bid__c bid = new Phoenix_Bid__c(id = bidId, Phoenix_Approval_Status__c = 'Marketing Rejected');
            update bid;
            
            wrapSteps.updateProcessStepList = bidProcessStepList;
            wrapSteps.flagMarketStop = true;
            
            
            
            
            
            
        }
        else{
            list < Phoenix_Bid_Process_Steps__c > marketStepLsit = new list < Phoenix_Bid_Process_Steps__c > ();
            boolean flagSCMStop = false;
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
            //  WrapperForNextSteps wrapSteps = new WrapperForNextSteps();
            if (!marketStepLsit.isEmpty()) {
                update marketStepLsit;
                wrapSteps.updateProcessStepList = bidProcessStepList;
                // wrapSteps.flagSCMStop=flagSCMStop;
                wrapSteps.flagMarketStop = flagMarketStop;
            }
        }
        
        return wrapSteps;
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
    @AuraEnabled
    public static WrapperForNextSteps makeApprovalsVistex(String bidId, List < Phoenix_Bid_Line_Item__c > bidlines, boolean approveStatusFlag) {
        boolean vistexNextStepFlag = false;
        String bidApprovalStatus ='';
        String finalStatus = 'Not Approved';
        bidApprovalStatus = [SELECT id, Phoenix_Approval_Status__c FROM Phoenix_Bid__c WHERE Id=:bidId].Phoenix_Approval_Status__c;
        String query= 'SELECT Phoenix_Product__r.Phoenix_Rx_SRx_OTC__c,Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_Contracts_Approver__r.Name,Phoenix_Bid__r.Phoenix_Approval_Status__c, Phoenix_Product__r.name,Phoenix_Bid__r.Phoenix_Bid_Name__c, '+Phoenix_Util.bidlineitemFields+ ' FROM Phoenix_Bid_Line_Item__c WHERE Phoenix_Bid__c=:bidId AND Phoenix_Final_Status__c !=:finalStatus';
        List<Phoenix_Bid_Line_Item__c> bidLineItems = Database.query(query);
        for (Phoenix_Bid_Line_Item__c line: bidLineItems) {
            if(line.Phoenix_Vistex_Status__c == 'Updated' && bidApprovalStatus=='Vistex Update'){
                    system.debug('in vistex update');
                    line.Phoenix_Vistex_Update_Final_Approval__c=true;
                }
            if (line.Phoenix_Vistex_Status__c == 'Pending'  && bidApprovalStatus=='Vistex Update') {
                //line.Phoenix_Final_Status__c = 'Not Approved';
                vistexNextStepFlag = true;
            }
            if(line.Vistex_Customer_Code_Update_Status__c == 'Updated' && bidApprovalStatus=='Vistex Customer Code Update'){
                    
                    line.Phoenix_SCM_Final_Approval__c=true;
                }
            if (line.Vistex_Customer_Code_Update_Status__c == 'Pending'  && bidApprovalStatus=='Vistex Customer Code Update') {
                //line.Phoenix_Final_Status__c = 'Not Approved';
                vistexNextStepFlag = true;
            }
            
            
            
        }
        if (bidlines.size() > 0) {
            update bidlines;
        }
        
        
        list < Phoenix_Bid_Process_Steps__c > bidProcessStepList = [SELECT Id, Name,Phoenix_Process_Step__r.Name, Phoenix_Bid__c,Phoenix_Bid__r.Phoenix_Approval_Status__c, Phoenix_Process_Step__c, Phoenix_Step__c,Phoenix_Approver__r.Name,Phoenix_Approver__r.Email, Phoenix_Approver__c, Phoenix_Status__c, Phoenix_Approver_Team__c,Phoenix_Is_Criteria_Step__c FROM Phoenix_Bid_Process_Steps__c where Phoenix_Bid__c =: bidId ORDER BY Phoenix_Step__c ASC];
        list < Phoenix_Bid_Process_Steps__c > contractsStepLsit = new list < Phoenix_Bid_Process_Steps__c > ();
        for (Phoenix_Bid_Process_Steps__c step: bidProcessStepList) {
            
            if(step.Phoenix_Bid__r.Phoenix_Approval_Status__c == 'Vistex Update'){
                system.debug('step.Phoenix_Approver_Team__c-->'+step.Phoenix_Approver_Team__c);
                system.debug('vistexNextStepFlag-->'+vistexNextStepFlag);
                system.debug('step.Phoenix_Process_Step__r.Name-->'+step.Phoenix_Process_Step__r.Name);
                if (step.Phoenix_Approver_Team__c == 'Home Office' && vistexNextStepFlag == false && step.Phoenix_Process_Step__r.Name == 'Vistex Update') {
                    step.Phoenix_Status__c = approveStatusFlag == true ? 'Completed' : 'Do Not Bid';
                    step.Phoenix_Approver__c=UserInfo.getUserId();
                    contractsStepLsit.add(step);
                    system.debug('in vistex');
                }
            }
            else if(step.Phoenix_Bid__r.Phoenix_Approval_Status__c == 'Vistex Customer Code Update'){
                if (step.Phoenix_Approver_Team__c == 'Home Office' && vistexNextStepFlag == false && step.Phoenix_Process_Step__r.Name == 'Vistex Customer Code Update') {
                    step.Phoenix_Status__c = approveStatusFlag == true ? 'Completed' : 'Do Not Bid';
                    step.Phoenix_Approver__c=UserInfo.getUserId();
                    contractsStepLsit.add(step);
                }
                if(step.Name!=null && step.Name.contains('Closed') && !vistexNextStepFlag){
                    system.debug('in completed step');
                     step.Phoenix_Status__c = 'Completed';
                     step.Phoenix_Approval_Completed_Time__c=system.now();
                     contractsStepLsit.add(step);
                }
            }
            
            
            
        }
        system.debug('vistexsteps List--->'+contractsStepLsit);
        system.debug('vistexsteps size--->'+contractsStepLsit.size());
        if (!contractsStepLsit.isEmpty()) {
            update contractsStepLsit;
            if(bidApprovalStatus == 'Vistex Customer Code Update'){
                Phoenix_Bid__c bid = new Phoenix_Bid__c(Id=bidId , Phoenix_Approval_Status__c='Closed');
                update bid;
            }
        }
        WrapperForNextSteps wrapSteps = new WrapperForNextSteps();
        
        wrapSteps.updateProcessStepList = bidProcessStepList;
        
        wrapSteps.contractNextStepFlag = vistexNextStepFlag;
        
        
        return wrapSteps;
        
    }
    
    @AuraEnabled
    public static list < Phoenix_Bid_Process_Steps__c > makeApprovalsCustomer(String bidId, List < Phoenix_Bid_Line_Item__c > bidlines, boolean approveStatusFlag) {
        boolean vistexNextStepFlag = false;
        for (Phoenix_Bid_Line_Item__c line: bidlines) {
            
            
            line.Phoenix_Customer_Final_Approval__c = true;
            if (line.Phoenix_Customer_Service_Status__c == 'Not Processed') {
                line.Phoenix_Final_Status__c = 'Not Approved';
                //vistexNextStepFlag = true;
            }
            
            
            
        }
        if (bidlines.size() > 0) {
            update bidlines;
        }
        
        
        list < Phoenix_Bid_Process_Steps__c > bidProcessStepList = [SELECT Id, Name, Phoenix_Bid__c,Phoenix_Is_Criteria_Step__c,Phoenix_Process_Step__c, Phoenix_Step__c,Phoenix_Approver__r.Email, Phoenix_Approver__c, Phoenix_Status__c, Phoenix_Approver_Team__c,Phoenix_Approver_Team_Members__c FROM Phoenix_Bid_Process_Steps__c where Phoenix_Bid__c =: bidId];
        list < Phoenix_Bid_Process_Steps__c > contractsStepLsit = new list < Phoenix_Bid_Process_Steps__c > ();
        for (Phoenix_Bid_Process_Steps__c step: bidProcessStepList) {
            
            
            
            if (step.Phoenix_Status__c == 'In Process' && step.Name.contains('Customer Service') && step.Phoenix_Approver_Team_Members__c.containsIgnoreCase(Userinfo.getName())) {
                step.Phoenix_Status__c = approveStatusFlag == true ? 'Completed' : 'Completed';
                //approveStatusFlag == true ? 'Completed' : 'Do Not Bid';
                step.Phoenix_Approver__c=UserInfo.getUserId();
                contractsStepLsit.add(step);
            }
            
        }
        if (!contractsStepLsit.isEmpty()) {
            update contractsStepLsit;
        }
        //WrapperForNextSteps wrapSteps = new WrapperForNextSteps();
        
        //wrapSteps.updateProcessStepList = bidProcessStepList;
        
        //wrapSteps.contractNextStepFlag = vistexNextStepFlag;
        
        
        return bidProcessStepList;
        
    }
    
    @AuraEnabled
    public static WrapperForNextSteps makeApprovalsRCAContracts(String bidId, List < Phoenix_Bid_Line_Item__c > bidlines, boolean approveStatusFlag) {
        for (Phoenix_Bid_Line_Item__c line: bidlines) {
            
            
            line.Phoenix_Contracts_Final_Approval__c = true;
            if (line.Phoenix_Contract_Approval__c == 'Line Error- Not Sent') {
                line.Phoenix_Final_Status__c = 'Not Approved';
            }
            
            
            
        }
        if (bidlines.size() > 0) {
            update bidlines;
        }
        String query = '';
        String SobjectApiName = 'Phoenix_RCA_IPA_LINE__c';
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
        query = 'select ' + strFields + ' from ' + SobjectApiName + ' where Phoenix_Bid__c = : bidId AND Phoenix_Final_Status__c !=: notApproved';
        
        list < Phoenix_RCA_IPA_LINE__c > bidLinesList = Database.query(query);
        boolean contractNextStepFlag = false;
        for (Phoenix_RCA_IPA_LINE__c pbl: bidLinesList) {
            if (pbl.Phoenix_Contracts_Final_Approval__c == false) {
                contractNextStepFlag = true;
            }
        }
        list < Phoenix_Bid_Process_Steps__c > bidProcessStepList = [SELECT Id, Name,Phoenix_Is_Criteria_Step__c, Phoenix_Bid__c, Phoenix_Process_Step__c, Phoenix_Step__c, Phoenix_Approver__c,Phoenix_Approver__r.Email, Phoenix_Status__c, Phoenix_Approver_Team__c FROM Phoenix_Bid_Process_Steps__c where Phoenix_Bid__c =: bidId];
        list < Phoenix_Bid_Process_Steps__c > contractsStepLsit = new list < Phoenix_Bid_Process_Steps__c > ();
        for (Phoenix_Bid_Process_Steps__c step: bidProcessStepList) {
            
            
            
            if (step.Phoenix_Approver_Team__c == 'Contracts' && contractNextStepFlag == false) {
                step.Phoenix_Status__c = approveStatusFlag == true ? 'Completed' : 'Do Not Bid';
                //approveStatusFlag == true ? 'Completed' : 'Do Not Bid'
                  step.Phoenix_Approver__c=UserInfo.getUserId();
                contractsStepLsit.add(step);
            }
            
        }
        if (!contractsStepLsit.isEmpty()) {
            update contractsStepLsit;
        }
        WrapperForNextSteps wrapSteps = new WrapperForNextSteps();
        
        wrapSteps.updateProcessStepList = bidProcessStepList;
        // wrapSteps.flagSCMStop=flagSCMStop;
        wrapSteps.contractNextStepFlag = contractNextStepFlag;
        
        
        return wrapSteps;
        
    }
    @AuraEnabled
    public static void makeApprovalsIPAContracts(String bidId, string comments, string status) {
        
        Phoenix_Bid_Process_Steps__c currentStep = [SELECT Id, Name,Phoenix_Is_Criteria_Step__c, Phoenix_Bid__c, Phoenix_Process_Step__c, Phoenix_Step__c, Phoenix_Approver__c, Phoenix_Status__c, Phoenix_Approver_Team__c FROM Phoenix_Bid_Process_Steps__c where Phoenix_Bid__c =: bidId AND(Phoenix_Status__c = 'In Process'
                                                                                                                                                                                                                                                                    OR Phoenix_Status__c = 'Not Processed') limit 1];
        List < Phoenix_Bid_Process_Steps__c > processStepLsit = [SELECT Id, Name, Phoenix_Is_Criteria_Step__c ,Phoenix_Bid__c, Phoenix_Process_Step__c, Phoenix_Step__c, Phoenix_Approver__c, Phoenix_Status__c, Phoenix_Approver_Team__c FROM Phoenix_Bid_Process_Steps__c where Phoenix_Bid__c =: bidId];
        
        
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
                    step.Phoenix_Status__c = 'Not Applicable';
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
    
    
    
    
    
    
    
    @AuraEnabled
    public static list < Phoenix_Bid_Process_Steps__c > makeApprovalsContracts(String bidId, List < Phoenix_Bid_Line_Item__c > bidlines, boolean approveStatusFlag, boolean isSCM, boolean isFinance) {
        for (Phoenix_Bid_Line_Item__c line: bidlines) {
            if (isSCM) {
                line.Phoenix_SCM_Final_Approval__c = true;
                if (line.Phoenix_SCM_Approval_Y_N__c == 'N- Not Approved') {
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
        list < Phoenix_Bid_Process_Steps__c > bidProcessStepList = [SELECT Id, Name,Phoenix_Is_Criteria_Step__c,Phoenix_Bid__c, Phoenix_Process_Step__c, Phoenix_Step__c, Phoenix_Approver__r.Name, Phoenix_Approver__r.Email, Phoenix_Approver__c, Phoenix_Status__c, Phoenix_Approver_Team__c FROM Phoenix_Bid_Process_Steps__c where Phoenix_Bid__c =: bidId];
        list < Phoenix_Bid_Process_Steps__c > contractsStepLsit = new list < Phoenix_Bid_Process_Steps__c > ();
        for (Phoenix_Bid_Process_Steps__c step: bidProcessStepList) {
            
            if (step.Phoenix_Approver_Team__c == 'Supply Chain' && isSCM) {
                step.Phoenix_Status__c = approveStatusFlag == true ? 'Completed' : 'Do Not Bid';
                step.Phoenix_Approver__c=UserInfo.getUserId();
                contractsStepLsit.add(step);
            }
            
            
            
            
            if (step.Phoenix_Approver_Team__c == 'Finance' && isFinance) {
                System.debug('approve status falg value--->'+approveStatusFlag);
                step.Phoenix_Status__c = approveStatusFlag == true ? 'Completed' : 'Completed';
                System.debug('Next approve status falg value--->'+approveStatusFlag);
                    //approveStatusFlag == true ? 'Completed' : 'Do Not Bid';
                step.Phoenix_Approver__c=UserInfo.getUserId();
                contractsStepLsit.add(step);
            }
        }
        if (!contractsStepLsit.isEmpty()) {
            update contractsStepLsit;
        }
        return bidProcessStepList;
    }
    
    @AuraEnabled
    public static void updateNextSCMProcessSteps(string bidId, boolean conditionalApproval, string bidName, list < Phoenix_Bid_Process_Steps__c > processStepLsit) {
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
        
        
        
        list < Phoenix_Bid_Line_Item__c > bidLinesUpdate = [select id,Phoenix_Proposed_IPA_Price__c,Phoenix_IPA_Floor_Price1__c,Phoenix_Contracts_Final_Approval__c,Phoenix_Customer_Final_Approval__c,Phoenix_Final_Status__c from Phoenix_Bid_Line_Item__c where Phoenix_Bid__c =: bidId];
        boolean conditionalApproval1=false;
        boolean isAllRejectedCaseFound = true;
        for (Phoenix_Bid_Line_Item__c lineItem: bidLinesUpdate) {
            if (lineItem.Phoenix_Final_Status__c != 'Not Approved') {
                isAllRejectedCaseFound = false;
            }
            if(lineItem.Phoenix_Final_Status__c!='Not Approved'){
                if (lineItem.Phoenix_Proposed_IPA_Price__c > 0 && (lineItem.Phoenix_Proposed_IPA_Price__c < lineItem.Phoenix_IPA_Floor_Price1__c || lineItem.Phoenix_IPA_Floor_Price1__c == null)) {
                    conditionalApproval1 = true;
                }
            }
        }
        if (isAllRejectedCaseFound) {
            
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
            Phoenix_Bid__c bid = new Phoenix_Bid__c(id = bidId, Phoenix_Approval_Status__c = 'Supply Chain Rejected');
            update bid;
            
        }
        else{
            system.debug('stepnamemap--' + stepnameNoMap.get('Supply Chain') + 1);
            system.debug('stepnamemap--' + stepMap.get(4));
            List < Phoenix_Bid_Process_Steps__c > nextSteps = new list < Phoenix_Bid_Process_Steps__c > ();
            List < Phoenix_Bid_Process_Steps__c > nextStepscopy = new list < Phoenix_Bid_Process_Steps__c > ();
            Integer stepNo;
            if (conditionalApproval1 == true) {
                stepNo = stepnameNoMap.get('Supply Chain') + 1;
                nextSteps = stepMap.get(stepNo);
            } else {
                stepNo = stepnameNoMap.get('Supply Chain') + 3;
                system.debug('stepNo' + stepNo);
                system.debug('stepMap' + stepMap);
                
                nextSteps = stepMap.get(stepNo);
                stepNo = stepnameNoMap.get('Supply Chain') + 1;
                nextStepscopy = stepMap.get(stepNo);
                stepNo = stepnameNoMap.get('Supply Chain') + 2;
                list < Phoenix_Bid_Process_Steps__c > stepBidList = stepMap.get(stepNo);
                
                for (Phoenix_Bid_Process_Steps__c bstep: nextStepscopy) {
                    nextSteps.add(bstep);
                }
                for (Phoenix_Bid_Process_Steps__c bstep: stepBidList) {
                    nextSteps.add(bstep);
                }
            }
            String currentUser = [SELECT id, Name FROM User WHERE Id =: UserInfo.getUserId() LIMIT 1].Id;
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
            
            //query+=' and Phoenix_Product_Director1__c=:loggerUserName';
            
            list < Phoenix_Bid_Line_Item__c > bidLinesList = Database.query(query);
            system.debug('bidLinesList-----' + bidLinesList);
            list < Phoenix_Bid_Process_Steps__c > nextstepsCopy1 = new list < Phoenix_Bid_Process_Steps__c > ();
            for (Phoenix_Bid_Process_Steps__c step: nextSteps) {
                if (step.Name.contains('Closed')) {
                    step.Phoenix_Status__c = 'Completed';
                } else if (conditionalApproval1 == false && (step.Name.contains('Finance') || step.Name.contains('Marketing') || step.Name.contains('Contract'))) {
                    if (step.Name.contains('Finance') || step.Name.contains('Marketing')) {
                        step.Phoenix_Status__c = 'Not Applicable';
                    }
                    if (step.Name.contains('Contract')) {
                        step.Phoenix_Status__c = 'In Process';
                    }
                } /*else if (step.Name.contains('Marketing')) {
for (Phoenix_Bid_Line_Item__c pbl: bidLinesList) {
system.debug('pbl.Phoenix_Conditional_Approval_Req_for_Flo__c' + pbl.Phoenix_Conditional_Approval_Req_for_Flo__c);
if (step.Phoenix_Approver__r.Name == pbl.Phoenix_Product_Director1__c && pbl.Phoenix_Conditional_Approval_Req_for_Flo__c == false) {
step.Phoenix_Status__c = 'Not Applicable';
}

}

}*/
                //else if(step.Name.contains('Contracts')){
                //step.Phoenix_Status__c = 'In Process';   
                //}
                nextstepsCopy1.add(step);
                //else{step.Phoenix_Status__c = 'In Process';}//'In Process' Submitted //Diff b/w them            
            }
            
            if (conditionalApproval1) {
                for (Phoenix_Bid_Process_Steps__c step: nextstepsCopy1) {
                    if (step.Name.contains('Marketing') && step.Phoenix_Status__c == 'Not Initiated') {
                        step.Phoenix_Status__c = 'In Process';
                    }
                    //nextstepsCopy1.add(step);
                }
            }
            if (!nextstepsCopy1.isEmpty()) {
                update nextstepsCopy1;
                
                if (conditionalApproval1) {
                    Phoenix_Bid__c bid = new Phoenix_Bid__c(id = bidId, Phoenix_Approval_Status__c = 'Marketing');
                    update bid;
                } else {
                    Phoenix_Bid__c bid = new Phoenix_Bid__c(id = bidId, Phoenix_Approval_Status__c = nextstepsCopy1[0].Phoenix_Approver_Team__c);
                    update bid;
                }
                
                Phoenix_SubmitBidForApprovalCtrl.approvalRequestNotification(bidId , nextSteps);//Added by satya
                //Phoenix_SubmitBidForApprovalCtrl.sendForApproval(bidId,'Approval Required for '+bidName,nextSteps,'Bid_Approval');
            } else {
                Phoenix_Bid__c bid = new Phoenix_Bid__c(id = bidId, Phoenix_Approval_Status__c = 'Closed');
                update bid;
            }
        }
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
                if(!stepnameNoMap.containsKey(stepName))
                	stepnameNoMap.put(stepName, stepNo);
                
            }
            system.debug('stepnamemap--' + stepnameNoMap.get('Home Office') + 1);
            system.debug('stepnamemap--' + stepMap.get(4));
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
                
                Phoenix_Bid__c bid = new Phoenix_Bid__c(id = bidId, Phoenix_Approval_Status__c = nextSteps[0].Phoenix_Approver_Team__c);
                update bid;
				System.debug('next step-->'+nextSteps);
            }
             Phoenix_SubmitBidForApprovalCtrl.approvalRequestNotification(bidId , nextSteps);//Added by satya
			System.debug('success msg');
            //Phoenix_SubmitBidForApprovalCtrl.sendForApproval(bidId,'Approval Required for '+bidName,nextSteps,'Bid_Approval');
        } else {
            Phoenix_Bid__c bid = new Phoenix_Bid__c(id = bidId, Phoenix_Approval_Status__c = 'Closed');
            update bid;
           //Phoenix_SubmitBidForApprovalCtrl.approvalRequestNotification(bidId , nextSteps);//Added by satya

        }
    }
    @AuraEnabled
    public static void updateNextCustomerProcessSteps(string bidId, string bidName, list < Phoenix_Bid_Process_Steps__c > processStepLsit) {
        
        
        system.debug('In processStepLsit' + processStepLsit.size());
        if ( !processStepLsit.isEmpty()) {
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
                
                integer currentStepNum =6;
                for (Phoenix_Bid_Process_Steps__c prcsStep: processStepLsit) {
                    if (prcsStep.Phoenix_Status__c == 'In Process' && prcsStep.Name.contains('Customer Service') ) {
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
                Phoenix_Bid__c bid = new Phoenix_Bid__c(id = bidId, Phoenix_Approval_Status__c = 'Customer Service Rejected');
                update bid;
                
            }
            else{
                
                
                List < Phoenix_Bid_Process_Steps__c > nextSteps = new list < Phoenix_Bid_Process_Steps__c > ();
                system.debug('stepMap' + stepMap);
                nextSteps = stepMap.get(7);
                
                
                for (Phoenix_Bid_Process_Steps__c step: nextSteps) {
                    if (step.Name.contains('Closed')) {
                        step.Phoenix_Status__c = 'Completed';
                    } else {
                        step.Phoenix_Status__c = 'In Process';
                    }       
                }
                if (!nextSteps.isEmpty()) {
                    update nextSteps;
                    
                    Phoenix_Bid__c bid = new Phoenix_Bid__c(id = bidId, Phoenix_Approval_Status__c = 'Vistex Customer Code Update');
                    update bid;
                }
                /*Need to Remove after testing is done*/
                //Phoenix_SubmitBidForApprovalCtrl.approvalRequestNotification(bidId , nextSteps);//Added by satya
            }
        }
        else {
            Phoenix_Bid__c bid = new Phoenix_Bid__c(id = bidId, Phoenix_Approval_Status__c = 'Closed');
            update bid;
        }
    }
    
    @AuraEnabled
    public static void updateNextContractsProcessSteps(string bidId, string bidName, list < Phoenix_Bid_Process_Steps__c > processStepLsit, boolean contractNextStepFlag) {
        system.debug('In Contracts');
        system.debug('In contractNextStepFlag' + contractNextStepFlag);
        system.debug('In processStepLsit' + processStepLsit.size());
        if (contractNextStepFlag == false && !processStepLsit.isEmpty()) {
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
            //Added by satya
            list < Phoenix_Bid_Line_Item__c > bidLinesUpdate = [select id,Phoenix_Contracts_Final_Approval__c,Phoenix_Customer_Final_Approval__c,Phoenix_Final_Status__c from Phoenix_Bid_Line_Item__c where Phoenix_Bid__c =: bidId];
            boolean isAllRejectedCaseFound = true;
                for (Phoenix_Bid_Line_Item__c lineItem: bidLinesUpdate) {
                	if (lineItem.Phoenix_Final_Status__c != 'Not Approved') {
                    	isAllRejectedCaseFound = false;
                	}
                }
            if (isAllRejectedCaseFound) {
            
            
            integer currentStepNum =stepnameNoMap.get('Contracts');
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
            Phoenix_Bid__c bid = new Phoenix_Bid__c(id = bidId, Phoenix_Approval_Status__c = 'Contracts Rejected');
            update bid;
            
            //close the bid other step not applicable
            
        }
            else{//Added by satya
            system.debug('stepnamemap--' + stepnameNoMap.get('Contracts') + 1);
            system.debug('stepnamemap--' + stepMap.get(4));
            List < Phoenix_Bid_Process_Steps__c > nextSteps = new list < Phoenix_Bid_Process_Steps__c > ();
            Integer stepNo;
            
            stepNo = stepnameNoMap.get('Contracts') + 1;
            system.debug('stepNo' + stepNo);
            system.debug('stepMap' + stepMap);
            nextSteps = stepMap.get(stepNo);
            
            
            for (Phoenix_Bid_Process_Steps__c step: nextSteps) {
                if (step.Name.contains('Closed')) {
                    step.Phoenix_Status__c = 'Completed';
                    step.Phoenix_Approver__c = userinfo.getuserid();
                    System.debug('approver-->'+step.Phoenix_Approver__c);
                } else {
                    step.Phoenix_Status__c = 'In Process';
                } //'In Process' Submitted //Diff b/w them            
            }
            if (!nextSteps.isEmpty()) {
                update nextSteps;
                if (nextSteps[0].Phoenix_Approver_Team__c == 'Home Office') {
                    Phoenix_Bid__c bid = new Phoenix_Bid__c(id = bidId, Phoenix_Approval_Status__c = 'Vistex Update');
                    update bid;
				//Phoenix_SubmitBidForApprovalCtrl.approvalRequestNotification(bidId , nextSteps);// added by satya

                }
               Phoenix_SubmitBidForApprovalCtrl.approvalRequestNotification(bidId , nextSteps);// added by satya

                //Phoenix_SubmitBidForApprovalCtrl.sendForApproval(bidId,'Approval Required for '+bidName,nextSteps,'Bid_Approval');
            } else {
                Phoenix_Bid__c bid = new Phoenix_Bid__c(id = bidId, Phoenix_Approval_Status__c = 'Closed');
                update bid;
            }
        }//Added by satya
        }
    }
    @AuraEnabled
    public static void updateNextMarketingProcessSteps(string bidId, string bidName, list < Phoenix_Bid_Process_Steps__c > processStepLsit,boolean flagMarketStop) {
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
                if (lineItem.Phoenix_Proposed_IPA_Price__c > 0 && (lineItem.Phoenix_Proposed_IPA_Price__c < lineItem.Phoenix_IPA_Floor_Price1__c || lineItem.Phoenix_IPA_Floor_Price1__c == null)) {
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
                system.debug('-------+stepNo+-----' + stepNo);
                nextStepscopy = stepMap.get(stepNo);
                system.debug('-------+nextStepscopy+-----' + nextStepscopy);
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
                  // Phoenix_SubmitBidForApprovalCtrl.approvalRequestNotification(bidId , nextSteps);//added by satya

                }
                System.debug('next step(contracts)'+nextSteps);
                 Phoenix_SubmitBidForApprovalCtrl.approvalRequestNotification(bidId , nextSteps);//added by satya

                //Phoenix_SubmitBidForApprovalCtrl.sendForApproval(bidId,'Approval Required for '+bidName,nextSteps,'Bid_Approval');
            } else {
                Phoenix_Bid__c bid = new Phoenix_Bid__c(id = bidId, Phoenix_Approval_Status__c = 'Closed');
                update bid;
            }
        }
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
            
            system.debug('stepnamemap--' + stepnameNoMap.get('Finance') + 1);
            system.debug('stepnamemap--' + stepMap.get(4));
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
                
                Phoenix_Bid__c bid = new Phoenix_Bid__c(id = bidId, Phoenix_Approval_Status__c = nextSteps[0].Phoenix_Approver_Team__c);
                update bid;
                
                 Phoenix_SubmitBidForApprovalCtrl.approvalRequestNotification(bidId , nextSteps);//Added by satya
                //Phoenix_SubmitBidForApprovalCtrl.sendForApproval(bidId,'Approval Required for '+bidName,nextSteps,'Bid_Approval');
            } else {
                Phoenix_Bid__c bid = new Phoenix_Bid__c(id = bidId, Phoenix_Approval_Status__c = 'Closed');
                update bid;
            }
        }
    }
    public class Wrapper {
        
        @AuraEnabled public List < Phoenix_Bid_Line_Item__c > lineItemsList;
        @AuraEnabled public Phoenix_Bid__c bidRecord;
        @AuraEnabled public List < String > productDirectorList;
        @AuraEnabled public string loggedInUserName;
        @AuraEnabled public string loggedInUserId;
        @AuraEnabled public boolean isSCMApprovePerson;
        @AuraEnabled public boolean conditionApproval;
        @AuraEnabled public boolean isVistexApprovePerson;
        @AuraEnabled public boolean isSRxApprovePerson;
        @AuraEnabled public boolean isFinanceApprovePerson;
        @AuraEnabled public boolean isContractsApprovePerson;
        @AuraEnabled public boolean isCustomerServiceApprovePerson;
        @AuraEnabled public string BidContractPerson;
        @AuraEnabled public string isMarketingApprovePerson;
        @AuraEnabled public boolean showProceedBtn;
        @AuraEnabled public boolean showProceedContrBtn;
        @AuraEnabled public boolean showProceedVistexBtn;
        @AuraEnabled public boolean showProceedCusServcBtn;
        Wrapper() {
            
            lineItemsList = new List < Phoenix_Bid_Line_Item__c > ();
            bidRecord = new Phoenix_Bid__c();
            productDirectorList = new list < string > ();
            loggedInUserName = '';
            BidContractPerson = '';
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
    public static list < Phoenix_Bid_Line_Item__c > saveLineItems(List < Phoenix_Bid_Line_Item__c > LineItemList,Phoenix_Bid__c bidRecord) {
        
        if(bidRecord != null)
            update bidRecord;
        String currentUser = [SELECT id, Name FROM User WHERE Id =: UserInfo.getUserId() LIMIT 1].Name;
        for (Phoenix_Bid_Line_Item__c pbl: LineItemList) {
            
            
            /*if(approvalStatus=='Marketing' && pbl.Phoenix_Product_Director1__c == currentUser && isMarketingChanged==true && isMarketingChanged!=null && marketingHeader != '' && marketingHeader !=null){
pbl.Phoenix_Marketing_Approval__c = marketingHeader;
}  
if(approvalStatus=='Contracts' && isApprovalChanged==true && isApprovalChanged!=null && contractApproval != '' && contractApproval !=null){
pbl.Phoenix_Contract_Approval__c = contractApproval;
}  */
            
            pbl.Phoenix_ProposedContractBidPriceMktng__c = pbl.Phoenix_Proposed_IPA_Price__c;
            pbl.Phoenix_Proposed_Direct_Selling_Unit__c = pbl.Phoenix_IDN_Usage__c;
        }
        update LineItemList;
        return LineItemList;
    }
}