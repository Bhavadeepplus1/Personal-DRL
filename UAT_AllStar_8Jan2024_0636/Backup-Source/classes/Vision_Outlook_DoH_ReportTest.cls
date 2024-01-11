@IsTest

public class Vision_Outlook_DoH_ReportTest {
    public static testmethod void test()
    {
        GCP_Trade_Partner_DOH_Report__c tradeDoH= new GCP_Trade_Partner_DOH_Report__c(Trade_Partner_Name__c='test Trade',Package_Description__c='testProduct',W3_DOH__c=2,Vision_GCP_Update_Date__c ='2022-02-11');
        insert tradeDoH;
        GCP_DOH_Trade_Partner_NDC__c ndcDOH = new  GCP_DOH_Trade_Partner_NDC__c(vision_gcp_trade_partner_name__c ='test');
        insert ndcDOH;
        List<GCP_DOH_Trade_Partner_NDC__c> ndcList = new List<GCP_DOH_Trade_Partner_NDC__c>{ndcDOH};
            
            
            doh_report_dates_info__c dohRepinfo = new  doh_report_dates_info__c(Vision_Update_Date__c ='2022-02-11', Name='Test');
        insert dohRepinfo;
        string customer = 'test';
        List<String> productType=new List<String> {}; 
        test.startTest();
        Vision_Outlook_DoH_Report.getDoHRecords('bhavdeep');
        Vision_Outlook_DoH_Report.getAccountGroups();
        test.stopTest();
    }

}