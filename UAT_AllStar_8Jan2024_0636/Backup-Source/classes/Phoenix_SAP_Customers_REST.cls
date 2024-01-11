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
@RestResource(urlMapping = '/SAP_Customers/*') //endpoint definition > {Salesforce Base URL}/services/apexrest/SAP_Customers/
global class Phoenix_SAP_Customers_REST {
    
    @HttpPost //HttpPost annotation exposes the method as a REST resource and called when an HTTP POST request is sent
    global static responseWrapper CustomerCreationToStaging() {
        
        RestRequest req = RestContext.request; //the RestRequest for the Apex REST method
        responseWrapper responseJSON = new responseWrapper(); //responseWrapper object for API response
        List<Phoenix_Bright_Exceptions__c> newExp = new List<Phoenix_Bright_Exceptions__c>();	
        Set<String> errorMessagesSet = new Set<String>(); 

        try{
        
        Map<String, Object> body = new Map<String, Object>(); //placeholder for the JSON Body of the request
        Map<String, Object> src = new Map<String, Object>(); //placeholder for the source object from the JSON request
        
        list<Phoenix_SAP_Customer_Staging__c> CustomerDataListToInsert=new list<Phoenix_SAP_Customer_Staging__c>();
        String jsonBody = req.requestBody.toString(); //the body of the request
        
        if (!String.isBlank(jsonBody)) { //if the request body is NOT white space, empty ('') or null
            body = (Map<String, Object>)JSON.deserializeUntyped(jsonBody); //deserializes the JSON string into collections of primitive data types
            if (body.containsKey('ns1:MT_Customer')) {
                map<string,Object> customerNodeExtract= (map<string,Object>)body.get('ns1:MT_Customer');
                list<object> recrdList= (list<object>)customerNodeExtract.get('records');
                set<String> allCustomerCodes=new set<string>();
                for(object eachRecord:recrdList){                   
                    map<string,object> eachRecordMap=(map<string,object>)eachRecord;                    
                    Phoenix_SAP_Customer_Staging__c NewCustomerRec=new Phoenix_SAP_Customer_Staging__c();
                    NewCustomerRec.Phoenix_RequestJSONFromSAP__c=JSON.serialize(eachRecord); 
                    NewCustomerRec.Phoenix_City__c =eachRecordMap.get('Phoenix_City__c').toString();
                    NewCustomerRec.Phoenix_Country__c=eachRecordMap.get('Phoenix_Country__c').toString();
                    NewCustomerRec.Phoenix_Distribution_Channel__c=eachRecordMap.get('Phoenix_Distribution_Channel__c').toString();
                    NewCustomerRec.Phoenix_Division__c=eachRecordMap.get('Phoenix_Division__c').toString();
                    string efctFromDate=eachRecordMap.get('Phoenix_Effective_From__c').toString();
                    NewCustomerRec.Phoenix_Effective_From__c=(efctFromDate=='0000-00-00'|| String.isBlank(efctFromDate))?null:Date.valueOf(efctFromDate);
                    string efctToDate=eachRecordMap.get('Phoenix_Effective_To__c').toString();
                    NewCustomerRec.Phoenix_Effective_To__c=(efctToDate=='0000-00-00'||String.isBlank(efctToDate))?null:(efctToDate=='9999-12-31')?Date.newInstance(4000, 12, 31):Date.valueOf(efctToDate);
                    NewCustomerRec.Phoenix_Parent_SAP_Customer__c=eachRecordMap.get('Phoenix_Parent_SAP_Customer__c').toString();
                    if(eachRecordMap.get('Phoenix_Parent_SAP_Customer_Code__c').toString() != '') NewCustomerRec.Phoenix_Parent_SAP_Customer_Code__c=String.valueOf(Integer.valueOf(eachRecordMap.get('Phoenix_Parent_SAP_Customer_Code__c')?.toString()));//Mamatha
                    NewCustomerRec.Phoenix_Partner_Function__c=eachRecordMap.get('Phoenix_Partner_Function__c').toString();
                    NewCustomerRec.Phoenix_Postal_Code__c=eachRecordMap.get('Phoenix_Postal_Code__c').toString();
                    NewCustomerRec.Phoenix_Region__c=eachRecordMap.get('Phoenix_Region__c').toString();
                    NewCustomerRec.Phoenix_Sales_Organization__c=eachRecordMap.get('Phoenix_Sales_Organization__c').toString();
                    if(eachRecordMap.get('Phoenix_SAP_Customer_Code__c').toString() != '')  NewCustomerRec.Phoenix_SAP_Customer_Code__c=String.valueOf(Integer.valueOf(eachRecordMap.get('Phoenix_SAP_Customer_Code__c').toString()));//Mamatha
                    NewCustomerRec.Phoenix_SAP_Customer_Group__c=eachRecordMap.get('Phoenix_SAP_Customer_Group__c').toString();
                    NewCustomerRec.Phoenix_SAP_Customer_Name_2__c=eachRecordMap.get('Phoenix_SAP_Customer_Name_2__c').toString();
                    string modDate=eachRecordMap.get('Phoenix_SAP_Modified_Date__c').toString();
                    NewCustomerRec.Phoenix_SAP_Modified_Date__c=(modDate=='0000-00-00'|| String.isBlank(modDate))?null:Date.valueOf(modDate);
                    if(eachRecordMap.get('Phoenix_SAP_Created_Date__c')!=null){
                        string createDate=eachRecordMap.get('Phoenix_SAP_Created_Date__c').toString();
                        NewCustomerRec.Phoenix_SAP_Created_Date__c=(createDate=='0000-00-00'|| String.isBlank(createDate))?null:Date.valueOf(createDate);
                    } 
                    NewCustomerRec.Phoenix_SAP_Customer_Name__c=eachRecordMap.get('Phoenix_SAP_Customer_Name__c').toString();
                    NewCustomerRec.Phoenix_Street__c=eachRecordMap.get('Phoenix_Street__c').toString();
                    allCustomerCodes.add(eachRecordMap.get('Phoenix_SAP_Customer_Code__c').toString());
                    CustomerDataListToInsert.add(NewCustomerRec);
                }
                Database.SaveResult[] insertRecords = Database.insert(CustomerDataListToInsert,false); //insert the list of customer stagings
                
                // Collect all success customer statging record ids               
                list<Id> successIds=new list<Id>();//push the inserted record ids into this list
                for(Database.SaveResult result : insertRecords){
                    if (result.isSuccess()) {
                        successIds.add(result.getId());
                    }
                }
                //fetch customer staging records to get SAP customer code
                Map<id,Phoenix_SAP_Customer_Staging__c> insertedSAPCustomers=new Map<id,Phoenix_SAP_Customer_Staging__c>([select id,Phoenix_SAP_Customer_Code__c from Phoenix_SAP_Customer_Staging__c where id in :successIds]);
                
                //check for errors and success records and build reposne to return                
                list<String> successCustomerCodes=new list<string>();              
                for (Database.SaveResult result : insertRecords) {
                    if (result.isSuccess()) {
                        successCustomerCodes.add(insertedSAPCustomers.get(result.getId()).Phoenix_SAP_Customer_Code__c);
                        successRecordWrapper recWp=new successRecordWrapper();
                        recWp.customerCode=insertedSAPCustomers.get(result.getId()).Phoenix_SAP_Customer_Code__c;
                        recWp.salesforceId=result.getId();
                        responseJSON.successRecords.add(recWp);
                        responseJSON.status = 'Success';                       
                    }
                    else {
                        
                        // Operation failed, so get all errors                     
                        for(Database.Error err : result.getErrors()) {
                            errorRecordWrapper errorWp=new errorRecordWrapper();
                            errorWp.fields=err.getFields();
                            errorWp.message=err.getMessage();
                            errorWp.statusCode=string.valueOf(err.getStatusCode());
                            responseJSON.errors.add(errorWp);
                            errorMessagesSet.add(err.getMessage()+'-'+errorWp.statusCode+'-'+err.getFields());
                            //System.debug('The following error has occurred.');                    
                            //System.debug(err.getStatusCode() + ': ' + err.getMessage());
                            //System.debug('Account fields that affected this error: ' + err.getFields());
                        }                      
                    }
                }               
                if(allCustomerCodes.size()>0 && (allCustomerCodes.size()!=successCustomerCodes.size()) ){
                    //allCustomerCodes - successCustomerCodes
                    list<string> failedCustomerCodes=new list<string>();
                    failedCustomerCodes.addAll(allCustomerCodes);                   
                    for(string code:successCustomerCodes){
                        if(failedCustomerCodes.contains(code)){                            
                            failedCustomerCodes.remove(failedCustomerCodes.indexOf(code));
                        }
                    }
                    responseJSON.successRecordsCount=successCustomerCodes.size();
                    responseJSON.failedCustomerCodes=failedCustomerCodes;
                    responseJSON.failedRecordsCount=responseJSON.errors.size();
                    
                }
                
            } 
            else{ 
                //respond with failure
                responseJSON.status = 'Failure';
                responseJSON.errorMessage ='No Customer data received.';
                Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c( Phoenix_Class__c='Phoenix_SAP_Customers_REST', Phoenix_Error_Message__c='No Customer data received.',Phoenix_Issue_Status__c='Pending', Phoenix_Method_Name__c='CustomerCreationToStaging', Phoenix_Occurrence_Time__c=System.now(), Phoenix_Stack_Trace__c='',Phoenix_Current_User__c=UserInfo.getName()+'('+UserInfo.getUserId()+')' );   insert exp;

                
            }
        } else { 
            //respond with failure
            responseJSON.status = 'Failure';
            responseJSON.errorMessage ='No JSON body received.';
            Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c( Phoenix_Class__c='Phoenix_SAP_Customers_REST', Phoenix_Error_Message__c='No JSON body received.',Phoenix_Issue_Status__c='Pending', Phoenix_Method_Name__c='CustomerCreationToStaging', Phoenix_Occurrence_Time__c=System.now(), Phoenix_Stack_Trace__c='',Phoenix_Current_User__c=UserInfo.getName()+'('+UserInfo.getUserId()+')' );   insert exp;

        }
             for(String str : errorMessagesSet){	
                Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c( Phoenix_Class__c='Phoenix_SAP_Customers_REST', Phoenix_Error_Message__c=str.substring(0,str.indexOf('-')),Phoenix_Issue_Status__c='Pending', Phoenix_Method_Name__c='CustomerCreationToStaging', Phoenix_Occurrence_Time__c=System.now(), Phoenix_Stack_Trace__c=str,Phoenix_Current_User__c=UserInfo.getName()+'('+UserInfo.getUserId()+')' );   insert exp;	
                newExp.add(exp);
                
        }
            if(newExp.size()>0) upsert newExp;
        }
        Catch(Exception e) {Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c( Phoenix_Class__c='Phoenix_SAP_Customers_REST', Phoenix_Error_Message__c=e.getMessage(),Phoenix_Issue_Status__c='Pending', Phoenix_Method_Name__c='CustomerCreationToStaging', Phoenix_Occurrence_Time__c=System.now(), Phoenix_Stack_Trace__c=e.getStackTraceString(),Phoenix_Current_User__c=UserInfo.getName()+'('+UserInfo.getUserId()+')' );   insert exp;}

        
        return responseJSON; //return the JSON response
    }
    
    global class successRecordWrapper{
        global string customerCode{get;set;}
        global string salesforceId{get;set;}
        global successRecordWrapper(){
            this.customerCode='';
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
        global list<string> failedCustomerCodes{get;set;}
        global integer failedRecordsCount{get;set;}
        global list<errorRecordWrapper> errors{get;set;}
        //constructor
        global responseWrapper() {
            //default all values
            this.status = '';
            this.errorMessage= '';
            this.successRecords=new list<successRecordWrapper>();
            this.successRecordsCount=0;
            this.failedCustomerCodes=new list<string>();
            this.failedRecordsCount=0;
            this.errors=new list<errorRecordWrapper>();
            
        }
    }
    
}