public class SRxDirectSalesSummaryBatchCls implements Database.Batchable < sObject > , Database.Stateful,Schedulable,Database.AllowsCallouts{
	  public void execute(SchedulableContext sc) {
        //Database.executeBatch(new VisionInternalDRLSalesSummaryBatchCls());
    }
     public Database.QueryLocator start(Database.BatchableContext BC) {
         //delete [Select Id FROM SRx_DirectSales_SummaryTable__c WHERE CreatedDate != Today LIMIT 10000];
        // String sales_Rep = 'Brenda Kern';
         //where  Phoenix_Sales_Rep__c=: sales_Rep
         String soldToNum1 = '166462';
          String soldToNum2 = '155781';
       		String exlude = 'NO';
         
         String query = 'Select '+Phoenix_Util.getsObjectFieds('Phoenix_SRx_Direct_Sales_Data__c')+' from Phoenix_SRx_Direct_Sales_Data__c  where 	 Phoenix_Exclude_Flag__c =:exlude AND Phoenix_Sold_To_Rebate_Recipient__c !=:soldToNum1 AND Phoenix_Sold_To_Rebate_Recipient__c !=:soldToNum2 ORDER BY Phoenix_Billing_Date__c ASC NULLS LAST';
        return Database.getQueryLocator(query);
     }
     public void execute(Database.BatchableContext BC, List < Phoenix_SRx_Direct_Sales_Data__c > directSalesData) {
           try{
               System.debug('directSalesData==>'+directSalesData.size());
               Map<String, Map<Integer, SRx_DirectSales_SummaryTable__c>> finalMap = new Map<String, Map<Integer, SRx_DirectSales_SummaryTable__c>>();
               Map<String, SRx_DirectSales_SummaryTable__c> summaryRecordsToInsert = new  Map<String, SRx_DirectSales_SummaryTable__c>();
               set<String> existingUniqueIds = new set<String>();
                Date billingDate ;
               for(Phoenix_SRx_Direct_Sales_Data__c directSalesRecord: directSalesData){
                  billingDate= date.valueOf(directSalesRecord.Phoenix_Billing_Date__c);
                 String mapKey = directSalesRecord.Phoenix_Sales_Rep__c+'_'+'_'+directSalesRecord.Phoenix_Customer_Recipient_Name__c+'_'+directSalesRecord.Phoenix_Product_Family__c+'_'+directSalesRecord.Phoenix_Description__c+'_'+billingDate.year();
                   if(finalMap.containsKey(mapKey)){
                         System.debug('in first if==>'+directSalesData.size());
                         Map<Integer, SRx_DirectSales_SummaryTable__c> oneStepInnerMap = finalMap.get(mapKey);
                       if(oneStepInnerMap.containsKey(integer.valueof(billingDate.month()))){
                             System.debug('in oneStepInnerMap==>');
                         	SRx_DirectSales_SummaryTable__c summaryRec = oneStepInnerMap.get(billingDate.month());
                           	Decimal directSales =Decimal.valueof(directSalesRecord.Phoenix_Gross__c);
                           	summaryRec.Name = directSalesRecord.Name;
                           	summaryRec.Sales_Rep_Name__c = directSalesRecord.Phoenix_Sales_Rep__c != null ? directSalesRecord.Phoenix_Sales_Rep__c  : '';
                         
                           	if(billingDate != null ) 	summaryRec.Billing_Date__c = billingDate ;
                        
                           if(summaryRec.Sales__c != null && directSalesRecord.Phoenix_Gross__c !=null) summaryRec.Sales__c = summaryRec.Sales__c+Decimal.valueof(directSalesRecord.Phoenix_Gross__c);
                           if(summaryRec.Units__c != null && directSalesRecord.Phoenix_Quantity_In_Units__c !=null) summaryRec.Units__c = summaryRec.Units__c+Decimal.valueof(directSalesRecord.Phoenix_Quantity_In_Units__c);
                           if(summaryRec.Sales_Rep_Name__c == 'Dave Smith' || summaryRec.Sales_Rep_Name__c == 'Nathan Cumme' || summaryRec.Sales_Rep_Name__c == 'Kristi Dodge' || summaryRec.Sales_Rep_Name__c == 'Angela Hattaway' || summaryRec.Sales_Rep_Name__c == 'Zachary McClard' || summaryRec.Sales_Rep_Name__c == 'Zack McClard' || summaryRec.Sales_Rep_Name__c == 'William Toupe' || summaryRec.Sales_Rep_Name__c == 'Willi Toups' ||  summaryRec.Sales_Rep_Name__c == 'Andre White'){
                             summaryRec.Region__c  = 'West';
                           }
                           if(summaryRec.Sales_Rep_Name__c == 'Eric Sutherland' || summaryRec.Sales_Rep_Name__c == 'Michael Alfino' || summaryRec.Sales_Rep_Name__c == 'Erica Bass' || summaryRec.Sales_Rep_Name__c == 'Susan Belleavoine' || summaryRec.Sales_Rep_Name__c == 'Brenda Kern' || summaryRec.Sales_Rep_Name__c == 'Heather Harris' ||  summaryRec.Sales_Rep_Name__c == 'Doris Hartell'){
                             summaryRec.Region__c  = 'East';
                           }
                           summaryRec.Customer_Name__c = 	directSalesRecord.Phoenix_Customer_Recipient_Name__c;
                           summaryRec.Product_Family__c = 	directSalesRecord.Phoenix_Product_Family__c;
                           summaryRec.Product__c = 	directSalesRecord.Phoenix_Description__c;
                           summaryRec.Sold_To_Rebate_Percent__c = 	directSalesRecord.Phoenix_Sold_To_Rebate_Recipient__c;
                           summaryRec.Unique_Identifier__c = mapKey+'_'+integer.valueof(billingDate.month());
						System.debug('map key in if=='+mapKey);
                           
                       }else{
                              System.debug('in oneStepInnerMap else==>');
                             SRx_DirectSales_SummaryTable__c newSummaryRec = new SRx_DirectSales_SummaryTable__c();
                           	Decimal directSales = directSalesRecord.Phoenix_Gross__c != null ? Decimal.valueof(directSalesRecord.Phoenix_Gross__c) : 0;
                           	newSummaryRec.Name = directSalesRecord.Name;
                           	newSummaryRec.Sales_Rep_Name__c = directSalesRecord.Phoenix_Sales_Rep__c != null ? directSalesRecord.Phoenix_Sales_Rep__c : '';
                           	newSummaryRec.Sales__c =  directSales;
                            newSummaryRec.Units__c = directSalesRecord.Phoenix_Quantity_In_Units__c != null ? Decimal.valueof(directSalesRecord.Phoenix_Quantity_In_Units__c) : 0;

                           	if(billingDate != null)newSummaryRec.Billing_Date__c = billingDate ;
                          	//newSummaryRec.Direct__c = 'Direct';
                           if(newSummaryRec.Sales_Rep_Name__c == 'Dave Smith' || newSummaryRec.Sales_Rep_Name__c == 'Nathan Cumme' || newSummaryRec.Sales_Rep_Name__c == 'Kristi Dodge' || newSummaryRec.Sales_Rep_Name__c == 'Angela Hattaway' || newSummaryRec.Sales_Rep_Name__c == 'Zachary McClard' || newSummaryRec.Sales_Rep_Name__c == 'William Toupe' ||  newSummaryRec.Sales_Rep_Name__c == 'Andre White'){
                             newSummaryRec.Region__c  = 'West';
                           }
                           if(newSummaryRec.Sales_Rep_Name__c == 'Eric Sutherland' || newSummaryRec.Sales_Rep_Name__c == 'Michael Alfino' || newSummaryRec.Sales_Rep_Name__c == 'Erica Bass' || newSummaryRec.Sales_Rep_Name__c == 'Susan Belleavoine' || newSummaryRec.Sales_Rep_Name__c == 'Brenda Kern' || newSummaryRec.Sales_Rep_Name__c == 'Heather Harris' ||  newSummaryRec.Sales_Rep_Name__c == 'Doris Hartell'){
                             newSummaryRec.Region__c  = 'East';
                           }
						   newSummaryRec.Customer_Name__c = 	directSalesRecord.Phoenix_Customer_Recipient_Name__c;
                           newSummaryRec.Product_Family__c = 	directSalesRecord.Phoenix_Product_Family__c;
                           newSummaryRec.Product__c = 	directSalesRecord.Phoenix_Description__c;
                           newSummaryRec.Sold_To_Rebate_Percent__c = directSalesRecord.Phoenix_Sold_To_Rebate_Recipient__c;

                           newSummaryRec.Unique_Identifier__c = mapKey+'_'+integer.valueof(billingDate.month());
                        	oneStepInnerMap.put(integer.valueof(billingDate.month()), newSummaryRec);

                       }
                       
                   }
                   else{
                       SRx_DirectSales_SummaryTable__c newSummaryRec = new SRx_DirectSales_SummaryTable__c();
                       Decimal directSales = directSalesRecord.Phoenix_Gross__c != null ? Decimal.valueof(directSalesRecord.Phoenix_Gross__c) : 0;
                       newSummaryRec.Name = directSalesRecord.Name;
                       newSummaryRec.Sales_Rep_Name__c = directSalesRecord.Phoenix_Sales_Rep__c != null ?directSalesRecord.Phoenix_Sales_Rep__c :'';
                       newSummaryRec.Sales__c =  directSales;
                       newSummaryRec.Units__c = directSalesRecord.Phoenix_Quantity_In_Units__c != null ? Decimal.valueof(directSalesRecord.Phoenix_Quantity_In_Units__c) : 0;
                       if(billingDate != null) newSummaryRec.Billing_Date__c = billingDate ;
                       if(newSummaryRec.Sales_Rep_Name__c == 'Dave Smith' || newSummaryRec.Sales_Rep_Name__c == 'Nathan Cumme' || newSummaryRec.Sales_Rep_Name__c == 'Kristi Dodge' || newSummaryRec.Sales_Rep_Name__c == 'Angela Hattaway' || newSummaryRec.Sales_Rep_Name__c == 'Zachary McClard' || newSummaryRec.Sales_Rep_Name__c == 'William Toupe' ||  newSummaryRec.Sales_Rep_Name__c == 'Andre White'){
                           newSummaryRec.Region__c  = 'West';
                       }
                       if(newSummaryRec.Sales_Rep_Name__c == 'Eric Sutherland' || newSummaryRec.Sales_Rep_Name__c == 'Michael Alfino' || newSummaryRec.Sales_Rep_Name__c == 'Erica Bass' || newSummaryRec.Sales_Rep_Name__c == 'Susan Belleavoine' || newSummaryRec.Sales_Rep_Name__c == 'Brenda Kern' || newSummaryRec.Sales_Rep_Name__c == 'Heather Harris' ||  newSummaryRec.Sales_Rep_Name__c == 'Doris Hartell'){
                           newSummaryRec.Region__c  = 'East';
                       }
                       newSummaryRec.Customer_Name__c = 	directSalesRecord.Phoenix_Customer_Recipient_Name__c;
                       newSummaryRec.Product_Family__c = 	directSalesRecord.Phoenix_Product_Family__c;
                       newSummaryRec.Product__c = 	directSalesRecord.Phoenix_Description__c;
                       newSummaryRec.Sold_To_Rebate_Percent__c = directSalesRecord.Phoenix_Sold_To_Rebate_Recipient__c;

                       newSummaryRec.Unique_Identifier__c = mapKey+'_'+billingDate.month();
                      Map<Integer, SRx_DirectSales_SummaryTable__c> oneStepInnerMap = new Map<Integer, SRx_DirectSales_SummaryTable__c>();
                       oneStepInnerMap.put(integer.valueof(billingDate.month()), newSummaryRec);
                       finalMap.put(mapKey, oneStepInnerMap);
                  
                   }
                   System.debug('final map size==>'+finalMap.size());
                   if(finalMap.size() > 0){
                           for(String singleKey: finalMap.keySet()){
                               Map<Integer, SRx_DirectSales_SummaryTable__c> specificData = finalMap.get(singleKey);
                               for(Integer monthKey: specificData.keySet()){
                                   existingUniqueIds.add(specificData.get(monthKey).Unique_Identifier__c);
                                   summaryRecordsToInsert.put(specificData.get(monthKey).Unique_Identifier__c, specificData.get(monthKey));
                               }
                           }
                       }
               }
               for(SRx_DirectSales_SummaryTable__c directSalesRec : [select Id,Sales__c,Billing_Date__c,Sales_Rep_Name__c,	Unique_Identifier__c From SRx_DirectSales_SummaryTable__c Where 	Unique_Identifier__c in : existingUniqueIds]){
                summaryRecordsToInsert.get(directSalesRec.Unique_Identifier__c).Id = directSalesRec.Id;
                if(summaryRecordsToInsert.get(directSalesRec.Unique_Identifier__c).Sales__c != null && directSalesRec.Sales__c != null) summaryRecordsToInsert.get(directSalesRec.Unique_Identifier__c).Sales__c = summaryRecordsToInsert.get(directSalesRec.Unique_Identifier__c).Sales__c + directSalesRec.Sales__c;
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