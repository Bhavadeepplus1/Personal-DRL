public class Compliance_RollUP_Batch implements Database.Batchable < sObject >,Database.Stateful {
    public Database.QueryLocator start(Database.BatchableContext BC) {
         String accId = '0011K00002RDd6lQAD';
         String query;
    //    if(test.isrunningtest()){
        query = 'Select Vision_Product__r.Phoenix_NDC_11__c,Vision_Product__r.Phoenix_NDC__c,Vision_Product__r.Phoenix_Rx_SRx_OTC__c,'+Phoenix_Util.getsObjectFieds('Compliance_Data__c')+' from Compliance_Data__c';
         
      //  }
     //   else{
        //     query = 'Select Vision_Product__r.Phoenix_NDC_11__c,Vision_Product__r.Phoenix_NDC__c,Vision_Product__r.Phoenix_Rx_SRx_OTC__c,'+Phoenix_Util.getsObjectFieds('Compliance_Data__c')+' from Compliance_Data__c where Vision_Customer__c=:accId';
         
     //   }
         return Database.getQueryLocator(query);
    }
    public void execute(Database.BatchableContext BC, List <Compliance_Data__c> compliancerecords) {
        try{
              Delete[select id from Compliance_Summary__c  where createddate!=today limit 1000];
            //  system.debug('compliancerecords----'+compliancerecords.size());
            //String accId = '115596';
                    String accId1 = '0011K00002RDd6lQAD';
            set<String> uniqueIdsSet = new set<String>();
            map<string,Compliance_Data__c> allndcrecs=new map<string,Compliance_Data__c>();
            Map<String,Compliance_Summary__c> uniqueIdentifierMap = new  Map<String,Compliance_Summary__c>();
            for(Compliance_Data__c comrec :compliancerecords ){
                uniqueIdsSet.add(comrec.Int_Unique_Identifier__c);
                allndcrecs.put(comrec.Vision_Product__r.Phoenix_NDC_11__c,comrec);
                allndcrecs.put(comrec.Vision_Product__r.Phoenix_NDC__c,comrec);
            }
            set<string> ndcset=allndcrecs.keyset();
            // system.debug('ndcset...'+ndcset);
            map<string,boolean> ndcmap= new map<string,boolean>();
            // list<string> orderndclist=new list<string>();
            for( Vision_GCP_SFDC_Order_Status__c orderStatusRec : [select id,Vision_Product__r.Phoenix_NDC_11__c ,Vision_Product__r.Phoenix_NDC__c From Vision_GCP_SFDC_Order_Status__c where Vision_Order_Status__c = 'NOT DELIVERED' and (Vision_Product__r.Phoenix_NDC__c in : ndcset or Vision_Product__r.Phoenix_NDC_11__c in:ndcset)]){
                if(orderStatusRec.Vision_Product__r.Phoenix_NDC_11__c!=null){
                    //system.debug('orderlist...'+orderStatusRec.Vision_Product__r.Phoenix_NDC_11__c);
                    // orderndclist.add(orderStatusRec.Vision_Product__r.Phoenix_NDC_11__c);
                    ndcmap.put(orderStatusRec.Vision_Product__r.Phoenix_NDC_11__c,true);
                }
                
                // system.debug('orderlist...'+orderStatusRec.Vision_Product__r.Phoenix_NDC_11__c);
                
                if(orderStatusRec.Vision_Product__r.Phoenix_NDC__c!=null){
                    ndcmap.put(orderStatusRec.Vision_Product__r.Phoenix_NDC__c,true);
                    // system.debug('orderlist...'+orderStatusRec.Vision_Product__r.Phoenix_NDC__c);
                    // orderndclist.add(orderStatusRec.Vision_Product__r.Phoenix_NDC__c) ;
                }
                
                
            }
            // system.debug('orderndclist'+orderndclist.size());
            
            // list<string> orderndclist=new list<string>();
            // orderndclist.addAll(orderndcset);
            //  upsert  allndcrecs.values();                                                        
            
            if(uniqueIdsSet.size() > 0){
                 String query;
               
               
                query = 'SELECT Product_Code__c,Customer_Code__c,Contract_Type__c,Sum(M1_Quantity__c) m1,Sum(M2_Quantity__c) m2,Sum(M3_Quantity__c) m3,Sum(M4_Quantity__c) m4,Sum(M5_Quantity__c) m5,Sum(M6_Quantity__c) m6,Sum(M7_Quantity__c) m7,Sum(M8_Quantity__c) m8,Sum(M9_Quantity__c) m9,Sum(M10_Quantity__c) m10,Sum(M11_Quantity__c) m11,Sum(M12_Quantity__c) m12,Sum(Awarded_Information__c)aq  FROM Compliance_Data__c where Int_Unique_Identifier__c in :uniqueIdsSet  GROUP BY Product_Code__c,Customer_Code__c,Contract_Type__c';// where Vision_Customer__c=:accId  GROUP BY Product_Code__c,Customer_Code__c,Contract_Type__c';
            
            List<AggregateResult> AggregateResultList = Database.query(query);
                
                 system.debug('AggregateResultList'+AggregateResultList.size());
                // List<Compliance_Summary__c> dohList = new List<Compliance_Summary__c>();
                set<String> uniqueIdKeys = new set<String>();
                
                for(AggregateResult aggr : AggregateResultList){
                    Compliance_Summary__c com;
                    String uniqueId = (String)aggr.get('Customer_Code__c')+'-'+(String)aggr.get('Product_Code__c');
                    if(uniqueIdentifierMap.containsKey(uniqueId)){
                        // System.debug('inside contains');
                        com = uniqueIdentifierMap.get(uniqueId);
                        com.Vision_Unique_Identifier__c = uniqueId;
                        String contractType = (String) aggr.get('Contract_Type__c');
                        if(contractType == 'Direct'){
                            
                            
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
                            com.Awarded_Information__c =  aggr.get('aq')!=null ? math.ceil((Decimal) aggr.get('aq')):0;
                          
                            com.Is_Direct__c =true;
                            
                            
                        }
                        else if(contractType == 'Indirect'){
                            
                            com.M1_Indirect_Quantity__c =  aggr.get('m1')!=null ? math.ceil((Decimal) aggr.get('m1')):0;
                            com.M2_Indirect_Quantity__c = aggr.get('m2')!=null ? math.ceil((Decimal) aggr.get('m2')):0;
                            com.M3_Indirect_Quantity__c =   aggr.get('m3')!=null ? math.ceil((Decimal) aggr.get('m3')):0;
                            com.M4_Indirect_Quantity__c =   aggr.get('m4')!=null ? math.ceil((Decimal) aggr.get('m4')):0;
                            com.M5_Indirect_Quantity__c =   aggr.get('m5')!=null ? math.ceil((Decimal) aggr.get('m5')):0;
                            com.M6_Indirect_Quantity__c =   aggr.get('m6')!=null ? math.ceil((Decimal) aggr.get('m6')):0;
                            com.M7_Indirect_Quantity__c =   aggr.get('m7')!=null ? math.ceil((Decimal) aggr.get('m7')):0;
                            com.M8_Indirect_Quantity__c =   aggr.get('m8')!=null ? math.ceil((Decimal) aggr.get('m8')):0;
                            com.M9_Indirect_Quantity__c =   aggr.get('m9')!=null ? math.ceil((Decimal) aggr.get('m9')):0;
                            com.M10_Indirect_Quantity__c =  aggr.get('m10')!=null ? math.ceil((Decimal) aggr.get('m10')):0;
                            com.M11_Indirect_Quantity__c = aggr.get('m11')!=null ? math.ceil((Decimal) aggr.get('m11')):0;
                            com.M12_Indirect_Quantity__c = aggr.get('m12')!=null ? math.ceil((Decimal) aggr.get('m12')):0;
                            com.Indirect_Awarded_Information__c =  aggr.get('aq')!=null ? math.ceil((Decimal) aggr.get('aq')):0;
                            com.Is_Indirect__c =true;
                            
                        }
                        uniqueIdentifierMap.put(uniqueId,com);
                        uniqueIdKeys.add(uniqueId);
                        
                    }
                    else{
                        com = new Compliance_Summary__c();
                        // System.debug('inside new');
                        com.Vision_Unique_Identifier__c = uniqueId;
                        String contractType = (String) aggr.get('Contract_Type__c');
                        if(contractType == 'Direct'){
                            
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
                            com.Awarded_Information__c =  aggr.get('aq')!=null ? math.ceil((Decimal) aggr.get('aq')):0;
                            com.Is_Direct__c =true;
                            
                        }
                        else if(contractType == 'Indirect'){
                            
                            com.M1_Indirect_Quantity__c =  aggr.get('m1')!=null ? math.ceil((Decimal) aggr.get('m1')):0;
                            com.M2_Indirect_Quantity__c = aggr.get('m2')!=null ? math.ceil((Decimal) aggr.get('m2')):0;
                            com.M3_Indirect_Quantity__c =   aggr.get('m3')!=null ? math.ceil((Decimal) aggr.get('m3')):0;
                            com.M4_Indirect_Quantity__c =   aggr.get('m4')!=null ? math.ceil((Decimal) aggr.get('m4')):0;
                            com.M5_Indirect_Quantity__c =   aggr.get('m5')!=null ? math.ceil((Decimal) aggr.get('m5')):0;
                            com.M6_Indirect_Quantity__c =   aggr.get('m6')!=null ? math.ceil((Decimal) aggr.get('m6')):0;
                            com.M7_Indirect_Quantity__c =   aggr.get('m7')!=null ? math.ceil((Decimal) aggr.get('m7')):0;
                            com.M8_Indirect_Quantity__c =   aggr.get('m8')!=null ? math.ceil((Decimal) aggr.get('m8')):0;
                            com.M9_Indirect_Quantity__c =   aggr.get('m9')!=null ? math.ceil((Decimal) aggr.get('m9')):0;
                            com.M10_Indirect_Quantity__c =  aggr.get('m10')!=null ? math.ceil((Decimal) aggr.get('m10')):0;
                            com.M11_Indirect_Quantity__c = aggr.get('m11')!=null ? math.ceil((Decimal) aggr.get('m11')):0;
                            com.M12_Indirect_Quantity__c = aggr.get('m12')!=null ? math.ceil((Decimal) aggr.get('m12')):0;
                            com.Indirect_Awarded_Information__c =  aggr.get('aq')!=null ? math.ceil((Decimal) aggr.get('aq')):0;
                            com.Is_Indirect__c =true;                    
                        }
                        uniqueIdentifierMap.put(uniqueId,com);
                        uniqueIdKeys.add(uniqueId);
                        
                    }
                    
                    // system.debug(' uniqueIdentifierMap..'+ uniqueIdentifierMap.values().size());
                    //dohList.add(doh);
                    //System.debug('doh>>>'+doh);
                }
                if(compliancerecords.size() > 0){
                    for(Compliance_Data__c compRec : compliancerecords){
                        if(uniqueIdentifierMap.containsKey(compRec.Int_Unique_Identifier__c)){
                            uniqueIdentifierMap.get(compRec.Int_Unique_Identifier__c).Month1__c = compRec.Month1__c; 
                            uniqueIdentifierMap.get(compRec.Int_Unique_Identifier__c).Month2__c = compRec.Month2__c; 
                            uniqueIdentifierMap.get(compRec.Int_Unique_Identifier__c).Month3__c = compRec.Month3__c; 
                            uniqueIdentifierMap.get(compRec.Int_Unique_Identifier__c).Month4__c = compRec.Month4__c;
                            uniqueIdentifierMap.get(compRec.Int_Unique_Identifier__c).Month5__c = compRec.Month5__c;
                            uniqueIdentifierMap.get(compRec.Int_Unique_Identifier__c).Month6__c = compRec.Month6__c; 
                            uniqueIdentifierMap.get(compRec.Int_Unique_Identifier__c).Month7__c = compRec.Month7__c; 
                            uniqueIdentifierMap.get(compRec.Int_Unique_Identifier__c).Month8__c = compRec.Month8__c; 
                            uniqueIdentifierMap.get(compRec.Int_Unique_Identifier__c).Month9__c = compRec.Month9__c; 
                            uniqueIdentifierMap.get(compRec.Int_Unique_Identifier__c).Month10__c = compRec.Month10__c; 
                            uniqueIdentifierMap.get(compRec.Int_Unique_Identifier__c).Month11__c = compRec.Month11__c;
                            uniqueIdentifierMap.get(compRec.Int_Unique_Identifier__c).Month12__c = compRec.Month12__c;
                            //system.debug('compRec.Vision_Customer__c----'+compRec.Vision_Customer__c);
                            
                            uniqueIdentifierMap.get(compRec.Int_Unique_Identifier__c).Vision_Contract__c = compRec.Vision_Contract__c; 
                            // system.debug('map.Vision_Customer__c----'+uniqueIdentifierMap.get(compRec.Int_Unique_Identifier__c).Vision_Contract__c);
                            uniqueIdentifierMap.get(compRec.Int_Unique_Identifier__c).Vision_Customer__c = compRec.Vision_Customer__c; 
                            uniqueIdentifierMap.get(compRec.Int_Unique_Identifier__c).Vision_Product__c = compRec.Vision_Product__c; 
                            uniqueIdentifierMap.get(compRec.Int_Unique_Identifier__c).product_Segment__c = compRec.Vision_Product__r.Phoenix_Rx_SRx_OTC__c;
                            uniqueIdentifierMap.get(compRec.Int_Unique_Identifier__c).GCP_Backorder_OTC__c = compRec.GCP_Backorder_OTC__c; 
                            uniqueIdentifierMap.get(compRec.Int_Unique_Identifier__c).Backorder_SRx_Rx__c = compRec.GCP_Backorder_SRx_Rx__c; 
                            //niqueIdentifierMap.get(compRec.Int_Unique_Identifier__c).General_Category__c=compRec.General_Category__c;
                           // uniqueIdentifierMap.get(compRec.Int_Unique_Identifier__c).Product_Position__c=compRec.Product_Position__c;
                             //uniqueIdentifierMap.get(compRec.Int_Unique_Identifier__c).Price_Effective_Date__c=compRec.Price_Effective_Date__c;
                            
                            //uniqueIdentifierMap.get(compRec.Int_Unique_Identifier__c).Supply_Effective_Date__c=compRec.Supply_Effective_Date__c;
                            
                            // system.debug('comp...'+compRec.Vision_Product__r.Phoenix_NDC_11__c);
                            
                            if( ndcmap.containskey(compRec.Vision_Product__r.Phoenix_NDC_11__c)){
                                uniqueIdentifierMap.get(compRec.Int_Unique_Identifier__c).Is_in_Openorder__c =  ndcmap.get(compRec.Vision_Product__r.Phoenix_NDC_11__c);
                            }
                            if(ndcmap.containskey(compRec.Vision_Product__r.Phoenix_NDC__c)){
                                uniqueIdentifierMap.get(compRec.Int_Unique_Identifier__c).Is_in_Openorder__c =  ndcmap.get(compRec.Vision_Product__r.Phoenix_NDc__c);
                                // uniqueIdentifierMap.get(compRec.Int_Unique_Identifier__c).Is_in_Openorder__c = true; 
                            }
                            
                            
                            
                        }
                    }   
                }  
                for(Compliance_Summary__c existingRec : [Select Id,Vision_Unique_Identifier__c from Compliance_Summary__c where Vision_Unique_Identifier__c IN: uniqueIdKeys]){
                    if(uniqueIdentifierMap.containsKey(existingRec.Vision_Unique_Identifier__c)){
                        uniqueIdentifierMap.get(existingRec.Vision_Unique_Identifier__c).Id = existingRec.Id;
                    }
                }
                
            }
               system.debug('uniqueIdentifierMap before upsert'+uniqueIdentifierMap.values());
            if(uniqueIdentifierMap.values().size()>0){
              system.debug('inside upsert');
              upsert  uniqueIdentifierMap.values();
           //Database.UpsertResult[] results = Database.upsert(uniqueIdentifierMap.values(),true);
            }
// system.debug('results===='+results);*/
          /*  List<Compliance_Summary__c> updateSummaryRec =new List<Compliance_Summary__c>();
            Integer orgFiscalMonth = [SELECT FiscalYearStartMonth FROM Organization].FiscalYearStartMonth;
            date todayDate =System.today();
            Date CurrentDate = Date.newInstance(todayDate.year(), 1, 1);
            Integer CTDDaysDue = CurrentDate.daysBetween(todayDate);
            
            system.debug('todayDate====='+todayDate);
            date currentFyscalDate = Date.newinstance(system.today().year(), 4, 1);
            Integer FTDDaysDue = currentFyscalDate.daysBetween(todayDate);
            system.debug('currentFyscalDate ====='+currentFyscalDate );
            Date Q2Date;
            List<Integer> Q1=new List<Integer>{4,5,6}; 
                List<Integer> Q2=new List<Integer>{7,8,9}; 
                    List<Integer> Q3=new List<Integer>{10,11,12};
                        List<Integer> Q4=new List<Integer>{1,2,3}; 
                            Integer QTDDaysDue;
            if(Q1.contains(system.Today().Month())){
                Q2Date = Date.newInstance(system.Today().year(), 4, 1);
                QTDDaysDue= Q2Date.daysBetween(system.Today());
            }
            if(Q2.contains(system.Today().Month())){
                Q2Date = Date.newInstance(system.Today().year(), 7, 1);
                QTDDaysDue= Q2Date.daysBetween(system.Today());
            }
            if(Q3.contains(system.Today().Month())){
                Q2Date = Date.newInstance(system.Today().year(), 10, 1);
                QTDDaysDue= Q2Date.daysBetween(system.Today());
            }
            if(Q4.contains(system.Today().Month())){
                Q2Date = Date.newInstance(system.Today().year(), 1, 1);
                QTDDaysDue= Q2Date.daysBetween(system.Today());
            }
            system.debug('QTDDaysDue==='+QTDDaysDue);
            List<String> FTDList = new List<String>();
            if(currentFyscalDate.month() < todayDate.month()){
                for(Integer i=currentFyscalDate.month();i<=todayDate.month();i++){
                    DateTime dt2 = currentFyscalDate.addmonths(i-3);
                    system.debug(dt2);
                    Integer y2 = dt2.year();
                    String yr2 = String.valueOf(y2);
                    string M2=dt2.format('MMM')+'-'+yr2.substring(2);
                    
                    FTDList.add(M2);
                    
                }
            }
            else{
                for(Integer i=0;i<=12-(currentFyscalDate.month()-todayDate.month());i++){
                    DateTime dt2 = todayDate.addmonths(-i+1);
                    system.debug(dt2);
                    Integer y2 = dt2.year();
                    String yr2 = String.valueOf(y2);
                    string M2=dt2.format('MMM')+'-'+yr2.substring(2);
                    FTDList.add(M2);
                    system.debug('M2====='+M2);
                    
                }
            }
            system.debug('FTDList====='+FTDList);
            List<String> CTDList = new List<String>();
            for(Integer i=todayDate.month()-1;i>=0;i--){
                DateTime dt2 = DateTime.now().addmonths(-i);
                system.debug(dt2);
                Integer y2 = dt2.year();
                String yr2 = String.valueOf(y2);
                string M2=dt2.format('MMM')+'-'+yr2.substring(2);
                CTDList.add(M2);
                
            }
            system.debug('uniqueIdentifierMap=='+uniqueIdentifierMap.keySet());
            for(Compliance_Summary__c qtdrec : uniqueIdentifierMap.values()){
                qtdrec.Days_Between_CTD__c = CTDDaysDue;
                qtdrec.Days_Between_FTD__c = FTDDaysDue;
                qtdrec.Days_Between_QTD__c = QTDDaysDue;
                qtdrec.QTD_Direct_Quantity__c =( qtdrec.M1_Quantity__c != null ? qtdrec.M1_Quantity__c : 0) +  (qtdrec.M2_Quantity__c != null ? qtdrec.M2_Quantity__c : 0 ) +  (qtdrec.M2_Quantity__c != null ? qtdrec.M3_Quantity__c : 0) ;
                qtdrec.QTD_Indirect_Quantity__c = (qtdrec.M1_Indirect_Quantity__c != null ? qtdrec.M1_Indirect_Quantity__c : 0 ) +  (qtdrec.M2_Indirect_Quantity__c != null ? qtdrec.M2_Indirect_Quantity__c : 0)  +  (qtdrec.M3_Indirect_Quantity__c != null ? qtdrec.M3_Indirect_Quantity__c : 0 );
                qtdrec.QTD_Total_Quantity__c = (qtdrec.M1_Total_Quantity__c != null ? qtdrec.M1_Total_Quantity__c : 0) + (qtdrec.M2_Total_Quantity__c != null ? qtdrec.M2_Total_Quantity__c : 0) +(qtdrec.M3_Total_Quantity__c != null ? qtdrec.M3_Total_Quantity__c : 0 );
                //   qtdrec.QTD_Avg_Direct_Quantity__c =  qtdrec.QTD_Direct_Quantity__c/3;
                //  qtdrec.QTD_Avg_Indirect_Quantity__c = qtdrec.QTD_Indirect_Quantity__c/3;
                // qtdrec.QTD_Avg_Total_Quantity__c = qtdrec.QTD_Total_Quantity__c/3;
                //FTD_Direct_Quantity__c
                system.debug('FTDList inside if====='+FTDList);
                system.debug('Id-----'+qtdrec.Id);
                system.debug('month 1-----'+qtdrec.Month1__c);
                system.debug('month2-----'+qtdrec.Month2__c);
                system.debug('month3-----'+qtdrec.Month3__c);
                system.debug('month4-----'+qtdrec.Month4__c);
                system.debug('month5-----'+qtdrec.Month5__c);
                system.debug('month6-----'+qtdrec.Month6__c);
                system.debug('month7-----'+qtdrec.Month7__c);
                system.debug('month8-----'+qtdrec.Month8__c);
                system.debug('month9-----'+qtdrec.Month9__c);
                system.debug('month10----'+qtdrec.Month10__c);
                system.debug('FTDList.contains(qtdrec.Month4__c)====='+FTDList.contains(qtdrec.Month4__c));
                
                qtdrec.FTD_Direct_Quantity__c = qtdrec.QTD_Direct_Quantity__c;
                if(FTDList.contains(qtdrec.Month4__c)){
                    system.debug('month 4 if-----'+qtdrec.Month4__c);
                    qtdrec.FTD_Direct_Quantity__c = qtdrec.FTD_Direct_Quantity__c+(qtdrec.M4_Quantity__c !=null ?  qtdrec.M4_Quantity__c :0);   
                    system.debug('month 4 qtdrec.FTD_Direct_Quantity__c-----'+qtdrec.FTD_Direct_Quantity__c);
                } 
                if(FTDList.contains(qtdrec.Month5__c)){
                    system.debug('month 5 if-----'+qtdrec.Month5__c);
                    qtdrec.FTD_Direct_Quantity__c = qtdrec.FTD_Direct_Quantity__c+(qtdrec.M5_Quantity__c !=null ?  qtdrec.M5_Quantity__c :0);
                    system.debug('month 4 qtdrec.FTD_Direct_Quantity__c-----'+qtdrec.FTD_Direct_Quantity__c);
                } 
                
                if(FTDList.contains(qtdrec.Month6__c)){ 
                    system.debug('month 6 if-----'+qtdrec.Month6__c);
                    qtdrec.FTD_Direct_Quantity__c = qtdrec.FTD_Direct_Quantity__c+(qtdrec.M6_Quantity__c !=null ?  qtdrec.M6_Quantity__c :0);
                    system.debug('month 4 qtdrec.FTD_Direct_Quantity__c-----'+qtdrec.FTD_Direct_Quantity__c);
                }
                if(FTDList.contains(qtdrec.Month7__c)){
                    system.debug('month 7 if-----'+qtdrec.Month7__c); 
                    qtdrec.FTD_Direct_Quantity__c = qtdrec.FTD_Direct_Quantity__c+(qtdrec.M7_Quantity__c !=null ?  qtdrec.M7_Quantity__c :0);
                    system.debug('month 4 qtdrec.FTD_Direct_Quantity__c-----'+qtdrec.FTD_Direct_Quantity__c);
                }
                if(FTDList.contains(qtdrec.Month8__c)){
                    system.debug('month 8 if-----'+qtdrec.Month8__c);
                    qtdrec.FTD_Direct_Quantity__c = qtdrec.FTD_Direct_Quantity__c+(qtdrec.M8_Quantity__c !=null ?  qtdrec.M8_Quantity__c :0);
                    system.debug('month 4 qtdrec.FTD_Direct_Quantity__c-----'+qtdrec.FTD_Direct_Quantity__c);
                }
                if(FTDList.contains(qtdrec.Month9__c)){ qtdrec.FTD_Direct_Quantity__c = qtdrec.FTD_Direct_Quantity__c+(qtdrec.M9_Quantity__c !=null ?  qtdrec.M9_Quantity__c :0);}
                if(FTDList.contains(qtdrec.Month10__c)){ qtdrec.FTD_Direct_Quantity__c = qtdrec.FTD_Direct_Quantity__c+(qtdrec.M10_Quantity__c !=null ?  qtdrec.M10_Quantity__c :0);}
                if(FTDList.contains(qtdrec.Month11__c)){ qtdrec.FTD_Direct_Quantity__c = qtdrec.FTD_Direct_Quantity__c+(qtdrec.M11_Quantity__c !=null ?  qtdrec.M11_Quantity__c :0);}
                if(FTDList.contains(qtdrec.Month12__c)){ qtdrec.FTD_Direct_Quantity__c = qtdrec.FTD_Direct_Quantity__c+(qtdrec.M12_Quantity__c !=null ?  qtdrec.M12_Quantity__c :0);}
                //FTD_Indirect_Quantity__c
                qtdrec.FTD_Indirect_Quantity__c = qtdrec.QTD_Indirect_Quantity__c;
                if(FTDList.contains(qtdrec.Month4__c)) qtdrec.FTD_Indirect_Quantity__c = qtdrec.FTD_Indirect_Quantity__c+(qtdrec.M4_Indirect_Quantity__c !=null ?  qtdrec.M4_Indirect_Quantity__c :0);
                if(FTDList.contains(qtdrec.Month5__c)) qtdrec.FTD_Indirect_Quantity__c = qtdrec.FTD_Indirect_Quantity__c+(qtdrec.M5_Indirect_Quantity__c !=null ?  qtdrec.M5_Indirect_Quantity__c :0);
                if(FTDList.contains(qtdrec.Month6__c)) qtdrec.FTD_Indirect_Quantity__c = qtdrec.FTD_Indirect_Quantity__c+(qtdrec.M6_Indirect_Quantity__c !=null ?  qtdrec.M6_Indirect_Quantity__c :0);
                if(FTDList.contains(qtdrec.Month7__c)) qtdrec.FTD_Indirect_Quantity__c = qtdrec.FTD_Indirect_Quantity__c+(qtdrec.M7_Indirect_Quantity__c !=null ?  qtdrec.M7_Indirect_Quantity__c :0);
                if(FTDList.contains(qtdrec.Month8__c)) qtdrec.FTD_Indirect_Quantity__c = qtdrec.FTD_Indirect_Quantity__c+(qtdrec.M8_Indirect_Quantity__c !=null ?  qtdrec.M8_Indirect_Quantity__c :0);
                if(FTDList.contains(qtdrec.Month9__c)) qtdrec.FTD_Indirect_Quantity__c = qtdrec.FTD_Indirect_Quantity__c+(qtdrec.M9_Indirect_Quantity__c !=null ?  qtdrec.M9_Indirect_Quantity__c :0);
                if(FTDList.contains(qtdrec.Month10__c)) qtdrec.FTD_Indirect_Quantity__c = qtdrec.FTD_Indirect_Quantity__c+(qtdrec.M10_Indirect_Quantity__c !=null ?  qtdrec.M10_Indirect_Quantity__c :0);
                if(FTDList.contains(qtdrec.Month11__c)) qtdrec.FTD_Indirect_Quantity__c = qtdrec.FTD_Indirect_Quantity__c+(qtdrec.M11_Indirect_Quantity__c !=null ?  qtdrec.M11_Indirect_Quantity__c :0);
                if(FTDList.contains(qtdrec.Month12__c)) qtdrec.FTD_Indirect_Quantity__c = qtdrec.FTD_Indirect_Quantity__c+(qtdrec.M12_Indirect_Quantity__c !=null ?  qtdrec.M12_Indirect_Quantity__c :0);
                //FTD_Total_Quantity__c
                /*  qtdrec.FTD_Total_Quantity__c = qtdrec.QTD_Total_Quantity__c;
if(FTDList.contains(qtdrec.Month4__c)) qtdrec.FTD_Total_Quantity__c = qtdrec.FTD_Total_Quantity__c+(qtdrec.M4_Total_Quantity__c !=null ?  qtdrec.M4_Total_Quantity__c :0);
if(FTDList.contains(qtdrec.Month5__c)) qtdrec.FTD_Total_Quantity__c = qtdrec.FTD_Total_Quantity__c+(qtdrec.M5_Total_Quantity__c !=null ?  qtdrec.M5_Total_Quantity__c :0);
if(FTDList.contains(qtdrec.Month6__c)) qtdrec.FTD_Total_Quantity__c = qtdrec.FTD_Total_Quantity__c+(qtdrec.M6_Total_Quantity__c !=null ?  qtdrec.M6_Total_Quantity__c :0);
if(FTDList.contains(qtdrec.Month7__c)) qtdrec.FTD_Total_Quantity__c = qtdrec.FTD_Total_Quantity__c+(qtdrec.M7_Total_Quantity__c !=null ?  qtdrec.M7_Total_Quantity__c :0);
if(FTDList.contains(qtdrec.Month8__c)) qtdrec.FTD_Total_Quantity__c = qtdrec.FTD_Total_Quantity__c+(qtdrec.M8_Total_Quantity__c !=null ?  qtdrec.M8_Total_Quantity__c :0);
if(FTDList.contains(qtdrec.Month9__c)) qtdrec.FTD_Total_Quantity__c = qtdrec.FTD_Total_Quantity__c+(qtdrec.M9_Total_Quantity__c !=null ?  qtdrec.M9_Total_Quantity__c :0);
if(FTDList.contains(qtdrec.Month10__c)) qtdrec.FTD_Total_Quantity__c = qtdrec.FTD_Total_Quantity__c+(qtdrec.M10_Total_Quantity__c !=null ?  qtdrec.M10_Total_Quantity__c :0);
if(FTDList.contains(qtdrec.Month11__c)) qtdrec.FTD_Total_Quantity__c = qtdrec.FTD_Total_Quantity__c+(qtdrec.M11_Total_Quantity__c !=null ?  qtdrec.M11_Total_Quantity__c :0);
if(FTDList.contains(qtdrec.Month12__c)) qtdrec.FTD_Total_Quantity__c = qtdrec.FTD_Total_Quantity__c+(qtdrec.M12_Total_Quantity__c !=null ?  qtdrec.M12_Total_Quantity__c :0);
//CTD_Total_Quantity__c
if(CTDList.contains(qtdrec.Month1__c)) qtdrec.CTD_Total_Quantity__c = qtdrec.CTD_Total_Quantity__c+(qtdrec.M1_Total_Quantity__c !=null ?  qtdrec.M1_Total_Quantity__c :0);
if(CTDList.contains(qtdrec.Month2__c)) qtdrec.CTD_Total_Quantity__c = qtdrec.CTD_Total_Quantity__c+(qtdrec.M2_Total_Quantity__c !=null ?  qtdrec.M2_Total_Quantity__c :0);
if(CTDList.contains(qtdrec.Month3__c)) qtdrec.CTD_Total_Quantity__c = qtdrec.CTD_Total_Quantity__c+(qtdrec.M3_Total_Quantity__c !=null ?  qtdrec.M3_Total_Quantity__c :0);
if(CTDList.contains(qtdrec.Month4__c)) qtdrec.CTD_Total_Quantity__c = qtdrec.CTD_Total_Quantity__c+(qtdrec.M4_Total_Quantity__c !=null ?  qtdrec.M4_Total_Quantity__c :0);
if(CTDList.contains(qtdrec.Month5__c)) qtdrec.CTD_Total_Quantity__c = qtdrec.CTD_Total_Quantity__c+(qtdrec.M5_Total_Quantity__c !=null ?  qtdrec.M5_Total_Quantity__c :0);
if(CTDList.contains(qtdrec.Month6__c)) qtdrec.CTD_Total_Quantity__c = qtdrec.CTD_Total_Quantity__c+(qtdrec.M6_Total_Quantity__c !=null ?  qtdrec.M6_Total_Quantity__c :0);
if(CTDList.contains(qtdrec.Month7__c)) qtdrec.CTD_Total_Quantity__c = qtdrec.CTD_Total_Quantity__c+(qtdrec.M7_Total_Quantity__c !=null ?  qtdrec.M7_Total_Quantity__c :0);
if(CTDList.contains(qtdrec.Month8__c)) qtdrec.CTD_Total_Quantity__c = qtdrec.CTD_Total_Quantity__c+(qtdrec.M8_Total_Quantity__c !=null ?  qtdrec.M8_Total_Quantity__c :0);
if(CTDList.contains(qtdrec.Month9__c)) qtdrec.CTD_Total_Quantity__c = qtdrec.CTD_Total_Quantity__c+(qtdrec.M9_Total_Quantity__c !=null ?  qtdrec.M9_Total_Quantity__c :0);
if(CTDList.contains(qtdrec.Month10__c)) qtdrec.CTD_Total_Quantity__c = qtdrec.CTD_Total_Quantity__c+(qtdrec.M10_Total_Quantity__c !=null ?  qtdrec.M10_Total_Quantity__c :0);
if(CTDList.contains(qtdrec.Month11__c)) qtdrec.CTD_Total_Quantity__c = qtdrec.CTD_Total_Quantity__c+(qtdrec.M11_Total_Quantity__c !=null ?  qtdrec.M11_Total_Quantity__c :0);
if(CTDList.contains(qtdrec.Month12__c)) qtdrec.CTD_Total_Quantity__c = qtdrec.CTD_Total_Quantity__c+(qtdrec.M12_Total_Quantity__c !=null ?  qtdrec.M12_Total_Quantity__c :0);   */
                //CTD_Indirect_Quantity__c
             /* if(CTDList.contains(qtdrec.Month1__c)){ qtdrec.CTD_Indirect_Quantity__c = qtdrec.CTD_Indirect_Quantity__c+(qtdrec.M1_Indirect_Quantity__c !=null ?  qtdrec.M1_Indirect_Quantity__c :0);}
if(CTDList.contains(qtdrec.Month2__c)){ qtdrec.CTD_Indirect_Quantity__c = qtdrec.CTD_Indirect_Quantity__c+(qtdrec.M2_Indirect_Quantity__c !=null ?  qtdrec.M2_Indirect_Quantity__c :0);
system.debug('qtdrec.CTD_Indirect_Quantity__c==='+qtdrec.CTD_Indirect_Quantity__c);
}
if(CTDList.contains(qtdrec.Month3__c)) qtdrec.CTD_Indirect_Quantity__c = qtdrec.CTD_Indirect_Quantity__c+(qtdrec.M3_Indirect_Quantity__c !=null ?  qtdrec.M3_Indirect_Quantity__c :0);
if(CTDList.contains(qtdrec.Month4__c)) qtdrec.CTD_Indirect_Quantity__c = qtdrec.CTD_Indirect_Quantity__c+(qtdrec.M4_Indirect_Quantity__c !=null ?  qtdrec.M4_Indirect_Quantity__c :0);
if(CTDList.contains(qtdrec.Month5__c)) qtdrec.CTD_Indirect_Quantity__c = qtdrec.CTD_Indirect_Quantity__c+(qtdrec.M5_Indirect_Quantity__c !=null ?  qtdrec.M5_Indirect_Quantity__c :0);
if(CTDList.contains(qtdrec.Month6__c)) qtdrec.CTD_Indirect_Quantity__c = qtdrec.CTD_Indirect_Quantity__c+(qtdrec.M6_Indirect_Quantity__c !=null ?  qtdrec.M6_Indirect_Quantity__c :0);
if(CTDList.contains(qtdrec.Month7__c)) qtdrec.CTD_Indirect_Quantity__c = qtdrec.CTD_Indirect_Quantity__c+(qtdrec.M7_Indirect_Quantity__c !=null ?  qtdrec.M7_Indirect_Quantity__c :0);
if(CTDList.contains(qtdrec.Month8__c)) qtdrec.CTD_Indirect_Quantity__c = qtdrec.CTD_Indirect_Quantity__c+(qtdrec.M8_Indirect_Quantity__c !=null ?  qtdrec.M8_Indirect_Quantity__c :0);
if(CTDList.contains(qtdrec.Month9__c)) qtdrec.CTD_Indirect_Quantity__c = qtdrec.CTD_Indirect_Quantity__c+(qtdrec.M9_Indirect_Quantity__c !=null ?  qtdrec.M9_Indirect_Quantity__c :0);
if(CTDList.contains(qtdrec.Month10__c)) qtdrec.CTD_Indirect_Quantity__c = qtdrec.CTD_Indirect_Quantity__c+(qtdrec.M10_Indirect_Quantity__c !=null ?  qtdrec.M10_Indirect_Quantity__c :0);
if(CTDList.contains(qtdrec.Month11__c)) qtdrec.CTD_Indirect_Quantity__c = qtdrec.CTD_Indirect_Quantity__c+(qtdrec.M11_Indirect_Quantity__c !=null ?  qtdrec.M11_Indirect_Quantity__c :0);
if(CTDList.contains(qtdrec.Month12__c)) qtdrec.CTD_Indirect_Quantity__c = qtdrec.CTD_Indirect_Quantity__c+(qtdrec.M12_Indirect_Quantity__c !=null ?  qtdrec.M12_Indirect_Quantity__c :0);
//CTD_Direct_Quantity__c
if(CTDList.contains(qtdrec.Month1__c)) qtdrec.CTD_Direct_Quantity__c = qtdrec.CTD_Direct_Quantity__c+(qtdrec.M1_Quantity__c !=null ?  qtdrec.M1_Quantity__c :0);
if(CTDList.contains(qtdrec.Month2__c)) qtdrec.CTD_Direct_Quantity__c = qtdrec.CTD_Direct_Quantity__c+(qtdrec.M2_Quantity__c !=null ?  qtdrec.M2_Quantity__c :0);
if(CTDList.contains(qtdrec.Month3__c)) qtdrec.CTD_Direct_Quantity__c = qtdrec.CTD_Direct_Quantity__c+(qtdrec.M3_Quantity__c !=null ?  qtdrec.M3_Quantity__c :0);
if(CTDList.contains(qtdrec.Month4__c)) qtdrec.CTD_Direct_Quantity__c = qtdrec.CTD_Direct_Quantity__c+(qtdrec.M4_Quantity__c !=null ?  qtdrec.M4_Quantity__c :0);
if(CTDList.contains(qtdrec.Month5__c)) qtdrec.CTD_Direct_Quantity__c = qtdrec.CTD_Direct_Quantity__c+(qtdrec.M5_Quantity__c !=null ?  qtdrec.M5_Quantity__c :0);
if(CTDList.contains(qtdrec.Month6__c)) qtdrec.CTD_Direct_Quantity__c = qtdrec.CTD_Direct_Quantity__c+(qtdrec.M6_Quantity__c !=null ?  qtdrec.M6_Quantity__c :0);
if(CTDList.contains(qtdrec.Month7__c)) qtdrec.CTD_Direct_Quantity__c = qtdrec.CTD_Direct_Quantity__c+(qtdrec.M7_Quantity__c !=null ?  qtdrec.M7_Quantity__c :0);
if(CTDList.contains(qtdrec.Month8__c)) qtdrec.CTD_Direct_Quantity__c = qtdrec.CTD_Direct_Quantity__c+(qtdrec.M8_Quantity__c !=null ?  qtdrec.M8_Quantity__c :0);
if(CTDList.contains(qtdrec.Month9__c)) qtdrec.CTD_Direct_Quantity__c = qtdrec.CTD_Direct_Quantity__c+(qtdrec.M9_Quantity__c !=null ?  qtdrec.M9_Quantity__c :0);
if(CTDList.contains(qtdrec.Month10__c)) qtdrec.CTD_Direct_Quantity__c = qtdrec.CTD_Direct_Quantity__c+(qtdrec.M10_Quantity__c !=null ?  qtdrec.M10_Quantity__c :0);
if(CTDList.contains(qtdrec.Month11__c)) qtdrec.CTD_Direct_Quantity__c = qtdrec.CTD_Direct_Quantity__c+(qtdrec.M11_Quantity__c !=null ?  qtdrec.M11_Quantity__c :0);
if(CTDList.contains(qtdrec.Month12__c)) qtdrec.CTD_Direct_Quantity__c = qtdrec.CTD_Direct_Quantity__c+(qtdrec.M12_Quantity__c !=null ?  qtdrec.M12_Quantity__c :0);
   updateSummaryRec.add(qtdrec);
            }
            system.debug('updateSummaryRec===='+updateSummaryRec);    
            system.debug('updateSummaryRec===='+updateSummaryRec.size());    
            if(updateSummaryRec.size()>0){
                Database.UpsertResult[] results = Database.upsert(updateSummaryRec,true);
                system.debug('results===='+results);    
            }*/
        }
        Catch(Exception e) {
            Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'Compliance_RollUP_Batch', Phoenix_Error_Message__c = e.getMessage(), Phoenix_Issue_Status__c = 'Pending', Phoenix_Method_Name__c = 'execute', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
            insert exp;
        }
    }   
    public void finish(Database.BatchableContext BC) {
         Database.executeBatch(new complianceCTDFTDdata());
    }
}