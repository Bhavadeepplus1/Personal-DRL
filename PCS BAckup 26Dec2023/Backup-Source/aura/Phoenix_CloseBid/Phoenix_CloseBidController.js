({
        doInit: function(component, event, helper){
        var getBidInfoAction = component.get("c.getBidDetails");
        var bidId = component.get("v.recordId");
        getBidInfoAction.setParams({ "bidId": bidId });
        getBidInfoAction.setCallback(this, function (response) {
            var actState = response.getState();
            if (actState === 'SUCCESS') {
                var responseWarapper=response.getReturnValue();
                component.set("v.bid",responseWarapper.bid);
                var bidObject = component.get("v.bid");
                if(bidObject.Phoenix_Approval_Status__c !="Draft"){
                    component.set("v.isError",true);
                    component.set("v.errormsg", "You can't close this Bid, as it is already submitted for approval.");
                }

            }
            
            
        });
        $A.enqueueAction(getBidInfoAction);
        
    },
       closeQuickActionPanel : function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    },
    
    
    
     closeTheBid : function(component, event, helper) {
        console.log('record Id is '+component.get("v.recordId"));
        var bidId = component.get("v.recordId");
        var closeBidAction = component.get("c.closeDraftBid");
        closeBidAction.setParams({ "bidId": bidId });
        closeBidAction.setCallback(this, function (response) {
           if(response.getState()=="SUCCESS"){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type":"success",
                    "title": "Success!",
                    "message": "Bid closed successfully."
                });
                toastEvent.fire();
                window.location.reload();
                $A.get("e.force:closeQuickAction").fire();
                
                
            }
            else{
                component.set("v.isError",true);
                component.set("v.errormsg", response.getReturnValue());
                console.log( 'response ->'+ response.getReturnValue());
            }
        });
        $A.enqueueAction(closeBidAction);
    }
       
/*    doInit: function(component, event, helper){
        var getBidInfoAction = component.get("c.getBidInfo");
        var bidId = component.get("v.recordId");
        getBidInfoAction.setParams({ "bidId": bidId });
        getBidInfoAction.setCallback(this, function (response) {
            var actState = response.getState();
            if (actState === 'SUCCESS') {
                var responseWarapper=response.getReturnValue();
                component.set("v.bid",responseWarapper.bid);
                var bidObject = component.get("v.bid");
                if(bidObject.Phoenix_Approval_Status__c.includes("Closed")){
                    component.set("v.isError",true);
                    component.set("v.errormsg", "This Bid is already closed.");
                }
                
                else if(bidObject.Phoenix_Approval_Status__c.includes("Rejected")){
                    component.set("v.isError",true);
                    component.set("v.errormsg", "This Bid is already Rejected.");
                }
            }
            
            
        });
        $A.enqueueAction(getBidInfoAction);
        
    },*/
  /*  closeTheBid : function(component, event, helper) {
        console.log('record Id is '+component.get("v.recordId"));
        var bidId = component.get("v.recordId");
        var closeBidAction = component.get("c.closeBid");
        closeBidAction.setParams({ "bidId": bidId });
        closeBidAction.setCallback(this, function (response) {
            if (response.getReturnValue() === 'Success') {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type":"success",
                    "title": "Success!",
                    "message": "Bid closed successfully."
                });
                toastEvent.fire();
                window.location.reload();
                $A.get("e.force:closeQuickAction").fire();
                
                
            }
            else{
                component.set("v.isError",true);
                component.set("v.errormsg", response.getReturnValue());
                console.log( 'response ->'+ response.getReturnValue());
            }
        });
        $A.enqueueAction(closeBidAction);
    }
 */   
})