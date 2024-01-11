trigger Phoenix_ChecklistTrigger on Checklist__c (after insert, after delete, after update) {
    if(Trigger.isInsert){
        try {
            for (Checklist__c co : Trigger.new){
                Phoenix_Bid__c po = [SELECT Id, Phoenix_Is_Checklist_Exist__c FROM Phoenix_Bid__c WHERE Id = :co.Bid__c LIMIT 1];
                
                //  List<Checklist__c> l_co = [SELECT Id FROM Checklist__c WHERE Bid__c = :po.Id];
                //  for(Checklist__c am_co : l_co) {
                //  amount += am_co.Amount__c;  
                // }
                po.Phoenix_Is_Checklist_Exist__c = true;
                
                update po;
            }
        } catch (Exception e) {
            System.debug(e);
        }
    }
    
    if(Trigger.isAfter) {
        if(Trigger.isUpdate){
            try {
                for (Checklist__c co : Trigger.old){
                    Phoenix_Bid__c po = [SELECT Id, Phoenix_Is_Checklist_Exist__c FROM Phoenix_Bid__c WHERE Id = :co.Bid__c LIMIT 1];
                    
                    // List<Checklist__c> l_co = [SELECT Id FROM Checklist__c WHERE Bid__c = :po.Id];
                    // for(Checklist__c am_co : l_co) {
                    //  amount += am_co.Amount__c;  
                    //  }
                    po.Phoenix_Is_Checklist_Exist__c = true;
                    
                    update po;
                }
            } catch (Exception e) {
                System.debug(e);
            }
        }
        
        if(Trigger.isDelete){
            try {
                for (Checklist__c co : Trigger.old){
                    Phoenix_Bid__c po = [SELECT Id,Phoenix_Is_Checklist_Exist__c  FROM Phoenix_Bid__c WHERE Id = :co.Bid__c LIMIT 1];
                    
                    //List<Checklist__c> l_co = [SELECT Id FROM Checklist__c WHERE Bid__c = :po.Id];
                    // for(Checklist__c am_co : l_co) {
                    //  amount += am_co.Amount__c;  
                    // }
                    //po.Sum_Field__c = amount;
                    po.Phoenix_Is_Checklist_Exist__c = false;
                    update po;
                }
            } catch (Exception e) {
                System.debug(e);
            }
        }
    }
}