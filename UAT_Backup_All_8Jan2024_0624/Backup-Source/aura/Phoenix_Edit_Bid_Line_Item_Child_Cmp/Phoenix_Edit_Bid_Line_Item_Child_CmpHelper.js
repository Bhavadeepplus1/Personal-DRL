({
    fetchPickListVal: function(component, fieldName, picklistOptsAttributeName) {
        var action = component.get("c.getselectOptions");
        action.setParams({
            "objObject": component.get("v.objInfoForPicklistValues"),
            "fld": fieldName
        });
        var opts = [];
        $A.enqueueAction(action);
    }, 
    getCalculations : function(component,event,helper,currentValue,fieldName){  
        // component.set("v.isSpinner",true);
        var LineItem=component.get("v.singleRec");
        var LineItemId=LineItem.Id;
        var action = component.get("c.getCalcs");
        action.setParams({
            LineItem: LineItem,
            LineItemId: LineItemId,
            currentValue: currentValue,
            fieldLabel : fieldName
        });
        action.setCallback(this, function(response) 
                           {
                               if(response.getState()==='SUCCESS'){
                                   console.log('calc response--'+JSON.stringify(response.getReturnValue()));
                                   component.set("v.singleRec",response.getReturnValue());
                                   var event = component.getEvent("calcEvent");                                 
                                   event.fire();
                                   //component.set("v.isSpinner",false);
                               } else{
                                   //component.set("v.isSpinner",false);
                               }
                               
                           });      
        $A.enqueueAction(action);
    }
})