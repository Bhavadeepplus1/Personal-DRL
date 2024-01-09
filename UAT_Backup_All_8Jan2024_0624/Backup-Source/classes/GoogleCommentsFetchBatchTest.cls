@isTest
public class GoogleCommentsFetchBatchTest {
    @testSetup static void setup() {
        // Create common test accounts and DRL Sales
        List<Account> accList = new List<Account>();
        Account acc = new Account(Name = 'Test Record');
        accList.add(acc);
        insert accList;
        List<GCP_Comment__c> gcp_comment_List = new List<GCP_Comment__c>();
        for(Account a : accList){
            GCP_Comment__c cmm = new GCP_Comment__c();
            cmm.GCP_Product_Family__c= 'Test Comment Record';
            cmm.long_term_strategy__c= 'Test Long Term Strategy';
            cmm.Segment__c= 'Test Segment';
            cmm.short_term_strategy__c= 'Test Short Term Strategy';
            cmm.Author__c= 'Test Author';
            cmm.Comment_Date__c = Date.today();
            cmm.Product_Family__c = 'Test Product Family';
            cmm.Comment_Type__c  = 'Panorama';
            cmm.GCP_Unique_Identifier__c= cmm.GCP_Product_Family__c+'_'+cmm.Segment__c+'_'+cmm.Comment_Date__c;
            gcp_comment_List.add(cmm);
        }
        upsert gcp_comment_List;
    }
    @isTest static void testMethod1() 
    {
        
        map<String,Id > existingGCPMap =new Map<String,Id >();
        for( GCP_Comment__c gcp : [select Id,GCP_Unique_Identifier__c  From GCP_Comment__c Where GCP_Product_Family__c = 'Test Comment Record'])existingGCPMap.put(gcp.GCP_Unique_Identifier__c,gcp.Id);
        Test.startTest();
        GoogleCommentsFetchBatch batch = new GoogleCommentsFetchBatch();
        batch.execute(null);
        Test.stopTest();
        GCP_Comment__c gcp = [ SELECT GCP_Product_Family__c ,GCP_Unique_Identifier__c,Id FROM GCP_Comment__c WHERE GCP_Product_Family__c = 'Test Comment Record'];
        System.assertEquals('Test Comment Record', gcp.GCP_Product_Family__c );
    }
    
    @isTest static void testMethod2() 
    {
        map<String,Id > existingGCPMap =new Map<String,Id >();
        for( GCP_Comment__c gcp : [select Id,GCP_Unique_Identifier__c  From GCP_Comment__c Where GCP_Product_Family__c = 'Test Comment Record'])existingGCPMap.put(gcp.GCP_Unique_Identifier__c,gcp.Id);
        Test.startTest();
        Database.executeBatch(new GoogleCommentsFetchBatch(1,1));
        Test.stopTest();
        GCP_Comment__c gcp = [ SELECT GCP_Product_Family__c ,GCP_Unique_Identifier__c,Id FROM GCP_Comment__c WHERE GCP_Product_Family__c= 'Test Comment Record'];
        System.assertEquals('Test Comment Record', gcp.GCP_Product_Family__c );
    }
}