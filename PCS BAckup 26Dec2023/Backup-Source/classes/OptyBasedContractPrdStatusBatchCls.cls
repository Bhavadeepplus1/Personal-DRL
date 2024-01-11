/*
In this Class we will update Customerproducttracker Object fields when we find  Same Contract Number that mathches with contracts  from oppurtunity which is of ProductOppurtunity and Product Code that Mathches with Product Code of ProductOppurtunity,
Vision_Contract_Product_Status__c as 'In Oppurtunity',
Update Customerproducttracker Object fields Vision_Opportunity__c,Vision_Opportunity_Created_Date__c,Vision_Opportunity_Name__c with of same fields from oppurunity's fields 
Update Customerproducttracker Object fields Vision_Product_Opportunity__c,Vision_Product_Opportunity_Created_Date__c,Vision_Product_Opportunity_Name__c,Vision_In_Opportunity__c with of same fields from product oppurtunity
*/

public class OptyBasedContractPrdStatusBatchCls implements Database.Batchable < sObject > , Database.Stateful,Schedulable,Database.AllowsCallouts {
    public void execute(SchedulableContext sc) {
        //Database.executeBatch(new OptyBasedContractPrdStatusBatchCls () );
    }
    public Database.QueryLocator start(Database.BatchableContext BC) {
        //Query - If a New Account has become bid account in last 24 Hours
        //String query = 'Select Product__r.ProductCode,'+Phoenix_Util.getsObjectFieds('Product_Opportunity__c')+' from Product_Opportunity__c where CreatedDate = LAST_N_DAYS:1';
        String query = 'Select Product__r.ProductCode,'+Phoenix_Util.getsObjectFieds('Product_Opportunity__c')+' from Product_Opportunity__c';
        if(Test.isRunningTest())query += ' LIMIT 1';
        return Database.getQueryLocator(query);
    }
    public void execute(Database.BatchableContext BC, List <Product_Opportunity__c> prdOptyList) {
        try{
        	if(prdOptyList.size() > 0){
                Map<Id, list<Product_Opportunity__c>> existingPrds = new Map<Id, list<Product_Opportunity__c>>();
                Map<Id, set<String>> existingContractNumbers = new Map<Id, set<String>>();
                List<Vision_Customer_Product_Tracker__c> cptUpdateList = new List<Vision_Customer_Product_Tracker__c>();
                for(Product_Opportunity__c prdOpty : prdOptyList){
                    if (!existingPrds.containsKey(prdOpty.Opportunity__c)){
                        existingPrds.put(prdOpty.Opportunity__c,new list<Product_Opportunity__c>{prdOpty});
                    }
                    else{
                        existingPrds.get(prdOpty.Opportunity__c).add(prdOpty);
                    }
                }
                map<String, Opportunity> UniqueIdsMap = new map<String, Opportunity>();
                map<String, Product_Opportunity__c> existingPrdOptyRecs = new map<String, Product_Opportunity__c>();
                for(Opportunity opty: [select Id,Vision_Reference_Contract__c,createdDate,Name from opportunity where id in : existingPrds.keySet()]){
                    if (existingPrds.containsKey(opty.Id)){
                        for(Product_Opportunity__c prdOpty : existingPrds.get(opty.Id)){
                            if(opty.Vision_Reference_Contract__c != null){
                                List<String> refContractsList = opty.Vision_Reference_Contract__c.split(',');
                                for(String cntrNum : refContractsList){
                                    if(prdOpty.Product__r.ProductCode != null && String.isNotBlank(cntrNum)){
                                        UniqueIdsMap.put(prdOpty.Product__r.ProductCode+'_'+cntrNum, opty);
                                        existingPrdOptyRecs.put(prdOpty.Product__r.ProductCode+'_'+cntrNum, prdOpty);
                                    }
                                }
                            }
                        }
                    }
                }
                
                for(Vision_Customer_Product_Tracker__c cpt :[SELECT Id,Vision_In_Opportunity__c,Vision_Contract_Product_Status__c,Vision_Unique_Identifier__c, Vision_Opportunity__c, Vision_Product_Opportunity_Created_Date__c , Vision_Product_Opportunity__c,Vision_Opportunity_Created_Date__c,Vision_Opportunity_Name__c,Vision_Product_Opportunity_Name__c from Vision_Customer_Product_Tracker__c Where Vision_Unique_Identifier__c in : existingPrdOptyRecs.keySet()])
                {
                    cpt.Vision_Contract_Product_Status__c = 'In Opportunity';
                    cpt.Vision_Opportunity__c = UniqueIdsMap.containsKey(cpt.Vision_Unique_Identifier__c) ? UniqueIdsMap.get(cpt.Vision_Unique_Identifier__c).Id : cpt.Vision_Opportunity__c;
                    cpt.Vision_Opportunity_Created_Date__c = UniqueIdsMap.containsKey(cpt.Vision_Unique_Identifier__c) ? UniqueIdsMap.get(cpt.Vision_Unique_Identifier__c).createdDate : cpt.Vision_Opportunity_Created_Date__c;
                    cpt.Vision_Opportunity_Name__c = UniqueIdsMap.containsKey(cpt.Vision_Unique_Identifier__c) ? UniqueIdsMap.get(cpt.Vision_Unique_Identifier__c).Name : cpt.Vision_Opportunity_Name__c;
                    cpt.Vision_Product_Opportunity__c = existingPrdOptyRecs.containsKey(cpt.Vision_Unique_Identifier__c) ? existingPrdOptyRecs.get(cpt.Vision_Unique_Identifier__c).Id : cpt.Vision_Product_Opportunity__c;
                    cpt.Vision_Product_Opportunity_Created_Date__c  = existingPrdOptyRecs.containsKey(cpt.Vision_Unique_Identifier__c) ? existingPrdOptyRecs.get(cpt.Vision_Unique_Identifier__c).createdDate : cpt.Vision_Product_Opportunity_Created_Date__c;
                    cpt.Vision_Product_Opportunity_Name__c = existingPrdOptyRecs.containsKey(cpt.Vision_Unique_Identifier__c) ? existingPrdOptyRecs.get(cpt.Vision_Unique_Identifier__c).Name : cpt.Vision_Product_Opportunity_Name__c;
                    cpt.Vision_In_Opportunity__c = true;
                    cptUpdateList.add(cpt);
                }
                if(cptUpdateList.size() > 0){
                    update cptUpdateList;
                } 
        	}
       }
        Catch(Exception e) {
            Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'OptyBasedContractPrdStatusBatchCls', Phoenix_Error_Message__c = e.getMessage(), Phoenix_Issue_Status__c = 'Pending', Phoenix_Method_Name__c = 'execute', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
            insert exp;
        }
    }
    public void finish(Database.BatchableContext bc){
        if(!Test.isRunningTest())  
        	Database.executeBatch(new BidLineContractProductStatusBatchCls(),2000);
    }
}