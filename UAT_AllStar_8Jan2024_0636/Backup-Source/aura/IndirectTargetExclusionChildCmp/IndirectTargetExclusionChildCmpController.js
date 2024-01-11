({
	doInit : function(component, event, helper) {
		
	},
    
     handleClick1: function(component, event, helper){
        console.log('event==>'+event.getSource().get("v.value") )
        component.set("v.showItem",false)
        //component.set("v.showProductFamily",true)
         component.set("v.showCustomers",true)
        var cust_SalesRep = event.getSource().get("v.value")
        var cust_SalesReps = cust_SalesRep.split("_");
        var contractNumber = cust_SalesReps[0];
         console.log('contractsNameFromFilter==>'+component.get("v.contractsNameFromFilter"));
  		console.log('productsFromFilter==>'+component.get("v.productsFromFilter"))
         var sales_rep = cust_SalesReps[1];
        component.set("v.contractNumber",contractNumber)
        component.set("v.salesRepName",sales_rep)
        
        var action = component.get("c.ContractSpecific_getDirectSalesList");
             action.setParams({
                 'contractNumber' : contractNumber,
                 'contractsNameFromFilter' : component.get("v.contractsNameFromFilter"),
                 'salesRepNameFromFilter' : component.get("v.salesRepNameFromFilter"),
                 'customerNameFromFilter' : component.get("v.customerNameFromFilter"),
                 'productsFromFilter' : component.get("v.productsFromFilter"),
             });
        action.setCallback(this,function(response){
            
            if(response.getState()=='SUCCESS'){
                //component.set("v.DirectSalesData",response.getReturnValue());
                console.log('cust specific==>'+JSON.stringify(response.getReturnValue()))
                var modified_list = [];
                console.log('length==>'+response.getReturnValue().length);
                for(var i=0;i<response.getReturnValue().length-2;i++){
                    modified_list.push(response.getReturnValue()[i]);
                }
                 //component.set("v.CustomerSpecific_DirectSalesData",modified_list);
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
           //component.set("v.showProductFamily",false)
            component.set("v.showCustomers",false)
    }
})