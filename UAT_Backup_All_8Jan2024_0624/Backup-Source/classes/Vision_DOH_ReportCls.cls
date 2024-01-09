public class Vision_DOH_ReportCls {
    @auraEnabled
    public static MainWrapper getAccountGroups(){
List<String> apexClassList = new List<String>();
        apexClassList.add('GoogleTradePartnerDOHRepFetch');
        apexClassList.add('Vision_DoH_Summary_Batch');
        
        MainWrapper mainwrap = new MainWrapper();
        mainWrap.isProcessed =  Vision_Rx_Compliance_NPR.apexJobStatus(apexClassList);        List<AggregateResult> AggregateResultList =[SELECT Trade_Partner_Name__c FROM GCP_Trade_Partner_DOH_Report__c GROUP BY Trade_Partner_Name__c ];
       List < GCP_Trade_Partner_DOH_Report__c > listOfGCPShortRecords = [SELECT Trade_Partner_Name__c,Vision_GCP_Update_Date__c,W1_Day__c,W2_Day__c,W3_Day__c,W4_Day__c,W5_Day__c,W6_Day__c,W7_Day__c,W8_Day__c FROM GCP_Trade_Partner_DOH_Report__c limit 1]; 
        set<string> accgrpsset = new set<string>();
        for(AggregateResult aggr : AggregateResultList){
            accgrpsset.add((String) aggr.get('Trade_Partner_Name__c'));
        }
        List<string> accgrpList = new List<string>();
        accgrpList.addAll(accgrpsset);
       // system.debug('accgrpList-----'+accgrpList.size());
       // system.debug('accgrpList-----'+accgrpList);
        string customer = accgrpList[0];
        mainwrap.accgrpList=accgrpList;
        doh_report_dates_info__c dohRepinfo = doh_report_dates_info__c.getInstance('Data1');
        if(dohRepinfo != null){
            mainwrap.visionUpdateDate = dohRepinfo.Vision_Update_Date__c;
        }
        mainwrap.dohRecords = listOfGCPShortRecords[0];
        mainwrap.dohSummary = getShortDateData(customer).dohSummary;
        return mainwrap;
    }
    @auraEnabled
    public static MainWrapper getShortDateData(String customer){
        
        Wrapper wrapperObject = new Wrapper();
        MainWrapper mainWrapper = new MainWrapper();
        
        String tradePartnerQuery = 'Select GCP_DOH_Trade_Partner_NDC__r.Vision_GCP_W1_DOH__c,GCP_DOH_Trade_Partner_NDC__r.Vision_GCP_W2_DOH__c,GCP_DOH_Trade_Partner_NDC__r.Vision_GCP_W3_DOH__c,GCP_DOH_Trade_Partner_NDC__r.Vision_GCP_W4_DOH__c,GCP_DOH_Trade_Partner_NDC__r.Vision_GCP_W5_DOH__c,GCP_DOH_Trade_Partner_NDC__r.Vision_GCP_W6_DOH__c,GCP_DOH_Trade_Partner_NDC__r.Vision_GCP_W7_DOH__c,GCP_DOH_Trade_Partner_NDC__r.Vision_GCP_W8_DOH__c, '+Phoenix_Util.getsObjectFieds('DoH_Summary__c')+' FROM DoH_Summary__c WHERE Trade_Partner_Name__c =:customer';
        List < DoH_Summary__c > DOHSummaryList = Database.query(tradePartnerQuery);
       // system.debug('tradePartnerQuery-----'+DOHSummaryList);
       // system.debug('tradePartnerQuery-----'+DOHSummaryList.size());
        mainWrapper.dohSummary = DOHSummaryList;
        return mainWrapper;
        
        
    }
    @auraEnabled
    public static MainWrapper getRxDoHData(List<String> productType,String customer,String searchText){
        
        Wrapper wrapperObject = new Wrapper();
        MainWrapper mainWrapper = new MainWrapper();
        String tradePartnerQuery = '';
        List < DoH_Summary__c > DOHSummaryList = new List < DoH_Summary__c >();
        if (productType != null && !productType.isEmpty()) {
               if(searchText != null && searchText !=''){ 
            searchText = '%'+searchText+'%';
                          tradePartnerQuery = 'Select GCP_DOH_Trade_Partner_NDC__r.Vision_GCP_W1_DOH__c,GCP_DOH_Trade_Partner_NDC__r.Vision_GCP_W2_DOH__c,GCP_DOH_Trade_Partner_NDC__r.Vision_GCP_W3_DOH__c,GCP_DOH_Trade_Partner_NDC__r.Vision_GCP_W4_DOH__c,GCP_DOH_Trade_Partner_NDC__r.Vision_GCP_W5_DOH__c,GCP_DOH_Trade_Partner_NDC__r.Vision_GCP_W6_DOH__c,GCP_DOH_Trade_Partner_NDC__r.Vision_GCP_W7_DOH__c,GCP_DOH_Trade_Partner_NDC__r.Vision_GCP_W8_DOH__c, '+Phoenix_Util.getsObjectFieds('DoH_Summary__c')+' FROM DoH_Summary__c WHERE Trade_Partner_Name__c =:customer and Vision_Segment__c =: productType and (Package_Description__c like :searchText OR NDC__c like :searchText)';      
               }
            else{
                             tradePartnerQuery = 'Select GCP_DOH_Trade_Partner_NDC__r.Vision_GCP_W1_DOH__c,GCP_DOH_Trade_Partner_NDC__r.Vision_GCP_W2_DOH__c,GCP_DOH_Trade_Partner_NDC__r.Vision_GCP_W3_DOH__c,GCP_DOH_Trade_Partner_NDC__r.Vision_GCP_W4_DOH__c,GCP_DOH_Trade_Partner_NDC__r.Vision_GCP_W5_DOH__c,GCP_DOH_Trade_Partner_NDC__r.Vision_GCP_W6_DOH__c,GCP_DOH_Trade_Partner_NDC__r.Vision_GCP_W7_DOH__c,GCP_DOH_Trade_Partner_NDC__r.Vision_GCP_W8_DOH__c, '+Phoenix_Util.getsObjectFieds('DoH_Summary__c')+' FROM DoH_Summary__c WHERE Trade_Partner_Name__c =:customer and Vision_Segment__c =: productType';

            }
            
        }
        if (productType == null || productType.size() == 0) {
               if(searchText != null && searchText !=''){ 
            searchText = '%'+searchText+'%';
               tradePartnerQuery = 'Select GCP_DOH_Trade_Partner_NDC__r.Vision_GCP_W1_DOH__c,GCP_DOH_Trade_Partner_NDC__r.Vision_GCP_W2_DOH__c,GCP_DOH_Trade_Partner_NDC__r.Vision_GCP_W3_DOH__c,GCP_DOH_Trade_Partner_NDC__r.Vision_GCP_W4_DOH__c,GCP_DOH_Trade_Partner_NDC__r.Vision_GCP_W5_DOH__c,GCP_DOH_Trade_Partner_NDC__r.Vision_GCP_W6_DOH__c,GCP_DOH_Trade_Partner_NDC__r.Vision_GCP_W7_DOH__c,GCP_DOH_Trade_Partner_NDC__r.Vision_GCP_W8_DOH__c, '+Phoenix_Util.getsObjectFieds('DoH_Summary__c')+' FROM DoH_Summary__c WHERE Trade_Partner_Name__c =:customer and (Package_Description__c like :searchText OR NDC__c like :searchText)';
               }
            else{
               tradePartnerQuery = 'Select GCP_DOH_Trade_Partner_NDC__r.Vision_GCP_W1_DOH__c,GCP_DOH_Trade_Partner_NDC__r.Vision_GCP_W2_DOH__c,GCP_DOH_Trade_Partner_NDC__r.Vision_GCP_W3_DOH__c,GCP_DOH_Trade_Partner_NDC__r.Vision_GCP_W4_DOH__c,GCP_DOH_Trade_Partner_NDC__r.Vision_GCP_W5_DOH__c,GCP_DOH_Trade_Partner_NDC__r.Vision_GCP_W6_DOH__c,GCP_DOH_Trade_Partner_NDC__r.Vision_GCP_W7_DOH__c,GCP_DOH_Trade_Partner_NDC__r.Vision_GCP_W8_DOH__c, '+Phoenix_Util.getsObjectFieds('DoH_Summary__c')+' FROM DoH_Summary__c WHERE Trade_Partner_Name__c =:customer';

            }
            
        }
                   DOHSummaryList = Database.query(tradePartnerQuery);
 
        mainWrapper.dohSummary = DOHSummaryList;
        
        return mainWrapper;
        
    }
    @auraEnabled
    public static MainWrapper getFilterDoHData(String searchText,String customer, List<String> productType){
        Wrapper wrapperObject = new Wrapper();
        MainWrapper mainWrapper = new MainWrapper();
        String query = '';
        
        if(searchText != null && searchText !=''){ 
            searchText = '%'+searchText+'%';
            query = 'Select '+Phoenix_Util.getsObjectFieds('DoH_Summary__c')+' FROM DoH_Summary__c WHERE Trade_Partner_Name__c =:customer and (Package_Description__c like :searchText OR NDC__c like :searchText)';
         //   system.debug('if1-->'+ query); 
            if(productType != null && !productType.isEmpty()){
                query = 'Select '+Phoenix_Util.getsObjectFieds('DoH_Summary__c')+' FROM DoH_Summary__c WHERE Trade_Partner_Name__c =:customer and Vision_Segment__c =:productType and (Package_Description__c like :searchText OR NDC__c like :searchText)';    
           //     system.debug('if2-->'+ query);
            }
        }
        else{
                    if (productType != null && !productType.isEmpty()) {
                               query = 'Select '+Phoenix_Util.getsObjectFieds('DoH_Summary__c')+' FROM DoH_Summary__c WHERE Trade_Partner_Name__c =:customer and Vision_Segment__c =:productType'; 
     
                    }
                    if (productType == null || productType.size() == 0) {
                                query = 'Select '+Phoenix_Util.getsObjectFieds('DoH_Summary__c')+' FROM DoH_Summary__c WHERE Trade_Partner_Name__c =:customer'; 
    
                    }
           // system.debug('else-->'+ query);
        }
        List < DoH_Summary__c > DOHSummaryList = Database.query(query);
     //   system.debug('tradePartnerQuery-----'+DOHSummaryList);
       // system.debug('tradePartnerQuery-----'+DOHSummaryList.size());
        mainWrapper.dohSummary = DOHSummaryList;
        return mainWrapper;
        
    }  
    @auraEnabled
    public static productFamily getProdFamData(String tradePartnerName,String Product){
        String query = '';
        String SobjectApiName = 'GCP_Trade_Partner_DOH_Report__c';
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
        
        
        query = 'select '+strFields+' from ' + SobjectApiName + ' WHERE Trade_Partner_Name__c =:tradePartnerName AND Package_Description__c =: Product ORDER BY Trade_Partner_Name__c ASC';   
        
        
        
        List < GCP_Trade_Partner_DOH_Report__c > listOfGCPShortRecords = Database.query(query);
      //  system.debug('total records-->'+listOfGCPShortRecords);
        productFamily prodWrap = new productFamily();
        
        
        prodWrap.dohRecords = listOfGCPShortRecords; 
        return prodWrap;
    }
    @auraEnabled
    public static productFamily fetchSortResults(string sortField,boolean isAsc,String Product,String tradePartnerName){
        
        String query = '';
      
        String SobjectApiName = 'GCP_Trade_Partner_DOH_Report__c';
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
        
        
        // query = 'select '+strFields+' from ' + SobjectApiName + ' WHERE Trade_Partner_Name__c =:tradePartnerName AND Package_Description__c =: Product ORDER BY Trade_Partner_Name__c ASC';   
        
        String sSoql = 'select '+strFields+' from ' + SobjectApiName + ' WHERE Trade_Partner_Name__c =:tradePartnerName AND Package_Description__c =: Product';     
        
        if (sortField != null && sortField != '') {
            sSoql += ' order by ' + sortField;
            if (isAsc) {
                sSoql += ' ASC NULLS LAST';
            } else {
                sSoql += ' DESC NULLS LAST';
            }
        }
        
        List < GCP_Trade_Partner_DOH_Report__c > listOfGCPShortRecords = Database.query(sSoql);
      //  system.debug('total records-->'+listOfGCPShortRecords);
        productFamily prodWrap = new productFamily();
        
        
        prodWrap.dohRecords = listOfGCPShortRecords;
      //  system.debug('prodWrap records-->'+prodWrap);
        return prodWrap;
    }
    /* @auraEnabled
public static MainWrapper fetchSortSummaryResults(string sortField,boolean isAsc,String Product,String tradePartnerName){

String query = '';
system.debug('sortField>>>'+sortField);
system.debug('isAsc>>>'+isAsc);
system.debug('Product>>>'+Product);
system.debug('tradePartnerName>>>'+tradePartnerName);
String SobjectApiName = 'DoH_Summary__c';
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


// query = 'select '+strFields+' from ' + SobjectApiName + ' WHERE Trade_Partner_Name__c =:tradePartnerName AND Package_Description__c =: Product ORDER BY Trade_Partner_Name__c ASC';   

String sSoql = 'select '+strFields+' from ' + SobjectApiName + ' WHERE Trade_Partner_Name__c =:tradePartnerName AND Package_Description__c =: Product';     

if (sortField != null && sortField != '') {
sSoql += ' order by ' + sortField;
if (isAsc) {
sSoql += ' ASC NULLS LAST';
} else {
sSoql += ' DESC NULLS LAST';
}
}

List < DoH_Summary__c > listOfGCPShortRecords = Database.query(sSoql);
system.debug('total records-->'+listOfGCPShortRecords);
MainWrapper mainWrapper = new MainWrapper();

mainWrapper.dohSummary = listOfGCPShortRecords;
return mainWrapper;

}*/
    public class Wrapper {
        
        @AuraEnabled public List < GCP_Trade_Partner_DOH_Report__c > gcpShortDates; 
        @AuraEnabled public List < string > accountList; 
        @AuraEnabled public List < string > prodFamilyList; 
        
        Wrapper() {
            
            gcpShortDates = new List < GCP_Trade_Partner_DOH_Report__c > ();
            accountList = new List < string > ();
            prodFamilyList = new List < string > ();
            
        }
    } 
    public class MainWrapper{
                @AuraEnabled public Boolean isProcessed;
        //@AuraEnabled public String headerName;
        @AuraEnabled public List<DoH_Summary__c> dohSummary;
        @AuraEnabled public List<AccountsList> accList;
        @AuraEnabled public List<String> accgrpList;
        @AuraEnabled public String visionUpdateDate;
        @AuraEnabled public GCP_Trade_Partner_DOH_Report__c dohRecords;
        MainWrapper(){
            dohRecords = new GCP_Trade_Partner_DOH_Report__c();
            dohSummary = new List<DoH_Summary__c>();
        }
        
    }
    Public Class AccountsList{
        @AuraEnabled public String tradePartnerName;
        @AuraEnabled public String accName;
        @AuraEnabled public integer WAC;
        @AuraEnabled public AggregateResult aggrResult;
        
        @AuraEnabled public Boolean showAccount;
        @AuraEnabled public List<String> acctCodes;
        AccountsList(){
            acctCodes = new List<String>();
            showAccount = true;
        }
    }
    Public Class productFamily{
        // @AuraEnabled public String pfName;    
        @AuraEnabled public List<GCP_Trade_Partner_DOH_Report__c> dohRecords;
        productFamily(){
            dohRecords = new List<GCP_Trade_Partner_DOH_Report__c>();
            
        }
        
    }
    
}