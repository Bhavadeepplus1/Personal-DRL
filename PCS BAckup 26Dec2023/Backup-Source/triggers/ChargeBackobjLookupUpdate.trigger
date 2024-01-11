trigger ChargeBackobjLookupUpdate on IDN_Charge_Back__c (before insert,before update) {
  
    if(trigger.isinsert || trigger.isupdate){
     map<string,product2> prodmap = new map<string,product2>();
        for(product2 p:[select id,productcode from product2 where productcode!=null]){
            prodmap.put(p.productcode,p);
        }
       Map<string,Account> accmap= new Map<string,Account>();
        for(account a:[select id ,accountnumber from account where accountnumber!=null]){
            accmap.put(a.accountnumber,a);
        }
        
      map<string,Phoenix_Contract__c> contMap = new map<string,Phoenix_Contract__c>();
    for(Phoenix_Contract__c ct:[select id,Phoenix_Contract_Number__c from Phoenix_Contract__c where Phoenix_Contract_Number__c!=null]){
        contMap.put(ct.Phoenix_Contract_Number__c,ct);
    }
        for(IDN_Charge_Back__c cb : Trigger.new){
            
            if(cb.Material_Number__c != null && prodmap.containskey(cb.Material_Number__c)){
                cb.Product__c = prodmap.get(cb.Material_Number__c).id;
            }
             if(cb.contact_id__c != null && contMap.containskey(cb.contact_id__c)){
                cb.Contract__c = contMap.get(cb.contact_id__c).id;
            }
            if(cb.Sold_to_Number__c != null && accmap.containskey(cb.Sold_to_Number__c)){
                cb.Account__c = accmap.get(cb.Sold_to_Number__c).id;
            }

            
        }
    }
    
   
    
}