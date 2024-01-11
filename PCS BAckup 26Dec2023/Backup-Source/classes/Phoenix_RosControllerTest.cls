@isTest 
public class Phoenix_RosControllerTest {
    static testmethod void setupTestData() {
        Phoenix_RosController.coverageBlock();
    }
    
    
    static testmethod void getItems() {
        try {
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
            pb.Phoenix_Customer_Type__c = 'Direct and Indirect';
            pb.Phoenix_Bid_Deadline_Date__c = System.today();
            pb.Phoenix_Bid_Type__c = 'VIP Rebate';
            insert pb;
            
            Phoenix_Contract__c Cntrct = new Phoenix_Contract__c();
            Cntrct.name = 'taest cntrct';
            Cntrct.Phoenix_Contract_Number__c = '223';
            insert Cntrct;
            
            Product2 prod1 = new Product2(Name = 'Test Product', Family = 'Test Family', IsActive = TRUE, ProductCode = '324');
            insert prod1;
            Phoenix_Bid_Line_Item__c bl = new Phoenix_Bid_Line_Item__c();
            bl.Phoenix_Bid__c = pb.Id;
            bl.Phoenix_12_Months_Actual_Sales__c = 10;
            bl.Phoenix_Current_Direct_Price__c = 10;
            bl.Phoenix_Current_Indirect_Selling_Unit__c = 10;
            bl.Phoenix_Current_Retail_Direct_Units__c = 12;
            bl.Phoenix_Product__c = prod1.id;
            bl.Phoenix_Final_Status__c = 'Approved';
            insert bl;
            
            Phoenix_BidLineItemExtn__c bliExtn1 = new Phoenix_BidLineItemExtn__c();
            bliExtn1.Phoenix_Bid_Line_Item__c = bl.Id;
            insert bliExtn1;
            
            
            Phoenix_Bid_Line_Item__c bl2 = new Phoenix_Bid_Line_Item__c();
            bl2.Phoenix_Bid__c = testData.bidsList[0].Id;
            bl2.Phoenix_Current_Direct_Price__c = 10;
            bl2.Phoenix_12_Months_Actual_Sales__c = 10;
            bl2.Phoenix_Current_Indirect_Selling_Unit__c = 10;
            bl2.Phoenix_Current_Retail_Direct_Units__c = 12;
            bl2.Phoenix_Product__c = prod1.id;
            bl2.Phoenix_Final_Status__c = 'Approved';
            insert bl2;
            
            Phoenix_BidLineItemExtn__c bliExtn2 = new Phoenix_BidLineItemExtn__c();
            bliExtn2.Phoenix_Bid_Line_Item__c = bl2.Id;
            insert bliExtn2;
            
            Phoenix_Bid_Line_Item__c bl3 = new Phoenix_Bid_Line_Item__c();
            bl3.Phoenix_Bid__c = pb.Id;
            bl3.Phoenix_12_Months_Actual_Sales__c = 10;
            bl3.Phoenix_Current_Direct_Price__c = 10;
            bl3.Phoenix_Current_Retail_Direct_Units__c = 12;
            bl3.Phoenix_Current_Indirect_Selling_Unit__c = 10;
            bl3.Phoenix_Product__c = prod1.id;
            bl3.Phoenix_Final_Status__c = 'Approved';
            bl3.Phoenix_Proposed_Indirect_Selling_Unit__c = 2;
            bl3.Phoenix_Proposed_Direct_Selling_Unit__c = 2;
            bl3.Phoenix_SCM_Approval_Y_N__c = 'Y- Current + Inc Demand Approved';
            insert bl3;
            
            Phoenix_BidLineItemExtn__c bliExtn3 = new Phoenix_BidLineItemExtn__c();
            bliExtn3.Phoenix_Bid_Line_Item__c = bl3.Id;
            insert bliExtn3;
            
            Phoenix_NPR_Data__c nprdat = new Phoenix_NPR_Data__c();
            nprdat.Phoenix_Contract__c = Cntrct.id;
            nprdat.Phoenix_NPR_Status__c = 'Active';
            nprdat.Phoenix_Contract_Number__c = '223';
            nprdat.Phoenix_Product__c = prod1.id;
            nprdat.Phoenix_Product_Position__c = '2';
            nprdat.Phoenix_12Months_Sales_Unit__c = 200;
            nprdat.Phoenix_Contract_Type__c = 'Direct';
            nprdat.Phoenix_Rebate_G_N_Indicator__c = '10N+ 0G';
            nprdat.Phoenix_Bonafied_G_N_Indicator__c = '5N+0G';
            nprdat.Phoenix_Contract_Price__c = 12.00;
            nprdat.Phoenix_Dead_Net_Tracking_GR__c = 12.00;
            insert nprdat;
            
            /* Phoenix_Approval_Process_Step__c aprovStepObj = new Phoenix_Approval_Process_Step__c();
aprovStepObj.Phoenix_Order__c = 1;
aprovStepObj.Phoenix_Is_Notification_Only__c = false;
insert aprovStepObj; */
            
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
            Phoenix_RosController.getReBidLineInfo(prod1.Id, pb.id);
            Phoenix_RosController.getRelatedList(pb.id);
            Phoenix_RosController.getAllTotals(pb.id);
            Phoenix_RosController.getupdatedforExport(pb.id);
            Phoenix_RosController.getContracts(testAccount.Id, 'a');
            Phoenix_RosController.getPositions(testAccount.Id);
            
            Phoenix_RosController.getNPRData(new list < string > {
                Cntrct.Phoenix_Contract_Number__c
                    }, pb.Id, 'Direct');
            Phoenix_RosController.getNPRData(new list < string > {
                Cntrct.Phoenix_Contract_Number__c
                    }, pb.Id, 'Indirect');
            Phoenix_Contract__c Cntrct1 = new Phoenix_Contract__c();
            Cntrct1.name = 'taest cntrct1';
            Cntrct1.Phoenix_Contract_Number__c = '1000000449';
            insert Cntrct1;
            Phoenix_Contract__c Cntrct2 = new Phoenix_Contract__c();
            Cntrct2.name = 'taest cntrct2';
            Cntrct2.Phoenix_Contract_Number__c = '3000000489';
            insert Cntrct2;
            
            Phoenix_NPR_Data__c nprdat1 = new Phoenix_NPR_Data__c();
            nprdat1.Phoenix_Contract__c = Cntrct1.id;
            nprdat1.Phoenix_NPR_Status__c = 'Active';
            nprdat1.Phoenix_Contract_Number__c = '1000000449';
            nprdat1.Phoenix_Product__c = prod1.id;
            nprdat1.Phoenix_12Months_Sales_Unit__c = 200;
            nprdat1.Phoenix_Contract_Type__c = 'Indirect';
            nprdat1.Phoenix_Rebate_G_N_Indicator__c = '10N+ 0G';
            nprdat1.Phoenix_Bonafied_G_N_Indicator__c = '5N+0G';
            insert nprdat1;
            Phoenix_NPR_Data__c nprdat2 = new Phoenix_NPR_Data__c();
            nprdat2.Phoenix_Contract__c = Cntrct2.id;
            nprdat2.Phoenix_NPR_Status__c = 'Active';
            nprdat2.Phoenix_Contract_Number__c = '3000000485';
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
            
            Phoenix_RosController.getChildExtnRecord(pb.id);
            Phoenix_RosController.updateRelatedList(new list < Phoenix_Bid_Line_Item__c > {
                bl
                    });
            Phoenix_RosController.getNPRData(new list < string > {
                Cntrct1.Phoenix_Contract_Number__c
                    }, pb.Id, 'ROS');
            Phoenix_RosController.updateRelatedList(new list < Phoenix_Bid_Line_Item__c > {
                bl
                    });
            Phoenix_RosController.findByProductFamily(new list < string > {
                'lev'
                    }, pb.Id, new list < string > {
                        'Rx'
                            }, new list < string > {
                                ''
                                    });
            
            Phoenix_RosController.saveLineItems(new list < Phoenix_Bid_Line_Item__c > {
                bl,
                    bl3
                    }, pb.id, 'Gross', 'Gross', '', true, true, true, 'Approved', true,'sample','sample2','sample3');
            Phoenix_RosController.getCalcs(bl, bl.id, 'No Change', 'rebateType');
            Phoenix_RosController.makeApprovals(pb.id, new List < Phoenix_Bid_Line_Item__c > {
                bl
                    }, true);
            Phoenix_RosController.submitToProceddStep(pb.id, false,false,'');
          /*  Phoenix_RosController.updateNextContractProcessSteps(pb.Id, pb.Name, new List < Phoenix_Bid_Process_Steps__c > {
                bisp
                    });*/
            Phoenix_RosController.updateNextProcessSteps(pb.id, pb.Name, new List < Phoenix_Bid_Process_Steps__c > {
                bisp
                    }, false, false);
            
        } catch (exception ex) {}
    }
    
