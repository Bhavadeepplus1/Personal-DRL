/**
 * @description       : 
 * @author            : Surender Dhruvsoft
 * @group             : 
 * @last modified on  : 25-05-2021
 * @last modified by  : Surender Dhruvsoft
 * Modifications Log 
 * Ver   Date         Author               Modification
 * 1.0   25-05-2021   Mamatha Dhruvsoft   Initial Version
 **/
public class CheckListController {
    //---------*************---changes by Mamatha Dhruvsoft-------START-----*************---

    //------------This method is used for onload in Edit Checklist & Checklist Detail Page actions------------
    @AuraEnabled
    public static Wrapper checkListRec(string checklistid) {
        try {
            Wrapper wrapperObject = new Wrapper();
            Phoenix_Bid__c bid = new Phoenix_Bid__c();
            //string checkval;
            Checklist__c chobk;
            if (checklistid != null) {
                bid = [select id, Phoenix_Bid_Type__c, Phoenix_Approval_Status__c, Phoenix_Is_Checklist_Exist__c, Phoenix_Vistex_Update__c, Phoenix_Vistex_Update_Comments__c from Phoenix_Bid__c where id =: checklistid limit 1];
                // checkval=chobk.Checklist_Type__c;
                if (bid.Phoenix_Is_Checklist_Exist__c == true) {
                    chobk = [select Id, Checklist_Type__c, Bid__c, Account__c from Checklist__c where Bid__c =: checklistid limit 1];

                }


            }
            if (chobk != null) {
                wrapperObject.checklist = chobk;

            }
            List < ContentDocumentLink > entries = [SELECT Id, LinkedEntityId, ContentDocument.Title, ContentDocument.FileExtension, ContentDocumentId FROM ContentDocumentLink where LinkedEntityId =: checklistid];
            if (!entries.isEmpty()) {
                wrapperObject.conDocLink = entries;
            }
            Map < String, String > userTeamUserIdMap = new Map < String, String > ();
            for (Phoenix_User_Approval_Matrix__c matrix: [Select Id, Name, RecordType.DeveloperName, Phoenix_Approver__r.Name, User_Group__r.Phoenix_Approver_Group_Name__c, Phoenix_Approval_Group_Behavior__c, Phoenix_Approver__c, Phoenix_Approver__r.Email, Phoenix_Approver_Group_Name__c, Phoenix_Is_Active_User__c, Phoenix_Is_Approval_Process_User__c, User_Group__c from Phoenix_User_Approval_Matrix__c limit 1000]) {
                String userTeamUserIdMapKey = matrix.User_Group__r.Phoenix_Approver_Group_Name__c + '-' + matrix.Phoenix_Approver__c;
                userTeamUserIdMap.put(userTeamUserIdMapKey, matrix.Phoenix_Approver__r.Name);
            }
            string isVistexApprovePerson;
            if (userTeamUserIdMap.containsKey('Home Office-' + UserInfo.getUserId())) {
                isVistexApprovePerson = userTeamUserIdMap.get(('Home Office-' + UserInfo.getUserId()));
            }
            wrapperObject.isVistexApprovePerson = isVistexApprovePerson;
            wrapperObject.approvalStatus = bid.Phoenix_Approval_Status__c;
            wrapperObject.loggedInUserId = UserInfo.getName();
            wrapperObject.bidRecord = bid;
            return wrapperObject;


        } catch (exception e) {
            Wrapper wrapperObject1 = new Wrapper();
            List < ContentDocumentLink > entries = [SELECT Id, LinkedEntityId, ContentDocument.Title, ContentDocument.FileExtension, ContentDocumentId FROM ContentDocumentLink where LinkedEntityId =: checklistid];
            if (!entries.isEmpty()) {
                wrapperObject1.conDocLink = entries;
            }
            Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'CheckListController', Phoenix_Method_Name__c = 'checkListRec', Phoenix_Remarks__c = 'checklistid is ' + checklistid, Phoenix_Error_Message__c = e.getMessage(), Phoenix_Issue_Status__c = 'Pending', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
            insert exp;
            return wrapperObject1;
      }

    }



    //------------This method is used for  onload in Add Checklist action------------


    @AuraEnabled
    public static Wrapper getBid(Id bidId) {

        Wrapper wrapperObject = new Wrapper();
        Checklist__c chobk;
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
        List < ContentDocumentLink > entries = [SELECT Id, LinkedEntityId, ContentDocument.Title, ContentDocument.FileExtension, ContentDocumentId FROM ContentDocumentLink where LinkedEntityId =: bidRec.Id];
        wrapperObject.bidRecord = bidRec;

        if (!entries.isEmpty()) {
            wrapperObject.conDocLink = entries;
        }

        return wrapperObject;

    }

