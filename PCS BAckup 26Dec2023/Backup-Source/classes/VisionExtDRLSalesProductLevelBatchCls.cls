public class VisionExtDRLSalesProductLevelBatchCls implements Database.Batchable < sObject > , Database.Stateful,Schedulable,Database.AllowsCallouts{
	public void execute(SchedulableContext sc) {
        //Database.executeBatch(new VisionInternalDRLSalesSummaryBatchCls());
    }
    public Database.QueryLocator start(Database.BatchableContext BC) {
        String cust = '0011K00002RDd6lQAD';
        String datee= '21';
        String family = 'Glimepiride Tabs';
        delete[select id from External_DRLSales_Product_Summary__c WHERE CreatedDate != Today limit 200];
        // where Vision_Customer_Name__c =:cust AND Vision_Processed_Month__c  like \'%' + datee + '%\' AND Vision_Product_Family__c like \'%'+family+'%\'
        String query = 'Select Vision_Customer__r.Name,Vision_Product__r.Family, '+Phoenix_Util.getsObjectFieds('Vision_DRL_Sales_External_Summary__c')+' from Vision_DRL_Sales_External_Summary__c   ORDER BY Vision_Product__r.Product_Family__r.Name,Vision_Processed_Date__c ASC NULLS LAST';
        return Database.getQueryLocator(query);
    }
    
      public void execute(Database.BatchableContext BC, List < Vision_DRL_Sales_External_Summary__c > internalSalesList) {
        try{
            Map<String, Map<Integer, External_DRLSales_Product_Summary__c>> finalMap = new Map<String, Map<Integer, External_DRLSales_Product_Summary__c>>();
            Map<String, External_DRLSales_Product_Summary__c> summaryRecordsToInsert = new  Map<String, External_DRLSales_Product_Summary__c>();
            set<String> existingUniqueIds = new set<String>();
            for(Vision_DRL_Sales_External_Summary__c internalSalesRecord: internalSalesList){
               
                String mapKey = internalSalesRecord.Vision_Customer_Desc__c+'-'+internalSalesRecord.GCP_Product_Family__c+'-'+internalSalesRecord.Vision_DIVISION_DESC__c+'-'+internalSalesRecord.Vision_Segment__c+'_'+internalSalesRecord.Vision_Processed_Date__c.year();
              if(finalMap.containsKey(mapKey)){
                   Map<Integer, External_DRLSales_Product_Summary__c> oneStepInnerMap = finalMap.get(mapKey);
                    if(oneStepInnerMap.containsKey(internalSalesRecord.Vision_Processed_Date__c.month())){
                        External_DRLSales_Product_Summary__c summaryRec = oneStepInnerMap.get(internalSalesRecord.Vision_Processed_Date__c.month());
                        if(internalSalesRecord.Vision_Segment__c == 'Rx' || internalSalesRecord.Vision_Segment__c == 'RX'){
                            summaryRec.Vision_Is_Rx__c = true;
                        } else if(internalSalesRecord.Vision_Segment__c == 'SRx' || internalSalesRecord.Vision_Segment__c == 'SRX'){
                            summaryRec.Vision_Is_SRx__c = true;
                        } else if(internalSalesRecord.Vision_Segment__c == 'OTC'){
                            summaryRec.Vision_Is_OTC__c =  true;
                        }
            
                        summaryRec.Vision_Customer__c = internalSalesRecord.Vision_Customer__c;
                        summaryRec.Vision_Processed_Date__c = internalSalesRecord.Vision_Processed_Date__c;
                        if(summaryRec.Vision_Sales__c != null && internalSalesRecord.Vision_net_sales__c !=null){
                            summaryRec.Vision_Sales__c = summaryRec.Vision_Sales__c+internalSalesRecord.Vision_net_sales__c;
                        }
                        if(summaryRec.Vision_Units__c != null && internalSalesRecord.Vision_Units__c !=null){
                            summaryRec.Vision_Units__c = summaryRec.Vision_Units__c+internalSalesRecord.Vision_Units__c;
                        }
                        summaryRec.Vision_Product_Family__c = internalSalesRecord.Vision_Product__r.Product_Family__r.Name;
                        summaryRec.Vision_Cutomer_Hierarchy_Code__c = internalSalesRecord.Vision_Cutomer_Hierarchy_Code__c;
                        summaryRec.Vision_Customer_Hierarchy__c = internalSalesRecord.Vision_Customer_Hierarchy__c;
                        summaryRec.Vision_Customer_Desc__c = internalSalesRecord.Vision_Customer_Desc__c;
                        summaryRec.Vision_Category__c = internalSalesRecord.Vision_Category__c;	
                        summaryRec.Vision_PFamily__c = internalSalesRecord.GCP_Product_Family__c;
                        summaryRec.Vision_DIVISION_DESC__c=internalSalesRecord.Vision_DIVISION_DESC__c;
                        summaryRec.Vision_Unique_Identifier__c = mapKey+'_'+internalSalesRecord.Vision_Processed_Date__c.month();
                       } else{
                        External_DRLSales_Product_Summary__c newSummaryRec = new External_DRLSales_Product_Summary__c();
                        if(internalSalesRecord.Vision_Segment__c == 'Rx' || internalSalesRecord.Vision_Segment__c == 'RX'){
                            newSummaryRec.Vision_Is_Rx__c = true;
                        } else if(internalSalesRecord.Vision_Segment__c == 'SRx' || internalSalesRecord.Vision_Segment__c == 'SRX'){
                            newSummaryRec.Vision_Is_SRx__c = true;
                        } else if(internalSalesRecord.Vision_Segment__c == 'OTC'){
                            newSummaryRec.Vision_Is_OTC__c =  true;
                        }
                        newSummaryRec.Vision_Customer__c = internalSalesRecord.Vision_Customer__c;
                        newSummaryRec.Vision_Processed_Date__c = internalSalesRecord.Vision_Processed_Date__c;
                        newSummaryRec.Vision_Sales__c = internalSalesRecord.Vision_net_sales__c;
                        newSummaryRec.Vision_Units__c = internalSalesRecord.Vision_Units__c;
                        newSummaryRec.Vision_Product_Family__c = internalSalesRecord.Vision_Product__r.Product_Family__r.Name;
                        newSummaryRec.Vision_Cutomer_Hierarchy_Code__c = internalSalesRecord.Vision_Cutomer_Hierarchy_Code__c;
                        newSummaryRec.Vision_Customer_Hierarchy__c = internalSalesRecord.Vision_Customer_Hierarchy__c;
                        newSummaryRec.Vision_Customer_Desc__c = internalSalesRecord.Vision_Customer_Desc__c;
                        newSummaryRec.Vision_Category__c = internalSalesRecord.Vision_Category__c;
                        newSummaryRec.Vision_PFamily__c = internalSalesRecord.GCP_Product_Family__c;
                         newsummaryRec.Vision_DIVISION_DESC__c=internalSalesRecord.Vision_DIVISION_DESC__c;
                        
                        newSummaryRec.Vision_Unique_Identifier__c = mapKey+'_'+internalSalesRecord.Vision_Processed_Date__c.month();
                        oneStepInnerMap.put(internalSalesRecord.Vision_Processed_Date__c.month(), newSummaryRec);
                     }
                } else{
                    External_DRLSales_Product_Summary__c newSummaryRec = new External_DRLSales_Product_Summary__c();
                    if(internalSalesRecord.Vision_Segment__c == 'Rx' || internalSalesRecord.Vision_Segment__c == 'RX'){
                            newSummaryRec.Vision_Is_Rx__c = true;
                        } else if(internalSalesRecord.Vision_Segment__c == 'SRx' || internalSalesRecord.Vision_Segment__c == 'SRX'){
                            newSummaryRec.Vision_Is_SRx__c = true;
                        } else if(internalSalesRecord.Vision_Segment__c == 'OTC'){
                            newSummaryRec.Vision_Is_OTC__c =  true;
                        }
                    newSummaryRec.Vision_Customer__c = internalSalesRecord.Vision_Customer__c;
                    newSummaryRec.Vision_Processed_Date__c = internalSalesRecord.Vision_Processed_Date__c;
                    newSummaryRec.Vision_Sales__c = internalSalesRecord.Vision_net_sales__c;
                    newSummaryRec.Vision_Units__c = internalSalesRecord.Vision_Units__c;
                    newSummaryRec.Vision_Product_Family__c = internalSalesRecord.Vision_Product__r.Product_Family__r.Name;
                    newSummaryRec.Vision_Cutomer_Hierarchy_Code__c = internalSalesRecord.Vision_Cutomer_Hierarchy_Code__c;
                    newSummaryRec.Vision_Customer_Hierarchy__c = internalSalesRecord.Vision_Customer_Hierarchy__c;
                    newSummaryRec.Vision_Customer_Desc__c = internalSalesRecord.Vision_Customer_Desc__c;
                    newSummaryRec.Vision_Category__c = internalSalesRecord.Vision_Category__c;
                    newSummaryRec.Vision_PFamily__c = internalSalesRecord.GCP_Product_Family__c;
                    newsummaryRec.Vision_DIVISION_DESC__c=internalSalesRecord.Vision_DIVISION_DESC__c;
                    newSummaryRec.Vision_Unique_Identifier__c = mapKey+'_'+internalSalesRecord.Vision_Processed_Date__c.month();
                    Map<Integer, External_DRLSales_Product_Summary__c> oneStepInnerMap = new Map<Integer, External_DRLSales_Product_Summary__c>();
                    oneStepInnerMap.put(internalSalesRecord.Vision_Processed_Date__c.month(), newSummaryRec);
                    finalMap.put(mapKey, oneStepInnerMap);
                }
                if(finalMap.size() > 0){
                    for(String custKey: finalMap.keySet()){
                        Map<Integer, External_DRLSales_Product_Summary__c> custSpecificData = finalMap.get(custKey);
                        for(Integer monthKey: custSpecificData.keySet()){
                            existingUniqueIds.add(custSpecificData.get(monthKey).Vision_Unique_Identifier__c);
                            summaryRecordsToInsert.put(custSpecificData.get(monthKey).Vision_Unique_Identifier__c, custSpecificData.get(monthKey));
                        }
                    }
                }
            }
             for(External_DRLSales_Product_Summary__c intDRLSalesRec : [select Id,Vision_Sales__c,Vision_Units__c,Vision_Unique_Identifier__c From External_DRLSales_Product_Summary__c Where Vision_Unique_Identifier__c in : existingUniqueIds]){
                if(intDRLSalesRec.Vision_Unique_Identifier__c!=null && summaryRecordsToInsert.containsKey(intDRLSalesRec.Vision_Unique_Identifier__c)){
                   if(intDRLSalesRec.Id != null){
                    summaryRecordsToInsert.get(intDRLSalesRec.Vision_Unique_Identifier__c).Id = intDRLSalesRec.Id;
                   }
                if(summaryRecordsToInsert.get(intDRLSalesRec.Vision_Unique_Identifier__c).Vision_Sales__c != null && intDRLSalesRec.Vision_Sales__c != null){
                summaryRecordsToInsert.get(intDRLSalesRec.Vision_Unique_Identifier__c).Vision_Sales__c = summaryRecordsToInsert.get(intDRLSalesRec.Vision_Unique_Identifier__c).Vision_Sales__c + intDRLSalesRec.Vision_Sales__c;
                }
                if(summaryRecordsToInsert.get(intDRLSalesRec.Vision_Unique_Identifier__c).Vision_Units__c != null && intDRLSalesRec.Vision_Units__c !=null){
                summaryRecordsToInsert.get(intDRLSalesRec.Vision_Unique_Identifier__c).Vision_Units__c = summaryRecordsToInsert.get(intDRLSalesRec.Vision_Unique_Identifier__c).Vision_Units__c + intDRLSalesRec.Vision_Units__c;
                }
                //summaryRecordsToInsert.get(intDRLSalesRec.Vision_Unique_Identifier__c).Vision_TPT_Percent__c = summaryRecordsToInsert.get(intDRLSalesRec.Vision_Unique_Identifier__c).Vision_TPT_Percent__c + intDRLSalesRec.Vision_TPT_Percent__c;
            }
            }
            if(summaryRecordsToInsert.size() > 0)
            {
                for(String key : summaryRecordsToInsert.keySet()){
                }
                upsert summaryRecordsToInsert.values();
            }
            //if(summaryRecordsToInsert.size() > 0)
             //   insert summaryRecordsToInsert.values();
            //insert summaryRecordsToInsert.values();
        }catch(Exception e) {
            Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'VisionExtDRLSalesProductLevelBatchCls', Phoenix_Error_Message__c = e.getMessage(), Phoenix_Issue_Status__c = 'Pending', Phoenix_Method_Name__c = 'execute', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
            insert exp;
        }
    }
    
    public void finish(Database.BatchableContext BC) {}
    
    
}