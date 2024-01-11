({
    handleClick1: function(component, event, helper){
        component.set("v.show", false);
        component.set("v.showProducts", true);
        component.set("v.loaded", true);
        var orderNumber = event.getSource().get("v.name");
        console.log('orderNumber: '+orderNumber);
        console.log('searchText: '+component.get("v.searchText"));
        var action = component.get("c.getRelatedOrdersOutlook");
        action.setParams({
            "orderNumber": orderNumber,
            "searchText": component.get("v.searchText")
        });
        action.setCallback(this, function (response) {
            if(response.getState() == "SUCCESS"){ 
                var res = response.getReturnValue();
                console.log('Response: '+JSON.stringify(res));
                var data =component.get("v.customerOrdersList");
                for(var i=0;i<data.length;i++){
                    if(orderNumber == data[i].Vision_Order_Number__c){
                        if(data[i].showItem){
                            data[i].showItem = false;   
                        } else{
                            data[i].showItem = true;
                            data[i].ordersList = Object.values(res);
                        }
                    }
                }
                component.set("v.customerOrdersList", data);     
                component.set("v.loaded", false);
            } else{
                component.set("v.loaded", false);
                console.log("Error "+JSON.stringify(response.getError()));
            }
        }); 
        $A.enqueueAction(action);
        
    },
    handleClick2: function(component, event, helper){
        component.set("v.show", true);
        component.set("v.showProducts", false);
        var orderNumber = event.getSource().get("v.name");
        //console.log('orderNumber: '+orderNumber);
        var data =component.get("v.customerOrdersList");
        for(var i=0;i<data.length;i++){
            if(orderNumber == data[i].Vision_Order_Number__c){
                if(data[i].showItem){
                    data[i].showItem = false;   
                    data[i].ordersList = [];
                } else{
                    data[i].showItem = true;
                }
            }
        }
        component.set("v.customerOrdersList", data); 
    },
    filterData: function(component, event, helper){
        component.set("v.loaded", true);
        var searchText = component.get("v.searchText");
        if(searchText){
            helper.getData(component, event, helper);
        } else{
            component.set("v.customerOrdersList", []);
            component.set("v.onLoad", true);
            component.set("v.searchText", null);
            component.set("v.loaded", false);
        }
    },
    gotoOrderStatus : function(component, event, helper) {
        window.open('/lightning/n/Order_Status');
    },
    onSearchTextChange: function(component, event, helper){
        var searchText = component.get("v.searchText");
        if(!searchText){
            component.set("v.customerOrdersList", []);
            component.set("v.onLoad", true);
            component.set("v.loaded", false);
            component.set("v.searchText", null);
        }
    }
})