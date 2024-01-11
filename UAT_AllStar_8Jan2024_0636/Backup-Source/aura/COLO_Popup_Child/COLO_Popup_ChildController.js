({
	doInit : function(component, event, helper) {
        component.set("v.expandFamily", false);
        var family = component.get("v.family");
        var familyMap = component.get("v.familyMap");
        var relatedList = familyMap[family];
        var productsMap = {}; var familySummaryObj = {};
        var totalAwardedSales = 0; var totalAwardedTPT = 0;
        var totalProposedSales = 0; var totalProposedTPT = 0;
        var popupName = component.get("v.popupName");
        if(relatedList != null){
            for(var i=0; i<relatedList.length; i++){
                var awardedQty = ((relatedList[i].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c != null) ? relatedList[i].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c : 0);
                var proposedASP = ((relatedList[i].Phoenix_Proposed_ASP_Dose__c != null) ? relatedList[i].Phoenix_Proposed_ASP_Dose__c : 0);
                var proposedQty = ((relatedList[i].Phoenix_Final_Total_Selling_Unit__c != null) ? relatedList[i].Phoenix_Final_Total_Selling_Unit__c : 0);
                var awardedSales = awardedQty*proposedASP;                 
                var currentSales = 0;
                if(relatedList[i].Phoenix_Bid_Template_Refrence__c == 'ClarusOne')
                    currentSales = (relatedList[i].Phoenix_Net_Sales_External__c != null ? relatedList[i].Phoenix_Net_Sales_External__c : 0) ;
                else
                    currentSales = (relatedList[i].Finance_Current_Sales__c != null ? relatedList[i].Finance_Current_Sales__c : (relatedList[i].Phoenix_Current_Sales_Finance__c != null ? relatedList[i].Phoenix_Current_Sales_Finance__c : 0) );
                var proposedSales = (relatedList[i].Phoenix_Proposed_Sales__c != null ? relatedList[i].Phoenix_Proposed_Sales__c : 0);
                /*var awardedTPT = awardedSales - (awardedQty * (NPLDataList[i].Phoenix_Throughput_Cost1__c != null ? (NPLDataList[i].Phoenix_Throughput_Cost1__c) : 0));
                var proposedTPT = (NPLDataList[i].Phoenix_Proposed_TP_Margin__c != null ? (NPLDataList[i].Phoenix_Proposed_TP_Margin__c) : 0);*/
                var awardedTPT = ((relatedList[i].Phoenix_Total_DRL_Share__c != null) ? relatedList[i].Phoenix_Total_DRL_Share__c : 0);
                var proposedTPT = ((relatedList[i].Phoenix_Total_DRL_Share__c != null) ? relatedList[i].Phoenix_Total_DRL_Share__c : 0);
                var currentTPT = (relatedList[i].Phoenix_Current_TP_Margin__c != null ? relatedList[i].Phoenix_Current_TP_Margin__c : 0);
                
                var awardedTPTPercent = awardedTPT/(proposedASP*awardedQty);
                var proposedTPTPercent = proposedTPT/proposedSales;
                //scmWrapperObj.currentTPT/(scmWrapperObj.currentDeadnet * scmWrapperObj.awardedQty)
                relatedList[i].awardedQty = awardedQty;
                relatedList[i].proposedASP = proposedASP;
                relatedList[i].currentSales = currentSales;
                relatedList[i].proposedQty = proposedQty;
                relatedList[i].awardedSales = (awardedSales - currentSales);
                relatedList[i].awardedTPT = (awardedTPT - currentTPT);
                relatedList[i].proposedTPT = (proposedTPT - currentTPT);
                relatedList[i].awardedTPTPercent = awardedTPTPercent;
                relatedList[i].proposedTPTPercent = proposedTPTPercent;
                relatedList[i].proposedSales = (proposedSales-currentSales);
                const tolerance = 1e-10;
                if (Math.abs((awardedSales-currentSales)) < tolerance) {
                    relatedList[i].awardedSales = 0;
                }
                if (Math.abs((proposedSales-currentSales)) < tolerance) {
                    relatedList[i].proposedSales = 0;
                }
                totalAwardedSales += relatedList[i].awardedSales;
                totalAwardedTPT += relatedList[i].awardedTPT;
                totalProposedSales += relatedList[i].proposedSales;
                totalProposedTPT += relatedList[i].proposedTPT;
                if(productsMap.hasOwnProperty(relatedList[i].Phoenix_Product__r.Name)){
                    var tempRelatedList = productsMap[relatedList[i].Phoenix_Product__r.Name];
                    tempRelatedList.push(relatedList[i]);
                    productsMap[relatedList[i].Phoenix_Product__r.Name] = tempRelatedList;
                } else {
                    var tempRelatedList = [];
                    tempRelatedList.push(relatedList[i]);
                    productsMap[relatedList[i].Phoenix_Product__r.Name] = tempRelatedList;
                }      
            }
            familySummaryObj.totalAwardedSales = totalAwardedSales;
            familySummaryObj.totalAwardedTPT = totalAwardedTPT;
            familySummaryObj.totalAwardedTPTPercent = (totalAwardedTPT/totalAwardedSales);
            familySummaryObj.totalProposedSales = totalProposedSales;
            familySummaryObj.totalProposedTPT = totalProposedTPT;
            familySummaryObj.totalProposedTPTPercent = (totalProposedTPT/totalProposedSales);
            component.set("v.familySummaryObj", familySummaryObj);
            component.set("v.relatedList", relatedList); 
            component.set("v.productsList", Object.keys(productsMap));
            component.set("v.productsMap", productsMap);
        }
    },
    expandFamilyList: function(component, event, helper){
        component.set("v.expandFamily", !component.get("v.expandFamily"));
    }
})