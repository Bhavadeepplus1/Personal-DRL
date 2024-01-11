trigger Phoenix_WacChangeLineItemTrigger on Phoenix_WAC_Change_Line_Item__c (before insert, after insert, before update, after update,before delete,after delete,after undelete) {
    List<Trigger_Validation__c> tv = Trigger_Validation__c.getall().values();
    boolean proceedOrNot = true;
    if(tv.size()>0){
        if(!tv[0].WacChangeLineItemTrigger__c)
            proceedOrNot = false;
    }
    if(proceedOrNot){
        String Bid_ID;   
        if (trigger.isAfter && trigger.isUpdate) {
            Set < Id > newIds = new Set < Id > ();
            for (Phoenix_WAC_Change_Line_Item__c item: trigger.new) {
                Bid_ID = item.Phoenix_WAC_Change__c;
                if (trigger.oldMap.get(item.Id).Phoenix_Final_Status__c != trigger.newMap.get(item.Id).Phoenix_Final_Status__c && trigger.newMap.get(item.Id).Phoenix_Final_Status__c == 'Not Approved') { //means status changed
                    newIds.add(item.Id);
                }
            }
            System.debug('newIds==>'+newIds.size());
            if (newIds.size() > 0) Phoenix_SubmitBidForApprovalCtrl.BidRejectionEmailNotificationToAll(newIds,Bid_ID); //Sending notification to all approvers
            
        }
    }
}