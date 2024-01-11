@isTest 
public class Phoenix_NewWacPricingTriggerHandlerTest {
 @testSetup static void setupTestData() {
        Account testAccount = new Account(Name = 'Test Account', Phoenix_Customer_Class_Bid_Template__c = 'Sams Club');
        insert testAccount;
        Phoenix_Contract__c c=new Phoenix_Contract__c();
        c.Name='New Contract';
        insert c;
     Product2 prod = new Product2();
     prod.Family = 'cetirizine';
     prod.Name = 'Test';
     insert prod;
        New_Product_WAC_Pricing__c pb = new New_Product_WAC_Pricing__c();
        pb.Phoenix_WAC_Price_for_New_Launch_Name__c='test';
     	pb.Phoenix_Product_Family__c=prod.Id;
        insert pb;
        
        
    }
    static testmethod void getBid1() {
        
        New_Product_WAC_Pricing__c bl = [SELECT Id from New_Product_WAC_Pricing__c LIMIT 1];
        bl.Phoenix_Approval_Status__c = 'Closed';
        
        update bl;
        
    }
    static testmethod void getBid2() {
        
        New_Product_WAC_Pricing__c bl = [SELECT Id from New_Product_WAC_Pricing__c LIMIT 1];
        bl.Phoenix_Approval_Status__c = 'Closed';
        
       // delete bl;
        
    }
     static testmethod void WACRejectedMethod() {
        
        
        list < Product2 > prodList = new list < Product2 > ();
        Product2 prod1 = new Product2(Name = 'Test Product', Family = 'Test Family', IsActive = TRUE);
        Product2 prod2 = new Product2(Name = 'Test Product1', Phoenix_Rx_SRx_OTC__c = 'Rx', Phoenix_Special_Product__c = true, Phoenix_GPI_Generic_Product_Identifier__c = '22222', Phoenix_NDC_11__c = '21345678902', Family = 'Sample Family', IsActive = TRUE);
        Product2 prod3 = new Product2(Name = 'Test Product2', Phoenix_Rx_SRx_OTC__c = 'SRx', Phoenix_Special_Product__c = true, Phoenix_NDC_11__c = '32145678902', Family = ' cetirizine', IsActive = TRUE);
        Product2 prod4 = new Product2(Name = 'Test Product3', Phoenix_Rx_SRx_OTC__c = 'OTC', Phoenix_Special_Product__c = true, Phoenix_GPI_Generic_Product_Identifier__c = '333333', Family = ' cetirizine', IsActive = TRUE);
        
        prodList.add(prod1);
        prodList.add(prod2);
        prodList.add(prod3);
        prodList.add(prod4);
        insert prodList;  
        
        Phoenix_Contract__c Cntrct = new Phoenix_Contract__c();
        Cntrct.name = 'taest cntrct';
        Cntrct.Phoenix_Contract_Number__c = '223';
        insert Cntrct;
        
         Phoenix_NPR_Data__c nprdat = new Phoenix_NPR_Data__c();
        nprdat.Phoenix_Contract__c = Cntrct.id;
        nprdat.Phoenix_NPR_Status__c = 'Active';
        nprdat.Phoenix_Contract_Number__c = '223';
        nprdat.Phoenix_Product__c = prod1.id;
        nprdat.Phoenix_12Months_Sales_Unit__c = 200;
        nprdat.Phoenix_Contract_Type__c = 'Direct';
        nprdat.Phoenix_Rebate_G_N_Indicator__c = '10N+ 0G';
        nprdat.Phoenix_Bonafied_G_N_Indicator__c = '5N+0G';
        insert nprdat;
        
        
        New_Product_WAC_Pricing__c testNDC=new New_Product_WAC_Pricing__c();
        testNDC.Phoenix_Approval_Status__c='Draft';   
       testNDC.Phoenix_WAC_Price_for_New_Launch_Name__c    ='testRecord';
       // testNDC.Phoenix_Contract__c=Cntrct.iD;
        
        insert testNDC;
        
  /*       list < Phoenix_NewProduct_WAC_Pricing_LineItems__c > lineItemsList = new list < Phoenix_NewProduct_WAC_Pricing_LineItems__c > ();
        Phoenix_NewProduct_WAC_Pricing_LineItems__c pbl1=new Phoenix_NewProduct_WAC_Pricing_LineItems__c();
        pbl1.Name='Test Test';
      
        pbl1.Phoenix_Product_Name__c = prod1.id;
        
        
        lineItemsList.add(pbl1);
        Phoenix_NewProduct_WAC_Pricing_LineItems__c pbl2=new Phoenix_NewProduct_WAC_Pricing_LineItems__c();
        pbl2.Name =testNDC.Id;
     
        pbl2.Phoenix_Product_Name__c = prod2.id;
      
        lineItemsList.add(pbl2);
        insert lineItemsList;*/
         
         
       
     //    testNDC.Name='test';
         update testNDC;
         //delete testNDC;
     }
   
    
}