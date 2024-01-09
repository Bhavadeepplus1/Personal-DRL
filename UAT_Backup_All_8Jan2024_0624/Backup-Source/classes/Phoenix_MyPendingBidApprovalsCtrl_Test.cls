/**
* @description       : 
* @author            : Surender Patel (Dhruvsoft)
* @group             : 
* @last modified on  : 25-05-2021
* @last modified by  : Surender Patel (Dhruvsoft)
* Modifications Log 
* Ver   Date         Author                       Modification
* 1.0   25-05-2021   Surender Patel (Dhruvsoft)   Initial Versionsendemail
* 
**/
@isTest
public class Phoenix_MyPendingBidApprovalsCtrl_Test{
    
    
    static testmethod void test1() {
        Phoenix_TestDataCreator testData = new Phoenix_TestDataCreator();
        testData.generateBids();
        testData.generateApprovalMatrix();
      
        Phoenix_NDC_Change__c pnc = New Phoenix_NDC_Change__c();
        pnc.Phoenix_Proposed_Product_Family__c='Test';
        insert pnc; 
        
        Phoenix_NDC_Change__c pnc2 = New Phoenix_NDC_Change__c();
        pnc2.Phoenix_Proposed_Product_Family__c='Data';
        insert pnc2; 
        
        Account a= new account();
        a.name='dfgdg';
        insert a;
       
        
        Phoenix_MyPendingBidApprovalsCtrl.loadModel();
        Phoenix_MyPendingBidApprovalsCtrl.getPendingApprovals();
        //Phoenix_MyPendingBidApprovalsCtrl.sendEmailToAllApprovers();
        Phoenix_MyPendingBidApprovalsCtrl.popUPBidsDue();
        Phoenix_MyPendingBidApprovalsCtrl.sendEmailtoVistex();
        Phoenix_MyPendingBidApprovalsCtrl.salesUsersatCustomersUpdate();
        //Phoenix_MyPendingBidApprovalsCtrl.BidApprovalModel();
        //Phoenix_MyPendingBidApprovalsCtrl.coverageBlock();
        Phoenix_MyPendingBidApprovalsCtrl ctrl = new Phoenix_MyPendingBidApprovalsCtrl();
       
       
        
        Phoenix_Bid__c bid = new Phoenix_Bid__c();
        insert bid;
      
        Profile standardPlatformProfile = [SELECT Id, Name FROM Profile LIMIT 1];
		User testUser = new User(
             ProfileId = standardPlatformProfile.Id,
             Username = 'HomeOffice@example.com',
             Email = 'testmahesh@dhruvsoft.com',
             Alias = 'Mahi',
             TimeZoneSidKey = 'GMT',
             FirstName = 'Mathe',
             LastName = 'Mahesh',
             LocaleSidKey = 'en_IN',
             EmailEncodingKey = 'UTF-8',
             LanguageLocaleKey = 'en_US'
           );
        insert testUser;
        
        Phoenix_Bid__c bid2 = new Phoenix_Bid__c();
        bid2.Phoenix_Internal_Target_Date__c = system.today()-2;
        bid2.Phoenix_Approval_Status__c='Customer\'s Update';
        bid2.Phoenix_Sent_to_Vistex_Date__c=system.today()+2;
        bid2.Phoenix_Bid_Type__c='RFP';
        bid2.Phoenix_Customer__c=a.id;
        bid2.Phoenix_Bid_Created_Behalf_of__c=userinfo.getUserId();
        //bid2.Phoenix_Approval_status_at_Hold__c='Vistex Update';
        bid2.Phoenix_Approval_Status__c = 'Vistex Update';
        bid2.Phoenix_Bid_Name__c='test';
        bid2.Phoenix_Sales_Person_2__c = testUser.Id;
        bid2.Phoenix_Salesperson__c = testUser.Id;
        bid2.Phoenix_Approver__c = UserInfo.getUserId();
        Boolean isCRCompleted = true;
        insert bid2;
        
        Phoenix_User_Approval_Matrix__c usmatrix = new Phoenix_User_Approval_Matrix__c();
        usmatrix.Phoenix_Approver_Group_Name__c = 'Home Office';
        usmatrix.Name = 'test';
        usmatrix.Phoenix_Approver__c = UserInfo.getUserId();
        insert usmatrix;
        
        Phoenix_Bid__c bid3 = new Phoenix_Bid__c();
        bid3.Phoenix_Internal_Target_Date__c = system.today()-2;
        bid3.Phoenix_Approval_Status__c = 'On Hold';
        bid3.Phoenix_Sent_to_Vistex_Date__c = system.today()+2;
        bid3.Phoenix_Bid_Type__c = 'RFP';
        bid3.Phoenix_Customer__c = a.id;
        bid3.Phoenix_Bid_Created_Behalf_of__c = userinfo.getUserId();
        bid3.Phoenix_Approval_Status__c = 'Customer\'s Update';
        bid3.Phoenix_Bid_Name__c='test';
        bid3.Phoenix_Sales_Person_2__c = testUser.Id;
        bid3.Phoenix_Salesperson__c = testUser.Id;
        bid3.Phoenix_Approver__c = UserInfo.getUserId();
        insert bid3;
        
        Phoenix_Bid__c bid4 = new Phoenix_Bid__c();
        bid4.Phoenix_Internal_Target_Date__c = system.today();
        bid4.Phoenix_Approval_Status__c='On Hold';
        bid4.Phoenix_Sent_to_Vistex_Date__c=system.today();
        bid4.Phoenix_Bid_Type__c='RFP';
        bid4.Phoenix_Customer__c=a.id;
        bid4.Phoenix_Bid_Created_Behalf_of__c=userinfo.getUserId();
        bid4.Phoenix_Approval_status_at_Hold__c='Vistex Update';
        bid4.Phoenix_Bid_Name__c='test';
        insert bid4;
       
        
        Phoenix_WAC_Change__c wac = new Phoenix_WAC_Change__c();
        wac.Phoenix_Effective_Date__c = system.today()+2;
        wac.Phoenix_Product_Family__c = 'Test';
        wac.Phoenix_WAC_Change_Name__c = 'Data';
        insert wac;
        
        Phoenix_WAC_Change__c wac2 = new Phoenix_WAC_Change__c();
        wac2.Phoenix_Effective_Date__c = system.today()+2;
        wac2.Phoenix_Product_Family__c = 'Test';
        wac2.Phoenix_WAC_Change_Name__c = 'Data';
        insert wac2;
        
        Phoenix_Approval_Matrix__c matrix = new Phoenix_Approval_Matrix__c();
        matrix.Name = 'Customer'+ '\''+'s Update';
        Insert matrix;
       
        Phoenix_Approval_Process_Step__c appstep = new Phoenix_Approval_Process_Step__c();
        appstep.Phoenix_Order__c = 2.0;
        appstep.Name = 'Customer'+ '\''+'s Update';
        appstep.Phoenix_Approval_Matrix__c = matrix.Id;
        appstep.Name='test';
        Insert appstep;

       //Phoneix bid process records insertion
        Phoenix_Bid_Process_Steps__c step = new Phoenix_Bid_Process_Steps__c();
        step.Phoenix_Approval_Sent_Time__c = System.Today();
        step.Phoenix_Process_Step__c = appstep.id;
        step.Phoenix_NDC_Change__c = pnc.Id;
        step.Phoenix_Approver__c = userinfo.getUserId();
        step.Phoenix_Bid__c = bid2.Id;
        step.Phoenix_WAC_Change__c = wac.Id;
        step.Phoenix_Approver_Team__c='Home Office';
        step.Phoenix_Status__c = 'In Process';
        insert step;
        
        Phoenix_Bid_Process_Steps__c step2 = new Phoenix_Bid_Process_Steps__c();
        step2.Phoenix_Approval_Sent_Time__c = System.Today();
        step2.Phoenix_Process_Step__c = appstep.id;
        step2.Phoenix_NDC_Change__c = pnc.Id;
        step2.Phoenix_Approver__c = userinfo.getUserId();
        step2.Phoenix_Bid__c = bid3.Id;
        step2.Phoenix_WAC_Change__c = wac.Id;
        step2.Phoenix_Approver_Team__c='Home Office';
        step2.Phoenix_Status__c = 'In Process';
        insert step2;
        
        
        
        Phoenix_Bid_Process_Steps__c wacStep = new Phoenix_Bid_Process_Steps__c();
        wacStep.Phoenix_WAC_Change__c = wac.Id;
        wacStep.Phoenix_NDC_Change__c = pnc.Id;
        wacStep.Phoenix_Approver__c = UserInfo.getUserId();
        wacStep.Phoenix_Status__c = 'In Process';
        wacStep.Phoenix_Bid__c = bid4.Id;
        wacStep.Phoenix_Approver_Team__c = 'Finance';
        insert wacStep;
       
               
        Phoenix_Approval_Process_Step__c appstep1 = new Phoenix_Approval_Process_Step__c();
        appstep1.Phoenix_Order__c = 3.0;
        appstep1.Name = 'Marketing Lead OTC';
        appstep1.Phoenix_Approval_Matrix__c = matrix.Id;
        Insert appstep1;
        
        Phoenix_NDC_Change__c ndc = new Phoenix_NDC_Change__c();
        insert ndc;
       
        Phoenix_Bid_Process_Steps__c ndcStep = new Phoenix_Bid_Process_Steps__c(
            Phoenix_NDC_Change__c = ndc.Id,
            Phoenix_Approver__c = UserInfo.getUserId(),
            Phoenix_Status__c = 'In Process',
            Phoenix_Approver_Team__c = 'Finance'
        );
        insert ndcStep;
        
        Phoenix_PHS_Price_Change__c phs = new Phoenix_PHS_Price_Change__c();
        insert phs;
       
        Phoenix_Bid_Process_Steps__c phsStep = new Phoenix_Bid_Process_Steps__c(
            Phoenix_PHS_Price_Change__c = phs.Id,
            Phoenix_Approver__c = UserInfo.getUserId(),
            Phoenix_Status__c = 'In Process',
            Phoenix_Approver_Team__c = 'Finance'
        );
        insert phsStep;
        
        New_Product_WAC_Pricing__c  newWac = new New_Product_WAC_Pricing__c();
        insert newWAC;
       
        Phoenix_Bid_Process_Steps__c newWacStep = new Phoenix_Bid_Process_Steps__c(
            Phoenix_New_Product_WAC_Pricing__c = newWac.Id,
            Phoenix_Approver__c = UserInfo.getUserId(),
            Phoenix_Status__c = 'In Process',
            Phoenix_Approver_Team__c = 'Finance'
        );
        insert newWacStep;
        
        
        Phoenix_Bid_Process_Steps__c bidStep = new Phoenix_Bid_Process_Steps__c(
            Phoenix_NDC_Change__c = ndc.Id,
            Phoenix_Bid__c = bid.Id,
            Phoenix_Approver__c = UserInfo.getUserId(),
            Phoenix_Status__c = 'In Process',
            Phoenix_Approver_Team__c = 'Finance',Phoenix_WAC_Change__c=wac.Id,
            Phoenix_PHS_Price_Change__c = phs.Id
        );
        insert bidStep;
        
        Phoenix_Bid_Process_Steps__c bidStep2 = new Phoenix_Bid_Process_Steps__c(
            Phoenix_Bid__c = bid2.Id,
            Phoenix_Approver__c=UserInfo.getUserId(),
            Phoenix_Status__c = 'In Process',
            Phoenix_Approver_Team__c = 'Finance'
        );
        insert bidStep2;
       
        Phoenix_Bid_Process_Steps__c bidStep3 = new Phoenix_Bid_Process_Steps__c(
            Phoenix_Bid__c = bid2.Id,
            Phoenix_Approver__c=UserInfo.getUserId(),
            Phoenix_Status__c = 'In Process',
            Phoenix_Approver_Team__c = 'Finance',
            Phoenix_Is_Criteria_Step__c =true,
            Phoenix_Process_Step__c=appstep1.id,
            name='test'
        );
        insert bidStep3;
        
        Phoenix_Bid_Process_Steps__c bidStep4 = new Phoenix_Bid_Process_Steps__c(
            Phoenix_Bid__c = bid2.Id,
            Phoenix_Approver__c=UserInfo.getUserId(),
            Phoenix_Status__c = 'In Process',
            Phoenix_Approver_Team__c = 'Home Office',
            Phoenix_Is_Criteria_Step__c =true,
            Phoenix_Process_Step__c=appstep1.id,
            Phoenix_Approver_Team_Members__c=userinfo.getName(),
            name='test'
        );
        insert bidStep4;
        
        List<Phoenix_Customer_Response__c> listData = New List<Phoenix_Customer_Response__c>();
        Phoenix_Customer_Response__c cR = new Phoenix_Customer_Response__c();
        cr.Delay_Type__c = 'N/A';
        cr.Phoenix_Bid_No__c =bid.Id;
        cr.Phoenix_Contract_Status__c= 'Completed';
        listData.add(cr);
        insert listData;
        
        Phoenix_MyPendingBidApprovalsCtrl.loadModel();
        Phoenix_MyPendingBidApprovalsCtrl.sendEmailToAllApprovers();
        Phoenix_MyPendingBidApprovalsCtrl.sendEmailtoVistex();
        Phoenix_MyPendingBidApprovalsCtrl.Bid wrap = new Phoenix_MyPendingBidApprovalsCtrl.Bid();
        //wrap.bidId = bid.Id;
        
        
        //Phoenix_MyPendingBidApprovalsCtrl.codeCoverage();
        //
       
        
    }
   
}