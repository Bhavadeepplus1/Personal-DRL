public class GoogleTradePartnerDOHRepFetch implements Database.Batchable < sObject > , Database.Stateful,Schedulable,Database.AllowsCallouts {
    public Integer limitVal;
    public Integer offSet;
    Integer receivedCount;
    Integer totalRows;
    public GoogleTradePartnerDOHRepFetch(Integer limitValue,Integer offSetValue){
        limitVal = limitValue;
        offSet = offSetValue;
    }
    
    public GoogleTradePartnerDOHRepFetch(){
        limitVal = 100;
        offSet = 0;
    }
    
    public void execute(SchedulableContext sc) {
        Database.executeBatch(new GoogleTradePartnerDOHRepFetch());
    }
    
    public Database.QueryLocator start(Database.BatchableContext BC) {
        delete [Select Id FROM GCP_Trade_Partner_DOH_Report__c WHERE CreatedDate != Today LIMIT 10000];
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
            req.setBody('{"query":"SELECT * FROM agg_zone.sfdc_trade_partner_doh_report LIMIT '+ limitVal+' OFFSET '+offSet+'"}');
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
            map<String,Product2> ndc11prodMap =new Map<String,Product2>();
            map<String,Product2> ndc10prodMap =new Map<String,Product2>();
            for( Product2 prod : [select Id,name,ProductCode,Phoenix_NDC__c ,Phoenix_Rx_SRx_OTC__c, Phoenix_NDC_11__c   From Product2 where Phoenix_NDC_11__c  != null and Phoenix_Rx_SRx_OTC__c !=null ]){
                ndc11prodMap.put(prod.Phoenix_NDC_11__c,prod);
                ndc10prodMap.put(prod.Phoenix_NDC__c,prod);
            }
            
            //Existing GCP records map for linking
            map<String,String> existingProductFamilyMap =new Map<String,String>();
            for(GCP_Product_Family_Map__c  prdfmy : [select id,GCP_Product_Family__c, SFDC_Product_Family__c From GCP_Product_Family_Map__c])
            {
                existingProductFamilyMap.put(prdfmy.GCP_Product_Family__c,prdfmy.SFDC_Product_Family__c); 
            }
            Map<String,String> gcpSfFieldsMap = new Map<String,String>();
            gcpSfFieldsMap.put('trade_partner_name','Trade_Partner_Name__c');
            gcpSfFieldsMap.put('distribution_center_name','Vision_Distribution_Center_Name__c');
            gcpSfFieldsMap.put('distribution_center_city','Vision_Distribution_Center_City__c');
            gcpSfFieldsMap.put('distribution_center_state','Vision_Distribution_Center_State__c');
            gcpSfFieldsMap.put('distribution_center_address','Vision_Distribution_Center_Address__c');
            gcpSfFieldsMap.put('distribution_center_zip','Vision_Distribution_Center_Zip__c');
            gcpSfFieldsMap.put('package_description','Package_Description__c');
            gcpSfFieldsMap.put('ndc','NDC__c');
            gcpSfFieldsMap.put('wac_price','WAC_Price__c');
            gcpSfFieldsMap.put('w1_day','W1_Day__c');
            gcpSfFieldsMap.put('w2_day','W2_Day__c');
            gcpSfFieldsMap.put('w3_day','W3_Day__c');
            gcpSfFieldsMap.put('w4_day','W4_Day__c');
            gcpSfFieldsMap.put('w5_day','W5_Day__c');
            gcpSfFieldsMap.put('w6_day','W6_Day__c');
            gcpSfFieldsMap.put('w7_day','W7_Day__c');
            gcpSfFieldsMap.put('w8_day','W8_Day__c');
            gcpSfFieldsMap.put('w1_qty_sold','W1_QTY_Sold__c');
            gcpSfFieldsMap.put('w2_qty_sold','W2_QTY_Sold__c');
            gcpSfFieldsMap.put('w3_qty_sold','W3_QTY_Sold__c');
            gcpSfFieldsMap.put('w4_qty_sold','W4_QTY_Sold__c');
            gcpSfFieldsMap.put('w5_qty_sold','W5_QTY_Sold__c');
            gcpSfFieldsMap.put('w6_qty_sold','W6_QTY_Sold__c');
            gcpSfFieldsMap.put('w7_qty_sold','W7_QTY_Sold__c');
            gcpSfFieldsMap.put('w8_qty_sold','W8_QTY_Sold__c');
            gcpSfFieldsMap.put('w1_qoh','W1_QOH__c');
            gcpSfFieldsMap.put('w2_qoh','W2_QOH__c');
            gcpSfFieldsMap.put('w3_qoh','W3_QOH__c');
            gcpSfFieldsMap.put('w4_qoh','W4_QOH__c');
            gcpSfFieldsMap.put('w5_qoh','W5_QOH__c');
            gcpSfFieldsMap.put('w6_qoh','W6_QOH__c');
            gcpSfFieldsMap.put('w7_qoh','W7_QOH__c');
            gcpSfFieldsMap.put('w8_qoh','W8_QOH__c');
            gcpSfFieldsMap.put('w1_doh','W1_DOH__c');
            gcpSfFieldsMap.put('w2_doh','W2_DOH__c');
            gcpSfFieldsMap.put('w3_doh','W3_DOH__c');
            gcpSfFieldsMap.put('w4_doh','W4_DOH__c');
            gcpSfFieldsMap.put('w5_doh','W5_DOH__c');
            gcpSfFieldsMap.put('w6_doh','W6_DOH__c');
            gcpSfFieldsMap.put('w7_doh','W7_DOH__c');
            gcpSfFieldsMap.put('w8_doh','W8_DOH__c');
            gcpSfFieldsMap.put('sum_average_sales','Vision_Sum_Average_Sales__c');
            gcpSfFieldsMap.put('Segment','Vision_Segment__c');
            gcpSfFieldsMap.put('wac_value','WAC_Value__c');
            gcpSfFieldsMap.put('high_flag','High_Flag__c');
            gcpSfFieldsMap.put('low_flag','Low_Flag__c');
            gcpSfFieldsMap.put('Gcp_update_date','Vision_GCP_Update_Date__c');
            //gcpSfFieldsMap.put('sf_account_code','GCP_SF_Account_Code__c');
            //gcpSfFieldsMap.put('sf_id','GCP_SF_Id__c');
            
            // adding decimal fields to a list
            List<String> decimalFields = new List<String>();
            List<String> dateFields = new List<String>();
            String SobjectApiName = 'GCP_Trade_Partner_DOH_Report__c';
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
            List<GCP_Trade_Partner_DOH_Report__c> finalGCPrecords = new List<GCP_Trade_Partner_DOH_Report__c>();
            Set<String> gcp_unique_ids = new Set<String>();
            Map<String,GCP_Trade_Partner_DOH_Report__c> finalGCPrecordsMap = new Map<String,GCP_Trade_Partner_DOH_Report__c>();
            for(Integer rowCounter : gbqrw.jsonRowMap.keySet()){//1
                Map<Integer,String> tempRowMap = gbqrw.jsonRowMap.get(rowCounter);
                GCP_Trade_Partner_DOH_Report__c gcpSFRec = new GCP_Trade_Partner_DOH_Report__c();
                
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
                //if(String.isNotBlank(gcpSFRec.GCP_SF_Account_Code__c)){
                //gcpSFRec.Vision_Customer__c  = accMap.containsKey(gcpSFRec.GCP_SF_Account_Code__c ) ? accMap.get(gcpSFRec.GCP_SF_Account_Code__c).Id : gcpSFRec.Vision_Customer__c;
                //}
                //gcpSFRec.Vision_Product__c  = prodMap.containsKey(gcpSFRec.NDC__c) ? prodMap.get(gcpSFRec.NDC__c).Id : gcpSFRec.Vision_Product__c;
                if(String.isNotBlank(gcpSFRec.NDC__c)){
                    System.debug('--- Before NDC ---'+gcpSFRec.NDC__c);
                    String ndcCode = gcpSFRec.NDC__c.replaceFirst('^0+', '');
                    System.debug('--- Before NDC ---'+ndcCode);
                    if(ndc11prodMap.containsKey(ndcCode)){
                        gcpSFRec.Vision_Product__c  = ndc11prodMap.get(ndcCode).Id;
                    }
                    else if(ndc10prodMap.containsKey(ndcCode)){
                        gcpSFRec.Vision_Product__c  = ndc10prodMap.get(ndcCode).Id;
                    }
                    else{
                        gcpSFRec.Vision_Product__c  = gcpSFRec.Vision_Product__c;
                    }
                }
                
                    gcpSFRec.Vision_Internal_Segment__c=gcpSFRec.Vision_Product__r.Phoenix_Rx_SRx_OTC__c!=null ? gcpSFRec.Vision_Product__r.Phoenix_Rx_SRx_OTC__c:gcpSFRec.Vision_Internal_Segment__c;
                
                // gcpSFRec.Vision_Product_Family__c  = existingProductFamilyMap.containsKey(gcpSFRec.GCP_Product_Family__c) ? existingProductFamilyMap.get(gcpSFRec.GCP_Product_Family__c) : null;
                //finalGCPrecords.add(gcpSFRec);
                gcpSFRec.Vision_Unique_Identifier__c = gcpSFRec.Trade_Partner_Name__c +'_'+gcpSFRec.Vision_Distribution_Center_Name__c+'_'+gcpSFRec.Vision_Distribution_Center_City__c+'_'+ gcpSFRec.NDC__c+'_'+gcpSFRec.Vision_Segment__c;
                gcp_unique_ids.add(gcpSFRec.Vision_Unique_Identifier__c);
                finalGCPrecordsMap.put(gcpSFRec.Vision_Unique_Identifier__c  ,gcpSFRec);
                
            }
            
            //Existing GCP records map for linking
            for(GCP_Trade_Partner_DOH_Report__c gcp : [select Id,Vision_Unique_Identifier__c  From GCP_Trade_Partner_DOH_Report__c Where Vision_Unique_Identifier__c  in : gcp_unique_ids]){
            	finalGCPrecordsMap.get(gcp.Vision_Unique_Identifier__c ).Id = gcp.Id;
            }
            finalGCPrecords.AddAll(finalGCPrecordsMap.values());
            upsert finalGCPrecords; 
        }
        Catch(Exception e) {
            Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'GoogleTradePartnerDOHRepFetch', Phoenix_Error_Message__c = e.getMessage()+' '+currentField, Phoenix_Issue_Status__c = 'Pending', Phoenix_Method_Name__c = 'execute', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
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
                 	Database.executeBatch(new GoogleTradePartnerDOHRepFetch(limitVal,offSet));
                }
                else
                {
                    GCP_Trade_Partner_DOH_Report__c tradeDOHRep = [select Vision_GCP_Update_Date__c from GCP_Trade_Partner_DOH_Report__c limit 1];
                    if(tradeDOHRep.Vision_GCP_Update_Date__c!=null){
                    String Vision_gcp_update_date  = String.valueOf(tradeDOHRep.Vision_GCP_Update_Date__c).substringbefore(' ');
                    String Vision_update_date = String.valueOf(Phoenix_Util.getTodayEST()).substringbefore(' ');
                    system.debug('--Vision_gcp_update_date--'+Vision_gcp_update_date);
                    system.debug('--Vision_update_date--'+Vision_update_date);
                    doh_report_dates_info__c dohRepinfo = doh_report_dates_info__c.getInstance('Data1');
                    dohRepinfo.Vision_GCP_Update_Date__c = Vision_gcp_update_date;
                    dohRepinfo.Vision_Update_Date__c = Vision_update_date;
                    update dohRepinfo;
                    }
                    database.executeBatch(new Vision_DoH_Summary_Batch());
                    Integer Records=[select count() from GCP_Trade_Partner_DOH_Report__c ];
                    string RecordsCount='Total Records are '+ String.valueOf(Records);
                    Phoenix_Util.sendBatchJobCompletionEmail('GCP Trade Partner DOH Report', RecordsCount);
    				//Database.executeBatch(new GoogleDOHTradePartnerNDCLevelFetch());
                }
            }
            Catch(Exception e) {
                Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'GoogleTradePartnerDOHRepFetch', Phoenix_Error_Message__c = e.getMessage(), Phoenix_Issue_Status__c = 'Pending', Phoenix_Method_Name__c = 'execute', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
                insert exp;
            }
        }
    }
    
}