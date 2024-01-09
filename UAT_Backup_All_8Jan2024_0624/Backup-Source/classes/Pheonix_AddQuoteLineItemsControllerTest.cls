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
public class Pheonix_AddQuoteLineItemsControllerTest {
    static testmethod void AddProductMethod() {
        Id phoenixRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Bid Accounts').getRecordTypeId();
        Account testAccount = new Account(Name = 'Test Account', Phoenix_Preferred_Wholesaler__c = 'ABC', Phoenix_Is_Govt_Customer__c = true);
        insert testAccount;
        list < Product2 > prodList = new list < Product2 > ();
        Product2 prod1 = new Product2(Name = 'Test Product', Phoenix_Rx_SRx_OTC__c = 'Rx', Phoenix_Special_Product__c = true, Phoenix_GPI_Generic_Product_Identifier__c = '11111', Phoenix_NDC_11__c = '12345678902', Family = 'Test Family', IsActive = TRUE);
        Product2 prod2 = new Product2(Name = 'Test Product1', Phoenix_Rx_SRx_OTC__c = 'Rx', Phoenix_Special_Product__c = true, Phoenix_GPI_Generic_Product_Identifier__c = '22222', Phoenix_NDC_11__c = '21345678902', Family = 'Sample Family', IsActive = TRUE);
        Product2 prod3 = new Product2(Name = 'Test Product2', Phoenix_Rx_SRx_OTC__c = 'SRx', Phoenix_Special_Product__c = true, Phoenix_NDC_11__c = '32145678902', Family = ' cetirizine', IsActive = TRUE);
        Product2 prod4 = new Product2(Name = 'Test Product3', Phoenix_Rx_SRx_OTC__c = 'OTC', Phoenix_Special_Product__c = true, Phoenix_GPI_Generic_Product_Identifier__c = '333333', Family = ' cetirizine', IsActive = TRUE);
        
        prodList.add(prod1);
        prodList.add(prod2);
        prodList.add(prod3);
        prodList.add(prod4);
        insert prodList;
        
        Phoenix_Bid__c pb = new Phoenix_Bid__c();
        pb.Phoenix_Status__c = 'New';
        //   pb.Phoenix_Bid_Type__c = 'IPA Floor Pricing Update';
        pb.Phoenix_Comments__c = 'Test Comments';
        pb.Phoenix_Customer__c = testAccount.Id;
        pb.Phoenix_Customer_Type__c='Econdisc';
        insert pb;
        
        
        Account testBidAccount = new Account(Name = 'TestBid Account', Phoenix_Preferred_Wholesaler__c = 'ABC',Phoenix_Customer_Class_Bid_Template__c='Base/DSH', Phoenix_Is_Govt_Customer__c = true);
        insert testBidAccount; 
        Phoenix_Bid__c testBid = new Phoenix_Bid__c();
        testBid.Phoenix_Status__c = 'New';
        testBid.Phoenix_Comments__c = 'Test Comments';
        testBid.Phoenix_Customer__c = testBidAccount.Id;
        insert testBid;
        
        
        list < Phoenix_Bid_Line_Item__c > lineItemsList1 = new list < Phoenix_Bid_Line_Item__c > ();
        Phoenix_Bid_Line_Item__c pbl1=new Phoenix_Bid_Line_Item__c();
        pbl1.Phoenix_Bid__c=testBid.Id;
        pbl1.Phoenix_Product__c = prod1.id;
        pbl1.Phoenix_Contract_Mngment_Fee_Wholesaler__c=2;
        lineItemsList1.add(pbl1);
        Phoenix_Bid_Line_Item__c pbl2=new Phoenix_Bid_Line_Item__c();
        pbl2.Phoenix_Bid__c=testBid.Id;
        pbl2.Phoenix_Contract_Mngment_Fee_Wholesaler__c=2;
        pbl2.Phoenix_Product__c = prod2.id;
        lineItemsList1.add(pbl2);
        insert lineItemsList1;
        
        
        Phoenix_BidCreatorCtrl.BidWrapper pbWrapper = new Phoenix_BidCreatorCtrl.BidWrapper();
        pbWrapper = Pheonix_AddQuoteLineItemsController.getBidInfo(pb.Id);
        
        Phoenix_BidCreatorCtrl.BidWrapper pbWrapper1 = new Phoenix_BidCreatorCtrl.BidWrapper();
        pbWrapper1.bid = pb;
        pbWrapper1.isBidCreated = true;
        Pheonix_AddQuoteLineItemsController.getproducts1(pbWrapper1);
        Pheonix_AddQuoteLineItemsController.getContracts(null, 'test','ROS');
        Phoenix_Bid_Fee_Master__c fee = new Phoenix_Bid_Fee_Master__c(Phoenix_Preferred_Wholesaler__c = 'ABC', Phoenix_Product_Type_for_CM_Fee__c = 'Special Product', Phoenix_Customer_Type__c = 'Govt business', Phoenix_Fee__c = 10.25);
        insert fee;
        
        list < Phoenix_BidCreatorCtrl.wrapperClass > wrap = new list < Phoenix_BidCreatorCtrl.wrapperClass > ();
        list < string > productIds = new list < string > ();
        for (Integer i = 0; i < prodList.size(); i++) {
            Phoenix_BidCreatorCtrl.wrapperClass pbw = new Phoenix_BidCreatorCtrl.wrapperClass();
            pbw.prdlist = prodList[i];
            pbw.isSelected = true;
            pbw.currencyCode = '$';
            wrap.add(pbw);
            productIds.add(prodList[i].Id);
            
        }
        string search = 'test';
        string searchFamily = 'test';
        list < string > RxSrxList = new list < string > ();
        RxSrxList.add('Rx');
        list < string > directorList = new list < string > ();
        directorList.add('Suseela Dhruvsoft');
        string searchNDC = '12345678902 21345678902';
        //Pheonix_AddQuoteLineItemsController.getSearch(wrap, directorList, search, searchFamily, RxSrxList, pbWrapper1);
        RxSrxList.add('SRx');
        //Pheonix_AddQuoteLineItemsController.finalSearchResult(wrap, directorList, '333333', searchFamily, RxSrxList, pbWrapper1);
        //Pheonix_AddQuoteLineItemsController.finalSearchResult(wrap, directorList, searchNDC, searchFamily, RxSrxList, pbWrapper1);
        //Pheonix_AddQuoteLineItemsController.findBySrxOtc(RxSrxList, directorList, search, searchFamily, wrap, pbWrapper1);
        //Pheonix_AddQuoteLineItemsController.finalSearchResult(wrap, directorList, searchFamily, search, RxSrxList, pbWrapper1);
        //Pheonix_AddQuoteLineItemsController.finalSearchResult(wrap, directorList, searchFamily, search, RxSrxList, pbWrapper1);
        Pheonix_AddQuoteLineItemsController.getProductDirectorList(pbWrapper1);
        Pheonix_AddQuoteLineItemsController.showselectedProducts(pb.Id);
        Pheonix_AddQuoteLineItemsController.getContractProducts(pbWrapper1, new list < Id > {});
        //Pheonix_AddQuoteLineItemsController.getproductsForSelectedCnts(pbWrapper1,productIds);
        
        
        list < Phoenix_BidCreatorCtrl.wrapperClass > wrap1 = new list < Phoenix_BidCreatorCtrl.wrapperClass > ();
        list < Phoenix_Bid_Line_Item__c > lineItemsList = new list < Phoenix_Bid_Line_Item__c > ();
        for (Integer i = 0; i < prodList.size(); i++) {
            Phoenix_BidCreatorCtrl.wrapperClass pbw = new Phoenix_BidCreatorCtrl.wrapperClass();
            Phoenix_Bid_Line_Item__c pbl = new Phoenix_Bid_Line_Item__c(Phoenix_Bid__c = pb.Id);
            pbw.qlItem = pbl;
            pbw.prdlist = prodList[i];
            wrap1.add(pbw);
        }
        list < string > selectrcs = new list < string > ();
        selectrcs.add('selectrcs');
        Pheonix_AddQuoteLineItemsController.savequoteitems(wrap1, pbWrapper1, selectrcs);
        Pheonix_AddQuoteLineItemsController.fetchSortResults('Name', true, wrap);
        
    }
    static testMethod void test2() {
        Account testAccount = new Account(Name = 'Test Account', Phoenix_Preferred_Wholesaler__c = 'ABC', Phoenix_Is_Govt_Customer__c = true);
        insert testAccount;
        Phoenix_Bid_Fee_Master__c fee = new Phoenix_Bid_Fee_Master__c(Phoenix_Preferred_Wholesaler__c = 'ABC', Phoenix_Product_Type_for_CM_Fee__c = 'Special Product', Phoenix_Customer_Type__c = 'Govt business', Phoenix_Fee__c = 10.25);
        insert fee;
        list < Product2 > prodlist = new list < Product2 > ();
        Product2 prod1 = new Product2(Name = 'Test Product', Phoenix_Rx_SRx_OTC__c = 'Rx', Phoenix_Special_Product__c = true, Phoenix_GPI_Generic_Product_Identifier__c = '11111', Phoenix_NDC__c = '5511112200', Family = 'Test Family', Phoenix_Is_Exclude_Bid__c = false, IsActive = TRUE);
        Product2 prod2 = new Product2(Name = 'Test Product1', Phoenix_Rx_SRx_OTC__c = 'Rx', Phoenix_Special_Product__c = true, Phoenix_GPI_Generic_Product_Identifier__c = '22222', Phoenix_NDC__c = '43598855300', Family = 'Sample Family', Phoenix_Is_Exclude_Bid__c = false, IsActive = TRUE);
        prodlist.add(prod1);
        prodlist.add(prod2);
        insert prodlist;
        system.debug('prodlist-prodlist------' + prodlist);
        list < string > ndcValues = new list < string > ();
        ndcValues.add('43598855300');
        ndcValues.add('5511112200');
        list < Product2 > plist = [select id, Phoenix_NDC_11__c from Product2 where Id IN: prodlist];
        system.debug('plist-------' + plist);
        list < Product2 > plist1 = [select id, Phoenix_NDC_11__c from Product2 where Phoenix_NDC_11__c =: ndcValues];
        system.debug('plist1-------' + plist1);
        
        Phoenix_Bid__c bid = new Phoenix_Bid__c();
        bid.Phoenix_Bid_Type__c = 'Customer Rebate Change';
        bid.Phoenix_Customer_Type__c = 'Econdisc';
        bid.Phoenix_Reference_Contracts__c = '123456789';
        bid.Phoenix_Customer__c = testAccount.Id;
        insert bid;
        
        
        Phoenix_Bid_Line_Item__c bl = new Phoenix_Bid_Line_Item__c();
        bl.Phoenix_Bid__c = bid.Id;
        bl.Phoenix_Current_Direct_Price__c = 10;
        bl.Phoenix_Product_Code1__c = '300029858';
        bl.Phoenix_Product_Family1__c = 'Daptomycin Inj 500mg US';
        bl.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        bl.Phoenix_Proposed_Direct_Selling_Unit__c = 60;
        bl.Phoenix_Proposed_Indirect_Selling_Unit__c = 65;
        bl.Phoenix_Product__c = prodlist[0].Id;
        //bl.Phoenix_Final_Status__c='Approved';
        bl.Phoenix_SCM_Approval_Y_N__c = 'Y- Only Current Monthly Demand Approved';
        bl.Phoenix_Marketing_Final_Approval__c = true;
        insert bl;
        Pheonix_AddQuoteLineItemsController.fieldWrapper fw = new Pheonix_AddQuoteLineItemsController.fieldWrapper();
        Pheonix_AddQuoteLineItemsController.returnWrapper rw = new Pheonix_AddQuoteLineItemsController.returnWrapper();
        
        fw.UPC = prodlist[0].Phoenix_UPC_Universal_Product_Code__c;
        fw.Proposed_direct_Selling_Unit = string.valueOf(bl.Phoenix_Proposed_Direct_Selling_Unit__c);
        fw.Proposed_Indirect_Selling_Unit = string.valueOf(bl.Phoenix_Proposed_Indirect_Selling_Unit__c);
        fw.NDC11 = prodlist[0].Phoenix_NDC_11__c;
        
        
        
        
        
        
        String st = '[{"NDC11":"55111012205","UPC":"","Proposed_direct_Selling_Unit":"22","Proposed_Indirect_Selling_Unit":""},{"NDC11":"43598085530","UPC":"","Proposed_direct_Selling_Unit":"23","Proposed_Indirect_Selling_Unit":""}]';
        Pheonix_AddQuoteLineItemsController.bidcountrecords(st, bid.Id, 2);
        list < string > selectrcs = new list < string > ();
        selectrcs.add('selectrcs');
        Pheonix_AddQuoteLineItemsController.insersuccesslist(st, bid.Id, selectrcs, 2, 2, 0);
        String stfrmt = '[{"NDC11":"12345678902","UPC":"1234567","Proposed_direct_Selling_Unit":"","Proposed_Indirect_Selling_Unit":"null"},{"NDC11":"","UPC":"648742818","Proposed_direct_Selling_Unit":"","Proposed_Indirect_Selling_Unit":"null"}]';
        Pheonix_AddQuoteLineItemsController.insersuccesslist(stfrmt, bid.Id, selectrcs, 2, 1, 2);
        
    }
    static testMethod void test3() {
        Account testAccount = new Account(Name = 'Test Account', Phoenix_Preferred_Wholesaler__c = 'ABC', Phoenix_Is_Govt_Customer__c = true);
        insert testAccount;
        Phoenix_Bid_Fee_Master__c fee = new Phoenix_Bid_Fee_Master__c(Phoenix_Preferred_Wholesaler__c = 'ABC', Phoenix_Product_Type_for_CM_Fee__c = 'Special Product', Phoenix_Customer_Type__c = 'Govt business', Phoenix_Fee__c = 10.25);
        insert fee;
        list < Product2 > prodlist = new list < Product2 > ();
        Product2 prod1 = new Product2(Name = 'Test Product', Phoenix_Rx_SRx_OTC__c = 'Rx', Phoenix_Special_Product__c = true, Phoenix_NDC_11__c = '12345678902', Phoenix_UPC_Universal_Product_Code__c = '1234567', Phoenix_GPI_Generic_Product_Identifier__c = '11111', Family = 'Test Family', Phoenix_Is_Exclude_Bid__c = false, IsActive = TRUE);
        Product2 prod2 = new Product2(Name = 'Test Product1', Phoenix_Rx_SRx_OTC__c = 'Rx', Phoenix_Special_Product__c = true, Phoenix_UPC_Universal_Product_Code__c = '648742818', Phoenix_GPI_Generic_Product_Identifier__c = '22222', Family = 'Sample Family', Phoenix_Is_Exclude_Bid__c = false, IsActive = TRUE);
        prodlist.add(prod1);
        prodlist.add(prod2);
        insert prodlist;
        system.debug('prodlist-prodlist------' + prodlist);
        list < string > ndcValues = new list < string > ();
        ndcValues.add('1234567');
        ndcValues.add('648742818');
        list < Product2 > plist = [select id, Phoenix_NDC_11__c from Product2 where Id IN: prodlist];
        system.debug('plist-------' + plist);
        list < Product2 > plist1 = [select id, Phoenix_NDC_11__c from Product2 where Phoenix_UPC_Universal_Product_Code__c =: ndcValues];
        system.debug('plist1-------' + plist1);
        
        Phoenix_Bid__c bid = new Phoenix_Bid__c();
        bid.Phoenix_Bid_Type__c = 'Customer Rebate Change';
        bid.Phoenix_Customer_Type__c = 'Econdisc';
        bid.Phoenix_Customer__c = testAccount.Id;
        insert bid;
        
        
        Phoenix_Bid_Line_Item__c bl = new Phoenix_Bid_Line_Item__c();
        bl.Phoenix_Bid__c = bid.Id;
        bl.Phoenix_Current_Direct_Price__c = 10;
        bl.Phoenix_Product_Code1__c = '300029858';
        bl.Phoenix_Product_Family1__c = 'Daptomycin Inj 500mg US';
        bl.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        bl.Phoenix_Proposed_Direct_Selling_Unit__c = 60;
        bl.Phoenix_Proposed_Indirect_Selling_Unit__c = 65;
        bl.Phoenix_Product__c = prodlist[0].Id;
        //bl.Phoenix_Final_Status__c='Approved';
        bl.Phoenix_SCM_Approval_Y_N__c = 'Y- Only Current Monthly Demand Approved';
        bl.Phoenix_Marketing_Final_Approval__c = true;
        insert bl;
        Pheonix_AddQuoteLineItemsController.fieldWrapper fw = new Pheonix_AddQuoteLineItemsController.fieldWrapper();
        Pheonix_AddQuoteLineItemsController.returnWrapper rw = new Pheonix_AddQuoteLineItemsController.returnWrapper();
        
        fw.UPC = prodlist[0].Phoenix_UPC_Universal_Product_Code__c;
        fw.Proposed_direct_Selling_Unit = string.valueOf(bl.Phoenix_Proposed_Direct_Selling_Unit__c);
        fw.Proposed_Indirect_Selling_Unit = string.valueOf(bl.Phoenix_Proposed_Indirect_Selling_Unit__c);
        fw.NDC11 = prodlist[0].Phoenix_NDC_11__c;
        
        
        
        
        
        
        String st = '[{"NDC11":"12345678902","UPC":"1234567","Proposed_direct_Selling_Unit":"22","Proposed_Indirect_Selling_Unit":""},{"NDC11":"","UPC":"648742818","Proposed_direct_Selling_Unit":"23","Proposed_Indirect_Selling_Unit":""}]';
        Pheonix_AddQuoteLineItemsController.bidcountrecords(st, bid.Id, 2);
        list < string > selectrcs = new list < string > ();
        selectrcs.add('selectrcs');
        Pheonix_AddQuoteLineItemsController.insersuccesslist(st, bid.Id, selectrcs, 2, 1, 2);
        
    }
    
