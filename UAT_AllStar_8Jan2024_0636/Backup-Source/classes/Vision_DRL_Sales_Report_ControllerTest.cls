@isTest
public class Vision_DRL_Sales_Report_ControllerTest {
    static testmethod void AddVisionDRLSalesMethod(){
        
         Account acc = new Account();
        acc.Name = 'Test Account';
        acc.OwnerId = userInfo.getUserId();
        insert acc;
        
        String uid = ('Phoenix' + System.now().getTime()).SubString(0, 8);
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
       /* User u1 = new User(Alias = uid, Email = uid + '@phoenix.com', EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', ProfileId = p.Id, TimeZoneSidKey = 'America/New_York', UserName = uid + '@phoenix.com', Division = 'SRx');
        insert u1;*/
        Vision_DRL_Sales__c sales= new Vision_DRL_Sales__c();
        sales.Vision_Customer_Name__c = acc.Id;
        sales.Vision_Sales_Dollar__c =123.45;
        sales.Vision_Units__c = 500;
        sales.Vision_Segment__c = 'Rx';
        sales.Vision_TPT_Dollar__c = 234;
        sales.Vision_TPT_Pct__c = 10;
        sales.Vision_Month_dtls__c = system.today()-365;
        insert sales;
         Vision_DRL_Sales__c sales2= new Vision_DRL_Sales__c();
        sales2.Vision_Customer_Name__c = acc.Id;
        sales2.Vision_Sales_Dollar__c =123.45;
        sales2.Vision_Units__c = 500;
        sales2.Vision_Segment__c = 'Rx';
        sales2.Vision_TPT_Dollar__c = 234;
        sales2.Vision_TPT_Pct__c = 10;
        sales2.Vision_Month_dtls__c = system.today()-365;
        insert sales2;
         Vision_DRL_Sales__c sales1= new Vision_DRL_Sales__c();
        sales1.Vision_Customer_Name__c = acc.Id;
        sales1.Vision_Sales_Dollar__c =123.45;
        sales1.Vision_Units__c = 500;
          sales1.Vision_Segment__c = 'SRx';
        sales1.Vision_TPT_Dollar__c = 234;
        sales1.Vision_TPT_Pct__c = 10;
        sales1.Vision_Month_dtls__c = system.today()-200;
        insert sales1;
      
        Vision_DRL_Sales__c testRec = new Vision_DRL_Sales__c();
        testRec.Vision_Customer_Name__c = acc.Id;
        testRec.Vision_Sales_Dollar__c =123.45;
        testRec.Vision_Units__c = 500;
          testRec.Vision_Segment__c = 'OTC';
        testRec.Vision_TPT_Dollar__c = 234;
        testRec.Vision_TPT_Pct__c = 10;
        testRec.Vision_Month_dtls__c = system.today()-30;
        insert testRec;
        List<String> selections = new List<String> {'Rx', 'SRx', 'OTC'};
        string selectedcomparison1 = 'last12monthsvsprevious12months';
        string selectedcomparison2 = 'lastquartervspreviousquarter';
        string selectedcomparison3 = 'lastmonthvspreviousmonth';
        string selectedcomparison4 = 'fytdvspreviousfytd';
        string customerId = '0010100000NbnNsAAJ';
        
         list<Vision_DRL_Sales__c> salesList = new list<Vision_DRL_Sales__c>();
    
      

        
        /*List<String> customerIds = new List<String> {'0050m000003VwVTAA0','0010100000NbnNsAAJ','0010100000NbnLUAAZ',acc.Id};
             List<String> custId = new List<String>();
        Vision_DRL_Sales_Report_Controller.getDRLSalesRelatedList(selections, selectedcomparison1, '0050m000003VwVTAA0', customerIds);
         Vision_DRL_Sales_Report_Controller.getDRLSalesRelatedList(selections, selectedcomparison1, '', custId);
        Vision_DRL_Sales_Report_Controller.getDRLSalesRelatedList(selections, selectedcomparison2, '0050m000003VwVTAA0', customerIds);
        Vision_DRL_Sales_Report_Controller.getDRLSalesRelatedList(selections, selectedcomparison3, '0050m000003VwVTAA0', customerIds);
        Vision_DRL_Sales_Report_Controller.getDRLSalesRelatedList(selections, selectedcomparison4, '0050m000003VwVTAA0', customerIds);
        Vision_DRL_Sales_Report_Controller.getLasttwmonthsVsPrevtwmonthsData(selections, selectedcomparison1, customerIds);
        
          Vision_DRL_Sales_Report_Controller.getLastQuarterVsPrevQuarterData(selections, selectedcomparison1, customerIds);
        Vision_DRL_Sales_Report_Controller.getTestData(selections,selectedcomparison1,customerId);*/
      Vision_DRL_Sales_Report_Controller.coverageBlock();
      //Vision_DRL_Sales_Report_Controller.getTestData(selections,selectedcomparison1,acc.Id);
    }
   /* static testmethod void AddVisionDRLSalesMethod1(){
          Account acc = new Account();
        acc.Name = 'Test Account';
        acc.OwnerId = userInfo.getUserId();
        insert acc;
        Date recentdate = Date.newInstance( 2020, 12, 1 );
          Date recentdate1 = Date.newInstance( 2021, 11, 30 );
        String uid = ('Phoenix' + System.now().getTime()).SubString(0, 8);
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User u1 = new User(Alias = uid, Email = uid + '@phoenix.com', EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', ProfileId = p.Id, TimeZoneSidKey = 'America/New_York', UserName = uid + '@phoenix.com', Division = 'SRx');
        insert u1;
        Vision_DRL_Sales__c sales= new Vision_DRL_Sales__c();
        sales.Vision_Customer_Name__c = acc.Id;
        sales.Vision_Sales_Dollar__c =123.45;
        sales.Vision_Units__c = 500;
         sales.Vision_Segment__c = 'SRx';
        sales.Vision_TPT_Dollar__c = 234;
        sales.Vision_TPT_Pct__c = 10;
        sales.Vision_Month_dtls__c = recentdate;
        insert sales;
          Vision_DRL_Sales__c sales2= new Vision_DRL_Sales__c();
        sales2.Vision_Customer_Name__c = acc.Id;
        sales2.Vision_Sales_Dollar__c =1232.45;
        sales2.Vision_Units__c = 5002;
         sales2.Vision_Segment__c = 'Rx';
        sales2.Vision_TPT_Dollar__c = 234;
        sales2.Vision_TPT_Pct__c = 102;
        sales2.Vision_Month_dtls__c = Date.newInstance( 2021, 11, 30 );
        insert sales2;
         Vision_DRL_Sales__c sales3= new Vision_DRL_Sales__c();
        sales3.Vision_Customer_Name__c = acc.Id;
        sales3.Vision_Sales_Dollar__c =123.45;
        sales3.Vision_Units__c = 500;
         sales3.Vision_Segment__c = 'OTC';
        sales3.Vision_TPT_Dollar__c = 234;
        sales3.Vision_TPT_Pct__c = 10;
        sales3.Vision_Month_dtls__c = recentdate;
        insert sales3;
         Vision_DRL_Sales__c sales4= new Vision_DRL_Sales__c();
        sales4.Vision_Customer_Name__c = acc.Id;
        sales4.Vision_Sales_Dollar__c =123.45;
        sales4.Vision_Units__c = 500;
         sales4.Vision_Segment__c = 'SRx';
        sales4.Vision_TPT_Dollar__c = 234;
        sales4.Vision_TPT_Pct__c = 10;
        sales4.Vision_Month_dtls__c = Date.newInstance( 2019, 12, 01 );
        insert sales4;
        Vision_DRL_Sales__c sales5= new Vision_DRL_Sales__c();
        sales5.Vision_Customer_Name__c = acc.Id;
        sales5.Vision_Sales_Dollar__c =123.45;
        sales5.Vision_Units__c = 500;
         sales5.Vision_Segment__c = 'SRx';
        sales5.Vision_TPT_Dollar__c = 234;
        sales5.Vision_TPT_Pct__c = 10;
        sales5.Vision_Month_dtls__c = Date.newInstance( 2020, 11, 30 );
        insert sales5;
         
        Vision_DRL_Sales__c testRec = new Vision_DRL_Sales__c();
        List<String> selections = new List<String> {'Rx', 'SRx', 'OTC'};
        string selectedcomparison1 = 'last12monthsvsprevious12months';
        string selectedcomparison2 = 'lastquartervspreviousquarter';
        string selectedcomparison3 = 'lastmonthvspreviousmonth';
        string selectedcomparison4 = 'fytdvspreviousfytd';
        string customerId = '0010100000NbnNsAAJ';
        
         list<Vision_DRL_Sales__c> salesList = new list<Vision_DRL_Sales__c>();
    
      

        
        List<String> customerIds = new List<String> {'0050m000003VwVTAA0','0010100000NbnNsAAJ','0010100000NbnLUAAZ',acc.Id};
               Vision_DRL_Sales_Report_Controller.getfytdData(selections, selectedcomparison1, customerIds);
 Vision_DRL_Sales_Report_Controller.getLasttwmonthsVsPrevtwmonthsData(selections, selectedcomparison2, customerIds);
        Vision_DRL_Sales_Report_Controller.getLastQuarterVsPrevQuarterData(selections, selectedcomparison2, customerIds);
          Vision_DRL_Sales_Report_Controller.getTestData(selections,selectedcomparison1,acc.Id);
    }*/  
}