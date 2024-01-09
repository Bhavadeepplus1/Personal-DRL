/**
 * @description       : 
 * @author            : Surender Dhruvsoft
 * @group             : 
 * @last modified on  : 19-10-2021
 * @last modified by  : Surender Patel (Dhruvsoft)
 * Modifications Log 
 * Ver   Date         Author               Modification
 * 1.0   25-05-2021   Surender Dhruvsoft   Initial Version
 **/
@isTest(SeeAllData = true)
public class Phoenix_SubmitBidForApprovalCtrl_Test {
  static testmethod void holdandrelesebid() {
     
    Account testAccount = new Account(Name = 'Test Account');
        testAccount.Phoenix_Contracts_Approver__c = Userinfo.getUserId();
        insert testAccount;
      
    Phoenix_Bid__c pb = new Phoenix_Bid__c();
    pb.Phoenix_On_Hold__c = false;
    pb.Phoenix_Bid_Deadline_Date__c = System.today();
    pb.Phoenix_Customer__c=testAccount.Id;
    insert pb;
    
    Phoenix_Bid__c pb2 = new Phoenix_Bid__c();
    pb2.Phoenix_On_Hold__c = true;
    pb2.Phoenix_Bid_Deadline_Date__c = System.today();
    insert pb2;
    
    Phoenix_Bid_Hold_History__c ph=new Phoenix_Bid_Hold_History__c();
    //ph.Phoenix_release_time__c=Time.newInstance(12, 20, 0, 0);
    ph.Phoenix_hold_time__c=System.Now();
   // ph.Phoenix_hold_duration__c=2;
    ph.Phoenix_Bid_Approval_Status__c='hold';
    ph.Phoenix_Bid__c=pb2.Id;
    insert ph;
      
    Phoenix_Approval_Matrix__c pam=new Phoenix_Approval_Matrix__c();
        pam.Name='Marketing Lead Rx Approval';
        insert pam;
      
    Phoenix_Approval_Process_Step__c pap=new Phoenix_Approval_Process_Step__c();
        pap.Phoenix_Approver__c=UserInfo.getUserId();
        pap.Name='Marketing Lead Rx Approval';
        pap.Phoenix_Approval_Matrix__c=pam.Id;
        insert pap;
      
    Phoenix_Bid_Process_Steps__c ps = new Phoenix_Bid_Process_Steps__c();
        ps.Phoenix_Approver__c = UserInfo.getUserId();
        ps.Phoenix_Is_Criteria_Step__c = false;
        ps.Phoenix_Status__c = 'In Process';
        ps.Phoenix_Process_Step__c=pap.Id;
        ps.Phoenix_Bid__c = pb.Id;
        insert ps;
    
    Phoenix_SubmitBidForApprovalCtrl.holdBid(pb.Id);
    Phoenix_SubmitBidForApprovalCtrl.releaseBid(pb2.Id);
    Phoenix_SubmitBidForApprovalCtrl.getBidDetails(pb.Id);
    Phoenix_SubmitBidForApprovalCtrl.getLowestPrice(pb.Id);
    Phoenix_SubmitBidForApprovalCtrl.codeCoverage();
        //Phoenix_SubmitBidForApprovalCtrl.coverageBlock();
  }
  static testmethod void getLowestPrice() {
      
      Account testAccount = new Account(Name = 'Test Account');
      testAccount.Phoenix_Contracts_Approver__c = Userinfo.getUserId();
      
      insert testAccount;
      
    Phoenix_Bid__c pb = new Phoenix_Bid__c();
    pb.Phoenix_Comments__c = 'Test Comments';
    pb.Phoenix_Bid_Deadline_Date__c = System.today();
    pb.Phoenix_Approval_Status__c='Draft';
    pb.Phoenix_On_Hold__c=false;
    pb.Phoenix_Customer__c=testAccount.Id;
    pb.Phoenix_Bid_Type__c='Volume Review Only';

    insert pb;
      
    Product2 prod1 = new Product2(Name = 'Test Product', Family = 'Test Family', IsActive = TRUE, ProductCode = '324');
    insert prod1;
    
    List<Phoenix_Bid_Line_Item__c> pbList=new List<Phoenix_Bid_Line_Item__c>();
    Phoenix_Bid_Line_Item__c pbl1 = new Phoenix_Bid_Line_Item__c();
    pbl1.Phoenix_Bid__c = pb.Id;
    pbl1.Phoenix_Is_New_Low_Triggered__c = true;
    pbl1.Phoenix_Approved_Lowest_Price_SKU__c = 10;
    pbl1.Phoenix_Product__c = prod1.id;
    pbl1.Phoenix_Final_Status__c = 'Approved';
   	pbList.add(pbl1);
      
    Phoenix_Bid_Line_Item__c pbl2 = new Phoenix_Bid_Line_Item__c();
    pbl2.Phoenix_Bid__c = pb.Id;
    pbl2.Phoenix_Is_New_Low_Triggered__c = true;
    pbl2.Phoenix_Approved_Lowest_Price_SKU__c = 10;
    //bl.Phoenix_Product__c = prod1.id;
    pbl2.Phoenix_Final_Status__c = 'Approved';
   	pbList.add(pbl2);
    
    insert pbList;
      
    Phoenix_Bid_Line_Item__c bl = new Phoenix_Bid_Line_Item__c();
    bl.Phoenix_Bid__c = pb.Id;
    bl.Phoenix_Is_New_Low_Triggered__c = true;
    bl.Phoenix_Approved_Lowest_Price_SKU__c = 10;
    bl.Phoenix_Product__c = prod1.id;
    bl.Phoenix_Final_Status__c = 'Approved';
    insert bl;
     
    Phoenix_Bid_Line_Item__c bl1 = new Phoenix_Bid_Line_Item__c();
    bl1.Phoenix_Bid__c = pb.Id;
    bl1.Phoenix_Is_New_Low_Triggered__c = true;
    bl1.Phoenix_Approved_Lowest_Price_SKU__c = 10;
    //bl.Phoenix_Product__c = prod1.id;
    bl1.Phoenix_Final_Status__c = 'Approved';
    insert bl1;
      
    Phoenix_Bid__c pb2 = new Phoenix_Bid__c();
    pb2.Phoenix_On_Hold__c = true;
    pb2.Phoenix_Bid_Deadline_Date__c = System.today();
    insert pb2;
    
     Phoenix_Approval_Matrix__c pam=new Phoenix_Approval_Matrix__c();
        pam.Name='Marketing Lead Rx Approval';
        insert pam;
  
            Phoenix_Approval_Process_Step__c rfpStep1 = new  Phoenix_Approval_Process_Step__c(Name='Marketing Lead Rx Approval',Phoenix_Order__c = 1,Phoenix_Is_Notification_Only__c = false,Phoenix_Approval_Matrix__c=pam.Id);
            insert rfpStep1;
            
            Phoenix_Approval_Process_Step__c rfpStep2 = new  Phoenix_Approval_Process_Step__c(Name='Contract Team\'s Action',Phoenix_Order__c = 2,Phoenix_Is_Notification_Only__c = false,Phoenix_Approver_Team__c='Marketing',Phoenix_Approval_Matrix__c=pam.Id,Phoenix_Approver__c=UserInfo.getUserId());
             insert rfpStep2;
            
            Phoenix_Approval_Process_Step__c rfpStep3 = new  Phoenix_Approval_Process_Step__c(Name='Marketing Lead OTC Approval',Phoenix_Order__c = 3,Phoenix_Is_Notification_Only__c = false,Phoenix_Approver_Team__c='Finance',Phoenix_Approval_Matrix__c=pam.Id);
             insert rfpStep3;
                                                                                              
            Phoenix_Approval_Process_Step__c rfpStep4 = new  Phoenix_Approval_Process_Step__c(Name='Marketing Head Approval',Phoenix_Order__c = 4,Phoenix_Is_Notification_Only__c = false,Phoenix_Approver_Team__c='Contracts',Phoenix_Approval_Matrix__c=pam.Id);
            insert rfpStep4;        
      
    /*Phoenix_Approval_Process_Step__c pap=new Phoenix_Approval_Process_Step__c();
        pap.Phoenix_Approver__c=UserInfo.getUserId();
        pap.Name='Marketing Lead Rx Approval';
        pap.Phoenix_Approval_Matrix__c=pam.Id;
      	pap.Phoenix_Process_Step__c=rfpStep1.Id;
        insert pap;*/
      List<Phoenix_Bid_Process_Steps__c> bprocessList=new List<Phoenix_Bid_Process_Steps__c>();
       Phoenix_Bid_Process_Steps__c bStep=new Phoenix_Bid_Process_Steps__c();
        bStep.Phoenix_Is_Criteria_Step__c = false;
        bStep.Name= 'Contract Team\'s Action';
        bStep.Phoenix_Process_Step__c=	rfpStep1.Id;
        bStep.Phoenix_Approver__c = UserInfo.getUserId();
        bStep.Phoenix_Bid__c = pb.Id;
        bStep.Phoenix_Sub_Step__c = 1;
      	//bStep.Phoenix_Step__c=1;
      	bprocessList.add(bStep);
      
       	Phoenix_Bid_Process_Steps__c bStep1=new Phoenix_Bid_Process_Steps__c();
        bStep1.Phoenix_Is_Criteria_Step__c = false;
        bStep1.Name= pb.Name+'-'+'Contract Team\'s Action';
        bStep1.Phoenix_Process_Step__c=	rfpStep2.Id;
        bStep1.Phoenix_Approver__c = UserInfo.getUserId();
        bStep1.Phoenix_Bid__c = pb.Id;
        bStep1.Phoenix_Sub_Step__c = 1;
      	bprocessList.add(bStep1);
      
      	insert bprocessList;
      
      List<Phoenix_Approval_Grid__c> pagList=new List<Phoenix_Approval_Grid__c>();
        Phoenix_Approval_Grid__c pag=new Phoenix_Approval_Grid__c();
		pag.Phoenix_Product_Family__c='Product Family';
		pag.Phoenix_Is_partner_product__c=true;
		pag.Phoenix_Sr_Director_VP_Finance_Comments__c='Noted';
		//pag.Phoenix_Is_Mkg_Head_Noti_Required__c=true;
		pag.Phoenix_Is_SVP_Notification_Required__c=true;
		pag.Phoenix_Sr_Director_VP__c='Approved';
		pag.Phoenix_Is_Mkg_Head_Noti_Required__c=true;
        pag.Phoenix_isMarketingRxLeadApproved__c=true;
		pag.Phoenix_Is_SVP_Notification_Required__c=true;
		pag.Phoenix_Sr_Director_VP__c='Approved';
		pag.Phoenix_Comments__c='Noted';
		pag.Phoenix_Approval__c='Approved';
		pag.Phoenix_Business_Head_Comments__c='Noted';
		pag.Phoenix_Marketing_Lead_OTC__c='Approved';
		pag.Phoenix_Marketing_Lead_SRx__c='Approved';
		pag.Phoenix_GM_Limit__c='Noted';
		pag.Phoenix_Marketing_Lead_Rx__c='Approved';
		pag.Phoenix_GM__c=2;
		pag.Phoenix_Revenue_Limit__c='Noted';
		pag.Phoenix_Revenue__c=2;
		pag.Phoenix_Annualized_GM_Impact_Limit__c='Noted';
		pag.Phoenix_Annualized_TP_Impact__c=3;
        pag.Phoenix_Annualized_GM_Impact__c=4;
		pag.Phoenix_Annualized_TP__c=3;
		pag.Phoenix_Annualized_TP_Impact_Limit__c='Noted';
      	pag.Phoenix_isRx__c=true;
		//pag.Phoenix_Annualized_TP__c=4;
       // pag.Phoenix_Is_New_Low__c=true;
        pag.Phoenix_Bid__c=pb.Id;
      	pag.Phoenix_Bid_Line_Item__c=bl.Id;
		insert pag;
      String str='Test';
      String str1='Test1';
      
      Phoenix_SubmitBidForApprovalCtrl.getLowestPrice(pb.Id);
      Phoenix_SubmitBidForApprovalCtrl.getLowestPrice(null);
      Phoenix_SubmitBidForApprovalCtrl.holdBid(null);
      Phoenix_SubmitBidForApprovalCtrl.holdBid(pb.Id);
      Phoenix_SubmitBidForApprovalCtrl.releaseBid(null);
      Phoenix_SubmitBidForApprovalCtrl.getBidInfo(null);
      Phoenix_SubmitBidForApprovalCtrl.updateLowestPrice(pb.Id);
   // Phoenix_SubmitBidForApprovalCtrl.recallBidToContracts(pb.Id);
      Phoenix_SubmitBidForApprovalCtrl.recallBidToScm1(pb.Id);
      Phoenix_SubmitBidForApprovalCtrl.sendForApproval(pb.Id,str,bprocessList,str1);
      Phoenix_SubmitBidForApprovalCtrl.approvalRequestNotificationOld(pb.Id,bprocessList);
      Phoenix_SubmitBidForApprovalCtrl.sendEmailToProdDirVolReview(pb.Id);
      Phoenix_SubmitBidForApprovalCtrl.sendEmailToAllApproversforProductsDeactivation(pb.Id,pbList);
      Phoenix_SubmitBidForApprovalCtrl.sendEmailToAllApproversforProductRemoval(pb.Id,pbList);
      //Phoenix_SubmitBidForApprovalCtrl.sendWACChangeEmailToFinanceTeam(pb.Id);
      
  }

    static testmethod void SubmitBidforApproval() {
        Account testAccount = new Account(Name = 'Test Account');
        testAccount.Phoenix_Contracts_Approver__c = Userinfo.getUserId();
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
        pb.Phoenix_Bid_Type__c = 'RFP Bids';
        pb.Phoenix_Approval_Status__c = 'Draft';
        insert pb;
        Product2 p2 = new Product2();
        p2.Family = 'Daptomycin Inj 500mg US';
        p2.Name = 'Test';
        p2.ProductCode = '300029858';
        p2.Phoenix_Marketing_Lead__c = UserInfo.getUserId();
        p2.Phoenix_Product_Director__c = UserInfo.getUserId();
        insert p2;
        Product2 p3 = new Product2();
        p3.Family = 'Abiraterone Acetate Tab';
        p3.ProductCode = '300029858';
        p3.Name = 'Test Product';
        p3.Phoenix_Product_Director__c = UserInfo.getUserId();
        p3.Phoenix_Marketing_Lead__c = UserInfo.getUserId();
        p3.Phoenix_Product_Director__c = UserInfo.getUserId();
        insert p3;
        Phoenix_Bid_Line_Item__c bl = new Phoenix_Bid_Line_Item__c();
        bl.Phoenix_Bid__c = pb.Id;
        bl.Phoenix_Current_Direct_Price__c = 10;
        bl.Phoenix_Product_Code1__c = '300029858';
        bl.Phoenix_Product_Family1__c = 'Daptomycin Inj 500mg US';
        bl.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        bl.Phoenix_Product__c = p2.Id;
        bl.Phoenix_Final_Status__c = 'Approved';
        bl.Phoenix_SCM_Approval_Y_N__c = 'Y- Only Current Monthly Demand Approved';
        bl.Phoenix_Marketing_Final_Approval__c = true;
        insert bl;
        Phoenix_Bid_Line_Item__c bl1 = new Phoenix_Bid_Line_Item__c();
        bl1.Phoenix_Bid__c = pb.Id;
        bl1.Phoenix_Final_Status__c = 'Approved';
        bl1.Phoenix_Current_Direct_Price__c = 10;
        bl1.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        bl1.Phoenix_Product__c = p3.Id;
        bl1.Phoenix_SCM_Approval_Y_N__c = 'Y- Only Current Monthly Demand Approved';
        bl1.Phoenix_Marketing_Final_Approval__c = true;
        insert bl1;
        Phoenix_Bid_Line_Item__c bl2 = new Phoenix_Bid_Line_Item__c();
        bl2.Phoenix_Bid__c = pb.Id;
        bl2.Phoenix_Final_Status__c = 'Approved';
        bl2.Phoenix_Current_Direct_Price__c = 10;
        bl2.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        bl2.Phoenix_Product__c = p3.Id;
        bl2.Phoenix_SCM_Approval_Y_N__c = 'N- Not Approved';
        bl2.Phoenix_Marketing_Final_Approval__c = true;
        insert bl2;
        //
        Phoenix_Bid_Process_Steps__c ps = new Phoenix_Bid_Process_Steps__c();
        ps.Phoenix_Approver__c = UserInfo.getUserId();
        ps.Phoenix_Bid__c = pb.Id;
        insert ps;
        //
        Map < String, Map < String, String >> financeApprovalMap = new Map < String, Map < String, String >> ();
        Map < String, Map < String, String >> financeCommentMap = new Map < String, Map < String, String >> ();
        Map < String, String > fieldsMap = new Map < String, String > ();
        Map < String, String > fieldsMap1 = new Map < String, String > ();
        Set < Id > blitemSet = new Set < Id > ();
        blitemSet.add(bl2.Id);
        blitemSet.add(bl1.Id);
        
        fieldsMap.put('SCM Comments', 'test');
        fieldsMap1.put('SCM Rejection Reason', 'test');
        financeApprovalMap.put(bl.Id, fieldsMap);
        financeCommentMap.put(bl1.Id, fieldsMap1);
        Phoenix_TestDataCreator testData = new Phoenix_TestDataCreator();
        Phoenix_SubmitBidForApprovalCtrl.BidWrapper wrap = new Phoenix_SubmitBidForApprovalCtrl.BidWrapper();
        wrap.bid = pb;
        testData.generateApprovalMatrix();
        Phoenix_SubmitBidForApprovalCtrl.SCMProductRejectionNotification(wrap.bid.Id);
        Phoenix_SubmitBidForApprovalCtrl.getBidInfo(wrap.bid.Id);
        Phoenix_SubmitBidForApprovalCtrl.calculateFinanceGrid(wrap.bid.Id);
        Phoenix_SubmitBidForApprovalCtrl.submitBid(wrap);
        Phoenix_SubmitBidForApprovalCtrl.BidRejectionEmailNotificationToAll(blitemSet,pb.Id);
        Phoenix_SubmitBidForApprovalCtrl.recallBid(wrap.bid.Id, 'Draft');
        //Phoenix_SubmitBidForApprovalCtrl.recallBidToContracts(pb.Id);
       
        
        
    }
    static testmethod void SubmitBidforApproval212() {
        Account testAccount = new Account(Name = 'Test Account');
        testAccount.Phoenix_Contracts_Approver__c = Userinfo.getUserId();
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
        pb.Phoenix_Bid_Type__c = 'OTC RFP';
        pb.Phoenix_is_OTC_Bid__c = true;
        pb.Phoenix_Approval_Status__c = 'Draft';
        insert pb;
        Product2 p2 = new Product2();
        p2.Family = 'Daptomycin Inj 500mg US';
        p2.Name = 'Test';
        p2.ProductCode = '300029858';
        p2.Phoenix_Marketing_Lead__c = UserInfo.getUserId();
        p2.Phoenix_Product_Director__c = UserInfo.getUserId();
        insert p2;
        Product2 p3 = new Product2();
        p3.Family = 'Abiraterone Acetate Tab';
        p3.ProductCode = '300029858';
        p3.Name = 'Test Product';
        p3.Phoenix_Product_Director__c = UserInfo.getUserId();
        p3.Phoenix_Marketing_Lead__c = UserInfo.getUserId();
        p3.Phoenix_Product_Director__c = UserInfo.getUserId();
        insert p3;
        Phoenix_Bid_Line_Item__c bl = new Phoenix_Bid_Line_Item__c();
        bl.Phoenix_Bid__c = pb.Id;
        bl.Phoenix_Current_Direct_Price__c = 10;
        bl.Phoenix_Product_Code1__c = '300029858';
        bl.Phoenix_Product_Family1__c = 'Daptomycin Inj 500mg US';
        bl.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        bl.Phoenix_Product__c = p2.Id;
        bl.Phoenix_Orange_Book_Rating1__c ='Version 2';
        bl.Phoenix_Final_Status__c = 'Approved';
        bl.Phoenix_SCM_Approval_Y_N__c = 'Y- Only Current Monthly Demand Approved';
        bl.Phoenix_Marketing_Final_Approval__c = true;
        insert bl;
        Phoenix_Bid_Line_Item__c bl1 = new Phoenix_Bid_Line_Item__c();
        bl1.Phoenix_Bid__c = pb.Id;
        bl1.Phoenix_Final_Status__c = 'Approved';
        bl1.Phoenix_Current_Direct_Price__c = 10;
        bl1.Phoenix_Orange_Book_Rating1__c ='Version 2';
        bl1.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        bl1.Phoenix_Product__c = p3.Id;
        bl1.Phoenix_SCM_Approval_Y_N__c = 'Y- Only Current Monthly Demand Approved';
        bl1.Phoenix_Marketing_Final_Approval__c = true;
        insert bl1;
        Phoenix_Bid_Line_Item__c bl2 = new Phoenix_Bid_Line_Item__c();
        bl2.Phoenix_Bid__c = pb.Id;
        bl2.Phoenix_Orange_Book_Rating1__c ='Version 2';
        bl2.Phoenix_Final_Status__c = 'Approved';
        bl2.Phoenix_Current_Direct_Price__c = 10;
        bl2.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        bl2.Phoenix_Product__c = p3.Id;
        bl2.Phoenix_SCM_Approval_Y_N__c = 'N- Not Approved';
        bl2.Phoenix_Marketing_Final_Approval__c = true;
        insert bl2;
        Phoenix_RCA_IPA_LINE__c R1 = new Phoenix_RCA_IPA_LINE__c();
        R1.Phoenix_Bid__c =pb.Id;
        Insert R1;
        //
        Phoenix_Bid_Process_Steps__c ps = new Phoenix_Bid_Process_Steps__c();
        ps.Phoenix_Approver__c = UserInfo.getUserId();
        ps.Phoenix_Bid__c = pb.Id;
        insert ps;
        //
        Map < String, Map < String, String >> financeApprovalMap = new Map < String, Map < String, String >> ();
        Map < String, Map < String, String >> financeCommentMap = new Map < String, Map < String, String >> ();
        Map < String, String > fieldsMap = new Map < String, String > ();
        Map < String, String > fieldsMap1 = new Map < String, String > ();
        Set < Id > blitemSet = new Set < Id > ();
        blitemSet.add(bl2.Id);
        blitemSet.add(bl1.Id);
        
        fieldsMap.put('SCM Comments', 'test');
        fieldsMap1.put('SCM Rejection Reason', 'test');
        financeApprovalMap.put(bl.Id, fieldsMap);
        financeCommentMap.put(bl1.Id, fieldsMap1);
        Phoenix_TestDataCreator testData = new Phoenix_TestDataCreator();
        Phoenix_SubmitBidForApprovalCtrl.BidWrapper wrap = new Phoenix_SubmitBidForApprovalCtrl.BidWrapper();
        wrap.bid = pb;
        testData.generateApprovalMatrix();
        Phoenix_SubmitBidForApprovalCtrl.recallBid(pb.Id, 'Draft');
        
    }
    
