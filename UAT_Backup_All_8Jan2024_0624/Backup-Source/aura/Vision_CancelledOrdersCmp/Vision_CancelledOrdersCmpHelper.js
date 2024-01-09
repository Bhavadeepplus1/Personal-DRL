({
    getData : function(component, event, helper, startDate, endDate, selectedRange) {
        component.set("v.loaded", true);
        var action = component.get("c.getCustomerOrdersData");
        var selections = component.get("v.selections");
        var date1 = component.get("v.startDate");
        var date2 =  component.get("v.endDate");
        action.setParams({
            "recordId": component.get("v.recordId"),
            "option": component.get("v.selectedOption"),
            "startDate":date1,
            "endDate":date2,
            "selectedRange":component.get("v.selectedRange"),
            "selections": selections,
            "searchText": component.get("v.searchText"),
            "searchCustText": component.get("v.searchCustText"),
            "selectedPageOption": component.get("v.selectedPageOption"),
            "lastOrder": component.get("v.lastOrder"),
            "firstOrder": component.get("v.firstOrder"),
            "isCancelledOrders": true
        });
        action.setCallback(this, function (response) {
            if(response.getState() == "SUCCESS"){ 
                var res = response.getReturnValue();
                console.log('resss--==>'+JSON.stringify(res));
                component.set("v.totalAmount",res.totalAmount);
                console.log('Total Amount'+JSON.stringify(res.totalAmount));
                var gcpDateSplit = res.GCPUpdateDate.split(" ");
                console.log('GCP Update Date: '+res.GCPUpdateDate);
                var sapDateSplit = res.SAPUpdateDate.split(" ");
                var visionDateSplit = res.VisionUpdateDate.split(" ");
                component.set("v.SAPUpdateDate", new Date(res.SAPUpdateDate).toLocaleDateString("en-US", { year: "numeric", month: "2-digit", day: "2-digit" })+' ('+sapDateSplit[1]+' '+'EST)');
                component.set("v.GCPUpdateDate", new Date(res.GCPUpdateDate).toLocaleDateString("en-US", { year: "numeric", month: "2-digit", day: "2-digit" })+' ('+gcpDateSplit[1]+' '+'EST)');
                component.set("v.VisionUpdateDate", new Date(res.VisionUpdateDate).toLocaleDateString("en-US", { year: "numeric", month: "2-digit", day: "2-digit" })+' ('+visionDateSplit[1]+' '+'EST)');
                component.set("v.totalOrders", res.totalOrders);
                var pages = Math.ceil(parseInt(res.totalOrders) / parseInt(component.get("v.limitPerPage")));
                component.set("v.totalPages", pages);
                var pagesArray = [];
                for(var i=1; i<=pages; i++){
                    pagesArray.push(i);
                }
                component.set('v.pagesArray',pagesArray);
                component.set("v.stringToDisablePageButton", res.stringToDisablePageButton);
                if(Object.keys(res.orderMap) != null){
                    var orderMap = Object.values(res.orderMap);
                    for(var i=0; i<orderMap.length; i++){
                        orderMap[i].showItem = false;
                        orderMap[i].ordersList = [];
                        var d = new Date();
                        //added by satya//
                        if(orderMap[i].Vision_Delivery_Number__c == null || orderMap[i].Vision_Delivery_Number__c == undefined ){
                            orderMap[i].stageValue = 1;
                            //console.log('Order Number::: '+prodObj.cxOrderList[0].Vision_Order_Number__c);
                        }
                        if(orderMap[i].Vision_Delivery_Number__c != null && orderMap[i].Vision_PGI_Date__c == null){
                            orderMap[i].stageValue = 2;
                        }
                        if(orderMap[i].Vision_Delivery_Number__c != null && orderMap[i].Vision_PGI_Date__c != null && orderMap[i].Vision_GCP_Ship_Date__c != null){
                            orderMap[i].stageValue = 3;
                        }
                        if(orderMap[i].Vision_Delivery_Number__c != null && orderMap[i].Vision_PGI_Date__c >= d.setDate(d.getDate() - 10)){
                            orderMap[i].stageValue = 4;
                        }
                        orderMap[i].formattedOrderDate = new Date(orderMap[i].Vision_Order_Date__c).toLocaleDateString("en-US", { year: "numeric", month: "2-digit", day: "2-digit" });
                        orderMap[i].formattedPODate = new Date(orderMap[i].Vision_PO_Date__c).toLocaleDateString("en-US", { year: "numeric", month: "2-digit", day: "2-digit" });
                    }
                    component.set("v.customerOrdersList",orderMap);
                    component.set("v.query", res.orderStatusListQuery);
                    component.set("v.loaded", false);   
                    if(orderMap != null && orderMap.length != 0){
                        component.set("v.countLoading", true);
                     	this.getTotalCount(component, event, helper);   
                    } else{
                        component.set("v.countLoading", false);
                    }
                } else{
                    component.set("v.loaded", false);   
                    component.set("v.noData", true);   
                    component.set("v.countLoading", false);
                }
            }
            else{
                component.set("v.loaded", false);
                console.log("Error "+JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action); 
    },
    getTotalCount: function(component, event, helper){
        var action = component.get("c.getTotalOrdersCount");
        action.setParams({
            'query': component.get("v.query"),
            'totalAmount': component.get("v.totalAmount"),
            'mapOfOrders': component.get("v.existingOrdersMap"),
            'startingDate': component.get("v.startDate"),
            'endingDate': component.get("v.endDate"),
            "searchKey": component.get("v.searchText"),
            "searchCustKey": component.get("v.searchCustText"),
            "tabName": 'CANCELLED'
        });
        action.setCallback(this, function(response){
            if(response.getState() === 'SUCCESS'){
                console.log('Response Count: '+JSON.stringify(response.getReturnValue()));
                component.set("v.existingOrdersMap", response.getReturnValue().mapOfOrders);
                component.set("v.totalAmount", response.getReturnValue().totalAmount);
                this.getTotalCountHelper(component, event, helper);
            } else{
                console.log("Error "+JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);
    },
    getTotalCountHelper: function(component, event, helper){
        var action = component.get("c.getTotalOrdersCount");
        action.setParams({
            'query': component.get("v.query"),
            'totalAmount': component.get("v.totalAmount"),
            'mapOfOrders': component.get("v.existingOrdersMap"),
            'startingDate': component.get("v.startDate"),
            'endingDate': component.get("v.endDate"),
            "searchKey": component.get("v.searchText"),
            "searchCustKey": component.get("v.searchCustText"),
            "tabName": 'Cancelled'
        });
        action.setCallback(this, function(response){
            if(response.getState() === 'SUCCESS'){
                console.log('getTotalCountHelper Response Count: '+JSON.stringify(response.getReturnValue()));
                console.log('1: '+JSON.stringify(component.get("v.existingOrdersMap")));
                var mapOfOrdersSize = Object.keys(component.get("v.existingOrdersMap")).length;
                console.log('2');
                var responseLength = Object.keys(response.getReturnValue().mapOfOrders).length;
                console.log('3');
                console.log('Response Length: '+responseLength+' Existing Length: '+mapOfOrdersSize);
                if(responseLength != mapOfOrdersSize){
                    console.log('4: '+response.getReturnValue().totalAmount);
                    component.set("v.existingOrdersMap", response.getReturnValue().mapOfOrders);
                    component.set("v.totalOrders", Object.keys(component.get("v.existingOrdersMap")).length);
                    component.set("v.totalAmount", response.getReturnValue().totalAmount);
                    this.getTotalCountHelper(component, event, helper);
                    console.log('5');
                } else{
                    console.log('Total Orders: '+Object.keys(component.get("v.existingOrdersMap")).length);
                    component.set("v.countLoading", false);
                    component.set("v.totalOrders", Object.keys(component.get("v.existingOrdersMap")).length);
                    component.set("v.totalAmount", response.getReturnValue().totalAmount);
                }
            } 
        });
        $A.enqueueAction(action);
    },
    showErrorToast : function(component, event, message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Warning!',
            message: message,
            duration:' 5000',
            key: 'info_alt',
            type: 'error'
        });
        toastEvent.fire();
    },
})