/**
* @description       : 
* @author            : Surender Dhruvsoft
* @group             : 
* @last modified on  : 25-05-2021
* @last modified by  : Surender Dhruvsoft
* Modifications Log 
* Ver   Date         Author               Modification
* 1.0   25-05-2021   Surender Dhruvsoft   Initial Version
**/
@isTest
public class BidCloneExtTest {

    static testmethod void BidCloneExtTestMethod() {
        Id phoenixRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Bid Accounts').getRecordTypeId();
        Account testAccount = new Account(Name = 'Test Account', Phoenix_Preferred_Wholesaler__c = 'ABC', Phoenix_Is_Govt_Customer__c = true);
        insert testAccount;
        
        Id phoenixRecordTypeId2 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Bid Accounts').getRecordTypeId();
        Account testAccount2 = new Account(Name = 'Test Account2', Phoenix_Preferred_Wholesaler__c = 'ABC', Phoenix_Is_Govt_Customer__c = true);
        insert testAccount2;
        
        String orgId = UserInfo.getOrganizationId();
        String dateString = String.valueof(Datetime.now()).replace(' ', '').replace(':', '').replace('-', '');
        
        Integer RandomId = Integer.valueOf(Math.rint(Math.random() * 1000000));
        String uniqueName = orgId + dateString + RandomId;
        Profile prof = [select id from profile where name LIKE '%System Admin%'
                        limit 1
                       ];
        
        User user = new User();
        user.firstName = 'Alan';
        user.lastName = 'McCarthy';
        user.profileId = prof.id;
        user.username = 'testsamplehkhhb1@test.com';
        user.email = 'msggghgggg@gmail.com';
        user.EmailEncodingKey = 'ISO-8859-1';
        user.Alias = uniqueName.substring(18, 23);
        user.TimeZoneSidKey = 'America/Los_Angeles';
        user.LocaleSidKey = 'en_US';
        user.LanguageLocaleKey = 'en_US';
        insert user;
        
        list < Product2 > prodList = new list < Product2 > ();
        Product2 prod1 = new Product2(Name = 'Test Product', Phoenix_Product_Director__c = user.Id, Phoenix_Rx_SRx_OTC__c = 'Rx', Phoenix_Special_Product__c = true, Phoenix_GPI_Generic_Product_Identifier__c = '11111', Phoenix_NDC_11__c = '12345678902', Family = 'Test Family', IsActive = TRUE);
        Product2 prod2 = new Product2(Name = 'Test Product1', Phoenix_Product_Director__c = user.Id, Phoenix_Rx_SRx_OTC__c = 'Rx', Phoenix_Special_Product__c = true, Phoenix_GPI_Generic_Product_Identifier__c = '22222', Phoenix_NDC_11__c = '21345678902', Family = 'Test Family', IsActive = TRUE);
        Product2 prod3 = new Product2(Name = 'Test Product2', Phoenix_Product_Director__c = user.Id, Phoenix_Rx_SRx_OTC__c = 'Rx', Phoenix_Special_Product__c = true, Phoenix_NDC_11__c = '32145678903', Family = ' cetirizine', IsActive = TRUE);
        Product2 prod4 = new Product2(Name = 'Test Product3', Phoenix_Product_Director__c = user.Id, Phoenix_Rx_SRx_OTC__c = 'OTC', Phoenix_Special_Product__c = true, Phoenix_GPI_Generic_Product_Identifier__c = '333333', Family = ' cetirizine', IsActive = TRUE);
        
        prodList.add(prod1);
        prodList.add(prod2);
        prodList.add(prod3);
        prodList.add(prod4);
        insert prodList;
        
        Phoenix_Bid__c pb = new Phoenix_Bid__c();
        pb.Phoenix_Status__c = 'New';
        pb.Phoenix_Comments__c = 'Test Comments';
        pb.Phoenix_Customer__c = testAccount.Id;
        insert pb;
        //New
        Phoenix_Bid__c pb1 = new Phoenix_Bid__c();
        pb.Phoenix_Status__c = 'New';
        pb.Phoenix_Comments__c = 'Test Comments2';
        pb.Phoenix_Customer__c = testAccount2.Id;
        insert pb1;
        //end
        Phoenix_Bid_Line_Item__c bli = new Phoenix_Bid_Line_Item__c();
        bli.Phoenix_Product_Director1__c = 'test1' + '' + 'test';
        bli.Phoenix_Bid__c = pb.id;
        bli.Phoenix_PS_Partner_11__c = 'test partner1';
        bli.Phoenix_PS_Partner_21__c = 'test partner2';
        insert bli;
        
        BidCloneExt.BidWrapper pbWrapper = new BidCloneExt.BidWrapper();
        pbWrapper = BidCloneExt.getbidInfo(pb.Id);
        //New
        BidCloneExt.BidWrapper pb1Wrapper = new BidCloneExt.BidWrapper();
        pb1Wrapper = BidCloneExt.getbidInfo(pb1.Id);
        //end        
        BidCloneExt.BidWrapper pbWrapper1 = new BidCloneExt.BidWrapper();
        pbWrapper1.bid = pb;
        pbWrapper1.isBidCreated = true;
        BidCloneExt.getproducts1(pbWrapper1);
        //New
        BidCloneExt.BidWrapper pb1Wrapper1 = new BidCloneExt.BidWrapper();
        pb1Wrapper1.bid = pb1;
        pb1Wrapper1.isBidCreated = true;
        BidCloneExt.getproducts1(pb1Wrapper1);
        //end
        
        Phoenix_Bid_Fee_Master__c fee = new Phoenix_Bid_Fee_Master__c(Phoenix_Preferred_Wholesaler__c = 'ABC', Phoenix_Product_Type_for_CM_Fee__c = 'Special Product', Phoenix_Customer_Type__c = 'Govt business', Phoenix_Fee__c = 10.25);
        insert fee;
        
        string search = 'Test';
        string searchFamily = 'Test';
        list < string > RxSrxList = new list < string > ();
        RxSrxList.add('Rx');
        list < string > directorList = new list < string > ();
        directorList.add('Alan McCarthy');
        string searchNDC = '12345678902 32145678903';
        pb.Phoenix_Bid_Type__c = 'IPA Floor Pricing Update';
        update pb;
        BidCloneExt.BidWrapper pbWrapper2 = new BidCloneExt.BidWrapper();
        pbWrapper2.bid = pb;
        pbWrapper2.isBidCreated = true;
        //New
        string search1 = 'Test Product1';
        string searchFamily1 = 'Test Product1';
        list < string > RxSrxList1 = new list < string > ();
        RxSrxList1.add('Rx');
        list < string > directorList1 = new list < string > ();
        directorList1.add('Alan McCarthy');
        string searchNDC1 = '12345678902 32145678903';
        pb.Phoenix_Bid_Type__c = 'IPA Floor Pricing Update';
        update pb1;
        BidCloneExt.BidWrapper pbWrapper3 = new BidCloneExt.BidWrapper();
        pbWrapper3.bid = pb;
        pbWrapper3.isBidCreated = true;
        //end
        list < Phoenix_Bid_Line_Item__c > clonelineItems = new list < Phoenix_Bid_Line_Item__c > ();
        list < Phoenix_Bid_Line_Item__c > lineItemsList = new list < Phoenix_Bid_Line_Item__c > ();
        for (Integer i = 0; i < prodList.size(); i++) {
            
            Phoenix_Bid_Line_Item__c pbl = new Phoenix_Bid_Line_Item__c(Phoenix_Bid__c = pb.Id, Phoenix_Final_Status__c = '', Phoenix_Product__c = prodList[i].Id);
            clonelineItems.add(pbl);
        }
        insert clonelineItems;
        
        list < BidCloneExt.wrapperClass > wrap = new list < BidCloneExt.wrapperClass > ();
        list < string > productIds = new list < string > ();
        for (Integer i = 0; i < clonelineItems.size(); i++) {
            BidCloneExt.wrapperClass pbw = new BidCloneExt.wrapperClass();
            pbw.qlItem = clonelineItems[i];
            pbw.isSelected = true;
            
            wrap.add(pbw);
            productIds.add(clonelineItems[i].Phoenix_Product__c);
            
        }
        BidCloneExt.getSearch(wrap, directorList, search, searchFamily, RxSrxList, pbWrapper1);
        //BidCloneExt.getSearch(wrap,directorList, search,searchFamily,RxSrxList,pbWrapper2);
        RxSrxList.add('SRx');
        //BidCloneExt.getSearch(wrap,directorList, '333333',searchFamily,RxSrxList,pbWrapper1);
        //        BidCloneExt.getSearch(wrap,directorList, searchNDC,searchFamily,RxSrxList,pbWrapper1);
        BidCloneExt.findBySrxOtc(RxSrxList, directorList, search, searchFamily, wrap, pbWrapper1);
        BidCloneExt.findBySrxOtc(RxSrxList, directorList, search, searchFamily, wrap, pbWrapper2);
        BidCloneExt.getSearchFamily(wrap, directorList, searchFamily, search, RxSrxList, pbWrapper1);
        BidCloneExt.getSearchFamily(wrap, directorList, searchFamily, search, RxSrxList, pbWrapper2);
        BidCloneExt.getsearchDirectorResult(wrap, directorList, searchFamily, search, RxSrxList, pbWrapper1);
        BidCloneExt.getsearchDirectorResult(wrap, directorList, searchFamily, search, RxSrxList, pbWrapper2);
        BidCloneExt.getProductDirectorList(pbWrapper1);
        //New
        BidCloneExt.getSearch(wrap, directorList1, search1, searchFamily1, RxSrxList1, pb1Wrapper1);
        RxSrxList1.add('SRx');
        BidCloneExt.findBySrxOtc(RxSrxList1, directorList1, search1, searchFamily1, wrap, pb1Wrapper1);
        BidCloneExt.findBySrxOtc(RxSrxList1, directorList1, search1, searchFamily1, wrap, pbWrapper3);
        BidCloneExt.getSearchFamily(wrap, directorList1, searchFamily1, search1, RxSrxList1, pb1Wrapper1);
        BidCloneExt.getSearchFamily(wrap, directorList1, searchFamily1, search1, RxSrxList1, pbWrapper3);
        BidCloneExt.getsearchDirectorResult(wrap, directorList1, searchFamily1, search1, RxSrxList1, pb1Wrapper1);
        BidCloneExt.getsearchDirectorResult(wrap, directorList1, searchFamily1, search1, RxSrxList1, pbWrapper3);
        BidCloneExt.getProductDirectorList(pb1Wrapper1);
        //end
        
        
        BidCloneExt.getproducts1(pbWrapper2);
        BidCloneExt.showselectedProducts(pb.Id);
        BidCloneExt.getDeadLineTimeZone();
        BidCloneExt.getDeadLineTime();
        
        Date internalDT = system.today() + 1;
        Date customerDeadDT = system.today() + 1;
        BidCloneExt.processRebid(pb.Id, clonelineItems, 'Re Bid test bid', internalDT, customerDeadDT, 'EST', '6:00 PM');
        list < BidCloneExt.wrapperClass > wraplines = new list < BidCloneExt.wrapperClass > ();
        for (Integer i = 0; i < clonelineItems.size(); i++) {
            BidCloneExt.wrapperClass pbw = new BidCloneExt.wrapperClass();
            pbw.qlItem = clonelineItems[i];
            pbw.isSelected = true;
            pbw.prodName='test';
            pbw.custName='alex';
            pbw.family='Waalgreen';
            pbw.IPAPrice=0.02;
            pbw.NDC='test2';
            pbw.currencyCode='Dollar';
            pbw.contrFlag=false;
            
            wraplines.add(pbw);
            
            
        }
        
        BidCloneExt.fetchSortResults('Name', true, wraplines);
        BidCloneExt.fetchSortResults('Name', false, wraplines);
        
        
    }
    
