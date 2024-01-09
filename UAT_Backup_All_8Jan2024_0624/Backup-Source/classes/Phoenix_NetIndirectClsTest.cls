@isTest
public class Phoenix_NetIndirectClsTest {
    /**
* @description       : 
* @author            : Ashok Alli (Dhruvsoft)
* @group             : 
* @last modified on  : 05-06-2021
* @last modified by  : Ashok Alli (Dhruvsoft)
* Modifications Log 
* Ver   Date         Author                       Modification
* 1.0   04-06-2021   Ashok Alli (Dhruvsoft)   Initial Version
**/
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
            bl.Phoenix_Current_Direct_Price__c = 10;
            bl.Phoenix_Current_Indirect_Selling_Unit__c = 10;
            bl.Phoenix_Product__c = prod1.id;
            bl.Phoenix_Final_Status__c = 'Approved';
            insert bl;
            
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
            Phoenix_NetIndirectCls.getReBidLineInfo(prod1.Id, pb.id);
            Phoenix_NetIndirectCls.getRelatedList(pb.id);
            Phoenix_NetIndirectCls.getAllTotals(pb.id);
            Phoenix_NetIndirectCls.getupdatedforExport(pb.id);
            Phoenix_NetIndirectCls.getContracts(testAccount.Id, 'a');
            
            Phoenix_NetIndirectCls.getNPRData(new list < string > {
                Cntrct.Phoenix_Contract_Number__c
                    }, pb.Id, 'Net Indirect Pricing');
            Phoenix_NetIndirectCls.getNPRData(new list < string > {
                Cntrct.Phoenix_Contract_Number__c
                    }, pb.Id, 'Net Indirect Pricing');
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
            
            /* Phoenix_NetIndirectCls.getNPRDataRXSS(new list < string > {
Cntrct1.Phoenix_Contract_Number__c
}, pb.Id, 'Net Indirect Pricing');*/
            
            Phoenix_NetIndirectCls.updateRelatedList(new list < Phoenix_Bid_Line_Item__c > {
                bl
                    });
            Phoenix_NetIndirectCls.findByProductFamily(new list < string > {
                'lev'
                    }, pb.Id, new list < string > {
                        'Rx'
                            }, new list < string > {
                                ''
                                    });
            
