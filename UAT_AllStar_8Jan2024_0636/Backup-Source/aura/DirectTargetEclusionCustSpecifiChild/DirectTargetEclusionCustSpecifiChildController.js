({
	 doInit: function(component, event, helper){
         console.log('record==>'+JSON.stringify(component.get("v.record")))
     },
     handleClick1: function(component, event, helper){
        console.log('event==>'+event.getSource().get("v.value") )
        component.set("v.showItem",false)
         component.set("v.showProduct",true)
        var prodFamily = event.getSource().get("v.value")
        var action = component.get("c.productFamily_getDirectSalesList");
         var sales_rep = String(component.get("v.salesRepName"));
         //var custName = String(component.get("v.customerName"));
         var custNumber = component.get("v.customerNumber");
         console.log('productsFromFilter'+component.get("v.productsFromFilter"))
        action.setParams({
            'prodFamily' : prodFamily,
            'sales_rep' : sales_rep,
            'custNumber':custNumber,
            'custNames'  : component.get("v.customerNameFromFilter"),
            'salesRepName' : component.get("v.salesRepNameFromFilter"),
            'productsList' :component.get("v.productsFromFilter")
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