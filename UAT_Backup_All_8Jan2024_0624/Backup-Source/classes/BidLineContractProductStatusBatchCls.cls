public class BidLineContractProductStatusBatchCls implements Database.Batchable < sObject > , Database.Stateful,Schedulable,Database.AllowsCallouts {
    public void execute(SchedulableContext sc) {
        //Database.executeBatch(new BidLineContractProductStatusBatchCls());
    }
    public Database.QueryLocator start(Database.BatchableContext BC) {
        //Query - If a New Account has become bid account in last 24 Hours
        //String query = 'Select Phoenix_Product__r.ProductCode, Phoenix_Contract__r.Phoenix_Contract_Number__c, Phoenix_Bid__r.Phoenix_Approval_Status__c,Phoenix_Bid__r.Name,Phoenix_Bid__r.createdDate,' +Phoenix_Util.getsObjectFieds('Phoenix_Bid_Line_Item__c')+' from Phoenix_Bid_Line_Item__c Where Phoenix_Bid__r.Phoenix_Approval_Status__c != \'Draft\' and CreatedDate = LAST_N_DAYS:1';
        String query = 'Select Phoenix_Product__r.ProductCode, Phoenix_Contract__r.Phoenix_Contract_Number__c, Phoenix_Bid__r.Phoenix_Approval_Status__c,Phoenix_Bid__r.Name,Phoenix_Bid__r.createdDate, ' +Phoenix_Util.getsObjectFieds('Phoenix_Bid_Line_Item__c')+' from Phoenix_Bid_Line_Item__c Where Phoenix_Bid__r.Phoenix_Approval_Status__c != \'Draft\'';
        if(Test.isRunningTest())query += ' LIMIT 1';
        return Database.getQueryLocator(query);
        
    }
    public void execute(Database.BatchableContext BC, List <Phoenix_Bid_Line_Item__c> bidLineItemList) {
        try{
            if(bidLineItemList.size() > 0){
                List<Vision_Customer_Product_Tracker__c> existingCusPrdTrkRecs = new List<Vision_Customer_Product_Tracker__c>();
                Map<Id,list<Phoenix_Bid_Line_Item__c>> existingBidRecsMap = new Map<Id,list<Phoenix_Bid_Line_Item__c>>();
                for(Phoenix_Bid_Line_Item__c bidLine:bidLineItemList){
                    if (!existingBidRecsMap.containsKey(bidLine.Phoenix_Bid__c)){
                        existingBidRecsMap.put(bidLine.Phoenix_Bid__c,new list<Phoenix_Bid_Line_Item__c>{bidLine});
                    }
                    else{
                        existingBidRecsMap.get(bidLine.Phoenix_Bid__c).add(bidLine);
                    }
                }
                map<String, Phoenix_Bid__c > UniqueIdsMap = new map<String, Phoenix_Bid__c >();
                map<String, Phoenix_Bid_Line_Item__c> existingBidLineItemRecs = new map<String, Phoenix_Bid_Line_Item__c>();
                for(Phoenix_Bid__c bid: [select Id,Phoenix_Reference_Contracts__c,createdDate,Name,Phoenix_Customer__r.Phoenix_Account_Cooling_Period__c from Phoenix_Bid__c where id in : existingBidRecsMap.keySet()]){
                    if (existingBidRecsMap.containsKey(bid.Id)){
                        for(Phoenix_Bid_Line_Item__c bidLineItem : existingBidRecsMap.get(bid.Id)){
                            if(bid.Phoenix_Reference_Contracts__c != null){
                                List<String> refContractsList = bid.Phoenix_Reference_Contracts__c.split(',');
                                for(String cntrNum : refContractsList){
                                    if(bidLineItem.Phoenix_Product__r.ProductCode != null && String.isNotBlank(cntrNum)){
                                        UniqueIdsMap.put(bidLineItem.Phoenix_Product__r.ProductCode+'_'+cntrNum, bid);
                                        existingBidLineItemRecs.put(bidLineItem.Phoenix_Product__r.ProductCode+'_'+cntrNum, bidLineItem);
                                    }
                                }
                            }
                        }
                    }
                }
                
                for(Vision_Customer_Product_Tracker__c CPT :[select Id,Vision_In_Cooling_Period__c,Vision_Account_Cooling_Period_Days__c,Vision_In_Bid__c,Vision_Contract_Product_Status__c,Vision_Unique_Identifier__c,Bid_Line_Created_Date__c,Bid_Line_Item__c, Vision_Bid__c, Vision_Bid_Created_Date__c , Vision_Bid_Name__c from Vision_Customer_Product_Tracker__c Where Vision_Unique_Identifier__c in : existingBidLineItemRecs.keySet()]){
                    if(existingBidLineItemRecs.containsKey(CPT.Vision_Unique_Identifier__c)){ 
                        CPT.Vision_Contract_Product_Status__c ='In Bid';
                        CPT.Vision_In_Bid__c = true;
                        //CPT.Vision_Temp_Awarded_Value__c = existingBidLineItemRecs.get(CPT.Vision_Unique_Identifier__c).Phoenix_Proposed_ASP_Dose__c;
                        CPT.Bid_Line_Created_Date__c = existingBidLineItemRecs.get(CPT.Vision_Unique_Identifier__c).createdDate;
                        CPT.Bid_Line_Item__c = existingBidLineItemRecs.get(CPT.Vision_Unique_Identifier__c).Id;
                        if(UniqueIdsMap.containsKey(CPT.Vision_Unique_Identifier__c)){
                            CPT.Vision_Bid__c = UniqueIdsMap.get(CPT.Vision_Unique_Identifier__c).Id; 
                            CPT.Vision_Bid_Created_Date__c = UniqueIdsMap.get(CPT.Vision_Unique_Identifier__c).createdDate;
                            CPT.Vision_Bid_Name__c = UniqueIdsMap.get(CPT.Vision_Unique_Identifier__c).Name;
                            Integer diffDateVal = (system.today()).daysBetween(Date.valueOf(UniqueIdsMap.get(CPT.Vision_Unique_Identifier__c).createdDate));
                            if(String.valueOf(diffDateVal).contains('-')){
                                String diffDateValString = String.valueOf(diffDateVal).replace('-','');
                                diffDateVal = Integer.valueOf(diffDateValString);
                            }
                            if(UniqueIdsMap.get(CPT.Vision_Unique_Identifier__c).Phoenix_Customer__c != null && UniqueIdsMap.get(CPT.Vision_Unique_Identifier__c).Phoenix_Customer__r.Phoenix_Account_Cooling_Period__c != null){
                                if(diffDateVal <= UniqueIdsMap.get(CPT.Vision_Unique_Identifier__c).Phoenix_Customer__r.Phoenix_Account_Cooling_Period__c){
                                    CPT.Vision_Account_Cooling_Period_Days__c = UniqueIdsMap.get(CPT.Vision_Unique_Identifier__c).Phoenix_Customer__r.Phoenix_Account_Cooling_Period__c - diffDateVal;
                                    CPT.Vision_In_Cooling_Period__c = true;
                                }
                                else{
                                    CPT.Vision_Account_Cooling_Period_Days__c = diffDateVal - UniqueIdsMap.get(CPT.Vision_Unique_Identifier__c).Phoenix_Customer__r.Phoenix_Account_Cooling_Period__c;
                                    CPT.Vision_In_Cooling_Period__c = false;
                                }
                            }
                        }
                        existingCusPrdTrkRecs.add(CPT);
                    }
                }
                if(existingCusPrdTrkRecs.size() > 0){
                    update existingCusPrdTrkRecs;
                }
            }
            else{
                system.debug('---No Records to Process---');
            }
        }
        Catch(Exception e) {
            Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'BidLineContractProductStatusBatchCls', Phoenix_Error_Message__c = e.getMessage(), Phoenix_Issue_Status__c = 'Pending', Phoenix_Method_Name__c = 'execute', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
            insert exp;
        }
    }
    public void finish(Database.BatchableContext BC) {
        if(!Test.isRunningTest())
        	Database.executeBatch(new BidLineRejectedContractPrdStatusBatchCls(),2000);
    }
    
}