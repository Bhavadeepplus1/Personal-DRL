({
    getTimeSeriesData : function(component, event, FromDate, ToDate, index, quarter) {      
        component.set("v.isSpinnerLoad", true);
        var action = component.get("c.getDataBasedOnQuarter");
        action.setParams({
            'FromDate': FromDate,
            'ToDate': ToDate,
            'basedOn': component.get("v.basedOn"),
            'quarter': quarter
        });
        action.setCallback(this, function(response){
            if(response.getState() == 'SUCCESS'){
                component.set("v.loadingMessage", 'Fetching Data for '+quarter);
                var wrapper = response.getReturnValue();
                var NPLList = wrapper.NPLList; var NewProductList = []; var totalNPL = 0;                  
                if(NPLList != null){
                    for(var i=0; i<NPLList.length; i++){
                        if(NPLList[i].Phoenix_Bid__r.Phoenix_Bid_Type__c == 'New Product Launch' || NPLList[i].Phoenix_Bid__r.Phoenix_Bid_Type__c == 'OTC New Product'){
                            if(!NewProductList.includes(NPLList[i].Phoenix_Bid__c)){
                                if(NPLList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Awarded'){
                                    totalNPL += 1;
                                }
                                NewProductList.push(NPLList[i].Phoenix_Bid__c);
                            }
                        }
                    }
                }
                console.log('Total NPL: '+totalNPL);
                var ProActiveList = wrapper.ProActiveList; var NewCustomerList=[]; var totalNewCustomer=0; var ProductAdditionList=[]; var totalProductAddition=0;                      
                
                if(ProActiveList != null){
                    for(var i=0; i<ProActiveList.length; i++){
                        if(ProActiveList[i].Phoenix_Bid__r.Phoenix_Bid_Type__c == 'New Customer'){
                            if(!NewCustomerList.includes(ProActiveList[i].Phoenix_Bid__c)){
                                if(ProActiveList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Awarded'){
                                    totalNewCustomer += 1;
                                } 
                                NewCustomerList.push(ProActiveList[i].Phoenix_Bid__c);
                            }
                        } else if(ProActiveList[i].Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Product Addition' || ProActiveList[i].Phoenix_Bid__r.Phoenix_Bid_Type__c == 'OTC Product Addition'){
                            if(!ProductAdditionList.includes(ProActiveList[i].Phoenix_Bid__c)){
                                if(ProActiveList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Awarded'){
                                    totalProductAddition += 1;
                                } 
                                ProductAdditionList.push(ProActiveList[i].Phoenix_Bid__c);
                            }
                        } 
                    }
                }
                console.log('totalNewCustomer: '+totalNewCustomer);
                console.log('NewCustomerList: '+NewCustomerList.length);
                console.log('totalProductAddition: '+totalProductAddition);
                console.log('ProductAdditionList: '+ProductAdditionList.length);
                console.log('ProActive: '+(totalNewCustomer+totalProductAddition));
                var ReActiveList = wrapper.ReActiveList; var ReActiveRFPList=[]; var ReActivetotalRFP=0; var OTBList=[]; var totalOTBs =0; var VolumeReviewList=[]; var totalVolumeReview=0;
                if(ReActiveList != null){
                    for(var i=0; i<ReActiveList.length; i++){
                        var currentSales = ((ReActiveList[i].Phoenix_Current_Sales_Finance__c != null) ? ReActiveList[i].Phoenix_Current_Sales_Finance__c : 0);
                        var awardedQty = ((ReActiveList[i].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c != null) ? ReActiveList[i].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c : 0);
                        var proposedASP = ((ReActiveList[i].Phoenix_Proposed_ASP_Dose__c != null) ? ReActiveList[i].Phoenix_Proposed_ASP_Dose__c : 0);
                        var proposedQty = ((ReActiveList[i].Phoenix_Final_Total_Selling_Unit__c != null) ? ReActiveList[i].Phoenix_Final_Total_Selling_Unit__c : 0);
                        var awardedSales = awardedQty*proposedASP;
                        var proposedSales = proposedQty*proposedASP;
                        if((ReActiveList[i].Phoenix_Bid__r.Phoenix_Bid_Type__c == 'RFP Bids' || ReActiveList[i].Phoenix_Bid__r.Phoenix_Bid_Type__c == 'OTC RFP') && ((((awardedQty * proposedASP) >= currentSales)) || (((proposedSales) > currentSales))) ){
                            if(!ReActiveRFPList.includes(ReActiveList[i].Phoenix_Bid__c)){
                                if(ReActiveList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Awarded'){
                                    ReActivetotalRFP += 1;
                                }
                                ReActiveRFPList.push(ReActiveList[i].Phoenix_Bid__c);   
                            }
                        }else if(ReActiveList[i].Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Good Dated OTB' || ReActiveList[i].Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Short Dated OTB' || ReActiveList[i].Phoenix_Bid__r.Phoenix_Bid_Type__c == 'OTC OTB Good Dated' ||
                                 ReActiveList[i].Phoenix_Bid__r.Phoenix_Bid_Type__c == 'OTC OTB Short Dated'){
                            if(!OTBList.includes(ReActiveList[i].Phoenix_Bid__c)){
                                if(ReActiveList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Awarded'){
                                    totalOTBs += 1;
                                }   
                                OTBList.push(ReActiveList[i].Phoenix_Bid__c);
                            }
                        } else if(ReActiveList[i].Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Volume Review Only' || ReActiveList[i].Phoenix_Bid__r.Phoenix_Bid_Type__c == 'OTC Volume Review'){
                            if(!VolumeReviewList.includes(ReActiveList[i].Phoenix_Bid__c)){
                                if(ReActiveList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Awarded'){
                                    totalVolumeReview += 1;
                                }
                                VolumeReviewList.push(ReActiveList[i].Phoenix_Bid__c);
                            }
                        } 
                    }
                }
                console.log('ReActivetotalRFP: '+ReActivetotalRFP);
                console.log('totalOTBs: '+totalOTBs);
                console.log('totalVolumeReview: '+totalVolumeReview);
                console.log('ReActive: '+(ReActivetotalRFP+totalOTBs+totalVolumeReview));
                var ROFRList = wrapper.ROFRList; var ROFRRFPList=[];var ROFRtotalRFP=0; var PriceChangeList=[]; var totalPriceChange=0;
                if(ROFRList != null){
                    for(var i=0; i<ROFRList.length; i++){
                        var currentSales = ((ROFRList[i].Phoenix_Current_Sales_Finance__c != null) ? ROFRList[i].Phoenix_Current_Sales_Finance__c : 0);
                        var awardedQty = ((ROFRList[i].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c != null) ? ROFRList[i].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c : 0);
                        var proposedASP = ((ROFRList[i].Phoenix_Proposed_ASP_Dose__c != null) ? ROFRList[i].Phoenix_Proposed_ASP_Dose__c : 0);
                        var proposedQty = ((ROFRList[i].Phoenix_Final_Total_Selling_Unit__c != null) ? ROFRList[i].Phoenix_Final_Total_Selling_Unit__c : 0);
                        var awardedSales = awardedQty*proposedASP;
                        var proposedSales = proposedQty*proposedASP;
                        if((ROFRList[i].Phoenix_Bid__r.Phoenix_Bid_Type__c == 'RFP Bids' || ROFRList[i].Phoenix_Bid__r.Phoenix_Bid_Type__c == 'OTC RFP') && ((((awardedQty * proposedASP) < currentSales) && currentSales > 0) || ((proposedSales <= currentSales) && currentSales > 0))){
                            if(!ROFRRFPList.includes(ROFRList[i].Phoenix_Bid__c)){
                                if(ROFRList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Awarded'){
                                    ROFRtotalRFP += 1;
                                }
                                ROFRRFPList.push(ROFRList[i].Phoenix_Bid__c);
                            }
                        } else if(ROFRList[i].Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Price Change' || ROFRList[i].Phoenix_Bid__r.Phoenix_Bid_Type__c == 'OTC Price Change'){
                            if(!PriceChangeList.includes(ROFRList[i].Phoenix_Bid__c)){
                                if(ROFRList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Awarded'){
                                    totalPriceChange += 1;
                                }
                                PriceChangeList.push(ROFRList[i].Phoenix_Bid__c);
                            }
                        } 
                    }
                }
                console.log('ROFRtotalRFP: '+ROFRtotalRFP);
                console.log('totalPriceChange: '+totalPriceChange);
                console.log('ROFR: '+(ROFRtotalRFP+totalPriceChange));
                wrapper.NPLAwardedCount = totalNPL;
                wrapper.ProActiveAwardedCount = (totalNewCustomer+totalProductAddition);
                wrapper.ReActiveAwardedCount = (ReActivetotalRFP+totalOTBs+totalVolumeReview);
                wrapper.ROFRAwardedCount = (ROFRtotalRFP+totalPriceChange);
                          
                
                if(index == 0){
                    /*var q1Data = response.getReturnValue();
                    q1Data.NPLWinRate = q1Data.NPLAwardedCount/q1Data.NPLBidsCount;
                    q1Data.ProActiveWinRate = q1Data.ProActiveAwardedCount/q1Data.ProActiveBidsCount;
                    q1Data.ReActiveWinRate = q1Data.ReActiveAwardedCount/q1Data.ReActiveBidsCount;
                    q1Data.ROFRsWinRate = q1Data.ROFRAwardedCount/q1Data.ROFRBidsCount;*/
                    component.set("v.Quarter1", wrapper);
                } else if(index == 1){
                    component.set("v.Quarter2", wrapper);
                } else if(index == 2){
                    component.set("v.Quarter3", wrapper);
                } else if(index == 3){
                    component.set("v.Quarter4", wrapper);
                } else if(index == 4){
                    var q1Data = component.get("v.Quarter1");
                    var finalQuarterData = wrapper;
                    finalQuarterData.NPLWinRate = finalQuarterData.NPLAwardedCount/finalQuarterData.NPLBidsCount;
                    q1Data.NPLWinRate = q1Data.NPLAwardedCount/q1Data.NPLBidsCount;
                    finalQuarterData.ProActiveWinRate = finalQuarterData.ProActiveAwardedCount/finalQuarterData.ProActiveBidsCount;
                    q1Data.ProActiveWinRate = q1Data.ProActiveAwardedCount/q1Data.ProActiveBidsCount;
                    finalQuarterData.ReActiveWinRate = finalQuarterData.ReActiveAwardedCount/finalQuarterData.ReActiveBidsCount;
                    q1Data.ReActiveWinRate = q1Data.ReActiveAwardedCount/q1Data.ReActiveBidsCount;
                    finalQuarterData.ROFRsWinRate = finalQuarterData.ROFRAwardedCount/finalQuarterData.ROFRBidsCount;
                    q1Data.ROFRsWinRate = q1Data.ROFRAwardedCount/q1Data.ROFRBidsCount;
                    
                    if((finalQuarterData.NPLWinRate > q1Data.NPLWinRate) && ((finalQuarterData.NPLWinRate - q1Data.NPLWinRate) > 0.1 || (finalQuarterData.NPLWinRate - q1Data.NPLWinRate) < -0.1)){
                        finalQuarterData.greaterNPL = true;
                    } else if((finalQuarterData.NPLWinRate < q1Data.NPLWinRate) && ((finalQuarterData.NPLWinRate - q1Data.NPLWinRate) > 0.1 || (finalQuarterData.NPLWinRate - q1Data.NPLWinRate) < -0.1)){
                        finalQuarterData.lesserNPL = true;
                    } else{
                        if(isNaN(finalQuarterData.NPLWinRate) || isNaN(q1Data.NPLWinRate)){
                            finalQuarterData.isNaNNPL = true;
                        }
                        finalQuarterData.equalNPL = true;
                    }
                    if((finalQuarterData.ProActiveWinRate > q1Data.ProActiveWinRate) && ((finalQuarterData.ProActiveWinRate - q1Data.ProActiveWinRate) > 0.1 || (finalQuarterData.ProActiveWinRate - q1Data.ProActiveWinRate) < -0.1)){
                        finalQuarterData.greaterProActive = true;
                    } else if((finalQuarterData.ProActiveWinRate < q1Data.ProActiveWinRate) && ((finalQuarterData.ProActiveWinRate - q1Data.ProActiveWinRate) > 0.1 || (finalQuarterData.ProActiveWinRate - q1Data.ProActiveWinRate) < -0.1)){
                        finalQuarterData.lesserProActive = true;
                    } else{
                        if(isNaN(finalQuarterData.ProActiveWinRate) || isNaN(q1Data.ProActiveWinRate)){
                            finalQuarterData.isNaNProActive = true;
                        }
                        finalQuarterData.equalProActiveL = true;
                    }
                    if((finalQuarterData.ReActiveWinRate > q1Data.ReActiveWinRate) && ((finalQuarterData.ReActiveWinRate - q1Data.ReActiveWinRate) > 0.1 || (finalQuarterData.ReActiveWinRate - q1Data.ReActiveWinRate) < -0.1)){
                        finalQuarterData.greaterReActive = true;
                    } else if((finalQuarterData.ReActiveWinRate < q1Data.ReActiveWinRate) && ((finalQuarterData.ReActiveWinRate - q1Data.ReActiveWinRate) > 0.1 || (finalQuarterData.ReActiveWinRate - q1Data.ReActiveWinRate) < -0.1)){
                        finalQuarterData.lesserReActive = true;
                    } else{
                        if(isNaN(finalQuarterData.ReActiveWinRate) || isNaN(q1Data.ReActiveWinRate)){
                            finalQuarterData.isNaNReActive = true;
                        }
                        finalQuarterData.equalReActive = true;
                    }
                    if((finalQuarterData.ROFRsWinRate > q1Data.ROFRsWinRate) && ((finalQuarterData.ROFRsWinRate - q1Data.ROFRsWinRate) > 0.1 || (finalQuarterData.ROFRsWinRate - q1Data.ROFRsWinRate) < -0.1)){
                        finalQuarterData.greaterROFRs = true;
                    } else if((finalQuarterData.ROFRsWinRate < q1Data.ROFRsWinRate) && ((finalQuarterData.ROFRsWinRate - q1Data.ROFRsWinRate) > 0.1 || (finalQuarterData.ROFRsWinRate - q1Data.ROFRsWinRate) < -0.1)){
                        finalQuarterData.lesserROFRs = true;
                    } else{
                        if(isNaN(finalQuarterData.ROFRsWinRate) || isNaN(q1Data.ROFRsWinRate)){
                            finalQuarterData.isNaNROFRs = true;
                        }
                        finalQuarterData.equalROFRs = true;
                    }
                    var q1WinRate = (q1Data.NPLAwardedCount+q1Data.ProActiveAwardedCount+q1Data.ReActiveAwardedCount+q1Data.ROFRAwardedCount)/(q1Data.NPLBidsCount+q1Data.ProActiveBidsCount+q1Data.ReActiveBidsCount+q1Data.ROFRBidsCount);
                    var q2WinRate = (finalQuarterData.NPLAwardedCount+finalQuarterData.ProActiveAwardedCount+finalQuarterData.ReActiveAwardedCount+finalQuarterData.ROFRAwardedCount)/(finalQuarterData.NPLBidsCount+finalQuarterData.ProActiveBidsCount+finalQuarterData.ReActiveBidsCount+finalQuarterData.ROFRBidsCount);
                    if((q2WinRate > q1WinRate) && ((q2WinRate - q1WinRate) > 0.1 || (q2WinRate - q1WinRate) < -0.1)){
                        finalQuarterData.greater = true;
                    } else if((q2WinRate < q1WinRate) && ((q2WinRate - q1WinRate) > 0.1 || (q2WinRate - q1WinRate) < -0.1)){
                        finalQuarterData.lesser = true;
                    } else{
                        if(isNaN(q2WinRate) || isNaN(q1WinRate)){
                            finalQuarterData.isNaN = true;
                        }
                        finalQuarterData.equal = true;
                    }
                    finalQuarterData.q2WinRate = q2WinRate;
                    component.set("v.Quarter5", finalQuarterData);
                }
                component.set("v.loadingMessage", '');
                component.set("v.isSpinnerLoad", false);
            } else{
                console.log("Exception: "+JSON.stringify(response.getError()));
                component.set("v.isSpinnerLoad", false);
            }
        });
        $A.enqueueAction(action);
	}
})