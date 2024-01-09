@isTest
public class GoogleSFDCOrderStatusFetchTest {
    @testSetup static void setup() {
        // Create common test accounts and DRL Sales
        List<Account> accList = new List<Account>();
        Account acc = new Account(Name = 'Test Record', accountNumber='12345');
        Account acc1 = new Account(Name = 'Test Record 2', accountNumber='67890');
        Account acc2 = new Account(Name = 'Test Record 3', accountNumber='1237854');
        accList.add(acc);
        accList.add(acc1);
        accList.add(acc2);
        insert accList;
        Product2 p=new Product2();
        p.Name='abc pharma';
        p.Phoenix_NDC_11__c='23364848';
        p.ProductCode='123566';
        p.Phoenix_NDC__c='5555555';
        p.Phoenix_GPI_Generic_Product_Identifier__c = '11111';
        p.Family = 'Test Family';
        p.Phoenix_Throughput_cost__c=10.23456576;
        p.Phoenix_GCN_Sequence_Number__c='666666';
        p.Phoenix_Pkg_Size__c=25.0;
        p.IsActive = true;
        p.Phoenix_Is_Exclude_Bid__c = false;
        Product2 p1=new Product2();
        p1.Name='abc pharma 2';
        p1.Phoenix_NDC_11__c='23364848';
        p1.ProductCode='1235678';
        p1.Phoenix_NDC__c='5555555';
        p1.Phoenix_GPI_Generic_Product_Identifier__c = '11111';
        p1.Family = 'Test Family';
        p1.Phoenix_Throughput_cost__c=10.23456576;
        p1.Phoenix_GCN_Sequence_Number__c='666666';
        p1.Phoenix_Pkg_Size__c=25.0;
        p1.IsActive = true;
        p1.Phoenix_Is_Exclude_Bid__c = false;
        insert p1;
        List<Vision_GCP_SFDC_Order_Status__c> ordStatusList = new List<Vision_GCP_SFDC_Order_Status__c>();
        for(Integer i=0; i<=2; i++){
            Vision_GCP_SFDC_Order_Status__c ordStatus = new Vision_GCP_SFDC_Order_Status__c();
            
            if(i == 0){
                ordStatus.Vision_Customer_Code__c= '12345';
                ordStatus.Vision_SKU_Code__c='123566';
                ordStatus.Vision_Account__c = acc.Id;
            }
            else if(i == 1){
                ordStatus.Vision_Customer_Code__c= '67890';
                ordStatus.Vision_SKU_Code__c='1235678';
                ordStatus.Vision_Product__c = p1.Id;
            }
            else{
                ordStatus.Vision_Customer_Code__c= '23456';
                ordStatus.Vision_Account__c = acc2.Id;
            }
            ordStatusList.add(ordStatus);
        }
        insert ordStatusList;
    }
    @isTest static void testMethod1() 
    {
        Test.startTest();
        GoogleSFDCOrderStatusFetch batch = new GoogleSFDCOrderStatusFetch();
        batch.execute(null); 
        Test.stopTest();
    }
    
    @isTest static void testMethod2() 
    {
        Test.startTest();
        Database.executeBatch(new GoogleSFDCOrderStatusFetch(1,1));
        Test.stopTest();
        Vision_GCP_SFDC_Order_Status__c gcp = [ SELECT Vision_Account__r.Name,Id FROM Vision_GCP_SFDC_Order_Status__c WHERE Vision_SKU_Code__c= '123566'];
        System.assertEquals('Test Record', gcp.Vision_Account__r.Name);
    }
    @isTest static void testMethod3() 
    {
        Test.startTest();
        Database.executeBatch(new GoogleSFDCOrderStatusFetch(1,1));
        Test.stopTest();
        Vision_GCP_SFDC_Order_Status__c gcp = [ SELECT Vision_Product__r.Name,Id FROM Vision_GCP_SFDC_Order_Status__c WHERE Vision_SKU_Code__c= '1235678'];
        System.assertEquals('abc pharma 2', gcp.Vision_Product__r.Name);
        
    }
}