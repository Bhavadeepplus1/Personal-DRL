public class SRxIndirectSalesSummaryBatchCls implements Database.Batchable < sObject > , Database.Stateful,Schedulable,Database.AllowsCallouts{
	  public void execute(SchedulableContext sc) {
        //Database.executeBatch(new VisionInternalDRLSalesSummaryBatchCls());
    }
     public Database.QueryLocator start(Database.BatchableContext BC) {
         //delete [Select Id FROM SRx_IndirectSales_Summary_Table__c WHERE CreatedDate != Today LIMIT 10000];
        // String sales_Rep = 'Brenda Kern';
         //where  Phoenix_Sales_Rep__c=: sales_Rep
         String soldToNum1 = '166462';
          String soldToNum2 = '155781';
       		String exlude = 'N';
         
         String query = 'Select '+Phoenix_Util.getsObjectFieds('IDN_Charge_Back__c')+' from IDN_Charge_Back__c  where Exclude_Flag__c =:exlude ORDER BY Settlement_Paid_Date__c ASC NULLS LAST';
        return Database.getQueryLocator(query);
     }
     public void execute(Database.BatchableContext BC, List < IDN_Charge_Back__c > indirectSalesData) {
           try{
               System.debug('indirectSalesData==>'+indirectSalesData.size());
               Map<String, Map<Integer, SRx_IndirectSales_Summary_Table__c>> finalMap = new Map<String, Map<Integer, SRx_IndirectSales_Summary_Table__c>>();
               Map<String, SRx_IndirectSales_Summary_Table__c> summaryRecordsToInsert = new  Map<String, SRx_IndirectSales_Summary_Table__c>();
               set<String> existingUniqueIds = new set<String>();
                Date billingDate ;
               for(IDN_Charge_Back__c indirectSalesRecord: indirectSalesData){
                 billingDate= 	indirectSalesRecord.Settlement_Paid_Date__c;//date.valueOf(directSalesRecord.Phoenix_Billing_Date__c);
                // String mapKey = indirectSalesRecord.Sales_Rep_Territory__c+'_'+'_'+indirectSalesRecord.Hospital_Id__c+'_'+indirectSalesRecord.revised_product_family__c+'_'+indirectSalesRecord.material_description__c+'_'+billingDate.year();
                 String mapKey = indirectSalesRecord.Sales_Rep_Territory__c+'_'+indirectSalesRecord.contact_id__c+'_'+indirectSalesRecord.Customer_Name__c+'_'+indirectSalesRecord.revised_product_family__c+'_'+indirectSalesRecord.Material_Number__c+'_'+'_'+indirectSalesRecord.Settlement_Paid_Date__c.year();
                   if(finalMap.containsKey(mapKey)){
                         Map<Integer, SRx_IndirectSales_Summary_Table__c> oneStepInnerMap = finalMap.get(mapKey);
                       if(oneStepInnerMap.containsKey(integer.valueof(billingDate.month()))){
                             System.debug('in oneStepInnerMap==>');
                         	SRx_IndirectSales_Summary_Table__c summaryRec = oneStepInnerMap.get(billingDate.month());
                           	Decimal indirectSales =indirectSalesRecord.Contract_Sales_Indirect_Price__c;
                           	summaryRec.Name = indirectSalesRecord.Name;
                           summaryRec.Contract_Number__c = indirectSalesRecord.contact_id__c != null ? indirectSalesRecord.contact_id__c : '';
                        	summaryRec.Contract__c = indirectSalesRecord.Contact_Description__c != null ? indirectSalesRecord.Contact_Description__c : '';
                           	summaryRec.Sales_Rep_Name__c = indirectSalesRecord.Sales_Rep_Territory__c != null ? indirectSalesRecord.Sales_Rep_Territory__c  : '';
                           	if(billingDate != null ) 	summaryRec.Settlement_Paid_Date__c = billingDate ;
                           if(summaryRec.Sales__c != null && indirectSalesRecord.Contract_Sales_Indirect_Price__c !=null) summaryRec.Sales__c = summaryRec.Sales__c+indirectSalesRecord.Contract_Sales_Indirect_Price__c;
                           if(summaryRec.Units__c != null && indirectSalesRecord.contract_units_paid_qty__c !=null) summaryRec.Units__c = summaryRec.Units__c+indirectSalesRecord.contract_units_paid_qty__c;
                           if(summaryRec.Sales_Rep_Name__c == 'Dave Smith' || summaryRec.Sales_Rep_Name__c == 'Nathan Cumme' || summaryRec.Sales_Rep_Name__c == 'Kristi Dodge' || summaryRec.Sales_Rep_Name__c == 'Angela Hattaway' || summaryRec.Sales_Rep_Name__c == 'Zachary McClard' || summaryRec.Sales_Rep_Name__c == 'Zack McClard' || summaryRec.Sales_Rep_Name__c == 'William Toupe' || summaryRec.Sales_Rep_Name__c == 'Willi Toups' ||  summaryRec.Sales_Rep_Name__c == 'Andre White'){
                             summaryRec.Region__c  = 'West';
                           }
                           if(summaryRec.Sales_Rep_Name__c == 'Eric Sutherland' || summaryRec.Sales_Rep_Name__c == 'Michael Alfino' || summaryRec.Sales_Rep_Name__c == 'Erica Bass' || summaryRec.Sales_Rep_Name__c == 'Susan Belleavoine' || summaryRec.Sales_Rep_Name__c == 'Brenda Kern' || summaryRec.Sales_Rep_Name__c == 'Heather Harris' ||  summaryRec.Sales_Rep_Name__c == 'Doris Hartell'){
                             summaryRec.Region__c  = 'East';
                           }
                           summaryRec.Hospital_Name__c = 	indirectSalesRecord.Customer_Name__c;
                           summaryRec.Product_Family__c = 	indirectSalesRecord.revised_product_family__c;
                           summaryRec.Product__c = 	indirectSalesRecord.material_description__c;
                           //summaryRec.Sold_To_Rebate_Percent__c = 	indirectSalesRecord.Phoenix_Sold_To_Rebate_Recipient__c;
                           summaryRec.Unique_Identifier__c = mapKey+'_'+integer.valueof(billingDate.month());
						System.debug('map key in if=='+mapKey);
                           
                       }else{
                              System.debug('in oneStepInnerMap else==>');
                             SRx_IndirectSales_Summary_Table__c newSummaryRec = new SRx_IndirectSales_Summary_Table__c();
                           	Decimal indirectSales = indirectSalesRecord.Contract_Sales_Indirect_Price__c != null ? indirectSalesRecord.Contract_Sales_Indirect_Price__c : 0;
                           	newSummaryRec.Name = indirectSalesRecord.Name;
                          	newSummaryRec.Contract_Number__c = indirectSalesRecord.contact_id__c != null ? indirectSalesRecord.contact_id__c : '';
                        	newSummaryRec.Contract__c = indirectSalesRecord.Contact_Description__c != null ? indirectSalesRecord.Contact_Description__c : '';

                           	newSummaryRec.Sales_Rep_Name__c = indirectSalesRecord.Sales_Rep_Territory__c != null ? indirectSalesRecord.Sales_Rep_Territory__c : '';
                           	newSummaryRec.Sales__c =  indirectSales;
                            newSummaryRec.Units__c = indirectSalesRecord.contract_units_paid_qty__c != null ? indirectSalesRecord.contract_units_paid_qty__c : 0;
                           	if(billingDate != null)newSummaryRec.Settlement_Paid_Date__c = billingDate ;
                          	//newSummaryRec.Direct__c = 'Direct';
                           if(newSummaryRec.Sales_Rep_Name__c == 'Dave Smith' || newSummaryRec.Sales_Rep_Name__c == 'Nathan Cumme' || newSummaryRec.Sales_Rep_Name__c == 'Kristi Dodge' || newSummaryRec.Sales_Rep_Name__c == 'Angela Hattaway' || newSummaryRec.Sales_Rep_Name__c == 'Zachary McClard' || newSummaryRec.Sales_Rep_Name__c == 'William Toupe' ||  newSummaryRec.Sales_Rep_Name__c == 'Andre White'){
                             newSummaryRec.Region__c  = 'West';
                           }
                           if(newSummaryRec.Sales_Rep_Name__c == 'Eric Sutherland' || newSummaryRec.Sales_Rep_Name__c == 'Michael Alfino' || newSummaryRec.Sales_Rep_Name__c == 'Erica Bass' || newSummaryRec.Sales_Rep_Name__c == 'Susan Belleavoine' || newSummaryRec.Sales_Rep_Name__c == 'Brenda Kern' || newSummaryRec.Sales_Rep_Name__c == 'Heather Harris' ||  newSummaryRec.Sales_Rep_Name__c == 'Doris Hartell'){
                             newSummaryRec.Region__c  = 'East';
                           }
						   newSummaryRec.Hospital_Name__c = 	indirectSalesRecord.Customer_Name__c;
                           newSummaryRec.Product_Family__c = 	indirectSalesRecord.revised_product_family__c;
                           newSummaryRec.Product__c = 	indirectSalesRecord.material_description__c;
                           //newSummaryRec.Sold_To_Rebate_Percent__c = directSalesRecord.Phoenix_Sold_To_Rebate_Recipient__c;

                           newSummaryRec.Unique_Identifier__c = mapKey+'_'+integer.valueof(billingDate.month());
                        	oneStepInnerMap.put(integer.valueof(billingDate.month()), newSummaryRec);

                       }
                       
                   }
                   else{
                       SRx_IndirectSales_Summary_Table__c newSummaryRec = new SRx_IndirectSales_Summary_Table__c();
                       Decimal indirectSales = indirectSalesRecord.Contract_Sales_Indirect_Price__c != null ? indirectSalesRecord.Contract_Sales_Indirect_Price__c : 0;
                       newSummaryRec.Name = indirectSalesRecord.Name;
                       newSummaryRec.Contract_Number__c = indirectSalesRecord.contact_id__c != null ? indirectSalesRecord.contact_id__c : '';
                       newSummaryRec.Contract__c = indirectSalesRecord.Contact_Description__c != null ? indirectSalesRecord.Contact_Description__c : '';
                       newSummaryRec.Sales_Rep_Name__c = indirectSalesRecord.Sales_Rep_Territory__c != null ?indirectSalesRecord.Sales_Rep_Territory__c :'';
                       newSummaryRec.Sales__c =  indirectSales;
                       newSummaryRec.Units__c = indirectSalesRecord.contract_units_paid_qty__c != null ? indirectSalesRecord.contract_units_paid_qty__c : 0;
                       if(billingDate != null) newSummaryRec.Settlement_Paid_Date__c = billingDate ;
                       if(newSummaryRec.Sales_Rep_Name__c == 'Dave Smith' || newSummaryRec.Sales_Rep_Name__c == 'Nathan Cumme' || newSummaryRec.Sales_Rep_Name__c == 'Kristi Dodge' || newSummaryRec.Sales_Rep_Name__c == 'Angela Hattaway' || newSummaryRec.Sales_Rep_Name__c == 'Zachary McClard' || newSummaryRec.Sales_Rep_Name__c == 'William Toupe' ||  newSummaryRec.Sales_Rep_Name__c == 'Andre White'){
                           newSummaryRec.Region__c  = 'West';
                       }
                       if(newSummaryRec.Sales_Rep_Name__c == 'Eric Sutherland' || newSummaryRec.Sales_Rep_Name__c == 'Michael Alfino' || newSummaryRec.Sales_Rep_Name__c == 'Erica Bass' || newSummaryRec.Sales_Rep_Name__c == 'Susan Belleavoine' || newSummaryRec.Sales_Rep_Name__c == 'Brenda Kern' || newSummaryRec.Sales_Rep_Name__c == 'Heather Harris' ||  newSummaryRec.Sales_Rep_Name__c == 'Doris Hartell'){
                           newSummaryRec.Region__c  = 'East';
                       }
                       newSummaryRec.Hospital_Name__c = 	indirectSalesRecord.Customer_Name__c;
                       newSummaryRec.Product_Family__c = 	indirectSalesRecord.revised_product_family__c;
                       newSummaryRec.Product__c = 	indirectSalesRecord.material_description__c;
                       //newSummaryRec.Sold_To_Rebate_Percent__c = directSalesRecord.Phoenix_Sold_To_Rebate_Recipient__c;

                       newSummaryRec.Unique_Identifier__c = mapKey+'_'+billingDate.month();
                      Map<Integer, SRx_IndirectSales_Summary_Table__c> oneStepInnerMap = new Map<Integer, SRx_IndirectSales_Summary_Table__c>();
                       oneStepInnerMap.put(integer.valueof(billingDate.month()), newSummaryRec);
                       finalMap.put(mapKey, oneStepInnerMap);
                  
                   }
                   System.debug('final map size==>'+finalMap.size());
                   if(finalMap.size() > 0){
                           for(String singleKey: finalMap.keySet()){
                               Map<Integer, SRx_IndirectSales_Summary_Table__c> specificData = finalMap.get(singleKey);
                               for(Integer monthKey: specificData.keySet()){
                                   existingUniqueIds.add(specificData.get(monthKey).Unique_Identifier__c);
                                   summaryRecordsToInsert.put(specificData.get(monthKey).Unique_Identifier__c, specificData.get(monthKey));
                               }
                           }
                       }
               }
               for(SRx_IndirectSales_Summary_Table__c indirectSalesRec : [select Id,Sales__c,Settlement_Paid_Date__c,Sales_Rep_Name__c,	Unique_Identifier__c From SRx_IndirectSales_Summary_Table__c Where 	Unique_Identifier__c in : existingUniqueIds]){
                summaryRecordsToInsert.get(indirectSalesRec.Unique_Identifier__c).Id = indirectSalesRec.Id;
                if(summaryRecordsToInsert.get(indirectSalesRec.Unique_Identifier__c).Sales__c != null && indirectSalesRec.Sales__c != null) summaryRecordsToInsert.get(indirectSalesRec.Unique_Identifier__c).Sales__c = summaryRecordsToInsert.get(indirectSalesRec.Unique_Identifier__c).Sales__c + indirectSalesRec.Sales__c;
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