public class GoogleCommentsFetchBatch implements Database.Batchable < sObject > , Database.Stateful,Schedulable,Database.AllowsCallouts {
    public Integer limitVal;
    public Integer offSet;
    Integer receivedCount;
    Integer totalRows;
    public GoogleCommentsFetchBatch(Integer limitValue,Integer offSetValue){
        limitVal = limitValue;
        offSet = offSetValue;  
    }
    
    public GoogleCommentsFetchBatch(){
        limitVal = 100;
        offSet = 0;
    }
    
    public void execute(SchedulableContext sc) {
        Database.executeBatch(new GoogleCommentsFetchBatch());
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
            //req.setBody('{"query":"SELECT * FROM agg_zone.sfdc_market_tracker_comment LIMIT '+ limitVal+' OFFSET '+offSet+'"}');
            req.setBody('{"query":"SELECT * FROM agg_zone.sfdc_100pct_analysis_comment LIMIT '+ limitVal+' OFFSET '+offSet+'"}');
            Http http = new Http();
            HTTPResponse res = new HTTPResponse();
            if(!Test.isRunningTest()) res = http.send(req);
            else {
                res.setBody('{"kind":"bigquery#queryResponse","schema":{"fields":[{"name":"product_family","type":"STRING","mode":"NULLABLE"},{"name":"segment","type":"STRING","mode":"NULLABLE"},{"name":"customer_code","type":"INTEGER","mode":"NULLABLE"},{"name":"customer_name","type":"STRING","mode":"NULLABLE"},{"name":"drl_act_volume_eu","type":"FLOAT","mode":"NULLABLE"},{"name":"drl_act_sales","type":"FLOAT","mode":"NULLABLE"},{"name":"drl_act_price","type":"FLOAT","mode":"NULLABLE"},{"name":"drl_act_tpt","type":"FLOAT","mode":"NULLABLE"},{"name":"drl_act_tpt_pct","type":"FLOAT","mode":"NULLABLE"},{"name":"prof_month_range","type":"STRING","mode":"NULLABLE"},{"name":"ims_mat_volume_eu","type":"FLOAT","mode":"NULLABLE"},{"name":"ims_mat_sales","type":"FLOAT","mode":"NULLABLE"},{"name":"ims_mat_month_range","type":"STRING","mode":"NULLABLE"},{"name":"ims_drl_mkt_sh_qtr","type":"FLOAT","mode":"NULLABLE"},{"name":"ims_qtr_month_range","type":"STRING","mode":"NULLABLE"},{"name":"drl_mkt_sh_act","type":"FLOAT","mode":"NULLABLE"},{"name":"cust_act_volume_mat_eu","type":"FLOAT","mode":"NULLABLE"},{"name":"cust_act_sales_mat","type":"FLOAT","mode":"NULLABLE"},{"name":"cust_act_mkt_sh","type":"FLOAT","mode":"NULLABLE"},{"name":"gcp_suggested_price","type":"FLOAT","mode":"NULLABLE"}]},"jobReference":{"projectId":"nag-analytics","jobId":"job_vehymv3sW1Yuuno-mJxYVxDswoBh","location":"asia-south1"},"totalRows":"100","rows":[{"f":[{"v":"OLOPATADINE"},{"v":"OTC"},{"v":"147972"},{"v":"HPC-GROCERY INVOICES"},{"v":"488287.0"},{"v":"3002441.1700000004"},{"v":"6.148927106394396"},{"v":"1633557.0925241003"},{"v":"0.5440763032582917"},{"v":"Nov 2020 - Oct 2021"},{"v":null},{"v":null},{"v":null},{"v":null},{"v":null},{"v":null},{"v":"24456.0"},{"v":"135330.24000000002"},{"v":null},{"v":null}]},{"f":[{"v":"NICOTINE LOZENGE MINT"},{"v":"OTC"},{"v":"370941"},{"v":"SUPERVALU INC."},{"v":"6946488.0"},{"v":"928247.4470844998"},{"v":"0.1336283093103306"},{"v":"176507.20583590007"},{"v":"0.19015102749841697"},{"v":"Nov 2020 - Oct 2021"},{"v":null},{"v":null},{"v":null},{"v":null},{"v":null},{"v":null},{"v":"6192.0"},{"v":"864.937296"},{"v":null},{"v":null}]}],"totalBytesProcessed":"782517","jobComplete":true,"cacheHit":false}');
            }
            String gcpResponse = res.getBody();            
            // Parsing BigQuery Response
            GoogleBigQuery.GoogleBigQueryRespWrapper gbqrw = GoogleBigQuery.RespParser(gcpResponse);
            totalRows = gbqrw.totalRows;
           
            //Existing GCP records map for linking
            map<String,String> existingProductFamilyMap =new Map<String,String>();
            for(GCP_Product_Family_Map__c  prdfmy : [select id,GCP_Product_Family__c, SFDC_Product_Family__c From GCP_Product_Family_Map__c])
            {
                existingProductFamilyMap.put(prdfmy.GCP_Product_Family__c,prdfmy.SFDC_Product_Family__c); 
                
            }
            //SF - GCP fields Map
            Map<String,String> gcpSfFieldsMap = new Map<String,String>();
            gcpSfFieldsMap.put('reporting_molecule','GCP_Product_Family__c'); 
            gcpSfFieldsMap.put('long_term_strategy','long_term_strategy__c'); 
            gcpSfFieldsMap.put('segment','Segment__c'); 
            gcpSfFieldsMap.put('short_term_strategy','short_term_strategy__c'); 
            gcpSfFieldsMap.put('author','Author__c'); 
            gcpSfFieldsMap.put('comment_date','Comment_Date__c'); 
            
            // adding decimal fields to a list
            List<String> decimalFields = new List<String>();
            List<String> dateFields = new List<String>();
            String SobjectApiName = 'GCP_Comment__c';
            Map<String,Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get(SobjectApiName).newSObject().getSobjectType().getDescribe().fields.getMap();
            for(String fieldName : fieldMap.keyset())
            {
                Schema.DisplayType fielddataType = fieldMap.get(fieldName).getDescribe().getType();
                String fldStringType = String.valueOf(fielddataType).trim();
                if(fldStringType == 'PERCENT' || fldStringType == 'DOUBLE' || fldStringType == 'CURRENCY')
                {
                    decimalFields.add(fieldName);
                }
                else if(fldStringType == 'DATETIME'){
                    dateFields.add(fieldName);
                }    
            }
             
            List< GCP_Comment__c> finalGCPrecords = new List< GCP_Comment__c >();
            Set<String> gcp_unique_ids = new Set<String>();
            Map<String,GCP_Comment__c> finalGCPrecordsMap = new Map<String,GCP_Comment__c >();
            for(Integer rowCounter : gbqrw.jsonRowMap.keySet()){//1
                Map<Integer,String> tempRowMap = gbqrw.jsonRowMap.get(rowCounter);
                GCP_Comment__c gcpSFRec = new GCP_Comment__c();
                
                for(Integer valNo : tempRowMap.keySet()){
                    String fieldName = gcpSfFieldsMap.get(gbqrw.jsonFieldMap.get(valNo));
                    currentField = fieldName;
                    String fieldValue = tempRowMap.get(valNo);
                    if(fieldValue != null && fieldName != null){
                        if(decimalFields.contains(fieldName.toLowerCase())){
                            gcpSFRec.put(fieldName , Decimal.valueOf(fieldValue).setScale(4));
                        }
                        else if(dateFields.contains(fieldName.toLowerCase()))
                        {
                            fieldValue= fieldValue.replace('T', ' ');
                            gcpSFRec.put(fieldName , DateTime.valueOf(fieldValue));
                        }
                        else{
                            gcpSFRec.put(fieldName , fieldValue);
                        }    
                    }     
                }
                gcpSFRec.Product_Family__c  = existingProductFamilyMap.containsKey(gcpSFRec.GCP_Product_Family__c.trim()) ? existingProductFamilyMap.get(gcpSFRec.GCP_Product_Family__c.trim()) : null;
                gcpSFRec.GCP_Unique_Identifier__c  = gcpSFRec.GCP_Product_Family__c +'_'+ gcpSFRec.Segment__c+'_'+gcpSFRec.Comment_Date__c;
                gcp_unique_ids.add(gcpSFRec.GCP_Unique_Identifier__c);
                //gcpSFRec.Id = existingGCPMap.containsKey(gcpSFRec.GCP_Unique_Identifier__c) ? existingGCPMap.get(gcpSFRec.GCP_Unique_Identifier__c) : null;
                gcpSFRec.Comment_Type__c  = 'Panorama';
                finalGCPrecordsMap.put(gcpSFRec.GCP_Unique_Identifier__c,gcpSFRec);
            }
            //Existing GCP records map for linking
            for(GCP_Comment__c gcp : [select Id,GCP_Unique_Identifier__c  From GCP_Comment__c Where GCP_Unique_Identifier__c in : gcp_unique_ids]){
                finalGCPrecordsMap.get(gcp.GCP_Unique_Identifier__c).Id = gcp.Id;
            }
            finalGCPrecords.AddAll(finalGCPrecordsMap.values());
            upsert finalGCPrecords;
        }
        Catch(Exception e) {            
            Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'GoogleCommentsFetchBatch', Phoenix_Error_Message__c = e.getMessage()+' '+currentField, Phoenix_Issue_Status__c = 'Pending', Phoenix_Method_Name__c = 'execute', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');            insert exp;
        }
        
    }
    
    public void finish(Database.BatchableContext BC) {
        //Plan for next run
        System.debug('Total Row Count is ======> '+totalRows + '   Limit Val is ======> ' +limitVal);
        if(!Test.isRunningTest()){
            if(totalRows == limitVal){
                offSet = offSet + limitVal;
                Database.executeBatch(new GoogleCommentsFetchBatch(limitVal,offSet));
            }
            else{
                 Integer Records=[select count() from GCP_Comment__c ];
                string RecordsCount= 'Total Records are '+String.valueOf(Records);
                
                Phoenix_Util.sendBatchJobCompletionEmail('GCP Comments Fetch ', RecordsCount);
            }
        }
    }
}