@isTest
public class GoogleNoOppProductsFetchTest {
    @testSetup static void setup() {
        // Create common test accounts and DRL Sales
        List<Account> accList = new List<Account>();
        Account acc = new Account(Name = 'Test Record');
        accList.add(acc);
        insert accList;
    	List<Vision_Non_Opportunity_Products__c> NOPList = new List<Vision_Non_Opportunity_Products__c>();
        for(Account a : accList){
            Vision_Non_Opportunity_Products__c nop = new Vision_Non_Opportunity_Products__c();
            nop.Vision_Product_Family__c= 'Test NOP Record';
            nop.Vision_Drl_Act_Volume_Eu__c= 0420.0;
            nop.Vision_Segment__c= 'RX';
            nop.Vision_Drl_Act_Sales__c= 446.489;
            nop.Vision_Drl_Act_Price__c= 0.44;
            nop.Vision_Drl_Act_TPT__c= 234.0;
           // nop.Vision_DRL_Act_TPT_PCT__c= 32.702;
            nop.Vision_Prof_Month_Range__c= 'Nov 2020 - Oct 2021';
            nop.Vision_IMS_Mat_Volume_Eu__c= 1.234;
            nop.GCP_Unique_Identifier__c= 'Test NOP Record_RX';
            NOPList.add(nop);
        }
        upsert NOPList;
    }
    @isTest static void testMethod1() 
    {
        
        map<String,Id > existingGCPMap =new Map<String,Id >();
        for( Vision_Non_Opportunity_Products__c gcp : [select Id,GCP_Unique_Identifier__c  From Vision_Non_Opportunity_Products__c Where Vision_Product_Family__c= 'Test NOP Record'])existingGCPMap.put(gcp.GCP_Unique_Identifier__c,gcp.Id);
        Test.startTest();
        GoogleNoOppProductsFetch batch = new GoogleNoOppProductsFetch();
        batch.execute(null);
        Test.stopTest();
        Vision_Non_Opportunity_Products__c gcp = [ SELECT Vision_Product_Family__c,GCP_Unique_Identifier__c,Id FROM Vision_Non_Opportunity_Products__c WHERE Vision_Product_Family__c= 'Test NOP Record'];
        System.assertEquals('Test NOP Record', gcp.Vision_Product_Family__c);
    }
    
    @isTest static void testMethod2() 
    {
        map<String,Id > existingGCPMap =new Map<String,Id >();
        for( Vision_Non_Opportunity_Products__c gcp : [select Id,GCP_Unique_Identifier__c  From Vision_Non_Opportunity_Products__c Where Vision_Product_Family__c= 'Test NOP Record'])existingGCPMap.put(gcp.GCP_Unique_Identifier__c,gcp.Id);
        Test.startTest();
        Database.executeBatch(new GoogleNoOppProductsFetch(1,1));
        Test.stopTest();
        Vision_Non_Opportunity_Products__c gcp = [ SELECT Vision_Product_Family__c,GCP_Unique_Identifier__c,Id FROM Vision_Non_Opportunity_Products__c WHERE Vision_Product_Family__c= 'Test NOP Record'];
        System.assertEquals('Test NOP Record', gcp.Vision_Product_Family__c);
    }

}