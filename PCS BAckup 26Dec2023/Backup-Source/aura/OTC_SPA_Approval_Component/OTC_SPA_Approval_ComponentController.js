({
    doInit : function(component, event, helper) {
        console.log('doInit');
        var action = component.get('c.validateOTCSPAs');
        action.setParams({
            'oppId' : component.get('v.recordId')
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS" && component.isValid()){
                var spaRecs = JSON.parse(response.getReturnValue());
                console.log('Recs',spaRecs);
                if(spaRecs.length <= 0){
                    helper.approvalSubmission(component);
                } else {
                    component.set('v.otcList',spaRecs);
                }
            } else {
                var error = response.getError();
                helper.showError(component,error);
            }
        });
        $A.enqueueAction(action);
    }
})