    static testmethod void SubmitBidforApproval2() {
    Account testAccount = new Account(Name = 'Test Account');
    testAccount.Phoenix_Contracts_Approver__c = Userinfo.getUserId();
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
    pb.Phoenix_Bid_Type__c = 'RFP Bids';
    pb.Phoenix_Approval_Status__c = 'Draft';
    insert pb;
    Product2 p2 = new Product2();
    p2.Family = 'Daptomycin Inj 500mg US';
    p2.Name = 'Test';
    p2.ProductCode = '300029858';
    p2.Phoenix_Marketing_Lead__c = UserInfo.getUserId();
    p2.Phoenix_Product_Director__c = UserInfo.getUserId();
    insert p2;
    Product2 p3 = new Product2();
    p3.Family = 'Abiraterone Acetate Tab';
    p3.ProductCode = '300029858';
    p3.Name = 'Test Product';
    p3.Phoenix_Product_Director__c = UserInfo.getUserId();
    p3.Phoenix_Marketing_Lead__c = UserInfo.getUserId();
    p3.Phoenix_Product_Director__c = UserInfo.getUserId();
    insert p3;
    Phoenix_Bid_Line_Item__c bl = new Phoenix_Bid_Line_Item__c();
    bl.Phoenix_Bid__c = pb.Id;
    bl.Phoenix_Current_Direct_Price__c = 10;
    bl.Phoenix_Product_Code1__c = '300029858';
    bl.Phoenix_Product_Family1__c = 'Daptomycin Inj 500mg US';
    bl.Phoenix_Current_Indirect_Selling_Unit__c = 10;
    bl.Phoenix_Product__c = p2.Id;
    bl.Phoenix_Final_Status__c = 'Approved';
    bl.Phoenix_SCM_Approval_Y_N__c = 'Y- Only Current Monthly Demand Approved';
    bl.Phoenix_Marketing_Final_Approval__c = true;
    insert bl;
    Phoenix_Bid_Line_Item__c bl1 = new Phoenix_Bid_Line_Item__c();
    bl1.Phoenix_Bid__c = pb.Id;
    bl1.Phoenix_Final_Status__c = 'Approved';
    bl1.Phoenix_Current_Direct_Price__c = 10;
    bl1.Phoenix_Current_Indirect_Selling_Unit__c = 10;
    bl1.Phoenix_Product__c = p3.Id;
    bl1.Phoenix_SCM_Approval_Y_N__c = 'Y- Only Current Monthly Demand Approved';
    bl1.Phoenix_Marketing_Final_Approval__c = true;
    insert bl1;
    Phoenix_Bid_Line_Item__c bl2 = new Phoenix_Bid_Line_Item__c();
    bl2.Phoenix_Bid__c = pb.Id;
    bl2.Phoenix_Final_Status__c = 'Approved';
    bl2.Phoenix_Current_Direct_Price__c = 10;
    bl2.Phoenix_Current_Indirect_Selling_Unit__c = 10;
    bl2.Phoenix_Product__c = p3.Id;
    bl2.Phoenix_SCM_Approval_Y_N__c = 'N- Not Approved';
    bl2.Phoenix_Marketing_Final_Approval__c = true;
    insert bl2;
    //
    Phoenix_Bid_Process_Steps__c ps = new Phoenix_Bid_Process_Steps__c();
    ps.Phoenix_Approver__c = UserInfo.getUserId();
    ps.Phoenix_Bid__c = pb.Id;
    insert ps;
    //
    Map < String, Map < String, String >> financeApprovalMap = new Map < String, Map < String, String >> ();
    Map < String, Map < String, String >> financeCommentMap = new Map < String, Map < String, String >> ();
    Map < String, String > fieldsMap = new Map < String, String > ();
    Map < String, String > fieldsMap1 = new Map < String, String > ();
    Set < Id > blitemSet = new Set < Id > ();
    blitemSet.add(bl2.Id);
    blitemSet.add(bl1.Id);

    fieldsMap.put('SCM Comments', 'test');
    fieldsMap1.put('SCM Rejection Reason', 'test');
    financeApprovalMap.put(bl.Id, fieldsMap);
    financeCommentMap.put(bl1.Id, fieldsMap1);
    Phoenix_TestDataCreator testData = new Phoenix_TestDataCreator();
    Phoenix_SubmitBidForApprovalCtrl.BidWrapper wrap = new Phoenix_SubmitBidForApprovalCtrl.BidWrapper();
    wrap.bid = pb;
    testData.generateApprovalMatrix();
    Phoenix_SubmitBidForApprovalCtrl.SCMProductRejectionNotification(wrap.bid.Id);

    Phoenix_SubmitBidForApprovalCtrl.getBidInfo(wrap.bid.Id);
    //
    Phoenix_SubmitBidForApprovalCtrl.calculateFinanceGrid(wrap.bid.Id);
    Phoenix_SubmitBidForApprovalCtrl.submitBid(wrap);
    Phoenix_SubmitBidForApprovalCtrl.BidRejectionEmailNotificationToAll(blitemSet,pb.Id);
    Phoenix_SubmitBidForApprovalCtrl.recallBid(wrap.bid.Id, 'SCM');
  }

  static testmethod void SubmitBidforApprovalrecall() {
    Account testAccount = new Account(Name = 'Test Account');
    testAccount.Phoenix_Contracts_Approver__c = Userinfo.getUserId();
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
    pb.Phoenix_Bid_Type__c = 'RFP Bids';
    pb.Phoenix_Approval_Status__c = 'Draft';
    insert pb;
    Product2 p2 = new Product2();
    p2.Family = 'Daptomycin Inj 500mg US';
    p2.Name = 'Test';
    p2.ProductCode = '300029858';
    p2.Phoenix_Marketing_Lead__c = UserInfo.getUserId();
    p2.Phoenix_Product_Director__c = UserInfo.getUserId();
    insert p2;
    Product2 p3 = new Product2();
    p3.Family = 'Abiraterone Acetate Tab';
    p3.ProductCode = '300029858';
    p3.Name = 'Test Product';
    p3.Phoenix_Product_Director__c = UserInfo.getUserId();
    p3.Phoenix_Marketing_Lead__c = UserInfo.getUserId();
    p3.Phoenix_Product_Director__c = UserInfo.getUserId();
    insert p3;
    Phoenix_Bid_Line_Item__c bl = new Phoenix_Bid_Line_Item__c();
    bl.Phoenix_Bid__c = pb.Id;
    bl.Phoenix_Current_Direct_Price__c = 10;
    bl.Phoenix_Product_Code1__c = '300029858';
    bl.Phoenix_Product_Family1__c = 'Daptomycin Inj 500mg US';
    bl.Phoenix_Current_Indirect_Selling_Unit__c = 10;
    bl.Phoenix_Product__c = p2.Id;
    bl.Phoenix_Final_Status__c = 'Approved';
    bl.Phoenix_SCM_Approval_Y_N__c = 'Y- Only Current Monthly Demand Approved';
    bl.Phoenix_Marketing_Final_Approval__c = true;
    insert bl;
    Phoenix_Bid_Line_Item__c bl1 = new Phoenix_Bid_Line_Item__c();
    bl1.Phoenix_Bid__c = pb.Id;
    bl1.Phoenix_Final_Status__c = 'Approved';
    bl1.Phoenix_Current_Direct_Price__c = 10;
    bl1.Phoenix_Current_Indirect_Selling_Unit__c = 10;
    bl1.Phoenix_Product__c = p3.Id;
    bl1.Phoenix_SCM_Approval_Y_N__c = 'Y- Only Current Monthly Demand Approved';
    bl1.Phoenix_Marketing_Final_Approval__c = true;
    insert bl1;
    Phoenix_Bid_Line_Item__c bl2 = new Phoenix_Bid_Line_Item__c();
    bl2.Phoenix_Bid__c = pb.Id;
    bl2.Phoenix_Final_Status__c = 'Approved';
    bl2.Phoenix_Current_Direct_Price__c = 10;
    bl2.Phoenix_Current_Indirect_Selling_Unit__c = 10;
    bl2.Phoenix_Product__c = p3.Id;
    bl2.Phoenix_SCM_Approval_Y_N__c = 'N- Not Approved';
    bl2.Phoenix_Marketing_Final_Approval__c = true;
    insert bl2;
    //
    Phoenix_Bid_Process_Steps__c ps = new Phoenix_Bid_Process_Steps__c();
    ps.Phoenix_Approver__c = UserInfo.getUserId();
    ps.Phoenix_Bid__c = pb.Id;
    insert ps;
    //
    Map < String, Map < String, String >> financeApprovalMap = new Map < String, Map < String, String >> ();
    Map < String, Map < String, String >> financeCommentMap = new Map < String, Map < String, String >> ();
    Map < String, String > fieldsMap = new Map < String, String > ();
    Map < String, String > fieldsMap1 = new Map < String, String > ();
    Set < Id > blitemSet = new Set < Id > ();
    blitemSet.add(bl2.Id);
    blitemSet.add(bl1.Id);

    fieldsMap.put('SCM Comments', 'test');
    fieldsMap1.put('SCM Rejection Reason', 'test');
    financeApprovalMap.put(bl.Id, fieldsMap);
    financeCommentMap.put(bl1.Id, fieldsMap1);
    Phoenix_TestDataCreator testData = new Phoenix_TestDataCreator();
    Phoenix_SubmitBidForApprovalCtrl.BidWrapper wrap = new Phoenix_SubmitBidForApprovalCtrl.BidWrapper();
    wrap.bid = pb;
    testData.generateApprovalMatrix();
    Phoenix_SubmitBidForApprovalCtrl.SCMProductRejectionNotification(wrap.bid.Id);

    Phoenix_SubmitBidForApprovalCtrl.getBidInfo(wrap.bid.Id);
    //
    Phoenix_SubmitBidForApprovalCtrl.calculateFinanceGrid(wrap.bid.Id);
    Phoenix_SubmitBidForApprovalCtrl.submitBid(wrap);
    Phoenix_SubmitBidForApprovalCtrl.BidRejectionEmailNotificationToAll(blitemSet,pb.Id);
    Phoenix_SubmitBidForApprovalCtrl.recallBid(wrap.bid.Id, 'SCMMarketing');
  }


  static testmethod void SubmitBidforApprovalrecall33() {
    Account testAccount = new Account(Name = 'Test Account');
    testAccount.Phoenix_Contracts_Approver__c = Userinfo.getUserId();
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
    pb.Phoenix_Bid_Type__c = 'RFP Bids';
    pb.Phoenix_Approval_Status__c = 'Draft';
    insert pb;
    Product2 p2 = new Product2();
    p2.Family = 'Daptomycin Inj 500mg US';
    p2.Name = 'Test';
    p2.ProductCode = '300029858';
    p2.Phoenix_Marketing_Lead__c = UserInfo.getUserId();
    p2.Phoenix_Product_Director__c = UserInfo.getUserId();
    insert p2;
    Product2 p3 = new Product2();
    p3.Family = 'Abiraterone Acetate Tab';
    p3.ProductCode = '300029858';
    p3.Name = 'Test Product';
    p3.Phoenix_Product_Director__c = UserInfo.getUserId();
    p3.Phoenix_Marketing_Lead__c = UserInfo.getUserId();
    p3.Phoenix_Product_Director__c = UserInfo.getUserId();
    insert p3;
    Phoenix_Bid_Line_Item__c bl = new Phoenix_Bid_Line_Item__c();
    bl.Phoenix_Bid__c = pb.Id;
    bl.Phoenix_Current_Direct_Price__c = 10;
    bl.Phoenix_Product_Code1__c = '300029858';
    bl.Phoenix_Product_Family1__c = 'Daptomycin Inj 500mg US';
    bl.Phoenix_Current_Indirect_Selling_Unit__c = 10;
    bl.Phoenix_Product__c = p2.Id;
    bl.Phoenix_Final_Status__c = 'Approved';
    bl.Phoenix_SCM_Approval_Y_N__c = 'Y- Only Current Monthly Demand Approved';
    bl.Phoenix_Marketing_Final_Approval__c = true;
    insert bl;
    Phoenix_Bid_Line_Item__c bl1 = new Phoenix_Bid_Line_Item__c();
    bl1.Phoenix_Bid__c = pb.Id;
    bl1.Phoenix_Final_Status__c = 'Approved';
    bl1.Phoenix_Current_Direct_Price__c = 10;
    bl1.Phoenix_Current_Indirect_Selling_Unit__c = 10;
    bl1.Phoenix_Product__c = p3.Id;
    bl1.Phoenix_SCM_Approval_Y_N__c = 'Y- Only Current Monthly Demand Approved';
    bl1.Phoenix_Marketing_Final_Approval__c = true;
    insert bl1;
    Phoenix_Bid_Line_Item__c bl2 = new Phoenix_Bid_Line_Item__c();
    bl2.Phoenix_Bid__c = pb.Id;
    bl2.Phoenix_Final_Status__c = 'Approved';
    bl2.Phoenix_Current_Direct_Price__c = 10;
    bl2.Phoenix_Current_Indirect_Selling_Unit__c = 10;
    bl2.Phoenix_Product__c = p3.Id;
    bl2.Phoenix_SCM_Approval_Y_N__c = 'N- Not Approved';
    bl2.Phoenix_Marketing_Final_Approval__c = true;
    insert bl2;
    //
    Phoenix_Bid_Process_Steps__c ps = new Phoenix_Bid_Process_Steps__c();
    ps.Phoenix_Approver__c = UserInfo.getUserId();
    ps.Phoenix_Bid__c = pb.Id;
    insert ps;
    //
    Map < String, Map < String, String >> financeApprovalMap = new Map < String, Map < String, String >> ();
    Map < String, Map < String, String >> financeCommentMap = new Map < String, Map < String, String >> ();
    Map < String, String > fieldsMap = new Map < String, String > ();
    Map < String, String > fieldsMap1 = new Map < String, String > ();
    Set < Id > blitemSet = new Set < Id > ();
    blitemSet.add(bl2.Id);
    blitemSet.add(bl1.Id);

    fieldsMap.put('SCM Comments', 'test');
    fieldsMap1.put('SCM Rejection Reason', 'test');
    financeApprovalMap.put(bl.Id, fieldsMap);
    financeCommentMap.put(bl1.Id, fieldsMap1);
    Phoenix_TestDataCreator testData = new Phoenix_TestDataCreator();
    Phoenix_SubmitBidForApprovalCtrl.BidWrapper wrap = new Phoenix_SubmitBidForApprovalCtrl.BidWrapper();
    wrap.bid = pb;
    testData.generateApprovalMatrix();
    Phoenix_SubmitBidForApprovalCtrl.SCMProductRejectionNotification(wrap.bid.Id);

    Phoenix_SubmitBidForApprovalCtrl.getBidInfo(wrap.bid.Id);
    //
    Phoenix_SubmitBidForApprovalCtrl.calculateFinanceGrid(wrap.bid.Id);
    Phoenix_SubmitBidForApprovalCtrl.submitBid(wrap);
    Phoenix_SubmitBidForApprovalCtrl.BidRejectionEmailNotificationToAll(blitemSet,pb.Id);
    Phoenix_SubmitBidForApprovalCtrl.recallBid(wrap.bid.Id, 'MarketingAll');
  }

  static testmethod void SubmitBidforApprovalrecall35() {
    Account testAccount = new Account(Name = 'Test Account');
    testAccount.Phoenix_Contracts_Approver__c = Userinfo.getUserId();
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
    pb.Phoenix_Bid_Type__c = 'RFP Bids';
    pb.Phoenix_Approval_Status__c = 'Draft';
    insert pb;
    Product2 p2 = new Product2();
    p2.Family = 'Daptomycin Inj 500mg US';
    p2.Name = 'Test';
    p2.ProductCode = '300029858';
    p2.Phoenix_Marketing_Lead__c = UserInfo.getUserId();
    p2.Phoenix_Product_Director__c = UserInfo.getUserId();
    insert p2;
    Product2 p3 = new Product2();
    p3.Family = 'Abiraterone Acetate Tab';
    p3.ProductCode = '300029858';
    p3.Name = 'Test Product';
    p3.Phoenix_Product_Director__c = UserInfo.getUserId();
    p3.Phoenix_Marketing_Lead__c = UserInfo.getUserId();
    p3.Phoenix_Product_Director__c = UserInfo.getUserId();
    insert p3;
    Phoenix_Bid_Line_Item__c bl = new Phoenix_Bid_Line_Item__c();
    bl.Phoenix_Bid__c = pb.Id;
    bl.Phoenix_Current_Direct_Price__c = 10;
    bl.Phoenix_Product_Code1__c = '300029858';
    bl.Phoenix_Product_Family1__c = 'Daptomycin Inj 500mg US';
    bl.Phoenix_Current_Indirect_Selling_Unit__c = 10;
    bl.Phoenix_Product__c = p2.Id;
    bl.Phoenix_Final_Status__c = 'Approved';
    bl.Phoenix_SCM_Approval_Y_N__c = 'Y- Only Current Monthly Demand Approved';
    bl.Phoenix_Marketing_Final_Approval__c = true;
    insert bl;
    Phoenix_Bid_Line_Item__c bl1 = new Phoenix_Bid_Line_Item__c();
    bl1.Phoenix_Bid__c = pb.Id;
    bl1.Phoenix_Final_Status__c = 'Approved';
    bl1.Phoenix_Current_Direct_Price__c = 10;
    bl1.Phoenix_Current_Indirect_Selling_Unit__c = 10;
    bl1.Phoenix_Product__c = p3.Id;
    bl1.Phoenix_SCM_Approval_Y_N__c = 'Y- Only Current Monthly Demand Approved';
    bl1.Phoenix_Marketing_Final_Approval__c = true;
    insert bl1;
    Phoenix_Bid_Line_Item__c bl2 = new Phoenix_Bid_Line_Item__c();
    bl2.Phoenix_Bid__c = pb.Id;
    bl2.Phoenix_Final_Status__c = 'Approved';
    bl2.Phoenix_Current_Direct_Price__c = 10;
    bl2.Phoenix_Current_Indirect_Selling_Unit__c = 10;
    bl2.Phoenix_Product__c = p3.Id;
    bl2.Phoenix_SCM_Approval_Y_N__c = 'N- Not Approved';
    bl2.Phoenix_Marketing_Final_Approval__c = true;
    insert bl2;
    //
    Phoenix_Bid_Process_Steps__c ps = new Phoenix_Bid_Process_Steps__c();
    ps.Phoenix_Approver__c = UserInfo.getUserId();
    ps.Phoenix_Bid__c = pb.Id;
    insert ps;
    //
    Map < String, Map < String, String >> financeApprovalMap = new Map < String, Map < String, String >> ();
    Map < String, Map < String, String >> financeCommentMap = new Map < String, Map < String, String >> ();
    Map < String, String > fieldsMap = new Map < String, String > ();
    Map < String, String > fieldsMap1 = new Map < String, String > ();
    Set < Id > blitemSet = new Set < Id > ();
    blitemSet.add(bl2.Id);
    blitemSet.add(bl1.Id);

    fieldsMap.put('SCM Comments', 'test');
    fieldsMap1.put('SCM Rejection Reason', 'test');
    financeApprovalMap.put(bl.Id, fieldsMap);
    financeCommentMap.put(bl1.Id, fieldsMap1);
    Phoenix_TestDataCreator testData = new Phoenix_TestDataCreator();
    Phoenix_SubmitBidForApprovalCtrl.BidWrapper wrap = new Phoenix_SubmitBidForApprovalCtrl.BidWrapper();
    wrap.bid = pb;
    testData.generateApprovalMatrix();
    Phoenix_SubmitBidForApprovalCtrl.SCMProductRejectionNotification(wrap.bid.Id);

    Phoenix_SubmitBidForApprovalCtrl.getBidInfo(wrap.bid.Id);
    //
    Phoenix_SubmitBidForApprovalCtrl.calculateFinanceGrid(wrap.bid.Id);
    Phoenix_SubmitBidForApprovalCtrl.submitBid(wrap);
    Phoenix_SubmitBidForApprovalCtrl.BidRejectionEmailNotificationToAll(blitemSet,pb.Id);
   // Phoenix_SubmitBidForApprovalCtrl.recallBid(wrap.bid.Id, 'Contracts');
  }



  static testmethod void SubmitBidforApprovalrecall34() {
    Account testAccount = new Account(Name = 'Test Account');
    testAccount.Phoenix_Contracts_Approver__c = Userinfo.getUserId();
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
    pb.Phoenix_Bid_Type__c = 'RFP Bids';
    pb.Phoenix_Approval_Status__c = 'Draft';
    insert pb;
    Product2 p2 = new Product2();
    p2.Family = 'Daptomycin Inj 500mg US';
    p2.Name = 'Test';
    p2.ProductCode = '300029858';
    p2.Phoenix_Marketing_Lead__c = UserInfo.getUserId();
    p2.Phoenix_Product_Director__c = UserInfo.getUserId();
    insert p2;
    Product2 p3 = new Product2();
    p3.Family = 'Abiraterone Acetate Tab';
    p3.ProductCode = '300029858';
    p3.Name = 'Test Product';
    p3.Phoenix_Product_Director__c = UserInfo.getUserId();
    p3.Phoenix_Marketing_Lead__c = UserInfo.getUserId();
    p3.Phoenix_Product_Director__c = UserInfo.getUserId();
    insert p3;
    Phoenix_Bid_Line_Item__c bl = new Phoenix_Bid_Line_Item__c();
    bl.Phoenix_Product_Director1__c=Userinfo.getName();
    bl.Phoenix_Bid__c = pb.Id;
    bl.Phoenix_Current_Direct_Price__c = 10;
    bl.Phoenix_Product_Code1__c = '300029858';
    bl.Phoenix_Product_Family1__c = 'Daptomycin Inj 500mg US';
    bl.Phoenix_Current_Indirect_Selling_Unit__c = 10;
    bl.Phoenix_Product__c = p2.Id;
    bl.Phoenix_Final_Status__c = 'Approved';
    bl.Phoenix_SCM_Approval_Y_N__c = 'Y- Only Current Monthly Demand Approved';
    bl.Phoenix_Marketing_Final_Approval__c = true;
    insert bl;
    Phoenix_Bid_Line_Item__c bl1 = new Phoenix_Bid_Line_Item__c();
    bl1.Phoenix_Product_Director1__c=Userinfo.getName();
    bl1.Phoenix_Bid__c = pb.Id;
    bl1.Phoenix_Final_Status__c = 'Approved';
    bl1.Phoenix_Current_Direct_Price__c = 10;
    bl1.Phoenix_Current_Indirect_Selling_Unit__c = 10;
    bl1.Phoenix_Product__c = p3.Id;
    bl1.Phoenix_SCM_Approval_Y_N__c = 'Y- Only Current Monthly Demand Approved';
    bl1.Phoenix_Marketing_Approval__c='Approved';
    bl1.Phoenix_Marketing_Final_Approval__c = true;
    insert bl1;
    Phoenix_Bid_Line_Item__c bl2 = new Phoenix_Bid_Line_Item__c();
    bl2.Phoenix_Product_Director1__c=Userinfo.getName();
    bl2.Phoenix_Bid__c = pb.Id;
    bl2.Phoenix_Final_Status__c = 'Approved';
    bl2.Phoenix_Current_Direct_Price__c = 10;
    bl2.Phoenix_Current_Indirect_Selling_Unit__c = 10;
    bl2.Phoenix_Product__c = p3.Id;
    bl2.Phoenix_SCM_Approval_Y_N__c = 'N- Not Approved';
    bl2.Phoenix_Marketing_Final_Approval__c = true;
    insert bl2;
    //
    Phoenix_Bid_Process_Steps__c ps = new Phoenix_Bid_Process_Steps__c();
    ps.Phoenix_Approver__c = UserInfo.getUserId();
    ps.Phoenix_Bid__c = pb.Id;
    insert ps;
    //
    Map < String, Map < String, String >> financeApprovalMap = new Map < String, Map < String, String >> ();
    Map < String, Map < String, String >> financeCommentMap = new Map < String, Map < String, String >> ();
    Map < String, String > fieldsMap = new Map < String, String > ();
    Map < String, String > fieldsMap1 = new Map < String, String > ();
    Set < Id > blitemSet = new Set < Id > ();
    blitemSet.add(bl2.Id);
    blitemSet.add(bl1.Id);

    fieldsMap.put('SCM Comments', 'test');
    fieldsMap1.put('SCM Rejection Reason', 'test');
    financeApprovalMap.put(bl.Id, fieldsMap);
    financeCommentMap.put(bl1.Id, fieldsMap1);
    Phoenix_TestDataCreator testData = new Phoenix_TestDataCreator();
    Phoenix_SubmitBidForApprovalCtrl.BidWrapper wrap = new Phoenix_SubmitBidForApprovalCtrl.BidWrapper();
    wrap.bid = pb;
    testData.generateApprovalMatrix();
    Phoenix_SubmitBidForApprovalCtrl.SCMProductRejectionNotification(wrap.bid.Id);

    Phoenix_SubmitBidForApprovalCtrl.getBidInfo(wrap.bid.Id);
    //
    Phoenix_SubmitBidForApprovalCtrl.calculateFinanceGrid(wrap.bid.Id);
    Phoenix_SubmitBidForApprovalCtrl.submitBid(wrap);
    Phoenix_SubmitBidForApprovalCtrl.BidRejectionEmailNotificationToAll(blitemSet,pb.Id);
    Phoenix_SubmitBidForApprovalCtrl.recallBid(wrap.bid.Id, 'MarketingOne');
  }

static testmethod void SubmitBidforApprovalrecall345() {
    Account testAccount = new Account(Name = 'Test Account');
    testAccount.Phoenix_Contracts_Approver__c = Userinfo.getUserId();
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
    pb.Phoenix_Bid_Type__c = 'RFP Bids';
    pb.Phoenix_Approval_Status__c = 'Draft';
    insert pb;
    Product2 p2 = new Product2();
    p2.Family = 'Daptomycin Inj 500mg US';
    p2.Name = 'Test';
    p2.ProductCode = '300029858';
    p2.Phoenix_Marketing_Lead__c = UserInfo.getUserId();
    p2.Phoenix_Product_Director__c = UserInfo.getUserId();
    insert p2;
    Product2 p3 = new Product2();
    p3.Family = 'Abiraterone Acetate Tab';
    p3.ProductCode = '300029858';
    p3.Name = 'Test Product';
    p3.Phoenix_Product_Director__c = UserInfo.getUserId();
    p3.Phoenix_Marketing_Lead__c = UserInfo.getUserId();
    p3.Phoenix_Product_Director__c = UserInfo.getUserId();
    insert p3;
    Phoenix_Bid_Line_Item__c bl = new Phoenix_Bid_Line_Item__c();
    bl.Phoenix_Bid__c = pb.Id;
    bl.Phoenix_Current_Direct_Price__c = 10;
    bl.Phoenix_Product_Code1__c = '300029858';
    bl.Phoenix_Product_Family1__c = 'Daptomycin Inj 500mg US';
    bl.Phoenix_Current_Indirect_Selling_Unit__c = 10;
    bl.Phoenix_Product__c = p2.Id;
    bl.Phoenix_Final_Status__c = 'Approved';
    bl.Phoenix_SCM_Approval_Y_N__c = 'Y- Only Current Monthly Demand Approved';
    bl.Phoenix_Marketing_Final_Approval__c = true;
    insert bl;
    Phoenix_Bid_Line_Item__c bl1 = new Phoenix_Bid_Line_Item__c();
    bl1.Phoenix_Bid__c = pb.Id;
    bl1.Phoenix_Final_Status__c = 'Approved';
    bl1.Phoenix_Current_Direct_Price__c = 10;
    bl1.Phoenix_Current_Indirect_Selling_Unit__c = 10;
    bl1.Phoenix_Product__c = p3.Id;
    bl1.Phoenix_SCM_Approval_Y_N__c = 'Y- Only Current Monthly Demand Approved';
    bl1.Phoenix_Marketing_Final_Approval__c = true;
    insert bl1;
    Phoenix_Bid_Line_Item__c bl2 = new Phoenix_Bid_Line_Item__c();
    bl2.Phoenix_Bid__c = pb.Id;
    bl2.Phoenix_Final_Status__c = 'Approved';
    bl2.Phoenix_Current_Direct_Price__c = 10;
    bl2.Phoenix_Current_Indirect_Selling_Unit__c = 10;
    bl2.Phoenix_Product__c = p3.Id;
    bl2.Phoenix_SCM_Approval_Y_N__c = 'N- Not Approved';
    bl2.Phoenix_Marketing_Final_Approval__c = true;
    insert bl2;
    //
    Phoenix_Approval_Matrix__c matrix = new Phoenix_Approval_Matrix__c();
    matrix.Name = 'Finance Approval';
    Insert matrix;
    Phoenix_Approval_Process_Step__c appstep = new Phoenix_Approval_Process_Step__c();
    appstep.Phoenix_Order__c = 3.0;
    appstep.Name = 'Finance Approval';
    appstep.Phoenix_Approval_Matrix__c = matrix.Id;
    Insert appstep;
    Phoenix_Bid_Process_Steps__c ps = new Phoenix_Bid_Process_Steps__c();
    ps.Phoenix_Approver__c = UserInfo.getUserId();
    ps.Phoenix_Process_Step__c =appstep.Id;
    ps.Phoenix_Bid__c = pb.Id;
    ps.Name = 'Finance Approval';
    insert ps;
     Phoenix_Approval_Process_Step__c appstep2 = new Phoenix_Approval_Process_Step__c();
    appstep2.Phoenix_Order__c = 2.0;
    appstep2.Name = 'Marketing Approval';
    appstep2.Phoenix_Approval_Matrix__c = matrix.Id;
    Insert appstep2;
    Phoenix_Bid_Process_Steps__c ps2 = new Phoenix_Bid_Process_Steps__c();
    ps2.Phoenix_Approver__c = UserInfo.getUserId();
    ps2.Phoenix_Process_Step__c =appstep.Id;
    ps2.Phoenix_Bid__c = pb.Id;
    ps2.Name = 'Marketing Approval';
    insert ps2;
    //
    Phoenix_SubmitBidForApprovalCtrl.recallBid(pb.Id, 'MarketingOne');
  }
    
