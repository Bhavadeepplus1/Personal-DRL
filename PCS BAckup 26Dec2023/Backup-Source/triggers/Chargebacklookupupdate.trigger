trigger Chargebacklookupupdate on IDN_Charge_Back__c (before insert,before update) {
    if(trigger.isinsert || trigger.isbefore){
        map<string,Phoenix_Contract__c> conmap = new  map<string,Phoenix_Contract__c>();
        list<Phoenix_Contract__c>  contractlist = [select id, Phoenix_Contract_Number__c from Phoenix_Contract__c where Phoenix_Contract_Number__c!=null];
        map<String,Product2> prodMap =new Map<String,Product2>();
        for( Product2 prod : [select Id,name,ProductCode  From Product2 where ProductCode!=null]){
            prodMap.put(prod.ProductCode,prod);
            //ndc10prodMap.put(prod.Phoenix_NDC__c,prod);
        }
        for(Phoenix_Contract__c cont:contractlist){
            conmap.put(cont.Phoenix_Contract_Number__c,cont);
        }
        for(IDN_Charge_Back__c idn:trigger.new){
            if(idn.contact_id__c!=null){
                if(conmap.containskey(idn.contact_id__c)){
                    idn.Contract__c = conmap.get(idn.contact_id__c).id;
                }
            }
            if(idn.Material_Number__c!=null){
                if(prodMap.containskey(idn.Material_Number__c)){
                    idn.Product__c = prodMap.get(idn.Material_Number__c).id;
                }
            }
            
        }
    }
}