public class Vision_DOH_Low_Inventory_Cls {
    @auraEnabled
    public static MainWrapper getAccountGroups(){
List<String> apexClassList = new List<String>();
        apexClassList.add('GoogleDOHTradePartnerNDCLevelFetch');
        
        MainWrapper mainwrap = new MainWrapper();
        mainWrap.isProcessed =  Vision_Rx_Compliance_NPR.apexJobStatus(apexClassList);        List<AggregateResult> AggregateResultList =[SELECT vision_gcp_trade_partner_name__c FROM GCP_DOH_Trade_Partner_NDC__c GROUP BY vision_gcp_trade_partner_name__c ];
      List < GCP_DOH_Trade_Partner_NDC__c > listOfGCPShortRecords = [SELECT vision_gcp_trade_partner_name__c,Vision_GCP_Update_Date__c,vision_gcp_w1_day__c,vision_gcp_w2_day__c,vision_gcp_w3_day__c,vision_gcp_w4_day__c,vision_gcp_w5_day__c,vision_gcp_w6_day__c,vision_gcp_w7_day__c,vision_gcp_w8_day__c FROM GCP_DOH_Trade_Partner_NDC__c limit 1]; 
        set<string> accgrpsset = new set<string>();
        for(AggregateResult aggr : AggregateResultList){
            accgrpsset.add((String) aggr.get('vision_gcp_trade_partner_name__c'));
        }
        List<string> accgrpList = new List<string>();
        accgrpList.addAll(accgrpsset);
      if(accgrpList.size()>0){
            string customer = accgrpList[0];
            List<String> productType = new List<String>();
            mainwrap.accgrpList=accgrpList;
            DOH_NDC_Level_Dates_Info__c dohRepinfo = DOH_NDC_Level_Dates_Info__c.getInstance('Data1');
            if(dohRepinfo != null)
                mainwrap.visionUpdateDate = dohRepinfo.Vision_Update_Date__c;
            mainwrap.gcpUpdateDate =  dohRepinfo.Vision_GCP_Update_Date__c;
            mainwrap.dohRecords = listOfGCPShortRecords[0];
            mainwrap.noOfRecords = getDoHData(customer,productType,false,false).noOfRecords;
            mainwrap.accList = getDoHData(customer,productType,false,false).accList;
         }
        return mainwrap;
    }
    @auraEnabled
    public static MainWrapper getDoHData(String tradePartnerName,List<String> productType,Boolean is4Weeks,Boolean isBOProduct){
        MainWrapper mainwrap = new MainWrapper();
        AccountsList accWrap = new AccountsList();
        String query = '';
        String SobjectApiName = 'GCP_DOH_Trade_Partner_NDC__c';
        Map < String, Schema.SObjectType > schemaMap = Schema.getGlobalDescribe();
        Map < String, Schema.SObjectField > fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();
        String strFields = '';
        for (String fieldName: fieldMap.keyset()) {
            if (strFields == null || strFields == '') {
                strFields = fieldName;
            } else {
                strFields = strFields + ' , ' + fieldName;
            }
        }
       
        String comment='Yes';
        String rxSegment = 'Rx';
        if (productType != null && !productType.isEmpty()) {
            if(is4Weeks == false && isBOProduct == false){
                query = 'select Product__r.Phoenix_Rx_SRx_OTC__c,GCP_Backorder_RX__r.Vision_Product__r.ProductCode,GCP_Backorder_SRX__r.Vision_Product__r.ProductCode,GCP_Backorder_SRX__r.Vision_MoH__c,GCP_Backorder_SRX__r.Vision_On_Backorder__c,GCP_Backorder_RX__r.Vision_Backorder_Qty__c,GCP_Backorder_RX__r.Vision_Product__r.Phoenix_Rx_SRx_OTC__c,GCP_Backorder_SRX__r.Vision_Product__r.Phoenix_Rx_SRx_OTC__c, '+strFields+' from ' + SobjectApiName + ' WHERE vision_gcp_trade_partner_name__c =:tradePartnerName AND Product__r.Phoenix_Rx_SRx_OTC__c =: productType and Vision_GCP_W8_DOH__c <=12 ORDER By vision_gcp_package_description__c ASC';   
                
            }
            else if(is4Weeks == false && isBOProduct == true){
                query = 'select Product__r.Phoenix_Rx_SRx_OTC__c,GCP_Backorder_RX__r.Vision_Product__r.ProductCode,GCP_Backorder_SRX__r.Vision_Product__r.ProductCode,GCP_Backorder_SRX__r.Vision_MoH__c,GCP_Backorder_SRX__r.Vision_On_Backorder__c,GCP_Backorder_RX__r.Vision_Backorder_Qty__c,GCP_Backorder_RX__r.Vision_Product__r.Phoenix_Rx_SRx_OTC__c,GCP_Backorder_SRX__r.Vision_Product__r.Phoenix_Rx_SRx_OTC__c, '+strFields+' from ' + SobjectApiName + ' WHERE vision_gcp_trade_partner_name__c =:tradePartnerName AND Product__r.Phoenix_Rx_SRx_OTC__c =: productType and Vision_GCP_W8_DOH__c <=12 and ((GCP_Backorder_SRX__r.Vision_MoH__c < 0 and GCP_Backorder_SRX__r.Vision_Product__r.Phoenix_Rx_SRx_OTC__c =: rxSegment)  or GCP_Backorder_SRX__r.Vision_On_Backorder__c =:comment  or GCP_Backorder_RX__r.Vision_Backorder_Qty__c >0) ORDER By vision_gcp_package_description__c ASC';       
            }
            else if(is4Weeks == true && isBOProduct == false){
                query = 'select Product__r.Phoenix_Rx_SRx_OTC__c,GCP_Backorder_RX__r.Vision_Product__r.ProductCode,GCP_Backorder_SRX__r.Vision_Product__r.ProductCode,GCP_Backorder_SRX__r.Vision_MoH__c,GCP_Backorder_SRX__r.Vision_On_Backorder__c,GCP_Backorder_RX__r.Vision_Backorder_Qty__c,GCP_Backorder_RX__r.Vision_Product__r.Phoenix_Rx_SRx_OTC__c,GCP_Backorder_SRX__r.Vision_Product__r.Phoenix_Rx_SRx_OTC__c, '+strFields+' from ' + SobjectApiName + ' WHERE vision_gcp_trade_partner_name__c =:tradePartnerName AND Product__r.Phoenix_Rx_SRx_OTC__c =: productType and Vision_GCP_W8_DOH__c <=12 AND Is_8_Week__c =true ORDER By vision_gcp_package_description__c ASC';   
                
            }
            else if(is4Weeks == true && isBOProduct == true){
                query = 'select Product__r.Phoenix_Rx_SRx_OTC__c,GCP_Backorder_RX__r.Vision_Product__r.ProductCode,GCP_Backorder_SRX__r.Vision_Product__r.ProductCode,GCP_Backorder_SRX__r.Vision_MoH__c,GCP_Backorder_SRX__r.Vision_On_Backorder__c,GCP_Backorder_RX__r.Vision_Backorder_Qty__c,GCP_Backorder_RX__r.Vision_Product__r.Phoenix_Rx_SRx_OTC__c,GCP_Backorder_SRX__r.Vision_Product__r.Phoenix_Rx_SRx_OTC__c, '+strFields+' from ' + SobjectApiName + ' WHERE vision_gcp_trade_partner_name__c =:tradePartnerName AND Product__r.Phoenix_Rx_SRx_OTC__c =: productType and Vision_GCP_W8_DOH__c <=12 AND Is_8_Week__c =true AND ((GCP_Backorder_SRX__r.Vision_MoH__c < 0 and GCP_Backorder_SRX__r.Vision_Product__r.Phoenix_Rx_SRx_OTC__c =: rxSegment)  or GCP_Backorder_SRX__r.Vision_On_Backorder__c =:comment or GCP_Backorder_RX__r.Vision_Backorder_Qty__c >0) ORDER By vision_gcp_package_description__c ASC';            
            }  
        }
        if (productType == null || productType.size() == 0) {
            if(is4Weeks == false && isBOProduct == false){
                query = 'select Product__r.Phoenix_Rx_SRx_OTC__c,GCP_Backorder_RX__r.Vision_Product__r.ProductCode,GCP_Backorder_SRX__r.Vision_Product__r.ProductCode,GCP_Backorder_SRX__r.Vision_MoH__c,GCP_Backorder_SRX__r.Vision_On_Backorder__c,GCP_Backorder_RX__r.Vision_Backorder_Qty__c,GCP_Backorder_RX__r.Vision_Product__r.Phoenix_Rx_SRx_OTC__c,GCP_Backorder_SRX__r.Vision_Product__r.Phoenix_Rx_SRx_OTC__c, '+strFields+' from ' + SobjectApiName + ' WHERE vision_gcp_trade_partner_name__c =:tradePartnerName and Vision_GCP_W8_DOH__c <=12 ORDER By vision_gcp_package_description__c ASC';   
                
            }
            else if(is4Weeks == false && isBOProduct == true){
                query = 'select Product__r.Phoenix_Rx_SRx_OTC__c,GCP_Backorder_RX__r.Vision_Product__r.ProductCode,GCP_Backorder_SRX__r.Vision_Product__r.ProductCode,GCP_Backorder_SRX__r.Vision_MoH__c,GCP_Backorder_SRX__r.Vision_On_Backorder__c,GCP_Backorder_RX__r.Vision_Backorder_Qty__c,GCP_Backorder_RX__r.Vision_Product__r.Phoenix_Rx_SRx_OTC__c,GCP_Backorder_SRX__r.Vision_Product__r.Phoenix_Rx_SRx_OTC__c, '+strFields+' from ' + SobjectApiName + ' WHERE vision_gcp_trade_partner_name__c =:tradePartnerName and Vision_GCP_W8_DOH__c <=12 and ((GCP_Backorder_SRX__r.Vision_MoH__c < 0 and GCP_Backorder_SRX__r.Vision_Product__r.Phoenix_Rx_SRx_OTC__c =: rxSegment)  or GCP_Backorder_SRX__r.Vision_On_Backorder__c =:comment or GCP_Backorder_RX__r.Vision_Backorder_Qty__c >0) ORDER By vision_gcp_package_description__c ASC';       
            }
            else if(is4Weeks == true && isBOProduct == false){
                query = 'select Product__r.Phoenix_Rx_SRx_OTC__c,GCP_Backorder_RX__r.Vision_Product__r.ProductCode,GCP_Backorder_SRX__r.Vision_Product__r.ProductCode,GCP_Backorder_SRX__r.Vision_MoH__c,GCP_Backorder_SRX__r.Vision_On_Backorder__c,GCP_Backorder_RX__r.Vision_Backorder_Qty__c,GCP_Backorder_RX__r.Vision_Product__r.Phoenix_Rx_SRx_OTC__c,GCP_Backorder_SRX__r.Vision_Product__r.Phoenix_Rx_SRx_OTC__c, '+strFields+' from ' + SobjectApiName + ' WHERE vision_gcp_trade_partner_name__c =:tradePartnerName and Vision_GCP_W8_DOH__c <=12 AND Is_8_Week__c =true ORDER By vision_gcp_package_description__c ASC';   
                
            }
            else if(is4Weeks == true && isBOProduct == true){
                query = 'select Product__r.Phoenix_Rx_SRx_OTC__c,GCP_Backorder_RX__r.Vision_Product__r.ProductCode,GCP_Backorder_SRX__r.Vision_Product__r.ProductCode,GCP_Backorder_SRX__r.Vision_MoH__c,GCP_Backorder_SRX__r.Vision_On_Backorder__c,GCP_Backorder_RX__r.Vision_Backorder_Qty__c,GCP_Backorder_RX__r.Vision_Product__r.Phoenix_Rx_SRx_OTC__c,GCP_Backorder_SRX__r.Vision_Product__r.Phoenix_Rx_SRx_OTC__c, '+strFields+' from ' + SobjectApiName + ' WHERE vision_gcp_trade_partner_name__c =:tradePartnerName and Vision_GCP_W8_DOH__c <=12  AND Is_8_Week__c =true AND ((GCP_Backorder_SRX__r.Vision_MoH__c < 0 and GCP_Backorder_SRX__r.Vision_Product__r.Phoenix_Rx_SRx_OTC__c =: rxSegment)  or GCP_Backorder_SRX__r.Vision_On_Backorder__c =:comment or GCP_Backorder_RX__r.Vision_Backorder_Qty__c > 0 ) ORDER By vision_gcp_package_description__c ASC';            
            }  
        }
        List < GCP_DOH_Trade_Partner_NDC__c > listOfGCPShortRecords = Database.query(query);
        mainwrap.noOfRecords = listOfGCPShortRecords.size();
        List<AccountsList> AccountsWrapperList = new List<AccountsList>();
        map<String,List<GCP_DOH_Trade_Partner_NDC__c>> accMap = new map<String,List<GCP_DOH_Trade_Partner_NDC__c>>();
        for(GCP_DOH_Trade_Partner_NDC__c item : listOfGCPShortRecords){
            if(accMap.containsKey(item.vision_gcp_trade_partner_name__c)){
                List<GCP_DOH_Trade_Partner_NDC__c> sdList = accMap.get(item.vision_gcp_trade_partner_name__c);
                sdList.add(item);
                accMap.put(item.vision_gcp_trade_partner_name__c,sdList);
            }
            else{
                accMap.put(item.vision_gcp_trade_partner_name__c,new List<GCP_DOH_Trade_Partner_NDC__c>{item});
            }
        }
        AccountsList accList = new AccountsList();
        for(string accName : accMap.keySet()){
            
            accList.accName = accName;
            accList.dohRecords = accMap.get(accName);
            
        }
        AccountsWrapperList.add(accList);
        mainwrap.accList = AccountsWrapperList;   
        return mainwrap;
    }
    @auraEnabled
    public static MainWrapper getFilterDoHData(String tradePartnerName,String searchText, List<String> productType,Boolean is4Weeks,Boolean isBOProduct){
        MainWrapper mainwrap = new MainWrapper();
        AccountsList accWrap = new AccountsList();
        String query = '';
       
        String SobjectApiName = 'GCP_DOH_Trade_Partner_NDC__c';
        Map < String, Schema.SObjectType > schemaMap = Schema.getGlobalDescribe();
        Map < String, Schema.SObjectField > fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();
        String strFields = '';
        for (String fieldName: fieldMap.keyset()) {
            if (strFields == null || strFields == '') {
                strFields = fieldName;
            } else {
                strFields = strFields + ' , ' + fieldName;
            }
        }
        String comment='Yes';
        String rxSegment = 'Rx';
        if(searchText != null && searchText !=''){
             searchText = '%'+searchText+'%';
            query = 'select Product__r.Phoenix_Rx_SRx_OTC__c,GCP_Backorder_RX__r.Vision_Product__r.ProductCode,GCP_Backorder_SRX__r.Vision_Product__r.ProductCode,GCP_Backorder_SRX__r.Vision_MoH__c,GCP_Backorder_SRX__r.Vision_On_Backorder__c,GCP_Backorder_RX__r.Vision_Backorder_Qty__c,GCP_Backorder_RX__r.Vision_Product__r.Phoenix_Rx_SRx_OTC__c,GCP_Backorder_SRX__r.Vision_Product__r.Phoenix_Rx_SRx_OTC__c, '+strFields+' from ' + SobjectApiName + ' WHERE vision_gcp_trade_partner_name__c =:tradePartnerName and Vision_GCP_W8_DOH__c <=12 AND (vision_gcp_package_description__c like :searchText or vision_gcp_ndc__c like :searchText)  ORDER By vision_gcp_package_description__c ASC';   
         
            if (productType != null && !productType.isEmpty()) {
                if(is4Weeks == false && isBOProduct == false){
                    query = 'select Product__r.Phoenix_Rx_SRx_OTC__c,GCP_Backorder_RX__r.Vision_Product__r.ProductCode,GCP_Backorder_SRX__r.Vision_Product__r.ProductCode,GCP_Backorder_SRX__r.Vision_MoH__c,GCP_Backorder_SRX__r.Vision_On_Backorder__c,GCP_Backorder_RX__r.Vision_Backorder_Qty__c,GCP_Backorder_RX__r.Vision_Product__r.Phoenix_Rx_SRx_OTC__c,GCP_Backorder_SRX__r.Vision_Product__r.Phoenix_Rx_SRx_OTC__c, '+strFields+' from ' + SobjectApiName + ' WHERE vision_gcp_trade_partner_name__c =:tradePartnerName AND Product__r.Phoenix_Rx_SRx_OTC__c =: productType and Vision_GCP_W8_DOH__c <=12 AND (vision_gcp_package_description__c like :searchText or vision_gcp_ndc__c like :searchText)  ORDER By vision_gcp_package_description__c ASC';   
                    
                }
                else if(is4Weeks == false && isBOProduct == true){
                    query = 'select Product__r.Phoenix_Rx_SRx_OTC__c,GCP_Backorder_RX__r.Vision_Product__r.ProductCode,GCP_Backorder_SRX__r.Vision_Product__r.ProductCode,GCP_Backorder_SRX__r.Vision_MoH__c,GCP_Backorder_SRX__r.Vision_On_Backorder__c,GCP_Backorder_RX__r.Vision_Backorder_Qty__c,GCP_Backorder_RX__r.Vision_Product__r.Phoenix_Rx_SRx_OTC__c,GCP_Backorder_SRX__r.Vision_Product__r.Phoenix_Rx_SRx_OTC__c, '+strFields+' from ' + SobjectApiName + ' WHERE vision_gcp_trade_partner_name__c =:tradePartnerName AND Product__r.Phoenix_Rx_SRx_OTC__c =: productType and Vision_GCP_W8_DOH__c <=12 and ((GCP_Backorder_SRX__r.Vision_MoH__c < 0 and GCP_Backorder_SRX__r.Vision_Product__r.Phoenix_Rx_SRx_OTC__c =: rxSegment)  or GCP_Backorder_SRX__r.Vision_On_Backorder__c =:comment or GCP_Backorder_RX__r.Vision_Backorder_Qty__c >0) AND (vision_gcp_package_description__c like :searchText or vision_gcp_ndc__c like :searchText)   ORDER By vision_gcp_package_description__c ASC';       
                }
                else if(is4Weeks == true && isBOProduct == false){
                    query = 'select Product__r.Phoenix_Rx_SRx_OTC__c,GCP_Backorder_RX__r.Vision_Product__r.ProductCode,GCP_Backorder_SRX__r.Vision_Product__r.ProductCode,GCP_Backorder_SRX__r.Vision_MoH__c,GCP_Backorder_SRX__r.Vision_On_Backorder__c,GCP_Backorder_RX__r.Vision_Backorder_Qty__c,GCP_Backorder_RX__r.Vision_Product__r.Phoenix_Rx_SRx_OTC__c,GCP_Backorder_SRX__r.Vision_Product__r.Phoenix_Rx_SRx_OTC__c, '+strFields+' from ' + SobjectApiName + ' WHERE vision_gcp_trade_partner_name__c =:tradePartnerName AND Product__r.Phoenix_Rx_SRx_OTC__c =: productType and Vision_GCP_W8_DOH__c <=12 AND Is_8_Week__c =true AND (vision_gcp_package_description__c like :searchText or vision_gcp_ndc__c like :searchText)  ORDER By vision_gcp_package_description__c ASC';   
                    
                }
                else if(is4Weeks == true && isBOProduct == true){
                    query = 'select Product__r.Phoenix_Rx_SRx_OTC__c,GCP_Backorder_RX__r.Vision_Product__r.ProductCode,GCP_Backorder_SRX__r.Vision_Product__r.ProductCode,GCP_Backorder_SRX__r.Vision_MoH__c,GCP_Backorder_SRX__r.Vision_On_Backorder__c,GCP_Backorder_RX__r.Vision_Backorder_Qty__c,GCP_Backorder_RX__r.Vision_Product__r.Phoenix_Rx_SRx_OTC__c,GCP_Backorder_SRX__r.Vision_Product__r.Phoenix_Rx_SRx_OTC__c, '+strFields+' from ' + SobjectApiName + ' WHERE vision_gcp_trade_partner_name__c =:tradePartnerName AND Product__r.Phoenix_Rx_SRx_OTC__c =: productType and Vision_GCP_W8_DOH__c <=12 AND Is_8_Week__c =true and ((GCP_Backorder_SRX__r.Vision_MoH__c < 0 and GCP_Backorder_SRX__r.Vision_Product__r.Phoenix_Rx_SRx_OTC__c =: rxSegment)  or GCP_Backorder_SRX__r.Vision_On_Backorder__c =:comment or GCP_Backorder_RX__r.Vision_Backorder_Qty__c >0) AND (vision_gcp_package_description__c like :searchText or vision_gcp_ndc__c like :searchText)   ORDER By vision_gcp_package_description__c ASC';            
                }  
            }
            if (productType == null || productType.size() == 0) {
                if(is4Weeks == false && isBOProduct == false){
                    query = 'select Product__r.Phoenix_Rx_SRx_OTC__c,GCP_Backorder_RX__r.Vision_Product__r.ProductCode,GCP_Backorder_SRX__r.Vision_Product__r.ProductCode,GCP_Backorder_SRX__r.Vision_MoH__c,GCP_Backorder_SRX__r.Vision_On_Backorder__c,GCP_Backorder_RX__r.Vision_Backorder_Qty__c,GCP_Backorder_RX__r.Vision_Product__r.Phoenix_Rx_SRx_OTC__c,GCP_Backorder_SRX__r.Vision_Product__r.Phoenix_Rx_SRx_OTC__c, '+strFields+' from ' + SobjectApiName + ' WHERE vision_gcp_trade_partner_name__c =:tradePartnerName and Vision_GCP_W8_DOH__c <=12 AND (vision_gcp_package_description__c like :searchText or vision_gcp_ndc__c like :searchText)  ORDER By vision_gcp_package_description__c ASC';   
                    
                }
                else if(is4Weeks == false && isBOProduct == true){
                    query = 'select Product__r.Phoenix_Rx_SRx_OTC__c,GCP_Backorder_RX__r.Vision_Product__r.ProductCode,GCP_Backorder_SRX__r.Vision_Product__r.ProductCode,GCP_Backorder_SRX__r.Vision_MoH__c,GCP_Backorder_SRX__r.Vision_On_Backorder__c,GCP_Backorder_RX__r.Vision_Backorder_Qty__c,GCP_Backorder_RX__r.Vision_Product__r.Phoenix_Rx_SRx_OTC__c,GCP_Backorder_SRX__r.Vision_Product__r.Phoenix_Rx_SRx_OTC__c, '+strFields+' from ' + SobjectApiName + ' WHERE vision_gcp_trade_partner_name__c =:tradePartnerName and Vision_GCP_W8_DOH__c <=12 and ((GCP_Backorder_SRX__r.Vision_MoH__c < 0 and GCP_Backorder_SRX__r.Vision_Product__r.Phoenix_Rx_SRx_OTC__c =: rxSegment)  or GCP_Backorder_SRX__r.Vision_On_Backorder__c =:comment or GCP_Backorder_RX__r.Vision_Backorder_Qty__c >0) AND (vision_gcp_package_description__c like :searchText or vision_gcp_ndc__c like :searchText)  ORDER By vision_gcp_package_description__c ASC';       
                }
                else if(is4Weeks == true && isBOProduct == false){
                    query = 'select Product__r.Phoenix_Rx_SRx_OTC__c,GCP_Backorder_RX__r.Vision_Product__r.ProductCode,GCP_Backorder_SRX__r.Vision_Product__r.ProductCode,GCP_Backorder_SRX__r.Vision_MoH__c,GCP_Backorder_SRX__r.Vision_On_Backorder__c,GCP_Backorder_RX__r.Vision_Backorder_Qty__c,GCP_Backorder_RX__r.Vision_Product__r.Phoenix_Rx_SRx_OTC__c,GCP_Backorder_SRX__r.Vision_Product__r.Phoenix_Rx_SRx_OTC__c, '+strFields+' from ' + SobjectApiName + ' WHERE vision_gcp_trade_partner_name__c =:tradePartnerName and Vision_GCP_W8_DOH__c <=12 AND Is_8_Week__c =true AND (vision_gcp_package_description__c like :searchText or vision_gcp_ndc__c like :searchText)  ORDER By vision_gcp_package_description__c ASC';   
                    
                }
                else if(is4Weeks == true && isBOProduct == true){
                    query = 'select Product__r.Phoenix_Rx_SRx_OTC__c,GCP_Backorder_RX__r.Vision_Product__r.ProductCode,GCP_Backorder_SRX__r.Vision_Product__r.ProductCode,GCP_Backorder_SRX__r.Vision_MoH__c,GCP_Backorder_SRX__r.Vision_On_Backorder__c,GCP_Backorder_RX__r.Vision_Backorder_Qty__c,GCP_Backorder_RX__r.Vision_Product__r.Phoenix_Rx_SRx_OTC__c,GCP_Backorder_SRX__r.Vision_Product__r.Phoenix_Rx_SRx_OTC__c, '+strFields+' from ' + SobjectApiName + ' WHERE vision_gcp_trade_partner_name__c =:tradePartnerName and Vision_GCP_W8_DOH__c <=12  AND Is_8_Week__c =true and ((GCP_Backorder_SRX__r.Vision_MoH__c < 0 and GCP_Backorder_SRX__r.Vision_Product__r.Phoenix_Rx_SRx_OTC__c =: rxSegment)  or GCP_Backorder_SRX__r.Vision_On_Backorder__c =:comment or GCP_Backorder_RX__r.Vision_Backorder_Qty__c >0) AND (vision_gcp_package_description__c like :searchText or vision_gcp_ndc__c like :searchText)  ORDER By vision_gcp_package_description__c ASC';            
                } 
            }
        }else{
            //query = 'select Product__r.Phoenix_Rx_SRx_OTC__c,GCP_Backorder_RX__r.Vision_Product__r.ProductCode,GCP_Backorder_SRX__r.Vision_Product__r.ProductCode, '+strFields+' from ' + SobjectApiName + ' WHERE vision_gcp_trade_partner_name__c =:tradePartnerName and Vision_GCP_W8_DOH__c <=12 AND (vision_gcp_package_description__c like :searchText or vision_gcp_ndc__c like :searchText)  ORDER By vision_gcp_package_description__c ASC';   
            if (productType != null && !productType.isEmpty()) {
                if(is4Weeks == false && isBOProduct == false){
                    query = 'select Product__r.Phoenix_Rx_SRx_OTC__c,GCP_Backorder_RX__r.Vision_Product__r.ProductCode,GCP_Backorder_SRX__r.Vision_Product__r.ProductCode,GCP_Backorder_SRX__r.Vision_MoH__c,GCP_Backorder_SRX__r.Vision_On_Backorder__c,GCP_Backorder_RX__r.Vision_Backorder_Qty__c,GCP_Backorder_RX__r.Vision_Product__r.Phoenix_Rx_SRx_OTC__c,GCP_Backorder_SRX__r.Vision_Product__r.Phoenix_Rx_SRx_OTC__c, '+strFields+' from ' + SobjectApiName + ' WHERE vision_gcp_trade_partner_name__c =:tradePartnerName AND Product__r.Phoenix_Rx_SRx_OTC__c =: productType and Vision_GCP_W8_DOH__c <=12 ORDER By vision_gcp_package_description__c ASC';   
                    
                }
                else if(is4Weeks == false && isBOProduct == true){
                    query = 'select Product__r.Phoenix_Rx_SRx_OTC__c,GCP_Backorder_RX__r.Vision_Product__r.ProductCode,GCP_Backorder_SRX__r.Vision_Product__r.ProductCode,GCP_Backorder_SRX__r.Vision_MoH__c,GCP_Backorder_SRX__r.Vision_On_Backorder__c,GCP_Backorder_RX__r.Vision_Backorder_Qty__c,GCP_Backorder_RX__r.Vision_Product__r.Phoenix_Rx_SRx_OTC__c,GCP_Backorder_SRX__r.Vision_Product__r.Phoenix_Rx_SRx_OTC__c, '+strFields+' from ' + SobjectApiName + ' WHERE vision_gcp_trade_partner_name__c =:tradePartnerName AND Product__r.Phoenix_Rx_SRx_OTC__c =: productType and Vision_GCP_W8_DOH__c <=12 and ((GCP_Backorder_SRX__r.Vision_MoH__c < 0 and GCP_Backorder_SRX__r.Vision_Product__r.Phoenix_Rx_SRx_OTC__c =: rxSegment)  or GCP_Backorder_SRX__r.Vision_On_Backorder__c =:comment or GCP_Backorder_RX__r.Vision_Backorder_Qty__c >0)  ORDER By vision_gcp_package_description__c ASC';       
                }
                else if(is4Weeks == true && isBOProduct == false){
                    query = 'select Product__r.Phoenix_Rx_SRx_OTC__c,GCP_Backorder_RX__r.Vision_Product__r.ProductCode,GCP_Backorder_SRX__r.Vision_Product__r.ProductCode,GCP_Backorder_SRX__r.Vision_MoH__c,GCP_Backorder_SRX__r.Vision_On_Backorder__c,GCP_Backorder_RX__r.Vision_Backorder_Qty__c,GCP_Backorder_RX__r.Vision_Product__r.Phoenix_Rx_SRx_OTC__c,GCP_Backorder_SRX__r.Vision_Product__r.Phoenix_Rx_SRx_OTC__c, '+strFields+' from ' + SobjectApiName + ' WHERE vision_gcp_trade_partner_name__c =:tradePartnerName AND Product__r.Phoenix_Rx_SRx_OTC__c =: productType and Vision_GCP_W8_DOH__c <=12 AND Is_8_Week__c =true ORDER By vision_gcp_package_description__c ASC';   
                    
                }
                else if(is4Weeks == true && isBOProduct == true){
                    query = 'select Product__r.Phoenix_Rx_SRx_OTC__c,GCP_Backorder_RX__r.Vision_Product__r.ProductCode,GCP_Backorder_SRX__r.Vision_Product__r.ProductCode,GCP_Backorder_SRX__r.Vision_MoH__c,GCP_Backorder_SRX__r.Vision_On_Backorder__c,GCP_Backorder_RX__r.Vision_Backorder_Qty__c,GCP_Backorder_RX__r.Vision_Product__r.Phoenix_Rx_SRx_OTC__c,GCP_Backorder_SRX__r.Vision_Product__r.Phoenix_Rx_SRx_OTC__c, '+strFields+' from ' + SobjectApiName + ' WHERE vision_gcp_trade_partner_name__c =:tradePartnerName AND Product__r.Phoenix_Rx_SRx_OTC__c =: productType and Vision_GCP_W8_DOH__c <=12 AND Is_8_Week__c =true and ((GCP_Backorder_SRX__r.Vision_MoH__c < 0 and GCP_Backorder_SRX__r.Vision_Product__r.Phoenix_Rx_SRx_OTC__c =: rxSegment)  or GCP_Backorder_SRX__r.Vision_On_Backorder__c =:comment or GCP_Backorder_RX__r.Vision_Backorder_Qty__c >0)  ORDER By vision_gcp_package_description__c ASC';            
                }  
            }
            if (productType == null || productType.size() == 0) {
                if(is4Weeks == false && isBOProduct == false){
                    query = 'select Product__r.Phoenix_Rx_SRx_OTC__c,GCP_Backorder_RX__r.Vision_Product__r.ProductCode,GCP_Backorder_SRX__r.Vision_Product__r.ProductCode,GCP_Backorder_SRX__r.Vision_MoH__c,GCP_Backorder_SRX__r.Vision_On_Backorder__c,GCP_Backorder_RX__r.Vision_Backorder_Qty__c,GCP_Backorder_RX__r.Vision_Product__r.Phoenix_Rx_SRx_OTC__c,GCP_Backorder_SRX__r.Vision_Product__r.Phoenix_Rx_SRx_OTC__c, '+strFields+' from ' + SobjectApiName + ' WHERE vision_gcp_trade_partner_name__c =:tradePartnerName and Vision_GCP_W8_DOH__c <=12 ORDER By vision_gcp_package_description__c ASC';   
                    
                }
                else if(is4Weeks == false && isBOProduct == true){
                    query = 'select Product__r.Phoenix_Rx_SRx_OTC__c,GCP_Backorder_RX__r.Vision_Product__r.ProductCode,GCP_Backorder_SRX__r.Vision_Product__r.ProductCode,GCP_Backorder_SRX__r.Vision_MoH__c,GCP_Backorder_SRX__r.Vision_On_Backorder__c,GCP_Backorder_RX__r.Vision_Backorder_Qty__c,GCP_Backorder_RX__r.Vision_Product__r.Phoenix_Rx_SRx_OTC__c,GCP_Backorder_SRX__r.Vision_Product__r.Phoenix_Rx_SRx_OTC__c, '+strFields+' from ' + SobjectApiName + ' WHERE vision_gcp_trade_partner_name__c =:tradePartnerName and Vision_GCP_W8_DOH__c <=12 and ((GCP_Backorder_SRX__r.Vision_MoH__c < 0 and GCP_Backorder_SRX__r.Vision_Product__r.Phoenix_Rx_SRx_OTC__c =: rxSegment)  or GCP_Backorder_SRX__r.Vision_On_Backorder__c =:comment or GCP_Backorder_RX__r.Vision_Backorder_Qty__c >0) ORDER By vision_gcp_package_description__c ASC';       
                }
                else if(is4Weeks == true && isBOProduct == false){
                    query = 'select Product__r.Phoenix_Rx_SRx_OTC__c,GCP_Backorder_RX__r.Vision_Product__r.ProductCode,GCP_Backorder_SRX__r.Vision_Product__r.ProductCode,GCP_Backorder_SRX__r.Vision_MoH__c,GCP_Backorder_SRX__r.Vision_On_Backorder__c,GCP_Backorder_RX__r.Vision_Backorder_Qty__c,GCP_Backorder_RX__r.Vision_Product__r.Phoenix_Rx_SRx_OTC__c,GCP_Backorder_SRX__r.Vision_Product__r.Phoenix_Rx_SRx_OTC__c, '+strFields+' from ' + SobjectApiName + ' WHERE vision_gcp_trade_partner_name__c =:tradePartnerName and Vision_GCP_W8_DOH__c <=12 AND Is_8_Week__c =true ORDER By vision_gcp_package_description__c ASC';   
                    
                }
                else if(is4Weeks == true && isBOProduct == true){
                    query = 'select Product__r.Phoenix_Rx_SRx_OTC__c,GCP_Backorder_RX__r.Vision_Product__r.ProductCode,GCP_Backorder_SRX__r.Vision_Product__r.ProductCode,GCP_Backorder_SRX__r.Vision_MoH__c,GCP_Backorder_SRX__r.Vision_On_Backorder__c,GCP_Backorder_RX__r.Vision_Backorder_Qty__c,GCP_Backorder_RX__r.Vision_Product__r.Phoenix_Rx_SRx_OTC__c,GCP_Backorder_SRX__r.Vision_Product__r.Phoenix_Rx_SRx_OTC__c, '+strFields+' from ' + SobjectApiName + ' WHERE vision_gcp_trade_partner_name__c =:tradePartnerName and Vision_GCP_W8_DOH__c <=12  AND Is_8_Week__c =true and ((GCP_Backorder_SRX__r.Vision_MoH__c < 0 and GCP_Backorder_SRX__r.Vision_Product__r.Phoenix_Rx_SRx_OTC__c =: rxSegment)  or GCP_Backorder_SRX__r.Vision_On_Backorder__c =:comment or GCP_Backorder_RX__r.Vision_Backorder_Qty__c >0) ORDER By vision_gcp_package_description__c ASC';            
                } 
            }
        }
        
        List < GCP_DOH_Trade_Partner_NDC__c > listOfGCPShortRecords = Database.query(query);
        mainwrap.noOfRecords = listOfGCPShortRecords.size();
        mainwrap.noOfRecords = listOfGCPShortRecords.size();
        
        List<AccountsList> AccountsWrapperList = new List<AccountsList>();
        map<String,List<GCP_DOH_Trade_Partner_NDC__c>> accMap = new map<String,List<GCP_DOH_Trade_Partner_NDC__c>>();
        for(GCP_DOH_Trade_Partner_NDC__c item : listOfGCPShortRecords){
            if(accMap.containsKey(item.vision_gcp_trade_partner_name__c)){
                List<GCP_DOH_Trade_Partner_NDC__c> sdList = accMap.get(item.vision_gcp_trade_partner_name__c);
                sdList.add(item);
                accMap.put(item.vision_gcp_trade_partner_name__c,sdList);
            }
            else{
                accMap.put(item.vision_gcp_trade_partner_name__c,new List<GCP_DOH_Trade_Partner_NDC__c>{item});
            }
        }
        AccountsList accList = new AccountsList();
        for(string accName : accMap.keySet()){
            
            accList.accName = accName;
            accList.dohRecords = accMap.get(accName);
            
        }
        AccountsWrapperList.add(accList);
        mainwrap.accList = AccountsWrapperList;   
        return mainwrap;
    }
    @auraEnabled
    public static MainWrapper fetchSortResults(string sortField,String searchText,boolean isAsc,List < GCP_DOH_Trade_Partner_NDC__c > productList,String tradePartnerName,List<String> productType,Boolean is4Weeks,Boolean isBOProduct){
        set < Id > prodIds = new set < Id > ();
        MainWrapper mainwrap = new MainWrapper();
        AccountsList accWrap = new AccountsList();
        
        list < GCP_DOH_Trade_Partner_NDC__c > sortResults = new list < GCP_DOH_Trade_Partner_NDC__c > ();
        List < GCP_DOH_Trade_Partner_NDC__c > wrlist = new List < GCP_DOH_Trade_Partner_NDC__c > ();
        String SobjectApiName = 'GCP_DOH_Trade_Partner_NDC__c';
        Map < String, Schema.SObjectType > schemaMap = Schema.getGlobalDescribe();
        Map < String, Schema.SObjectField > fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();
        for (GCP_DOH_Trade_Partner_NDC__c w: productList) {
            prodIds.add(w.Id);
            
        }
       
        String strFields = '';
        String sSoql = '';
        for (String fieldName: fieldMap.keyset()) {
            if (strFields == null || strFields == '') {
                strFields = fieldName;
            } else {
                strFields = strFields + ' , ' + fieldName;
            }
        }
        
        //String sSoql = 'select ' + strFields + ' from GCP_DOH_Trade_Partner_NDC__c WHERE ID IN:prodIds';
        
        String comment='Yes';
        String rxSegment = 'Rx';
        if(searchText != null && searchText !=''){
             searchText = '%'+searchText+'%';
            //sSoql = 'select Product__r.Phoenix_Rx_SRx_OTC__c,GCP_Backorder_RX__r.Vision_Product__r.ProductCode,GCP_Backorder_SRX__r.Vision_Product__r.ProductCode, '+strFields+' from ' + SobjectApiName + ' WHERE vision_gcp_trade_partner_name__c =:tradePartnerName and Vision_GCP_W8_DOH__c <=12 AND (vision_gcp_package_description__c like :searchText or vision_gcp_ndc__c like :searchText)  AND ID IN:prodIds';   
            /*if(productType != null && !productType.isEmpty()){
query = 'select Product__r.Phoenix_Rx_SRx_OTC__c,GCP_Backorder_RX__r.Vision_Product__r.ProductCode,GCP_Backorder_SRX__r.Vision_Product__r.ProductCode, '+strFields+' from ' + SobjectApiName + ' WHERE vision_gcp_trade_partner_name__c =:tradePartnerName and  Vision_GCP_W8_DOH__c <=12 AND Product__r.Phoenix_Rx_SRx_OTC__c =: productType AND (vision_gcp_package_description__c like :searchText or vision_gcp_ndc__c like :searchText)  AND ID IN:prodIds';     
}*/
            if (productType != null && !productType.isEmpty()) {
                if(is4Weeks == false && isBOProduct == false){
                    sSoql = 'select Product__r.Phoenix_Rx_SRx_OTC__c,GCP_Backorder_RX__r.Vision_Product__r.ProductCode,GCP_Backorder_SRX__r.Vision_Product__r.ProductCode,GCP_Backorder_SRX__r.Vision_MoH__c,GCP_Backorder_SRX__r.Vision_On_Backorder__c,GCP_Backorder_RX__r.Vision_Backorder_Qty__c,GCP_Backorder_RX__r.Vision_Product__r.Phoenix_Rx_SRx_OTC__c,GCP_Backorder_SRX__r.Vision_Product__r.Phoenix_Rx_SRx_OTC__c, '+strFields+' from ' + SobjectApiName + ' WHERE vision_gcp_trade_partner_name__c =:tradePartnerName AND Product__r.Phoenix_Rx_SRx_OTC__c =: productType and Vision_GCP_W8_DOH__c <=12 AND (vision_gcp_package_description__c like :searchText or vision_gcp_ndc__c like :searchText)  AND ID IN:prodIds';   
                    
                }
                else if(is4Weeks == false && isBOProduct == true){
                    sSoql = 'select Product__r.Phoenix_Rx_SRx_OTC__c,GCP_Backorder_RX__r.Vision_Product__r.ProductCode,GCP_Backorder_SRX__r.Vision_Product__r.ProductCode,GCP_Backorder_SRX__r.Vision_MoH__c,GCP_Backorder_SRX__r.Vision_On_Backorder__c,GCP_Backorder_RX__r.Vision_Backorder_Qty__c,GCP_Backorder_RX__r.Vision_Product__r.Phoenix_Rx_SRx_OTC__c,GCP_Backorder_SRX__r.Vision_Product__r.Phoenix_Rx_SRx_OTC__c, '+strFields+' from ' + SobjectApiName + ' WHERE vision_gcp_trade_partner_name__c =:tradePartnerName AND Product__r.Phoenix_Rx_SRx_OTC__c =: productType and Vision_GCP_W8_DOH__c <=12 and ((GCP_Backorder_SRX__r.Vision_MoH__c < 0 and GCP_Backorder_SRX__r.Vision_Product__r.Phoenix_Rx_SRx_OTC__c =: rxSegment)  or GCP_Backorder_SRX__r.Vision_On_Backorder__c =:comment or GCP_Backorder_RX__r.Vision_Backorder_Qty__c >0) AND (vision_gcp_package_description__c like :searchText or vision_gcp_ndc__c like :searchText)  AND ID IN:prodIds';       
                }
                else if(is4Weeks == true && isBOProduct == false){
                    sSoql = 'select Product__r.Phoenix_Rx_SRx_OTC__c,GCP_Backorder_RX__r.Vision_Product__r.ProductCode,GCP_Backorder_SRX__r.Vision_Product__r.ProductCode,GCP_Backorder_SRX__r.Vision_MoH__c,GCP_Backorder_SRX__r.Vision_On_Backorder__c,GCP_Backorder_RX__r.Vision_Backorder_Qty__c,GCP_Backorder_RX__r.Vision_Product__r.Phoenix_Rx_SRx_OTC__c,GCP_Backorder_SRX__r.Vision_Product__r.Phoenix_Rx_SRx_OTC__c, '+strFields+' from ' + SobjectApiName + ' WHERE vision_gcp_trade_partner_name__c =:tradePartnerName AND Product__r.Phoenix_Rx_SRx_OTC__c =: productType and Vision_GCP_W8_DOH__c <=12 AND Is_8_Week__c =true AND (vision_gcp_package_description__c like :searchText or vision_gcp_ndc__c like :searchText)  AND ID IN:prodIds';   
                    
                }
                else if(is4Weeks == true && isBOProduct == true){
                    sSoql = 'select Product__r.Phoenix_Rx_SRx_OTC__c,GCP_Backorder_RX__r.Vision_Product__r.ProductCode,GCP_Backorder_SRX__r.Vision_Product__r.ProductCode,GCP_Backorder_SRX__r.Vision_MoH__c,GCP_Backorder_SRX__r.Vision_On_Backorder__c,GCP_Backorder_RX__r.Vision_Backorder_Qty__c,GCP_Backorder_RX__r.Vision_Product__r.Phoenix_Rx_SRx_OTC__c,GCP_Backorder_SRX__r.Vision_Product__r.Phoenix_Rx_SRx_OTC__c, '+strFields+' from ' + SobjectApiName + ' WHERE vision_gcp_trade_partner_name__c =:tradePartnerName AND Product__r.Phoenix_Rx_SRx_OTC__c =: productType and Vision_GCP_W8_DOH__c <=12 ANDIs_8_Week__c =true and ((GCP_Backorder_SRX__r.Vision_MoH__c < 0 and GCP_Backorder_SRX__r.Vision_Product__r.Phoenix_Rx_SRx_OTC__c =: rxSegment)  or GCP_Backorder_SRX__r.Vision_On_Backorder__c =:comment or GCP_Backorder_RX__r.Vision_Backorder_Qty__c >0) AND (vision_gcp_package_description__c like :searchText or vision_gcp_ndc__c like :searchText)  AND ID IN:prodIds ';            
                }  
            }
            if (productType == null || productType.size() == 0) {
                if(is4Weeks == false && isBOProduct == false){
                    sSoql = 'select Product__r.Phoenix_Rx_SRx_OTC__c,GCP_Backorder_RX__r.Vision_Product__r.ProductCode,GCP_Backorder_SRX__r.Vision_Product__r.ProductCode,GCP_Backorder_SRX__r.Vision_MoH__c,GCP_Backorder_SRX__r.Vision_On_Backorder__c,GCP_Backorder_RX__r.Vision_Backorder_Qty__c,GCP_Backorder_RX__r.Vision_Product__r.Phoenix_Rx_SRx_OTC__c,GCP_Backorder_SRX__r.Vision_Product__r.Phoenix_Rx_SRx_OTC__c, '+strFields+' from ' + SobjectApiName + ' WHERE vision_gcp_trade_partner_name__c =:tradePartnerName and Vision_GCP_W8_DOH__c <=12 AND (vision_gcp_package_description__c like :searchText or vision_gcp_ndc__c like :searchText)  AND ID IN:prodIds';   
                    
                }
                else if(is4Weeks == false && isBOProduct == true){
                    sSoql = 'select Product__r.Phoenix_Rx_SRx_OTC__c,GCP_Backorder_RX__r.Vision_Product__r.ProductCode,GCP_Backorder_SRX__r.Vision_Product__r.ProductCode,GCP_Backorder_SRX__r.Vision_MoH__c,GCP_Backorder_SRX__r.Vision_On_Backorder__c,GCP_Backorder_RX__r.Vision_Backorder_Qty__c,GCP_Backorder_RX__r.Vision_Product__r.Phoenix_Rx_SRx_OTC__c,GCP_Backorder_SRX__r.Vision_Product__r.Phoenix_Rx_SRx_OTC__c, '+strFields+' from ' + SobjectApiName + ' WHERE vision_gcp_trade_partner_name__c =:tradePartnerName and Vision_GCP_W8_DOH__c <=12 and ((GCP_Backorder_SRX__r.Vision_MoH__c < 0 and GCP_Backorder_SRX__r.Vision_Product__r.Phoenix_Rx_SRx_OTC__c =: rxSegment)  or GCP_Backorder_SRX__r.Vision_On_Backorder__c =:comment or GCP_Backorder_RX__r.Vision_Backorder_Qty__c >0) AND (vision_gcp_package_description__c like :searchText or vision_gcp_ndc__c like :searchText)  AND ID IN:prodIds';       
                }
                else if(is4Weeks == true && isBOProduct == false){
                    sSoql = 'select Product__r.Phoenix_Rx_SRx_OTC__c,GCP_Backorder_RX__r.Vision_Product__r.ProductCode,GCP_Backorder_SRX__r.Vision_Product__r.ProductCode,GCP_Backorder_SRX__r.Vision_MoH__c,GCP_Backorder_SRX__r.Vision_On_Backorder__c,GCP_Backorder_RX__r.Vision_Backorder_Qty__c,GCP_Backorder_RX__r.Vision_Product__r.Phoenix_Rx_SRx_OTC__c,GCP_Backorder_SRX__r.Vision_Product__r.Phoenix_Rx_SRx_OTC__c, '+strFields+' from ' + SobjectApiName + ' WHERE vision_gcp_trade_partner_name__c =:tradePartnerName and Vision_GCP_W8_DOH__c <=12 AND Is_8_Week__c =true AND (vision_gcp_package_description__c like :searchText or vision_gcp_ndc__c like :searchText)  AND ID IN:prodIds';   
                    
                }
                else if(is4Weeks == true && isBOProduct == true){
                    sSoql = 'select Product__r.Phoenix_Rx_SRx_OTC__c,GCP_Backorder_RX__r.Vision_Product__r.ProductCode,GCP_Backorder_SRX__r.Vision_Product__r.ProductCode,GCP_Backorder_SRX__r.Vision_MoH__c,GCP_Backorder_SRX__r.Vision_On_Backorder__c,GCP_Backorder_RX__r.Vision_Backorder_Qty__c,GCP_Backorder_RX__r.Vision_Product__r.Phoenix_Rx_SRx_OTC__c,GCP_Backorder_SRX__r.Vision_Product__r.Phoenix_Rx_SRx_OTC__c, '+strFields+' from ' + SobjectApiName + ' WHERE vision_gcp_trade_partner_name__c =:tradePartnerName and Vision_GCP_W8_DOH__c <=12  AND Is_8_Week__c =true and ((GCP_Backorder_SRX__r.Vision_MoH__c < 0 and GCP_Backorder_SRX__r.Vision_Product__r.Phoenix_Rx_SRx_OTC__c =: rxSegment)  or GCP_Backorder_SRX__r.Vision_On_Backorder__c =:comment or GCP_Backorder_RX__r.Vision_Backorder_Qty__c >0) AND (vision_gcp_package_description__c like :searchText or vision_gcp_ndc__c like :searchText)  AND ID IN:prodIds';            
                } 
            }
        }else{
            //query = 'select Product__r.Phoenix_Rx_SRx_OTC__c,GCP_Backorder_RX__r.Vision_Product__r.ProductCode,GCP_Backorder_SRX__r.Vision_Product__r.ProductCode, '+strFields+' from ' + SobjectApiName + ' WHERE vision_gcp_trade_partner_name__c =:tradePartnerName and Vision_GCP_W8_DOH__c <=12 AND (vision_gcp_package_description__c like :searchText or vision_gcp_ndc__c like :searchText)  ORDER By vision_gcp_package_description__c ASC';   
            if (productType != null && !productType.isEmpty()) {
                if(is4Weeks == false && isBOProduct == false){
                    sSoql = 'select Product__r.Phoenix_Rx_SRx_OTC__c,GCP_Backorder_RX__r.Vision_Product__r.ProductCode,GCP_Backorder_SRX__r.Vision_Product__r.ProductCode,GCP_Backorder_SRX__r.Vision_MoH__c,GCP_Backorder_SRX__r.Vision_On_Backorder__c,GCP_Backorder_RX__r.Vision_Backorder_Qty__c,GCP_Backorder_RX__r.Vision_Product__r.Phoenix_Rx_SRx_OTC__c,GCP_Backorder_SRX__r.Vision_Product__r.Phoenix_Rx_SRx_OTC__c, '+strFields+' from ' + SobjectApiName + ' WHERE vision_gcp_trade_partner_name__c =:tradePartnerName AND Product__r.Phoenix_Rx_SRx_OTC__c =: productType and Vision_GCP_W8_DOH__c <=12 AND ID IN:prodIds';       
                    
                }
                else if(is4Weeks == false && isBOProduct == true){
                    sSoql = 'select Product__r.Phoenix_Rx_SRx_OTC__c,GCP_Backorder_RX__r.Vision_Product__r.ProductCode,GCP_Backorder_SRX__r.Vision_Product__r.ProductCode,GCP_Backorder_SRX__r.Vision_MoH__c,GCP_Backorder_SRX__r.Vision_On_Backorder__c,GCP_Backorder_RX__r.Vision_Backorder_Qty__c,GCP_Backorder_RX__r.Vision_Product__r.Phoenix_Rx_SRx_OTC__c,GCP_Backorder_SRX__r.Vision_Product__r.Phoenix_Rx_SRx_OTC__c, '+strFields+' from ' + SobjectApiName + ' WHERE vision_gcp_trade_partner_name__c =:tradePartnerName AND Product__r.Phoenix_Rx_SRx_OTC__c =: productType and Vision_GCP_W8_DOH__c <=12 and ((GCP_Backorder_SRX__r.Vision_MoH__c < 0 and GCP_Backorder_SRX__r.Vision_Product__r.Phoenix_Rx_SRx_OTC__c =: rxSegment)  or GCP_Backorder_SRX__r.Vision_On_Backorder__c =:comment or GCP_Backorder_RX__r.Vision_Backorder_Qty__c >0) AND ID IN:prodIds';       
                }
                else if(is4Weeks == true && isBOProduct == false){
                    sSoql = 'select Product__r.Phoenix_Rx_SRx_OTC__c,GCP_Backorder_RX__r.Vision_Product__r.ProductCode,GCP_Backorder_SRX__r.Vision_Product__r.ProductCode,GCP_Backorder_SRX__r.Vision_MoH__c,GCP_Backorder_SRX__r.Vision_On_Backorder__c,GCP_Backorder_RX__r.Vision_Backorder_Qty__c,GCP_Backorder_RX__r.Vision_Product__r.Phoenix_Rx_SRx_OTC__c,GCP_Backorder_SRX__r.Vision_Product__r.Phoenix_Rx_SRx_OTC__c, '+strFields+' from ' + SobjectApiName + ' WHERE vision_gcp_trade_partner_name__c =:tradePartnerName AND Product__r.Phoenix_Rx_SRx_OTC__c =: productType and Is_8_Week__c =true and Vision_GCP_W8_DOH__c <=12 AND ID IN:prodIds';   
                    
                }
                else if(is4Weeks == true && isBOProduct == true){
                    sSoql = 'select Product__r.Phoenix_Rx_SRx_OTC__c,GCP_Backorder_RX__r.Vision_Product__r.ProductCode,GCP_Backorder_SRX__r.Vision_Product__r.ProductCode,GCP_Backorder_SRX__r.Vision_MoH__c,GCP_Backorder_SRX__r.Vision_On_Backorder__c,GCP_Backorder_RX__r.Vision_Backorder_Qty__c,GCP_Backorder_RX__r.Vision_Product__r.Phoenix_Rx_SRx_OTC__c,GCP_Backorder_SRX__r.Vision_Product__r.Phoenix_Rx_SRx_OTC__c, '+strFields+' from ' + SobjectApiName + ' WHERE vision_gcp_trade_partner_name__c =:tradePartnerName AND Product__r.Phoenix_Rx_SRx_OTC__c =: productType and Vision_GCP_W8_DOH__c <=12 AND Is_8_Week__c =true and ((GCP_Backorder_SRX__r.Vision_MoH__c < 0 and GCP_Backorder_SRX__r.Vision_Product__r.Phoenix_Rx_SRx_OTC__c =: rxSegment)  or GCP_Backorder_SRX__r.Vision_On_Backorder__c =:comment or GCP_Backorder_RX__r.Vision_Backorder_Qty__c >0) AND ID IN:prodIds';            
                }  
            }
            if (productType == null || productType.size() == 0) {
                if(is4Weeks == false && isBOProduct == false){
                    sSoql = 'select Product__r.Phoenix_Rx_SRx_OTC__c,GCP_Backorder_RX__r.Vision_Product__r.ProductCode,GCP_Backorder_SRX__r.Vision_Product__r.ProductCode,GCP_Backorder_SRX__r.Vision_MoH__c,GCP_Backorder_SRX__r.Vision_On_Backorder__c,GCP_Backorder_RX__r.Vision_Backorder_Qty__c,GCP_Backorder_RX__r.Vision_Product__r.Phoenix_Rx_SRx_OTC__c,GCP_Backorder_SRX__r.Vision_Product__r.Phoenix_Rx_SRx_OTC__c, '+strFields+' from ' + SobjectApiName + ' WHERE vision_gcp_trade_partner_name__c =:tradePartnerName and Vision_GCP_W8_DOH__c <=12  AND ID IN:prodIds';       
                    
                }
                else if(is4Weeks == false && isBOProduct == true){
                    sSoql = 'select Product__r.Phoenix_Rx_SRx_OTC__c,GCP_Backorder_RX__r.Vision_Product__r.ProductCode,GCP_Backorder_SRX__r.Vision_Product__r.ProductCode,GCP_Backorder_SRX__r.Vision_MoH__c,GCP_Backorder_SRX__r.Vision_On_Backorder__c,GCP_Backorder_RX__r.Vision_Backorder_Qty__c,GCP_Backorder_RX__r.Vision_Product__r.Phoenix_Rx_SRx_OTC__c,GCP_Backorder_SRX__r.Vision_Product__r.Phoenix_Rx_SRx_OTC__c, '+strFields+' from ' + SobjectApiName + ' WHERE vision_gcp_trade_partner_name__c =:tradePartnerName and Vision_GCP_W8_DOH__c <=12 and ((GCP_Backorder_SRX__r.Vision_MoH__c < 0 and GCP_Backorder_SRX__r.Vision_Product__r.Phoenix_Rx_SRx_OTC__c =: rxSegment)  or GCP_Backorder_SRX__r.Vision_On_Backorder__c =:comment or GCP_Backorder_RX__r.Vision_Backorder_Qty__c > 0) AND ID IN:prodIds';       
                }
                else if(is4Weeks == true && isBOProduct == false){
                    sSoql = 'select Product__r.Phoenix_Rx_SRx_OTC__c,GCP_Backorder_RX__r.Vision_Product__r.ProductCode,GCP_Backorder_SRX__r.Vision_Product__r.ProductCode,GCP_Backorder_SRX__r.Vision_MoH__c,GCP_Backorder_SRX__r.Vision_On_Backorder__c,GCP_Backorder_RX__r.Vision_Backorder_Qty__c,GCP_Backorder_RX__r.Vision_Product__r.Phoenix_Rx_SRx_OTC__c,GCP_Backorder_SRX__r.Vision_Product__r.Phoenix_Rx_SRx_OTC__c, '+strFields+' from ' + SobjectApiName + ' WHERE vision_gcp_trade_partner_name__c =:tradePartnerName and Vision_GCP_W8_DOH__c <=12 AND Is_8_Week__c =true AND ID IN:prodIds';   
                    
                }
                else if(is4Weeks == true && isBOProduct == true){
                    sSoql = 'select Product__r.Phoenix_Rx_SRx_OTC__c,GCP_Backorder_RX__r.Vision_Product__r.ProductCode,GCP_Backorder_SRX__r.Vision_Product__r.ProductCode,GCP_Backorder_SRX__r.Vision_MoH__c,GCP_Backorder_SRX__r.Vision_On_Backorder__c,GCP_Backorder_RX__r.Vision_Backorder_Qty__c,GCP_Backorder_RX__r.Vision_Product__r.Phoenix_Rx_SRx_OTC__c,GCP_Backorder_SRX__r.Vision_Product__r.Phoenix_Rx_SRx_OTC__c, '+strFields+' from ' + SobjectApiName + ' WHERE vision_gcp_trade_partner_name__c =:tradePartnerName and Vision_GCP_W8_DOH__c <=12  AND Is_8_Week__c =true and ((GCP_Backorder_SRX__r.Vision_MoH__c < 0 and GCP_Backorder_SRX__r.Vision_Product__r.Phoenix_Rx_SRx_OTC__c =: rxSegment)  or GCP_Backorder_SRX__r.Vision_On_Backorder__c =:comment or GCP_Backorder_RX__r.Vision_Backorder_Qty__c > 0) AND ID IN:prodIds ';            
                } 
            }
        }
        
        if (sortField != null && sortField != '') {
            sSoql += ' order by ' + sortField;
            if (isAsc) {
                sSoql += ' ASC NULLS LAST';
            } else {
                sSoql += ' DESC NULLS LAST';
            }
        }
        //sSoql += ' NULLS LAST LIMIT 100 ';
        sortResults = Database.query(sSoql);
       mainwrap.noOfRecords = sortResults.size();
        
        for (GCP_DOH_Trade_Partner_NDC__c pr: sortResults) {
            for (GCP_DOH_Trade_Partner_NDC__c wr: productList) {
                if (wr.Id == pr.Id) {
                    wrlist.add(wr);
                    
                }
            }
        }
        List<AccountsList> AccountsWrapperList = new List<AccountsList>();
        map<String,List<GCP_DOH_Trade_Partner_NDC__c>> accMap = new map<String,List<GCP_DOH_Trade_Partner_NDC__c>>();
        for(GCP_DOH_Trade_Partner_NDC__c item : wrlist){
            if(accMap.containsKey(item.vision_gcp_trade_partner_name__c)){
                List<GCP_DOH_Trade_Partner_NDC__c> sdList = accMap.get(item.vision_gcp_trade_partner_name__c);
                sdList.add(item);
                accMap.put(item.vision_gcp_trade_partner_name__c,sdList);
            }
            else{
                accMap.put(item.vision_gcp_trade_partner_name__c,new List<GCP_DOH_Trade_Partner_NDC__c>{item});
            }
        }
        AccountsList accList = new AccountsList();
        for(string accName : accMap.keySet()){
            
            accList.accName = accName;
            accList.dohRecords = accMap.get(accName);
            
        }
        AccountsWrapperList.add(accList);
        mainwrap.accList = AccountsWrapperList;   
        return mainwrap;
        
        
    }
    @AuraEnabled
    public static MainWrapper getAwardedPositionData(String customerId, string Id){
        MainWrapper mainWrap = new MainWrapper();
        List<GCP_DOH_Trade_Partner_NDC__c> ProdList = [SELECT id,Product__r.ProductCode FROM GCP_DOH_Trade_Partner_NDC__c where id =: Id limit 1];
        String ProductCode = ProdList[0].Product__r.ProductCode;
        List < Vision_Customer_Product_Tracker__c > awardedPositionList = [SELECT Vision_Account__c,Vision_Contract__r.Name,Vision_Current_Product_Position__c,Vision_Product__c,Vision_Product__r.Name,Vision_Product__r.Phoenix_NDC_11__c,Vision_Product__r.ProductCode FROM Vision_Customer_Product_Tracker__c where Vision_Product__r.ProductCode =: ProductCode and Vision_Current_Product_Position__c != null];
        
        mainwrap.awardedPositionList = awardedPositionList;
        if(awardedPositionList.size() > 0){
            mainwrap.ProdName = awardedPositionList[0].Vision_Product__r.Name;
            mainwrap.Ndc = awardedPositionList[0].Vision_Product__r.Phoenix_NDC_11__c; 
            
        }
        return mainwrap;
    } 
    public class MainWrapper{
                @AuraEnabled public Boolean isProcessed;
        //@AuraEnabled public String headerName;
        @AuraEnabled public Integer noOfRecords;
        @AuraEnabled public List<DoH_Summary__c> dohSummary;
        @AuraEnabled public List<AccountsList> accList;
        @AuraEnabled public List<String> accgrpList;
        @AuraEnabled public String visionUpdateDate;
        @AuraEnabled public String gcpUpdateDate;
        @AuraEnabled public GCP_DOH_Trade_Partner_NDC__c dohRecords;
        @AuraEnabled public String ProdName;
        @AuraEnabled public String Ndc;
        @AuraEnabled public List<Vision_Customer_Product_Tracker__c> awardedPositionList; 
        MainWrapper(){
            dohRecords = new GCP_DOH_Trade_Partner_NDC__c();
            dohSummary = new List<DoH_Summary__c>();
            awardedPositionList = new List<Vision_Customer_Product_Tracker__c>();
        }
        
    }
    Public Class AccountsList{
        //  @AuraEnabled public String tradePartnerName;
        @AuraEnabled public String accName;
        // @AuraEnabled public integer WAC;
        @AuraEnabled public  List<GCP_DOH_Trade_Partner_NDC__c> dohRecords;
        //  @AuraEnabled public AggregateResult aggrResult;
        
        @AuraEnabled public Boolean showAccount;
        //  @AuraEnabled public List<String> acctCodes;
        AccountsList(){
            dohRecords = new List<GCP_DOH_Trade_Partner_NDC__c>();
            //   acctCodes = new List<String>();
            showAccount = true;
        }
    }
    Public Class productFamily{
        // @AuraEnabled public String pfName;    
        @AuraEnabled public List<GCP_DOH_Trade_Partner_NDC__c> dohRecords;
        productFamily(){
            dohRecords = new List<GCP_DOH_Trade_Partner_NDC__c>();
            
        }
        
    }
}