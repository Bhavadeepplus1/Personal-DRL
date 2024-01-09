@isTest
public class Vision_OpportunityCreatorTest {
    static testmethod void AddProductMethod() {
        Account parentAccount = new Account(Name = 'Walgreen Company',Phoenix_Local_VIP__c=12.2, Phoenix_Preferred_Wholesaler__c = 'McKesson', Phoenix_Is_Govt_Customer__c = true,Phoenix_Is_Bid_Account__c=true,Phoenix_Customer_Class_Bid_Template__c='Direct and Indirect');
        insert parentAccount;
        Account testAccount = new Account(Name = 'Walgreen Company', ParentId= parentAccount.Id, Phoenix_Local_VIP__c=12.2,Phoenix_Preferred_Wholesaler__c = 'Cardinal', Phoenix_Is_Govt_Customer__c = true,Phoenix_Is_Bid_Account__c=true,Phoenix_Customer_Class_Bid_Template__c='Direct and Indirect');
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
        pb.Phoenix_Bid_Type__c = 'WAC Change Submissions';
        pb.Phoenix_Approval_Status__c = 'Draft';
        pb.Phoenix_Internal_Target_Date__c = system.Date.today();
        pb.Phoenix_Customer_Type__c='ROS';
        insert pb;
        
        Opportunity opp = new Opportunity(); 
        opp.Name = 'Test Record';
        opp.Vsion_Status__c = 'Opportunity in progress';
        opp.Bid_Type__c = 'Product Addition';  
        opp.Vision_Comments__c = 'Test Comments';
        opp.AccountId = testAccount.Id;
        opp.Vision_Bid_Template__c='Indirect';
        opp.CloseDate=System.today();
        opp.StageName='Closed Lost';
        opp.Vision_Reference_Contract__c='123';
        //pb.Phoenix_Customer_Type__c='Econdisc';
        insert opp;
        
        Opportunity opp1 = new Opportunity();
        opp1.Name = 'Test Record 1';
        opp1.Vsion_Status__c = 'Opportunity in progress';
        opp1.Bid_Type__c = 'Product Addition';  
        opp1.Vision_Comments__c = 'Test Comments';
        opp1.AccountId = testAccount.Id;
        opp1.Vision_Bid_Template__c='Direct';
        //pb.Phoenix_Customer_Type__c='Econdisc';
        opp1.CloseDate=System.today();
        opp1.StageName='Closed Lost';
        opp1.Vision_Reference_Contract__c='223';
        insert opp1;
        
        Opportunity opp2 = new Opportunity();
        opp2.Name = 'Test Record 1';
        opp2.Vsion_Status__c = 'Opportunity in progress';
        opp2.Bid_Type__c = 'Product Addition';  
        opp2.Vision_Comments__c = 'Test Comments';
        opp2.AccountId = testAccount.Id;
        opp2.Vision_Bid_Template__c='Econdisc';
        opp2.CloseDate=System.today();
        opp2.StageName='Closed Lost';
        opp2.Vision_Reference_Contract__c='223';
        insert opp2;
        
        Opportunity opp3 = new Opportunity();
        opp3.Name = 'Test Record 1';
        opp3.Vsion_Status__c = 'Opportunity in progress';
        opp3.Bid_Type__c = 'Product Addition';  
        opp3.Vision_Comments__c = 'Test Comments';
        opp3.AccountId = testAccount.Id;
        opp3.Vision_Bid_Template__c='Econdisc';
        opp3.Vision_Reference_Contract__c='223';
        opp3.CloseDate=System.today();
        opp3.StageName='Closed Lost';
        
        
        Attachment attach=new Attachment();   	
        attach.Name='Test Attachment';
        Blob bodyBlob2=Blob.valueOf('Test Attachment Body');
        attach.body=bodyBlob2;
        attach.parentId=opp.Id;
        insert attach;
        
        list < Product2 > prodList = new list < Product2 > ();
        Product2 prod1 = new Product2(Name = 'Test Product', Phoenix_Rx_SRx_OTC__c = 'Rx', Phoenix_Special_Product__c = true, 
                                      Phoenix_GPI_Generic_Product_Identifier__c = '11111', Phoenix_NDC_11__c = '12345678902',
                                      Family = 'Test Family', IsActive = TRUE, 
                                      Phoenix_Throughput_cost__c=10.23456576,Phoenix_GCN_Generic_Code_Number__c = '44444',
                                      Phoenix_GCN_Sequence_Number__c='666666',Phoenix_Pkg_Size__c=25.0,ProductCode='123456'
                                     );
        Product2 prod2 = new Product2(Name = 'Test Product1', Phoenix_Rx_SRx_OTC__c = 'Rx', Phoenix_Special_Product__c = true, Phoenix_GPI_Generic_Product_Identifier__c = '22222',
                                      Phoenix_NDC_11__c = '21345678902', Family = 'Sample Family', IsActive = TRUE,Phoenix_GCN_Generic_Code_Number__c = '44444',
                                      Phoenix_Throughput_cost__c=10.23456576,Phoenix_Pkg_Size__c=25.0,Phoenix_GCN_Sequence_Number__c='666666',ProductCode='123456'
                                     );
        Product2 prod3 = new Product2(Name = 'Test Product2', Phoenix_Rx_SRx_OTC__c = 'SRx', Phoenix_Special_Product__c = true, 
                                      Phoenix_NDC_11__c = '32145678902', Family = ' cetirizine', IsActive = TRUE,
                                      Phoenix_Throughput_cost__c=10.23456576,Phoenix_Pkg_Size__c=25.0,ProductCode='123456'
                                     );
        Product2 prod4 = new Product2(Name = 'Test Product3', Phoenix_Rx_SRx_OTC__c = 'OTC', 
                                      Phoenix_Special_Product__c = true,
                                      Phoenix_GCN_Generic_Code_Number__c = '44444',
                                      Phoenix_GPI_Generic_Product_Identifier__c = '333333', 
                                      Family = ' cetirizine', IsActive = TRUE,Phoenix_Pkg_Size__c=25.0,
                                      Phoenix_GCN_Sequence_Number__c='666666',Phoenix_NDC_11__c='111111'
                                      ,Phoenix_Throughput_cost__c=10.23456576,ProductCode='123456',Phoenix_Lowest_Price_SKU__c=10.1,
                                      Description='test',Phoenix_Strength__c='test');
                Product2 prod5 = new Product2(Name = 'Test Product3', Phoenix_Rx_SRx_OTC__c = 'OTC', 
                                      Phoenix_Special_Product__c = true,
                                      Phoenix_GCN_Generic_Code_Number__c = '44444',
                                      Phoenix_GPI_Generic_Product_Identifier__c = '333333', 
                                      Family = ' cetirizine', IsActive = TRUE,Phoenix_Pkg_Size__c=25.0,
                                      Phoenix_GCN_Sequence_Number__c='666666',Phoenix_NDC_11__c='111111'
                                      ,Phoenix_Throughput_cost__c=10.23456576,ProductCode='123456',Phoenix_Lowest_Price_SKU__c=10.1,
                                      Description='test',Phoenix_Strength__c='test',Phoenix_Is_Exclude_Bid__c = false);
        
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
                                                                      NDC_11__c = '10', Product_Family__c = 'Test Family',Product__c = prod3.Id,Vision_Bid_on_Highest_Pack_Size__c = true,
                                                                      GPI_Generic_Product_Identifier__c = '222222',Status__c = 'Matched',SKU_Number__c='103',
                                                                      Is_NDC_Matched__c=true,GCN_Generic_Code_Number__c='10',
                                                                      Is_SKU_Matched__c=true,Is_GCN_Pack_Size_Matched__c=true,Pkg_Size__c=10,
                                                                      Vision_Total_Annual_Units__c = 23455767,vision_is_discrepancy_product__c=true,
                                                                      Opportunity__c=opp.Id,GSN__c='666666',Vision_Opportunity_Value__c=10,
                                                                      Is_GSN_Pack_Size_Matched__c=true,Vision_Is_Pack_Size_Provided__c=true,
                                                                      Vision_Is_NDC_Provided__c=true,Vision_Is_GCN_Provided__c=true,
                                                                      Vision_Is_SKU_Provided__c=true
                                                                     );
        Product_Opportunity__c prodopty2 = new Product_Opportunity__c(Name = 'Test Product opty1', 
                                                                      GPI_Generic_Product_Identifier__c = '3444443',SKU_Number__c='103',GSN__c='666666',Vision_Bid_on_Highest_Pack_Size__c = true,
                                                                      NDC_11__c = '10', Product_Family__c = 'Sample Family',Product__c = prod3.Id,
                                                                      vision_is_discrepancy_product__c=true, Is_NDC_Matched__c=true,GCN_Generic_Code_Number__c='10',
                                                                      Is_SKU_Matched__c=true,Is_GCN_Pack_Size_Matched__c=true,Pkg_Size__c=10,
                                                                      Status__c = 'Matched',Opportunity__c=opp.Id,Vision_Opportunity_Value__c=10,
                                                                      Is_GSN_Pack_Size_Matched__c=true,Vision_Is_Pack_Size_Provided__c=true,
                                                                      Vision_Is_NDC_Provided__c=true,Vision_Is_GCN_Provided__c=true,
                                                                      Vision_Is_SKU_Provided__c=true
                                                                     );
        Product_Opportunity__c prodopty3 = new Product_Opportunity__c(Name = 'Test Product opty2',Product__c = prod3.Id,
                                                                      vision_is_discrepancy_product__c=true,Opportunity__c=opp.Id,
                                                                       Is_GSN_Pack_Size_Matched__c=true,Vision_Is_Pack_Size_Provided__c=true,
                                                                      Vision_Is_NDC_Provided__c=true,Vision_Is_GCN_Provided__c=true,
                                                                      Vision_Is_SKU_Provided__c=true
                                                                     );
        Product_Opportunity__c prodopty4 = new Product_Opportunity__c(Name = 'Test Product opty3',Product__c = prod3.Id,
                                                                      vision_is_discrepancy_product__c=true,Opportunity__c=opp.Id,
                                                                       Is_GSN_Pack_Size_Matched__c=true,Vision_Is_Pack_Size_Provided__c=true,
                                                                      Vision_Is_NDC_Provided__c=true,Vision_Is_GCN_Provided__c=true,
                                                                      Vision_Is_SKU_Provided__c=true
                                                                     );
        Product_Opportunity__c prodopty5 = new Product_Opportunity__c(Name = 'Test Product opty5', Product__c = prod3.Id, Pkg_Size__c=25, GSN__c='666666', 
                                                                      Status__c = 'Unmatched', vision_is_discrepancy_product__c=true,
                                                                      Vision_Total_Annual_Units__c = 23455767,Opportunity__c=opp.Id, Vision_UOM__c = 'EA', Vision_Opportunity_Value__c=10
                                                                     );
        Product_Opportunity__c prodopty6 = new Product_Opportunity__c(Name = 'Test Product opty6', Product__c = prod2.Id,Pkg_Size__c=25, vision_is_discrepancy_product__c=true,
                                                                      GSN__c='666666', Status__c = 'Unmatched',Vision_Alt_Pkg_Size__c=25,Vision_High_Pkg_Size__c=45,Opportunity__c=opp.Id, 
                                                                      Vision_Bid_on_Highest_Pack_Size__c = true, Vision_Bid_on_Alternative_Pack_Size__c = true, Dosage_Form__c = 'Tablets',
                                                                      Vision_Total_Annual_Units__c = 23455767, Vision_UOM__c = 'EA',Vision_Opportunity_Value__c=10
                                                                     );
        Product_Opportunity__c prodopty7 = new Product_Opportunity__c(Name = 'Test Product opty7', Product__c = prod2.Id,Pkg_Size__c=25,vision_is_discrepancy_product__c=true, 
                                                                      GSN__c='777777', Status__c = 'Unmatched',Vision_Alt_Pkg_Size__c=25,Vision_High_Pkg_Size__c=45,Opportunity__c=opp.Id, 
                                                                      Vision_Bid_on_Highest_Pack_Size__c = true, Vision_Bid_on_Alternative_Pack_Size__c = true, Dosage_Form__c = 'Tablets',
                                                                      Vision_Total_Annual_Units__c = 23455767, Vision_UOM__c = 'EA',Vision_Opportunity_Value__c=10
                                                                     );
        Insert prodopty7;
        prodoptyList.add(prodopty1);
        prodoptyList.add(prodopty2);
        prodoptyList.add(prodopty3);
        prodoptyList.add(prodopty4);
        prodoptyList.add(prodopty5);
        prodoptyList.add(prodopty6);
        insert prodoptyList;
        
        Map<Id, Product_Opportunity__c> prdOptyMap = new Map<Id, Product_Opportunity__c>{prod3.Id => prodopty5,prod2.Id=>prodopty6 };
            
