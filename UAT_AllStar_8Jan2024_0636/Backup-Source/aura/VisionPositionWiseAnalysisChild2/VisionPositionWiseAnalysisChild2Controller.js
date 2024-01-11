({
	doInit : function(component, event, helper) {
        var bidLineItems = component.get("v.familyGroup.bidLineItems");
        var summaryAtFamilyObj = {};
        var CurrentBusinessQty = 0; var CurrentBusinessSales = 0; var CurrentBusinessTPT = 0;
        var BidRFPQty = 0; var BidRFPSales = 0; var BidRFPTPT = 0;
        var FinalRFPQty = 0; var FinalRFPSales = 0; var FinalRFPTPT = 0;
        var priceVariance = 0; var volumeVariance = 0; var totalVariance = 0;
        for(var i=0; i<bidLineItems.length; i++){
            CurrentBusinessQty += isNaN(bidLineItems[i].Phoenix_Total_Selling_Unit__c)?0: bidLineItems[i].Phoenix_Total_Selling_Unit__c;
            CurrentBusinessSales += isNaN(bidLineItems[i].Finance_Current_Sales__c)?0: bidLineItems[i].Finance_Current_Sales__c;
            CurrentBusinessTPT += isNaN(bidLineItems[i].Phoenix_Current_TP_Margin__c)?0: bidLineItems[i].Phoenix_Current_TP_Margin__c;
            BidRFPQty += isNaN(bidLineItems[i].Phoenix_Final_Total_Selling_Unit__c)?0: bidLineItems[i].Phoenix_Final_Total_Selling_Unit__c;
            BidRFPSales += isNaN(bidLineItems[i].Phoenix_Proposed_Sales__c)?0: parseFloat(bidLineItems[i].Phoenix_Proposed_Sales__c);
            BidRFPTPT += isNaN(bidLineItems[i].Phoenix_Proposed_TP_Margin__c)?0: bidLineItems[i].Phoenix_Proposed_TP_Margin__c;           
            priceVariance += bidLineItems[i].priceVariance;
            volumeVariance += bidLineItems[i].volumeVariance;
            totalVariance += bidLineItems[i].totalVariance;
            
            bidLineItems[i].finalRFPSales = isNaN(bidLineItems[i].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c * bidLineItems[i].Phoenix_Proposed_ASP_Dose__c)? 0: parseFloat(bidLineItems[i].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c * bidLineItems[i].Phoenix_Proposed_ASP_Dose__c);
            bidLineItems[i].finalRFPTPTDollar = bidLineItems[i].finalRFPSales - (isNaN(bidLineItems[i].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c * bidLineItems[i].Phoenix_Throughput_cost__c)? 0: parseFloat(bidLineItems[i].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c * bidLineItems[i].Phoenix_Throughput_cost__c));
            if(bidLineItems[i].finalRFPTPTDollar != 0){
                bidLineItems[i].finalRFPTPTPercent = (bidLineItems[i].finalRFPTPTDollar/bidLineItems[i].finalRFPSales)*100;
            } else{
             	bidLineItems[i].finalRFPTPTPercent = 0;   
            }
            FinalRFPQty += isNaN(bidLineItems[i].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c)?0: bidLineItems[i].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c;
            FinalRFPSales += isNaN(bidLineItems[i].finalRFPSales)?0:bidLineItems[i].finalRFPSales;
            var tempfinalRFPSales = parseFloat(isNaN(bidLineItems[i].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c * bidLineItems[i].Phoenix_Proposed_ASP_Dose__c)? 0: parseFloat(bidLineItems[i].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c * bidLineItems[i].Phoenix_Proposed_ASP_Dose__c)).toFixed(0);
            var tempfinalRFPTPTDollar = tempfinalRFPSales - parseFloat(isNaN(bidLineItems[i].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c * bidLineItems[i].Phoenix_Throughput_cost__c)? 0: parseFloat(bidLineItems[i].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c * bidLineItems[i].Phoenix_Throughput_cost__c)).toFixed(0);
            FinalRFPTPT += isNaN(bidLineItems[i].finalRFPTPTDollar)?0:bidLineItems[i].finalRFPTPTDollar;
        }
        console.log('Total TPT RFP: '+FinalRFPTPT);
        console.log('*********Outer End**********');
        summaryAtFamilyObj.CurrentBusinessQty = CurrentBusinessQty;summaryAtFamilyObj.CurrentBusinessSales = CurrentBusinessSales;summaryAtFamilyObj.CurrentBusinessTPT = CurrentBusinessTPT;
        summaryAtFamilyObj.BidRFPQty = BidRFPQty; summaryAtFamilyObj.BidRFPSales = BidRFPSales; summaryAtFamilyObj.BidRFPTPT = BidRFPTPT;
        summaryAtFamilyObj.FinalRFPQty = FinalRFPQty; summaryAtFamilyObj.FinalRFPSales = FinalRFPSales; summaryAtFamilyObj.FinalRFPTPT = FinalRFPTPT;
        summaryAtFamilyObj.priceVariance = priceVariance; summaryAtFamilyObj.volumeVariance = volumeVariance; summaryAtFamilyObj.totalVariance = totalVariance;
        if(CurrentBusinessSales != 0){
         	summaryAtFamilyObj.CurrentBusinessTPTPercent = (CurrentBusinessTPT/CurrentBusinessSales)*100;
        } else{
            summaryAtFamilyObj.CurrentBusinessTPTPercent = 0;
        }
        if(BidRFPSales != 0){
         	summaryAtFamilyObj.BidRFPTPTPercent = (BidRFPTPT/BidRFPSales)*100;   
        } else{
            summaryAtFamilyObj.BidRFPTPTPercent = 0;
        }
        if(FinalRFPSales != 0){
         	summaryAtFamilyObj.FinalRFPTPTPercent = (FinalRFPTPT/FinalRFPSales)*100;
        } else{
            summaryAtFamilyObj.FinalRFPTPTPercent = 0;
        }
        var productFamilyIdMap = component.get("v.productFamilyIdMap");
        component.set("v.familyId", productFamilyIdMap[component.get("v.familyGroup.family")]);
        component.set("v.summaryAtFamilyObj", summaryAtFamilyObj);
        component.set("v.bidLineItems", bidLineItems);
        component.set("v.expandFamily", component.get("v.expandAll"));
	},
    expandFamily: function(component, event, helper){
        component.set("v.expandFamily", !component.get("v.expandFamily"));
    }
})