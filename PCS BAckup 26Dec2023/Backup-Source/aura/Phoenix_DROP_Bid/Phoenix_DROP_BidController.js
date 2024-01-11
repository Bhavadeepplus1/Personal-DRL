({
    readyforDrop: function(component,event,helper){
        component.set("v.readyToDrop",true);
    },
	dropTheBid : function(component, event, helper) {
        if(component.get("v.dropBidComment") == null || component.get("v.dropBidComment")== undefined){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type":"Warning",
                "title": "Drop Comments!",
                "message": "Please enter the drop comments for the bid."
            });
            toastEvent.fire();
            return;
        }
        component.set("v.showSpinner",true);
        var action = component.get("c.dropBid");
        action.setParams({
            bidId : component.get("v.recordId"),
            comments:component.get("v.dropBidComment")
        });
        action.setCallback(this, function(response){
            if(response.getState() == 'SUCCESS'){
                component.set("v.readyToDrop",false);
                component.set("v.showSpinner",false);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type":"success",
                    "title": "Success!",
                    "message": "The bid has been dropped !!"
                });
                toastEvent.fire();
                $A.get("e.force:closeQuickAction").fire();
                window.location.reload();
            }
        });
        $A.enqueueAction(action);
        
    },
    closeQuickActionPanel: function(component,event,helper){
        $A.get("e.force:closeQuickAction").fire();
    }
})