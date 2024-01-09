@istest
public class GoogleDOHTradePartnerNDCLevelFetchTest {
    
    static testmethod void setup(){
        List<Account> Acclist = new List<Account>();
        Account acc = new Account();
        acc.Name='test';
        Acclist.add(acc);
        Insert Acclist;
        list<Product2> plist = new list  < Product2>();
        
        Vision_GCP_Backorder_SRx_Rx__c data1 = new Vision_GCP_Backorder_SRx_Rx__c();
        data1.Vision_Sku_Code__c = '123566';
        insert data1;
        
        Vision_GCP_Backorder_OTC__c data2 = new Vision_GCP_Backorder_OTC__c();
        data2.Vision_Sku_Code__c = '123566';
        insert data2;
        
        Product2 p=new Product2();
        p.Name='abc pharma';
        p.Phoenix_NDC_11__c='4359834531';
        p.ProductCode='123566';
        p.Phoenix_NDC__c='4359834531';
        p.Phoenix_GPI_Generic_Product_Identifier__c = '11111';
        p.Family = 'Test Family';
        p.Phoenix_Throughput_cost__c=10.23456576;
        p.Phoenix_GCN_Sequence_Number__c='666666';
        p.Phoenix_Pkg_Size__c=25.0;
        p.IsActive = true;
        p.Phoenix_Is_Exclude_Bid__c = false;
        
        plist.add(p);
        insert plist;
        
        GCP_DOH_Trade_Partner_NDC__c obj = new GCP_DOH_Trade_Partner_NDC__c();
        obj.Product__c = p.id;
        //obj.Name = 'Deep';
        obj.vision_gcp_ndc__c = '4359834531';
        obj.vision_gcp_trade_partner_name__c = 'NORTH CAROLINA MUTUAL WHOLESALE DRUG CO';
        obj.Vision_GCP_Unique_Identifier__c = obj.vision_gcp_trade_partner_name__c + '_'+obj.vision_gcp_ndc__c;
        insert obj;
        
        test.startTest();
        Database.executeBatch(new GoogleDOHTradePartnerNDCLevelFetch(1,1));
        
        GoogleDOHTradePartnerNDCLevelFetch batch = new GoogleDOHTradePartnerNDCLevelFetch();
        batch.execute(null);
        Test.stopTest();
        
        

}
}