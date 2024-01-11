({
	doInit : function(component, event, helper) {
		
	},
    
     handleClick1: function(component, event, helper){
        console.log('event==>'+event.getSource().get("v.value") )
        component.set("v.showItem",false)
        component.set("v.showProductFamily",true)
        var cust_SalesRep = event.getSource().get("v.value")
        var cust_SalesReps = cust_SalesRep.split("_");
         var contractNumber = cust_SalesReps[0];
         var custName = cust_SalesReps[1];
         var sales_rep = cust_SalesReps[2];
         console.log('contractNumber==>'+contractNumber)
         console.log('custName==>'+custName)
         console.log('productsFromFilter==>'+component.get("v.productsFromFilter"))
         component.set("v.customerName",custName)
        component.set("v.salesRepName",sales_rep)
        var action = component.get("c.CustomerSpecific_getDirectSalesList");
        action.setParams({
            'contractNumber' :contractNumber,
            'custName' : custName,
            'sales_rep' : sales_rep,
            'contractsNameFromFilter' : component.get("v.contractsNameFromFilter"),
            'salesRepNameFromFilter' : component.get("v.salesRepNameFromFilter"),
            'customerNameFromFilter' : component.get("v.customerNameFromFilter"),
            'productsFromFilter' : component.get("v.productsFromFilter"),
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
           component.set("v.showItem",true);
        	
           component.set("v.showProductFamily",false);
    }
})