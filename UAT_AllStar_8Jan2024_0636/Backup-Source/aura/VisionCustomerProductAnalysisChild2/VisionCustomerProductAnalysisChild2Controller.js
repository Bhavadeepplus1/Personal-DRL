({
	doInit : function(component, event, helper) {
		var family = component.get("v.family");
        var familyMap = component.get("v.familyMap");
        var relatedProductList = familyMap[family];
        component.set("v.familyRelatedProducts", relatedProductList);
        var productMap = {};
        for(var i=0; i<relatedProductList.length; i++){
            if(productMap.hasOwnProperty(relatedProductList[i].productName)){
                var familyRelatedList = productMap[relatedProductList[i].productName];
                familyRelatedList.push(relatedProductList[i]);
                productMap[relatedProductList[i].productName] = familyRelatedList;                            
            } else{
                var familyRelatedList = [];
                familyRelatedList.push(relatedProductList[i]);
                productMap[relatedProductList[i].productName] = familyRelatedList;
            }   
        }
        component.set("v.productMap", productMap);
        component.set("v.productList", Object.keys(productMap));
        
        var obj = {}; var previousContractTotal = 0; var currentContractTotal = 0; var annualImpact = 0; var businessImpact = 0;
        var previousQty = 0; var awardedQty = 0; var previousTPT = 0; var currentTPT = 0; var priceVariance = 0; var volumeVariance = 0;
        var totalVariance = 0; var totalTPTVariance= 0;
        for(var i=0; i<relatedProductList.length; i++){
            if((relatedProductList[i].bidType != 'RFP Bids' && (relatedProductList[i].bidStatus == 'Declined by Customer' || relatedProductList[i].bidStatus == 'DRL Rescinded' || relatedProductList[i].bidStatus == 'DRL submitting under New Bid Number')) || relatedProductList[i].businessCategory == 'No Effect'){
                
            }/*  else if(relatedProductList[i].bidType == 'RFP Bids' && (relatedProductList[i].bidStatus == 'Declined by Customer' || relatedProductList[i].bidStatus == 'DRL Rescinded')){
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
                    previousQty += (isNaN(relatedProductList[i].previousQty) ? 0: parseFloat(relatedProductList[i].previousQty));
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
        component.set("v.familyLevelSummary", obj);
	},
    
    expandFamily: function(component, event, helper){
        var expandFamily = component.get("v.expandFamily");
        if(expandFamily){
            component.set("v.expandFamily", false);
        } else{
            component.set("v.expandFamily", true)
        }
    }
})