  static testmethod void test1() {
    Phoenix_TestDataCreator testData = new Phoenix_TestDataCreator();
    testData.generateBids();
    Phoenix_SubmitBidForApprovalCtrl.getBidInfo(testData.bidsList[0].Id);
    //
    Phoenix_SubmitBidForApprovalCtrl.calculateFinanceGrid(testData.bidsList[0].Id);

  }

  static testmethod void test2() {
    Phoenix_TestDataCreator testData = new Phoenix_TestDataCreator();
    testData.generateBids();
    Phoenix_SubmitBidForApprovalCtrl.BidWrapper wrap = new Phoenix_SubmitBidForApprovalCtrl.BidWrapper();
    wrap.bid = testData.bidsList[0];

    testData.generateApprovalMatrix();
    Phoenix_SubmitBidForApprovalCtrl.submitBid(wrap);

  }

  static testmethod void test3() {
    Phoenix_TestDataCreator testData = new Phoenix_TestDataCreator();
    testData.generateBids();
    Phoenix_SubmitBidForApprovalCtrl.BidWrapper wrap = new Phoenix_SubmitBidForApprovalCtrl.BidWrapper();
    wrap.bid = testData.bidsList[0];

    testData.generateApprovalMatrix();

    System.runAs(testData.users[0]) {
      Phoenix_SubmitBidForApprovalCtrl.submitBid(wrap);

    }
  }

  static testmethod void test4() {
    Phoenix_TestDataCreator testData = new Phoenix_TestDataCreator();

    testData.generateBids();
    Phoenix_Bid__c bid = testData.bidsList[1];
    Account acc = new Account(Name = 'Name');
    insert acc;

    bid.Phoenix_Customer__c = acc.Id;
    update bid;
	//Commented by Shashirekha
    /*Phoenix_Bid_VIP_Rebate__c rebate = new Phoenix_Bid_VIP_Rebate__c(Phoenix_Bid__c = bid.Id,
      Phoenix_Customer__c = acc.Id, Phoenix_Start_Date__c = System.today(),
      Phoenix_End_Date__c = System.today() + 10, Phoenix_Status__c = 'Proposed', Phoenix_Type__c = 'Currency'
    );

    insert rebate;*/



    Phoenix_SubmitBidForApprovalCtrl.getBidInfo(bid.Id);
    Phoenix_SubmitBidForApprovalCtrl.BidWrapper wrap = new Phoenix_SubmitBidForApprovalCtrl.BidWrapper();
    wrap.bid = bid;
    testData.generateApprovalMatrix();
    Phoenix_SubmitBidForApprovalCtrl.submitBid(wrap);
  }
  static testmethod void test5() {
    Phoenix_TestDataCreator testData = new Phoenix_TestDataCreator();
    testData.generateBids();
    Phoenix_SubmitBidForApprovalCtrl.getBidInfo(testData.bidsList[2].Id);
    Phoenix_SubmitBidForApprovalCtrl.BidWrapper wrap = new Phoenix_SubmitBidForApprovalCtrl.BidWrapper();
    wrap.bid = testData.bidsList[2];
    testData.generateApprovalMatrix();
    Phoenix_SubmitBidForApprovalCtrl.submitBid(wrap);
  }
  static testmethod void test6() {
    Phoenix_TestDataCreator testData = new Phoenix_TestDataCreator();
    testData.generateBids();
    Phoenix_SubmitBidForApprovalCtrl.getBidInfo(testData.bidsList[3].Id);
    Phoenix_SubmitBidForApprovalCtrl.BidWrapper wrap = new Phoenix_SubmitBidForApprovalCtrl.BidWrapper();
    wrap.bid = testData.bidsList[3];
    testData.generateApprovalMatrix();
    Phoenix_SubmitBidForApprovalCtrl.submitBid(wrap);
  }
  static testmethod void test7() {
    Phoenix_TestDataCreator testData = new Phoenix_TestDataCreator();
    testData.generateBids();
    Phoenix_SubmitBidForApprovalCtrl.getBidInfo(testData.bidsList[4].Id);
    Phoenix_SubmitBidForApprovalCtrl.BidWrapper wrap = new Phoenix_SubmitBidForApprovalCtrl.BidWrapper();
    wrap.bid = testData.bidsList[4];
    testData.generateApprovalMatrix();
    Phoenix_SubmitBidForApprovalCtrl.submitBid(wrap);

  }
  @isTest static void SubmitBidforApproval8() {
    Account testAccount = new Account(Name = 'Test Account');
    testAccount.Phoenix_Contracts_Approver__c = Userinfo.getUserId();
    insert testAccount;
    Phoenix_Bid__c pb = new Phoenix_Bid__c();
    pb.Phoenix_Status__c = 'New';
    pb.Phoenix_Comments__c = 'Test Comments';
    pb.Phoenix_Customer__c = testAccount.Id;
    pb.Phoenix_Customer_Bid_Deadline_Date_Time__c = DateTime.now();
    pb.Phoenix_Customer_Bid_Deadline_Time_zone__c = 'PST';
    pb.Phoenix_Customer_Bid_Deadline_Time__c = '6 PM';
    // pb.Phoenix_Customer_Type__c='Direct and Indirect';
    pb.Phoenix_Bid_Deadline_Date__c = System.today();
    pb.Phoenix_Bid_Type__c = 'Contracts Only';
    pb.Phoenix_Approval_Status__c = 'Draft';
    insert pb;
    Phoenix_SubmitBidForApprovalCtrl.getBidInfo(pb.Id);
  }
  @isTest static void SubmitBidforApproval9() {
    Account testAccount = new Account(Name = 'Test Account');
    testAccount.Phoenix_Contracts_Approver__c = Userinfo.getUserId();
    insert testAccount;
    Phoenix_Bid__c pb = new Phoenix_Bid__c();
    pb.Phoenix_Status__c = 'New';
    pb.Phoenix_Comments__c = 'Test Comments';
    pb.Phoenix_Customer__c = testAccount.Id;
    pb.Phoenix_Customer_Bid_Deadline_Date_Time__c = DateTime.now();
    pb.Phoenix_Customer_Bid_Deadline_Time_zone__c = 'PST';
    pb.Phoenix_Customer_Bid_Deadline_Time__c = '6 PM';
    // pb.Phoenix_Customer_Type__c='Direct and Indirect';
    pb.Phoenix_Bid_Deadline_Date__c = System.today();
    pb.Phoenix_Bid_Type__c = 'WAC Change Submissions';
    pb.Phoenix_Approval_Status__c = 'Draft';
    insert pb;
    Phoenix_SubmitBidForApprovalCtrl.getBidInfo(pb.Id);
  }

  @isTest static void EmailTestingMethods() {
    Phoenix_TestDataCreator testData = new Phoenix_TestDataCreator();
    testData.generateProducts();
    testData.generateUsers();
    Account testAccount = new Account(Name = 'Test');
    testAccount.Phoenix_Contracts_Approver__c = Userinfo.getUserId();
    insert testAccount;

    Product2 p2 = new Product2();
    p2.Family = 'Daptomycin Inj 500mg US';
    p2.Name = 'Test';
    p2.ProductCode = '300029858';
    p2.Phoenix_Marketing_Lead__c = UserInfo.getUserId();
    p2.Phoenix_Product_Director__c = testData.users[0].Id;
    insert p2;

    Phoenix_Bid__c pb = new Phoenix_Bid__c();
    pb.Phoenix_Status__c = 'New';
    pb.Phoenix_Comments__c = 'Test Comments';
    pb.Phoenix_Customer__c = testAccount.Id;
    pb.Phoenix_Customer_Bid_Deadline_Date_Time__c = DateTime.now();
    pb.Phoenix_Customer_Bid_Deadline_Time_zone__c = 'PST';
    pb.Phoenix_Customer_Bid_Deadline_Time__c = '6 PM';
    pb.Phoenix_Customer_Type__c = 'Direct and Indirect';
    pb.Phoenix_Bid_Deadline_Date__c = System.today();
    pb.Phoenix_Bid_Type__c = 'WAC Change Submissions';
    pb.Phoenix_Approval_Status__c = 'Draft';
    pb.Phoenix_Internal_Target_Date__c = Date.parse('10/12/2021');
    pb.Phoenix_Sales_Person_2__c = UserInfo.getUserId();
    insert pb;

    Phoenix_Bid_Line_Item__c bl = new Phoenix_Bid_Line_Item__c();
    bl.Phoenix_Bid__c = pb.Id;
    bl.Phoenix_Current_Direct_Price__c = 10;
    bl.Phoenix_Product_Code1__c = '300029858';
    bl.Phoenix_Product_Family1__c = 'Daptomycin Inj 500mg US';
    bl.Phoenix_Current_Indirect_Selling_Unit__c = 10;
    bl.Phoenix_Product__c = testData.productList[0].Id;
    bl.Phoenix_Final_Status__c = 'Approved';
    bl.Phoenix_SCM_Approval_Y_N__c = 'Y- Only Current Monthly Demand Approved';
    bl.Phoenix_Marketing_Final_Approval__c = true;
    //insert bl;
    Phoenix_Bid_Line_Item__c b2 = new Phoenix_Bid_Line_Item__c();
    b2.Phoenix_Bid__c = pb.Id;
    b2.Phoenix_Current_Direct_Price__c = 10;
    b2.Phoenix_Product_Code1__c = '300029858';
    b2.Phoenix_Product_Family1__c = 'Daptomycin Inj 500mg US';
    b2.Phoenix_Current_Indirect_Selling_Unit__c = 10;
    b2.Phoenix_Product__c = p2.Id;
    b2.Phoenix_Final_Status__c = 'Approved';
    b2.Phoenix_SCM_Approval_Y_N__c = 'Y- Only Current Monthly Demand Approved';
    b2.Phoenix_Marketing_Final_Approval__c = true;
    b2.Phoenix_SCM_Approved_Quantity__c = 20;
    insert b2;

    Phoenix_Customer_Response__c recb2 = new Phoenix_Customer_Response__c();
    recb2.Phoenix_Bid_No__c = pb.Id;
    insert recb2;

    Phoenix_Customer_Response_Line__c recb3 = new Phoenix_Customer_Response_Line__c();
    recb3.Phoenix_Awarded_Quantity__c = 210;
    recb3.Phoenix_Bid__c = pb.Id;
    recb3.Phoenix_Customer_Response__c = recb2.Id;
    recb3.Phoenix_Bid_Line_Item__c = bl.Id;
    recb3.Phoenix_Customer_status_internal_use__c = 'Not Approved';
    recb3.Phoenix_Bid_Status__c = 'Awarded';
    insert recb3;
    Phoenix_Customer_Response_Line__c recb4 = new Phoenix_Customer_Response_Line__c();
    recb4.Phoenix_Awarded_Quantity__c = 220;
    recb4.Phoenix_Bid__c = pb.Id;
    recb4.Phoenix_Customer_Response__c = recb2.Id;
    recb4.Phoenix_Bid_Line_Item__c = bl.Id;
    recb4.Phoenix_Customer_status_internal_use__c = 'Approved';
    recb4.Phoenix_Bid_Status__c = 'Declined by Customer	';
    insert recb4;
    Phoenix_Bid_Process_Steps__c ps = new Phoenix_Bid_Process_Steps__c();
    ps.Phoenix_Bid__c = pb.Id;
    ps.Phoenix_Approver_Team__c = 'Home Office';
    ps.Phoenix_Approver__c = UserInfo.getUserId();
    ps.Phoenix_Approver_Team_Members__c = 'Surender Patel';
    insert ps;
    string crid = recb2.Id;
    List < Phoenix_Bid_Process_Steps__c > nextSteps = new list < Phoenix_Bid_Process_Steps__c > ();
    String str;
    String str2;
    Phoenix_Bid_Process_Steps__c n = new Phoenix_Bid_Process_Steps__c();
    n.Phoenix_Status__c = 'Submitted';
    n.Phoenix_Approver_Team__c = 'Marketing';
    insert n;
    nextSteps.add(n);
     
    //Phoenix_SubmitBidForApprovalCtrl.sendEmailToVistexTeam(testAccount.Id, pb.Id);
    Phoenix_SubmitBidForApprovalCtrl.approvalRequestNotification(pb.Id, nextSteps);
    pb.Phoenix_Approval_Status__c = 'Closed';
    //   Update pb;
    List < Id > bidIds = new List < Id > ();
    Phoenix_Bid__c pb5 = new Phoenix_Bid__c();

    pb5.Phoenix_Approval_Status__c = 'Draft';

    insert pb5;
    bidIds.add(pb5.Id);
      
    Phoenix_SubmitBidForApprovalCtrl.BidClosureNotification(bidIds);
    Phoenix_SubmitBidForApprovalCtrl.SCMPartialApprovalNotification(pb.Id);
  }
    
  @isTest static void NDCVistex() {
    Phoenix_TestDataCreator testData = new Phoenix_TestDataCreator();
    testData.generateProducts();
    testData.generateUsers();
    Account testAccount = new Account(Name = 'Test Email Account');
    testAccount.Phoenix_Contracts_Approver__c = Userinfo.getUserId();
    insert testAccount;

    Product2 p2 = new Product2();
    p2.Family = 'Daptomycin Inj 500mg US';
    p2.Name = 'Test';
    p2.ProductCode = '300029858';
    p2.Phoenix_Marketing_Lead__c = UserInfo.getUserId();
    p2.Phoenix_Product_Director__c = testData.users[0].Id;
    insert p2;

    Phoenix_NDC_Change__c pb = new Phoenix_NDC_Change__c();
    pb.Phoenix_Approval_Status__c = 'Draft';
    insert pb;

    Phoenix_NDC_Change_Line_Item__c bl = new Phoenix_NDC_Change_Line_Item__c();
    bl.Phoenix_NDC_Change__c = pb.Id;
    bl.Pheonix_Customer_Approval__c = 'Approved';
    bl.Phoenix_is_Vistex_Noti_Sent__c = false;
    insert bl;
    Phoenix_NDC_Change_Line_Item__c b2 = new Phoenix_NDC_Change_Line_Item__c();
    b2.Phoenix_NDC_Change__c = pb.Id;
    b2.Pheonix_Customer_Approval__c = 'Not Approved';
    b2.Phoenix_is_Vistex_Noti_Sent__c = false;
    insert b2;

    Phoenix_Bid_Process_Steps__c ps = new Phoenix_Bid_Process_Steps__c();
    ps.Phoenix_NDC_Change__c = pb.Id;
    ps.Phoenix_Approver_Team__c = 'Home Office';
    ps.Phoenix_Approver__c = UserInfo.getUserId();
    ps.Phoenix_Approver_Team_Members__c = 'Surender Patel';
    insert ps;
    List < Phoenix_Bid_Process_Steps__c > nextSteps = new list < Phoenix_Bid_Process_Steps__c > ();
    Phoenix_Bid_Process_Steps__c n = new Phoenix_Bid_Process_Steps__c();
    n.Phoenix_Status__c = 'Submitted';
    n.Phoenix_Approver_Team__c = 'Marketing';
    insert n;
    nextSteps.add(n);
        Phoenix_Bid__c pb1 = new Phoenix_Bid__c();
    pb1.Phoenix_Status__c = 'New';
    pb1.Phoenix_Comments__c = 'Test Comments';
    pb1.Phoenix_Customer__c = testAccount.Id;
    pb1.Phoenix_Customer_Bid_Deadline_Date_Time__c = DateTime.now();
    pb1.Phoenix_Customer_Bid_Deadline_Time_zone__c = 'PST';
    pb1.Phoenix_Customer_Bid_Deadline_Time__c = '6 PM';
    pb1.Phoenix_Customer_Type__c = 'Direct and Indirect';
    pb1.Phoenix_Bid_Deadline_Date__c = System.today();
    pb1.Phoenix_Bid_Type__c = 'WAC Change Submissions';
    pb1.Phoenix_Approval_Status__c = 'Draft';
    pb1.Phoenix_Internal_Target_Date__c = Date.parse('10/12/2021');
    pb1.Phoenix_Sales_Person_2__c = UserInfo.getUserId();
    insert pb1;
       Phoenix_Customer_Response__c recb2 = new Phoenix_Customer_Response__c();
    recb2.Phoenix_Bid_No__c = pb1.Id;
    insert recb2;
    Phoenix_SubmitBidForApprovalCtrl.sendNDCEmailToVistexTeam(pb.Id);
 	Phoenix_SubmitBidForApprovalCtrl.sendDrlSubmittingUnderNewBidEmail(recb2.Id,pb1.Id);
    //Phoenix_SubmitBidForApprovalCtrl.recallBidToScm1(pb.Id);  
    //Phoenix_SubmitBidForApprovalCtrl.sendEmailToVistexTeam(testAccount.Id, pb.Id);

  }
  @isTest static void WACVistex() {
    Phoenix_TestDataCreator testData = new Phoenix_TestDataCreator();
    testData.generateProducts();
    testData.generateUsers();
    Account testAccount = new Account(Name = 'Test Email Account');
    testAccount.Phoenix_Contracts_Approver__c = Userinfo.getUserId();
    insert testAccount;

    Product2 p2 = new Product2();
    p2.Family = 'Daptomycin Inj 500mg US';
    p2.Name = 'Test';
    p2.ProductCode = '300029858';
    p2.Phoenix_Marketing_Lead__c = UserInfo.getUserId();
    p2.Phoenix_Product_Director__c = testData.users[0].Id;
    insert p2;

    Phoenix_WAC_Change__c pb = new Phoenix_WAC_Change__c();
    pb.Phoenix_Approval_Status__c = 'Draft';
    insert pb;
     
    Phoenix_WAC_Change_Line_Item__c bl = new Phoenix_WAC_Change_Line_Item__c();
    bl.Phoenix_WAC_Change__c = pb.Id;
    bl.Phoenix_Customer_Update_Approval__c = 'Accepted';
    bl.Phoenix_is_Vistex_Noti_Sent__c = false;
    insert bl;
    Phoenix_WAC_Change_Line_Item__c b2 = new Phoenix_WAC_Change_Line_Item__c();
    b2.Phoenix_WAC_Change__c = pb.Id;
    b2.Phoenix_Customer_Update_Approval__c = 'Not Accepted';
    b2.Phoenix_is_Vistex_Noti_Sent__c = false;
    insert b2;

    Phoenix_Bid_Process_Steps__c ps = new Phoenix_Bid_Process_Steps__c();
    ps.Phoenix_WAC_Change__c = pb.Id;
    ps.Phoenix_Approver_Team__c = 'Home Office';
    ps.Phoenix_Approver__c = UserInfo.getUserId();
    ps.Phoenix_Approver_Team_Members__c = 'Surender Patel';
    insert ps;
    List < Phoenix_Bid_Process_Steps__c > nextSteps = new list < Phoenix_Bid_Process_Steps__c > ();
    Phoenix_Bid_Process_Steps__c n = new Phoenix_Bid_Process_Steps__c();
    n.Phoenix_Status__c = 'Submitted';
    n.Phoenix_Approver_Team__c = 'Marketing';
    insert n;
    nextSteps.add(n);
    Phoenix_SubmitBidForApprovalCtrl.sendWACChangeEmailToVistexTeam(pb.Id);


  }
  @isTest static void WACFinancce() {
    Phoenix_TestDataCreator testData = new Phoenix_TestDataCreator();
    testData.generateProducts();
    testData.generateUsers();
    Account testAccount = new Account(Name = 'Test Email Account');
    testAccount.Phoenix_Contracts_Approver__c = Userinfo.getUserId();
    insert testAccount;

    Product2 p2 = new Product2();
    p2.Family = 'Daptomycin Inj 500mg US';
    p2.Name = 'Test';
    p2.ProductCode = '300029858';
    p2.Phoenix_Marketing_Lead__c = UserInfo.getUserId();
    p2.Phoenix_Product_Director__c = testData.users[0].Id;
    insert p2;
    
    Phoenix_Bid__c pb1 = new Phoenix_Bid__c();
    pb1.Phoenix_Status__c = 'New';
    pb1.Phoenix_Comments__c = 'Test Comments';
    pb1.Phoenix_Customer__c = testAccount.Id;
    pb1.Phoenix_Customer_Bid_Deadline_Date_Time__c = DateTime.now();
    pb1.Phoenix_Customer_Bid_Deadline_Time_zone__c = 'PST';
    pb1.Phoenix_Customer_Bid_Deadline_Time__c = '6 PM';
    pb1.Phoenix_Customer_Type__c = 'Direct and Indirect';
    pb1.Phoenix_Bid_Deadline_Date__c = System.today();
    pb1.Phoenix_Bid_Type__c = 'WAC Change Submissions';
    pb1.Phoenix_Approval_Status__c = 'Draft';
    pb1.Phoenix_Internal_Target_Date__c = Date.parse('10/12/2021');
    pb1.Phoenix_Sales_Person_2__c = UserInfo.getUserId();
    insert pb1;

    Phoenix_WAC_Change__c pb = new Phoenix_WAC_Change__c();
    pb.Phoenix_Approval_Status__c = 'Draft';
    insert pb;
    
    Phoenix_Approval_Matrix__c pam=new Phoenix_Approval_Matrix__c();
        pam.Name='Marketing Lead Rx Approval';
        insert pam;
    
     Phoenix_Approval_Process_Step__c rfpStep1 = new  Phoenix_Approval_Process_Step__c(Name='Marketing Lead Rx Approval',Phoenix_Order__c = 1,Phoenix_Is_Notification_Only__c = false,Phoenix_Approval_Matrix__c=pam.Id);
            insert rfpStep1;
      
    List < Phoenix_Bid_Process_Steps__c > nextSteps = new list < Phoenix_Bid_Process_Steps__c > ();
    Phoenix_Bid_Process_Steps__c ps = new Phoenix_Bid_Process_Steps__c();
    ps.Phoenix_WAC_Change__c = pb.Id;
    ps.Phoenix_Approver_Team__c = 'Home Office';
    ps.Phoenix_Approver__c = UserInfo.getUserId();
    ps.Phoenix_WAC_Change__c=pb.Id;
   // ps.Phoenix_Step__c=
    ps.Phoenix_Is_Criteria_Step__c=true;
    //ps.Phoenix_Is_Notification_Only__c=
    //ps.Phoenix_Approver_Email__c='test@gmail.com'
    ps.Phoenix_Approver__c=rfpStep1.Id;
    ps.Phoenix_Approver_Team__c='Sales';
    ps.Phoenix_Approver_Team_Members__c = 'Surender Patel';
    ps.Phoenix_Bid__c=pb1.Id;
    //insert ps;
      
    Phoenix_Bid_Process_Steps__c n = new Phoenix_Bid_Process_Steps__c();
    n.Phoenix_Status__c = 'Completed';
    n.Phoenix_Approver_Team__c = 'Marketing';
    n.Phoenix_WAC_Change__c=pb.Id;
    ps.Phoenix_Bid__c=pb1.Id;
    //insert n1;
    nextSteps.add(n);
    insert nextSteps;
 
    Phoenix_SubmitBidForApprovalCtrl.sendWACChangeEmailToFinanceTeam(pb.Id);


  }
  @isTest static void NewWACFinancce() {
    Phoenix_TestDataCreator testData = new Phoenix_TestDataCreator();
    testData.generateProducts();
    testData.generateUsers();
    Account testAccount = new Account(Name = 'Test Email Account');
    testAccount.Phoenix_Contracts_Approver__c = Userinfo.getUserId();
    insert testAccount;

    Product2 p2 = new Product2();
    p2.Family = 'Daptomycin Inj 500mg US';
    p2.Name = 'Test';
    p2.ProductCode = '300029858';
    p2.Phoenix_Marketing_Lead__c = UserInfo.getUserId();
    p2.Phoenix_Product_Director__c = testData.users[0].Id;
    insert p2;

    New_Product_WAC_Pricing__c pb = new New_Product_WAC_Pricing__c();
    pb.Phoenix_Approval_Status__c = 'Draft';
    pb.Phoenix_Product_Type__c='Product';
   	pb.Phoenix_TPT__c=45;
    pb.Phoenix_Net_sales_annualized__c=123;
    pb.Phoenix_GM__c=12;
    pb.Phoenix_Summary__c='Product Type';
    insert pb;
      
    Phoenix_NewProduct_WAC_Pricing_LineItems__c pnw=new Phoenix_NewProduct_WAC_Pricing_LineItems__c();
      pnw.Phoenix_TPT_GM__c=45;
      pnw.Phoenix_Lowest_Price__c=123;
      pnw.Phoenix_Brand_WAC__c=23;
      pnw.Phoenix_WAC__c=54;
      pnw.Phoenix_Pkg_Size__c=12;
      pnw.Phoenix_Product__c=p2.Id;
      pnw.Phoenix_NDC_11__c='123';
      pnw.Phoenix_Material_Number__c='12';
      pnw.Phoenix_New_Product_WAC_Pricing__c=pb.Id;
      insert pnw;
      
      Phoenix_NewProduct_WAC_Pricing_LineItems__c pnw1=new Phoenix_NewProduct_WAC_Pricing_LineItems__c();
      //pnw.Phoenix_TPT_GM__c=45;
      //pnw.Phoenix_Lowest_Price__c=123;
      //pnw.Phoenix_Brand_WAC__c=23;
      //pnw.Phoenix_WAC__c=54;
      //pnw.Phoenix_Pkg_Size__c=12;
      //pnw.Phoenix_Product__c=p2.Id;
      //pnw.Phoenix_NDC_11__c='123';
      //pnw.Phoenix_Material_Number__c='12';
      pnw1.Phoenix_New_Product_WAC_Pricing__c=pb.Id;
      insert pnw1;
        
    Phoenix_SubmitBidForApprovalCtrl.sendNewWACEmailToFinanceTeam(pb.Id);

  }
    
