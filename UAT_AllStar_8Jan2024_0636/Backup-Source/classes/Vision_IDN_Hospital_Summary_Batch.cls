public class Vision_IDN_Hospital_Summary_Batch implements Database.Batchable < sObject >{
    public Database.QueryLocator start(Database.BatchableContext BC) {
        //delete [Select Id FROM IDN_Charge_Back_Hospital_Summary__c WHERE CreatedDate != Today LIMIT 10000];
        //and Sales_Rep_Territory__c =:salesrep
        string hospitalName = 'Advocate Aurora Health';
        string salesrep = 'Zack McClard';
        string month_year = 'Dec-22';
        //where Hospital_Name__c =:hospitalName
         String query = 'Select Contract__r.Name, '+Phoenix_Util.getsObjectFieds('IDN_Charge_Back__c')+' from IDN_Charge_Back__c  ORDER BY Settlement_Paid_Date__c,Contract_Sales_Indirect_Price__c DESC NULLS LAST  ';
        return Database.getQueryLocator(query);
    }
	 public void execute(Database.BatchableContext BC, List < IDN_Charge_Back__c > listOfChargebackRecords) {
         try{ 
             Map<String, Map<Integer, IDN_Charge_Back_Hospital_Summary__c>> finalMap = new Map<String, Map<Integer, IDN_Charge_Back_Hospital_Summary__c>>();
             Map<String, IDN_Charge_Back_Hospital_Summary__c> summaryRecordsToInsert = new  Map<String, IDN_Charge_Back_Hospital_Summary__c>();
             set<String> existingUniqueIds = new set<String>();
             for(IDN_Charge_Back__c chargebackRecord: listOfChargebackRecords){
                 String mapKey = chargebackRecord.Hospital_Name__c+'-'+chargebackRecord.Sales_Rep_Territory__c+'_'+chargebackRecord.Settlement_Paid_Date__c.year();
                 if(finalMap.containsKey(mapKey)){
                     Map<Integer, IDN_Charge_Back_Hospital_Summary__c> oneStepInnerMap = finalMap.get(mapKey);
                     if(oneStepInnerMap.containsKey(chargebackRecord.Settlement_Paid_Date__c.month())){
                         IDN_Charge_Back_Hospital_Summary__c summaryRec = oneStepInnerMap.get(chargebackRecord.Settlement_Paid_Date__c.month());
                         summaryRec.H1_Hospital_Name__c = chargebackRecord.Hospital_Name__c;
                         summaryRec.H1_Sales_Rep_Territory__c = chargebackRecord.Sales_Rep_Territory__c;
                         summaryRec.H1_Settlement_Paid_Date__c = chargebackRecord.Settlement_Paid_Date__c;	
                         summaryRec.H1_Month_Year__c = chargebackRecord.Month_Year__c;
                         summaryRec.H1_Child1_Name__c = chargebackRecord.Child1_Name__c;
                         summaryRec.H1_Child2_Name__c = chargebackRecord.Child2_Name__c;
                         summaryRec.H1_revised_product_family__c = chargebackRecord.revised_product_family__c;	
                         summaryRec.H1_material_description__c = chargebackRecord.material_description__c;	
                         summaryRec.H1_Contact_Description__c = chargebackRecord.Contact_Description__c;
                         summaryRec.H1_Region__c = chargebackRecord.Region__c;
                         summaryRec.H1_Category__c = chargebackRecord.Category__c;
                         summaryRec.H1_Member_State__c = chargebackRecord.Member_State__c;
                         summaryRec.H1_member_city__c = chargebackRecord.member_city__c;
                         summaryRec.H1_Submitter_Name__c = chargebackRecord.Submitter_Name__c;
                         summaryRec.H1_Tab_Reference__c = 'HPC';
                         summaryRec.H1_Level__c = 'First';
                         if(summaryRec.H1_Contract_Sales_Indirect_Price__c != null && chargebackRecord.Contract_Sales_Indirect_Price__c !=null){
                         summaryRec.H1_Contract_Sales_Indirect_Price__c = summaryRec.H1_Contract_Sales_Indirect_Price__c+chargebackRecord.Contract_Sales_Indirect_Price__c;
                         }
                         if(summaryRec.H1_contract_units_paid_qty__c != null && chargebackRecord.contract_units_paid_qty__c !=null){
                            summaryRec.H1_contract_units_paid_qty__c = summaryRec.H1_contract_units_paid_qty__c+chargebackRecord.contract_units_paid_qty__c;
                         }
                         //summaryRec.Contract_Sales_Indirect_Price__c += chargebackRecord.Contract_Sales_Indirect_Price__c;
                         //summaryRec.contract_units_paid_qty__c += chargebackRecord.contract_units_paid_qty__c;
                         summaryRec.H1_Vision_Test_Unique_Identifier__c = mapKey+'_'+chargebackRecord.Settlement_Paid_Date__c.month();
                     }
                     else{
                         IDN_Charge_Back_Hospital_Summary__c newSummaryRec = new IDN_Charge_Back_Hospital_Summary__c();
                         newSummaryRec.H1_Hospital_Name__c = chargebackRecord.Hospital_Name__c;
                         newSummaryRec.H1_Sales_Rep_Territory__c = chargebackRecord.Sales_Rep_Territory__c;
                         newSummaryRec.H1_Settlement_Paid_Date__c = chargebackRecord.Settlement_Paid_Date__c;	
                         newSummaryRec.H1_Month_Year__c = chargebackRecord.Month_Year__c;
                         newSummaryRec.H1_Child1_Name__c = chargebackRecord.Child1_Name__c;
                         newSummaryRec.H1_Child2_Name__c = chargebackRecord.Child2_Name__c;
                         newSummaryRec.H1_revised_product_family__c = chargebackRecord.revised_product_family__c;
                         newSummaryRec.H1_material_description__c = chargebackRecord.material_description__c;	
                         newSummaryRec.H1_Contact_Description__c = chargebackRecord.Contact_Description__c;
                         newSummaryRec.H1_Contract_Sales_Indirect_Price__c = chargebackRecord.Contract_Sales_Indirect_Price__c;
                         newSummaryRec.H1_contract_units_paid_qty__c = chargebackRecord.contract_units_paid_qty__c;
                         newSummaryRec.H1_Tab_Reference__c = 'HPC';
                         newSummaryRec.H1_Region__c = chargebackRecord.Region__c;
                         newSummaryRec.H1_Category__c = chargebackRecord.Category__c;
                         newSummaryRec.H1_Member_State__c = chargebackRecord.Member_State__c;
                         newSummaryRec.H1_member_city__c = chargebackRecord.member_city__c;
                         newSummaryRec.H1_Submitter_Name__c = chargebackRecord.Submitter_Name__c;
                         newSummaryRec.H1_Level__c = 'First';
                         newSummaryRec.H1_Vision_Test_Unique_Identifier__c = mapKey+'_'+chargebackRecord.Settlement_Paid_Date__c.month();
                        
                         oneStepInnerMap.put(chargebackRecord.Settlement_Paid_Date__c.month(), newSummaryRec);
                     }
                     System.debug('oneStepInnerMap==>'+oneStepInnerMap);
                     System.debug('oneStepInnerMap==>'+oneStepInnerMap.size());
                 }
                 else{
                     IDN_Charge_Back_Hospital_Summary__c newSummaryRec = new IDN_Charge_Back_Hospital_Summary__c();
                     newSummaryRec.H1_Hospital_Name__c = chargebackRecord.Hospital_Name__c;
                     newSummaryRec.H1_Sales_Rep_Territory__c = chargebackRecord.Sales_Rep_Territory__c;
                     newSummaryRec.H1_Settlement_Paid_Date__c = chargebackRecord.Settlement_Paid_Date__c;	
                     newSummaryRec.H1_Month_Year__c = chargebackRecord.Month_Year__c;
                     newSummaryRec.H1_Child1_Name__c = chargebackRecord.Child1_Name__c;
                     newSummaryRec.H1_Child2_Name__c = chargebackRecord.Child2_Name__c;
                     newSummaryRec.H1_revised_product_family__c = chargebackRecord.revised_product_family__c;	
                     newSummaryRec.H1_material_description__c = chargebackRecord.material_description__c;
                     newSummaryRec.H1_Contact_Description__c = chargebackRecord.Contact_Description__c;
                     newSummaryRec.H1_Contract_Sales_Indirect_Price__c = chargebackRecord.Contract_Sales_Indirect_Price__c;
                     newSummaryRec.H1_contract_units_paid_qty__c = chargebackRecord.contract_units_paid_qty__c;
                     newSummaryRec.H1_Tab_Reference__c = 'HPC'; newSummaryRec.H1_Region__c = chargebackRecord.Region__c;
                     newSummaryRec.H1_Category__c = chargebackRecord.Category__c;
                     newSummaryRec.H1_Member_State__c = chargebackRecord.Member_State__c;
                     newSummaryRec.H1_member_city__c = chargebackRecord.member_city__c;
                     newSummaryRec.H1_Submitter_Name__c = chargebackRecord.Submitter_Name__c;
                     newSummaryRec.H1_Level__c = 'First';
                     newSummaryRec.H1_Vision_Test_Unique_Identifier__c = mapKey+'_'+chargebackRecord.Settlement_Paid_Date__c.month();
                     Map<Integer, IDN_Charge_Back_Hospital_Summary__c> oneStepInnerMap = new Map<Integer, IDN_Charge_Back_Hospital_Summary__c>();
                     oneStepInnerMap.put(chargebackRecord.Settlement_Paid_Date__c.month(), newSummaryRec);
                     finalMap.put(mapKey, oneStepInnerMap);
                     
                 }
                 System.debug('finalMap==>'+finalMap);
                  System.debug('finalMap==>'+finalMap.size());
                 System.debug('finalMap==>'+finalMap.keySet());
                 if(finalMap.size() > 0){
                     for(String hsptlKey: finalMap.keySet()){
                         Map<Integer, IDN_Charge_Back_Hospital_Summary__c> hsptlSpecificData = finalMap.get(hsptlKey);
                         for(Integer monthKey: hsptlSpecificData.keySet()){
                             existingUniqueIds.add(hsptlSpecificData.get(monthKey).H1_Vision_Test_Unique_Identifier__c);
                             summaryRecordsToInsert.put(hsptlSpecificData.get(monthKey).H1_Vision_Test_Unique_Identifier__c, hsptlSpecificData.get(monthKey));
                         }
                     }
                 }
                 
             }
             for(IDN_Charge_Back_Hospital_Summary__c chargebackRec : [select Id,H1_Hospital_Name__c,H1_Settlement_Paid_Date__c,H1_Vision_Test_Unique_Identifier__c,	H1_contract_units_paid_qty__c,	H1_Contract_Sales_Indirect_Price__c From IDN_Charge_Back_Hospital_Summary__c Where H1_Vision_Test_Unique_Identifier__c in : existingUniqueIds]){
                     summaryRecordsToInsert.get(chargebackRec.H1_Vision_Test_Unique_Identifier__c).Id = chargebackRec.Id;
                     if(summaryRecordsToInsert.get(chargebackRec.H1_Vision_Test_Unique_Identifier__c).H1_Contract_Sales_Indirect_Price__c != null && chargebackRec.H1_Contract_Sales_Indirect_Price__c != null){ 
                         summaryRecordsToInsert.get(chargebackRec.H1_Vision_Test_Unique_Identifier__c).H1_Contract_Sales_Indirect_Price__c = summaryRecordsToInsert.get(chargebackRec.H1_Vision_Test_Unique_Identifier__c).H1_Contract_Sales_Indirect_Price__c + chargebackRec.H1_Contract_Sales_Indirect_Price__c;
                     }
                     if(summaryRecordsToInsert.get(chargebackRec.H1_Vision_Test_Unique_Identifier__c).H1_contract_units_paid_qty__c != null && chargebackRec.H1_contract_units_paid_qty__c != null){
                         summaryRecordsToInsert.get(chargebackRec.H1_Vision_Test_Unique_Identifier__c).H1_contract_units_paid_qty__c = summaryRecordsToInsert.get(chargebackRec.H1_Vision_Test_Unique_Identifier__c).H1_contract_units_paid_qty__c + chargebackRec.H1_contract_units_paid_qty__c;
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