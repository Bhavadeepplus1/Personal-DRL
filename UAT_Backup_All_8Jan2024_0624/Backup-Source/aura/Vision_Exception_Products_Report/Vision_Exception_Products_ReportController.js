({
    doInit: function(component, event, helper){
        var date = new Date();
        var firstDay = new Date(date.getFullYear(), date.getMonth(), 1);
        var lastDay = new Date(date.getFullYear(), date.getMonth(), date.getDate());
        component.set("v.startDate", date.getFullYear()+'-'+(parseInt(firstDay.getMonth())+1)+'-'+'1');
        component.set("v.endDate", date.getFullYear()+'-'+(parseInt(lastDay.getMonth())+1)+'-'+date.getDate());
    },
    getProductData: function(component, event, helper){
        helper.getProductData(component, event, helper);
    },
    sortByDays: function(component, event, helper){
        component.set("v.isSpinnerLoad", true);  
        var keyList = component.get("v.keyList");
        component.set("v.filterName", 'Since Last Bid');
        if(component.get("v.isAsc")){
            component.set("v.isAsc", false);
        } else{
            component.set("v.isAsc", true);
        }
        component.set("v.keyList", []);
        component.set("v.keyList", keyList);
        component.set("v.data", component.get("v.data"));
        component.set("v.isSpinnerLoad", false);
    },
    sortBySales: function(component, event, helper){
        var data = component.get("v.data");
        var finalObj = {};var sorted = [];
        component.set("v.filterName", 'Sales');
        if(component.get("v.sortBySalesASC")){
            component.set("v.sortBySalesASC", false);
            sorted = Object.values(data).sort((a, b) => b.summaryMap.salesSummary - a.summaryMap.salesSummary);
        } else{
            component.set("v.sortBySalesASC", true);
                sorted = Object.values(data).sort((a, b) => a.summaryMap.salesSummary - b.summaryMap.salesSummary);
        }
        sorted.forEach((elem, i) => {
            finalObj[elem.family] = elem
        });
            var keys = Object.keys(finalObj);
            component.set("v.data", finalObj);
            component.set("v.keyList", keys);
    },
    filterRxSRxOTC: function(component, event, helper){
        var selectionList = component.get('v.selectionList');        
        if(component.get("v.isRxChecked") && !selectionList.includes('Rx')){
            selectionList.push('Rx');
        }
        if(component.get("v.isSRxChecked") && !selectionList.includes('SRx')){
            selectionList.push('SRx');
        }
        if(component.get("v.isOTCChecked") && !selectionList.includes('OTC')){
            selectionList.push('OTC');
        }
        if(component.get("v.isRxChecked") == false && selectionList.includes('Rx')){
            var ind = selectionList.indexOf('Rx')
            selectionList.splice(ind, 1);
        }
        if(component.get("v.isSRxChecked") == false && selectionList.includes('SRx')){
            var ind = selectionList.indexOf('SRx')
            selectionList.splice(ind, 1);
        }
        if(component.get("v.isOTCChecked") == false && selectionList.includes('OTC')){
            var ind = selectionList.indexOf('OTC')
            selectionList.splice(ind, 1);
        }
        if(selectionList.length == 0){
            var sel = ['Rx', 'SRx', 'OTC'];
            component.set("v.isRxChecked", true);
            component.set("v.isSRxChecked", true);
            component.set("v.isOTCChecked", true);
         	component.set("v.selectionList", sel);   
        } else{
            component.set("v.selectionList",selectionList);
        }
        var action = component.get("c.getData");
        var startDate = component.get("v.startDate");
        var endDate = component.get("v.endDate");
        if(startDate != null && endDate != null){
            component.set("v.isSpinnerLoad", true);
            action.setParams({
                'startDate': new Date(startDate),
                'endDate': new Date(endDate),
                'selectionList': component.get("v.selectionList")
            });
            action.setCallback(this, function(response){
                if(response.getState() == 'SUCCESS'){
                    var response = response.getReturnValue();
                    component.set("v.productsCount", response.productsCount);
                    component.set("v.rxCount", response.rxCount);
                    component.set("v.srxCount", response.srxCount);
                    component.set("v.otcCount", response.otcCount);
                    if(response != null){
                        component.set("v.data", response.familyMap);
                        helper.sortBySales(component, event, helper);
                    }
                } else{
                    console.log("Error: "+JSON.stringify(response.getError()));
                    component.set("v.isSpinnerLoad", false);
                    component.set("v.dataLoaded", false);
                }
            });
            $A.enqueueAction(action);   
        } else{
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title : 'Warning',
                type: 'Warning',
                message:'Please provide both Start Date and End Date.',
                mode: 'dismissible',
                key: 'info_alt',
                duration: '10000'
            });
            toastEvent.fire();
        }
    },
    expandAll: function(component, event, helper){
        component.set("v.isSpinnerLoad", true);
        component.set("v.expandCollapse", false);
        component.set("v.expand", true);
        component.set("v.keyList", component.get("v.keyList"));
        component.set("v.data", component.get("v.data"));
        component.set("v.isSpinnerLoad", false);
    },
    collapseAll: function(component, event, helper){
        component.set("v.isSpinnerLoad", true);
        component.set("v.expandCollapse", true);
        component.set("v.expand", false);
        component.set("v.keyList", component.get("v.keyList"));
        component.set("v.data", component.get("v.data"));
        component.set("v.isSpinnerLoad", false);
    }
})