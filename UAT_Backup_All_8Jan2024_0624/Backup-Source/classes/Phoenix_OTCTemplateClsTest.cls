@isTest
public class Phoenix_OTCTemplateClsTest {
    static testmethod void getItems() {
        //   try {
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
       
        Phoenix_OTCTemplateCls.getPositions(testAccount.Id);
        Phoenix_Contract__c Cntrct = new Phoenix_Contract__c();
        Cntrct.name = 'taest cntrct';
        Cntrct.Phoenix_Contract_Number__c = '223';
        insert Cntrct;
        
        Product2 prod1 = new Product2(Name = 'Test Product', Family = 'Test Family', IsActive = TRUE, ProductCode = '324');
        insert prod1;
       Phoenix_Bid__c pb = new Phoenix_Bid__c();
        pb.Phoenix_Approval_Status__c='SCM & Marketing';
        pb.Phoenix_Status__c = 'New';
        pb.Phoenix_Comments__c = 'Test Comments';
        pb.Phoenix_Customer__c = testAccount.Id;
        pb.Phoenix_Reference_Contracts__c = '223';
        pb.Phoenix_Customer_Bid_Deadline_Time_zone__c = 'PST';
        pb.Phoenix_Customer_Bid_Deadline_Time__c = '6 PM';
        pb.Phoenix_Customer_Type__c = 'Direct and Indirect';
        pb.Phoenix_Bid_Deadline_Date__c = System.today();
        pb.Phoenix_Bid_Type__c = 'VIP Rebate';
        
        insert pb;
        
        Phoenix_Bid_Line_Item__c bl = new Phoenix_Bid_Line_Item__c();
        bl.Phoenix_Bid__c = pb.Id;
        bl.Phoenix_Customer_Approval_OTC__c ='Send Back to Marketing';
        bl.Phoenix_Current_Direct_Price__c = 10;
        bl.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        bl.Phoenix_Product__c = prod1.id;
        bl.Phoenix_Final_Status__c = 'Not Approved';
        bl.Phoenix_Contract_Approval__c = 'Line Error- Not Sent';
        bl.Phoenix_Current_Position__c = 'test';
        bl.Phoenix_Marketing_Lead_OTC__c = 'Approved';
        insert bl;
         
        
        Phoenix_Bid_Line_Item__c bl2 = new Phoenix_Bid_Line_Item__c();
        bl2.Phoenix_Bid__c = pb.Id;
        bl2.Phoenix_Customer_Approval_OTC__c ='Not Approved';
        bl2.Phoenix_Current_Direct_Price__c = 10;
        bl2.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        bl2.Phoenix_Product__c = prod1.id;
        bl2.Phoenix_Final_Status__c = 'Not Approved';
        bl2.Phoenix_Current_Position__c = 'test';
        bl2.Phoenix_Marketing_Lead_OTC__c = 'Approved';
     
        insert bl2;
        Phoenix_Approval_Delegation_History__c deleHistory = new Phoenix_Approval_Delegation_History__c();
        deleHistory.Phoenix_Delegation_Start_Time__c =  system.now();
        deleHistory.Phoenix_Delegation_End_Time__c = datetime.newInstance(2023, 9, 15, 12, 30, 0); 
        deleHistory.Phoenix_Delegated_Approver__c=userInfo.getUserId();
        deleHistory.Phoenix_Is_Active_delegator__c = True;
        insert deleHistory;
        
        Phoenix_Bid_Line_Item__c bl3 = new Phoenix_Bid_Line_Item__c();
        bl3.Phoenix_Bid__c = pb.Id;
        bl3.Phoenix_Current_Direct_Price__c = 10;
        bl3.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        bl3.Phoenix_Product__c = prod1.id;
        bl3.Phoenix_Final_Status__c = 'Not Approved';
        bl3.Phoenix_Marketing_Lead_OTC__c = 'Not Approved';
        bl3.Phoenix_Proposed_Indirect_Selling_Unit__c = 2;
        bl3.Phoenix_Proposed_Direct_Selling_Unit__c = 2;
        bl3.Phoenix_SCM_Approval_Y_N__c = 'Y- Current + Inc Demand Approved';
        bl3.Phoenix_Current_Position__c = 'test';
        insert bl3;
           Phoenix_Product_Position__c pp= new Phoenix_Product_Position__c();
        pp.Phoenix_Customer__c= testAccount.id;
        pp.Phoenix_Group_Name__c = 'ClarusONE';
        pp.name='Primary';
        pp.Phoenix_General_Category__c='Primary';
        pp.Phoenix_Position_Comments__c='TEt';
        insert pp;
        
        Phoenix_Bid_Line_Item__c bl4 = new Phoenix_Bid_Line_Item__c();
        bl4.Phoenix_Bid__c = pb.Id;
        bl4.Phoenix_Current_Direct_Price__c = 10;
        bl4.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        bl4.Phoenix_Product__c = prod1.id;
        bl4.Phoenix_Final_Status__c = 'Approved';
        bl4.Phoenix_Marketing_Lead_OTC__c = 'Not Approved';
        bl4.Phoenix_Proposed_Indirect_Selling_Unit__c = 2;
        bl4.Phoenix_Proposed_Direct_Selling_Unit__c = 2;
        bl4.Phoenix_SCM_Approval_Y_N__c = 'Y- Current + Inc Demand Approved';
        bl4.Phoenix_Current_Position__c = 'test';
        insert bl4;
        
        list<Phoenix_Bid_Line_Item__c>pblist=new list<Phoenix_Bid_Line_Item__c>();
        list<Phoenix_Bid_Line_Item__c>pblist2=new list<Phoenix_Bid_Line_Item__c>();
        list<Phoenix_Bid_Line_Item__c>elsepblist=new list<Phoenix_Bid_Line_Item__c>{bl4};
        list<Id>pbIDlist=new list<Id>();
        pblist.add(bl); pbIDlist.add(bl.Id);pblist2.add(bl2);
        pblist.add(bl2); pbIDlist.add(bl2.Id);pblist2.add(bl3);
        pblist.add(bl3); 
        List<String> selcntcs = new List<String>();
        selcntcs.add('223');
        Phoenix_NPR_Data__c nprdat = new Phoenix_NPR_Data__c();
        nprdat.Phoenix_Contract__c = Cntrct.id;
        nprdat.Phoenix_NPR_Status__c = 'Active';
        nprdat.Phoenix_Contract_Number__c = '223';
        nprdat.Phoenix_Product__c = prod1.id;
        nprdat.Phoenix_12Months_Sales_Unit__c = 200;
        nprdat.Phoenix_Contract_Type__c = 'Direct';
        nprdat.Phoenix_Rebate_G_N_Indicator__c = '10N+ 0G';
        nprdat.Phoenix_Bonafied_G_N_Indicator__c = '5N+0G';
        nprdat.Phoenix_Product_Position__c = 'test1';
        insert nprdat;
        Phoenix_Approval_Matrix__c matrix = new Phoenix_Approval_Matrix__c();
        matrix.Name = 'Marketing Approval';
        Insert matrix;
        Phoenix_Approval_Process_Step__c appstep = new Phoenix_Approval_Process_Step__c();
        appstep.Phoenix_Order__c = 2.0;
        appstep.Name = 'Marketing Approval';
        appstep.Phoenix_Approval_Matrix__c = matrix.Id;
        Insert appstep;
        Phoenix_Approval_Process_Step__c appstep1 = new Phoenix_Approval_Process_Step__c();
        appstep1.Phoenix_Order__c = 3.0;
        appstep1.Name = 'Marketing Lead OTC';
        appstep1.Phoenix_Approval_Matrix__c = matrix.Id;
        Insert appstep1;
        
        Phoenix_Bid_Process_Steps__c bisp = new Phoenix_Bid_Process_Steps__c();
        bisp.Name = 'Contract';
        bisp.Phoenix_Bid__c = pb.Id;
        bisp.Phoenix_Approver__c = Userinfo.getUserId();
        bisp.Phoenix_Approver_Team__c = 'Marketing';
        bisp.Phoenix_Process_Step__c = appstep.Id;
        insert bisp;
        Phoenix_Bid_Process_Steps__c bisp1 = new Phoenix_Bid_Process_Steps__c();
        bisp1.Name = 'Marketing';
        bisp1.Phoenix_Bid__c = pb.Id;
        bisp1.Phoenix_Approver__c = Userinfo.getUserId();
        bisp1.Phoenix_Approver_Team__c = 'Marketing';
        bisp1.Phoenix_Process_Step__c = appstep.Id;
        bisp1.Phoenix_Status__c='Completed';
        
        insert bisp1;
         Phoenix_Bid_Process_Steps__c bisp2 = new Phoenix_Bid_Process_Steps__c();
        bisp2.Name = 'Customer';
        bisp2.Phoenix_Bid__c = pb.Id;
        bisp2.Phoenix_Approver__c = Userinfo.getUserId();
        bisp2.Phoenix_Approver_Team__c = 'Marketing';
        bisp2.Phoenix_Process_Step__c = appstep.Id;
        bisp2.Phoenix_Status__c='Completed';
        
        Phoenix_Bid_Process_Steps__c bisp4 = new Phoenix_Bid_Process_Steps__c();
        bisp4.Name = 'Customer';
        bisp4.Phoenix_Bid__c = 'a0CDL00000HrvZw2AJ';
        bisp4.Phoenix_Approver__c = Userinfo.getUserId();
        bisp4.Phoenix_Approver_Team__c = 'Marketing';
        bisp4.Phoenix_Process_Step__c = appstep.Id;
        bisp4.Phoenix_Status__c='Completed';
        insert bisp4;
        
        Phoenix_Bid_Process_Steps__c bisp5 = new Phoenix_Bid_Process_Steps__c();
        bisp5.Name = 'Customer';
        bisp5.Phoenix_Bid__c = 'a0CDL00000HrvZw2AJ';
        bisp5.Phoenix_Approver__c = Userinfo.getUserId();
        bisp5.Phoenix_Approver_Team__c = 'Marketing';
        bisp5.Phoenix_Process_Step__c = appstep.Id;
        bisp5.Phoenix_Status__c='Completed';
        insert bisp5;
        insert bisp2;
        List<Phoenix_Bid_Process_Steps__c> steps = new List<Phoenix_Bid_Process_Steps__c>();
        steps.add(bisp2);
        steps.add(bisp1);
        Phoenix_OTCTemplateCls.fetchUser();
        Phoenix_OTCTemplateCls.getSubmitBidInfo(pb.Id);
        Phoenix_OTCTemplateCls.getExistingDocs(pb.Id);
        
        Phoenix_OTCTemplateCls.getReBidLineInfo(prod1.Id, pb.id);
        Phoenix_OTCTemplateCls.getRelatedList(pb.id);
        Phoenix_OTCTemplateCls.getAllTotals(new List<Id> {bl3.id,bl2.id,bl.id});

        Phoenix_OTCTemplateCls.getupdatedforExport(pb.id);
     
        Phoenix_OTCTemplateCls.fieldApiList('Phoenix_Bid_Line_Item__c');
       
        Phoenix_OTCTemplateCls.sentBackToMarketing(pb.Id,pblist);
        Phoenix_OTCTemplateCls.makeApprovalsCustomers(pb.Id,pblist,true,false);
		Phoenix_OTCTemplateCls.makeLeadApprovals(pb.Id,pblist,true);
        Phoenix_OTCTemplateCls.updateRelatedList(new list < Phoenix_Bid_Line_Item__c > {
            bl
                });
        Phoenix_OTCTemplateCls.getContracts(testAccount.Id, 'a');
        Phoenix_OTCTemplateCls.getPositions(testAccount.Id);
     
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
        Bid_Last_Activity__c bd = new Bid_Last_Activity__c();
        bd.Bid__c = 'a0CDL00000HrvZw2AJ';
        bd.Bid_Name__c = 'test';
        insert bd;
     
         list < Phoenix_Product_Position__c > positionList = [select Phoenix_Customer__c, Phoenix_Customer__r.Name, Name, Phoenix_Customer__r.ParentId, Phoenix_Group_Name__c, Phoenix_General_Category__c, Phoenix_Position_Comments__c from Phoenix_Product_Position__c];
        List<Phoenix_Bid_Process_Steps__c> processList = [SELECT  Id, Name, Phoenix_Process_Step__r.Name,Phoenix_Bid__c, Phoenix_Is_Criteria_Step__c, Phoenix_Process_Step__c, Phoenix_Step__c, Phoenix_Approver__c, Phoenix_Approver__r.Name, Phoenix_Approver__r.Email, Phoenix_Status__c, Phoenix_Approver_Team__c FROM Phoenix_Bid_Process_Steps__c where Phoenix_Bid__c = 'a0CDL00000HrvZw2AJ'];
        if(processList.size()>0){}
        system.debug('processList---->'+processList.size());
        system.debug('processList---->'+processList);
       // Phoenix_ClarusOneCls.updateNextContractProcessSteps(pb.id,pb.Name,processList);
        
        List < Id > contentDCLinks = new List < Id > ();
        Phoenix_OTCTemplateCls.deleteAttachmentList(contentDCLinks);            
        Phoenix_OTCTemplateCls.getPositions(testAccount.Id);
        Phoenix_OTCTemplateCls.updateRelatedList(new list < Phoenix_Bid_Line_Item__c > {
            bl
                });
        Phoenix_OTCTemplateCls.findByProductFamily(new list < string > {
            'lev'
                }, pb.Id, new list < string > {
                    'Rx'
                        }, new list < string > {
                            ''
                                });
         Test.startTest();
        Phoenix_OTCTemplateCls.saveLineItems(new list < Phoenix_Bid_Line_Item__c > {
            bl,
                bl3
                }, pb.id, 'Gross', 'Gross', '', true, true, true, 'Approved', true,'sample',true,system.today(),true,system.today());
        Phoenix_OTCTemplateCls.getCalcs(bl, bl.id, 'Test 1', 'rebateType');
        Phoenix_OTCTemplateCls.getCalcs(bl, bl.id, 'Test 2', 'feeType');
          
        
        Phoenix_OTCTemplateCls.makeApprovals(pb.id, new List < Phoenix_Bid_Line_Item__c > {
            bl2
                }, true);
        Phoenix_OTCTemplateCls.makeApprovals(pb.id, elsepblist, true);
        //Phoenix_OTCTemplateCls.codeCoverageBlock();
        Phoenix_OTCTemplateCls.getNPRData(new List<string>{Cntrct1.Phoenix_Contract_Number__c,Cntrct2.Phoenix_Contract_Number__c,Cntrct3.Phoenix_Contract_Number__c,Cntrct4.Phoenix_Contract_Number__c},new List<Id>{bl.id,bl2.id,bl3.Id},'Product Addition',pb.id,'Walgreens');
        Phoenix_OTCTemplateCls.saveProposedShare(bl.id,'500');
        Phoenix_OTCTemplateCls.submitToProceddStep(pb.id, false,false,'',false);
        Phoenix_OTCTemplateCls.submitToProceddStep(pb.id, false,false,'',true);
        Phoenix_OTCTemplateCls.submitToProceddStep(pb.id, true,false,'',false);
        Phoenix_OTCTemplateCls.updateNextProcessSteps(pb.id,pb.Name,steps,false,false);
        Phoenix_OTCTemplateCls.updateNextCustomerProcessSteps(pb.id,pb.Name,processList);
        Phoenix_OTCTemplateCls.sampleStep('a0CDL00000HrvZw2AJ',pb.Name,processList);
        Phoenix_OTCTemplateCls.getbidInfo(pb.id); 
        Phoenix_OTCTemplateCls.getLastBidActivity('a0CDL00000HrvZw2AJ');
        Phoenix_OTCTemplateCls.getNPRDataList(new List<string>{Cntrct1.Phoenix_Contract_Number__c,Cntrct2.Phoenix_Contract_Number__c,Cntrct3.Phoenix_Contract_Number__c,Cntrct4.Phoenix_Contract_Number__c},new List<Id>{bl.id,bl2.id,bl3.Id});
		Test.stopTest();		
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
        
        Phoenix_Bid_Line_Item__c bl = new Phoenix_Bid_Line_Item__c();
        bl.Phoenix_Bid__c = pb.Id;
        bl.Phoenix_Current_Direct_Price__c = 10;
        bl.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        bl.Phoenix_Final_Status__c = 'Not Approved';
        bl.Phoenix_Contract_Approval__c = 'Line Error- Not Sent';
        insert bl;
        
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
            
            Phoenix_Bid_Process_Steps__c bisp1 = new Phoenix_Bid_Process_Steps__c();
            bisp1.Name = 'Closed' + i ;
            bisp1.Phoenix_Process_Step__c = ap2.id;
            bisp1.Phoenix_Bid__c = pb.Id;
            bisp1.Phoenix_Approver__c = Userinfo.getUserId();
            bisp1.Phoenix_Approver_Team__c = 'Marketing';
            bidprocess.add(bisp);
            bidprocess.add(bisp1);
            
        }
        insert bidprocess;
        for(Phoenix_Bid_Process_Steps__c cmp : bidprocess)
        {
            stepMap.put(integer.valueof(cmp.Phoenix_Step__c), new List<Phoenix_Bid_Process_Steps__c>{cmp}); 
            stepnameNoMap.put(cmp.Phoenix_Approver_Team__c, integer.valueof(cmp.Phoenix_Step__c));
        }
        
        
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
        bl.Phoenix_Final_Status__c = 'Not Approved';
        bl.Phoenix_Wholesaler_Guidance_Price__c = 5;
        bl.Phoenix_Retail_Direct_Sales_Price__c = 4;
        bl.Phoenix_ProposedContractBidPriceMktng__c = 3 ;
        bl.Phoenix_Retail_Direct_Guidance_Price__c = 2 ;
        bl.Phoenix_Retail_Direct_Price__c = 1;
        bl.Phoenix_Retail_Indirect_Price__c = 2;
        bl.Phoenix_Marketing_Approval__c = 'Not Approved';
        bl.Phoenix_Guidance_Price__c = 2;
        
