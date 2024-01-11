/**
 * @description       : 
 * @author            : Surender Patel
 * @group             : 
 * @last modified on  : 03-23-2022
 * @last modified by  : Surender Patel
**/
public class GoogleBackOrderOTCFetch implements Database.Batchable < sObject > , Database.Stateful,Schedulable,Database.AllowsCallouts {
    public Integer limitVal;
    public Integer offSet;
    Integer receivedCount;
    Integer totalRows;
    public GoogleBackOrderOTCFetch(Integer limitValue,Integer offSetValue){
        limitVal = limitValue;
        offSet = offSetValue;
    }
    
    public GoogleBackOrderOTCFetch(){
        limitVal = 100;
        offSet = 0;
    }
    
    public void execute(SchedulableContext sc) {
        Database.executeBatch(new GoogleBackOrderOTCFetch());
    }
    
    public Database.QueryLocator start(Database.BatchableContext BC) {
        //delete [Select Id FROM Vision_GCP_Backorder_OTC__c WHERE CreatedDate != Today LIMIT 200];
        return Database.getQueryLocator('Select Id FROM Account Limit 1');
    }
    
    public void execute(Database.BatchableContext BC, List < Account > accList) {
       system.debug('limit value.......'+limitVal);
        system.debug('off et value.......'+offSet);
        String currentField='';
        String gcpResponse = '';
      	try{
            //Query GCP
            GoogleAuthProvider auth = new GoogleAuthProvider();
            auth.authorize();
            HttpRequest req = new HttpRequest();
            req.setMethod('POST');
            req.setEndpoint(Label.bigQueryEndpoint);
            req.setHeader('Content-type', 'application/json');
            req.setHeader('Authorization', 'Bearer ' + auth.getAccessToken());
            
           // string s='\'2022-09-22\'';
             Vision_GCP_Backorder_OTC__c otcrec;
            if(!test.isRunningTest()){
          otcrec=[select Vision_Backorder_Report_Date__c from Vision_GCP_Backorder_OTC__c where createddate!=today order by Vision_Backorder_Report_Date__c desc limit 1];
           }
            else{
                otcrec=[select Vision_Backorder_Report_Date__c from Vision_GCP_Backorder_OTC__c limit 1];
            }
            
           // system.debug('otcrec....'+otcrec);
            datetime d=date.valueof(otcrec.Vision_Backorder_Report_Date__c);
   //date p= date.newInstanceGMT(d.year(),d.month(),d.day());
  //string o=otcrec.Vision_Backorder_Report_Date__c;
string s= '\''+d.formatGMT('yyyy-MM-dd')+'\'';
system.debug('ddv...'+s);
   //system.debug('date...'+p);         
req.setBody('{"query":"SELECT * FROM agg_zone.sfdc_back_order_otc where cast(Backorder_Report_Date as date) >  cast('+s+' as date) LIMIT '+ limitVal+' OFFSET '+offSet+'"}');
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
                res.setBody('{ "kind": "bigquery#queryResponse", "schema": { "fields": [ { "name": "customer_code", "type": "STRING", "mode": "NULLABLE" }, { "name": "salesforce_id", "type": "STRING", "mode": "NULLABLE" }, { "name": "customer_name", "type": "STRING", "mode": "NULLABLE" }, { "name": "order_number", "type": "STRING", "mode": "NULLABLE" }, { "name": "customer_po", "type": "STRING", "mode": "NULLABLE" }, { "name": "ndc_code", "type": "STRING", "mode": "NULLABLE" }, { "name": "sku_code", "type": "STRING", "mode": "NULLABLE" }, { "name": "sku_desc", "type": "STRING", "mode": "NULLABLE" }, { "name": "segment", "type": "STRING", "mode": "NULLABLE" }, { "name": "reporting_molecule", "type": "STRING", "mode": "NULLABLE" }, { "name": "order_qty", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "order_date", "type": "DATE", "mode": "NULLABLE" }, { "name": "order_week", "type": "STRING", "mode": "NULLABLE" }, { "name": "order_month", "type": "STRING", "mode": "NULLABLE" }, { "name": "order_status", "type": "STRING", "mode": "NULLABLE" }, { "name": "ship_qty", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "ship_date", "type": "DATE", "mode": "NULLABLE" }, { "name": "delivery_number", "type": "STRING", "mode": "NULLABLE" }, { "name": "tracking_number", "type": "STRING", "mode": "NULLABLE" }, { "name": "price", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "ship_location_city", "type": "STRING", "mode": "NULLABLE" }, { "name": "ship_location_state", "type": "STRING", "mode": "NULLABLE" }, { "name": "ship_to_customer", "type": "STRING", "mode": "NULLABLE" }, { "name": "requested_delivery_date", "type": "DATE", "mode": "NULLABLE" }, { "name": "delivery_date", "type": "DATE", "mode": "NULLABLE" }, { "name": "top_five_indicator", "type": "STRING", "mode": "NULLABLE" } ] }, "jobReference": { "projectId": "nag-analytics", "jobId": "job_Q-mIfobYrk7fRq1jn5bcV4RN8ho3", "location": "asia-south1" }, "totalRows": "3", "rows": [ { "f": [ { "v": "162799" }, { "v": null }, { "v": null }, { "v": "0021024295" }, { "v": "1208213RDY" }, { "v": "04359826704" }, { "v": "300034059" }, { "v": "Icosapent Ethyl Capsules 1g 120" }, { "v": "RX" }, { "v": "ICOSAPENT ETHYL" }, { "v": "288.0" }, { "v": "2021-12-09" }, { "v": "WK 05 Dec 2021" }, { "v": "Dec 2021" }, { "v": "COMPLETED" }, { "v": "288.0" }, { "v": null }, { "v": null }, { "v": null }, { "v": "178.83274305555557" }, { "v": "Lakeland" }, { "v": "FL" }, { "v": "Clearview Procurement, LLC" }, { "v": "2021-12-15" }, { "v": "2021-12-15" }, { "v": null } ] } ], "totalBytesProcessed": "96301448", "jobComplete": true, "cacheHit": false }');
                gcpResponse = res.getBody();
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
            for( Product2 prod : [select Id,name,ProductCode From Product2 where ProductCode != null]){
                skuprodMap.put(prod.ProductCode,prod);
            }
            Map<String,String> gcpSfFieldsMap = new Map<String,String>();
            gcpSfFieldsMap.put('Average_Forecast','Vision_Average_Forecast__c');
            gcpSfFieldsMap.put('unique_id','Vision_GCP_Hash_Key__c');
            gcpSfFieldsMap.put('Back_Order_Value','Vision_Back_Order_Value__c');
            gcpSfFieldsMap.put('Backorder_Qty','Back_Order_Qty__c');
            gcpSfFieldsMap.put('Backorder_Report_Date','Vision_Backorder_Report_Date__c');
            //gcpSfFieldsMap.put('Backorder_Report_Date','Back_Order_Date_Text__c');
            gcpSfFieldsMap.put('Comments','Vision_Comments__c'); 
            gcpSfFieldsMap.put('Count','Vision_Count__c'); 
            gcpSfFieldsMap.put('current_month','Vision_current_month__c'); 
            gcpSfFieldsMap.put('Current_Month_Total_Monthly_Order','Vision_Current_Month_Total_Monthly_Order__c'); 
            gcpSfFieldsMap.put('Current_Order_Qty','Vision_Current_Order_Qty__c'); 
            gcpSfFieldsMap.put('Gcp_Update_Date','Vision_Gcp_Update_Date__c'); 
            gcpSfFieldsMap.put('Inventory_in_QA','Vision_Inventory_in_QA__c'); 
            gcpSfFieldsMap.put('Inventory_in_Transit','Vision_Inventory_in_Transit__c'); 
            gcpSfFieldsMap.put('last_month','Vision_last_month__c'); 
            gcpSfFieldsMap.put('last_month_forecast','Vision_last_month_forecast__c'); 
            gcpSfFieldsMap.put('MoH','Vision_MoH__c');
            gcpSfFieldsMap.put('Order_Value','Vision_Order_Value__c');
            gcpSfFieldsMap.put('Pct_Current_Forecast','Vision_Pct_Current_Forecast__c');
            gcpSfFieldsMap.put('Short_term_adjustment','Vision_Short_term_adjustment__c');
           // gcpSfFieldsMap.put('Short_Term_Forecast','Vision_Short_Term_Forecast__c');
            gcpSfFieldsMap.put('Stocks_at_UPS','Vision_Stocks_at_UPS__c');
            gcpSfFieldsMap.put('Total_Open_Order_Qty','Vision_Total_Open_Order_Qty__c');
            gcpSfFieldsMap.put('Unit_Sales_Value','Vision_Unit_Sales_Value__c');
            gcpSfFieldsMap.put('Sku_Code','Vision_Sku_Code__c');
            gcpSfFieldsMap.put('Customer','GCP_Customer_Name__c');
            gcpSfFieldsMap.put('Molecule','GCP_Product_Family__c');
            gcpSfFieldsMap.put('Week_1','Vision_Week_1__c');
            gcpSfFieldsMap.put('Week_2','Vision_Week_2__c');
            gcpSfFieldsMap.put('Week_3','Vision_Week_3__c');
            gcpSfFieldsMap.put('Week_4','Vision_Week_4__c');
            gcpSfFieldsMap.put('Week_5','Vision_Week_5__c');
            gcpSfFieldsMap.put('Week_6','Vision_Week_6__c');
            gcpSfFieldsMap.put('Week_7','Vision_Week_7__c');
            gcpSfFieldsMap.put('Week_8','Vision_Week_8__c');
            gcpSfFieldsMap.put('Week1_qty','Vision_Week1_Qty__c');
            gcpSfFieldsMap.put('Week2_qty','Vision_Week2_Qty__c');
            gcpSfFieldsMap.put('Week3_qty','Vision_Week3_Qty__c');
            gcpSfFieldsMap.put('Week4_qty','Vision_Week4_Qty__c');
            gcpSfFieldsMap.put('Week5_qty','Vision_Week5_Qty__c');
            gcpSfFieldsMap.put('Week6_qty','Vision_Week6_Qty__c');
            gcpSfFieldsMap.put('Week7_qty','Vision_Week7_Qty__c');
            gcpSfFieldsMap.put('Week8_qty','Vision_Week8_Qty__c');
            gcpSfFieldsMap.put('Moh_Week1','Vision_Moh_Week1__c');
            gcpSfFieldsMap.put('Moh_Week2','Vision_Moh_Week2__c');
            gcpSfFieldsMap.put('Moh_Week3','Vision_Moh_Week3__c');
            gcpSfFieldsMap.put('Moh_Week4','Vision_Moh_Week4__c');
            gcpSfFieldsMap.put('Moh_Week5','Vision_Moh_Week5__c');
            gcpSfFieldsMap.put('Moh_Week6','Vision_Moh_Week6__c');
            gcpSfFieldsMap.put('Moh_Week7','Vision_Moh_Week7__c');
            gcpSfFieldsMap.put('Moh_Week8','Vision_Moh_Week8__c');
            gcpSfFieldsMap.put('Short_Term_Forecast_current_month','Vision_Short_Term_Forecast_Current_Month__c');
            gcpSfFieldsMap.put('last_month_forecast','Vision_Current_Forecast_Last_Month__c');

            
            // adding decimal fields to a list
            List<String> decimalFields = new List<String>();
            List<String> dateFields = new List<String>();
            String SobjectApiName = 'Vision_GCP_Backorder_OTC__c';
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
            List<Vision_GCP_Backorder_OTC__c> finalGCPrecords = new List<Vision_GCP_Backorder_OTC__c>();
            Set<String> gcp_unique_ids = new Set<String>();
            Map<String,Vision_GCP_Backorder_OTC__c> finalGCPrecordsMap = new Map<String,Vision_GCP_Backorder_OTC__c>();
            for(Integer rowCounter : gbqrw.jsonRowMap.keySet()){//1
                Map<Integer,String> tempRowMap = gbqrw.jsonRowMap.get(rowCounter);
                Vision_GCP_Backorder_OTC__c gcpSFRec = new Vision_GCP_Backorder_OTC__c();
                
                for(Integer valNo : tempRowMap.keySet()){
                    String fieldName = gcpSfFieldsMap.get(gbqrw.jsonFieldMap.get(valNo));
                    currentField = fieldName;
                    String fieldValue = tempRowMap.get(valNo);
                    if(fieldValue != null && fieldName != null){
                        if(decimalFields.contains(fieldName.toLowerCase())){
                            if(fieldValue.startsWith('-') && fieldValue.length()>1 ){
                                gcpSFRec.put(fieldName , Decimal.valueOf(fieldValue));
                            }
                            else if (fieldValue.contains('-') && fieldValue.length()==1 ){
                                gcpSFRec.put(fieldName , null);
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
                
                gcpSFRec.Product_Family__c = existingProductFamilyMap.containsKey(gcpSFRec.GCP_Product_Family__c) ? existingProductFamilyMap.get(gcpSFRec.GCP_Product_Family__c) : null;
                if(gcpSFRec.Vision_Sku_Code__c != null){
                    if(skuprodMap.containsKey(gcpSFRec.Vision_Sku_Code__c)){
                        gcpSFRec.Vision_Product__c  = skuprodMap.get(gcpSFRec.Vision_Sku_Code__c).Id;
                    }
                    else{
                        gcpSFRec.Vision_Product__c  = gcpSFRec.Vision_Product__c;
                    }
                }
              // finalGCPrecords.add(gcpSFRec);
               gcpSFRec.Vision_GCP_Unique_Identifier__c   = gcpSFRec.Vision_GCP_Hash_Key__c;
               // finalGCPrecords.add(gcpSFRec);
               gcp_unique_ids.add(gcpSFRec.Vision_GCP_Unique_Identifier__c );
                finalGCPrecordsMap.put(gcpSFRec.Vision_GCP_Unique_Identifier__c ,gcpSFRec);
               // 
           }
            //Existing GCP records map for linking
           for(Vision_GCP_Backorder_OTC__c gcp : [select Id,Vision_GCP_Unique_Identifier__c From Vision_GCP_Backorder_OTC__c  Where Vision_GCP_Unique_Identifier__c in : gcp_unique_ids]){
                finalGCPrecordsMap.get(gcp.Vision_GCP_Unique_Identifier__c).Id = gcp.Id;
            }
            finalGCPrecords.AddAll(finalGCPrecordsMap.values());
            upsert finalGCPrecords; 
             offSet = offSet + gbqrw.totalRows;
            //Internal_Use__c it=new Internal_Use__c();
            
            ///it.limit__c=limitVal!=null?limitval:0;
            //it.offset__c=offSet!=null?offSet:0;
            //it.Total_Rows__c=gbqrw.totalRows!=null?gbqrw.totalRows:0;
           // insert it;
            
     }
            
        Catch(Exception e) {
            Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'GoogleBackOrderOTCFetch', Phoenix_Error_Message__c = e.getMessage()+' '+currentField, Phoenix_Issue_Status__c = 'Pending', Phoenix_Method_Name__c = 'execute', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
            insert exp;
        }
        
    
    }
    
    public void finish(Database.BatchableContext BC) {
        //Plan for next run
        System.debug('Total Row Count is ======> '+totalRows + '   Limit Val is ======> ' +limitVal);
        if(!Test.isRunningTest()){
            try{
                if(totalRows == limitVal){
                   // offSet = offSet + limitVal;
                	Database.executeBatch(new GoogleBackOrderOTCFetch(limitVal,offSet));
                }
               else{
               
            // add Custom setting Code
                   Vision_GCP_Backorder_OTC__c cusOrdRec = [select Vision_Gcp_Update_Date__c from Vision_GCP_Backorder_OTC__c limit 1];
                   String Vision_gcp_update_date  = String.valueOf(cusOrdRec.Vision_Gcp_Update_Date__c).substringbefore(' ');
                   String Vision_update_date = String.valueOf(Phoenix_Util.getTodayEST()).substringbefore(' ');
                   system.debug('--Vision_gcp_update_date--'+Vision_gcp_update_date);
                   system.debug('--Vision_update_date--'+Vision_update_date);
                   Back_Order_OTC_Dates_Info__c cotdi = Back_Order_OTC_Dates_Info__c.getInstance('Data1');
                   cotdi.Vision_Gcp_Update_Date__c = Vision_gcp_update_date;
                   cotdi.Vision_Update_Date__c = Vision_update_date;
                   update cotdi;
                   
                   Integer Records=[select count() from Vision_GCP_Backorder_OTC__c ];
                   string RecordsCount='Total Records are '+ String.valueOf(Records);
                   Phoenix_Util.sendBatchJobCompletionEmail('GCP Backorder OTC ', RecordsCount);
                   Database.executeBatch(new GoogleDOHTradePartnerNDCLevelFetch());
               }
                
            }
            Catch(Exception e) {
                Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'GoogleBackOrderOTCFetch', Phoenix_Error_Message__c = e.getMessage(), Phoenix_Issue_Status__c = 'Pending', Phoenix_Method_Name__c = 'execute', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
                insert exp;
            }
        }
       
        
    }
    
}