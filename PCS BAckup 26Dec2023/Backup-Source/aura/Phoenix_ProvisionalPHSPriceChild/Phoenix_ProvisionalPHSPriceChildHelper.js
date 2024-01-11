({
	getProductInfo : function(component, event) {
        var action = component.get("c.getProductInfo");
        action.setParams({
            "productId": component.get("v.selectedRecord").Id
        });
        action.setCallback(this, function(response) 
                           {
                               if(response.getState()=="SUCCESS"){
                                   var resp = response.getReturnValue();
                                   var instance = component.get("v.lineInstance");
                                   if(resp[0]){
                                       instance.Phoenix_Product_Name__c = component.get("v.selectedRecord").Id;
                                       instance.ProductName__c = component.get("v.selectedRecord").Name;
                                       instance.Phoenix_PHS_Price_Change__c = component.get("v.recordId");
                                       instance.Phoenix_NDC_11__c = resp[0].Phoenix_NDC_11__c;
                                       instance.Phoenix_Material_Code__c = resp[0].ProductCode;
                                   }
                                   component.set("v.lineInstance", instance);
                               }
                           });
        $A.enqueueAction(action);
	}
})