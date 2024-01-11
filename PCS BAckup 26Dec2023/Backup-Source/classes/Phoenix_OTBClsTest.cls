@isTest
public class Phoenix_OTBClsTest {
    
    static testmethod void getItems() {
  ///  try {
            Phoenix_TestDataCreator testData = new Phoenix_TestDataCreator();
            testData.generateBids();
            testData.generateApprovalMatrix();
            Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
            User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
                              EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US', ProfileId = p.Id, 
                              TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testorg.com'+System.now().getTime());
            System.runAs(u) {
                // The following code runs as user 'u' 
                System.debug('Current User: ' + UserInfo.getUserName());
                System.debug('Current Profile: ' + UserInfo.getProfileId()); 
            }
            Account testAccount = new Account(Name = 'Test Account',Phoenix_Customer_Service_Approver__c=u.Id);
            insert testAccount;
            Phoenix_Bid__c pb = new Phoenix_Bid__c();
            pb.Phoenix_Status__c = 'New';
            pb.Phoenix_Comments__c = 'Test Comments';
            pb.Phoenix_Customer__c = testAccount.Id;
            //  pb.Phoenix_Customer_Bid_Deadline_Date_Time__c = DateTime.now();
            pb.Phoenix_Customer_Bid_Deadline_Time_zone__c = 'PST';
            pb.Phoenix_Customer_Bid_Deadline_Time__c = '6 PM';
            // pb.Phoenix_Customer_Type__c = 'Direct and Indirect';
            pb.Phoenix_Bid_Deadline_Date__c = System.today();
           pb.Phoenix_Bid_Type__c = 'Short Dated OTB';
           pb.Phoenix_Proposed_Cash_Terms__c =10;
           insert pb;
            
            
            Phoenix_Contract__c Cntrct = new Phoenix_Contract__c();
            Cntrct.name = 'taest cntrct';
            Cntrct.Phoenix_Contract_Number__c = '223';
            insert Cntrct;
            
            Product2 prod1 = new Product2(Name = 'Test Product', Family = 'Test Family',Phoenix_Product_Director__c=u.Id, IsActive = TRUE, ProductCode = '324');
            insert prod1;
            Phoenix_OTBCls.getReBidLineInfo(prod1.Id, pb.id);
            Phoenix_OTBCls.getReBidLineInfo1(prod1.Id, pb.id);
            Phoenix_OTBCls.getReBidLineInfo2(prod1.Id, pb.id);
            Phoenix_OTBCls.getReBidLineInfo3(prod1.Id, pb.id);
            Phoenix_OTBCls.getReBidLineInfo4(prod1.Id, pb.id);
            Phoenix_OTBCls.getAllTotals(pb.id);
            Phoenix_OTBCls.getupdatedforExport(pb.id);
            Phoenix_OTBCls.getupdatedforExport1(pb.id);
            Phoenix_OTBCls.getContracts(testAccount.Id, 'a');
            
            Phoenix_Bid_Line_Item__c bl = new Phoenix_Bid_Line_Item__c();
            bl.Phoenix_Bid__c = pb.Id;
            bl.Phoenix_Current_Direct_Price__c = 10;
        bl.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        bl.Phoenix_Product__c = prod1.id;
        bl.Phoenix_Final_Status__c = 'Approved';
        bl.Phoenix_WAC1__c = 10;
        bl.Phoenix_Estimated_Medicaid_Returns__c=2.5023;
        insert bl;
            Phoenix_OTBCls.getCalcs(bl, bl.id, 'No Change', 'rebateType','Direct');
            Phoenix_Bid_Line_Item__c bl2 = new Phoenix_Bid_Line_Item__c();
            bl2.Phoenix_Bid__c = testData.bidsList[0].Id;
            bl2.Phoenix_Current_Direct_Price__c = 10;
            bl2.Phoenix_Current_Indirect_Selling_Unit__c = 10;
            bl2.Phoenix_Product__c = prod1.id;
            bl2.Phoenix_Final_Status__c = 'Approved';
            insert bl2;
            
            Phoenix_Bid_Line_Item__c bl3 = new Phoenix_Bid_Line_Item__c();
            bl3.Phoenix_Bid__c = pb.Id;
            bl3.Phoenix_Current_Direct_Price__c = 10;
            bl3.Phoenix_Current_Indirect_Selling_Unit__c = 10;
            bl3.Phoenix_Product__c = prod1.id;
            bl3.Phoenix_Final_Status__c = 'Approved';
            bl3.Phoenix_Proposed_Indirect_Selling_Unit__c = 2;
            bl3.Phoenix_Proposed_Direct_Selling_Unit__c = 2;
            bl3.Phoenix_SCM_Approval_Y_N__c = 'Y- Current + Inc Demand Approved';
         bl3.Phoenix_Estimated_Medicaid_Returns__c=2.5023;
            insert bl3;
            
            Phoenix_NPR_Data__c nprdat = new Phoenix_NPR_Data__c();
            nprdat.Phoenix_Contract__c = Cntrct.id;
            nprdat.Phoenix_NPR_Status__c = 'Active';
            nprdat.Phoenix_Contract_Number__c = '223';
            nprdat.Phoenix_Product__c = prod1.id;
            nprdat.Phoenix_12Months_Sales_Unit__c = 200;
            nprdat.Phoenix_Contract_Type__c = 'Direct';
            nprdat.Phoenix_Rebate_G_N_Indicator__c = '10N+ 0G';
            nprdat.Phoenix_Bonafied_G_N_Indicator__c = '5N+0G';
            insert nprdat;
            
            List < Phoenix_Approval_Process_Step__c > approvalSteps = [Select Id FROM Phoenix_Approval_Process_Step__c where Phoenix_Order__c = 1 LImit 1];
            Phoenix_Bid_Process_Steps__c bisp = new Phoenix_Bid_Process_Steps__c();
            bisp.Name = 'Contracts';
            bisp.Phoenix_Bid__c = pb.Id;
            bisp.Phoenix_Approver__c = Userinfo.getUserId();
            bisp.Phoenix_Approver_Team__c = 'Marketing';
            bisp.Phoenix_Process_Step__c = approvalSteps[0].Id;
            insert bisp;
            Phoenix_Bid_Process_Steps__c bisp1 = new Phoenix_Bid_Process_Steps__c();
            bisp1.Name = 'Marketing';
            bisp1.Phoenix_Bid__c = pb.Id;
            bisp1.Phoenix_Approver__c = Userinfo.getUserId();
            bisp1.Phoenix_Approver_Team__c = 'Marketing';
            bisp1.Phoenix_Process_Step__c = approvalSteps[0].Id;
            insert bisp1;
            
            Phoenix_Contract__c Cntrct1 = new Phoenix_Contract__c();
            Cntrct1.name = 'taest cntrct1';
            Cntrct1.Phoenix_Contract_Number__c = '3000000733';
            insert Cntrct1;
            Phoenix_Contract__c Cntrct2 = new Phoenix_Contract__c();
            Cntrct2.name = 'taest cntrct2';
            Cntrct2.Phoenix_Contract_Number__c = '3000001332';
            insert Cntrct2;
            
            Phoenix_NPR_Data__c nprdat1 = new Phoenix_NPR_Data__c();
            nprdat1.Phoenix_Contract__c = Cntrct1.id;
            nprdat1.Phoenix_NPR_Status__c = 'Active';
            nprdat1.Phoenix_Contract_Number__c = '3000000733';
            nprdat1.Phoenix_Product__c = prod1.id;
            nprdat1.Phoenix_12Months_Sales_Unit__c = 200;
            nprdat1.Phoenix_Contract_Type__c = 'Indirect';
            nprdat1.Phoenix_Rebate_G_N_Indicator__c = '10N+ 0G';
            nprdat1.Phoenix_Bonafied_G_N_Indicator__c = '5N+0G';
            insert nprdat1;
            Phoenix_NPR_Data__c nprdat2 = new Phoenix_NPR_Data__c();
            nprdat2.Phoenix_Contract__c = Cntrct2.id;
            nprdat2.Phoenix_NPR_Status__c = 'Active';
            nprdat2.Phoenix_Contract_Number__c = '3000001332';
            nprdat2.Phoenix_Product__c = prod1.id;
            nprdat2.Phoenix_12Months_Sales_Unit__c = 200;
            nprdat2.Phoenix_Contract_Type__c = 'Indirect';
            nprdat2.Phoenix_Rebate_G_N_Indicator__c = '10N+ 0G';
            nprdat2.Phoenix_Bonafied_G_N_Indicator__c = '5N+0G';
            insert nprdat2;
            
            Phoenix_Contract__c Cntrct3 = new Phoenix_Contract__c();
            Cntrct3.name = 'taest cntrct3';
            Cntrct3.Phoenix_Contract_Number__c = '3000000762';
            insert Cntrct3;
            
            Phoenix_NPR_Data__c nprdat3 = new Phoenix_NPR_Data__c();
            nprdat3.Phoenix_Contract__c = Cntrct3.id;
            nprdat3.Phoenix_NPR_Status__c = 'Active';
            nprdat3.Phoenix_Contract_Number__c = '3000000762';
            nprdat3.Phoenix_Product__c = prod1.id;
            nprdat3.Phoenix_12Months_Sales_Unit__c = 200;
            nprdat3.Phoenix_Contract_Type__c = 'Indirect';
            nprdat3.Phoenix_Rebate_G_N_Indicator__c = '10N+ 0G';
            nprdat3.Phoenix_Bonafied_G_N_Indicator__c = '5N+0G';
            insert nprdat3;
            
            Phoenix_Contract__c Cntrct4 = new Phoenix_Contract__c();
            Cntrct4.name = 'taest cntrct4';
            Cntrct4.Phoenix_Contract_Number__c = '3000000551';
            insert Cntrct4;
            
            Phoenix_NPR_Data__c nprdat4 = new Phoenix_NPR_Data__c();
            nprdat4.Phoenix_Contract__c = Cntrct4.id;
            nprdat4.Phoenix_NPR_Status__c = 'Active';
            nprdat4.Phoenix_Contract_Number__c = '3000000551';
            nprdat4.Phoenix_Product__c = prod1.id;
            nprdat4.Phoenix_12Months_Sales_Unit__c = 200;
            nprdat4.Phoenix_Contract_Type__c = 'Indirect';
            nprdat4.Phoenix_Rebate_G_N_Indicator__c = '10N+ 0G';
            nprdat4.Phoenix_Bonafied_G_N_Indicator__c = '5N+0G';
            insert nprdat4;
            
            Phoenix_OTBCls.updateRelatedList(new list < Phoenix_Bid_Line_Item__c > {
                bl
                    });
            Phoenix_OTBCls.findByProductFamily(new list < string > {
                'lev'
                    }, pb.Id, new list < string > {
                        'Rx'
                            }, new list < string > {
                                ''
                                    });
            
            Phoenix_OTBCls.saveLineItems(new list < Phoenix_Bid_Line_Item__c > {bl,bl3}, pb.id, 'Gross', 'Gross', '', true, true, true, 'Approved', true,'sample');
            Phoenix_OTBCls.saveLineItems1(new list < Phoenix_Bid_Line_Item__c > {bl,bl3}, pb.id, 'Gross', 'Gross', '', true, true, true, 'Not Approved', true,'sample');
            Phoenix_OTBCls.makeApprovals(pb.id, new List < Phoenix_Bid_Line_Item__c > {bl}, true);
            Phoenix_OTBCls.submitToProceddStep(pb.id, false, 'Approved',false,'');
            Phoenix_OTBCls.updateNextContractProcessSteps(pb.Id, pb.Name, new List < Phoenix_Bid_Process_Steps__c > {bisp});
          //  Phoenix_OTBCls.updateNextProcessSteps(pb.id, pb.Name, new List < Phoenix_Bid_Process_Steps__c > {bisp}, false, false, false, 'Approved');
            Phoenix_OTBCls.getSubmitBidInfo(pb.Id);
                Phoenix_OTBCls.getRelatedList(pb.id);
            Phoenix_OTBCls.getSubmitBidInfo1(pb.Id);
            Phoenix_OTBCls.updateLines(pb.Id,'Direct');
            Phoenix_OTBCls.getNPRData(new list < string > {
                Cntrct.Phoenix_Contract_Number__c
                    }, pb.Id, 'Direct');
            
    
            Phoenix_OTBCls.deleteLineItems(bl.id);           
            //Phoenix_WalgreensCls.deleteLineItems(bl.id);
            Phoenix_OTBCls.testLogic();
            Phoenix_OTBCls.testLogic1();
            Phoenix_OTBCls.testLogic2();
            Phoenix_OTBCls.testLogic3();
            Phoenix_OTBCls.testLogic4();
            
     //  } catch (exception ex) {}
    }
    
