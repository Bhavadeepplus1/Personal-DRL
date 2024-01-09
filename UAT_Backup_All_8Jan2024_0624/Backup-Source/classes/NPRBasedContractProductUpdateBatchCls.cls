/*
In this Class we will update Customerproducttracker Object fields when we find  Same Contract Number and Product Code that Mathches that of  NPR Data,
We will Update Vision_Contract_Product_Status__c as 'Awarded',
Vision_Awarded_Date__c from Npr's Phoenix_Price_Effective_Value_From__c Field,
Vision_NPR_Data__c as Npr Lookup,
Vision_Price_Effective_Date__c,Phoenix_Price_Effective_Value_To__c of Npr,
Vision_Awarded_Price__c from contract Price Od Npr,
Vision_Awarded_Value__c as Phoenix_Contract_Price__c*Phoenix_12Months_Sales_Unit__c of Npr,
Vision_Awarded_Volume__c from Phoenix_12Months_Sales_Unit__c from Npr
*/
public class NPRBasedContractProductUpdateBatchCls implements Database.Batchable < sObject > , Database.Stateful, Schedulable{
    public void execute(SchedulableContext sc) {
        //Database.executeBatch(new NPRBasedContractProductUpdateBatchCls());
    }
    public Database.QueryLocator start(Database.BatchableContext BC) {
        //Querying the NPR Lines created in last 24 Hrs.
       // string s='300011866';
        //string p='1000000785';
        string status='Active';
        //String query = 'Select Phoenix_Product__r.ProductCode,Phoenix_Contract__r.Phoenix_Contract_Number__c, '+Phoenix_Util.getsObjectFieds('Phoenix_NPR_Data__c')+' from Phoenix_NPR_Data__c Where CreatedDate = LAST_N_DAYS:1';
        String query = 'Select Phoenix_Product__r.ProductCode,Phoenix_Contract__r.Phoenix_Contract_Number__c, '+Phoenix_Util.getsObjectFieds('Phoenix_NPR_Data__c')+' from Phoenix_NPR_Data__c where Phoenix_NPR_Status__c=:status';
        if(Test.isRunningTest())query += ' LIMIT 1';
        return Database.getQueryLocator(query);
    }
    public void execute(Database.BatchableContext BC, List <Phoenix_NPR_Data__c> nprList) {
        try{
            if(nprList.size() > 0){
                List<Vision_Customer_Product_Tracker__c> listOfCustomerProductTracker = new List<Vision_Customer_Product_Tracker__c>();
              //  List<Vision_Customer_Product_Log__c> listOfCustomerProductLog = new List<Vision_Customer_Product_Log__c>();
                Map<String,Phoenix_NPR_Data__c> existingNPRData = new Map<String,Phoenix_NPR_Data__c>();
                for(Phoenix_NPR_Data__c npr : nprList){
                    string uniqueIdentifier = npr.Phoenix_Product__r.ProductCode+'_'+npr.Phoenix_Contract__r.Phoenix_Contract_Number__c;
                    existingNPRData.put(uniqueIdentifier,npr);
                }
                for(Vision_Customer_Product_Tracker__c track: [SELECT Id,Vision_On_Contract__c,Vision_Price_Effective_Date__c,Vision_Price_End_Date__c,Vision_Awarded_Date__c,Vision_NPR_Data__c,Vision_Contract_Product_Status__c,Vision_Is_In_Awarded__c,Vision_Current_Product_Position__c,Vision_Unique_Identifier__c ,Vision_Contract__c, Vision_Account__c,Vision_Awarded_Volume__c  FROM Vision_Customer_Product_Tracker__c WHERE Vision_Unique_Identifier__c IN:existingNPRData.keySet()]){
                    if(existingNPRData.containsKey(track.Vision_Unique_Identifier__c)){
                        track.Vision_Contract_Product_Status__c = 'Awarded';
                        track.Vision_Is_In_Awarded__c=True;
                       track.Vision_Current_Product_Position__c= existingNPRData.get(track.Vision_Unique_Identifier__c).Phoenix_Product_Position__c;
                        track.Vision_Awarded_Date__c = existingNPRData.get(track.Vision_Unique_Identifier__c).Phoenix_Price_Effective_Value_From__c;
                        track.Vision_NPR_Data__c = existingNPRData.get(track.Vision_Unique_Identifier__c).Id;
                       // track.Vision_In_NPR_Data__c = true;
                        track.Vision_On_Contract__c = True;
                        track.Vision_NPR_Created_Date__c = existingNPRData.get(track.Vision_Unique_Identifier__c).createdDate;
                        track.Vision_Price_Effective_Date__c=existingNPRData.get(track.Vision_Unique_Identifier__c).Phoenix_Price_Effective_Value_From__c;
                        track.Vision_Price_End_Date__c=existingNPRData.get(track.Vision_Unique_Identifier__c).Phoenix_Price_Effective_Value_To__c;
                        
                        	track.Vision_Awarded_Volume__c = existingNPRData.get(track.Vision_Unique_Identifier__c).Phoenix_12Months_Sales_Unit__c;
                        	track.Vision_Awarded_Price__c = existingNPRData.get(track.Vision_Unique_Identifier__c).Phoenix_Contract_Price__c;
                            if(existingNPRData.get(track.Vision_Unique_Identifier__c).Phoenix_Contract_Price__c != null && existingNPRData.get(track.Vision_Unique_Identifier__c).Phoenix_12Months_Sales_Unit__c !=null)
                            	track.Vision_Awarded_Value__c = existingNPRData.get(track.Vision_Unique_Identifier__c).Phoenix_Contract_Price__c * existingNPRData.get(track.Vision_Unique_Identifier__c).Phoenix_12Months_Sales_Unit__c;
                            //if(existingNPRData.get(track.Vision_Unique_Identifier__c).Phoenix_12Months_Sales_Unit__c != null && track.Vision_Temp_Awarded_Value__c != null)
                            //	track.Vision_Awarded_Value__c = existingNPRData.get(track.Vision_Unique_Identifier__c).Phoenix_12Months_Sales_Unit__c * track.Vision_Temp_Awarded_Value__c;
                        
                        listOfCustomerProductTracker.add(track);
                     /*  Vision_Customer_Product_Log__c log = new Vision_Customer_Product_Log__c(
                            Phoenix_Customer__c = track.Vision_Account__c,
                            Phoenix_Contract__c = track.Vision_Contract__c,
                            Phoenix_NPR_Data__c = track.Vision_NPR_Data__c,
                            Vision_Awarded_Volume__c = existingNPRData.get(track.Vision_Unique_Identifier__c).Phoenix_12Months_Sales_Unit__c,
                            Vision_Deadnet_Price__c = existingNPRData.get(track.Vision_Unique_Identifier__c).Phoenix_Dead_Net_Tracking_GR__c,
                            Phoenix_New_Existing_Product__c = 'New Product',
                            Phoenix_Status__c = 'Active',
                            Phoenix_Price_Effective_Value_From__c = existingNPRData.get(track.Vision_Unique_Identifier__c).Phoenix_Price_Effective_Value_From__c,
                            Phoenix_Price_Effective_Value_To__c = existingNPRData.get(track.Vision_Unique_Identifier__c).Phoenix_Price_Effective_Value_To__c
                        );
                        listOfCustomerProductLog.add(log);*/
                    }
                }
                update listOfCustomerProductTracker;
              //  insert listOfCustomerProductLog;
            }
            else{
              }
        }
        Catch(Exception e) {
            Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'NPRBasedContractProductUpdateBatchCls', Phoenix_Error_Message__c = e.getMessage(), Phoenix_Issue_Status__c = 'Pending', Phoenix_Method_Name__c = 'execute', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
            insert exp;
        }
    }
    public void finish(Database.BatchableContext BC) {
        if(!Test.isRunningTest())
           Database.executeBatch(new AwardedQtyContractPrdStatusBatchCls(),2000);
    }
}