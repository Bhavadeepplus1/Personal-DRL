public class Vision_AlertCtrl {
    public class alertWrapper{
        //Add your items here to return updated "Is Alerted" value back to UI
        @auraEnabled
        public Phoenix_GCP_Opportunity_Tracker__c gcpObj;
        @auraEnabled
        public GCP_SFDC_100pct_Analysis_SKU__c ndcObj;
        @auraEnabled
        public boolean isError = false;
        @auraEnabled
        public string errorMessage = '';
    }
    
    @AuraEnabled
    public static Vision_Alert__c fetchVisionAlertList(String recId, String recType, String accId){
        system.debug('rectype --> '+recType);
        //Add your own recType from Lightning component and add your own Query below to pull existing alerts.
        String query = 'SELECT '+Phoenix_Util.getsObjectFieds('Vision_Alert__c')+' FROM Vision_Alert__c';
        if(recType=='gcpItem')
            query += ' WHERE GCP_Opportunity_Tracker__c =: recId';
        else if(recType == 'ndcItem')
            query += ' WHERE GCP_SFDC_100pct_Analysis_SKU__c =: recId';
        else if(recType == 'accCalendar'){
            string queryItem = 'Account Calendar';
            query += ' WHERE Vision_Alert_Type__c =: queryItem AND Account__c =: accId';
        }
        list<Vision_Alert__c> visionAlertList = Database.query(query);
        system.debug('visionAlertList.size() ---> '+visionAlertList.size());
        if(visionAlertList.size() > 0)
            return visionAlertList[0];
        else{ 
            Vision_Alert__c alertObj = new Vision_Alert__c();
            return alertObj;
        }
    }
   @auraEnabled
    public static alertWrapper saveAlert(Vision_Alert__c alertObj, Account accObj, String recId, String itemType)
    {
        alertWrapper wrapObj = new alertWrapper();
        if(alertObj.id == null){
            if(itemType == 'accCalendar')
                alertObj.Name = 'Account Calendar - '+accObj.Name;
            else
                alertObj.Name = 'CxAnalysis - '+accObj.Name;
            if(itemType == 'gcpItem')
                alertObj.GCP_Opportunity_Tracker__c = recId;
            else if(itemType == 'ndcItem')
                alertObj.GCP_SFDC_100pct_Analysis_SKU__c = recId;
        }
        if(itemType == 'accCalendar')
            alertObj.Vision_Alert_Type__c = 'Account Calendar';
        else
            alertObj.Vision_Alert_Type__c = 'GCP 100% Customer Analysis';
        alertObj.Account__c = accObj.Id; 
        UPSERT alertObj; 
        //update your corresponding record if it's alert is activated or now and return the record to show in UI.
        if(itemType == 'gcpItem'){
            String query = 'SELECT '+Phoenix_Util.getsObjectFieds('Phoenix_GCP_Opportunity_Tracker__c')+' FROM Phoenix_GCP_Opportunity_Tracker__c WHERE Id =: recId';
            Phoenix_GCP_Opportunity_Tracker__c gcpObj = Database.query(query);
            gcpObj.Vision_isAlerted__c = alertObj.Vision_isActiveAlert__c;
            update gcpObj;
            wrapObj.gcpObj = gcpObj;
            return wrapObj;
        }
        else if(itemType == 'ndcItem'){
            String query = 'SELECT Vision_Product__r.Id,Vision_Product__r.Name, Vision_Product__r.Phoenix_NDC_11__c, '+Phoenix_Util.getsObjectFieds('GCP_SFDC_100pct_Analysis_SKU__c')+' FROM GCP_SFDC_100pct_Analysis_SKU__c WHERE Id =: recId';
            GCP_SFDC_100pct_Analysis_SKU__c ndcObj = Database.query(query);
            ndcObj.Vision_isAlerted__c = alertObj.Vision_isActiveAlert__c;
            update ndcObj;
            wrapObj.ndcObj = ndcObj;
            return wrapObj;
        } 
        else{
            wrapObj.isError =  false;
            wrapObj.errorMessage = 'Saved Successfully!';
            return wrapObj;
        }
    }
  
}