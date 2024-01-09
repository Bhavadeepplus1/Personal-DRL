//added by Shashirekha
@isTest
public class marketingHeadSRVPReviewNotification_Test {
    static testmethod void reviewNotifications_TestMethod() {
        List<Phoenix_Bid_Line_Item__c> pbLineitems = new List<Phoenix_Bid_Line_Item__c>();
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
        pbLineitems.add(bl);
        
        Phoenix_Bid_Line_Item__c bl1 = new Phoenix_Bid_Line_Item__c();
        bl1.Phoenix_Bid__c = pb.Id;
        bl1.Phoenix_Final_Status__c = 'Approved';
        bl1.Phoenix_Current_Direct_Price__c = 10;
        bl1.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        bl1.Phoenix_Product__c = p3.Id;
        bl1.Phoenix_SCM_Approval_Y_N__c = 'Y- Only Current Monthly Demand Approved';
        bl1.Phoenix_Marketing_Final_Approval__c = true;
        insert bl1;
        pbLineitems.add(bl1);
        
        Phoenix_Bid_Line_Item__c bl2 = new Phoenix_Bid_Line_Item__c();
        bl2.Phoenix_Bid__c = pb.Id;
        bl2.Phoenix_Final_Status__c = 'Approved';
        bl2.Phoenix_Current_Direct_Price__c = 10;
        bl2.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        bl2.Phoenix_Product__c = p3.Id;
        bl2.Phoenix_SCM_Approval_Y_N__c = 'N- Not Approved';
        bl2.Phoenix_Marketing_Final_Approval__c = true;
        insert bl2;
        pbLineitems.add(bl2);
        
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
        
        List<Phoenix_Approval_Grid__c> pagList=new List<Phoenix_Approval_Grid__c>();
        Phoenix_Approval_Grid__c pag=new Phoenix_Approval_Grid__c();
		pag.Phoenix_Product_Family__c='Product Family';
		pag.Phoenix_Is_partner_product__c=true;
		pag.Phoenix_Sr_Director_VP_Finance_Comments__c='Noted';
		//pag.Phoenix_Is_Mkg_Head_Noti_Required__c=true;
		pag.Phoenix_Is_SVP_Notification_Required__c=true;
		pag.Phoenix_Sr_Director_VP__c='Approved';
		pag.Phoenix_Is_Mkg_Head_Noti_Required__c=true;
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
		//pag.Phoenix_Annualized_TP__c=4;
       // pag.Phoenix_Is_New_Low__c=true;
        pag.Phoenix_Bid__c=pb.Id;
		insert pag;
        pagList.add(pag);
        
        Phoenix_User_Approval_Matrix__c pua=new Phoenix_User_Approval_Matrix__c();
		pua.Phoenix_Approval_Group_Behavior__c='Team';
		pua.Phoenix_Approver__c=UserInfo.getUserId();
		pua.Phoenix_Approver_Group_Name__c='Sales';
		pua.Phoenix_Is_Approval_Process_User__c=true;
        //pua.RecordType.DeveloperName='Approval_User_Group';
		//pua.User_Group__c=
        insert pua;
        
		marketingHeadSRVPReviewNotificationS.reviewNotificationsMarketingHead(pb.Id,psList);
        //marketingHeadSRVPReviewNotificationS.reviewNotificationsSrVpFinance(pb.Id,psList);
	}
    
