({
    doInit: function(component, event, helper){
        var expandCollapseObj = component.get("v.expandCollapseObj");
        var objectType = typeof expandCollapseObj;
        if(objectType == 'string')
            component.set("v.expandCollapseObj", JSON.parse(expandCollapseObj));
        var ShareExpansionDataList = component.get("v.ShareExpansionDataList");
        var optyWonList = []; var optyLostList = []; var priceCOLOList = []; var supplyCOLOList = []; var wonLessThresholdList = []; var wonGreaterThresholdList = []; var lostLessThresholdList = []; var lostGreaterThresholdList = []; var wonCIPOnList = []; var wonCIPInitiatedList = [];
        var lostCIPOnList = []; var lostCIPInitiatedList = [];
		var totalOptyWonSales = 0; var totalOptyWonTPTSales = 0; var totalOptyLostSales = 0; var totalOptyLostTPTSales = 0; var totalPriceCOLOSales = 0; var totalSupplyCOLOSales = 0; var totalPriceCOLOTPTSales = 0; var totalSupplyCOLOTPTSales = 0;
        var ltOneSales = 0; var ltTwoSales = 0; var ltThreeSales = 0; var ltFourSales = 0;
        var ltOneTPTSales = 0; var ltTwoTPTSales = 0; var ltThreeTPTSales = 0; var ltFourTPTSales = 0;
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
        if(ShareExpansionDataList != null){
            for(var i=0; i<ShareExpansionDataList.length; i++){
                var awardedQty = ((ShareExpansionDataList[i].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c != null) ? ShareExpansionDataList[i].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c : 0);
                var proposedASP = ((ShareExpansionDataList[i].Phoenix_Proposed_ASP_Dose__c != null) ? ShareExpansionDataList[i].Phoenix_Proposed_ASP_Dose__c : 0);
                var proposedQty = ((ShareExpansionDataList[i].Phoenix_Final_Total_Selling_Unit__c != null) ? ShareExpansionDataList[i].Phoenix_Final_Total_Selling_Unit__c : 0);
                var awardedSales = awardedQty*proposedASP;                 
                var currentSales = 0;
                if(ShareExpansionDataList[i].Phoenix_Bid_Template_Refrence__c == 'ClarusOne')
                    currentSales = (ShareExpansionDataList[i].Phoenix_Net_Sales_External__c != null ? ShareExpansionDataList[i].Phoenix_Net_Sales_External__c : 0) ;
                else
                    currentSales = (ShareExpansionDataList[i].Finance_Current_Sales__c != null ? ShareExpansionDataList[i].Finance_Current_Sales__c : (ShareExpansionDataList[i].Phoenix_Current_Sales_Finance__c != null ? ShareExpansionDataList[i].Phoenix_Current_Sales_Finance__c : 0) );
                var proposedSales = (ShareExpansionDataList[i].Phoenix_Proposed_Sales__c != null ? ShareExpansionDataList[i].Phoenix_Proposed_Sales__c : 0);
                var awardedTPT = ((ShareExpansionDataList[i].Phoenix_Total_DRL_Share__c != null) ? ShareExpansionDataList[i].Phoenix_Total_DRL_Share__c : 0);
                var proposedTPT = ((ShareExpansionDataList[i].Phoenix_Total_DRL_Share__c != null) ? ShareExpansionDataList[i].Phoenix_Total_DRL_Share__c : 0);
                var currentTPT = (ShareExpansionDataList[i].Phoenix_Current_TP_Margin__c != null ? ShareExpansionDataList[i].Phoenix_Current_TP_Margin__c : 0);
                
                var awardedTPTPercent = awardedTPT/(proposedASP*awardedQty);
                var proposedTPTPercent = proposedTPT/proposedSales;
                //scmWrapperObj.currentTPT/(scmWrapperObj.currentDeadnet * scmWrapperObj.awardedQty)
                ShareExpansionDataList[i].awardedQty = awardedQty;
                ShareExpansionDataList[i].proposedASP = proposedASP;
                ShareExpansionDataList[i].currentSales = currentSales;
                ShareExpansionDataList[i].proposedQty = proposedQty;
                ShareExpansionDataList[i].awardedSales = (awardedSales - currentSales);
                ShareExpansionDataList[i].awardedTPT = (awardedTPT - currentTPT);
                ShareExpansionDataList[i].proposedTPT = (proposedTPT - currentTPT);
                ShareExpansionDataList[i].awardedTPTPercent = awardedTPTPercent;
                ShareExpansionDataList[i].proposedTPTPercent = proposedTPTPercent;
                ShareExpansionDataList[i].proposedSales = (proposedSales-currentSales);
                if(ShareExpansionDataList[i].Customer_Response_Lines__r != null && ShareExpansionDataList[i].Customer_Response_Lines__r.length > 0 && ShareExpansionDataList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Awarded'){
                    optyWonList.push(ShareExpansionDataList[i]);
                    totalOptyWonSales += (awardedSales-currentSales);
                    totalOptyWonTPTSales += (awardedTPT - currentTPT);
                    if(ShareExpansionDataList[i].Phoenix_Product__r.Phoenix_Is_partner_product__c){
                        if(ShareExpansionDataList[i].Phoenix_DRL_Margin_DRL__c < 25) {
                            wonLessThresholdList.push(ShareExpansionDataList[i]);
                            wonLessThresholdSales += (awardedSales-currentSales);
                            wonLessThresholdTPTSales += (awardedTPT - currentTPT);
                            if(ShareExpansionDataList[i].CIP_Status_Internal_Use__c == 'OnGoing'){
                            	wonCIPOnList.push(ShareExpansionDataList[i]);    
                                wonCIPOnSales += (awardedSales-currentSales);
                                wonCIPOnTPTSales += (awardedTPT - currentTPT);
                            } else{
                            	wonCIPInitiatedList.push(ShareExpansionDataList[i]);    
                                wonCIPInitiatedSales += (awardedSales-currentSales);
                                wonCIPInitiatedTPTSales += (awardedTPT - currentTPT);
                            }
                        } else {
                            wonGreaterThresholdList.push(ShareExpansionDataList[i]);
                            wonGreaterThresholdSales += (awardedSales-currentSales);
                            wonGreaterThresholdTPTSales += (awardedTPT - currentTPT);
                        }
                    } else {
                        if(ShareExpansionDataList[i].Phoenix_DRL_Margin_DRL__c < 40) {
                            wonLessThresholdList.push(ShareExpansionDataList[i]);
                            wonLessThresholdSales += (awardedSales-currentSales);
                            wonLessThresholdTPTSales += (awardedTPT - currentTPT);
                            if(ShareExpansionDataList[i].CIP_Status_Internal_Use__c == 'OnGoing'){
                            	wonCIPOnList.push(ShareExpansionDataList[i]);    
                                wonCIPOnSales += (awardedSales-currentSales);
                                wonCIPOnTPTSales += (awardedTPT - currentTPT);
                            } else{
                            	wonCIPInitiatedList.push(ShareExpansionDataList[i]);    
                                wonCIPInitiatedSales += (awardedSales-currentSales);
                                wonCIPInitiatedTPTSales += (awardedTPT - currentTPT);
                            }
                        } else {
                            wonGreaterThresholdList.push(ShareExpansionDataList[i]);
                            wonGreaterThresholdSales += (awardedSales-currentSales);
                            wonGreaterThresholdTPTSales += (awardedTPT - currentTPT);
                        }
                    }
                    
                } else if(ShareExpansionDataList[i].Customer_Response_Lines__r != null && ShareExpansionDataList[i].Customer_Response_Lines__r.length > 0 && ShareExpansionDataList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Declined by Customer'){
                    optyLostList.push(ShareExpansionDataList[i]);
                    if(ShareExpansionDataList[i].Customer_Response_Lines__r[0].Phoenix_Lead_Time_Days__c == 0){
                        priceCOLOList.push(ShareExpansionDataList[i]);
                        totalPriceCOLOSales += (proposedSales-currentSales);
                        totalPriceCOLOTPTSales += (proposedTPT - currentTPT);
                        if(ShareExpansionDataList[i].Phoenix_Product__r.Phoenix_Is_partner_product__c){
                            if(ShareExpansionDataList[i].Phoenix_DRL_Margin_DRL__c < 25) {
                                lostLessThresholdList.push(ShareExpansionDataList[i]);
                                lostLessThresholdSales += (proposedSales-currentSales);
                                lostLessThresholdTPTSales += (proposedTPT - currentTPT);
                                if(ShareExpansionDataList[i].CIP_Status_Internal_Use__c == 'OnGoing'){
                                    lostCIPOnList.push(ShareExpansionDataList[i]);    
                                    lostCIPOnSales += (proposedSales-currentSales);
                                    lostCIPOnTPTSales += (proposedTPT - currentTPT);
                                } else{
                                    lostCIPInitiatedList.push(ShareExpansionDataList[i]);    
                                    lostCIPInitiatedSales += (proposedSales-currentSales);
                                    lostCIPInitiatedTPTSales += (proposedTPT - currentTPT);
                                }
                            } else {
                                lostGreaterThresholdList.push(ShareExpansionDataList[i]);
                                lostGreaterThresholdSales += (proposedSales-currentSales);
                                lostGreaterThresholdTPTSales += (proposedTPT - currentTPT);
                            }
                        } else {
                            if(ShareExpansionDataList[i].Phoenix_DRL_Margin_DRL__c < 40) {
                                lostLessThresholdList.push(ShareExpansionDataList[i]);
                                lostLessThresholdSales += (proposedSales-currentSales);
                                lostLessThresholdTPTSales += (proposedTPT - currentTPT);
                                if(ShareExpansionDataList[i].CIP_Status_Internal_Use__c == 'OnGoing'){
                                    lostCIPOnList.push(ShareExpansionDataList[i]);    
                                    lostCIPOnSales += (proposedSales-currentSales);
                                    lostCIPOnTPTSales += (proposedTPT - currentTPT);
                                } else{
                                    lostCIPInitiatedList.push(ShareExpansionDataList[i]);    
                                    lostCIPInitiatedSales += (proposedSales-currentSales);
                                    lostCIPInitiatedTPTSales += (proposedTPT - currentTPT);
                                }
                            } else {
                                lostGreaterThresholdList.push(ShareExpansionDataList[i]);
                                lostGreaterThresholdSales += (proposedSales-currentSales);
                                lostGreaterThresholdTPTSales += (proposedTPT - currentTPT);
                            }
                        }
                    } else{
                        supplyCOLOList.push(ShareExpansionDataList[i]);
                        totalSupplyCOLOSales += (proposedSales-currentSales);
                        totalSupplyCOLOTPTSales += (proposedTPT - currentTPT);
                        if(ShareExpansionDataList[i].Customer_Response_Lines__r[0].Phoenix_Lead_Time_Days__c == null || ShareExpansionDataList[i].Customer_Response_Lines__r[0].Phoenix_Lead_Time_Days__c == 0 ||
                          ShareExpansionDataList[i].Customer_Response_Lines__r[0].Phoenix_Lead_Time_Days__c == 7 || ShareExpansionDataList[i].Customer_Response_Lines__r[0].Phoenix_Lead_Time_Days__c == 15 ||
                          ShareExpansionDataList[i].Customer_Response_Lines__r[0].Phoenix_Lead_Time_Days__c == 20 || ShareExpansionDataList[i].Customer_Response_Lines__r[0].Phoenix_Lead_Time_Days__c == 30){
                            ltOneSales += (proposedSales-currentSales);
                            ltOneTPTSales += (proposedTPT - currentTPT);
                        } else if(ShareExpansionDataList[i].Customer_Response_Lines__r[0].Phoenix_Lead_Time_Days__c == 30 || ShareExpansionDataList[i].Customer_Response_Lines__r[0].Phoenix_Lead_Time_Days__c == 45){
                            ltTwoSales += (proposedSales-currentSales);
                            ltTwoTPTSales += (proposedTPT - currentTPT);
                        } else if(ShareExpansionDataList[i].Customer_Response_Lines__r[0].Phoenix_Lead_Time_Days__c == 60){
                            ltThreeSales += (proposedSales-currentSales);
                            ltThreeTPTSales += (proposedTPT - currentTPT);
                        } else {
                            ltFourSales += (proposedSales-currentSales);
                            ltFourTPTSales += (proposedTPT - currentTPT);
                        }
                        
                    }
                    totalOptyLostSales += (proposedSales-currentSales);
                    totalOptyLostTPTSales += (proposedTPT - currentTPT);
                }
            }
        }
        var formattedTotalOptyWonSales = helper.formatCurrencyMethod(component, event, helper, totalOptyWonSales);
        var formattedTotalOptyLostSales = helper.formatCurrencyMethod(component, event, helper, totalOptyLostSales);
        var formattedTotalPriceCOLOSales = helper.formatCurrencyMethod(component, event, helper, totalPriceCOLOSales);
        var formattedTotalPriceCOLOTPTSales = helper.formatCurrencyMethod(component, event, helper, totalPriceCOLOTPTSales);
        var formattedTotalSupplyCOLOSales = helper.formatCurrencyMethod(component, event, helper, totalSupplyCOLOSales);
        var formattedTotalSupplyCOLOTPTSales = helper.formatCurrencyMethod(component, event, helper, totalSupplyCOLOTPTSales);
        
        var formattedTotalSupplyCOLOLeadTimeOneSales = helper.formatCurrencyMethod(component, event, helper, ltOneSales);
        var formattedTotalSupplyCOLOLeadTimeTwoSales = helper.formatCurrencyMethod(component, event, helper, ltTwoSales);
        var formattedTotalSupplyCOLOLeadTimeThreeSales = helper.formatCurrencyMethod(component, event, helper, ltThreeSales);
        var formattedTotalSupplyCOLOLeadTimeFourSales = helper.formatCurrencyMethod(component, event, helper, ltFourSales);
        var formattedTotalSupplyCOLOLeadTimeOneTPTSales = helper.formatCurrencyMethod(component, event, helper, ltOneTPTSales);
        var formattedTotalSupplyCOLOLeadTimeTwoTPTSales = helper.formatCurrencyMethod(component, event, helper, ltTwoTPTSales);
        var formattedTotalSupplyCOLOLeadTimeThreeTPTSales = helper.formatCurrencyMethod(component, event, helper, ltThreeTPTSales);
        var formattedTotalSupplyCOLOLeadTimeFourTPTSales = helper.formatCurrencyMethod(component, event, helper, ltFourTPTSales);
        
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
        component.set("v.priceCOLOList", priceCOLOList);
        component.set("v.lostLessThresholdList", lostLessThresholdList);
        component.set("v.lostGreaterThresholdList", lostGreaterThresholdList);
        component.set("v.lostCIPOnList", lostCIPOnList);
        component.set("v.lostCIPInitiatedList", lostCIPInitiatedList);
        component.set("v.supplyCOLOList", supplyCOLOList);
        
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
        
        component.set("v.dataObject.totalOptyWonCount", optyWonList.length);
        component.set("v.dataObject.totalOptyLostCount", optyLostList.length);
        
        component.set("v.optyWonList", optyWonList);
        component.set("v.optyLostList", optyLostList);
        
        component.set("v.dataObject.totalPriceCOLOCount", priceCOLOList.length);
        component.set("v.dataObject.totalSupplyCOLOCount", supplyCOLOList.length);
        
        component.set("v.dataObject.totalPriceCOLOSales", formattedTotalPriceCOLOSales);
        component.set("v.dataObject.totalPriceCOLOTPTSales", formattedTotalPriceCOLOTPTSales);
        component.set("v.dataObject.totalSupplyCOLOSales", formattedTotalSupplyCOLOSales);
        component.set("v.dataObject.totalSupplyCOLOTPTSales", formattedTotalSupplyCOLOTPTSales);
        
        
        component.set("v.dataObject.totalSupplyCOLOLeadTimeOneSales", formattedTotalSupplyCOLOLeadTimeOneSales);
        component.set("v.dataObject.totalSupplyCOLOLeadTimeTwoSales", formattedTotalSupplyCOLOLeadTimeTwoSales);
        component.set("v.dataObject.totalSupplyCOLOLeadTimeThreeSales", formattedTotalSupplyCOLOLeadTimeThreeSales);
        component.set("v.dataObject.totalSupplyCOLOLeadTimeFourSales", formattedTotalSupplyCOLOLeadTimeFourSales);
        component.set("v.dataObject.totalSupplyCOLOLeadTimeOneTPTSales", formattedTotalSupplyCOLOLeadTimeOneTPTSales);
        component.set("v.dataObject.totalSupplyCOLOLeadTimeTwoTPTSales", formattedTotalSupplyCOLOLeadTimeTwoTPTSales);
        component.set("v.dataObject.totalSupplyCOLOLeadTimeThreeTPTSales", formattedTotalSupplyCOLOLeadTimeThreeTPTSales);
        component.set("v.dataObject.totalSupplyCOLOLeadTimeFourTPTSales", formattedTotalSupplyCOLOLeadTimeFourTPTSales);
        
        component.set("v.dataObject.totalWonCIPOnSales", formattedWonCIPOnSales);
        component.set("v.dataObject.totalWonCIPOnTPTSales", formattedWonCIPOnTPTSales);
        component.set("v.dataObject.totalWonCIPInitiatedSales", formattedWonCIPInitiatedSales);
        component.set("v.dataObject.totalWonCIPInitiatedTPTSales", formattedWonCIPInitiatedTPTSales);
        component.set("v.dataObject.totalLostCIPOnSales", formattedLostCIPOnSales);
        component.set("v.dataObject.totalLostCIPOnTPTSales", formattedLostCIPOnTPTSales);
        component.set("v.dataObject.totalLostCIPInitiatedSales", formattedLostCIPInitiatedSales);
        component.set("v.dataObject.totalLostCIPInitiatedTPTSales", formattedLostCIPInitiatedTPTSales);
        
    },
    openTimeSeries : function(component, event, helper){
        component.set("v.selectedTimeSeriesItem",'Share Expansion Time Series');
        component.set("v.showTimeSeries",true);
    },
    optyWonTimeSeries : function(component, event, helper){
        component.set("v.selectedTimeSeriesItem",'Share Expansion Opportunity Won Time Series');
        component.set("v.showTimeSeries",true);
    },
    optyLostTimeSeries : function(component, event, helper){
        component.set("v.selectedTimeSeriesItem",'Share Expansion Opportunity Lost Time Series');
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
        if(clickedTd == 'NPL'){
            try{
                var currentBoolean = expandCollapseObj.expandNPL;
                expandCollapseObj.expandNPL = !currentBoolean;
                expandCollapseObj.expandOptyWon = !currentBoolean;
                expandCollapseObj.expandOptyLost = !currentBoolean;
                expandCollapseObj.expandLessThreshold1 = !currentBoolean;
                expandCollapseObj.expandLessThreshold2 = !currentBoolean;
                expandCollapseObj.expandDueToPrice = !currentBoolean;
                expandCollapseObj.expandDueToSupply = !currentBoolean;
                expandCollapseObj.expandSupplyLeadTimesInDays = !currentBoolean;
                component.set("v.expandCollapseObj", expandCollapseObj);
            } catch (error) {
                // Handle the error
                console.error('An error occurred:', error.message);                
                // Optionally, log the error details for debugging
                console.error(error);
            }
        }
        if(clickedTd == 'expandOptyWon'){
            try{
                expandCollapseObj.expandOptyWon = !expandCollapseObj.expandOptyWon;
            } catch (error) {
                console.error('An error occurred:', error.message);
            }
        }
        if(clickedTd == 'expandOptyLost'){
            try{
                expandCollapseObj.expandOptyLost = !expandCollapseObj.expandOptyLost;
            } catch (error) {
                console.error('An error occurred:', error.message);
            }
        }
        if(clickedTd == 'expandLessThreshold1'){
            try{
                expandCollapseObj.expandLessThreshold1 = !expandCollapseObj.expandLessThreshold1;
            } catch (error) {
                console.error('An error occurred:', error.message);
            }
        }
        if(clickedTd == 'expandLessThreshold2'){
            try{
                expandCollapseObj.expandLessThreshold2 = !expandCollapseObj.expandLessThreshold2;
            } catch (error) {
                console.error('An error occurred:', error.message);
            }
        }
        if(clickedTd == 'expandDueToPrice'){
            try{
                expandCollapseObj.expandDueToPrice = !expandCollapseObj.expandDueToPrice;
            } catch (error) {
                console.error('An error occurred:', error.message);
            }
        }
        if(clickedTd == 'expandDueToSupply'){
            try{
                expandCollapseObj.expandDueToSupply = !expandCollapseObj.expandDueToSupply;
            } catch (error) {
                console.error('An error occurred:', error.message);
            }
        }
        if(clickedTd == 'expandSupplyLeadTimesInDays'){
            try{
                expandCollapseObj.expandSupplyLeadTimesInDays = !expandCollapseObj.expandSupplyLeadTimesInDays;
            } catch (error) {
                console.error('An error occurred:', error.message);
            }
        }
        component.set("v.expandCollapseObj", expandCollapseObj);
    },
    openOptyWon: function(component, event, helper){
        component.set("v.showWonPopup", !component.get("v.showWonPopup"));
        var optyWonList = component.get("v.optyWonList");
        var familyMap = {};
        var totalOptyAwardedSales = 0; var totalOptyAwardedGM = 0;
        if(component.get("v.showWonPopup")){
            if(optyWonList != null){
                for(var i=0; i<optyWonList.length; i++)    {
                    var awardedQty = ((optyWonList[i].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c != null) ? optyWonList[i].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c : 0);
                    var proposedASP = ((optyWonList[i].Phoenix_Proposed_ASP_Dose__c != null) ? optyWonList[i].Phoenix_Proposed_ASP_Dose__c : 0);
                    var proposedQty = ((optyWonList[i].Phoenix_Final_Total_Selling_Unit__c != null) ? optyWonList[i].Phoenix_Final_Total_Selling_Unit__c : 0);
                    var awardedSales = awardedQty*proposedASP;                 
                    var currentSales = 0;
                    if(optyWonList[i].Phoenix_Bid_Template_Refrence__c == 'ClarusOne')
                        currentSales = (optyWonList[i].Phoenix_Net_Sales_External__c != null ? optyWonList[i].Phoenix_Net_Sales_External__c : 0) ;
                    else
                        currentSales = (optyWonList[i].Finance_Current_Sales__c != null ? optyWonList[i].Finance_Current_Sales__c : (optyWonList[i].Phoenix_Current_Sales_Finance__c != null ? optyWonList[i].Phoenix_Current_Sales_Finance__c : 0) );
                    var proposedSales = (optyWonList[i].Phoenix_Proposed_Sales__c != null ? optyWonList[i].Phoenix_Proposed_Sales__c : 0);
                    var awardedTPT = ((optyWonList[i].Phoenix_Total_DRL_Share__c != null) ? optyWonList[i].Phoenix_Total_DRL_Share__c : 0);
                    var proposedTPT = ((optyWonList[i].Phoenix_Total_DRL_Share__c != null) ? optyWonList[i].Phoenix_Total_DRL_Share__c : 0);
                    var currentTPT = (optyWonList[i].Phoenix_Current_TP_Margin__c != null ? optyWonList[i].Phoenix_Current_TP_Margin__c : 0);
                    
                    var awardedTPTPercent = awardedTPT/(proposedASP*awardedQty);
                    var proposedTPTPercent = proposedTPT/proposedSales;
                    //scmWrapperObj.currentTPT/(scmWrapperObj.currentDeadnet * scmWrapperObj.awardedQty)
                    optyWonList[i].awardedQty = awardedQty;
                    optyWonList[i].proposedASP = proposedASP;
                    optyWonList[i].currentSales = currentSales;
                    optyWonList[i].proposedQty = proposedQty;
                    optyWonList[i].awardedSales = (awardedSales - currentSales);
                    optyWonList[i].awardedTPT = (awardedTPT - currentTPT);
                    optyWonList[i].proposedTPT = (proposedTPT - currentTPT);
                    optyWonList[i].awardedTPTPercent = awardedTPTPercent;
                    optyWonList[i].proposedTPTPercent = proposedTPTPercent;
                    optyWonList[i].proposedSales = (proposedSales-currentSales);
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
    openOptyLostPriceCOLO: function(component, event, helper){
        console.log('Greater');
        component.set("v.totalSales", 0);
        component.set("v.totalGM", 0);
        component.set("v.popupFamilyMap", null);
        component.set("v.popupFamilyList", null);
        var showDeclinedPopup = !component.get("v.showDeclinedPopup");
        var dataList = component.get("v.priceCOLOList");
        if(showDeclinedPopup){
            if(dataList != null){
                helper.preparePopupData(component, event, helper, dataList);
                component.set("v.popupName", 'Due to Price (Price COLO)');
            }   
        }
        component.set("v.showDeclinedPopup", showDeclinedPopup);
    },
    openOptyLostSupplyCOLO: function(component, event, helper){
        console.log('Greater');
        component.set("v.totalSales", 0);
        component.set("v.totalGM", 0);
        component.set("v.popupFamilyMap", null);
        component.set("v.popupFamilyList", null);
        var showDeclinedPopup = !component.get("v.showDeclinedPopup");
        var dataList = component.get("v.supplyCOLOList");
        if(showDeclinedPopup){
            if(dataList != null){
                helper.preparePopupData(component, event, helper, dataList);
                component.set("v.popupName", 'Due to Supply or Price');
            }   
        }
        component.set("v.showDeclinedPopup", showDeclinedPopup);
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
    openOptyLost: function(component, event, helper){
        component.set("v.showWonPopup", false);
        component.set("v.showLostPopup", !component.get("v.showLostPopup"));
        var optyLostList = component.get("v.optyLostList");
        var familyMap = {};
        var totalOptyProposedSales = 0; var totalOptyProposedGM = 0;
        if(component.get("v.showLostPopup")){
            if(optyLostList != null){
                for(var i=0; i<optyLostList.length; i++)    {
                    var awardedQty = ((optyLostList[i].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c != null) ? optyLostList[i].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c : 0);
                    var proposedASP = ((optyLostList[i].Phoenix_Proposed_ASP_Dose__c != null) ? optyLostList[i].Phoenix_Proposed_ASP_Dose__c : 0);
                    var proposedQty = ((optyLostList[i].Phoenix_Final_Total_Selling_Unit__c != null) ? optyLostList[i].Phoenix_Final_Total_Selling_Unit__c : 0);
                    var awardedSales = awardedQty*proposedASP;                 
                    var currentSales = 0;
                    if(optyLostList[i].Phoenix_Bid_Template_Refrence__c == 'ClarusOne')
                        currentSales = (optyLostList[i].Phoenix_Net_Sales_External__c != null ? optyLostList[i].Phoenix_Net_Sales_External__c : 0) ;
                    else
                        currentSales = (optyLostList[i].Finance_Current_Sales__c != null ? optyLostList[i].Finance_Current_Sales__c : (optyLostList[i].Phoenix_Current_Sales_Finance__c != null ? optyLostList[i].Phoenix_Current_Sales_Finance__c : 0) );
                    var proposedSales = (optyLostList[i].Phoenix_Proposed_Sales__c != null ? optyLostList[i].Phoenix_Proposed_Sales__c : 0);
                    var awardedTPT = ((optyLostList[i].Phoenix_Total_DRL_Share__c != null) ? optyLostList[i].Phoenix_Total_DRL_Share__c : 0);
                    var proposedTPT = ((optyLostList[i].Phoenix_Total_DRL_Share__c != null) ? optyLostList[i].Phoenix_Total_DRL_Share__c : 0);
                    var currentTPT = (optyLostList[i].Phoenix_Current_TP_Margin__c != null ? optyLostList[i].Phoenix_Current_TP_Margin__c : 0);
                    
                    var awardedTPTPercent = awardedTPT/(proposedASP*awardedQty);
                    var proposedTPTPercent = proposedTPT/proposedSales;
                    //scmWrapperObj.currentTPT/(scmWrapperObj.currentDeadnet * scmWrapperObj.awardedQty)
                    optyLostList[i].awardedQty = awardedQty;
                    optyLostList[i].proposedASP = proposedASP;
                    optyLostList[i].currentSales = currentSales;
                    optyLostList[i].proposedQty = proposedQty;
                    optyLostList[i].awardedSales = (awardedSales - currentSales);
                    optyLostList[i].awardedTPT = (awardedTPT - currentTPT);
                    optyLostList[i].proposedTPT = (proposedTPT - currentTPT);
                    optyLostList[i].awardedTPTPercent = awardedTPTPercent;
                    optyLostList[i].proposedTPTPercent = proposedTPTPercent;
                    optyLostList[i].proposedSales = (awardedSales-currentSales);
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