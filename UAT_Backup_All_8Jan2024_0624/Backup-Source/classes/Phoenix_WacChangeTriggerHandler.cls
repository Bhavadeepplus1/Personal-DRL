public class Phoenix_WacChangeTriggerHandler extends TriggerHandler {
  private list < Phoenix_WAC_Change__c > triggerNew;
    private list < Phoenix_WAC_Change__c > triggerOld;
    private Map < Id, Phoenix_WAC_Change__c > newMap;
    private Map < Id, Phoenix_WAC_Change__c > oldMap;
    public Phoenix_WacChangeTriggerHandler() {
        this.newMap = (Map < Id, Phoenix_WAC_Change__c > ) Trigger.newMap;
        this.oldMap = (Map < Id, Phoenix_WAC_Change__c > ) Trigger.oldMap;
        this.triggerNew = (List < Phoenix_WAC_Change__c > ) Trigger.new;
        this.triggerOld = (List < Phoenix_WAC_Change__c > ) Trigger.old;
        
        
    }
    public override void beforeInsert() {}
    public override void beforeUpdate() {}
    public override void afterUpdate() {
        List < Id > WacChangeIds = new List < Id > ();
        
        for (Phoenix_WAC_Change__c WACChange: triggerNew) {
            if (oldMap.get(WACChange.Id).Phoenix_Approval_Status__c != newMap.get(WACChange.Id).Phoenix_Approval_Status__c && newMap.get(WACChange.Id).Phoenix_Approval_Status__c.contains('Closed')) {
                WacChangeIds.add(WACChange.Id);
            }
        }
        if (WacChangeIds.size() > 0) Phoenix_SubmitBidForApprovalCtrl.BidClosureNotification(WacChangeIds);
        
    }
    public override void beforeDelete(){
         triggerOld[0].addError('You can\'t delete the WAC Change');
     /*   List < Id > WacChangeIds = new List < Id > ();
        for (Phoenix_WAC_Change__c WACChange: triggerOld) {
            if (oldMap.get(WACChange.Id).Phoenix_Approval_Status__c == 'Draft')
                WacChangeIds.add(WACChange.Id);
            else 
                WACChange.addError('You can\'t delete this WAC Change, as it is already submitted for approval.');
            
        }
        if (WacChangeIds.size() > 0)Phoenix_SubmitBidForApprovalCtrl.deleteBidChildren(WacChangeIds);
        system.debug('deleting children');
*/    }
    
    
}