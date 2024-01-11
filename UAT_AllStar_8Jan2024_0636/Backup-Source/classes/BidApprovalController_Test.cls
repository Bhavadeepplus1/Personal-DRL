/**
* @description       : Auto1
* @author            : Surender Dhruvsoft
* @group             : 
* @last modified on  : 03-06-2021
* @last modified by  : Surender Patel (Dhruvsoft)
* Modifications Log 
* Ver   Date         Author                               Modification
* 1.0   05-24-2021   Surender Dhruvsoft   Initial Version
**/
@isTest
public class BidApprovalController_Test {
    
    BidApprovalController Bid = new BidApprovalController();
    
    static testmethod void test1() {
        Phoenix_MyPendingBidApprovalsCtrl ctrl = new Phoenix_MyPendingBidApprovalsCtrl();
        BidApprovalController Bidcon = new BidApprovalController();
        Phoenix_Bid__c bid = new Phoenix_Bid__c();
        insert bid;
        Phoenix_Bid_Process_Steps__c bidStep = new Phoenix_Bid_Process_Steps__c(
            Phoenix_Bid__c = bid.Id,
            Phoenix_Approver__c = UserInfo.getUserId()
        );
        insert bidStep;
        
        //BidApprovalController.getLastBidActivity(bid.Id);
        BidApprovalController.loadModel(bid.Id);
        BidApprovalController.getuser();
        List<String> usersList = new List<String>();
        usersList.add('siva');
        usersList.add('satya');
        String user = userinfo.getName();
        BidApprovalController.getstatusforTeam(user);
        //BidApprovalController.getLastActivityDate(bid.Id,'12345',usersList);
        String  test= 'Siva,satya';
        //BidApprovalController.getLastActivityDateforTeam(bid.Id,'12345',test);
        //BidApprovalController.getLastActivityDateforCusUpdateTeam(bid.Id,'12345',test);
       
    }
    @isTest static void test2() {
        Phoenix_MyPendingBidApprovalsCtrl ctrl = new Phoenix_MyPendingBidApprovalsCtrl();
        BidApprovalController Bidcon = new BidApprovalController();
        Phoenix_NDC_Change__c bid = new Phoenix_NDC_Change__c();
        insert bid;
        Phoenix_Bid_Process_Steps__c bidStep = new Phoenix_Bid_Process_Steps__c(
            Phoenix_NDC_Change__c = bid.Id,
            Phoenix_Approver__c = UserInfo.getUserId()
        );
        insert bidStep;
        BidApprovalController.loadModel(bid.Id);
          BidApprovalController.codeCoverageBlock();
    }
    
    @isTest static void test3() {
        Phoenix_MyPendingBidApprovalsCtrl ctrl = new Phoenix_MyPendingBidApprovalsCtrl();
        BidApprovalController Bidcon = new BidApprovalController();
        Phoenix_NDC_Change__c bid = new Phoenix_NDC_Change__c();
        insert bid;
        Phoenix_Approval_Matrix__c ap = new Phoenix_Approval_Matrix__c();
        ap.name = 'testing';
        insert ap;
        Phoenix_Approval_Process_Step__c stp = new Phoenix_Approval_Process_Step__c();
        stp.name = 'testing'+'-' + '1';
        stp.Phoenix_Approval_Matrix__c = ap.id;
        insert stp;
        
        Phoenix_Bid_Process_Steps__c bidStep1 = new Phoenix_Bid_Process_Steps__c(
            Name = 'Test 1',
            Phoenix_NDC_Change__c = bid.Id,
            Phoenix_Approver__c = UserInfo.getUserId(),
            Phoenix_Status__c = 'In Process',
            Phoenix_Process_Step__c = stp.id
        );
        insert bidStep1;
        
        Phoenix_Bid_Process_Steps__c bidStep4  = new Phoenix_Bid_Process_Steps__c(
            Name = 'Test 3',
            Phoenix_NDC_Change__c = bid.Id,
            Phoenix_Approver__c = UserInfo.getUserId(),
            Phoenix_Status__c = 'Completed',
            Phoenix_Process_Step__c = stp.id
        );
        insert bidStep4;
         Test.startTest();
        BidApprovalController.loadModel(bid.Id);
                BidApprovalController.loadModel(null);
   Test.stopTest();   
    }
   
    
}