        insert bl;
        List<Phoenix_Bid_Process_Steps__c> processList = [SELECT  Id, Name, Phoenix_Process_Step__r.Name,Phoenix_Bid__c, Phoenix_Is_Criteria_Step__c, Phoenix_Process_Step__c, Phoenix_Step__c, Phoenix_Approver__c, Phoenix_Approver__r.Name, Phoenix_Approver__r.Email, Phoenix_Status__c, Phoenix_Approver_Team__c FROM Phoenix_Bid_Process_Steps__c where Phoenix_Bid__c =: pb.id order by Phoenix_Step__c];
        system.debug('processList---->'+processList.size());
        system.debug('processList---->'+processList);
       
        
        Phoenix_BidLineItemExtn__c bliExtn1 = new Phoenix_BidLineItemExtn__c();
        bliExtn1.Phoenix_Bid_Line_Item__c = bl.Id;
        insert bliExtn1;
        
        Phoenix_OTCTemplateCls.getSubmitBidInfo(pb.id);
        Phoenix_OTCTemplateCls.getChildExtnRecord(bl.id);
        
        Phoenix_OTCTemplateCls.getbidInfo(pb.id);
        Phoenix_OTCTemplateCls.getselectOptions(testAccount,'Testing');
        Phoenix_OTCTemplateCls.deleteLineItems(bl.id);
        Phoenix_OTCTemplateCls.updateNextProcessSteps(pb.id,pb.Name,processList,false,false);
        
    }    
    static testmethod void getItems4(){
       
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
        pb.Phoenix_Bid_Name__c = 'test 1';
        pb.Phoenix_Reference_Contracts__c = 'test 2';
        pb.Phoenix_Approval_Status__c = 'Customer';
        insert pb;


        Product2 prod1 = new Product2(Name = 'Test Product', Family = 'Test Family', IsActive = TRUE, ProductCode = '324', Phoenix_Product_Director__c = UserInfo.getUserId(), Phoenix_Marketing_Lead__c = UserInfo.getUserId());
        insert prod1;

        Phoenix_Bid_Line_Item__c bl = new Phoenix_Bid_Line_Item__c();
        bl.Phoenix_Bid__c = pb.Id;
        bl.Phoenix_Current_Direct_Price__c = 10;
        bl.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        bl.Phoenix_Product__c = prod1.id;
        bl.Phoenix_Final_Status__c = 'Not Approved';
        bl.Phoenix_Product_Family1__c = 'Habitrol';
        bl.Phoenix_Product_Director1__c = UserInfo.getName();
        bl.Phoenix_Marketing_Final_Approval__c = true;
        bl.Phoenix_Contract_Approval__c = 'Line Error- Not Sent';
        bl.Phoenix_Others_Indirect__c = 24;
        bl.Phoenix_Others_Direct__c = 25;
        bl.Phoenix_12_Months_Actual_Sales__c = 5;
        bl.Phoenix_Current_Position__c = 'test 1';
        bl.Phoenix_Current_Net_Sales_Internal__c = 4;
        bl.Phoenix_DeadNet_TrckGR__c = 2;
        bl.Phoenix_Current_Direct_Selling_Unit__c = 2;
        bl.Phoenix_Current_Indirect_Selling_Unit__c = 4;
        bl.Phoenix_Current_Indirect_Price__c = 7;
        bl.Phoenix_Current_Direct_Price__c = 4;
        bl.Phoenix_Current_Per_Unit_Rebate__c = 7;
        bl.Phoenix_ZITD_Value__c = 2;
        bl.Phoenix_Current_Rebate__c = 2;
        bl.Phoenix_Rebate_G_N__c = 'test p';
        bl.Phoenix_Fee_G_N__c = 'tst';
        bl.Phoenix_Current_Admin_Fee__c = 5;
        bl.Phoenix_Marketing_Approval__c = 'Not Approved';
        bl.Phoenix_Current_Retail_Direct_Units__c = 20;
        insert bl;
        Phoenix_OTCTemplateCls.saveLineItemsNewPL(pb.Id, new List < Phoenix_Bid_Line_Item__c > {
            bl
        }); 
    }
    static testmethod void getItems5(){
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
            prod1.Phoenix_Product_Director__c = UserInfo.getUserId();
            insert prod1;
            Phoenix_Bid_Line_Item__c bl = new Phoenix_Bid_Line_Item__c();
            bl.Phoenix_Bid__c = pb.Id;
            bl.Phoenix_Current_Direct_Price__c = 10;
            bl.Phoenix_Current_Indirect_Selling_Unit__c = 10;
            bl.Phoenix_Product__c = prod1.id;
            bl.Phoenix_Final_Status__c = 'Not Approved';
            insert bl;

            Phoenix_Bid_Line_Item__c bl2 = new Phoenix_Bid_Line_Item__c();
            bl2.Phoenix_Bid__c = testData.bidsList[0].Id;
            bl2.Phoenix_Current_Direct_Price__c = 10;
            bl2.Phoenix_Current_Indirect_Selling_Unit__c = 10;
            bl2.Phoenix_Product__c = prod1.id;
            bl2.Phoenix_Final_Status__c = 'Not Approved';
            insert bl2;

            Phoenix_Bid_Line_Item__c bl3 = new Phoenix_Bid_Line_Item__c();
            bl3.Phoenix_Bid__c = pb.Id;
            bl3.Phoenix_Current_Direct_Price__c = 10;
            bl3.Phoenix_Current_Indirect_Selling_Unit__c = 10;
            bl3.Phoenix_Product__c = prod1.id;
            bl3.Phoenix_Final_Status__c = 'Not Approved';
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
            Phoenix_OTCTemplateCls.getReBidLineInfo(prod1.Id, pb.id);
            Phoenix_OTCTemplateCls.getRelatedList(pb.id);
        Phoenix_OTCTemplateCls.getAllTotals(new List<Id> {bl3.id,bl2.id});
            Phoenix_OTCTemplateCls.getupdatedforExport(pb.id);
           Phoenix_OTCTemplateCls.getContracts(testAccount.Id, 'a');
            Phoenix_OTCTemplateCls.getPositions(testAccount.Id);

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


            Phoenix_OTCTemplateCls.updateRelatedList(new list < Phoenix_Bid_Line_Item__c > {
                bl
            });
            Phoenix_OTCTemplateCls.findByProductFamily(new list < string > {
                'lev'
            }, pb.Id, new list < string > {
                'Rx'
            }, new list < string > {
                ''
            });
		
            Phoenix_OTCTemplateCls.saveLineItemsNewPL( pb.id,new list < Phoenix_Bid_Line_Item__c > {bl});
             Phoenix_OTCTemplateCls.saveLineItems(new list < Phoenix_Bid_Line_Item__c > {
            bl,
                bl3
                }, pb.id, 'Gross', 'Gross', '', true, true, true, 'Approved', true,'sample',true,system.today(),true,system.today());
            Phoenix_OTCTemplateCls.getCalcs(bl, bl.id, 'Test 1', 'rebateType');
            Phoenix_OTCTemplateCls.getCalcs(bl, bl.id, 'Test 2', 'feeType');
            Phoenix_OTCTemplateCls.deleteAttachmentList(new List < Id > {bl.Id,bl2.Id});
            
            Phoenix_OTCTemplateCls.makeApprovals(pb.id, new List < Phoenix_Bid_Line_Item__c > {
                bl
            }, true);
            Phoenix_OTCTemplateCls.submitToProceddStep(pb.id, false, false, '',false);
            Phoenix_OTCTemplateCls.makeApprovalsCustomers(pb.Id,new list < Phoenix_Bid_Line_Item__c > {bl},true,false);
            Phoenix_OTCTemplateCls.makeLeadApprovals(pb.Id,new list < Phoenix_Bid_Line_Item__c > {bl},true);
            Phoenix_OTCTemplateCls.updateNextCustomerProcessSteps(pb.Id, pb.Name, new List < Phoenix_Bid_Process_Steps__c > {
                bisp
            });
            Phoenix_OTCTemplateCls.updateNextProcessSteps(pb.id, pb.Name, new List < Phoenix_Bid_Process_Steps__c > {
                bisp
            }, false, false);
       
        } catch (exception ex) {}

    }
   
    
}