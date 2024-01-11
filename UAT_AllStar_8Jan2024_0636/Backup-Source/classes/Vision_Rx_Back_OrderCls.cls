public class Vision_Rx_Back_OrderCls {
    @auraEnabled
    public static MainWrapper getCustomers(){
  List<String> apexClassList = new List<String>();
        apexClassList.add('GoogleBackOrderOTCFetch');
        
        MainWrapper mainwrap = new MainWrapper();
        mainWrap.isProcessed =  Vision_Rx_Compliance_NPR.apexJobStatus(apexClassList);
        //doh_report_dates_info__c dohRepinfo = doh_report_dates_info__c.getInstance('Data1');
        //mainwrap.visionUpdateDate = dohRepinfo.Vision_Update_Date__c;
        String query = '';
        //  string customer ='CONTROL LABEL';
        set<string> accgrpsset = new set<string>();
        
        List < Vision_GCP_Backorder_OTC__c > listOfRxBackOrderRecords=[Select Vision_Backorder_Report_Date__c,Vision_Gcp_Update_Date__c From Vision_GCP_Backorder_OTC__c order by Vision_Backorder_Report_Date__c desc limit 1];
      //  system.debug('listOfRxBackOrderRecords>>>'+listOfRxBackOrderRecords);
        String reportDate = String.valueOf(listOfRxBackOrderRecords[0].Vision_Backorder_Report_Date__c);
        
        /*   List<AggregateResult> AggregateResultList =[SELECT GCP_Customer_Name__c FROM Vision_GCP_Backorder_OTC__c GROUP BY GCP_Customer_Name__c having Vision_Backorder_Report_Date__c =: reportDate];
for(AggregateResult aggr : AggregateResultList){
accgrpsset.add((String) aggr.get('GCP_Customer_Name__c'));
}*/
        List<Vision_GCP_Backorder_OTC__c> otcList =[SELECT GCP_Customer_Name__c FROM Vision_GCP_Backorder_OTC__c where Vision_Backorder_Report_Date__c =: reportDate order by GCP_Customer_Name__c ASC];		
        for(Vision_GCP_Backorder_OTC__c otcRec : otcList){
            accgrpsset.add(otcRec.GCP_Customer_Name__c);
        }
        List<string> accgrpList = new List<string>();
        accgrpList.addAll(accgrpsset);
      //  system.debug('accgrpList-----'+accgrpList.size());
       // system.debug('accgrpList-----'+accgrpList);
        if(accgrpList.size()>0){
            string customer = accgrpList[0];
            Back_Order_OTC_Dates_Info__c  borxdi = Back_Order_OTC_Dates_Info__c.getInstance('Data1');
            if(borxdi != null){
                mainwrap.visionUpdateDate =  borxdi.Vision_Update_Date__c;
            }
            mainwrap.accgrpList=accgrpList;
            mainwrap.sdRecords = listOfRxBackOrderRecords[0];
            mainwrap.noOfRecords = getbackOrder(customer,false).noOfRecords;
            
            mainwrap.accList = getbackOrder(customer,false).accList;
        }
        return mainwrap;
    }
    
    @auraEnabled
    public static MainWrapper getbackOrder(String customer, Boolean showAll){
      //  system.debug('customer-----'+customer);
      //  system.debug('showAll-----'+showAll);
        MainWrapper mainwrap = new MainWrapper();
        AccountsList accWrap = new AccountsList();
        List < Vision_GCP_Backorder_OTC__c > listOfRxBackOrderRecords=[Select Vision_Backorder_Report_Date__c,Vision_Gcp_Update_Date__c From Vision_GCP_Backorder_OTC__c order by Vision_Backorder_Report_Date__c desc limit 1];
        if(listOfRxBackOrderRecords.size()>0){
            String reportDate = listOfRxBackOrderRecords[0].Vision_Backorder_Report_Date__c;
            
            String query = '';
            String SobjectApiName = 'Vision_GCP_Backorder_OTC__c';
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
            if(showAll){
             //   system.debug('Inside if');
                query = 'select Vision_Product__r.Name,Vision_Product__r.Phoenix_NDC_11__c, '+strFields+' from ' + SobjectApiName + ' WHERE GCP_Customer_Name__c =:customer and Vision_Backorder_Report_Date__c =: reportDate and Vision_Backorder_Qty__c>0';   
            }
            else{
             //   system.debug('Inside else');
                                query = 'select Vision_Product__r.Name,Vision_Product__r.Phoenix_NDC_11__c, '+strFields+' from ' + SobjectApiName + ' WHERE GCP_Customer_Name__c =:customer and Vision_Backorder_Report_Date__c =: reportDate';   

              //  query = 'select Vision_Product__r.Name,Vision_Product__r.Phoenix_NDC_11__c, '+strFields+' from ' + SobjectApiName + ' WHERE GCP_Customer_Name__c =:customer and Vision_Backorder_Report_Date__c =: reportDate';     
            }
            
            
            AccountsList accList = new AccountsList();
            List < Vision_GCP_Backorder_OTC__c > listOfGCPShortRecords = Database.query(query);
          //  system.debug('listOfGCPShortRecords-----'+listOfGCPShortRecords.size());
            mainwrap.noOfRecords = listOfGCPShortRecords.size();
            List<AccountsList> AccountsWrapperList = new List<AccountsList>();
            map<String,List<Vision_GCP_Backorder_OTC__c>> accMap = new map<String,List<Vision_GCP_Backorder_OTC__c>>();
            map<Id,String> MoHMap = new map<Id,String>();
            
            accList.backOrderRecords = listOfGCPShortRecords;
            AccountsWrapperList.add(accList);
          //  system.debug('AccountsWrapperList-----'+AccountsWrapperList.size());
            mainwrap.accList = AccountsWrapperList;   
        }
        return mainwrap;
    }
    @auraEnabled
    public static MainWrapper getFilterBackOrder(String searchText,String customer,Boolean showAll){
        MainWrapper mainwrap = new MainWrapper();
        AccountsList accWrap = new AccountsList();
        List < Vision_GCP_Backorder_OTC__c > listOfRxBackOrderRecords=[Select Vision_Backorder_Report_Date__c,Vision_Gcp_Update_Date__c From Vision_GCP_Backorder_OTC__c order by Vision_Backorder_Report_Date__c desc limit 1];
        String reportDate = listOfRxBackOrderRecords[0].Vision_Backorder_Report_Date__c;
        String query = '';
        String SobjectApiName = 'Vision_GCP_Backorder_OTC__c';
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
        searchText = '%'+searchText+'%';
        if(searchText != null && searchText !=''){
            if(showAll){
                query = 'select Vision_Product__r.Name,Vision_Product__r.Phoenix_NDC_11__c, '+strFields+' from ' + SobjectApiName + ' WHERE GCP_Customer_Name__c =:customer AND (Vision_Product__r.Name like : searchText or Vision_Sku_Code__c like : searchText)  and Vision_Backorder_Qty__c>0 and Vision_Backorder_Report_Date__c =: reportDate';
                
            }
            else{
                query = 'select Vision_Product__r.Name,Vision_Product__r.Phoenix_NDC_11__c, '+strFields+' from ' + SobjectApiName + ' WHERE GCP_Customer_Name__c =:customer AND (Vision_Product__r.Name like : searchText or Vision_Sku_Code__c like : searchText)  and Vision_Backorder_Report_Date__c =: reportDate';
            }   
        }
        
        List < Vision_GCP_Backorder_OTC__c > listOfGCPShortRecords = Database.query(query);
      //  system.debug('listOfGCPShortRecords-----'+listOfGCPShortRecords.size());
        mainwrap.noOfRecords = listOfGCPShortRecords.size();
        if(listOfGCPShortRecords != null){
            List<AccountsList> AccountsWrapperList = new List<AccountsList>();
            map<String,List<Vision_GCP_Backorder_OTC__c>> accMap = new map<String,List<Vision_GCP_Backorder_OTC__c>>();
            for(Vision_GCP_Backorder_OTC__c item : listOfGCPShortRecords){
                if(accMap.containsKey(item.GCP_Customer_Name__c)){
                    List<Vision_GCP_Backorder_OTC__c> sdList = accMap.get(item.GCP_Customer_Name__c);
                    sdList.add(item);
                    accMap.put(item.GCP_Customer_Name__c,sdList);
                    
                }
                else{
                    accMap.put(item.GCP_Customer_Name__c,new List<Vision_GCP_Backorder_OTC__c>{item});
                }
            }
            AccountsList accList = new AccountsList();
            for(string accName : accMap.keySet()){
                
                accList.accName = accName;
                accList.backOrderRecords = listOfGCPShortRecords;
                
            }
            AccountsWrapperList.add(accList);
            
          //  system.debug('AccountsWrapperList-----'+AccountsWrapperList);
            mainwrap.accList = AccountsWrapperList;  
        }
        return mainwrap;}
    
    @auraEnabled
    public static MainWrapper fetchSortResults(string sortField,boolean isAsc,String customer, Boolean showAll,String searchText){
        
        set < Id > prodIds = new set < Id > ();
        MainWrapper mainwrap = new MainWrapper();
        AccountsList accWrap = new AccountsList();
        String sSoql = '';
        String SobjectApiName = 'Vision_GCP_Backorder_OTC__c';
        Map < String, Schema.SObjectType > schemaMap = Schema.getGlobalDescribe();
        Map < String, Schema.SObjectField > fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();
        List < Vision_GCP_Backorder_OTC__c > listOfRxBackOrderRecords=[Select Vision_Backorder_Report_Date__c,Vision_Gcp_Update_Date__c From Vision_GCP_Backorder_OTC__c order by Vision_Backorder_Report_Date__c desc limit 1];
        String reportDate = listOfRxBackOrderRecords[0].Vision_Backorder_Report_Date__c;
        String strFields = '';
        
        for (String fieldName: fieldMap.keyset()) {
            if (strFields == null || strFields == '') {
                strFields = fieldName;
            } else {
                strFields = strFields + ' , ' + fieldName;
            }
        }
        
        if(searchText != null && searchText !=''){
            searchText = '%'+searchText+'%';
            
            if(showAll){
                sSoql = 'select Vision_Product__r.Name,Vision_Product__r.Phoenix_NDC_11__c, '+strFields+' from ' + SobjectApiName + ' WHERE GCP_Customer_Name__c =:customer and Vision_Backorder_Report_Date__c =: reportDate and Vision_Backorder_Qty__c>0 AND (Vision_Product__r.Name like : searchText or Vision_Sku_Code__c like : searchText) ';   
            }
            else{
                sSoql = 'select Vision_Product__r.Name,Vision_Product__r.Phoenix_NDC_11__c, '+strFields+' from ' + SobjectApiName + ' WHERE GCP_Customer_Name__c =:customer and Vision_Backorder_Report_Date__c =: reportDate AND (Vision_Product__r.Name like : searchText or Vision_Sku_Code__c like : searchText) ';   
            } 
        }
        else{
            if(showAll){
                sSoql = 'select Vision_Product__r.Name,Vision_Product__r.Phoenix_NDC_11__c, '+strFields+' from ' + SobjectApiName + ' WHERE GCP_Customer_Name__c =:customer and Vision_Backorder_Report_Date__c =: reportDate and Vision_Backorder_Qty__c>0';   
                
            }else{
                sSoql = 'select Vision_Product__r.Name,Vision_Product__r.Phoenix_NDC_11__c, '+strFields+' from ' + SobjectApiName + ' WHERE GCP_Customer_Name__c =:customer and Vision_Backorder_Report_Date__c =: reportDate';   
                
            }
        }
        
        //     sSoql = 'select ' + strFields + ' from Vision_GCP_Backorder_OTC__c WHERE ID IN:prodIds';
        if (sortField != null && sortField != '') {
            System.debug('sort');
            sSoql += ' order by ' + sortField;
            
            if (isAsc) {
                System.debug('asc');
                sSoql += ' ASC NULLS LAST';
            } else {
                System.debug('asc else');
                sSoql += ' DESC NULLS LAST';
            }
            
        }
        
        //sSoql += ' NULLS LAST LIMIT 100 ';
      //  system.debug('sSoql-----'+sSoql);
        AccountsList accList = new AccountsList();
        List < Vision_GCP_Backorder_OTC__c > listOfGCPShortRecords = Database.query(sSoql);
        for(Vision_GCP_Backorder_OTC__c sd : listOfGCPShortRecords ){
      //      system.debug('Vision_Total_Open_Order_Qty__c-----'+sd.Vision_Total_Open_Order_Qty__c); 
        }
      //  system.debug('listOfGCPShortRecords-----'+listOfGCPShortRecords.size());
        mainwrap.noOfRecords = listOfGCPShortRecords.size();
        List<AccountsList> AccountsWrapperList = new List<AccountsList>();
        map<String,List<Vision_GCP_Backorder_OTC__c>> accMap = new map<String,List<Vision_GCP_Backorder_OTC__c>>();
        map<Id,String> MoHMap = new map<Id,String>();
        
        accList.backOrderRecords = listOfGCPShortRecords;
        AccountsWrapperList.add(accList);
     //   system.debug('AccountsWrapperList-----'+AccountsWrapperList.size());
        mainwrap.accList = AccountsWrapperList;   
        return mainwrap;
    }
    
    
    public class Wrapper {
        
        @AuraEnabled public List < Vision_GCP_Backorder_OTC__c > gcpShortDates; 
        @AuraEnabled public List < string > accountList; 
        @AuraEnabled public List < string > prodFamilyList; 
        
        Wrapper() {
            
            gcpShortDates = new List < Vision_GCP_Backorder_OTC__c > ();
            accountList = new List < string > ();
            prodFamilyList = new List < string > ();
            
        }
    } 
    public class MainWrapper{
        //@AuraEnabled public String headerName;
        //@AuraEnabled public Integer noOfRecords;
        @AuraEnabled public Integer noOfRecords;
        @AuraEnabled public Boolean isProcessed;
        @AuraEnabled public List<AccountsList> accList;
        @AuraEnabled public List<String> accgrpList;
        @AuraEnabled public String visionUpdateDate;   
        @AuraEnabled public Vision_GCP_Backorder_OTC__c sdRecords;
        mainWrapper(){
            sdRecords = new Vision_GCP_Backorder_OTC__c();
            accList = new List<AccountsList>();
            accgrpList = new List<String>();
        }
    }
    Public Class AccountsList{
        @AuraEnabled public String accName;
        @AuraEnabled public Map<Id,String> MohMap;
        @AuraEnabled public Boolean showAccount;
        @AuraEnabled public List<Vision_GCP_Backorder_OTC__c> backOrderRecords;
        @AuraEnabled public List<productFamily> productFamily;
        AccountsList(){
            backOrderRecords = new List<Vision_GCP_Backorder_OTC__c>();
            showAccount = true;
            MohMap = new Map<Id,String>();
        }
    }
    Public Class productFamily{
        
        @AuraEnabled public List<Vision_GCP_Backorder_OTC__c> sdpfist;
        productFamily(){
            sdpfist = new List<Vision_GCP_Backorder_OTC__c>();
            
        }
        
    }
    
}