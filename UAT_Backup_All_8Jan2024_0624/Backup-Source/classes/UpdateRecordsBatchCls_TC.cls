@isTest
public class UpdateRecordsBatchCls_TC {
    static testmethod void test1() {
        Test.startTest();
        GCP_SFDC_100pct_Analysis_SKU__c newObj = new GCP_SFDC_100pct_Analysis_SKU__c();
        newObj.Vision_Update_Date__c = system.today();
        newObj.Vision_isIncludeProduct__c = true;
        insert newObj;
        
        Database.executeBatch(new UpdateRecordsBatchCls('GCP_SFDC_100pct_Analysis_SKU__c','Vision_isIncludeProduct__c','false','boolean'));
        Test.stopTest();
    }
    static testmethod void test2() {
        Test.startTest();
        GCP_SFDC_100pct_Analysis_SKU__c newObj = new GCP_SFDC_100pct_Analysis_SKU__c();
        newObj.Vision_Update_Date__c = system.today();
        newObj.Vision_isIncludeProduct__c = true;
        insert newObj;
        
        Database.executeBatch(new UpdateRecordsBatchCls('GCP_SFDC_100pct_Analysis_SKU__c','Vision_Update_Date__c',''+system.today(),'date'));
        Test.stopTest();
    }
    static testmethod void test3() {
        Test.startTest();
        GCP_SFDC_100pct_Analysis_SKU__c newObj = new GCP_SFDC_100pct_Analysis_SKU__c();
        newObj.Vision_Update_Date__c = system.today();
        newObj.Vision_Drl_Act_Price__c = 100;
        insert newObj;
        
        Database.executeBatch(new UpdateRecordsBatchCls('GCP_SFDC_100pct_Analysis_SKU__c','Vision_Drl_Act_Price__c','200','Integer'));
        Test.stopTest();
    }
    static testmethod void test4() {
        Test.startTest();
        GCP_SFDC_100pct_Analysis_SKU__c newObj = new GCP_SFDC_100pct_Analysis_SKU__c();
        newObj.Vision_Update_Date__c = system.today();
        newObj.Vision_Drl_Act_Sales__c = 100;
        insert newObj;
        
        Database.executeBatch(new UpdateRecordsBatchCls('GCP_SFDC_100pct_Analysis_SKU__c','Vision_Drl_Act_Sales__c','200','decimal'));
        Test.stopTest();
    }
}