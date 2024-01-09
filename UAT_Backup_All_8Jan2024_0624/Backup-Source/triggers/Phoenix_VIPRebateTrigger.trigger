trigger Phoenix_VIPRebateTrigger on Phoenix_Bid_VIP_Rebate__c (before insert, before update) {
    
    Map<id,Account> customerMap = new Map<id,Account>();
    Set<id> customerIds = new Set<id>();
    
    for( Phoenix_Bid_VIP_Rebate__c vipRebate :Trigger.new)
    {
        customerIds.add(vipRebate.Phoenix_Customer__c); // error in this line
       if(vipRebate.Phoenix_Bid__c!=null && vipRebate.Phoenix_Bid__r.Phoenix_Proposed_VIP_Rebate__c != null){           vipRebate.Phoenix_Bid__r.Phoenix_Proposed_VIP_Rebate__c=vipRebate?.Id; 
       }
    }
    
    customerMap= new map<id,Account> ([select id,Name ,(select id,Name from Bid_VIP_Rebates__r) from account where id in: customerIds]);
    
    for ( Phoenix_Bid_VIP_Rebate__c c :trigger.new)
    {
        //c.Name= !Test.isRunningTest() ? customerMap.get(c.Phoenix_Customer__c).Name+'_'+c.Phoenix_Start_Date__c.format()+'_'+c.Phoenix_End_Date__c.format()+'' : '';
    }
    
}