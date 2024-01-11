({
    doInit : function(component, event, helper) {
        helper.getData(component, event, helper);
       /* component.set("v.loadSpinner", true);
        var action = component.get("c.getExistingDeleRecords");
        action.setCallback(this, function(response) 
                           {
                               if(response.getState()=="SUCCESS"){
                                   console.log('Response: '+JSON.stringify(response.getReturnValue()));
                                   var deleUsersList = response.getReturnValue().deleUsersList;
                                   component.set("v.loggedInUser", response.getReturnValue().loggedInUser);
                                   component.set("v.userLkp",response.getReturnValue().loggedInUserId);
                                   component.set("v.delegatorLkp",response.getReturnValue().loggedInUserId);
                                   component.set("v.loggedInUserProfile",response.getReturnValue().loggedInUserProfile);
                                   component.set("v.isLoggedInUsedHead",response.getReturnValue().isLoggedInUsedHead);
                                   var dateNow = new Date();
                                   if(deleUsersList != null){
                                       for(var i=0; i<deleUsersList.length; i++){
                                           if(deleUsersList[i].Phoenix_Delegation_End_Time__c < dateNow){
                                               deleUsersList[i].status = 'Expired';
                                           } else{
                                               deleUsersList[i].status = 'Active';
                                           }
                                       }
                                   }
                                   component.set("v.excistingDeleList", deleUsersList);
                               } else{
                                   console.log("Exception Inside: "+JSON.stringify(response.getError()));        
                               }
                           });
        $A.enqueueAction(action);
        component.set("v.loadSpinner", false);*/
    },
    handleChange : function(component, event, helper) {
        var delegatorId = component.get("v.delegatorLkp");
        console.log('Delegator ID is: '+delegatorId);
        helper.getData(component, event, helper, delegatorId);
        /*component.set("v.loadSpinner", true);
        var action = component.get("c.getExistingDeleRecords");
        action.setParams({
            'userId': delegatorId
        });
        action.setCallback(this, function(response) 
                           {
                               if(response.getState()=="SUCCESS"){
                                   console.log('Response: '+JSON.stringify(response.getReturnValue()));
                                   var deleUsersList = response.getReturnValue().deleUsersList;
                                   component.set("v.loggedInUser", response.getReturnValue().loggedInUser);
                                   component.set("v.userLkp",response.getReturnValue().loggedInUserId);
                                   component.set("v.delegatorLkp",response.getReturnValue().loggedInUserId);
                                   component.set("v.loggedInUserProfile",response.getReturnValue().loggedInUserProfile);
                                   console.log('loggedInUserProfile: '+response.getReturnValue().loggedInUserProfile);
                                   //component.set("v.isLoggedInUsedHead",response.getReturnValue().isLoggedInUsedHead);
                                   var dateNow = new Date();
                                   if(deleUsersList != null){
                                       for(var i=0; i<deleUsersList.length; i++){
                                           if(deleUsersList[i].Phoenix_Delegation_End_Time__c < dateNow){
                                               deleUsersList[i].status = 'Expired';
                                           } else{
                                               deleUsersList[i].status = 'Active';
                                           }
                                       }
                                   }
                                   component.set("v.excistingDeleList", deleUsersList);
                               } else{
                                   console.log("Exception Inside: "+JSON.stringify(response.getError()));        
                               }
                           });
        $A.enqueueAction(action);
        component.set("v.loadSpinner", false);*/
    },
    handleClick: function(component, event, helper){
        component.set("v.showInfoPopup", !component.get("v.showInfoPopup"));
    },
    closeModal: function(component, event, helper){
        component.set("v.showInfoPopup", false);
    },
    openDelegatorHistory : function(component, event, helper) {
        var navService = component.find("navService");
        var pageReference = {
            "type": "standard__component",
            "attributes": {
                "componentName": "c__Phoenix_delegation_History"  // c__YourComponentName
            }
        }
        
        navService.navigate(pageReference);
    },  
    validateStartTime: function(component, event, helper){
        var startTime = component.get("v.startTime");
        var action = component.get("c.formatDateEST");
        action.setParams({
            'dt': startTime,
            'tz': 'America/New_York'
        });
        action.setCallback(this, function(response){
            if(response.getState() == 'SUCCESS'){
                console.log('Response: '+response.getReturnValue());
                var formattedESTStartTime = response.getReturnValue();
                component.set("v.startTimeString", formattedESTStartTime);
                var action2 = component.get("c.getNowEST");
                action2.setCallback(this, function(response){
                    if(response.getState() == 'SUCCESS'){
                        var timeNow = response.getReturnValue();
                        if(new Date(formattedESTStartTime) < new Date(timeNow)){
                            var message = 'Delegation Start Time should be greater than or equal to Today';
                            component.set("v.isValidationFailed", true);
                            helper.showErrorToast(component, event, message);
                        } else{
                            component.set("v.isValidationFailed", false);
                        }
                    } else{
                        console.log("Exception Inside: "+JSON.stringify(response.getError()));        
                    }
                });
                $A.enqueueAction(action2);   
            } else{
                console.log("Exception: "+JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);       
    },
    
    validateEndTime: function(component, event, helper){
        var startTime = component.get("v.EndTime");
        var action = component.get("c.formatDateEST");
        action.setParams({
            'dt': startTime,
            'tz': 'America/New_York'
        });
        action.setCallback(this, function(response){
            if(response.getState() == 'SUCCESS'){
                console.log('Response: '+response.getReturnValue());
                var formattedESTStartTime = response.getReturnValue();
                if(component.get("v.startTimeString") != null && component.get("v.startTimeString") != ''){
                    if(new Date(formattedESTStartTime) < new Date(component.get("v.startTimeString"))){
                        var message = 'Delegation End Time should not be lesser than Delegation Start Time';
                        component.set("v.isValidationFailed", true);
                        helper.showErrorToast(component, event, message);   
                    } else{
                        component.set("v.isValidationFailed", false);
                    }
                } else{
                    var action2 = component.get("c.getNowEST");
                    action2.setCallback(this, function(response){
                        if(response.getState() == 'SUCCESS'){
                            var timeNow = response.getReturnValue();
                            console.log('TimeNow: '+timeNow);
                            if(new Date(formattedESTStartTime) < new Date(timeNow)){
                                var message = 'Delegation End Time should be greater than or equal to Today/Delegation Start Time';
                                component.set("v.isValidationFailed", true);
                                helper.showErrorToast(component, event, message);
                            } else{
                                component.set("v.isValidationFailed", false);
                            }
                            console.log('isValidationFailed: '+component.get("v.isValidationFailed"));
                        } else{
                            console.log("Exception Inside: "+JSON.stringify(response.getError()));        
                        }
                    });
                    $A.enqueueAction(action2);  
                }
            } else{
                console.log("Exception: "+JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);       
    },
    validateSave : function(component, event, helper){
        console.log('validate save called');
        component.set("v.loadSpinner", true);
        var user = component.get("v.userLkp");
        var deleUser = component.get("v.deleUserLkp") ;
        var startTime =  component.get("v.startTime");
        var EndTime =  component.get("v.EndTime");
        if(user!=null && deleUser!=null && user!=undefined && deleUser!=undefined && user!='' && deleUser!='' && startTime!=null && EndTime!=null && startTime!=undefined && EndTime!=undefined && startTime!='' && EndTime!=''){
            console.log('user-->'+user);
            console.log('deleUser-->'+deleUser);
            helper.saveRecord(component, event, helper);
        }
        
        else if(startTime!=null && EndTime!=null && startTime!=undefined && EndTime!=undefined && startTime!='' && EndTime!=''){
            console.log('case 5');
            var message = 'Please select user and delegator.';
            helper.showErrorToast(component, event, message);
        }
            else if(user!=null && deleUser!=null && user!=undefined && deleUser!=undefined && user!='' && deleUser!=''){
                console.log('case 6');
                var message = 'Please select delegation start time and end time.';
                helper.showErrorToast(component, event, message);
            }
                else {
                    console.log('case 7');
                    var message =  'Please select all fields below.';
                    helper.showErrorToast(component, event, message);
                }
    },
    deletedeleItem : function(component, event, helper){
        component.set("v.loadSpinner", true);
        console.log('delete called');
        var target = event.target;
        var rowIndex = target.getAttribute("name");
        console.log('rowIndex--->'+rowIndex);
        var action = component.get("c.deleteDelegationItems");
        action.setParams({
            'userId' : component.get("v.userId")
        });
        action.setCallback(this, function(response) {
            component.set("v.loadSpinner", true);
            var state = response.getState();
            if(response.getReturnValue() == 'Success'){
                var action = component.get("c.getExistingDeleRecords");
                action.setCallback(this, function(response) 
                                   {
                                       
                                       if(response.getState()=="SUCCESS"){
                                           var deleUsersList = response.getReturnValue().deleUsersList;
                                           component.set("v.excistingDeleList", deleUsersList);
                                       }
                                   });
                $A.enqueueAction(action);
                
            }
            console.log('state--->'+state);
            component.set("v.loadSpinner", false);
        });
        $A.enqueueAction(action);
        var event = component.getEvent("lightningEvent");
        event.setParam("message", "the message to send" );
        event.fire();
        component.set("v.loadSpinner", false);
        component.set("v.confirmDelete", false);
    },
    closeQuickActionPanel : function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
        component.set("v.confirmDelete", false);
        
    },
    confirmDelete : function(component, event, helper) {
        var target = event.target;
        var rowIndex = target.getAttribute("name");
        console.log('rowIndex--->'+rowIndex);
        component.set("v.userId",rowIndex);
        component.set("v.confirmDelete", true);
        
    }
})