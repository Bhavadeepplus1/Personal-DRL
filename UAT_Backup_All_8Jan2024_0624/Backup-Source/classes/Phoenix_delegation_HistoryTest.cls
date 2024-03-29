@isTest
public class Phoenix_delegation_HistoryTest {
    static testmethod void test1() {
        Phoenix_delegation_History.getExistingDeleRecords('111111111','11111111111', 1, 10);
        Phoenix_delegation_History.getExistingDeleRecords('','11111111111', 1, 10);
        Phoenix_delegation_History.getExistingDeleRecords('','', 1, 10);
        Phoenix_delegation_History.getExistingDeleRecords('111111111','', 1, 10);
        Phoenix_delegation_History.getPendingApprovals('111111111');
        Phoenix_delegation_History.formatDateEST(Date.today());
        Phoenix_delegation_History.codeCoverage();
    }
    static testmethod void test2() {
        Phoenix_TestDataCreator testData = new Phoenix_TestDataCreator();
        testData.generateBids();
        testData.generateApprovalMatrix();
        Phoenix_NDC_Change__c pnc = New Phoenix_NDC_Change__c();
        pnc.Phoenix_Proposed_Product_Family__c='Test';
        insert pnc;
        Account a= new account();
        a.name='dfgdg';
        insert a;
        Phoenix_Bid_Process_Steps__c step = new Phoenix_Bid_Process_Steps__c();
        step.Phoenix_NDC_Change__c = pnc.Id;
        step.Phoenix_Approver__c = userinfo.getUserId();
        insert step;
        
        Phoenix_delegation_History.getPendingApprovals(UserInfo.getUserId());
        Phoenix_Bid__c bid = new Phoenix_Bid__c();
        insert bid;
        Phoenix_Bid__c bid2 = new Phoenix_Bid__c();
        bid2.Phoenix_Internal_Target_Date__c = system.today()+2;
        bid2.Phoenix_Approval_Status__c='On Hold';
        bid2.Phoenix_Sent_to_Vistex_Date__c=system.today()+2;
        bid2.Phoenix_Bid_Type__c='RFP';
        bid2.Phoenix_Customer__c=a.id;
        bid2.Phoenix_Bid_Created_Behalf_of__c=userinfo.getUserId();
        bid2.Phoenix_Approval_status_at_Hold__c='Vistex Update';
        bid2.Phoenix_Bid_Name__c='test';
        //bid2.Phoenix_Approval_Status__c
        insert bid2;
        Phoenix_Bid__c bid3 = new Phoenix_Bid__c();
        bid2.Phoenix_Internal_Target_Date__c = system.today()+1;
        insert bid3;
        
        Phoenix_WAC_Change__c wac = new Phoenix_WAC_Change__c();
        insert wac;
        Phoenix_Bid_Process_Steps__c wacStep = new Phoenix_Bid_Process_Steps__c(
            Phoenix_WAC_Change__c = wac.Id,
            Phoenix_Approver__c = UserInfo.getUserId(),
            Phoenix_Status__c = 'In Process',
            Phoenix_Approver_Team__c = 'Finance'
        );
        insert wacStep;
        Phoenix_Approval_Matrix__c matrix = new Phoenix_Approval_Matrix__c();
        matrix.Name = 'Marketing Approval';
        
        Insert matrix;
        Phoenix_Approval_Process_Step__c appstep = new Phoenix_Approval_Process_Step__c();
        appstep.Phoenix_Order__c = 2.0;
        appstep.Name = 'Marketing Approval';
        appstep.Phoenix_Approval_Matrix__c = matrix.Id;
        appstep.Name='test';
        Insert appstep;
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
        Phoenix_Customer_Response__c cR = new Phoenix_Customer_Response__c();
        cr.Delay_Type__c = 'N/A';
        cr.Phoenix_Bid_No__c =bid.Id;
        cr.Phoenix_Contract_Status__c= 'Completed';
        insert cr;
        
    }
    
    
}