            Phoenix_NetIndirectCls.getCalcs(bl, bl.id, 'No Change', 'rebateType');
            Phoenix_NetIndirectCls.getPositions(testAccount.ID);
            Phoenix_NetIndirectCls.saveLineItems(new list < Phoenix_Bid_Line_Item__c > {
                bl,
                    bl3
                    }, pb.id, 'Gross', 'Gross', '', true, true, true, 'Approved', true,'TEST',2.5,true);
            Phoenix_NetIndirectCls.saveLineItemsNewPL(pb.id,new list < Phoenix_Bid_Line_Item__c > {
                bl,
                    bl3
                    });

            
            Phoenix_NetIndirectCls.makeApprovals(pb.id, new List < Phoenix_Bid_Line_Item__c > {
                bl
                    }, true);
            Phoenix_NetIndirectCls.getSubmitBidInfo(pb.Id);
            Phoenix_NetIndirectCls.submitToProceddStep(pb.id, false,false,'');
            /* Phoenix_NetIndirectCls.updateNextContractProcessSteps(pb.Id, pb.Name, new List < Phoenix_Bid_Process_Steps__c > {
bisp
});*/
            Phoenix_NetIndirectCls.updateNextProcessSteps(pb.id, pb.Name, new List < Phoenix_Bid_Process_Steps__c > {
                bisp
                    }, false, false);
            Phoenix_NetIndirectCls.deleteLineItems( bl.ID);
            
        } catch (exception ex) {}
        
        
    }
    
    
    static testmethod void getItems2() {
        
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        
        
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
        bl.Phoenix_Marketing_Approval__c = 'Approved';
        bl.Phoenix_Contract_Approval__c = 'Line Error- Not Sent';
        insert bl;
        
        Phoenix_Bid_Line_Item__c bidline = [select id, name, Phoenix_Bid__r.Phoenix_Rebate__c, Phoenix_Bid__c, Phoenix_Bid__r.Phoenix_Bid_Type__c, Phoenix_Product_Director1__c, Phoenix_Marketing_Approval__c from Phoenix_Bid_Line_Item__c where id =: bl.id];
        Phoenix_NetIndirectCls.getSubmitBidInfo(pb.Id);
        Phoenix_NetIndirectCls.getRelatedList(pb.id);
        Phoenix_NetIndirectCls.saveLineItems(new list < Phoenix_Bid_Line_Item__c > {
            bidline
                }, pb.id, 'Gross', 'Gross', 'Line Error- Not Sent',true, true, true,'Approved',true,'Line Error- Not Sent',2.5,true);
        Phoenix_NetIndirectCls.getselectOptions(testAccount,'Testing');
        Phoenix_NetIndirectCls.deleteLineItems(bidline.id);
        //    Phoenix_NetIndirectCls.getCalcs(bl, bl.id, 'test', 'rebateType');
        
        
    }
    
    static testmethod void getItems3() {
        
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        
        Phoenix_Contract__c Cntrct = new Phoenix_Contract__c();
        Cntrct.name = 'taest cntrct';
        Cntrct.Phoenix_Contract_Number__c = '223';
        insert Cntrct;
        
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
        bl.Phoenix_ProposedContractBidPriceMktng__c = 24;
        bl.Phoenix_Guidance_Price__c = 34;
        insert bl;
        
        
        
        Phoenix_Approval_Matrix__c am = new Phoenix_Approval_Matrix__c();
        am.Name = 'test';
        insert am;
        
        Phoenix_Approval_Process_Step__c ap2 = new Phoenix_Approval_Process_Step__c();
        ap2.Phoenix_Approval_Matrix__c = am.id;
        ap2.Phoenix_Order__c = 2;
        insert ap2;
        
        
        
        Phoenix_Bid_Line_Item__c bidline = [select id, Phoenix_Rebate_G_N__c, Phoenix_Fee_G_N__c, Phoenix_Contract_Approval__c,Phoenix_ProposedContractBidPriceMktng__c,Phoenix_Guidance_Price__c from Phoenix_Bid_Line_Item__c where id =: bl.id];
        Phoenix_NetIndirectCls.getCalcs(bidline, bidline.id, 'test 2', 'feeType');
        Phoenix_NetIndirectCls.getCalcs(bidline, bidline.id, 'Approved', 'MarketApproval');
        Phoenix_NetIndirectCls.getCalcs(bidline, bidline.id, 'Line Error- Not Sent', 'ContractApproval');
        
    }
    
    static testmethod void getItems4() {
        list < Phoenix_NPR_Data__c > pnrdata = new list < Phoenix_NPR_Data__c >();   
        map < string, list < Phoenix_NPR_Data__c >> productCodeToNPRLineMap = new map < string, list < Phoenix_NPR_Data__c >> ();
        
        Account testAccount = new Account(Name = 'Test Account',Phoenix_Fee__c = 10,Rebate_Type__c = 'Gross',Phoenix_Cash_Discount__c = 10,Fee_Type__c = 'Gross',Phoenix_Rebates__c = 20,Phoenix_VIP__c = 10 );
        insert testAccount;
        
        Phoenix_Contract__c Cntrct = new Phoenix_Contract__c();
        Cntrct.name = 'taest cntrct';
        Cntrct.Phoenix_Contract_Number__c = '223';
        insert Cntrct;
        
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
        insert bl;
        
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
        
        for(integer i = 0 ; i < 5 ; i++)
        {
            phoenix_NPR_Data__c nprdat = new Phoenix_NPR_Data__c();
            nprdat.Phoenix_Contract__c = Cntrct.id;
            nprdat.Phoenix_Contract_Number__c = '223';
            nprdat.Phoenix_Product__c = prod1.id;
            nprdat.Phoenix_12Months_Sales_Unit__c = 200;
            nprdat.Phoenix_Contract_Type__c = 'Direct';
            nprdat.Phoenix_Rebate_G_N_Indicator__c = '10N+ 0G';
            nprdat.Phoenix_Bonafied_G_N_Indicator__c = '5N+0G';
            nprdat.Phoenix_12Mt_Sales_Ut_Actual__c = 30;
            nprdat.Phoenix_Product_Position__c = 'test 1';
            nprdat.Phoenix_Dead_Net_Tracking_GR__c=12;
            nprdat.Phoenix_Contract_Price__c = 5;
            nprdat.Phoenix_12Months_Net_Sales__c=50;
            nprdat.Phoenix_Per_Unit_Rebate__c = 2;
            nprdat.Phoenix_ZITD_Value__c = 3 ;
            nprdat.Phoenix_Rebate__c = 2;
            nprdat.Phoenix_Rebate_G_N_Indicator__c='test npr 1';
            nprdat.Phoenix_Bonafied_G_N_Indicator__c = 'test npr i';   
            nprdat.Phoenix_Fee_Bonafied_Fee__c=25;
            nprdat.Phoenix_Per_Unit_Bonfied_Fee__c = 5;
            nprdat.Phoenix_CD__c = 12;
            nprdat.Phoenix_GR_TrackingTier__c = 4;
            nprdat.Phoenix_NPR_Status__c = 'Active';
            
            pnrdata.add(nprdat);
            
            Phoenix_NPR_Data__c nprdata = new Phoenix_NPR_Data__c();
            nprdata.Phoenix_Contract__c = Cntrct.id;
            nprdata.Phoenix_Contract_Number__c = '223';
            nprdata.Phoenix_Product__c = prod1.id;
            nprdata.Phoenix_12Months_Sales_Unit__c = 200;
            nprdata.Phoenix_Contract_Type__c = 'Indirect';
            nprdata.Phoenix_Rebate_G_N_Indicator__c = '10N+ 0G';
            nprdata.Phoenix_Bonafied_G_N_Indicator__c = '5N+0G';
            nprdata.Phoenix_12Mt_Sales_Ut_Actual__c = 30;
            nprdata.Phoenix_Product_Position__c = 'test 2';
            nprdata.Phoenix_Dead_Net_Tracking_GR__c=12;
            nprdata.Phoenix_Contract_Price__c = 5;
            nprdata.Phoenix_12Months_Net_Sales__c=50;
            nprdata.Phoenix_Per_Unit_Rebate__c = 2;
            nprdata.Phoenix_ZITD_Value__c=3;
            nprdata.Phoenix_Rebate__c = 2;
            nprdata.Phoenix_Rebate_G_N_Indicator__c='test npr 2';
            nprdata.Phoenix_Bonafied_G_N_Indicator__c = 'test npr ii';      
            nprdata.Phoenix_Fee_Bonafied_Fee__c=25;
            nprdata.Phoenix_Per_Unit_Bonfied_Fee__c = 5;
            nprdata.Phoenix_CD__c = 12;
            nprdata.Phoenix_GR_TrackingTier__c = 4;
            nprdata.Phoenix_NPR_Status__c = 'Active';
            pnrdata.add(nprdata);
        }
        insert pnrdata;
        Phoenix_NetIndirectCls.getPositions(testAccount.ID);
        
        Phoenix_NetIndirectCls.getNPRData(new list < string > {
            Cntrct.Phoenix_Contract_Number__c
                }, pb.Id, 'Net Indirect Pricing');  
        
        Phoenix_NetIndirectCls.submitToProceddStep(pb.id, false,false,'');
        Phoenix_NetIndirectCls.makeApprovals(pb.id, new list < Phoenix_Bid_Line_Item__c > {
            bl
                }, true);
    }
    
    static testmethod void getItems5()
    {
        list < Phoenix_Bid_Process_Steps__c > marketStepLsit = new list < Phoenix_Bid_Process_Steps__c > ();
        
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        
        Phoenix_Contract__c Cntrct = new Phoenix_Contract__c();
        Cntrct.name = 'taest cntrct';
        Cntrct.Phoenix_Contract_Number__c = '223';
        insert Cntrct;
        
        Phoenix_Bid__c pb = new Phoenix_Bid__c();
        pb.Phoenix_Status__c = 'New';
        pb.Phoenix_Comments__c = 'Test Comments';
        pb.Phoenix_Customer__c = testAccount.Id;
        pb.Phoenix_Customer_Bid_Deadline_Time_zone__c = 'PST';
        pb.Phoenix_Customer_Bid_Deadline_Time__c = '6 PM';
        pb.Phoenix_Customer_Type__c = 'Direct and Indirect';
        pb.Phoenix_Bid_Deadline_Date__c = System.today();
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
        
        insert bl;
        
        Phoenix_Approval_Matrix__c am = new Phoenix_Approval_Matrix__c();
        am.Name = 'test';
        insert am;
        
        Phoenix_Approval_Process_Step__c ap2 = new Phoenix_Approval_Process_Step__c();
        ap2.Phoenix_Approval_Matrix__c = am.id;
        ap2.Phoenix_Order__c = integer.valueof(2);
        insert ap2;
        
        
        Phoenix_Bid_Process_Steps__c bisp11 = new Phoenix_Bid_Process_Steps__c();
        bisp11.Name = 'Test ii';
        bisp11.Phoenix_Process_Step__c = ap2.id;
        bisp11.Phoenix_Bid__c = pb.Id;
        bisp11.Phoenix_Approver__c = Userinfo.getUserId();
        bisp11.Phoenix_Approver_Team__c = 'Supply Chain';
        bisp11.Phoenix_Status__c = 'Submitted';
        insert bisp11;
        
        Phoenix_Bid_Process_Steps__c bisp111 = new Phoenix_Bid_Process_Steps__c();
        bisp111.Name = 'Test ii';
        bisp111.Phoenix_Process_Step__c = ap2.id;
        bisp111.Phoenix_Bid__c = pb.Id;
        bisp111.Phoenix_Approver__c = Userinfo.getUserId();
        bisp111.Phoenix_Approver_Team__c = 'Marketing';
        bisp111.Phoenix_Status__c = 'In Process';
        insert bisp111;
        
       
        
        Phoenix_Bid_Line_Item__c bidline = [select id, Phoenix_Rebate_G_N__c,Phoenix_Product_Director1__c, Phoenix_Fee_G_N__c, Phoenix_Marketing_Approval__c from Phoenix_Bid_Line_Item__c where id =: bl.id];
        Phoenix_NetIndirectCls.makeApprovals(pb.id, new list < Phoenix_Bid_Line_Item__c > {
            bidline
                }, true);
        
    }
    
}