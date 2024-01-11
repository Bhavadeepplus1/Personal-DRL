({
    /*handleChange : function(component, event, helper) {
        console.log('Selected Contract Id: '+component.get("v.selectedContract"));
        component.set("v.loaded", true);
		helper.getData(component, event, helper);
    },*/
    loaded: function(component, event, helper){
        console.log('Yeah! Script loaded..');
    },
    jsloaded: function(component, event, helper){
        console.log('Yeah! Chartjs Script loaded..');
    },
    HighChartsloaded: function(component, event, helper){
        console.log('Yeah! HighCharts Script loaded..');
    },
	doInit : function(component, event, helper) {
        component.set("v.loaded",true);
        var action = component.get("c.getFilters");
        action.setParams({
            'accountId': component.get("v.recordId")
        });
        action.setCallback(this, function(response){
            if(response.getState() == 'SUCCESS'){
                var selections = response.getReturnValue();
                if(selections.includes('Rx')){
                    component.set("v.isRxChecked", true);
                }
                if(selections.includes('SRx')){
                    component.set("v.isSRxChecked", true);
                }
                if(selections.includes('OTC')){
                    component.set("v.isOtcChecked", true);
                }
        		component.set("v.selections", response.getReturnValue());      
                console.log('Selections: '+response.getReturnValue());
                helper.getData(component, event, helper);
            } else{
                console.log("Error "+JSON.stringify(response.getError()));
                component.set("v.loaded", false);
            }
        });
        $A.enqueueAction(action);
	},
    handleChange: function(component, event, helper){
        console.log('Value changed to: '+component.get("v.selectedContract"));
        if(component.get("v.selectedContract") == '' || component.get("v.selectedContract") == null){
            component.set("v.productData", []);
            component.set("v.contractRec", null);
        } else{
            component.set("v.loaded", true);
            helper.getData(component, event, helper);
        }
    },
    sortByProduct : function(component, event, helper){
        var isAsc = component.get("v.isAsc");
        if(isAsc == true){
            component.set("v.isAsc", false);
        } else{
            component.set("v.isAsc", true);
        }
        component.set("v.filterName", 'Product Description');
        component.set("v.sortField", 'Vision_Product__r.Name');
        component.set("v.loaded", true);
        helper.getData(component, event, helper);
    }, 
    sortByPosition : function(component, event, helper){
        var isAsc = component.get("v.isAsc");
        if(isAsc == true){
            component.set("v.isAsc", false);
        } else{
            component.set("v.isAsc", true);
        }
        component.set("v.filterName", 'Formulary Position');
        component.set("v.sortField", 'Vision_Current_Product_Position__c');
        component.set("v.loaded", true);
        helper.getData(component, event, helper);
    },
    displayChart: function(component, event, helper){
        component.set("v.isModalOpen", true);
        component.set("v.showChart", true);
        component.set("v.chartType", 'Bar');
        var positionsCount = component.get("v.positionsCount");
        var selectedContract = event.getSource().get("v.value");
        console.log('selectedContract: '+JSON.stringify(selectedContract));
        component.set("v.selectedContract", selectedContract);
        component.set("v.selectedContractPositionsCount", positionsCount[selectedContract]);
        /*var topHeight = 2036;
        var scrollOptions = {
            left: 0,
            top: topHeight,
            behavior: 'smooth'
        }
        window.scrollTo(scrollOptions);*/
    },
    displayPieChart: function(component, event, helper){
        component.set("v.isModalOpen", true);
        component.set("v.showChart", true);
        component.set("v.chartType", 'Pie');
        var positionsCount = component.get("v.positionsCount");
        var selectedContract = event.getSource().get("v.value");
        console.log('selectedContract: '+JSON.stringify(selectedContract));
        component.set("v.selectedContract", selectedContract);
        component.set("v.selectedContractPositionsCount", positionsCount[selectedContract]);
        /*var topHeight = 2036;
        var scrollOptions = {
            left: 0,
            top: topHeight,
            behavior: 'smooth'
        }
        window.scrollTo(scrollOptions);*/
    },
    closeModal: function(component, event, helper){
        component.set("v.isModalOpen", false);
    },
    searchSrxRxOttc: function(component, event, helper){
        component.set("v.loaded", true);
        var rx = component.get("v.isRxChecked");
        var sRx = component.get("v.isSRxChecked");
        var otc = component.get("v.isOtcChecked");
        var selections = component.get("v.selections");
        if(rx == true && !selections.includes('Rx')){
            selections.push('Rx');
        }
        if(sRx == true && !selections.includes('SRx')){
            selections.push('SRx');
        }
        if(otc == true && !selections.includes('OTC')){
            selections.push('OTC');
        }
        if(rx == false && selections.includes('Rx')){
            var ind = selections.indexOf('Rx');
            selections.splice(ind, 1);
        }
        if(sRx == false && selections.includes('SRx')){
            var ind = selections.indexOf('SRx');
            selections.splice(ind, 1);
        }
        if(otc == false && selections.includes('OTC')){
            var ind = selections.indexOf('OTC');
            selections.splice(ind, 1);
        }
        if(selections.length == 0){
            selections.push('Rx');
            selections.push('SRx');
            selections.push('OTC');
            component.set("v.isRxChecked", true);
            component.set("v.isSRxChecked", true);
            component.set("v.isOtcChecked", true);
        }
        component.set("v.selections", selections);
		helper.getData(component, event, helper);
    },
    downloadCsv: function (component, event, helper) {        
        var resultData = component.get("v.productData");  
        var csv4 = helper.convertArrayOfObjectsToCSV(component, resultData);
        if (csv4 == null) {
            return;
        }
        var hiddenElement1 = document.createElement('a');
        hiddenElement1.href = 'data:text/csv;charset=utf-8,' + encodeURI(csv4);
        hiddenElement1.target = '_self'; //
        var date = new Date();
        var hours = date.getHours();
        var minutes = date.getMinutes();
        var newformat = hours >= 12 ? 'PM' : 'AM';
        hours = hours % 12;
        hours = hours ? hours : 12;
        minutes = minutes < 10 ? '0' + minutes : minutes;
        var Now = (date.getMonth() + 1) + '/' + date.getDate() + '/' + date.getFullYear() + ' ' + hours + ':' + minutes + ' ' + newformat;
        hiddenElement1.download = 'Formulary Positions'+ '-' + Now + '-' + '.csv'; // CSV file Name* you can change it.[only name not .csv] 
        document.body.appendChild(hiddenElement1); // Required for FireFox browser
        hiddenElement1.click(); // using click() js function to download csv file
    },
})