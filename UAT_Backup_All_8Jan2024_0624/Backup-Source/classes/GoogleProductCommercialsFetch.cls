public class GoogleProductCommercialsFetch implements Database.Batchable < sObject > , Database.Stateful,Schedulable,Database.AllowsCallouts {
    public Integer limitVal;
    public Integer offSet;
    Integer receivedCount;
    Integer totalRows;
    public GoogleProductCommercialsFetch(Integer limitValue,Integer offSetValue){
        limitVal = limitValue;
        offSet = offSetValue;
    }
    
    public GoogleProductCommercialsFetch(){
        limitVal = 100;
        offSet = 0;
    }
    
    public void execute(SchedulableContext sc) {
        Database.executeBatch(new GoogleProductCommercialsFetch());
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
          //  req.setEndpoint('https://bigquery.googleapis.com/bigquery/v2/projects/nag-analytics/queries');
            req.setHeader('Content-type', 'application/json');
            req.setHeader('Authorization', 'Bearer ' + auth.getAccessToken());
            req.setBody('{"query":"SELECT * FROM agg_zone.sfdc_product_commercial_dtls LIMIT '+ limitVal+' OFFSET '+offSet+'"}');
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
                res.setBody('{ "kind": "bigquery#queryResponse", "schema": { "fields": [ { "name": "trade_partner_name", "type": "STRING", "mode": "NULLABLE" }, { "name": "package_description", "type": "STRING", "mode": "NULLABLE" }, { "name": "ndc", "type": "STRING", "mode": "NULLABLE" }, { "name": "wac_price", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "w1_day", "type": "DATE", "mode": "NULLABLE" }, { "name": "w2_day", "type": "DATE", "mode": "NULLABLE" }, { "name": "w3_day", "type": "DATE", "mode": "NULLABLE" }, { "name": "w4_day", "type": "DATE", "mode": "NULLABLE" }, { "name": "w1_qty_sold", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "w2_qty_sold", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "w3_qty_sold", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "w4_qty_sold", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "w1_qoh", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "w2_qoh", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "w3_qoh", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "w4_qoh", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "w1_doh", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "w2_doh", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "w3_doh", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "w4_doh", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "wac_value", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "high_flag", "type": "INTEGER", "mode": "NULLABLE" }, { "name": "low_flag", "type": "INTEGER", "mode": "NULLABLE" }, { "name": "sf_account_code", "type": "STRING", "mode": "NULLABLE" }, { "name": "sf_id", "type": "STRING", "mode": "NULLABLE" } ] }, "jobReference": { "projectId": "nag-analytics", "jobId": "job_wdoe4O3yTcsioohgQ69KpY8j0NeQ", "location": "asia-south1" }, "totalRows": "1", "rows": [ { "f": [ { "v": "CAPITAL WHOLESALE DRUG CO" }, { "v": "IMATINIB MESYLATE 400MG X 30 (TABS)" }, { "v": "4359834531" }, { "v": "2700.0" }, { "v": "2021-12-23" }, { "v": "2021-12-30" }, { "v": "2022-01-06" }, { "v": "2022-01-13" }, { "v": "0.0" }, { "v": "3.0" }, { "v": "1.0" }, { "v": "0.0" }, { "v": "10.0" }, { "v": "6.0" }, { "v": "5.0" }, { "v": "0.0" }, { "v": "82.73" }, { "v": "49.64" }, { "v": "37.92" }, { "v": "0.0" }, { "v": "0.0" }, { "v": "0" }, { "v": "1" }, { "v": "157919" }, { "v": "0010n00001Dbj1EAAR" } ] } ], "totalBytesProcessed": "929045", "jobComplete": true, "cacheHit": false }');
                gcpResponse = res.getBody();
            }
            //System.debug('GCP Response is ====>'+gcpResponse);
            
            // Parsing BigQuery Response
            GoogleBigQuery.GoogleBigQueryRespWrapper gbqrw = GoogleBigQuery.RespParser(gcpResponse);
            totalRows = gbqrw.totalRows;
            
            //Account map for linking
            map<String,Account> accMap =new Map<String,Account>();
            for( Account acc : [select id,name,accountNumber From Account where accountNumber != null ])accMap.put(acc.accountNumber,acc);
            
            //Product map for linking
            map<String,Product2> prodMap =new Map<String,Product2>();
            for( Product2 prod : [select Id,name,ProductCode,Phoenix_NDC__c, Phoenix_NDC_11__c   From Product2 where ProductCode != null  and IsActive = true AND Phoenix_Is_Exclude_Bid__c = false  ])prodMap.put(prod.ProductCode,prod);
            
            //Existing GCP records map for linking
            map<String,String> existingProductFamilyMap =new Map<String,String>();
            for(GCP_Product_Family_Map__c  prdfmy : [select id,GCP_Product_Family__c, SFDC_Product_Family__c From GCP_Product_Family_Map__c])
            {
                existingProductFamilyMap.put(prdfmy.GCP_Product_Family__c,prdfmy.SFDC_Product_Family__c); 
            }
            Map<String,String> gcpSfFieldsMap = new Map<String,String>();
            gcpSfFieldsMap.put('reporting_molecule','GCP_Product_Family__c');
            gcpSfFieldsMap.put('Product_Code','Product_Code__c');
            gcpSfFieldsMap.put('Product_Name','Product_Name__c');
            gcpSfFieldsMap.put('segment','Segment__c');
            gcpSfFieldsMap.put('NDC_code','NDC_Code__c');
            gcpSfFieldsMap.put('Brand_Name','Brand_Name__c');
            gcpSfFieldsMap.put('Generic_Name','Generic_Name__c');
            gcpSfFieldsMap.put('Dosage_Form','Dosage_Form__c');
            gcpSfFieldsMap.put('Package_Size','Package_Size__c');
            gcpSfFieldsMap.put('Package_Description','Package_Description__c');
            gcpSfFieldsMap.put('Strength','Strength__c');
            gcpSfFieldsMap.put('Billing_Unit','Billing_Unit__c');
            gcpSfFieldsMap.put('GPI_Generic_Product_Identifier','GPI_Generic_Product_Identifier__c');
            gcpSfFieldsMap.put('GCN','GCN__c');
            gcpSfFieldsMap.put('GSN','GSN__c');
            gcpSfFieldsMap.put('Orange_Book_Code','Orange_Book_Code__c'); 
            gcpSfFieldsMap.put('WAC_Current_Package_Price','WAC_Current_Package_Price__c');
            //  gcpSfFieldsMap.put('WAC_Current_Effective_Date','WAC_Current_Effective_Date__c');
            gcpSfFieldsMap.put('AWP_Current_Package_Price','AWP_Current_Package_Price__c');
            //   gcpSfFieldsMap.put('AWP_Current_Effective_Date','AWP_Current_Effective_Date__c');
            
            
            // adding decimal fields to a list
            List<String> decimalFields = new List<String>();
            List<String> dateFields = new List<String>();
            String SobjectApiName = 'GCP_Product_Commercials__c';
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
            List<GCP_Product_Commercials__c> finalGCPrecords = new List<GCP_Product_Commercials__c>();
            
            Set<String> gcp_unique_ids = new Set<String>();
            Map<String,GCP_Product_Commercials__c> finalGCPrecordsMap = new Map<String,GCP_Product_Commercials__c>();
            for(Integer rowCounter : gbqrw.jsonRowMap.keySet()){//1
                Map<Integer,String> tempRowMap = gbqrw.jsonRowMap.get(rowCounter);
                GCP_Product_Commercials__c gcpSFRec = new GCP_Product_Commercials__c();
                
                for(Integer valNo : tempRowMap.keySet()){
                    String fieldName = gcpSfFieldsMap.get(gbqrw.jsonFieldMap.get(valNo));
                    currentField = fieldName;
                    String fieldValue = tempRowMap.get(valNo);
                    
                    if(fieldValue != null && fieldName != null){
                        fieldValue = fieldValue.remove('$').remove(',');
                      
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
                //if(String.isNotBlank(gcpSFRec.GCP_SF_Account_Code__c)){
                //  gcpSFRec.Vision_Customer__c  = accMap.containsKey(gcpSFRec.GCP_SF_Account_Code__c ) ? accMap.get(gcpSFRec.GCP_SF_Account_Code__c).Id : gcpSFRec.Vision_Customer__c;
                //}
                gcpSFRec.Vision_Product__c  = prodMap.containsKey(gcpSFRec.Product_Code__c) ? prodMap.get(gcpSFRec.Product_Code__c).Id : gcpSFRec.Vision_Product__c;
                gcpSFRec.Vision_Product_Family__c  = existingProductFamilyMap.containsKey(gcpSFRec.GCP_Product_Family__c) ? existingProductFamilyMap.get(gcpSFRec.GCP_Product_Family__c) : null;
                //finalGCPrecords.add(gcpSFRec);
                //gcpSFRec.Vision_GCP_Unique_Identifier__c   = gcpSFRec.Product_Code__c;
                gcp_unique_ids.add(gcpSFRec.Product_Code__c);
                finalGCPrecordsMap.put(gcpSFRec.Product_Code__c,gcpSFRec);
                
            }
            
             //Existing GCP records map for linking
            for(GCP_Product_Commercials__c gcp : [select Id,Product_Code__c  From GCP_Product_Commercials__c Where Product_Code__c in : gcp_unique_ids]){
                finalGCPrecordsMap.get(gcp.Product_Code__c).Id = gcp.Id;
            }
            finalGCPrecords.AddAll(finalGCPrecordsMap.values());
            upsert finalGCPrecords; 
            
            List<Product2> finalProductsUpdate = new List<Product2>();
            for(GCP_Product_Commercials__c gcp : finalGCPrecords){
                if(gcp.Vision_Product__c != null &&(gcp.GCN__c != null || gcp.GSN__c != null || gcp.GPI_Generic_Product_Identifier__c != null)){
                    Product2 prod = new Product2(id=gcp.Vision_Product__c);
                    if(gcp.GCN__c != null)    prod.Phoenix_GCN_Generic_Code_Number__c=gcp.GCN__c;
                    if(gcp.GSN__c != null)   prod.Phoenix_GCN_Sequence_Number__c =gcp.GSN__c;
                    if(gcp.GPI_Generic_Product_Identifier__c != null) prod.Phoenix_GPI_Generic_Product_Identifier__c=gcp.GPI_Generic_Product_Identifier__c.replaceAll('-', '');                         
                    
                    
                    finalProductsUpdate.add(prod);  
                }  
            }
            System.debug('finalProductsUpdate count==> '+finalProductsUpdate.size());
            if(!finalProductsUpdate.isEmpty()) update finalProductsUpdate; 
            
        }
        Catch(Exception e) {
            Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'GoogleProductCommercialsFetch', Phoenix_Error_Message__c = e.getMessage()+' '+currentField, Phoenix_Issue_Status__c = 'Pending', Phoenix_Method_Name__c = 'execute', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
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
                       Database.executeBatch(new GoogleProductCommercialsFetch(limitVal,offSet));
                }
                else{
                    Integer Records=[select count() from GCP_Product_Commercials__c ];
                string RecordsCount='Total Records are '+ String.valueOf(Records);
                
                Phoenix_Util.sendBatchJobCompletionEmail('GCP Product Commercials ', RecordsCount);
                }
            }
            Catch(Exception e) {
                Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'GoogleProductCommercialsFetch', Phoenix_Error_Message__c = e.getMessage(), Phoenix_Issue_Status__c = 'Pending', Phoenix_Method_Name__c = 'execute', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
                insert exp;
            }
        }
    }
    
}