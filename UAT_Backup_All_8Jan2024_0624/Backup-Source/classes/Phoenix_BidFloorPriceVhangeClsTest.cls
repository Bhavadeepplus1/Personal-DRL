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
@istest
public class Phoenix_BidFloorPriceVhangeClsTest {
    static testmethod void getItems() {
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
        bl.Phoenix_Final_Status__c = 'Approved';
        bl.Phoenix_Product_Family1__c = 'Habitrol';
        bl.Phoenix_Product_Director1__c = UserInfo.getUserId();
        bl.Phoenix_Marketing_Final_Approval__c = true;
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
        
        Phoenix_Approval_Matrix__c am = new Phoenix_Approval_Matrix__c();
        am.Name = 'test';
        insert am;
        Phoenix_Approval_Process_Step__c ap = new Phoenix_Approval_Process_Step__c();
        ap.Phoenix_Approval_Matrix__c = am.id;
        ap.Phoenix_Order__c = 1;
        insert ap;
        Phoenix_Approval_Process_Step__c ap2 = new Phoenix_Approval_Process_Step__c();
        ap2.Phoenix_Approval_Matrix__c = am.id;
        ap2.Phoenix_Order__c = 2;
        insert ap2;
        Phoenix_Bid_Process_Steps__c bisp = new Phoenix_Bid_Process_Steps__c();
        bisp.Name = 'Contracts';
        bisp.Phoenix_Process_Step__c = ap.id;
        bisp.Phoenix_Bid__c = pb.Id;
        bisp.Phoenix_Approver__c = Userinfo.getUserId();
        bisp.Phoenix_Approver_Team__c = 'Contracts';
        insert bisp;
        Phoenix_Bid_Process_Steps__c bisp1 = new Phoenix_Bid_Process_Steps__c();
        bisp1.Name = 'Marketing';
        bisp1.Phoenix_Process_Step__c = ap2.id;
        bisp1.Phoenix_Bid__c = pb.Id;
        bisp1.Phoenix_Approver__c = Userinfo.getUserId();
        bisp1.Phoenix_Approver_Team__c = 'Marketing';
        
        insert bisp1;
        
        //******************************Marketing
        
        Id devRecordTypeId = Schema.SObjectType.Phoenix_User_Approval_Matrix__c.getRecordTypeInfosByName().get('Approval User Group').getRecordTypeId();
        Phoenix_User_Approval_Matrix__c app11 = new Phoenix_User_Approval_Matrix__c();
        app11.Name = 'Marketing User Group Testing 1';
        app11.Phoenix_Approver_Group_Name__c = 'Marketing';
        app11.RecordTypeId = devRecordTypeId;
        insert app11;
        
        Phoenix_User_Approval_Matrix__c app22 = new Phoenix_User_Approval_Matrix__c();
        app22.Name = 'Marketing User Group Testing 2';
        app22.Phoenix_Approver_Group_Name__c = 'Marketing';
        app22.RecordTypeId = devRecordTypeId;
        insert app22;
        
        Phoenix_User_Approval_Matrix__c app1 = new Phoenix_User_Approval_Matrix__c();
        app1.Name = 'Testing 1';
        app1.Phoenix_Approver__c = UserInfo.getUserId();
        app1.User_Group__c = app11.id;
        insert app1;
        
        Phoenix_User_Approval_Matrix__c app2 = new Phoenix_User_Approval_Matrix__c();
        app2.Name = 'Testing 2';
        app2.User_Group__c = app22.id;
        app2.Phoenix_Approver__c = UserInfo.getUserId();
        insert app2; 
        
        //******************************Contracts
        Phoenix_User_Approval_Matrix__c app111 = new Phoenix_User_Approval_Matrix__c();
        app111.Name = 'Contracts User Group Testing 1';
        app111.Phoenix_Approver_Group_Name__c = 'Contracts';
        app111.RecordTypeId = devRecordTypeId;
        insert app111;
        
        Phoenix_User_Approval_Matrix__c app222 = new Phoenix_User_Approval_Matrix__c();
        app222.Name = 'Contracts User Group Testing 2';
        app222.Phoenix_Approver_Group_Name__c = 'Contracts';
        app222.RecordTypeId = devRecordTypeId;
        insert app222;
        
        Phoenix_User_Approval_Matrix__c app12 = new Phoenix_User_Approval_Matrix__c();
        app12.Name = 'Testing 1';
        app12.Phoenix_Approver__c = UserInfo.getUserId();
        app12.User_Group__c = app111.id;
        insert app12;
        
        Phoenix_User_Approval_Matrix__c app23 = new Phoenix_User_Approval_Matrix__c();
        app23.Name = 'Testing 2';
        app23.User_Group__c = app222.id;
        app23.Phoenix_Approver__c = UserInfo.getUserId();
        insert app23; 
        
        Phoenix_Bid_Line_Item__c bidline = [select id, Phoenix_Rebate_G_N__c, Phoenix_Fee_G_N__c, Phoenix_Contract_Approval__c from Phoenix_Bid_Line_Item__c where id =: bl.id];
     Phoenix_BidFloorPriceVhangeCls.getRelatedList(pb.id);
        Phoenix_BidFloorPriceVhangeCls.getContracts(testAccount.Id, 'a');
        Phoenix_BidFloorPriceVhangeCls.updateRelatedList(new list < Phoenix_Bid_Line_Item__c > {
            bidline
                });
        Phoenix_BidFloorPriceVhangeCls.findByProductFamily(new list < string > {
            'lev'
                }, pb.Id, new list < string > {
                    'Rx'
                        }, new list < string > {
                            ''
                                });
        Phoenix_BidFloorPriceVhangeCls.saveLineItems(new list < Phoenix_Bid_Line_Item__c > {
            bidline
                },
                                                     bl.id, 'Gross', 'Gross', 'Approved',
                                                     true, true, true, 'marketingHeader', true);
        Phoenix_BidFloorPriceVhangeCls.getCalcs(bl, bl.id, 'test 1', 'rebateType');
        Phoenix_BidFloorPriceVhangeCls.submitToProceddStep(pb.id, false);
        Phoenix_BidFloorPriceVhangeCls.makeApprovalsContracts(pb.id, new list < Phoenix_Bid_Line_Item__c > {
            bidline
                }, true, true);
        Phoenix_BidFloorPriceVhangeCls.makeApprovals(pb.id, new List < Phoenix_Bid_Line_Item__c > {
            bl
                }, true);
        list < Phoenix_Bid_Process_Steps__c > processStepLsit = [SELECT Id, Name, Phoenix_Step__c, Phoenix_Approver_Team__c from Phoenix_Bid_Process_Steps__c LIMIT 1];
        Phoenix_BidFloorPriceVhangeCls.updateNextProcessSteps(pb.id, 'testbid', processStepLsit, false, false);
        Phoenix_BidFloorPriceVhangeCls.deleteLineItems(bl.id);
        Phoenix_BidFloorPriceVhangeCls.getSubmitBidInfo(pb.id);
        Phoenix_BidFloorPriceVhangeCls.getupdatedforExport(pb.id);
        //list < Phoenix_Bid_Process_Steps__c > processStepLsit1 = [SELECT Id, Name, Phoenix_Step__c, Phoenix_Approver_Team__c from Phoenix_Bid_Process_Steps__c LIMIT 1];
       // Phoenix_BidFloorPriceVhangeCls.updateNextContractProcessSteps(pb.id,'testbid1',processStepLsit);
    }
    
