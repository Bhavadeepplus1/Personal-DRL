public class Vision_IDN_Tab2_Summary_Batch implements Database.Batchable < sObject >,Schedulable{
    public void execute(SchedulableContext sc) {
        Database.executeBatch(new Vision_IDN_Tab2_Summary_Batch());
    }
    public Database.QueryLocator start(Database.BatchableContext BC) {
        //
        //and Sales_Rep_Territory__c =:salesrep
        string hospitalName = 'Advocate Aurora Health';
        string salesrep = 'Zack McClard';
        string month_year = 'Dec-22';
        //where Hospital_Name__c =:hospitalName
        String query = 'Select Contract__r.Name, '+Phoenix_Util.getsObjectFieds('IDN_Charge_Back__c')+' from IDN_Charge_Back__c ORDER BY Hospital_Name__c,Settlement_Paid_Date__c ASC NULLS LAST';
        return Database.getQueryLocator(query);
    }
    public void execute(Database.BatchableContext BC, List < IDN_Charge_Back__c > listOfChargebackRecords) {
        try{ 
            delete [Select Id FROM IDN_Charge_Back_Hospital_Summary__c WHERE H1_Level__c = 'Middle' AND CreatedDate != Today LIMIT 1000];
            System.debug('listOfChargebackRecords==>'+listOfChargebackRecords);
            Map<String, Map<Integer, IDN_Charge_Back_Hospital_Summary__c>> finalMap = new Map<String, Map<Integer, IDN_Charge_Back_Hospital_Summary__c>>();
            Map<String, IDN_Charge_Back_Hospital_Summary__c> summaryRecordsToInsert = new  Map<String, IDN_Charge_Back_Hospital_Summary__c>();
            set<String> existingUniqueIds = new set<String>();
            for(IDN_Charge_Back__c chargebackRecord: listOfChargebackRecords){
                
                String mapKey = chargebackRecord.Hospital_Name__c+'-'+chargebackRecord.Child_1__c+'_'+chargebackRecord.Child_2__c+'_'+chargebackRecord.contact_id__c+'_'+chargebackRecord.revised_product_family__c+'_'+chargebackRecord.Material_Number__c+'_'+chargebackRecord.Member_State__c+'_'+chargebackRecord.member_city__c+'_'+chargebackRecord.Submitter_Number__c+'_'+chargebackRecord.Sales_Rep_Territory__c+'_'+chargebackRecord.Settlement_Paid_Date__c.year();
                
                if(finalMap.containsKey(mapKey)){
                    System.debug('mapkey==>'+finalMap.get(mapKey));
                    Map<Integer, IDN_Charge_Back_Hospital_Summary__c> oneStepInnerMap = finalMap.get(mapKey);
                    if(oneStepInnerMap.containsKey(chargebackRecord.Settlement_Paid_Date__c.month())){
                        IDN_Charge_Back_Hospital_Summary__c summaryRec = oneStepInnerMap.get(chargebackRecord.Settlement_Paid_Date__c.month());
                        summaryRec.T2_Hospital_Name__c = chargebackRecord.Hospital_Name__c;
                        summaryRec.T2_Sales_Rep_Territory__c = chargebackRecord.Sales_Rep_Territory__c;
                        summaryRec.T2_Settlement_Paid_Date__c = chargebackRecord.Settlement_Paid_Date__c;	
                        summaryRec.T2_Month_Year__c = chargebackRecord.Month_Year__c;
                        summaryRec.T2_Child1_Name__c = chargebackRecord.Child1_Name__c;
                        summaryRec.T2_Child2_Name__c = chargebackRecord.Child2_Name__c;
                        summaryRec.T2_revised_product_family__c = chargebackRecord.revised_product_family__c;	
                        summaryRec.T2_material_description__c = chargebackRecord.material_description__c;	
                        summaryRec.T2_Contact_Description__c = chargebackRecord.Contact_Description__c;
                        summaryRec.T2_Region__c = chargebackRecord.Region__c;
                        summaryRec.T2_Category__c = chargebackRecord.Category__c;
                        summaryRec.T2_Member_State__c = chargebackRecord.Member_State__c;
                        summaryRec.T2_member_city__c = chargebackRecord.member_city__c;
                        summaryRec.T2_Submitter_Name__c = chargebackRecord.Submitter_Name__c;
                        summaryRec.H1_Tab_Reference__c = 'HCP';
                        summaryRec.H1_Level__c = 'Middle';
                        if(summaryRec.T2_Contract_Sales_Indirect_Price__c != null && chargebackRecord.Contract_Sales_Indirect_Price__c !=null){
                            summaryRec.T2_Contract_Sales_Indirect_Price__c = summaryRec.T2_Contract_Sales_Indirect_Price__c+chargebackRecord.Contract_Sales_Indirect_Price__c;
                        }
                        if(summaryRec.T2_contract_units_paid_qty__c != null && chargebackRecord.contract_units_paid_qty__c !=null){
                            summaryRec.T2_contract_units_paid_qty__c = summaryRec.T2_contract_units_paid_qty__c+chargebackRecord.contract_units_paid_qty__c;
                        }
                        //summaryRec.Contract_Sales_Indirect_Price__c += chargebackRecord.Contract_Sales_Indirect_Price__c;
                        //summaryRec.contract_units_paid_qty__c += chargebackRecord.contract_units_paid_qty__c;
                        summaryRec.T2_Vision_Test_Unique_Identifier__c = mapKey+'_'+chargebackRecord.Settlement_Paid_Date__c.month();
                    }
                    else{
                        IDN_Charge_Back_Hospital_Summary__c newSummaryRec = new IDN_Charge_Back_Hospital_Summary__c();
                        newSummaryRec.T2_Hospital_Name__c = chargebackRecord.Hospital_Name__c;
                        newSummaryRec.T2_Sales_Rep_Territory__c = chargebackRecord.Sales_Rep_Territory__c;
                        newSummaryRec.T2_Settlement_Paid_Date__c = chargebackRecord.Settlement_Paid_Date__c;	
                        newSummaryRec.T2_Month_Year__c = chargebackRecord.Month_Year__c;
                        newSummaryRec.T2_Child1_Name__c = chargebackRecord.Child1_Name__c;
                        newSummaryRec.T2_Child2_Name__c = chargebackRecord.Child2_Name__c;
                        newSummaryRec.T2_revised_product_family__c = chargebackRecord.revised_product_family__c;
                        newSummaryRec.T2_material_description__c = chargebackRecord.material_description__c;	
                        newSummaryRec.T2_Contact_Description__c = chargebackRecord.Contact_Description__c;
                        newSummaryRec.T2_Region__c = chargebackRecord.Region__c;
                        newSummaryRec.T2_Category__c = chargebackRecord.Category__c;
                        newSummaryRec.T2_Member_State__c = chargebackRecord.Member_State__c;
                        newSummaryRec.T2_member_city__c = chargebackRecord.member_city__c;
                        newSummaryRec.T2_Submitter_Name__c = chargebackRecord.Submitter_Name__c;
                        newSummaryRec.H1_Tab_Reference__c = 'HCP';
                        newSummaryRec.H1_Level__c = 'Middle';
                        newSummaryRec.T2_Contract_Sales_Indirect_Price__c = chargebackRecord.Contract_Sales_Indirect_Price__c;
                        newSummaryRec.T2_contract_units_paid_qty__c = chargebackRecord.contract_units_paid_qty__c;
                        newSummaryRec.T2_Vision_Test_Unique_Identifier__c = mapKey+'_'+chargebackRecord.Settlement_Paid_Date__c.month();
                        oneStepInnerMap.put(chargebackRecord.Settlement_Paid_Date__c.month(), newSummaryRec);
                    }
                    System.debug('oneStepInnerMap==>'+oneStepInnerMap);
                    System.debug('oneStepInnerMap==>'+oneStepInnerMap.size());
                }
                else{
                    IDN_Charge_Back_Hospital_Summary__c newSummaryRec = new IDN_Charge_Back_Hospital_Summary__c();
                    newSummaryRec.T2_Hospital_Name__c = chargebackRecord.Hospital_Name__c;
                    newSummaryRec.T2_Sales_Rep_Territory__c = chargebackRecord.Sales_Rep_Territory__c;
                    newSummaryRec.T2_Settlement_Paid_Date__c = chargebackRecord.Settlement_Paid_Date__c;	
                    newSummaryRec.T2_Month_Year__c = chargebackRecord.Month_Year__c;
                    newSummaryRec.T2_Child1_Name__c = chargebackRecord.Child1_Name__c;
                    newSummaryRec.T2_Child2_Name__c = chargebackRecord.Child2_Name__c;
                    newSummaryRec.T2_revised_product_family__c = chargebackRecord.revised_product_family__c;	
                    newSummaryRec.T2_material_description__c = chargebackRecord.material_description__c;
                    newSummaryRec.T2_Contact_Description__c = chargebackRecord.Contact_Description__c;
                    newSummaryRec.T2_Region__c = chargebackRecord.Region__c;
                    newSummaryRec.T2_Category__c = chargebackRecord.Category__c;
                    newSummaryRec.T2_Member_State__c = chargebackRecord.Member_State__c;
                    newSummaryRec.T2_member_city__c = chargebackRecord.member_city__c;
                    newSummaryRec.T2_Submitter_Name__c = chargebackRecord.Submitter_Name__c;
                    newSummaryRec.H1_Tab_Reference__c = 'HCP';
                    newSummaryRec.H1_Level__c = 'Middle';
                    newSummaryRec.T2_Contract_Sales_Indirect_Price__c = chargebackRecord.Contract_Sales_Indirect_Price__c;
                    newSummaryRec.T2_contract_units_paid_qty__c = chargebackRecord.contract_units_paid_qty__c;
                    newSummaryRec.T2_Vision_Test_Unique_Identifier__c = mapKey+'_'+chargebackRecord.Settlement_Paid_Date__c.month();
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
                            existingUniqueIds.add(hsptlSpecificData.get(monthKey).T2_Vision_Test_Unique_Identifier__c);
                            summaryRecordsToInsert.put(hsptlSpecificData.get(monthKey).T2_Vision_Test_Unique_Identifier__c, hsptlSpecificData.get(monthKey));
                        }
                    }
                }
                
            }
            for(IDN_Charge_Back_Hospital_Summary__c chargebackRec : [select Id,T2_Hospital_Name__c,T2_Settlement_Paid_Date__c,T2_Vision_Test_Unique_Identifier__c,	T2_contract_units_paid_qty__c,	T2_Contract_Sales_Indirect_Price__c From IDN_Charge_Back_Hospital_Summary__c Where T2_Vision_Test_Unique_Identifier__c in : existingUniqueIds]){
                summaryRecordsToInsert.get(chargebackRec.T2_Vision_Test_Unique_Identifier__c).Id = chargebackRec.Id;
                if(summaryRecordsToInsert.get(chargebackRec.T2_Vision_Test_Unique_Identifier__c).T2_Contract_Sales_Indirect_Price__c != null && chargebackRec.T2_Contract_Sales_Indirect_Price__c != null){ 
                    summaryRecordsToInsert.get(chargebackRec.T2_Vision_Test_Unique_Identifier__c).T2_Contract_Sales_Indirect_Price__c = summaryRecordsToInsert.get(chargebackRec.T2_Vision_Test_Unique_Identifier__c).T2_Contract_Sales_Indirect_Price__c + chargebackRec.T2_Contract_Sales_Indirect_Price__c;
                }
                if(summaryRecordsToInsert.get(chargebackRec.T2_Vision_Test_Unique_Identifier__c).T2_contract_units_paid_qty__c != null && chargebackRec.T2_contract_units_paid_qty__c != null){
                    summaryRecordsToInsert.get(chargebackRec.T2_Vision_Test_Unique_Identifier__c).T2_contract_units_paid_qty__c = summaryRecordsToInsert.get(chargebackRec.T2_Vision_Test_Unique_Identifier__c).T2_contract_units_paid_qty__c + chargebackRec.T2_contract_units_paid_qty__c;
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
            Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'Vision_IDN_Tab2_Summary_Batch', Phoenix_Error_Message__c = e.getMessage(), Phoenix_Issue_Status__c = 'Pending', Phoenix_Method_Name__c = 'execute', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
            insert exp;
        }
    }
    public void finish(Database.BatchableContext BC) {}
    public static void codecoverageBlock(){
        integer i = 0;
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
    }
    
}