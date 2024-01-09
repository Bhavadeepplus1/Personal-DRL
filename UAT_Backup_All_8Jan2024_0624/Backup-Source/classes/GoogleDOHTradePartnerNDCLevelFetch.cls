public class GoogleDOHTradePartnerNDCLevelFetch implements Database.Batchable < sObject > , Database.Stateful,Schedulable,Database.AllowsCallouts {
    public Integer limitVal;
    public Integer offSet;
    Integer receivedCount;
    Integer totalRows;
    public GoogleDOHTradePartnerNDCLevelFetch(Integer limitValue,Integer offSetValue){
        limitVal = limitValue;
        offSet = offSetValue;
    }
    
    public GoogleDOHTradePartnerNDCLevelFetch(){
        limitVal = 100;
        offSet = 0;
    }
    
    public void execute(SchedulableContext sc) {
        Database.executeBatch(new GoogleDOHTradePartnerNDCLevelFetch());
    }
    
    public Database.QueryLocator start(Database.BatchableContext BC) {
        delete [Select Id FROM GCP_DOH_Trade_Partner_NDC__c WHERE CreatedDate != Today LIMIT 100];
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
            //	req.setEndpoint('https://bigquery.googleapis.com/bigquery/v2/projects/nag-analytics/queries');
            req.setHeader('Content-type', 'application/json');
            req.setHeader('Authorization', 'Bearer ' + auth.getAccessToken());
            req.setBody('{"query":"SELECT * FROM agg_zone.sfdc_doh_trade_partner_ndc_level LIMIT '+ limitVal+' OFFSET '+offSet+'"}');
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
                res.setBody('{ "kind": "bigquery#queryResponse", "schema": { "fields": [ { "name": "trade_partner_name", "type": "STRING", "mode": "NULLABLE" }, { "name": "package_description", "type": "STRING", "mode": "NULLABLE" }, { "name": "ndc", "type": "STRING", "mode": "NULLABLE" }, { "name": "wac_price", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "w1_day", "type": "DATE", "mode": "NULLABLE" }, { "name": "w2_day", "type": "DATE", "mode": "NULLABLE" }, { "name": "w3_day", "type": "DATE", "mode": "NULLABLE" }, { "name": "w4_day", "type": "DATE", "mode": "NULLABLE" }, { "name": "w1_qty_sold", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "w2_qty_sold", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "w3_qty_sold", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "w4_qty_sold", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "w1_qoh", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "w2_qoh", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "w3_qoh", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "w4_qoh", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "w1_doh", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "w2_doh", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "w3_doh", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "w4_doh", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "wac_value", "type": "FLOAT", "mode": "NULLABLE" }, { "name": "high_flag", "type": "INTEGER", "mode": "NULLABLE" }, { "name": "low_flag", "type": "INTEGER", "mode": "NULLABLE" }, { "name": "Gcp_update_date", "type": "DATE", "mode": "NULLABLE" } ] }, "jobReference": { "projectId": "nag-analytics", "jobId": "job_Q9lPG9qQN355fq2zOsgwpnJRKrss", "location": "asia-south1" }, "totalRows": "1", "rows": [ { "f": [ { "v": "NORTH CAROLINA MUTUAL WHOLESALE DRUG CO" }, { "v": "IMATINIB MESYLATE 400MG X 30 (TABS)" }, { "v": "4359834531" }, { "v": "2700.0" }, { "v": "2022-01-05" }, { "v": "2022-01-12" }, { "v": "2022-01-19" }, { "v": "2022-01-26" }, { "v": "0.0" }, { "v": "1.0" }, { "v": "0.0" }, { "v": "1.0" }, { "v": "8.0" }, { "v": "6.0" }, { "v": "12.0" }, { "v": "11.0" }, { "v": "42.82" }, { "v": "30.33" }, { "v": "60.67" }, { "v": "62.56" }, { "v": "29700.0" }, { "v": "1" }, { "v": "0" }, { "v": "2022-02-25" } ] } ], "totalBytesProcessed": "509038", "jobComplete": true, "cacheHit": false }');
                gcpResponse = res.getBody();
            }
            //System.debug('GCP Response is ====>'+gcpResponse);
            
            // Parsing BigQuery Response
            GoogleBigQuery.GoogleBigQueryRespWrapper gbqrw = GoogleBigQuery.RespParser(gcpResponse);
            totalRows = gbqrw.totalRows;
            
            //Account map for linking
            map<String,Account> accMap =new Map<String,Account>();
            for( Account acc : [select id,name,accountNumber From Account where accountNumber != null ])accMap.put(acc.accountNumber,acc);
            
            //Back Order Rx map for linking
            map<String,Id> existingBackOrderRXMap =new Map<String,Id>();
            for( Vision_GCP_Backorder_OTC__c  backOrderRx : [select id,Vision_Sku_Code__c,Vision_Backorder_Report_Date__c From Vision_GCP_Backorder_OTC__c where Vision_Sku_Code__c != null order by Vision_Backorder_Report_Date__c desc]){
                if(!existingBackOrderRXMap.containskey(backOrderRx.Vision_Sku_Code__c ))
                    existingBackOrderRXMap.put(backOrderRx.Vision_Sku_Code__c ,backOrderRx.Id);
                
            }
            
            //Back Order SRx map for linking
            map<String,Vision_GCP_Backorder_SRx_Rx__c> existingBackOrderSRXMap =new Map<String,Vision_GCP_Backorder_SRx_Rx__c>();
            for( Vision_GCP_Backorder_SRx_Rx__c backOrderSRx : [select id,Vision_Sku_Code__c,Vision_MoH__c,Vision_On_Backorder__c From Vision_GCP_Backorder_SRx_Rx__c where Vision_Sku_Code__c != null order by Vision_Backorder_Report_Date__c  desc]){
                if(!existingBackOrderSRXMap.containskey(backOrderSRx.Vision_Sku_Code__c))
               		 existingBackOrderSRXMap.put(backOrderSRx.Vision_Sku_Code__c ,backOrderSRx);
            }
            //Product map for linking
            map<String,Product2> ndc11prodMap =new Map<String,Product2>();
            map<String,Product2> ndc10prodMap =new Map<String,Product2>();
            for( Product2 prod : [select Id,name,ProductCode,Phoenix_NDC__c , Phoenix_NDC_11__c,Phoenix_Rx_SRx_OTC__c   From Product2 where Phoenix_NDC_11__c != null and Phoenix_NDC__c != null]){
                ndc11prodMap.put(prod.Phoenix_NDC_11__c,prod);
                ndc10prodMap.put(prod.Phoenix_NDC__c,prod);
            }
            
            Map<String,String> gcpSfFieldsMap = new Map<String,String>();
            gcpSfFieldsMap.put('trade_partner_name','vision_gcp_trade_partner_name__c');
            gcpSfFieldsMap.put('package_description','vision_gcp_package_description__c');
            gcpSfFieldsMap.put('ndc','vision_gcp_ndc__c');
            gcpSfFieldsMap.put('wac_price','vision_gcp_wac_price__c');
            gcpSfFieldsMap.put('w1_day','vision_gcp_w1_day__c');
            gcpSfFieldsMap.put('w2_day','vision_gcp_w2_day__c');
            gcpSfFieldsMap.put('w3_day','vision_gcp_w3_day__c');
            gcpSfFieldsMap.put('w4_day','vision_gcp_w4_day__c');
            gcpSfFieldsMap.put('w5_day','vision_gcp_w5_day__c');
            gcpSfFieldsMap.put('w6_day','vision_gcp_w6_day__c');
            gcpSfFieldsMap.put('w7_day','vision_gcp_w7_day__c');
            gcpSfFieldsMap.put('w8_day','vision_gcp_w8_day__c');
            //New fields need to be added
            gcpSfFieldsMap.put('w1_qty_sold','vision_gcp_w1_quantity_sold__c');
            gcpSfFieldsMap.put('w2_qty_sold','vision_gcp_w2_quantity_sold__c');
            gcpSfFieldsMap.put('w3_qty_sold','vision_gcp_w3_quantity_sold__c');
            gcpSfFieldsMap.put('w4_qty_sold','vision_gcp_w4_quantity_sold__c');
            gcpSfFieldsMap.put('w5_qty_sold','vision_gcp_w5_quantity_sold__c');
            gcpSfFieldsMap.put('w6_qty_sold','vision_gcp_w6_quantity_sold__c');
            gcpSfFieldsMap.put('w7_qty_sold','vision_gcp_w7_quantity_sold__c');
            gcpSfFieldsMap.put('w8_qty_sold','vision_gcp_w8_quantity_sold__c');
            //New fields need to be added
            gcpSfFieldsMap.put('w1_qoh','Vision_GCP_W1_QOH__c');
            gcpSfFieldsMap.put('w2_qoh','Vision_GCP_W2_QOH__c');
            gcpSfFieldsMap.put('w3_qoh','Vision_GCP_W3_QOH__c');
            gcpSfFieldsMap.put('w4_qoh','Vision_Gcp_W4_QOH__c');
            gcpSfFieldsMap.put('w5_qoh','Vision_GCP_W5_QOH__c');
            gcpSfFieldsMap.put('w6_qoh','Vision_GCP_W6_QOH__c');
            gcpSfFieldsMap.put('w7_qoh','Vision_GCP_W7_QOH__c');
            gcpSfFieldsMap.put('w8_qoh','Vision_Gcp_W8_QOH__c');
            //New fields need to be added
            gcpSfFieldsMap.put('w1_doh','Vision_GCP_W1_DOH__c');
            gcpSfFieldsMap.put('w2_doh','Vision_GCP_W2_DOH__c');
            gcpSfFieldsMap.put('w3_doh','Vision_GCP_W3_DOH__c');
            gcpSfFieldsMap.put('w4_doh','Vision_GCP_W4_DOH__c');
            gcpSfFieldsMap.put('w5_doh','Vision_GCP_W5_DOH__c');
            gcpSfFieldsMap.put('w6_doh','Vision_GCP_W6_DOH__c');
            gcpSfFieldsMap.put('w7_doh','Vision_GCP_W7_DOH__c');
            gcpSfFieldsMap.put('w8_doh','Vision_GCP_W8_DOH__c');
            gcpSfFieldsMap.put('wac_value','Vision_GCP_WAC_Value__c');
            gcpSfFieldsMap.put('high_flag','Vision_GCP_High_Flag__c');
            gcpSfFieldsMap.put('low_flag','Vision_GCP_Low_Flag__c');
            gcpSfFieldsMap.put('Gcp_update_date','Vision_GCP_Update_Date__c');
            // adding decimal fields to a list
            List<String> decimalFields = new List<String>();
            List<String> dateFields = new List<String>();
            map<id,string> existingRxSRxMap = new map<id,string>();
             map<id,string> existingOTCMap = new map<id,string>();
            String SobjectApiName = 'GCP_DOH_Trade_Partner_NDC__c';
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
            List<GCP_DOH_Trade_Partner_NDC__c> finalGCPrecords = new List<GCP_DOH_Trade_Partner_NDC__c>();
            Set<String> gcp_unique_ids = new Set<String>();
            Map<String,GCP_DOH_Trade_Partner_NDC__c> finalGCPrecordsMap = new Map<String,GCP_DOH_Trade_Partner_NDC__c>();
            Map<String,list<GCP_DOH_Trade_Partner_NDC__c>> allNDCRecs = new Map<String,list<GCP_DOH_Trade_Partner_NDC__c>>();
            for(Integer rowCounter : gbqrw.jsonRowMap.keySet()){//1
                Map<Integer,String> tempRowMap = gbqrw.jsonRowMap.get(rowCounter);
                GCP_DOH_Trade_Partner_NDC__c gcpSFRec = new GCP_DOH_Trade_Partner_NDC__c();
                
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
                gcpSFRec.Vision_GCP_Unique_Identifier__c = gcpSFRec.vision_gcp_trade_partner_name__c +'_'+gcpSfRec.vision_gcp_ndc__c;
                if(gcpSFRec.vision_gcp_ndc__c != null){
                    //System.debug('--- Before NDC ---'+gcpSFRec.vision_gcp_ndc__c);
                    
                    String ndcCode = gcpSFRec.vision_gcp_ndc__c;
                    //System.debug('--- Before NDC ---'+gcpSFRec.vision_gcp_ndc__c);
                    // gcpSFRec.GCP_Backorder_RX__c field refering to otc object  and gcpSFRec.GCP_Backorder_SRX__c refering to srxrx object
                    if(ndc11prodMap.containsKey(ndcCode)){
                        gcpSFRec.Product__c  = ndc11prodMap.get(ndcCode).Id;
                        gcpSFRec.GCP_Backorder_RX__c = existingBackOrderRXMap.containsKey(ndc11prodMap.get(ndcCode).ProductCode) ? existingBackOrderRXMap.get(ndc11prodMap.get(ndcCode).ProductCode) : gcpSFRec.GCP_Backorder_RX__c;
                        gcpSFRec.Vision_Segment__c = ndc11prodMap.get(ndcCode).Phoenix_Rx_SRx_OTC__c;
                        if(existingBackOrderSRXMap.containsKey(ndc11prodMap.get(ndcCode).ProductCode)){
                            gcpSFRec.GCP_Backorder_SRX__c =  existingBackOrderSRXMap.get(ndc11prodMap.get(ndcCode).ProductCode).Id;
                            
                        }
                        else{
                            gcpSFRec.GCP_Backorder_SRX__c = gcpSFRec.GCP_Backorder_SRX__c;
                        }
                        existingRxSRxmap.put( gcpSFRec.GCP_Backorder_SRX__c,gcpSFRec.Vision_GCP_Unique_Identifier__c);
                        existingOTCmap.put( gcpSFRec.GCP_Backorder_RX__c,gcpSFRec.Vision_GCP_Unique_Identifier__c);
                    }
                    else if(ndc10prodMap.containsKey(ndcCode)){
                        gcpSFRec.Product__c  = ndc10prodMap.get(ndcCode).Id;
                        gcpSFRec.GCP_Backorder_RX__c = existingBackOrderRXMap.containsKey(ndc10prodMap.get(ndcCode).ProductCode) ? existingBackOrderRXMap.get(ndc10prodMap.get(ndcCode).ProductCode) : gcpSFRec.GCP_Backorder_RX__c;
                        //gcpSFRec.GCP_Backorder_SRX__c = existingBackOrderSRXMap.containsKey(ndc10prodMap.get(ndcCode).ProductCode) ? existingBackOrderSRXMap.get(ndc10prodMap.get(ndcCode).ProductCode).Id : gcpSFRec.GCP_Backorder_SRX__c;
                        gcpSFRec.Vision_Segment__c = ndc10prodMap.get(ndcCode).Phoenix_Rx_SRx_OTC__c;
                        if(existingBackOrderSRXMap.containsKey(ndc10prodMap.get(ndcCode).ProductCode)){
                            gcpSFRec.GCP_Backorder_SRX__c =  existingBackOrderSRXMap.get(ndc10prodMap.get(ndcCode).ProductCode).Id;
                           
                        }
                        else{
                            gcpSFRec.GCP_Backorder_SRX__c = gcpSFRec.GCP_Backorder_SRX__c;
                        }
                        existingRxSRxmap.put( gcpSFRec.GCP_Backorder_SRX__c, gcpSFRec.Vision_GCP_Unique_Identifier__c);
                        existingOTCmap.put( gcpSFRec.GCP_Backorder_RX__c,gcpSFRec.Vision_GCP_Unique_Identifier__c);
                    }
                    else{
                        gcpSFRec.Product__c = gcpSFRec.Product__c;
                    }
                   
                    if(allNDCRecs.containskey(ndccode)){
                        allNDCRecs.get(ndccode).add(gcpSFRec);
                    }
                    else{
                        allNDCRecs.put(ndccode,new list<GCP_DOH_Trade_Partner_NDC__c>{gcpSFRec}); 
                    }
                }
                
                gcp_unique_ids.add(gcpSFRec.Vision_GCP_Unique_Identifier__c);
                finalGCPrecordsMap.put(gcpSFRec.Vision_GCP_Unique_Identifier__c ,gcpSFRec);
            }
            //system.debug('allNDCRecs....'+allNDCRecs);
            
            //Existing GCP records map for linking
            for(GCP_DOH_Trade_Partner_NDC__c gcp : [select Id,Vision_GCP_Unique_Identifier__c  From GCP_DOH_Trade_Partner_NDC__c Where Vision_GCP_Unique_Identifier__c  in : gcp_unique_ids]){
                finalGCPrecordsMap.get(gcp.Vision_GCP_Unique_Identifier__c).Id = gcp.Id;
            }
            map<String,Id> existingOrderStatusRecs = new map<String,Id>();
            for( Vision_GCP_SFDC_Order_Status__c orderStatusRec : [select id,Vision_Product__r.Phoenix_NDC_11__c ,Vision_Product__r.Phoenix_NDC__c From Vision_GCP_SFDC_Order_Status__c where Vision_Order_Status__c = 'NOT DELIVERED' and (Vision_Product__r.Phoenix_NDC__c   in : allNDCRecs.keySet() or Vision_Product__r.Phoenix_NDC_11__c in: allNDCRecs.keySet())]){
                if(allNDCRecs.containsKey(orderStatusRec.Vision_Product__r.Phoenix_NDC__c)){
                    for(GCP_DOH_Trade_Partner_NDC__c existingdohndcrec:allNDCRecs.get(orderStatusRec.Vision_Product__r.Phoenix_NDC__c)){
                        if(finalGCPrecordsMap.containsKey(existingdohndcrec.Vision_GCP_Unique_Identifier__c)){
                            finalGCPrecordsMap.get(existingdohndcrec.Vision_GCP_Unique_Identifier__c).Vision_SFDC_Order_Status__c = orderStatusRec.id;
                            finalGCPrecordsMap.get(existingdohndcrec.Vision_GCP_Unique_Identifier__c).Vision_Is_In_Open_Order__c = true;
                        }
                    }
                }
                
                 else if(allNDCRecs.containsKey(orderStatusRec.Vision_Product__r.Phoenix_NDC_11__c)){
                    for(GCP_DOH_Trade_Partner_NDC__c existingdohndcrec:allNDCRecs.get(orderStatusRec.Vision_Product__r.Phoenix_NDC_11__c)){
                    if(finalGCPrecordsMap.containsKey(existingdohndcrec.Vision_GCP_Unique_Identifier__c)){
                        finalGCPrecordsMap.get(existingdohndcrec.Vision_GCP_Unique_Identifier__c).Vision_SFDC_Order_Status__c = orderStatusRec.id;
                        finalGCPrecordsMap.get(existingdohndcrec.Vision_GCP_Unique_Identifier__c).Vision_Is_In_Open_Order__c = true;
                    }
                    }
                }
            }
            List < Vision_GCP_Backorder_SRx_Rx__c > listOfSRxBackOrderRecords=[Select Vision_Backorder_Report_Date__c,Vision_GCP_Update_Date__c From Vision_GCP_Backorder_SRx_Rx__c order by Vision_Backorder_Report_Date__c desc limit 1];
            //system.debug('listOfSRxBackOrderRecords>>>'+listOfSRxBackOrderRecords);
            if(listOfSRxBackOrderRecords[0].Vision_Backorder_Report_Date__c!=null)
                String reportDate = String.valueOf(listOfSRxBackOrderRecords[0].Vision_Backorder_Report_Date__c);

            /*for(Vision_GCP_Backorder_SRx_Rx__c srxrxrecord:[select id,Vision_MoH__c,Vision_On_Backorder__c from Vision_GCP_Backorder_SRx_Rx__c where id in:existingRxSRxmap.keyset()]){
                system.debug('-- Segment --'+finalGCPrecordsMap.get(existingRxSRxmap.get(srxrxrecord.id)).Vision_Segment__c);
                system.debug('-- Vision_MoH__c --'+srxrxrecord.Vision_MoH__c);
                system.debug('-- srxrxrecord ID --'+srxrxrecord.id);
                system.debug('-- Vision_On_Backorder__c --'+srxrxrecord.Vision_On_Backorder__c);
                if(finalGCPrecordsMap.get(existingRxSRxmap.get(srxrxrecord.id)).Vision_Segment__c.toLowercase()=='rx' && srxrxrecord.Vision_MoH__c<0){
                    system.debug('-- Is in Backorder RX --'+srxrxrecord.id);
                    finalGCPrecordsMap.get(existingRxSRxmap.get(srxrxrecord.id)).Vision_Is_In_Backorder__c =true;  
                }
                if(finalGCPrecordsMap.get(existingRxSRxmap.get(srxrxrecord.id)).Vision_Segment__c.toLowercase()=='srx' && srxrxrecord.Vision_On_Backorder__c.toLowercase()=='yes'){
                    system.debug('-- Is in Backorder SRX --'+srxrxrecord.id);
                    finalGCPrecordsMap.get(existingRxSRxmap.get(srxrxrecord.id)).Vision_Is_In_Backorder__c =true;  
                }
            }*/
            
            finalGCPrecords.AddAll(finalGCPrecordsMap.values());
            upsert finalGCPrecords; 
        }
        Catch(Exception e) {
            Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'GoogleDOHTradePartnerNDCLevelFetch', Phoenix_Error_Message__c = e.getMessage()+' '+currentField, Phoenix_Issue_Status__c = 'Pending', Phoenix_Method_Name__c = 'execute', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
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
                   	Database.executeBatch(new GoogleDOHTradePartnerNDCLevelFetch(limitVal,offSet));
                }
                else{
                    // storing MAX of GCP_Update_Date__c,Vision_update_date in custom Settings
                   GCP_DOH_Trade_Partner_NDC__c tradeDOHRep = [select Vision_GCP_Update_Date__c from GCP_DOH_Trade_Partner_NDC__c limit 1];
                    String Vision_gcp_update_date  = String.valueOf(tradeDOHRep.Vision_GCP_Update_Date__c).substringbefore(' ');
                    String Vision_update_date = String.valueOf(Phoenix_Util.getTodayEST()).substringbefore(' ');
                    system.debug('--Vision_gcp_update_date--'+Vision_gcp_update_date);
                    system.debug('--Vision_update_date--'+Vision_update_date);
                    DOH_NDC_Level_Dates_Info__c dohRepinfo = DOH_NDC_Level_Dates_Info__c.getInstance('Data1');
                    dohRepinfo.Vision_GCP_Update_Date__c = Vision_gcp_update_date;
                    dohRepinfo.Vision_Update_Date__c = Vision_update_date;
                    update dohRepinfo;
                    
                    Integer Records=[select count() from GCP_DOH_Trade_Partner_NDC__c ];
                    string RecordsCount= String.valueOf(Records);
                    Phoenix_Util.sendBatchJobCompletionEmail('GCP DOH Trade Partner Ndc Level ', RecordsCount);
                   	database.executeBatch(new GoogleTradePartnerDOHRepFetch());
                   //system.debug('testing');
                    
                }
                /* Integer Records=[select count() from GCP_DOH_Trade_Partner_NDC__c ];
string RecordsCount= String.valueOf(Records);

Phoenix_Util.sendBatchJobCompletionEmail('GCP DOH Trade Partner Ndc Level ', 'RecordsCount');*/
                
            }
            Catch(Exception e) {
                Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'GoogleDOHTradePartnerNDCLevelFetch', Phoenix_Error_Message__c = e.getMessage(), Phoenix_Issue_Status__c = 'Pending', Phoenix_Method_Name__c = 'execute', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
                insert exp;
            }
        }
        
    }
    
    
}