            matchprodoptyList.add(prodopty1);
        matchprodoptyList.add(prodopty2);
        
        unmatchprodoptyList.add(prodopty3);
        unmatchprodoptyList.add(prodopty4);
        
        unmatchprodoptyList2.add(prodopty5);
        unmatchprodoptyList2.add(prodopty6);
        
        String matchRecs = JSON.serialize(matchprodoptyList);
        String unMatchRecs = JSON.serialize(unmatchprodoptyList);
        String unMatchRecs2 = JSON.serialize(unmatchprodoptyList2);
        
        
        
        
        
        list<String> csvRecordsList2 = new list<String>{'GCN,GSN,GPI,NDC 11,SKU NUMBER,PRODUCT FAMILY,STRENGTH,DOSAGE FORM,PACK SIZE,PRODUCT DESCRIPTION,TOTAL ANNUAL UNITS,UOM,CUSTOMER COMMENTS,BID ON HIGHEST PACK SIZE,BID ON ALTERNATIVE PACK SIZE,GUIDANCE PRICE,PROPOSED OS UNITS,PROPOSED RAD UNITS,PROPOSED WMT UNITS,PROPOSED DIRECT UNITS,PROPOSED INDIRECT UNITS,PROPOSED SMITH DRUG UNITS,PROPOSED ANDA UNITS,PROPOSED DIRECT AHOLD/DELHAIZE UNITS,PROPOSED DIRECT GAINT EAGLE UNITS,PROPOSED TOTAL RETAIL INDIRECT UNITS,PROPOSED BASE UNITS,PROPOSED DSH UNITS,PROPOSED AUTOSUB UNITS,PROPOSED DIRECT ESI UNITS,PROPOSED INDIRECT ESI UNITS,PROPOSED DIRECT KROGER UNITS,PROPOSED INDIRECT KROGER UNITS,PROPOSED DIRECT RX OUTREACH UNITS,PROPOSED INDIRECT RX OUTREACH UNITS,PROPOSED DIRECT SUPERVALU UNITS,PROPOSED INDIRECT SUPERVALU UNITS,PROPOSED DIRECT CORDANT UNITS,PROPOSED INDIRECT CORDANT UNITS,PROPOSED DIRECT ACCERODO UNITS,PROPOSED INDIRECT ACCERODO UNITS,'};
            
            Map<String,Integer> headerMap = new Map<String,Integer>{'GCN'=> 0, 'GSN'=> 1, 'GPI'=> 2, 'ndc'=> 3, 'sku_num'=> 4, 'prd_family'=> 5, 
                'STRENGTH'=> 6, 'dosage_form'=> 7, 'pkg_size'=> 8, 'prd_desc'=> 9, 'tot_annual_units'=> 10,
                'UOM'=> 11, 'cus_cmt'=> 12, 'bid_on_highest_pkg_size'=> 13, 'bid_on_alternative_pkg_size' => 14,
                'pro_direct_gaint_units'=>10,'pro_total_retail_units'=>10,'pro_base_units'=>10,'pro_dsh_units'=>10,
                'pro_autosub_units'=>10,'pro_direct_esi_units'=>10,'pro_indirect_esi_units'=>10,'pro_direct_kroger_units'=>10,
                'pro_indirect_kroger_units'=>10,'pro_direct_rx_outreach_units'=>10,'pro_indirect_rx_outreach_units'=>10,
                'pro_direct_supervalu_units'=>10,'pro_indirect_supervalu_units'=>10,'pro_direct_cordant_units'=>10,'pro_indirect_cordant_units'=>10,
                'pro_indirect_cordant_units'=>10,'pro_direct_accerodo_units'=>10,'pro_indirect_accerodo_units'=>10  };
                    List<String> csvRecordData1 = new List<String>{'63915','2706','48991003101835','55111052230','300031164','ALMACONE-2 LIQUID','355.0','Injectable','355','ALMACONE-2 LIQUID','1,83,192','ML','BID LARGEST PKG SIZE AVAILABLE','NO','YES'};
                        List<String> csvRecordData2 = new List<String>{'14262','3775','57100010000315','55111019690','300028678','ALPRAZOLAM 1 MG TABLET','1000','Injectable','1000','ALPRAZOLAM 1 MG TABLET','35,87,458','TABLET','BID LARGEST PKG SIZE AVAILABLE','YES','NO'};
                            String csvLine = 'Test,Check,abc@abc.com, "19, Link road, A1SH10, India", companyName, "companyStreet, CompanyCity, CompanyCountry"';
        
        List<Attachment> attachments=[select id, name from Attachment where parent.Id=:opp.Id];
        Blob b1 = Blob.valueOf('GCN,GSN,GPI,NDC 11,SKU NUMBER,PRODUCT FAMILY,STRENGTH,DOSAGE FORM,PACK SIZE,PRODUCT DESCRIPTION,TOTAL ANNUAL UNITS,UOM,CUSTOMER COMMENTS,BID ON HIGHEST PACK SIZE,BID ON ALTERNATIVE PACK SIZE,GUIDANCE PRICE');
        Blob b2 = Blob.valueOf('63915,2706,48991003101835,55111052230,300031164,ALMACONE-2 LIQUID,355.0,Injectable,355,ALMACONE-2 LIQUID,1,83,192,ML,BID LARGEST PKG SIZE AVAILABLE,NO,YES,10');
        Blob b3 = Blob.valueOf('14262,3775,57100010000315,55111019690,300028678,ALPRAZOLAM 1 MG TABLET,1000,Injectable,1000,ALPRAZOLAM 1 MG TABLET,35,87,458,TABLET,BID LARGEST PKG SIZE AVAILABLE,YES,NO,11');
        
        String combinedDataAsHex = EncodingUtil.convertToHex(b1) + EncodingUtil.convertToHex(b2) + EncodingUtil.convertToHex(b3);
        Blob combinedDataAsBlob = EncodingUtil.convertFromHex(combinedDataAsHex);
        
        ContentVersion contentVersionInsert = new ContentVersion(
            Title = 'Test',
            PathOnClient = 'Test.csv',
            VersionData = combinedDataAsBlob,
            IsMajorVersion = true
        );
        
        insert contentVersionInsert;
        
        Account accA =new Account(Name='Walgreen Company');
        insert accA ; 
        Opportunity opt = new Opportunity(Name='test opp',StageName='stage', AccountId = accA.Id ,Probability = 95, CloseDate=system.today());
        insert opt;
        
        Quote Q = New Quote(Name='Test Quote', OpportunityId=opt.Id);
        insert Q;
        
        ContentVersion content=new ContentVersion(); 
        content.Title='Header_Picture1'; 
        content.PathOnClient='/' + content.Title + '.jpg'; 
        content.VersionData=combinedDataAsBlob; 
        //content.LinkedEntityId=sub.id;
        content.origin = 'H';
        insert content;
        List < Id > contentDCLinks = new List < Id > ();
        
        List < Competitor__c > compList = new List < Competitor__c > ();
        Competitor__c  cmp1 = new Competitor__c ();
        cmp1.name = 'test 1';
        insert cmp1;
        
        Competitor__c  cmp2 = new Competitor__c ();
        cmp2.name = 'test 2';
        insert cmp2;
        compList.add(cmp1);
        compList.add(cmp2);
        competitor_Info__c  cinf = new competitor_Info__c();
        //cinf.Bid_No__c = pb.id;
        // cinf.Product_Name__c = p2.id;
        //cinf.Bid_Line_Item__c = bl.id;
        cinf.NDC__c = '55111072913';
        cinf.Product_Family__c = 'Allopurinol';
        cinf.Product_Name__c = 'Allopurinol 100mg 1000s Tabs';
        cinf.Incumbent_Competitor_Name__c = cmp1.id;
        cinf.Incumbent_Competitor_Name_2__c = cmp1.id;
        cinf.Incumbent_Competitor_Name_3__c = cmp1.id;
        cinf.Incumbent_Competitor_Name_4__c = cmp1.id;
        cinf.Incumbent_Competitor_Name_5__c = cmp1.id;
        cinf.Winning_Competitor_Name__c = cmp2.id;
        cinf.Incumbent_Price_Range__c = '3';
        cinf.Incumbent_Price_Range_2__c= '4';
        cinf.Incumbent_Price_Range_3__c= '5';
        cinf.Incumbent_Price_Range_4__c= '6';
        cinf.Incumbent_Price_Range_5__c= '7';
        cinf.Winning_Price_Range__c = '24';
        cinf.Winning_Price_Range_2__c = '27';
        cinf.Winning_Price_Range_3__c = '28';
        cinf.Winning_Price_Range_4__c = '34';
        cinf.Winning_Price_Range_5__c = '35';
        cinf.Vision_Product_Opportunity__c=prodopty1.id;
        insert cinf;
        
        Competitor_Info__c  cinf2 = new Competitor_Info__c();
        //cinf2.Bid_No__c = pb.id;
        // cinf2.Product_Name__c = p2.id;
        //cinf2.Bid_Line_Item__c = bl.id;
        cinf2.NDC__c = '55111-0729-10';
        cinf2.Product_Family__c = 'Allopurinol';
        cinf2.Product_Name__c = 'Allopurinol 100mg 1000s Tabs';
        cinf2.Incumbent_Competitor_Name__c = cmp1.id;
        cinf2.Winning_Competitor_Name__c = cmp2.id;
        cinf2.Incumbent_Price_Range__c = '3';
        cinf2.Incumbent_Price_Range_2__c= '4';
        cinf2.Incumbent_Price_Range_3__c= '5';
        cinf2.Incumbent_Price_Range_4__c= '6';
        cinf2.Incumbent_Price_Range_5__c= '7';
        cinf2.Winning_Price_Range__c = '24';
        cinf2.Winning_Price_Range_2__c = '27';
        cinf2.Winning_Price_Range_3__c = '28';
        cinf2.Winning_Price_Range_4__c = '34';
        cinf2.Winning_Price_Range_5__c = '35';
        insert cinf2;
        
        
        ContentVersion contentVersionSelect = [SELECT Id, Title, ContentDocumentId, VersionData FROM ContentVersion WHERE Id = :contentVersionInsert.Id LIMIT 5];
        
        Id accountId = testAccount.Id;
        
        System.Debug('accountId: '+ accountId);
        List<Phoenix_Bid_Fee_Master__c> bfeelist= new List<Phoenix_Bid_Fee_Master__c>();
        Phoenix_Bid_Fee_Master__c bfee= new Phoenix_Bid_Fee_Master__c();
        bfee.Phoenix_Customer__c=parentAccount.id;
        bfee.Phoenix_Customer_Type__c='Govt business';
        bfee.Phoenix_Fee__c=10.2;
        bfee.Phoenix_Fee_Type__c='RDC/NLC %';
        bfee.Phoenix_Preferred_Wholesaler__c = 'McKesson';
        bfeelist.add(bfee);
        
        Phoenix_Bid_Fee_Master__c bfee1= new Phoenix_Bid_Fee_Master__c();
        bfee1.Phoenix_Customer__c=testAccount.id;
        bfee1.Phoenix_Customer_Type__c='Non Govt business';
        bfee1.Phoenix_Fee__c=10.2;
        bfee1.Phoenix_Fee_Type__c='RDC/NLC %';
        bfee1.Phoenix_Preferred_Wholesaler__c = 'Cardinal';
        bfeelist.add(bfee1);
        
        Insert bfeelist;
        
        Account acc;
        Vision_OpportunityCreator.BidWrapper bwr = new Vision_OpportunityCreator.BidWrapper();
        bwr.bid = pb;
        bwr.isBidCreated = true;
        
        Phoenix_Contract__c Cntrct1 = new Phoenix_Contract__c();
        Cntrct1.name = 'taest cntrct 1';
        Cntrct1.Phoenix_Contract_Number__c = '123';
        insert Cntrct1;
        
        Phoenix_Contract__c Cntrct2 = new Phoenix_Contract__c();
        Cntrct2.name = 'taest cntrct 2';
        Cntrct2.Phoenix_Contract_Number__c = '223';
        insert Cntrct2;
        
        Phoenix_Contract__c Cntrct3 = new Phoenix_Contract__c();
        Cntrct3.name = 'taest cntrct 3';
        Cntrct3.Phoenix_Contract_Number__c = '223';
        insert Cntrct3;
        
        
        Phoenix_NPR_Data__c pnr = new Phoenix_NPR_Data__c();
        pnr.Phoenix_Contract__c=Cntrct1.id;
        pnr.Phoenix_NPR_Status__c='Active';
        pnr.Phoenix_Account__c=parentAccount.id;
        pnr.Phoenix_Contract_Number__c='123';
        Insert pnr;
        
        list<Vision_OpportunityCreator.prdwrapperClass> prList = new list<Vision_OpportunityCreator.prdwrapperClass>();
        
