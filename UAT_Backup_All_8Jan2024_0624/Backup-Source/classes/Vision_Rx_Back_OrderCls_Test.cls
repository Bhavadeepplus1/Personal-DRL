@isTest(seeAllData=true)
public class Vision_Rx_Back_OrderCls_Test {   
   static testmethod void  test(){
        
       Vision_GCP_Backorder_OTC__c backOrderRx1 = new  Vision_GCP_Backorder_OTC__c(GCP_Customer_Name__c = 'ABC', Product_Family__c = 'Fexo 180', Vision_Comments__c='comment 1');
        insert backOrderRx1;
        
         Vision_GCP_Backorder_OTC__c backOrderRx2 = new  Vision_GCP_Backorder_OTC__c(GCP_Customer_Name__c = 'Amazon', Product_Family__c = 'Fexo 180', Vision_Comments__c ='comment 2');
        insert backOrderRx2;
        
        
        String tradePartnerName = 'ABC';
        
        Vision_Rx_Back_OrderCls.getCustomers();
        Vision_Rx_Back_OrderCls.getbackOrder('ABC', true);
        Vision_Rx_Back_OrderCls.getFilterBackOrder('test123', 'ABC', true);
        Vision_Rx_Back_OrderCls.fetchSortResults('GCP_Customer_Name__c', true,'ABC', true,'Fexo');
    } 
}