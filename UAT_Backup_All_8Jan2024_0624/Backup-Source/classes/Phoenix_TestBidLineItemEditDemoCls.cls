/**
 * @description       : 
 * @author            : Surender Dhruvsoft
 * @group             : 
 * @last modified on  : 25-05-2021
 * @last modified by  : Surender Dhruvsoft
 * Modifications Log 
 * Ver   Date         Author               Modification
 * 1.0   25-05-2021   Surender Dhruvsoft   Initial Version
**/
@istest
public class Phoenix_TestBidLineItemEditDemoCls {/*
    static testmethod void getItems() {
         Phoenix_Approval_Delegation_History__c deleHistory = new Phoenix_Approval_Delegation_History__c();
        deleHistory.Phoenix_Delegation_Start_Time__c =  system.now();
        deleHistory.Phoenix_Delegation_End_Time__c = datetime.newInstance(2023, 9, 15, 12, 30, 0); 
        deleHistory.Phoenix_Delegated_Approver__c=userInfo.getUserId();
    deleHistory.Phoenix_Is_Active_delegator__c = True;
        insert deleHistory;
        Account testAccount = new Account(Name = 'Test Account', Phoenix_Customer_Class_Bid_Template__c = 'Walgreens');
        insert testAccount;
        Phoenix_Bid__c pb = new Phoenix_Bid__c();
        pb.Phoenix_Status__c = 'New';
        pb.Phoenix_Bid_Type__c = 'IPA Floor Pricing Update';
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

        Product2 prod1 = new Product2(Name = 'Test Product', Family = 'Test Family', IsActive = TRUE, ProductCode = '324');
        insert prod1;
        Phoenix_Bid_Line_Item__c bl = new Phoenix_Bid_Line_Item__c();
        bl.Phoenix_Bid__c = pb.Id;
        bl.Phoenix_Current_Direct_Price__c = 10;
        bl.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        bl.Phoenix_Product__c = prod1.id;
        bl.Phoenix_Final_Status__c = 'Approved';
        bl.Phoenix_ProposedContractBidPriceMktng__c = 10;
        insert bl;
        Phoenix_NPR_Data__c nprdat = new Phoenix_NPR_Data__c();
        nprdat.Phoenix_Contract__c = Cntrct.id;
        nprdat.Phoenix_Contract_Number__c = '223';
        nprdat.Phoenix_Product__c = prod1.id;
        nprdat.Phoenix_12Months_Sales_Unit__c = 200;
        nprdat.Phoenix_Contract_Type__c = 'Direct';
        nprdat.Phoenix_Rebate_G_N_Indicator__c = '10N+ 0G';
        nprdat.Phoenix_Bonafied_G_N_Indicator__c = '5N+0G';
        insert nprdat;
        //List<Phoenix_Bid_Process_Steps__c> processList =new List<Phoenix_Bid_Process_Steps__c>();
        Phoenix_Bid_Process_Steps__c bisp = new Phoenix_Bid_Process_Steps__c();
        bisp.Name = 'Contracts Approval';
        bisp.Phoenix_Bid__c = pb.Id;
        bisp.Phoenix_Approver__c = Userinfo.getUserId();
        bisp.Phoenix_Approver_Team__c = 'Contracts';
        bisp.Phoenix_Is_Criteria_Step__c = false;
        bisp.Phoenix_Status__c = 'In Process';
        // processList.add(bisp);
        insert bisp;
        Phoenix_Bid_Process_Steps__c bisp1 = new Phoenix_Bid_Process_Steps__c();
        bisp1.Name = 'Marketing Approval';
        bisp1.Phoenix_Bid__c = pb.Id;
        bisp1.Phoenix_Approver__c = Userinfo.getUserId();
        bisp1.Phoenix_Approver_Team__c = 'Marketing';
        bisp1.Phoenix_Is_Criteria_Step__c = true;
        bisp1.Phoenix_Status__c = 'In Process';
        insert bisp1;
        // processList.add(bisp1);
        // if(!processList.isEmpty()){
        //         insert processList;
        // }
        Phoenix_BidLineItemEditDemoCls.getExistingDocs(pb.id);
        Phoenix_BidLineItemEditDemoCls.deleteAttachmentList(new list < id > {
            bl.id
        });
        //Phoenix_BidLineItemEditDemoCls.generateDocument(pb.id);
        Phoenix_BidLineItemEditDemoCls.getRelatedList(pb.id);
        Phoenix_BidLineItemEditDemoCls.getExistingDocs(pb.id);
        Phoenix_BidLineItemEditDemoCls.getAllTotals(pb.id);
        Phoenix_BidLineItemEditDemoCls.getupdatedforExport(pb.id);
        Phoenix_BidLineItemEditDemoCls.getContracts(testAccount.Id, 'a');
        Phoenix_BidLineItemEditDemoCls.getNPRData(new list < string > {
            Cntrct.Phoenix_Contract_Number__c
        }, pb.Id, 'Direct');
        Phoenix_BidLineItemEditDemoCls.getNPRData(new list < string > {
            Cntrct.Phoenix_Contract_Number__c
        }, pb.Id, 'Indirect');
        Phoenix_BidLineItemEditDemoCls.updateRelatedList(new list < Phoenix_Bid_Line_Item__c > {
            bl
        });
        Phoenix_BidLineItemEditDemoCls.findByProductFamily(new list < string > {
            'lev'
        }, pb.Id, new list < string > {
            'Rx'
        }, new list < string > {
            ''
        });
        Phoenix_BidLineItemEditDemoCls.saveLineItems(new list < Phoenix_Bid_Line_Item__c > {
            bl
        }, pb.id, 'Gross', 'Gross', '', true, true, true, 'Approved', true,'');
        Phoenix_BidLineItemEditDemoCls.getCalcs(bl, bl.id, 'No Change', 'rebateType');
        Phoenix_BidLineItemEditDemoCls.submitToProceddStep(pb.id, false,false,'');
        Phoenix_BidLineItemEditDemoCls.makeApprovals(pb.id, new List < Phoenix_Bid_Line_Item__c > {
            bl
        }, true);
        // 
        Phoenix_Bid_Line_Item__c bl1 = new Phoenix_Bid_Line_Item__c();
        bl1.Phoenix_Bid__c = pb.Id;
        bl1.Phoenix_Current_Direct_Price__c = 10;
        bl1.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        bl1.Phoenix_Product__c = prod1.id;
        bl1.Phoenix_SCM_Final_Approval__c = true;
        bl1.Phoenix_Final_Status__c = 'Approved';
        bl1.Phoenix_Proposed_Indirect_Selling_Unit__c = 2;
        bl1.Phoenix_SCM_Approval_Y_N__c = 'Y- Only Current Monthly Demand Approved';
        insert bl1;
        Phoenix_Bid_Line_Item__c bl2 = new Phoenix_Bid_Line_Item__c();
        bl2.Phoenix_Bid__c = pb.Id;
        bl2.Phoenix_Current_Direct_Price__c = 10;
        bl2.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        bl2.Phoenix_Product__c = prod1.id;
        bl2.Phoenix_Final_Status__c = 'Approved';
        bl2.Phoenix_Proposed_Indirect_Selling_Unit__c = 2;
        bl2.Phoenix_Proposed_Direct_Selling_Unit__c = 2;
        bl2.Phoenix_SCM_Approval_Y_N__c = 'Y- Current + Inc Demand Approved';
        insert bl2;
        Phoenix_Bid__c pb1 = new Phoenix_Bid__c();
        pb1.Phoenix_Status__c = 'New';
        pb1.Phoenix_Comments__c = 'Test Comments';
        pb1.Phoenix_Customer__c = testAccount.Id;
        //	pb.Phoenix_Customer_Bid_Deadline_Date_Time__c = DateTime.now();
        pb1.Phoenix_Customer_Bid_Deadline_Time_zone__c = 'PST';
        pb1.Phoenix_Customer_Bid_Deadline_Time__c = '6 PM';
        pb1.Phoenix_Customer_Type__c = 'Walgreens';
        pb1.Phoenix_Bid_Deadline_Date__c = System.today();
        insert pb1;
        Phoenix_Bid_Line_Item__c bl3 = new Phoenix_Bid_Line_Item__c();
        bl3.Phoenix_Bid__c = pb1.Id;
        bl3.Phoenix_Current_Direct_Price__c = 10;
        bl3.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        bl3.Phoenix_Product__c = prod1.id;
        bl3.Phoenix_Final_Status__c = 'Approved';
        bl3.Phoenix_Proposed_Indirect_Selling_Unit__c = 2;
        bl3.Phoenix_Proposed_Direct_Selling_Unit__c = 2;
        bl3.Phoenix_SCM_Approval_Y_N__c = 'Y- Current + Inc Demand Approved';
        insert bl3;
        Phoenix_IPARejectedLineItemsCls.getRelatedList(pb.id);
        Phoenix_BidLineItemEditDemoCls.updateNextProcessSteps(pb.id, 'test', new list < Phoenix_Bid_Process_Steps__c > {
            bisp,
            bisp1
        }, true, true);
        Phoenix_BidLineItemEditDemoCls.updateNextProcessSteps(pb.id, 'test', new list < Phoenix_Bid_Process_Steps__c > {
            bisp,
            bisp1
        }, false, false);
        Phoenix_BidLineItemEditDemoCls.updateNextContractProcessSteps(pb.id, 'test', new list < Phoenix_Bid_Process_Steps__c > {
            bisp
        });


        Phoenix_IPARejectedLineItemsCls.saveLineItems(new list < Phoenix_Bid_Line_Item__c > {
            bl3
        });
        Phoenix_BidLineItemEditDemoCls.deleteLineItems(bl.id);
        Phoenix_IPARejectedLineItemsCls.deleteLineItems(bl3.id);
        // Phoenix_BidLineItemEditDemoCls.getSubmitBidInfo(pb.id);
        // Phoenix_BidLineItemEditDemoCls.makeApprovalsContracts(pb.id,new list<Phoenix_Bid_Line_Item__c>{bl},false,false);


        //Phoenix_BidLineItemEditDemoCls.updateNextContractProcessSteps(pb.id,'test',new list<Phoenix_Bid_Process_Steps__c>{bisp});
    }
    @isTest static void SubmitBidforApproval() {
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
        pb.Phoenix_Customer_Type__c = 'Direct and Indirect';
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
        bl.Phoenix_Product_Code1__c = '300029858';
        bl.Phoenix_Product_Family1__c = 'Daptomycin Inj 500mg US';
        bl.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        bl.Phoenix_Product__c = p2.Id;
        bl.Phoenix_Final_Status__c = 'Approved';
        bl.Phoenix_SCM_Approval_Y_N__c = 'Y- Only Current Monthly Demand Approved';
        bl.Phoenix_Marketing_Final_Approval__c = true;
        insert bl;
        Phoenix_Bid_Line_Item__c bl1 = new Phoenix_Bid_Line_Item__c();
        bl1.Phoenix_Bid__c = pb.Id;
        bl1.Phoenix_Final_Status__c = 'Approved';
        bl1.Phoenix_Current_Direct_Price__c = 10;
        bl1.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        bl1.Phoenix_Product__c = p3.Id;
        bl1.Phoenix_SCM_Approval_Y_N__c = 'Y- Only Current Monthly Demand Approved';
        bl1.Phoenix_Marketing_Final_Approval__c = true;
        insert bl1;

        Phoenix_TestDataCreator testData = new Phoenix_TestDataCreator();
        Phoenix_SubmitBidForApprovalCtrl.BidWrapper wrap = new Phoenix_SubmitBidForApprovalCtrl.BidWrapper();
        wrap.bid = pb;
        testData.generateApprovalMatrix();
        Phoenix_SubmitBidForApprovalCtrl.getBidInfo(wrap.bid.Id);
        Phoenix_SubmitBidForApprovalCtrl.calculateFinanceGrid(wrap.bid.Id);
        Phoenix_BidLineItemEditDemoCls.getSubmitBidInfo(wrap.bid.Id);
        Phoenix_BidLineItemEditDemoCls.makeApprovalsContracts(wrap.bid.Id, new list < Phoenix_Bid_Line_Item__c > {
            bl1
        }, false, false);
        Phoenix_SubmitBidForApprovalCtrl.submitBid(wrap);
    }
      static testmethod void getPositions() {
           Phoenix_Approval_Delegation_History__c deleHistory = new Phoenix_Approval_Delegation_History__c();
        deleHistory.Phoenix_Delegation_Start_Time__c =  system.now();
        deleHistory.Phoenix_Delegation_End_Time__c = datetime.newInstance(2023, 9, 15, 12, 30, 0); 
        deleHistory.Phoenix_Delegated_Approver__c=userInfo.getUserId();
    deleHistory.Phoenix_Is_Active_delegator__c = True;
        insert deleHistory;
        Account testAccount = new Account(Name = 'Test Account', Phoenix_Customer_Class_Bid_Template__c = 'Walgreens');
        insert testAccount;
        Phoenix_Bid__c pb = new Phoenix_Bid__c();
        pb.Phoenix_Status__c = 'New';
        pb.Phoenix_Bid_Type__c = 'IPA Floor Pricing Update';
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

        Product2 prod1 = new Product2(Name = 'Test Product', Family = 'Test Family', IsActive = TRUE, ProductCode = '324');
        insert prod1;
        Phoenix_Bid_Line_Item__c bl = new Phoenix_Bid_Line_Item__c();
        bl.Phoenix_Bid__c = pb.Id;
        bl.Phoenix_Current_Direct_Price__c = 10;
        bl.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        bl.Phoenix_Product__c = prod1.id;
        bl.Phoenix_Final_Status__c = 'Approved';
        bl.Phoenix_ProposedContractBidPriceMktng__c = 10;
        insert bl;
        Phoenix_NPR_Data__c nprdat = new Phoenix_NPR_Data__c();
        nprdat.Phoenix_Contract__c = Cntrct.id;
        nprdat.Phoenix_Contract_Number__c = '223';
        nprdat.Phoenix_Product__c = prod1.id;
        nprdat.Phoenix_12Months_Sales_Unit__c = 200;
        nprdat.Phoenix_Contract_Type__c = 'Direct';
        nprdat.Phoenix_Rebate_G_N_Indicator__c = '10N+ 0G';
        nprdat.Phoenix_Bonafied_G_N_Indicator__c = '5N+0G';
        insert nprdat;
        //List<Phoenix_Bid_Process_Steps__c> processList =new List<Phoenix_Bid_Process_Steps__c>();
        Phoenix_Bid_Process_Steps__c bisp = new Phoenix_Bid_Process_Steps__c();
        bisp.Name = 'Contracts Approval';
        bisp.Phoenix_Bid__c = pb.Id;
        bisp.Phoenix_Approver__c = Userinfo.getUserId();
        bisp.Phoenix_Approver_Team__c = 'Contracts';
        bisp.Phoenix_Is_Criteria_Step__c = false;
        bisp.Phoenix_Status__c = 'In Process';
        // processList.add(bisp);
        insert bisp;
        Phoenix_Bid_Process_Steps__c bisp1 = new Phoenix_Bid_Process_Steps__c();
        bisp1.Name = 'Marketing Approval';
        bisp1.Phoenix_Bid__c = pb.Id;
        bisp1.Phoenix_Approver__c = Userinfo.getUserId();
        bisp1.Phoenix_Approver_Team__c = 'Marketing';
        bisp1.Phoenix_Is_Criteria_Step__c = true;
        bisp1.Phoenix_Status__c = 'In Process';
        insert bisp1;
        // processList.add(bisp1);
        // if(!processList.isEmpty()){
        //         insert processList;
        // }
       
        Phoenix_BidLineItemEditDemoCls.getExistingDocs(pb.id);
        Phoenix_BidLineItemEditDemoCls.deleteAttachmentList(new list < id > {
            bl.id
        });
        //Phoenix_BidLineItemEditDemoCls.generateDocument(pb.id);
        Phoenix_BidLineItemEditDemoCls.getRelatedList(pb.id);
        Phoenix_BidLineItemEditDemoCls.getExistingDocs(pb.id);
        Phoenix_BidLineItemEditDemoCls.getAllTotals(pb.id);
        Phoenix_BidLineItemEditDemoCls.getupdatedforExport(pb.id);
        Phoenix_BidLineItemEditDemoCls.getContracts(testAccount.Id, 'a');
        Phoenix_BidLineItemEditDemoCls.getNPRData(new list < string > {
            Cntrct.Phoenix_Contract_Number__c
        }, pb.Id, 'Direct');
        Phoenix_BidLineItemEditDemoCls.getNPRData(new list < string > {
            Cntrct.Phoenix_Contract_Number__c
        }, pb.Id, 'Indirect');
        Phoenix_BidLineItemEditDemoCls.updateRelatedList(new list < Phoenix_Bid_Line_Item__c > {
            bl
        });
        Phoenix_BidLineItemEditDemoCls.findByProductFamily(new list < string > {
            'lev'
        }, pb.Id, new list < string > {
            'Rx'
        }, new list < string > {
            ''
        });
        Phoenix_BidLineItemEditDemoCls.saveLineItems(new list < Phoenix_Bid_Line_Item__c > {
            bl
        }, pb.id, 'Gross', 'Gross', '', true, true, true, 'Approved', true,'');
        Phoenix_BidLineItemEditDemoCls.getCalcs(bl, bl.id, 'No Change', 'rebateType');
        Phoenix_BidLineItemEditDemoCls.submitToProceddStep(pb.id, false,false,'');
        Phoenix_BidLineItemEditDemoCls.makeApprovals(pb.id, new List < Phoenix_Bid_Line_Item__c > {
            bl
        }, true);
        // 
        Phoenix_Bid_Line_Item__c bl1 = new Phoenix_Bid_Line_Item__c();
        bl1.Phoenix_Bid__c = pb.Id;
        bl1.Phoenix_Current_Direct_Price__c = 10;
        bl1.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        bl1.Phoenix_Product__c = prod1.id;
        bl1.Phoenix_SCM_Final_Approval__c = true;
        bl1.Phoenix_Final_Status__c = 'Approved';
        bl1.Phoenix_Proposed_Indirect_Selling_Unit__c = 2;
        bl1.Phoenix_SCM_Approval_Y_N__c = 'Y- Only Current Monthly Demand Approved';
        insert bl1;
        Phoenix_Bid_Line_Item__c bl2 = new Phoenix_Bid_Line_Item__c();
        bl2.Phoenix_Bid__c = pb.Id;
        bl2.Phoenix_Current_Direct_Price__c = 10;
        bl2.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        bl2.Phoenix_Product__c = prod1.id;
        bl2.Phoenix_Final_Status__c = 'Approved';
        bl2.Phoenix_Proposed_Indirect_Selling_Unit__c = 2;
        bl2.Phoenix_Proposed_Direct_Selling_Unit__c = 2;
        bl2.Phoenix_SCM_Approval_Y_N__c = 'Y- Current + Inc Demand Approved';
        insert bl2;
        Phoenix_Bid__c pb1 = new Phoenix_Bid__c();
        pb1.Phoenix_Status__c = 'New';
        pb1.Phoenix_Comments__c = 'Test Comments';
        pb1.Phoenix_Customer__c = testAccount.Id;
        //	pb.Phoenix_Customer_Bid_Deadline_Date_Time__c = DateTime.now();
        pb1.Phoenix_Customer_Bid_Deadline_Time_zone__c = 'PST';
        pb1.Phoenix_Customer_Bid_Deadline_Time__c = '6 PM';
        pb1.Phoenix_Customer_Type__c = 'Walgreens';
        pb1.Phoenix_Bid_Deadline_Date__c = System.today();
        insert pb1;
        Phoenix_Bid_Line_Item__c bl3 = new Phoenix_Bid_Line_Item__c();
        bl3.Phoenix_Bid__c = pb1.Id;
        bl3.Phoenix_Current_Direct_Price__c = 10;
        bl3.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        bl3.Phoenix_Product__c = prod1.id;
        bl3.Phoenix_Final_Status__c = 'Approved';
        bl3.Phoenix_Proposed_Indirect_Selling_Unit__c = 2;
        bl3.Phoenix_Proposed_Direct_Selling_Unit__c = 2;
        bl3.Phoenix_SCM_Approval_Y_N__c = 'Y- Current + Inc Demand Approved';
        insert bl3;
          Phoenix_BidLineItemEditDemoCls.getPositions(testAccount.Id);
      }

*/
}