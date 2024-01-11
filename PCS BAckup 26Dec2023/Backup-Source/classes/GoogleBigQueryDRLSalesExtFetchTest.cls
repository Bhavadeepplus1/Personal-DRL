@istest
public class GoogleBigQueryDRLSalesExtFetchTest {
    @istest(seealldata=true)
     public static  void main(){
        Account a = new Account();
        a.Name='test';
        a.AccountNumber='1234';
        insert a;
        Phoenix_Contract__c ct= new Phoenix_Contract__c();
        ct.Phoenix_Contract_Number__c='1223';
        ct.Phoenix_Contract_Start_Date__c=date.newInstance(2022, 04, 17);
        ct.Phoenix_Contract_End_Date__c=system.Today()+1;
        insert ct;
        Product2 p = new Product2();
        p.Name='abc';
        p.ProductCode='1222';
        p.IsActive=true;
        p.Phoenix_Is_Exclude_Bid__c=false;
        insert p;
          GCP_Product_Family_Map__c gcp = new GCP_Product_Family_Map__c();
        gcp.GCP_Product_Family__c = 'GCP DRL Sales Record';
        gcp.SFDC_Product_Family__c = 'Test DRL Sales Record';
        insert gcp;
      Vision_DRL_Sales_External_Summary__c extsales = new Vision_DRL_Sales_External_Summary__c();
        extsales.Vision_agreement_no__c='123456';
        extsales.Vision_Contract__c=ct.id;
        extsales.Vision_Customer__c=a.id;
        extsales.Vision_SKU_Code__c='1222';
        extsales.Vision_customer_code__c='1234';
        extsales.GCP_Product_Family__c='abc';
        insert extsales;
        test.startTest();
        GoogleBigQueryDRLSalesExtFetch b = new GoogleBigQueryDRLSalesExtFetch();
        database.executeBatch(b);
        database.executeBatch(new GoogleBigQueryDRLSalesExtFetch (1,1));
        
        
       
        test.stopTest();
    }

}