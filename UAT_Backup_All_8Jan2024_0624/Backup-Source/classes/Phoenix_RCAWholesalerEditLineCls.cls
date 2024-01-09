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
public class Phoenix_RCAWholesalerEditLineCls {

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
        query = 'select Phoenix_Bid__r.Name,Phoenix_RAM__r.Name,Phoenix_Parent_IPA_Customer__r.Name,Phoenix_RCA_Agreement__r.Name,Phoenix_New_RCA_Agreement__r.Name,Phoenix_Customer__r.Name , ' + strFields + ' from ' + SobjectApiName + ' where Phoenix_Bid__c = : bidId limit 20000';

        list < Phoenix_RCA_IPA_LINE__c > quoteList = Database.query(query);
        system.debug('quoteList--->' + quoteList);
        Map < String, String > userTeamUserIdMap = new Map < String, String > ();
        for (Phoenix_User_Approval_Matrix__c matrix: [Select Id, Name, RecordType.DeveloperName, User_Group__r.Phoenix_Approver_Group_Name__c, Phoenix_Approval_Group_Behavior__c, Phoenix_Approver__c, Phoenix_Approver__r.Email, Phoenix_Approver_Group_Name__c, Phoenix_Is_Active_User__c, Phoenix_Is_Approval_Process_User__c, User_Group__c from Phoenix_User_Approval_Matrix__c limit 1000]) {
            String userTeamUserIdMapKey = matrix.User_Group__r.Phoenix_Approver_Group_Name__c + '-' + matrix.Phoenix_Approver__c;
            userTeamUserIdMap.put(userTeamUserIdMapKey, matrix.Phoenix_Approver__c);
        }

        boolean isSRxApprovePerson = false;
          boolean isVistexApprovePerson = false;


        if (userTeamUserIdMap.containsKey('SRx IPA Contracts Approver-' + UserInfo.getUserId())) {
            isSRxApprovePerson = true;
        }
        if (userTeamUserIdMap.containsKey('Home Office-' + UserInfo.getUserId())) {
            isVistexApprovePerson = true;
        }
        



        Phoenix_Bid__c bid = [SELECT Id, Phoenix_Contracts_Approval_Comments__c, Phoenix_Contracts_Approval__c,Phoenix_Vistex_Update__c,Phoenix_Vistex_Update_Comments__c, Phoenix_Approval_Status__c, Name, Phoenix_Customer__r.Name, Phoenix_Bid_Name__c, Phoenix_Bid_Type__c FROM Phoenix_Bid__c WHERE Id =: bidId];

