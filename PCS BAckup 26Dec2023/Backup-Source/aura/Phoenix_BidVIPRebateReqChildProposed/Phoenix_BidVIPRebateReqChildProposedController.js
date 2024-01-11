({    
    doInit: function(component, event, helper) {
        console.log('------+component.get("v.type)-'+component.get("v.type"));
        console.log('----frequencyEdit-'+component.get("v.inputDiscRebate"));
    },
    
    inlineEditDVF: function(component,event,helper){  
        if(component.get("v.type")=='Currency'){
            component.set("v.DVFEditMode", true);
            setTimeout(function(){
                component.find("inputDVFId").focus();
                console.log('-------child');
            }, 100);   
            component.set("v.showSaveCancelBtn1", true);
        }
        else{
            component.set("v.DVFEditMode", false);  
        } 
    },
    
    closeDVFBox :  function (component, event, helper) {
        component.set("v.DVFEditMode", false);
    },
    
    inlineEditDVT : function(component,event,helper){  
        if(component.get("v.type")=='Currency'){
            component.set("v.DVTEditMode", true);
            setTimeout(function(){
                component.find("inputDVTId").focus();
            }, 100);    
        }
        else{
            component.set("v.DVFEditMode", false);  
        } 
    },
    
    closeDVTBox :  function (component, event, helper) {
        component.set("v.DVTEditMode", false);
    },
    
    inlineEditUVF : function(component,event,helper){ 
        if(component.get("v.type")=='Quantity'){
            component.set("v.UVFEditMode", true);
            setTimeout(function(){
                component.find("inputUVFId").focus();
            }, 100);  
            component.set("v.showSaveCancelBtn1", true);
            
        }
        else{
            component.set("v.UVFEditMode", false);  
        } 
    },
    
    closeUVFBox :  function (component, event, helper) {
        component.set("v.UVFEditMode", false);
    },
    
    inlineEditUVT : function(component,event,helper){  
        if(component.get("v.type")=='Quantity'){
            component.set("v.UVTEditMode", true);
            setTimeout(function(){
                component.find("inputUVTId").focus();
            }, 100);
        }
        else{
            component.set("v.UVTEditMode", false);
        } 
    },
    
    closeUVTBox :  function (component, event, helper) {
        component.set("v.UVTEditMode", false);
    },
    
    inlineEditDR : function(component,event,helper){  
        component.set("v.DREditMode", true);
        setTimeout(function(){
            component.find("inputDRId").focus();
        }, 100);
        component.set("v.showSaveCancelBtn1", true);
        
    },
    
    closeDRBox :  function (component, event, helper) {
        component.set("v.DREditMode", false);
    },
    
    inlineEditRem : function(component,event,helper){  
        component.set("v.RemEditMode", true);
        setTimeout(function(){
            component.find("inputRemId").focus();
        }, 100);
        component.set("v.showSaveCancelBtn1", true);
        
    },
    
    closeRemBox :  function (component, event, helper) {
        component.set("v.RemEditMode", false);
    },
    
    deleteLineItem : function(component, event, helper){
        var target = event.target;
        var rowIndex = target.getAttribute("name");
        console.log('---------delete--1----2------');
        console.log('selectedRec'+rowIndex);
        var eventDelete = component.getEvent("lightningEvent");
        // var eventDelete1 = component.getEvent("lightningEvent1");
        console.log('---------delete--1----3------');
        eventDelete.setParam("message",rowIndex);
        eventDelete.setParam("fromWhichCmp",component.get("v.fromWhichCmp"));
        eventDelete.fire();
    },
    
    closeModel :  function (component, event, helper) {
        component.set('v.typeChanged',false);
        component.set('v.typeChangedPopup',false);
    },
})