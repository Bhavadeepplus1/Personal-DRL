public class GoogleSFDCOrderStatusFetch implements Database.Batchable < sObject > , Database.Stateful,Schedulable,Database.AllowsCallouts {
    public Integer limitVal;
    public Integer offSet;
    Integer receivedCount;
    Integer totalRows;
    public GoogleSFDCOrderStatusFetch(Integer limitValue,Integer offSetValue){
        limitVal = limitValue;
        offSet = offSetValue;
    }
    
    public GoogleSFDCOrderStatusFetch(){
        limitVal = 100;
        offSet = 0;
    }
    
    public void execute(SchedulableContext sc) {
        Database.executeBatch(new GoogleSFDCOrderStatusFetch());
    }
    
    public Database.QueryLocator start(Database.BatchableContext BC) {
        delete [Select Id FROM Vision_GCP_SFDC_Order_Status__c WHERE CreatedDate != Today LIMIT 10000];
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
          //  String query = 'SELECT * FROM agg_zone.sfdc_order_status ;
           // String body = '{"query":"'+query+'"}';
           // req.setBody(body);
            req.setBody('{"query":"SELECT * FROM agg_zone.sfdc_order_status LIMIT '+ limitVal+' OFFSET '+offSet+'"}');
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
                res.setBody('{ "kind": "bigquery#queryResponse", "schema": { "fields": [ { "name": "order_number", "type": "STRING", "mode": "NULLABLE" }, { "name": "sku_code", "type": "STRING", "mode": "NULLABLE" }, { "name": "customer_code", "type": "STRING", "mode": "NULLABLE" }, { "name": "po_number", "type": "STRING", "mode": "NULLABLE" }, { "name": "order_qty", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "delivery_qty", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "open_order_qty", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "order_date", "type": "DATE", "mode": "NULLABLE" }, { "name": "requested_delivery_date", "type": "DATE", "mode": "NULLABLE" }, { "name": "sold_to_customer_code", "type": "STRING", "mode": "NULLABLE" }, { "name": "sold_to_customer_name", "type": "STRING", "mode": "NULLABLE" }, { "name": "net_amount", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "po_date", "type": "DATE", "mode": "NULLABLE" }, { "name": "delivery_date", "type": "DATE", "mode": "NULLABLE" }, { "name": "goods_issue_date", "type": "DATE", "mode": "NULLABLE" }, { "name": "rejection_reason", "type": "STRING", "mode": "NULLABLE" }, { "name": "description", "type": "STRING", "mode": "NULLABLE" }, { "name": "ndc_code", "type": "STRING", "mode": "NULLABLE" }, { "name": "ndc_desc", "type": "STRING", "mode": "NULLABLE" }, { "name": "street", "type": "STRING", "mode": "NULLABLE" }, { "name": "postal_code", "type": "STRING", "mode": "NULLABLE" }, { "name": "order_status", "type": "STRING", "mode": "NULLABLE" }, { "name": "net_value", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "pgi_date", "type": "DATE", "mode": "NULLABLE" }, { "name": "tracking_number", "type": "STRING", "mode": "NULLABLE" }, { "name": "delivery_number", "type": "STRING", "mode": "NULLABLE" }, { "name": "ship_to_customer_name", "type": "STRING", "mode": "NULLABLE" }, { "name": "Gcp_update_date", "type": "DATE", "mode": "NULLABLE" } ] }, "jobReference": { "projectId": "nag-analytics", "jobId": "job_Xzs6Ca5EZqmkvfzCyVt1g4D3s6Sz", "location": "asia-south1" }, "totalRows": "1", "rows": [ { "f": [ { "v": "21039180" }, { "v": "300000906" }, { "v": "0000108059" }, { "v": "00000000000000031330" }, { "v": "96.0" }, { "v": "96.0" }, { "v": "0.0" }, { "v": "2022-02-25" }, { "v": "2022-03-02" }, { "v": "0000106131" }, { "v": "GOLUB CORPORATION" }, { "v": "203.12" }, { "v": "2022-02-25" }, { "v": "2022-03-02" }, { "v": "1900-01-01" }, { "v": " " }, { "v": " " }, { "v": "05511118015" }, { "v": "TIZANIDINE TABLETS 4MG, 150" }, { "v": "501 DUANESBURG ROAD" }, { "v": "0000012306" }, { "v": "NOT DELIVERED" }, { "v": "212.16" }, { "v": null }, { "v": null }, { "v": null }, { "v": null }, { "v": "2022-03-01" } ] } ], "totalBytesProcessed": "117111341", "jobComplete": true, "cacheHit": false }');
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
              gcpSfFieldsMap.put('unique_identifier','GCP_Unique_Identifier__c');
              gcpSfFieldsMap.put('doc_item','Vision_Doc_Item__c');
            
            
            gcpSfFieldsMap.put('order_number','Vision_Order_Number__c');
            gcpSfFieldsMap.put('sku_code','Vision_SKU_Code__c');
            gcpSfFieldsMap.put('customer_code','Vision_Customer_Code__c');
            gcpSfFieldsMap.put('po_number','Vision_PO_Number__c');
            gcpSfFieldsMap.put('order_qty','Vision_Order_Quantity__c'); 
            gcpSfFieldsMap.put('delivery_qty','Vision_Delivery_Quantity__c'); 
            gcpSfFieldsMap.put('open_order_qty','Vision_Open_Order_Quantity__c'); 
            gcpSfFieldsMap.put('order_date','Vision_Order_Date__c'); 
            gcpSfFieldsMap.put('requested_delivery_date','Vision_Requested_Delivery_Date__c'); 
            gcpSfFieldsMap.put('sold_to_customer_code','Vision_Sold_to_Customer_Code__c'); 
            gcpSfFieldsMap.put('sold_to_customer_name','Vision_Sold_to_Customer_Name__c'); 
            gcpSfFieldsMap.put('net_amount','Vision_Net_Amount__c'); 
            gcpSfFieldsMap.put('po_date','Vision_PO_Date__c'); 
            gcpSfFieldsMap.put('delivery_date','Vision_Delivery_Date__c'); 
            gcpSfFieldsMap.put('goods_issue_date','Vision_Goods_Issue_Date__c');
            gcpSfFieldsMap.put('rejection_reason','Vision_Rejection_Reason__c');
            gcpSfFieldsMap.put('description','Vision_Description__c');
            gcpSfFieldsMap.put('ndc_code','Vision_NDC_Code__c');
            gcpSfFieldsMap.put('ndc_desc','Vision_NDC_Desc__c');
            gcpSfFieldsMap.put('street','Vision_Street__c');
           // gcpSfFieldsMap.put('postal_code','Vision_Postal_Code__c');
            gcpSfFieldsMap.put('order_status','Vision_Order_Status__c');
            gcpSfFieldsMap.put('net_value','Vision_Net_Value__c');
            gcpSfFieldsMap.put('delivery_create_date','Vision_Delivery_Created_Date__c');
            
            gcpSfFieldsMap.put('pgi_date','Vision_PGI_Date__c');
            gcpSfFieldsMap.put('tracking_number','Vision_Tracking_Number__c');
            gcpSfFieldsMap.put('delivery_number','Vision_Delivery_Number__c');
            gcpSfFieldsMap.put('quantity_in_order_uom','Vision_GCP_Quantity_in_Order_UOM__c');
            
            gcpSfFieldsMap.put('ship_to_customer_name','Vision_Ship_to_Customer_Name__c');
            gcpSfFieldsMap.put('shipping_method','Vision_GCP_Shipping_Method__c');
             gcpSfFieldsMap.put('ship_qty','Vision_GCP_Ship_Quanity__c');
             gcpSfFieldsMap.put('price','Vision_GCP_Price__c');
            
             gcpSfFieldsMap.put('ship_date','Vision_GCP_Ship_Date__c');
             gcpSfFieldsMap.put('ship_location_city','Vision_GCP_Ship_Location_City__c');
             gcpSfFieldsMap.put('ship_location_state','Vision_GCP_Ship_Location_State__c');
            
            gcpSfFieldsMap.put('Gcp_update_date','Vision_GCP_Update_Date__c');
            gcpSfFieldsMap.put('created_date','Vision_Created_Date__c');
            
            // adding decimal fields to a list
            List<String> decimalFields = new List<String>();
            List<String> dateFields = new List<String>();
            List<String> dateTimeFields = new List<String>();
            String SobjectApiName = 'Vision_GCP_SFDC_Order_Status__c';
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
                else if(fldStringType == 'DATETIME'){
                    dateTimeFields.add(fieldName);
                }
            }
            system.debug('decimalFields : '+decimalFields);
            system.debug('dateFields : '+dateFields);
            List<Vision_GCP_SFDC_Order_Status__c> finalGCPrecords = new List<Vision_GCP_SFDC_Order_Status__c>();
            Set<String> gcp_unique_ids = new Set<String>();
            Map<String,Vision_GCP_SFDC_Order_Status__c> finalGCPrecordsMap = new Map<String,Vision_GCP_SFDC_Order_Status__c>();
            for(Integer rowCounter : gbqrw.jsonRowMap.keySet()){//1
                Map<Integer,String> tempRowMap = gbqrw.jsonRowMap.get(rowCounter);
                Vision_GCP_SFDC_Order_Status__c gcpSFRec = new Vision_GCP_SFDC_Order_Status__c();
                
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
                        else if(dateTimeFields.contains(fieldName.toLowerCase()))
                        {
                            gcpSFRec.put(fieldName , DateTime.Valueof(fieldValue.replace('T', ' ')));
                        }
                        else{
                            gcpSFRec.put(fieldName , fieldValue);
                        }
                        
                    }
                    
                }
                if(gcpSFRec.Vision_Customer_Code__c != null){
                    String cusCode = gcpSFRec.Vision_Customer_Code__c.replaceFirst('^0+', '');
                    gcpSFRec.Vision_Account__c = accMap.containsKey(cusCode) ? accMap.get(cusCode).Id : gcpSFRec.Vision_Account__c;
                }
                if(gcpSFRec.Vision_SKU_Code__c != null){
                    gcpSFRec.Vision_Product__c = skuCodePrdMap.containsKey(gcpSFRec.Vision_SKU_Code__c) ? skuCodePrdMap.get(gcpSFRec.Vision_SKU_Code__c).Id : gcpSFRec.Vision_Product__c;
                }
                
               	gcpSFRec.Vision_GCP_Unique_Identifier__c   =gcpSFRec.Vision_Doc_Item__c.trim()+'_'+ gcpSFRec.Vision_Order_Number__c.trim()+'_'+gcpSFRec.Vision_SKU_Code__c.trim();
                gcp_unique_ids.add(gcpSFRec.Vision_GCP_Unique_Identifier__c );
                finalGCPrecordsMap.put(gcpSFRec.Vision_GCP_Unique_Identifier__c ,gcpSFRec);
                
            }
            //Existing GCP records map for linking
            for(Vision_GCP_SFDC_Order_Status__c gcp : [select Id,Vision_GCP_Unique_Identifier__c From Vision_GCP_SFDC_Order_Status__c Where Vision_GCP_Unique_Identifier__c in : gcp_unique_ids]){
                finalGCPrecordsMap.get(gcp.Vision_GCP_Unique_Identifier__c).Id = gcp.Id;
            }
            finalGCPrecords.AddAll(finalGCPrecordsMap.values());
            upsert finalGCPrecords; 
        }
            
        Catch(Exception e) {
            Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'GoogleSFDCOrderStatusFetch', Phoenix_Error_Message__c = e.getMessage()+' '+currentField, Phoenix_Issue_Status__c = 'Pending', Phoenix_Method_Name__c = 'execute', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
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
                	Database.executeBatch(new GoogleSFDCOrderStatusFetch(limitVal,offSet));
                }
                else{
                    // storing MAX of GCP_Update_Date__c, in custom label
                   Vision_GCP_SFDC_Order_Status__c cusOrdRec = [select Vision_GCP_Update_Date__c from Vision_GCP_SFDC_Order_Status__c limit 1];
                    String Vision_gcp_update_date  = String.valueOf(cusOrdRec.Vision_GCP_Update_Date__c).substringbefore(' ');
                    String Vision_update_date = String.valueOf(Phoenix_Util.getTodayEST()).substringbefore(' ');
                    system.debug('--Vision_gcp_update_date--'+Vision_gcp_update_date);
                    system.debug('--Vision_update_date--'+Vision_update_date);
                    cus_ord_trend_dates_info__c  cotdi = cus_ord_trend_dates_info__c.getInstance('Data1');
                    cotdi.Vision_GCP_Update_Date__c = Vision_gcp_update_date;
                    cotdi.Vision_Update_Date__c = Vision_update_date;
                    update cotdi;
                    Integer Records=[select count() from Vision_GCP_SFDC_Order_Status__c ];
                    string RecordsCount= String.valueOf(Records);
                    Phoenix_Util.sendBatchJobCompletionEmail('The batch SFDC Order Status is ran now in '+system.label.Org_Name, RecordsCount);
                }
                
        
            }
            Catch(Exception e) {
                Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'GoogleSFDCOrderStatusFetch', Phoenix_Error_Message__c = e.getMessage(), Phoenix_Issue_Status__c = 'Pending', Phoenix_Method_Name__c = 'execute', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
                insert exp;
            }
        }
    }
    
}