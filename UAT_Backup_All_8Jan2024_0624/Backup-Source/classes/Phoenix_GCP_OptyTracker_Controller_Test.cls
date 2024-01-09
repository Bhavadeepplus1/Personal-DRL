@isTest//(seeAlldata=true)
public class Phoenix_GCP_OptyTracker_Controller_Test {
    //static testmethod void setupTestDataCov() {
    //    Phoenix_GCP_OptyTracker_Controller.coverageBlock();
    //}
    static testmethod void test1(){
        Account acc = new Account();
        acc.Name = 'Test Account';
        insert acc;
        String uid = ('Phoenix' + System.now().getTime()).SubString(0, 8);
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User u1 = new User(Alias = uid, Email = uid + '@phoenix.com', EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', ProfileId = p.Id, TimeZoneSidKey = 'America/New_York', UserName = uid + '@phoenix.com', Division = 'SRx');
        insert u1;  
        Product_Family__c prodFam = new Product_Family__c();
        prodFam.Name = 'OLOPATADINE';
        prodFam.Vision_IsActive__c = true;
        prodFam.Vision_Segment__c = 'Rx';
        insert prodFam;
        
        Phoenix_GCP_Opportunity_Tracker__c gcp=new Phoenix_GCP_Opportunity_Tracker__c();
        gcp.gcp_customer_name__c='Sunil';
        gcp.Phoenix_Product_Family__c='Walgreens';
        gcp.Phoenix_Ims_Mat_Volume_Eu__c=10;
        gcp.Phoenix_Ims_Mat_Volume_Eu__c=10;
        gcp.Phoenix_Est_Price_Method__c='Use User Input';
        gcp.Phoenix_Est_Acct_Mkt_Share_User_Input__c=20;
        gcp.Phoenix_Customer__c = acc.Id;
        gcp.comments__c = 'test';
        gcp.GCP_Product_Family__c = 'OLOPATADINE';
        gcp.gcp_customer_name__c='Sunil';
        gcp.Phoenix_Product_Family__c= 'Walgreens';
        gcp.Phoenix_Ims_Mat_Volume_Eu__c=80;
        gcp.Phoenix_Est_Price_EU_Lowest_Price__c=10;
        gcp.Phoenix_Est_Price_Method__c='Use User Input';
        gcp.Phoenix_Est_Acct_Mkt_Share_User_Input__c=20;
        gcp.Phoenix_Est_Acct_Mkt_Share_Method__c='Use User Input';
        gcp.Phoenix_Est_Acct_Price_EU_User_Input__c=45;
        gcp.Product_Status__c = 'Awarded';
        gcp.Phoenix_Segment__c = 'Rx';
        gcp.Vision_isRelevance__c = true;
        gcp.Product_Family__c = prodFam.Id;
        insert gcp;
        
        list < Product2 > prodlist = new list < Product2 > ();
        Product2 prod1 = new Product2(Name = 'Test Product', Phoenix_Rx_SRx_OTC__c = 'Rx', Phoenix_Special_Product__c = true, Phoenix_GPI_Generic_Product_Identifier__c = '11111', Product_Family__c = prodFam.Id,
                                      Phoenix_NDC__c = '5511112200', Family = 'Test Family', Phoenix_Is_Exclude_Bid__c = false, IsActive = TRUE, Phoenix_Pkg_Size__c = 50, Phoenix_Lowest_Price_SKU__c = 5);
        Product2 prod2 = new Product2(Name = 'Test Product1', Phoenix_Rx_SRx_OTC__c = 'Rx', Phoenix_Special_Product__c = true, Phoenix_GPI_Generic_Product_Identifier__c = '22222', Product_Family__c = prodFam.Id,
                                      Phoenix_NDC__c = '43598855300', Family = 'Sample Family', Phoenix_Is_Exclude_Bid__c = false, IsActive = TRUE, Phoenix_Pkg_Size__c = 1000, Phoenix_Lowest_Price_SKU__c = 10);
        prodlist.add(prod1);
        prodlist.add(prod2);
        insert prodlist;
        
        Product2 prod = new Product2();
        prod.Name ='test1';
        prod.Phoenix_Rx_SRx_OTC__c = 'testItem'; 
        prod.IsActive = true; 
        prod.Phoenix_Is_Exclude_Bid__c = false;
        prod.family = 'testFam';
        prod.Product_Family__c = prodFam.Id;
        //prod.Product_Status__c = 'test';
        insert prod;
        
        
        Phoenix_Bid__c bid = new Phoenix_Bid__c();
        bid.Phoenix_Bid_Name__c = 'Test Bid';
        bid.Phoenix_Bid_Type__c = 'Product Addition';
        bid.Phoenix_Approval_Status__c='Closed';
        bid.Phoenix_Customer__c = acc.id;
        bid.Phoenix_Marketing_Comments__c='gjhyb';
        insert bid;
        
        List<Phoenix_Bid_Process_Steps__c> bidProcessSteps = new List<Phoenix_Bid_Process_Steps__c>();
        insert bidProcessSteps;
        
        List<Phoenix_Bid_Process_Steps__c> pbps =new  List<Phoenix_Bid_Process_Steps__c>();
        
        Phoenix_Bid_Process_Steps__c step1 = new Phoenix_Bid_Process_Steps__c();
        step1.Phoenix_Bid__c = bid.id;
        step1.Phoenix_Approver_Team__c = '';
        pbps.add(step1);
        
        Phoenix_Bid_Process_Steps__c step2 = new Phoenix_Bid_Process_Steps__c();
        step2.Phoenix_Bid__c = bid.id;
        step2.Phoenix_Approver_Team__c ='Marketing';
        pbps.add(step2);
        
        Phoenix_Bid_Process_Steps__c step3 = new Phoenix_Bid_Process_Steps__c();
        step3.Phoenix_Bid__c = bid.id;
        step3.Phoenix_Approver_Team__c = 'Supply Chain';
        pbps.add(step3);
        
        Phoenix_Bid_Process_Steps__c step4 = new Phoenix_Bid_Process_Steps__c();
        step4.Phoenix_Bid__c = bid.id;
        step4.Phoenix_Approver_Team__c ='Contracts';
        pbps.add(step4);
        
        Phoenix_Bid_Process_Steps__c step5 = new Phoenix_Bid_Process_Steps__c();
        step5.Phoenix_Bid__c = bid.id;
        step5.Phoenix_Approver_Team__c ='Finance';
        pbps.add(step5);
        
        Phoenix_Bid_Process_Steps__c step6 = new Phoenix_Bid_Process_Steps__c();
        step6.Phoenix_Bid__c = bid.id;
        step6.Phoenix_Approver_Team__c ='Customer Service';
        pbps.add(step6);
        
        Phoenix_Bid_Process_Steps__c step7 = new Phoenix_Bid_Process_Steps__c();
        step7.Phoenix_Bid__c = bid.id;
        step7.Phoenix_Approver_Team__c ='Home Office';
        pbps.add(step7);
        
        insert pbps;
        
        
        
        list <Phoenix_Bid_Line_Item__c > bidLine1 = new list<Phoenix_Bid_Line_Item__c> ();
        Phoenix_Bid_Line_Item__c bidLine = new Phoenix_Bid_Line_Item__c();
        bidLine.Phoenix_Product_Family1__c='tests';
        bidLine.Phoenix_Bid__c = bid.id;
        bidLine.Phoenix_Marketing_Approval__c='Approved';
        bidLine.Phoenix_Vistex_Comments__c = 'test';
        bidLine.Phoenix_Product__c = prod.Id;
        bidLine.Phoenix_Bid_Status__c = 'Awarded';
        bidLine.Phoenix_Proposed_Sales__c = 1000;
        bidLine.Phoenix_Final_Direct_Selling_Units_Calc__c=90;
        bidLine.Phoenix_Final_Indirect_Selling_Units_Cal__c=89;
        bidLine.Phoenix_SCM_Notes__c='RFP';
        bidLine.Phoenix_Marketing_Notes__c='notes';
        //Phoenix_Final_Direct_Selling_Units_Calc__c
        bidLine.Phoenix_Final_Indirect_Selling_Units_Cal__c=76;
        //bidLine.Phoenix_Awarded_Net_Sales__c=54;
        bidLine.Proposed_Net_Sales_Indirect__c=98;
        bidLine.Phoenix_Marketing_Approval__c='Approved';
        bidLine.Phoenix_Initial_Stocking_Order_Comments__c='test5';
        //bl.Phoenix_Bid__c = bid.Id;
        bidLine.Phoenix_Current_Direct_Price__c = 10;
        bidLine.Phoenix_Product_Code1__c = '300029858';
        bidLine.Phoenix_Product_Family1__c = 'Daptomycin Inj 500mg US';
        bidLine.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        bidLine.Phoenix_Proposed_Direct_Selling_Unit__c = 60;
        bidLine.Phoenix_Proposed_Indirect_Selling_Unit__c = 65;
        bidLine.Phoenix_Comments__c='Approved';
        bidLine.Phoenix_Contract_Comments__c='ahdu';
        bidLine.Phoenix_SCM_Approval_Y_N__c = 'N- Not Approved';
        bidLine.Phoenix_Marketing_Final_Approval__c = true;
        
        insert bidLine;
        
        GCP_SFDC_100pct_Analysis_SKU__c ndcItem = new GCP_SFDC_100pct_Analysis_SKU__c();
        ndcItem.Product_Family__c = 'Walgreens';
        ndcItem.GCP_Product_Family__c=gcp.GCP_Product_Family__c;
        ndcItem.Vision_Customer__c=acc.Id;
        ndcItem.Vision_Product__c = prod.Id;
        ndcItem.Vision_Product_Constraint__c='Price Constraint';
        insert ndcItem;
        
        GCP_Comment__c cmt = new GCP_Comment__c();
        cmt.Comment__c='test';
        cmt.Comment_Type__c = 'Panorama';
        cmt.Comment_Date__c= system.today();
        cmt.GCP_Product_Family__c='Walgreens';
        cmt.Product_Family__c = 'Walgreens';
        cmt.GCP_SFDC_100pct_Analysis_SKU__c = ndcItem.Id;
        insert cmt;
        Product_Family__c fm= new Product_Family__c();
        fm.Name='Walgreens';
        insert fm;
        GCP_100Pct_Analysis_Unique__c gcpunq= new GCP_100Pct_Analysis_Unique__c();
        gcpunq.GCP_Product_Family__c='Walgreens';
        gcpunq.cogs_per_unit__c=89;
        gcpunq.vision_segment__c='rx';
        gcpunq.Vision_Updated_date__c=system.today();
        gcpunq.ims_qtr_month_range__c='45';
        gcpunq.IMS_Mat_Volume_Eu__c=56;
        gcpunq.Ims_Mat_Sales__c=90;
        gcpunq.Ims_Mat_Month_Range__c='kjj';
        gcpunq.Prof_Month_range__c='kk';
        gcpunq.ims_drl_mrkt_share_qtr__c=45.0;
        
        gcpunq.drl_mkt_share_acct__c=45.3;
        gcpunq.drl_act_volume_eu__c=450;
        gcpunq.DRL_Act_Sales__c=56;
        gcpunq.DRL_Act_Price__c=78;
        gcpunq.DRL_Act_Tpt__c=45;
        gcpunq.DRL_Act_Tpt_Pct__c=0.5;
        gcpunq.GCP_Suggested_Price__c=23;
        insert gcpunq;
        
        Phoenix_GCP_OptyTracker_Controller.getupdatedAccData(acc.Id);
        Phoenix_GCP_OptyTracker_Controller.getAllTotals(acc.Id);
        Phoenix_GCP_OptyTracker_Controller.getGCPInfo(acc.Id);
        Phoenix_GCP_OptyTracker_Controller.getGcpRelatedList(acc.Id, new List<String>{}, new List<String>{'Awarded'}, false);
        Phoenix_GCP_OptyTracker_Controller.updateGcpLineItem(gcp);
        Phoenix_GCP_OptyTracker_Controller.saveComment('test',gcp.Id);
        Phoenix_GCP_OptyTracker_Controller.getProdBidLineItemComments(ndcItem,acc);
        Phoenix_GCP_OptyTracker_Controller.getPositions(acc.Id,gcp);
        Phoenix_GCP_OptyTracker_Controller.updateGcpLineItem(gcp);        
        Phoenix_GCP_OptyTracker_Controller.updateGcpListWithNewRelevance(acc.Id,new List<String>{'Walgreens'}); 
        Phoenix_GCP_OptyTracker_Controller.getGCPFamList(acc.Id);
        Phoenix_GCP_OptyTracker_Controller.getProdListWithIds(new List<String>{prod.Id});
        
        
        
        Phoenix_GCP_OptyTracker_Controller.rosWrapper wrap3 = Phoenix_GCP_OptyTracker_Controller.getAllAccList(acc.Id,new list<String>{},true);
        //Phoenix_GCP_OptyTracker_Controller.Wrapper wrap4 = Phoenix_GCP_OptyTracker_Controller.getIndvAccData(acc.Id,new list<String>{});
        Phoenix_GCP_OptyTracker_Controller.isNumeric('10000');
        Phoenix_GCP_OptyTracker_Controller.isNumeric('test');
        Phoenix_GCP_OptyTracker_Controller.Wrapper wrap2 = Phoenix_GCP_OptyTracker_Controller.getNDCforROS('Walgreens', acc.Id);
        Phoenix_GCP_OptyTracker_Controller.getStatusCount(gcp);
        Account ac1 = Phoenix_GCP_OptyTracker_Controller.updateAccWithNewFilter(acc);
        Phoenix_GCP_OptyTracker_Controller.countWrapper wrap = Phoenix_GCP_OptyTracker_Controller.getStatusCountSRx(gcp);
        Phoenix_GCP_OptyTracker_Controller.Wrapper wrap1 = Phoenix_GCP_OptyTracker_Controller.getFilteredGCPItems(acc.id,new list<String>{}, new list<String>{}, true);
        List<GCP_SFDC_100pct_Analysis_SKU__c> sp = Phoenix_GCP_OptyTracker_Controller.getNDCListForPieChart(acc.id,'Awarded',true);
        
        Test.startTest();
        ndcItem.Vision_Product_Constraint__c='Supply Constraint';
        update ndcItem;
        ndcItem.Vision_Product_Constraint__c='Not An Opportunity';
        update ndcItem;
        ndcItem.Vision_Product_Constraint__c='';
        update ndcItem;
        
        
        Phoenix_GCP_OptyTracker_Controller.fieldApiList('Phoenix_GCP_Opportunity_Tracker__c');
        Phoenix_GCP_OptyTracker_Controller.getUpdatedGcpLineItem(gcp.id);
        List<string> rxSrxOtcList = new List<String>{'Rx','Test2','Test3'};
        Phoenix_GCP_OptyTracker_Controller.getGcpRelatedList(acc.Id,rxSrxOtcList, new List<String>{'Awarded'}, true);
        Phoenix_GCP_OptyTracker_Controller.getPositions(acc.id,gcp);
        Phoenix_GCP_OptyTracker_Controller.updateGcpLineItem(gcp);        
        Phoenix_GCP_OptyTracker_Controller.updateNdcLineItem(new List<GCP_SFDC_100pct_Analysis_SKU__c>{ndcItem});
        Test.stopTest();
    }
    
    static testmethod void test2(){
        Account acc = new Account();
        acc.Name = 'Test Account';
        insert acc;
        
        Account acc1 = new Account();
        acc1.Name = 'Test Account';
        insert acc1;
        String uid = ('Phoenix' + System.now().getTime()).SubString(0, 8);
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User u1 = new User(Alias = uid, Email = uid + '@phoenix.com', EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', ProfileId = p.Id, TimeZoneSidKey = 'America/New_York', UserName = uid + '@phoenix.com', Division = 'SRx');
        insert u1;  
        
        Product_Family__c fm= new Product_Family__c();
        fm.Name='Walgreens';
        fm.Vision_IsActive__c = true;
        insert fm;        
        
        Phoenix_GCP_Opportunity_Tracker__c gcp=new Phoenix_GCP_Opportunity_Tracker__c();
        gcp.gcp_customer_name__c='Sunil';
        gcp.Phoenix_Product_Family__c='Walgreens';
        gcp.Phoenix_Ims_Mat_Volume_Eu__c=10;
        gcp.Phoenix_Ims_Mat_Volume_Eu__c=10;
        gcp.Phoenix_Est_Price_Method__c='Use User Input';
        gcp.Phoenix_Est_Acct_Mkt_Share_User_Input__c=20;
        gcp.Phoenix_Customer__c = acc.Id;
        gcp.comments__c = 'test';
        gcp.GCP_Product_Family__c = 'OLOPATADINE';
        gcp.gcp_customer_name__c='Sunil';
        gcp.Phoenix_Product_Family__c= 'Walgreens';
        gcp.Phoenix_Ims_Mat_Volume_Eu__c=80;
        gcp.Phoenix_Est_Price_EU_Lowest_Price__c=10;
        gcp.Phoenix_Est_Price_Method__c='Use User Input';
        gcp.Phoenix_Est_Acct_Mkt_Share_User_Input__c=20;
        gcp.Phoenix_Est_Acct_Mkt_Share_Method__c='Use User Input';
        gcp.Phoenix_Product_Family__c = 'abcde';
        gcp.Product_Status__c = 'Awarded';
        gcp.Product_Family__c=fm.id;
        Phoenix_GCP_Opportunity_Tracker__c gcp2=new Phoenix_GCP_Opportunity_Tracker__c();
        gcp2.Phoenix_Est_Acct_Share_of_Wallet_Method__c = 'Use User Input';
        gcp2.gcp_customer_name__c='Sunil';
        gcp2.Phoenix_Product_Family__c='Walgreens';
        gcp2.Phoenix_Ims_Mat_Volume_Eu__c=10;
        gcp2.Phoenix_Ims_Mat_Volume_Eu__c=10;
        gcp2.Phoenix_Est_Price_Method__c='Use User Input';
        gcp2.Phoenix_Est_Acct_Mkt_Share_User_Input__c=20;
        gcp2.Phoenix_Customer__c = acc.Id;
        gcp2.comments__c = 'test';
        gcp2.GCP_Product_Family__c = 'OLOPATADINE';
        gcp2.gcp_customer_name__c='Sunil';
        gcp2.Phoenix_Product_Family__c= 'Walgreens';
        gcp2.Phoenix_Ims_Mat_Volume_Eu__c=80;
        gcp2.Phoenix_Est_Price_EU_Lowest_Price__c=10;
        gcp2.Phoenix_Est_Price_Method__c='Use User Input';
        gcp2.Phoenix_Est_Acct_Mkt_Share_User_Input__c=20;
        gcp2.Phoenix_Est_Acct_Mkt_Share_Method__c='Use User Input';
        gcp2.Product_Status__c = 'Awarded';
        gcp2.Product_Family__c=fm.id;
        
        Phoenix_GCP_Opportunity_Tracker__c gcp3=new Phoenix_GCP_Opportunity_Tracker__c();
        gcp3.Phoenix_Est_Acct_Share_of_Wallet_Method__c = 'Use User Input';
        gcp3.gcp_customer_name__c='Sunil';
        gcp3.Phoenix_Product_Family__c='Walgreens';
        gcp3.Phoenix_Ims_Mat_Volume_Eu__c=10;
        gcp3.Phoenix_Ims_Mat_Volume_Eu__c=10;
        gcp3.Phoenix_Est_Price_Method__c='Use User Input';
        gcp3.Phoenix_Est_Acct_Mkt_Share_User_Input__c=20;
        gcp3.Phoenix_Customer__c = acc.Id;
        gcp3.comments__c = 'test';
        gcp3.GCP_Product_Family__c = 'OLOPATADINE';
        gcp3.gcp_customer_name__c='Sunil';
        gcp3.Phoenix_Product_Family__c= 'Walgreens';
        gcp3.Phoenix_Ims_Mat_Volume_Eu__c=80;
        gcp3.Phoenix_Est_Price_EU_Lowest_Price__c=10;
        gcp3.Phoenix_Est_Price_Method__c='Use User Input';
        gcp3.Phoenix_Est_Acct_Mkt_Share_User_Input__c=20;
        gcp3.Phoenix_Est_Acct_Mkt_Share_Method__c='Use Usage Data';
        gcp3.Product_Status__c = 'Awarded';
        gcp3.Product_Family__c=fm.id;
        
        Phoenix_GCP_Opportunity_Tracker__c gcp4=new Phoenix_GCP_Opportunity_Tracker__c();
        gcp4.Product_Status__c = 'Awarded';
        gcp4.Phoenix_Est_Acct_Share_of_Wallet_Method__c = 'Use User Input';
        gcp4.gcp_customer_name__c='Sunil';
        gcp4.Phoenix_Product_Family__c='Walgreens';
        gcp4.Phoenix_Ims_Mat_Volume_Eu__c=10;
        gcp4.Phoenix_Ims_Mat_Volume_Eu__c=10;
        gcp4.Phoenix_Est_Acct_Mkt_Share_User_Input__c=20;
        gcp4.Phoenix_Customer__c = acc.Id;
        gcp4.comments__c = 'test';
        gcp4.GCP_Product_Family__c = 'OLOPATADINE';
        gcp4.gcp_customer_name__c='Sunil';
        gcp4.Phoenix_Product_Family__c= 'Walgreens';
        gcp4.Phoenix_Ims_Mat_Volume_Eu__c=80;
        gcp4.Phoenix_Est_Price_EU_Lowest_Price__c=10;
        gcp4.Phoenix_Est_Price_Method__c='DRL Customer Actuals Average Price';
        gcp4.Phoenix_Est_Acct_Mkt_Share_User_Input__c=20;
        gcp4.Phoenix_Est_Acct_Mkt_Share_Method__c='Use Usage Data';
        gcp4.Phoenix_Cust_Act_Volume_Mat_Eu__c =22;
        gcp4.Product_Status__c = 'Awarded';
        gcp4.Product_Family__c=fm.id;
        
        Phoenix_GCP_Opportunity_Tracker__c gcp5=new Phoenix_GCP_Opportunity_Tracker__c();
        gcp5.Product_Status__c = 'Awarded';
        gcp5.Phoenix_Est_Acct_Share_of_Wallet_Method__c = 'Use User Input';
        gcp5.gcp_customer_name__c='Sunil';
        gcp5.Phoenix_Product_Family__c='Walgreens';
        gcp5.Phoenix_Ims_Mat_Volume_Eu__c=10;
        gcp5.Phoenix_Ims_Mat_Volume_Eu__c=10;
        gcp5.Phoenix_Est_Acct_Mkt_Share_User_Input__c=20;
        gcp5.Phoenix_Customer__c = acc.Id;
        gcp5.comments__c = 'test';
        gcp5.GCP_Product_Family__c = 'OLOPATADINE';
        gcp5.gcp_customer_name__c='Sunil';
        gcp5.Phoenix_Product_Family__c= 'Walgreens';
        gcp5.Phoenix_Ims_Mat_Volume_Eu__c=80;
        gcp5.Phoenix_Est_Price_EU_Lowest_Price__c=10;
        gcp5.Phoenix_Est_Price_Method__c='DRL Customer Actuals Average Price';
        gcp5.Phoenix_Est_Acct_Mkt_Share_User_Input__c=20;
        gcp5.Phoenix_Est_Acct_Mkt_Share_Method__c='Use Usage Data';
        gcp5.Product_Status__c = 'Awarded';
        gcp5.Product_Family__c=fm.id;
        Phoenix_GCP_Opportunity_Tracker__c gcp6=new Phoenix_GCP_Opportunity_Tracker__c();
        gcp6.Product_Status__c = 'Awarded';
        gcp6.Phoenix_Est_Acct_Share_of_Wallet_Method__c = 'Use User Input';
        gcp6.gcp_customer_name__c='Sunil';
        gcp6.Phoenix_Product_Family__c='Walgreens';
        gcp6.Phoenix_Ims_Mat_Volume_Eu__c=10;
        gcp6.Phoenix_Ims_Mat_Volume_Eu__c=10;
        gcp6.Phoenix_Est_Acct_Mkt_Share_User_Input__c=20;
        gcp6.Phoenix_Customer__c = acc.Id;
        gcp6.comments__c = 'test';
        gcp6.GCP_Product_Family__c = 'OLOPATADINE';
        gcp6.gcp_customer_name__c='Sunil';
        gcp6.Phoenix_Product_Family__c= 'Walgreens';
        gcp6.Phoenix_Ims_Mat_Volume_Eu__c=80;
        gcp6.Phoenix_Est_Price_EU_Lowest_Price__c=10;
        gcp6.Phoenix_Est_Acct_Mkt_Share_User_Input__c=20;
        gcp6.Phoenix_Est_Acct_Mkt_Share_Method__c='Use Usage Data';
        gcp6.Product_Status__c = 'Awarded';
        gcp6.Product_Family__c=fm.id;
        
        Phoenix_GCP_Opportunity_Tracker__c gcp7=new Phoenix_GCP_Opportunity_Tracker__c();
        gcp7.Product_Status__c = 'Awarded';
        gcp7.Phoenix_Current_Position__c ='Formulary A Awards';
        gcp7.Phoenix_Est_Acct_Share_of_Wallet_Method__c = 'Use User Input';
        gcp7.gcp_customer_name__c='Sunil';
        gcp7.Phoenix_Product_Family__c='Walgreens';
        gcp7.Phoenix_Ims_Mat_Volume_Eu__c=10;
        gcp7.Phoenix_Ims_Mat_Volume_Eu__c=10;
        gcp7.Phoenix_Est_Acct_Mkt_Share_User_Input__c=20;
        gcp7.Phoenix_Customer__c = acc.Id;
        gcp7.comments__c = 'test';
        gcp7.GCP_Product_Family__c = 'OLOPATADINE';
        gcp7.gcp_customer_name__c='Sunil';
        gcp7.Phoenix_Product_Family__c= 'Walgreens';
        gcp7.Phoenix_Ims_Mat_Volume_Eu__c=80;
        gcp7.Phoenix_Est_Price_EU_Lowest_Price__c=10;
        gcp7.Phoenix_Est_Acct_Mkt_Share_User_Input__c=20;
        gcp7.Phoenix_Est_Acct_Mkt_Share_Method__c='Use Usage Data';
        gcp7.Product_Status__c = 'Awarded';
        gcp7.Product_Family__c=fm.id;
        
        insert gcp;
        insert gcp2;
        insert gcp3;
        insert gcp4;
        insert gcp5;
        insert gcp6;
        insert gcp7;
        
        list < Product2 > prodlist = new list < Product2 > ();
        Product2 prod1 = new Product2(Name = 'Test Product', Phoenix_Rx_SRx_OTC__c = 'Rx', Phoenix_Special_Product__c = true, Phoenix_GPI_Generic_Product_Identifier__c = '11111', Phoenix_NDC__c = '5511112200', Family = 'Test Family', Phoenix_Is_Exclude_Bid__c = false, IsActive = TRUE);
        Product2 prod2 = new Product2(Name = 'Test Product1', Phoenix_Rx_SRx_OTC__c = 'Rx', Phoenix_Special_Product__c = true, Phoenix_GPI_Generic_Product_Identifier__c = '22222', Phoenix_NDC__c = '43598855300', Family = 'Sample Family', Phoenix_Is_Exclude_Bid__c = false, IsActive = TRUE);
        prodlist.add(prod1);
        prodlist.add(prod2);
        insert prodlist;
        
        Product2 prod = new Product2();
        prod.Name ='test1';
        //prod.Product_Status__c = 'test';
        insert prod;
        
        Phoenix_Bid__c bid = new Phoenix_Bid__c();
        bid.Phoenix_Bid_Name__c = 'Test Bid';
        bid.Phoenix_Bid_Type__c = 'Product Addition';
        bid.Phoenix_Approval_Status__c='Closed';
        bid.Phoenix_Customer__c = acc.id;
        insert bid;
        
        Phoenix_Bid__c bid2 = new Phoenix_Bid__c();
        bid2.Phoenix_Bid_Name__c = 'Test Bid2';
        bid2.Phoenix_Bid_Type__c = 'Contracts Only';
        bid2.Phoenix_Approval_Status__c='Closed';
        bid2.Phoenix_Customer__c = acc.id;
        insert bid2;
        
        List<Phoenix_Bid_Process_Steps__c> pbps =new  List<Phoenix_Bid_Process_Steps__c>();
        
        Phoenix_Bid_Process_Steps__c step1 = new Phoenix_Bid_Process_Steps__c();
        step1.Phoenix_Bid__c = bid.id;
        step1.Phoenix_Approver_Team__c = '';
        pbps.add(step1);
        
        Phoenix_Bid_Process_Steps__c step2 = new Phoenix_Bid_Process_Steps__c();
        step2.Phoenix_Bid__c = bid.id;
        step2.Phoenix_Approver_Team__c ='Marketing';
        pbps.add(step2);
        
        Phoenix_Bid_Process_Steps__c step3 = new Phoenix_Bid_Process_Steps__c();
        step3.Phoenix_Bid__c = bid.id;
        step3.Phoenix_Approver_Team__c = 'Supply Chain';
        pbps.add(step3);
        
        Phoenix_Bid_Process_Steps__c step4 = new Phoenix_Bid_Process_Steps__c();
        step4.Phoenix_Bid__c = bid2.id;
        step4.Phoenix_Approver_Team__c ='Contracts';
        pbps.add(step4);
        
        Phoenix_Bid_Process_Steps__c step5 = new Phoenix_Bid_Process_Steps__c();
        step5.Phoenix_Bid__c = bid.id;
        step5.Phoenix_Approver_Team__c ='Finance';
        pbps.add(step5);
        
        Phoenix_Bid_Process_Steps__c step6 = new Phoenix_Bid_Process_Steps__c();
        step6.Phoenix_Bid__c = bid.id;
        step6.Phoenix_Approver_Team__c ='Customer Service';
        pbps.add(step6);
        
        Phoenix_Bid_Process_Steps__c step7 = new Phoenix_Bid_Process_Steps__c();
        step7.Phoenix_Bid__c = bid.id;
        step7.Phoenix_Approver_Team__c ='Home Office';
        pbps.add(step7);
        
        insert pbps;
        
        
        
        list <  Phoenix_Bid_Line_Item__c > bidLine1 = new list<Phoenix_Bid_Line_Item__c> ();
        Phoenix_Bid_Line_Item__c bidLine = new Phoenix_Bid_Line_Item__c();
        bidLine.Phoenix_Bid__c = bid.id;
        bidLine.Phoenix_Marketing_Approval__c='Not Approved';
        bidLine.Phoenix_Vistex_Comments__c = 'test';
        bidLine.Phoenix_Comments__c='testing';
        bidLine.Phoenix_Product__c = prod.Id;
        bidLine.Phoenix_Bid_Status__c = 'Awarded';
        bidLine.Phoenix_Proposed_Sales__c = 1000;
        bidLine.Phoenix_Final_Direct_Selling_Units_Calc__c=90;
        bidLine.Phoenix_Final_Indirect_Selling_Units_Cal__c=89;
        bidLine.Phoenix_SCM_Notes__c='RFP';
        //Phoenix_Final_Direct_Selling_Units_Calc__c
        bidLine.Phoenix_Final_Indirect_Selling_Units_Cal__c=76;
        //bidLine.Phoenix_Awarded_Net_Sales__c=54;
        bidLine.Proposed_Net_Sales_Indirect__c=98;
        bidLine.Phoenix_Marketing_Approval__c='Approved';
        
        
        //bl.Phoenix_Bid__c = bid.Id;
        bidLine.Phoenix_Current_Direct_Price__c = 10;
        bidLine.Phoenix_Product_Code1__c = '300029858';
        bidLine.Phoenix_Product_Family1__c = 'Daptomycin Inj 500mg US';
        bidLine.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        bidLine.Phoenix_Proposed_Direct_Selling_Unit__c = 60;
        bidLine.Phoenix_Proposed_Indirect_Selling_Unit__c = 65;
        bidLine.Phoenix_Product__c = prodlist[0].Id;
        //bl.Phoenix_Final_Status__c='Approved';
        // bidLine.Phoenix_SCM_Approval_Y_N__c = 'Y - Only Current Monthly Demand Approved';
        bidLine.Phoenix_Marketing_Final_Approval__c = true;
        bidLine.Phoenix_Product_Family1__c = 'abcde';
        bidline.Phoenix_Finance_Comments__c = 'jhghg';
        insert bidLine;
        
        
        
        GCP_Comment__c cmt = new GCP_Comment__c();
        cmt.Comment_Date__c= system.today();
        cmt.GCP_Product_Family__c='Walgreens';
        insert cmt;
        
        GCP_SFDC_100pct_Analysis_SKU__c ndcItem = new GCP_SFDC_100pct_Analysis_SKU__c();
        ndcItem.Product_Family__c = 'Walgreens';
        insert ndcItem;
        Phoenix_GCP_OptyTracker_Controller.Wrapper wp = Phoenix_GCP_OptyTracker_Controller.getIndvAccData(acc1.Id,acc.Id,new list<Phoenix_GCP_Opportunity_Tracker__c>{gcp,gcp2,gcp3,gcp4});
        Phoenix_GCP_OptyTracker_Controller.Wrapper wp2 = Phoenix_GCP_OptyTracker_Controller.getUpdatedGcpItems(acc.id,new list<String>{},true);
        Phoenix_GCP_OptyTracker_Controller.getUpdatedGcpItem(gcp7.Id);
        Phoenix_GCP_OptyTracker_Controller.getupdatedAccData(acc.Id);
        Phoenix_GCP_OptyTracker_Controller.getAllTotals(acc.Id);
        Phoenix_GCP_OptyTracker_Controller.getGCPInfo(acc.Id);
        Phoenix_GCP_OptyTracker_Controller.getGcpRelatedList(acc.Id, new List<String>{}, new List<String>{'Awarded'}, false);
        Phoenix_GCP_OptyTracker_Controller.updateGcpLineItem(gcp);
        Phoenix_GCP_OptyTracker_Controller.saveComment('test',gcp.Id);
        Phoenix_GCP_OptyTracker_Controller.getProdBidLineItemComments(ndcItem,acc);
        Phoenix_GCP_OptyTracker_Controller.getPositions(acc.Id,gcp);
        Phoenix_GCP_OptyTracker_Controller.updateGcpLineItem(gcp);        
        
        // Phoenix_GCP_OptyTracker_Controller.fieldApiList('Phoenix_GCP_Opportunity_Tracker__c');
        Phoenix_GCP_OptyTracker_Controller.fieldApiList('Phoenix_GCP_Opportunity_Tracker__c');
        Phoenix_GCP_OptyTracker_Controller.getUpdatedGcpLineItem(gcp.id);
        List<string> rxSrxOtcList = new List<String>{'Test1','Test2','Test3'};
            Phoenix_GCP_OptyTracker_Controller.getGcpRelatedList(acc.Id,rxSrxOtcList, new List<String>{'Awarded'}, true);
        Phoenix_GCP_OptyTracker_Controller.getPositions(acc.id,gcp);
        Phoenix_GCP_OptyTracker_Controller.getProdBidLineItemComments(ndcItem,acc);
      //  Phoenix_GCP_OptyTracker_Controller.updateGcpLineItem(gcp);    
        
    }
    
    static testmethod void test3(){
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.Phoenix_Account_Cooling_Period__c = 40;
        insert acc;
        
        Product_Family__c prodFamObj = new Product_Family__c();
        prodFamObj.Name = 'Walgreens';
        insert prodFamObj;
        
        Phoenix_GCP_Opportunity_Tracker__c gcp=new Phoenix_GCP_Opportunity_Tracker__c();
        gcp.gcp_customer_name__c='Sunil';
        gcp.Phoenix_Product_Family__c='Walgreens';
        gcp.Phoenix_Ims_Mat_Volume_Eu__c=10;
        gcp.Phoenix_Ims_Mat_Volume_Eu__c=10;
        gcp.Phoenix_Est_Price_Method__c='Use User Input';
        gcp.Phoenix_Est_Acct_Mkt_Share_User_Input__c=20;
        gcp.Phoenix_Customer__c = acc.Id;
        gcp.comments__c = 'test';
        gcp.GCP_Product_Family__c = 'OLOPATADINE';
        gcp.gcp_customer_name__c='Sunil';
        gcp.Phoenix_Product_Family__c= 'Walgreens';
        gcp.Phoenix_Ims_Mat_Volume_Eu__c=80;
        gcp.Phoenix_Est_Price_EU_Lowest_Price__c=10;
        gcp.Phoenix_Est_Price_Method__c='Use User Input';
        gcp.Phoenix_Est_Acct_Mkt_Share_User_Input__c=20;
        gcp.Phoenix_Est_Acct_Mkt_Share_Method__c='Use User Input';
        gcp.Phoenix_Est_Acct_Price_EU_User_Input__c=45;
        gcp.Product_Status__c = 'Awarded';
        insert gcp;
        
        Product2 prdObj = new Product2();
        prdObj.Name = 'testProd';
        prdObj.Family = 'Walgreens';
        prdobj.Phoenix_NDC_11__c='4563';
        prdobj.IsActive = true;
        prdobj.Phoenix_Is_Private_Label_OTC__c = false;
        prdobj.Product_Family__c = prodFamObj.Id;
        insert prdObj;
        
        Phoenix_Bid__c bid = new Phoenix_Bid__c();
        bid.Phoenix_Bid_Name__c = 'Test Bid';
        bid.Phoenix_Bid_Type__c = 'Product Addition';
        bid.Phoenix_Approval_Status__c='Closed';
        bid.Phoenix_Customer__c = acc.id;
        bid.Phoenix_Marketing_Comments__c='gjhyb';
        insert bid;
        Phoenix_Bid__c bid1 = new Phoenix_Bid__c();
        bid1.Phoenix_Bid_Name__c = 'Test Bid';
        bid1.Phoenix_Bid_Type__c = 'Product Addition';
        bid1.Phoenix_Approval_Status__c='Marketing Rejected';
        bid1.Phoenix_Customer__c = acc.id;
        bid1.Phoenix_Marketing_Comments__c='gjhyb';
        insert bid1;
        
        Phoenix_Bid_Line_Item__c bidLine = new Phoenix_Bid_Line_Item__c();
        bidLine.Phoenix_Product_Family1__c='tests';
        bidLine.Phoenix_Bid__c = bid.id;
        //bidLine.Phoenix_Marketing_Approval__c='Approved';
        bidLine.Phoenix_Vistex_Comments__c = 'test';
        bidLine.Phoenix_Product__c = prdObj.Id;
        bidLine.Phoenix_Bid_Status__c = 'Awarded';
        bidLine.Phoenix_Proposed_Sales__c = 1000;
        bidLine.Phoenix_Final_Direct_Selling_Units_Calc__c=90;
        bidLine.Phoenix_Final_Indirect_Selling_Units_Cal__c=89;
        bidLine.Phoenix_SCM_Notes__c='RFP';
        bidLine.Phoenix_Marketing_Notes__c='notes';
        bidLine.Phoenix_Final_Indirect_Selling_Units_Cal__c=76;
        bidLine.Proposed_Net_Sales_Indirect__c=98;
        bidLine.Phoenix_Marketing_Approval__c='Not Approved';
        bidLine.Phoenix_Initial_Stocking_Order_Comments__c='test5';
        bidLine.Phoenix_Current_Direct_Price__c = 10;
        bidLine.Phoenix_Product_Code1__c = '300029858';
        bidLine.Phoenix_Product_Family1__c = 'Daptomycin Inj 500mg US';
        bidLine.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        bidLine.Phoenix_Proposed_Direct_Selling_Unit__c = 60;
        bidLine.Phoenix_Proposed_Indirect_Selling_Unit__c = 65;
        bidLine.Phoenix_Comments__c='Approved';
        bidLine.Phoenix_Contract_Comments__c='ahdu';
        bidLine.Phoenix_SCM_Approval_Y_N__c = 'N- Not Approved';
        bidLine.Phoenix_Marketing_Final_Approval__c = true;
        // bidline.Phoenix_Awarded_Net_Sales__c=45;
        bidline.Proposed_Net_Sales_Direct__c=45;
        bidline.Proposed_Net_Sales_Indirect__c=66;
        
        
        insert bidLine;
        Phoenix_Bid_Line_Item__c bidLine1 = new Phoenix_Bid_Line_Item__c();
        bidLine1.Phoenix_Product_Family1__c='tests';
        bidLine1.Phoenix_Bid__c = bid.id;
        bidLine1.Phoenix_Marketing_Approval__c='Not Approved';
        bidLine1.Phoenix_Vistex_Comments__c = 'test';
        bidLine1.Phoenix_Product__c = prdObj.Id;
        bidLine1.Phoenix_Bid_Status__c = 'Awarded';
        bidLine1.Phoenix_Proposed_Sales__c = 1000;
        bidLine1.Phoenix_Final_Direct_Selling_Units_Calc__c=90;
        bidLine1.Phoenix_Final_Indirect_Selling_Units_Cal__c=89;
        bidLine1.Phoenix_SCM_Notes__c='RFP';
        bidLine1.Phoenix_Marketing_Notes__c='notes';
        bidLine1.Phoenix_Final_Indirect_Selling_Units_Cal__c=76;
        bidLine1.Proposed_Net_Sales_Indirect__c=98;
        // bidLine1.Phoenix_Marketing_Approval__c='Not Approved';
        bidLine1.Phoenix_Initial_Stocking_Order_Comments__c='test5';
        bidLine1.Phoenix_Current_Direct_Price__c = 10;
        bidLine1.Phoenix_Product_Code1__c = '300029858';
        bidLine1.Phoenix_Product_Family1__c = 'Daptomycin Inj 500mg US';
        bidLine1.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        bidLine1.Phoenix_Proposed_Direct_Selling_Unit__c = 60;
        bidLine1.Phoenix_Proposed_Indirect_Selling_Unit__c = 65;
        bidLine1.Phoenix_Comments__c='Approved';
        bidLine1.Phoenix_Contract_Comments__c='ahdu';
        bidLine1.Phoenix_SCM_Approval_Y_N__c = 'N- Not Approved';
        bidLine1.Phoenix_Marketing_Final_Approval__c = true;
        // bidline.Phoenix_Awarded_Net_Sales__c=45;
        bidline1.Proposed_Net_Sales_Direct__c=45;
        bidline1.Proposed_Net_Sales_Indirect__c=66;
        
        
        insert bidLine1;
        
        
        GCP_SFDC_100pct_Analysis_SKU__c ndcItem = new GCP_SFDC_100pct_Analysis_SKU__c();
        ndcItem.Product_Family__c = 'Walgreens';
        ndcItem.Vision_Customer__c = acc.Id;
        ndcItem.Vision_Product__c = prdObj.Id;
        ndcitem.GCP_Product_Family__c='OLOPATADINE';
        ndcItem.Vision_Major_VolShare_Percent__c = 1100;
        ndcItem.Vision_Estimate_Account_Total_Vol_EU__c = 1000;
        ndcItem.Vision_CVS_VolShare_Percent__c = 1000;
        ndcItem.Vision_Cardinal_VolShare_Percent__c= 1000;
        insert ndcItem;
        
        GCP_100PCT_Analysis_SKU__c cc = new GCP_100PCT_Analysis_SKU__c();
        cc.GCP_Product_Family__c='Walgreens';
        cc.Vision_Product__c= prdObj.Id;
        insert cc;
        GCP_SFDC_100pct_Analysis_SKU__c ndcItem1 = new GCP_SFDC_100pct_Analysis_SKU__c();
        ndcItem1.Product_Family__c = 'Walgreens';
        ndcItem1.Vision_Customer__c = acc.Id;
        ndcItem1.Vision_Product__c = prdObj.Id;
        ndcitem1.GCP_Product_Family__c='OLOPATADINE';
        ndcItem1.Vision_Major_VolShare_Percent__c = 1100;
        ndcItem1.Vision_Estimate_Account_Total_Vol_EU__c = 1000;
        ndcItem1.Vision_CVS_VolShare_Percent__c = 1000;
        ndcItem1.Vision_Cardinal_VolShare_Percent__c= 1000;
        
        
        insert ndcItem1;
        
        Vision_Alert__c alertObj = new Vision_Alert__c();
        
        Vision_Customer_Product_Tracker__c cptObj = new Vision_Customer_Product_Tracker__c();
        cptObj.Vision_Account__c = acc.Id;
        cptObj.Vision_Product__c = prdObj.Id;
        insert cptObj;
        
        Vision_Alert__c newAlertObj = new Vision_Alert__c();
        newAlertObj.Name = '100%Item';
        newAlertObj.Account__c = acc.Id;
        newAlertObj.GCP_Opportunity_Tracker__c = gcp.Id;
        newAlertObj.Vision_Notification_Comment__c = 'THIS IS A TEST';
        insert newAlertObj;
        
        GCP_Comment__c cmnt = new GCP_Comment__c();
        cmnt.GCP_SFDC_100pct_Analysis_SKU__c = ndcItem.Id;
        cmnt.Comment_Type__c = 'Panorama';
        cmnt.Product_Family__c = 'Walgreens';
        cmnt.Comment_Date__c = system.today();
        insert cmnt;
        
        
        List<Phoenix_Bid_Process_Steps__c> pbps =new  List<Phoenix_Bid_Process_Steps__c>();
        
        Phoenix_Bid_Process_Steps__c step1 = new Phoenix_Bid_Process_Steps__c();
        step1.Phoenix_Bid__c = bid.id;
        step1.Phoenix_Approver_Team__c = '';
        pbps.add(step1);
        
        Phoenix_Bid_Process_Steps__c step2 = new Phoenix_Bid_Process_Steps__c();
        step2.Phoenix_Bid__c = bid.id;
        step2.Phoenix_Approver_Team__c ='Marketing';
        pbps.add(step2);
        
        Phoenix_Bid_Process_Steps__c step3 = new Phoenix_Bid_Process_Steps__c();
        step3.Phoenix_Bid__c = bid.id;
        step3.Phoenix_Approver_Team__c = 'Supply Chain';
        pbps.add(step3);
        
        Phoenix_Bid_Process_Steps__c step4 = new Phoenix_Bid_Process_Steps__c();
        step4.Phoenix_Bid__c = bid.id;
        step4.Phoenix_Approver_Team__c ='Contracts';
        pbps.add(step4);
        
        Phoenix_Bid_Process_Steps__c step5 = new Phoenix_Bid_Process_Steps__c();
        step5.Phoenix_Bid__c = bid.id;
        step5.Phoenix_Approver_Team__c ='Finance';
        pbps.add(step5);
        
        Phoenix_Bid_Process_Steps__c step6 = new Phoenix_Bid_Process_Steps__c();
        step6.Phoenix_Bid__c = bid.id;
        step6.Phoenix_Approver_Team__c ='Customer Service';
        pbps.add(step6);
        
        Phoenix_Bid_Process_Steps__c step7 = new Phoenix_Bid_Process_Steps__c();
        step7.Phoenix_Bid__c = bid.id;
        step7.Phoenix_Approver_Team__c ='Home Office';
        pbps.add(step7);
        
        insert pbps;
        
        Account acctest = new Account();
        acctest.Name = 'Red Oak Sourcing';
        acctest.Phoenix_Account_Cooling_Period__c = 40;
        insert acctest;
        List<GCP_SFDC_100pct_Analysis_SKU__c> gc = Phoenix_GCP_OptyTracker_Controller.saveConToAllSKUs('test',new list<GCP_SFDC_100pct_Analysis_SKU__c>{ndcItem,ndcItem1});
        List<GCP_SFDC_100pct_Analysis_SKU__c> spp = Phoenix_GCP_OptyTracker_Controller.updateNdcLineItemForROS(new list<GCP_SFDC_100pct_Analysis_SKU__c>{ndcItem,ndcItem1},false);
        //List<GCP_SFDC_100pct_Analysis_SKU__c> spp1 = Phoenix_GCP_OptyTracker_Controller.updateMemberVolShare(gcp,new list<GCP_SFDC_100pct_Analysis_SKU__c>{ndcItem,ndcItem1});
        //Phoenix_GCP_OptyTracker_Controller.saveAlert(alertObj, acc, gcp.Id, 'gcpItem');
        Phoenix_GCP_OptyTracker_Controller.getAwardedPositionData(ndcItem.Id, acctest);
        //Phoenix_GCP_OptyTracker_Controller.fetchVisionAlertList(gcp.Id,'gcpItem');
        Phoenix_GCP_OptyTracker_Controller.getProdStatusInfoNdcLevel(gcp);
        //Phoenix_GCP_OptyTracker_Controller.getStatusCount(gcp);
        Phoenix_GCP_OptyTracker_Controller.getNdcListOfProdFam('Walgreens',acc.Id);
    }
    static testmethod void test7(){
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.Phoenix_Account_Cooling_Period__c = 40;
        insert acc;
        
        Product_Family__c prodFamObj = new Product_Family__c();
        prodFamObj.Name = 'Walgreens';
        insert prodFamObj;
        
        Phoenix_GCP_Opportunity_Tracker__c gcp=new Phoenix_GCP_Opportunity_Tracker__c();
        gcp.gcp_customer_name__c='Sunil';
        gcp.Phoenix_Product_Family__c='Walgreens';
        gcp.Phoenix_Ims_Mat_Volume_Eu__c=10;
        gcp.Phoenix_Ims_Mat_Volume_Eu__c=10;
        gcp.Phoenix_Est_Price_Method__c='Use User Input';
        gcp.Phoenix_Est_Acct_Mkt_Share_User_Input__c=20;
        gcp.Phoenix_Customer__c = acc.Id;
        gcp.comments__c = 'test';
        gcp.GCP_Product_Family__c = 'OLOPATADINE';
        gcp.gcp_customer_name__c='Sunil';
        gcp.Phoenix_Product_Family__c= 'Walgreens';
        gcp.Phoenix_Ims_Mat_Volume_Eu__c=80;
        gcp.Phoenix_Est_Price_EU_Lowest_Price__c=10;
        gcp.Phoenix_Est_Price_Method__c='Use User Input';
        gcp.Phoenix_Est_Acct_Mkt_Share_User_Input__c=20;
        gcp.Phoenix_Est_Acct_Mkt_Share_Method__c='Use User Input';
        gcp.Phoenix_Est_Acct_Price_EU_User_Input__c=45;
        gcp.Product_Status__c = 'Awarded';
        insert gcp;
        
        Product2 prdObj = new Product2();
        prdObj.Name = 'testProd';
        prdObj.Family = 'Walgreens';
        prdobj.Phoenix_NDC_11__c='4563';
        prdobj.Product_Family__c = prodFamObj.Id;
        insert prdObj;
        
        Phoenix_Bid__c bid = new Phoenix_Bid__c();
        bid.Phoenix_Bid_Name__c = 'Test Bid';
        bid.Phoenix_Bid_Type__c = 'Product Addition';
        bid.Phoenix_Approval_Status__c='Closed';
        bid.Phoenix_Customer__c = acc.id;
        bid.Phoenix_Marketing_Comments__c='gjhyb';
        insert bid;
        Phoenix_Bid__c bid1 = new Phoenix_Bid__c();
        bid1.Phoenix_Bid_Name__c = 'Test Bid';
        bid1.Phoenix_Bid_Type__c = 'Product Addition';
        bid1.Phoenix_Approval_Status__c='Marketing Rejected';
        bid1.Phoenix_Customer__c = acc.id;
        bid1.Phoenix_Marketing_Comments__c='gjhyb';
        insert bid1;
        
        Phoenix_Bid_Line_Item__c bidLine = new Phoenix_Bid_Line_Item__c();
        bidLine.Phoenix_Product_Family1__c='tests';
        bidLine.Phoenix_Bid__c = bid.id;
        //bidLine.Phoenix_Marketing_Approval__c='Approved';
        bidLine.Phoenix_Vistex_Comments__c = 'test';
        bidLine.Phoenix_Product__c = prdObj.Id;
        bidLine.Phoenix_Bid_Status__c = 'Awarded';
        bidLine.Phoenix_Proposed_Sales__c = 1000;
        bidLine.Phoenix_Final_Direct_Selling_Units_Calc__c=90;
        bidLine.Phoenix_Final_Indirect_Selling_Units_Cal__c=89;
        bidLine.Phoenix_SCM_Notes__c='RFP';
        bidLine.Phoenix_Marketing_Notes__c='notes';
        bidLine.Phoenix_Final_Indirect_Selling_Units_Cal__c=76;
        bidLine.Proposed_Net_Sales_Indirect__c=98;
        bidLine.Phoenix_Marketing_Approval__c='Approved';
        bidLine.Phoenix_Initial_Stocking_Order_Comments__c='test5';
        bidLine.Phoenix_Current_Direct_Price__c = 10;
        bidLine.Phoenix_Product_Code1__c = '300029858';
        bidLine.Phoenix_Product_Family1__c = 'Daptomycin Inj 500mg US';
        bidLine.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        bidLine.Phoenix_Proposed_Direct_Selling_Unit__c = 60;
        bidLine.Phoenix_Proposed_Indirect_Selling_Unit__c = 65;
        bidLine.Phoenix_Comments__c='Approved';
        bidLine.Phoenix_Contract_Comments__c='ahdu';
        bidLine.Phoenix_SCM_Approval_Y_N__c = 'N- Not Approved';
        bidLine.Phoenix_Marketing_Final_Approval__c = true;
        // bidline.Phoenix_Awarded_Net_Sales__c=45;
        bidline.Proposed_Net_Sales_Direct__c=45;
        bidline.Proposed_Net_Sales_Indirect__c=66;
        
        
        insert bidLine;
        Phoenix_Bid_Line_Item__c bidLine1 = new Phoenix_Bid_Line_Item__c();
        bidLine1.Phoenix_Product_Family1__c='tests';
        bidLine1.Phoenix_Bid__c = bid.id;
        bidLine1.Phoenix_Marketing_Approval__c='Not Approved';
        bidLine1.Phoenix_Vistex_Comments__c = 'test';
        bidLine1.Phoenix_Product__c = prdObj.Id;
        bidLine1.Phoenix_Bid_Status__c = 'Awarded';
        bidLine1.Phoenix_Proposed_Sales__c = 1000;
        bidLine1.Phoenix_Final_Direct_Selling_Units_Calc__c=90;
        bidLine1.Phoenix_Final_Indirect_Selling_Units_Cal__c=89;
        bidLine1.Phoenix_SCM_Notes__c='RFP';
        bidLine1.Phoenix_Marketing_Notes__c='notes';
        bidLine1.Phoenix_Final_Indirect_Selling_Units_Cal__c=76;
        bidLine1.Proposed_Net_Sales_Indirect__c=98;
        // bidLine1.Phoenix_Marketing_Approval__c='Not Approved';
        bidLine1.Phoenix_Initial_Stocking_Order_Comments__c='test5';
        bidLine1.Phoenix_Current_Direct_Price__c = 10;
        bidLine1.Phoenix_Product_Code1__c = '300029858';
        bidLine1.Phoenix_Product_Family1__c = 'Daptomycin Inj 500mg US';
        bidLine1.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        bidLine1.Phoenix_Proposed_Direct_Selling_Unit__c = 60;
        bidLine1.Phoenix_Proposed_Indirect_Selling_Unit__c = 65;
        bidLine1.Phoenix_Comments__c='Approved';
        bidLine1.Phoenix_Contract_Comments__c='ahdu';
        bidLine1.Phoenix_SCM_Approval_Y_N__c = 'N- Not Approved';
        bidLine1.Phoenix_Marketing_Final_Approval__c = true;
        // bidline.Phoenix_Awarded_Net_Sales__c=45;
        bidline1.Proposed_Net_Sales_Direct__c=45;
        bidline1.Proposed_Net_Sales_Indirect__c=66;
        
        
        insert bidLine1;
        
        
        GCP_SFDC_100pct_Analysis_SKU__c ndcItem = new GCP_SFDC_100pct_Analysis_SKU__c();
        ndcItem.Product_Family__c = 'Walgreens';
        ndcItem.Vision_Customer__c = acc.Id;
        ndcItem.Vision_Product__c = prdObj.Id;
        ndcitem.GCP_Product_Family__c='OLOPATADINE';
        
        
        insert ndcItem;
        GCP_SFDC_100pct_Analysis_SKU__c ndcItem1 = new GCP_SFDC_100pct_Analysis_SKU__c();
        ndcItem1.Product_Family__c = 'Walgreens';
        ndcItem1.Vision_Customer__c = acc.Id;
        ndcItem1.Vision_Product__c = prdObj.Id;
        ndcitem1.GCP_Product_Family__c='OLOPATADINE';
        
        
        insert ndcItem1;
        
        Vision_Alert__c alertObj = new Vision_Alert__c();
        
        Vision_Customer_Product_Tracker__c cptObj = new Vision_Customer_Product_Tracker__c();
        cptObj.Vision_Account__c = acc.Id;
        cptObj.Vision_Product__c = prdObj.Id;
        insert cptObj;
        
        Vision_Alert__c newAlertObj = new Vision_Alert__c();
        newAlertObj.Name = '100%Item';
        newAlertObj.Account__c = acc.Id;
        newAlertObj.GCP_Opportunity_Tracker__c = gcp.Id;
        newAlertObj.Vision_Notification_Comment__c = 'THIS IS A TEST';
        insert newAlertObj;
        
        GCP_Comment__c cmnt = new GCP_Comment__c();
        cmnt.GCP_SFDC_100pct_Analysis_SKU__c = ndcItem.Id;
        cmnt.Comment_Type__c = 'Panorama';
        cmnt.Product_Family__c = 'Walgreens';
        cmnt.Comment_Date__c = system.today();
        insert cmnt;
		
		GCP_Comment__c cmnt1 = new GCP_Comment__c();
        cmnt1.GCP_SFDC_100pct_Analysis_SKU__c = ndcItem.Id;
        cmnt1.Comment_Type__c = 'Panorama Test';
        cmnt1.Product_Family__c = 'Walgreens';
        cmnt1.Comment_Date__c = system.today();
        insert cmnt1;        
        
        List<Phoenix_Bid_Process_Steps__c> pbps =new  List<Phoenix_Bid_Process_Steps__c>();
        
        Phoenix_Bid_Process_Steps__c step1 = new Phoenix_Bid_Process_Steps__c();
        step1.Phoenix_Bid__c = bid.id;
        step1.Phoenix_Approver_Team__c = '';
        pbps.add(step1);
        
        Phoenix_Bid_Process_Steps__c step2 = new Phoenix_Bid_Process_Steps__c();
        step2.Phoenix_Bid__c = bid.id;
        step2.Phoenix_Approver_Team__c ='Marketing';
        pbps.add(step2);
        
        Phoenix_Bid_Process_Steps__c step3 = new Phoenix_Bid_Process_Steps__c();
        step3.Phoenix_Bid__c = bid.id;
        step3.Phoenix_Approver_Team__c = 'Supply Chain';
        pbps.add(step3);
        
        Phoenix_Bid_Process_Steps__c step4 = new Phoenix_Bid_Process_Steps__c();
        step4.Phoenix_Bid__c = bid.id;
        step4.Phoenix_Approver_Team__c ='Contracts';
        pbps.add(step4);
        
        Phoenix_Bid_Process_Steps__c step5 = new Phoenix_Bid_Process_Steps__c();
        step5.Phoenix_Bid__c = bid.id;
        step5.Phoenix_Approver_Team__c ='Finance';
        pbps.add(step5);
        
        Phoenix_Bid_Process_Steps__c step6 = new Phoenix_Bid_Process_Steps__c();
        step6.Phoenix_Bid__c = bid.id;
        step6.Phoenix_Approver_Team__c ='Customer Service';
        pbps.add(step6);
        
        Phoenix_Bid_Process_Steps__c step7 = new Phoenix_Bid_Process_Steps__c();
        step7.Phoenix_Bid__c = bid.id;
        step7.Phoenix_Approver_Team__c ='Home Office';
        pbps.add(step7);
        
        insert pbps;
        
        Account acctest = new Account();
        acctest.Name = 'Red Oak Sourcing';
        acctest.Phoenix_Account_Cooling_Period__c = 40;
        insert acctest;
        string ss = Phoenix_GCP_OptyTracker_Controller.getCommentsOfPrds(new list<id>{prdObj.Id},acc.Id);
        Phoenix_GCP_OptyTracker_Controller.deleteComment(cmnt);
        Phoenix_GCP_OptyTracker_Controller.updateComment(cmnt1);
        //Phoenix_GCP_OptyTracker_Controller.saveAlert(alertObj, acc, gcp.Id, 'gcpItem');
        Phoenix_GCP_OptyTracker_Controller.getAwardedPositionData(ndcItem.Id, acctest);
        //Phoenix_GCP_OptyTracker_Controller.fetchVisionAlertList(gcp.Id,'gcpItem');
        Phoenix_GCP_OptyTracker_Controller.getProdStatusInfoNdcLevel(gcp);
        //Phoenix_GCP_OptyTracker_Controller.getStatusCount(gcp);
        Phoenix_GCP_OptyTracker_Controller.getNdcListOfProdFam('Walgreens',acc.Id);
    }
    static testmethod void test8(){
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.Phoenix_Account_Cooling_Period__c = 40;
        insert acc;
        
        Product_Family__c prodFamObj = new Product_Family__c();
        prodFamObj.Name = 'Walgreens';
        insert prodFamObj;
                
        Phoenix_GCP_Opportunity_Tracker__c gcp=new Phoenix_GCP_Opportunity_Tracker__c();
        gcp.gcp_customer_name__c='Sunil';
        gcp.Phoenix_Product_Family__c='Walgreens';
        gcp.Phoenix_Ims_Mat_Volume_Eu__c=10;
        gcp.Phoenix_Ims_Mat_Volume_Eu__c=10;
        gcp.Phoenix_Est_Price_Method__c='Use User Input';
        gcp.Phoenix_Est_Acct_Mkt_Share_User_Input__c=20;
        gcp.Phoenix_Customer__c = acc.Id;
        gcp.comments__c = 'test';
        gcp.GCP_Product_Family__c = 'OLOPATADINE';
        gcp.gcp_customer_name__c='Sunil';
        gcp.Phoenix_Product_Family__c= 'Walgreens';
        gcp.Phoenix_Ims_Mat_Volume_Eu__c=80;
        gcp.Phoenix_Est_Price_EU_Lowest_Price__c=10;
        gcp.Phoenix_Est_Price_Method__c='Use User Input';
        gcp.Phoenix_Est_Acct_Mkt_Share_User_Input__c=20;
        gcp.Phoenix_Est_Acct_Mkt_Share_Method__c='Use User Input';
        gcp.Phoenix_Est_Acct_Price_EU_User_Input__c=45;
        gcp.Product_Status__c = 'Awarded';
        insert gcp;
        
        Product2 prdObj = new Product2();
        prdObj.Name = 'testProd';
        prdObj.Family = 'Walgreens';
        prdobj.Phoenix_NDC_11__c='4563';
        prdobj.Product_Family__c = prodFamObj.Id;
        insert prdObj;
        
        Phoenix_Bid__c bid = new Phoenix_Bid__c();
        bid.Phoenix_Bid_Name__c = 'Test Bid';
        bid.Phoenix_Bid_Type__c = 'Product Addition';
        bid.Phoenix_Approval_Status__c='Rejected';
        bid.Phoenix_Customer__c = acc.id;
        bid.Phoenix_Marketing_Comments__c='gjhyb';
        insert bid;
        Phoenix_Bid__c bid1 = new Phoenix_Bid__c();
        bid1.Phoenix_Bid_Name__c = 'Test Bid';
        bid1.Phoenix_Bid_Type__c = 'Product Addition';
        bid1.Phoenix_Approval_Status__c='Marketing Rejected';
        bid1.Phoenix_Customer__c = acc.id;
        bid1.Phoenix_Marketing_Comments__c='gjhyb';
        insert bid1;
        
        Phoenix_Bid_Line_Item__c bidLine = new Phoenix_Bid_Line_Item__c();
        bidLine.Phoenix_Product_Family1__c='tests';
        bidLine.Phoenix_Bid__c = bid.id;
        //bidLine.Phoenix_Marketing_Approval__c='Approved';
        bidLine.Phoenix_Vistex_Comments__c = 'test';
        bidLine.Phoenix_Product__c = prdObj.Id;
        bidLine.Phoenix_Bid_Status__c = 'Awarded';
        bidLine.Phoenix_Proposed_Sales__c = 1000;
        bidLine.Phoenix_Final_Direct_Selling_Units_Calc__c=90;
        bidLine.Phoenix_Final_Indirect_Selling_Units_Cal__c=89;
        bidLine.Phoenix_SCM_Notes__c='RFP';
        bidLine.Phoenix_Marketing_Notes__c='notes';
        bidLine.Phoenix_Final_Indirect_Selling_Units_Cal__c=76;
        bidLine.Proposed_Net_Sales_Indirect__c=98;
        bidLine.Phoenix_Marketing_Approval__c='Approved';
        bidLine.Phoenix_Initial_Stocking_Order_Comments__c='test5';
        bidLine.Phoenix_Current_Direct_Price__c = 10;
        bidLine.Phoenix_Product_Code1__c = '300029858';
        bidLine.Phoenix_Product_Family1__c = 'Daptomycin Inj 500mg US';
        bidLine.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        bidLine.Phoenix_Proposed_Direct_Selling_Unit__c = 60;
        bidLine.Phoenix_Proposed_Indirect_Selling_Unit__c = 65;
        bidLine.Phoenix_Comments__c='Approved';
        bidLine.Phoenix_Contract_Comments__c='ahdu';
        // bidLine.Phoenix_SCM_Approval_Y_N__c = 'N- Not Approved';
        bidLine.Phoenix_Marketing_Final_Approval__c = true;
        // bidline.Phoenix_Awarded_Net_Sales__c=45;
        bidline.Proposed_Net_Sales_Direct__c=45;
        bidline.Proposed_Net_Sales_Indirect__c=66;
        
        
        insert bidLine;
        Phoenix_Bid_Line_Item__c bidLine1 = new Phoenix_Bid_Line_Item__c();
        bidLine1.Phoenix_Product_Family1__c='tests';
        bidLine1.Phoenix_Bid__c = bid.id;
        //bidLine1.Phoenix_Marketing_Approval__c='Not Apprcoved';
        bidLine1.Phoenix_Vistex_Comments__c = 'test';
        bidLine1.Phoenix_Product__c = prdObj.Id;
        bidLine1.Phoenix_Bid_Status__c = 'Awarded';
        bidLine1.Phoenix_Proposed_Sales__c = 1000;
        bidLine1.Phoenix_Final_Direct_Selling_Units_Calc__c=90;
        bidLine1.Phoenix_Final_Indirect_Selling_Units_Cal__c=89;
        bidLine1.Phoenix_SCM_Notes__c='RFP';
        bidLine1.Phoenix_Marketing_Notes__c='notes';
        bidLine1.Phoenix_Final_Indirect_Selling_Units_Cal__c=76;
        bidLine1.Proposed_Net_Sales_Indirect__c=98;
        // bidLine1.Phoenix_Marketing_Approval__c='Not Approved';
        bidLine1.Phoenix_Initial_Stocking_Order_Comments__c='test5';
        bidLine1.Phoenix_Current_Direct_Price__c = 10;
        bidLine1.Phoenix_Product_Code1__c = '300029858';
        bidLine1.Phoenix_Product_Family1__c = 'Daptomycin Inj 500mg US';
        bidLine1.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        bidLine1.Phoenix_Proposed_Direct_Selling_Unit__c = 60;
        bidLine1.Phoenix_Proposed_Indirect_Selling_Unit__c = 65;
        bidLine1.Phoenix_Comments__c='Approved';
        bidLine1.Phoenix_Contract_Comments__c='ahdu';
        // bidLine1.Phoenix_SCM_Approval_Y_N__c = 'N- Not Acpproved';
        bidLine1.Phoenix_Marketing_Final_Approval__c = true;
        // bidline.Phoenix_Awarded_Net_Sales__c=45;
        bidline1.Proposed_Net_Sales_Direct__c=45;
        bidline1.Proposed_Net_Sales_Indirect__c=66;
        
        
        insert bidLine1;
        
        
        GCP_SFDC_100pct_Analysis_SKU__c ndcItem = new GCP_SFDC_100pct_Analysis_SKU__c();
        ndcItem.Product_Family__c = 'Walgreens';
        ndcItem.Vision_Customer__c = acc.Id;
        ndcItem.Vision_Product__c = prdObj.Id;
        ndcitem.GCP_Product_Family__c='OLOPATADINE';
        
        
        insert ndcItem;
        GCP_SFDC_100pct_Analysis_SKU__c ndcItem1 = new GCP_SFDC_100pct_Analysis_SKU__c();
        ndcItem1.Product_Family__c = 'Walgreens';
        ndcItem1.Vision_Customer__c = acc.Id;
        ndcItem1.Vision_Product__c = prdObj.Id;
        ndcitem1.GCP_Product_Family__c='OLOPATADINE';
        
        
        insert ndcItem1;
        
        Vision_Alert__c alertObj = new Vision_Alert__c();
        
        Vision_Customer_Product_Tracker__c cptObj = new Vision_Customer_Product_Tracker__c();
        cptObj.Vision_Account__c = acc.Id;
        cptObj.Vision_Product__c = prdObj.Id;
        insert cptObj;
        
        Vision_Alert__c newAlertObj = new Vision_Alert__c();
        newAlertObj.Name = '100%Item';
        newAlertObj.Account__c = acc.Id;
        newAlertObj.GCP_Opportunity_Tracker__c = gcp.Id;
        newAlertObj.Vision_Notification_Comment__c = 'THIS IS A TEST';
        insert newAlertObj;
        
        GCP_Comment__c cmnt = new GCP_Comment__c();
        cmnt.GCP_SFDC_100pct_Analysis_SKU__c = ndcItem.Id;
        cmnt.Comment_Type__c = 'Panorama';
        cmnt.Product_Family__c = 'Walgreens';
        cmnt.Comment_Date__c = system.today();
        insert cmnt;
        
        
        List<Phoenix_Bid_Process_Steps__c> pbps =new  List<Phoenix_Bid_Process_Steps__c>();
        
        Phoenix_Bid_Process_Steps__c step1 = new Phoenix_Bid_Process_Steps__c();
        step1.Phoenix_Bid__c = bid.id;
        step1.Phoenix_Approver_Team__c = '';
        pbps.add(step1);
        
        Phoenix_Bid_Process_Steps__c step2 = new Phoenix_Bid_Process_Steps__c();
        step2.Phoenix_Bid__c = bid.id;
        step2.Phoenix_Approver_Team__c ='Marketing';
        pbps.add(step2);
        
        Phoenix_Bid_Process_Steps__c step3 = new Phoenix_Bid_Process_Steps__c();
        step3.Phoenix_Bid__c = bid.id;
        step3.Phoenix_Approver_Team__c = 'Supply Chain';
        pbps.add(step3);
        
        Phoenix_Bid_Process_Steps__c step4 = new Phoenix_Bid_Process_Steps__c();
        step4.Phoenix_Bid__c = bid.id;
        step4.Phoenix_Approver_Team__c ='Contracts';
        pbps.add(step4);
        
        Phoenix_Bid_Process_Steps__c step5 = new Phoenix_Bid_Process_Steps__c();
        step5.Phoenix_Bid__c = bid.id;
        step5.Phoenix_Approver_Team__c ='Finance';
        pbps.add(step5);
        
        Phoenix_Bid_Process_Steps__c step6 = new Phoenix_Bid_Process_Steps__c();
        step6.Phoenix_Bid__c = bid.id;
        step6.Phoenix_Approver_Team__c ='Customer Service';
        pbps.add(step6);
        
        Phoenix_Bid_Process_Steps__c step7 = new Phoenix_Bid_Process_Steps__c();
        step7.Phoenix_Bid__c = bid.id;
        step7.Phoenix_Approver_Team__c ='Home Office';
        pbps.add(step7);
        
        insert pbps;
        Account acctest = new Account();
        acctest.Name = 'Red Oak Sourcing';
        acctest.Phoenix_Account_Cooling_Period__c = 40;
        insert acctest;
        string sc = Phoenix_GCP_OptyTracker_Controller.saveCommentToAllSKUs(gcp,new List<GCP_SFDC_100pct_Analysis_SKU__c> {ndcItem, ndcItem1});
        //Phoenix_GCP_OptyTracker_Controller.saveAlert(alertObj, acc, gcp.Id, 'gcpItem');
        Phoenix_GCP_OptyTracker_Controller.getAwardedPositionData(ndcItem.Id, acctest);
        //Phoenix_GCP_OptyTracker_Controller.fetchVisionAlertList(gcp.Id,'gcpItem');
        Phoenix_GCP_OptyTracker_Controller.getProdStatusInfoNdcLevel(gcp);
        //Phoenix_GCP_OptyTracker_Controller.getStatusCount(gcp);
        Phoenix_GCP_OptyTracker_Controller.getNdcListOfProdFam('Walgreens',acc.Id);
    }
    static testmethod void test9(){
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.Phoenix_Account_Cooling_Period__c = 40;
        insert acc;
        
        Product_Family__c prodFamObj = new Product_Family__c();
        prodFamObj.Name = 'Walgreens';
        insert prodFamObj;
        
        Phoenix_GCP_Opportunity_Tracker__c gcp=new Phoenix_GCP_Opportunity_Tracker__c();
        gcp.gcp_customer_name__c='Sunil';
        gcp.Phoenix_Product_Family__c='Walgreens';
        gcp.Phoenix_Ims_Mat_Volume_Eu__c=10;
        gcp.Phoenix_Ims_Mat_Volume_Eu__c=10;
        gcp.Phoenix_Est_Price_Method__c='Use User Input';
        gcp.Phoenix_Est_Acct_Mkt_Share_User_Input__c=20;
        gcp.Phoenix_Customer__c = acc.Id;
        gcp.comments__c = 'test';
        gcp.GCP_Product_Family__c = 'OLOPATADINE';
        gcp.gcp_customer_name__c='Sunil';
        gcp.Phoenix_Product_Family__c= 'Walgreens';
        gcp.Phoenix_Ims_Mat_Volume_Eu__c=80;
        gcp.Phoenix_Est_Price_EU_Lowest_Price__c=10;
        gcp.Phoenix_Est_Price_Method__c='Use User Input';
        gcp.Phoenix_Est_Acct_Mkt_Share_User_Input__c=20;
        gcp.Phoenix_Est_Acct_Mkt_Share_Method__c='Use User Input';
        gcp.Phoenix_Est_Acct_Price_EU_User_Input__c=45;
        gcp.Product_Status__c = 'Awarded';
        insert gcp;
        
        Product2 prdObj = new Product2();
        prdObj.Name = 'testProd';
        prdObj.Family = 'Walgreens';
        prdobj.Phoenix_NDC_11__c='4563';
        prdobj.Product_Family__c = prodFamObj.Id;
        insert prdObj;
        
        Phoenix_Bid__c bid = new Phoenix_Bid__c();
        bid.Phoenix_Bid_Name__c = 'Test Bid';
        bid.Phoenix_Bid_Type__c = 'Product Addition';
        bid.Phoenix_Approval_Status__c='Closed';
        bid.Phoenix_Customer__c = acc.id;
        bid.Phoenix_Marketing_Comments__c='gjhyb';
        insert bid;
        Phoenix_Bid__c bid1 = new Phoenix_Bid__c();
        bid1.Phoenix_Bid_Name__c = 'Test Bid';
        bid1.Phoenix_Bid_Type__c = 'Product Addition';
        bid1.Phoenix_Approval_Status__c='Marketing Rejected';
        bid1.Phoenix_Customer__c = acc.id;
        bid1.Phoenix_Marketing_Comments__c='gjhyb';
        insert bid1;
        
        Phoenix_Bid_Line_Item__c bidLine = new Phoenix_Bid_Line_Item__c();
        bidLine.Phoenix_Product_Family1__c='tests';
        bidLine.Phoenix_Bid__c = bid.id;
        //bidLine.Phoenix_Marketing_Approval__c='Approved';
        bidLine.Phoenix_Vistex_Comments__c = 'test';
        bidLine.Phoenix_Product__c = prdObj.Id;
        bidLine.Phoenix_Bid_Status__c = 'Awarded';
        bidLine.Phoenix_Proposed_Sales__c = 1000;
        bidLine.Phoenix_Final_Direct_Selling_Units_Calc__c=90;
        bidLine.Phoenix_Final_Indirect_Selling_Units_Cal__c=89;
        bidLine.Phoenix_SCM_Notes__c='RFP';
        bidLine.Phoenix_Marketing_Notes__c='notes';
        bidLine.Phoenix_Final_Indirect_Selling_Units_Cal__c=76;
        bidLine.Proposed_Net_Sales_Indirect__c=98;
        bidLine.Phoenix_Marketing_Approval__c='Approved';
        bidLine.Phoenix_Initial_Stocking_Order_Comments__c='test5';
        bidLine.Phoenix_Current_Direct_Price__c = 10;
        bidLine.Phoenix_Product_Code1__c = '300029858';
        bidLine.Phoenix_Product_Family1__c = 'Daptomycin Inj 500mg US';
        bidLine.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        bidLine.Phoenix_Proposed_Direct_Selling_Unit__c = 60;
        bidLine.Phoenix_Proposed_Indirect_Selling_Unit__c = 65;
        bidLine.Phoenix_Comments__c='Approved';
        bidLine.Phoenix_Contract_Comments__c='ahdu';
        // bidLine.Phoenix_SCM_Approval_Y_N__c = 'N- Noth Approved';
        bidLine.Phoenix_Marketing_Final_Approval__c = true;
        // bidline.Phoenix_Awarded_Net_Sales__c=45;
        bidline.Proposed_Net_Sales_Direct__c=45;
        bidline.Proposed_Net_Sales_Indirect__c=66;
        
        
        insert bidLine;
        Phoenix_Bid_Line_Item__c bidLine1 = new Phoenix_Bid_Line_Item__c();
        bidLine1.Phoenix_Product_Family1__c='tests';
        bidLine1.Phoenix_Bid__c = bid.id;
        //bidLine1.Phoenix_Marketing_Approval__c='Not Appjrove;
        bidLine1.Phoenix_Vistex_Comments__c = 'test';
        bidLine1.Phoenix_Product__c = prdObj.Id;
        bidLine1.Phoenix_Bid_Status__c = 'Awarded';
        bidLine1.Phoenix_Proposed_Sales__c = 1000;
        bidLine1.Phoenix_Final_Direct_Selling_Units_Calc__c=90;
        bidLine1.Phoenix_Final_Indirect_Selling_Units_Cal__c=89;
        bidLine1.Phoenix_SCM_Notes__c='RFP';
        bidLine1.Phoenix_Marketing_Notes__c='notes';
        bidLine1.Phoenix_Final_Indirect_Selling_Units_Cal__c=76;
        bidLine1.Proposed_Net_Sales_Indirect__c=98;
        // bidLine1.Phoenix_Marketing_Approval__c='Not Approved';
        bidLine1.Phoenix_Initial_Stocking_Order_Comments__c='test5';
        bidLine1.Phoenix_Current_Direct_Price__c = 10;
        bidLine1.Phoenix_Product_Code1__c = '300029858';
        bidLine1.Phoenix_Product_Family1__c = 'Daptomycin Inj 500mg US';
        bidLine1.Phoenix_Current_Indirect_Selling_Unit__c = 10;
        bidLine1.Phoenix_Proposed_Direct_Selling_Unit__c = 60;
        bidLine1.Phoenix_Proposed_Indirect_Selling_Unit__c = 65;
        bidLine1.Phoenix_Comments__c='Approved';
        bidLine1.Phoenix_Contract_Comments__c='ahdu';
        //bidLine1.Phoenix_SCM_Approval_Y_N__c = 'N- Not Approved';
        bidLine1.Phoenix_Marketing_Final_Approval__c = true;
        // bidline.Phoenix_Awarded_Net_Sales__c=45;
        bidline1.Proposed_Net_Sales_Direct__c=45;
        bidline1.Proposed_Net_Sales_Indirect__c=66;
        
        
        insert bidLine1;
        
        
        GCP_SFDC_100pct_Analysis_SKU__c ndcItem = new GCP_SFDC_100pct_Analysis_SKU__c();
        ndcItem.Product_Family__c = 'Walgreens';
        ndcItem.Vision_Customer__c = acc.Id;
        //ndcItem.Vision_Product__c = prdObj.Id;
        ndcitem.GCP_Product_Family__c='OLOPATADINE';
        
        
        insert ndcItem;
        GCP_SFDC_100pct_Analysis_SKU__c ndcItem1 = new GCP_SFDC_100pct_Analysis_SKU__c();
        ndcItem1.Product_Family__c = 'Walgreens';
        ndcItem1.Vision_Customer__c = acc.Id;
        ndcItem1.Vision_Product__c = prdObj.Id;
        ndcitem1.GCP_Product_Family__c='OLOPATADINE';
        
        
        insert ndcItem1;
        
        Vision_Alert__c alertObj = new Vision_Alert__c();
        
        Vision_Customer_Product_Tracker__c cptObj = new Vision_Customer_Product_Tracker__c();
        cptObj.Vision_Account__c = acc.Id;
        cptObj.Vision_Product__c = prdObj.Id;
        insert cptObj;
        
        Vision_Alert__c newAlertObj = new Vision_Alert__c();
        newAlertObj.Name = '100%Item';
        newAlertObj.Account__c = acc.Id;
        newAlertObj.GCP_Opportunity_Tracker__c = gcp.Id;
        newAlertObj.Vision_Notification_Comment__c = 'THIS IS A TEST';
        insert newAlertObj;
        
        GCP_Comment__c cmnt = new GCP_Comment__c();
        cmnt.GCP_SFDC_100pct_Analysis_SKU__c = ndcItem.Id;
        cmnt.Comment_Type__c = 'Panorama';
        cmnt.Product_Family__c = 'Walgreens';
        cmnt.Comment_Date__c = system.today();
        insert cmnt;
        
        
        List<Phoenix_Bid_Process_Steps__c> pbps =new  List<Phoenix_Bid_Process_Steps__c>();
        
        Phoenix_Bid_Process_Steps__c step1 = new Phoenix_Bid_Process_Steps__c();
        step1.Phoenix_Bid__c = bid.id;
        step1.Phoenix_Approver_Team__c = '';
        pbps.add(step1);
        
        Phoenix_Bid_Process_Steps__c step2 = new Phoenix_Bid_Process_Steps__c();
        step2.Phoenix_Bid__c = bid.id;
        step2.Phoenix_Approver_Team__c ='Marketing';
        pbps.add(step2);
        
        Phoenix_Bid_Process_Steps__c step3 = new Phoenix_Bid_Process_Steps__c();
        step3.Phoenix_Bid__c = bid.id;
        step3.Phoenix_Approver_Team__c = 'Supply Chain';
        pbps.add(step3);
        
        Phoenix_Bid_Process_Steps__c step4 = new Phoenix_Bid_Process_Steps__c();
        step4.Phoenix_Bid__c = bid.id;
        step4.Phoenix_Approver_Team__c ='Contracts';
        pbps.add(step4);
        
        Phoenix_Bid_Process_Steps__c step5 = new Phoenix_Bid_Process_Steps__c();
        step5.Phoenix_Bid__c = bid.id;
        step5.Phoenix_Approver_Team__c ='Finance';
        pbps.add(step5);
        
        Phoenix_Bid_Process_Steps__c step6 = new Phoenix_Bid_Process_Steps__c();
        step6.Phoenix_Bid__c = bid.id;
        step6.Phoenix_Approver_Team__c ='Customer Service';
        pbps.add(step6);
        
        Phoenix_Bid_Process_Steps__c step7 = new Phoenix_Bid_Process_Steps__c();
        step7.Phoenix_Bid__c = bid.id;
        step7.Phoenix_Approver_Team__c ='Home Office';
        pbps.add(step7);
        
        insert pbps;
        Account acctest = new Account();
        acctest.Name = 'Red Oak Sourcing';
        acctest.Phoenix_Account_Cooling_Period__c = 40;
        insert acctest;
        
        //Phoenix_GCP_OptyTracker_Controller.saveAlert(alertObj, acc, gcp.Id, 'gcpItem');
        Phoenix_GCP_OptyTracker_Controller.getAwardedPositionData(ndcItem.Id, acctest);
        //Phoenix_GCP_OptyTracker_Controller.fetchVisionAlertList(gcp.Id,'gcpItem');
        Phoenix_GCP_OptyTracker_Controller.getProdStatusInfoNdcLevel(gcp);
        //Phoenix_GCP_OptyTracker_Controller.getStatusCount(gcp);
        Phoenix_GCP_OptyTracker_Controller.getNdcListOfProdFam('Walgreens',acc.Id);
    }
    static testmethod void test4(){
        Account acc = new Account();
        acc.Name = 'Test Account';
        insert acc;
        
        Phoenix_GCP_Opportunity_Tracker__c gcp=new Phoenix_GCP_Opportunity_Tracker__c();
        gcp.gcp_customer_name__c='Sunil';
        gcp.Phoenix_Product_Family__c='Walgreens';
        gcp.Phoenix_Ims_Mat_Volume_Eu__c=10;
        gcp.Phoenix_Ims_Mat_Volume_Eu__c=10;
        gcp.Phoenix_Est_Price_Method__c='Use User Input';
        gcp.Phoenix_Est_Acct_Mkt_Share_User_Input__c=20;
        gcp.Phoenix_Customer__c = acc.Id;
        gcp.comments__c = 'test';
        gcp.GCP_Product_Family__c = 'OLOPATADINE';
        gcp.gcp_customer_name__c='Sunil';
        gcp.Phoenix_Product_Family__c= 'Walgreens';
        gcp.Phoenix_Ims_Mat_Volume_Eu__c=80;
        gcp.Phoenix_Est_Price_EU_Lowest_Price__c=10;
        gcp.Phoenix_Est_Price_Method__c='Use User Input';
        gcp.Phoenix_Est_Acct_Mkt_Share_User_Input__c=20;
        gcp.Phoenix_Est_Acct_Mkt_Share_Method__c='Use User Input';
        gcp.Phoenix_Est_Acct_Price_EU_User_Input__c=45;
        gcp.Product_Status__c = 'Awarded';
        insert gcp;
        
        GCP_SFDC_100pct_Analysis_SKU__c ndcItem = new GCP_SFDC_100pct_Analysis_SKU__c();
        ndcItem.Product_Family__c = 'Walgreens';
        ndcItem.Vision_Customer__c = acc.Id;
        insert ndcItem;
        
        Vision_Alert__c alertObj = new Vision_Alert__c();
        
        Vision_Alert__c newAlertObj = new Vision_Alert__c();
        newAlertObj.Name = '100%Item';
        newAlertObj.Account__c = acc.Id;
        newAlertObj.GCP_SFDC_100pct_Analysis_SKU__c = ndcItem.Id;
        newAlertObj.Vision_Notification_Comment__c = 'THIS IS A TEST';
        insert newAlertObj;
        
        //Phoenix_GCP_OptyTracker_Controller.saveAlert(alertObj, acc, ndcItem.Id, 'ndcItem');
        //Phoenix_GCP_OptyTracker_Controller.fetchVisionAlertList(ndcItem.Id,'ndcItem');
    }
    /*static testmethod void test5(){
        Phoenix_GCP_OptyTracker_Controller.Wrapper wrap=new Phoenix_GCP_OptyTracker_Controller.Wrapper();
        wrap.EstAcctSales=10.20;
        
        Phoenix_GCP_OptyTracker_Controller.cmntWrapper cmntwrap=new Phoenix_GCP_OptyTracker_Controller.cmntWrapper();
        cmntwrap.cmntString='test';
        
     }*/
    
         
    
}