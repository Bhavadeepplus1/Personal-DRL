({
    doInit : function(component, event, helper) {
        var bidId = component.get("v.recordId");
        var getBidInfoAction = component.get("c.getBidInfo");
        getBidInfoAction.setParams({ "bidId": bidId });
        getBidInfoAction.setCallback(this, function (response) {
            var actState = response.getState();
            if (actState === 'SUCCESS') {
                var responseWarapper=response.getReturnValue();
                component.set("v.wrap",responseWarapper);
                if(responseWarapper.error!=null){
                    component.set("v.isError",true);
                    component.set("v.errorMessage",responseWarapper.error);
                    
                }
            }
        });
        $A.enqueueAction(getBidInfoAction);
        
    },
    
    closeQuickActionPanel: function (component, event, helper) {
        helper.closeActionPanel();
        
    },
    submitTheBid : function(component, event, helper) {
        component.set("v.showSpinner",true);
        var wrap = component.get("v.wrap");
        var submitBidAction = component.get("c.submitBid");
        submitBidAction.setParams({ "wrap": wrap });
        submitBidAction.setCallback(this, function (response) {
            var actState = response.getState();
            if (actState === 'SUCCESS') {
                component.set("v.showSpinner",false);
                var res = response.getReturnValue();
                
                if(res == 'Success'){
                  var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message":"Bid is sent for approval.",
                    "type":"success",
                    "mode":"dismissible"
                });
                toastEvent.fire();
                 
                helper.closeActionPanel(); 
                    window.location.reload();
                }else{
                    console.log('see res=>'+JSON.stringify(res));
                     component.set("v.isError",true);
                    component.set("v.errorMessage",res);
                } 
                
                
            }
        });
        $A.enqueueAction(submitBidAction);
        
    }
    
})