/*
  We will create Cpt records based on Rx and Srx Products,

All Product Related fields are also created in cpt like Account,Productcode ,Productcreateddate etc from Product
 */
public class CustomerContractProductCreatorBatchCls implements Database.Batchable < sObject > , Database.Stateful,Schedulable,Database.AllowsCallouts {
    public void execute(SchedulableContext sc) {
        Database.executeBatch(new CustomerContractProductCreatorBatchCls(),1);
    }
    public Database.QueryLocator start(Database.BatchableContext BC) {
        //Query Active Bid Products and Find Products for Which This Batch has not Run even Once
        String query = 'Select Phoenix_Product_Director__r.Name,'+Phoenix_Util.getsObjectFieds('Product2')+' from Product2 where IsActive = true AND Phoenix_Is_Exclude_Bid__c = false AND Vision_Is_CPT_Batch_Executed__c = false AND ProductCode != null AND ((Phoenix_Rx_SRx_OTC__c = \'Rx\' or Phoenix_Rx_SRx_OTC__c = \'SRx\') or Phoenix_Is_Private_Label_OTC__c = false)';
        if(Test.isRunningTest())query += ' LIMIT 1';
        return Database.getQueryLocator(query);
    }
    
   public void execute(Database.BatchableContext BC, List <Product2> prdList) {
        try{
            if(prdList.size() > 0){
                list<Vision_Customer_Product_Tracker__c> cusPrdTrackerRecs = new list<Vision_Customer_Product_Tracker__c>();
                list<Phoenix_GCP_Opportunity_Tracker__c> gcpOptyTrackerRecs = new list<Phoenix_GCP_Opportunity_Tracker__c>();
                //Updating Vision_Is_CPT_Batch_Executed__c when batch process the record inorder to exclude this rec in next batch
                Map<String,Product2> existingPrdMap = new Map<String,Product2>();
                Map<String,Id> activePrdFamilyMap = new Map<String,Id>();
                for(Product2 prd:prdList){
                    prd.Vision_Is_CPT_Batch_Executed__c = true;
                    existingPrdMap.put(prd.ProductCode,prd);
                    activePrdFamilyMap.put(prd.Family,prd.Id);
                }
                
                Map<String,Phoenix_Contract__c> existingCntrMap = new Map<String,Phoenix_Contract__c>();
                for(Phoenix_Contract__c cntr : [select Id, createdDate, Name, Phoenix_Customer__c, Phoenix_Contract_Number__c, Phoenix_Customer__r.Name,Phoenix_Customer__r.AccountNumber,Phoenix_Contract_Status__c from Phoenix_Contract__c where Phoenix_Contract_Status__c =: 'Active' AND Phoenix_Contract_Number__c != null]){
                    existingCntrMap.put(cntr.Phoenix_Contract_Number__c,cntr);
                    
                }
                //Generating Unique Identifier
                Set<String> UnqFormIds = new Set<String>();
                for(String prdCode : existingPrdMap.keySet()){
                    for(String cntrNum : existingCntrMap.keySet()){
                        String unqId = prdCode+'_'+cntrNum;
                        UnqFormIds.add(unqId);
                    }
                }
                
                List<String> existingCusPrdTrkRecs = new List<String>();
                for(Vision_Customer_Product_Tracker__c cusRec : [select Vision_Unique_Identifier__c from Vision_Customer_Product_Tracker__c Where Vision_Unique_Identifier__c in : UnqFormIds]){
                    existingCusPrdTrkRecs.add(cusRec.Vision_Unique_Identifier__c);
                    
                }
                //For Active Bid Product - Query "Customer Product Tracker". 
                //If record doesnot exist create Customer Product Tracker.
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
                //For Active Bid Product, fetch product family - Query "Opportunity Tracker". 
                //If there is a new product family we need to insert Opportunity Tracker
                //Set<String> optyTrackerFamily =new Set<String>();
                //for(Phoenix_GCP_Opportunity_Tracker__c optyTrk : [select Phoenix_Product_Family__c From Phoenix_GCP_Opportunity_Tracker__c where Phoenix_Product_Family__c in : activePrdFamilyMap.keySet()])
                //{
                  //  optyTrackerFamily.add(optyTrk.Phoenix_Product_Family__c); 
                //}
                
                //for(String fmyName : activePrdFamilyMap.keySet()){
                  //  if(!optyTrackerFamily.contains(fmyName)){
                   //    Phoenix_GCP_Opportunity_Tracker__c gcpOptyTrk = new Phoenix_GCP_Opportunity_Tracker__c();
                     //   gcpOptyTrk.Vision_Product__c = activePrdFamilyMap.get(fmyName);
                       // gcpOptyTrackerRecs.add(gcpOptyTrk);
                    //}
                //}
                update prdList;
                upsert cusPrdTrackerRecs;
                //insert gcpOptyTrackerRecs;
            }
            
        }
        Catch(Exception e) {
            Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'CustomerContractProductCreatorBatchCls', Phoenix_Error_Message__c = e.getMessage(), Phoenix_Issue_Status__c = 'Pending', Phoenix_Method_Name__c = 'execute', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
            insert exp;
        }
    }
    public void finish(Database.BatchableContext BC) {
        if(!Test.isRunningTest())
            Database.executeBatch(new CustomerProductActiveContractsBatchCls(),1);
    }

}