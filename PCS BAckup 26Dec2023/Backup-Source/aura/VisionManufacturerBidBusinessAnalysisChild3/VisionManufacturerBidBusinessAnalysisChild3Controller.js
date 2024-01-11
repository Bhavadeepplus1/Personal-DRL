({
    doInit: function(component, event, helper){
        var productMap = component.get("v.productMap");
        var product = component.get("v.product");
        var relatedProductList = productMap[product];
        var obj = {}; var previousContractTotal = 0; var currentContractTotal = 0; var annualImpact = 0; var businessImpact = 0;
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
            }*/  else{
                if(relatedProductList[i].bidStatus != 'DRL submitting under New Bid Number'){
                    previousContractTotal += (isNaN(relatedProductList[i].previousContractTotal) ? 0: relatedProductList[i].previousContractTotal);
                    currentContractTotal += (isNaN(relatedProductList[i].currentContractTotal) ? 0: relatedProductList[i].currentContractTotal);
                    annualImpact += (isNaN(relatedProductList[i].annualImpact) ? 0: relatedProductList[i].annualImpact);
                    businessImpact += (isNaN(relatedProductList[i].businessImpact) ? 0: relatedProductList[i].businessImpact);
                    previousQty += (isNaN(relatedProductList[i].previousQty) ? 0: relatedProductList[i].previousQty);
                    awardedQty += (isNaN(relatedProductList[i].awardedQty) ? 0: relatedProductList[i].awardedQty);
                    previousTPT += (isNaN(relatedProductList[i].previousTPT) ? 0: relatedProductList[i].previousTPT);
                    currentTPT += (isNaN(relatedProductList[i].currentTPT) ? 0: relatedProductList[i].currentTPT);
                    priceVariance += (isNaN(relatedProductList[i].priceVariance) ? 0: relatedProductList[i].priceVariance);
                    volumeVariance += (isNaN(relatedProductList[i].volumeVariance) ? 0: relatedProductList[i].volumeVariance);
                    totalVariance += (isNaN(relatedProductList[i].totalVariance) ? 0: relatedProductList[i].totalVariance);
                    totalTPTVariance += (isNaN(relatedProductList[i].totalTPTVariance) ? 0: relatedProductList[i].totalTPTVariance);   
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
        component.set("v.productLevelSummary", obj);
    },
    expandProduct: function(component, event, helper){
        var expandProduct = component.get("v.expandProduct");
        var productMap = component.get("v.productMap");
        var product = component.get("v.product");
        console.log('Product Map: '+JSON.stringify(productMap));
        console.log('Product: '+product);
		var relatedProductList = productMap[product];
        var customerMap = {};
        for(var i=0; i<relatedProductList.length; i++){
            var customerName;
            if(relatedProductList[i].hasOwnProperty('customer')){
                customerName = relatedProductList[i].customer;
            } else if(relatedProductList[i].bidLineItem.hasOwnProperty('Phoenix_Customer__r')){
                customerName = relatedProductList[i].bidLineItem.Phoenix_Customer__r.Name;
            }
            if(customerMap.hasOwnProperty(customerName)){
                var familyRelatedList = customerMap[customerName];
                familyRelatedList.push(relatedProductList[i]);
                if(customerName != null){
                    customerMap[customerName] = familyRelatedList;                            
                }
                
            } else{
                var familyRelatedList = [];
                familyRelatedList.push(relatedProductList[i]);
                if(customerName != null){
                    customerMap[customerName] = familyRelatedList;  
                }
            }   
        }
        //component.set("v.relatedProductList", productMap[product]);
        component.set("v.customerMapList", Object.keys(customerMap));
        component.set("v.customerMap", customerMap);
        console.log('Customer Map: '+JSON.stringify(customerMap));
        if(expandProduct){
            component.set("v.expandProduct", false);
        } else{
            component.set("v.expandProduct", true);
        }
        
    },
    showDropDown: function(component, event, helper){
        var lineItemId = event.getSource().get("v.name");
        var productMap = component.get("v.productMap");
        var product = component.get("v.product");
        var relatedProductList = productMap[product];
        for(var i=0; i<relatedProductList.length; i++){
            if(relatedProductList[i].bidLineItem.Id == lineItemId){
                if(relatedProductList[i].showDropdown){
                    relatedProductList[i].showDropdown = false;
                } else{
                    relatedProductList[i].showDropdown = true;
                }
            }
        }
        component.set("v.relatedProductList", relatedProductList);
    },
    mouseOver: function(component, event, helper){
        var product = event.getSource().get("v.title");
        var groupingList = component.get("v.relatedProductList");
        for(var i=0; i<groupingList.length; i++){
            if(groupingList[i].bidLineItem.Id == product){
                if(groupingList[i].bidRecord.Phoenix_Bid_Submitted_Date__c){
                    groupingList[i].formattedSubmittedDate = new Date(groupingList[i].bidRecord.Phoenix_Bid_Submitted_Date__c).toLocaleDateString("en-US", { year: "numeric", month: "2-digit", day: "2-digit" });
                }
                if(groupingList[i].bidRecord.Phoenix_Bid_Closed_Date__c){
                    groupingList[i].formattedClosedDate = new Date(groupingList[i].bidRecord.Phoenix_Bid_Closed_Date__c).toLocaleDateString("en-US", { year: "numeric", month: "2-digit", day: "2-digit" });
                }
                if(groupingList[i].showTooltip){
                 	groupingList[i].showTooltip = false;
                } else{
                    groupingList[i].showTooltip = true;
                }
            }
        }
        component.set("v.relatedProductList", groupingList);
        /*var index = component.get("v.index");
        var top = component.get("v.top");
        var size = component.get("v.size");
        if(index > 5 && (index == size || index == (size-1) || index == (size-2) || index == (size-3) || index == (size-4))){
            top = '-130px;';
            component.set("v.isLastRows", true);
        } else if(index == 1){
            top = '-50.5px;';
        } else if(index == 2){
            top = '-79px;';
        } else if(index == 3){
            top = '-107.5px;';
        } else if(index == 4){
            top = '-136px;';
        } else if(index == 5){
            top = '-164.5px;';
        }
        component.set("v.top", top);*/
    },
    mouseOut: function(component, event, helper){
        var product = event.getSource().get("v.title");
        var groupingList = component.get("v.relatedProductList");
        for(var i=0; i<groupingList.length; i++){
            if(groupingList[i].bidLineItem.Id == product){
                if(groupingList[i].showTooltip){
                 	groupingList[i].showTooltip = false;
                } else{
                    groupingList[i].showTooltip = true;
                }
            }
        }
        component.set("v.relatedProductList", groupingList);
    },
    
})