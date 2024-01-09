({
   /* loadInstance: function(component, event){
        var action = component.get("c.getApprovals");
        var ndcId = component.get("v.singleRec").NDCChangeId;
        action.setParams({
            "ndcChangeId": ndcId 
        });
        action.setCallback(this, function(response) {
            if(response.getState() == "SUCCESS") {
                component.set("v.isSCMApprover",response.getReturnValue());
                console.log('Approval Response :::: '+JSON.stringify(response.getReturnValue()));
            } else {
                console.log("Error "+JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);
    },*/
   // fetch picklist values dynamic from apex controller 
  
})