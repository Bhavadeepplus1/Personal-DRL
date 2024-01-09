public class AchievementSummaryIndirectBatchCls implements Database.Batchable < sObject > , Database.Stateful,Schedulable,Database.AllowsCallouts{
	  public void execute(SchedulableContext sc) {
        //Database.executeBatch(new VisionInternalDRLSalesSummaryBatchCls());
    }
     public Database.QueryLocator start(Database.BatchableContext BC) {
         //delete [Select Id FROM Achievement_Summary_Table__c WHERE CreatedDate != Today LIMIT 10000];
        // String sales_Rep = 'Brenda Kern';
         //where  Sales_Rep_Territory__c=: sales_Rep
         String exclude ='N';
         String query = 'Select '+Phoenix_Util.getsObjectFieds('IDN_Charge_Back__c')+' from IDN_Charge_Back__c  WHERE 	Exclude_Flag__c =: exclude ORDER BY Settlement_Paid_Date__c ASC NULLS LAST';
        return Database.getQueryLocator(query);
     }
     public void execute(Database.BatchableContext BC, List < IDN_Charge_Back__c > indirectSalesData) {
           try{
               System.debug('indirectSalesData==>'+indirectSalesData.size());
               Map<String, Map<Integer, Achievement_Summary_Table__c>> finalMap = new Map<String, Map<Integer, Achievement_Summary_Table__c>>();
               Map<String, Achievement_Summary_Table__c> summaryRecordsToInsert = new  Map<String, Achievement_Summary_Table__c>();
               set<String> existingUniqueIds = new set<String>();
                Date billingDate ;
               for(IDN_Charge_Back__c indirectSalesRecord: indirectSalesData){
                  billingDate= date.valueOf(indirectSalesRecord.Settlement_Paid_Date__c);
                 String mapKey = indirectSalesRecord.Sales_Rep_Territory__c+'_'+billingDate.year();
                   if(finalMap.containsKey(mapKey)){
                         System.debug('in first if==>'+indirectSalesData.size());
                         Map<Integer, Achievement_Summary_Table__c> oneStepInnerMap = finalMap.get(mapKey);
                       if(oneStepInnerMap.containsKey(integer.valueof(billingDate.month()))){
                             System.debug('in oneStepInnerMap==>');
                         	Achievement_Summary_Table__c summaryRec = oneStepInnerMap.get(billingDate.month());
                           	Decimal indirectSales =indirectSalesRecord.Contract_Sales_Indirect_Price__c;
                           	summaryRec.Name = indirectSalesRecord.Name;
                           	summaryRec.Sales_Rep_Name__c = indirectSalesRecord.Sales_Rep_Territory__c != null ? indirectSalesRecord.Sales_Rep_Territory__c  : '';
                           	//summaryRec.Direct_Sales__c =  indirectSales;
                           	if(billingDate != null ) 	summaryRec.Indirect_Sales_Date__c = billingDate ;
                           	if(billingDate != null ) summaryRec.DateToConsider__c = billingDate;
                            if(summaryRec.Indirect_Sales__c != null && indirectSalesRecord.Contract_Sales_Indirect_Price__c !=null) summaryRec.Indirect_Sales__c = summaryRec.Indirect_Sales__c+indirectSalesRecord.Contract_Sales_Indirect_Price__c;
                        	summaryRec.Indirect__c = 'Indirect';
                            if(summaryRec.Sales_Rep_Name__c == 'Dave Smith' || summaryRec.Sales_Rep_Name__c == 'Nathan Cumme' || summaryRec.Sales_Rep_Name__c == 'Kristi Dodge' || summaryRec.Sales_Rep_Name__c == 'Angela Hattaway' || summaryRec.Sales_Rep_Name__c == 'Zachary McClard'||summaryRec.Sales_Rep_Name__c == 'Zack McClard' || summaryRec.Sales_Rep_Name__c == 'William Toupe' ||summaryRec.Sales_Rep_Name__c == 'Willi Toups'||  summaryRec.Sales_Rep_Name__c == 'Andre White'){
                             summaryRec.Region__c  = 'West';
                           }
                           if(summaryRec.Sales_Rep_Name__c == 'Eric Sutherland' || summaryRec.Sales_Rep_Name__c == 'Michael Alfino'|| summaryRec.Sales_Rep_Name__c == 'Mike Alfino' || summaryRec.Sales_Rep_Name__c == 'Erica Bass' || summaryRec.Sales_Rep_Name__c == 'Susan Belleavoine' || summaryRec.Sales_Rep_Name__c == 'Brenda Kern' || summaryRec.Sales_Rep_Name__c == 'Heather Harris' ||  summaryRec.Sales_Rep_Name__c == 'Doris Hartell'){
                             summaryRec.Region__c  = 'East';
                           }
                           if(summaryRec.Sales_Rep_Name__c == 'Dave Smith'){
                           		summaryRec.Employee_Id__c = 'P00075889';
                                summaryRec.Sales_Rep_Email_Id__c = 'dsmith@drreddys.com';
                            }
                           if(summaryRec.Sales_Rep_Name__c == 'Nathan Cumme'){
                           		summaryRec.Employee_Id__c = '';
                                summaryRec.Sales_Rep_Email_Id__c = 'ncumme@drreddys.com.invalid';
                            }
                           if(summaryRec.Sales_Rep_Name__c == 'Kristi Dodge'){
                           		summaryRec.Employee_Id__c = '';
                                summaryRec.Sales_Rep_Email_Id__c = 'kdodge@drreddys.com.invalid';
                            }
                             if(summaryRec.Sales_Rep_Name__c == 'Angela Hattaway'){
                           		 summaryRec.Employee_Id__c = 'P00084180';
                                 summaryRec.Sales_Rep_Email_Id__c = 'angela.hattaway@drreddys.com.invalid';
                            }
                            if( summaryRec.Sales_Rep_Name__c == 'Zachary McClard'||summaryRec.Sales_Rep_Name__c == 'Zack McClard'){
                           		summaryRec.Employee_Id__c = '';
                                summaryRec.Sales_Rep_Email_Id__c = 'zmcclard@drreddys.com';
                            }
                            if(summaryRec.Sales_Rep_Name__c == 'William Toupe' ||summaryRec.Sales_Rep_Name__c == 'Willi Toups'){
                           		summaryRec.Employee_Id__c = 'P00079113';
                                summaryRec.Sales_Rep_Email_Id__c = 'wtoups@drreddys.com.invalid';
                            }
                           
                           if(summaryRec.Sales_Rep_Name__c == 'Andre White'){
                               summaryRec.Employee_Id__c = '';
                               summaryRec.Sales_Rep_Email_Id__c = 'andre.white@drreddys.com';
                           }
                           if(summaryRec.Sales_Rep_Name__c == 'Eric Sutherland'){
                               summaryRec.Employee_Id__c = '';
                               summaryRec.Sales_Rep_Email_Id__c = 'esutherland@drreddys.com';
                           }
                           if(summaryRec.Sales_Rep_Name__c == 'Michael Alfino'|| summaryRec.Sales_Rep_Name__c == 'Mike Alfino'){
                               summaryRec.Employee_Id__c = '';
                               summaryRec.Sales_Rep_Email_Id__c = 'malfino@drreddys.com.invalid';
                           }
                           if(summaryRec.Sales_Rep_Name__c == 'Erica Bass'){
                              summaryRec.Employee_Id__c = 'P00080204'; 
                              summaryRec.Sales_Rep_Email_Id__c = 'ebass@drreddys.com.invalid';
                           }
                           if(summaryRec.Sales_Rep_Name__c == 'Susan Belleavoine'){
                              summaryRec.Employee_Id__c = 'P00082819'; 
                              summaryRec.Sales_Rep_Email_Id__c = 'sbelleavoine@drreddys.com.invalid';
                           }
                           if(summaryRec.Sales_Rep_Name__c == 'Brenda Kern'){
                              summaryRec.Employee_Id__c = ''; 
                              summaryRec.Sales_Rep_Email_Id__c = 'bkern@drreddys.com.invalid';
                           }
                           if(summaryRec.Sales_Rep_Name__c == 'Heather Harris'){
                              summaryRec.Employee_Id__c = ''; 
                              summaryRec.Sales_Rep_Email_Id__c = 'hharris@drreddys.com';
                               
                           }
                           if(summaryRec.Sales_Rep_Name__c == 'Doris Hartell'){
                           		summaryRec.Employee_Id__c = '';
                                summaryRec.Sales_Rep_Email_Id__c = 'dhartell@drreddys.com.invalid';
                            }
                           summaryRec.Unique_Identifier__c = mapKey+'_'+integer.valueof(billingDate.month());
						System.debug('map key in if=='+mapKey);
                           
                       }else{
                              System.debug('in oneStepInnerMap else==>');
                             Achievement_Summary_Table__c newSummaryRec = new Achievement_Summary_Table__c();
                           	Decimal indirectSales = indirectSalesRecord.Contract_Sales_Indirect_Price__c != null ? indirectSalesRecord.Contract_Sales_Indirect_Price__c : 0;
                           	newSummaryRec.Name = indirectSalesRecord.Name;
                           	newSummaryRec.Sales_Rep_Name__c = indirectSalesRecord.Sales_Rep_Territory__c != null ? indirectSalesRecord.Sales_Rep_Territory__c : '';
                           	newSummaryRec.Indirect_Sales__c =  indirectSales;
                           	if(billingDate != null)newSummaryRec.Indirect_Sales_Date__c = billingDate ;
                           	if(billingDate != null ) newSummaryRec.DateToConsider__c = billingDate;
                          	newSummaryRec.Indirect__c = 'Indirect';
                           if(newSummaryRec.Sales_Rep_Name__c == 'Dave Smith' || newSummaryRec.Sales_Rep_Name__c == 'Nathan Cumme' || newSummaryRec.Sales_Rep_Name__c == 'Kristi Dodge' || newSummaryRec.Sales_Rep_Name__c == 'Angela Hattaway' || newSummaryRec.Sales_Rep_Name__c == 'Zachary McClard'||newSummaryRec.Sales_Rep_Name__c == 'Zack McClard' || newSummaryRec.Sales_Rep_Name__c == 'William Toupe' ||newSummaryRec.Sales_Rep_Name__c == 'Willi Toups'||  newSummaryRec.Sales_Rep_Name__c == 'Andre White'){
                               newSummaryRec.Region__c  = 'West';
                           }
                           if(newSummaryRec.Sales_Rep_Name__c == 'Eric Sutherland' || newSummaryRec.Sales_Rep_Name__c == 'Michael Alfino'|| newSummaryRec.Sales_Rep_Name__c == 'Mike Alfino' || newSummaryRec.Sales_Rep_Name__c == 'Erica Bass' || newSummaryRec.Sales_Rep_Name__c == 'Susan Belleavoine' || newSummaryRec.Sales_Rep_Name__c == 'Brenda Kern' || newSummaryRec.Sales_Rep_Name__c == 'Heather Harris' ||  newSummaryRec.Sales_Rep_Name__c == 'Doris Hartell'){
                               newSummaryRec.Region__c  = 'East';
                           }  
                           if(newSummaryRec.Sales_Rep_Name__c == 'Dave Smith'){
                           		newSummaryRec.Employee_Id__c = 'P00075889';
                               	newSummaryRec.Sales_Rep_Email_Id__c = 'dsmith@drreddys.com';
                            }
                           if(newSummaryRec.Sales_Rep_Name__c == 'Nathan Cumme'){
                           		newSummaryRec.Employee_Id__c = '';
                               	newSummaryRec.Sales_Rep_Email_Id__c = 'ncumme@drreddys.com.invalid';
                            }
                           if(newSummaryRec.Sales_Rep_Name__c == 'Kristi Dodge'){
                           		newSummaryRec.Employee_Id__c = '';
                               newSummaryRec.Sales_Rep_Email_Id__c = 'kdodge@drreddys.com.invalid';
                            }
                             if(newSummaryRec.Sales_Rep_Name__c == 'Angela Hattaway'){
                           		newSummaryRec.Employee_Id__c = 'P00084180';
                                 newSummaryRec.Sales_Rep_Email_Id__c = 'angela.hattaway@drreddys.com.invalid';
                            }
                            if( newSummaryRec.Sales_Rep_Name__c == 'Zachary McClard'||newSummaryRec.Sales_Rep_Name__c == 'Zack McClard'){
                           		newSummaryRec.Employee_Id__c = '';
                                newSummaryRec.Sales_Rep_Email_Id__c = 'zmcclard@drreddys.com';
                            }
                            if(newSummaryRec.Sales_Rep_Name__c == 'William Toupe' ||newSummaryRec.Sales_Rep_Name__c == 'Willi Toups'){
                           		newSummaryRec.Employee_Id__c = 'P00079113';
                                newSummaryRec.Sales_Rep_Email_Id__c = 'wtoups@drreddys.com.invalid';
                            }
                           
                           if(newSummaryRec.Sales_Rep_Name__c == 'Andre White'){
                               newSummaryRec.Employee_Id__c = '';
                               newSummaryRec.Sales_Rep_Email_Id__c = 'andre.white@drreddys.com';
                           }
                           if(newSummaryRec.Sales_Rep_Name__c == 'Eric Sutherland'){
                               newSummaryRec.Employee_Id__c = '';
                               newSummaryRec.Sales_Rep_Email_Id__c = 'esutherland@drreddys.com';
                           }
                           if(newSummaryRec.Sales_Rep_Name__c == 'Michael Alfino'|| newSummaryRec.Sales_Rep_Name__c == 'Mike Alfino'){
                               newSummaryRec.Employee_Id__c = '';
                               newSummaryRec.Sales_Rep_Email_Id__c = 'malfino@drreddys.com.invalid';
                           }
                           if(newSummaryRec.Sales_Rep_Name__c == 'Erica Bass'){
                              newSummaryRec.Employee_Id__c = 'P00080204'; 
                               newSummaryRec.Sales_Rep_Email_Id__c = 'ebass@drreddys.com.invalid';
                           }
                           if(newSummaryRec.Sales_Rep_Name__c == 'Susan Belleavoine'){
                              newSummaryRec.Employee_Id__c = 'P00082819'; 
                              newSummaryRec.Sales_Rep_Email_Id__c = 'sbelleavoine@drreddys.com.invalid';
                           }
                           if(newSummaryRec.Sales_Rep_Name__c == 'Brenda Kern'){
                              newSummaryRec.Employee_Id__c = ''; 
                              newSummaryRec.Sales_Rep_Email_Id__c = 'bkern@drreddys.com.invalid';
                           }
                           if(newSummaryRec.Sales_Rep_Name__c == 'Heather Harris'){
                              newSummaryRec.Employee_Id__c = ''; 
                              newSummaryRec.Sales_Rep_Email_Id__c = 'hharris@drreddys.com';
                           }
                           if(newSummaryRec.Sales_Rep_Name__c == 'Doris Hartell'){
                           		newSummaryRec.Employee_Id__c = '';
                                newSummaryRec.Sales_Rep_Email_Id__c = 'dhartell@drreddys.com.invalid';
                            }
                           newSummaryRec.Unique_Identifier__c = mapKey+'_'+integer.valueof(billingDate.month());
                        	oneStepInnerMap.put(integer.valueof(billingDate.month()), newSummaryRec);

                       }
                       
                   }
                   else{
                       Achievement_Summary_Table__c newSummaryRec = new Achievement_Summary_Table__c();
                       Decimal indirectSales = indirectSalesRecord.Contract_Sales_Indirect_Price__c != null ? indirectSalesRecord.Contract_Sales_Indirect_Price__c : 0;
                       newSummaryRec.Name = indirectSalesRecord.Name;
                       newSummaryRec.Sales_Rep_Name__c = indirectSalesRecord.Sales_Rep_Territory__c != null ?indirectSalesRecord.Sales_Rep_Territory__c :'';
                       newSummaryRec.Indirect_Sales__c =  indirectSales;
                       if(billingDate != null) newSummaryRec.Indirect_Sales_Date__c = billingDate ;
                       if(billingDate != null ) newSummaryRec.DateToConsider__c = billingDate;
                       newSummaryRec.Indirect__c = 'Indirect';
                        if(newSummaryRec.Sales_Rep_Name__c == 'Dave Smith' || newSummaryRec.Sales_Rep_Name__c == 'Nathan Cumme' || newSummaryRec.Sales_Rep_Name__c == 'Kristi Dodge' || newSummaryRec.Sales_Rep_Name__c == 'Angela Hattaway' || newSummaryRec.Sales_Rep_Name__c == 'Zachary McClard'||newSummaryRec.Sales_Rep_Name__c == 'Zack McClard' || newSummaryRec.Sales_Rep_Name__c == 'William Toupe' ||newSummaryRec.Sales_Rep_Name__c == 'Willi Toups'||  newSummaryRec.Sales_Rep_Name__c == 'Andre White'){
                           newSummaryRec.Region__c  = 'West';
                       }
                       if(newSummaryRec.Sales_Rep_Name__c == 'Eric Sutherland' || newSummaryRec.Sales_Rep_Name__c == 'Michael Alfino'|| newSummaryRec.Sales_Rep_Name__c == 'Mike Alfino' || newSummaryRec.Sales_Rep_Name__c == 'Erica Bass' || newSummaryRec.Sales_Rep_Name__c == 'Susan Belleavoine' || newSummaryRec.Sales_Rep_Name__c == 'Brenda Kern' || newSummaryRec.Sales_Rep_Name__c == 'Heather Harris' ||  newSummaryRec.Sales_Rep_Name__c == 'Doris Hartell'){
                           newSummaryRec.Region__c  = 'East';
                       }
                       if(newSummaryRec.Sales_Rep_Name__c == 'Dave Smith'){
                           		newSummaryRec.Employee_Id__c = 'P00075889';
                           		newSummaryRec.Sales_Rep_Email_Id__c = 'dsmith@drreddys.com';
                            }
                           if(newSummaryRec.Sales_Rep_Name__c == 'Nathan Cumme'){
                           		newSummaryRec.Employee_Id__c = '';
                                newSummaryRec.Sales_Rep_Email_Id__c = 'ncumme@drreddys.com.invalid';
                            }
                           if(newSummaryRec.Sales_Rep_Name__c == 'Kristi Dodge'){
                           		newSummaryRec.Employee_Id__c = '';
                                newSummaryRec.Sales_Rep_Email_Id__c = 'kdodge@drreddys.com.invalid';
                            }
                             if(newSummaryRec.Sales_Rep_Name__c == 'Angela Hattaway'){
                           		newSummaryRec.Employee_Id__c = 'P00084180';
                                newSummaryRec.Sales_Rep_Email_Id__c = 'angela.hattaway@drreddys.com.invalid';
                            }
                            if( newSummaryRec.Sales_Rep_Name__c == 'Zachary McClard'||newSummaryRec.Sales_Rep_Name__c == 'Zack McClard'){
                           		newSummaryRec.Employee_Id__c = '';
                                newSummaryRec.Sales_Rep_Email_Id__c = 'zmcclard@drreddys.com';
                            }
                            if(newSummaryRec.Sales_Rep_Name__c == 'William Toupe' ||newSummaryRec.Sales_Rep_Name__c == 'Willi Toups'){
                           		newSummaryRec.Employee_Id__c = 'P00079113';
                                newSummaryRec.Sales_Rep_Email_Id__c = 'wtoups@drreddys.com.invalid';
                            }
                           
                           if(newSummaryRec.Sales_Rep_Name__c == 'Andre White'){
                               newSummaryRec.Employee_Id__c = '';
                               newSummaryRec.Sales_Rep_Email_Id__c = 'andre.white@drreddys.com';
                           }
                           if(newSummaryRec.Sales_Rep_Name__c == 'Eric Sutherland'){
                               newSummaryRec.Employee_Id__c = '';
                               newSummaryRec.Sales_Rep_Email_Id__c = 'esutherland@drreddys.com';
                           }
                           if(newSummaryRec.Sales_Rep_Name__c == 'Michael Alfino'|| newSummaryRec.Sales_Rep_Name__c == 'Mike Alfino'){
                               newSummaryRec.Employee_Id__c = '';
                               newSummaryRec.Sales_Rep_Email_Id__c = 'malfino@drreddys.com.invalid';
                           }
                           if(newSummaryRec.Sales_Rep_Name__c == 'Erica Bass'){
                               newSummaryRec.Employee_Id__c = 'P00080204'; 
                               newSummaryRec.Sales_Rep_Email_Id__c = 'ebass@drreddys.com.invalid';
                           }
                           if(newSummaryRec.Sales_Rep_Name__c == 'Susan Belleavoine'){
                              newSummaryRec.Employee_Id__c = 'P00082819';
                              newSummaryRec.Sales_Rep_Email_Id__c = 'sbelleavoine@drreddys.com.invalid';
                           }
                           if(newSummaryRec.Sales_Rep_Name__c == 'Brenda Kern'){
                              newSummaryRec.Employee_Id__c = '';
                              newSummaryRec.Sales_Rep_Email_Id__c = 'bkern@drreddys.com.invalid';
                           }
                           if(newSummaryRec.Sales_Rep_Name__c == 'Heather Harris'){
                              newSummaryRec.Employee_Id__c = ''; 
                              newSummaryRec.Sales_Rep_Email_Id__c = 'hharris@drreddys.com';
                              
                           }
                           if(newSummaryRec.Sales_Rep_Name__c == 'Doris Hartell'){
                           		newSummaryRec.Employee_Id__c = '';
                                newSummaryRec.Sales_Rep_Email_Id__c = 'dhartell@drreddys.com.invalid'; 
                            }
                       newSummaryRec.Unique_Identifier__c = mapKey+'_'+billingDate.month();
                      Map<Integer, Achievement_Summary_Table__c> oneStepInnerMap = new Map<Integer, Achievement_Summary_Table__c>();
                       oneStepInnerMap.put(integer.valueof(billingDate.month()), newSummaryRec);
                       finalMap.put(mapKey, oneStepInnerMap);
                  
                   }
                   System.debug('final map size==>'+finalMap.size());
                   if(finalMap.size() > 0){
                           for(String singleKey: finalMap.keySet()){
                               Map<Integer, Achievement_Summary_Table__c> specificData = finalMap.get(singleKey);
                               for(Integer monthKey: specificData.keySet()){
                                   existingUniqueIds.add(specificData.get(monthKey).Unique_Identifier__c);
                                   summaryRecordsToInsert.put(specificData.get(monthKey).Unique_Identifier__c, specificData.get(monthKey));
                               }
                           }
                       }
               }
               for(Achievement_Summary_Table__c directSalesRec : [select Id,Indirect_Sales__c,Direct_Sales__c,Direct_Sales_Billing_Date__c,Sales_Rep_Name__c,	Unique_Identifier__c From Achievement_Summary_Table__c Where 	Unique_Identifier__c in : existingUniqueIds]){
                summaryRecordsToInsert.get(directSalesRec.Unique_Identifier__c).Id = directSalesRec.Id;
                if(summaryRecordsToInsert.get(directSalesRec.Unique_Identifier__c).Indirect_Sales__c != null && directSalesRec.Indirect_Sales__c != null) summaryRecordsToInsert.get(directSalesRec.Unique_Identifier__c).Indirect_Sales__c = summaryRecordsToInsert.get(directSalesRec.Unique_Identifier__c).Indirect_Sales__c + directSalesRec.Indirect_Sales__c;
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