public class GoogleNoOppProductsFetch implements Database.Batchable < sObject > , Database.Stateful,Schedulable,Database.AllowsCallouts {
    public Integer limitVal;
    public Integer offSet;
    Integer receivedCount;
    Integer totalRows;
    public GoogleNoOppProductsFetch(Integer limitValue,Integer offSetValue){
        limitVal = limitValue;
        offSet = offSetValue;
    }
    
    public GoogleNoOppProductsFetch(){
        limitVal = 100;
        offSet = 0;
    }
    
    public void execute(SchedulableContext sc) {
        Database.executeBatch(new GoogleNoOppProductsFetch());
    }
    
    public Database.QueryLocator start(Database.BatchableContext BC) {
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
            //req.setBody('{"query":"SELECT * FROM agg_zone.sfdc_market_tracker_product LIMIT '+ limitVal+' OFFSET '+offSet+'"}');
            req.setBody('{"query":"SELECT * FROM agg_zone.sfdc_100pct_analysis_product LIMIT '+ limitVal+' OFFSET '+offSet+'"}');
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
                res.setBody('{ "kind": "bigquery#queryResponse", "schema": { "fields": [ { "name": "Product", "type": "STRING", "mode": "NULLABLE" }, { "name": "customer_name", "type": "STRING", "mode": "NULLABLE" }, { "name": "account_salesforce_id", "type": "STRING", "mode": "NULLABLE" }, { "name": "segment", "type": "STRING", "mode": "NULLABLE" }, { "name": "customer_number", "type": "INTEGER", "mode": "NULLABLE" }, { "name": "month_dtls", "type": "DATE", "mode": "NULLABLE" }, { "name": "units", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "sales_dollar", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "tpt_dollar", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "tpt_pct", "type": "FLOAT", "mode": "NULLABLE" } ] }, "jobReference": { "projectId": "nag-analytics", "jobId": "job_1w6P3McTXZNhoiXZSFR2C6bG539B", "location": "asia-south1" }, "totalRows": "100", "rows": [ { "f": [ { "v": "SULFADIAZINE 1% CREAM" }, { "v": "DIAMOND DRUGS INC" }, { "v": "0011K00002RDd3vQAD" }, { "v": "RX" }, { "v": "106266" }, { "v": "2018-04-30" }, { "v": "234.0" }, { "v": "1745.7343121" }, { "v": "1566.3956755000002" }, { "v": "0.897270371924885" } ] }, { "f": [ { "v": "DIVALPROEX SODIUM ER TABS" }, { "v": "DIAMOND DRUGS INC" }, { "v": "0011K00002RDd3vQAD" }, { "v": "RX" }, { "v": "106266" }, { "v": "2018-04-30" }, { "v": "36000.0" }, { "v": "8396.7056298" }, { "v": "6041.7944927" }, { "v": "0.7195434446644889" } ] }, { "f": [ { "v": "OMEPRAZOLE DR CAPS" }, { "v": "AMERISOURCE HEALTH SERVICES, LLC, D" }, { "v": "0011K00002RDd6mQAD" }, { "v": "RX" }, { "v": "108475" }, { "v": "2018-04-30" }, { "v": "636000.0" }, { "v": "15209.5210106" }, { "v": "7180.3253489" }, { "v": "0.47209411419963865" } ] } ], "totalBytesProcessed": "9103094", "jobComplete": true, "cacheHit": false }');
                gcpResponse = res.getBody();
            }
            System.debug('GCP Response is ====>'+gcpResponse);
            
            // Parsing BigQuery Response
            GoogleBigQuery.GoogleBigQueryRespWrapper gbqrw = GoogleBigQuery.RespParser(gcpResponse);
            totalRows = gbqrw.totalRows;
            
            //Account map for linking
            //map<String,Account> accMap =new Map<String,Account>();
            //for( Account acc : [select id,name,accountNumber From Account])accMap.put(acc.accountNumber,acc);
            
            //Existing GCP records map for linking
            map<String,String> existingProductFamilyMap =new Map<String,String>();
            for(GCP_Product_Family_Map__c  prdfmy : [select id,GCP_Product_Family__c, SFDC_Product_Family__c From GCP_Product_Family_Map__c])
            {
                existingProductFamilyMap.put(prdfmy.GCP_Product_Family__c,prdfmy.SFDC_Product_Family__c); 
            }
            
