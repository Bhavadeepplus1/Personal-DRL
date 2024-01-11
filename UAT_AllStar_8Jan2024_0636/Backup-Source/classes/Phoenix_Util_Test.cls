@isTest(SeeAllData=false)
public class Phoenix_Util_Test {
   
	 @isTest
    public static void testMethod1() {
     
        Decimal positiveValue = 100.50;
        String obj='Phoenix_Bid__c';
        String str='String';
        DateTime today =System.now();
        String result = Phoenix_Util.format(positiveValue);
        Phoenix_Util.getsObjectFieds(obj);
      	Phoenix_Util.removeSymbolsFromString(str);
       	Phoenix_Util.getUserTimeNow(today,str);
        Phoenix_Util.getUserTime(today,str);
        
        
    }
    @isTest
    public static void testMethod2() {
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
        pb.Phoenix_Customer_Type__c = 'Product Discontinuation Process';
        pb.Phoenix_Bid_Deadline_Date__c = System.today();
        pb.Phoenix_Bid_Type__c = 'RFP Bids';
        pb.Phoenix_Approval_Status__c = 'Draft';
       	insert pb;
        
        Phoenix_Approval_Matrix__c pam=new Phoenix_Approval_Matrix__c();
        pam.Name='Marketing Lead Rx Approval';
        insert pam;
        
        Phoenix_Approval_Process_Step__c pap=new Phoenix_Approval_Process_Step__c();
        pap.Phoenix_Approver__c=UserInfo.getUserId();
        pap.Name='Marketing Lead Rx Approval';
        pap.Phoenix_Approval_Matrix__c=pam.Id;
        insert pap;
        
        List<Phoenix_Bid_Process_Steps__c> psList = new List<Phoenix_Bid_Process_Steps__c>();
        Phoenix_Bid_Process_Steps__c ps = new Phoenix_Bid_Process_Steps__c();
        ps.Phoenix_Approver__c = null;
        ps.Phoenix_Approver_Team__c='Sales';
        ps.Phoenix_Is_Criteria_Step__c = false;
        ps.Phoenix_Status__c = 'In Process';
        ps.Phoenix_Process_Step__c=pap.Id;
        ps.Phoenix_Bid__c = pb.Id;
        insert ps;
        psList.add(ps);
        
        Phoenix_Contract__c pc=new Phoenix_Contract__c();
        pc.Phoenix_Customer__c=testAccount.Id;
        insert pc;
        
        Phoenix_NPR_Data__c npr=new Phoenix_NPR_Data__c();
        npr.Phoenix_Account__c=testAccount.Id;
        npr.Phoenix_Contract__c=pc.Id;
        insert npr;
        
        Product2 prod = new Product2(Name = 'Test Product',Phoenix_IPA_Floor_Price__c=100,Phoenix_Is_IPA_Product__c =TRUE,Phoenix_GPI_Generic_Product_Identifier__c='11111',Phoenix_NDC_11__c='12345678902', Family = 'Test Family', IsActive = TRUE);
		insert prod;
        
        Phoenix_Bid_Line_Item__c pbl = new Phoenix_Bid_Line_Item__c(Phoenix_Bid__c = pb.Id, Phoenix_Product__c = prod.Id,Phoenix_Proposed_IPA_Price__c=100,Phoenix_IDN_Usage__c=10);
		insert pbl;
        
        Phoenix_Approval_Grid__c pag=new Phoenix_Approval_Grid__c();
         pag.Phoenix_Marketing_Lead_SRx__c='Not Approved';
         pag.Phoenix_Bid_Line_Item__c=pbl.Id;
         pag.Phoenix_Bid__c	=pb.Id;
         pag.Phoenix_Marketing_Lead_OTC__c='Not Approved';
         pag.Phoenix_Marketing_Lead_Rx__c='Not Approved';
         insert pag;
        
        Product_Family__c pf=new Product_Family__c();
        pf.Name='Product';
        insert pf;
        
        Phoenix_NDC_Change__c ndc=new Phoenix_NDC_Change__c();
       	ndc.Proposed_Product_Family__c=pf.Id;
        ndc.Phoenix_Approval_Status__c='Closed';
        insert ndc;
       
       	Phoenix_NDC_Change_Line_Item__c NDCLine=new Phoenix_NDC_Change_Line_Item__c();
       	NDCLine.Phoenix_Remarks__c='Remarks';
        NDCLine.Phoenix_Current_Product__c=prod.Id;
        NDCLine.Phoenix_NDC_Change__c=ndc.Id;
        NDCLine.Phoenix_Final_Status__c = 'Not Approved';
        NDCLine.Phoenix_Is_Rejection_Noti_All_Sent__c = false;  
        NDCLine.Phoenix_NDC_Line_Item_Approval_Status__c='Finance Rejected';
        NDCLine.Phoenix_Contracts_Approval_Remarks__c='Remarks';
        NDCLine.Phoenix_SCM_Rejection_Reason__c='Remarks';
        NDCLine.Phoenix_Remarks__c='Remarks';
        NDCLine.Phoenix_Contracts_Approval_Remarks__c='Remarks';
        NDCLine.Phoenix_Finance_Approval_Remarks__c='Remarks';
        insert NDCLine;
        
        Phoenix_WAC_Change__c wac=new Phoenix_WAC_Change__c();
        wac.Product_Family__c=pf.Id;
        //wac.Phoenix_Account__c=testAccount.Id;
        wac.Phoenix_Approval_Status__c='Closed';
        insert wac;
        
        Phoenix_WAC_Change_Line_Item__c wacLine=new Phoenix_WAC_Change_Line_Item__c();
        wacLine.Phoenix_WAC_Change__c=wac.Id;
        wacLine.Product_Family__c=pf.id;
        wacLine.Phoenix_Product__c=prod.Id;
        wacLine.Phoenix_Final_Status__c = 'Not Approved';
        wacLine.Phoenix_Is_Rejection_Noti_All_Sent__c = false;
        wacLine.Phoenix_Account__c=testAccount.Id;
       	insert wacLine;
        
         Phoenix_PHS_Price_Change__c phs=new Phoenix_PHS_Price_Change__c();
       	phs.Phoenix_Account__c=testAccount.Id;
        phs.Phoenix_Approval_Status__c='Closed';
        insert phs;
       
       	Phoenix_PHS_Price_Change_Line__c phsLine=new Phoenix_PHS_Price_Change_Line__c();
       	phsLine.Phoenix_Remarks__c='Remarks';
        phsLine.Phoenix_Product_Name__c=prod.Id;
        phsLine.Phoenix_PHS_Price_Change__c=phs.Id;
        phsLine.Phoenix_Final_Status__c = 'Not Approved';
        phsLine.Phoenix_Is_Rejection_Noti_All_Sent__c = false;
        phsLine.Phoenix_Sales_Difference__c=34;
        phsLine.Phoenix_Last_90_days_PHS_Units__c=3;
        phsLine.Phoenix_Change_in_Price__c=3;
        phsLine.Phoenix_New_PHS_Price__c=100;
        phsLine.Phoenix_Old_PHS_Price__c=50;
        phsLine.Phoenix_Finance_Approval_Remarks__c='Remarks';
        phsLine.Phoenix_Provisional_PHS_Price__c=50;
        phsLine.Phoenix_NDC_11__c='NDC';
        phsLine.Phoenix_Material_Code__c='Material';
        phsLine.Phoenix_Remarks__c='Remarks';
            
        insert phsLine;
        
        New_Product_WAC_Pricing__c newWac=new New_Product_WAC_Pricing__c();
        newWac.Product_Family__c=pf.Id;
        newWac.Phoenix_Approval_Status__c='Closed';
        newWac.Phoenix_Net_sales_annualized__c=100;
        newWac.Phoenix_Product_Type__c='Product';
        newWac.Phoenix_Product_Family__c='Product';
        newWac.Phoenix_GM__c=34;
        newWac.Phoenix_TPT__c=5;
        newWac.Phoenix_Marketing_Lead__c=UserInfo.getUserId();
        newWac.Phoenix_Summary__c='Remarks';
        newWac.Phoenix_Head_of_Marketing_Comments__c='Remarks';
        insert newWac;
        
        Phoenix_NewProduct_WAC_Pricing_LineItems__c newWacLine=new Phoenix_NewProduct_WAC_Pricing_LineItems__c();
       	newWacLine.Phoenix_Final_Status__c = 'Not Approved';
       	newWacLine.Phoenix_Is_Rejection_Noti_All_Sent__c = false;
        newWacLine.Phoenix_Product__c=prod.Id;
        
       	insert newWacLine;
        
        Phoenix_Bid_Line_Item_Price_History__c bidItem=new Phoenix_Bid_Line_Item_Price_History__c();
        bidItem.Name='Bid';
        bidItem.Phoenix_Sell_Price_Change__c=5;
        insert bidItem;
        
        Phoenix_Bid_Action_Item__c bidAction=new Phoenix_Bid_Action_Item__c();
        bidAction.Phoenix_Product__c=prod.Id;
        bidAction.Phoenix_Bid__c=pb.Id;
        bidAction.Phoenix_Bid_Line_Item__c=pbl.Id;
        insert bidAction;
        
        Phoenix_Customer_Response__c custRes=new Phoenix_Customer_Response__c();
        custRes.Phoenix_NDC_Change__c=ndc.Id;
        custRes.Phoenix_Customer__c=testAccount.Id;
        custRes.Phoenix_Bid_No__c=pb.Id;
        insert custRes;
        
        Phoenix_Customer_Response_Line__c custResLine=new Phoenix_Customer_Response_Line__c();
        custResLine.Product_Family__c=pf.id;
        custResLine.Phoenix_NDC_Change_Line_Item__c=NDCLine.Id;
        custResLine.Phoenix_NDC_Change__c=ndc.Id;
        custResLine.Phoenix_Customer_Response__c=custRes.Id;
        //custResLine.Bid_Line_Item_Extn__c=
        custResLine.Phoenix_Bid_Line_Item__c=pbl.Id;
        custResLine.Phoenix_Bid__c=pb.Id;
        insert custResLine;
        
        Phoenix_SAP_NPR_Staging__c nprStage=new Phoenix_SAP_NPR_Staging__c();
        nprStage.Phoenix_Is_Sync_Completed__c=true;
        nprStage.Phoenix_Total_NPR_Lines__c=4;
        insert nprStage;
        
        Phoenix_Awarded_Quantity__c awq=new Phoenix_Awarded_Quantity__c();
        awq.GCP_Product_Family__c=pf.Id;
        awq.Phoenix_Product__c=prod.Id;
        awq.Phoenix_NPR_Data__c=npr.Id;
        awq.Customer_Response_Line__c=custResLine.Id;
        awq.Phoenix_Customer__c=testAccount.Id;
        awq.Phoenix_Contract__c=pc.id;
        awq.Phoenix_Bid_Line_Item__c=pbl.Id;
        awq.Phoenix_Bid__c=pb.Id;
        insert awq;
        
        Phoenix_NPR_Data__c nprData=new Phoenix_NPR_Data__c();
        nprData.Phoenix_Product__c=prod.Id;
        nprData.Phoenix_Account__c=testAccount.Id;
        nprData.Phoenix_Contract__c=pc.id;
        nprData.Phoenix_Awarded_Quantity_Record__c=awq.id;
        insert nprData;
        
        Phoenix_NPR_Volume__c nprVol=new Phoenix_NPR_Volume__c();
        nprVol.Phoenix_Volume__c=5;
        nprVol.Phoenix_NPR_Data__c=nprData.Id;
        insert nprVol;
        
       	Phoenix_User_Approval_Matrix__c group1= new Phoenix_User_Approval_Matrix__c(RecordTypeId = Phoenix_User_Approval_Matrix__c.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Approval_User_Group').getRecordTypeId(),Phoenix_Approver_Group_Name__c = 'Sales',Phoenix_Approval_Group_Behavior__c='Single User');
		insert group1;
		Contact testContact = new Contact(
            FirstName = 'John',
            LastName = 'Doe',
            Email = 'john.doe@example.com' );
        insert testContact;
        
        Phoenix_RCA_IPA_LINE__c rca=new Phoenix_RCA_IPA_LINE__c();
        rca.Phoenix_RCA_Agreement__c=pc.Id;
        rca.Phoenix_RAM__c=UserInfo.getUserId();
        rca.Phoenix_Parent_IPA_Customer__c=testAccount.Id;
        rca.Phoenix_New_RCA_Agreement__c=pc.Id;
        rca.Phoenix_Contact__c=testContact.Id;
        rca.Phoenix_Bid__c=pb.Id;
        rca.Phoenix_Customer__c=testAccount.Id;
        insert rca;
        
        Phoenix_NDC_Change_Product__c ndcProduct=new Phoenix_NDC_Change_Product__c();
        ndcProduct.Phoenix_Proposed_Product__c=prod.Id;
        ndcProduct.Phoenix_NDC_Change_Name__c=ndc.Id;
        ndcProduct.Phoenix_Current_Product__c=prod.Id;
        insert ndcProduct;
        
        Phoenix_BidLineItemExtn__c pblext=new Phoenix_BidLineItemExtn__c();
        pblext.Phoenix_Bid_Line_Item__c=pbl.Id;
        insert pblext;
        
        Phoenix_Future_NPR_Data__c futureNPR=new Phoenix_Future_NPR_Data__c();
        futureNPR.Phoenix_Product__c=prod.Id;
        futureNPR.Phoenix_Account__c=testAccount.Id;
        futureNPR.Phoenix_Contract__c=pc.Id;
        insert futureNPR;
        
        Phoenix_NPR_Snapshot__c nprSnap=new Phoenix_NPR_Snapshot__c();
        nprSnap.Phoenix_NPR_Data__c=nprData.Id;
        insert nprSnap;
        
         DateTime today =System.now();
         String  SrcTimeZone='10' ;
         String targetTimeZone='10';
        
        Phoenix_Util.sortBidProcessSteps(psList);
       	String nprResult=Phoenix_Util.nprDataFields;
        String contractResult=Phoenix_Util.contractFields;
        String AccountResult=Phoenix_Util.customerFields;
        String bidResult=Phoenix_Util.bidFields;
		String processResult=Phoenix_Util.bidProcessStepFields;
        String prodResult=Phoenix_Util.productFields;
        String bidLineResult=Phoenix_Util.bidlineitemFields;
        String appmatrixResult=Phoenix_Util.approvalMatrixFields;
        String appGridResult=Phoenix_Util.approvalGridFields;
        String appProcessResult=Phoenix_Util.approvalProcessStepFields;
        String ndcResult=Phoenix_Util.ndcChangeFields;
        String ndcLineResult=Phoenix_Util.ndcChangeLineItemFields;
        String wacChangeFields=Phoenix_Util.wacChangeFields;
        String wacChangeLineItemFields=Phoenix_Util.wacChangeLineItemFields;
        String phsChangeFields=Phoenix_Util.phsChangeFields;
        String phsChangeLineFields=Phoenix_Util.phsChangeLineFields;
        String newProductWACPricingFields=Phoenix_Util.newProductWACPricingFields;
        String newProductWACPricingLinesFields=Phoenix_Util.newProductWACPricingLinesFields;
        String bidLinePriceHistFields=Phoenix_Util.bidLinePriceHistFields;
        String bidActionItemsFields=Phoenix_Util.bidActionItemsFields;
        String customerResponseItemFields=Phoenix_Util.customerResponseItemFields;
        String customerResponseFields=Phoenix_Util.customerResponseFields;
        String sapNPRStagingFields=Phoenix_Util.sapNPRStagingFields;
        String nprVolumeFields=Phoenix_Util.nprVolumeFields;
        String userApprovalMatrixFields=Phoenix_Util.userApprovalMatrixFields;
        String RCAIPAFields=Phoenix_Util.RCAIPAFields;
        String ndcChangeProductFields=Phoenix_Util.ndcChangeProductFields;
        String bidLineItemExtnFields=Phoenix_Util.bidLineItemExtnFields;
        String awardedQuantityFields=Phoenix_Util.awardedQuantityFields;
        String futureNPRDataFields=Phoenix_Util.futureNPRDataFields;
        String nprSnapShotFields=Phoenix_Util.nprSnapShotFields;
        DateTime getNowEST=Phoenix_Util.getNowEST();
        DateTime getTodayEST=Phoenix_Util.getTodayEST();
        Phoenix_Util.convertTime(today,targetTimeZone,SrcTimeZone);
    }
@isTest
    static void testSendBatchJobCompletionEmail() {
        Profile profile = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        User testUser = new User(
            ProfileId = profile.Id,
            Username = 'testuser@example.com',
            Email = 'testuser@example.com',
            Alias = 'TUser',
            CommunityNickname = 'testuser123',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Test',
            FirstName = 'User',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            TimeZoneSidKey = 'America/New_York'
        );
        insert testUser;

        // Set the context user for the test
        System.runAs(testUser) {
            
            Phoenix_Util.sendBatchJobCompletionEmail('Test Batch', 'Test Comments');
          
        }
    }
   
    
}