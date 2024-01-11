@istest
public class Phoenix_OTB_PharmaBidClsTest {
    static testmethod void setupTestData() {
     //   Phoenix_OTB_PharmaBidCls.coverageBlock();
      /*  Phoenix_OTB_PharmaBidCls.testLogic();
        Phoenix_OTB_PharmaBidCls.testLogic1();
        Phoenix_OTB_PharmaBidCls.testLogic2();
        Phoenix_OTB_PharmaBidCls.testLogic3();
        Phoenix_OTB_PharmaBidCls.testLogic4();
*/
    }
    static testmethod void test1() {
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
        Product2 prod1 = new Product2(Name = 'Test Product', Family = 'Test Family', IsActive = TRUE, ProductCode = '324');
        prod1.Phoenix_Product_Director__c = UserInfo.getUserId();
        prod1.Phoenix_Marketing_Lead__c = UserInfo.getUserId();
        insert prod1;
        Phoenix_Bid_Line_Item__c bl = new Phoenix_Bid_Line_Item__c();
        bl.Phoenix_Bid__c = pb.Id;
        bl.Phoenix_Current_Direct_Price__c = 10;
        bl.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        bl.Phoenix_Product__c = prod1.id;
        bl.Phoenix_Final_Status__c = 'Approved';
        insert bl;
        Phoenix_OTB_PharmaBidCls.fetchUserOTB();
        Phoenix_OTB_PharmaBidCls.getSubmitBidInfo(pb.id);
        Phoenix_OTB_PharmaBidCls.getRelatedList(pb.id);
        Phoenix_OTB_PharmaBidCls.getAllTotals(pb.id);
        //Phoenix_OTB_PharmaBidCls.getupdatedforExport(pb.id);
        //Phoenix_OTB_PharmaBidCls.getReBidLineInfo(prod1.Id, pb.id);
        //Phoenix_OTB_PharmaBidCls.updateRelatedList(new list < Phoenix_Bid_Line_Item__c > {
        //bl
        //});
        
    }
    static testmethod void test2() {
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
        Product2 prod1 = new Product2(Name = 'Test Product', Family = 'Test Family', IsActive = TRUE, ProductCode = '324');
        prod1.Phoenix_Product_Director__c = UserInfo.getUserId();
        prod1.Phoenix_Marketing_Lead__c = UserInfo.getUserId();
        insert prod1;
        Phoenix_Bid_Line_Item__c bl = new Phoenix_Bid_Line_Item__c();
        bl.Phoenix_Bid__c = pb.Id;
        bl.Phoenix_Current_Direct_Price__c = 10;
        bl.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        bl.Phoenix_Product__c = prod1.id;
        bl.Phoenix_Final_Status__c = 'Approved';
        insert bl;
        Phoenix_Bid__c bid =new Phoenix_Bid__c();
        bid.Phoenix_Bid_Name__c='Test';
        bid.Phoenix_Customer__c=testAccount.Id;
        bid.Phoenix_Bid_Type__c='Product Addition ';
        bid.Phoenix_Approval_Status__c='';
        insert bid;
        Product2 pro= new Product2();
        pro.Name='Test';
        pro.Family='Test';
        pro.Phoenix_Pkg_Size__c=5;
        pro.ProductCode='30000001';
        pro.Phoenix_Overall_market__c=70000;
        pro.Phoenix_DRL_Market_Share__c=5;
        insert pro;
        Phoenix_Bid_Line_Item__c bli= new Phoenix_Bid_Line_Item__c();
        bli.Phoenix_Bid__c=bid.Id;
        bli.Phoenix_Pkg_Size1__c=pro.Phoenix_Pkg_Size__c;
        bli.Phoenix_Product__c=pro.Id;
        insert bli;
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
        // list < Phoenix_OTB_PharmaBidCls.wrapperClass > pbw = new list < Phoenix_OTB_PharmaBidCls.wrapperClass > ();
        //list < Phoenix_Bid_Line_Item__c > clonelineItems = new list < Phoenix_Bid_Line_Item__c > ();
        //insert clonelineItems;
        //list < Phoenix_OTB_PharmaBidCls.wrapperClass > wraplines = new list < Phoenix_OTB_PharmaBidCls.wrapperClass > ();
        /* for (Integer i = 0; i < clonelineItems.size(); i++) {
Phoenix_OTB_PharmaBidCls.wrapperClass  ph = new  Phoenix_OTB_PharmaBidCls.wrapperClass();
//list < Phoenix_OTB_PharmaBidCls.wrapperClass > wraplines = new list < Phoenix_OTB_PharmaBidCls.wrapperClass > ();
// Phoenix_OTB_PharmaBidCls.wrapperClass pbw = new Phoenix_OTB_PharmaBidCls.wrapperClass();
ph.qlItem = clonelineItems[i];
//pbw.isSelected = true;
//pbw.prodName='test';
//pbw.custName='alex';
//pbw.family='Waalgreen';
//pbw.IPAPrice=0.02;
//pbw.NDC='test2';
//pbw.currencyCode='Dollar';
//pbw.contrFlag=false;

wraplines.add(ph);
}*/
        //Phoenix_OTB_PharmaBidCls.fetchUserOTB();
        //Phoenix_OTB_PharmaBidCls.getSubmitBidInfo(pb.id);
        // Phoenix_OTB_PharmaBidCls.getRelatedList(pb.id);
        // Phoenix_OTB_PharmaBidCls.getAllTotals(pb.id);
        
        Phoenix_OTB_PharmaBidCls.getupdatedforExport(pb.id);
        Phoenix_OTB_PharmaBidCls.getReBidLineInfo(prod1.Id, pb.id);
        Phoenix_OTB_PharmaBidCls.updateRelatedList(new list < Phoenix_Bid_Line_Item__c > {
            bl
                });
        // Phoenix_OTB_PharmaBidCls.deleteLineItems(bli.id);
        Phoenix_OTB_PharmaBidCls.saveLineItems(new list < Phoenix_Bid_Line_Item__c > {bl,bl3}, pb.id, 'Gross', 'Gross', '', true, true, true, 'Approved', true,'sample');
        Phoenix_OTB_PharmaBidCls.saveLineItems1(new list < Phoenix_Bid_Line_Item__c > {bl,bl3}, pb.id, 'Gross', 'Gross', '', false, false, false, 'Approved', false,'sample');
        Phoenix_OTB_PharmaBidCls.makeApprovals(pb.id, new List < Phoenix_Bid_Line_Item__c > {bl}, true);
    }
    static testmethod void test3() {
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
        Product2 prod1 = new Product2(Name = 'Test Product', Family = 'Test Family', IsActive = TRUE, ProductCode = '324');
        prod1.Phoenix_Product_Director__c = UserInfo.getUserId();
        prod1.Phoenix_Marketing_Lead__c = UserInfo.getUserId();
        insert prod1;
        Phoenix_Bid_Line_Item__c bl = new Phoenix_Bid_Line_Item__c();
        bl.Phoenix_Bid__c = pb.Id;
        bl.Phoenix_Current_Direct_Price__c = 10;
        bl.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        bl.Phoenix_Product__c = prod1.id;
        bl.Phoenix_Final_Status__c = 'Approved';
        insert bl;
        Phoenix_Bid__c bid =new Phoenix_Bid__c();
        bid.Phoenix_Bid_Name__c='Test';
        bid.Phoenix_Customer__c=testAccount.Id;
        bid.Phoenix_Bid_Type__c='Product Addition ';
        bid.Phoenix_Approval_Status__c='';
        insert bid;
        Product2 pro= new Product2();
        pro.Name='Test';
        pro.Family='Test';
        pro.Phoenix_Pkg_Size__c=5;
        pro.ProductCode='30000001';
        pro.Phoenix_Overall_market__c=70000;
        pro.Phoenix_DRL_Market_Share__c=5;
        insert pro;
        Phoenix_Bid_Line_Item__c bli= new Phoenix_Bid_Line_Item__c();
        bli.Phoenix_Bid__c=bid.Id;
        bli.Phoenix_Pkg_Size1__c=pro.Phoenix_Pkg_Size__c;
        bli.Phoenix_Product__c=pro.Id;
        insert bli;
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
        Phoenix_OTB_PharmaBidCls.deleteLineItems(bli.id);
        Phoenix_OTB_PharmaBidCls.getCalcs(bl, bl.id, 'No Change', 'MarketApproval','Indirect');
        Phoenix_OTB_PharmaBidCls.findByProductFamily(new list < string > {
            'lev'
                }, pb.Id, new list < string > {
                    'Rx'
                        }, new list < string > {
                            ''
                                });
    }
    static testmethod void test4() {
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
        Product2 prod1 = new Product2(Name = 'Test Product', Family = 'Test Family', IsActive = TRUE, ProductCode = '324');
        prod1.Phoenix_Product_Director__c = UserInfo.getUserId();
        prod1.Phoenix_Marketing_Lead__c = UserInfo.getUserId();
        insert prod1;
        Phoenix_Bid_Line_Item__c bl = new Phoenix_Bid_Line_Item__c();
        bl.Phoenix_Bid__c = pb.Id;
        bl.Phoenix_Current_Direct_Price__c = 10;
        bl.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        bl.Phoenix_Product__c = prod1.id;
        bl.Phoenix_Final_Status__c = 'Approved';
        insert bl;
        Phoenix_Bid__c bid =new Phoenix_Bid__c();
        bid.Phoenix_Bid_Name__c='Test';
        bid.Phoenix_Customer__c=testAccount.Id;
        bid.Phoenix_Bid_Type__c='Product Addition ';
        bid.Phoenix_Approval_Status__c='';
        insert bid;
        Product2 pro= new Product2();
        pro.Name='Test';
        pro.Family='Test';
        pro.Phoenix_Pkg_Size__c=5;
        pro.ProductCode='30000001';
        pro.Phoenix_Overall_market__c=70000;
        pro.Phoenix_DRL_Market_Share__c=5;
        insert pro;
        Phoenix_Bid_Line_Item__c bli= new Phoenix_Bid_Line_Item__c();
        bli.Phoenix_Bid__c=bid.Id;
        bli.Phoenix_Pkg_Size1__c=pro.Phoenix_Pkg_Size__c;
        bli.Phoenix_Product__c=pro.Id;
        insert bli;
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
        List < Phoenix_Approval_Process_Step__c > approvalSteps = [Select Id FROM Phoenix_Approval_Process_Step__c where Phoenix_Order__c = 1 LImit 1];
        Phoenix_Bid_Process_Steps__c bisp = new Phoenix_Bid_Process_Steps__c();
        bisp.Name = 'Contracts';
        bisp.Phoenix_Bid__c = pb.Id;
        bisp.Phoenix_Approver__c = Userinfo.getUserId();
        bisp.Phoenix_Approver_Team__c = 'Marketing';
        //bisp.Phoenix_Step__c = 233;
        //bisp.Phoenix_Process_Step__c = approvalSteps[0].Id;
        insert bisp;
        Phoenix_Bid_Process_Steps__c bisp1 = new Phoenix_Bid_Process_Steps__c();
        bisp1.Name = '';
        bisp1.Phoenix_Bid__c = pb.Id;
        bisp1.Phoenix_Approver__c = Userinfo.getUserId();
        bisp1.Phoenix_Approver_Team__c = 'Marketing';
        //bisp1.Phoenix_Process_Step__c = approvalSteps[0].Id;
        insert bisp1;
        Phoenix_Contract__c Cntrct = new Phoenix_Contract__c();
        Cntrct.name = 'taest cntrct';
        Cntrct.Phoenix_Contract_Number__c = '223';
        insert Cntrct;
        Phoenix_OTB_PharmaBidCls.getContracts(testAccount.id, 'a');
        Phoenix_OTB_PharmaBidCls.submitToProceddStep(pb.id, false, 'Not Approved',false,'');
        //Phoenix_OTB_PharmaBidCls.makeApprovals(pb.id, new List < Phoenix_Bid_Line_Item__c > {bl}, true);
        Phoenix_OTB_PharmaBidCls.updateNextContractProcessSteps(pb.Id, pb.Name, new List < Phoenix_Bid_Process_Steps__c > {bisp});
        Phoenix_OTB_PharmaBidCls.updateNextProcessSteps(pb.id, pb.Name, new List < Phoenix_Bid_Process_Steps__c > {bisp}, true, true, true, 'Not Approved');
        Phoenix_OTB_PharmaBidCls.updateNextProcessSteps(pb.id, pb.Name, new List < Phoenix_Bid_Process_Steps__c > {bisp,bisp1}, false, false, false, 'Not Approved');
        //Phoenix_OTB_PharmaBidCls.codeCoverage();
        //Phoenix_OTB_PharmaBidCls.updateNextProcessSteps(pb.id, pb.Name, new List < Phoenix_Bid_Process_Steps__c > {bisp}, false, false, false, 'Not Approved');
        Phoenix_OTB_PharmaBidCls.getNPRData(new list < string > {
            Cntrct.Phoenix_Contract_Number__c
                }, pb.Id, 'OneTimeBuy');
        
        
    }
    static testmethod void test5() {
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
        Product2 prod1 = new Product2(Name = 'Test Product', Family = 'Test Family', IsActive = TRUE, ProductCode = '324');
        prod1.Phoenix_Product_Director__c = UserInfo.getUserId();
        prod1.Phoenix_Marketing_Lead__c = UserInfo.getUserId();
        insert prod1;
        Phoenix_Bid_Line_Item__c bl = new Phoenix_Bid_Line_Item__c();
        bl.Phoenix_Bid__c = pb.Id;
        bl.Phoenix_Current_Direct_Price__c = 10;
        bl.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        bl.Phoenix_Product__c = prod1.id;
        bl.Phoenix_Final_Status__c = 'Approved';
        insert bl;
        Phoenix_Bid__c bid =new Phoenix_Bid__c();
        bid.Phoenix_Bid_Name__c='Test';
        bid.Phoenix_Customer__c=testAccount.Id;
        bid.Phoenix_Bid_Type__c='Product Addition ';
        bid.Phoenix_Approval_Status__c='';
        insert bid;
        Product2 pro= new Product2();
        pro.Name='Test';
        pro.Family='Test';
        pro.Phoenix_Pkg_Size__c=5;
        pro.ProductCode='30000001';
        pro.Phoenix_Overall_market__c=70000;
        pro.Phoenix_DRL_Market_Share__c=5;
        insert pro;
        Phoenix_Bid_Line_Item__c bli= new Phoenix_Bid_Line_Item__c();
        bli.Phoenix_Bid__c=bid.Id;
        bli.Phoenix_Pkg_Size1__c=pro.Phoenix_Pkg_Size__c;
        bli.Phoenix_Product__c=pro.Id;
        insert bli;
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
        List < Phoenix_Approval_Process_Step__c > approvalSteps = [Select Id FROM Phoenix_Approval_Process_Step__c where Phoenix_Order__c = 1 LImit 1];
        Phoenix_Bid_Process_Steps__c bisp = new Phoenix_Bid_Process_Steps__c();
        bisp.Name = 'Contracts';
        bisp.Phoenix_Bid__c = pb.Id;
        bisp.Phoenix_Approver__c = Userinfo.getUserId();
        bisp.Phoenix_Approver_Team__c = 'Marketing';
        //bisp.Phoenix_Process_Step__c = approvalSteps[0].Id;
        insert bisp;
        Phoenix_Bid_Process_Steps__c bisp1 = new Phoenix_Bid_Process_Steps__c();
        bisp1.Name = '';
        bisp1.Phoenix_Bid__c = pb.Id;
        bisp1.Phoenix_Approver__c = Userinfo.getUserId();
        bisp1.Phoenix_Approver_Team__c = 'Marketing';
        //bisp1.Phoenix_Process_Step__c = approvalSteps[0].Id;
        insert bisp1;
        Phoenix_Contract__c Cntrct = new Phoenix_Contract__c();
        Cntrct.name = 'taest cntrct';
        Cntrct.Phoenix_Contract_Number__c = '223';
        insert Cntrct;
        Phoenix_OTB_PharmaBidCls.updateLines(pb.Id,'Direct');
        Phoenix_OTB_PharmaBidCls.getSubmitBidInfo1(pb.Id);
        Phoenix_OTB_PharmaBidCls.getupdatedforExport1(pb.id);
        Phoenix_OTB_PharmaBidCls.getReBidLineInfo1(prod1.Id, pb.id);
        Phoenix_OTB_PharmaBidCls.getReBidLineInfo2(prod1.Id, pb.id);
        Phoenix_OTB_PharmaBidCls.getReBidLineInfo3(prod1.Id, pb.id);
        Phoenix_OTB_PharmaBidCls.getReBidLineInfo4(prod1.Id, pb.id);
        
    }
    /*static testmethod void getItems2() {
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        
        Phoenix_Bid__c pb = new Phoenix_Bid__c();
        pb.Phoenix_Bid_Type__c = 'Pharma Bid OTB';
        pb.Phoenix_Status__c = 'New';
        pb.Phoenix_Comments__c = 'Test Comments';
        pb.Phoenix_Customer__c = testAccount.Id;
        //pb.Phoenix_Customer_Bid_Deadline_Time_zone__c = 'PST';
        //pb.Phoenix_Customer_Bid_Deadline_Time__c = '6 PM';
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
            bisp2.Phoenix_Is_Criteria_Step__c = true;
            
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
            system.debug('criteriaStep----'+cmp.Phoenix_Is_Criteria_Step__c);
            stepMap.put(integer.valueof(cmp.Phoenix_Step__c), new List<Phoenix_Bid_Process_Steps__c>{cmp}); 
            stepnameNoMap.put(cmp.Phoenix_Approver_Team__c, integer.valueof(cmp.Phoenix_Step__c));
        }
        
        Phoenix_OTB_PharmaBidCls.updateNextContractProcessSteps(pb.id,pb.name,bidprocess);
        //  Phoenix_OTB_PharmaBidCls.updateNextProcessSteps(pb.id,pb.name,bidQuery,false,false,false,'Customer Service');
        Phoenix_OTB_PharmaBidCls.updateNextProcessSteps(pb.id,pb.name,bidprocess,false,false,false,'Supply Chain');
    }*/
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
        prod1.Phoenix_Product_Director__c = UserInfo.getUserId();
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
        
        
        Phoenix_OTB_PharmaBidCls.makeApprovals(pb.Id,new List<Phoenix_Bid_Line_Item__c> {bl},true);
        
        
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
        bl.Phoenix_Current_Direct_Selling_Unit__c = 100;
        //  bl.Phoenix_12Months_Sales_Unit__c = 120;
        bl.Phoenix_12_Months_Actual_Sales__c = 120;
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
        bl2.Phoenix_Current_Direct_Selling_Unit__c = 100;
        // bl2.Phoenix_12Months_Sales_Unit__c = 120;
        bl2.Phoenix_12_Months_Actual_Sales__c = 120;
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
        bl3.Phoenix_Current_Direct_Selling_Unit__c = 100;
        //bl3.Phoenix_12Months_Sales_Unit__c = 120;
        bl3.Phoenix_12_Months_Actual_Sales__c = 120;
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
        nprdat1.Phoenix_Contract_Type__c = 'Direct';
        nprdat1.Phoenix_Contract_Price__c = 100;
        nprdat1.Phoenix_Per_Unit_Rebate__c = 100;
        nprdat1.Phoenix_Dead_Net_Tracking_GR__c = 100;
        //       nprdat1.Phoenix_Net_Sales_Internal__c = 100;
        nprdat1.Phoenix_ZITD_Value__c = 100;
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
        nprdat2.Phoenix_Contract_Type__c = 'Direct';
        nprdat2.Phoenix_Contract_Price__c = 100;
        nprdat2.Phoenix_Per_Unit_Rebate__c = 100;
        nprdat2.Phoenix_Dead_Net_Tracking_GR__c = 100;
        //       nprdat1.Phoenix_Net_Sales_Internal__c = 100;
        nprdat2.Phoenix_ZITD_Value__c = 100;
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
        nprdat3.Phoenix_Contract_Type__c = 'Direct';
        nprdat3.Phoenix_Contract_Price__c = 100;
        nprdat3.Phoenix_Per_Unit_Rebate__c = 100;
        nprdat3.Phoenix_Dead_Net_Tracking_GR__c = 100;
        //       nprdat1.Phoenix_Net_Sales_Internal__c = 100;
        nprdat3.Phoenix_ZITD_Value__c = 100;
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
        nprdat4.Phoenix_Contract_Type__c = 'Direct';
        nprdat4.Phoenix_Contract_Price__c = 100;
        nprdat4.Phoenix_Per_Unit_Rebate__c = 100;
        nprdat4.Phoenix_Dead_Net_Tracking_GR__c = 100;
        //       nprdat1.Phoenix_Net_Sales_Internal__c = 100;
        nprdat4.Phoenix_ZITD_Value__c = 100;
        insert nprdat4;
        
        
        Phoenix_OTB_PharmaBidCls.getNPRData(new list < string > {
            Cntrct1.Phoenix_Contract_Number__c
                }, pb.Id, 'Indirect');
        Phoenix_OTB_PharmaBidCls.getNPRData(new list < string > {
            Cntrct2.Phoenix_Contract_Number__c
                }, pb.Id, 'Indirect');
        Phoenix_OTB_PharmaBidCls.getNPRData(new list < string > {
            Cntrct3.Phoenix_Contract_Number__c
                }, pb.Id, 'Indirect');
        Phoenix_OTB_PharmaBidCls.getNPRData(new list < string > {
            Cntrct4.Phoenix_Contract_Number__c
                }, pb.Id, 'Indirect');
        
    }  
    
}