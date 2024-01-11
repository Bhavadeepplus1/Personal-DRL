({
    Onload: function(component,event,helper){
        $A.get('e.force:refreshView').fire();
    },
    pageReferenceChangeHandler: function(component, event, helper){
        let pageReference = component.get("v.pageReference");
        console.log(pageReference);
        let recordId = pageReference.state.c__recordId;
        console.log("pageReferenceChangeHandler: recordId: " + recordId);
        if (recordId != null && recordId!=undefined) {
            helper.loadInstance(component, helper);  
            
        }else{
            console.log("else part");
            component.set("v.recordId", null);
            $A.get('e.force:refreshView').fire();
        }
    },
    doInit : function(component,event,helper) {
        console.log("---doInit()-----");
        helper.loadInstance(component, helper);            
    },
    closeQuickActionPanel: function (component, event, helper) {
        console.log("---TermMatrixEdit---returnToRecord()-------"+component.get("v.recordId"));
        try {
            $A.get('e.force:refreshView').fire();
            let recordId = component.get("v.recordId");
            if (recordId != null) {
                // Go to record
                component.find("navigationService").navigate({
                    type: "standard__recordPage",
                    attributes: {
                        recordId: recordId,
                        actionName: "view"
                    }
                }, false); // replace
            } else {
                // Go to Initiative Home
                component.find("navigationService").navigate({
                    type: "standard__objectPage",
                    attributes: {
                        objectApiName: "Phoenix_Terms_Matrix__c",
                        actionName: "home"
                    }
                }, false); // replace
            }
        } catch (ex) {
            console.log(ex);
        }
        
    },
    redirectToDetailPage:function (component, event, helper) {
        
    
        var record = event.getParam("response");
        var apiName = record.apiName;
        var myRecordId = record.id; 
        console.log('myRecordId: '+myRecordId);
        var toastEvent = $A.get("e.force:showToast");
        var message;
        if(component.get("v.recordId")  == null|| component.get("v.recordId")  ===''||component.get("v.recordId")  ==='undefined'){
            message = 'created';
            
        }else{
            message = 'updated';
        }
        if(message=='updated'){
            toastEvent.setParams({
                "type" : "success",
                "title": "Success!",
            "message": "The record has been "+message+ " successfully."
            });
            toastEvent.fire();
           
            
            component.find("navigationService").navigate({
                type: "standard__recordPage",
                attributes: {
                    recordId: myRecordId,
                    actionName: "view"
                }
            }, false); // replace

            $A.get('e.force:refreshView').fire();

        } else{
            component.find("navigationService").navigate({
                type: "standard__recordPage",
                attributes: {
                    recordId: myRecordId,
                    actionName: "view"
                }
            }, false); // replace

            $A.get('e.force:refreshView').fire();
        }
        
        
    },
    getErrorMessage: function (component, event, helper) {
        console.log('errormessage---->'+event.getParam("output").fieldErrors);
    },
    handleCreateAccount: function(component, event, helper){
       // component.find("editform").submit();
        component.find("editform").submit();
    },
    setReadonly : function (component, event, helper) {

        let changedInput = event.getSource();

        //collect all inputs
        let fieldsMap = new Map();
        component.find("fieldLableId").forEach(function(eachInput){
            fieldsMap.set(eachInput.get("v.fieldName"), eachInput);
        });

       helper.validateInputs(component, helper, changedInput, fieldsMap,false);
        
    },
   
})