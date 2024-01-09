public class Vision_DoH_Summary_Batch implements Database.Batchable < sObject > {
    public Database.QueryLocator start(Database.BatchableContext BC) {
        delete [Select Id FROM DoH_Summary__c WHERE CreatedDate != Today LIMIT 10000];
         String query = 'Select Vision_Product__r.Phoenix_Rx_SRx_OTC__c, '+Phoenix_Util.getsObjectFieds('GCP_Trade_Partner_DOH_Report__c')+' from GCP_Trade_Partner_DOH_Report__c';
        return Database.getQueryLocator(query);
    }
    public void execute(Database.BatchableContext BC, List < GCP_Trade_Partner_DOH_Report__c > listOfDOHRecords) {
        try{
            Map<String,DoH_Summary__c> uniqueIdentifierMap = new  Map<String,DoH_Summary__c>();
            set<String> uniqueIdsSet = new set<String>();
            for(GCP_Trade_Partner_DOH_Report__c dohrec : listOfDOHRecords){
                uniqueIdsSet.add(dohrec.Unique_Child_Identifier__c);
            }
            if(uniqueIdsSet.size() > 0){
                String query = 'SELECT Package_Description__c ,Trade_Partner_Name__c,Sum(W1_QOH__c) qoh1,Sum(W1_QTY_Sold__c) qtySold1,Sum(Value_W1__c) value1,Sum(W2_QOH__c) qoh2,Sum(W2_QTY_Sold__c) qtySold2,Sum(Value_W2__c) value2,Sum(W3_QOH__c) qoh3,Sum(W3_QTY_Sold__c) qtySold3,Sum(Value_W3__c) value3,Sum(W4_QOH__c) qoh4,Sum(W4_QTY_Sold__c) qtySold4,Sum(Value_W4__c) value4,Sum(W5_QOH__c) qoh5,Sum(W5_QTY_Sold__c) qtySold5,Sum(Value_W5__c) value5,Sum(W6_QOH__c) qoh6,Sum(W6_QTY_Sold__c) qtySold6,Sum(Value_W6__c) value6,Sum(W7_QOH__c) qoh7,Sum(W7_QTY_Sold__c) qtySold7,Sum(Value_W7__c) value7,Sum(W8_QOH__c) qoh8,Sum(W8_QTY_Sold__c) qtySold8,Sum(Value_W8__c) value8 FROM GCP_Trade_Partner_DOH_Report__c WHERE Unique_Child_Identifier__c In: uniqueIdsSet GROUP BY Package_Description__c,Trade_Partner_Name__c';
                List<GCP_DOH_Trade_Partner_NDC__c> ndcList=[Select Id,vision_gcp_ndc__c,vision_gcp_package_description__c,vision_gcp_trade_partner_name__c From GCP_DOH_Trade_Partner_NDC__c LIMIT 50000];
                Map<String,Id> ndcMap=new Map<String,Id>(); 
              //  System.debug('ndcList size'+ndcList.size());
                for(GCP_DOH_Trade_Partner_NDC__c ndcRec:ndcList){
                    String keyName=ndcRec.vision_gcp_trade_partner_name__c+'_'+ndcRec.vision_gcp_ndc__c;
                    ndcMap.put(keyName,ndcRec.Id);
                    
                }
                List<AggregateResult> AggregateResultList = Database.query(query);
                //set<string> uniqueIdentifierSet =new set<string>();
                
               // system.debug('AggregateResultList-----'+AggregateResultList);
             //   system.debug('AggregateResultList-----'+AggregateResultList.size());
                List<DoH_Summary__c> dohList = new List<DoH_Summary__c>();
                set<String> uniqueIdKeys = new set<String>();
                for(AggregateResult aggr : AggregateResultList){
                    DoH_Summary__c doh = new DoH_Summary__c();
                    String uniqueTradeName=(String) aggr.get('Trade_Partner_Name__c')+'_'+(String) aggr.get('Package_Description__c');
                    doh.Trade_Partner_Name__c =  (String) aggr.get('Trade_Partner_Name__c');
                    doh.Package_Description__c =  (String) aggr.get('Package_Description__c');
                    System.debug('uniqueTradeName>>'+uniqueTradeName);
                    doh.Vision_Unique_Identifier__c = uniqueTradeName;
                    doh.W1_QOH__c = (Decimal) aggr.get('qoh1');
                    doh.W1_QTY_Sold__c = (Decimal) aggr.get('qtySold1');
                    doh.Value_W1__c = (Decimal) aggr.get('value1');
                    doh.W2_QOH__c = (Decimal) aggr.get('qoh2');
                    doh.W2_QTY_Sold__c = (Decimal) aggr.get('qtySold2');
                    doh.Value_W2__c = (Decimal) aggr.get('value2');
                    doh.W3_QOH__c = (Decimal) aggr.get('qoh3');
                    doh.W3_QTY_Sold__c = (Decimal) aggr.get('qtySold3');
                    doh.Value_W3__c = (Decimal) aggr.get('value3');
                    doh.W4_QOH__c = (Decimal) aggr.get('qoh4');
                    doh.W4_QTY_Sold__c = (Decimal) aggr.get('qtySold4');
                    doh.Value_W4__c = (Decimal) aggr.get('value4');  
                    doh.W5_QOH__c = (Decimal) aggr.get('qoh5');
                    doh.W5_QTY_Sold__c = (Decimal) aggr.get('qtySold5');
                    doh.Value_W5__c = (Decimal) aggr.get('value5');
                    doh.W6_QOH__c = (Decimal) aggr.get('qoh6');
                    doh.W6_QTY_Sold__c = (Decimal) aggr.get('qtySold6');
                    doh.Value_W6__c = (Decimal) aggr.get('value6');
                    doh.W7_QOH__c = (Decimal) aggr.get('qoh7');
                    doh.W7_QTY_Sold__c = (Decimal) aggr.get('qtySold7');
                    doh.Value_W7__c = (Decimal) aggr.get('value7');
                    doh.W8_QOH__c = (Decimal) aggr.get('qoh8');
                    doh.W8_QTY_Sold__c = (Decimal) aggr.get('qtySold8');
                    doh.Value_W8__c = (Decimal) aggr.get('value8');
                    uniqueIdentifierMap.put(uniqueTradeName,doh);
                    uniqueIdKeys.add(uniqueTradeName);
                    //dohList.add(doh);
                    //System.debug('doh>>>'+doh);
                }
                
                //	List < GCP_Trade_Partner_DOH_Report__c > listOfDOHRecords = [SELECT Unique_Child_Identifier__c,Trade_Partner_Name__c,NDC__c,WAC_Price__c,Vision_Product__r.Phoenix_Rx_SRx_OTC__c FROM GCP_Trade_Partner_DOH_Report__c WHERE Unique_Child_Identifier__c IN: tempUniqIDKeysMap1 limit 10000]; 
                if(listOfDOHRecords.size() > 0){
                    for(GCP_Trade_Partner_DOH_Report__c dohrec : listOfDOHRecords){
                        if(uniqueIdentifierMap.containsKey(dohrec.Unique_Child_Identifier__c)){
                            String uniqueNdc = dohrec.Trade_Partner_Name__c+'_'+dohrec.NDC__c;
                            uniqueIdentifierMap.get(dohrec.Unique_Child_Identifier__c).WAC_Price__c = dohrec.WAC_Price__c; 
                            uniqueIdentifierMap.get(dohrec.Unique_Child_Identifier__c).Vision_Segment__c= dohrec.Vision_Product__r.Phoenix_Rx_SRx_OTC__c;
                            uniqueIdentifierMap.get(dohrec.Unique_Child_Identifier__c).NDC__c= dohrec.NDC__c;
                            uniqueIdentifierMap.get(dohrec.Unique_Child_Identifier__c).GCP_DOH_Trade_Partner_NDC__c=ndcMap.get(uniqueNdc);
                        }
                    }   
                }  
                
                //dohList.addAll(uniqueIdentifierMap.values());
                
                for(DoH_Summary__c existingRec : [Select Id,Vision_Unique_Identifier__c from DoH_Summary__c where Vision_Unique_Identifier__c IN: uniqueIdKeys]){
                    if(uniqueIdentifierMap.containsKey(existingRec.Vision_Unique_Identifier__c)){
                        uniqueIdentifierMap.get(existingRec.Vision_Unique_Identifier__c).Id = existingRec.Id;
                    }
                }
                
                /*String existingQuery = 'Select Vision_Unique_Identifier__c from DoH_Summary__c where Vision_Unique_Identifier__c IN: uniqueIdKeys';
                list<DoH_Summary__c> existingDOHRecords = Database.query(existingQuery);
                if(existingDOHRecords.size() > 0){
                    for(String key : uniqueIdentifierMap.keySet()){
                        for(DoH_Summary__c existingRec : Database.query(existingQuery)){
                            if(!(existingRec.Vision_Unique_Identifier__c == key))
                                insertionMap.put(key,uniqueIdentifierMap.get(key));
                        }
                    }
                }
                else{
                    insertionList.add(uniqueIdentifierMap.values());
                    //insertionMap.put(key,uniqueIdentifierMap.values());
                }*/
                
                
            }
            if(uniqueIdentifierMap.values().size()>0)
                upsert uniqueIdentifierMap.values();
        }
        Catch(Exception e) {
            Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'Vision_DoH_Summary_Batch', Phoenix_Error_Message__c = e.getMessage(), Phoenix_Issue_Status__c = 'Pending', Phoenix_Method_Name__c = 'execute', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
            insert exp;
        }
          /*  else{
                Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'Vision_DoH_Summary_Batch', Phoenix_Error_Message__c = 'UniqueIdSet List is Empty', Phoenix_Issue_Status__c = 'Pending', Phoenix_Method_Name__c = 'execute', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = null, Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
                insert exp;  
            }*/
        }
        /*Catch(Exception e) {
            Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'Vision_DoH_Summary_Batch', Phoenix_Error_Message__c = e.getMessage(), Phoenix_Issue_Status__c = 'Pending', Phoenix_Method_Name__c = 'execute', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
            insert exp;
        }*/
    
    public void finish(Database.BatchableContext BC) {}
}