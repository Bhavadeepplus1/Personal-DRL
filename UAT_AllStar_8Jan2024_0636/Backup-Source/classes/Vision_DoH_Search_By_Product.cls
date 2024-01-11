public class Vision_DoH_Search_By_Product {
    @auraEnabled
    public static MainWrapper getAccountGroups(){
  List<String> apexClassList = new List<String>();
        apexClassList.add('GoogleDOHTradePartnerNDCLevelFetch');
        
        MainWrapper mainwrap = new MainWrapper();
        mainWrap.isProcessed =  Vision_Rx_Compliance_NPR.apexJobStatus(apexClassList);
        List<AggregateResult> AggregateResultList =[SELECT vision_gcp_trade_partner_name__c FROM GCP_DOH_Trade_Partner_NDC__c GROUP BY vision_gcp_trade_partner_name__c ];
        system.debug('total records-->'+AggregateResultList.size());
        List < GCP_DOH_Trade_Partner_NDC__c > listOfGCPShortRecords = [SELECT vision_gcp_trade_partner_name__c,Vision_GCP_Update_Date__c,vision_gcp_w1_day__c,vision_gcp_w2_day__c,vision_gcp_w3_day__c,vision_gcp_w4_day__c,vision_gcp_w5_day__c,vision_gcp_w6_day__c,vision_gcp_w7_day__c,vision_gcp_w8_day__c FROM GCP_DOH_Trade_Partner_NDC__c limit 1]; 
        set<string> accgrpsset = new set<string>();
        for(AggregateResult aggr : AggregateResultList){
            accgrpsset.add((String) aggr.get('vision_gcp_trade_partner_name__c'));
        }
        List<string> accgrpList = new List<string>();
        accgrpList.addAll(accgrpsset);
        system.debug('accgrpList-----'+accgrpList.size());
        system.debug('accgrpList-----'+accgrpList);
        if(accgrpList.size()>0){
            string customer = accgrpList[0];
            List<String> productType = new List<String>();
            mainwrap.accgrpList=accgrpList;
            DOH_NDC_Level_Dates_Info__c dohRepinfo = DOH_NDC_Level_Dates_Info__c.getInstance('Data1');
            if(dohRepinfo != null){
                mainwrap.visionUpdateDate = dohRepinfo.Vision_Update_Date__c;
                mainwrap.gcpUpdateDate =  dohRepinfo.Vision_GCP_Update_Date__c;     
            }
            
            if(listOfGCPShortRecords.size() > 0){
                mainwrap.dohRecords = listOfGCPShortRecords[0]; 
            }
            
            
        }
        return mainwrap;
    }
 
    @auraEnabled
    public static MainWrapper getFilterDoHData(String tradePartnerName,String searchText){
        MainWrapper mainwrap = new MainWrapper();
        //  AccountsList accWrap = new AccountsList();
        system.debug('search method ');
        
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
        system.debug('search text----'+searchText);
        String comment='Yes';
        if(searchText != null && searchText !=''){
            searchText = '%'+searchText+'%';
            query = 'select Product__r.Phoenix_Rx_SRx_OTC__c,GCP_Backorder_RX__r.Vision_Product__r.ProductCode,GCP_Backorder_SRX__r.Vision_Product__r.ProductCode,GCP_Backorder_SRX__r.Vision_MoH__c,GCP_Backorder_SRX__r.Vision_On_Backorder__c,GCP_Backorder_RX__r.Vision_Backorder_Qty__c, '+strFields+' from ' + SobjectApiName + ' WHERE vision_gcp_trade_partner_name__c =:tradePartnerName AND (vision_gcp_package_description__c like :searchText or vision_gcp_ndc__c like :searchText)  ORDER By vision_gcp_package_description__c ASC';   
        }
        if(searchText == null && searchText ==''){
            system.debug('search text null');
            mainwrap.dohRecordsList = null;   
            
        }
        List < GCP_DOH_Trade_Partner_NDC__c > listOfGCPShortRecords = new List < GCP_DOH_Trade_Partner_NDC__c >();
        
        
        if(query != null && query != ''){
            listOfGCPShortRecords = Database.query(query);
            
        }
        system.debug('listOfGCPShortRecords-----'+listOfGCPShortRecords.size());
        //  mainwrap.noOfRecords = listOfGCPShortRecords.size();
        mainwrap.noOfRecords = listOfGCPShortRecords.size();
        mainwrap.dohRecordsList = listOfGCPShortRecords;   
        return mainwrap;
    }
    @auraEnabled
    public static MainWrapper fetchSortResults(string sortField,String searchText,boolean isAsc,String tradePartnerName,List < GCP_DOH_Trade_Partner_NDC__c > productList){
        set < Id > prodIds = new set < Id > ();
        MainWrapper mainwrap = new MainWrapper();        
        System.debug('productList>>>'+productList);
        list < GCP_DOH_Trade_Partner_NDC__c > sortResults = new list < GCP_DOH_Trade_Partner_NDC__c > ();
        List < GCP_DOH_Trade_Partner_NDC__c > wrlist = new List < GCP_DOH_Trade_Partner_NDC__c > ();
        String SobjectApiName = 'GCP_DOH_Trade_Partner_NDC__c';
        Map < String, Schema.SObjectType > schemaMap = Schema.getGlobalDescribe();
        Map < String, Schema.SObjectField > fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();
        for (GCP_DOH_Trade_Partner_NDC__c w: productList) {
            system.debug('Product:: '+w);
            prodIds.add(w.Id);
            
        }
        System.debug('prodIds'+ prodIds.size());
        System.debug('prodIds'+ prodIds);
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
        if(searchText != null && searchText !=''){
            searchText = '%'+searchText+'%';
            sSoql = 'select Product__r.Phoenix_Rx_SRx_OTC__c,GCP_Backorder_RX__r.Vision_Product__r.ProductCode,GCP_Backorder_SRX__r.Vision_Product__r.ProductCode,GCP_Backorder_SRX__r.Vision_MoH__c,GCP_Backorder_SRX__r.Vision_On_Backorder__c,GCP_Backorder_RX__r.Vision_Backorder_Qty__c, '+strFields+' from ' + SobjectApiName + ' WHERE vision_gcp_trade_partner_name__c =:tradePartnerName AND (vision_gcp_package_description__c like :searchText or vision_gcp_ndc__c like :searchText)  ORDER By vision_gcp_package_description__c ASC';   
        }
        if(searchText == null && searchText ==''){
            system.debug('search text null');
            mainwrap.dohRecordsList = null;   
            
        }            
        //sSoql = 'select Product__r.Phoenix_Rx_SRx_OTC__c,GCP_Backorder_RX__r.Vision_Product__r.ProductCode,GCP_Backorder_SRX__r.Vision_Product__r.ProductCode, '+strFields+' from ' + SobjectApiName + ' WHERE vision_gcp_trade_partner_name__c =:tradePartnerName and Vision_GCP_W8_DOH__c <=12 AND (vision_gcp_package_description__c like :searchText or vision_gcp_ndc__c like :searchText)  AND ID IN:prodIds';   
        /*if(productType != null && !productType.isEmpty()){
query = 'select Product__r.Phoenix_Rx_SRx_OTC__c,GCP_Backorder_RX__r.Vision_Product__r.ProductCode,GCP_Backorder_SRX__r.Vision_Product__r.ProductCode, '+strFields+' from ' + SobjectApiName + ' WHERE vision_gcp_trade_partner_name__c =:tradePartnerName and  Vision_GCP_W8_DOH__c <=12 AND Product__r.Phoenix_Rx_SRx_OTC__c =: productType AND (vision_gcp_package_description__c like :searchText or vision_gcp_ndc__c like :searchText)  AND ID IN:prodIds';     
}*/
        
        
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
        System.debug('sortResults size>>'+sortResults.size());
        mainwrap.noOfRecords = sortResults.size();
        
        for (GCP_DOH_Trade_Partner_NDC__c pr: sortResults) {
            for (GCP_DOH_Trade_Partner_NDC__c wr: productList) {
                if (wr.Id == pr.Id) {
                    wrlist.add(wr);
                    
                }
            }
        }
        
        return mainwrap;
        
        
    }
    @AuraEnabled
    public static MainWrapper getAwardedPositionData(String customerId, string Id){
        MainWrapper mainWrap = new MainWrapper();
        system.debug('customerId---'+customerId);
        List<GCP_DOH_Trade_Partner_NDC__c> ProdList = [SELECT id,Product__r.ProductCode FROM GCP_DOH_Trade_Partner_NDC__c where id =: Id limit 1];
        String ProductCode = ProdList[0].Product__r.ProductCode;
        List < Vision_Customer_Product_Tracker__c > awardedPositionList = [SELECT Vision_Account__c,Vision_Contract__r.Name,Vision_Current_Product_Position__c,Vision_Product__c,Vision_Product__r.Name,Vision_Product__r.Phoenix_NDC_11__c,Vision_Product__r.ProductCode FROM Vision_Customer_Product_Tracker__c where Vision_Product__r.ProductCode =: ProductCode and Vision_Current_Product_Position__c != null];
        system.debug('awardedPositionList---'+awardedPositionList.size());
        
        mainwrap.awardedPositionList = awardedPositionList;
        if(awardedPositionList.size() > 0){
            mainwrap.ProdName = awardedPositionList[0].Vision_Product__r.Name;
            mainwrap.Ndc = awardedPositionList[0].Vision_Product__r.Phoenix_NDC_11__c; 
            
        }
        return mainwrap;
    } 
    public class MainWrapper{
        @AuraEnabled public Boolean isProcessed;
        @AuraEnabled public Integer noOfRecords;
        @AuraEnabled public List<String> accgrpList;
        @AuraEnabled public String visionUpdateDate;
        @AuraEnabled public String gcpUpdateDate;
        @AuraEnabled public List<GCP_DOH_Trade_Partner_NDC__c> dohRecordsList;
        @AuraEnabled public GCP_DOH_Trade_Partner_NDC__c dohRecords;
        @AuraEnabled public String ProdName;
        @AuraEnabled public String Ndc;
        @AuraEnabled public List<Vision_Customer_Product_Tracker__c> awardedPositionList; 
        MainWrapper(){
            dohRecords = new GCP_DOH_Trade_Partner_NDC__c();
            dohRecordsList = new List<GCP_DOH_Trade_Partner_NDC__c>();
            awardedPositionList = new List<Vision_Customer_Product_Tracker__c>();
        }
        
    }
}