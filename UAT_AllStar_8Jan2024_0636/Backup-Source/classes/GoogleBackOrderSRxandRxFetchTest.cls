@istest
public class GoogleBackOrderSRxandRxFetchTest {
    static testmethod void setup(){
        Account A = new Account();
        a.name='Test';
        a.AccountNumber='11111';
        insert a;
        Account a1= new account();
        a1.name='test1';
        a1.AccountNumber=null;
        insert a1;
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
        insert p;
        GCP_Product_Family_Map__c gcpf= new GCP_Product_Family_Map__c();
        gcpf.SFDC_Product_Family__c='A';
        gcpf.GCP_Product_Family__c='A';
        insert gcpf;
        Vision_GCP_Backorder_SRx_Rx__c bosrx = new Vision_GCP_Backorder_SRx_Rx__c();
        bosrx.Vision_Anticipated_Date_of_Availability__c='24-06-2022';
        bosrx.Vision_Available_for_Dropship__c='yes';
        bosrx.Vision_Avg_unit_Price__c='25';
        bosrx.Vision_Back_Order_SKU_In_Transit__c='256';
        bosrx.Vision_Back_Order_Value__c=25000;
        bosrx.Vision_Backorder_Qty__c=250;
      //  bosrx.Vision_Date_Dispatched__c='jjj';
        bosrx.Vision_Manufacturer__c='phonenix';
        bosrx.Vision_GCP_Update_Date__c=Date.newInstance(2022, 02, 24);
        bosrx.Vision_ndc__c='25666';
        bosrx.Vision_SKU_Code__c='22222';
        bosrx.Vision_SKU_Description__c='ddff';
        bosrx.Vision_Product__c=p.id;
        bosrx.Vision_Total_in_Transit__c=250;
        insert bosrx;
        test.startTest();
        GoogleBackOrderSRxandRxFetch b = new GoogleBackOrderSRxandRxFetch();
        database.executeBatch(b);
         Database.executeBatch(new GoogleBackOrderSRxandRxFetch(5,4));
        test.stopTest();
        
        
        
    }
}