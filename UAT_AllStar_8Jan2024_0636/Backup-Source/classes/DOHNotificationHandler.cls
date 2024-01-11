public class DOHNotificationHandler extends TriggerHandler {
	private list < GCP_DOH_Trade_Partner_NDC__c > triggerNew;
    private list < GCP_DOH_Trade_Partner_NDC__c > triggerOld;
    private Map < Id, GCP_DOH_Trade_Partner_NDC__c > newMap;
    private Map < Id, GCP_DOH_Trade_Partner_NDC__c > oldMap;
    
    public DOHNotificationHandler() {
        this.newMap = (Map < Id, GCP_DOH_Trade_Partner_NDC__c > ) Trigger.newMap;
        this.oldMap = (Map < Id, GCP_DOH_Trade_Partner_NDC__c > ) Trigger.oldMap;
        this.triggerNew = (List < GCP_DOH_Trade_Partner_NDC__c > ) Trigger.new;
        this.triggerOld = (List < GCP_DOH_Trade_Partner_NDC__c > ) Trigger.old;
        //system.debug('triggerNew-->'+triggerNew);
    }
    public void afterInsertUpdate() {
		//system.debug('=== beforeInsertDOHTradePartnerHander--');
        Map<String, Map<String, List<GCP_DOH_Trade_Partner_NDC__c>>> mapOfLowInventory = new Map<String, Map<String, List<GCP_DOH_Trade_Partner_NDC__c>>>();
        Map<String, Map<String, List<GCP_DOH_Trade_Partner_NDC__c>>> mapOfHighInventory = new Map<String, Map<String, List<GCP_DOH_Trade_Partner_NDC__c>>>();
        Map<String, Map<String, List<GCP_DOH_Trade_Partner_NDC__c>>> mapOfHighValue = new Map<String, Map<String, List<GCP_DOH_Trade_Partner_NDC__c>>>();
        String recordId;
        string query = 'Select Id, Product__r.Name, Vision_GCP_W4_DOH__c, Account_Manager__r.Email,Value_W4__c, Account_Manager__c, vision_gcp_trade_partner_name__c, Product__r.Phoenix_Rx_SRx_OTC__c FROM GCP_DOH_Trade_Partner_NDC__c WHERE Id=:triggerNew ORDER By Vision_GCP_W4_DOH__c ASC';
        List < GCP_DOH_Trade_Partner_NDC__c > dohList= Database.query(query);
        recordId = dohList[0].Id;
        for(GCP_DOH_Trade_Partner_NDC__c doh : dohList){
            try{
                if(doh.Vision_GCP_W4_DOH__c <= 12){
                    Map<String, List<GCP_DOH_Trade_Partner_NDC__c>> innerMap = new Map<String, List<GCP_DOH_Trade_Partner_NDC__c>>();
                    //system.debug('mapOfLowInventory>>>'+mapOfLowInventory);
                    //system.debug('doh>>>'+doh);
                    if(mapOfLowInventory.containsKey(doh.vision_gcp_trade_partner_name__c)){
                        Map<String, List<GCP_DOH_Trade_Partner_NDC__c>> partnerRecord = mapOfLowInventory.get(doh.vision_gcp_trade_partner_name__c);
                        if(doh.Product__r.Phoenix_Rx_SRx_OTC__c == 'SRx' && partnerRecord.containsKey('SRx')){
                            List<GCP_DOH_Trade_Partner_NDC__c> SRxList = partnerRecord.get('SRx');
                            SRxList.add(doh);
                            partnerRecord.put('SRx', SRxList);
                        } else  if(doh.Product__r.Phoenix_Rx_SRx_OTC__c == 'SRx' && !partnerRecord.containsKey('SRx')){
                           
                            partnerRecord.put('SRx', new List<GCP_DOH_Trade_Partner_NDC__c>{doh});
                        }
                        
                        
                        
                        
                        
                        
                        else if(doh.Product__r.Phoenix_Rx_SRx_OTC__c == 'Rx'){
                            List<GCP_DOH_Trade_Partner_NDC__c> RxList= new List<GCP_DOH_Trade_Partner_NDC__c>();
                            if(partnerRecord.containskey('Rx')){
                               RxList= partnerRecord.get('Rx');
                            }
                              RxList.add(doh);
                            partnerRecord.put('Rx', RxList);
                        }
                        mapOfLowInventory.put(doh.vision_gcp_trade_partner_name__c, partnerRecord);
                    } else{
                        if(doh.Product__r.Phoenix_Rx_SRx_OTC__c == 'SRx'){
                            innerMap.put('SRx', new List<GCP_DOH_Trade_Partner_NDC__c> {doh});
                        } else if(doh.Product__r.Phoenix_Rx_SRx_OTC__c == 'Rx'){
                            innerMap.put('Rx', new List<GCP_DOH_Trade_Partner_NDC__c> {doh});
                        }
                        mapOfLowInventory.put(doh.vision_gcp_trade_partner_name__c, innerMap);
                    }   
                }
                else if(doh.Vision_GCP_W4_DOH__c >= 45){
                    Map<String, List<GCP_DOH_Trade_Partner_NDC__c>> innerMap = new Map<String, List<GCP_DOH_Trade_Partner_NDC__c>>();
                    if(mapOfHighInventory.containsKey(doh.vision_gcp_trade_partner_name__c)){
                        Map<String, List<GCP_DOH_Trade_Partner_NDC__c>> partnerRecord = mapOfHighInventory.get(doh.vision_gcp_trade_partner_name__c);
                        if(doh.Product__r.Phoenix_Rx_SRx_OTC__c == 'SRx'){
                            List<GCP_DOH_Trade_Partner_NDC__c> SRxList = new List<GCP_DOH_Trade_Partner_NDC__c>();
                            if(partnerRecord.containskey('SRx')){
                             SRxList   = partnerRecord.get('SRx');
                            }
                            SRxList.add(doh);
                            partnerRecord.put('SRx', SRxList);
                        } else if(doh.Product__r.Phoenix_Rx_SRx_OTC__c == 'Rx'){
                            
                            List<GCP_DOH_Trade_Partner_NDC__c> RxList = new   List<GCP_DOH_Trade_Partner_NDC__c>();
                            if(partnerRecord.containskey('Rx')){
                              RxList = partnerRecord.get('Rx');
                            }
                            RxList.add(doh);
                            partnerRecord.put('Rx', RxList);
                        }
                        mapOfHighInventory.put(doh.vision_gcp_trade_partner_name__c, partnerRecord);
                    } else{
                        if(doh.Product__r.Phoenix_Rx_SRx_OTC__c == 'SRx'){
                            innerMap.put('SRx', new List<GCP_DOH_Trade_Partner_NDC__c> {doh});
                        } else if(doh.Product__r.Phoenix_Rx_SRx_OTC__c == 'Rx'){
                            innerMap.put('Rx', new List<GCP_DOH_Trade_Partner_NDC__c> {doh});
                        }
                        mapOfHighInventory.put(doh.vision_gcp_trade_partner_name__c, innerMap);
                    }
                } 
                else if(doh.Value_W4__c >= 100000){
                 
                        //system.debug('>= 100000');
                        Map<String, List<GCP_DOH_Trade_Partner_NDC__c>> innerMap = new Map<String, List<GCP_DOH_Trade_Partner_NDC__c>>();
                        if(mapOfHighValue.containsKey(doh.vision_gcp_trade_partner_name__c)){
                            Map<String, List<GCP_DOH_Trade_Partner_NDC__c>> partnerRecord = mapOfHighValue.get(doh.vision_gcp_trade_partner_name__c);
                            if(doh.Product__r.Phoenix_Rx_SRx_OTC__c == 'SRx'){
                               List<GCP_DOH_Trade_Partner_NDC__c> SRxList = new List<GCP_DOH_Trade_Partner_NDC__c>();
                            if(partnerRecord.containskey('SRx')){
                             SRxList   = partnerRecord.get('SRx');
                            }
                                SRxList.add(doh);
                                partnerRecord.put('SRx', SRxList);
                            } else if(doh.Product__r.Phoenix_Rx_SRx_OTC__c == 'Rx'){
                                 List<GCP_DOH_Trade_Partner_NDC__c> RxList = new   List<GCP_DOH_Trade_Partner_NDC__c>();
                            if(partnerRecord.containskey('Rx')){
                                partnerRecord.get('Rx');
                            }
                                RxList.add(doh);
                                partnerRecord.put('Rx', RxList);
                            }
                            mapOfHighValue.put(doh.vision_gcp_trade_partner_name__c, partnerRecord);
                        } else{
                            if(doh.Product__r.Phoenix_Rx_SRx_OTC__c == 'SRx'){
                                innerMap.put('SRx', new List<GCP_DOH_Trade_Partner_NDC__c> {doh});
                            } else if(doh.Product__r.Phoenix_Rx_SRx_OTC__c == 'Rx'){
                                innerMap.put('Rx', new List<GCP_DOH_Trade_Partner_NDC__c> {doh});
                            }
                            mapOfHighValue.put(doh.vision_gcp_trade_partner_name__c, innerMap);
                        }   
                    
                }
            } Catch(Exception e) {
                String msg = e.getMessage().length() > 255 ? e.getMessage().substring(0, 254) : e.getMessage();
            Phoenix_Bright_Exceptions__c exp = new Phoenix_Bright_Exceptions__c(Phoenix_Class__c = 'DOHNotificationHandler', Phoenix_Error_Message__c = msg, Phoenix_Issue_Status__c = 'Pending', Phoenix_Method_Name__c = 'afterInsertUpdate', Phoenix_Occurrence_Time__c = System.now(), Phoenix_Stack_Trace__c = e.getStackTraceString(), Phoenix_Remarks__c ='doh Record id '+doh.id , Phoenix_Current_User__c = UserInfo.getName() + '(' + UserInfo.getUserId() + ')');
            insert exp;
               // //system.debug('Exception: '+e);
            }
        }
        if(mapOfLowInventory.keySet().size() > 0){
            String keyString = 'Low Inventory';
            DoHNotificationsCls.notifyUsers(mapOfLowInventory, recordId, keyString);    
        }
        if(mapOfHighInventory.keySet().size() > 0){
            String keyString = 'High Inventory';
            DoHNotificationsCls.notifyUsers(mapOfHighInventory, recordId, keyString);    
        }
        if(mapOfHighValue.keySet().size() > 0){
            String keyString = 'High Value';
            DoHNotificationsCls.notifyUsers(mapOfHighValue, recordId, keyString);    
        }
        DoHNotificationsCls.sendDataUpdateNotification('DoH_Report', 'DoH data has been updated.', 'DoH Data Update');
    }
    
}