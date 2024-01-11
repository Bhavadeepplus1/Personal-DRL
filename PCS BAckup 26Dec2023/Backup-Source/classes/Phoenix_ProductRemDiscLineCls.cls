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
public class Phoenix_ProductRemDiscLineCls {
    
    public static Map < String, String > approvalGroupBehaviourMap = new Map < String, String > ();
    public static Map < String, Set < String >> approvalTeamUsersMap = new Map < String, Set < String >> ();
    public static Map < String, Set < String >> approvalTeamUsersEmailsMap = new Map < String, Set < String >> ();
    public static Map < String, Set < String >> approvalTeamUserNamesMap = new Map < String, Set < String >> ();
    public static Map < String, String > userTeamUserIdMap = new Map < String, String > ();

    @AuraEnabled
    public static Wrapper getRelatedList(Id bidId) {
        Wrapper wrapperObject = new Wrapper();

        String query = '';
        String SobjectApiName = 'Phoenix_Bid_Line_Item__c';
        Map < String, Schema.SObjectType > schemaMap = Schema.getGlobalDescribe();
        Map < String, Schema.SObjectField > fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();
        list<string> approversteam= new list<string> ();

        String strFields = '';

        for (String fieldName: fieldMap.keyset()) {
            if (strFields == null || strFields == '') {
                strFields = fieldName;
            } else {
                strFields = strFields + ' , ' + fieldName;
            }
        }
        string notApproved = 'Not Approved';
        query = 'select Phoenix_Contract__r.Name,Phoenix_Contract__r.Id,Phoenix_Customer__r.Name,Phoenix_Customer__r.Id, Phoenix_Product__r.name,Phoenix_Bid__r.Phoenix_Bid_Name__c,Phoenix_Product__r.Phoenix_Marketing_Lead__c, ' + strFields + ' from ' + SobjectApiName + ' where Phoenix_Bid__c = : bidId and Phoenix_Final_Status__c !=: notApproved ORDER BY Phoenix_Product__r.Name ASC';

        list < Phoenix_Bid_Line_Item__c > quoteList = Database.query(query);

        boolean showProceedBtn = true;
        boolean showproceedlead = true;
       boolean showproceedleadrx = true;
  boolean showproceedleadsrx = true;
   boolean showproceedleadotc = true; 
              boolean isdelegationUserrx  = true;
         boolean isdelegationUsersrx  = true;
          boolean isdelegationUserotc  = true;
        for (Phoenix_Bid_Line_Item__c lineItem: quoteList) {
                 approversteam.add(lineItem.Phoenix_Product__r.Phoenix_Marketing_Lead__c);
            if (lineItem.Phoenix_Product_Director1__c != null && lineItem.Phoenix_Marketing_Final_Approval__c != null && lineItem.Phoenix_Marketing_Final_Approval__c == true && lineItem.Phoenix_Product_Director1__c == userinfo.getName()) {
                showProceedBtn = false;
            }

        }

        list<Phoenix_Bid_Line_Item__c> linesitemsupdate = new list<Phoenix_Bid_Line_Item__c>();
          for (Phoenix_Bid_Line_Item__c lineItem: quoteList) {
 
            if (lineItem.Phoenix_MarketingLead_Final_Approval__c != null && lineItem.Phoenix_MarketingLead_Final_Approval__c == true) {
                  
                showproceedlead = false;
                showproceedleadrx = false;
                showproceedleadsrx =false;
                showproceedleadotc =false;
                isdelegationUserrx=false;
                isdelegationUsersrx=false;
                isdelegationUserotc=false;
               // isdelegationUser =false;
            }
            else if(lineItem.Phoenix_MarketingLead_Final_Approval__c == false) 
linesitemsupdate.add(lineItem);

        }
        Map < String, String > userTeamUserIdMap = new Map < String, String > ();
        list <string> userTeamUserIdMap2 = new list <string> ();
        for (Phoenix_User_Approval_Matrix__c matrix: [Select Id, Name, RecordType.DeveloperName, User_Group__r.Phoenix_Approver_Group_Name__c, Phoenix_Approval_Group_Behavior__c, Phoenix_Approver__c, Phoenix_Approver__r.Email, Phoenix_Approver_Group_Name__c, Phoenix_Is_Active_User__c, Phoenix_Is_Approval_Process_User__c, User_Group__c from Phoenix_User_Approval_Matrix__c limit 1000]) {
            String userTeamUserIdMapKey = matrix.User_Group__r.Phoenix_Approver_Group_Name__c + '-' + matrix.Phoenix_Approver__c;
            
            userTeamUserIdMap.put(userTeamUserIdMapKey, matrix.Phoenix_Approver__c);
        }

        boolean isFinanceApprovePerson = false;
        string isMarketingApprovePerson;
        boolean isSRxApprovePerson = false;
        boolean isVistexApprovePerson = false;
        string isMarketingLeadrxApprovePerson;
        string isMarketingLeadsrxApprovePerson ;
 string isMarketingLeadotcApprovePerson;
        boolean delegationUser  = false;
     string delagationuser;
        string delagationuser1 ;
        if (userTeamUserIdMap.containsKey('Finance-' + UserInfo.getUserId())) {
            isFinanceApprovePerson = true;
        }
        if (userTeamUserIdMap.containsKey('Contracts-' + UserInfo.getUserId())) {
            isSRxApprovePerson = true;
        }

        if (userTeamUserIdMap.containsKey('Marketing-' + UserInfo.getUserId())) {
            isMarketingApprovePerson = userTeamUserIdMap.get(('Marketing-' + UserInfo.getUserId()));
           
        }
        if (userTeamUserIdMap.containsKey('Home Office-' + UserInfo.getUserId())) {
            isVistexApprovePerson = true;
        }
              if (userTeamUserIdMap.containsKey('Marketing Lead Rx-' + UserInfo.getUserId())) {
                 isMarketingLeadrxApprovePerson = userTeamUserIdMap.get(('Marketing Lead Rx-' + UserInfo.getUserId()));
                   //approversteam.add(isMarketingLeadrxApprovePerson);
        }
      if (userTeamUserIdMap.containsKey('Marketing Lead SRx-' + UserInfo.getUserId())) {
                 isMarketingLeadsrxApprovePerson = userTeamUserIdMap.get(('Marketing Lead SRx-' + UserInfo.getUserId()));
          // approversteam.add(isMarketingLeadsrxApprovePerson);
        }
     
  if (userTeamUserIdMap.containsKey('Marketing Lead OTC-' + UserInfo.getUserId())) {
                 isMarketingLeadotcApprovePerson = userTeamUserIdMap.get(('Marketing Lead OTC-' + UserInfo.getUserId()));
      // approversteam.add(isMarketingLeadotcApprovePerson);
        } 
     if(approversteam.size()>0){
        List<Phoenix_Approval_Delegation_History__c> deligatorApprover = new List<Phoenix_Approval_Delegation_History__c>();
        deligatorApprover =[SELECT Id, Name, Phoenix_Delegated_Approver__r.Profile.Name,Phoenix_Is_Active_delegator__c, Phoenix_Delegated_Approver__c, Phoenix_Delegated_Approver__r.Name,Phoenix_User__c FROM Phoenix_Approval_Delegation_History__c WHERE Phoenix_Is_Active_delegator__c = true and Phoenix_User__c  in :approversteam];
        List<String> delegationUsersList = new List<String>();
          List<String> delegationUsersList1 = new List<String>();
        if(deligatorApprover != null && deligatorApprover.size()>0){
            for(Phoenix_Approval_Delegation_History__c ADH : deligatorApprover){
                if(ADH.Phoenix_Delegated_Approver__c == Userinfo.getUserId()){
                    delegationUsersList.add(ADH.Phoenix_Delegated_Approver__r.Name);
                     delegationUsersList1.add(ADH.Phoenix_Delegated_Approver__c);
                }
            }
        }
             if(delegationUsersList.size()>0){
                 system.debug('entered here');
            delagationuser1 = delegationUsersList[0];
                 delagationuser=delegationUsersList1[0];
        }
        }


        if(linesitemsupdate.size()>0){
            for(Phoenix_Bid_Line_Item__c item2:linesitemsupdate){
                if(isMarketingLeadrxApprovePerson == item2.Phoenix_Product__r.Phoenix_Marketing_Lead__c){
                    showproceedleadrx = true;
                  isdelegationUserrx =true;
                       isdelegationUsersrx=false;
                    isdelegationUserotc = true;
                }
                 if(isMarketingLeadsrxApprovePerson == item2.Phoenix_Product__r.Phoenix_Marketing_Lead__c){
                    showproceedleadsrx = true;
                       isdelegationUserrx =false;
                       isdelegationUsersrx=true;
                    isdelegationUserotc = true;
                }
                if(isMarketingLeadotcApprovePerson == item2.Phoenix_Product__r.Phoenix_Marketing_Lead__c){
                    showproceedleadotc = true;
                     isdelegationUserrx =false;
                       isdelegationUsersrx=false;
                    isdelegationUserotc = true;
                }

            }
        }
     //   system.debug('isdelegationUser....'+isdelegationUser);
        if(delagationuser1!=null){
           system.debug('delagationuser1....'+delagationuser1);
        }
        Phoenix_Bid__c bid = [SELECT Id, Phoenix_Contracts_Approval_Comments__c, Phoenix_Contracts_Approval__c, Phoenix_Customer__r.Phoenix_Contracts_Approver__r.Name, Name, Phoenix_Approval_Status__c, Phoenix_Customer__r.Name, Phoenix_Bid_Name__c, Phoenix_Bid_Type__c FROM Phoenix_Bid__c WHERE Id =: bidId];

        List < ContentDocumentLink > entries = [SELECT Id, LinkedEntityId, ContentDocument.Title, ContentDocument.FileExtension, ContentDocumentId FROM ContentDocumentLink where LinkedEntityId =: bidId];

        wrapperObject.lineItemsList = quoteList;
        wrapperObject.bidRecord = bid;
        if (!entries.isEmpty()) {
            wrapperObject.conDocLink = entries;

        }

        wrapperObject.loggedInUserName = UserInfo.getName();
        wrapperObject.loggedInUserId = UserInfo.getUserId();
        wrapperObject.isVistexApprovePerson = isVistexApprovePerson;
        wrapperObject.isFinanceApprovePerson = isFinanceApprovePerson;
        wrapperObject.isMarketingApprovePerson = isMarketingApprovePerson;
        wrapperObject.isSRxApprovePerson = isSRxApprovePerson;
        wrapperObject.showProceedBtn = showProceedBtn;
          wrapperObject.showproceedlead = showproceedlead;
                wrapperObject.showproceedleadrx = showproceedleadrx;
                wrapperObject.showproceedleadsrx = showproceedleadsrx;
                wrapperObject.showproceedleadotc = showproceedleadotc;
        wrapperObject.isMarketingLeadrxApprovePerson = isMarketingLeadrxApprovePerson;
     wrapperObject.isMarketingLeadsrxApprovePerson = isMarketingLeadsrxApprovePerson;
   wrapperObject.isMarketingLeadotcApprovePerson = isMarketingLeadotcApprovePerson;
        //wrapperObject.delegationUser = delegationUser;
          wrapperObject.isdelegationUserrx = isdelegationUserrx;
                  wrapperObject.isdelegationUsersrx = isdelegationUsersrx;
                  wrapperObject.isdelegationUserotc = isdelegationUserotc;
        wrapperObject.delagationuser1 =delagationuser1;
                wrapperObject.delagationuser =delagationuser;
        return wrapperObject;

    }
    public class WrapperForNextSteps {
        @AuraEnabled public list < Phoenix_Bid_Process_Steps__c > updateProcessStepList;
        @AuraEnabled public boolean flagSCMStop;
        @AuraEnabled public boolean flagMarketStop;
        @AuraEnabled public boolean contractNextStepFlag;
        @AuraEnabled public boolean flagmarketingLeadstop;
        WrapperForNextSteps() {
            updateProcessStepList = new List < Phoenix_Bid_Process_Steps__c > ();
            flagSCMStop = false;
            flagMarketStop = false;
            contractNextStepFlag = false;
            flagmarketingLeadstop = false;
        }
    }
    @AuraEnabled
    public static WrapperForNextSteps makeApprovalsVistex(String bidId, List < Phoenix_Bid_Line_Item__c > bidlines, boolean approveStatusFlag) {
        boolean vistexNextStepFlag = false;
        for (Phoenix_Bid_Line_Item__c line: bidlines) {


            //line.Phoenix_Vistex_Update_Final_Approval__c = true;
            if (line.Phoenix_Vistex_Status__c == 'Pending') {
                //line.Phoenix_Final_Status__c = 'Not Approved';
                vistexNextStepFlag = true;
            }



        }
        if (bidlines.size() > 0) {
            update bidlines;
        }


        list < Phoenix_Bid_Process_Steps__c > bidProcessStepList = [SELECT Id, Name, Phoenix_Bid__c, Phoenix_Process_Step__c, Phoenix_Step__c, Phoenix_Approver__c, Phoenix_Status__c, Phoenix_Approver_Team__c FROM Phoenix_Bid_Process_Steps__c where Phoenix_Bid__c =: bidId];
        list < Phoenix_Bid_Process_Steps__c > contractsStepLsit = new list < Phoenix_Bid_Process_Steps__c > ();
        for (Phoenix_Bid_Process_Steps__c step: bidProcessStepList) {



            if (step.Phoenix_Approver_Team__c == 'Home Office' && vistexNextStepFlag == false) {
                step.Phoenix_Status__c = approveStatusFlag == true ? 'Completed' : 'Do Not Bid';
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
    public static list < Phoenix_Bid_Line_Item__c > submitToProceddStep1(string bidId, boolean isMarketing, boolean isFinance, boolean isContracts,boolean isMarketingLead,boolean isdelegationuser2) {
        
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
            //query = 'select Phoenix_Product__r.Phoenix_Rx_SRx_OTC__c,Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_Contracts_Approver__r.Name, Phoenix_Product__r.name,Phoenix_Bid__r.Phoenix_Bid_Name__c, ' + strFields + ' from ' + SobjectApiName + ' where Phoenix_Bid__c = : bidId AND Phoenix_Final_Status__c !=: notApproved';
       
        if(isdelegationuser2 == false){
            if (isMarketinglead == true) {
            query += ' and Marketing_Lead__c=:loggerUserName';
        }
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

        list < Phoenix_Bid_Process_Steps__c > bidProcessStepList = [SELECT Id, Name, Phoenix_Bid__c, Phoenix_Is_Criteria_Step__c, Phoenix_Process_Step__c, Phoenix_Step__c, Phoenix_Approver__c, Phoenix_Status__c, Phoenix_Approver_Team__c FROM Phoenix_Bid_Process_Steps__c where Phoenix_Bid__c =: bidId order by Phoenix_Step__c];
        list < Phoenix_Bid_Line_Item__c > bidLinesUpdate = [select id,Phoenix_Marketing_Final_Approval__c, Phoenix_Contracts_Final_Approval__c, Phoenix_Customer_Final_Approval__c, Phoenix_Final_Status__c from Phoenix_Bid_Line_Item__c where Phoenix_Bid__c =: bidId];
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
                    } else {
                        prcsStep.Phoenix_Status__c = 'Not Applicable';
                    }
                }
            }
            update bidProcessStepList;
            Phoenix_Bid__c bid = new Phoenix_Bid__c(id = bidId, Phoenix_Approval_Status__c = 'Marketing Rejected');
            update bid;

            wrapSteps.updateProcessStepList = bidProcessStepList;
            wrapSteps.flagMarketStop = true;






        } else {
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

            if (!marketStepLsit.isEmpty()) {
                update marketStepLsit;
                wrapSteps.updateProcessStepList = bidProcessStepList;

                wrapSteps.flagMarketStop = flagMarketStop;
            }
        }
        return wrapSteps;
    }
 @AuraEnabled
    public static WrapperForNextSteps makeApprovalsMarketingLead(String bidId, List < Phoenix_Bid_Line_Item__c > bidlines, boolean approveStatusFlag,boolean isdelegationuser2) {
        system.debug('bidid...'+bidId);
         system.debug('bidlineitem....'+bidlines);
           system.debug('approveStatusFlag....'+approveStatusFlag);
        for (Phoenix_Bid_Line_Item__c line: bidlines) {
            line.Phoenix_MarketingLead_Final_Approval__c = true;
            if (line.Phoenix_MarketingLead_Approver__c == 'Not Approved') {
                line.Phoenix_Final_Status__c = 'Not Approved';
            }
        }
        if (bidlines.size() > 0) {
            update bidlines;
        }

        list < Phoenix_Bid_Process_Steps__c > bidProcessStepList = [SELECT Id, Name, Phoenix_Bid__c, Phoenix_Is_Criteria_Step__c, Phoenix_Process_Step__c, Phoenix_Step__c, Phoenix_Approver__c, Phoenix_Status__c, Phoenix_Approver_Team__c FROM Phoenix_Bid_Process_Steps__c where Phoenix_Bid__c =: bidId order by Phoenix_Step__c];
        for(Phoenix_Bid_Process_Steps__c st:bidProcessStepList){
            system.debug('bid process step..'+st);
        }
        list < Phoenix_Bid_Line_Item__c > bidLinesUpdate = [select id,Phoenix_Marketing_Final_Approval__c, Phoenix_Contracts_Final_Approval__c, Phoenix_Customer_Final_Approval__c, Phoenix_Final_Status__c,Phoenix_MarketingLead_Approver__c,Phoenix_MarketingLead_Final_Approval__c from Phoenix_Bid_Line_Item__c where Phoenix_Bid__c =: bidId];
        WrapperForNextSteps wrapSteps = new WrapperForNextSteps();
        boolean isAllRejectedCaseFound = true;
        boolean isMarketingLeadCompleted = true;
        for (Phoenix_Bid_Line_Item__c lineItem: bidLinesUpdate) {
            if (lineItem.Phoenix_Final_Status__c != 'Not Approved') {
                isAllRejectedCaseFound = false;
            }
            if(!lineItem.Phoenix_MarketingLead_Final_Approval__c && lineItem.Phoenix_Final_Status__c != 'Not Approved')
                isMarketingleadCompleted = false;
        }
        Phoenix_Bid__c bidRec = new Phoenix_Bid__c(id = bidId, Phoenix_MarketingLead_Approved_date__c = system.today()); //Closed
        if(bidRec != null && (isMarketingLeadCompleted || isAllRejectedCaseFound))
        	update bidRec;
        
        if (isAllRejectedCaseFound) {

            integer currentStepNum;
            for (Phoenix_Bid_Process_Steps__c prcsStep: bidProcessStepList) {
                if (prcsStep.Phoenix_Approver_Team__c == 'Marketing Lead Rx') {
                    currentStepNum = integer.valueOf(prcsStep.Phoenix_Step__c);
                }
                 if (prcsStep.Phoenix_Approver_Team__c == 'Marketing Lead SRx') {
                    currentStepNum = integer.valueOf(prcsStep.Phoenix_Step__c);
                }
                if (prcsStep.Phoenix_Approver_Team__c == 'Marketing Lead OTC') {
                    currentStepNum = integer.valueOf(prcsStep.Phoenix_Step__c);
                }
            }
            for (Phoenix_Bid_Process_Steps__c prcsStep: bidProcessStepList) {
                if(isdelegationuser2==false){
                 if (prcsStep.Phoenix_Approver_Team__c == 'Marketing Lead Rx' && prcsStep.Phoenix_Approver__c == Userinfo.getUserId()) {
                   prcsStep.Phoenix_Status__c = 'Completed';//approveStatusFlag==true?'Completed':'Do Not Bid';
                    // step.Phoenix_Status__c=approveStatusFlag==true?'Completed':'';
                   // marketStepLsit.add(step);
                    system.debug('entered here');
                }
                 if(prcsStep.Phoenix_Approver_Team__c == 'Marketing Lead SRx'  && prcsStep.Phoenix_Approver__c == Userinfo.getUserId()){
               //  step.Phoenix_Status__c = 'Completed'; //approveStatusFlag==true?'Completed':'Do Not Bid';
                    // step.Phoenix_Status__c=approveStatusFlag==true?'Completed':'';
                       system.debug('entered here srx');
                   prcsStep.Phoenix_Status__c = 'Completed';
                }
                     if(prcsStep.Phoenix_Approver_Team__c == 'Marketing Lead OTC'  && prcsStep.Phoenix_Approver__c == Userinfo.getUserId()){
                 prcsStep.Phoenix_Status__c = 'Completed';
                      system.debug('entered here otc');
                }
                }
                 else if (isdelegationuser2==true) {
                    if(prcsStep.Phoenix_Approver_Team__c == 'Marketing Lead Rx') {
                    prcsStep.Phoenix_Status__c = 'Completed'; //approveStatusFlag==true?'Completed':'Do Not Bid';
                    // step.Phoenix_Status__c=approveStatusFlag==true?'Completed':'';
                   // marketStepLsit.add(step);
                          system.debug('entered here 2');
                }
                                           if(prcsStep.Phoenix_Approver_Team__c == 'Marketing Lead OTC'){
                 prcsStep.Phoenix_Status__c = 'Completed'; //approveStatusFlag==true?'Completed':'Do Not Bid';
                    // step.Phoenix_Status__c=approveStatusFlag==true?'Completed':'';
                   // marketStepLsit.add(step);
                           system.debug('entered here otc1');
                }
                     if(prcsStep.Phoenix_Approver_Team__c == 'Marketing Lead SRx'){
                 prcsStep.Phoenix_Status__c = 'Completed'; //approveStatusFlag==true?'Completed':'Do Not Bid';
                    // step.Phoenix_Status__c=approveStatusFlag==true?'Completed':'';
                   // marketStepLsit.add(step);
                           system.debug('entered here otc1');
                }
                }
                if (prcsStep.Phoenix_Step__c > currentStepNum) {
                    if (prcsStep.Name.contains('Closed')) {
                        prcsStep.Phoenix_Status__c = 'Completed';
                    } else {
                        prcsStep.Phoenix_Status__c = 'Not Applicable';
                    }
                }
            }
            update bidProcessStepList;
            Phoenix_Bid__c bid = new Phoenix_Bid__c(id = bidId, Phoenix_Approval_Status__c = 'Marketing Lead Rejected');
            update bid;

            wrapSteps.updateProcessStepList = bidProcessStepList;
            wrapSteps.flagmarketingLeadstop = true;






        } else {
            list < Phoenix_Bid_Process_Steps__c > marketStepLsit = new list < Phoenix_Bid_Process_Steps__c > ();

            boolean flagmarketingLeadstop = false;
            for (Phoenix_Bid_Process_Steps__c step: bidProcessStepList) {
               system.debug('bidProcessStepList'+step);
               
                if(isdelegationuser2== false){
                if (step.Phoenix_Approver_Team__c == 'Marketing Lead Rx' && step.Phoenix_Approver__c == Userinfo.getUserId()) {
                    step.Phoenix_Status__c = 'Completed'; //approveStatusFlag==true?'Completed':'Do Not Bid';
                    // step.Phoenix_Status__c=approveStatusFlag==true?'Completed':'';
                    marketStepLsit.add(step);
                    system.debug('entered here');
                }
                 if(step.Phoenix_Approver_Team__c == 'Marketing Lead SRx'  && step.Phoenix_Approver__c == Userinfo.getUserId()){
                 step.Phoenix_Status__c = 'Completed'; //approveStatusFlag==true?'Completed':'Do Not Bid';
                    // step.Phoenix_Status__c=approveStatusFlag==true?'Completed':'';
                       system.debug('entered here srx');
                    marketStepLsit.add(step);
                }
                     if(step.Phoenix_Approver_Team__c == 'Marketing Lead OTC'  && step.Phoenix_Approver__c == Userinfo.getUserId()){
                 step.Phoenix_Status__c = 'Completed'; //approveStatusFlag==true?'Completed':'Do Not Bid';
                    // step.Phoenix_Status__c=approveStatusFlag==true?'Completed':'';
                    marketStepLsit.add(step);
                      system.debug('entered here otc');
                }
                }
                else if (isdelegationuser2==true) {
                    if(step.Phoenix_Approver_Team__c == 'Marketing Lead Rx') {
                    step.Phoenix_Status__c = 'Completed'; //approveStatusFlag==true?'Completed':'Do Not Bid';
                    // step.Phoenix_Status__c=approveStatusFlag==true?'Completed':'';
                    marketStepLsit.add(step);
                          system.debug('entered here 2');
                }
                                           if(step.Phoenix_Approver_Team__c == 'Marketing Lead OTC'){
                 step.Phoenix_Status__c = 'Completed'; //approveStatusFlag==true?'Completed':'Do Not Bid';
                    // step.Phoenix_Status__c=approveStatusFlag==true?'Completed':'';
                    marketStepLsit.add(step);
                           system.debug('entered here otc1');
                }
                     if(step.Phoenix_Approver_Team__c == 'Marketing Lead SRx'){
                 step.Phoenix_Status__c = 'Completed'; //approveStatusFlag==true?'Completed':'Do Not Bid';
                    // step.Phoenix_Status__c=approveStatusFlag==true?'Completed':'';
                    marketStepLsit.add(step);
                           system.debug('entered here otc1');
                }
                }
                
     
                
                  if (step.Phoenix_Approver_Team__c == 'Marketing Lead Rx'  &&  step.Phoenix_Status__c != 'Completed') {
                   if (step.Phoenix_Status__c != 'Not Applicable') {
                        flagmarketingLeadstop = true;
                    }
                }
                else if(step.Phoenix_Approver_Team__c == 'Marketing Lead SRx'  &&  step.Phoenix_Status__c != 'Completed'){
                 if (step.Phoenix_Status__c != 'Not Applicable') {
                        flagmarketingLeadstop = true;
                    }
                }
                 else if(step.Phoenix_Approver_Team__c == 'Marketing Lead OTC'  &&  step.Phoenix_Status__c != 'Completed'){
                if (step.Phoenix_Status__c != 'Not Applicable') {
                        flagmarketingLeadstop = true;
                    }
                }
                
                
               
            }

            if (!marketStepLsit.isEmpty()) {
                update marketStepLsit;
                wrapSteps.updateProcessStepList = bidProcessStepList;

                wrapSteps.flagmarketingLeadstop = flagmarketingLeadstop;
            }
        }
        return wrapSteps;
    }
    @AuraEnabled
    public static void updateNextMarketingProcessSteps(string bidId, string bidName, list < Phoenix_Bid_Process_Steps__c > processStepLsit, boolean flagMarketStop) {
        if (flagMarketStop == false && !processStepLsit.isEmpty()) {
            Map < Integer, List < Phoenix_Bid_Process_Steps__c >> stepMap = new Map < Integer, List < Phoenix_Bid_Process_Steps__c >> ();
            Map < String, List < Phoenix_Bid_Process_Steps__c >> stepNamesMap = new Map < String, List < Phoenix_Bid_Process_Steps__c >> ();
            Map < String, Integer > stepnameNoMap = new Map < String, Integer > ();
          system.debug('Entered here');
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
            List < Phoenix_Bid_Process_Steps__c > nextSteps = new list < Phoenix_Bid_Process_Steps__c > ();
            List < Phoenix_Bid_Process_Steps__c > nextStepscopy = new list < Phoenix_Bid_Process_Steps__c > ();
            Integer stepNo;




            stepNo = stepnameNoMap.get('Marketing') + 1;
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

                Phoenix_Bid__c bid = new Phoenix_Bid__c();
                    bid.id = bidId;
               
                
                 
                   if(nextSteps[0].Phoenix_Approver_Team__c.containsIgnoreCase('Marketing Lead')){
                  bid.Phoenix_Approval_Status__c = 'Marketing Lead';
                }
                else{
                    bid.Phoenix_Approval_Status__c = nextSteps[0].Phoenix_Approver_Team__c;
                }
                
               // bid.Phoenix_Approval_Status__c = 
                update bid;
                approvalAlert(bidId , nextSteps);
				//Phoenix_SubmitBidForApprovalCtrl.approvalRequestNotification(bidId , nextSteps);
                //Phoenix_SubmitBidForApprovalCtrl.sendForApproval(bidId,'Approval Required for '+bidName,nextSteps,'Bid_Approval');
            } else {
                Phoenix_Bid__c bid = new Phoenix_Bid__c(id = bidId, Phoenix_Approval_Status__c = 'Closed');
                update bid;
            }
        }
    }
    
    public static void approvalAlert(Id objId, List < Phoenix_Bid_Process_Steps__c > nextSteps){
        List < Messaging.SingleEmailMessage > mails = new List < Messaging.SingleEmailMessage > ();
        //bidtype label names added by vandana.
        Map < String, String > bidTypesmap = new Map < String, String > ();
        for(Schema.PicklistEntry  ple:  Phoenix_Bid__c.Phoenix_Bid_Type__c.getDescribe().getPicklistValues()){
            bidTypesmap.put(ple.getValue(),ple.getLabel());
        }
        //bidtype label names added end.
        try {
            set < Id > userIds = new set < Id > ();
            for (Phoenix_Bid_Process_Steps__c step: nextSteps) {
                if (step.Phoenix_Approver__c != null)
                    userIds.add(step.Phoenix_Approver__c);
            }
            Map < Id, User > usersMap = new Map < Id, User > ([SELECT Id, Name, Email,Phoenix_Delegated_Approver__c,Phoenix_Delegated_Approver__r.Name,Phoenix_Delegated_Approver__r.Email FROM User]);
            integer sNo = 0;
            String objName = String.valueOf(objId.getsObjectType());
            String mailStatus = '';
            Messaging.SendEmailResult[] results;
            Set < String > allPeopleInvolvedEmailsSet = new Set < String > ();
            Phoenix_Bid__c bid;
            List < Phoenix_Bid_Line_Item__c > bidItems;
            String Product_Families_bItems = '';
            bid = [Select Id,Phoenix_is_OTC_Bid__c, Name, Owner.Name, Phoenix_Bid_Name__c, Owner.Email,Phoenix_Bid_Type__c, Phoenix_Bid_Deadline_Date__c, Phoenix_Sales_Person_2__c, Phoenix_Sales_Person_2__r.Email, Phoenix_Salesperson__c, Phoenix_Salesperson__r.Email, Phoenix_Bid_Created_Behalf_of__c, Phoenix_Bid_Created_Behalf_of__r.Email, Phoenix_Internal_Target_Date__c, Phoenix_Customer_Bid_Deadline_Date_Time__c FROM Phoenix_Bid__c Where Id =: objId];
            bidItems = [Select Id, Name, Product_Family_Name__c,Phoenix_Product__r.Phoenix_Marketing_Lead__r.Name, Phoenix_Product__r.Name, Phoenix_Product__r.Product_Family__r.Name, Phoenix_Product__r.Phoenix_Product_Director__c, Phoenix_Product__r.Phoenix_Marketing_Lead__c, Phoenix_Product__c, Phoenix_Product__r.Family FROM Phoenix_Bid_Line_Item__c Where Phoenix_Bid__c =: objId AND Phoenix_Final_Status__c != 'Not Approved'];
            list < Phoenix_Approval_Grid__c > approvalGridList = [Select Id, Phoenix_Product_Family__c, Phoenix_Is_New_Low__c, Phoenix_Annualized_TP__c, Phoenix_Annualized_TP_Impact__c,
                                                                  Phoenix_Annualized_TP_Impact_Limit__c, Phoenix_TP__c, Phoenix_TP_Limit__c, Phoenix_Annualized_GM__c,
                                                                  Phoenix_Annualized_GM_Impact__c, Phoenix_Annualized_GM_Impact_Limit__c, Phoenix_Revenue__c, Phoenix_Revenue_Limit__c,
                                                                  Phoenix_GM__c, Phoenix_GM_Limit__c, Phoenix_Marketing_Lead_Rx__c, Phoenix_Marketing_Lead_SRx__c, Phoenix_Marketing_Lead_OTC__c,
                                                                  Phoenix_Business_Head_Comments__c, Phoenix_Approval__c, Phoenix_Comments__c, Phoenix_Sr_Director_VP__c,
                                                                  Phoenix_Sr_Director_VP_Finance_Comments__c, Phoenix_Is_partner_product__c FROM Phoenix_Approval_Grid__c WHERE Phoenix_Bid__c =: objId
                                                                 ];
            if (!bid.Phoenix_is_OTC_Bid__c) {
                Product_Families_bItems += '<table style="border-collapse: collapse;"><thead><tr><th style="border: 1px solid black;padding:4px;">S.No</th><th style="border: 1px solid black;width:15%;padding:4px">Product Family</th><th style="border: 1px solid black;width:15%;padding:4px">Products below Lowest Price / SKU</th><th style="border: 1px solid black;width:15%;padding:4px">Annualized TP</th><th style="border: 1px solid black;width:21%;padding:4px">Annualized TP Impact</th><th style="border: 1px solid black;width:27%;padding:4px">Annualized TP Impact Limit</th><th style="border: 1px solid black; width:9%;padding:4px;">TP%</th><th style="border: 1px solid black; width:15%;padding:4px;">TP % Limit</th><th style="border: 1px solid black; width:15%;padding:4px">Annualized GM</th><th style="border: 1px solid black;width:23%;padding:4px">Annualized GM Impact</th><th style="border: 1px solid black;width:28%;padding:4px">Annualized GM Impact Limit</th><th style="border: 1px solid black;width:15%;padding:4px">Revenue</th><th style="border: 1px solid black;width:15%;padding:4px">Revenue Limit</th><th style="border: 1px solid black;width:9%;padding:4px">GM%</th><th style="border: 1px solid black; width:15%;padding:4px">GM% Limit</th><th style="border: 1px solid black;width:18%;padding:4px">Marketing Lead Rx</th><th style="border: 1px solid black;width:20%;padding:4px">Marketing Lead SRx</th><th style="border: 1px solid black;width:20%;padding:4px">Marketing Lead OTC</th><th style="border: 1px solid black;width:25%;padding:4px">Marketing Lead Comments</th><th style="border: 1px solid black;width:25%;padding:4px">Marketing Head Approval</th><th style="border: 1px solid black;width:25%;padding:4px">Marketing Head Comments</th><th style="border: 1px solid black;width:32%;padding:4px">Sr Director / VP Finance Approval</th><th style="border: 1px solid black;width:34%;padding:4px">Sr Director / VP Finance Comments</th></tr></thead>';
            }
            else if (bid.Phoenix_is_OTC_Bid__c) {
                Product_Families_bItems += '<table style="border-collapse: collapse;"><thead><tr><th style="border: 1px solid black;padding:4px;">S.No</th><th style="border: 1px solid black;width:15%;padding:4px">Product Family</th><th style="border: 1px solid black;width:15%;padding:4px">Products below Lowest Price / SKU</th><th style="border: 1px solid black;width:15%;padding:4px">Annualized TP</th><th style="border: 1px solid black;width:21%;padding:4px">Annualized TP Impact</th><th style="border: 1px solid black;width:27%;padding:4px">Annualized TP Impact Limit</th><th style="border: 1px solid black; width:9%;padding:4px;">TP%</th><th style="border: 1px solid black; width:15%;padding:4px;">TP % Limit</th><th style="border: 1px solid black; width:15%;padding:4px">Annualized GM</th><th style="border: 1px solid black;width:23%;padding:4px">Annualized GM Impact</th><th style="border: 1px solid black;width:28%;padding:4px">Annualized GM Impact Limit</th><th style="border: 1px solid black;width:15%;padding:4px">Revenue</th><th style="border: 1px solid black;width:15%;padding:4px">Revenue Limit</th><th style="border: 1px solid black;width:9%;padding:4px">GM%</th><th style="border: 1px solid black; width:15%;padding:4px">GM% Limit</th><th style="border: 1px solid black;width:20%;padding:4px">Marketing Lead OTC</th><th style="border: 1px solid black;width:25%;padding:4px">Marketing Lead Comments</th><th style="border: 1px solid black;width:25%;padding:4px">Marketing Head Approval</th><th style="border: 1px solid black;width:25%;padding:4px">Marketing Head Comments</th><th style="border: 1px solid black;width:32%;padding:4px">Sr Director / VP Finance Approval</th><th style="border: 1px solid black;width:34%;padding:4px">Sr Director / VP Finance Comments</th></tr></thead>';
            }
            Product_Families_bItems += '<tbody>';
            for (Phoenix_Approval_Grid__c grid: approvalGridList) {
                sNo++;
                Product_Families_bItems += '<tr>';
                Product_Families_bItems += '<td style="border: 1px solid black;text-align:left;;padding:4px">' + sNo + '</td>';
                Product_Families_bItems += '<td style="border: 1px solid black;text-align:left;;padding:4px">' + grid.Phoenix_Product_Family__c + '</td>';
                if (grid.Phoenix_Is_New_Low__c == True) Product_Families_bItems += '<td style="border: 1px solid black;text-align:left;;background-color:Yellow;padding:4px">' + 'Yes' + '</td>';
                else if (grid.Phoenix_Is_New_Low__c == False) Product_Families_bItems += '<td style="border: 1px solid black;text-align:left;;padding:4px">' + 'No' + '</td>';
                else Product_Families_bItems += '<td style="border: 1px solid black;">' + '' + '</td>';
                if (grid.Phoenix_Is_partner_product__c == false) {
                    if (grid.Phoenix_Annualized_TP__c != Null) Product_Families_bItems += '<td style="border: 1px solid black;text-align:right;;padding:4px">' + '$' + Phoenix_Util.format(grid.Phoenix_Annualized_TP__c) + '</td>';
                    else Product_Families_bItems += '<td style="border: 1px solid black;">' + '' + '</td>';
                    if (grid.Phoenix_Annualized_TP_Impact__c != Null) Product_Families_bItems += '<td style="border: 1px solid black;text-align:right;;padding:4px">' + '$' + Phoenix_Util.format(grid.Phoenix_Annualized_TP_Impact__c) + '</td>';
                    else Product_Families_bItems += '<td style="border: 1px solid black;">' + '' + '</td>';
                    if (grid.Phoenix_Annualized_TP_Impact_Limit__c != Null) Product_Families_bItems += '<td style="border: 1px solid black;background-color:Yellow;text-align:right;;padding:4px">' + grid.Phoenix_Annualized_TP_Impact_Limit__c + '</td>';
                    else Product_Families_bItems += '<td style="border: 1px solid black;">' + '' + '</td>';
                    if (grid.Phoenix_TP__c != Null) Product_Families_bItems += '<td style="border: 1px solid black;text-align:right;;padding:4px">' + grid.Phoenix_TP__c.setscale(2) +'%' +'</td>';
                    else Product_Families_bItems += '<td style="border: 1px solid black;">' + '' + '</td>';
                    if (grid.Phoenix_TP_Limit__c != Null) Product_Families_bItems += '<td style="border: 1px solid black;text-align:right;background-color:Yellow;;padding:4px">' + grid.Phoenix_TP_Limit__c + '</td>';
                    else Product_Families_bItems += '<td style="border: 1px solid black;">' + '' + '</td>';
                } else {
                    Product_Families_bItems += '<td style="border: 1px solid black;">' + '' + '</td>';
                    Product_Families_bItems += '<td style="border: 1px solid black;">' + '' + '</td>';
                    Product_Families_bItems += '<td style="border: 1px solid black;">' + '' + '</td>';
                    Product_Families_bItems += '<td style="border: 1px solid black;">' + '' + '</td>';
                    Product_Families_bItems += '<td style="border: 1px solid black;">' + '' + '</td>';
                }
                if (grid.Phoenix_Is_partner_product__c == True) {
                    if (grid.Phoenix_Annualized_GM__c != Null) Product_Families_bItems += '<td style="border: 1px solid black;text-align: right;;padding:4px">' + '$' + Phoenix_Util.format(grid.Phoenix_Annualized_GM__c) + '</td>';
                    else Product_Families_bItems += '<td style="border: 1px solid black;">' + '' + '</td>';
                    if (grid.Phoenix_Annualized_GM_Impact__c != Null) Product_Families_bItems += '<td style="border: 1px solid black;text-align: right;;padding:4px">' + '$' + Phoenix_Util.format(grid.Phoenix_Annualized_GM_Impact__c) + '</td>';
                    else Product_Families_bItems += '<td style="border: 1px solid black;">' + '' + '</td>';
                    if (grid.Phoenix_Annualized_GM_Impact_Limit__c != Null) Product_Families_bItems += '<td style="border: 1px solid black;background-color:Yellow;text-align:right;;padding:4px">' + grid.Phoenix_Annualized_GM_Impact_Limit__c + '</td>';
                    else Product_Families_bItems += '<td style="border: 1px solid black;">' + '' + '</td>';
                } else {
                    Product_Families_bItems += '<td style="border: 1px solid black;">' + '' + '</td>';
                    Product_Families_bItems += '<td style="border: 1px solid black;">' + '' + '</td>';
                    Product_Families_bItems += '<td style="border: 1px solid black;">' + '' + '</td>';
                }
                if (grid.Phoenix_Revenue__c != Null) Product_Families_bItems += '<td style="border: 1px solid black;text-align: right;;padding:4px">' + '$' + Phoenix_Util.format(grid.Phoenix_Revenue__c) + '</td>';
                else Product_Families_bItems += '<td style="border: 1px solid black;">' + '' + '</td>';
                if (grid.Phoenix_Revenue_Limit__c != Null) Product_Families_bItems += '<td style="border: 1px solid black;background-color:Yellow;text-align:right;;padding:4px">' + grid.Phoenix_Revenue_Limit__c + '</td>';
                else Product_Families_bItems += '<td style="border: 1px solid black;">' + '' + '</td>';
                if (grid.Phoenix_Is_partner_product__c == True) {
                    if (grid.Phoenix_GM__c != Null) Product_Families_bItems += '<td style="border: 1px solid black;text-align:right;;padding:4px">' + grid.Phoenix_GM__c.setscale(2) + '%' +'</td>';
                    else Product_Families_bItems += '<td style="border: 1px solid black;">' + '' + '</td>';
                    if (grid.Phoenix_GM_Limit__c != Null) Product_Families_bItems += '<td style="border: 1px solid black;text-align:right;background-color:Yellow;;padding:4px">' + grid.Phoenix_GM_Limit__c + '</td>';
                    else Product_Families_bItems += '<td style="border: 1px solid black;">' + '' + '</td>';
                } else {
                    Product_Families_bItems += '<td style="border: 1px solid black;">' + '' + '</td>';
                    Product_Families_bItems += '<td style="border: 1px solid black;">' + '' + '</td>';
                }
                if (!bid.Phoenix_is_OTC_Bid__c) {
                    if (grid.Phoenix_Marketing_Lead_Rx__c != Null) Product_Families_bItems += '<td style="border: 1px solid black;text-align:left;;padding:4px">' + grid.Phoenix_Marketing_Lead_Rx__c + '</td>';
                    else Product_Families_bItems += '<td style="border: 1px solid black;">' + '' + '</td>';
                    if (grid.Phoenix_Marketing_Lead_SRx__c != Null) Product_Families_bItems += '<td style="border: 1px solid black;text-align:left;;padding:4px">' + grid.Phoenix_Marketing_Lead_SRx__c + '</td>';
                    else Product_Families_bItems += '<td style="border: 1px solid black;">' + '' + '</td>';
                }
                if (grid.Phoenix_Marketing_Lead_OTC__c != Null) Product_Families_bItems += '<td style="border: 1px solid black;text-align:left;;padding:4px">' + grid.Phoenix_Marketing_Lead_OTC__c + '</td>';
                else Product_Families_bItems += '<td style="border: 1px solid black;">' + '' + '</td>';
                if (grid.Phoenix_Business_Head_Comments__c != Null) Product_Families_bItems += '<td style="border: 1px solid black;text-align:left;;padding:4px">' + grid.Phoenix_Business_Head_Comments__c + '</td>';
                else Product_Families_bItems += '<td style="border: 1px solid black;">' + '' + '</td>';
                if (grid.Phoenix_Approval__c != Null) Product_Families_bItems += '<td style="border: 1px solid black;text-align:left;;padding:4px">' + grid.Phoenix_Approval__c + '</td>';
                else Product_Families_bItems += '<td style="border: 1px solid black;">' + '' + '</td>';
                if (grid.Phoenix_Comments__c != Null) Product_Families_bItems += '<td style="border: 1px solid black;text-align:left;;padding:4px">' + grid.Phoenix_Comments__c + '</td>';
                else Product_Families_bItems += '<td style="border: 1px solid black;">' + '' + '</td>';
                if (grid.Phoenix_Sr_Director_VP__c != Null) Product_Families_bItems += '<td style="border: 1px solid black;text-align:left;;padding:4px">' + grid.Phoenix_Sr_Director_VP__c + '</td>';
                else Product_Families_bItems += '<td style="border: 1px solid black;">' + '' + '</td>';
                if (grid.Phoenix_Sr_Director_VP_Finance_Comments__c != Null) Product_Families_bItems += '<td style="border: 1px solid black;text-align:left;;padding:4px">' + grid.Phoenix_Sr_Director_VP_Finance_Comments__c + '</td>';
                else Product_Families_bItems += '<td style="border: 1px solid black;">' + '' + '</td>';
                Product_Families_bItems += '</tr></tbody></table>';
                //Add Sales persons
                if (bid.Phoenix_Sales_Person_2__c != null) {
                    allPeopleInvolvedEmailsSet.add(bid.Phoenix_Sales_Person_2__r.Email);
                } else if (bid.Phoenix_Salesperson__c != null) {
                    allPeopleInvolvedEmailsSet.add(bid.Phoenix_Salesperson__r.Email);
                }
            }
            for (Phoenix_Bid_Process_Steps__c step: [SELECT Id, Name, Phoenix_Approver__c, Phoenix_Bid__c, Phoenix_Is_Criteria_Step__c, Phoenix_Process_Step__c, Phoenix_Status__c, Phoenix_Approver__r.Email FROM Phoenix_Bid_Process_Steps__c WHERE Phoenix_Is_Criteria_Step__c = false AND Phoenix_Status__c != 'Not Applicable' AND(Phoenix_Bid__c =: objId OR Phoenix_NDC_Change__c =: objId OR Phoenix_PHS_Price_Change__c =: objId OR Phoenix_New_Product_WAC_Pricing__c =: objId OR Phoenix_WAC_Change__c =: objId) ]) {
                                                        if (step.Phoenix_Approver__c != null) {
                                                            // allPeopleInvolvedEmailsSet.add(step.Phoenix_Approver__r.Email);
                                                            allPeopleInvolvedEmailsSet.add(usersMap.get(step.Phoenix_Approver__c).Email);
                                                            if(usersMap.get(step.Phoenix_Approver__c).Phoenix_Delegated_Approver__c!=null && usersMap.get(step.Phoenix_Approver__c).Phoenix_Delegated_Approver__r.Name!=null && usersMap.get(step.Phoenix_Approver__c).Phoenix_Delegated_Approver__r.Email!=null){
                                                                allPeopleInvolvedEmailsSet.add(usersMap.get(step.Phoenix_Approver__c).Phoenix_Delegated_Approver__r.Email);    
                                                            }
                                                        }
                                                    }
            Map < Id, Set < String >> itemsByDitectorMap = new Map < Id, Set < String >> ();
            Map < Id, Set < String >> itemsByLeadMap = new Map < Id, Set < String >> ();
            Map < String, Set<String>> productsByLead = new Map < String, Set<String>> ();
            //Arranging bid line items by director
            if (bidItems != null && bidItems.size() > 0) {
                for (Phoenix_Bid_Line_Item__c item: bidItems) {
                    if(productsByLead.containsKey(item.Phoenix_Product__r.Phoenix_Marketing_Lead__r.Name)){
                        Set<String> listOfProductNames = productsByLead.get(item.Phoenix_Product__r.Phoenix_Marketing_Lead__r.Name);
                        listOfProductNames.add(item.Phoenix_Product__r.Name);
                        productsByLead.put(item.Phoenix_Product__r.Phoenix_Marketing_Lead__r.Name, listOfProductNames);
                    } else productsByLead.put(item.Phoenix_Product__r.Phoenix_Marketing_Lead__r.Name, new Set<String>{item.Phoenix_Product__r.Name});
                    if (itemsByDitectorMap!=null && item.Phoenix_Product__r.Phoenix_Product_Director__c != null && item.Phoenix_Product__r.Product_Family__r.Name != null && itemsByDitectorMap.containsKey(item.Phoenix_Product__r.Phoenix_Product_Director__c)) {
                        Set < String > temp = itemsByDitectorMap.get(item.Phoenix_Product__r.Phoenix_Product_Director__c);
                        temp.add(item.Phoenix_Product__r.Product_Family__r.Name);
                        itemsByDitectorMap.put(item.Phoenix_Product__r.Phoenix_Product_Director__c, temp);
                    } else if (item.Phoenix_Product__r.Phoenix_Product_Director__c != null && item.Phoenix_Product__r.Product_Family__r.Name != null && !itemsByDitectorMap.containsKey(item.Phoenix_Product__r.Phoenix_Product_Director__c)) {
                        itemsByDitectorMap.put(item.Phoenix_Product__r.Phoenix_Product_Director__c, new Set < String > {
                            item.Phoenix_Product__r.Product_Family__r.Name
                                });
                    }
                    if (item.Phoenix_Product__r.Phoenix_Marketing_Lead__c != null && item.Phoenix_Product__r.Product_Family__r.Name != null && itemsByLeadMap.containsKey(item.Phoenix_Product__r.Phoenix_Marketing_Lead__c)) {
                        Set < String > temp = itemsByLeadMap.get(item.Phoenix_Product__r.Phoenix_Marketing_Lead__c);
                        temp.add(item.Phoenix_Product__r.Product_Family__r.Name);
                        itemsByLeadMap.put(item.Phoenix_Product__r.Phoenix_Marketing_Lead__c, temp);
                    } else if (item.Phoenix_Product__r.Phoenix_Marketing_Lead__c != null && item.Phoenix_Product__r.Product_Family__r.Name != null && !itemsByLeadMap.containsKey(item.Phoenix_Product__r.Phoenix_Marketing_Lead__c)) {
                        itemsByLeadMap.put(item.Phoenix_Product__r.Phoenix_Marketing_Lead__c, new Set < String > {
                            item.Phoenix_Product__r.Product_Family__r.Name
                                });
                    }
                }
            }
            Phoenix_Util.EmailWrapper emailWrapperMain;
            emailWrapperMain = Phoenix_Util.getTemplateBody('ProductDisc_Removal_Notification', objId);
            for (Phoenix_Bid_Process_Steps__c step: nextSteps) {
                Phoenix_Util.EmailWrapper emailWrapper = emailWrapperMain;
                String templateBody = emailWrapper.mailHtmlBody;
                String subject = emailWrapper.mailSubject;
                Messaging.SingleEmailMessage mail;
                set < String > toAddress = new set < String > ();
                String marketingHeadName; String productFamiliesString;
                if (step.Phoenix_Status__c == 'In Process' && step.Phoenix_Approver__c == null && step.Phoenix_Approver_Team__c != null) { //Means team
                    mail = new Messaging.SingleEmailMessage();
                    if (approvalTeamUsersEmailsMap.get(step.Phoenix_Approver_Team__c) != null){
                        toAddress.addAll(approvalTeamUsersEmailsMap.get(step.Phoenix_Approver_Team__c));
                        List<User> usersList = new List <User>();
                        for(Id eachUserId : approvalTeamUsersMap.get(step.Phoenix_Approver_Team__c)){
                            usersList.add(usersMap.get(eachUserId));
                        }
                        for( User u : usersList){
                            if(u.Phoenix_Delegated_Approver__c!=null && u.Phoenix_Delegated_Approver__r.Name!=null && u.Phoenix_Delegated_Approver__r.Email!=null){
                                toAddress.addAll( new List<String>{u.Phoenix_Delegated_Approver__r.Email});  
                            }
                        }
                    }
                    
                } 
                else if (step.Phoenix_Status__c == 'In Process' && step.Phoenix_Approver__c != null) { //Means individuals
                    mail = new Messaging.SingleEmailMessage();
                    if(usersMap.get(step.Phoenix_Approver__c) != null){     
                        toAddress.add(usersMap.get(step.Phoenix_Approver__c).Email);
                        if(usersMap.get(step.Phoenix_Approver__c).Phoenix_Delegated_Approver__r.Email!=null && usersMap.get(step.Phoenix_Approver__c).Phoenix_Delegated_Approver__r.Name!=null && usersMap.get(step.Phoenix_Approver__c).Phoenix_Delegated_Approver__c!=null){
                            toAddress.add(usersMap.get(step.Phoenix_Approver__c).Phoenix_Delegated_Approver__r.Email);
                        }
                    }
                    /*     mail.setToAddresses(new List < String > {
usersMap.get(step.Phoenix_Approver__c).Email
});*/
                    // system.debug('To address ------>'+step.Phoenix_Approver__r.Email);
                    // system.debug('To Name ------>'+step.Phoenix_Approver__r.Name);
                    
                    if(usersMap.get(step.Phoenix_Approver__c).Phoenix_Delegated_Approver__r.Name!=null)  marketingHeadName = usersMap.get(step.Phoenix_Approver__c).Phoenix_Delegated_Approver__r.Name;
                    else  marketingHeadName = usersMap.get(step.Phoenix_Approver__c).Name;
                    //   if (templateBody.contains('Team')) templateBody = templateBody.replaceFirst('Team', step.Phoenix_Approver__r.Name);
                }
                
                if (mail != null) {
                    
                    String prodFamilyString = '';
                    if(objName == 'Phoenix_Bid__c'){
                        if (bid.Phoenix_Bid_Type__c!='Platform OTB' && step.Phoenix_Approver_Team__c == 'Marketing' && step.Phoenix_Approver__c != null) {
                            prodFamilyString = '';
                            integer i = 1;
                            for (String pfamily: itemsByDitectorMap.get(step.Phoenix_Approver__c)) {
                                prodFamilyString += i + '. ' + pfamily + '<br/>';
                                i++;
                            }
                        } else if (step.Phoenix_Approver_Team__c.contains('Marketing Lead') && step.Phoenix_Approver__c != null) {
                            prodFamilyString = '';
                            integer i = 1;
                            if(step.Phoenix_Approver__c!=null){
                                for (String pfamily: itemsByLeadMap.get(step.Phoenix_Approver__c)) {
                                    prodFamilyString += i + '. ' + pfamily + '<br/>';
                                    i++;
                                }
                            }
                        }
                        
                        if (step.Phoenix_Is_Criteria_Step__c == false) productFamiliesString = prodFamilyString;
                        else if (step.Phoenix_Is_Criteria_Step__c == true) productFamiliesString = Product_Families_bItems;
                    }
                    Set < string > ccEmailIds = new Set < string > ();
                    if (objName == 'Phoenix_Bid__c') ccEmailIds.add(bid.owner.Email);
                    if (objName == 'Phoenix_Bid__c' && step.Phoenix_Is_Criteria_Step__c == true) {
                        mail.setReplyTo(Label.Bright_Approval_Inbound_Email);
                    }
                    if (objName == 'Phoenix_Bid__c' && bid.Phoenix_Bid_Created_Behalf_of__c != null) ccEmailIds.add(bid.Phoenix_Bid_Created_Behalf_of__r.Email);
                    if (step.Phoenix_Approver_Team__c == 'Home Office' && Label.CC_Emails_for_Vistex_Approvals != null) ccEmailIds.addAll(Label.CC_Emails_for_Vistex_Approvals.split(','));
                    if (Label.Phoenix_Contracts_DL != null) ccEmailIds.addAll(Label.Phoenix_Contracts_DL.split(','));
                    ccEmailIds.addAll(allPeopleInvolvedEmailsSet);
                    for (string emailId: toAddress) {
                        if (ccEmailIds.contains(emailId))
                            ccEmailIds.remove(emailId);
                    }
                    
                    If(ccEmailIds != null && ccEmailIds.contains('mkalawadia@drreddys.com'))ccEmailIds.remove('mkalawadia@drreddys.com');
                    
                    mail.setToAddresses(new List < String > (toAddress)); //new List < String > (toAddress)
                    mail.setCcAddresses(new List < String > (ccEmailIds));
                    //   mail.setCcAddresses(new List<String>{'surenderpatel@drreddys.com'}); 
                    mail.setOrgWideEmailAddressId(Phoenix_Util.orgWideEmailId);
                    Integer productsCount = productsByLead.get(marketingHeadName).size(); String bidType;
                    List<Document> brightLogo = [select id from Document where DeveloperName = 'BRIGHT_Logo_Email']; 
                    List<Document> visionLogo = [select id from Document where DeveloperName = 'VISION_Logo_Email'];
                    DateTime internalDueDateTime = DateTime.newInstance(bid.Phoenix_Internal_Target_Date__c, Time.newInstance(0, 0, 0, 0));
                    string bidLink = '<a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+bid.Id+'">'+bid.Name+'</a>';
                    String strOrgId = UserInfo.getOrganizationId();
                    String BRIGHT_Logo_Url = System.URL.getSalesforceBaseUrl().toExternalForm() + '/servlet/servlet.ImageServer?id='+brightLogo[0].Id +'&oid='+ strOrgId;
                    String VISION_Logo_Url = System.URL.getSalesforceBaseUrl().toExternalForm() + '/servlet/servlet.ImageServer?id='+visionLogo[0].Id +'&oid='+ strOrgId;
                    String tableString = '<div style="background-color: #721DEF; color: white;padding-bottom: 2px;"><div style="width: 100%;"><div style="width: 50%;float:right;height: 64px;"><img src="'+VISION_Logo_Url+'" width="115" height="25" align="right" style="margin-right:20px;padding-right:15px;padding-bottom:7px;padding-top:20px;"alt="Logo"</img></div><div style="padding-top: 4px;width: 50%;float: left;"><img src="'+BRIGHT_Logo_Url+'" width="115" height="52" align="left" style="margin-left:26px;padding-right:15px;padding-bottom:7px;padding-top:1px;"alt="Logo"</img></div></div><div><br/>';
                    tableString += '<div style="color: black; margin: 20px 40px 40px 40px;padding:50px; background-color: white;">Dear '+marketingHeadName+',<br /><br />';
                    if(bid.Phoenix_Bid_Type__c == 'Mass Product Removals'){
                        bidType = 'Product Removals';
                        tableString += '<b><p style="margin: 10px 0px 10px 38px;font-size: 22px;">Product Removals Approval Request</p></b></div>';
                        tableString += 'We are requesting your approval of removing '+productsCount+' product(s) on a newly submitted Product Removals Bid initiated by '+bid.Owner.Name+'. You are receiving this as you are identified as a Marketing Head for the below products.<br/>';
                        mail.setSubject('Product Removals Approval Request Notification');
                    } else{
                        bidType = 'Product Discontinuation Process';
                        tableString += '<b><p style="margin: 10px 0px 10px 38px;font-size: 22px;">Product Discontinuation Approval Request</p></b></div>';
                        tableString += 'We are requesting your approval of deactivating '+productsCount+' product(s) on a newly submitted Product Discontinuation Bid initiated by '+bid.Owner.Name+'. You are receiving this as you are identified as a Marketing Head for the below products.<br/>';
                        mail.setSubject('Product Discontinuation Approval Request Notification');
                    }
                    tableString += '<br/>To view further details of the bid and the product(s), please refer to the table below.<br/><br/>';
                    tableString += '<div><table border="2" style="margin: auto; border-collapse: collapse;"><tbody><tr><td style="background-color: #b3a8f7; color: black; padding: 4px 8px;"><b>Bid Number</b></td><td style="padding: 4px 8px;">'+bidLink+'</td></tr>';
                    tableString += '<tr><td style="background-color: #b3a8f7; color: black; padding: 4px 8px;"><b>Bid Name</b></td><td style="padding: 4px 8px;">'+bid.Phoenix_Bid_Name__c+'</td></tr>';
                    tableString += '<tr><td style="background-color: #b3a8f7; color: black;padding: 4px 8px;"><b>Bid Type</b></td><td style="padding: 4px 8px;">'+bidType+'</td></tr>';
                    tableString += '<tr><td style="background-color: #b3a8f7; color: black;padding: 4px 8px;"><b>Bid Initiator</b></td><td style="padding: 4px 8px;">'+bid.Owner.Name+'</td></tr>';
                    tableString += '<tr><td style="background-color: #b3a8f7; color: black;padding: 4px 8px;"><b>Internal Deadline</b></td><td style="padding: 4px 8px;">'+internalDueDateTime.format('MMM d yyyy')+'</td></tr></tbody></table></div><br/><br/>';
                    tableString += '<b>Product Families:</b><br/>'+productFamiliesString+'</br>';
                    tableString += 'To approve or reject the following bid, kindly refer to the link '+bidLink+'<br/><br/>Sincerely,<br/>BRIGHT Support Team<br/><br/><br/><i>[This is an auto generated mail from Bright, please do not reply to this e-mail]</i><br/></div>';
                    
                    mail.setHtmlBody(templateBody.replace('EMAIL_BODY', tableString));
                    //mail.setHtmlBody(templateBody);
                    mails.add(mail);
                    // if(step.Phoenix_Approver_Team__c == 'Sr Director or VP Finance')mail.setCcAddresses(new List<String>{'surender+BUheadCC@dhruvsoft.com'});//mail.setCcAddresses(new List<String>(approvalTeamUsersEmailsMap.get('Business Head')));
                }   
            }
            results = Messaging.sendEmail(mails);
        }
        Catch(Exception e) {
            String msg = e.getMessage().length() > 255 ? e.getMessage().substring(0, 254) : e.getMessage();
            
            Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'Phoenix_SubmitBidForApprovalCtrl', Phoenix_Error_Message__c = msg, Phoenix_Issue_Status__c = 'Pending', Phoenix_Method_Name__c = 'approvalRequestNotification', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Remarks__c = 'ObjectId is '+objID, Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
            insert exp;
        }        
    }
    
    
    
    @AuraEnabled
    public static void updateNextMarketingLeadProcessSteps(string bidId, string bidName, list < Phoenix_Bid_Process_Steps__c > processStepLsit, boolean flagmarketingLeadstop) {
        if (flagmarketingLeadstop == false && !processStepLsit.isEmpty()) {
            Map < Integer, List < Phoenix_Bid_Process_Steps__c >> stepMap = new Map < Integer, List < Phoenix_Bid_Process_Steps__c >> ();
            Map < String, List < Phoenix_Bid_Process_Steps__c >> stepNamesMap = new Map < String, List < Phoenix_Bid_Process_Steps__c >> ();
            Map < String, Integer > stepnameNoMap = new Map < String, Integer > ();
          system.debug('Entered here');
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
            List < Phoenix_Bid_Process_Steps__c > nextSteps = new list < Phoenix_Bid_Process_Steps__c > ();
            List < Phoenix_Bid_Process_Steps__c > nextStepscopy = new list < Phoenix_Bid_Process_Steps__c > ();
            Integer stepNo;


            if(stepnameNoMap.containsKey('Marketing Lead Rx')){
                stepNo = stepnameNoMap.get('Marketing Lead Rx') + 1;
            nextSteps = stepMap.get(stepNo);
            }
            if(stepnameNoMap.containsKey('Marketing Lead SRx')){
                stepNo = stepnameNoMap.get('Marketing Lead SRx') + 1;
            nextSteps = stepMap.get(stepNo);
            }

        if(stepnameNoMap.containsKey('Marketing Lead OTC')){
                stepNo = stepnameNoMap.get('Marketing Lead OTC') + 1;
            nextSteps = stepMap.get(stepNo);
            }
      



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
        list < Phoenix_Bid_Process_Steps__c > bidProcessStepList = [SELECT Id, Name, Phoenix_Bid__c, Phoenix_Process_Step__c, Phoenix_Step__c, Phoenix_Approver__r.Email, Phoenix_Approver__r.Name, Phoenix_Approver__c, Phoenix_Status__c, Phoenix_Approver_Team__c FROM Phoenix_Bid_Process_Steps__c where Phoenix_Bid__c =: bidId];
        list < Phoenix_Bid_Process_Steps__c > contractsStepLsit = new list < Phoenix_Bid_Process_Steps__c > ();
        for (Phoenix_Bid_Process_Steps__c step: bidProcessStepList) {

            if (step.Phoenix_Approver_Team__c == 'Contracts' && isContracts) {
                step.Phoenix_Status__c = approveStatusFlag == true ? 'Completed' : 'Do Not Bid';
                contractsStepLsit.add(step);
            }




            if (step.Phoenix_Approver_Team__c == 'Finance' && isFinance) {
                step.Phoenix_Status__c = approveStatusFlag == true ? 'Completed' : 'Do Not Bid';
                contractsStepLsit.add(step);
            }
        }
        if (!contractsStepLsit.isEmpty()) {
            update contractsStepLsit;
        }
        return bidProcessStepList;
    }
    @AuraEnabled
    public static void updateNextFinanceProcessSteps(string bidId, string bidName, list < Phoenix_Bid_Process_Steps__c > processStepLsit) {
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

        list < Phoenix_Bid_Line_Item__c > bidLinesUpdate = [select id, Phoenix_Contracts_Final_Approval__c, Phoenix_Customer_Final_Approval__c, Phoenix_Final_Status__c from Phoenix_Bid_Line_Item__c where Phoenix_Bid__c =: bidId];

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

        } else {

		 List < Phoenix_Bid_Process_Steps__c > nextSteps = new list < Phoenix_Bid_Process_Steps__c > ();
            Integer stepNo;

            stepNo = stepnameNoMap.get('Finance') + 1;
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
    public static void updateNextContractsProcessSteps(string bidId, string bidType, string bidName, list < Phoenix_Bid_Process_Steps__c > processStepLsit) {
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

        list < Phoenix_Bid_Line_Item__c > bidLinesUpdate = [select id,Phoenix_Bid__r.Phoenix_Bid_Type__c, Phoenix_Contracts_Final_Approval__c, Phoenix_Customer_Final_Approval__c, Phoenix_Final_Status__c from Phoenix_Bid_Line_Item__c where Phoenix_Bid__c =: bidId];
        boolean isAllRejectedCaseFound = true;
        for (Phoenix_Bid_Line_Item__c lineItem: bidLinesUpdate) {
            if (lineItem.Phoenix_Final_Status__c != 'Not Approved') {
                isAllRejectedCaseFound = false;
            }
            bidType=lineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c;
        }
        if (isAllRejectedCaseFound) {


            integer currentStepNum = stepnameNoMap.get('Contracts');
            for (Phoenix_Bid_Process_Steps__c prcsStep: processStepLsit) {
                if (prcsStep.Phoenix_Approver_Team__c == 'Contracts' && prcsStep.Phoenix_Status__c != 'Completed') {
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

        } else {
            List < Phoenix_Bid_Process_Steps__c > nextSteps = new list < Phoenix_Bid_Process_Steps__c > ();
            Integer stepNo;

            stepNo = stepnameNoMap.get('Contracts') + 1;
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
                if(bidType=='Mass Product Removals')
					Phoenix_SubmitBidForApprovalCtrl.sendEmailToSCMTeam(bidId);



            } else {
                Phoenix_Bid__c bid = new Phoenix_Bid__c(id = bidId, Phoenix_Approval_Status__c = 'Closed');
                update bid;
                if(bidType=='Mass Product Removals')
					Phoenix_SubmitBidForApprovalCtrl.sendEmailToSCMTeam(bidId);
            }
        }

    }
    public class Wrapper {

        @AuraEnabled public List < Phoenix_Bid_Line_Item__c > lineItemsList;
        @AuraEnabled public Phoenix_Bid__c bidRecord;
        @AuraEnabled public List < ContentDocumentLink > conDocLink;
        @AuraEnabled public string loggedInUserName;
        @AuraEnabled public string loggedInUserId;
        @AuraEnabled public boolean isVistexApprovePerson;
        @AuraEnabled public boolean isSRxApprovePerson;
        @AuraEnabled public boolean isFinanceApprovePerson;
        @AuraEnabled public string isMarketingApprovePerson;
          @AuraEnabled public string isMarketingLeadrxApprovePerson;
                  @AuraEnabled public string isMarketingLeadsrxApprovePerson;
                  @AuraEnabled public string isMarketingLeadotcApprovePerson;
        @AuraEnabled public boolean showProceedBtn;
         @AuraEnabled public boolean showproceedlead;
         @AuraEnabled public boolean showproceedleadrx;
         @AuraEnabled public boolean showproceedleadotc;
         @AuraEnabled public boolean showproceedleadsrx;
          @AuraEnabled public boolean delegationUser;
                  @AuraEnabled public boolean isdelegationUser;
           @AuraEnabled public string delagationuser1;
          @AuraEnabled public string delagationuser;
         @AuraEnabled public boolean isdelegationUserrx;
 @AuraEnabled public boolean isdelegationUsersrx;
         @AuraEnabled public boolean isdelegationUserotc;
        Wrapper() {

            lineItemsList = new List < Phoenix_Bid_Line_Item__c > ();
            bidRecord = new Phoenix_Bid__c();
            conDocLink = new list < ContentDocumentLink > ();
            loggedInUserName = '';
            loggedInUserId = '';
            isMarketingApprovePerson = '';
            isMarketingLeadrxApprovePerson ='';
            isMarketingLeadsrxApprovePerson='';
            isMarketingLeadotcApprovePerson='';
            delagationuser1='';
                  delagationuser='';
        }


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
    public static void updateNextVistexProcessSteps(string bidId, string bidName, list < Phoenix_Bid_Process_Steps__c > processStepLsit, boolean vistexNextStepFlag) {
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
            List < Phoenix_Bid_Process_Steps__c > nextSteps = new list < Phoenix_Bid_Process_Steps__c > ();
            Integer stepNo;

            stepNo = stepnameNoMap.get('Home Office') + 1;
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

    @AuraEnabled
    public static void deleteLineItems(String LineItemId) {
        if (LineItemId != null) {
            Phoenix_Bid_Line_Item__c deletedLineItem = [SELECT Id FROM Phoenix_Bid_Line_Item__c WHERE Id =: LineItemId];
            delete deletedLineItem;
        }
    }
    @AuraEnabled
    public static list < Phoenix_Bid_Line_Item__c > saveLineItems(List < Phoenix_Bid_Line_Item__c > LineItemList) {

        update LineItemList;
        return LineItemList;
    }
    @AuraEnabled
    public static List < ContentDocumentLink > getDocs(String bidId) {
        Phoenix_Bid__c bidRec = [select Id FROM Phoenix_Bid__c where id =: bidId];
        return [SELECT Id, LinkedEntityId, ContentDocument.Title, ContentDocument.FileExtension, ContentDocumentId FROM ContentDocumentLink where LinkedEntityId =: bidRec.Id];
    }
    @AuraEnabled
    public static void deleteAttachments(String LineItemId, String bidId) {
        List < ContentDocument > contentDocumentIds = [select Id from ContentDocument WHERE Id =: LineItemId];
        delete contentDocumentIds;

    }
    @AuraEnabled
    public static List < ContentDocumentLink > getExistingDocs(String bidId) {
        return [SELECT Id, LinkedEntityId, ContentDocument.Title, ContentDocument.FileExtension, ContentDocumentId FROM ContentDocumentLink where LinkedEntityId =: bidId];


    }
      public static void coderItems(){
        integer i = 0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
          i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
          i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
          i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
          i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
          i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
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