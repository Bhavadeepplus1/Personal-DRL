public class Rx_Compliance_Direct_Sales_Summary_Batch implements Database.Batchable < sObject >{
    public Database.QueryLocator start(Database.BatchableContext BC) {
       delete [Select Id FROM Rx_Compliance_Summary__c WHERE CreatedDate != Today LIMIT 10000];
        String query = 'SELECT ID FROM Account LIMIT 1';
        string num='370741';
        return Database.getQueryLocator([select Id,Vision_Account__c,Vision_Product__c,Vision_Contract__c,Vision_Customer_Hierarchy__c,Vision_Posting_Month__c,Vision_SAP_Material__c,Vision_Month__c,Vision_Month_Text__c,Vision_Net_Dollar__c,Vision_Agreement_No__c,Vision_Quantity_in_Units__c,Vision_Quantity__c,Vision_Billing_Date__c from GCP_SFDC_Direct_Sales__c  ]);// where Vision_Customer_Hierarchy__c='115596' and Vision_SAP_Material__c='300018604' and Vision_Posting_Month__c ='1']);
        
    }
    public void execute(Database.BatchableContext BC, List < GCP_SFDC_Direct_Sales__c > directSalesList) {
     /*   try{
             RxComplainceUtility util = new  RxComplainceUtility();
            map<string,map<String,map<string,String>>> summarizedMap = new map<string,map<String,map<string,String>>>();
            map<string,map<String,string>> summarizedWeekMap = new map<string,map<String,string>>();
            map<String,Rx_Compliance_Summary__c> insertionMap = new map<String,Rx_Compliance_Summary__c>();
            Date today = System.today();
            Integer M1 = today.Month();
            Integer M2 = today.addMonths(-1).Month();
            Integer M3 = today.addMonths(-2).Month();
            Integer M4= today.addMonths(-3).Month();
            Integer M5 = today.addMonths(-4).Month();
            Integer M6 = today.addMonths(-5).Month();
            Integer M7 = today.addMonths(-6).Month();
            Integer M8 = today.addMonths(-7).Month();

            set<String> UniqueIds = new set<String>();
            for(GCP_SFDC_Direct_Sales__c item: directSalesList){
                String uniqueId = item.Vision_Customer_Hierarchy__c + '-'+ item.Vision_SAP_Material__c;
                UniqueIds.add(uniqueId);
               
                if(summarizedMap.containsKey(uniqueId)){
                    String month = string.valueOf(item.Vision_Posting_Month__c);
                    
                    map<String,map<string,String>> summarizedValueMap = summarizedMap.get(uniqueId);
                    map<String,String> summarizedUpdatedValMap = new  map<String,String>();
                    map<String,map<string,String>> summarizedUpdatedMonthMap = new  map<String,map<string,String>>();
                    map<string,String> newValuesMap = new map<string,String>();
                    map<string,String> newWeekValuesMap = new map<string,String>{'week1'=>'0','week2'=>'0','week3'=>'0','week4'=>'0','week1Value'=>'0','week2Value'=>'0','week3Value'=>'0','week4Value'=>'0'};
                  
                        if(summarizedValueMap.containsKey(month)){
                        map<string,String> OldValuesMap = summarizedValueMap.get(month);
                        String QtyValue =  OldValuesMap.get('Quantity');
                        String NetValue =  OldValuesMap.get('NetValue');

                        if(item.Vision_Quantity__c != null && QtyValue != null)
                        {
                            Decimal QtyValueSum = util.convStrtoDec(QtyValue)  + util.convStrtoDec(item.Vision_Quantity__c);
                            newValuesMap.put('Quantity',String.valueOf(QtyValueSum));
                        }
                        else{
                            newValuesMap.put('Quantity',QtyValue);
                        }
                        if(item.Vision_Net_Dollar__c != null && NetValue != null){
                            Decimal NetValueSum =   util.convStrtoDec(NetValue)  + util.convStrtoDec(item.Vision_Net_Dollar__c);
                            newValuesMap.put('NetValue',String.valueOf(NetValueSum));
                        }
                        else{
                            newValuesMap.put('NetValue',NetValue);
                        }
                        newValuesMap.put('AccountName',item.Vision_Customer_Hierarchy__c);
                        newValuesMap.put('monthHeader',item.Vision_Month_Text__c);
                        newValuesMap.put('sapMaterial',item.Vision_SAP_Material__c);  
                        newValuesMap.put('agreementNo',item.Vision_Agreement_No__c);
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
                        newValuesMap.put('NetValue',String.valueOf(item.Vision_Net_Dollar__c));
                        newValuesMap.put('Quantity',String.valueOf(item.Vision_Quantity__c));
                        newValuesMap.put('AccountNumber',item.Vision_Customer_Hierarchy__c);
                        newValuesMap.put('monthHeader',item.Vision_Month_Text__c);
                        newValuesMap.put('sapMaterial',item.Vision_SAP_Material__c);
                        newValuesMap.put('agreementNo',item.Vision_Agreement_No__c);
                        newValuesMap.put('Account',item.Vision_Account__c!=null?String.valueOf(item.Vision_Account__c):null);
                        newValuesMap.put('Product',item.Vision_Product__c!=null?String.valueOf(item.Vision_Product__c):null);
                        newValuesMap.put('Contract',item.Vision_Contract__c!=null?String.valueOf(item.Vision_Contract__c):null);
                        summarizedValueMap.put(month,newValuesMap);
                    }
                    system.debug('new value map'+newValuesMap);
               
                    String monthCmp2 = string.valueOf(M1);
                 
                    if(monthCmp2 == item.Vision_Posting_Month__c){    
                      
                        if(summarizedWeekMap.containsKey(uniqueId))
                        {
                      
                            map<string,String> oldWeekValuesMap = summarizedWeekMap.get(uniqueId);
                            Decimal Week1Quantity = oldWeekValuesMap.get('week1')!=null?util.convStrtoDec(oldWeekValuesMap.get('week1')):0;
                            Decimal Week2Quantity = oldWeekValuesMap.get('week2')!=null?util.convStrtoDec(oldWeekValuesMap.get('week2')):0;
                            Decimal Week3Quantity = oldWeekValuesMap.get('week3')!=null?util.convStrtoDec(oldWeekValuesMap.get('week3')):0;
                            Decimal Week4Quantity = oldWeekValuesMap.get('week4')!=null?util.convStrtoDec(oldWeekValuesMap.get('week4')):0;
                            Decimal Week1Value = oldWeekValuesMap.get('week1Value')!=null?util.convStrtoDec(oldWeekValuesMap.get('week1Value')):0;
                            Decimal Week2Value = oldWeekValuesMap.get('week2Value')!=null?util.convStrtoDec(oldWeekValuesMap.get('week2Value')):0;
                            Decimal Week3Value = oldWeekValuesMap.get('week3Value')!=null?util.convStrtoDec(oldWeekValuesMap.get('week3Value')):0;
                            Decimal Week4Value = oldWeekValuesMap.get('week4Value')!=null?util.convStrtoDec(oldWeekValuesMap.get('week4Value')):0;
                            Integer dateVal;
                            if(item.Vision_Billing_Date__c.contains('/')){
                            dateval= integer.valueOf(item.Vision_Billing_Date__c.split('/')[0]);
                            }
                            else{
                                  dateval= integer.valueOf(item.Vision_Billing_Date__c.split('-')[0]);
                            }
                            system.debug(dateval);
                            Integer rem = math.mod(dateVal,7);
                            Integer Quotient = dateVal/7;
                            if(Quotient<1 || Quotient==1 & rem ==0){
                                if(item.Vision_Quantity__c != null && Week1Quantity != null){
                                    Week1Quantity =  Week1Quantity  + util.convStrtoDec(item.Vision_Quantity__c);
                                    newWeekValuesMap.put('week1',string.valueof(Week1Quantity));
                                }
                                 if(item.Vision_Net_Dollar__c != null && Week1Value != null){
                                    Week1Value =  Week1Value  + util.convStrtoDec(item.Vision_Net_Dollar__c);
                                    newWeekValuesMap.put('week1Value',string.valueOf(Week1Value));
                                }
                            }
                            else if(Quotient<2 || Quotient==2 & rem ==0){
                                if(item.Vision_Quantity__c != null && Week2Quantity != null){
                                    Week2Quantity =  Week2Quantity  + util.convStrtoDec(item.Vision_Quantity__c);
                                    newWeekValuesMap.put('week2',string.valueOf(Week2Quantity));
                                }
                                 if(item.Vision_Net_Dollar__c != null && Week2Value != null){
                                    Week2Value =  Week2Value  + util.convStrtoDec(item.Vision_Net_Dollar__c);
                                    newWeekValuesMap.put('week2Value',string.valueOf(Week2Value));
                                }
                            }
                            else if(Quotient<3 || Quotient==3 & rem ==0){
                                if(item.Vision_Quantity__c != null && Week3Quantity != null){
                                    Week3Quantity =  Week3Quantity  + util.convStrtoDec(item.Vision_Quantity__c);
                                    newWeekValuesMap.put('week3',string.valueOf(Week3Quantity));
                                }
                                 if(item.Vision_Net_Dollar__c != null && Week3Value != null){
                                    Week3Value =  Week3Value  + util.convStrtoDec(item.Vision_Net_Dollar__c);
                                    newWeekValuesMap.put('week3Value',string.valueOf(Week3Value));
                                }
                            }
                            else if(Quotient<4 || Quotient==4 & rem ==0){
                                if(item.Vision_Quantity__c != null && Week4Quantity != null){
                                    Week4Quantity =  Week4Quantity  + Decimal.valueOf(item.Vision_Quantity__c);
                                    newWeekValuesMap.put('week4',string.valueOf(Week4Quantity));
                                }
                                   if(item.Vision_Net_Dollar__c != null && Week4Value != null){
                                    Week4Value =  Week4Value  + util.convStrtoDec(item.Vision_Net_Dollar__c);
                                    newWeekValuesMap.put('week4Value',string.valueOf(Week4Value));
                                }
                            }
                        }
                        summarizedWeekMap.put(uniqueId,newWeekValuesMap);
                    }
                }
                else{
                    map<string,String> summarizedInitialValueMap = new  map<string,String>{'Quantity'=>String.valueOf(item.Vision_Quantity__c),
                        'NetValue'=>String.valueOf(item.Vision_Net_Dollar__c),
                        'AccountNumber'=>item.Vision_Customer_Hierarchy__c,
                        'monthHeader'=>item.Vision_Month_Text__c,'sapMaterial'=>item.Vision_SAP_Material__c,
                        'agreementNo'=>item.Vision_Agreement_No__c,
                        'Account'=>item.Vision_Account__c!=null?String.valueOf(item.Vision_Account__c):null,
                            'Product'=>item.Vision_Product__c!=null?String.valueOf(item.Vision_Product__c):null,
                                'Contract'=>item.Vision_Contract__c!=null?String.valueOf(item.Vision_Contract__c):null
                                    };
                                        
                                        map<string,map<string,String>> summarizedsecondaryValueMap = new  map<string,map<string,String>>{string.valueOf(item.Vision_Posting_Month__c)=>summarizedInitialValueMap};
                                            summarizedMap.put(uniqueId,summarizedsecondaryValueMap);
                    // handling week data
                    map<string,String> summarizedWeekMapData = new map<string,String>{'week1'=>'0','week2'=>'0','week3'=>'0','week4'=>'0','week1Value'=>'0','week2Value'=>'0','week3Value'=>'0','week4Value'=>'0'};
                  Integer dateVal = integer.valueOf(item.Vision_Billing_Date__c.split('-')[0]);
                            Integer rem = math.mod(dateVal,7);
                            Integer Quotient = dateVal/7;
                            if(Quotient<1 || Quotient==1 & rem ==0){
                                if(item.Vision_Quantity__c != null){
                                    summarizedWeekMapData.put('week1',string.valueOf(item.Vision_Quantity__c));
                                }
                                 if(item.Vision_Net_Dollar__c != null ){
                                    summarizedWeekMapData.put('week1Value',string.valueOf(item.Vision_Net_Dollar__c));
                                }
                            }
                            else if(Quotient<2 || Quotient==2 & rem ==0){
                                if(item.Vision_Quantity__c != null){
                                    summarizedWeekMapData.put('week2',string.valueOf(item.Vision_Quantity__c));
                                }
                                 if(item.Vision_Net_Dollar__c != null){
                                    summarizedWeekMapData.put('week2Value',string.valueOf(item.Vision_Net_Dollar__c));
                                }
                            }
                            else if(Quotient<3 || Quotient==3 & rem ==0){
                                if(item.Vision_Quantity__c != null ){
                                    summarizedWeekMapData.put('week3',string.valueOf(item.Vision_Quantity__c));
                                }
                                 if(item.Vision_Net_Dollar__c != null ){
                                    summarizedWeekMapData.put('week3Value',string.valueOf(item.Vision_Net_Dollar__c));
                                }
                            }
                            else if(Quotient<4 || Quotient==4 & rem ==0){
                                if(item.Vision_Quantity__c != null){
                                    summarizedWeekMapData.put('week4',string.valueOf(item.Vision_Quantity__c));
                                }
                                   if(item.Vision_Net_Dollar__c != null){
                                    summarizedWeekMapData.put('week4Value',string.valueOf(item.Vision_Net_Dollar__c));
                                }
                            }
                        summarizedWeekMap.put(uniqueId,summarizedWeekMapData);
                }
            }
 
            List<Rx_Compliance_Summary__c> insertionList = new List<Rx_Compliance_Summary__c>();
            
            Map<string,Rx_Compliance_Summary__c> existingComplianerec = new Map<string,Rx_Compliance_Summary__c>();
            for(Rx_Compliance_Summary__c item:[SELECT ID,Vision_Direct_Awarded_Qty__c,Direct_Awarded_Position__c,Vision_Direct_Awarded_Value__c,M1_Direct_Net_Dollar__c,M1_Direct_Quantity__c,M1_Indirect_Net_Dollar__c,M1_Indirect_Quantity_in_Units__c,M1_Quantity_in_Units__c,M2_Direct_Net_Dollar__c,M2_Direct_Quantity__c,M2_Indirect_Net_Dollar__c,M2_Indirect_Quantity_in_Units__c,M2_Quantity_in_Units__c,M3_Direct_Net_Dollar__c,M3_Direct_Quantity__c,M3_Indirect_Net_Dollar__c,M3_Indirect_Quantity_in_Units__c,M3_Quantity_in_Units__c,M4_Direct_Net_Dollar__c,M4_Direct_Quantity__c,M4_Indirect_Net_Dollar__c,M4_Indirect_Quantity_in_Units__c,M4_Quantity_in_Units__c,M5_Direct_Net_Dollar__c,M5_Direct_Quantity__c,M5_Indirect_Net_Dollar__c,M5_Indirect_Quantity_in_Units__c,M5_Quantity_in_Units__c,M6_Direct_Net_Dollar__c,M6_Direct_Quantity__c,M6_Indirect_Net_Dollar__c,M6_Indirect_Quantity_in_Units__c,M6_Quantity_in_Units__c,Month1__c,Month2__c,Month3__c,Month4__c,Month5__c,Month6__c,Month__c,Name,OwnerId,SystemModstamp,Vision_Accounting_Document__c,Vision_Account__c,Vision_Acct_Reference__c,Vision_Agreement_Description__c,Vision_Agreement_No__c,Vision_Batch_Number__c,Vision_Billed_Price__c,Vision_Billing_Date__c,Vision_Billing_IP_Document__c,Vision_Billing_Type__c,Vision_Contract_Updated__c,Vision_Contract__c,Vision_Created_Date__c,Vision_Customer_Group_1__c,Vision_Customer_Group__c,Vision_Customer_Hierarchy_Name__c,Vision_Customer_Hierarchy__c,Vision_Customer_Name__c,Vision_Description__c,Vision_Direct_Rebates__c,Vision_Division__c,Vision_Gross__c,Vision_NDC__c,Vision_Net_Direct_Rebates__c,Vision_Net_Dollar__c,Vision_Order_Created_By__c,Vision_Order_Created_Name__c,Vision_Order_CR_Type__c,Vision_Order_Reason_Code__c,Vision_Order_Reason__c,Vision_Package_Size__c,Vision_Posting_Month__c,Vision_PO_CR_Reference_Number__c,Vision_Pricing_Date__c,Vision_Product_Family__c,Vision_Product__c,Vision_Profic_Center__c,Vision_Quantity_in_Units__c,Vision_Quantity__c,Vision_Sales_CR_Doc_Item__c,Vision_Sales_CR_Doc__c,Vision_SAP_Material__c,Vision_Shelf_Life_Exp_Date__c,Vision_Ship_To_Customer__c,Vision_Ship_to_State__c,Vision_Sold_to_Rebate_Recipient__c,Vision_Unique_Identifier__c,Vision_ZWAC__c,Week1_Direct_Actual_Qty__c,Week1_Direct_Actual_Value__c,Week1_Indirect_Actual_Qty__c,Week1_Indirect_Actual_Value__c,Week2_Direct_Actual_Qty__c,Week2_Direct_Actual_Value__c,Week2_Indirect_Actual_Qty__c,Week2_Indirect_Actual_Value__c,Week3_Direct_Actual_Qty__c,Week3_Direct_Actual_Value__c,Week3_Indirect_Actual_Qty__c,Week3_Indirect_Actual_Value__c,Week4_Direct_Actual_Qty__c,Week4_Direct_Actual_Value__c,Week4_Indirect_Actual_Qty__c,Week4_Indirect_Actual_Value__c FROM Rx_Compliance_Summary__c where Vision_Unique_Identifier__c IN:UniqueIds]){
                existingComplianerec.put(item.Vision_Unique_Identifier__c,item);
            }
            Map<string,Vision_Customer_Product_Tracker__c> existingCustomerProductTrackerRecs = new Map<string,Vision_Customer_Product_Tracker__c>();
            for(Vision_Customer_Product_Tracker__c cpt:[SELECT ID,Is_Initial_Order__c,Vision_Price_Effective_Date__c,Vision_Internal_Unique_Identifier__c,Vision_Awarded_Value__c,Vision_Awarded_Volume__c,Vision_Current_Product_Position__c FROM Vision_Customer_Product_Tracker__c where Vision_Contract_Type__c = 'Direct' and Vision_Is_In_Awarded__c = true and Vision_Internal_Unique_Identifier__c IN:UniqueIds]){
                existingCustomerProductTrackerRecs.put(cpt.Vision_Internal_Unique_Identifier__c ,cpt);
            }
            system.debug('existingcrdprd....'+existingCustomerProductTrackerRecs);
            system.debug('summaririzedmap....'+summarizedMap.keySet());
            for(String key:summarizedMap.keySet()){
                Rx_Compliance_Summary__c newrec = new Rx_Compliance_Summary__c();
                if(!existingComplianerec.containsKey(key)){
                    
                    newrec.Vision_Unique_Identifier__c = key;
                    map<String,map<string,String>> summarySecondMap = summarizedMap.get(key);
                    map<String,string> summaryseconWeekMap = summarizedWeekMap.get(key);
                    // Storing Customer Product tracker data
                    if(existingCustomerProductTrackerRecs.containsKey(key)) {
                        if(existingCustomerProductTrackerRecs.get(key).Vision_Awarded_Volume__c != null && existingCustomerProductTrackerRecs.get(key).Vision_Awarded_Volume__c > 0)
                            newrec.Vision_Direct_Awarded_Qty__c = existingCustomerProductTrackerRecs.get(key).Vision_Awarded_Volume__c;
                        if(existingCustomerProductTrackerRecs.get(key).Vision_Awarded_Value__c != null && existingCustomerProductTrackerRecs.get(key).Vision_Awarded_Value__c > 0)
                            newrec.Vision_Direct_Awarded_Value__c = existingCustomerProductTrackerRecs.get(key).Vision_Awarded_Value__c;
                        if(existingCustomerProductTrackerRecs.get(key).Vision_Current_Product_Position__c != null){
                        	newrec.Direct_Awarded_Position__c = existingCustomerProductTrackerRecs.get(key).Vision_Current_Product_Position__c;
                        	newrec.Awarded_Position__c = existingCustomerProductTrackerRecs.get(key).Vision_Current_Product_Position__c;
                        }
                        newrec.Is_Initial_Order__c = existingCustomerProductTrackerRecs.get(key).Is_Initial_Order__c;
                        if(existingCustomerProductTrackerRecs.get(key).Vision_Price_Effective_Date__c != null){
                            newrec.Vision_Price_Effective_Date__c = existingCustomerProductTrackerRecs.get(key).Vision_Price_Effective_Date__c;
                        }
                        
                    }
               
                   system.debug('m1....'+string.valueOf(M1));
                    for(String key2:summarySecondMap.keySet()){
                        map<string,String> summaryThirdMap = summarySecondMap.get(key2);
                        if(key2==string.valueOf(M1)){
                            if(summaryseconWeekMap.get('week1') != '0'){
                            newrec.Week1_Direct_Actual_Qty__c = util.convStrtoDec(summaryseconWeekMap.get('week1'));
   
                            }
                            if(summaryseconWeekMap.get('week2') != '0'){
                            newrec.Week2_Direct_Actual_Qty__c = util.convStrtoDec(summaryseconWeekMap.get('week2'));
   
                            }
                            if(summaryseconWeekMap.get('week3') != '0'){
                            newrec.Week3_Direct_Actual_Qty__c = util.convStrtoDec(summaryseconWeekMap.get('week3'));
   
                            }
                            if(summaryseconWeekMap.get('week4') != '0'){
                            newrec.Week4_Direct_Actual_Qty__c = util.convStrtoDec(summaryseconWeekMap.get('week4'));
   
                            }
                             if(summaryseconWeekMap.get('week1Value') != '0'){
                            newrec.Week1_Direct_Actual_Value__c = util.convStrtoDec(summaryseconWeekMap.get('week1Value'));
   
                            }
                            if(summaryseconWeekMap.get('week2Value') != '0'){
                            newrec.Week2_Direct_Actual_Value__c = util.convStrtoDec(summaryseconWeekMap.get('week2Value'));
   
                            }
                            if(summaryseconWeekMap.get('week3Value') != '0'){
                            newrec.Week3_Direct_Actual_Value__c = util.convStrtoDec(summaryseconWeekMap.get('week3Value'));
   
                            }
                            if(summaryseconWeekMap.get('week4Value') != '0'){
                            newrec.Week4_Direct_Actual_Value__c = util.convStrtoDec(summaryseconWeekMap.get('week4Value'));
   
                            }
                            if(summaryThirdMap.get('NetValue') != null)
                            {
                                newrec.M1_Direct_Net_Dollar__c = util.convStrtoDec(summaryThirdMap.get('NetValue'));
                            }
                            else{
                                newrec.M1_Direct_Net_Dollar__c = null;
                            }
                            if(summaryThirdMap.get('Quantity') != null)
                            {
                                newrec.M1_Direct_Quantity__c = util.convStrtoDec(summaryThirdMap.get('Quantity'));
                            }
                            else{
                                newrec.M1_Direct_Quantity__c = null;
                            }
                            newrec.Month1__c = summaryThirdMap.get('monthHeader');
                            
                        }
                        else if(key2==string.valueOf(M2)){
                            if(summaryThirdMap.get('NetValue') != null)
                            {
                                newrec.M2_Direct_Net_Dollar__c = util.convStrtoDec(summaryThirdMap.get('NetValue'));
                            }
                            else{
                                newrec.M2_Direct_Net_Dollar__c = null;
                            }
                            if(summaryThirdMap.get('Quantity') != null)
                            {
                                newrec.M2_Direct_Quantity__c = util.convStrtoDec(summaryThirdMap.get('Quantity'));
                            }
                            else{
                                newrec.M2_Direct_Quantity__c = null;
                            }
                            newrec.Month2__c = summaryThirdMap.get('monthHeader');
                            
                        }
                        else if(key2==string.valueOf(M3)){
                            if(summaryThirdMap.get('NetValue') != null)
                            {
                                newrec.M3_Direct_Net_Dollar__c = util.convStrtoDec(summaryThirdMap.get('NetValue'));
                            }
                            else{
                                newrec.M3_Direct_Net_Dollar__c = null;
                            }
                            if(summaryThirdMap.get('Quantity') != null)
                            {
                                newrec.M3_Direct_Quantity__c = util.convStrtoDec(summaryThirdMap.get('Quantity'));
                            }
                            else{
                                newrec.M3_Direct_Quantity__c = null;
                            }
                            newrec.Month3__c = summaryThirdMap.get('monthHeader');
                            system.debug('Month3--1'+newrec.Month3__c);
                            
                        }
                        else if(key2==string.valueOf(M4)){
                            if(summaryThirdMap.get('NetValue') != null)
                            {
                                newrec.M4_Direct_Net_Dollar__c = util.convStrtoDec(summaryThirdMap.get('NetValue'));
                            }
                            else{
                                newrec.M4_Direct_Net_Dollar__c = null;  
                            }
                            if(summaryThirdMap.get('Quantity') != null)
                            {
                                newrec.M4_Direct_Quantity__c = util.convStrtoDec(summaryThirdMap.get('Quantity'));
                            }
                            else{
                                newrec.M4_Direct_Quantity__c = null;
                            }
                            newrec.Month4__c = summaryThirdMap.get('monthHeader');
                            
                        }
                        else if(key2==string.valueOf(M5)){
                            if(summaryThirdMap.get('NetValue') != null)
                            {
                                newrec.M5_Direct_Net_Dollar__c = util.convStrtoDec(summaryThirdMap.get('NetValue'));
                            }
                            else{
                                newrec.M5_Direct_Net_Dollar__c = null;
                            }
                            if(summaryThirdMap.get('Quantity') != null)
                            {
                                newrec.M5_Direct_Quantity__c = util.convStrtoDec(summaryThirdMap.get('Quantity'));
                            }
                            else{
                                newrec.M5_Direct_Quantity__c = null; 
                            }
                            newrec.Month5__c = summaryThirdMap.get('monthHeader');
                            
                        }
                        else if(key2==string.valueOf(M6)){
                            if(summaryThirdMap.get('NetValue') != null)
                            {
                                newrec.M6_Direct_Net_Dollar__c = util.convStrtoDec(summaryThirdMap.get('NetValue'));
                            }
                            else{
                                newrec.M6_Direct_Net_Dollar__c = null;
                            }
                            if(summaryThirdMap.get('Quantity') != null)
                            {
                                newrec.M6_Direct_Quantity__c = util.convStrtoDec(summaryThirdMap.get('Quantity'));
                            }
                            else{
                                newrec.M6_Direct_Quantity__c = null;
                            }
                            newrec.Month6__c = summaryThirdMap.get('monthHeader');
                            
                        }
                        else if(key2==string.valueOf(M7)){
                            if(summaryThirdMap.get('NetValue') != null)
                            {
                                newrec.M7_Direct_Net_Dollar__c = util.convStrtoDec(summaryThirdMap.get('NetValue'));
                            }
                            else{
                                newrec.M7_Direct_Net_Dollar__c = null;
                            }
                            if(summaryThirdMap.get('Quantity') != null)
                            {
                                newrec.M7_Direct_Quantity__c = util.convStrtoDec(summaryThirdMap.get('Quantity'));
                            }
                            else{
                                newrec.M7_Direct_Quantity__c = null;
                            }
                            newrec.Month7__c = summaryThirdMap.get('monthHeader');
                            
                        }
                        else if(key2==string.valueOf(M8)){
                            if(summaryThirdMap.get('NetValue') != null)
                            {
                                newrec.M8_Direct_Net_Dollar__c = util.convStrtoDec(summaryThirdMap.get('NetValue'));
                            }
                            else{
                                newrec.M8_Direct_Net_Dollar__c = null;
                            }
                            if(summaryThirdMap.get('Quantity') != null)
                            {
                                newrec.M8_Direct_Quantity__c = util.convStrtoDec(summaryThirdMap.get('Quantity'));
                            }
                            else{
                                newrec.M8_Direct_Quantity__c = null;
                            }
                            newrec.Month8__c = summaryThirdMap.get('monthHeader');
                            
                        }
                        newrec.Vision_Customer_Hierarchy__c = summaryThirdMap.get('AccountNumber');                    
                        newrec.Vision_Agreement_No__c = summaryThirdMap.get('agreementNo');
                        newrec.Vision_SAP_Material__c = summaryThirdMap.get('sapMaterial');
                        newrec.Vision_Account__c = summaryThirdMap.get('Account');
                        newrec.Vision_Product__c = summaryThirdMap.get('Product');
                        newrec.Vision_Contract_Updated__c = summaryThirdMap.get('Contract');
                    }
                    insertionMap.put(key,newrec);
                    //insertionList.add(newrec);
                }
                else{
                    //Rx_Compliance_Summary__c existingrec = existingComplianerec.get(key);
                    map<String,map<string,String>> summarySecondMap = summarizedMap.get(key);
                    
                	// Storing Customer Product tracker data
                	List<String> temAwdPositiondata = new List<String>();
                    system.debug('existingcusprdrec...'+existingCustomerProductTrackerRecs.keyset());
                    
                    if(existingCustomerProductTrackerRecs.containsKey(key)) {
                        if(existingCustomerProductTrackerRecs.get(key).Vision_Awarded_Volume__c != null && existingCustomerProductTrackerRecs.get(key).Vision_Awarded_Volume__c > 0)
                            newrec.Vision_Direct_Awarded_Qty__c = existingCustomerProductTrackerRecs.get(key).Vision_Awarded_Volume__c;
                        if(existingCustomerProductTrackerRecs.get(key).Vision_Awarded_Value__c != null && existingCustomerProductTrackerRecs.get(key).Vision_Awarded_Value__c > 0)
                            newrec.Vision_Direct_Awarded_Value__c = existingCustomerProductTrackerRecs.get(key).Vision_Awarded_Value__c;
                        if(existingCustomerProductTrackerRecs.get(key).Vision_Current_Product_Position__c != null){
                        	temAwdPositiondata.add(existingCustomerProductTrackerRecs.get(key).Vision_Current_Product_Position__c);
                           // if(existingComplianerec.get(key).Awarded_Position__c != null)
                            	
                            	//temAwdPositiondata.add(existingComplianerec.get(key).Awarded_Position__c);
                        newrec.Is_Initial_Order__c = existingCustomerProductTrackerRecs.get(key).Is_Initial_Order__c;
                        }
                        if(existingCustomerProductTrackerRecs.get(key).Vision_Price_Effective_Date__c != null){
                            newrec.Vision_Price_Effective_Date__c = existingCustomerProductTrackerRecs.get(key).Vision_Price_Effective_Date__c;
                        }
                    }
                    
                    map<string,String> summaryseconWeekMap  = summarizedWeekMap.get(key);
                    system.debug('summarysecondmap...'+summarySecondMap.keyset());
                    system.debug('m1...'+M1);
                    for(String key2:summarySecondMap.keySet()){
                        map<string,String> summaryThirdMap = summarySecondMap.get(key2);
                       
                        if(key2==string.valueOf(M1)){
                             if(summaryseconWeekMap.get('week1') != '0'){
                            newrec.Week1_Direct_Actual_Qty__c = util.convStrtoDec(summaryseconWeekMap.get('week1'));
   
                            }
                            if(summaryseconWeekMap.get('week2') != '0'){
                            newrec.Week2_Direct_Actual_Qty__c = util.convStrtoDec(summaryseconWeekMap.get('week2'));
   
                            }
                            if(summaryseconWeekMap.get('week3') != '0'){
                            newrec.Week3_Direct_Actual_Qty__c = util.convStrtoDec(summaryseconWeekMap.get('week3'));
   
                            }
                            if(summaryseconWeekMap.get('week4') != '0'){
                            newrec.Week4_Direct_Actual_Qty__c = util.convStrtoDec(summaryseconWeekMap.get('week4'));
   
                            }
                             if(summaryseconWeekMap.get('week1Value') != '0'){
                            newrec.Week1_Direct_Actual_Value__c = util.convStrtoDec(summaryseconWeekMap.get('week1Value'));
   
                            }
                            if(summaryseconWeekMap.get('week2Value') != '0'){
                            newrec.Week2_Direct_Actual_Value__c = util.convStrtoDec(summaryseconWeekMap.get('week2Value'));
   
                            }
                            if(summaryseconWeekMap.get('week3Value') != '0'){
                            newrec.Week3_Direct_Actual_Value__c = util.convStrtoDec(summaryseconWeekMap.get('week3Value'));
   
                            }
                            if(summaryseconWeekMap.get('week4Value') != '0'){
                            newrec.Week4_Direct_Actual_Value__c = util.convStrtoDec(summaryseconWeekMap.get('week4Value'));
   
                            }
                            if(summaryThirdMap.get('NetValue') != null)
                            {
                                newrec.M1_Direct_Net_Dollar__c = util.convStrtoDec(summaryThirdMap.get('NetValue'));
                            }
                            else{
                                newrec.M1_Direct_Net_Dollar__c = null;
                            }
                            if(summaryThirdMap.get('Quantity') != null)
                            {
                                newrec.M1_Direct_Quantity__c = util.convStrtoDec(summaryThirdMap.get('Quantity'));
                            }
                            else{
                                newrec.M1_Direct_Quantity__c = null; 
                            }
                            newrec.Month1__c = summaryThirdMap.get('monthHeader');
                        }
                        else if(key2==string.valueOf(M2)){
                            if(summaryThirdMap.get('NetValue') != null)
                            {
                                newrec.M2_Direct_Net_Dollar__c = util.convStrtoDec(summaryThirdMap.get('NetValue'));
                            }
                            else{
                                newrec.M2_Direct_Net_Dollar__c = null; 
                            }
                            if(summaryThirdMap.get('Quantity') != null)
                            {
                                newrec.M2_Direct_Quantity__c = util.convStrtoDec(summaryThirdMap.get('Quantity'));
                            }
                            else{
                                newrec.M2_Direct_Quantity__c = null; 
                            }
                            newrec.Month2__c = summaryThirdMap.get('monthHeader');
                            
                        }
                        else if(key2==string.valueOf(M3)){
                            if(summaryThirdMap.get('NetValue') != null)
                            {
                                newrec.M3_Direct_Net_Dollar__c = util.convStrtoDec(summaryThirdMap.get('NetValue'));
                            }
                            else{
                                newrec.M3_Direct_Net_Dollar__c = null; 
                            }
                            if(summaryThirdMap.get('Quantity') != null)
                            {
                                newrec.M3_Direct_Quantity__c = util.convStrtoDec(summaryThirdMap.get('Quantity'));
                            }
                            else{
                                newrec.M3_Direct_Quantity__c = null;
                            }
                            newrec.Month3__c = summaryThirdMap.get('monthHeader');
                            system.debug('Month3--2'+newrec.Month3__c);
                            
                        }
                        else if(key2==string.valueOf(M4)){
                            if(summaryThirdMap.get('NetValue') != null)
                            {
                                newrec.M4_Direct_Net_Dollar__c = util.convStrtoDec(summaryThirdMap.get('NetValue'));
                            }
                            else{
                                newrec.M4_Direct_Net_Dollar__c = null;
                            }
                            if(summaryThirdMap.get('Quantity') != null)
                            {
                                newrec.M4_Direct_Quantity__c = util.convStrtoDec(summaryThirdMap.get('Quantity'));
                            }
                            else{
                                newrec.M4_Direct_Quantity__c = null;
                            }
                            newrec.Month4__c = summaryThirdMap.get('monthHeader');
                            
                        }
                        else if(key2==string.valueOf(M5)){
                            if(summaryThirdMap.get('NetValue') != null)
                            {
                                newrec.M5_Direct_Net_Dollar__c = util.convStrtoDec(summaryThirdMap.get('NetValue'));
                            }
                            else{
                                newrec.M5_Direct_Net_Dollar__c = null;
                            }
                            if(summaryThirdMap.get('Quantity') != null)
                            {
                                newrec.M5_Direct_Quantity__c = util.convStrtoDec(summaryThirdMap.get('Quantity'));
                            }
                            else{
                                newrec.M5_Direct_Quantity__c = null;
                            }
                            newrec.Month5__c = summaryThirdMap.get('monthHeader');
                            
                        }
                        else if(key2==string.valueOf(M6)){
                            if(summaryThirdMap.get('NetValue') != null)
                            {
                                newrec.M6_Direct_Net_Dollar__c = util.convStrtoDec(summaryThirdMap.get('NetValue'));
                            }
                            else{
                                newrec.M6_Direct_Net_Dollar__c = null;
                            }
                            if(summaryThirdMap.get('Quantity') != null)
                            {
                                newrec.M6_Direct_Quantity__c = util.convStrtoDec(summaryThirdMap.get('Quantity'));
                            }
                            else{
                                newrec.M6_Direct_Quantity__c = null; 
                            }
                            newrec.Month6__c = summaryThirdMap.get('monthHeader');
                            
                        }
                        else if(key2==string.valueOf(M7)){
                            if(summaryThirdMap.get('NetValue') != null)
                            {
                                newrec.M7_Direct_Net_Dollar__c = util.convStrtoDec(summaryThirdMap.get('NetValue'));
                            }
                            else{
                                newrec.M7_Direct_Net_Dollar__c = null;
                            }
                            if(summaryThirdMap.get('Quantity') != null)
                            {
                                newrec.M7_Direct_Quantity__c = util.convStrtoDec(summaryThirdMap.get('Quantity'));
                            }
                            else{
                                newrec.M7_Direct_Quantity__c = null; 
                            }
                            newrec.Month7__c = summaryThirdMap.get('monthHeader');
                            
                        }
                        else if(key2==string.valueOf(M8)){
                            if(summaryThirdMap.get('NetValue') != null)
                            {
                                newrec.M8_Direct_Net_Dollar__c = util.convStrtoDec(summaryThirdMap.get('NetValue'));
                            }
                            else{
                                newrec.M8_Direct_Net_Dollar__c = null;
                            }
                            if(summaryThirdMap.get('Quantity') != null)
                            {
                                newrec.M8_Direct_Quantity__c = util.convStrtoDec(summaryThirdMap.get('Quantity'));
                            }
                            else{
                                newrec.M8_Direct_Quantity__c = null; 
                            }
                            newrec.Month8__c = summaryThirdMap.get('monthHeader');
                            
                        }
                        newrec.Vision_Customer_Hierarchy__c = summaryThirdMap.get('AccountNumber');                    
                        newrec.Vision_Agreement_No__c = summaryThirdMap.get('agreementNo');
                        newrec.Vision_SAP_Material__c = summaryThirdMap.get('sapMaterial');
                        newrec.Vision_Account__c = summaryThirdMap.get('Account');
                        newrec.Vision_Product__c = summaryThirdMap.get('Product');
                        newrec.Vision_Contract_Updated__c = summaryThirdMap.get('Contract');
                        newrec.Id = existingComplianerec.get(key).Id;
                        if(temAwdPositiondata.size() > 0){
                            newrec.Direct_Awarded_Position__c = '\'' + String.join(temAwdPositiondata, '\',\'') + '\'';
                            newrec.Awarded_Position__c = '\'' + String.join(temAwdPositiondata, '\',\'') + '\'';
                        }
                    }
                    insertionMap.put(key,newrec);
                    //insertionList.add(existingrec);
                }
                
            }
            if(insertionMap.values().size()>0)
            	upsert insertionMap.values();
        }
        catch (Exception e) {
            Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'Rx_Compliance_Direct_Sales_Summary_Batch', Phoenix_Error_Message__c = e.getMessage(), Phoenix_Issue_Status__c = 'Pending', Phoenix_Method_Name__c = 'execute', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
            insert exp;
            
        } */
    }
    
    public void finish(Database.BatchableContext BC) {
       Database.executeBatch(new Rx_Compliance_Indirect_Sales_Batch());
    }
}