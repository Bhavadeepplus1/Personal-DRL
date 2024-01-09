({
    getProducts: function(component, event){
        var selectedProducts = component.get("v.selectedProducts");
        var action = component.get("c.getProducts");
        action.setParams({
            'selectedProducts': component.get("v.selectedProducts"),
            'currentProductFamily': component.get("v.currentProductFamily")
        });
        action.setCallback(this, function(response){
            if(response.getState()=="SUCCESS"){
                var resp = response.getReturnValue();
                console.log('Products:: '+JSON.stringify(resp));
                var currentProductOpts = [];
                for(var i=0;i< resp.length;i++){
                    currentProductOpts.push({"class": "optionClass", label: resp[i].Name, value: resp[i].Id});
                }
                component.set("v.currentProducts", currentProductOpts);
            }
        });
        $A.enqueueAction(action);
    },
})