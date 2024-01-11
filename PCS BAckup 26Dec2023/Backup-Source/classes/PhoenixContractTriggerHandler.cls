public class PhoenixContractTriggerHandler extends TriggerHandler{
    private list<Phoenix_Contract__c> triggerNew;
    private list<Phoenix_Contract__c> triggerOld;
    private Map<Id, Phoenix_Contract__c> newMap;
    private Map<Id, Phoenix_Contract__c> oldMap;
    
    public PhoenixContractTriggerHandler(){
        this.newMap = (Map<Id, Phoenix_Contract__c>)Trigger.newMap;
        this.oldMap = (Map<Id, Phoenix_Contract__c>)Trigger.oldMap;
        this.triggerNew = (List<Phoenix_Contract__c>)Trigger.new;
        this.triggerOld = (List<Phoenix_Contract__c>)Trigger.old;
        
    }
    public override void beforeInsert(){
        addNameContracts();
    }
    
    public override void beforeUpdate(){
        addNameContracts();
    }
    
    public void addNameContracts(){
        Set<String> accIds = new Set<String>();
        for(Phoenix_Contract__c contract : triggerNew){
            if(String.isNotBlank(contract.Phoenix_Customer__c)) accIds.add(contract.Phoenix_Customer__c);
        }
        
        Map<Id,Account> accMap = new Map<Id,Account>([Select Id,Name,AccountNumber From Account Where Id IN:accIds]);
        
        for(Phoenix_Contract__c contract : triggerNew){
            if(contract.Phoenix_Customer__c != null){
                Account acc = accMap.get(contract.Phoenix_Customer__c);
                if(contract.Phoenix_Contract_Internal_Description__c!=null){
                    contract.Name =contract.Phoenix_Contract_Number__c+'-'+contract.Phoenix_Contract_Internal_Description__c.replaceAll('#','-');
                }
                else{
                    contract.Name =contract.Phoenix_Contract_Number__c;
                    
                }
            }   
        }
    }
    
    public override void afterUpdate(){
        Map <String ,List<Phoenix_NPR_Data__c> > nprDataMap = new Map <String ,List<Phoenix_NPR_Data__c> >();
        Map <String ,List<Phoenix_NPR_Data__c>> existingNprDataMap = new Map <String ,List<Phoenix_NPR_Data__c>>();
        Set<String> contractIds = new Set<String>();
        for(Phoenix_Contract__c contract : triggerNew)contractIds.add(contract.Id);
        List<Phoenix_NPR_Data__c> nprList = new List<Phoenix_NPR_Data__c>();
        if(contractIds != null){
            nprList = [SELECT Id, Phoenix_Contract__c, Phoenix_Account__r.Name FROM Phoenix_NPR_Data__c WHERE Phoenix_Contract__c IN: contractIds LIMIT 20000];
        }
        if(nprList != null && existingNprDataMap != null){
            for(Phoenix_NPR_Data__c npr : nprList){
                if(existingNprDataMap.containsKey(npr.Phoenix_Contract__c)){
                    List<Phoenix_NPR_Data__c> tempList = existingNprDataMap.get(npr.Phoenix_Contract__c);
                    tempList.add(npr);
                    existingNprDataMap.put(npr.Phoenix_Contract__c,tempList);
                }else{
                    existingNprDataMap.put(npr.Phoenix_Contract__c,new List<Phoenix_NPR_Data__c>{npr});
                }
            }
        }
        for(Phoenix_Contract__c contract : triggerNew){
            Phoenix_Contract__c oldContract = oldMap.get(contract.Id);
            if(contract.Phoenix_Customer__c != oldContract.Phoenix_Customer__c ){
                
                nprDataMap.put(contract.Phoenix_Customer__c , existingNprDataMap.get(contract.Id));
                
            }
            
        }
        Map<String,Phoenix_NPR_Data__c> massUpdateNPRData = new Map<String,Phoenix_NPR_Data__c>(); // [SELECT Id, Phoenix_Contract__c, Phoenix_Account__r.Name FROM Phoenix_NPR_Data__c WHERE Phoenix_Contract__c =: nprDataMap.values() LIMIT 1000];
        if(nprDataMap != null && nprDataMap.size()>0 && nprDataMap.keySet() != null){
            for(String  custId : nprDataMap.keySet()){
                if(nprDataMap.get(custId) != null){
                    for(Phoenix_NPR_Data__c npr : nprDataMap.get(custId)){
                        npr.Phoenix_Account__c = custId;
                        massUpdateNPRData.put(npr.Id,npr);
                    }
                }
            }
        }
        if(massUpdateNPRData.size() > 0)
            update massUpdateNPRData.values();
        
        /*
*  for(Phoenix_NPR_Data__c nprData : massUpdateNPRData ){
String customer = nprDataMap.get(nprData.Phoenix_Contract__c);
nprData.Phoenix_Account__c = customer;
}
* 
* 
* for(String customer : nprDataMap.keySet() ){
for(Phoenix_NPR_Data__c nprData : nprDataMap.get(customer)){
nprData.Phoenix_Account__c = customer;
massUpdateNPRData.add(nprData);
}
}*/
        
        /* List<Phoenix_NPR_Data__c> copyofmassUpdateNPRData = [SELECT ID ,Phoenix_Account__r.Name FROM Phoenix_NPR_Data__c  WHERE ID =: massUpdateNPRData];
for(Phoenix_NPR_Data__c nprData : copyofmassUpdateNPRData){
//  nprData.Phoenix_NPR_Customer_Name__c = nprData.Phoenix_Account__r.Name;
}
update copyofmassUpdateNPRData;*/
        
    }
    
}