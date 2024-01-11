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
public class Phoenix_EditIPALinesCls {

    private static final String base64Chars = '' +
        'ABCDEFGHIJKLMNOPQRSTUVWXYZ' +
        'abcdefghijklmnopqrstuvwxyz' +
        '0123456789+/';
    @AuraEnabled
    public static Wrapper getRelatedList(Id bidId) {
        Wrapper wrapperObject = new Wrapper();

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
        query = 'select Phoenix_Bid__r.Name,Phoenix_Parent_IPA_Customer__r.Name,Phoenix_RAM__r.Name,Phoenix_Contact__r.Name,Phoenix_RCA_Agreement__r.Name,Phoenix_New_RCA_Agreement__r.Name,Phoenix_Customer__r.Name , ' + strFields + ' from ' + SobjectApiName + ' where Phoenix_Bid__c = : bidId limit 20000';

        list < Phoenix_RCA_IPA_LINE__c > quoteList = Database.query(query);
      //  system.debug('quoteList--->' + quoteList);




        Phoenix_Bid__c bid = [SELECT Id, Phoenix_Customer__r.Phoenix_Contracts_Approver__c, Phoenix_Customer__r.Phoenix_Contracts_Approver__r.Name, Name, Phoenix_Approval_Status__c, Phoenix_Customer__r.Name, Phoenix_Bid_Name__c, Phoenix_Bid_Type__c FROM Phoenix_Bid__c WHERE Id =: bidId];

        Map < String, String > userTeamUserIdMap = new Map < String, String > ();
        for (Phoenix_User_Approval_Matrix__c matrix: [Select Id, Name, RecordType.DeveloperName, Phoenix_Approver__r.Name, User_Group__r.Phoenix_Approver_Group_Name__c, Phoenix_Approval_Group_Behavior__c, Phoenix_Approver__c, Phoenix_Approver__r.Email, Phoenix_Approver_Group_Name__c, Phoenix_Is_Active_User__c, Phoenix_Is_Approval_Process_User__c, User_Group__c from Phoenix_User_Approval_Matrix__c limit 1000]) {
            String userTeamUserIdMapKey = matrix.User_Group__r.Phoenix_Approver_Group_Name__c + '-' + matrix.Phoenix_Approver__c;
            userTeamUserIdMap.put(userTeamUserIdMapKey, matrix.Phoenix_Approver__r.Name);
        }

        boolean isContractsApprovePerson;

        if (userTeamUserIdMap.containsKey('Contracts-' + UserInfo.getUserId())) {
            isContractsApprovePerson = true;
        }
        boolean showProceedContrBtn = true;
        for (Phoenix_RCA_IPA_LINE__c lineItem: quoteList) {



            if (lineItem.Phoenix_Contracts_Final_Approval__c == false) {
                showProceedContrBtn = false;
            }
        }
        wrapperObject.lineItemsList = quoteList;
        wrapperObject.bidRecord = bid;
        wrapperObject.loggedInUserName = UserInfo.getName();
        wrapperObject.showProceedContrBtn = showProceedContrBtn;
        wrapperObject.isContractsApprovePerson = isContractsApprovePerson;
        if (bid.Phoenix_Customer__r.Phoenix_Contracts_Approver__r.Name != null) {
            wrapperObject.BidContractPerson = bid.Phoenix_Customer__r.Phoenix_Contracts_Approver__r.Name;
        }
        return wrapperObject;

    }
    // added by Jogarao
    @AuraEnabled
    public static List < Phoenix_RCA_IPA_LINE__c >  getupdatedforExport(List < Phoenix_RCA_IPA_LINE__c > rcaLines) {
        for(Phoenix_RCA_IPA_LINE__c line : rcaLines){   
            line.Phoenix_Street_Name__c = line.Phoenix_Street_Name__c!=null ? line.Phoenix_Street_Name__c.replaceAll('#',' '):line.Phoenix_Street_Name__c;
            line.Phoenix_Contract_Comments__c  = line.Phoenix_Contract_Comments__c !=null ? line.Phoenix_Contract_Comments__c .replaceAll('#',' '):line.Phoenix_Contract_Comments__c ;
            
        }
        return rcaLines;
    }
    public class Wrapper {

        @AuraEnabled public List < Phoenix_RCA_IPA_LINE__c > lineItemsList;
        @AuraEnabled public Phoenix_Bid__c bidRecord;
        @AuraEnabled public string loggedInUserName;
        @AuraEnabled public boolean isContractsApprovePerson;
        @AuraEnabled public string BidContractPerson;
        @AuraEnabled public boolean showProceedBtn;
        @AuraEnabled public boolean showProceedContrBtn;

