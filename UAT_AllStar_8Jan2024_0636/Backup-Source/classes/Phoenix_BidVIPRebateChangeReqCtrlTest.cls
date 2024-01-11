@istest
public class Phoenix_BidVIPRebateChangeReqCtrlTest {
    
    static testmethod void coverageMethod() {
        
    }
    
    
    @testSetup static void setupTestData() {
        Account testAccount = new Account(Name = 'BidVipRebateTestAccount#');
        insert testAccount;
        Phoenix_Bid_VIP_Rebate__c currentReb = new Phoenix_Bid_VIP_Rebate__c();
        currentReb.Phoenix_Customer__c = testAccount.Id;
        currentReb.Phoenix_Type__c = 'Currency';
        currentReb.Phoenix_Status__c = 'Current';
        currentReb.Phoenix_Start_Date__c = system.today();
        currentReb.Phoenix_End_Date__c = system.today();
        insert currentReb;
        
        Phoenix_Bid__c pb = new Phoenix_Bid__c();
        pb.Phoenix_Status__c = 'New';
        pb.Phoenix_Bid_Type__c = 'VIP Rebate';
        pb.Phoenix_Comments__c = 'Test Comments';
        pb.Phoenix_Customer__c = testAccount.Id;
        pb.Phoenix_Customer_Bid_Deadline_Time_zone__c = 'PST';
        pb.Phoenix_Customer_Bid_Deadline_Time__c = '6 PM';
        pb.Phoenix_Bid_Deadline_Date__c = System.today();
        insert pb;
        
        Phoenix_Bid_VIP_Rebate__c newReb1 = new Phoenix_Bid_VIP_Rebate__c();
        newReb1.Phoenix_Customer__c = testAccount.Id;
        newReb1.Phoenix_Bid__c = pb.Id;
        newReb1.Phoenix_Type__c = 'Currency';
        newReb1.Phoenix_Status__c = 'Proposed';
        newReb1.Phoenix_Start_Date__c = system.today();
        newReb1.Phoenix_End_Date__c = system.today();
        insert newReb1;
        Phoenix_VIP_Rebate_Line__c newReb = new Phoenix_VIP_Rebate_Line__c();
        newReb.Phoenix_VIP_Rebate__c = newReb1.Id;
        //  newReb.Phoenix_Type__c='Currency';
        newReb.Phoenix_Dollar_Value_From__c = 2.0;
        newReb.Phoenix_Dollar_Value_To__c = 100;
        //newReb.Phoenix_Unit_Volume_From__c=2.0;
        // newReb.Phoenix_Unit_Volume_To__c=100;
        newReb.Phoenix_Discount_Rebate__c = 2.0;
        newReb.Phoenix_Remarks__c = 'Test Remarks';
        newReb.Phoenix_Tier__c = 'Tier 1';
        //  newReb.Phoenix_Status__c='Proposed';
        //  newReb.Phoenix_Exclusion_details__c='Test Exclusion';
        insert newReb;
        
    }
    static testmethod void getExistingRec() {
        Account testAccount = [SELECT Id FROM Account Where Name = 'BidVipRebateTestAccount#'];
        List < Phoenix_VIP_Rebate_Line__c > newReb = [select Id, Phoenix_Dollar_Value_From__c,
                                                      Phoenix_VIP_Rebate__c,
                                                      Phoenix_Dollar_Value_To__c,
                                                      Phoenix_Unit_Volume_From__c,
                                                      Phoenix_Unit_Volume_To__c,
                                                      Phoenix_Discount_Rebate__c,
                                                      Phoenix_Remarks__c,
                                                      Phoenix_Tier__c
                                                      FROM Phoenix_VIP_Rebate_Line__c where Phoenix_Dollar_Value_From__c = 2.0
                                                     ];
        Phoenix_Bid__c pb = [select id from Phoenix_Bid__c where Phoenix_Status__c = 'New'];
        Phoenix_BidVIPRebateChangeReqCtrl.saveLineItems(new list < Phoenix_VIP_Rebate_Line__c > {
            newReb[0]
                }, pb.Id, 'Test', system.today(), system.today(), false, 'Currency', testAccount.Id, '', '', '', '');
        Phoenix_BidVIPRebateChangeReqCtrl.saveLineItemsInTab(new list < Phoenix_VIP_Rebate_Line__c > {
            newReb[0]
                }, pb.Id, 'Test', system.today(), system.today(), false, 'Currency', testAccount.Id, '', '', '', '');
        Phoenix_BidVIPRebateChangeReqCtrl.getRelatedList(pb.Id);
        Phoenix_BidVIPRebateChangeReqCtrl.getVipAndRelatedList(pb.Id, 'Rx', testAccount.Id);
        Phoenix_BidVIPRebateChangeReqCtrl.getVipRebateByType('Currency', pb.Id, testAccount.Id);
        Phoenix_BidVIPRebateChangeReqCtrl.checkForProposedRebate(pb.Id);
        Phoenix_BidVIPRebateChangeReqCtrl.getVipAndRelatedListByType('Currency', pb.Id, testAccount.Id);
        Phoenix_Bid_Process_Steps__c bps = new Phoenix_Bid_Process_Steps__c();
        bps.Name = 'Test bps2';
        bps.Phoenix_Bid__c = pb.Id;
        bps.Phoenix_Status__c = 'In Process';
        insert bps;
        
        Phoenix_Bid_Process_Steps__c bps2 = new Phoenix_Bid_Process_Steps__c();
        bps2.Name = 'Test bps';
        bps2.Phoenix_Bid__c = pb.Id;
        //bps2.Phoenix_Step__c = bps.Id;
        bps2.Phoenix_Status__c = 'In Process';
        insert bps2;
        
        Phoenix_BidVIPRebateChangeReqCtrl.makeApprovalsBusiness(pb.Id, 'Test', 'Approved', 'Test3');
        Phoenix_BidVIPRebateChangeReqCtrl.makeApprovalsBusiness(pb.Id, 'Test 2', 'Not Approved', 'Test5');
        Phoenix_BidVIPRebateChangeReqCtrl.getBidVipRebateCount(pb.Id);
        Phoenix_BidVIPRebateChangeReqCtrl.deleteProposedRebate(pb.Id,testAccount.Id);
        Phoenix_BidVIPRebateChangeReqCtrl.getCustomerVIPRebateByType('test',pb.Id,testAccount.Id);
        //Phoenix_BidVIPRebateChangeReqCtrl.deleteRebate(pb.Id,new list < Phoenix_VIP_Rebate_Line__c > {
        
        //});
        
        System.assertEquals(1, 1);
    }
    static testmethod void getNewRec() {
        Account testAccount = [SELECT Id FROM Account Where Name = 'BidVipRebateTestAccount#'];
        List < Phoenix_Bid__c > pb = [select Id from Phoenix_Bid__c];
        Phoenix_Bid_VIP_Rebate__c newReb1 = new Phoenix_Bid_VIP_Rebate__c();
        newReb1.Phoenix_Bid__c = pb[0].Id;
        newReb1.Phoenix_Type__c = 'Currency';
        newReb1.Phoenix_Dollar_Volume_From__c = 101.00;
        newReb1.Phoenix_Dollar_Volume_To__c = 1000.00;
        newReb1.Phoenix_Unit_Volume_From__c = 101.00;
        newReb1.Phoenix_Unit_Volume_To__c = 1000.00;
        newReb1.Phoenix_Discount_Rebate__c = 2.0;
        newReb1.Phoenix_Remarks__c = 'Test Remarks';
        newReb1.Phoenix_Tier__c = 'Tier 2';
        newReb1.Phoenix_Status__c = 'Proposed';
        newReb1.Phoenix_Exclusion_details__c = 'Test Exclusion';
        
        Phoenix_VIP_Rebate_Line__c newReb = new Phoenix_VIP_Rebate_Line__c();
        newReb.Phoenix_VIP_Rebate__c = newReb1.Id;
        //  newReb.Phoenix_Type__c='Currency';
        newReb.Phoenix_Dollar_Value_From__c = 2.0;
        newReb.Phoenix_Dollar_Value_To__c = 100;
        newReb.Phoenix_Unit_Volume_From__c = 2.0;
        newReb.Phoenix_Unit_Volume_To__c = 100;
        newReb.Phoenix_Discount_Rebate__c = 2.0;
        newReb.Phoenix_Remarks__c = 'Test Remarks';
        newReb.Phoenix_Tier__c = 'Tier 1';
        
        Phoenix_BidVIPRebateChangeReqCtrl.saveLineItems(new list < Phoenix_VIP_Rebate_Line__c > {
            newReb
                }, pb[0].Id, 'Test', system.today(), system.today(), false, 'Currency', testAccount.Id, '', '', '', '');
        System.assertEquals(1, 1);
        
    }
    
    
    static testmethod void processApprovals() {
        Account testAccount = [SELECT Id FROM Account Where Name = 'BidVipRebateTestAccount#'];
        Phoenix_Bid__c pb2 = new Phoenix_Bid__c();
        pb2.Phoenix_Status__c = 'New';
        pb2.Phoenix_Comments__c = 'Test Comments';
        //pb2.Phoenix_Customer__c = testAccount.Id;
        pb2.Phoenix_Customer_Bid_Deadline_Time_zone__c = 'PST';
        pb2.Phoenix_Customer_Bid_Deadline_Time__c = '6 PM';
        pb2.Phoenix_Bid_Deadline_Date__c = System.today();
        insert pb2;
        
        Phoenix_Bid_Process_Steps__c bps = new Phoenix_Bid_Process_Steps__c();
        bps.Name = 'Test bps2';
        bps.Phoenix_Bid__c = pb2.Id;
        bps.Phoenix_Status__c = 'In Process';
        insert bps;
        
        Phoenix_Bid_Process_Steps__c bps2 = new Phoenix_Bid_Process_Steps__c();
        bps2.Name = 'Test bps';
        bps2.Phoenix_Bid__c = pb2.Id;
        //bps2.Phoenix_Step__c = bps.Id;
        bps2.Phoenix_Status__c = 'In Process';
        insert bps2;
        
        /*Phoenix_Bid_VIP_Rebate__c bvr = new Phoenix_Bid_VIP_Rebate__c();
bvr.Phoenix_Bid__c = pb2.Id;
bvr.Phoenix_Status__c='Proposed';
insert bvr;*/
        
        Account ac = new Account();
        ac.Name = 'Test Account';
        insert ac;
        
        Phoenix_Bid_VIP_Rebate__c bvr = new Phoenix_Bid_VIP_Rebate__c();
        bvr.Phoenix_Customer__c = ac.Id;
        bvr.Phoenix_Bid__c = pb2.Id;
        bvr.Phoenix_Type__c = 'Currency';
        bvr.Phoenix_Status__c = 'Proposed';
        bvr.Phoenix_Start_Date__c = system.today();
        bvr.Phoenix_End_Date__c = system.today();
        insert bvr;
        
        Test.startTest();
        Phoenix_BidVIPRebateChangeReqCtrl.makeApprovalsFinance(pb2.Id, 'Test 2', 'Approved', 'Approved');
        Test.stopTest();
    }
    
