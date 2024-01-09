public class GoogleShortDatesFetch implements Database.Batchable < sObject > , Database.Stateful,Schedulable,Database.AllowsCallouts {
    public Integer limitVal;
    public Integer offSet;
    Integer receivedCount;
    Integer totalRows;
    public GoogleShortDatesFetch(Integer limitValue,Integer offSetValue){
        limitVal = limitValue;
        offSet = offSetValue;
    }
    
    public GoogleShortDatesFetch(){
        limitVal = 100;
        offSet = 0;
    }
    
    public void execute(SchedulableContext sc) {
        Database.executeBatch(new GoogleShortDatesFetch());
    }
    
    public Database.QueryLocator start(Database.BatchableContext BC) {
        delete [Select Id FROM Vision_GCP_Short_Date__c WHERE CreatedDate != Today LIMIT 10000];
        return Database.getQueryLocator('Select Id FROM Account Limit 1');
    }
    
    public void execute(Database.BatchableContext BC, List < Account > accList) {
        String currentField='';
        String gcpResponse = '';
        try{
            //Query GCP
            GoogleAuthProvider auth = new GoogleAuthProvider();
            auth.authorize();
            HttpRequest req = new HttpRequest();
            req.setMethod('POST');
           	String endpoint = Label.bigQueryEndpoint;
            req.setEndpoint(endpoint);
            //req.setEndpoint('https://bigquery.googleapis.com/bigquery/v2/projects/nag-analytics/queries');
            req.setHeader('Content-type', 'application/json');
            req.setHeader('Authorization', 'Bearer ' + auth.getAccessToken());
            req.setBody('{"query":"SELECT * FROM agg_zone.sfdc_short_date LIMIT '+ limitVal+' OFFSET '+offSet+'"}');//sfdc_short_date
            Http http = new Http();
            HTTPResponse res = new HTTPResponse();
            if(!Test.isRunningTest()) {
                
                res = http.send(req);
                if (res.getStatusCode() == 200) {
                    gcpResponse = res.getBody();
                }
                else
                {
                    System.debug('The status code returned was not expected: ' +res.getStatusCode() + ' ' + res.getStatus());
                }
            }
            else {
                res.setBody('{ "kind": "bigquery#queryResponse", "schema": { "fields": [ { "name": "SAP_Part_Number", "type": "STRING", "mode": "NULLABLE" }, { "name": "Customer", "type": "STRING", "mode": "NULLABLE" }, { "name": "Family", "type": "STRING", "mode": "NULLABLE" }, { "name": "Pack_Size", "type": "STRING", "mode": "NULLABLE" }, { "name": "Description", "type": "STRING", "mode": "NULLABLE" }, { "name": "Month_1", "type": "STRING", "mode": "NULLABLE" }, { "name": "Month_2", "type": "STRING", "mode": "NULLABLE" }, { "name": "Month_3", "type": "STRING", "mode": "NULLABLE" }, { "name": "Month_4", "type": "STRING", "mode": "NULLABLE" }, { "name": "Month_5", "type": "STRING", "mode": "NULLABLE" }, { "name": "Month_6", "type": "STRING", "mode": "NULLABLE" }, { "name": "Month_7", "type": "STRING", "mode": "NULLABLE" }, { "name": "Month_8", "type": "STRING", "mode": "NULLABLE" }, { "name": "Month_9", "type": "STRING", "mode": "NULLABLE" }, { "name": "Forecast_Month_1", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "Forecast_Month_2", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "Forecast_Month_3", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "Forecast_Month_4", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "Forecast_Month_5", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "Forecast_Month_6", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "Forecast_Month_7", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "Forecast_Month_8", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "Forecast_Month_9", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "total_qty", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "FTO_Cost_dollar", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "M_1_short_date", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "M_1_potential_writeoff", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "M_1_writeoff_cost", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "M_2_short_date", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "M_2_potential_writeoff", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "M_2_writeoff_cost", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "M_3_short_date", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "M_3_potential_writeoff", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "M_3_writeoff_cost", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "M_4_short_date", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "M_4_potential_writeoff", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "M_4_writeoff_cost", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "M_5_short_date", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "M_5_potential_writeoff", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "M_5_writeoff_cost", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "M_6_short_date", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "M_6_potential_writeoff", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "M_6_writeoff_cost", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "M_7_short_date", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "M_7_potential_writeoff", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "M_7_writeoff_cost", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "M_8_short_date", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "M_8_potential_writeoff", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "M_8_writeoff_cost", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "M_9_short_date", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "M_9_potential_writeoff", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "M_9_writeoff_cost", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "Total_in_Units", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "Total_value_dollar", "type": "FLOAT", "mode": "NULLABLE" } ] }, "jobReference": { "projectId": "nag-analytics", "jobId": "job_g7pDCPqJnZ0o0G9JJAdJkwNCpkI3", "location": "asia-south1" }, "totalRows": "1", "rows": [ { "f": [ { "v": "300011866" }, { "v": "CONTROL LABEL" }, { "v": "OTC Fexo" }, { "v": "30" }, { "v": "DRL Control Fexo 24hr 180mg Tab 30ct Btl" }, { "v": "Jan" }, { "v": "Feb" }, { "v": "Mar" }, { "v": "Apr" }, { "v": "May" }, { "v": "Jun" }, { "v": "Jul" }, { "v": "Aug" }, { "v": "Sep" }, { "v": "50285.828" }, { "v": "50472.828" }, { "v": "49922.82800000001" }, { "v": "49479.82800000001" }, { "v": "49479.82800000001" }, { "v": "49479.82800000001" }, { "v": "48563.828" }, { "v": "48566.82800000001" }, { "v": "48566.82800000001" }, { "v": "81672.0" }, { "v": "1.526687703115239" }, { "v": "3072.0" }, { "v": "0.0" }, { "v": "0.0" }, { "v": "7896.0" }, { "v": "0.0" }, { "v": "0.0" }, { "v": null }, { "v": "0.0" }, { "v": "0.0" }, { "v": null }, { "v": "0.0" }, { "v": "0.0" }, { "v": null }, { "v": "0.0" }, { "v": "0.0" }, { "v": null }, { "v": "0.0" }, { "v": "0.0" }, { "v": "70416.0" }, { "v": "21852.172" }, { "v": "33361.44227875914" }, { "v": "288.0" }, { "v": "0.0" }, { "v": "0.0" }, { "v": null }, { "v": "0.0" }, { "v": "0.0" }, { "v": "21852.172" }, { "v": "33361.44227875914" } ] } ], "totalBytesProcessed": "59263", "jobComplete": true, "cacheHit": false }');
                gcpResponse = res.getBody();
            }
            //System.debug('GCP Response is ====>'+gcpResponse);
            
            // Parsing BigQuery Response
            GoogleBigQuery.GoogleBigQueryRespWrapper gbqrw = GoogleBigQuery.RespParser(gcpResponse);
            totalRows = gbqrw.totalRows;
            
            //Account map for linking
            map<String,Account> accMap =new Map<String,Account>();
            for( Account acc : [select id,name,accountNumber From Account where accountNumber != null])accMap.put(acc.accountNumber,acc);
            
            //Existing GCP records map for linking
            map<String,String> existingProductFamilyMap =new Map<String,String>();
            for(GCP_Product_Family_Map__c  prdfmy : [select id,GCP_Product_Family__c, SFDC_Product_Family__c From GCP_Product_Family_Map__c])
            {
                existingProductFamilyMap.put(prdfmy.GCP_Product_Family__c,prdfmy.SFDC_Product_Family__c); 
            }
            Map<String,String> gcpSfFieldsMap = new Map<String,String>(); 
          //  gcpSfFieldsMap.put('Customer_code','GCP_Customer_Code__c');  
            gcpSfFieldsMap.put('SAP_Part_Number','Vision_SAP_Part_Number__c');
            gcpSfFieldsMap.put('Customer','GCP_Customer_Name__c');
            gcpSfFieldsMap.put('Family','GCP_Product_Family__c');
            gcpSfFieldsMap.put('Pack_Size','Vision_Pack_Size__c');
            gcpSfFieldsMap.put('Description','Vision_Description__c');
            gcpSfFieldsMap.put('Month_1','Vision_Month_1__c'); 
            gcpSfFieldsMap.put('Month_2','Vision_Month_2__c'); 
            gcpSfFieldsMap.put('Month_3','Vision_Month_3__c'); 
            gcpSfFieldsMap.put('Month_4','Vision_Month_4__c'); 
            gcpSfFieldsMap.put('Month_5','Vision_Month_5__c');
            gcpSfFieldsMap.put('Month_6','Vision_Month_6__c');
            gcpSfFieldsMap.put('Month_7','Vision_Month_7__c'); 
            gcpSfFieldsMap.put('Month_8','Vision_Month_8__c'); 
            gcpSfFieldsMap.put('Month_9','Vision_Month_9__c');
            gcpSfFieldsMap.put('Forecast_Month_1','Vision_Forecast_Month_1__c'); 
            gcpSfFieldsMap.put('Forecast_Month_2','Vision_Forecast_Month_2__c'); 
            gcpSfFieldsMap.put('Forecast_Month_3','Vision_Forecast_Month_3__c'); 
            gcpSfFieldsMap.put('Forecast_Month_4','Vision_Forecast_Month_4__c'); 
            gcpSfFieldsMap.put('Forecast_Month_5','Vision_Forecast_Month_5__c');
            gcpSfFieldsMap.put('Forecast_Month_6','Vision_Forecast_Month_6__c');
            gcpSfFieldsMap.put('Forecast_Month_7','Vision_Forecast_Month_7__c'); 
            gcpSfFieldsMap.put('Forecast_Month_8','Vision_Forecast_Month_8__c'); 
            gcpSfFieldsMap.put('Forecast_Month_9','Vision_Forecast_Month_9__c');
            gcpSfFieldsMap.put('current_month_order_qty','Vision_Current_Month_Order_Quantity__c');
            gcpSfFieldsMap.put('FTO_Cost_dollar','Vision_FTO_Cost_dollar__c');
            gcpSfFieldsMap.put('total_qty','Vision_total_qty__c');
            gcpSfFieldsMap.put('M_1_short_date','Vision_M1_Short_Date__c');
            gcpSfFieldsMap.put('M_1_potential_writeoff','Vision_M1_Potential_Write_Off__c');
            gcpSfFieldsMap.put('M_1_writeoff_cost','Vision_M1_Write_Off_Cost__c');
            gcpSfFieldsMap.put('M_2_short_date','Vision_M2_Short_Date__c');
            gcpSfFieldsMap.put('M_2_potential_writeoff','Vision_M2_Potential_Write_Off__c');
            gcpSfFieldsMap.put('M_2_writeoff_cost','Vision_M2_Write_Off_Cost__c');
            gcpSfFieldsMap.put('M_3_short_date','Vision_M3_Short_Date__c');
            gcpSfFieldsMap.put('M_3_potential_writeoff','Vision_M3_Potential_Write_Off__c');
            gcpSfFieldsMap.put('M_3_writeoff_cost','Vision_M3_Write_Off_Cost__c');
            gcpSfFieldsMap.put('M_4_short_date','Vision_M4_Short_Date__c');
            gcpSfFieldsMap.put('M_4_potential_writeoff','Vision_M4_Potential_Write_Off__c');
            gcpSfFieldsMap.put('M_4_writeoff_cost','Vision_M4_Write_Off_Cost__c');
            gcpSfFieldsMap.put('M_5_short_date','Vision_M5_Short_Date__c');
            gcpSfFieldsMap.put('M_5_potential_writeoff','Vision_M5_Potential_Write_Off__c');
            gcpSfFieldsMap.put('M_5_writeoff_cost','Vision_M5_Write_Off_Cost__c');
            gcpSfFieldsMap.put('M_6_short_date','Vision_M6_Short_Date__c');
            gcpSfFieldsMap.put('M_6_potential_writeoff','Vision_M6_Potential_Write_Off__c');
            gcpSfFieldsMap.put('M_6_writeoff_cost','Vision_M6_Write_Off_Cost__c');
            gcpSfFieldsMap.put('M_7_short_date','Vision_M7_Short_Date__c');
            gcpSfFieldsMap.put('M_7_potential_writeoff','Vision_M7_Potential_Write_Off__c');
            gcpSfFieldsMap.put('M_7_writeoff_cost','Vision_M7_Write_Off_Cost__c');
            gcpSfFieldsMap.put('M_8_short_date','Vision_M8_Short_Date__c');
            gcpSfFieldsMap.put('M_8_potential_writeoff','Vision_M8_Potential_Write_Off__c');
            gcpSfFieldsMap.put('M_8_writeoff_cost','Vision_M8_Write_Off_Cost__c');
            gcpSfFieldsMap.put('M_9_short_date','Vision_M9_Short_Date__c');
            gcpSfFieldsMap.put('M_9_potential_writeoff','Vision_M9_Potential_Write_Off__c');
            gcpSfFieldsMap.put('M_9_writeoff_cost','Vision_M9_Write_Off_Cost__c');
	    	gcpSfFieldsMap.put('Total_writeoff_Units_3months','Vision_GCP_Total_Writeoff_Units_3_Months__c');
            gcpSfFieldsMap.put('Total_writeoff_cost_3months','Vision_GCP_Total_Writeoff_Costs_3_Months__c');
            gcpSfFieldsMap.put('Total_in_Units','Vision_Total_in_Units__c');
            gcpSfFieldsMap.put('Total_value_dollar','Vision_Total_value_dollar__c');
            gcpSfFieldsMap.put('Qty_writtenoff','Vision_qty_written_off__c');
            gcpSfFieldsMap.put('last_month_writtenoff_qty','Vision_Last_Month_Written_Off_QTY__c');
            gcpSfFieldsMap.put('Gcp_update_date','GCP_Updated_Date__c'); 
            
            // adding decimal fields to a list
            List<String> decimalFields = new List<String>();
            List<String> dateFields = new List<String>();
            String SobjectApiName = 'Vision_GCP_Short_Date__c';
            Map<String,Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get(SobjectApiName).newSObject().getSobjectType().getDescribe().fields.getMap();
            for(String fieldName : fieldMap.keyset())
            {
                Schema.DisplayType fielddataType = fieldMap.get(fieldName).getDescribe().getType();
                String fldStringType = String.valueOf(fielddataType).trim();
                if(fldStringType == 'PERCENT' || fldStringType == 'DOUBLE' || fldStringType == 'CURRENCY')
                {
                    decimalFields.add(fieldName);
                }
                else if(fldStringType == 'DATE'){
                    dateFields.add(fieldName);
                }    
            }
            system.debug('decimalFields : '+decimalFields);
            system.debug('dateFields : '+dateFields);
            List<Vision_GCP_Short_Date__c> finalGCPrecords = new List<Vision_GCP_Short_Date__c>();
            Set<String> gcp_unique_ids = new Set<String>();
            Map<String,Vision_GCP_Short_Date__c> finalGCPrecordsMap = new Map<String,Vision_GCP_Short_Date__c>();
            for(Integer rowCounter : gbqrw.jsonRowMap.keySet()){//1
                Map<Integer,String> tempRowMap = gbqrw.jsonRowMap.get(rowCounter);
                Vision_GCP_Short_Date__c gcpSFRec = new Vision_GCP_Short_Date__c();
                
                for(Integer valNo : tempRowMap.keySet()){
                    String fieldName = gcpSfFieldsMap.get(gbqrw.jsonFieldMap.get(valNo));
                    currentField = fieldName;
                    String fieldValue = tempRowMap.get(valNo);
                    if(fieldValue != null && fieldName != null){
                        if(decimalFields.contains(fieldName.toLowerCase())){
                            system.debug(fieldName+'---------'+fieldValue);
                            gcpSFRec.put(fieldName , Decimal.valueOf(fieldValue));
                        }
                        else if(dateFields.contains(fieldName.toLowerCase()))
                        {
                            gcpSFRec.put(fieldName , Date.valueOf(fieldValue));
                        }
                        else{
                            gcpSFRec.put(fieldName , fieldValue);
                        }
                        
                    }
                    
                }
              /* 	if(String.isNotBlank(gcpSFRec.GCP_Customer_Code__c)){
                	gcpSFRec.Vision_Customer__c  = accMap.containsKey(gcpSFRec.GCP_Customer_Code__c) ? accMap.get(gcpSFRec.GCP_Customer_Code__c).Id : null;
                }*/
                gcpSFRec.SF_Data_Pull_Date__c = Phoenix_Util.getTodayEST();
                gcpSFRec.Vision_Product_Family__c  = existingProductFamilyMap.containsKey(gcpSFRec.GCP_Product_Family__c) ? existingProductFamilyMap.get(gcpSFRec.GCP_Product_Family__c) : null;
                gcpSFRec.Vision_GCP_Unique_Identifier__c = gcpSFRec.Vision_SAP_Part_Number__c;
                gcp_unique_ids.add(gcpSFRec.Vision_GCP_Unique_Identifier__c);
                finalGCPrecords.add(gcpSFRec);
                finalGCPrecordsMap.put(gcpSFRec.Vision_GCP_Unique_Identifier__c,gcpSFRec);
            }

            //Existing GCP records map for linking
            for(Vision_GCP_Short_Date__c gcp : [select Id,Vision_GCP_Unique_Identifier__c From Vision_GCP_Short_Date__c Where Vision_GCP_Unique_Identifier__c in : gcp_unique_ids]){
                finalGCPrecordsMap.get(gcp.Vision_GCP_Unique_Identifier__c).Id = gcp.Id;
            }
          // finalGCPrecords.AddAll(finalGCPrecordsMap.values());
            upsert finalGCPrecords; 
        }
        Catch(Exception e) {
            Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'GoogleShortDatesFetch', Phoenix_Error_Message__c = e.getMessage()+' '+currentField, Phoenix_Issue_Status__c = 'Pending', Phoenix_Method_Name__c = 'execute', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
            insert exp;
        }
        
    }
    
    public void finish(Database.BatchableContext BC) {
        //Plan for next run
        System.debug('Total Row Count is ======> '+totalRows + '   Limit Val is ======> ' +limitVal);
        if(!Test.isRunningTest()){
            try{
                if(totalRows == limitVal){
                    offSet = offSet + limitVal;
                    Database.executeBatch(new GoogleShortDatesFetch(limitVal,offSet));
                }
else{
                     Integer Records=[select count() from Vision_GCP_Short_Date__c ];
                string RecordsCount= 'Total Records are '+String.valueOf(Records);
                
                Phoenix_Util.sendBatchJobCompletionEmail('GCP Short Dates ', RecordsCount);
                }
            }
            Catch(Exception e) {
                Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'GoogleShortDatesFetch', Phoenix_Error_Message__c = e.getMessage(), Phoenix_Issue_Status__c = 'Pending', Phoenix_Method_Name__c = 'execute', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
                insert exp;
            }
        }
    }
}