        Wrapper() {

            lineItemsList = new List < Phoenix_RCA_IPA_LINE__c > ();
            bidRecord = new Phoenix_Bid__c();
            loggedInUserName = '';
            BidContractPerson = '';

        }
    }
    @AuraEnabled
    public static void deleteLineItems(String LineItemId) {
        if (LineItemId != null) {
            Phoenix_RCA_IPA_LINE__c deletedLineItem = [SELECT Id FROM Phoenix_RCA_IPA_LINE__c WHERE Id =: LineItemId];
            delete deletedLineItem;
        }
    }
    @AuraEnabled
    public static list < Phoenix_RCA_IPA_LINE__c > saveLineItems(List < Phoenix_RCA_IPA_LINE__c > LineItemList) {

        list < Phoenix_RCA_IPA_LINE__c > updateList = new list < Phoenix_RCA_IPA_LINE__c > ();
        for (Phoenix_RCA_IPA_LINE__c rca: LineItemList) {
            Phoenix_RCA_IPA_LINE__c ril = new Phoenix_RCA_IPA_LINE__c();
            ril = rca;
            if (ril.Phoenix_New_GPO__c == '--None--') {
                ril.Phoenix_New_GPO__c = '';
            }
            if (ril.Phoenix_Wholesaler__c == '-- None --') {
                system.debug('ril.Phoenix_Wholesaler__c' + ril.Phoenix_Wholesaler__c);
                ril.Phoenix_Wholesaler__c = '';
                ril.Phoenix_Wholesaler_Location__c = '';
            } else if (ril.Phoenix_Wholesaler_Location__c == '-- None --') {
                system.debug('ril.Phoenix_Wholesaler__c' + ril.Phoenix_Wholesaler__c);
                system.debug('ril.Phoenix_Wholesaler_Location__c' + ril.Phoenix_Wholesaler_Location__c);
                ril.Phoenix_Wholesaler_Location__c = '';
                system.debug('ril.Phoenix_Wholesaler_Location__c' + ril.Phoenix_Wholesaler_Location__c);
            }

            updateList.add(ril);
        }
        update updateList;
        return updateList;
    }
    @AuraEnabled
    public static list < Phoenix_RCA_IPA_LINE__c > submitToProceddStep1(string bidId) {
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
        return bidLinesList;

    }
    @AuraEnabled
    public static WrapperForNextSteps makeApprovalsContracts(String bidId, List < Phoenix_RCA_IPA_LINE__c > bidlines, boolean approveStatusFlag) {
        for (Phoenix_RCA_IPA_LINE__c line: bidlines) {

            line.Phoenix_Contracts_Final_Approval__c = true;
            if (line.Phoenix_Contract_Status__c == 'Line Error- Not Sent') {
                line.Phoenix_Final_Status__c = 'Not Approved';
            }


        }
        if (bidlines.size() > 0) {
            update bidlines;
        }
        list < Phoenix_Bid_Process_Steps__c > bidProcessStepList = [SELECT Id, Name, Phoenix_Bid__c, Phoenix_Process_Step__c, Phoenix_Approver__r.Email, Phoenix_Approver__r.Name, Phoenix_Step__c, Phoenix_Approver__c, Phoenix_Status__c, Phoenix_Approver_Team__c FROM Phoenix_Bid_Process_Steps__c where Phoenix_Bid__c =: bidId];
        list < Phoenix_Bid_Process_Steps__c > contractsStepLsit = new list < Phoenix_Bid_Process_Steps__c > ();
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
        query = 'select ' + strFields + ' from ' + SobjectApiName + ' where Phoenix_Bid__c = : bidId AND Phoenix_Final_Status__c !=: notApproved';

        list < Phoenix_Bid_Line_Item__c > bidLinesList = Database.query(query);
        boolean contractNextStepFlag = false;
        for (Phoenix_Bid_Line_Item__c pbl: bidLinesList) {
            if (pbl.Phoenix_Contracts_Final_Approval__c == false) {
                contractNextStepFlag = true;
            }
        }
        for (Phoenix_Bid_Process_Steps__c step: bidProcessStepList) {



            if (step.Phoenix_Approver_Team__c == 'Contracts' && contractNextStepFlag == false) {
                //step.Phoenix_Status__c = approveStatusFlag == true ? 'Completed' : 'Do Not Bid';
                if(approveStatusFlag == true){
                  step.Phoenix_Status__c =  'Completed'; 
                   step.Phoenix_Approver__c = userinfo.getuserid();
                }else{
                    step.Phoenix_Status__c = 'Do Not Bid';
                }
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
    public class WrapperForNextSteps {
        @AuraEnabled public list < Phoenix_Bid_Process_Steps__c > updateProcessStepList;

        @AuraEnabled public boolean contractNextStepFlag;

        WrapperForNextSteps() {
            updateProcessStepList = new List < Phoenix_Bid_Process_Steps__c > ();
            contractNextStepFlag = false;
        }
    }
    @AuraEnabled
    public static void updateNextContractsProcessSteps(string bidId, string bidName, list < Phoenix_Bid_Process_Steps__c > processStepLsit, boolean contractNextStepFlag) {

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
            System.debug('isAllRejectedCaseFound value-->'+isAllRejectedCaseFound);
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
            else{
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
                } else {
                    step.Phoenix_Status__c = 'In Process';
                } //'In Process' Submitted //Diff b/w them            
            }
            if (!nextSteps.isEmpty()) {
                update nextSteps;
                if (nextSteps[0].Phoenix_Approver_Team__c == 'Home Office') {
                    Phoenix_Bid__c bid = new Phoenix_Bid__c(id = bidId, Phoenix_Approval_Status__c = 'Vistex Update');
                    update bid;
                }
                Phoenix_SubmitBidForApprovalCtrl.approvalRequestNotification(bidId , nextSteps);//added by satya
                //Phoenix_SubmitBidForApprovalCtrl.sendForApproval(bidId,'Approval Required for '+bidName,nextSteps,'Bid_Approval');
            } else {
                Phoenix_Bid__c bid = new Phoenix_Bid__c(id = bidId, Phoenix_Approval_Status__c = 'Closed');
                update bid;
            }
        }
        }

    }

