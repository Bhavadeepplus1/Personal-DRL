public class Vision_DroppedLineItemActionHandler extends TriggerHandler {
    @TestVisible private list < Phoenix_Bid_Line_Item__c > triggerNew;
    
    public Vision_DroppedLineItemActionHandler() {
        this.triggerNew = (List < Phoenix_Bid_Line_Item__c > ) Trigger.new;
    }
    
    public override void beforeUpdate() {
        List<Id> droppedIds = new List<Id>();
        Map<Id,String> prodDroppedCommentMap = new Map<Id,String>();
        for(Phoenix_Bid_Line_Item__c obj:triggerNew){
            if(obj.Phoenix_Bid_Line_Item_Approval_Status__c == 'Dropped'){
                droppedIds.add(obj.Id);
            }
        }
        List<Phoenix_Bid_Line_Item__c> lineItemList = [SELECT Id, Name, Phoenix_Product__c, Phoenix_Bid__r.Phoenix_Dropped_Comments__c FROM Phoenix_Bid_Line_Item__c WHERE Id IN: droppedIds];
        for(Phoenix_Bid_Line_Item__c obj:lineItemList){
            prodDroppedCommentMap.put(obj.Phoenix_Product__c , obj.Phoenix_Bid__r.Phoenix_Dropped_Comments__c);
        }
        List<Product_Opportunity__c> optyProdList = [SELECT Id, Name, Status__c, Product__c FROM Product_Opportunity__c WHERE Vision_Bid_Line_Item__c IN:droppedIds];
        List<Id> optyProdIds = new List<Id>();
        for(Product_Opportunity__c obj:optyProdList){
            obj.Status__c = 'Dropped';
            if(prodDroppedCommentMap.containsKey(obj.Product__c)){
                obj.Vision_Dropped_Comments__c = prodDroppedCommentMap.get(obj.Product__c);
                obj.Vision_Bright_Delete_Comments__c = prodDroppedCommentMap.get(obj.Product__c);
            }
            optyProdIds.add(obj.Id);
        }
        update optyProdList;
        List<Vision_Market_Share_Expansion__c> shareExpnList = [SELECT Id,Vision_Product__c, Name, Task_Status__c FROM Vision_Market_Share_Expansion__c WHERE ProductOpportunity__c IN: optyProdIds];
        for(Vision_Market_Share_Expansion__c obj:shareExpnList){
            obj.Task_Status__c = 'Dropped';
            if(prodDroppedCommentMap.containsKey(obj.Vision_Product__c))
                obj.Vision_Dropped_Comments__c = prodDroppedCommentMap.get(obj.Vision_Product__c);
        }
        update shareExpnList;
    }
}