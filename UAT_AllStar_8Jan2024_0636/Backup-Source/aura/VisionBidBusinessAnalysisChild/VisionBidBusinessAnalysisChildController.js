({
    handleClick1: function(component, event, helper){
        component.set("v.expandFamily", true);
        component.set("v.record.showItem", true);
    },
    handleClick2: function(component, event, helper){
        component.set("v.expandFamily", false);
        component.set("v.record.showItem", false);
    },
    expandAll: function(component, event, helper){
        component.set("v.expandFamily", component.get("v.expandAll"));
        component.set("v.record.showItem", component.get("v.expandAll"));
        var currentTabId = component.get("v.currentTabId");
        if(currentTabId == 'tabThree'){
            var groupingList = component.get("v.groupingList");
            for(var i=0; i<groupingList.length; i++){
                groupingList[i].showCustomers = component.get("v.expandAll");
            }
            component.set("v.groupingList", groupingList); 
        }
        
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
        var currentTabId = component.get("v.currentTabId");
        if(currentTabId != 'tabThree'){
            var record = component.get("v.record[0]");
            var productsList = component.get("v.record[1]");
            var summary = component.get("v.familySummaryMap");
            component.set("v.summaryList", summary[record]);
            productsList.sort(function(a, b) {
                return parseFloat(b.annualImpact) - parseFloat(a.annualImpact); 
            });  
            component.set("v.expandFamily", component.get("v.expandAll"));
            component.set("v.record.showItem", component.get("v.expandAll"));
        } else{
            var record = component.get("v.record[0]");
            var productsList = component.get("v.record[1]");
            var summary = component.get("v.familySummaryMap");
            component.set("v.summaryList", summary[record]);
            if(productsList != null){
                var productIds = [];
                var groupingList = [];
                for(var i=0; i<productsList.length; i++){
                    if(!productIds.includes(productsList[i].bidLineItem.Phoenix_Product__r.Id)){
                        productIds.push(productsList[i].bidLineItem.Phoenix_Product__r.Id);   
                    }
                }
                for(var i=0; i<productIds.length; i++){
                    var obj = {};
                    var lst = []; var customerIds = [];
                    var previousTotal = 0; var currentTotal = 0; var annualImpact = 0; var businessImpact = 0; var currentQuarterImpact = 0; var previousQty = 0; var awardedQty = 0; var previousTPT = 0; 
                    var currentTPT = 0; var priceVariance = 0; var volumeVariance = 0; var totalVariance = 0; var tptVariance = 0;
                    for(var j=0; j<productsList.length; j++){
                        productsList[j].showDropdown = false;
                        if(productsList[j].bidLineItem.Phoenix_Product__r.Id == productIds[i]){
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
                            }*/
                            else{
                                if(productsList[j].bidStatus != 'DRL submitting under New Bid Number'){
                                    previousTotal += ((isNaN(productsList[j].previousContractTotal) ? 0 : parseFloat(productsList[j].previousContractTotal)));
                                    currentTotal += ((isNaN(productsList[j].currentContractTotal) ? 0 : parseFloat(productsList[j].currentContractTotal)));
                                    annualImpact += ((isNaN(productsList[j].annualImpact) ? 0 : parseFloat(productsList[j].annualImpact)));
                                    businessImpact += ((isNaN(productsList[j].businessImpact) ? 0 : parseFloat(productsList[j].businessImpact)));
                                    currentQuarterImpact += ((isNaN(productsList[j].currentQuarterImpact) ? 0 : parseFloat(productsList[j].currentQuarterImpact)));
                                    previousQty += ((isNaN(productsList[j].previousQty) ? 0 : parseFloat(productsList[j].previousQty)));
                                    awardedQty += ((isNaN(productsList[j].awardedQty) ? 0 : parseFloat(productsList[j].awardedQty)));
                                    previousTPT += ((isNaN(productsList[j].previousTPT) ? 0 : parseFloat(productsList[j].previousTPT)));
                                    currentTPT += ((isNaN(productsList[j].currentTPT) ? 0 : parseFloat(productsList[j].currentTPT)));
                                    priceVariance += ((isNaN(productsList[j].priceVariance) ? 0 : parseFloat(productsList[j].priceVariance)));
                                    volumeVariance += ((isNaN(productsList[j].volumeVariance) ? 0 : parseFloat(productsList[j].volumeVariance)));
                                    totalVariance += ((isNaN(productsList[j].totalVariance) ? 0 : parseFloat(productsList[j].totalVariance)));
                                    tptVariance += ((isNaN(productsList[j].totalTPTVariance) ? 0 : parseFloat(productsList[j].totalTPTVariance)));
                                }
                            }
                            lst.push(productsList[j]);
                            if(productsList[j].bidRecord.Phoenix_Customer__c != null && !customerIds.includes(productsList[j].bidRecord.Phoenix_Customer__c)){
                                customerIds.push(productsList[j].bidRecord.Phoenix_Customer__c);
                            }
                            obj.id = productsList[j].bidLineItem.Phoenix_Product__r.Id;
                            obj.product = productsList[j].productName;
                        }
                    }
                    var customerGroupingList = [];
                    for(var k=0; k<customerIds.length; k++){
                        var custObj = {}; var internalList = [];
                        for(var l=0; l<lst.length; l++){
                            lst[l].showDropdown = false;
                            if(lst[l].bidRecord.Phoenix_Customer__c == customerIds[k]){
                                internalList.push(lst[l]);
                                custObj.customerId = lst[l].bidRecord.Phoenix_Customer__c;
                                if(lst[l].bidRecord.Phoenix_Customer__r){
                                    custObj.customer = lst[l].bidRecord.Phoenix_Customer__r.Name;
                                }
                            }
                        }
                        custObj.relatedList = internalList;
                        customerGroupingList.push(custObj);                        
                    }
                    obj.customerGroupingList = customerGroupingList;
                    obj.relatedList = lst;
                    obj.previousTotal = previousTotal;obj.currentTotal = currentTotal;obj.annualImpact = annualImpact;obj.businessImpact = businessImpact; obj.currentQuarterImpact = currentQuarterImpact;
                    obj.previousQty = previousQty; obj.awardedQty = awardedQty; /*obj.previousDeadnet = previousDeadnet; obj.currentDeadnet = currentDeadnet;*/
                    obj.previousTPT = previousTPT; obj.currentTPT = currentTPT; obj.priceVariance = priceVariance; obj.volumeVariance = volumeVariance;
                    obj.totalVariance = totalVariance; obj.tptVariance = tptVariance;
                    obj.previousTPTPer = ((!isFinite(obj.previousTPT/obj.previousTotal) ? 0 : (obj.previousTPT/obj.previousTotal)));
                    obj.currentTPTPer = ((!isFinite(obj.currentTPT/obj.currentTotal) ? 0 : (obj.currentTPT/obj.currentTotal)));
                    //console.log('Object::::: '+JSON.stringify(obj));
                    groupingList.push(obj);
                }
                component.set("v.expandFamily", component.get("v.expandAll"));
                component.set("v.record.showItem", component.get("v.expandAll"));
                component.set("v.groupingList", groupingList);
            }
            
            productsList.sort(function(a, b) {
                return parseFloat(b.annualImpact) - parseFloat(a.annualImpact); 
            });   
            //console.log('productsList: '+JSON.stringify(productsList));
        }
        
    },
})