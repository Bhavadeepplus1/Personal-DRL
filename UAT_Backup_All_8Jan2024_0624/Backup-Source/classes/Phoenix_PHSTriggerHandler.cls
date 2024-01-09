public class Phoenix_PHSTriggerHandler extends TriggerHandler {
      private list < Phoenix_PHS_Price_Change__c > triggerNew;
    private list < Phoenix_PHS_Price_Change__c > triggerOld;
    private Map < Id, Phoenix_PHS_Price_Change__c > newMap;
    private Map < Id, Phoenix_PHS_Price_Change__c > oldMap;
      public Phoenix_PHSTriggerHandler() {
        this.newMap = (Map < Id, Phoenix_PHS_Price_Change__c > ) Trigger.newMap;
        this.oldMap = (Map < Id, Phoenix_PHS_Price_Change__c > ) Trigger.oldMap;
        this.triggerNew = (List < Phoenix_PHS_Price_Change__c > ) Trigger.new;
        this.triggerOld = (List < Phoenix_PHS_Price_Change__c > ) Trigger.old;
          
          
    }
    public override void beforeInsert() {}
    public override void beforeUpdate() {}
    public override void afterUpdate() {
         List < Id > pHSChangeIds = new List < Id > ();

        for (Phoenix_PHS_Price_Change__c pHSChange: triggerNew) {
            if (oldMap.get(pHSChange.Id).Phoenix_Approval_Status__c != newMap.get(pHSChange.Id).Phoenix_Approval_Status__c && newMap.get(pHSChange.Id).Phoenix_Approval_Status__c.contains('Closed')) {
                pHSChangeIds.add(pHSChange.Id);
            }
        }
         if (pHSChangeIds.size() > 0) Phoenix_SubmitBidForApprovalCtrl.BidClosureNotification(pHSChangeIds);
    
    }
    public override void beforeDelete(){
        // triggerOld[0].addError('You can\'t delete the PHS Price Change');
         List < Id > ndcChangeIds = new List < Id > ();
        for (Phoenix_PHS_Price_Change__c ndcChange: triggerOld) {
            if (oldMap.get(ndcChange.Id).Phoenix_Approval_Status__c == 'Draft')
                ndcChangeIds.add(ndcChange.Id);
            else 
                ndcChange.addError('You can\'t delete this PHS Price Change, as it is already submitted for approval.');

        }
        if (ndcChangeIds.size() > 0)Phoenix_SubmitBidForApprovalCtrl.deleteBidChildren(ndcChangeIds);
        system.debug('deleting children');
    }


}