public class Googlesfdc100pctanalysisSKULevel implements Database.Batchable < sObject > , Database.Stateful,Schedulable,Database.AllowsCallouts {
    public Integer limitVal;
    public Integer offSet;
    Integer receivedCount;
    Integer totalRows;
    public Googlesfdc100pctanalysisSKULevel(Integer limitValue,Integer offSetValue){
        limitVal = limitValue;
        offSet = offSetValue;  
    }
    
    public Googlesfdc100pctanalysisSKULevel(){
        limitVal = 100;
        offSet = 0;
    }
    
    public void execute(SchedulableContext sc) {
        Database.executeBatch(new Googlesfdc100pctanalysisSKULevel());
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
            //string s= '\'370741\'';
            //req.setBody('{"query":"SELECT * FROM agg_zone.sfdc_market_tracker WHERE product_family is not null AND customer_code is not null LIMIT '+ limitVal+' OFFSET '+offSet+'"}');
            req.setBody('{"query":"SELECT * FROM agg_zone.sfdc_100pct_analysis_sku_level_prof LIMIT '+ limitVal+' OFFSET '+offSet+'"}');
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
            //Account map for linking
            map<String,Account> accMap =new Map<String,Account>();
            for( Account acc : [select id,name,accountNumber From Account])accMap.put(acc.accountNumber,acc);
            //Existing GCP records map for linking
             map<String,String> existingProductFamilyMap =new Map<String,String>();
            for(Product_Family__c  prdfmy : [select id,Name From Product_Family__c])
            {
                existingProductFamilyMap.put(prdfmy.Name,prdfmy.id); 
                
            }    
              map<String,Product2> skuprodMap =new Map<String,Product2>();
            for( Product2 prod : [select Id,name,ProductCode From Product2 where ProductCode != null]){
                skuprodMap.put(prod.ProductCode,prod);
            }
            //SF - GCP fields Map
            Map<String,String> gcpSfFieldsMap = new Map<String,String>();
            gcpSfFieldsMap.put('sku_code','SKU_Code__c'); 
            gcpSfFieldsMap.put('product_family','GCP_Product_Family__c'); 
            gcpSfFieldsMap.put('segment','Segment__c');
            //gcpSfFieldsMap.put('customer_sfid','Phoenix_Customer__c');
            gcpSfFieldsMap.put('drl_act_volume_eu','drl_act_volume_eu__c');
            gcpSfFieldsMap.put('drl_act_price','DRL_Act_Price__c');
            gcpSfFieldsMap.put('drl_act_sales','DRL_Act_Sales__c');//ok
            gcpSfFieldsMap.put('drl_act_tpt','DRL_Act_Tpt__c');
             gcpSfFieldsMap.put('drl_act_tpt_pct','DRL_Act_Tpt_Pct__c');
             gcpSfFieldsMap.put('prof_month_range','Prof_Month_Range__c');
               gcpSfFieldsMap.put('gcp_suggested_price','GCP_Suggested_Price__c');
            
            // adding decimal fields to a list
            List<String> decimalFields = new List<String>();
            List<String> dateFields = new List<String>();
            String SobjectApiName = 'GCP_100PCT_Analysis_SKU__c';
            Map<String,Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get(SobjectApiName).newSObject().getSobjectType().getDescribe().fields.getMap();
            for(String fieldName : fieldMap.keyset())
            {
                Schema.DisplayType fielddataType = fieldMap.get(fieldName).getDescribe().getType();
                String fldStringType = String.valueOf(fielddataType);
                if(fldStringType == 'PERCENT' || fldStringType == 'DOUBLE' || fldStringType == 'CURRENCY')
                {
                    decimalFields.add(fieldName);
                }
                else if(fldStringType == 'DATE')
                {
                    dateFields.add(fieldName);
                }
                
            }
            List< GCP_100PCT_Analysis_SKU__c> finalGCPrecords = new List< GCP_100PCT_Analysis_SKU__c >();
            Set<String> gcp_unique_ids = new Set<String>();
            Map<String,GCP_100PCT_Analysis_SKU__c> finalGCPrecordsMap = new Map<String,GCP_100PCT_Analysis_SKU__c >();
            for(Integer rowCounter : gbqrw.jsonRowMap.keySet()){//1
                Map<Integer,String> tempRowMap = gbqrw.jsonRowMap.get(rowCounter);
                GCP_100PCT_Analysis_SKU__c gcpSFRec = new GCP_100PCT_Analysis_SKU__c();
                
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
                            gcpSFRec.put(fieldName , Date.valueOf(fieldValue));
                        }
                        else {
                            gcpSFRec.put(fieldName , fieldValue);  
                        }
                    }   
                }
                gcpSFRec.Product_Family__c  = existingProductFamilyMap.containsKey(gcpSFRec.GCP_Product_Family__c) ? existingProductFamilyMap.get(gcpSFRec.GCP_Product_Family__c) : null;
                gcpSFRec.Vision_Updated_Date__c = System.today();
                //finalGCPrecords.add(gcpSFRec);
                gcpSFRec.GCP_Unique_Identifier__c  = gcpSFRec.GCP_Product_Family__c +'_'+ gcpSFRec.SKU_Code__c;
                //gcpSFRec.Id = existingGCPMap.containsKey(gcpSFRec.GCP_Unique_Identifier__c) ? existingGCPMap.get(gcpSFRec.GCP_Unique_Identifier__c) : null;
                gcp_unique_ids.add(gcpSFRec.GCP_Unique_Identifier__c);
                gcpSFRec.Vision_Product__c = skuprodMap.containsKey(gcpSFRec.SKU_Code__c) ? skuprodMap.get(gcpSFRec.SKU_Code__c).Id : gcpSFRec.Vision_Product__c;
                finalGCPrecordsMap.put(gcpSFRec.GCP_Unique_Identifier__c,gcpSFRec);  
            }
            //Existing GCP records map for linking
            for(GCP_100PCT_Analysis_SKU__c gcp : [select Id,GCP_Unique_Identifier__c  From GCP_100PCT_Analysis_SKU__c Where GCP_Unique_Identifier__c in : gcp_unique_ids]){
              if(finalGCPrecordsMap.containskey(gcp.GCP_Unique_Identifier__c)){
                finalGCPrecordsMap.get(gcp.GCP_Unique_Identifier__c).Id = gcp.Id;
              }
            }
            
            finalGCPrecords.AddAll(finalGCPrecordsMap.values());
            upsert finalGCPrecords;
        }
        Catch(Exception e) {            
            Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'Googlesfdc100pctanalysisSKULevel', Phoenix_Error_Message__c = e.getMessage()+' '+currentField, Phoenix_Issue_Status__c = 'Pending', Phoenix_Method_Name__c = 'execute', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');            insert exp;
         } 
    }
    
    public void finish(Database.BatchableContext BC) {
        //Plan for next run
        if(!Test.isRunningTest()){
            try{
                System.debug('Total Row Count is ======> '+totalRows + '   Limit Val is ======> ' +limitVal);
                if(totalRows == limitVal){
                    offSet = offSet + limitVal;
                    Database.executeBatch(new Googlesfdc100pctanalysisSKULevel(limitVal,offSet));
                }
                else{
                      //Integer Records=[select count() from  Phoenix_GCP_Opportunity_Tracker__c];
                //string RecordsCount= 'Total Records are '+String.valueOf(Records);
                
                //Phoenix_Util.sendBatchJobCompletionEmail('GCP Opportunity Tracker  ', RecordsCount);
                   Database.executeBatch(new GoogleSFDC100PctAnalysisUnique());
                }
                
            }
            Catch(Exception e) {
                Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'Googlesfdc100pctanalysisSKULevel', Phoenix_Error_Message__c = e.getMessage(), Phoenix_Issue_Status__c = 'Pending', Phoenix_Method_Name__c = 'execute', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
                insert exp;
            }
        }
        
    }

}