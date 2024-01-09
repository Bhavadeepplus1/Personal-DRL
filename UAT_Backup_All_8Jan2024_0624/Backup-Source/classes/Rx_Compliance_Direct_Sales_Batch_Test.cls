@isTest
public class Rx_Compliance_Direct_Sales_Batch_Test {
    static testMethod void setup(){
        Test.startTest();
        List<GCP_SFDC_Direct_Sales__c> directSalesList = new List<GCP_SFDC_Direct_Sales__c>();
        // March Month
        GCP_SFDC_Direct_Sales__c directSalesA1 = new GCP_SFDC_Direct_Sales__c(Vision_Posting_Month__c='4',Vision_Quantity__c='10', Vision_Month__c='Mar 21', Vision_Net_Dollar__c= '1000', 
                                                                            Vision_Quantity_in_Units__c='100',Vision_Customer_Hierarchy__c='154328',Vision_SAP_Material__c= '300000904', 
                                                                            Vision_Agreement_No__c = '1000000691',Vision_Billing_Date__c='02-03-2021');
        GCP_SFDC_Direct_Sales__c directSalesA2 = new GCP_SFDC_Direct_Sales__c(Vision_Posting_Month__c='3',Vision_Quantity__c='10', Vision_Month__c='Mar 21', Vision_Net_Dollar__c= '1000', 
                                                                            Vision_Quantity_in_Units__c='100',Vision_Customer_Hierarchy__c='154328',Vision_SAP_Material__c= '300028872', 
                                                                            Vision_Agreement_No__c = '1000000691',Vision_Billing_Date__c='11-03-2021');
        GCP_SFDC_Direct_Sales__c directSalesA3 = new GCP_SFDC_Direct_Sales__c(Vision_Posting_Month__c='3',Vision_Quantity__c='10', Vision_Month__c='Mar 21', Vision_Net_Dollar__c= '1000', 
                                                                             Vision_Quantity_in_Units__c='100',Vision_Customer_Hierarchy__c='154328',Vision_SAP_Material__c= '300032174', 
                                                                             Vision_Agreement_No__c = '1000000691',Vision_Billing_Date__c='23-03-2021');
        GCP_SFDC_Direct_Sales__c directSalesA4 = new GCP_SFDC_Direct_Sales__c(Vision_Posting_Month__c='3',Vision_Quantity__c='10', Vision_Month__c='Mar 21', Vision_Net_Dollar__c= '1000', 
                                                                             Vision_Quantity_in_Units__c='100',Vision_Customer_Hierarchy__c='154328',Vision_SAP_Material__c= '300011450', 
                                                                             Vision_Agreement_No__c = '1000000691',Vision_Billing_Date__c='29-03-2021');
        // March Month null data
        GCP_SFDC_Direct_Sales__c directSalesAA1 = new GCP_SFDC_Direct_Sales__c(Vision_Posting_Month__c='3',Vision_Quantity__c=null, Vision_Month__c='Mar 21', Vision_Net_Dollar__c= null, 
                                                                            Vision_Quantity_in_Units__c=null,Vision_Customer_Hierarchy__c='154328',Vision_SAP_Material__c= '300000904', 
                                                                            Vision_Agreement_No__c = '1000000691',Vision_Billing_Date__c='02-03-2021');
        GCP_SFDC_Direct_Sales__c directSalesAA2 = new GCP_SFDC_Direct_Sales__c(Vision_Posting_Month__c='3',Vision_Quantity__c=null, Vision_Month__c='Mar 21', Vision_Net_Dollar__c= null, 
                                                                            Vision_Quantity_in_Units__c=null,Vision_Customer_Hierarchy__c='154328',Vision_SAP_Material__c= '300028872', 
                                                                            Vision_Agreement_No__c = '1000000691',Vision_Billing_Date__c='11-03-2021');
        GCP_SFDC_Direct_Sales__c directSalesAA3 = new GCP_SFDC_Direct_Sales__c(Vision_Posting_Month__c='3',Vision_Quantity__c=null, Vision_Month__c='Mar 21', Vision_Net_Dollar__c= null, 
                                                                            Vision_Quantity_in_Units__c=null,Vision_Customer_Hierarchy__c='154328',Vision_SAP_Material__c= '300032174', 
                                                                             Vision_Agreement_No__c = '1000000691',Vision_Billing_Date__c='23-03-2021');
        GCP_SFDC_Direct_Sales__c directSalesAA4 = new GCP_SFDC_Direct_Sales__c(Vision_Posting_Month__c='3',Vision_Quantity__c=null, Vision_Month__c='Mar 21', Vision_Net_Dollar__c= null, 
                                                                            Vision_Quantity_in_Units__c=null,Vision_Customer_Hierarchy__c='154328',Vision_SAP_Material__c= '300011450', 
                                                                             Vision_Agreement_No__c = '1000000691',Vision_Billing_Date__c='29-03-2021');
        // Feb Month Data
        GCP_SFDC_Direct_Sales__c directSalesB1 = new GCP_SFDC_Direct_Sales__c(Vision_Posting_Month__c='2',Vision_Quantity__c='10', Vision_Month__c='Feb 21', Vision_Net_Dollar__c= '1000', 
                                                                            Vision_Quantity_in_Units__c='100',Vision_Customer_Hierarchy__c='154328',Vision_SAP_Material__c= '300000904', 
                                                                            Vision_Agreement_No__c = '1000000691',Vision_Billing_Date__c='02-02-2021');
        GCP_SFDC_Direct_Sales__c directSalesB2 = new GCP_SFDC_Direct_Sales__c(Vision_Posting_Month__c='2',Vision_Quantity__c='10', Vision_Month__c='Feb 21', Vision_Net_Dollar__c= '1000', 
                                                                            Vision_Quantity_in_Units__c='100',Vision_Customer_Hierarchy__c='154328',Vision_SAP_Material__c= '300028872', 
                                                                            Vision_Agreement_No__c = '1000000691',Vision_Billing_Date__c='11-02-2021');
        GCP_SFDC_Direct_Sales__c directSalesB3 = new GCP_SFDC_Direct_Sales__c(Vision_Posting_Month__c='2',Vision_Quantity__c='10', Vision_Month__c='Feb 21', Vision_Net_Dollar__c= '1000', 
                                                                             Vision_Quantity_in_Units__c='100',Vision_Customer_Hierarchy__c='154328',Vision_SAP_Material__c= '300032174', 
                                                                             Vision_Agreement_No__c = '1000000691',Vision_Billing_Date__c='23-02-2021');
        GCP_SFDC_Direct_Sales__c directSalesB4 = new GCP_SFDC_Direct_Sales__c(Vision_Posting_Month__c='2',Vision_Quantity__c='10', Vision_Month__c='Feb 21', Vision_Net_Dollar__c= '1000', 
                                                                             Vision_Quantity_in_Units__c='100',Vision_Customer_Hierarchy__c='154328',Vision_SAP_Material__c= '300011450', 
                                                                             Vision_Agreement_No__c = '1000000691',Vision_Billing_Date__c='27-02-2021');
        // Feb Month null data
        GCP_SFDC_Direct_Sales__c directSalesBB1 = new GCP_SFDC_Direct_Sales__c(Vision_Posting_Month__c='2',Vision_Quantity__c=null, Vision_Month__c='Feb 21', Vision_Net_Dollar__c= null, 
                                                                            Vision_Quantity_in_Units__c=null,Vision_Customer_Hierarchy__c='154328',Vision_SAP_Material__c= '300000904', 
                                                                            Vision_Agreement_No__c = '1000000691',Vision_Billing_Date__c='03-02-2021');
        GCP_SFDC_Direct_Sales__c directSalesBB2 = new GCP_SFDC_Direct_Sales__c(Vision_Posting_Month__c='2',Vision_Quantity__c=null, Vision_Month__c='Feb 21', Vision_Net_Dollar__c= null, 
                                                                            Vision_Quantity_in_Units__c=null,Vision_Customer_Hierarchy__c='154328',Vision_SAP_Material__c= '300000904', 
                                                                            Vision_Agreement_No__c = '1000000691',Vision_Billing_Date__c='10-02-2021');
        GCP_SFDC_Direct_Sales__c directSalesBB3 = new GCP_SFDC_Direct_Sales__c(Vision_Posting_Month__c='2',Vision_Quantity__c=null, Vision_Month__c='Feb 21', Vision_Net_Dollar__c= null, 
                                                                            Vision_Quantity_in_Units__c=null,Vision_Customer_Hierarchy__c='154328',Vision_SAP_Material__c= '300000904', 
                                                                            Vision_Agreement_No__c = '1000000691',Vision_Billing_Date__c='17-02-2021');
        GCP_SFDC_Direct_Sales__c directSalesBB4 = new GCP_SFDC_Direct_Sales__c(Vision_Posting_Month__c='2',Vision_Quantity__c=null, Vision_Month__c='Feb 21',Vision_Net_Dollar__c= null, 
                                                                            Vision_Quantity_in_Units__c=null,Vision_Customer_Hierarchy__c='154328',Vision_SAP_Material__c= '300000904', 
                                                                            Vision_Agreement_No__c = '1000000691',Vision_Billing_Date__c='28-02-2021');
        
        // Jan Month Data
        GCP_SFDC_Direct_Sales__c directSalesC1 = new GCP_SFDC_Direct_Sales__c(Vision_Posting_Month__c='1',Vision_Quantity__c='10', Vision_Month__c='Jan 21', Vision_Net_Dollar__c= '1000', 
                                                                            Vision_Quantity_in_Units__c='100',Vision_Customer_Hierarchy__c='154328',Vision_SAP_Material__c= '300000904', 
                                                                            Vision_Agreement_No__c = '1000000691',Vision_Billing_Date__c='02-01-2021');
        GCP_SFDC_Direct_Sales__c directSalesC2 = new GCP_SFDC_Direct_Sales__c(Vision_Posting_Month__c='1',Vision_Quantity__c='10', Vision_Month__c='Jan 21', Vision_Net_Dollar__c= '1000', 
                                                                            Vision_Quantity_in_Units__c='100',Vision_Customer_Hierarchy__c='154328',Vision_SAP_Material__c= '300028872', 
                                                                            Vision_Agreement_No__c = '1000000691',Vision_Billing_Date__c='11-01-2021');
        GCP_SFDC_Direct_Sales__c directSalesC3 = new GCP_SFDC_Direct_Sales__c(Vision_Posting_Month__c='1',Vision_Quantity__c='10', Vision_Month__c='Jan 21', Vision_Net_Dollar__c= '1000', 
                                                                             Vision_Quantity_in_Units__c='100',Vision_Customer_Hierarchy__c='154328',Vision_SAP_Material__c= '300032174', 
                                                                             Vision_Agreement_No__c = '1000000691',Vision_Billing_Date__c='23-01-2021');
        GCP_SFDC_Direct_Sales__c directSalesC4 = new GCP_SFDC_Direct_Sales__c(Vision_Posting_Month__c='1',Vision_Quantity__c='10', Vision_Month__c='Jan 21', Vision_Net_Dollar__c= '1000', 
                                                                             Vision_Quantity_in_Units__c='100',Vision_Customer_Hierarchy__c='154328',Vision_SAP_Material__c= '300011450', 
                                                                             Vision_Agreement_No__c = '1000000691',Vision_Billing_Date__c='27-01-2021');
        // Jan Month null data
        GCP_SFDC_Direct_Sales__c directSalesCC1 = new GCP_SFDC_Direct_Sales__c(Vision_Posting_Month__c='1',Vision_Quantity__c=null, Vision_Month__c='Jan 21', Vision_Net_Dollar__c= null, 
                                                                            Vision_Quantity_in_Units__c=null,Vision_Customer_Hierarchy__c='154328',Vision_SAP_Material__c= '300000904', 
                                                                            Vision_Agreement_No__c = '1000000691',Vision_Billing_Date__c='03-01-2021');
        GCP_SFDC_Direct_Sales__c directSalesCC2 = new GCP_SFDC_Direct_Sales__c(Vision_Posting_Month__c='1',Vision_Quantity__c=null, Vision_Month__c='Jan 21', Vision_Net_Dollar__c= null, 
                                                                            Vision_Quantity_in_Units__c=null,Vision_Customer_Hierarchy__c='154328',Vision_SAP_Material__c= '300000904', 
                                                                            Vision_Agreement_No__c = '1000000691',Vision_Billing_Date__c='10-01-2021');
        GCP_SFDC_Direct_Sales__c directSalesCC3 = new GCP_SFDC_Direct_Sales__c(Vision_Posting_Month__c='1',Vision_Quantity__c=null, Vision_Month__c='Jan 21', Vision_Net_Dollar__c= null, 
                                                                            Vision_Quantity_in_Units__c=null,Vision_Customer_Hierarchy__c='154328',Vision_SAP_Material__c= '300000904', 
                                                                            Vision_Agreement_No__c = '1000000691',Vision_Billing_Date__c='17-01-2021');
        GCP_SFDC_Direct_Sales__c directSalesCC4 = new GCP_SFDC_Direct_Sales__c(Vision_Posting_Month__c='1',Vision_Quantity__c=null, Vision_Month__c='Jan 21',Vision_Net_Dollar__c= null, 
                                                                            Vision_Quantity_in_Units__c=null,Vision_Customer_Hierarchy__c='154328',Vision_SAP_Material__c= '300000904', 
                                                                            Vision_Agreement_No__c = '1000000691',Vision_Billing_Date__c='28-01-2021');
        
        // Dec Month Data
        GCP_SFDC_Direct_Sales__c directSalesD1 = new GCP_SFDC_Direct_Sales__c(Vision_Posting_Month__c='12',Vision_Quantity__c='10', Vision_Month__c='Dec 21', Vision_Net_Dollar__c= '1000', 
                                                                            Vision_Quantity_in_Units__c='100',Vision_Customer_Hierarchy__c='154328',Vision_SAP_Material__c= '300000904', 
                                                                            Vision_Agreement_No__c = '1000000691',Vision_Billing_Date__c='02-12-2021');
        GCP_SFDC_Direct_Sales__c directSalesD2 = new GCP_SFDC_Direct_Sales__c(Vision_Posting_Month__c='12',Vision_Quantity__c='10', Vision_Month__c='Dec 21', Vision_Net_Dollar__c= '1000', 
                                                                            Vision_Quantity_in_Units__c='100',Vision_Customer_Hierarchy__c='154328',Vision_SAP_Material__c= '300028872', 
                                                                            Vision_Agreement_No__c = '1000000691',Vision_Billing_Date__c='11-12-2021');
        GCP_SFDC_Direct_Sales__c directSalesD3 = new GCP_SFDC_Direct_Sales__c(Vision_Posting_Month__c='12',Vision_Quantity__c='10', Vision_Month__c='Dec 21', Vision_Net_Dollar__c= '1000', 
                                                                             Vision_Quantity_in_Units__c='100',Vision_Customer_Hierarchy__c='154328',Vision_SAP_Material__c= '300032174', 
                                                                             Vision_Agreement_No__c = '1000000691',Vision_Billing_Date__c='23-12-2021');
        GCP_SFDC_Direct_Sales__c directSalesD4 = new GCP_SFDC_Direct_Sales__c(Vision_Posting_Month__c='12',Vision_Quantity__c='10', Vision_Month__c='Dec 21', Vision_Net_Dollar__c= '1000', 
                                                                             Vision_Quantity_in_Units__c='100',Vision_Customer_Hierarchy__c='154328',Vision_SAP_Material__c= '300011450', 
                                                                             Vision_Agreement_No__c = '1000000691',Vision_Billing_Date__c='27-12-2021');
        // Dec Month null data
        GCP_SFDC_Direct_Sales__c directSalesDD1 = new GCP_SFDC_Direct_Sales__c(Vision_Posting_Month__c='12',Vision_Quantity__c=null, Vision_Month__c='Dec 21', Vision_Net_Dollar__c= null, 
                                                                            Vision_Quantity_in_Units__c=null,Vision_Customer_Hierarchy__c='154328',Vision_SAP_Material__c= '300000904', 
                                                                            Vision_Agreement_No__c = '1000000691',Vision_Billing_Date__c='03-12-2021');
        GCP_SFDC_Direct_Sales__c directSalesDD2 = new GCP_SFDC_Direct_Sales__c(Vision_Posting_Month__c='12',Vision_Quantity__c=null, Vision_Month__c='Dec 21', Vision_Net_Dollar__c= null, 
                                                                            Vision_Quantity_in_Units__c=null,Vision_Customer_Hierarchy__c='154328',Vision_SAP_Material__c= '300000904', 
                                                                            Vision_Agreement_No__c = '1000000691',Vision_Billing_Date__c='10-12-2021');
        GCP_SFDC_Direct_Sales__c directSalesDD3 = new GCP_SFDC_Direct_Sales__c(Vision_Posting_Month__c='12',Vision_Quantity__c=null, Vision_Month__c='Dec 21', Vision_Net_Dollar__c= null, 
                                                                            Vision_Quantity_in_Units__c=null,Vision_Customer_Hierarchy__c='154328',Vision_SAP_Material__c= '300000904', 
                                                                            Vision_Agreement_No__c = '1000000691',Vision_Billing_Date__c='17-12-2021');
        GCP_SFDC_Direct_Sales__c directSalesDD4 = new GCP_SFDC_Direct_Sales__c(Vision_Posting_Month__c='12',Vision_Quantity__c=null, Vision_Month__c='Dec 21',Vision_Net_Dollar__c= null, 
                                                                            Vision_Quantity_in_Units__c=null,Vision_Customer_Hierarchy__c='154328',Vision_SAP_Material__c= '300000904', 
                                                                            Vision_Agreement_No__c = '1000000691',Vision_Billing_Date__c='28-12-2021');
        // Nov Month Data
        GCP_SFDC_Direct_Sales__c directSalesE1 = new GCP_SFDC_Direct_Sales__c(Vision_Posting_Month__c='11',Vision_Quantity__c='10', Vision_Month__c='Nov 21', Vision_Net_Dollar__c= '1000', 
                                                                            Vision_Quantity_in_Units__c='100',Vision_Customer_Hierarchy__c='154328',Vision_SAP_Material__c= '300000904', 
                                                                            Vision_Agreement_No__c = '1000000691',Vision_Billing_Date__c='02-11-2021');
        GCP_SFDC_Direct_Sales__c directSalesE2 = new GCP_SFDC_Direct_Sales__c(Vision_Posting_Month__c='11',Vision_Quantity__c='10', Vision_Month__c='Nov 21', Vision_Net_Dollar__c= '1000', 
                                                                            Vision_Quantity_in_Units__c='100',Vision_Customer_Hierarchy__c='154328',Vision_SAP_Material__c= '300028872', 
                                                                            Vision_Agreement_No__c = '1000000691',Vision_Billing_Date__c='11-11-2021');
        GCP_SFDC_Direct_Sales__c directSalesE3 = new GCP_SFDC_Direct_Sales__c(Vision_Posting_Month__c='11',Vision_Quantity__c='10', Vision_Month__c='Nov 21', Vision_Net_Dollar__c= '1000', 
                                                                             Vision_Quantity_in_Units__c='100',Vision_Customer_Hierarchy__c='154328',Vision_SAP_Material__c= '300032174', 
                                                                             Vision_Agreement_No__c = '1000000691',Vision_Billing_Date__c='23-11-2021');
        GCP_SFDC_Direct_Sales__c directSalesE4 = new GCP_SFDC_Direct_Sales__c(Vision_Posting_Month__c='11',Vision_Quantity__c='10', Vision_Month__c='Nov 21', Vision_Net_Dollar__c= '1000', 
                                                                             Vision_Quantity_in_Units__c='100',Vision_Customer_Hierarchy__c='154328',Vision_SAP_Material__c= '300011450', 
                                                                             Vision_Agreement_No__c = '1000000691',Vision_Billing_Date__c='27-11-2021');
        // Nov Month null data
        GCP_SFDC_Direct_Sales__c directSalesEE1 = new GCP_SFDC_Direct_Sales__c(Vision_Posting_Month__c='11',Vision_Quantity__c=null, Vision_Month__c='Nov 21', Vision_Net_Dollar__c= null, 
                                                                            Vision_Quantity_in_Units__c=null,Vision_Customer_Hierarchy__c='154328',Vision_SAP_Material__c= '300000904', 
                                                                            Vision_Agreement_No__c = '1000000691',Vision_Billing_Date__c='03-11-2021');
        GCP_SFDC_Direct_Sales__c directSalesEE2 = new GCP_SFDC_Direct_Sales__c(Vision_Posting_Month__c='11',Vision_Quantity__c=null, Vision_Month__c='Nov 21', Vision_Net_Dollar__c= null, 
                                                                            Vision_Quantity_in_Units__c=null,Vision_Customer_Hierarchy__c='154328',Vision_SAP_Material__c= '300000904', 
                                                                            Vision_Agreement_No__c = '1000000691',Vision_Billing_Date__c='10-11-2021');
        GCP_SFDC_Direct_Sales__c directSalesEE3 = new GCP_SFDC_Direct_Sales__c(Vision_Posting_Month__c='11',Vision_Quantity__c=null, Vision_Month__c='Nov 21', Vision_Net_Dollar__c= null, 
                                                                            Vision_Quantity_in_Units__c=null,Vision_Customer_Hierarchy__c='154328',Vision_SAP_Material__c= '300000904', 
                                                                            Vision_Agreement_No__c = '1000000691',Vision_Billing_Date__c='17-11-2021');
        GCP_SFDC_Direct_Sales__c directSalesEE4 = new GCP_SFDC_Direct_Sales__c(Vision_Posting_Month__c='11',Vision_Quantity__c=null, Vision_Month__c='Nov 21',Vision_Net_Dollar__c= null, 
                                                                            Vision_Quantity_in_Units__c=null,Vision_Customer_Hierarchy__c='154328',Vision_SAP_Material__c= '300000904', 
                                                                            Vision_Agreement_No__c = '1000000691',Vision_Billing_Date__c='28-11-2021');
        // Oct Month Data
        GCP_SFDC_Direct_Sales__c directSalesF1 = new GCP_SFDC_Direct_Sales__c(Vision_Posting_Month__c='10',Vision_Quantity__c='10', Vision_Month__c='Oct 21', Vision_Net_Dollar__c= '1000', 
                                                                            Vision_Quantity_in_Units__c='100',Vision_Customer_Hierarchy__c='154328',Vision_SAP_Material__c= '300000904', 
                                                                            Vision_Agreement_No__c = '1000000691',Vision_Billing_Date__c='02-10-2021');
        GCP_SFDC_Direct_Sales__c directSalesF2 = new GCP_SFDC_Direct_Sales__c(Vision_Posting_Month__c='10',Vision_Quantity__c='10', Vision_Month__c='Oct 21', Vision_Net_Dollar__c= '1000', 
                                                                            Vision_Quantity_in_Units__c='100',Vision_Customer_Hierarchy__c='154328',Vision_SAP_Material__c= '300028872', 
                                                                            Vision_Agreement_No__c = '1000000691',Vision_Billing_Date__c='11-10-2021');
        GCP_SFDC_Direct_Sales__c directSalesF3 = new GCP_SFDC_Direct_Sales__c(Vision_Posting_Month__c='10',Vision_Quantity__c='10', Vision_Month__c='Oct 21', Vision_Net_Dollar__c= '1000', 
                                                                             Vision_Quantity_in_Units__c='100',Vision_Customer_Hierarchy__c='154328',Vision_SAP_Material__c= '300032174', 
                                                                             Vision_Agreement_No__c = '1000000691',Vision_Billing_Date__c='23-10-2021');
        GCP_SFDC_Direct_Sales__c directSalesF4 = new GCP_SFDC_Direct_Sales__c(Vision_Posting_Month__c='10',Vision_Quantity__c='10', Vision_Month__c='Oct 21', Vision_Net_Dollar__c= '1000', 
                                                                             Vision_Quantity_in_Units__c='100',Vision_Customer_Hierarchy__c='154328',Vision_SAP_Material__c= '300011450', 
                                                                             Vision_Agreement_No__c = '1000000691',Vision_Billing_Date__c='27-10-2021');
        // Oct Month null data
        GCP_SFDC_Direct_Sales__c directSalesFF1 = new GCP_SFDC_Direct_Sales__c(Vision_Posting_Month__c='10',Vision_Quantity__c=null, Vision_Month__c='Oct 21', Vision_Net_Dollar__c= null, 
                                                                            Vision_Quantity_in_Units__c=null,Vision_Customer_Hierarchy__c='154328',Vision_SAP_Material__c= '300000904', 
                                                                            Vision_Agreement_No__c = '1000000691',Vision_Billing_Date__c='03-10-2021');
        GCP_SFDC_Direct_Sales__c directSalesFF2 = new GCP_SFDC_Direct_Sales__c(Vision_Posting_Month__c='10',Vision_Quantity__c=null, Vision_Month__c='Oct 21', Vision_Net_Dollar__c= null, 
                                                                            Vision_Quantity_in_Units__c=null,Vision_Customer_Hierarchy__c='154328',Vision_SAP_Material__c= '300000904', 
                                                                            Vision_Agreement_No__c = '1000000691',Vision_Billing_Date__c='10-10-2021');
        GCP_SFDC_Direct_Sales__c directSalesFF3 = new GCP_SFDC_Direct_Sales__c(Vision_Posting_Month__c='10',Vision_Quantity__c=null, Vision_Month__c='Oct 21', Vision_Net_Dollar__c= null, 
                                                                            Vision_Quantity_in_Units__c=null,Vision_Customer_Hierarchy__c='154328',Vision_SAP_Material__c= '300000904', 
                                                                            Vision_Agreement_No__c = '1000000691',Vision_Billing_Date__c='17-10-2021');
        GCP_SFDC_Direct_Sales__c directSalesFF4 = new GCP_SFDC_Direct_Sales__c(Vision_Posting_Month__c='10',Vision_Quantity__c=null, Vision_Month__c='Oct 21',Vision_Net_Dollar__c= null, 
                                                                            Vision_Quantity_in_Units__c=null,Vision_Customer_Hierarchy__c='154328',Vision_SAP_Material__c= '300000904', 
                                                                            Vision_Agreement_No__c = '1000000691',Vision_Billing_Date__c='28-10-2021');
        // Sep Month Data
        GCP_SFDC_Direct_Sales__c directSalesG1 = new GCP_SFDC_Direct_Sales__c(Vision_Posting_Month__c='9',Vision_Quantity__c='10', Vision_Month__c='Sep 21', Vision_Net_Dollar__c= '1000', 
                                                                            Vision_Quantity_in_Units__c='100',Vision_Customer_Hierarchy__c='154328',Vision_SAP_Material__c= '300000904', 
                                                                            Vision_Agreement_No__c = '1000000691',Vision_Billing_Date__c='02-09-2021');
        GCP_SFDC_Direct_Sales__c directSalesG2 = new GCP_SFDC_Direct_Sales__c(Vision_Posting_Month__c='9',Vision_Quantity__c='10', Vision_Month__c='Sep 21', Vision_Net_Dollar__c= '1000', 
                                                                            Vision_Quantity_in_Units__c='100',Vision_Customer_Hierarchy__c='154328',Vision_SAP_Material__c= '300028872', 
                                                                            Vision_Agreement_No__c = '1000000691',Vision_Billing_Date__c='11-09-2021');
        GCP_SFDC_Direct_Sales__c directSalesG3 = new GCP_SFDC_Direct_Sales__c(Vision_Posting_Month__c='9',Vision_Quantity__c='10', Vision_Month__c='Sep 21', Vision_Net_Dollar__c= '1000', 
                                                                             Vision_Quantity_in_Units__c='100',Vision_Customer_Hierarchy__c='154328',Vision_SAP_Material__c= '300032174', 
                                                                             Vision_Agreement_No__c = '1000000691',Vision_Billing_Date__c='23-09-2021');
        GCP_SFDC_Direct_Sales__c directSalesG4 = new GCP_SFDC_Direct_Sales__c(Vision_Posting_Month__c='9',Vision_Quantity__c='10', Vision_Month__c='Sep 21', Vision_Net_Dollar__c= '1000', 
                                                                             Vision_Quantity_in_Units__c='100',Vision_Customer_Hierarchy__c='154328',Vision_SAP_Material__c= '300011450', 
                                                                             Vision_Agreement_No__c = '1000000691',Vision_Billing_Date__c='27-09-2021');
        // Sep Month null data
        GCP_SFDC_Direct_Sales__c directSalesGG1 = new GCP_SFDC_Direct_Sales__c(Vision_Posting_Month__c='4',Vision_Quantity__c=null, Vision_Month__c='Sep 21', Vision_Net_Dollar__c= null, 
                                                                            Vision_Quantity_in_Units__c=null,Vision_Customer_Hierarchy__c='154328',Vision_SAP_Material__c= '300000904', 
                                                                            Vision_Agreement_No__c = '1000000691',Vision_Billing_Date__c='03-09-2021');
        GCP_SFDC_Direct_Sales__c directSalesGG2 = new GCP_SFDC_Direct_Sales__c(Vision_Posting_Month__c='4',Vision_Quantity__c=null, Vision_Month__c='Sep 21', Vision_Net_Dollar__c= null, 
                                                                            Vision_Quantity_in_Units__c=null,Vision_Customer_Hierarchy__c='154328',Vision_SAP_Material__c= '300000904', 
                                                                            Vision_Agreement_No__c = '1000000691',Vision_Billing_Date__c='10-09-2021');
        GCP_SFDC_Direct_Sales__c directSalesGG3 = new GCP_SFDC_Direct_Sales__c(Vision_Posting_Month__c='4',Vision_Quantity__c=null, Vision_Month__c='Sep 21', Vision_Net_Dollar__c= null, 
                                                                            Vision_Quantity_in_Units__c=null,Vision_Customer_Hierarchy__c='154328',Vision_SAP_Material__c= '300000904', 
                                                                            Vision_Agreement_No__c = '1000000691',Vision_Billing_Date__c='17-09-2021');
        GCP_SFDC_Direct_Sales__c directSalesGG4 = new GCP_SFDC_Direct_Sales__c(Vision_Posting_Month__c='4',Vision_Quantity__c=null, Vision_Month__c='Sep 21',Vision_Net_Dollar__c= null, 
                                                                            Vision_Quantity_in_Units__c=null,Vision_Customer_Hierarchy__c='154328',Vision_SAP_Material__c= '300000904', 
                                                                            Vision_Agreement_No__c = '1000000691',Vision_Billing_Date__c='28-09-2021');
        
        // August Month Data
        GCP_SFDC_Direct_Sales__c directSalesH1 = new GCP_SFDC_Direct_Sales__c(Vision_Posting_Month__c='4',Vision_Quantity__c='10', Vision_Month__c='Aug 21', Vision_Net_Dollar__c= '1000', 
                                                                            Vision_Quantity_in_Units__c='100',Vision_Customer_Hierarchy__c='154328',Vision_SAP_Material__c= '300000904', 
                                                                            Vision_Agreement_No__c = '1000000691',Vision_Billing_Date__c='02-08-2021');
        GCP_SFDC_Direct_Sales__c directSalesH2 = new GCP_SFDC_Direct_Sales__c(Vision_Posting_Month__c='4',Vision_Quantity__c='10', Vision_Month__c='Aug 21', Vision_Net_Dollar__c= '1000', 
                                                                            Vision_Quantity_in_Units__c='100',Vision_Customer_Hierarchy__c='154328',Vision_SAP_Material__c= '300028872', 
                                                                            Vision_Agreement_No__c = '1000000691',Vision_Billing_Date__c='11-08-2021');
        GCP_SFDC_Direct_Sales__c directSalesH3 = new GCP_SFDC_Direct_Sales__c(Vision_Posting_Month__c='4',Vision_Quantity__c='10', Vision_Month__c='Aug 21', Vision_Net_Dollar__c= '1000', 
                                                                             Vision_Quantity_in_Units__c='100',Vision_Customer_Hierarchy__c='154328',Vision_SAP_Material__c= '300032174', 
                                                                             Vision_Agreement_No__c = '1000000691',Vision_Billing_Date__c='23-08-2021');
        GCP_SFDC_Direct_Sales__c directSalesH4 = new GCP_SFDC_Direct_Sales__c(Vision_Posting_Month__c='4',Vision_Quantity__c='10', Vision_Month__c='Aug 21', Vision_Net_Dollar__c= '1000', 
                                                                             Vision_Quantity_in_Units__c='100',Vision_Customer_Hierarchy__c='154328',Vision_SAP_Material__c= '300011450', 
                                                                             Vision_Agreement_No__c = '1000000691',Vision_Billing_Date__c='27-08-2021');
        // August Month null data
        GCP_SFDC_Direct_Sales__c directSalesHH1 = new GCP_SFDC_Direct_Sales__c(Vision_Posting_Month__c='4',Vision_Quantity__c=null, Vision_Month__c='Sep 21', Vision_Net_Dollar__c= null, 
                                                                            Vision_Quantity_in_Units__c=null,Vision_Customer_Hierarchy__c='154328',Vision_SAP_Material__c= '300000904', 
                                                                            Vision_Agreement_No__c = '1000000691',Vision_Billing_Date__c='03-09-2021');
        GCP_SFDC_Direct_Sales__c directSalesHH2 = new GCP_SFDC_Direct_Sales__c(Vision_Posting_Month__c='4',Vision_Quantity__c=null, Vision_Month__c='Sep 21', Vision_Net_Dollar__c= null, 
                                                                            Vision_Quantity_in_Units__c=null,Vision_Customer_Hierarchy__c='154328',Vision_SAP_Material__c= '300000904', 
                                                                            Vision_Agreement_No__c = '1000000691',Vision_Billing_Date__c='10-09-2021');
        GCP_SFDC_Direct_Sales__c directSalesHH3 = new GCP_SFDC_Direct_Sales__c(Vision_Posting_Month__c='4',Vision_Quantity__c=null, Vision_Month__c='Sep 21', Vision_Net_Dollar__c= null, 
                                                                            Vision_Quantity_in_Units__c=null,Vision_Customer_Hierarchy__c='154328',Vision_SAP_Material__c= '300000904', 
                                                                            Vision_Agreement_No__c = '1000000691',Vision_Billing_Date__c='17-09-2021');
        GCP_SFDC_Direct_Sales__c directSalesHH4 = new GCP_SFDC_Direct_Sales__c(Vision_Posting_Month__c='4',Vision_Quantity__c=null, Vision_Month__c='Sep 21',Vision_Net_Dollar__c= null, 
                                                                            Vision_Quantity_in_Units__c=null,Vision_Customer_Hierarchy__c='154328',Vision_SAP_Material__c= '300000904', 
                                                                            Vision_Agreement_No__c = '1000000691',Vision_Billing_Date__c='28-09-2021');
        
        directSalesList.add(directSalesA1);
        directSalesList.add(directSalesA2);
        directSalesList.add(directSalesA3);
        directSalesList.add(directSalesA4);
        directSalesList.add(directSalesAA1);
        directSalesList.add(directSalesAA2);
        directSalesList.add(directSalesAA3);
        directSalesList.add(directSalesAA4);
        directSalesList.add(directSalesB1);
        directSalesList.add(directSalesB2);
        directSalesList.add(directSalesB3);
        directSalesList.add(directSalesB4);
        directSalesList.add(directSalesBB1);
        directSalesList.add(directSalesBB2);
        directSalesList.add(directSalesBB3);
        directSalesList.add(directSalesBB4);
        directSalesList.add(directSalesC1);
        directSalesList.add(directSalesC2);
        directSalesList.add(directSalesC3);
        directSalesList.add(directSalesC4);
        directSalesList.add(directSalesCC1);
        directSalesList.add(directSalesCC2);
        directSalesList.add(directSalesCC3);
        directSalesList.add(directSalesCC4);
        directSalesList.add(directSalesD1);
        directSalesList.add(directSalesD2);
        directSalesList.add(directSalesD3);
        directSalesList.add(directSalesD4);
        directSalesList.add(directSalesDD1);
        directSalesList.add(directSalesDD2);
        directSalesList.add(directSalesDD3);
        directSalesList.add(directSalesDD4);
        directSalesList.add(directSalesE1);
        directSalesList.add(directSalesE2);
        directSalesList.add(directSalesE3);
        directSalesList.add(directSalesE4);
        directSalesList.add(directSalesEE1);
        directSalesList.add(directSalesEE2);
        directSalesList.add(directSalesEE3);
        directSalesList.add(directSalesEE4);
        directSalesList.add(directSalesF1);
        directSalesList.add(directSalesF2);
        directSalesList.add(directSalesF3);
        directSalesList.add(directSalesF4);
        directSalesList.add(directSalesFF1);
        directSalesList.add(directSalesFF2);
        directSalesList.add(directSalesFF3);
        directSalesList.add(directSalesFF4);
        directSalesList.add(directSalesG1);
        directSalesList.add(directSalesG2);
        directSalesList.add(directSalesG3);
        directSalesList.add(directSalesG4);
        directSalesList.add(directSalesGG1);
        directSalesList.add(directSalesGG2);
        directSalesList.add(directSalesGG3);
        directSalesList.add(directSalesGG4);
        directSalesList.add(directSalesH1);
        directSalesList.add(directSalesH2);
        directSalesList.add(directSalesH3);
        directSalesList.add(directSalesH4);
        directSalesList.add(directSalesHH1);
        directSalesList.add(directSalesHH2);
        directSalesList.add(directSalesHH3);
        directSalesList.add(directSalesHH4);
        //directSalesList.add(directSales4);
        insert directSalesList;
        
        
        List<Account> Acclist = new  List<Account>();
        Account acc =new Account();
        acc.name='test';
        acc.AccountNumber = '154328';
        Acclist.add(acc);
        insert Acclist;
        // Phoenix Data
        List<Phoenix_Contract__c> Ctlist  = new List<Phoenix_Contract__c>();
        Phoenix_Contract__c ct = new Phoenix_Contract__c ();
        ct.Phoenix_Contract_Number__c='123456';
        ct.Phoenix_Contract_Start_Date__c=Date.newInstance(2022, 02, 21);
        ct.Phoenix_Contract_End_Date__c=system.today();
      
        ctlist.add(ct);
        insert ctlist;
        
        // Product Data
        list<Product2> plist = new list  < Product2>();
        
        Product2 p=new Product2();
        p.Name='abc pharma';
        p.Phoenix_NDC_11__c='23364848';
        p.ProductCode='300000904';
        p.Phoenix_NDC__c='5555555';
        p.Phoenix_GPI_Generic_Product_Identifier__c = '11111';
        p.Family = 'Test Family';
        p.Phoenix_Throughput_cost__c=10.23456576;
        p.Phoenix_GCN_Sequence_Number__c='666666';
        p.Phoenix_Pkg_Size__c=25.0;
        p.Vision_Is_CPT_Batch_Executed__c = false;
        p.Phoenix_Is_Exclude_Bid__c = false;
        p.IsActive=true;
        p.Phoenix_Rx_SRx_OTC__c = 'Rx';
        p.Description='my testing';
        
        Product2 p1=new Product2();
        p1.Name='abc pharma 2';
        p1.Phoenix_NDC_11__c='123364848';
        p1.ProductCode='300028872';
        p1.Phoenix_NDC__c='5555555';
        p1.Phoenix_GPI_Generic_Product_Identifier__c = '11111';
        p1.Family = 'Test Family';
        p1.Phoenix_Throughput_cost__c=10.23456576;
        p1.Phoenix_GCN_Sequence_Number__c='666666';
        p1.Phoenix_Pkg_Size__c=25.0;
        p1.Vision_Is_CPT_Batch_Executed__c = false;
        p1.Phoenix_Is_Exclude_Bid__c = false;
        p1.IsActive=true;
        p1.Phoenix_Rx_SRx_OTC__c = 'SRx';
        p1.Description='my testing';
      	plist.add(p1);
        insert plist;

        
        // NprData Data
        List<Phoenix_NPR_Data__c> nprdtlist = new  List<Phoenix_NPR_Data__c>();
        Phoenix_NPR_Data__c  npdata = new Phoenix_NPR_Data__c();
        npdata.Phoenix_12Months_Actual_Sales_Unit__c=20.00;
        npdata.Phoenix_12Months_Net_Sales__c=250.00;
        npdata.Phoenix_12Months_Sales_Unit__c=25.00;
        npdata.Phoenix_12Mt_Sales_Ut_Actual__c=22.0;
        npdata.Phoenix_Account__c=acc.Id;
        npdata.Phoenix_Contract__c=ct.Id;
        nprdtlist.add(npdata);
        insert nprdtlist;
        
  
        List<Vision_Customer_Product_Tracker__c> cpotlist= new List<Vision_Customer_Product_Tracker__c>();
        for ( Product2 pp:plist){
            Vision_Customer_Product_Tracker__c cpt = new Vision_Customer_Product_Tracker__c();
            cpt.Vision_Account__c=Acc.Id;
            cpt.Vision_Contract__c=ct.Id;
            cpt.Vision_NPR_Data__c=npdata.Id;
            cpt.Vision_Product__c=pp.Id;
            cpt.Vision_Product_Code__c='300028872';
            cpt.Vision_Contract_Number__c='123456';
            cpt.Vision_Customer_Code__c = '154328';
            cpt.Vision_Current_Product_Position__c = 'Testing Current Product Position';
            cpt.Vision_Contract_Type__c = 'Direct';
            cpt.Vision_Awarded_Volume__c = 25;
            cpt.Vision_Is_In_Awarded__c = true;
            cpotlist.add(cpt);
            Vision_Customer_Product_Tracker__c cpt1 = new Vision_Customer_Product_Tracker__c();
            cpt1.Vision_Account__c=Acc.Id;
            cpt.Vision_Contract__c=ct.Id;
            cpt1.Vision_NPR_Data__c=npdata.Id;
            cpt1.Vision_Product__c=pp.Id;
            cpt1.Vision_Product_Code__c='300028812';
            cpt1.Vision_Customer_Code__c = '154308';
            cpt1.Vision_Contract_Number__c='123456';
            cpt1.Vision_Contract_Type__c = 'Direct';
            cpt.Vision_Awarded_Volume__c = 75;
            cpt1.Vision_Current_Product_Position__c = 'Testing Current Product Position 1';
            cpt1.Vision_Is_In_Awarded__c = true;
            cpotlist.add(cpt1);
        }
        insert cpotlist;
        
        // Sample Rx Compliance Summary Records
        List<Rx_Compliance_Summary__c> insertionList = new List<Rx_Compliance_Summary__c>();
        Rx_Compliance_Summary__c summaryObj = new Rx_Compliance_Summary__c();
        summaryObj.Vision_Product__c = p.Id;
        summaryObj.Vision_Account__c = Acc.Id;
        summaryObj.Vision_Package_Size__c = p.Phoenix_Pkg_Size__c;
        summaryObj.M1_Direct_Quantity__c = 10;
        summaryObj.M2_Direct_Quantity__c = 15;
        summaryObj.Month1__c = 'Oct 22';
        summaryObj.Month2__c = 'Nov 22';
        summaryObj.Month3__c = 'Dec 22';
        summaryObj.Month3__c = 'Jan 22';
        summaryObj.Month3__c = 'Feb 22';
        summaryObj.Month3__c = 'Mar 22';
        //summaryObj.M2_Direct_Value_Compliance__c = 10;
        //summaryObj.M2_Indirect_Value_Compliance__c = 10;
        summaryObj.M1_Direct_Net_Dollar__c = 10000;
        summaryObj.Vision_Direct_Awarded_Qty__c = 50;
        //summaryObj.M2_Total_Compliance__c = 10;
        summaryObj.Vision_Direct_Awarded_Value__c = 0;
        //summaryObj.Vision_Direct_Awarded_Value_Monthly__c = 0;
        summaryObj.Vision_Indirect_Awarded_Value__c = 1772;
        //summaryObj.Vision_Indirect_Awarded_Value_Monthly__c = 148;
        //summaryObj.Vision_Total_Awarded_Value__c = 1772;
        //summaryObj.Vision_Total_Awarded_Value_Monthly__c = 148;
        summaryObj.Vision_Unique_Identifier__c = '154328-300028872';
        insertionList.add(summaryObj);
        Rx_Compliance_Summary__c summaryObj1 = new Rx_Compliance_Summary__c();
        summaryObj1.Vision_Product__c = p1.Id;
        summaryObj1.Vision_Account__c = Acc.Id;
        summaryObj1.Vision_Package_Size__c = p.Phoenix_Pkg_Size__c;
        summaryObj1.M1_Direct_Quantity__c = 10;
        summaryObj1.M2_Direct_Quantity__c = 15;
        summaryObj1.Month1__c = 'Oct 22';
        summaryObj1.Month2__c = 'Nov 22';
        summaryObj1.Month3__c = 'Dec 22';
        summaryObj1.Month3__c = 'Jan 22';
        summaryObj1.Month3__c = 'Feb 22';
        summaryObj1.Month3__c = 'Mar 22';
        //summaryObj.M2_Direct_Value_Compliance__c = 10;
        //summaryObj.M2_Indirect_Value_Compliance__c = 10;
        summaryObj1.M1_Direct_Net_Dollar__c = 10000;
        summaryObj1.Vision_Direct_Awarded_Qty__c = 50;
        //summaryObj.M2_Total_Compliance__c = 10;
        summaryObj1.Vision_Direct_Awarded_Value__c = 0;
        //summaryObj.Vision_Direct_Awarded_Value_Monthly__c = 0;
        summaryObj1.Vision_Indirect_Awarded_Value__c = 1772;
        //summaryObj.Vision_Indirect_Awarded_Value_Monthly__c = 148;
        //summaryObj.Vision_Total_Awarded_Value__c = 1772;
        //summaryObj.Vision_Total_Awarded_Value_Monthly__c = 148;
        summaryObj1.Vision_Unique_Identifier__c = '154158-300029072';
        insertionList.add(summaryObj1);
        upsert insertionList;
        Database.BatchableContext BC;
        Rx_Compliance_Direct_Sales_Summary_Batch salesSummary = new Rx_Compliance_Direct_Sales_Summary_Batch();
        salesSummary.start(BC);
        salesSummary.execute(BC, directSalesList);
        salesSummary.finish(BC);
        Test.stopTest();
    }
}