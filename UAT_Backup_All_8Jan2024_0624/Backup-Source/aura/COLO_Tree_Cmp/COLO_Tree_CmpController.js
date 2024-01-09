({
    doInit: function(component, event, helper){
        var dataObject = component.get("v.dataObject");
        var objectType = typeof dataObject;
        if(objectType == 'string')
            component.set("v.dataObject", JSON.parse(dataObject));
        var today = new Date();
        today = today.toLocaleString('en-US', {
            timeZone: 'America/New_York',
        });
        // Get the current date
        const currentDate = new Date(today);
        
        // Create an array to store month names
        const monthNames = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
        
        // Get the current month and year
        let currentMonth = currentDate.getMonth()-1; 
        let currentYear = currentDate.getFullYear();
        
        // Create an array to store the last 12 months' names
        const last12Months = [];
        // If we reach January, move to the previous year
        if (currentMonth < 0) {
            currentMonth = 11;
            currentYear--;
        }
        // Loop through the last 12 months
        for (let i = 0; i < 12; i++) {
            // Add the month name to the array
            last12Months.push({ name: `${monthNames[currentMonth]} ${currentYear}`, value: `${currentYear}-${(currentMonth + 1).toString().padStart(2, '0')}`});
    // Move to the previous month
    currentMonth--;
    // If we reach January, move to the previous year
    if (currentMonth < 0) {
    currentMonth = 11;
    currentYear--;
} 

 }
 console.log('last 12 Months: '+JSON.stringify(last12Months));
 // Sort the array based on the "value" property
 last12Months.sort((a, b) => (a.value > b.value) ? 1 : -1);

// Extract only the "name" property for the final result
const sortedMonthNames = last12Months.map(month => month.name);
var monthOptions = [];
for(var i=0; i<sortedMonthNames.length; i++){
    var obj = {};
    obj.label = sortedMonthNames[i];
    obj.value = sortedMonthNames[i];
    monthOptions.push(obj);
}
console.log('Inital: '+JSON.stringify(monthOptions));
component.set("v.monthOptions", monthOptions);
component.set("v.tempMonthOptions", monthOptions);
component.set("v.tempMonthOptions2", monthOptions);
helper.doInitStartHelper(component);
},
    resetPopup: function(component, event, helper) {
        console.log('Ok');
        component.set("v.selectedMonth", null);
        component.set("v.selectedId", null);
        component.set("v.changeTo", null);
        component.set("v.expandNPL", false);
        component.set("v.expandShareExpansion", false);
        component.set("v.expandPriceChange", false);
        component.set("v.isDataLoaded", false);
        var options = component.get("v.monthOptions");
        var values = component.get('v.values') || [];
        options.forEach( function(element, index) {	
            element.selected = false;
        });
        component.set('v.searchString','0 Month(s) selected');
        component.set('v.values', []);
        //component.set("v.monthOptions", options);
        console.log('tempMonthOptions: '+JSON.stringify(component.get("v.tempMonthOptions2")));
        component.set("v.monthOptions", component.get("v.tempMonthOptions2"));
        component.set("v.options", component.get("v.tempMonthOptions2"));
        console.log('monthOptions: '+JSON.stringify(component.get("v.monthOptions")));
        component.find("productDirectorLookup").fireChanging();
    },
        openAllOptyTimeSeries : function(component, event, helper){
            component.set("v.selectedTimeSeriesItem",'Time Series');
            component.set("v.showTimeSeries",true);
        },
            openNewPdLTimeSeries : function(component, event, helper){
                component.set("v.selectedTimeSeriesItem",'New Product Launch Time Series');
                component.set("v.showTimeSeries",true);
            },
                
                openSeTimeSeries : function(component, event, helper){
                    component.set("v.selectedTimeSeriesItem",'Share Expansion Time Series');
                    component.set("v.showTimeSeries",true);
                },
                    
                    openPcTimeSeries : function(component, event, helper){
                        component.set("v.selectedTimeSeriesItem",'Price Change Time Series');
                        component.set("v.showTimeSeries",true);
                    },
                        
                        openScmTimeSeries : function(component, event, helper){
                            component.set("v.selectedTimeSeriesItem",'Lack Of inventory COLO Time Series');
                            component.set("v.showTimeSeries",true);
                        },
                            closeTimeSeriesPopup : function(component, event, helper){
                                component.set("v.showTimeSeries",false);
                            },
            
            
        getData: function(component, event, helper){
            component.set("v.isSpinnerLoad", true);
            component.set("v.showFilterPopup", false);
            component.set("v.expandNPL", false);
            component.set("v.expandShareExpansion", false);
            component.set("v.expandPriceChange", false);
            var values = component.get("v.values");
            values.sort(function(a, b) {
                var dateA = new Date(a);
                var dateB = new Date(b);
                return dateA - dateB;
            });
            var selectedMonth = values.join(', ');
            component.set("v.selectedMonth", selectedMonth);
            var monthsList = []; var yearList = []; var selectedOptions = [];
            if(values != null){
                for(var i=0; i<values.length; i++){
                    var selectedMonth = values[i];
                    const monthNames = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
                    var month = ''; var year = '';
                    if(selectedMonth != null){
                        month = selectedMonth.split(' ')[0];
                        year = selectedMonth.split(' ')[1];
                    }
                    var monthNumber = parseInt(monthNames.indexOf(month))+1;   
                    monthsList.push(monthNumber);
                    yearList.push(year);
                    selectedOptions.push(monthNumber+' '+year);
                }
            }
            var action = component.get("c.getDataBasedOnQuarter");
            action.setParams({
                'month': monthsList,
                'year': yearList,
                'productType': component.get("v.selectedProductType"),
                'productDirector': component.get("v.selectedId")
            });
            action.setCallback(this, function(response){
                if(response.getState() == 'SUCCESS'){
                    var responseData = response.getReturnValue();
                    component.set("v.responseWrapper", responseData);
                    //console.log('Response: '+JSON.stringify(responseData));
                    component.set("v.selectedUserName", component.get("v.userName"));
                    if(responseData != null){
                        var NPLListCount = (responseData.NPLList != null ? responseData.NPLList.length : 0);
                        var ProActiveListCount = (responseData.ProActiveList != null ? responseData.ProActiveList.length : 0);
                        var ReActiveListCount = (responseData.ReActiveList != null ? responseData.ReActiveList.length : 0);
                        var ROFRListCount = (responseData.ROFRList != null ? responseData.ROFRList.length : 0);
                        var lackInventoryCount = (responseData.lackInventoryList != null ? responseData.lackInventoryList.length : 0);
                        var totalOpportunities = NPLListCount + ProActiveListCount + ReActiveListCount + ROFRListCount + lackInventoryCount;
                        var totalSales = responseData.NPLSales + responseData.ProActiveSales + responseData.ReActiveSales + responseData.ROFRSales;
                        var totalTPTSales = responseData.NPLTPTSales + responseData.ShareExpansionTPTSales + responseData.PriceChangeTPTSales;
                        if(totalSales != 0 && totalSales != null) {
                            const totalSalesInMillions = helper.formatCurrencyMethod(component, event, helper, totalSales);
                            //console.log('totalSalesInMillions: '+totalSalesInMillions);
                            if(totalSalesInMillions == '$NaNM')
                                component.set("v.dataObject.totalSales", '$' + 0 + 'M');  
                            else 
                                component.set("v.dataObject.totalSales", totalSalesInMillions);  
                        } else
                            component.set("v.dataObject.totalSales", '$' + 0 + 'M');
                        if(totalTPTSales != 0 && totalTPTSales != null) {
                            const totalSalesInMillions = helper.formatCurrencyMethod(component, event, helper, totalTPTSales); 
                            if(totalSalesInMillions == '$NaNM')
                                component.set("v.dataObject.totalTPTSales", '$' + 0 + 'M');  
                            else 
                                component.set("v.dataObject.totalTPTSales", totalSalesInMillions);    
                        } else
                            component.set("v.dataObject.totalTPTSales", '$' + 0 + 'M');
                        
                        component.set("v.dataObject.totalOpportunities", totalOpportunities);
                        component.set("v.dataObject.totalNPLCount", NPLListCount);
                        component.set("v.dataObject.totalShareExpansionCount", (ProActiveListCount+ReActiveListCount));
                        component.set("v.dataObject.totalPriceChangeCount", ROFRListCount);
                        component.set("v.dataObject.totalLackInventoryCount", lackInventoryCount);
                        
                        if(responseData.NPLSales != 0 && responseData.NPLSales != null) {
                            const totalSalesInMillions = helper.formatCurrencyMethod(component, event, helper, responseData.NPLSales); 
                            if(totalSalesInMillions == '$NaNM')
                                component.set("v.dataObject.totalNPLSales", '$' + 0 + 'M');  
                            else 
                                component.set("v.dataObject.totalNPLSales", totalSalesInMillions);
                        } else
                            component.set("v.dataObject.totalNPLSales", '$' + 0 + 'M');
                        
                        if(responseData.NPLTPTSales != 0 && responseData.NPLTPTSales != null) {
                            const totalSalesInMillions = helper.formatCurrencyMethod(component, event, helper, responseData.NPLTPTSales); 
                            if(totalSalesInMillions == '$NaNM')
                                component.set("v.dataObject.totalNPLTPTSales", '$' + 0 + 'M');  
                            else 
                                component.set("v.dataObject.totalNPLTPTSales", totalSalesInMillions);
                        } else
                            component.set("v.dataObject.totalNPLTPTSales", '$' + 0 + 'M');
                        
                        if((responseData.ProActiveSales + responseData.ReActiveSales) != 0 && (responseData.ProActiveSales + responseData.ReActiveSales) != null) {
                            const totalSalesInMillions = helper.formatCurrencyMethod(component, event, helper, (responseData.ProActiveSales + responseData.ReActiveSales));
                            if(totalSalesInMillions == '$NaNM')
                                component.set("v.dataObject.totalShareExpansionSales", '$' + 0 + 'M');  
                            else 
                                component.set("v.dataObject.totalShareExpansionSales", totalSalesInMillions);
                        } else
                            component.set("v.dataObject.totalShareExpansionSales", '$' + 0 + 'M');
                        
                        if(responseData.ShareExpansionTPTSales != 0 && responseData.ShareExpansionTPTSales != null) {
                            const totalSalesInMillions = helper.formatCurrencyMethod(component, event, helper, responseData.ShareExpansionTPTSales); 
                            if(totalSalesInMillions == '$NaNM')
                                component.set("v.dataObject.totalShareExpansionTPTSales", '$' + 0 + 'M');  
                            else 
                                component.set("v.dataObject.totalShareExpansionTPTSales", totalSalesInMillions);
                        } else
                            component.set("v.dataObject.totalShareExpansionTPTSales", '$' + 0 + 'M');
                        
                        if(responseData.ROFRSales != 0 && responseData.ROFRSales != null) {
                            const totalSalesInMillions = helper.formatCurrencyMethod(component, event, helper, responseData.ROFRSales); 
                            if(totalSalesInMillions == '$NaNM')
                                component.set("v.dataObject.totalPriceChangeSales", '$' + 0 + 'M');  
                            else 
                                component.set("v.dataObject.totalPriceChangeSales", totalSalesInMillions);
                        } else
                            component.set("v.dataObject.totalPriceChangeSales", '$' + 0 + 'M');
                        
                        if(responseData.PriceChangeTPTSales != 0 && responseData.PriceChangeTPTSales != null) {
                            const totalSalesInMillions = helper.formatCurrencyMethod(component, event, helper, responseData.PriceChangeTPTSales); 
                            if(totalSalesInMillions == '$NaNM')
                                component.set("v.dataObject.totalPriceChangeTPTSales", '$' + 0 + 'M');  
                            else 
                                component.set("v.dataObject.totalPriceChangeTPTSales", totalSalesInMillions);
                        } else
                            component.set("v.dataObject.totalPriceChangeTPTSales", '$' + 0 + 'M');
                        
                        var shareExpansionList = [];
                        if(responseData.ProActiveList != null && responseData.ReActiveList != null)
                        	shareExpansionList = [...responseData.ProActiveList, ...responseData.ReActiveList];
                        else if(responseData.ProActiveList != null)
                            shareExpansionList = responseData.ProActiveList;
                        else if(responseData.ReActiveList != null)
                            shareExpansionList = responseData.ReActiveList;
                        component.set("v.shareExpansionList", shareExpansionList);
                        component.set("v.priceChangeList", responseData.ROFRList); 
                        var lackInventoryList = responseData.lackInventoryList;
                        var lackInventorySummaryMap = {};
                        var netCOLO = 0; var netTPTDollar = 0;
                        if(lackInventoryList != null){
                            component.set("v.inventoryProductCount", lackInventoryList.length);
                            var totalCOLO = 0; var totalTPTDollar = 0;
                            for(var i=0; i<lackInventoryList.length; i++){
                                var calculatedCOLO = (lackInventoryList[i].Phoenix_Latest_Estimate__c != null ? lackInventoryList[i].Phoenix_Latest_Estimate__c : 0) * (lackInventoryList[i].Phoenix_Final_Total_Selling_Unit__c != null ? lackInventoryList[i].Phoenix_Final_Total_Selling_Unit__c: 0);
                                lackInventoryList[i].COLO = 0;
                                lackInventoryList[i].calculatedCOLO = calculatedCOLO;
                                lackInventoryList[i].grossCOLO = 0;
                                if(lackInventoryList[i].Phoenix_Net_Sales_Internal__c == 0){
                                    lackInventoryList[i].COLO = calculatedCOLO;
                                    lackInventoryList[i].revisedCOLO = calculatedCOLO;
                                    lackInventoryList[i].grossCOLO = calculatedCOLO;
                                    lackInventoryList[i].adjustedCOLO = lackInventoryList[i].revisedCOLO * (0.5);
                                } else if(lackInventoryList[i].Phoenix_Net_Sales_Internal__c > 0){
                                    var netSales = (lackInventoryList[i].Phoenix_Net_Sales_Internal__c != null ? lackInventoryList[i].Phoenix_Net_Sales_Internal__c:0);
                                    if(netSales > (calculatedCOLO * (130/100))){
                                        lackInventoryList[i].grossCOLO = calculatedCOLO;
                                        lackInventoryList[i].adjustedCOLO = calculatedCOLO * (0.5);
                                    } else{
                                    	lackInventoryList[i].grossCOLO = netSales;    
                                        lackInventoryList[i].adjustedCOLO = netSales * (0.5);
                                    }
                                }
                                var tptDollar = lackInventoryList[i].grossCOLO - ((lackInventoryList[i].Phoenix_Throughput_cost__c != null ? lackInventoryList[i].Phoenix_Throughput_cost__c:0) * (lackInventoryList[i].Phoenix_Final_Total_Selling_Unit__c != null ? lackInventoryList[i].Phoenix_Final_Total_Selling_Unit__c: 0));
                                lackInventoryList[i].tptDollar = tptDollar;
                                lackInventoryList[i].tptPercent = (tptDollar/lackInventoryList[i].grossCOLO)*100;
                                var threshold = 0;
                                if(lackInventoryList[i].Phoenix_Is_partner_product__c)
                                    threshold = parseFloat(25);
                                else
                                    threshold = parseFloat(40);
                                if(lackInventoryList[i].tptPercent < threshold){
                                    lackInventoryList[i].finalCOLO = 0; 
                                    lackInventoryList[i].netCOLO = 0;
                                } else if(lackInventoryList[i].tptPercent > threshold){
                                    lackInventoryList[i].finalCOLO = lackInventoryList[i].grossCOLO;
                                    lackInventoryList[i].netCOLO = lackInventoryList[i].adjustedCOLO;
                                    lackInventoryList[i].netTPTDollar = (lackInventoryList[i].netCOLO * (lackInventoryList[i].tptPercent)/100);
                                    netCOLO += ((lackInventoryList[i].netCOLO != null && !isNaN(lackInventoryList[i].netCOLO)) ? parseFloat(lackInventoryList[i].netCOLO) : 0);
                                    netTPTDollar += ((lackInventoryList[i].netTPTDollar != null && !isNaN(lackInventoryList[i].netTPTDollar)) ? parseFloat(lackInventoryList[i].netTPTDollar) : 0);
                                }
                                totalCOLO += ((lackInventoryList[i].netCOLO != null && !isNaN(lackInventoryList[i].netCOLO)) ? parseFloat(lackInventoryList[i].netCOLO) : 0);
                                totalTPTDollar += ((lackInventoryList[i].netTPTDollar != null && !isNaN(lackInventoryList[i].netTPTDollar)) ? parseFloat(lackInventoryList[i].netTPTDollar) : 0);
                            }
                        }
                        lackInventorySummaryMap.netCOLO = netCOLO;
                        lackInventorySummaryMap.netTPTDollar = netTPTDollar;
                        if(totalSales != 0 && totalSales != null && netCOLO != 0 && netCOLO != null) {
                            const totalSalesInMillions = helper.formatCurrencyMethod(component, event, helper, totalSales+netCOLO);
                            //console.log('totalSalesInMillions: '+totalSalesInMillions);
                            if(totalSalesInMillions == '$NaNM')
                                component.set("v.dataObject.totalSales", '$' + 0 + 'M');  
                            else 
                                component.set("v.dataObject.totalSales", totalSalesInMillions);  
                        } else
                            component.set("v.dataObject.totalSales", '$' + 0 + 'M');
                        
                        if(totalTPTSales != 0 && totalTPTSales != null && netTPTDollar != 0 && netTPTDollar != null) {
                            const totalSalesInMillions = helper.formatCurrencyMethod(component, event, helper, totalTPTSales+netTPTDollar); 
                            if(totalSalesInMillions == '$NaNM')
                                component.set("v.dataObject.totalTPTSales", '$' + 0 + 'M');  
                            else 
                                component.set("v.dataObject.totalTPTSales", totalSalesInMillions);    
                        } else
                            component.set("v.dataObject.totalTPTSales", '$' + 0 + 'M');
                        
                        if(netCOLO != 0 && netCOLO != null) {
                            const totalSalesInMillions = helper.formatCurrencyMethod(component, event, helper, netCOLO); 
                            if(totalSalesInMillions == '$NaNM')
                                component.set("v.dataObject.netCOLO", '$' + 0 + 'M');  
                            else 
                                component.set("v.dataObject.netCOLO", totalSalesInMillions);    
                        } else
                            component.set("v.dataObject.netCOLO", '$' + 0 + 'M');
                        if(netTPTDollar != 0 && netTPTDollar != null) {
                            const totalSalesInMillions = helper.formatCurrencyMethod(component, event, helper, netTPTDollar); 
                            if(totalSalesInMillions == '$NaNM')
                                component.set("v.dataObject.netTPTDollar", '$' + 0 + 'M');  
                            else 
                                component.set("v.dataObject.netTPTDollar", totalSalesInMillions);    
                        } else
                            component.set("v.dataObject.netTPTDollar", '$' + 0 + 'M');
                        
                        component.set("v.dataObject.totalOpportunities", totalOpportunities);
                        component.set("v.lackInventorySummaryMap", lackInventorySummaryMap);
                        component.set("v.lackInventoryList", responseData.lackInventoryList);
                        var lackInventoryList = responseData.lackInventoryList;
                        var familyList = [];
                        for(var i=0; i<lackInventoryList.length; i++){
                            if(!familyList.includes(lackInventoryList[i].Product_Family_Name__c)){
                                familyList.push(lackInventoryList[i].Product_Family_Name__c);
                            }
                        }
                        var action = component.get("c.getExistingSupplyIssues");
                        action.setParams({
                            'familyList': familyList,
                            'selectedMonth': component.get("v.selectedMonth")
                        });
                        action.setCallback(this, function(response){
                            if(response.getState() == 'SUCCESS'){
                                var response = response.getReturnValue();
                                if(response != null){
                                    component.set("v.supplyFamilyIssueMap", response); 
                                    component.set("v.isSpinnerLoad", false);
                                    component.set("v.isDataLoaded", true);
                                }
                            } else{
                                component.set("v.isSpinnerLoad", false);
                                component.set("v.isDataLoaded", false);
                                console.log("Exception: "+JSON.stringify(response.getError()));
                            }
                        });
                        $A.enqueueAction(action);
                        
                    }
                } else{
                    component.set("v.isSpinnerLoad", false);
                    component.set("v.showFilterPopup", true);
                    component.set("v.isDataLoaded", false);
                    console.log("Exception: "+JSON.stringify(response.getError()));
                }
            });
            $A.enqueueAction(action);
        },
            expandAllOpportunities: function(component, event, helper){
                component.set("v.expandAllOpportunities", !component.get("v.expandAllOpportunities"));
                component.set("v.expandNPL", false);
                component.set("v.expandShareExpansion", false);
                component.set("v.expandPriceChange", false);
            },
            expandShareExpansion: function(component, event, helper){
                component.set("v.expandShareExpansion", !component.get("v.expandShareExpansion"));
            },
            expandPriceChange: function(component, event, helper){
                component.set("v.expandPriceChange", !component.get("v.expandPriceChange"));
            },
    onclickNPL : function(component, event, helper) {
        component.set("v.selectedSection", 'New Product Launch');
        component.set("v.expandNPL", !component.get("v.expandNPL"));
        component.set("v.expandShareExpansion", false);
        component.set("v.expandPriceChange", false);
        var tabUrl = window.location.origin+'/lightning/n/COLO_NPL';
        //window.open(tabUrl, '_blank');
        /*var scrollToDiv = component.find("scrollToDiv").getElement();
        if (scrollToDiv) {
            scrollToDiv.scrollIntoView({ behavior: "smooth" });
        }*/
        setTimeout(function() {
            window.scrollTo({
                top: 480,
                behavior: 'smooth' // Optional: Add smooth scrolling effect
            });
        }, 500);
    },
    onclickSE : function(component, event, helper) {
        component.set("v.selectedSection", 'Share Expansion');
        var tabUrl = window.location.origin+'/lightning/n/COLO_SE';
        component.set("v.expandShareExpansion", !component.get("v.expandShareExpansion"));
        component.set("v.expandNPL", false);
        component.set("v.expandPriceChange", false);
        //window.open(tabUrl, '_blank');
        setTimeout(function() {
            window.scrollTo({
                top: 480,
                behavior: 'smooth' // Optional: Add smooth scrolling effect
            });
        }, 500);
    },
    onclickPC : function(component, event, helper) {
        component.set("v.selectedSection", 'Price Change');
        var tabUrl = window.location.origin+'/lightning/n/COLO_Price_Change';
        component.set("v.expandPriceChange", !component.get("v.expandPriceChange"));
        component.set("v.expandShareExpansion", false);
        component.set("v.expandNPL", false);
        //window.open(tabUrl, '_blank');
        setTimeout(function() {
            window.scrollTo({
                top: 480,
                behavior: 'smooth' // Optional: Add smooth scrolling effect
            });
        }, 500);
    },
        openAllOpportunitiesPopup: function(component, event, helper){
            var responseData = component.get("v.responseWrapper");
            var totalOpportunitiesList = [...responseData.NPLList, ...responseData.ROFRList, ...responseData.ProActiveList, ...responseData.ReActiveList];
            component.set("v.productSearchString", '');
            component.set("v.customerSearchString", '');
            component.set("v.selectedPopup", 'All Opportunities');
            var optyWonList = []; var optyLostList = [];
            var totalOptyAwardedSales = 0; var totalOptyAwardedGM = 0;
            var totalOptyProposedSales = 0; var totalOptyProposedGM = 0;
            if(totalOpportunitiesList != null){
                for(var i=0; i<totalOpportunitiesList.length; i++){
                    var awardedQty = ((totalOpportunitiesList[i].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c != null) ? totalOpportunitiesList[i].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c : 0);
                    var proposedASP = ((totalOpportunitiesList[i].Phoenix_Proposed_ASP_Dose__c != null) ? totalOpportunitiesList[i].Phoenix_Proposed_ASP_Dose__c : 0);
                    var proposedQty = ((totalOpportunitiesList[i].Phoenix_Final_Total_Selling_Unit__c != null) ? totalOpportunitiesList[i].Phoenix_Final_Total_Selling_Unit__c : 0);
                    var awardedSales = awardedQty*proposedASP;                 
                    var currentSales = 0;
                    if(totalOpportunitiesList[i].Phoenix_Bid_Template_Refrence__c == 'ClarusOne')
                        currentSales = (totalOpportunitiesList[i].Phoenix_Net_Sales_External__c != null ? totalOpportunitiesList[i].Phoenix_Net_Sales_External__c : 0) ;
                    else
                        currentSales = (totalOpportunitiesList[i].Finance_Current_Sales__c != null ? totalOpportunitiesList[i].Finance_Current_Sales__c : (totalOpportunitiesList[i].Phoenix_Current_Sales_Finance__c != null ? totalOpportunitiesList[i].Phoenix_Current_Sales_Finance__c : 0) );
                    var proposedSales = (totalOpportunitiesList[i].Phoenix_Proposed_Sales__c != null ? totalOpportunitiesList[i].Phoenix_Proposed_Sales__c : 0);
                    var awardedTPT = ((totalOpportunitiesList[i].Phoenix_Total_DRL_Share__c != null) ? totalOpportunitiesList[i].Phoenix_Total_DRL_Share__c : 0);
                    var proposedTPT = ((totalOpportunitiesList[i].Phoenix_Total_DRL_Share__c != null) ? totalOpportunitiesList[i].Phoenix_Total_DRL_Share__c : 0);
                    var currentTPT = (totalOpportunitiesList[i].Phoenix_Current_TP_Margin__c != null ? totalOpportunitiesList[i].Phoenix_Current_TP_Margin__c : 0);
                    
                    var awardedTPTPercent = awardedTPT/(proposedASP*awardedQty);
                    var proposedTPTPercent = proposedTPT/proposedSales;
                    //scmWrapperObj.currentTPT/(scmWrapperObj.currentDeadnet * scmWrapperObj.awardedQty)
                    totalOpportunitiesList[i].awardedQty = awardedQty;
                    totalOpportunitiesList[i].proposedASP = proposedASP;
                    totalOpportunitiesList[i].currentSales = currentSales;
                    totalOpportunitiesList[i].proposedQty = proposedQty;
                    totalOpportunitiesList[i].awardedSales = (awardedSales - currentSales);
                    totalOpportunitiesList[i].awardedTPT = (awardedTPT - currentTPT);
                    totalOpportunitiesList[i].proposedTPT = (proposedTPT - currentTPT);
                    totalOpportunitiesList[i].awardedTPTPercent = awardedTPTPercent;
                    totalOpportunitiesList[i].proposedTPTPercent = proposedTPTPercent;
                    totalOpportunitiesList[i].proposedSales = (proposedSales-currentSales);
                    if(totalOpportunitiesList[i].Customer_Response_Lines__r != null && totalOpportunitiesList[i].Customer_Response_Lines__r.length > 0 && totalOpportunitiesList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Awarded'){
                        totalOptyAwardedSales += totalOpportunitiesList[i].awardedSales;
                        totalOptyAwardedGM += totalOpportunitiesList[i].awardedTPT;
                        optyWonList.push(totalOpportunitiesList[i]);
                    } else if(totalOpportunitiesList[i].Customer_Response_Lines__r != null && totalOpportunitiesList[i].Customer_Response_Lines__r.length > 0 && totalOpportunitiesList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Declined by Customer'){
                        totalOptyProposedSales += totalOpportunitiesList[i].proposedSales;
                        totalOptyProposedGM += totalOpportunitiesList[i].proposedTPT;
                        optyLostList.push(totalOpportunitiesList[i]);
                    }
                }
                component.set("v.dataObject.totalOptyAwardedSales", totalOptyAwardedSales);
                component.set("v.dataObject.totalOptyAwardedGM", totalOptyAwardedGM);
                component.set("v.dataObject.totalOptyProposedSales", totalOptyProposedSales);
                component.set("v.dataObject.totalOptyProposedGM", totalOptyProposedGM);
                var closePopup = true;
                helper.openPopup(component, event, helper, optyWonList, optyLostList, closePopup);
            }
        },
    handleClick: function(component, event, helper){
        component.set("v.showFilterPopup", !component.get("v.showFilterPopup"));
    },
    handleProductTypeChange: function(component, event, helper){
        
    },
    //search option in picklist
    filterOptions : function( component, event, helper ) {
        if( !$A.util.isEmpty(component.get('v.searchString')) ) {
            helper.filterOptionsDataHelper(component);
        } else {
            $A.util.removeClass(component.find('resultsDiv'),'slds-is-open');
            component.set("v.showUL", false);
        }
    },
     
    // option selected
    selectItem : function( component, event, helper ) {
        if(!$A.util.isEmpty(event.currentTarget.id)) {
            helper.selectOptionHelper(component, event);
        }
    },

    passValue : function(component, event, helper) {
        var passValueEvent = component.getEvent("passValueEvent");
        passValueEvent.setParams({"value" : component.get("v.childValue")});
        passValueEvent.fire();
    }, 
    showOptions : function( component, event, helper ) {
        var selectedOptions = component.get("v.values");
        component.set("v.values", selectedOptions);
        var disabled = component.get("v.disabled");
        if(!disabled) {
            component.set("v.message", '');
            component.set('v.searchString', '');
            var options = component.get("v.tempMonthOptions");
            options.forEach( function(element,index) {
                if(selectedOptions == null || selectedOptions == undefined){
                 	element.selected = false;
                }
                else {
                    if(selectedOptions.includes(element.value)){
                        element.selected = true;
                    } else{
                        element.selected = false;
                    }
                    element.isVisible = true;
                }   
            });
            component.set("v.monthOptions", options);
            if(!$A.util.isEmpty(component.get('v.monthOptions'))) {
                $A.util.addClass(component.find('resultsDiv'),'slds-is-open');
                component.set("v.showUL", true);
            } 
        }
    },
     
    // To remove the selected item.
    closePill : function( component, event, helper ){
        helper.removeOptionPillHelper(component, event);
    },
        handleChange:function( component, event, helper ){
            var selectedRecordId = component.get("v.selectedId");
            if(selectedRecordId != null && selectedRecordId != ''){
                var action = component.get("c.getUserName");
                action.setParams({
                    'userId': selectedRecordId
                });
                action.setCallback(this, function(response){
                    if(response.getState() == 'SUCCESS'){
                        var response = response.getReturnValue();
                        component.set("v.userName", response);
                    } else{
                        console.log("Exception: "+JSON.stringify(response.getError()));
                    }
                });
                $A.enqueueAction(action);   
            }
        },
     
    // To close the dropdown if clicked outside the dropdown.
    handleBlur : function( component, event, helper ){
        helper.handleBlurHelper(component, event);
    },
    closeNPLPopup: function(component, event, helper){
        component.set("v.showPopup", false)  ;
        component.set("v.productSearchString", '');
        component.set("v.customerSearchString", '');
    },
        openNPLPopup: function(component, event, helper){
            component.set("v.productSearchString", '');
            component.set("v.customerSearchString", '');
            component.set("v.selectedPopup", 'New Product Launch Bids');
            var NPLList = component.get("v.responseWrapper.NPLList");
            var optyWonList = []; var optyLostList = [];
            var totalOptyAwardedSales = 0; var totalOptyAwardedGM = 0;
            var totalOptyProposedSales = 0; var totalOptyProposedGM = 0;
            if(NPLList != null){
                for(var i=0; i<NPLList.length; i++){
                    var awardedQty = ((NPLList[i].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c != null) ? NPLList[i].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c : 0);
                    var proposedASP = ((NPLList[i].Phoenix_Proposed_ASP_Dose__c != null) ? NPLList[i].Phoenix_Proposed_ASP_Dose__c : 0);
                    var proposedQty = ((NPLList[i].Phoenix_Final_Total_Selling_Unit__c != null) ? NPLList[i].Phoenix_Final_Total_Selling_Unit__c : 0);
                    var awardedSales = awardedQty*proposedASP;                 
                    var currentSales = 0;
                    if(NPLList[i].Phoenix_Bid_Template_Refrence__c == 'ClarusOne')
                        currentSales = (NPLList[i].Phoenix_Net_Sales_External__c != null ? NPLList[i].Phoenix_Net_Sales_External__c : 0) ;
                    else
                        currentSales = (NPLList[i].Finance_Current_Sales__c != null ? NPLList[i].Finance_Current_Sales__c : (NPLList[i].Phoenix_Current_Sales_Finance__c != null ? NPLList[i].Phoenix_Current_Sales_Finance__c : 0) );
                    var proposedSales = (NPLList[i].Phoenix_Proposed_Sales__c != null ? NPLList[i].Phoenix_Proposed_Sales__c : 0);
                    var awardedTPT = ((NPLList[i].Phoenix_Total_DRL_Share__c != null) ? NPLList[i].Phoenix_Total_DRL_Share__c : 0);
                    var proposedTPT = ((NPLList[i].Phoenix_Total_DRL_Share__c != null) ? NPLList[i].Phoenix_Total_DRL_Share__c : 0);
                    var currentTPT = (NPLList[i].Phoenix_Current_TP_Margin__c != null ? NPLList[i].Phoenix_Current_TP_Margin__c : 0);
                    
                    var awardedTPTPercent = awardedTPT/(proposedASP*awardedQty);
                    var proposedTPTPercent = proposedTPT/proposedSales;
                    //scmWrapperObj.currentTPT/(scmWrapperObj.currentDeadnet * scmWrapperObj.awardedQty)
                    NPLList[i].awardedQty = awardedQty;
                    NPLList[i].proposedASP = proposedASP;
                    NPLList[i].currentSales = currentSales;
                    NPLList[i].proposedQty = proposedQty;
                    NPLList[i].awardedSales = (awardedSales - currentSales);
                    NPLList[i].awardedTPT = (awardedTPT - currentTPT);
                    NPLList[i].proposedTPT = (proposedTPT - currentTPT);
                    NPLList[i].awardedTPTPercent = awardedTPTPercent;
                    NPLList[i].proposedTPTPercent = proposedTPTPercent;
                    NPLList[i].proposedSales = (proposedSales-currentSales);
                    if(NPLList[i].Customer_Response_Lines__r != null && NPLList[i].Customer_Response_Lines__r.length > 0 && NPLList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Awarded'){
                        totalOptyAwardedSales += NPLList[i].awardedSales;
                        totalOptyAwardedGM += NPLList[i].awardedTPT;
                        optyWonList.push(NPLList[i]);
                    } else if(NPLList[i].Customer_Response_Lines__r != null && NPLList[i].Customer_Response_Lines__r.length > 0 && NPLList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Declined by Customer'){
                        totalOptyProposedSales += NPLList[i].proposedSales;
                        totalOptyProposedGM += NPLList[i].proposedTPT;
                        optyLostList.push(NPLList[i]);
                    }
                }
                component.set("v.dataObject.totalOptyAwardedSales", totalOptyAwardedSales);
                component.set("v.dataObject.totalOptyAwardedGM", totalOptyAwardedGM);
                component.set("v.dataObject.totalOptyProposedSales", totalOptyProposedSales);
                component.set("v.dataObject.totalOptyProposedGM", totalOptyProposedGM);
                var closePopup = true;
            helper.openPopup(component, event, helper, optyWonList, optyLostList, closePopup);
        }
    },
    openSEPopup: function(component, event, helper){
        component.set("v.productSearchString", '');
        component.set("v.customerSearchString", '');
        component.set("v.selectedPopup", 'Share Expansion Bids');
        var NPLList = component.get("v.shareExpansionList");
        var optyWonList = []; var optyLostList = [];
        var totalOptyAwardedSales = 0; var totalOptyAwardedGM = 0;
        var totalOptyProposedSales = 0; var totalOptyProposedGM = 0;
        console.log('Total Length: '+NPLList.length);
        if(NPLList != null){
            for(var i=0; i<NPLList.length; i++){
                console.log('i: '+(i+1));
                console.log('Phoenix_Bid_Template_Refrence__c: '+JSON.stringify(NPLList[i]));
                var awardedQty = ((NPLList[i].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c != null) ? NPLList[i].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c : 0);
                var proposedASP = ((NPLList[i].Phoenix_Proposed_ASP_Dose__c != null) ? NPLList[i].Phoenix_Proposed_ASP_Dose__c : 0);
                var proposedQty = ((NPLList[i].Phoenix_Final_Total_Selling_Unit__c != null) ? NPLList[i].Phoenix_Final_Total_Selling_Unit__c : 0);
                var awardedSales = awardedQty*proposedASP;                 
                var currentSales = 0;
                if(NPLList[i].Phoenix_Bid_Template_Refrence__c == 'ClarusOne')
                    currentSales = (NPLList[i].Phoenix_Net_Sales_External__c != null ? NPLList[i].Phoenix_Net_Sales_External__c : 0) ;
                else
                    currentSales = (NPLList[i].Finance_Current_Sales__c != null ? NPLList[i].Finance_Current_Sales__c : (NPLList[i].Phoenix_Current_Sales_Finance__c != null ? NPLList[i].Phoenix_Current_Sales_Finance__c : 0) );
                var proposedSales = (NPLList[i].Phoenix_Proposed_Sales__c != null ? NPLList[i].Phoenix_Proposed_Sales__c : 0);
                var awardedTPT = ((NPLList[i].Phoenix_Total_DRL_Share__c != null) ? NPLList[i].Phoenix_Total_DRL_Share__c : 0);
                var proposedTPT = ((NPLList[i].Phoenix_Total_DRL_Share__c != null) ? NPLList[i].Phoenix_Total_DRL_Share__c : 0);
                var currentTPT = (NPLList[i].Phoenix_Current_TP_Margin__c != null ? NPLList[i].Phoenix_Current_TP_Margin__c : 0);
                
                var awardedTPTPercent = awardedTPT/(proposedASP*awardedQty);
                var proposedTPTPercent = proposedTPT/proposedSales;
                //scmWrapperObj.currentTPT/(scmWrapperObj.currentDeadnet * scmWrapperObj.awardedQty)
                NPLList[i].awardedQty = awardedQty;
                NPLList[i].proposedASP = proposedASP;
                NPLList[i].currentSales = currentSales;
                NPLList[i].proposedQty = proposedQty;
                NPLList[i].awardedSales = (awardedSales - currentSales);
                NPLList[i].awardedTPT = (awardedTPT - currentTPT);
                NPLList[i].proposedTPT = (proposedTPT - currentTPT);
                NPLList[i].awardedTPTPercent = awardedTPTPercent;
                NPLList[i].proposedTPTPercent = proposedTPTPercent;
                NPLList[i].proposedSales = (awardedSales-currentSales);
                if(NPLList[i].Customer_Response_Lines__r != null && NPLList[i].Customer_Response_Lines__r.length > 0 && NPLList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Awarded'){
                    totalOptyAwardedSales += NPLList[i].awardedSales;
                    totalOptyAwardedGM += NPLList[i].awardedTPT;
                    optyWonList.push(NPLList[i]);
                } else if(NPLList[i].Customer_Response_Lines__r != null && NPLList[i].Customer_Response_Lines__r.length > 0 && NPLList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Declined by Customer'){
                    totalOptyProposedSales += NPLList[i].proposedSales;
                    totalOptyProposedGM += NPLList[i].proposedTPT;
                    optyLostList.push(NPLList[i]);
                }
            }
            component.set("v.dataObject.totalOptyAwardedSales", totalOptyAwardedSales);
            component.set("v.dataObject.totalOptyAwardedGM", totalOptyAwardedGM);
            component.set("v.dataObject.totalOptyProposedSales", totalOptyProposedSales);
            component.set("v.dataObject.totalOptyProposedGM", totalOptyProposedGM);
            var closePopup = true;
            helper.openPopup(component, event, helper, optyWonList, optyLostList, closePopup);
        }
    },
        openPCPopup: function(component, event, helper){
            component.set("v.productSearchString", '');
            component.set("v.customerSearchString", '');
            component.set("v.selectedPopup", 'Price Change Bids');
            var NPLList = component.get("v.priceChangeList");
            var optyWonList = []; var optyLostList = [];
            var totalOptyAwardedSales = 0; var totalOptyAwardedGM = 0;
            var totalOptyProposedSales = 0; var totalOptyProposedGM = 0;
            if(NPLList != null){
                for(var i=0; i<NPLList.length; i++){
                    var awardedQty = ((NPLList[i].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c != null) ? NPLList[i].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c : 0);
                    var proposedASP = ((NPLList[i].Phoenix_Proposed_ASP_Dose__c != null) ? NPLList[i].Phoenix_Proposed_ASP_Dose__c : 0);
                    var proposedQty = ((NPLList[i].Phoenix_Final_Total_Selling_Unit__c != null) ? NPLList[i].Phoenix_Final_Total_Selling_Unit__c : 0);
                    var awardedSales = awardedQty*proposedASP;                 
                    var currentSales = 0;
                    if(NPLList[i].Phoenix_Bid_Template_Refrence__c == 'ClarusOne')
                        currentSales = (NPLList[i].Phoenix_Net_Sales_External__c != null ? NPLList[i].Phoenix_Net_Sales_External__c : 0) ;
                    else
                        currentSales = (NPLList[i].Finance_Current_Sales__c != null ? NPLList[i].Finance_Current_Sales__c : (NPLList[i].Phoenix_Current_Sales_Finance__c != null ? NPLList[i].Phoenix_Current_Sales_Finance__c : 0) );
                    var proposedSales = (NPLList[i].Phoenix_Proposed_Sales__c != null ? NPLList[i].Phoenix_Proposed_Sales__c : 0);
                    var awardedTPT = ((NPLList[i].Phoenix_Total_DRL_Share__c != null) ? NPLList[i].Phoenix_Total_DRL_Share__c : 0);
                    var proposedTPT = ((NPLList[i].Phoenix_Total_DRL_Share__c != null) ? NPLList[i].Phoenix_Total_DRL_Share__c : 0);
                    var currentTPT = (NPLList[i].Phoenix_Current_TP_Margin__c != null ? NPLList[i].Phoenix_Current_TP_Margin__c : 0);
                    
                    var awardedTPTPercent = awardedTPT/(proposedASP*awardedQty);
                    var proposedTPTPercent = proposedTPT/proposedSales;
                    //scmWrapperObj.currentTPT/(scmWrapperObj.currentDeadnet * scmWrapperObj.awardedQty)
                    NPLList[i].awardedQty = awardedQty;
                    NPLList[i].proposedASP = proposedASP;
                    NPLList[i].currentSales = currentSales;
                    NPLList[i].proposedQty = proposedQty;
                    NPLList[i].awardedSales = (awardedSales - currentSales);
                    NPLList[i].awardedTPT = (awardedTPT - currentTPT);
                    NPLList[i].proposedTPT = (proposedTPT - currentTPT);
                    NPLList[i].awardedTPTPercent = awardedTPTPercent;
                    NPLList[i].proposedTPTPercent = proposedTPTPercent;
                    NPLList[i].proposedSales = (proposedSales-currentSales);
                if(NPLList[i].Customer_Response_Lines__r != null && NPLList[i].Customer_Response_Lines__r.length > 0 && NPLList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Awarded'){
                    totalOptyAwardedSales += NPLList[i].awardedSales;
                    totalOptyAwardedGM += NPLList[i].awardedTPT;
                    optyWonList.push(NPLList[i]);
                } else if(NPLList[i].Customer_Response_Lines__r != null && NPLList[i].Customer_Response_Lines__r.length > 0 && NPLList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Declined by Customer'){
                    totalOptyProposedSales += NPLList[i].proposedSales;
                    totalOptyProposedGM += NPLList[i].proposedTPT;
                    optyLostList.push(NPLList[i]);
                }
                }
                component.set("v.dataObject.totalOptyAwardedSales", totalOptyAwardedSales);
                component.set("v.dataObject.totalOptyAwardedGM", totalOptyAwardedGM);
                component.set("v.dataObject.totalOptyProposedSales", totalOptyProposedSales);
                component.set("v.dataObject.totalOptyProposedGM", totalOptyProposedGM);
                var closePopup = true;
                helper.openPopup(component, event, helper, optyWonList, optyLostList, closePopup);
        }
    },
    searchWon: function(component, event, helper){
        var productSearchString = component.get("v.productSearchString");
        var customerSearchString = component.get("v.customerSearchString");
        var selectedPopup = component.get("v.selectedPopup");
        var dataList = [];
        if(selectedPopup == 'New Product Launch Bids'){
            dataList = component.get("v.responseWrapper.NPLList");
        } else if(selectedPopup == 'Share Expansion Bids'){
            dataList = component.get("v.shareExpansionList");
        } else if(selectedPopup == 'Price Change Bids'){
            dataList = component.get("v.priceChangeList");
        } else if(selectedPopup == 'All Opportunities'){
            var responseData = component.get("v.responseWrapper");
            dataList = [...responseData.NPLList, ...responseData.ROFRList, ...responseData.ProActiveList, ...responseData.ReActiveList];
        }
        var optyWonList = []; var optyLostList = []; var filteredWonList = []; var filteredLostList = [];
        if(dataList != null){
            for(var i=0; i<dataList.length; i++){
                if(dataList[i].Customer_Response_Lines__r != null && dataList[i].Customer_Response_Lines__r.length > 0 && dataList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Awarded'){
                    optyWonList.push(dataList[i]);
                } else if(dataList[i].Customer_Response_Lines__r != null && dataList[i].Customer_Response_Lines__r.length > 0 && dataList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Declined by Customer'){
                    optyLostList.push(dataList[i]);
                }
            }
        } 
        if(optyWonList != null){
            for(var i=0; i<optyWonList.length; i++){
                var productSearchList = productSearchString.split(',');
                var customerSearchList = customerSearchString.split(',');
                if(productSearchList != null){
                    for(var j=0; j<productSearchList.length; j++){
                        if(customerSearchList != null){
                            for(var k=0; k<customerSearchList.length; k++){
                                if(((optyWonList[i].Phoenix_Product_Family__c != null && optyWonList[i].Phoenix_Product_Family__c.toLowerCase().indexOf(productSearchList[j].toLowerCase()) !== -1) || 
                                    (optyWonList[i].Phoenix_Product__r.Name != null && optyWonList[i].Phoenix_Product__r.Name.toLowerCase().indexOf(productSearchList[j].toLowerCase()) !== -1) ||
                                    (optyWonList[i].Phoenix_NDC_Without_Dashes__c != null && optyWonList[i].Phoenix_NDC_Without_Dashes__c.indexOf(productSearchList[j]) !== -1) ||
                                    (optyWonList[i].Phoenix_Product__r.ProductCode != null && optyWonList[i].Phoenix_Product__r.ProductCode.indexOf(productSearchList[j]) !== -1)) && 
                                   (optyWonList[i].Phoenix_Bid__r.Phoenix_Customer__r.Name != null && optyWonList[i].Phoenix_Bid__r.Phoenix_Customer__r.Name.toLowerCase().indexOf(customerSearchList[k].toLowerCase()) !== -1)){
                                    filteredWonList.push(optyWonList[i]);
                                }       
                            }
                        } else{
                            if(((optyWonList[i].Phoenix_Product_Family__c != null && optyWonList[i].Phoenix_Product_Family__c.toLowerCase().indexOf(productSearchList[j].toLowerCase()) !== -1) || 
                                (optyWonList[i].Phoenix_Product__r.Name != null && optyWonList[i].Phoenix_Product__r.Name.toLowerCase().indexOf(productSearchList[j].toLowerCase()) !== -1) ||
                                (optyWonList[i].Phoenix_NDC_Without_Dashes__c != null && optyWonList[i].Phoenix_NDC_Without_Dashes__c.indexOf(productSearchList[j]) !== -1) ||
                                (optyWonList[i].Phoenix_Product__r.ProductCode != null && optyWonList[i].Phoenix_Product__r.ProductCode.indexOf(productSearchList[j]) !== -1))){
                                filteredWonList.push(optyWonList[i]);
                            }
                        }
                    }
                } else if(customerSearchList != null){
                    for(var k=0; k<customerSearchList.length; k++){
                        if(optyWonList[i].Phoenix_Bid__r.Phoenix_Customer__r.Name != null && optyWonList[i].Phoenix_Bid__r.Phoenix_Customer__r.Name.toLowerCase().indexOf(customerSearchList[k].toLowerCase()) !== -1){
                            filteredWonList.push(optyWonList[i]);
                        }       
                    }
                }      
            }
        }
        if(optyLostList != null){
            for(var i=0; i<optyLostList.length; i++){
                var productSearchList = productSearchString.split(',');
                var customerSearchList = customerSearchString.split(',');
                if(productSearchList != null){
                    for(var j=0; j<productSearchList.length; j++){
                        if(customerSearchList != null){
                            for(var k=0; k<customerSearchList.length; k++){
                                if(((optyLostList[i].Phoenix_Product_Family__c != null && optyLostList[i].Phoenix_Product_Family__c.toLowerCase().indexOf(productSearchList[j].toLowerCase()) !== -1) || 
                                    (optyLostList[i].Phoenix_Product__r.Name != null && optyLostList[i].Phoenix_Product__r.Name.toLowerCase().indexOf(productSearchList[j].toLowerCase()) !== -1) ||
                                    (optyLostList[i].Phoenix_NDC_Without_Dashes__c != null && optyLostList[i].Phoenix_NDC_Without_Dashes__c.indexOf(productSearchList[j]) !== -1) ||
                                    (optyLostList[i].Phoenix_Product__r.ProductCode != null && optyLostList[i].Phoenix_Product__r.ProductCode.indexOf(productSearchList[j]) !== -1)) && 
                                   (optyLostList[i].Phoenix_Bid__r.Phoenix_Customer__r.Name != null && optyLostList[i].Phoenix_Bid__r.Phoenix_Customer__r.Name.toLowerCase().indexOf(customerSearchList[k].toLowerCase()) !== -1)){
                                    filteredLostList.push(optyLostList[i]);
                                }       
                            }
                        } else{
                            if(((optyLostList[i].Phoenix_Product_Family__c != null && optyLostList[i].Phoenix_Product_Family__c.toLowerCase().indexOf(productSearchList[j].toLowerCase()) !== -1) || 
                                (optyLostList[i].Phoenix_Product__r.Name != null && optyLostList[i].Phoenix_Product__r.Name.toLowerCase().indexOf(productSearchList[j].toLowerCase()) !== -1) ||
                                (optyLostList[i].Phoenix_NDC_Without_Dashes__c != null && optyLostList[i].Phoenix_NDC_Without_Dashes__c.indexOf(productSearchList[j]) !== -1) ||
                                (optyLostList[i].Phoenix_Product__r.ProductCode != null && optyLostList[i].Phoenix_Product__r.ProductCode.indexOf(productSearchList[j]) !== -1))){
                                filteredLostList.push(optyLostList[i]);
                            }
                        }
                    }
                } else if(customerSearchList != null){
                    for(var k=0; k<customerSearchList.length; k++){
                        if(optyLostList[i].Phoenix_Bid__r.Phoenix_Customer__r.Name != null && optyLostList[i].Phoenix_Bid__r.Phoenix_Customer__r.Name.toLowerCase().indexOf(customerSearchList[k].toLowerCase()) !== -1){
                            filteredLostList.push(optyLostList[i]);
                        }       
                    }
                }      
            }
        }
        console.log('Won List: '+filteredWonList.length);
        console.log('Lost List: '+filteredLostList.length);
        var closePopup = false;
        helper.openPopup(component, event, helper, filteredWonList, filteredLostList, closePopup);

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
                       optyWonList[i].Phoenix_Product__r.ProductCode.indexOf(productSearchString) !== -1) && 
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
        }
    },
        searchLackOfInventoryList: function(component, event, helper){
            var productSearchString = component.get("v.productSearchString");
            var customerSearchString = component.get("v.customerSearchString");
            if(productSearchString != null && customerSearchString != null){
                var optyWonList = component.get("v.responseWrapper.lackInventoryList");
                var familyMap = {}; var filteredList = [];
                var lackInventorySummaryMap = {};
                var netCOLO = 0; var netTPTDollar = 0;
                
                if(optyWonList != null){
                    console.log('Ok');
                    for(var i=0; i<optyWonList.length; i++){
                        var productSearchList = productSearchString.split(',');
                        var customerSearchList = customerSearchString.split(',');
                        if(productSearchList != null){
                            for(var j=0; j<productSearchList.length; j++){
                                if(customerSearchList != null){
                                    for(var k=0; k<customerSearchList.length; k++){
                                        if(((optyWonList[i].Phoenix_Product_Family__c != null && optyWonList[i].Phoenix_Product_Family__c.toLowerCase().indexOf(productSearchList[j].toLowerCase()) !== -1) || 
                                            (optyWonList[i].Phoenix_Product__r.Name != null && optyWonList[i].Phoenix_Product__r.Name.toLowerCase().indexOf(productSearchList[j].toLowerCase()) !== -1) ||
                                            (optyWonList[i].Phoenix_NDC_Without_Dashes__c != null && optyWonList[i].Phoenix_NDC_Without_Dashes__c.indexOf(productSearchList[j]) !== -1) ||
                                            (optyWonList[i].Phoenix_Product__r.ProductCode != null && optyWonList[i].Phoenix_Product__r.ProductCode.indexOf(productSearchList[j]) !== -1)) && 
                                           (optyWonList[i].Phoenix_Bid__r.Phoenix_Customer__r.Name != null && optyWonList[i].Phoenix_Bid__r.Phoenix_Customer__r.Name.toLowerCase().indexOf(customerSearchList[k].toLowerCase()) !== -1)){
                                            filteredList.push(optyWonList[i]);
                                        }       
                                    }
                                } else{
                                    if(((optyWonList[i].Phoenix_Product_Family__c != null && optyWonList[i].Phoenix_Product_Family__c.toLowerCase().indexOf(productSearchList[j].toLowerCase()) !== -1) || 
                                        (optyWonList[i].Phoenix_Product__r.Name != null && optyWonList[i].Phoenix_Product__r.Name.toLowerCase().indexOf(productSearchList[j].toLowerCase()) !== -1) ||
                                        (optyWonList[i].Phoenix_NDC_Without_Dashes__c != null && optyWonList[i].Phoenix_NDC_Without_Dashes__c.indexOf(productSearchList[j]) !== -1) ||
                                        (optyWonList[i].Phoenix_Product__r.ProductCode != null && optyWonList[i].Phoenix_Product__r.ProductCode.indexOf(productSearchList[j]) !== -1))){
                                        filteredList.push(optyWonList[i]);
                                    }
                                }
                            }
                        } else if(customerSearchList != null){
                            for(var k=0; k<customerSearchList.length; k++){
                                if(optyWonList[i].Phoenix_Bid__r.Phoenix_Customer__r.Name != null && optyWonList[i].Phoenix_Bid__r.Phoenix_Customer__r.Name.toLowerCase().indexOf(customerSearchList[k].toLowerCase()) !== -1){
                                    filteredList.push(optyWonList[i]);
                                }       
                            }
                        }      
                    }
                }
                
                if(filteredList != null){
                    console.log('Ok');
                    var updatedFamilyMap = {}; var familySummaryForSorting = {}; var finalFamilyMap = {};
                    for(var i=0; i<filteredList.length; i++)    {
                        if(updatedFamilyMap.hasOwnProperty(filteredList[i].Product_Family_Name__c)){
                            var relatedList = updatedFamilyMap[filteredList[i].Product_Family_Name__c];
                            relatedList.push(filteredList[i]);
                            updatedFamilyMap[filteredList[i].Product_Family_Name__c] = relatedList;
                            var awardedSales = familySummaryForSorting[filteredList[i].Product_Family_Name__c];
                            awardedSales += filteredList[i].awardedSales;
                            familySummaryForSorting[filteredList[i].Product_Family_Name__c] = parseFloat(awardedSales);
                        } else {
                            var relatedList = [];
                            relatedList.push(filteredList[i]);
                            familyMap[filteredList[i].Product_Family_Name__c] = relatedList;
                            familySummaryForSorting[filteredList[i].Product_Family_Name__c] = filteredList[i].awardedSales;
                        }      
                    }
                    let keys = Object.keys(familySummaryForSorting);
                    keys.sort(function(a, b) { 
                        return familySummaryForSorting[b] - familySummaryForSorting[a]
                    });
                    keys.forEach(function(key) {
                        finalFamilyMap[key] = updatedFamilyMap[key];
                    });
                    lackInventorySummaryMap.netCOLO = netCOLO;
                    lackInventorySummaryMap.netTPTDollar = netTPTDollar;
                    component.set("v.lackInventorySummaryMap", lackInventorySummaryMap);
                    component.set("v.lackInventoryFamilyMap", finalFamilyMap);
                    component.set("v.lackInventoryFamilyList", Object.keys(finalFamilyMap));
                }   
            } else{
                component.set("v.showLackOfInventoryPopup", false);
                helper.showLackOfInventoryPopup(component, event, helper);
            }
        },
        showLackOfInventoryPopup: function(component, event, helper){
            component.set("v.productSearchString", '');
            component.set("v.customerSearchString", '');
            var lackInventoryList = component.get("v.lackInventoryList");
            var familyMap = {}; var familyIdMap = {};
            component.set("v.showLackOfInventoryPopup", !component.get("v.showLackOfInventoryPopup"));
            if(component.get("v.showLackOfInventoryPopup")){
                if(lackInventoryList != null){
                    for(var i=0; i<lackInventoryList.length; i++){
                        familyIdMap[lackInventoryList[i].Product_Family_Name__c] = lackInventoryList[i].Product_Family__c;
                        if(familyMap.hasOwnProperty(lackInventoryList[i].Product_Family_Name__c)){
                            var relatedList = familyMap[lackInventoryList[i].Product_Family_Name__c];
                            relatedList.push(lackInventoryList[i]);
                            familyMap[lackInventoryList[i].Product_Family_Name__c] = relatedList;
                        } else {
                            var relatedList = [];
                            relatedList.push(lackInventoryList[i]);
                            familyMap[lackInventoryList[i].Product_Family_Name__c] = relatedList;
                        }      
                    }
                    component.set("v.lackInventoryFamilyMap", familyMap);
                    component.set("v.familyIdMap", familyIdMap);
                    component.set("v.lackInventoryFamilyList", Object.keys(familyMap));
                    component.set("v.lackInventoryFamilyMapTemp", familyMap);
                    component.set("v.familyIdMapTemp", familyIdMap);
                    component.set("v.lackInventoryFamilyListTemp", Object.keys(familyMap));
                }
            }
        }
})