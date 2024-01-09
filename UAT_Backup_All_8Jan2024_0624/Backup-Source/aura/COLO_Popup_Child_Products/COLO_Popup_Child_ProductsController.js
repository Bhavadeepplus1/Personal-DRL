({
	doInit : function(component, event, helper) {
        var product = component.get("v.product");
        var productsMap = component.get("v.productsMap");
        var relatedList = productsMap[product];
        var productSummaryObj = {};
        var totalAwardedSales = 0; var totalAwardedTPT = 0; var totalProposedSales = 0; var totalProposedTPT = 0;
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
                console.log('Popup Name: '+component.get("v.popupName"));
                console.log('Product: '+relatedList[i].Phoenix_Product__r.Name);
                console.log('Template: '+relatedList[i].Phoenix_Bid_Template_Refrence__c);
                console.log('Awarded Sales: '+awardedSales);
                console.log('Proposed Sales: '+proposedSales);
                console.log('Current Sales: '+currentSales);
                console.log('Net Sales: '+relatedList[i].Phoenix_Net_Sales_External__c);
                console.log('Finance Current Sales: '+relatedList[i].Finance_Current_Sales__c);
                console.log('Current Sales Finance: '+relatedList[i].Phoenix_Current_Sales_Finance__c);
                console.log('Final Sales: '+(awardedSales - currentSales));
                //scmWrapperObj.currentTPT/(scmWrapperObj.currentDeadnet * scmWrapperObj.awardedQty)
                relatedList[i].awardedQty = awardedQty;
                relatedList[i].proposedASP = proposedASP;
                relatedList[i].currentSales = parseFloat(currentSales);
                relatedList[i].proposedQty = proposedQty;
                relatedList[i].awardedSales = parseFloat(awardedSales) - parseFloat(currentSales);
                relatedList[i].awardedTPT = parseFloat(awardedTPT) - parseFloat(currentTPT);
                relatedList[i].proposedTPT = parseFloat(proposedTPT) - parseFloat(currentTPT);
                relatedList[i].proposedSales = parseFloat(proposedSales) - parseFloat(currentSales);
                console.log('Final Awarded TPT: '+relatedList[i].awardedTPT);
                console.log('Final Awarded Sales: '+relatedList[i].awardedSales);
                console.log('Final Proposed TPT: '+relatedList[i].proposedTPT);
                console.log('Final Proposed Sales: '+relatedList[i].proposedSales);
                const tolerance = 1e-10;
                if (Math.abs((awardedSales-currentSales)) < tolerance) {
                    relatedList[i].awardedSales = 0;
                }
                if (Math.abs((proposedSales-currentSales)) < tolerance) {
                    relatedList[i].proposedSales = 0;
                }
                var awardedTPTPercent = parseFloat(relatedList[i].awardedTPT)/parseFloat(relatedList[i].awardedSales);
                var proposedTPTPercent = parseFloat(relatedList[i].proposedTPT)/parseFloat(relatedList[i].proposedSales);
                relatedList[i].awardedTPTPercent = awardedTPTPercent;
                relatedList[i].proposedTPTPercent = proposedTPTPercent;

                
                totalAwardedSales += (awardedSales - currentSales);
                totalAwardedTPT += (awardedTPT - currentTPT);
                totalProposedSales += (proposedSales-currentSales);
                totalProposedTPT += (proposedTPT - currentTPT);
            }
        }
        productSummaryObj.totalAwardedSales = totalAwardedSales;
        productSummaryObj.totalAwardedTPT = totalAwardedTPT;
        productSummaryObj.totalAwardedTPTPercent = (totalAwardedTPT/totalAwardedSales);
        productSummaryObj.totalProposedSales = totalProposedSales;
        productSummaryObj.totalProposedTPT = totalProposedTPT;
        productSummaryObj.totalProposedTPTPercent = (totalProposedTPT/totalProposedSales);
        component.set("v.productSummaryObj", productSummaryObj);
        component.set("v.relatedList", relatedList); 
    },
    expandProductList: function(component, event, helper){
        component.set("v.expandProduct", !component.get("v.expandProduct"));
    }
})