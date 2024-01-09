public class SRxDirectTargetExclusionSummaryBatchCls implements Database.Batchable < sObject > , Database.Stateful,Schedulable,Database.AllowsCallouts{
	  public void execute(SchedulableContext sc) {
        //Database.executeBatch(new VisionInternalDRLSalesSummaryBatchCls());
    }
     public Database.QueryLocator start(Database.BatchableContext BC) {
         //delete [Select Id FROM Target_Exclusion_Summary__c WHERE CreatedDate != Today LIMIT 10000];
        // String sales_Rep = 'Brenda Kern';
         //where  Phoenix_Sales_Rep__c=: sales_Rep
         String soldToNum1 = '166462';
          String soldToNum2 = '155781';
       		String exlude = 'YES';
         
         String query = 'Select '+Phoenix_Util.getsObjectFieds('Phoenix_SRx_Direct_Sales_Data__c')+' from Phoenix_SRx_Direct_Sales_Data__c  where 	 Phoenix_Exclude_Flag__c =:exlude AND Phoenix_Sold_To_Rebate_Recipient__c !=:soldToNum1 AND Phoenix_Sold_To_Rebate_Recipient__c !=:soldToNum2 ORDER BY Phoenix_Billing_Date__c ASC NULLS LAST';
        return Database.getQueryLocator(query);
     }
     public void execute(Database.BatchableContext BC, List < Phoenix_SRx_Direct_Sales_Data__c > directSalesData) {
           try{
               Map<String, Map<Integer, Target_Exclusion_Summary__c>> finalMap = new Map<String, Map<Integer, Target_Exclusion_Summary__c>>();
               Map<String, Target_Exclusion_Summary__c> summaryRecordsToInsert = new  Map<String, Target_Exclusion_Summary__c>();
               set<String> existingUniqueIds = new set<String>();
                Date billingDate ;
               for(Phoenix_SRx_Direct_Sales_Data__c directSalesRecord: directSalesData){
                  billingDate= date.valueOf(directSalesRecord.Phoenix_Billing_Date__c);
                 String mapKey = directSalesRecord.Phoenix_Sales_Rep__c+'_'+'_'+directSalesRecord.Phoenix_Sold_To_Rebate_Recipient__c+'_'+directSalesRecord.Phoenix_Product_Family__c+'_'+directSalesRecord.Phoenix_Description__c+'_'+billingDate.year();
                   if(finalMap.containsKey(mapKey)){
                         System.debug('in first if==>'+directSalesData.size());
                         Map<Integer, Target_Exclusion_Summary__c> oneStepInnerMap = finalMap.get(mapKey);
                       if(oneStepInnerMap.containsKey(integer.valueof(billingDate.month()))){
                             System.debug('in oneStepInnerMap==>');
                         	Target_Exclusion_Summary__c summaryRec = oneStepInnerMap.get(billingDate.month());
                           	Decimal directSales =Decimal.valueof(directSalesRecord.Phoenix_Gross__c);
                           	summaryRec.Name = directSalesRecord.Name;
                           	summaryRec.Direct_Sales_Rep_Name__c = directSalesRecord.Phoenix_Sales_Rep__c != null ? directSalesRecord.Phoenix_Sales_Rep__c  : '';
                            summaryRec.Direct_Sold_To_Rebate_Percent__c = directSalesRecord.Phoenix_Sold_To_Rebate_Recipient__c;

                           	if(billingDate != null ) 	summaryRec.Direct_Billing_Date__c = billingDate ;
                        
                           if(summaryRec.Direct_Sales__c != null && directSalesRecord.Phoenix_Gross__c !=null) summaryRec.Direct_Sales__c = summaryRec.Direct_Sales__c+Decimal.valueof(directSalesRecord.Phoenix_Gross__c);
                           if(summaryRec.Direct_Units__c != null && directSalesRecord.Phoenix_Quantity_In_Units__c !=null) summaryRec.Direct_Units__c = summaryRec.Direct_Units__c+Decimal.valueof(directSalesRecord.Phoenix_Quantity_In_Units__c);
                           if(summaryRec.Direct_Sales_Rep_Name__c == 'Dave Smith' || summaryRec.Direct_Sales_Rep_Name__c == 'Nathan Cumme' || summaryRec.Direct_Sales_Rep_Name__c == 'Kristi Dodge' || summaryRec.Direct_Sales_Rep_Name__c == 'Angela Hattaway' || summaryRec.Direct_Sales_Rep_Name__c == 'Zachary McClard' || summaryRec.Direct_Sales_Rep_Name__c == 'Zack McClard' || summaryRec.Direct_Sales_Rep_Name__c == 'William Toupe' || summaryRec.Direct_Sales_Rep_Name__c == 'Willi Toups' ||  summaryRec.Direct_Sales_Rep_Name__c == 'Andre White'){
                             summaryRec.Direct_Region__c  = 'West';
                           }
                           if(summaryRec.Direct_Sales_Rep_Name__c == 'Eric Sutherland' || summaryRec.Direct_Sales_Rep_Name__c == 'Michael Alfino' || summaryRec.Direct_Sales_Rep_Name__c == 'Erica Bass' || summaryRec.Direct_Sales_Rep_Name__c == 'Susan Belleavoine' || summaryRec.Direct_Sales_Rep_Name__c == 'Brenda Kern' || summaryRec.Direct_Sales_Rep_Name__c == 'Heather Harris' ||  summaryRec.Direct_Sales_Rep_Name__c == 'Doris Hartell'){
                             summaryRec.Direct_Region__c  = 'East';
                           }
                           summaryRec.Direct_Customer_Name__c = 	directSalesRecord.Phoenix_Customer_Recipient_Name__c;
                           summaryRec.Direct_Product_Family__c = 	directSalesRecord.Phoenix_Product_Family__c;
                           summaryRec.Direct_Product__c = 	directSalesRecord.Phoenix_Description__c;
                           summaryRec.Direct_Indirect__c = 'Direct';
                           //summaryRec.Sold_To_Rebate_Percent__c = 	directSalesRecord.Phoenix_Sold_To_Rebate_Recipient__c;
                           summaryRec.Unique_Identifier__c = mapKey+'_'+integer.valueof(billingDate.month());
						System.debug('map key in if=='+mapKey);
                           
                       }else{
                              System.debug('in oneStepInnerMap else==>');
                            Target_Exclusion_Summary__c newSummaryRec = new Target_Exclusion_Summary__c();
                           	Decimal directSales = directSalesRecord.Phoenix_Gross__c != null ? Decimal.valueof(directSalesRecord.Phoenix_Gross__c) : 0;
                           	newSummaryRec.Name = directSalesRecord.Name;
                           	newSummaryRec.Direct_Sales_Rep_Name__c = directSalesRecord.Phoenix_Sales_Rep__c != null ? directSalesRecord.Phoenix_Sales_Rep__c : '';
                           	newSummaryRec.Direct_Sold_To_Rebate_Percent__c = directSalesRecord.Phoenix_Sold_To_Rebate_Recipient__c;

                           newSummaryRec.Direct_Sales__c =  directSales;
                            newSummaryRec.Direct_Units__c = directSalesRecord.Phoenix_Quantity_In_Units__c != null ? Decimal.valueof(directSalesRecord.Phoenix_Quantity_In_Units__c) : 0;

                           	if(billingDate != null)newSummaryRec.Direct_Billing_Date__c = billingDate ;
                          	//newSummaryRec.Direct__c = 'Direct';
                           if(newSummaryRec.Direct_Sales_Rep_Name__c == 'Dave Smith' || newSummaryRec.Direct_Sales_Rep_Name__c == 'Nathan Cumme' || newSummaryRec.Direct_Sales_Rep_Name__c == 'Kristi Dodge' || newSummaryRec.Direct_Sales_Rep_Name__c == 'Angela Hattaway' || newSummaryRec.Direct_Sales_Rep_Name__c == 'Zachary McClard' || newSummaryRec.Direct_Sales_Rep_Name__c == 'William Toupe' ||  newSummaryRec.Direct_Sales_Rep_Name__c == 'Andre White'){
                             newSummaryRec.Direct_Region__c  = 'West';
                           }
                           if(newSummaryRec.Direct_Sales_Rep_Name__c == 'Eric Sutherland' || newSummaryRec.Direct_Sales_Rep_Name__c == 'Michael Alfino' || newSummaryRec.Direct_Sales_Rep_Name__c == 'Erica Bass' || newSummaryRec.Direct_Sales_Rep_Name__c == 'Susan Belleavoine' || newSummaryRec.Direct_Sales_Rep_Name__c == 'Brenda Kern' || newSummaryRec.Direct_Sales_Rep_Name__c == 'Heather Harris' ||  newSummaryRec.Direct_Sales_Rep_Name__c == 'Doris Hartell'){
                             newSummaryRec.Direct_Region__c  = 'East';
                           }
						   newSummaryRec.Direct_Customer_Name__c = 	directSalesRecord.Phoenix_Customer_Recipient_Name__c;
                           newSummaryRec.Direct_Product_Family__c = 	directSalesRecord.Phoenix_Product_Family__c;
                           newSummaryRec.Direct_Product__c = 	directSalesRecord.Phoenix_Description__c;
                           //newSummaryRec.Sold_To_Rebate_Percent__c = directSalesRecord.Phoenix_Sold_To_Rebate_Recipient__c;
						   newSummaryRec.Direct_Indirect__c = 'Direct';
                           newSummaryRec.Unique_Identifier__c = mapKey+'_'+integer.valueof(billingDate.month());
                        	oneStepInnerMap.put(integer.valueof(billingDate.month()), newSummaryRec);

                       }
                       
                   }
                   else{
                       Target_Exclusion_Summary__c newSummaryRec = new Target_Exclusion_Summary__c();
                       Decimal directSales = directSalesRecord.Phoenix_Gross__c != null ? Decimal.valueof(directSalesRecord.Phoenix_Gross__c) : 0;
                       newSummaryRec.Name = directSalesRecord.Name;
                       newSummaryRec.Direct_Sales_Rep_Name__c = directSalesRecord.Phoenix_Sales_Rep__c != null ?directSalesRecord.Phoenix_Sales_Rep__c :'';
                      newSummaryRec.Direct_Sold_To_Rebate_Percent__c = directSalesRecord.Phoenix_Sold_To_Rebate_Recipient__c;

                       newSummaryRec.Direct_Sales__c =  directSales;
                       newSummaryRec.Direct_Units__c = directSalesRecord.Phoenix_Quantity_In_Units__c != null ? Decimal.valueof(directSalesRecord.Phoenix_Quantity_In_Units__c) : 0;
                       if(billingDate != null) newSummaryRec.Direct_Billing_Date__c = billingDate ;
                       if(newSummaryRec.Direct_Sales_Rep_Name__c == 'Dave Smith' || newSummaryRec.Direct_Sales_Rep_Name__c == 'Nathan Cumme' || newSummaryRec.Direct_Sales_Rep_Name__c == 'Kristi Dodge' || newSummaryRec.Direct_Sales_Rep_Name__c == 'Angela Hattaway' || newSummaryRec.Direct_Sales_Rep_Name__c == 'Zachary McClard' || newSummaryRec.Direct_Sales_Rep_Name__c == 'William Toupe' ||  newSummaryRec.Direct_Sales_Rep_Name__c == 'Andre White'){
                           newSummaryRec.Direct_Region__c  = 'West';
                       }
                       if(newSummaryRec.Direct_Sales_Rep_Name__c == 'Eric Sutherland' || newSummaryRec.Direct_Sales_Rep_Name__c == 'Michael Alfino' || newSummaryRec.Direct_Sales_Rep_Name__c == 'Erica Bass' || newSummaryRec.Direct_Sales_Rep_Name__c == 'Susan Belleavoine' || newSummaryRec.Direct_Sales_Rep_Name__c == 'Brenda Kern' || newSummaryRec.Direct_Sales_Rep_Name__c == 'Heather Harris' ||  newSummaryRec.Direct_Sales_Rep_Name__c == 'Doris Hartell'){
                           newSummaryRec.Direct_Region__c  = 'East';
                       }
                       newSummaryRec.Direct_Customer_Name__c = 	directSalesRecord.Phoenix_Customer_Recipient_Name__c;
                       newSummaryRec.Direct_Product_Family__c = 	directSalesRecord.Phoenix_Product_Family__c;
                       newSummaryRec.Direct_Product__c = 	directSalesRecord.Phoenix_Description__c;
                       //newSummaryRec.Sold_To_Rebate_Percent__c = directSalesRecord.Phoenix_Sold_To_Rebate_Recipient__c;
 						newSummaryRec.Direct_Indirect__c = 'Direct';
                       newSummaryRec.Unique_Identifier__c = mapKey+'_'+billingDate.month();
                      Map<Integer, Target_Exclusion_Summary__c> oneStepInnerMap = new Map<Integer, Target_Exclusion_Summary__c>();
                       oneStepInnerMap.put(integer.valueof(billingDate.month()), newSummaryRec);
                       finalMap.put(mapKey, oneStepInnerMap);
                  
                   }
                   System.debug('final map size==>'+finalMap.size());
                   if(finalMap.size() > 0){
                           for(String singleKey: finalMap.keySet()){
                               Map<Integer, Target_Exclusion_Summary__c> specificData = finalMap.get(singleKey);
                               for(Integer monthKey: specificData.keySet()){
                                   existingUniqueIds.add(specificData.get(monthKey).Unique_Identifier__c);
                                   summaryRecordsToInsert.put(specificData.get(monthKey).Unique_Identifier__c, specificData.get(monthKey));
                               }
                           }
                       }
               }
               for(Target_Exclusion_Summary__c directSalesRec : [select Id,Direct_Sales__c,Direct_Units__c,	Direct_Billing_Date__c,Direct_Sales_Rep_Name__c,	Unique_Identifier__c From Target_Exclusion_Summary__c Where 	Unique_Identifier__c in : existingUniqueIds]){
                summaryRecordsToInsert.get(directSalesRec.Unique_Identifier__c).Id = directSalesRec.Id;
                if(summaryRecordsToInsert.get(directSalesRec.Unique_Identifier__c).Direct_Sales__c != null && directSalesRec.Direct_Sales__c != null) summaryRecordsToInsert.get(directSalesRec.Unique_Identifier__c).Direct_Sales__c = summaryRecordsToInsert.get(directSalesRec.Unique_Identifier__c).Direct_Sales__c + directSalesRec.Direct_Sales__c;
                if(summaryRecordsToInsert.get(directSalesRec.Unique_Identifier__c).Direct_Units__c != null && directSalesRec.Direct_Units__c != null) summaryRecordsToInsert.get(directSalesRec.Unique_Identifier__c).Direct_Units__c = summaryRecordsToInsert.get(directSalesRec.Unique_Identifier__c).Direct_Units__c + directSalesRec.Direct_Units__c;

                   //    summaryRecordsToInsert.get(intDRLSalesRec.Vision_Unique_Identifier__c).Vision_TPT_Percent__c = summaryRecordsToInsert.get(intDRLSalesRec.Vision_Unique_Identifier__c).Vision_TPT_Percent__c + intDRLSalesRec.Vision_TPT_Percent__c;
            }
               System.debug('summaryRecordsToInsert==>'+summaryRecordsToInsert);
            if(summaryRecordsToInsert.size() > 0) upsert summaryRecordsToInsert.values();
               
           }
         catch(Exception e) {
             String msg = e.getMessage().length() > 255 ? e.getMessage().substring(0, 254) : e.getMessage();
 			System.debug('msg==>'+msg);
         }
     }
     public void finish(Database.BatchableContext BC) {}
}