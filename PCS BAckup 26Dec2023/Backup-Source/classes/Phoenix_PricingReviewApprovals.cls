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
public class Phoenix_PricingReviewApprovals {

    @AuraEnabled
    public static Wrapper getBid(Id bidId) {
        Wrapper wrapperObject = new Wrapper();
        String SobjectApiName = 'Phoenix_Bid__c';
        String query = '';
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
        query = 'select' + ' ' + strFields + ' ' + 'from' + ' ' + SobjectApiName + ' ' + 'where Id =:bidId LIMIT 1';
        Phoenix_Bid__c bidRec = Database.query(query);
        Account acc = [select id, Name, Phoenix_Contracts_Approver__c from Account where id =: bidRec.Phoenix_Customer__c LIMIT 1];

        List < ContentDocumentLink > entries = [SELECT Id, LinkedEntityId, ContentDocument.Title, ContentDocument.FileExtension, ContentDocumentId FROM ContentDocumentLink where LinkedEntityId =: bidRec.Id];

        Map < String, String > userTeamUserIdMap = new Map < String, String > ();
        for (Phoenix_User_Approval_Matrix__c matrix: [Select Id, Name, RecordType.DeveloperName, Phoenix_Approver__r.Name, User_Group__r.Phoenix_Approver_Group_Name__c, Phoenix_Approval_Group_Behavior__c, Phoenix_Approver__c, Phoenix_Approver__r.Email, Phoenix_Approver_Group_Name__c, Phoenix_Is_Active_User__c, Phoenix_Is_Approval_Process_User__c, User_Group__c from Phoenix_User_Approval_Matrix__c limit 1000]) {
            String userTeamUserIdMapKey = matrix.User_Group__r.Phoenix_Approver_Group_Name__c + '-' + matrix.Phoenix_Approver__c;
            userTeamUserIdMap.put(userTeamUserIdMapKey, matrix.Phoenix_Approver__r.Name);
        }
        string isBusinessApprovePerson;
        string isContractsApprovePerson;
        if (userTeamUserIdMap.containsKey('Marketing Head-' + UserInfo.getUserId())) {
            isBusinessApprovePerson = userTeamUserIdMap.get(('Marketing Head-' + UserInfo.getUserId()));
        }

        if (acc.Phoenix_Contracts_Approver__c == UserInfo.getUserId() || userTeamUserIdMap.containsKey('Contracts-' + UserInfo.getUserId())) {
            isContractsApprovePerson = UserInfo.getName();
        }

        wrapperObject.bidRecord = bidRec;
        wrapperObject.approvalStatus = bidRec.Phoenix_Approval_Status__c;
        wrapperObject.account = acc;
        wrapperObject.loggedInUserId = UserInfo.getName();
        wrapperObject.isBusinessApprovePerson = isBusinessApprovePerson;
        wrapperObject.isContractsApprovePerson = isContractsApprovePerson;
        if (!entries.isEmpty()) {
            wrapperObject.conDocLink = entries;

        }

        return wrapperObject;
    }

    @AuraEnabled
    public static List < ContentDocumentLink > getDocs(String bidId) {
        Phoenix_Bid__c bidRec = [select Id FROM Phoenix_Bid__c where id =: bidId];
        return [SELECT Id, LinkedEntityId, ContentDocument.Title, ContentDocument.FileExtension, ContentDocumentId FROM ContentDocumentLink where LinkedEntityId =: bidRec.Id];
    }
    public class Wrapper {
        @AuraEnabled public Phoenix_Bid__c bidRecord;
        @AuraEnabled public string approvalStatus;
        @AuraEnabled public Account account;
        @AuraEnabled public List < ContentDocumentLink > conDocLink;
        @AuraEnabled public string loggedInUserId;
        @AuraEnabled public string isBusinessApprovePerson;
        @AuraEnabled public string isContractsApprovePerson;
    }

