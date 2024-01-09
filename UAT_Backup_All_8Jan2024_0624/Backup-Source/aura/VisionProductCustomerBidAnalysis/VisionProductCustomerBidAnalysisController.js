({
    handleClick1: function(component, event, helper){
        component.set("v.record.expand", true);
        component.set("v.record.showItem", true);
        component.set("v.relatedList", component.get("v.record.relatedList"));
        /*var product = event.getSource().get("v.name");
        var groupingList = component.get("v.groupingList");
        for(var i=0; i<groupingList.length; i++){
            if(groupingList[i].product == product){
                groupingList[i].showCustomers = true;
            }
        }
        component.set("v.groupingList", groupingList); */  
        
    },
    handleClick2: function(component, event, helper){
        component.set("v.record.expand", false);
        component.set("v.record.showItem", false);
        /*component.set("v.record.showItem", false);
        component.set("v.expandFamily", false);*/
    },
    expandAll: function(component, event, helper){
        component.set("v.record.expand", component.get("v.expandAll"));
        component.set("v.record.showItem", component.get("v.expandAll"));
        if(component.get("v.expandAll")){
         	component.set("v.relatedList", component.get("v.record.relatedList"));   
        } else{
            component.set("v.relatedList", null);
        }
    },
    doInit: function(component, event, helper){
        component.set("v.record.showItem", false);
        var productsList = component.get("v.record.relatedList");
        var previousTotal = 0; var currentTotal = 0; var annualImpact = 0; var businessImpact = 0; var currentQuarterImpact = 0; var previousQty = 0; var awardedQty = 0; var previousTPT = 0; 
        var currentTPT = 0; var priceVariance = 0; var volumeVariance = 0; var totalVariance = 0; var tptVariance = 0;
        for(var j=0; j<productsList.length; j++){
            if((productsList[j].bidType != 'RFP Bids' && (productsList[j].bidStatus == 'Declined by Customer' || productsList[j].bidStatus == 'DRL Rescinded' || productsList[j].bidStatus == 'DRL submitting under New Bid Number')) || productsList[j].businessCategory == 'No Effect'){
                
            } /*else if(productsList[j].bidType == 'RFP Bids' && (productsList[j].bidStatus == 'Declined by Customer' || productsList[j].bidStatus == 'DRL Rescinded')){
                previousTotal -= ((isNaN(productsList[j].previousContractTotal) ? 0 : productsList[j].previousContractTotal));
                currentTotal -= ((isNaN(productsList[j].currentContractTotal) ? 0 : productsList[j].currentContractTotal));
                annualImpact -= ((isNaN(productsList[j].annualImpact) ? 0 : productsList[j].annualImpact));
                businessImpact -= ((isNaN(productsList[j].businessImpact) ? 0 : productsList[j].businessImpact));
                previousQty -= ((isNaN(productsList[j].previousQty) ? 0 : productsList[j].previousQty));
                awardedQty -= ((isNaN(productsList[j].awardedQty) ? 0 : productsList[j].awardedQty));
                previousTPT -= ((isNaN(productsList[j].previousTPT) ? 0 : productsList[j].previousTPT));
                currentTPT -= ((isNaN(productsList[j].currentTPT) ? 0 : productsList[j].currentTPT));
                priceVariance -= ((isNaN(productsList[j].priceVariance) ? 0 : productsList[j].priceVariance));
                volumeVariance -= ((isNaN(productsList[j].volumeVariance) ? 0 : productsList[j].volumeVariance));
                totalVariance -= ((isNaN(productsList[j].totalVariance) ? 0 : productsList[j].totalVariance));
                tptVariance -= ((isNaN(productsList[j].totalTPTVariance) ? 0 : productsList[j].totalTPTVariance));
            } */
            else{
                if(productsList[j].bidStatus != 'DRL submitting under New Bid Number'){
                    previousTotal += ((isNaN(productsList[j].previousContractTotal) ? 0 : productsList[j].previousContractTotal));
                    currentTotal += ((isNaN(productsList[j].currentContractTotal) ? 0 : productsList[j].currentContractTotal));
                    annualImpact += ((isNaN(productsList[j].annualImpact) ? 0 : productsList[j].annualImpact));
                    businessImpact += ((isNaN(productsList[j].businessImpact) ? 0 : productsList[j].businessImpact));
                    currentQuarterImpact += ((isNaN(productsList[j].currentQuarterImpact) ? 0 : productsList[j].currentQuarterImpact));
                    previousQty += ((isNaN(productsList[j].previousQty) ? 0 : productsList[j].previousQty));
                    awardedQty += ((isNaN(productsList[j].awardedQty) ? 0 : productsList[j].awardedQty));
                    previousTPT += ((isNaN(productsList[j].previousTPT) ? 0 : productsList[j].previousTPT));
                    currentTPT += ((isNaN(productsList[j].currentTPT) ? 0 : productsList[j].currentTPT));
                    priceVariance += ((isNaN(productsList[j].priceVariance) ? 0 : productsList[j].priceVariance));
                    volumeVariance += ((isNaN(productsList[j].volumeVariance) ? 0 : productsList[j].volumeVariance));
                    totalVariance += ((isNaN(productsList[j].totalVariance) ? 0 : productsList[j].totalVariance));
                    tptVariance += ((isNaN(productsList[j].totalTPTVariance) ? 0 : productsList[j].totalTPTVariance));   
                }
            }
            if(productsList[j].bidRecord.Phoenix_Bid_Submitted_Date__c){
                productsList[j].formattedSubmittedDate = new Date(productsList[j].bidRecord.Phoenix_Bid_Submitted_Date__c).toLocaleDateString("en-US", { year: "numeric", month: "2-digit", day: "2-digit" });
            }
            if(productsList[j].bidRecord.Phoenix_Bid_Closed_Date__c){
                productsList[j].formattedClosedDate = new Date(productsList[j].bidRecord.Phoenix_Bid_Closed_Date__c).toLocaleDateString("en-US", { year: "numeric", month: "2-digit", day: "2-digit" });
            }
        }
        var custSummary = {};
        custSummary.previousTotal = previousTotal;custSummary.currentTotal = currentTotal;custSummary.annualImpact = annualImpact;custSummary.businessImpact = businessImpact;custSummary.currentQuarterImpact = currentQuarterImpact;
        custSummary.previousQty = previousQty; custSummary.awardedQty = awardedQty;
        custSummary.previousTPT = previousTPT; custSummary.currentTPT = currentTPT; custSummary.priceVariance = priceVariance; custSummary.volumeVariance = volumeVariance;
        custSummary.totalVariance = totalVariance; custSummary.tptVariance = tptVariance;
        custSummary.previousTPTPer = ((!isFinite(custSummary.previousTPT/custSummary.previousTotal) ? 0 : (custSummary.previousTPT/custSummary.previousTotal)));
        custSummary.currentTPTPer = ((!isFinite(custSummary.currentTPT/custSummary.currentTotal) ? 0 : (custSummary.currentTPT/custSummary.currentTotal)));
        component.set("v.custSummary", custSummary);
        if(component.get("v.expandAll")){
         	component.set("v.relatedList", component.get("v.record.relatedList"));   
        } else{
            component.set("v.relatedList", null);
        }
        component.set("v.record.expand", component.get("v.expandAll"));
        component.set("v.record.showItem", component.get("v.expandAll"));

    },
    showDropDown : function(component, event, helper) {
        var product = event.getSource().get("v.name");
        var groupingList = component.get("v.record.relatedList");
        for(var i=0; i<groupingList.length; i++){
            if(groupingList[i].bidLineItem.Id == product){
                if(groupingList[i].showDropdown){
                 	groupingList[i].showDropdown = false;
                } else{
                    groupingList[i].showDropdown = true;
                }
            }
        }
        component.set("v.record.groupingList", groupingList);
        component.set("v.relatedList", groupingList);
    },
    
    mouseOver: function(component, event, helper){
        var product = event.getSource().get("v.title");
        var groupingList = component.get("v.record.relatedList");
        for(var i=0; i<groupingList.length; i++){
            if(groupingList[i].bidLineItem.Id == product){
                if(groupingList[i].showTooltip){
                 	groupingList[i].showTooltip = false;
                } else{
                    groupingList[i].showTooltip = true;
                }
            }
        }
        component.set("v.record.groupingList", groupingList);
        component.set("v.relatedList", groupingList);
        var index = component.get("v.index");
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
        component.set("v.top", top);
    },
    mouseOut: function(component, event, helper){
        var product = event.getSource().get("v.title");
        var groupingList = component.get("v.record.relatedList");
        for(var i=0; i<groupingList.length; i++){
            if(groupingList[i].bidLineItem.Id == product){
                if(groupingList[i].showTooltip){
                 	groupingList[i].showTooltip = false;
                } else{
                    groupingList[i].showTooltip = true;
                }
            }
        }
        component.set("v.record.groupingList", groupingList);
        component.set("v.relatedList", groupingList);
    },
})