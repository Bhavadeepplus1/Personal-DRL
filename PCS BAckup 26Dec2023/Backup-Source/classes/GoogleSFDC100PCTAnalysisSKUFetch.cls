public class GoogleSFDC100PCTAnalysisSKUFetch implements Database.Batchable < sObject > , Database.Stateful,Schedulable,Database.AllowsCallouts {
    public Integer limitVal;
    public Integer offSet;
    Integer receivedCount;
    Integer totalRows;
    public GoogleSFDC100PCTAnalysisSKUFetch(Integer limitValue,Integer offSetValue){
        limitVal = limitValue;
        offSet = offSetValue;  
    }
    
    public GoogleSFDC100PCTAnalysisSKUFetch(){
        limitVal = 100;
        offSet = 0;
    }
    
    public void execute(SchedulableContext sc) {
        Database.executeBatch(new GoogleSFDC100PCTAnalysisSKUFetch());
    }
    
    public Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator('Select Id FROM Account Limit 1');
    }
    
    public void execute(Database.BatchableContext BC, List < Account > accList) {
        String currentField='';
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
            string s= '\'370741\'';
            //req.setBody('{"query":"SELECT * FROM agg_zone.sfdc_100pct_analysis_sku_level LIMIT '+ limitVal+' OFFSET '+offSet+'"}');
            req.setBody('{"query":"SELECT * FROM agg_zone.sfdc_100pct_analysis_sku_level LIMIT '+ limitVal+' OFFSET '+offSet+'"}');
            
            Http http = new Http();
            HTTPResponse res = new HTTPResponse();
            if(!Test.isRunningTest()) res = http.send(req);
            else {
                res.setBody('{ "kind": "bigquery#queryResponse", "schema": { "fields": [ { "name": "record_id", "type": "BYTES", "mode": "NULLABLE" }, { "name": "sku_code", "type": "STRING", "mode": "NULLABLE" }, { "name": "product_family", "type": "STRING", "mode": "NULLABLE" }, { "name": "segment", "type": "STRING", "mode": "NULLABLE" }, { "name": "customer_code", "type": "INTEGER", "mode": "NULLABLE" }, { "name": "customer_sfid", "type": "STRING", "mode": "NULLABLE" }, { "name": "customer_name", "type": "INTEGER", "mode": "NULLABLE" }, { "name": "cogs_per_unit", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "drl_act_volume_eu", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "drl_act_sales", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "drl_act_price", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "drl_act_tpt", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "drl_act_tpt_pct", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "prof_month_range", "type": "STRING", "mode": "NULLABLE" }, { "name": "cust_act_volume_mat_eu", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "cust_act_sales_mat", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "gcp_suggested_price", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "Gcp_update_date", "type": "DATE", "mode": "NULLABLE" } ] }, "jobReference": { "projectId": "nag-analytics", "jobId": "job_RogY6bqmsTdqiglbUicPSITGnR5q", "location": "asia-south1" }, "totalRows": "1", "rows": [ { "f": [ { "v": "/EVHYchXJfokloH+t56rFYyRwdN4pfpOQU8MxplIBiU=" }, { "v": "300000845" }, { "v": "FAMOTIDINE" }, { "v": "RX" }, { "v": "158639" }, { "v": "0011K00002RDd45QAD" }, { "v": null }, { "v": "0.0077491088782535794" }, { "v": "3.9754E7" }, { "v": "355132.296128" }, { "v": "0.008933246871459476" }, { "v": "-74587.54814489999" }, { "v": "-0.21002749949279878" }, { "v": null }, { "v": null }, { "v": null }, { "v": null }, { "v": "2022-03-15" } ] } ], "totalBytesProcessed": "0", "jobComplete": true, "cacheHit": true } ');
            }
            String gcpResponse = res.getBody();            
            // Parsing BigQuery Response
            GoogleBigQuery.GoogleBigQueryRespWrapper gbqrw = GoogleBigQuery.RespParser(gcpResponse);
            totalRows = gbqrw.totalRows;
            map<String,Id> accMap =new map<String,Id>();
            for( Account acc : [select id,name,accountNumber From Account where accountNumber != null])
            {
                accMap.put(acc.accountNumber,acc.Id);
            }
            map<String,Product2> skuCodePrdMap =new Map<String,Product2>();
            for( Product2 prod : [select Id,name,ProductCode From Product2 where ProductCode != null and IsActive = true AND Phoenix_Is_Exclude_Bid__c = false]){
                skuCodePrdMap.put(prod.ProductCode,prod);
            }
          
           
            //Existing GCP records map for linking
            map<String,String> existingProductFamilyMap =new Map<String,String>();
            for(GCP_Product_Family_Map__c  prdfmy : [select id,GCP_Product_Family__c, SFDC_Product_Family__c From GCP_Product_Family_Map__c])
            {
                existingProductFamilyMap.put(prdfmy.GCP_Product_Family__c,prdfmy.SFDC_Product_Family__c); 
                
            }
            //SF - GCP fields Map
            Map<String,String> gcpSfFieldsMap = new Map<String,String>();
            gcpSfFieldsMap.put('record_id','Vision_Unique_Identifier__c');
            gcpSfFieldsMap.put('sku_code','Vision_SKU_Code__c'); 
            gcpSfFieldsMap.put('product_family','GCP_Product_Family__c'); 
            gcpSfFieldsMap.put('segment','Vision_Segment__c'); 
            gcpSfFieldsMap.put('customer_code','Vision_Customer_Code__c'); 
            gcpSfFieldsMap.put('customer_sfid','Vision_Customer_SFID__c'); 
            gcpSfFieldsMap.put('customer_name','Vision_Customer_Name__c');
            gcpSfFieldsMap.put('cogs_per_unit','Vision_COGS_Per_Unit__c'); 
            gcpSfFieldsMap.put('drl_act_volume_eu','Vision_DRL_Act_Volume_Eu__c'); 
            gcpSfFieldsMap.put('drl_act_sales','Vision_Drl_Act_Sales__c'); 
            gcpSfFieldsMap.put('drl_act_price','Vision_Drl_Act_Price__c'); 
            gcpSfFieldsMap.put('drl_act_tpt','Vision_DRL_Act_Tpt__c'); 
            gcpSfFieldsMap.put('drl_act_tpt_pct','Vision_Drl_Act_Tpt_Pct__c');
            gcpSfFieldsMap.put('prof_month_range','Vision_Proof_Month_Range__c'); 
            gcpSfFieldsMap.put('cust_act_volume_mat_eu','GCP_Cust_Act_Volume_Mat_Eu__c'); 
            gcpSfFieldsMap.put('cust_act_sales_mat','Vision_Cust_Act_Sales_Mat__c'); 
            gcpSfFieldsMap.put('gcp_suggested_price','Vision_Suggested_Price__c'); 
            gcpSfFieldsMap.put('Gcp_update_date','Vision_Update_date__c'); 
           
            
            // adding decimal fields to a list
            List<String> decimalFields = new List<String>();
            List<String> dateFields = new List<String>();
            String SobjectApiName = 'GCP_SFDC_100pct_Analysis_SKU__c';
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
             
            List<GCP_SFDC_100pct_Analysis_SKU__c> finalGCPrecords = new List< GCP_SFDC_100pct_Analysis_SKU__c >();
            Set<String> gcp_unique_ids = new Set<String>();
            Map<String,GCP_SFDC_100pct_Analysis_SKU__c> finalGCPrecordsMap = new Map<String,GCP_SFDC_100pct_Analysis_SKU__c>();
            for(Integer rowCounter : gbqrw.jsonRowMap.keySet()){//1
                Map<Integer,String> tempRowMap = gbqrw.jsonRowMap.get(rowCounter);
                GCP_SFDC_100pct_Analysis_SKU__c gcpSFRec = new GCP_SFDC_100pct_Analysis_SKU__c();
                
                for(Integer valNo : tempRowMap.keySet()){
                    String fieldName = gcpSfFieldsMap.get(gbqrw.jsonFieldMap.get(valNo));
                    currentField = fieldName;
                    String fieldValue = tempRowMap.get(valNo);
                    if(fieldValue != null && fieldName != null){
                        if(decimalFields.contains(fieldName.toLowerCase())){
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
                if(gcpSFRec.Vision_SKU_Code__c != null){
                    gcpSFRec.Vision_Product__c = skuCodePrdMap.containsKey(gcpSFRec.Vision_SKU_Code__c) ? skuCodePrdMap.get(gcpSFRec.Vision_SKU_Code__c).Id : gcpSFRec.Vision_Product__c;
                    
                }
               if(gcpSFRec.Vision_Customer_Code__c != null){
                    String cusCode = string.valueOf(gcpSFRec.Vision_Customer_Code__c);
                    // cuscode=cuscode.replaceAll('[^a-zA-Z0-9\\s+]', '');
                    gcpSFRec.Vision_Customer__c = accMap.containsKey(cuscode) ? accMap.get(cuscode): gcpSFRec.Vision_Customer__c;
                }
               
                gcpSFRec.Vision_Update_Date__c = system.today();
                gcpSFRec.Product_Family__c  = existingProductFamilyMap.containsKey(gcpSFRec.GCP_Product_Family__c.trim()) ? existingProductFamilyMap.get(gcpSFRec.GCP_Product_Family__c.trim()) : gcpSFRec.Product_Family__c;
                //gcpSFRec.GCP_Unique_Identifier__c  = gcpSFRec.GCP_Product_Family__c +'_'+ gcpSFRec.Segment__c+'_'+gcpSFRec.Comment_Date__c;
                gcp_unique_ids.add(gcpSFRec.Vision_Unique_Identifier__c);
                finalGCPrecordsMap.put(gcpSFRec.Vision_Unique_Identifier__c,gcpSFRec);
            }
            //Existing GCP records map for linking
            for(GCP_SFDC_100pct_Analysis_SKU__c gcp : [select Id,Vision_Unique_Identifier__c  From GCP_SFDC_100pct_Analysis_SKU__c Where Vision_Unique_Identifier__c in : gcp_unique_ids]){
                finalGCPrecordsMap.get(gcp.Vision_Unique_Identifier__c).Id = gcp.Id;
            }
            finalGCPrecords.AddAll(finalGCPrecordsMap.values());
            upsert finalGCPrecords;
            
        }
        Catch(Exception e) {            
            Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'GoogleSFDC100PCTAnalysisSKUFetch', Phoenix_Error_Message__c = e.getMessage()+' '+currentField, Phoenix_Issue_Status__c = 'Pending', Phoenix_Method_Name__c = 'execute', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');            insert exp;
        }
        
    }
    
    public void finish(Database.BatchableContext BC) {
        //Plan for next run
        System.debug('Total Row Count is ======> '+totalRows + '   Limit Val is ======> ' +limitVal);
        
        if(!Test.isRunningTest()){
            if(totalRows == limitVal){
                offSet = offSet + limitVal;
                Database.executeBatch(new GoogleSFDC100PCTAnalysisSKUFetch(limitVal,offSet));
            }
            else{
                Integer Records=[select count() from GCP_SFDC_100pct_Analysis_SKU__c ];
                string RecordsCount= 'Total Records are '+String.valueOf(Records);
                Phoenix_Util.sendBatchJobCompletionEmail('SFDC 100pct Analysis SKU Level ', RecordsCount);
                  Database.executeBatch(new Googlesfdc100pctanalysisSKULevel());
            }
        }
    }
}