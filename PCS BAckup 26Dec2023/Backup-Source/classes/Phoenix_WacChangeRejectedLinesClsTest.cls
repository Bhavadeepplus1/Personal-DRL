@isTest
public class Phoenix_WacChangeRejectedLinesClsTest {

    static testmethod void WacChangeRejectedMethod() {
        list < Product2 > prodList = new list < Product2 > ();
        Product_Family__c pf = new Product_Family__c();
        pf.Name = 'Test Family';
        insert pf;
        Product_Family__c pf1 = new Product_Family__c();
        pf1.Name = 'Sample Family';
        insert pf1;
        Product_Family__c pf2 = new Product_Family__c();
        pf2.Name = 'cetirizine';
        insert pf2;
        Product_Family__c pf3 = new Product_Family__c();
        pf3.Name = 'cetirizine';
        insert pf3;
        Product2 prod1 = new Product2(Name = 'Test Product', Product_Family__c = pf.Id,Phoenix_Rx_SRx_OTC__c = 'Rx', Phoenix_Special_Product__c = true, Phoenix_GPI_Generic_Product_Identifier__c = '11111', Phoenix_NDC_11__c = '12345678902', Family = 'Test Family', IsActive = TRUE);
        Product2 prod2 = new Product2(Name = 'Test Product1', Product_Family__c = pf1.Id,Phoenix_Rx_SRx_OTC__c = 'Rx', Phoenix_Special_Product__c = true, Phoenix_GPI_Generic_Product_Identifier__c = '22222', Phoenix_NDC_11__c = '21345678902', Family = 'Sample Family', IsActive = TRUE);
        Product2 prod3 = new Product2(Name = 'Test Product2', Product_Family__c = pf2.Id,Phoenix_Rx_SRx_OTC__c = 'SRx', Phoenix_Special_Product__c = true, Phoenix_NDC_11__c = '32145678902', Family = ' cetirizine', IsActive = TRUE);
        Product2 prod4 = new Product2(Name = 'Test Product3', Product_Family__c = pf3.Id,Phoenix_Rx_SRx_OTC__c = 'OTC', Phoenix_Special_Product__c = true, Phoenix_GPI_Generic_Product_Identifier__c = '333333', Family = ' cetirizine', IsActive = TRUE);
        
        prodList.add(prod1);
        prodList.add(prod2);
        prodList.add(prod3);
        prodList.add(prod4);
        insert prodList;    
        
        Phoenix_WAC_Change__c testNDC=new Phoenix_WAC_Change__c();
        testNDC.Phoenix_Approval_Status__c='Draft';   
        testNDC.Phoenix_WAC_Change_Name__c    ='testRecord';
      
       
        insert testNDC;
         
         
          list < Phoenix_WAC_Change_Line_Item__c > lineItemsList = new list < Phoenix_WAC_Change_Line_Item__c > ();
        Phoenix_WAC_Change_Line_Item__c pbl1=new Phoenix_WAC_Change_Line_Item__c();
        pbl1.Phoenix_WAC_Change__c=testNDC.Id;
        pbl1.Phoenix_Product__c = prod1.id;
      
        
        lineItemsList.add(pbl1);
        Phoenix_WAC_Change_Line_Item__c pbl2=new Phoenix_WAC_Change_Line_Item__c();
        pbl2.Phoenix_WAC_Change__c=testNDC.Id;
        pbl2.Phoenix_Product__c = prod2.id;
   
        lineItemsList.add(pbl2);
        insert lineItemsList;
        
        list<string>lineItemIds=new list<string>();    
        lineItemIds.add(pbl2.Id);
         
         
         Phoenix_WacChangeRejectedLinesCls.getRelatedList(testNDC.Id);
          Phoenix_WacChangeRejectedLinesCls.getupdatedforExport(testNDC.Id);
            Phoenix_WacChangeRejectedLinesCls.saveLineItems(lineItemsList);
         Phoenix_WacChangeRejectedLinesCls.deleteLineItems(lineItemsList[0].Id);
         testNDC.Phoenix_WAC_Change_Name__c='test';
         update testNDC;
         //delete testNDC;
     }


}