/**
 * @description       : 
 * @author            : Surender Dhruvsoft
 * @group             : 
 * @last modified on  : 25-05-2021
 * @last modified by  : Surender Dhruvsoft
 * Modifications Log 
 * Ver   Date         Author               Modification
 * 1.0   25-05-2021   Surender Dhruvsoft   Initial Version
 **/
@RestResource(urlMapping = '/SAP_Products/*') //endpoint definition > {Salesforce Base URL}/services/apexrest/SAP_Products/
global class Phoenix_SAP_Products_REST {
    
    @HttpPost //HttpPost annotation exposes the method as a REST resource and called when an HTTP POST request is sent
    global static responseWrapper productCreationToStaging() {
        
        RestRequest req = RestContext.request; //the RestRequest for the Apex REST method
        responseWrapper responseJSON = new responseWrapper(); //responseWrapper object for API response
        List<Phoenix_Bright_Exceptions__c> newExp = new List<Phoenix_Bright_Exceptions__c>();	
        Set<String> errorMessagesSet = new Set<String>(); 
        try{
        Map<String, Object> body = new Map<String, Object>(); //placeholder for the JSON Body of the request
        Map<String, Object> src = new Map<String, Object>(); //placeholder for the source object from the JSON request
        list<Phoenix_SAP_Product_Staging__c> ProductDataListToInsert=new list<Phoenix_SAP_Product_Staging__c>();
        String jsonBody = req.requestBody.toString(); //the body of the request
        if (!String.isBlank(jsonBody)) { //if the request body is NOT white space, empty ('') or null
            body = (Map<String, Object>)JSON.deserializeUntyped(jsonBody); //deserializes the JSON string into collections of primitive data types
            if (body.containsKey('ns1:MT_Material')) {               
                map<string,Object> MaterialNodeExtract= (map<string,Object>)body.get('ns1:MT_Material');
                list<object> recrdList= (list<object>)MaterialNodeExtract.get('ProductDetails');
                set<String> allSAPNumbers=new set<string>();
                for(object eachRecord:recrdList){                   
                    map<string,object> eachRecordMap=(map<string,object>)eachRecord;
                    if(eachRecordMap != null){
                        Phoenix_SAP_Product_Staging__c NewProductRec=new Phoenix_SAP_Product_Staging__c();                                 
                        NewProductRec.Phoenix_RequestJSONFromSAP__c=JSON.serialize(eachRecord);                   
                        NewProductRec.Phoenix_Active_Discontinue__c =eachRecordMap.get('Phoenix_Active_Discontinue__c').toString();
                        NewProductRec.Phoenix_Case_Pack__c=eachRecordMap.get('Phoenix_Case_Pack__c').toString();
                       // if(eachRecordMap.get('Phoenix_Compare_to_Brand_Name__c') != null) NewProductRec.Phoenix_Compare_to_Brand_Name__c=eachRecordMap.get('Phoenix_Compare_to_Brand_Name__c').toString();
                        NewProductRec.Phoenix_Controlled_Substance_Class__c=eachRecordMap.get('Phoenix_Controlled_Substance_Class__c').toString();
                        NewProductRec.Phoenix_Controlled_Substance__c=eachRecordMap.get('Phoenix_Controlled_Substance__c').toString();
                        string SAPCreatedDate=eachRecordMap.get('Phoenix_SAP_Created_Date__c').toString();
                        NewProductRec.Phoenix_SAP_Created_Date__c=(SAPCreatedDate=='0000-00-00'||String.isBlank(SAPCreatedDate))?null:Date.valueOf(SAPCreatedDate);
                        NewProductRec.Phoenix_DLS_formerly_NDC__c=eachRecordMap.get('Phoenix_DLS_formerly_NDC__c').toString();
                        NewProductRec.Phoenix_Dosage_Form__c=eachRecordMap.get('Phoenix_Dosage_Form__c').toString();
                        NewProductRec.Phoenix_Imported_or_Domestic__c=eachRecordMap.get('Phoenix_Imported_or_Domestic__c').toString();
                        NewProductRec.Phoenix_Material_Description__c=eachRecordMap.get('Phoenix_Material_Description__c').toString();
                        NewProductRec.Phoenix_Minimum_Order_Quantity__c=eachRecordMap.get('Phoenix_Minimum_Order_Quantity__c').toString();
                        NewProductRec.Phoenix_NDC__c=eachRecordMap.get('Phoenix_NDC__c').toString();
                        NewProductRec.Phoenix_Proprietary_Name_Trade_Name__c=eachRecordMap.get('Phoenix_Proprietary_Name_Trade_Name__c')?.toString();
                        NewProductRec.Phoenix_SAP_Molecule_Description__c=eachRecordMap.get('Phoenix_SAP_Molecule_Description__c')?.toString();
                        NewProductRec.Phoenix_SAP_Number__c=eachRecordMap.get('Phoenix_SAP_Number__c').toString();
                        NewProductRec.Phoenix_SAP_Pack_Size__c=eachRecordMap.get('Phoenix_SAP_Pack_Size__c').toString();
                        String SAPMdfDate=eachRecordMap.get('Phoenix_SAP_Modified_Date__c').toString();
                        NewProductRec.Phoenix_SAP_Modified_Date__c=(SAPMdfDate=='0000-00-00'||String.isBlank(SAPMdfDate))?null:Date.valueOf(SAPMdfDate);
                        NewProductRec.Phoenix_Product_Family__c=eachRecordMap.get('Phoenix_Product_Family__c').toString();
                        NewProductRec.Phoenix_SAP_Sub_Therapy_Description__c=eachRecordMap.get('Phoenix_SAP_Sub_Therapy_Description__c').toString();
                        NewProductRec.Phoenix_SAP_Therapy_Description__c=eachRecordMap.get('Phoenix_SAP_Therapy_Description__c').toString();
                        NewProductRec.Phoenix_Shelf_Life__c=eachRecordMap.get('Phoenix_Shelf_Life__c').toString();
                        NewProductRec.Phoenix_Strength__c=eachRecordMap.get('Phoenix_Strength__c').toString();
                       // if(eachRecordMap.get('Phoenix_Th_Put_Cost__c') != null) NewProductRec.Phoenix_Th_Put_Cost__c=Decimal.valueOf(eachRecordMap.get('Phoenix_Th_Put_Cost__c')?.toString());
                        NewProductRec.Phoenix_UPC__c=eachRecordMap.get('Phoenix_UPC__c')!=null?eachRecordMap.get('Phoenix_UPC__c').toString():null;
                        NewProductRec.Phoenix_WAC__c=Decimal.valueOf(eachRecordMap.get('Phoenix_WAC__c').toString());
                        NewProductRec.Phoenix_GTIN_14__c=eachRecordMap.get('Phoenix_GTIN_14__c').toString();
                        ProductDataListToInsert.add(NewProductRec); 
                        allSAPNumbers.add(eachRecordMap.get('Phoenix_SAP_Number__c').toString());
                    }
                }
                Database.SaveResult[] insertRecords = Database.insert(ProductDataListToInsert,false); //insert the list of customer stagings
                
                // Collect all success product statging record ids               
                list<Id> successIds=new list<Id>();//push the inserted record ids into this list
                for(Database.SaveResult result : insertRecords){
                    if (result.isSuccess()) {
                        successIds.add(result.getId());
                    }
                } 
                
                //fetch product staging records to get SAP Number(material in product sheet)
                Map<id,Phoenix_SAP_Product_Staging__c> insertedSAPProducts=new Map<id,Phoenix_SAP_Product_Staging__c>([select id,Phoenix_SAP_Number__c from Phoenix_SAP_Product_Staging__c where id in :successIds]);
                
                //check for errors and success records and build reposne to return                
                list<String> successSAPNumbers=new list<string>();              
                for (Database.SaveResult result : insertRecords) {
                    if (result.isSuccess()) {
                        successSAPNumbers.add(insertedSAPProducts.get(result.getId()).Phoenix_SAP_Number__c);
                        successRecordWrapper recWp=new successRecordWrapper();
                        recWp.SAPNumber=insertedSAPProducts.get(result.getId()).Phoenix_SAP_Number__c;
                        recWp.salesforceId=result.getId();
                        responseJSON.successRecords.add(recWp);
                        responseJSON.status = 'Success';                       
                    }
                    else {
                        responseJSON.status = 'Failure';
                        // Operation failed, so get all errors                     
                        for(Database.Error err : result.getErrors()) {
                            errorRecordWrapper errorWp=new errorRecordWrapper();
                            errorWp.fields=err.getFields();
                            errorWp.message=err.getMessage();
                            errorWp.statusCode=string.valueOf(err.getStatusCode());
                            responseJSON.errors.add(errorWp);
                            errorMessagesSet.add(err.getMessage()+'-'+errorWp.statusCode+'-'+err.getFields());
                            System.debug('The following error has occurred.');                    
                            System.debug(err.getStatusCode() + ': ' + err.getMessage());
                            System.debug('Account fields that affected this error: ' + err.getFields());
                        }                      
                    }
                }
                if(allSAPNumbers.size()>0 && (allSAPNumbers.size()!=successSAPNumbers.size())){
                    //allSAPNumbers - successSAPNumbers
                    list<string> failedSAPNumbers=new list<string>();
                    failedSAPNumbers.addAll(allSAPNumbers);
                    for(string sapNumber:successSAPNumbers){
                        if(failedSAPNumbers.contains(sapNumber)){                        
                            failedSAPNumbers.remove(failedSAPNumbers.indexOf(sapNumber));
                        }
                    }
                    responseJSON.successRecordsCount=successSAPNumbers.size();
                    responseJSON.failedSAPNumbers=failedSAPNumbers;                    
                    responseJSON.failedRecordsCount=failedSAPNumbers.size();
                    responseJSON.status = responseJSON.failedRecordsCount>0? 'Failure':'Success';
                }   
            } else{ 
                //respond with failure
                responseJSON.status = 'Failure';  
                responseJSON.errorMessage ='No Product data received.';
                Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c( Phoenix_Class__c='Phoenix_SAP_Products_REST', Phoenix_Error_Message__c='No Product data received.',Phoenix_Issue_Status__c='Pending', Phoenix_Method_Name__c='productCreationToStaging', Phoenix_Occurrence_Time__c=System.now(), Phoenix_Stack_Trace__c='',Phoenix_Current_User__c=UserInfo.getName()+'('+UserInfo.getUserId()+')' );   insert exp;
            }
        } else { 
            //respond with failure
            responseJSON.status = 'Failure'; 
            responseJSON.errorMessage ='No JSON body received.';
            Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c( Phoenix_Class__c='Phoenix_SAP_Products_REST', Phoenix_Error_Message__c='No JSON body received.',Phoenix_Issue_Status__c='Pending', Phoenix_Method_Name__c='productCreationToStaging', Phoenix_Occurrence_Time__c=System.now(), Phoenix_Stack_Trace__c='',Phoenix_Current_User__c=UserInfo.getName()+'('+UserInfo.getUserId()+')' );   insert exp;
        }
            for(String str : errorMessagesSet){	
                Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c( Phoenix_Class__c='Phoenix_SAP_Products_REST', Phoenix_Error_Message__c=str.substring(0,str.indexOf('-')),Phoenix_Issue_Status__c='Pending', Phoenix_Method_Name__c='productCreationToStaging', Phoenix_Occurrence_Time__c=System.now(), Phoenix_Stack_Trace__c=str,Phoenix_Current_User__c=UserInfo.getName()+'('+UserInfo.getUserId()+')' );   insert exp;	
                newExp.add(exp);
                
        }
            if(newExp.size()>0) upsert newExp;
        }
        Catch(Exception e) {Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c( Phoenix_Class__c='Phoenix_SAP_Products_REST', Phoenix_Error_Message__c=e.getMessage().subString(0,254),Phoenix_Issue_Status__c='Pending', Phoenix_Method_Name__c='productCreationToStaging', Phoenix_Occurrence_Time__c=System.now(), Phoenix_Stack_Trace__c=e.getStackTraceString(),Phoenix_Current_User__c=UserInfo.getName()+'('+UserInfo.getUserId()+')' );  
                            insert exp;}

        return responseJSON; //return the JSON response
    }
    
    
    
    global class successRecordWrapper{
        global string SAPNumber{get;set;}
        global string salesforceId{get;set;}
        global successRecordWrapper(){
            this.SAPNumber='';
            this.salesforceId='';
        }
    }   
    
    
    global class errorRecordWrapper{
        global list<string> fields{get;set;}
        global string message{get;set;}
        global string statusCode{get;set;}
        global  errorRecordWrapper(){
            this.fields=new list<string>();
            message='';
            statusCode='';
        }
    }
    
    //wrapper class for the response to an API request
    global class responseWrapper {
        
        global String status {get;set;} //status string
        global string errorMessage {get;set;}
        global list<successRecordWrapper> successRecords{get;set;} 
        global integer successRecordsCount{get;set;}    
        global list<string> failedSAPNumbers{get;set;} 
        global integer failedRecordsCount{get;set;}
        global list<errorRecordWrapper> errors{get;set;}
        //constructor
        global responseWrapper() {
            //default all values
            this.status = '';
            this.errorMessage= '';
            this.successRecords=new list<successRecordWrapper>();
            this.successRecordsCount=0;
            this.failedSAPNumbers=new list<string>();
            this.failedRecordsCount=0;
            this.errors=new list<errorRecordWrapper>();
            
        }
    }
    
}