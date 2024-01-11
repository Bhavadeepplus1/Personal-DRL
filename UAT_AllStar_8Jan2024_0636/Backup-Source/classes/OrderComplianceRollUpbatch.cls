public class OrderComplianceRollUpbatch implements Database.Batchable < sObject >{
    public Database.QueryLocator start(Database.BatchableContext BC) {
        string ss='370679';
        string query='select'+Phoenix_Util.getsObjectFieds('Order_Compliance_Data__c')+'from Order_Compliance_Data__c';
        return Database.getQueryLocator(query);  
    }
    public void execute(Database.BatchableContext BC, List <Order_Compliance_Data__c> compliancerecords) {
         delete[select id from Order_Compliance_Summary__c where createddate!=today limit 1000];
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
            
            list<string> uniqueidsset=new list<string>();
           
       //Order_Compliance_Data__c[] ocd;
            Map<String,Order_Compliance_Summary__c> uniqueIdentifierMap = new  Map<String,Order_Compliance_Summary__c>();
            ///map<string,Order_Compliance_Data__c> 
            for(Order_Compliance_Data__c comrec:compliancerecords){
                uniqueidsset.add(comrec.Internal_Unique_Identifier__c);
            }
           string ss1='370679';
            //Rolling UP here by Product  and Customer so that same product and same customer with two different contracts should be Represented as one record
            if(uniqueIdsSet.size() > 0){
                String query;
                
                
                query = 'SELECT Product_Code__c,Hierachy_Code__c,Sum(M1_Quantity__c) m1,Sum(M2_Quantity__c) m2,Sum(M3_Quantity__c) m3,Sum(M4_Quantity__c) m4,Sum(M5_Quantity__c) m5,Sum(M6_Quantity__c) m6,Sum(M7_Quantity__c) m7,Sum(M8_Quantity__c) m8,Sum(M9_Quantity__c) m9,Sum(M10_Quantity__c) m10,Sum(M11_Quantity__c) m11,Sum(M12_Quantity__c) m12,Sum(M13_Quantity__c) m13,Sum(M14_Quantity__c) m14,Sum(M15_Quantity__c) m15,Sum(Awarded_Quantity__c)aq  FROM Order_Compliance_Data__c  where Internal_Unique_Identifier__c in :uniqueIdsSet GROUP BY Product_Code__c,Hierachy_Code__c';
                
                
                List<AggregateResult> AggregateResultList = Database.query(query);
                set<String> uniqueIdKeys = new set<String>();
                //Storing AggregateResult into each record
                for(AggregateResult aggr : AggregateResultList){
                    Order_Compliance_Summary__c com;
                    String uniqueId = (String) aggr.get('Hierachy_Code__c')+'-'+(String) aggr.get('Product_Code__c');
                    if(uniqueIdentifierMap.containsKey(uniqueId)){
                        // System.debug('inside contains');
                        com = uniqueIdentifierMap.get(uniqueId);
                        com.Vision_Unique_Identifier__c = uniqueId;
                        com.M1_Quantity__c =  aggr.get('m1')!=null ? math.ceil((Decimal) aggr.get('m1')):0;
                        com.M2_Quantity__c = aggr.get('m2')!=null ? math.ceil((Decimal) aggr.get('m2')):0;
                        com.M3_Quantity__c = aggr.get('m3')!=null ? math.ceil((Decimal) aggr.get('m3')):0;
                        com.M4_Quantity__c =  aggr.get('m4')!=null ? math.ceil((Decimal) aggr.get('m4')):0;
                        com.M5_Quantity__c =  aggr.get('m5')!=null ? math.ceil((Decimal) aggr.get('m5')):0;
                        com.M6_Quantity__c =  aggr.get('m6')!=null ? math.ceil((Decimal) aggr.get('m6')):0;
                        com.M7_Quantity__c = aggr.get('m7')!=null ? math.ceil((Decimal) aggr.get('m7')):0;
                        com.M8_Quantity__c =  aggr.get('m8')!=null ? math.ceil((Decimal) aggr.get('m8')):0;
                        com.M9_Quantity__c = aggr.get('m9')!=null ? math.ceil((Decimal) aggr.get('m9')):0;
                        com.M10_Quantity__c = aggr.get('m10')!=null ? math.ceil((Decimal) aggr.get('m10')):0;
                        com.M11_Quantity__c = aggr.get('m11')!=null ? math.ceil((Decimal) aggr.get('m11')):0;
                        com.M12_Quantity__c = aggr.get('m12')!=null ? math.ceil((Decimal) aggr.get('m12')):0;
                        com.M13_Quantity__c = aggr.get('m13')!=null ? math.ceil((Decimal) aggr.get('m13')):0;
                        com.M14_Quantity__c = aggr.get('m14')!=null ? math.ceil((Decimal) aggr.get('m14')):0;
                        com.M15_Quantity__c = aggr.get('m15')!=null ? math.ceil((Decimal) aggr.get('m15')):0;
                        com.Awarded_Quantity__c =  aggr.get('aq')!=null ? math.ceil((Decimal) aggr.get('aq')):0;
                        uniqueIdentifierMap.put(uniqueId,com);
                        uniqueIdKeys.add(uniqueId);
                        
                    }
                    else{
                        com = new Order_Compliance_Summary__c();
                        // System.debug('inside new');
                        com.Vision_Unique_Identifier__c = uniqueId;
                        //String contractType = (String) aggr.get('Contract_Type__c');
                        //if(contractType == 'Direct'){
                        
                        com.M1_Quantity__c =  aggr.get('m1')!=null ? math.ceil((Decimal) aggr.get('m1')):0;
                        com.M2_Quantity__c = aggr.get('m2')!=null ? math.ceil((Decimal) aggr.get('m2')):0;
                        com.M3_Quantity__c = aggr.get('m3')!=null ? math.ceil((Decimal) aggr.get('m3')):0;
                        com.M4_Quantity__c =  aggr.get('m4')!=null ? math.ceil((Decimal) aggr.get('m4')):0;
                        com.M5_Quantity__c =  aggr.get('m5')!=null ? math.ceil((Decimal) aggr.get('m5')):0;
                        com.M6_Quantity__c =  aggr.get('m6')!=null ? math.ceil((Decimal) aggr.get('m6')):0;
                        com.M7_Quantity__c = aggr.get('m7')!=null ? math.ceil((Decimal) aggr.get('m7')):0;
                        com.M8_Quantity__c =  aggr.get('m8')!=null ? math.ceil((Decimal) aggr.get('m8')):0;
                        com.M9_Quantity__c = aggr.get('m9')!=null ? math.ceil((Decimal) aggr.get('m9')):0;
                        com.M10_Quantity__c = aggr.get('m10')!=null ? math.ceil((Decimal) aggr.get('m10')):0;
                        com.M11_Quantity__c = aggr.get('m11')!=null ? math.ceil((Decimal) aggr.get('m11')):0;
                        com.M12_Quantity__c = aggr.get('m12')!=null ? math.ceil((Decimal) aggr.get('m12')):0;
                        com.M13_Quantity__c = aggr.get('m13')!=null ? math.ceil((Decimal) aggr.get('m13')):0;
                        com.M14_Quantity__c = aggr.get('m14')!=null ? math.ceil((Decimal) aggr.get('m14')):0;
                        com.M15_Quantity__c = aggr.get('m15')!=null ? math.ceil((Decimal) aggr.get('m15')):0;
                        com.Awarded_Quantity__c =  aggr.get('aq')!=null ? math.ceil((Decimal) aggr.get('aq')):0;
                        uniqueIdentifierMap.put(uniqueId,com);
                        uniqueIdKeys.add(uniqueId);
                        
                        
                    }
                }
                system.debug('map'+uniqueIdentifierMap);
                if(compliancerecords.size() > 0){
                    for(Order_Compliance_Data__c compRec : compliancerecords){
                        system.debug('comrec...'+compRec.Internal_Unique_Identifier__c);
                        if(uniqueIdentifierMap.containsKey(compRec.Internal_Unique_Identifier__c)){
                            uniqueIdentifierMap.get(compRec.Internal_Unique_Identifier__c).Month1__c = compRec.Month1__c!=null?compRec.Month1__c:m1; 
                            uniqueIdentifierMap.get(compRec.Internal_Unique_Identifier__c).Month2__c = compRec.Month2__c!=null?compRec.Month2__c:m2; 
                            uniqueIdentifierMap.get(compRec.Internal_Unique_Identifier__c).Month3__c = compRec.Month3__c!=null?comprec.Month3__c:m3; 
                            uniqueIdentifierMap.get(compRec.Internal_Unique_Identifier__c).Month4__c = compRec.Month4__c!=null?comprec.Month4__c:m4;
                            uniqueIdentifierMap.get(compRec.Internal_Unique_Identifier__c).Month5__c = compRec.Month5__c!=null?comprec.Month5__c:m5;
                            uniqueIdentifierMap.get(compRec.Internal_Unique_Identifier__c).Month6__c = compRec.Month6__c!=null?compRec.Month6__c:m6; 
                            uniqueIdentifierMap.get(compRec.Internal_Unique_Identifier__c).Month7__c = compRec.Month7__c!=null?compRec.Month7__c:m7; 
                            uniqueIdentifierMap.get(compRec.Internal_Unique_Identifier__c).Month8__c = compRec.Month8__c!=null?comprec.Month8__c:m8; 
                            uniqueIdentifierMap.get(compRec.Internal_Unique_Identifier__c).Month9__c = compRec.Month9__c!=null?comprec.Month9__c:m9; 
                            uniqueIdentifierMap.get(compRec.Internal_Unique_Identifier__c).Month10__c = compRec.Month10__c!=null?compRec.Month10__c:m10; 
                            uniqueIdentifierMap.get(compRec.Internal_Unique_Identifier__c).Month11__c = compRec.Month11__c!=null?compRec.Month11__c:m11;
                            uniqueIdentifierMap.get(compRec.Internal_Unique_Identifier__c).Month12__c = compRec.Month12__c!=null?compRec.Month12__c:m12;
                            uniqueIdentifierMap.get(compRec.Internal_Unique_Identifier__c).Month13__c = compRec.Month13__c!=null?compRec.Month13__c:m13;
                            uniqueIdentifierMap.get(compRec.Internal_Unique_Identifier__c).Month14__c = compRec.Month14__c!=null?compRec.Month14__c:m14;
                            uniqueIdentifierMap.get(compRec.Internal_Unique_Identifier__c).Month15__c = compRec.Month15__c!=null?compRec.Month15__c:m15;
                            uniqueIdentifierMap.get(compRec.Internal_Unique_Identifier__c).GCP_Backorder_OTC__c = compRec.GCP_Backorder_OTC__c;
                            uniqueIdentifierMap.get(compRec.Internal_Unique_Identifier__c).GCP_Backorder_SRx_Rx__c = compRec.GCP_Backorder_SRx_Rx__c;
                            uniqueIdentifierMap.get(compRec.Internal_Unique_Identifier__c).Is_in_Openorder__c = compRec.Is_in_Openorder__c;
                            // uniqueIdentifierMap.get(compRec.Internal_Unique_Identifier__c).Awarded_Quantity__c = compRec.Awarded_Quantity__c;
                            uniqueIdentifierMap.get(compRec.Internal_Unique_Identifier__c).Product_Position__c = compRec.Product_Position__c;
                            uniqueIdentifierMap.get(compRec.Internal_Unique_Identifier__c).Price_Effective_Date__c = compRec.Price_Effective_Date__c;
                            uniqueIdentifierMap.get(compRec.Internal_Unique_Identifier__c).Supply_Effective_Date__c = compRec.Supply_Effective_Date__c;
                            uniqueIdentifierMap.get(compRec.Internal_Unique_Identifier__c).Hierachy_Code__c = compRec.Hierachy_Code__c;
                            uniqueIdentifierMap.get(compRec.Internal_Unique_Identifier__c).Product_Code__c = compRec.Product_Code__c;
                            uniqueIdentifierMap.get(compRec.Internal_Unique_Identifier__c).Vision_Product__c = compRec.Vision_Product__c;
                            
                            
                            
                        }
                    }
                }
                for(Order_Compliance_Summary__c existingRec : [Select Id,Vision_Unique_Identifier__c from Order_Compliance_Summary__c where Vision_Unique_Identifier__c IN: uniqueIdKeys]){
                    if(uniqueIdentifierMap.containsKey(existingRec.Vision_Unique_Identifier__c)){
                        uniqueIdentifierMap.get(existingRec.Vision_Unique_Identifier__c).Id = existingRec.Id;
                    }
                }
            }
            //Upserting Records here
            if(uniqueIdentifierMap.values().size()>0){
                // system.debug('inside upsert');
                Database.UpsertResult[] results = Database.upsert(uniqueIdentifierMap.values(),true);
            }
        }
        catch(exception e){
            Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'OrderComplianceRollUpbatch', Phoenix_Error_Message__c = e.getMessage(), Phoenix_Issue_Status__c = 'Pending', Phoenix_Method_Name__c = 'execute', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
            insert exp; 
        }
        
        
        
    }
    public void finish(Database.BatchableContext BC) {
        Database.executeBatch(new OrderComplianceFTDQTDMTD(),100);
    }
}