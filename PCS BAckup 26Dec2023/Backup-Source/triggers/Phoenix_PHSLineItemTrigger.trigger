trigger Phoenix_PHSLineItemTrigger on Phoenix_PHS_Price_Change_Line__c (before insert, after insert, before update, after update,before delete,after delete,after undelete) {
    
    String phsPriceChangeId;
    
    if (trigger.isBefore && trigger.isUpdate) {
        
        Phoenix_PHS_Price_Change__c pHS = [SELECT Id,  Phoenix_Approval_Status__c FROM Phoenix_PHS_Price_Change__c WHERE Id =: Trigger.new[0].Phoenix_PHS_Price_Change__c];
        for (Phoenix_PHS_Price_Change_Line__c pHSItem: Trigger.new) {
            
            if(pHS.Phoenix_Approval_Status__c != 'Draft' &&  pHS.Phoenix_Approval_Status__c != 'Closed' && pHSItem.Phoenix_Final_Status__c != 'Not Approved')
            {
                pHSItem.Phoenix_PHS_Line_Item_Approval_Status__c = pHS.Phoenix_Approval_Status__c + ' Pending';
            }
            
            if(pHSItem.Phoenix_Finance_Approval__c == 'Not Approved' && pHSItem.Phoenix_Final_Status__c == 'Not Approved'){pHSItem.Phoenix_PHS_Line_Item_Approval_Status__c = 'Sr Director or VP Finance Rejected';
                                                                                                                          } 
            if(pHSItem.Phoenix_Vistex_Approval__c == 'Not Approved' && pHSItem.Phoenix_Final_Status__c == 'Not Approved'){pHSItem.Phoenix_PHS_Line_Item_Approval_Status__c = 'Vistex Rejected';
                                                                                                                         } 
            
            
        }
        
    }
    if (trigger.isAfter && trigger.isUpdate) {
        Set < Id > newIds = new Set < Id > ();
        for (Phoenix_PHS_Price_Change_Line__c item: trigger.new) {
            phsPriceChangeId = item.Phoenix_PHS_Price_Change__c;
            if (trigger.oldMap.get(item.Id).Phoenix_Final_Status__c != trigger.newMap.get(item.Id).Phoenix_Final_Status__c && trigger.newMap.get(item.Id).Phoenix_Final_Status__c == 'Not Approved') { //means status changed
                newIds.add(item.Id);
            }
        }
        if (newIds.size() > 0) Phoenix_SubmitBidForApprovalCtrl.BidRejectionEmailNotificationToAll(newIds,phsPriceChangeId); //Sending notification to all approvers
        
    }
    
}