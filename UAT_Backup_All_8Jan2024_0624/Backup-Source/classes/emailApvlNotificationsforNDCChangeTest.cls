@isTest
public class emailApvlNotificationsforNDCChangeTest {
    
    @isTest
    public static void test1()
    {
        
        Account acc = new Account();
        acc.Name = 'Walgreen Company';
        insert acc;
        
        Product_Family__c pd = new Product_Family__c();
        pd.Name = 'FLUPHENAZINE';
        pd.Family_Group__c = 'FLUPHENAZINE TABS';
        pd.Vision_Segment__c = 'Rx';
        pd.Vision_IsActive__c = true;
        insert pd;
        
        Product_Family__c pd1 = new Product_Family__c();
        pd1.Name = 'ALLOPURINOL';
        pd1.Family_Group__c = 'Allopurinol';
        pd1.Vision_Segment__c = 'Rx';
        pd1.Vision_IsActive__c = true;
        insert pd1;
        
        list<Phoenix_NDC_Change__c> ndclist = new list<Phoenix_NDC_Change__c>{};
        Phoenix_NDC_Change__c ndc1 = new Phoenix_NDC_Change__c();
        //ndc1.Name='NDC Change-0000001';
        ndc1.Phoenix_Description__c='This is a test description for NDC change Email Template';
        ndc1.Phoenix_Current_Product_Family__c='ATORVASTATIN TABS';
        ndc1.Phoenix_Proposed_Product_Family__c='ATORVASTATIN TABS';
        ndc1.Phoenix_Approval_Status__c ='Draft';
        ndclist.add(ndc1);
        
        Phoenix_NDC_Change__c ndc2 = new Phoenix_NDC_Change__c();
        //ndc2.Name='NDC Change-0000044';
        ndc2.Phoenix_Description__c='This is a test description for NDC change Email Template';
        ndc2.Phoenix_Current_Product_Family__c='ABIRATERONE';
        ndc2.Phoenix_Proposed_Product_Family__c='ABIRATERONE';
        ndc2.Phoenix_Approval_Status__c ='Draft';
        ndclist.add(ndc2);
        
        insert ndclist;
        
        Phoenix_WAC_Change__c wac = new Phoenix_WAC_Change__c();
        //wac.Phoenix_Total_Net_Benefit__c = '5445776';
        wac.Phoenix_Product_Family__c = pd.Id;
        wac.Phoenix_Summary__c = 'Adjusting Fulvestrant Inj 250mg/5mL WAC from $700/pack to $250/pack';
        wac.Phoenix_Medicaid_release__c = 114008;
        wac.Working_capital_benefit__c=2650093;
        wac.Phoenix_PHS_hit__c = -359691;
        wac.Phoenix_WAC_finance_impact__c = 94955;
        wac.Phoenix_Effective_Date__c = date.newInstance(2023,05,16);
        wac.Phoenix_Sales_Increase__c = 184224;
        wac.Phoenix_Approval_Status__c = 'Customer\'s Update Rejected';
        insert wac;
        
        
        
        /*
        Phoenix_NDC_Change__c ndc1 = new Phoenix_NDC_Change__c();
        ndc1.Phoenix_NDC_Change_Name__c = 'Test NDC Email Template';
        insert ndc1;
        */
        
        Phoenix_Bid__c bid1 = new Phoenix_Bid__c();
        bid1.Phoenix_Bid_Name__c = 'Walgreens Sirolimus ROFR April 29';
        insert bid1;
        
        Phoenix_Approval_Matrix__c mat1 = new Phoenix_Approval_Matrix__c();
        mat1.Name = '23.Price Change';
        insert mat1;
        
        Phoenix_Approval_Process_Step__c ap1 = new Phoenix_Approval_Process_Step__c();
        ap1.Name = 'Marketing Lead Approval SRx';
        ap1.Phoenix_Approval_Matrix__c = mat1.Id;
        insert ap1;
        
        
        Phoenix_Approval_Process_Step__c ap2 = new Phoenix_Approval_Process_Step__c();
        ap2.Name = 'Finance Approval';
        ap2.Phoenix_Approval_Matrix__c = mat1.Id;
        insert ap2;
        
        Phoenix_Approval_Process_Step__c ap3 = new Phoenix_Approval_Process_Step__c();
        ap3.Name = 'Supply Chain Approval';
        ap3.Phoenix_Approval_Matrix__c = mat1.Id;
        insert ap3;
        
        Phoenix_Approval_Process_Step__c ap4 = new Phoenix_Approval_Process_Step__c();
        ap4.Name = 'Contract Team\'s Action';
        ap4.Phoenix_Approval_Matrix__c = mat1.Id;
        insert ap4;
        
        
        Phoenix_Contract__c contract1 = new Phoenix_Contract__c();
        contract1.Name = '1000000453-Top Market Direct Contract';
        
        
        Product2 p1 = new Product2();
        p1.Name = 'Albendazole Tablets 200mg, 2';
        insert p1;
        
        Product2 p2 = new Product2();
        p2.Name = 'Ibandronate Sodium Tablets 150mg, 3 (1x3)';
        insert p2;
        
        
        Phoenix_NDC_Change_Line_Item__c change1 = new Phoenix_NDC_Change_Line_Item__c();
        change1.Phoenix_Account__c = acc.Id;
        change1.Phoenix_Contract__c = contract1.Id;
        change1.Phoenix_Current_Product__c = p1.Id;
        change1.Phoenix_NDC_Change__c = ndc1.Id;
        change1.Phoenix_Current_Product_NDC__c = '55111-0575-03';
        change1.Phoenix_Current_Product_Pack_Size__c = 3;
        change1.Phoenix_Proposed_Product__c = p2.Id;
        change1.Phoenix_Proposed_Product_NDC__c = '55111-0575-43';
        change1.Phoenix_Proposed_Product_Pack_Size__c = 3;
        change1.Phoenix_Final_Status__c = 'Approved';
        insert change1;
        
        Phoenix_NDC_Change_Line_Item__c change2 = new Phoenix_NDC_Change_Line_Item__c();
        change2.Phoenix_Account__c = acc.Id;
        change2.Phoenix_Contract__c = contract1.Id;
        change2.Phoenix_Current_Product__c = p1.Id;
        change2.Phoenix_NDC_Change__c = ndc1.Id;
        change2.Phoenix_Current_Product_NDC__c = '55111-0575-03';
        change2.Phoenix_Current_Product_Pack_Size__c = 3;
        change2.Phoenix_Proposed_Product__c = p2.Id;
        change2.Phoenix_Proposed_Product_NDC__c = '55111-0575-43';
        change2.Phoenix_Proposed_Product_Pack_Size__c = 3;
        change2.Phoenix_Final_Status__c = 'Approved';
        insert change2;
        
        
        //list<Phoenix_NDC_Change_Line_Item__c> lineitemlist = [Select Phoenix_Account__r.Name,Phoenix_Contract__r.Name,Phoenix_Current_Product__c, Phoenix_Current_Product__r.Name, Phoenix_Current_Product_NDC__c, Phoenix_Current_Product_Pack_Size__c, Phoenix_Proposed_Product__c, Phoenix_Proposed_Product__r.Name, Phoenix_Proposed_Product_NDC__c, Phoenix_Proposed_Product_Pack_Size__c FROM Phoenix_NDC_Change_Line_Item__c where Phoenix_NDC_Change__c =:ndc1.Id  AND  Phoenix_Final_Status__c != 'Not Approved' limit 10];
        //insert lineitemlist;
        
        list<Phoenix_Bid_Process_Steps__c> bidprocesslist = new list<Phoenix_Bid_Process_Steps__c>{};
        Phoenix_Bid_Process_Steps__c step1 = new Phoenix_Bid_Process_Steps__c();
        step1.Phoenix_Bid__c  = bid1.Id;
        //step1.Phoenix_Step__c = 5;
        step1.Phoenix_Status__c = 'In Process';
        step1.Phoenix_Approver_Team__c = 'Supply Chain';
        step1.Phoenix_Process_Step__c = ap1.Id;
        step1.Phoenix_NDC_Change__c = ndc1.Id;
        step1.Phoenix_Approver__c = UserInfo.getUserId();
        //step1.Phoenix_Is_Notification_Only__c = false;
        step1.Phoenix_Is_Criteria_Step__c = false;
        bidprocesslist.add(step1);
        
        
        Phoenix_Bid_Process_Steps__c step2 = new Phoenix_Bid_Process_Steps__c();
        step2.Phoenix_Bid__c  = bid1.Id;
        //step2.Phoenix_Step__c = 5;
        step2.Phoenix_Status__c = 'Completed';
        step2.Phoenix_Approver_Team__c = 'Supply Chain';
        step2.Phoenix_Process_Step__c = ap2.Id;
        step2.Phoenix_NDC_Change__c = ndc1.Id;
        //step2.Phoenix_Is_Notification_Only__c = false;
        step2.Phoenix_Is_Criteria_Step__c = false;
        bidprocesslist.add(step2);
        
        Phoenix_Bid_Process_Steps__c step3 = new Phoenix_Bid_Process_Steps__c();
        step3.Phoenix_Bid__c  = bid1.Id;
        //step2.Phoenix_Step__c = 5;
        step3.Phoenix_Status__c = 'In Process';
        step3.Phoenix_Approver_Team__c = 'Supply Chain';
        step3.Phoenix_WAC_Change__c = wac.Id;
        step3.Phoenix_Process_Step__c = ap4.Id;
        step3.Phoenix_NDC_Change__c = ndc1.Id;
        //step2.Phoenix_Is_Notification_Only__c = false;
        step3.Phoenix_Is_Criteria_Step__c = false;
        bidprocesslist.add(step3);
        
        Phoenix_Bid_Process_Steps__c step4 = new Phoenix_Bid_Process_Steps__c();
        step4.Phoenix_Bid__c  = bid1.Id;
        //step2.Phoenix_Step__c = 5;
        step4.Phoenix_Status__c = 'In Process';
        step4.Phoenix_Approver_Team__c = 'Supply Chain';
        step4.Phoenix_Process_Step__c = ap2.Id;
        step4.Phoenix_NDC_Change__c = ndc1.Id;
        step4.Phoenix_WAC_Change__c = wac.Id;
        //step2.Phoenix_Is_Notification_Only__c = false;
        step4.Phoenix_Is_Criteria_Step__c = false;
        bidprocesslist.add(step4);
        insert bidprocesslist;
        
        Phoenix_PHS_Price_Change__c price1 = new Phoenix_PHS_Price_Change__c();
        //price1.Name = 'Price Change - 000000';
        price1.Phoenix_PHS_Price_Change_Name__c='Test PHS Price Change Email Temp';
        price1.Phoenix_PHS_Price_Change_Description__c = 'This is a test PHS Price Change Description for Email template';
        price1.Phoenix_Approval_Status__c = 'Vistex Update';
        price1.Phoenix_Record_Type__c = 'Provisional PHS Price Change';
        insert price1;
        
        Phoenix_PHS_Price_Change__c price2 = new Phoenix_PHS_Price_Change__c();
        //price1.Name = 'Price Change - 000000';
        price2.Phoenix_PHS_Price_Change_Name__c='Test GCP Product Family';
        price2.Phoenix_PHS_Price_Change_Description__c = 'This is a test PHS Price Change Description for Email template';
        price2.Phoenix_Approval_Status__c = 'Sr Director or VP Finance';
        price2.Phoenix_Record_Type__c = 'Quarterly PHS Price Change';
        insert price2;
        
        Phoenix_PHS_Price_Change__c price3 = new Phoenix_PHS_Price_Change__c();
        //price1.Name = 'Price Change - 000000';
        price3.Phoenix_PHS_Price_Change_Name__c='Test PHS Price Change Email Temp';
        price3.Phoenix_PHS_Price_Change_Description__c = 'This is a test PHS Price Change Description for Email template';
        price3.Phoenix_Approval_Status__c = 'Vistex Update';
        price3.Phoenix_Record_Type__c = 'Provisional PHS Price Change';
        insert price3;
        
        
        Phoenix_PHS_Price_Change_Line__c changeline = new Phoenix_PHS_Price_Change_Line__c();
        changeline.Phoenix_Product_Name__c = p1.Id;
        changeline.Phoenix_Material_Code__c = '300030382';
        changeline.Phoenix_NDC_11__c='43598035804';
        changeline.Phoenix_Provisional_PHS_Price__c = 82.94;
        changeline.Phoenix_Old_PHS_Price__c = 7.45;
        changeline.Phoenix_New_PHS_Price__c = 38.97;
        changeline.Phoenix_Change_in_Price__c = 423.09;
        changeline.Phoenix_Last_90_days_PHS_Units__c = 1173;
        changeline.Phoenix_Sales_Difference__c = 36972.96;
        changeline.Phoenix_Price_Start_Date__c =date.newinstance(2021, 09, 23);
        changeline.Phoenix_Price_End_Date__c=date.newinstance(2021, 12, 31);
        changeline.Phoenix_Final_Status__c = 'Approved';
        changeline.Phoenix_PHS_Price_Change__c = price2.Id;
		insert changeline;
        
        
        
        Phoenix_User_Approval_Matrix__c user = new Phoenix_User_Approval_Matrix__c(
            Phoenix_Approver_Group_Name__c = 'Finance');
        
        //RecordType rc = new RecordType();
        
        
        Phoenix_User_Approval_Matrix__c record1 = new Phoenix_User_Approval_Matrix__c();
        record1.Name = 'Record 1';
        //record1.RecordType = new RecordType(DeveloperName = 'YourRecordTypeDeveloperName1');
        record1.Phoenix_Approval_Group_Behavior__c = '	Single User';
        record1.Phoenix_Approver_Group_Name__c = 'Finance';
        //record1.Phoenix_Is_Active_User__c = true;
        record1.Phoenix_Is_Approval_Process_User__c = true;
        record1.User_Group__c = user.Id;
        record1.Phoenix_Approver__c=UserInfo.getUserId();
        insert record1;
        
        
        Phoenix_WAC_Change_Line_Item__c wacline = new Phoenix_WAC_Change_Line_Item__c();
        wacline.Phoenix_Matl_No__c = '300024793';
        wacline.Phoenix_NDC11__c = '43598026202';
        wacline.Phoenix_Contr_Number__c = '3000000047';
        wacline.Phoenix_Cust_Name__c = 'McKesson Drug Company';
        wacline.Phoenix_Product__c =p1.Id;
        wacline.Phoenix_Proposed_WAC__c = 250;
        wacline.Phoenix_System_WAC__c = 700;
        wacline.Phoenix_Uploaded_WAC__c = 700;
        wacline.Phoenix_Proposed_Contr_Price__c = 140.5;
        wacline.Phoenix_System_Contract_price__c = 150;
        wacline.Phoenix_Uploaded_Contr_Price__c = 150;
        wacline.Phoenix_WAC_Change__c = wac.Id;
        insert wacline;
        
        New_Product_WAC_Pricing__c wacprice = new New_Product_WAC_Pricing__c();
        wacprice.Phoenix_Summary__c = 'Approved by Milan 07/01/2021 via email';
        wacprice.Phoenix_TPT__c = 63;
        wacprice.Phoenix_GM__c = 21;
        wacprice.Phoenix_Product_Family__c = 'Carmustine';
        wacprice.Phoenix_Product_Type__c = 'DRL';
        wacprice.Phoenix_Net_sales_annualized__c = 934395;
        wacprice.Phoenix_Approval_Status__c = 'Closed';
        insert wacprice;
        
        New_Product_WAC_Pricing__c newprod = new New_Product_WAC_Pricing__c();
        newprod.Phoenix_Approval_Status__c = 'Closed';
        newprod.Phoenix_GM__c = 21;
        newprod.Phoenix_Head_of_Marketing_Approval__c = 'Approved';
        newprod.Phoenix_Head_of_Marketing_Comments__c = 'Approved per our discussion';
        newprod.Phoenix_Head_of_PM_Grp_Approval__c = 'Approved';
        newprod.Phoenix_Is_Clone_New_Product_WAC_Pricing__c =false;
        newprod.Product_Family__c = pd.id;
        newprod.Phoenix_Product_Type__c = 'DRL';
        newprod.Phoenix_Submitted_Date__c = system.today();
        newprod.Phoenix_Summary__c = 'Approved by Milan 07/01/2021 via email';
        //newprod.Phoenix_WAC_Price_for_New_Launch_Name__c = 750.00;
        insert newprod;
        
        Phoenix_NewProduct_WAC_Pricing_LineItems__c newline = new Phoenix_NewProduct_WAC_Pricing_LineItems__c();
        newline.Phoenix_Material_Number__c = '300026902';
        newline.Phoenix_NDC_11__c = '43598062857';
		newline.Phoenix_Product__c = p1.Id;
		newline.Phoenix_Pkg_Size__c = 1;
		newline.Phoenix_WAC__c = 750;
        newline.Phoenix_Brand_WAC__c = 1603;
        newline.Phoenix_Lowest_Price__c = 435;
        newline.Phoenix_TPT_GM__c = 66;
        newline.Phoenix_Final_Status__c = 'Approved';
        newline.Phoenix_New_Product_WAC_Pricing__c = newprod.Id;
        insert newline;
        
        
        
        Phoenix_User_Approval_Matrix__c record2 = new Phoenix_User_Approval_Matrix__c();
        record2.Name = 'Record 12';
        //record2.RecordType = new RecordType(DeveloperName = 'YourRecordTypeDeveloperName12');
        record2.Phoenix_Approval_Group_Behavior__c = '	Account based';
        record2.Phoenix_Approver_Group_Name__c = 'Finance';
        //record1.Phoenix_Is_Active_User__c = true;
        record2.Phoenix_Is_Approval_Process_User__c = true;
        record2.User_Group__c = user.Id;
        record2.Phoenix_Approver__c=UserInfo.getUserId();
        insert record2;
        
            
            
            
        system.debug('rough list is'+[Select Id, Name, RecordType.DeveloperName, User_Group__r.Phoenix_Approver_Group_Name__c, Phoenix_Approval_Group_Behavior__c, Phoenix_Approver__c, Phoenix_Approver__r.Name, Phoenix_Approver__r.Email, Phoenix_Approver_Group_Name__c, Phoenix_Is_Active_User__c, Phoenix_Is_Approval_Process_User__c, User_Group__c from Phoenix_User_Approval_Matrix__c limit 1000]);
        
        list<Phoenix_PHS_Price_Change_Line__c> rough = [Select Phoenix_Product_Name__c, Phoenix_Product_Name__r.Name, Phoenix_Material_Code__c, Phoenix_NDC_11__c, Phoenix_Provisional_PHS_Price__c, Phoenix_Old_PHS_Price__c, Phoenix_New_PHS_Price__c,	Phoenix_Change_in_Price__c,	Phoenix_Last_90_days_PHS_Units__c,	Phoenix_Sales_Difference__c, Phoenix_Price_Start_Date__c, Phoenix_Price_End_Date__c FROM Phoenix_PHS_Price_Change_Line__c where Phoenix_Final_Status__c != 'Not Approved'];
        system.debug('price change list is '+rough);
        
        emailApprovalNotificationsforNDCChange.approvalEmails(ndc1.Id,bidprocesslist);
        emailApprovalNotificationsforNDCChange.approvalEmailsPHSPriceChange(price2.Id,bidprocesslist);
        emailApprovalNotificationsforNDCChange.approvalEmailsPHSPriceChange(price3.Id,bidprocesslist);
        emailApprovalNotificationsforNDCChange.approvalEmailsPHSPriceChange(price1.Id,bidprocesslist);
        emailApprovalNotificationsforNDCChange.approvalEmailsWACChange(ndc1.Id,bidprocesslist);
        
        emailApprovalNotificationsforNDCChange.approvalEmailsWACChange(wac.Id,bidprocesslist);
        emailApprovalNotificationsforNDCChange.approvalEmailsWACChange(wac.Id,bidprocesslist);
        
        emailApprovalNotificationsforNDCChange.approvalEmailsNewProductWAC(wacprice.Id,bidprocesslist);
        
        emailApprovalNotificationsforNDCChange.approvalEmailsNewProductWAC(ndc1.Id,bidprocesslist);
        emailApprovalNotificationsforNDCChange.approvalEmailsNewProductWAC(newprod.Id,bidprocesslist);
        //emailApprovalNotificationsforNDCChange.updateListItems();
        
    }
    
    
    static testmethod void emailApprovalNotificationsforNDCChange_TestMethod() {
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
        //insert p2;
        
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
        
        
        list<Phoenix_Bid_Process_Steps__c> processlist = new List<Phoenix_Bid_Process_Steps__c>{};
        Phoenix_Bid_Process_Steps__c ps = new Phoenix_Bid_Process_Steps__c();
        ps.Phoenix_Approver__c = UserInfo.getUserId();
        ps.Phoenix_Is_Criteria_Step__c = false;
        ps.Phoenix_Status__c = 'In Process';
        ps.Phoenix_Process_Step__c=pap.Id;
        ps.Phoenix_Bid__c = pb.Id;
        //insert ps;
        processlist.add(ps);
        
        Phoenix_Bid_Process_Steps__c ps1 = new Phoenix_Bid_Process_Steps__c();
        ps1.Phoenix_Approver__c = UserInfo.getUserId();
        ps1.Phoenix_Is_Criteria_Step__c = false;
        ps1.Phoenix_Status__c = 'In Process';
        ps1.Phoenix_Process_Step__c=pap.Id;
        ps1.Phoenix_Bid__c = pb.Id;
        //insert ps1;
        processlist.add(ps1);
        
        
        Phoenix_Bid_Process_Steps__c ps2 = new Phoenix_Bid_Process_Steps__c();
        ps2.Phoenix_Approver__c = UserInfo.getUserId();
        ps2.Phoenix_Is_Criteria_Step__c = false;
        ps2.Phoenix_Status__c = 'In Process';
        ps2.Phoenix_Process_Step__c=pap.Id;
        ps2.Phoenix_Bid__c = pb.Id;
        //insert ps2;
        processlist.add(ps2);
        insert processlist;
        
        emailApprovalNotificationsforNDCChange.approvalEmails(pb.Id,processlist);
        emailApprovalNotificationsforNDCChange.approvalEmailsPHSPriceChange(pb.Id,processlist);
        emailApprovalNotificationsforNDCChange.approvalEmailsPHSPriceChange(pb.Id,processlist);
        emailApprovalNotificationsforNDCChange.approvalEmailsWACChange(pb.Id,processlist);
        emailApprovalNotificationsforNDCChange.approvalEmailsNewProductWAC(pb.Id,processlist);
        
		//emailsforProductDisc_MasPrdctRemoval.sendEmailToAllApproversforProductDiscontinuation(pb.Id,pbLineitems);
        //emailsforProductDisc_MasPrdctRemoval.sendEmailToAllApproversforProductDiscontinuationToMktLead(pb.Id,pbLineitems);
	}
    
    
    static testmethod void sendEmailToAllApproversforProductDiscontinuation_TestMethod2() {
        
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
        pam.Name='Marketing Lead Rx Approval';
        insert pam;
        
        Phoenix_Approval_Process_Step__c pap=new Phoenix_Approval_Process_Step__c();
        pap.Phoenix_Approver__c=UserInfo.getUserId();
        pap.Name='Marketing Lead Rx Approval';
        pap.Phoenix_Approval_Matrix__c=pam.Id;
        insert pap;
        
        
        Phoenix_Bid_Process_Steps__c ps = new Phoenix_Bid_Process_Steps__c();
        ps.Phoenix_Approver__c = null;
        ps.Phoenix_Is_Criteria_Step__c = false;
        ps.Phoenix_Status__c = 'In Process';
        ps.Phoenix_Process_Step__c=pap.Id;
        ps.Phoenix_Bid__c = pb.Id;
        insert ps;
        
        Phoenix_Bid_Process_Steps__c ps1 = new Phoenix_Bid_Process_Steps__c();
        ps1.Phoenix_Approver__c = null;
        ps1.Phoenix_Is_Criteria_Step__c = false;
        ps1.Phoenix_Status__c = 'In Process';
        ps1.Phoenix_Process_Step__c=pap.Id;
        ps1.Phoenix_Bid__c = pb.Id;
        insert ps1;
        
        //emailApprovalNotificationsforNDCChange.approvalEmails(pb.Id,pbLineitems);
        //emailApprovalNotificationsforNDCChange.approvalEmailsPHSPriceChange(pb.Id,pbLineitems);
        //emailApprovalNotificationsforNDCChange.approvalEmailsPHSPriceChange(pb.Id,pbLineitems);
        //emailApprovalNotificationsforNDCChange.approvalEmailsWACChange(pb.Id,pbLineitems);
        //emailApprovalNotificationsforNDCChange.approvalEmailsNewProductWAC(pb.Id,pbLineitems);
		

        
		//emailsforProductDisc_MasPrdctRemoval.sendEmailToAllApproversforProductDiscontinuation(pb.Id,pbLineitems);
        //emailsforProductDisc_MasPrdctRemoval.sendEmailToAllApproversforProductDiscontinuationToMktLead(pb.Id,pbLineitems);
	}

}