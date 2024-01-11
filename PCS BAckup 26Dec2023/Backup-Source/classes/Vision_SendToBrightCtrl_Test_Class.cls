@isTest
public class Vision_SendToBrightCtrl_Test_Class {
    
    static testmethod void testmethod1()
    {
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
        
        Account acc1= New Account();
        acc1.Name='Walgreen Company';
        acc1.AccountNumber='117866';
        acc1.Phoenix_Local_VIP__c=25.10;
        acc1.Phoenix_Preferred_Wholesaler__c='McKesson';
        acc1.Phoenix_Is_Bid_Account__c = true;
        Insert acc1;
        
        Account acc2= New Account();
        acc2.Name='Test Account';
        acc2.AccountNumber='370337';
        acc2.Phoenix_Is_Bid_Account__c=True;
        acc2.Phoenix_Local_VIP__c=10.2;
        acc2.Phoenix_Preferred_Wholesaler__c='Cardinal';
        Insert acc2;
        
        Opportunity opp = New Opportunity ();
        opp.AccountId= acc.Id;
        opp.Name='Test Opportunity';
        opp.CloseDate=System.today();
        opp.StageName='Closed Lost';
        opp.Vision_Reference_Contract__c='Testing';
        Insert opp;
        
        Opportunity opp2 = New Opportunity ();
        opp2.AccountId= acc.Id;
        opp2.Name='Test Opportunity';
        opp2.CloseDate=System.today();
        opp2.StageName='Closed Lost';
        opp2.Vision_Reference_Contract__c='Testing';
        Insert opp2;
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
        bfee.Phoenix_Fee__c=10.2;
        bfee.Phoenix_Fee_Type__c='RDC/NLC %';
        bfeelist.add(bfee);
        
        Phoenix_Bid_Fee_Master__c bfee1= new Phoenix_Bid_Fee_Master__c();
        bfee1.Phoenix_Customer__c=acc2.id;
        bfee1.Phoenix_Customer_Type__c='Non Govt business';
        bfee1.Phoenix_Fee__c=10.2;
        bfee1.Phoenix_Fee_Type__c='RDC/NLC %';
        bfeelist.add(bfee1);
        
        Insert bfeelist;
        
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
        prodList.add(prod1);
        prodList.add(prod2);
        
        Insert prodList;
        
      //  Vision_Market_Share_Expansion__c vmse= new Vision_Market_Share_Expansion__c();
        //Insert vmse;
        
        List<Product_Opportunity__c> optyProdList = new List<Product_Opportunity__c> ();
        Product_Opportunity__c prodopty1 = new Product_Opportunity__c();
        prodopty1.Name = 'Test Product opty';
        prodopty1.Opportunity__c=opp.Id;
        prodopty1.Product__c=prod1.Id;
       // prodopty1.Market_Share_Expansion__c=vmse.Id;
        prodopty1.Status__c='Matched';
        prodopty1.vision_is_discrepancy_product__c=False;
        optyProdList.add(prodopty1);
        
        Insert optyProdList;
        List<Phoenix_NPR_Data__c> nprdtlist = new  List<Phoenix_NPR_Data__c>();
        Phoenix_NPR_Data__c  npdata = new Phoenix_NPR_Data__c();
        npdata.Phoenix_Account__c=acc.Id;
        npdata.Phoenix_Contract__c=ctlist[0].id;
        npdata.Phoenix_Product__c=prodlist[0].id;
        npdata.Phoenix_12Months_Actual_Sales_Unit__c=20.00;
        npdata.Phoenix_12Months_Net_Sales__c=250.00;
        npdata.Phoenix_12Months_Sales_Unit__c=25.00;
        npdata.Phoenix_12Mt_Sales_Ut_Actual__c=22.0;
        nprdtlist.add(npdata);
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
        
        
        /*  JSONGenerator gen = JSON.createGenerator(true);
gen.writeObject(wbc);
String jsonRepresentation = gen.getAsString();
system.debug('this is our debuf log====='+jsonRepresentation);*/
        
        String tt ='[{"showAddToBidButton":false,"refContractList":null, "optyProdObj":{"attributes":{"type":"Product_Opportunity__c","url":"/services/data/v54.0/sobjects/Product_Opportunity__c/a187c000003VPBNAA4"},"Name":"Test Product opty","Opportunity__c":"0067c00000E8CzQAAV","Product__c":"01t7c000006ULqtAAG"}}]';
        
        list<string>selcntrs = new List<String>();
        
        Map<Id,Product_Opportunity__c> prdOptyItems=new Map<Id,Product_Opportunity__c> {prod1.Id=>prodopty1};
            
            Vision_SendToBrightCtrl.getOptyProd(opp.Id);
        Vision_SendToBrightCtrl.getOptyProd(opp2.Id);
        
        Vision_SendToBrightCtrl.deleteOptyProd(opp.Id);
        Vision_SendToBrightCtrl.getOpenBids(acc.Id,'Contracts Only');
        
        Vision_SendToBrightCtrl.addBidLinesToBid(bid, optyProdList, 'Contracts Only');
        Vision_SendToBrightCtrl.addBidLinesToBid(bid1, optyProdList, 'Contracts Only');
        Vision_SendToBrightCtrl.addBidLinesToBid(bid2, optyProdList, 'Contracts Only');
        Vision_SendToBrightCtrl.addBidLinesToBid(bid3, optyProdList, 'Contracts Only');
        Vision_SendToBrightCtrl.addBidLinesToBid(bid4, optyProdList, 'Contracts Only');
        Vision_SendToBrightCtrl.addBidLinesToBid(bid5, optyProdList, 'Contracts Only');
        
        
        Vision_SendToBrightCtrl.sendToBrightExistingBid(opp.Id,bid.Id, tt);
        Vision_SendToBrightCtrl.sendToBrightFunc(opp.Id,tt, 'ClarusOne',false);
        
        //Vision_SendToBrightCtrl.savequoteitems(prodList, bw, selcntrs, prdOptyItems,'test');
        //Vision_SendToBrightCtrl.savequoteitems(prodList, bw, selcntrs, prdOptyItems,'ClarusOne');
        // Vision_SendToBrightCtrl.savequoteitems(prodList, bw1, selcntrs, prdOptyItems,'ClarusOne');
        Vision_SendToBrightCtrl.saveOptyDetPageChanges(opp.Id,prodopty1);
        Vision_SendToBrightCtrl.getOptyLinesAndCon(opp.Id);
        Vision_SendToBrightCtrl.fetchNprtData(optyProdList,ctlist,'otcCx');
        Vision_SendToBrightCtrl.getContracts(acc1.id);
        Vision_SendToBrightCtrl.saveOptyWithContracts(selcntrs,opp.id);
        Vision_SendToBrightCtrl.updateOptyCmnt(opp);
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
        
        Product2 prod1 = new Product2(Name = 'Test Product', Phoenix_Rx_SRx_OTC__c = 'Rx', Phoenix_Special_Product__c = true);
        Insert prod1;
        
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
        Vision_SendToBrightCtrl.addBidLinesToBid(bid5, optyProdList, 'Contracts Only');
        Vision_SendToBrightCtrl.addBidLinesToBid(bid6, optyProdList, 'Contracts Only');
        Vision_SendToBrightCtrl.getOptyLinesAndCon(opp.id);
        Vision_SendToBrightCtrl.sendToBrightFunc(opp.Id,tt1, 'ClarusOne',false);
    }
}