    static testmethod void AddProductMethod4() {
        Id phoenixRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Bid Accounts').getRecordTypeId();
        Account testAccount = new Account(Name = 'Test Account', Phoenix_Preferred_Wholesaler__c = 'ABC', Phoenix_Is_Govt_Customer__c = true);
        insert testAccount;
        list < Product2 > prodList = new list < Product2 > ();
        Product2 prod1 = new Product2(Name = 'Test Product', Phoenix_Rx_SRx_OTC__c = 'Rx', Phoenix_Special_Product__c = true, Phoenix_GPI_Generic_Product_Identifier__c = '11111', Phoenix_NDC_11__c = '12345678902', Family = 'Test Family', IsActive = TRUE);
        Product2 prod2 = new Product2(Name = 'Test Product1', Phoenix_Rx_SRx_OTC__c = 'Rx', Phoenix_Special_Product__c = true, Phoenix_GPI_Generic_Product_Identifier__c = '22222', Phoenix_NDC_11__c = '21345678902', Family = 'Sample Family', IsActive = TRUE);
        Product2 prod3 = new Product2(Name = 'Test Product2', Phoenix_Rx_SRx_OTC__c = 'SRx', Phoenix_Special_Product__c = true, Phoenix_NDC_11__c = '32145678902', Family = ' cetirizine', IsActive = TRUE);
        Product2 prod4 = new Product2(Name = 'Test Product3', Phoenix_Rx_SRx_OTC__c = 'OTC', Phoenix_Special_Product__c = true, Phoenix_GPI_Generic_Product_Identifier__c = '333333', Family = ' cetirizine', IsActive = TRUE);
        
        prodList.add(prod1);
        prodList.add(prod2);
        prodList.add(prod3);
        prodList.add(prod4);
        insert prodList;
        
        Phoenix_Bid__c pb = new Phoenix_Bid__c();
        pb.Phoenix_Status__c = 'New';
        pb.Phoenix_Bid_Type__c = 'IPA Floor Pricing Update';
        pb.Phoenix_Comments__c = 'Test Comments';
        pb.Phoenix_Customer_Type__c = 'ROS';
        pb.Phoenix_Customer__c = testAccount.Id;
        insert pb;
        
        
        Account testBidAccount = new Account(Name = 'TestBid Account', Phoenix_Preferred_Wholesaler__c = 'ABC',Phoenix_Customer_Class_Bid_Template__c='Base/DSH', Phoenix_Is_Govt_Customer__c = true);
        insert testBidAccount; 
        Phoenix_Bid__c testBid = new Phoenix_Bid__c();
        testBid.Phoenix_Status__c = 'New';
        testBid.Phoenix_Comments__c = 'Test Comments';
        testBid.Phoenix_Bid_Type__c = 'Price Change';
        testBid.Phoenix_Customer__c = testBidAccount.Id;
        insert testBid;
        
        
        list < Phoenix_Bid_Line_Item__c > lineItemsList1 = new list < Phoenix_Bid_Line_Item__c > ();
        Phoenix_Bid_Line_Item__c pbl1=new Phoenix_Bid_Line_Item__c();
        pbl1.Phoenix_Bid__c=testBid.Id;
        pbl1.Phoenix_Product__c = prod1.id;
        lineItemsList1.add(pbl1);
        Phoenix_Bid_Line_Item__c pbl2=new Phoenix_Bid_Line_Item__c();
        pbl2.Phoenix_Bid__c=testBid.Id;
        pbl2.Phoenix_Product__c = prod2.id;
        lineItemsList1.add(pbl2);
        insert lineItemsList1;
        
        
        Phoenix_BidCreatorCtrl.BidWrapper pbWrapper = new Phoenix_BidCreatorCtrl.BidWrapper();
        pbWrapper = Pheonix_AddQuoteLineItemsController.getBidInfo(pb.Id);
        
        Phoenix_BidCreatorCtrl.BidWrapper pbWrapper1 = new Phoenix_BidCreatorCtrl.BidWrapper();
        pbWrapper1.bid = pb;
        pbWrapper1.isBidCreated = true;
        Pheonix_AddQuoteLineItemsController.getproducts1(pbWrapper1);
        Pheonix_AddQuoteLineItemsController.getContracts(null, 'test','ROS');
        Phoenix_Bid_Fee_Master__c fee = new Phoenix_Bid_Fee_Master__c(Phoenix_Preferred_Wholesaler__c = 'ABC', Phoenix_Product_Type_for_CM_Fee__c = 'Special Product', Phoenix_Customer_Type__c = 'Govt business', Phoenix_Fee__c = 10.25);
        insert fee;
        
        list < Phoenix_BidCreatorCtrl.wrapperClass > wrap = new list < Phoenix_BidCreatorCtrl.wrapperClass > ();
        list < string > productIds = new list < string > ();
        for (Integer i = 0; i < prodList.size(); i++) {
            Phoenix_BidCreatorCtrl.wrapperClass pbw = new Phoenix_BidCreatorCtrl.wrapperClass();
            pbw.prdlist = prodList[i];
            pbw.isSelected = true;
            pbw.currencyCode = '$';
            wrap.add(pbw);
            productIds.add(prodList[i].Id);
            
        }
        string search = 'test';
        string searchFamily = 'test';
        list < string > RxSrxList = new list < string > ();
        RxSrxList.add('Rx');
        list < string > directorList = new list < string > ();
        directorList.add('Suseela Dhruvsoft');
        string searchNDC = '12345678902 21345678902';
        //Pheonix_AddQuoteLineItemsController.finalSearchResult(wrap, directorList, search, searchFamily, RxSrxList, pbWrapper1);
        RxSrxList.add('SRx');
        //Pheonix_AddQuoteLineItemsController.finalSearchResult(wrap, directorList, '333333', searchFamily, RxSrxList, pbWrapper1);
        //Pheonix_AddQuoteLineItemsController.finalSearchResult(wrap, directorList, searchNDC, searchFamily, RxSrxList, pbWrapper1);
        //Pheonix_AddQuoteLineItemsController.findBySrxOtc(RxSrxList, directorList, search, searchFamily, wrap, pbWrapper1);
       // Pheonix_AddQuoteLineItemsController.finalSearchResult(wrap, directorList, searchFamily, search, RxSrxList, pbWrapper1);
       // Pheonix_AddQuoteLineItemsController.finalSearchResult(wrap, directorList, searchFamily, search, RxSrxList, pbWrapper1);
        Pheonix_AddQuoteLineItemsController.getProductDirectorList(pbWrapper1);
        Pheonix_AddQuoteLineItemsController.showselectedProducts(pb.Id);
        Pheonix_AddQuoteLineItemsController.getContractProducts(pbWrapper1, new list < Id > {});
        //Pheonix_AddQuoteLineItemsController.getproductsForSelectedCnts(pbWrapper1,productIds);
        
        
        list < Phoenix_BidCreatorCtrl.wrapperClass > wrap1 = new list < Phoenix_BidCreatorCtrl.wrapperClass > ();
        list < Phoenix_Bid_Line_Item__c > lineItemsList = new list < Phoenix_Bid_Line_Item__c > ();
        for (Integer i = 0; i < prodList.size(); i++) {
            Phoenix_BidCreatorCtrl.wrapperClass pbw = new Phoenix_BidCreatorCtrl.wrapperClass();
            Phoenix_Bid_Line_Item__c pbl = new Phoenix_Bid_Line_Item__c(Phoenix_Bid__c = pb.Id);
            pbw.qlItem = pbl;
            pbw.prdlist = prodList[i];
            wrap1.add(pbw);
        }
        list < string > selectrcs = new list < string > ();
        selectrcs.add('selectrcs');
        Pheonix_AddQuoteLineItemsController.savequoteitems(wrap1, pbWrapper1, selectrcs);
        Pheonix_AddQuoteLineItemsController.fetchSortResults('Name', true, wrap);
        
    }
    
    
    static testmethod void AddProductMethod6() {
        Id phoenixRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Bid Accounts').getRecordTypeId();
        Account testAccount = new Account(Name = 'Test Account', Phoenix_Preferred_Wholesaler__c = 'ABC', Phoenix_Is_Govt_Customer__c = true);
        insert testAccount;
        Phoenix_Bid__c pb = new Phoenix_Bid__c();
        pb.Phoenix_Status__c = 'New';
        pb.Phoenix_Bid_Type__c = 'Direct Order Form Pricing Update';
        pb.Phoenix_Comments__c = 'Test Comments';
        pb.Phoenix_Customer__c = testAccount.Id;
        insert pb;
    }  
    