        wrapperObject.lineItemsList = quoteList;
        wrapperObject.bidRecord = bid;
        wrapperObject.isSRxApprovePerson = isSRxApprovePerson;
		wrapperObject.isVistexApprovePerson = isVistexApprovePerson;
        return wrapperObject;

    }
    public class Wrapper {

        @AuraEnabled public List < Phoenix_RCA_IPA_LINE__c > lineItemsList;
        @AuraEnabled public Phoenix_Bid__c bidRecord;
        @AuraEnabled public boolean isSRxApprovePerson;
		@AuraEnabled public boolean isVistexApprovePerson;
        Wrapper() {

            lineItemsList = new List < Phoenix_RCA_IPA_LINE__c > ();
            bidRecord = new Phoenix_Bid__c();

        }
    }
    @AuraEnabled
    public static Phoenix_Bid__c saveTobid(string bidId, string comments, string status,string approvalStatus,string visAppStatus,string visComm) {
     Phoenix_Bid__c bidRecord = new Phoenix_Bid__c();
        if(approvalStatus == 'Contracts'){
         bidRecord = new Phoenix_Bid__c(Id = bidId, Phoenix_Contracts_Approval__c = status, Phoenix_Contracts_Approval_Comments__c = comments);   
        }
        if(approvalStatus == 'Vistex Update'){
           bidRecord = new Phoenix_Bid__c(Id = bidId, Phoenix_Vistex_Update__c = visAppStatus, Phoenix_Vistex_Update_Comments__c = visComm);   
           
        } 
        update bidRecord;
        return bidRecord;
    }
    @AuraEnabled
    public static void makeApprovalsIPAContracts(String bidId, string comments, string status) {

        Phoenix_Bid_Process_Steps__c currentStep = [SELECT Id, Name, Phoenix_Bid__c, Phoenix_Step__c, Phoenix_Status__c, Phoenix_Approver_Team__c,Phoenix_Is_Criteria_Step__c, Phoenix_Process_Step__c, Phoenix_Approver__c,Phoenix_Approver__r.Email FROM Phoenix_Bid_Process_Steps__c where Phoenix_Bid__c =: bidId AND(Phoenix_Status__c = 'In Process'
            OR Phoenix_Status__c = 'Not Processed') limit 1];
        List < Phoenix_Bid_Process_Steps__c > processStepLsit = [SELECT Id, Name, Phoenix_Bid__c, Phoenix_Step__c, Phoenix_Status__c, Phoenix_Approver_Team__c,Phoenix_Is_Criteria_Step__c, Phoenix_Process_Step__c, Phoenix_Approver__c,Phoenix_Approver__r.Email FROM Phoenix_Bid_Process_Steps__c where Phoenix_Bid__c =: bidId];


        if (string.isNotBlank(status) && status == 'Processed') {
            system.debug('status------' + status);


            for (Phoenix_Bid_Process_Steps__c step: processStepLsit) {
                if (step.Name.contains('Vistex')) {
                    step.Phoenix_Status__c = 'In Process';
                }
            }

            if (!processStepLsit.isEmpty()) {
                update processStepLsit;
                currentStep.Phoenix_Status__c = 'Completed';
                currentStep.Phoenix_Approver__c = userinfo.getuserid();
                currentStep.Phoenix_Description__c = comments;
                update currentStep;
                Phoenix_Bid__c bid = new Phoenix_Bid__c(id = bidId, Phoenix_Contracts_Approval__c = status, Phoenix_Contracts_Approval_Comments__c = comments, Phoenix_Approval_Status__c = 'Vistex Update');
                update bid;
            }
            Phoenix_SubmitBidForApprovalCtrl.approvalRequestNotification(bidId , processStepLsit); 


        } 
        else {

            system.debug('currentStep----' + currentStep);

            for (Phoenix_Bid_Process_Steps__c step: processStepLsit) {
                if (step.Name.contains('Closed')) {
                    step.Phoenix_Status__c = 'Completed';
                }
                if (step.Name.contains('Vistex')) {
                    step.Phoenix_Status__c = 'Not Applicable';
                }
            }

            if (!processStepLsit.isEmpty()) {
                update processStepLsit;
                currentStep.Phoenix_Status__c = 'Completed';
                currentStep.Phoenix_Approver__c = userinfo.getuserid();
                currentStep.Phoenix_Description__c = comments;
                update currentStep;
                Phoenix_Bid__c bid = new Phoenix_Bid__c(id = bidId, Phoenix_Contracts_Approval__c = status, Phoenix_Contracts_Approval_Comments__c = comments, Phoenix_Approval_Status__c = 'Contracts Rejected');
                update bid;
            }
        }
    }
@AuraEnabled
    public static void makeApprovalsVistex(String bidId, string comments, string status) {

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
                Phoenix_Bid__c bid = new Phoenix_Bid__c(id = bidId, Phoenix_Vistex_Update__c = status, Phoenix_Vistex_Update_Comments__c = comments, Phoenix_Approval_Status__c = 'Closed');
                update bid;
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
                currentStep.Phoenix_Approver__c = userinfo.getuserid();
                currentStep.Phoenix_Description__c = comments;
                update currentStep;
                Phoenix_Bid__c bid = new Phoenix_Bid__c(id = bidId, Phoenix_Vistex_Update__c = status, Phoenix_Vistex_Update_Comments__c = comments, Phoenix_Approval_Status__c = 'Vistex Rejected');
                update bid;
                Map<Id,Phoenix_Bid_Line_Item__c> bidLinesMap = new Map<Id,Phoenix_Bid_Line_Item__c>([SELECT Id FROM Phoenix_Bid_Line_Item__c WHERE Phoenix_Bid__c=:bidId]);
                set<Id> bidLineItemIdset = bidLinesMap.keySet();
               
                Phoenix_SubmitBidForApprovalCtrl.BidRejectionEmailNotificationToAll(bidLineItemIdset,bidId);
            }
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
                ril.Phoenix_Wholesaler_Location__c = '';
                system.debug('ril.Phoenix_Wholesaler__c' + ril.Phoenix_Wholesaler__c);
                system.debug('ril.Phoenix_Wholesaler_Location__c' + ril.Phoenix_Wholesaler_Location__c);

                system.debug('ril.Phoenix_Wholesaler_Location__c' + ril.Phoenix_Wholesaler_Location__c);
            }

            updateList.add(ril);
        }
        update updateList;
        system.debug('updateList' + updateList);
        return updateList;
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