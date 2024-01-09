({
    doInit : function( component, event, helper ) {
         if(component.get("v.isRegion")){
             console.log('isRegion==>'+component.get("v.isRegion"))
         helper.getRegion(component);
       }
       if(component.get("v.isCategory")){
         helper.getcategoryData(component);
       }
        if(component.get("v.isHospital")){
            helper.gethospitalName(component);
        }
         if(component.get("v.isproductFamily")){
            helper.getProductNames(component);
        }
         if(component.get("v.isproductDescription")){
              helper.getProducts(component);
         }
         if(component.get("v.ismemberState")){
              helper.getmemberstate(component);
         }
         if(component.get("v.ismemberCity")){
              helper.getmembericty(component);
         }
         if(component.get("v.isSubmitterName")){
              helper.getsubmitters(component);
         }
        
       helper.doInitStartHelper(component);
    },
     
    //search option in picklist
    filterOptions : function( component, event, helper ) {
        if( !$A.util.isEmpty(component.get('v.searchString')) ) {
            helper.filterOptionsDataHelper(component);
        } else {
            $A.util.removeClass(component.find('resultsDiv'),'slds-is-open');
        }
    },
     
    // option selected
    selectItem : function( component, event, helper ) {
        if(!$A.util.isEmpty(event.currentTarget.id)) {
            helper.selectOptionHelper(component, event);
        }
    },

    passValue : function(component, event, helper) {
        var passValueEvent = component.getEvent("passValueEvent");
        passValueEvent.setParams({"value" : component.get("v.childValue")});
        passValueEvent.fire();
    }, 
    showOptions : function( component, event, helper ) {
        var disabled = component.get("v.disabled");
        if(!disabled) {
            component.set("v.message", '');
            component.set('v.searchString', '');
            var options = component.get("v.options");
            options.forEach( function(element,index) {
                element.isVisible = true;
            });
            component.set("v.options", options);
            if(!$A.util.isEmpty(component.get('v.options'))) {
                $A.util.addClass(component.find('resultsDiv'),'slds-is-open');
            } 
        }
        //added by satya//
        if(component.get("v.ismemberState") || component.get("v.ismemberCity") || component.get("v.isSubmitterName")){
        var parentComponent = component.get("v.parent");                         
		parentComponent.greetingMethod2("openModel")
        }
        //end by satya//
    },
     
    // To remove the selected item.
    closePill : function( component, event, helper ){
        helper.removeOptionPillHelper(component, event);
    },
     
    // To close the dropdown if clicked outside the dropdown.
    handleBlur : function( component, event, helper ){
        helper.handleBlurHelper(component, event);
    },
})