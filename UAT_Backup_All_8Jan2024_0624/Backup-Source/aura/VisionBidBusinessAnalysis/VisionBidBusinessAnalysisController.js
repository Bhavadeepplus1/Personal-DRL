({
    doInit: function(component, event, helper){
        var selections = component.get("v.selections");
        selections.push('Rx');
        selections.push('SRx');
        selections.push('OTC');
        component.set("v.selections", selections);  
        var date = new Date();
        /*var firstDay = new Date(date.getFullYear(), 3, 1);
        var lastDay = new Date(date.getFullYear(), 3, 30);*/
        var firstDay = new Date(date.getFullYear(), date.getMonth(), 1);
        var lastDay = new Date(date.getFullYear(), date.getMonth(), date.getDate());
        /*component.set("v.startDate", date.getFullYear()+'-'+(parseInt(firstDay.getMonth())+1)+'-'+'1');
        component.set("v.endDate", date.getFullYear()+'-'+(parseInt(lastDay.getMonth())+1)+'-'+date.getDate());*/
        component.set("v.startDate", date.getFullYear()+'-1-'+'1');
        component.set("v.endDate", date.getFullYear()+'-1-'+'31');
        console.log('Start Date: '+component.get("v.startDate"));
        console.log('End Date: '+component.get("v.endDate"));
        var action = component.get("c.getFamilies");
        action.setCallback(this, function(response){
            if(response.getState() == 'SUCCESS'){
                var response = response.getReturnValue();
                var familiesList = [];
                var obj = { 'label' : '', 'value': ''};
                familiesList.push(obj);
                if(response != null){
                    for(var i=0; i<response.length; i++){
                        var obj = {};
                        obj.label = response[i];
                        obj.value = response[i];
                        familiesList.push(obj);
                    }
                }
                component.set("v.familiesList", familiesList);
            } else{
                console.log("Error "+JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);
    },
    expandAll: function(component, event, helper){
      	component.set("v.expandAll", !component.get("v.expandAll"));
    },
    showPriceChangeDropDown: function(component, event, helper){
      	component.set("v.showPriceChangeDropDown", !component.get("v.showPriceChangeDropDown"));
        var priceChangeDropDown = component.get("v.showPriceChangeDropDown");
        var dynamicMargin = component.get("v.dynamicMargin");
        if(priceChangeDropDown){
            dynamicMargin -= 65.78;
        } else{
            dynamicMargin += 65.78;
        }
        component.set("v.dynamicMargin", dynamicMargin);
    },
    showVolumeChangeDropDown: function(component, event, helper){
        component.set("v.showVolumeChangeDropDown", !component.get("v.showVolumeChangeDropDown"));
        var volumeChangeDropDown = component.get("v.showVolumeChangeDropDown");
        var dynamicMargin = component.get("v.dynamicMargin");
        if(volumeChangeDropDown){
            dynamicMargin -= 65.78;
        } else{
            dynamicMargin += 65.78;
        }
        component.set("v.dynamicMargin", dynamicMargin);
    },
    showBothChangeDropDown: function(component, event, helper){
      	component.set("v.showBothChangeDropDown", !component.get("v.showBothChangeDropDown"));
        var bothChangeDropDown = component.get("v.showBothChangeDropDown");
        var dynamicMargin = component.get("v.dynamicMargin");
        if(bothChangeDropDown){
            dynamicMargin -= 65.78;
        } else{
            dynamicMargin += 65.78;
        }
        component.set("v.dynamicMargin", dynamicMargin);
    },
    showLostDropDown: function(component, event, helper){
      	component.set("v.showLostDropDown", !component.get("v.showLostDropDown"));
        var bothChangeDropDown = component.get("v.showLostDropDown");
        var dynamicMargin = component.get("v.dynamicMargin");
        if(bothChangeDropDown){
            dynamicMargin -= 139.44;
        } else{
            dynamicMargin = 46.56;
            dynamicMargin += 145.44;
        }
        component.set("v.dynamicMargin", dynamicMargin);
    },
    showOpenStatusDropDown: function(component, event, helper){
        var openStatusBidTypeMap = component.get("v.openStatusBidTypeMap");
        var bidTypes = []; var openStatusSummaryData = {};
      	component.set("v.showOpenStatusDropDown", !component.get("v.showOpenStatusDropDown"));
        var showOpenStatusDropDown = component.get("v.showOpenStatusDropDown");
        var dynamicMargin = component.get("v.dynamicMargin");
        if(showOpenStatusDropDown){
            dynamicMargin -= 139.44;
            if(openStatusBidTypeMap != null){
                for(var i=0; i<openStatusBidTypeMap.length; i++){
                    bidTypes.push(openStatusBidTypeMap[i][0]);
                    openStatusSummaryData[openStatusBidTypeMap[i][0]] = openStatusBidTypeMap[i][1].length;
                }
                component.set("v.bidTypes", bidTypes);
                component.set("v.openStatusSummaryData", Object.entries(openStatusSummaryData));
            }
        } else{
            dynamicMargin = 46.56;
            dynamicMargin += 145.44;
            component.set("v.bidTypes", []);
        }
        component.set("v.dynamicMargin", dynamicMargin);        
    },
    openLegendPopup: function(component, event, helper){
        var showLegendPopup = component.get("v.showLegendPopup");
        if(showLegendPopup){
            component.set("v.showLegendPopup", false);   
        } else{
            component.set("v.showLegendPopup", true);
        }
    },    
    refreshSearchTab : function(component, event, helper) {
        component.set("v.currentTabId", "tabTwo");
        component.set("v.onLoad", true);
        var searchSelectTab = component.find('searchTab');
        searchSelectTab.refreshTab();
    },
    searchHandler : function (component, event, helper) {
        const searchString = event.target.value;
        if (searchString.length >= 3) {
            //Ensure that not many function execution happens if user keeps typing
            if (component.get("v.inputSearchFunction")) {
                clearTimeout(component.get("v.inputSearchFunction"));
            }

            var inputTimer = setTimeout($A.getCallback(function () {
                helper.searchRecords(component, searchString);
            }), 1000);
            component.set("v.inputSearchFunction", inputTimer);
        } else{
            component.set("v.results", []);
            component.set("v.openDropDown", false);
        }
    },

    optionClickHandler : function (component, event, helper) {
        const selectedId = event.target.closest('li').dataset.id;
        const selectedValue = event.target.closest('li').dataset.value;
        component.set("v.inputValue", selectedValue);
        component.set("v.selectedFamily", selectedValue);
        component.set("v.openDropDown", false);
        component.set("v.selectedOption", selectedId);
    },

    clearOption : function (component, event, helper) {
        component.set("v.results", []);
        component.set("v.openDropDown", false);
        component.set("v.inputValue", "");
        component.set("v.selectedOption", "");
        component.set("v.selectedFamily", "");
    },
    
    handleChange: function (component, event, helper) {
        var division = event.getParam("value");
        component.set("v.selectedDivision", division);
    },
    handleDirectorChange: function(component, event, helper){
        var directorType = event.getParam("value");
        component.set("v.selectedDirectorType", directorType);
    },
    handleFamilyChange: function(component, event, helper){
        var family = event.getParam("value");
        component.set("v.selectedFamily", family);
    },
    selectedVal: function(component, event, helper){
        console.log('Selected Director: '+component.get("v.selectedId"));
    },
    dateBasedOn: function (component, event, helper){
        var selectedDate = event.getParam("value");
        component.set("v.selectedDate", selectedDate);
    },
    searchSrxRxOtc: function(component, event, helper){
        var productType = event.getParam("value");
        component.set("v.selections", []);
        var selections = component.get("v.selections");
        if(productType == 'All'){
             selections.push('Rx');
            selections.push('SRx');
            selections.push('OTC');   
        } else{
         	selections = productType.split('+');   
        }
        component.set("v.selections", selections);
    },
    displayPieChart: function(component, event, helper){
      	component.set("v.isModalOpen", true);
    },
    selectedBidIdsChange: function(component, event, helper){
        console.log('Selected Bid Ids: '+component.get("v.selectedBidIds"));
    },
    displayWaterfallChart: function(component, event, helper){
      	component.set("v.showWaterfallChart", true);
    },
    closeModal: function(component, event, helper){
         component.set("v.isModalOpen", false);
        component.set("v.showWaterfallChart", false);
    },
    closeShowProductsModal: function(component, event, helper){
        component.set("v.showAddProducts", false);
    },
    searchBidData : function(component, event, helper) {
        //get method paramaters
        var params = event.getParam('arguments');
        if (params) {
            var param1 = params.selectedBids;
            component.set("v.selectedBidIds", param1);
            component.set("v.currentTabId", "tabTwo");
            var searchByBids = true;
            helper.collectData(component, event, helper, searchByBids);
        }
    },
    activeTabOne: function(component, event, helper){
      	component.set("v.currentTabId", "tabOne");
        component.set("v.onLoad", true);
    },
    productToCustomer: function(component, event, helper){
      	component.set("v.currentTabId", "tabThree");
        component.set("v.onLoad", true);        
    },
    customerToProduct: function(component, event, helper){
      	component.set("v.currentTabId", "tabFour");
        component.set("v.onLoad", true);        
    },
    manufacturerTab: function(component, event, helper){
        component.set("v.currentTabId", "tabSeven");
        component.set("v.onLoad", true);        
    },
    positionWise: function(component, event, helper){
      	component.set("v.currentTabId", "tabFive");
        component.set("v.onLoad", true);        
    },
    
    collectData: function(component, event, helper){
		component.set("v.showPriceChangeDropDown", false);
        component.set("v.showVolumeChangeDropDown", false);
        component.set("v.showBothChangeDropDown", false);
        component.set("v.showLostDropDown", false);
        component.set("v.showOpenStatusDropDown", false);
        console.log('Start Date: '+component.get("v.startDate"));
        console.log('End Date: '+component.get("v.endDate"));
        helper.collectData(component, event, helper);
    },
    QRMView: function(component, event, helper){
      	component.set("v.currentTabId", "tabSix");
        component.set("v.onLoad", true);                
    },
    downloadCsv: function (component, event, helper) {        
        var resultData = component.get("v.scmData");  
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
        hiddenElement1.download = 'Bid Business Analysis'+ '-' + Now + '-' + '.csv'; // CSV file Name* you can change it.[only name not .csv] 
        document.body.appendChild(hiddenElement1); // Required for FireFox browser
        hiddenElement1.click(); // using click() js function to download csv file
    },
    downloadCategoryWiseCsv: function (component, event, helper) {        
        helper.downloadBusinessGainedCsv(component, event, helper);
        helper.downloadBusinessRetainedGainedCsv(component, event, helper);
        helper.downloadBusinessRetainedLossCsv(component, event, helper);
        //helper.downloadBusinessLostCsv(component, event, helper);
        helper.downloadInternalRejectionsCsv(component, event, helper);
        helper.downloadNoEffectsCsv(component, event, helper);
        helper.downloadOpenStatusCsv(component, event, helper);
    },
    
})