  //By sai krishna (30/03/2021)
  @isTest static void PHSClosureMethods() {
    Phoenix_TestDataCreator testData = new Phoenix_TestDataCreator();
    testData.generateProducts();
    testData.generateUsers();
    Account testAccount = new Account(Name = 'Test Email Account');
    testAccount.Phoenix_Contracts_Approver__c = Userinfo.getUserId();
    insert testAccount;

    Product2 p2 = new Product2();
    p2.Family = 'Daptomycin Inj 500mg US';
    p2.Name = 'Test';
    p2.ProductCode = '300029858';
    p2.Phoenix_Marketing_Lead__c = UserInfo.getUserId();
    p2.Phoenix_Product_Director__c = testData.users[0].Id;
    insert p2;

    Phoenix_PHS_Price_Change__c pb = new Phoenix_PHS_Price_Change__c();
    pb.Phoenix_PHS_Price_Change_Name__c = 'ggg';

    insert pb;

    Phoenix_PHS_Price_Change_Line__c bl = new Phoenix_PHS_Price_Change_Line__c();
    bl.Phoenix_Final_Status__c = 'Approved';
    bl.Phoenix_PHS_Price_Change__c = pb.Id;

    insert bl;
    Phoenix_PHS_Price_Change_Line__c b2 = new Phoenix_PHS_Price_Change_Line__c();
    b2.Phoenix_Final_Status__c = 'Approved';
    b2.Phoenix_PHS_Price_Change__c = pb.Id;

    insert b2;


    Phoenix_Bid_Process_Steps__c ps = new Phoenix_Bid_Process_Steps__c();
    ps.Phoenix_PHS_Price_Change__c = pb.Id;
    ps.Phoenix_Approver_Team__c = 'Home Office';
    ps.Phoenix_Approver__c = UserInfo.getUserId();
    ps.Phoenix_Approver_Team_Members__c = 'Surender Patel';
    insert ps;
    List < Phoenix_Bid_Process_Steps__c > nextSteps = new list < Phoenix_Bid_Process_Steps__c > ();
    String str;
    String str2;
    Phoenix_Bid_Process_Steps__c n = new Phoenix_Bid_Process_Steps__c();
    n.Phoenix_PHS_Price_Change__c = pb.Id;
    n.Phoenix_Status__c = 'Submitted';
    n.Phoenix_Approver_Team__c = 'Marketing';
    insert n;
    nextSteps.add(n);

    pb.Phoenix_Approval_Status__c = 'Closed';
    Update pb;
    List < Id > bidIds = new List < Id > ();
    bidIds.add(pb.Id);
    Phoenix_SubmitBidForApprovalCtrl.BidClosureNotification(bidIds);

  }
  @isTest static void NewWACClosureMethods() {
    Phoenix_TestDataCreator testData = new Phoenix_TestDataCreator();
    testData.generateProducts();
    testData.generateUsers();
    Account testAccount = new Account(Name = 'Test Email Account');
    testAccount.Phoenix_Contracts_Approver__c = Userinfo.getUserId();
    insert testAccount;

    Product2 p2 = new Product2();
    p2.Family = 'Daptomycin Inj 500mg US';
    p2.Name = 'Test';
    p2.ProductCode = '300029858';
    p2.Phoenix_Marketing_Lead__c = UserInfo.getUserId();
    p2.Phoenix_Product_Director__c = testData.users[0].Id;
    insert p2;

    New_Product_WAC_Pricing__c pb = new New_Product_WAC_Pricing__c();
    insert pb;

    Phoenix_NewProduct_WAC_Pricing_LineItems__c bl = new Phoenix_NewProduct_WAC_Pricing_LineItems__c();
    bl.Phoenix_Final_Status__c = 'Approved';
    bl.Phoenix_New_Product_WAC_Pricing__c = pb.Id;

    insert bl;
    Phoenix_NewProduct_WAC_Pricing_LineItems__c b2 = new Phoenix_NewProduct_WAC_Pricing_LineItems__c();
    b2.Phoenix_Final_Status__c = 'Approved';
    b2.Phoenix_New_Product_WAC_Pricing__c = pb.Id;

    insert b2;


    Phoenix_Bid_Process_Steps__c ps = new Phoenix_Bid_Process_Steps__c();
    ps.Phoenix_New_Product_WAC_Pricing__c = pb.Id;
    ps.Phoenix_Approver_Team__c = 'Home Office';
    ps.Phoenix_Approver__c = UserInfo.getUserId();
    ps.Phoenix_Approver_Team_Members__c = 'Surender Patel';
    insert ps;
    List < Phoenix_Bid_Process_Steps__c > nextSteps = new list < Phoenix_Bid_Process_Steps__c > ();
    String str;
    String str2;
    Phoenix_Bid_Process_Steps__c n = new Phoenix_Bid_Process_Steps__c();
    n.Phoenix_New_Product_WAC_Pricing__c = pb.Id;
    n.Phoenix_Status__c = 'Submitted';
    n.Phoenix_Approver_Team__c = 'Marketing';
    insert n;
    nextSteps.add(n);

    pb.Phoenix_Approval_Status__c = 'Closed';
    Update pb;
    List < Id > bidIds = new List < Id > ();
    bidIds.add(pb.Id);
    Phoenix_SubmitBidForApprovalCtrl.BidClosureNotification(bidIds);

  }
  @isTest static void WACClosureMethods() {
    Phoenix_TestDataCreator testData = new Phoenix_TestDataCreator();
    testData.generateProducts();
    testData.generateUsers();
    Account testAccount = new Account(Name = 'Test Email Account');
    testAccount.Phoenix_Contracts_Approver__c = Userinfo.getUserId();
    insert testAccount;

    Product2 p2 = new Product2();
    p2.Family = 'Daptomycin Inj 500mg US';
    p2.Name = 'Test';
    p2.ProductCode = '300029858';
    p2.Phoenix_Marketing_Lead__c = UserInfo.getUserId();
    p2.Phoenix_Product_Director__c = testData.users[0].Id;
    insert p2;

    Phoenix_WAC_Change__c pb = new Phoenix_WAC_Change__c();


    insert pb;

    Phoenix_WAC_Change_Line_Item__c bl = new Phoenix_WAC_Change_Line_Item__c();
    bl.Phoenix_Final_Status__c = 'Approved';
    bl.Phoenix_WAC_Change__c = pb.Id;

    insert bl;
    Phoenix_WAC_Change_Line_Item__c b2 = new Phoenix_WAC_Change_Line_Item__c();
    b2.Phoenix_Final_Status__c = 'Approved';
    b2.Phoenix_WAC_Change__c = pb.Id;

    insert b2;


    Phoenix_Bid_Process_Steps__c ps = new Phoenix_Bid_Process_Steps__c();
    ps.Phoenix_WAC_Change__c = pb.Id;
    ps.Phoenix_Approver_Team__c = 'Home Office';
    ps.Phoenix_Approver__c = UserInfo.getUserId();
    ps.Phoenix_Approver_Team_Members__c = 'Surender Patel';
    insert ps;
    List < Phoenix_Bid_Process_Steps__c > nextSteps = new list < Phoenix_Bid_Process_Steps__c > ();
    String str;
    String str2;
    Phoenix_Bid_Process_Steps__c n = new Phoenix_Bid_Process_Steps__c();
    n.Phoenix_WAC_Change__c = pb.Id;
    n.Phoenix_Status__c = 'Submitted';
    n.Phoenix_Approver_Team__c = 'Marketing';
    insert n;
    nextSteps.add(n);

    pb.Phoenix_Approval_Status__c = 'Closed';
    Update pb;
    List < Id > bidIds = new List < Id > ();
    bidIds.add(pb.Id);
    Phoenix_SubmitBidForApprovalCtrl.BidClosureNotification(bidIds);

  }

