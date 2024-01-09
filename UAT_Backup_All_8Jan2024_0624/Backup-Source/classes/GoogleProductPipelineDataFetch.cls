public class GoogleProductPipelineDataFetch implements Database.Batchable < sObject > , Database.Stateful,Schedulable,Database.AllowsCallouts {
    public Integer limitVal;
    public Integer offSet;
    Integer receivedCount;
    Integer totalRows;
    public GoogleProductPipelineDataFetch(Integer limitValue,Integer offSetValue){
        limitVal = limitValue;
        offSet = offSetValue;
    }
    
    public GoogleProductPipelineDataFetch(){
        limitVal = 100;
        offSet = 0;
    }
    
    public void execute(SchedulableContext sc) {
        Database.executeBatch(new GoogleProductPipelineDataFetch());
    }
    
    public Database.QueryLocator start(Database.BatchableContext BC) {
        delete [Select Id FROM Product_Pipeline__c WHERE CreatedDate != Today LIMIT 10000];
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
            req.setBody('{"query":"SELECT * FROM agg_zone.sfdc_pipeline_launch_dtls LIMIT '+ limitVal+' OFFSET '+offSet+'"}');
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
                res.setBody('{ "kind": "bigquery#queryResponse", "schema": { "fields": [ { "name": "segment", "type": "STRING", "mode": "NULLABLE" }, { "name": "reporting_molecule", "type": "STRING", "mode": "NULLABLE" }, { "name": "sku_code", "type": "STRING", "mode": "NULLABLE" }, { "name": "sku_desc", "type": "STRING", "mode": "NULLABLE" }, { "name": "ndc_code", "type": "STRING", "mode": "NULLABLE" }, { "name": "inventory_date", "type": "DATE", "mode": "NULLABLE" }, { "name": "forecast", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "mtd_sales", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "open_so", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "unsold_forecast", "type": "INTEGER", "mode": "NULLABLE" }, { "name": "ups_inv", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "inventory_qa", "type": "INTEGER", "mode": "NULLABLE" }, { "name": "in_tran_inventory", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "total_moh", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "dispatch_week_1", "type": "STRING", "mode": "NULLABLE" }, { "name": "dispatch_week_2", "type": "STRING", "mode": "NULLABLE" }, { "name": "dispatch_week_3", "type": "STRING", "mode": "NULLABLE" }, { "name": "dispatch_week_4", "type": "STRING", "mode": "NULLABLE" }, { "name": "comments", "type": "STRING", "mode": "NULLABLE" } ] }, "jobReference": { "projectId": "nag-analytics", "jobId": "job_KypwWo6mrZx4GTyk_btBgpSyyoDH", "location": "asia-south1" }, "totalRows": "1", "rows": [ { "f": [ { "v": "RX" }, { "v": "FLUCONAZOLE TABS" }, { "v": "300000885" }, { "v": "Fluconazole 50mg 30" }, { "v": "55111014330" }, { "v": "2021-11-21" }, { "v": "321.0" }, { "v": "312.0" }, { "v": "0.07476635514018691" }, { "v": null }, { "v": "11.458566978193147" }, { "v": null }, { "v": "0.0" }, { "v": "11.458566978193147" }, { "v": null }, { "v": null }, { "v": null }, { "v": null }, { "v": null } ] } ], "totalBytesProcessed": "0", "jobComplete": true, "cacheHit": true }');
                gcpResponse = res.getBody();
            }
            //System.debug('GCP Response is ====>'+gcpResponse);
            
            // Parsing BigQuery Response
            GoogleBigQuery.GoogleBigQueryRespWrapper gbqrw = GoogleBigQuery.RespParser(gcpResponse);
            totalRows = gbqrw.totalRows;
            
            //Account map for linking
            /*map<String,Account> accMap =new Map<String,Account>();
for( Account acc : [select id,name,accountNumber From Account where accountNumber != null])accMap.put(acc.accountNumber,acc);*/
            
            //Existing GCP records map for linking
            map<String,String> existingProductFamilyMap =new Map<String,String>();
            for(GCP_Product_Family_Map__c  prdfmy : [select id,GCP_Product_Family__c, SFDC_Product_Family__c From GCP_Product_Family_Map__c])
            {
                existingProductFamilyMap.put(prdfmy.GCP_Product_Family__c,prdfmy.SFDC_Product_Family__c); 
            }
            Map<String,String> gcpSfFieldsMap = new Map<String,String>();
            gcpSfFieldsMap.put('reporting_molecule','Vision_GCP_Product_Family__c');
            gcpSfFieldsMap.put('generic_name','Vision_Generic_Name__c');
            gcpSfFieldsMap.put('Launch_Month','Vision_Launch_Month__c');
             gcpSfFieldsMap.put('potential_launch_date','Vision_Potential_Launch_date__c');
            gcpSfFieldsMap.put('strat_plan_molecule','Vision_Strat_Plan_Molecule__c');
            gcpSfFieldsMap.put('therapeutic_area','Vision_Therapeutic_Area__c');
            gcpSfFieldsMap.put('updated_date','GCP_Updated_Date__c');
            gcpSfFieldsMap.put('Launch_Year','GCP_Launch_Year__c');
            gcpSfFieldsMap.put('dosage_form','Vision_Dosage_Form__c');
            gcpSfFieldsMap.put('segment','Vision_Segment__c');
            gcpSfFieldsMap.put('strength','Vision_Strength__c'); 
            gcpSfFieldsMap.put('reference_brand','Vision_Reference_Brand__c'); 
            gcpSfFieldsMap.put('size','Vision_Size__c'); 
            gcpSfFieldsMap.put('api_vertically_integrated','Vision_Api_Vertically_Integrated__c'); 
            gcpSfFieldsMap.put('launch_type','Vision_Launch_Type__c'); 
              gcpSfFieldsMap.put('Authorized_Generic','Vision_Authorized_Generic__c'); 
             gcpSfFieldsMap.put('Unit_Dose','Vision_Unit_Dose__c'); 
             gcpSfFieldsMap.put('Anda_Filed','Vision_Anda_Filed__c'); 
            //gcpSfFieldsMap.put('launch_type','Vision_Launch_Type_1__c'); 
            gcpSfFieldsMap.put('comments','Vision_Comments__c');
            gcpSfFieldsMap.put('gpi','Vision_GPI__c'); 
            gcpSfFieldsMap.put('gcn','Vision_GCN__c');
            
            
            // adding decimal fields to a list
            List<String> decimalFields = new List<String>();
            List<String> dateFields = new List<String>();
            String SobjectApiName = 'Product_Pipeline__c';
            Map<String,Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get(SobjectApiName).newSObject().getSobjectType().getDescribe().fields.getMap();
            for(String fieldName : fieldMap.keyset())
            {
                Schema.DisplayType fielddataType = fieldMap.get(fieldName).getDescribe().getType();
                String fldStringType = String.valueOf(fielddataType).trim();
                if( fldStringType == 'DOUBLE' || fldStringType == 'CURRENCY')
                {
                    decimalFields.add(fieldName);
                }
                else if(fldStringType == 'DATE'){
                    dateFields.add(fieldName);
                }    
            }
            system.debug('decimalFields : '+decimalFields);
            system.debug('dateFields : '+dateFields);
            List<Product_Pipeline__c> finalGCPrecords = new List<Product_Pipeline__c>();
            Set<String> gcp_unique_ids = new Set<String>();
            Map<String,Product_Pipeline__c> finalGCPrecordsMap = new Map<String,Product_Pipeline__c>();
            List<String> ignoreDatainDates = new List<String>{'TBD','None',''};
                for(Integer rowCounter : gbqrw.jsonRowMap.keySet()){//1
                    Map<Integer,String> tempRowMap = gbqrw.jsonRowMap.get(rowCounter);
                    Product_Pipeline__c gcpSFRec = new Product_Pipeline__c();
                    
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
                                if(!ignoreDatainDates.contains(fieldValue))
                                    gcpSFRec.put(fieldName , Date.valueOf(fieldValue));
                            }
                            else{
                                gcpSFRec.put(fieldName , fieldValue);
                                System.debug('fieldName=>'+fieldName  + '  fieldValue=>'+fieldValue);
                            }
                            
                        }
                        
                    }
                    gcpSFRec.Vision_Updated_Date__c = Phoenix_Util.getTodayEST();
                    gcpSFRec.Vision_Product_Family__c  = existingProductFamilyMap.containsKey(gcpSFRec.Vision_GCP_Product_Family__c) ? existingProductFamilyMap.get(gcpSFRec.Vision_GCP_Product_Family__c) : null;
                    finalGCPrecords.add(gcpSFRec);
                    for(Product_Pipeline__c a:finalGCPrecords){
                        system.debug('records..'+ a);
                    }
                    
                    /*gcpSFRec.Vision_GCP_Unique_Identifier__c   = gcpSFRec.Vision_NDC_Code__c +'_'+ gcpSFRec.Vision_SKU_Code__c+'_'+gcpSFRec.Vision_Order_Qty__c+'_'+gcpSFRec.Vision_Order_Date__c+'_'+gcpSFRec.Vision_Price__c;
gcp_unique_ids.add(gcpSFRec.Vision_GCP_Unique_Identifier__c );
finalGCPrecordsMap.put(gcpSFRec.Vision_GCP_Unique_Identifier__c ,gcpSFRec);*/
                    
                }
            //Existing GCP records map for linking
            /*for(Product_Pipeline__c gcp : [select Id,Vision_GCP_Unique_Identifier__c From Product_Pipeline__c Where Vision_GCP_Unique_Identifier__c in : gcp_unique_ids]){
finalGCPrecordsMap.get(gcp.Vision_GCP_Unique_Identifier__c).Id = gcp.Id;
}
finalGCPrecords.AddAll(finalGCPrecordsMap.values());*/
           upsert finalGCPrecords;            
        }
        Catch(Exception e) {
            Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'GoogleProductPipelineDataFetch', Phoenix_Error_Message__c = e.getMessage()+' '+currentField, Phoenix_Issue_Status__c = 'Pending', Phoenix_Method_Name__c = 'execute', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
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
                    Database.executeBatch(new GoogleProductPipelineDataFetch(limitVal,offSet));
                }
                else{
                    Integer Records=[select count() from Product_Pipeline__c ];
                    string RecordsCount='Total Records are '+ String.valueOf(Records);
                    Phoenix_Util.sendBatchJobCompletionEmail('GCP Product Pipeline', RecordsCount);
                    PipelineNotificationCls.notifyUsers(Records);
                }
            }
            Catch(Exception e) {
                Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'GoogleProductPipelineDataFetch', Phoenix_Error_Message__c = e.getMessage(), Phoenix_Issue_Status__c = 'Pending', Phoenix_Method_Name__c = 'execute', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
                insert exp;
            }
        }
    }
    
}