    static testmethod void getItems2() {
        test.startTest();
        
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
        ap2.Phoenix_Order__c = 2;
        insert ap2;
        
        Phoenix_Bid_Process_Steps__c bisp1 = new Phoenix_Bid_Process_Steps__c();
        bisp1.Name = 'Marketing';
        bisp1.Phoenix_Process_Step__c = ap2.id;
        bisp1.Phoenix_Bid__c = pb.Id;
        bisp1.Phoenix_Approver__c = Userinfo.getUserId();
        bisp1.Phoenix_Approver_Team__c = 'Marketing';
        // bisp1.Phoenix_Status__c = 'In Process';
        insert bisp1;
        
        Phoenix_Bid_Line_Item__c bidline = [select id, Phoenix_Rebate_G_N__c, Phoenix_Fee_G_N__c, Phoenix_Contract_Approval__c from Phoenix_Bid_Line_Item__c where id =: bl.id];
        
        Phoenix_BidFloorPriceVhangeCls.saveLineItems(new list < Phoenix_Bid_Line_Item__c > {
            bidline
                },
                                                     pb.id, 'Gross', 'Gross', '	Sent to Customer',
                                                     true, true, true, 'Approved', true);
        Phoenix_BidFloorPriceVhangeCls.getselectOptions(testAccount,'Testing');
        Phoenix_BidFloorPriceVhangeCls.getCalcs(bl, bl.id, 'test 2', 'feeType');
        Phoenix_BidFloorPriceVhangeCls.getCalcs(bl, bl.id, 'Approved', 'MarketApproval');
        Phoenix_BidFloorPriceVhangeCls.makeApprovalsContracts(pb.id, new list < Phoenix_Bid_Line_Item__c > {
            bidline
                }, true, true);
        Phoenix_BidFloorPriceVhangeCls.makeApprovals(pb.id, new List < Phoenix_Bid_Line_Item__c > {
            bl
                }, true);
        test.stopTest();
    }
    
