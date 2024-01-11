({
	doInit : function(component, event, helper) {
        var productFamilyMap = {}; var productFamilyIdMap = {};
        var bidLineItems = component.get("v.positionWrap.bidLineItems");
        var summaryAtPositionObj = {};
        var CurrentBusinessQty = 0; var CurrentBusinessSales = 0; var CurrentBusinessTPT = 0;
        var BidRFPQty = 0; var BidRFPSales = 0; var BidRFPTPT = 0;
        var FinalRFPQty = 0; var FinalRFPSales = 0; var FinalRFPTPT = 0;
        var priceVariance = 0; var volumeVariance = 0; var totalVariance = 0;
        for(var i=0; i<bidLineItems.length; i++){
            CurrentBusinessQty += isNaN(bidLineItems[i].Phoenix_Total_Selling_Unit__c)?0: bidLineItems[i].Phoenix_Total_Selling_Unit__c;
            CurrentBusinessSales += isNaN(bidLineItems[i].Finance_Current_Sales__c)?0: bidLineItems[i].Finance_Current_Sales__c;
            CurrentBusinessTPT += isNaN(bidLineItems[i].Phoenix_Current_TP_Margin__c)?0: bidLineItems[i].Phoenix_Current_TP_Margin__c;
            BidRFPQty += isNaN(bidLineItems[i].Phoenix_Final_Total_Selling_Unit__c)?0: bidLineItems[i].Phoenix_Final_Total_Selling_Unit__c;
            BidRFPSales += isNaN(bidLineItems[i].Phoenix_Proposed_Sales__c)?0: parseInt(bidLineItems[i].Phoenix_Proposed_Sales__c);
            BidRFPTPT += isNaN(bidLineItems[i].Phoenix_Proposed_TP_Margin__c)?0: bidLineItems[i].Phoenix_Proposed_TP_Margin__c;
            
            priceVariance += bidLineItems[i].priceVariance;
            volumeVariance += bidLineItems[i].volumeVariance;
            totalVariance += bidLineItems[i].totalVariance;
            
            var finalRFPSales = isNaN(bidLineItems[i].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c * bidLineItems[i].Phoenix_Proposed_ASP_Dose__c)? 0: parseInt(bidLineItems[i].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c * bidLineItems[i].Phoenix_Proposed_ASP_Dose__c);
            var finalRFPTPTDollar = finalRFPSales - (isNaN(bidLineItems[i].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c * bidLineItems[i].Phoenix_Throughput_cost__c)? 0: parseInt(bidLineItems[i].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c * bidLineItems[i].Phoenix_Throughput_cost__c));
            var finalRFPTPTPercent = 0;
            if(finalRFPTPTDollar != 0){
                finalRFPTPTPercent = (finalRFPTPTDollar/finalRFPSales)*100;
            } else{
             	finalRFPTPTPercent = 0;   
            }
            FinalRFPQty += isNaN(bidLineItems[i].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c)?0: bidLineItems[i].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c;
            FinalRFPSales += isNaN(finalRFPSales)?0:finalRFPSales;
            FinalRFPTPT += isNaN(finalRFPTPTDollar)?0:finalRFPTPTDollar;
            
            if(productFamilyMap.hasOwnProperty(bidLineItems[i].Product_Family_Name__c)){
                var familyRelatedList = productFamilyMap[bidLineItems[i].Product_Family_Name__c];
                familyRelatedList.push(bidLineItems[i]);
                productFamilyMap[bidLineItems[i].Product_Family_Name__c] = familyRelatedList;                            
            } else{
                var familyRelatedList = [];
                familyRelatedList.push(bidLineItems[i]);
                productFamilyMap[bidLineItems[i].Product_Family_Name__c] = familyRelatedList;
            }   
            productFamilyIdMap[bidLineItems[i].Product_Family_Name__c] = bidLineItems[i].Product_Family__c;
        }
        var keys = Object.keys(productFamilyMap);
        var familyGroupedData = [];
        for(var i=0; i<keys.length; i++){
            var obj = {};            
            obj.family = keys[i];
            obj.bidLineItems = productFamilyMap[keys[i]];
            familyGroupedData.push(obj);
        }
        summaryAtPositionObj.CurrentBusinessQty = CurrentBusinessQty;summaryAtPositionObj.CurrentBusinessSales = CurrentBusinessSales;summaryAtPositionObj.CurrentBusinessTPT = CurrentBusinessTPT;
        summaryAtPositionObj.BidRFPQty = BidRFPQty; summaryAtPositionObj.BidRFPSales = BidRFPSales; summaryAtPositionObj.BidRFPTPT = BidRFPTPT;
        summaryAtPositionObj.FinalRFPQty = FinalRFPQty; summaryAtPositionObj.FinalRFPSales = FinalRFPSales; summaryAtPositionObj.FinalRFPTPT = FinalRFPTPT;
        summaryAtPositionObj.priceVariance = priceVariance; summaryAtPositionObj.volumeVariance = volumeVariance; summaryAtPositionObj.totalVariance = totalVariance;
        if(CurrentBusinessSales != 0){
         	summaryAtPositionObj.CurrentBusinessTPTPercent = (CurrentBusinessTPT/CurrentBusinessSales)*100;
        } else{
            summaryAtPositionObj.CurrentBusinessTPTPercent = 0;
        }
        if(BidRFPSales != 0){
         	summaryAtPositionObj.BidRFPTPTPercent = (BidRFPTPT/BidRFPSales)*100;   
        } else{
            summaryAtPositionObj.BidRFPTPTPercent = 0;
        }
        if(FinalRFPSales != 0){
         	summaryAtPositionObj.FinalRFPTPTPercent = (FinalRFPTPT/FinalRFPSales)*100;
        } else{
            summaryAtPositionObj.FinalRFPTPTPercent = 0;
        }
        component.set("v.productFamilyIdMap", productFamilyIdMap);
        component.set("v.summaryAtPositionObj", summaryAtPositionObj);
        component.set("v.familyGroupedData", familyGroupedData);
        component.set("v.expandPosition", component.get("v.expandAll"));
    },
    expandPosition: function(component, event, helper) {
        component.set("v.expandPosition", !component.get("v.expandPosition"));
	}
})