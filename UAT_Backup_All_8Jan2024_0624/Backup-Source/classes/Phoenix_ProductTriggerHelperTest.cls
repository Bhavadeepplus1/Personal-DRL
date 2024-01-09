@isTest
public class Phoenix_ProductTriggerHelperTest {
    static testmethod void AddProductMethod() {
        Product_Family__c pf=new Product_Family__c(Name='Test Family',Family_Group__c='TestGroup',Vision_IsActive__c=false);
        insert pf;
        
        list < Product2 > prodList = new list < Product2 > ();
        Product2 prod1 = new Product2(Name = 'Test Product', Phoenix_Rx_SRx_OTC__c = 'Rx', Phoenix_Special_Product__c = true, Phoenix_GPI_Generic_Product_Identifier__c = '11111', Phoenix_NDC_11__c = '12345678902', Family = 'Test Family', IsActive = TRUE,Product_Family__c=pf.Id);
        Product2 prod2 = new Product2(Name = 'Test Product1', Phoenix_Rx_SRx_OTC__c = 'Rx', Phoenix_Special_Product__c = true, Phoenix_GPI_Generic_Product_Identifier__c = '22222', Phoenix_NDC_11__c = '21345678902', Family = 'Sample Family', IsActive = TRUE,Product_Family__c=pf.Id);
        Product2 prod3 = new Product2(Name = 'Test Product2', Phoenix_Rx_SRx_OTC__c = 'SRx', Phoenix_Special_Product__c = true, Phoenix_NDC_11__c = '32145678902', Family = ' cetirizine', IsActive = TRUE,Product_Family__c=pf.Id);
        Product2 prod4 = new Product2(Name = 'Test Product3', Phoenix_Rx_SRx_OTC__c = 'OTC', Phoenix_Special_Product__c = true, Phoenix_GPI_Generic_Product_Identifier__c = '333333', Family = ' cetirizine', IsActive = TRUE,Product_Family__c=pf.Id);
        
        prodList.add(prod1);
        prodList.add(prod2);
        prodList.add(prod3);
        prodList.add(prod4);
        insert prodList;
        
        prod1.IsActive=false;
        update prod1;
        
    }
    
}