    static testmethod void getItems3() {
        Test.startTest();
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
        bl.Phoenix_Final_Status__c = 'Approved';
        bl.Phoenix_Product_Family1__c = 'Habitrol';
        bl.Phoenix_Product_Director1__c = UserInfo.getUserId();
        bl.Phoenix_Marketing_Final_Approval__c = true;
        bl.Phoenix_Marketing_Approval__c= 'Not Approved';
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
        
        Phoenix_Approval_Matrix__c am = new Phoenix_Approval_Matrix__c();
        am.Name = 'test';
        insert am;
        Phoenix_Approval_Process_Step__c ap = new Phoenix_Approval_Process_Step__c();
        ap.Phoenix_Approval_Matrix__c = am.id;
        ap.Phoenix_Order__c = 1;
        insert ap;
        Phoenix_Approval_Process_Step__c ap2 = new Phoenix_Approval_Process_Step__c();
        ap2.Phoenix_Approval_Matrix__c = am.id;
        ap2.Phoenix_Order__c = 2;
        insert ap2;
        
        Phoenix_Bid_Process_Steps__c bisp3 = new Phoenix_Bid_Process_Steps__c();
        bisp3.Name = 'Contracts';
        bisp3.Phoenix_Process_Step__c = ap.id;
        bisp3.Phoenix_Bid__c = pb.Id;
        bisp3.Phoenix_Approver__c = Userinfo.getUserId();
        bisp3.Phoenix_Approver_Team__c = 'Contracts';
        insert bisp3;
        Phoenix_Bid_Process_Steps__c bisp14 = new Phoenix_Bid_Process_Steps__c();
        bisp14.Name = 'Marketing';
        bisp14.Phoenix_Process_Step__c = ap2.id;
        bisp14.Phoenix_Bid__c = pb.Id;
        bisp14.Phoenix_Approver__c = Userinfo.getUserId();
        bisp14.Phoenix_Approver_Team__c = 'Marketing';
        insert bisp14;
        
                //******************************Marketing

        Id devRecordTypeId = Schema.SObjectType.Phoenix_User_Approval_Matrix__c.getRecordTypeInfosByName().get('Approval User Group').getRecordTypeId();
        Phoenix_User_Approval_Matrix__c app11 = new Phoenix_User_Approval_Matrix__c();
        app11.Name = 'Marketing User Group Testing 1';
        app11.Phoenix_Approver_Group_Name__c = 'Marketing';
        app11.RecordTypeId = devRecordTypeId;
        insert app11;
        
        Phoenix_User_Approval_Matrix__c app22 = new Phoenix_User_Approval_Matrix__c();
        app22.Name = 'Marketing User Group Testing 2';
        app22.Phoenix_Approver_Group_Name__c = 'Marketing';
        app22.RecordTypeId = devRecordTypeId;
        insert app22;
        
        Phoenix_User_Approval_Matrix__c app1 = new Phoenix_User_Approval_Matrix__c();
        app1.Name = 'Testing 1';
        app1.Phoenix_Approver__c = UserInfo.getUserId();
        app1.User_Group__c = app11.id;
        insert app1;
        
        Phoenix_User_Approval_Matrix__c app2 = new Phoenix_User_Approval_Matrix__c();
        app2.Name = 'Testing 2';
        app2.User_Group__c = app22.id;
        app2.Phoenix_Approver__c = UserInfo.getUserId();
        insert app2; 
        
        //******************************Contracts
        Phoenix_User_Approval_Matrix__c app111 = new Phoenix_User_Approval_Matrix__c();
        app111.Name = 'Contracts User Group Testing 1';
        app111.Phoenix_Approver_Group_Name__c = 'Contracts';
        app111.RecordTypeId = devRecordTypeId;
        insert app111;
        
        Phoenix_User_Approval_Matrix__c app222 = new Phoenix_User_Approval_Matrix__c();
        app222.Name = 'Contracts User Group Testing 2';
        app222.Phoenix_Approver_Group_Name__c = 'Contracts';
        app222.RecordTypeId = devRecordTypeId;
        insert app222;
        
        Phoenix_User_Approval_Matrix__c app12 = new Phoenix_User_Approval_Matrix__c();
        app12.Name = 'Testing 1';
        app12.Phoenix_Approver__c = UserInfo.getUserId();
        app12.User_Group__c = app111.id;
        insert app12;
        
        Phoenix_User_Approval_Matrix__c app23 = new Phoenix_User_Approval_Matrix__c();
        app23.Name = 'Testing 2';
        app23.User_Group__c = app222.id;
        app23.Phoenix_Approver__c = UserInfo.getUserId();
        insert app23; 
        
        List < Phoenix_Bid_Process_Steps__c > pbpk = new List < Phoenix_Bid_Process_Steps__c >();
        Map < Integer, List < Phoenix_Bid_Process_Steps__c >> stepMap = new Map < Integer, List < Phoenix_Bid_Process_Steps__c >> ();
        
        for(Integer i=0;i<5;i++)
        {
            Phoenix_Bid_Process_Steps__c bisp = new Phoenix_Bid_Process_Steps__c();
            bisp.Name = 'Contracts'+i;
            bisp.Phoenix_Process_Step__c = ap.id;
            bisp.Phoenix_Bid__c = pb.Id;
            bisp.Phoenix_Approver__c = Userinfo.getUserId();
            bisp.Phoenix_Approver_Team__c = 'Contracts';
            
            Phoenix_Bid_Process_Steps__c bisp1 = new Phoenix_Bid_Process_Steps__c();
            bisp1.Name = 'Marketing' + i ;
            bisp1.Phoenix_Process_Step__c = ap2.id;
            bisp1.Phoenix_Bid__c = pb.Id;
            bisp1.Phoenix_Approver__c = Userinfo.getUserId();
            bisp1.Phoenix_Approver_Team__c = 'Marketing';
            pbpk.add(bisp);
            pbpk.add(bisp1);
        }
        insert pbpk;
        for(Phoenix_Bid_Process_Steps__c cmp : pbpk)
        {
            stepMap.put(integer.valueof(cmp.Phoenix_Step__c), new List<Phoenix_Bid_Process_Steps__c>{cmp});  
        }
        Phoenix_BidFloorPriceVhangeCls.updateNextProcessSteps(pb.id, 'testbid', pbpk, false, false);
        //Phoenix_BidFloorPriceVhangeCls.updateNextContractProcessSteps(pb.id, 'testbid', pbpk);
        
        Test.stopTest();
    }
     
}