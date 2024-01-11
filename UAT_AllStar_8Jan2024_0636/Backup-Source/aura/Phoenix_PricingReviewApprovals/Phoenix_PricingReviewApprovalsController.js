({
    initRecords: function(component, event, helper) { 
        var action = component.get("c.getBid"); 
        var recordId=component.get("v.recordId");
        console.log('---------recordId-----'+recordId);
        action.setParams
        ({
            bidId: recordId
        });
        action.setCallback(this, function(response) 
                           {
                               if(response.getState()=="SUCCESS"){
                                   var wrapperObj =  response.getReturnValue();
                                   var bidRecord = wrapperObj.bidRecord;
                                   var approvalState=wrapperObj.approvalStatus;
                                   console.log('--------approvalState------'+approvalState);
                                   component.set("v.approvalStatus",approvalState);
                                   component.set("v.bidRecord",bidRecord);
                               }
                               else{
                               }
                           });
        $A.enqueueAction(action);
        
    },
    saveToProceedBusiness: function (component, event, helper) {
        var finComm=component.find("businessComments").get("v.value");
        var finAppStatus=component.find("businessAppStatus").get("v.value");
        var approvalStatus=component.get("v.approvalStatus");
        var action = component.get("c.makeApprovalsBusiness");
        action.setParams({
            'bidId' : component.get("v.recordId"),
            'finaceCom':finComm,
            'financeAppStatus':finAppStatus,
            'approvStatus':approvalStatus
        });
        action.setCallback(this, function (response){
            if(response.getState() === "SUCCESS"){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type":"success",
                    "title": "Success",
                    "message": "Your Approvals are submitted successfully."
                });
                toastEvent.fire();
                
            }
            else{
                var errors = response.getError();
                console.log("Error message: -----------------------" +
                            errors[0].message);
            }
            $A.get('e.force:refreshView').fire();  
        });
        $A.enqueueAction(action);
    },
     saveToProceedContr: function (component, event, helper) {
        var finComm=component.find("contractsComments").get("v.value");
        var finAppStatus=component.find("contractsAppStatus").get("v.value");
        var approvalStatus=component.get("v.approvalStatus");
        var action = component.get("c.makeApprovalsContracts");
        action.setParams({
            'bidId' : component.get("v.recordId"),
            'finaceCom':finComm,
            'financeAppStatus':finAppStatus,
            'approvStatus':approvalStatus
        });
        action.setCallback(this, function (response){
            if(response.getState() === "SUCCESS"){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type":"success",
                    "title": "Success",
                    "message": "Your Approvals are submitted successfully."
                });
                toastEvent.fire();
                
            }
            else{
                var errors = response.getError();
                console.log("Error message: -----------------------" +
                            errors[0].message);
            }
            $A.get('e.force:refreshView').fire();  
        });
        $A.enqueueAction(action);
    },
    closeModal : function(component,event,helper) {
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
    }
})