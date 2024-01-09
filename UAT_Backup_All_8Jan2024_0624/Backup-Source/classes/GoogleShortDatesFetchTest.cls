@isTest
public class GoogleShortDatesFetchTest {
    @testSetup static void setup() {
        // Create common test accounts and DRL Sales
        List<Account> accList = new List<Account>();
        Account acc = new Account(Name = 'Test Record', accountNumber='12345');
        accList.add(acc);
        insert accList;
        GCP_Product_Family_Map__c prdFamily = new GCP_Product_Family_Map__c(GCP_Product_Family__c = 'Test SDR Record 1',SFDC_Product_Family__c='Test SDR');
        insert prdFamily;
    	List<Vision_GCP_Short_Date__c > SDRList = new List<Vision_GCP_Short_Date__c >();
        for(Integer i=0; i<=2; i++){
            Vision_GCP_Short_Date__c  sdr = new Vision_GCP_Short_Date__c();
            sdr.GCP_Product_Family__c= 'Test SDR Record '+String.valueOf(i);
            if(i == 1){
            	sdr.Vision_Product_Family__c = 'Test SDR';
            }
            SDRList.add(sdr);
        }
        upsert SDRList;
    }
    @isTest static void testMethod1() 
    {
        Test.startTest();
        GoogleShortDatesFetch batch = new GoogleShortDatesFetch();
        batch.execute(null); 
        Test.stopTest();
        
    }
    
    @isTest static void testMethod2() 
    {
        Test.startTest();
        Database.executeBatch(new GoogleShortDatesFetch(1,1));
        Test.stopTest();
        Vision_GCP_Short_Date__c gcp = [ SELECT GCP_Product_Family__c,Id FROM Vision_GCP_Short_Date__c WHERE GCP_Product_Family__c= 'Test SDR Record 2'];
        System.assertEquals('Test SDR Record 2', gcp.GCP_Product_Family__c);
    } 
    @isTest static void testMethod3() 
    {
        Test.startTest();
        Database.executeBatch(new GoogleShortDatesFetch(1,1));
        Test.stopTest();
        Vision_GCP_Short_Date__c gcp = [ SELECT Vision_Product_Family__c,Id FROM Vision_GCP_Short_Date__c WHERE GCP_Product_Family__c= 'Test SDR Record 1'];
        System.assertEquals('Test SDR', gcp.Vision_Product_Family__c);
    } 
}