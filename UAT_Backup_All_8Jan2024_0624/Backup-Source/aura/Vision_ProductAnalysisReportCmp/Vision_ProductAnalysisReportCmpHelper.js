({
    getData : function(component, event, helper, startDate, endDate, selectedRange) {
        var action = component.get("c.getProductAnalysisData");
        action.setParams({
            'startDate': startDate,
            'endDate': endDate,
            "recordId": component.get("v.recordId"),
            'selectedRange': selectedRange,
        });
        action.setCallback(this, function (response) { 
            if(response.getState() == "SUCCESS"){ 
                var totalRes =response.getReturnValue();
                console.log('totalRes-->'+JSON.stringify(totalRes))
                var salesDl = totalRes.salesdl;
                var trendSalesDollar = totalRes.trendSalesDollar;
                console.log('trendSalesDollar-->'+trendSalesDollar)
                var recentAwardsProdAdditionList =  totalRes.recentAwardsProdAdditionList;
                var recentAwardsNewPLList =  totalRes.recentAwardsNewPLList;
                var recentAwardsRFPList =  totalRes.recentAwardsRFPList;
                var recentAwardsNewCustomerList =  totalRes.recentAwardsNewCustomerList;
                var mapListFIProdAdd = totalRes.mapListFIProdAdd;
                var mapListFIRFP = totalRes.mapListFIRFP;
                var mapListFINewPL = totalRes.mapListFINewPL;
                var decreasesRFPList = totalRes.decreasesRFPList;
                var decreasesPriceChangeList = totalRes.decreasesPriceChangeList;
                var decreasesvolumeReviewList = totalRes.decreasesvolumeReviewList;
                var mapListDecreasesRFP = totalRes.mapListDecreasesRFP;
                var mapListDecreasesPriceChange = totalRes.mapListDecreasesPriceChange;
                var mapListDecreasesVolumeReview  = totalRes.mapListDecreasesVolumeReview ;
                var productLossesMassProductRemovalList = totalRes.productLossesMassProductRemovalList;
                var productLossesPriceChangeList = totalRes.productLossesPriceChangeList;
                var productLossesvolumeReviewList = totalRes.productLossesvolumeReviewList;
                var productLossesRFPList = totalRes.productLossesRFPList;
                
                // var effectivedate = recentAwards.recentAwardsProdAdditionList[0].Phoenix_Price_Effective_Date__c;
                var effectiveDateList = [];
                var totalBusinessImpactPA = 0; var totalBusinessImpactNPL = 0; var totalBusinessImpactRFP = 0; var totalBusinessImpactNC = 0;
                var totalBusinessImpactPCDecreaseGain = 0; var totalBusinessImpactVRDecreaseGain = 0; var totalBusinessImpactRFPDecreaseGain = 0;
                var totalBusinessImpactPCDecrease = 0; var totalBusinessImpactVRDecrease = 0; var totalBusinessImpactRFPDecrease = 0;
                var totalBusinessImpactMPRLoss = 0; var totalBusinessImpactPCLoss = 0; var totalBusinessImpactVROLoss = 0; var totalBusinessImpactRFPLoss = 0;
                
                var months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
                var Q1 = ['Apr', 'May', 'Jun'];
                var Q2 = ['Jul', 'Aug', 'Sep'];
                var Q3 = ['Oct', 'Nov', 'Dec'];
                var Q4 = ['Jan', 'Feb', 'Mar'];
                var recentAwardsProdAdditionListUpdated = []; var recentAwardsNewPLListUpdated = []; var recentAwardsRFPListUpdated = []; var recentAwardsNewCustomerListUpdated = [];
                var decreasesGainRFPListUpdated = []; var decreasesGainPriceChangeListUpdated = []; var decreasesGainvolumeReviewListUpdated = [];
                var decreasesRFPListUpdated = []; var decreasesPriceChangeListUpdated = []; var decreasesvolumeReviewListUpdated = [];
                var productLossesMassProductRemovalListUpdated = []; var productLossesPriceChangeListUpdated = []; var productLossesvolumeReviewListUpdated = []; var productLossesRFPListListUpdated = [];
                var familiesPA = Object.keys(totalRes.mapRecentAwardsProductAdditionList);
                component.set("v.familiesPA", familiesPA);
                for(var f=0; f<familiesPA.length; f++){
                    var dataObj = {};
                    var dataList = [];
                    var totalAwardedVolume = 0;
                    var totalAwardedAnnualValue = 0;
                    var totalAnnualImpact = 0;
                    var totalBusinessImpact = 0;
                    for(var i=0; i<recentAwardsProdAdditionList.length; i++){
                        if(recentAwardsProdAdditionList[i].Phoenix_Product__r.Family == familiesPA[f] && recentAwardsProdAdditionList[i].Customer_Response_Lines__r && recentAwardsProdAdditionList[i].Customer_Response_Lines__r[0].Phoenix_Price_Effective_Date__c){
                            var d = new Date(recentAwardsProdAdditionList[i].Customer_Response_Lines__r[0].Phoenix_Price_Effective_Date__c);
                            var todayDate =  new Date();
                            var currentMonthString = months[todayDate.getMonth()];
                            console.log('Current Month Awards PA: '+currentMonthString);
                            var remainingMnths = 0;
                            var endFY;
                            if(Q1.includes(currentMonthString)){
                                var diff = 0;
                                for(var j=0; j<Q1.length; j++){
                                    if(Q1[j] == currentMonthString){
                                        diff = Q1.length-1 - j;
                                    }
                                }
                                remainingMnths = remainingMnths + diff + 9;
                            } else if (Q2.includes(currentMonthString)){
                                var diff = 0;
                                for(var j=0; j<Q2.length; j++){
                                    if(Q2[j] == currentMonthString){
                                        diff = Q2.length-1 - j;
                                    }
                                }
                                remainingMnths = remainingMnths + diff + 6;
                            } else if (Q3.includes(currentMonthString)){
                                var diff = 0;
                                for(var j=0; j<Q3.length; j++){
                                    if(Q3[j] == currentMonthString){
                                        diff = Q3.length-1 - j;
                                    }
                                }
                                remainingMnths = remainingMnths + diff + 3;
                            } else if (Q4.includes(currentMonthString)){
                                var diff = 0;
                                for(var j=0; j<Q4.length; j++){
                                    if(Q4[j] == currentMonthString){
                                        diff = Q4.length-1 - j;
                                    }
                                }
                                remainingMnths = remainingMnths + diff + 0;
                            } 
                            console.log('remainingMnths Awards PA: '+remainingMnths);
                            var endDate = new Date();
                            var date = new Date(endDate.setMonth(remainingMnths+1));
                            var endDateOfFiscalYear = new Date(date.getFullYear(), date.getMonth() + 1, 0);
                            console.log('Awards:: last date FY: '+endDateOfFiscalYear);
                            var monthsRemaining = 0;
                            //calculate time difference  
                            var time_difference = endDateOfFiscalYear.getTime() - d.getTime();  
                            
                            //calculate days difference by dividing total milliseconds in a day  
                            var days_difference = time_difference / (1000 * 60 * 60 * 24);
                            monthsRemaining = (days_difference/365)*12;
                            var businessImpact = ((recentAwardsProdAdditionList[i].Phoenix_Proposed_ASP_Dose__c * recentAwardsProdAdditionList[i].Phoenix_Awarded_Quantity__c) * monthsRemaining)/12;
                            recentAwardsProdAdditionList[i].businessImpact = businessImpact;
                            totalAwardedVolume += recentAwardsProdAdditionList[i].Phoenix_Awarded_Quantity__c;
                            totalAwardedAnnualValue += recentAwardsProdAdditionList[i].Phoenix_Awarded_Quantity__c * recentAwardsProdAdditionList[i].Phoenix_Proposed_ASP_Dose__c;
                            totalAnnualImpact += recentAwardsProdAdditionList[i].Phoenix_Awarded_Quantity__c * recentAwardsProdAdditionList[i].Phoenix_Proposed_ASP_Dose__c;
                            
                            if(isNaN(businessImpact)){
                                totalBusinessImpact += 0;
                                totalBusinessImpactPA += 0;   
                            } else{
                                totalBusinessImpact += businessImpact;
                                totalBusinessImpactPA += businessImpact;
                            }
                            recentAwardsProdAdditionList[i].monthsRemaining = monthsRemaining;
                            recentAwardsProdAdditionList[i].formattedEffectiveDate = new Date(recentAwardsProdAdditionList[i].Customer_Response_Lines__r[0].Phoenix_Price_Effective_Date__c).toLocaleDateString("en-US", { year: "numeric", month: "2-digit", day: "2-digit" });                       
                            recentAwardsProdAdditionList[i].showItem = false;
                            dataList.push(recentAwardsProdAdditionList[i]);
                        }
                    } 
                    dataObj.family = familiesPA[f];
                    dataObj.dataList = dataList;
                    dataObj.totalAwardedVolume = totalAwardedVolume;
                    dataObj.totalAwardedAnnualValue = totalAwardedAnnualValue;
                    dataObj.totalAnnualImpact = totalAnnualImpact;
                    dataObj.totalBusinessImpact = totalBusinessImpact;
                    recentAwardsProdAdditionListUpdated.push(dataObj);
                }
                var familiesNPL = Object.keys(totalRes.mapRecentAwardsNPLList);
                for(var f=0; f<familiesNPL.length; f++){
                    var dataObj = {};
                    var dataList = [];
                    var totalAwardedVolume = 0;
                    var totalAwardedAnnualValue = 0;
                    var totalAnnualImpact = 0;
                    var totalBusinessImpact = 0;
                    for(var i=0; i<recentAwardsNewPLList.length; i++){
                        if(recentAwardsNewPLList[i].Phoenix_Product__r.Family == familiesNPL[f] && recentAwardsNewPLList[i].Customer_Response_Lines__r && recentAwardsNewPLList[i].Customer_Response_Lines__r[0].Phoenix_Price_Effective_Date__c){
                            var d = new Date(recentAwardsNewPLList[i].Customer_Response_Lines__r[0].Phoenix_Price_Effective_Date__c);
                            var todayDate =  new Date();
                            var currentMonthString = months[todayDate.getMonth()];
                            console.log('Current Month Awards PA: '+currentMonthString);
                            var remainingMnths = 0;
                            var endFY;
                            if(Q1.includes(currentMonthString)){
                                var diff = 0;
                                for(var j=0; j<Q1.length; j++){
                                    if(Q1[j] == currentMonthString){
                                        diff = Q1.length-1 - j;
                                    }
                                }
                                remainingMnths = remainingMnths + diff + 9;
                            } else if (Q2.includes(currentMonthString)){
                                var diff = 0;
                                for(var j=0; j<Q2.length; j++){
                                    if(Q2[j] == currentMonthString){
                                        diff = Q2.length-1 - j;
                                    }
                                }
                                remainingMnths = remainingMnths + diff + 6;
                            } else if (Q3.includes(currentMonthString)){
                                var diff = 0;
                                for(var j=0; j<Q3.length; j++){
                                    if(Q3[j] == currentMonthString){
                                        diff = Q3.length-1 - j;
                                    }
                                }
                                remainingMnths = remainingMnths + diff + 3;
                            } else if (Q4.includes(currentMonthString)){
                                var diff = 0;
                                for(var j=0; j<Q4.length; j++){
                                    if(Q4[j] == currentMonthString){
                                        diff = Q4.length-1 - j;
                                    }
                                }
                                remainingMnths = remainingMnths + diff + 0;
                            } 
                            console.log('remainingMnths Awards PA: '+remainingMnths);
                            var endDate = new Date();
                            var date = new Date(endDate.setMonth(remainingMnths+1));
                            var endDateOfFiscalYear = new Date(date.getFullYear(), date.getMonth() + 1, 0);
                            console.log('Awards:: last date FY: '+endDateOfFiscalYear);
                            var monthsRemaining = 0;
                            //calculate time difference  
                            var time_difference = endDateOfFiscalYear.getTime() - d.getTime();  
                            
                            //calculate days difference by dividing total milliseconds in a day  
                            var days_difference = time_difference / (1000 * 60 * 60 * 24);
                            monthsRemaining = (days_difference/365)*12;
                            var businessImpact = ((recentAwardsNewPLList[i].Phoenix_Proposed_ASP_Dose__c * recentAwardsNewPLList[i].Phoenix_Awarded_Quantity__c) * monthsRemaining)/12;
                            recentAwardsProdAdditionList[i].businessImpact = businessImpact;
                            totalAwardedVolume += recentAwardsNewPLList[i].Phoenix_Awarded_Quantity__c;
                            totalAwardedAnnualValue += recentAwardsNewPLList[i].Phoenix_Awarded_Quantity__c * recentAwardsNewPLList[i].Phoenix_Proposed_ASP_Dose__c;
                            totalAnnualImpact += recentAwardsNewPLList[i].Phoenix_Awarded_Quantity__c * recentAwardsNewPLList[i].Phoenix_Proposed_ASP_Dose__c;
                            
                            if(isNaN(businessImpact)){
                                totalBusinessImpact += 0;
                                totalBusinessImpactNPL += 0;   
                            } else{
                                totalBusinessImpact += businessImpact;
                                totalBusinessImpactNPL += businessImpact;
                            }
                            recentAwardsNewPLList[i].monthsRemaining = monthsRemaining;
                            recentAwardsNewPLList[i].formattedEffectiveDate = new Date(recentAwardsNewPLList[i].Customer_Response_Lines__r[0].Phoenix_Price_Effective_Date__c).toLocaleDateString("en-US", { year: "numeric", month: "2-digit", day: "2-digit" });                       
                            recentAwardsNewPLList[i].showItem = false;
                            dataList.push(recentAwardsNewPLList[i]);
                        }
                    } 
                    dataObj.family = familiesNPL[f];
                    dataObj.dataList = dataList;
                    dataObj.totalAwardedVolume = totalAwardedVolume;
                    dataObj.totalAwardedAnnualValue = totalAwardedAnnualValue;
                    dataObj.totalAnnualImpact = totalAnnualImpact;
                    dataObj.totalBusinessImpact = totalBusinessImpact;
                    recentAwardsNewPLListUpdated.push(dataObj);
                }  
               
                var familiesRFP = Object.keys(totalRes.mapRecentAwardsRFPList);
                for(var f=0; f<familiesRFP.length; f++){
                    var dataObj = {};
                    var dataList = [];
                    var totalAwardedVolume = 0;
                    var totalAwardedAnnualValue = 0;
                    var totalAnnualImpact = 0;
                    var totalBusinessImpact = 0;
                    for(var i=0; i<recentAwardsRFPList.length; i++){
                        if(recentAwardsRFPList[i].Phoenix_Product__r.Family == familiesRFP[f] && recentAwardsRFPList[i].Customer_Response_Lines__r && recentAwardsRFPList[i].Customer_Response_Lines__r[0].Phoenix_Price_Effective_Date__c){
                            var d = new Date(recentAwardsRFPList[i].Customer_Response_Lines__r[0].Phoenix_Price_Effective_Date__c);
                            var todayDate =  new Date();
                            var currentMonthString = months[todayDate.getMonth()];
                            console.log('Current Month Awards PA: '+currentMonthString);
                            var remainingMnths = 0;
                            var endFY;
                            if(Q1.includes(currentMonthString)){
                                var diff = 0;
                                for(var j=0; j<Q1.length; j++){
                                    if(Q1[j] == currentMonthString){
                                        diff = Q1.length-1 - j;
                                    }
                                }
                                remainingMnths = remainingMnths + diff + 9;
                            } else if (Q2.includes(currentMonthString)){
                                var diff = 0;
                                for(var j=0; j<Q2.length; j++){
                                    if(Q2[j] == currentMonthString){
                                        diff = Q2.length-1 - j;
                                    }
                                }
                                remainingMnths = remainingMnths + diff + 6;
                            } else if (Q3.includes(currentMonthString)){
                                var diff = 0;
                                for(var j=0; j<Q3.length; j++){
                                    if(Q3[j] == currentMonthString){
                                        diff = Q3.length-1 - j;
                                    }
                                }
                                remainingMnths = remainingMnths + diff + 3;
                            } else if (Q4.includes(currentMonthString)){
                                var diff = 0;
                                for(var j=0; j<Q4.length; j++){
                                    if(Q4[j] == currentMonthString){
                                        diff = Q4.length-1 - j;
                                    }
                                }
                                remainingMnths = remainingMnths + diff + 0;
                            } 
                            console.log('remainingMnths Awards PA: '+remainingMnths);
                            var endDate = new Date();
                            var date = new Date(endDate.setMonth(remainingMnths+1));
                            var endDateOfFiscalYear = new Date(date.getFullYear(), date.getMonth() + 1, 0);
                            console.log('Awards:: last date FY: '+endDateOfFiscalYear);
                            var monthsRemaining = 0;
                            //calculate time difference  
                            var time_difference = endDateOfFiscalYear.getTime() - d.getTime();  
                            
                            //calculate days difference by dividing total milliseconds in a day  
                            var days_difference = time_difference / (1000 * 60 * 60 * 24);
                            monthsRemaining = (days_difference/365)*12;
                            var businessImpact = ((recentAwardsRFPList[i].Phoenix_Proposed_ASP_Dose__c * recentAwardsRFPList[i].Phoenix_Awarded_Quantity__c) * monthsRemaining)/12;
                            recentAwardsRFPList[i].businessImpact = businessImpact;
                            totalAwardedVolume += recentAwardsRFPList[i].Phoenix_Awarded_Quantity__c;
                            totalAwardedAnnualValue += recentAwardsRFPList[i].Phoenix_Awarded_Quantity__c * recentAwardsRFPList[i].Phoenix_Proposed_ASP_Dose__c;
                            totalAnnualImpact += recentAwardsRFPList[i].Phoenix_Awarded_Quantity__c * recentAwardsRFPList[i].Phoenix_Proposed_ASP_Dose__c;
                            
                            if(isNaN(businessImpact)){
                                totalBusinessImpact += 0;
                                totalBusinessImpactRFP += 0;   
                            } else{
                                totalBusinessImpact += businessImpact;
                                totalBusinessImpactRFP += businessImpact;
                            }
                            recentAwardsRFPList[i].monthsRemaining = monthsRemaining;
                            recentAwardsRFPList[i].formattedEffectiveDate = new Date(recentAwardsRFPList[i].Customer_Response_Lines__r[0].Phoenix_Price_Effective_Date__c).toLocaleDateString("en-US", { year: "numeric", month: "2-digit", day: "2-digit" });                       
                            recentAwardsRFPList[i].showItem = false;
                            dataList.push(recentAwardsRFPList[i]);
                        }
                    } 
                    dataObj.family = familiesRFP[f];
                    dataObj.dataList = dataList;
                    dataObj.totalAwardedVolume = totalAwardedVolume;
                    dataObj.totalAwardedAnnualValue = totalAwardedAnnualValue;
                    dataObj.totalAnnualImpact = totalAnnualImpact;
                    dataObj.totalBusinessImpact = totalBusinessImpact;
                    recentAwardsRFPListUpdated.push(dataObj);
                }
                var familiesNC = Object.keys(totalRes.mapRecentAwardsNCList);
                for(var f=0; f<familiesNC.length; f++){
                    var dataObj = {};
                    var dataList = [];
                    var totalAwardedVolume = 0;
                    var totalAwardedAnnualValue = 0;
                    var totalAnnualImpact = 0;
                    var totalBusinessImpact = 0;
                    for(var i=0; i<recentAwardsNewCustomerList.length; i++){
                        if(recentAwardsNewCustomerList[i].Phoenix_Product__r.Family == familiesNC[f] && recentAwardsNewCustomerList[i].Customer_Response_Lines__r && recentAwardsNewCustomerList[i].Customer_Response_Lines__r[0].Phoenix_Price_Effective_Date__c){
                            var d = new Date(recentAwardsNewCustomerList[i].Customer_Response_Lines__r[0].Phoenix_Price_Effective_Date__c);
                            var todayDate =  new Date();
                            var currentMonthString = months[todayDate.getMonth()];
                            console.log('Current Month Awards PA: '+currentMonthString);
                            var remainingMnths = 0;
                            var endFY;
                            if(Q1.includes(currentMonthString)){
                                var diff = 0;
                                for(var j=0; j<Q1.length; j++){
                                    if(Q1[j] == currentMonthString){
                                        diff = Q1.length-1 - j;
                                    }
                                }
                                remainingMnths = remainingMnths + diff + 9;
                            } else if (Q2.includes(currentMonthString)){
                                var diff = 0;
                                for(var j=0; j<Q2.length; j++){
                                    if(Q2[j] == currentMonthString){
                                        diff = Q2.length-1 - j;
                                    }
                                }
                                remainingMnths = remainingMnths + diff + 6;
                            } else if (Q3.includes(currentMonthString)){
                                var diff = 0;
                                for(var j=0; j<Q3.length; j++){
                                    if(Q3[j] == currentMonthString){
                                        diff = Q3.length-1 - j;
                                    }
                                }
                                remainingMnths = remainingMnths + diff + 3;
                            } else if (Q4.includes(currentMonthString)){
                                var diff = 0;
                                for(var j=0; j<Q4.length; j++){
                                    if(Q4[j] == currentMonthString){
                                        diff = Q4.length-1 - j;
                                    }
                                }
                                remainingMnths = remainingMnths + diff + 0;
                            } 
                            console.log('remainingMnths Awards PA: '+remainingMnths);
                            var endDate = new Date();
                            var date = new Date(endDate.setMonth(remainingMnths+1));
                            var endDateOfFiscalYear = new Date(date.getFullYear(), date.getMonth() + 1, 0);
                            console.log('Awards:: last date FY: '+endDateOfFiscalYear);
                            var monthsRemaining = 0;
                            //calculate time difference  
                            var time_difference = endDateOfFiscalYear.getTime() - d.getTime();  
                            
                            //calculate days difference by dividing total milliseconds in a day  
                            var days_difference = time_difference / (1000 * 60 * 60 * 24);
                            monthsRemaining = (days_difference/365)*12;
                            var businessImpact = ((recentAwardsNewCustomerList[i].Phoenix_Proposed_ASP_Dose__c * recentAwardsNewCustomerList[i].Phoenix_Awarded_Quantity__c) * monthsRemaining)/12;
                            recentAwardsNewCustomerList[i].businessImpact = businessImpact;
                            totalAwardedVolume += recentAwardsNewCustomerList[i].Phoenix_Awarded_Quantity__c;
                            totalAwardedAnnualValue += recentAwardsNewCustomerList[i].Phoenix_Awarded_Quantity__c * recentAwardsNewCustomerList[i].Phoenix_Proposed_ASP_Dose__c;
                            totalAnnualImpact += recentAwardsNewCustomerList[i].Phoenix_Awarded_Quantity__c * recentAwardsNewCustomerList[i].Phoenix_Proposed_ASP_Dose__c;
                            
                            if(isNaN(businessImpact)){
                                totalBusinessImpact += 0;
                                totalBusinessImpactNC += 0;   
                            } else{
                                totalBusinessImpact += businessImpact;
                                totalBusinessImpactNC += businessImpact;
                            }
                            recentAwardsNewCustomerList[i].monthsRemaining = monthsRemaining;
                            recentAwardsNewCustomerList[i].formattedEffectiveDate = new Date(recentAwardsNewCustomerList[i].Customer_Response_Lines__r[0].Phoenix_Price_Effective_Date__c).toLocaleDateString("en-US", { year: "numeric", month: "2-digit", day: "2-digit" });                       
                            recentAwardsNewCustomerList[i].showItem = false;
                            dataList.push(recentAwardsNewCustomerList[i]);
                        }
                    } 
                    dataObj.family = familiesNC[f];
                    dataObj.dataList = dataList;
                    dataObj.totalAwardedVolume = totalAwardedVolume;
                    dataObj.totalAwardedAnnualValue = totalAwardedAnnualValue;
                    dataObj.totalAnnualImpact = totalAnnualImpact;
                    dataObj.totalBusinessImpact = totalBusinessImpact;
                    recentAwardsNewCustomerListUpdated.push(dataObj);
                }
                /*Need to change this as per Awards logic*/
                
                
                
                var familiesRFPDecreases = Object.keys(totalRes.mapDecreasesRFPList);
                for(var f=0; f<familiesRFPDecreases.length; f++){
                    var dataObj = {};
                    var dataList = [];
                    var totalAwardedVolume = 0;
                    var totalPreviousVolume = 0;
                    var totalAwardedAnnualValue = 0;
                    var totalAnnualImpact = 0;
                    var totalBusinessImpact = 0;
                    for(var i=0; i<decreasesRFPList.length; i++){
                        if(decreasesRFPList[i].Phoenix_Product__r.Family == familiesRFPDecreases[f] && decreasesRFPList[i].Customer_Response_Lines__r){
                            var d = new Date(decreasesRFPList[i].Customer_Response_Lines__r[0].Phoenix_Price_Effective_Date__c);
                            var todayDate =  new Date();
                            var currentMonthString = months[todayDate.getMonth()];
                            console.log('Current Month Awards PA: '+currentMonthString);
                            var remainingMnths = 0;
                            var endFY;
                            if(Q1.includes(currentMonthString)){
                                var diff = 0;
                                for(var j=0; j<Q1.length; j++){
                                    if(Q1[j] == currentMonthString){
                                        diff = Q1.length-1 - j;
                                    }
                                }
                                remainingMnths = remainingMnths + diff + 9;
                            } else if (Q2.includes(currentMonthString)){
                                var diff = 0;
                                for(var j=0; j<Q2.length; j++){
                                    if(Q2[j] == currentMonthString){
                                        diff = Q2.length-1 - j;
                                    }
                                }
                                remainingMnths = remainingMnths + diff + 6;
                            } else if (Q3.includes(currentMonthString)){
                                var diff = 0;
                                for(var j=0; j<Q3.length; j++){
                                    if(Q3[j] == currentMonthString){
                                        diff = Q3.length-1 - j;
                                    }
                                }
                                remainingMnths = remainingMnths + diff + 3;
                            } else if (Q4.includes(currentMonthString)){
                                var diff = 0;
                                for(var j=0; j<Q4.length; j++){
                                    if(Q4[j] == currentMonthString){
                                        diff = Q4.length-1 - j;
                                    }
                                }
                                remainingMnths = remainingMnths + diff + 0;
                            } 
                            console.log('remainingMnths Awards PA: '+remainingMnths);
                            var endDate = new Date();
                            var date = new Date(endDate.setMonth(remainingMnths+1));
                            var endDateOfFiscalYear = new Date(date.getFullYear(), date.getMonth() + 1, 0);
                            console.log('Awards:: last date FY: '+endDateOfFiscalYear);
                            var monthsRemaining = 0;
                            //calculate time difference  
                            var time_difference = endDateOfFiscalYear.getTime() - d.getTime();  
                            
                            //calculate days difference by dividing total milliseconds in a day  
                            var days_difference = time_difference / (1000 * 60 * 60 * 24);
                            monthsRemaining = (days_difference/365)*12;
                            var annualImpact = ((decreasesRFPList[i].Phoenix_Awarded_Quantity__c * decreasesRFPList[i].Phoenix_Proposed_ASP_Dose__c)-(decreasesRFPList[i].Phoenix_Total_Selling_Unit__c * decreasesRFPList[i].Phoenix_Current_ASP_Dose__c));
                            var businessImpact = (annualImpact * monthsRemaining)/12;
                            console.log('Annual Impact: '+annualImpact+' Business Impact: '+businessImpact);
                            decreasesRFPList[i].businessImpact = businessImpact;
                            decreasesRFPList[i].annualImpact = annualImpact;
                            /*decreasesRFPList[i].businessImpact = new Intl.NumberFormat(undefined, { 
                                style: 'currency', 
                                currency: 'USD',
                                maximumFractionDigits: 0, 
                                minimumFractionDigits: 0, 
                            }).format(businessImpact);
                            decreasesRFPList[i].annualImpact = new Intl.NumberFormat(undefined, { 
                                style: 'currency', 
                                currency: 'USD',
                                maximumFractionDigits: 0, 
                                minimumFractionDigits: 0, 
                            }).format(annualImpact);*/
                            totalAwardedVolume += decreasesRFPList[i].Phoenix_Awarded_Quantity__c;
                            totalPreviousVolume += decreasesRFPList[i].Phoenix_Total_Selling_Unit__c;;
                            totalAwardedAnnualValue += decreasesRFPList[i].Phoenix_Awarded_Quantity__c * decreasesRFPList[i].Phoenix_Proposed_ASP_Dose__c;
                            totalAnnualImpact += annualImpact;
                            if(businessImpact >= 0){
                                decreasesRFPList[i].businessImpactPositive = true;
                                if(isNaN(businessImpact)){
                                    decreasesRFPList[i].businessImpact = 0;
                                    totalBusinessImpact += 0;
                                    totalBusinessImpactRFPDecreaseGain += 0;   
                                } else{
                                    totalBusinessImpact += businessImpact;
                                    totalBusinessImpactRFPDecreaseGain += businessImpact;
                                }
                            } else{
                                decreasesRFPList[i].businessImpactPositive = false;
                                if(isNaN(businessImpact)){
                                    decreasesRFPList[i].businessImpact = 0;
                                    totalBusinessImpact += 0;
                                    totalBusinessImpactRFPDecrease += 0;   
                                } else{
                                    totalBusinessImpact += businessImpact;
                                    totalBusinessImpactRFPDecrease += businessImpact;
                                }
                            }
                            if(isNaN(annualImpact)){
                                decreasesRFPList[i].annualImpact = 0;
                            }
                            decreasesRFPList[i].monthsRemaining = monthsRemaining;
                            decreasesRFPList[i].formattedEffectiveDate = new Date(decreasesRFPList[i].Customer_Response_Lines__r[0].Phoenix_Price_Effective_Date__c).toLocaleDateString("en-US", { year: "numeric", month: "2-digit", day: "2-digit" });                       
                            decreasesRFPList[i].showItem = false;
                            dataList.push(decreasesRFPList[i]);
                        }
                    } 
                    dataObj.family = familiesRFPDecreases[f];
                    dataObj.dataList = dataList;
                    dataObj.totalAwardedVolume = totalAwardedVolume;
                    dataObj.totalAwardedAnnualValue = totalAwardedAnnualValue;
                    /*dataObj.totalAnnualImpact = new Intl.NumberFormat(undefined, { 
                        style: 'currency', 
                        currency: 'USD',
                        maximumFractionDigits: 0, 
                        minimumFractionDigits: 0, 
                    }).format(totalAnnualImpact);
                    dataObj.totalBusinessImpact = new Intl.NumberFormat(undefined, { 
                        style: 'currency', 
                        currency: 'USD',
                        maximumFractionDigits: 0, 
                        minimumFractionDigits: 0, 
                    }).format(totalBusinessImpact);*/
                    dataObj.totalAnnualImpact = totalAnnualImpact;
                    dataObj.totalBusinessImpact = totalBusinessImpact;
                    console.log('RFP Total Annual Impact: '+totalAnnualImpact);
                    dataObj.totalPreviousVolume = totalPreviousVolume;
                    if(totalAnnualImpact > 0){
                        console.log('totalAnnualImpact Greater than 0: '+totalAnnualImpact);
                        dataObj.positiveAI = true;
                    } else{
                        dataObj.positiveAI = false;
                        console.log('totalAnnualImpact Less than 0: '+totalAnnualImpact);
                    }
                    if(totalBusinessImpact > 0){
                        console.log('totalBusinessImpact Greater than 0: '+totalBusinessImpact);
                        dataObj.positiveBI = true;
                        decreasesGainRFPListUpdated.push(dataObj);
                    } else{
                        dataObj.positiveBI = false;
                        console.log('totalBusinessImpact Less than 0: '+totalBusinessImpact);
                        decreasesRFPListUpdated.push(dataObj);
                    }
                }
                
                /*for(var i=0; i<decreasesRFPList.length; i++){
                    if(decreasesRFPList[i].Customer_Response_Lines__r && decreasesRFPList[i].Phoenix_Total_Selling_Unit__c != 0){
                        var d = new Date(decreasesRFPList[i].Customer_Response_Lines__r[0].Phoenix_Price_Effective_Date__c);
                        var monthString = months[d.getMonth()];
                        var monthsRemaining = 0;
                        var endDateOfFiscalYear;
                        if(Q1.includes(monthString)){
                            var diff = 0;
                            for(var j=0; j<Q1.length; j++){
                                if(Q1[j] == monthString){
                                    diff = Q1.length-1 - j;
                                }
                            }
                            monthsRemaining = monthsRemaining + diff + 9;
                            var endDate = new Date();
                            endDateOfFiscalYear = new Date(endDate.getFullYear(), endDate.getMonth() + 1, 0);
                            endDateOfFiscalYear.setMonth(monthsRemaining-1);
                        } else if (Q2.includes(monthString)){
                            var diff = 0;
                            for(var j=0; j<Q2.length; j++){
                                if(Q2[j] == monthString){
                                    diff = Q2.length-1 - j;
                                }
                            }
                            monthsRemaining = monthsRemaining + diff + 6;
                            var endDate = new Date();
                            endDateOfFiscalYear = new Date(endDate.getFullYear(), endDate.getMonth() + 1, 0);
                            endDateOfFiscalYear.setMonth(monthsRemaining-1);
                        } else if (Q3.includes(monthString)){
                            var diff = 0;
                            for(var j=0; j<Q3.length; j++){
                                if(Q3[j] == monthString){
                                    diff = Q3.length-1 - j;
                                }
                            }
                            monthsRemaining = monthsRemaining + diff + 3;
                            var endDate = new Date();
                            endDateOfFiscalYear = new Date(endDate.getFullYear(), endDate.getMonth() + 1, 0);
                            endDateOfFiscalYear.setMonth(monthsRemaining-1);
                        } else if (Q4.includes(monthString)){
                            var diff = 0;
                            for(var j=0; j<Q4.length; j++){
                                if(Q4[j] == monthString){
                                    diff = Q4.length-1 - j;
                                }
                            }
                            monthsRemaining = monthsRemaining + diff + 0;
                            var endDate = new Date();
                            endDateOfFiscalYear = new Date(endDate.getFullYear(), endDate.getMonth() + 1, 0);
                            endDateOfFiscalYear.setMonth(monthsRemaining-1);
                        } 
                        //calculate time difference  
                        var time_difference = endDateOfFiscalYear.getTime() - d.getTime();  
                        
                        //calculate days difference by dividing total milliseconds in a day  
                        var days_difference = time_difference / (1000 * 60 * 60 * 24);
                        monthsRemaining = (days_difference/365)*12;
                        var annualImpact = ((decreasesRFPList[i].Phoenix_Awarded_Quantity__c * decreasesRFPList[i].Phoenix_Proposed_ASP_Dose__c)-(decreasesRFPList[i].Phoenix_Total_Selling_Unit__c * decreasesRFPList[i].Phoenix_Current_ASP_Dose__c));
                        var businessImpact = (annualImpact * monthsRemaining)/12;
                        if(businessImpact >= 0){
                            decreasesRFPList[i].businessImpactPositive = true;    
                        } else{
                            decreasesRFPList[i].businessImpactPositive = false;
                        }
                        
                        decreasesRFPList[i].businessImpact = businessImpact;
                        if(isNaN(businessImpact)){
                            totalBusinessImpactRFPDecrease += 0;   
                        } else{
                            totalBusinessImpactRFPDecrease += businessImpact;
                        }
                        decreasesRFPList[i].monthsRemaining = monthsRemaining;
                        decreasesRFPList[i].formattedEffectiveDate = new Date(decreasesRFPList[i].Customer_Response_Lines__r[0].Phoenix_Price_Effective_Date__c).toLocaleDateString("en-US", { year: "numeric", month: "2-digit", day: "2-digit" });                       
                        decreasesRFPListUpdated.push(decreasesRFPList[i]);
                    }
                }*/
                
                var familiesPCDecreases = Object.keys(totalRes.mapDecreasesPCList);
                for(var f=0; f<familiesPCDecreases.length; f++){
                    var dataObj = {};
                    var dataList = [];
                    var totalAwardedVolume = 0;
                    var totalAwardedAnnualValue = 0;
                    var totalAnnualImpact = 0;
                    var totalBusinessImpact = 0;
                    for(var i=0; i<decreasesPriceChangeList.length; i++){
                        if(decreasesPriceChangeList[i].Phoenix_Product__r.Family == familiesPCDecreases[f] && decreasesPriceChangeList[i].Customer_Response_Lines__r){
                            var d = new Date(decreasesPriceChangeList[i].Customer_Response_Lines__r[0].Phoenix_Price_Effective_Date__c);
                            var todayDate =  new Date();
                            var currentMonthString = months[todayDate.getMonth()];
                            console.log('Current Month Awards PA: '+currentMonthString);
                            var remainingMnths = 0;
                            var endFY;
                            if(Q1.includes(currentMonthString)){
                                var diff = 0;
                                for(var j=0; j<Q1.length; j++){
                                    if(Q1[j] == currentMonthString){
                                        diff = Q1.length-1 - j;
                                    }
                                }
                                remainingMnths = remainingMnths + diff + 9;
                            } else if (Q2.includes(currentMonthString)){
                                var diff = 0;
                                for(var j=0; j<Q2.length; j++){
                                    if(Q2[j] == currentMonthString){
                                        diff = Q2.length-1 - j;
                                    }
                                }
                                remainingMnths = remainingMnths + diff + 6;
                            } else if (Q3.includes(currentMonthString)){
                                var diff = 0;
                                for(var j=0; j<Q3.length; j++){
                                    if(Q3[j] == currentMonthString){
                                        diff = Q3.length-1 - j;
                                    }
                                }
                                remainingMnths = remainingMnths + diff + 3;
                            } else if (Q4.includes(currentMonthString)){
                                var diff = 0;
                                for(var j=0; j<Q4.length; j++){
                                    if(Q4[j] == currentMonthString){
                                        diff = Q4.length-1 - j;
                                    }
                                }
                                remainingMnths = remainingMnths + diff + 0;
                            } 
                            console.log('remainingMnths Awards PA: '+remainingMnths);
                            var endDate = new Date();
                            var date = new Date(endDate.setMonth(remainingMnths+1));
                            var endDateOfFiscalYear = new Date(date.getFullYear(), date.getMonth() + 1, 0);
                            console.log('Awards:: last date FY: '+endDateOfFiscalYear);
                            var monthsRemaining = 0;
                            //calculate time difference  
                            var time_difference = endDateOfFiscalYear.getTime() - d.getTime();  
                            
                            //calculate days difference by dividing total milliseconds in a day  
                            var days_difference = time_difference / (1000 * 60 * 60 * 24);
                            monthsRemaining = (days_difference/365)*12;
                            var annualImpact = (decreasesPriceChangeList[i].Phoenix_Proposed_ASP_Dose__c - decreasesPriceChangeList[i].Phoenix_Current_ASP_Dose__c)*decreasesPriceChangeList[i].Phoenix_Awarded_Quantity__c;
                            var businessImpact = (annualImpact * monthsRemaining)/12;
                            decreasesPriceChangeList[i].businessImpact = businessImpact;
                            decreasesPriceChangeList[i].annualImpact = annualImpact;
                            /*decreasesPriceChangeList[i].businessImpact = new Intl.NumberFormat(undefined, { 
                                style: 'currency', 
                                currency: 'USD',
                                maximumFractionDigits: 0, 
                                minimumFractionDigits: 0, 
                            }).format(businessImpact);
                            decreasesPriceChangeList[i].annualImpact = new Intl.NumberFormat(undefined, { 
                                style: 'currency', 
                                currency: 'USD',
                                maximumFractionDigits: 0, 
                                minimumFractionDigits: 0, 
                            }).format(annualImpact);*/
                            totalAwardedVolume += decreasesPriceChangeList[i].Phoenix_Awarded_Quantity__c;
                            totalAwardedAnnualValue += decreasesPriceChangeList[i].Phoenix_Awarded_Quantity__c * decreasesPriceChangeList[i].Phoenix_Proposed_ASP_Dose__c;
                            totalAnnualImpact += annualImpact;
                            if(businessImpact >= 0){
                                decreasesPriceChangeList[i].businessImpactPositive = true;    
                                if(isNaN(businessImpact)){
                                    decreasesPriceChangeList[i].businessImpact = 0;
                                    totalBusinessImpact += 0;
                                    totalBusinessImpactPCDecreaseGain += 0;   
                                } else{
                                    totalBusinessImpact += businessImpact;
                                    totalBusinessImpactPCDecreaseGain += businessImpact;
                                }
                            } else{
                                decreasesPriceChangeList[i].businessImpactPositive = false;
                                if(isNaN(businessImpact)){
                                    decreasesPriceChangeList[i].businessImpact = 0;
                                    totalBusinessImpact += 0;
                                    totalBusinessImpactPCDecrease += 0;   
                                } else{
                                    totalBusinessImpact += businessImpact;
                                    totalBusinessImpactPCDecrease += businessImpact;
                                }
                            }
                            if(isNaN(annualImpact)){
                                decreasesPriceChangeList[i].annualImpact = 0;
                            }
                            decreasesPriceChangeList[i].monthsRemaining = monthsRemaining;
                            decreasesPriceChangeList[i].formattedEffectiveDate = new Date(decreasesPriceChangeList[i].Customer_Response_Lines__r[0].Phoenix_Price_Effective_Date__c).toLocaleDateString("en-US", { year: "numeric", month: "2-digit", day: "2-digit" });                       
                            decreasesPriceChangeList[i].showItem = false;
                            dataList.push(decreasesPriceChangeList[i]);
                        }
                    } 
                    dataObj.family = familiesPCDecreases[f];
                    dataObj.dataList = dataList;
                    dataObj.totalAwardedVolume = totalAwardedVolume;
                    dataObj.totalAwardedAnnualValue = totalAwardedAnnualValue;
                    dataObj.totalAnnualImpact = totalAnnualImpact;
                    dataObj.totalBusinessImpact = totalBusinessImpact;
                    /*dataObj.totalAnnualImpact = new Intl.NumberFormat(undefined, { 
                        style: 'currency', 
                        currency: 'USD',
                        maximumFractionDigits: 0, 
                        minimumFractionDigits: 0, 
                    }).format(totalAnnualImpact);
                    dataObj.totalBusinessImpact = new Intl.NumberFormat(undefined, { 
                        style: 'currency', 
                        currency: 'USD',
                        maximumFractionDigits: 0, 
                        minimumFractionDigits: 0, 
                    }).format(totalBusinessImpact);*/
                    if(totalAnnualImpact > 0){
                        dataObj.positiveAI = true;
                    } else{
                        dataObj.positiveAI = false;
                    }
                    if(totalBusinessImpact > 0){
                        dataObj.positiveBI = true;
                        decreasesGainPriceChangeListUpdated.push(dataObj);
                    } else{
                        dataObj.positiveBI = false;
                        decreasesPriceChangeListUpdated.push(dataObj);
                    }
                }
                
                
                var familiesVRODecreases = Object.keys(totalRes.mapDecreasesVROList);
                for(var f=0; f<familiesVRODecreases.length; f++){
                    var dataObj = {};
                    var dataList = [];
                    var totalAwardedVolume = 0;
                    var totalAwardedAnnualValue = 0;
                    var totalAnnualImpact = 0;
                    var totalBusinessImpact = 0;
                    for(var i=0; i<decreasesvolumeReviewList.length; i++){
                        if(decreasesvolumeReviewList[i].Phoenix_Product__r.Family == familiesVRODecreases[f] && decreasesvolumeReviewList[i].Customer_Response_Lines__r){
                            var d = new Date(decreasesvolumeReviewList[i].Customer_Response_Lines__r[0].Phoenix_Customer_Response_Date__c);
                            var todayDate =  new Date();
                            var currentMonthString = months[todayDate.getMonth()];
                            console.log('Current Month Awards PA: '+currentMonthString);
                            var remainingMnths = 0;
                            var endFY;
                            if(Q1.includes(currentMonthString)){
                                var diff = 0;
                                for(var j=0; j<Q1.length; j++){
                                    if(Q1[j] == currentMonthString){
                                        diff = Q1.length-1 - j;
                                    }
                                }
                                remainingMnths = remainingMnths + diff + 9;
                            } else if (Q2.includes(currentMonthString)){
                                var diff = 0;
                                for(var j=0; j<Q2.length; j++){
                                    if(Q2[j] == currentMonthString){
                                        diff = Q2.length-1 - j;
                                    }
                                }
                                remainingMnths = remainingMnths + diff + 6;
                            } else if (Q3.includes(currentMonthString)){
                                var diff = 0;
                                for(var j=0; j<Q3.length; j++){
                                    if(Q3[j] == currentMonthString){
                                        diff = Q3.length-1 - j;
                                    }
                                }
                                remainingMnths = remainingMnths + diff + 3;
                            } else if (Q4.includes(currentMonthString)){
                                var diff = 0;
                                for(var j=0; j<Q4.length; j++){
                                    if(Q4[j] == currentMonthString){
                                        diff = Q4.length-1 - j;
                                    }
                                }
                                remainingMnths = remainingMnths + diff + 0;
                            } 
                            console.log('remainingMnths Awards PA: '+remainingMnths);
                            var endDate = new Date();
                            var date = new Date(endDate.setMonth(remainingMnths+1));
                            var endDateOfFiscalYear = new Date(date.getFullYear(), date.getMonth() + 1, 0);
                            console.log('Awards:: last date FY: '+endDateOfFiscalYear);
                            var monthsRemaining = 0;
                            //calculate time difference  
                            var time_difference = endDateOfFiscalYear.getTime() - d.getTime();  
                            
                            //calculate days difference by dividing total milliseconds in a day  
                            var days_difference = time_difference / (1000 * 60 * 60 * 24);
                            monthsRemaining = (days_difference/365)*12;
                            var annualImpact = (decreasesvolumeReviewList[i].Phoenix_Awarded_Quantity__c - decreasesvolumeReviewList[i].Phoenix_Total_Selling_Unit__c)*decreasesvolumeReviewList[i].Phoenix_Proposed_ASP_Dose__c;
                            var businessImpact = (annualImpact * monthsRemaining)/12;
                            decreasesvolumeReviewList[i].businessImpact = businessImpact;
                            decreasesvolumeReviewList[i].annualImpact = annualImpact;
                            /*decreasesvolumeReviewList[i].businessImpact = new Intl.NumberFormat(undefined, { 
                                style: 'currency', 
                                currency: 'USD',
                                maximumFractionDigits: 0, 
                                minimumFractionDigits: 0, 
                            }).format(businessImpact);
                            decreasesvolumeReviewList[i].annualImpact = new Intl.NumberFormat(undefined, { 
                                style: 'currency', 
                                currency: 'USD',
                                maximumFractionDigits: 0, 
                                minimumFractionDigits: 0, 
                            }).format(annualImpact);*/
                            totalAwardedVolume += decreasesvolumeReviewList[i].Phoenix_Awarded_Quantity__c;
                            totalAwardedAnnualValue += (decreasesvolumeReviewList[i].Phoenix_Awarded_Quantity__c * decreasesvolumeReviewList[i].Phoenix_Proposed_ASP_Dose__c);
                            totalAnnualImpact += annualImpact;
                            if(businessImpact >= 0){
                                decreasesvolumeReviewList[i].businessImpactPositive = true;    
                                if(isNaN(businessImpact)){
                                    decreasesvolumeReviewList[i].businessImpact = 0;
                                    totalBusinessImpact += 0;
                                    totalBusinessImpactVRDecreaseGain += 0;   
                                } else{
                                    totalBusinessImpact += businessImpact;
                                    totalBusinessImpactVRDecreaseGain += businessImpact;
                                }
                            } else{
                                decreasesvolumeReviewList[i].businessImpactPositive = false;
                                if(isNaN(businessImpact)){
                                    decreasesvolumeReviewList[i].businessImpact = 0;
                                    totalBusinessImpact += 0;
                                    totalBusinessImpactVRDecrease += 0;   
                                } else{
                                    totalBusinessImpact += businessImpact;
                                    totalBusinessImpactVRDecrease += businessImpact;
                                }
                            }
                            if(isNaN(annualImpact)){
                                decreasesvolumeReviewList[i].annualImpact = 0;
                            }
                            decreasesvolumeReviewList[i].monthsRemaining = monthsRemaining;
                            decreasesvolumeReviewList[i].formattedEffectiveDate = new Date(decreasesvolumeReviewList[i].Customer_Response_Lines__r[0].Phoenix_Price_Effective_Date__c).toLocaleDateString("en-US", { year: "numeric", month: "2-digit", day: "2-digit" });                       
                            decreasesvolumeReviewList[i].showItem = false;
                            dataList.push(decreasesvolumeReviewList[i]);
                        }
                    } 
                    dataObj.family = familiesVRODecreases[f];
                    dataObj.dataList = dataList;
                    dataObj.totalAwardedVolume = totalAwardedVolume;
                    dataObj.totalAwardedAnnualValue = totalAwardedAnnualValue;
                    console.log('Total Awarded Value: '+totalAwardedAnnualValue);
                    console.log('Total Awarded Value Data type: '+typeof totalAwardedAnnualValue);
                    dataObj.totalAnnualImpact = totalAnnualImpact;
                    dataObj.totalBusinessImpact = totalBusinessImpact;
                    /*dataObj.totalAnnualImpact = new Intl.NumberFormat(undefined, { 
                        style: 'currency', 
                        currency: 'USD',
                        maximumFractionDigits: 0, 
                        minimumFractionDigits: 0, 
                    }).format(totalAnnualImpact);
                    dataObj.totalBusinessImpact = new Intl.NumberFormat(undefined, { 
                        style: 'currency', 
                        currency: 'USD',
                        maximumFractionDigits: 0, 
                        minimumFractionDigits: 0, 
                    }).format(totalBusinessImpact);*/
                    if(totalAnnualImpact > 0){
                        dataObj.positiveAI = true;
                    } else{
                        dataObj.positiveAI = false;
                    }
                    if(totalBusinessImpact > 0){
                        dataObj.positiveBI = true;
                        decreasesGainvolumeReviewListUpdated.push(dataObj);
                    } else{
                        dataObj.positiveBI = false;
                        decreasesvolumeReviewListUpdated.push(dataObj);
                    }
                    console.log('Total Business Impact: '+totalBusinessImpact);
                    console.log('Total Business Impact Data type: '+typeof totalBusinessImpact);
                }
                
                
                var familiesMPRLoss = Object.keys(totalRes.mapLossesMPRList);
                for(var f=0; f<familiesMPRLoss.length; f++){
                    var dataObj = {};
                    var dataList = [];
                    var totalAwardedVolume = 0;
                    var totalAwardedAnnualValue = 0;
                    var totalAnnualImpact = 0;
                    var totalBusinessImpact = 0;
                    for(var i=0; i<productLossesMassProductRemovalList.length; i++){
                        if(productLossesMassProductRemovalList[i].Phoenix_Product__r.Family == familiesMPRLoss[f] && productLossesMassProductRemovalList[i].Customer_Response_Lines__r){
                            var d = new Date(productLossesMassProductRemovalList[i].Customer_Response_Lines__r[0].Phoenix_Customer_Response_Date__c);
                            var todayDate =  new Date();
                            var currentMonthString = months[todayDate.getMonth()];
                            console.log('Current Month Awards PA: '+currentMonthString);
                            var remainingMnths = 0;
                            var endFY;
                            if(Q1.includes(currentMonthString)){
                                var diff = 0;
                                for(var j=0; j<Q1.length; j++){
                                    if(Q1[j] == currentMonthString){
                                        diff = Q1.length-1 - j;
                                    }
                                }
                                remainingMnths = remainingMnths + diff + 9;
                            } else if (Q2.includes(currentMonthString)){
                                var diff = 0;
                                for(var j=0; j<Q2.length; j++){
                                    if(Q2[j] == currentMonthString){
                                        diff = Q2.length-1 - j;
                                    }
                                }
                                remainingMnths = remainingMnths + diff + 6;
                            } else if (Q3.includes(currentMonthString)){
                                var diff = 0;
                                for(var j=0; j<Q3.length; j++){
                                    if(Q3[j] == currentMonthString){
                                        diff = Q3.length-1 - j;
                                    }
                                }
                                remainingMnths = remainingMnths + diff + 3;
                            } else if (Q4.includes(currentMonthString)){
                                var diff = 0;
                                for(var j=0; j<Q4.length; j++){
                                    if(Q4[j] == currentMonthString){
                                        diff = Q4.length-1 - j;
                                    }
                                }
                                remainingMnths = remainingMnths + diff + 0;
                            } 
                            console.log('remainingMnths Awards PA: '+remainingMnths);
                            var endDate = new Date();
                            var date = new Date(endDate.setMonth(remainingMnths+1));
                            var endDateOfFiscalYear = new Date(date.getFullYear(), date.getMonth() + 1, 0);
                            console.log('Awards:: last date FY: '+endDateOfFiscalYear);
                            var monthsRemaining = 0;
                            //calculate time difference  
                            var time_difference = endDateOfFiscalYear.getTime() - d.getTime();  
                            
                            //calculate days difference by dividing total milliseconds in a day  
                            var days_difference = time_difference / (1000 * 60 * 60 * 24);
                            monthsRemaining = (days_difference/365)*12;
                            var annualImpact = productLossesMassProductRemovalList[i].Phoenix_Total_Selling_Unit__c * productLossesMassProductRemovalList[i].Phoenix_Current_ASP_Dose__c;
                            var businessImpact = (annualImpact * monthsRemaining)/12;
                            productLossesMassProductRemovalList[i].businessImpact = businessImpact;
                            totalAwardedVolume += productLossesMassProductRemovalList[i].Phoenix_Total_Selling_Unit__c;
                            totalAnnualImpact += productLossesMassProductRemovalList[i].Phoenix_Total_Selling_Unit__c * productLossesMassProductRemovalList[i].Phoenix_Current_ASP_Dose__c;
                            if(isNaN(businessImpact)){
                                totalBusinessImpact += 0;
                                totalBusinessImpactMPRLoss += 0;   
                            } else{
                                totalBusinessImpact += businessImpact;
                                totalBusinessImpactMPRLoss += businessImpact;
                            }
                            productLossesMassProductRemovalList[i].monthsRemaining = monthsRemaining;
                            productLossesMassProductRemovalList[i].formattedEffectiveDate = new Date(productLossesMassProductRemovalList[i].Customer_Response_Lines__r[0].Phoenix_Customer_Response_Date__c).toLocaleDateString("en-US", { year: "numeric", month: "2-digit", day: "2-digit" });                       
                            productLossesMassProductRemovalList[i].showItem = false;
                            dataList.push(productLossesMassProductRemovalList[i]);
                        }
                    } 
                    dataObj.family = familiesMPRLoss[f];
                    dataObj.dataList = dataList;
                    dataObj.totalAwardedVolume = totalAwardedVolume;
                    dataObj.totalAwardedAnnualValue = totalAwardedAnnualValue;
                    dataObj.totalAnnualImpact = totalAnnualImpact;
                    dataObj.totalBusinessImpact = totalBusinessImpact;
                    productLossesMassProductRemovalListUpdated.push(dataObj);
                }
                
                
                var familiesPCLoss = Object.keys(totalRes.mapLossesPCList);
                for(var f=0; f<familiesPCLoss.length; f++){
                    var dataObj = {};
                    var dataList = [];
                    var totalAwardedVolume = 0;
                    var totalAwardedAnnualValue = 0;
                    var totalAnnualImpact = 0;
                    var totalBusinessImpact = 0;
                    for(var i=0; i<productLossesPriceChangeList.length; i++){
                        if(productLossesPriceChangeList[i].Phoenix_Product__r.Family == familiesPCLoss[f] && productLossesPriceChangeList[i].Customer_Response_Lines__r){
                            var d = new Date(productLossesPriceChangeList[i].Customer_Response_Lines__r[0].Phoenix_Customer_Response_Date__c);
                            var todayDate =  new Date();
                            var currentMonthString = months[todayDate.getMonth()];
                            console.log('Current Month Awards PA: '+currentMonthString);
                            var remainingMnths = 0;
                            var endFY;
                            if(Q1.includes(currentMonthString)){
                                var diff = 0;
                                for(var j=0; j<Q1.length; j++){
                                    if(Q1[j] == currentMonthString){
                                        diff = Q1.length-1 - j;
                                    }
                                }
                                remainingMnths = remainingMnths + diff + 9;
                            } else if (Q2.includes(currentMonthString)){
                                var diff = 0;
                                for(var j=0; j<Q2.length; j++){
                                    if(Q2[j] == currentMonthString){
                                        diff = Q2.length-1 - j;
                                    }
                                }
                                remainingMnths = remainingMnths + diff + 6;
                            } else if (Q3.includes(currentMonthString)){
                                var diff = 0;
                                for(var j=0; j<Q3.length; j++){
                                    if(Q3[j] == currentMonthString){
                                        diff = Q3.length-1 - j;
                                    }
                                }
                                remainingMnths = remainingMnths + diff + 3;
                            } else if (Q4.includes(currentMonthString)){
                                var diff = 0;
                                for(var j=0; j<Q4.length; j++){
                                    if(Q4[j] == currentMonthString){
                                        diff = Q4.length-1 - j;
                                    }
                                }
                                remainingMnths = remainingMnths + diff + 0;
                            } 
                            console.log('remainingMnths Awards PA: '+remainingMnths);
                            var endDate = new Date();
                            var date = new Date(endDate.setMonth(remainingMnths+1));
                            var endDateOfFiscalYear = new Date(date.getFullYear(), date.getMonth() + 1, 0);
                            console.log('Awards:: last date FY: '+endDateOfFiscalYear);
                            var monthsRemaining = 0;
                            //calculate time difference  
                            var time_difference = endDateOfFiscalYear.getTime() - d.getTime();  
                            
                            //calculate days difference by dividing total milliseconds in a day  
                            var days_difference = time_difference / (1000 * 60 * 60 * 24);
                            monthsRemaining = (days_difference/365)*12;
                            var annualImpact = productLossesPriceChangeList[i].Phoenix_Total_Selling_Unit__c * productLossesPriceChangeList[i].Phoenix_Current_ASP_Dose__c;
                            var businessImpact = (annualImpact * monthsRemaining)/12;
                            productLossesPriceChangeList[i].businessImpact = businessImpact;
                            totalAwardedVolume += productLossesPriceChangeList[i].Phoenix_Total_Selling_Unit__c;
                            totalAnnualImpact += productLossesPriceChangeList[i].Phoenix_Total_Selling_Unit__c * productLossesPriceChangeList[i].Phoenix_Current_ASP_Dose__c;
                            if(isNaN(businessImpact)){
                                totalBusinessImpact += 0;
                                totalBusinessImpactPCLoss += 0;   
                            } else{
                                totalBusinessImpact += businessImpact;
                                totalBusinessImpactPCLoss += businessImpact;
                            }
                            productLossesPriceChangeList[i].monthsRemaining = monthsRemaining;
                            productLossesPriceChangeList[i].formattedEffectiveDate = new Date(productLossesPriceChangeList[i].Customer_Response_Lines__r[0].Phoenix_Customer_Response_Date__c).toLocaleDateString("en-US", { year: "numeric", month: "2-digit", day: "2-digit" });                       
                            productLossesPriceChangeList[i].showItem = false;
                            dataList.push(productLossesPriceChangeList[i]);
                        }
                    } 
                    dataObj.family = familiesPCLoss[f];
                    dataObj.dataList = dataList;
                    dataObj.totalAwardedVolume = totalAwardedVolume;
                    dataObj.totalAwardedAnnualValue = totalAwardedAnnualValue;
                    dataObj.totalAnnualImpact = totalAnnualImpact;
                    dataObj.totalBusinessImpact = totalBusinessImpact;
                    productLossesPriceChangeListUpdated.push(dataObj);
                }
                
                var familiesVROLoss = Object.keys(totalRes.mapLossesVROList);
                for(var f=0; f<familiesVROLoss.length; f++){
                    var dataObj = {};
                    var dataList = [];
                    var totalAwardedVolume = 0;
                    var totalAwardedAnnualValue = 0;
                    var totalAnnualImpact = 0;
                    var totalBusinessImpact = 0;
                    for(var i=0; i<productLossesvolumeReviewList.length; i++){
                        if(productLossesvolumeReviewList[i].Phoenix_Product__r.Family == familiesVROLoss[f] && productLossesvolumeReviewList[i].Customer_Response_Lines__r){
                            var d = new Date(productLossesvolumeReviewList[i].Customer_Response_Lines__r[0].Phoenix_Customer_Response_Date__c);
                            var todayDate =  new Date();
                            var currentMonthString = months[todayDate.getMonth()];
                            console.log('Current Month Awards PA: '+currentMonthString);
                            var remainingMnths = 0;
                            var endFY;
                            if(Q1.includes(currentMonthString)){
                                var diff = 0;
                                for(var j=0; j<Q1.length; j++){
                                    if(Q1[j] == currentMonthString){
                                        diff = Q1.length-1 - j;
                                    }
                                }
                                remainingMnths = remainingMnths + diff + 9;
                            } else if (Q2.includes(currentMonthString)){
                                var diff = 0;
                                for(var j=0; j<Q2.length; j++){
                                    if(Q2[j] == currentMonthString){
                                        diff = Q2.length-1 - j;
                                    }
                                }
                                remainingMnths = remainingMnths + diff + 6;
                            } else if (Q3.includes(currentMonthString)){
                                var diff = 0;
                                for(var j=0; j<Q3.length; j++){
                                    if(Q3[j] == currentMonthString){
                                        diff = Q3.length-1 - j;
                                    }
                                }
                                remainingMnths = remainingMnths + diff + 3;
                            } else if (Q4.includes(currentMonthString)){
                                var diff = 0;
                                for(var j=0; j<Q4.length; j++){
                                    if(Q4[j] == currentMonthString){
                                        diff = Q4.length-1 - j;
                                    }
                                }
                                remainingMnths = remainingMnths + diff + 0;
                            } 
                            console.log('remainingMnths Awards PA: '+remainingMnths);
                            var endDate = new Date();
                            var date = new Date(endDate.setMonth(remainingMnths+1));
                            var endDateOfFiscalYear = new Date(date.getFullYear(), date.getMonth() + 1, 0);
                            console.log('Awards:: last date FY: '+endDateOfFiscalYear);
                            var monthsRemaining = 0;
                            //calculate time difference  
                            var time_difference = endDateOfFiscalYear.getTime() - d.getTime();  
                            
                            //calculate days difference by dividing total milliseconds in a day  
                            var days_difference = time_difference / (1000 * 60 * 60 * 24);
                            monthsRemaining = (days_difference/365)*12;
                            var annualImpact = productLossesvolumeReviewList[i].Phoenix_Total_Selling_Unit__c * productLossesvolumeReviewList[i].Phoenix_Current_ASP_Dose__c;
                            var businessImpact = (annualImpact * monthsRemaining)/12;
                            productLossesvolumeReviewList[i].businessImpact = businessImpact;
                            totalAwardedVolume += productLossesvolumeReviewList[i].Phoenix_Total_Selling_Unit__c;
                            totalAnnualImpact += productLossesvolumeReviewList[i].Phoenix_Total_Selling_Unit__c * productLossesvolumeReviewList[i].Phoenix_Current_ASP_Dose__c;
                            if(isNaN(businessImpact)){
                                totalBusinessImpact += 0;
                                totalBusinessImpactVROLoss += 0;   
                            } else{
                                totalBusinessImpact += businessImpact;
                                totalBusinessImpactVROLoss += businessImpact;
                            }
                            productLossesvolumeReviewList[i].monthsRemaining = monthsRemaining;
                            productLossesvolumeReviewList[i].formattedEffectiveDate = new Date(productLossesvolumeReviewList[i].Customer_Response_Lines__r[0].Phoenix_Customer_Response_Date__c).toLocaleDateString("en-US", { year: "numeric", month: "2-digit", day: "2-digit" });                       
                            productLossesvolumeReviewList[i].showItem = false;
                            dataList.push(productLossesvolumeReviewList[i]);
                        }
                    } 
                    dataObj.family = familiesVROLoss[f];
                    dataObj.dataList = dataList;
                    dataObj.totalAwardedVolume = totalAwardedVolume;
                    dataObj.totalAwardedAnnualValue = totalAwardedAnnualValue;
                    dataObj.totalAnnualImpact = totalAnnualImpact;
                    dataObj.totalBusinessImpact = totalBusinessImpact;
                    productLossesvolumeReviewListUpdated.push(dataObj);
                }
                
                
                var familiesRFPLoss = Object.keys(totalRes.mapLossesRFPList);
                for(var f=0; f<familiesRFPLoss.length; f++){
                    var dataObj = {};
                    var dataList = [];
                    var totalAwardedVolume = 0;
                    var totalAwardedAnnualValue = 0;
                    var totalAnnualImpact = 0;
                    var totalBusinessImpact = 0;
                    for(var i=0; i<productLossesRFPList.length; i++){
                        if(productLossesRFPList[i].Phoenix_Product__r.Family == familiesRFPLoss[f] && productLossesRFPList[i].Customer_Response_Lines__r && productLossesRFPList[i].Phoenix_Total_Selling_Unit__c != 0){
                            var d = new Date(productLossesRFPList[i].Customer_Response_Lines__r[0].Phoenix_Customer_Response_Date__c);
                            var todayDate =  new Date();
                            var currentMonthString = months[todayDate.getMonth()];
                            console.log('Current Month Awards PA: '+currentMonthString);
                            var remainingMnths = 0;
                            var endFY;
                            if(Q1.includes(currentMonthString)){
                                var diff = 0;
                                for(var j=0; j<Q1.length; j++){
                                    if(Q1[j] == currentMonthString){
                                        diff = Q1.length-1 - j;
                                    }
                                }
                                remainingMnths = remainingMnths + diff + 9;
                            } else if (Q2.includes(currentMonthString)){
                                var diff = 0;
                                for(var j=0; j<Q2.length; j++){
                                    if(Q2[j] == currentMonthString){
                                        diff = Q2.length-1 - j;
                                    }
                                }
                                remainingMnths = remainingMnths + diff + 6;
                            } else if (Q3.includes(currentMonthString)){
                                var diff = 0;
                                for(var j=0; j<Q3.length; j++){
                                    if(Q3[j] == currentMonthString){
                                        diff = Q3.length-1 - j;
                                    }
                                }
                                remainingMnths = remainingMnths + diff + 3;
                            } else if (Q4.includes(currentMonthString)){
                                var diff = 0;
                                for(var j=0; j<Q4.length; j++){
                                    if(Q4[j] == currentMonthString){
                                        diff = Q4.length-1 - j;
                                    }
                                }
                                remainingMnths = remainingMnths + diff + 0;
                            } 
                            console.log('remainingMnths Awards PA: '+remainingMnths);
                            var endDate = new Date();
                            var date = new Date(endDate.setMonth(remainingMnths+1));
                            var endDateOfFiscalYear = new Date(date.getFullYear(), date.getMonth() + 1, 0);
                            console.log('Awards:: last date FY: '+endDateOfFiscalYear);
                            var monthsRemaining = 0;
                            //calculate time difference  
                            var time_difference = endDateOfFiscalYear.getTime() - d.getTime();  
                            
                            //calculate days difference by dividing total milliseconds in a day  
                            var days_difference = time_difference / (1000 * 60 * 60 * 24);
                            monthsRemaining = (days_difference/365)*12;
                            var annualImpact = productLossesRFPList[i].Phoenix_Total_Selling_Unit__c * productLossesRFPList[i].Phoenix_Current_ASP_Dose__c;
                            var businessImpact = (annualImpact * monthsRemaining)/12;
                            productLossesRFPList[i].businessImpact = businessImpact;
                            totalAwardedVolume += productLossesRFPList[i].Phoenix_Total_Selling_Unit__c;
                            totalAnnualImpact += productLossesRFPList[i].Phoenix_Total_Selling_Unit__c * productLossesRFPList[i].Phoenix_Current_ASP_Dose__c;
                            if(isNaN(businessImpact)){
                                totalBusinessImpact += 0;
                                totalBusinessImpactRFPLoss += 0;   
                            } else{
                                totalBusinessImpact += businessImpact;
                                totalBusinessImpactRFPLoss += businessImpact;
                            }
                            productLossesRFPList[i].monthsRemaining = monthsRemaining;
                            productLossesRFPList[i].formattedEffectiveDate = new Date(productLossesRFPList[i].Customer_Response_Lines__r[0].Phoenix_Customer_Response_Date__c).toLocaleDateString("en-US", { year: "numeric", month: "2-digit", day: "2-digit" });                       
                            productLossesRFPList[i].showItem = false;
                            dataList.push(productLossesRFPList[i]);
                        }
                    } 
                    dataObj.family = familiesRFPLoss[f];
                    dataObj.dataList = dataList;
                    dataObj.totalAwardedVolume = totalAwardedVolume;
                    dataObj.totalAwardedAnnualValue = totalAwardedAnnualValue;
                    dataObj.totalAnnualImpact = totalAnnualImpact;
                    dataObj.totalBusinessImpact = totalBusinessImpact;
                    productLossesRFPListListUpdated.push(dataObj);
                }
                
                component.set("v.totalBusinessImpactPA", totalBusinessImpactPA);
                component.set("v.totalBusinessImpactRFP", totalBusinessImpactRFP);
                component.set("v.totalBusinessImpactNPL", totalBusinessImpactNPL);
                component.set("v.totalBusinessImpactNC", totalBusinessImpactNC);
                component.set("v.totalBusinessImpactPCDecrease", totalBusinessImpactPCDecrease);
                component.set("v.totalBusinessImpactVRDecrease", totalBusinessImpactVRDecrease);
                component.set("v.totalBusinessImpactRFPDecrease", totalBusinessImpactRFPDecrease);
                /*component.set("v.totalBusinessImpactPCDecrease", new Intl.NumberFormat(undefined, { 
                    style: 'currency', 
                    currency: 'USD',
                    maximumFractionDigits: 0, 
                    minimumFractionDigits: 0, 
                }).format(totalBusinessImpactPCDecrease));
                component.set("v.totalBusinessImpactVRDecrease", new Intl.NumberFormat(undefined, { 
                    style: 'currency', 
                    currency: 'USD',
                    maximumFractionDigits: 0, 
                    minimumFractionDigits: 0, 
                }).format(totalBusinessImpactVRDecrease));
                component.set("v.totalBusinessImpactRFPDecrease", new Intl.NumberFormat(undefined, { 
                    style: 'currency', 
                    currency: 'USD',
                    maximumFractionDigits: 0, 
                    minimumFractionDigits: 0, 
                }).format(totalBusinessImpactRFPDecrease));*/
                component.set("v.totalBusinessImpactPCDecreaseGain", totalBusinessImpactPCDecreaseGain);
                component.set("v.totalBusinessImpactVRDecreaseGain", totalBusinessImpactVRDecreaseGain);
                component.set("v.totalBusinessImpactRFPDecreaseGain", totalBusinessImpactRFPDecreaseGain);
                component.set("v.totalBusinessImpactMPRLoss", totalBusinessImpactMPRLoss);
                component.set("v.totalBusinessImpactPCLoss", totalBusinessImpactPCLoss);
                component.set("v.totalBusinessImpactVROLoss", totalBusinessImpactVROLoss);
                component.set("v.totalBusinessImpactRFPLoss", totalBusinessImpactRFPLoss);
                
                component.set("v.recentAwardsProdAdditionList",recentAwardsProdAdditionListUpdated);
                component.set("v.recentAwardsNewPLList",recentAwardsNewPLListUpdated);
                component.set("v.recentAwardsRFPList",recentAwardsRFPListUpdated);
                component.set("v.recentAwardsNewCustomerList",recentAwardsNewCustomerListUpdated);
                component.set("v.decreasesRFPList",decreasesRFPListUpdated);
                component.set("v.decreasesPriceChangeList",decreasesPriceChangeListUpdated);
                component.set("v.decreasesvolumeReviewList",decreasesvolumeReviewListUpdated);
                component.set("v.decreasesGainRFPList",decreasesGainRFPListUpdated);
                component.set("v.decreasesGainPriceChangeList",decreasesGainPriceChangeListUpdated);
                component.set("v.decreasesGainvolumeReviewList",decreasesGainvolumeReviewListUpdated);
                
                component.set("v.productLossesMassProductRemovalList",productLossesMassProductRemovalListUpdated);
                component.set("v.productLossesPriceChangeList",productLossesPriceChangeListUpdated);
                component.set("v.productLossesvolumeReviewList",productLossesvolumeReviewListUpdated);
                component.set("v.productLossesRFPList",productLossesRFPListListUpdated);
                component.set("v.loaded", false);
                //Added by satya//
                var BusinessGainedNPL= component.get("v.totalBusinessImpactNPL");
                var BusinessGainedPA = component.get("v.totalBusinessImpactPA");
                var BusinessGainedRFP = component.get("v.totalBusinessImpactRFP");
                var BusinessGainedNC = component.get("v.totalBusinessImpactNC");
                var totalBusinessLost = 0;
                  totalBusinessLost=  component.get("v.totalBusinessImpactMPRLoss")+component.get("v.totalBusinessImpactPCLoss")+component.get("v.totalBusinessImpactVROLoss")+component.get("v.totalBusinessImpactRFPLoss");
                if(totalBusinessLost !=0){
                  totalBusinessLost = -totalBusinessLost;  
                }else{
                    totalBusinessLost =totalBusinessLost;
                }
                var totalBusinessGained = BusinessGainedNPL + BusinessGainedPA+ BusinessGainedRFP+BusinessGainedNC;
                var totalBusRetWitGained = 0;
               totalBusRetWitGained= component.get("v.totalBusinessImpactRFPDecreaseGain")+component.get("v.totalBusinessImpactPCDecreaseGain")+component.get("v.totalBusinessImpactVRDecreaseGain");
                let totalBusRetWitLoss;
                /*let busRetainedWitLossRFP = parseFloat(component.get("v.totalBusinessImpactRFPDecrease").replace('$', ''));
                console.log('RFP'+busRetainedWitLossRFP);
                let busRetainedWitLossPC = parseFloat(component.get("v.totalBusinessImpactPCDecrease").replace('$', ''));;
                console.log('PC'+busRetainedWitLossPC);
                let busRetainedWitLossVR = parseFloat(component.get("v.totalBusinessImpactVRDecrease").replace('$', ''));;
                console.log('VR'+busRetainedWitLossVR);*/
                totalBusRetWitLoss= (component.get("v.totalBusinessImpactRFPDecrease")) + (component.get("v.totalBusinessImpactPCDecrease")) + (component.get("v.totalBusinessImpactVRDecrease"));
                console.log('totalBusRetWitLoss'+totalBusRetWitLoss);
                /*if(totalBusRetWitLoss !=0){
                  totalBusRetWitLoss = -totalBusRetWitLoss;  
                }else{
                    totalBusRetWitLoss = totalBusRetWitLoss;
                }*/
                console.log('totalBusRetWitLoss test'+totalBusRetWitLoss);
                //helper.buildChartData(component, event, helper,salesDl,totalBusinessGained,totalBusinessLost,totalBusRetWitGained,totalBusRetWitLoss,trendSalesDollar);
            }else{
                component.set("v.loaded", false);
                console.log("Error "+JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);  
    },
    showErrorToast : function(component, event, message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Warning!',
            message: message,
            duration:' 5000',
            key: 'info_alt',
            type: 'error'
        });
        toastEvent.fire();
    },
   
    buildChartData: function(component, event, helper,salesDl,totalBusinessGained,totalBusinessLost,totalBusRetWitGained,totalBusRetWitLoss,trendSalesDollar){ 
     //var projectedAnnualSales = trendSalesDollar + totalBusinessGained+totalBusinessLost + totalBusRetWitGained + totalBusRetWitLoss;
               
        //number.toLocaleString('en-US', {minimumFractionDigits: 2});
        let salesDollar = Math.round(salesDl);
         console.log('salesDollar-->'+salesDollar);
        let BusinessGained = Math.round(totalBusinessGained);
        let BusinessLost =  Math.round(totalBusinessLost);
         let BusRetWitGained =  Math.round(totalBusRetWitGained);
        let BusRetWitLoss = Math.round(totalBusRetWitLoss);
        let trendSales = Math.round(trendSalesDollar);
        console.log('trendSalesDollar1-->'+trendSales.toLocaleString('en-US', {minimumFractionDigits: 0}))
        let projectedAnlSales = salesDollar + BusinessGained + BusinessLost + BusRetWitGained +BusRetWitLoss;
       
      //  anychart.onDocumentReady(function () {
        /* var data = [
      {x: "Start", value:  23},
      {x: "Jan",   value:  22},
      {x: "Feb",   value: -46},
      {x: "Mar",   value: -91},
      {x: "Apr",   value:  37},
      {x: "May",   value: -21},
      {x: "Jun",   value:  53},
      {x: "Jul",   value:  31},
      {x: "Aug",   value: -15},
      {x: "Sep",   value:  42},
      {x: "Oct",   value:  53},
      {x: "Nov",   value: -15},
      {x: "Dec",   value:  51},
      {x: "End", isTotal: true}
    ];*/
    //component.find("container").set("v.value",null);
      //   component.find("container1").set("v.value",null);
        var itemNode = document.getElementById('container');
            itemNode.parentNode.removeChild(itemNode);
           document.getElementById('chartDiv').innerHTML = '<div class="slds-col slds-size--1-of-1 slds-small-size--1-of-2 slds-medium-size--3-of-4" style="height: 450px; width: 100%" id="container"></div>';
     /* var itemNode = document.getElementById('container1');
            itemNode.parentNode.removeChild(itemNode);
           document.getElementById('chartDiv1').innerHTML = '<div class="slds-col slds-size--1-of-1 slds-small-size--1-of-2 slds-medium-size--3-of-4" style="height: 450px; width: 100%" id="container1"></div>';
    */
        var data = [
              {x: "Actual Sales", value:  salesDollar},
              {x: "Business Gained",   value: BusinessGained},
              {x: "Business Retained with Gain",   value: BusRetWitGained},
              {x: "Business Lost",   value: BusinessLost },
              {x: "Business Retained with Loss",   value:  BusRetWitLoss},
              {x: "Projected Annual Sales",   isTotal: true},
             {x: "",   value:trendSales},
              {x: "Trend Sales",   value:  [0,trendSales]},
              
            ];
             //if(component.get("v.valueChanged") == false){
             var chart = anychart.waterfall();
              var series = chart.waterfall(data);
                chart.title("Analysis");
            chart.yAxis().labels().format('${%Value}{groupsSeparator:\\,}');
            chart.labels().format("${%diff}{groupsSeparator:\\,}");
             chart.tooltip().format("Absolute :${%absolute}{groupsSeparator:\\,} \n Difference:  ${%diff}{groupsSeparator:\\,}");
           // anychart.format.number(this.value, 3, ".", ",")
           //chart.tooltip().format("{%value}{groupsSeparator:\\,}");
             chart.tooltip().fontColor("gold");
                 chart.container("container");
                   chart.draw();
            // }
             
          
//})
        

    }
})