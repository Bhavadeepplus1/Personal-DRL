public class OTC_SPA_ApprovalController {
    
    @AuraEnabled
    public static String validateOTCSPAs(Id oppId){
        
        List<OTC_SPA__c> otcspaErrorList = new List<OTC_SPA__c>();
        
        System.debug('oppId : ' + oppId);
        if( String.isNotBlank(oppId)) {
            
            for( OTC_SPA__c otc : [ SELECT Id,Name, Product__c, Price_Intelligence__c, OPT__c 
                                   FROM OTC_SPA__c 
                                   WHERE OPT__c = :oppId
                                  ] ) {
                                      if (otc.Product__c == NULL || String.isBlank(otc.Price_Intelligence__c)) {
                                          otcspaErrorList.add(otc);    
                                      }    
                                  }
        }
        System.debug('otcspaErrorList : ' + otcspaErrorList);
        return JSON.serialize(otcspaErrorList);
    }
    
    @AuraEnabled
    public static String submitForApproval(Id oppId){
        
        Approval.ProcessSubmitRequest [] requestList = new Approval.ProcessSubmitRequest []{};
        Approval.ProcessSubmitRequest req1;
        Approval.ProcessResult[] result;
        Set<Id> idSet = new Set<Id>();
        
        for( OTC_SPA__c otc : [ SELECT Id FROM OTC_SPA__c WHERE OPT__c = :oppId ]) {
            idSet.add(otc.id);
        }
        
        for (Id otcId : idSet) {
            
            req1 = new Approval.ProcessSubmitRequest();
            req1.setComments('Submitting request for approval');
            req1.setObjectId(otcId);
            //req1.setProcessDefinitionNameOrId('OTC_SPA_Approval_Process'); Commented by Inba
            req1.setProcessDefinitionNameOrId('OTC_SPA_Approval_ProcessV2');
            requestList.add(req1);
        }
        System.debug('requestList: ' + requestList);
        if( requestList.size() > 0 ) {
            result = Approval.process(requestList);
            System.debug('result : ' + result);    
        }  
        return JSON.serialize(result);
    }
}