    //wrapper class
    public class Wrapper {
        @AuraEnabled public Phoenix_Bid__c bidRecord;
        @AuraEnabled public List < ContentDocumentLink > conDocLink;
        @AuraEnabled public Checklist__c checklist;
        @AuraEnabled public string isVistexApprovePerson;
        @AuraEnabled public string approvalStatus;
        @AuraEnabled public string loggedInUserId;
    }

    //this method is for retrieving the documents related to the bid
    @AuraEnabled
    public static List < ContentDocumentLink > getDocs(String bidId) {
        Phoenix_Bid__c bidRec = [select Id FROM Phoenix_Bid__c where id =: bidId];
        return [SELECT Id, LinkedEntityId, ContentDocument.Title, ContentDocument.FileExtension, ContentDocumentId FROM ContentDocumentLink where LinkedEntityId =: bidRec.Id];
    }

    //this method is for deleting the selected documents related to the bid

    @AuraEnabled
    public static void deleteAttachments(String selAttachId, String bidId) {
        List < ContentDocument > contentDocumentIds = [select Id from ContentDocument WHERE Id =: selAttachId];
        delete contentDocumentIds;

    }

    @AuraEnabled
    public static void delChecklist(String bidId) {
        Checklist__c check = [select Id from Checklist__c WHERE Bid__c =: bidId LIMIT 1];
        delete check;
    }

    @AuraEnabled
    public static void saveToBidBus(string bidId, String busStatus, String busCom) {
        Phoenix_Bid__c bidRecord = [select Id, Phoenix_Vistex_Update__c, Phoenix_Vistex_Update_Comments__c FROM Phoenix_Bid__c WHERE Id =: bidId limit 1];
        bidRecord.Phoenix_Vistex_Update__c = busStatus;
        bidRecord.Phoenix_Vistex_Update_Comments__c = busCom;
        update bidRecord;
    }
    @AuraEnabled
    public static void makeApprovalsBusiness(String bidId, String finaceCom, string financeAppStatus, string approvStatus) {
        Phoenix_Bid_Process_Steps__c currentStep = [SELECT Id, Name, Phoenix_Bid__c, Phoenix_Process_Step__c, Phoenix_Step__c, Phoenix_Approver__c, Phoenix_Status__c, Phoenix_Approver_Team__c FROM Phoenix_Bid_Process_Steps__c
            where Phoenix_Bid__c =: bidId AND Phoenix_Status__c = 'In Process'
            LIMIT 1
        ];
        List < Phoenix_Bid_Process_Steps__c > updateProcessStep = [SELECT Id, Name, Phoenix_Bid__c, Phoenix_Process_Step__c, Phoenix_Step__c, Phoenix_Approver__c, Phoenix_Status__c, Phoenix_Approver_Team__c FROM Phoenix_Bid_Process_Steps__c where Phoenix_Bid__c =: bidId];
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
            System.debug('-----------stepName------' + stepName);
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
        Phoenix_Bid__c bidCurrent = [select id, Phoenix_Approval_Status__c, Phoenix_Vistex_Update__c, Phoenix_Vistex_Update_Comments__c from Phoenix_Bid__c where id =: bidId LIMIT 1];
        List < Phoenix_Bid_Process_Steps__c > nextSteps = stepMap.get(3);


        if (currentStep != null) {
            System.debug('-------updateProcessStep.Phoenix_Status__c-' + currentStep.Phoenix_Status__c);
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
        if(bidCurrent.Phoenix_Vistex_Update__c == 'Not Processed')
            bidCurrent.Phoenix_Approval_Status__c = 'Vistex Update Rejected';
        else if(bidCurrent.Phoenix_Vistex_Update__c == 'Processed')
            bidCurrent.Phoenix_Approval_Status__c = 'Closed';
        update bidCurrent;



    }

    //----------*************------changes by Mamatha Dhruvsoft--------	END------*************---


    /*  @AuraEnabled
public static string checklistrecord(string checklistid)
{
string checkval;
//system.debug('-------'+checklistid);
if(checklistid != null)
{
Checklist__c chobk=[select Checklist_Type__c from Checklist__c where id =:checklistid limit 1];
checkval=chobk.Checklist_Type__c;
}
return checkval;

}

//this method s used for get Account id --when click on AddChecklist button in bid record
@AuraEnabled
public static string accountrecordid(string bidid)
{
string accid;

if(bidid != null)
{
Phoenix_Bid__c  accobj=[select id ,Phoenix_Customer__c from Phoenix_Bid__c where id =:bidid limit 1];
accid=accobj.Phoenix_Customer__c;
}
return accid;

}*/


}