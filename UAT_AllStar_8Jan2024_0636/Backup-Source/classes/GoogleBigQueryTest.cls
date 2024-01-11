@isTest
public class GoogleBigQueryTest {
    
    
    static testmethod void insertAll(){
        
        String projectId = 'nag-analytics';
        String datasetId = 'Test';
        String tableId = 'sfdc_market_tracker';
        String action = 'insertAll';
        
        Phoenix_GCP_Opportunity_Tracker__c gcp = new Phoenix_GCP_Opportunity_Tracker__c(
        Phoenix_product_family__c = 'Phoenix_product_family__c',
            GCP_Customer_Code_temp__c  = '12345',
            GCP_Unique_Identifier__c = 'Phoenix_product_family__c_12345'
        );
        insert gcp;
        List<Phoenix_GCP_Opportunity_Tracker__c > ord = new List<Phoenix_GCP_Opportunity_Tracker__c>{gcp};
        
        if (ord.size()>0) {
            // Setup connector
            GoogleBigQuery google = new GoogleBigQuery(projectId, datasetId, tableId);
            
            //
            GoogleBigQuery google2 = new GoogleBigQuery(projectId, datasetId);
            GoogleBigQuery google3 = new GoogleBigQuery(projectId);
            google3.isSuccess();
            //
            GoogleBigQuery.Payload insertAll = new GoogleBigQuery.Payload();
            insertAll.addObject(ord[0],action);
            
            //
            GoogleBigQuery.InsertAll insertAll2 = new GoogleBigQuery.InsertAll();
            insertAll2.addObject(ord[0]);
            //
            if (!google.process(insertAll,action)) {
                System.debug('Error: ' + google.getResponse());
            }
        }
        
               GoogleUiController.runBigQuerySql('SELECT product_family,customer_code,ims_mat_sales FROM Test.sfdc_market_tracker LIMIT 1');
        string s= '{ "kind": "bigquery#queryResponse", "schema": { "fields": [ { "name": "SAP_Part_Number", "type": "STRING", "mode": "NULLABLE" }, { "name": "Customer", "type": "STRING", "mode": "NULLABLE" }, { "name": "Family", "type": "STRING", "mode": "NULLABLE" }, { "name": "Pack_Size", "type": "STRING", "mode": "NULLABLE" }, { "name": "Description", "type": "STRING", "mode": "NULLABLE" }, { "name": "Month_1", "type": "STRING", "mode": "NULLABLE" }, { "name": "Month_2", "type": "STRING", "mode": "NULLABLE" }, { "name": "Month_3", "type": "STRING", "mode": "NULLABLE" }, { "name": "Month_4", "type": "STRING", "mode": "NULLABLE" }, { "name": "Month_5", "type": "STRING", "mode": "NULLABLE" }, { "name": "Month_6", "type": "STRING", "mode": "NULLABLE" }, { "name": "Month_7", "type": "STRING", "mode": "NULLABLE" }, { "name": "Month_8", "type": "STRING", "mode": "NULLABLE" }, { "name": "Month_9", "type": "STRING", "mode": "NULLABLE" }, { "name": "Forecast_Month_1", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "Forecast_Month_2", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "Forecast_Month_3", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "Forecast_Month_4", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "Forecast_Month_5", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "Forecast_Month_6", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "Forecast_Month_7", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "Forecast_Month_8", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "Forecast_Month_9", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "total_qty", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "FTO_Cost_dollar", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "M_1_short_date", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "M_1_potential_writeoff", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "M_1_writeoff_cost", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "M_2_short_date", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "M_2_potential_writeoff", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "M_2_writeoff_cost", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "M_3_short_date", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "M_3_potential_writeoff", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "M_3_writeoff_cost", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "M_4_short_date", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "M_4_potential_writeoff", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "M_4_writeoff_cost", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "M_5_short_date", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "M_5_potential_writeoff", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "M_5_writeoff_cost", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "M_6_short_date", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "M_6_potential_writeoff", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "M_6_writeoff_cost", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "M_7_short_date", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "M_7_potential_writeoff", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "M_7_writeoff_cost", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "M_8_short_date", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "M_8_potential_writeoff", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "M_8_writeoff_cost", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "M_9_short_date", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "M_9_potential_writeoff", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "M_9_writeoff_cost", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "Total_in_Units", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "Total_value_dollar", "type": "FLOAT", "mode": "NULLABLE" } ] }, "jobReference": { "projectId": "nag-analytics", "jobId": "job_g7pDCPqJnZ0o0G9JJAdJkwNCpkI3", "location": "asia-south1" }, "totalRows": "1", "rows": [ { "f": [ { "v": "300011866" }, { "v": "CONTROL LABEL" }, { "v": "OTC Fexo" }, { "v": "30" }, { "v": "DRL Control Fexo 24hr 180mg Tab 30ct Btl" }, { "v": "Jan" }, { "v": "Feb" }, { "v": "Mar" }, { "v": "Apr" }, { "v": "May" }, { "v": "Jun" }, { "v": "Jul" }, { "v": "Aug" }, { "v": "Sep" }, { "v": "50285.828" }, { "v": "50472.828" }, { "v": "49922.82800000001" }, { "v": "49479.82800000001" }, { "v": "49479.82800000001" }, { "v": "49479.82800000001" }, { "v": "48563.828" }, { "v": "48566.82800000001" }, { "v": "48566.82800000001" }, { "v": "81672.0" }, { "v": "1.526687703115239" }, { "v": "3072.0" }, { "v": "0.0" }, { "v": "0.0" }, { "v": "7896.0" }, { "v": "0.0" }, { "v": "0.0" }, { "v": null }, { "v": "0.0" }, { "v": "0.0" }, { "v": null }, { "v": "0.0" }, { "v": "0.0" }, { "v": null }, { "v": "0.0" }, { "v": "0.0" }, { "v": null }, { "v": "0.0" }, { "v": "0.0" }, { "v": "70416.0" }, { "v": "21852.172" }, { "v": "33361.44227875914" }, { "v": "288.0" }, { "v": "0.0" }, { "v": "0.0" }, { "v": null }, { "v": "0.0" }, { "v": "0.0" }, { "v": "21852.172" }, { "v": "33361.44227875914" } ] } ], "totalBytesProcessed": "59263", "jobComplete": true, "cacheHit": false }';
        GoogleBigQuery.RespParser(s);
 
    }
}