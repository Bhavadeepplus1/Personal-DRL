/*
 We will create Cpt records based on OTC Products,
Vision_Contract_Number__c from Relatedlist of contracts from Customer related to that Product
All Product Related fields are also created in cpt like Account,Productcode ,Productcreateddate etc from Product
 */
public class CustomerContractOTCPrdCreatorBatchCls implements Database.Batchable < sObject > , Database.Stateful,Schedulable,Database.AllowsCallouts {
    public void execute(SchedulableContext sc) {
        //Database.executeBatch(new CustomerContractProductCreatorBatchCls());
    }
    public Database.QueryLocator start(Database.BatchableContext BC) {
        //Query Active Bid Products and Find Products for Which This Batch has not Run even Once
        String query = 'Select Phoenix_Product_Director__r.Name,OTC_Customer__r.Name,OTC_Customer__r.AccountNumber,'+Phoenix_Util.getsObjectFieds('Product2')+' from Product2 where IsActive = true AND Phoenix_Is_Exclude_Bid__c = false AND Vision_Is_CPT_Batch_Executed__c = false AND Phoenix_Is_Private_Label_OTC__c = true';
        if(Test.isRunningTest())query += ' LIMIT 1';
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext BC, List <Product2> prdList) {
       // system.debug(prdlist);
        try{
            if(prdList.size() > 0){
                list<Vision_Customer_Product_Tracker__c> cusPrdTrackerRecs = new list<Vision_Customer_Product_Tracker__c>();
                list<Phoenix_GCP_Opportunity_Tracker__c> gcpOptyTrackerRecs = new list<Phoenix_GCP_Opportunity_Tracker__c>();
                map<id,list<Phoenix_Contract__c>> contrmap= new map<id,list<Phoenix_Contract__c>>();
                set<string> cusset=new set<string>();
                for(Product2 prd:prdList){
                    cusset.add(prd.OTC_Customer__r.AccountNumber);
            }
                
                for(Phoenix_Contract__c contr:[select id,Phoenix_Customer__c,Phoenix_Contract_Number__c from Phoenix_Contract__c where Phoenix_Contract_Status__c =:'Active' and Phoenix_Customer__r.Accountnumber in:cusset]){
                    if(contrMap.containskey(contr.Phoenix_Customer__c)){
                        contrMap.get(contr.Phoenix_Customer__c).add(contr);
                    }
                    else{
                        contrMap.put(contr.Phoenix_Customer__c, new list<Phoenix_Contract__c>{contr});
                    }
                    
                }
                   
                
                
               
                //Updating Vision_Is_CPT_Batch_Executed__c when batch process the record inorder to exclude this rec in next batch
                Map<String,Product2> existingPrdMap = new Map<String,Product2>();
                Map<String,Id> activePrdFamilyMap = new Map<String,Id>();
                map<string,Phoenix_Contract__c> contrmap2 =  new  map<string,Phoenix_Contract__c>();
                for(Product2 prd:prdList){
                    
                    if(prd.ProductCode != null && prd.OTC_Customer__c != null && contrmap.containskey(prd.OTC_Customer__c) ){
                        if(contrmap.get(prd.OTC_Customer__c).size()>0){
                            for(integer i=0;i<contrmap.get(prd.OTC_Customer__c).size();i++){
                                 String unqId = prd.ProductCode+'_'+contrmap.get(prd.OTC_Customer__c)[i].Phoenix_Contract_Number__c;
                                existingPrdMap.put(unqId,prd);
                                 contrmap2.put(unqId,contrmap.get(prd.OTC_Customer__c)[i]);
                                 prd.Vision_Is_CPT_Batch_Executed__c = true;

                                
                            }
                        }  
                      
                        
                                           }
                    
                    activePrdFamilyMap.put(prd.Family,prd.Id);
                }
                //existing Contracts Map
                Map<String,Phoenix_Contract__c> existingCntrMap = new Map<String,Phoenix_Contract__c>();
                for(Phoenix_Contract__c cntr : [select Id, createdDate, Name, Phoenix_Customer__c, Phoenix_Contract_Number__c, Phoenix_Customer__r.Name,Phoenix_Contract_Status__c from Phoenix_Contract__c where Phoenix_Contract_Status__c =: 'Active']){
                    existingCntrMap.put(cntr.Phoenix_Contract_Number__c,cntr);
                }
                //For Active Bid Product - Query "Customer Product Tracker". 
                //If record doesnot exist create Customer Product Tracker.
               // system.debug('existing prd map...'+existingPrdMap.size());
                List<String> existingCusPrdTrkRecs = new List<String>();
                Set<String> UniqueIds = new Set<String>();
                for(Vision_Customer_Product_Tracker__c cusRec : [select Vision_Unique_Identifier__c from Vision_Customer_Product_Tracker__c Where Vision_Unique_Identifier__c in : existingPrdMap.keySet()]){
                    UniqueIds.add(cusRec.Vision_Unique_Identifier__c);
                }
               
                
                for(String key : existingPrdMap.keySet()){  
                    if(!UniqueIds.contains(key)){
                        Vision_Customer_Product_Tracker__c cusPrdTrk = new Vision_Customer_Product_Tracker__c();
                        //contract details
                        cusPrdTrk.Vision_Contract_Number__c =contrmap2.get(key).Phoenix_Contract_Number__c;
                        if(existingCntrMap.containsKey(contrmap2.get(key).Phoenix_Contract_Number__c)){
                            cusPrdTrk.Vision_Contract__c = existingCntrMap.get(contrmap2.get(key).Phoenix_Contract_Number__c).Id;
                            cusPrdTrk.Vision_Contract_Created_Date__c = existingCntrMap.get(contrmap2.get(key).Phoenix_Contract_Number__c).createdDate;
                            cusPrdTrk.Vision_Contract_Name__c = existingCntrMap.get(contrmap2.get(key).Phoenix_Contract_Number__c).Name;
                            
                        }
                        // product details
                        if(cusPrdTrk.Vision_Contract_Number__c.startsWith('3000')){
                            cusPrdTrk.Vision_Contract_Type__c='Indirect';
                        }
                        else if(cusPrdTrk.Vision_Contract_Number__c.startsWith('1000')){
                            cusPrdTrk.Vision_Contract_Type__c='Direct';
                        }
                        
                        cusPrdTrk.Vision_Product__c = existingPrdMap.get(key).Id;
                        cusPrdTrk.Vision_Product_Code__c = existingPrdMap.get(key).ProductCode;
                        cusPrdTrk.Vision_Product_Created_Date__c = existingPrdMap.get(key).createdDate;
                        cusPrdTrk.Vision_Product_Description__c = existingPrdMap.get(key).Description;
                        cusPrdTrk.Vision_Product_Director__c = existingPrdMap.get(key).Phoenix_Product_Director__r.Name;
                        cusPrdTrk.Vision_Product_Name__c = existingPrdMap.get(key).Name;
                        cusPrdTrk.Product_Family__c = existingPrdMap.get(key).Product_Family__c;
                        cusPrdTrk.Vision_Account__c = existingPrdMap.get(key).OTC_Customer__c;
                        cusPrdTrk.Vision_Customer_Name__c = existingPrdMap.get(key).OTC_Customer__r.Name;
                        cusPrdTrk.Vision_Customer_Code__c = existingPrdMap.get(key).OTC_Customer__r.AccountNumber;
                        cusPrdTrk.Vision_Contract_Product_Status__c = 'True Opportunity';
                        cusPrdTrk.Vision_Is_True_Opportunity__c = True;
                        cusPrdTrackerRecs.add(cusPrdTrk);
                    }
                }
                //For Active Bid Product, fetch product family - Query "Opportunity Tracker". 
                //If there is a new product family we need to insert Opportunity Tracker
                /*Set<String> optyTrackerFamily =new Set<String>();
                for(Phoenix_GCP_Opportunity_Tracker__c optyTrk : [select Phoenix_Product_Family__c From Phoenix_GCP_Opportunity_Tracker__c where Phoenix_Product_Family__c in : activePrdFamilyMap.keySet()])
                {
                    optyTrackerFamily.add(optyTrk.Phoenix_Product_Family__c); 
                }
                
                for(String fmyName : activePrdFamilyMap.keySet()){
                    if(!optyTrackerFamily.contains(fmyName)){
                        Phoenix_GCP_Opportunity_Tracker__c gcpOptyTrk = new Phoenix_GCP_Opportunity_Tracker__c();
                        gcpOptyTrk.Vision_Product__c = activePrdFamilyMap.get(fmyName);
                        gcpOptyTrackerRecs.add(gcpOptyTrk);
                    }
                }*/
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
            Database.executeBatch(new OptyBasedContractPrdStatusBatchCls(),2000);
    
}

}