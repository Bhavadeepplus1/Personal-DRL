@istest
public class Phoenix_ClarusOneClsTest {
  static testmethod void getItems() {
      //try{
      Phoenix_TestDataCreator testData = new Phoenix_TestDataCreator();
      testData.generateBids();
      testData.generateApprovalMatrix();
      Account testAccount = new Account(Name = 'Test Account');
      insert testAccount;
      Phoenix_Product_Position__c pp = new Phoenix_Product_Position__c();
      pp.Phoenix_Customer__c = testAccount.Id;
      pp.Name = 'test';
      insert pp;
      
      Phoenix_Product_Position__c pp1 = new Phoenix_Product_Position__c();
      pp.Phoenix_Customer__c = testAccount.Id;
      pp.Name = 'test1';
      insert pp1;
      
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
        prod1.Phoenix_Marketing_Lead__c = UserInfo.getUserId();
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
      nprdat.Phoenix_Contract_Number__c = '3000000224';
      nprdat.Phoenix_Product__c = prod1.id;
      nprdat.Phoenix_12Months_Sales_Unit__c = 200;
      nprdat.Phoenix_Contract_Type__c = 'Direct';
      nprdat.Phoenix_Rebate_G_N_Indicator__c = '10N+ 0G';
      nprdat.Phoenix_Bonafied_G_N_Indicator__c = '5N+0G';
      insert nprdat;

      List < Phoenix_Approval_Process_Step__c > approvalSteps = [Select Id FROM Phoenix_Approval_Process_Step__c where Phoenix_Order__c = 1 LImit 1];
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
            bisp.Phoenix_Approver_Team__c = 'Marketing';
            
            Phoenix_Bid_Process_Steps__c bisp1 = new Phoenix_Bid_Process_Steps__c();
            bisp1.Name = 'Closed' + i ;
            bisp1.Phoenix_Process_Step__c = ap2.id;
            bisp1.Phoenix_Bid__c = pb.Id;
            bisp1.Phoenix_Approver__c = Userinfo.getUserId();
            bisp1.Phoenix_Approver_Team__c = 'Contracts';
            bidprocess.add(bisp);
            bidprocess.add(bisp1);
            
        }
        insert bidprocess;
      
       Phoenix_ClarusOneCls.submitToProceddStep(pb.id,false,false,'');
       Phoenix_ClarusOneCls.getPositions(testAccount.Id);
       Phoenix_ClarusOneCls.getUpdatedList(pb.id);
      Phoenix_ClarusOneCls.getReBidLineInfo(prod1.Id, pb.id);
      Phoenix_ClarusOneCls.getRelatedList(pb.id);
      Phoenix_ClarusOneCls.getAllTotals(pb.id);
      Phoenix_ClarusOneCls.getupdatedforExport(pb.id);
      Phoenix_ClarusOneCls.getContracts(testAccount.Id, 'a');
      Phoenix_ClarusOneCls.getNPRData(new list < string > {
        Cntrct.Phoenix_Contract_Number__c
      }, pb.Id, 'ClarusOne');
      Phoenix_ClarusOneCls.getNPRData(new list < string > {
        Cntrct.Phoenix_Contract_Number__c
      }, pb.Id, 'ClarusOne');
      Phoenix_Contract__c Cntrct1 = new Phoenix_Contract__c();
      Cntrct1.name = 'taest cntrct1';
      Cntrct1.Phoenix_Contract_Number__c = '3000000224';
      insert Cntrct1;
      Phoenix_Contract__c Cntrct2 = new Phoenix_Contract__c();
      Cntrct2.name = 'taest cntrct2';
      Cntrct2.Phoenix_Contract_Number__c = '1000000120';
      insert Cntrct2;
      Phoenix_Contract__c Cntrct3 = new Phoenix_Contract__c();
      Cntrct3.name = 'taest cntrct3';
      Cntrct3.Phoenix_Contract_Number__c = '3000000143';
      insert Cntrct3;

      Phoenix_NPR_Data__c nprdat1 = new Phoenix_NPR_Data__c();
      nprdat1.Phoenix_Contract__c = Cntrct1.id;
      nprdat1.Phoenix_NPR_Status__c = 'Active';
      nprdat1.Phoenix_Contract_Number__c = '3000000224';
      nprdat1.Phoenix_Product__c = prod1.id;
      nprdat1.Phoenix_12Months_Sales_Unit__c = 200;
      nprdat1.Phoenix_Contract_Type__c = 'Indirect';
      nprdat1.Phoenix_Rebate_G_N_Indicator__c = '10N+ 0G';
      nprdat1.Phoenix_Bonafied_G_N_Indicator__c = '5N+0G';
      nprdat1.Phoenix_Per_Unit_Rebate__c = 123;
      nprdat1.Phoenix_Contract_Price__c = 143;
      insert nprdat1;
      Phoenix_NPR_Data__c nprdat2 = new Phoenix_NPR_Data__c();
      nprdat2.Phoenix_Contract__c = Cntrct2.id;
      nprdat2.Phoenix_NPR_Status__c = 'Active';
      nprdat2.Phoenix_Contract_Number__c = '1000000120';
      nprdat2.Phoenix_Product__c = prod1.id;
      nprdat2.Phoenix_12Months_Sales_Unit__c = 200;
      nprdat2.Phoenix_Contract_Type__c = 'Indirect';
      nprdat2.Phoenix_Rebate_G_N_Indicator__c = '10N+ 0G';
      nprdat2.Phoenix_Bonafied_G_N_Indicator__c = '5N+0G';
      nprdat2.Phoenix_Per_Unit_Rebate__c = 123;
      nprdat2.Phoenix_Contract_Price__c = 143;
      insert nprdat2;
	  
