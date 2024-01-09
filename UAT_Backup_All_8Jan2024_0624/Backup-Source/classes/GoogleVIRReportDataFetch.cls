public class GoogleVIRReportDataFetch implements Database.Batchable < sObject > , Database.Stateful,Schedulable,Database.AllowsCallouts {
    public Integer limitVal;
    public Integer offSet;
    Integer receivedCount;
    Integer totalRows;
    public GoogleVIRReportDataFetch(Integer limitValue,Integer offSetValue){
        limitVal = limitValue;
        offSet = offSetValue;
    }
    
    public GoogleVIRReportDataFetch() {
        limitVal = 100;
        offSet = 0;
    }
    
    public void execute(SchedulableContext sc) {
        Database.executeBatch(new GoogleVIRReportDataFetch());
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
            req.setBody('{"query":"SELECT * FROM agg_zone.sfdc_vir_report LIMIT '+ limitVal+' OFFSET '+offSet+'"}');
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
                res.setBody('{ "kind": "bigquery#queryResponse", "schema": { "fields": [ { "name": "Customer", "type": "STRING", "mode": "NULLABLE" }, { "name": "Customer_code", "type": "STRING", "mode": "NULLABLE" }, { "name": "Agreement", "type": "STRING", "mode": "NULLABLE" }, { "name": "tenure", "type": "STRING", "mode": "NULLABLE" }, { "name": "Month_Text", "type": "STRING", "mode": "NULLABLE" }, { "name": "Year", "type": "STRING", "mode": "NULLABLE" }, { "name": "month", "type": "INTEGER", "mode": "NULLABLE" }, { "name": "Direct_sales", "type": "NUMERIC", "mode": "NULLABLE" }, { "name": "indirect_sales", "type": "NUMERIC", "mode": "NULLABLE" }, { "name": "credit_sales", "type": "NUMERIC", "mode": "NULLABLE" }, { "name": "Vistex_sales", "type": "NUMERIC", "mode": "NULLABLE" }, { "name": "Net_sales", "type": "NUMERIC", "mode": "NULLABLE" }, { "name": "Gcp_update_date", "type": "DATE", "mode": "NULLABLE" } ] }, "jobReference": { "projectId": "nag-analytics", "jobId": "job_ityzZvdaI0dXYoE4NRrXAx2jyVPG", "location": "asia-south1" }, "totalRows": "1", "rows": [ { "f": [ { "v": "ABC" }, { "v": null }, { "v": "ABC 2020" }, { "v": null }, { "v": "Sep" }, { "v": "2020" }, { "v": "9" }, { "v":null }, { "v": "6805889.480000001" }, { "v": null }, { "v": null }, { "v": "6805889.480000001" }, { "v": "2022-03-02" } ] } ], "totalBytesProcessed": "32326", "jobComplete": true, "cacheHit": false} ');

                gcpResponse = res.getBody();
            }
            //System.debug('GCP Response is ====>'+gcpResponse);
            
            // Parsing BigQuery Response
            GoogleBigQuery.GoogleBigQueryRespWrapper gbqrw = GoogleBigQuery.RespParser(gcpResponse);
            totalRows = gbqrw.totalRows;
            
            //Account map for linking
            map<String,Account> accMap =new Map<String,Account>();
			for( Account acc : [select id,name,accountNumber From Account where accountNumber != null])accMap.put(acc.accountNumber,acc);
            //Contract Map for Linking
            Map<String,Phoenix_Contract__c> existingCntrMap = new Map<String,Phoenix_Contract__c>();
            for(Phoenix_Contract__c cntr : [select Id, createdDate, Name, Phoenix_Customer__c, Phoenix_Customer__r.accountNumber,Phoenix_Contract_Number__c,Phoenix_Customer__r.Name from Phoenix_Contract__c where Phoenix_Contract_Status__c =: 'Active']){
                existingCntrMap.put(cntr.Phoenix_Contract_Number__c,cntr);
            }
            
            //Existing GCP records map for linking
            map<String,String> existingProductFamilyMap =new Map<String,String>();
            for(GCP_Product_Family_Map__c  prdfmy : [select id,GCP_Product_Family__c, SFDC_Product_Family__c From GCP_Product_Family_Map__c])
            {
                existingProductFamilyMap.put(prdfmy.GCP_Product_Family__c,prdfmy.SFDC_Product_Family__c); 
            }
            Map<String,String> gcpSfFieldsMap = new Map<String,String>();
            gcpSfFieldsMap.put('Agreement_No','Vision_Agreement_Number__c');
            gcpSfFieldsMap.put('Customer','Vision_GCP_Customer__c');
            gcpSfFieldsMap.put('Customer_code','Vision_GCP_Customer_Code__c');
            gcpSfFieldsMap.put('Agreement','Vision_GCP_Agreement__c');
            gcpSfFieldsMap.put('tenure','Vision_GCP_Tenure__c');
            gcpSfFieldsMap.put('Month_Text','Vision_GCP_Month_Text__c'); 
            gcpSfFieldsMap.put('Year','Vision_GCP_Year__c'); 
            gcpSfFieldsMap.put('month','Vision_GCP_Month__c'); 
            gcpSfFieldsMap.put('Direct_sales','Vision_Gcp_Direct_Sales__c'); 
            gcpSfFieldsMap.put('indirect_sales','Vision_GCP_Indirect_Sales__c'); 
            gcpSfFieldsMap.put('credit_sales','Vision_GCP_Credit_Sales__c'); 
            gcpSfFieldsMap.put('Vistex_sales','Vision_GCP_Vistex_Sales__c'); 
            gcpSfFieldsMap.put('Net_sales','Vision_GCP_Net_Sales__c'); 
             gcpSfFieldsMap.put('Payment_frequency','Vision_Payment_Frequency__c');
             gcpSfFieldsMap.put('Net_Contract','Vision_Net_Contract__c');
             gcpSfFieldsMap.put('data_available_till','Vision_Data_Available_Till__c');
            gcpSfFieldsMap.put('Gcp_update_date','Vision_GCP_Update_Date__c');
            
            // adding decimal fields to a list
            List<String> decimalFields = new List<String>();
            List<String> dateFields = new List<String>();
            String SobjectApiName = 'GCP_VIR_Report__c';
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
            List<GCP_VIR_Report__c> finalGCPrecords = new List<GCP_VIR_Report__c>();
            Set<String> gcp_unique_ids = new Set<String>();
            Map<String,GCP_VIR_Report__c> finalGCPrecordsMap = new Map<String,GCP_VIR_Report__c>();
            List<String> ignoreDatainDates = new List<String>{'TBD','None',''};
                for(Integer rowCounter : gbqrw.jsonRowMap.keySet()){//1
                    Map<Integer,String> tempRowMap = gbqrw.jsonRowMap.get(rowCounter);
                    GCP_VIR_Report__c gcpSFRec = new GCP_VIR_Report__c();
                    
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
                                if(!ignoreDatainDates.contains(fieldValue))
                                    gcpSFRec.put(fieldName , Date.valueOf(fieldValue));
                            }
                           
                          else{
                                gcpSFRec.put(fieldName , fieldValue);
                                System.debug('fieldName=>'+fieldName  + '  fieldValue=>'+fieldValue);
                            }
                            
                        }
                        
                    }
                    
                  	
                    Map<string,Integer> monthTexttoNumericmap = new Map<string,Integer>{'jan'=>01,'feb'=>02,'mar'=>03,'apr'=>04,'may'=>05,'jun'=>06,'jul'
                        =>07,'aug'=>08,'sep'=>09,'oct'=>10,'nov'=>11,'dec'=>12,'january'=>01,'february'=>02,'march'=>03,'april'=>04,'may'=>05,'june'=>06,
                        'july'=>07,'august'=>08,'september'=>09,'october'=>10,'november'=>11,'december'=>12};
                    if(gcpSFRec.Vision_GCP_Tenure__c != null){
                        if(gcpSFRec.Vision_GCP_Tenure__c.Contains('to')){
                            List<string> tenureSplitDate =gcpSFRec.Vision_GCP_Tenure__c.split('to');
                            for(Integer i=0;i<tenureSplitDate.size();i++){
                                String formattedVal = tenureSplitDate[i].trim().replace('\'', ' ');
                                List<string> singleTenureValList =formattedVal.split(' ');
                                if(monthTexttoNumericmap.containsKey(singleTenureValList[0].toLowerCase())){
                                    String tenureDate = String.valueOf(System.Today().year()).substring(0,2)+ singleTenureValList[1] +'-'+monthTexttoNumericmap.get(singleTenureValList[0].toLowerCase())+'-01';
                                    if(i==0)
                                    	gcpSFRec.Vision_GCP_Start_Date__c = Date.valueOf(tenureDate);
                                    else if(i==1)
                                        gcpSFRec.Vision_GCP_End_Date__c = Date.valueOf(tenureDate);
                                }
                            }
                            
                        }
                    }
                    gcpSFRec.Vision_GCP_Unique_Identifier__c   = gcpSFRec.Vision_GCP_Customer__c +'_'+ gcpSFRec.Vision_GCP_Customer_Code__c+'_'+gcpSFRec.Vision_GCP_Agreement__c+'_'+gcpSFRec.Vision_GCP_Year__c+'_'+gcpSFRec.Vision_GCP_Month__c;
                    map<String,list<GCP_VIR_Report__c>> noTenureVIRRepRecsMap = new map<String,list<GCP_VIR_Report__c>>();
                    if(gcpSFRec.Vision_GCP_Customer_Code__c != null || test.isRunningTest()==true){
                        gcpSFRec.Vision_Account__c  = accMap.containsKey(gcpSFRec.Vision_GCP_Customer_Code__c) ? accMap.get(gcpSFRec.Vision_GCP_Customer_Code__c).Id : gcpSFRec.Vision_Account__c;
                        if(gcpSFRec.Vision_GCP_Tenure__c == null){
                            if (!noTenureVIRRepRecsMap.containsKey(gcpSFRec.Vision_GCP_Customer_Code__c))
                                noTenureVIRRepRecsMap.put(gcpSFRec.Vision_GCP_Customer_Code__c,new list<GCP_VIR_Report__c>{gcpSFRec});
                            
                            else
                                noTenureVIRRepRecsMap.get(gcpSFRec.Vision_GCP_Customer_Code__c).add(gcpSFRec);
                        }
                    }
                    if(gcpSFRec.Vision_Agreement_Number__c!=null){
                        gcpSFRec.Vision_Contract__c = existingCntrMap.containsKey(gcpSFRec.Vision_Agreement_Number__c)?existingCntrMap.get(gcpSFRec.Vision_Agreement_Number__c).Id:gcpSFRec.Vision_Contract__c;
                    }
                    //gcpSFRec.Vision_GCP_Unique_Identifier__c   = gcpSFRec.Vision_GCP_Customer__c +'_'+ gcpSFRec.Vision_GCP_Customer_Code__c+'_'+gcpSFRec.Vision_GCP_Agreement__c+'_'+gcpSFRec.Vision_GCP_Year__c+'_'+gcpSFRec.Vision_GCP_Month__c;
                    gcp_unique_ids.add(gcpSFRec.Vision_GCP_Unique_Identifier__c );
                    finalGCPrecordsMap.put(gcpSFRec.Vision_GCP_Unique_Identifier__c ,gcpSFRec);
                    
                    
                }
            //Existing GCP records map for linking
            for(GCP_VIR_Report__c gcp : [select Id,	Vision_GCP_Unique_Identifier__c From GCP_VIR_Report__c Where Vision_GCP_Unique_Identifier__c in : gcp_unique_ids]){
                finalGCPrecordsMap.get(gcp.Vision_GCP_Unique_Identifier__c).Id = gcp.Id;
            }
            finalGCPrecords.AddAll(finalGCPrecordsMap.values());
            upsert finalGCPrecords;            
        }
        Catch(Exception e) {
            Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'GoogleVIRReportDataFetch', Phoenix_Error_Message__c = e.getMessage()+' '+currentField, Phoenix_Issue_Status__c = 'Pending', Phoenix_Method_Name__c = 'execute', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
            insert exp;
        }
        
    }
    
    public void finish(Database.BatchableContext BC) {
        //Plan for next run
        System.debug('Total Row Count is ======> '+totalRows + '   Limit Val is ======> ' +limitVal);
       
        if(!Test.isRunningTest()){
            try{
                if(totalRows == limitVal){
                    offSet = offSet + limitVal;                    Database.executeBatch(new GoogleVIRReportDataFetch(limitVal,offSet));
                }
                else{                    Integer Records=[select count() from GCP_VIR_Report__c ];                    string RecordsCount='Total Records are '+ String.valueOf(Records);                    Phoenix_Util.sendBatchJobCompletionEmail('GCP VIR Report', RecordsCount);
                }
                
            }
            
            Catch(Exception e) {
                Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'GoogleVIRReportDataFetch', Phoenix_Error_Message__c = e.getMessage(), Phoenix_Issue_Status__c = 'Pending', Phoenix_Method_Name__c = 'execute', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
                insert exp;
            }
        }
    }
    
}