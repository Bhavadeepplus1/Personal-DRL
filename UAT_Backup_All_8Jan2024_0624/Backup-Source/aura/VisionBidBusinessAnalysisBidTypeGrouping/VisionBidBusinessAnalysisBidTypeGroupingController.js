({
    handleClick1: function(component, event, helper){
        component.set("v.expandBidType", true);
        component.set("v.record.showItem", true);
    },
    handleClick2: function(component, event, helper){
        component.set("v.expandBidType", false);
        component.set("v.record.showItem", false);
    }, 
    expandAll: function(component, event, helper){
        component.set("v.expandBidType", component.get("v.expandAll"));
        component.set("v.record.showItem", component.get("v.expandAll"));
        console.log('Expand All in Bid Type Grouping: '+component.get("v.expandAll"));
    }, 
    
    showCustomers: function(component, event, helper){
        var product = event.getSource().get("v.name");
        var groupingList = component.get("v.groupingList");
        for(var i=0; i<groupingList.length; i++){
            if(groupingList[i].product == product){
                groupingList[i].showCustomers = true;
            }
        }
        component.set("v.groupingList", groupingList);   
    },
    hideCustomers: function(component, event, helper){
        var product = event.getSource().get("v.name");
        var groupingList = component.get("v.groupingList");
        for(var i=0; i<groupingList.length; i++){
            if(groupingList[i].product == product){
                groupingList[i].showCustomers = false;
            }
        }
        component.set("v.groupingList", groupingList);
    },
    
    doInit: function(component, event, helper){
        var record = component.get("v.record[0]");
        var productsList = component.get("v.record[1]");
        var summary = component.get("v.bidTypeSummaryMap");
        
        component.set("v.summaryList", summary[record]);
        if(productsList != null){
            var openStatusMap = {};
            var openStatusFamilySummaryMap = {};
            productsList.forEach(function(rec){
                if(openStatusMap.hasOwnProperty(rec.productFamily)){
                    var relatedList = openStatusMap[rec.productFamily]; var summary = [];
                    relatedList.push(rec);
                    openStatusMap[rec.productFamily] = relatedList;
                    var previousTotal = 0; var currentTotal = 0; var annualImapact = 0; var businessImpact = 0; var currentQuarterImpact = 0; var previousTPT = 0; var currentTPT = 0;
                    var previousTPTFamilySummary = 0; var currentTPTFamilySummary = 0; var priceVarianceFamilySummary = 0; var volumeVarianceFamilySummary = 0;
                    var totalVarianceFamilySummary = 0; var tptVarianceFamilySummary = 0;var totalPreviousAwdQtySummary = 0; var totalAwdQtySummary = 0;
                    for(var i=0; i<relatedList.length; i++){
                        previousTotal += ((isNaN(relatedList[i].previousContractTotal) ? 0 : relatedList[i].previousContractTotal));
                        currentTotal += ((isNaN(relatedList[i].currentContractTotal) ? 0 : relatedList[i].currentContractTotal));
                        annualImapact += ((isNaN(relatedList[i].annualImpact) ? 0 : relatedList[i].annualImpact));
                        businessImpact += ((isNaN(relatedList[i].businessImpact) ? 0 : relatedList[i].businessImpact));
                        currentQuarterImpact += ((isNaN(relatedList[i].currentQuarterImpact) ? 0 : relatedList[i].currentQuarterImpact));
                        previousTPT += ((isNaN(relatedList[i].previousTPT) ? 0 : relatedList[i].previousTPT));
                        currentTPT += ((isNaN(relatedList[i].currentTPT) ? 0 : relatedList[i].currentTPT));
                        priceVarianceFamilySummary += ((isNaN(relatedList[i].priceVariance) ? 0 : relatedList[i].priceVariance));
                        volumeVarianceFamilySummary += ((isNaN(relatedList[i].volumeVariance) ? 0 : relatedList[i].volumeVariance));
                        totalPreviousAwdQtySummary += ((isNaN(relatedList[i].previousQty) ? 0 : relatedList[i].previousQty));
                        totalAwdQtySummary += ((isNaN(relatedList[i].awardedQty) ? 0 : relatedList[i].awardedQty));
                    }
                    /*totalPreviousQtyOS += totalPreviousAwdQtySummary;
                                totalAwardedQtyOS += totalAwdQtySummary;*/
                    summary[0] = parseInt(previousTotal);
                    summary[1] = parseInt(currentTotal);
                    summary[2] = parseInt(annualImapact);
                    summary[3] = parseInt(businessImpact);
                    summary[4] = parseInt(previousTPT);
                    summary[5] = parseInt(currentTPT);
                    summary[6] = parseInt(parseFloat(currentTPT) - parseFloat(previousTPT));
                    summary[7] = parseInt(priceVarianceFamilySummary);
                    summary[8] = parseInt(volumeVarianceFamilySummary);
                    summary[9] = ((!isFinite(previousTPT/previousTotal) ? 0 : (previousTPT/previousTotal)));
                    summary[10] = ((!isFinite(currentTPT/currentTotal) ? 0 : (currentTPT/currentTotal)));
                    summary[11] = parseInt(totalPreviousAwdQtySummary);
                    summary[12] = parseInt(totalAwdQtySummary);
                    summary[13] = parseInt(currentQuarterImpact);
                    openStatusFamilySummaryMap[rec.productFamily] = summary;
                } else{
                    var relatedList = [];var summary = [];
                    relatedList.push(rec);
                    openStatusMap[rec.productFamily] = relatedList;
                    var previousTotal = ((isNaN(rec.previousContractTotal) ? 0 : rec.previousContractTotal));
                    var currentTotal = ((isNaN(rec.currentContractTotal) ? 0 : rec.currentContractTotal));
                    var annualImapact = ((isNaN(rec.annualImpact) ? 0 : rec.annualImpact));
                    var businessImpact = ((isNaN(rec.businessImpact) ? 0 : rec.businessImpact));
                    var currentQuarterImpact = ((isNaN(rec.currentQuarterImpact) ? 0 : rec.currentQuarterImpact));
                    var previousTPT = ((isNaN(rec.previousTPT) ? 0 : rec.previousTPT));
                    var currentTPT = ((isNaN(rec.currentTPT) ? 0 : rec.currentTPT));
                    var priceVarianceFamilySummary = ((isNaN(rec.priceVariance) ? 0 : rec.priceVariance));
                    var volumeVarianceFamilySummary = ((isNaN(rec.volumeVariance) ? 0 : rec.volumeVariance));
                    var totalPreviousAwdQtySummary = ((isNaN(rec.previousQty) ? 0 : rec.previousQty));
                    var totalAwdQtySummary = ((isNaN(rec.awardedQty) ? 0 : rec.awardedQty));
                    /*totalPreviousQtyOS += totalPreviousAwdQtySummary;
                                totalAwardedQtyOS += totalAwdQtySummary;*/
                    summary[0] = parseInt(previousTotal);
                    summary[1] = parseInt(currentTotal);
                    summary[2] = parseInt(annualImapact);
                    summary[3] = parseInt(businessImpact);
                    summary[4] = parseInt(previousTPT);
                    summary[5] = parseInt(currentTPT);
                    summary[6] = parseInt(parseFloat(currentTPT) - parseFloat(previousTPT));
                    summary[7] = parseInt(priceVarianceFamilySummary);
                    summary[8] = parseInt(volumeVarianceFamilySummary);
                    summary[9] = ((!isFinite(previousTPT/previousTotal) ? 0 : (previousTPT/previousTotal)));
                    summary[10] = ((!isFinite(currentTPT/currentTotal) ? 0 : (currentTPT/currentTotal)));
                    summary[11] = parseInt(totalPreviousAwdQtySummary);
                    summary[12] = parseInt(totalAwdQtySummary);
                    summary[13] = parseInt(currentQuarterImpact);
                    openStatusFamilySummaryMap[rec.productFamily] = summary;
                }
            });
            var tempObj = {};
            let keys = Object.keys(openStatusFamilySummaryMap);
            keys.sort(function(a, b) { return openStatusFamilySummaryMap[b][2] - openStatusFamilySummaryMap[a][2] });
            for(var i=0; i<keys.length; i++){
                tempObj[keys[i]] = openStatusFamilySummaryMap[keys[i]];
            }
            openStatusFamilySummaryMap = tempObj;
            tempObj = {};
            
            let sortedKeys = Object.keys(openStatusFamilySummaryMap);
            for(var i=0; i<sortedKeys.length; i++){
                tempObj[sortedKeys[i]] = openStatusMap[sortedKeys[i]];
            }
            openStatusMap = tempObj;
            
            tempObj = {};
            
            component.set("v.openStatusFamilySummaryMap",openStatusFamilySummaryMap);
            component.set("v.openStatusMap",Object.entries(openStatusMap));
        }        
    },
})