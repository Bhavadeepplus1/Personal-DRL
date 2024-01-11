({
    init: function (component, event, helper) {
        //component.set("v.prodItem.options", component.get("v.options"));
        var noofRecc=component.get("v.responseLen");
        component.set("v.isRenderCompleted",false);
        //console.log('getPicklistValueschild :: '+component.get("v.getPicklistValues"));
        var selectedPositions = component.get("v.prodItem.selectedOptions");
        var selectedPositionsList = [];
        var selectedPositionsCount = 0;
        if(selectedPositions != null && selectedPositions !=  undefined){
            /*if(selectedPositions.includes('All')){
                selectedPositions.splice(selectedPositions.indexOf('All'), 1);
            }*/
            for(var i=0; i<selectedPositions.length; i++){
                if(selectedPositions[i] != 'All'){
                    selectedPositionsCount += 1;
                    selectedPositionsList.push(selectedPositions[i]);
                }
            }
            component.set("v.selectedPositionsString", selectedPositionsList.toString());
            component.set('v.searchString', selectedPositionsCount + ' Position(s) selected');   
        }
        helper.doInitStartHelper(component);
        /*console.log('noofRecc.length'+noofRecc);
        if(noofRecc.length > 1)
            {
                component.set("v.OverrideUnitsEditMode1",true);
                console.log('v.OverrideUnitsEditMode1');
            }
        else{
            component.set("v.OverrideUnitsEditMode1",false);
        }
        */
    },
    
    handleSaveEdition: function (component, event, helper) {
        var draftValues = event.getParam('columns');
        var ii=component.find("dtTable").get("v.value");
        console.log(draftValues);
        var action = component.get("c.updateAccount");
        action.setParams({"acc" : draftValues});
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            
        });
        $A.enqueueAction(action);
    },
    showSelectedproducts: function (component, event, helper) {
        component.set("v.isModalOpen", true);
    },
    closePopup: function (component, event, helper) {
        component.set("v.isModalOpen", false);
    },
    inlineEditOverrideUnits : function(component,event,helper){  
        component.set("v.OverrideUnitsEditMode", true);
        setTimeout(function(){
            component.find("OverrideUnits").focus();
        }, 100);
    },
    closeOverrideUnits: function (component, event, helper) {       
        component.set("v.OverrideUnitsEditMode", false);        
    },
    onCISUChange : function(component,event,helper){
        var awardedQuantity=component.get("v.prodItem.Phoenix_Awarded_Quantity__c");
        var nameofEditfield = event.getSource().get('v.name');
        var val = event.getSource().get('v.value');
        var currentValue, fieldName;
        var responseList=component.get("v.responseList");
        helper.getCalculations(component,event,helper,responseList);
    },
    onRender: function(component,event,helper){
        console.log("after render remQtyToAward--->"+component.get("v.remQtyToAward"));
        var singleRec = component.get("v.prodItem");
        if(!component.get("v.isRenderCompleted")){
            component.set("v.isRenderCompleted",true);
            if(component.get("v.sNo") == "1" && singleRec.Phoenix_Awarded_Quantity__c == null){
                singleRec.Phoenix_Awarded_Quantity__c = component.get("v.remQtyToAward"); 
            }
            else if(singleRec.Phoenix_Awarded_Quantity__c == null){
                singleRec.Phoenix_Awarded_Quantity__c = 0; 
                
            }
            component.set("v.prodItem",singleRec);
                        component.set('v.remQtyToAward',0);

        }   
        
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
        var selectedOptions = component.get("v.prodItem.selectedOptions");
        component.set("v.values", selectedOptions);
        var disabled = component.get("v.disabled");
        if(!disabled) {
            component.set("v.message", '');
            component.set('v.searchString', '');
            var options = component.get("v.options");
            options.forEach( function(element,index) {
                if(selectedOptions == null || selectedOptions == undefined)
                	element.selected = false;
                else {
                    if(selectedOptions.includes(element.value)){
                        element.selected = true;
                    } else{
                        element.selected = false;
                    }
                    element.isVisible = true;
                }   
            });
            component.set("v.options", options);
            if(!$A.util.isEmpty(component.get('v.options'))) {
                $A.util.addClass(component.find('resultsDiv'),'slds-is-open');
            } 
        }
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