({
	doInit : function(component, event, helper) {
		var action = component.get("c.apexJobStatus");
        action.setCallback(this, function(response){
            if(response.getState() == 'SUCCESS'){
                console.log('Response: '+JSON.stringify(response.getReturnValue()));
                component.set("v.isJobRunning", response.getReturnValue());
            } else{
                console.log('Error: '+response.getError());
            }
        });
        $A.enqueueAction(action);
	}
})