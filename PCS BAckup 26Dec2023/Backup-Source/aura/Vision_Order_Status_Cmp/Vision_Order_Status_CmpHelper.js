({
    getData : function(component, event, helper, startDate, endDate, selectedRange) {
        component.set("v.loaded", true);
        var action = component.get("c.getCustomerOrdersData");
        var selections = component.get("v.selections");
        var date1 = component.get("v.startDate");
        var date2 =  component.get("v.endDate");
        component.set("v.countLoading", true);
        console.log('RecordId:1 '+component.get("v.recordId"));
        console.log('option:1 '+component.get("v.selectedOption"));
        console.log('startDate:1 '+date1);
        console.log('endDate:1 '+date2);
        console.log('selectedRange:1 '+component.get("v.selectedRange"));
        console.log('selections:1 '+component.get("v.selections"));
        console.log('searchText:1 '+component.get("v.searchText"));
        console.log('searchCustText:1 '+component.get("v.searchCustText"));
        console.log('selectedPageOption:1 '+component.get("v.selectedPageOption"));
        console.log('lastOrder:1 '+component.get("v.lastOrder"));
        console.log('firstOrder:1 '+component.get("v.firstOrder"));
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
            "isCancelledOrders": false
        });
        action.setCallback(this, function (response) {
            if(response.getState() == "SUCCESS"){ 
                var res = response.getReturnValue();
                console.log('resss--==>'+JSON.stringify(res));
                var gcpDateSplit = res.GCPUpdateDate.split(" ");
                console.log('Vision Update Date: '+res.GCPUpdateDate);
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
                if(res.orderMap != null){
                    console.log('Object.keys(res.orderMap): '+Object.keys(res.orderMap));
                    var orderMap = Object.values(res.orderMap);
                    for(var i=0; i<orderMap.length; i++){
                        orderMap[i].showItem = false;
                        orderMap[i].formattedOrderDate = new Date(orderMap[i].Vision_Order_Date__c).toLocaleDateString("en-US", { year: "numeric", month: "2-digit", day: "2-digit" });
                        orderMap[i].formattedPODate = new Date(orderMap[i].Vision_PO_Date__c).toLocaleDateString("en-US", { year: "numeric", month: "2-digit", day: "2-digit" });
                    }
                    component.set("v.customerOrdersList",orderMap);
                    console.log('Initial Response Query: '+res.orderStatusListQuery);
                    component.set("v.query", res.orderStatusListQuery);
                    component.set("v.loaded", false);  
                    if(orderMap != null && orderMap.length != 0){
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
        console.log('Cust Text: '+component.get("v.searchCustText"));
        action.setParams({
            'query': component.get("v.query"),
            'totalAmount': component.get("v.totalAmount"),
            'mapOfOrders': component.get("v.existingOrdersMap"),
            'startingDate': component.get("v.startDate"),
            'endingDate': component.get("v.endDate"),
            "searchKey": component.get("v.searchText"),
            "searchCustKey": component.get("v.searchCustText"),
            "tabName": 'Analysis'
        });
        action.setCallback(this, function(response){
            if(response.getState() === 'SUCCESS'){
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
        console.log('Get Total Count Helper Called');
        var action = component.get("c.getTotalOrdersCount");
        console.log('query: '+component.get("v.query"));
        console.log('totalAmount: '+component.get("v.totalAmount"));
        console.log('mapOfOrders: '+component.get("v.existingOrdersMap"));
        console.log('startingDate: '+component.get("v.startDate"));
        console.log('endingDate: '+component.get("v.endDate"));
        console.log('searchText: '+component.get("v.searchText"));
        console.log('searchCustText: '+component.get("v.searchCustText"));
        action.setParams({
            'query': component.get("v.query"),
            'totalAmount': component.get("v.totalAmount"),
            'mapOfOrders': component.get("v.existingOrdersMap"),
            'startingDate': component.get("v.startDate"),
            'endingDate': component.get("v.endDate"),
            "searchKey": component.get("v.searchText"),
            "searchCustKey": component.get("v.searchCustText"),
        });
        action.setCallback(this, function(response){
            if(response.getState() === 'SUCCESS'){
                console.log('getTotalCountHelper Response: '+JSON.stringify(response.getReturnValue()));
                var mapOfOrdersSize = Object.keys(component.get("v.existingOrdersMap")).length;
                var responseLength = Object.keys(response.getReturnValue().mapOfOrders).length;
                if(responseLength != mapOfOrdersSize){
                    component.set("v.existingOrdersMap", response.getReturnValue().mapOfOrders);
                    component.set("v.totalOrders", Object.keys(component.get("v.existingOrdersMap")).length);
                    component.set("v.totalAmount", response.getReturnValue().totalAmount);
                    this.getTotalCountHelper(component, event, helper);
                } else{
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