/*
 We will create cpt records from Active Contracts 
 */
public class CustomerProductActiveContractsBatchCls implements Database.Batchable < sObject > , Database.Stateful,Schedulable,Database.AllowsCallouts {
    public void execute(SchedulableContext sc) {        Database.executeBatch(new CustomerProductActiveContractsBatchCls());
    }
    public Database.QueryLocator start(Database.BatchableContext BC) {
        //Query - If a New Account has become bid account in last 24 Hours
        //String query = 'Select '+Phoenix_Util.getsObjectFieds('Phoenix_Contract__c')+' from Phoenix_Contract__c where Phoenix_Contract_Status__c =\'Active\' AND CreatedDate = LAST_N_DAYS:1';
        String query = 'Select Phoenix_Customer__r.Name,Phoenix_Customer__r.AccountNumber,'+Phoenix_Util.getsObjectFieds('Phoenix_Contract__c')+' from Phoenix_Contract__c where Phoenix_Contract_Status__c =\'Active\' AND Phoenix_Contract_Number__c != null';
      if(Test.isRunningTest())query += ' LIMIT 1';
	  return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext BC, List <Phoenix_Contract__c> contractList) {
        try{
            if(contractList.size() > 0){
                list<Vision_Customer_Product_Tracker__c> cusPrdTrackerRecs = new list<Vision_Customer_Product_Tracker__c>();
                //Update Contract level Checkbox Customer Product Tracker records Created as True
                Map<String,Phoenix_Contract__c> existingCntrMap = new Map<String,Phoenix_Contract__c>();
                for(Phoenix_Contract__c cntr : contractList){
					cntr.Vision_Is_Cus_Prd_Tracker_Created__c = true;
                    existingCntrMap.put(cntr.Phoenix_Contract_Number__c,cntr);
                }
                //Create All Customer Product Tracker records for all products
                String query = 'Select Id,ProductCode,createdDate,Family,Description,Name,Phoenix_Rx_SRx_OTC__c,Phoenix_Product_Director__r.Name from Product2 where IsActive = true AND Phoenix_Is_Exclude_Bid__c = false AND ProductCode != null AND ((Phoenix_Rx_SRx_OTC__c = \'Rx\' or Phoenix_Rx_SRx_OTC__c = \'SRx\') or Phoenix_Is_Private_Label_OTC__c = false) LIMIT 30000';
                Map<String,Product2> existingPrdMap = new Map<String,Product2>();
                for(Product2 prd:Database.query(query))                   
                    existingPrdMap.put(prd.ProductCode,prd);
                
                Set<String> UnqFormIds = new Set<String>();
                for(String prdCode : existingPrdMap.keySet()){
                    for(String cntrNum : existingCntrMap.keySet()){                       
                        String unqId = prdCode+'_'+cntrNum;                       
                        UnqFormIds.add(unqId);
                    }
                }
                
                List<String> existingCusPrdTrkRecs = new List<String>();
                for(Vision_Customer_Product_Tracker__c cusRec : [select Vision_Unique_Identifier__c from Vision_Customer_Product_Tracker__c Where Vision_Unique_Identifier__c in : UnqFormIds])                    existingCusPrdTrkRecs.add(cusRec.Vision_Unique_Identifier__c);
                
                for(String unqId : UnqFormIds){
                    if(!existingCusPrdTrkRecs.contains(unqId)){
                        List<String> unqSepList = unqId.split('_');
                        Vision_Customer_Product_Tracker__c cusPrdTrk = new Vision_Customer_Product_Tracker__c();
                        if(existingCntrMap.containsKey(unqSepList[1])){
                            if(unqSepList[1].startsWith('3000')){                               
                                cusPrdTrk.Vision_Contract_Type__c='Indirect';
                            }
                            else if(unqSepList[1].startsWith('1000')){                               
                                cusPrdTrk.Vision_Contract_Type__c='Direct';
                            }
                            cusPrdTrk.Vision_Contract__c = existingCntrMap.get(unqSepList[1]).Id;
                            cusPrdTrk.Vision_Contract_Number__c = unqSepList[1];
                            cusPrdTrk.Vision_Contract_Created_Date__c = existingCntrMap.get(unqSepList[1]).createdDate;
                            cusPrdTrk.Vision_Contract_Name__c = existingCntrMap.get(unqSepList[1]).Name;
                            if(existingCntrMap.get(unqSepList[1]).Phoenix_Customer__c != null){
                                cusPrdTrk.Vision_Account__c = existingCntrMap.get(unqSepList[1]).Phoenix_Customer__c;
                                cusPrdTrk.Vision_Customer_Name__c = existingCntrMap.get(unqSepList[1]).Phoenix_Customer__r.Name;
                                cusPrdTrk.Vision_Customer_Code__c = existingCntrMap.get(unqSepList[1]).Phoenix_Customer__r.AccountNumber;
                            }
                        }
                        system.debug('existingprdmap...>'+existingPrdMap.keyset());
                        system.debug('unqsew'+unqSepList[0]);
                        if(existingPrdMap.containsKey(unqSepList[0])){
                            cusPrdTrk.Vision_Product__c = existingPrdMap.get(unqSepList[0]).Id;
                            cusPrdTrk.Vision_Product_Code__c = unqSepList[0];
                            cusPrdTrk.Vision_Product_Created_Date__c = existingPrdMap.get(unqSepList[0]).createdDate;
                            cusPrdTrk.Vision_Product_Description__c = existingPrdMap.get(unqSepList[0]).Description;
                            cusPrdTrk.Vision_Product_Director__c = existingPrdMap.get(unqSepList[0]).Phoenix_Product_Director__r.Name;
                            cusPrdTrk.Vision_Product_Name__c = existingPrdMap.get(unqSepList[0]).Name;
                            cusPrdTrk.Product_Family__c = existingPrdMap.get(unqSepList[0]).Product_Family__c;
                        }
                        cusPrdTrk.Vision_Contract_Product_Status__c = 'True Opportunity';
                        cusPrdTrk.Vision_Is_True_Opportunity__c = True;
                        cusPrdTrackerRecs.add(cusPrdTrk);
                    }
                }
                insert cusPrdTrackerRecs;
                update contractList;
            }
        }
        Catch(Exception e) {            Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'CustomerProductActiveContractsBatchCls', Phoenix_Error_Message__c = e.getMessage(), Phoenix_Issue_Status__c = 'Pending', Phoenix_Method_Name__c = 'execute', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
            insert exp;
        }
    }
    public void finish(Database.BatchableContext BC) {
     if(!Test.isRunningTest())  
         Database.executeBatch(new CustomerContractOTCPrdCreatorBatchCls(),1);
    }
    
}