    @AuraEnabled
    public static PicklistWrapper getDependentPicklist() {
        Map < String, List < String >> pickListMap = new Map < String, List < String >> ();
        List < String > GPOvalues = new List < String > ();
        PicklistWrapper pw = new PicklistWrapper();
        pw.pickListMap = pickListMap;

        Schema.sObjectType objType = Schema.getGlobalDescribe().get('Phoenix_RCA_IPA_LINE__c').newSObject().getSObjectType();
        Map < String, Schema.SObjectField > objFieldMap = objType.getDescribe().fields.getMap();

        if (!objFieldMap.containsKey('Phoenix_Wholesaler__c') || !objFieldMap.containsKey('Phoenix_Wholesaler_Location__c')) {
            return pw;
        }

        List < PicklistEntryWrapper > depEntries = (List < PicklistEntryWrapper > ) JSON.deserialize(JSON.serialize(objFieldMap.get('Phoenix_Wholesaler_Location__c').getDescribe().getPicklistValues()), List < PicklistEntryWrapper > .class);
        List < String > controllingValues = new List < String > ();

        for (Schema.PicklistEntry ple: objFieldMap.get('Phoenix_Wholesaler__c').getDescribe().getPicklistValues()) {
            pickListMap.put(ple.getLabel(), new List < String > ());
            controllingValues.add(ple.getLabel());
        }

        for (PicklistEntryWrapper plew: depEntries) {
            String validForBits = base64ToBits(plew.validFor);
            for (Integer i = 0; i < validForBits.length(); i++) {
                String bit = validForBits.mid(i, 1);
                if (bit == '1') {
                    pickListMap.get(controllingValues.get(i)).add(plew.label);
                }
            }
        }
        Schema.DescribeFieldResult fieldResult = Phoenix_RCA_IPA_LINE__c.Phoenix_New_GPO__c.getDescribe();
        List < Schema.PicklistEntry > pList = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry p: pList) {
            GPOvalues.add(p.getLabel());
        }
        pw.pickListMap = pickListMap;
        pw.parentFieldLabel = objFieldMap.get('Phoenix_Wholesaler__c').getDescribe().getLabel();
        pw.childFieldLabel = objFieldMap.get('Phoenix_Wholesaler_Location__c').getDescribe().getLabel();
        pw.GPOvalues = GPOvalues;
        return pw;
    }

    //Refer from here https://salesforce.stackexchange.com/questions/4462/get-lists-of-dependent-picklist-options-in-apex
    public static String decimalToBinary(Integer val) {
        String bits = '';
        while (val > 0) {
            Integer remainder = Math.mod(val, 2);
            val = Integer.valueOf(Math.floor(val / 2));
            bits = String.valueOf(remainder) + bits;
        }
        return bits;
    }

    public static String base64ToBits(String validFor) {
        if (String.isEmpty(validFor)) return '';

        String validForBits = '';

        for (Integer i = 0; i < validFor.length(); i++) {
            String thisChar = validFor.mid(i, 1);
            Integer val = base64Chars.indexOf(thisChar);
            String bits = decimalToBinary(val).leftPad(6, '0');
            validForBits += bits;
        }

        return validForBits;
    }

    public class PicklistWrapper {
        @AuraEnabled
        public Map < String, List < String >> pickListMap;
        @AuraEnabled
        public String parentFieldLabel;
        @AuraEnabled
        public String childFieldLabel;
        @AuraEnabled
        public list < String > GPOvalues;
    }

    public class PicklistEntryWrapper {
        public String active;
        public String defaultValue;
        public String label;
        public String value;
        public String validFor;

    }


}