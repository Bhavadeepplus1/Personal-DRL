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
        var accoundId='';
          var customerLookupId='';
        if(compId=="accountLookup"){
            console.log('hi');
            accoundId=component.get("v.singleRec.rcItem.Phoenix_Customer__c");   
        }
        
         if(compId=="customerLookup"){
            console.log('hi');
            customerLookupId=component.get("v.singleRec.rcItem.Phoenix_Parent_IPA_Customer__c");   
        }
        
        
        console.log('accountId--'+accoundId);
          console.log('customerLookupId--'+customerLookupId);
        
        if(event.getParam("oldValue")==accoundId && compId=="accountLookup"){
              console.log(' IN accountId--');
            
            component.set("v.accountRecord",'');
          
        }
        else  if(event.getParam("oldValue")==customerLookupId && compId=="customerLookup"){
              console.log(' IN customerLookup--');
             component.set("v.accountRecord1",'');
            component.set("v.singleRec.rcItem.Phoenix_Street_Name__c",'');
            component.set("v.singleRec.rcItem.Phoenix_State__c",'');
            component.set("v.singleRec.rcItem.Phoenix_City__c",'');
            component.set("v.singleRec.rcItem.Phoenix_Zip__c",'');
              component.set("v.singleRec.rcItem.Phoenix_DEA__c",'');
            
        }
            
        
        else{
             console.log('IN else');
              console.log('IN else---'+(customerLookupId!=null && customerLookupId!='' && customerLookupId!=undefined &&compId=="customerLookup"));
            
            if((accoundId!=null && accoundId!='' && accoundId!=undefined &&compId=="accountLookup")||(customerLookupId!=null && customerLookupId!='' && customerLookupId!=undefined &&compId=="customerLookup")){
               
                 console.log('IN els122333444e');
                component.set("v.showSpinner",true);
                var getProductsAction = component.get("c.getRCAmemberInfo");
                getProductsAction.setParams({"accountId":component.get("v.singleRec.rcItem.Phoenix_Customer__c"),
                                             "customerLookupId":component.get("v.singleRec.rcItem.Phoenix_Parent_IPA_Customer__c"),
                                            });
                
                
                
                getProductsAction.setCallback(this, function (response) {
                    var actState = response.getState();
                    console.log('actState'+actState);
                    if (actState === 'SUCCESS') {
                        console.log('success');
                        component.set("v.showSpinner",false);
                        var resposeData = response.getReturnValue();
                        
                        
                        console.log('resposeData--------'+JSON.stringify(resposeData));
                          console.log('resposeData----accRecord1----'+JSON.stringify(resposeData.accRecord1));
                        component.set("v.accountRecord",resposeData.accRecord);
                         component.set("v.accountRecord1",resposeData.accRecord1);
                        component.set("v.singleRec.rcItem.Phoenix_Street_Name__c",resposeData.accRecord1.Street_Address_1__c);
                        component.set("v.singleRec.rcItem.Phoenix_State__c",resposeData.accRecord1.State__c);
                        component.set("v.singleRec.rcItem.Phoenix_City__c",resposeData.accRecord1.City__c);
                        component.set("v.singleRec.rcItem.Phoenix_Zip__c",resposeData.accRecord1.Zip__c);
                         component.set("v.singleRec.rcItem.Phoenix_DEA__c",resposeData.accRecord1.DEA__c);
                        
                        
                        
                        
                        
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