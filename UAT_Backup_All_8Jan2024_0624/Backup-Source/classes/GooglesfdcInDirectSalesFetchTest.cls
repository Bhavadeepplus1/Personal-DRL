@istest
public class GooglesfdcInDirectSalesFetchTest {
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
        P.ProductCode = '12122321';
        P.Phoenix_NDC_11__c = '35345435';
        
        
        insert p;
         Phoenix_Contract__c ctr = new Phoenix_Contract__c();
        ctr.Name = 'Test Contract';
        ctr.Phoenix_Contract_Number__c = '46579';
        ctr.Phoenix_Customer__c = a.Id;
        insert ctr;
        GCP_SFDC_Indirect_Sales__c ids = new GCP_SFDC_Indirect_Sales__c();
             ids.Vision_Product__c=p.id;
             ids.Vision_Contract__c=ctr.id;
             ids.Vision_Contract_ID__c='46579';
             ids.Vision_NDC__c='123';
             ids.Vision_Material_Number__c='123';
             insert ids;
        GCP_SFDC_Indirect_Sales__c ids1 = new GCP_SFDC_Indirect_Sales__c();
             ids1.Vision_Product__c=p.id;
             ids1.Vision_Contract__c=ctr.id;
             ids1.Vision_Contract_ID__c='46579';
             ids1.Vision_NDC__c='123';
             insert ids1;
        test.startTest();
         GoogleSFDCInDirectSalesFetch b = new GoogleSFDCInDirectSalesFetch();
        Database.executeBatch(new GoogleSFDCInDirectSalesFetch(1,1));
        Database.executeBatch(b);
        test.stopTest();
    }
}