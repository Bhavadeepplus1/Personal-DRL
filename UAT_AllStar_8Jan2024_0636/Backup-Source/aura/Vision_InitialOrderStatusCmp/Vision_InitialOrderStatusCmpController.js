({
	doInit : function(component, event, helper) {
        console.log("Account Id is: "+component.get("v.recordId"));
	},
    handleChange: function(component, event, helper){
        if(component.get("v.selectedContract") == '' || component.get("v.selectedContract") == null){
            component.set("v.selectedContractName", null);
            component.set("v.contractType", null);
            component.set("v.initialOrderData", null);
            component.set("v.noInitialOrderData", null);
        } else{
            helper.getData(component, event, helper);
        }
    },
    sortByProduct : function(component, event, helper){
        var isAsc = component.get("v.isAsc");
        if(isAsc == true){
            component.set("v.isAsc", false);
        } else{
            component.set("v.isAsc", true);
        }
        component.set("v.filterName", 'Product Description');
        component.set("v.sortField", 'Vision_Product__r.Name');
        helper.getData(component, event, helper);
    }, 
    sortByAwardedPrice : function(component, event, helper){
        var isAsc = component.get("v.isAsc");
        if(isAsc == true){
            component.set("v.isAsc", false);
        } else{
            component.set("v.isAsc", true);
        }
        component.set("v.filterName", 'Awarded Price');
        component.set("v.sortField", 'Vision_Internal_DeadNet__c');
        helper.getData(component, event, helper);
    }, 
    sortByAwardedQty : function(component, event, helper){
        var isAsc = component.get("v.isAsc");
        if(isAsc == true){
            component.set("v.isAsc", false);
        } else{
            component.set("v.isAsc", true);
        }
        component.set("v.filterName", 'Awarded Qty');
        component.set("v.sortField", 'Vision_Awarded_Volume__c');
        helper.getData(component, event, helper);
    }, 
    sortByAwardedQty : function(component, event, helper){
        var isAsc = component.get("v.isAsc");
        if(isAsc == true){
            component.set("v.isAsc", false);
        } else{
            component.set("v.isAsc", true);
        }
        component.set("v.filterName", 'Awarded Qty');
        component.set("v.sortField", 'Vision_Awarded_Volume__c');
        helper.getData(component, event, helper);
    }, 
})