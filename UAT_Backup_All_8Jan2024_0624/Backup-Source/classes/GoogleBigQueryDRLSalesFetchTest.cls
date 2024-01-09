@isTest
public class GoogleBigQueryDRLSalesFetchTest {
    @testSetup static void setup() {
        // Create common test accounts and DRL Sales
        List<Account> accList = new List<Account>();
        Account acc = new Account(Name = 'Test Record',accountnumber='1234');
        accList.add(acc);
        insert accList;
        GCP_Product_Family_Map__c gcp = new GCP_Product_Family_Map__c();
        gcp.GCP_Product_Family__c = 'GCP DRL Sales Record';
        gcp.SFDC_Product_Family__c = 'Test DRL Sales Record';
        insert gcp;
    	List<Vision_DRL_Sales__c> drlSalesList = new List<Vision_DRL_Sales__c>();
        for(Account a : accList){
            Vision_DRL_Sales__c sales = new Vision_DRL_Sales__c();
            sales.Vision_Product_Family__c= 'Test DRL Sales Record';
            sales.GCP_customer_name__c= a.Name;
            sales.Vision_Customer_Name__c= a.Id;
            sales.Vision_Customer_Number__c= '111111';
            sales.Vision_Month_dtls__c= Date.today();
            sales.Vision_Units__c= 234.0;
            sales.Vision_Sales_Dollar__c= 1745.7343121;
            sales.Vision_TPT_Dollar__c= 1566.3956;
            sales.Vision_TPT_Pct__c= 0.897270;
            sales.Vision_NPR_Customer_Code__c='111111';
            sales.GCP_Unique_Identifier__c= 'Test DRL Sales Record_111111_'+Date.today();
            drlSalesList.add(sales);
        }
        upsert drlSalesList;
    }
    @isTest static void testMethod1() 
    {
        
        map<String,Id > existingGCPMap =new Map<String,Id >();
        for( Vision_DRL_Sales__c gcp : [select Id,GCP_Unique_Identifier__c  From Vision_DRL_Sales__c Where Vision_Product_Family__c= 'Test DRL Sales Record'])existingGCPMap.put(gcp.GCP_Unique_Identifier__c,gcp.Id);
        Test.startTest();
        GoogleBigQueryDRLSalesFetch batch = new GoogleBigQueryDRLSalesFetch();
        batch.execute(null);
        Test.stopTest();
        Vision_DRL_Sales__c gcp = [ SELECT Vision_Product_Family__c,GCP_Unique_Identifier__c,Id FROM Vision_DRL_Sales__c WHERE Vision_Product_Family__c= 'Test DRL Sales Record'];
        System.assertEquals('Test DRL Sales Record', gcp.Vision_Product_Family__c);
    }
    
    @isTest static void testMethod2() 
    {
        map<String,Id > existingGCPMap =new Map<String,Id >();
        for( Vision_DRL_Sales__c gcp : [select Id,GCP_Unique_Identifier__c  From Vision_DRL_Sales__c Where Vision_Product_Family__c= 'Test DRL Sales Record'])existingGCPMap.put(gcp.GCP_Unique_Identifier__c,gcp.Id);
        Test.startTest();
        Database.executeBatch(new GoogleBigQueryDRLSalesFetch(1,1));
        Test.stopTest();
        Vision_DRL_Sales__c gcp = [ SELECT Vision_Product_Family__c,GCP_Unique_Identifier__c,Id FROM Vision_DRL_Sales__c WHERE Vision_Product_Family__c= 'Test DRL Sales Record'];
        System.assertEquals('Test DRL Sales Record', gcp.Vision_Product_Family__c);
    }

}