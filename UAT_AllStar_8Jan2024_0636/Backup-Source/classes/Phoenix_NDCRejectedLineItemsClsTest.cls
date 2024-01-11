@isTest
public class Phoenix_NDCRejectedLineItemsClsTest {
     static testmethod void NDCRejectedMethod() {
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
        
        Phoenix_NDC_Change__c testNDC=new Phoenix_NDC_Change__c();
        testNDC.Phoenix_Approval_Status__c='Draft';   
        testNDC.Phoenix_NDC_Change_Name__c    ='testRecord';
        testNDC.Phoenix_Current_Product_Family__c=prodList[0].Family;
        testNDC.Phoenix_Proposed_Product_Family__c=prodList[1].Family;
        insert testNDC;
          list<Phoenix_NDC_Change_Product__c>ndcProductList=new list<Phoenix_NDC_Change_Product__c>();
        Phoenix_NDC_Change_Product__c ndcChangeProduct=new Phoenix_NDC_Change_Product__c();
        ndcChangeProduct.Phoenix_NDC_Change_Name__c=testNDC.Id;
        ndcChangeProduct.Phoenix_Current_Product__c=prod1.Id;
        ndcChangeProduct.Phoenix_Proposed_Product__c=prod2.Id;
        insert ndcChangeProduct;
         
          list < Phoenix_NDC_Change_Line_Item__c > lineItemsList = new list < Phoenix_NDC_Change_Line_Item__c > ();
        Phoenix_NDC_Change_Line_Item__c pbl1=new Phoenix_NDC_Change_Line_Item__c();
        pbl1.Phoenix_NDC_Change__c=testNDC.Id;
        pbl1.Phoenix_NDC_Change_Product__c=ndcChangeProduct.Id;
        pbl1.Phoenix_Current_Product__c = prod1.id;
        pbl1.Phoenix_Proposed_Product__c = prod2.id;
        
        lineItemsList.add(pbl1);
        Phoenix_NDC_Change_Line_Item__c pbl2=new Phoenix_NDC_Change_Line_Item__c();
        pbl2.Phoenix_NDC_Change__c=testNDC.Id;
        pbl2.Phoenix_NDC_Change_Product__c=ndcChangeProduct.Id;
        pbl2.Phoenix_Current_Product__c = prod1.id;
        pbl2.Phoenix_Proposed_Product__c = prod2.id;
        lineItemsList.add(pbl2);
        insert lineItemsList;
        
        list<string>lineItemIds=new list<string>();    
        lineItemIds.add(pbl2.Id);
         
         
         Phoenix_NDCRejectedLineItemsCls.getRelatedList(testNDC.Id);
          Phoenix_NDCRejectedLineItemsCls.getupdatedforExport(testNDC.Id);
            Phoenix_NDCRejectedLineItemsCls.saveLineItems(lineItemsList);
         Phoenix_NDCRejectedLineItemsCls.deleteLineItems(lineItemsList[0].Id);
         testNDC.Phoenix_NDC_Change_Name__c='test';
         update testNDC;
        // delete testNDC;
     }

}