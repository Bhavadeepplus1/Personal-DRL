trigger activeProductFieldUpdate on Phoenix_Bid_Line_Item__c ( after insert,  after update) {
     System.debug('after update test');
     Phoenix_Bid__c bidRec; 
    if (trigger.isInsert || trigger.isUpdate) {
            bidRec = [SELECT Id, Phoenix_is_OTC_Bid__c,Phoenix_Customer_Type__c, Phoenix_Customer__r.Phoenix_Rebates__c,Phoenix_Customer__r.Phoenix_Cash_Discount__c ,Phoenix_Customer__r.Phoenix_Fee__c,Phoenix_Customer__r.Phoenix_CM_Fees__c,Phoenix_Proposed_Value_Admin_Fee__c, Phoenix_Current_CD__c,Phoenix_Approval_Status__c, Phoenix_Bid_Proposed_Position__c, Phoenix_Custom_type__c, Phoenix_Current_Value_Est_VIP__c, Phoenix_Proposed_Value_Est_VIP__c, Phoenix_Initial_Order_Discount_of_Days__c, Phoenix_Proposed_Initial_Order_Discount__c, Phoenix_Proposed_Cash_Terms__c, Phoenix_Bid_Type__c FROM Phoenix_Bid__c WHERE Id =: Trigger.new[0].Phoenix_Bid__c];
         //Added by satya//
  /*     List<Phoenix_Bid_Line_Item__c> blineItems = [select id,Phoenix_Product__r.Test__c from Phoenix_Bid_Line_Item__c where Phoenix_Bid__C =: bidRec.Id];
           System.debug('satya is testing');
        System.debug('blineItems size==>'+blineItems.size());
            if(bidRec.Phoenix_Bid_Type__c == 'Product Discontinuation Process'){
                 System.debug('inside Product Discontinuation Process');
                for (Phoenix_Bid_Line_Item__c blItem: blineItems) {
                        blItem.Phoenix_Product__r.Test__c = 'Satya';
                    System.debug('blItem Phoenix_Product__r test=='+blItem.Phoenix_Product__r.Test__c);
                   if(blItem.Phoenix_Contract_Approval__c == 'Sent to Customer'){
                        blItem.Phoenix_Product__r.IsActive = false;
                        
                    }
                }
            }
        if(blineItems.size()>0){
            update blineItems;
        }*/
            //end by satya// 
    }
}