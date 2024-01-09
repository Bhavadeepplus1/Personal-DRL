public class ComplainceRecordsNprData implements Database.Batchable < sObject > ,Schedulable{
     public void execute(SchedulableContext sc) {
        Database.executeBatch(new ComplainceRecordsNprData());
    }
    public Database.QueryLocator start(Database.BatchableContext BC) {
        //Date today = System.today();
        // String month = String.valueOf(today.Month()).length() == 2 ? String.valueOf(today.addMonths(1).Month()) : '0' + today.addMonths(1).Month();
        // date StartDate = date.newInstance(today.addYears(-1).Year(), Integer.valueOf(month), 01);
        //date EndDate = date.newInstance(today.Year(), today.Month(), today.Day());
        delete[select id from Compliance_Data__c  where createddate!=today limit 10000];
        string status='Active';
         string id='0011K00002RDd6lQAD';
        String query = 'select Id,Phoenix_NPR_Data__r.Phoenix_Contract_Number__c,Phoenix_NPR_Data__r.Phoenix_Material_Number__c,Phoenix_NPR_Data__r.Phoenix_Contract_Type__c,Phoenix_NPR_Data__r.Phoenix_12Mt_Sales_Ut_Actual__c,Phoenix_NPR_Data__r.Phoenix_Product__r.ProductCode,Phoenix_NPR_Data__r.Phoenix_Product__r.Phoenix_NDC_11__c,Phoenix_NPR_Data__r.Phoenix_Product__r.Phoenix_NDC__c,Phoenix_NPR_Data__r.Phoenix_12Months_Actual_Sales_Unit__c,Phoenix_NPR_Data__r.Phoenix_Account__r.Accountnumber,Phoenix_NPR_Data__r.Phoenix_Account__c,Phoenix_NPR_Data__r.Phoenix_Contract__c,Phoenix_NPR_Data__r.Phoenix_Product__c,Phoenix_Month__c,Phoenix_Volume__c  from Phoenix_NPR_Volume__c WHERE Phoenix_NPR_Data__r.Phoenix_NPR_Status__c=:status';
        if(Test.isRunningTest())query += ' LIMIT 1';
        return Database.getQueryLocator(query);
    }
    public void execute(Database.BatchableContext BC, List < Phoenix_NPR_Volume__c> nprdatalist) {
        if(nprdatalist.size()> 0){
            try{
                DateTime dt1 = DateTime.now();
                DateTime dt2 = DateTime.now().addmonths(-1);
                DateTime dt3 = DateTime.now().addmonths(-2);
                DateTime dt4 = DateTime.now().addmonths(-3);
                DateTime dt5 = DateTime.now().addmonths(-4);
                DateTime dt6 = DateTime.now().addmonths(-5);
                DateTime dt7 = DateTime.now().addmonths(-6);
                DateTime dt8 = DateTime.now().addmonths(-7);
                DateTime dt9 = DateTime.now().addmonths(-8);
                DateTime dt10 = DateTime.now().addmonths(-9);
                 DateTime dt11 = DateTime.now().addmonths(-10);
                 DateTime dt12 = DateTime.now().addmonths(-11);
              //  system.debug('dt8...'+dt8);
                
                Integer y1 = dt1.year();
                String yr1 = String.valueOf(y1);
                Integer y2 = dt2.year();
                String yr2 = String.valueOf(y2);
                Integer y3 = dt3.year();
                String yr3 = String.valueOf(y3);
                Integer y4 = dt4.year();
                String yr4 = String.valueOf(y4);
                Integer y5 = dt5.year();
                String yr5 = String.valueOf(y5);
                Integer y6 = dt6.year();
                String yr6 = String.valueOf(y6);
                Integer y7 = dt7.year();
                String yr7 = String.valueOf(y7);
                Integer y8 = dt8.year();
                String yr8 = String.valueOf(y8);
                Integer y9 = dt9.year();
                String yr9 = String.valueOf(y9);
                Integer y10 = dt10.year();
                String yr10 = String.valueOf(y10);
                   Integer y11 = dt11.year();
                String yr11 = String.valueOf(y11);
                Integer y12 = dt12.year();
                String yr12 = String.valueOf(y12);
                
                
                
                //  Integer m = dt.month();
                // Integer d = dt.day();
                string M1=dt1.format('MMM')+'-'+yr1.substring(2);
                string M2=dt2.format('MMM')+'-'+yr2.substring(2);
                string M3=dt3.format('MMM')+'-'+yr3.substring(2);
                string M4=dt4.format('MMM')+'-'+yr4.substring(2);
                string M5=dt5.format('MMM')+'-'+yr5.substring(2);
                string M6=dt6.format('MMM')+'-'+yr6.substring(2);
                string M7=dt7.format('MMM')+'-'+yr7.substring(2);
                string M8=dt8.format('MMM')+'-'+yr8.substring(2);
                string M9=dt9.format('MMM')+'-'+yr9.substring(2);
                string M10= dt10.format('MMM')+'-'+yr10.substring(2);
                   string M11= dt11.format('MMM')+'-'+yr11.substring(2);
                
                   string M12= dt12.format('MMM')+'-'+yr12.substring(2);
                
                
                //System.debug(dt.format('MMM')+'-'+yr.substring(2));
                /* String M1 = String.valueOf(today.Month()).length() == 2 ? String.valueOf(today.Month()) : string.valueof(today.Month());
String M2 = String.valueOf(today.addMonths(-1).Month()).length() == 2 ? String.valueOf(today.addMonths(-1).Month()) : string.valueof( today.addMonths(-1).Month());
String M3 = String.valueOf(today.addMonths(-2).Month()).length() == 2 ? String.valueOf(today.addMonths(-2).Month()) : string.valueof( today.addMonths(-2).Month());
String M4 = String.valueOf(today.addMonths(-3).Month()).length() == 2 ? String.valueOf(today.addMonths(-3).Month()) : string.valueof( today.addMonths(-3).Month());
String M5 = String.valueOf(today.addMonths(-4).Month()).length() == 2 ? String.valueOf(today.addMonths(-4).Month()) : string.valueof( today.addMonths(-4).Month());
String M6 = String.valueOf(today.addMonths(-5).Month()).length() == 2 ? String.valueOf(today.addMonths(-5).Month()) : string.valueof( today.addMonths(-5).Month());
String M7 = String.valueOf(today.addMonths(-6).Month()).length() == 2 ? String.valueOf(today.addMonths(-6).Month()) :string.valueof( today.addMonths(-6).Month());
String M8 = String.valueOf(today.addMonths(-7).Month()).length() == 2 ? String.valueOf(today.addMonths(-7).Month()) :string.valueof( today.addMonths(-7).Month());
String M9 = String.valueOf(today.addMonths(-7).Month()).length() == 2 ? String.valueOf(today.addMonths(-8).Month()) :string.valueof( today.addMonths(-8).Month());*/
                // list<Phoenix_NPR_Volume__c> nprvollist= new list<Phoenix_NPR_Volume__c>();
                //for(Phoenix_NPR_Data__c npr :nprdatalist){
                // for(Phoenix_NPR_Volume__c nprvol:npr.NPR_Volumes__r ){
                //  nprvollist.add(nprvol);
                //}
                //}
                set<String> UniqueIds = new set<String>();
                
                Map<String,Map<String,String>> SummaryMap = new Map<String,Map<String,String>>();
                string uniqueid='';
                for(Phoenix_NPR_Volume__c item:nprdatalist){
                    
                    if(item.Phoenix_NPR_Data__r.Phoenix_Contract_Number__c!=null && item.Phoenix_NPR_Data__r.Phoenix_Material_Number__c!=null && item.Phoenix_Month__c!=null){
                        UniqueId=item.Phoenix_NPR_Data__r.Phoenix_Contract_Number__c+'-'+item.Phoenix_NPR_Data__r.Phoenix_Material_Number__c+'_'+item.Phoenix_Month__c;
                        UniqueIds.add(item.Phoenix_NPR_Data__r.Phoenix_Contract_Number__c+'-'+item.Phoenix_NPR_Data__r.Phoenix_Material_Number__c);
                        
                        if(SummaryMap.containskey(UniqueId)){
                            Map<String,String> oneStepInnerMap = SummaryMap.get(uniqueId);
                            if(item.Phoenix_NPR_Data__r.Phoenix_Contract_Type__c!=null)
                                onestepinnermap.put('contracttype',string.valueof(item.Phoenix_NPR_Data__r.Phoenix_Contract_Type__c));
                            if(item.Phoenix_NPR_Data__r.Phoenix_12Months_Actual_Sales_Unit__c!=null)
                                onestepinnermap.put('Actuals',string.valueof(item.Phoenix_NPR_Data__r.Phoenix_12Months_Actual_Sales_Unit__c));
                            if(item.Phoenix_NPR_Data__r.Phoenix_Account__c!=null)
                                onestepinnermap.put('Account',string.valueof(item.Phoenix_NPR_Data__r.Phoenix_Account__c));
                            if(item.Phoenix_NPR_Data__r.Phoenix_Account__r.AccountNumber!=null)
                                onestepinnermap.put('AccountNumber',string.valueof(item.Phoenix_NPR_Data__r.Phoenix_Account__r.AccountNumber));
                            if(item.Phoenix_NPR_Data__r.Phoenix_Product__c!=null)
                                onestepinnermap.put('product',string.valueof(item.Phoenix_NPR_Data__r.Phoenix_Product__c));
                            if(item.Phoenix_NPR_Data__r.Phoenix_Product__r.ProductCode!=null)
                                onestepinnermap.put('productcode',string.valueof(item.Phoenix_NPR_Data__r.Phoenix_Product__r.ProductCode));
                         
                            if(item.Phoenix_NPR_Data__r.Phoenix_Contract_Number__c!=null)
                                onestepinnermap.put('contractnumber',string.valueof(item.Phoenix_NPR_Data__r.Phoenix_Contract_Number__c));
                            if(item.Phoenix_NPR_Data__r.Phoenix_Contract__c!=null)
                                onestepinnermap.put('contract',string.valueof(item.Phoenix_NPR_Data__r.Phoenix_Contract__c));
                            if(item.Phoenix_NPR_Data__c!=null)
                                onestepinnermap.put('npr',string.valueof(item.Phoenix_NPR_Data__c));
                            
                            if(item.Phoenix_Month__c!=null){
                                onestepinnermap.put('month',item.Phoenix_Month__c);
                               }
                            if(item.Phoenix_Volume__c!=null)
                                onestepinnermap.put('volume',string.valueof(item.Phoenix_Volume__c));
                            
                        }
                        else{
                            map<string,string> onestepinnermap = new  map<string,string>();
                            if(item.Phoenix_NPR_Data__r.Phoenix_Contract_Type__c!=null)
                                onestepinnermap.put('contracttype',string.valueof(item.Phoenix_NPR_Data__r.Phoenix_Contract_Type__c));
                            if(item.Phoenix_NPR_Data__r.Phoenix_12Months_Actual_Sales_Unit__c!=null)
                                onestepinnermap.put('Actuals',string.valueof(item.Phoenix_NPR_Data__r.Phoenix_12Months_Actual_Sales_Unit__c));
                            if(item.Phoenix_NPR_Data__r.Phoenix_Account__c!=null)
                                onestepinnermap.put('Account',string.valueof(item.Phoenix_NPR_Data__r.Phoenix_Account__c));
                            if(item.Phoenix_NPR_Data__r.Phoenix_Account__r.AccountNumber!=null)
                                onestepinnermap.put('AccountNumber',string.valueof(item.Phoenix_NPR_Data__r.Phoenix_Account__r.AccountNumber));
                            if(item.Phoenix_NPR_Data__r.Phoenix_Product__c!=null)
                                onestepinnermap.put('product',string.valueof(item.Phoenix_NPR_Data__r.Phoenix_Product__c));
                            if(item.Phoenix_NPR_Data__r.Phoenix_Product__r.ProductCode!=null)
                                onestepinnermap.put('productcode',string.valueof(item.Phoenix_NPR_Data__r.Phoenix_Product__r.ProductCode));
                           
                            if(item.Phoenix_NPR_Data__r.Phoenix_Contract_Number__c!=null)
                                onestepinnermap.put('contractnumber',string.valueof(item.Phoenix_NPR_Data__r.Phoenix_Contract_Number__c));
                            if(item.Phoenix_NPR_Data__r.Phoenix_Contract__c!=null)
                                onestepinnermap.put('contract',string.valueof(item.Phoenix_NPR_Data__r.Phoenix_Contract__c));
                            if(item.Phoenix_NPR_Data__c!=null)
                                onestepinnermap.put('npr',string.valueof(item.Phoenix_NPR_Data__c));
                            
                            if(item.Phoenix_Month__c!=null){
                                onestepinnermap.put('month',item.Phoenix_Month__c);
                              }
                            if(item.Phoenix_Volume__c!=null)
                                onestepinnermap.put('volume',string.valueof(item.Phoenix_Volume__c));
                            summarymap.put(UniqueId,onestepinnermap);
                        }
                        
                        
                    }
                    
                }
                set<string> uniue2=new  set<string>();
                for(string s:summarymap.keyset()){
                    string internalkey= s.split('_')[0];
                    uniue2.add(internalkey);
                    
                  //  system.debug('summarymapvalue..'+s+'...'+summarymap.get(s));
                    
                }
                
                
                Map<String,Compliance_Data__c> complianceSummaryMap = new Map<String,Compliance_Data__c>();
                map<String,Id> existingBackOrderRXMap =new Map<String,Id>();
                for( Vision_GCP_Backorder_OTC__c  backOrderRx : [select id,Vision_Sku_Code__c,Vision_Backorder_Report_Date__c From Vision_GCP_Backorder_OTC__c where Vision_Sku_Code__c != null ]){
                    if(!existingBackOrderRXMap.containskey(backOrderRx.Vision_Sku_Code__c ))
                        existingBackOrderRXMap.put(backOrderRx.Vision_Sku_Code__c ,backOrderRx.Id);
                    
                }
                map<String,Vision_GCP_Backorder_SRx_Rx__c> existingBackOrderSRXMap =new Map<String,Vision_GCP_Backorder_SRx_Rx__c>();
                for( Vision_GCP_Backorder_SRx_Rx__c backOrderSRx : [select id,Vision_Sku_Code__c,Vision_MoH__c,Vision_On_Backorder__c From Vision_GCP_Backorder_SRx_Rx__c where Vision_Sku_Code__c != null ]){
                    if(!existingBackOrderSRXMap.containskey(backOrderSRx.Vision_Sku_Code__c))
                        existingBackOrderSRXMap.put(backOrderSRx.Vision_Sku_Code__c ,backOrderSRx);
                }
                Map<String,list<Compliance_Data__c>> complianceSummaryMapkey = new Map<String,list<Compliance_Data__c>>();
                Map<string,Vision_Customer_Product_Tracker__c> existingCustomerProductTrackerRecs = new Map<string,Vision_Customer_Product_Tracker__c>();
                for(Vision_Customer_Product_Tracker__c cpt:[SELECT ID,Vision_Internal_Unique_Identifier__c,Vision_Price_Effective_Date__c,Compliance_Unique_Identifier__c,General_Category__c,Vision_Awarded_Value__c,Vision_Awarded_Volume__c,Vision_Current_Product_Position__c FROM Vision_Customer_Product_Tracker__c where  Vision_Is_In_Awarded__c = true and Compliance_Unique_Identifier__c IN:UniqueIds]){
                    existingCustomerProductTrackerRecs.put(cpt.Compliance_Unique_Identifier__c ,cpt);
                }
                Map<string,Compliance_Data__c> existingComplianerecsMap = new Map<string,Compliance_Data__c>();
                Map<string,Compliance_Data__c> existingComplianerecsMapkey = new Map<string,Compliance_Data__c>();
                String query = 'Select '+Phoenix_Util.getsObjectFieds('Compliance_Data__c')+' from Compliance_Data__c where Vision_Unique_Identifier__c IN:UniqueIds';
                for(Compliance_Data__c existingRec : database.query(query)){
                    existingComplianerecsMap.put(existingRec.Vision_Unique_Identifier__c,existingRec);
                }
                
                for(String key:SummaryMap.keySet()){
                    string internalkey1= key.split('_')[0];
                    if(!existingComplianerecsMap.containskey(internalkey1)){
                        Compliance_Data__c newrec = complianceSummaryMap.containsKey(internalkey1) ? complianceSummaryMap.get(internalkey1) : new Compliance_Data__c();
                        
                        if(existingCustomerProductTrackerRecs.containsKey(internalkey1)) {
                            if(existingCustomerProductTrackerRecs.get(internalkey1).Vision_Awarded_Volume__c != null){
                                
                                   // system.debug('entered loooop.... conditiii');
                                    newrec.Awarded_Information__c = existingCustomerProductTrackerRecs.get(internalkey1).Vision_Awarded_Volume__c;
                                
                            }
                            if(existingCustomerProductTrackerRecs.get(internalkey1).General_Category__c != null) {
                                newrec.General_Category__c=existingCustomerProductTrackerRecs.get(internalkey1).General_Category__c;
                            }
                              if(existingCustomerProductTrackerRecs.get(internalkey1).Vision_Current_Product_Position__c != null) {
                                newrec.Product_Position__c=existingCustomerProductTrackerRecs.get(internalkey1).Vision_Current_Product_Position__c;
                            }
                            if(existingCustomerProductTrackerRecs.get(internalKey1).Vision_Price_Effective_Date__c != null){
                  
                            newrec.Price_Effective_Date__c = existingCustomerProductTrackerRecs.get(internalKey1).Vision_Price_Effective_Date__c;
                        
                         }
                            
                            
                        }
                        if(summarymap.get(key).containskey('month')){
                            
                            string monthdts=summarymap.get(key).get('month');
                          //  system.debug('key....'+key);
                           // system.debug('months'+monthdts);
                          //  system.debug('m1...'+m1);
                           // system.debug('m2...'+m2);
                           // system.debug('m3..'+m3);
                           // system.debug('m4..'+m4);
                           // system.debug('m5..'+m5);
                            
                            if(m1 == monthdts){
                                newrec.Month1__c=monthdts;
                                newrec.M1_Quantity__c=decimal.valueof(summarymap.get(key).get('volume'));
                            }
                            else if(m2 == monthdts){
                                newrec.Month2__c=monthdts;
                                newrec.M2_Quantity__c=decimal.valueof(summarymap.get(key).get('volume'));
                            }
                            else if(m3 == monthdts){
                                newrec.Month3__c=monthdts;
                                newrec.M3_Quantity__c=decimal.valueof(summarymap.get(key).get('volume'));
                            }
                            else if(m4 == monthdts){
                                newrec.Month4__c=monthdts;
                                newrec.M4_Quantity__c=decimal.valueof(summarymap.get(key).get('volume'));
                            }
                            else if(m5==monthdts){
                                newrec.Month5__c=monthdts;
                                newrec.M5_Quantity__c=decimal.valueof(summarymap.get(key).get('volume'));
                            }
                            else if(m6 == monthdts){
                                newrec.Month6__c=monthdts;
                                newrec.M6_Quantity__c=decimal.valueof(summarymap.get(key).get('volume'));
                            }
                            else if(m7 == monthdts){
                                newrec.Month7__c=monthdts;
                                newrec.M7_Quantity__c=decimal.valueof(summarymap.get(key).get('volume'));
                            }
                            else if(m8 == monthdts){
                                newrec.Month8__c=monthdts;
                                newrec.M8_Quantity__c=decimal.valueof(summarymap.get(key).get('volume'));
                            }
                            else if(m9 == monthdts){
                                newrec.Month9__c=monthdts;
                                newrec.M9_Quantity__c=decimal.valueof(summarymap.get(key).get('volume'));
                            }
                            else if(m10 == monthdts){
                                newrec.Month10__c=monthdts;
                                newrec.M10_Quantity__c=decimal.valueof(summarymap.get(key).get('volume'));
                            }
                              else if(m11 == monthdts){
                                newrec.Month11__c=monthdts;
                                newrec.M11_Quantity__c=decimal.valueof(summarymap.get(key).get('volume'));
                            }
                              else if(m12 == monthdts){
                                newrec.Month12__c=monthdts;
                                newrec.M12_Quantity__c=decimal.valueof(summarymap.get(key).get('volume'));
                            }
                            
                            
                            newrec.Vision_Customer__c= summarymap.get(key).get('Account'); 
                            newrec.Vision_Product__c= summarymap.get(key).get('product');
                            newrec.Vision_Contract__c=summarymap.get(key).get('contract');
                            newrec.Contract_Type__c=summarymap.get(key).get('contracttype');
                            newrec.Customer_Code__c=summarymap.get(key).get('AccountNumber');
                            newrec.Product_Code__c=summarymap.get(key).get('productcode');
                            newrec.GCP_Backorder_OTC__c=existingBackOrderRXMap.containskey(summarymap.get(key).get('productcode')) ? existingBackOrderRXMap.get(summarymap.get(key).get('productcode')):newrec.GCP_Backorder_OTC__c;
                            newrec.GCP_Backorder_SRx_Rx__c=existingBackOrderSRXMap.containskey(summarymap.get(key).get('productcode')) ? existingBackOrderSRXMap.get(summarymap.get(key).get('productcode')).id:newrec.GCP_Backorder_SRx_Rx__c;
                            newrec.Contract_Number__c=summarymap.get(key).get('contractnumber');
                            
                            
                            
                            
                            if(summarymap.get(key).get('Actuals')!=null){
                                newrec.Actual_Sales__c=decimal.valueof(summarymap.get(key).get('Actuals'));
                            }
                            newrec.NPR_Data__c=summarymap.get(key).get('npr');
                            newrec.Vision_Unique_Identifier__c=internalkey1;
                        }
                        complianceSummaryMap.put(internalkey1,newrec);
                        complianceSummaryMapkey.put(internalkey1,new list<Compliance_Data__c>{newrec});
                    }
                    else{
                        Compliance_Data__c newrec = existingComplianerecsMap.get(internalkey1);
                        
                        // Compliance_Data__c newrec = existingComplianerecsMap.get(key);
                        if(existingCustomerProductTrackerRecs.containsKey(internalkey1)) {
                            if(existingCustomerProductTrackerRecs.get(internalkey1).Vision_Awarded_Volume__c != null){
                                
                                    newrec.Awarded_Information__c = existingCustomerProductTrackerRecs.get(internalkey1).Vision_Awarded_Volume__c;
                                
                            }
                              if(existingCustomerProductTrackerRecs.get(internalkey1).General_Category__c != null) {
                                newrec.General_Category__c=existingCustomerProductTrackerRecs.get(internalkey1).General_Category__c;
                            }
                              if(existingCustomerProductTrackerRecs.get(internalkey1).Vision_Current_Product_Position__c != null) {
                                newrec.Product_Position__c=existingCustomerProductTrackerRecs.get(internalkey1).Vision_Current_Product_Position__c;
                            }
                             if(existingCustomerProductTrackerRecs.get(internalKey1).Vision_Price_Effective_Date__c != null){
                           
                            newrec.Price_Effective_Date__c = existingCustomerProductTrackerRecs.get(internalKey1).Vision_Price_Effective_Date__c;
                        
                         }
                        }
                        if(summarymap.get(key).containskey('month')){
                            string monthdts1=summarymap.get(key).get('month');
                            //system.debug('key....'+key);
                          //  system.debug('monthdtsss'+monthdts1);
                           // system.debug('monthdtsss'+monthdts1);
                            
                          //  system.debug('m1...'+m1);
                           // system.debug('m2...'+m2);
                           // system.debug('m3..'+m3);
                          //  system.debug('m4..'+m4);
                           // system.debug('m5..'+m5);
                            if(m1==monthdts1){
                                newrec.Month1__c=monthdts1;
                                newrec.M1_Quantity__c=decimal.valueof(summarymap.get(key).get('volume'));
                            }
                            else if(m2==monthdts1){
                                newrec.Month2__c=monthdts1;
                                newrec.M2_Quantity__c=decimal.valueof(summarymap.get(key).get('volume'));
                            }
                            else if(m3==monthdts1){
                                newrec.Month3__c=monthdts1;
                                newrec.M3_Quantity__c=decimal.valueof(summarymap.get(key).get('volume'));
                            }
                            else if(m4==monthdts1){
                                newrec.Month4__c=monthdts1;
                                newrec.M4_Quantity__c=decimal.valueof(summarymap.get(key).get('volume'));
                            }
                            else if(m5==monthdts1){
                                newrec.Month5__c=monthdts1;
                                newrec.M5_Quantity__c=decimal.valueof(summarymap.get(key).get('volume'));
                            }
                            else if(m6==monthdts1){
                                newrec.Month6__c=monthdts1;
                                newrec.M6_Quantity__c=decimal.valueof(summarymap.get(key).get('volume'));
                            }
                            else if(m7==monthdts1){
                                newrec.Month7__c=monthdts1;
                                newrec.M7_Quantity__c=decimal.valueof(summarymap.get(key).get('volume'));
                            }
                            else if(m8==monthdts1){
                                newrec.Month8__c=monthdts1;
                                newrec.M8_Quantity__c=decimal.valueof(summarymap.get(key).get('volume'));
                            }
                            else if(m9==monthdts1){
                                newrec.Month9__c=monthdts1;
                                newrec.M9_Quantity__c=decimal.valueof(summarymap.get(key).get('volume'));
                            }
                            else if(m10==monthdts1){
                                newrec.Month10__c=monthdts1;
                                newrec.M10_Quantity__c=decimal.valueof(summarymap.get(key).get('volume'));
                            }
                              else if(m11 == monthdts1){
                                newrec.Month11__c=monthdts1;
                                newrec.M11_Quantity__c=decimal.valueof(summarymap.get(key).get('volume'));
                            }
                              else if(m12 == monthdts1){
                                newrec.Month12__c=monthdts1;
                                newrec.M12_Quantity__c=decimal.valueof(summarymap.get(key).get('volume'));
                            }
                            
                            
                            newrec.Vision_Customer__c= summarymap.get(key).get('Account'); 
                            newrec.Vision_Product__c= summarymap.get(key).get('product');
                            newrec.Vision_Contract__c=summarymap.get(key).get('contract');
                            newrec.Contract_Type__c=summarymap.get(key).get('contracttype');
                            newrec.NPR_Data__c=summarymap.get(key).get('npr');
                            newrec.Customer_Code__c=summarymap.get(key).get('AccountNumber');
                            newrec.Product_Code__c=summarymap.get(key).get('productcode');
                            newrec.GCP_Backorder_OTC__c=existingBackOrderRXMap.containskey(summarymap.get(key).get('productcode'))?existingBackOrderRXMap.get(summarymap.get(key).get('productcode')):newrec.GCP_Backorder_OTC__c;
                            newrec.GCP_Backorder_SRx_Rx__c=existingBackOrderSRXMap.containskey(summarymap.get(key).get('productcode'))?existingBackOrderSRXMap.get(summarymap.get(key).get('productcode')).id:newrec.GCP_Backorder_SRx_Rx__c;
                            newrec.Contract_Number__c=summarymap.get(key).get('contractnumber');
                         
                            
                            
                            
                            if(summarymap.get(key).get('Actuals')!=null)
                                newrec.Actual_Sales__c=decimal.valueof(summarymap.get(key).get('Actuals'));
                            newrec.Vision_Unique_Identifier__c=internalkey1;
                        }
                        complianceSummaryMap.put(internalkey1,newrec);  
                        //complianceSummaryMapkey.get(internalkey1).add(newrec);
                        
                    }
                }
                //list<Compliance_Data__c> cmpdata =new list<Compliance_Data__c>();
               // for(string ss:complianceSummaryMapkey.keyset()){
                    // cmpdata.add(complianceSummaryMapkey.get(ss));
                    //system.debug('comsummarymap'+ss+'-'+complianceSummaryMapkey.get(ss));
               // }
                if(complianceSummaryMap.size()>0)
                    upsert complianceSummaryMap.values();
                
                
            }
            catch(exception e){
                Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'ComplainceRecordsNprData', Phoenix_Error_Message__c = e.getMessage(), Phoenix_Issue_Status__c = 'Pending', Phoenix_Method_Name__c = 'execute', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
                insert exp;
            }
            
        }
        
    }
    public void finish(Database.BatchableContext BC) {
        Database.executeBatch(new Compliance_RollUP_Batch());
    }
    
    
}