public class GoogleBigQueryDRLSalesFetch implements Database.Batchable < sObject > , Database.Stateful,Schedulable,Database.AllowsCallouts {
    public Integer limitVal;
    public Integer offSet;
    Integer receivedCount;
    Integer totalRows;
    public GoogleBigQueryDRLSalesFetch(Integer limitValue,Integer offSetValue){
        limitVal = limitValue;
        offSet = offSetValue;
    }
    
    public GoogleBigQueryDRLSalesFetch(){
        limitVal = 100;
        offSet = 0;
    }
    
    public void execute(SchedulableContext sc) {
        Database.executeBatch(new GoogleBigQueryDRLSalesFetch());
    }
    
    public Database.QueryLocator start(Database.BatchableContext BC) {
        delete [Select Id FROM Vision_DRL_Sales__c WHERE CreatedDate != Today LIMIT 10000];
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
            //req.setBody('{"query":"SELECT * FROM agg_zone.sfdc_profitability LIMIT '+ limitVal+' OFFSET '+offSet+'"}');
            req.setBody('{"query":"SELECT * FROM agg_zone.sfdc_net_sales_profitability LIMIT '+ limitVal+' OFFSET '+offSet+'"}');
            Http http = new Http();
            HTTPResponse res = new HTTPResponse();
            if(!Test.isRunningTest()) {
                
                res = http.send(req);
                if (res.getStatusCode() == 200) {
                    gcpResponse = res.getBody();
                }
                else{
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
            map<String,Account> accMap =new Map<String,Account>();
            for( Account acc : [select id,name,accountNumber From Account])accMap.put(acc.accountNumber,acc);
            
            //Existing GCP records map for linking
            map<String,String> existingProductFamilyMap =new Map<String,String>();
            for(GCP_Product_Family_Map__c  prdfmy : [select id,GCP_Product_Family__c, SFDC_Product_Family__c From GCP_Product_Family_Map__c])
            {
                existingProductFamilyMap.put(prdfmy.GCP_Product_Family__c,prdfmy.SFDC_Product_Family__c); 
            }

            Map<String,String> gcpSfFieldsMap = new Map<String,String>();
            gcpSfFieldsMap.put('Product','GCP_Product_Family__c'); //text
            gcpSfFieldsMap.put('customer_name','GCP_customer_name__c'); //Text
            gcpSfFieldsMap.put('npr_customer_code','Vision_NPR_Customer_Code__c'); //Lookup(Account)
            gcpSfFieldsMap.put('segment','Vision_Segment__c'); // picklist
            gcpSfFieldsMap.put('customer_number','Vision_Customer_Number__c'); //text
            gcpSfFieldsMap.put('month_dtls','Vision_Month_dtls__c'); //date
            gcpSfFieldsMap.put('units','Vision_Units__c'); //number
            gcpSfFieldsMap.put('sales_dollar','Vision_Sales_Dollar__c'); //currency
            gcpSfFieldsMap.put('tpt_dollar','Vision_TPT_Dollar__c'); //currency
            gcpSfFieldsMap.put('tpt_pct','Vision_TPT_Pct__c'); //percent
            gcpSfFieldsMap.put('updated_date','GCP_Update_Date__c'); //date
            
            // adding decimal fields to a list
            List<String> decimalFields = new List<String>();
            List<String> dateFields = new List<String>();
            String SobjectApiName = 'Vision_DRL_Sales__c';
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
            
            List< Vision_DRL_Sales__c> finalGCPrecords = new List< Vision_DRL_Sales__c >();
            Set<String> gcp_unique_ids = new Set<String>();
            Map<String,Vision_DRL_Sales__c> finalGCPrecordsMap = new Map<String,Vision_DRL_Sales__c >();
            for(Integer rowCounter : gbqrw.jsonRowMap.keySet()){//1
                Map<Integer,String> tempRowMap = gbqrw.jsonRowMap.get(rowCounter);
                Vision_DRL_Sales__c gcpSFRec = new Vision_DRL_Sales__c();
                
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
                //gcpSFRec.Phoenix_Product_Family__c  = gcpSFRec.GCP_Product_Family__c; 
                gcpSFRec.Vision_Product_Family__c  = existingProductFamilyMap.containsKey(gcpSFRec.GCP_Product_Family__c) ? existingProductFamilyMap.get(gcpSFRec.GCP_Product_Family__c) : null;
                gcpSFRec.GCP_Unique_Identifier__c  = gcpSFRec.GCP_Product_Family__c +'_'+ gcpSFRec.Vision_Customer_Number__c+'_'+gcpSFRec.Vision_Segment__c+'_'+ gcpSFRec.Vision_NPR_Customer_Code__c+'_'+gcpSFRec.Vision_Month_dtls__c;
                gcp_unique_ids.add(gcpSFRec.GCP_Unique_Identifier__c);
                //gcpSFRec.Id = existingGCPMap.containsKey(gcpSFRec.GCP_Unique_Identifier__c) ? existingGCPMap.get(gcpSFRec.GCP_Unique_Identifier__c) : null;
                gcpSFRec.Vision_Customer_Name__c = accMap.containsKey(gcpSFRec.Vision_NPR_Customer_Code__c) ? accMap.get(gcpSFRec.Vision_NPR_Customer_Code__c).Id : gcpSFRec.Vision_Customer_Name__c;
                gcpSFRec.Vision_Update_Date__c = Phoenix_Util.getTodayEST();
                finalGCPrecordsMap.put(gcpSFRec.GCP_Unique_Identifier__c,gcpSFRec);
                
            }
            //Existing GCP records map for linking
            for(Vision_DRL_Sales__c gcp : [select Id,GCP_Unique_Identifier__c  From Vision_DRL_Sales__c Where GCP_Unique_Identifier__c in : gcp_unique_ids]){
                finalGCPrecordsMap.get(gcp.GCP_Unique_Identifier__c).Id = gcp.Id;
            }
            finalGCPrecords.AddAll(finalGCPrecordsMap.values());
            upsert finalGCPrecords;            
        }
        Catch(Exception e) {
            Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'GoogleBigQueryDRLSalesFetch', Phoenix_Error_Message__c = e.getMessage()+' '+currentField, Phoenix_Issue_Status__c = 'Pending', Phoenix_Method_Name__c = 'execute', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
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
                    Database.executeBatch(new GoogleBigQueryDRLSalesFetch(limitVal,offSet));
                }
                else{
                    // storing MAX of month_dtls,GCP_Update_Date__c, in custom label
                    Vision_DRL_Sales__c salesRec = [select Vision_Month_dtls__c,GCP_Update_Date__c from Vision_DRL_Sales__c order by Vision_Month_dtls__c desc limit 1];
                    String Vision_Month_dtls_val = String.valueOf(salesRec.Vision_Month_dtls__c).substringbefore(' ');
                    String Vision_gcp_update_date  = String.valueOf(salesRec.GCP_Update_Date__c).substringbefore(' ');
                    String Vision_update_date = String.valueOf(Phoenix_Util.getTodayEST()).substringbefore(' ');
                    drl_sales_dates_info__c dsdi = drl_sales_dates_info__c.getInstance('Data1');
                    dsdi.Vision_Data_Available_Till__c = Vision_Month_dtls_val;
                    dsdi.Vision_GCP_Update_Date__c = Vision_gcp_update_date;
                    dsdi.Vision_Update_Date__c = Vision_update_date;
                    update dsdi;
                    
                    Integer Records=[select count() from Vision_DRL_Sales__c];
                    string RecordsCount='Total Records are '+ String.valueOf(Records);
                    Phoenix_Util.sendBatchJobCompletionEmail('DRL Sales ', RecordsCount);
					
                }
            }
            Catch(Exception e) {
                Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'GoogleBigQueryDRLSalesFetch', Phoenix_Error_Message__c = e.getMessage(), Phoenix_Issue_Status__c = 'Pending', Phoenix_Method_Name__c = 'execute', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
                insert exp;
            }
        }
    }
}