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
                // create a empty array for store parent picklist values 
                var parentkeys = []; // for store all map keys 
                var parentField = []; // for store parent picklist value to set on lightning:select. 
                
                // Iterate over map and store the key
                for (var pickKey in pickListResponse.pickListMap) {
                    parentkeys.push(pickKey);
                }
                
                //set the parent field value for lightning:select
                if (parentkeys != undefined && parentkeys.length > 0) {
                    parentField.push('-- None --');
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
     inlineEditGPO: function(component,event,helper){  
        component.set("v.GPOEditMode", true);
        setTimeout(function(){
            component.find("inputGPOId").focus();
        }, 100);
       component.set("v.showSaveCancelBtn",true);   
    },
    closeGPOBox :  function (component, event, helper) {
        component.set("v.GPOEditMode", false);
          
    },
     inlineEditWholesaler: function(component,event,helper){  
        
        component.set("v.WholesalerEditMode", true);
        setTimeout(function(){
            component.find("inputWholesalerId").focus();
        }, 100);
          component.set("v.showSaveCancelBtn",true);  
    },
    closeWholesalerBox :  function (component, event, helper) {
        component.set("v.WholesalerEditMode", false);
        component.set("v.LocationEditMode", true);
        setTimeout(function(){
            component.find("inputLocationId").focus();
        }, 100);
          component.set("v.showSaveCancelBtn",true); 
         
    },
    inlineEditLocation:function(component,event,helper){  
        component.set("v.LocationEditMode", true);
        setTimeout(function(){
            component.find("inputLocationId").focus();
        }, 100);
          component.set("v.showSaveCancelBtn",true);  
    },
     closeLocationBox :  function (component, event, helper) {
        component.set("v.LocationEditMode", false);
         
    },
    
     inlineEditDEA :function(component,event,helper){  
        component.set("v.DEAEditMode", true);
        setTimeout(function(){
            component.find("inputDEAId").focus();
        }, 100);
          component.set("v.showSaveCancelBtn",true);  
    },
     closeDEABox :  function (component, event, helper) {
        component.set("v.DEAEditMode", false);
         
    },
   
	deleteLineItem : function(component, event, helper){
        var target = event.target;
        var rowIndex = target.getAttribute("name");
        console.log('rowIndex--->'+rowIndex);
        var action = component.get("c.deleteLineItems");
        action.setParams({
            'LineItemId' : rowIndex
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('state--->'+state);
        });
        $A.enqueueAction(action);
        var event = component.getEvent("lightningEvent");
        event.setParam("message", "the message to send" );
        event.fire();
    },
     parentFieldChange : function(component, event, helper) {
    	var controllerValue = component.find("inputWholesalerId").get("v.value");// We can also use event.getSource().get("v.value")
        var pickListMap = component.get("v.pickListMap");

        if (controllerValue != '-- None --') {
             //get child picklist value
            var childValues = pickListMap[controllerValue];
            var childValueList = [];
            childValueList.push('-- None --');
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
            component.set("v.childList", ['-- None --']);
            component.set("v.disabledChildField" , true);
        }
	},
})