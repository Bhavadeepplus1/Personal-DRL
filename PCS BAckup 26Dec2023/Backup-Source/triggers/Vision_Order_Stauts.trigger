trigger Vision_Order_Stauts on Vision_GCP_SFDC_Order_Status__c (before insert,before update) {
    
    
    if(Trigger.isInsert || Trigger.isUpdate ){
        List<Vision_GCP_SFDC_Order_Status__c> listOfOrders = new List<Vision_GCP_SFDC_Order_Status__c>();
          List<String> strTimes = new  List<String>();
         Date sapCreatedDt;
        Date GCPUpdateDt;
         map<String,Product2> skuprodMap =new Map<String,Product2>();
            for( Product2 prod : [select Id,name,ProductCode From Product2 where ProductCode != null]){
                skuprodMap.put(prod.ProductCode,prod);
            }
        for(Vision_GCP_SFDC_Order_Status__c ord : trigger.new){
            if(ord.Vision_SKU_Code__c!=null){
                ord.Vision_Product__c=skuprodMap.containskey(ord.Vision_SKU_Code__c)?skuprodMap.get(ord.Vision_SKU_Code__c).id:null;
            }
            //Vision_SAP_Created_DateTime__c 
            if(ord.PRISM_SAP_Created_Date__c!=null){
            sapCreatedDt= ord.PRISM_SAP_Created_Date__c;
            }
            //system.debug('sap createddate...'+ord.PRISM_SAP_Created_Date__c);
            //system.debug('sap createdtime...'+ord.PRISM_SAP_Created_Time__c);
            if(ord.PRISM_SAP_Created_Time__c!=null){
             strTimes = ord.PRISM_SAP_Created_Time__c.substringBefore('.').split(':'); 
            system.debug('strTimes...'+strTimes);
            }
            // This is IST time coming from PRISM(GCP) 
            
            DateTime  dtTimegmt = DateTime.newInstanceGMT(sapCreatedDt.year(), sapCreatedDt.month(), sapCreatedDt.day(), Integer.valueOf(strTimes[0]), Integer.valueOf(strTimes[1]), Integer.valueOf(strTimes[2])); 
            system.debug('dttimegmt..'+dtTimegmt);
            
          //  DateTime dt1Gmt = Phoenix_Util.getUserTime(dtTimegmt,'GMT');
            ord.Vision_SAP_Created_DateTime__c = Phoenix_Util.convertTime(dtTimegmt,'Asia/Kolkata', 'America/New_York');
            system.debug('sap created datetime'+ord.Vision_SAP_Created_DateTime__c);
            //GCP Update DateTime
            if(ord.Vision_GCP_Update_Date__c!=null){
            GCPUpdateDt = ord.Vision_GCP_Update_Date__c;
            }
            system.debug('Vision_GCP_Update_Date__c'+ord.Vision_GCP_Update_Date__c);
            List<String> strTimes2 = new  List<String>();
            if(ord.Vision_Created_Date__c!=null){
                string dt=string.valueofGMT(ord.Vision_Created_Date__c);
                system.debug('Vision_GCP_Update_Time__c'+ord.Vision_GCP_Update_Time__c);
                strTimes2 = dt.substringafter(' ').split(':'); 
                system.debug('strTimes2'+strTimes2);
            }  
            DateTime  dtTimegmt2;
            
            if(strTimes2.size() > 0){
                
                dtTimegmt2 = DateTime.newInstanceGMT(GCPUpdateDt.year(), GCPUpdateDt.month(), GCPUpdateDt.day(), Integer.valueOf(strTimes2[0]), Integer.valueOf(strTimes2[1]), Integer.valueOf(strTimes2[2])); 
                //system.debug('testdt...'+dtTimegmt2 );
                system.debug('dtTimegmt2'+dtTimegmt2);
                system.debug('strtimes2'+strTimes2);
                
                DateTime dt2Gmt = Phoenix_Util.getUserTime(dtTimegmt2,'GMT');
                
                ord.Vision_GCP_Update_DateTime__c = Phoenix_Util.getUserTime(dt2Gmt,'America/New_York');
                
                listOfOrders.add(ord);
            }
        }
        
    }
}