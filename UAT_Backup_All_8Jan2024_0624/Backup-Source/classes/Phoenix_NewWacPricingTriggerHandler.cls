public class Phoenix_NewWacPricingTriggerHandler extends TriggerHandler {
    private list < New_Product_WAC_Pricing__c > triggerNew;
    private list < New_Product_WAC_Pricing__c > triggerOld;
    private Map < Id, New_Product_WAC_Pricing__c > newMap;
    private Map < Id, New_Product_WAC_Pricing__c > oldMap;
    public Phoenix_NewWacPricingTriggerHandler() {
        this.newMap = (Map < Id, New_Product_WAC_Pricing__c > ) Trigger.newMap;
        this.oldMap = (Map < Id, New_Product_WAC_Pricing__c > ) Trigger.oldMap;
        this.triggerNew = (List < New_Product_WAC_Pricing__c > ) Trigger.new;
        this.triggerOld = (List < New_Product_WAC_Pricing__c > ) Trigger.old;
        
        
    }
    public override void beforeInsert() {}
    public override void beforeUpdate() {}
    public override void afterUpdate() {
        List < Id > newWacIds = new List < Id > ();
        
        for (New_Product_WAC_Pricing__c newWac: triggerNew) {
            if (oldMap.get(newWac.Id).Phoenix_Approval_Status__c != newMap.get(newWac.Id).Phoenix_Approval_Status__c && newMap.get(newWac.Id).Phoenix_Approval_Status__c.contains('Closed')) {
                newWacIds.add(newWac.Id);
            }
        }
        if (newWacIds.size() > 0) Phoenix_SubmitBidForApprovalCtrl.BidClosureNotification(newWacIds);
        
    }
    public override void beforeDelete(){
         triggerOld[0].addError('You can\'t delete the New Product WAC Pricing');
   /*     List < Id > newWacIds = new List < Id > ();
        for (New_Product_WAC_Pricing__c newWac: triggerOld) {
            if (oldMap.get(newWac.Id).Phoenix_Approval_Status__c == 'Draft')
                newWacIds.add(newWac.Id);
            else 
                newWac.addError('You can\'t delete this New Product WAC Pricing, as it is already submitted for approval.');
            
        }
        if (newWacIds.size() > 0)Phoenix_SubmitBidForApprovalCtrl.deleteBidChildren(newWacIds);
        system.debug('deleting children');
   */ }
    
    
}