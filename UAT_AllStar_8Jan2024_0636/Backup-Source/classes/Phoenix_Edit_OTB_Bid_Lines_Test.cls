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
public class Phoenix_Edit_OTB_Bid_Lines_Test {
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
        bl.Phoenix_Product_Director1__c = UserInfo.getUserId();
        
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
        
        Phoenix_Bid_Process_Steps__c bisp = new Phoenix_Bid_Process_Steps__c();
        bisp.Name = 'Contracts';
        bisp.Phoenix_Bid__c = pb.Id;
        bisp.Phoenix_Approver__c = Userinfo.getUserId();
        bisp.Phoenix_Approver_Team__c = 'Contracts';
        insert bisp;
        Phoenix_Bid_Process_Steps__c bisp1 = new Phoenix_Bid_Process_Steps__c();
        bisp1.Name = 'Marketing';
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
        
        
        
        Phoenix_Edit_OTB_Bid_Lines_Cls.getRelatedList(pb.id);
        Phoenix_Edit_OTB_Bid_Lines_Cls.getAllTotals(pb.id);
        Phoenix_Edit_OTB_Bid_Lines_Cls.getupdatedforExport(pb.id);
        Phoenix_Edit_OTB_Bid_Lines_Cls.getContracts(testAccount.Id, 'a');
        
        Phoenix_Edit_OTB_Bid_Lines_Cls.getNPRData(new list < string > {
            Cntrct.Phoenix_Contract_Number__c
                }, pb.Id, 'Direct');
        Phoenix_Edit_OTB_Bid_Lines_Cls.getNPRData(new list < string > {
            Cntrct.Phoenix_Contract_Number__c
                }, pb.Id, 'Indirect');
        Phoenix_Edit_OTB_Bid_Lines_Cls.updateRelatedList(new list < Phoenix_Bid_Line_Item__c > {
            bl
                });
        Phoenix_Edit_OTB_Bid_Lines_Cls.findByProductFamily(new list < string > {
            'lev'
                }, pb.Id, new list < string > {
                    'Rx'
                        }, new list < string > {
                            ''
                                });
        Phoenix_Edit_OTB_Bid_Lines_Cls.saveLineItems(new list < Phoenix_Bid_Line_Item__c > {
            bl
                }, bl.id, 'Gross', 'Gross', true, true, 'Approved', true);
        
        Phoenix_Edit_OTB_Bid_Lines_Cls.getCalcs(bl, bl.id, 'test', 'rebateType');
        
        Phoenix_Bid_Line_Item__c bl1 = new Phoenix_Bid_Line_Item__c();
        bl1.Phoenix_Bid__c = pb.Id;
        bl1.Phoenix_Current_Direct_Price__c = 10;
        bl1.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        bl1.Phoenix_Product__c = prod1.id;
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
        