    static testmethod void BidCloneExtTestMethod2() {
        
        
        
        Id phoenixRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Bid Accounts').getRecordTypeId();
        Account testAccount = new Account(Name = 'Test Account', Phoenix_Preferred_Wholesaler__c = 'ABC', Phoenix_Is_Govt_Customer__c = true);
        insert testAccount;
        
        
        String orgId = UserInfo.getOrganizationId();
        String dateString = String.valueof(Datetime.now()).replace(' ', '').replace(':', '').replace('-', '');
        
        Integer RandomId = Integer.valueOf(Math.rint(Math.random() * 1000000));
        String uniqueName = orgId + dateString + RandomId;
        Profile prof = [select id from profile where name LIKE '%System Admin%'
                        limit 1
                       ];
        
        User user1 = new User();
        user1.firstName = 'sample';
        user1.lastName = 'user';
        user1.profileId = prof.id;
        user1.username = 'mhgkhugkhg@user.com';
        user1.email = 'samplerfdef@gmail.com';
        user1.EmailEncodingKey = 'ISO-8859-1';
        user1.Alias = uniqueName.substring(18, 23);
        user1.TimeZoneSidKey = 'America/Los_Angeles';
        user1.LocaleSidKey = 'en_US';
        user1.LanguageLocaleKey = 'en_US';
        insert user1;
        
        contact testcontact = new contact(lastname = 'test contact',accountid = testaccount.id);
        insert testcontact;
        
        
        Phoenix_Contract__c Cntrct = new Phoenix_Contract__c();
        Cntrct.name = 'taest cntrct';
        Cntrct.Phoenix_Contract_Number__c = '3000000551';
        insert Cntrct; 
        
        Id Phoenix_Bidrcdtype = Schema.SObjectType.Phoenix_Bid__c.getRecordTypeInfosByName().get('Phoenix Bid').getRecordTypeId();
        

        
        Phoenix_Partner__c part = new Phoenix_Partner__c();
        part.name = 'test partner';
        insert part;
        
        Phoenix_Bid_VIP_Rebate__c rebate = new Phoenix_Bid_VIP_Rebate__c();
        rebate.Phoenix_Customer__c = testaccount.id;
        rebate.Phoenix_Start_Date__c= system.today();
        rebate.Phoenix_End_Date__c = system.today()+1;
        rebate.Phoenix_Type__c = 'Currency';
        rebate.Phoenix_Status__c = 	'Current';
        insert rebate;
        
        list < Phoenix_Bid_Line_Item__c > clonelineItems = new list < Phoenix_Bid_Line_Item__c > ();
        
       Product2  pro= new product2();
        pro.name = 'Test product';
        pro.Family ='Cetirizine' ;
   pro.Phoenix_Product_Director__c =user1.id;
        pro.ProductCode = '524';
        pro.Phoenix_Pkg_Size__c = 24;
        pro.Phoenix_Case_Pack__c = 4;
        pro.Phoenix_Minimum_Order_Quantity__c = 2;
        pro.Phoenix_Compare_to_Brand_Name__c = 'test brand';
        pro.Phoenix_Orange_Book_Rating__c = 'test rating';
       pro.Phoenix_Throughput_cost__c =21.254742;
        system.assertEquals(21.254742, pro.Phoenix_Throughput_cost__c);
        pro.Phoenix_WAC__c = 2;
        pro.Phoenix_IMS_Market_Share__c = 'market share';
        pro.Phoenix_Budgeted_ASP_Q1__c  = 2;
        pro.Phoenix_Budgeted_ASP_Q2__c = 3;
        pro.Phoenix_Budgeted_ASP_Q3__c = 4; 
        pro.Phoenix_Budgeted_ASP_Q4__c = 5;
        pro.Phoenix_Lowest_Price_SKU__c = 11;
        pro.Phoenix_Comm_Exps__c = 2;
        pro.Phoenix_IPA_Floor_Price__c  = 4 ;
        pro.Phoenix_Latest_Estimate__c = 5 ; 
        pro.Phoenix_Per_Unit_Profit_Rate_Partner_1__c = 5;
        pro.Phoenix_Per_Unit_Profit_Rate_Partner_2__c = 7 ;
        pro.Phoenix_NDC_11__c = '12345678902';
        pro.Phoenix_PS_Partner_1__c = 8;
        pro.Phoenix_PS_Partner_1_Name__c = part.id;
        pro.Phoenix_PS_Partner_2__c = 7;
        pro.Phoenix_REMS__c = true;
        pro.Phoenix_Royalty__c = 4;
       pro.IsActive = TRUE;
      insert pro;
        

        Phoenix_Bid__c pb = new Phoenix_Bid__c();
        pb.Phoenix_Status__c = 'New';
        pb.Phoenix_Comments__c = 'Test Comments';
        pb.Phoenix_Customer__c = testAccount.Id;
        pb.Phoenix_Approval_Status__c = 'Draft';
        pb.Phoenix_Bid_Type__c = 'ROS';
        pb.RecordTypeId = Phoenix_Bidrcdtype;
        pb.Phoenix_Customer__c = testAccount.id;
        pb.Phoenix_Custom_type__c = 	'Custom type 1';
        pb.Phoenix_Contact__c = testcontact.id ;
        pb.Phoenix_Salesperson__c = UserInfo.getUserId();
        pb.Phoenix_Sent_to_Customer_Date__c = system.today();
        pb.Phoenix_Bid_Created_Behalf_of__c = UserInfo.getUserId();
        pb.Phoenix_Comments__c = 'test phoenix bid';
        pb.Phoenix_Is_Re_Bid__c = true;
        pb.Phoenix_Proposed_Value_Admin_Fee__c = 24;
        pb.Phoenix_Formal_Offer_Needed__c = true;
        pb.Phoenix_Bid_Owner__c = UserInfo.getUserId();
        pb.Phoenix_Customer_Type__c = 'Costco';
        pb.Phoenix_Cash_Terms_Days__c = 4;
        pb.Phoenix_Select_Wholesaler__c = 'ABC';
        pb.Phoenix_Contract_Management_Fee__c = 2 ; 
        pb.Phoenix_Contract_Workflow_Type__c = 'Bonafide Fee Setup';
        pb.Phoenix_Reference_Contracts__c = 'test bid';
        pb.Phoenix_Current_CD__c = 2;
        pb.Phoenix_Current_Contract__c = 'test contract';
        pb.Phoenix_Current_Value_Est_VIP__c = 2;
        pb.Phoenix_Current_VIP_Rebate__c = rebate.id;
        pb.Phoenix_Group_VIP__c = 2;
        pb.Phoenix_Initial_Order_Discount_of_Days__c = 4;
        pb.Phoenix_Initial_Order_Discount_Type__c = 'None';
        pb.Phoenix_Is_Checklist_Exist__c = true;
        pb.Phoenix_Review_Details__c = 'test details';
        pb.Phoenix_Proactive_Reactive__c = 'Proactive';
        pb.Phoenix_Proposed_Admin_Fee_Basis__c = 'Gross';
        pb.Phoenix_Proposed_Cash_Terms__c = 2;
        pb.Phoenix_Proposed_Value_Est_VIP__c = 2;
        pb.Phoenix_Proposed_Initial_Order_Discount__c = 2;
        pb.Phoenix_Proposed_Position__c = 'test position';
        pb.Phoenix_Proposed_Rebate_Basis__c = 'Gross';
        pb.Phoenix_Proposed_Sales_Out_Promotion__c = 2;
        pb.Phoenix_Proposed_SSA_No_of_Days__c = 2;
        pb.Phoenix_Proposed_VIP_Rebate__c = rebate.id;
        pb.Phoenix_Sales_Out_Promotion_of_Days__c = 2 ;
        pb.Phoenix_Sales_Person_2__c = UserInfo.getUserId();
        pb.Phoenix_Value_Est_VIP_Type__c = 'Gross';
        pb.Phoenix_OTB_Direct_Indirect__c = 'Direct';
        insert pb;
  
        Phoenix_Bid_Line_Item__c blitmm = new Phoenix_Bid_Line_Item__c();
       blitmm.Phoenix_Bid__c = pb.id;
        blitmm.Phoenix_Product__c = pro.id;
        blitmm.Phoenix_Final_Status__c = 'Approved';
        blitmm.Phoenix_Contract__c = Cntrct.id;
     blitmm.Phoenix_Current_Indirect_Selling_Unit__c = 2;
        blitmm.Phoenix_Proposed_Indirect_Selling_Unit__c = 3;
        blitmm.Phoenix_Current_Indirect_Price__c = 2;
        blitmm.Phoenix_Guidance_Price__c = 3;
        blitmm.Phoenix_ProposedContract_Bid_Price_Sales__c = 3;
        blitmm.Phoenix_ProposedContractBidPriceMktng__c = 4;
        blitmm.Phoenix_Customer_Dead_Net1__c = 4;
        blitmm.Phoenix_Current_Rebate__c = 7;
        blitmm.Phoenix_Proposed_Current_Rebate__c = 10;
        blitmm.Phoenix_Internal_Dead_Net_Price__c = 21;
        blitmm.Phoenix_Net_Sales_Internal__c = 21;
        blitmm.Phoenix_SCM_Review__c = true;
        blitmm.Phoenix_Bid_Status__c = 'Awarded';
        blitmm.Phoenix_Cash_Terms__c = 12;
        blitmm.Phoenix_Contract_Mngment_Fee_Wholesaler__c = 2;
        blitmm.Phoenix_Current_Per_Unit_Rebate__c = 2;
        blitmm.Phoenix_Current_Admin_Fee__c = 12;
        blitmm.Phoenix_Current_Direct_Price__c = 10;
        blitmm.Phoenix_Current_Direct_Selling_Unit__c = 2 ; 
        blitmm.Phoenix_Current_Net_Sales_Internal__c = 21;
        blitmm.Phoenix_Customer__c = testaccount.id;
        blitmm.Phoenix_Customer_Decline_Reasons__c = 'No Response - Closing bid';
        blitmm.Phoenix_RDC_NLC__c = 2;
        blitmm.Phoenix_Customer_Requested_Days__c = 2;
        blitmm.Phoenix_Days_Notice_Product_Discontinuat__c = 3;
        blitmm.Phoenix_Day_s_Notice_Product_removal__c = 4;
        blitmm.Phoenix_DeadNet_TrckGR__c =  4 ;
        blitmm.Phoenix_Direct_Dead_Net__c = 12;
        blitmm.Phoenix_Direct_Order_Price1__c = 4;
        blitmm.Phoenix_Effective_Date__c = system.today();
        blitmm.Phoenix_Estimated_Medicaid_Returns__c = 4 ; 
        blitmm.Phoenix_Fee_G_N__c = 'test line items';
        blitmm.Phoenix_Final_Direct_Selling_Units_Calc__c = 4;
        blitmm.Phoenix_Final_Indirect_Selling_Units_Cal__c = 5 ;
        blitmm.Phoenix_IDN_Usage__c = 7;
        blitmm.Phoenix_Indirect_CD_Per__c = 4;
        blitmm.Phoenix_Indirect_Dead_Net__c = 5;
        blitmm.Phoenix_Local_VIP__c = 4 ; 
        blitmm.Phoenix_Net_Price_afterRebates_after_VIP__c = 4;
        blitmm.Phoenix_Net_Price_after_Rebates_Terms__c = 7;
        blitmm.Phoenix_Net_Price_after_RebatesbeforeVIP__c = 8;
        blitmm.Phoenix_Net_Sales_External__c = 11;
        blitmm.Phoenix_New_WAC__c = 5;
        blitmm.Phoenix_Price_Effective_Date__c = system.today();
        blitmm.Phoenix_Pricing_Notes__c = 'Testing notes';
        blitmm.Phoenix_Proactive_Reactive__c = 'Proactive';
        blitmm.Phoenix_Proposed_Direct_Selling_Unit__c = 5;
        blitmm.Phoenix_Proposed_IPA_Price__c = 6;
        blitmm.Proposed_Net_Sales_Direct__c = 5 ; 
        blitmm.Proposed_Net_Sales_Indirect__c= 4 ; 
        blitmm.Phoenix_Proposed_Per_Unit_Rebate__c = 4;
        blitmm.Proposed_TPT_Direct__c = 4;
        blitmm.Proposed_TPT_Indirect__c = 2;
        blitmm.Proposed_TPT_Per_Direct__c = 4 ;
        blitmm.Proposed_TPT_Per_Indirect__c = 5;
        blitmm.Phoenix_Rebate_G_N__c = 'Test rebate';
        blitmm.Phoenix_Retail_Indirect_Wholesaler_Fee__c = 4;
        blitmm.Phoenix_Revisited_Date__c = system.today();
        blitmm.Phoenix_SCM_Qty_Approved_Direct__c = 4;
        blitmm.Phoenix_SCM_Qty_Approved_Indirect__c = 5;
        blitmm.Phoenix_Supply_Effective_Date__c = system.today();
        blitmm.Phoenix_Wholesaler_Diff_Price_Indirect__c = 5;
        blitmm.Phoenix_Wholesaler_Price_Percent__c = 6;
        blitmm.Phoenix_ZITD_Value__c = 4;
        blitmm.Phoenix_12_Months_Actual_Sales__c = 4;
        blitmm.Phoenix_Override_Current_Units__c = 5;
        blitmm.Phoenix_Current_Position__c =  'Test current position';
        blitmm.Phoenix_Direct_ESI__c = 2;
        blitmm.Phoenix_Indirect_ESI__c = 3;
        blitmm.Phoenix_Direct_Kroger__c = 5;
        blitmm.Phoenix_Indirect_Kroger__c = 6;
        blitmm.Phoenix_Direct_Rx_Outreach__c = 3;
        blitmm.Phoenix_Indirect_Rx_Outreach__c = 4;
        blitmm.Phoenix_Direct_Supervalu__c = 5;
        blitmm.Phoenix_Indirect_Supervalu__c = 6;
        blitmm.Phoenix_Direct_Cigna__c = 3;
        blitmm.Phoenix_Indirect_Cigna__c = 4;
        blitmm.Phoenix_Direct_Cordant__c = 2;
        blitmm.Phoenix_Indirect_Cordant__c = 3;
        blitmm.Phoenix_Direct_Accerodo__c = 5;
        blitmm.Phoenix_Indirect_Accerodo__c = 6;
        blitmm.Phoenix_Others_Direct__c = 5;
        blitmm.Phoenix_Others_Indirect__c = 6;
        blitmm.Phoenix_Current_Wholesaler_Units__c =2;
        blitmm.Phoenix_Current_Anda_Units__c = 3;
        blitmm.Phoenix_Current_Retail_Direct_Units__c = 3;
        blitmm.Phoenix_Current_Anda_Net_Model_Units__c = 4;
        blitmm.Phoenix_Current_Retail_Indirect_Units__c = 5;
        blitmm.Phoenix_Current_Indirect_Gaint_EagleUnit__c = 6;
        blitmm.Phoenix_Proposed_Anda_Units__c = 5;
        blitmm.Phoenix_Proposed_Smith_Drug_Units__c = 6;
        blitmm.Phoenix_ProposedDirectAholdDelhaizeUnits__c = 7;
        blitmm.Phoenix_ProposedDirectGaintEagleUnits__c = 8;
        blitmm.Phoenix_ProposedIndirectAholdDelhaizeUni__c = 7;
        blitmm.Phoenix_Proposed_IndirectGaintEagleUnits__c = 5;
        blitmm.Phoenix_Current_Retail_Direct_Price__c = 6;
        blitmm.Phoenix_Current_Retail_Indirect_Net__c = 7;
        blitmm.Phoenix_Current_Retail_Indirect_Price__c = 8;
        blitmm.Phoenix_Current_Wholesaler_Price__c = 5;
        blitmm.Phoenix_Current_Anda_Invoice_Price__c = 5;
        blitmm.Phoenix_Current_Anda_CP_Price__c = 4;
        blitmm.Phoenix_Current_Anda_Acquisition_Costs__c = 4;
        blitmm.Phoenix_Retail_Direct_Guidance_Price__c = 5;
        blitmm.Phoenix_Wholesaler_Guidance_Price__c = 6;
        blitmm.Phoenix_Retail_Direct_Sales_Price__c = 4;
        blitmm.Phoenix_Wholesaler_Sales_Price__c = 5;
        blitmm.Phoenix_Reduction__c = 4;
        blitmm.Phoenix_Retail_Direct_Price__c = 2;
        blitmm.Phoenix_Retail_Indirect_Net__c = 3;
        blitmm.Phoenix_Retail_Indirect_Price__c = 5;
        blitmm.Phoenix_Wholesaler_Price_RxSS__c = 4;
        blitmm.Phoenix_Cash_Terms_RxSS__c = 7;
        blitmm.Phoenix_Anda_New_Model_Acqusition_Costs__c = 4;
        blitmm.Phoenix_Direct_CD__c = 4;
        blitmm.Phoenix_Retail_Direct_Admin_Fee__c = 3;
        blitmm.Phoenix_Retail_Direct_VIP__c = 2;
        blitmm.Phoenix_Retail_Indirect_ZITD__c= 4;
        blitmm.Phoenix_Retail_Indirect_Admin_Fees__c = 5;
        blitmm.Phoenix_Retail_Indirect_VIP__c = 4;
        blitmm.Phoenix_Retail_Indirect_WAC_NLC_Fee__c = 2;
        blitmm.Phoenix_Retail_Indirect_WholesalerFeeRxS__c = 4;
        blitmm.Phoenix_Anda_Admin_Fees__c = 7;
        blitmm.Phoenix_Anda_VIP__c = 4;
        blitmm.Phoenix_Wholesaler_Admin_Fee__c = 5;
        blitmm.Phoenix_Wholesaler_VIP__c = 4;
        blitmm.Phoenix_Retail_Customer_Net_Price__c = 5;
        blitmm.Phoenix_Wholesaler_Customer_Net_Price__c = 2;
        blitmm.Phoenix_Wholesaler_DRL_Net_Price__c = 2;
        blitmm.Phoenix_Anda_DRL_Net_price__c = 5;
        blitmm.Phoenix_Retail_Direct_DRL_TPT__c = 2;
        blitmm.Phoenix_Retail_Indirect_DRL_TPT__c = 4;
        blitmm.Phoenix_Wholesaler_DRL_TPT__c = 2;
        blitmm.Phoenix_Anda_DRL_TPT__c = 4;
        blitmm.Phoenix_Retail_Direct_DRL_TPT_Percent__c = 4;
        blitmm.Phoenix_Retail_Indirect_DRL_TPT_Percent__c = 1;
        blitmm.Phoenix_Wholesaler_DRL_TPT_Percent__c = 5;
        blitmm.Phoenix_Anda_DRL_TPT_Percent__c = 3;
        blitmm.Phoenix_Retail_IOD_per_unit__c = 4;
        blitmm.Phoenix_ANDA_IOD_Per_unit__c = 1;
        blitmm.Phoenix_Wholesaler_IOD_per_unit__c = 4;
        blitmm.Phoenix_Retail_IOD_overall_amount__c = 1;
        blitmm.Phoenix_ANDA_IOD_Overall_Amount__c = 5;
        blitmm.Phoenix_Wholesaler_IOD_overall_amount__c = 4;
        blitmm.Phoenix_Retail_Direct_Net_sales__c =  5;
        blitmm.Phoenix_Retail_Indirect_Net_Sales__c = 4;
        blitmm.Phoenix_Anda_Net_Model_Sales__c = 5;
        blitmm.Phoenix_Wholesaler_Net_Sales__c = 2;
        blitmm.Phoenix_Override_Current_Direct_Units__c = 1;
        blitmm.Phoenix_Override_Current_Indirect_Units__c = 2;
        blitmm.Phoenix_OS_RAD_CP__c = 2;
        blitmm.Phoenix_WMT_Direct_CP__c = 4;
        blitmm.Phoenix_WMT_Indirect_CP__c = 5;
        blitmm.Phoenix_OS_RAD_PUR__c = 6;
        blitmm.Phoenix_WMT_Direct_PUR__c = 7;
        blitmm.Phoenix_WMT_Indirect_PUR__c = 10;
        blitmm.Phoenix_OS_RAD_NCP__c = 8;
        blitmm.Phoenix_WMT_Direct_NCP__c = 3;
        blitmm.Phoenix_WMT_Indirect_NCP__c = 4;
        blitmm.Phoenix_Current_McK_RAD_Dead_net__c = 5;
        blitmm.Phoenix_Current_WMT_Direct_Dead_net__c = 4;
        blitmm.Phoenix_Current_WMT_Indirect_Dead_net__c = 3;
        blitmm.Phoenix_OS_and_RAD_Cur_Direct_Units_C__c = 2;
        blitmm.Phoenix_WMT_Current_Direct_Units__c = 1;
        blitmm.Phoenix_WMT_Current_Indirect_Units__c = 2;
        blitmm.Phoenix_Proposed_OS_Units__c = 4;
        blitmm.Phoenix_Proposed_RAD_Units__c = 2;
        blitmm.Phoenix_Proposed_WMT_Units__c = 3;
        blitmm.Phoenix_Proposed_WMT_Direct_NCP__c = 4;
        blitmm.Phoenix_Proposed_WMT_Indirect_NCP__c = 5;
        blitmm.Phoenix_Proposed_McK_OS_And_RAD_NCP__c = 3;
        blitmm.Phoenix_Sales_Proposed_NCP_McK_And_RAD__c = 4;
        blitmm.Phoenix_Reduc_in_NCP_McK_And_RAD__c = 2;
        blitmm.Phoenix_Reduction_in_NCP_WMT__c = 4;
        blitmm.Phoenix_Anda_Old_Acqusition_Costs__c = 3;
        blitmm.Phoenix_Admin_Fee_WMT_Direct_NCP__c = 4;
        blitmm.Phoenix_WMT_Direct_Dead_Net_Proposed__c = 2;
        blitmm.Phoenix_RDC_WMT_Indirect__c = 1;
        blitmm.Phoenix_CM_Fee_WMT_Indirect__c = 5;
        blitmm.Phoenix_Stocking_Allowance_Per_Unit__c = 4;
        blitmm.Phoenix_WMT_Stck_Allowance_Overall_Amnt__c = 6;
        blitmm.Phoenix_WMT_Indirect_Net_Sales__c = 1;
        blitmm.Phoenix_WMT_Indirect_TPT__c = 2;
        blitmm.Phoenix_Current_Supplier__c = 'test current supplier';
        blitmm.Brand_WAC__c=1;
        blitmm.Phoenix_Brand_WAC_Per__c = 4;
        blitmm.Phoenix_Opening_Order__c = 4;
        blitmm.Phoenix_Opening_Order_Net_sales__c = 4;
        blitmm.Phoenix_Opening_Order_TPT__c = 2;
        blitmm.Phoenix_Opening_Order_TPT_Per__c = 3;
        blitmm.Phoenix_NLC__c = 2;
        blitmm.Phoenix_Override_Total_units__c = 3;
        blitmm.Phoenix_SCM_Review__c = false;
       blitmm.Phoenix_Product_Director1__c = 'test1' + '' + 'test';
       blitmm.Phoenix_PS_Partner_11__c = 'test partner1';
        blitmm.Phoenix_PS_Partner_21__c = 'test partner2';
      
        
        
       clonelineItems.add(blitmm);
    
        insert clonelineItems;
        system.debug('list is '+clonelineItems);
        
        Date internalDT = system.today() + 1;
        Date customerDeadDT = system.today() + 1;
        
         BidCloneExt.processRebid(pb.Id, clonelineItems, 'Re Bid test bid 2', internalDT, customerDeadDT, 'EST', '6:00 PM');
    }
    
}