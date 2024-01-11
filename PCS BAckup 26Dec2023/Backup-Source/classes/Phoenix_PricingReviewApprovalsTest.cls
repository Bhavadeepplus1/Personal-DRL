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
public class Phoenix_PricingReviewApprovalsTest {

    @testSetup static void setupTestData() {
        Id phoenixRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Bid Accounts').getRecordTypeId();
        Account testAccount = new Account(Name = 'Test Account', Phoenix_Preferred_Wholesaler__c = 'ABC', Phoenix_Is_Govt_Customer__c = true);
        insert testAccount;

        Phoenix_Bid__c bid = new Phoenix_Bid__c();
        bid.Phoenix_Status__c = 'New';
        bid.Phoenix_Comments__c = 'Test Comments';
        bid.Phoenix_Approval_Status__c = 'Draft';
        bid.Phoenix_Customer__c = testAccount.Id;
        insert bid;

        ContentVersion contentVersion = new ContentVersion(
            Title = 'Penguins',
            PathOnClient = 'Penguins.jpg',
            VersionData = Blob.valueOf('Test Content'),
            IsMajorVersion = true
        );
        insert contentVersion;
        List < ContentDocument > documents = [
            SELECT Id, Title, LatestPublishedVersionId
            FROM ContentDocument
        ];
        String docId = documents[0].Id;
        //create ContentDocumentLink  record 
        ContentDocumentLink cdl = New ContentDocumentLink();
        cdl.LinkedEntityId = bid.Id;
        cdl.ContentDocumentId = documents[0].Id;
        cdl.shareType = 'V';
        insert cdl;

        //--------------Approval--------------
        Phoenix_Approval_Matrix__c appro = new Phoenix_Approval_Matrix__c();
        appro.Phoenix_Bid_Type__c = 'Customer Requested Pricing Confirmations';
        appro.Name = 'Pricing Review';
        insert appro;

        Phoenix_Approval_Process_Step__c proI = new Phoenix_Approval_Process_Step__c();
        proI.Name = 'Initial Submission';
        proI.Phoenix_Order__c = 1;
        proI.Phoenix_Approval_Matrix__c = appro.Id;
        insert proI;

        Phoenix_Approval_Process_Step__c pro = new Phoenix_Approval_Process_Step__c();
        pro.Name = 'Business Head';
        pro.Phoenix_Order__c = 2;
        pro.Phoenix_Approval_Matrix__c = appro.Id;
        insert pro;

        Phoenix_Approval_Process_Step__c pro1 = new Phoenix_Approval_Process_Step__c();
        pro1.Name = 'Contracts';
        pro1.Phoenix_Order__c = 3;
        pro1.Phoenix_Approval_Matrix__c = appro.Id;
        insert pro1;

        Phoenix_Approval_Process_Step__c proClosed = new Phoenix_Approval_Process_Step__c();
        proClosed.Name = 'Closed';
        proClosed.Phoenix_Order__c = 4;
        proClosed.Phoenix_Approval_Matrix__c = appro.Id;
        insert proClosed;

        List < Phoenix_Bid_Process_Steps__c > processSteps = new List < Phoenix_Bid_Process_Steps__c > ();
        Phoenix_Bid_Process_Steps__c processStep1 = new Phoenix_Bid_Process_Steps__c();
        processStep1.Phoenix_Bid__c = bid.Id;
        processStep1.Phoenix_Process_Step__c = proI.Id;
        processStep1.Phoenix_Status__c = 'Submitted';
        // processStep1.Phoenix_Sub_Step__c=1;
        processSteps.add(processStep1);
        insert processSteps;

        List < Phoenix_Bid_Process_Steps__c > processStepNext = new List < Phoenix_Bid_Process_Steps__c > ();
        Phoenix_Bid_Process_Steps__c processStep = new Phoenix_Bid_Process_Steps__c();
        processStep.Phoenix_Bid__c = bid.Id;
        processStep.Phoenix_Process_Step__c = pro.Id;
        processStep.Phoenix_Status__c = 'In Process';
        // processStep.Phoenix_Sub_Step__c=2;
        processStepNext.add(processStep);
        insert processStepNext;

        List < Phoenix_Bid_Process_Steps__c > processStepNextStep = new List < Phoenix_Bid_Process_Steps__c > ();
        Phoenix_Bid_Process_Steps__c processStep3 = new Phoenix_Bid_Process_Steps__c();
        processStep3.Phoenix_Bid__c = bid.Id;
        processStep3.Phoenix_Process_Step__c = pro1.Id;
        processStep3.Phoenix_Status__c = 'Not Initiated';
        processStep3.Phoenix_Sub_Step__c = 3;
        processStepNextStep.add(processStep3);
        insert processStepNextStep;

        List < Phoenix_Bid_Process_Steps__c > processStepClose = new List < Phoenix_Bid_Process_Steps__c > ();
        Phoenix_Bid_Process_Steps__c processStepCl = new Phoenix_Bid_Process_Steps__c();
        processStepCl.Phoenix_Bid__c = bid.Id;
        processStepCl.Phoenix_Process_Step__c = proClosed.Id;
        processStepCl.Phoenix_Status__c = 'Not Initiated';
        processStep3.Phoenix_Sub_Step__c = 4;
        processStepClose.add(processStepCl);
        insert processStepClose;

        //-------Approval Test Data End-----------------

    }

    static testmethod void getBid() {

        Phoenix_Bid__c bid = [SELECT Id FROM Phoenix_Bid__c WHERE Phoenix_Approval_Status__c = 'Draft'
            LIMIT 1
        ];

        bid.Phoenix_Review_Details__c = 'Test';
        update bid;
        ContentDocumentLink bid1 = [SELECT Id, ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId =: bid.Id LIMIT 1];
        List < Phoenix_Bid_Process_Steps__c > bidProcess = [select id, Phoenix_Status__c from Phoenix_Bid_Process_Steps__c where Phoenix_Sub_Step__c = 3];
        bidProcess[0].Phoenix_Status__c = 'In Process';
        update bidProcess;

        Phoenix_PricingReviewApprovals.saveToBid(bid.Id, 'test');
        Phoenix_PricingReviewApprovals.saveToBidBus(bid.Id, 'Approved', 'Business Head');
        Phoenix_PricingReviewApprovals.saveToBidContr(bid.Id, 'Processed', 'Business Head');
        Phoenix_PricingReviewApprovals.getBid(bid.Id);
        Phoenix_PricingReviewApprovals.deleteAttachments(bid1.ContentDocumentId, bid.Id);
        Phoenix_PricingReviewApprovals.getDocs(bid.Id);
        Phoenix_PricingReviewApprovals.makeApprovalsBusiness(bid.Id, 'test', 'Approved', 'Business Head');
        Phoenix_PricingReviewApprovals.makeApprovalsBusiness(bid.Id, 'test', 'Not Approved', 'Business Head');
        //  Phoenix_PricingReviewApprovals.makeApprovalsContracts(bid.Id,'test','Processed','Contracts');
    }

    static testmethod void contractsApproval() {
        Phoenix_Bid__c bid = [SELECT Id FROM Phoenix_Bid__c LIMIT 1];
        Phoenix_PricingReviewApprovals.makeApprovalsContracts(bid.Id, 'test', 'Not Processed', 'Contracts');

    }
}