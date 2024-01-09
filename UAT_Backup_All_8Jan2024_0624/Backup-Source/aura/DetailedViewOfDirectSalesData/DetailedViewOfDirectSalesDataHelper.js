({
    getData:function(component, event, helper){
        console.log('salesRepName==>'+component.get("v.salesRepName"))
         console.log('customer list==>'+JSON.stringify(component.get("v.selectedPicklist")))
         console.log('selectedProducts==>'+JSON.stringify(component.get("v.selectedProducts")))
         var action = component.get("c.getDirectSalesList");
        action.setParams({
            salesRepName : component.get("v.salesRepName"),
            customer_Name : component.get("v.selectedPicklist"),
            product_List : component.get("v.selectedProducts")
        });
        action.setCallback(this,function(response){
            
            if(response.getState()=='SUCCESS'){
                var original_list = response.getReturnValue()
                
                var modified_list = [];
                console.log('length==>'+response.getReturnValue().length);
                for(var i=0;i<response.getReturnValue().length-2;i++){
                    //if(i != response.getReturnValue().length-2){
                    modified_list.push(response.getReturnValue()[i]);
                    //}
                }
              
                component.set("v.DirectSalesData",modified_list);
                
                component.set("v.summaryList",original_list[original_list.length-2]);
                component.set("v.MonthList",original_list[original_list.length-1].currenttwelveMonthKeys);
                
                component.set("v.isSpinnerLoad",false);
                //console.log('component month lsit is '+JSON.stringify(component.get("v.MonthList")));
               //console.log('response list is'+JSON.stringify(response.getReturnValue()));
                //console.log('summary list is =='+JSON.stringify(original_list[original_list.length-1]))
          		
            }
            else{
                console.log("Error "+JSON.stringify(response.getError()));
                
            }
            
        });
        
        $A.enqueueAction(action);
    },
    
    getCustomerName:function(component, event, helper){
        var action = component.get("c.getCustomerNames");
        action.setParams({
            salesRepName : component.get("v.salesRepName"),
        })
        action.setCallback(this,function(response){
            if(response.getState() == 'SUCCESS'){
                var responseList = response.getReturnValue();
                console.log('response.....'+responseList.length);
                var title=[];
                for (var i=0; i<responseList.length; i++) {
                    title[i] = {
                        'label':responseList[i],
                        'value': responseList[i]
                        
                    };
                }
                component.set("v.optionsforCustomers",title);  
               
               
               
            }else{
                console.log('Error'+JSON.stringify(response.getError())); 
                component.set("v.isSpinnerLoad", false);
            }
        });
        $A.enqueueAction(action);
     },
    
    getProducts:function(component, event, helper){
        var action = component.get("c.getProductNames");
        action.setParams({
            salesRepName : component.get("v.salesRepName"),
        })
        action.setCallback(this,function(response){
            if(response.getState() == 'SUCCESS'){
                var responseList = response.getReturnValue();
                console.log('response.....'+responseList.length);
                var title=[];
                for (var i=0; i<responseList.length; i++) {
                    title[i] = {
                        'label':responseList[i],
                        'value': responseList[i]
                        
                    };
                }
                component.set("v.optionsforProducts",title);  
                helper.getData(component, event, helper);
               
               
            }else{
                console.log('Error'+JSON.stringify(response.getError())); 
                component.set("v.isSpinnerLoad", false);
            }
        });
        $A.enqueueAction(action);
     },
    
})