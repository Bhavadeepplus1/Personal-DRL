({
	formatCurrencyMethod : function(component, event, helper, number) {
        if(number != null && number != 0){
         	number = (number/1000000).toFixed(1);
            number = parseFloat(number);
        }
		const formattedCurrency = number.toLocaleString('en-US', { style: 'currency', currency: 'USD',  minimumFractionDigits: 0, maximumFractionDigits: 1 });
        return formattedCurrency+'M';
	},
    doInitStartHelper : function(component) {
        $A.util.toggleClass(component.find('resultsDiv'),'slds-is-open');
        //component.set("v.showUL", component.get("v.showUL"));
        var value = component.get('v.value');
        var values = component.get('v.values');
        
        if( !$A.util.isEmpty(value) || !$A.util.isEmpty(values) ) {
            var searchString;
            var count = 0;
            var multiSelect = component.get('v.multiSelect');
            var options = component.get('v.monthOptions');
            options.forEach( function(element, index) {
                if(multiSelect) {
                    if(values.includes(element.value)) {
                        element.selected = true;
                        count++;
                    }  
                } else {
                    if(element.value == value) {
                        searchString = element.label;
                    }
                }
            });
            if(multiSelect){
                if(count == 0)
                    component.set('v.searchString', 'Select Month(s)');   
                else
                    component.set('v.searchString', count + ' Month(s) selected');   
            }
            else
                component.set('v.searchString', searchString);
            component.set('v.monthOptions', options);
            component.set("v.selectedOptionsCount", count);
        }
        console.log('Values: '+JSON.stringify(values));
    },
    
    filterOptionsDataHelper : function(component) {
        component.set("v.message", '');
        var searchText = component.get('v.searchString');
        var options = component.get("v.monthOptions");
        var minChar = component.get('v.minChar');
        if(searchText.length >= minChar) {
            var flag = true;
            options.forEach( function(element,index) {
                if(element.label.toLowerCase().trim().startsWith(searchText.toLowerCase().trim())) {
                    element.isVisible = true;
                    flag = false;
                } else {
                    element.isVisible = false;
                }
            });
            component.set("v.monthOptions",options);
            if(flag) {
                component.set("v.message", "No results found for '" + searchText + "'");
            }
        }
        $A.util.addClass(component.find('resultsDiv'),'slds-is-open');
        component.set("v.showUL", true);
    },
     
    selectOptionHelper : function(component, event) {
        console.log('selectOptionHelper');
        var options = component.get('v.monthOptions');
        var multiSelect = component.get('v.multiSelect');
        var searchString = component.get('v.searchString');
        var values = component.get('v.values') || [];
        var value;
        var count = 0;
        if(event.currentTarget.id == 'All'){
            if(values != null && values.length != options.length){
                var allSelected = true;
                options.forEach( function(element, index) {
                    if(!element.selected){
                        allSelected = false;
                        element.selected = true;
                        values.push(element.value);
                    }
                });                
            } else if(values.length == options.length){
                values = []; 
                options.forEach( function(element, index) {
                    element.selected = false;
                });
            } else{
                options.forEach( function(element, index) {
                    element.selected = true;
                    values.push(element.value);
                });
            }
        } else{
            options.forEach( function(element, index) {
                if(element.value === event.currentTarget.id) {
                    if(multiSelect) {
                        if(values.includes(element.value)) {
                            values.splice(values.indexOf(element.value), 1);
                        } else {
                            values.push(element.value);
                        }
                        element.selected = element.selected ? false : true;   
                    } else {
                        value = element.value;
                        searchString = element.label;
                    }
                }
                if(element.selected && element.value != 'All') {
                    count++;
                }
            });   
        }
        component.set("v.selectedOptionsCount", count);
        component.set('v.value', value);
        component.set('v.values', values);
        component.set('v.monthOptions', options);
        //component.set("v.prodItem.selectedOptions", values);
        if(values != null && values !=  undefined){
            var tempVal = values;
            if(values.includes('All')){
                component.set("v.selectedPositions", tempVal.toString());
                tempVal.splice(tempVal.indexOf('All'), 1);
            }
            component.set("v.selectedPositions", tempVal.toString());
            component.set("v.selectedPositionsString", tempVal.toString());  
        }
        if(multiSelect){
            if(count == 0)
                component.set('v.searchString', 'Select Month(s)');   
            else
                component.set('v.searchString', count + ' Month(s) selected');   
        }
        else
            component.set('v.searchString', searchString);
        if(multiSelect)
            event.preventDefault();
        else{
            $A.util.removeClass(component.find('resultsDiv'),'slds-is-open');
            component.set("v.showUL", false);
        }
    },
     
    removeOptionPillHelper : function(component, event) {
        var value = event.getSource().get('v.name');
        var multiSelect = component.get('v.multiSelect');
        var count = 0;
        var options = component.get("v.monthOptions");
        var values = component.get('v.values') || [];
        options.forEach( function(element, index) {
            if(element.value === value) {
                element.selected = false;
                values.splice(values.indexOf(element.value), 1);
            }
            if(element.selected) {
                count++;
            }
        });
        component.set("v.selectedOptionsCount", count);
        if(multiSelect)
            component.set('v.searchString', count + ' Month(s) selected');
        component.set('v.values', values)
        component.set("v.monthOptions", options);
    },
     
    handleBlurHelper : function(component, event) {
        var selectedValue = component.get('v.value');
        var multiSelect = component.get('v.multiSelect');
        var previousLabel;
        var count = 0;
        var options = component.get("v.monthOptions");
        options.forEach( function(element, index) {
            if(element.value === selectedValue) {
                previousLabel = element.label;
            }
            if(element.selected && element.value != 'All') {
                count++;
            }
        });
        component.set("v.selectedOptionsCount", count);
        if(multiSelect)
            component.set('v.searchString', count + ' Months(s) selected');
        else
            component.set('v.searchString', previousLabel);
         
        if(multiSelect){
            $A.util.removeClass(component.find('resultsDiv'),'slds-is-open');
            component.set("v.showUL", false);
        }
    },
    
    openPopup: function(component, event, helper, optyWonList, optyLostList, closePopup){
        var familyMap = {}; var familySummaryForSorting = {}; var finalFamilyMap = {};
        var totalOptyAwardedSales = 0; var totalOptyAwardedGM = 0;
        var totalOptyProposedSales = 0; var totalOptyProposedGM = 0;
        if(optyWonList != null){
            for(var i=0; i<optyWonList.length; i++)    {
                var awardedQty = ((optyWonList[i].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c != null) ? optyWonList[i].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c : 0);
                var proposedASP = ((optyWonList[i].Phoenix_Proposed_ASP_Dose__c != null) ? optyWonList[i].Phoenix_Proposed_ASP_Dose__c : 0);
                var proposedQty = ((optyWonList[i].Phoenix_Final_Total_Selling_Unit__c != null) ? optyWonList[i].Phoenix_Final_Total_Selling_Unit__c : 0);
                var awardedSales = awardedQty*proposedASP;                 
                var currentSales = 0;
                if(optyWonList[i].Phoenix_Bid_Template_Refrence__c == 'ClarusOne')
                    currentSales = (optyWonList[i].Phoenix_Net_Sales_External__c != null ? optyWonList[i].Phoenix_Net_Sales_External__c : 0) ;
                else
                    currentSales = (optyWonList[i].Finance_Current_Sales__c != null ? optyWonList[i].Finance_Current_Sales__c : (optyWonList[i].Phoenix_Current_Sales_Finance__c != null ? optyWonList[i].Phoenix_Current_Sales_Finance__c : 0) );
                var proposedSales = (optyWonList[i].Phoenix_Proposed_Sales__c != null ? optyWonList[i].Phoenix_Proposed_Sales__c : 0);
                var awardedTPT = ((optyWonList[i].Phoenix_Total_DRL_Share__c != null) ? optyWonList[i].Phoenix_Total_DRL_Share__c : 0);
                var proposedTPT = ((optyWonList[i].Phoenix_Total_DRL_Share__c != null) ? optyWonList[i].Phoenix_Total_DRL_Share__c : 0);
                var currentTPT = (optyWonList[i].Phoenix_Current_TP_Margin__c != null ? optyWonList[i].Phoenix_Current_TP_Margin__c : 0);
                
                var awardedTPTPercent = awardedTPT/(proposedASP*awardedQty);
                var proposedTPTPercent = proposedTPT/proposedSales;
                //scmWrapperObj.currentTPT/(scmWrapperObj.currentDeadnet * scmWrapperObj.awardedQty)
                optyWonList[i].awardedQty = awardedQty;
                optyWonList[i].proposedASP = proposedASP;
                optyWonList[i].currentSales = currentSales;
                optyWonList[i].proposedQty = proposedQty;
                optyWonList[i].awardedSales = (awardedSales - currentSales);
                optyWonList[i].awardedTPT = (awardedTPT - currentTPT);
                optyWonList[i].proposedTPT = (proposedTPT - currentTPT);
                optyWonList[i].awardedTPTPercent = awardedTPTPercent;
                optyWonList[i].proposedTPTPercent = proposedTPTPercent;
                optyWonList[i].proposedSales = (proposedSales-currentSales);
                totalOptyAwardedSales += optyWonList[i].awardedSales;
                totalOptyAwardedGM += optyWonList[i].awardedTPT;
                if(familyMap.hasOwnProperty(optyWonList[i].Phoenix_Product_Family__c)){
                    var relatedList = familyMap[optyWonList[i].Phoenix_Product_Family__c];
                    relatedList.push(optyWonList[i]);
                    familyMap[optyWonList[i].Phoenix_Product_Family__c] = relatedList;
                    var awardedSales = familySummaryForSorting[optyWonList[i].Phoenix_Product_Family__c];
                    awardedSales += optyWonList[i].awardedSales;
                    familySummaryForSorting[optyWonList[i].Phoenix_Product_Family__c] = parseFloat(awardedSales);
                } else {
                    var relatedList = [];
                    relatedList.push(optyWonList[i]);
                    familyMap[optyWonList[i].Phoenix_Product_Family__c] = relatedList;
                    familySummaryForSorting[optyWonList[i].Phoenix_Product_Family__c] = optyWonList[i].awardedSales;
                }      
            }
            let keys = Object.keys(familySummaryForSorting);
            keys.sort(function(a, b) { 
                return familySummaryForSorting[b] - familySummaryForSorting[a]
            });
            keys.forEach(function(key) {
                finalFamilyMap[key] = familyMap[key];
            });
            component.set("v.dataObject.totalOptyAwardedSales", totalOptyAwardedSales);
            component.set("v.dataObject.totalOptyAwardedGM", totalOptyAwardedGM);
            component.set("v.optyWonFamilyMap", finalFamilyMap);
            component.set("v.optyWonFamilyList", Object.keys(finalFamilyMap));
        }
        var familyMapLost = {};  var familySummaryForSortingLost = {}; var finalFamilyMapLost = {};
        if(optyLostList != null){
            for(var i=0; i<optyLostList.length; i++)    {
                var awardedQty = ((optyLostList[i].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c != null) ? optyLostList[i].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c : 0);
                var proposedASP = ((optyLostList[i].Phoenix_Proposed_ASP_Dose__c != null) ? optyLostList[i].Phoenix_Proposed_ASP_Dose__c : 0);
                var proposedQty = ((optyLostList[i].Phoenix_Final_Total_Selling_Unit__c != null) ? optyLostList[i].Phoenix_Final_Total_Selling_Unit__c : 0);
                var awardedSales = awardedQty*proposedASP;                 
                var currentSales = 0;
                if(optyLostList[i].Phoenix_Bid_Template_Refrence__c == 'ClarusOne')
                    currentSales = (optyLostList[i].Phoenix_Net_Sales_External__c != null ? optyLostList[i].Phoenix_Net_Sales_External__c : 0) ;
                else
                    currentSales = (optyLostList[i].Finance_Current_Sales__c != null ? optyLostList[i].Finance_Current_Sales__c : (optyLostList[i].Phoenix_Current_Sales_Finance__c != null ? optyLostList[i].Phoenix_Current_Sales_Finance__c : 0) );
                var proposedSales = (optyLostList[i].Phoenix_Proposed_Sales__c != null ? optyLostList[i].Phoenix_Proposed_Sales__c : 0);
                var awardedTPT = ((optyLostList[i].Phoenix_Total_DRL_Share__c != null) ? optyLostList[i].Phoenix_Total_DRL_Share__c : 0);
                var proposedTPT = ((optyLostList[i].Phoenix_Total_DRL_Share__c != null) ? optyLostList[i].Phoenix_Total_DRL_Share__c : 0);
                var currentTPT = (optyLostList[i].Phoenix_Current_TP_Margin__c != null ? optyLostList[i].Phoenix_Current_TP_Margin__c : 0);
                
                var awardedTPTPercent = awardedTPT/(proposedASP*awardedQty);
                var proposedTPTPercent = proposedTPT/proposedSales;
                //scmWrapperObj.currentTPT/(scmWrapperObj.currentDeadnet * scmWrapperObj.awardedQty)
                optyLostList[i].awardedQty = awardedQty;
                optyLostList[i].proposedASP = proposedASP;
                optyLostList[i].currentSales = currentSales;
                optyLostList[i].proposedQty = proposedQty;
                optyLostList[i].awardedSales = (awardedSales - currentSales);
                optyLostList[i].awardedTPT = (awardedTPT - currentTPT);
                optyLostList[i].proposedTPT = (proposedTPT - currentTPT);
                optyLostList[i].awardedTPTPercent = awardedTPTPercent;
                optyLostList[i].proposedTPTPercent = proposedTPTPercent;
                optyLostList[i].proposedSales = (proposedSales-currentSales);
                totalOptyProposedSales += optyLostList[i].proposedSales;
                totalOptyProposedGM += optyLostList[i].proposedTPT;
                if(familyMapLost.hasOwnProperty(optyLostList[i].Phoenix_Product_Family__c)){
                    var relatedList = familyMapLost[optyLostList[i].Phoenix_Product_Family__c];
                    relatedList.push(optyLostList[i]);
                    familyMapLost[optyLostList[i].Phoenix_Product_Family__c] = relatedList;
                    var proposedSales = familySummaryForSortingLost[optyLostList[i].Phoenix_Product_Family__c];
                    proposedSales += optyLostList[i].proposedSales;
                    familySummaryForSortingLost[optyLostList[i].Phoenix_Product_Family__c] = proposedSales;
                } else {
                    var relatedList = [];
                    relatedList.push(optyLostList[i]);
                    familyMapLost[optyLostList[i].Phoenix_Product_Family__c] = relatedList;
                    familySummaryForSortingLost[optyLostList[i].Phoenix_Product_Family__c] = optyLostList[i].proposedSales;
                }      
            }
            let keys = Object.keys(familySummaryForSortingLost);
            keys.sort(function(a, b) { 
                return familySummaryForSortingLost[b] - familySummaryForSortingLost[a]
            });
            keys.forEach(function(key) {
                finalFamilyMapLost[key] = familyMapLost[key];
            });
            component.set("v.dataObject.totalOptyProposedSales", totalOptyProposedSales);
            component.set("v.dataObject.totalOptyProposedGM", totalOptyProposedGM);
            component.set("v.optyLostFamilyMap", finalFamilyMapLost);
            component.set("v.optyLostFamilyList", Object.keys(finalFamilyMapLost));
        }

        if(!closePopup){
            
        } else{
         	component.set("v.showPopup", !component.get("v.showPopup"));   
        }
    },
    searchWon: function(component, event, helper){
        var productSearchString = component.get("v.productSearchString");
        var customerSearchString = component.get("v.customerSearchString");
        var optyWonList = component.get("v.optyWonList");
        var familyMap = {}; var filteredList = [];
        if(optyWonList != null){
            for(var i=0; i<optyWonList.length; i++){
                if(productSearchString != null && customerSearchString != null){
                    if((optyWonList[i].Phoenix_Product_Family__c.toLowerCase().indexOf(productSearchString.toLowerCase()) !== -1 || 
                       optyWonList[i].Phoenix_Product__r.Name.toLowerCase().indexOf(productSearchString.toLowerCase()) !== -1 ||
                       optyWonList[i].Phoenix_NDC_Without_Dashes__c.indexOf(productSearchString) !== -1 ||
                       optyWonList[i].ProductCode.indexOf(productSearchString) !== -1) && 
                       optyWonList[i].Phoenix_Bid__r.Phoenix_Customer__r.Name.toLowerCase().indexOf(customerSearchString.toLowerCase()) !== -1){
                        filteredList.push(optyWonList[i]);
                    }
                }
                else if((productSearchString != null && optyWonList[i].Phoenix_Product_Family__c.toLowerCase().indexOf(productSearchString.toLowerCase()) !== -1) || 
                   (productSearchString != null && optyWonList[i].Phoenix_Product__r.Name.toLowerCase().indexOf(productSearchString.toLowerCase()) !== -1) || 
                   (customerSearchString != null && optyWonList[i].Phoenix_Bid__r.Phoenix_Customer__r.Name.toLowerCase().indexOf(customerSearchString.toLowerCase()) !== -1)){
                    filteredList.push(optyWonList[i]);
                }      
            }
        }
        console.log('Filter List Length: '+filteredList.length);
        if(filteredList != null){
            var updatedFamilyMap = {};
            for(var i=0; i<filteredList.length; i++)    {
                if(updatedFamilyMap.hasOwnProperty(filteredList[i].Phoenix_Product_Family__c)){
                    var relatedList = updatedFamilyMap[filteredList[i].Phoenix_Product_Family__c];
                    relatedList.push(filteredList[i]);
                    updatedFamilyMap[filteredList[i].Phoenix_Product_Family__c] = relatedList;
                } else {
                    var relatedList = [];
                    relatedList.push(filteredList[i]);
                    updatedFamilyMap[filteredList[i].Phoenix_Product_Family__c] = relatedList;
                }      
            }
            component.set("v.optyWonFamilyMap", updatedFamilyMap);
            component.set("v.optyWonFamilyList", Object.keys(updatedFamilyMap));
            console.log('Family Map: '+JSON.stringify(updatedFamilyMap));
        }
    },
    searchLostfunction: function(component, event, helper){
        var productSearchString = component.get("v.productSearchString");
        var customerSearchString = component.get("v.customerSearchString");
        var optyWonList = component.get("v.optyLostList");
        var familyMap = {}; var filteredList = [];
        if(optyWonList != null){
            for(var i=0; i<optyWonList.length; i++){
                if(productSearchString != null && customerSearchString != null){
                    if((optyWonList[i].Phoenix_Product_Family__c.toLowerCase().indexOf(productSearchString.toLowerCase()) !== -1 || 
                       optyWonList[i].Phoenix_Product__r.Name.toLowerCase().indexOf(productSearchString.toLowerCase()) !== -1 ||
                       optyWonList[i].Phoenix_NDC_Without_Dashes__c.indexOf(productSearchString) !== -1 ||
                       optyWonList[i].ProductCode.indexOf(productSearchString) !== -1) && 
                       optyWonList[i].Phoenix_Bid__r.Phoenix_Customer__r.Name.toLowerCase().indexOf(customerSearchString.toLowerCase()) !== -1){
                        filteredList.push(optyWonList[i]);
                    }
                }
                else if((productSearchString != null && optyWonList[i].Phoenix_Product_Family__c.toLowerCase().indexOf(productSearchString.toLowerCase()) !== -1) || 
                   (productSearchString != null && optyWonList[i].Phoenix_Product__r.Name.toLowerCase().indexOf(productSearchString.toLowerCase()) !== -1) || 
                   (customerSearchString != null && optyWonList[i].Phoenix_Bid__r.Phoenix_Customer__r.Name.toLowerCase().indexOf(customerSearchString.toLowerCase()) !== -1)){
                    filteredList.push(optyWonList[i]);
                }      
            }
        }
        console.log('Filter List Length: '+filteredList.length);
        if(filteredList != null){
            var updatedFamilyMap = {};
            for(var i=0; i<filteredList.length; i++)    {
                if(updatedFamilyMap.hasOwnProperty(filteredList[i].Phoenix_Product_Family__c)){
                    var relatedList = updatedFamilyMap[filteredList[i].Phoenix_Product_Family__c];
                    relatedList.push(filteredList[i]);
                    updatedFamilyMap[filteredList[i].Phoenix_Product_Family__c] = relatedList;
                } else {
                    var relatedList = [];
                    relatedList.push(filteredList[i]);
                    updatedFamilyMap[filteredList[i].Phoenix_Product_Family__c] = relatedList;
                }      
            }
            component.set("v.optyLostFamilyMap", updatedFamilyMap);
            component.set("v.optyLostFamilyList", Object.keys(updatedFamilyMap));
            console.log('Family Map: '+JSON.stringify(updatedFamilyMap));
        }
    },
    showLackOfInventoryPopup: function(component, event, helper){
        var lackInventoryList = component.get("v.lackInventoryList");
        if(lackInventoryList != null){
            component.set("v.showLackOfInventoryPopup", true);
            component.set("v.lackInventoryFamilyMap", component.get("v.lackInventoryFamilyMapTemp"));
            component.set("v.familyIdMapTemp", component.get("v.familyIdMapTemp"));
            component.set("v.lackInventoryFamilyListTemp", Object.keys(component.get("v.lackInventoryFamilyMapTemp")));
        }
    }
})