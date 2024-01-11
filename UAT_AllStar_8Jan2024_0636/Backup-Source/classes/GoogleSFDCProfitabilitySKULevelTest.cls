@istest
public class GoogleSFDCProfitabilitySKULevelTest {
    static testmethod void setup(){
        Account a= new Account();
        a.Name='test';
        a.AccountNumber='123';
        insert a;
        Product2 p=new Product2();
        p.Name='abc pharma';
      //  p.Phoenix_NDC_11__c='23364848';
        p.ProductCode='123566';
       // p.Phoenix_NDC__c='5555555';
       // p.Phoenix_GPI_Generic_Product_Identifier__c = '11111';
       // p.Family = 'Test Family';
       // p.Phoenix_Throughput_cost__c=10.23456576;
       // p.Phoenix_GCN_Sequence_Number__c='666666';
       // p.Phoenix_Pkg_Size__c=25.0;
       // p.IsActive = true;
       // p.Phoenix_Is_Exclude_Bid__c = false;
        
        insert p;
        Vision_GCP_SFDC_Profitability_SKU_Level__c sfp= new  Vision_GCP_SFDC_Profitability_SKU_Level__c();
        
        
        sfp.Vision_SKU_Code__c='123566';
        sfp.Vision_Customer_Number__c='123';
        sfp.Vision_Product_Family__c='su';
        // sfp.Vision_Customer__c=a.id;
        // sfp.Vision_Product__c=p.id;
        sfp.GCP_Product_Family__c='gf 1%e';
        insert sfp;
        test.startTest();
        GoogleSFDCProfitabilitySKULevel b = new GoogleSFDCProfitabilitySKULevel();
       Database.executeBatch(new GoogleSFDCProfitabilitySKULevel(1,1));
        Database.executeBatch(b);
        test.stopTest();
    
    }
    
}