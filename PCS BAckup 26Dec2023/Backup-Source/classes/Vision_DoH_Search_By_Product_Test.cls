@isTest
public class Vision_DoH_Search_By_Product_Test {
	@isTest
    public static void testMethod1(){
        GCP_DOH_Trade_Partner_NDC__c gcpDoh = new GCP_DOH_Trade_Partner_NDC__c();
		gcpDoh.vision_gcp_ndc__c = 'Test';
        gcpDoh.vision_gcp_package_description__c = 'Test';
        gcpDoh.Vision_GCP_Update_Date__c = system.today();
        gcpDoh.vision_gcp_trade_partner_name__c = 'Test';
        insert gcpDoh;
        GCP_DOH_Trade_Partner_NDC__c gcpDoh2 = new GCP_DOH_Trade_Partner_NDC__c();
		gcpDoh2.vision_gcp_ndc__c = 'Test2';
        gcpDoh2.vision_gcp_package_description__c = 'Test2';
        gcpDoh2.Vision_GCP_Update_Date__c = system.today();
        gcpDoh2.vision_gcp_trade_partner_name__c = 'Test2';
        insert gcpDoh2;
       // Vision_DoH_Search_By_Product.getAccountGroups();
       List<String> strList = new List<String>();
        strList.add('Hello');
       Vision_DoH_Search_By_Product.getFilterDoHData('Test','Test2');
        GCP_DOH_Trade_Partner_NDC__c gcpDoh3 = new GCP_DOH_Trade_Partner_NDC__c();
		gcpDoh3.vision_gcp_ndc__c = 'Test2';
        gcpDoh3.vision_gcp_package_description__c = 'Test2';
        gcpDoh3.Vision_GCP_Update_Date__c = system.today();
        gcpDoh3.vision_gcp_trade_partner_name__c = 'Test2';
        insert gcpDoh3;
        Product2 pr = new Product2();
        pr.Name  = 'test product';
        insert pr;
        gcpDoh2.Product__c = pr.Id;
        update gcpDoh2;
        List < GCP_DOH_Trade_Partner_NDC__c > productList1 = new List < GCP_DOH_Trade_Partner_NDC__c >();
       productList1.add(gcpDoh2);
       Vision_DoH_Search_By_Product.fetchSortResults('','Test4',true,'Test2',productList1);
        
        Vision_DoH_Search_By_Product.getAwardedPositionData(gcpDoh2.Id,gcpDoh2.Id);
        
        
    }
    static testmethod void  test1(){
        GCP_Trade_Partner_DOH_Report__c tradeDoH= new GCP_Trade_Partner_DOH_Report__c(Trade_Partner_Name__c='test Trade',Package_Description__c='testProduct',W3_DOH__c=2,Vision_GCP_Update_Date__c ='2022-02-11');
        insert tradeDoH;
        GCP_DOH_Trade_Partner_NDC__c ndcDOH = new  GCP_DOH_Trade_Partner_NDC__c(vision_gcp_trade_partner_name__c ='test small');
        insert ndcDOH;
        List<GCP_DOH_Trade_Partner_NDC__c> ndcList = new List<GCP_DOH_Trade_Partner_NDC__c>{ndcDOH};
            
            doh_report_dates_info__c dohRepinfo = new  doh_report_dates_info__c(Vision_Update_Date__c ='2022-02-11', Name='Test');
        insert dohRepinfo;
        string customer = 'test';
        List<String> productType=new List<String> {}; 
            
            Vision_DoH_Search_By_Product.getAccountGroups();

    }
     static testmethod void  test7(){
        GCP_Trade_Partner_DOH_Report__c tradeDoH= new GCP_Trade_Partner_DOH_Report__c(Trade_Partner_Name__c='test Trade',Package_Description__c='testProduct',W3_DOH__c=2,Vision_GCP_Update_Date__c ='2022-02-11');
        insert tradeDoH;
        GCP_DOH_Trade_Partner_NDC__c ndcDOH = new  GCP_DOH_Trade_Partner_NDC__c(vision_gcp_trade_partner_name__c ='test small');
        insert ndcDOH;
        List<GCP_DOH_Trade_Partner_NDC__c> ndcList = new List<GCP_DOH_Trade_Partner_NDC__c>{ndcDOH};
            
            doh_report_dates_info__c dohRepinfo = new  doh_report_dates_info__c(Vision_Update_Date__c ='2022-02-11', Name='Test');
        insert dohRepinfo;
        string customer = 'test';
        List<String> productType=new List<String> {'Rx','Srx'}; 
            Vision_DoH_Search_By_Product.getAccountGroups();
       
    }
}