  static testmethod void test10() {
    Account testAccount = new Account(Name = 'Test Email Account');
    testAccount.Phoenix_Contracts_Approver__c = Userinfo.getUserId();
    insert testAccount;
    Phoenix_Bid__c pb = new Phoenix_Bid__c();
    pb.Phoenix_Status__c = 'New';
    pb.Phoenix_Comments__c = 'Test Comments';
    pb.Phoenix_Customer__c = testAccount.Id;
    //pb.Phoenix_Product__r.Phoenix_Product_Director__c='0050m000003VwV4AAK';
    pb.Phoenix_Customer_Bid_Deadline_Date_Time__c = DateTime.now();
    pb.Phoenix_Customer_Bid_Deadline_Time_zone__c = 'PST';
    pb.Phoenix_Customer_Bid_Deadline_Time__c = '6 PM';
    pb.Phoenix_Customer_Type__c = 'Direct and Indirect';
    pb.Phoenix_Bid_Deadline_Date__c = System.today();
    pb.Phoenix_Bid_Type__c = 'WAC Change Submissions';
    pb.Phoenix_Approval_Status__c = 'Draft';
    insert pb;
    Phoenix_SubmitBidForApprovalCtrl.SCMProductRejectionNotification(pb.Id);
    List < Phoenix_SAP_NPR_Staging__c > psapList= new List < Phoenix_SAP_NPR_Staging__c >();

    Phoenix_SAP_NPR_Staging__c n = new Phoenix_SAP_NPR_Staging__c();

    n.Phoenix_Contract_Number__c = '111';
    n.Phoenix_Material_Number__c = '12345';
    n.Phoenix_Contract_Internal_Description__c = 'description';
    n.Phoenix_Customer_Name__c = 'g';
    insert n;
    Phoenix_SAP_NPR_Staging__c n1 = new Phoenix_SAP_NPR_Staging__c();

    n1.Phoenix_Contract_Number__c = '111';
    n1.Phoenix_Material_Number__c = '12345';
    n1.Phoenix_Contract_Internal_Description__c = 'description';
    n1.Phoenix_Customer_Name__c = 'g';
    //insert n1;
    psapList.add(n1);
     
      	  Phoenix_SAP_NPR_Staging__c psap = new Phoenix_SAP_NPR_Staging__c();
      
      	  psap.Phoenix_NPR_Report_Type__c='Current Active';
          psap.Phoenix_Customer_Name__c='test';
          psap.Phoenix_Contract_External_Description__c='description';
          psap.Phoenix_Contract_Internal_Description__c='description';
          psap.Phoenix_Material_Number__c='12345';
          psap.Phoenix_Contract_Number__c='111';
         //psap.Phoenix_NPR_Ref_SF__c='test';
         //  psap.Phoenix_Price_Effective_Value_From__c=
         // psap.Phoenix_Vistex_Description__c=
         psapList.add(psap);
      	 insert psapList;

    Phoenix_SubmitBidForApprovalCtrl.calculateFinanceGrid(pb.Id);
    Phoenix_SubmitBidForApprovalCtrl.reportDuplicateNprStagingRecords();



  }
  static testmethod void LoginAsSCM() {
    Account testAccount = new Account(Name = 'Test Account');
    testAccount.Phoenix_Contracts_Approver__c = Userinfo.getUserId();
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
    pb.Phoenix_Bid_Type__c = 'RFP Bids';
    pb.Phoenix_Approval_Status__c = 'Draft';
    insert pb;
    Product2 p2 = new Product2();
    p2.Family = 'Daptomycin Inj 500mg US';
    p2.Name = 'Test';
    p2.ProductCode = '300029858';
    p2.Phoenix_Marketing_Lead__c = UserInfo.getUserId();
    p2.Phoenix_Product_Director__c = UserInfo.getUserId();
    insert p2;
    Product2 p3 = new Product2();
    p3.Family = 'Abiraterone Acetate Tab';
    p3.ProductCode = '300029858';
    p3.Name = 'Test Product';
    p3.Phoenix_Marketing_Lead__c = UserInfo.getUserId();
    p3.Phoenix_Product_Director__c = UserInfo.getUserId();
    insert p3;
    Phoenix_Bid_Line_Item__c bl = new Phoenix_Bid_Line_Item__c();
    bl.Phoenix_Bid__c = pb.Id;
    bl.Phoenix_Current_Direct_Price__c = 10;
    bl.Phoenix_Product_Code1__c = '300029858';
    bl.Phoenix_Product_Family1__c = 'Daptomycin Inj 500mg US';
    bl.Phoenix_Current_Indirect_Selling_Unit__c = 10;
    bl.Phoenix_Product__c = p2.Id;
    bl.Phoenix_Final_Status__c = 'Approved';
    bl.Phoenix_SCM_Approval_Y_N__c = 'Y- Only Current Monthly Demand Approved';
    bl.Phoenix_Marketing_Final_Approval__c = true;
    bl.Phoenix_Product_Director1__c = UserInfo.getName();
    insert bl;
    Phoenix_Bid_Line_Item__c bl1 = new Phoenix_Bid_Line_Item__c();
    bl1.Phoenix_Bid__c = pb.Id;
    bl1.Phoenix_Final_Status__c = 'Approved';
    bl1.Phoenix_Current_Direct_Price__c = 10;
    bl1.Phoenix_Current_Indirect_Selling_Unit__c = 10;
    bl1.Phoenix_Product__c = p3.Id;
    bl1.Phoenix_SCM_Approval_Y_N__c = 'Y- Only Current Monthly Demand Approved';
    bl1.Phoenix_Marketing_Final_Approval__c = true;
    bl1.Phoenix_Product_Director1__c = UserInfo.getName();
    insert bl1;
    Phoenix_Bid_Line_Item__c bl2 = new Phoenix_Bid_Line_Item__c();
    bl2.Phoenix_Bid__c = pb.Id;
    bl2.Phoenix_Final_Status__c = 'Approved';
    bl2.Phoenix_Current_Direct_Price__c = 10;
    bl2.Phoenix_Current_Indirect_Selling_Unit__c = 10;
    bl2.Phoenix_Product__c = p3.Id;
    bl2.Phoenix_SCM_Approval_Y_N__c = 'N- Not Approved';
    bl2.Phoenix_Marketing_Final_Approval__c = true;
    bl2.Phoenix_Product_Director1__c = UserInfo.getName();
    insert bl2;
    //
    Phoenix_Bid_Process_Steps__c ps = new Phoenix_Bid_Process_Steps__c();
    ps.Phoenix_Approver__c = UserInfo.getUserId();
    ps.Phoenix_Bid__c = pb.Id;
    insert ps;
    //
    Map < String, Map < String, String >> financeApprovalMap = new Map < String, Map < String, String >> ();
    Map < String, Map < String, String >> financeCommentMap = new Map < String, Map < String, String >> ();
    Map < String, String > fieldsMap = new Map < String, String > ();
    Map < String, String > fieldsMap1 = new Map < String, String > ();
    Set < Id > blitemSet = new Set < Id > ();
    blitemSet.add(bl2.Id);
    blitemSet.add(bl1.Id);

    fieldsMap.put('SCM Comments', 'test');
    fieldsMap1.put('SCM Rejection Reason', 'test');
    financeApprovalMap.put(bl.Id, fieldsMap);
    financeCommentMap.put(bl1.Id, fieldsMap1);
    Phoenix_TestDataCreator testData = new Phoenix_TestDataCreator();
    testData.generateProducts();
    testData.generateUsers();
    testData.generateApprovalMatrix();
    delete[Select Id from Phoenix_User_Approval_Matrix__c where User_Group__c =: testData.approvalGroups[2].Id or User_Group__c =: testData.approvalGroups[0].Id];
    Phoenix_SubmitBidForApprovalCtrl.BidWrapper wrap = new Phoenix_SubmitBidForApprovalCtrl.BidWrapper();
    wrap.bid = pb;
    Phoenix_SubmitBidForApprovalCtrl.submitBid(wrap);
  }
  static testmethod void LoginAsMkt() {
    Account testAccount = new Account(Name = 'Test Account');
    testAccount.Phoenix_Contracts_Approver__c = Userinfo.getUserId();
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
    pb.Phoenix_Bid_Type__c = 'RFP Bids';
    pb.Phoenix_Approval_Status__c = 'Draft';
    insert pb;
    Product2 p2 = new Product2();
    p2.Family = 'Daptomycin Inj 500mg US';
    p2.Name = 'Test';
    p2.ProductCode = '300029858';
    p2.Phoenix_Marketing_Lead__c = UserInfo.getUserId();
    p2.Phoenix_Product_Director__c = UserInfo.getUserId();
    insert p2;
    Product2 p3 = new Product2();
    p3.Family = 'Abiraterone Acetate Tab';
    p3.ProductCode = '300029858';
    p3.Name = 'Test Product';
    p3.Phoenix_Marketing_Lead__c = UserInfo.getUserId();
    p3.Phoenix_Product_Director__c = UserInfo.getUserId();
    insert p3;
    Phoenix_Bid_Line_Item__c bl = new Phoenix_Bid_Line_Item__c();
    bl.Phoenix_Bid__c = pb.Id;
    bl.Phoenix_Current_Direct_Price__c = 10;
    bl.Phoenix_Product_Code1__c = '300029858';
    bl.Phoenix_Product_Family1__c = 'Daptomycin Inj 500mg US';
    bl.Phoenix_Current_Indirect_Selling_Unit__c = 10;
    bl.Phoenix_Product__c = p2.Id;
    bl.Phoenix_Final_Status__c = 'Approved';
    bl.Phoenix_SCM_Approval_Y_N__c = 'Y- Only Current Monthly Demand Approved';
    bl.Phoenix_Marketing_Final_Approval__c = true;
    bl.Phoenix_Product_Director1__c = UserInfo.getName();
    insert bl;
    Phoenix_Bid_Line_Item__c bl1 = new Phoenix_Bid_Line_Item__c();
    bl1.Phoenix_Bid__c = pb.Id;
    bl1.Phoenix_Final_Status__c = 'Approved';
    bl1.Phoenix_Current_Direct_Price__c = 10;
    bl1.Phoenix_Current_Indirect_Selling_Unit__c = 10;
    bl1.Phoenix_Product__c = p3.Id;
    bl1.Phoenix_SCM_Approval_Y_N__c = 'Y- Only Current Monthly Demand Approved';
    bl1.Phoenix_Marketing_Final_Approval__c = true;
    bl1.Phoenix_Product_Director1__c = UserInfo.getName();
    insert bl1;
    Phoenix_Bid_Line_Item__c bl2 = new Phoenix_Bid_Line_Item__c();
    bl2.Phoenix_Bid__c = pb.Id;
    bl2.Phoenix_Final_Status__c = 'Approved';
    bl2.Phoenix_Current_Direct_Price__c = 10;
    bl2.Phoenix_Current_Indirect_Selling_Unit__c = 10;
    bl2.Phoenix_Product__c = p3.Id;
    bl2.Phoenix_SCM_Approval_Y_N__c = 'N- Not Approved';
    bl2.Phoenix_Marketing_Final_Approval__c = true;
    bl2.Phoenix_Product_Director1__c = UserInfo.getName();
    insert bl2;
    //
    Phoenix_Bid_Process_Steps__c ps = new Phoenix_Bid_Process_Steps__c();
    ps.Phoenix_Approver__c = UserInfo.getUserId();
    ps.Phoenix_Bid__c = pb.Id;
    insert ps;
    //
    Map < String, Map < String, String >> financeApprovalMap = new Map < String, Map < String, String >> ();
    Map < String, Map < String, String >> financeCommentMap = new Map < String, Map < String, String >> ();
    Map < String, String > fieldsMap = new Map < String, String > ();
    Map < String, String > fieldsMap1 = new Map < String, String > ();
    Set < Id > blitemSet = new Set < Id > ();
    blitemSet.add(bl2.Id);
    blitemSet.add(bl1.Id);

    fieldsMap.put('SCM Comments', 'test');
    fieldsMap1.put('SCM Rejection Reason', 'test');
    financeApprovalMap.put(bl.Id, fieldsMap);
    financeCommentMap.put(bl1.Id, fieldsMap1);
    Phoenix_TestDataCreator testData = new Phoenix_TestDataCreator();
    testData.generateProducts();
    testData.generateUsers();
    testData.generateApprovalMatrix();
    delete[Select Id from Phoenix_User_Approval_Matrix__c where User_Group__c =: testData.approvalGroups[1].Id or User_Group__c =: testData.approvalGroups[0].Id];
    Phoenix_SubmitBidForApprovalCtrl.BidWrapper wrap = new Phoenix_SubmitBidForApprovalCtrl.BidWrapper();
    wrap.bid = pb;
    Phoenix_SubmitBidForApprovalCtrl.submitBid(wrap);
  }
  /*   static testmethod void LoginAsMktSrx() {
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
pb.Phoenix_Bid_Type__c='SRx IPA Price Change';pb.Phoenix_Approval_Status__c = 'Draft';
pb.Phoenix_Is_Re_Bid__c =true;
insert pb;
Product2 p2 = new Product2();
p2.Family = 'Daptomycin Inj 500mg US'; 
p2.Name = 'Test';
p2.ProductCode = '300029858';
p2.Phoenix_Product_Director__c = UserInfo.getUserId();
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
bl.Phoenix_Product_Director1__c=UserInfo.getName();
insert bl; 
Phoenix_Bid_Line_Item__c bl1= new Phoenix_Bid_Line_Item__c();
bl1.Phoenix_Bid__c=pb.Id;
bl1.Phoenix_Final_Status__c='Approved';      
bl1.Phoenix_Current_Direct_Price__c=10;
bl1.Phoenix_Current_Indirect_Selling_Unit__c=10;
bl1.Phoenix_Product__c = p3.Id;
bl1.Phoenix_SCM_Approval_Y_N__c = 'Y- Only Current Monthly Demand Approved';
bl1.Phoenix_Marketing_Final_Approval__c=true;
bl1.Phoenix_Product_Director1__c=UserInfo.getName();
insert bl1;
Phoenix_Bid_Line_Item__c bl2= new Phoenix_Bid_Line_Item__c();
bl2.Phoenix_Bid__c=pb.Id;
bl2.Phoenix_Final_Status__c='Approved';      
bl2.Phoenix_Current_Direct_Price__c=10;
bl2.Phoenix_Current_Indirect_Selling_Unit__c=10;
bl2.Phoenix_Product__c = p3.Id;
bl2.Phoenix_SCM_Approval_Y_N__c = 'N- Not Approved';
bl2.Phoenix_Marketing_Final_Approval__c=true;
bl2.Phoenix_Product_Director1__c=UserInfo.getName();
insert bl2;
//
Phoenix_Bid_Process_Steps__c ps=new Phoenix_Bid_Process_Steps__c();
ps.Phoenix_Approver__c=UserInfo.getUserId();
ps.Phoenix_Bid__c=pb.Id;
insert ps; 
//
Map<String, Map<String,String>> financeApprovalMap = new Map<String, Map<String,String>>();
Map<String, Map<String,String>> financeCommentMap = new Map<String, Map<String,String>>();
Map<String,String> fieldsMap = new Map<String,String>();
Map<String,String> fieldsMap1 = new Map<String,String>();
Set<Id> blitemSet = new Set<Id>();
blitemSet.add(bl2.Id);
blitemSet.add(bl1.Id);

fieldsMap.put('SCM Comments','test');
fieldsMap1.put('SCM Rejection Reason' , 'test');
financeApprovalMap.put(bl.Id, fieldsMap);
financeCommentMap.put(bl1.Id, fieldsMap1);
Phoenix_TestDataCreator testData = new Phoenix_TestDataCreator();
testData.generateProducts();
testData.generateUsers();
testData.generateApprovalMatrix();
delete[Select Id from  Phoenix_User_Approval_Matrix__c where User_Group__c =: testData.approvalGroups[1].Id or User_Group__c =: testData.approvalGroups[0].Id ]; 
Phoenix_SubmitBidForApprovalCtrl.BidWrapper wrap = new Phoenix_SubmitBidForApprovalCtrl.BidWrapper();
wrap.bid = pb;
Phoenix_SubmitBidForApprovalCtrl.submitBid(wrap);  
}
static testmethod void LoginAsSCMSrx() {
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
pb.Phoenix_Is_Re_Bid__c =true;

pb.Phoenix_Bid_Type__c='SRx IPA Price Change';pb.Phoenix_Approval_Status__c = 'Draft';
insert pb;
Product2 p2 = new Product2();
p2.Family = 'Daptomycin Inj 500mg US'; 
p2.Name = 'Test';
p2.ProductCode = '300029858';
p2.Phoenix_Product_Director__c = UserInfo.getUserId();
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
bl.Phoenix_Product_Director1__c=UserInfo.getName();
insert bl; 
Phoenix_Bid_Line_Item__c bl1= new Phoenix_Bid_Line_Item__c();
bl1.Phoenix_Bid__c=pb.Id;
bl1.Phoenix_Final_Status__c='Approved';      
bl1.Phoenix_Current_Direct_Price__c=10;
bl1.Phoenix_Current_Indirect_Selling_Unit__c=10;
bl1.Phoenix_Product__c = p3.Id;
bl1.Phoenix_SCM_Approval_Y_N__c = 'Y- Only Current Monthly Demand Approved';
bl1.Phoenix_Marketing_Final_Approval__c=true;
bl1.Phoenix_Product_Director1__c=UserInfo.getName();
insert bl1;
Phoenix_Bid_Line_Item__c bl2= new Phoenix_Bid_Line_Item__c();
bl2.Phoenix_Bid__c=pb.Id;
bl2.Phoenix_Final_Status__c='Approved';      
bl2.Phoenix_Current_Direct_Price__c=10;
bl2.Phoenix_Current_Indirect_Selling_Unit__c=10;
bl2.Phoenix_Product__c = p3.Id;
bl2.Phoenix_SCM_Approval_Y_N__c = 'N- Not Approved';
bl2.Phoenix_Marketing_Final_Approval__c=true;
bl2.Phoenix_Product_Director1__c=UserInfo.getName();
insert bl2;
//
Phoenix_Bid_Process_Steps__c ps=new Phoenix_Bid_Process_Steps__c();
ps.Phoenix_Approver__c=UserInfo.getUserId();
ps.Phoenix_Bid__c=pb.Id;
insert ps; 
//
Map<String, Map<String,String>> financeApprovalMap = new Map<String, Map<String,String>>();
Map<String, Map<String,String>> financeCommentMap = new Map<String, Map<String,String>>();
Map<String,String> fieldsMap = new Map<String,String>();
Map<String,String> fieldsMap1 = new Map<String,String>();
Set<Id> blitemSet = new Set<Id>();
blitemSet.add(bl2.Id);
blitemSet.add(bl1.Id);

fieldsMap.put('SCM Comments','test');
fieldsMap1.put('SCM Rejection Reason' , 'test');
financeApprovalMap.put(bl.Id, fieldsMap);
financeCommentMap.put(bl1.Id, fieldsMap1);
Phoenix_TestDataCreator testData = new Phoenix_TestDataCreator();
testData.generateProducts();
testData.generateUsers();
testData.generateApprovalMatrix();
delete[Select Id from  Phoenix_User_Approval_Matrix__c where User_Group__c =: testData.approvalGroups[1].Id or User_Group__c =: testData.approvalGroups[0].Id ]; 
Phoenix_SubmitBidForApprovalCtrl.BidWrapper wrap = new Phoenix_SubmitBidForApprovalCtrl.BidWrapper();
wrap.bid = pb;
Phoenix_SubmitBidForApprovalCtrl.submitBid(wrap);  
}

*/
  @isTest static void SCMRejectionMethod() {
    Phoenix_TestDataCreator testData = new Phoenix_TestDataCreator();
    testData.generateProducts();
    testData.generateUsers();
    Account testAccount = new Account(Name = 'Test Email Account');
    testAccount.Phoenix_Contracts_Approver__c = Userinfo.getUserId();
    insert testAccount;

    Product2 p2 = new Product2();
    p2.Family = 'Daptomycin Inj 500mg US';
    p2.Name = 'Test';
    p2.ProductCode = '300029858';
    p2.Phoenix_Marketing_Lead__c = UserInfo.getUserId();
    p2.Phoenix_Product_Director__c = testData.users[0].Id;
    insert p2;

    Phoenix_Bid__c pb = new Phoenix_Bid__c();
    pb.Phoenix_Status__c = 'New';
    pb.Phoenix_Comments__c = 'Test Comments';
    pb.Phoenix_Customer__c = testAccount.Id;
    pb.Phoenix_Customer_Bid_Deadline_Date_Time__c = DateTime.now();
    pb.Phoenix_Customer_Bid_Deadline_Time_zone__c = 'PST';
    pb.Phoenix_Customer_Bid_Deadline_Time__c = '6 PM';
    pb.Phoenix_Customer_Type__c = 'Direct and Indirect';
    pb.Phoenix_Bid_Deadline_Date__c = System.today();
    pb.Phoenix_Bid_Type__c = 'Mass Product Removals';
    pb.Phoenix_Approval_Status__c = 'Draft';
    pb.Phoenix_Internal_Target_Date__c = Date.parse('10/12/2021');
    pb.Phoenix_Sales_Person_2__c = UserInfo.getUserId();
    insert pb;

    Phoenix_Bid_Line_Item__c bl = new Phoenix_Bid_Line_Item__c();
    bl.Phoenix_Bid__c = pb.Id;
    bl.Phoenix_Current_Direct_Price__c = 10;
    bl.Phoenix_Product_Code1__c = '300029858';
    bl.Phoenix_Final_Status__c='Approved';
    bl.Phoenix_Product_Family1__c = 'Daptomycin Inj 500mg US';
    bl.Phoenix_Current_Indirect_Selling_Unit__c = 10;
    bl.Phoenix_Product__c = testData.productList[0].Id;
    bl.Phoenix_SCM_Approval_Y_N__c = 'N- Not Approved';
    insert bl;
    Phoenix_Bid_Line_Item__c b2 = new Phoenix_Bid_Line_Item__c();
    b2.Phoenix_Bid__c = pb.Id;
    b2.Phoenix_Final_Status__c='Approved';
    b2.Phoenix_Current_Direct_Price__c = 10;
    b2.Phoenix_Product_Code1__c = '300029858';
    b2.Phoenix_Product_Family1__c = 'Daptomycin Inj 500mg US';
    b2.Phoenix_Current_Indirect_Selling_Unit__c = 10;
    b2.Phoenix_Product__c = p2.Id;
    b2.Phoenix_SCM_Approval_Y_N__c = 'N- Not Approved';
    insert b2;
    Phoenix_SubmitBidForApprovalCtrl.SCMProductRejectionNotification(pb.Id);
    Phoenix_SubmitBidForApprovalCtrl.sendEmailToSCMTeam(pb.Id);

  }
  @isTest static void BidRejectionEmailMethod() {
    Phoenix_TestDataCreator testData = new Phoenix_TestDataCreator();
    testData.generateProducts();
    testData.generateUsers();
    Account testAccount = new Account(Name = 'Test Email Account');
    testAccount.Phoenix_Contracts_Approver__c = Userinfo.getUserId();
    insert testAccount;

    Product2 p2 = new Product2();
    p2.Family = 'Daptomycin Inj 500mg US';
    p2.Name = 'Test';
    p2.ProductCode = '300029858';
    p2.Phoenix_Marketing_Lead__c = UserInfo.getUserId();
    p2.Phoenix_Product_Director__c = testData.users[0].Id;
    insert p2;

    Phoenix_Bid__c pb = new Phoenix_Bid__c();
    pb.Phoenix_Status__c = 'New';
    pb.Phoenix_Comments__c = 'Test Comments';
    pb.Phoenix_Customer__c = testAccount.Id;
    pb.Phoenix_Customer_Bid_Deadline_Date_Time__c = DateTime.now();
    pb.Phoenix_Customer_Bid_Deadline_Time_zone__c = 'PST';
    pb.Phoenix_Customer_Bid_Deadline_Time__c = '6 PM';
    pb.Phoenix_Customer_Type__c = 'Direct and Indirect';
    pb.Phoenix_Bid_Deadline_Date__c = System.today();
    pb.Phoenix_Bid_Type__c = 'WAC Change Submissions';
    pb.Phoenix_Approval_Status__c = 'Draft';
    pb.Phoenix_Internal_Target_Date__c = Date.parse('10/12/2021');
    pb.Phoenix_Sales_Person_2__c = UserInfo.getUserId();
    insert pb;

    Phoenix_Bid_Line_Item__c bl = new Phoenix_Bid_Line_Item__c();
    bl.Phoenix_Bid__c = pb.Id;
    bl.Phoenix_Current_Direct_Price__c = 10;
    bl.Phoenix_Product_Code1__c = '300029858';
    bl.Phoenix_Product_Family1__c = 'Daptomycin Inj 500mg US';
    bl.Phoenix_Current_Indirect_Selling_Unit__c = 10;
    bl.Phoenix_Product__c = testData.productList[0].Id;
    bl.Phoenix_Final_Status__c = 'Not Approved';
    bl.Phoenix_Is_Rejection_Noti_All_Sent__c = false;
    insert bl;
    Phoenix_Bid_Line_Item__c b2 = new Phoenix_Bid_Line_Item__c();
    b2.Phoenix_Bid__c = pb.Id;
    b2.Phoenix_Current_Direct_Price__c = 10;
    b2.Phoenix_Product_Code1__c = '300029858';
    b2.Phoenix_Product_Family1__c = 'Daptomycin Inj 500mg US';
    b2.Phoenix_Current_Indirect_Selling_Unit__c = 10;
    b2.Phoenix_Product__c = p2.Id;
    b2.Phoenix_Final_Status__c = 'Not Approved';
    b2.Phoenix_Is_Rejection_Noti_All_Sent__c = false;
    insert b2;
    set < Id > bidLineItemSet = new set < Id > ();
    bidLineItemSet.add(bl.Id);
    bidLineItemSet.add(b2.Id);
    Phoenix_SubmitBidForApprovalCtrl.BidRejectionEmailNotificationToAll(bidLineItemSet,pb.Id);

  }
  @isTest static void ApprovalRequestEmailMethods() {
    Phoenix_TestDataCreator testData = new Phoenix_TestDataCreator();
    testData.generateProducts();
    testData.generateUsers();
    Account testAccount = new Account(Name = 'Test Email Account');
    testAccount.Phoenix_Contracts_Approver__c = Userinfo.getUserId();
    insert testAccount;

    Product2 p2 = new Product2();
    p2.Family = 'Daptomycin Inj 500mg US';
    p2.Name = 'Test';
    p2.ProductCode = '300029858';
    p2.Phoenix_Marketing_Lead__c = UserInfo.getUserId();
    p2.Phoenix_Product_Director__c = testData.users[0].Id;
    insert p2;

    Phoenix_Bid__c pb = new Phoenix_Bid__c();
    pb.Phoenix_Status__c = 'New';
    pb.Phoenix_Comments__c = 'Test Comments';
    pb.Phoenix_Customer__c = testAccount.Id;
    pb.Phoenix_Customer_Bid_Deadline_Date_Time__c = DateTime.now();
    pb.Phoenix_Customer_Bid_Deadline_Time_zone__c = 'PST';
    pb.Phoenix_Customer_Bid_Deadline_Time__c = '6 PM';
    pb.Phoenix_Customer_Type__c = 'Direct and Indirect';
    pb.Phoenix_Bid_Deadline_Date__c = System.today();
    pb.Phoenix_Bid_Type__c = 'WAC Change Submissions';
    pb.Phoenix_Approval_Status__c = 'Draft';
    pb.Phoenix_Internal_Target_Date__c = Date.parse('10/12/2021');
    //User curUser = [SELECT Id, Username, Email FROM User where Username = 'manisha+phoenix+project1@dhruvsoft.com'];
    //pb.Phoenix_Sales_Person_2__c=curUser.Id;
    pb.Phoenix_Sales_Person_2__c = Userinfo.getUserId();
    //pb.Phoenix_Salesperson__c =UserInfo.getUserId();
    insert pb;

    Phoenix_Bid_Line_Item__c bl = new Phoenix_Bid_Line_Item__c();
    bl.Phoenix_Bid__c = pb.Id;
    bl.Phoenix_Current_Direct_Price__c = 10;
    bl.Phoenix_Product_Code1__c = '300029858';
    bl.Phoenix_Product_Family1__c = 'Daptomycin Inj 500mg US';
    bl.Phoenix_Current_Indirect_Selling_Unit__c = 10;
    bl.Phoenix_Product__c = testData.productList[0].Id;
    bl.Phoenix_Final_Status__c = 'Approved';
    bl.Phoenix_SCM_Approval_Y_N__c = 'Y- Only Current Monthly Demand Approved';
    bl.Phoenix_Marketing_Final_Approval__c = true;
    insert bl;
    Phoenix_Bid_Line_Item__c b2 = new Phoenix_Bid_Line_Item__c();
    b2.Phoenix_Bid__c = pb.Id;
    b2.Phoenix_Current_Direct_Price__c = 10;
    b2.Phoenix_Product_Code1__c = '300029858';
    b2.Phoenix_Product_Family1__c = 'Daptomycin Inj 500mg US';
    b2.Phoenix_Current_Indirect_Selling_Unit__c = 10;
    b2.Phoenix_Final_Status__c = 'Approved';
    b2.Phoenix_SCM_Approval_Y_N__c = 'Y- Only Current Monthly Demand Approved';
    b2.Phoenix_Marketing_Final_Approval__c = true;
    b2.Phoenix_SCM_Approved_Quantity__c = 20;
    insert b2;
    Phoenix_Bid_Process_Steps__c ps = new Phoenix_Bid_Process_Steps__c();
    ps.Phoenix_Bid__c = pb.Id;
    ps.Phoenix_Approver_Team__c = 'Home Office';
    ps.Phoenix_Approver__c = UserInfo.getUserId();
    ps.Phoenix_Approver_Team_Members__c = 'Surender Patel';
    insert ps;
    Phoenix_Approval_Grid__c approvalGrid = new Phoenix_Approval_Grid__c(Name = 'Test grid');
    approvalGrid.Phoenix_Bid__c = pb.Id;
    approvalGrid.Phoenix_Is_SVP_Notification_Required__c = true;
    approvalGrid.Phoenix_Is_partner_product__c = false;
    approvalGrid.Phoenix_Annualized_TP__c = 10;
    insert approvalGrid;

    Phoenix_Approval_Grid__c approvalGrid2 = new Phoenix_Approval_Grid__c(Name = 'Test grid2');
    approvalGrid2.Phoenix_Bid__c = pb.Id;
    approvalGrid2.Phoenix_Is_SVP_Notification_Required__c = true;
    approvalGrid2.Phoenix_Is_partner_product__c = true;
    approvalGrid2.Phoenix_Annualized_TP__c = 100;
    approvalGrid2.Phoenix_Product_Family__c = 'abc';
    insert approvalGrid2;
    List < Phoenix_Bid_Process_Steps__c > nextSteps = new list < Phoenix_Bid_Process_Steps__c > ();
    String str;
    String str2;
    Phoenix_Bid_Process_Steps__c n = new Phoenix_Bid_Process_Steps__c();
    n.Phoenix_Status__c = 'Submitted';
    n.Phoenix_Approver_Team__c = 'Marketing';
    insert n;
    nextSteps.add(n);
    Phoenix_SubmitBidForApprovalCtrl.approvalRequestNotification(pb.Id, nextSteps);
    pb.Phoenix_Approval_Status__c = 'Closed';
    // Update pb;
    List < Id > bidIds = new List < Id > ();
    bidIds.add(pb.Id);

  }
  @isTest static void SVPEmailMethods() {
    Phoenix_TestDataCreator testData = new Phoenix_TestDataCreator();
    testData.generateProducts();
    testData.generateUsers();
    Account testAccount = new Account(Name = 'Test Email Account');
    testAccount.Phoenix_Contracts_Approver__c = Userinfo.getUserId();
    insert testAccount;

    Product2 p2 = new Product2();
    p2.Family = 'Daptomycin Inj 500mg US';
    p2.Name = 'Test';
    p2.ProductCode = '300029858';
    p2.Phoenix_Marketing_Lead__c = UserInfo.getUserId();
    p2.Phoenix_Product_Director__c = testData.users[0].Id;
    insert p2;

    Phoenix_Bid__c pb = new Phoenix_Bid__c();
    pb.Phoenix_Status__c = 'New';
    pb.Phoenix_Comments__c = 'Test Comments';
    pb.Phoenix_Customer__c = testAccount.Id;
    pb.Phoenix_Customer_Bid_Deadline_Date_Time__c = DateTime.now();
    pb.Phoenix_Customer_Bid_Deadline_Time_zone__c = 'PST';
    pb.Phoenix_Customer_Bid_Deadline_Time__c = '6 PM';
    pb.Phoenix_Customer_Type__c = 'Direct and Indirect';
    pb.Phoenix_Bid_Deadline_Date__c = System.today();
    pb.Phoenix_Bid_Type__c = 'WAC Change Submissions';
    pb.Phoenix_Approval_Status__c = 'Draft';
    pb.Phoenix_Internal_Target_Date__c = Date.parse('10/12/2021');
    //User curUser = [SELECT Id, Username, Email FROM User where Username = 'manisha+phoenix+project1@dhruvsoft.com'];
    //pb.Phoenix_Sales_Person_2__c=curUser.Id;
    pb.Phoenix_Sales_Person_2__c = Userinfo.getUserId();
    //pb.Phoenix_Salesperson__c =UserInfo.getUserId();
    insert pb;

    Phoenix_Bid_Line_Item__c bl = new Phoenix_Bid_Line_Item__c();
    bl.Phoenix_Bid__c = pb.Id;
    bl.Phoenix_Current_Direct_Price__c = 10;
    bl.Phoenix_Product_Code1__c = '300029858';
    bl.Phoenix_Product_Family1__c = 'Daptomycin Inj 500mg US';
    bl.Phoenix_Current_Indirect_Selling_Unit__c = 10;
    bl.Phoenix_Product__c = testData.productList[0].Id;
    bl.Phoenix_Final_Status__c = 'Approved';
    bl.Phoenix_SCM_Approval_Y_N__c = 'Y- Only Current Monthly Demand Approved';
    bl.Phoenix_Marketing_Final_Approval__c = true;
    insert bl;
    Phoenix_Bid_Line_Item__c b2 = new Phoenix_Bid_Line_Item__c();
    b2.Phoenix_Bid__c = pb.Id;
    b2.Phoenix_Current_Direct_Price__c = 10;
    b2.Phoenix_Product_Code1__c = '300029858';
    b2.Phoenix_Product_Family1__c = 'Daptomycin Inj 500mg US';
    b2.Phoenix_Current_Indirect_Selling_Unit__c = 10;
    b2.Phoenix_Product__c = p2.Id;
    b2.Phoenix_Final_Status__c = 'Approved';
    b2.Phoenix_SCM_Approval_Y_N__c = 'Y- Only Current Monthly Demand Approved';
    b2.Phoenix_Marketing_Final_Approval__c = true;
    b2.Phoenix_SCM_Approved_Quantity__c = 20;
    insert b2;
    Phoenix_Bid_Process_Steps__c ps = new Phoenix_Bid_Process_Steps__c();
    ps.Phoenix_Bid__c = pb.Id;
    ps.Phoenix_Approver_Team__c = 'Home Office';
    ps.Phoenix_Approver__c = UserInfo.getUserId();
    ps.Phoenix_Approver_Team_Members__c = 'Surender Patel';
    insert ps;
    Phoenix_Approval_Grid__c approvalGrid = new Phoenix_Approval_Grid__c(Name = 'Test grid');
    approvalGrid.Phoenix_Bid__c = pb.Id;
    approvalGrid.Phoenix_Is_SVP_Notification_Required__c = true;
    approvalGrid.Phoenix_Is_partner_product__c = false;
    approvalGrid.Phoenix_Annualized_TP__c = 10;
    insert approvalGrid;

    Phoenix_Approval_Grid__c approvalGrid2 = new Phoenix_Approval_Grid__c(Name = 'Test grid2');
    approvalGrid2.Phoenix_Bid__c = pb.Id;
    approvalGrid2.Phoenix_Is_SVP_Notification_Required__c = true;
    approvalGrid2.Phoenix_Is_partner_product__c = true;
    approvalGrid2.Phoenix_Annualized_TP__c = 100;
    approvalGrid2.Phoenix_Product_Family__c = 'abc';
    insert approvalGrid2;
    List < Phoenix_Bid_Process_Steps__c > nextSteps = new list < Phoenix_Bid_Process_Steps__c > ();
    String str;
    String str2;
    Phoenix_Bid_Process_Steps__c n = new Phoenix_Bid_Process_Steps__c();
    n.Phoenix_Status__c = 'Submitted';
    n.Phoenix_Approver_Team__c = 'Marketing';
    insert n;
    nextSteps.add(n);
    List < Id > bidIds = new List < Id > ();
    bidIds.add(pb.Id);
    //Test.startTest();
    Phoenix_SubmitBidForApprovalCtrl.SVPEmailNotification(pb.Id);
    //Test.stopTest();

  }
  @isTest static void SVPEmailMethods2() {
    Phoenix_TestDataCreator testData = new Phoenix_TestDataCreator();
    testData.generateProducts();
    testData.generateUsers();
    Account testAccount = new Account(Name = 'Test Email Account');
    testAccount.Phoenix_Contracts_Approver__c = Userinfo.getUserId();
    insert testAccount;

    Product2 p2 = new Product2();
    p2.Family = 'Daptomycin Inj 500mg US';
    p2.Name = 'Test';
    p2.ProductCode = '300029858';
    p2.Phoenix_Marketing_Lead__c = UserInfo.getUserId();
    p2.Phoenix_Product_Director__c = testData.users[0].Id;
    insert p2;

    Phoenix_Bid__c pb = new Phoenix_Bid__c();
    pb.Phoenix_Status__c = 'New';
    pb.Phoenix_Comments__c = 'Test Comments';
    pb.Phoenix_Customer__c = testAccount.Id;
    pb.Phoenix_Customer_Bid_Deadline_Date_Time__c = DateTime.now();
    pb.Phoenix_Customer_Bid_Deadline_Time_zone__c = 'PST';
    pb.Phoenix_Customer_Bid_Deadline_Time__c = '6 PM';
    pb.Phoenix_Customer_Type__c = 'Direct and Indirect';
    pb.Phoenix_Bid_Deadline_Date__c = System.today();
    pb.Phoenix_Bid_Type__c = 'WAC Change Submissions';
    pb.Phoenix_Approval_Status__c = 'Draft';
    pb.Phoenix_Internal_Target_Date__c = Date.parse('10/12/2021');
    //User curUser = [SELECT Id, Username, Email FROM User where Username = 'manisha+phoenix+project1@dhruvsoft.com'];
    //pb.Phoenix_Sales_Person_2__c=curUser.Id;
    pb.Phoenix_Sales_Person_2__c = Userinfo.getUserId();
    //pb.Phoenix_Salesperson__c =UserInfo.getUserId();
    insert pb;

    Phoenix_Bid_Line_Item__c bl = new Phoenix_Bid_Line_Item__c();
    bl.Phoenix_Bid__c = pb.Id;
    bl.Phoenix_Current_Direct_Price__c = 10;
    bl.Phoenix_Product_Code1__c = '300029858';
    bl.Phoenix_Product_Family1__c = 'Daptomycin Inj 500mg US';
    bl.Phoenix_Current_Indirect_Selling_Unit__c = 10;
    bl.Phoenix_Product__c = testData.productList[0].Id;
    bl.Phoenix_Final_Status__c = 'Approved';
    bl.Phoenix_SCM_Approval_Y_N__c = 'Y- Only Current Monthly Demand Approved';
    bl.Phoenix_Marketing_Final_Approval__c = true;
    insert bl;
    Phoenix_Bid_Line_Item__c b2 = new Phoenix_Bid_Line_Item__c();
    b2.Phoenix_Bid__c = pb.Id;
    b2.Phoenix_Current_Direct_Price__c = 10;
    b2.Phoenix_Product_Code1__c = '300029858';
    b2.Phoenix_Product_Family1__c = 'Daptomycin Inj 500mg US';
    b2.Phoenix_Current_Indirect_Selling_Unit__c = 10;
    b2.Phoenix_Product__c = p2.Id;
    b2.Phoenix_Final_Status__c = 'Approved';
    b2.Phoenix_SCM_Approval_Y_N__c = 'Y- Only Current Monthly Demand Approved';
    b2.Phoenix_Marketing_Final_Approval__c = true;
    b2.Phoenix_SCM_Approved_Quantity__c = 20;
    insert b2;
    Phoenix_Bid_Process_Steps__c ps = new Phoenix_Bid_Process_Steps__c();
    ps.Phoenix_Bid__c = pb.Id;
    ps.Phoenix_Approver_Team__c = 'Home Office';
    ps.Phoenix_Approver__c = UserInfo.getUserId();
    ps.Phoenix_Approver_Team_Members__c = 'Surender Patel';
    insert ps;
    Phoenix_Approval_Grid__c approvalGrid = new Phoenix_Approval_Grid__c(Name = 'Test grid');
    approvalGrid.Phoenix_Bid__c = pb.Id;
    approvalGrid.Phoenix_Is_SVP_Notification_Required__c = true;
    approvalGrid.Phoenix_Is_partner_product__c = false;
    approvalGrid.Phoenix_Annualized_TP__c = 10;
    insert approvalGrid;

    Phoenix_Approval_Grid__c approvalGrid2 = new Phoenix_Approval_Grid__c(Name = 'Test grid2');
    approvalGrid2.Phoenix_Bid__c = pb.Id;
    approvalGrid2.Phoenix_Is_SVP_Notification_Required__c = true;
    approvalGrid2.Phoenix_Is_partner_product__c = true;
    approvalGrid2.Phoenix_Annualized_TP__c = 100;
    approvalGrid2.Phoenix_Product_Family__c = 'abc';
    insert approvalGrid2;
    List < Phoenix_Bid_Process_Steps__c > nextSteps = new list < Phoenix_Bid_Process_Steps__c > ();
    String str;
    String str2;
    Phoenix_Bid_Process_Steps__c n = new Phoenix_Bid_Process_Steps__c();
    n.Phoenix_Status__c = 'Submitted';
    n.Phoenix_Approver_Team__c = 'Marketing';
    insert n;
    nextSteps.add(n);
    List < Id > bidIds = new List < Id > ();
    bidIds.add(pb.Id);
    //Test.startTest();


    //Test.stopTest();

  }
  @isTest static void CloseBidMethod() {
    Phoenix_TestDataCreator testData = new Phoenix_TestDataCreator();
    testData.generateProducts();
    testData.generateUsers();
    Account testAccount = new Account(Name = 'Test Email Account');
    testAccount.Phoenix_Contracts_Approver__c = Userinfo.getUserId();
    insert testAccount;

    Product2 p2 = new Product2();
    p2.Family = 'Daptomycin Inj 500mg US';
    p2.Name = 'Test';
    p2.ProductCode = '300029858';
    p2.Phoenix_Marketing_Lead__c = UserInfo.getUserId();
    p2.Phoenix_Product_Director__c = testData.users[0].Id;
    insert p2;

    Phoenix_Bid__c pb = new Phoenix_Bid__c();
    pb.Phoenix_Status__c = 'New';
    pb.Phoenix_Comments__c = 'Test Comments';
    pb.Phoenix_Customer__c = testAccount.Id;
    pb.Phoenix_Customer_Bid_Deadline_Date_Time__c = DateTime.now();
    pb.Phoenix_Customer_Bid_Deadline_Time_zone__c = 'PST';
    pb.Phoenix_Customer_Bid_Deadline_Time__c = '6 PM';
    pb.Phoenix_Customer_Type__c = 'Direct and Indirect';
    pb.Phoenix_Bid_Deadline_Date__c = System.today();
    pb.Phoenix_Bid_Type__c = 'WAC Change Submissions';
    pb.Phoenix_Approval_Status__c = 'Draft';
    pb.Phoenix_Internal_Target_Date__c = Date.parse('10/12/2021');
    pb.Phoenix_Sales_Person_2__c = UserInfo.getUserId();
    insert pb;

    Phoenix_Bid_Line_Item__c bl = new Phoenix_Bid_Line_Item__c();
    bl.Phoenix_Bid__c = pb.Id;
    bl.Phoenix_Current_Direct_Price__c = 10;
    bl.Phoenix_Product_Code1__c = '300029858';
    bl.Phoenix_Product_Family1__c = 'Daptomycin Inj 500mg US';
    bl.Phoenix_Current_Indirect_Selling_Unit__c = 10;
    bl.Phoenix_Product__c = testData.productList[0].Id;
    bl.Phoenix_SCM_Approval_Y_N__c = 'N- Not Approved';
    insert bl;
    Phoenix_Bid_Line_Item__c b2 = new Phoenix_Bid_Line_Item__c();
    b2.Phoenix_Bid__c = pb.Id;
    b2.Phoenix_Current_Direct_Price__c = 10;
    b2.Phoenix_Product_Code1__c = '300029858';
    b2.Phoenix_Product_Family1__c = 'Daptomycin Inj 500mg US';
    b2.Phoenix_Current_Indirect_Selling_Unit__c = 10;
    b2.Phoenix_Product__c = p2.Id;
    b2.Phoenix_SCM_Approval_Y_N__c = 'N- Not Approved';
    insert b2;
    Phoenix_Bid_Process_Steps__c ps = new Phoenix_Bid_Process_Steps__c();
    ps.Phoenix_Bid__c = pb.Id;
    ps.Phoenix_Approver_Team__c = 'Home Office';
    ps.Phoenix_Approver__c = null;
    ps.Phoenix_Status__c = 'In Process';
    ps.Phoenix_Approver_Team_Members__c = 'Surender Patel';
    insert ps;
    Phoenix_Bid_Process_Steps__c ps1 = new Phoenix_Bid_Process_Steps__c();
    ps1.Phoenix_Bid__c = pb.Id;
    ps1.Phoenix_Approver_Team__c = 'Home Office';
    ps1.Phoenix_Approver__c = UserInfo.getUserId();
    ps1.Phoenix_Approver_Team_Members__c = 'Surender Patel';
    insert ps1;


  }
  @isTest static void NDCDelete() {
    Phoenix_TestDataCreator testData = new Phoenix_TestDataCreator();
    testData.generateProducts();
    testData.generateUsers();
    Account testAccount = new Account(Name = 'Test Email Account');
    testAccount.Phoenix_Contracts_Approver__c = Userinfo.getUserId();
    insert testAccount;

    Product2 p2 = new Product2();
    p2.Family = 'Daptomycin Inj 500mg US';
    p2.Name = 'Test';
    p2.ProductCode = '300029858';
    p2.Phoenix_Marketing_Lead__c = UserInfo.getUserId();
    p2.Phoenix_Product_Director__c = testData.users[0].Id;
    insert p2;
      
    List < Id > ndcChangeIds = new List < Id > ();
      
    Phoenix_Bid__c pbid = new Phoenix_Bid__c();
    pbid.Phoenix_On_Hold__c = false;
    pbid.Phoenix_Bid_Deadline_Date__c = System.today();
    pbid.Phoenix_Customer__c=testAccount.Id;
    insert pbid;
    
    ndcChangeIds.add(pbid.Id);
    
    Phoenix_Bid__c pb2 = new Phoenix_Bid__c();
    pb2.Phoenix_On_Hold__c = true;
    pb2.Phoenix_Bid_Deadline_Date__c = System.today();
    insert pb2;
      
    List<Phoenix_Bid_Line_Item__c> pbList=new List<Phoenix_Bid_Line_Item__c>();
    Phoenix_Bid_Line_Item__c pbl1 = new Phoenix_Bid_Line_Item__c();
    pbl1.Phoenix_Bid__c = pbid.Id;
    pbl1.Phoenix_Is_New_Low_Triggered__c = true;
    pbl1.Phoenix_Approved_Lowest_Price_SKU__c = 10;
    pbl1.Phoenix_Product__c = p2.id;
    pbl1.Phoenix_Final_Status__c = 'Approved';
   	pbList.add(pbl1);
      
    Phoenix_Bid_Line_Item__c pbl2 = new Phoenix_Bid_Line_Item__c();
    pbl2.Phoenix_Bid__c = pbid.Id;
    pbl2.Phoenix_Is_New_Low_Triggered__c = true;
    pbl2.Phoenix_Approved_Lowest_Price_SKU__c = 10;
    //bl.Phoenix_Product__c = prod1.id;
    pbl2.Phoenix_Final_Status__c = 'Approved';
   	pbList.add(pbl2);
    
    insert pbList;

    Phoenix_NDC_Change__c pb = new Phoenix_NDC_Change__c();
    pb.Phoenix_Approval_Status__c = 'Draft';
    insert pb;

    Phoenix_NDC_Change_Line_Item__c bl = new Phoenix_NDC_Change_Line_Item__c();
    bl.Phoenix_NDC_Change__c = pb.Id;
    bl.Phoenix_Final_Status__c = 'Approved';
    insert bl;
    Phoenix_NDC_Change_Line_Item__c b2 = new Phoenix_NDC_Change_Line_Item__c();
    b2.Phoenix_NDC_Change__c = pb.Id;
    b2.Phoenix_Final_Status__c = 'Approved';
    b2.Phoenix_SCM_Approved_Quantity__c = 20;
    insert b2;
    Phoenix_Bid_Process_Steps__c ps = new Phoenix_Bid_Process_Steps__c();
    ps.Phoenix_NDC_Change__c = pb.Id;
    ps.Phoenix_Approver_Team__c = 'Home Office';
    ps.Phoenix_Approver__c = UserInfo.getUserId();
    ps.Phoenix_Approver_Team_Members__c = 'Surender Patel';
    insert ps;
    List < Phoenix_Bid_Process_Steps__c > nextSteps = new list < Phoenix_Bid_Process_Steps__c > ();
    String str;
    String str2;
    Phoenix_Bid_Process_Steps__c n = new Phoenix_Bid_Process_Steps__c();
    n.Phoenix_Status__c = 'Submitted';
    n.Phoenix_Approver_Team__c = 'Marketing';
    insert n;
    nextSteps.add(n);
   
    ndcChangeIds.add(pb.Id);
    //Test.startTest();
    Phoenix_SubmitBidForApprovalCtrl.deleteBidChildren(ndcChangeIds);
    //Test.stopTest();

  }
    
