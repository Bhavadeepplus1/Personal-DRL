public class GoogleSFDCProfitabilitySKULevel implements Database.Batchable < sObject > , Database.Stateful,Schedulable,Database.AllowsCallouts {
    public Integer limitVal;
    public Integer offSet;
    Integer receivedCount;
    Integer totalRows;
    public GoogleSFDCProfitabilitySKULevel(Integer limitValue,Integer offSetValue){
        limitVal = limitValue;
        offSet = offSetValue;
    }
    
    public GoogleSFDCProfitabilitySKULevel(){
        limitVal = 100;
        offSet = 0;
    }
    
    public void execute(SchedulableContext sc) {
        Database.executeBatch(new GoogleSFDCProfitabilitySKULevel());
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
           // req.setEndpoint('https://bigquery.googleapis.com/bigquery/v2/projects/nag-analytics/queries');
            req.setHeader('Content-type', 'application/json');
            req.setHeader('Authorization', 'Bearer ' + auth.getAccessToken());
            req.setBody('{"query":"SELECT * FROM agg_zone.sfdc_profitability_sku_level LIMIT '+ limitVal+' OFFSET '+offSet+'"}');
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
                res.setBody('{ "kind": "bigquery#queryResponse", "schema": { "fields": [ { "name": "sku_code", "type": "STRING", "mode": "NULLABLE" }, { "name": "Product", "type": "STRING", "mode": "NULLABLE" }, { "name": "customer_name", "type": "INTEGER", "mode": "NULLABLE" }, { "name": "account_salesforce_id", "type": "STRING", "mode": "NULLABLE" }, { "name": "segment", "type": "STRING", "mode": "NULLABLE" }, { "name": "customer_number", "type": "INTEGER", "mode": "NULLABLE" }, { "name": "month_dtls", "type": "DATE", "mode": "NULLABLE" }, { "name": "units", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "sales_dollar", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "tpt_dollar", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "tpt_pct", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "updated_date", "type": "DATE", "mode": "NULLABLE" } ] }, "jobReference": { "projectId": "nag-analytics", "jobId": "job_z1nZ-HaOti2KyqkelxpyvLDJHqKy", "location": "asia-south1" }, "totalRows": "1", "rows": [ { "f": [ { "v": "300007256" }, { "v": "SULFADIAZINE 1% CREAM" }, { "v": null }, { "v": "0011K00002RDd3vQAD" }, { "v": "RX" }, { "v": "106266" }, { "v": "2018-04-30" }, { "v": "216.0" }, { "v": "1296.998159" }, { "v": "1177.8003808" }, { "v": "0.9080971878233792" }, { "v": "2022-03-10" } ] } ], "totalBytesProcessed": "23309218", "jobComplete": true, "cacheHit": false } ');
                gcpResponse = res.getBody();
            }
            //System.debug('GCP Response is ====>'+gcpResponse);
            
            // Parsing BigQuery Response
            GoogleBigQuery.GoogleBigQueryRespWrapper gbqrw = GoogleBigQuery.RespParser(gcpResponse);
            totalRows = gbqrw.totalRows;
            
            //Account map for linking
            map<String,Account> accMap =new Map<String,Account>();
            for( Account acc : [select id,name,accountNumber From Account where accountNumber != null])accMap.put(acc.accountNumber,acc);
            
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
            Map<String,String> gcpSfFieldsMap = new Map<String,String>();
            gcpSfFieldsMap.put('sku_code','Vision_SKU_Code__c');
            gcpSfFieldsMap.put('Product','GCP_Product_Family__c');
            gcpSfFieldsMap.put('customer_name','Vision_Customer_Name__c');
            gcpSfFieldsMap.put('account_salesforce_id','Vision_Account_Salesforce_Id__c');
            gcpSfFieldsMap.put('segment','Vision_Segment__c'); 
            gcpSfFieldsMap.put('customer_number','Vision_Customer_Number__c'); 
            gcpSfFieldsMap.put('month_dtls','Vision_Month_DtLs__c'); 
            gcpSfFieldsMap.put('units','Vision_Units__c'); 
            gcpSfFieldsMap.put('sales_dollar','Vision_Sales_Dollar__c'); 
            gcpSfFieldsMap.put('tpt_dollar','Vision_TPT_Dollar__c'); 
            gcpSfFieldsMap.put('tpt_pct','Vision_TPT_PCT__c'); 
            gcpSfFieldsMap.put('npr_customer_code','Vision_NPR_Customer_Code__c'); 
            gcpSfFieldsMap.put('updated_date','Vision_Updated_Date__c'); 
           
            // adding decimal fields to a list
            List<String> decimalFields = new List<String>();
            List<String> dateFields = new List<String>();
            String SobjectApiName = 'Vision_GCP_SFDC_Profitability_SKU_Level__c';
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
            List<Vision_GCP_SFDC_Profitability_SKU_Level__c> finalGCPrecords = new List<Vision_GCP_SFDC_Profitability_SKU_Level__c>();
            Set<String> gcp_unique_ids = new Set<String>();
            Set<String>  gcp_skus = new set<string>();
            
            Map<String,Vision_GCP_SFDC_Profitability_SKU_Level__c> finalGCPrecordsMap = new Map<String,Vision_GCP_SFDC_Profitability_SKU_Level__c>();
            for(Integer rowCounter : gbqrw.jsonRowMap.keySet()){//1
                Map<Integer,String> tempRowMap = gbqrw.jsonRowMap.get(rowCounter);
                Vision_GCP_SFDC_Profitability_SKU_Level__c gcpSFRec = new Vision_GCP_SFDC_Profitability_SKU_Level__c();
                
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
                if(gcpSFRec.Vision_NPR_Customer_Code__c != null){
                    String cusCode = gcpSFRec.Vision_NPR_Customer_Code__c.replaceFirst('^0+', '');
                    // cuscode=cuscode.replaceAll('[^a-zA-Z0-9\\s+]', '');
                    gcpSFRec.Vision_Customer__c = accMap.containsKey(cuscode) ? accMap.get(cuscode).Id : gcpSFRec.Vision_Customer__c;
                }
                if(gcpSFRec.Vision_SKU_Code__c != null){
                    
                    gcpSFRec.Vision_Product__c = skuCodePrdMap.containsKey(gcpSFRec.Vision_SKU_Code__c) ? skuCodePrdMap.get(gcpSFRec.Vision_SKU_Code__c).Id : gcpSFRec.Vision_Product__c;
                }
                 if(gcpSFRec.GCP_Product_Family__c != null){
                     string gcpproduct =gcpSFRec.GCP_Product_Family__c.replaceAll('[^a-zA-Z0-9\\s+]', '');
                    gcpSFRec.Vision_Product_Family__c = existingProductFamilyMap.containsKey(gcpproduct) ? existingProductFamilyMap.get(gcpproduct) :gcpSFRec.Vision_Product_Family__c;
                }
                if(gcpSFRec.Vision_NPR_Customer_Code__c!=null && gcpSFRec.Vision_SKU_Code__c!=null){
                    gcp_skus.add(gcpSFRec.Vision_NPR_Customer_Code__c+'-'+gcpSFRec.Vision_SKU_Code__c);
                }
              
                
                gcpSFRec.Vision_GCP_Unique_Identifier__c   = gcpSFRec.Vision_Customer_Number__c+'_'+gcpSFRec.Vision_SKU_Code__c+'_'+gcpSFRec.Vision_NPR_Customer_Code__c+'_'+gcpSFRec.Vision_Month_DtLs__c;
                gcp_unique_ids.add(gcpSFRec.Vision_GCP_Unique_Identifier__c );
                finalGCPrecordsMap.put(gcpSFRec.Vision_GCP_Unique_Identifier__c ,gcpSFRec);
                
            }
           
            //Get All the Customer Product records using the set
            Map<string,Id> customerPrdTrcMap = new Map<string,Id >();
            
            for(Vision_Customer_Product_Tracker__c cpt :[select id,	Vision_Internal_Unique_Identifier__c from Vision_Customer_Product_Tracker__c where Vision_Internal_Unique_Identifier__c in:  gcp_skus order by createdDate Desc]){
                if(!customerPrdTrcMap.containsKey(cpt.Vision_Internal_Unique_Identifier__c))                    
                	customerPrdTrcMap.put(cpt.Vision_Internal_Unique_Identifier__c,cpt.id);
            }
            
             //Existing GCP records map for linking
            for(Vision_GCP_SFDC_Profitability_SKU_Level__c gcp : [select Id,Vision_GCP_Unique_Identifier__c From Vision_GCP_SFDC_Profitability_SKU_Level__c Where Vision_GCP_Unique_Identifier__c in : gcp_unique_ids]){
                
                finalGCPrecordsMap.get(gcp.Vision_GCP_Unique_Identifier__c).Id = gcp.Id;
            }
            for(string cptrec: finalGCPrecordsMap.keyset()){
               if( finalGCPrecordsMap.get(cptrec).Vision_SKU_Code__c!=null && finalGCPrecordsMap.get(cptrec).Vision_NPR_Customer_Code__c!=null)
                   
               {
                   string uniqid = finalGCPrecordsMap.get(cptrec).Vision_NPR_Customer_Code__c+'-'+finalGCPrecordsMap.get(cptrec).Vision_SKU_Code__c;
                  if(customerPrdTrcMap.containsKey(uniqid)) 
                      finalGCPrecordsMap.get(cptrec).Vision_Customer_Product_Tracker__c=customerPrdTrcMap.get(uniqid);
               }
            }
            
            
            finalGCPrecords.AddAll(finalGCPrecordsMap.values());
            system.debug(finalGCPrecordsMap.size());
            upsert finalGCPrecords; 
        }
            
        Catch(Exception e) {
            Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'GoogleSFDCProfitabilitySKULevel', Phoenix_Error_Message__c = e.getMessage()+' '+currentField, Phoenix_Issue_Status__c = 'Pending', Phoenix_Method_Name__c = 'execute', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
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
                	Database.executeBatch(new GoogleSFDCProfitabilitySKULevel(limitVal,offSet));
                }
                else{
                    // storing MAX of GCP_Update_Date__c, in custom label
                   	/*Vision_GCP_SFDC_Profitability_SKU_Level__c ProSKU = [select GCP_Update_Date__c from Vision_GCP_SFDC_Profitability_SKU_Level__c limit 1];
                    String Vision_gcp_update_date  = String.valueOf(ProSKU.GCP_Update_Date__c).substringbefore(' ');
                    String Vision_update_date = String.valueOf(Phoenix_Util.getTodayEST()).substringbefore(' ');
                    system.debug('--Vision_gcp_update_date--'+Vision_gcp_update_date);
                    system.debug('--Vision_update_date--'+Vision_update_date);
                    SFDC_Profitability_SKU_level_Dates_Info__c  skudi = SFDC_Profitability_SKU_level_Dates_Info__c.getInstance('Data1');
                    skudi.Vision_GCP_Update_Date__c = Vision_gcp_update_date;
                    skudi.Vision_Update_Date__c = Vision_update_date;
                    update cotdi;
                    Integer Records=[select count() from Vision_GCP_SFDC_Profitability_SKU_Level__c ];
                    string RecordsCount= String.valueOf(Records);
                    Phoenix_Util.sendBatchJobCompletionEmail('SFDC Profitability SKU Level ', RecordsCount);*/ 
                }
                
        
            }
            Catch(Exception e) {
                Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'GoogleSFDCProfitabilitySKULevel', Phoenix_Error_Message__c = e.getMessage(), Phoenix_Issue_Status__c = 'Pending', Phoenix_Method_Name__c = 'execute', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
                insert exp;
            }
        }
    }
    
}