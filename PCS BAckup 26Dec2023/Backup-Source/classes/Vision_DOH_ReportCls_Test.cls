@isTest
public class Vision_DOH_ReportCls_Test {
    
    static testmethod void  test(){
        List<String> prodType = new List<String>{'Rx','SRx','OTC'};
            Account acc = new Account();
        acc.Name = 'Amazon'; 
        insert acc;
        Product2 prod = new Product2();
        prod.Name = 'Alloprinol';
        prod.Phoenix_Rx_SRx_OTC__c = 'Rx';
        insert prod;
        GCP_Trade_Partner_DOH_Report__c tradeDoH= new GCP_Trade_Partner_DOH_Report__c(Trade_Partner_Name__c='test Trade',Package_Description__c='testProduct',W3_DOH__c=2,Vision_Product__c=prod.Id);
        insert tradeDoH;
        doh_report_dates_info__c dohRepinfo = new  doh_report_dates_info__c(Vision_Update_Date__c ='2022-02-11', Name='Test');
        insert dohRepinfo;
        DoH_Summary__c dohSummary = new DoH_Summary__c();
        dohSummary.Name = 'Test';
        dohSummary.Trade_Partner_Name__c = acc.Id;
        insert dohSummary;
        Vision_DOH_ReportCls.getAccountGroups();
        Vision_DOH_ReportCls.getRxDoHData(prodType,'Amazon','Ama');
                Vision_DOH_ReportCls.getFilterDoHData('Amazon','Ama',prodType);
                Vision_DOH_ReportCls.getProdFamData('Amazon','Alloprinol');
                Vision_DOH_ReportCls.fetchSortResults('Package_Description__c',true,'Amazon','Ama');

    }
    
    
}