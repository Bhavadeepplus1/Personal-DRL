public class GoogleBackOrderSRxandRxFetch implements Database.Batchable <sObject > , Database.Stateful,Schedulable,Database.AllowsCallouts {
    public Integer limitVal;
    public Integer offSet;
    Integer receivedCount;
    Integer totalRows;
    public  GoogleBackOrderSRxandRxFetch(Integer limitValue,Integer offSetValue){
        limitVal = limitValue;
        offSet = offSetValue;
    }
    
    public  GoogleBackOrderSRxandRxFetch(){
        limitVal = 100;
        offSet = 0;
    }
    
    public void execute(SchedulableContext sc) {
        Database.executeBatch(new  GoogleBackOrderSRxandRxFetch());
    }
    
    public Database.QueryLocator start(Database.BatchableContext BC) {
        delete [Select Id FROM Vision_GCP_Backorder_SRx_Rx__c WHERE CreatedDate != Today LIMIT 10000];
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
            req.setHeader('Content-type', 'application/json');
            req.setHeader('Authorization', 'Bearer ' + auth.getAccessToken());
            req.setBody('{"query":"SELECT * FROM agg_zone.sfdc_back_order_srx_rx LIMIT '+ limitVal+' OFFSET '+offSet+'"}');
            Http http = new Http();
            HTTPResponse res = new HTTPResponse();
            if(!Test.isRunningTest()) { res = http.send(req);
               
            }
            else {
                res.setBody('{ "kind": "bigquery#queryResponse", "schema": { "fields": [ { "name": "customer_code", "type": "STRING", "mode": "NULLABLE" }, { "name": "salesforce_id", "type": "STRING", "mode": "NULLABLE" }, { "name": "customer_name", "type": "STRING", "mode": "NULLABLE" }, { "name": "order_number", "type": "STRING", "mode": "NULLABLE" }, { "name": "customer_po", "type": "STRING", "mode": "NULLABLE" }, { "name": "ndc_code", "type": "STRING", "mode": "NULLABLE" }, { "name": "sku_code", "type": "STRING", "mode": "NULLABLE" }, { "name": "sku_desc", "type": "STRING", "mode": "NULLABLE" }, { "name": "segment", "type": "STRING", "mode": "NULLABLE" }, { "name": "reporting_molecule", "type": "STRING", "mode": "NULLABLE" }, { "name": "order_qty", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "order_date", "type": "DATE", "mode": "NULLABLE" }, { "name": "order_week", "type": "STRING", "mode": "NULLABLE" }, { "name": "order_month", "type": "STRING", "mode": "NULLABLE" }, { "name": "order_status", "type": "STRING", "mode": "NULLABLE" }, { "name": "ship_qty", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "ship_date", "type": "DATE", "mode": "NULLABLE" }, { "name": "delivery_number", "type": "STRING", "mode": "NULLABLE" }, { "name": "tracking_number", "type": "STRING", "mode": "NULLABLE" }, { "name": "price", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "ship_location_city", "type": "STRING", "mode": "NULLABLE" }, { "name": "ship_location_state", "type": "STRING", "mode": "NULLABLE" }, { "name": "ship_to_customer", "type": "STRING", "mode": "NULLABLE" }, { "name": "requested_delivery_date", "type": "DATE", "mode": "NULLABLE" }, { "name": "delivery_date", "type": "DATE", "mode": "NULLABLE" }, { "name": "top_five_indicator", "type": "STRING", "mode": "NULLABLE" } ] }, "jobReference": { "projectId": "nag-analytics", "jobId": "job_Q-mIfobYrk7fRq1jn5bcV4RN8ho3", "location": "asia-south1" }, "totalRows": "3", "rows": [ { "f": [ { "v": "162799" }, { "v": null }, { "v": null }, { "v": "0021024295" }, { "v": "1208213RDY" }, { "v": "04359826704" }, { "v": "300034059" }, { "v": "Icosapent Ethyl Capsules 1g 120" }, { "v": "RX" }, { "v": "ICOSAPENT ETHYL" }, { "v": "288.0" }, { "v": "2021-12-09" }, { "v": "WK 05 Dec 2021" }, { "v": "Dec 2021" }, { "v": "COMPLETED" }, { "v": "288.0" }, { "v": null }, { "v": null }, { "v": null }, { "v": "178.83274305555557" }, { "v": "Lakeland" }, { "v": "FL" }, { "v": "Clearview Procurement, LLC" }, { "v": "2021-12-15" }, { "v": "2021-12-15" }, { "v": null } ] } ], "totalBytesProcessed": "96301448", "jobComplete": true, "cacheHit": false }');
                gcpResponse = res.getBody();
            }
			 if (res.getStatusCode() == 200) {
                    gcpResponse = res.getBody();
                }
                else {                    System.debug('The status code returned was not expected: ' +res.getStatusCode() + ' ' + res.getStatus());
                }
            //System.debug('GCP Response is ====>'+gcpResponse);
            
            // Parsing BigQuery Response
            GoogleBigQuery.GoogleBigQueryRespWrapper gbqrw = GoogleBigQuery.RespParser(gcpResponse);
            totalRows = gbqrw.totalRows;
            
            //Account map for linking
            map<String,Account> accMap =new Map<String,Account>();
            for( Account acc : [select id,name,accountNumber From Account where accountNumber != null])accMap.put(acc.accountNumber,acc);
            
            //Existing GCP records map for linking
            map<String,String> existingProductFamilyMap =new Map<String,String>();
            for(GCP_Product_Family_Map__c  prdfmy : [select id,GCP_Product_Family__c, SFDC_Product_Family__c From GCP_Product_Family_Map__c])
            {
                existingProductFamilyMap.put(prdfmy.GCP_Product_Family__c,prdfmy.SFDC_Product_Family__c); 
            }
            //Product map for linking
            map<String,Product2> skuprodMap =new Map<String,Product2>();
            for( Product2 prod : [select Id,name,ProductCode From Product2 where ProductCode != null ]){
                skuprodMap.put(prod.ProductCode,prod);
            }
            Map<String,String> gcpSfFieldsMap = new Map<String,String>();
            gcpSfFieldsMap.put('SKU_Description','Vision_SKU_Description__c');
            gcpSfFieldsMap.put('unique_id','GCP_Hash_Key__c');
            gcpSfFieldsMap.put('SKU_Code','Vision_SKU_Code__c');
            gcpSfFieldsMap.put('Manufacturer','Vision_Manufacturer__c');
            gcpSfFieldsMap.put('Pack_Size','Vision_Pack_Size__c');
            gcpSfFieldsMap.put('NDC','Vision_ndc__c'); 
            gcpSfFieldsMap.put('Latest_Report_Date','Vision_Latest_Report_Date__c'); 
            gcpSfFieldsMap.put('past_week_Report_Date','Vision_Past_Week_Report_Date__c'); 
            gcpSfFieldsMap.put('Demand_In_Tab_Cap','Vision_Demand_In_Tab_Cap__c'); 
            gcpSfFieldsMap.put('Expected_Monthly_Sales','Vision_Expected_Monthly_Sales__c'); 
            gcpSfFieldsMap.put('Avg_unit_Price','Vision_Avg_unit_Price__c'); 
            gcpSfFieldsMap.put('Order_Qty','Vision_Order_Qty__c');
            gcpSfFieldsMap.put('past_week_order_Qty','Vision_Past_Week_Order_Quantity__c'); 
            gcpSfFieldsMap.put('Order_Value','Vision_Order_Value__c');
            gcpSfFieldsMap.put('past_week_order_value','Vision_Past_Week_Order_Value__c'); 
            gcpSfFieldsMap.put('Backorder_Qty','Vision_Backorder_Qty__c'); 
            gcpSfFieldsMap.put('past_week_backorder_Qty','Vision_Past_Week_BackOrder_Quantity__c'); 
            gcpSfFieldsMap.put('Back_Order_Value','Vision_Back_Order_Value__c');
            gcpSfFieldsMap.put('past_week_back_order_Value','Vision_Past_Week_Backorder_Value__c'); 
            gcpSfFieldsMap.put('Inventory_in_Transit','Vision_Inventory_in_Transit__c'); 
            gcpSfFieldsMap.put('Total_in_Transit','Vision_Total_in_Transit__c'); 
            gcpSfFieldsMap.put('Date_Dispatched','Vision_Date_Dispatched__c');
            gcpSfFieldsMap.put('Stocks_at_UPS','Vision_Stocks_at_UPS__c');
            gcpSfFieldsMap.put('MoH','Vision_MoH__c');
            gcpSfFieldsMap.put('past_week_Moh','Vision_Past_Week_MOH__c');
            gcpSfFieldsMap.put('Week_1','Vision_Week_1__c');
            gcpSfFieldsMap.put('Week_2','Vision_Week_2__c');
            gcpSfFieldsMap.put('COMMIT_Week1','Vision_COMMIT_Week1__c');
            gcpSfFieldsMap.put('COMMIT_Week2','Vision_COMMIT_Week2__c');
            gcpSfFieldsMap.put('MoH_Post_2_week','Vision_MoH_Post_2_week__c');
            gcpSfFieldsMap.put('Comments','Vision_Comments__c');
	    gcpSfFieldsMap.put('past_week_comments','Vision_Past_Week_Comments__c');
            gcpSfFieldsMap.put('Inv_in_transit_Value','Vision_Inv_in_transit_Value__c');
            gcpSfFieldsMap.put('Back_Order_SKU_In_Transit','Vision_Back_Order_SKU_In_Transit__c');
            gcpSfFieldsMap.put('On_Backorder','Vision_On_Backorder__c');
            gcpSfFieldsMap.put('Available_for_Dropship','Vision_Available_for_Dropship__c');
            gcpSfFieldsMap.put('Anticipated_Date_of_Availability','Vision_Anticipated_Date_of_Availability__c');
          //  gcpSfFieldsMap.put('Backorder_Report_Date','Vision_Backorder_Report_Date__c');
            gcpSfFieldsMap.put('Gcp_Update_Date','Vision_GCP_Update_Date__c');
            
            // adding decimal fields to a list
            List<String> decimalFields = new List<String>();
            List<String> dateFields = new List<String>();
            String SobjectApiName = 'Vision_GCP_Backorder_SRx_Rx__c';
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
            List<Vision_GCP_Backorder_SRx_Rx__c> finalGCPrecords = new List<Vision_GCP_Backorder_SRx_Rx__c>();
            Set<String> gcp_unique_ids = new Set<String>();
            Map<String,Vision_GCP_Backorder_SRx_Rx__c> finalGCPrecordsMap = new Map<String,Vision_GCP_Backorder_SRx_Rx__c>();
            for(Integer rowCounter : gbqrw.jsonRowMap.keySet()){//1
                Map<Integer,String> tempRowMap = gbqrw.jsonRowMap.get(rowCounter);
                Vision_GCP_Backorder_SRx_Rx__c gcpSFRec = new Vision_GCP_Backorder_SRx_Rx__c();
                
                for(Integer valNo : tempRowMap.keySet()){
                    String fieldName = gcpSfFieldsMap.get(gbqrw.jsonFieldMap.get(valNo));
                    currentField = fieldName;
                    String fieldValue = tempRowMap.get(valNo);
                    if(fieldValue != null && fieldName != null){
                        if(decimalFields.contains(fieldName.toLowerCase())){
                            if(fieldValue.startsWith('-') && fieldValue.length() == 1 ){
                                gcpSFRec.put(fieldName , null);
                            }
                            else if(fieldValue.startsWith('MTO')){
                                gcpSFRec.put(fieldName , null);
                            }
                            else if(fieldValue.startsWith('-') && fieldValue.length()>1 ){
                                gcpSFRec.put(fieldName , Decimal.valueOf(fieldValue));
                            }
                            else{
                                gcpSFRec.put(fieldName , Decimal.valueOf(fieldValue));
                            }
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
                
                //gcpSFRec.Product_Family__c = existingProductFamilyMap.containsKey(gcpSFRec.GCP_Product_Family__c) ? existingProductFamilyMap.get(gcpSFRec.GCP_Product_Family__c) : null;
                if(gcpSFRec.Vision_Sku_Code__c != null){
                    if(skuprodMap.containsKey(gcpSFRec.Vision_Sku_Code__c)){
                        gcpSFRec.Vision_Product__c  = skuprodMap.get(gcpSFRec.Vision_Sku_Code__c).Id;
                    }
                    else{
                        gcpSFRec.Vision_Product__c  = gcpSFRec.Vision_Product__c;
                    }
                }
                gcpSFRec.Vision_GCP_Unique_Identifier__c   = gcpSFRec.GCP_Hash_Key__c;
                gcp_unique_ids.add(gcpSFRec.Vision_GCP_Unique_Identifier__c );
                finalGCPrecordsMap.put(gcpSFRec.Vision_GCP_Unique_Identifier__c ,gcpSFRec);
                
            }
            //Existing GCP records map for linking
            for(Vision_GCP_Backorder_SRx_Rx__c gcp : [select Id,Vision_GCP_Unique_Identifier__c From Vision_GCP_Backorder_SRx_Rx__c Where Vision_GCP_Unique_Identifier__c in : gcp_unique_ids]){
                finalGCPrecordsMap.get(gcp.Vision_GCP_Unique_Identifier__c).Id = gcp.Id;
            }
            finalGCPrecords.AddAll(finalGCPrecordsMap.values());
            upsert finalGCPrecords;            
        }
        Catch(Exception e) {            String msg = e.getMessage().length() > 255 ? e.getMessage().substring(0, 254) : e.getMessage();Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'GoogleBackOrderSRxandRxFetch', Phoenix_Error_Message__c = msg+' '+currentField, Phoenix_Issue_Status__c = 'Pending', Phoenix_Method_Name__c = 'execute', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');insert exp;
        }
        
    }
    
    public void finish(Database.BatchableContext BC) {
        //Plan for next run
        System.debug('Total Row Count is ======> '+totalRows + '   Limit Val is ======> ' +limitVal);
        if(!Test.isRunningTest()){
            try{
                if(totalRows == limitVal){
                    offSet = offSet + limitVal;
                    Database.executeBatch(new GoogleBackOrderSRxandRxFetch(limitVal,offSet));
                }
                else{

                    //add Custom setting Code
                    Vision_GCP_Backorder_SRx_Rx__c cusOrdRec = [select Vision_Gcp_Update_Date__c from Vision_GCP_Backorder_SRx_Rx__c limit 1];
                    String Vision_gcp_update_date  = String.valueOf(cusOrdRec.Vision_Gcp_Update_Date__c).substringbefore(' ');
                    String Vision_update_date = String.valueOf(Phoenix_Util.getTodayEST()).substringbefore(' ');
                    system.debug('--Vision_gcp_update_date--'+Vision_gcp_update_date);
                    system.debug('--Vision_update_date--'+Vision_update_date);
                    Back_Order_SRX_Dates_Info__c  cotdi = Back_Order_SRX_Dates_Info__c.getInstance('Data1');
                    cotdi.Vision_GCP_Update_Date__c = Vision_gcp_update_date;
                    cotdi.Vision_Update_Date__c = Vision_update_date;
                    update cotdi;
                    
                    Integer Records=[select count() from Vision_GCP_Backorder_SRx_Rx__c];
                    string RecordsCount= 'Total Records are '+String.valueOf(Records);
                  	Phoenix_Util.sendBatchJobCompletionEmail('GCP Backorder Rx and SRx ', RecordsCount);
                }
                
            }
            Catch(Exception e) {
                Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'GoogleBackOrderSRxandRxFetch', Phoenix_Error_Message__c = e.getMessage(), Phoenix_Issue_Status__c = 'Pending', Phoenix_Method_Name__c = 'execute', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
                insert exp;
            }
        }
        
        
    }
    
    
}