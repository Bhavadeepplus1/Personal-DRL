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
@isTest(SeeAllData=true)
public class Phoenix_EditRCALinesClsTest {


    static testmethod void Phoenix_EditRCALinesClsMethod() {
        Id phoenixRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Bid Accounts').getRecordTypeId();
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        Phoenix_Bid__c pb = new Phoenix_Bid__c();
        pb.Phoenix_Status__c = 'New';
        //pb.Phoenix_Bid_Type__c='SRx IPA Price Change';
        pb.Phoenix_Comments__c = 'Test Comments';
        pb.Phoenix_Customer__c = testAccount.Id;
        
        Phoenix_Bid__c pb1 = new Phoenix_Bid__c();
        pb1.Phoenix_Status__c = 'New';
        //pb.Phoenix_Bid_Type__c='SRx IPA Price Change';
        pb1.Phoenix_Comments__c = 'Test Comments';
        pb1.Phoenix_Customer__c = testAccount.Id;
        insert pb1;
        insert pb;
        list < Phoenix_RCA_IPA_LINE__c > lineItemsList = new list < Phoenix_RCA_IPA_LINE__c > ();
        for (Integer i = 0; i < 4; i++) {
            Phoenix_RCA_IPA_LINE__c pbl = new Phoenix_RCA_IPA_LINE__c(Phoenix_Bid__c = pb.Id);
            lineItemsList.add(pbl);
        }
        insert lineItemsList;
        Phoenix_EditRCALinesCls.getRelatedList(pb.Id);
        Phoenix_EditRCALinesCls.deleteLineItems(lineItemsList[0].Id);
        list < Phoenix_RCA_IPA_LINE__c > lineItemsList1 = [select Id, Phoenix_New_GPO__c, Phoenix_Wholesaler__c, Phoenix_Wholesaler_Location__c from Phoenix_RCA_IPA_LINE__c where Phoenix_Bid__c =: pb.Id];
        Phoenix_EditRCALinesCls.saveLineItems(lineItemsList1);
        Phoenix_EditRCALinesCls.getDependentPicklist();
        Phoenix_EditRCALinesCls.saveTobid(pb.Id, 'Comments', 'Processed');
        Phoenix_TestDataCreator testData = new Phoenix_TestDataCreator();
        testData.generateApprovalMatrix();
        //Phoenix_SubmitBidForApprovalCtrl.createBidApprovalItems(new List<Phoenix_Bid__c>{pb});
        Phoenix_Bid_Process_Steps__c bStep = new Phoenix_Bid_Process_Steps__c();
        bStep.Phoenix_Is_Criteria_Step__c = false;
        bStep.Name = pb.Name + '-' + 'Intial Submission';
        bStep.Phoenix_Approver__c = UserInfo.getUserId();
        bStep.Phoenix_Bid__c = pb1.Id;
        // bStep.Phoenix_Process_Step__c = pStep.Id;
        bStep.Phoenix_Status__c = 'Not Processed';
        bStep.Phoenix_Approver_Team__c = 'Marketing';
        //stepNo : Ask and increment as per requirements
        bStep.Phoenix_Sub_Step__c = 1;
        insert bStep;
        Phoenix_Bid_Process_Steps__c bStep1 = new Phoenix_Bid_Process_Steps__c();
        bStep1.Phoenix_Is_Criteria_Step__c = false;
        bStep1.Name = pb.Name + '-' + 'Contracts';
        bStep1.Phoenix_Approver__c = UserInfo.getUserId();
        bStep1.Phoenix_Bid__c = pb.Id;
        // bStep.Phoenix_Process_Step__c = pStep.Id;
        bStep1.Phoenix_Status__c = 'In Process';
        bStep1.Phoenix_Approver_Team__c = 'Marketing';
        //stepNo : Ask and increment as per requirements
        bStep1.Phoenix_Sub_Step__c = 2;
        insert bStep1;
        Phoenix_Bid_Process_Steps__c bStep2 = new Phoenix_Bid_Process_Steps__c();
        bStep1.Phoenix_Is_Criteria_Step__c = false;
        bStep2.Name = pb.Name + '-' + 'Closed';
        bStep2.Phoenix_Approver__c = UserInfo.getUserId();
        bStep2.Phoenix_Bid__c = pb.Id;
        // bStep.Phoenix_Process_Step__c = pStep.Id;
        //bStep2.Phoenix_Status__c =  '';
        bStep2.Phoenix_Approver_Team__c = 'Marketing';
        //stepNo : Ask and increment as per requirements
        bStep2.Phoenix_Sub_Step__c = 3;
        insert bStep2;
        Phoenix_EditRCALinesCls.makeApprovalsIPAContracts(pb.Id, 'Comments', 'Processed');
        Phoenix_EditRCALinesCls.makeApprovalsIPAContracts(pb1.Id, 'Comments', 'Not Processed');
        //Phoenix_EditRCALinesCls.makeApprovalsIPAVistex(pb.Id, 'Comments', 'Processed');
        //Phoenix_EditRCALinesCls.makeApprovalsIPAVistex(pb1.Id, 'Comments', 'Not Processed');
        //Phoenix_EditRCALinesCls.coverage();
        //Phoenix_EditRCALinesCls.makeApprovalsIPAContracts(pb.Id,'Comments','Not Processed');
    }
    
    @isTest
    public static void test2()
    {
        Phoenix_EditRCALinesCls.coverage();
    }



}