@isTest
public class GoogleBigQueryDataFetchBatchTest {
    @testSetup static void setup() {
        // Create common test accounts and DRL Sales
        List<Account> accList = new List<Account>();
        Account acc = new Account(Name = 'Test Record');
        accList.add(acc);
        insert accList;
    	List<Phoenix_GCP_Opportunity_Tracker__c> optyList = new List<Phoenix_GCP_Opportunity_Tracker__c>();
        for(Account a : accList){
            Phoenix_GCP_Opportunity_Tracker__c opty = new Phoenix_GCP_Opportunity_Tracker__c();
            opty.GCP_Product_Family__c= 'Test Opty Record';
            opty.GCP_Customer_Code_temp__c= 'Test Code Temp';
            opty.gcp_customer_name__c= 'Test customer name';
            opty.Phoenix_Segment__c= 'Test Segment';
            opty.Phoenix_Product_Family__c= 'Test Opty Record';
            opty.GCP_Unique_Identifier__c= opty.GCP_Product_Family__c+'_'+opty.GCP_Customer_Code_temp__c+'_'+opty.Phoenix_Segment__c;
            optyList.add(opty);
        }
        upsert optyList;
    }
    @isTest static void testMethod1() 
    {
        
        map<String,Id > existingGCPMap =new Map<String,Id >();
        for( Phoenix_GCP_Opportunity_Tracker__c gcp : [select Id,GCP_Unique_Identifier__c  From Phoenix_GCP_Opportunity_Tracker__c Where GCP_Product_Family__c= 'Test Opty Record'])existingGCPMap.put(gcp.GCP_Unique_Identifier__c,gcp.Id);
        Test.startTest();
        GoogleBigQueryDataFetchBatch batch = new GoogleBigQueryDataFetchBatch();
        batch.execute(null);
        Test.stopTest();
        Phoenix_GCP_Opportunity_Tracker__c gcp = [ SELECT GCP_Product_Family__c,GCP_Unique_Identifier__c,Id FROM Phoenix_GCP_Opportunity_Tracker__c WHERE GCP_Product_Family__c= 'Test Opty Record'];
        System.assertEquals('Test Opty Record', gcp.GCP_Product_Family__c);
    }
    
    @isTest static void testMethod2() 
    {
        map<String,Id > existingGCPMap =new Map<String,Id >();
        for( Phoenix_GCP_Opportunity_Tracker__c gcp : [select Id,GCP_Unique_Identifier__c  From Phoenix_GCP_Opportunity_Tracker__c Where GCP_Product_Family__c= 'Test Opty Record'])existingGCPMap.put(gcp.GCP_Unique_Identifier__c,gcp.Id);
        Test.startTest();
        Database.executeBatch(new GoogleBigQueryDataFetchBatch(1,1));
        Test.stopTest();
        Phoenix_GCP_Opportunity_Tracker__c gcp = [ SELECT GCP_Product_Family__c,GCP_Unique_Identifier__c,Id FROM Phoenix_GCP_Opportunity_Tracker__c WHERE GCP_Product_Family__c= 'Test Opty Record'];
        System.assertEquals('Test Opty Record', gcp.GCP_Product_Family__c);
    }

}