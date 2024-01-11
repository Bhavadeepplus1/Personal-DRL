@isTest
public class VisionDRLSalesProductMyDivisionTestCtrl {
    static testmethod void AddVisionDRLSalesMethod(){
        
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.OwnerId = userInfo.getUserId();
        insert acc;
        
        String uid = ('Phoenix' + System.now().getTime()).SubString(0, 8);
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User u1 = new User(Alias = uid, Email = uid + '@phoenix.com', EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', ProfileId = p.Id, TimeZoneSidKey = 'America/New_York', UserName = uid + '@phoenix.com', Division = 'SRx');
        insert u1;
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
        List<String> productFamilies = new List<String>{'OTC Fexo','Diclofenac Gel'};
            
            
            
            List<String> customerIds = new List<String> {'0050m000003VwVTAA0','0010100000NbnNsAAJ','0010100000NbnLUAAZ',acc.Id};
                List<String> custId = new List<String>();
		
        /*---*/
        /*Vision_DRLSales_Product_MyDivisionCtrl.getDRLSalesRelatedList(selections, selectedComparison1, customerId);
        Vision_DRLSales_Product_MyDivisionCtrl.getDRLSalesRelatedList(selections, selectedcomparison2, customerId);
        Vision_DRLSales_Product_MyDivisionCtrl.getDRLSalesRelatedList(selections, selectedcomparison3, customerId);
        Vision_DRLSales_Product_MyDivisionCtrl.getDRLSalesRelatedList(selections, selectedcomparison3, '0050m000003VwVTAA0');
        Vision_DRLSales_Product_MyDivisionCtrl.getDRLSalesRelatedList(selections, selectedcomparison3,acc.Id);
        
        Vision_DRLSales_Product_MyDivisionCtrl.getLasttwmonthsVsPrevtwmonthsData(selections, selectedcomparison4, customerId, productFamilies);
        Vision_DRLSales_Product_MyDivisionCtrl.getLasttwmonthsVsPrevtwmonthsData(selections, selectedcomparison4, '0050m000003VwVTAA0', productFamilies);
        Vision_DRLSales_Product_MyDivisionCtrl.getLasttwmonthsVsPrevtwmonthsData(selections, selectedcomparison4, acc.Id, productFamilies);
        
        Vision_DRLSales_Product_MyDivisionCtrl.getLastQuarterVsPrevQuarterData(selections, selectedcomparison1, customerId, productFamilies);
        Vision_DRLSales_Product_MyDivisionCtrl.getLastQuarterVsPrevQuarterData(selections, selectedcomparison1, '0050m000003VwVTAA0', productFamilies);
        Vision_DRLSales_Product_MyDivisionCtrl.getLastQuarterVsPrevQuarterData(selections, selectedcomparison1, acc.Id, productFamilies);
        
        Vision_DRLSales_Product_MyDivisionCtrl.getfytdData(selections, selectedcomparison1, customerId, productFamilies);
        Vision_DRLSales_Product_MyDivisionCtrl.getfytdData(selections, selectedcomparison1, '0050m000003VwVTAA0', productFamilies);
        
        Vision_DRLSales_Product_MyDivisionCtrl.getfytdData(selections, selectedcomparison1, acc.Id, productFamilies);
        
        Vision_DRLSales_Product_MyDivisionCtrl.getLasttwmonthsVsPrevtwmonthsDataSingleId(selections, selectedcomparison1, customerId);
        Vision_DRLSales_Product_MyDivisionCtrl.getLasttwmonthsVsPrevtwmonthsDataSingleId(selections, selectedcomparison1,'0050m000003VwVTAA0');
        Vision_DRLSales_Product_MyDivisionCtrl.getLasttwmonthsVsPrevtwmonthsDataSingleId(selections,selectedcomparison1,acc.Id);*/
        Vision_DRLSales_Product_MyDivisionCtrl.coverageBlock();
    }
    
}