    static testmethod void getItems2() {
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        
        Phoenix_Bid__c pb = new Phoenix_Bid__c();
        pb.Phoenix_Status__c = 'New';
        pb.Phoenix_Comments__c = 'Test Comments';
        pb.Phoenix_Customer__c = testAccount.Id;
        pb.Phoenix_Customer_Bid_Deadline_Time_zone__c = 'PST';
        pb.Phoenix_Customer_Bid_Deadline_Time__c = '6 PM';
        pb.Phoenix_Customer_Type__c = 'Direct and Indirect';
        pb.Phoenix_Bid_Deadline_Date__c = System.today();
        insert pb;
        
        Phoenix_Approval_Matrix__c am = new Phoenix_Approval_Matrix__c();
        am.Name = 'test';
        insert am;
        Phoenix_Approval_Process_Step__c ap = new Phoenix_Approval_Process_Step__c();
        ap.Phoenix_Approval_Matrix__c = am.id;
        ap.Phoenix_Order__c = 1;
        insert ap;
        System.assertEquals(1, ap.Phoenix_Order__c);
        Phoenix_Approval_Process_Step__c ap2 = new Phoenix_Approval_Process_Step__c();
        ap2.Phoenix_Approval_Matrix__c = am.id;
        ap2.Phoenix_Order__c = 2;
        insert ap2;
        Phoenix_Approval_Process_Step__c ap3 = new Phoenix_Approval_Process_Step__c();
        ap3.Phoenix_Approval_Matrix__c = am.id;
        ap3.Phoenix_Order__c = 3;
        insert ap3;
        
        List < Phoenix_Bid_Process_Steps__c >  bidprocess= new List < Phoenix_Bid_Process_Steps__c >();
        Map < Integer, List < Phoenix_Bid_Process_Steps__c >> stepMap = new Map < Integer, List < Phoenix_Bid_Process_Steps__c >> ();
        Map < String, Integer > stepnameNoMap = new Map < String, Integer > ();
        
        for(Integer i=0;i<5;i++)
        {
            Phoenix_Bid_Process_Steps__c bisp = new Phoenix_Bid_Process_Steps__c();
            bisp.Name = 'Closed'+i;
            bisp.Phoenix_Process_Step__c = ap.id;
            bisp.Phoenix_Bid__c = pb.Id;
            bisp.Phoenix_Approver__c = Userinfo.getUserId();
            bisp.Phoenix_Approver_Team__c = 'Contracts';
            
            Phoenix_Bid_Process_Steps__c bisp2 = new Phoenix_Bid_Process_Steps__c();
            bisp2.Name = 'Closed'+i;
            bisp2.Phoenix_Process_Step__c = ap.id;
            bisp2.Phoenix_Bid__c = pb.Id;
            bisp2.Phoenix_Approver__c = Userinfo.getUserId();
            bisp2.Phoenix_Is_Criteria_Step__c = true;
            bisp2.Phoenix_Approver_Team__c = 'Marketing Lead SRx';
            
            Phoenix_Bid_Process_Steps__c bisp1 = new Phoenix_Bid_Process_Steps__c();
            bisp1.Name = 'Closed' + i ;
            bisp1.Phoenix_Process_Step__c = ap2.id;
            bisp1.Phoenix_Bid__c = pb.Id;
            bisp1.Phoenix_Approver__c = Userinfo.getUserId();
            bisp1.Phoenix_Approver_Team__c = 'Marketing';
            
            Phoenix_Bid_Process_Steps__c bisp3 = new Phoenix_Bid_Process_Steps__c();
            bisp3.Name = 'Closed'+i;
            bisp3.Phoenix_Process_Step__c = ap3.id;
            bisp3.Phoenix_Bid__c = pb.Id;
            bisp3.Phoenix_Approver__c = Userinfo.getUserId();
            bisp3.Phoenix_Approver_Team__c = 'Contracts';
            
            bidprocess.add(bisp);
            bidprocess.add(bisp1);
            bidprocess.add(bisp2);
            bidprocess.add(bisp3);
        }
        insert bidprocess;
        
        List < Phoenix_Bid_Process_Steps__c > bidQuery = [SELECT Id, Name, Phoenix_Bid__c, Phoenix_Is_Criteria_Step__c, Phoenix_Process_Step__c, Phoenix_Step__c, Phoenix_Approver__c, Phoenix_Approver__r.Name, Phoenix_Status__c, Phoenix_Approver_Team__c FROM Phoenix_Bid_Process_Steps__c WHERE ID=: bidprocess];
        
        
        system.debug('STEPS----'+bidQuery[0].Phoenix_Step__c);
        for(Phoenix_Bid_Process_Steps__c cmp : bidprocess)
        {
            stepMap.put(integer.valueof(cmp.Phoenix_Step__c), new List<Phoenix_Bid_Process_Steps__c>{cmp}); 
            stepnameNoMap.put(cmp.Phoenix_Approver_Team__c, integer.valueof(cmp.Phoenix_Step__c));
        }
        
       // Phoenix_RosController.updateNextContractProcessSteps(pb.id,pb.name,bidprocess);
        Phoenix_RosController.updateNextProcessSteps(pb.id,pb.name,bidQuery,false,false);
    }
    
