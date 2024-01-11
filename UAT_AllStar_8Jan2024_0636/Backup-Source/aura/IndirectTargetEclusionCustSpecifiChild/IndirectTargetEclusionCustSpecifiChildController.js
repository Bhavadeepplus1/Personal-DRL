({
	 doInit: function(component, event, helper){
         console.log('record==>'+JSON.stringify(component.get("v.record")))
     },
     handleClick1: function(component, event, helper){
        console.log('event==>'+event.getSource().get("v.value") )
        component.set("v.showItem",false)
         component.set("v.showProduct",true)
         var prodFamily = event.getSource().get("v.value")
         var sales_rep = String(component.get("v.salesRepName"));
         var custName = String(component.get("v.customerName"));
         var contractNumber = String(component.get("v.contractNumber"));
          console.log('sales_rep==>'+component.get("v.sales_rep"))
         console.log('customerName==>'+component.get("v.customerName"))
         console.log('productsFromFilter'+component.get("v.productsFromFilter"))
        var action = component.get("c.productFamily_getDirectSalesList");
        action.setParams({
            'prodFamily' : prodFamily,
            'sales_rep' :sales_rep,
            'custName':custName,
            'contractNumber' :contractNumber,
            'contractsNameFromFilter' : component.get("v.contractsNameFromFilter"),
            'salesRepNameFromFilter' : component.get("v.salesRepNameFromFilter"),
            'customerNameFromFilter' : component.get("v.customerNameFromFilter"),
            'productsFromFilter' : component.get("v.productsFromFilter"),
        });
        action.setCallback(this,function(response){
            
            if(response.getState()=='SUCCESS'){
                //component.set("v.DirectSalesData",response.getReturnValue());
                console.log('cust specific==>'+JSON.stringify(response.getReturnValue()))
                 component.set("v.productFamily_DirectSalesData",response.getReturnValue());
            }
            else{
                console.log("Error "+JSON.stringify(response.getError()));
                
            }
            
        });
        
        $A.enqueueAction(action);
    },
       handleClick2: function(component, event, helper){
         component.set("v.showItem",true)
         component.set("v.showProduct",false)
         
       }
    
})