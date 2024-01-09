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
public class Phoenix_RejectedStatusClsTest {
  static testmethod void getItems() {
    Account testAccount = new Account(Name = 'Test Account');
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

    Phoenix_Bid_Line_Item__c bl1 = new Phoenix_Bid_Line_Item__c();
    bl1.Phoenix_Bid__c = pb.Id;
    bl1.Phoenix_Product__c = prod1.id;
    insert bl1;

    String lineItemId = bl1.Id;

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

    Phoenix_RejectedStatusCls.getRelatedList(pb.id);
    //Phoenix_RejectedStatusCls.getContracts(testAccount.Id, 'a');
   /* Phoenix_RejectedStatusCls.getNPRData(new list < string > {
      Cntrct.Phoenix_Contract_Number__c
    }, pb.Id, 'Direct');
    */
      Phoenix_RejectedStatusCls.updateRelatedList(new list < Phoenix_Bid_Line_Item__c > {
      bl
    });
    Phoenix_RejectedStatusCls.findByProductFamily(new list < string > {
      'lev'
    }, pb.Id, new list < string > {
      'Rx'
    }, new list < string > {
      ''
    });
   /* Phoenix_RejectedStatusCls.saveLineItems(new list < Phoenix_Bid_Line_Item__c > {
      bl
    }, bl.id, 'Gross', 'Gross', true, true);
    */
      Phoenix_RejectedStatusCls.getCalcs(bl, bl.id, 'No Change', 'rebateType'); //Phoenix_IPARejectedLineItemsCls
    Phoenix_RejectedStatusClass.getRelatedList(pb.id);
    Phoenix_RejectedStatusCls.getAllTotals(pb.id);
    Phoenix_RejectedStatusCls.getupdatedforExport(pb.id);
    //Phoenix_RejectedStatusCls.getChildExtnRecord(pb.id);
    
    Phoenix_RejectedStatusClass.getContracts(testAccount.Id, 'a');
    Phoenix_RejectedStatusClass.getNPRData(new list < string > {
      Cntrct.Phoenix_Contract_Number__c
    }, pb.Id, 'Direct');
    Phoenix_RejectedStatusClass.updateRelatedList(new list < Phoenix_Bid_Line_Item__c > {
      bl
    });
    Phoenix_RejectedStatusClass.findByProductFamily(new list < string > {
      'lev'
    }, pb.Id, new list < string > {
      'Rx'
    }, new list < string > {
      ''
    });
    Phoenix_RejectedStatusClass.saveLineItems(new list < Phoenix_Bid_Line_Item__c > {
      bl
    }, bl.id, 'Gross', 'Gross', true, true);
    Phoenix_RejectedStatusClass.getCalcs(bl, bl.id, 'No Change', 'rebateType'); //Phoenix_IPARejectedLineItemsCls
    //Phoenix_RejectedStatusClass.deleteLineItems(bl.id);
    Account acc;
    Phoenix_RejectedStatusClass.getselectOptions(acc, 'Type');
  }
  static testmethod void getItems1() {
    Account testAccount = new Account(Name = 'Test Account');
    insert testAccount;
    Phoenix_Bid__c pb = new Phoenix_Bid__c();
    pb.Phoenix_Status__c = 'New';
    //pb.Phoenix_Comments__c = 'Test Comments';
    pb.Phoenix_Customer__c = testAccount.Id;
    //	pb.Phoenix_Customer_Bid_Deadline_Date_Time__c = DateTime.now();
    pb.Phoenix_Customer_Bid_Deadline_Time_zone__c = 'PST';
    pb.Phoenix_Customer_Bid_Deadline_Time__c = '6 PM';
    pb.Phoenix_Customer_Type__c = 'Direct and Indirect';
    pb.Phoenix_Bid_Deadline_Date__c = System.today();
    insert pb;


    Product2 prod1 = new Product2(Name = 'Test Product', Family = 'Test Family', IsActive = TRUE, ProductCode = '324');
    insert prod1;

    Phoenix_Bid_Line_Item__c bl1 = new Phoenix_Bid_Line_Item__c();
    List < Phoenix_Bid_Line_Item__c > bl2 = new List < Phoenix_Bid_Line_Item__c > ();
    bl1.Phoenix_Bid__c = pb.Id;
    bl1.Phoenix_Product__c = prod1.id;
    bl2.add(bl1);
    insert bl2;

    String lineItemId = bl2[0].Id;

    Phoenix_RejectedStatusCls.getReBidLineInfo(prod1.Id,pb.Id);
        Phoenix_RejectedStatusCls.deleteLineItems(lineItemId);
      
    //Phoenix_RejectedStatusClass.deleteLineItems(lineItemId);
  }
  static testmethod void test1() {
    Account testAccount = new Account(Name = 'Test Account');
    insert testAccount;
    Phoenix_Bid__c pb = new Phoenix_Bid__c();
    pb.Phoenix_Status__c = 'New';
    //pb.Phoenix_Comments__c = 'Test Comments';
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
    Account acc;
    string acci;
    string lid = bl.Id;
    Phoenix_RejectedStatusClass.getselectOptions(acc, 'Type');
    //Phoenix_RejectedStatusClass.getReBidLineInfo(a);
    Phoenix_RejectedStatusClass.deleteLineItems(lid);
     // Phoenix_RejectedStatusClass.getChildExtnRecord(pb.id);

    Phoenix_RejectedStatusCls.getReBidLineInfo(prod1.Id,pb.Id);

  }

}