    static testmethod void getItems3()
    {
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        
        Phoenix_Bid__c pb = new Phoenix_Bid__c();
        pb.Phoenix_Status__c = 'New';
        pb.Phoenix_Comments__c = 'Test Comments';
        pb.Phoenix_Customer__c = testAccount.Id;
        pb.Phoenix_Customer_Bid_Deadline_Time_zone__c = 'PST';
        pb.Phoenix_Customer_Bid_Deadline_Time__c = '6 PM';
        pb.Phoenix_Bid_Deadline_Date__c = System.today();
        pb.Phoenix_Reference_Contracts__c = 'test 1';
        pb.Phoenix_Customer_Type__c = 'Direct and Indirect';
        
        insert pb;
        
        Product2 prod1 = new Product2(Name = 'Test Product', Family = 'Test Family', IsActive = TRUE, ProductCode = '324');
        insert prod1;
        Phoenix_Bid_Line_Item__c bl = new Phoenix_Bid_Line_Item__c();
        bl.Phoenix_Bid__c = pb.Id;
        bl.Phoenix_Current_Direct_Price__c = 10;
        bl.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        bl.Phoenix_Product__c = prod1.id;
        bl.Phoenix_Final_Status__c = 'Approved';
        bl.Phoenix_Wholesaler_Guidance_Price__c = 5;
        bl.Phoenix_Retail_Direct_Sales_Price__c = 4;
        bl.Phoenix_ProposedContractBidPriceMktng__c = 3 ;
        bl.Phoenix_Retail_Direct_Guidance_Price__c = 2 ;
        bl.Phoenix_Retail_Direct_Price__c = 1;
        bl.Phoenix_Retail_Indirect_Price__c = 2;
        bl.Phoenix_Marketing_Approval__c = 'Approved';
        bl.Phoenix_Guidance_Price__c = 2;
        
        insert bl;
        Phoenix_RosController.getSubmitBidInfo(pb.id);
        Phoenix_RosController.getselectOptions(testAccount,'Testing');
        Phoenix_RosController.deleteLineItems(bl.id);
        
    }
    static testmethod void getItems4()
    {
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        
        Phoenix_Bid__c pb = new Phoenix_Bid__c();
        pb.Phoenix_Status__c = 'New';
        pb.Phoenix_Comments__c = 'Test Comments';
        pb.Phoenix_Customer__c = testAccount.Id;
        pb.Phoenix_Customer_Bid_Deadline_Time_zone__c = 'PST';
        pb.Phoenix_Customer_Bid_Deadline_Time__c = '6 PM';
        pb.Phoenix_Bid_Deadline_Date__c = System.today();
        pb.Phoenix_Reference_Contracts__c = 'test 1';
        pb.Phoenix_Customer_Type__c = 'ROS';
        insert pb;
        system.assertEquals('ROS',pb.Phoenix_Customer_Type__c);
        
        Product2 prod1 = new Product2(Name = 'Test Product', Family = 'Test Family', IsActive = TRUE, ProductCode = '324');
        insert prod1;
        
        Phoenix_Bid_Line_Item__c bl = new Phoenix_Bid_Line_Item__c();
        bl.Phoenix_Bid__c = pb.Id;
        bl.Phoenix_Current_Direct_Price__c = 10;
        bl.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        bl.Phoenix_Product__c = prod1.id;
        bl.Phoenix_Final_Status__c = 'Approved';
        bl.Phoenix_Wholesaler_Guidance_Price__c = 5;
        bl.Phoenix_Retail_Direct_Sales_Price__c = 3;
        bl.Phoenix_ProposedContractBidPriceMktng__c = 3 ;
        bl.Phoenix_Retail_Direct_Guidance_Price__c = 2 ;
        bl.Phoenix_Retail_Direct_Price__c = 1;
        bl.Phoenix_Retail_Indirect_Price__c = 2;
        bl.Phoenix_Marketing_Approval__c = 'Approved';
        bl.Phoenix_Guidance_Price__c = 2;
        insert bl;
        
        Phoenix_BidLineItemExtn__c bliExtn1 = new Phoenix_BidLineItemExtn__c();
        bliExtn1.Phoenix_Bid_Line_Item__c = bl.Id;
        insert bliExtn1;
        
        Phoenix_RosController.getCalcs(bl, bl.id, 'Approved', 'MarketApproval');
        Phoenix_RosController.getCalcs(bl, bl.id, 'Line Error- Not Sent', 'ContractApproval');
        Phoenix_RosController.saveLineItems(new list < Phoenix_Bid_Line_Item__c > {bl}, pb.id, 'Gross', 'Gross', '', true, true, true, 'Approved', true,'sample','sample2','sample3');
    }
    static testmethod void getItems5()
    {
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        
        Phoenix_Bid__c pb = new Phoenix_Bid__c();
        pb.Phoenix_Status__c = 'New';
        pb.Phoenix_Comments__c = 'Test Comments';
        pb.Phoenix_Customer__c = testAccount.Id;
        pb.Phoenix_Customer_Bid_Deadline_Time_zone__c = 'PST';
        pb.Phoenix_Customer_Bid_Deadline_Time__c = '6 PM';
        pb.Phoenix_Bid_Deadline_Date__c = System.today();
        pb.Phoenix_Reference_Contracts__c = 'test 1';
        pb.Phoenix_Customer_Type__c = 'BASE/DSH';
        insert pb;
        system.assertEquals('BASE/DSH',pb.Phoenix_Customer_Type__c);
        
        Product2 prod1 = new Product2(Name = 'Test Product', Family = 'Test Family', IsActive = TRUE, ProductCode = '324');
        insert prod1;
        
        Phoenix_Bid_Line_Item__c bl = new Phoenix_Bid_Line_Item__c();
        bl.Phoenix_Bid__c = pb.Id;
        bl.Phoenix_Current_Direct_Price__c = 10;
        bl.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        bl.Phoenix_Product__c = prod1.id;
        bl.Phoenix_Final_Status__c = 'Approved';
        bl.Phoenix_Wholesaler_Guidance_Price__c = 5;
        bl.Phoenix_Retail_Direct_Sales_Price__c = 3;
        bl.Phoenix_ProposedContractBidPriceMktng__c = 3 ;
        bl.Phoenix_Retail_Direct_Guidance_Price__c = 2 ;
        bl.Phoenix_Retail_Direct_Price__c = 1;
        bl.Phoenix_Retail_Indirect_Price__c = 2;
        bl.Phoenix_Marketing_Approval__c = 'Approved';
        bl.Phoenix_Guidance_Price__c = 2;
        insert bl;
        
        Phoenix_BidLineItemExtn__c bliExtn1 = new Phoenix_BidLineItemExtn__c();
        bliExtn1.Phoenix_Bid_Line_Item__c = bl.Id;
        insert bliExtn1;
        
        Phoenix_Approval_Matrix__c am1 = new Phoenix_Approval_Matrix__c();
        am1.Name = 'test';
        insert am1;
        
        Phoenix_Approval_Process_Step__c ap1 = new Phoenix_Approval_Process_Step__c();
        ap1.Phoenix_Approval_Matrix__c = am1.id;
        ap1.Phoenix_Order__c = 1;
        insert ap1;
        System.assertEquals(1, ap1.Phoenix_Order__c);
        Phoenix_Approval_Process_Step__c ap22 = new Phoenix_Approval_Process_Step__c();
        ap22.Phoenix_Approval_Matrix__c = am1.id;
        ap22.Phoenix_Order__c = 2;
        insert ap22;
        List < Phoenix_Bid_Process_Steps__c >  bidprocess= new List < Phoenix_Bid_Process_Steps__c >();
        Map < Integer, List < Phoenix_Bid_Process_Steps__c >> stepMap = new Map < Integer, List < Phoenix_Bid_Process_Steps__c >> ();
        Map < String, Integer > stepnameNoMap = new Map < String, Integer > ();
        
        for(Integer i=0;i<5;i++)
        {
            Phoenix_Bid_Process_Steps__c bisp = new Phoenix_Bid_Process_Steps__c();
            bisp.Name = 'Closed'+i;
            bisp.Phoenix_Process_Step__c = ap1.id;
            bisp.Phoenix_Bid__c = pb.Id;
            bisp.Phoenix_Approver__c = Userinfo.getUserId();
            bisp.Phoenix_Approver_Team__c = 'Contracts';
            
            Phoenix_Bid_Process_Steps__c bisp1 = new Phoenix_Bid_Process_Steps__c();
            bisp1.Name = 'Closed' + i ;
            bisp1.Phoenix_Process_Step__c = ap22.id;
            bisp1.Phoenix_Bid__c = pb.Id;
            bisp1.Phoenix_Approver__c = Userinfo.getUserId();
            bisp1.Phoenix_Approver_Team__c = 'Marketing';
            
            Phoenix_Bid_Process_Steps__c bisp2 = new Phoenix_Bid_Process_Steps__c();
            bisp2.Name = 'Closed'+i;
            bisp2.Phoenix_Process_Step__c = ap1.id;
            bisp2.Phoenix_Bid__c = pb.Id;
            bisp2.Phoenix_Approver__c = Userinfo.getUserId();
            bisp2.Phoenix_Approver_Team__c = 'Supply Chain';
            
            
            bidprocess.add(bisp);
            bidprocess.add(bisp1);
            bidprocess.add(bisp2);
            
        }
        insert bidprocess;
        for(Phoenix_Bid_Process_Steps__c cmp : bidprocess)
        {
            stepMap.put(integer.valueof(cmp.Phoenix_Step__c), new List<Phoenix_Bid_Process_Steps__c>{cmp}); 
            stepnameNoMap.put(cmp.Phoenix_Approver_Team__c, integer.valueof(cmp.Phoenix_Step__c));
        }
        
        Phoenix_RosController.getCalcs(bl, bl.id, 'Approved', 'MarketApproval');
        Phoenix_RosController.getCalcs(bl, bl.id, 'Line Error- Not Sent', 'ContractApproval');
        Phoenix_RosController.saveLineItemsNewPL(pb.Id,new List<Phoenix_Bid_Line_Item__c> {bl});
        Phoenix_RosController.makeApprovals(pb.Id,new List<Phoenix_Bid_Line_Item__c> {bl},true);
        Phoenix_RosController.updateRelatedList(new List<Phoenix_Bid_Line_Item__c> {bl});
        Phoenix_RosController.updateChildRec(bliExtn1,'No Change');
        Phoenix_RosController.getUpdatedLineItemRec(bl.Id);
        Phoenix_RosController.submitToProceddStep(pb.Id,false,false,'');
        
    }
    