    @AuraEnabled
    public static void makeApprovalsBusiness(String bidId, String finaceCom, string financeAppStatus, string approvStatus) {
        Phoenix_Bid_Process_Steps__c currentStep = [SELECT Id, Name, Phoenix_Bid__c, Phoenix_Process_Step__c, Phoenix_Step__c, Phoenix_Approver__c, Phoenix_Status__c, Phoenix_Approver_Team__c FROM Phoenix_Bid_Process_Steps__c
            where Phoenix_Bid__c =: bidId AND Phoenix_Status__c = 'In Process'
            LIMIT 1
        ];
        List < Phoenix_Bid_Process_Steps__c > updateProcessStep = [SELECT Id, Name, Phoenix_Bid__c, Phoenix_Process_Step__c, Phoenix_Step__c, Phoenix_Approver__c,Phoenix_Approver__r.Email, Phoenix_Status__c, Phoenix_Approver_Team__c FROM Phoenix_Bid_Process_Steps__c where Phoenix_Bid__c =: bidId];
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
        Phoenix_Bid__c bidCurrent = [select id, Phoenix_Approval_Status__c, Phoenix_Marketing_Head_Approval__c, Phoenix_Marketing_Head_Comments__c from Phoenix_Bid__c where id =: bidId LIMIT 1];
        List < Phoenix_Bid_Process_Steps__c > nextSteps = stepMap.get(3);
        List < Phoenix_Bid_Process_Steps__c > nextSteps2 = stepMap.get(4);

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
            if (!nextSteps.isEmpty()) {
                update nextSteps;
            }
            if (!nextSteps2.isEmpty()) {
                update nextSteps2;
            }
            bidCurrent.Phoenix_Approval_Status__c = 'Closed';
            update bidCurrent;
        } else {}

    }
    @AuraEnabled
    public static void saveToBid(string bidId, String pricingDetails) {
        Phoenix_Bid__c bidRecord = [select Id, Phoenix_Review_Details__c FROM Phoenix_Bid__c WHERE Id =: bidId limit 1];
        bidRecord.Phoenix_Review_Details__c = pricingDetails;
        update bidRecord;
    }
    @AuraEnabled
    public static void saveToBidBus(string bidId, String busStatus, String busCom) {
        Phoenix_Bid__c bidRecord = [select Id, Phoenix_Marketing_Head_Approval__c, Phoenix_Marketing_Head_Comments__c FROM Phoenix_Bid__c WHERE Id =: bidId limit 1];
        bidRecord.Phoenix_Marketing_Head_Approval__c = busStatus;
        bidRecord.Phoenix_Marketing_Head_Comments__c = busCom;
        update bidRecord;
    }
    @AuraEnabled
    public static void saveToBidContr(string bidId, String contrStatus, String contrCom) {
        Phoenix_Bid__c bidRecord = [select Id, Phoenix_Contracts_Approval__c, Phoenix_Contracts_Approval_Comments__c FROM Phoenix_Bid__c WHERE Id =: bidId limit 1];
        bidRecord.Phoenix_Contracts_Approval__c = contrStatus;
        bidRecord.Phoenix_Contracts_Approval_Comments__c = contrCom;
        update bidRecord;
    }

    @AuraEnabled
    public static void makeApprovalsContracts(String bidId, String finaceCom, string financeAppStatus, string approvStatus) {
        Phoenix_Bid_Process_Steps__c currentStep = [SELECT Id, Name, Phoenix_Bid__c, Phoenix_Process_Step__c, Phoenix_Step__c, Phoenix_Approver__c, Phoenix_Status__c, Phoenix_Approver_Team__c FROM Phoenix_Bid_Process_Steps__c
            where Phoenix_Bid__c =: bidId AND Phoenix_Status__c = 'In Process'
            LIMIT 1
        ];
        List < Phoenix_Bid_Process_Steps__c > updateProcessStep = [SELECT Id, Name, Phoenix_Bid__c, Phoenix_Process_Step__c, Phoenix_Step__c, Phoenix_Approver__c,Phoenix_Approver__r.Email, Phoenix_Status__c, Phoenix_Approver_Team__c FROM Phoenix_Bid_Process_Steps__c where Phoenix_Bid__c =: bidId];
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
        List < Phoenix_Bid_Process_Steps__c > nextSteps = stepMap.get(4);

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
        } else if (financeAppStatus == 'Not_Processed') {
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
            bidCurrent.Phoenix_Approval_Status__c = 'Closed';
            update bidCurrent;
        } else {}
    }
    @AuraEnabled
    public static void deleteAttachments(String LineItemId, String bidId) {
        List < ContentDocument > contentDocumentIds = [select Id from ContentDocument WHERE Id =: LineItemId];
        delete contentDocumentIds;

    }

}