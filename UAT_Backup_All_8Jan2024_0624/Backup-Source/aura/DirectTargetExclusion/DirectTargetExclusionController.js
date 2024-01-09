({
	init : function(component, event, helper) {
        
        component.set("v.isSpinnerLoad",true);
        helper.getSalesRepName(component, event, helper);
        helper.getCustomerName(component, event, helper);
        helper.getProducts(component, event, helper);
        helper.ShowData(component, event, helper);
        //helper.ShowData(component, event, helper);
		
	},
    
    redirectToAchievementSummary : function(component, event, helper) {
        
        var navService = component.find("navService");
        var pageReference = {
            "type": "standard__component",
            "attributes": {
                "componentName": "c__AchievementSummaryTable"  // c__YourComponentName
            }
        }
        navService.navigate(pageReference);
		
	},
    
    searchHandler : function(component, event, helper){
        
        component.set("v.isSpinnerLoad",true);
        component.set("v.salesRepName",component.get("v.SalesManagerselectedPdts")),
        component.set("v.customer_Name",component.get("v.selectedPicklist")),
       	component.set("v.product_List",component.get("v.selectedProducts")),
        helper.ShowData(component, event, helper)
        
    }
    
})