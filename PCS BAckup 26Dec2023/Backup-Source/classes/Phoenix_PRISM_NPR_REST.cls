/* @description       : 
 * @author            : Surender Dhruvsoft
 * @group             : 
 * @last modified on  : 06-07-2022
 * @last modified by  : Surender Dhruvsoft
 * Modifications Log 
 * Ver   Date         Author               Modification
 * 1.0   06-07-2022   Surender Dhruvsoft   Initial Version
 **/
@RestResource(urlMapping = '/PRISM_NetPriceReport/*') //endpoint definition > {Salesforce Base URL}/services/apexrest/PRISM_NetPriceReport/
global class Phoenix_PRISM_NPR_REST {
    
    @HttpPost //HttpPost annotation exposes the method as a REST resource and called when an HTTP POST request is sent
    global static responseWrapper NPRCreationToStaging() {
        
        RestRequest req = RestContext.request; //the RestRequest for the Apex REST method
        responseWrapper responseJSON = new responseWrapper(); //responseWrapper object for API response
        List<Phoenix_Bright_Exceptions__c> newExp = new List<Phoenix_Bright_Exceptions__c>();
         Set<String> errorMessagesSet = new Set<String>(); 
        try{
            
            Map<String, Object> body = new Map<String, Object>(); //placeholder for the JSON Body of the request
            Map<String, Object> src = new Map<String, Object>(); //placeholder for the source object from the JSON request
            
            list<PRISM_NPR_Staging__c> nprListToInsert=new list<PRISM_NPR_Staging__c>();
            String jsonBody = req.requestBody.toString(); //the body of the request
            
            if (!String.isBlank(jsonBody)) { //if the request body is NOT white space, empty ('') or null
                body = (Map<String, Object>)JSON.deserializeUntyped(jsonBody); //deserializes the JSON string into collections of primitive data types
                if (body.containsKey('ns1:MT_NetPriceReport')) {
                    Map<string,Object> nprNodeExtract = (Map<string,Object>)body.get('ns1:MT_NetPriceReport');
                    List<object> recrdList= (List<object>)nprNodeExtract.get('NetPriceReportDetails');
                    set<String> allNPRKeys = new set<string>();
                    for(object eachRecord:recrdList){                   
                        map<string,object> eachRecordMap=(map<string,object>)eachRecord;                    
                        PRISM_NPR_Staging__c NewNPRStagingRec = new PRISM_NPR_Staging__c();
                        NewNPRStagingRec.Phoenix_RequestJSONFromSAP__c=JSON.serialize(eachRecord); 
                        NewNPRStagingRec.Phoenix_Contract_Number__c =eachRecordMap.get('Phoenix_Contract_Number__c').toString();
                        NewNPRStagingRec.Phoenix_Contract_External_Description__c=eachRecordMap.get('Phoenix_Contract_External_Description__c').toString();
                        if(eachRecordMap.get('Phoenix_Contract_Internal_Description__c') != null)  NewNPRStagingRec.Phoenix_Contract_Internal_Description__c=eachRecordMap.get('Phoenix_Contract_Internal_Description__c').toString();
                        
                        string conStartDt=eachRecordMap.get('Phoenix_Contract_Start_Date__c').toString();
                        NewNPRStagingRec.Phoenix_Contract_Start_Date__c=(conStartDt=='0000-00-00'|| String.isBlank(conStartDt))?null:Date.valueOf(conStartDt);
                        string conEndDt=eachRecordMap.get('Phoenix_Contract_End_Date__c').toString();
                        NewNPRStagingRec.Phoenix_Contract_End_Date__c=(conEndDt=='0000-00-00'||String.isBlank(conEndDt))?null:Date.valueOf(conEndDt);
                        NewNPRStagingRec.Phoenix_Customer_Number__c=String.valueOf(Integer.valueOf(eachRecordMap.get('Phoenix_Customer_Number__c')?.toString()));
                        
                        NewNPRStagingRec.Phoenix_Customer_Name__c=eachRecordMap.get('Phoenix_Customer_Name__c').toString();
                        NewNPRStagingRec.Phoenix_Customer_Group__c=eachRecordMap.get('Phoenix_Customer_Group__c').toString();
                        NewNPRStagingRec.Phoenix_Material_Number__c=String.valueOf(Integer.valueOf(eachRecordMap.get('Phoenix_Material_Number__c')?.toString()));
                        
                        NewNPRStagingRec.Phoenix_Vistex_Description__c=eachRecordMap.get('Phoenix_Vistex_Description__c').toString();
                        NewNPRStagingRec.Phoenix_Vistex_Product_Hierarchy__c=eachRecordMap.get('Phoenix_Vistex_Product_Hierarchy__c').toString();
                        NewNPRStagingRec.Phoenix_UPC_NDC10__c=eachRecordMap.get('Phoenix_UPC_NDC10__c').toString();
                        NewNPRStagingRec.Phoenix_NDC11__c=eachRecordMap.get('Phoenix_NDC11__c').toString();
                        NewNPRStagingRec.Phoenix_Contract_Type__c=eachRecordMap.get('Phoenix_Contract_Type__c').toString();
                        NewNPRStagingRec.Phoenix_WAC__c=Decimal.valueOf((eachRecordMap.get('Phoenix_WAC__c')).toString());
                        NewNPRStagingRec.Phoenix_WAC_Units__c=eachRecordMap.get('Phoenix_WAC_Units__c').toString();
                        NewNPRStagingRec.Phoenix_Contract_Price__c=Decimal.valueOf(eachRecordMap.get('Phoenix_Contract_Price__c').toString());
                        NewNPRStagingRec.Phoenix_CP_Units__c=eachRecordMap.get('Phoenix_CP_Units__c').toString();
                        NewNPRStagingRec.Phoenix_Sales_Unit_90__c=Decimal.valueOf(eachRecordMap.get('Phoenix_Sales_Unit_90__c').toString());
                        NewNPRStagingRec.Phoenix_Net_Sales_90__c=Decimal.valueOf(eachRecordMap.get('Phoenix_Net_Sales_90__c').toString());
                        NewNPRStagingRec.Phoenix_12Mt_Sales_Ut__c=Decimal.valueOf(eachRecordMap.get('Phoenix_12Mt_Sales_Ut__c').toString());
                        NewNPRStagingRec.Phoenix_12Months_Net_Sales__c=Decimal.valueOf(eachRecordMap.get('Phoenix_12Months_Net_Sales__c').toString());
                        string Phoenix_Sales_From_Date_last_90_Days =eachRecordMap.get('Phoenix_Sales_From_Date_last_90_Days__c').toString();
                        NewNPRStagingRec.Phoenix_Sales_From_Date_last_90_Days__c=(Phoenix_Sales_From_Date_last_90_Days=='0000-00-00'|| String.isBlank(Phoenix_Sales_From_Date_last_90_Days))?null:Date.valueOf(Phoenix_Sales_From_Date_last_90_Days);
                        
                        NewNPRStagingRec.Phoenix_Rebate_G_N_Indicator__c=eachRecordMap.get('Phoenix_Rebate_G_N_Indicator__c').toString();
                        NewNPRStagingRec.Phoenix_Rebate__c=Decimal.valueOf(eachRecordMap.get('Phoenix_Rebate__c').toString());
                        NewNPRStagingRec.Phoenix_Rebate_in_Value__c=Decimal.valueOf(eachRecordMap.get('Phoenix_Rebate_in_Value__c').toString());
                        NewNPRStagingRec.Phoenix_Per_Unit_Rebate__c=Decimal.valueOf(eachRecordMap.get('Phoenix_Per_Unit_Rebate__c').toString());
                        NewNPRStagingRec.Phoenix_ZITD_Value__c=Decimal.valueOf(eachRecordMap.get('Phoenix_ZITD_Value__c').toString());
                        NewNPRStagingRec.Phoenix_Grwth_L_Tier__c=Decimal.valueOf(eachRecordMap.get('Phoenix_Grwth_L_Tier__c').toString());
                        NewNPRStagingRec.Phoenix_Grwth_H_Tier__c=Decimal.valueOf(eachRecordMap.get('Phoenix_Grwth_H_Tier__c').toString());
                        NewNPRStagingRec.Phoenix_Bonafied_G_N_Indicator__c=eachRecordMap.get('Phoenix_Bonafied_G_N_Indicator__c').toString();
                        NewNPRStagingRec.Phoenix_Fee_Bonafied_Fee__c=Decimal.valueOf(eachRecordMap.get('Phoenix_Fee_Bonafied_Fee__c').toString());
                        NewNPRStagingRec.Phoenix_Fee_in_Value__c=Decimal.valueOf(eachRecordMap.get('Phoenix_Fee_in_Value__c').toString());
                        NewNPRStagingRec.Phoenix_Per_Unit_Bonafied_Fee__c=Decimal.valueOf(eachRecordMap.get('Phoenix_Per_Unit_Bonafied_Fee__c').toString());
                        NewNPRStagingRec.Phoenix_NetPrice__c=Decimal.valueOf(eachRecordMap.get('Phoenix_NetPrice__c').toString());
                        NewNPRStagingRec.Phoenix_Net_Price_w_o_Fees__c=Decimal.valueOf(eachRecordMap.get('Phoenix_Net_Price_w_o_Fees__c').toString());
                        NewNPRStagingRec.Phoenix_Net_Price_with_Fees__c=Decimal.valueOf(eachRecordMap.get('Phoenix_Net_Price_with_Fees__c').toString());
                        NewNPRStagingRec.Phoenix_Sales_Group__c=eachRecordMap.get('Phoenix_Sales_Group__c').toString();
                        NewNPRStagingRec.Phoenix_WAC_Check__c=eachRecordMap.get('Phoenix_WAC_Check__c').toString();
                        NewNPRStagingRec.Phoenix_CD__c=Decimal.valueOf(eachRecordMap.get('Phoenix_CD__c').toString());
                        NewNPRStagingRec.Phoenix_CD_in__c=Decimal.valueOf(eachRecordMap.get('Phoenix_CD_in__c').toString());
                        NewNPRStagingRec.Phoenix_Net_Price_w_o_Fee_CD__c=Decimal.valueOf(eachRecordMap.get('Phoenix_Net_Price_w_o_Fee_CD__c').toString());
                        NewNPRStagingRec.Phoenix_Net_Price_Fees_CD__c=Decimal.valueOf(eachRecordMap.get('Phoenix_Net_Price_Fees_CD__c').toString());
                        NewNPRStagingRec.Phoenix_Net_Price_w_o_Fee_CD_HiGR__c=Decimal.valueOf(eachRecordMap.get('Phoenix_Net_Price_w_o_Fee_CD_HiGR__c').toString());
                        NewNPRStagingRec.Phoenix_Net_Price_Fees_CD_HiGR__c=Decimal.valueOf(eachRecordMap.get('Phoenix_Net_Price_Fees_CD_HiGR__c').toString());
                        
                        String Phoenix_Price_Effective_Value_From =eachRecordMap.get('Phoenix_Price_Effective_Value_From__c').toString();
                        NewNPRStagingRec.Phoenix_Price_Effective_Value_From__c=(Phoenix_Price_Effective_Value_From=='0000-00-00'|| String.isBlank(Phoenix_Price_Effective_Value_From))?null:Date.valueOf(Phoenix_Price_Effective_Value_From);
                        
                        String Phoenix_Price_Effective_Value_To =eachRecordMap.get('Phoenix_Price_Effective_Value_To__c').toString();
                        NewNPRStagingRec.Phoenix_Price_Effective_Value_To__c=(Phoenix_Price_Effective_Value_To=='0000-00-00'|| String.isBlank(Phoenix_Price_Effective_Value_To))?null:Date.valueOf(Phoenix_Price_Effective_Value_To);                    
                        
                        NewNPRStagingRec.Phoenix_ZD07_Off_Inv__c=Decimal.valueOf(eachRecordMap.get('Phoenix_ZD07_Off_Inv__c').toString());
                        NewNPRStagingRec.Phoenix_CM_Fee__c=Decimal.valueOf(eachRecordMap.get('Phoenix_CM_Fee__c').toString());
                        NewNPRStagingRec.Phoenix_CM_Fee_in__c=Decimal.valueOf(eachRecordMap.get('Phoenix_CM_Fee_in__c').toString());
                        NewNPRStagingRec.Phoenix_RDC_NLC__c=Decimal.valueOf(eachRecordMap.get('Phoenix_RDC_NLC__c').toString());
                        NewNPRStagingRec.Phoenix_RDC_NLC_in__c=Decimal.valueOf(eachRecordMap.get('Phoenix_RDC_NLC_in__c').toString());
                        NewNPRStagingRec.Phoenix_ABS__c=Decimal.valueOf(eachRecordMap.get('Phoenix_ABS__c').toString());
                        NewNPRStagingRec.Phoenix_ABS_in_Currency__c=Decimal.valueOf(eachRecordMap.get('Phoenix_ABS_in_Currency__c').toString());
                        NewNPRStagingRec.Phoenix_Add_ABS_Value__c=Decimal.valueOf(eachRecordMap.get('Phoenix_Add_ABS_Value__c').toString());
                        NewNPRStagingRec.Phoenix_ZD07_Off_Inv_dollar__c=Decimal.valueOf(eachRecordMap.get('Phoenix_ZD07_Off_Inv_Value__c').toString());
                        NewNPRStagingRec.Phoenix_Dead_Net_High_GR__c=Decimal.valueOf(eachRecordMap.get('Phoenix_Dead_Net_High_GR__c').toString());                   
                        NewNPRStagingRec.Phoenix_Net_Price_for_GR_basis__c=Decimal.valueOf(eachRecordMap.get('Phoenix_Net_Price_for_GR_basis__c').toString());
                        NewNPRStagingRec.Phoenix_GR_Rebate_High_Tier__c=Decimal.valueOf(eachRecordMap.get('Phoenix_GR_Rebate_High_Tier__c').toString());
                        NewNPRStagingRec.Phoenix_GR_HighTier_in__c=Decimal.valueOf(eachRecordMap.get('Phoenix_GR_HighTier_in__c').toString());
                        NewNPRStagingRec.Phoenix_GR_Tracking_Tier__c=Decimal.valueOf(eachRecordMap.get('Phoenix_GR_Tracking_Tier__c').toString());
                        NewNPRStagingRec.Phoenix_GR_Tracking_in__c=Decimal.valueOf(eachRecordMap.get('Phoenix_GR_Tracking_in__c').toString());
                        NewNPRStagingRec.Phoenix_Dead_Net_Tracking_GR__c=Decimal.valueOf(eachRecordMap.get('Phoenix_Dead_Net_Tracking_GR__c').toString());
                        NewNPRStagingRec.Phoenix_NP_wo_fee_CD_Trck_Tier__c=Decimal.valueOf(eachRecordMap.get('Phoenix_NP_wo_fee_CD_Trck_Tier__c').toString());
                        NewNPRStagingRec.Phoenix_NP_fees_CD_Trcktier__c=Decimal.valueOf(eachRecordMap.get('Phoenix_NP_fees_CD_Trcktier__c').toString());
                        NewNPRStagingRec.Phoenix_Product_Position__c=eachRecordMap.get('Phoenix_Product_Position__c').toString();
                        if(String.isNotBlank(eachRecordMap.get('Phoenix_Market_Share__c').toString())) NewNPRStagingRec.Phoenix_Market_Share__c=Decimal.valueOf(eachRecordMap.get('Phoenix_Market_Share__c').toString());
                        
                        NewNPRStagingRec.Phoenix_Dead_Net_with_CMFee_for_H_Tier__c=Decimal.valueOf(eachRecordMap.get('Phoenix_Dead_Net_with_CMFee_for_H_Tier__c').toString());
                        NewNPRStagingRec.Phoenix_DeadNet_w_CMFee_for_Track_Tier__c=Decimal.valueOf(eachRecordMap.get('Phoenix_DeadNet_w_CMFee_for_Track_Tier__c').toString());
                        NewNPRStagingRec.Phoenix_Current_Month_Till_Date__c=Decimal.valueOf(eachRecordMap.get('Phoenix_Current_Month_Till_Date__c').toString());
                        NewNPRStagingRec.Phoenix_M1__c=Decimal.valueOf(eachRecordMap.get('Phoenix_M1__c').toString());
                        NewNPRStagingRec.Phoenix_M2__c=Decimal.valueOf(eachRecordMap.get('Phoenix_M2__c').toString());
                        NewNPRStagingRec.Phoenix_M3__c=Decimal.valueOf(eachRecordMap.get('Phoenix_M3__c').toString());
                        NewNPRStagingRec.Phoenix_M4__c=Decimal.valueOf(eachRecordMap.get('Phoenix_M4__c').toString());
                        NewNPRStagingRec.Phoenix_M5__c=Decimal.valueOf(eachRecordMap.get('Phoenix_M5__c').toString());
                        NewNPRStagingRec.Phoenix_M6__c=Decimal.valueOf(eachRecordMap.get('Phoenix_M6__c').toString());
                        NewNPRStagingRec.Phoenix_M7__c=Decimal.valueOf(eachRecordMap.get('Phoenix_M7__c').toString());
                        NewNPRStagingRec.Phoenix_M8__c=Decimal.valueOf(eachRecordMap.get('Phoenix_M8__c').toString());
                        NewNPRStagingRec.Phoenix_M9__c=Decimal.valueOf(eachRecordMap.get('Phoenix_M9__c').toString());
                        NewNPRStagingRec.Phoenix_M10__c=Decimal.valueOf(eachRecordMap.get('Phoenix_M10__c').toString());
                        NewNPRStagingRec.Phoenix_M11__c=Decimal.valueOf(eachRecordMap.get('Phoenix_M11__c').toString());
                        NewNPRStagingRec.Phoenix_M12__c=Decimal.valueOf(eachRecordMap.get('Phoenix_M12__c').toString());
                        NewNPRStagingRec.Phoenix_Total_Sale_Units__c=Decimal.valueOf(eachRecordMap.get('Phoenix_Total_Sale_Units__c').toString());
                        NewNPRStagingRec.Phoenix_Customer_Group_Code__c=eachRecordMap.get('Phoenix_Customer_Group_Code__c').toString();
                        NewNPRStagingRec.Phoenix_Sales_Org__c=Decimal.valueOf(eachRecordMap.get('Phoenix_Sales_Org__c').toString());
                        NewNPRStagingRec.Phoenix_Distribution_Channel__c=Decimal.valueOf(eachRecordMap.get('Phoenix_Distribution_Channel__c').toString());
                        NewNPRStagingRec.Phoenix_Divison__c=Decimal.valueOf(eachRecordMap.get('Phoenix_Divison__c').toString());
                        
                        NewNPRStagingRec.Phoenix_Total_NPR_Lines__c = Decimal.valueOf(eachRecordMap.get('Phoenix_Total_NPR_Lines__c').toString());
                        NewNPRStagingRec.Phoenix_NPR_Report_Type__c = eachRecordMap.get('Phoenix_NPR_Report_Type__c').toString();
                        String Phoenix_NPR_System_Date = eachRecordMap.get('Phoenix_NPR_System_Date__c').toString();
                        NewNPRStagingRec.Phoenix_NPR_System_Date__c = (Phoenix_NPR_System_Date=='0000-00-00'|| String.isBlank(Phoenix_NPR_System_Date))?null:Date.valueOf(Phoenix_NPR_System_Date);                    
                        
                        
                        
                        String nprKey = NewNPRStagingRec.Phoenix_Contract_Number__c +'_'+ NewNPRStagingRec.Phoenix_Material_Number__c;
                        allNPRKeys.add(nprKey);
                        nprListToInsert.add(NewNPRStagingRec);
                    }
                    Database.SaveResult[] insertRecords = Database.insert(nprListToInsert,false); //insert the list of NPR stagings
                    
                    // Collect all success NPR statging record ids               
                    list<Id> successIds=new list<Id>();//push the inserted record ids into this list
                    for(Database.SaveResult result : insertRecords){
                        if (result.isSuccess()) {
                            successIds.add(result.getId());
                        }
                    }
                    //fetch NPR staging records to get SAP NPR code
                    Map<id,PRISM_NPR_Staging__c> insertedNPRStagings = new Map<id,PRISM_NPR_Staging__c>([select id,Phoenix_NPR_Ref_SF__c from PRISM_NPR_Staging__c where id in :successIds]);
                    
                    //check for errors and success records and build reposne to return]
                                  
                    list<String> successNPRCodes=new list<string>();              
                    for (Database.SaveResult result : insertRecords) {
                        if (result.isSuccess()) {
                            successNPRCodes.add(insertedNPRStagings.get(result.getId()).Phoenix_NPR_Ref_SF__c);
                            successRecordWrapper recWp=new successRecordWrapper();
                            recWp.contractNo_MatNo=insertedNPRStagings.get(result.getId()).Phoenix_NPR_Ref_SF__c;
                            recWp.salesforceId=result.getId();
                            responseJSON.successRecords.add(recWp);
                            //responseJSON.status = 'Success';                       
                        }
                        else {
                            
                            // Operation failed, so get all errors                     
                            for(Database.Error err : result.getErrors()) {
                                errorRecordWrapper errorWp=new errorRecordWrapper();
                                errorWp.fields=err.getFields();
                                errorWp.message=err.getMessage();
                                errorWp.statusCode=string.valueOf(err.getStatusCode());
                                
                                errorMessagesSet.add(err.getMessage()+'-'+errorWp.statusCode+'-'+err.getFields());
                                responseJSON.errors.add(errorWp);
                                                            }                      
                        }
                    }               
                    if(allNPRKeys.size()>0 && (allNPRKeys.size()!=successNPRCodes.size()) ){
                        //allNPRKeys - successNPRCodes
                        list<string> failedNPRCodes=new list<string>();
                        failedNPRCodes.addAll(allNPRKeys);                   
                        for(string code:successNPRCodes){
                            if(failedNPRCodes.contains(code)){                            
                                failedNPRCodes.remove(failedNPRCodes.indexOf(code));
                            }
                        }
                        responseJSON.successRecordsCount=successNPRCodes.size();
                        responseJSON.failedNPRCodes=failedNPRCodes;
                        responseJSON.failedRecordsCount=failedNPRCodes.size();
                        responseJSON.status = responseJSON.failedRecordsCount>0? 'Failure':'Success';
                    }
                    
                    
                    
                } 
                else{ 
                    //respond with failure
                    responseJSON.status = 'Failure';
                    responseJSON.errorMessage ='No NPR data received.';
                    Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c( Phoenix_Class__c='Phoenix_SAP_NPR_REST', Phoenix_Error_Message__c='No NPR data received.',Phoenix_Issue_Status__c='Pending', Phoenix_Method_Name__c='NPRCreationToStaging', Phoenix_Occurrence_Time__c=System.now(), Phoenix_Stack_Trace__c='',Phoenix_Current_User__c=UserInfo.getName()+'('+UserInfo.getUserId()+')' );   insert exp;
                    
                }
            } else { 
                //respond with failure
                responseJSON.status = 'Failure';
                responseJSON.errorMessage ='No JSON body received.';
                Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c( Phoenix_Class__c='Phoenix_SAP_NPR_REST', Phoenix_Error_Message__c='No JSON body received.',Phoenix_Issue_Status__c='Pending', Phoenix_Method_Name__c='NPRCreationToStaging', Phoenix_Occurrence_Time__c=System.now(), Phoenix_Stack_Trace__c='',Phoenix_Current_User__c=UserInfo.getName()+'('+UserInfo.getUserId()+')' );   insert exp;
            }
            for(String str : errorMessagesSet){
                Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c( Phoenix_Class__c='Phoenix_SAP_NPR_REST', Phoenix_Error_Message__c=str.substring(0,str.indexOf('-')),Phoenix_Issue_Status__c='Pending', Phoenix_Method_Name__c='NPRCreationToStaging', Phoenix_Occurrence_Time__c=System.now(), Phoenix_Stack_Trace__c=str,Phoenix_Current_User__c=UserInfo.getName()+'('+UserInfo.getUserId()+')' );   insert exp;
                newExp.add(exp);
            }
            if(newExp.size()>0) upsert newExp;
        }Catch(Exception e) {Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c( Phoenix_Class__c='Phoenix_SAP_NPR_REST', Phoenix_Error_Message__c=e.getMessage(),Phoenix_Issue_Status__c='Pending', Phoenix_Method_Name__c='NPRCreationToStaging', Phoenix_Occurrence_Time__c=System.now(), Phoenix_Stack_Trace__c=e.getStackTraceString(),Phoenix_Current_User__c=UserInfo.getName()+'('+UserInfo.getUserId()+')' );   insert exp;}
        
        
        return responseJSON; //return the JSON response
    }
    
    global class successRecordWrapper{
        global string contractNo_MatNo{get;set;}
        global string salesforceId{get;set;}
        global successRecordWrapper(){
            this.contractNo_MatNo='';
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
        global list<string> failedNPRCodes{get;set;}
        global integer failedRecordsCount{get;set;}
        global list<errorRecordWrapper> errors{get;set;}
        //constructor
        global responseWrapper() {
            //default all values
            this.status = '';
            this.errorMessage= '';
            this.successRecords=new list<successRecordWrapper>();
            this.successRecordsCount=0;
            this.failedNPRCodes=new list<string>();
            this.failedRecordsCount=0;
            this.errors=new list<errorRecordWrapper>();
        }
    }
}