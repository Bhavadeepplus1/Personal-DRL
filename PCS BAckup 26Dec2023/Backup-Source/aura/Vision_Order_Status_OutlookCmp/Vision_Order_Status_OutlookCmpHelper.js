({
    getData : function(component, event, helper, startDate, endDate, selectedRange) {
        component.set("v.loaded", true);
        var action = component.get("c.getOrderDataOutlook");
        console.log('Search Text: Order Status: '+component.get("v.searchText"));
        action.setParams({
            "searchText": component.get("v.searchText")
        });
        action.setCallback(this, function (response) {
            if(response.getState() == "SUCCESS"){ 
                var res = response.getReturnValue();
                console.log('resss--==>'+Object.keys(res.outlookOrderMap).length);
                if(Object.keys(res.outlookOrderMap).length != 0){
                    component.set("v.ndcList", Object.values(res.outlookOrderMap)[0]);
                    var orderMap = Object.values(res.outlookOrderMap);
                    var order = orderMap[0][0];
                    order.showItem = false;
                    order.formattedOrderDate = new Date(order.Vision_Order_Date__c).toLocaleDateString("en-US", { year: "numeric", month: "2-digit", day: "2-digit" });
                    order.formattedPODate = new Date(order.Vision_PO_Date__c).toLocaleDateString("en-US", { year: "numeric", month: "2-digit", day: "2-digit" });
                    component.set("v.customerOrdersList",order);
                    console.log('Order Map Type: '+ typeof orderMap);
                    component.set("v.loaded", false);   
                    component.set("v.onLoad", false);   
                } else{
                    component.set("v.customerOrdersList", []);
                    component.set("v.onLoad", false);
                    component.set("v.loaded", false);  
                }
            }
            else{
                component.set("v.loaded", false);
                console.log("Error "+JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action); 
    },
})