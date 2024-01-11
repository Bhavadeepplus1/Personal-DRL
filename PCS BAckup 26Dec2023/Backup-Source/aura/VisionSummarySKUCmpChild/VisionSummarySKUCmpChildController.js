({
    doInit : function(component, event, helper) {
        /*var relatedList = component.get("v.relatedList");
        for(var i=0; i<relatedList.length; i++){
            console.log('SCM Approval: '+JSON.stringify(relatedList[i]));
        }*/
	},
    expandFamily: function(component, event, helper){
        component.set("v.expandFamily", !component.get("v.expandFamily"));
    }
})