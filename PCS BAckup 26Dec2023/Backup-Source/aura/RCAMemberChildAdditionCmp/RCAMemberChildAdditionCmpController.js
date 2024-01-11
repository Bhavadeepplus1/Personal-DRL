({
     doInit : function(component, event, helper) {
       
        var action = component.get("c.getDependentPicklist");
        action.setParams({
           
        });
        
        action.setCallback(this, function(response){
         	var status = response.getState();
            if(status === "SUCCESS"){
                var pickListResponse = response.getReturnValue();
                
                //save response 
                component.set("v.pickListMap",pickListResponse.pickListMap);
                component.set("v.parentFieldLabel",pickListResponse.parentFieldLabel);
                component.set("v.childFieldLabel",pickListResponse.childFieldLabel);
                 component.set("v.GPOvalues",pickListResponse.GPOvalues);
                  component.set("v.StateValues",pickListResponse.StateValues);
                // create a empty array for store parent picklist values 
                var parentkeys = []; // for store all map keys 
                var parentField = []; // for store parent picklist value to set on lightning:select. 
                
                // Iterate over map and store the key
                for (var pickKey in pickListResponse.pickListMap) {
                    parentkeys.push(pickKey);
                }
                
                //set the parent field value for lightning:select
                if (parentkeys != undefined && parentkeys.length > 0) {
                    parentField.push('--- None ---');
                }
                
                for (var i = 0; i < parentkeys.length; i++) {
                    parentField.push(parentkeys[i]);
                }  
                // set the parent picklist
                component.set("v.parentList", parentField);
                
            }
        });
        
        $A.enqueueAction(action);
	
   	
    },
   
    deleteItem: function(component, event, helper) {
        var target = event.target;
        var rowIndex = target.getAttribute("name");
        
        console.log('selectedRec'+rowIndex); 
        var eventDelete = component.getEvent("lightningEvent");
        eventDelete.setParam("message",rowIndex);
        eventDelete.fire();
    },
    handleChange : function(component, event, helper) {
        console.log('Lookup component Id: ' + event.getParam("cmpId"));
        console.log('Old Id: ' + event.getParam("oldValue"));
         var compId=event.getParam("cmpId");
        var accoundId=component.get("v.singleRec.Phoenix_Customer__c");
        var contactId=component.get("v.singleRec.Phoenix_Contact__c");
        console.log('accountId--'+accoundId);
        console.log('contactId--'+contactId);
        if(compId=="accountLookup"){
            component.set("v.accountId",accoundId);    
        }
        if(event.getParam("oldValue")==accoundId && compId=="accountLookup"){
       
          component.set("v.accountRecord",'');
            component.set("v.singleRec.Phoenix_Street_Name__c",'');
            component.set("v.singleRec.Phoenix_State__c",'');
            component.set("v.singleRec.Phoenix_City__c",'');
            component.set("v.singleRec.Phoenix_Zip__c",'');
          component.set("v.accountId",'');
          component.set("v.contactRecord",'');
        }
        else if(event.getParam("oldValue")==contactId && compId=="contactLookup"){
          component.set("v.contactRecord",'');   
        }
            else{
          if(compId=="accountLookup" || compId=="contactLookup"){
        if((accoundId!=null && accoundId!='' && accoundId!=undefined)||(contactId!=null && contactId!='' && contactId!=undefined)){
            component.set("v.showSpinner",true);
            var getProductsAction = component.get("c.getRCAmemberInfo");
            getProductsAction.setParams({"accountId":component.get("v.singleRec.Phoenix_Customer__c"), "contactId":component.get("v.singleRec.Phoenix_Contact__c")});
            
            
            
            getProductsAction.setCallback(this, function (response) {
                var actState = response.getState();
                console.log('actState'+actState);
                if (actState === 'SUCCESS') {
                    console.log('success');
                    component.set("v.showSpinner",false);
                    var resposeData = response.getReturnValue();
                   
                   
                    console.log('resposeData--------'+JSON.stringify(resposeData));
                    component.set("v.accountRecord",resposeData.accRecord);
                    component.set("v.singleRec.Phoenix_Street_Name__c",resposeData.accRecord.Street_Address_1__c);
                    component.set("v.singleRec.Phoenix_State__c",resposeData.accRecord.State__c);
                     component.set("v.singleRec.Phoenix_City__c",resposeData.accRecord.City__c);
                      component.set("v.singleRec.Phoenix_Zip__c",resposeData.accRecord.Zip__c);
                    //component.set("v.accountRecord",resposeData.accRecord);
                    
                    component.set("v.contactRecord",resposeData.contRecord);
                    
                   
                    
                    
                }
                else if (actState === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } 
                }
                
            });
            $A.enqueueAction(getProductsAction);
        }
          }
          }
    },
     parentFieldChange : function(component, event, helper) {
    	var controllerValue = component.find("parentField").get("v.value");// We can also use event.getSource().get("v.value")
        var pickListMap = component.get("v.pickListMap");

        if (controllerValue != '--- None ---') {
             //get child picklist value
            var childValues = pickListMap[controllerValue];
            var childValueList = [];
            childValueList.push('--- None ---');
            for (var i = 0; i < childValues.length; i++) {
                childValueList.push(childValues[i]);
            }
            // set the child list
            component.set("v.childList", childValueList);
            
            if(childValues.length > 0){
                component.set("v.disabledChildField" , false);  
            }else{
                component.set("v.disabledChildField" , true); 
            }
            
        } else {
            component.set("v.childList", ['--- None ---']);
            component.set("v.disabledChildField" , true);
        }
	},
      
     
})