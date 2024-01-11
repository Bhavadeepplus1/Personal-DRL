trigger PhoenixNDCChangeLineItemTrigger on Phoenix_NDC_Change_Line_Item__c (before insert, after insert, before update, after update,before delete,after delete,after undelete) {

String ndcChangeProductId;
if (trigger.isBefore && trigger.isUpdate) {
 
             Phoenix_NDC_Change__c ndc = [SELECT Id,  Phoenix_Approval_Status__c FROM Phoenix_NDC_Change__c WHERE Id =: Trigger.new[0].Phoenix_NDC_Change__c];
 for (Phoenix_NDC_Change_Line_Item__c ndcItem: Trigger.new) {
 
 if(ndc.Phoenix_Approval_Status__c != 'Draft' &&  ndc.Phoenix_Approval_Status__c != 'Closed' && ndcItem.Phoenix_Final_Status__c != 'Not Approved'){ndcItem.Phoenix_NDC_Line_Item_Approval_Status__c = ndc.Phoenix_Approval_Status__c + ' Pending';
                }
                if(ndcItem.Phoenix_SCM_Approval_Y_N__c == 'Not Approved' && ndcItem.Phoenix_Final_Status__c == 'Not Approved'){ndcItem.Phoenix_NDC_Line_Item_Approval_Status__c = 'SCM Rejected';
                }
               
                if(ndcItem.Phoenix_Contracts_Approval__c == 'Not Approved' && ndcItem.Phoenix_Final_Status__c == 'Not Approved'){ndcItem.Phoenix_NDC_Line_Item_Approval_Status__c = 'Contract Rejected';
                } 
                if(ndcItem.Phoenix_Finance_Approval__c == 'Not Approved' && ndcItem.Phoenix_Final_Status__c == 'Not Approved'){ndcItem.Phoenix_NDC_Line_Item_Approval_Status__c = 'Finance Rejected';
                } 
                if(ndcItem.Phoenix_Vistex_Approval__c == 'Not Approved' && ndcItem.Phoenix_Final_Status__c == 'Not Approved'){ndcItem.Phoenix_NDC_Line_Item_Approval_Status__c = 'Vistex Rejected';
                } 
                if(ndcItem.Pheonix_Customer_Approval__c == 'Not Approved' && ndcItem.Phoenix_Final_Status__c == 'Not Approved'){ndcItem.Phoenix_NDC_Line_Item_Approval_Status__c = 'Customer Rejected';
                }
               
                
                }

}
        if (trigger.isAfter && trigger.isUpdate) {
        Set < Id > newIds = new Set < Id > ();
        for (Phoenix_NDC_Change_Line_Item__c item: trigger.new) {
            ndcChangeProductId = item.Phoenix_NDC_Change_Product__c;
            if (trigger.oldMap.get(item.Id).Phoenix_Final_Status__c != trigger.newMap.get(item.Id).Phoenix_Final_Status__c && trigger.newMap.get(item.Id).Phoenix_Final_Status__c == 'Not Approved') { //means status changed
                newIds.add(item.Id);
            }
        }
        if (newIds.size() > 0) Phoenix_SubmitBidForApprovalCtrl.BidRejectionEmailNotificationToAll(newIds,ndcChangeProductId); //Sending notification to all approvers
        
    }

}