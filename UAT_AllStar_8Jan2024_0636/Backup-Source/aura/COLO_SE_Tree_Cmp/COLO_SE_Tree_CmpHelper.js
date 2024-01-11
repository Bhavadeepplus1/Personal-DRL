({
	formatCurrencyMethod : function(component, event, helper, number) {
        if(number != null && number != 0){
         	number = (number/1000000).toFixed(1);
            number = parseFloat(number);
        }
		const formattedCurrency = number.toLocaleString('en-US', { style: 'currency', currency: 'USD',  minimumFractionDigits: 0, maximumFractionDigits: 1 });
        return formattedCurrency+'M';
	},
    preparePopupData: function(component, event, helper, dataList){
        var familyMap = {};
        var totalOptyAwardedSales = 0; var totalOptyAwardedGM = 0;
        var totalOptyProposedSales = 0; var totalOptyProposedGM = 0;
        if(dataList != null){
            for(var i=0; i<dataList.length; i++) {
                var awardedQty = ((dataList[i].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c != null) ? dataList[i].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c : 0);
                var proposedASP = ((dataList[i].Phoenix_Proposed_ASP_Dose__c != null) ? dataList[i].Phoenix_Proposed_ASP_Dose__c : 0);
                var proposedQty = ((dataList[i].Phoenix_Final_Total_Selling_Unit__c != null) ? dataList[i].Phoenix_Final_Total_Selling_Unit__c : 0);
                var awardedSales = awardedQty*proposedASP;                 
                var currentSales = 0;
                if(dataList[i].Phoenix_Bid_Template_Refrence__c == 'ClarusOne')
                    currentSales = (dataList[i].Phoenix_Net_Sales_External__c != null ? dataList[i].Phoenix_Net_Sales_External__c : 0) ;
                else
                    currentSales = (dataList[i].Finance_Current_Sales__c != null ? dataList[i].Finance_Current_Sales__c : (dataList[i].Phoenix_Current_Sales_Finance__c != null ? dataList[i].Phoenix_Current_Sales_Finance__c : 0) );
                var proposedSales = (dataList[i].Phoenix_Proposed_Sales__c != null ? dataList[i].Phoenix_Proposed_Sales__c : 0);
                var awardedTPT = ((dataList[i].Phoenix_Total_DRL_Share__c != null) ? dataList[i].Phoenix_Total_DRL_Share__c : 0);
                var proposedTPT = ((dataList[i].Phoenix_Total_DRL_Share__c != null) ? dataList[i].Phoenix_Total_DRL_Share__c : 0);
                var currentTPT = (dataList[i].Phoenix_Current_TP_Margin__c != null ? dataList[i].Phoenix_Current_TP_Margin__c : 0);
                
                var awardedTPTPercent = awardedTPT/(proposedASP*awardedQty);
                var proposedTPTPercent = proposedTPT/proposedSales;
                dataList[i].awardedQty = awardedQty;
                dataList[i].proposedASP = proposedASP;
                dataList[i].currentSales = currentSales;
                dataList[i].proposedQty = proposedQty;
                dataList[i].awardedSales = (awardedSales - currentSales);
                dataList[i].awardedTPT = (awardedTPT - currentTPT);
                dataList[i].proposedTPT = (proposedTPT - currentTPT);
                dataList[i].awardedTPTPercent = awardedTPTPercent;
                dataList[i].proposedTPTPercent = proposedTPTPercent;
                dataList[i].proposedSales = (proposedSales-currentSales);
                totalOptyAwardedSales += dataList[i].awardedSales;
                totalOptyAwardedGM += dataList[i].awardedTPT;
                totalOptyProposedSales += dataList[i].proposedSales;
                totalOptyProposedGM += dataList[i].proposedTPT;
                if(familyMap.hasOwnProperty(dataList[i].Phoenix_Product_Family__c)){
                    var relatedList = familyMap[dataList[i].Phoenix_Product_Family__c];
                    relatedList.push(dataList[i]);
                    familyMap[dataList[i].Phoenix_Product_Family__c] = relatedList;
                } else {
                    var relatedList = [];
                    relatedList.push(dataList[i]);
                    familyMap[dataList[i].Phoenix_Product_Family__c] = relatedList;
                }      
            }
            component.set("v.totalSales", totalOptyAwardedSales);
            component.set("v.totalGM", totalOptyAwardedGM);
            component.set("v.totalProposedSales", totalOptyProposedSales);
            component.set("v.totalProposedGM", totalOptyProposedGM);
            component.set("v.popupFamilyMap", familyMap);
            component.set("v.popupFamilyList", Object.keys(familyMap));
        }   
    },
})