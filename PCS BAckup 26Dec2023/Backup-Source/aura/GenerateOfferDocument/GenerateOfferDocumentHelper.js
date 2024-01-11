({
    
    generateOffer: function(component, event){
        var action = component.get("c.generateDocument");
        action.setParams({ 
            "bidId": component.get("v.recordId"), 
            "templateName": component.get("v.selectedTemplate"), 
            "offerDocumentName": component.get("v.defaultOfferName"), 
            "productFamily": component.get("v.selectedProductFamily"),
            "relatedTo": component.get("v.relatedTo"),
            "customerId": component.get("v.selectedAccount")
        });
        action.setCallback(this, function(response) 
                           {
                               if(response.getState()=="SUCCESS"){
                                   var LineItemtable = component.get("v.tableClass");
                                   console.log('tableClass-->'+JSON.stringify(LineItemtable));
                                   $A.util.addClass(LineItemtable, "contractTable");
                                   
                                   var toastEvent = $A.get("e.force:showToast");
                                   toastEvent.setParams({
                                       title : 'Success',
                                       message:'Successfully generated the offer document',
                                       duration:' 5000',
                                       key: 'info_alt',
                                       type: 'success'
                                   });
                                   component.set("v.isOpen", false);
                                   toastEvent.fire(); 
                                   $A.get("e.force:closeQuickAction").fire();
                                   
                               }
                               else {
                                   var LineItemtable = component.get("v.tableClass");
                                   console.log('tableClass-->'+JSON.stringify(LineItemtable));
                                   $A.util.addClass(LineItemtable, "contractTable");
                                   console.log("Error "+JSON.stringify(response.getError()));
                                   var toastEvent = $A.get("e.force:showToast");
                                   toastEvent.setParams({
                                       title : 'Error',
                                       message:'Something went wrong, please try again',
                                       duration:' 5000',
                                       key: 'info_alt',
                                       type: 'error'
                                   });
                                   component.set("v.isOpen", false);
                                   toastEvent.fire();
                               }
                           });
        
        $A.enqueueAction(action);
    },
    toastMessage: function(component, event){
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Error',
            message:'Please fill all the fields',
            duration:' 5000',
            key: 'info_alt',
            type: 'error'
        });
        toastEvent.fire(); 
    }
})