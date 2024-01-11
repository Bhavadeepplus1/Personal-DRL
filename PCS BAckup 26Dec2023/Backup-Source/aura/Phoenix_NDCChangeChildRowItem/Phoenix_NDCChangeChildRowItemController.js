({
    doInit: function(component, event, helper) {
        var productInstance = component.get("v.productInstance");
		component.set("v.selectedCurrentProduct", productInstance.Phoenix_Current_Product__c);
        component.set("v.selectedProposedProduct", productInstance.Phoenix_Proposed_Product__c);
        console.log(component.get("v.selectedCurrentProduct"));
        var selectedProducts = component.get("v.selectedProducts");
        console.log('Product Instance:: '+JSON.stringify(productInstance));
        console.log('Selected Products:: '+selectedProducts);
        helper.getProducts(component, event);
        if(productInstance.Phoenix_Current_Product__c == '' || productInstance.Phoenix_Current_Product__c == undefined || productInstance.Phoenix_Current_Product__c == ''){
            component.set("v.disableProposedProduct", true);
        } else {
            component.set("v.disableProposedProduct", false);
        }
    },
    
    AddNewRow : function(component, event, helper){
        // fire the AddNewRowEvt Lightning Event 
        component.getEvent("AddRowEvt").setParams({"indexVar" : component.get("v.rowIndex") }).fire();            
    },
    
    removeRow : function(component, event, helper){
        console.log('Product Instance::Remove '+JSON.stringify(component.get("v.productInstance")));
        // fire the DeleteRowEvt Lightning Event and pass the deleted Row Index to Event parameter/attribute
        var productInstance = component.get("v.productInstance");
        if(productInstance.Id){
            component.set("v.isModalOpen", true);   
        } else
            component.getEvent("DeleteRowEvt").setParams({"indexVar" : component.get("v.rowIndex") }).fire();
    }, 
    
    closeModal: function(component, event){
        component.set("v.isModalOpen", false);
    },
    
    deleteProduct: function(component, event){
    	component.set("v.isModalOpen", false);
        component.getEvent("DeleteRowEvt").setParams({"indexVar" : component.get("v.rowIndex") }).fire();
    },
    
    handleCurrentProductSelect: function(component, event, helper) {
        // Get the string of the "value" attribute on the selected option
        var selectedOptionValue = event.getParam("value");
        var selectedOptionName = event.getParam("name");
        var action = component.get("c.getProposedProductInfo");
        action.setParams({
            productId: selectedOptionValue
        });
        action.setCallback(this, function(response) 
                           {
                               if(response.getState()=="SUCCESS"){
                                   var data = response.getReturnValue(); 
                                   var productInstance = component.get("v.productInstance");
                                   for(var i=0; i<data.length; i++) {
                                       productInstance.Phoenix_NDC_Change_Name__c = component.get("v.recordIdNew");
                                       productInstance.Phoenix_Current_Product__c = data[i].Id;
                                       productInstance.Phoenix_Current_Product_Name__c = data[i].Name;
                                       productInstance.Phoenix_Current_NDC__c = data[i].Phoenix_NDC_11_Dashes__c;
                                       productInstance.Phoenix_Current_SAP_Number__c = data[i].ProductCode;
                                       productInstance.Phoenix_Current_Pack_Size__c = data[i].Phoenix_Pkg_Size__c;
                                       productInstance.Phoenix_Proposed_Product__c = '';
                                       productInstance.Phoenix_Proposed_Product_Name__c = '';
                                       productInstance.Phoenix_Proposed_NDC__c = '';
                                       productInstance.Phoenix_Proposed_SAP_Number__c = '';
                                       productInstance.Phoenix_Proposed_Pack_Size__c = ''; 
                                       component.set("v.selectedProposedProduct", '');
                                       component.set("v.productInstance", productInstance);
                                       component.set("v.disableProposedProduct", false);
                                   }           
                               }
                           });
        $A.enqueueAction(action);
    },
    
    handleProposedProductSelect: function(component, event, helper) {
        // Get the string of the "value" attribute on the selected option
        var selectedOptionValue = event.getParam("value");
        var selectedOptionName = event.getParam("name");
        var action = component.get("c.getProposedProductInfo");
        action.setParams({
            productId: selectedOptionValue
        });
        action.setCallback(this, function(response) 
                           {
                               if(response.getState()=="SUCCESS"){
                                   var data = response.getReturnValue(); 
                                   var productInstance = component.get("v.productInstance");
                                   for(var i=0; i<data.length; i++) {
                                       if(data[i].Phoenix_Pkg_Size__c != productInstance.Phoenix_Current_Pack_Size__c) {
                                           productInstance.Phoenix_Proposed_Product__c = '';
                                           productInstance.Phoenix_Proposed_Product_Name__c = '';
                                           productInstance.Phoenix_Proposed_NDC__c = '';
                                           productInstance.Phoenix_Proposed_SAP_Number__c = '';
                                           productInstance.Phoenix_Proposed_Pack_Size__c = '';  
                                           component.set("v.productInstance", productInstance); 
                                           var toastEvent = $A.get("e.force:showToast");
                                           toastEvent.setParams({
                                               title : 'Error',
                                               message:'Both Current Pack Size and Proposed Pack Size should be same',
                                               duration:' 5000',
                                               key: 'info_alt',
                                               type: 'error'
                                           });
                                           toastEvent.fire();
                                           component.set("v.selectedProposedProduct", '');
                                       } else {
                                           productInstance.Phoenix_Proposed_Product__c = data[i].Id;
                                           productInstance.Phoenix_Proposed_Product_Name__c = data[i].Name;
                                           productInstance.Phoenix_Proposed_SAP_Number__c = data[i].ProductCode;
                                           productInstance.Phoenix_Proposed_NDC__c = data[i].Phoenix_NDC_11_Dashes__c;
                                           productInstance.Phoenix_Proposed_Pack_Size__c = data[i].Phoenix_Pkg_Size__c;  
                                           component.set("v.productInstance", productInstance);   
                                       }
                                   }
                               }
                           });
        $A.enqueueAction(action);
    }
  
})