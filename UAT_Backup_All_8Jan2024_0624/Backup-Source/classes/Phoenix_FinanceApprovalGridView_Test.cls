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
public class Phoenix_FinanceApprovalGridView_Test {
    
    static testmethod void test1() {
        Phoenix_Approval_Delegation_History__c deleHistory = new Phoenix_Approval_Delegation_History__c();
        deleHistory.Phoenix_Delegation_Start_Time__c =  system.now();
        deleHistory.Phoenix_Delegation_End_Time__c = datetime.newInstance(2023, 9, 15, 12, 30, 0); 
        deleHistory.Phoenix_Delegated_Approver__c=userInfo.getUserId();
    deleHistory.Phoenix_Is_Active_delegator__c = True;
        insert deleHistory;
         Phoenix_Approval_Delegation_History__c deleHistory1 = new Phoenix_Approval_Delegation_History__c();
        deleHistory1.Phoenix_Delegation_Start_Time__c =  system.now();
        deleHistory1.Phoenix_Delegation_End_Time__c = datetime.newInstance(2023, 9, 15, 12, 30, 0); 
        deleHistory1.Phoenix_Delegated_Approver__c=userInfo.getUserId();
    deleHistory.Phoenix_Is_Active_delegator__c = false;
        insert deleHistory1;
        Phoenix_TestDataCreator testData = new Phoenix_TestDataCreator();
        testData.generateBids();
        testData.generateApprovalMatrix();
        Phoenix_FinanceApprovalGridView.getScmData(testData.bidsList[0].Id);
        
        
        Phoenix_SubmitBidForApprovalCtrl.calculateFinanceGrid(testData.bidsList[0].Id);
        Map < String, String > approvalMap = new Map < String, String > ();
        approvalMap.put('Levocetrizine', 'Approved');
        
        Map < String, String > commentsMap = new Map < String, String > ();
        commentsMap.put('Levocetrizine', 'Approved');
        Map < String, String > SRXmap = new Map < String, String > ();
        Map < String, String > RXmap = new Map < String, String > ();
        Map < String, String > OTCmap = new Map < String, String > ();
        SRXmap.put('Levocetrizine', 'Approved');
        RXmap.put('Levocetrizine', 'Approved');
        OTCmap.put('Levocetrizine', 'Approved');
        Phoenix_FinanceApprovalGrid.updateLineItems(testData.bidsList[0].Id, approvalMap, commentsMap, approvalMap, commentsMap, approvalMap, commentsMap, SRXmap, RXmap, OTCmap);
        //Phoenix_FinanceApprovalGrid.makeApprovals(testData.bidsList[0].Id);
        Account testAccount = new Account(Name = 'Test Account');
        testAccount.Phoenix_Contracts_Approver__c = Userinfo.getUserId();
        insert testAccount;
        Phoenix_Bid__c pb = new Phoenix_Bid__c();
        pb.Phoenix_Status__c = 'New';
        pb.Phoenix_Comments__c = 'Test Comments';
        pb.Phoenix_Customer__c = testAccount.Id;
        pb.Phoenix_Customer_Bid_Deadline_Date_Time__c = DateTime.now();
        pb.Phoenix_Customer_Bid_Deadline_Time_zone__c = 'PST';
        pb.Phoenix_Customer_Bid_Deadline_Time__c = '6 PM';
        pb.Phoenix_Bid_Deadline_Date__c = System.today();
        pb.Phoenix_Bid_Type__c = 'RFP Bids';
        pb.Phoenix_Approval_Status__c = 'Draft';
        insert pb;
     
        
        Phoenix_Bid_Process_Steps__c bStep = new Phoenix_Bid_Process_Steps__c();
        bStep.Phoenix_Is_Criteria_Step__c = false;
        bStep.Name = testData.bidsList[0].Name + '-' + 'pStep.Name';
        bStep.Phoenix_Approver__c = UserInfo.getUserId();
        bStep.Phoenix_Bid__c = testData.bidsList[0].Id;
        // bStep.Phoenix_Process_Step__c = pStep.Id;
        bStep.Phoenix_Status__c = 'In Process';
        bStep.Phoenix_Approver_Team__c = 'Marketing';
        //stepNo : Ask and increment as per requirements
        bStep.Phoenix_Sub_Step__c = 1;
        insert bStep;
        Phoenix_Bid_Process_Steps__c bStep1 = new Phoenix_Bid_Process_Steps__c();
        bStep1.Phoenix_Is_Criteria_Step__c = true;
        bStep1.Name = testData.bidsList[0].Name + '-' + 'pStep.Name';
        bStep1.Phoenix_Approver__c = UserInfo.getUserId();
        bStep1.Phoenix_Bid__c = testData.bidsList[0].Id;
        // bStep.Phoenix_Process_Step__c = pStep.Id;
        bStep1.Phoenix_Status__c = 'In Process';
        bStep1.Phoenix_Approver_Team__c = 'Marketing';
        //stepNo : Ask and increment as per requirements
        bStep1.Phoenix_Sub_Step__c = 1;
        insert bStep1;
        
       // Phoenix_FinanceApprovalGrid.updateNextProcessSteps(pb.id);{
            
                        
        Phoenix_Approval_Grid__c approvalGrid = new Phoenix_Approval_Grid__c();
        approvalGrid.Name = 'test';
        approvalGrid.Phoenix_Bid__c = pb.id;
        Phoenix_Approval_Grid__c approvalGrid1 = new Phoenix_Approval_Grid__c();
        approvalGrid1.Name = 'test1';
        approvalGrid1.Phoenix_Bid__c = pb.id;
        insert approvalGrid;
        insert approvalGrid1;
           Phoenix_Bid_Line_Item__c bl = new Phoenix_Bid_Line_Item__c();
        bl.Phoenix_Bid__c = pb.id;
        bl.Phoenix_Approval_Grid__c=approvalGrid.id;
        bl.Phoenix_Final_Status__c='Approved';
        
        insert bl;
        string s=string.valueof(bl.Phoenix_Approval_Grid__c);
        approvalmap.put(s,'Approved');
        list < Phoenix_Approval_Grid__c > test = new list < Phoenix_Approval_Grid__c > ();
      
      
        
       //Phoenix_FinanceApprovalGrid.updateNextProcessSteps(testData.bidsList[0].Id,new List<Phoenix_Bid_Process_Steps__c>{bStep});
       Phoenix_FinanceApprovalGrid.viewApprovalGrid(pb.id);
        Phoenix_FinanceApprovalGrid.updateLineItems(pb.Id, approvalMap, commentsMap, approvalMap, commentsMap, approvalMap, commentsMap, SRXmap, RXmap, OTCmap);
         }
   static testmethod void test2() {
        Account testAccount = new Account(Name = 'Test Account');
        testAccount.Phoenix_Contracts_Approver__c = Userinfo.getUserId();
        insert testAccount;
        Phoenix_Bid__c pb = new Phoenix_Bid__c();
        pb.Phoenix_Status__c = 'New';
        pb.Phoenix_Comments__c = 'Test Comments';
        pb.Phoenix_Customer__c = testAccount.Id;
        pb.Phoenix_Customer_Bid_Deadline_Date_Time__c = DateTime.now();
        pb.Phoenix_Customer_Bid_Deadline_Time_zone__c = 'PST';
        pb.Phoenix_Customer_Bid_Deadline_Time__c = '6 PM';
        pb.Phoenix_Bid_Deadline_Date__c = System.today();
        pb.Phoenix_Bid_Type__c = 'RFP Bids';
        pb.Phoenix_Approval_Status__c = 'Draft';
        insert pb;
        Product2 p2 = new Product2();
        p2.Family = 'Daptomycin Inj 500mg US';
        p2.Name = 'Test';
        p2.ProductCode = '300029858';
        insert p2;
        Product2 p3 = new Product2();
        p3.Family = 'Abiraterone Acetate Tab';
        p3.ProductCode = '300029858';
        p3.Name = 'Test Product';
        insert p3;
        Phoenix_Bid_Line_Item__c bl = new Phoenix_Bid_Line_Item__c();
        bl.Phoenix_Bid__c = pb.Id;
        bl.Phoenix_Current_Direct_Price__c = 10;
        bl.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        bl.Phoenix_Product__c = p2.Id;
        bl.Phoenix_SCM_Approval_Y_N__c = 'Y- Only Current Monthly Demand Approved';
        bl.Phoenix_Marketing_Final_Approval__c = true;
        insert bl;
        Phoenix_Bid_Line_Item__c bl1 = new Phoenix_Bid_Line_Item__c();
        bl1.Phoenix_Bid__c = pb.Id;
        bl1.Phoenix_Current_Direct_Price__c = 10;
        bl1.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        bl1.Phoenix_Product__c = p3.Id;
        bl1.Phoenix_SCM_Approval_Y_N__c = 'Y- Only Current Monthly Demand Approved';
        bl1.Phoenix_Marketing_Final_Approval__c = true;
        insert bl1;
        Map < String, Map < String, String >> financeApprovalMap = new Map < String, Map < String, String >> ();
        Map < String, Map < String, String >> financeCommentMap = new Map < String, Map < String, String >> ();
        Map < String, String > fieldsMap = new Map < String, String > ();
        Map < String, String > fieldsMap1 = new Map < String, String > ();
        fieldsMap.put('SCM Comments', 'test');
        fieldsMap1.put('SCM Rejection Reason', 'test');
        financeApprovalMap.put(bl.Id, fieldsMap);
        financeCommentMap.put(bl1.Id, fieldsMap1);
        
        Phoenix_FinanceApprovalGridView.getScmData(pb.id);
        Phoenix_FinanceApprovalGridView.updateLineItems(pb.id, financeApprovalMap, null, null, financeApprovalMap, financeCommentMap, null, null, bl1.Phoenix_SCM_Approval_Y_N__c, true);
        Phoenix_TestDataCreator testData = new Phoenix_TestDataCreator();
        Phoenix_SubmitBidForApprovalCtrl.BidWrapper wrap = new Phoenix_SubmitBidForApprovalCtrl.BidWrapper();
        wrap.bid = pb;
        testData.generateApprovalMatrix();
        Phoenix_Approval_Grid__c approvalGrid = new Phoenix_Approval_Grid__c();
        approvalGrid.Name = 'test';
        approvalGrid.Phoenix_Bid__c = pb.id;
        Phoenix_Approval_Grid__c approvalGrid1 = new Phoenix_Approval_Grid__c();
        approvalGrid1.Name = 'test1';
        approvalGrid1.Phoenix_Bid__c = pb.id;
        insert approvalGrid;
        insert approvalGrid1;
       list<Phoenix_Bid_Process_Steps__c> bpslist = new list<Phoenix_Bid_Process_Steps__c>();
       
       Phoenix_Bid_Process_Steps__c bps = new Phoenix_Bid_Process_Steps__c();
       bps.Phoenix_Bid__c =pb.id;
       bps.Phoenix_Status__c='In Process';
       bpslist.add(bps);
       insert bpslist;
       
       
        list < Phoenix_Approval_Grid__c > test = new list < Phoenix_Approval_Grid__c > ();
        Phoenix_FinanceApprovalGrid.makeApprovals(pb.id, new list < Phoenix_Approval_Grid__c > {
            approvalGrid,
                approvalGrid1
                }, true, true, true, true, true, true);
        
        System.runAs(testData.users[0]) {
            //  Phoenix_SubmitBidForApprovalCtrl.getTemplateBody('test',wrap.bid.id);
            Phoenix_SubmitBidForApprovalCtrl.submitBid(wrap);
            
            Phoenix_FinanceApprovalGridView.makeApprovals(wrap.bid.id);
        }
       Map < Integer, List < Phoenix_Bid_Process_Steps__c >> stepmap = new Map < Integer, List < Phoenix_Bid_Process_Steps__c >>();
       stepmap.put(4,bpslist);
       Phoenix_FinanceApprovalGrid.moveTonextStep(pb.id, 2, stepMap, true);
       Phoenix_FinanceApprovalGrid.moveTonextStep(pb.id, 1, stepMap, false);
       
        
    }
    static testmethod void test3() 
    {
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        Phoenix_Bid__c pb = new Phoenix_Bid__c();
        pb.Phoenix_Status__c = 'New';
        pb.Phoenix_Comments__c = 'Test Comments';
        pb.Phoenix_Customer__c = testAccount.Id;
        //	pb.Phoenix_Customer_Bid_Deadline_Date_Time__c = DateTime.now();
        pb.Phoenix_Customer_Bid_Deadline_Time_zone__c = 'PST';
        pb.Phoenix_Customer_Bid_Deadline_Time__c = '6 PM';
        pb.Phoenix_Customer_Type__c = 'Direct and Indirect';
        pb.Phoenix_Bid_Deadline_Date__c = System.today();
        insert pb;
        
        Phoenix_Contract__c Cntrct = new Phoenix_Contract__c();
        Cntrct.name = 'taest cntrct';
        Cntrct.Phoenix_Contract_Number__c = '223';
        insert Cntrct;
        
        
        Product2 prod1 = new Product2(Name = 'Test Product', Family = 'Test Family', IsActive = TRUE, ProductCode = '324',Phoenix_Product_Director__c = UserInfo.getUserId() ,Phoenix_Marketing_Lead__c = UserInfo.getUserId());
        insert prod1;
        Phoenix_Bid_Line_Item__c bl = new Phoenix_Bid_Line_Item__c();
        bl.Phoenix_Bid__c = pb.Id;
        bl.Phoenix_Current_Direct_Price__c = 10;
        bl.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        bl.Phoenix_Product__c = prod1.id;
        bl.Phoenix_Final_Status__c = 'Not Approved';
        insert bl;
        
        Phoenix_Approval_Grid__c approvalGrid = new Phoenix_Approval_Grid__c();
        approvalGrid.Name = 'test';
        approvalGrid.Phoenix_Bid__c = pb.id;
        approvalGrid.Phoenix_Approval__c = 'Not Approved';
        approvalGrid.Phoenix_Sr_Director_VP__c = 'Not Approved';
        approvalGrid.Phoenix_Marketing_Lead_SRx__c = 'Not Approved';
        approvalGrid.Phoenix_Marketing_Lead_Rx__c = 'Not Approved';
        approvalGrid.Phoenix_Marketing_Lead_OTC__c = 'Not Approved';
        insert approvalGrid;
        /* Phoenix_Approval_Grid__c approvalGrid1 = new Phoenix_Approval_Grid__c();
approvalGrid1.Name = 'test1';
approvalGrid1.Phoenix_Bid__c = pb.id;
insert approvalGrid1;
*/
        
        
        
        Phoenix_Approval_Matrix__c am = new Phoenix_Approval_Matrix__c();
        am.Name = 'test';
        insert am;
        Phoenix_Approval_Process_Step__c ap = new Phoenix_Approval_Process_Step__c();
        ap.Phoenix_Approval_Matrix__c = am.id;
        ap.Phoenix_Order__c = 1;
        insert ap;
        
        Phoenix_Bid_Process_Steps__c bisp = new Phoenix_Bid_Process_Steps__c();
        bisp.Name = 'test';
        bisp.Phoenix_Bid__c = pb.Id;
        bisp.Phoenix_Approver__c = Userinfo.getUserId();
        bisp.Phoenix_Approver_Team__c = 'Contracts';
        bisp.Phoenix_Approver_Team_Members__c = 'approver team';
        bisp.Phoenix_Process_Step__c = ap.id;
        bisp.Phoenix_Is_Criteria_Step__c = true;
        bisp.Phoenix_Status__c = 'In Process';
        insert bisp;
        boolean A = true;
        user usr = [select id,name from user where id =: userinfo.getUserId()];
        Phoenix_FinanceApprovalGrid.makeApprovals(pb.id, new list < Phoenix_Approval_Grid__c > {
            approvalGrid
                
                }, true, true, true, true, true, true);
        Phoenix_FinanceApprovalGrid.updateNextProcessSteps(pb.id, new list < Phoenix_Bid_Process_Steps__c > {
           bisp
                }, 1, new list < Phoenix_Bid_Line_Item__c > {
                    bl
                        },A,'Marketing Head Rejected');
        Phoenix_FinanceApprovalGrid.makeApprovalsFromEmail(pb.id, new list < Phoenix_Approval_Grid__c > {
            approvalGrid
                
                }, true, true, true, true, true, true,usr);
    }
    
}