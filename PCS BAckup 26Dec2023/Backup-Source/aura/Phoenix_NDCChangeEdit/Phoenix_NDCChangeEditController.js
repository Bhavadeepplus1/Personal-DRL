({
    doInit : function(component, event, helper) {
        let pageReference = component.get("v.pageReference");
        let recordId = pageReference.state.c__recordId;
        if (recordId != null && recordId != undefined && recordId != '') {
            console.log('If');
            component.set("v.recordId", recordId);
            var action = component.get("c.getActiveBidProductFamilies");
            var opts = [];
            component.set("v.loaded", true);
            action.setCallback(this, function(response) 
                               {
                                   if(response.getState()=="SUCCESS"){
                                       component.set("v.activeBidProductFamilies", response.getReturnValue());
                                       helper.loadInstance(component, helper);
                                   }
                               });
            $A.enqueueAction(action);
        } else{
            console.log('Else');
            component.set("v.recordId", null);
            var action = component.get("c.getActiveBidProductFamilies");
            var opts = [];
            action.setCallback(this, function(response) 
                               {
                                   if(response.getState()=="SUCCESS"){
                                       component.set("v.activeBidProductFamilies", response.getReturnValue());
                                       var response = response.getReturnValue();
                                       console.log('Response: '+JSON.stringify(response));
                                       for(var i=0;i< response.length;i++){
                                           var familyKey = Object.keys(response[i]);
                                           opts.push({"class": "optionClass", label: response[i][familyKey], value: familyKey.toString()});
                                       }
                                       /*for(var i=0;i< response.getReturnValue().length;i++){
                                           opts.push({"class": "optionClass", label: response.getReturnValue()[i], value: response.getReturnValue()[i]});
                                       }*/
                                       console.log('opts: '+JSON.stringify(opts));
                                       component.set("v.currentFamilyOptions", opts);
                                       component.set("v.proposedFamilyOptions", opts);
                                   }
                               });
            $A.enqueueAction(action);
        }
    },
    
    reInit : function(component, event, helper) {
        $A.get('e.force:refreshView').fire();
    },
    acceptNote:function(component) {
        component.set("v.isNoteAccept", false);
        component.set("v.disableButton", true);
    },
    
    displayNDCLineItemScreen: function(component, event, helper) {
      	var isProductsSelected = event.getParam("isProductsSelected");
        if(isProductsSelected == true){
         	component.set("v.isProductFamilyNotSelected", false);   
        } else {
            component.set("v.isProductFamilyNotSelected", true);
        }
    },
    
    handleSuccess : function(component, event, helper) {
        var recordId = event.getParams().response.id;
        var ProposedProductFamily = component.get("v.ProposedProductFamily");
        component.set("v.recordIdNew", recordId);
        component.set("v.recordId", recordId);
        

        component.find("navService").navigate({
            type: "standard__component",
            attributes: {
                componentName: "c__Phoenix_NDCChangeEdit" },
            state: {
                c__recordId: recordId
               
            }
        }, true); // replace = true
        component.set("v.ProposedProductFamily", ProposedProductFamily);
        component.set("v.showChangeProducts", true);
        component.set("v.disabled", true);
        component.set("v.disableSave", true);
        component.set("v.disableEdit", false);
        component.set('v.isNoteAccept', true);
        component.set("v.disableAddRow", false);
    },
    
    handleSelectedCurrentProductFamily: function (component, event) {
        // Get the string of the "value" attribute on the selected option
        var selectedOptionValue = event.getParam("value");
        var selectedOptionName = event.getParam("label");
        var currentFamilyOptions = component.get("v.currentFamilyOptions");
        for(var i=0; i<currentFamilyOptions.length; i++){
            if(currentFamilyOptions[i].value == selectedOptionValue){
                component.set("v.CurrentProductFamily", currentFamilyOptions[i].value);
                component.set("v.ProposedProductFamily", currentFamilyOptions[i].value);   
                component.set("v.CurrentProductFamilyName", currentFamilyOptions[i].label);
                component.set("v.ProposedProductFamilyName", currentFamilyOptions[i].label);
                break;
            }
        }
        console.log('Current: '+component.get("v.CurrentProductFamilyName"));
        console.log('Proposed: '+component.get("v.ProposedProductFamilyName"));
        /*component.set("v.CurrentProductFamily", selectedOptionValue);
        component.set("v.ProposedProductFamily", selectedOptionValue);*/
        /*var activeBidProductFamilies = component.get("v.activeBidProductFamilies");
        var proposedProductFamilies = [];
        for(var i=0;i< activeBidProductFamilies.length;i++){
            if(activeBidProductFamilies[i] != selectedOptionValue) {
                proposedProductFamilies.push({"class": "optionClass", label: activeBidProductFamilies[i], value: activeBidProductFamilies[i]});
            }
        }
        component.set("v.proposedFamilyOptions", proposedProductFamilies);*/
        component.set("v.disabled", false);
    },
    
    handleSelectedProposedProductFamily: function (component, event) {
        // Get the string of the "value" attribute on the selected option
        var selectedOptionValue = event.getParam("value");
        var selectedOptionName = event.getParam("name");
        component.set("v.ProposedProductFamily", selectedOptionValue);
        var proposedFamilyOptions = component.get("v.proposedFamilyOptions");
        for(var i=0; i<proposedFamilyOptions.length; i++){
            if(proposedFamilyOptions[i].value == selectedOptionValue){
                component.set("v.ProposedProductFamily", proposedFamilyOptions[i].value);
                component.set("v.ProposedProductFamilyName", proposedFamilyOptions[i].label);
                break;
            }
        }
    },
    
    navigateToNDCChangeProducts: function(component, event, helper) {
        
        var Name = component.get("v.Name");
        var Date = component.get("v.Date");
        var Description = component.get("v.Description");
        var CurrentProductFamily = component.get("v.CurrentProductFamily");
        var ProposedProductFamily = component.get("v.ProposedProductFamily");
        if( Name == "" || Name == "undefined" 
           || Date == "" || Date == "undefined" 
           || Description == "" || Description == "undefined"
           || CurrentProductFamily == "" || CurrentProductFamily == "undefined" 
           || ProposedProductFamily == "" || ProposedProductFamily == "undefined") {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title : 'Error',
                message:'Please fill all the fields',
                duration:' 5000',
                key: 'info_alt',
                type: 'error'
            });
            toastEvent.fire();
        } else {
            component.set("v.showChangeProducts", false);
            component.find("recordEditForm").submit();
        } 
    },
    
    disableHeaderFields: function(component, event, helper){
        var val = event.getParam("productInstanceLength");
        if(val == 0){
            //component.set('v.isNoteAccept', false);
            component.set('v.disabled', false);
            //component.set("v.disableSave", true);
            component.set("v.disableEdit", false);
            component.set("v.disabled", true);
        } else{
            component.set("v.disableSave", true);
            component.set("v.disableEdit", true);
            component.set('v.isNoteAccept', true);
            component.set('v.disabled', true);
        }
        
    },
    
    enableEdit: function(component, event, helper){
      	component.set('v.isNoteAccept', false);  
        component.set("v.disableSave", false);
        component.set("v.disabled", false);
        component.set("v.showChangeProducts", false);
    },
    
    goToNDCChangePage: function(component, event, helper) {
        var navService = component.find("navService");
        var pageReference = {
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Phoenix_NDC_Change__c',
                actionName: 'list'
            },
            state: {
                filterName: "Recent"
            }
        };
        component.set("v.pageReference", pageReference);
        // Set the URL on the link or use the default if there's an error
        var defaultUrl = "#";
        navService.generateUrl(pageReference)
            .then($A.getCallback(function(url) {
                component.set("v.url", url ? url : defaultUrl);
            }), $A.getCallback(function(error) {
                component.set("v.url", defaultUrl);
            }));
        $A.get('e.force:refreshView').fire(); 
        event.preventDefault();
        navService.navigate(pageReference);
    }
            
})