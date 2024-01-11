trigger Phoenix_ProductTrigger on Product2 (before insert, before update,after insert,after update) {
    if((trigger.isUpdate && trigger.isBefore)||(trigger.isInsert && trigger.isBefore)){
    for (Product2 obj: trigger.new){
        //  String ndc= obj.Phoenix_NDC_11__c;
        //if (obj.Phoenix_Is_New_Product__c) obj.Phoenix_Lowest_Price_SKU__c = obj.Phoenix_New_Product_Lowest_Price__c;
        String ndc= obj.Phoenix_NDC__c;
        //Manikanta Olete -21-12-2023 - Added New NDC- 11 series - 75907
        if((ndc!=null) && (ndc.startsWith('55111') || ndc.startsWith('43598') || ndc.startsWith('51862') || ndc.startsWith('68308') || ndc.startsWith('30142') || ndc.startsWith('70000') || ndc.startsWith('51316') || ndc.startsWith('11822') || ndc.startsWith('70677') || ndc.startsWith('79903') || ndc.startsWith('60429') || ndc.startsWith('75907'))){
            obj.Phoenix_NDC_11__c= ndc.substring(0, 5)+'0'+ndc.substring(5, 10);
        }
        else{
            obj.Phoenix_NDC_11__c= null;   
        }
    }
    }
    if(trigger.isUpdate && trigger.isBefore){
         for (Product2 obj: trigger.new){
             Product2 oldProduct = trigger.oldMap.get(obj.id);
        //  String ndc= obj.Phoenix_NDC_11__c;
        if (obj.Phoenix_Is_New_Product__c) obj.Phoenix_Lowest_Price_SKU__c = obj.Phoenix_New_Product_Lowest_Price__c;
        /*For New CIP TPT Cost*/
        if(obj.Phoenix_CIP_Throughput_Cost__c != null) {
            obj.Phoenix_Throughput_cost__c =  obj.Phoenix_CIP_Throughput_Cost__c ;

            if(obj.Phoenix_CIP_Throughput_Cost__c != oldProduct.Phoenix_CIP_Throughput_Cost__c){
                //obj.Phoenix_Throughput_cost__c =  obj.Phoenix_CIP_Throughput_Cost__c ;
                obj.Phoenix_Old_Throughput_Cost__c =  oldProduct.Phoenix_Throughput_cost__c ;
            
            }
           /* else{
               obj.Phoenix_Old_Throughput_Cost__c =  oldProduct.Phoenix_Throughput_cost__c;
            }*/
        }
         }
        
        /*End For New CIP TPT Cost*/
        
    }
    
    Phoenix_ProductTriggerHelper productTriggerHandler =new Phoenix_ProductTriggerHelper(Trigger.new);
   
    if (Trigger.isAfter) {
        if (Trigger.isInsert || Trigger.isUpdate) {
            productTriggerHandler.updateProdFamilyStatus();
        } 
        
    }
    
}