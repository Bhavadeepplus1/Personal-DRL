({
 doInit : function(component, event, helper) {
        
        var id = component.get("v.recordId");
     component.set("v.recId",id);
     console.log('recId====='+component.get("v.recId"));
 }
})