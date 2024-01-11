public class GoogleBigQueryDataFetchBatch implements Database.Batchable < sObject > , Database.Stateful,Schedulable,Database.AllowsCallouts {
    public Integer limitVal;
    public Integer offSet;
    Integer receivedCount;
    Integer totalRows;
    public GoogleBigQueryDataFetchBatch(Integer limitValue,Integer offSetValue){
        limitVal = limitValue;
        offSet = offSetValue;  
    }
    
    public GoogleBigQueryDataFetchBatch(){
        limitVal = 100;
        offSet = 0;
    }
    
    public void execute(SchedulableContext sc) {
        Database.executeBatch(new GoogleBigQueryDataFetchBatch());
    }
    
    public Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator('Select Id FROM Account Limit 1');
    }
    
    public void execute(Database.BatchableContext BC, List < Account > accList) {
        String currentField='';
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
            string s= '\'370741\'';
            //req.setBody('{"query":"SELECT * FROM agg_zone.sfdc_market_tracker WHERE product_family is not null AND customer_code is  LIMIT '+ limitVal+' OFFSET '+offSet+'"}');
            req.setBody('{"query":"SELECT * FROM agg_zone.sfdc_100pct_analysis WHERE product_family is not null LIMIT'+ limitVal+' OFFSET '+offSet+'"}');
            Http http = new Http();
            HTTPResponse res = new HTTPResponse();
            if(!Test.isRunningTest()) res = http.send(req);
            else {
                res.setBody('{"kind":"bigquery#queryResponse","schema":{"fields":[{"name":"product_family","type":"STRING","mode":"NULLABLE"},{"name":"segment","type":"STRING","mode":"NULLABLE"},{"name":"customer_code","type":"INTEGER","mode":"NULLABLE"},{"name":"customer_name","type":"STRING","mode":"NULLABLE"},{"name":"drl_act_volume_eu","type":"FLOAT","mode":"NULLABLE"},{"name":"drl_act_sales","type":"FLOAT","mode":"NULLABLE"},{"name":"drl_act_price","type":"FLOAT","mode":"NULLABLE"},{"name":"drl_act_tpt","type":"FLOAT","mode":"NULLABLE"},{"name":"drl_act_tpt_pct","type":"FLOAT","mode":"NULLABLE"},{"name":"prof_month_range","type":"STRING","mode":"NULLABLE"},{"name":"ims_mat_volume_eu","type":"FLOAT","mode":"NULLABLE"},{"name":"ims_mat_sales","type":"FLOAT","mode":"NULLABLE"},{"name":"ims_mat_month_range","type":"STRING","mode":"NULLABLE"},{"name":"ims_drl_mkt_sh_qtr","type":"FLOAT","mode":"NULLABLE"},{"name":"ims_qtr_month_range","type":"STRING","mode":"NULLABLE"},{"name":"drl_mkt_sh_act","type":"FLOAT","mode":"NULLABLE"},{"name":"cust_act_volume_mat_eu","type":"FLOAT","mode":"NULLABLE"},{"name":"cust_act_sales_mat","type":"FLOAT","mode":"NULLABLE"},{"name":"cust_act_mkt_sh","type":"FLOAT","mode":"NULLABLE"},{"name":"gcp_suggested_price","type":"FLOAT","mode":"NULLABLE"}]},"jobReference":{"projectId":"nag-analytics","jobId":"job_vehymv3sW1Yuuno-mJxYVxDswoBh","location":"asia-south1"},"totalRows":"100","rows":[{"f":[{"v":"OLOPATADINE"},{"v":"OTC"},{"v":"147972"},{"v":"HPC-GROCERY INVOICES"},{"v":"488287.0"},{"v":"3002441.1700000004"},{"v":"6.148927106394396"},{"v":"1633557.0925241003"},{"v":"0.5440763032582917"},{"v":"Nov 2020 - Oct 2021"},{"v":null},{"v":null},{"v":null},{"v":null},{"v":null},{"v":null},{"v":"24456.0"},{"v":"135330.24000000002"},{"v":null},{"v":null}]},{"f":[{"v":"NICOTINE LOZENGE MINT"},{"v":"OTC"},{"v":"370941"},{"v":"SUPERVALU INC."},{"v":"6946488.0"},{"v":"928247.4470844998"},{"v":"0.1336283093103306"},{"v":"176507.20583590007"},{"v":"0.19015102749841697"},{"v":"Nov 2020 - Oct 2021"},{"v":null},{"v":null},{"v":null},{"v":null},{"v":null},{"v":null},{"v":"6192.0"},{"v":"864.937296"},{"v":null},{"v":null}]}],"totalBytesProcessed":"782517","jobComplete":true,"cacheHit":false}');
            }
            String gcpResponse = res.getBody();
            // Parsing BigQuery Response
            GoogleBigQuery.GoogleBigQueryRespWrapper gbqrw = GoogleBigQuery.RespParser(gcpResponse);
            totalRows = gbqrw.totalRows;     
            string uni;
            string cust;
            //Existing GCP records map for linking
            map<String,String> existingProductFamilyMap =new Map<String,String>();
            for(Product_Family__c  prdfmy : [select id,Name From Product_Family__c])
            {
                existingProductFamilyMap.put(prdfmy.Name,prdfmy.id); 
                
            }            
            //SF - GCP fields Map
            Map<String,String> gcpSfFieldsMap = new Map<String,String>();
          //  gcpSfFieldsMap.put('record_id','GCP_Unique_Identifier__c'); 
            gcpSfFieldsMap.put('product_family','GCP_Product_Family__c'); 
            gcpSfFieldsMap.put('customer_code','GCP_Customer_Code_temp__c');
            //gcpSfFieldsMap.put('customer_sfid','Phoenix_Customer__c');
            gcpSfFieldsMap.put('customer_name','gcp_customer_name__c');
            gcpSfFieldsMap.put('Ims_Drl_Mkt_Sh_Qtr','Phoenix_Ims_Drl_Mkt_Sh_Qtr__c');
            gcpSfFieldsMap.put('drl_act_sales','Phoenix_Drl_Act_Sales__c');//ok
            gcpSfFieldsMap.put('drl_act_tpt_pct','Phoenix_DRL_Actual_TPT_Per__c');//ok
            gcpSfFieldsMap.put('segment','Phoenix_Segment__c');
            gcpSfFieldsMap.put('drl_act_volume_eu','Phoenix_Drl_Act_Volume_Eu__c');//ok
            gcpSfFieldsMap.put('drl_act_price','Phoenix_Drl_Act_Price__c');//ok
            gcpSfFieldsMap.put('drl_act_tpt','Phoenix_DRL_Actual_TPT__c');//ok
            gcpSfFieldsMap.put('prof_month_range','Phoenix_Prof_Month_Range__c');
            gcpSfFieldsMap.put('ims_mat_volume_eu','Phoenix_Total_Market_Vol_MAT_EU__c');
            gcpSfFieldsMap.put('ims_mat_sales','Phoenix_Total_Market_Sales__c');
            gcpSfFieldsMap.put('ims_mat_month_range','Ims_Mat_Month_Range__c');
            gcpSfFieldsMap.put('ims_drl_mkt_sh_qtr','Phoenix_Ims_Drl_Mkt_Sh_Qtr__c');
            gcpSfFieldsMap.put('ims_qtr_month_range','Phoenix_Ims_Qtr_Month_Range__c');
            gcpSfFieldsMap.put('drl_mkt_sh_act','Phoenix_Drl_Mkt_Sh_Act__c');
            gcpSfFieldsMap.put('current_position','current_position__c');
            gcpSfFieldsMap.put('cooling_period','cooling_period__c'); 
            gcpSfFieldsMap.put('est_acct_market_sh','Phoenix_Estimate_Account_Marketing_Share__c');//No
            gcpSfFieldsMap.put('est_acct_sh_of_wallet','Phoenix_Est_Acct_Share_of_Wallet__c');//No
            gcpSfFieldsMap.put('est_acct_tot_vol_eu','Phoenix_Est_Acct_Total_Vol_EU__c');//No
            gcpSfFieldsMap.put('est_acct_price','Phoenix_Est_Price_EU__c');//No
            gcpSfFieldsMap.put('est_acct_sales','Phoenix_Est_Acct_Sales__c');//No
            gcpSfFieldsMap.put('cust_act_volume_mat_eu','Phoenix_Cust_Act_Volume_Mat_Eu__c');
            gcpSfFieldsMap.put('cust_act_sales_mat','Cust_Act_Sales_Mat__c');
            gcpSfFieldsMap.put('cust_act_mkt_sh','Phoenix_Cust_Act_Mkt_Sh__c');
            gcpSfFieldsMap.put('cust_opp_sales','Phoenix_Customer_Opp_Sales__c');//No
            gcpSfFieldsMap.put('cust_opp_tpt_dollar','Phoenix_Customer_Opp_TPT__c');//No
            gcpSfFieldsMap.put('cogs_per_unit','cogs_per_unit__c');//No
            gcpSfFieldsMap.put('cust_opp_tpt_pct','Phoenix_Customer_Opp_TPT_Perc__c');//No
            gcpSfFieldsMap.put('cust_opp_probability','Phoenix_Opportunity_Probability__c');//No    picklist in SF
            gcpSfFieldsMap.put('gcp_suggested_price','Phoenix_GCP_Suggested_Lowest_Price__c');
            gcpSfFieldsMap.put('comments','comments__c');
            gcpSfFieldsMap.put('Gcp_update_date','GCP_Updated_Date__c');
             
            
            // adding decimal fields to a list
            List<String> decimalFields = new List<String>();
            List<String> dateFields = new List<String>();
            String SobjectApiName = 'Phoenix_GCP_Opportunity_Tracker__c';
            Map<String,Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get(SobjectApiName).newSObject().getSobjectType().getDescribe().fields.getMap();
            for(String fieldName : fieldMap.keyset())
            {
                Schema.DisplayType fielddataType = fieldMap.get(fieldName).getDescribe().getType();
                String fldStringType = String.valueOf(fielddataType);
                if(fldStringType == 'PERCENT' || fldStringType == 'DOUBLE' || fldStringType == 'CURRENCY')
                {
                    decimalFields.add(fieldName);
                }
                else if(fldStringType == 'DATE')
                {
                    dateFields.add(fieldName);
                }
                
            }
            List< Phoenix_GCP_Opportunity_Tracker__c> finalGCPrecords = new List< Phoenix_GCP_Opportunity_Tracker__c >();
            Set<String> gcp_unique_ids = new Set<String>();
            Map<String,Phoenix_GCP_Opportunity_Tracker__c> finalGCPrecordsMap = new Map<String,Phoenix_GCP_Opportunity_Tracker__c >();
            
            list<Phoenix_GCP_Opportunity_Tracker__c> insertList = new  list<Phoenix_GCP_Opportunity_Tracker__c>();
            list<Phoenix_GCP_Opportunity_Tracker__c> updateList = new  list<Phoenix_GCP_Opportunity_Tracker__c>();
            
            List<String> accNums = new List<String>();
            for(Integer rowCounter : gbqrw.jsonRowMap.keySet()){
                Map<Integer,String> tempRowMap = gbqrw.jsonRowMap.get(rowCounter);
                for(Integer valNo : tempRowMap.keySet()){
                    String fieldName = gcpSfFieldsMap.get(gbqrw.jsonFieldMap.get(valNo));
                    currentField = fieldName;
                    if(currentField == 'GCP_Customer_Code_temp__c'){
                        if(!accNums.contains(tempRowMap.get(valNo)))
                            accNums.add(tempRowMap.get(valNo));
                    }
                }
            }
            
            //Account map for linking
            map<String,Account> accMap =new Map<String,Account>();
            for(Account acc : [select id,name,accountNumber From Account WHERE accountNumber IN: accNums])accMap.put(acc.accountNumber,acc);
            
            Map<string, Phoenix_GCP_Opportunity_Tracker__c> existingGcpMap = new Map<string, Phoenix_GCP_Opportunity_Tracker__c>();
            for(Phoenix_GCP_Opportunity_Tracker__c gcp : [select Id,Unique_Identifier_Test__c,GCP_Customer_Code_temp__c,GCP_Product_Family__c,Phoenix_Customer__c,Phoenix_Customer__r.accountNumber 
                                                          From Phoenix_GCP_Opportunity_Tracker__c Where Phoenix_Customer__r.accountNumber IN: accNums ]){// 
                string iden = gcp.GCP_Product_Family__c+'_'+gcp.Phoenix_Customer__r.accountNumber;
                if(!existingGcpMap.containskey(iden))
                    existingGcpMap.put(iden,gcp);
            }
            
            
            for(Integer rowCounter : gbqrw.jsonRowMap.keySet()){
                Map<Integer,String> tempRowMap = gbqrw.jsonRowMap.get(rowCounter);
                string uniqString = '';
                for(Integer valNo : tempRowMap.keySet()){
                    String fieldName = gcpSfFieldsMap.get(gbqrw.jsonFieldMap.get(valNo));
                    currentField = fieldName;
                    String fieldValue = tempRowMap.get(valNo);
                    if(fieldValue != null && fieldName != null){
                        if(fieldName == 'GCP_Product_Family__c')
                            uniqString = (uniqString == '' ? fieldValue : fieldValue+''+uniqString);
                        else if(currentField == 'GCP_Customer_Code_temp__c')
                            uniqString = (uniqString == '' ? '_'+fieldValue : uniqString+'_'+fieldValue);
                    }
                }
                Phoenix_GCP_Opportunity_Tracker__c gcpSFRec = new Phoenix_GCP_Opportunity_Tracker__c();
                if(existingGcpMap.containsKey(uniqString))
                    gcpSFRec = existingGcpMap.get(uniqString);
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
                        else {
                            gcpSFRec.put(fieldName , fieldValue);  
                        }
                    }   
                }
                gcpSFRec.Product_Family__c  = existingProductFamilyMap.containsKey(gcpSFRec.GCP_Product_Family__c) ? existingProductFamilyMap.get(gcpSFRec.GCP_Product_Family__c) : null;
                gcpSFRec.Vision_Update_Date__c = System.today();
                gcpSFRec.GCP_Unique_Identifier__c  = uniqString;//gcpSFRec.GCP_Product_Family__c +'_'+ gcpSFRec.GCP_Customer_Code_temp__c+'_'+gcpSFRec.Phoenix_Segment__c;
                //gcpSFRec.Id = existingGCPMap.containsKey(gcpSFRec.GCP_Unique_Identifier__c) ? existingGCPMap.get(gcpSFRec.GCP_Unique_Identifier__c) : null;
                
                gcpSFRec.Phoenix_Customer__c = accMap.containsKey(gcpSFRec.GCP_Customer_Code_temp__c) ? accMap.get(gcpSFRec.GCP_Customer_Code_temp__c).Id : gcpSFRec.Phoenix_Customer__c;
                finalGCPrecords.add(gcpSFRec);
                
                //gcp_unique_ids.add(gcpSFRec.GCP_Product_Family__c+'_'+gcpSFRec.Phoenix_Customer__c);
                //uni=gcpSFRec.GCP_Product_Family__c+'_'+gcpSFRec.Phoenix_Customer__c;
                //finalGCPrecordsMap.put(uni,gcpSFRec);  
            }
            
            
            //finalGCPrecords.AddAll(finalGCPrecordsMap.values());
            //upsert finalGCPrecords;
        }
        Catch(Exception e) {            
            Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'GoogleBigQueryDataFetchBatch', Phoenix_Error_Message__c = e.getMessage()+' '+currentField, Phoenix_Issue_Status__c = 'Pending', Phoenix_Method_Name__c = 'execute', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');            insert exp;
         } 
    }
    
    public void finish(Database.BatchableContext BC) {
        //Plan for next run
        if(!Test.isRunningTest()){
            try{
                System.debug('Total Row Count is ======> '+totalRows + '   Limit Val is ======> ' +limitVal);
                if(totalRows == limitVal){
                    offSet = offSet + limitVal;
                    Database.executeBatch(new GoogleBigQueryDataFetchBatch(limitVal,offSet));
                }
                else{
                      Integer Records=[select count() from  Phoenix_GCP_Opportunity_Tracker__c];
                string RecordsCount= 'Total Records are '+String.valueOf(Records);
                
                Phoenix_Util.sendBatchJobCompletionEmail('GCP Opportunity Tracker  ', RecordsCount);
                    Database.executeBatch(new GoogleNoOppProductsFetch());
                }
                
            }
            Catch(Exception e) {
                Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'GoogleBigQueryDataFetchBatch', Phoenix_Error_Message__c = e.getMessage(), Phoenix_Issue_Status__c = 'Pending', Phoenix_Method_Name__c = 'execute', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
                insert exp;
            }
        }
        
    }
}