@isTest(seeAllData=true)
public class Vision_Rx_Fresh_Backorder_Test {
   static testmethod void  test(){
        
        Vision_GCP_Backorder_SRx_Rx__c backOrderSRx1 = new  Vision_GCP_Backorder_SRx_Rx__c(Vision_SKU_Description__c = 'Succinylcholinechlorideinj 20mg/mLUS25s', Vision_Comments__c='comment 1');
        insert backOrderSRx1;
        
         Vision_GCP_Backorder_SRx_Rx__c backOrderSRx2 = new  Vision_GCP_Backorder_SRx_Rx__c(Vision_SKU_Description__c = 'Thiotepa For Injection USP 15mg/Vial', Vision_Comments__c ='comment 2');
        insert backOrderSRx2;
        
        string searchText = 'test';
        String tradePartnerName = 'ABC';
       List<String> productType= new List<String>();
        productType.add('Rx');
        productType.add('SRx');                 
    
       Vision_Rx_Fresh_Backorder.getbackOrder( productType, true);
       Vision_Rx_Fresh_Backorder.getFilterBackOrder('test', true);
       Vision_Rx_Fresh_Backorder.fetchSortResults('Vision_SKU_Description__c', true,new List<Vision_GCP_Backorder_SRx_Rx__c>{backOrderSRx1, backOrderSRx2});
        
    } 

    
}