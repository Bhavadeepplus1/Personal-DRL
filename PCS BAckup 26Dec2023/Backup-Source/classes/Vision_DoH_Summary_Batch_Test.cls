@isTest
public class Vision_DoH_Summary_Batch_Test {
    @testSetup static void setup() {
       List<Account> accList = new List<Account>();
        Account acc = new Account(Name = 'Test Record', accountNumber='12345');
        accList.add(acc);
        insert accList;
        
         GCP_Trade_Partner_DOH_Report__c tradeDoH= new GCP_Trade_Partner_DOH_Report__c(Trade_Partner_Name__c='test Trade',Package_Description__c='testProduct',W3_DOH__c=2);
          insert tradeDoH;
        
    }
    @isTest static void testMethod1() 
    {
        Test.startTest();
        Vision_DoH_Summary_Batch batch = new Vision_DoH_Summary_Batch();
        Database.executeBatch(batch);
        //
        //batch.execute(); 
        Test.stopTest();
        
    }
    @isTest static void testMethod2() 
    {
        Test.startTest();
        Database.executeBatch(new Vision_DoH_Summary_Batch());
        Test.stopTest();
        GCP_Trade_Partner_DOH_Report__c gcp = [ SELECT Id, Trade_Partner_Name__c, Package_Description__c FROM GCP_Trade_Partner_DOH_Report__c limit 1];
        
    } 
}