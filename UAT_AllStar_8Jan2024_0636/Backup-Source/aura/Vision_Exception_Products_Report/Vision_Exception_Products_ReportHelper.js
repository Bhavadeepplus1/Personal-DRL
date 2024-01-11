({
    getProductData: function(component, event, helper){
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
                    console.log('Response: '+JSON.stringify(response.familyMap));
                    component.set("v.productsCount", response.productsCount);
                    component.set("v.rxCount", response.rxCount);
                    component.set("v.srxCount", response.srxCount);
                    component.set("v.otcCount", response.otcCount);
                    if(response != null){
                        /*var keys = Object.keys(response.familyMap);
                        component.set("v.keyList", keys);*/
                        component.set("v.data", response.familyMap);
                        this.sortBySales(component, event, helper, response.familyMap);
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
    sortBySales: function(component, event, helper){
        var data = component.get("v.data");
        var finalObj = {};var sorted = [];
        var familyIdsMap = {};
        component.set("v.filterName", 'Sales');
        if(component.get("v.sortBySalesASC")){
            sorted = Object.values(data).sort((a, b) => a.summaryMap.salesSummary - b.summaryMap.salesSummary);
        } else{
            sorted = Object.values(data).sort((a, b) => b.summaryMap.salesSummary - a.summaryMap.salesSummary);
        }
        sorted.forEach((elem, i) => {
            finalObj[elem.family] = elem;
            familyIdsMap[elem.family] = elem.familyId;
        });
            var keys = Object.keys(finalObj);
            component.set("v.familyIds", familyIdsMap);
            component.set("v.data", finalObj);
            component.set("v.keyList", keys);
            component.set("v.isSpinnerLoad", false);
            component.set("v.dataLoaded", true); 
    },
})