public class Phoenix_NDCChangeTriggerHandler extends TriggerHandler {
      private list < Phoenix_NDC_Change__c > triggerNew;
    private list < Phoenix_NDC_Change__c > triggerOld;
    private Map < Id, Phoenix_NDC_Change__c > newMap;
    private Map < Id, Phoenix_NDC_Change__c > oldMap;
      public Phoenix_NDCChangeTriggerHandler() {
        this.newMap = (Map < Id, Phoenix_NDC_Change__c > ) Trigger.newMap;
        this.oldMap = (Map < Id, Phoenix_NDC_Change__c > ) Trigger.oldMap;
        this.triggerNew = (List < Phoenix_NDC_Change__c > ) Trigger.new;
        this.triggerOld = (List < Phoenix_NDC_Change__c > ) Trigger.old;
          
          
    }
    public override void beforeInsert() {}
    public override void beforeUpdate() {}
    public override void afterUpdate() {
         List < Id > ndcChangeIds = new List < Id > ();

        for (Phoenix_NDC_Change__c ndcChange: triggerNew) {
            if (oldMap.get(ndcChange.Id).Phoenix_Approval_Status__c != newMap.get(ndcChange.Id).Phoenix_Approval_Status__c && newMap.get(ndcChange.Id).Phoenix_Approval_Status__c.contains('Closed')) {
                ndcChangeIds.add(ndcChange.Id);
            }
        }
         if (ndcChangeIds.size() > 0) Phoenix_SubmitBidForApprovalCtrl.BidClosureNotification(ndcChangeIds);
    
    }
    public override void beforeDelete(){
        triggerOld[0].addError('You can\'t delete the NDC Change');
  /*       List < Id > ndcChangeIds = new List < Id > ();
        for (Phoenix_NDC_Change__c ndcChange: triggerOld) {
            if (oldMap.get(ndcChange.Id).Phoenix_Approval_Status__c == 'Draft')
                ndcChangeIds.add(ndcChange.Id);
            else 
                ndcChange.addError('You can\'t delete this NDC Change, as it is already submitted for approval.');

        }
        if (ndcChangeIds.size() > 0)Phoenix_SubmitBidForApprovalCtrl.deleteBidChildren(ndcChangeIds);
      
  */  }


}