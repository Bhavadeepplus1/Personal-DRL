({
    doInit : function(component, event, helper) {
        component.set("v.showSpinner",true);
        var recId = component.get("v.recId");
        var accId = component.get("v.accObj").Id;
        var itemType = component.get("v.alertType");
        var action=component.get("c.fetchVisionAlertList");
        action.setParams({recId:recId, recType:itemType,accId:accId});
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
    
    validateDueDate : function(component, event, helper){
        var today = new Date();
        var enteredDate = component.get("v.alertObj.Vision_Notification_Due_Date__c");
        if(new Date(enteredDate) <= today){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "ERROR",
                "message":'Due date can not be less than Today.',
                "type":"ERROR",
                "mode":"dismissible"
            });
            toastEvent.fire();   
            //component.set("v.ANDueDate",today);
        }
    },
    
    submitDetails: function(component, event, helper) {
        
        var alertObj = component.get("v.alertObj");
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
                else
                {
                    component.set("v.showSpinner",true);
                    var recId = '';
                    recId = component.get("v.recId") != undefined ? component.get("v.recId") : '';
                    var itemType = component.get("v.alertType");
                    var action=component.get("c.saveAlert");
                    
                    action.setParams({alertObj:alertObj, accObj:component.get("v.accObj"), 
                                      recId : recId, itemType:itemType});
                    
                    action.setCallback(this,function(response){
                        var state= response.getState(); 
                        console.log('State--->'+ state);
                        if(state=='SUCCESS'){
                            var wrapperObj = response.getReturnValue();
                            var compEvent = component.getEvent("alertEvent");
                            console.log('wrapperObj--->'+wrapperObj);
                            if(itemType == 'gcpItem'){
                                compEvent.setParams({
                                    "gcpItem" : wrapperObj.gcpObj 
                                });
                                compEvent.fire();
                            }
                            else if(itemType=="ndcItem"){
                                compEvent.setParams({
                                    "gcpNdcItem" : wrapperObj.ndcObj 
                                });
                                compEvent.fire();
                            }
                                //else if(itemType=="accCalendar"){
                                //    component.set("v.isModalOpen", false);
                               // }
                            
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
                }
    },
    closeModel : function(component, event, helper){
        component.set("v.isModalOpen", false);
    }
})