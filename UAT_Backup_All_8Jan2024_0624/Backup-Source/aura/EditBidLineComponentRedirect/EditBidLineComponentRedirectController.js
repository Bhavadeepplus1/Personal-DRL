({
    init : function(component, event, helper) {
        console.log('TermMatrixRedirect init()');
        component.set('v.recordId',component.get("v.pageReference").state.c__id)
        var recordId = component.get("v.recordId");
        
        console.log('recordId---->'+recordId)
        var action = component.get("c.getBid");
        action.setParams({
            bidId : recordId
        });
       action.setCallback(this, function(response) {
           console.log('inside the callback');
            var state = response.getState();
            console.log('inside the callback'+state);
           if(state === 'SUCCESS'){
               var bid = response.getReturnValue();
               if(bid.Phoenix_Customer_Type__c == 'Direct' || bid.Phoenix_Customer_Type__c == 'Indirect' || bid.Phoenix_Customer_Type__c == 'Direct and Indirect'){
                  console.log('bid.Phoenix_Customer_Type__c---->'+bid.Phoenix_Customer_Type__c);
                   component.find("navigationService").navigate({
                       type: "standard__component",
                       attributes: {
                           componentName: "c__BidLineItemEditDemoCmp" },
                       state: {
                           c__id: recordId,
                           
                       }
                   }, true); // replace = true
                   
               }else if(bid.Phoenix_Customer_Type__c == 'Walgreens'){
                   /*component.find("navigationService").navigate({
                       type: "standard__component",
                       attributes: {
                           componentName: "c__WalgreensTemplate" },
                       state: {
                           c__id: recordId,
                          
                       }
                   }, true); // replace = true*/
               }
           }
            
            
        });
        $A.enqueueAction(action);
        
    }
})