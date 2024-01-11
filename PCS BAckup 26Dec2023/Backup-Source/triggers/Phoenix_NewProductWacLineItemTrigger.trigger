trigger Phoenix_NewProductWacLineItemTrigger on Phoenix_NewProduct_WAC_Pricing_LineItems__c (before insert, after insert, before update, after update,before delete,after delete,after undelete) {
       String newProductWACPricingId; //Added by BV
    if (trigger.isAfter && trigger.isUpdate) {
        Set < Id > newIds = new Set < Id > ();
        for (Phoenix_NewProduct_WAC_Pricing_LineItems__c item: trigger.new) {
            newProductWACPricingId = item.Phoenix_New_Product_WAC_Pricing__c; //Added by BV
            if (trigger.oldMap.get(item.Id).Phoenix_Final_Status__c != trigger.newMap.get(item.Id).Phoenix_Final_Status__c && trigger.newMap.get(item.Id).Phoenix_Final_Status__c == 'Not Approved') { //means status changed
                newIds.add(item.Id);
            }
        }
        if (newIds.size() > 0) Phoenix_SubmitBidForApprovalCtrl.BidRejectionEmailNotificationToAll(newIds,newProductWACPricingId); //Sending notification to all approvers //Added by BV
        
    }
    
}