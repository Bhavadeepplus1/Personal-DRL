@istest
public class GoogleBackOrderOTCFetchTest {
    static testmethod void setup(){
        
        Account a= new Account();
        a.name='test';
        a.AccountNumber='123456';
        insert a;
        Account a1= new Account();
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
        Vision_GCP_Backorder_OTC__c borx = new Vision_GCP_Backorder_OTC__c();
        borx.Product_Family__c='A';
       // borx.Vision_Average_Forecast__c=23.0;
       // borx.Vision_Back_Order_Value__c=23;
        borx.Vision_Backorder_Qty__c=24;
        borx.Vision_Comments__c='test';
        borx.Vision_Backorder_Report_Date__c='2022-10-20';
       // borx.Vision_Count__c=24.00;
        borx.Vision_current_month__c='november';
        borx.Vision_Current_Month_Total_Monthly_Order__c='250';
       // borx.Vision_Current_Order_Qty__c=250;
       // borx.Vision_Gcp_Update_Date__c='23-02-2022';
        borx.Vision_last_month_forecast__c='errfc';
      //  borx.Vision_Order_Value__c=250;
        borx.Vision_MoH__c='active';
        borx.Vision_Sku_Code__c='12345';
        borx.Vision_Product__c=p.id;
        borx.Vision_Short_Term_Forecast__c='5322';
       // borx.Vision_Total_Open_Order_Qty__c=1253;
        borx.Vision_Unit_Sales_Value__c='123';
        insert borx;
        test.startTest();
        GoogleBackOrderOTCFetch b = new GoogleBackOrderOTCFetch();
        database.executeBatch(b);
         Database.executeBatch(new GoogleBackOrderOTCFetch(1,1));
        test.stopTest();
            
        
    }

}