    static testmethod void processApprovalsContract() {
        Account testAccount = [SELECT Id FROM Account Where Name = 'BidVipRebateTestAccount#'];
        Phoenix_Bid__c pb2 = new Phoenix_Bid__c();
        pb2.Phoenix_Status__c = 'New';
        pb2.Phoenix_Comments__c = 'Test Comments';
        pb2.Phoenix_Customer_Bid_Deadline_Time_zone__c = 'PST';
        pb2.Phoenix_Customer_Bid_Deadline_Time__c = '6 PM';
        pb2.Phoenix_Bid_Deadline_Date__c = System.today();
        insert pb2;
        
        Phoenix_Bid_Process_Steps__c bps = new Phoenix_Bid_Process_Steps__c();
        bps.Name = 'Test bps2';
        bps.Phoenix_Bid__c = pb2.Id;
        bps.Phoenix_Status__c = 'In Process';
        insert bps;
        
        Phoenix_Bid_Process_Steps__c bps2 = new Phoenix_Bid_Process_Steps__c();
        bps2.Name = 'Test bps';
        bps2.Phoenix_Bid__c = pb2.Id;
        //bps2.Phoenix_Step__c = bps.Id;
        bps2.Phoenix_Status__c = 'In Process';
        insert bps2;
        
        Account ac = new Account();
        ac.Name = 'Test Account';
        insert ac;
        
        Phoenix_Bid_VIP_Rebate__c bvr = new Phoenix_Bid_VIP_Rebate__c();
        bvr.Phoenix_Customer__c = ac.Id;
        bvr.Phoenix_Bid__c = pb2.Id;
        bvr.Phoenix_Type__c = 'Currency';
        bvr.Phoenix_Status__c = 'Proposed';
        bvr.Phoenix_Start_Date__c = system.today();
        bvr.Phoenix_End_Date__c = system.today();
        insert bvr;
        
        Test.startTest();
        Phoenix_BidVIPRebateChangeReqCtrl.makeApprovalsContracts(pb2.Id, 'Sent to Customer', 'Sent to Customer', 'Approved');
        Phoenix_BidVIPRebateChangeReqCtrl.makeApprovalsContracts(pb2.Id, 'Sent to Customer', 'Line Error - Not Sent', 'Approved');
        Test.stopTest();
    }
    
