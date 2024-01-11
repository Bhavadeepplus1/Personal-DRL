public class Rx_Compliance_Indirect_Sales_Batch implements Database.Batchable < sObject >{
    public Database.QueryLocator start(Database.BatchableContext BC) {
       // delete [Select Id FROM Rx_Compliance_Summary__c WHERE CreatedDate = Today LIMIT 10000];
        String query = 'select Id,Vision_Account__c,Vision_Material_Number__c,Vision_Product__c, Vision_Contract__c, Vision_Customer_Code__c,Vision_Conversion_Quantity__c,Vision_Contract_Sales_Indirect_Price__c,Vision_Month__c,Vision_Month_Text__c,Vision_Settlement_Date_From__c,Vision_Settlement_Date_To__c from GCP_SFDC_Indirect_Sales__c';
      if(Test.isRunningTest())query += ' LIMIT 200';
        return Database.getQueryLocator(query);
        
    }
    public void execute(Database.BatchableContext BC, List < GCP_SFDC_Indirect_Sales__c > directSalesList) {
        Savepoint sp = Database.setSavepoint();
/*        try{
            RxComplainceUtility util = new RxComplainceUtility();
            
            //   List<GCP_SFDC_Indirect_Sales__c > directSalesList = [select Id,Vision_Customer_Hierarchy__c,Vision_Posting_Month__c,Vision_SAP_Material__c,Vision_Month__c,Vision_Contract_Sales_Indirect_Price__c,Vision_Agreement_No__c,Vision_Quantity_in_Units__c from GCP_SFDC_Indirect_Sales__c];
            //   List<GCP_SFDC_Indirect_Sales__c > directSalesList = [select Id,Vision_Customer_Hierarchy__c,Vision_Posting_Month__c,Vision_SAP_Material__c,Vision_Month__c,Vision_Contract_Sales_Indirect_Price__c,Vision_Agreement_No__c,Vision_Quantity_in_Units__c from GCP_SFDC_Indirect_Sales__c where Vision_Customer_Hierarchy__c='154328' AND Vision_SAP_Material__c= '300000904' AND Vision_Agreement_No__c = '1000000691' ];
            map<string,map<String,map<string,String>>> summarizedMap = new map<string,map<String,map<string,String>>>();
            map<string,map<String,string>> summarizedWeekMap = new map<string,map<String,string>>();
            map<String,Rx_Compliance_Summary__c> insertionMap = new map<String,Rx_Compliance_Summary__c>();
            Date today = Test.isRunningTest() ? Date.newInstance(2022, 04, 03) : System.today();
            String M1 = String.valueOf(today.Month()).length() == 2 ? String.valueOf(today.Month()) : '0' + today.Month();
            String M2 = String.valueOf(today.addMonths(-1).Month()).length() == 2 ? String.valueOf(today.addMonths(-1).Month()) : '0' + today.addMonths(-1).Month();
            String M3 = String.valueOf(today.addMonths(-2).Month()).length() == 2 ? String.valueOf(today.addMonths(-2).Month()) : '0' + today.addMonths(-2).Month();
            String M4 = String.valueOf(today.addMonths(-3).Month()).length() == 2 ? String.valueOf(today.addMonths(-3).Month()) : '0' + today.addMonths(-3).Month();
            String M5 = String.valueOf(today.addMonths(-4).Month()).length() == 2 ? String.valueOf(today.addMonths(-4).Month()) : '0' + today.addMonths(-4).Month();
            String M6 = String.valueOf(today.addMonths(-5).Month()).length() == 2 ? String.valueOf(today.addMonths(-5).Month()) : '0' + today.addMonths(-5).Month();
            set<String> UniqueIds = new set<String>();
            for(GCP_SFDC_Indirect_Sales__c item: directSalesList){
                String uniqueId = item.Vision_Customer_Code__c+ '-'+ item.Vision_Material_Number__c;
                UniqueIds.add(uniqueId);
                String month ;
                
                if(summarizedMap.containsKey(uniqueId)){
                    if(item.Vision_Settlement_Date_From__c.contains('/')){
                     month = item.Vision_Settlement_Date_From__c.split('/')[1];
                    }
                    else{
                      month = item.Vision_Settlement_Date_From__c.split('-')[1];  
                    }
                     map<String,map<string,String>> summarizedValueMap = summarizedMap.get(uniqueId);
                    map<String,String> summarizedUpdatedValMap = new  map<String,String>();
                    map<String,map<string,String>> summarizedUpdatedMonthMap = new  map<String,map<string,String>>();
                    map<string,String> newValuesMap = new map<string,String>();
                    map<string,String> newWeekValuesMap = new map<string,String>{'week1'=>'0','week2'=>'0','week3'=>'0','week4'=>'0','week1Value'=>'0','week2Value'=>'0','week3Value'=>'0','week4Value'=>'0'};
                        if(summarizedValueMap.containsKey(month)){
                            map<string,String> OldValuesMap = summarizedValueMap.get(month);
                            String QtyValue =  OldValuesMap.get('Quantity');
                            String NetValue =  OldValuesMap.get('NetValue');
                            string convQty ;
                            string Salesindir;
                            if(item.Vision_Conversion_Quantity__c != null && QtyValue != null)
                            {
                                
                                 Decimal QtyValueSum=  util.convStrtoDec(QtyValue)  +util.convStrtoDec(item.Vision_Conversion_Quantity__c);
                                
                              
                               // Decimal QtyValueSum =  Decimal.valueOf(QtyValue)  + Decimal.valueOf(item.Vision_Conversion_Quantity__c);
                                newValuesMap.put('Quantity',String.valueOf(QtyValueSum));
                            }
                            else{
                                newValuesMap.put('Quantity',QtyValue);
                            }
                            if(item.Vision_Contract_Sales_Indirect_Price__c != null && NetValue != null){
                               
                          
                                Decimal NetValueSum =   util.convStrtoDec(Netvalue)  + util.convStrtoDec(item.Vision_Contract_Sales_Indirect_Price__c);
                                newValuesMap.put('NetValue',String.valueOf(NetValueSum));
                            }
                            else{
                                newValuesMap.put('NetValue',NetValue);
                            }
                            newValuesMap.put('AccountName',item.Vision_Customer_Code__c);
                            newValuesMap.put('monthHeader',item.Vision_Month_Text__c);
                            //newValuesMap.put('sapMaterial',item.Vision_SAP_Material__c);  
                            //newValuesMap.put('agreementNo',item.Vision_Agreement_No__c);
                            if(item.Vision_Account__c != null){
                                newValuesMap.put('Account',String.valueOf(item.Vision_Account__c));    
                            }
                            if(item.Vision_Product__c != null){
                                newValuesMap.put('Product',String.valueOf(item.Vision_Product__c));
                            }
                            if(item.Vision_Contract__c != null){
                                newValuesMap.put('Contract',String.valueOf(item.Vision_Contract__c));
                            }
                            summarizedValueMap.put(month,newValuesMap);
                            //summarizedUpdatedMonthMap.put(month,summarizedUpdatedValMap);
                        }
                    else{
                        newValuesMap.put('NetValue',String.valueOf(item.Vision_Contract_Sales_Indirect_Price__c));
                        newValuesMap.put('Quantity',String.valueOf(item.Vision_Conversion_Quantity__c));
                        newValuesMap.put('AccountNumber',item.Vision_Customer_Code__c);
                        newValuesMap.put('monthHeader',item.Vision_Month_Text__c);
                        //newValuesMap.put('sapMaterial',item.Vision_SAP_Material__c);
                        //newValuesMap.put('agreementNo',item.Vision_Agreement_No__c);
                        newValuesMap.put('Account',item.Vision_Account__c!=null?String.valueOf(item.Vision_Account__c):null);
                        newValuesMap.put('Product',item.Vision_Product__c!=null?String.valueOf(item.Vision_Product__c):null);
                        newValuesMap.put('Contract',item.Vision_Contract__c!=null?String.valueOf(item.Vision_Contract__c):null);
                        summarizedValueMap.put(month,newValuesMap);
                    }
                    // handling week data
                    String monthCmp;
                     if(item.Vision_Settlement_Date_From__c.contains('/')){
                     monthCmp = item.Vision_Settlement_Date_From__c.split('/')[1];
                    }
                    else{
                      monthCmp = item.Vision_Settlement_Date_From__c.split('-')[1];  
                    }
                    String mon = string.valueOf(M1);
                    if(mon == monthCmp){  
                        // if(monthCmp == latestMonth){  
                        //  system.debug('latestMonth-----'+latestMonth);   
                        if(summarizedWeekMap.containsKey(uniqueId)){
                            map<string,String> oldWeekValuesMap = summarizedWeekMap.get(uniqueId);
                            Decimal Week1Quantity = decimal.valueOf(oldWeekValuesMap.get('week1'))!=null?decimal.valueOf(oldWeekValuesMap.get('week1')):0;
                            Decimal Week2Quantity =decimal.valueOf(oldWeekValuesMap.get('week2'))!=null?decimal.valueOf(oldWeekValuesMap.get('week2')):0;
                            Decimal Week3Quantity = decimal.valueOf(oldWeekValuesMap.get('week3'))!=null?decimal.valueOf(oldWeekValuesMap.get('week3')):0;
                            Decimal Week4Quantity = decimal.valueOf(oldWeekValuesMap.get('week4'))!=null?decimal.valueOf(oldWeekValuesMap.get('week4')):0;
                            Decimal Week1Value = decimal.valueOf(oldWeekValuesMap.get('week1Value'))!=null?decimal.valueOf(oldWeekValuesMap.get('week1Value')):0;
                            Decimal Week2Value = decimal.valueOf(oldWeekValuesMap.get('week2Value'))!=null?decimal.valueOf(oldWeekValuesMap.get('week2Value')):0;
                            Decimal Week3Value = decimal.valueOf(oldWeekValuesMap.get('week3Value'))!=null?decimal.valueOf(oldWeekValuesMap.get('week3Value')):0;
                            Decimal Week4Value = decimal.valueOf(oldWeekValuesMap.get('week4Value'))!=null?decimal.valueOf(oldWeekValuesMap.get('week4Value')):0;
                            Integer dateVal;
                            if(item.Vision_Settlement_Date_From__c.contains('/')){
                            dateval = integer.valueOf(item.Vision_Settlement_Date_From__c.split('/')[0]);
                            }
                            else{
                                 dateval = integer.valueOf(item.Vision_Settlement_Date_From__c.split('-')[0]);
                            }
                            Integer rem = math.mod(dateVal,7);
                            Integer Quotient = dateVal/7;
                            if(Quotient<=1 && rem == 0){
                                if(item.Vision_Conversion_Quantity__c != null
                                   && Week1Quantity != null){
                                    Week1Quantity =  Week1Quantity  + Decimal.valueOf(item.Vision_Conversion_Quantity__c);
                                    newWeekValuesMap.put('week1',string.valueOf(Week1Quantity));
                                }
                                if(item.Vision_Conversion_Quantity__c != null
                                   && Week1Value != null){
                                    Week1Value =  Week1Value  + Decimal.valueOf(item.Vision_Conversion_Quantity__c);
                                    newWeekValuesMap.put('week1Value',string.valueOf(Week1Value));
                                }
                            }
                            else if(Quotient<=2 && rem ==0){
                                if(item.Vision_Conversion_Quantity__c != null &&
                                   Week2Quantity != null){
                                    Week2Quantity =  Week2Quantity  + Decimal.valueOf(item.Vision_Conversion_Quantity__c);
                                    newWeekValuesMap.put('week2',string.valueOf(Week2Quantity));
                                }
                                if(item.Vision_Contract_Sales_Indirect_Price__c != null &&
                                   Week2Value != null){
                                    Week2Value =  Week2Value  + Decimal.valueOf(item.Vision_Contract_Sales_Indirect_Price__c);
                                    newWeekValuesMap.put('week2Value',string.valueOf(Week2Value));
                                }
                            }
                            else if(Quotient<=3 && rem ==0){
                                if(item.Vision_Conversion_Quantity__c != null && Week3Quantity != null){
                                    Week3Quantity =  Week3Quantity  + Decimal.valueOf(item.Vision_Conversion_Quantity__c);
                                    newWeekValuesMap.put('week3',string.valueOf(Week3Quantity));
                                }
                                if(item.Vision_Contract_Sales_Indirect_Price__c != null && Week3Value != null){
                                    Week3Value =  Week3Value  + Decimal.valueOf(item.Vision_Contract_Sales_Indirect_Price__c);
                                    newWeekValuesMap.put('week3Value',string.valueOf(Week3Value));
                                }
                            }
                            else if(Quotient<=4 && rem ==0){
                                if(item.Vision_Conversion_Quantity__c != null && Week4Quantity != null){
                                    Week4Quantity =  Week4Quantity  + Decimal.valueOf(item.Vision_Conversion_Quantity__c);
                                    newWeekValuesMap.put('week4',string.valueOf(Week4Quantity));
                                }
                                if(item.Vision_Contract_Sales_Indirect_Price__c != null && Week4Value != null){
                                    Week4Value =  Week4Value  + Decimal.valueOf(item.Vision_Contract_Sales_Indirect_Price__c);
                                    newWeekValuesMap.put('week4Value',string.valueOf(Week4Value));
                                }
                            }
                            // add oldweekvalues and replace them in newWeekValuesMap
                            summarizedWeekMap.put(uniqueId,newWeekValuesMap);
                        }
                    }
                }
                else{
                    system.debug('------- Conv Quantity -----------------------'+item.Vision_Conversion_Quantity__c);
                    map<string,String> summarizedInitialValueMap = new  map<string,String>{'Quantity'=>String.valueOf(item.Vision_Conversion_Quantity__c),
                        'NetValue'=>String.valueOf(item.Vision_Contract_Sales_Indirect_Price__c),
                        'AccountNumber'=>item.Vision_Customer_Code__c,
                        'monthHeader'=>item.Vision_Month_Text__c, 
                        //'sapMaterial'=>item.Vision_SAP_Material__c,
                        // 'agreementNo'=>item.Vision_Agreement_No__c,
                        'Account'=>item.Vision_Account__c!=null?String.valueOf(item.Vision_Account__c):null,
                            'Product'=>item.Vision_Product__c!=null?String.valueOf(item.Vision_Product__c):null,
                                'Contract'=>item.Vision_Contract__c!=null?String.valueOf(item.Vision_Contract__c):null
                                    };
                                        if(item.Vision_Settlement_Date_From__c != null){
                                            String latestMonth ;
                                             if(item.Vision_Settlement_Date_From__c.contains('/')){
                    latestmonth = item.Vision_Settlement_Date_From__c.split('/')[1];
                    }
                    else{
                      latestmonth = item.Vision_Settlement_Date_From__c.split('-')[1];  
                    }                 
                                            map<string,map<string,String>> summarizedsecondaryValueMap = new  map<string,map<string,String>>{latestMonth=>summarizedInitialValueMap};
                                                summarizedMap.put(uniqueId,summarizedsecondaryValueMap);
                                        }
                    // handling week data
                    map<string,String> summarizedWeekMapData = new map<string,String>{'week1'=>'0','week2'=>'0','week3'=>'0','week4'=>'0','week1Value'=>'0','week2Value'=>'0','week3Value'=>'0','week4Value'=>'0'};
                        summarizedWeekMap.put(uniqueId,summarizedWeekMapData);
                }
            }
            system.debug('summarizedMap key-----'+summarizedMap.keySet());
            system.debug('summarizedMap values-----'+summarizedMap.values());
            system.debug('summarizedWeekMap Key-----'+summarizedWeekMap.keySet());
            system.debug('summarizedWeekMap values-----'+summarizedWeekMap.values());
            List<Rx_Compliance_Summary__c> insertionList = new List<Rx_Compliance_Summary__c>();
            Map<string,Rx_Compliance_Summary__c> existingComplianerec = new Map<string,Rx_Compliance_Summary__c>();
            for(Rx_Compliance_Summary__c item:[select id,Indirect_Awarded_Position__c,Vision_Unique_Identifier__c,M1_Indirect_Net_Dollar__c,M1_Indirect_Quantity__c,M2_Indirect_Net_Dollar__c,M2_Indirect_Quantity__c,M3_Indirect_Net_Dollar__c,M3_Indirect_Quantity__c,M4_Indirect_Net_Dollar__c,M4_Indirect_Quantity__c,M5_Indirect_Net_Dollar__c,M5_Indirect_Quantity__c,M6_Indirect_Net_Dollar__c,M6_Indirect_Quantity__c from Rx_Compliance_Summary__c where Vision_Unique_Identifier__c IN:UniqueIds]){
                existingComplianerec.put(item.Vision_Unique_Identifier__c,item);
            }
            Map<string,List<Vision_Customer_Product_Tracker__c>> existingCustomerProductTrackerRecs = new Map<string,List<Vision_Customer_Product_Tracker__c>>();
            for(Vision_Customer_Product_Tracker__c cpt:[SELECT ID,Is_Initial_Order__c,Vision_Price_Effective_Date__c,Vision_Internal_Unique_Identifier__c,Vision_Awarded_Value__c,Vision_Awarded_Volume__c,Vision_Current_Product_Position__c FROM Vision_Customer_Product_Tracker__c where Vision_Contract_Type__c = 'Indirect' and Vision_Is_In_Awarded__c = true and Vision_Internal_Unique_Identifier__c IN:UniqueIds]){
                if(existingCustomerProductTrackerRecs.containsKey(cpt.Vision_Internal_Unique_Identifier__c)){    
                    existingCustomerProductTrackerRecs.get(cpt.Vision_Internal_Unique_Identifier__c).add(cpt);
                }
                else{
                    existingCustomerProductTrackerRecs.put(cpt.Vision_Internal_Unique_Identifier__c,new list<Vision_Customer_Product_Tracker__c>{cpt});
                }
            }
            system.debug('--existingCustomerProductTrackerRecs Key---'+existingCustomerProductTrackerRecs.keySet());
            system.debug('--existingCustomerProductTrackerRecs values---'+existingCustomerProductTrackerRecs.values());
            for(String key:summarizedMap.keySet()){
                Rx_Compliance_Summary__c newrec = new Rx_Compliance_Summary__c();
                if(!existingComplianerec.containsKey(key)){
                    newrec.Vision_Unique_Identifier__c = key;
                    Integer tempAwdQtyVal = 0;
                    Integer tempAwdVal = 0;
                 //   List<String> temAwdPositiondata = new List<String>();
                    set<string>  temAwdPositiondataset = new set<String>();
                    if(existingCustomerProductTrackerRecs.containsKey(key)){
                        for(Vision_Customer_Product_Tracker__c cptRec : existingCustomerProductTrackerRecs.get(key)){
                            if(cptRec.Vision_Awarded_Volume__c != null && cptRec.Vision_Awarded_Volume__c > 0)
                                tempAwdQtyVal = tempAwdQtyVal + Integer.valueOf(cptRec.Vision_Awarded_Volume__c);
                            if(cptRec.Vision_Awarded_Value__c != null && cptRec.Vision_Awarded_Value__c > 0)
                                tempAwdVal = tempAwdVal + Integer.valueOf(cptRec.Vision_Awarded_Value__c);
                            if(cptRec.Vision_Current_Product_Position__c != null){
                                temAwdPositiondataset.add(cptRec.Vision_Current_Product_Position__c);
                            
                             
                            }
                            if(cptRec.Is_Initial_Order__c == true)
                            	newrec.Is_Initial_Order__c = cptRec.Is_Initial_Order__c;
                            if(cptRec.Vision_Price_Effective_Date__c != null)
                                newrec.Vision_Price_Effective_Date__c =cptRec.Vision_Price_Effective_Date__c;
                        }
                        newrec.Vision_Indirect_Awarded_Qty__c = tempAwdQtyVal;
                        newrec.Vision_Indirect_Awarded_Value__c = tempAwdVal;
                        if(temAwdPositiondataset.size() > 0){
                            List<String> temAwdPositiondata = new List<String>(temAwdPositiondataset);
                            
                        	newrec.Indirect_Awarded_Position__c = '\'' + String.join(temAwdPositiondata, '\',\'') + '\'';
                            newrec.Awarded_Position__c = '\'' + String.join(temAwdPositiondata, '\',\'') + '\'';
                        }
                    }
                    
                    map<String,map<string,String>> summarySecondMap = new map<String,map<string,String>>();
                    summarySecondMap=summarizedMap.get(key);
                    map<String,string> summaryseconWeekMap = summarizedWeekMap.get(key);
                    for(String key2:summarySecondMap.keySet()){
                        map<string,String> summaryThirdMap = summarySecondMap.get(key2);
                        system.debug('key2---'+key2);
                        system.debug('m1----'+m1);
                        if(key2==string.valueOf(M1)){
                            if(summaryseconWeekMap.get('week1') != '0'){
                                newrec.Week1_Indirect_Actual_Qty__c = util.convStrtoDec(summaryseconWeekMap.get('week1'));
                            }
                            if(summaryseconWeekMap.get('week2') != '0'){
                                newrec.Week2_Indirect_Actual_Qty__c = util.convStrtoDec(summaryseconWeekMap.get('week2'));
                            }
                            if(summaryseconWeekMap.get('week3') != '0'){
                                newrec.Week3_Indirect_Actual_Qty__c =util.convStrtoDec(summaryseconWeekMap.get('week3'));
                            }
                            if(summaryseconWeekMap.get('week4') != '0'){
                                newrec.Week4_Indirect_Actual_Qty__c = util.convStrtoDec(summaryseconWeekMap.get('week4'));
                            }
                            if(summaryseconWeekMap.get('week1Value') != '0'){
                                newrec.Week1_Indirect_Actual_Value__c = util.convStrtoDec(summaryseconWeekMap.get('week2Value'));
                                
                            }
                            if(summaryseconWeekMap.get('week2Value') != '0'){
                                newrec.Week2_Indirect_Actual_Value__c = util.convStrtoDec(summaryseconWeekMap.get('week2Value'));
                                
                            }
                            if(summaryseconWeekMap.get('week3Value') != '0'){
                                newrec.Week3_Indirect_Actual_Value__c = util.convStrtoDec(summaryseconWeekMap.get('week3Value'));
                                
                            }
                            if(summaryseconWeekMap.get('week4Value') != '0'){
                                newrec.Week4_Indirect_Actual_Value__c = util.convStrtoDec(summaryseconWeekMap.get('week4sValue'));
                                
                            }
                            if(summaryThirdMap.get('NetValue') != null)
                            {
                                newrec.M1_Indirect_Net_Dollar__c = util.convStrtoDec(summaryThirdMap.get('NetValue'));
                            }
                            else{
                                newrec.M1_Indirect_Net_Dollar__c = null;
                            }
                            if(summaryThirdMap.get('Quantity') != null)
                            {
                                newrec.M1_Indirect_Quantity__c = util.convStrtoDec(summaryThirdMap.get('Quantity'));
                            }
                            else{
                                newrec.M1_Indirect_Quantity__c = null;
                            }
                            //    newrec.Month1__c = summaryThirdMap.get('monthHeader');
                        }
                        else if(key2==string.valueOf(M2)){
                            if(summaryThirdMap.get('NetValue') != null)
                            {
                                newrec.M2_Indirect_Net_Dollar__c = util.convStrtoDec(summaryThirdMap.get('NetValue'));
                            }
                            else{
                                newrec.M2_Indirect_Net_Dollar__c = null;
                            }
                            if(summaryThirdMap.get('Quantity') != null)
                            {
                                newrec.M2_Indirect_Quantity__c = util.convStrtoDec(summaryThirdMap.get('Quantity'));
                            }
                            else{
                                newrec.M2_Indirect_Quantity__c = null;
                            }
                            //    newrec.Month2__c = summaryThirdMap.get('monthHeader');
                            
                        }
                        else if(key2==string.valueOf(M3)){
                            if(summaryThirdMap.get('NetValue') != null)
                            {
                                newrec.M3_Indirect_Net_Dollar__c = util.convStrtoDec(summaryThirdMap.get('NetValue'));
                            }
                            else{
                                newrec.M3_Indirect_Net_Dollar__c = null;
                            }
                            if(summaryThirdMap.get('Quantity') != null)
                            {
                                newrec.M3_Indirect_Quantity__c = util.convStrtoDec(summaryThirdMap.get('Quantity'));
                            }
                            else{
                                newrec.M3_Indirect_Quantity__c = null;
                            }
                            //  newrec.Month3__c = summaryThirdMap.get('monthHeader');
                            
                        }
                        else if(key2==string.valueOf(M4)){
                            if(summaryThirdMap.get('NetValue') != null)
                            {
                                newrec.M4_Indirect_Net_Dollar__c = util.convStrtoDec(summaryThirdMap.get('NetValue'));
                            }
                            else{
                                newrec.M4_Indirect_Net_Dollar__c = null;  
                            }
                            if(summaryThirdMap.get('Quantity') != null)
                            {
                                newrec.M4_Indirect_Quantity__c = util.convStrtoDec(summaryThirdMap.get('Quantity'));
                            }
                            else{
                                newrec.M4_Indirect_Quantity__c = null;
                            }
                            //     newrec.Month4__c = summaryThirdMap.get('monthHeader');
                            
                        }
                        else if(key2==string.valueOf(M5)){
                            if(summaryThirdMap.get('NetValue') != null)
                            {
                                newrec.M5_Indirect_Net_Dollar__c = util.convStrtoDec(summaryThirdMap.get('NetValue'));
                            }
                            else{
                                newrec.M5_Indirect_Net_Dollar__c = null;
                            }
                            if(summaryThirdMap.get('Quantity') != null)
                            {
                                newrec.M5_Indirect_Quantity__c = util.convStrtoDec(summaryThirdMap.get('Quantity'));
                            }
                            else{
                                newrec.M5_Indirect_Quantity__c = null; 
                            }
                            //  newrec.Month5__c = summaryThirdMap.get('monthHeader');
                            
                        }
                        else if(key2==string.valueOf(M6)){
                            if(summaryThirdMap.get('NetValue') != null)
                            {
                                newrec.M6_Indirect_Net_Dollar__c = util.convStrtoDec(summaryThirdMap.get('NetValue'));
                            }
                            else{
                                newrec.M6_Indirect_Net_Dollar__c = null;
                            }
                            if(summaryThirdMap.get('Quantity') != null)
                            {
                                newrec.M6_Indirect_Quantity__c = util.convStrtoDec(summaryThirdMap.get('Quantity'));
                            }
                            else{
                                newrec.M6_Indirect_Quantity__c = null;
                            }
                            //  newrec.Month6__c = summaryThirdMap.get('monthHeader');
                            
                        }
                        if(summaryThirdMap.get('AccountNumber') != null)
                            newrec.Vision_Customer_Hierarchy__c = summaryThirdMap.get('AccountNumber');
                        if(summaryThirdMap.get('agreementNo') != null)
                            newrec.Vision_Agreement_No__c = summaryThirdMap.get('agreementNo');
                        if(summaryThirdMap.get('sapMaterial') != null)
                            newrec.Vision_SAP_Material__c = summaryThirdMap.get('sapMaterial');
                        if(summaryThirdMap.get('Account') != null)
                            newrec.Vision_Account__c = summaryThirdMap.get('Account');
                        if(summaryThirdMap.get('Product') != null)
                            newrec.Vision_Product__c = summaryThirdMap.get('Product');
                        if(summaryThirdMap.get('Contract') != null)
                            newrec.Vision_Contract_Updated__c = summaryThirdMap.get('Contract');
                        system.debug('---- Key -----'+key+'-'+key2);
                    }
                    insertionMap.put(key,newrec);
                    system.debug('insertionMap-----------------------'+insertionMap.values());
                }
                else{
                    map<String,map<string,String>> summarySecondMap = summarizedMap.get(key);
                    Integer tempAwdQtyVal = 0;
                    Integer tempAwdVal = 0;
                  //  List<String> temAwdPositiondata = new List<String>();
                  set<string>  temAwdPositiondataset = new set<String>();
                    if(existingCustomerProductTrackerRecs.containsKey(key)){
                        for(Vision_Customer_Product_Tracker__c cptRec : existingCustomerProductTrackerRecs.get(key)){
                            if(cptRec.Vision_Awarded_Volume__c != null && cptRec.Vision_Awarded_Volume__c > 0)
                                tempAwdQtyVal = tempAwdQtyVal + Integer.valueOf(cptRec.Vision_Awarded_Volume__c);
                            if(cptRec.Vision_Awarded_Value__c != null && cptRec.Vision_Awarded_Value__c > 0)
                                tempAwdVal = tempAwdVal + Integer.valueOf(cptRec.Vision_Awarded_Value__c);
                            
                            if(cptRec.Vision_Current_Product_Position__c != null){
                                temAwdPositiondataset.add(cptRec.Vision_Current_Product_Position__c);
                                if(existingComplianerec.containsKey(key)){
                                    if(existingComplianerec.get(key).Indirect_Awarded_Position__c != null)
                                   		temAwdPositiondataset.add(existingComplianerec.get(key).Indirect_Awarded_Position__c);
                                }
                            }
                            if(cptRec.Is_Initial_Order__c == true)
                            	newrec.Is_Initial_Order__c = cptRec.Is_Initial_Order__c;
                            if(cptRec.Vision_Price_Effective_Date__c != null)
                                newrec.Vision_Price_Effective_Date__c =cptRec.Vision_Price_Effective_Date__c;
                        
                            
                        }
                        newrec.Vision_Indirect_Awarded_Qty__c = tempAwdQtyVal;
                        newrec.Vision_Indirect_Awarded_Value__c = tempAwdVal;
                        if(temAwdPositiondataset.size() > 0){
                             List<String> temAwdPositiondata = new List<String>(temAwdPositiondataset);
                            
                        	newrec.Indirect_Awarded_Position__c = '\'' + String.join(temAwdPositiondata, '\',\'') + '\'';
                            newrec.Awarded_Position__c = '\'' + String.join(temAwdPositiondata, '\',\'') + '\'';
                        }
                    }
                    for(String key2:summarySecondMap.keySet()){
                        map<string,String> summaryThirdMap = summarySecondMap.get(key2);
                        system.debug('------summaryThirdMap--------------------'+summaryThirdMap);
                        map<string,String> summaryseconWeekMap  = summarizedWeekMap.get(key); 
                        
                        if(key2==string.valueOf(M1)){
                            system.debug('Existing Rec Unique M1 ----'+summaryThirdMap.get('Quantity'));
                            if(summaryseconWeekMap.get('week1') != '0'){
                                newrec.Week1_Indirect_Actual_Qty__c = util.convStrtoDec(summaryseconWeekMap.get('week1'));
                                
                            }
                            if(summaryseconWeekMap.get('week2') != '0'){
                                newrec.Week2_Indirect_Actual_Qty__c = util.convStrtoDec(summaryseconWeekMap.get('week2'));
                                
                            }
                            if(summaryseconWeekMap.get('week3') != '0'){
                                newrec.Week3_Indirect_Actual_Qty__c = util.convStrtoDec(summaryseconWeekMap.get('week3'));
                                
                            }
                            if(summaryseconWeekMap.get('week4') != '0'){
                                newrec.Week4_Indirect_Actual_Qty__c = util.convStrtoDec(summaryseconWeekMap.get('week4'));
                                
                            }
                            if(summaryseconWeekMap.get('week1Value') != '0'){
                                newrec.Week1_Indirect_Actual_Value__c = util.convStrtoDec(summaryseconWeekMap.get('week2Value'));
                                
                            }
                            if(summaryseconWeekMap.get('week2Value') != '0'){
                                newrec.Week2_Indirect_Actual_Value__c = util.convStrtoDec(summaryseconWeekMap.get('week2Value'));
                                
                            }
                            if(summaryseconWeekMap.get('week3Value') != '0'){
                                newrec.Week3_Indirect_Actual_Value__c = util.convStrtoDec(summaryseconWeekMap.get('week3Value'));
                                
                            }
                            if(summaryseconWeekMap.get('week4Value') != '0'){
                                newrec.Week4_Indirect_Actual_Value__c = util.convStrtoDec(summaryseconWeekMap.get('week4sValue'));
                                
                            }
                            if(summaryThirdMap.get('NetValue') != null)
                            {
                                newrec.M1_Indirect_Net_Dollar__c = util.convStrtoDec(summaryThirdMap.get('NetValue'));
                            }
                            else{
                                newrec.M1_Indirect_Net_Dollar__c = null;
                            }
                            if(summaryThirdMap.get('Quantity') != null)
                            {
                                newrec.M1_Indirect_Quantity__c = util.convStrtoDec(summaryThirdMap.get('Quantity'));
                            }
                            else{
                                newrec.M1_Indirect_Quantity__c = null; 
                            }
                            //     newrec.Month1__c = summaryThirdMap.get('monthHeader');
                        }
                        else if(key2==string.valueOf(M2)){
                            system.debug('Existing Rec Unique M2 ----'+summaryThirdMap.get('Quantity'));
                            if(summaryThirdMap.get('NetValue') != null)
                            {
                                newrec.M2_Indirect_Net_Dollar__c = util.convStrtoDec(summaryThirdMap.get('NetValue'));
                            }
                            else{
                                newrec.M2_Indirect_Net_Dollar__c = null; 
                            }
                            if(summaryThirdMap.get('Quantity') != null)
                            {
                                newrec.M2_Indirect_Quantity__c = util.convStrtoDec(summaryThirdMap.get('Quantity'));
                            }
                            else{
                                newrec.M2_Indirect_Quantity__c = null; 
                            }
                            //    newrec.Month2__c = summaryThirdMap.get('monthHeader');
                            
                        }
                        else if(key2==string.valueOf(M3)){
                            system.debug('Existing Rec Unique M3 ----'+summaryThirdMap.get('Quantity'));
                            if(summaryThirdMap.get('NetValue') != null)
                            {
                                newrec.M3_Indirect_Net_Dollar__c = util.convStrtoDec(summaryThirdMap.get('NetValue'));
                            }
                            else{
                                newrec.M3_Indirect_Net_Dollar__c = null; 
                            }
                            if(summaryThirdMap.get('Quantity') != null)
                            {
                                newrec.M3_Indirect_Quantity__c = util.convStrtoDec(summaryThirdMap.get('Quantity'));
                                system.debug('working'+newrec.M3_Indirect_Quantity__c);
                            }
                            else{
                                newrec.M3_Indirect_Quantity__c = null;
                            }
                            
                        }
                        else if(key2==string.valueOf(M4)){
                            system.debug('Existing Rec Unique M4 ----'+summaryThirdMap.get('Quantity'));
                            if(summaryThirdMap.get('NetValue') != null)
                            {
                                newrec.M4_Indirect_Net_Dollar__c = util.convStrtoDec(summaryThirdMap.get('NetValue'));
                            }
                            else{
                                newrec.M4_Indirect_Net_Dollar__c = null;
                            }
                            if(summaryThirdMap.get('Quantity') != null)
                            {
                                newrec.M4_Indirect_Quantity__c = util.convStrtoDec(summaryThirdMap.get('Quantity'));
                            }
                            else{
                                newrec.M4_Indirect_Quantity__c = null;
                            }
                            //   newrec.Month4__c = summaryThirdMap.get('monthHeader');
                            
                        }
                        else if(key2==string.valueOf(M5)){
                            system.debug('Existing Rec Unique M5 ----'+summaryThirdMap.get('Quantity'));
                            if(summaryThirdMap.get('NetValue') != null)
                            {
                                newrec.M5_Indirect_Net_Dollar__c = util.convStrtoDec(summaryThirdMap.get('NetValue'));
                            }
                            else{
                                newrec.M5_Indirect_Net_Dollar__c = null;
                            }
                            if(summaryThirdMap.get('Quantity') != null)
                            {
                                newrec.M5_Indirect_Quantity__c = util.convStrtoDec(summaryThirdMap.get('Quantity'));
                            }
                            else{
                                newrec.M5_Indirect_Quantity__c = null;
                            }
                            //   newrec.Month5__c = summaryThirdMap.get('monthHeader');
                            
                        }
                        else if(key2==string.valueOf(M6)){
                            system.debug('Existing Rec Unique M6 ----'+summaryThirdMap.get('Quantity'));
                            if(summaryThirdMap.get('NetValue') != null)
                            {
                                newrec.M6_Indirect_Net_Dollar__c = util.convStrtoDec(summaryThirdMap.get('NetValue'));
                            }
                            else{
                                newrec.M6_Indirect_Net_Dollar__c = null;
                            }
                            if(summaryThirdMap.get('Quantity') != null)
                            {
                                newrec.M6_Indirect_Quantity__c = util.convStrtoDec(summaryThirdMap.get('Quantity'));
                            }
                            else{
                                newrec.M6_Indirect_Quantity__c = null; 
                            }
                            //   newrec.Month6__c = summaryThirdMap.get('monthHeader');
                            
                        }
                        if(summaryThirdMap.get('AccountNumber') != null)
                            newrec.Vision_Customer_Hierarchy__c = summaryThirdMap.get('AccountNumber');
                        if(summaryThirdMap.get('agreementNo') != null)
                            newrec.Vision_Agreement_No__c = summaryThirdMap.get('agreementNo');
                        if(summaryThirdMap.get('sapMaterial') != null)
                            newrec.Vision_SAP_Material__c = summaryThirdMap.get('sapMaterial');
                        if(summaryThirdMap.get('Account') != null)
                            newrec.Vision_Account__c = summaryThirdMap.get('Account');
                        if(summaryThirdMap.get('Product') != null)
                            newrec.Vision_Product__c = summaryThirdMap.get('Product');
                        if(summaryThirdMap.get('Contract') != null)
                            newrec.Vision_Contract_Updated__c = summaryThirdMap.get('Contract');
                        newrec.Id = existingComplianerec.get(key).Id;
                    }
                    insertionMap.put(key,newrec);
                    system.debug('insertionMap-----------------------'+insertionMap.values());
                    
                }
                
            }
            
            if(insertionMap.values().size()>0)
                upsert insertionMap.values();  
        }
        catch (Exception e) {
            //Database.rollback(sp);
            Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'Rx_Compliance_Indirect_Sales_Batch', Phoenix_Error_Message__c = e.getMessage(), Phoenix_Issue_Status__c = 'Pending', Phoenix_Method_Name__c = 'execute', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
            insert exp;
            
        } */
    }
    
    public void finish(Database.BatchableContext BC) {}
}