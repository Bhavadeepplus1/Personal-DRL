@isTest
public class Phoenix_PHSRejectedLineItemsClsTest {
    static testmethod void PHSRejectedMethod() {
        
        
        list < Product2 > prodList = new list < Product2 > ();
        Product2 prod1 = new Product2(Name = 'Test Product', Phoenix_Rx_SRx_OTC__c = 'Rx', Phoenix_Special_Product__c = true, Phoenix_GPI_Generic_Product_Identifier__c = '11111', Phoenix_NDC_11__c = '12345678902', Family = 'Test Family', IsActive = TRUE);
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
        
        
        Phoenix_PHS_Price_Change__c testNDC=new Phoenix_PHS_Price_Change__c();
        testNDC.Phoenix_Approval_Status__c='Draft';   
        testNDC.Phoenix_Contract__c=Cntrct.iD;
        
        insert testNDC;
        
         list < Phoenix_PHS_Price_Change_Line__c > lineItemsList = new list < Phoenix_PHS_Price_Change_Line__c > ();
        Phoenix_PHS_Price_Change_Line__c pbl1=new Phoenix_PHS_Price_Change_Line__c();
        pbl1.Phoenix_PHS_Price_Change__c=testNDC.Id;
      
        pbl1.Phoenix_Product_Name__c = prod1.id;
        
        
        lineItemsList.add(pbl1);
        Phoenix_PHS_Price_Change_Line__c pbl2=new Phoenix_PHS_Price_Change_Line__c();
        pbl2.Phoenix_PHS_Price_Change__c	=testNDC.Id;
     
        pbl2.Phoenix_Product_Name__c = prod2.id;
      
        lineItemsList.add(pbl2);
        insert lineItemsList;
         
         
         Phoenix_PHSRejectedLineItemsCls.getRelatedList(testNDC.Id);
          Phoenix_PHSRejectedLineItemsCls.getupdatedforExport(testNDC.Id);
            Phoenix_PHSRejectedLineItemsCls.saveLineItems(lineItemsList);
         Phoenix_PHSRejectedLineItemsCls.deleteLineItems(lineItemsList[0].Id);
         testNDC.Phoenix_PHS_Price_Change_Name__c='test';
         update testNDC;
         //delete testNDC;
     }


}