({
	  doInit: function(component, event, helper){
           component.set("v.isSpinnerLoad", false);
          helper.getUser(component, event, helper);
      },
     handleChange : function(cmp, event, helper) {
        console.log('Lookup component Id: ' + event.getParam("cmpId"));
        var newId = cmp.get("v.selectedUserId");
         console.log('newId: ' + newId);
        cmp.set("v.selectedUserId", newId);
        },
      showHideSalesUnits:function(component, event, helper){
        console.log('showHideSalesUnits==>'+component.get("v.showHideSalesUnits"))
        component.set("v.showHideSalesUnits",component.get("v.showHideSalesUnits")?false:true);
          helper.getKeys(component, event, helper)
         
    },
      collectData: function(component, event, helper){
         // helper.getAVG_Total(component, event, helper);
        helper.getFullData(component, event, helper);
    },
})