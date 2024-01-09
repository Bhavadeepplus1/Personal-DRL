({
    showError : function(component,error) {
        console.log('Error',error);
        var errorMsg = [];
        for(var i=0 ; i< error.length ; i++){
            console.log('err---',error[i].pageErrors);
           
            if(error[i].pageErrors){
                var pageErrors = error[i].pageErrors;
                for(var j=0;j< pageErrors.length;j++){
                    console.log('page--',pageErrors[j].message);
                    errorMsg.push((i+1)+'. '+pageErrors[j].message);
                }
            } else {
                errorMsg.push((i+1)+'. '+error[i].message);
            }
        }
        console.log('lib',component.find('notifLib'));
        console.log('Msg' ,errorMsg);
        component.set('v.messages',errorMsg);
    },
    approvalSubmission : function(component){
        var action = component.get('c.submitForApproval');
        action.setParams({
            'oppId' : component.get('v.recordId')
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS" && component.isValid()){
                var successMsg = response.getReturnValue();
                $A.get("e.force:closeQuickAction").fire();
                console.log('Approval Submission Success');
                console.log('successMsg',successMsg);
                component.find('notifLib').showToast({
                    "variant" : "success",
                    "title": "Success",
                    "message": 'The OTC-SPA records are successfully submitted for approval.'
                });
            } else {
                var error = response.getError();
                this.showError(component,error);
            }
        });
        $A.enqueueAction(action);
        
    }
})