public class SRxIndirectTgExclusionSummaryBatchCls implements Database.Batchable < sObject > , Database.Stateful,Schedulable,Database.AllowsCallouts{
    public void execute(SchedulableContext sc) {
       // Database.executeBatch(new SRxIndirectTgExclusionSummaryBatchCls());
    }
    public Database.QueryLocator start(Database.BatchableContext BC) {
        string hospitalName = 'Advocate Aurora Health';
        string salesrep = 'Zack McClard';
        string month_year = 'Dec-22';
        String exlude = 'Y';
        //where Hospital_Name__c =:hospitalName
        String query = 'Select '+Phoenix_Util.getsObjectFieds('IDN_Charge_Back__c')+' from IDN_Charge_Back__c where Exclude_Flag__c =:exlude ORDER BY Sold_to_Name__c,Settlement_Paid_Date__c ASC NULLS LAST';
        return Database.getQueryLocator(query);
    }
    public void execute(Database.BatchableContext BC, List < IDN_Charge_Back__c > listOfChargebackRecords) {
        try{ 
            //delete [Select Id FROM IDN_Charge_Back_Hospital_Summary__c WHERE H1_Level__c = 'Last' AND CreatedDate != Today LIMIT 1000];
            System.debug('listOfChargebackRecords==>'+listOfChargebackRecords);
            Map<String, Map<Integer, Indirect_TargetExclusion_Summary__c>> finalMap = new Map<String, Map<Integer, Indirect_TargetExclusion_Summary__c>>();
            Map<String, Indirect_TargetExclusion_Summary__c> summaryRecordsToInsert = new  Map<String, Indirect_TargetExclusion_Summary__c>();
            set<String> existingUniqueIds = new set<String>();
            for(IDN_Charge_Back__c indirectSalesRecord: listOfChargebackRecords){
                
                //String mapKey = chargebackRecord.Hospital_Name__c+'-'+chargebackRecord.Child_1__c+'_'+chargebackRecord.Child_2__c+'_'+chargebackRecord.revised_product_family__c+'_'+chargebackRecord.Material_Number__c+'_'+chargebackRecord.contact_id__c+'_'+chargebackRecord.Sales_Rep_Territory__c+'_'+chargebackRecord.Settlement_Paid_Date__c.year();
                String mapKey = indirectSalesRecord.Sales_Rep_Territory__c+'_'+indirectSalesRecord.contact_id__c+'_'+indirectSalesRecord.Customer_Name__c+'_'+indirectSalesRecord.revised_product_family__c+'_'+indirectSalesRecord.Material_Number__c+'_'+'_'+indirectSalesRecord.Settlement_Paid_Date__c.year();
                if(finalMap.containsKey(mapKey)){
                    System.debug('mapkey==>'+finalMap.get(mapKey));
                    Map<Integer, Indirect_TargetExclusion_Summary__c> oneStepInnerMap = finalMap.get(mapKey);
                    if(oneStepInnerMap.containsKey(indirectSalesRecord.Settlement_Paid_Date__c.month())){
                        Indirect_TargetExclusion_Summary__c summaryRec = oneStepInnerMap.get(indirectSalesRecord.Settlement_Paid_Date__c.month());
                        summaryRec.Name = indirectSalesRecord.Name;
                        summaryRec.Contract__c = indirectSalesRecord.Contact_Description__c != null ? indirectSalesRecord.Contact_Description__c : '';
                        summaryRec.Contract_Number__c = indirectSalesRecord.contact_id__c != null ? indirectSalesRecord.contact_id__c : '';
                        summaryRec.Contract__c = indirectSalesRecord.Contact_Description__c != null ? indirectSalesRecord.Contact_Description__c : '';
                        summaryRec.Indirect_Sales_Rep_Name__c = indirectSalesRecord.Sales_Rep_Territory__c != null ? indirectSalesRecord.Sales_Rep_Territory__c  : '';
                         
                           	if(indirectSalesRecord.Settlement_Paid_Date__c != null ) 	summaryRec.Indirect_Billing_Date__c = indirectSalesRecord.Settlement_Paid_Date__c ;
                        
                           if(summaryRec.Indirect_Sales__c != null && indirectSalesRecord.Contract_Sales_Indirect_Price__c !=null) summaryRec.Indirect_Sales__c = summaryRec.Indirect_Sales__c+indirectSalesRecord.Contract_Sales_Indirect_Price__c;
                           if(summaryRec.Indirect_Units__c != null && indirectSalesRecord.contract_units_paid_qty__c !=null) summaryRec.Indirect_Units__c = summaryRec.Indirect_Units__c+indirectSalesRecord.contract_units_paid_qty__c;
                           if(summaryRec.Indirect_Sales_Rep_Name__c == 'Dave Smith' || summaryRec.Indirect_Sales_Rep_Name__c == 'Nathan Cumme' || summaryRec.Indirect_Sales_Rep_Name__c == 'Kristi Dodge' || summaryRec.Indirect_Sales_Rep_Name__c == 'Angela Hattaway' || summaryRec.Indirect_Sales_Rep_Name__c == 'Zachary McClard' || summaryRec.Indirect_Sales_Rep_Name__c == 'Zack McClard' || summaryRec.Indirect_Sales_Rep_Name__c == 'William Toupe' || summaryRec.Indirect_Sales_Rep_Name__c == 'Willi Toups' ||  summaryRec.Indirect_Sales_Rep_Name__c == 'Andre White'){
                             summaryRec.Indirect_Region__c  = 'West';
                           }
                           if(summaryRec.Indirect_Sales_Rep_Name__c == 'Eric Sutherland' || summaryRec.Indirect_Sales_Rep_Name__c == 'Michael Alfino' || summaryRec.Indirect_Sales_Rep_Name__c == 'Erica Bass' || summaryRec.Indirect_Sales_Rep_Name__c == 'Susan Belleavoine' || summaryRec.Indirect_Sales_Rep_Name__c == 'Brenda Kern' || summaryRec.Indirect_Sales_Rep_Name__c == 'Heather Harris' ||  summaryRec.Indirect_Sales_Rep_Name__c == 'Doris Hartell'){
                             summaryRec.Indirect_Region__c  = 'East';
                           }
                           summaryRec.Indirect_Customer_Name__c = 	indirectSalesRecord.Customer_Name__c;
                           summaryRec.Sold_to_Number__c = indirectSalesRecord.Sold_to_Number__c;
                           summaryRec.Indirect_Product_Family__c = 	indirectSalesRecord.revised_product_family__c;
                           summaryRec.Indirect_Product__c = 	indirectSalesRecord.material_description__c;
                           summaryRec.Indirect_Unique_Identifier__c = mapKey+'_'+indirectSalesRecord.Settlement_Paid_Date__c.month();
                    }
                    else{
                        Indirect_TargetExclusion_Summary__c newSummaryRec = new Indirect_TargetExclusion_Summary__c();
                        decimal directSales = indirectSalesRecord.Contract_Sales_Indirect_Price__c != null ? indirectSalesRecord.Contract_Sales_Indirect_Price__c : 0;
                        newSummaryRec.Name = indirectSalesRecord.Name;
                        newSummaryRec.Contract__c = indirectSalesRecord.Contact_Description__c != null ? indirectSalesRecord.Contact_Description__c : '';
                        newSummaryRec.Contract_Number__c = indirectSalesRecord.contact_id__c != null ? indirectSalesRecord.contact_id__c : '';
                        newSummaryRec.Indirect_Sales_Rep_Name__c = indirectSalesRecord.Sales_Rep_Territory__c != null ? indirectSalesRecord.Sales_Rep_Territory__c : '';
                        newSummaryRec.Indirect_Sales__c =  directSales;
                        newSummaryRec.Indirect_Units__c = indirectSalesRecord.contract_units_paid_qty__c != null ? indirectSalesRecord.contract_units_paid_qty__c : 0;
                        
                        if(indirectSalesRecord.Settlement_Paid_Date__c != null)newSummaryRec.Indirect_Billing_Date__c = indirectSalesRecord.Settlement_Paid_Date__c ;
                        if(newSummaryRec.Indirect_Sales_Rep_Name__c == 'Dave Smith' || newSummaryRec.Indirect_Sales_Rep_Name__c == 'Nathan Cumme' || newSummaryRec.Indirect_Sales_Rep_Name__c == 'Kristi Dodge' || newSummaryRec.Indirect_Sales_Rep_Name__c == 'Angela Hattaway' || newSummaryRec.Indirect_Sales_Rep_Name__c == 'Zachary McClard' || newSummaryRec.Indirect_Sales_Rep_Name__c == 'William Toupe' ||  newSummaryRec.Indirect_Sales_Rep_Name__c == 'Andre White'){
                            newSummaryRec.Indirect_Region__c  = 'West';
                        }
                        if(newSummaryRec.Indirect_Sales_Rep_Name__c == 'Eric Sutherland' || newSummaryRec.Indirect_Sales_Rep_Name__c == 'Michael Alfino' || newSummaryRec.Indirect_Sales_Rep_Name__c == 'Erica Bass' || newSummaryRec.Indirect_Sales_Rep_Name__c == 'Susan Belleavoine' || newSummaryRec.Indirect_Sales_Rep_Name__c == 'Brenda Kern' || newSummaryRec.Indirect_Sales_Rep_Name__c == 'Heather Harris' ||  newSummaryRec.Indirect_Sales_Rep_Name__c == 'Doris Hartell'){
                            newSummaryRec.Indirect_Region__c  = 'East';
                        }
                        newSummaryRec.Indirect_Customer_Name__c = 	indirectSalesRecord.Customer_Name__c;
                        newSummaryRec.Sold_to_Number__c = indirectSalesRecord.Sold_to_Number__c;

                        newSummaryRec.Indirect_Product_Family__c = 	indirectSalesRecord.revised_product_family__c;
                        newSummaryRec.Indirect_Product__c = 	indirectSalesRecord.material_description__c;
                        
                        newSummaryRec.Indirect_Unique_Identifier__c = mapKey+'_'+indirectSalesRecord.Settlement_Paid_Date__c.month();
                        oneStepInnerMap.put(indirectSalesRecord.Settlement_Paid_Date__c.month(), newSummaryRec);
                    }
                   
                }
                else{
                    Indirect_TargetExclusion_Summary__c newSummaryRec = new Indirect_TargetExclusion_Summary__c();
                    Decimal directSales = indirectSalesRecord.Contract_Sales_Indirect_Price__c != null ? indirectSalesRecord.Contract_Sales_Indirect_Price__c : 0;
                       newSummaryRec.Name = indirectSalesRecord.Name;
                       newSummaryRec.Contract__c = indirectSalesRecord.Contact_Description__c != null ? indirectSalesRecord.Contact_Description__c : '';
                       newSummaryRec.Contract_Number__c = indirectSalesRecord.contact_id__c != null ? indirectSalesRecord.contact_id__c : '';
                       newSummaryRec.Indirect_Sales_Rep_Name__c = indirectSalesRecord.Sales_Rep_Territory__c != null ?indirectSalesRecord.Sales_Rep_Territory__c :'';
                       newSummaryRec.Indirect_Sales__c =  directSales;
                       newSummaryRec.Indirect_Units__c = indirectSalesRecord.contract_units_paid_qty__c != null ? indirectSalesRecord.contract_units_paid_qty__c : 0;
                       if(indirectSalesRecord.Settlement_Paid_Date__c != null) newSummaryRec.Indirect_Billing_Date__c = indirectSalesRecord.Settlement_Paid_Date__c ;
                       if(newSummaryRec.Indirect_Sales_Rep_Name__c == 'Dave Smith' || newSummaryRec.Indirect_Sales_Rep_Name__c == 'Nathan Cumme' || newSummaryRec.Indirect_Sales_Rep_Name__c == 'Kristi Dodge' || newSummaryRec.Indirect_Sales_Rep_Name__c == 'Angela Hattaway' || newSummaryRec.Indirect_Sales_Rep_Name__c == 'Zachary McClard' || newSummaryRec.Indirect_Sales_Rep_Name__c == 'William Toupe' ||  newSummaryRec.Indirect_Sales_Rep_Name__c == 'Andre White'){
                           newSummaryRec.Indirect_Region__c  = 'West';
                       }
                       if(newSummaryRec.Indirect_Sales_Rep_Name__c == 'Eric Sutherland' || newSummaryRec.Indirect_Sales_Rep_Name__c == 'Michael Alfino' || newSummaryRec.Indirect_Sales_Rep_Name__c == 'Erica Bass' || newSummaryRec.Indirect_Sales_Rep_Name__c == 'Susan Belleavoine' || newSummaryRec.Indirect_Sales_Rep_Name__c == 'Brenda Kern' || newSummaryRec.Indirect_Sales_Rep_Name__c == 'Heather Harris' ||  newSummaryRec.Indirect_Sales_Rep_Name__c == 'Doris Hartell'){
                           newSummaryRec.Indirect_Region__c  = 'East';
                       }
                       newSummaryRec.Indirect_Customer_Name__c = 	indirectSalesRecord.Customer_Name__c;
                       newSummaryRec.Sold_to_Number__c = indirectSalesRecord.Sold_to_Number__c;
                       newSummaryRec.Indirect_Product_Family__c = 	indirectSalesRecord.revised_product_family__c;
                       newSummaryRec.Indirect_Product__c = 	indirectSalesRecord.material_description__c;
                       
                    newSummaryRec.Indirect_Unique_Identifier__c = mapKey+'_'+indirectSalesRecord.Settlement_Paid_Date__c.month();
                    Map<Integer, Indirect_TargetExclusion_Summary__c> oneStepInnerMap = new Map<Integer, Indirect_TargetExclusion_Summary__c>();
                    oneStepInnerMap.put(indirectSalesRecord.Settlement_Paid_Date__c.month(), newSummaryRec);
                    finalMap.put(mapKey, oneStepInnerMap);
                    
                }
                System.debug('finalMap==>'+finalMap);
                System.debug('finalMap==>'+finalMap.size());
                System.debug('finalMap==>'+finalMap.keySet());
                if(finalMap.size() > 0){
                    for(String hsptlKey: finalMap.keySet()){
                        Map<Integer, Indirect_TargetExclusion_Summary__c> hsptlSpecificData = finalMap.get(hsptlKey);
                        for(Integer monthKey: hsptlSpecificData.keySet()){
                            existingUniqueIds.add(hsptlSpecificData.get(monthKey).Indirect_Unique_Identifier__c);
                            summaryRecordsToInsert.put(hsptlSpecificData.get(monthKey).Indirect_Unique_Identifier__c, hsptlSpecificData.get(monthKey));
                        }
                    }
                }
                
            }
            for(Indirect_TargetExclusion_Summary__c chargebackRec : [select Id,Indirect_Customer_Name__c,Indirect_Billing_Date__c,Indirect_Unique_Identifier__c,Indirect_Units__c,	Indirect_Sales__c From Indirect_TargetExclusion_Summary__c Where Indirect_Unique_Identifier__c in : existingUniqueIds]){
                summaryRecordsToInsert.get(chargebackRec.Indirect_Unique_Identifier__c).Id = chargebackRec.Id;
                if(summaryRecordsToInsert.get(chargebackRec.Indirect_Unique_Identifier__c).Indirect_Sales__c != null && chargebackRec.Indirect_Sales__c != null){ 
                    summaryRecordsToInsert.get(chargebackRec.Indirect_Unique_Identifier__c).Indirect_Sales__c = summaryRecordsToInsert.get(chargebackRec.Indirect_Unique_Identifier__c).Indirect_Sales__c + chargebackRec.Indirect_Sales__c;
                }
                if(summaryRecordsToInsert.get(chargebackRec.Indirect_Unique_Identifier__c).Indirect_Units__c != null && chargebackRec.Indirect_Units__c != null){
                    summaryRecordsToInsert.get(chargebackRec.Indirect_Unique_Identifier__c).Indirect_Units__c = summaryRecordsToInsert.get(chargebackRec.Indirect_Unique_Identifier__c).Indirect_Units__c + chargebackRec.Indirect_Units__c;
                }
            }
            
            if(summaryRecordsToInsert.size() > 0){
                upsert summaryRecordsToInsert.values();
                // insert summaryRecordsToInsert.values();
            }
            System.debug('summaryRecordsToInsert==>'+summaryRecordsToInsert.size());
            System.debug('summaryRecordsToInsert values==>'+summaryRecordsToInsert.values());
        }
        catch(Exception e) {
            Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'Vision_IDN_Hospital_Summary_Batch', Phoenix_Error_Message__c = e.getMessage(), Phoenix_Issue_Status__c = 'Pending', Phoenix_Method_Name__c = 'execute', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
            insert exp;
        }
    }
    public void finish(Database.BatchableContext BC) {}
}