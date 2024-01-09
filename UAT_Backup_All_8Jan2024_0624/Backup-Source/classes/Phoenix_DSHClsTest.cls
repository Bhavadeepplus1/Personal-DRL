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
public class Phoenix_DSHClsTest {
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
            prod1.Phoenix_Product_Director__c = UserInfo.getUserId();
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
            Phoenix_DSHCls.getReBidLineInfo(prod1.Id, pb.id);
            Phoenix_DSHCls.getRelatedList(pb.id);
            Phoenix_DSHCls.getAllTotals(pb.id);
            Phoenix_DSHCls.getupdatedforExport(pb.id);
            Phoenix_DSHCls.getContracts(testAccount.Id,'test','Walgreens');
            Phoenix_DSHCls.getPositions(testAccount.Id);
            
            Phoenix_DSHCls.getNPRData(new list < string > {
                Cntrct.Phoenix_Contract_Number__c
                    }, pb.Id, 'Direct');
            Phoenix_DSHCls.getNPRData(new list < string > {
                Cntrct.Phoenix_Contract_Number__c
                    }, pb.Id, 'Indirect');
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
            
            Phoenix_DSHCls.getNPRDataRXSS(new list < string > {
                Cntrct1.Phoenix_Contract_Number__c
                    }, pb.Id, 'RXSS');
            Phoenix_DSHCls.getNPRDataDSH(new list < string > {
                Cntrct3.Phoenix_Contract_Number__c
                    }, pb.Id, 'BASE/DSH');
            
            Phoenix_DSHCls.getNPRDataABCPharmagen(new list < string > {
                Cntrct4.Phoenix_Contract_Number__c
                    }, pb.Id, 'ABC Pharmagen');
            
            Phoenix_DSHCls.updateRelatedList(new list < Phoenix_Bid_Line_Item__c > {
                bl
                    });
            Phoenix_DSHCls.findByProductFamily(new list < string > {
                'lev'
                    }, pb.Id, new list < string > {
                        'Rx'
                            }, new list < string > {
                                ''
                                    });
            
            Phoenix_DSHCls.saveLineItems(new list < Phoenix_Bid_Line_Item__c > {
                bl,
                    bl3
                    }, pb.id, 'Gross', 'Gross','10','20', '', true, true, true, true,true,'Approved', true,'sample');
            Phoenix_DSHCls.getCalcs(bl, bl.id, 'Test 1', 'rebateType');
            Phoenix_DSHCls.getCalcs(bl, bl.id, 'Test 2', 'feeType');
            
            
            Phoenix_DSHCls.makeApprovals(pb.id, new List < Phoenix_Bid_Line_Item__c > {
                bl
                    }, true);
            Phoenix_DSHCls.submitToProceddStep(pb.id, false,false,'');
            Phoenix_DSHCls.fetchUser();
          /*  Phoenix_DSHCls.updateNextContractProcessSteps(pb.Id, pb.Name, new List < Phoenix_Bid_Process_Steps__c > {
                bisp
                    });*/
            Phoenix_DSHCls.updateNextProcessSteps(pb.id, pb.Name, new List < Phoenix_Bid_Process_Steps__c > {
                bisp
                    }, false, false);
            
            
            
            //Phoenix_WalgreensCls.getSubmitBidInfo(pb.Id);
            
            //uncommented 64th line
            //Phoenix_WalgreensCls.makeApprovalsContracts(pb.id,new list<Phoenix_Bid_Line_Item__c>{bl},true,true);
            //Phoenix_WalgreensCls.makeApprovals(pb.id,new List<Phoenix_Bid_Line_Item__c>{bl},true);
            
            /*  Phoenix_Bid_Line_Item__c bl1= new Phoenix_Bid_Line_Item__c();
bl1.Phoenix_Bid__c=pb.Id;
bl1.Phoenix_Current_Direct_Price__c=10;
bl1.Phoenix_Current_Indirect_Selling_Unit__c=10;
bl1.Phoenix_Product__c=prod1.id;
bl1.Phoenix_Final_Status__c='Approved';
bl1.Phoenix_Proposed_Indirect_Selling_Unit__c=2;        
bl1.Phoenix_SCM_Approval_Y_N__c='Y- Only Current Monthly Demand Approved';      
insert bl1;*/
            
            
            
