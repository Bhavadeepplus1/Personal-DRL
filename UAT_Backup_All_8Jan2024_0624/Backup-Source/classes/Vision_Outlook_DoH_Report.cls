public class Vision_Outlook_DoH_Report {
    @auraEnabled
    public static MainWrapper getAccountGroups(){
        MainWrapper mainwrap = new MainWrapper();
        List<AggregateResult> AggregateResultList =[SELECT vision_gcp_trade_partner_name__c FROM GCP_DOH_Trade_Partner_NDC__c GROUP BY vision_gcp_trade_partner_name__c ];
        system.debug('total records-->'+AggregateResultList.size());
        set<string> accgrpsset = new set<string>();
        for(AggregateResult aggr : AggregateResultList){
            accgrpsset.add((String) aggr.get('vision_gcp_trade_partner_name__c'));
        }
        List<string> accgrpList = new List<string>();
        // String header = 'Select Customer';
        // accgrpList.add(header);
        accgrpList.addAll(accgrpsset);
        
        string customer = accgrpList[0];
        List<String> productType = new List<String>();
       
        // doh_report_dates_info__c dohRepinfo = doh_report_dates_info__c.getInstance('Data1');
        /// if(dohRepinfo != null)
        //  mainwrap.visionUpdateDate = dohRepinfo.Vision_Update_Date__c;
        //  mainwrap.dohRecords = listOfGCPShortRecords[0];
        // mainwrap.noOfRecords = getDoHData(customer,productType).noOfRecords;
       mainwrap = getDoHRecords(customer);
         mainwrap.accgrpList=accgrpList;
        system.debug(' mainwrap.dohSummary-----'+accgrpList);
        return mainwrap;
    }
    @auraEnabled
    public static MainWrapper getDoHRecords(String customerName){
        MainWrapper mainwrap = new MainWrapper();
        String queryLowInv = '';
        String queryHighInv = '';
        String queryHighValue = '';
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
        queryLowInv = 'select '+strFields+' from ' + SobjectApiName + ' WHERE vision_gcp_trade_partner_name__c =: customerName and Vision_GCP_W8_DOH__c <=12 ORDER By Vision_GCP_W8_DOH__c ASC LIMIT 5';   
        queryHighInv = 'select '+strFields+' from ' + SobjectApiName + ' WHERE vision_gcp_trade_partner_name__c =: customerName and Vision_GCP_W8_DOH__c >=45 ORDER By Vision_GCP_W8_DOH__c Desc LIMIT 5';   
        queryHighValue = 'select '+strFields+' from ' + SobjectApiName + ' WHERE vision_gcp_trade_partner_name__c =: customerName and Value_W8__c >=100000 ORDER By Value_W8__c Desc LIMIT 5';   
        List < GCP_DOH_Trade_Partner_NDC__c > listOfLowInv = Database.query(queryLowInv);
        List < GCP_DOH_Trade_Partner_NDC__c > listOfHighInv = Database.query(queryHighInv);
        List < GCP_DOH_Trade_Partner_NDC__c > listOfHighValue = Database.query(queryHighValue);
        mainwrap.lowInvRecords = listOfLowInv;
        mainwrap.highInvRecords = listOfHighInv;
        mainwrap.highValueRecords = listOfHighValue;
        return mainwrap;
    }
    public class MainWrapper{
        @AuraEnabled public List<String> accgrpList;
        @AuraEnabled public List<GCP_DOH_Trade_Partner_NDC__c> lowInvRecords;
        @AuraEnabled public List<GCP_DOH_Trade_Partner_NDC__c> highInvRecords;
        @AuraEnabled public List<GCP_DOH_Trade_Partner_NDC__c> highValueRecords;
        MainWrapper(){
            lowInvRecords = new List<GCP_DOH_Trade_Partner_NDC__c>();
            highInvRecords = new List<GCP_DOH_Trade_Partner_NDC__c>();
            highValueRecords = new List<GCP_DOH_Trade_Partner_NDC__c>();
        }
    }
}