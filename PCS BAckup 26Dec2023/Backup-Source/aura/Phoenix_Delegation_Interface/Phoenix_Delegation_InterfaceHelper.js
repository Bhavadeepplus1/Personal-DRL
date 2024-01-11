({
    saveRecord : function(component, event, helper){
        var action = component.get("c.updateUser");
        var userId = '';
        if(component.get("v.isLoggedInUsedHead")){
            userId = component.get("v.delegatorLkp");
        } else{
            userId = component.get("v.userLkp");
        }
        action.setParams({
            'startTime': component.get("v.startTime"),
            'endTime' : component.get("v.EndTime"),
            'userId': userId,
            'deleUserId':component.get("v.deleUserLkp")
            
        });  
        action.setCallback(this, function(response) 
                           {
                               if(response.getState()=="SUCCESS"){
                                   console.log('State is success');
                                   component.set("v.loadSpinner", false);  
                                   if(response.getReturnValue() == 'Success'){
                                       if(component.get("v.isLoggedInUsedHead")){
                                           helper.getData(component, event, helper, component.get("v.delegatorLkp"));
                                       } else{
                                           helper.getData(component, event, helper, component.get("v.userLkp"));
                                       }
                                       /*r action = component.get("c.getExistingDeleRecords");
                                       action.setCallback(this, function(response1) 
                                                          {
                                                              if(response1.getState()=="SUCCESS"){
                                                                  var deleUsersList = response1.getReturnValue().deleUsersList;
                                                                  component.set("v.excistingDeleList", deleUsersList);
                                                              }else{
                                                                  console.log("Exception Inside: "+JSON.stringify(response1.getError()));        
                                                              }
                                                          });
                                       $A.enqueueAction(action);*/
                                   }
                                   // window.location.reload();   
                                   else{
                                       var toastEvent = $A.get("e.force:showToast");
                                       toastEvent.setParams({
                                           title : 'Error!',
                                           message: response.getReturnValue(),
                                           duration:' 5000',
                                           key: 'info_alt',
                                           type: 'error'
                                       });
                                       toastEvent.fire();
                                   }
                                   
                               }else{
                                   console.log("Exception Inside: "+JSON.stringify(response.getError()));        
                               }
                           });
        $A.enqueueAction(action);
        component.set("v.startTime", null); 
        component.set("v.EndTime", null);
        component.set("v.changeTo", null);
        //component.find("userLookup").fireChanging();
        component.find("delegatedUserLookup").fireChanging();
    },
    getData: function(component, event, helper, userId){
        component.set("v.loadSpinner", true);
        var action = component.get("c.getExistingDeleRecords");
        action.setParams({
            'userId': userId
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
        component.set("v.loadSpinner", false);  
    },
    showErrorToast : function(component, event, message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Warning!',
            message: message,
            duration:' 5000',
            key: 'info_alt',
            type: 'error'
        });
        toastEvent.fire();
        component.set("v.loadSpinner", false);
    }
    
    
})