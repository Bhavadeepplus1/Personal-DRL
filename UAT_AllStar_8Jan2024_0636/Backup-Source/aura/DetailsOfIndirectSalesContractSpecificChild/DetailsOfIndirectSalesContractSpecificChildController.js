({
	doInit : function(component, event, helper) {
		
	},
    handleClick1: function(component, event, helper){
        console.log('event==>'+event.getSource().get("v.value") )
        component.set("v.showItem",false)
        component.set("v.showProductFamily",true);
        component.set("v.showCustomers",true)
        console.log('sales rep==>'+component.get("v.salesRepName"))
        
        var contractName = event.getSource().get("v.value")
        component.set("v.contractName",contractName);
          console.log('contractName==>'+contractName)
        var action = component.get("c.ContractSpecific_getIndirectSalesList");
        action.setParams({
            'contractName' : contractName,
            'sales_rep' : component.get("v.salesRepName"),
            'contractFromFilter' : component.get("v.contractFromFilter"),
            'customerFromFilter' : component.get("v.customerFromFilter"),
            'productFromFilter' : component.get("v.productFromFilter"),
        });
        action.setCallback(this,function(response){
            
            if(response.getState()=='SUCCESS'){
                //component.set("v.DirectSalesData",response.getReturnValue());
                console.log('cust specific==>'+JSON.stringify(response.getReturnValue()))
                 component.set("v.ContractSpecific_IndirectSalesData",response.getReturnValue());
            }
            else{
                console.log("Error "+JSON.stringify(response.getError()));
                
            }
            
        });
        
        $A.enqueueAction(action);
    },
    handleClick2: function(component, event, helper){
           component.set("v.showItem",true)
           component.set("v.showCustomers",false)
           
    }
})