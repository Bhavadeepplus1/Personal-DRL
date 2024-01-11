public class GoogleBigQueryDRLSalesExtFetch implements Database.Batchable < sObject > , Database.Stateful,Schedulable,Database.AllowsCallouts {
    public Integer limitVal;
    public Integer offSet;
    Integer receivedCount;
    Integer totalRows;
    public GoogleBigQueryDRLSalesExtFetch(Integer limitValue,Integer offSetValue){
        limitVal = limitValue;
        offSet = offSetValue;
    }
    
    public GoogleBigQueryDRLSalesExtFetch(){
        limitVal = 100;
        offSet = 0;
    }
    
    public void execute(SchedulableContext sc) {
        Database.executeBatch(new GoogleBigQueryDRLSalesExtFetch());
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
            	Vision_DRL_Sales_External_Summary__c Drlsalesext  = [select Vision_Created_Date__c from Vision_DRL_Sales_External_Summary__c where Vision_Created_Date__c != null and CreatedDate!= Today order by Vision_Created_Date__c desc limit 1];
            Datetime createdDateMaxVal = Drlsalesext.Vision_Created_Date__c;
            String createdDateStrVal = '\''+ createdDateMaxVal.formatGMT('yyyy-MM-dd')+ '\'';
            //req.setBody('{"query":"SELECT * FROM agg_zone.sfdc_profitability LIMIT '+ limitVal+' OFFSET '+offSet+'"}');  
            //req.setBody('{"query":"SELECT * FROM agg_zone.sfdc_net_sales_profitability LIMIT '+ limitVal+' OFFSET '+offSet+'"}');
            req.setBody('{"query":"SELECT * FROM agg_zone.sfdc_net_sales_ext where DATE(create_date) > DATE('+createdDateStrVal+') LIMIT '+ limitVal+' OFFSET '+offSet+'"}');
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
            //System.debug('GCP Response is ====>'+gcpResponse);
            
            // Parsing BigQuery Response
            GoogleBigQuery.GoogleBigQueryRespWrapper gbqrw = GoogleBigQuery.RespParser(gcpResponse);
            totalRows = gbqrw.totalRows;
            
            //Account map for linking
            map<String,Account> accMap =new Map<String,Account>();
            for( Account acc : [select id,name,accountNumber From Account])accMap.put(acc.accountNumber,acc);
            
            //Contract map for linking
            map<String,Phoenix_Contract__c> contractsMap =new Map<String,Phoenix_Contract__c >();
            for( Phoenix_Contract__c cntr : [select id,Phoenix_Contract_Number__c From Phoenix_Contract__c where Phoenix_Contract_Status__c ='Active'])contractsMap.put(cntr.Phoenix_Contract_Number__c ,cntr);
            
            //Product map for linking
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
                gcpSfFieldsMap.put('Agreement','Vision_agreement_no__c'); //text
            gcpSfFieldsMap.put('Product','GCP_Product_Family__c'); //text
            //gcp customer name to store account name
                 gcpSfFieldsMap.put('PRICE_AGRMNT_DESC','Vision_price_agreement_desc__c');
             gcpSfFieldsMap.put('sku_code','Vision_SKU_Code__c'); //text
              gcpSfFieldsMap.put('SEGMENT','Vision_Segment__c');
            gcpSfFieldsMap.put('NDC','Vision_NDC__c'); //text
            gcpSfFieldsMap.put('CUST_HIER_CODE','Vision_Cutomer_Hierarchy_Code__c');
            gcpSfFieldsMap.put('CUST_HIER','Vision_Customer_Hierarchy__c');
            gcpSfFieldsMap.put('CUSTOMER_CODE','Vision_customer_code__c'); //Text
            //gcpSfFieldsMap.put('account_salesforce_id','Vision_Customer_Name__c'); //Lookup(Account)
           // picklist
            gcpSfFieldsMap.put('CUST_DESC','Vision_Customer_Desc__c'); //text
            gcpSfFieldsMap.put('CATEGORY','Vision_Category__c'); //text
            //gcpSfFieldsMap.put('month_dtls','Vision_Month_dtls__c'); //date // missing this in new data
            gcpSfFieldsMap.put('CAL_MONTH','Vision_Processed_Month__c'); //number
            gcpSfFieldsMap.put('Month','Vision_Month__c');
            gcpSfFieldsMap.put('Year','Vision_year__c');
            gcpSfFieldsMap.put('INDIRECT_QTY','Vision_indirect_qty__c'); //currency
            gcpSfFieldsMap.put('DIRECT_QTY','Vision_direct_qty__c'); //currency
            gcpSfFieldsMap.put('QTY_TOTAL','Vision_Units__c'); //percent
           
            
            gcpSfFieldsMap.put('SALES_INDIRECT','Vision_sales_indirect__c'); //text
        
             //text
            gcpSfFieldsMap.put('SALES_DIRECT','Vision_sales_direct__c'); //text
            gcpSfFieldsMap.put('SALES_TOTAL','Vision_Sales__c'); //Number
            gcpSfFieldsMap.put('NET_SALES','Vision_net_sales__c');//date
            gcpSfFieldsMap.put('create_date','Vision_Created_Date__c');
            gcpSfFieldsMap.put('gcp_update_date','GCP_Updated_Date__c'); //date
            
            // adding decimal fields to a list
            List<String> decimalFields = new List<String>();
            List<String> dateFields = new List<String>();
            String SobjectApiName = 'Vision_DRL_Sales_External_Summary__c';
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
            system.debug('---decimalFields---'+decimalFields);
            system.debug('---dateFields---'+dateFields);
            List<Vision_DRL_Sales_External_Summary__c> finalGCPrecords = new List<Vision_DRL_Sales_External_Summary__c>();
            Set<String> gcp_unique_ids = new Set<String>();
            Map<String,Vision_DRL_Sales_External_Summary__c> finalGCPrecordsMap = new Map<String,Vision_DRL_Sales_External_Summary__c >();
            for(Integer rowCounter : gbqrw.jsonRowMap.keySet()){//1
                Map<Integer,String> tempRowMap = gbqrw.jsonRowMap.get(rowCounter);
                Vision_DRL_Sales_External_Summary__c gcpSFRec = new Vision_DRL_Sales_External_Summary__c();
                
                for(Integer valNo : tempRowMap.keySet()){
                    String fieldName = gcpSfFieldsMap.get(gbqrw.jsonFieldMap.get(valNo));
                    currentField = fieldName;
                    String fieldValue = tempRowMap.get(valNo);
                    system.debug(fieldName+'<<----------->>'+fieldValue);
                    if(fieldValue != null && fieldName != null){
                        if(decimalFields.contains(fieldName.toLowerCase())){
                            if(String.isNotBlank(fieldValue))
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
                //gcpSFRec.Phoenix_Product_Family__c  = gcpSFRec.GCP_Product_Family__c;
                //Product,npr_customer_code,customer_number,month_dtls

				if(gcpSFRec.Vision_SKU_Code__c != null)
                	gcpSFRec.Vision_Product__c  = skuCodePrdMap.containsKey(gcpSFRec.Vision_SKU_Code__c) ? skuCodePrdMap.get(gcpSFRec.Vision_SKU_Code__c).Id : gcpSFRec.Vision_Product__c;

                gcpSFRec.Vision_Product_Family__c  = existingProductFamilyMap.containsKey(gcpSFRec.GCP_Product_Family__c) ? existingProductFamilyMap.get(gcpSFRec.GCP_Product_Family__c) : null;
                gcpSFRec.Vision_GCP_Unique_Identifier__c = gcpSFRec.Vision_agreement_no__c +'_'+ gcpSFRec.Vision_SKU_Code__c+'_'+gcpSFRec.Vision_customer_code__c+'_'+gcpSFRec.Vision_Category__c+'_'+gcpSFRec.Vision_month__c+'_'+gcpSFRec.Vision_year__c;
                gcp_unique_ids.add(gcpSFRec.Vision_GCP_Unique_Identifier__c);
                //gcpSFRec.Id = existingGCPMap.containsKey(gcpSFRec.GCP_Unique_Identifier__c) ? existingGCPMap.get(gcpSFRec.GCP_Unique_Identifier__c) : null;
                gcpSFRec.Vision_Customer__c = accMap.containsKey(gcpSFRec.Vision_customer_code__c) ? accMap.get(gcpSFRec.Vision_customer_code__c).Id : gcpSFRec.Vision_Customer__c;
                gcpSFRec.Vision_Contract__c = contractsMap.containsKey(gcpSFRec.Vision_Agreement_No__c) ? contractsMap.get(gcpSFRec.Vision_Agreement_No__c).Id : gcpSFRec.Vision_Contract__c;
               // gcpSFRec.Vision_Update_Date__c = Phoenix_Util.getTodayEST();
                finalGCPrecordsMap.put(gcpSFRec.Vision_GCP_Unique_Identifier__c,gcpSFRec);
                
            }
            //Existing GCP records map for linking
            for(Vision_DRL_Sales_External_Summary__c gcp : [select Id,Vision_GCP_Unique_Identifier__c From Vision_DRL_Sales_External_Summary__c Where Vision_GCP_Unique_Identifier__c in : gcp_unique_ids]){
                finalGCPrecordsMap.get(gcp.Vision_GCP_Unique_Identifier__c).Id = gcp.Id;
            }
            finalGCPrecords.AddAll(finalGCPrecordsMap.values());
            upsert finalGCPrecords;            
        }
        Catch(Exception e) {
            Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'GoogleBigQueryDRLSalesExtFetch', Phoenix_Error_Message__c = e.getMessage()+' '+currentField, Phoenix_Issue_Status__c = 'Pending', Phoenix_Method_Name__c = 'execute', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
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
                    Database.executeBatch(new GoogleBigQueryDRLSalesExtFetch(limitVal,offSet));
                }
                else{
                    // storing MAX of month_dtls,GCP_Update_Date__c, in custom label
                    /*Vision_DRL_Sales_External__c salesRec = [select Vision_Month_dtls__c,GCP_Update_Date__c from Vision_DRL_Sales_External__c order by Vision_Month_dtls__c desc limit 1];
                    String Vision_Month_dtls_val = String.valueOf(salesRec.Vision_Month_dtls__c).substringbefore(' ');
                    String Vision_gcp_update_date  = String.valueOf(salesRec.GCP_Update_Date__c).substringbefore(' ');
                    String Vision_update_date = String.valueOf(Phoenix_Util.getTodayEST()).substringbefore(' ');
                    drl_sales_dates_info__c dsdi = drl_sales_dates_info__c.getInstance('Data1');
                    dsdi.Vision_Data_Available_Till__c = Vision_Month_dtls_val;
                    dsdi.Vision_GCP_Update_Date__c = Vision_gcp_update_date;
                    dsdi.Vision_Update_Date__c = Vision_update_date;
                    update dsdi;*/
                    
                    Integer Records=[select count() from Vision_DRL_Sales_External_Summary__c];
                    string RecordsCount='Total Records are '+ String.valueOf(Records);
                    //Phoenix_Util.sendBatchJobCompletionEmail('DRL Sales External ', RecordsCount);
					
                }
            }
            Catch(Exception e) {
                Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'GoogleBigQueryDRLSalesExtFetch', Phoenix_Error_Message__c = e.getMessage(), Phoenix_Issue_Status__c = 'Pending', Phoenix_Method_Name__c = 'execute', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
                insert exp;
            }
        }
    }
}