@istest
public class GoogleSFDC100PCTAnalysisSKUFetchTest {
    static testmethod void main(){
         Account a= new Account();
        a.Name='test';
        a.AccountNumber='123';
        insert a;
        Product2 p=new Product2();
        p.Name='abc pharma';
        p.IsActive=true;
        p.Phoenix_Is_Exclude_Bid__c=false;
        p.Phoenix_NDC__c='123';
        p.ProductCode='123456';
        
        insert p;
         Phoenix_Contract__c ctr = new Phoenix_Contract__c();
        ctr.Name = 'Test Contract';
        ctr.Phoenix_Contract_Number__c = '46579';
        ctr.Phoenix_Customer__c = a.Id;
        insert ctr;
        GCP_SFDC_100pct_Analysis_SKU__c tt= new GCP_SFDC_100pct_Analysis_SKU__c();
        tt.Vision_Customer__c=a.id;
        tt.Vision_Customer_Code__c=123456;
        tt.Vision_SKU_Code__c='123456';
        tt.Vision_Product__c=p.id;
        tt.GCP_Product_Family__c='abc';
        insert tt;
        test.startTest();
        GoogleSFDC100PCTAnalysisSKUFetch b= new GoogleSFDC100PCTAnalysisSKUFetch();
        database.executeBatch(b);
        database.executeBatch(new GoogleSFDC100PCTAnalysisSKUFetch(1,1));
        test.stopTest();
    }

}