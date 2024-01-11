public class bidlineitemstatus implements Database.Batchable < sObject > , Database.Stateful,Schedulable,Database.AllowsCallouts{
    public void execute(SchedulableContext sc) {
        //Database.executeBatch(new BidLineRejectedContractPrdStatusBatchCls());
    }
    
    
    
    public Database.QueryLocator start(Database.BatchableContext BC) {
        list<Phoenix_Bid_Line_Item__c> items=new list<Phoenix_Bid_Line_Item__c>();
        //Query - If a New Account has become bid account in last 24 Hours
        //String query = 'Select Phoenix_Product__r.ProductCode, Phoenix_Contract__r.Phoenix_Contract_Number__c,Phoenix_Bid__r.createdDate,Phoenix_Bid__r.Name,Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_Account_Cooling_Period__c, ' +Phoenix_Util.getsObjectFieds('Phoenix_Bid_Line_Item__c')+'from Phoenix_Bid_Line_Item__c where Phoenix_Final_Status__c = \'Not Approved\' and CreatedDate = LAST_N_DAYS:1';
        String query = 'Select Phoenix_Product__r.ProductCode, Phoenix_Contract__r.Phoenix_Contract_Number__c,Phoenix_Bid__r.createdDate,Phoenix_Bid__r.Name,Phoenix_Bid_Status__c,Phoenix_Bid__r.Phoenix_Customer__r.Phoenix_Account_Cooling_Period__c,Phoenix_Bid__r.Phoenix_Bid_Type__c,Phoenix_Bid__r.Phoenix_Status__c from Phoenix_Bid_Line_Item__c where  Phoenix_Bid__r.Phoenix_Approval_Status__c=\'Closed\' or Phoenix_Bid__r.Phoenix_Approval_Status__c= \'Customer Rejected\' or Phoenix_Bid__r.Phoenix_Approval_Status__c = \'Vistex Update\' order by createddate DESC';
        if(Test.isRunningTest())query += ' LIMIT 1';
        return Database.getQueryLocator(query);
    }
    
    
    
    
    
    
    public void execute(Database.BatchableContext BC, List <Phoenix_Bid_Line_Item__c> bidLineItemList) {
        system.debug('bidlineitem...'+bidLineItemList);
        if(bidLineItemList.size()>0){
            try{
                // string unique;
                List<Vision_Customer_Product_Tracker__c> existingCusPrdTrkRecs = new List<Vision_Customer_Product_Tracker__c>();
                map<string,Phoenix_Bid_Line_Item__c> bidlineitemmap= new  map<string,Phoenix_Bid_Line_Item__c>();
                Map<Id,list<Phoenix_Bid_Line_Item__c>> existingBidRecsMap = new Map<Id,list<Phoenix_Bid_Line_Item__c>>();
                for(Phoenix_Bid_Line_Item__c bidLine:bidLineItemList){
                    if (!existingBidRecsMap.containsKey(bidLine.Phoenix_Bid__c)){
                        existingBidRecsMap.put(bidLine.Phoenix_Bid__c,new list<Phoenix_Bid_Line_Item__c>{bidLine});
                    }
                    else{
                        existingBidRecsMap.get(bidLine.Phoenix_Bid__c).add(bidLine);
                    }
                }
                for(Phoenix_Bid_Line_Item__c bidlineitm:bidLineItemList){
                    // unique=bidlineitm.Phoenix_Product__r.ProductCode+'_'+bidlineitm.Phoenix_Contract__r.Phoenix_Contract_Number__c;
                    bidlineitemmap.put(bidlineitm.Phoenix_Product__r.ProductCode+'_'+bidlineitm.Phoenix_Contract__r.Phoenix_Contract_Number__c,bidlineitm) ;
                }
                for(Phoenix_Bid__c bid: [select Id,Phoenix_Reference_Contracts__c,Phoenix_Bid_Type__c,createdDate,Name,Phoenix_Customer__r.Phoenix_Account_Cooling_Period__c from Phoenix_Bid__c where id in : existingBidRecsMap.keySet()]){
                    if (existingBidRecsMap.containsKey(bid.Id)){
                        for(Phoenix_Bid_Line_Item__c bidLineItem : existingBidRecsMap.get(bid.Id)){
                            if(bid.Phoenix_Reference_Contracts__c != null){
                                List<String> refContractsList = bid.Phoenix_Reference_Contracts__c.split(',');
                                for(String cntrNum : refContractsList){
                                    if(bidLineItem.Phoenix_Product__r.ProductCode != null && String.isNotBlank(cntrNum)){
                                        // UniqueIdsMap.put(bidLineItem.Phoenix_Product__r.ProductCode+'_'+cntrNum, bid);
                                        bidlineitemmap.put(bidLineItem.Phoenix_Product__r.ProductCode+'_'+cntrNum, bidLineItem);
                                    }
                                }
                            }
                        }
                    }
                }
               // system.debug('bidlinemap..'+bidlineitemmap.keyset());
                
                list<Vision_Customer_Product_Tracker__c> cptlist=[select id, Vision_Unique_Identifier__c,category__c from Vision_Customer_Product_Tracker__c where Vision_Unique_Identifier__c in:bidlineitemmap.keyset()];
              //  system.debug('cptlist/...'+cptlist);
                for(Vision_Customer_Product_Tracker__c cpt:cptlist){
                    if(bidlineitemmap.containskey(cpt.Vision_Unique_Identifier__c)){
                        //system.debug('true');
                       // system.debug(bidlineitemmap.get(cpt.Vision_Unique_Identifier__c).Phoenix_Bid__r.Phoenix_Bid_Type__c);
                        if(bidlineitemmap.get(cpt.Vision_Unique_Identifier__c).Phoenix_Bid__r.Phoenix_Bid_Type__c=='Product Discontinuation Process'){
                          //  system.debug('true 40');
                            cpt.category__c='Product DisContinued';
                        }
                        else if(bidlineitemmap.get(cpt.Vision_Unique_Identifier__c).Phoenix_Bid__r.Phoenix_Bid_Type__c=='Mass Product Removals'){
                            //system.debug('true 45');
                            cpt.category__c='Product Removed'; 
                        }
                        else{
                           // system.debug('true,,,');
                           // system.debug(bidlineitemmap.get(cpt.Vision_Unique_Identifier__c));
                            
                            cpt.category__c=bidlineitemmap.get(cpt.Vision_Unique_Identifier__c).Phoenix_Bid_Status__c;  
                        }
                        
                        
                    }
                    existingCusPrdTrkRecs.add(cpt);
                    
                }
                if(existingCusPrdTrkRecs.size() > 0){
                    update existingCusPrdTrkRecs;
                }
                
            }
            catch(exception e){
                Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'bidlineitemstatus', Phoenix_Error_Message__c = e.getMessage(), Phoenix_Issue_Status__c = 'Pending', Phoenix_Method_Name__c = 'execute', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
                insert exp; 
            }
        }
    }
    public void finish(Database.BatchableContext BC) {
        
    }
    
}