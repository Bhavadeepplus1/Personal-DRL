({
    nprdata: function (component, event, helper) {
        component.set("v.isSpinnerLoad",true);
        var action = component.get("c.futureNPR");    
        console.log("Product Id--->"+component.get("v.productId"))
        console.log("lineItemId Id--->"+component.get("v.lineItemId"))
        action.setParams({
            productId : component.get("v.productId")
        });
        action.setCallback(this, function (response) {  
            console.log("response---"+response.getState());
            if(response.getState() == "SUCCESS"){  
                component.set("v.isSpinnerLoad",false);
                var nprRecord=response.getReturnValue();
                component.set("v.FutureNPRDataList",nprRecord.nprDataList); 
                component.set("v.prodName",nprRecord.prodName); 
                 component.set("v.prodId",nprRecord.prodId); 
            }
            
        });
        $A.enqueueAction(action);  
    },
    openModel: function(component, event, helper) {
        // Set isModalOpen attribute to true
        component.set("v.isModalOpen", false);
        component.set("v.displayFutureDisplay",false); 
        var LineItemtable = component.get("v.tableRef");
        $A.util.addClass(LineItemtable, "maintable");
    }
})