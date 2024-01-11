({
    doInit: function(component, event, helper){
        component.set("v.loaded", true);
        helper.buildData(component, event, helper);
    },
    handleChange: function (component, event, helper) {
        // This will contain the string of the "value" attribute of the selected option
        component.set("v.loaded", true);
        var selectedOptionValue = event.getParam("value");
        var vipRebateData = component.get("v.vipRebateData");
        for(var i=0; i<vipRebateData.length; i++){
            if(vipRebateData[i].Id == selectedOptionValue){
                component.set("v.selectedVIPRebateRecord", vipRebateData[i]);
            }
        }
        helper.buildData(component, event, helper);
    },
    openModal: function(component, event, helper) {
        component.set("v.isModalOpen", true);
    },
    closeModal: function(component, event, helper){
        component.set("v.isProductsModalOpen", false);
        component.set("v.isModalOpen", false);
    },
    handleEvent: function(component, event, helper, singleRec){
        var isProductsModalOpen =event.getParam("isProductsModalOpen");
        var header =event.getParam("header");
        var singleRec = event.getParam('singleRec');
        component.set("v.isProductsModalOpen", isProductsModalOpen);
        component.set("v.header", header);
        component.set("v.productData", singleRec);
        var months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
        var Q1 = ['Apr', 'May', 'Jun'];
        var Q2 = ['Jul', 'Aug', 'Sep'];
        var Q3 = ['Oct', 'Nov', 'Dec'];
        var Q4 = ['Jan', 'Feb', 'Mar'];
        var totalVolume = 0; var totalPrice = 0; var totalValue = 0; var totalImpact = 0; var totalPrevVolume = 0; var totalPrevPrice = 0; var totalAnnualImpact = 0;
        var totalPreviousQty = 0; var totalProposedQty = 0; var totalPreviousSales = 0; var totalProposedSales = 0;
        var productRemovalPC = []; var productRemovalVRO = []; var productRemovalMPR = [];
        for(var i=0; i<singleRec.length; i++){
            if(singleRec[i].lineItem.Customer_Response_Lines__r){
                var d;
                if(singleRec[i].lineItem.hasOwnProperty('Phoenix_Estimated_Lead_Time_Days__c') && singleRec[i].lineItem.Phoenix_Estimated_Lead_Time_Days__c != null){
                    d = new Date(singleRec[i].lineItem.Customer_Response_Lines__r[0].Phoenix_Supply_Effective_Date__c);   
                } else if(singleRec[i].lineItem.Customer_Response_Lines__r[0].Phoenix_Price_Effective_Date__c != null){
                    d = new Date(singleRec[i].lineItem.Customer_Response_Lines__r[0].Phoenix_Price_Effective_Date__c);
                } else{
                    d = new Date(singleRec[i].lineItem.Customer_Response_Lines__r[0].Phoenix_Customer_Response_Date__c);
                }
                singleRec[i].lineItem.formattedEffectiveDate = new Date(d).toLocaleDateString("en-US", { year: "numeric", month: "2-digit", day: "2-digit" });
                var fiscalyear = '';
                if ((d.getMonth() + 1) <= 3) {
                    fiscalyear = d.getFullYear();
                } else {
                    fiscalyear = d.getFullYear() + 1;
                }
                //var endDate = new Date();
                //var date = new Date(endDate.setMonth(remainingMnths+1));
                var endDateOfFiscalYear = new Date(fiscalyear, 2, 31);
                var monthsRemaining = 0;
                var endDate = new Date(component.get("v.endDate"));
                //calculate time difference  
                //var time_difference = endDate.getTime() - d.getTime(); 
                var time_difference = endDateOfFiscalYear.getTime() - d.getTime(); 
                //calculate days difference by dividing total milliseconds in a day  
                var days_difference = time_difference / (1000 * 60 * 60 * 24);
                monthsRemaining = (days_difference/365)*12;
                var previousSales = (singleRec[i].previousDeadnet * singleRec[i].previousQty);
                var proposedSales = (singleRec[i].proposedDeadnet * singleRec[i].awardedQty);
                singleRec[i].previousSales = ((isNaN(previousSales)) ? 0 : previousSales);
                singleRec[i].proposedSales = ((isNaN(proposedSales)) ? 0 : proposedSales);
                var annualImpact = (singleRec[i].proposedSales - singleRec[i].previousSales);
                var businessImpact = (annualImpact * monthsRemaining)/12;
                
                singleRec[i].lineItem.businessImpact = parseInt(businessImpact);
                singleRec[i].lineItem.annualImpact = parseInt(annualImpact);
                singleRec[i].lineItem.monthsRemaining = monthsRemaining;
                if(singleRec[i].lineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Price Change'){
                    var prevValue = singleRec[i].lineItem.Phoenix_Current_ASP_Dose__c * singleRec[i].lineItem.Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c;
                    var currentValue = singleRec[i].lineItem.Phoenix_Proposed_ASP_Dose__c * singleRec[i].lineItem.Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c;
                    if(currentValue >= prevValue){
                        singleRec[i].lineItem.businessImpactPositive = true;    
                    } else{
                        singleRec[i].lineItem.businessImpactPositive = false;
                    }
                } 
                else if(singleRec[i].lineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Volume Review Only'){
                    var prevValue = singleRec[i].lineItem.Phoenix_Proposed_ASP_Dose__c * singleRec[i].lineItem.Phoenix_Total_Selling_Unit__c;
                    var currentValue = singleRec[i].lineItem.Phoenix_Proposed_ASP_Dose__c * singleRec[i].lineItem.Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c;
                    if(currentValue >= prevValue){
                        singleRec[i].lineItem.businessImpactPositive = true;    
                    } else{
                        singleRec[i].lineItem.businessImpactPositive = false;
                    }
                } 
                    else{
                    if(businessImpact >= 0){
                        singleRec[i].lineItem.businessImpactPositive = true;
                    } else{
                        singleRec[i].lineItem.businessImpactPositive = false;
                    }   
                }
                //singleRec[i].formattedEffectiveDate = new Date(singleRec[i].Customer_Response_Lines__r[0].Phoenix_Supply_Effective_Date__c).toLocaleDateString("en-US", { year: "numeric", month: "2-digit", day: "2-digit" });
                component.set("v.productData", singleRec);
                totalPreviousQty += ((isNaN(singleRec[i].previousQty)) ? 0 : singleRec[i].previousQty); 
                totalProposedQty += ((isNaN(singleRec[i].awardedQty)) ? 0 : singleRec[i].awardedQty); 
                totalPreviousSales += ((isNaN(singleRec[i].previousSales)) ? 0 : singleRec[i].previousSales); 
                totalProposedSales += ((isNaN(singleRec[i].proposedSales)) ? 0 : singleRec[i].proposedSales); 
                totalVolume += ((isNaN(singleRec[i].lineItem.Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c)) ? 0 : singleRec[i].lineItem.Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c);
                totalPrevVolume += ((isNaN(singleRec[i].lineItem.Phoenix_Total_Selling_Unit__c)) ? 0 : singleRec[i].lineItem.Phoenix_Total_Selling_Unit__c);
                totalPrice += ((isNaN(singleRec[i].lineItem.Phoenix_Proposed_ASP_Dose__c)) ? 0 : singleRec[i].lineItem.Phoenix_Proposed_ASP_Dose__c);
                totalPrevPrice += ((isNaN(singleRec[i].lineItem.Phoenix_Current_ASP_Dose__c)) ? 0 : singleRec[i].lineItem.Phoenix_Current_ASP_Dose__c);
                totalValue += ((isNaN(annualImpact)) ? 0 : annualImpact);
                totalImpact += ((isNaN(businessImpact)) ? 0 : businessImpact);
                totalAnnualImpact += ((isNaN(annualImpact)) ? 0 : annualImpact);
                if(header == 'Product Removal / Loss'){
                    if(singleRec[i].lineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Price Change'){
                        productRemovalPC.push(singleRec[i]);
                    } else if(singleRec[i].lineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Volume Review Only'){
                        productRemovalVRO.push(singleRec[i]);
                    } else if(singleRec[i].lineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Mass Product Removal'){
                        productRemovalMPR.push(singleRec[i]);
                    } else if(singleRec[i].lineItem.Phoenix_Bid__r.Phoenix_Bid_Type__c == 'RFP Bids'){
                        productRemovalRFP.push(singleRec[i]);
                    }
                }   
            }
        }
        if(header == 'Product Removal / Loss'){
            for(var i=0; i<singleRec.length; i++){
                if(singleRec[i].lineItem.hasOwnProperty('BidLineItemsExtn__r') && singleRec[i].lineItem.BidLineItemsExtn__r){
                    var d = new Date(singleRec[i].removalEffectiveDate);
                    console.log('Ddate: '+singleRec[i].removalEffectiveDate);
                    singleRec[i].lineItem.formattedEffectiveDate = new Date(d).toLocaleDateString("en-US", { year: "numeric", month: "2-digit", day: "2-digit" });
                    var fiscalyear = '';
                    if ((d.getMonth() + 1) <= 3) {
                        fiscalyear = d.getFullYear();
                    } else {
                        fiscalyear = d.getFullYear() + 1;
                    }
                    //var endDate = new Date();
                    //var date = new Date(endDate.setMonth(remainingMnths+1));
                    var endDateOfFiscalYear = new Date(fiscalyear, 2, 31);
                    var monthsRemaining = 0;
                    //calculate time difference  
                    var time_difference = endDateOfFiscalYear.getTime() - d.getTime(); 
                    
                    //calculate days difference by dividing total milliseconds in a day  
                    var days_difference = time_difference / (1000 * 60 * 60 * 24);
                    monthsRemaining = (days_difference/365)*12;
                    
                    var annualImpact = 0;
                    var previousSales = (singleRec[i].previousDeadnet * singleRec[i].previousQty);
                    singleRec[i].previousSales = ((isNaN(previousSales)) ? 0 : previousSales);
                    singleRec[i].proposedSales = 0;
                    singleRec[i].monthsRemaining = monthsRemaining;
                    annualImpact = (singleRec[i].proposedSales - singleRec[i].previousSales);
                    singleRec[i].lineItem.annualImpact = parseInt(annualImpact);
                    singleRec[i].lineItem.businessImpact = ((annualImpact*monthsRemaining)/12);
                    totalPreviousQty += ((isNaN(singleRec[i].previousQty)) ? 0 : singleRec[i].previousQty); 
                    totalPreviousSales += ((isNaN(singleRec[i].previousSales)) ? 0 : singleRec[i].previousSales);
                    totalImpact += ((isNaN(singleRec[i].lineItem.businessImpact)) ? 0 : singleRec[i].lineItem.businessImpact);
                    totalAnnualImpact += ((isNaN(annualImpact)) ? 0 : annualImpact);
                }
            }
        }
        var totalObj = {};
        totalObj.totalPreviousQty = parseInt(totalPreviousQty);
        totalObj.totalProposedQty = parseInt(totalProposedQty);
        totalObj.totalPreviousSales = parseInt(totalPreviousSales);
        totalObj.totalProposedSales = parseInt(totalProposedSales);
        totalObj.totalImpact = parseInt(totalImpact);
        totalObj.totalAnnualImpact = parseInt(totalAnnualImpact);
        /*totalObj.totalVolume = totalVolume;
        totalObj.totalPrevVolume = totalPrevVolume;
        totalObj.totalPrice = totalPrice;
        totalObj.totalPrevPrice = totalPrevPrice;
        totalObj.totalValue = parseInt(totalValue);
        totalObj.totalImpact = parseInt(totalImpact);
        totalObj.totalAnnualImpact = parseInt(totalAnnualImpact);*/
        component.set("v.productRemovalPC", productRemovalPC);
        component.set("v.productRemovalVRO", productRemovalVRO);
        component.set("v.productRemovalMPR", productRemovalMPR);
        component.set("v.totalObj", totalObj);
    },
    handleTierEvent: function(component, event, helper){
        console.log('Fired: '+event.getParam("highlightTier"));
        var highlightTier =event.getParam("highlightTier");
        var tierData = component.get("v.vipRebateTierData");
        for(var i=0; i<tierData.length; i++){
            if(tierData[i].Phoenix_Tier__c == highlightTier){
                tierData[i].highlightTier = true;
            } else{
                tierData[i].highlightTier = false;
            }
        }
        component.set("v.vipRebateTierData", tierData);
    },
    /*doInit : function(component, event, helper) {
        var action = component.get("c.getRebateLinesData");
        console.log('Customer ID:: '+component.get("v.recordId"));
        action.setParams({
            'customerId': component.get("v.recordId")
        });
        action.setCallback(this, function(response){
            if(response.getState() == 'SUCCESS') {
                console.log('Response:: '+JSON.stringify(response.getReturnValue()));
                var wrapResponse = response.getReturnValue();
                component.set("v.data", wrapResponse.mapOfTotals);
                var totalsData = Object.values(wrapResponse.mapOfTotals);
                var previousTotalsData = Object.values(wrapResponse.previousMapOfTotals);
                var splittedKeys = [];
                var allKeys = Object.keys(wrapResponse.mapOfTotals);
                for(var i=0; i<allKeys.length; i++){
                    if(!allKeys.includes(allKeys[i].split('-')[0])){
                        splittedKeys.push(allKeys[i].split('-')[0]);   
                    }
                }
                var monthYearSet = wrapResponse.monthYearSet;
                console.log('all keys: '+splittedKeys);
                var labels = [];
                component.set("v.xLabels", splittedKeys);
                component.set("v.startDate", wrapResponse.rebateLinesData[0].Phoenix_VIP_Rebate__r.Phoenix_Start_Date__c);
                component.set("v.endDate", wrapResponse.rebateLinesData[wrapResponse.rebateLinesData.length-1].Phoenix_VIP_Rebate__r.Phoenix_End_Date__c);
                var chartDataCurrent = [];
                var chartDataPrevious = [];
                console.log('Type: '+wrapResponse.rebateLinesData[0].Phoenix_VIP_Rebate__r.Phoenix_Type__c);
                component.set("v.rebateType",wrapResponse.rebateLinesData[0].Phoenix_VIP_Rebate__r.Phoenix_Type__c);
                var maxVal;
                if(wrapResponse.rebateLinesData[0].Phoenix_VIP_Rebate__r.Phoenix_Type__c == 'Currency'){ //Quantity
                    for(var i=0; i<totalsData.length; i++){
                        console.log('::: '+JSON.stringify(totalsData[i]));
                        chartDataCurrent.push(totalsData[i].Sales);
                    }
                    component.set("v.chartDataCurrent", chartDataCurrent);
                    component.set("v.label1", 'Current Sales ($)');
                    component.set("v.label", 'Sales ($)');
                    maxVal = wrapResponse.rebateLinesData[wrapResponse.rebateLinesData.length-1].Phoenix_Dollar_Value_To__c;
                } else{
                    for(var i=0; i<totalsData.length; i++){
                        console.log('::: '+totalsData[i]);
                        chartDataCurrent.push(totalsData[i].Units);
                    }
                    component.set("v.chartDataCurrent", chartDataCurrent);
                    component.set("v.label1", 'Current Quantity (EU)');
                    component.set("v.label", 'Quantity (EU)');
                    maxVal = wrapResponse.rebateLinesData[wrapResponse.rebateLinesData.length-1].Phoenix_Unit_Volume_To__c;
                }
                if(wrapResponse.rebateLinesData[0].Phoenix_VIP_Rebate__r.Phoenix_Type__c == 'Currency'){ //Quantity
                    for(var i=0; i<previousTotalsData.length; i++){
                        console.log('::: '+JSON.stringify(previousTotalsData[i]));
                        chartDataPrevious.push(previousTotalsData[i].Sales);
                    }
                    component.set("v.chartDataPrevious", chartDataPrevious);
                    component.set("v.label", 'Sales ($)');
                    component.set("v.label2", 'Previous Sales ($)');
                    maxVal = wrapResponse.rebateLinesData[wrapResponse.rebateLinesData.length-1].Phoenix_Dollar_Value_To__c;
                } else{
                    for(var i=0; i<previousTotalsData.length; i++){
                        console.log('::: '+previousTotalsData[i]);
                        chartDataPrevious.push(previousTotalsData[i].Units);
                    }
                    component.set("v.chartDataPrevious", chartDataPrevious);
                    component.set("v.label2", 'Previous Quantity (EU)');
                    component.set("v.label", 'Quantity ($)');
                    maxVal = wrapResponse.rebateLinesData[wrapResponse.rebateLinesData.length-1].Phoenix_Unit_Volume_To__c;
                }
                console.log('chartDataCurrent: '+chartDataCurrent);
                console.log('chartDataPrevious: '+chartDataPrevious);
                helper.generateChart(component, event, helper, splittedKeys, maxVal);
            } else{
                console.log("Error "+JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);
    }*/
})