      @isTest static void NDCDelete_TestMethod() {
    Phoenix_TestDataCreator testData = new Phoenix_TestDataCreator();
    testData.generateProducts();
    testData.generateUsers();
    Account testAccount = new Account(Name = 'Test Email Account');
    testAccount.Phoenix_Contracts_Approver__c = Userinfo.getUserId();
    insert testAccount;

    Product2 p2 = new Product2();
    p2.Family = 'Daptomycin Inj 500mg US';
    p2.Name = 'Test';
    p2.ProductCode = '300029858';
    p2.Phoenix_Marketing_Lead__c = UserInfo.getUserId();
    p2.Phoenix_Product_Director__c = testData.users[0].Id;
    insert p2;
      
    List < Id > ndcChangeIds = new List < Id > ();
      
   
    Phoenix_NDC_Change__c pb = new Phoenix_NDC_Change__c();
    pb.Phoenix_Approval_Status__c = 'Draft';
    insert pb;

    Phoenix_NDC_Change_Line_Item__c bl = new Phoenix_NDC_Change_Line_Item__c();
    bl.Phoenix_NDC_Change__c = pb.Id;
    bl.Phoenix_Final_Status__c = 'Approved';
    insert bl;
    Phoenix_NDC_Change_Line_Item__c b2 = new Phoenix_NDC_Change_Line_Item__c();
    b2.Phoenix_NDC_Change__c = pb.Id;
    b2.Phoenix_Final_Status__c = 'Approved';
    b2.Phoenix_SCM_Approved_Quantity__c = 20;
    insert b2;
    Phoenix_Bid_Process_Steps__c ps = new Phoenix_Bid_Process_Steps__c();
    ps.Phoenix_NDC_Change__c = pb.Id;
    ps.Phoenix_Approver_Team__c = 'Home Office';
    ps.Phoenix_Approver__c = UserInfo.getUserId();
    ps.Phoenix_Approver_Team_Members__c = 'Surender Patel';
    insert ps;
    List < Phoenix_Bid_Process_Steps__c > nextSteps = new list < Phoenix_Bid_Process_Steps__c > ();
    String str;
    String str2;
    Phoenix_Bid_Process_Steps__c n = new Phoenix_Bid_Process_Steps__c();
    n.Phoenix_Status__c = 'Submitted';
    n.Phoenix_Approver_Team__c = 'Marketing';
    insert n;
    nextSteps.add(n);
   
    ndcChangeIds.add(pb.Id);
    //Test.startTest();
    Phoenix_SubmitBidForApprovalCtrl.deleteBidChildren(ndcChangeIds);
    //Test.stopTest();

  }
    
  @isTest static void PHSDelete() {
    Phoenix_TestDataCreator testData = new Phoenix_TestDataCreator();
    testData.generateProducts();
    testData.generateUsers();
    Account testAccount = new Account(Name = 'Test Email Account');
    testAccount.Phoenix_Contracts_Approver__c = Userinfo.getUserId();
    insert testAccount;
    
    List<ID> idList=new List<ID>();
     
    Product2 p2 = new Product2();
    p2.Family = 'Daptomycin Inj 500mg US';
    p2.Name = 'Test';
    p2.ProductCode = '300029858';
    p2.Phoenix_Marketing_Lead__c = UserInfo.getUserId();
    p2.Phoenix_Product_Director__c = testData.users[0].Id;
    insert p2;
      
    Phoenix_Bid__c pbid = new Phoenix_Bid__c();
    pbid.Phoenix_On_Hold__c = false;
    pbid.Phoenix_Bid_Deadline_Date__c = System.today();
    pbid.Phoenix_Customer__c=testAccount.Id;
    insert pbid;
    
    idList.add(pbid.Id);
    
    Phoenix_Bid__c pb2 = new Phoenix_Bid__c();
    pb2.Phoenix_On_Hold__c = true;
    pb2.Phoenix_Bid_Deadline_Date__c = System.today();
    insert pb2;
      
    List<Phoenix_Bid_Line_Item__c> pbList=new List<Phoenix_Bid_Line_Item__c>();
    Phoenix_Bid_Line_Item__c pbl1 = new Phoenix_Bid_Line_Item__c();
    pbl1.Phoenix_Bid__c = pbid.Id;
    pbl1.Phoenix_Is_New_Low_Triggered__c = true;
    pbl1.Phoenix_Approved_Lowest_Price_SKU__c = 10;
    pbl1.Phoenix_Product__c = p2.id;
    pbl1.Phoenix_Final_Status__c = 'Approved';
   	pbList.add(pbl1);
      
    Phoenix_Bid_Line_Item__c pbl2 = new Phoenix_Bid_Line_Item__c();
    pbl2.Phoenix_Bid__c = pbid.Id;
    pbl2.Phoenix_Is_New_Low_Triggered__c = true;
    pbl2.Phoenix_Approved_Lowest_Price_SKU__c = 10;
    //bl.Phoenix_Product__c = prod1.id;
    pbl2.Phoenix_Final_Status__c = 'Approved';
   	pbList.add(pbl2);
    
    insert pbList;


    Phoenix_PHS_Price_Change__c pb = new Phoenix_PHS_Price_Change__c();
    pb.Phoenix_Approval_Status__c = 'Draft';
    insert pb;

    Phoenix_PHS_Price_Change_Line__c bl = new Phoenix_PHS_Price_Change_Line__c();
    bl.Phoenix_PHS_Price_Change__c = pb.Id;
    bl.Phoenix_Final_Status__c = 'Approved';
    insert bl;
    Phoenix_PHS_Price_Change_Line__c b2 = new Phoenix_PHS_Price_Change_Line__c();
    b2.Phoenix_PHS_Price_Change__c = pb.Id;
    b2.Phoenix_Final_Status__c = 'Approved';
    insert b2;
    Phoenix_Bid_Process_Steps__c ps = new Phoenix_Bid_Process_Steps__c();
    ps.Phoenix_PHS_Price_Change__c = pb.Id;
    ps.Phoenix_Approver_Team__c = 'Home Office';
    ps.Phoenix_Approver__c = UserInfo.getUserId();
    ps.Phoenix_Approver_Team_Members__c = 'Surender Patel';
    insert ps;
    List < Phoenix_Bid_Process_Steps__c > nextSteps = new list < Phoenix_Bid_Process_Steps__c > ();
    String str;
    String str2;
    Phoenix_Bid_Process_Steps__c n = new Phoenix_Bid_Process_Steps__c();
    n.Phoenix_Status__c = 'Submitted';
    n.Phoenix_Approver_Team__c = 'Marketing';
    insert n;
    nextSteps.add(n);
    List < Id > ndcChangeIds = new List < Id > ();
    ndcChangeIds.add(pb.Id);
    //Test.startTest();
    Phoenix_SubmitBidForApprovalCtrl.deleteBidChildren(ndcChangeIds);
    //Test.stopTest();

  }
  @isTest static void NewWACDelete() {
    Phoenix_TestDataCreator testData = new Phoenix_TestDataCreator();
    testData.generateProducts();
    testData.generateUsers();
    Account testAccount = new Account(Name = 'Test Email Account');
    testAccount.Phoenix_Contracts_Approver__c = Userinfo.getUserId();
    insert testAccount;

    Product2 p2 = new Product2();
    p2.Family = 'Daptomycin Inj 500mg US';
    p2.Name = 'Test';
    p2.ProductCode = '300029858';
    p2.Phoenix_Marketing_Lead__c = UserInfo.getUserId();
    p2.Phoenix_Product_Director__c = testData.users[0].Id;
    insert p2;

    New_Product_WAC_Pricing__c pb = new New_Product_WAC_Pricing__c();
    pb.Phoenix_Approval_Status__c = 'Draft';
    insert pb;

    Phoenix_NewProduct_WAC_Pricing_LineItems__c bl = new Phoenix_NewProduct_WAC_Pricing_LineItems__c();
    bl.Phoenix_New_Product_WAC_Pricing__c = pb.Id;
    bl.Phoenix_Final_Status__c = 'Approved';
    insert bl;
    Phoenix_NewProduct_WAC_Pricing_LineItems__c b2 = new Phoenix_NewProduct_WAC_Pricing_LineItems__c();
    b2.Phoenix_New_Product_WAC_Pricing__c = pb.Id;
    b2.Phoenix_Final_Status__c = 'Approved';
    insert b2;
    Phoenix_Bid_Process_Steps__c ps = new Phoenix_Bid_Process_Steps__c();
    ps.Phoenix_New_Product_WAC_Pricing__c = pb.Id;
    ps.Phoenix_Approver_Team__c = 'Home Office';
    ps.Phoenix_Approver__c = UserInfo.getUserId();
    ps.Phoenix_Approver_Team_Members__c = 'Surender Patel';
    insert ps;
    List < Phoenix_Bid_Process_Steps__c > nextSteps = new list < Phoenix_Bid_Process_Steps__c > ();
    String str;
    String str2;
    Phoenix_Bid_Process_Steps__c n = new Phoenix_Bid_Process_Steps__c();
    n.Phoenix_Status__c = 'Submitted';
    n.Phoenix_Approver_Team__c = 'Marketing';
    insert n;
    nextSteps.add(n);
    List < Id > ndcChangeIds = new List < Id > ();
    ndcChangeIds.add(pb.Id);
    //Test.startTest();
    Phoenix_SubmitBidForApprovalCtrl.deleteBidChildren(ndcChangeIds);
    //Test.stopTest();

  }
  @isTest static void WACDelete() {
    Phoenix_TestDataCreator testData = new Phoenix_TestDataCreator();
    testData.generateProducts();
    testData.generateUsers();
    Account testAccount = new Account(Name = 'Test Email Account');
    testAccount.Phoenix_Contracts_Approver__c = Userinfo.getUserId();
    insert testAccount;

    Product2 p2 = new Product2();
    p2.Family = 'Daptomycin Inj 500mg US';
    p2.Name = 'Test';
    p2.ProductCode = '300029858';
    p2.Phoenix_Marketing_Lead__c = UserInfo.getUserId();
    p2.Phoenix_Product_Director__c = testData.users[0].Id;
    insert p2;

    Phoenix_WAC_Change__c pb = new Phoenix_WAC_Change__c();
    pb.Phoenix_Approval_Status__c = 'Draft';
    insert pb;

    Phoenix_WAC_Change_Line_Item__c bl = new Phoenix_WAC_Change_Line_Item__c();
    bl.Phoenix_WAC_Change__c = pb.Id;
    bl.Phoenix_Final_Status__c = 'Approved';
    insert bl;
    Phoenix_WAC_Change_Line_Item__c b2 = new Phoenix_WAC_Change_Line_Item__c();
    b2.Phoenix_WAC_Change__c = pb.Id;
    b2.Phoenix_Final_Status__c = 'Approved';
    insert b2;
    Phoenix_Bid_Process_Steps__c ps = new Phoenix_Bid_Process_Steps__c();
    ps.Phoenix_WAC_Change__c = pb.Id;
    ps.Phoenix_Approver_Team__c = 'Home Office';
    ps.Phoenix_Approver__c = UserInfo.getUserId();
    ps.Phoenix_Approver_Team_Members__c = 'Surender Patel';
    insert ps;
    List < Phoenix_Bid_Process_Steps__c > nextSteps = new list < Phoenix_Bid_Process_Steps__c > ();
    String str;
    String str2;
    Phoenix_Bid_Process_Steps__c n = new Phoenix_Bid_Process_Steps__c();
    n.Phoenix_Status__c = 'Submitted';
    n.Phoenix_Approver_Team__c = 'Marketing';
    insert n;
    nextSteps.add(n);
    List < Id > ndcChangeIds = new List < Id > ();
    ndcChangeIds.add(pb.Id);
    //Test.startTest();
    Phoenix_SubmitBidForApprovalCtrl.deleteBidChildren(ndcChangeIds);
    //Test.stopTest();

  }

