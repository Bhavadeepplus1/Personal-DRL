({
    doInit: function(component, event, helper) {
       
    },
     inlineEditPIP: function(component,event,helper){  
        component.set("v.PIPEditMode", true);
        setTimeout(function(){
            component.find("inputPIPId").focus();
        }, 100);
       component.set("v.showSaveCancelBtn",true);   
    },
    closePIPBox :  function (component, event, helper) {
        component.set("v.PIPEditMode", false);
          
    },
     inlineEditIDN: function(component,event,helper){  
        component.set("v.IDNEditMode", true);
        setTimeout(function(){
            component.find("inputIDNId").focus();
        }, 100);
          component.set("v.showSaveCancelBtn",true);  
    },
    closeIDNBox :  function (component, event, helper) {
        component.set("v.IDNEditMode", false);
         
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
    }
})