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
@isTest
public class CheckListControllerTest {
    @isTest
    public static void checklistMethod() {
        Id phoenixRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Bid Accounts').getRecordTypeId();
        Account testAccount = new Account(Name = 'Test Account', Phoenix_Preferred_Wholesaler__c = 'ABC', Phoenix_Is_Govt_Customer__c = true);
        insert testAccount;

        Phoenix_Bid__c bid = new Phoenix_Bid__c();
        bid.Phoenix_Status__c = 'New';
        bid.Phoenix_Comments__c = 'Test Comments';
        bid.Phoenix_Customer__c = testAccount.Id;
     
        insert bid;


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

        Checklist__c check = new Checklist__c();
        // check.Name='test';
        check.Bid__c = bid.Id;

        insert check;
        check.Bonafide_fee__c = 1;
        update check;
        Phoenix_Bid__c bid1 = [select id, Phoenix_Bid_Type__c, Phoenix_Is_Checklist_Exist__c, Phoenix_Vistex_Update__c, Phoenix_Vistex_Update_Comments__c from Phoenix_Bid__c where Phoenix_Status__c = 'New'  LIMIT 1 ];


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
        cdl.LinkedEntityId = bid1.Id;
        cdl.ContentDocumentId = documents[0].Id;
        cdl.shareType = 'V';
        insert cdl;
        CheckListController.deleteAttachments(cdl.ContentDocumentId, bid1.Id);
        CheckListController.getDocs(bid1.Id);
        CheckListController.delChecklist(bid1.Id);
        CheckListController.saveToBidBus(bid1.Id, 'Processed', 'test');
        CheckListController.checkListRec(check.Id);
        CheckListController.getBid(bid1.Id);
        CheckListController.makeApprovalsBusiness(bid.Id, 'test', 'Processed', 'Vistex Update');


    }
  @isTest
    public static void checklistMethod1() {
          Account testAccount = new Account(Name = 'Test Account', Phoenix_Preferred_Wholesaler__c = 'ABC', Phoenix_Is_Govt_Customer__c = true);
        insert testAccount;

        Phoenix_Bid__c bid = new Phoenix_Bid__c();
        bid.Phoenix_Status__c = 'New';
        bid.Phoenix_Comments__c = 'Test Comments';
        bid.Phoenix_Customer__c = testAccount.Id;
            bid.Phoenix_Is_Checklist_Exist__c = true;
        bid.Phoenix_Bid_Type__c = 'Price Change';
        bid.Phoenix_Approval_Status__c = 'Customer';
        bid.Phoenix_Vistex_Update__c = 'Processed';
        bid.Phoenix_Vistex_Update_Comments__c= 'Test';
        insert bid;
      
          Phoenix_Bid__c bid2 = [select id, Phoenix_Bid_Type__c, Phoenix_Approval_Status__c, Phoenix_Is_Checklist_Exist__c, Phoenix_Vistex_Update__c, Phoenix_Vistex_Update_Comments__c from Phoenix_Bid__c where id=:bid.id  limit 1];      
         Checklist__c check = new Checklist__c();
        check.Bid__c = bid.Id;
        insert check;
 //******************************Marketing
        
        Id devRecordTypeId = Schema.SObjectType.Phoenix_User_Approval_Matrix__c.getRecordTypeInfosByName().get('Approval User Group').getRecordTypeId();
        Phoenix_User_Approval_Matrix__c app11 = new Phoenix_User_Approval_Matrix__c();
        app11.Name = 'Marketing User Group Testing 1';
        app11.Phoenix_Approver_Group_Name__c = 'Home Office';
        app11.RecordTypeId = devRecordTypeId;
        insert app11;
        
        Phoenix_User_Approval_Matrix__c app22 = new Phoenix_User_Approval_Matrix__c();
        app22.Name = 'Marketing User Group Testing 2';
        app22.Phoenix_Approver_Group_Name__c = 'Home Office';
        app22.RecordTypeId = devRecordTypeId;
        insert app22;
        
        Phoenix_User_Approval_Matrix__c app1 = new Phoenix_User_Approval_Matrix__c();
        app1.Name = 'Testing 1';
        app1.Phoenix_Approver__c = UserInfo.getUserId();
        app1.User_Group__c = app11.id;
        insert app1;
        
        Phoenix_User_Approval_Matrix__c app2 = new Phoenix_User_Approval_Matrix__c();
        app2.Name = 'Testing 2';
        app2.User_Group__c = app22.id;
        app2.Phoenix_Approver__c = UserInfo.getUserId();
        insert app2; 
        
        //******************************Contracts
        Phoenix_User_Approval_Matrix__c app111 = new Phoenix_User_Approval_Matrix__c();
        app111.Name = 'Contracts User Group Testing 1';
        app111.Phoenix_Approver_Group_Name__c = 'Home Office';
        app111.RecordTypeId = devRecordTypeId;
        insert app111;
        
        Phoenix_User_Approval_Matrix__c app222 = new Phoenix_User_Approval_Matrix__c();
        app222.Name = 'Contracts User Group Testing 2';
        app222.Phoenix_Approver_Group_Name__c = 'Home Office';
        app222.RecordTypeId = devRecordTypeId;
        insert app222;
        
        Phoenix_User_Approval_Matrix__c app12 = new Phoenix_User_Approval_Matrix__c();
        app12.Name = 'Testing 1';
        app12.Phoenix_Approver__c = UserInfo.getUserId();
        app12.User_Group__c = app111.id;
        insert app12;
        
        Phoenix_User_Approval_Matrix__c app23 = new Phoenix_User_Approval_Matrix__c();
        app23.Name = 'Testing 2';
        app23.User_Group__c = app222.id;
        app23.Phoenix_Approver__c = UserInfo.getUserId();
        insert app23; 
        
   CheckListController.checkListRec(bid.Id);
        
      

    }

}