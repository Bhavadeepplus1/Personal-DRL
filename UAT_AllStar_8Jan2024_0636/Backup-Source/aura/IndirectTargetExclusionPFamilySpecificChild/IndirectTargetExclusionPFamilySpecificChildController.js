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
        action.setParams({
            'prodFamily' : prodFamily,
            'sales_rep' : component.get("v.salesRepName"),
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