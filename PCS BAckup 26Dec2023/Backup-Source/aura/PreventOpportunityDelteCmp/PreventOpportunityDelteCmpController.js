({
	doInit : function(component, event, helper) {
        console.log('in doinit--'+component.get("v.recordId"))
		var action=component.get("c.getOpportunityProductsList");
        component.set("v.canWedelete",true);
        if(component.get("v.recordId") != undefined && component.get("v.recordId") != '' ){
            action.setParams({
                opptyId:component.get("v.recordId")
            });
            action.setCallback(this,function(response){
                console.log('state--->'+response.getState())
                if(response.getState()=='SUCCESS'){
                    var respWrapper = response.getReturnValue();
                    component.set("v.OptyResponse",response.getReturnValue());
                    console.log('response.getReturnValue()===>'+JSON.stringify(response.getReturnValue()));
                    if(respWrapper.opportunityStage != 'Opportunity in progress'){
                        component.set("v.showMessage",true);
                        component.set("v.sevType",'error');
                        component.set("v.loadMessage",'You can not delete this Opportunity as it has been sent to BRIGHT.');
                    }
                }
            });
            $A.enqueueAction(action);
        }
        
	},
    deleteOpty : function(component, event, helper) {
        
        if(component.get("v.recordId") != undefined && component.get("v.recordId") != '' ){
            var action= component.get("c.deleteOpportunity");
            action.setParams({
                opptyId:component.get("v.recordId")
            });
            action.setCallback(this,function(response){
                console.log('state--->'+response.getState())
                if(response.getState()=='SUCCESS'){
                    //component.set("v.canWedelete",false);
                    /*var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "message": "The record has been deleted successfully."
                    });
                    toastEvent.fire();*/
                    /*component.find('notifLib').showNotice({
                        "variant": "SUCCESS",
                        "header": "SUCCESS!",
                        "message": "The record has been deleted successfully.",
                        closeCallback: function() {
                            //alert('You closed the alert!');
                        }
                    });*/
                    component.set("v.showMessage",true);
                    component.set("v.sevType",'Info');
                    component.set("v.loadMessage",'Opportunity has been deleted Successfully.');
                    
                    //window.location = "https://drreddysnag--phoenixpcs.lightning.force.com/lightning/o/Opportunity/list?filterName=Recent";
                    //history.back();
                }
            });
            $A.enqueueAction(action);
        }
    },
    redirectTOOpptyHome : function(component, event, helper) {
        //component.set("v.canWedelete",false);
        //window.location = "https://drreddysnag--phoenixpcs.lightning.force.com/lightning/o/Opportunity/list?filterName=Recent";
        history.back();
    
    }
})