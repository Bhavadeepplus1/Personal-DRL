({
	doInit : function(component, event, helper) {
		var action = component.get("c.getBidActionItems");
        console.log('recordId-->'+component.get("v.recordId"))
        action.setParams({
            bidId : component.get("v.recordId")
        });
        action.setCallback(this, function(response){
            if(response.getState() === "SUCCESS"){
                var mdmWrapper = response.getReturnValue();
                component.set("v.canHeSubmit",mdmWrapper.canHeSubmit);
                component.set("v.bidActionItemList",mdmWrapper.mdmActionItemList);
                component.set("v.admins",mdmWrapper.admins);
                component.set("v.isCustomerStepDone",mdmWrapper.isCustomerStepCmpltd);
                component.set("v.productList",mdmWrapper.productList);
                component.set("v.loggedInUserId",mdmWrapper.loggedInUserId);
                //added by vandana.
                var adminsList = component.get("v.admins");
                var loggedinUserId = component.get("v.loggedInUserId");
                if(adminsList.includes(loggedinUserId)){
                     component.set("v.IsHeAdmin",true);
                }
            }else{
                console.log('get error');
            }
        });
        $A.enqueueAction(action);
	},
    submitCodesMethod:function(component,event,helper){  
        component.set("v.isSpinnerLoad",true);
        var action = component.get("c.submitProductCodes");
        action.setParams({
            bidId : component.get("v.recordId")
        });
        action.setCallback(this, function(response){
            if(response.getState() === "SUCCESS"){
                component.set("v.isSpinnerLoad",false);
                var mdmWrapper = response.getReturnValue();
                component.set("v.canHeSubmit",mdmWrapper.canHeSubmit);
                component.set("v.bidActionItemList",mdmWrapper.mdmActionItemList);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": "success",
                    "title": "Success!",
                    "message": "Product Codes Updated Successfully."
                });
                toastEvent.fire();
            }else{
                console.log('get error');
            }
        });
        $A.enqueueAction(action);
	},
    handleMDMEvent:function(component,event,helper){  
        var valueFromChild = event.getParam("canHeSubmit");
            component.set("v.canHeSubmit", valueFromChild);
        console.log("parent event--->"+valueFromChild)
     },
    backToBid: function (component, event, helper) {
        component.find("navigationService").navigate({
            type: "standard__recordPage",
            attributes: {
                recordId: component.get("v.recordId"),
                actionName: "view"
            }
        }, false);

    },
    
})