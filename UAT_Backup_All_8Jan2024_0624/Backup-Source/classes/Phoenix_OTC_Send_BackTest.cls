@isTest(SeeAllData=true)
public class Phoenix_OTC_Send_BackTest {
    static testmethod void SubmitBidforApproval() {
        Phoenix_Contract__c contract = new Phoenix_Contract__c();
        contract.Name = 'test contract';
        contract.Phoenix_Contract_Start_Date__c = system.today();
        contract.Phoenix_Contract_Internal_Description__c = 'test cotract for OTC';
        contract.Phoenix_Contract_Number__c = '123456';
        insert contract;
        
        Phoenix_Bid__c pb = new Phoenix_Bid__c();
        pb.Phoenix_Status__c = 'New';
        pb.Phoenix_Comments__c = 'Test Comments';
        pb.Phoenix_Customer_Bid_Deadline_Date_Time__c = DateTime.now();
        pb.Phoenix_Customer_Bid_Deadline_Time_zone__c = 'PST';
        pb.Phoenix_Customer_Bid_Deadline_Time__c = '6 PM';
        pb.Phoenix_Customer_Type__c = 'Direct and Indirect';
        pb.Phoenix_Bid_Deadline_Date__c = System.today();
        pb.Phoenix_Bid_Type__c = 'RFP Bids';
        pb.Phoenix_Approval_Status__c = 'Draft';
        pb.Phoenix_Reference_Contracts__c = '123456';
        insert pb;
        Phoenix_Bid_Line_Item__c bl = new Phoenix_Bid_Line_Item__c();
        bl.Phoenix_Bid__c = pb.Id;
        bl.Phoenix_Product_Director1__c = UserInfo.getName();
        bl.Phoenix_Is_New_Low_Triggered__c = true;
        bl.Phoenix_Approved_Lowest_Price_SKU__c = 10;
        bl.Phoenix_Customer_Approval_OTC__c = 'Send Back to Marketing';		
        bl.Phoenix_Orange_Book_Rating1__c = 'Version 1';
        insert bl;
        Phoenix_Bid_Line_Item__c bl1 = new Phoenix_Bid_Line_Item__c();
        bl1.Phoenix_Bid__c = pb.Id;
        bl1.Phoenix_Product_Director1__c = UserInfo.getName();
        bl1.Phoenix_Customer_Approval_OTC__c = 'Send Back to Marketing';
        bl1.Phoenix_Current_Direct_Price__c = 10;
        bl1.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        bl1.Phoenix_SCM_Approval_Y_N__c = 'Y- Only Current Monthly Demand Approved';
        bl1.Phoenix_Marketing_Final_Approval__c = true;
        bl1.Phoenix_Orange_Book_Rating1__c = 'Version 1';
        insert bl1;
        Phoenix_Customer_Response__c custResponse = new Phoenix_Customer_Response__c();
        custResponse.Phoenix_Bid_No__c = pb.Id;
        custResponse.Phoenix_Customer__c =  pb.Phoenix_Customer__c;
        custResponse.Phoenix_Affected_Contract_s__c = pb.Phoenix_Reference_Contracts__c;
        custResponse.Phoenix_Sent_to_Customer_Date__c = system.today();
        custResponse.Phoenix_Customer_Response_Date__c = system.today();
        custResponse.Phoenix_Contracts_for_Vistex_Update__c =  pb.Phoenix_Reference_Contracts__c;
        custResponse.Phoenix_Items_Pending__c = 'All Items Settled';
        custResponse.Phoenix_Contract_Status__c = 'Completed';
        custResponse.Phoenix_Contract_Update_Date__c = system.today();
        insert custResponse;
            
        
        Phoenix_Approval_Matrix__c matrix = new Phoenix_Approval_Matrix__c();
        matrix.Name = 'Marketing Approval';
        Insert matrix;
        Phoenix_Approval_Process_Step__c appstep = new Phoenix_Approval_Process_Step__c();
        appstep.Phoenix_Order__c = 2.0;
        appstep.Name = 'Marketing Approval';
        appstep.Phoenix_Approval_Matrix__c = matrix.Id;
        Insert appstep;
        Phoenix_Bid_Process_Steps__c ps = new Phoenix_Bid_Process_Steps__c();
        ps.Phoenix_Approver__c = UserInfo.getUserId();
        ps.Phoenix_Process_Step__c =appstep.Id;
        ps.Phoenix_Bid__c = pb.Id;
        ps.Name = 'Marketing Approval';
        insert ps;
        List<Phoenix_Bid_Line_Item__c> ListOfLines = new List<Phoenix_Bid_Line_Item__c>();
        ListOfLines.add(bl);
        ListOfLines.add(bl1);
        Phoenix_OTC_Send_Back.sendBackToMkg(pb.Id,ListOfLines);
        //Phoenix_OTC_Send_Back.createActionItem(pb.Id,ListOfLines);
        Phoenix_OTC_Send_Back.createCustomerResponse(pb.Id);
        Phoenix_OTC_Send_Back.createCustomerLines(custResponse, new List<Phoenix_Bid__c>{pb});
        Phoenix_OTC_Send_Back.getContracts(pb.Phoenix_Reference_Contracts__c);
        Phoenix_OTC_Send_Back.createActionItem(pb.Id,new List<Phoenix_Bid_Line_Item__c>{bl,bl1});
    }

}