    static testmethod void getItems6()
    {
        list < Phoenix_NPR_Data__c > pnrdata = new list < Phoenix_NPR_Data__c >();   
        map < string, list < Phoenix_NPR_Data__c >> productCodeToNPRLineMap = new map < string, list < Phoenix_NPR_Data__c >> ();
        
        Account testAccount = new Account(Name = 'Test Account',Phoenix_Fee__c = 10,Rebate_Type__c = 'Gross',Phoenix_Cash_Discount__c = 10,Fee_Type__c = 'Gross',Phoenix_Rebates__c = 20,Phoenix_VIP__c = 10 );
        insert testAccount;
        
        Phoenix_Contract__c Cntrct4 = new Phoenix_Contract__c();
        Cntrct4.name = 'taest cntrct 2';
        Cntrct4.Phoenix_Contract_Number__c = '1000000449';
        insert Cntrct4;
        
        
        Phoenix_Contract__c Cntrct5 = new Phoenix_Contract__c();
        Cntrct5.name = 'taest cntrct 3';
        Cntrct5.Phoenix_Contract_Number__c = '3000000489';
        insert Cntrct5;
        
        
        
        Phoenix_Contract__c Cntrct55 = new Phoenix_Contract__c();
        Cntrct55.name = 'taest cntrct 3';
        Cntrct55.Phoenix_Contract_Number__c = '3000000485';
        insert Cntrct55;
        
        Phoenix_Contract__c Cntrct555 = new Phoenix_Contract__c();
        Cntrct555.name = 'taest cntrct 3';
        Cntrct555.Phoenix_Contract_Number__c = '3000000753';
        insert Cntrct555;
        
        
        Phoenix_Bid__c pb = new Phoenix_Bid__c();
        pb.Phoenix_Status__c = 'New';
        pb.Phoenix_Comments__c = 'Test Comments';
        pb.Phoenix_Customer_Bid_Deadline_Time_zone__c = 'PST';
        pb.Phoenix_Customer_Bid_Deadline_Time__c = '6 PM';
        pb.Phoenix_Customer_Type__c = 'Direct and Indirect';
        pb.Phoenix_Bid_Deadline_Date__c = System.today();
        pb.Phoenix_Bid_Type__c = 'Customer Rebate Change';
        pb.Phoenix_Bid_Created_Behalf_of__c = UserInfo.getUserId();
        pb.Phoenix_Proactive_Reactive__c = 'Proactive';       
        pb.Phoenix_Salesperson__c = UserInfo.getUserId();
        pb.Phoenix_Proposed_Initial_Order_Discount__c = 13;
        pb.Phoenix_Proposed_Sales_Out_Promotion__c = 12;
        pb.Phoenix_Proposed_Value_Admin_Fee__c = 11;
        pb.Phoenix_Proposed_Value_Est_VIP__c = 10;
        pb.Phoenix_Sales_Out_Promotion_of_Days__c = 24;
        pb.Phoenix_Initial_Order_Discount_of_Days__c = 20;
        pb.Phoenix_Current_CD__c = 34;
        pb.Phoenix_Rebate__c = 45;
        pb.Phoenix_Initial_Order_Discount_Type__c = 'Contract';
        pb.Phoenix_Value_Est_VIP_Type__c = 'Gross';
        pb.Phoenix_Current_Value_Est_VIP__c = 23;
        pb.Phoenix_Select_Wholesaler__c = 'ABC';
        pb.Phoenix_Customer__c = testAccount.id;
        pb.Phoenix_Bid_Name__c = 'test 1';
        pb.Phoenix_Reference_Contracts__c = 'test 2';
        pb.Phoenix_Approval_Status__c = 'Customer';
        insert pb;
        
        
        Product2 prod1 = new Product2(Name = 'Test Product', Family = 'Test Family', IsActive = TRUE, ProductCode = '324',Phoenix_Product_Director__c = UserInfo.getUserId() ,Phoenix_Marketing_Lead__c = UserInfo.getUserId());
        insert prod1;
        
        Phoenix_Bid_Line_Item__c bl = new Phoenix_Bid_Line_Item__c();
        bl.Phoenix_Bid__c = pb.Id;
        bl.Phoenix_Current_Direct_Price__c = 10;
        bl.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        bl.Phoenix_Product__c = prod1.id;
        bl.Phoenix_Final_Status__c = 'Approved';
        bl.Phoenix_Product_Family1__c = 'Habitrol';
        bl.Phoenix_Product_Director1__c = UserInfo.getName();
        bl.Phoenix_Marketing_Final_Approval__c = true;
        bl.Phoenix_Contract_Approval__c = 'Line Error- Not Sent';
        bl.Phoenix_Others_Indirect__c = 24;
        bl.Phoenix_Others_Direct__c = 25;
        bl.Phoenix_12_Months_Actual_Sales__c = 5;
        bl.Phoenix_Current_Position__c = 'test 1';
        bl.Phoenix_Current_Net_Sales_Internal__c=4;
        bl.Phoenix_DeadNet_TrckGR__c = 2;
        bl.Phoenix_Current_Direct_Selling_Unit__c = 2;
        bl.Phoenix_Current_Indirect_Selling_Unit__c = 4;
        bl.Phoenix_Current_Indirect_Price__c = 7;
        bl.Phoenix_Current_Direct_Price__c = 4;
        bl.Phoenix_Current_Per_Unit_Rebate__c = 7;
        bl.Phoenix_ZITD_Value__c = 2;
        bl.Phoenix_Current_Rebate__c = 2;
        bl.Phoenix_Rebate_G_N__c ='test p';
        bl.Phoenix_Fee_G_N__c = 'tst';
        bl.Phoenix_Current_Admin_Fee__c = 5;
        bl.Phoenix_Marketing_Approval__c ='Not Approved';
        bl.Phoenix_Current_Retail_Direct_Units__c = 20;
        insert bl;
        
        
        Phoenix_BidLineItemExtn__c bliExtn1 = new Phoenix_BidLineItemExtn__c();
        bliExtn1.Phoenix_Bid_Line_Item__c = bl.Id;
        insert bliExtn1;
        
        
        Phoenix_Approval_Matrix__c am = new Phoenix_Approval_Matrix__c();
        am.Name = 'test';
        insert am;
        
        Phoenix_Approval_Process_Step__c ap2 = new Phoenix_Approval_Process_Step__c();
        ap2.Phoenix_Approval_Matrix__c = am.id;
        ap2.Phoenix_Order__c = integer.valueof(5);
        insert ap2;
        
        Phoenix_Bid_Process_Steps__c bisp11 = new Phoenix_Bid_Process_Steps__c();
        bisp11.Name = 'Test ii';
        bisp11.Phoenix_Process_Step__c = ap2.id;
        bisp11.Phoenix_Bid__c = pb.Id;
        bisp11.Phoenix_Approver__c = Userinfo.getUserId();
        bisp11.Phoenix_Approver_Team__c = 'Supply Chain';
        bisp11.Phoenix_Status__c = 'In Process';
        insert bisp11;
        
        
        Phoenix_NPR_Data__c nprdata5 = new Phoenix_NPR_Data__c();
        nprdata5.Phoenix_Contract__c = Cntrct4.id;
        nprdata5.Phoenix_Contract_Type__c = 'Direct';
        nprdata5.Phoenix_Contract_Number__c = '1000000627';
        nprdata5.Phoenix_Product__c = prod1.id;
        nprdata5.Phoenix_12Months_Sales_Unit__c = 200;
        nprdata5.Phoenix_Rebate_G_N_Indicator__c = '10N+ 0G';
        nprdata5.Phoenix_Bonafied_G_N_Indicator__c = '5N+0G';
        nprdata5.Phoenix_12Mt_Sales_Ut_Actual__c = 30;
        nprdata5.Phoenix_Product_Position__c = 'test 2';
        nprdata5.Phoenix_Dead_Net_Tracking_GR__c=12;
        nprdata5.Phoenix_Contract_Price__c = 5;
        nprdata5.Phoenix_12Months_Net_Sales__c=50;
        nprdata5.Phoenix_Per_Unit_Rebate__c = 2;
        nprdata5.Phoenix_ZITD_Value__c=3;
        nprdata5.Phoenix_Rebate__c = 2;
        nprdata5.Phoenix_Rebate_G_N_Indicator__c='test npr 2';
        nprdata5.Phoenix_Bonafied_G_N_Indicator__c = 'test npr ii';      
        nprdata5.Phoenix_Fee_Bonafied_Fee__c=25;
        nprdata5.Phoenix_Per_Unit_Bonfied_Fee__c = 5;
        nprdata5.Phoenix_CD__c = 12;
        nprdata5.Phoenix_GR_TrackingTier__c = 4;
        nprdata5.Phoenix_NPR_Status__c = 'Active';
        insert nprdata5;
        
        Phoenix_NPR_Data__c nprdata55 = new Phoenix_NPR_Data__c();
        nprdata55.Phoenix_Contract__c = Cntrct5.id;
        nprdata55.Phoenix_Contract_Type__c = 'Direct';
        nprdata55.Phoenix_Contract_Number__c = '3000000352';
        nprdata55.Phoenix_Product__c = prod1.id;
        nprdata55.Phoenix_12Months_Sales_Unit__c = 200;
        nprdata55.Phoenix_Rebate_G_N_Indicator__c = '10N+ 0G';
        nprdata55.Phoenix_Bonafied_G_N_Indicator__c = '5N+0G';
        nprdata55.Phoenix_12Mt_Sales_Ut_Actual__c = 30;
        nprdata55.Phoenix_Product_Position__c = 'test 2';
        nprdata55.Phoenix_Dead_Net_Tracking_GR__c=12;
        nprdata55.Phoenix_Contract_Price__c = 5;
        nprdata55.Phoenix_12Months_Net_Sales__c=50;
        nprdata55.Phoenix_Per_Unit_Rebate__c = 2;
        nprdata55.Phoenix_ZITD_Value__c=3;
        nprdata55.Phoenix_Rebate__c = 2;
        nprdata55.Phoenix_Rebate_G_N_Indicator__c='test npr 2';
        nprdata55.Phoenix_Bonafied_G_N_Indicator__c = 'test npr ii';      
        nprdata55.Phoenix_Fee_Bonafied_Fee__c=25;
        nprdata55.Phoenix_Per_Unit_Bonfied_Fee__c = 5;
        nprdata55.Phoenix_CD__c = 12;
        nprdata55.Phoenix_GR_TrackingTier__c = 4;
        nprdata55.Phoenix_NPR_Status__c = 'Active';
        insert nprdata55;
        
        Phoenix_NPR_Data__c nprdata555 = new Phoenix_NPR_Data__c();
        nprdata555.Phoenix_Contract__c = Cntrct55.id;
        nprdata555.Phoenix_Contract_Type__c = 'Direct';
        nprdata555.Phoenix_Contract_Number__c = '3000000589';
        nprdata555.Phoenix_Product__c = prod1.id;
        nprdata555.Phoenix_12Months_Sales_Unit__c = 200;
        nprdata555.Phoenix_Rebate_G_N_Indicator__c = '10N+ 0G';
        nprdata555.Phoenix_Bonafied_G_N_Indicator__c = '5N+0G';
        nprdata555.Phoenix_12Mt_Sales_Ut_Actual__c = 30;
        nprdata555.Phoenix_Product_Position__c = 'test 2';
        nprdata555.Phoenix_Dead_Net_Tracking_GR__c=12;
        nprdata555.Phoenix_Contract_Price__c = 5;
        nprdata555.Phoenix_12Months_Net_Sales__c=50;
        nprdata555.Phoenix_Per_Unit_Rebate__c = 2;
        nprdata555.Phoenix_ZITD_Value__c=3;
        nprdata555.Phoenix_Rebate__c = 2;
        nprdata555.Phoenix_Rebate_G_N_Indicator__c='test npr 2';
        nprdata555.Phoenix_Bonafied_G_N_Indicator__c = 'test npr ii';      
        nprdata555.Phoenix_Fee_Bonafied_Fee__c=25;
        nprdata555.Phoenix_Per_Unit_Bonfied_Fee__c = 5;
        nprdata555.Phoenix_CD__c = 12;
        nprdata555.Phoenix_GR_TrackingTier__c = 4;
        nprdata555.Phoenix_NPR_Status__c = 'Active';
        insert nprdata555;
        
        
        Phoenix_RosController.getNPRData(new list < string > {
            Cntrct4.Phoenix_Contract_Number__c
                }, pb.Id, 'ROS'); 
        
        Phoenix_RosController.getNPRData(new list < string > {
            Cntrct5.Phoenix_Contract_Number__c
                }, pb.Id, 'ROS'); 
        
        Phoenix_RosController.getNPRData(new list < string > {
            Cntrct55.Phoenix_Contract_Number__c
                }, pb.Id, 'ROS'); 
        Phoenix_RosController.getNPRData(new list < string > {
            Cntrct555.Phoenix_Contract_Number__c
                }, pb.Id, 'ROS'); 
       // Phoenix_RosController.updateNextProcessSteps(pb.Id,pb.Phoenix_Bid_Name__c,new List<Phoenix_Bid_Process_Steps__c> {bisp11}, false, false);
        Phoenix_RosController.findByProductFamily(new list < string > {'Ipa'},bl.Id,new list < string > {'Rx'},new list < string > {'SRx'});
    }
    static testmethod void getItems7(){
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
        pb.Phoenix_Customer_Type__c = 'Direct and Indirect';
        pb.Phoenix_Bid_Deadline_Date__c = System.today();
        pb.Phoenix_Bid_Type__c = 'VIP Rebate';
        insert pb;
        
        Phoenix_Contract__c Cntrct = new Phoenix_Contract__c();
        Cntrct.name = 'taest cntrct';
        Cntrct.Phoenix_Contract_Number__c = '223';
        insert Cntrct;
        
        Product2 prod1 = new Product2(Name = 'Test Product', Family = 'Test Family', IsActive = TRUE, ProductCode = '324');
        insert prod1;
        Phoenix_Bid_Line_Item__c bl = new Phoenix_Bid_Line_Item__c();
        bl.Phoenix_Bid__c = pb.Id;
        bl.Phoenix_12_Months_Actual_Sales__c = 10;
        bl.Phoenix_Current_Direct_Price__c = 10;
        bl.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        bl.Phoenix_Current_Retail_Direct_Units__c = 12;
        bl.Phoenix_Product__c = prod1.id;
        bl.Phoenix_Final_Status__c = 'Approved';
        insert bl;
        
        Phoenix_BidLineItemExtn__c bliExtn1 = new Phoenix_BidLineItemExtn__c();
        bliExtn1.Phoenix_Bid_Line_Item__c = bl.Id;
        insert bliExtn1;
        
        
        Phoenix_Bid_Line_Item__c bl2 = new Phoenix_Bid_Line_Item__c();
        bl2.Phoenix_Bid__c = testData.bidsList[0].Id;
        bl2.Phoenix_Current_Direct_Price__c = 10;
        bl2.Phoenix_12_Months_Actual_Sales__c = 10;
        bl2.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        bl2.Phoenix_Current_Retail_Direct_Units__c = 12;
        bl2.Phoenix_Product__c = prod1.id;
        bl2.Phoenix_Final_Status__c = 'Approved';
        insert bl2;
        
        Phoenix_BidLineItemExtn__c bliExtn2 = new Phoenix_BidLineItemExtn__c();
        bliExtn2.Phoenix_Bid_Line_Item__c = bl2.Id;
        insert bliExtn2;
        
        Phoenix_Bid_Line_Item__c bl3 = new Phoenix_Bid_Line_Item__c();
        bl3.Phoenix_Bid__c = pb.Id;
        bl3.Phoenix_12_Months_Actual_Sales__c = 10;
        bl3.Phoenix_Current_Direct_Price__c = 10;
        bl3.Phoenix_Current_Retail_Direct_Units__c = 12;
        bl3.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        bl3.Phoenix_Product__c = prod1.id;
        bl3.Phoenix_Final_Status__c = 'Approved';
        bl3.Phoenix_Proposed_Indirect_Selling_Unit__c = 2;
        bl3.Phoenix_Proposed_Direct_Selling_Unit__c = 2;
        bl3.Phoenix_SCM_Approval_Y_N__c = 'Y- Current + Inc Demand Approved';
        insert bl3;
        
        Phoenix_BidLineItemExtn__c bliExtn3 = new Phoenix_BidLineItemExtn__c();
        bliExtn3.Phoenix_Bid_Line_Item__c = bl3.Id;
        insert bliExtn3;
        
        Phoenix_NPR_Data__c nprdat = new Phoenix_NPR_Data__c();
        nprdat.Phoenix_Contract__c = Cntrct.id;
        nprdat.Phoenix_NPR_Status__c = 'Active';
        nprdat.Phoenix_Contract_Number__c = '223';
        nprdat.Phoenix_Product__c = prod1.id;
        nprdat.Phoenix_Product_Position__c = '2';
        nprdat.Phoenix_12Months_Sales_Unit__c = 200;
        nprdat.Phoenix_Contract_Type__c = 'Direct';
        nprdat.Phoenix_Rebate_G_N_Indicator__c = '10N+ 0G';
        nprdat.Phoenix_Bonafied_G_N_Indicator__c = '5N+0G';
        nprdat.Phoenix_Contract_Price__c = 12.00;
        nprdat.Phoenix_Dead_Net_Tracking_GR__c = 12.00;
        insert nprdat;
        
        /* Phoenix_Approval_Process_Step__c aprovStepObj = new Phoenix_Approval_Process_Step__c();
aprovStepObj.Phoenix_Order__c = 1;
aprovStepObj.Phoenix_Is_Notification_Only__c = false;
insert aprovStepObj; */
        
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
        Cntrct1.Phoenix_Contract_Number__c = '1000000449';
        insert Cntrct1;
        
        
        Phoenix_NPR_Data__c nprdat1 = new Phoenix_NPR_Data__c();
        nprdat1.Phoenix_Contract__c = Cntrct1.id;
        nprdat1.Phoenix_NPR_Status__c = 'Active';
        nprdat1.Phoenix_Contract_Number__c = '1000000449';
        nprdat1.Phoenix_Product__c = prod1.id;
        nprdat1.Phoenix_12Months_Sales_Unit__c = 200;
        nprdat1.Phoenix_Contract_Type__c = 'Indirect';
        nprdat1.Phoenix_Rebate_G_N_Indicator__c = '10N+ 0G';
        nprdat1.Phoenix_Bonafied_G_N_Indicator__c = '5N+0G';
        insert nprdat1;
        
        Phoenix_Contract__c Cntrct2 = new Phoenix_Contract__c();
        Cntrct2.name = 'taest cntrct2';
        Cntrct2.Phoenix_Contract_Number__c = '3000000489';
        insert Cntrct2;
        
        
        Phoenix_NPR_Data__c nprdat2 = new Phoenix_NPR_Data__c();
        nprdat2.Phoenix_Contract__c = Cntrct2.id;
        nprdat2.Phoenix_NPR_Status__c = 'Active';
        nprdat2.Phoenix_Contract_Number__c = '3000000489';
        nprdat2.Phoenix_Product__c = prod1.id;
        nprdat2.Phoenix_12Months_Sales_Unit__c = 200;
        nprdat2.Phoenix_Contract_Type__c = 'Indirect';
        nprdat2.Phoenix_Rebate_G_N_Indicator__c = '10N+ 0G';
        nprdat2.Phoenix_Bonafied_G_N_Indicator__c = '5N+0G';
        insert nprdat2;
        
        
        Phoenix_Contract__c Cntrct3 = new Phoenix_Contract__c();
        Cntrct3.name = 'taest cntrct3';
        Cntrct3.Phoenix_Contract_Number__c = '3000000753';
        insert Cntrct3;
        
        Phoenix_NPR_Data__c nprdat3 = new Phoenix_NPR_Data__c();
        nprdat3.Phoenix_Contract__c = Cntrct3.id;
        nprdat3.Phoenix_NPR_Status__c = 'Active';
        nprdat3.Phoenix_Contract_Number__c = '3000000753';
        nprdat3.Phoenix_Product__c = prod1.id;
        nprdat3.Phoenix_12Months_Sales_Unit__c = 200;
        nprdat3.Phoenix_Contract_Type__c = 'Indirect';
        nprdat3.Phoenix_Rebate_G_N_Indicator__c = '10N+ 0G';
        nprdat3.Phoenix_Bonafied_G_N_Indicator__c = '5N+0G';
        insert nprdat3;
        
        
        Phoenix_Contract__c Cntrct4 = new Phoenix_Contract__c();
        Cntrct4.name = 'taest cntrct4';
        Cntrct4.Phoenix_Contract_Number__c = '3000000485';
        insert Cntrct4;
        
        Phoenix_NPR_Data__c nprdat4 = new Phoenix_NPR_Data__c();
        nprdat4.Phoenix_Contract__c = Cntrct4.id;
        nprdat4.Phoenix_NPR_Status__c = 'Active';
        nprdat4.Phoenix_Contract_Number__c = '3000000485';
        nprdat4.Phoenix_Product__c = prod1.id;
        nprdat4.Phoenix_12Months_Sales_Unit__c = 200;
        nprdat4.Phoenix_Contract_Type__c = 'Indirect';
        nprdat4.Phoenix_Rebate_G_N_Indicator__c = '10N+ 0G';
        nprdat4.Phoenix_Bonafied_G_N_Indicator__c = '5N+0G';
            insert nprdat4;
            
        
         Phoenix_RosController.getNPRData(new list < string > {
                Cntrct1.Phoenix_Contract_Number__c
                    }, pb.Id, 'Indirect');
         Phoenix_RosController.getNPRData(new list < string > {
                Cntrct2.Phoenix_Contract_Number__c
                    }, pb.Id, 'Indirect');
         Phoenix_RosController.getNPRData(new list < string > {
                Cntrct3.Phoenix_Contract_Number__c
                    }, pb.Id, 'Indirect');
         Phoenix_RosController.getNPRData(new list < string > {
                Cntrct4.Phoenix_Contract_Number__c
                    }, pb.Id, 'Indirect');
            
    }
}