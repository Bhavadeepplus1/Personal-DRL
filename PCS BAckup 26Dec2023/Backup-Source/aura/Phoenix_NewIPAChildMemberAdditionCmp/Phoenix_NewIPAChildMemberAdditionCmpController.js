({
    doInit : function(component, event, helper) {
        
        var ipaAccountId=component.get("v.bidRecord");
        console.log('ipaAccountId'+JSON.stringify(ipaAccountId));
        //component.set("v.ipaAccountId",ipaAccountId.Phoenix_Customer__c);  
        
        
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
        var compId=event.getParam("cmpId");
        console.log('Old Id: ' + event.getParam("oldValue"));
        console.log('New Id: ' + event.getParam("newValue"));
        
        var accoundId=component.get("v.singleRec.Phoenix_Customer__c");
        var contactId=component.get("v.singleRec.Phoenix_Contact__c");
        if(compId=="accountLookup"){
            component.set("v.accountId",accoundId);  
        }
        console.log('accId'+component.get("v.accountId"));
        if(event.getParam("oldValue")==accoundId && compId=="accountLookup"){
            
            component.set("v.accountRecord",''); 
            component.set("v.singleRec.Phoenix_Street_Name__c",'');
            component.set("v.singleRec.Phoenix_State__c",'');
            component.set("v.singleRec.Phoenix_City__c",'');
            component.set("v.singleRec.Phoenix_Zip__c",'');
            component.set("v.singleRec.Phoenix_DEA__c",'');
            component.set("v.singleRec.Phoenix_HIN__c",'');
            component.set("v.singleRec.Phoenix_GLN__c",'');
            component.set("v.singleRec.Phoenix_New_GPO__c",'');
            component.set("v.singleRec.Phoenix_Wholesaler__c",'');
            component.set("v.singleRec.Phoenix_Wholesaler_Location__c",'');
            component.set("v.childList", []);
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
                        var getProductsAction = component.get("c.getIPAmemberInfo");
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
                                component.set("v.contactRecord",resposeData.contRecord);
                                component.set("v.singleRec.Phoenix_DEA__c",resposeData.accRecord.DEA__c);
                                component.set("v.singleRec.Phoenix_HIN__c",resposeData.accRecord.Phoenix_HIN__c);
                                component.set("v.singleRec.Phoenix_GLN__c",resposeData.accRecord.Phoenix_GLN__c);
                                component.set("v.singleRec.Phoenix_New_GPO__c",resposeData.accRecord.GPO1__c);
                                component.set("v.singleRec.Phoenix_Wholesaler__c",resposeData.accRecord.Wholesaler1__c);
                                component.set("v.singleRec.Phoenix_Wholesaler_Location__c",resposeData.accRecord.Wholesaler_DC_1__c);
                                console.log('wholesalesr location-->'+resposeData.accRecord.Wholesaler_DC_1__c);
                                console.log('wholesalesr location1-->'+component.get("v.singleRec.Phoenix_Wholesaler_Location__c"));
                                if(resposeData.accRecord.Wholesaler1__c != undefined && resposeData.accRecord.Wholesaler1__c != '--- None ---'){
                                    //get child picklist value
                                    var controllerValue = resposeData.accRecord.Wholesaler1__c;
                                    var wholeSalerLocation = resposeData.accRecord.Wholesaler_DC_1__c;
                                    var pickListMap = component.get("v.pickListMap");
                                    var childValues = pickListMap[controllerValue];
                                    var childValueList = [];
                                    if(wholeSalerLocation != undefined){
                                        childValueList.push(wholeSalerLocation);
                                    }else{
                                        childValueList.push('--- None ---');
                                    }
                                    for (var i = 0; i < childValues.length; i++) {
                                        childValueList.push(childValues[i]);
                                    }
                                    // set the child list
                                    component.set("v.childList", childValueList);
                                    console.log('childValueList--->'+childValueList)
                                    if(childValues.length > 0){
                                        component.set("v.disabledChildField" , false);  
                                    }else{
                                        component.set("v.disabledChildField" , true); 
                                    }
                                }
                                
                                
                                
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