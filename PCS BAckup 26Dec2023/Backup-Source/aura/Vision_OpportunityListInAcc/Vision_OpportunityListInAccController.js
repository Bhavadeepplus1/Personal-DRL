({
	doInit : function(component, event, helper) {
        var accId = component.get("v.recordId");
        var action = component.get("c.getOptyList");
        action.setParams({accId : accId});
        action.setCallback(this, function (response) {
            console.log('State from getGcpRelatedList :: '+response.getState());
            if (response.getState() == "SUCCESS") {
                var optyList = response.getReturnValue();
                component.set("v.optyList",optyList);
                component.set('v.isSpinner', false);
            }
            else {
                console.log('ERROR WHILE GETTING Opty List --> '+JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);
	}
})