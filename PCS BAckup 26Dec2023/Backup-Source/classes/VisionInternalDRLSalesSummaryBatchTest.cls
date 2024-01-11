@isTest
public class VisionInternalDRLSalesSummaryBatchTest {	
    
    /*static testmethod void testMe(){
        Account acc = new Account();
        acc.Name = 'Test Account';
        insert acc;
        Account acc1 = new Account();
        acc1.Name = 'Test Account';
        insert acc1;
        Product2 pro=new Product2(Name='Test',Family='Allopurinol');
        insert pro;
        Product2 pro1=new Product2(Name='Test1',Family='Allopurinol');
        insert pro1;
        
        Vision_Intrenal_DRL_Sales_Summary__c sales = new Vision_Intrenal_DRL_Sales_Summary__c();
        sales.Vision_Customer__c = acc1.Id;
        sales.Vision_Sales__c =223.45;
        sales.Vision_Units__c = 600;
        sales.Vision_Product_Family__c='Diclofenac Gel';
        sales.Vision_Unique_Identifier__c = 'ab';
        sales.Vision_Processed_Date__c = system.today()-475;
        insert sales;
        Vision_Intrenal_DRL_Sales_Summary__c sales11 = new Vision_Intrenal_DRL_Sales_Summary__c();
        sales11.Vision_Customer__c = acc1.Id;
        sales11.Vision_Sales__c =223.45;
        sales11.Vision_Units__c = 600;
        sales11.Vision_Product_Family__c='Diclofenac Gel';
        sales11.Vision_Unique_Identifier__c = 'ab';
        sales11.Vision_Processed_Date__c = system.today()-470;
        insert sales11;
        
        Vision_Intrenal_DRL_Sales_Summary__c sales1 = new Vision_Intrenal_DRL_Sales_Summary__c();
        sales1.Vision_Customer__c = acc.Id;
        sales1.Vision_Sales__c =123.45;
        sales1.Vision_Units__c = 500;
        sales1.Vision_Product_Family__c='Diclofenac Gel';
        sales1.Vision_Unique_Identifier__c = 'ab';
        sales1.Vision_Processed_Date__c = system.today()-470;
        insert sales1;
        
        Vision_Intrenal_DRL_Sales_Summary__c sales2 = new Vision_Intrenal_DRL_Sales_Summary__c();
        sales2.Vision_Customer__c = acc.Id;
        sales2.Vision_Sales__c =123.45;
        sales2.Vision_Units__c = 500;
        sales2.Vision_Product_Family__c='Diclofenac Gel';
        sales2.Vision_Unique_Identifier__c = 'ab';
        sales2.Vision_Processed_Date__c = system.today()-470;
        insert sales2;
        
         
        Vision_Intrenal_DRL_Sales_Summary__c sales3 = new Vision_Intrenal_DRL_Sales_Summary__c();
        sales3.Vision_Customer__c = acc.Id;
        sales3.Vision_Sales__c =123.45;
        sales3.Vision_Units__c = 500;
        sales3.Vision_Product_Family__c='Diclofenac Gel';
        sales3.Vision_Unique_Identifier__c = 'ab';
        sales3.Vision_Processed_Date__c = system.today()-475;
        insert sales3;
        
        Vision_DRL_Sales__c intsales1= new Vision_DRL_Sales__c();
        intsales1.Vision_Customer_Name__c = acc.Id;
        intsales1.Vision_Sales_Dollar__c =173.45;
        intsales1.Vision_Units__c = 500;
        intsales1.Vision_Segment__c  = 'Rx';
        intsales1.Vision_Month_dtls__c = system.today()-475;
        intsales1.Vision_Product_Family__c='Diclofenac Gel';
        intsales1.GCP_Unique_Identifier__c = 'ab';
        insert intsales1;
        
        Vision_DRL_Sales__c intsales2= new Vision_DRL_Sales__c();
        intsales2.Vision_Customer_Name__c = acc.Id;
        intsales2.Vision_Sales_Dollar__c =173.45;
        intsales2.Vision_Units__c = 500;
        intsales2.Vision_Segment__c  = 'Rx';
        intsales2.Vision_Month_dtls__c = system.today()-475;
        intsales2.Vision_Product_Family__c='Diclofenac Gel';
        intsales2.GCP_Unique_Identifier__c = 'ab';
        insert intsales2;
        
        Vision_DRL_Sales__c intsales3= new Vision_DRL_Sales__c();
        intsales3.Vision_Customer_Name__c = acc1.Id;
        intsales3.Vision_Sales_Dollar__c =173.45;
        intsales3.Vision_Units__c = 500;
        intsales3.Vision_Segment__c  = 'Rx';
        intsales3.Vision_Month_dtls__c = system.today()-400;
        intsales3.Vision_Product_Family__c='Diclofenac Gel';
        intsales3.GCP_Unique_Identifier__c = 'ab';
        insert intsales3;
        
        Test.startTest();
        //Database.executeBatch(new VisionInternalDRLSalesSummaryBatchCls(), 5); //uncomment this before running/deploying
        Test.stopTest();   
    }
    
    static testmethod void test2(){
        Account acc = new Account();
        acc.Name = 'Test Account';
        insert acc;
        Account acc1 = new Account();
        acc1.Name = 'Test Account';
        insert acc1;
        Product2 pro=new Product2(Name='Test',Family='Allopurinol');
        insert pro;
        Product2 pro1=new Product2(Name='Test1',Family='Allopurinol');
        insert pro1;
        
        Vision_DRL_Sales__c intsales2= new Vision_DRL_Sales__c();
        intsales2.Vision_Customer_Name__c = acc1.Id;
        intsales2.Vision_Sales_Dollar__c =165.45;
        intsales2.Vision_Units__c = 500;
        intsales2.Vision_Segment__c  = 'SRx';
        intsales2.Vision_Month_dtls__c = system.today()-475;
        intsales2.Vision_Product_Family__c='Diclofenac Gel';
        intsales2.GCP_Unique_Identifier__c = 'Test Account-OTC_2021_1';
        
        insert intsales2;
        
        Vision_DRL_Sales__c intsales3= new Vision_DRL_Sales__c();
        intsales3.Vision_Customer_Name__c = acc1.Id;
        intsales3.Vision_Sales_Dollar__c =165.45;
        intsales3.Vision_Units__c = 500;
        intsales3.Vision_Segment__c  = 'SRx';
        intsales3.Vision_Month_dtls__c = system.today()-400;
        intsales3.Vision_Product_Family__c='Diclofenac Gel';
        intsales3.GCP_Unique_Identifier__c = 'Test Account-OTC_2021_1';
        
        insert intsales3;
        
        Test.startTest();
        //Database.executeBatch(new VisionInternalDRLSalesSummaryBatchCls(), 5); //uncomment this before running/deploying
        Test.stopTest();   
    }
    
    static testmethod void test3(){
        Account acc = new Account();
        acc.Name = 'Test Account';
        insert acc;
        Account acc1 = new Account();
        acc1.Name = 'Test Account';
        insert acc1;
        Product2 pro=new Product2(Name='Test',Family='Allopurinol');
        insert pro;
        Product2 pro1=new Product2(Name='Test1',Family='Allopurinol');
        insert pro1;
        
        Vision_DRL_Sales__c intsales3= new Vision_DRL_Sales__c();
        intsales3.Vision_Customer_Name__c = acc1.Id;
        intsales3.Vision_Sales_Dollar__c =500.45;
        intsales3.Vision_Units__c = 500;
        intsales3.Vision_Segment__c  = 'OTC';
        intsales3.Vision_Month_dtls__c = system.today()-365;
        intsales3.Vision_Product_Family__c='Diclofenac Gel';
        intsales3.GCP_Unique_Identifier__c = 'Test Account-SRx_2021_1';
        
        insert intsales3;
        Vision_DRL_Sales__c intsales4= new Vision_DRL_Sales__c();
        intsales4.Vision_Customer_Name__c = acc1.Id;
        intsales4.Vision_Sales_Dollar__c =500.45;
        intsales4.Vision_Units__c = 500;
        intsales4.Vision_Segment__c  = 'OTC';
        intsales4.Vision_Month_dtls__c = system.today()-300;
        intsales4.Vision_Product_Family__c='Diclofenac Gel';
        intsales4.GCP_Unique_Identifier__c = 'Test Account-SRx_2021_1';
        
        insert intsales4;
        
        Test.startTest();
        //Database.executeBatch(new VisionInternalDRLSalesSummaryBatchCls(), 5); //uncomment this before running/deploying
        Test.stopTest();   
    }
    
    /*static testmethod void test4(){
        Account acc = new Account();
        acc.Name = 'Test Account';
        insert acc;
        Account acc1 = new Account();
        acc1.Name = 'Test Account';
        insert acc1;
        Product2 pro=new Product2(Name='Test',Family='Allopurinol');
        insert pro;
        Product2 pro1=new Product2(Name='Test1',Family='Allopurinol');
        insert pro1;
        
        Vision_DRL_Sales__c intsales4= new Vision_DRL_Sales__c();
        intsales4.Vision_Customer_Name__c = acc.Id;
        intsales4.Vision_Sales_Dollar__c =500.45;
        intsales4.Vision_Units__c = 500;
        intsales4.Vision_Segment__c  = 'Rx';
        intsales4.Vision_Month_dtls__c = system.today()-365;
        intsales4.Vision_Product_Family__c='Diclofenac Gel';
        intsales4.GCP_Unique_Identifier__c = 'Test Account-SRx_2021_1';
        
        insert intsales4;
        
        Test.startTest();
        Database.executeBatch(new VisionInternalDRLSalesSummaryBatchCls(), 5);
        Test.stopTest();   
    }*/
}