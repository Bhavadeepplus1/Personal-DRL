({
    doInit: function(component, event, helper){
        var expandCollapseObj = component.get("v.expandCollapseObj");
        var objectType = typeof expandCollapseObj;
        if(objectType == 'string')
            component.set("v.expandCollapseObj", JSON.parse(expandCollapseObj));
        var PriceChangeDataList = component.get("v.PriceChangeDataList");
        var optyWonList = []; var optyLostList = []; var wonLessThresholdList = []; var wonGreaterThresholdList = []; 
        var lostLessThresholdList = []; var lostGreaterThresholdList = []; var wonCIPOnList = []; var wonCIPInitiatedList = [];
        var lostCIPOnList = []; var lostCIPInitiatedList = [];
		var totalOptyWonSales = 0; var totalOptyWonTPTSales = 0; var totalOptyLostSales = 0; var totalOptyLostTPTSales = 0;
        var wonLessThresholdSales = 0; var wonLessThresholdTPTSales = 0; var wonGreaterThresholdSales = 0; var wonGreaterThresholdTPTSales = 0;
        var lostLessThresholdSales = 0; var lostLessThresholdTPTSales = 0; var lostGreaterThresholdSales = 0; var lostGreaterThresholdTPTSales = 0;
        var wonCIPOnSales = 0; var wonCIPOnTPTSales = 0; var wonCIPInitiatedSales = 0; var wonCIPInitiatedTPTSales = 0;
        var lostCIPOnSales = 0; var lostCIPOnTPTSales = 0; var lostCIPInitiatedSales = 0; var lostCIPInitiatedTPTSales = 0;
        component.set("v.dataObject.wonLessThresholdSales", 0);
        component.set("v.dataObject.wonLessThresholdTPTSales", 0);
        component.set("v.dataObject.wonGreaterThresholdSales", 0);
        component.set("v.dataObject.wonGreaterThresholdTPTSales", 0);
        component.set("v.dataObject.lostLessThresholdSales", 0);
        component.set("v.dataObject.lostLessThresholdTPTSales", 0);
        component.set("v.dataObject.lostGreaterThresholdSales", 0);
        component.set("v.dataObject.lostGreaterThresholdTPTSales", 0);
        component.set("v.dataObject.wonCIPOnSales", 0);
        component.set("v.dataObject.wonCIPOnTPTSales", 0);
        component.set("v.dataObject.wonCIPInitiatedSales", 0);
        component.set("v.dataObject.wonCIPInitiatedTPTSales", 0);
        component.set("v.dataObject.lostCIPOnSales", 0);
        component.set("v.dataObject.lostCIPOnTPTSales", 0);
        component.set("v.dataObject.lostCIPInitiatedSales", 0);
        component.set("v.dataObject.lostCIPInitiatedTPTSales", 0);
        if(PriceChangeDataList != null){
            for(var i=0; i<PriceChangeDataList.length; i++){
                var awardedQty = ((PriceChangeDataList[i].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c != null) ? PriceChangeDataList[i].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c : 0);
                var proposedASP = ((PriceChangeDataList[i].Phoenix_Proposed_ASP_Dose__c != null) ? PriceChangeDataList[i].Phoenix_Proposed_ASP_Dose__c : 0);
                var proposedQty = ((PriceChangeDataList[i].Phoenix_Final_Total_Selling_Unit__c != null) ? PriceChangeDataList[i].Phoenix_Final_Total_Selling_Unit__c : 0);
                var awardedSales = awardedQty*proposedASP;                 
                var currentSales = 0;
                if(PriceChangeDataList[i].Phoenix_Bid_Template_Refrence__c == 'ClarusOne')
                    currentSales = (PriceChangeDataList[i].Phoenix_Net_Sales_External__c != null ? PriceChangeDataList[i].Phoenix_Net_Sales_External__c : 0) ;
                else
                    currentSales = (PriceChangeDataList[i].Finance_Current_Sales__c != null ? PriceChangeDataList[i].Finance_Current_Sales__c : (PriceChangeDataList[i].Phoenix_Current_Sales_Finance__c != null ? PriceChangeDataList[i].Phoenix_Current_Sales_Finance__c : 0) );
                var proposedSales = (PriceChangeDataList[i].Phoenix_Proposed_Sales__c != null ? PriceChangeDataList[i].Phoenix_Proposed_Sales__c : 0);
                var awardedTPT = ((PriceChangeDataList[i].Phoenix_Total_DRL_Share__c != null) ? PriceChangeDataList[i].Phoenix_Total_DRL_Share__c : 0);
                var proposedTPT = ((PriceChangeDataList[i].Phoenix_Total_DRL_Share__c != null) ? PriceChangeDataList[i].Phoenix_Total_DRL_Share__c : 0);
                var currentTPT = (PriceChangeDataList[i].Phoenix_Current_TP_Margin__c != null ? PriceChangeDataList[i].Phoenix_Current_TP_Margin__c : 0);
                
                var awardedTPTPercent = awardedTPT/(proposedASP*awardedQty);
                var proposedTPTPercent = proposedTPT/proposedSales;
                //scmWrapperObj.currentTPT/(scmWrapperObj.currentDeadnet * scmWrapperObj.awardedQty)
                PriceChangeDataList[i].awardedQty = awardedQty;
                PriceChangeDataList[i].proposedASP = proposedASP;
                PriceChangeDataList[i].currentSales = currentSales;
                PriceChangeDataList[i].proposedQty = proposedQty;
                PriceChangeDataList[i].awardedSales = (awardedSales - currentSales);
                PriceChangeDataList[i].awardedTPT = (awardedTPT - currentTPT);
                PriceChangeDataList[i].proposedTPT = (proposedTPT - currentTPT);
                PriceChangeDataList[i].awardedTPTPercent = awardedTPTPercent;
                PriceChangeDataList[i].proposedTPTPercent = proposedTPTPercent;
                PriceChangeDataList[i].proposedSales = (proposedSales-currentSales);
                
                if(PriceChangeDataList[i].Customer_Response_Lines__r != null && PriceChangeDataList[i].Customer_Response_Lines__r.length > 0 && PriceChangeDataList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Awarded'){
                    optyWonList.push(PriceChangeDataList[i]);
                    totalOptyWonSales += (awardedSales-currentSales);
                    totalOptyWonTPTSales += (awardedTPT - currentTPT);
                    if(PriceChangeDataList[i].Phoenix_Product__r.Phoenix_Is_partner_product__c){
                        if(PriceChangeDataList[i].Phoenix_DRL_Margin_DRL__c < 25) {
                            wonLessThresholdList.push(PriceChangeDataList[i]);
                            wonLessThresholdSales += (awardedSales-currentSales);
                            wonLessThresholdTPTSales += (awardedTPT - currentTPT);
                            if(PriceChangeDataList[i].CIP_Status_Internal_Use__c == 'OnGoing'){
                            	wonCIPOnList.push(PriceChangeDataList[i]);    
                                wonCIPOnSales += (awardedSales-currentSales);
                                wonCIPOnTPTSales += (awardedTPT - currentTPT);
                            } else{
                            	wonCIPInitiatedList.push(PriceChangeDataList[i]);    
                                wonCIPInitiatedSales += (awardedSales-currentSales);
                                wonCIPInitiatedTPTSales += (awardedTPT - currentTPT);
                            }
                        } else {
                            wonGreaterThresholdList.push(PriceChangeDataList[i]);
                            wonGreaterThresholdSales += (awardedSales-currentSales);
                            wonGreaterThresholdTPTSales += (awardedTPT - currentTPT);
                        }
                    } else {
                        if(PriceChangeDataList[i].Phoenix_DRL_Margin_DRL__c < 40) {
                            wonLessThresholdList.push(PriceChangeDataList[i]);
                            wonLessThresholdSales += (awardedSales-currentSales);
                            wonLessThresholdTPTSales += (awardedTPT - currentTPT);
                            if(PriceChangeDataList[i].CIP_Status_Internal_Use__c == 'OnGoing'){
                            	wonCIPOnList.push(PriceChangeDataList[i]);    
                                wonCIPOnSales += (awardedSales-currentSales);
                                wonCIPOnTPTSales += (awardedTPT - currentTPT);
                            } else{
                            	wonCIPInitiatedList.push(PriceChangeDataList[i]);    
                                wonCIPInitiatedSales += (awardedSales-currentSales);
                                wonCIPInitiatedTPTSales += (awardedTPT - currentTPT);
                            }
                        } else {
                            wonGreaterThresholdList.push(PriceChangeDataList[i]);
                            wonGreaterThresholdSales += (awardedSales-currentSales);
                            wonGreaterThresholdTPTSales += (awardedTPT - currentTPT);
                        }
                    }
                    
                } else if(PriceChangeDataList[i].Customer_Response_Lines__r != null && PriceChangeDataList[i].Customer_Response_Lines__r.length > 0 && PriceChangeDataList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Declined by Customer'){
                    optyLostList.push(PriceChangeDataList[i]);
                    totalOptyLostSales += (proposedSales-currentSales);
                    totalOptyLostTPTSales += (proposedTPT - currentTPT);
                    if(PriceChangeDataList[i].Phoenix_Product__r.Phoenix_Is_partner_product__c){
                        if(PriceChangeDataList[i].Phoenix_DRL_Margin_DRL__c < 25) {
                            lostLessThresholdList.push(PriceChangeDataList[i]);
                            lostLessThresholdSales += (proposedSales-currentSales);
                            lostLessThresholdTPTSales += (proposedTPT - currentTPT);
                            if(PriceChangeDataList[i].CIP_Status_Internal_Use__c == 'OnGoing'){
                                lostCIPOnList.push(PriceChangeDataList[i]);    
                                lostCIPOnSales += (proposedSales-currentSales);
                                lostCIPOnTPTSales += (proposedTPT - currentTPT);
                            } else{
                                lostCIPInitiatedList.push(PriceChangeDataList[i]);    
                                lostCIPInitiatedSales += (proposedSales-currentSales);
                                lostCIPInitiatedTPTSales += (proposedTPT - currentTPT);
                            }
                        } else {
                            lostGreaterThresholdList.push(PriceChangeDataList[i]);
                            lostGreaterThresholdSales += (proposedSales-currentSales);
                            lostGreaterThresholdTPTSales += (proposedTPT - currentTPT);
                        }
                    } else {
                        if(PriceChangeDataList[i].Phoenix_DRL_Margin_DRL__c < 40) {
                            lostLessThresholdList.push(PriceChangeDataList[i]);
                            lostLessThresholdSales += (proposedSales-currentSales);
                            lostLessThresholdTPTSales += (proposedTPT - currentTPT);
                            if(PriceChangeDataList[i].CIP_Status_Internal_Use__c == 'OnGoing'){
                                lostCIPOnList.push(PriceChangeDataList[i]);    
                                lostCIPOnSales += (proposedSales-currentSales);
                                lostCIPOnTPTSales += (proposedTPT - currentTPT);
                            } else{
                                lostCIPInitiatedList.push(PriceChangeDataList[i]);    
                                lostCIPInitiatedSales += (proposedSales-currentSales);
                                lostCIPInitiatedTPTSales += (proposedTPT - currentTPT);
                            }
                        } else {
                            lostGreaterThresholdList.push(PriceChangeDataList[i]);
                            lostGreaterThresholdSales += (proposedSales-currentSales);
                            lostGreaterThresholdTPTSales += (proposedTPT - currentTPT);
                        }
                    }
                }
            }
        }
        var formattedTotalOptyWonSales = helper.formatCurrencyMethod(component, event, helper, totalOptyWonSales);
        var formattedTotalOptyLostSales = helper.formatCurrencyMethod(component, event, helper, totalOptyLostSales);
        
        var formattedTotalOptyWonTPTSales = helper.formatCurrencyMethod(component, event, helper, totalOptyWonTPTSales);
        var formattedTotalOptyLostTPTSales = helper.formatCurrencyMethod(component, event, helper, totalOptyLostTPTSales);
        var formattedWonLessThresholdSales = helper.formatCurrencyMethod(component, event, helper, wonLessThresholdSales);
        var formattedWonLessThresholdTPTSales = helper.formatCurrencyMethod(component, event, helper, wonLessThresholdTPTSales);
        var formattedWonGreaterThresholdSales = helper.formatCurrencyMethod(component, event, helper, wonGreaterThresholdSales);
        var formattedWonGreaterThresholdTPTSales = helper.formatCurrencyMethod(component, event, helper, wonGreaterThresholdTPTSales);
        var formattedLostLessThresholdSales = helper.formatCurrencyMethod(component, event, helper, lostLessThresholdSales);
        var formattedLostLessThresholdTPTSales = helper.formatCurrencyMethod(component, event, helper, lostLessThresholdTPTSales);
        var formattedLostGreaterThresholdSales = helper.formatCurrencyMethod(component, event, helper, lostGreaterThresholdSales);
        var formattedLostGreaterThresholdTPTSales = helper.formatCurrencyMethod(component, event, helper, lostGreaterThresholdTPTSales);
        
        var formattedWonCIPOnSales = helper.formatCurrencyMethod(component, event, helper, wonCIPOnSales);
        var formattedWonCIPOnTPTSales = helper.formatCurrencyMethod(component, event, helper, wonCIPOnTPTSales);
        var formattedWonCIPInitiatedSales = helper.formatCurrencyMethod(component, event, helper, wonCIPInitiatedSales);
        var formattedWonCIPInitiatedTPTSales = helper.formatCurrencyMethod(component, event, helper, wonCIPInitiatedTPTSales);
        var formattedLostCIPOnSales = helper.formatCurrencyMethod(component, event, helper, lostCIPOnSales);
        var formattedLostCIPOnTPTSales = helper.formatCurrencyMethod(component, event, helper, lostCIPOnTPTSales);
        var formattedLostCIPInitiatedSales = helper.formatCurrencyMethod(component, event, helper, lostCIPInitiatedSales);
        var formattedLostCIPInitiatedTPTSales = helper.formatCurrencyMethod(component, event, helper, lostCIPInitiatedTPTSales);
        
        component.set("v.wonLessThresholdList", wonLessThresholdList);
        component.set("v.wonGreaterThresholdList", wonGreaterThresholdList);
        component.set("v.wonCIPOnList", wonCIPOnList);
        component.set("v.wonCIPInitiatedList", wonCIPInitiatedList);
        component.set("v.lostLessThresholdList", lostLessThresholdList);
        component.set("v.lostGreaterThresholdList", lostGreaterThresholdList);
        component.set("v.lostCIPOnList", lostCIPOnList);
        component.set("v.lostCIPInitiatedList", lostCIPInitiatedList);
        
        component.set("v.dataObject.totalOptyWonSales", formattedTotalOptyWonSales);
        component.set("v.dataObject.totalOptyWonTPTSales", formattedTotalOptyWonTPTSales);
        component.set("v.dataObject.totalOptyLostSales", formattedTotalOptyLostSales);
        component.set("v.dataObject.totalOptyLostTPTSales", formattedTotalOptyLostTPTSales);
        
        component.set("v.dataObject.wonLessThresholdSales", formattedWonLessThresholdSales);
        component.set("v.dataObject.wonLessThresholdTPTSales", formattedWonLessThresholdTPTSales);
        component.set("v.dataObject.wonGreaterThresholdSales", formattedWonGreaterThresholdSales);
        component.set("v.dataObject.wonGreaterThresholdTPTSales", formattedWonGreaterThresholdTPTSales);
        component.set("v.dataObject.wonLessThresholdCount", wonLessThresholdList.length);
        component.set("v.dataObject.wonGreaterThresholdCount", wonGreaterThresholdList.length);
        
        component.set("v.dataObject.lostLessThresholdSales", formattedLostLessThresholdSales);
        component.set("v.dataObject.lostLessThresholdTPTSales", formattedLostLessThresholdTPTSales);
        component.set("v.dataObject.lostGreaterThresholdSales", formattedLostGreaterThresholdSales);
        component.set("v.dataObject.lostGreaterThresholdTPTSales", formattedLostGreaterThresholdTPTSales);
        component.set("v.dataObject.lostLessThresholdCount", lostLessThresholdList.length);
        component.set("v.dataObject.lostGreaterThresholdCount", lostGreaterThresholdList.length);
        
        component.set("v.dataObject.totalWonCIPOnSales", formattedWonCIPOnSales);
        component.set("v.dataObject.totalWonCIPOnTPTSales", formattedWonCIPOnTPTSales);
        component.set("v.dataObject.totalWonCIPInitiatedSales", formattedWonCIPInitiatedSales);
        component.set("v.dataObject.totalWonCIPInitiatedTPTSales", formattedWonCIPInitiatedTPTSales);
        component.set("v.dataObject.totalLostCIPOnSales", formattedLostCIPOnSales);
        component.set("v.dataObject.totalLostCIPOnTPTSales", formattedLostCIPOnTPTSales);
        component.set("v.dataObject.totalLostCIPInitiatedSales", formattedLostCIPInitiatedSales);
        component.set("v.dataObject.totalLostCIPInitiatedTPTSales", formattedLostCIPInitiatedTPTSales);
        
        component.set("v.dataObject.totalOptyWonCount", optyWonList.length);
        component.set("v.dataObject.totalOptyLostCount", optyLostList.length);
        
        component.set("v.optyWonList", optyWonList);
        component.set("v.optyLostList", optyLostList);
        
        
    },
    openTimeSeries : function(component, event, helper){
        component.set("v.selectedTimeSeriesItem",'Price Change Time Series');
        component.set("v.showTimeSeries",true);
    },
    optyWonTimeSeries : function(component, event, helper){
        component.set("v.selectedTimeSeriesItem",'Price Change Opportunity Won Time Series');
        component.set("v.showTimeSeries",true);
    },
    optyLostTimeSeries : function(component, event, helper){
        component.set("v.selectedTimeSeriesItem",'Price Change Opportunity Lost Time Series');
        component.set("v.showTimeSeries",true);
    },
    closeTimeSeriesPopup : function(component, event, helper){
        component.set("v.showTimeSeries",false);
    },
    scrollToDiv: function(component, event, helper) {
        var scrollToDiv = component.find("scrollToDiv").getElement();
        if (scrollToDiv) {
            scrollToDiv.scrollIntoView({ behavior: "smooth" });
        }
    },
    getSelectedSection: function(component, event, helper){
        var clickedTd = event.getSource().get("v.name");
        var expandCollapseObj = component.get("v.expandCollapseObj");
        if(clickedTd == 'Price Change'){
            var currentBoolean = expandCollapseObj.expandPriceChanges;
            expandCollapseObj.expandPriceChanges = !currentBoolean;
            expandCollapseObj.expandOptyWon = !currentBoolean;
            expandCollapseObj.expandOptyLost = !currentBoolean;
            expandCollapseObj.expandLessThreshold1 = !currentBoolean;
            expandCollapseObj.expandLessThreshold2 = !currentBoolean;
            component.set("v.expandCollapseObj", expandCollapseObj);
        }
        if(clickedTd == 'expandOptyWon'){
            expandCollapseObj.expandOptyWon = !expandCollapseObj.expandOptyWon;
            component.set("v.expandCollapseObj", expandCollapseObj);
        }
        if(clickedTd == 'expandOptyLost'){
            expandCollapseObj.expandOptyLost = !expandCollapseObj.expandOptyLost;
            component.set("v.expandCollapseObj", expandCollapseObj);
        }
        if(clickedTd == 'expandLessThreshold1'){
            expandCollapseObj.expandLessThreshold1 = !expandCollapseObj.expandLessThreshold1;
            component.set("v.expandCollapseObj", expandCollapseObj);
        }
        if(clickedTd == 'expandLessThreshold2'){
            expandCollapseObj.expandLessThreshold2 = !expandCollapseObj.expandLessThreshold2;
            component.set("v.expandCollapseObj", expandCollapseObj);
        }
    },
    openOptyWon: function(component, event, helper){
        component.set("v.showWonPopup", !component.get("v.showWonPopup"));
        var optyWonList = component.get("v.optyWonList");
        var familyMap = {};
        var totalOptyAwardedSales = 0; var totalOptyAwardedGM = 0;
        if(component.get("v.showWonPopup")){
            if(optyWonList != null){
                for(var i=0; i<optyWonList.length; i++)    {
                    totalOptyAwardedSales += optyWonList[i].awardedSales;
                    totalOptyAwardedGM += optyWonList[i].awardedTPT;
                    if(familyMap.hasOwnProperty(optyWonList[i].Phoenix_Product_Family__c)){
                        var relatedList = familyMap[optyWonList[i].Phoenix_Product_Family__c];
                        relatedList.push(optyWonList[i]);
                        familyMap[optyWonList[i].Phoenix_Product_Family__c] = relatedList;
                    } else {
                        var relatedList = [];
                        relatedList.push(optyWonList[i]);
                        familyMap[optyWonList[i].Phoenix_Product_Family__c] = relatedList;
                    }      
                }
                component.set("v.dataObject.totalOptyAwardedSales", totalOptyAwardedSales);
                component.set("v.dataObject.totalOptyAwardedGM", totalOptyAwardedGM);
                component.set("v.optyWonFamilyMap", familyMap);
                component.set("v.optyWonFamilyList", Object.keys(familyMap));
            }
        }
    },
    openOptyLost: function(component, event, helper){
        component.set("v.showWonPopup", false);
        component.set("v.showLostPopup", !component.get("v.showLostPopup"));
        var optyLostList = component.get("v.optyLostList");
        var familyMap = {};
        var totalOptyProposedSales = 0; var totalOptyProposedGM = 0;
        if(component.get("v.showLostPopup")){
            if(optyLostList != null){
                for(var i=0; i<optyLostList.length; i++)    {
                    totalOptyProposedSales += optyLostList[i].proposedSales;
                    totalOptyProposedGM += optyLostList[i].proposedTPT;
                    if(familyMap.hasOwnProperty(optyLostList[i].Phoenix_Product_Family__c)){
                        var relatedList = familyMap[optyLostList[i].Phoenix_Product_Family__c];
                        relatedList.push(optyLostList[i]);
                        familyMap[optyLostList[i].Phoenix_Product_Family__c] = relatedList;
                    } else {
                        var relatedList = [];
                        relatedList.push(optyLostList[i]);
                        familyMap[optyLostList[i].Phoenix_Product_Family__c] = relatedList;
                    }      
                }
                component.set("v.dataObject.totalOptyProposedSales", totalOptyProposedSales);
                component.set("v.dataObject.totalOptyProposedGM", totalOptyProposedGM);
                component.set("v.optyLostFamilyMap", familyMap);
                component.set("v.optyLostFamilyList", Object.keys(familyMap));
            }
        }
    },
    openOptyWonTPTLT: function(component, event, helper){
        var showAwardedPopup = !component.get("v.showAwardedPopup");
        var dataList = component.get("v.wonLessThresholdList");
        if(showAwardedPopup){
            if(dataList != null){
                helper.preparePopupData(component, event, helper, dataList);
                component.set("v.popupName", 'TPT < Threshold');
            }   
        }
        component.set("v.showAwardedPopup", showAwardedPopup);
    },
    openOptyWonTPTGT: function(component, event, helper){
        console.log('Greater');
        component.set("v.totalSales", 0);
        component.set("v.totalGM", 0);
        component.set("v.popupFamilyMap", null);
        component.set("v.popupFamilyList", null);
        var showAwardedPopup = !component.get("v.showAwardedPopup");
        var dataList = component.get("v.wonGreaterThresholdList");
        if(showAwardedPopup){
            if(dataList != null){
                helper.preparePopupData(component, event, helper, dataList);
                component.set("v.popupName", 'TPT > Threshold');
            }   
        }
        component.set("v.showAwardedPopup", showAwardedPopup);
    },
    openOptyWonCIPInitiated: function(component, event, helper){
        component.set("v.totalSales", 0);
        component.set("v.totalGM", 0);
        component.set("v.popupFamilyMap", null);
        component.set("v.popupFamilyList", null);
        var showAwardedPopup = !component.get("v.showAwardedPopup");
        var dataList = component.get("v.wonCIPInitiatedList");
        if(showAwardedPopup){
            if(dataList != null){
                helper.preparePopupData(component, event, helper, dataList);
                component.set("v.popupName", 'CIP needs to be Initiated');
            }   
        }
        component.set("v.showAwardedPopup", showAwardedPopup);
    },
    openOptyWonCIPOn: function(component, event, helper){
        console.log('Greater');
        component.set("v.totalSales", 0);
        component.set("v.totalGM", 0);
        component.set("v.popupFamilyMap", null);
        component.set("v.popupFamilyList", null);
        var showAwardedPopup = !component.get("v.showAwardedPopup");
        var dataList = component.get("v.wonCIPOnList");
        if(showAwardedPopup){
            if(dataList != null){
                helper.preparePopupData(component, event, helper, dataList);
                component.set("v.popupName", 'CIP is ON');
            }   
        }
        component.set("v.showAwardedPopup", showAwardedPopup);
    },
    openOptyLostTPTLT: function(component, event, helper){
        component.set("v.totalSales", 0);
        component.set("v.totalGM", 0);
        component.set("v.popupFamilyMap", null);
        component.set("v.popupFamilyList", null);
        var showDeclinedPopup = !component.get("v.showDeclinedPopup");
        var dataList = component.get("v.lostLessThresholdList");
        if(showDeclinedPopup){
            if(dataList != null){
                helper.preparePopupData(component, event, helper, dataList);
                component.set("v.popupName", 'TPT < Threshold');
            }   
        }
        component.set("v.showDeclinedPopup", showDeclinedPopup);
    },
    openOptyLostTPTGT: function(component, event, helper){
        component.set("v.totalSales", 0);
        component.set("v.totalGM", 0);
        component.set("v.popupFamilyMap", null);
        component.set("v.popupFamilyList", null);
        var showDeclinedPopup = !component.get("v.showDeclinedPopup");
        var dataList = component.get("v.lostGreaterThresholdList");
        if(showDeclinedPopup){
            if(dataList != null){
                helper.preparePopupData(component, event, helper, dataList);
                component.set("v.popupName", 'TPT > Threshold');
            }   
        }
        component.set("v.showDeclinedPopup", showDeclinedPopup);
    },
    openOptyWonCIPInitiatedLT: function(component, event, helper){
        component.set("v.totalSales", 0);
        component.set("v.totalGM", 0);
        component.set("v.popupFamilyMap", null);
        component.set("v.popupFamilyList", null);
        var showDeclinedPopup = !component.get("v.showDeclinedPopup");
        var dataList = component.get("v.lostCIPInitiatedList");
        if(showDeclinedPopup){
            if(dataList != null){
                helper.preparePopupData(component, event, helper, dataList);
                component.set("v.popupName", 'CIP needs to be Initiated');
            }   
        }
        component.set("v.showDeclinedPopup", showDeclinedPopup);
    },
    openOptyWonCIPOnLT: function(component, event, helper){
        console.log('Greater');
        component.set("v.totalSales", 0);
        component.set("v.totalGM", 0);
        component.set("v.popupFamilyMap", null);
        component.set("v.popupFamilyList", null);
        var showDeclinedPopup = !component.get("v.showDeclinedPopup");
        var dataList = component.get("v.lostCIPOnList");
        if(showDeclinedPopup){
            if(dataList != null){
                helper.preparePopupData(component, event, helper, dataList);
                component.set("v.popupName", 'CIP is ON');
            }   
        }
        component.set("v.showDeclinedPopup", showDeclinedPopup);
    },
    closePopups: function(component, event, helper){
      	component.set("v.showAwardedPopup", false);
        component.set("v.showDeclinedPopup", false);
    },
    closeNPLPopup: function(component, event, helper){
      	component.set("v.showNPLPopup", false)  ;
    },
    openNPLPopup: function(component, event, helper){
        var optyWonList = component.get("v.optyWonList");
        var familyMap = {};
        var totalOptyAwardedSales = 0; var totalOptyAwardedGM = 0;
        var totalOptyProposedSales = 0; var totalOptyProposedGM = 0;
        if(optyWonList != null){
            for(var i=0; i<optyWonList.length; i++)    {
                totalOptyAwardedSales += optyWonList[i].awardedSales;
                totalOptyAwardedGM += optyWonList[i].awardedTPT;
                if(familyMap.hasOwnProperty(optyWonList[i].Phoenix_Product_Family__c)){
                    var relatedList = familyMap[optyWonList[i].Phoenix_Product_Family__c];
                    relatedList.push(optyWonList[i]);
                    familyMap[optyWonList[i].Phoenix_Product_Family__c] = relatedList;
                } else {
                    var relatedList = [];
                    relatedList.push(optyWonList[i]);
                    familyMap[optyWonList[i].Phoenix_Product_Family__c] = relatedList;
                }      
            }
            component.set("v.dataObject.totalOptyAwardedSales", totalOptyAwardedSales);
            component.set("v.dataObject.totalOptyAwardedGM", totalOptyAwardedGM);
            component.set("v.optyWonFamilyMap", familyMap);
            component.set("v.optyWonFamilyList", Object.keys(familyMap));
        }
        var optyLostList = component.get("v.optyLostList");
        var familyMapLost = {};
        if(optyLostList != null){
            for(var i=0; i<optyLostList.length; i++)    {
                totalOptyProposedSales += optyLostList[i].proposedSales;
                totalOptyProposedGM += optyLostList[i].proposedTPT;
                if(familyMapLost.hasOwnProperty(optyLostList[i].Phoenix_Product_Family__c)){
                    var relatedList = familyMapLost[optyLostList[i].Phoenix_Product_Family__c];
                    relatedList.push(optyLostList[i]);
                    familyMapLost[optyLostList[i].Phoenix_Product_Family__c] = relatedList;
                } else {
                    var relatedList = [];
                    relatedList.push(optyLostList[i]);
                    familyMapLost[optyLostList[i].Phoenix_Product_Family__c] = relatedList;
                }      
            }
            component.set("v.dataObject.totalOptyProposedSales", totalOptyProposedSales);
            component.set("v.dataObject.totalOptyProposedGM", totalOptyProposedGM);
            component.set("v.optyLostFamilyMap", familyMapLost);
            component.set("v.optyLostFamilyList", Object.keys(familyMapLost));
        }
        component.set("v.showNPLPopup", !component.get("v.showNPLPopup"));
    },
    searchWon: function(component, event, helper){
        var productSearchString = component.get("v.productSearchString");
        var customerSearchString = component.get("v.customerSearchString");
        var optyWonList = component.get("v.optyWonList");
        var familyMap = {}; var filteredList = [];
        if(optyWonList != null){
            for(var i=0; i<optyWonList.length; i++){
                if(productSearchString != null && customerSearchString != null){
                    if((optyWonList[i].Phoenix_Product_Family__c.toLowerCase().indexOf(productSearchString.toLowerCase()) !== -1 || 
                       optyWonList[i].Phoenix_Product__r.Name.toLowerCase().indexOf(productSearchString.toLowerCase()) !== -1 ||
                       optyWonList[i].Phoenix_NDC_Without_Dashes__c.indexOf(productSearchString) !== -1 ||
                       optyWonList[i].ProductCode.indexOf(productSearchString) !== -1) && 
                       optyWonList[i].Phoenix_Bid__r.Phoenix_Customer__r.Name.toLowerCase().indexOf(customerSearchString.toLowerCase()) !== -1){
                        filteredList.push(optyWonList[i]);
                    }
                }
                else if((productSearchString != null && optyWonList[i].Phoenix_Product_Family__c.toLowerCase().indexOf(productSearchString.toLowerCase()) !== -1) || 
                   (productSearchString != null && optyWonList[i].Phoenix_Product__r.Name.toLowerCase().indexOf(productSearchString.toLowerCase()) !== -1) || 
                   (customerSearchString != null && optyWonList[i].Phoenix_Bid__r.Phoenix_Customer__r.Name.toLowerCase().indexOf(customerSearchString.toLowerCase()) !== -1)){
                    filteredList.push(optyWonList[i]);
                }      
            }
        }
        console.log('Filter List Length: '+filteredList.length);
        if(filteredList != null){
            var updatedFamilyMap = {};
            for(var i=0; i<filteredList.length; i++)    {
                if(updatedFamilyMap.hasOwnProperty(filteredList[i].Phoenix_Product_Family__c)){
                    var relatedList = updatedFamilyMap[filteredList[i].Phoenix_Product_Family__c];
                    relatedList.push(filteredList[i]);
                    updatedFamilyMap[filteredList[i].Phoenix_Product_Family__c] = relatedList;
                } else {
                    var relatedList = [];
                    relatedList.push(filteredList[i]);
                    updatedFamilyMap[filteredList[i].Phoenix_Product_Family__c] = relatedList;
                }      
            }
            component.set("v.optyWonFamilyMap", updatedFamilyMap);
            component.set("v.optyWonFamilyList", Object.keys(updatedFamilyMap));
            console.log('Family Map: '+JSON.stringify(updatedFamilyMap));
        }
    },
    searchLostfunction: function(component, event, helper){
        var productSearchString = component.get("v.productSearchString");
        var customerSearchString = component.get("v.customerSearchString");
        var optyWonList = component.get("v.optyLostList");
        var familyMap = {}; var filteredList = [];
        if(optyWonList != null){
            for(var i=0; i<optyWonList.length; i++){
                if(productSearchString != null && customerSearchString != null){
                    if((optyWonList[i].Phoenix_Product_Family__c.toLowerCase().indexOf(productSearchString.toLowerCase()) !== -1 || 
                       optyWonList[i].Phoenix_Product__r.Name.toLowerCase().indexOf(productSearchString.toLowerCase()) !== -1 ||
                       optyWonList[i].Phoenix_NDC_Without_Dashes__c.indexOf(productSearchString) !== -1 ||
                       optyWonList[i].ProductCode.indexOf(productSearchString) !== -1) && 
                       optyWonList[i].Phoenix_Bid__r.Phoenix_Customer__r.Name.toLowerCase().indexOf(customerSearchString.toLowerCase()) !== -1){
                        filteredList.push(optyWonList[i]);
                    }
                }
                else if((productSearchString != null && optyWonList[i].Phoenix_Product_Family__c.toLowerCase().indexOf(productSearchString.toLowerCase()) !== -1) || 
                   (productSearchString != null && optyWonList[i].Phoenix_Product__r.Name.toLowerCase().indexOf(productSearchString.toLowerCase()) !== -1) || 
                   (customerSearchString != null && optyWonList[i].Phoenix_Bid__r.Phoenix_Customer__r.Name.toLowerCase().indexOf(customerSearchString.toLowerCase()) !== -1)){
                    filteredList.push(optyWonList[i]);
                }      
            }
        }
        console.log('Filter List Length: '+filteredList.length);
        if(filteredList != null){
            var updatedFamilyMap = {};
            for(var i=0; i<filteredList.length; i++)    {
                if(updatedFamilyMap.hasOwnProperty(filteredList[i].Phoenix_Product_Family__c)){
                    var relatedList = updatedFamilyMap[filteredList[i].Phoenix_Product_Family__c];
                    relatedList.push(filteredList[i]);
                    updatedFamilyMap[filteredList[i].Phoenix_Product_Family__c] = relatedList;
                } else {
                    var relatedList = [];
                    relatedList.push(filteredList[i]);
                    updatedFamilyMap[filteredList[i].Phoenix_Product_Family__c] = relatedList;
                }      
            }
            component.set("v.optyLostFamilyMap", updatedFamilyMap);
            component.set("v.optyLostFamilyList", Object.keys(updatedFamilyMap));
            console.log('Family Map: '+JSON.stringify(updatedFamilyMap));
        }
    },
})