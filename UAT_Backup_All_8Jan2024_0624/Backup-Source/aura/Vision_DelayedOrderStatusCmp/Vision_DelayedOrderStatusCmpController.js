({
    doInit : function(component, event, helper) {
        var d = new Date();
        var d2 = new Date();
        var startDate = new Date(d2.setDate(d2.getDate() - 7));
        component.set("v.startDate", startDate.toISOString());
        component.set("v.endDate", d.toISOString());
        console.log('Date: '+d);
        helper.getData(component, event, helper);
    },
    handleChange: function (component, event, helper) {
        var selectedOption = event.getParam("value");
        component.set("v.selectedOption", selectedOption);
        var selectedRange = component.find("rangeId").get("v.value");
        console.log('selectedRange-->'+selectedRange);
        component.set("v.selectedRange",selectedRange);
    },
    handleClick1: function(component, event, helper){
        component.set("v.show", false);
        component.set("v.showProducts", true);
        component.set("v.loaded", true);
        var orderNumber = event.getSource().get("v.name");
        console.log('orderNumber: '+orderNumber);
        var action = component.get("c.getRelatedOrders");
        var date1 = component.get("v.startDate");
        var date2 =  component.get("v.endDate");
        action.setParams({
            "tabName": 'OpenDelayed',
            "orderNumber": orderNumber,
            "recordId": component.get("v.recordId"),
            "startDate":date1,
            "endDate":date2,
            "selectedRange":component.get("v.selectedRange"),
            "searchText": component.get("v.searchText"),
            "searchCustText": component.get("v.searchCustText"),
            "openDelayed": component.get("v.openDelayed"),
            "isCancelledOrders": false
        });
        action.setCallback(this, function (response) {
            if(response.getState() == "SUCCESS"){ 
                var res = response.getReturnValue();
                var total = 0;
                if(res.length > 0){
                    for(var i=0; i<res.length; i++){
                        if(res[i].hasOwnProperty('Vision_Net_Amount__c')){
                         	total += res[i].Vision_Net_Amount__c;   
                        }
                    }
                }
                var data =component.get("v.customerOrdersList");
                for(var i=0;i<data.length;i++){
                    if(orderNumber == data[i].Vision_Order_Number__c){
                        if(data[i].showItem){
                            data[i].showItem = false;   
                        } else{
                            data[i].showItem = true;
                            data[i].totalAmount = total;
                            data[i].ordersList = Object.values(res);
                        }
                    }
                }
                component.set("v.customerOrdersList", data);
                component.set("v.loaded", false);
                console.log('Data: '+JSON.stringify(data));
            }else{
                component.set("v.loaded", false);
                console.log("Error "+JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);
    },
    handleClick2: function(component, event, helper){
        component.set("v.show", true);
        component.set("v.showProducts", false);
        component.set("v.loaded", true);
        var orderNumber = event.getSource().get("v.name");
        console.log('orderNumber: '+orderNumber);
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
        component.set("v.loaded", false);
    },
    handleStartDateChange: function(component, event, helper) {
        var date1 = component.get("v.startDate");
        var date2 = component.get("v.endDate");
        console.log('Start: '+date1+' End: '+date2);
    },
    handleEndDateChange: function(component, event, helper) {
        var date1 = component.get("v.startDate");
        var date2 =  new Date(component.get("v.endDate"));
        // date2.setDate(date2.getDate() + 1);
        console.log('Start: '+date1+' End: '+date2);
        
    }, 
    filterData: function(component, event, helper){
        component.set("v.isSpinnerLoad", true);
        var date1 = component.get("v.startDate");
        var date2 =  new Date(component.get("v.endDate"));
        //  date2.setDate(date2.getDate() + 1);
        var selectedRange = component.get("v.selectedRange");
        if(date1 == null || date2 == null || date1 == undefined || date2 == undefined || date1 == '' || date2 == ''){
            component.set("v.isSpinnerLoad", false);
            var message = 'Please choose both Start Date and End Date ';
            helper.showErrorToast(component, event, message);
        } else if(selectedRange ==''|| selectedRange == null|| selectedRange ==undefined){
            component.set("v.isSpinnerLoad", false);
            var message = 'Please select Date filter based on ';
            helper.showErrorToast(component, event, message);
        }
            else{
                component.set("v.existingOrdersMap", null);
                component.set("v.totalAmount", 0);
                component.set("v.totalOrders", 0);
                helper.getData(component, event, helper, date1, date2);
            }
    },
    onsearch: function(component, event, helper){
        var searchText = component.get("v.searchText");
        var selectedRange = component.find("rangeId").get("v.value");
        console.log('Search Text: '+searchText);
        var date1 = component.get("v.startDate");
        var date2 =  new Date(component.get("v.endDate"));
        helper.getData(component, event, helper, date1, date2);
    },
    onSearchCustomer: function(component, event, helper){
        var searchText = component.get("v.searchCustText");
        var selectedRange = component.find("rangeId").get("v.value");
        console.log('Search Text: '+searchText);
        var date1 = component.get("v.startDate");
        var date2 =  new Date(component.get("v.endDate"));
        helper.getData(component, event, helper, date1, date2);
    },
    searchSrxRxOttc: function(component, event, helper){
        var openDelayed = component.get("v.openDelayed");
        /*if(openDelayed == true){
            console.log('If: '+component.get("v.openDelayed"));
            component.set("v.openDelayed", false);
        } else{
            console.log('Else: '+component.get("v.openDelayed"));
            component.set("v.openDelayed", true);
        }*/
        console.log('After: '+component.get("v.openDelayed"));
        var date1 = component.get("v.startDate");
        var date2 =  new Date(component.get("v.endDate"));
        helper.getData(component, event, helper, date1, date2);
    },
    
    buildPaging : function(component,event, helper){
        helper.callServer(component,'c.getTotalItems', function(response){
            var ttl = response;
            var lmt = component.get('v.limitPerPage');
            var pages = Math.ceil(parseInt(ttl) / parseInt(lmt));
            var pagesArray = [];
            for(var i=1; i<=pages; i++){
                var obj = {};
                obj['label'] = i.toString();
                obj['value'] = i.toString();
                pagesArray.push(obj);
            }
            component.set('v.pagesArray',pagesArray);
        },{});
    },
    
    doPaging : function(component, event, helper){
        var lmt = component.get('v.limitPerPage');
        var val = event.getSource().get("v.value");
        var offset = parseInt((val-1) * lmt);
        component.set('v.curpage',val);
        component.set('v.offset',offset);
        console.log('curpage: '+val);
        console.log('offset: '+offset);
        helper.getData(component, event, helper);
        /*helper.callServer(component,'c.getNewHires', function(response){
            if(response.length > 0){
                component.set("v.newhires", response);
            }else{
                console.log('no records');
            }
        },{'ofst' : ofst, 'lmt' : lmt});*/
    },
    previousPage: function(component, event, helper){
        var lmt = component.get('v.limitPerPage');
        var ordersSize = component.get("v.customerOrdersList").length;
        var lastOrder = component.get("v.customerOrdersList")[ordersSize-1].Vision_Order_Number__c;
        var firstOrder = component.get("v.customerOrdersList")[0].Vision_Order_Number__c;
        component.set("v.selectedPageOption", 'Previous');
        component.set("v.firstOrder", firstOrder);
        component.set("v.lastOrder", lastOrder);
        var currentPageNumber = component.get("v.curpage");
        var offset = parseInt((currentPageNumber-1) * lmt);
        component.set('v.curpage',currentPageNumber-1);
        component.set('v.offset',offset);
        console.log('offset: '+offset);
        helper.getData(component, event, helper);
    },
    nextPage: function(component, event, helper){
        var lmt = component.get('v.limitPerPage');
        var orders = component.get("v.customerOrdersList");
        console.log('Order: '+orders[0]);
        var lastOrder = orders[orders.length-1].Vision_Order_Number__c;
        var firstOrder = orders[0].Vision_Order_Number__c;
        component.set("v.selectedPageOption", 'Next');
        component.set("v.firstOrder", firstOrder);
        component.set("v.lastOrder", lastOrder);
        var currentPageNumber = component.get("v.curpage");
        var offset = parseInt((currentPageNumber+1) * lmt);
        component.set('v.curpage',currentPageNumber+1);
        component.set('v.offset',offset);
        console.log('offset: '+offset);
        helper.getData(component, event, helper);
    },
    
    onFirst: function(component, event, helper){
        var lmt = component.get('v.limitPerPage');
        var orders = component.get("v.customerOrdersList");
        console.log('Order: '+orders[0]);
        var lastOrder = orders[orders.length-1].Vision_Order_Number__c;
        var firstOrder = orders[0].Vision_Order_Number__c;
        component.set("v.selectedPageOption", 'First');
        component.set("v.firstOrder", firstOrder);
        component.set("v.lastOrder", lastOrder);
        var currentPageNumber = component.get("v.curpage");
        var offset = parseInt((currentPageNumber+1) * lmt);
        component.set('v.curpage',currentPageNumber+1);
        component.set('v.offset',offset);
        console.log('offset: '+offset);
        helper.getData(component, event, helper);
    },
    
    onLast: function(component, event, helper){
        var lmt = component.get('v.limitPerPage');
        var orders = component.get("v.customerOrdersList");
        console.log('Order: '+orders[0]);
        var lastOrder = orders[orders.length-1].Vision_Order_Number__c;
        var firstOrder = orders[0].Vision_Order_Number__c;
        component.set("v.selectedPageOption", 'Last');
        component.set("v.firstOrder", firstOrder);
        component.set("v.lastOrder", lastOrder);
        var currentPageNumber = component.get("v.curpage");
        var offset = parseInt((currentPageNumber+1) * lmt);
        component.set('v.curpage',currentPageNumber+1);
        component.set('v.offset',offset);
        console.log('offset: '+offset);
        helper.getData(component, event, helper);
    },
    openModal: function(component, event, helper) {
        component.set("v.isModalOpen", true);
    },
    closeModal: function(component, event, helper){
        component.set("v.isModalOpen", false);
    },
})