    static testmethod void getItems1() {
     //  try {
            Phoenix_TestDataCreator testData = new Phoenix_TestDataCreator();
            testData.generateBids();
            testData.generateApprovalMatrix();
            Account testAccount = new Account(Name = 'Test Account');
            insert testAccount;
            Phoenix_Bid__c pb = new Phoenix_Bid__c();
            pb.Phoenix_Status__c = 'New';
            pb.Phoenix_Comments__c = 'Test Comments';
            pb.Phoenix_Customer__c = testAccount.Id;
            //  pb.Phoenix_Customer_Bid_Deadline_Date_Time__c = DateTime.now();
            pb.Phoenix_Customer_Bid_Deadline_Time_zone__c = 'PST';
            pb.Phoenix_Customer_Bid_Deadline_Time__c = '6 PM';
            // pb.Phoenix_Customer_Type__c = 'Direct and Indirect';
            pb.Phoenix_Bid_Deadline_Date__c = System.today();
            pb.Phoenix_Bid_Type__c = 'Good Dated OTB';
         pb.Phoenix_Proposed_Cash_Terms__c =10;
            insert pb;
            
            
            Phoenix_Contract__c Cntrct = new Phoenix_Contract__c();
            Cntrct.name = 'taest cntrct';
            Cntrct.Phoenix_Contract_Number__c = '223';
            insert Cntrct;
            
            Product2 prod1 = new Product2(Name = 'Test Product', Family = 'Test Family', IsActive = TRUE, ProductCode = '324');
            insert prod1;
            Phoenix_OTBCls.getReBidLineInfo(prod1.Id, pb.id);
            Phoenix_OTBCls.getReBidLineInfo1(prod1.Id, pb.id);
            Phoenix_OTBCls.getReBidLineInfo2(prod1.Id, pb.id);
            Phoenix_OTBCls.getReBidLineInfo3(prod1.Id, pb.id);
            Phoenix_OTBCls.getReBidLineInfo4(prod1.Id, pb.id);
            Phoenix_OTBCls.getAllTotals(pb.id);
            Phoenix_OTBCls.getupdatedforExport(pb.id);
            Phoenix_OTBCls.getupdatedforExport1(pb.id);
            Phoenix_OTBCls.getContracts(testAccount.Id, 'a');
            Phoenix_OTBCls.getNPRData(new list < string > {
                Cntrct.Phoenix_Contract_Number__c
                    }, pb.Id, 'OneTimeBuy');
            
            Phoenix_Bid_Line_Item__c bl = new Phoenix_Bid_Line_Item__c();
            bl.Phoenix_Bid__c = pb.Id;
            bl.Phoenix_Current_Direct_Price__c = 10;
            bl.Phoenix_Current_Indirect_Selling_Unit__c = 10;
            bl.Phoenix_Product__c = prod1.id;
            bl.Phoenix_Final_Status__c = 'Not Approved';
        bl.Phoenix_WAC1__c = 10;
        bl.Phoenix_Estimated_Medicaid_Returns__c=2.5023;
            insert bl;
            Phoenix_OTBCls.getCalcs(bl, bl.id, 'No Change', 'MarketApproval','Indirect');
            Phoenix_Bid_Line_Item__c bl2 = new Phoenix_Bid_Line_Item__c();
            bl2.Phoenix_Bid__c = testData.bidsList[0].Id;
            bl2.Phoenix_Current_Direct_Price__c = 10;
            bl2.Phoenix_Current_Indirect_Selling_Unit__c = 10;
            bl2.Phoenix_Product__c = prod1.id;
            bl2.Phoenix_Final_Status__c = 'Approved';
         bl2.Phoenix_WAC1__c = 10;
            insert bl2;
            
            Phoenix_Bid_Line_Item__c bl3 = new Phoenix_Bid_Line_Item__c();
            bl3.Phoenix_Bid__c = pb.Id;
            bl3.Phoenix_Current_Direct_Price__c = 10;
            bl3.Phoenix_Current_Indirect_Selling_Unit__c = 10;
            bl3.Phoenix_Product__c = prod1.id;
            bl3.Phoenix_Final_Status__c = 'Approved';
            bl3.Phoenix_Proposed_Indirect_Selling_Unit__c = 2;
            bl3.Phoenix_Proposed_Direct_Selling_Unit__c = 2;
            bl3.Phoenix_SCM_Approval_Y_N__c = 'Y- Current + Inc Demand Approved';
         bl3.Phoenix_WAC1__c = 10;
         bl3.Phoenix_Estimated_Medicaid_Returns__c=2.5023;
            insert bl3;
            
            Phoenix_NPR_Data__c nprdat = new Phoenix_NPR_Data__c();
            nprdat.Phoenix_Contract__c = Cntrct.id;
            nprdat.Phoenix_NPR_Status__c = 'Active';
            nprdat.Phoenix_Contract_Number__c = '223';
            nprdat.Phoenix_Product__c = prod1.id;
            nprdat.Phoenix_12Months_Sales_Unit__c = 200;
            nprdat.Phoenix_Contract_Type__c = 'Direct';
            nprdat.Phoenix_Rebate_G_N_Indicator__c = '10N+ 0G';
            nprdat.Phoenix_Bonafied_G_N_Indicator__c = '5N+0G';
            insert nprdat;
            
            List < Phoenix_Approval_Process_Step__c > approvalSteps = [Select Id FROM Phoenix_Approval_Process_Step__c where Phoenix_Order__c = 1 LImit 1];
            
            Phoenix_Bid_Process_Steps__c bisp = new Phoenix_Bid_Process_Steps__c();
            bisp.Name = 'Contracts';
            bisp.Phoenix_Bid__c = pb.Id;
            bisp.Phoenix_Approver__c = Userinfo.getUserId();
            bisp.Phoenix_Approver_Team__c = 'Marketing';
            bisp.Phoenix_Process_Step__c = approvalSteps[0].Id;
            insert bisp;
            Phoenix_Bid_Process_Steps__c bisp1 = new Phoenix_Bid_Process_Steps__c();
            bisp1.Name = 'Marketing';
            bisp1.Phoenix_Bid__c = pb.Id;
            bisp1.Phoenix_Approver__c = Userinfo.getUserId();
            bisp1.Phoenix_Approver_Team__c = 'Marketing';
            bisp1.Phoenix_Process_Step__c = approvalSteps[0].Id;
            insert bisp1;
            
            
            
            Phoenix_Contract__c Cntrct1 = new Phoenix_Contract__c();
            Cntrct1.name = 'taest cntrct1';
            Cntrct1.Phoenix_Contract_Number__c = '3000000733';
            insert Cntrct1;
            Phoenix_Contract__c Cntrct2 = new Phoenix_Contract__c();
            Cntrct2.name = 'taest cntrct2';
            Cntrct2.Phoenix_Contract_Number__c = '3000001332';
            insert Cntrct2;
            
            Phoenix_NPR_Data__c nprdat1 = new Phoenix_NPR_Data__c();
            nprdat1.Phoenix_Contract__c = Cntrct1.id;
            nprdat1.Phoenix_NPR_Status__c = 'Active';
            nprdat1.Phoenix_Contract_Number__c = '3000000733';
            nprdat1.Phoenix_Product__c = prod1.id;
            nprdat1.Phoenix_12Months_Sales_Unit__c = 200;
            nprdat1.Phoenix_Contract_Type__c = 'Indirect';
            nprdat1.Phoenix_Rebate_G_N_Indicator__c = '10N+ 0G';
            nprdat1.Phoenix_Bonafied_G_N_Indicator__c = '5N+0G';
            insert nprdat1;
            Phoenix_NPR_Data__c nprdat2 = new Phoenix_NPR_Data__c();
            nprdat2.Phoenix_Contract__c = Cntrct2.id;
            nprdat2.Phoenix_NPR_Status__c = 'Active';
            nprdat2.Phoenix_Contract_Number__c = '3000001332';
            nprdat2.Phoenix_Product__c = prod1.id;
            nprdat2.Phoenix_12Months_Sales_Unit__c = 200;
            nprdat2.Phoenix_Contract_Type__c = 'Indirect';
            nprdat2.Phoenix_Rebate_G_N_Indicator__c = '10N+ 0G';
            nprdat2.Phoenix_Bonafied_G_N_Indicator__c = '5N+0G';
            insert nprdat2;
            
            
            Phoenix_Contract__c Cntrct3 = new Phoenix_Contract__c();
            Cntrct3.name = 'taest cntrct3';
            Cntrct3.Phoenix_Contract_Number__c = '3000000762';
            insert Cntrct3;
            
            Phoenix_NPR_Data__c nprdat3 = new Phoenix_NPR_Data__c();
            nprdat3.Phoenix_Contract__c = Cntrct3.id;
            nprdat3.Phoenix_NPR_Status__c = 'Active';
            nprdat3.Phoenix_Contract_Number__c = '3000000762';
            nprdat3.Phoenix_Product__c = prod1.id;
            nprdat3.Phoenix_12Months_Sales_Unit__c = 200;
            nprdat3.Phoenix_Contract_Type__c = 'Indirect';
            nprdat3.Phoenix_Rebate_G_N_Indicator__c = '10N+ 0G';
            nprdat3.Phoenix_Bonafied_G_N_Indicator__c = '5N+0G';
            insert nprdat3;
            
            
            Phoenix_Contract__c Cntrct4 = new Phoenix_Contract__c();
            Cntrct4.name = 'taest cntrct4';
            Cntrct4.Phoenix_Contract_Number__c = '3000000551';
            insert Cntrct4;
            
            Phoenix_NPR_Data__c nprdat4 = new Phoenix_NPR_Data__c();
            nprdat4.Phoenix_Contract__c = Cntrct4.id;
            nprdat4.Phoenix_NPR_Status__c = 'Active';
            nprdat4.Phoenix_Contract_Number__c = '3000000551';
            nprdat4.Phoenix_Product__c = prod1.id;
            nprdat4.Phoenix_12Months_Sales_Unit__c = 200;
            nprdat4.Phoenix_Contract_Type__c = 'Indirect';
            nprdat4.Phoenix_Rebate_G_N_Indicator__c = '10N+ 0G';
            nprdat4.Phoenix_Bonafied_G_N_Indicator__c = '5N+0G';
            insert nprdat4;
            
            
            
            Phoenix_OTBCls.updateRelatedList(new list < Phoenix_Bid_Line_Item__c > {
                bl
                    });
            Phoenix_OTBCls.findByProductFamily(new list < string > {
                'lev'
                    }, pb.Id, new list < string > {
                        'Rx'
                            }, new list < string > {
                                ''
                                    });
            
            Phoenix_OTBCls.saveLineItems(new list < Phoenix_Bid_Line_Item__c > {bl,bl3}, pb.id, 'Gross', 'Gross', '', false, false, false, 'Approved', false,'sample');
            Phoenix_OTBCls.saveLineItems1(new list < Phoenix_Bid_Line_Item__c > {bl,bl3}, pb.id, 'Gross', 'Gross', '', false, false, false, 'Approved', false,'sample');
            Phoenix_OTBCls.makeApprovals(pb.id, new List < Phoenix_Bid_Line_Item__c > {bl}, true);
            Phoenix_OTBCls.submitToProceddStep(pb.id, false, 'Approved',false,'');
            Phoenix_OTBCls.updateNextContractProcessSteps(pb.Id, pb.Name, new List < Phoenix_Bid_Process_Steps__c > {bisp});
            Phoenix_OTBCls.updateNextProcessSteps(pb.id, pb.Name, new List < Phoenix_Bid_Process_Steps__c > {bisp}, true, true, true, 'Not Approved');
            Phoenix_OTBCls.getSubmitBidInfo(pb.Id);
            Phoenix_OTBCls.getSubmitBidInfo1(pb.Id);
            Phoenix_OTBCls.updateLines(pb.Id,'Indirect');
            Phoenix_OTBCls.getRelatedList(pb.id);
            Phoenix_OTBCls.deleteLineItems(bl.id);           
            Phoenix_OTBCls.testLogic();
            Phoenix_OTBCls.testLogic1();
            Phoenix_OTBCls.testLogic2();
            Phoenix_OTBCls.testLogic3();
            Phoenix_OTBCls.testLogic4();
            
     //  } catch (exception ex) {}
        
    }
    