        List<String> contractIds = new List<String>{Cntrct1.Id, Cntrct2.Id, Cntrct3.Id};
            
            
            
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
        pr.competitorIdVal='test';
        pr.ProposedOSUnits=10;
        prList.add(pr);
        
        list<Vision_OpportunityCreator.wrapperBidCheck> bcList = new list<Vision_OpportunityCreator.wrapperBidCheck>();
        Vision_OpportunityCreator.wrapperBidCheck bc = new Vision_OpportunityCreator.wrapperBidCheck();
        bc.isError = false;
        bc.errorMessage='test';
        bc.bidId=pb.Id;
        bc.oppObj=opp3;
        bc.optyProdObj=prodopty5;
        bc.isSelected=false;
        bcList.add(bc);
        
        list<string> selcntrs = new List<String>();
        
        
        
        List<Integer> pkgList = new List<Integer>{25,34,67,89,12,67,4};
            pkgList.sort();
        //Integer data = Vision_OpportunityCreator.findClosest(pkgList, 32);
        
        list<String> csvRecordsList = contentVersionSelect.VersionData.toString().split('\n');
        //list<String> csvRowData = csvRecordsList[0].split(',');
        List<Product2> productList = [SELECT Id, Name, ProductCode, Phoenix_NDC_11__c, Phoenix_NDC_11_Dashes__c,
                                      Phoenix_Case_Pack__c, Phoenix_Minimum_Order_Quantity__c, 
                                      Phoenix_Orange_Book_Rating__c, Phoenix_Throughput_cost__c,
                                      Phoenix_Current_Budgeted_ASP__c, Phoenix_Lowest_Price_SKU__c,
                                      Phoenix_Comm_Exps__c, Phoenix_PS_Partner_1_Name__r.Name, Phoenix_PS_Partner_1__c,
                                      Phoenix_PS_Partner_2_Name__r.Name, Phoenix_PS_Partner_2__c, Phoenix_Royalty__c,
                                      Phoenix_Royalty_Partner_Name__r.Name, Phoenix_Per_Unit_Profit_Partner_2__c,
                                      Phoenix_Per_Unit_Profit_Partner_1__c, Phoenix_IPA_Floor_Price__c, Phoenix_REMS__c,
                                      Phoenix_Latest_Estimate__c, Phoenix_IMS_Market_Share__c, Phoenix_Medicaid_Per_Unit__c,
                                      Phoenix_Return_Per_Unit__c, Phoenix_UPC_Universal_Product_Code__c,
                                      Phoenix_GPI_Generic_Product_Identifier__c, Phoenix_GCN_Generic_Code_Number__c,
                                      Phoenix_GCN_Sequence_Number__c, Family, Phoenix_Strength__c,
                                      Phoenix_SAP_Pack_Size__c, Phoenix_WAC__c, Phoenix_Product_Director__r.Name, 
                                      Phoenix_Compare_to_Brand_Name__c, Phoenix_Rx_SRx_OTC__c,
                                      Phoenix_Date_of_Discontinuation__c, Phoenix_Pkg_Size__c, Description,
                                      Phoenix_Direct_Order_Price__c, Phoenix_Product_Type_for_CM_Fee__c
                                      FROM Product2 
                                      WHERE IsActive = true
                                      ORDER BY Name ASC NULLS LAST Limit 5];
        
        for(Product2 product : productList){
            system.debug('feeList : '+bfeeList);
            system.debug('acc : '+acc);
            system.debug('product.Phoenix_Throughput_cost__c : '+product.Phoenix_Throughput_cost__c);
            Vision_OpportunityCreator.mapProductOpportunity(product, csvRecordData1,'Matched',headerMap);
            Vision_OpportunityCreator.mapProductOpportunity(product, csvRecordData2,'Matched',headerMap);
            Vision_OpportunityCreator.mapProductOpportunity(product, csvRecordData2,'UnMatched',headerMap);
        }
        Vision_OpportunityCreator.saveOptyProducts(opp.Id, matchRecs,unMatchRecs);
        Vision_OpportunityCreator.saveOptyProducts(null, matchRecs,unMatchRecs);
        Vision_OpportunityCreator.saveOptyProducts(opp1.Id, '','');
        
        Vision_OpportunityCreator.returnExtProductData();
        Vision_OpportunityCreator.handleCommaInCSV(csvLine);
        Vision_OpportunityCreator.getHeaderMap(csvRecordsList2);
        Vision_OpportunityCreator.csvFileRead(contentVersionSelect.Id);
        Vision_OpportunityCreator.productCountRecords(content.Id);
        Vision_OpportunityCreator.getRecordTypeDetails();
        Vision_OpportunityCreator.createContentDCLink(q.id,contentDCLinks);
        Vision_OpportunityCreator.getcustomerOwner(testAccount.Id);
        Vision_OpportunityCreator.getoptyInfo(opp.Id);
        
        Vision_OpportunityCreator.productCountRecordsDetailPage(opp.Id);
        Vision_OpportunityCreator.productCountRecordsDetailPage(null);
        
        Vision_OpportunityCreator.mapUnmatchedProducts(matchRecs,unMatchRecs2);
        Vision_OpportunityCreator.moveUnmatchedProducts(matchRecs,unMatchRecs2);
        // Vision_OpportunityCreator voc = new Vision_OpportunityCreator();
        Vision_OpportunityCreator.sendToPanoramaFunc(opp.Id);
        //Vision_OpportunityCreator.sendToBrightFunc(opp.Id);
        Vision_OpportunityCreator.deleteAttachmentList(new list < Id > {opp.Id });
        Vision_OpportunityCreator.updateProdWithNRP( testAccount.Id, contractIds,matchRecs);
        Vision_OpportunityCreator.getNPRdata(parentAccount.Id, contractIds,prList);
        Vision_OpportunityCreator.saveOptyRec(JSON.serialize(opp3));
        Vision_OpportunityCreator.getContracts(testAccount.Id,'test','ROS');
        Vision_OpportunityCreator.getContracts(testAccount.Id,'test',' ');
        Vision_OpportunityCreator.getOptyRec(opp.Id);
        Vision_OpportunityCreator.getCompetitorInfo();
        Vision_OpportunityCreator.getCompetitorInfoObjData('55111-0729-10','55111072913');
        Vision_OpportunityCreator.validateOptyNameCtrl('Test Record');
        Vision_OpportunityCreator.deleteOptyProd(prodopty5.Id);
        Vision_OpportunityCreator.saveOptyDetPageChanges(opp1.Id,prodopty7);
        Vision_OpportunityCreator.findClosest(pkgList, 3);
        Vision_OpportunityCreator.findClosest(pkgList, 5);
        Vision_OpportunityCreator.deleteContentDoc(opp.Id);
        Vision_OpportunityCreator.getProductListSearch('Test Record',contractIds);
        //Vision_OpportunityCreator.removeProductLookup('01t1K0000068e8iQAA');
         
        //Vision_OpportunityCreator.getOptyProd(opp.Id);
        Vision_OpportunityCreator.checkForBid(opp.Id);
        Vision_OpportunityCreator.fetchPrdOptyRecs(opp.Id);
        Vision_OpportunityCreator.saveCompInfo(cinf, 'Allopurinol', '55111072913',  'Test Account', 'Test Product3', JSON.serialize(prodopty5.Id));
        
