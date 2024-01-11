({
    submithelper: function(component, event, helper){
        
        var alertObj = component.get("v.alertObj");
        var recId= component.get("v.recId");
        var today = new Date();
        if(alertObj.Vision_Alert_Topic__c == undefined || alertObj.Vision_Alert_Topic__c == ''){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "ERROR",
                "message":'Please Enter Alert Subject.',
                "type":"ERROR",
                "mode":"dismissible"
            });
            toastEvent.fire();
        }
        else if(alertObj.Vision_Notification_Due_Date__c == undefined || alertObj.Vision_Notification_Due_Date__c == ''){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "ERROR",
                "message":'Please Enter Alert Due Date.',
                "type":"ERROR",
                "mode":"dismissible"
            });
            toastEvent.fire();
        }
            else if(new Date(alertObj.Vision_Notification_Due_Date__c) <= today){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "ERROR",
                    "message":'Due date can not be less than Today.',
                    "type":"ERROR",
                    "mode":"dismissible"
                });
                toastEvent.fire(); 
            }        
        var alertObj = component.get("v.alertObj");
        var itemType = component.get("v.alertType");
        // console.log('recId---->'+recId);
        console.log('accObj--->'+ component.get("v.accObj"));
        console.log('alertObj--->'+ alertObj);
        console.log('itemType--->'+ itemType);
        var action=component.get("c.saveCalendarAlert");
        
        action.setParams({alertObj:alertObj, accObj:component.get("v.recId"), 
                          itemType:itemType});
        action.setCallback(this,function(response){
            var state= response.getState(); 
            console.log('State--->'+ state);
            if (state === "SUCCESS"){
                console.log('RESPONSE  ---> '+JSON.stringify(response.getReturnValue()));
                var alertObj = response.getReturnValue();
                component.set("v.isModalOpen", false);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "SUCCESS",
                    "message":'Alert has been created successfully.',
                    "type":"SUCCESS",
                    "mode":"dismissible"
                });
                toastEvent.fire();
                component.set("v.showSpinner",false);
            }
            else{
                console.log('error while saving alert : '+JSON.stringify(response.getError()));
                component.set("v.showSpinner",false);
            }
        }); 
        $A.enqueueAction(action);
    },
    initHelper: function(component, event, helper){
        var recId = component.get("v.accObj");
        console.log('Account Id--->'+recId);   
        var accId = component.get("v.recId");
        console.log('Record Id--->'+accId);
        var itemType = component.get("v.alertType");
        var action=component.get("c.fetchCalendarVisionAlertList");
        action.setParams({accObj:accId, recType:itemType});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                console.log('RESPONSE  ---> '+JSON.stringify(response.getReturnValue()));
                var alertObj = response.getReturnValue();
                if(alertObj.Id == undefined){
                    alertObj.Vision_isActiveAlert__c = true;
                }
                if(alertObj.Vision_Notification_Repeat_Time__c == undefined)
                    alertObj.Vision_Notification_Repeat_Time__c = '14:00:00.000'; 
                component.set("v.alertObj",alertObj);
                console.log('alertObj--->'+alertObj);
                component.set("v.showSpinner",false);
            }
            else{
                console.log('error while fetching alert : '+JSON.stringify(response.getError()));
                component.set("v.showSpinner",false);
            }
        });
        $A.enqueueAction(action);
    },
})