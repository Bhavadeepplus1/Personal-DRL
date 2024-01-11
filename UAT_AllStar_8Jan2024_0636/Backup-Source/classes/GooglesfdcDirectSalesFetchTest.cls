@istest
public class GooglesfdcDirectSalesFetchTest {
    static testmethod void Setup(){
        Account a= new Account();
        a.Name='test';
        a.AccountNumber='123';
        insert a;
        Product2 p=new Product2();
        p.Name='abc pharma';
        p.IsActive=true;
        p.Phoenix_Is_Exclude_Bid__c=false;
        p.Phoenix_NDC__c='123';
        insert p;
         Phoenix_Contract__c ctr = new Phoenix_Contract__c();
        ctr.Name = 'Test Contract';
        ctr.Phoenix_Contract_Number__c = '46579';
        ctr.Phoenix_Customer__c = a.Id;
        insert ctr;
        GCP_SFDC_Direct_Sales__c ds= new GCP_SFDC_Direct_Sales__c();
        ds.Vision_Product__c=p.id;
        ds.Vision_SAP_Material__c='123';
        ds.Vision_NDC__c='123';
        insert ds;
        test.startTest();
        GoogleSFDCDirectSalesFetch b = new GoogleSFDCDirectSalesFetch();
        Database.executeBatch(new GoogleSFDCDirectSalesFetch(1,1));
        Database.executeBatch(b);
        test.stopTest();
    }
    

}