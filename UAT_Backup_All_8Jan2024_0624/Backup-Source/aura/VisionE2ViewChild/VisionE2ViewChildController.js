({
	doInit : function(component, event, helper) {
        var productMapObj = component.get("v.productMapObj");
        var product = component.get("v.product");
        var relatedList = productMapObj[product];
        var familyCurrentSales = 0; var familyProposedSales = 0; var familyAwardedSales = 0; var familyDifference = 0;
        for(var i=0; i<relatedList.length; i++){
            var awardedQty = ((relatedList[i].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c != null) ? relatedList[i].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c : 0);
            var proposedASP = ((relatedList[i].Phoenix_Proposed_ASP_Dose__c != null) ? relatedList[i].Phoenix_Proposed_ASP_Dose__c : 0);
            var currentSales = ((relatedList[i].Phoenix_Current_Sales_Finance__c != null) ? relatedList[i].Phoenix_Current_Sales_Finance__c : 0);
            var proposedQty = ((relatedList[i].Phoenix_Final_Total_Selling_Unit__c != null) ? relatedList[i].Phoenix_Final_Total_Selling_Unit__c : 0);
            var awardedSales = awardedQty*proposedASP; 
            var proposedSales = proposedQty*proposedASP;
            familyCurrentSales += currentSales;
            familyProposedSales += proposedSales;
            familyAwardedSales += awardedSales;
            relatedList[i].awardedSales = awardedSales;
            relatedList[i].proposedSales = proposedSales;
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
            familyDifference += relatedList[i].increseDecrease;
        }
        var sortedList = [];
        if(component.get("v.status") == 'Awarded'){
            sortedList = relatedList.sort(
                (p1, p2) => (p1.awardedSales < p2.awardedSales) ? 1 : (p1.awardedSales > p2.awardedSales) ? -1 : 0);   
        } else{
            sortedList = relatedList.sort(
                (p1, p2) => (p1.proposedSales < p2.proposedSales) ? 1 : (p1.proposedSales > p2.proposedSales) ? -1 : 0);               
        }
        
        component.set("v.relatedList", sortedList);
        var obj = {};
        obj.familyCurrentSales = familyCurrentSales;
        obj.familyProposedSales = familyProposedSales;
        obj.familyAwardedSales = familyAwardedSales;
        obj.familyDifference = familyDifference;
        component.set("v.productSummaryObj", obj);
	},
    expandProduct: function(component, event, helper){
        var expandProduct = component.get("v.expandProduct");
        if(expandProduct){
            component.set("v.expandProduct", false);   
        } else{
            component.set("v.expandProduct", true);
        }
    }
})