@isTest
public class GoogleProductPipelineDataFetchTest {
    @testSetup static void setup() {
        // Create common test accounts and DRL Sales
        List<Account> accList = new List<Account>();
        Account acc = new Account(Name = 'Test Record', accountNumber='12345');
        accList.add(acc);
        insert accList;
        GCP_Product_Family_Map__c prdFamily = new GCP_Product_Family_Map__c(GCP_Product_Family__c = 'Test PLD Record 1',SFDC_Product_Family__c='Test BOD');
        insert prdFamily;
        List<Product_Pipeline__c> BODList = new List<Product_Pipeline__c>();
        for(Integer i=0; i<=2; i++){
            Product_Pipeline__c bod = new Product_Pipeline__c();
            bod.Vision_GCP_Product_Family__c= 'Test PLD Record '+String.valueOf(i);
            bod.Vision_Segment__c= 'RX';
            if(i == 1){
                bod.Vision_Product_Family__c = 'Test PLD';
            }
            BODList.add(bod);
        }
        upsert BODList;
    }
    @isTest static void testMethod1()
    {
        Test.startTest();
        GoogleProductPipelineDataFetch batch = new GoogleProductPipelineDataFetch();
        batch.execute(null);
        Test.stopTest();
       
    }
   
    @isTest static void testMethod2()
    {
        Test.startTest();
        Database.executeBatch(new GoogleProductPipelineDataFetch(1,1));
        Test.stopTest();
        Product_Pipeline__c gcp = [ SELECT Vision_GCP_Product_Family__c,Id FROM Product_Pipeline__c WHERE Vision_GCP_Product_Family__c= 'Test PLD Record 2'];
        System.assertEquals('Test PLD Record 2', gcp.Vision_GCP_Product_Family__c);
    }
    @isTest static void testMethod3()
    {
        Test.startTest();
        Database.executeBatch(new GoogleProductPipelineDataFetch(1,1));
        Test.stopTest();
        Product_Pipeline__c gcp = [ SELECT Vision_Product_Family__c,Id FROM Product_Pipeline__c WHERE Vision_GCP_Product_Family__c= 'Test PLD Record 1'];
        System.assertEquals('Test PLD', gcp.Vision_Product_Family__c);
    }
}