            //Phoenix_WalgreensCls.deleteLineItems(bl.id);
            
            
        } catch (exception ex) {}
        
        
    }
    /* //methods by sk
static testmethod void getSubmitBidInfo(){
// try{       

Phoenix_TestDataCreator testData = new Phoenix_TestDataCreator();
testData.generateBids();
testData.generateApprovalMatrix();

Phoenix_Bid__c pb = new Phoenix_Bid__c();
pb.Phoenix_Status__c = 'New';
pb.Phoenix_Comments__c = 'Test Comments';
// pb.Phoenix_Customer__c = testAccount.Id;
// pb.Phoenix_Customer_Bid_Deadline_Date_Time__c = DateTime.now();
pb.Phoenix_Customer_Bid_Deadline_Time_zone__c = 'PST';
pb.Phoenix_Customer_Bid_Deadline_Time__c = '6 PM';
pb.Phoenix_Bid_Deadline_Date__c = System.today();
pb.Phoenix_Select_Wholesaler__c = 'ABC';
pb.Phoenix_Bid_Type__c='RFP Bids';
insert pb;

Phoenix_RedirectClass.getBid(pb.Id);
Phoenix_WalgreensCls.getSubmitBidInfo(pb.Id);

//   }catch(exception ex){}

}
static testmethod void updateNextContractProcessSteps(){
//    try{
Phoenix_Bid__c bid = new Phoenix_Bid__c();
bid.Phoenix_Bid_Type__c = 'Customer Rebate Change';
insert bid;
list<Phoenix_Bid_Process_Steps__c> processStepLsit=[select Name,Id from Phoenix_Bid_Process_Steps__c];
Phoenix_WalgreensCls.updateNextContractProcessSteps(bid.Id,bid.Name,processStepLsit);
// Phoenix_WalgreensCls.getSubmitBidInfo(pb.Id);

//  }catch(exception ex){}

}
//by sai krishna (02/04/2021)
static testmethod void test1(){
// try{
Account testAccount = new Account(Name = 'Test Account');
insert testAccount;
Phoenix_Bid__c pb = new Phoenix_Bid__c();
pb.Phoenix_Status__c = 'New';
pb.Phoenix_Comments__c = 'Test Comments';
pb.Phoenix_Customer__c = testAccount.Id;
//  pb.Phoenix_Customer_Bid_Deadline_Date_Time__c = DateTime.now();
pb.Phoenix_Customer_Bid_Deadline_Time_zone__c = 'PST';
pb.Phoenix_Customer_Bid_Deadline_Time__c = '6 PM';
pb.Phoenix_Customer_Type__c='Direct and Indirect';
pb.Phoenix_Bid_Deadline_Date__c = System.today();
insert pb;
Phoenix_WalgreensCls.submitToProceddStep(pb.id,false);

//  }catch(exception ex){}

}
static testmethod void makeApprovalsContracts(){
//  try{
List<Phoenix_Bid_Line_Item__c> bidlines = new List<Phoenix_Bid_Line_Item__c>();
Account testAccount = new Account(Name = 'Test Account');
testAccount.Phoenix_Contracts_Approver__c=Userinfo.getUserId();
insert testAccount;
Phoenix_Bid__c pb = new Phoenix_Bid__c();
pb.Phoenix_Status__c = 'New';
pb.Phoenix_Comments__c = 'Test Comments';
pb.Phoenix_Customer__c = testAccount.Id;
pb.Phoenix_Customer_Bid_Deadline_Date_Time__c = DateTime.now();
pb.Phoenix_Customer_Bid_Deadline_Time_zone__c = 'PST';
pb.Phoenix_Customer_Bid_Deadline_Time__c = '6 PM';
pb.Phoenix_Customer_Type__c='Direct and Indirect';
pb.Phoenix_Bid_Deadline_Date__c = System.today();
pb.Phoenix_Bid_Type__c='RFP Bids';pb.Phoenix_Approval_Status__c = 'Draft';
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
p3.Phoenix_Product_Director__c = UserInfo.getUserId();
insert p3;
Phoenix_Bid_Line_Item__c bl= new Phoenix_Bid_Line_Item__c();
bl.Phoenix_Bid__c=pb.Id;
bl.Phoenix_Current_Direct_Price__c=10;
bl.Phoenix_Product_Code1__c='300029858';
bl.Phoenix_Product_Family1__c='Daptomycin Inj 500mg US';
bl.Phoenix_Current_Indirect_Selling_Unit__c=10;
bl.Phoenix_Product__c = p2.Id;
bl.Phoenix_Final_Status__c='Approved';
bl.Phoenix_SCM_Approval_Y_N__c = 'Y- Only Current Monthly Demand Approved';
bl.Phoenix_Marketing_Final_Approval__c=true;
insert bl; 
bidlines.add(bl);
Phoenix_Bid_Line_Item__c bl1= new Phoenix_Bid_Line_Item__c();
bl1.Phoenix_Bid__c=pb.Id;
bl1.Phoenix_Final_Status__c='Approved';      
bl1.Phoenix_Current_Direct_Price__c=10;
bl1.Phoenix_Current_Indirect_Selling_Unit__c=10;
bl1.Phoenix_Product__c = p3.Id;
bl1.Phoenix_SCM_Approval_Y_N__c = 'Y- Only Current Monthly Demand Approved';
bl1.Phoenix_Marketing_Final_Approval__c=true;
insert bl1;
bidlines.add(bl1);
Phoenix_Bid_Line_Item__c bl2= new Phoenix_Bid_Line_Item__c();
bl2.Phoenix_Bid__c=pb.Id;
bl2.Phoenix_Final_Status__c='Not Approved';      
bl2.Phoenix_Current_Direct_Price__c=10;
bl2.Phoenix_Current_Indirect_Selling_Unit__c=10;
bl2.Phoenix_Product__c = p3.Id;
bl2.Phoenix_SCM_Approval_Y_N__c = 'N- Not Approved';
bl2.Phoenix_Marketing_Final_Approval__c=true;
insert bl2;
bidlines.add(bl2);
String bidId;

boolean approveStatusFlag;
boolean isContracts;
//Phoenix_WalgreensCls.makeApprovalsContracts(pb.id,bidlines,true,true);
//Phoenix_WalgreensCls.makeApprovals(pb.id,bidlines,true);

// }catch(exception ex){}

}
static testmethod void test2(){
Account acc=new Account();
acc.Name='test account';
acc.Industry='Banking';
insert acc;
Phoenix_WalgreensCls.getselectOptions(acc,'Industry');
}
static testmethod void test3(){
Account testAccount = new Account(Name = 'Test Account');
testAccount.Phoenix_Contracts_Approver__c=Userinfo.getUserId();
insert testAccount;
Phoenix_Bid__c pb = new Phoenix_Bid__c();
pb.Phoenix_Status__c = 'New';
pb.Phoenix_Comments__c = 'Test Comments';
pb.Phoenix_Customer__c = testAccount.Id;
pb.Phoenix_Customer_Bid_Deadline_Date_Time__c = DateTime.now();
pb.Phoenix_Customer_Bid_Deadline_Time_zone__c = 'PST';
pb.Phoenix_Customer_Bid_Deadline_Time__c = '6 PM';
pb.Phoenix_Customer_Type__c='Direct and Indirect';
pb.Phoenix_Bid_Deadline_Date__c = System.today();
pb.Phoenix_Bid_Type__c='RFP Bids';pb.Phoenix_Approval_Status__c = 'Draft';
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
p3.Phoenix_Product_Director__c = UserInfo.getUserId();
insert p3;
Phoenix_Bid_Line_Item__c bl= new Phoenix_Bid_Line_Item__c();
bl.Phoenix_Bid__c=pb.Id;
bl.Phoenix_Current_Direct_Price__c=10;
bl.Phoenix_Product_Code1__c='300029858';
bl.Phoenix_Product_Family1__c='Daptomycin Inj 500mg US';
bl.Phoenix_Current_Indirect_Selling_Unit__c=10;
bl.Phoenix_Product__c = p2.Id;
bl.Phoenix_Final_Status__c='Approved';
bl.Phoenix_SCM_Approval_Y_N__c = 'Y- Only Current Monthly Demand Approved';
bl.Phoenix_Marketing_Final_Approval__c=true;
insert bl; 
Phoenix_WalgreensCls.getCalcs(bl, bl.id,'No Change','rebateType');
Phoenix_WalgreensCls.deleteLineItems(bl.Id);
}
//by sai krishna
static testmethod void test4(){
//   try{
List<Phoenix_Bid_Line_Item__c> bidlines=new List<Phoenix_Bid_Line_Item__c>();
Account testAccount = new Account(Name = 'Test Account');
testAccount.Phoenix_Contracts_Approver__c=Userinfo.getUserId();
insert testAccount;
Phoenix_Bid__c pb = new Phoenix_Bid__c();
pb.Phoenix_Status__c = 'New';
pb.Phoenix_Comments__c = 'Test Comments';
pb.Phoenix_Customer__c = testAccount.Id;
pb.Phoenix_Customer_Bid_Deadline_Date_Time__c = DateTime.now();
pb.Phoenix_Customer_Bid_Deadline_Time_zone__c = 'PST';
pb.Phoenix_Customer_Bid_Deadline_Time__c = '6 PM';
pb.Phoenix_Customer_Type__c='Direct and Indirect';
pb.Phoenix_Bid_Deadline_Date__c = System.today();
pb.Phoenix_Bid_Type__c='RFP Bids';pb.Phoenix_Approval_Status__c = 'Draft';
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
p3.Phoenix_Product_Director__c = UserInfo.getUserId();
insert p3;
Phoenix_Bid_Line_Item__c bl= new Phoenix_Bid_Line_Item__c();
bl.Phoenix_Bid__c=pb.Id;
bl.Phoenix_Current_Direct_Price__c=10;
bl.Phoenix_Product_Code1__c='300029858';
bl.Phoenix_Product_Family1__c='Daptomycin Inj 500mg US';
bl.Phoenix_Current_Indirect_Selling_Unit__c=10;
bl.Phoenix_Product__c = p2.Id;
bl.Phoenix_Final_Status__c='Approved';
bl.Phoenix_SCM_Approval_Y_N__c = 'Y- Only Current Monthly Demand Approved';
bl.Phoenix_Marketing_Final_Approval__c=true;
insert bl; 
bidlines.add(bl);
Phoenix_Bid_Line_Item__c bl2= new Phoenix_Bid_Line_Item__c();
bl2.Phoenix_Bid__c=pb.Id;
bl2.Phoenix_Current_Direct_Price__c=10;
bl2.Phoenix_Product_Code1__c='300029858';
bl2.Phoenix_Product_Family1__c='Daptomycin Inj 500mg US';
bl2.Phoenix_Current_Indirect_Selling_Unit__c=10;
bl2.Phoenix_Product__c = p2.Id;
bl2.Phoenix_Final_Status__c='Approved';
bl2.Phoenix_SCM_Approval_Y_N__c = 'Y- Only Current Monthly Demand Approved';
bl2.Phoenix_Marketing_Final_Approval__c=true;
insert bl2; 
bidlines.add(bl2);
list<Phoenix_Bid_Process_Steps__c> processStepLsit=new list<Phoenix_Bid_Process_Steps__c>();
Phoenix_Bid_Process_Steps__c bisp=new Phoenix_Bid_Process_Steps__c(); 
bisp.Name='Contracts';
bisp.Phoenix_Bid__c=pb.Id;
bisp.Phoenix_Approver__c =Userinfo.getUserId();
bisp.Phoenix_Approver_Team__c='Contracts';
insert bisp;
processStepLsit.add(bisp);

Phoenix_Bid_Process_Steps__c bisp1=new Phoenix_Bid_Process_Steps__c(); 
bisp1.Name='Marketing';
bisp1.Phoenix_Bid__c=pb.Id;
bisp1.Phoenix_Approver__c =Userinfo.getUserId();
bisp1.Phoenix_Approver_Team__c='Marketing';
insert bisp1;
processStepLsit.add(bisp1);
Phoenix_WalgreensCls.makeApprovalsContracts(pb.id,bidlines,true,true);
Phoenix_WalgreensCls.makeApprovals(pb.id,bidlines,true);
Phoenix_WalgreensCls.updateNextProcessSteps(pb.id,pb.Name,processStepLsit,false,false);

// }catch(exception ex){}

}*/
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
        
      //  Phoenix_DSHCls.updateNextContractProcessSteps(pb.id,pb.name,bidprocess);
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
        Product_Family__c pf = new Product_Family__c();
        pf.Name = 'Test Family';
        insert pf;
        
        Product2 prod1 = new Product2(Name = 'Test Product', Product_Family__c = pf.Id, Family = 'Test Family', IsActive = TRUE, ProductCode = '324');
        insert prod1;
        Phoenix_Bid_Line_Item__c bl = new Phoenix_Bid_Line_Item__c();
        bl.Phoenix_Bid__c = pb.Id;
        bl.Product_Family__c = pf.Id;
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
       // Phoenix_WalgreensCls.CompetitorInfoMethod(pb.id);
        Phoenix_DSHCls.getSubmitBidInfo(pb.id);
        Phoenix_DSHCls.getselectOptions(testAccount,'Testing');
        Phoenix_DSHCls.deleteLineItems(bl.id);
        
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
        pb.Phoenix_Customer_Type__c = 'RXSS';
        insert pb;
        system.assertEquals('RXSS',pb.Phoenix_Customer_Type__c);
        Product_Family__c pf = new Product_Family__c();
        pf.Name = 'Test Family';
        insert pf;
        Product2 prod1 = new Product2(Name = 'Test Product', Product_Family__c = pf.Id, Family = 'Test Family', IsActive = TRUE, ProductCode = '324');
        insert prod1;
        
        Phoenix_Bid_Line_Item__c bl = new Phoenix_Bid_Line_Item__c();
        bl.Phoenix_Bid__c = pb.Id;
        bl.Product_Family__c = pf.Id;
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
        
        Phoenix_DSHCls.getCalcs(bl, bl.id, 'Approved', 'MarketApproval');
        Phoenix_DSHCls.getCalcs(bl, bl.id, 'Line Error- Not Sent', 'ContractApproval');
        Phoenix_DSHCls.getSubmitBidInfo(pb.id);
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
        Product_Family__c pf = new Product_Family__c();
        pf.Name = 'Test Family';
        insert pf;
        Product2 prod1 = new Product2(Name = 'Test Product', Product_Family__c = pf.Id, Family = 'Test Family', IsActive = TRUE, ProductCode = '324');
        insert prod1;
        
        Phoenix_Bid_Line_Item__c bl = new Phoenix_Bid_Line_Item__c();
        bl.Phoenix_Bid__c = pb.Id;
        bl.Product_Family__c = pf.Id;
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
       
        
        Phoenix_DSHCls.getCalcs(bl, bl.id, 'Approved', 'MarketApproval');
        Phoenix_DSHCls.getCalcs(bl, bl.id, 'Line Error- Not Sent', 'ContractApproval');
    }
     static testmethod void getItems6()
    {
         
        list < Phoenix_NPR_Data__c > pnrdata = new list < Phoenix_NPR_Data__c >();   
        map < string, list < Phoenix_NPR_Data__c >> productCodeToNPRLineMap = new map < string, list < Phoenix_NPR_Data__c >> ();
        
        Account testAccount = new Account(Name = 'Test Account',Phoenix_Fee__c = 10,Rebate_Type__c = 'Gross',Phoenix_Cash_Discount__c = 10,Fee_Type__c = 'Gross',Phoenix_Rebates__c = 20,Phoenix_VIP__c = 10 );
        insert testAccount;
        
        Phoenix_Contract__c Cntrct = new Phoenix_Contract__c();
        Cntrct.name = 'taest cntrct';
        Cntrct.Phoenix_Contract_Number__c = '3000000957';
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
        Product_Family__c pf = new Product_Family__c();
        pf.Name = 'Test Family';
        insert pf;
        
        Product2 prod1 = new Product2(Name = 'Test Product', Product_Family__c = pf.Id, Family = 'Test Family', IsActive = TRUE, ProductCode = '324',Phoenix_Product_Director__c = UserInfo.getUserId() ,Phoenix_Marketing_Lead__c = UserInfo.getUserId());
        insert prod1;
        
        Phoenix_Bid_Line_Item__c bl = new Phoenix_Bid_Line_Item__c();
        bl.Phoenix_Bid__c = pb.Id;
        bl.Product_Family__c = pf.Id;
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
            nprdat.Phoenix_Contract_Number__c = '3000000957';
            nprdat.Phoenix_Product__c = prod1.id;
            nprdat.Phoenix_12Months_Sales_Unit__c = 200;
            nprdat.Phoenix_Contract_Type__c = 'InDirect';
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
            nprdata.Phoenix_Contract_Number__c = '3000000957';
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
           Phoenix_DSHCls.getNPRData(new list < string > {
            Cntrct.Phoenix_Contract_Number__c
                }, pb.Id, 'InDirect'); 
         Phoenix_DSHCls.getNPRData(new list < string > {
            Cntrct.Phoenix_Contract_Number__c
                }, pb.Id, 'Direct');
        Phoenix_DSHCls.getNPRDataABCPharmagen(new list < string > {
            Cntrct.Phoenix_Contract_Number__c
                }, pb.Id, 'ABC Pharmagen');
         Phoenix_DSHCls.getNPRDataRXSS(new list < string > {
            Cntrct.Phoenix_Contract_Number__c
                }, pb.Id, 'ABC Pharmagen');
        
        
    }
    
     static testmethod void getItems7()
    {
     list < Phoenix_NPR_Data__c > pnrdata = new list < Phoenix_NPR_Data__c >();   
        map < string, list < Phoenix_NPR_Data__c >> productCodeToNPRLineMap = new map < string, list < Phoenix_NPR_Data__c >> ();
        
        Account testAccount = new Account(Name = 'Test Account',Phoenix_Fee__c = 10,Rebate_Type__c = 'Gross',Phoenix_Cash_Discount__c = 10,Fee_Type__c = 'Gross',Phoenix_Rebates__c = 20,Phoenix_VIP__c = 10 );
        insert testAccount;
        
        Phoenix_Contract__c Cntrct = new Phoenix_Contract__c();
        Cntrct.name = 'taest cntrct';
        Cntrct.Phoenix_Contract_Number__c = '3000001332';
        insert Cntrct;
        
         
                Phoenix_Contract__c Cntrct2 = new Phoenix_Contract__c();
        Cntrct2.name = 'taest cntrct 2';
        Cntrct2.Phoenix_Contract_Number__c = '3000000734';
        insert Cntrct2;
        
        
                Phoenix_Contract__c Cntrct3 = new Phoenix_Contract__c();
        Cntrct3.name = 'taest cntrct 2';
        Cntrct3.Phoenix_Contract_Number__c = '3000000733';
        insert Cntrct3;
        
           Phoenix_Contract__c Cntrct4 = new Phoenix_Contract__c();
        Cntrct4.name = 'taest cntrct 2';
        Cntrct4.Phoenix_Contract_Number__c = '3000000733';
        insert Cntrct4;
        
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
            nprdat.Phoenix_Contract_Number__c = '3000001332';
            nprdat.Phoenix_Product__c = prod1.id;
            nprdat.Phoenix_12Months_Sales_Unit__c = 200;
            nprdat.Phoenix_Contract_Type__c = 'InDirect';
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
            nprdata.Phoenix_Contract__c = Cntrct2.id;
            nprdata.Phoenix_Contract_Number__c = '3000000734';
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
            
            Phoenix_NPR_Data__c nprdata3 = new Phoenix_NPR_Data__c();
            nprdata3.Phoenix_Contract__c = Cntrct3.id;
            nprdata3.Phoenix_Contract_Number__c = '3000000733';
            nprdata3.Phoenix_Product__c = prod1.id;
            nprdata3.Phoenix_12Months_Sales_Unit__c = 200;
            nprdata3.Phoenix_Contract_Type__c = 'Indirect';
            nprdata3.Phoenix_Rebate_G_N_Indicator__c = '10N+ 0G';
            nprdata3.Phoenix_Bonafied_G_N_Indicator__c = '5N+0G';
            nprdata3.Phoenix_12Mt_Sales_Ut_Actual__c = 30;
            nprdata3.Phoenix_Product_Position__c = 'test 2';
            nprdata3.Phoenix_Dead_Net_Tracking_GR__c=12;
            nprdata3.Phoenix_Contract_Price__c = 5;
            nprdata3.Phoenix_12Months_Net_Sales__c=50;
            nprdata3.Phoenix_Per_Unit_Rebate__c = 2;
            nprdata3.Phoenix_ZITD_Value__c=3;
            nprdata3.Phoenix_Rebate__c = 2;
            nprdata3.Phoenix_Rebate_G_N_Indicator__c='test npr 2';
            nprdata3.Phoenix_Bonafied_G_N_Indicator__c = 'test npr ii';      
            nprdata3.Phoenix_Fee_Bonafied_Fee__c=25;
            nprdata3.Phoenix_Per_Unit_Bonfied_Fee__c = 5;
            nprdata3.Phoenix_CD__c = 12;
            nprdata3.Phoenix_GR_TrackingTier__c = 4;
            nprdata3.Phoenix_NPR_Status__c = 'Active';
            pnrdata.add(nprdata3);
            
             
        }
        insert pnrdata;
          
         Phoenix_DSHCls.getNPRDataRXSS(new list < string > {
            Cntrct.Phoenix_Contract_Number__c
                }, pb.Id, 'RXSS');
        Phoenix_DSHCls.getNPRDataRXSS(new list < string > {
            Cntrct2.Phoenix_Contract_Number__c
                }, pb.Id, 'RXSS');
        Phoenix_DSHCls.getNPRDataRXSS(new list < string > {
            Cntrct3.Phoenix_Contract_Number__c
                }, pb.Id, 'RXSS');
            Phoenix_DSHCls.getNPRDataRXSS(new list < string > {
            Cntrct4.Phoenix_Contract_Number__c
                }, pb.Id, 'RXSS');
 
    }
    
    static testmethod void getItems8()
    {
     list < Phoenix_NPR_Data__c > pnrdata = new list < Phoenix_NPR_Data__c >();   
        map < string, list < Phoenix_NPR_Data__c >> productCodeToNPRLineMap = new map < string, list < Phoenix_NPR_Data__c >> ();
        
        Account testAccount = new Account(Name = 'Test Account',Phoenix_Fee__c = 10,Rebate_Type__c = 'Gross',Phoenix_Cash_Discount__c = 10,Fee_Type__c = 'Gross',Phoenix_Rebates__c = 20,Phoenix_VIP__c = 10 );
        insert testAccount;
       
           Phoenix_Contract__c Cntrct4 = new Phoenix_Contract__c();
        Cntrct4.name = 'taest cntrct 2';
        Cntrct4.Phoenix_Contract_Number__c = '1000000627';
        insert Cntrct4;
        
          Phoenix_Contract__c Cntrct5 = new Phoenix_Contract__c();
        Cntrct5.name = 'taest cntrct 2';
        Cntrct5.Phoenix_Contract_Number__c = '1000000870';
        insert Cntrct5;
        
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
        
         Phoenix_NPR_Data__c nprdata6 = new Phoenix_NPR_Data__c();
            nprdata6.Phoenix_Contract__c = Cntrct5.id;
            nprdata6.Phoenix_Contract_Type__c = 'Direct';
            nprdata6.Phoenix_Contract_Number__c = '1000000870';
            nprdata6.Phoenix_Product__c = prod1.id;
            nprdata6.Phoenix_12Months_Sales_Unit__c = 200;
            nprdata6.Phoenix_Rebate_G_N_Indicator__c = '10N+ 0G';
            nprdata6.Phoenix_Bonafied_G_N_Indicator__c = '5N+0G';
            nprdata6.Phoenix_12Mt_Sales_Ut_Actual__c = 30;
            nprdata6.Phoenix_Product_Position__c = 'test 2';
            nprdata6.Phoenix_Dead_Net_Tracking_GR__c=12;
            nprdata6.Phoenix_Contract_Price__c = 5;
            nprdata6.Phoenix_12Months_Net_Sales__c=50;
            nprdata6.Phoenix_Per_Unit_Rebate__c = 2;
            nprdata6.Phoenix_ZITD_Value__c=3;
            nprdata6.Phoenix_Rebate__c = 2;
            nprdata6.Phoenix_Rebate_G_N_Indicator__c='test npr 2';
            nprdata6.Phoenix_Bonafied_G_N_Indicator__c = 'test npr ii';      
            nprdata6.Phoenix_Fee_Bonafied_Fee__c=25;
            nprdata6.Phoenix_Per_Unit_Bonfied_Fee__c = 5;
            nprdata6.Phoenix_CD__c = 12;
            nprdata6.Phoenix_GR_TrackingTier__c = 4;
            nprdata6.Phoenix_NPR_Status__c = 'Active';
        insert nprdata6;
        
        
              Phoenix_DSHCls.getNPRDataRXSS(new list < string > {
            Cntrct4.Phoenix_Contract_Number__c
                }, pb.Id, 'RXSS');
        
        Phoenix_DSHCls.getNPRDataRXSS(new list < string > {
            Cntrct5.Phoenix_Contract_Number__c
                }, pb.Id, 'RXSS');
  
          
    }
     static testmethod void getItems9()
    {
        list < Phoenix_NPR_Data__c > pnrdata = new list < Phoenix_NPR_Data__c >();   
        map < string, list < Phoenix_NPR_Data__c >> productCodeToNPRLineMap = new map < string, list < Phoenix_NPR_Data__c >> ();
        
        Account testAccount = new Account(Name = 'Test Account',Phoenix_Fee__c = 10,Rebate_Type__c = 'Gross',Phoenix_Cash_Discount__c = 10,Fee_Type__c = 'Gross',Phoenix_Rebates__c = 20,Phoenix_VIP__c = 10 );
        insert testAccount;
       
           Phoenix_Contract__c Cntrct4 = new Phoenix_Contract__c();
        Cntrct4.name = 'taest cntrct 2';
        Cntrct4.Phoenix_Contract_Number__c = '3000000762';
        insert Cntrct4;
        
        
           Phoenix_Contract__c Cntrct5 = new Phoenix_Contract__c();
        Cntrct5.name = 'taest cntrct 3';
        Cntrct5.Phoenix_Contract_Number__c = '3000000352';
        insert Cntrct5;
        
        
            
           Phoenix_Contract__c Cntrct55 = new Phoenix_Contract__c();
        Cntrct55.name = 'taest cntrct 3';
        Cntrct55.Phoenix_Contract_Number__c = '3000000589';
        insert Cntrct55;
            
            
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
        
        
        Phoenix_DSHCls.getNPRDataDSH(new list < string > {
            Cntrct4.Phoenix_Contract_Number__c
                }, pb.Id, 'RXSS'); 
        
        Phoenix_DSHCls.getNPRDataDSH(new list < string > {
            Cntrct5.Phoenix_Contract_Number__c
                }, pb.Id, 'RXSS'); 
        
          Phoenix_DSHCls.getNPRDataDSH(new list < string > {
            Cntrct55.Phoenix_Contract_Number__c
                }, pb.Id, 'RXSS'); 
    
    }
    static testmethod void getItems10(){
        
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
        Phoenix_DSHCls.saveLineItemsNewPL(pb.Id,new List<Phoenix_Bid_Line_Item__c>{bl});
        //Phoenix_WalgreensCls.CollectCompetitorInfoRec(pb.Id);
       // Phoenix_WalgreensCls.GetCompetitorNames();
        // Phoenix_WalgreensCls.getCompetitorName();
       // Phoenix_WalgreensCls.fetchUser();
       // Phoenix_WalgreensCls.collectProductFamilyNames(pb.Id);
       // Phoenix_WalgreensCls.CompetitorInfoPF(pb.Id,'m');
       // Phoenix_WalgreensCls.CompetitorInfoMethod(pb.Id);
        
        Competitor_Info__c comp = new Competitor_Info__c();
        comp.Bid_Line_Item__c = bl.Id;
        comp.Bid_No__c = pb.Id;
        insert comp;
        
       // Phoenix_WalgreensCls.updatecominforec(new list<Competitor_Info__c>{comp});
    }
    


}