({
	doInit : function(component, event, helper) {
		
	},
    handleClick1: function(component, event, helper){
        console.log('event==>'+event.getSource().get("v.value") )
        component.set("v.showItem",false)
        component.set("v.showProductFamily",true)
        console.log('sales rep==>'+component.get("v.salesRepName"))
        var custName = event.getSource().get("v.value")
        component.set("v.custName",custName)
        var action = component.get("c.CustomerSpecific_getDirectSalesList");
        action.setParams({
            'custName' : custName,
            'sales_rep' : component.get("v.salesRepName"),
            'customerFromFilter' : component.get("v.customerFromFilter"),
            'productFromFilter' : component.get("v.productFromFilter")
        });
        action.setCallback(this,function(response){
            
            if(response.getState()=='SUCCESS'){
                //component.set("v.DirectSalesData",response.getReturnValue());
                console.log('cust specific==>'+JSON.stringify(response.getReturnValue()))
                 component.set("v.CustomerSpecific_DirectSalesData",response.getReturnValue());
            }
            else{
                console.log("Error "+JSON.stringify(response.getError()));
                
            }
            
        });
        
        $A.enqueueAction(action);
    },
    handleClick2: function(component, event, helper){
           component.set("v.showItem",true)
           component.set("v.showProductFamily",false)
    }
})