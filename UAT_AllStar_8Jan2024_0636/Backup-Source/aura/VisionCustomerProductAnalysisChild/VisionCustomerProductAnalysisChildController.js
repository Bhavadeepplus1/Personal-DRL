({
    doInit : function(component, event, helper) {
        var customerId = component.get("v.customerId");
        var customerGroupedData = component.get("v.customerGroupedData");
        var relatedProductList = customerGroupedData[customerId];
        component.set("v.relatedFamilyList", relatedProductList);
        console.log('Expand All in Customer Product Child: '+component.get("v.expandAll"));
        component.set("v.expandCustomer", component.get("v.expandAll"));
        var familyMap = {}; var bidTypeMap = {}; var bidTypeSummaryMap = {};
        
        relatedProductList.forEach(function(rec){
            if(bidTypeMap.hasOwnProperty(rec.bidType)){
                var relatedList = bidTypeMap[rec.bidType]; var summary = [];
                relatedList.push(rec);
                bidTypeMap[rec.bidType] = relatedList;
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
                bidTypeSummaryMap[rec.bidType] = summary;
            } else{
                var relatedList = [];var summary = [];
                relatedList.push(rec);
                bidTypeMap[rec.bidType] = relatedList;
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
                bidTypeSummaryMap[rec.bidType] = summary;
            }
        });
        
        
        component.set("v.expandCustomer", component.get("v.expandAll"));
        component.set("v.bidTypeMap", Object.entries(bidTypeMap));
        component.set("v.bidTypeSummaryMap", bidTypeSummaryMap);
        
        for(var i=0; i<relatedProductList.length; i++){
            if(familyMap.hasOwnProperty(relatedProductList[i].productFamily)){
                var familyRelatedList = familyMap[relatedProductList[i].productFamily];
                familyRelatedList.push(relatedProductList[i]);
                if(relatedProductList[i].productFamily != null && relatedProductList[i].productFamily != null){
                    familyMap[relatedProductList[i].productFamily] = familyRelatedList;                            
                }
                
            } else{
                var familyRelatedList = [];
                familyRelatedList.push(relatedProductList[i]);
                if(relatedProductList[i].productFamily != null && relatedProductList[i].productFamily != null){
                    familyMap[relatedProductList[i].productFamily] = familyRelatedList;  
                }
                
            }   
        }
        component.set("v.familyList", Object.keys(familyMap));
        component.set("v.familyMap", familyMap);
        
        var obj = {}; var previousContractTotal = 0; var currentContractTotal = 0; var annualImpact = 0; var businessImpact = 0; var currentQuarterImpact = 0;
        var previousQty = 0; var awardedQty = 0; var previousTPT = 0; var currentTPT = 0; var priceVariance = 0; var volumeVariance = 0;
        var totalVariance = 0; var totalTPTVariance= 0;
        for(var i=0; i<relatedProductList.length; i++){
            if((relatedProductList[i].bidType != 'RFP Bids' && (relatedProductList[i].bidStatus == 'Declined by Customer' || relatedProductList[i].bidStatus == 'DRL Rescinded' || relatedProductList[i].bidStatus == 'DRL submitting under New Bid Number')) || relatedProductList[i].businessCategory == 'No Effect'){
                
            }/* else if(relatedProductList[i].bidType == 'RFP Bids' && (relatedProductList[i].bidStatus == 'Declined by Customer' || relatedProductList[i].bidStatus == 'DRL Rescinded')){
                previousContractTotal -= (isNaN(relatedProductList[i].previousContractTotal) ? 0: relatedProductList[i].previousContractTotal);
                currentContractTotal -= (isNaN(relatedProductList[i].currentContractTotal) ? 0: relatedProductList[i].currentContractTotal);
                annualImpact -= (isNaN(relatedProductList[i].annualImpact) ? 0: relatedProductList[i].annualImpact);
                businessImpact -= (isNaN(relatedProductList[i].businessImpact) ? 0: relatedProductList[i].businessImpact);
                previousQty -= (isNaN(relatedProductList[i].previousQty) ? 0: relatedProductList[i].previousQty);
                awardedQty -= (isNaN(relatedProductList[i].awardedQty) ? 0: relatedProductList[i].awardedQty);
                previousTPT -= (isNaN(relatedProductList[i].previousTPT) ? 0: relatedProductList[i].previousTPT);
                currentTPT -= (isNaN(relatedProductList[i].currentTPT) ? 0: relatedProductList[i].currentTPT);
                priceVariance -= (isNaN(relatedProductList[i].priceVariance) ? 0: relatedProductList[i].priceVariance);
                volumeVariance -= (isNaN(relatedProductList[i].volumeVariance) ? 0: relatedProductList[i].volumeVariance);
                totalVariance -= (isNaN(relatedProductList[i].totalVariance) ? 0: relatedProductList[i].totalVariance);
                totalTPTVariance -= (isNaN(relatedProductList[i].totalTPTVariance) ? 0: relatedProductList[i].totalTPTVariance);                
            }*/ else{
                if(relatedProductList[i].bidStatus != 'DRL submitting under New Bid Number'){
                    previousContractTotal += (isNaN(relatedProductList[i].previousContractTotal) ? 0: parseFloat(relatedProductList[i].previousContractTotal));
                    currentContractTotal += (isNaN(relatedProductList[i].currentContractTotal) ? 0: parseFloat(relatedProductList[i].currentContractTotal));
                    annualImpact += (isNaN(relatedProductList[i].annualImpact) ? 0: parseFloat(relatedProductList[i].annualImpact));
                    businessImpact += (isNaN(relatedProductList[i].businessImpact) ? 0: parseFloat(relatedProductList[i].businessImpact));
                    currentQuarterImpact += (isNaN(relatedProductList[i].currentQuarterImpact) ? 0: parseFloat(relatedProductList[i].currentQuarterImpact));
                    if(relatedProductList[i].previousQty != null){
                        previousQty += (isNaN(relatedProductList[i].previousQty) ? 0: parseFloat(relatedProductList[i].previousQty));   
                    } else{
                        relatedProductList[i].previousQty = 0;
                        previousQty += 0;
                    }
                    awardedQty += (isNaN(relatedProductList[i].awardedQty) ? 0: parseFloat(relatedProductList[i].awardedQty));
                    previousTPT += (isNaN(relatedProductList[i].previousTPT) ? 0: parseFloat(relatedProductList[i].previousTPT));
                    currentTPT += (isNaN(relatedProductList[i].currentTPT) ? 0: parseFloat(relatedProductList[i].currentTPT));
                    priceVariance += (isNaN(relatedProductList[i].priceVariance) ? 0: parseFloat(relatedProductList[i].priceVariance));
                    volumeVariance += (isNaN(relatedProductList[i].volumeVariance) ? 0: parseFloat(relatedProductList[i].volumeVariance));
                    totalVariance += (isNaN(relatedProductList[i].totalVariance) ? 0: parseFloat(relatedProductList[i].totalVariance));
                    totalTPTVariance += (isNaN(relatedProductList[i].totalTPTVariance) ? 0: parseFloat(relatedProductList[i].totalTPTVariance));   
                }
            }
        }
        obj.previousContractTotal = parseFloat(previousContractTotal);
        obj.currentContractTotal = parseFloat(currentContractTotal);
        obj.annualImpact = parseFloat(annualImpact);
        obj.businessImpact = parseFloat(businessImpact);
        obj.currentQuarterImpact = parseFloat(currentQuarterImpact);
        obj.previousQty = parseFloat(previousQty);
        obj.awardedQty = parseFloat(awardedQty);
        obj.previousTPT = parseFloat(previousTPT);
        obj.currentTPT = parseFloat(currentTPT);
        obj.previousTPTPer = obj.previousTPT/(obj.previousContractTotal);
        obj.currentTPTPer = obj.currentTPT/(obj.currentContractTotal);
        obj.priceVariance = parseFloat(priceVariance);
        obj.volumeVariance = parseFloat(volumeVariance);
        obj.totalVariance = parseFloat(totalVariance);
        obj.totalTPTVariance = parseFloat(totalTPTVariance);
        component.set("v.customerLevelSummary", obj);
    },
    expandCustomer: function(component, event, helper){
        var expandCustomer = component.get("v.expandCustomer");
        if(expandCustomer){
            component.set("v.expandCustomer", false);
        } else{
            component.set("v.expandCustomer", true);
        }
    }
})