        Vision_OpportunityCreator.saveOptyExtProductsManual(JSON.serialize(opp.Id), JSON.serialize(prodopty5.Id));
        Vision_OpportunityCreator.saveProductsToExtOpty(JSON.serialize(opp.Id), prList, contractIds);
        Vision_AddOpportunityLinesCtrl.saveProductsToExtOpty(JSON.serialize(opp.Id), prList, contractIds);
        Vision_OpportunityCreator.saveOptyProductsManual(JSON.serialize(opp3), prList, contractIds);
        Vision_OpportunityCreator.updateCoItems('testId');
        //  Vision_OpportunityCreator.coverageBlock();
        /*Vision_OpportunityCreator.savedProductOptyWrapper prow = new Vision_OpportunityCreator.savedProductOptyWrapper();
prow.competitorObjInfo = compList;
prow.savedProducts = prodoptyList;
prow.oppIdData = new Map<String,Id>{'OppId'=>opp.Id};*/
        /*saveOptyProductsManual
saveProductsToExtOpty
saveOptyExtProductsManual
saveCompInfo
fetchPrdOptyRecs
savedProductOptyWrapper
wrapperBidCheck
checkForBid
getOptyProd
sendToBrightFunc
savequoteitems
BidWrapper
prdwrapperClass
getCompetitorInfo
getCompetitorInfoObjData
validateOptyNameCtrl
deleteOptyProd
updateProdWithNRP
getNPRdata
getNPRdata*/
        
    }
    
    static testmethod void AddProductMethod1() {
        Account parentAccount = new Account(Name = 'Walgreen Company',AccountNumber = '117866',Phoenix_Local_VIP__c=12.2, Phoenix_Is_Govt_Customer__c = true,Phoenix_Preferred_Wholesaler__c='McKesson',Phoenix_Is_Bid_Account__c=true,Phoenix_Customer_Class_Bid_Template__c='Indirect');
        insert parentAccount;
        Account testAccount = new Account(Name = 'Walgreen Company',AccountNumber = '117866', Phoenix_Local_VIP__c=12.2,ParentId= parentAccount.Id, Phoenix_Preferred_Wholesaler__c = 'Cardinal', Phoenix_Is_Govt_Customer__c = true,Phoenix_Is_Bid_Account__c=true,Phoenix_Customer_Class_Bid_Template__c='Indirect');
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
        pb.Phoenix_Bid_Type__c = 'WAC Change Submissions';
        pb.Phoenix_Approval_Status__c = 'Draft';
        pb.Phoenix_Internal_Target_Date__c = system.Date.today();
        insert pb;
        
        Opportunity opp = new Opportunity(); 
        opp.Name = 'Test Record';
        opp.Vsion_Status__c = 'Opportunity in progress';
        opp.Bid_Type__c = 'Product Addition';  
        opp.Vision_Comments__c = 'Test Comments';
        opp.AccountId = testAccount.Id;
        opp.Vision_Bid_Template__c='Indirect';
        opp.Vision_Opportunity_Value__c=20;
        opp.CloseDate=System.today();
        opp.Vision_Reference_Contract__c='223';
        opp.StageName='Closed Lost';
        //pb.Phoenix_Customer_Type__c='Econdisc';
        insert opp;
        
        Opportunity opp1 = new Opportunity();
        opp1.Name = 'Test Record 1';
        opp1.Vsion_Status__c = 'Opportunity in progress';
        opp1.Bid_Type__c = 'Product Addition';  
        opp1.Vision_Comments__c = 'Test Comments';
        opp1.AccountId = testAccount.Id;
        opp1.Vision_Bid_Template__c='ABC Progen';
        opp1.CloseDate=System.today();
        opp1.StageName='Closed Lost';
        opp1.Vision_Reference_Contract__c='223';
        //pb.Phoenix_Customer_Type__c='Econdisc';
        insert opp1;
        
        Opportunity opp2 = new Opportunity();
        opp2.Name = 'Test Record 1';
        opp2.Vsion_Status__c = 'Opportunity in progress';
        opp2.Bid_Type__c = 'Product Addition';  
        opp2.Vision_Comments__c = 'Test Comments';
        opp2.AccountId = testAccount.Id;
        opp2.Vision_Bid_Template__c='Econdisc';
        opp2.CloseDate=System.today();
        opp2.StageName='Closed Lost';
        opp2.Vision_Reference_Contract__c='223';
        //pb.Phoenix_Customer_Type__c='';
        insert opp2;
        
        Opportunity opp3 = new Opportunity();
        opp3.Name = 'Test Record 1';
        opp3.Vsion_Status__c = 'Opportunity in progress';
        opp3.Bid_Type__c = 'Product Addition';  
        opp3.Vision_Comments__c = 'Test Comments';
        opp3.AccountId = testAccount.Id;
        opp3.Vision_Bid_Template__c='Econdisc';
        opp3.CloseDate=System.today();
        opp3.StageName='Closed Lost';
        opp3.Vision_Reference_Contract__c='223';
        Insert opp3;
        
        Opportunity opp4 = new Opportunity();
        opp4.Name = 'Test Record 1';
        opp4.Vsion_Status__c = 'Opportunity in progress';
        opp4.Bid_Type__c = 'Product Addition';  
        opp4.Vision_Comments__c = 'Test Comments';
        opp4.AccountId = testAccount.Id;
        opp4.Vision_Bid_Template__c='Econdisc';
        opp4.Vision_Internal_Closing_Date__c=System.today();
        opp4.StageName='Closed Lost';
        opp4.Vision_Reference_Contract__c='223';
        
        
        
        Attachment attach=new Attachment();   	
        attach.Name='Test Attachment';
        Blob bodyBlob2=Blob.valueOf('Test Attachment Body');
        attach.body=bodyBlob2;
        attach.parentId=opp.Id;
        insert attach;
        
        list < Product2 > prodList = new list < Product2 > ();
        Product2 prod1 = new Product2(Name = 'Test Product', Phoenix_Rx_SRx_OTC__c = 'Rx', 
                                      Phoenix_Special_Product__c = true, Phoenix_GPI_Generic_Product_Identifier__c = '11111', 
                                      Phoenix_NDC_11__c = '12345678902', Family = 'Test Family', IsActive = TRUE, 
                                      Phoenix_Throughput_cost__c=10.23456576,Phoenix_GCN_Generic_Code_Number__c = '44444',
                                      Phoenix_GCN_Sequence_Number__c='666666',
                                      Phoenix_Pkg_Size__c=25.0,ProductCode='123456'
                                     );
        Product2 prod2 = new Product2(Name = 'Test Product1', Phoenix_Rx_SRx_OTC__c = 'Rx', Phoenix_Special_Product__c = true, 
                                      Phoenix_GPI_Generic_Product_Identifier__c = '22222',  Phoenix_NDC_11__c = '21345678902', 
                                      Family = 'Sample Family',  IsActive = TRUE,Phoenix_GCN_Generic_Code_Number__c = '44444',
                                      Phoenix_Throughput_cost__c=10.23456576,Phoenix_Pkg_Size__c=25.0,
                                      Phoenix_GCN_Sequence_Number__c='666666',ProductCode='123456'
                                     );
        Product2 prod3 = new Product2(Name = 'Test Product2', Phoenix_Rx_SRx_OTC__c = 'SRx', Phoenix_Special_Product__c = true, 
                                      Phoenix_NDC_11__c = '32145678902', Family = ' cetirizine', IsActive = TRUE,
                                      Phoenix_Throughput_cost__c=10.23456576,Phoenix_Pkg_Size__c=25.0,ProductCode='123456'
                                     );
        Product2 prod4 = new Product2(Name = 'Test Product3', Phoenix_Rx_SRx_OTC__c = 'OTC', 
                                      Phoenix_Special_Product__c = true,
                                      Phoenix_GCN_Generic_Code_Number__c = '44444',
                                      Phoenix_GPI_Generic_Product_Identifier__c = '333333', 
                                      Family = ' cetirizine', IsActive = TRUE,Phoenix_Pkg_Size__c=25.0,
                                      Phoenix_GCN_Sequence_Number__c='666666',Phoenix_NDC_11__c='111111'
                                      ,Phoenix_Throughput_cost__c=10.23456576,ProductCode='123456',Phoenix_Lowest_Price_SKU__c=10.1,
                                      Description='test',Phoenix_Strength__c='test');
        
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
                                                                      NDC_11__c = '12345-678902', Product_Family__c = 'Test Family',
                                                                      GSN__c='test',  GPI_Generic_Product_Identifier__c = '222222',
                                                                      GCN_Generic_Code_Number__c='666666',
                                                                      vision_is_discrepancy_product__c=true,Status__c = 'Matched',Pkg_Size__c=25,
                                                                      Vision_Opportunity_Value__c=10,SKU_Number__c='test',
                                                                      Opportunity__c=opp1.Id, Is_GSN_Pack_Size_Matched__c=true,Vision_Is_Pack_Size_Provided__c=true,
                                                                      Vision_Is_NDC_Provided__c=true,Vision_Is_GCN_Provided__c=true,
                                                                      Vision_Is_SKU_Provided__c=true,Strength__c='This is a test strength that we are going to check on testing bla bla bla This is a test strength that we are going to check on testing bla bla bla This is a test strength that we are going to check on testing bla bla bla This is a test strength that we are going to check on testing bla bla bla This is a test strength that we are going to check on testing bla bla bla'
                                                                     );
        Product_Opportunity__c prodopty2 = new Product_Opportunity__c(Name = 'Test Product opty1', 
                                                                      GPI_Generic_Product_Identifier__c = '3444443',GSN__c='test',
                                                                      NDC_11__c = '213456-78902', Product_Family__c = 'Sample Family',SKU_Number__c='test',
                                                                      GCN_Generic_Code_Number__c='666666',Vision_Total_Annual_Units__c = 23455767,
                                                                      vision_is_discrepancy_product__c=true,Pkg_Size__c=30,Vision_Opportunity_Value__c=10,
                                                                      Status__c = 'Matched',Opportunity__c=opp1.Id, Is_GSN_Pack_Size_Matched__c=true,Vision_Is_Pack_Size_Provided__c=true,
                                                                      Vision_Is_NDC_Provided__c=true,Vision_Is_GCN_Provided__c=true,
                                                                      Vision_Is_SKU_Provided__c=true
                                                                     );
        Product_Opportunity__c prodopty3 = new Product_Opportunity__c(Name = 'Test Product opty2',GPI_Generic_Product_Identifier__c = '3444443',
                                                                      NDC_11__c = '213456-78902', Product_Family__c = 'Sample Family',
                                                                      GCN_Generic_Code_Number__c='666666',Pkg_Size__c=30,Vision_Opportunity_Value__c=10,
                                                                      vision_is_discrepancy_product__c=true,Status__c = 'Matched',
                                                                      Opportunity__c=opp1.Id,
                                                                       Is_GSN_Pack_Size_Matched__c=true,Vision_Is_Pack_Size_Provided__c=true,
                                                                      Vision_Is_NDC_Provided__c=true,Vision_Is_GCN_Provided__c=true,
                                                                      Vision_Is_SKU_Provided__c=true
                                                                     );
        Product_Opportunity__c prodopty4 = new Product_Opportunity__c(Name = 'Test Product opty3', NDC_11__c = '12345-678902', Product_Family__c = 'Test Family',
                                                                      GPI_Generic_Product_Identifier__c = '222222',GCN_Generic_Code_Number__c='666666',
                                                                      Status__c = 'Matched',Pkg_Size__c=25,Vision_Total_Annual_Units__c = 23455767,
                                                                      vision_is_discrepancy_product__c=true,Opportunity__c=opp1.Id, Is_GSN_Pack_Size_Matched__c=true,Vision_Is_Pack_Size_Provided__c=true,
                                                                      Vision_Is_NDC_Provided__c=true,Vision_Is_GCN_Provided__c=true,
                                                                      Vision_Is_SKU_Provided__c=true
                                                                     );
        Product_Opportunity__c prodopty5 = new Product_Opportunity__c(Name = 'Test Product opty5', Product__c = prod3.Id, Pkg_Size__c=25, GSN__c='666666', 
                                                                      Status__c = 'Matched', vision_is_discrepancy_product__c=true,
                                                                      Opportunity__c=opp1.Id, Vision_Opportunity_Value__c=10,
                                                                      Vision_Total_Annual_Units__c = 23455767,
                                                                       Is_GSN_Pack_Size_Matched__c=true,Vision_Is_Pack_Size_Provided__c=true,
                                                                      Vision_Is_NDC_Provided__c=true,Vision_Is_GCN_Provided__c=true,
                                                                      Vision_Is_SKU_Provided__c=true
                                                                     );
        Product_Opportunity__c prodopty6 = new Product_Opportunity__c(Name = 'Test Product opty6', Product__c = prod2.Id,Pkg_Size__c=25, 
                                                                      GSN__c='666666', Status__c = 'Matched',Vision_Alt_Pkg_Size__c=25,Vision_High_Pkg_Size__c=45,Opportunity__c=opp1.Id, 
                                                                      Vision_Bid_on_Highest_Pack_Size__c = true, Vision_Opportunity_Value__c=10,Vision_Bid_on_Alternative_Pack_Size__c = true, 
                                                                      Dosage_Form__c = 'Tablets',vision_is_discrepancy_product__c=true,
                                                                      Vision_Total_Annual_Units__c = 23455767, Vision_UOM__c = 'EA'
                                                                     );
        Product_Opportunity__c prodopty7 = new Product_Opportunity__c(Name = 'Test Product opty7', Product__c = prod2.Id,Pkg_Size__c=95, 
                                                                      GSN__c='777777', Status__c = 'Matched',Vision_Alt_Pkg_Size__c=25,Vision_High_Pkg_Size__c=45,Opportunity__c=opp1.Id, 
                                                                      Vision_Bid_on_Highest_Pack_Size__c = true, Vision_Opportunity_Value__c=10,Vision_Bid_on_Alternative_Pack_Size__c = true, 
                                                                      Dosage_Form__c = 'Tablets',vision_is_discrepancy_product__c=true,
                                                                      Vision_UOM__c = 'EA'
                                                                     );
        Insert prodopty7;
        
        prodoptyList.add(prodopty1);
        prodoptyList.add(prodopty2);
        prodoptyList.add(prodopty3);
        prodoptyList.add(prodopty4);
        prodoptyList.add(prodopty5);
        prodoptyList.add(prodopty6);
        //insert prodoptyList;
        Map<Id, Product_Opportunity__c> prdOptyMap = new Map<Id, Product_Opportunity__c>{prod3.Id => prodopty5,prod2.Id=>prodopty6 };
            
            matchprodoptyList.add(prodopty1);
        matchprodoptyList.add(prodopty2);
        
        unmatchprodoptyList.add(prodopty3);
        unmatchprodoptyList.add(prodopty4);
        
        unmatchprodoptyList2.add(prodopty5);
        unmatchprodoptyList2.add(prodopty6);
        
        String matchRecs = JSON.serialize(matchprodoptyList);
        String unMatchRecs = JSON.serialize(unmatchprodoptyList);
        String unMatchRecs2 = JSON.serialize(unmatchprodoptyList2);
        
        list<String> csvRecordsList2 = new list<String>{'GCN,GSN,GPI,NDC 11,SKU NUMBER,PRODUCT FAMILY,STRENGTH,DOSAGE FORM,PACK SIZE,PRODUCT DESCRIPTION,TOTAL ANNUAL UNITS,UOM,CUSTOMER COMMENTS,BID ON HIGHEST PACK SIZE,BID ON ALTERNATIVE PACK SIZE'};
            
            Map<String,Integer> headerMap = new Map<String,Integer>{'GCN'=> 0, 'GSN'=> 1, 'GPI'=> 2, 'ndc'=> 3, 'sku_num'=> 4, 'prd_family'=> 5, 
                'STRENGTH'=> 6, 'dosage_form'=> 7, 'pkg_size'=> 8, 'prd_desc'=> 9, 'tot_annual_units'=> 10,'gui_price'=>11,
                'UOM'=> 11, 'cus_cmt'=> 12, 'bid_on_highest_pkg_size'=> 13, 'bid_on_alternative_pkg_size' => 14,'pro_direct_selling_units'=>10,
                'pro_indirect_selling_units'=>10,
                'pro_os_units'=>10,'pro_rad_units'=>10,'pro_wmt_units'=>10,'pro_smithDrug_units'=>8,'pro_anda_units'=>10,
                'pro_dir_ahold_units'=>14};
                    List<String> csvRecordData1 = new List<String>{'63915','2706','48991003101835','55111052230','300031164','ALMACONE-2 LIQUID','355.0','Injectable','355','ALMACONE-2 LIQUID','1,83,192','ML','BID LARGEST PKG SIZE AVAILABLE','NO','YES'};
                        List<String> csvRecordData2 = new List<String>{'14262','3775','57100010000315','55111019690','300028678','ALPRAZOLAM 1 MG TABLET','1000','Injectable','1000','ALPRAZOLAM 1 MG TABLET','35,87,458','TABLET','BID LARGEST PKG SIZE AVAILABLE','YES','NO'};
                            String csvLine = 'Test,Check,abc@abc.com, "19, Link road, A1SH10, India", companyName, "companyStreet, CompanyCity, CompanyCountry"';
        
        List<Attachment> attachments=[select id, name from Attachment where parent.Id=:opp.Id];
        Blob b1 = Blob.valueOf('GCN,GSN,GPI,NDC 11,SKU NUMBER,PRODUCT FAMILY,STRENGTH,DOSAGE FORM,PACK SIZE,PRODUCT DESCRIPTION,TOTAL ANNUAL UNITS,UOM,CUSTOMER COMMENTS,BID ON HIGHEST PACK SIZE,BID ON ALTERNATIVE PACK SIZE');
        Blob b2 = Blob.valueOf('63915,2706,48991003101835,55111052230,300031164,ALMACONE-2 LIQUID,355.0,Injectable,355,ALMACONE-2 LIQUID,1,83,192,ML,BID LARGEST PKG SIZE AVAILABLE,NO,YES');
        Blob b3 = Blob.valueOf('14262,3775,57100010000315,55111019690,300028678,ALPRAZOLAM 1 MG TABLET,1000,Injectable,1000,ALPRAZOLAM 1 MG TABLET,35,87,458,TABLET,BID LARGEST PKG SIZE AVAILABLE,YES,NO');
        
        String combinedDataAsHex = EncodingUtil.convertToHex(b1) + EncodingUtil.convertToHex(b2) + EncodingUtil.convertToHex(b3);
        Blob combinedDataAsBlob = EncodingUtil.convertFromHex(combinedDataAsHex);
        List<ContentVersion> cv = new List<ContentVersion>();
        ContentVersion contentVersionInsert = new ContentVersion(
            Title = 'Test',
            PathOnClient = 'Test.csv',
            VersionData = combinedDataAsBlob,
            IsMajorVersion = true
        );
        
        insert contentVersionInsert;
        
        Account accA =new Account(Name='Demo');
        insert accA ; 
        Opportunity opt = new Opportunity(Name='test opp',StageName='stage', AccountId = accA.Id ,Probability = 95, CloseDate=system.today());
        insert opt;
        
        Quote Q = New Quote(Name='Test Quote', OpportunityId=opt.Id);
        insert Q;
        
        ContentVersion content=new ContentVersion(); 
        content.Title='Header_Picture1'; 
        content.PathOnClient='/' + content.Title + '.jpg'; 
        content.VersionData=combinedDataAsBlob; 
        //content.LinkedEntityId=sub.id;
        content.origin = 'H';
        insert content;
        List < Id > contentDCLinks = new List < Id > ();
        
        List < Competitor__c > compList = new List < Competitor__c > ();
        Competitor__c  cmp1 = new Competitor__c ();
        cmp1.name = 'test 1';
        insert cmp1;
        
        Competitor__c  cmp2 = new Competitor__c ();
        cmp2.name = 'test 2';
        insert cmp2;
        compList.add(cmp1);
        compList.add(cmp2);
        
        competitor_Info__c  cinf = new Competitor_Info__c();
        cinf.Id=Null;
        Insert cinf; 
        
        ContentVersion contentVersionSelect = [SELECT Id, Title, ContentDocumentId, VersionData FROM ContentVersion WHERE Id = :contentVersionInsert.Id LIMIT 1];
        
        Id accountId = testAccount.Id;
        
        System.Debug('accountId: '+ accountId);
        List<Phoenix_Bid_Fee_Master__c> feeList = new List<Phoenix_Bid_Fee_Master__c>(); 
        Phoenix_Bid_Fee_Master__c fee1 = new Phoenix_Bid_Fee_Master__c(Phoenix_Preferred_Wholesaler__c = 'ABC', 
                                                                       Phoenix_Product_Type_for_CM_Fee__c = 'Special Product', 
                                                                       Phoenix_Fee_Type__c ='RDC/NLC %',
                                                                       Phoenix_Customer_Type__c = 'Govt business', Phoenix_Fee__c = 10.25);
        Phoenix_Bid_Fee_Master__c fee2 = new Phoenix_Bid_Fee_Master__c(Phoenix_Preferred_Wholesaler__c = 'ABC',
                                                                       Phoenix_Fee_Type__c ='CM Fee%',
                                                                       Phoenix_Product_Type_for_CM_Fee__c = 'Special Product', 
                                                                       Phoenix_Customer_Type__c = 'Govt business', Phoenix_Fee__c = 10.25);
        Phoenix_Bid_Fee_Master__c fee3 = new Phoenix_Bid_Fee_Master__c(Phoenix_Preferred_Wholesaler__c = 'ABC', 
                                                                       Phoenix_Fee_Type__c ='RDC/NLC %',
                                                                       Phoenix_Product_Type_for_CM_Fee__c = 'Special Product', 
                                                                       Phoenix_Customer_Type__c = 'Govt business', Phoenix_Fee__c = 10.25);
        
        
        Account acc;
        
        Vision_OpportunityCreator.BidWrapper bwr = new Vision_OpportunityCreator.BidWrapper();
        bwr.bid = pb;
        bwr.isBidCreated = true;
        bwr.bid.Phoenix_Bid_Type__c = 'Short Dated OTB';
        bwr.bid.Phoenix_Customer_Type__c='Costco';
        
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
        insert Cntrct3;
        
        list<Vision_OpportunityCreator.prdwrapperClass> prList = new list<Vision_OpportunityCreator.prdwrapperClass>();
        list<Vision_OpportunityCreator.prdwrapperClass> prList1 = new list<Vision_OpportunityCreator.prdwrapperClass>();
        list<Vision_OpportunityCreator.prdwrapperClass> prList2 = new list<Vision_OpportunityCreator.prdwrapperClass>();
        list<Vision_OpportunityCreator.prdwrapperClass> prList3 = new list<Vision_OpportunityCreator.prdwrapperClass>();
        list<Vision_OpportunityCreator.prdwrapperClass> prList4 = new list<Vision_OpportunityCreator.prdwrapperClass>();
        
        List<String> contractIds = new List<String>{Cntrct1.Id, Cntrct2.Id, Cntrct3.Id};
            
            
            
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
        pr.ProposedDirectEsiUnits=20;
        pr.ProposedIndirectEsiUnits=20;
        pr.ProposedDirectKrogerUnits=30;
        pr.ProposedIndirectKrogerUnits=40;
        pr.ProposedDirectRxOutreachUnits=50;
        pr.ProposedIndirectRxOutreachUnits=60;
        pr.ProposedDirectSupervaluUnits=70;
        pr.ProposedIndirectSupervaluUnits=80;
        pr.ProposedDirectCordantUnits=70;
        pr.ProposedIndirectCordantUnits=90;
        pr.ProposedDirectAccerodoUnits=10;
        pr.ProposedIndirectAccerodoUnits=30;
        pr.ProposedIndirectUnits=70;
        pr.currentAndaUnits=20;
        pr.currentWholeSalerUnits=78;
        pr.currentBaseUnits=10;
        pr.currentDshUnits=6;
        pr.currentAutoSubUnits=12;
        pr.currentOsRadUnits=77;
        
        prList.add(pr);
        
        Vision_OpportunityCreator.prdwrapperClass pr1 = new Vision_OpportunityCreator.prdwrapperClass();
        
        pr1.guidancePriceVal = '23';
        pr1.competitorIdVal='';
        pr1.contrFlag=true;
        pr1.currencyCode='$';
        pr1.currentDirectPrice=20;
        pr1.currentDirectUnits=30;
        pr1.currentIndirectPrice=45;
        pr1.currentIndirectUnits=24;
        pr1.currentRebatePer=23;
        pr1.financialImpact=24;
        pr1.incumbentCompId2='45';  
        pr1.isSelected=true;
        pr1.opportunityVal='23';
        pr1.prdlist=prod4;
        pr1.priceRange1='23';
        pr1.priceRange2='23';
        pr1.priceRange3='23';
        pr1.priceRange4='23';
        pr1.priceRange5='23';
        pr1.priceRangeVal='24';
        pr1.proposedDirectUnits=245;
        pr1.proposedUnitsVal='234';
        pr1.salesPriceVal='23234';
        prList1.add(pr1);
        
        Vision_OpportunityCreator.prdwrapperClass pr2 = new Vision_OpportunityCreator.prdwrapperClass();
        pr2.guidancePriceVal = '23';
        pr2.competitorIdVal='';
        pr2.contrFlag=true;
        pr2.currencyCode='$';
        pr2.currentDirectPrice=20;
        pr2.currentDirectUnits=30;
        pr2.currentIndirectPrice=45;
        pr2.currentIndirectUnits=24;
        pr2.currentRebatePer=23;
        pr2.financialImpact=24;
        pr2.incumbentCompId3='75';  
        pr2.isSelected=true;
        pr2.opportunityVal='23';
        pr2.prdlist=prod4;
        pr2.priceRange1='23';
        pr2.priceRange2='23';
        pr2.priceRange3='23';
        pr2.priceRange4='23';
        pr2.priceRange5='23';
        pr2.priceRangeVal='24';
        pr2.proposedDirectUnits=245;
        pr2.proposedUnitsVal='234';
        pr2.salesPriceVal='23234';     
        prList2.add(pr2);
        
        Vision_OpportunityCreator.prdwrapperClass pr3 = new Vision_OpportunityCreator.prdwrapperClass();
        pr3.guidancePriceVal = '23';
        pr3.competitorIdVal='';
        pr3.contrFlag=true;
        pr3.currencyCode='$';
        pr3.currentDirectPrice=20;
        pr3.currentDirectUnits=30;
        pr3.currentIndirectPrice=45;
        pr3.currentIndirectUnits=24;
        pr3.currentRebatePer=23;
        pr3.financialImpact=24;
        pr3.incumbentCompId4='75';  
        pr3.isSelected=true;
        pr3.opportunityVal='23';
        pr3.prdlist=prod4;
        pr3.priceRange1='23';
        pr3.priceRange2='23';
        pr3.priceRange3='23';
        pr3.priceRange4='23';
        pr3.priceRange5='23';
        pr3.priceRangeVal='24';
        pr3.proposedDirectUnits=245;
        pr3.proposedUnitsVal='234';
        pr3.salesPriceVal='23234';     
        prList3.add(pr3);
        
        Vision_OpportunityCreator.prdwrapperClass pr4 = new Vision_OpportunityCreator.prdwrapperClass();
        pr4.guidancePriceVal = '23';
        pr4.competitorIdVal='';
        pr4.contrFlag=true;
        pr4.currencyCode='$';
        pr4.currentDirectPrice=20;
        pr4.currentDirectUnits=30;
        pr4.currentIndirectPrice=45;
        pr4.currentIndirectUnits=24;
        pr4.currentRebatePer=23;
        pr4.financialImpact=24;
        pr4.incumbentCompId5='75';  
        pr4.isSelected=true;
        pr4.opportunityVal='23';
        pr4.prdlist=prod4;
        pr4.priceRange1='23';
        pr4.priceRange2='23';
        pr4.priceRange3='23';
        pr4.priceRange4='23';
        pr4.priceRange5='23';
        pr4.priceRangeVal='24';
        pr4.proposedDirectUnits=245;
        pr4.proposedUnitsVal='234';
        pr4.salesPriceVal='23234';  
        pr4.opportunityVal='dfsfvscsd';
        prList4.add(pr4);
        
        list<Vision_OpportunityCreator.wrapperBidCheck> bcList = new list<Vision_OpportunityCreator.wrapperBidCheck>();
        Vision_OpportunityCreator.wrapperBidCheck bc = new Vision_OpportunityCreator.wrapperBidCheck();
        bc.isError = false;
        bc.errorMessage='test';
        bc.bidId=pb.Id;
        bc.oppObj=opp3;
        bc.optyProdObj=prodopty5;
        bc.isSelected=false;
        bcList.add(bc);
        list<string>selcntrs = new List<String>();
        
        
        if(accountId!=null){
            acc = [select Id,Phoenix_Is_Govt_Customer__c,Phoenix_Cash_Discount__c,Phoenix_Fee__c,Fee_Type__c,Rebate_Type__c,Phoenix_Indirect_Cash_Discount__c,Phoenix_Rebates__c,Phoenix_Preferred_Wholesaler__c,Phoenix_Local_VIP__c,Phoenix_CM_Fees__c,Phoenix_RDC_NLC__c,Cash_Terms__c from Account where Id=:accountId];
            
            feeList = [select Id,Phoenix_Customer_Type__c,Phoenix_Fee__c,Phoenix_Preferred_Wholesaler__c,Phoenix_Fee_Type__c,Phoenix_Product_Type_for_CM_Fee__c from Phoenix_Bid_Fee_Master__c where Phoenix_Preferred_Wholesaler__c='ABC' limit 5];     
        }
        if(feeList.size() == 0){
            feeList.add(fee1);
            feeList.add(fee2);
            feeList.add(fee3);
            Insert feeList;
        }
        List<Integer> pkgList = new List<Integer>{25,34,67,89,12,67,4};
            pkgList.sort();
        //Integer data = Vision_OpportunityCreator.findClosest(pkgList, 32);
        
        list<String> csvRecordsList = contentVersionSelect.VersionData.toString().split('\n');
        //list<String> csvRowData = csvRecordsList[0].split(',');
        List<Product2> productList = [SELECT Id, Name, ProductCode, Phoenix_NDC_11__c, Phoenix_NDC_11_Dashes__c,
                                      Phoenix_Case_Pack__c, Phoenix_Minimum_Order_Quantity__c, 
                                      Phoenix_Orange_Book_Rating__c, Phoenix_Throughput_cost__c,
                                      Phoenix_Current_Budgeted_ASP__c, Phoenix_Lowest_Price_SKU__c,
                                      Phoenix_Comm_Exps__c, Phoenix_PS_Partner_1_Name__r.Name, Phoenix_PS_Partner_1__c,
                                      Phoenix_PS_Partner_2_Name__r.Name, Phoenix_PS_Partner_2__c, Phoenix_Royalty__c,
                                      Phoenix_Royalty_Partner_Name__r.Name, Phoenix_Per_Unit_Profit_Partner_2__c,
                                      Phoenix_Per_Unit_Profit_Partner_1__c, Phoenix_IPA_Floor_Price__c, Phoenix_REMS__c,
                                      Phoenix_Latest_Estimate__c, Phoenix_IMS_Market_Share__c, Phoenix_Medicaid_Per_Unit__c,
                                      Phoenix_Return_Per_Unit__c, Phoenix_UPC_Universal_Product_Code__c,
                                      Phoenix_GPI_Generic_Product_Identifier__c, Phoenix_GCN_Generic_Code_Number__c,
                                      Phoenix_GCN_Sequence_Number__c, Family, Phoenix_Strength__c,
                                      Phoenix_SAP_Pack_Size__c, Phoenix_WAC__c, Phoenix_Product_Director__r.Name, 
                                      Phoenix_Compare_to_Brand_Name__c, Phoenix_Rx_SRx_OTC__c,
                                      Phoenix_Date_of_Discontinuation__c, Phoenix_Pkg_Size__c, Description,
                                      Phoenix_Direct_Order_Price__c, Phoenix_Product_Type_for_CM_Fee__c
                                      FROM Product2 
                                      WHERE IsActive = true
                                      ORDER BY Name ASC NULLS LAST Limit 5];
        
        for(Product2 product : productList){
            system.debug('feeList : '+feeList);
            system.debug('acc : '+acc);
            system.debug('product.Phoenix_Throughput_cost__c : '+product.Phoenix_Throughput_cost__c);
            Vision_OpportunityCreator.mapProductOpportunity(product, csvRecordData1,'Matched',headerMap);
            Vision_OpportunityCreator.mapProductOpportunity(product, csvRecordData2,'Matched',headerMap);
            Vision_OpportunityCreator.mapProductOpportunity(product, csvRecordData2,'UnMatched',headerMap);
        }
        Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'Creator', Phoenix_Error_Message__c ='hbhb', Phoenix_Issue_Status__c = 'Pending', Phoenix_Method_Name__c = 'execute', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = 'hbhg', Phoenix_Current_User__c ='lisa');
        insert exp;
        Product_Opportunity__c vhu =new Product_Opportunity__c();
        String gsn =  '';
        String gcn =  'nb';
        String gpi =  'nbhk';
        String gsnUnique = 'nhjvv';
        String gcnUnique = 'bb';
        String gpiUnique = 'vcjmhgc';
        String sku_num = 'hgchx';
        String ndc = 'mvhgc';
        String highBidPkgSize = 'mhvhfx';
        String AltBidPkgSize = 'jbgc';
        
         Vision_OpportunityCreator.productCountRecordsDetailPage(opp1.Id);
        Vision_OpportunityCreator.saveOptyProducts(opp1.Id, '',unMatchRecs);
        Vision_OpportunityCreator.returnExtProductData();
        Vision_OpportunityCreator.handleCommaInCSV(csvLine);
        Vision_OpportunityCreator.getHeaderMap(csvRecordsList2);
        Vision_OpportunityCreator.csvFileRead(contentVersionSelect.Id);
        // Vision_OpportunityCreator.productCountRecords(contentVersionSelect.Id);
        Vision_OpportunityCreator.prepareRecords(csvRecordsList2,headerMap);
        Vision_OpportunityCreator.productCountRecords2(contentVersionInsert.Id);
        Vision_OpportunityCreator.processProductMatching(matchRecs);
        Vision_OpportunityCreator.getRecordTypeDetails();
        Vision_OpportunityCreator.createContentDCLink(q.id,contentDCLinks);
        Vision_OpportunityCreator.getcustomerOwner(testAccount.Id);
        Vision_OpportunityCreator.getoptyInfo(opp.Id);
        Vision_OpportunityCreator.mapProductOpportunityRec(prod4,prodopty7);
        Vision_OpportunityCreator.productCountRecordsDetailPage(opp3.Id);
        Vision_OpportunityCreator.productCountRecordsDetailPage(null);
        Vision_OpportunityCreator.mapUnmatchedProducts(matchRecs,unMatchRecs2);
        // Vision_OpportunityCreator voc = new Vision_OpportunityCreator();
        Vision_OpportunityCreator.sendToPanoramaFunc(opp.Id);
        //Vision_OpportunityCreator.sendToBrightFunc(opp.Id);
        Vision_OpportunityCreator.deleteAttachmentList(new list < Id > {opp.Id });
        Vision_OpportunityCreator.updateProdWithNRP( testAccount.Id, contractIds,matchRecs);
        Vision_OpportunityCreator.getNPRdata(testAccount.Id, contractIds,prList);
        //Vision_OpportunityCreator.saveOptyRec(JSON.serialize(opp3));
        Vision_OpportunityCreator.saveOptyRec(null);
        Vision_OpportunityCreator.getContracts(testAccount.Id,'test','ROS');
        Vision_OpportunityCreator.getContracts(testAccount.Id,'test',' ');
        Vision_OpportunityCreator.getOptyRec(opp.Id);
        
        Vision_OpportunityCreator.getCompetitorInfo();
        Vision_OpportunityCreator.getCompetitorInfoObjData('55111-0729-10','55111072913');
        Vision_AddOpportunityLinesCtrl.getCompetitorInfoObjData('55111-0729-10','55111072913');
        Vision_OpportunityCreator.validateOptyNameCtrl('');
        Vision_OpportunityCreator.getClosest(1,21,1);
        //Vision_OpportunityCreator.deleteOptyProd(prodopty5.Id);
        Vision_OpportunityCreator.deleteOptyProd(null);
        Vision_OpportunityCreator.saveOptyDetPageChanges(opp1.Id,prodopty7);
        Vision_OpportunityCreator.findClosest(pkgList, 90);
        Vision_OpportunityCreator.findClosest(pkgList, 50);
        //Vision_OpportunityCreator.sendToBrightFunc(opp.Id,JSON.serialize(bcList));
        //Vision_OpportunityCreator.getOptyProd(opp.Id);
        Vision_OpportunityCreator.checkForBid(opp.Id);
        Vision_OpportunityCreator.fetchPrdOptyRecs(null);
        Vision_OpportunityCreator.saveCompInfo(cinf, 'Allopurinol', '55111072913',  'Test Account', 'Test Product3', JSON.serialize(prodopty5.Id));
        
        Vision_OpportunityCreator.saveOptyExtProductsManual(JSON.serialize(opp.Id), JSON.serialize(opp.Id));
        Vision_OpportunityCreator.saveProductsToExtOpty(opp.Id, prList, contractIds);
        Vision_OpportunityCreator.saveOptyProductsManual(JSON.serialize(opp4), prList, contractIds);
        
        
    }
    
    
    static testmethod void testingmethod1()
    {
        Account Acc = new Account(Name = 'Walgreen Company',AccountNumber='370337', Phoenix_Local_VIP__c=12.2,Phoenix_Preferred_Wholesaler__c = 'ABC', Phoenix_Is_Govt_Customer__c = false,Phoenix_Is_Bid_Account__c=true,Phoenix_Customer_Class_Bid_Template__c='Indirect');
        insert Acc;
        
        Account Acc1 = new Account(Name = 'Walgreen Company',AccountNumber='370337', Phoenix_Local_VIP__c=12.2,Phoenix_Preferred_Wholesaler__c = 'ABC', Phoenix_Is_Govt_Customer__c = false,Phoenix_Is_Bid_Account__c=true,Phoenix_Customer_Class_Bid_Template__c='ClarusOne');
        insert Acc1;
        
        Id testaccount =acc.id;
        
        Opportunity opp = new Opportunity(); 
        opp.Name = 'Test Record';
        opp.Vsion_Status__c = 'Opportunity in progress';
        opp.Bid_Type__c = 'Product Addition';  
        opp.Vision_Comments__c = 'Test Comments';
        opp.AccountId = Acc1.Id;
        opp.Vision_Bid_Template__c='Indirect';
        opp.Vision_Opportunity_Value__c=20;
        opp.CloseDate=System.today();
        opp.StageName='Closed Lost';
        insert opp;
        
        Opportunity opp1 = new Opportunity(); 
        opp1.Name = 'Test Record';
        opp1.Vsion_Status__c = 'Opportunity in progress';
        opp1.Bid_Type__c = 'Product Addition';  
        opp1.Vision_Comments__c = 'Test Comments';
        opp1.AccountId = Acc.Id;
        opp1.Vision_Bid_Template__c='Indirect';
        opp1.Vision_Opportunity_Value__c=20;
        opp1.CloseDate=System.today();
        opp1.StageName='Closed Lost';
        insert opp1;
        
        list < Product2 > prodList = new list < Product2 > ();
        
        Product2 prd = new Product2();
        prd.Name='Sample Product';
        prd.ProductCode='testing';
        prd.Phoenix_GPI_Generic_Product_Identifier__c='test';
        prd.Phoenix_GCN_Generic_Code_Number__c='test';
        prd.Phoenix_GCN_Sequence_Number__c='123456';
        prd.Family='Amlodipine Benazepril';
        prd.Phoenix_NDC_11__c='ndc';
        prd.Phoenix_Pkg_Size__c=20.0;
        prd.phoenix_special_product__c=true;
        prd.ProductCode='samplecode';
        
        Product2 prd1 = new Product2(Name = 'Test Product1', Phoenix_Rx_SRx_OTC__c = 'Rx', Phoenix_Special_Product__c = true, 
                                     Phoenix_GPI_Generic_Product_Identifier__c = '22222',  Phoenix_NDC_11__c = '21345678902', 
                                     Family = 'Sample Family',  IsActive = TRUE,Phoenix_GCN_Generic_Code_Number__c = '44444',
                                     Phoenix_Throughput_cost__c=10.23456576,Phoenix_Pkg_Size__c=25.0,
                                     Phoenix_GCN_Sequence_Number__c='666666',ProductCode='123456'
                                    );
        
        prodList.add(prd);
        prodList.add(prd1);
        
        Insert prodList;
        
        Competitor__c  cmp1 = new Competitor__c ();
        cmp1.name = 'test 1';
        insert cmp1;
        
        Competitor__c  cmp2 = new Competitor__c ();
        cmp2.name = 'test 2';
        insert cmp2;
        
        Competitor_Info__c  cinf2 = new Competitor_Info__c();
        //cinf2.Bid_No__c = pb.id;
        // cinf2.Product_Name__c = p2.id;
        //cinf2.Bid_Line_Item__c = bl.id;
        cinf2.NDC__c = '55111-0729-10';
        cinf2.Product_Family__c = 'Allopurinol';
        cinf2.Product_Name__c = 'Allopurinol 100mg 1000s Tabs';
        cinf2.Incumbent_Competitor_Name__c = cmp1.id;
        cinf2.Winning_Competitor_Name__c = cmp2.id;
        cinf2.Incumbent_Price_Range__c = '3';
        cinf2.Incumbent_Price_Range_2__c= '4';
        cinf2.Incumbent_Price_Range_3__c= '5';
        cinf2.Incumbent_Price_Range_4__c= '6';
        cinf2.Incumbent_Price_Range_5__c= '7';
        cinf2.Winning_Price_Range__c = '24';
        cinf2.Winning_Price_Range_2__c = '27';
        cinf2.Winning_Price_Range_3__c = '28';
        cinf2.Winning_Price_Range_4__c = '34';
        cinf2.Winning_Price_Range_5__c = '35';
        insert cinf2;
        
        
        
        List<Product_Opportunity__c> PO = new  List<Product_Opportunity__c>();
        
        Product_Opportunity__c prodopty1 = new Product_Opportunity__c(Name = 'Test Product opty', 
                                                                      NDC_11__c = '12345678902', Product_Family__c = 'Test Family',Product__c =prd.id,
                                                                      GPI_Generic_Product_Identifier__c = '222222',GCN_Generic_Code_Number__c='666666',
                                                                      Status__c = 'Matched',Pkg_Size__c=35,Vision_Opportunity_Value__c=10,GSN__c='test',
                                                                      SKU_Number__c='test',Vision_Bid_on_Highest_Pack_Size__c=true,
                                                                      Vision_Incumbent_Competitor_Info__c=cinf2.Id,
                                                                      Vision_Total_Annual_Units__c = 23455767,
                                                                      Vision_Bid_on_Alternative_Pack_Size__c=true,Opportunity__c=opp.Id
                                                                     );
        Product_Opportunity__c prodopty2 = new Product_Opportunity__c(Name = 'Test Product opty1', 
                                                                      GPI_Generic_Product_Identifier__c = '3444443',Product__c =prd1.id,
                                                                      NDC_11__c = '21345678902', Product_Family__c = 'Sample Family',
                                                                      GCN_Generic_Code_Number__c='666666',Pkg_Size__c=30,
                                                                      Vision_Total_Annual_Units__c = 23455767,
                                                                      Vision_Opportunity_Value__c=10,GSN__c='test', Vision_Incumbent_Competitor_Info__c=cinf2.Id,
                                                                      SKU_Number__c='test',Status__c = 'Matched',Vision_Bid_on_Highest_Pack_Size__c=true,
                                                                      Vision_Bid_on_Alternative_Pack_Size__c=true,Opportunity__c=opp.Id
                                                                     );
        PO.add(prodopty1);
        PO.add(prodopty2);
        Insert PO;
        String test = JSON.serialize(PO);
        
        Vision_Panorama_Queue__c vpq = new Vision_Panorama_Queue__c();
        vpq.Vision_Panorama_Unique_Identifier__c='test';
        insert vpq;
        
        Phoenix_Bid__c pb = new Phoenix_Bid__c();
        pb.Phoenix_Status__c = 'New';
        pb.Phoenix_Comments__c = 'Test Comments';
        pb.Phoenix_Customer__c = Acc.Id;
        pb.Phoenix_Customer_Bid_Deadline_Date_Time__c = DateTime.now();
        pb.Phoenix_Customer_Bid_Deadline_Time_zone__c = 'PST';
        pb.Phoenix_Customer_Bid_Deadline_Time__c = '6 PM';
        pb.Phoenix_Customer_Type__c = 'Direct and Indirect';
        pb.Phoenix_Bid_Deadline_Date__c = System.today();
        pb.Phoenix_Bid_Type__c = 'Direct Order Form Pricing Update';
        pb.Phoenix_Approval_Status__c = 'Draft';
        pb.Phoenix_Internal_Target_Date__c = system.Date.today();
        insert pb;
        
        
        Vision_OpportunityCreator.BidWrapper bwr2 = new Vision_OpportunityCreator.BidWrapper();
        bwr2.bid = pb;
        bwr2.isBidCreated = true;
        bwr2.bid.Phoenix_Bid_Type__c = 'IPA Floor Pricing Update';
        bwr2.bid.Phoenix_Customer_Type__c='ABC Pharmagen';
        
        list<string>selcntrs = new List<String>();
        
        Map<Id, Product_Opportunity__c> prdOptyMap = new Map<Id, Product_Opportunity__c>{prd.Id => prodopty1,prd1.Id=>prodopty2 };
            
            Phoenix_Contract__c Cntrct1 = new Phoenix_Contract__c();
        Cntrct1.name = 'taest cntrct 1';
        Cntrct1.Phoenix_Contract_Number__c = '3000001263';
        Cntrct1.Phoenix_Contract_Type__c='Direct';
        insert Cntrct1;
        
        Phoenix_Contract__c Cntrct2 = new Phoenix_Contract__c();
        Cntrct2.name = 'taest cntrct 2';
        Cntrct2.Phoenix_Contract_Number__c = '1000000120';
        insert Cntrct2;
        
        Phoenix_Contract__c Cntrct3 = new Phoenix_Contract__c();
        Cntrct3.name = 'taest cntrct 3';
        Cntrct3.Phoenix_Contract_Number__c = '3000000143';
        insert Cntrct3;
        
        list< Phoenix_NPR_Data__c> pnrlist  = new list< Phoenix_NPR_Data__c>();
        
        Phoenix_NPR_Data__c pnr = new Phoenix_NPR_Data__c(); 
        pnr.Phoenix_Contract__c=Cntrct1.id;
        pnr.Phoenix_NPR_Status__c='Active';
        pnr.Phoenix_Account__c=Acc.id;
        pnr.Phoenix_Contract_Number__c='3000001263';
        pnr.Phoenix_Product__c=prd.id;
        pnrlist.add(pnr);
        
        Phoenix_NPR_Data__c pnr1 = new Phoenix_NPR_Data__c();
        pnr1.Phoenix_Contract__c=Cntrct2.id;
        pnr1.Phoenix_NPR_Status__c='Active';
        pnr1.Phoenix_Account__c=Acc1.id;
        pnr1.Phoenix_Product__c=prd.id;
        pnr1.Phoenix_Contract_Type__c='Indirect';
        pnrlist.add(pnr1);
        
        Phoenix_NPR_Data__c pnr2 = new Phoenix_NPR_Data__c(); 
        pnr2.Phoenix_Contract__c=Cntrct1.id;
        pnr2.Phoenix_NPR_Status__c='Active';
        pnr2.Phoenix_Account__c=Acc1.id;
        pnr2.Phoenix_Contract_Type__c='Direct';
        pnr2.Phoenix_Contract_Number__c='3000001263';
        pnr2.Phoenix_Product__c=prd.id;
        pnrlist.add(pnr2);
        
        Phoenix_NPR_Data__c pnr3 = new Phoenix_NPR_Data__c(); 
        pnr3.Phoenix_Contract__c=Cntrct2.id;
        pnr3.Phoenix_NPR_Status__c='Active';
        pnr3.Phoenix_Account__c=Acc1.id;
        pnr3.Phoenix_Contract_Type__c='Direct';
        pnr3.Phoenix_Contract_Number__c='1000000120';
        pnr3.Phoenix_Product__c=prd.id;
        pnrlist.add(pnr3);
        
        Phoenix_NPR_Data__c pnr4 = new Phoenix_NPR_Data__c(); 
        pnr4.Phoenix_Contract__c=Cntrct3.id;
        pnr4.Phoenix_NPR_Status__c='Active';
        pnr4.Phoenix_Account__c=Acc1.id;
        pnr4.Phoenix_Contract_Type__c='Direct';
        pnr4.Phoenix_Contract_Number__c='3000000143';
        pnr4.Phoenix_Product__c=prd.id;
        pnrlist.add(pnr4);
        
        
        Insert pnrlist;
        
        map < string, list < Phoenix_NPR_Data__c >> productCodeToNPRLineMap = new map < string, list < Phoenix_NPR_Data__c >> {prd.id=>pnrlist};
            List<String> contractIds = new List<String>{Cntrct1.Id, Cntrct2.Id, Cntrct3.Id};
                
                
                
                
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
        pr.incumbentCompId3='47';
        pr.incumbentCompId4='50';
        pr.incumbentCompId5='58';
        pr.isSelected=true;
        pr.opportunityVal='23';
        pr.prdlist=prd;
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
        
        list<Vision_OpportunityCreator.wrapperBidCheck> bcList = new list<Vision_OpportunityCreator.wrapperBidCheck>();
        Vision_OpportunityCreator.wrapperBidCheck bc = new Vision_OpportunityCreator.wrapperBidCheck();
        bc.isError = false;
        bc.errorMessage='test';
        bc.bidId=pb.Id;
        bc.oppObj=opp;
        bc.optyProdObj=prodopty1;
        bc.isSelected=true;
        bcList.add(bc);
        
        string wraplist = json.serialize(bcList);
        
        Vision_OpportunityCreator.saveOptyExtProductsManual(opp.id,test);
        Vision_OpportunityCreator.saveOptyExtProductsManual('',test);
        Vision_OpportunityCreator.mapProductOpportunityRec(null,null);
        Vision_OpportunityCreator.processProductMatching(test);
        Vision_OpportunityCreator.mapUnmatchedProducts(test,test);
       // Vision_OpportunityCreator.moveUnmatchedProducts(test,test);
        
        Vision_OpportunityCreator.updateProdWithNRP( Acc.Id, contractIds,test);
        Vision_OpportunityCreator.updateProdWithNRP( Acc1.Id, contractIds,test);
        
        Vision_OpportunityCreator.handleUpdateProdWithNRPForUpload( Acc.Id, contractIds,test);
        Vision_OpportunityCreator.handleUpdateProdWithNRPForUpload( Acc1.Id, contractIds,test);
        
        Vision_OpportunityCreator.getNPRdata(Acc.Id, contractIds,prList);
        
        Vision_OpportunityCreator.productCountRecordsDetailPage(opp.Id);
        Vision_OpportunityCreator.fetchPicklistVal();
        
        Vision_OpportunityCreator.updateOptyLineTotalAnnualUnits(test);
        Vision_OpportunityCreator.updateOptyLineList(test);
        
        Vision_OpportunityCreator.moveDupToMatchPrds(opp.id,prodopty1.id);
        Vision_OpportunityCreator.moveToUnMatchPrds(opp.id, prodopty1.id);
         Vision_OpportunityCreator.movePkgDisItemToMatchPrds(opp.id,prodopty1.id);
        
        Vision_OpportunityCreator.getOpenBids(Acc.Id);
        Vision_OpportunityCreator.getAccRec(Acc.Id);
         //Vision_OpportunityCreator.saveProductData(wraplist, prodopty1.id);//,60,prodopty2.id,prd1.id);
        Vision_OpportunityCreator.getProductDetails(prd1.id,prodopty1.id);
        Vision_OpportunityCreator.removeProductLookup(prodopty1.id);
    }
    
    static testmethod void testingmethod2()
    {
        Account Acc = new Account(Name = 'Walgreen Company',AccountNumber='370337', Phoenix_Local_VIP__c=12.2,Phoenix_Preferred_Wholesaler__c = 'ABC', Phoenix_Is_Govt_Customer__c = false,Phoenix_Is_Bid_Account__c=true,Phoenix_Customer_Class_Bid_Template__c='Indirect');
        insert Acc;
        
        Account Acc1 = new Account(Name = 'Walgreen Company',AccountNumber='370337', Phoenix_Local_VIP__c=12.2,Phoenix_Preferred_Wholesaler__c = 'ABC', Phoenix_Is_Govt_Customer__c = false,Phoenix_Is_Bid_Account__c=true,Phoenix_Customer_Class_Bid_Template__c='ClarusOne');
        insert Acc1;
        
        Id testaccount =acc.id;
        
        Opportunity opp1 = new Opportunity(); 
        opp1.Name = 'Test Record';
        opp1.Vsion_Status__c = 'Opportunity in progress';
        opp1.Bid_Type__c = 'Product Addition';  
        opp1.Vision_Comments__c = 'Test Comments';
        opp1.AccountId = Acc.Id;
        opp1.Vision_Bid_Template__c='Indirect';
        opp1.Vision_Opportunity_Value__c=20;
        opp1.CloseDate=System.today();
        opp1.StageName='Closed Lost';
        insert opp1;
        
        list < Product2 > prodList = new list < Product2 > ();
        
        Product2 prd = new Product2();
        prd.Name='Sample Product';
        prd.ProductCode='testing';
        prd.Phoenix_GPI_Generic_Product_Identifier__c='test';
        prd.Phoenix_GCN_Generic_Code_Number__c='test';
        prd.Phoenix_GCN_Sequence_Number__c='123456';
        prd.Family='Amlodipine Benazepril';
        prd.Phoenix_NDC_11__c='ndc';
        prd.Phoenix_Pkg_Size__c=20.0;
        prd.phoenix_special_product__c=true;
        prd.ProductCode='samplecode';
        
        Product2 prd1 = new Product2(Name = 'Test Product1', Phoenix_Rx_SRx_OTC__c = 'Rx', Phoenix_Special_Product__c = true, 
                                     Phoenix_GPI_Generic_Product_Identifier__c = '22222',  Phoenix_NDC_11__c = '21345678902', 
                                     Family = 'Sample Family',  IsActive = TRUE,Phoenix_GCN_Generic_Code_Number__c = '44444',
                                     Phoenix_Throughput_cost__c=10.23456576,Phoenix_Pkg_Size__c=25.0,
                                     Phoenix_GCN_Sequence_Number__c='666666',ProductCode='123456'
                                    );
        
        prodList.add(prd);
        prodList.add(prd1);
        
        Insert prodList;
        
        Competitor__c  cmp1 = new Competitor__c ();
        cmp1.name = 'test 1';
        insert cmp1;
        
        Competitor__c  cmp2 = new Competitor__c ();
        cmp2.name = 'test 2';
        insert cmp2;
        

        
        Competitor_Info__c  cinf2 = new Competitor_Info__c();
        //cinf2.Bid_No__c = pb.id;
        // cinf2.Product_Name__c = p2.id;
        //cinf2.Bid_Line_Item__c = bl.id;
        cinf2.NDC__c = '55111-0729-10';
        cinf2.Product_Family__c = 'Allopurinol';
        cinf2.Product_Name__c = 'Allopurinol 100mg 1000s Tabs';
        cinf2.Incumbent_Competitor_Name__c = cmp1.id;
        cinf2.Winning_Competitor_Name__c = cmp2.id;
        cinf2.Incumbent_Price_Range__c = '3';
        cinf2.Incumbent_Price_Range_2__c= '4';
        cinf2.Incumbent_Price_Range_3__c= '5';
        cinf2.Incumbent_Price_Range_4__c= '6';
        cinf2.Incumbent_Price_Range_5__c= '7';
        cinf2.Winning_Price_Range__c = '24';
        cinf2.Winning_Price_Range_2__c = '27';
        cinf2.Winning_Price_Range_3__c = '28';
        cinf2.Winning_Price_Range_4__c = '34';
        cinf2.Winning_Price_Range_5__c = '35';
        insert cinf2;
        
        
        
        
        List<Product_Opportunity__c> PO = new  List<Product_Opportunity__c>();
        
        Product_Opportunity__c prodopty1 = new Product_Opportunity__c(Name = 'Test Product opty', 
                                                                      NDC_11__c = '12345678902', Product_Family__c = 'Test Family',Product__c =prd.id,
                                                                      GPI_Generic_Product_Identifier__c = '222222',GCN_Generic_Code_Number__c='666666',
                                                                      Status__c = 'Matched',Pkg_Size__c=25,Vision_Opportunity_Value__c=10,GSN__c='test',
                                                                      SKU_Number__c='test',Vision_Bid_on_Highest_Pack_Size__c=true,
                                                                      Vision_Incumbent_Competitor_Info__c=cinf2.Id,
                                                                      Vision_Total_Annual_Units__c = 23455767,
                                                                      Vision_Bid_on_Alternative_Pack_Size__c=true,Opportunity__c=opp1.Id
                                                                     );
        Product_Opportunity__c prodopty2 = new Product_Opportunity__c(Name = 'Test Product opty1', 
                                                                      GPI_Generic_Product_Identifier__c = '3444443',Product__c =prd1.id,
                                                                      NDC_11__c = '21345678902', Product_Family__c = 'Sample Family',
                                                                      GCN_Generic_Code_Number__c='666666',Pkg_Size__c=30,
                                                                      Vision_Total_Annual_Units__c = 23455767,
                                                                      Vision_Opportunity_Value__c=10,GSN__c='test', Vision_Incumbent_Competitor_Info__c=cinf2.Id,
                                                                      SKU_Number__c='test',Status__c = 'Matched',Vision_Bid_on_Highest_Pack_Size__c=true,
                                                                      Vision_Bid_on_Alternative_Pack_Size__c=true,Opportunity__c=opp1.Id
                                                                     );
        PO.add(prodopty1);
        PO.add(prodopty2);
        Insert PO;
        String test = JSON.serialize(PO);
        
        
        
        Phoenix_Bid__c pb = new Phoenix_Bid__c();
        pb.Phoenix_Status__c = 'New';
        pb.Phoenix_Comments__c = 'Test Comments';
        pb.Phoenix_Customer__c = Acc.Id;
        pb.Phoenix_Customer_Bid_Deadline_Date_Time__c = DateTime.now();
        pb.Phoenix_Customer_Bid_Deadline_Time_zone__c = 'PST';
        pb.Phoenix_Customer_Bid_Deadline_Time__c = '6 PM';
        pb.Phoenix_Customer_Type__c = 'Direct and Indirect';
        pb.Phoenix_Bid_Deadline_Date__c = System.today();
        pb.Phoenix_Bid_Type__c = 'Direct Order Form Pricing Update';
        pb.Phoenix_Approval_Status__c = 'Draft';
        pb.Phoenix_Internal_Target_Date__c = system.Date.today();
        insert pb;
        
        
        
        
        
        list<Vision_OpportunityCreator.wrapperBidCheck> bcList = new list<Vision_OpportunityCreator.wrapperBidCheck>();
        Vision_OpportunityCreator.wrapperBidCheck bc = new Vision_OpportunityCreator.wrapperBidCheck();
        bc.isError = false;
        bc.errorMessage='test';
        bc.bidId=pb.Id;
        bc.oppObj=opp1;
        bc.optyProdObj=prodopty1;
        bc.isSelected=true;
        bcList.add(bc);
        
        string wraplist = json.serialize(bcList);
        
        Vision_OpportunityCreator.ProductsWrapper wrapObj = new Vision_OpportunityCreator.ProductsWrapper();
        wrapObj.optyProdObj = prodopty1;
        wrapObj.expectedOptyProd = prodopty2;
        wrapObj.prodObj = prd1;
        string wrapObjString = json.serialize(wrapObj);
        
        Phoenix_Contract__c Cntrct1 = new Phoenix_Contract__c();
        Cntrct1.name = 'taest cntrct 1';
        Cntrct1.Phoenix_Contract_Number__c = '123';
        insert Cntrct1;
        
        Phoenix_Contract__c Cntrct2 = new Phoenix_Contract__c();
        Cntrct2.name = 'taest cntrct 2';
        Cntrct2.Phoenix_Contract_Number__c = '223';
        insert Cntrct2;
        
        Phoenix_Contract__c Cntrct3 = new Phoenix_Contract__c();
        Cntrct3.name = 'taest cntrct 3';
        Cntrct3.Phoenix_Contract_Number__c = '223';
        insert Cntrct3;
        
        List<String> contractIds = new List<String>{Cntrct1.Id, Cntrct2.Id, Cntrct3.Id};
            
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
        pr.isSelected=true;
        pr.opportunityVal='23';
        pr.prdlist=prd;
        pr.priceRange1='23';
        pr.priceRange2='23';
        pr.priceRange3='23';
        pr.priceRange4='23';
        pr.priceRange5='23';
        pr.priceRangeVal='24';
        pr.proposedDirectUnits=245;
        pr.proposedUnitsVal='234';
        pr.salesPriceVal='23234';
        pr.ProposedDirectEsiUnits=20;
        pr.ProposedIndirectEsiUnits=20;
        pr.ProposedDirectKrogerUnits=30;
        pr.ProposedIndirectKrogerUnits=40;
        pr.ProposedDirectRxOutreachUnits=50;
        pr.ProposedIndirectRxOutreachUnits=60;
        pr.ProposedDirectSupervaluUnits=70;
        pr.ProposedIndirectSupervaluUnits=80;
        pr.ProposedDirectCordantUnits=70;
        pr.ProposedIndirectCordantUnits=90;
        pr.ProposedDirectAccerodoUnits=10;
        pr.ProposedIndirectAccerodoUnits=30;
        pr.ProposedIndirectUnits=70;
        pr.currentAndaUnits=20;
        pr.currentWholeSalerUnits=78;
        pr.currentBaseUnits=10;
        pr.currentDshUnits=6;
        pr.currentAutoSubUnits=12;
        pr.currentOsRadUnits=77;
        pr.ProposedRadUnits=10;
        pr.ProposedOSUnits=10;
        pr.ProposedWmtUnits=10;
        pr.ProposedBaseUnits=10;
        pr.ProposedDshUnits=10;
        pr.ProposedAutosubUnits=10;
        pr.ProposedSmithDrugUnits=10;
        pr.ProposedAndaUnits=10;
        pr.ProposedDirectAholdDelhaizeUnits=10;
        pr.ProposedDirectGaintEagleUnits=10;
        pr.ProposedTotalRetailIndirectUnits=10;
        prList.add(pr);
        
        Map<String,Integer> headerMap = new Map<String,Integer>{'gui_price'=> 10};
        //Vision_OpportunityCreator.saveOptyProductsManual(JSON.serialize(opp1), prList, contractIds);
        Vision_OpportunityCreator.saveProductsToExtOpty(opp1.id, prList, contractIds);
        Vision_OpportunityCreator.saveCompInfo(cinf2, 'Allopurinol', '55111072913',  'Test Account', 'Test Product3', JSON.serialize(prodopty2.Id));
        Vision_OpportunityCreator.saveProductData(wrapObjString,opp1.id);
        Vision_OpportunityCreator.deleteContentDoc(opp1.Id);
        
    }
    
    static testmethod void testingMethod3(){
        
        Account Acc = new Account(Name = 'Walgreen Company',AccountNumber='370337', Phoenix_Local_VIP__c=12.2,Phoenix_Preferred_Wholesaler__c = 'ABC', 
                                  Phoenix_Is_Govt_Customer__c = false,Phoenix_Is_Bid_Account__c=true,Phoenix_Customer_Class_Bid_Template__c='ClarusOne');
        insert Acc;
        Opportunity opp1 = new Opportunity(); 
        opp1.Name = 'Test Record';
        opp1.Vsion_Status__c = 'Opportunity in progress';
        opp1.Bid_Type__c = 'Product Addition';  
        opp1.Vision_Comments__c = 'Test Comments';
        opp1.AccountId = Acc.Id;
        opp1.Vision_Bid_Template__c='ClarusOne';
        opp1.Vision_Opportunity_Value__c=20;
        opp1.CloseDate=System.today();
        opp1.StageName='Closed Lost';
        insert opp1;
        
        Product2 prd = new Product2();
        prd.Name='Sample Product';
        prd.ProductCode='testing';
        prd.Phoenix_GPI_Generic_Product_Identifier__c='test';
        prd.Phoenix_GCN_Generic_Code_Number__c='test';
        prd.Phoenix_GCN_Sequence_Number__c='123456';
        prd.Family='Amlodipine Benazepril';
        prd.Phoenix_NDC_11__c='ndc';
        prd.Phoenix_Pkg_Size__c=20.0;
        prd.phoenix_special_product__c=true;
        prd.ProductCode='samplecode';
        
        Product2 prd1 = new Product2(Name = 'Test Product1', Phoenix_Rx_SRx_OTC__c = 'Rx', Phoenix_Special_Product__c = true, 
                                     Phoenix_GPI_Generic_Product_Identifier__c = '22222',  Phoenix_NDC_11__c = '21345678902', 
                                     Family = 'Sample Family',  IsActive = TRUE,Phoenix_GCN_Generic_Code_Number__c = '44444',
                                     Phoenix_Throughput_cost__c=10.23456576,Phoenix_Pkg_Size__c=25.0,
                                     Phoenix_GCN_Sequence_Number__c='666666',ProductCode='123456'
                                    );
        List<Product2> prodList = new List<Product2>();
        prodList.add(prd);
        prodList.add(prd1);
        
        Insert prodList;
        
        Product_Opportunity__c prodopty1 = new Product_Opportunity__c(Name = 'Test Product opty', 
                                                                      NDC_11__c = '12345678902', Product_Family__c = 'Test Family',Product__c =prd.id,
                                                                      GPI_Generic_Product_Identifier__c = '222222',GCN_Generic_Code_Number__c='666666',
                                                                      Status__c = 'Matched',Pkg_Size__c=25,Vision_Opportunity_Value__c=10,GSN__c='test',
                                                                      SKU_Number__c='test',Vision_Bid_on_Highest_Pack_Size__c=true,
                                                                      Vision_Total_Annual_Units__c = 23455767,
                                                                      Vision_Bid_on_Alternative_Pack_Size__c=true,Opportunity__c=opp1.Id
                                                                     );
        Product_Opportunity__c prodopty2 = new Product_Opportunity__c(Name = 'Test Product opty1', 
                                                                      GPI_Generic_Product_Identifier__c = '3444443',Product__c =prd1.id,
                                                                      NDC_11__c = '21345678902', Product_Family__c = 'Sample Family',
                                                                      GCN_Generic_Code_Number__c='666666',Pkg_Size__c=30,
                                                                      Vision_Total_Annual_Units__c = 23455767,
                                                                      Vision_Opportunity_Value__c=10,GSN__c='test',
                                                                      SKU_Number__c='test',Status__c = 'Matched',Vision_Bid_on_Highest_Pack_Size__c=true,
                                                                      Vision_Bid_on_Alternative_Pack_Size__c=true,Opportunity__c=opp1.Id
                                                                     );
        List<Product_Opportunity__c> PO = new List<Product_Opportunity__c>();
        PO.add(prodopty1);
        PO.add(prodopty2);
        Insert PO;
        
        Phoenix_Contract__c Cntrct1 = new Phoenix_Contract__c();
        Cntrct1.name = 'taest cntrct 1';
        Cntrct1.Phoenix_Contract_Number__c = '123';
        insert Cntrct1;
        
        Phoenix_Contract__c Cntrct2 = new Phoenix_Contract__c();
        Cntrct2.name = 'taest cntrct 2';
        Cntrct2.Phoenix_Contract_Number__c = '223';
        insert Cntrct2;
        
        Phoenix_Contract__c Cntrct3 = new Phoenix_Contract__c();
        Cntrct3.name = 'taest cntrct 3';
        Cntrct3.Phoenix_Contract_Number__c = '223';
        insert Cntrct3;
        string accId = Acc.Id;
        
        Vision_OpportunityCreator.updateProdWithNRP(accId, new list < string > {
            Cntrct1.Id,Cntrct2.Id,Cntrct3.Id
                }, JSON.serialize(PO));
        Vision_OpportunityCreator.handleUpdateProdWithNRPForUpload(accId, new list < string > {
            Cntrct1.Id,Cntrct2.Id,Cntrct3.Id
                }, JSON.serialize(PO));
    }
}