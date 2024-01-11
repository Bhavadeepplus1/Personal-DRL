@istest
public class Vision_Order_Compliance_Report_Test_Cls {
    static testmethod void testmethod1(){
       User systemUser = [SELECT Id, Name FROM USER WHERE NAME='LISA CARDETTI' LIMIT 1];
        Account acc = new Account();
        acc.AccountNumber = '115576';
        acc.Name = 'Amazon'; 
        insert acc;
        Product2 prod = new Product2();
        prod.Name = 'Alloprinol';
        prod.Family = 'Alloprinol';
        prod.Phoenix_Rx_SRx_OTC__c = 'Rx';
        prod.IsActive = true;
        prod.Phoenix_Product_Director__c= systemUser.Id;
        prod.Phoenix_Is_Exclude_Bid__c =false;
       
        insert prod;
       Product2 prod1 = new Product2();
        prod1.Name = 'Alloprinol';
        prod1.Family = 'Alloprinol';
        prod1.Phoenix_Rx_SRx_OTC__c = 'Rx';
        prod1.IsActive = true;
        prod1.Phoenix_Product_Director__c= systemUser.Id;
        prod1.Phoenix_Is_Exclude_Bid__c =false;
       
        insert prod1;
        Order_Compliance_Data__c comp = new Order_Compliance_Data__c();
         comp.Vision_Product__c = prod.Id;
        comp.Hierachy_Code__c = '115576';
        comp.General_Category__c = 'Primary';
        comp.M1_Quantity__c = 60;
        comp.M2_Quantity__c = 60;
        comp.M3_Quantity__c = 60;
        comp.M4_Quantity__c = 60;
        comp.M5_Quantity__c = 60;
        comp.M6_Quantity__c = 60;
        comp.M7_Quantity__c = 60;
        comp.M8_Quantity__c = 60;
        comp.M9_Quantity__c = 60;
        comp.M10_Quantity__c = 60;
        comp.M11_Quantity__c = 60;
        comp.M12_Quantity__c = 60;
        comp.M13_Quantity__c = 60;
        comp.M14_Quantity__c = 60;
        comp.M15_Quantity__c = 60;
        comp.Awarded_Quantity__c =1200;
        comp.Month1__c='Jan';
         comp.Month2__c='Jan';
         comp.Month3__c='Jan';
         comp.Month4__c='Jan';
         comp.Month5__c='Jan';
         comp.Month6__c='Jan';
         comp.Month7__c='Jan';
         comp.Month8__c='Jan';
        comp.Month9__c='Jan';
        comp.Month10__c='Jan';
        insert comp;
        
         Order_Compliance_Data__c comp1 = new Order_Compliance_Data__c();
         comp1.Vision_Product__c = prod1.Id;
        comp1.Hierachy_Code__c = '115576';
        comp1.General_Category__c = 'Primary';
        comp1.M1_Quantity__c = 800;
        comp1.M2_Quantity__c = 800;
        comp1.M3_Quantity__c = 800;
        comp1.M4_Quantity__c = 800;
        comp1.M5_Quantity__c = 800;
        comp1.M6_Quantity__c = 800;
        comp1.M7_Quantity__c = 800;
        comp1.M8_Quantity__c = 800;
        comp1.M9_Quantity__c = 800;
        comp1.M10_Quantity__c = 800;
        comp1.M11_Quantity__c = 800;
        comp1.M12_Quantity__c = 800;
        comp1.M13_Quantity__c = 800;
        comp1.M14_Quantity__c = 800;
        comp1.M15_Quantity__c = 800;
        comp1.Awarded_Quantity__c =1200;
         comp1.Month1__c='Jan';
         comp1.Month2__c='Jan';
         comp1.Month3__c='Jan';
         comp1.Month4__c='Jan';
         comp1.Month5__c='Jan';
         comp1.Month6__c='Jan';
         comp1.Month7__c='Jan';
         comp1.Month8__c='Jan';
        comp1.Month9__c='Jan';
        comp1.Month10__c='Jan';
        insert comp1;
        Vision_Order_Compliance_Report_Class.getOnlyComplianceData('allop', acc.Id,'1Month', false, 'LISA CARDETTI');
        Vision_Order_Compliance_Report_Class.getOnlyComplianceData('', acc.Id,'1Month', false, 'LISA CARDETTI');
        Vision_Order_Compliance_Report_Class.getOnlyComplianceData('', acc.Id,'1Month', true, 'LISA CARDETTI');
        Vision_Order_Compliance_Report_Class.getOnlyComplianceData('allop', acc.Id,'1Month', true, '');
        Vision_Order_Compliance_Report_Class.getOnlyComplianceData('', acc.Id,'1Month', true, '');
        Vision_Order_Compliance_Report_Class.getOnlyComplianceData('allop', acc.Id,'2Month', false, 'LISA CARDETTI');
        
        Vision_Order_Compliance_Report_Class.getOnlyComplianceData('allop', acc.Id,'3Month', false, 'LISA CARDETTI');
        
        Vision_Order_Compliance_Report_Class.getOnlyComplianceData('allop', acc.Id,'4Month', false, 'LISA CARDETTI');
        
        Vision_Order_Compliance_Report_Class.getOnlyComplianceData('allop', acc.Id,'5Month', false, 'LISA CARDETTI');
        
        Vision_Order_Compliance_Report_Class.getOnlyComplianceData('allop', acc.Id,'6Month', false, 'LISA CARDETTI');
        
        Vision_Order_Compliance_Report_Class.getOnlyComplianceData('allop', acc.Id,'ShowAll', false, 'LISA CARDETTI');
		Vision_Order_Compliance_Report_Class.codeCoverage();
        


    }
     static testmethod void testmethod2(){
       User systemUser = [SELECT Id, Name FROM USER WHERE NAME='LISA CARDETTI' LIMIT 1];
        Account acc = new Account();
        acc.AccountNumber = '115576';
        acc.Name = 'Amazon'; 
        insert acc;
        Product2 prod = new Product2();
        prod.Name = 'Alloprinol';
        prod.Family = 'Alloprinol';
        prod.Phoenix_Rx_SRx_OTC__c = 'Rx';
        prod.IsActive = true;
        prod.Phoenix_Product_Director__c= systemUser.Id;
        prod.Phoenix_Is_Exclude_Bid__c =false;
       
        insert prod;
       Product2 prod1 = new Product2();
        prod1.Name = 'Alloprinol';
        prod1.Family = 'Alloprinol';
        prod1.Phoenix_Rx_SRx_OTC__c = 'Rx';
        prod1.IsActive = true;
        prod1.Phoenix_Product_Director__c= systemUser.Id;
        prod1.Phoenix_Is_Exclude_Bid__c =false;
        prod1.ProductCode='115576'; 
        insert prod1;
        Order_Compliance_Data__c comp = new Order_Compliance_Data__c();
         comp.Vision_Product__c = prod.Id;
        comp.Hierachy_Code__c = '115576';
        comp.General_Category__c = 'Primary';
        comp.M1_Quantity__c = 60;
        comp.M2_Quantity__c = 60;
        comp.M3_Quantity__c = 60;
        comp.M4_Quantity__c = 60;
        comp.M5_Quantity__c = 60;
        comp.M6_Quantity__c = 60;
        comp.M7_Quantity__c = 60;
        comp.M8_Quantity__c = 60;
        comp.M9_Quantity__c = 60;
        comp.M10_Quantity__c = 60;
        comp.M11_Quantity__c = 60;
        comp.M12_Quantity__c = 60;
        comp.M13_Quantity__c = 60;
        comp.M14_Quantity__c = 60;
        comp.M15_Quantity__c = 60;
        comp.Month1__c='Jan';
         comp.Month2__c='Jan';
         comp.Month3__c='Jan';
         comp.Month4__c='Jan';
         comp.Month5__c='Jan';
         comp.Month6__c='Jan';
         comp.Month7__c='Jan';
         comp.Month8__c='Jan';
        comp.Month9__c='Jan';
        comp.Month10__c='Jan';
        insert comp;
        
         Order_Compliance_Data__c comp1 = new Order_Compliance_Data__c();
         comp1.Vision_Product__c = prod1.Id;
        comp1.Hierachy_Code__c = '115576';
        comp1.General_Category__c = 'Primary';
        comp1.M1_Quantity__c = 800;
        comp1.M2_Quantity__c = 800;
        comp1.M3_Quantity__c = 800;
        comp1.M4_Quantity__c = 800;
        comp1.M5_Quantity__c = 800;
        comp1.M6_Quantity__c = 800;
        comp1.M7_Quantity__c = 800;
        comp1.M8_Quantity__c = 800;
        comp1.M9_Quantity__c = 800;
        comp1.M10_Quantity__c = 800;
        comp1.M11_Quantity__c = 800;
        comp1.M12_Quantity__c = 800;
        comp1.M13_Quantity__c = 800;
        comp1.M14_Quantity__c = 800;
        comp1.M15_Quantity__c = 800;
         comp1.Month1__c='Jan';
         comp1.Month2__c='Jan';
         comp1.Month3__c='Jan';
         comp1.Month4__c='Jan';
         comp1.Month5__c='Jan';
         comp1.Month6__c='Jan';
         comp1.Month7__c='Jan';
         comp1.Month8__c='Jan';
        comp1.Month9__c='Jan';
        comp1.Month10__c='Jan';
        insert comp1;
        Vision_Order_Compliance_Report_Class.getOnlyComplianceDataHistoricalSales('allop', acc.Id,'1Month', false, 'LISA CARDETTI');
        Vision_Order_Compliance_Report_Class.getOnlyComplianceDataHistoricalSales('', acc.Id,'1Month', false, 'LISA CARDETTI');
        Vision_Order_Compliance_Report_Class.getOnlyComplianceDataHistoricalSales('', acc.Id,'1Month', true, 'LISA CARDETTI');
        Vision_Order_Compliance_Report_Class.getOnlyComplianceDataHistoricalSales('allop', acc.Id,'1Month', true, '');
        Vision_Order_Compliance_Report_Class.getOnlyComplianceDataHistoricalSales('', acc.Id,'1Month', true, '');
        Vision_Order_Compliance_Report_Class.getOnlyComplianceDataHistoricalSales('allop', acc.Id,'2Month', false, 'LISA CARDETTI');        
        Vision_Order_Compliance_Report_Class.getOnlyComplianceDataHistoricalSales('allop', acc.Id,'3Month', false, 'LISA CARDETTI');        
        Vision_Order_Compliance_Report_Class.getOnlyComplianceDataHistoricalSales('allop', acc.Id,'4Month', false, 'LISA CARDETTI');        
        Vision_Order_Compliance_Report_Class.getOnlyComplianceDataHistoricalSales('allop', acc.Id,'5Month', false, 'LISA CARDETTI');        
        Vision_Order_Compliance_Report_Class.getOnlyComplianceDataHistoricalSales('allop', acc.Id,'6Month', false, 'LISA CARDETTI');        
        Vision_Order_Compliance_Report_Class.getOnlyComplianceDataHistoricalSales('allop', acc.Id,'ShowAll', false, 'LISA CARDETTI');



    }
      static testmethod void testmethod3(){
       User systemUser = [SELECT Id, Name FROM USER WHERE NAME='LISA CARDETTI' LIMIT 1];
        Account acc = new Account();
        acc.AccountNumber = '115576';
        acc.Name = 'Amazon'; 
        insert acc;
        Product2 prod = new Product2();
        prod.Name = 'Alloprinol';
        prod.Family = 'Alloprinol';
        prod.Phoenix_Rx_SRx_OTC__c = 'Rx';
        prod.IsActive = true;
        prod.Phoenix_Product_Director__c= systemUser.Id;
        prod.Phoenix_Is_Exclude_Bid__c =false;
          prod.ProductCode= '30008932';
       
        insert prod;
       Product2 prod1 = new Product2();
        prod1.Name = 'Alloprinol';
        prod1.Family = 'Alloprinol';
        prod1.Phoenix_Rx_SRx_OTC__c = 'Rx';
        prod1.IsActive = true;
        prod1.Phoenix_Product_Director__c= systemUser.Id;
          prod1.ProductCode= '30008932';
        prod1.Phoenix_Is_Exclude_Bid__c =false;
       
        insert prod1;
        Order_Compliance_Data__c comp = new Order_Compliance_Data__c();
         comp.Vision_Product__c = prod1.Id;
        comp.Hierachy_Code__c = '115576';
        comp.General_Category__c = 'Primary';
        comp.M1_Quantity__c = 60;
        comp.M2_Quantity__c = 60;
        comp.M3_Quantity__c = 60;
        comp.M4_Quantity__c = 60;
        comp.M5_Quantity__c = 60;
        comp.M6_Quantity__c = 60;
        comp.M7_Quantity__c = 60;
        comp.M8_Quantity__c = 60;
        comp.M9_Quantity__c = 60;
        comp.M10_Quantity__c = 60;
        comp.M11_Quantity__c = 60;
        comp.M12_Quantity__c = 60;
        comp.M13_Quantity__c = 60;
        comp.M14_Quantity__c = 60;
        comp.M15_Quantity__c = 60;
        comp.Month1__c='Jan';
         comp.Month2__c='Jan';
         comp.Month3__c='Jan';
         comp.Month4__c='Jan';
         comp.Month5__c='Jan';
         comp.Month6__c='Jan';
         comp.Month7__c='Jan';
         comp.Month8__c='Jan';
        comp.Month9__c='Jan';
        comp.Month10__c='Jan';
           comp.Month11__c='Jan';
          comp.Month12__c='Jan';
        insert comp;
        
         Order_Compliance_Data__c comp1 = new Order_Compliance_Data__c();
         comp1.Vision_Product__c = prod1.Id;
        comp1.Hierachy_Code__c = '115576';
        comp1.General_Category__c = 'Primary';
        comp1.M1_Quantity__c = 800;
        comp1.M2_Quantity__c = 800;
        comp1.M3_Quantity__c = 800;
        comp1.M4_Quantity__c = 800;
        comp1.M5_Quantity__c = 800;
        comp1.M6_Quantity__c = 800;
        comp1.M7_Quantity__c = 800;
        comp1.M8_Quantity__c = 800;
        comp1.M9_Quantity__c = 800;
        comp1.M10_Quantity__c = 800;
        comp1.M11_Quantity__c = 800;
        comp1.M12_Quantity__c = 800;
        comp1.M13_Quantity__c = 800;
        comp1.M14_Quantity__c = 800;
        comp1.M15_Quantity__c = 800;
         comp1.Month1__c='Jan';
         comp1.Month2__c='Jan';
         comp1.Month3__c='Jan';
         comp1.Month4__c='Jan';
         comp1.Month5__c='Jan';
         comp1.Month6__c='Jan';
         comp1.Month7__c='Jan';
         comp1.Month8__c='Jan';
        comp1.Month9__c='Jan';
        comp1.Month10__c='Jan';
          comp1.Month11__c='Jan';
          comp1.Month12__c='Jan';
        insert comp1;
       //Vision_Order_Compliance_Report_Class.getGraphData(acc.Id,'30008932','115576','awarded');
 	   //Vision_Order_Compliance_Report_Class.getGraphData(acc.Id,'30008932','115576','historical');
    }
     static testmethod void test2(){
        Account acc = new Account();
        acc.Name = 'Test Account';
        insert acc;
        String uid = ('Phoenix' + System.now().getTime()).SubString(0, 8);
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User u1 = new User(Alias = uid, Email = uid + '@phoenix.com', EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', ProfileId = p.Id, TimeZoneSidKey = 'America/New_York', UserName = uid + '@phoenix.com', Division = 'SRx');
        insert u1;  
        
        
        
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
        
        
        
        Phoenix_GCP_OptyTracker_Controller.getProdBidLineItemComments(ndcItem,acc);
     
        Phoenix_GCP_OptyTracker_Controller.getProdBidLineItemComments(ndcItem,acc);
        
    }    
     static testmethod void test5(){
        Account acc = new Account();
        acc.Name = 'Test Account';
        insert acc;
        String uid = ('Phoenix' + System.now().getTime()).SubString(0, 8);
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User u1 = new User(Alias = uid, Email = uid + '@phoenix.com', EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', ProfileId = p.Id, TimeZoneSidKey = 'America/New_York', UserName = uid + '@phoenix.com', Division = 'SRx');
        insert u1;  
        
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
        
        list < Product2 > prodlist = new list < Product2 > ();
        Product2 prod1 = new Product2(Name = 'Test Product', Phoenix_Rx_SRx_OTC__c = 'Rx', Phoenix_Special_Product__c = true, Phoenix_GPI_Generic_Product_Identifier__c = '11111', 
                                      Phoenix_NDC__c = '5511112200', Family = 'Test Family', Phoenix_Is_Exclude_Bid__c = false, IsActive = TRUE, Phoenix_Pkg_Size__c = 50, Phoenix_Lowest_Price_SKU__c = 5);
        Product2 prod2 = new Product2(Name = 'Test Product1', Phoenix_Rx_SRx_OTC__c = 'Rx', Phoenix_Special_Product__c = true, Phoenix_GPI_Generic_Product_Identifier__c = '22222',
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
        ndcItem.Vision_Product__c = prod.Id;
        insert ndcItem;
        
        GCP_Comment__c cmt = new GCP_Comment__c();
        cmt.Comment__c='test';
        cmt.Comment_Type__c = 'Panorama';
        cmt.Comment_Date__c= system.today();
        cmt.GCP_Product_Family__c='Walgreens';
        cmt.Product_Family__c = 'Walgreens';
        cmt.GCP_SFDC_100pct_Analysis_SKU__c = ndcItem.Id;
        insert cmt;
        
       
        Phoenix_GCP_OptyTracker_Controller.getProdBidLineItemComments(ndcItem,acc);
    
        
    }
}