      Phoenix_NPR_Data__c nprdat3 = new Phoenix_NPR_Data__c();
      nprdat3.Phoenix_Contract__c = Cntrct3.id;
      nprdat3.Phoenix_NPR_Status__c = 'Active';
      nprdat3.Phoenix_Contract_Number__c = '3000000143';
      nprdat3.Phoenix_Product__c = prod1.id;
      nprdat3.Phoenix_12Months_Sales_Unit__c = 200;
      nprdat3.Phoenix_Contract_Type__c = 'Indirect';
      nprdat3.Phoenix_Rebate_G_N_Indicator__c = '10N+ 0G';
      nprdat3.Phoenix_Bonafied_G_N_Indicator__c = '5N+0G';
      nprdat3.Phoenix_Per_Unit_Rebate__c = 123;
      nprdat3.Phoenix_Contract_Price__c = 143;
      insert nprdat3;
    
  /*    Phoenix_ClarusOneCls.WrapperForNextSteps nxtStep = new Phoenix_ClarusOneCls.WrapperForNextSteps();
      nxtStep.updateProcessStepList = new List<Phoenix_Bid_Process_Steps__c>{bisp1};
      nxtStep.flagSCMStop = false;
      nxtStep.flagMarketStop = false;*/
       
          
      Phoenix_ClarusOneCls.getNPRData(new list < string > {
        Cntrct1.Phoenix_Contract_Number__c,Cntrct2.Phoenix_Contract_Number__c,Cntrct3.Phoenix_Contract_Number__c
      }, pb.Id, 'ClarusOne');
 		Phoenix_ClarusOneCls.saveLineItemsNewPL(pb.id,new list < Phoenix_Bid_Line_Item__c > {
        bl
      });
      Phoenix_ClarusOneCls.updateRelatedList(new list < Phoenix_Bid_Line_Item__c > {
        bl
      });
      Phoenix_ClarusOneCls.findByProductFamily(new list < string > {
        'lev'
      }, pb.Id, new list < string > {
        'Rx'
      }, new list < string > {
        ''
      });
      List<Phoenix_Bid_Process_Steps__c> processList = [SELECT  Id, Name, Phoenix_Process_Step__r.Name,Phoenix_Bid__c, Phoenix_Is_Criteria_Step__c, Phoenix_Process_Step__c, Phoenix_Step__c, Phoenix_Approver__c, Phoenix_Approver__r.Name, Phoenix_Approver__r.Email, Phoenix_Status__c, Phoenix_Approver_Team__c FROM Phoenix_Bid_Process_Steps__c where Phoenix_Bid__c =: pb.id order by Phoenix_Step__c];
      system.debug('processList---->'+processList.size());
      system.debug('processList---->'+processList);
      Phoenix_ClarusOneCls.updateNextContractProcessSteps(pb.id,pb.Name,processList);
      Phoenix_ClarusOneCls.updateNextProcessSteps(pb.id,pb.Name,processList,false,false);
       //hoenix_ClarusOneCls.deleteLineItems(bl.id);
       Phoenix_ClarusOneCls.getSubmitBidInfo(pb.id);
      Phoenix_ClarusOneCls.saveLineItems(new list < Phoenix_Bid_Line_Item__c > {
        bl,
        bl3
      }, pb.id, 'Gross', 'Gross', 'Sent to Customer', true, true, true, 'Approved', true,'Main','Main');
   //   Phoenix_ClarusOneCls.getCalcs(bl, bl.id, 'No Change', 'rebateType');
      Phoenix_ClarusOneCls.getSubmitBidInfo( bl.id);
     Phoenix_ClarusOneCls.makeApprovals(pb.id, new List < Phoenix_Bid_Line_Item__c > {
        bl
      }, true);
      Phoenix_ClarusOneCls.getUpdatedList( bl.id);
      Phoenix_ClarusOneCls.submitToProceddStep(pb.id, false,false,'');
      Phoenix_ClarusOneCls.updateNextContractProcessSteps(pb.Id, pb.Name,
       processList
     );
      Phoenix_ClarusOneCls.getPositions(testAccount.Id);
//  Phoenix_ClarusOneCls.saveLineItems(new List < Phoenix_Bid_Line_Item__c >{bl},pb.id,'test','test','test',true,true,true,'test',true,'test','test');
      //Phoenix_ClarusOneCls.updateNextProcessSteps(pb.id, pb.Name, 
      // processList
      //, false, false);

 
  //} catch (exception ex) {}


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
        Phoenix_ClarusOneCls.getCalcs(bl, bl.id, 'test 2', 'feeType');
        Phoenix_ClarusOneCls.getCalcs(bl, bl.id, 'Approved', 'MarketApproval');
          Phoenix_ClarusOneCls.deleteLineItems(bl.id);
        Phoenix_ClarusOneCls.fetchUser();
        // Phoenix_ClarusOneCls.getCalcs(bl, bl.id, 'Approved', 'OpportunityBidding');
        
    }
 
}