public class VisionIntDRLSalesProductLevelBatchCls implements Database.Batchable < sObject > , Database.Stateful,Schedulable,Database.AllowsCallouts{
	public void execute(SchedulableContext sc) {
        //Database.executeBatch(new VisionInternalDRLSalesSummaryBatchCls());
    }
    public Database.QueryLocator start(Database.BatchableContext BC) {
        String cust = '0011K00002RDd6lQAD';
        String datee= '21';
        String family = 'Glimepiride Tabs';
          delete[select id from Vision_InternalDRLSales_ProductSummary__c WHERE CreatedDate != Today limit 200];
        // where Vision_Customer_Name__c =:cust AND Vision_Processed_Month__c  like \'%' + datee + '%\' AND Vision_Product_Family__c like \'%'+family+'%\'
        String query = 'Select Vision_Customer_Name__r.Name, '+Phoenix_Util.getsObjectFieds('Vision_DRL_Sales__c')+' from Vision_DRL_Sales__c  ORDER BY Vision_Product_Family__c,Vision_Month_dtls__c ASC NULLS LAST';
        return Database.getQueryLocator(query);
    }
    
      public void execute(Database.BatchableContext BC, List < Vision_DRL_Sales__c > internalSalesList) {
        try{
            System.debug('sales list size-->'+internalSalesList.size());
            Map<String, Map<Integer, Vision_InternalDRLSales_ProductSummary__c>> finalMap = new Map<String, Map<Integer, Vision_InternalDRLSales_ProductSummary__c>>();
            Map<String, Vision_InternalDRLSales_ProductSummary__c> summaryRecordsToInsert = new  Map<String, Vision_InternalDRLSales_ProductSummary__c>();
            set<String> existingUniqueIds = new set<String>();
            for(Vision_DRL_Sales__c internalSalesRecord: internalSalesList){
                String mapKey = internalSalesRecord.Vision_Customer_Name__r.Name+'-'+internalSalesRecord.Vision_Product_Family__c+'-'+internalSalesRecord.Vision_Segment__c+'_'+internalSalesRecord.Vision_Month_dtls__c.year();
                system.debug('Map Key: '+mapKey);
                system.debug(internalSalesRecord.Vision_Month_dtls__c+' ::Sales:: '+internalSalesRecord.Vision_Sales_Dollar__c);
                System.debug('finalMap>>'+finalMap);
                if(finalMap.containsKey(mapKey)){
                    Map<Integer, Vision_InternalDRLSales_ProductSummary__c> oneStepInnerMap = finalMap.get(mapKey);
                    if(oneStepInnerMap.containsKey(internalSalesRecord.Vision_Month_dtls__c.month())){
                        Vision_InternalDRLSales_ProductSummary__c summaryRec = oneStepInnerMap.get(internalSalesRecord.Vision_Month_dtls__c.month());
                        System.debug('family  is-->'+internalSalesRecord.Vision_Product_Family__c);
                        System.debug('segment is-->'+internalSalesRecord.Vision_Segment__c);
                        System.debug('summaryRec>>>'+summaryRec);
                        if(internalSalesRecord.Vision_Segment__c == 'Rx' || internalSalesRecord.Vision_Segment__c == 'RX'){
                            summaryRec.Vision_Is_Rx__c = true;
                        } else if(internalSalesRecord.Vision_Segment__c == 'SRx' || internalSalesRecord.Vision_Segment__c == 'SRX'){
                            summaryRec.Vision_Is_SRx__c = true;
                        } else if(internalSalesRecord.Vision_Segment__c == 'OTC'){
                            summaryRec.Vision_Is_OTC__c =  true;
                        }
                        summaryRec.Vision_Customer__c = internalSalesRecord.Vision_Customer_Name__c;
                        summaryRec.Vision_Processed_Date__c = internalSalesRecord.Vision_Month_dtls__c;
                        if(summaryRec.Vision_Sales__c != null && internalSalesRecord.Vision_Sales_Dollar__c !=null){
                            summaryRec.Vision_Sales__c = summaryRec.Vision_Sales__c+internalSalesRecord.Vision_Sales_Dollar__c;
                        }
                        if(summaryRec.Vision_Units__c != null && internalSalesRecord.Vision_Units__c !=null){
                            summaryRec.Vision_Units__c = summaryRec.Vision_Units__c+internalSalesRecord.Vision_Units__c;
                        }
                        if(summaryRec.Vision_TPT_Dollar__c != null && internalSalesRecord.Vision_TPT_Dollar__c !=null){
                            summaryRec.Vision_TPT_Dollar__c = summaryRec.Vision_TPT_Dollar__c+internalSalesRecord.Vision_TPT_Dollar__c;
                        }
                        if(summaryRec.Vision_TPT_Percent__c != null && internalSalesRecord.Vision_TPT_Pct__c !=null){
                            summaryRec.Vision_TPT_Percent__c = summaryRec.Vision_TPT_Percent__c+internalSalesRecord.Vision_TPT_Pct__c;
                        }
                        summaryRec.Vision_Product_Family__c = internalSalesRecord.Vision_Product_Family__c;
                        summaryRec.Vision_Unique_Identifier__c = mapKey+'_'+internalSalesRecord.Vision_Month_dtls__c.month();
                        //system.debug('Vision_Sales__c -- Inner If: '+summaryRec.Vision_Sales__c);
                    } else{
                        Vision_InternalDRLSales_ProductSummary__c newSummaryRec = new Vision_InternalDRLSales_ProductSummary__c();
                        if(internalSalesRecord.Vision_Segment__c == 'Rx' || internalSalesRecord.Vision_Segment__c == 'RX'){
                            newSummaryRec.Vision_Is_Rx__c = true;
                        } else if(internalSalesRecord.Vision_Segment__c == 'SRx' || internalSalesRecord.Vision_Segment__c == 'SRX'){
                            newSummaryRec.Vision_Is_SRx__c = true;
                        } else if(internalSalesRecord.Vision_Segment__c == 'OTC'){
                            newSummaryRec.Vision_Is_OTC__c =  true;
                        }
                        newSummaryRec.Vision_Customer__c = internalSalesRecord.Vision_Customer_Name__c;
                        newSummaryRec.Vision_Processed_Date__c = internalSalesRecord.Vision_Month_dtls__c;
                        newSummaryRec.Vision_Sales__c = internalSalesRecord.Vision_Sales_Dollar__c;
                        newSummaryRec.Vision_Units__c = internalSalesRecord.Vision_Units__c;
                        newSummaryRec.Vision_TPT_Dollar__c = internalSalesRecord.Vision_TPT_Dollar__c;
                        newSummaryRec.Vision_TPT_Percent__c = internalSalesRecord.Vision_TPT_Pct__c;
                        newSummaryRec.Vision_Product_Family__c = internalSalesRecord.Vision_Product_Family__c;
                        newSummaryRec.Vision_Unique_Identifier__c = mapKey+'_'+internalSalesRecord.Vision_Month_dtls__c.month();
                        oneStepInnerMap.put(internalSalesRecord.Vision_Month_dtls__c.month(), newSummaryRec);
                        //system.debug('Vision_Sales__c -- Inner Else: '+newSummaryRec.Vision_Sales__c);
                    }
                } else{
                    Vision_InternalDRLSales_ProductSummary__c newSummaryRec = new Vision_InternalDRLSales_ProductSummary__c();
                    if(internalSalesRecord.Vision_Segment__c == 'Rx' || internalSalesRecord.Vision_Segment__c == 'RX'){
                            newSummaryRec.Vision_Is_Rx__c = true;
                        } else if(internalSalesRecord.Vision_Segment__c == 'SRx' || internalSalesRecord.Vision_Segment__c == 'SRX'){
                            newSummaryRec.Vision_Is_SRx__c = true;
                        } else if(internalSalesRecord.Vision_Segment__c == 'OTC'){
                            newSummaryRec.Vision_Is_OTC__c =  true;
                        }
                    newSummaryRec.Vision_Customer__c = internalSalesRecord.Vision_Customer_Name__c;
                    newSummaryRec.Vision_Processed_Date__c = internalSalesRecord.Vision_Month_dtls__c;
                    newSummaryRec.Vision_Sales__c = internalSalesRecord.Vision_Sales_Dollar__c;
                    newSummaryRec.Vision_Units__c = internalSalesRecord.Vision_Units__c;
                    newSummaryRec.Vision_TPT_Dollar__c =  internalSalesRecord.Vision_TPT_Dollar__c;
                    newSummaryRec.Vision_TPT_Percent__c = internalSalesRecord.Vision_TPT_Pct__c;
                    newSummaryRec.Vision_Product_Family__c = internalSalesRecord.Vision_Product_Family__c;
                    newSummaryRec.Vision_Unique_Identifier__c = mapKey+'_'+internalSalesRecord.Vision_Month_dtls__c.month();
                    //system.debug('Vision_Sales__c -- Outer Else: '+newSummaryRec.Vision_Sales__c);
                    Map<Integer, Vision_InternalDRLSales_ProductSummary__c> oneStepInnerMap = new Map<Integer, Vision_InternalDRLSales_ProductSummary__c>();
                    oneStepInnerMap.put(internalSalesRecord.Vision_Month_dtls__c.month(), newSummaryRec);
                    finalMap.put(mapKey, oneStepInnerMap);
                    System.debug('newSummaryRec'+newSummaryRec);
                }
                if(finalMap.size() > 0){
                    for(String custKey: finalMap.keySet()){
                        Map<Integer, Vision_InternalDRLSales_ProductSummary__c> custSpecificData = finalMap.get(custKey);
                        //system.debug('Customer Specific Data: '+custSpecificData);
                        for(Integer monthKey: custSpecificData.keySet()){
                            existingUniqueIds.add(custSpecificData.get(monthKey).Vision_Unique_Identifier__c);
                                        System.debug('existingUniqueIds>>'+existingUniqueIds);

                            summaryRecordsToInsert.put(custSpecificData.get(monthKey).Vision_Unique_Identifier__c, custSpecificData.get(monthKey));
                        }
                    }
                }
            }
            for(Vision_InternalDRLSales_ProductSummary__c intDRLSalesRec : [select Id,Vision_Sales__c,Vision_Units__c,Vision_TPT_Dollar__c,Vision_TPT_Percent__c,Vision_Unique_Identifier__c From Vision_InternalDRLSales_ProductSummary__c Where Vision_Unique_Identifier__c in : existingUniqueIds]){
                 System.debug('intDRLSalesRec>>'+intDRLSalesRec.Vision_Unique_Identifier__c);
                System.debug('intDRLSalesRec>>'+intDRLSalesRec.Id);
                System.debug('summaryRecordsToInsert>>'+summaryRecordsToInsert);
                summaryRecordsToInsert.get(intDRLSalesRec.Vision_Unique_Identifier__c).Id = intDRLSalesRec.Id;
                                 System.debug('intDRLSalesRec1>>'+intDRLSalesRec.Vision_Unique_Identifier__c);

               
                if(summaryRecordsToInsert.get(intDRLSalesRec.Vision_Unique_Identifier__c).Vision_Sales__c != null && intDRLSalesRec.Vision_Sales__c != null){
                summaryRecordsToInsert.get(intDRLSalesRec.Vision_Unique_Identifier__c).Vision_Sales__c = summaryRecordsToInsert.get(intDRLSalesRec.Vision_Unique_Identifier__c).Vision_Sales__c + intDRLSalesRec.Vision_Sales__c;
                }
                if(summaryRecordsToInsert.get(intDRLSalesRec.Vision_Unique_Identifier__c).Vision_Units__c != null && intDRLSalesRec.Vision_Units__c !=null){
                summaryRecordsToInsert.get(intDRLSalesRec.Vision_Unique_Identifier__c).Vision_Units__c = summaryRecordsToInsert.get(intDRLSalesRec.Vision_Unique_Identifier__c).Vision_Units__c + intDRLSalesRec.Vision_Units__c;
                }
                if(summaryRecordsToInsert.get(intDRLSalesRec.Vision_Unique_Identifier__c).Vision_TPT_Dollar__c != null && intDRLSalesRec.Vision_TPT_Dollar__c != null){
               	summaryRecordsToInsert.get(intDRLSalesRec.Vision_Unique_Identifier__c).Vision_TPT_Dollar__c = summaryRecordsToInsert.get(intDRLSalesRec.Vision_Unique_Identifier__c).Vision_TPT_Dollar__c + intDRLSalesRec.Vision_TPT_Dollar__c;
           		 }
                //summaryRecordsToInsert.get(intDRLSalesRec.Vision_Unique_Identifier__c).Vision_TPT_Percent__c = summaryRecordsToInsert.get(intDRLSalesRec.Vision_Unique_Identifier__c).Vision_TPT_Percent__c + intDRLSalesRec.Vision_TPT_Percent__c;
            }
            if(summaryRecordsToInsert.size() > 0)
            {
                for(String key : summaryRecordsToInsert.keySet()){
                    system.debug(key+':: Customer Specific Data:: '+summaryRecordsToInsert.get(key));
                }
                upsert summaryRecordsToInsert.values();
            }
            //if(summaryRecordsToInsert.size() > 0)
             //   insert summaryRecordsToInsert.values();
            //insert summaryRecordsToInsert.values();
        }catch(Exception e) {
            Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'VisionIntDRLSalesProductLevelBatchCls', Phoenix_Error_Message__c = e.getMessage(), Phoenix_Issue_Status__c = 'Pending', Phoenix_Method_Name__c = 'execute', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
            insert exp;
        }
    }
    
    public void finish(Database.BatchableContext BC) {}
    
     /*public static void coverageBlock(){
        Integer i=0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
    }*/
}