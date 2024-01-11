@isTest
public class VisionExtDRLSalesProductLevelBtchTestCls {
	
    static testmethod void testMe(){
       
        Account acc = new Account();
        acc.Name = 'Test Account';
        insert acc;
        Account acc1 = new Account();
        acc1.Name = 'Test Account';
        insert acc1;
         Product2 pro=new Product2(Name='Test',Family='Allopurinol');
        insert pro;
        Vision_DRL_Sales_External_Summary__c sales = new Vision_DRL_Sales_External_Summary__c();
        sales.Vision_Customer__c = acc1.Id;
       sales.Vision_Sales__c =123.45;
        sales.Vision_Units__c = 600;
        sales.Vision_Product__c=pro.id;
        //sales.Vision_TPT_Pct__c=1;
       sales.Vision_year__c='2021';
        sales.Vision_month__c='4';
       // sales.Vision_TPT_Dollar__c = 334;
       //sales.Vision_Month_dtls__c = system.today()-475;
        sales.Vision_Product_Family__c='Diclofenac Gel';
        sales.Vision_Segment__c = 'OTC';
        insert sales;
        Vision_DRL_Sales_External_Summary__c sales11 = new Vision_DRL_Sales_External_Summary__c();
        sales11.Vision_Customer__c = acc1.Id;
      // sales11.Vision_Sales_Dollar__c =123.45;
        sales11.Vision_Units__c = 600;
               // sales11.Vision_TPT_Pct__c=1;

        sales11.Vision_Product__c=pro.id;
        sales11.Vision_year__c='2021';
        sales11.Vision_month__c='1';
       // sales.Vision_TPT_Dollar__c = 334;
       // sales.Vision_Month_dtls__c = system.today()-475;
        sales11.Vision_Product_Family__c='Diclofenac Gel';
        sales11.Vision_Segment__c = 'Rx';
        insert sales11;
        
         Vision_DRL_Sales_External_Summary__c sales1 = new Vision_DRL_Sales_External_Summary__c();
        sales1.Vision_Customer__c = acc.Id;
        sales1.Vision_Product__c=pro.id;
              //  sales1.Vision_TPT_Pct__c=1;

       sales1.Vision_year__c='2021';
        sales1.Vision_month__c='1';
        //Vision_Sales_Dollar__c
       //sales1.Vision_Sales_Dollar__c =123.45;
        sales1.Vision_Units__c = 500;
        //sales1.Vision_TPT_Dollar__c = 234;
        //sales1.Vision_Month_dtls__c = system.today()-465;
        sales1.Vision_Product_Family__c='Diclofenac Gel';
        sales1.Vision_Segment__c = 'SRx';
        insert sales1;
        
        Vision_DRL_Sales_External_Summary__c sales2 = new Vision_DRL_Sales_External_Summary__c();
        sales2.Vision_Customer__c = acc.Id;
               // sales2.Vision_TPT_Pct__c=1;

        sales2.Vision_Product__c=pro.id;
        sales2.Vision_year__c='2021';
        sales2.Vision_month__c='1';
      // sales2.Vision_Sales_Dollar__c =123.45;
        sales2.Vision_Units__c = 500;
       // sales2.Vision_TPT_Dollar__c = 234;
      //  sales2.Vision_Month_dtls__c = system.today()-465;
        sales2.Vision_Product_Family__c='Diclofenac Gel';
        sales2.Vision_Segment__c = 'OTC';
        insert sales2;
        
         
        Vision_DRL_Sales_External_Summary__c sales3 = new Vision_DRL_Sales_External_Summary__c();
        sales3.Vision_Customer__c = acc.Id;
        sales3.Vision_Product__c=pro.id;
              //  sales3.Vision_TPT_Pct__c=1;

        sales3.Vision_year__c='2021';
        sales3.Vision_month__c='1';
       //sales3.Vision_Sales_Dollar__c =123.45;
        sales3.Vision_Units__c = 500;
       // sales3.Vision_TPT_Dollar__c = 234;
       // sales3.Vision_Month_dtls__c = system.today()-475;
        sales3.Vision_Product_Family__c='Diclofenac Gel';
        sales3.Vision_Segment__c = 'SRx';
        insert sales3;
        
     /*    Vision_DRL_Sales__c sales4 = new Vision_DRL_Sales__c();
        sales4.Vision_Customer__c = acc.Id;
        sales4.Vision_Product__c=pro.id;
        //sales4.Vision_year__c='2021';
        //sales4.Vision_month__c='1';
        sales4.Vision_Sales__c =1000;
        sales4.Vision_Units__c = 500;
        //sales4.Vision_TPT_Dollar__c = 234;
        //sales4.Vision_Month_dtls__c = system.today()-475;
        sales4.Vision_Product_Family__c='Diclofenac Gel';
        sales4.Vision_Segment__c = 'OTC';
        insert sales4;*/
       
        
        /*Vision_InternalDRLSales_ProductSummary__c intsales1= new Vision_InternalDRLSales_ProductSummary__c();
        intsales1.Vision_Customer__c = acc.Id;
        intsales1.Vision_Sales__c =173.45;
        intsales1.Vision_Units__c = 500;
        intsales1.Vision_Is_Rx__c  = true;
                intsales1.Vision_TPT_Percent__c=1;

        intsales1.Vision_TPT_Dollar__c = 234;
        intsales1.Vision_Processed_Date__c = system.today()-475;
        intsales1.Vision_Product_Family__c='Diclofenac Gel';
        intsales1.Vision_Unique_Identifier__c = 'Test Account-Diclofenac Gel-Rx_2021_2';
        insert intsales1;
              Vision_InternalDRLSales_ProductSummary__c intsales2= new Vision_InternalDRLSales_ProductSummary__c();
        intsales2.Vision_Customer__c = acc1.Id;
        intsales2.Vision_Sales__c =165.45;
        intsales2.Vision_Units__c = 500;
        intsales2.Vision_Is_OTC__c  = true;
               intsales2.Vision_TPT_Percent__c=1;

        intsales2.Vision_TPT_Dollar__c = 234;
        intsales2.Vision_Processed_Date__c = system.today()-200;
        intsales2.Vision_Product_Family__c='Diclofenac Gel';
        intsales2.Vision_Unique_Identifier__c = 'Test Account-Diclofenac Gel-OTC_2021_2';

        insert intsales2;
		
        Vision_InternalDRLSales_ProductSummary__c intsales3= new Vision_InternalDRLSales_ProductSummary__c();
        intsales3.Vision_Customer__c = acc1.Id;
        intsales3.Vision_Sales__c =500.45;
        intsales3.Vision_Units__c = 500;
        intsales3.Vision_Is_SRx__c  = true;
        intsales3.Vision_TPT_Percent__c=1;
        intsales3.Vision_TPT_Dollar__c = 234;
        intsales3.Vision_Processed_Date__c = system.today()-365;
        intsales3.Vision_Product_Family__c='Diclofenac Gel';
        intsales3.Vision_Unique_Identifier__c = 'Test Account-Diclofenac Gel-SRx_2021_2';

        insert intsales3;*/
        Vision_InternalDRLSales_ProductSummary__c intsales1= new Vision_InternalDRLSales_ProductSummary__c();
        intsales1.Vision_Customer__c = acc.Id;
        intsales1.Vision_Sales__c =123.45;
        intsales1.Vision_Units__c = 500;
        intsales1.Vision_Is_Rx__c  = true;
        intsales1.Vision_TPT_Dollar__c = 234;
        intsales1.Vision_Processed_Date__c = system.today()-200;
        intsales1.Vision_Product_Family__c='Diclofenac Gel';
        intsales1.Vision_Unique_Identifier__c = 'Test Account-Diclofenac Gel-Rx_2021_2';
        
           Vision_InternalDRLSales_ProductSummary__c intsales2= new Vision_InternalDRLSales_ProductSummary__c();
        intsales2.Vision_Customer__c = acc1.Id;
        intsales2.Vision_Sales__c =123.45;
        intsales2.Vision_Units__c = 500;
        intsales2.Vision_Is_SRx__c  = true;
        intsales2.Vision_TPT_Dollar__c = 234;
        intsales2.Vision_Processed_Date__c = system.today()-200;
        intsales2.Vision_Product_Family__c='Diclofenac Gel';
        intsales2.Vision_Unique_Identifier__c = 'Test Account-Diclofenac Gel-SRx_2021_2';

        insert intsales2;
        Vision_InternalDRLSales_ProductSummary__c intsales3= new Vision_InternalDRLSales_ProductSummary__c();
        intsales3.Vision_Customer__c = acc1.Id;
        intsales3.Vision_Sales__c =123.45;
        intsales3.Vision_Units__c = 500;
        intsales3.Vision_Is_SRx__c  = true;
        intsales3.Vision_TPT_Dollar__c = 234;
        intsales3.Vision_Processed_Date__c = system.today()-200;
        intsales3.Vision_Product_Family__c='Diclofenac Gel';
        intsales3.Vision_Unique_Identifier__c = 'Test Account-Diclofenac Gel-OTC_2021_2';

        insert intsales3;
        
     /*   Vision_DRL_Sales_External__c externalSales1 = new Vision_DRL_Sales_External__c();
        externalSales1.Vision_Customer_Name__c =  acc.Id;
        externalSales1.Vision_Segment__c = 'Rx';
        externalSales1.Vision_Month_dtls__c = system.today()-475;
        externalSales1.Vision_Sales_Dollar__c = 173.45;
        externalSales1.Quantity_in_Units__c = 500;
        externalSales1.Vision_Product_Family__c = 'Diclofenac Gel';
        insert externalSales1;
        
        Vision_DRL_Sales_External__c externalSales2 = new Vision_DRL_Sales_External__c();
        externalSales2.Vision_Customer_Name__c =  acc1.Id;
        externalSales2.Vision_Segment__c = 'SRx';
        externalSales2.Vision_Month_dtls__c = system.today()-365;
        externalSales2.Vision_Sales_Dollar__c =500.45;
        externalSales2.Quantity_in_Units__c = 500;
        externalSales2.Vision_Product_Family__c = 'Diclofenac Gel';
        insert externalSales2;
        
        Vision_DRL_Sales_External__c externalSales3 = new Vision_DRL_Sales_External__c();
        externalSales3.Vision_Customer_Name__c =  acc1.Id;
        externalSales3.Vision_Segment__c = 'OTC';
        externalSales3.Vision_Month_dtls__c = system.today()-200;
        externalSales3.Vision_Sales_Dollar__c =165.45;
        externalSales3.Quantity_in_Units__c = 500;
        externalSales3.Vision_Product_Family__c = 'Diclofenac Gel';
        insert externalSales3;
        
        List < Vision_DRL_Sales_External__c > externalSalesList = new List < Vision_DRL_Sales_External__c >();
        externalSalesList.add(externalSales1);
        externalSalesList.add(externalSales2);
        externalSalesList.add(externalSales3);*/
        
        
        
       
        
        Test.startTest();
        VisionExtDRLSalesProductLevelBatchCls batch = new VisionExtDRLSalesProductLevelBatchCls();
       	Id jobid= Database.executeBatch(batch,5);
        //batch.execute(null);
        Test.stopTest();     
    }
    
   /* static testmethod void testMethod1(){
        Test.startTest();
        //Database.executeBatch(new VisionDRLSalesSummaryBatchCls()); 
        Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'VisionDRLSalesSummaryBatchCls', Phoenix_Issue_Status__c = 'Pending', Phoenix_Method_Name__c = 'execute', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
        insert exp;
        Test.stopTest(); 
       
        
    }*/
    
    
}