({
    expandProduct: function(component, event, helper){
        console.log('Expand Product Called');
        var expandProduct = component.get("v.expandProduct");
        var productMap = component.get("v.productMap");
        var product = component.get("v.product");
		var relatedProductList = productMap[product];
        var customerMap = {};
        for(var i=0; i<relatedProductList.length; i++){
            var customerName;
            if(relatedProductList[i].hasOwnProperty('customer')){
                customerName = relatedProductList[i].customer;
            } else if(relatedProductList[i].bidLineItem.hasOwnProperty('Phoenix_Customer__r')){
                customerName = relatedProductList[i].bidLineItem.Phoenix_Customer__r.Name;
            }
            if(customerMap.hasOwnProperty(customerName)){
                var familyRelatedList = customerMap[customerName];
                familyRelatedList.push(relatedProductList[i]);
                if(customerName != null){
                    customerMap[customerName] = familyRelatedList;                            
                }
                
            } else{
                var familyRelatedList = [];
                familyRelatedList.push(relatedProductList[i]);
                if(customerName != null){
                    customerMap[customerName] = familyRelatedList;  
                }
            }   
        }
        //component.set("v.relatedProductList", productMap[product]);
        component.set("v.customerMapList", Object.keys(customerMap));
        component.set("v.customerMap", customerMap);
        if(component.get("v.expandAll")){
            component.set("v.expandProduct", component.get("v.expandAll"));
        } else{
            if(expandProduct){
                component.set("v.expandProduct", false);
            } else{
                component.set("v.expandProduct", true);
            }      
        }     
    },
})