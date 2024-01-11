/*
In this Class we will update Customerproducttracker Object fields when we find  Same Contract Number and Product Code that Mathches with Customerresponse lines,
We will Update Vision_Contract_Product_Status__c as 'Awarded',
Vision_Is_In_Awarded__c as 'True',
Vision_Supply_Effective_Date__c from Customerresponseline Phoenix_Supply_Effective_Date__c,
Vision_Awarded_Volume__c, from Phoenix_Awarded_Quantity__c field of  Phoenix_Awarded_Quantity__c object where Phoenix_Material_Code__c and Phoenix_Contract_Number__c which Matches with Customerresponseline's Contract Number and Product Code,
Vision_On_Contract__c as true,
Vision_Previous_Volume__c,Vision_Customer_Response_Name__c,Vision_Previous_DeadNet__c,Vision_Internal_DeadNet__c,Customer_Response_Line__c,Vision_Customer_Response_Created_Date__c,Vision_Customer_Response_Name__c from CustomerResponseLine.
*/
public class AwardedQtyContractPrdStatusBatchCls implements Database.Batchable < sObject > , Database.Stateful,Schedulable,Database.AllowsCallouts {
    public void execute(SchedulableContext sc) {
        //Database.executeBatch(new AwardedQtyContractPrdStatusBatchCls());
    }
    public Database.QueryLocator start(Database.BatchableContext BC) {
        //Query - If a New Account has become bid account in last 24 Hours
        string s='300018384';
        //String query = 'Select Phoenix_Bid_Line_Item__r.Phoenix_Awarded_Quantity__c,Phoenix_Bid_Line_Item__r.Phoenix_Total_Selling_Unit__c,Phoenix_Bid_Line_Item__r.Phoenix_Current_ASP_Dose__c,Phoenix_Bid_Line_Item__r.Phoenix_Proposed_ASP_Dose__c,Phoenix_Bid_Line_Item__r.Phoenix_Product__r.ProductCode, ' +Phoenix_Util.getsObjectFieds('Phoenix_Customer_Response_Line__c')+' from Phoenix_Customer_Response_Line__c Where CreatedDate = LAST_N_DAYS:1';
        String query = 'Select Phoenix_Bid_Line_Item__r.Phoenix_Awarded_Quantity__c,Phoenix_Bid_Line_Item__r.Phoenix_Total_Selling_Unit__c,Phoenix_Bid_Line_Item__r.Phoenix_Current_ASP_Dose__c,Phoenix_Bid_Line_Item__r.Phoenix_Proposed_ASP_Dose__c,Phoenix_Bid_Line_Item__r.Phoenix_Product__r.ProductCode, ' +Phoenix_Util.getsObjectFieds('Phoenix_Customer_Response_Line__c')+' from Phoenix_Customer_Response_Line__c';
        if(Test.isRunningTest())query += ' LIMIT 1';
        return Database.getQueryLocator(query);
        
    }
    public void execute(Database.BatchableContext BC, List <Phoenix_Customer_Response_Line__c> cusRespLinesList) {
        try{
            if(cusRespLinesList.size() > 0){
                List<Vision_Customer_Product_Tracker__c> cptUpdateList = new List<Vision_Customer_Product_Tracker__c>();
                map<String,list<Phoenix_Customer_Response_Line__c>> existingCusRespMap = new map<String,list<Phoenix_Customer_Response_Line__c>>();
                for(Phoenix_Customer_Response_Line__c cusResRec : cusRespLinesList){
                    if(!existingCusRespMap.containsKey(cusResRec.Phoenix_Customer_Response__c)){
                        existingCusRespMap.put(cusResRec.Phoenix_Customer_Response__c,new list<Phoenix_Customer_Response_Line__c>{cusResRec});
                    }
                    else{
                        existingCusRespMap.get(cusResRec.Phoenix_Customer_Response__c).add(cusResRec);
                    }
                }
               // system.debug('existingcusrespmap'+existingCusRespMap);
                map<String, Phoenix_Customer_Response__c> UniqueIdsMap = new map<String, Phoenix_Customer_Response__c>();
                map<String, Phoenix_Customer_Response_Line__c> existingCusRespLinesRecs = new map<String, Phoenix_Customer_Response_Line__c>();
                for(Phoenix_Customer_Response__c cusRes: [select Id,Phoenix_Affected_Contract_s__c,createdDate,Name from Phoenix_Customer_Response__c where id in : existingCusRespMap.keySet()] ){
                    //system.debug('cusrec'+cusres);
                    if (existingCusRespMap.containsKey(cusRes.Id)){
                        for(Phoenix_Customer_Response_Line__c cusResLine : existingCusRespMap.get(cusRes.Id)){
                            if(cusRes.Phoenix_Affected_Contract_s__c != null){
                                List<String> refContractsList = cusRes.Phoenix_Affected_Contract_s__c.split(',');
                                for(String cntrNum : refContractsList){
                                    if(cusResLine.Phoenix_Bid_Line_Item__r.Phoenix_Product__r.ProductCode != null && String.isNotBlank(cntrNum)){
                                        UniqueIdsMap.put(cusResLine.Phoenix_Bid_Line_Item__r.Phoenix_Product__r.ProductCode+'_'+cntrNum, cusRes);
                                        existingCusRespLinesRecs.put(cusResLine.Phoenix_Bid_Line_Item__r.Phoenix_Product__r.ProductCode+'_'+cntrNum, cusResLine);
                                    }
                                }
                                
                                
                                
                                
                            }
                        }
                    }
                }
                system.debug('uniqueidsmap'+UniqueIdsMap);
                system.debug('existingCusRespLinesRecs'+existingCusRespLinesRecs);
                map<String, Phoenix_Awarded_Quantity__c> existingAwardedQtyMap = new map<String, Phoenix_Awarded_Quantity__c>();
                for(Phoenix_Awarded_Quantity__c awardedQtyRec: [select id, Phoenix_Material_Code__c, Phoenix_Contract_Number__c,createdDate,Phoenix_Awarded_Quantity__c from Phoenix_Awarded_Quantity__c ORDER BY createdDate DESC]){
                    if(awardedQtyRec.Phoenix_Material_Code__c != null && awardedQtyRec.Phoenix_Contract_Number__c != null){
                        String awardedQtyUnqId = awardedQtyRec.Phoenix_Material_Code__c+'_'+awardedQtyRec.Phoenix_Contract_Number__c;
                        if(!existingAwardedQtyMap.containsKey(awardedQtyUnqId)){
                            existingAwardedQtyMap.put(awardedQtyUnqId,awardedQtyRec);
                        }
                    }
                }
                for(Vision_Customer_Product_Tracker__c cpt :[SELECT Id,Vision_On_Contract__c,Vision_Supply_Effective_Date__c,Vision_Is_In_Awarded__c,Vision_Contract_Product_Status__c,Vision_Cus_Response_Lines_Created_Date__c,Vision_Customer_Response__c,Vision_Customer_Response_Created_Date__c,Vision_Customer_Response_Name__c,Vision_In_Customer_Response_Lines__c,Vision_Unique_Identifier__c ,Customer_Response_Effective_Date__c , Customer_Response_Line__c,Vision_Awarded_Volume__c,Vision_Previous_Volume__c,Vision_Previous_DeadNet__c,Vision_Internal_DeadNet__c,Vision_Current_Product_Position__c from Vision_Customer_Product_Tracker__c Where Vision_Unique_Identifier__c in : existingCusRespLinesRecs.keySet()]){
                    if(existingCusRespLinesRecs.containsKey(cpt.Vision_Unique_Identifier__c)){
                        if(existingCusRespLinesRecs.get(cpt.Vision_Unique_Identifier__c).Phoenix_Bid_Status__c == 'Awarded'){
                            cpt.Vision_Contract_Product_Status__c = 'Awarded';
                            cpt.Vision_Is_In_Awarded__c=True;
                            //if(existingCusRespLinesRecs.get(cpt.Vision_Unique_Identifier__c).Phoenix_Supply_Effective_Date__c > system.today()){ 
                            cpt.Vision_On_Contract__c = True;
                            cpt.Vision_Supply_Effective_Date__c = existingCusRespLinesRecs.get(cpt.Vision_Unique_Identifier__c).Phoenix_Supply_Effective_Date__c;
                            
                           cpt.Customer_Response_Effective_Date__c = existingCusRespLinesRecs.get(cpt.Vision_Unique_Identifier__c).Phoenix_Price_Effective_Date__c;
                           cpt.Customer_Response_Line__c = existingCusRespLinesRecs.get(cpt.Vision_Unique_Identifier__c).Id;
                            cpt.Vision_Bid__c= existingCusRespLinesRecs.get(cpt.Vision_Unique_Identifier__c).Phoenix_Bid__c;
                           cpt.Bid_Line_Item__c=existingCusRespLinesRecs.get(cpt.Vision_Unique_Identifier__c).Phoenix_Bid_Line_Item__c;
                           
                           cpt.Vision_Current_Product_Position__c =  existingCusRespLinesRecs.get(cpt.Vision_Unique_Identifier__c).Phoenix_Award_Position__c;
                            //}
                            if(existingAwardedQtyMap.containsKey(cpt.Vision_Unique_Identifier__c)){
                                system.debug('entered here');
                                cpt.Vision_Awarded_Volume__c = existingAwardedQtyMap.get(cpt.Vision_Unique_Identifier__c).Phoenix_Awarded_Quantity__c;
                                cpt.Awarded_Quantity__c=existingAwardedQtyMap.get(cpt.Vision_Unique_Identifier__c).Id;
                                
                                //if(existingAwardedQtyMap.get(cpt.Vision_Unique_Identifier__c).Phoenix_Awarded_Quantity__c != null && cpt.Vision_Temp_Awarded_Value__c != null)
                                //	cpt.Vision_Awarded_Value__c = existingAwardedQtyMap.get(cpt.Vision_Unique_Identifier__c).Phoenix_Awarded_Quantity__c * cpt.Vision_Temp_Awarded_Value__c;
                            }
                            cpt.Vision_Previous_Volume__c = existingCusRespLinesRecs.get(cpt.Vision_Unique_Identifier__c).Phoenix_Bid_Line_Item__r.Phoenix_Total_Selling_Unit__c;
                            cpt.Vision_Previous_DeadNet__c = existingCusRespLinesRecs.get(cpt.Vision_Unique_Identifier__c).Phoenix_Bid_Line_Item__r.Phoenix_Current_ASP_Dose__c;
                            cpt.Vision_Internal_DeadNet__c = existingCusRespLinesRecs.get(cpt.Vision_Unique_Identifier__c).Phoenix_Bid_Line_Item__r.Phoenix_Proposed_ASP_Dose__c;
                           
                        }
                        else{
                            cpt.Vision_Contract_Product_Status__c = 'Non Awarded';
                        }
                        
                        cpt.Vision_Cus_Response_Lines_Created_Date__c = existingCusRespLinesRecs.get(cpt.Vision_Unique_Identifier__c).createdDate;
                        cpt.Vision_In_Customer_Response_Lines__c = true;
                         cpt.Customer_Response_Line_Bid_status__c=existingCusRespLinesRecs.get(cpt.Vision_Unique_Identifier__c).Phoenix_Bid_Status__c;
                        if(UniqueIdsMap.containsKey(cpt.Vision_Unique_Identifier__c)){
                            cpt.Vision_Customer_Response__c = UniqueIdsMap.get(cpt.Vision_Unique_Identifier__c).Id;
                            cpt.Vision_Customer_Response_Created_Date__c = UniqueIdsMap.get(cpt.Vision_Unique_Identifier__c).createdDate;
                            cpt.Vision_Customer_Response_Name__c = UniqueIdsMap.get(cpt.Vision_Unique_Identifier__c).Name;
                        }
                    }
                    cptUpdateList.add(cpt);
                }
                if(cptUpdateList.size()>0){
                    update cptUpdateList;
                }
            }
            else{
               // system.debug('---No Records to Process---');
            }
        }
        Catch(Exception e) {
            Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'AwardedQtyContractPrdStatusBatchCls', Phoenix_Error_Message__c = e.getMessage(), Phoenix_Issue_Status__c = 'Pending', Phoenix_Method_Name__c = 'execute', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
            insert exp;
        }
    }
    public void finish(Database.BatchableContext bc){
        //if(!Test.isRunningTest())
        	//Database.executeBatch(new NPRBasedContractProductUpdateBatchCls(),2000);
    }
    
}