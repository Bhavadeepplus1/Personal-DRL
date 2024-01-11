({
    doInit : function(component, event, helper) {
        component.set("v.isOpen", true);
        var isWACOffer = component.get("v.isWACOffer");
        var isNDCOffer = component.get("v.isNDCOffer");
        var isCustSpecific = component.get("v.isCustSpecific");
        if(isWACOffer == true){
            component.set("v.objectAPIName", 'Phoenix_WAC_Change__c');
            component.set("v.relatedTo", 'WAC Change');
            var action = component.get("c.getWACOfferTemplates");
            action.setParams
            ({
                "wacId": component.get("v.recordId"),
                "isCustomerSpecific": component.get("v.isCustSpecific")
            });
        } else if(isNDCOffer == true){
            component.set("v.objectAPIName", 'Phoenix_NDC_Change__c');
            component.set("v.relatedTo", 'NDC Change');
            var action = component.get("c.getNDCOfferTemplates");
            action.setParams
            ({
                "ndcId": component.get("v.recordId")
            });            
        } else{
            component.set("v.objectAPIName", 'Phoenix_Bid__c');
            component.set("v.relatedTo", 'Bid Template');
            var action = component.get("c.getOfferTemplates");
            action.setParams
            ({
                "bidId": component.get("v.recordId"),
                "customerId": component.get("v.customerId")
            });   
        }
        
        action.setCallback(this, function(response) 
                           {
                               if(response.getState()=="SUCCESS"){
                                   var wrapperObj = response.getReturnValue();
                                   component.set("v.offerTemplateList", wrapperObj.offTemp);
									console.log('lineItemsInfo=='+JSON.stringify(wrapperObj.lineItemsInfo));
                                   component.set("v.defaultOfferName", wrapperObj.offerDefaultName);
                                   component.set("v.lineItemsFamilies", wrapperObj.listOfLineItemsFamilies);
                                   if(isCustSpecific){
                                       component.set("v.lineItemsCustomers", wrapperObj.listOfLineItemsAccounts);
                                   }
                               }
                           });
        $A.enqueueAction(action);
        
    },
    
    closeModel: function(component, event, helper) { 
        component.set("v.isOpen", false);
        var LineItemtable = component.get("v.tableClass");
        console.log('tableClass-->'+JSON.stringify(LineItemtable));
        $A.util.addClass(LineItemtable, "contractTable");
    },
    
    handleSelectedTemplate:function(component, event, helper) {
        var selectedTemplate = component.find('select').get('v.value');
        console.log('selectedTemplate=='+selectedTemplate);
        component.set("v.selectedTemplate", selectedTemplate);
    },
    handleSelectedCustomer:function(component, event, helper) {
        var selectedAccount = component.find('selectCustomer').get('v.value');
        component.set("v.selectedAccount", selectedAccount);
        var action = component.get("c.getWACOfferTemplates");
        action.setParams
        ({
            "wacId": component.get("v.recordId"),
            "isCustomerSpecific": component.get("v.isCustSpecific"),
            "customerId": component.get("v.selectedAccount")
        });
        action.setCallback(this, function(response) 
                           {
                               if(response.getState()=="SUCCESS"){
                                   var wrapperObj = response.getReturnValue();
                                   console.log('Wrapper Response:: '+JSON.stringify(wrapperObj));
                                   component.set("v.offerTemplateList", wrapperObj.offTemp);
                                   component.set("v.defaultOfferName", wrapperObj.offerDefaultName);
                               }
                           });
        $A.enqueueAction(action);
    },
    
    handleSelectedProductFamily: function(component, event, helper) {
        var selectedFamily = component.find('selectfamily').get('v.value');
        component.set("v.selectedProductFamily", selectedFamily);
    },
    
    generateDoc : function(component, event, helper) {
        var defaultOfferName = component.get("v.defaultOfferName");
        var selectedTemplate = component.get("v.selectedTemplate");
        var selectedAccount = component.get("v.selectedAccount");
        var selectedFamily = component.get("v.selectedProductFamily");
        var isCustSpecific = component.get("v.isCustSpecific");
        if(defaultOfferName == "" || selectedTemplate == "" || selectedTemplate == "undefined" || selectedFamily == ""){
            helper.toastMessage(component, event);
        } else{
            if(isCustSpecific){
                if(selectedAccount == "" || selectedAccount == "null" || selectedAccount == 'All'){
                    helper.toastMessage(component, event);
                } else{
            		helper.generateOffer(component, event, helper);        
                }
            } else{
             	helper.generateOffer(component, event, helper);   
            }
        }
    },
    
})