            Map<String,String> gcpSfFieldsMap = new Map<String,String>();
            gcpSfFieldsMap.put('product_family','GCP_Product_Family__c'); //text
            gcpSfFieldsMap.put('drl_act_volume_eu','Vision_Drl_Act_Volume_Eu__c'); //Number
            gcpSfFieldsMap.put('segment','Vision_Segment__c'); // picklist
            gcpSfFieldsMap.put('drl_act_sales','Vision_Drl_Act_Sales__c'); 
            gcpSfFieldsMap.put('drl_act_price','Vision_Drl_Act_Price__c'); 
            gcpSfFieldsMap.put('drl_act_tpt','Vision_Drl_Act_TPT__c'); 
            gcpSfFieldsMap.put('drl_act_tpt_pct','Vision_DRL_Act_TPT_PCT__c'); 
            gcpSfFieldsMap.put('prof_month_range','Vision_Prof_Month_Range__c'); 
            gcpSfFieldsMap.put('ims_mat_volume_eu','Vision_IMS_Mat_Volume_Eu__c'); 
            gcpSfFieldsMap.put('ims_mat_sales','Vision_IMS_Mat_Sales__c'); 
            gcpSfFieldsMap.put('ims_mat_month_range','Vision_IMS_Mat_Month_Range__c'); 
            gcpSfFieldsMap.put('ims_drl_mkt_sh_qtr','Vision_IMS_Drl_Mkt_Sh_Qtr__c'); 
            gcpSfFieldsMap.put('ims_qtr_month_range','Vision_IMS_Quarter_Month_Range__c'); 
            gcpSfFieldsMap.put('drl_mkt_sh_act','Vision_Drl_Mkt_Sh_Act__c'); 
            gcpSfFieldsMap.put('panorama_suggested_price','Vision_Panorama_Suggested_Price__c'); 

            
            // adding decimal fields to a list
            List<String> decimalFields = new List<String>();
            List<String> dateFields = new List<String>();
            String SobjectApiName = 'Vision_Non_Opportunity_Products__c';
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
            
            List< Vision_Non_Opportunity_Products__c> finalGCPrecords = new List< Vision_Non_Opportunity_Products__c >();
            Set<String> gcp_unique_ids = new Set<String>();
            Map<String,Vision_Non_Opportunity_Products__c> finalGCPrecordsMap = new Map<String,Vision_Non_Opportunity_Products__c >();
            for(Integer rowCounter : gbqrw.jsonRowMap.keySet()){//1
                Map<Integer,String> tempRowMap = gbqrw.jsonRowMap.get(rowCounter);
                Vision_Non_Opportunity_Products__c gcpSFRec = new Vision_Non_Opportunity_Products__c();
                
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
                        else{
                            gcpSFRec.put(fieldName , fieldValue);
                        }
                        
                    }
                    
                }
                gcpSFRec.Vision_Product_Family__c  = existingProductFamilyMap.containsKey(gcpSFRec.GCP_Product_Family__c) ? existingProductFamilyMap.get(gcpSFRec.GCP_Product_Family__c) : null;
                gcpSFRec.GCP_Unique_Identifier__c  = gcpSFRec.GCP_Product_Family__c +'_'+ gcpSFRec.Vision_Segment__c;
                gcp_unique_ids.add(gcpSFRec.GCP_Unique_Identifier__c);
                finalGCPrecordsMap.put(gcpSFRec.GCP_Unique_Identifier__c,gcpSFRec);
                
            }
            //Existing GCP records map for linking
            for(Vision_Non_Opportunity_Products__c gcp : [select Id,GCP_Unique_Identifier__c  From Vision_Non_Opportunity_Products__c Where GCP_Unique_Identifier__c in : gcp_unique_ids]){
                finalGCPrecordsMap.get(gcp.GCP_Unique_Identifier__c).Id = gcp.Id;
            }
            finalGCPrecords.AddAll(finalGCPrecordsMap.values());
            upsert finalGCPrecords;            
        }
        Catch(Exception e) {
            Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'GoogleNoOppProductsFetch', Phoenix_Error_Message__c = e.getMessage()+' '+currentField, Phoenix_Issue_Status__c = 'Pending', Phoenix_Method_Name__c = 'execute', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
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
                    Database.executeBatch(new GoogleNoOppProductsFetch(limitVal,offSet));
                }
                else{
                     Integer Records=[select count() from Vision_Non_Opportunity_Products__c ];
                string RecordsCount='Total Records are '+ String.valueOf(Records);
                
                Phoenix_Util.sendBatchJobCompletionEmail('Non Opportunity Products ', RecordsCount);
                }

            }
            Catch(Exception e) {
                Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'GoogleNoOppProductsFetch', Phoenix_Error_Message__c = e.getMessage(), Phoenix_Issue_Status__c = 'Pending', Phoenix_Method_Name__c = 'execute', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
                insert exp;
            }
        }
    }
}