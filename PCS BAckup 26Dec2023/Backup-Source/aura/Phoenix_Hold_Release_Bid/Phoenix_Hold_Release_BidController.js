({
    doInit: function(component, event, helper){
           component.set("v.showSpinner",true);
        var getBidInfoAction = component.get("c.getBidDetails");
        var bidId = component.get("v.recordId");
        getBidInfoAction.setParams({ "bidId": bidId });
        getBidInfoAction.setCallback(this, function (response) {
            var actState = response.getState();
            if (actState === 'SUCCESS') {
                var responseWarapper=response.getReturnValue();
                component.set("v.bid",responseWarapper.bid);
                var bidObject = component.get("v.bid");
                console.log('bid-->'+JSON.stringify(bidObject));
                console.log('hold-->'+bidObject.Phoenix_On_Hold__c );
                if(bidObject.Phoenix_On_Hold__c == true){
                    component.set("v.OnHold",true);
                }
                if(bidObject.Phoenix_Approval_Status__c.includes("Rejected")){
                    component.set("v.isError",true);
                    console.log('rejected case found');
                     component.set("v.errormsg",'You can’t Hold  this bid as it is already rejected');
                }
                
            }
            
               component.set("v.showSpinner",false);
        });
        $A.enqueueAction(getBidInfoAction);
        
    },
    closeQuickActionPanel : function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    },
    holdTheBid : function(component, event, helper) {
           component.set("v.showSpinner",true);
        var bidId = component.get("v.recordId");
        var holdBidAction = component.get("c.holdBid");
        holdBidAction.setParams({ "bidId": bidId });
        holdBidAction.setCallback(this, function (response) {
            
            var res = response.getReturnValue();
            if(res == 'Success'){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type":"success",
                    "title": "Success!",
                    "message": "Bid kept on hold."
                });
                toastEvent.fire();
                window.location.reload();
                $A.get("e.force:closeQuickAction").fire();
                
                
            }
            else{
                component.set("v.isError",true);
                component.set("v.errormsg", response.getReturnValue());
            }
               component.set("v.showSpinner",false);
        });
        $A.enqueueAction(holdBidAction);
        
    },
    releaseTheBid : function(component, event, helper) {
           component.set("v.showSpinner",true);
        var bidId = component.get("v.recordId");
        var releaseBidAction = component.get("c.releaseBid");
        releaseBidAction.setParams({ "bidId": bidId });
        releaseBidAction.setCallback(this, function (response) {
            if(response.getState()=="SUCCESS"){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type":"success",
                    "title": "Success!",
                    "message": "Bid released."
                });
                toastEvent.fire();
                window.location.reload();
                $A.get("e.force:closeQuickAction").fire();
                
                
            }
            else{
                component.set("v.isError",true);
                component.set("v.errormsg", response.getReturnValue());
            }
               component.set("v.showSpinner",false);
        });
        $A.enqueueAction(releaseBidAction);
    }
    
})