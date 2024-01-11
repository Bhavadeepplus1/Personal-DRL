public class Vision_Rx_Fresh_Backorder {
@auraEnabled
    public static MainWrapper getbackOrder(List<String> productType, Boolean showAll){
          List<String> apexClassList = new List<String>();
        apexClassList.add('GoogleBackOrderSRxandRxFetch');
        
        MainWrapper mainwrap = new MainWrapper();
                                mainWrap.isProcessed =  Vision_Rx_Compliance_NPR.apexJobStatus(apexClassList);

        AccountsList accWrap = new AccountsList();
        String query = '';
        String SobjectApiName = 'Vision_GCP_Backorder_SRx_Rx__c';
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
        List < Vision_GCP_Backorder_SRx_Rx__c > listOfSRxBackOrderRecords=[Select Vision_Backorder_Report_Date__c,Vision_GCP_Update_Date__c From Vision_GCP_Backorder_SRx_Rx__c order by Vision_Backorder_Report_Date__c desc limit 1];
      //  system.debug('listOfSRxBackOrderRecords>>>'+listOfSRxBackOrderRecords);
        Date reportDate = listOfSRxBackOrderRecords[0].Vision_Backorder_Report_Date__c;
        System.debug('reportDate'+ reportDate);
        String comment = 'Yes'; 
        String segment = 'Rx';
        if (productType != null && !productType.isEmpty()) {
           
                    query = 'select Vision_Product__r.Phoenix_Rx_SRx_OTC__c,Vision_Product__r.Phoenix_NDC_11__c,  '+strFields+' from ' + SobjectApiName + ' WHERE Vision_Backorder_Report_Date__c =:reportDate AND Vision_Product__r.Phoenix_Rx_SRx_OTC__c =: segment and Vision_Past_Week_MOH__c >0 and Vision_MoH__c < 0 ORDER By Vision_SKU_Description__c ASC';      
              
            
    }
       // System.debug('query1'+ query);
    if (productType == null || productType.size() == 0) {
                          query = 'select Vision_Product__r.Phoenix_Rx_SRx_OTC__c,Vision_Product__r.Phoenix_NDC_11__c,  '+strFields+' from ' + SobjectApiName + ' WHERE Vision_Backorder_Report_Date__c =:reportDate AND Vision_Product__r.Phoenix_Rx_SRx_OTC__c =: segment AND Vision_Past_Week_MOH__c > 0 and Vision_MoH__c < 0 ORDER By Vision_SKU_Description__c ASC';      

        
    }
     System.debug('query2'+ query);
        List < Vision_GCP_Backorder_SRx_Rx__c > listOfBackOrderRecordsSRx = Database.query(query);
     //   system.debug('listOfBackOrderRecordsSRx-----'+listOfBackOrderRecordsSRx.size());
        Back_Order_SRX_Dates_Info__c  borxdi = Back_Order_SRX_Dates_Info__c.getInstance('Data1');
        if(borxdi != null){
            mainwrap.visionUpdateDate =  borxdi.Vision_Update_Date__c;
        }
        
        
        
        mainwrap.sdRecords = listOfSRxBackOrderRecords[0];
        mainwrap.backOrderRecordsSRx = listOfBackOrderRecordsSRx; 
          mainwrap.noOfRecords = listOfBackOrderRecordsSRx.size();   
        return mainwrap;
    }
    @auraEnabled
    public static List < Vision_GCP_Backorder_SRx_Rx__c > fetchSortResults(string sortField,boolean isAsc,List < Vision_GCP_Backorder_SRx_Rx__c > productList){
        set < Id > prodIds = new set < Id > ();
        list < Vision_GCP_Backorder_SRx_Rx__c > sortResults = new list < Vision_GCP_Backorder_SRx_Rx__c > ();
        List < Vision_GCP_Backorder_SRx_Rx__c > wrlist = new List < Vision_GCP_Backorder_SRx_Rx__c > ();
        String SobjectApiName = 'Vision_GCP_Backorder_SRx_Rx__c';
        Map < String, Schema.SObjectType > schemaMap = Schema.getGlobalDescribe();
        Map < String, Schema.SObjectField > fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();
        if(productList != null)  
            for (Vision_GCP_Backorder_SRx_Rx__c w: productList) {
               // system.debug('Product:: '+w);
                prodIds.add(w.Id);
                
            }
        String strFields = '';
        
        for (String fieldName: fieldMap.keyset()) {
            if (strFields == null || strFields == '') {
                strFields = fieldName;
            } else {
                strFields = strFields + ' , ' + fieldName;
            }
        }
        
        String sSoql = 'select ' + strFields + ' from Vision_GCP_Backorder_SRx_Rx__c WHERE ID IN:prodIds';
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
        for (Vision_GCP_Backorder_SRx_Rx__c pr: sortResults) {
            for (Vision_GCP_Backorder_SRx_Rx__c wr: productList) {
                if (wr.Id == pr.Id) {
                    wrlist.add(wr);
                    
                }
            }
        }
        System.debug('wrlist--->'+ wrlist);
        return wrlist;
        
        
        
        
    }
    @auraEnabled
    public static MainWrapper getFilterBackOrder(String searchText,  Boolean showAll){
      //  system.debug('searchText-----'+searchText);
        MainWrapper mainwrap = new MainWrapper();
        AccountsList accWrap = new AccountsList();
        String query = '';
        String SobjectApiName = 'Vision_GCP_Backorder_SRx_Rx__c';
        Map < String, Schema.SObjectType > schemaMap = Schema.getGlobalDescribe();
        Map < String, Schema.SObjectField > fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();
        String strFields = '';
                List < Vision_GCP_Backorder_SRx_Rx__c > listOfSRxBackOrderRecords=[Select Vision_Backorder_Report_Date__c,Vision_GCP_Update_Date__c From Vision_GCP_Backorder_SRx_Rx__c order by Vision_Backorder_Report_Date__c desc limit 1];
  Date reportDate = listOfSRxBackOrderRecords[0].Vision_Backorder_Report_Date__c;
        String comment = 'Yes'; 
        String segment = 'Rx';
        for (String fieldName: fieldMap.keyset()) {
            if (strFields == null || strFields == '') {
                strFields = fieldName;
            } else {
                strFields = strFields + ' , ' + fieldName;
            }
        }
       //searchText = '%'+searchText+'%';
        if(searchText != null && searchText !=''){
                        searchText = '%'+searchText+'%';

                    query = 'select Vision_Product__r.Phoenix_Rx_SRx_OTC__c,Vision_Product__r.Phoenix_NDC_11__c,  '+strFields+' from ' + SobjectApiName + ' WHERE (Vision_SKU_Description__c like : searchText OR Vision_Product__r.Phoenix_NDC_11__c like : searchText) and Vision_Backorder_Report_Date__c =:reportDate AND Vision_Product__r.Phoenix_Rx_SRx_OTC__c =: segment and Vision_Past_Week_MOH__c > 0 and Vision_MoH__c < 0 ORDER By Vision_SKU_Description__c ASC';      
       
        }else if(searchText == null || searchText ==''){
                         query = 'select Vision_Product__r.Phoenix_Rx_SRx_OTC__c,Vision_Product__r.Phoenix_NDC_11__c,  '+strFields+' from ' + SobjectApiName + ' WHERE Vision_Backorder_Report_Date__c =:reportDate AND Vision_Product__r.Phoenix_Rx_SRx_OTC__c =: segment and Vision_Past_Week_MOH__c > 0 and Vision_MoH__c < 0 ORDER By Vision_SKU_Description__c ASC';      
      
        }
        List < Vision_GCP_Backorder_SRx_Rx__c > listOfBackOrderRecordsSRx = Database.query(query);
        mainwrap.backOrderRecordsSRx = listOfBackOrderRecordsSRx;   
        mainwrap.noOfRecords = listOfBackOrderRecordsSRx.size();   
        return mainwrap;}
  
    public class Wrapper {
        
        @AuraEnabled public List < Vision_GCP_Backorder_SRx_Rx__c > gcpShortDates; 
        @AuraEnabled public List < string > accountList; 
        @AuraEnabled public List < string > prodFamilyList; 
        
        Wrapper() {
            
            gcpShortDates = new List < Vision_GCP_Backorder_SRx_Rx__c > ();
            accountList = new List < string > ();
            prodFamilyList = new List < string > ();
            
        }
    } 
    public class MainWrapper{
        //@AuraEnabled public String headerName;
        //@AuraEnabled public List<AccountsList> accList;
        //@AuraEnabled public List<String> accgrpList;
        @AuraEnabled public String visionUpdateDate; 
        @AuraEnabled public Boolean isProcessed;
        @AuraEnabled public Integer noOfRecords;
        @AuraEnabled public  List<Vision_GCP_Backorder_SRx_Rx__c> backOrderRecordsSRx;
        @AuraEnabled public Vision_GCP_Backorder_SRx_Rx__c sdRecords;
        mainWrapper(){
            sdRecords = new Vision_GCP_Backorder_SRx_Rx__c();
            backOrderRecordsSRx = new List<Vision_GCP_Backorder_SRx_Rx__c>();
            
        }
    }
    
    Public Class AccountsList{
        @AuraEnabled public String accName;
        @AuraEnabled public Map<Id,String> MohMap;
        @AuraEnabled public Boolean showAccount;
        @AuraEnabled public  List<Vision_GCP_Backorder_SRx_Rx__c> backOrderRecords;
        @AuraEnabled public List<productFamily> productFamily;
        AccountsList(){
            backOrderRecords = new List<Vision_GCP_Backorder_SRx_Rx__c>();
            showAccount = true;
            MohMap = new Map<Id,String>();
        }
    }
    Public Class productFamily{
        
        @AuraEnabled public List<Vision_GCP_Backorder_SRx_Rx__c> sdpfist;
        productFamily(){
            sdpfist = new List<Vision_GCP_Backorder_SRx_Rx__c>();
            
        }
        
    }
    
}