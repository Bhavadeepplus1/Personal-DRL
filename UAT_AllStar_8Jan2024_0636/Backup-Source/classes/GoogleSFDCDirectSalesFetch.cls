public class GoogleSFDCDirectSalesFetch implements Database.Batchable < sObject > , Database.Stateful,Schedulable,Database.AllowsCallouts {
    public Integer limitVal;
    public Integer offSet;
    Integer receivedCount;
    Integer totalRows;
    public GoogleSFDCDirectSalesFetch(Integer limitValue,Integer offSetValue){
        limitVal = limitValue;
        offSet = offSetValue;  
    }
    
    public GoogleSFDCDirectSalesFetch(){
        limitVal = 100;
        offSet = 0;
    }
    
    public void execute(SchedulableContext sc) {
        
        Database.executeBatch(new GoogleSFDCDirectSalesFetch());
    }
    
    public Database.QueryLocator start(Database.BatchableContext BC) {
         delete [Select Id FROM GCP_SFDC_Direct_Sales__c WHERE CreatedDate != Today LIMIT 10000];
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
            req.setBody('{"query":"SELECT * FROM agg_zone.Sfdc_Direct_Sales LIMIT '+ limitVal+' OFFSET '+offSet+'"}');
            Http http = new Http();
            HTTPResponse res = new HTTPResponse();
            if(!Test.isRunningTest()) res = http.send(req);
            else {
                res.setBody('{ "kind": "bigquery#queryResponse", "schema": { "fields": [ { "name": "Id", "type": "STRING", "mode": "NULLABLE" }, { "name": "Month", "type": "STRING", "mode": "NULLABLE" }, { "name": "Created_On", "type": "STRING", "mode": "NULLABLE" }, { "name": "Billing_Date", "type": "STRING", "mode": "NULLABLE" }, { "name": "Sold_to_Rebate_Recipient", "type": "STRING", "mode": "NULLABLE" }, { "name": "Ship_To_Customer", "type": "STRING", "mode": "NULLABLE" }, { "name": "Customer_Recipient_Name", "type": "STRING", "mode": "NULLABLE" }, { "name": "Ship_to_State", "type": "STRING", "mode": "NULLABLE" }, { "name": "Billing_IP_Document", "type": "STRING", "mode": "NULLABLE" }, { "name": "SAP_Material", "type": "STRING", "mode": "NULLABLE" }, { "name": "Description", "type": "STRING", "mode": "NULLABLE" }, { "name": "Billing_Type", "type": "STRING", "mode": "NULLABLE" }, { "name": "Sales_CR_Doc", "type": "STRING", "mode": "NULLABLE" }, { "name": "Order_CR_Type", "type": "STRING", "mode": "NULLABLE" }, { "name": "Posting_Month", "type": "STRING", "mode": "NULLABLE" }, { "name": "Quantity", "type": "STRING", "mode": "NULLABLE" }, { "name": "Gross_dollar", "type": "STRING", "mode": "NULLABLE" }, { "name": "Net_dollar", "type": "STRING", "mode": "NULLABLE" }, { "name": "Package_Size", "type": "STRING", "mode": "NULLABLE" }, { "name": "Pricing_Date", "type": "STRING", "mode": "NULLABLE" }, { "name": "Quantity_in_Units", "type": "STRING", "mode": "NULLABLE" }, { "name": "Accounting_Document", "type": "STRING", "mode": "NULLABLE" }, { "name": "Acct_Reference", "type": "STRING", "mode": "NULLABLE" }, { "name": "Product_Family", "type": "STRING", "mode": "NULLABLE" }, { "name": "Billed_Price", "type": "STRING", "mode": "NULLABLE" }, { "name": "Customer_Hierarchy", "type": "STRING", "mode": "NULLABLE" }, { "name": "Order_Created_By", "type": "STRING", "mode": "NULLABLE" }, { "name": "Customer_Hierarchy_Name", "type": "STRING", "mode": "NULLABLE" }, { "name": "Division", "type": "STRING", "mode": "NULLABLE" }, { "name": "Order_Created_Name", "type": "STRING", "mode": "NULLABLE" }, { "name": "PO_CR_Reference_Number", "type": "STRING", "mode": "NULLABLE" }, { "name": "Order_Reason", "type": "STRING", "mode": "NULLABLE" }, { "name": "Profic_Center", "type": "STRING", "mode": "NULLABLE" }, { "name": "Settlement_Doc_CC", "type": "STRING", "mode": "NULLABLE" }, { "name": "Settlement_Doc_No", "type": "STRING", "mode": "NULLABLE" }, { "name": "Settlement_Doc_Year", "type": "STRING", "mode": "NULLABLE" }, { "name": "ZWAC", "type": "STRING", "mode": "NULLABLE" }, { "name": "NDC", "type": "STRING", "mode": "NULLABLE" }, { "name": "Order_Reason_Code", "type": "STRING", "mode": "NULLABLE" }, { "name": "Customer_Group_1", "type": "STRING", "mode": "NULLABLE" }, { "name": "Customer_Group", "type": "STRING", "mode": "NULLABLE" }, { "name": "Agreement_Description", "type": "STRING", "mode": "NULLABLE" }, { "name": "Agreement_No", "type": "STRING", "mode": "NULLABLE" }, { "name": "Sales_CR_Doc_Item", "type": "STRING", "mode": "NULLABLE" }, { "name": "Batch_Number", "type": "STRING", "mode": "NULLABLE" }, { "name": "Shelf_Life_Exp_Date", "type": "STRING", "mode": "NULLABLE" }, { "name": "Direct_Rebates_dollar", "type": "STRING", "mode": "NULLABLE" }, { "name": "Net_Direct_Rebates_BillBack_ZV87", "type": "STRING", "mode": "NULLABLE" }, { "name": "Billing_Item_No", "type": "STRING", "mode": "NULLABLE" }, { "name": "Gcp_update_date", "type": "DATE", "mode": "NULLABLE" } ] }, "jobReference": { "projectId": "nag-analytics", "jobId": "job_hKKEeAFom-vKctHZfBs2fOLrcJmD", "location": "asia-south1" }, "totalRows": "1", "rows": [ { "f": [ { "v": "1b4bf884-e798-4921-9857-0ae72cb772fb" }, { "v": " Aug 21" }, { "v": " 03-08-2021" }, { "v": "02-08-2021" }, { "v": "106131" }, { "v": "108059" }, { "v": "Golub Corporation" }, { "v": "NY" }, { "v": "9111730401" }, { "v": "300028874" }, { "v": "Bupren&Naloxone SL Film 4mg/1mg 30 USA" }, { "v": "ZB16" }, { "v": "20997948" }, { "v": "ZOR" }, { "v": "8" }, { "v": "24" }, { "v": "1841.52" }, { "v": "1747.08" }, { "v": "30" }, { "v": "02-08-2021" }, { "v": "720" }, { "v": "9111730401" }, { "v": "9111730401" }, { "v": "Buprenorphine and Naloxone" }, { "v": "76.73" }, { "v": null }, { "v": "P10USBATCH" }, { "v": null }, { "v": "31" }, { "v": "Batch User - US ." }, { "v": "47068" }, { "v": null }, { "v": "92000501" }, { "v": null }, { "v": null }, { "v": null }, { "v": "0" }, { "v": "4359858030" }, { "v": null }, { "v": "91" }, { "v": "RetailChain Pharmacy" }, { "v": "PRICE CHOPPER DIRECT" }, { "v": "1000000012" }, { "v": "20" }, { "v": "3233200B" }, { "v": "31-12-2022" }, { "v": "0" }, { "v": "1747.08" }, { "v": "20" }, { "v": "2022-03-14" } ] } ], "totalBytesProcessed": "78374030", "jobComplete": true, "cacheHit": false }');
            }
            String gcpResponse = res.getBody();            
            // Parsing BigQuery Response
            GoogleBigQuery.GoogleBigQueryRespWrapper gbqrw = GoogleBigQuery.RespParser(gcpResponse);
            totalRows = gbqrw.totalRows;
            
            map<String,Id> accMap =new map<String,Id>();
            for( Account acc : [select id,name,accountNumber From Account where accountNumber != null])
            {
                accMap.put(acc.accountNumber,acc.Id);
            }
            
            Map<String,Phoenix_Contract__c> existingCntrMap = new Map<String,Phoenix_Contract__c>();
            for(Phoenix_Contract__c cntr : [select Id, createdDate, Name, Phoenix_Customer__c, Phoenix_Customer__r.accountNumber,Phoenix_Contract_Number__c,Phoenix_Customer__r.Name from Phoenix_Contract__c where Phoenix_Contract_Status__c =: 'Active']){
                existingCntrMap.put(cntr.Phoenix_Contract_Number__c,cntr);
            }

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
           
            //Existing GCP records map for linking
            map<String,String> existingProductFamilyMap =new Map<String,String>();
            for(GCP_Product_Family_Map__c  prdfmy : [select id,GCP_Product_Family__c, SFDC_Product_Family__c From GCP_Product_Family_Map__c])
            {
                existingProductFamilyMap.put(prdfmy.GCP_Product_Family__c,prdfmy.SFDC_Product_Family__c); 
                
            }
            //SF - GCP fields Map
            Map<String,String> gcpSfFieldsMap = new Map<String,String>();
            gcpSfFieldsMap.put('Accounting_Document','Vision_Accounting_Document__c'); 
            gcpSfFieldsMap.put('Acct_Reference','Vision_Acct_Reference__c'); 
            gcpSfFieldsMap.put('Agreement_Description','Vision_Agreement_Description__c'); 
            gcpSfFieldsMap.put('Agreement_No','Vision_Agreement_No__c'); 
            gcpSfFieldsMap.put('Batch_Number','Vision_Batch_Number__c'); 
            gcpSfFieldsMap.put('Billed_Price','Vision_Billed_Price__c');
            gcpSfFieldsMap.put('Billing_Date','Vision_Billing_Date__c'); 
            gcpSfFieldsMap.put('Billing_IP_Document','Vision_Billing_IP_Document__c'); 
            gcpSfFieldsMap.put('Billing_Item_No','Vision_Billing_Item_No__c'); 
            gcpSfFieldsMap.put('Billing_Type','Vision_Billing_Type__c'); 
            gcpSfFieldsMap.put('Created_On','Vision_Created_On__c'); 
            gcpSfFieldsMap.put('Customer_Group','Vision_Customer_Group__c');
            gcpSfFieldsMap.put('Customer_Group_1','Vision_Customer_Group_1__c'); 
            gcpSfFieldsMap.put('Customer_Hierarchy','Vision_Customer_Hierarchy__c'); 
            gcpSfFieldsMap.put('Customer_Hierarchy_Name','Vision_Customer_Hierarchy_Name__c'); 
            gcpSfFieldsMap.put('Customer_Recipient_Name','Vision_Customer_Recipient_Name__c'); 
            gcpSfFieldsMap.put('Description','Vision_Description__c'); 
            gcpSfFieldsMap.put('Direct_Rebates_dollar','Vision_Direct_Rebates_Dollar__c');
            gcpSfFieldsMap.put('Division','Vision_Division__c'); 
            gcpSfFieldsMap.put('Product_Family','GCP_Product_Family__c'); 
            gcpSfFieldsMap.put('Gross_dollar','Vision_Gross_Dollar__c'); 
            gcpSfFieldsMap.put('Month','Vision_Month__c'); 
            gcpSfFieldsMap.put('NDC','Vision_NDC__c'); 
            gcpSfFieldsMap.put('Net_Direct_Rebates_BillBack_ZV87','Vision_Net_Direct_Rebates_BillBack_ZV87__c');
            gcpSfFieldsMap.put('Net_dollar','Vision_Net_Dollar__c'); 
            gcpSfFieldsMap.put('Order_Created_By','Vision_Order_Created_By__c'); 
            gcpSfFieldsMap.put('Order_Created_Name','Vision_Order_Created_Name__c'); 
            gcpSfFieldsMap.put('Order_CR_Type','Vision_Order_CR_Type__c'); 
            gcpSfFieldsMap.put('Order_Reason','Vision_Order_Reason__c'); 
            gcpSfFieldsMap.put('Order_Reason_Code','Vision_Order_Reason_Code__c');
            gcpSfFieldsMap.put('Package_Size','Vision_Package_Size__c'); 
            gcpSfFieldsMap.put('PO_CR_Reference_Number','Vision_PO_CR_Reference_Number__c'); 
            gcpSfFieldsMap.put('Posting_Month','Vision_Posting_Month__c'); 
            gcpSfFieldsMap.put('Pricing_Date','Vision_Pricing_Date__c'); 
            gcpSfFieldsMap.put('Profic_Center','Vision_Profic_Center__c'); 
            gcpSfFieldsMap.put('Quantity','Vision_Quantity__c');
            gcpSfFieldsMap.put('Quantity_in_Units','Vision_Quantity_in_Units__c'); 
            gcpSfFieldsMap.put('Sales_CR_Doc','Vision_Sales_CR_Doc__c'); 
            gcpSfFieldsMap.put('Sales_CR_Doc_Item','Vision_Sales_CR_Doc_Item__c'); 
            gcpSfFieldsMap.put('SAP_Material','Vision_SAP_Material__c'); 
            gcpSfFieldsMap.put('Settlement_Doc_CC','Vision_Settlement_Doc_CC__c'); 
            gcpSfFieldsMap.put('Settlement_Doc_No','Vision_Settlement_Doc_No__c');
            gcpSfFieldsMap.put('Settlement_Doc_Year','Vision_Settlement_Doc_Year__c'); 
            gcpSfFieldsMap.put('Shelf_Life_Exp_Date','Vision_Shelf_Life_Exp_Date__c'); 
            gcpSfFieldsMap.put('Ship_To_Customer','Vision_Ship_To_Customer__c'); 
            gcpSfFieldsMap.put('Ship_to_State','Vision_Ship_to_State__c'); 
            gcpSfFieldsMap.put('Sold_to_Rebate_Recipient','Vision_Sold_to_Rebate_Recipient__c'); 
            gcpSfFieldsMap.put('ZWAC','Vision_ZWAC__c');
             gcpSfFieldsMap.put('month_text','Vision_Month_Text__c');
            gcpSfFieldsMap.put('Id','Vision_Unique_Identifier__c');
            gcpSfFieldsMap.put('Gcp_update_date','GCP_Update_Date__c');
            
            // adding decimal fields to a list
            List<String> decimalFields = new List<String>();
            List<String> dateFields = new List<String>();
            String SobjectApiName = 'GCP_SFDC_Direct_Sales__c';
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
             
            List< GCP_SFDC_Direct_Sales__c> finalGCPrecords = new List< GCP_SFDC_Direct_Sales__c >();
            Set<String> gcp_unique_ids = new Set<String>();
            Map<String,GCP_SFDC_Direct_Sales__c> finalGCPrecordsMap = new Map<String,GCP_SFDC_Direct_Sales__c >();
            for(Integer rowCounter : gbqrw.jsonRowMap.keySet()){//1
                Map<Integer,String> tempRowMap = gbqrw.jsonRowMap.get(rowCounter);
                GCP_SFDC_Direct_Sales__c gcpSFRec = new GCP_SFDC_Direct_Sales__c();
                
                for(Integer valNo : tempRowMap.keySet()){
                    String fieldName = gcpSfFieldsMap.get(gbqrw.jsonFieldMap.get(valNo));
                    currentField = fieldName;
                    String fieldValue = tempRowMap.get(valNo);
                    if(fieldValue != null && fieldName != null && String.isNotBlank(fieldValue)){
                        if(decimalFields.contains(fieldName.toLowerCase())){
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
                if(gcpSFRec.Vision_SAP_Material__c != null){
                    gcpSFRec.Vision_Product__c = skuCodePrdMap.containsKey(gcpSFRec.Vision_SAP_Material__c) ? skuCodePrdMap.get(gcpSFRec.Vision_SAP_Material__c).Id : gcpSFRec.Vision_Product__c;
                    
                }
                else if (gcpSFRec.Vision_NDC__c != null){
                    System.debug('--- Before NDC ---'+gcpSFRec.Vision_NDC__c );
                    String ndcCode = gcpSFRec.Vision_NDC__c.replaceFirst('^0+', '');
                    System.debug('--- Before NDC ---'+gcpSFRec.Vision_NDC__c );
                    if(ndc11prodMap.containsKey(ndcCode)){
                        gcpSFRec.Vision_Product__c = ndc11prodMap.get(ndcCode).Id;
                    }
                    else if (ndc10prodMap.containsKey(ndcCode)){
                        gcpSFRec.Vision_Product__c  = ndc10prodMap.get(ndcCode).Id;
                    }
                }
                else{
                    gcpSFRec.Vision_Product__c = gcpSFRec.Vision_Product__c;
                }
                if(gcpSFRec.Vision_Customer_Hierarchy__c != null){
                    if(accMap.containsKey(gcpSFRec.Vision_Customer_Hierarchy__c)){
                        gcpSFRec.Vision_Account__c = accMap.get(gcpSFRec.Vision_Customer_Hierarchy__c);
                    }
                }
                if(gcpSFRec.Vision_Agreement_No__c != null){
                    if(existingCntrMap.containsKey(gcpSFRec.Vision_Agreement_No__c)){
                        gcpSFRec.Vision_Contract__c = existingCntrMap.get(gcpSFRec.Vision_Agreement_No__c).Id;
                    }
                }
                gcpSFRec.Vision_Updated_Date__c = system.today();
                if(gcpSFRec.GCP_Product_Family__c!=null)
                	gcpSFRec.Vision_Product_Family__c  = existingProductFamilyMap.containsKey(gcpSFRec.GCP_Product_Family__c.trim()) ? existingProductFamilyMap.get(gcpSFRec.GCP_Product_Family__c.trim()) : gcpSFRec.Vision_Product_Family__c;
                
                //gcpSFRec.GCP_Unique_Identifier__c  = gcpSFRec.GCP_Product_Family__c +'_'+ gcpSFRec.Segment__c+'_'+gcpSFRec.Comment_Date__c;
                gcp_unique_ids.add(gcpSFRec.Vision_Unique_Identifier__c);
                finalGCPrecordsMap.put(gcpSFRec.Vision_Unique_Identifier__c,gcpSFRec);
            }
            //Existing GCP records map for linking
            for(GCP_SFDC_Direct_Sales__c gcp : [select Id,Vision_Unique_Identifier__c  From GCP_SFDC_Direct_Sales__c Where Vision_Unique_Identifier__c in : gcp_unique_ids]){
                finalGCPrecordsMap.get(gcp.Vision_Unique_Identifier__c).Id = gcp.Id;
            }
            finalGCPrecords.AddAll(finalGCPrecordsMap.values());
            upsert finalGCPrecords;
            
        }
        Catch(Exception e) {            
            Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'GoogleSFDCDirectSalesFetch', Phoenix_Error_Message__c = e.getMessage()+' '+currentField, Phoenix_Issue_Status__c = 'Pending', Phoenix_Method_Name__c = 'execute', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');            insert exp;
        }
        
    }
    
    public void finish(Database.BatchableContext BC) {
        //Plan for next run
        System.debug('Total Row Count is ======> '+totalRows + '   Limit Val is ======> ' +limitVal);
        
        if(!Test.isRunningTest()){
            if(totalRows == limitVal){
                offSet = offSet + limitVal;
                Database.executeBatch(new GoogleSFDCDirectSalesFetch(limitVal,offSet));
            }
            else{
                Integer Records=[select count() from GCP_SFDC_Direct_Sales__c ];
                string RecordsCount= 'Total Records are '+String.valueOf(Records);
                Phoenix_Util.sendBatchJobCompletionEmail('SFDC Direct Sales', RecordsCount);
                Database.executeBatch(new GoogleSFDCIndirectSalesFetch());
            }
        }
    }
}