  @isTest static void NDCApprovalRequestEmailMethods() {
    Phoenix_TestDataCreator testData = new Phoenix_TestDataCreator();
    testData.generateProducts();
    testData.generateUsers();
    Account testAccount = new Account(Name = 'Test Email Account');
    testAccount.Phoenix_Contracts_Approver__c = Userinfo.getUserId();
    insert testAccount;

    Product2 p2 = new Product2();
    p2.Family = 'Daptomycin Inj 500mg US';
    p2.Name = 'Test';
    p2.ProductCode = '300029858';
    p2.Phoenix_Marketing_Lead__c = UserInfo.getUserId();
    p2.Phoenix_Product_Director__c = testData.users[0].Id;
    insert p2;

    Phoenix_NDC_Change__c pb = new Phoenix_NDC_Change__c();
    pb.Phoenix_Approval_Status__c = 'Draft';
    insert pb;

    Phoenix_NDC_Change_Line_Item__c bl = new Phoenix_NDC_Change_Line_Item__c();
    bl.Phoenix_NDC_Change__c = pb.Id;
    bl.Phoenix_Final_Status__c = 'Approved';
    insert bl;
    Phoenix_NDC_Change_Line_Item__c b2 = new Phoenix_NDC_Change_Line_Item__c();
    b2.Phoenix_NDC_Change__c = pb.Id;
    b2.Phoenix_Final_Status__c = 'Approved';
    b2.Phoenix_SCM_Approved_Quantity__c = 20;
    insert b2;
    Phoenix_Bid_Process_Steps__c ps = new Phoenix_Bid_Process_Steps__c();
    ps.Phoenix_NDC_Change__c = pb.Id;
    ps.Phoenix_Approver_Team__c = 'Home Office';
    ps.Phoenix_Approver__c = UserInfo.getUserId();
    ps.Phoenix_Approver_Team_Members__c = 'Surender Patel';
    insert ps;

    List < Phoenix_Bid_Process_Steps__c > nextSteps = new list < Phoenix_Bid_Process_Steps__c > ();
    String str;
    String str2;
    Phoenix_Bid_Process_Steps__c n = new Phoenix_Bid_Process_Steps__c();
    n.Phoenix_Status__c = 'Submitted';
    n.Phoenix_Approver_Team__c = 'Marketing';
    insert n;
    nextSteps.add(n);
    //Commented by Shashirekha
    //Phoenix_SubmitBidForApprovalCtrl.approvalRequestNotification(pb.Id, nextSteps);
    pb.Phoenix_Approval_Status__c = 'Closed';
    Update pb;
    List < Id > bidIds = new List < Id > ();
    bidIds.add(pb.Id);

  }
  @isTest static void NDCSCMRejectionMethod() {
    Phoenix_TestDataCreator testData = new Phoenix_TestDataCreator();
    testData.generateProducts();
    testData.generateUsers();
    Account testAccount = new Account(Name = 'Test Email Account');
    testAccount.Phoenix_Contracts_Approver__c = Userinfo.getUserId();
    insert testAccount;

    Product2 p2 = new Product2();
    p2.Family = 'Daptomycin Inj 500mg US';
    p2.Name = 'Test';
    p2.ProductCode = '300029858';
    p2.Phoenix_Marketing_Lead__c = UserInfo.getUserId();
    p2.Phoenix_Product_Director__c = testData.users[0].Id;
    insert p2;

    Phoenix_NDC_Change__c pb = new Phoenix_NDC_Change__c();
    pb.Phoenix_Approval_Status__c = 'Draft';
    insert pb;

    Phoenix_NDC_Change_Line_Item__c bl = new Phoenix_NDC_Change_Line_Item__c();
    bl.Phoenix_NDC_Change__c = pb.Id;
    bl.Phoenix_SCM_Approval_Y_N__c = 'Not Approved';
    insert bl;
    Phoenix_NDC_Change_Line_Item__c b2 = new Phoenix_NDC_Change_Line_Item__c();
    b2.Phoenix_NDC_Change__c = pb.Id;
    b2.Phoenix_SCM_Approval_Y_N__c = 'Not Approved';
    insert b2;
    Phoenix_Bid_Process_Steps__c ps = new Phoenix_Bid_Process_Steps__c();
    ps.Phoenix_NDC_Change__c = pb.Id;
    ps.Phoenix_Approver_Team__c = 'Home Office';
    ps.Phoenix_Approver__c = UserInfo.getUserId();
    ps.Phoenix_Approver_Team_Members__c = 'Surender Patel';
    insert ps;

    List < Phoenix_Bid_Process_Steps__c > nextSteps = new list < Phoenix_Bid_Process_Steps__c > ();
    String str;
    String str2;
    Phoenix_Bid_Process_Steps__c n = new Phoenix_Bid_Process_Steps__c();
    n.Phoenix_Status__c = 'Submitted';
    n.Phoenix_Approver_Team__c = 'Marketing';
    insert n;
    nextSteps.add(n);
    Phoenix_SubmitBidForApprovalCtrl.SCMProductRejectionNotification(pb.Id);

  }
  @isTest static void NDCBidRejectionEmailMethod() {
    Phoenix_TestDataCreator testData = new Phoenix_TestDataCreator();
    testData.generateProducts();
    testData.generateUsers();
    Account testAccount = new Account(Name = 'Test Email Account');
    testAccount.Phoenix_Contracts_Approver__c = Userinfo.getUserId();
    insert testAccount;

    Product2 p2 = new Product2();
    p2.Family = 'Daptomycin Inj 500mg US';
    p2.Name = 'Test';
    p2.ProductCode = '300029858';
    p2.Phoenix_Marketing_Lead__c = UserInfo.getUserId();
    p2.Phoenix_Product_Director__c = testData.users[0].Id;
    insert p2;

    Phoenix_NDC_Change__c pb = new Phoenix_NDC_Change__c();
    pb.Phoenix_Approval_Status__c = 'Draft';
    insert pb;

    Phoenix_NDC_Change_Line_Item__c bl = new Phoenix_NDC_Change_Line_Item__c();
    bl.Phoenix_NDC_Change__c = pb.Id;
    bl.Phoenix_SCM_Approval_Y_N__c = 'Not Approved';
    bl.Phoenix_Final_Status__c = 'Not Approved';
    bl.Phoenix_Is_Rejection_Noti_All_Sent__c = false;
    insert bl;
    Phoenix_NDC_Change_Line_Item__c b2 = new Phoenix_NDC_Change_Line_Item__c();
    b2.Phoenix_NDC_Change__c = pb.Id;
    b2.Phoenix_SCM_Approval_Y_N__c = 'Not Approved';
    b2.Phoenix_Final_Status__c = 'Not Approved';
    b2.Phoenix_Is_Rejection_Noti_All_Sent__c = false;
    insert b2;
    Phoenix_Bid_Process_Steps__c ps = new Phoenix_Bid_Process_Steps__c();
    ps.Phoenix_NDC_Change__c = pb.Id;
    ps.Phoenix_Approver_Team__c = 'Home Office';
    ps.Phoenix_Approver__c = UserInfo.getUserId();
    ps.Phoenix_Approver_Team_Members__c = 'Surender Patel';
    insert ps;

    List < Phoenix_Bid_Process_Steps__c > nextSteps = new list < Phoenix_Bid_Process_Steps__c > ();
    String str;
    String str2;
    Phoenix_Bid_Process_Steps__c n = new Phoenix_Bid_Process_Steps__c();
    n.Phoenix_Status__c = 'Submitted';
    n.Phoenix_Approver_Team__c = 'Marketing';
    insert n;
    nextSteps.add(n);
    set < Id > ndcLineItemSet = new set < Id > ();
    ndcLineItemSet.add(b2.Id);
    ndcLineItemSet.add(bl.Id);
    //Commented by Shashirekha
    //Phoenix_SubmitBidForApprovalCtrl.BidRejectionEmailNotificationToAll(ndcLineItemSet,pb.Id);

  }
  @isTest static void NDCSCMPartialApprovalMethod() {
    Phoenix_TestDataCreator testData = new Phoenix_TestDataCreator();
    testData.generateProducts();
    testData.generateUsers();
    Account testAccount = new Account(Name = 'Test Email Account');
    testAccount.Phoenix_Contracts_Approver__c = Userinfo.getUserId();
    insert testAccount;

    Product2 p2 = new Product2();
    p2.Family = 'Daptomycin Inj 500mg US';
    p2.Name = 'Test';
    p2.ProductCode = '300029858';
    p2.Phoenix_Marketing_Lead__c = UserInfo.getUserId();
    p2.Phoenix_Product_Director__c = testData.users[0].Id;
    insert p2;

    Phoenix_NDC_Change__c pb = new Phoenix_NDC_Change__c();
    pb.Phoenix_Approval_Status__c = 'Draft';
    insert pb;

    Phoenix_NDC_Change_Line_Item__c bl = new Phoenix_NDC_Change_Line_Item__c();
    bl.Phoenix_NDC_Change__c = pb.Id;
    bl.Phoenix_SCM_Approval_Y_N__c = 'Approved';
    bl.Phoenix_SCM_Approved_Quantity__c = 20;
    insert bl;
    Phoenix_NDC_Change_Line_Item__c b2 = new Phoenix_NDC_Change_Line_Item__c();
    b2.Phoenix_NDC_Change__c = pb.Id;
    b2.Phoenix_SCM_Approval_Y_N__c = 'Approved';
    b2.Phoenix_SCM_Approved_Quantity__c = 20;
    insert b2;
    Phoenix_Bid_Process_Steps__c ps = new Phoenix_Bid_Process_Steps__c();
    ps.Phoenix_NDC_Change__c = pb.Id;
    ps.Phoenix_Approver_Team__c = 'Home Office';
    ps.Phoenix_Approver__c = UserInfo.getUserId();
    ps.Phoenix_Approver_Team_Members__c = 'Surender Patel';
    insert ps;

    List < Phoenix_Bid_Process_Steps__c > nextSteps = new list < Phoenix_Bid_Process_Steps__c > ();
    String str;
    String str2;
    Phoenix_Bid_Process_Steps__c n = new Phoenix_Bid_Process_Steps__c();
    n.Phoenix_Status__c = 'Submitted';
    n.Phoenix_Approver_Team__c = 'Marketing';
    insert n;
    nextSteps.add(n);
    Phoenix_SubmitBidForApprovalCtrl.SCMPartialApprovalNotification(pb.Id);

  }
  static testmethod void SubmitPHSforApproval() {
    Account testAccount = new Account(Name = 'Test Account');
    testAccount.Phoenix_Contracts_Approver__c = Userinfo.getUserId();
    insert testAccount;
    Phoenix_PHS_Price_Change__c pb = new Phoenix_PHS_Price_Change__c();
    pb.Phoenix_Approval_Status__c = 'Draft';
    insert pb;
    Product2 p2 = new Product2();
    p2.Family = 'Daptomycin Inj 500mg US';
    p2.Name = 'Test';
    p2.ProductCode = '300029858';
    p2.Phoenix_Marketing_Lead__c = UserInfo.getUserId();
    p2.Phoenix_Product_Director__c = UserInfo.getUserId();
    p2.Phoenix_CIP_Implementation_Date__c=Date.valueOf('2023-10-24');
    p2.Phoenix_CIP_Throughput_Cost__c=123;
    p2.CIP_Notification_Sent_Date__c=Date.valueOf('2023-12-24');
    insert p2;
      
    Product2 p3 = new Product2();
    p3.Family = 'Abiraterone Acetate Tab';
    p3.ProductCode = '300029858';
    p3.Name = 'Test Product';
    p3.Phoenix_Marketing_Lead__c = UserInfo.getUserId();
    p3.Phoenix_Product_Director__c = UserInfo.getUserId();
    insert p3;
    
     Phoenix_Bid__c pbid = new Phoenix_Bid__c();
    pbid.Phoenix_On_Hold__c = false;
    pbid.Phoenix_Bid_Deadline_Date__c = System.today();
    //pb.Phoenix_Customer__c=testAccount.Id;
    insert pbid;
      
    List<Phoenix_Bid_Line_Item__c> pbList=new List<Phoenix_Bid_Line_Item__c>();
    Phoenix_Bid_Line_Item__c pbl1 = new Phoenix_Bid_Line_Item__c();
    pbl1.Phoenix_Bid__c = pbid.Id;
    pbl1.Phoenix_Is_New_Low_Triggered__c = true;
    pbl1.Phoenix_Approved_Lowest_Price_SKU__c = 10;
    pbl1.Phoenix_Product__c = p2.id;
    pbl1.Phoenix_Final_Status__c = 'Approved';
   	pbList.add(pbl1);

    Phoenix_PHS_Price_Change_Line__c bl = new Phoenix_PHS_Price_Change_Line__c();
    bl.Phoenix_PHS_Price_Change__c = pb.Id;

    insert bl;
    Phoenix_PHS_Price_Change_Line__c b2 = new Phoenix_PHS_Price_Change_Line__c();
    b2.Phoenix_PHS_Price_Change__c = pb.Id;

    insert b2;
    //
    Phoenix_Bid_Process_Steps__c ps = new Phoenix_Bid_Process_Steps__c();
    ps.Phoenix_Approver__c = UserInfo.getUserId();
    ps.Phoenix_PHS_Price_Change__c = pb.Id;
    ps.Phoenix_Is_Criteria_Step__c = true;
    insert ps;
    //
    Map < String, Map < String, String >> financeApprovalMap = new Map < String, Map < String, String >> ();
    Map < String, Map < String, String >> financeCommentMap = new Map < String, Map < String, String >> ();
    Map < String, String > fieldsMap = new Map < String, String > ();
    Map < String, String > fieldsMap1 = new Map < String, String > ();
    Set < Id > blitemSet = new Set < Id > ();
    blitemSet.add(bl.Id);
    blitemSet.add(b2.Id);

    fieldsMap.put('SCM Comments', 'test');
    fieldsMap1.put('SCM Rejection Reason', 'test');
    financeApprovalMap.put(bl.Id, fieldsMap);
    financeCommentMap.put(b2.Id, fieldsMap1);
    Phoenix_TestDataCreator testData = new Phoenix_TestDataCreator();
    Phoenix_SubmitBidForApprovalCtrl.BidWrapper wrap = new Phoenix_SubmitBidForApprovalCtrl.BidWrapper();
    wrap.pHSPriceChange = pb;
    testData.generateApprovalMatrix();
    Phoenix_SubmitBidForApprovalCtrl.getBidInfo(wrap.pHSPriceChange.Id);
    Phoenix_SubmitBidForApprovalCtrl.submitPHSPriceChange(pb.Id);
     Phoenix_SubmitBidForApprovalCtrl.sendCIPReminderNotification();

  }
  static testmethod void SubmitWACChangeforApproval() {
    Account testAccount = new Account(Name = 'Test Account');
    testAccount.Phoenix_Contracts_Approver__c = Userinfo.getUserId();
    insert testAccount;
    Phoenix_WAC_Change__c pb = new Phoenix_WAC_Change__c();
    pb.Phoenix_Approval_Status__c = 'Draft';
    insert pb;
    Product2 p2 = new Product2();
    p2.Family = 'Daptomycin Inj 500mg US';
    p2.Name = 'Test';
    p2.ProductCode = '300029858';
    p2.Phoenix_Marketing_Lead__c = UserInfo.getUserId();
    p2.Phoenix_Product_Director__c = UserInfo.getUserId();
    insert p2;
    Product2 p3 = new Product2();
    p3.Family = 'Abiraterone Acetate Tab';
    p3.ProductCode = '300029858';
    p3.Name = 'Test Product';
    p3.Phoenix_Marketing_Lead__c = UserInfo.getUserId();
    p3.Phoenix_Product_Director__c = UserInfo.getUserId();
    insert p3;

    Phoenix_WAC_Change_Line_Item__c bl = new Phoenix_WAC_Change_Line_Item__c();
    bl.Phoenix_WAC_Change__c = pb.Id;

    insert bl;
    Phoenix_WAC_Change_Line_Item__c b2 = new Phoenix_WAC_Change_Line_Item__c();
    b2.Phoenix_WAC_Change__c = pb.Id;

    insert b2;
    //
    Phoenix_Bid_Process_Steps__c ps = new Phoenix_Bid_Process_Steps__c();
    ps.Phoenix_Approver__c = UserInfo.getUserId();
    ps.Phoenix_WAC_Change__c = pb.Id;
    ps.Phoenix_Is_Criteria_Step__c = true;
    insert ps;
    //
    Map < String, Map < String, String >> financeApprovalMap = new Map < String, Map < String, String >> ();
    Map < String, Map < String, String >> financeCommentMap = new Map < String, Map < String, String >> ();
    Map < String, String > fieldsMap = new Map < String, String > ();
    Map < String, String > fieldsMap1 = new Map < String, String > ();
    Set < Id > blitemSet = new Set < Id > ();
    blitemSet.add(bl.Id);
    blitemSet.add(b2.Id);

    fieldsMap.put('SCM Comments', 'test');
    fieldsMap1.put('SCM Rejection Reason', 'test');
    financeApprovalMap.put(bl.Id, fieldsMap);
    financeCommentMap.put(b2.Id, fieldsMap1);
    Phoenix_TestDataCreator testData = new Phoenix_TestDataCreator();
    Phoenix_SubmitBidForApprovalCtrl.BidWrapper wrap = new Phoenix_SubmitBidForApprovalCtrl.BidWrapper();

    testData.generateApprovalMatrix();

    Phoenix_SubmitBidForApprovalCtrl.submitWACChange(pb.Id);

  }

  static testmethod void SubmitWacPricingforApproval() {
    Account testAccount = new Account(Name = 'Test Account');
    testAccount.Phoenix_Contracts_Approver__c = Userinfo.getUserId();
    insert testAccount;
    New_Product_WAC_Pricing__c pb = new New_Product_WAC_Pricing__c();
    pb.Phoenix_Approval_Status__c = 'Draft';
    insert pb;
    Product2 p2 = new Product2();
    p2.Family = 'Daptomycin Inj 500mg US';
    p2.Name = 'Test';
    p2.ProductCode = '300029858';
    p2.Phoenix_Marketing_Lead__c = UserInfo.getUserId();
    p2.Phoenix_Product_Director__c = UserInfo.getUserId();
    insert p2;
    Product2 p3 = new Product2();
    p3.Family = 'Abiraterone Acetate Tab';
    p3.ProductCode = '300029858';
    p3.Name = 'Test Product';
    p3.Phoenix_Marketing_Lead__c = UserInfo.getUserId();
    p3.Phoenix_Product_Director__c = UserInfo.getUserId();
    insert p3;

    Phoenix_NewProduct_WAC_Pricing_LineItems__c bl = new Phoenix_NewProduct_WAC_Pricing_LineItems__c();
    bl.Phoenix_New_Product_WAC_Pricing__c = pb.Id;

    insert bl;
    Phoenix_NewProduct_WAC_Pricing_LineItems__c b2 = new Phoenix_NewProduct_WAC_Pricing_LineItems__c();
    b2.Phoenix_New_Product_WAC_Pricing__c = pb.Id;

    insert b2;
    //
    Phoenix_Bid_Process_Steps__c ps = new Phoenix_Bid_Process_Steps__c();
    ps.Phoenix_Approver__c = UserInfo.getUserId();
    ps.Phoenix_New_Product_WAC_Pricing__c = pb.Id;
    ps.Phoenix_Is_Criteria_Step__c = true;
    insert ps;
    //
    Map < String, Map < String, String >> financeApprovalMap = new Map < String, Map < String, String >> ();
    Map < String, Map < String, String >> financeCommentMap = new Map < String, Map < String, String >> ();
    Map < String, String > fieldsMap = new Map < String, String > ();
    Map < String, String > fieldsMap1 = new Map < String, String > ();
    Set < Id > blitemSet = new Set < Id > ();
    blitemSet.add(bl.Id);
    blitemSet.add(b2.Id);

    fieldsMap.put('SCM Comments', 'test');
    fieldsMap1.put('SCM Rejection Reason', 'test');
    financeApprovalMap.put(bl.Id, fieldsMap);
    financeCommentMap.put(b2.Id, fieldsMap1);
    Phoenix_TestDataCreator testData = new Phoenix_TestDataCreator();
    Phoenix_SubmitBidForApprovalCtrl.BidWrapper wrap = new Phoenix_SubmitBidForApprovalCtrl.BidWrapper();

    testData.generateApprovalMatrix();
      
    Phoenix_SubmitBidForApprovalCtrl.submitNewProductWACPricing(pb.Id);

  }