    static testmethod void AddProductMethod7() {
        Id phoenixRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Bid Accounts').getRecordTypeId();
        Account testAccount = new Account(Name = 'Test Account', Phoenix_Preferred_Wholesaler__c = 'ABC', Phoenix_Is_Govt_Customer__c = true);
        insert testAccount;
        Phoenix_Bid__c pb = new Phoenix_Bid__c();
        pb.Phoenix_Status__c = 'New';
        pb.Phoenix_Bid_Type__c = 'VIP Rebate';
        pb.Phoenix_Comments__c = 'Test Comments';
        pb.Phoenix_Customer__c = testAccount.Id;
        insert pb;
    }  
    static testmethod void AddProductMethod8() {
        Id phoenixRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Bid Accounts').getRecordTypeId();
        Account testAccount = new Account(Name = 'Test Account', Phoenix_Preferred_Wholesaler__c = 'ABC', Phoenix_Is_Govt_Customer__c = true);
        insert testAccount;
        Phoenix_Bid__c pb = new Phoenix_Bid__c();
        pb.Phoenix_Status__c = 'New';
        pb.Phoenix_Bid_Type__c = 'RFP Bids';
        pb.Phoenix_Comments__c = 'Test Comments';
        pb.Phoenix_Customer__c = testAccount.Id;
        insert pb;
    }  
    
    static testmethod void AddProductMethod9() {
        Id phoenixRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Bid Accounts').getRecordTypeId();
        Account testAccount = new Account(Name = 'Test Account', Phoenix_Preferred_Wholesaler__c = 'ABC', Phoenix_Is_Govt_Customer__c = true,Phoenix_VIP__c=2,Phoenix_Fee__c=5,Phoenix_Cash_Discount__c=4);
        insert testAccount;
        Phoenix_Bid__c pb = new Phoenix_Bid__c();
        pb.Phoenix_Status__c = 'New';
        pb.Phoenix_Bid_Type__c = 'Short Dated OTB';
        pb.Phoenix_Comments__c = 'Test Comments';
        pb.Phoenix_Customer__c = testAccount.Id;
        insert pb;
    }  
}