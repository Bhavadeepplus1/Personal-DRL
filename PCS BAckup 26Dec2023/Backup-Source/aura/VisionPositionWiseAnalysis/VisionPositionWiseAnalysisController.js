({
    doInit: function(component, event, helper){
        /*component.set("v.isSpinnerLoad", true);
        var action = component.get("c.getData");
        action.setCallback(this, function(response){
            if(response.getState() == 'SUCCESS'){
                var response = response.getReturnValue();
                component.set("v.categoriesList", response);
                var primaryList = response.primaryCategory;
                if(primaryList != null && primaryList.length !=0){
                    var summaryAtPrimaryObj = {};
                    var CurrentBusinessQty = 0; var CurrentBusinessSales = 0; var CurrentBusinessTPT = 0;
                    var BidRFPQty = 0; var BidRFPSales = 0; var BidRFPTPT = 0;
                    var FinalRFPQty = 0; var FinalRFPSales = 0; var FinalRFPTPT = 0;
                    for(var i=0; i<primaryList.length; i++){
                        var bidLineItems = primaryList[i].bidLineItems;
                        for(var j=0; j<bidLineItems.length; j++){
                            CurrentBusinessQty += isNaN(bidLineItems[j].Phoenix_Total_Selling_Unit__c)?0: bidLineItems[j].Phoenix_Total_Selling_Unit__c;
                            CurrentBusinessSales += isNaN(bidLineItems[j].Finance_Current_Sales__c)?0: bidLineItems[j].Finance_Current_Sales__c;
                            CurrentBusinessTPT += isNaN(bidLineItems[j].Phoenix_Current_TP_Margin__c)?0: bidLineItems[j].Phoenix_Current_TP_Margin__c;
                            BidRFPQty += isNaN(bidLineItems[j].Phoenix_Final_Total_Selling_Unit__c)?0: bidLineItems[j].Phoenix_Final_Total_Selling_Unit__c;
                            BidRFPSales += isNaN(bidLineItems[j].Phoenix_Proposed_Sales__c)?0: parseInt(bidLineItems[j].Phoenix_Proposed_Sales__c);
                            BidRFPTPT += isNaN(bidLineItems[j].Phoenix_Proposed_TP_Margin__c)?0: bidLineItems[j].Phoenix_Proposed_TP_Margin__c;
                            
                            var finalRFPSales = isNaN(bidLineItems[j].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c * bidLineItems[j].Phoenix_Proposed_ASP_Dose__c)? 0: parseInt(bidLineItems[j].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c * bidLineItems[j].Phoenix_Proposed_ASP_Dose__c);
                            var finalRFPTPTDollar = finalRFPSales - isNaN(bidLineItems[j].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c * bidLineItems[j].Phoenix_Proposed_ASP_Dose__c)? 0: parseInt(bidLineItems[j].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c * bidLineItems[j].Phoenix_Product__r.Phoenix_Throughput_cost__c);
                            var finalRFPTPTPercent = 0;
                            if(finalRFPTPTDollar != 0){
                                finalRFPTPTPercent = (finalRFPTPTDollar/finalRFPSales)*100;
                            } else{
                                finalRFPTPTPercent = 0;   
                            }
                            FinalRFPQty += isNaN(bidLineItems[j].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c)?0: bidLineItems[j].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c;
                            FinalRFPSales += isNaN(finalRFPSales)?0:finalRFPSales;
                            FinalRFPTPT += isNaN(finalRFPTPTDollar)?0:finalRFPTPTDollar;
                        }
                    }
                    summaryAtPrimaryObj.CurrentBusinessQty = CurrentBusinessQty;summaryAtPrimaryObj.CurrentBusinessSales = CurrentBusinessSales;summaryAtPrimaryObj.CurrentBusinessTPT = CurrentBusinessTPT;
                    summaryAtPrimaryObj.BidRFPQty = BidRFPQty; summaryAtPrimaryObj.BidRFPSales = BidRFPSales; summaryAtPrimaryObj.BidRFPTPT = BidRFPTPT;
                    summaryAtPrimaryObj.FinalRFPQty = FinalRFPQty; summaryAtPrimaryObj.FinalRFPSales = FinalRFPSales; summaryAtPrimaryObj.FinalRFPTPT = FinalRFPTPT;
                    summaryAtPrimaryObj.CurrentBusinessTPTPercent = (CurrentBusinessTPT/CurrentBusinessSales)*100;
                    summaryAtPrimaryObj.BidRFPTPTPercent = (BidRFPTPT/BidRFPSales)*100;
                    summaryAtPrimaryObj.FinalRFPTPTPercent = (FinalRFPTPT/FinalRFPSales)*100;
                    component.set("v.summaryAtPrimaryObj", summaryAtPrimaryObj);
                }
                var backupList = response.backupCategory;
                if(backupList != null && backupList.length !=0){
                    var summaryAtBackupObj = {};
                    var CurrentBusinessQty = 0; var CurrentBusinessSales = 0; var CurrentBusinessTPT = 0;
                    var BidRFPQty = 0; var BidRFPSales = 0; var BidRFPTPT = 0;
                    var FinalRFPQty = 0; var FinalRFPSales = 0; var FinalRFPTPT = 0;
                    for(var i=0; i<backupList.length; i++){
                        var bidLineItems = backupList[i].bidLineItems;
                        for(var j=0; j<bidLineItems.length; j++){
                            CurrentBusinessQty += isNaN(bidLineItems[j].Phoenix_Total_Selling_Unit__c)?0: bidLineItems[j].Phoenix_Total_Selling_Unit__c;
                            CurrentBusinessSales += isNaN(bidLineItems[j].Finance_Current_Sales__c)?0: bidLineItems[j].Finance_Current_Sales__c;
                            CurrentBusinessTPT += isNaN(bidLineItems[j].Phoenix_Current_TP_Margin__c)?0: bidLineItems[j].Phoenix_Current_TP_Margin__c;
                            BidRFPQty += isNaN(bidLineItems[j].Phoenix_Final_Total_Selling_Unit__c)?0: bidLineItems[j].Phoenix_Final_Total_Selling_Unit__c;
                            BidRFPSales += isNaN(bidLineItems[j].Phoenix_Proposed_Sales__c)?0: parseInt(bidLineItems[j].Phoenix_Proposed_Sales__c);
                            BidRFPTPT += isNaN(bidLineItems[j].Phoenix_Proposed_TP_Margin__c)?0: bidLineItems[j].Phoenix_Proposed_TP_Margin__c;
                            
                            var finalRFPSales = isNaN(bidLineItems[j].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c * bidLineItems[j].Phoenix_Proposed_ASP_Dose__c)? 0: parseInt(bidLineItems[j].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c * bidLineItems[j].Phoenix_Proposed_ASP_Dose__c);
                            var finalRFPTPTDollar = finalRFPSales - isNaN(bidLineItems[j].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c * bidLineItems[j].Phoenix_Proposed_ASP_Dose__c)? 0: parseInt(bidLineItems[j].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c * bidLineItems[j].Phoenix_Product__r.Phoenix_Throughput_cost__c);
                            var finalRFPTPTPercent = 0;
                            if(finalRFPTPTDollar != 0){
                                finalRFPTPTPercent = (finalRFPTPTDollar/finalRFPSales)*100;
                            } else{
                                finalRFPTPTPercent = 0;   
                            }
                            FinalRFPQty += isNaN(bidLineItems[j].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c)?0: bidLineItems[j].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c;
                            FinalRFPSales += isNaN(finalRFPSales)?0:finalRFPSales;
                            FinalRFPTPT += isNaN(finalRFPTPTDollar)?0:finalRFPTPTDollar;
                        }
                    }
                    summaryAtBackupObj.CurrentBusinessQty = CurrentBusinessQty;summaryAtBackupObj.CurrentBusinessSales = CurrentBusinessSales;summaryAtBackupObj.CurrentBusinessTPT = CurrentBusinessTPT;
                    summaryAtBackupObj.BidRFPQty = BidRFPQty; summaryAtBackupObj.BidRFPSales = BidRFPSales; summaryAtBackupObj.BidRFPTPT = BidRFPTPT;
                    summaryAtBackupObj.FinalRFPQty = FinalRFPQty; summaryAtBackupObj.FinalRFPSales = FinalRFPSales; summaryAtBackupObj.FinalRFPTPT = FinalRFPTPT;
                    summaryAtBackupObj.CurrentBusinessTPTPercent = (CurrentBusinessTPT/CurrentBusinessSales)*100;
                    summaryAtBackupObj.BidRFPTPTPercent = (BidRFPTPT/BidRFPSales)*100;
                    summaryAtBackupObj.FinalRFPTPTPercent = (FinalRFPTPT/FinalRFPSales)*100;
                    component.set("v.summaryAtBackupObj", summaryAtBackupObj);
                }
                var optyList = response.optyCategory;
                if(optyList != null && optyList.length !=0){
                    var summaryAtOptyObj = {};
                    var CurrentBusinessQty = 0; var CurrentBusinessSales = 0; var CurrentBusinessTPT = 0;
                    var BidRFPQty = 0; var BidRFPSales = 0; var BidRFPTPT = 0;
                    var FinalRFPQty = 0; var FinalRFPSales = 0; var FinalRFPTPT = 0;
                    for(var i=0; i<optyList.length; i++){
                        var bidLineItems = optyList[i].bidLineItems;
                        for(var j=0; j<bidLineItems.length; j++){
                            CurrentBusinessQty += isNaN(bidLineItems[j].Phoenix_Total_Selling_Unit__c)?0: bidLineItems[j].Phoenix_Total_Selling_Unit__c;
                            CurrentBusinessSales += isNaN(bidLineItems[j].Finance_Current_Sales__c)?0: bidLineItems[j].Finance_Current_Sales__c;
                            CurrentBusinessTPT += isNaN(bidLineItems[j].Phoenix_Current_TP_Margin__c)?0: bidLineItems[j].Phoenix_Current_TP_Margin__c;
                            BidRFPQty += isNaN(bidLineItems[j].Phoenix_Final_Total_Selling_Unit__c)?0: bidLineItems[j].Phoenix_Final_Total_Selling_Unit__c;
                            BidRFPSales += isNaN(bidLineItems[j].Phoenix_Proposed_Sales__c)?0: parseInt(bidLineItems[j].Phoenix_Proposed_Sales__c);
                            BidRFPTPT += isNaN(bidLineItems[j].Phoenix_Proposed_TP_Margin__c)?0: bidLineItems[j].Phoenix_Proposed_TP_Margin__c;
                            
                            var finalRFPSales = isNaN(bidLineItems[j].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c * bidLineItems[j].Phoenix_Proposed_ASP_Dose__c)? 0: parseInt(bidLineItems[j].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c * bidLineItems[j].Phoenix_Proposed_ASP_Dose__c);
                            var finalRFPTPTDollar = finalRFPSales - isNaN(bidLineItems[j].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c * bidLineItems[j].Phoenix_Proposed_ASP_Dose__c)? 0: parseInt(bidLineItems[j].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c * bidLineItems[j].Phoenix_Product__r.Phoenix_Throughput_cost__c);
                            var finalRFPTPTPercent = 0;
                            if(finalRFPTPTDollar != 0){
                                finalRFPTPTPercent = (finalRFPTPTDollar/finalRFPSales)*100;
                            } else{
                                finalRFPTPTPercent = 0;   
                            }
                            FinalRFPQty += isNaN(bidLineItems[j].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c)?0: bidLineItems[j].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c;
                            FinalRFPSales += isNaN(finalRFPSales)?0:finalRFPSales;
                            FinalRFPTPT += isNaN(finalRFPTPTDollar)?0:finalRFPTPTDollar;
                        }
                    }
                    summaryAtOptyObj.CurrentBusinessQty = CurrentBusinessQty;summaryAtOptyObj.CurrentBusinessSales = CurrentBusinessSales;summaryAtOptyObj.CurrentBusinessTPT = CurrentBusinessTPT;
                    summaryAtOptyObj.BidRFPQty = BidRFPQty; summaryAtOptyObj.BidRFPSales = BidRFPSales; summaryAtOptyObj.BidRFPTPT = BidRFPTPT;
                    summaryAtOptyObj.FinalRFPQty = FinalRFPQty; summaryAtOptyObj.FinalRFPSales = FinalRFPSales; summaryAtOptyObj.FinalRFPTPT = FinalRFPTPT;
                    summaryAtOptyObj.CurrentBusinessTPTPercent = (CurrentBusinessTPT/CurrentBusinessSales)*100;
                    summaryAtOptyObj.BidRFPTPTPercent = (BidRFPTPT/BidRFPSales)*100;
                    summaryAtOptyObj.FinalRFPTPTPercent = (FinalRFPTPT/FinalRFPSales)*100;
                    component.set("v.summaryAtOptyObj", summaryAtOptyObj);
                }
                component.set("v.primaryList", response.primaryCategory);
                component.set("v.backupList", response.backupCategory);
                component.set("v.optyList", response.optyCategory);
                component.set("v.isSpinnerLoad", false);
            } else{
                console.log("Error "+JSON.stringify(response.getError()));
                component.set("v.isSpinnerLoad", false);
            }
        });
        $A.enqueueAction(action);*/
    },
	/*expandCategory : function(component, event, helper) {
        var category = event.getSource().get("v.name");
        console.log('Selected Category: '+category);
        var categoriesList = component.get("v.categoriesList");
        for(var i=0; i<categoriesList.length; i++){
            if(categoriesList[i].category == category){
                categoriesList[i].expandCategory = !categoriesList[i].expandCategory;
            }
        }
        component.set("v.categoriesList", categoriesList);
	},*/
    
    expandCollapse: function(component, event, helper){
        console.log('Expand All Before: '+component.get("v.expandAll"));
        component.set("v.expandAll", !component.get("v.expandAll"));
        console.log('Expand All After: '+component.get("v.expandAll"));
        if(component.get("v.expandAll")){
            component.set("v.expandCollapseLabel", 'Collapse All') ;
            component.set("v.expandPrimary", true);
            component.set("v.expandBackup", true);
            component.set("v.expandOpty", true);
        } else{
         	component.set("v.expandCollapseLabel", 'Expand All') ;
            component.set("v.expandPrimary", false);
            component.set("v.expandBackup", false);
            component.set("v.expandOpty", false);
        }
    },
    
    selectedBidsChange: function(component, event, helper) {
        console.log('Selected Bids changed: '+component.get("v.selectedBids"));
        if(component.get("v.selectedBids")){
            helper.getData(component, event, helper);
        }
    },
    openModal: function(component, event, helper){
        component.set("v.isModalOpen", !component.get("v.isModalOpen"));
    },
    closeModal: function(component, event, helper){
        component.set("v.isModalOpen", false)  ;
    },
    expandPrimary : function(component, event, helper) {
        component.set("v.expandPrimary", !component.get("v.expandPrimary"));
    },
    expandBackup : function(component, event, helper) {
        component.set("v.expandBackup", !component.get("v.expandBackup"));
    },
    expandOpty : function(component, event, helper) {
        component.set("v.expandOpty", !component.get("v.expandOpty"));
    },
    selectBids: function(component, event, helper){
        component.set("v.showSelectBidsPopup", !component.get("v.showSelectBidsPopup"));
    }
})