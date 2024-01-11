public class OrdercompliancerecordscreationBatch implements Database.Batchable <sObject> ,Schedulable,Database.Stateful {
    public void execute(SchedulableContext sc) {
        Database.executeBatch(new OrdercompliancerecordscreationBatch());
    }
    public Database.QueryLocator start(Database.BatchableContext BC) {
        string s='115596';
        string p='300012842';
        //string sc='117866';
        string st='Direct';
          string status='Active';
        string   query='select id,Phoenix_Contract_Number__c,Phoenix_Material_Number__c,Phoenix_Contract__c,Phoenix_Account__c,Phoenix_Product__c,Phoenix_Account__r.accountnumber,Phoenix_Product__r.productcode from Phoenix_NPR_Data__c where Phoenix_Contract_Type__c=:st and  Phoenix_NPR_Status__c=:status and Phoenix_Product__r.IsActive=TRUE';
        return database.getQueryLocator(query);
    }
    public void execute(Database.BatchableContext BC, List <Phoenix_NPR_Data__c> nprlist) {
       delete[select id from Order_Compliance_Data__c where createddate!=today limit 1000];
        if(nprlist.size()>0){
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
                 DateTime dt13 = DateTime.now().addmonths(-12);
                 DateTime dt14 = DateTime.now().addmonths(-13);
                 DateTime dt15 = DateTime.now().addmonths(-14);
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
                 Integer y13 = dt13.year();
                String yr13 = String.valueOf(y13);
                 Integer y14 = dt12.year();
                String yr14 = String.valueOf(y14);
                 Integer y15 = dt15.year();
                String yr15 = String.valueOf(y15);
                
                
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
                string M13= dt13.format('MMM')+'-'+yr13.substring(2);
                string M14= dt14.format('MMM')+'-'+yr14.substring(2);
                string M15= dt15.format('MMM')+'-'+yr15.substring(2);
                set<String> UniqueIds = new set<String>();
                
                Map<String,Map<String,String>> SummaryMap = new Map<String,Map<String,String>>();
                string UniqueId='';
                Integer d ;
                Integer mo ;
                Integer yr ;
                DateTime dt;
                string Mm='';
                for(Phoenix_NPR_Data__c item:nprlist){
                    if(item.Phoenix_Contract_Number__c!=null && item.Phoenix_Material_Number__c!=null && item.Phoenix_Account__r.accountnumber!=null){
                        
                    
                        UniqueId=item.Phoenix_Contract_Number__c+'-'+item.Phoenix_Material_Number__c;
                        UniqueIds.add(item.Phoenix_Contract_Number__c+'-'+item.Phoenix_Material_Number__c);
                        
                        if(SummaryMap.containskey(UniqueId)){
                            Map<String,String> oneStepInnerMap = SummaryMap.get(uniqueId);
                            if(item.Phoenix_Material_Number__c!=null){
                                oneStepInnerMap.put('material number',item.Phoenix_Material_Number__c);  
                            }
                            
                           
                            if(item.Phoenix_Product__c!=null){
                                oneStepInnerMap.put('Product',item.Phoenix_Product__c);  
                            }
                           
                            if(item.Phoenix_Contract_Number__c!=null){
                                oneStepInnerMap.put('contract number',item.Phoenix_Contract_Number__c);  
                            }
                            if(item.Phoenix_Contract__c!=null){
                                oneStepInnerMap.put('Contract',item.Phoenix_Contract__c);
                            }
                             if(item.Phoenix_Account__r.accountnumber!=null){
                                oneStepInnerMap.put('AccountNumber',item.Phoenix_Account__r.accountnumber);
                            }
                        }
                        else{
                            Map<String,String> oneStepInnerMap =  new  map<string,string>();
                            if(item.Phoenix_Material_Number__c!=null){
                                oneStepInnerMap.put('material number',item.Phoenix_Material_Number__c);  
                            }
                            
                           
                            if(item.Phoenix_Product__c!=null){
                                oneStepInnerMap.put('Product',item.Phoenix_Product__c);  
                            }
                           
                            if(item.Phoenix_Contract_Number__c!=null){
                                oneStepInnerMap.put('contract number',item.Phoenix_Contract_Number__c);  
                            }
                            if(item.Phoenix_Contract__c!=null){
                                oneStepInnerMap.put('Contract',item.Phoenix_Contract__c);
                            }
                             if(item.Phoenix_Account__r.accountnumber!=null){
                                oneStepInnerMap.put('AccountNumber',item.Phoenix_Account__r.accountnumber);
                            }
                            summarymap.put(UniqueId,onestepinnermap);
                            
                        }
                    }
                    
                    
                    
                    
                }
                system.debug('summarymap'+summarymap.values());
                system.debug('summarymakey...'+summarymap.keyset());
                Map<String,Order_Compliance_Data__c> ordercomplianceSummaryMap = new Map<String,Order_Compliance_Data__c>();
                Map<string,Order_Compliance_Data__c> existingorderComplianerecsMap = new Map<string,Order_Compliance_Data__c>();
                String query = 'Select '+Phoenix_Util.getsObjectFieds('Order_Compliance_Data__c')+' from Order_Compliance_Data__c where Vision_Unique_Identifier__c IN:UniqueIds';
                for(Order_Compliance_Data__c existingRec : database.query(query)){
                    existingorderComplianerecsMap.put(existingRec.Vision_Unique_Identifier__c,existingRec);
                }
               
               
                
               
                for(String key:SummaryMap.keySet()){
                    //string internalkey=key.split('_')[0];
                    if(!existingorderComplianerecsMap.containskey(key)){
                        Order_Compliance_Data__c newrec =ordercomplianceSummaryMap.containsKey(key) ? ordercomplianceSummaryMap.get(key) : new Order_Compliance_Data__c();
                       
                                              
                      
                        newrec.Vision_Unique_Identifier__c=key;
                        newrec.Hierachy_Code__c=summarymap.get(key).get('AccountNumber');
                        newrec.Vision_Product__c=summarymap.get(key).get('Product');
                        newrec.Product_Code__c=summarymap.get(key).get('material number');
                       newrec.Contract_Number__c=summarymap.get(key).get('contract number');
                        //newrec.Order_Quantity__c=integer.valueof(summarymap.get(key).get('orderqty'));
                       // newrec.Sold_to_customer_code__c=summarymap.get(key).get('sold to customer code');
                       //newrec.sold_to_customer_name__c=summarymap.get(key).get('sold to customer name');
                        //newrec.Is_in_Openorder__c=summarymap.get(key).get('openorder')=='Not Delivered'?True:False;
                       // newrec.Vision_Account__c=summarymap.get(key).get('account');
                        
                        ordercomplianceSummaryMap.put(key,newrec);
                         //complianceSummaryMapkey.put(internalkey1,new list<Compliance_Data__c>{newrec});
                       // ordercomplianceSummaryMap.put(key,new list<Order_Compliance_Data__c>{newrec});
                        
                    }
                    else{
                        
                        
                        Order_Compliance_Data__c newrec = existingorderComplianerecsMap.get(key);
                        
                        //newrec.Vision_Unique_Identifier__c=internalkey;
                               newrec.Vision_Unique_Identifier__c=key;
                        newrec.Hierachy_Code__c=summarymap.get(key).get('AccountNumber');
                        newrec.Vision_Product__c=summarymap.get(key).get('Product');
                        newrec.Product_Code__c=summarymap.get(key).get('material number');
                       newrec.Contract_Number__c=summarymap.get(key).get('contract number');
                        
                        ordercomplianceSummaryMap.put(key,newrec);
                    }
                }
                system.debug('ordercomplaincesummaryMap...'+ordercomplianceSummaryMap.values());
                if(ordercomplianceSummaryMap.size()>0)
                    upsert ordercomplianceSummaryMap.values();
            }
            catch(exception e){
                Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'OrdercompliancerecordscreationBatch', Phoenix_Error_Message__c = e.getMessage(), Phoenix_Issue_Status__c = 'Pending', Phoenix_Method_Name__c = 'execute', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
                insert exp;
            }
            
            
            
        }
    }
    public void finish(Database.BatchableContext BC) {
         Database.executeBatch(new OrdercomplianceAwardedqty(),20);
    }
    
}