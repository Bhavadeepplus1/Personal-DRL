({
	doInit : function(component, event, helper) {
        console.log('Ok');
        var customerMap = component.get("v.customerMap");
        var customer = component.get("v.customer");
        var relatedProductList = customerMap[customer];
        component.set("v.relatedProductList", relatedProductList);
        var obj = {}; var previousContractTotal = 0; var currentContractTotal = 0; var annualImpact = 0; var businessImpact = 0;
        var previousQty = 0; var awardedQty = 0; var previousTPT = 0; var currentTPT = 0; var priceVariance = 0; var volumeVariance = 0;
        var totalVariance = 0; var totalTPTVariance= 0;
        for(var i=0; i<relatedProductList.length; i++){
            if((relatedProductList[i].bidType != 'RFP Bids' && (relatedProductList[i].bidStatus == 'Declined by Customer' || relatedProductList[i].bidStatus == 'DRL Rescinded' || relatedProductList[i].bidStatus == 'DRL submitting under New Bid Number')) || relatedProductList[i].businessCategory == 'No Effect'){
                
            } else{
                if(relatedProductList[i].bidStatus != 'DRL submitting under New Bid Number'){
                    previousContractTotal += (isNaN(relatedProductList[i].previousContractTotal) ? 0: parseFloat(relatedProductList[i].previousContractTotal));
                    currentContractTotal += (isNaN(relatedProductList[i].currentContractTotal) ? 0: parseFloat(relatedProductList[i].currentContractTotal));
                    annualImpact += (isNaN(relatedProductList[i].annualImpact) ? 0: parseFloat(relatedProductList[i].annualImpact));
                    businessImpact += (isNaN(relatedProductList[i].businessImpact) ? 0: parseFloat(relatedProductList[i].businessImpact));
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
        obj.previousContractTotal = parseInt(previousContractTotal);
        obj.currentContractTotal = parseInt(currentContractTotal);
        obj.annualImpact = parseInt(annualImpact);
        obj.businessImpact = parseInt(businessImpact);
        obj.previousQty = parseInt(previousQty);
        obj.awardedQty = parseInt(awardedQty);
        obj.previousTPT = parseInt(previousTPT);
        obj.currentTPT = parseInt(currentTPT);
        obj.previousTPTPer = obj.previousTPT/(obj.previousContractTotal);
        obj.currentTPTPer = obj.currentTPT/(obj.currentContractTotal);
        obj.priceVariance = parseInt(priceVariance);
        obj.volumeVariance = parseInt(volumeVariance);
        obj.totalVariance = parseInt(totalVariance);
        obj.totalTPTVariance = parseInt(totalTPTVariance);
        component.set("v.customerLevelSummary", obj);
	},
    
    expandCustomer: function(component, event, helper){
        var expandCustomer = component.get("v.expandCustomer");
        console.log('::::::::::::::::::: '+JSON.stringify(component.get("v.relatedProductList")));
        if(expandCustomer){
            component.set("v.expandCustomer", false);
        } else{
            component.set("v.expandCustomer", true);
        }
    }
})