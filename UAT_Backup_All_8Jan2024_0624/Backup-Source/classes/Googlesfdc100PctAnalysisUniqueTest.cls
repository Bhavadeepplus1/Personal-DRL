@istest
public class Googlesfdc100PctAnalysisUniqueTest {
   static testmethod void setup() {
         Account a = new Account();
        a.Name='es';
        a.AccountNumber='12563';
        insert a;
        Product_Family__c p= new Product_Family__c();
        p.name='abc';
        insert p;
        GCP_100Pct_Analysis_Unique__c gcp=new GCP_100Pct_Analysis_Unique__c();
        gcp.GCP_Product_Family__c='abc';
        insert gcp;
       product2 pp=new product2();
       pp.name='abc';
       pp.ProductCode='1234';
       insert pp;
       GCP_100PCT_Analysis_SKU__c gg= new GCP_100PCT_Analysis_SKU__c();
       gg.GCP_Product_Family__c='abc';
       gg.SKU_Code__c='1234';
       insert gg;
       
        test.starttest();
         Googlesfdc100PctAnalysisUnique b = new Googlesfdc100PctAnalysisUnique();
        database.executeBatch(b);
         Database.executeBatch(new Googlesfdc100PctAnalysisUnique(5,1));
         Googlesfdc100pctanalysisSKULevel c = new Googlesfdc100pctanalysisSKULevel();
        database.executeBatch(c);
         Database.executeBatch(new Googlesfdc100pctanalysisSKULevel(5,1));
        test.stopTest();
    }
}