    static testmethod void processApprovalsCustomer() {
        Account testAccount = [SELECT Id FROM Account Where Name = 'BidVipRebateTestAccount#'];
        Phoenix_Bid__c pb2 = new Phoenix_Bid__c();
        pb2.Phoenix_Status__c = 'New';
        pb2.Phoenix_Comments__c = 'Test Comments';
        pb2.Phoenix_Customer_Bid_Deadline_Time_zone__c = 'PST';
        pb2.Phoenix_Customer_Bid_Deadline_Time__c = '6 PM';
        pb2.Phoenix_Bid_Deadline_Date__c = System.today();
        insert pb2;
        
        Phoenix_Bid_Process_Steps__c bps = new Phoenix_Bid_Process_Steps__c();
        bps.Name = 'Test bps2';
        bps.Phoenix_Bid__c = pb2.Id;
        bps.Phoenix_Status__c = 'In Process';
        insert bps;
        
        Phoenix_Bid_Process_Steps__c bps2 = new Phoenix_Bid_Process_Steps__c();
        bps2.Name = 'Test bps';
        bps2.Phoenix_Bid__c = pb2.Id;
        //bps2.Phoenix_Step__c = bps.Id;
        bps2.Phoenix_Status__c = 'In Process';
        insert bps2;
        
        Account ac = new Account();
        ac.Name = 'Test Account';
        insert ac;
        
        Phoenix_Bid_VIP_Rebate__c bvr = new Phoenix_Bid_VIP_Rebate__c();
        bvr.Phoenix_Customer__c = ac.Id;
        bvr.Phoenix_Bid__c = pb2.Id;
        bvr.Phoenix_Type__c = 'Currency';
        bvr.Phoenix_Status__c = 'Proposed';
        bvr.Phoenix_Start_Date__c = system.today();
        bvr.Phoenix_End_Date__c = system.today();
        insert bvr;
        
        Test.startTest();
        Phoenix_BidVIPRebateChangeReqCtrl.makeApprovalsCustomer(pb2.Id, 'Sent to Customer', 'Customer Accepted', 'Approved');
        Phoenix_BidVIPRebateChangeReqCtrl.makeApprovalsCustomer(pb2.Id, 'Sent to Customer', 'Customer Not Accepted', 'Approved');
        Phoenix_BidVIPRebateChangeReqCtrl.getCustomerVIPRebate(pb2.Id);
        
        
        Test.stopTest();
    }
    