    static testmethod void getItems2() {
    //  try {
            Phoenix_TestDataCreator testData = new Phoenix_TestDataCreator();
            testData.generateBids();
            testData.generateApprovalMatrix();
            Account testAccount = new Account(Name = 'Test Account');
            insert testAccount;
            Phoenix_Bid__c pb = new Phoenix_Bid__c();
            pb.Phoenix_Status__c = 'New';
            pb.Phoenix_Comments__c = 'Test Comments';
            pb.Phoenix_Customer__c = testAccount.Id;
            //  pb.Phoenix_Customer_Bid_Deadline_Date_Time__c = DateTime.now();
            pb.Phoenix_Customer_Bid_Deadline_Time_zone__c = 'PST';
            pb.Phoenix_Customer_Bid_Deadline_Time__c = '6 PM';
            // pb.Phoenix_Customer_Type__c = 'Direct and Indirect';
            pb.Phoenix_Bid_Deadline_Date__c = System.today();
            pb.Phoenix_Bid_Type__c = 'Short Dated OTB';
         pb.Phoenix_Proposed_Cash_Terms__c =10;
            insert pb;
            
            
            Phoenix_Contract__c Cntrct = new Phoenix_Contract__c();
            Cntrct.name = 'taest cntrct';
            Cntrct.Phoenix_Contract_Number__c = '223';
            insert Cntrct;
            
            Product2 prod1 = new Product2(Name = 'Test Product', Family = 'Test Family', IsActive = TRUE, ProductCode = '324');
            insert prod1;
            Phoenix_OTBCls.getReBidLineInfo(prod1.Id, pb.id);
            Phoenix_OTBCls.getReBidLineInfo1(prod1.Id, pb.id);
            Phoenix_OTBCls.getReBidLineInfo2(prod1.Id, pb.id);
            Phoenix_OTBCls.getReBidLineInfo3(prod1.Id, pb.id);
            Phoenix_OTBCls.getReBidLineInfo4(prod1.Id, pb.id);
            Phoenix_OTBCls.getAllTotals(pb.id);
            Phoenix_OTBCls.getupdatedforExport(pb.id);
            Phoenix_OTBCls.getupdatedforExport1(pb.id);
            Phoenix_OTBCls.getContracts(testAccount.Id, 'a');
            
            Phoenix_Bid_Line_Item__c bl = new Phoenix_Bid_Line_Item__c();
            bl.Phoenix_Bid__c = pb.Id;
            bl.Phoenix_Current_Direct_Price__c = 10;
            bl.Phoenix_Current_Indirect_Selling_Unit__c = 10;
            bl.Phoenix_Product__c = prod1.id;
            bl.Phoenix_Final_Status__c = 'Not Approved';
            bl.Phoenix_Estimated_Medicaid_Returns__c=2.0;
            bl.Phoenix_WAC1__c = 10;
            insert bl;
            Phoenix_OTBCls.getCalcs(bl, bl.id, 'No Change', 'ContractApproval','Direct');
            Phoenix_Bid_Line_Item__c bl2 = new Phoenix_Bid_Line_Item__c();
            bl2.Phoenix_Bid__c = testData.bidsList[0].Id;
            bl2.Phoenix_Current_Direct_Price__c = 10;
            bl2.Phoenix_Current_Indirect_Selling_Unit__c = 10;
            bl2.Phoenix_Product__c = prod1.id;
            bl2.Phoenix_Final_Status__c = 'Not Approved';
         bl2.Phoenix_WAC1__c = 10;
            insert bl2;
            
            Phoenix_Bid_Line_Item__c bl3 = new Phoenix_Bid_Line_Item__c();
            bl3.Phoenix_Bid__c = pb.Id;
            bl3.Phoenix_Current_Direct_Price__c = 10;
            bl3.Phoenix_Current_Indirect_Selling_Unit__c = 10;
            bl3.Phoenix_Product__c = prod1.id;
            bl3.Phoenix_Final_Status__c = 'Approved';
            bl3.Phoenix_Proposed_Indirect_Selling_Unit__c = 2;
            bl3.Phoenix_Proposed_Direct_Selling_Unit__c = 2;
            bl3.Phoenix_SCM_Approval_Y_N__c = 'Y- Current + Inc Demand Approved';
        bl3.Phoenix_WAC1__c = 10;
        bl3.Phoenix_Estimated_Medicaid_Returns__c=2.0345;
            insert bl3;
            
            Phoenix_NPR_Data__c nprdat = new Phoenix_NPR_Data__c();
            nprdat.Phoenix_Contract__c = Cntrct.id;
            nprdat.Phoenix_NPR_Status__c = 'Active';
            nprdat.Phoenix_Contract_Number__c = '223';
            nprdat.Phoenix_Product__c = prod1.id;
            nprdat.Phoenix_12Months_Sales_Unit__c = 200;
            nprdat.Phoenix_Contract_Type__c = 'Direct';
            nprdat.Phoenix_Rebate_G_N_Indicator__c = '10N+ 0G';
            nprdat.Phoenix_Bonafied_G_N_Indicator__c = '5N+0G';
            insert nprdat;
            
            List < Phoenix_Approval_Process_Step__c > approvalSteps = [Select Id FROM Phoenix_Approval_Process_Step__c where Phoenix_Order__c = 1 LImit 1];
            Phoenix_Bid_Process_Steps__c bisp = new Phoenix_Bid_Process_Steps__c();
            bisp.Name = 'Contracts';
            bisp.Phoenix_Bid__c = pb.Id;
            bisp.Phoenix_Approver__c = Userinfo.getUserId();
            bisp.Phoenix_Approver_Team__c = 'Marketing';
            bisp.Phoenix_Process_Step__c = approvalSteps[0].Id;
            insert bisp;
            Phoenix_Bid_Process_Steps__c bisp1 = new Phoenix_Bid_Process_Steps__c();
            bisp1.Name = 'Marketing';
            bisp1.Phoenix_Bid__c = pb.Id;
            bisp1.Phoenix_Approver__c = Userinfo.getUserId();
            bisp1.Phoenix_Approver_Team__c = 'Marketing';
            bisp1.Phoenix_Process_Step__c = approvalSteps[0].Id;
            insert bisp1;
            
            Phoenix_Contract__c Cntrct1 = new Phoenix_Contract__c();
            Cntrct1.name = 'taest cntrct1';
            Cntrct1.Phoenix_Contract_Number__c = '3000000733';
            insert Cntrct1;
            Phoenix_Contract__c Cntrct2 = new Phoenix_Contract__c();
            Cntrct2.name = 'taest cntrct2';
            Cntrct2.Phoenix_Contract_Number__c = '3000001332';
            insert Cntrct2;
            
            Phoenix_NPR_Data__c nprdat1 = new Phoenix_NPR_Data__c();
            nprdat1.Phoenix_Contract__c = Cntrct1.id;
            nprdat1.Phoenix_NPR_Status__c = 'Active';
            nprdat1.Phoenix_Contract_Number__c = '3000000733';
            nprdat1.Phoenix_Product__c = prod1.id;
            nprdat1.Phoenix_12Months_Sales_Unit__c = 200;
            nprdat1.Phoenix_Contract_Type__c = 'Indirect';
            nprdat1.Phoenix_Rebate_G_N_Indicator__c = '10N+ 0G';
            nprdat1.Phoenix_Bonafied_G_N_Indicator__c = '5N+0G';
            insert nprdat1;
            Phoenix_NPR_Data__c nprdat2 = new Phoenix_NPR_Data__c();
            nprdat2.Phoenix_Contract__c = Cntrct2.id;
            nprdat2.Phoenix_NPR_Status__c = 'Active';
            nprdat2.Phoenix_Contract_Number__c = '3000001332';
            nprdat2.Phoenix_Product__c = prod1.id;
            nprdat2.Phoenix_12Months_Sales_Unit__c = 200;
            nprdat2.Phoenix_Contract_Type__c = 'Indirect';
            nprdat2.Phoenix_Rebate_G_N_Indicator__c = '10N+ 0G';
            nprdat2.Phoenix_Bonafied_G_N_Indicator__c = '5N+0G';
            insert nprdat2;
            
            
            Phoenix_Contract__c Cntrct3 = new Phoenix_Contract__c();
            Cntrct3.name = 'taest cntrct3';
            Cntrct3.Phoenix_Contract_Number__c = '3000000762';
            insert Cntrct3;
            
            Phoenix_NPR_Data__c nprdat3 = new Phoenix_NPR_Data__c();
            nprdat3.Phoenix_Contract__c = Cntrct3.id;
            nprdat3.Phoenix_NPR_Status__c = 'Active';
            nprdat3.Phoenix_Contract_Number__c = '3000000762';
            nprdat3.Phoenix_Product__c = prod1.id;
            nprdat3.Phoenix_12Months_Sales_Unit__c = 200;
            nprdat3.Phoenix_Contract_Type__c = 'Indirect';
            nprdat3.Phoenix_Rebate_G_N_Indicator__c = '10N+ 0G';
            nprdat3.Phoenix_Bonafied_G_N_Indicator__c = '5N+0G';
            insert nprdat3;
            
            Phoenix_Contract__c Cntrct4 = new Phoenix_Contract__c();
            Cntrct4.name = 'taest cntrct4';
            Cntrct4.Phoenix_Contract_Number__c = '3000000551';
            insert Cntrct4;
            
            Phoenix_NPR_Data__c nprdat4 = new Phoenix_NPR_Data__c();
            nprdat4.Phoenix_Contract__c = Cntrct4.id;
            nprdat4.Phoenix_NPR_Status__c = 'Active';
            nprdat4.Phoenix_Contract_Number__c = '3000000551';
            nprdat4.Phoenix_Product__c = prod1.id;
            nprdat4.Phoenix_12Months_Sales_Unit__c = 200;
            nprdat4.Phoenix_Contract_Type__c = 'Indirect';
            nprdat4.Phoenix_Rebate_G_N_Indicator__c = '10N+ 0G';
            nprdat4.Phoenix_Bonafied_G_N_Indicator__c = '5N+0G';
            insert nprdat4;
            
            Phoenix_OTBCls.updateRelatedList(new list < Phoenix_Bid_Line_Item__c > {
                bl
                    });
            Phoenix_OTBCls.findByProductFamily(new list < string > {
                'lev'
                    }, pb.Id, new list < string > {
                        'Rx'
                            }, new list < string > {
                                ''
                                    });
            
            Phoenix_OTBCls.saveLineItems(new list < Phoenix_Bid_Line_Item__c > {bl,bl3}, pb.id, 'Gross', 'Gross', '', true, true, true, 'Not Approved', true,'sample');
            Phoenix_OTBCls.saveLineItems1(new list < Phoenix_Bid_Line_Item__c > {bl,bl3}, pb.id, 'Gross', 'Gross', '', true, true, true, 'Not Approved', true,'sample');
            Phoenix_OTBCls.makeApprovals(pb.id, new List < Phoenix_Bid_Line_Item__c > {bl}, true);
            Phoenix_OTBCls.submitToProceddStep(pb.id, false, 'Not Approved',false,'');
            Phoenix_OTBCls.updateNextContractProcessSteps(pb.Id, pb.Name, new List < Phoenix_Bid_Process_Steps__c > {bisp});
          //  Phoenix_OTBCls.updateNextProcessSteps(pb.id, pb.Name, new List < Phoenix_Bid_Process_Steps__c > {bisp}, false, false, false, 'Not Approved');
            Phoenix_OTBCls.getSubmitBidInfo(pb.Id);
            Phoenix_OTBCls.getSubmitBidInfo1(pb.Id);
            Phoenix_OTBCls.updateLines(pb.Id,'Direct');
            Phoenix_OTBCls.fetchUserOTB();
            
            Phoenix_OTBCls.getNPRData(new list < string > {
                Cntrct.Phoenix_Contract_Number__c
                    }, pb.Id, 'OneTimeBuy');
            
            Phoenix_OTBCls.getRelatedList(pb.id);
            Phoenix_OTBCls.deleteLineItems(bl.id);           
            Phoenix_OTBCls.testLogic();
            Phoenix_OTBCls.testLogic1();
            Phoenix_OTBCls.testLogic2();
            Phoenix_OTBCls.testLogic3();
            Phoenix_OTBCls.testLogic4();
            
      //  } catch (exception ex) {}
    }
    
}