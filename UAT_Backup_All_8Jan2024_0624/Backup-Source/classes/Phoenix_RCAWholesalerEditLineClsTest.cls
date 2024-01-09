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
@isTest
public class Phoenix_RCAWholesalerEditLineClsTest {


    static testmethod void Phoenix_RCAWholesalerEditLineClsMethod() {
        Id phoenixRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Bid Accounts').getRecordTypeId();
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        Phoenix_Bid__c pb = new Phoenix_Bid__c();
        pb.Phoenix_Status__c = 'New';
        //pb.Phoenix_Bid_Type__c='SRx IPA Price Change';
        pb.Phoenix_Comments__c = 'Test Comments';
        pb.Phoenix_Customer__c = testAccount.Id;
        insert pb;
        list < Phoenix_RCA_IPA_LINE__c > lineItemsList = new list < Phoenix_RCA_IPA_LINE__c > ();
        for (Integer i = 0; i < 4; i++) {
            Phoenix_RCA_IPA_LINE__c pbl = new Phoenix_RCA_IPA_LINE__c(Phoenix_Bid__c = pb.Id);
            lineItemsList.add(pbl);
        }
        insert lineItemsList;
        Phoenix_RCAWholesalerEditLineCls.getRelatedList(pb.Id);
        Phoenix_RCAWholesalerEditLineCls.deleteLineItems(lineItemsList[0].Id);
        list < Phoenix_RCA_IPA_LINE__c > lineItemsList1 = [select Id, Phoenix_New_GPO__c, Phoenix_Wholesaler__c, Phoenix_Wholesaler_Location__c from Phoenix_RCA_IPA_LINE__c where Phoenix_Bid__c =: pb.Id];
        Phoenix_RCAWholesalerEditLineCls.saveLineItems(lineItemsList1);
        Phoenix_RCAWholesalerEditLineCls.getDependentPicklist();
        Phoenix_RCAWholesalerEditLineCls.saveTobid(pb.Id, 'Comments', 'Processed','Vistex Update','Processed','Test');//string bidId, string comments, string status,string approvalStatus,string visAppStatus,string visComm)
        Phoenix_TestDataCreator testData = new Phoenix_TestDataCreator();
        testData.generateApprovalMatrix();
        //Phoenix_SubmitBidForApprovalCtrl.createBidApprovalItems(new List<Phoenix_Bid__c>{pb});
        Phoenix_Bid_Process_Steps__c bStep = new Phoenix_Bid_Process_Steps__c();
        bStep.Phoenix_Is_Criteria_Step__c = false;
        bStep.Name = pb.Name + '-' + 'Intial Submission';
        bStep.Phoenix_Approver__c = UserInfo.getUserId();
        bStep.Phoenix_Bid__c = pb.Id;
        // bStep.Phoenix_Process_Step__c = pStep.Id;
        bStep.Phoenix_Status__c = 'Submitted';
        bStep.Phoenix_Approver_Team__c = 'Marketing';
        //stepNo : Ask and increment as per requirements
        bStep.Phoenix_Sub_Step__c = 1;
        //insert bStep;
         Phoenix_Bid_Process_Steps__c bStep1 = new Phoenix_Bid_Process_Steps__c();
        bStep1.Phoenix_Is_Criteria_Step__c = false;
        bStep1.Name = pb.Name + '-' + 'Intial Submission';
        bStep1.Phoenix_Approver__c = UserInfo.getUserId();
        bStep1.Phoenix_Bid__c = pb.Id;
        // bStep.Phoenix_Process_Step__c = pStep.Id;
        bStep1.Phoenix_Status__c = 'In Process';
        bStep1.Phoenix_Approver_Team__c = 'Marketing';
        //stepNo : Ask and increment as per requirements
        bStep1.Phoenix_Sub_Step__c = 1;
        insert bStep;
        Phoenix_Bid_Process_Steps__c bStep3 = new Phoenix_Bid_Process_Steps__c();
        bStep3.Phoenix_Is_Criteria_Step__c = false;
        bStep3.Name = pb.Name + '-' + 'Contracts';
        bStep3.Phoenix_Approver__c = UserInfo.getUserId();
        bStep3.Phoenix_Bid__c = pb.Id;
        // bStep.Phoenix_Process_Step__c = pStep.Id;
        bStep3.Phoenix_Status__c = 'In Process';
        bStep3.Phoenix_Approver_Team__c = 'Marketing';
        //stepNo : Ask and increment as per requirements
        bStep3.Phoenix_Sub_Step__c = 1;
        insert bStep3;
        Phoenix_Bid_Process_Steps__c bStep2 = new Phoenix_Bid_Process_Steps__c();
        bStep1.Phoenix_Is_Criteria_Step__c = false;
        bStep2.Name = pb.Name + '-' + 'Closed';
        bStep2.Phoenix_Approver__c = UserInfo.getUserId();
        bStep2.Phoenix_Bid__c = pb.Id;
        // bStep.Phoenix_Process_Step__c = pStep.Id;
        //bStep2.Phoenix_Status__c =  '';
        bStep2.Phoenix_Approver_Team__c = 'Marketing';
        //stepNo : Ask and increment as per requirements
        bStep2.Phoenix_Sub_Step__c = 1;
        insert bStep2;
          Phoenix_Bid_Process_Steps__c bStep4 = new Phoenix_Bid_Process_Steps__c();
        bStep4.Phoenix_Is_Criteria_Step__c = false;
        bStep4.Name = pb.Name + '-' + 'Vistex';
        bStep4.Phoenix_Approver__c = UserInfo.getUserId();
        bStep4.Phoenix_Bid__c = pb.Id;
        // bStep.Phoenix_Process_Step__c = pStep.Id;
        bStep4.Phoenix_Status__c =  'In Process';
        bStep4.Phoenix_Approver_Team__c = 'Home Office';
        //stepNo : Ask and increment as per requirements
        bStep4.Phoenix_Sub_Step__c = 1;
        insert bStep4;
          Phoenix_Bid_Process_Steps__c bStep5 = new Phoenix_Bid_Process_Steps__c();
        bStep5.Phoenix_Is_Criteria_Step__c = false;
        bStep5.Name = pb.Name + '-' + 'Closed';
        bStep5.Phoenix_Approver__c = UserInfo.getUserId();
        bStep5.Phoenix_Bid__c = pb.Id;
        // bStep.Phoenix_Process_Step__c = pStep.Id;
        bStep5.Phoenix_Status__c =  'Completed';
        bStep5.Phoenix_Approver_Team__c = 'Home Office';
        //stepNo : Ask and increment as per requirements
        bStep5.Phoenix_Sub_Step__c = 1;
        insert bStep5;
              Phoenix_RCAWholesalerEditLineCls.makeApprovalsVistex(pb.Id, 'Comments','Processed');//String bidId, string comments, string status) {

             Phoenix_RCAWholesalerEditLineCls.makeApprovalsIPAContracts(pb.Id, 'Comments','In Process');
     //   Phoenix_RCAWholesalerEditLineCls.makeApprovalsIPAContracts(pb.Id, 'Comments', 'Processed');
      //  Phoenix_RCAWholesalerEditLineCls.makeApprovalsIPAContracts(pb.Id,'Comments','Not Processed');
    }


}