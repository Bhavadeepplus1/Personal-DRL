({
    doInit : function(component, event, helper) {
       
       
	
   	
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
    
})