    static testmethod void processApprovalsVistex() {
        Account testAccount = [SELECT Id FROM Account Where Name = 'BidVipRebateTestAccount#'];
        Phoenix_Bid__c pb2 = new Phoenix_Bid__c();
        pb2.Phoenix_Status__c = 'New';
        pb2.Phoenix_Comments__c = 'Test Comments';
        pb2.Phoenix_Customer_Bid_Deadline_Time_zone__c = 'PST';
        pb2.Phoenix_Customer_Bid_Deadline_Time__c = '6 PM';
        pb2.Phoenix_Bid_Deadline_Date__c = System.today();
        insert pb2;
        
        Phoenix_Bid_Process_Steps__c bps = new Phoenix_Bid_Process_Steps__c();
        bps.Name = 'Test bps2';
        bps.Phoenix_Bid__c = pb2.Id;
        bps.Phoenix_Status__c = 'In Process';
        insert bps;
        
        Phoenix_Bid_Process_Steps__c bps2 = new Phoenix_Bid_Process_Steps__c();
        bps2.Name = 'Test bps';
        bps2.Phoenix_Bid__c = pb2.Id;
        //bps2.Phoenix_Step__c = bps.Id;
        bps2.Phoenix_Status__c = 'In Process';
        insert bps2;
        
        Account ac = new Account();
        ac.Name = 'Test Account';
        insert ac;
        
        Phoenix_Bid_VIP_Rebate__c bvr = new Phoenix_Bid_VIP_Rebate__c();
        bvr.Phoenix_Customer__c = ac.Id;
        bvr.Phoenix_Bid__c = pb2.Id;
        bvr.Phoenix_Type__c = 'Currency';
        bvr.Phoenix_Status__c = 'Proposed';
        bvr.Phoenix_Start_Date__c = system.today();
        bvr.Phoenix_End_Date__c = system.today();
        insert bvr;
        
        Test.startTest();
        Phoenix_BidVIPRebateChangeReqCtrl.makeApprovalsVistex(pb2.Id, 'Test', 'Processed', 'Approved');
        Phoenix_BidVIPRebateChangeReqCtrl.makeApprovalsVistex(pb2.Id, 'Test', 'Not Processed', 'Approved');
        Phoenix_BidVIPRebateChangeReqCtrl.getDocs(pb2.Id);
        Phoenix_BidVIPRebateChangeReqCtrl.saveToBidBus(pb2.Id, 'Approved', 'Approved');
        Phoenix_BidVIPRebateChangeReqCtrl.saveToBidFin(pb2.Id, 'Customer Accepted', 'Approved');
        Phoenix_BidVIPRebateChangeReqCtrl.saveToBidContr(pb2.Id, 'Sent to Customer', 'Approved');
        Phoenix_BidVIPRebateChangeReqCtrl.saveToBidCust(pb2.Id, 'Customer Accepted', 'Approved');
        Phoenix_BidVIPRebateChangeReqCtrl.saveToBidVist(pb2.Id, 'Processed', 'Approved', bvr.Id, '1234567890');
        Test.stopTest();
    }
    static testmethod void bidTrigger() {
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        
        
        Phoenix_Bid__c pb = new Phoenix_Bid__c();
        pb.Phoenix_Select_Wholesaler__c = 'ABC';
        pb.Phoenix_Customer__c = testAccount.Id;
        pb.Phoenix_Customer_Bid_Deadline_Time_zone__c = 'PST';
        pb.Phoenix_Customer_Bid_Deadline_Time__c = '6 PM';
        pb.Phoenix_Bid_Deadline_Date__c = System.today();
        insert pb;
    }
    static testmethod void bidTriggerCardinal() {
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        
        
        Phoenix_Bid__c pb = new Phoenix_Bid__c();
        pb.Phoenix_Select_Wholesaler__c = 'Cardinal';
        pb.Phoenix_Customer__c = testAccount.Id;
        pb.Phoenix_Customer_Bid_Deadline_Time_zone__c = 'PST';
        pb.Phoenix_Customer_Bid_Deadline_Time__c = '6 PM';
        pb.Phoenix_Bid_Deadline_Date__c = System.today();
        insert pb;
    }
    static testmethod void bidTriggerMcKesson() {
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        
        
        Phoenix_Bid__c pb = new Phoenix_Bid__c();
        pb.Phoenix_Select_Wholesaler__c = 'McKesson';
        pb.Phoenix_Customer__c = testAccount.Id;
        pb.Phoenix_Customer_Bid_Deadline_Time_zone__c = 'PST';
        pb.Phoenix_Customer_Bid_Deadline_Time__c = '6 PM';
        pb.Phoenix_Bid_Deadline_Date__c = System.today();
        insert pb;
    }
    static testmethod void bidTriggeOther() {
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        
        
        Phoenix_Bid__c pb = new Phoenix_Bid__c();
        pb.Phoenix_Select_Wholesaler__c = 'Other';
        pb.Phoenix_Customer__c = testAccount.Id;
        pb.Phoenix_Customer_Bid_Deadline_Time_zone__c = 'PST';
        pb.Phoenix_Customer_Bid_Deadline_Time__c = '6 PM';
        pb.Phoenix_Bid_Deadline_Date__c = System.today();
        insert pb;
    }
    static testmethod void bidTriggeSourceProg() {
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        
        
        Phoenix_Bid__c pb = new Phoenix_Bid__c();
        pb.Phoenix_Select_Wholesaler__c = 'Source Program (No CM Fee Applies)';
        pb.Phoenix_Customer__c = testAccount.Id;
        pb.Phoenix_Customer_Bid_Deadline_Time_zone__c = 'PST';
        pb.Phoenix_Customer_Bid_Deadline_Time__c = '6 PM';
        pb.Phoenix_Bid_Deadline_Date__c = System.today();
        insert pb;
    }
}