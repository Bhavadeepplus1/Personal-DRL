trigger Phoenix_BidVIPRebateLinesTrigger on Phoenix_VIP_Rebate_Line__c (before insert, before update) {
    Map<id,Phoenix_Bid_VIP_Rebate__c> vipRebateMap = new Map<id,Phoenix_Bid_VIP_Rebate__c>();
    Set<id> vipRebateIds = new Set<id>();
    
    for( Phoenix_VIP_Rebate_Line__c vipRebateLine :Trigger.new)
    {
        vipRebateIds.add(vipRebateLine.Phoenix_VIP_Rebate__c); // error in this line
    }
    list<Phoenix_Bid_VIP_Rebate__c> vipList = [select id,Name,Phoenix_Tier__c,(select id,Name,Phoenix_VIP_Rebate__c from VIP_Rebate_Lines__r) from Phoenix_Bid_VIP_Rebate__c where id in: vipRebateIds];
    for(Phoenix_Bid_VIP_Rebate__c vipObj : vipList){
        vipRebateMap.put(vipObj.Id, vipObj);//= new map<id,Phoenix_Bid_VIP_Rebate__c> ([select id,Name,Phoenix_Tier__c,(select id,Name,Phoenix_VIP_Rebate__c from VIP_Rebate_Lines__r) from Phoenix_Bid_VIP_Rebate__c where id in: vipRebateIds]);
    }
    for ( Phoenix_VIP_Rebate_Line__c c :trigger.new)
    {
        if(vipRebateMap.containsKey(c.Phoenix_VIP_Rebate__c))
            c.Name=vipRebateMap.get(c.Phoenix_VIP_Rebate__c).Name+'_'+c.Phoenix_Tier__c;
    }
}