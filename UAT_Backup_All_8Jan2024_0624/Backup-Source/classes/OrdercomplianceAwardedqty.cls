public class OrdercomplianceAwardedqty implements Database.Batchable < sObject >{
    public Database.QueryLocator start(Database.BatchableContext BC) {
        String acc = '115596';
        string uu='300000912_115596';
        
        String query='';
        
        
            query = 'Select Vision_Product__r.Phoenix_NDC_11__c,Vision_Product__r.Phoenix_NDC__c,'+Phoenix_Util.getsObjectFieds('Order_Compliance_Data__c')+' from Order_Compliance_Data__c';
            //where Vision_Customer__r.accountnumber=:acc';
        
        return Database.getQueryLocator(query);
    }
    public void execute(Database.BatchableContext BC, List <Order_Compliance_Data__c> compliancerecords) {
        try{ 
          map<string,Order_Compliance_Data__c> updatesummaryrecmap=new map<string,Order_Compliance_Data__c>();
           list<Order_Compliance_Data__c> updateSummaryRec = new list<Order_Compliance_Data__c>();
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
            // date dt1;
         
            // system.debug('uniqueIdentifierMap=='+uniqueIdentifierMap.keySet());
            //  system.debug('compliancerecords===='+compliancerecords.size());  
             
            
            map<String,Id> existingBackOrderRXMap =new Map<String,Id>();
            for( Vision_GCP_Backorder_OTC__c  backOrderRx : [select id,Vision_Sku_Code__c,Vision_Backorder_Report_Date__c From Vision_GCP_Backorder_OTC__c where Vision_Sku_Code__c != null ]){
                if(!existingBackOrderRXMap.containskey(backOrderRx.Vision_Sku_Code__c ))
                    existingBackOrderRXMap.put(backOrderRx.Vision_Sku_Code__c ,backOrderRx.Id);
                
            }
            map<String,ID> existingBackOrderSRXMap =new Map<String,Id>();
            for( Vision_GCP_Backorder_SRx_Rx__c backOrderSRx : [select id,Vision_Sku_Code__c,Vision_MoH__c,Vision_On_Backorder__c From Vision_GCP_Backorder_SRx_Rx__c where Vision_Sku_Code__c != null ]){
                if(!existingBackOrderSRXMap.containskey(backOrderSRx.Vision_Sku_Code__c))
                    existingBackOrderSRXMap.put(backOrderSRx.Vision_Sku_Code__c ,backOrderSRx.id);
            }  
                 map<string,Order_Compliance_Data__c> allndcrecs=new map<string,Order_Compliance_Data__c>();
            list<string> intunique= new list<string>();
            
            // Map<String,Compliance_Summary__c> uniqueIdentifierMap = new  Map<String,Compliance_Summary__c>();
       
              map<string,boolean> ndcmap= new map<string,boolean>();
        
            list<string> keys=new list<string>();
            list<string> unikeys=new list<string>();
            list<string> compkeys=new list<string>();
           
        
           set<string> ndcset=allndcrecs.keyset();
            map<string,list<Order_Compliance_Data__c>> ordercomp=new map<string,list<Order_Compliance_Data__c>>();
             for(Order_Compliance_Data__c comrec :compliancerecords ){
                // uniqueIdsSet.add(comrec.Int_Unique_Identifier__c);
                allndcrecs.put(comrec.Vision_Product__r.Phoenix_NDC_11__c,comrec);
                allndcrecs.put(comrec.Vision_Product__r.Phoenix_NDC__c,comrec);
                // compkeys.add()
                unikeys.add(comrec.Vision_Unique_Identifier__c);
                  //keys.add(comrec.Sold_to_customer_code__c+'-'+comrec.Product_Code__c);
               keys.add(comrec.Hierachy_Code__c+'-'+comrec.Product_Code__c);
               // intunique.add(comrec.Customer_Code__c+'-'+comrec.Product_Code__c);
               if(ordercomp.containskey(comrec.Hierachy_Code__c+'-'+comrec.Product_Code__c)){
                    ordercomp.get(comrec.Hierachy_Code__c+'-'+comrec.Product_Code__c).add(comrec);
                }
                else{
                    ordercomp.put(comrec.Hierachy_Code__c+'-'+comrec.Product_Code__c,new list<Order_Compliance_Data__c>{comrec});
                }
               
             }  
           
            // list<string> orderndclist=new list<string>();
         
          string key1;
            string key2;
          
         
            
          
          
            map<string,list<Vision_GCP_SFDC_Order_Status__c>> existingordercommap= new map<string,list<Vision_GCP_SFDC_Order_Status__c>>();
            for(Vision_GCP_SFDC_Order_Status__c ocd:[select id,Vision_Order_Date__c,Vision_Order_Quantity__c,Vision_Sold_to_Customer_Code__c,Vision_Sold_to_Customer_Name__c,Vision_Order_Status__c,Vision_Hierachy_Code__c,Vision_Product__c,Vision_Product__r.productcode,Compliance_Unique_Identifier__c from Vision_GCP_SFDC_Order_Status__c where Compliance_Unique_Identifier__c in : keys and Vision_Order_Status__c!='CANCELLED']){
                if(existingordercommap.containskey(ocd.Compliance_Unique_Identifier__c)){
                    existingordercommap.get(ocd.Compliance_Unique_Identifier__c).add(ocd);
                }
                else{
                    existingordercommap.put(ocd.Compliance_Unique_Identifier__c,new list<Vision_GCP_SFDC_Order_Status__c>{ocd});
                }
            }
          
            Integer d ;
            string month;
            
                Integer mo ;
                Integer yr ;
                DateTime dt;
                string monthdts1='';
          list<Order_Compliance_Data__c> nprlist= new   list<Order_Compliance_Data__c>();
                for(string unq:existingordercommap.keyset()){
            for(Vision_GCP_SFDC_Order_Status__c rec:existingordercommap.get(unq)){
                  d=rec.Vision_Order_Date__c.day();
                      mo = rec.Vision_Order_Date__c.month();
                       yr=rec.Vision_Order_Date__c.year();
                        dt= DateTime.newInstance(yr, mo, d);
                monthdts1=dt.format('MMM')+'-'+String.valueOf(yr).subString(2);
                if(ordercomp.containskey(unq)){
                    nprlist=ordercomp.get(unq);
                   nprlist[0] .Sold_to_customer_code__c=rec.Vision_Sold_to_Customer_Code__c;
                    
                    nprlist[0].sold_to_customer_name__c=rec.Vision_Sold_to_Customer_Name__c;
               
                if(m1==monthdts1){
                  nprlist[0].Month1__c =monthdts1;
                    nprlist[0].M1_Quantity__c=nprlist[0].M1_Quantity__c!=null?nprlist[0].M1_Quantity__c+rec.Vision_Order_Quantity__c:rec.Vision_Order_Quantity__c;
                
                }
                else  if(m2==monthdts1){
                  nprlist[0].Month2__c =monthdts1;
                    nprlist[0].M2_Quantity__c=nprlist[0].M2_Quantity__c!=null?nprlist[0].M2_Quantity__c+rec.Vision_Order_Quantity__c:rec.Vision_Order_Quantity__c;
                
                }  
                  else  if(m3==monthdts1){
                  nprlist[0].Month3__c =monthdts1;
                    nprlist[0].M3_Quantity__c=nprlist[0].M3_Quantity__c!=null?nprlist[0].M3_Quantity__c+rec.Vision_Order_Quantity__c:rec.Vision_Order_Quantity__c;
                
                }  
                     else  if(m4==monthdts1){
                  nprlist[0].Month4__c =monthdts1;
                    nprlist[0].M4_Quantity__c=nprlist[0].M4_Quantity__c!=null?nprlist[0].M4_Quantity__c+rec.Vision_Order_Quantity__c:rec.Vision_Order_Quantity__c;
                
                }  
                    else  if(m5==monthdts1){
                  nprlist[0].Month5__c =monthdts1;
                    nprlist[0].M5_Quantity__c=nprlist[0].M5_Quantity__c!=null?nprlist[0].M5_Quantity__c+rec.Vision_Order_Quantity__c:rec.Vision_Order_Quantity__c;
                
                }  
                     else  if(m6==monthdts1){
                  nprlist[0].Month6__c =monthdts1;
                    nprlist[0].M6_Quantity__c=nprlist[0].M6_Quantity__c!=null?nprlist[0].M6_Quantity__c+rec.Vision_Order_Quantity__c:rec.Vision_Order_Quantity__c;
                
                }  
                     else  if(m7==monthdts1){
                  nprlist[0].Month7__c =monthdts1;
                    nprlist[0].M7_Quantity__c=nprlist[0].M7_Quantity__c!=null?nprlist[0].M7_Quantity__c+rec.Vision_Order_Quantity__c:rec.Vision_Order_Quantity__c;
                
                }  
                    else  if(m8==monthdts1){
                  nprlist[0].Month8__c =monthdts1;
                    nprlist[0].M8_Quantity__c=nprlist[0].M8_Quantity__c!=null?nprlist[0].M8_Quantity__c+rec.Vision_Order_Quantity__c:rec.Vision_Order_Quantity__c;
                
                } 
                     else  if(m9==monthdts1){
                  nprlist[0].Month9__c =monthdts1;
                    nprlist[0].M9_Quantity__c=nprlist[0].M9_Quantity__c!=null?nprlist[0].M9_Quantity__c+rec.Vision_Order_Quantity__c:rec.Vision_Order_Quantity__c;
                
                }
                     else  if(m10==monthdts1){
                  nprlist[0].Month10__c =monthdts1;
                    nprlist[0].M10_Quantity__c=nprlist[0].M10_Quantity__c!=null?nprlist[0].M10_Quantity__c+rec.Vision_Order_Quantity__c:rec.Vision_Order_Quantity__c;
                
                } 
                     else  if(m11==monthdts1){
                  nprlist[0].Month11__c =monthdts1;
                    nprlist[0].M11_Quantity__c=nprlist[0].M11_Quantity__c!=null?nprlist[0].M11_Quantity__c+rec.Vision_Order_Quantity__c:rec.Vision_Order_Quantity__c;
                
                }  
                    else  if(m12==monthdts1){
                  nprlist[0].Month12__c =monthdts1;
                    nprlist[0].M12_Quantity__c=nprlist[0].M12_Quantity__c!=null?nprlist[0].M12_Quantity__c+rec.Vision_Order_Quantity__c:rec.Vision_Order_Quantity__c;
                
                }  
                    else  if(m13==monthdts1){
                  nprlist[0].Month13__c =monthdts1;
                    nprlist[0].M13_Quantity__c=nprlist[0].M13_Quantity__c!=null?nprlist[0].M13_Quantity__c+rec.Vision_Order_Quantity__c:rec.Vision_Order_Quantity__c;
                
                }  
                     else  if(m14==monthdts1){
                  nprlist[0].Month14__c =monthdts1;
                    nprlist[0].M14_Quantity__c=nprlist[0].M14_Quantity__c!=null?nprlist[0].M14_Quantity__c+rec.Vision_Order_Quantity__c:rec.Vision_Order_Quantity__c;
                
                }  
                    else  if(m15==monthdts1){
                  nprlist[0].Month15__c =monthdts1;
                    nprlist[0].M15_Quantity__c=nprlist[0].M15_Quantity__c!=null?nprlist[0].M15_Quantity__c+rec.Vision_Order_Quantity__c:rec.Vision_Order_Quantity__c;
                
                }
                    
                 if(nprlist[0].M1_Quantity__c==null){
                    nprlist[0].M1_Quantity__c=0;
                }
                 if(nprlist[0].M2_Quantity__c==null){
                    nprlist[0].M2_Quantity__c=0;
                }
                 if(nprlist[0].M3_Quantity__c==null){
                    nprlist[0].M3_Quantity__c=0;
                }
                 if(nprlist[0].M4_Quantity__c==null){
                    nprlist[0].M4_Quantity__c=0;
                }
                 if(nprlist[0].M5_Quantity__c==null){
                    nprlist[0].M5_Quantity__c=0;
                }
                 if(nprlist[0].M6_Quantity__c==null){
                    nprlist[0].M6_Quantity__c=0;
                }
                 if(nprlist[0].M7_Quantity__c==null){
                    nprlist[0].M7_Quantity__c=0;
                }
                 if(nprlist[0].M8_Quantity__c==null){
                    nprlist[0].M8_Quantity__c=0;
                }
                 if(nprlist[0].M9_Quantity__c==null){
                    nprlist[0].M9_Quantity__c=0;
                }
                 if(nprlist[0].M10_Quantity__c==null){
                    nprlist[0].M10_Quantity__c=0;
                }
                 if(nprlist[0].M11_Quantity__c==null){
                    nprlist[0].M11_Quantity__c=0;
                }
                 if(nprlist[0].M12_Quantity__c==null){
                    nprlist[0].M12_Quantity__c=0;
                }
                if(nprlist[0].M13_Quantity__c==null){
                    nprlist[0].M13_Quantity__c=0;
                }
                if(nprlist[0].M14_Quantity__c==null){
                    nprlist[0].M14_Quantity__c=0;
                }
                if(nprlist[0].M15_Quantity__c==null){
                    nprlist[0].M15_Quantity__c=0;
                }    
                    
                    
                    updatesummaryrecmap.put(nprlist[0].Vision_Unique_Identifier__c,nprlist[0]);

                        
                    
                  
                    
                    
                    
                    
                }
                
            }
        }
            // system.debug('ndcset...'+ndcset);
          
            
            
            for(Order_Compliance_Data__c qtdrec : compliancerecords){
                
                //   system.debug('qtdrec====='+qtdrec);
               
                //  if(qtdrec.M1_Quantity__c!=null)
                //   d=item.Vision_Order_Date__c.day();
                
                      
                
                                      
                //qtdrec.Vision_Account__c=accMap.containskey(qtdrec.Hierachy_Code__c)?accMap.get(qtdrec.Hierachy_Code__c).id:qtdrec.Vision_Account__c;
                //qtdrec.Sold_to_customer_Account__c=accMap.containskey(qtdrec.Sold_to_customer_code__c)?accMap.get(qtdrec.Sold_to_customer_code__c).id:qtdrec.Sold_to_customer_Account__c;
                qtdrec.GCP_Backorder_OTC__c=existingBackOrderRXMap.containskey(qtdrec.Product_Code__c)?existingBackOrderRXMap.get(qtdrec.Product_Code__c):qtdrec.GCP_Backorder_OTC__c;
                qtdrec.GCP_Backorder_SRx_Rx__c=existingBackOrderSRXMap.containskey(qtdrec.Product_Code__c)?existingBackOrderSRXMap.get(qtdrec.Product_Code__c):qtdrec.GCP_Backorder_SRx_Rx__c;
                if( ndcmap.containskey(qtdrec.Vision_Product__r.Phoenix_NDC_11__c)){
                    qtdrec.Is_in_Openorder__c =  ndcmap.get(qtdrec.Vision_Product__r.Phoenix_NDC_11__c);
                }
               
               else if(ndcmap.containskey(qtdrec.Vision_Product__r.Phoenix_NDC__c)){
                    qtdrec.Is_in_Openorder__c =  ndcmap.get(qtdrec.Vision_Product__r.Phoenix_NDC__c);
                    // uniqueIdentifierMap.get(compRec.Int_Unique_Identifier__c).Is_in_Openorder__c = true; 
                }
                else{
                    qtdrec.Is_in_Openorder__c=false;
                }
                
                  //key1=qtdrec.Sold_to_customer_code__c+'-'+qtdrec.Product_Code__c;
                  key1=qtdrec.Vision_Unique_Identifier__c;
              
                     if(updatesummaryrecmap.containskey(qtdrec.Vision_Unique_Identifier__c)){
                        updatesummaryrecmap.get(qtdrec.Vision_Unique_Identifier__c).id=qtdrec.id;
                    }
                    else{
                        updatesummaryrecmap.put(qtdrec.Vision_Unique_Identifier__c,qtdrec);
                    }
                
                
                
                
               
                
              
               
                   
            
            }
            system.debug('updateSummaryRec===='+updateSummaryRec);    
            system.debug('updateSummaryRec===='+updateSummaryRec.size());    
            if(updatesummaryrecmap.values().size()>0){
               Database.UpsertResult[] results = Database.upsert(updatesummaryrecmap.values(),true);
               system.debug('results===='+results);    
            
        }
            
        } catch(exception e){
            Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'Ordercomplianceawardedqty', Phoenix_Error_Message__c = e.getMessage(), Phoenix_Issue_Status__c = 'Pending', Phoenix_Method_Name__c = 'execute', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
            insert exp; 
        }
    }
    public void finish(Database.BatchableContext BC) {
         Database.executeBatch(new OrderComplianceRollUpbatch());
    }
    
    
    
    
    
}