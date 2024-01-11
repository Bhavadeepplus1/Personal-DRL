public class GoogleSFDCIndirectSalesFetch implements Database.Batchable < sObject > , Database.Stateful,Schedulable,Database.AllowsCallouts {
    public Integer limitVal;
    public Integer offSet;
    Integer receivedCount;
    Integer totalRows;
    public GoogleSFDCIndirectSalesFetch(Integer limitValue,Integer offSetValue){
        limitVal = limitValue;
        offSet = offSetValue;
    }
    
    public GoogleSFDCIndirectSalesFetch(){
        limitVal = 100;
        offSet = 0;
    }
    
    public void execute(SchedulableContext sc) {
        Database.executeBatch(new GoogleSFDCIndirectSalesFetch());
    }
    
    public Database.QueryLocator start(Database.BatchableContext BC) {
         delete [Select Id FROM GCP_SFDC_Indirect_Sales__c WHERE CreatedDate != Today LIMIT 10000];
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
          //  req.setEndpoint('https://bigquery.googleapis.com/bigquery/v2/projects/nag-analytics/queries');
            req.setHeader('Content-type', 'application/json');
            req.setHeader('Authorization', 'Bearer ' + auth.getAccessToken());
            req.setBody('{"query":"SELECT * FROM agg_zone.Sfdc_Indirect_Sales LIMIT '+ limitVal+' OFFSET '+offSet+'"}');
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
                res.setBody('{ "kind": "bigquery#queryResponse", "schema": { "fields": [ { "name": "Month", "type": "STRING", "mode": "NULLABLE" }, { "name": "Contract_ID", "type": "STRING", "mode": "NULLABLE" }, { "name": "Material_Number", "type": "STRING", "mode": "NULLABLE" }, { "name": "NDC", "type": "STRING", "mode": "NULLABLE" }, { "name": "Material_Description", "type": "STRING", "mode": "NULLABLE" }, { "name": "Contract_Units_Paid_Qty", "type": "STRING", "mode": "NULLABLE" }, { "name": "Contract_Sales_Indirect_Price", "type": "STRING", "mode": "NULLABLE" }, { "name": "Paid_Chargeback_Amt", "type": "STRING", "mode": "NULLABLE" }, { "name": "Contract_External_ID", "type": "STRING", "mode": "NULLABLE" }, { "name": "Contract_Description", "type": "STRING", "mode": "NULLABLE" }, { "name": "Conversion_Quantity", "type": "STRING", "mode": "NULLABLE" }, { "name": "Settlement_Date_From", "type": "STRING", "mode": "NULLABLE" }, { "name": "Settlement_Document_Category", "type": "STRING", "mode": "NULLABLE" }, { "name": "Settlement_Date_To", "type": "STRING", "mode": "NULLABLE" }, { "name": "UOM", "type": "STRING", "mode": "NULLABLE" }, { "name": "Converion_UOM", "type": "STRING", "mode": "NULLABLE" }, { "name": "Gcp_update_date", "type": "DATE", "mode": "NULLABLE" } ] }, "jobReference": { "projectId": "nag-analytics", "jobId": "job_8xhR24mbmR76yRA4nOui8lzWsHvG", "location": "asia-south1" }, "totalRows": "1", "rows": [ { "f": [ { "v": " Mar 22" }, { "v": "3000000733" }, { "v": "300023750" }, { "v": "8489850015" }, { "v": "DRL HAB7 MG 7 CT" }, { "v": "26" }, { "v": "337.74" }, { "v": "44.2" }, { "v": "RXSS WHOLESALER CONT" }, { "v": "RXSS Indirect Wholesaler Contract" }, { "v": "182" }, { "v": "03-01-2022" }, { "v": "E" }, { "v": "10-03-2022" }, { "v": "SU" }, { "v": "NO" }, { "v": "2022-03-14" } ] } ], "totalBytesProcessed": "8394521", "jobComplete": true, "cacheHit": false } ');
                gcpResponse = res.getBody();
            }
            //System.debug('GCP Response is ====>'+gcpResponse);
            
            // Parsing BigQuery Response
            GoogleBigQuery.GoogleBigQueryRespWrapper gbqrw = GoogleBigQuery.RespParser(gcpResponse);
            totalRows = gbqrw.totalRows;
            
            //Account map for linking
            map<String,Phoenix_Contract__c> ContrMap =new Map<String,Phoenix_Contract__c>();
            for(Phoenix_Contract__c ctr : [select id, Phoenix_Contract_Number__c,Phoenix_Customer__r.id,Phoenix_Customer__r.AccountNumber From Phoenix_Contract__c where Phoenix_Contract_Number__c != null])ContrMap.put(ctr.Phoenix_Contract_Number__c,ctr);
            
            map<String,Product2> skuCodePrdMap =new Map<String,Product2>();
            for( Product2 prod : [select Id,name,ProductCode From Product2 where ProductCode != null and IsActive = true AND Phoenix_Is_Exclude_Bid__c = false]){
                skuCodePrdMap.put(prod.ProductCode,prod);
            }
            
            map<String,Product2> ndc11prodMap =new Map<String,Product2>();
            map<String,Product2> ndc10prodMap =new Map<String,Product2>();
            for( Product2 prod : [select Id,name,ProductCode,Phoenix_NDC__c , Phoenix_NDC_11__c   From Product2 where Phoenix_NDC_11__c != null and Phoenix_NDC__c != null and IsActive = true AND Phoenix_Is_Exclude_Bid__c = false]){
                ndc11prodMap.put(prod.Phoenix_NDC_11__c,prod);
                ndc10prodMap.put(prod.Phoenix_NDC__c,prod);                
            }
            
            Map<String,String> gcpSfFieldsMap = new Map<String,String>();
            gcpSfFieldsMap.put('Month','Vision_Month__c');
            gcpSfFieldsMap.put('Contract_ID','Vision_Contract_ID__c');
            gcpSfFieldsMap.put('Material_Number','Vision_Material_Number__c');
            gcpSfFieldsMap.put('NDC','Vision_NDC__c');
            gcpSfFieldsMap.put('Material_Description','Vision_Material_Description__c'); 
            gcpSfFieldsMap.put('Contract_Units_Paid_Qty','Vision_Contracts_Units_Paid_Qty__c'); 
            gcpSfFieldsMap.put('Contract_Sales_Indirect_Price','Vision_Contract_Sales_Indirect_Price__c'); 
            gcpSfFieldsMap.put('Paid_Chargeback_Amt','Vision_Paid_Charge_Back_Amount__c'); 
            gcpSfFieldsMap.put('Contract_External_ID','Vision_Contract_External_ID__c'); 
            gcpSfFieldsMap.put('Contract_Description','Vision_Contract_Description__c'); 
            gcpSfFieldsMap.put('Conversion_Quantity','Vision_Conversion_Quantity__c'); 
            gcpSfFieldsMap.put('Settlement_Date_From','Vision_Settlement_Date_From__c'); 
            gcpSfFieldsMap.put('Settlement_Document_Category','Vision_Settlement_Document_Category__c');
            gcpSfFieldsMap.put('Settlement_Date_To','Vision_Settlement_Date_To__c');
            gcpSfFieldsMap.put('UOM','Vision_UOM__c');
            gcpSfFieldsMap.put('Converion_UOM','Vision_Converion_UOM__c');
            gcpSfFieldsMap.put('Gcp_update_date','GCP_Update_Date__c');
            
            // adding decimal fields to a list
            List<String> decimalFields = new List<String>();
            List<String> dateFields = new List<String>();
            String SobjectApiName = 'GCP_SFDC_Indirect_Sales__c';
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
            List<GCP_SFDC_Indirect_Sales__c> finalGCPrecords = new List<GCP_SFDC_Indirect_Sales__c>();
            Set<String> gcp_unique_ids = new Set<String>();
            Map<String,GCP_SFDC_Indirect_Sales__c> finalGCPrecordsMap = new Map<String,GCP_SFDC_Indirect_Sales__c>();
            for(Integer rowCounter : gbqrw.jsonRowMap.keySet()){//1
                Map<Integer,String> tempRowMap = gbqrw.jsonRowMap.get(rowCounter);
                GCP_SFDC_Indirect_Sales__c gcpSFRec = new GCP_SFDC_Indirect_Sales__c();
                
                for(Integer valNo : tempRowMap.keySet()){
                    String fieldName = gcpSfFieldsMap.get(gbqrw.jsonFieldMap.get(valNo));
                    currentField = fieldName;
                    String fieldValue = tempRowMap.get(valNo);
                    if(fieldValue != null && fieldName != null){
                        if(decimalFields.contains(fieldName.toLowerCase())){                            gcpSFRec.put(fieldName , Decimal.valueOf(fieldValue));
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
            
                if(gcpSFRec.Vision_Contract_ID__c!= null){
                    String cusnum = gcpSFRec.Vision_Contract_ID__c.replaceFirst('^0+', '');
                    // cuscode=cuscode.replaceAll('[^a-zA-Z0-9\\s+]', '');
                    gcpSFRec.Vision_Contract__c = ContrMap.containsKey(cusnum) ? ContrMap.get(cusnum).Id : gcpSFRec.Vision_Contract__c;
                    if(ContrMap.containsKey(cusnum)){
                        if(ContrMap.get(cusnum).Phoenix_Customer__r.id != null)                            gcpSFRec.Vision_Account__c  = ContrMap.get(cusnum).Phoenix_Customer__r.id;
                        if(ContrMap.get(cusnum).Phoenix_Customer__r.AccountNumber != null)                            gcpSFRec.Vision_Customer_Code__c = ContrMap.get(cusnum).Phoenix_Customer__r.AccountNumber;
                    }
                 }
                if(gcpSFRec.Vision_Material_Number__c != null){
                    gcpSFRec.Vision_Product__c = skuCodePrdMap.containsKey(gcpSFRec.Vision_Material_Number__c) ? skuCodePrdMap.get(gcpSFRec.Vision_Material_Number__c).Id : gcpSFRec.Vision_Product__c;
                    
                }
                else if (gcpSFRec.Vision_NDC__c != null){
                    System.debug('--- Before NDC ---'+gcpSFRec.Vision_NDC__c );
                    String ndcCode = gcpSFRec.Vision_NDC__c.replaceFirst('^0+', '');
                    System.debug('--- Before NDC ---'+gcpSFRec.Vision_NDC__c );
                    if(ndc11prodMap.containsKey(ndcCode)){                        gcpSFRec.Vision_Product__c = ndc11prodMap.get(ndcCode).Id;
                    }
                    else if (ndc10prodMap.containsKey(ndcCode)){                        gcpSFRec.Vision_Product__c  = ndc10prodMap.get(ndcCode).Id;
                    }
                }
                else{                    gcpSFRec.Vision_Product__c = gcpSFRec.Vision_Product__c;
                }
                gcpSFRec.Vision_Update_Date__c = system.today();
                gcpSFRec.Vision_Unique_Identifier__c   = gcpSFRec.Vision_Contract_ID__c+'_'+gcpSFRec.Vision_Material_Number__c+'_'+gcpSFRec.Vision_Settlement_Date_From__c;
                gcp_unique_ids.add(gcpSFRec.Vision_Unique_Identifier__c );
                finalGCPrecordsMap.put(gcpSFRec.Vision_Unique_Identifier__c ,gcpSFRec); 
            }
            //Existing GCP records map for linking
            for(GCP_SFDC_Indirect_Sales__c gcp : [select Id,Vision_Unique_Identifier__c From GCP_SFDC_Indirect_Sales__c Where Vision_Unique_Identifier__c in : gcp_unique_ids]){
                finalGCPrecordsMap.get(gcp.Vision_Unique_Identifier__c).Id = gcp.Id;
            }
            finalGCPrecords.AddAll(finalGCPrecordsMap.values());
            upsert finalGCPrecords;
        	
        }
   Catch(Exception e) {            Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'GoogleSFDCIndirectSalesFetch', Phoenix_Error_Message__c = e.getMessage()+' '+currentField, Phoenix_Issue_Status__c = 'Pending', Phoenix_Method_Name__c = 'execute', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');insert exp;
        }
        
    }
    
    public void finish(Database.BatchableContext BC) {
        //Plan for next run
        System.debug('Total Row Count is ======> '+totalRows + '   Limit Val is ======> ' +limitVal);
        if(!Test.isRunningTest()){
            try{
                if(totalRows == limitVal){
                    offSet = offSet + limitVal;
                    Database.executeBatch(new GoogleSFDCIndirectSalesFetch(limitVal,offSet));
                }
                else{
                    Integer Records=[select count() from GCP_SFDC_Indirect_Sales__c ];
                    string RecordsCount= String.valueOf(Records);
                    Phoenix_Util.sendBatchJobCompletionEmail('SFDC Indirect sales ', RecordsCount);
                    Database.executeBatch(new Rx_Compliance_Direct_Sales_Summary_Batch());
                } 
            }
            Catch(Exception e) {Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'GoogleSFDCIndirectSalesFetch', Phoenix_Error_Message__c = e.getMessage(), Phoenix_Issue_Status__c = 'Pending', Phoenix_Method_Name__c = 'execute', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');insert exp;
            }
        }
    }

    
}