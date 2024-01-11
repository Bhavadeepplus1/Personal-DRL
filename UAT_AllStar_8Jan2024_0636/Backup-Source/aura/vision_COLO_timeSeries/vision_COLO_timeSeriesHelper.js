({
    getData : function(component, event, helper, processNum) {
        var monthNum = component.get("v.monthsList")[processNum];
        var yearNum = component.get("v.yearList")[processNum];
        var action = component.get("c.getDataBasedOnQuarter");
        action.setParams({
            'month': [monthNum],
            'year': [yearNum],
            'productType': component.get("v.selectedProductType"),
            'productDirector': component.get("v.selectedId")
        });
        action.setCallback(this, function(response){
            if(response.getState() == 'SUCCESS'){
                var responseData = response.getReturnValue();
                var wrapperList = component.get("v.wrapperList");
                wrapperList.push(responseData);
                component.set("v.wrapperList",wrapperList);
                processNum ++;
                if(processNum == 6)
                    helper.processWrapper(component, event, helper);
                else
                    helper.getData(component, event, helper, processNum);
                /*component.set("v.responseWrapper", responseData);
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
                    
                    component.set("v.isSpinnerLoad", false);
                    component.set("v.isDataLoaded", true);
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
                        for(var i=0; i<lackInventoryList.length; i++){
                            var calculatedCOLO = (lackInventoryList[i].Phoenix_Latest_Estimate__c != null ? lackInventoryList[i].Phoenix_Latest_Estimate__c : 0) * (lackInventoryList[i].Phoenix_Final_Total_Selling_Unit__c != null ? lackInventoryList[i].Phoenix_Final_Total_Selling_Unit__c: 0);
                            lackInventoryList[i].COLO = 0;
                            lackInventoryList[i].grossCOLO = 0;
                            if(lackInventoryList[i].Phoenix_Net_Sales_Internal__c == 0){
                                lackInventoryList[i].COLO = calculatedCOLO;
                            } else if(lackInventoryList[i].Phoenix_Net_Sales_Internal__c > 0){
                                var netSales = (lackInventoryList[i].Phoenix_Net_Sales_Internal__c != null ? lackInventoryList[i].Phoenix_Net_Sales_Internal__c:0);
                                if(netSales > (calculatedCOLO * (130/100))){
                                    lackInventoryList[i].grossCOLO = netSales;
                                    lackInventoryList[i].adjustedCOLO = netSales * (0.5);
                                } else{
                                    lackInventoryList[i].grossCOLO = calculatedCOLO;    
                                    lackInventoryList[i].adjustedCOLO = calculatedCOLO * (0.5);
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
                        }
                    }
                    lackInventorySummaryMap.netCOLO = netCOLO;
                    lackInventorySummaryMap.netTPTDollar = netTPTDollar;
                    component.set("v.lackInventorySummaryMap", lackInventorySummaryMap);
                    component.set("v.lackInventoryList", responseData.lackInventoryList);
                    
                }*/
            } else{
                console.log("Exception: "+JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);
    },
    processWrapper : function(component, event, helper){
        var selectedTimeSeriesItem = component.get("v.selectedTimeSeriesItem");
        var wrapperList = component.get("v.wrapperList");
        var bidLineList = []; var perBidsList = []; var salesList = []; var gmList = [];
        wrapperList.forEach(function(wrapObj){
            var NPLListCount = (wrapObj.NPLList != null ? wrapObj.NPLList.length : 0);
            var ProActiveListCount = (wrapObj.ProActiveList != null ? wrapObj.ProActiveList.length : 0);
            var ReActiveListCount = (wrapObj.ReActiveList != null ? wrapObj.ReActiveList.length : 0);
            var ROFRListCount = (wrapObj.ROFRList != null ? wrapObj.ROFRList.length : 0);
            var lackInventoryCount = (wrapObj.lackInventoryList != null ? wrapObj.lackInventoryList.length : 0);
            var totalOpportunities = NPLListCount + ProActiveListCount + ReActiveListCount + ROFRListCount + lackInventoryCount;
            if(selectedTimeSeriesItem == 'New Product Launch Time Series'){
                perBidsList.push(((NPLListCount/totalOpportunities)*100).toFixed(0));
                bidLineList.push(wrapObj.NPLList.length);
                if(wrapObj.NPLSales != 0 && wrapObj.NPLSales != null) {
                    const totalSalesInMillions = helper.formatCurrencyMethod(component, event, helper, wrapObj.NPLSales); 
                    if(totalSalesInMillions == '$NaNM')
                        salesList.push('$' + 0 );  
                    else 
                        salesList.push(totalSalesInMillions);
                } else
                    salesList.push('$' + 0 );
                if(wrapObj.NPLTPTSales != 0 && wrapObj.NPLTPTSales != null) {
                    const totalSalesInMillions = helper.formatCurrencyMethod(component, event, helper, wrapObj.NPLTPTSales); 
                    if(totalSalesInMillions == '$NaNM')
                        gmList.push('$' + 0 );  
                    else 
                        gmList.push(totalSalesInMillions);
                } else
                    gmList.push('$' + 0 );
            }
            else if(selectedTimeSeriesItem == 'Share Expansion Time Series'){
                perBidsList.push((((ProActiveListCount+ReActiveListCount)/totalOpportunities)*100).toFixed(0));
                bidLineList.push((ProActiveListCount+ReActiveListCount));
                if((wrapObj.ProActiveSales + wrapObj.ReActiveSales) != 0 && (wrapObj.ProActiveSales + wrapObj.ReActiveSales) != null) {
                    const totalSalesInMillions = helper.formatCurrencyMethod(component, event, helper, (wrapObj.ProActiveSales + wrapObj.ReActiveSales));
                    console.log('share Expansion sales --> '+totalSalesInMillions);
                    if(totalSalesInMillions == '$NaNM')
                        salesList.push('$' + 0 );  
                    else 
                        salesList.push(totalSalesInMillions);
                } else
                    salesList.push('$' + 0 );
                
                if(wrapObj.ShareExpansionTPTSales != 0 && wrapObj.ShareExpansionTPTSales != null) {
                    const totalSalesInMillions = helper.formatCurrencyMethod(component, event, helper, wrapObj.ShareExpansionTPTSales); 
                    if(totalSalesInMillions == '$NaNM')
                        gmList.push('$' + 0 );  
                    else 
                        gmList.push(totalSalesInMillions);
                } else
                    gmList.push('$' + 0 );
            }
            else if(selectedTimeSeriesItem == 'Price Change Time Series'){
                perBidsList.push(((ROFRListCount/totalOpportunities)*100).toFixed(0));
                bidLineList.push(ROFRListCount);
                if(wrapObj.totalPriceChangeSales != 0 && wrapObj.totalPriceChangeSales != null) {
                    const totalSalesInMillions = helper.formatCurrencyMethod(component, event, helper, wrapObj.totalPriceChangeSales); 
                    if(totalSalesInMillions == '$NaNM')
                        salesList.push('$' + 0 );  
                    else 
                        salesList.push(totalSalesInMillions);
                } else
                    salesList.push('$' + 0 );
                if(wrapObj.totalPriceChangeTPTSales != 0 && wrapObj.totalPriceChangeTPTSales != null) {
                    const totalSalesInMillions = helper.formatCurrencyMethod(component, event, helper, wrapObj.totalPriceChangeTPTSales); 
                    if(totalSalesInMillions == '$NaNM')
                        gmList.push('$' + 0 );  
                    else 
                        gmList.push(totalSalesInMillions);
                } else
                    gmList.push('$' + 0 );
            }
            else if(selectedTimeSeriesItem == 'Lack Of inventory COLO Time Series'){
                var lackInventoryList = wrapObj.lackInventoryList;
                var lackInventorySummaryMap = {};
                var netCOLO = 0; var netTPTDollar = 0;
                if(lackInventoryList != null){
                    for(var i=0; i<lackInventoryList.length; i++){
                        var calculatedCOLO = (lackInventoryList[i].Phoenix_Latest_Estimate__c != null ? lackInventoryList[i].Phoenix_Latest_Estimate__c : 0) * (lackInventoryList[i].Phoenix_Final_Total_Selling_Unit__c != null ? lackInventoryList[i].Phoenix_Final_Total_Selling_Unit__c: 0);
                        lackInventoryList[i].COLO = 0;
                        lackInventoryList[i].grossCOLO = 0;
                        if(lackInventoryList[i].Phoenix_Net_Sales_Internal__c == 0){
                            lackInventoryList[i].COLO = calculatedCOLO;
                        } else if(lackInventoryList[i].Phoenix_Net_Sales_Internal__c > 0){
                            var netSales = (lackInventoryList[i].Phoenix_Net_Sales_Internal__c != null ? lackInventoryList[i].Phoenix_Net_Sales_Internal__c:0);
                            if(netSales > (calculatedCOLO * (130/100))){
                                lackInventoryList[i].grossCOLO = netSales;
                                lackInventoryList[i].adjustedCOLO = netSales * (0.5);
                            } else{
                                lackInventoryList[i].grossCOLO = calculatedCOLO;    
                                lackInventoryList[i].adjustedCOLO = calculatedCOLO * (0.5);
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
                    }
                }
                salesList.push(netCOLO);
                gmList.push(netTPTDollar);
                perBidsList.push(((lackInventoryCount/totalOpportunities)*100).toFixed(0));
                bidLineList.push(lackInventoryCount);
                /*if(wrapObj.NPLSales != 0 && wrapObj.NPLSales != null) {
                    const totalSalesInMillions = helper.formatCurrencyMethod(component, event, helper, wrapObj.NPLSales); 
                    if(totalSalesInMillions == '$NaNM')
                        salesList.push('$' + 0 );  
                    else 
                        salesList.push(totalSalesInMillions);
                } else
                    salesList.push('$' + 0 );
                if(wrapObj.NPLTPTSales != 0 && wrapObj.NPLTPTSales != null) {
                    const totalSalesInMillions = helper.formatCurrencyMethod(component, event, helper, wrapObj.NPLTPTSales); 
                    if(totalSalesInMillions == '$NaNM')
                        gmList.push('$' + 0 );  
                    else 
                        gmList.push(totalSalesInMillions);
                } else
                    gmList.push('$' + 0 );*/
            }
            else if(selectedTimeSeriesItem == 'Time Series'){
                perBidsList.push(100);
                bidLineList.push(totalOpportunities);
                var totalSales = wrapObj.NPLSales + wrapObj.ProActiveSales + wrapObj.ReActiveSales + wrapObj.ROFRSales;
                var totalTPTSales = wrapObj.NPLTPTSales + wrapObj.ShareExpansionTPTSales + wrapObj.PriceChangeTPTSales;
                if(totalSales != 0 && totalSales != null) {
                    const totalSalesInMillions = helper.formatCurrencyMethod(component, event, helper, totalSales);
                    //console.log('totalSalesInMillions: '+totalSalesInMillions);
                    if(totalSalesInMillions == '$NaNM')
                        salesList.push('$' + 0);  
                    else 
                        salesList.push(totalSalesInMillions);  
                } else
                    salesList.push('$' + 0);
                if(totalTPTSales != 0 && totalTPTSales != null) {
                    const totalSalesInMillions = helper.formatCurrencyMethod(component, event, helper, totalTPTSales); 
                    if(totalSalesInMillions == '$NaNM')
                        gmList.push('$' + 0);  
                    else 
                        gmList.push(totalSalesInMillions);    
                } else
                    gmList.push('$' + 0);
            }
            
        });
        if(bidLineList[bidLineList.length-1]>bidLineList[bidLineList.length-2])
            component.set("v.isBidLineUp",true);
        if(perBidsList[perBidsList.length-1]>perBidsList[perBidsList.length-2])
            component.set("v.isPerBidUp",true);
        if(salesList[salesList.length-1]>salesList[salesList.length-2])
            component.set("v.isSalUp",true);
        if(gmList[gmList.length-1]>gmList[gmList.length-2])
            component.set("v.isGmUp",true);
        component.set("v.bidLineNumList",bidLineList);
        component.set("v.perBidsList",perBidsList);
        component.set("v.salesList",salesList);
        component.set("v.gmList",gmList);
        component.set("v.showSpinnerNow",false);
    },
    formatCurrencyMethod : function(component, event, helper, number) {
        if(number != null && number != 0){
         	number = (number/1000000).toFixed(1);
            number = parseFloat(number);
        }
		const formattedCurrency = number.toLocaleString('en-US', { style: 'currency', currency: 'USD',  minimumFractionDigits: 0, maximumFractionDigits: 1 });
        return formattedCurrency;
	},
})