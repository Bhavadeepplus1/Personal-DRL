@isTest
public class Vision_SendToBrightCtrl_Test_Class {
    
    static testmethod void testmethod1()
    {
        List<Account> acclist = new List<Account>{};
        Account acc= New Account();
        acc.Name='Red Oak Sourcing';
        acc.Phoenix_Is_Bid_Account__c=True;
        acc.Phoenix_Local_VIP__c=10.2;
        acc.AccountNumber = '153363';
        acc.Phoenix_Preferred_Wholesaler__c='ABC';
        acc.Phoenix_Customer_Class_Bid_Template__c='Humana';
        acc.Phoenix_Is_OTC_Customer__c=true;
        acc.Vision_is_SRx_Account__c = true;
        acc.Phoenix_Account_Cooling_Period__c = 20;
        acc.OwnerId=UserInfo.getUserId();
        acclist.add(acc);
        //Insert acc;
        
        Account acc1= New Account();
        acc1.Name='Red Oak Sourcing';
        acc1.AccountNumber='153363';
        acc1.Phoenix_Local_VIP__c=25.10;
        acc1.Phoenix_Preferred_Wholesaler__c='McKesson';
        acc1.Phoenix_Is_Bid_Account__c = true;
        acc1.Vision_is_SRx_Account__c = true;
        acclist.add(acc1);
        //Insert acc1;
        
        Account acc2= New Account();
        acc2.Name='Test Account 2';
        acc2.AccountNumber='370336';
        acc2.Phoenix_Is_Bid_Account__c=True;
        acc2.Phoenix_Local_VIP__c=10.2;
        acc2.Phoenix_Preferred_Wholesaler__c='Cardinal';
        acc2.Vision_is_SRx_Account__c = true;
        acclist.add(acc2);
        //Insert acc2;
        
        Account acc3= New Account();
        acc3.Name='Test Account 3';
        acc3.AccountNumber='370338';
        acc3.Phoenix_Is_Bid_Account__c=True;
        acc3.Phoenix_Local_VIP__c=10;
        acc3.Phoenix_Preferred_Wholesaler__c='Cardinal';
        acc3.Vision_is_SRx_Account__c = true;
        acclist.add(acc3);

        
        Account acc4= New Account();
        acc4.Name='Test Account 4';
        acc4.AccountNumber='3703379';
        acc4.Phoenix_Is_Bid_Account__c=True;
        acc4.Phoenix_Local_VIP__c=1.2;
        acc4.Phoenix_Preferred_Wholesaler__c='Cardinal';
        acc4.Vision_is_SRx_Account__c = true;
        acclist.add(acc4);
	
        insert acclist;
        
        list<Opportunity> opptylist = new list<Opportunity>{};
        Opportunity opp = New Opportunity ();
        opp.AccountId= acc.Id;
        opp.Name='Test Opportunity';
        opp.CloseDate=System.today();
        opp.StageName='Closed Lost';
        opp.Vision_Reference_Contract__c='Testing';
        opptylist.add(opp);
        Insert opp;
        
        Opportunity opp2 = New Opportunity ();
        opp2.AccountId= acc1.Id;
        opp2.Name='Test Opportunity';
        opp2.CloseDate=System.today();
        opp2.StageName='Closed Lost';
        opp2.Vision_Reference_Contract__c='Testing';
        opptylist.add(opp2);
        Insert opp2;
        
        Opportunity opp3 = New Opportunity ();
        opp3.AccountId= acc1.Id;
        opp3.Name='Test Opportunity';
        opp3.CloseDate=System.today();
        opp3.StageName='Closed Lost';
        opp3.Vision_Reference_Contract__c='Testing';
        opptylist.add(opp3);
        Insert opp3;
        
        List<Phoenix_Contract__c> Ctlist  = new List<Phoenix_Contract__c>();
        Phoenix_Contract__c ct = new Phoenix_Contract__c ();
        ct.Phoenix_Contract_Number__c='122456';
        ct.Phoenix_Contract_Start_Date__c=Date.newInstance(2022, 02, 21);
        ct.Phoenix_Contract_End_Date__c=system.today();
        
        ctlist.add(ct);
        Phoenix_Contract__c ct1 = new Phoenix_Contract__c ();
        ct1.Phoenix_Contract_Number__c=null;
        ct1.Phoenix_Contract_Start_Date__c=Date.newInstance(2022, 02, 21);
        ct1.Phoenix_Contract_End_Date__c=system.today();
        
        ctlist.add(ct1);
        insert ctlist;
        
        Phoenix_Bid__c bid = new Phoenix_Bid__c();
        bid.Phoenix_Customer__c=acc.Id;
       
        bid.Phoenix_Approval_Status__c='Draft';
        bid.Phoenix_Bid_Type__c='IPA Floor Pricing Update';
        bid.Phoenix_Customer_Type__c='ABC Pharmagen';
        Insert bid;
        
        Phoenix_Bid__c bid1 = new Phoenix_Bid__c();
        bid1.Phoenix_Customer__c=acc1.Id;
        bid1.Phoenix_Approval_Status__c='Draft';
        bid1.Phoenix_Bid_Type__c='RXSS';
        bid1.Phoenix_Customer_Type__c='ROS';
        Insert bid1;
        
        Phoenix_Bid__c bid2 = new Phoenix_Bid__c();
        bid2.Phoenix_Customer__c=acc1.Id;
        bid2.Phoenix_Approval_Status__c='Draft';
        bid2.Phoenix_Bid_Type__c='Direct Order Form Pricing Update';
        bid2.Phoenix_Customer_Type__c='ClarusOne';
        Insert bid2;
        
        Phoenix_Bid__c bid3 = new Phoenix_Bid__c();
        bid3.Phoenix_Customer__c=acc1.Id;
        bid3.Phoenix_Approval_Status__c='Draft';
        bid3.Phoenix_Bid_Type__c='Short Dated OTB';
        bid3.Phoenix_Customer_Type__c='RXSS';
        Insert bid3;
        
        Phoenix_Bid__c bid4 = new Phoenix_Bid__c();
        bid4.Phoenix_Customer__c=acc.Id;
        bid4.Phoenix_Approval_Status__c='Draft';
        bid4.Phoenix_Bid_Type__c='Platform OTB';
        bid4.Phoenix_Customer_Type__c='BASE/DSH';
        Insert bid4;
        
        Phoenix_Bid__c bid5 = new Phoenix_Bid__c();
        bid5.Phoenix_Customer__c=acc.Id;
        bid5.Phoenix_Customer_Type__c='ROS';
        Insert bid5;
        Phoenix_Bid__c bid6 = new Phoenix_Bid__c();
        bid5.Phoenix_Customer__c=acc.Id;
        bid5.Phoenix_Customer_Type__c='Econdisc';
        Insert bid6;
        
        
        List<Phoenix_Bid_Fee_Master__c> bfeelist= new List<Phoenix_Bid_Fee_Master__c>();
        Phoenix_Bid_Fee_Master__c bfee= new Phoenix_Bid_Fee_Master__c();
        bfee.Phoenix_Customer__c=acc.id;
        bfee.Phoenix_Customer_Type__c='Govt business';
        bfee.Phoenix_Preferred_Wholesaler__c = 'ABC';
        bfee.Phoenix_Fee__c=10.2;
        bfee.Phoenix_Fee_Type__c='RDC/NLC %';
        bfeelist.add(bfee);
        
        Phoenix_Bid_Fee_Master__c bfee1= new Phoenix_Bid_Fee_Master__c();
        bfee1.Phoenix_Customer__c=acc1.id;
        bfee1.Phoenix_Customer_Type__c='Non Govt business';
        bfee1.Phoenix_Fee__c=10.2;
        bfee1.Phoenix_Preferred_Wholesaler__c = 'McKesson';
        bfee1.Phoenix_Fee_Type__c='RDC/NLC %';
        bfeelist.add(bfee1);
        
        Insert bfeelist;
        
        
        List<Product_Family__c> famlist = new list<Product_Family__c>{};
        Product_Family__c prodfam1 = new Product_Family__c();
        prodfam1.Name = 'CETIRIZINE';
        prodfam1.Family_Group__c = 'OTC CETIRIZINE';
        prodfam1.Old_Reference_Name__c ='Cetirizine';
        prodfam1.Vision_Segment__c = 'OTC';
        prodfam1.Vision_IsActive__c = true;
        famlist.add(prodfam1);
        
        Product_Family__c prodfam2 = new Product_Family__c();
        prodfam2.Name = 'LORATADINE ODT';
        prodfam2.Family_Group__c = 'LORATADINE ODT';
        prodfam2.Vision_Segment__c = 'OTC';
        prodfam2.Vision_IsActive__c = true;
        famlist.add(prodfam2);
        
        insert famlist;
        
        
        list < Product2 > prodList = new list < Product2 > ();
        Product2 prod1 = new Product2(Name = 'Albertsons Cetirizine Tablet 120ct', Phoenix_Rx_SRx_OTC__c = 'Rx', Phoenix_Special_Product__c = true, 
                                      Phoenix_GPI_Generic_Product_Identifier__c = '11111', Phoenix_NDC_11__c = '12345678902',
                                      Family = 'Test Family', IsActive = TRUE, Phoenix_Is_Private_Label_OTC__c =true,
                                      Phoenix_Throughput_cost__c=10.23456576,Phoenix_GCN_Generic_Code_Number__c = '44444',
                                      Phoenix_GCN_Sequence_Number__c='666666',Phoenix_Pkg_Size__c=25.0,ProductCode='123456',
                                 	  OTC_Customer__c = acc.Id,Phoenix_Is_Control_Label__c = false,
                                      Product_Family__c = prodfam1.Id
                                     );
        
        Product2 prod2 = new Product2(Name = 'Test Product1', Phoenix_Rx_SRx_OTC__c = 'Rx', Phoenix_Special_Product__c = true, Phoenix_GPI_Generic_Product_Identifier__c = '22222',
                                      Phoenix_NDC_11__c = '21345678902', Family = 'Sample Family', IsActive = TRUE,Phoenix_GCN_Generic_Code_Number__c = '44444',
                                      Phoenix_Throughput_cost__c=10.23456576,Phoenix_Pkg_Size__c=25.0,Phoenix_GCN_Sequence_Number__c='666666',ProductCode='123456',Phoenix_Is_Private_Label_OTC__c =false,
                                      Product_Family__c = prodfam2.Id
                                     );
        
        Product2 prod3 = new Product2(Name = 'Test Product 3', Phoenix_Rx_SRx_OTC__c = 'Rx', Phoenix_Special_Product__c = true, Phoenix_GPI_Generic_Product_Identifier__c = '22222',
                                      Phoenix_NDC_11__c = '21345678902', Family = 'Sample Family', IsActive = TRUE,Phoenix_GCN_Generic_Code_Number__c = '44444',
                                      Phoenix_Throughput_cost__c=10.23456576,Phoenix_Pkg_Size__c=25.0,Phoenix_GCN_Sequence_Number__c='666666',ProductCode='123456',Phoenix_Is_Private_Label_OTC__c =false,
                                      Product_Family__c = prodfam2.Id
                                     );
        prodList.add(prod3);
        
        prodList.add(prod1);
        prodList.add(prod2);
        system.debug(prod1.Product_Family__c);
        Insert prodList;
        
        
        GCP_100PCT_Analysis_SKU__c unique = new GCP_100PCT_Analysis_SKU__c();
        unique.Vision_Product__c = prod3.Id;
        unique.Vision_Updated_date__c = system.today();
        unique.Vision_Product__c = prod3.Id;
        unique.DRL_Act_Price__c = 1;
        unique.DRL_Act_Sales__c = 2;
        unique.drl_act_volume_eu__c = 2;    
        unique.DRL_Act_Tpt__c = 2;    
        unique.GCP_Product_Family__c = 'CETIRIZINE';   
        unique.DRL_Act_Tpt_Pct__c = 2;
        
        insert unique;
        
        
      //  Vision_Market_Share_Expansion__c vmse= new Vision_Market_Share_Expansion__c();
        //Insert vmse;
        
        List<Product_Opportunity__c> optyProdList = new List<Product_Opportunity__c> ();
        Product_Opportunity__c prodopty1 = new Product_Opportunity__c();
        prodopty1.Name = 'Test Product opty';
        prodopty1.Opportunity__c=opp.Id;
        prodopty1.Product__c=prod1.Id;
        prodopty1.Secondary_Backup_Exclusion_Customers__c ='Text Product Opportunity' ;
        prodopty1.Final_Exclusion_Customers__c = 'Test Product Opportunity';
        prodopty1.Proposed_Direct_Selling_Units__c = 1;
        prodopty1.Proposed_Indirect_Selling_Units__c = 2;
        //prodopty1.Vision_Update_Date__c = system.today();
        prodopty1.Vision_Proposed_OS_Units__c = 1;
        prodopty1.Vision_Proposed_RAD_Units__c = 1;
        prodopty1.Vision_Proposed_WMT_Units__c =1;
        prodopty1.Vision_Proposed_BASE_Units__c = 1;
        prodopty1.Vision_Proposed_DSH_Units__c = 2;    
        prodopty1.Vision_Proposed_AutoSub_Units__c = 1;    
        prodopty1.Vision_Proposed_Smith_Drug_Units__c =1;    
        prodopty1.Vision_Proposed_Anda_Units__c =1;  
        prodopty1.Vision_Proposed_DirectAholdDelhaizeUnits__c =1;   
        prodopty1.Vision_Proposed_Direct_Gaint_Eagle_Units__c =1;    
        prodopty1.Vision_Proposed_TotalRetailIndirectUnits__c= 1;    
        prodopty1.Vision_Proposed_Direct_ESI_Units__c = 2;   
        prodopty1.Vision_Proposed_Indirect_ESI_Units__c = 1;
        prodopty1.Vision_Proposed_Direct_Kroger_Units__c =2;
        prodopty1.Vision_Proposed_Indirect_Kroger_Units__c =1;
        prodopty1.Vision_Proposed_Direct_Rx_Outreach_Units__c =2;
        prodopty1.Vision_Proposed_IndirectRxOutreach_Units__c =1;
        prodopty1.Vision_Proposed_Direct_Supervalu_Units__c =2;
        prodopty1.Vision_Proposed_Indirect_Supervalu_Units__c =1;
        prodopty1.Vision_Proposed_Direct_Cordant_Units__c =1;
        prodopty1.Vision_Proposed_Indirect_Cordant_Units__c =2;
        prodopty1.Vision_Proposed_Direct_Accerodo_Units__c=1;
        prodopty1.Vision_Proposed_Indirect_Accerodo_Units__c=2;
        prodopty1.Vision_Proposed_CVS_Direct_Units__c=1;    
        prodopty1.Vision_Proposed_CVS_Indirect_Units__c=2;    
        prodopty1.Vision_Proposed_Cardinal_Units__c =1;    
        prodopty1.Vision_Proposed_Major_Units__c=2;    
        prodopty1.Vision_Proposed_Indirect_Cigna_Units__c=1;    
        prodopty1.Vision_Proposed_Direct_Cigna_Units__c=2;
        prodopty1.Vision_Total_Annual_Units__c = 1000;
       // prodopty1.Market_Share_Expansion__c=vmse.Id;
        prodopty1.Status__c='Matched';
        prodopty1.vision_is_discrepancy_product__c=False;
        optyProdList.add(prodopty1);
        
        
        Product_Opportunity__c prodopty2 = new Product_Opportunity__c();
        prodopty2.Name = 'Test Product opty2';
        prodopty2.Opportunity__c=opp2.Id;
        prodopty2.Product__c=prod2.Id;
        prodopty2.Secondary_Backup_Exclusion_Customers__c ='Text Product Opportunity 2 ' ;
        prodopty2.Final_Exclusion_Customers__c = 'Test Product Opportunity 2';
       // prodopty2.Market_Share_Expansion__c=vmse.Id;
        prodopty2.Status__c='Matched';
        prodopty2.vision_is_discrepancy_product__c=False;
        prodopty2.Proposed_Direct_Selling_Units__c = 1;
        prodopty2.Proposed_Indirect_Selling_Units__c = 2;
        prodopty2.Vision_Proposed_OS_Units__c = 1;
        prodopty2.Vision_Proposed_RAD_Units__c = 1;
        prodopty2.Vision_Proposed_WMT_Units__c =1;
        prodopty2.Vision_Proposed_BASE_Units__c = 1;
        prodopty2.Vision_Proposed_DSH_Units__c = 2;    
        prodopty2.Vision_Proposed_AutoSub_Units__c = 1;    
        prodopty2.Vision_Proposed_Smith_Drug_Units__c =1;    
        prodopty2.Vision_Proposed_Anda_Units__c =1;  
        prodopty2.Vision_Proposed_DirectAholdDelhaizeUnits__c =1;   
        prodopty2.Vision_Proposed_Direct_Gaint_Eagle_Units__c =1;    
        prodopty2.Vision_Proposed_TotalRetailIndirectUnits__c= 1;    
        prodopty2.Vision_Proposed_Direct_ESI_Units__c = 2;   
        prodopty2.Vision_Proposed_Indirect_ESI_Units__c = 1;
        prodopty2.Vision_Proposed_Direct_Kroger_Units__c =2;
        prodopty2.Vision_Proposed_Indirect_Kroger_Units__c =1;
        prodopty2.Vision_Proposed_Direct_Rx_Outreach_Units__c =2;
        prodopty2.Vision_Proposed_IndirectRxOutreach_Units__c =1;
        prodopty2.Vision_Proposed_Direct_Supervalu_Units__c =2;
        prodopty2.Vision_Proposed_Indirect_Supervalu_Units__c =1;
        prodopty2.Vision_Proposed_Direct_Cordant_Units__c =1;
        prodopty2.Vision_Proposed_Indirect_Cordant_Units__c =2;
        prodopty2.Vision_Proposed_Direct_Accerodo_Units__c=1;
        prodopty2.Vision_Proposed_Indirect_Accerodo_Units__c=2;
        prodopty2.Vision_Proposed_CVS_Direct_Units__c=1;    
        prodopty2.Vision_Proposed_CVS_Indirect_Units__c=2;    
        prodopty2.Vision_Proposed_Cardinal_Units__c =1;    
        prodopty2.Vision_Proposed_Major_Units__c=2;    
        prodopty2.Vision_Proposed_Indirect_Cigna_Units__c=1;    
        prodopty2.Vision_Proposed_Direct_Cigna_Units__c=2;
        
       // prodopty1.Market_Share_Expansion__c=vmse.Id;
        prodopty2.Status__c='Matched';
        prodopty2.vision_is_discrepancy_product__c=False;
        optyProdList.add(prodopty2);
        
        Product_Opportunity__c prodopty3 = new Product_Opportunity__c();
        prodopty3.Name = 'Test Product opty2';
        prodopty3.Opportunity__c=opp2.Id;
        prodopty3.Product__c=prod2.Id;
        prodopty3.Secondary_Backup_Exclusion_Customers__c ='Text Product Opportunity 2 ' ;
        prodopty3.Final_Exclusion_Customers__c = 'Test Product Opportunity 2';
       // prodopty2.Market_Share_Expansion__c=vmse.Id;
        prodopty3.Status__c='Matched';
        
        List<Product_Opportunity__c> otheroptyProdList = new List<Product_Opportunity__c> ();
        otheroptyProdList.add(prodopty3); 
        
        insert optyProdList;
        
        string query = 'SELECT GCP_Product_Family__r.Name,Product__r.Id, Product__r.Name, Product__r.ProductCode, Product__r.Phoenix_NDC_11__c, Product__r.Family, Product__r.Phoenix_Is_New_Product__c, '+
                +'Product__r.Phoenix_Lowest_Price_SKU__c, Product__r.Phoenix_Strength__c, Product__r.Phoenix_Pkg_Size__c, Product__r.Phoenix_Is_Private_Label_OTC__c, Product__r.Phoenix_Rx_SRx_OTC__c,'+
                +' Product__r.Phoenix_WAC__c, Product__r.Phoenix_Product_Director__r.Name, Vision_Bid_Line_Item__r.Phoenix_Bid__r.Id, Product__r.Phoenix_Is_Control_Label__c,Product__r.Product_Family__c,'+
                +' Vision_Bid_Line_Item__r.Phoenix_Bid__r.Name, Vision_Bid_Line_Item__r.Phoenix_Bid__r.Phoenix_Bid_Name__c, Market_Share_Expansion__r.Task_Status__c,'+
                +' Vision_Bid__r.Phoenix_Bid_Name__c, Vision_Bid__r.Name, '+Phoenix_Util.getsObjectFieds('Product_Opportunity__c')+' FROM Product_Opportunity__c'+
                +' WHERE Id in : optyProdList ';
        optyProdList = Database.query(query);
        
        
        string opprdtids = String.valueOf(prodopty1.id)+','+String.valueOf(prodopty2.Id); 
        string accids = String.valueOf(acc.Id)+'-'+String.valueOf(acc1.Id);
        
        
        List<Phoenix_NPR_Data__c> nprdtlist = new  List<Phoenix_NPR_Data__c>();
        Phoenix_NPR_Data__c  npdata = new Phoenix_NPR_Data__c();
        npdata.Phoenix_Account__c=acc.Id;
        npdata.Phoenix_Contract__c=ctlist[0].id;
        npdata.Phoenix_NPR_Status__c = 'Active';
        npdata.Phoenix_Product__c=prodlist[0].id;
        npdata.Phoenix_12Months_Actual_Sales_Unit__c=20.00;
        npdata.Phoenix_12Months_Net_Sales__c=250.00;
        npdata.Phoenix_12Months_Sales_Unit__c=25.00;
        npdata.Phoenix_12Mt_Sales_Ut_Actual__c=22.0;
        nprdtlist.add(npdata);
        
        Phoenix_NPR_Data__c  npdata1 = new Phoenix_NPR_Data__c();
        npdata1.Phoenix_Account__c=acc1.Id;
        npdata1.Phoenix_Contract__c=ctlist[1].id;
        npdata1.Phoenix_Product__c=prodlist[1].id;
        npdata1.Phoenix_NPR_Status__c = 'Active';
        npdata1.Phoenix_Contract_Number__c = '3000000957';
        npdata1.Phoenix_Contract_Type__c = 'Indirect';
        npdata1.Phoenix_12Months_Actual_Sales_Unit__c=22.00;
        npdata1.Phoenix_12Months_Net_Sales__c=250.00;
        npdata1.Phoenix_12Months_Sales_Unit__c=30.00;
        npdata1.Phoenix_12Mt_Sales_Ut_Actual__c=25.0;
        nprdtlist.add(npdata1);
        
        
        insert nprdtlist;
        
        Vision_SendToBrightCtrl.BidWrapper bw = new Vision_SendToBrightCtrl.BidWrapper();
        bw.bid = bid;
        bw.isBidCreated=true;
        Vision_SendToBrightCtrl.BidWrapper bw1 = new Vision_SendToBrightCtrl.BidWrapper();
        bw1.bid = bid5;
        bw1.isBidCreated=true;
        
        Vision_SendToBrightCtrl.wrapperBidCheck wbc= new Vision_SendToBrightCtrl.wrapperBidCheck();
        wbc.errorMessage='test message';
        wbc.isAwarded=false;
        wbc.isSelected=false;
        wbc.oppObj=opp;
        wbc.optyProdObj=prodopty1;
        
        list<Phoenix_Inclusion_Contract_Pharmabid__c> contrctbidlist = new list<Phoenix_Inclusion_Contract_Pharmabid__c>{};

        Phoenix_Inclusion_Contract_Pharmabid__c  contrtbid = new Phoenix_Inclusion_Contract_Pharmabid__c();
        contrtbid.Customer_Name__c = acc.id;
        contrtbid.Group_Customer_Name__c = acc.Id;
        contrtbid.Group_Customer_Number__c = '12345';
        contrtbid.Contract_Number__c = '12345';
        contrctbidlist.add(contrtbid);
        

        
        Phoenix_Inclusion_Contract_Pharmabid__c  contrtbid1 = new Phoenix_Inclusion_Contract_Pharmabid__c();
        contrtbid1.Customer_Name__c = acc1.id;
        contrtbid1.Group_Customer_Name__c = acc1.Id;
        contrtbid1.Group_Customer_Number__c = '12345';
        contrtbid1.Contract_Number__c = '12345';
        contrctbidlist.add(contrtbid1);
        
        Phoenix_Inclusion_Contract_Pharmabid__c  contrtbid2 = new Phoenix_Inclusion_Contract_Pharmabid__c();
        contrtbid2.Customer_Name__c = acc3.id;
        contrtbid2.Group_Customer_Name__c = acc3.Id;
        contrtbid2.Group_Customer_Number__c = '123456';
        contrtbid2.Contract_Number__c = '12345';
        contrctbidlist.add(contrtbid2);
        
        Phoenix_Inclusion_Contract_Pharmabid__c  contrtbid3 = new Phoenix_Inclusion_Contract_Pharmabid__c();
        contrtbid3.Customer_Name__c = acc4.id;
        contrtbid3.Group_Customer_Name__c = acc4.Id;
        contrtbid3.Group_Customer_Number__c = '1234567';
        contrtbid3.Contract_Number__c = '1234567';
        contrctbidlist.add(contrtbid3);
        

        insert contrctbidlist;

        
        List<String> custnames = new list<String>{acc.Name,acc1.Name,acc2.Name};
        List<String> nonselectcustnames = new list<String>{acc3.Name,acc4.Name};
            
        
		LIst<GCP_SFDC_100pct_Analysis_SKU__c> gcplist = new list<GCP_SFDC_100pct_Analysis_SKU__c>{};
        GCP_SFDC_100pct_Analysis_SKU__c gcpanlys1 = new GCP_SFDC_100pct_Analysis_SKU__c(); 
        gcpanlys1.Vision_Customer__c = acc.id;
        gcpanlys1.Vision_Product__c = prod1.id;
        gcpanlys1.Vision_Cardinal_CustAct_Sales__c = 10000;
        gcpanlys1.Vision_Cardinal_CustAct_Volume__c =1;
        gcpanlys1.Vision_Cardinal_Share_Vol__c = 2;
        gcpanlys1.Vision_Cardinal_VolShare_Percent__c = 90;
        gcpanlys1.Vision_Cooling_Period__c = 10;
        gcpanlys1.Vision_Cooling_Period_String__c = 'test';
        gcpanlys1.Vision_Current_Position__c = 'test rec';
        gcpanlys1.Vision_CVS_CustAct_Sales__c =2;
        gcpanlys1.Vision_CVS_CustAct_Volume__c = 12;
        gcpanlys1.Vision_CVS_Share_Vol__c = 10;
        gcpanlys1.Vision_CVS_VolShare_Percent__c = 10;
        gcpanlys1.Vision_doesPositionExists__c = true;
        gcpanlys1.Vision_Estimate_Account_Total_Vol_EU__c = 10;
        gcpanlys1.Vision_COGS_Per_Unit__c = 10;
        gcpanlys1.Vision_Cust_Act_Sales_Mat__c =10;
        gcpanlys1.GCP_Cust_Act_Volume_Mat_Eu__c =1;
        gcpanlys1.Vision_Customer_Code__c = 1;
        //gcpanlys1.Vision_Customer_Name__c = 'tst';
        gcpanlys1.Vision_Customer_SFID__c = 'test record';
        gcpanlys1.Vision_Drl_Act_Price__c = 12;
        gcpanlys1.Vision_Drl_Act_Sales__c = 1;
        gcpanlys1.Vision_DRL_Act_Tpt__c = 10;
        gcpanlys1.GCP_Product_Family__c = 'Test Family';
        gcpanlys1.Vision_Drl_Act_Tpt_Pct__c = 10;   
        gcpanlys1.Vision_DRL_Act_Volume_Eu__c = 1;    
        gcpanlys1.Vision_SKU_Code__c = 'ABC';   
        gcpanlys1.Vision_Suggested_Price__c = 100;    
        gcpanlys1.Vision_Unique_Identifier__c = 'ABC123';
        gcpanlys1.Vision_Major_Share_Vol__c = 12;
        gcpanlys1.Vision_Major_VolShare_Percent__c = 2;
        gcpanlys1.Vision_McKesson_Vol__c = 0;    
        gcpanlys1.Vision_McKesson_Vol_Share__c = 1;    
        gcpanlys1.Vision_NorthStar_Vol__c = 1;    
        gcpanlys1.Vision_NorthStar_Vol_Share__c = 2;    
        gcpanlys1.Vision_Rite_Aid_Vol__c = 2;    
        gcpanlys1.Vision_Rite_Aid_Vol_Share__c = 1;   
        gcpanlys1.Vision_User_Input_Estimate_Vol__c = 1;
        gcpanlys1.Vision_Contract_Type__c = 'Direct';
        gcpanlys1.Vision_Estimate_Vol_Method__c = 'Full Line Volume';    
        gcpanlys1.Vision_WalMart_Vol__c = 1;   
        gcpanlys1.Vision_WalMart_Vol_Share__c =1;
        gcpanlys1.Vision_Estimate_Account_Total_Vol_EU__c = 100;
        gcplist.add(gcpanlys1);
        
        GCP_SFDC_100pct_Analysis_SKU__c gcpanlys2 = new GCP_SFDC_100pct_Analysis_SKU__c(); 
        gcpanlys2.Vision_Customer__c = acc.id;
        gcpanlys2.Vision_Product__c = prod2.id;
        
        GCP_SFDC_100pct_Analysis_SKU__c gcpanlys3 = new GCP_SFDC_100pct_Analysis_SKU__c(); 
        gcpanlys3.Vision_Customer__c = acc.id;
        //gcpanlys3.Vision_Product__c = prod2.id;
        gcplist.add(gcpanlys3);
        
        insert gcplist;
        
        
        
        /*  JSONGenerator gen = JSON.createGenerator(true);
gen.writeObject(wbc);
String jsonRepresentation = gen.getAsString();
system.debug('this is our debuf log====='+jsonRepresentation);*/
        
        String tt ='[{"showAddToBidButton":false,"refContractList":null, "optyProdObj":{"attributes":{"type":"Product_Opportunity__c","url":"/services/data/v54.0/sobjects/Product_Opportunity__c/a187c000003VPBNAA4"},"Name":"Test Product opty","Opportunity__c":"0067c00000E8CzQAAV","Product__c":"01t7c000006ULqtAAG"}}]';
        
        list<string>selcntrs = new List<String>();
        
        Map<Id,Product_Opportunity__c> prdOptyItems=new Map<Id,Product_Opportunity__c> {prod1.Id=>prodopty1};
            
        Vision_SendToBrightCtrl.getOptyProd(opp.Id);
        Vision_SendToBrightCtrl.getOptyProd(acc.Id);
        
        Vision_SendToBrightCtrl.deleteOptyProd(opp.Id);
        Vision_SendToBrightCtrl.getOpenBids(acc.Id,'Contracts Only');
        
        Vision_SendToBrightCtrl.addBidLinesToBid(bid, optyProdList, 'Contracts Only', true);
        Vision_SendToBrightCtrl.addBidLinesToBid(bid1, optyProdList, 'Contracts Only', true);
        Vision_SendToBrightCtrl.addBidLinesToBid(bid2, optyProdList, 'Contracts Only', true);
        Vision_SendToBrightCtrl.addBidLinesToBid(bid3, optyProdList, 'Contracts Only', true);
        Vision_SendToBrightCtrl.addBidLinesToBid(bid4, optyProdList, 'Contracts Only', true);
        Vision_SendToBrightCtrl.addBidLinesToBid(bid5, optyProdList, 'Contracts Only', true);
        
        
        Vision_SendToBrightCtrl.sendToBrightExistingBid(opp.Id,bid.Id, tt);
        Vision_SendToBrightCtrl.sendToBrightFunc(opp.Id,tt, 'ClarusOne',false);
        
        //Vision_SendToBrightCtrl.savequoteitems(prodList, bw, selcntrs, prdOptyItems,'test');
        //Vision_SendToBrightCtrl.savequoteitems(prodList, bw, selcntrs, prdOptyItems,'ClarusOne');
        // Vision_SendToBrightCtrl.savequoteitems(prodList, bw1, selcntrs, prdOptyItems,'ClarusOne');
        //Vision_SendToBrightCtrl.saveOptyDetPageChanges(opp.Id,prodopty1);
        Vision_SendToBrightCtrl.getOptyLinesAndCon(opp.Id);
        Vision_SendToBrightCtrl.getOptyLinesAndCon(acc.Id);
        Vision_SendToBrightCtrl.fetchNprtData(optyProdList,ctlist,'otcCx');
        Vision_SendToBrightCtrl.fetchNprtData(optyProdList,ctlist,'Indirect');
        Vision_SendToBrightCtrl.fetchNprtData(optyProdList,ctlist,'ABC Pharmagen');
        Vision_SendToBrightCtrl.fetchNprtData(optyProdList,ctlist,'Direct');
        Vision_SendToBrightCtrl.fetchNprtData(optyProdList,ctlist,'ClarusOne');
        Vision_SendToBrightCtrl.fetchNprtData(optyProdList,ctlist,'RXSS');
        Vision_SendToBrightCtrl.fetchNprtData(optyProdList,ctlist,'BASE/DSH');
        Vision_SendToBrightCtrl.fetchNprtData(optyProdList,ctlist,'ROS');
        Vision_SendToBrightCtrl.getContracts(acc1.id);
        Vision_SendToBrightCtrl.saveOptyWithContracts(selcntrs,opp.id);
        Vision_SendToBrightCtrl.updateOptyCmnt(opp);
        
		Test.startTest();
        Vision_SendToBrightCtrl.syncUnitsToAnalysis(opprdtids);
        Vision_SendToBrightCtrl.syncUnitsToAnalysis(accids);
        
        Vision_SendToBrightCtrl.saveCustomers(custnames,nonselectcustnames,prodopty1.id,opp.id);
        
        Vision_SendToBrightCtrl.updateInAnalysisClass(optyProdList, true);
        Vision_SendToBrightCtrl.updateInAnalysisClass(otheroptyProdList, true);
        Vision_SendToBrightCtrl.updateInAnalysisClass(optyProdList, false);
        
        Vision_SendToBrightCtrl.showSecondaryCustomers(prod1.id);
        Test.stopTest();
        
    }
    static testmethod void testmethod2(){
        Account acc= New Account();
        acc.Name='Walgreen Company';
        acc.AccountNumber='370337';
        acc.Phoenix_Is_Bid_Account__c=True;
        acc.Phoenix_Local_VIP__c=10.2;
        acc.Phoenix_Preferred_Wholesaler__c='McKesson';
        acc.Phoenix_Customer_Class_Bid_Template__c='Humana';
        acc.Phoenix_Is_OTC_Customer__c=true;
        
        acc.OwnerId=UserInfo.getUserId();
        Insert acc;
        
        Opportunity opp = New Opportunity ();
        opp.AccountId= acc.Id;
        opp.Name='Test Opportunity';
        opp.CloseDate=System.today();
        opp.StageName='Closed Lost';
        opp.Vision_Reference_Contract__c='Testing';
        Insert opp;
        
        Phoenix_Bid__c bid5 = new Phoenix_Bid__c();
        bid5.Phoenix_Customer__c=acc.Id;
        bid5.Phoenix_Approval_Status__c='Draft';
        bid5.Phoenix_Bid_Type__c='Platform OTB';
        bid5.Phoenix_Customer_Type__c='Costco';
        Insert bid5;
        
        Phoenix_Bid__c bid6 = new Phoenix_Bid__c();
        bid6.Phoenix_Customer__c=acc.Id;
        bid6.Phoenix_Approval_Status__c='Draft';
        bid6.Phoenix_Bid_Type__c='Platform OTB';
        bid6.Phoenix_Customer_Type__c='ABC Pharmagen';
        Insert bid6;
        
        
        Product_Family__c famObj = new Product_Family__c(Name='testFamily');
        insert famObj;
        Product2 prod1 = new Product2(Name = 'Test Product', Phoenix_Rx_SRx_OTC__c = 'Rx', Phoenix_Special_Product__c = true, Product_Family__c = famObj.Id);
        Insert prod1;
        
        Phoenix_GCP_Opportunity_Tracker__c gcpObj = new Phoenix_GCP_Opportunity_Tracker__c(Product_Family__c = famObj.Id,Phoenix_Customer__c=acc.Id);
        gcpObj.Vision_isRelevance__c = true;
        gcpObj.Vision_Inline_RFP_Units__c = 2;
        gcpObj.Phoenix_Est_Acct_Vol_Method__c = 'Use User Input';
        gcpObj.Vision_Sum_of_Sku_est_vol__c = 2;
        insert gcpObj;
        
       // Vision_Market_Share_Expansion__c vmse= new Vision_Market_Share_Expansion__c();
//Insert vmse;
        
        List<Product_Opportunity__c> optyProdList = new List<Product_Opportunity__c> (); 
        Product_Opportunity__c prodopty1 = new Product_Opportunity__c();
        prodopty1.Name = 'Test Product opty';
        prodopty1.Opportunity__c=opp.Id;
        prodopty1.Product__c=prod1.Id;
       // prodopty1.Market_Share_Expansion__c=vmse.Id;
        optyProdList.add(prodopty1);
        
        Insert optyProdList;
        String tt1 ='[{"showAddToBidButton":false,"refContractList":null, "optyProdObj":{"attributes":{"type":"Product_Opportunity__c","url":"/services/data/v54.0/sobjects/Product_Opportunity__c/a187c000003VPBNAA4"},"Name":"Test Product opty","Opportunity__c":"0067c00000E8CzQAAV","Product__c":"01t7c000006ULqtAAG"}}]';
        Vision_SendToBrightCtrl.getOptyProd(null);
        Vision_SendToBrightCtrl.addBidLinesToBid(bid5, optyProdList, 'Contracts Only', true);
        Vision_SendToBrightCtrl.addBidLinesToBid(bid6, optyProdList, 'Contracts Only', true);
        Vision_SendToBrightCtrl.getOptyLinesAndCon(opp.id);
        Vision_SendToBrightCtrl.sendToBrightFunc(opp.Id,tt1, 'ClarusOne',false);
    }
}