   static testmethod void reviewNotifications_TestMethod2() {
        List<Phoenix_Bid_Line_Item__c> pbLineitems = new List<Phoenix_Bid_Line_Item__c>();
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
        pb.Phoenix_Customer_Type__c = 'Mass Product Removals';
        pb.Phoenix_Bid_Deadline_Date__c = System.today();
        pb.Phoenix_Bid_Type__c = 'RFP Bids';
        pb.Phoenix_Approval_Status__c = 'Draft';
        pb.Phoenix_Bid_Type__c='Pharmabid';
        pb.Phoenix_Internal_Target_Date__c=System.Today();
        insert pb;
        System.debug([select id,Owner.Name,Phoenix_Approval_Status__c,CreatedDate,Name,Phoenix_Bid_Type__c,Phoenix_Bid_Name__c,Phoenix_Comments__c,Phoenix_Internal_Target_Date__c from Phoenix_Bid__c where id=:pb.Id]);
			// System.debug([SELECT Id, Name FROM Phoenix_Bid_Process_Steps__c WHERE Phoenix_Bid__c = :pb.Id]);
        
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
        pbLineitems.add(bl);
        
        Phoenix_Bid_Line_Item__c bl1 = new Phoenix_Bid_Line_Item__c();
        bl1.Phoenix_Bid__c = pb.Id;
        bl1.Phoenix_Final_Status__c = 'Approved';
        bl1.Phoenix_Current_Direct_Price__c = 10;
        bl1.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        bl1.Phoenix_Product__c = p3.Id;
        bl1.Phoenix_SCM_Approval_Y_N__c = 'Y- Only Current Monthly Demand Approved';
        bl1.Phoenix_Marketing_Final_Approval__c = true;
        insert bl1;
        pbLineitems.add(bl1);
        
        Phoenix_Bid_Line_Item__c bl2 = new Phoenix_Bid_Line_Item__c();
        bl2.Phoenix_Bid__c = pb.Id;
        bl2.Phoenix_Final_Status__c = 'Approved';
        bl2.Phoenix_Current_Direct_Price__c = 10;
        bl2.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        bl2.Phoenix_Product__c = p3.Id;
        bl2.Phoenix_SCM_Approval_Y_N__c = 'N- Not Approved';
        bl2.Phoenix_Marketing_Final_Approval__c = true;
        insert bl2;
        
        pbLineitems.add(bl2);
        Phoenix_Approval_Matrix__c pam=new Phoenix_Approval_Matrix__c();
        pam.Name='Marketing Head Approval';
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
       	ps.Name='Contract Team\'s Action';
        insert ps;
        psList.add(ps);
       
        Phoenix_Bid_Process_Steps__c ps1 = new Phoenix_Bid_Process_Steps__c();
        ps1.Phoenix_Approver__c = UserInfo.getUserId();
        ps1.Phoenix_Approver_Team__c='Sales';
        ps1.Phoenix_Is_Criteria_Step__c = false;
        ps1.Phoenix_Status__c = 'In Process';
        ps1.Phoenix_Process_Step__c=pap.Id;
        ps1.Phoenix_Bid__c = pb.Id;
       	ps1.Name='Finance Approval';
        insert ps1;
        psList.add(ps1);
        
       List<Phoenix_Approval_Grid__c> pagList=new List<Phoenix_Approval_Grid__c>();
        Phoenix_Approval_Grid__c pag=new Phoenix_Approval_Grid__c();
		pag.Phoenix_Product_Family__c='Product Family';
		pag.Phoenix_Is_partner_product__c=true;
		pag.Phoenix_Sr_Director_VP_Finance_Comments__c='Noted';
		pag.Phoenix_Is_Mkg_Head_Noti_Required__c=true;
		pag.Phoenix_Is_SVP_Notification_Required__c=true;
		pag.Phoenix_Sr_Director_VP__c='Approved';
		//pag.Phoenix_Is_Mkg_Head_Noti_Required__c=true;
		pag.Phoenix_Is_SVP_Notification_Required__c=true;
		pag.Phoenix_Sr_Director_VP__c='Approved';
		//pag.Phoenix_Comments__c='Noted';
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
		pag.Phoenix_Annualized_TP__c=4;
        pag.Phoenix_Is_New_Low__c=true;
        pag.Phoenix_Bid__c=pb.Id;
       	pag.Phoenix_Annualized_GM__c=4;
		insert pag;
        pagList.add(pag);
        
        Phoenix_User_Approval_Matrix__c pua=new Phoenix_User_Approval_Matrix__c();
		pua.Phoenix_Approval_Group_Behavior__c='Team';
		pua.Phoenix_Approver__c=UserInfo.getUserId();
		pua.Phoenix_Approver_Group_Name__c='Sales';
		pua.Phoenix_Is_Approval_Process_User__c=true;
        //pua.RecordType.DeveloperName='Approval_User_Group';
		//pua.User_Group__c=
        insert pua;
       
       
        
		marketingHeadSRVPReviewNotificationS.reviewNotificationsMarketingHead(pb.Id,psList);
       	marketingHeadSRVPReviewNotificationS.reviewNotificationsSrVpFinance(pb.Id,psList);
        //emailsforProductDisc_MasPrdctRemoval.sendEmailToAllApproversforProductDiscontinuationToMktLead(pb.Id,pbLineitems);
	}
	static testmethod void reviewNotifications_TestMethod3() {
        List<Phoenix_Bid_Line_Item__c> pbLineitems = new List<Phoenix_Bid_Line_Item__c>();
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
        pb.Phoenix_Customer_Type__c = 'Mass Product Removals';
        pb.Phoenix_Bid_Deadline_Date__c = System.today();
        pb.Phoenix_Bid_Type__c = 'RFP Bids';
        pb.Phoenix_Approval_Status__c = 'Draft';
        pb.Phoenix_Bid_Type__c='Pharmabid';
        pb.Phoenix_Internal_Target_Date__c=System.Today();
        insert pb;
        System.debug([select id,Owner.Name,Phoenix_Approval_Status__c,CreatedDate,Name,Phoenix_Bid_Type__c,Phoenix_Bid_Name__c,Phoenix_Comments__c,Phoenix_Internal_Target_Date__c from Phoenix_Bid__c where id=:pb.Id]);
			// System.debug([SELECT Id, Name FROM Phoenix_Bid_Process_Steps__c WHERE Phoenix_Bid__c = :pb.Id]);
        
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
        pbLineitems.add(bl);
        
        Phoenix_Bid_Line_Item__c bl1 = new Phoenix_Bid_Line_Item__c();
        bl1.Phoenix_Bid__c = pb.Id;
        bl1.Phoenix_Final_Status__c = 'Approved';
        bl1.Phoenix_Current_Direct_Price__c = 10;
        bl1.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        bl1.Phoenix_Product__c = p3.Id;
        bl1.Phoenix_SCM_Approval_Y_N__c = 'Y- Only Current Monthly Demand Approved';
        bl1.Phoenix_Marketing_Final_Approval__c = true;
        insert bl1;
        pbLineitems.add(bl1);
        
        Phoenix_Bid_Line_Item__c bl2 = new Phoenix_Bid_Line_Item__c();
        bl2.Phoenix_Bid__c = pb.Id;
        bl2.Phoenix_Final_Status__c = 'Approved';
        bl2.Phoenix_Current_Direct_Price__c = 10;
        bl2.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        bl2.Phoenix_Product__c = p3.Id;
        bl2.Phoenix_SCM_Approval_Y_N__c = 'N- Not Approved';
        bl2.Phoenix_Marketing_Final_Approval__c = true;
        insert bl2;
        
        pbLineitems.add(bl2);
        Phoenix_Approval_Matrix__c pam=new Phoenix_Approval_Matrix__c();
        pam.Name='Marketing Head Approval';
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
       
        Phoenix_Bid_Process_Steps__c ps1 = new Phoenix_Bid_Process_Steps__c();
        ps1.Phoenix_Approver__c = UserInfo.getUserId();
        ps1.Phoenix_Approver_Team__c='Sales';
        ps1.Phoenix_Is_Criteria_Step__c = false;
        ps1.Phoenix_Status__c = 'In Process';
        ps1.Phoenix_Process_Step__c=pap.Id;
        ps1.Phoenix_Bid__c = pb.Id;
        insert ps1;
        psList.add(ps1);
        
       List<Phoenix_Approval_Grid__c> pagList=new List<Phoenix_Approval_Grid__c>();
        Phoenix_Approval_Grid__c pag=new Phoenix_Approval_Grid__c();
		pag.Phoenix_Product_Family__c='Product Family';
		pag.Phoenix_Is_partner_product__c=false;
		pag.Phoenix_Sr_Director_VP_Finance_Comments__c='Noted';
		pag.Phoenix_Is_Mkg_Head_Noti_Required__c=true;
		pag.Phoenix_Is_SVP_Notification_Required__c=true;
		pag.Phoenix_Sr_Director_VP__c='Approved';
		pag.Phoenix_Is_Mkg_Head_Noti_Required__c=true;
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
		//pag.Phoenix_Annualized_TP__c=4;
        pag.Phoenix_Is_New_Low__c=false;
        pag.Phoenix_Bid__c=pb.Id;
		insert pag;
        pagList.add(pag);
        
        Phoenix_User_Approval_Matrix__c pua=new Phoenix_User_Approval_Matrix__c();
		pua.Phoenix_Approval_Group_Behavior__c='Team';
		pua.Phoenix_Approver__c=UserInfo.getUserId();
		pua.Phoenix_Approver_Group_Name__c='Sales';
		pua.Phoenix_Is_Approval_Process_User__c=true;
        //pua.RecordType.DeveloperName='Approval_User_Group';
		//pua.User_Group__c=
        insert pua;
       
       
        
		marketingHeadSRVPReviewNotificationS.reviewNotificationsMarketingHead(pb.Id,psList);
       	marketingHeadSRVPReviewNotificationS.reviewNotificationsSrVpFinance(pb.Id,psList);
        //emailsforProductDisc_MasPrdctRemoval.sendEmailToAllApproversforProductDiscontinuationToMktLead(pb.Id,pbLineitems);
	}
    static testmethod void reviewNotifications_TestMethod4() {
        List<Phoenix_Bid_Line_Item__c> pbLineitems = new List<Phoenix_Bid_Line_Item__c>();
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
        pb.Phoenix_Customer_Type__c = 'Mass Product Removals';
        pb.Phoenix_Bid_Deadline_Date__c = System.today();
        pb.Phoenix_Bid_Type__c = 'RFP Bids';
        pb.Phoenix_Approval_Status__c = 'Draft';
        pb.Phoenix_Bid_Type__c='Pharmabid';
        pb.Phoenix_Internal_Target_Date__c=System.Today();
        insert pb;
        System.debug([select id,Owner.Name,Phoenix_Approval_Status__c,CreatedDate,Name,Phoenix_Bid_Type__c,Phoenix_Bid_Name__c,Phoenix_Comments__c,Phoenix_Internal_Target_Date__c from Phoenix_Bid__c where id=:pb.Id]);
			// System.debug([SELECT Id, Name FROM Phoenix_Bid_Process_Steps__c WHERE Phoenix_Bid__c = :pb.Id]);
        
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
        pbLineitems.add(bl);
        
        Phoenix_Bid_Line_Item__c bl1 = new Phoenix_Bid_Line_Item__c();
        bl1.Phoenix_Bid__c = pb.Id;
        bl1.Phoenix_Final_Status__c = 'Approved';
        bl1.Phoenix_Current_Direct_Price__c = 10;
        bl1.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        bl1.Phoenix_Product__c = p3.Id;
        bl1.Phoenix_SCM_Approval_Y_N__c = 'Y- Only Current Monthly Demand Approved';
        bl1.Phoenix_Marketing_Final_Approval__c = true;
        insert bl1;
        pbLineitems.add(bl1);
        
        Phoenix_Bid_Line_Item__c bl2 = new Phoenix_Bid_Line_Item__c();
        bl2.Phoenix_Bid__c = pb.Id;
        bl2.Phoenix_Final_Status__c = 'Approved';
        bl2.Phoenix_Current_Direct_Price__c = 10;
        bl2.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        bl2.Phoenix_Product__c = p3.Id;
        bl2.Phoenix_SCM_Approval_Y_N__c = 'N- Not Approved';
        bl2.Phoenix_Marketing_Final_Approval__c = true;
        insert bl2;
        
        pbLineitems.add(bl2);
        Phoenix_Approval_Matrix__c pam=new Phoenix_Approval_Matrix__c();
        pam.Name='Marketing Head Approval';
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
        ps.name='Contract Team\'s Action';
        insert ps;
        psList.add(ps);
       
        Phoenix_Bid_Process_Steps__c ps1 = new Phoenix_Bid_Process_Steps__c();
        ps1.Phoenix_Approver__c = UserInfo.getUserId();
        ps1.Phoenix_Approver_Team__c='Sales';
        ps1.Phoenix_Is_Criteria_Step__c = false;
        ps1.Phoenix_Status__c = 'In Process';
        ps1.Phoenix_Process_Step__c=pap.Id;
        ps1.Phoenix_Bid__c = pb.Id;
        ps1.Name='Finance Approval';
        insert ps1;
        psList.add(ps1);
        
       List<Phoenix_Approval_Grid__c> pagList=new List<Phoenix_Approval_Grid__c>();
        Phoenix_Approval_Grid__c pag=new Phoenix_Approval_Grid__c();
		pag.Phoenix_Product_Family__c='Product Family';
		pag.Phoenix_Is_partner_product__c=false;
		pag.Phoenix_Sr_Director_VP_Finance_Comments__c='Noted';
		pag.Phoenix_Is_Mkg_Head_Noti_Required__c=true;
		pag.Phoenix_Is_SVP_Notification_Required__c=true;
		pag.Phoenix_Sr_Director_VP__c='Approved';
		//pag.Phoenix_Is_Mkg_Head_Noti_Required__c=true;
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
		//pag.Phoenix_Annualized_TP__c=3;
		pag.Phoenix_Annualized_TP_Impact_Limit__c='Noted';
		//pag.Phoenix_Annualized_TP__c=4;
        pag.Phoenix_Is_New_Low__c=false;
        pag.Phoenix_Bid__c=pb.Id;
		insert pag;
        pagList.add(pag);
        
        Phoenix_User_Approval_Matrix__c pua=new Phoenix_User_Approval_Matrix__c();
		pua.Phoenix_Approval_Group_Behavior__c='Team';
		pua.Phoenix_Approver__c=UserInfo.getUserId();
		pua.Phoenix_Approver_Group_Name__c='Sales';
		pua.Phoenix_Is_Approval_Process_User__c=true;
        //pua.RecordType.DeveloperName='Approval_User_Group';
		//pua.User_Group__c=
        insert pua;
        
		marketingHeadSRVPReviewNotificationS.reviewNotificationsMarketingHead(pb.Id,psList);
       	marketingHeadSRVPReviewNotificationS.reviewNotificationsSrVpFinance(pb.Id,psList);
        //emailsforProductDisc_MasPrdctRemoval.sendEmailToAllApproversforProductDiscontinuationToMktLead(pb.Id,pbLineitems);
	}
     static testmethod void reviewNotifications_TestMethod5() {
        List<Phoenix_Bid_Line_Item__c> pbLineitems = new List<Phoenix_Bid_Line_Item__c>();
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
        pb.Phoenix_Customer_Type__c = 'Mass Product Removals';
        pb.Phoenix_Bid_Deadline_Date__c = System.today();
        pb.Phoenix_Bid_Type__c = 'RFP Bids';
        pb.Phoenix_Approval_Status__c = 'Draft';
        pb.Phoenix_Bid_Type__c='Pharmabid';
        pb.Phoenix_Internal_Target_Date__c=System.Today();
        insert pb;
        System.debug([select id,Owner.Name,Phoenix_Approval_Status__c,CreatedDate,Name,Phoenix_Bid_Type__c,Phoenix_Bid_Name__c,Phoenix_Comments__c,Phoenix_Internal_Target_Date__c from Phoenix_Bid__c where id=:pb.Id]);
			// System.debug([SELECT Id, Name FROM Phoenix_Bid_Process_Steps__c WHERE Phoenix_Bid__c = :pb.Id]);
        
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
        pbLineitems.add(bl);
        
        Phoenix_Bid_Line_Item__c bl1 = new Phoenix_Bid_Line_Item__c();
        bl1.Phoenix_Bid__c = pb.Id;
        bl1.Phoenix_Final_Status__c = 'Approved';
        bl1.Phoenix_Current_Direct_Price__c = 10;
        bl1.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        bl1.Phoenix_Product__c = p3.Id;
        bl1.Phoenix_SCM_Approval_Y_N__c = 'Y- Only Current Monthly Demand Approved';
        bl1.Phoenix_Marketing_Final_Approval__c = true;
        insert bl1;
        pbLineitems.add(bl1);
        
        Phoenix_Bid_Line_Item__c bl2 = new Phoenix_Bid_Line_Item__c();
        bl2.Phoenix_Bid__c = pb.Id;
        bl2.Phoenix_Final_Status__c = 'Approved';
        bl2.Phoenix_Current_Direct_Price__c = 10;
        bl2.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        bl2.Phoenix_Product__c = p3.Id;
        bl2.Phoenix_SCM_Approval_Y_N__c = 'N- Not Approved';
        bl2.Phoenix_Marketing_Final_Approval__c = true;
        insert bl2;
        
        pbLineitems.add(bl2);
        Phoenix_Approval_Matrix__c pam=new Phoenix_Approval_Matrix__c();
        pam.Name='Marketing Head Approval';
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
        ps.name='Contract Team\'s Action';
        insert ps;
        psList.add(ps);
       
        Phoenix_Bid_Process_Steps__c ps1 = new Phoenix_Bid_Process_Steps__c();
        ps1.Phoenix_Approver__c = UserInfo.getUserId();
        ps1.Phoenix_Approver_Team__c='Sales';
        ps1.Phoenix_Is_Criteria_Step__c = false;
        ps1.Phoenix_Status__c = 'In Process';
        ps1.Phoenix_Process_Step__c=pap.Id;
        ps1.Phoenix_Bid__c = pb.Id;
        ps1.Name='Finance Approval';
        insert ps1;
        psList.add(ps1);
        
       List<Phoenix_Approval_Grid__c> pagList=new List<Phoenix_Approval_Grid__c>();
        Phoenix_Approval_Grid__c pag=new Phoenix_Approval_Grid__c();
		pag.Phoenix_Product_Family__c='Product Family';
		pag.Phoenix_Is_partner_product__c=false;
		pag.Phoenix_Sr_Director_VP_Finance_Comments__c='Noted';
		pag.Phoenix_Is_Mkg_Head_Noti_Required__c=true;
		pag.Phoenix_Is_SVP_Notification_Required__c=true;
		pag.Phoenix_Sr_Director_VP__c='Approved';
		//pag.Phoenix_Is_Mkg_Head_Noti_Required__c=true;
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
		//pag.Phoenix_Annualized_TP__c=4;
        //pag.Phoenix_Is_New_Low__c=true;
        pag.Phoenix_Bid__c=pb.Id;
		insert pag;
        pagList.add(pag);
        
        Phoenix_User_Approval_Matrix__c pua=new Phoenix_User_Approval_Matrix__c();
		pua.Phoenix_Approval_Group_Behavior__c='Team';
		pua.Phoenix_Approver__c=UserInfo.getUserId();
		pua.Phoenix_Approver_Group_Name__c='Sales';
		pua.Phoenix_Is_Approval_Process_User__c=true;
        //pua.RecordType.DeveloperName='Approval_User_Group';
		//pua.User_Group__c=
        insert pua;
        
		marketingHeadSRVPReviewNotificationS.reviewNotificationsMarketingHead(pb.Id,psList);
       	marketingHeadSRVPReviewNotificationS.reviewNotificationsSrVpFinance(pb.Id,psList);
        //emailsforProductDisc_MasPrdctRemoval.sendEmailToAllApproversforProductDiscontinuationToMktLead(pb.Id,pbLineitems);
	}
    static testmethod void reviewNotifications_TestMethod6() {
        List<Phoenix_Bid_Line_Item__c> pbLineitems = new List<Phoenix_Bid_Line_Item__c>();
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
        pb.Phoenix_Customer_Type__c = 'Mass Product Removals';
        pb.Phoenix_Bid_Deadline_Date__c = System.today();
        pb.Phoenix_Bid_Type__c = 'RFP Bids';
        pb.Phoenix_Approval_Status__c = 'Draft';
        pb.Phoenix_Bid_Type__c='Pharmabid';
        pb.Phoenix_Internal_Target_Date__c=System.Today();
        insert pb;
        System.debug([select id,Owner.Name,Phoenix_Approval_Status__c,CreatedDate,Name,Phoenix_Bid_Type__c,Phoenix_Bid_Name__c,Phoenix_Comments__c,Phoenix_Internal_Target_Date__c from Phoenix_Bid__c where id=:pb.Id]);
			// System.debug([SELECT Id, Name FROM Phoenix_Bid_Process_Steps__c WHERE Phoenix_Bid__c = :pb.Id]);
        
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
        pbLineitems.add(bl);
        
        Phoenix_Bid_Line_Item__c bl1 = new Phoenix_Bid_Line_Item__c();
        bl1.Phoenix_Bid__c = pb.Id;
        bl1.Phoenix_Final_Status__c = 'Approved';
        bl1.Phoenix_Current_Direct_Price__c = 10;
        bl1.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        bl1.Phoenix_Product__c = p3.Id;
        bl1.Phoenix_SCM_Approval_Y_N__c = 'Y- Only Current Monthly Demand Approved';
        bl1.Phoenix_Marketing_Final_Approval__c = true;
        insert bl1;
        pbLineitems.add(bl1);
        
        Phoenix_Bid_Line_Item__c bl2 = new Phoenix_Bid_Line_Item__c();
        bl2.Phoenix_Bid__c = pb.Id;
        bl2.Phoenix_Final_Status__c = 'Approved';
        bl2.Phoenix_Current_Direct_Price__c = 10;
        bl2.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        bl2.Phoenix_Product__c = p3.Id;
        bl2.Phoenix_SCM_Approval_Y_N__c = 'N- Not Approved';
        bl2.Phoenix_Marketing_Final_Approval__c = true;
        insert bl2;
        
        pbLineitems.add(bl2);
        Phoenix_Approval_Matrix__c pam=new Phoenix_Approval_Matrix__c();
        pam.Name='Marketing Head Approval';
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
       	ps.Name='Contract Team\'s Action';
        insert ps;
        psList.add(ps);
       
        Phoenix_Bid_Process_Steps__c ps1 = new Phoenix_Bid_Process_Steps__c();
        ps1.Phoenix_Approver__c = UserInfo.getUserId();
        ps1.Phoenix_Approver_Team__c='Sales';
        ps1.Phoenix_Is_Criteria_Step__c = false;
        ps1.Phoenix_Status__c = 'In Process';
        ps1.Phoenix_Process_Step__c=pap.Id;
        ps1.Phoenix_Bid__c = pb.Id;
       	ps1.Name='Finance Approval';
        insert ps1;
        psList.add(ps1);
        
       List<Phoenix_Approval_Grid__c> pagList=new List<Phoenix_Approval_Grid__c>();
        Phoenix_Approval_Grid__c pag=new Phoenix_Approval_Grid__c();
		pag.Phoenix_Product_Family__c='Product Family';
		pag.Phoenix_Is_partner_product__c=true;
		pag.Phoenix_Sr_Director_VP_Finance_Comments__c='Noted';
		pag.Phoenix_Is_Mkg_Head_Noti_Required__c=true;
		pag.Phoenix_Is_SVP_Notification_Required__c=true;
		pag.Phoenix_Sr_Director_VP__c='Approved';
		//pag.Phoenix_Is_Mkg_Head_Noti_Required__c=true;
		pag.Phoenix_Is_SVP_Notification_Required__c=true;
		pag.Phoenix_Sr_Director_VP__c='Approved';
		//pag.Phoenix_Comments__c='Noted';
		pag.Phoenix_Approval__c='Approved';
		//pag.Phoenix_Business_Head_Comments__c='Noted';
		//pag.Phoenix_Marketing_Lead_OTC__c='Approved';
		//pag.Phoenix_Marketing_Lead_SRx__c='Approved';
		pag.Phoenix_GM_Limit__c='Noted';
		//pag.Phoenix_Marketing_Lead_Rx__c='Approved';
		pag.Phoenix_GM__c=2;
		pag.Phoenix_Revenue_Limit__c='Noted';
		pag.Phoenix_Revenue__c=2;
		//pag.Phoenix_Annualized_GM_Impact_Limit__c='Noted';
		pag.Phoenix_Annualized_TP_Impact__c=3;
        pag.Phoenix_Annualized_GM_Impact__c=4;
		pag.Phoenix_Annualized_TP__c=3;
		pag.Phoenix_Annualized_TP_Impact_Limit__c='Noted';
		pag.Phoenix_Annualized_TP__c=4;
        pag.Phoenix_Is_New_Low__c=true;
        pag.Phoenix_Bid__c=pb.Id;
		insert pag;
        pagList.add(pag);
        
        Phoenix_User_Approval_Matrix__c pua=new Phoenix_User_Approval_Matrix__c();
		pua.Phoenix_Approval_Group_Behavior__c='Team';
		pua.Phoenix_Approver__c=UserInfo.getUserId();
		pua.Phoenix_Approver_Group_Name__c='Sales';
		pua.Phoenix_Is_Approval_Process_User__c=true;
        //pua.RecordType.DeveloperName='Approval_User_Group';
		//pua.User_Group__c=
        insert pua;
        
		marketingHeadSRVPReviewNotificationS.reviewNotificationsMarketingHead(pb.Id,psList);
       	marketingHeadSRVPReviewNotificationS.reviewNotificationsSrVpFinance(pb.Id,psList);
        //emailsforProductDisc_MasPrdctRemoval.sendEmailToAllApproversforProductDiscontinuationToMktLead(pb.Id,pbLineitems);
	}
    static testmethod void reviewNotifications_TestMethod7() {
        List<Phoenix_Bid_Line_Item__c> pbLineitems = new List<Phoenix_Bid_Line_Item__c>();
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
        pb.Phoenix_Customer_Type__c = 'Mass Product Removals';
        pb.Phoenix_Bid_Deadline_Date__c = System.today();
        pb.Phoenix_Bid_Type__c = 'RFP Bids';
        pb.Phoenix_Approval_Status__c = 'Draft';
        pb.Phoenix_Bid_Type__c='Price Change';
        pb.Phoenix_Internal_Target_Date__c=System.Today();
        insert pb;
        System.debug([select id,Owner.Name,Phoenix_Approval_Status__c,CreatedDate,Name,Phoenix_Bid_Type__c,Phoenix_Bid_Name__c,Phoenix_Comments__c,Phoenix_Internal_Target_Date__c from Phoenix_Bid__c where id=:pb.Id]);
			// System.debug([SELECT Id, Name FROM Phoenix_Bid_Process_Steps__c WHERE Phoenix_Bid__c = :pb.Id]);
        
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
        pbLineitems.add(bl);
        
        Phoenix_Bid_Line_Item__c bl1 = new Phoenix_Bid_Line_Item__c();
        bl1.Phoenix_Bid__c = pb.Id;
        bl1.Phoenix_Final_Status__c = 'Approved';
        bl1.Phoenix_Current_Direct_Price__c = 10;
        bl1.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        bl1.Phoenix_Product__c = p3.Id;
        bl1.Phoenix_SCM_Approval_Y_N__c = 'Y- Only Current Monthly Demand Approved';
        bl1.Phoenix_Marketing_Final_Approval__c = true;
        insert bl1;
        pbLineitems.add(bl1);
        
        Phoenix_Bid_Line_Item__c bl2 = new Phoenix_Bid_Line_Item__c();
        bl2.Phoenix_Bid__c = pb.Id;
        bl2.Phoenix_Final_Status__c = 'Approved';
        bl2.Phoenix_Current_Direct_Price__c = 10;
        bl2.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        bl2.Phoenix_Product__c = p3.Id;
        bl2.Phoenix_SCM_Approval_Y_N__c = 'N- Not Approved';
        bl2.Phoenix_Marketing_Final_Approval__c = true;
        insert bl2;
        
        pbLineitems.add(bl2);
        Phoenix_Approval_Matrix__c pam=new Phoenix_Approval_Matrix__c();
        pam.Name='Marketing Head Approval';
        insert pam;
        
        Phoenix_Approval_Process_Step__c pap=new Phoenix_Approval_Process_Step__c();
        pap.Phoenix_Approver__c=UserInfo.getUserId();
        pap.Name='Finance Approval';
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
       	ps.Name='Marketing Head';
        insert ps;
        psList.add(ps);
       
        Phoenix_Bid_Process_Steps__c ps1 = new Phoenix_Bid_Process_Steps__c();
        ps1.Phoenix_Approver__c = UserInfo.getUserId();
        ps1.Phoenix_Approver_Team__c='Sales';
        ps1.Phoenix_Is_Criteria_Step__c = false;
        ps1.Phoenix_Status__c = 'In Process';
        ps1.Phoenix_Process_Step__c=pap.Id;
        ps1.Phoenix_Bid__c = pb.Id;
       	ps1.Name='Finance Approval';
        insert ps1;
        psList.add(ps1);
        
       List<Phoenix_Approval_Grid__c> pagList=new List<Phoenix_Approval_Grid__c>();
        Phoenix_Approval_Grid__c pag=new Phoenix_Approval_Grid__c();
		pag.Phoenix_Product_Family__c='Product Family';
		pag.Phoenix_Is_partner_product__c=true;
		pag.Phoenix_Sr_Director_VP_Finance_Comments__c='Noted';
		pag.Phoenix_Is_Mkg_Head_Noti_Required__c=true;
		pag.Phoenix_Is_SVP_Notification_Required__c=true;
		pag.Phoenix_Sr_Director_VP__c='Approved';
		//pag.Phoenix_Is_Mkg_Head_Noti_Required__c=true;
		pag.Phoenix_Is_SVP_Notification_Required__c=true;
		pag.Phoenix_Sr_Director_VP__c='Approved';
		//pag.Phoenix_Comments__c='Noted';
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
		pag.Phoenix_Annualized_TP__c=4;
        pag.Phoenix_Is_New_Low__c=true;
        pag.Phoenix_Bid__c=pb.Id;
       	pag.Phoenix_Annualized_GM__c=4;
		insert pag;
        pagList.add(pag);
        
        Phoenix_User_Approval_Matrix__c pua=new Phoenix_User_Approval_Matrix__c();
		pua.Phoenix_Approval_Group_Behavior__c='Team';
		pua.Phoenix_Approver__c=UserInfo.getUserId();
		pua.Phoenix_Approver_Group_Name__c='Sales';
		pua.Phoenix_Is_Approval_Process_User__c=true;
        //pua.RecordType.DeveloperName='Approval_User_Group';
		//pua.User_Group__c=
        insert pua;
        
		marketingHeadSRVPReviewNotificationS.reviewNotificationsMarketingHead(pb.Id,psList);
       	marketingHeadSRVPReviewNotificationS.reviewNotificationsSrVpFinance(pb.Id,psList);
        //emailsforProductDisc_MasPrdctRemoval.sendEmailToAllApproversforProductDiscontinuationToMktLead(pb.Id,pbLineitems);
	}
    static testmethod void reviewNotifications_TestMethod8() {
        List<Phoenix_Bid_Line_Item__c> pbLineitems = new List<Phoenix_Bid_Line_Item__c>();
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
        pb.Phoenix_Customer_Type__c = 'Mass Product Removals';
        pb.Phoenix_Bid_Deadline_Date__c = System.today();
        pb.Phoenix_Bid_Type__c = 'RFP Bids';
        pb.Phoenix_Approval_Status__c = 'Draft';
        pb.Phoenix_Bid_Type__c='Price Change';
        pb.Phoenix_Internal_Target_Date__c=System.Today();
        insert pb;
        System.debug([select id,Owner.Name,Phoenix_Approval_Status__c,CreatedDate,Name,Phoenix_Bid_Type__c,Phoenix_Bid_Name__c,Phoenix_Comments__c,Phoenix_Internal_Target_Date__c from Phoenix_Bid__c where id=:pb.Id]);
			// System.debug([SELECT Id, Name FROM Phoenix_Bid_Process_Steps__c WHERE Phoenix_Bid__c = :pb.Id]);
        
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
        pbLineitems.add(bl);
        
        Phoenix_Bid_Line_Item__c bl1 = new Phoenix_Bid_Line_Item__c();
        bl1.Phoenix_Bid__c = pb.Id;
        bl1.Phoenix_Final_Status__c = 'Approved';
        bl1.Phoenix_Current_Direct_Price__c = 10;
        bl1.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        bl1.Phoenix_Product__c = p3.Id;
        bl1.Phoenix_SCM_Approval_Y_N__c = 'Y- Only Current Monthly Demand Approved';
        bl1.Phoenix_Marketing_Final_Approval__c = true;
        insert bl1;
        pbLineitems.add(bl1);
        
        Phoenix_Bid_Line_Item__c bl2 = new Phoenix_Bid_Line_Item__c();
        bl2.Phoenix_Bid__c = pb.Id;
        bl2.Phoenix_Final_Status__c = 'Approved';
        bl2.Phoenix_Current_Direct_Price__c = 10;
        bl2.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        bl2.Phoenix_Product__c = p3.Id;
        bl2.Phoenix_SCM_Approval_Y_N__c = 'N- Not Approved';
        bl2.Phoenix_Marketing_Final_Approval__c = true;
        insert bl2;
        
        pbLineitems.add(bl2);
        Phoenix_Approval_Matrix__c pam=new Phoenix_Approval_Matrix__c();
        pam.Name='Marketing Head Approval';
        insert pam;
        
        Phoenix_Approval_Process_Step__c pap=new Phoenix_Approval_Process_Step__c();
        pap.Phoenix_Approver__c=UserInfo.getUserId();
        pap.Name='Contract Team\'s Action';
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
       	ps.Name='Marketing Head';
        insert ps;
        psList.add(ps);
       
        Phoenix_Bid_Process_Steps__c ps1 = new Phoenix_Bid_Process_Steps__c();
        ps1.Phoenix_Approver__c = UserInfo.getUserId();
        ps1.Phoenix_Approver_Team__c='Sales';
        ps1.Phoenix_Is_Criteria_Step__c = false;
        ps1.Phoenix_Status__c = 'In Process';
        ps1.Phoenix_Process_Step__c=pap.Id;
        ps1.Phoenix_Bid__c = pb.Id;
       	ps1.Name='Finance Approval';
        insert ps1;
        psList.add(ps1);
        
       List<Phoenix_Approval_Grid__c> pagList=new List<Phoenix_Approval_Grid__c>();
        Phoenix_Approval_Grid__c pag=new Phoenix_Approval_Grid__c();
		pag.Phoenix_Product_Family__c='Product Family';
		pag.Phoenix_Is_partner_product__c=true;
		pag.Phoenix_Sr_Director_VP_Finance_Comments__c='Noted';
		pag.Phoenix_Is_Mkg_Head_Noti_Required__c=true;
		pag.Phoenix_Is_SVP_Notification_Required__c=true;
		pag.Phoenix_Sr_Director_VP__c='Approved';
		//pag.Phoenix_Is_Mkg_Head_Noti_Required__c=true;
		pag.Phoenix_Is_SVP_Notification_Required__c=true;
		pag.Phoenix_Sr_Director_VP__c='Approved';
		//pag.Phoenix_Comments__c='Noted';
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
		pag.Phoenix_Annualized_TP__c=4;
        pag.Phoenix_Is_New_Low__c=true;
        pag.Phoenix_Bid__c=pb.Id;
       	pag.Phoenix_Annualized_GM__c=4;
		insert pag;
        pagList.add(pag);
        
        Phoenix_User_Approval_Matrix__c pua=new Phoenix_User_Approval_Matrix__c();
		pua.Phoenix_Approval_Group_Behavior__c='Team';
		pua.Phoenix_Approver__c=UserInfo.getUserId();
		pua.Phoenix_Approver_Group_Name__c='Sales';
		pua.Phoenix_Is_Approval_Process_User__c=true;
        //pua.RecordType.DeveloperName='Approval_User_Group';
		//pua.User_Group__c=
        insert pua;
        
		marketingHeadSRVPReviewNotificationS.reviewNotificationsMarketingHead(pb.Id,psList);
       	marketingHeadSRVPReviewNotificationS.reviewNotificationsSrVpFinance(pb.Id,psList);
        //emailsforProductDisc_MasPrdctRemoval.sendEmailToAllApproversforProductDiscontinuationToMktLead(pb.Id,pbLineitems);
	}
}