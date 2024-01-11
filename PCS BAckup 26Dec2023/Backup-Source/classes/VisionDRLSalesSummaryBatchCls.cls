public class VisionDRLSalesSummaryBatchCls implements Database.Batchable < sObject > , Database.Stateful,Schedulable,Database.AllowsCallouts {
    
    public void execute(SchedulableContext sc) {
        //Database.executeBatch(new VisionDRLSalesSummaryBatchCls());
    }
    
    public Database.QueryLocator start(Database.BatchableContext BC) {
        delete[select id from Vision_DRL_Sales_Summary__c WHERE CreatedDate != Today limit 200];
       String code = '0011K00002RDd8IQAT';
        String query = 'Select Vision_Customer__r.Name, '+Phoenix_Util.getsObjectFieds('Vision_DRL_Sales_External_Summary__c')+' from Vision_DRL_Sales_External_Summary__c where Vision_Customer__c = :code ORDER BY Vision_Customer_Desc__c,Vision_Processed_Date__c  NULLS LAST';
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext BC, List < Vision_DRL_Sales_External_Summary__c > externalSalesList) {
        try{
            Map<String, Map<Integer, Vision_DRL_Sales_Summary__c>> finalMap = new Map<String, Map<Integer, Vision_DRL_Sales_Summary__c>>();
            Map<String, Vision_DRL_Sales_Summary__c> summaryRecordsToInsert = new  Map<String, Vision_DRL_Sales_Summary__c>();
             set<String> existingUniqueIds = new set<String>();
            for(Vision_DRL_Sales_External_Summary__c externalSalesRecord: externalSalesList){
                String mapKey = externalSalesRecord.Vision_Cutomer_Hierarchy_Code__c+'-'+externalSalesRecord.Vision_Customer_Desc__c+'-'+externalSalesRecord.Vision_DIVISION_DESC__c+'-'+externalSalesRecord.Vision_Segment__c+'_'+externalSalesRecord.Vision_Processed_Date__c.year();
               
               /* if(Test.isRunningTest()){
                    Vision_DRL_Sales_Summary__c intsales2= new Vision_DRL_Sales_Summary__c();
                    //intsales2.Vision_Customer__c = 'test';
                    intsales2.Vision_Sales__c =165.45;
                    intsales2.Vision_Units__c = 500;
                    intsales2.Vision_Is_OTC__c  = true;
                    //intsales2.Vision_TPT_Dollar__c = 234;
                    intsales2.Vision_Processed_Date__c = system.today()-200;
                    intsales2.Vision_Product_Family__c='Diclofenac Gel';
                    intsales2.Vision_Unique_Identifier__c = intsales2.Id;
            
                    insert intsales2;
                     Map<Integer, Vision_DRL_Sales_Summary__c> oneStepInnerMap1 = new Map<Integer, Vision_DRL_Sales_Summary__c>(); 
                    oneStepInnerMap1.put(1, intsales2);
                    finalMap.put('Test Account-Rx_2021', oneStepInnerMap1);        
                }*/
                
                if(finalMap.containsKey(mapKey)){
					Map<Integer, Vision_DRL_Sales_Summary__c> oneStepInnerMap = finalMap.get(mapKey);
                    if(oneStepInnerMap.containsKey(externalSalesRecord.Vision_Processed_Date__c.month())){
                        Vision_DRL_Sales_Summary__c summaryRec = oneStepInnerMap.get(externalSalesRecord.Vision_Processed_Date__c.month());
                        if(externalSalesRecord.Vision_Segment__c == 'Rx'){
                            summaryRec.Vision_Is_Rx__c = true;
                         } else if(externalSalesRecord.Vision_Segment__c == 'SRx'){
                            summaryRec.Vision_Is_SRx__c = true;
                        } else if(externalSalesRecord.Vision_Segment__c == 'OTC'){
                            summaryRec.Vision_Is_OTC__c =  true;
                        }
                        summaryRec.Vision_Customer__c = externalSalesRecord.Vision_Customer__c;
                        summaryRec.Vision_Processed_Date__c = externalSalesRecord.Vision_Processed_Date__c;
                        summaryRec.Vision_Sales__c = summaryRec.Vision_Sales__c+externalSalesRecord.Vision_net_sales__c;
                        summaryRec.Vision_Units__c = summaryRec.Vision_Units__c+externalSalesRecord.Vision_Units__c;
                        summaryRec.Direct_Sales__c = summaryRec.Direct_Sales__c+externalSalesRecord.Vision_sales_direct__c;
                        summaryRec.Direct_Units__c = summaryRec.Direct_Units__c+externalSalesRecord.Vision_direct_qty__c;
                        summaryRec.Indirect_Sales__c = summaryRec.Indirect_Sales__c+externalSalesRecord.Vision_sales_indirect__c;
                        summaryRec.Indirect_Units__c = summaryRec.Indirect_Units__c+externalSalesRecord.Vision_indirect_qty__c;
                        summaryRec.Vision_Product_Family__c = externalSalesRecord.Vision_Product_Family__c;
                        summaryRec.Vision_Cutomer_Hierarchy_Code__c = externalSalesRecord.Vision_Cutomer_Hierarchy_Code__c;
                        summaryRec.Vision_Customer_Hierarchy__c = externalSalesRecord.Vision_Customer_Hierarchy__c;
                        summaryRec.Vision_Customer_Desc__c = externalSalesRecord.Vision_Customer_Desc__c;
                        summaryRec.Vision_customer_code__c = externalSalesRecord.Vision_customer_code__c;
                        summaryRec.Vision_Category__c = externalSalesRecord.Vision_Category__c;
                        summaryRec.Vision_DIVISION_DESC__c=externalSalesRecord.Vision_DIVISION_DESC__c;
                        summaryRec.Vision_Unique_Identifier__c = mapKey+'_'+externalSalesRecord.Vision_Processed_Date__c.month();
                     } 
                    else{
                        Vision_DRL_Sales_Summary__c newSummaryRec = new Vision_DRL_Sales_Summary__c();
                        if(externalSalesRecord.Vision_Segment__c == 'Rx' || externalSalesRecord.Vision_Segment__c == 'RX'){
                            newSummaryRec.Vision_Is_Rx__c = true;
                        } else if(externalSalesRecord.Vision_Segment__c == 'SRx' || externalSalesRecord.Vision_Segment__c == 'SRX'){
                            newSummaryRec.Vision_Is_SRx__c = true;
                        } else if(externalSalesRecord.Vision_Segment__c == 'OTC'){
                            newSummaryRec.Vision_Is_OTC__c =  true;
                        }
                        newSummaryRec.Vision_Customer__c = externalSalesRecord.Vision_Customer__c;
                        newSummaryRec.Vision_Processed_Date__c = externalSalesRecord.Vision_Processed_Date__c;
                        newSummaryRec.Vision_Sales__c = externalSalesRecord.Vision_net_sales__c;
                        newSummaryRec.Vision_Units__c = externalSalesRecord.Vision_Units__c;
                        newSummaryRec.Direct_Sales__c = externalSalesRecord.Vision_sales_direct__c;
                        newSummaryRec.Direct_Units__c = externalSalesRecord.Vision_direct_qty__c;
                        newSummaryRec.Indirect_Sales__c = externalSalesRecord.Vision_sales_indirect__c;
                        newSummaryRec.Indirect_Units__c = externalSalesRecord.Vision_indirect_qty__c;
                        newSummaryRec.Vision_Product_Family__c = externalSalesRecord.Vision_Product_Family__c;
                        newSummaryRec.Vision_Cutomer_Hierarchy_Code__c = externalSalesRecord.Vision_Cutomer_Hierarchy_Code__c;
                        newSummaryRec.Vision_Customer_Hierarchy__c = externalSalesRecord.Vision_Customer_Hierarchy__c;
                        newSummaryRec.Vision_Customer_Desc__c = externalSalesRecord.Vision_Customer_Desc__c;
                        newSummaryRec.Vision_customer_code__c = externalSalesRecord.Vision_customer_code__c;
                        newSummaryRec.Vision_Category__c = externalSalesRecord.Vision_Category__c;
                         newsummaryRec.Vision_DIVISION_DESC__c=externalSalesRecord.Vision_DIVISION_DESC__c;
                        newSummaryRec.Vision_Unique_Identifier__c = mapKey+'_'+externalSalesRecord.Vision_Processed_Date__c.month();
                        oneStepInnerMap.put(externalSalesRecord.Vision_Processed_Date__c.month(), newSummaryRec);
                     }
                    
                } 
                else{
                    Vision_DRL_Sales_Summary__c newSummaryRec = new Vision_DRL_Sales_Summary__c();
                    if(externalSalesRecord.Vision_Segment__c == 'Rx' || externalSalesRecord.Vision_Segment__c == 'RX'){
                            newSummaryRec.Vision_Is_Rx__c = true;
                        } else if(externalSalesRecord.Vision_Segment__c == 'SRx' || externalSalesRecord.Vision_Segment__c == 'SRX'){
                            newSummaryRec.Vision_Is_SRx__c = true;
                        } else if(externalSalesRecord.Vision_Segment__c == 'OTC'){
                            newSummaryRec.Vision_Is_OTC__c =  true;
                        }
                    newSummaryRec.Vision_Customer__c = externalSalesRecord.Vision_Customer__c;
                    newSummaryRec.Vision_Processed_Date__c = externalSalesRecord.Vision_Processed_Date__c;
                    newSummaryRec.Vision_Sales__c = externalSalesRecord.Vision_net_sales__c;
                    newSummaryRec.Vision_Units__c = externalSalesRecord.Vision_Units__c;
                    newSummaryRec.Direct_Sales__c = externalSalesRecord.Vision_sales_direct__c;
                    newSummaryRec.Direct_Units__c = externalSalesRecord.Vision_direct_qty__c;
                    newSummaryRec.Indirect_Sales__c = externalSalesRecord.Vision_sales_indirect__c;
                    newSummaryRec.Indirect_Units__c = externalSalesRecord.Vision_indirect_qty__c;
                    newSummaryRec.Vision_Cutomer_Hierarchy_Code__c = externalSalesRecord.Vision_Cutomer_Hierarchy_Code__c;
                    newSummaryRec.Vision_Customer_Hierarchy__c = externalSalesRecord.Vision_Customer_Hierarchy__c;
                    newSummaryRec.Vision_Customer_Desc__c = externalSalesRecord.Vision_Customer_Desc__c;
                    newSummaryRec.Vision_Category__c = externalSalesRecord.Vision_Category__c;
                    newSummaryRec.Vision_customer_code__c = externalSalesRecord.Vision_customer_code__c;
                     newsummaryRec.Vision_DIVISION_DESC__c=externalSalesRecord.Vision_DIVISION_DESC__c;
                    newSummaryRec.Vision_Unique_Identifier__c = mapKey+'_'+externalSalesRecord.Vision_Processed_Date__c.month();
                    Map<Integer, Vision_DRL_Sales_Summary__c> oneStepInnerMap = new Map<Integer, Vision_DRL_Sales_Summary__c>();
                    oneStepInnerMap.put(externalSalesRecord.Vision_Processed_Date__c.month(), newSummaryRec);
                    finalMap.put(mapKey, oneStepInnerMap);
                }
                
            
                if(finalMap.size() > 0){
                    for(String custKey: finalMap.keySet()){
                        Map<Integer, Vision_DRL_Sales_Summary__c> custSpecificData = finalMap.get(custKey);
                        for(Integer monthKey: custSpecificData.keySet()){
                            existingUniqueIds.add(custSpecificData.get(monthKey).Vision_Unique_Identifier__c);
                            summaryRecordsToInsert.put(custSpecificData.get(monthKey).Vision_Unique_Identifier__c, custSpecificData.get(monthKey));
                        }
                    }
                }
            }
            for(Vision_DRL_Sales_Summary__c intDRLSalesRec : [select Id,Vision_Sales__c,Direct_Sales__c,Direct_Units__c,Indirect_Sales__c,Indirect_Units__c,Vision_Units__c,Vision_Unique_Identifier__c From Vision_DRL_Sales_Summary__c Where Vision_Unique_Identifier__c in : existingUniqueIds]){
                if(intDRLSalesRec.Vision_Unique_Identifier__c!=null && summaryRecordsToInsert.containsKey(intDRLSalesRec.Vision_Unique_Identifier__c)){
                if( intDRLSalesRec.Id != null){
                summaryRecordsToInsert.get(intDRLSalesRec.Vision_Unique_Identifier__c).Id = intDRLSalesRec.Id;
                }
                if(summaryRecordsToInsert.get(intDRLSalesRec.Vision_Unique_Identifier__c).Vision_Sales__c != null && intDRLSalesRec.Vision_Sales__c != null){
               
                summaryRecordsToInsert.get(intDRLSalesRec.Vision_Unique_Identifier__c).Vision_Sales__c = summaryRecordsToInsert.get(intDRLSalesRec.Vision_Unique_Identifier__c).Vision_Sales__c + intDRLSalesRec.Vision_Sales__c;
                }
                if(summaryRecordsToInsert.get(intDRLSalesRec.Vision_Unique_Identifier__c).Vision_Units__c != null && intDRLSalesRec.Vision_Units__c != null){
                    summaryRecordsToInsert.get(intDRLSalesRec.Vision_Unique_Identifier__c).Vision_Units__c = summaryRecordsToInsert.get(intDRLSalesRec.Vision_Unique_Identifier__c).Vision_Units__c + intDRLSalesRec.Vision_Units__c;
                }
                }
               //    summaryRecordsToInsert.get(intDRLSalesRec.Vision_Unique_Identifier__c).Vision_TPT_Percent__c = summaryRecordsToInsert.get(intDRLSalesRec.Vision_Unique_Identifier__c).Vision_TPT_Percent__c + intDRLSalesRec.Vision_TPT_Percent__c;
            }
            if(summaryRecordsToInsert.size() > 0){
                for(String key : summaryRecordsToInsert.keySet()){
                  }
                upsert summaryRecordsToInsert.values();
            //insert summaryRecordsToInsert.values();
            }
        }catch(Exception e) {
            Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'VisionDRLSalesSummaryBatchCls', Phoenix_Error_Message__c = e.getMessage(), Phoenix_Issue_Status__c = 'Pending', Phoenix_Method_Name__c = 'execute', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
            insert exp;
        }
        
    }
    
    public void finish(Database.BatchableContext BC) {}
   
}