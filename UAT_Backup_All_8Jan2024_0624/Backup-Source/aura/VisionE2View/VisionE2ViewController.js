({
    doInit : function(component, event, helper) {
        var data = component.get("v.data");
        var familyMap = {};
        if(data != null){
            for(var i=0; i<data.length;i++){
                if(data[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == component.get("v.status")){
                    if(familyMap.hasOwnProperty(data[i].Product_Family_Name__c)){
                        var relatedList = familyMap[data[i].Product_Family_Name__c];
                        relatedList.push(data[i]);
                        familyMap[data[i].Product_Family_Name__c] = relatedList;
                    } else{
                        var relatedList = [];
                        relatedList.push(data[i]);
                        familyMap[data[i].Product_Family_Name__c] = relatedList;
                    }   
                }
            }   
        }
        component.set("v.familyKeys", Object.keys(familyMap));
        component.set("v.familyMapObj", familyMap);
        var family = component.get("v.family");
        var relatedList = familyMap[family];
        if(relatedList != null){
            component.set("v.bidType", relatedList[0].Phoenix_Bid__r.Phoenix_Bid_Type__c);
            var bidCurrentSales = 0; var bidProposedSales = 0; var bidAwardedSales = 0; var bidDifference = 0;
            for(var i=0; i<relatedList.length; i++){
                var awardedQty = ((relatedList[i].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c != null) ? relatedList[i].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c : 0);
                var proposedASP = ((relatedList[i].Phoenix_Proposed_ASP_Dose__c != null) ? relatedList[i].Phoenix_Proposed_ASP_Dose__c : 0);
                var currentSales = ((relatedList[i].Phoenix_Current_Sales_Finance__c != null) ? relatedList[i].Phoenix_Current_Sales_Finance__c : 0);
                var proposedQty = ((relatedList[i].Phoenix_Final_Total_Selling_Unit__c != null) ? relatedList[i].Phoenix_Final_Total_Selling_Unit__c : 0);
                var awardedSales = awardedQty*proposedASP; 
                var proposedSales = proposedQty*proposedASP;
                bidCurrentSales += currentSales;
                bidProposedSales += proposedSales;
                bidAwardedSales += awardedSales;
                if((relatedList[i].Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Price Change' || relatedList[i].Phoenix_Bid__r.Phoenix_Bid_Type__c == 'OTC Price Change' ||
                    ((relatedList[i].Phoenix_Bid__r.Phoenix_Bid_Type__c == 'RFP Bids' || relatedList[i].Phoenix_Bid__r.Phoenix_Bid_Type__c == 'OTC RFP') && ((awardedQty * proposedASP) - currentSales) < 0 && currentSales > 0))){
                    if(relatedList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Awarded'){
                        relatedList[i].increseDecrease = awardedSales-currentSales;
                    } else if(relatedList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Declined by Customer'){
                        relatedList[i].increseDecrease = 0-currentSales;
                    }
                } else if(((relatedList[i].Phoenix_Bid__r.Phoenix_Bid_Type__c == 'RFP Bids' || relatedList[i].Phoenix_Bid__r.Phoenix_Bid_Type__c == 'OTC RFP') && ((currentSales == 0 && ((awardedQty * proposedASP) > currentSales)) || (currentSales == 0 && ((proposedSales) > currentSales)))) || relatedList[i].Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Good Dated OTB' || relatedList[i].Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Short Dated OTB' || relatedList[i].Phoenix_Bid__r.Phoenix_Bid_Type__c == 'OTC OTB Good Dated' || relatedList[i].Phoenix_Bid__r.Phoenix_Bid_Type__c == 'OTC OTB Short Dated' || relatedList[i].Phoenix_Bid__r.Phoenix_Bid_Type__c == 'New Product Launch' || relatedList[i].Phoenix_Bid__r.Phoenix_Bid_Type__c == 'OTC New Product' || relatedList[i].Phoenix_Bid__r.Phoenix_Bid_Type__c == 'New Customer' || relatedList[i].Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Product Addition' || relatedList[i].Phoenix_Bid__r.Phoenix_Bid_Type__c == 'OTC Product Addition' ||  relatedList[i].Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Volume Review Only' ||  relatedList[i].Phoenix_Bid__r.Phoenix_Bid_Type__c == 'OTC Volume Review'){ 
                    if(relatedList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Awarded'){
                        relatedList[i].increseDecrease = awardedSales-currentSales;
                    } else if(relatedList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Declined by Customer'){
                        relatedList[i].increseDecrease = proposedSales-currentSales;
                    } 
                } else if(relatedList[i].Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Volume Review Only' || relatedList[i].Phoenix_Bid__r.Phoenix_Bid_Type__c == 'OTC Volume Review'){
                    if(relatedList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Awarded'){
                        relatedList[i].increseDecrease = awardedSales-currentSales;
                    } else if(relatedList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Declined by Customer'){
                        relatedList[i].increseDecrease = proposedSales-currentSales;
                    } 
                }
                bidDifference += relatedList[i].increseDecrease;
            }
            familyMap[family] = relatedList;
            var obj = {};
            obj.bidCurrentSales = bidCurrentSales;
            obj.bidProposedSales = bidProposedSales;
            obj.bidAwardedSales = bidAwardedSales;
            obj.bidDifference = bidDifference;
            component.set("v.familySummaryObj", obj);
        }
    },
    expandFamily: function(component, event, helper){
        var family = component.get("v.family");
        var familyMap = component.get("v.familyMapObj");
        var expandFamily = component.get("v.expandFamily");
        component.set("v.bidRelatedList", familyMap[family]);
        var productMap = {};
        var relatedItemsList = familyMap[family];
        if(relatedItemsList != null){
            for(var i=0; i<relatedItemsList.length;i++){
                var product = relatedItemsList[i].Phoenix_Product__r.Name;
                if(productMap.hasOwnProperty(product)){
                    var relatedList = productMap[product];
                    relatedList.push(relatedItemsList[i]);
                    productMap[product] = relatedList;
                } else{
                    var relatedList = [];
                    relatedList.push(relatedItemsList[i]);
                    productMap[product] = relatedList;
                }
            }   
        }		
        
        var tempSalesObj = {};
        var keys = Object.keys(productMap);
        for(var i=0; i<keys.length; i++){
            var relatedList = productMap[keys[i]];
            var productGroupSales = 0;
            for(var j=0; j<relatedList.length; j++){
                if(component.get("v.status") == 'Awarded'){
                    var awardedQty = ((relatedList[j].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c != null) ? relatedList[j].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c : 0);
                    var proposedASP = ((relatedList[j].Phoenix_Proposed_ASP_Dose__c != null) ? relatedList[j].Phoenix_Proposed_ASP_Dose__c : 0);
                    productGroupSales += awardedQty*proposedASP;  
                } else{
                    var proposedASP = ((relatedList[j].Phoenix_Proposed_ASP_Dose__c != null) ? relatedList[j].Phoenix_Proposed_ASP_Dose__c : 0);
                    var proposedQty = ((relatedList[j].Phoenix_Final_Total_Selling_Unit__c != null) ? relatedList[j].Phoenix_Final_Total_Selling_Unit__c : 0);
                    productGroupSales += proposedQty*proposedASP;
                }
            }
            tempSalesObj[keys[i]] = productGroupSales;
        }
        let updatedProductKeys = Object.keys(tempSalesObj);
        updatedProductKeys.sort(function(a, b) { return tempSalesObj[b] - tempSalesObj[a] });
        component.set("v.productKeys", updatedProductKeys);
        component.set("v.productMapObj", productMap);
        if(expandFamily){
            component.set("v.expandFamily", false);   
        } else{
            component.set("v.expandFamily", true);
        }
    }
})