        Phoenix_Edit_OTB_Bid_Lines_Cls.submitToProceddStep(pb.id, false);
        Phoenix_Edit_OTB_Bid_Lines_Cls.makeApprovalsContracts(pb.id, new list < Phoenix_Bid_Line_Item__c > {
            bl1
                }, true, true);
        Phoenix_Edit_OTB_Bid_Lines_Cls.makeApprovals(pb.id, new List < Phoenix_Bid_Line_Item__c > {
            bl1
                }, true);
        Phoenix_Edit_OTB_Bid_Lines_Cls.deleteLineItems(bl2.id);
        
    }
    static testmethod void getItems2() {
        
        map < string, list < Phoenix_NPR_Data__c >> productCodeToNPRLineMap = new map < string, list < Phoenix_NPR_Data__c >> ();
        
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
        
        Phoenix_Edit_OTB_Bid_Lines_Cls.saveLineItems(new list < Phoenix_Bid_Line_Item__c > {
            bidline
                },
                                                     pb.id, 'Gross', 'Gross', 
                                                     true, true,  'Approved', true);
        Phoenix_Edit_OTB_Bid_Lines_Cls.getselectOptions(testAccount,'Testing');
        Phoenix_Edit_OTB_Bid_Lines_Cls.getCalcs(bl, bl.id, 'test 2', 'feeType');
        Phoenix_Edit_OTB_Bid_Lines_Cls.getCalcs(bl, bl.id, 'Approved', 'MarketApproval');
        Phoenix_Edit_OTB_Bid_Lines_Cls.getCalcs(bl, bl.id, 'Line Error- Not Sent', 'ContractApproval');
        
        
    }
    
    static testmethod void getItems3() {
        list < Phoenix_NPR_Data__c > pnrdata = new list < Phoenix_NPR_Data__c >();   
        map < string, list < Phoenix_NPR_Data__c >> productCodeToNPRLineMap = new map < string, list < Phoenix_NPR_Data__c >> ();
        
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
            pnrdata.add(nprdat);
            
            Phoenix_NPR_Data__c nprdata = new Phoenix_NPR_Data__c();
            nprdata.Phoenix_Contract__c = Cntrct.id;
            nprdata.Phoenix_Contract_Number__c = '223';
            nprdata.Phoenix_Product__c = prod1.id;
            nprdata.Phoenix_12Months_Sales_Unit__c = 200;
            nprdata.Phoenix_Contract_Type__c = 'Indirect';
            nprdata.Phoenix_Rebate_G_N_Indicator__c = '10N+ 0G';
            nprdata.Phoenix_Bonafied_G_N_Indicator__c = '5N+0G';
            pnrdata.add(nprdata);
        }
        insert pnrdata;
        
        Phoenix_Edit_OTB_Bid_Lines_Cls.getNPRData(new list < string > {
            Cntrct.Phoenix_Contract_Number__c
                }, pb.Id, 'Direct');    
        Phoenix_Edit_OTB_Bid_Lines_Cls.getNPRData(new list < string > {
            Cntrct.Phoenix_Contract_Number__c
                }, pb.Id, 'Indirect');  
        Phoenix_Edit_OTB_Bid_Lines_Cls.getNPRData(new list < string > {
            Cntrct.Phoenix_Contract_Number__c
                }, pb.Id, 'Direct and Indirect');  
    }
    
    static testmethod void getItems4() {
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
        ap2.Phoenix_Order__c = 2;
        insert ap2;
        
        Phoenix_Bid_Process_Steps__c bisp11 = new Phoenix_Bid_Process_Steps__c();
        bisp11.Name = 'Test ii';
        bisp11.Phoenix_Process_Step__c = ap2.id;
        bisp11.Phoenix_Bid__c = pb.Id;
        bisp11.Phoenix_Approver__c = Userinfo.getUserId();
        bisp11.Phoenix_Approver_Team__c = 'Supply Chain';
        bisp11.Phoenix_Status__c = 'In Process';
        insert bisp11;
        
        Phoenix_Bid_Line_Item__c bidline = [select id, Phoenix_Rebate_G_N__c, Phoenix_Fee_G_N__c, Phoenix_Marketing_Approval__c from Phoenix_Bid_Line_Item__c where id =: bl.id];
        Phoenix_Edit_OTB_Bid_Lines_Cls.makeApprovals(pb.id, new list < Phoenix_Bid_Line_Item__c > {
            bidline
                }, true);
        
        Phoenix_Edit_OTB_Bid_Lines_Cls.getNPRData(new list < string > {
            Cntrct.Phoenix_Contract_Number__c
                }, pb.Id, 'Direct');    
       
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

List < Phoenix_Bid_Process_Steps__c >  bidprocess= new List < Phoenix_Bid_Process_Steps__c >();
Map < Integer, List < Phoenix_Bid_Process_Steps__c >> stepMap = new Map < Integer, List < Phoenix_Bid_Process_Steps__c >> ();
            Map < String, Integer > stepnameNoMap = new Map < String, Integer > ();

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
bidprocess.add(bisp);
bidprocess.add(bisp1);
}
insert bidprocess;
for(Phoenix_Bid_Process_Steps__c cmp : bidprocess)
{
stepMap.put(integer.valueof(cmp.Phoenix_Step__c), new List<Phoenix_Bid_Process_Steps__c>{cmp}); 
      stepnameNoMap.put(cmp.Phoenix_Approver_Team__c, integer.valueof(cmp.Phoenix_Step__c));
}
          /* if 
            
           
            Phoenix_Edit_OTB_Bid_Lines_Cls.updateNextProcessSteps(pb.id, 'testbid', bidprocess, false, false);*/
               
    }
}