  @isTest static void PHSRejectionEmailMethod() {
    Phoenix_TestDataCreator testData = new Phoenix_TestDataCreator();
    testData.generateProducts();
    testData.generateUsers();
    Account testAccount = new Account(Name = 'Test Email Account');
    testAccount.Phoenix_Contracts_Approver__c = Userinfo.getUserId();
    insert testAccount;

    Product2 p2 = new Product2();
    p2.Family = 'Daptomycin Inj 500mg US';
    p2.Name = 'Test';
    p2.ProductCode = '300029858';
    p2.Phoenix_Marketing_Lead__c = UserInfo.getUserId();
    p2.Phoenix_Product_Director__c = testData.users[0].Id;
    insert p2;

    Phoenix_PHS_Price_Change__c pb = new Phoenix_PHS_Price_Change__c();
    pb.Phoenix_Approval_Status__c = 'Draft';
    insert pb;

    Phoenix_PHS_Price_Change_Line__c bl = new Phoenix_PHS_Price_Change_Line__c();
    bl.Phoenix_PHS_Price_Change__c = pb.Id;
    bl.Phoenix_Final_Status__c = 'Not Approved';
    bl.Phoenix_Is_Rejection_Noti_All_Sent__c = false;
    insert bl;
    Phoenix_PHS_Price_Change_Line__c b2 = new Phoenix_PHS_Price_Change_Line__c();
    b2.Phoenix_PHS_Price_Change__c = pb.Id;

    b2.Phoenix_Final_Status__c = 'Not Approved';
    b2.Phoenix_Is_Rejection_Noti_All_Sent__c = false;
    insert b2;
    Phoenix_Bid_Process_Steps__c ps = new Phoenix_Bid_Process_Steps__c();
    ps.Phoenix_PHS_Price_Change__c = pb.Id;
    ps.Phoenix_Approver_Team__c = 'Home Office';
    ps.Phoenix_Approver__c = UserInfo.getUserId();
    ps.Phoenix_Approver_Team_Members__c = 'Surender Patel';
    insert ps;

    List < Phoenix_Bid_Process_Steps__c > nextSteps = new list < Phoenix_Bid_Process_Steps__c > ();
    String str;
    String str2;
    Phoenix_Bid_Process_Steps__c n = new Phoenix_Bid_Process_Steps__c();
    n.Phoenix_Status__c = 'Submitted';
    n.Phoenix_Approver_Team__c = 'Marketing';
    insert n;
    nextSteps.add(n);
    set < Id > pHSLineItemSet = new set < Id > ();
    pHSLineItemSet.add(b2.Id);
    pHSLineItemSet.add(bl.Id);
    //Commented by Shashirekha
    //Phoenix_SubmitBidForApprovalCtrl.BidRejectionEmailNotificationToAll(pHSLineItemSet,pb.Id);

  }
  @isTest static void WACChangeRejectionEmailMethod() {
    Phoenix_TestDataCreator testData = new Phoenix_TestDataCreator();
    testData.generateProducts();
    testData.generateUsers();
    Account testAccount = new Account(Name = 'Test Email Account');
    testAccount.Phoenix_Contracts_Approver__c = Userinfo.getUserId();
    insert testAccount;

    Product2 p2 = new Product2();
    p2.Family = 'Daptomycin Inj 500mg US';
    p2.Name = 'Test';
    p2.ProductCode = '300029858';
    p2.Phoenix_Marketing_Lead__c = UserInfo.getUserId();
    p2.Phoenix_Product_Director__c = testData.users[0].Id;
    insert p2;

    Phoenix_WAC_Change__c pb = new Phoenix_WAC_Change__c();
    pb.Phoenix_Approval_Status__c = 'Draft';
    insert pb;

    Phoenix_WAC_Change_Line_Item__c bl = new Phoenix_WAC_Change_Line_Item__c();
    bl.Phoenix_WAC_Change__c = pb.Id;
    bl.Phoenix_Final_Status__c = 'Not Approved';
    bl.Phoenix_Is_Rejection_Noti_All_Sent__c = false;
    insert bl;
    Phoenix_WAC_Change_Line_Item__c b2 = new Phoenix_WAC_Change_Line_Item__c();
    b2.Phoenix_WAC_Change__c = pb.Id;

    b2.Phoenix_Final_Status__c = 'Not Approved';
    b2.Phoenix_Is_Rejection_Noti_All_Sent__c = false;
    insert b2;
    Phoenix_Bid_Process_Steps__c ps = new Phoenix_Bid_Process_Steps__c();
    ps.Phoenix_WAC_Change__c = pb.Id;
    ps.Phoenix_Approver_Team__c = 'Home Office';
    ps.Phoenix_Approver__c = UserInfo.getUserId();
    ps.Phoenix_Approver_Team_Members__c = 'Surender Patel';
    insert ps;

    List < Phoenix_Bid_Process_Steps__c > nextSteps = new list < Phoenix_Bid_Process_Steps__c > ();
    String str;
    String str2;
    Phoenix_Bid_Process_Steps__c n = new Phoenix_Bid_Process_Steps__c();
    n.Phoenix_Status__c = 'Submitted';
    n.Phoenix_Approver_Team__c = 'Marketing';
    insert n;
    nextSteps.add(n);
    set < Id > pHSLineItemSet = new set < Id > ();
    pHSLineItemSet.add(b2.Id);
    pHSLineItemSet.add(bl.Id);
    //Commented by Shashirekha
    //Phoenix_SubmitBidForApprovalCtrl.BidRejectionEmailNotificationToAll(pHSLineItemSet,pb.Id);

  }
  @isTest static void NewWACCRejectionEmailMethod() {
    Phoenix_TestDataCreator testData = new Phoenix_TestDataCreator();
    testData.generateProducts();
    testData.generateUsers();
    Account testAccount = new Account(Name = 'Test Email Account');
    testAccount.Phoenix_Contracts_Approver__c = Userinfo.getUserId();
    insert testAccount;

    Product2 p2 = new Product2();
    p2.Family = 'Daptomycin Inj 500mg US';
    p2.Name = 'Test';
    p2.ProductCode = '300029858';
    p2.Phoenix_Marketing_Lead__c = UserInfo.getUserId();
    p2.Phoenix_Product_Director__c = testData.users[0].Id;
    insert p2;

    New_Product_WAC_Pricing__c pb = new New_Product_WAC_Pricing__c();
    pb.Phoenix_Approval_Status__c = 'Draft';
    insert pb;

    Phoenix_NewProduct_WAC_Pricing_LineItems__c bl = new Phoenix_NewProduct_WAC_Pricing_LineItems__c();
    bl.Phoenix_New_Product_WAC_Pricing__c = pb.Id;
    bl.Phoenix_Final_Status__c = 'Not Approved';
    bl.Phoenix_Is_Rejection_Noti_All_Sent__c = false;
    insert bl;
    Phoenix_NewProduct_WAC_Pricing_LineItems__c b2 = new Phoenix_NewProduct_WAC_Pricing_LineItems__c();
    b2.Phoenix_New_Product_WAC_Pricing__c = pb.Id;

    b2.Phoenix_Final_Status__c = 'Not Approved';
    b2.Phoenix_Is_Rejection_Noti_All_Sent__c = false;
    insert b2;
    Phoenix_Bid_Process_Steps__c ps = new Phoenix_Bid_Process_Steps__c();
    ps.Phoenix_New_Product_WAC_Pricing__c = pb.Id;
    ps.Phoenix_Approver_Team__c = 'Home Office';
    ps.Phoenix_Approver__c = UserInfo.getUserId();
    ps.Phoenix_Approver_Team_Members__c = 'Surender Patel';
    insert ps;

    List < Phoenix_Bid_Process_Steps__c > nextSteps = new list < Phoenix_Bid_Process_Steps__c > ();
    String str;
    String str2;
    Phoenix_Bid_Process_Steps__c n = new Phoenix_Bid_Process_Steps__c();
    n.Phoenix_Status__c = 'Submitted';
    n.Phoenix_Approver_Team__c = 'Marketing';
    insert n;
    nextSteps.add(n);
    set < Id > pHSLineItemSet = new set < Id > ();
    pHSLineItemSet.add(b2.Id);
    pHSLineItemSet.add(bl.Id);
    //Commented by Shashirekha
    //hoenix_SubmitBidForApprovalCtrl.BidRejectionEmailNotificationToAll(pHSLineItemSet,pb.Id);

  }

  static testmethod void SubmitNDCforApproval() {
    Account testAccount = new Account(Name = 'Test Account');
    testAccount.Phoenix_Contracts_Approver__c = Userinfo.getUserId();
    insert testAccount;
    Phoenix_NDC_Change__c pb = new Phoenix_NDC_Change__c();
    pb.Phoenix_Approval_Status__c = 'Draft';
    insert pb;
    Product2 p2 = new Product2();
    p2.Family = 'Daptomycin Inj 500mg US';
    p2.Name = 'Test';
    p2.ProductCode = '300029858';
    p2.Phoenix_Marketing_Lead__c = UserInfo.getUserId();
    p2.Phoenix_Product_Director__c = UserInfo.getUserId();
    insert p2;
    Product2 p3 = new Product2();
    p3.Family = 'Abiraterone Acetate Tab';
    p3.ProductCode = '300029858';
    p3.Name = 'Test Product';
    p3.Phoenix_Marketing_Lead__c = UserInfo.getUserId();
    p3.Phoenix_Product_Director__c = UserInfo.getUserId();
    insert p3;

    Phoenix_NDC_Change_Line_Item__c bl = new Phoenix_NDC_Change_Line_Item__c();
    bl.Phoenix_NDC_Change__c = pb.Id;
    bl.Phoenix_SCM_Approval_Y_N__c = 'Approved';
    bl.Phoenix_SCM_Approved_Quantity__c = 20;
    insert bl;
    Phoenix_NDC_Change_Line_Item__c b2 = new Phoenix_NDC_Change_Line_Item__c();
    b2.Phoenix_NDC_Change__c = pb.Id;
    b2.Phoenix_SCM_Approval_Y_N__c = 'Approved';
    b2.Phoenix_SCM_Approved_Quantity__c = 20;
    insert b2;
    //
    Phoenix_Bid_Process_Steps__c ps = new Phoenix_Bid_Process_Steps__c();
    ps.Phoenix_Approver__c = UserInfo.getUserId();
    ps.Phoenix_NDC_Change__c = pb.Id;
    ps.Phoenix_Is_Criteria_Step__c = true;
    insert ps;
    //
    Map < String, Map < String, String >> financeApprovalMap = new Map < String, Map < String, String >> ();
    Map < String, Map < String, String >> financeCommentMap = new Map < String, Map < String, String >> ();
    Map < String, String > fieldsMap = new Map < String, String > ();
    Map < String, String > fieldsMap1 = new Map < String, String > ();
    Set < Id > blitemSet = new Set < Id > ();
    blitemSet.add(bl.Id);
    blitemSet.add(b2.Id);

    fieldsMap.put('SCM Comments', 'test');
    fieldsMap1.put('SCM Rejection Reason', 'test');
    financeApprovalMap.put(bl.Id, fieldsMap);
    financeCommentMap.put(b2.Id, fieldsMap1);
    Phoenix_TestDataCreator testData = new Phoenix_TestDataCreator();
    Phoenix_SubmitBidForApprovalCtrl.BidWrapper wrap = new Phoenix_SubmitBidForApprovalCtrl.BidWrapper();
    wrap.ndcChange = pb;
    testData.generateApprovalMatrix();
    Phoenix_SubmitBidForApprovalCtrl.getBidInfo(wrap.ndcChange.Id);
    Phoenix_SubmitBidForApprovalCtrl.submitNDCChange(wrap);

  }
  @isTest static void MkgHeadEmailMethods() {
    Phoenix_TestDataCreator testData = new Phoenix_TestDataCreator();
    testData.generateProducts();
    testData.generateUsers();
    Account testAccount = new Account(Name = 'Test Email Account');
    testAccount.Phoenix_Contracts_Approver__c = Userinfo.getUserId();
    insert testAccount;

    Product2 p2 = new Product2();
    p2.Family = 'Daptomycin Inj 500mg US';
    p2.Name = 'Test';
    p2.ProductCode = '300029858';
    p2.Phoenix_Marketing_Lead__c = UserInfo.getUserId();
    p2.Phoenix_Product_Director__c = testData.users[0].Id;
    insert p2;

    Phoenix_Bid__c pb = new Phoenix_Bid__c();
    pb.Phoenix_Status__c = 'New';
    pb.Phoenix_Comments__c = 'Test Comments';
    pb.Phoenix_Customer__c = testAccount.Id;
    pb.Phoenix_Customer_Bid_Deadline_Date_Time__c = DateTime.now();
    pb.Phoenix_Customer_Bid_Deadline_Time_zone__c = 'PST';
    pb.Phoenix_Customer_Bid_Deadline_Time__c = '6 PM';
    pb.Phoenix_Customer_Type__c = 'Direct and Indirect';
    pb.Phoenix_Bid_Deadline_Date__c = System.today();
    pb.Phoenix_Bid_Type__c = 'WAC Change Submissions';
    pb.Phoenix_Approval_Status__c = 'Draft';
    pb.Phoenix_Internal_Target_Date__c = Date.parse('10/12/2021');
    //User curUser = [SELECT Id, Username, Email FROM User where Username = 'manisha+phoenix+project1@dhruvsoft.com'];
    //pb.Phoenix_Sales_Person_2__c=curUser.Id;
    pb.Phoenix_Sales_Person_2__c = Userinfo.getUserId();
    //pb.Phoenix_Salesperson__c =UserInfo.getUserId();
    insert pb;

    Phoenix_Bid_Line_Item__c bl = new Phoenix_Bid_Line_Item__c();
    bl.Phoenix_Bid__c = pb.Id;
    bl.Phoenix_Current_Direct_Price__c = 10;
    bl.Phoenix_Product_Code1__c = '300029858';
    bl.Phoenix_Product_Family1__c = 'Daptomycin Inj 500mg US';
    bl.Phoenix_Current_Indirect_Selling_Unit__c = 10;
    bl.Phoenix_Product__c = testData.productList[0].Id;
    bl.Phoenix_Final_Status__c = 'Approved';
    bl.Phoenix_SCM_Approval_Y_N__c = 'Y- Only Current Monthly Demand Approved';
    bl.Phoenix_Marketing_Final_Approval__c = true;
    insert bl;
    Phoenix_Bid_Line_Item__c b2 = new Phoenix_Bid_Line_Item__c();
    b2.Phoenix_Bid__c = pb.Id;
    b2.Phoenix_Current_Direct_Price__c = 10;
    b2.Phoenix_Product_Code1__c = '300029858';
    b2.Phoenix_Product_Family1__c = 'Daptomycin Inj 500mg US';
    b2.Phoenix_Current_Indirect_Selling_Unit__c = 10;
    b2.Phoenix_Product__c = p2.Id;
    b2.Phoenix_Final_Status__c = 'Approved';
    b2.Phoenix_SCM_Approval_Y_N__c = 'Y- Only Current Monthly Demand Approved';
    b2.Phoenix_Marketing_Final_Approval__c = true;
    b2.Phoenix_SCM_Approved_Quantity__c = 20;
    insert b2;
    Phoenix_Bid_Process_Steps__c ps = new Phoenix_Bid_Process_Steps__c();
    ps.Phoenix_Bid__c = pb.Id;
    ps.Phoenix_Approver_Team__c = 'Home Office';
    ps.Phoenix_Approver__c = UserInfo.getUserId();
    ps.Phoenix_Approver_Team_Members__c = 'Surender Patel';
    insert ps;
    Phoenix_Approval_Grid__c approvalGrid = new Phoenix_Approval_Grid__c(Name = 'Test grid');
    approvalGrid.Phoenix_Bid__c = pb.Id;
    approvalGrid.Phoenix_Is_Mkg_Head_Noti_Required__c = true;
    approvalGrid.Phoenix_Is_partner_product__c = false;
    approvalGrid.Phoenix_Annualized_TP__c = 10;
    insert approvalGrid;

    Phoenix_Approval_Grid__c approvalGrid2 = new Phoenix_Approval_Grid__c(Name = 'Test grid2');
    approvalGrid2.Phoenix_Bid__c = pb.Id;
    approvalGrid2.Phoenix_Is_Mkg_Head_Noti_Required__c = true;
    approvalGrid2.Phoenix_Is_partner_product__c = true;
    approvalGrid2.Phoenix_Annualized_TP__c = 100;
    approvalGrid2.Phoenix_Product_Family__c = 'abc';
    insert approvalGrid2;
    List < Phoenix_Bid_Process_Steps__c > nextSteps = new list < Phoenix_Bid_Process_Steps__c > ();
    String str;
    String str2;
    Phoenix_Bid_Process_Steps__c n = new Phoenix_Bid_Process_Steps__c();
    n.Phoenix_Status__c = 'Submitted';
    n.Phoenix_Approver_Team__c = 'Marketing';
    insert n;
    nextSteps.add(n);
    List < Id > bidIds = new List < Id > ();
    bidIds.add(pb.Id);
    //Test.startTest();
    Phoenix_SubmitBidForApprovalCtrl.MkgHeadEmailNotification(pb.Id);
      Phoenix_SubmitBidForApprovalCtrl.sendCIPReminderNotification();
    //Test.stopTest();
  }
  @isTest static void SubmitBidforApprovalnew1() {


    Account testAccount = new Account(Name = 'Test Account', Phoenix_Preferred_Wholesaler__c = 'ABC', Phoenix_Is_Govt_Customer__c = true);
    insert testAccount;

    Phoenix_Bid__c bid = new Phoenix_Bid__c();
    bid.Phoenix_Status__c = 'New';
    bid.Phoenix_Comments__c = 'Test Comments';
    bid.Phoenix_Customer__c = testAccount.Id;
    bid.Phoenix_Bid_Type__c = 'Contracts Only';
    insert bid;

       Product2 p2 = new Product2();
    p2.Family = 'Daptomycin Inj 500mg US';
    p2.Name = 'Test';
    p2.ProductCode = '300029858';
    p2.Phoenix_Marketing_Lead__c = UserInfo.getUserId();
    insert p2;
      Phoenix_Bid_Action_Item__c actionItem = new Phoenix_Bid_Action_Item__c();
      actionItem.Phoenix_Bid__c =  bid.Id;
      actionItem.Phoenix_Account__c =testAccount.Id;
      actionItem.Phoenix_Product__c =p2.Id;
      Insert actionItem;
       Phoenix_Bid_Action_Item__c actionItem2 = new Phoenix_Bid_Action_Item__c();
      actionItem2.Phoenix_Bid__c =  bid.Id;
      actionItem2.Phoenix_Account__c =testAccount.Id;
      actionItem2.Phoenix_Product__c =p2.Id;
      Insert actionItem2;
      List<Phoenix_Bid_Action_Item__c> actionItemsList = new List<Phoenix_Bid_Action_Item__c>();
      actionItemsList.add(actionItem2);
      actionItemsList.add(actionItem);
      Checklist__c check = new Checklist__c();
    // check.Name='test';
    check.Bid__c = bid.Id;
Phoenix_Bid_Process_Steps__c ps = new Phoenix_Bid_Process_Steps__c();
    ps.Phoenix_Bid__c = bid.Id;
    ps.Phoenix_Approver_Team__c = 'Home Office';
    ps.Phoenix_Approver__c = UserInfo.getUserId();
    ps.Phoenix_Approver_Team_Members__c = 'Surender Patel';
    insert ps;
    insert check;
Group grp = new Group();
        grp.Type = 'Regular';
        grp.Name ='admin Users';
        Insert grp;
 Phoenix_SubmitBidForApprovalCtrl.sendEmailToMDMTeam(bid.Id,actionItemsList);
       Phoenix_SubmitBidForApprovalCtrl.sendEmailToAllApprovers(bid.Id,actionItemsList);

    Phoenix_SubmitBidForApprovalCtrl.getBidInfo(bid.Id);
      Id UserId = Userinfo.getUserId();
   		//Phoenix_SubmitBidForApprovalCtrl.delegationEmailAlert(UserId);
      Phoenix_SubmitBidForApprovalCtrl.sendCIPReminderNotification();
      Phoenix_SubmitBidForApprovalCtrl.closeDraftBid(bid.Id);
  }
  
    public static void testGetBidInfo() {
        // Create test account
        Account testAccount = new Account(Name = 'Test Account', Phoenix_Preferred_Wholesaler__c = 'ABC', Phoenix_Is_Govt_Customer__c = true);
        insert testAccount;

        // Create a Contracts Only bid
        Phoenix_Bid__c contractsOnlyBid = new Phoenix_Bid__c();
        contractsOnlyBid.Phoenix_Status__c = 'New';
        contractsOnlyBid.Phoenix_Comments__c = 'Test Comments';
        contractsOnlyBid.Phoenix_Customer__c = testAccount.Id;
        contractsOnlyBid.Phoenix_Bid_Type__c = 'Contracts Only';
        insert contractsOnlyBid;

        // Create a VIP Rebate bid with related documents
        Phoenix_Bid__c vipRebateBid = new Phoenix_Bid__c();
        vipRebateBid.Phoenix_Status__c = 'New';
        vipRebateBid.Phoenix_Comments__c = 'Test Comments';
        vipRebateBid.Phoenix_Customer__c = testAccount.Id;
        vipRebateBid.Phoenix_Bid_Type__c = 'VIP Rebate';
        insert vipRebateBid;

        Product2 testProduct = new Product2(
            Family = 'Daptomycin Inj 500mg US',
            Name = 'Test',
            ProductCode = '300029858',
            Phoenix_Marketing_Lead__c = UserInfo.getUserId()
        );
        insert testProduct;

        Phoenix_Bid_Action_Item__c actionItem = new Phoenix_Bid_Action_Item__c(
            Phoenix_Bid__c = vipRebateBid.Id,
            Phoenix_Account__c = testAccount.Id,
            Phoenix_Product__c = testProduct.Id
        );
        insert actionItem;

        // Create a checklist bid
        Phoenix_Bid__c checklistBid = new Phoenix_Bid__c();
        checklistBid.Phoenix_Status__c = 'New';
        checklistBid.Phoenix_Comments__c = 'Test Comments';
        checklistBid.Phoenix_Customer__c = testAccount.Id;
        checklistBid.Phoenix_Bid_Type__c = 'Contracts Only';
        insert checklistBid;

        Checklist__c checklist = new Checklist__c(Bid__c = checklistBid.Id);
        insert checklist;

     Phoenix_SubmitBidForApprovalCtrl.getBidInfo(contractsOnlyBid.Id);
	 Phoenix_SubmitBidForApprovalCtrl.getBidInfo(vipRebateBid.Id);
   
       
    }
 /*  @isTest
static void delegationEmailAlert_TestMethod() {
    // Create a test user
    
    Profile testProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User'];
    User testUser = new User(
        ProfileId = testProfile.Id,
        Username = 'testuser12@example.com',
        Email = 'shashirekha@dhruvsoft.com',
        FirstName = 'Test',
        LastName = 'User',
        Alias = 'TUser',
        TimeZoneSidKey = 'America/Los_Angeles',
        LocaleSidKey = 'en_US',
        EmailEncodingKey = 'UTF-8',
        LanguageLocaleKey = 'en_US',
        Phoenix_Delegated_Approver__c=UserInfo.getUserId(),
        Phoenix_Delegation_End_Time__c=DateTime.newInstance(2023, 11, 30, 12, 30, 0),
        Phoenix_Delegation_Start_Time__c=DateTime.newInstance(2023, 11, 30, 10, 30, 0)
    );

    // No need to specify Id during insert
    insert testUser;
    
    Phoenix_SubmitBidForApprovalCtrl.delegationEmailAlert(testUser.Id);
    Phoenix_SubmitBidForApprovalCtrl.delegationEndEmailAlert(testUser.Id);
    
}
    @isTest
static void sendEmailToVistexTeam_TestMethod() {
    // Create a test user
    
    Profile testProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User'];
    User testUser = new User(
        ProfileId = testProfile.Id,
        Username = 'testuser12@example.com',
        Email = 'shashirekha@dhruvsoft.com',
        FirstName = 'Test',
        LastName = 'User',
        Alias = 'TUser',
        TimeZoneSidKey = 'America/Los_Angeles',
        LocaleSidKey = 'en_US',
        EmailEncodingKey = 'UTF-8',
        LanguageLocaleKey = 'en_US',
        Phoenix_Delegated_Approver__c=UserInfo.getUserId(),
        Phoenix_Delegation_End_Time__c=DateTime.newInstance(2023, 11, 30, 12, 30, 0),
        Phoenix_Delegation_Start_Time__c=DateTime.newInstance(2023, 11, 30, 10, 30, 0)
    );

    // No need to specify Id during insert
    insert testUser;
    
    Account testAccount = new Account(Name = 'T');
        testAccount.Phoenix_Contracts_Approver__c = Userinfo.getUserId();
        insert testAccount;
    
    Phoenix_Bid__c pb = new Phoenix_Bid__c();
   // pb.Phoenix_On_Hold__c = false;
    //pb.Phoenix_Bid_Deadline_Date__c = System.today();
    pb.Phoenix_Customer__c=testAccount.Id;
    insert pb;
    
    //Phoenix_SubmitBidForApprovalCtrl.sendEmailToVistexTeam(testAccount.Id, pb.Id);
   
}*/
     
}