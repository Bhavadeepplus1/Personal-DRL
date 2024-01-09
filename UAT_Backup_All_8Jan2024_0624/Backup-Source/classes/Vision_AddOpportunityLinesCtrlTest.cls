@isTest
public class Vision_AddOpportunityLinesCtrlTest {
    static testmethod void AddProductMethod() {
        Id phoenixRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Bid Accounts').getRecordTypeId();
        Account testAccount = new Account(Name = 'Test Account', Phoenix_Preferred_Wholesaler__c = 'ABC', Phoenix_Is_Govt_Customer__c = true);
        insert testAccount;
        
        Opportunity pb = new Opportunity();
        pb.Name = 'Test Record';
        pb.Vsion_Status__c = 'Opportunity in progress';
        pb.Bid_Type__c = 'RFP';  
        pb.Vision_Comments__c = 'Test Comments';
        pb.AccountId = testAccount.Id;
        pb.StageName = 'Opportunity in progress';
        pb.CloseDate = Date.valueOf('2020-01-01');
        
        
        
        
        //pb.Phoenix_Customer_Type__c='Econdisc';
        insert pb;
        
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
        
        list < Product_Opportunity__c > prodoptyList = new list < Product_Opportunity__c > ();
        list < Product_Opportunity__c > matchprodoptyList = new list < Product_Opportunity__c > ();
        list < Product_Opportunity__c > unmatchprodoptyList = new list < Product_Opportunity__c > ();
        list < Product_Opportunity__c > unmatchprodoptyList2 = new list < Product_Opportunity__c > ();
        
        Product_Opportunity__c prodopty1 = new Product_Opportunity__c(Name = 'Test Product opty', 
                                                                      NDC_11__c = '12345678902', Product_Family__c = 'Test Family',
                                                                      GPI_Generic_Product_Identifier__c = '222222',Status__c = 'Matched',
                                                                      Opportunity__c=pb.Id
                                                                     );
        Product_Opportunity__c prodopty2 = new Product_Opportunity__c(Name = 'Test Product opty1', 
                                                                      GPI_Generic_Product_Identifier__c = '3444443',
                                                                      NDC_11__c = '21345678902', Product_Family__c = 'Sample Family',
                                                                      Status__c = 'Matched',Opportunity__c=pb.Id
                                                                     );
        Product_Opportunity__c prodopty3 = new Product_Opportunity__c(Name = 'Test Product opty2'
                                                                     );
        Product_Opportunity__c prodopty4 = new Product_Opportunity__c(Name = 'Test Product opty3'
                                                                     );
        Product_Opportunity__c prodopty5 = new Product_Opportunity__c(Name = 'Test Product opty5', Product__c = prod3.Id, Pkg_Size__c=25, GSN__c='666666', 
                                                                      Status__c = 'Unmatched', Opportunity__c=pb.Id, Vision_Opportunity_Value__c=10
                                                                     );
        Product_Opportunity__c prodopty6 = new Product_Opportunity__c(Name = 'Test Product opty6', Product__c = prod2.Id,Pkg_Size__c=25, 
                                                                      GSN__c='666666', Status__c = 'Unmatched',Vision_Alt_Pkg_Size__c=25,Vision_High_Pkg_Size__c=45,Opportunity__c=pb.Id, 
                                                                      Vision_Bid_on_Highest_Pack_Size__c = true, Vision_Bid_on_Alternative_Pack_Size__c = true, Dosage_Form__c = 'Tablets',
                                                                      Vision_Total_Annual_Units__c = 23455767, Vision_UOM__c = 'EU'
                                                                     );
        prodoptyList.add(prodopty1);
        prodoptyList.add(prodopty2);
        prodoptyList.add(prodopty3);
        prodoptyList.add(prodopty4);
        prodoptyList.add(prodopty5);
        prodoptyList.add(prodopty6);
        insert prodoptyList;
        Map<Id, Product_Opportunity__c> prdOptyMap = new Map<Id, Product_Opportunity__c>{prodopty5.Id => prodopty5,prodopty6.Id=>prodopty6 };
            
            matchprodoptyList.add(prodopty1);
        matchprodoptyList.add(prodopty2);
        
        unmatchprodoptyList.add(prodopty3);
        unmatchprodoptyList.add(prodopty4);
        
        unmatchprodoptyList2.add(prodopty5);
        unmatchprodoptyList2.add(prodopty6);
        
        String matchRecs = JSON.serialize(matchprodoptyList);
        String unMatchRecs = JSON.serialize(unmatchprodoptyList);
        String unMatchRecs2 = JSON.serialize(unmatchprodoptyList2);
        
        
        
        
        Account testBidAccount = new Account(Name = 'TestBid Account', Phoenix_Preferred_Wholesaler__c = 'ABC',Phoenix_Customer_Class_Bid_Template__c='Base/DSH', Phoenix_Is_Govt_Customer__c = true);
        insert testBidAccount; 
        Opportunity testBid = new Opportunity();
        testBid.Name = 'Test Record 2';
        testBid.Vsion_Status__c = 'Opportunity in progress';
        testBid.Vision_Comments__c = 'Test Comments';
        testBid.AccountId = testBidAccount.Id;
        testBid.StageName = 'Opportunity in progress';
        testBid.CloseDate = Date.valueOf('2020-01-01');
        
        insert testBid;
        
        
        list < Product_Opportunity__c > lineItemsList1 = new list < Product_Opportunity__c > ();
        Product_Opportunity__c pbl1=new Product_Opportunity__c();
        pbl1.Opportunity__c=testBid.Id;
        pbl1.Product__c = prod1.id;
        pbl1.Contract_Management_Fee_Wholesaler__c=2;
        lineItemsList1.add(pbl1);
        Product_Opportunity__c pbl2=new Product_Opportunity__c();
        pbl2.Opportunity__c=testBid.Id;
        pbl2.Contract_Management_Fee_Wholesaler__c=2;
        pbl2.Product__c = prod2.id;
        lineItemsList1.add(pbl2);
        insert lineItemsList1;
        
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
        pb1.Phoenix_Internal_Target_Date__c = system.Date.today();
        insert pb1;
        
        
        Vision_OpportunityCreatorCtrl.BidWrapper pbWrapper = new Vision_OpportunityCreatorCtrl.BidWrapper();
        //pbWrapper = Pheonix_AddQuoteLineItemsController.getBidInfo(pb.Id);
        
        Vision_OpportunityCreatorCtrl.BidWrapper pbWrapper1 = new Vision_OpportunityCreatorCtrl.BidWrapper();
        pbWrapper1.oppty = pb;
        pbWrapper1.isBidCreated = true;
        //Pheonix_AddQuoteLineItemsController.getproducts1(pbWrapper1);
        // Pheonix_AddQuoteLineItemsController.getContracts(null, 'test');
        //Phoenix_Bid_Fee_Master__c fee = new Phoenix_Bid_Fee_Master__c(Phoenix_Preferred_Wholesaler__c = 'ABC', Phoenix_Product_Type_for_CM_Fee__c = 'Special Product', Phoenix_Customer_Type__c = 'Govt business', Phoenix_Fee__c = 10.25);
        //insert fee;
        
        list < Vision_OpportunityCreatorCtrl.wrapperClass > wrap = new list < Vision_OpportunityCreatorCtrl.wrapperClass > ();
        list < string > productIds = new list < string > ();
        for (Integer i = 0; i < prodList.size(); i++) {
            Vision_OpportunityCreatorCtrl.wrapperClass pbw = new Vision_OpportunityCreatorCtrl.wrapperClass();
            pbw.prdlist = prodList[i];
            pbw.isSelected = true;
            pbw.currencyCode = '$';
            wrap.add(pbw);
            productIds.add(prodList[i].Id);
            
        }
        Opportunity bid = new Opportunity();
        bid.Name = 'Test Record 323';
        bid.Bid_Type__c = 'Price Change';
        //bid.Phoenix_Customer_Type__c = 'ROS';
        bid.AccountId = testAccount.Id;
        bid.StageName = 'Opportunity in progress';
        bid.CloseDate = Date.valueOf('2020-01-01');
        insert bid;
        string search = 'test';
        string searchFamily = 'test';
        list < string > RxSrxList = new list < string > ();
        RxSrxList.add('Rx');
        list < string > directorList = new list < string > ();
        directorList.add('Suseela Dhruvsoft');
        string searchNDC = '12345678902 21345678902';
        //Pheonix_AddQuoteLineItemsController.
        RxSrxList.add('SRx');
        Vision_AddOpportunityLinesCtrl.getBidInfo(pb.Id);
        Vision_AddOpportunityLinesCtrl.getSearch(wrap, directorList, search, searchFamily, RxSrxList, pbWrapper1);
        Vision_AddOpportunityLinesCtrl.getsearchDirectorResult(wrap, directorList, searchFamily, search, RxSrxList, pbWrapper1);
        Vision_AddOpportunityLinesCtrl.getSearchFamily(wrap, directorList, searchFamily, search, RxSrxList, pbWrapper1);
        Vision_AddOpportunityLinesCtrl.getproducts1(pbWrapper1);
        Vision_AddOpportunityLinesCtrl.showselectedProducts(pb.Id);
        Vision_AddOpportunityLinesCtrl.getProductDirectorList(pbWrapper1);
        list < Vision_OpportunityCreatorCtrl.wrapperClass > wrap1 = new list < Vision_OpportunityCreatorCtrl.wrapperClass > ();
        list < Product_Opportunity__c > lineItemsList = new list < Product_Opportunity__c > ();
        for (Integer i = 0; i < prodList.size(); i++) {
            Vision_OpportunityCreatorCtrl.wrapperClass pbw = new Vision_OpportunityCreatorCtrl.wrapperClass();
            Product_Opportunity__c pbl = new Product_Opportunity__c(Opportunity__c = pb.Id);
            pbw.qlItem = pbl;
            pbw.prdlist = prodList[i];
            wrap1.add(pbw);
        }
        Phoenix_Contract__c Cntrct1 = new Phoenix_Contract__c();
        Cntrct1.name = 'taest cntrct 1';
        Cntrct1.Phoenix_Contract_Number__c = '223';
        insert Cntrct1;
        Phoenix_Contract__c Cntrct2 = new Phoenix_Contract__c();
        Cntrct2.name = 'taest cntrct 2';
        Cntrct2.Phoenix_Contract_Number__c = '223';
        insert Cntrct2;
        Phoenix_Contract__c Cntrct3 = new Phoenix_Contract__c();
        Cntrct3.name = 'taest cntrct 3';
        Cntrct3.Phoenix_Contract_Number__c = '223';
        
        
        
        Opportunity opp3 = new Opportunity();
        opp3.Name = 'Test Record 1';
        opp3.Vsion_Status__c = 'Opportunity in progress';
        opp3.Bid_Type__c = 'Product Addition';  
        opp3.Vision_Comments__c = 'Test Comments';
        opp3.AccountId = testAccount.Id;
        opp3.Vision_Bid_Template__c='Econdisc';
        opp3.StageName = 'Opportunity in progress';
        opp3.CloseDate = Date.valueOf('2020-01-01');
        
        list<Vision_OpportunityCreator.prdwrapperClass> prList = new list<Vision_OpportunityCreator.prdwrapperClass>();
        Vision_OpportunityCreator.prdwrapperClass pr = new Vision_OpportunityCreator.prdwrapperClass();
        pr.guidancePriceVal = '23';
        pr.competitorIdVal='';
        pr.contrFlag=true;
        pr.currencyCode='$';
        pr.currentDirectPrice=20;
        pr.currentDirectUnits=30;
        pr.currentIndirectPrice=45;
        pr.currentIndirectUnits=24;
        pr.currentRebatePer=23;
        pr.financialImpact=24;
        pr.incumbentCompId1='23';
        pr.incumbentCompId2='45';
        pr.incumbentCompId3='45';
        pr.incumbentCompId4='45';
        pr.incumbentCompId5='45';
        pr.isSelected=true;
        pr.opportunityVal='23';
        pr.prdlist=prod4;
        pr.priceRange1='23';
        pr.priceRange2='23';
        pr.priceRange3='23';
        pr.priceRange4='23';
        pr.priceRange5='23';
        pr.priceRangeVal='24';
        pr.proposedDirectUnits=245;
        pr.proposedUnitsVal='234';
        pr.salesPriceVal='23234';
        prList.add(pr);
        List<String> contractIds = new List<String>{Cntrct1.Id, Cntrct2.Id, Cntrct3.Id};
            list<Vision_OpportunityCreator.prdwrapperClass> optyProdList = new list<Vision_OpportunityCreator.prdwrapperClass>();
        
        
        Vision_AddOpportunityLinesCtrl.savequoteitems(wrap1, pbWrapper1, contractIds);
        Vision_AddOpportunityLinesCtrl.fetchSortResults('Name', true, wrap);
       // Vision_AddOpportunityLinesCtrl.findBySrxOtc(RxSrxList, directorList, search, searchFamily, wrap, pbWrapper1);
       // List < Vision_OpportunityCreatorCtrl.wrapperClass > pItem, list < string > SearchKeyWordPD, string search, string family, list < string > RxSrxList, Vision_OpportunityCreatorCtrl.BidWrapper quotewrap
        Vision_AddOpportunityLinesCtrl.getContracts(testAccount.Id,'test', 'ROS');
        Vision_AddOpportunityLinesCtrl.getContractProducts(pbWrapper1, new list < Id > {});
        String st = '[{"NDC11":"12345678902","UPC":"1234567","Proposed_direct_Selling_Unit":"","Proposed_Indirect_Selling_Unit":"null"},{"NDC11":"","UPC":"648742818","Proposed_direct_Selling_Unit":"","Proposed_Indirect_Selling_Unit":"null"}]';
        Vision_AddOpportunityLinesCtrl.bidcountrecords(st, bid.Id, 2);
        Vision_AddOpportunityLinesCtrl.insersuccesslist(st, pb1.Id, contractIds, 2, 1, 2);
        Vision_AddOpportunityLinesCtrl.getCompetitorInfo();
        Vision_AddOpportunityLinesCtrl.saveOptyProductsManual(JSON.serialize(opp3), prList, contractIds);
        Vision_AddOpportunityLinesCtrl.saveOptyExtProductsManual(JSON.serialize(bid.Id), JSON.serialize(prodoptyList));
        //Vision_AddOpportunityLinesCtrl.getTemplateFromAcc(JSON.serialize(testAccount.Id));
        //Vision_AddOpportunityLinesCtrl.coverageBlock();
        //Vision_AddOpportunityLinesCtrl.saveProductsToExtOpty(JSON.serialize(opp3), prList, contractIds);
        //Vision_AddOpportunityLinesCtrl.getCompetitorInfoObjData('string','string');
        Vision_AddOpportunityLinesCtrl.getTemplateFromAcc(testAccount.Id);
        Vision_AddOpportunityLinesCtrl.getNPRdata(testAccount.Id,contractIds,optyProdList);
    }
    
}