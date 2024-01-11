({
    searchRecords : function(component, searchString) {
        var action = component.get("c.getFamilies");
        action.setParams({
            "searchString" : searchString
        });
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                const serverResult = response.getReturnValue();
                const results = [];
                serverResult.forEach(element => {
                    const result = {id : element, value : element};
                                     results.push(result);
            });
            component.set("v.results", results);
            if(serverResult.length>0){
                component.set("v.openDropDown", true);
            }
        } else{
                           console.log("Error "+JSON.stringify(response.getError()));
    }
});
$A.enqueueAction(action);
},
    collectData: function(component, event, helper, searchByBids){
        component.set("v.isSpinnerLoad", true);
        var action = component.get("c.getData");
        action.setParams({
            'AccountDirector': component.get("v.selectedId"),
            'Customer': component.get("v.selectedUserId"),
            'selections': component.get("v.selections"),
            'startDate': new Date(component.get("v.startDate")),
            'endDate': new Date(component.get("v.endDate")),
            'selectedDivision': component.get("v.selectedDivision"),
            'dateBasedOn': component.get("v.selectedDate"),
            'directorType': component.get("v.selectedDirectorType"),
            'selectedFamily': component.get("v.selectedFamily"),
            'searchByBids': searchByBids,
            'selectedBidIds': component.get("v.selectedBidIds")
        });
        action.setCallback(this, function(response){
            if(response.getState() === "SUCCESS"){  
                component.set("v.onLoad", false);
                var scmDataList = response.getReturnValue().scmWrapperList;
                var actualSales = response.getReturnValue().actualSales;
                component.set("v.actualSales", actualSales);
                component.set("v.totalBids", response.getReturnValue().bids);
                component.set("v.openLineItemsCount", response.getReturnValue().openLineItemsCount);
                var gainedList = [];
                var openStatusList =[];
                var retainedGainList = [];
                var lossList = [];
                var retainedLossList = [];
                var RFPLossList = [];
                var removalsLossList = [];
                var discontinuationLossList =[];
                var noEffectList = [];
                var totalObj = {};
                var bothList = []; var priceChangeList = []; var volumeChangeList = [];
                var bothListRetainedWithGains = []; var bothListRetainedWithLoss = [];
                var priceChangeListRetainedWithGains = []; var priceChangeListRetainedWithLoss = [];
                var volumeChangeListRetainedWithGains = []; var volumeChangeListRetainedWithLoss = [];
                var previousTotal = 0; var currentTotal = 0; var gainedImpact = 0; var retainedImpact = 0; var lostImpact = 0;
                if(scmDataList.length>0){
                    var totalAnnualImpactBG = 0; var totalBusinessImpactBG = 0; var totalPreviousQtyBG = 0; var totalQtyBG = 0; var totalSCMApprovedQtyBG = 0; var currentTotalBG = 0; var previousTotalBG = 0; var previousTPTBG = 0; var currentTPTBG = 0; var priceVarianceBG = 0; var volumeVarianceBG = 0; var totalVarianceBG = 0; var tptVarianceBG = 0;
                    var totalAnnualImpactBGG = 0; var totalBusinessImpactBGG = 0; var totalPreviousQtyBGG = 0; var totalQtyBGG = 0; var totalSCMApprovedQtyBGG = 0; var currentTotalBGG = 0; var previousTotalBGG = 0; var previousTPTBGG = 0; var currentTPTBGG = 0; var priceVarianceBGG = 0; var volumeVarianceBGG = 0; var totalVarianceBGG = 0; var tptVarianceBGG = 0;
                    var totalAnnualImpactBGL = 0; var totalBusinessImpactBGL = 0; var totalPreviousQtyBGL = 0; var totalQtyBGL = 0; var totalSCMApprovedQtyBGL = 0; var currentTotalBGL = 0; var previousTotalBGL = 0; var previousTPTBGL = 0; var currentTPTBGL = 0; var priceVarianceBGL = 0; var volumeVarianceBGL = 0; var totalVarianceBGL = 0; var tptVarianceBGL = 0;
                    var totalAnnualImpactNE = 0; var totalBusinessImpactNE = 0; var totalPreviousQtyNE = 0; var totalQtyNE = 0; var totalSCMApprovedQtyNE = 0; var currentTotalNE = 0; var previousTotalNE = 0; var previousTPTNE = 0; var currentTPTNE = 0; var priceVarianceNE = 0; var volumeVarianceNE = 0; var totalVarianceNE = 0; var tptVarianceNE = 0;
                    var totalAnnualImpactOS = 0; var totalBusinessImpactOS = 0; var totalPreviousQtyOS = 0; var totalQtyOS = 0; var totalSCMApprovedQtyOS = 0; var currentTotalOS = 0; var previousTotalOS = 0; var previousTPTOS = 0; var currentTPTOS = 0; var priceVarianceOS = 0; var volumeVarianceOS = 0; var totalVarianceOS = 0; var tptVarianceOS = 0;
                    var totalAnnualImpactBL = 0; var totalBusinessImpactBL = 0; var currentTotalBL = 0; var previousTotalBL = 0; var tptVariance =0; var priceVariance =0; var volumeVariance =0;var currentTotalBL = 0; var previousTotalBL = 0; var previousTPTBL = 0; var currentTPTBL = 0; var priceVarianceBL = 0; var volumeVarianceBL = 0; var totalVarianceBL = 0; var tptVarianceBL = 0;
                    var totalPreviousQtyBLRFP = 0; var totalSCMApprovedQtyBL = 0; var totalQtyBL = 0; var totalQtyBLRFP = 0; var currentTotalBLRFP = 0; var previousTotalBLRFP = 0; var tptVarianceBLRFP =0; var priceVarianceBLRFP =0; var volumeVarianceBLRFP =0;var previousTPTBLRFP = 0; var currentTPTBLRFP = 0; var priceVarianceBLRFP = 0; var volumeVarianceBLRFP = 0; var totalVarianceBLRFP = 0; var tptVarianceBLRFP = 0;
                    var totalAnnualImpactBLRemovals = 0; var totalPreviousQtyBL = 0; var totalBusinessImpactBLRemovals = 0;var totalAnnualImpactBLDiscontinuation = 0; var totalBusinessImpactBLDiscontinuation = 0;var totalAnnualImpactBLRFP = 0; var totalBusinessImpactBLRFP = 0;
                    let removalsDataFormattingObjProductRemovals = new Map(); var totalCurrentFiscalImpact = 0; var totalProposedFiscalImpact = 0; var totalCurrentTPTFiscalImpact = 0; var totalProposedTPTFiscalImpact = 0;
                    let removalsDataFormattingObjProductDiscontinuation = new Map(); let removalsDataFormattingObjRFP = new Map();
                    for(var i=0; i<scmDataList.length; i++){
                        tptVariance += isNaN(scmDataList[i].tptVariance)? 0 : scmDataList[i].tptVariance;
                        priceVariance += isNaN(scmDataList[i].priceVariance)? 0 : scmDataList[i].priceVariance;
                        volumeVariance += isNaN(scmDataList[i].volumeVariance)? 0 : scmDataList[i].volumeVariance;
                        var d = null;
                        if(scmDataList[i].supplyEffectiveDate){
                            d = new Date(scmDataList[i].supplyEffectiveDate);
                            scmDataList[i].dateUsed = 'SED';
                            scmDataList[i].date = 'Supply Effective Date';
                        } else if(scmDataList[i].priceEffectiveDate){
                            d = new Date(scmDataList[i].priceEffectiveDate);
                            scmDataList[i].dateUsed = 'PED';
                            scmDataList[i].date = 'Price Effective Date';
                        } else if(scmDataList[i].removalEffectiveDate){
                            d = new Date(scmDataList[i].removalEffectiveDate);
                            scmDataList[i].dateUsed = 'RED';
                            scmDataList[i].date = 'Removal Effective Date';
                        }
                        scmDataList[i].showTPTDiff = true;
                        scmDataList[i].showTotalVariance = true;
                        if(d != null && !isNaN(d)){
                            var effectiveDateFiscalYear = '';
                            if ((d.getMonth() + 1) <= 3)
                                effectiveDateFiscalYear = d.getFullYear();
                            else
                                effectiveDateFiscalYear = d.getFullYear() + 1;
                            var effectiveDateFiscalYearEndDate = new Date(effectiveDateFiscalYear, 2, 31);
                            
                            var dt = new Date();
                            var fiscalyear = '';
                            if ((dt.getMonth() + 1) <= 3)
                                fiscalyear = dt.getFullYear();
                            else
                                fiscalyear = dt.getFullYear() + 1;
                            var currentFiscalYearEndDate = new Date(fiscalyear, 2, 31);
                            
                            var endDateOfFiscalYear;      
                            if(effectiveDateFiscalYearEndDate < currentFiscalYearEndDate){
                                endDateOfFiscalYear = currentFiscalYearEndDate;// new Date(d.getFullYear()+1, d.getMonth(), d.getDate()); //currentFiscalYearEndDate;
                                d = dt;
                            } else if(effectiveDateFiscalYearEndDate > currentFiscalYearEndDate){
                                
                            } else{
                                endDateOfFiscalYear = effectiveDateFiscalYearEndDate;
                            }
                            
                            scmDataList[i].endDate = new Date(endDateOfFiscalYear).toLocaleDateString("en-US", { year: "numeric", month: "2-digit", day: "2-digit" });
                            scmDataList[i].startDate = new Date(d).toLocaleDateString("en-US", { year: "numeric", month: "2-digit", day: "2-digit" });
                            var monthsRemaining = 0;
                            //calculate time difference  
                            var time_difference = endDateOfFiscalYear.getTime() - d.getTime();  
                            //calculate days difference by dividing total milliseconds in a day  
                            var days_difference = time_difference / (1000 * 60 * 60 * 24);
                            days_difference = parseFloat(days_difference).toFixed(2);
                            scmDataList[i].daysDifference = days_difference;
                            scmDataList[i].impactedTitle = '(('+scmDataList[i].endDate+'+'-'+'+scmDataList[i].date+')/365)*12  '+'[(('+days_difference+')/365)*12]';
                            monthsRemaining = (days_difference/365)*12;
                            var annualImpact = 0;
                            var businessImpact = 0;
                            scmDataList[i].businessTitle = '(Annual Impact * Impacted Months)/12 [('+annualImpact+' * '+monthsRemaining.toFixed(2)+')/12]';
                            scmDataList[i].currentContractTotal = isNaN(scmDataList[i].awardedQty * scmDataList[i].currentDeadnet)? 0 :(scmDataList[i].awardedQty * scmDataList[i].currentDeadnet);
                            scmDataList[i].previousContractTotal = isNaN(scmDataList[i].previousQty * scmDataList[i].previousDeadnet)? 0 :(scmDataList[i].previousQty * scmDataList[i].previousDeadnet);
                            scmDataList[i].contractTotalCurrentTitle = 'Awarded Qty * Current Deadnet ('+scmDataList[i].awardedQty+'*'+scmDataList[i].currentDeadnet+')';
                            scmDataList[i].contractTotalPreviousTitle = 'Previous Qty * Previous Deadnet ('+scmDataList[i].previousQty+'*'+((scmDataList[i].previousDeadnet != undefined)?scmDataList[i].previousDeadnet:0)+')';
                            annualImpact = (scmDataList[i].currentContractTotal-(isNaN(scmDataList[i].previousContractTotal)?0:scmDataList[i].previousContractTotal));
                            businessImpact = (annualImpact * monthsRemaining)/12;
                            scmDataList[i].annualTitle = 'Current Contract Total - Previous Contract Total  ('+scmDataList[i].currentContractTotal+' - '+(isNaN(scmDataList[i].previousContractTotal)?0:scmDataList[i].previousContractTotal)+')';
                            scmDataList[i].businessImpact = businessImpact;
                            scmDataList[i].annualImpact = annualImpact;  
                            scmDataList[i].monthsRemaining = monthsRemaining;
                            if(scmDataList[i].businessCategory == 'Business Gained'){
                                //scmDataList[i].showTPTDiff = false;
                                //scmDataList[i].showTotalVariance = false;
                                scmDataList[i].previousIndirectPrice = null;
                                scmDataList[i].previousDeadnet = null;
                                scmDataList[i].previousQty = null;
                                scmDataList[i].category = 'Business Gained';
                                totalCurrentFiscalImpact +=(scmDataList[i].previousContractTotal * monthsRemaining)/12;
                                totalProposedFiscalImpact += (scmDataList[i].currentContractTotal * monthsRemaining)/12;
                                totalCurrentTPTFiscalImpact +=(scmDataList[i].previousTPT * monthsRemaining)/12;
                                gainedImpact += (scmDataList[i].previousTPT * monthsRemaining)/12;
                                totalProposedTPTFiscalImpact += (scmDataList[i].currentTPT * monthsRemaining)/12;
                                //if(scmDataList[i].annualImpact >= 0){
                                    gainedList.push(scmDataList[i]);
                                    totalAnnualImpactBG += ((isNaN(annualImpact) ? 0 : parseFloat(annualImpact)));
                                    totalBusinessImpactBG += ((isNaN(businessImpact) ? 0 : parseFloat(businessImpact)));
                                    totalPreviousQtyBG += ((isNaN(scmDataList[i].previousQty) ? 0 : parseFloat(scmDataList[i].previousQty)));
                                    totalQtyBG += ((isNaN(scmDataList[i].awardedQty) ? 0 : parseFloat(scmDataList[i].awardedQty)));
                                    totalSCMApprovedQtyBG += ((isNaN(scmDataList[i].proposedBottles) ? 0 : parseFloat(scmDataList[i].proposedBottles)));
                                    previousTotalBG += ((isNaN(scmDataList[i].previousContractTotal) ? 0 : parseFloat(scmDataList[i].previousContractTotal)));
                                    currentTotalBG += ((isNaN(scmDataList[i].currentContractTotal) ? 0 : parseFloat(scmDataList[i].currentContractTotal)));   
                                    currentTPTBG += ((isNaN(scmDataList[i].currentTPT) ? 0 : parseFloat(scmDataList[i].currentTPT)));
                                    previousTPTBG += ((isNaN(scmDataList[i].previousTPT) ? 0 : parseFloat(scmDataList[i].previousTPT)));
                                    priceVarianceBG += ((isNaN(scmDataList[i].priceVariance) ? 0 : parseFloat(scmDataList[i].priceVariance)));
                                    volumeVarianceBG += ((isNaN(scmDataList[i].volumeVariance) ? 0 : parseFloat(scmDataList[i].volumeVariance)));
                                //}
                            }
                            else if(scmDataList[i].businessCategory == 'Business Retained'){
                                totalCurrentFiscalImpact +=(scmDataList[i].previousContractTotal * monthsRemaining)/12;
                                totalProposedFiscalImpact += (scmDataList[i].currentContractTotal * monthsRemaining)/12;
                                totalCurrentTPTFiscalImpact +=(scmDataList[i].previousTPT * monthsRemaining)/12;
                                retainedImpact += (scmDataList[i].previousTPT * monthsRemaining)/12;
                                totalProposedTPTFiscalImpact += (scmDataList[i].currentTPT * monthsRemaining)/12;
                                if(scmDataList[i].businessImpact > 0){
                                    scmDataList[i].category = 'Business Retained with Gains';
                                    retainedGainList.push(scmDataList[i]);   
                                    totalAnnualImpactBGG += ((isNaN(annualImpact) ? 0 : parseFloat(annualImpact)));
                                    totalBusinessImpactBGG += ((isNaN(businessImpact) ? 0 : parseFloat(businessImpact)));
                                    totalPreviousQtyBGG += ((isNaN(scmDataList[i].previousQty) ? 0 : parseFloat(scmDataList[i].previousQty)));
                                    totalQtyBGG += ((isNaN(scmDataList[i].awardedQty) ? 0 : parseFloat(scmDataList[i].awardedQty)));
                                    totalSCMApprovedQtyBGG += ((isNaN(scmDataList[i].proposedBottles) ? 0 : parseFloat(scmDataList[i].proposedBottles)));
                                    previousTotalBGG += ((isNaN(scmDataList[i].previousContractTotal) ? 0 : parseFloat(scmDataList[i].previousContractTotal)));
                                    currentTotalBGG += ((isNaN(scmDataList[i].currentContractTotal) ? 0 : parseFloat(scmDataList[i].currentContractTotal)));
                                    currentTPTBGG += ((isNaN(scmDataList[i].currentTPT) ? 0 : parseFloat(scmDataList[i].currentTPT)));
                                    previousTPTBGG += ((isNaN(scmDataList[i].previousTPT) ? 0 : parseFloat(scmDataList[i].previousTPT)));
                                    priceVarianceBGG += ((isNaN(scmDataList[i].priceVariance) ? 0 : parseFloat(scmDataList[i].priceVariance)));
                                    volumeVarianceBGG += ((isNaN(scmDataList[i].volumeVariance) ? 0 : parseFloat(scmDataList[i].volumeVariance)));
                                    if(scmDataList[i].currentTPT > scmDataList[i].previousTPT){
                                        scmDataList[i].isGreaterTPT = true;
                                    } else if(scmDataList[i].currentTPT < scmDataList[i].previousTPT){
                                        scmDataList[i].isLesserTPT = true;
                                    } else{
                                        scmDataList[i].isEqualTPT = true;
                                    }
                                    if(scmDataList[i].currentTPTPercent > scmDataList[i].previousTPTPercent){
                                        scmDataList[i].isGreaterTPTPercent = true;
                                    } else if(scmDataList[i].currentTPTPercent < scmDataList[i].previousTPTPercent){
                                        scmDataList[i].isLesserTPTPercent = true;
                                    } else{
                                        scmDataList[i].isEqualTPTPercent = true;
                                    }
                                } 
                                else{
                                    scmDataList[i].category = 'Business Retained with Loss';
                                    retainedLossList.push(scmDataList[i]);
                                    totalAnnualImpactBGL += ((isNaN(annualImpact) ? 0 : parseFloat(annualImpact)));
                                    totalBusinessImpactBGL += ((isNaN(businessImpact) ? 0 : parseFloat(businessImpact)));
                                    totalPreviousQtyBGL += ((isNaN(scmDataList[i].previousQty) ? 0 : parseFloat(scmDataList[i].previousQty)));
                                    totalQtyBGL += ((isNaN(scmDataList[i].awardedQty) ? 0 : parseFloat(scmDataList[i].awardedQty)));
                                    totalSCMApprovedQtyBGL += ((isNaN(scmDataList[i].proposedBottles) ? 0 : parseFloat(scmDataList[i].proposedBottles)));
                                    previousTotalBGL += ((isNaN(scmDataList[i].previousContractTotal) ? 0 : parseFloat(scmDataList[i].previousContractTotal)));
                                    currentTotalBGL += ((isNaN(scmDataList[i].currentContractTotal) ? 0 : parseFloat(scmDataList[i].currentContractTotal)));
                                    currentTPTBGL += ((isNaN(scmDataList[i].currentTPT) ? 0 : parseFloat(scmDataList[i].currentTPT)));
                                    previousTPTBGL += ((isNaN(scmDataList[i].previousTPT) ? 0 : parseFloat(scmDataList[i].previousTPT)));
                                    priceVarianceBGL += ((isNaN(scmDataList[i].priceVariance) ? 0 : parseFloat(scmDataList[i].priceVariance)));
                                    volumeVarianceBGL += ((isNaN(scmDataList[i].volumeVariance) ? 0 : parseFloat(scmDataList[i].volumeVariance)));
                                    if(scmDataList[i].currentTPT > scmDataList[i].previousTPT){
                                        scmDataList[i].isGreaterTPT = true;
                                    } else if(scmDataList[i].currentTPT < scmDataList[i].previousTPT){
                                        scmDataList[i].isLesserTPT = true;
                                    } else{
                                        scmDataList[i].isEqualTPT = true;
                                    }
                                    if(scmDataList[i].currentTPTPercent > scmDataList[i].previousTPTPercent){
                                        scmDataList[i].isGreaterTPTPercent = true;
                                    } else if(scmDataList[i].currentTPTPercent < scmDataList[i].previousTPTPercent){
                                        scmDataList[i].isLesserTPTPercent = true;
                                    } else{
                                        scmDataList[i].isEqualTPTPercent = true;
                                    }
                                }
                            } 
                                else if(scmDataList[i].businessCategory == 'Business Lost'){
                                    if(scmDataList[i].bidRecord.Phoenix_Bid_Type__c == 'RFP Bids'){
                                        totalCurrentFiscalImpact += (scmDataList[i].previousContractTotal * monthsRemaining)/12;
                                        totalCurrentTPTFiscalImpact +=(scmDataList[i].previousTPT * monthsRemaining)/12;
                                        lostImpact += (scmDataList[i].previousTPT * monthsRemaining)/12;
                                        totalAnnualImpactBL += ((isNaN(scmDataList[i].annualImpact) ? 0 : parseFloat(scmDataList[i].annualImpact)));
                                        totalBusinessImpactBL += ((isNaN(scmDataList[i].businessImpact) ? 0 : parseFloat(scmDataList[i].businessImpact)));
                                        totalAnnualImpactBLRFP += ((isNaN(scmDataList[i].annualImpact) ? 0 : parseFloat(scmDataList[i].annualImpact)));
                                        totalBusinessImpactBLRFP += ((isNaN(scmDataList[i].businessImpact) ? 0 : parseFloat(scmDataList[i].businessImpact)));
                                        totalPreviousQtyBL += ((isNaN(scmDataList[i].previousQty) ? 0 : parseFloat(scmDataList[i].previousQty)));
                                        totalQtyBL += ((isNaN(scmDataList[i].awardedQty) ? 0 : parseFloat(scmDataList[i].awardedQty)));
                                        totalSCMApprovedQtyBL += ((isNaN(scmDataList[i].proposedBottles) ? 0 : parseFloat(scmDataList[i].proposedBottles)));
                                        previousTotalBL += ((isNaN(scmDataList[i].previousContractTotal) ? 0 : parseFloat(scmDataList[i].previousContractTotal)));
                                        previousTotalBLRFP += ((isNaN(scmDataList[i].previousContractTotal) ? 0 : parseFloat(scmDataList[i].previousContractTotal)));
                                        currentTotalBL += ((isNaN(scmDataList[i].currentContractTotal) ? 0 : parseFloat(scmDataList[i].currentContractTotal)));
                                        currentTotalBLRFP += ((isNaN(scmDataList[i].currentContractTotal) ? 0 : parseFloat(scmDataList[i].currentContractTotal)));
                                        currentTPTBL += ((isNaN(scmDataList[i].currentTPT) ? 0 : parseFloat(scmDataList[i].currentTPT)));
                                        currentTPTBLRFP += ((isNaN(scmDataList[i].currentTPT) ? 0 : parseFloat(scmDataList[i].currentTPT)));
                                        previousTPTBL += ((isNaN(scmDataList[i].previousTPT) ? 0 : parseFloat(scmDataList[i].previousTPT)));
                                        previousTPTBLRFP += ((isNaN(scmDataList[i].previousTPT) ? 0 : parseFloat(scmDataList[i].previousTPT)));
                                        priceVarianceBL += ((isNaN(scmDataList[i].priceVariance) ? 0 : parseFloat(scmDataList[i].priceVariance)));
                                        priceVarianceBLRFP += ((isNaN(scmDataList[i].priceVariance) ? 0 : parseFloat(scmDataList[i].priceVariance)));
                                        volumeVarianceBL += ((isNaN(scmDataList[i].volumeVariance) ? 0 : parseFloat(scmDataList[i].volumeVariance)));
                                        volumeVarianceBLRFP += ((isNaN(scmDataList[i].volumeVariance) ? 0 : parseFloat(scmDataList[i].volumeVariance)));
                                        totalPreviousQtyBLRFP += ((isNaN(scmDataList[i].previousQty) ? 0 : parseFloat(scmDataList[i].previousQty)));
                                        totalQtyBLRFP += ((isNaN(scmDataList[i].awardedQty) ? 0 : parseFloat(scmDataList[i].awardedQty)));
                                        if(scmDataList[i].currentTPT > scmDataList[i].previousTPT){
                                            scmDataList[i].isGreaterTPT = true;
                                        } else if(scmDataList[i].currentTPT < scmDataList[i].previousTPT){
                                            scmDataList[i].isLesserTPT = true;
                                        } else{
                                            scmDataList[i].isEqualTPT = true;
                                        }
                                        if(scmDataList[i].currentTPTPercent > scmDataList[i].previousTPTPercent){
                                            scmDataList[i].isGreaterTPTPercent = true;
                                        } else if(scmDataList[i].currentTPTPercent < scmDataList[i].previousTPTPercent){
                                            scmDataList[i].isLesserTPTPercent = true;
                                        } else{
                                            scmDataList[i].isEqualTPTPercent = true;
                                        }
                                        lossList.push(scmDataList[i]);
                                        RFPLossList.push(scmDataList[i]);
                                    } else if(scmDataList[i].bidRecord.Phoenix_Bid_Type__c == 'Product Discontinuation Process'){
                                        var listOfProducts = removalsDataFormattingObjProductDiscontinuation[scmDataList[i].customer];
                                        scmDataList[i].annualTitle = 'Deadnet Price * Quantity  ('+scmDataList[i].previousQty+' * '+scmDataList[i].previousIndirectPrice+')';
                                        if(listOfProducts != null){ 
                                            if(scmDataList[i].removalEffectiveDate != null){
                                                scmDataList[i].removalEffectiveDate = new Date(scmDataList[i].removalEffectiveDate).toLocaleDateString("en-US", { year: "numeric", month: "2-digit", day: "2-digit" });   
                                            }
                                            scmDataList[i].previousContractTotal = isNaN(scmDataList[i].previousQty * scmDataList[i].previousIndirectPrice)?0:(scmDataList[i].previousQty * scmDataList[i].previousIndirectPrice);
                                            scmDataList[i].currentContractTotal = 0;
                                            scmDataList[i].annualImpact = scmDataList[i].currentContractTotal - scmDataList[i].previousContractTotal;
                                            /*if(annualImpact != 0 && annualImpact != null)
                                                scmDataList[i].annualImpact = parseFloat(Math.abs(annualImpact) * -1);
                                            else 
                                                scmDataList[i].annualImpact = 0;*/
                                            scmDataList[i].businessTitle = '(Annual Impact * Impacted Months)/12 [('+(scmDataList[i].annualImpact).toFixed()+' * '+monthsRemaining.toFixed(2)+')/12]';
                                            scmDataList[i].businessImpact = (scmDataList[i].annualImpact * monthsRemaining)/12;
                                            if(scmDataList[i].businessImpact == 'Infinity' || isNaN(scmDataList[i].businessImpact) || scmDataList[i].businessImpact == null){
                                                scmDataList[i].businessImpact = 'N/A';
                                            }
                                            listOfProducts.push(scmDataList[i]);
                                            totalAnnualImpactBL += ((isNaN(scmDataList[i].annualImpact) ? 0 : scmDataList[i].annualImpact));
                                            totalBusinessImpactBL += ((isNaN(scmDataList[i].businessImpact) ? 0 : scmDataList[i].businessImpact));
                                            totalAnnualImpactBLDiscontinuation += ((isNaN(scmDataList[i].annualImpact) ? 0 : scmDataList[i].annualImpact));
                                            totalBusinessImpactBLDiscontinuation += ((isNaN(scmDataList[i].businessImpact) ? 0 : scmDataList[i].businessImpact));
                                            previousTotalBL += scmDataList[i].previousContractTotal;
                                            currentTotalBL += 0;
                                            removalsDataFormattingObjProductDiscontinuation[scmDataList[i].customer] = listOfProducts;                                    
                                        } 
                                        else{
                                            var listOfProducts = [];
                                            if(scmDataList[i].removalEffectiveDate != null){
                                                scmDataList[i].removalEffectiveDate = new Date(scmDataList[i].removalEffectiveDate).toLocaleDateString("en-US", { year: "numeric", month: "2-digit", day: "2-digit" });   
                                            }
                                            scmDataList[i].previousContractTotal = isNaN(scmDataList[i].previousQty * scmDataList[i].previousIndirectPrice)?0:(scmDataList[i].previousQty * scmDataList[i].previousIndirectPrice);
                                            scmDataList[i].currentContractTotal = 0;
                                            scmDataList[i].annualImpact = scmDataList[i].currentContractTotal - scmDataList[i].previousContractTotal;
                                            scmDataList[i].businessTitle = '(Annual Impact * Impacted Months)/12 [('+(scmDataList[i].annualImpact).toFixed()+' * '+monthsRemaining.toFixed(2)+')/12]';
                                            scmDataList[i].businessImpact = (scmDataList[i].annualImpact * monthsRemaining)/12;
                                            if(scmDataList[i].businessImpact == 'Infinity' || isNaN(scmDataList[i].businessImpact) || scmDataList[i].businessImpact == null){
                                                scmDataList[i].businessImpact = 'N/A';
                                            }
                                            listOfProducts.push(scmDataList[i]);
                                            totalAnnualImpactBL += ((isNaN(scmDataList[i].annualImpact) ? 0 : scmDataList[i].annualImpact));
                                            totalBusinessImpactBL += ((isNaN(scmDataList[i].businessImpact) ? 0 : scmDataList[i].businessImpact));
                                            totalAnnualImpactBLDiscontinuation += ((isNaN(scmDataList[i].annualImpact) ? 0 : scmDataList[i].annualImpact));
                                            totalBusinessImpactBLDiscontinuation += ((isNaN(scmDataList[i].businessImpact) ? 0 : scmDataList[i].businessImpact));
                                            previousTotalBL += scmDataList[i].previousContractTotal;
                                            currentTotalBL += 0;
                                            removalsDataFormattingObjProductDiscontinuation[scmDataList[i].customer] = listOfProducts;                                    
                                        }
                                        totalCurrentFiscalImpact += (scmDataList[i].previousContractTotal * monthsRemaining)/12;
                                        scmDataList[i].monthsRemaining = monthsRemaining;
                                        lossList.push(scmDataList[i]);
                                        discontinuationLossList.push(scmDataList[i]);
                                    } else if(scmDataList[i].bidRecord.Phoenix_Bid_Type__c == 'Mass Product Removals'){
                                        var listOfProducts = removalsDataFormattingObjProductRemovals[scmDataList[i].customer];
                                        scmDataList[i].annualTitle = 'Deadnet Price * Quantity  ('+scmDataList[i].previousQty+' * '+scmDataList[i].previousIndirectPrice+')';
                                        if(listOfProducts != null){ 
                                            if(scmDataList[i].removalEffectiveDate != null){
                                                scmDataList[i].removalEffectiveDate = new Date(scmDataList[i].removalEffectiveDate).toLocaleDateString("en-US", { year: "numeric", month: "2-digit", day: "2-digit" });   
                                            }
                                            scmDataList[i].previousContractTotal = isNaN(scmDataList[i].previousQty * scmDataList[i].previousIndirectPrice)?0:(scmDataList[i].previousQty * scmDataList[i].previousIndirectPrice);
                                            scmDataList[i].currentContractTotal = 0;
                                            scmDataList[i].annualImpact = scmDataList[i].currentContractTotal - scmDataList[i].previousContractTotal;
                                            
                                            scmDataList[i].businessTitle = '(Annual Impact * Impacted Months)/12 [('+(scmDataList[i].annualImpact).toFixed()+' * '+monthsRemaining.toFixed(2)+')/12]';
                                            scmDataList[i].businessImpact = (scmDataList[i].annualImpact * monthsRemaining)/12;
                                            if(scmDataList[i].businessImpact == 'Infinity' || isNaN(scmDataList[i].businessImpact) || scmDataList[i].businessImpact == null){
                                                scmDataList[i].businessImpact = 'N/A';
                                            }
                                            listOfProducts.push(scmDataList[i]);
                                            totalAnnualImpactBL += ((isNaN(scmDataList[i].annualImpact) ? 0 : scmDataList[i].annualImpact));
                                            totalBusinessImpactBL += ((isNaN(scmDataList[i].businessImpact) ? 0 : scmDataList[i].businessImpact));
                                            totalAnnualImpactBLRemovals += ((isNaN(scmDataList[i].annualImpact) ? 0 : scmDataList[i].annualImpact));
                                            totalBusinessImpactBLRemovals += ((isNaN(scmDataList[i].businessImpact) ? 0 : scmDataList[i].businessImpact));
                                            previousTotalBL += scmDataList[i].previousContractTotal;
                                            currentTotalBL += 0;
                                            removalsDataFormattingObjProductRemovals[scmDataList[i].customer] = listOfProducts;                                    
                                        } 
                                        else{
                                            var listOfProducts = [];
                                            if(scmDataList[i].removalEffectiveDate != null){
                                                scmDataList[i].removalEffectiveDate = new Date(scmDataList[i].removalEffectiveDate).toLocaleDateString("en-US", { year: "numeric", month: "2-digit", day: "2-digit" });   
                                            }
                                            scmDataList[i].previousContractTotal = isNaN(scmDataList[i].previousQty * scmDataList[i].previousIndirectPrice)?0:(scmDataList[i].previousQty * scmDataList[i].previousIndirectPrice);
                                            scmDataList[i].currentContractTotal = 0;
                                            scmDataList[i].annualImpact = scmDataList[i].currentContractTotal - scmDataList[i].previousContractTotal;
                                            
                                            scmDataList[i].businessTitle = '(Annual Impact * Impacted Months)/12 [('+(scmDataList[i].annualImpact).toFixed()+' * '+monthsRemaining.toFixed(2)+')/12]';
                                            scmDataList[i].businessImpact = (scmDataList[i].annualImpact * monthsRemaining)/12;
                                            if(scmDataList[i].businessImpact == 'Infinity' || isNaN(scmDataList[i].businessImpact) || scmDataList[i].businessImpact == null){
                                                scmDataList[i].businessImpact = 'N/A';
                                            }
                                            listOfProducts.push(scmDataList[i]);
                                            totalAnnualImpactBL += ((isNaN(scmDataList[i].annualImpact) ? 0 : scmDataList[i].annualImpact));
                                            totalBusinessImpactBL += ((isNaN(scmDataList[i].businessImpact) ? 0 : scmDataList[i].businessImpact));
                                            totalAnnualImpactBLRemovals += ((isNaN(scmDataList[i].annualImpact) ? 0 : scmDataList[i].annualImpact));
                                            totalBusinessImpactBLRemovals += ((isNaN(scmDataList[i].businessImpact) ? 0 : scmDataList[i].businessImpact));
                                            previousTotalBL += scmDataList[i].previousContractTotal;
                                            currentTotalBL += 0;
                                            removalsDataFormattingObjProductRemovals[scmDataList[i].customer] = listOfProducts;                                    
                                        }
                                        totalCurrentFiscalImpact += (scmDataList[i].previousContractTotal * monthsRemaining)/12;
                                        scmDataList[i].monthsRemaining = monthsRemaining;
                                        lossList.push(scmDataList[i]);
                                        removalsLossList.push(scmDataList[i]);
                                    }
                                } 
                                    else if(scmDataList[i].businessCategory == 'No Effect'){
                                        scmDataList[i].currentContractTotal = isNaN(scmDataList[i].awardedQty * scmDataList[i].currentDeadnet)? 0 :(scmDataList[i].awardedQty * scmDataList[i].currentDeadnet);
                                        scmDataList[i].previousContractTotal = isNaN(scmDataList[i].previousQty * scmDataList[i].previousDeadnet)? 0 :(scmDataList[i].previousQty * scmDataList[i].previousDeadnet);
                                        scmDataList[i].contractTotalCurrentTitle = 'Awarded Qty * Current Deadnet ('+scmDataList[i].awardedQty+'*'+scmDataList[i].currentDeadnet+')';
                                        scmDataList[i].contractTotalPreviousTitle = 'Previous Qty * Previous Deadnet ('+scmDataList[i].previousQty+'*'+((scmDataList[i].previousDeadnet != undefined)?scmDataList[i].previousDeadnet:0)+')';
                                        annualImpact = (scmDataList[i].currentContractTotal-(isNaN(scmDataList[i].previousContractTotal)?0:scmDataList[i].previousContractTotal));
                                        scmDataList[i].businessTitle = '(Annual Impact * Impacted Months)/12 [('+annualImpact+' * '+monthsRemaining.toFixed(2)+')/12]';
                                        scmDataList[i].annualImpact = parseFloat(annualImpact);
                                        previousTotalNE += ((isNaN(scmDataList[i].previousContractTotal) ? 0 : scmDataList[i].previousContractTotal));
                                        currentTotalNE += ((isNaN(scmDataList[i].currentContractTotal) ? 0 : scmDataList[i].currentContractTotal));
                                        totalAnnualImpactNE += ((isNaN(annualImpact) ? 0 : parseFloat(annualImpact)));
                                        totalBusinessImpactNE += ((isNaN(businessImpact) ? 0 : parseFloat(businessImpact)));
                                        currentTPTNE += ((isNaN(scmDataList[i].currentTPT) ? 0 : scmDataList[i].currentTPT));
                                        previousTPTNE += ((isNaN(scmDataList[i].previousTPT) ? 0 : scmDataList[i].previousTPT));
                                        priceVarianceNE += ((isNaN(scmDataList[i].priceVariance) ? 0 : scmDataList[i].priceVariance));
                                        volumeVarianceNE += ((isNaN(scmDataList[i].volumeVariance) ? 0 : scmDataList[i].volumeVariance));
                                        if(scmDataList[i].currentTPT > scmDataList[i].previousTPT){
                                            scmDataList[i].isGreaterTPT = true;
                                        } else if(scmDataList[i].currentTPT < scmDataList[i].previousTPT){
                                            scmDataList[i].isLesserTPT = true;
                                        } else{
                                            scmDataList[i].isEqualTPT = true;
                                        }
                                        if(scmDataList[i].currentTPTPercent > scmDataList[i].previousTPTPercent){
                                            scmDataList[i].isGreaterTPTPercent = true;
                                        } else if(scmDataList[i].currentTPTPercent < scmDataList[i].previousTPTPercent){
                                            scmDataList[i].isLesserTPTPercent = true;
                                        } else{
                                            scmDataList[i].isEqualTPTPercent = true;
                                        }
                                        noEffectList.push(scmDataList[i]);
                                    }   
                                        else if(scmDataList[i].businessCategory == 'Open Status'){
                                            scmDataList[i].currentContractTotal = parseFloat(isNaN(scmDataList[i].awardedQty * scmDataList[i].currentDeadnet)? 0 :(scmDataList[i].awardedQty * scmDataList[i].currentDeadnet));
                                            scmDataList[i].previousContractTotal = parseFloat(isNaN(scmDataList[i].previousQty * scmDataList[i].previousDeadnet)? 0 :(scmDataList[i].previousQty * scmDataList[i].previousDeadnet));
                                            scmDataList[i].contractTotalCurrentTitle = 'Proposed Qty * Current Deadnet ('+scmDataList[i].awardedQty+'*'+scmDataList[i].currentDeadnet+')';
                                            scmDataList[i].contractTotalPreviousTitle = 'Previous Qty * Previous Deadnet ('+scmDataList[i].previousQty+'*'+((scmDataList[i].previousDeadnet != undefined)?scmDataList[i].previousDeadnet:0)+')';
                                            annualImpact = (scmDataList[i].currentContractTotal-(isNaN(scmDataList[i].previousContractTotal)?0:scmDataList[i].previousContractTotal));
                                            scmDataList[i].businessTitle = '(Annual Impact * Impacted Months)/12 [('+annualImpact+' * '+monthsRemaining.toFixed(2)+')/12]';
                                            scmDataList[i].annualImpact = annualImpact;
                                            previousTotalOS += ((isNaN(scmDataList[i].previousContractTotal) ? 0 : scmDataList[i].previousContractTotal));
                                            currentTotalOS += ((isNaN(scmDataList[i].currentContractTotal) ? 0 : scmDataList[i].currentContractTotal));
                                            totalAnnualImpactOS += ((isNaN(annualImpact) ? 0 : annualImpact));
                                            totalBusinessImpactOS += ((isNaN(businessImpact) ? 0 : businessImpact));
                                            currentTPTOS += ((isNaN(scmDataList[i].currentTPT) ? 0 : scmDataList[i].currentTPT));
                                            previousTPTOS += ((isNaN(scmDataList[i].previousTPT) ? 0 : scmDataList[i].previousTPT));
                                            priceVarianceOS += ((isNaN(scmDataList[i].priceVariance) ? 0 : scmDataList[i].priceVariance));
                                            volumeVarianceOS += ((isNaN(scmDataList[i].volumeVariance) ? 0 : scmDataList[i].volumeVariance));
                                            if(scmDataList[i].currentTPT > scmDataList[i].previousTPT){
                                                scmDataList[i].isGreaterTPT = true;
                                            } else if(scmDataList[i].currentTPT < scmDataList[i].previousTPT){
                                                scmDataList[i].isLesserTPT = true;
                                            } else{
                                                scmDataList[i].isEqualTPT = true;
                                            }
                                            if(scmDataList[i].currentTPTPercent > scmDataList[i].previousTPTPercent){
                                                scmDataList[i].isGreaterTPTPercent = true;
                                            } else if(scmDataList[i].currentTPTPercent < scmDataList[i].previousTPTPercent){
                                                scmDataList[i].isLesserTPTPercent = true;
                                            } else{
                                                scmDataList[i].isEqualTPTPercent = true;
                                            }
                                            openStatusList.push(scmDataList[i]);
                                        }
                        }
                        else{
                            var monthsRemaining = 0;
                            var annualImpact = 0;
                            var businessImpact = 0;
                            if(scmDataList[i].businessCategory == 'Business Lost'){
                                if(scmDataList[i].bidRecord.Phoenix_Bid_Type__c == 'RFP Bids'){
                                    scmDataList[i].currentContractTotal = isNaN(scmDataList[i].awardedQty * scmDataList[i].currentDeadnet)? 0 :(scmDataList[i].awardedQty * scmDataList[i].currentDeadnet);
                                    scmDataList[i].previousContractTotal = isNaN(scmDataList[i].previousQty * scmDataList[i].previousDeadnet)? 0 :(scmDataList[i].previousQty * scmDataList[i].previousDeadnet);
                                    scmDataList[i].contractTotalCurrentTitle = 'Awarded Qty * Current Deadnet ('+scmDataList[i].awardedQty+'*'+scmDataList[i].currentDeadnet+')';
                                    scmDataList[i].contractTotalPreviousTitle = 'Previous Qty * Previous Deadnet ('+scmDataList[i].previousQty+'*'+((scmDataList[i].previousDeadnet != undefined)?scmDataList[i].previousDeadnet:0)+')';
                                    annualImpact = (scmDataList[i].currentContractTotal-(isNaN(scmDataList[i].previousContractTotal)?0:scmDataList[i].previousContractTotal));
                                    scmDataList[i].businessTitle = '(Annual Impact * Impacted Months)/12 [('+annualImpact+' * '+monthsRemaining.toFixed(2)+')/12]';
                                    scmDataList[i].annualImpact = parseFloat(annualImpact);
                                    previousTotalBL += ((isNaN(scmDataList[i].previousContractTotal) ? 0 : scmDataList[i].previousContractTotal));
                                    previousTotalBLRFP += ((isNaN(scmDataList[i].previousContractTotal) ? 0 : scmDataList[i].previousContractTotal));
                                    currentTotalBL += ((isNaN(scmDataList[i].currentContractTotal) ? 0 : scmDataList[i].currentContractTotal));
                                    currentTotalBLRFP += ((isNaN(scmDataList[i].currentContractTotal) ? 0 : scmDataList[i].currentContractTotal));
                                    totalAnnualImpactBL += ((isNaN(annualImpact) ? 0 : parseFloat(annualImpact)));
                                    totalBusinessImpactBL += ((isNaN(businessImpact) ? 0 : parseFloat(businessImpact)));
                                    totalAnnualImpactBLRFP += ((isNaN(annualImpact) ? 0 : parseFloat(annualImpact)));
                                    totalBusinessImpactBLRFP += ((isNaN(businessImpact) ? 0 : parseFloat(businessImpact)));
                                    currentTPTBL += ((isNaN(scmDataList[i].currentTPT) ? 0 : scmDataList[i].currentTPT));
                                    currentTPTBLRFP += ((isNaN(scmDataList[i].currentTPT) ? 0 : scmDataList[i].currentTPT));
                                    previousTPTBL += ((isNaN(scmDataList[i].previousTPT) ? 0 : scmDataList[i].previousTPT));
                                    previousTPTBLRFP += ((isNaN(scmDataList[i].previousTPT) ? 0 : scmDataList[i].previousTPT));
                                    priceVarianceBL += ((isNaN(scmDataList[i].priceVariance) ? 0 : scmDataList[i].priceVariance));
                                    priceVarianceBLRFP += ((isNaN(scmDataList[i].priceVariance) ? 0 : scmDataList[i].priceVariance));
                                    volumeVarianceBL += ((isNaN(scmDataList[i].volumeVariance) ? 0 : scmDataList[i].volumeVariance));
                                    volumeVarianceBLRFP += ((isNaN(scmDataList[i].volumeVariance) ? 0 : scmDataList[i].volumeVariance));
                                    totalPreviousQtyBLRFP += ((isNaN(scmDataList[i].previousQty) ? 0 : scmDataList[i].previousQty));
                                    totalQtyBLRFP += ((isNaN(scmDataList[i].awardedQty) ? 0 : scmDataList[i].awardedQty));
                                    if(scmDataList[i].currentTPT > scmDataList[i].previousTPT){
                                        scmDataList[i].isGreaterTPT = true;
                                    } else if(scmDataList[i].currentTPT < scmDataList[i].previousTPT){
                                        scmDataList[i].isLesserTPT = true;
                                    } else{
                                        scmDataList[i].isEqualTPT = true;
                                    }
                                    if(scmDataList[i].currentTPTPercent > scmDataList[i].previousTPTPercent){
                                        scmDataList[i].isGreaterTPTPercent = true;
                                    } else if(scmDataList[i].currentTPTPercent < scmDataList[i].previousTPTPercent){
                                        scmDataList[i].isLesserTPTPercent = true;
                                    } else{
                                        scmDataList[i].isEqualTPTPercent = true;
                                    }
                                    totalCurrentFiscalImpact += (scmDataList[i].previousContractTotal * monthsRemaining)/12;
                                    lossList.push(scmDataList[i]);
                                    RFPLossList.push(scmDataList[i]);   
                                } else if(scmDataList[i].bidRecord.Phoenix_Bid_Type__c == 'Mass Product Removals'){
                                    scmDataList[i].annualTitle = 'Deadnet Price * Quantity  ('+scmDataList[i].previousQty+' * '+scmDataList[i].previousIndirectPrice+')';
                                    var listOfProducts = removalsDataFormattingObjProductRemovals[scmDataList[i].customer];
                                    if(listOfProducts != null){ 
                                        if(scmDataList[i].removalEffectiveDate != null){
                                            scmDataList[i].removalEffectiveDate = new Date(scmDataList[i].removalEffectiveDate).toLocaleDateString("en-US", { year: "numeric", month: "2-digit", day: "2-digit" });   
                                        }
                                        scmDataList[i].previousContractTotal = isNaN(scmDataList[i].previousQty * scmDataList[i].previousIndirectPrice)?0:(scmDataList[i].previousQty * scmDataList[i].previousIndirectPrice);
                                        scmDataList[i].currentContractTotal = 0;
                                        scmDataList[i].annualImpact = scmDataList[i].currentContractTotal - scmDataList[i].previousContractTotal;
                                        
                                        scmDataList[i].businessTitle = '(Annual Impact * Impacted Months)/12 [('+(scmDataList[i].annualImpact).toFixed()+' * '+monthsRemaining.toFixed(2)+')/12]';
                                        scmDataList[i].businessImpact = (scmDataList[i].annualImpact * monthsRemaining)/12;
                                        if(scmDataList[i].businessImpact == 'Infinity' || isNaN(scmDataList[i].businessImpact) || scmDataList[i].businessImpact == null){
                                            scmDataList[i].businessImpact = 'N/A';
                                        }
                                        listOfProducts.push(scmDataList[i]);
                                        totalAnnualImpactBL += ((isNaN(scmDataList[i].annualImpact) ? 0 : scmDataList[i].annualImpact));
                                        totalBusinessImpactBL += ((isNaN(scmDataList[i].businessImpact) ? 0 : scmDataList[i].businessImpact));
                                        totalAnnualImpactBLRemovals += ((isNaN(scmDataList[i].annualImpact) ? 0 : scmDataList[i].annualImpact));
                                        totalBusinessImpactBLRemovals += ((isNaN(scmDataList[i].businessImpact) ? 0 : scmDataList[i].businessImpact));
                                        previousTotalBL += scmDataList[i].previousContractTotal;
                                        currentTotalBL += 0;
                                        removalsDataFormattingObjProductRemovals[scmDataList[i].customer] = listOfProducts;                                    
                                    } else{
                                        var listOfProducts = [];
                                        if(scmDataList[i].removalEffectiveDate != null){
                                            scmDataList[i].removalEffectiveDate = new Date(scmDataList[i].removalEffectiveDate).toLocaleDateString("en-US", { year: "numeric", month: "2-digit", day: "2-digit" });   
                                        }
                                        scmDataList[i].previousContractTotal = isNaN(scmDataList[i].previousQty * scmDataList[i].previousIndirectPrice)?0:(scmDataList[i].previousQty * scmDataList[i].previousIndirectPrice);
                                        scmDataList[i].currentContractTotal = 0;
                                        scmDataList[i].annualImpact = scmDataList[i].currentContractTotal - scmDataList[i].previousContractTotal;
                                        
                                        scmDataList[i].businessTitle = '(Annual Impact * Impacted Months)/12 [('+(scmDataList[i].annualImpact).toFixed()+' * '+monthsRemaining.toFixed(2)+')/12]';
                                        scmDataList[i].businessImpact = (scmDataList[i].annualImpact * monthsRemaining)/12;
                                        if(scmDataList[i].businessImpact == 'Infinity' || isNaN(scmDataList[i].businessImpact) || scmDataList[i].businessImpact == null){
                                            scmDataList[i].businessImpact = 'N/A';
                                        }
                                        listOfProducts.push(scmDataList[i]);
                                        totalAnnualImpactBL += ((isNaN(scmDataList[i].annualImpact) ? 0 : scmDataList[i].annualImpact));
                                        totalBusinessImpactBL += ((isNaN(scmDataList[i].businessImpact) ? 0 : scmDataList[i].businessImpact));
                                        totalAnnualImpactBLRemovals += ((isNaN(scmDataList[i].annualImpact) ? 0 : scmDataList[i].annualImpact));
                                        totalBusinessImpactBLRemovals += ((isNaN(scmDataList[i].businessImpact) ? 0 : scmDataList[i].businessImpact));
                                        previousTotalBL += scmDataList[i].previousContractTotal;
                                        currentTotalBL += 0;
                                        removalsDataFormattingObjProductRemovals[scmDataList[i].customer] = listOfProducts;                                    
                                    }
                                    totalCurrentFiscalImpact += (scmDataList[i].previousContractTotal * monthsRemaining)/12;
                                    lossList.push(scmDataList[i]);
                                    removalsLossList.push(scmDataList[i]);
                                } else if(scmDataList[i].bidRecord.Phoenix_Bid_Type__c == 'Product Discontinuation Process'){
                                    scmDataList[i].annualTitle = 'Deadnet Price * Quantity  ('+scmDataList[i].previousQty+' * '+scmDataList[i].previousIndirectPrice+')';
                                    var listOfProducts = removalsDataFormattingObjProductDiscontinuation[scmDataList[i].customer];
                                    if(listOfProducts != null){ 
                                        if(scmDataList[i].removalEffectiveDate != null){
                                            scmDataList[i].removalEffectiveDate = new Date(scmDataList[i].removalEffectiveDate).toLocaleDateString("en-US", { year: "numeric", month: "2-digit", day: "2-digit" });   
                                        }
                                        scmDataList[i].previousContractTotal = isNaN(scmDataList[i].previousQty * scmDataList[i].previousIndirectPrice)?0:(scmDataList[i].previousQty * scmDataList[i].previousIndirectPrice);
                                        scmDataList[i].currentContractTotal = 0;
                                        scmDataList[i].annualImpact = scmDataList[i].currentContractTotal - scmDataList[i].previousContractTotal;
                                        
                                        scmDataList[i].businessTitle = '(Annual Impact * Impacted Months)/12 [('+(scmDataList[i].annualImpact).toFixed()+' * '+monthsRemaining.toFixed(2)+')/12]';
                                        scmDataList[i].businessImpact = (scmDataList[i].annualImpact * monthsRemaining)/12;
                                        if(scmDataList[i].businessImpact == 'Infinity' || isNaN(scmDataList[i].businessImpact) || scmDataList[i].businessImpact == null){
                                            scmDataList[i].businessImpact = 'N/A';
                                        }
                                        listOfProducts.push(scmDataList[i]);
                                        totalAnnualImpactBL += ((isNaN(scmDataList[i].annualImpact) ? 0 : scmDataList[i].annualImpact));
                                        totalBusinessImpactBL += ((isNaN(scmDataList[i].businessImpact) ? 0 : scmDataList[i].businessImpact));
                                        totalAnnualImpactBLDiscontinuation += ((isNaN(scmDataList[i].annualImpact) ? 0 : scmDataList[i].annualImpact));
                                        totalBusinessImpactBLDiscontinuation += ((isNaN(scmDataList[i].businessImpact) ? 0 : scmDataList[i].businessImpact));
                                        previousTotalBL += scmDataList[i].previousContractTotal;
                                        currentTotalBL += 0;
                                        removalsDataFormattingObjProductDiscontinuation[scmDataList[i].customer] = listOfProducts;                                    
                                    } else{
                                        var listOfProducts = [];
                                        if(scmDataList[i].removalEffectiveDate != null){
                                            scmDataList[i].removalEffectiveDate = new Date(scmDataList[i].removalEffectiveDate).toLocaleDateString("en-US", { year: "numeric", month: "2-digit", day: "2-digit" });   
                                        }
                                        scmDataList[i].previousContractTotal = isNaN(scmDataList[i].previousQty * scmDataList[i].previousIndirectPrice)?0:(scmDataList[i].previousQty * scmDataList[i].previousIndirectPrice);
                                        scmDataList[i].currentContractTotal = 0;
                                        scmDataList[i].annualImpact = scmDataList[i].currentContractTotal - scmDataList[i].previousContractTotal;
                                        
                                        scmDataList[i].businessTitle = '(Annual Impact * Impacted Months)/12 [('+(scmDataList[i].annualImpact).toFixed()+' * '+monthsRemaining.toFixed(2)+')/12]';
                                        scmDataList[i].businessImpact = (scmDataList[i].annualImpact * monthsRemaining)/12;
                                        if(scmDataList[i].businessImpact == 'Infinity' || isNaN(scmDataList[i].businessImpact) || scmDataList[i].businessImpact == null){
                                            scmDataList[i].businessImpact = 'N/A';
                                        }
                                        listOfProducts.push(scmDataList[i]);
                                        totalAnnualImpactBL += ((isNaN(scmDataList[i].annualImpact) ? 0 : scmDataList[i].annualImpact));
                                        totalBusinessImpactBL += ((isNaN(scmDataList[i].businessImpact) ? 0 : scmDataList[i].businessImpact));
                                        totalAnnualImpactBLDiscontinuation += ((isNaN(scmDataList[i].annualImpact) ? 0 : scmDataList[i].annualImpact));
                                        totalBusinessImpactBLDiscontinuation += ((isNaN(scmDataList[i].businessImpact) ? 0 : scmDataList[i].businessImpact));
                                        previousTotalBL += scmDataList[i].previousContractTotal;
                                        currentTotalBL += 0;
                                        removalsDataFormattingObjProductDiscontinuation[scmDataList[i].customer] = listOfProducts;                                    
                                    }
                                    totalCurrentFiscalImpact += (scmDataList[i].previousContractTotal * monthsRemaining)/12;
                                    lossList.push(scmDataList[i]);
                                    discontinuationLossList.push(scmDataList[i]);
                                }
                            } else if(scmDataList[i].businessCategory == 'No Effect'){
                                scmDataList[i].currentContractTotal = isNaN(scmDataList[i].awardedQty * scmDataList[i].currentDeadnet)? 0 :(scmDataList[i].awardedQty * scmDataList[i].currentDeadnet);
                                scmDataList[i].previousContractTotal = isNaN(scmDataList[i].previousQty * scmDataList[i].previousDeadnet)? 0 :(scmDataList[i].previousQty * scmDataList[i].previousDeadnet);
                                scmDataList[i].contractTotalCurrentTitle = 'Awarded Qty * Current Deadnet ('+scmDataList[i].awardedQty+'*'+scmDataList[i].currentDeadnet+')';
                                scmDataList[i].contractTotalPreviousTitle = 'Previous Qty * Previous Deadnet ('+scmDataList[i].previousQty+'*'+((scmDataList[i].previousDeadnet != undefined)?scmDataList[i].previousDeadnet:0)+')';
                                annualImpact = (scmDataList[i].currentContractTotal-(isNaN(scmDataList[i].previousContractTotal)?0:scmDataList[i].previousContractTotal));
                                scmDataList[i].businessTitle = '(Annual Impact * Impacted Months)/12 [('+annualImpact+' * '+monthsRemaining.toFixed(2)+')/12]';
                                scmDataList[i].annualImpact = parseFloat(annualImpact);
                                previousTotalNE += ((isNaN(scmDataList[i].previousContractTotal) ? 0 : scmDataList[i].previousContractTotal));
                                currentTotalNE += ((isNaN(scmDataList[i].currentContractTotal) ? 0 : scmDataList[i].currentContractTotal));
                                totalAnnualImpactNE += ((isNaN(annualImpact) ? 0 : parseFloat(annualImpact)));
                                totalBusinessImpactNE += ((isNaN(businessImpact) ? 0 : parseFloat(businessImpact)));
                                currentTPTNE += ((isNaN(scmDataList[i].currentTPT) ? 0 : scmDataList[i].currentTPT));
                                previousTPTNE += ((isNaN(scmDataList[i].previousTPT) ? 0 : scmDataList[i].previousTPT));
                                priceVarianceNE += ((isNaN(scmDataList[i].priceVariance) ? 0 : scmDataList[i].priceVariance));
                                volumeVarianceNE += ((isNaN(scmDataList[i].volumeVariance) ? 0 : scmDataList[i].volumeVariance));
                                if(scmDataList[i].currentTPT > scmDataList[i].previousTPT){
                                    scmDataList[i].isGreaterTPT = true;
                                } else if(scmDataList[i].currentTPT < scmDataList[i].previousTPT){
                                    scmDataList[i].isLesserTPT = true;
                                } else{
                                    scmDataList[i].isEqualTPT = true;
                                }
                                if(scmDataList[i].currentTPTPercent > scmDataList[i].previousTPTPercent){
                                    scmDataList[i].isGreaterTPTPercent = true;
                                } else if(scmDataList[i].currentTPTPercent < scmDataList[i].previousTPTPercent){
                                    scmDataList[i].isLesserTPTPercent = true;
                                } else{
                                    scmDataList[i].isEqualTPTPercent = true;
                                }
                                noEffectList.push(scmDataList[i]);
                            }
                                else if(scmDataList[i].businessCategory == 'Open Status'){
                                    scmDataList[i].currentContractTotal = parseFloat(isNaN(scmDataList[i].awardedQty * scmDataList[i].currentDeadnet)? 0 :(scmDataList[i].awardedQty * scmDataList[i].currentDeadnet));
                                    scmDataList[i].previousContractTotal = parseFloat(isNaN(scmDataList[i].previousQty * scmDataList[i].previousDeadnet)? 0 :(scmDataList[i].previousQty * scmDataList[i].previousDeadnet));
                                    scmDataList[i].contractTotalCurrentTitle = 'Proposed Qty * Current Deadnet ('+scmDataList[i].awardedQty+'*'+scmDataList[i].currentDeadnet+')';
                                    scmDataList[i].contractTotalPreviousTitle = 'Previous Qty * Previous Deadnet ('+scmDataList[i].previousQty+'*'+((scmDataList[i].previousDeadnet != undefined)?scmDataList[i].previousDeadnet:0)+')';
                                    annualImpact = (scmDataList[i].currentContractTotal-(isNaN(scmDataList[i].previousContractTotal)?0:scmDataList[i].previousContractTotal));
                                    scmDataList[i].businessTitle = '(Annual Impact * Impacted Months)/12 [('+annualImpact+' * '+monthsRemaining.toFixed(2)+')/12]';
                                    scmDataList[i].annualImpact = annualImpact;
                                    previousTotalOS += ((isNaN(scmDataList[i].previousContractTotal) ? 0 : scmDataList[i].previousContractTotal));
                                    currentTotalOS += ((isNaN(scmDataList[i].currentContractTotal) ? 0 : scmDataList[i].currentContractTotal));
                                    totalAnnualImpactOS += ((isNaN(annualImpact) ? 0 : annualImpact));
                                    totalBusinessImpactOS += ((isNaN(businessImpact) ? 0 : businessImpact));
                                    currentTPTOS += ((isNaN(scmDataList[i].currentTPT) ? 0 : scmDataList[i].currentTPT));
                                    previousTPTOS += ((isNaN(scmDataList[i].previousTPT) ? 0 : scmDataList[i].previousTPT));
                                    priceVarianceOS += ((isNaN(scmDataList[i].priceVariance) ? 0 : scmDataList[i].priceVariance));
                                    volumeVarianceOS += ((isNaN(scmDataList[i].volumeVariance) ? 0 : scmDataList[i].volumeVariance));
                                    if(scmDataList[i].currentTPT > scmDataList[i].previousTPT){
                                        scmDataList[i].isGreaterTPT = true;
                                    } else if(scmDataList[i].currentTPT < scmDataList[i].previousTPT){
                                        scmDataList[i].isLesserTPT = true;
                                    } else{
                                        scmDataList[i].isEqualTPT = true;
                                    }
                                    if(scmDataList[i].currentTPTPercent > scmDataList[i].previousTPTPercent){
                                        scmDataList[i].isGreaterTPTPercent = true;
                                    } else if(scmDataList[i].currentTPTPercent < scmDataList[i].previousTPTPercent){
                                        scmDataList[i].isLesserTPTPercent = true;
                                    } else{
                                        scmDataList[i].isEqualTPTPercent = true;
                                    }
                                    openStatusList.push(scmDataList[i]);
                                }
                        }
                        if(scmDataList[i].awardedQty != null){
                            scmDataList[i].diffCombinedQtyDSH = scmDataList[i].awardedQty - (scmDataList[i].overrideCurrentDirectUnits + scmDataList[i].overrideCurrentIndirectUnits + scmDataList[i].overrideCurrentUnits);
                            scmDataList[i].diffCombinedQty = scmDataList[i].awardedQty - (scmDataList[i].overrideCurrentDirectUnits + scmDataList[i].overrideCurrentIndirectUnits);
                            if(scmDataList[i].previousQty != null)
                                scmDataList[i].diffQty = (scmDataList[i].awardedQty - scmDataList[i].previousQty).toLocaleString("en-US");
                            else
                                scmDataList[i].diffQty = (scmDataList[i].awardedQty).toLocaleString("en-US");
                        } else
                            scmDataList[i].diffQty = (0-scmDataList[i].previousQty).toLocaleString("en-US");
                        if(scmDataList[i].awardedPrice != null){
                            if(scmDataList[i].previousIndirectPrice != null)
                                scmDataList[i].diffIndirectPrice = Intl.NumberFormat('en-US', {style: "currency",currency: "USD"}).format(scmDataList[i].awardedPrice - scmDataList[i].previousIndirectPrice);
                            else
                                scmDataList[i].diffIndirectPrice = Intl.NumberFormat('en-US', {style: "currency",currency: "USD"}).format(scmDataList[i].awardedPrice);
                            
                        } else
                            scmDataList[i].diffIndirectPrice = Intl.NumberFormat('en-US', {style: "currency",currency: "USD"}).format(0-scmDataList[i].awardedPrice);
                        if(scmDataList[i].businessCategory != 'Business Gained' && scmDataList[i].businessCategory != 'No Effect' && scmDataList[i].businessCategory != 'Business Lost' && scmDataList[i].businessCategory != 'Open Status'){
                            if(scmDataList[i].currentDeadnet != scmDataList[i].previousDeadnet && scmDataList[i].awardedQty != scmDataList[i].previousQty){
                                bothList.push(scmDataList[i].bidLineItem.Id); 
                                if(scmDataList[i].category == 'Business Retained with Gains'){
                                    bothListRetainedWithGains.push(scmDataList[i].bidLineItem.Id);
                                } else if(scmDataList[i].category == 'Business Retained with Loss'){
                                    bothListRetainedWithLoss.push(scmDataList[i].bidLineItem.Id);
                                }
                            }
                            else if(scmDataList[i].currentDeadnet != scmDataList[i].previousDeadnet && !bothList.includes(scmDataList[i].bidLineItem.Id)){
                                priceChangeList.push(scmDataList[i].bidLineItem.Id);
                                if(scmDataList[i].category == 'Business Retained with Gains'){
                                    priceChangeListRetainedWithGains.push(scmDataList[i].bidLineItem.Id);
                                } else if(scmDataList[i].category == 'Business Retained with Loss'){
                                    priceChangeListRetainedWithLoss.push(scmDataList[i].bidLineItem.Id);
                                }
                            }
                                else if(scmDataList[i].awardedQty != scmDataList[i].previousQty && !bothList.includes(scmDataList[i].bidLineItem.Id)){
                                    volumeChangeList.push(scmDataList[i].bidLineItem.Id);
                                    if(scmDataList[i].category == 'Business Retained with Gains'){
                                        volumeChangeListRetainedWithGains.push(scmDataList[i].bidLineItem.Id);
                                    } else if(scmDataList[i].category == 'Business Retained with Loss'){
                                        volumeChangeListRetainedWithLoss.push(scmDataList[i].bidLineItem.Id);
                                    }
                                } else{
                                    if(!bothList.includes(scmDataList[i].bidLineItem.Id)){
                                        bothList.push(scmDataList[i].bidLineItem.Id);
                                        if(scmDataList[i].category == 'Business Retained with Gains'){
                                            bothListRetainedWithGains.push(scmDataList[i].bidLineItem.Id);
                                        } else if(scmDataList[i].category == 'Business Retained with Loss'){
                                            bothListRetainedWithLoss.push(scmDataList[i].bidLineItem.Id);
                                        }   
                                    }
                                }
                        }
                        if(scmDataList[i].currentDeadnet != null){
                            if(scmDataList[i].previousDeadnet != null)
                                scmDataList[i].diffDeadnet = Intl.NumberFormat('en-US', {style: "currency",currency: "USD"}).format(scmDataList[i].currentDeadnet - scmDataList[i].previousDeadnet);
                            else
                                scmDataList[i].diffDeadnet = Intl.NumberFormat('en-US', {style: "currency",currency: "USD"}).format(scmDataList[i].currentDeadnet);
                        } else
                            scmDataList[i].diffDeadnet = Intl.NumberFormat('en-US', {style: "currency",currency: "USD"}).format(0-scmDataList[i].currentDeadnet);
                        scmDataList[i].diffDirectPrice = Intl.NumberFormat('en-US', {style: "currency",currency: "USD"}).format((scmDataList[i].bidLineItem.Phoenix_ProposedContractBidPriceMktng__c == null ? 0:scmDataList[i].bidLineItem.Phoenix_ProposedContractBidPriceMktng__c)-scmDataList[i].bidLineItem.Phoenix_Current_Direct_Price__c);
                        scmDataList[i].diffNetIndirectPrice = Intl.NumberFormat('en-US', {style: "currency",currency: "USD"}).format((scmDataList[i].bidLineItem.Phoenix_Wholesaler_Diff_Price_Indirect__c == null ? 0:scmDataList[i].bidLineItem.Phoenix_Wholesaler_Diff_Price_Indirect__c)-scmDataList[i].bidLineItem.Phoenix_Current_Indirect_Price__c);
                        scmDataList[i].totalVariance = parseFloat(((isNaN(scmDataList[i].currentContractTotal) ? 0 : scmDataList[i].currentContractTotal))) - parseFloat(((isNaN(scmDataList[i].previousContractTotal) ? 0 : scmDataList[i].previousContractTotal)));
                        scmDataList[i].totalTPTVariance = parseFloat(scmDataList[i].currentTPT-scmDataList[i].previousTPT);
                    }
                    totalObj.totalCurrentFiscalImpact = parseFloat(totalCurrentFiscalImpact);
                    totalObj.totalProposedFiscalImpact = parseFloat(totalProposedFiscalImpact);
                    totalObj.salesFiscalVar = parseInt(totalProposedFiscalImpact-totalCurrentFiscalImpact);
                    totalObj.salesFiscalVarPer = parseFloat((totalObj.salesFiscalVar/totalObj.totalCurrentFiscalImpact)*100).toFixed(2);
                    totalObj.totalCurrentTPTFiscalImpact = parseFloat(totalCurrentTPTFiscalImpact);
                    totalObj.totalProposedTPTFiscalImpact = parseFloat(totalProposedTPTFiscalImpact);
                    totalObj.tptFiscalVar = parseInt(totalProposedTPTFiscalImpact-totalCurrentTPTFiscalImpact);
                    totalObj.tptFiscalVarPer = parseFloat((totalObj.tptFiscalVar/totalObj.totalCurrentTPTFiscalImpact)*100).toFixed(2);
                    
                    totalObj.awardedQtyChangesCount = volumeChangeList.length;
                    totalObj.deadnetChangesCount = priceChangeList.length;
                    totalObj.bothPriceAndVolumeChangesCount = bothList.length;
                    /*var totalAwards = (component.get("v.gainedList") != null ? component.get("v.gainedList").length : 0);
                    var percentNewAwards = (totalAwards/total)*100;
                    var percentLoss = (component.get("v.lossList").length/total)*100;
                    var percentNoEffects = (component.get("v.noEffectList").length/total)*100;
                    totalObj.totalAwards = totalAwards;
                    totalObj.percentNewAwards = percentNewAwards;
                    totalObj.percentLoss = percentLoss;
                    totalObj.percentNoEffects = percentNoEffects;*/
                    
                    totalObj.currentTotal = parseFloat(currentTotal);
                    totalObj.previousTotal = parseFloat(previousTotal);
                    totalObj.totalAnnualImpactBG = parseFloat(totalAnnualImpactBG); totalObj.totalBusinessImpactBG = parseFloat(totalBusinessImpactBG); totalObj.totalPreviousQtyBG = parseFloat(totalPreviousQtyBG); totalObj.totalQtyBG = parseFloat(totalQtyBG); totalObj.totalSCMApprovedQtyBG = totalSCMApprovedQtyBG; totalObj.previousTotalBG = previousTotalBG;totalObj.currentTotalBG = currentTotalBG;totalObj.currentTPTBG = parseFloat(currentTPTBG);totalObj.previousTPTBG =  parseFloat(previousTPTBG);totalObj.priceVarianceBG =  parseFloat(priceVarianceBG);totalObj.volumeVarianceBG =  parseFloat(volumeVarianceBG);totalObj.currentTPTPerBG = (!isFinite(totalObj.currentTPTBG/totalObj.currentTotalBG) ? 0 : (totalObj.currentTPTBG/totalObj.currentTotalBG));totalObj.previousTPTPerBG = (!isFinite(totalObj.previousTPTBG/totalObj.previousTotalBG) ? 0 : (totalObj.previousTPTBG/totalObj.previousTotalBG));
                    totalObj.totalAnnualImpactBGG = parseFloat(totalAnnualImpactBGG); totalObj.totalBusinessImpactBGG = parseFloat(totalBusinessImpactBGG); totalObj.totalPreviousQtyBGG = parseFloat(totalPreviousQtyBGG); totalObj.totalQtyBGG = parseFloat(totalQtyBGG); totalObj.totalSCMApprovedQtyBGG = totalSCMApprovedQtyBGG; totalObj.previousTotalBGG = previousTotalBGG;totalObj.currentTotalBGG = currentTotalBGG;totalObj.currentTPTBGG =  parseFloat(currentTPTBGG);totalObj.previousTPTBGG =  parseFloat(previousTPTBGG);totalObj.priceVarianceBGG =  parseFloat(priceVarianceBGG);totalObj.volumeVarianceBGG = parseFloat(volumeVarianceBGG);totalObj.currentTPTPerBGG = (!isFinite(totalObj.currentTPTBGG/currentTotalBGG) ? 0 : (totalObj.currentTPTBGG/currentTotalBGG));totalObj.previousTPTPerBGG = (!isFinite(totalObj.previousTPTBGG/previousTotalBGG) ? 0 : (totalObj.previousTPTBGG/previousTotalBGG));
                    totalObj.totalAnnualImpactBGL = parseFloat(totalAnnualImpactBGL); totalObj.totalBusinessImpactBGL = parseFloat(totalBusinessImpactBGL); totalObj.totalPreviousQtyBGL = parseFloat(totalPreviousQtyBGL); totalObj.totalQtyBGL = parseFloat(totalQtyBGL); totalObj.totalSCMApprovedQtyBGL = totalSCMApprovedQtyBGL; totalObj.previousTotalBGL = previousTotalBGL;totalObj.currentTotalBGL = currentTotalBGL;totalObj.currentTPTBGL =  parseFloat(currentTPTBGL);totalObj.previousTPTBGL =  parseFloat(previousTPTBGL);totalObj.priceVarianceBGL =  parseFloat(priceVarianceBGL);totalObj.volumeVarianceBGL =  parseFloat(volumeVarianceBGL);totalObj.currentTPTPerBGL = (!isFinite(totalObj.currentTPTBGL/currentTotalBGL) ? 0 : (totalObj.currentTPTBGL/currentTotalBGL));totalObj.previousTPTPerBGL = (!isFinite(totalObj.previousTPTBGL/previousTotalBGL) ? 0 : (totalObj.previousTPTBGL/previousTotalBGL));
                    totalObj.totalAnnualImpactNE = parseFloat(totalAnnualImpactNE); totalObj.totalBusinessImpactNE = parseFloat(totalBusinessImpactNE); totalObj.totalPreviousQtyNE = parseFloat(totalPreviousQtyNE); totalObj.totalQtyNE = parseFloat(totalQtyNE); totalObj.totalSCMApprovedQtyNE = totalSCMApprovedQtyNE; totalObj.previousTotalNE = previousTotalNE;totalObj.currentTotalNE = currentTotalNE;totalObj.currentTPTNE =  parseFloat(currentTPTNE);totalObj.previousTPTNE =  parseFloat(previousTPTNE);totalObj.priceVarianceNE =  parseFloat(priceVarianceNE);totalObj.volumeVarianceNE =  parseFloat(volumeVarianceNE);totalObj.currentTPTPerNE = (!isFinite(totalObj.currentTPTNE/currentTotalNE) ? 0 : (totalObj.currentTPTNE/currentTotalNE));totalObj.previousTPTPerNE = (!isFinite(totalObj.previousTPTNE/previousTotalNE) ? 0 : (totalObj.previousTPTNE/previousTotalNE));
                    totalObj.totalAnnualImpactOS = parseFloat(totalAnnualImpactOS); totalObj.totalBusinessImpactOS = parseFloat(totalBusinessImpactOS); totalObj.totalPreviousQtyOS = parseFloat(totalPreviousQtyOS); totalObj.totalQtyOS = parseFloat(totalQtyOS); totalObj.totalSCMApprovedQtyOS = totalSCMApprovedQtyOS; totalObj.previousTotalOS = previousTotalOS;totalObj.currentTotalOS = currentTotalOS;totalObj.currentTPTOS =  parseFloat(currentTPTOS);totalObj.previousTPTOS =  parseFloat(previousTPTOS);totalObj.priceVarianceOS =  parseFloat(priceVarianceOS);totalObj.volumeVarianceOS =  parseFloat(volumeVarianceOS);totalObj.currentTPTPerOS = (!isFinite(totalObj.currentTPTOS/currentTotalOS) ? 0 : (totalObj.currentTPTOS/currentTotalOS));totalObj.previousTPTPerOS = (!isFinite(totalObj.previousTPTOS/previousTotalOS) ? 0 : (totalObj.previousTPTOS/previousTotalOS));
                    totalObj.totalAnnualImpactBL = parseFloat(totalAnnualImpactBL); totalObj.totalBusinessImpactBL = parseFloat(totalBusinessImpactBL);
                    totalObj.totalAnnualImpactBLRFP = parseFloat(totalAnnualImpactBLRFP); totalObj.totalBusinessImpactBLRFP = parseFloat(totalBusinessImpactBLRFP);
                    totalObj.totalAnnualImpactBLRemovals = parseFloat(totalAnnualImpactBLRemovals); totalObj.totalBusinessImpactBLRemovals = parseFloat(totalBusinessImpactBLRemovals);
                    totalObj.totalAnnualImpactBLDiscontinuation = parseFloat(totalAnnualImpactBLDiscontinuation); totalObj.totalBusinessImpactBLDiscontinuation = parseFloat(totalBusinessImpactBLDiscontinuation);
                    totalObj.totalAnnualImpact = parseFloat((isNaN(totalAnnualImpactBG) ? 0: totalAnnualImpactBG) + (isNaN(totalAnnualImpactBGG) ? 0: totalAnnualImpactBGG) + (isNaN(totalAnnualImpactBGL) ? 0: totalAnnualImpactBGL) + (isNaN(totalAnnualImpactBL) ? 0: totalAnnualImpactBL)); // + (isNaN(totalAnnualImpactNE) ? 0: totalAnnualImpactNE)
                    totalObj.totalPreviousQtyBLRFP =  parseFloat(totalPreviousQtyBLRFP); totalObj.totalQtyBLRFP = parseFloat(totalQtyBLRFP);
                    totalObj.currentTotalBLRFP = parseFloat(currentTotalBLRFP); totalObj.previousTotalBLRFP = parseFloat(previousTotalBLRFP);
                    totalObj.tptVarianceBLRFP = parseFloat(tptVarianceBLRFP); totalObj.priceVarianceBLRFP = parseFloat(priceVarianceBLRFP); totalObj.volumeVarianceBLRFP = parseFloat(volumeVarianceBLRFP);
                    totalObj.previousTPTBLRFP = parseFloat(previousTPTBLRFP); totalObj.currentTPTBLRFP = parseFloat(currentTPTBLRFP); totalObj.priceVarianceBLRFP = parseFloat(priceVarianceBLRFP);
                    totalObj.volumeVarianceBLRFP = parseFloat(volumeVarianceBLRFP); totalObj.totalVarianceBLRFP = parseFloat(totalVarianceBLRFP); totalObj.tptVarianceBLRFP = parseFloat(tptVarianceBLRFP);
                    totalObj.currentTPTPerBLRFP = (!isFinite(totalObj.currentTPTBLRFP/totalObj.currentTotalBLRFP) ? 0 : (totalObj.currentTPTBLRFP/totalObj.currentTotalBLRFP));totalObj.previousTPTPerBLRFP = (!isFinite(totalObj.previousTPTBLRFP/totalObj.previousTotalBLRFP) ? 0 : (totalObj.previousTPTBLRFP/totalObj.previousTotalBLRFP));
                    totalObj.totalBusinessImpact = parseFloat((isNaN(totalBusinessImpactBG) ? 0: totalBusinessImpactBG) + (isNaN(totalBusinessImpactBGG) ? 0: totalBusinessImpactBGG) + (isNaN(totalBusinessImpactBGL) ? 0: totalBusinessImpactBGL) + (isNaN(totalBusinessImpactBL) ? 0: totalBusinessImpactBL)); // + (isNaN(totalBusinessImpactNE) ? 0: totalBusinessImpactNE)
                    totalObj.totalPreviousTotal = parseFloat((isNaN(previousTotalBG) ? 0: previousTotalBG) + (isNaN(previousTotalBGG) ? 0: previousTotalBGG) + (isNaN(previousTotalBGL) ? 0: previousTotalBGL) + (isNaN(previousTotalBL) ? 0: previousTotalBL)); // + (isNaN(previousTotalNE) ? 0: previousTotalNE)
                    component.set("v.actualSales", totalObj.totalPreviousTotal);
                    totalObj.totalCurrentTotal = parseFloat((isNaN(currentTotalBG) ? 0: currentTotalBG) + (isNaN(currentTotalBGG) ? 0: currentTotalBGG) + (isNaN(currentTotalBGL) ? 0: currentTotalBGL) + (isNaN(currentTotalBL) ? 0: currentTotalBL)); // + (isNaN(currentTotalNE) ? 0: currentTotalNE)
                    totalObj.totalCurrentTotalTitle = '('+(isNaN(currentTotalBG) ? 0: currentTotalBG.toFixed())+') + (' + (isNaN(currentTotalBGG) ? 0: currentTotalBGG.toFixed())+') + (' + (isNaN(currentTotalBGL) ? 0: currentTotalBGL.toFixed())+') + ('+ (isNaN(currentTotalBL) ? 0: currentTotalBL.toFixed())+')';
                    totalObj.totalPreviousTotalTitle = '('+(isNaN(previousTotalBG) ? 0: previousTotalBG.toFixed())+') + (' + (isNaN(previousTotalBGG) ? 0: previousTotalBGG.toFixed())+') + (' + (isNaN(previousTotalBGL) ? 0: previousTotalBGL.toFixed())+') + ('+ (isNaN(previousTotalBL) ? 0: previousTotalBL.toFixed())+')'; // + (' + (isNaN(previousTotalNE) ? 0: previousTotalNE.toFixed())+')';
                    totalObj.percentageChange = (((totalObj.totalCurrentTotal - totalObj.totalPreviousTotal) / totalObj.totalPreviousTotal)*100).toFixed(2);
                    totalObj.change = parseInt((totalObj.totalCurrentTotal - totalObj.totalPreviousTotal));
                    totalObj.previousTPT = previousTPTBG + previousTPTBGG + previousTPTBGL + previousTPTBLRFP;
                    totalObj.currentTPT = currentTPTBG + currentTPTBGG + currentTPTBGL + currentTPTBLRFP;
                    totalObj.previousTPTPer = totalObj.previousTPT/(totalObj.totalPreviousTotal);
                    if(isNaN(totalObj.previousTPT/(totalObj.totalPreviousTotal))){
                        totalObj.isPreviousTPTPerNaN = true;
                    } else{
                        totalObj.isPreviousTPTPerNaN = false;
                    }
                    totalObj.currentTPTPer = totalObj.currentTPT/(totalObj.totalCurrentTotal);
                    if(isNaN(totalObj.currentTPT/(totalObj.totalCurrentTotal))){
                        totalObj.isCurrentTPTPerNaN = true;
                    } else{
                        totalObj.isCurrentTPTPerNaN = false;
                    }
                    totalObj.tptVariance = totalObj.currentTPT - totalObj.previousTPT;
                    totalObj.tptVariancePer = (((totalObj.currentTPT - totalObj.previousTPT) / totalObj.previousTPT)*100).toFixed(2);
                    totalObj.priceVariance = (priceVarianceBG+priceVarianceBGG+priceVarianceBGL+priceVarianceBL);
                    totalObj.volumeVariance = (volumeVarianceBG+volumeVarianceBGG+volumeVarianceBGL+volumeVarianceBL);
                    totalObj.percentageChangeTitle = '('+totalObj.totalCurrentTotal.toFixed()+' - '+totalObj.totalPreviousTotal.toFixed()+') / '+totalObj.totalPreviousTotal.toFixed();
                    totalObj.changeTitle = '('+totalObj.totalCurrentTotal.toFixed()+' - '+totalObj.totalPreviousTotal.toFixed()+')';
                    if(totalObj.percentageChange == 'Infinity' || isNaN(totalObj.percentageChange))
                        totalObj.isPercentPositive = 'Infinity';
                    else{
                        if(totalObj.percentageChange == 0 || totalObj.percentageChange == null)
                            totalObj.isPercentPositive = 'Zero';
                        else if(totalObj.percentageChange > 0)
                            totalObj.isPercentPositive = 'percentPositive';
                            else if(totalObj.percentageChange < 0 && totalObj.percentageChange != -1.00)
                                totalObj.isPercentPositive = 'percentNegative';
                                else if(totalObj.percentageChange == -1.00)
                                    totalObj.isPercentPositive = 'showN/A';
                    }
                    totalObj.totalLines = scmDataList.length;
                    component.set("v.isSCMApprovePerson",scmDataList[0].isSCMApprovePerson);
                    /*if(scmDataList[0].businessCategory == 'Business Lost'){
                        component.set("v.totalLineItems", 0);
                    } else{*/
                    component.set("v.totalLineItems", scmDataList.length);
                    totalObj.totalAnnualImpactTitle = '('+(isNaN(totalAnnualImpactBG) ? 0: totalAnnualImpactBG.toFixed())+') + (' + (isNaN(totalAnnualImpactBGG) ? 0: totalAnnualImpactBGG.toFixed())+') + (' + (isNaN(totalAnnualImpactBGL) ? 0: totalAnnualImpactBGL.toFixed())+')'; // + (' + (isNaN(totalAnnualImpactNE) ? 0: totalAnnualImpactNE.toFixed())+')
                    totalObj.totalBusinessImpactTitle = '('+(isNaN(totalBusinessImpactBG) ? 0: totalBusinessImpactBG.toFixed())+') + (' + (isNaN(totalBusinessImpactBGG) ? 0: totalBusinessImpactBGG.toFixed())+') + (' + (isNaN(totalBusinessImpactBGL) ? 0: totalBusinessImpactBGL.toFixed())+')'; // + (' + (isNaN(totalBusinessImpactNE) ? 0: totalBusinessImpactNE.toFixed())+')
                    //}
                    var total = component.get("v.totalLineItems");
                    totalObj.percentPriceChanges = (totalObj.deadnetChangesCount/total)*100;
                    totalObj.percentQtyChanges = (totalObj.awardedQtyChangesCount/total)*100;
                    totalObj.percentBothChanges = (totalObj.bothPriceAndVolumeChangesCount/total)*100;
                    
                    totalObj.bothListRetainedWithGains = bothListRetainedWithGains.length;
                    totalObj.percentBothListRetainedWithGains = (totalObj.bothListRetainedWithGains/total)*100;
                    totalObj.bothListRetainedWithLoss = bothListRetainedWithLoss.length;
                    totalObj.percentBothListRetainedWithLoss = (totalObj.bothListRetainedWithLoss/total)*100;
                    
                    totalObj.priceChangeListRetainedWithGains = priceChangeListRetainedWithGains.length;
                    totalObj.percentPriceChangeListRetainedWithGains = (totalObj.priceChangeListRetainedWithGains/total)*100;
                    totalObj.priceChangeListRetainedWithLoss = priceChangeListRetainedWithLoss.length;
                    totalObj.percentPriceChangeListRetainedWithLoss = (totalObj.priceChangeListRetainedWithLoss/total)*100;
                    
                    totalObj.volumeChangeListRetainedWithGains = volumeChangeListRetainedWithGains.length;
                    totalObj.percentVolumeChangeListRetainedWithGains = (totalObj.volumeChangeListRetainedWithGains/total)*100;
                    totalObj.volumeChangeListRetainedWithLoss = volumeChangeListRetainedWithLoss.length;
                    totalObj.percentVolumeChangeListRetainedWithLoss = (totalObj.volumeChangeListRetainedWithLoss/total)*100;
                    //component.set("v.categoryTotals", totalObj);
                    
                    component.set("v.gainedList", []);
                    component.set("v.removalsLossList", []);
                    component.set("v.discontinuationLossList", []);
                    component.set("v.RFPLossList", []);
                    component.set("v.noEffectList", []);
                    var currentTabId = component.get("v.currentTabId");
                    var gain = []; var lost = []; var open = []; var noEffect = []; var retained = []; var rfplost =[];
                    if(currentTabId == 'tabThree'){
                        var totalMap = {};
                        var totalFamilySummaryMap = {}; var totalPreviousQty = 0; var totalAwardedQty = 0; var totalPreviousTotal = 0; var totalCurrentTotal = 0;
                        var totalAnnualImpact = 0; var totalBusinessImpact = 0; var totalCurrentTPT = 0; var totalPreviousTPT = 0; var totalCurrentTPTPer = 0; var totalPreviousTPTPer = 0;
                        var totalPriceVariance = 0; var totalVolumeVariance = 0; var total = 0; var totalTPT = 0;
                        scmDataList.forEach(function(rec){
                            if(rec.businessCategory == 'Business Gained'){
                                if(rec.productFamily == 'Fluconazole Tabs'){
                                    console.log('Product to Customer - Product: '+rec.productName);
                                    console.log('Its Category: '+rec.businessCategory);
                                }	
                                gain.push(rec);
                            } else if(rec.businessCategory == 'Business Lost'){
                                lost.push(rec);
                            } else if(rec.businessCategory == 'Open Status'){
                                open.push(rec);
                            } else if(rec.businessCategory == 'No Effect'){
                                noEffect.push(rec);
                            }
                            if(rec.businessCategory == 'Business Retained') retained.push(rec);
                            if(rec.businessCategory == 'Business Lost') {
                                if(rec.bidType == 'RFP Bids') rfplost.push(rec);                                
                            }
                            if((rec.bidType != 'RFP Bids' && (rec.bidStatus == 'Declined by Customer' || rec.bidStatus == 'DRL Rescinded' || rec.bidStatus == 'DRL submitting under New Bid Number')) || rec.businessCategory == 'No Effect'){
                                
                            }else{
                                if(rec.bidStatus != 'DRL submitting under New Bid Number'){
                                    if(rec.previousQty == null){
                                        rec.previousQty = 0;
                                    }
                                    totalPreviousQty += ((isNaN(rec.previousQty) ? 0 : parseInt(rec.previousQty)));
                                    totalAwardedQty += ((isNaN(rec.awardedQty) ? 0 : parseInt(rec.awardedQty)));
                                    totalPreviousTotal += ((isNaN(rec.previousContractTotal) ? 0 : parseFloat(rec.previousContractTotal)));
                                    totalCurrentTotal += ((isNaN(rec.currentContractTotal) ? 0 : parseFloat(rec.currentContractTotal)));
                                    totalAnnualImpact += ((isNaN(rec.annualImpact) ? 0 : parseFloat(rec.annualImpact)));
                                    totalBusinessImpact += ((isNaN(rec.businessImpact) ? 0 : parseFloat(rec.businessImpact)));
                                    totalPreviousTPT += ((isNaN(rec.previousTPT) ? 0 : parseFloat(rec.previousTPT)));
                                    totalCurrentTPT += ((isNaN(rec.currentTPT) ? 0 : parseFloat(rec.currentTPT)));
                                    totalPriceVariance += ((isNaN(rec.priceVariance) ? 0 : parseFloat(rec.priceVariance)));
                                    totalVolumeVariance += ((isNaN(rec.volumeVariance) ? 0 : parseFloat(rec.volumeVariance)));
                                }
                            }
                            if(totalMap.hasOwnProperty(rec.productFamily)){
                                var relatedList = totalMap[rec.productFamily]; var summary = [];
                                relatedList.push(rec);
                                totalMap[rec.productFamily] = relatedList;
                                var previousTotal = 0; var currentTotal = 0; var annualImapact = 0; var businessImpact = 0; var previousTPT = 0; var currentTPT = 0;
                                var previousTPTFamilySummary = 0; var currentTPTFamilySummary = 0; var priceVarianceFamilySummary = 0; var volumeVarianceFamilySummary = 0;
                                var totalVarianceFamilySummary = 0; var tptVarianceFamilySummary = 0;var totalPreviousAwdQtySummary = 0; var totalAwdQtySummary = 0;
                                for(var i=0; i<relatedList.length; i++){
                                    if((relatedList[i].bidType != 'RFP Bids' && (relatedList[i].bidStatus == 'Declined by Customer' || relatedList[i].bidStatus == 'DRL Rescinded' || relatedList[i].bidStatus == 'DRL submitting under New Bid Number')) || relatedList[i].businessCategory == 'No Effect'){
                                        
                                    } /*else if(relatedList[i].bidType == 'RFP Bids' && (relatedList[i].bidStatus == 'Declined by Customer' || relatedList[i].bidStatus == 'DRL Rescinded')){
                                        previousTotal -= ((isNaN(relatedList[i].previousContractTotal) ? 0 : relatedList[i].previousContractTotal));
                                        currentTotal -= ((isNaN(relatedList[i].currentContractTotal) ? 0 : relatedList[i].currentContractTotal));
                                        annualImapact -= ((isNaN(relatedList[i].annualImpact) ? 0 : relatedList[i].annualImpact));
                                        businessImpact -= ((isNaN(relatedList[i].businessImpact) ? 0 : relatedList[i].businessImpact));   
                                        previousTPT -= ((isNaN(relatedList[i].previousTPT) ? 0 : relatedList[i].previousTPT));
                                        currentTPT -= ((isNaN(relatedList[i].currentTPT) ? 0 : relatedList[i].currentTPT));
                                        priceVarianceFamilySummary -= ((isNaN(relatedList[i].priceVariance) ? 0 : relatedList[i].priceVariance));
                                        volumeVarianceFamilySummary -= ((isNaN(relatedList[i].volumeVariance) ? 0 : relatedList[i].volumeVariance));
                                        totalPreviousAwdQtySummary -= ((isNaN(relatedList[i].previousQty) ? 0 : relatedList[i].previousQty));
                                        totalAwdQtySummary -= ((isNaN(relatedList[i].awardedQty) ? 0 : relatedList[i].awardedQty));   
                                    }*/
                                    else{
                                        if(relatedList[i].bidStatus != 'DRL submitting under New Bid Number'){
                                            previousTotal += ((isNaN(relatedList[i].previousContractTotal) ? 0 : parseFloat(relatedList[i].previousContractTotal)));
                                            currentTotal += ((isNaN(relatedList[i].currentContractTotal) ? 0 : parseFloat(relatedList[i].currentContractTotal)));
                                            annualImapact += ((isNaN(relatedList[i].annualImpact) ? 0 : parseInt(relatedList[i].annualImpact)));
                                            businessImpact += ((isNaN(relatedList[i].businessImpact) ? 0 : parseInt(relatedList[i].businessImpact)));   
                                            previousTPT += ((isNaN(relatedList[i].previousTPT) ? 0 : parseFloat(relatedList[i].previousTPT)));
                                            currentTPT += ((isNaN(relatedList[i].currentTPT) ? 0 : parseFloat(relatedList[i].currentTPT)));
                                            priceVarianceFamilySummary += ((isNaN(relatedList[i].priceVariance) ? 0 : parseFloat(relatedList[i].priceVariance)));
                                            volumeVarianceFamilySummary += ((isNaN(relatedList[i].volumeVariance) ? 0 : parseFloat(relatedList[i].volumeVariance)));
                                            if(relatedList[i].previousQty != null){
                                                totalPreviousAwdQtySummary += ((isNaN(relatedList[i].previousQty) ? 0 : parseFloat(relatedList[i].previousQty)));
                                            } else{
                                                relatedList[i].previousQty = 0;
                                                totalPreviousAwdQtySummary += 0;
                                            }
                                            totalAwdQtySummary += ((isNaN(relatedList[i].awardedQty) ? 0 : parseFloat(relatedList[i].awardedQty)));      
                                        }
                                    }
                                }
                                /*totalPreviousQty += ((isNaN(rec.previousQty) ? 0 : parseFloat(rec.previousQty))); 
                                totalAwardedQty += ((isNaN(rec.awardedQty) ? 0 : parseFloat(rec.awardedQty)));
                                totalPreviousTotal += ((isNaN(rec.previousContractTotal) ? 0 : parseFloat(rec.previousContractTotal)));
                                totalCurrentTotal += ((isNaN(rec.currentContractTotal) ? 0 : parseFloat(rec.currentContractTotal)));
                                totalAnnualImpact += ((isNaN(rec.annualImpact) ? 0 : parseInt(rec.annualImpact)));
                                totalBusinessImpact += ((isNaN(rec.businessImpact) ? 0 : parseInt(rec.businessImpact)));
                                totalCurrentTPT += ((isNaN(rec.currentTPT) ? 0 : parseFloat(rec.currentTPT)));
                                totalPreviousTPT += ((isNaN(rec.previousTPT) ? 0 : parseFloat(rec.previousTPT)));
                                totalPriceVariance += ((isNaN(rec.priceVariance) ? 0 : parseFloat(rec.priceVariance)));
                                totalVolumeVariance += ((isNaN(rec.volumeVariance) ? 0 : parseFloat(rec.volumeVariance)));*/
                                total += parseInt(annualImpact);
                                totalTPT = parseFloat(currentTPT) - parseFloat(previousTPT);
                                summary[0] = parseInt(previousTotal);
                                summary[1] = parseInt(currentTotal);
                                summary[2] = parseInt(annualImapact);
                                summary[3] = parseInt(businessImpact);
                                summary[4] = parseInt(previousTPT);
                                summary[5] = parseInt(currentTPT);
                                summary[6] = parseInt(parseFloat(currentTPT) - parseFloat(previousTPT));
                                summary[7] = parseInt(priceVarianceFamilySummary);
                                summary[8] = parseInt(volumeVarianceFamilySummary);
                                summary[9] = ((!isFinite(previousTPT/previousTotal) ? 0 : (previousTPT/previousTotal)));
                                summary[10] = ((!isFinite(currentTPT/currentTotal) ? 0 : (currentTPT/currentTotal)));
                                summary[11] = parseInt(totalPreviousAwdQtySummary);
                                summary[12] = parseInt(totalAwdQtySummary); 
                                totalFamilySummaryMap[rec.productFamily] = summary;
                            } 
                            else{
                                var relatedList = [];var summary = [];
                                relatedList.push(rec);
                                totalMap[rec.productFamily] = relatedList;
                                var previousTotal = ((isNaN(rec.previousContractTotal) ? 0 : parseFloat(rec.previousContractTotal)));
                                var currentTotal = ((isNaN(rec.currentContractTotal) ? 0 : parseFloat(rec.currentContractTotal)));
                                var annualImpact = ((isNaN(rec.annualImpact) ? 0 : parseInt(rec.annualImpact)));
                                var businessImpact = ((isNaN(rec.businessImpact) ? 0 : parseInt(rec.businessImpact)));
                                var previousTPT = ((isNaN(rec.previousTPT) ? 0 : parseFloat(rec.previousTPT)));
                                var currentTPT = ((isNaN(rec.currentTPT) ? 0 : parseFloat(rec.currentTPT)));
                                var priceVarianceFamilySummary = ((isNaN(rec.priceVariance) ? 0 : parseFloat(rec.priceVariance)));
                                var volumeVarianceFamilySummary = ((isNaN(rec.volumeVariance) ? 0 : parseFloat(rec.volumeVariance)));
                                var totalPreviousAwdQtySummary = ((isNaN(rec.previousQty) ? 0 : parseFloat(rec.previousQty)));
                                var totalAwdQtySummary = ((isNaN(rec.awardedQty) ? 0 : parseFloat(rec.awardedQty)));
                                /*if(rec.bidType != 'RFP Bids' && (rec.bidStatus == 'Declined by Customer' || rec.bidStatus == 'DRL Rescinded' || rec.bidStatus == 'DRL submitting under New Bid Number')){
                                }
                                else{
                                    if(rec.bidStatus != 'DRL submitting under New Bid Number'){
                                        if(rec.previousQty != null){
                                            totalPreviousQty += parseFloat(totalPreviousAwdQtySummary);
                                        } else{
                                            rec.previousQty = 0;
                                            totalPreviousQty += 0;
                                        }
                                        totalAwardedQty += parseFloat(totalAwdQtySummary);
                                        totalPreviousTotal += parseFloat(previousTotal);
                                        totalCurrentTotal += parseFloat(currentTotal);
                                        totalAnnualImpact += parseInt(annualImpact);
                                        totalBusinessImpact += parseFloat(businessImpact);
                                        totalCurrentTPT += parseFloat(currentTPT);
                                        totalPreviousTPT += parseFloat(previousTPT);
                                        totalPriceVariance += parseFloat(priceVarianceFamilySummary);
                                        totalVolumeVariance += parseFloat(volumeVarianceFamilySummary); 
                                        total += parseInt(annualImpact);
                                        totalTPT = parseFloat(currentTPT) - parseFloat(previousTPT);    
                                    }  
                                }*/
                                summary[0] = parseInt(previousTotal);
                                summary[1] = parseInt(currentTotal);
                                summary[2] = parseInt(annualImpact);
                                summary[3] = parseInt(businessImpact);
                                summary[4] = parseInt(previousTPT);
                                summary[5] = parseInt(currentTPT);
                                summary[6] = parseInt(parseFloat(currentTPT) - parseFloat(previousTPT));
                                summary[7] = parseInt(priceVarianceFamilySummary);
                                summary[8] = parseInt(volumeVarianceFamilySummary);
                                summary[9] = ((!isFinite(previousTPT/previousTotal) ? 0 : (previousTPT/previousTotal)));
                                summary[10] = ((!isFinite(currentTPT/currentTotal) ? 0 : (currentTPT/currentTotal)));
                                summary[11] = parseInt(totalPreviousAwdQtySummary);
                                summary[12] = parseInt(totalAwdQtySummary);
                                totalFamilySummaryMap[rec.productFamily] = summary;
                            }
                        });
                        var tempObj = {};
                        let keys = Object.keys(totalFamilySummaryMap);
                        keys.sort(function(a, b) { return totalFamilySummaryMap[b][2] - totalFamilySummaryMap[a][2] });
                        var totalPreviousTotalFinal = 0; var totalCurrentTotalFinal = 0; var totalAnnualImpactFinal = 0; var totalFiscalImpactFinal = 0;
                        var totalPreviousTPTFinal = 0; var totalCurrentTPTFinal = 0; var totalTPTDiffFinal = 0; var totalPriceVarianceFinal = 0;
                        var totalVolumeVarianceFinal = 0; var totalPreviousQtyFinal = 0; var totalAwardedQtyFinal = 0;
                        for(var i=0; i<keys.length; i++){
                            tempObj[keys[i]] = totalFamilySummaryMap[keys[i]];
                            totalPreviousTotalFinal += totalFamilySummaryMap[keys[i]][0];
                            totalCurrentTotalFinal += totalFamilySummaryMap[keys[i]][1];
                            totalAnnualImpactFinal += totalFamilySummaryMap[keys[i]][2];
                            totalFiscalImpactFinal += totalFamilySummaryMap[keys[i]][3];
                            totalPreviousTPTFinal += totalFamilySummaryMap[keys[i]][4];
                            totalCurrentTPTFinal += totalFamilySummaryMap[keys[i]][5];
                            totalTPTDiffFinal += totalFamilySummaryMap[keys[i]][6];
                            totalPriceVarianceFinal += totalFamilySummaryMap[keys[i]][7];
                            totalVolumeVarianceFinal += totalFamilySummaryMap[keys[i]][8];
                            totalPreviousQtyFinal += totalFamilySummaryMap[keys[i]][11];
                            totalAwardedQtyFinal += totalFamilySummaryMap[keys[i]][12];
                        }
                        totalFamilySummaryMap = tempObj;
                        tempObj = {};
                        
                        let sortedKeys = Object.keys(totalFamilySummaryMap);
                        for(var i=0; i<sortedKeys.length; i++){
                            tempObj[sortedKeys[i]] = totalMap[sortedKeys[i]];
                        }
                        totalMap = tempObj;
                        
                        /*totalObj.totalPreviousQty = totalPreviousQtyFinal;
                        console.log('totalPreviousTotalFinal: '+totalPreviousTotalFinal);
                        totalObj.totalAwardedQty = totalAwardedQtyFinal;
                        totalObj.totalPreviousTotal = totalPreviousTotalFinal;
                        totalObj.totalCurrentTotal = totalCurrentTotalFinal;
                        totalObj.totalCurrentTPT = parseFloat(totalCurrentTPTFinal);
                        totalObj.totalPreviousTPT =  parseFloat(totalPreviousTPTFinal);
                        totalObj.totalPriceVariance =  parseFloat(totalPriceVarianceFinal);
                        totalObj.totalVolumeVariance =  parseFloat(totalVolumeVarianceFinal);
                        totalObj.currentTPTPer = (!isFinite(totalObj.totalCurrentTPT/totalObj.totalCurrentTotal) ? 0 : (totalObj.totalCurrentTPT/totalObj.totalCurrentTotal));
                        totalObj.previousTPTPer = (!isFinite(totalObj.totalPreviousTPT/totalObj.totalPreviousTotal) ? 0 : (totalObj.totalPreviousTPT/totalObj.totalPreviousTotal));*/
                        
                        var totalAwards = (gain != null ? gain.length : 0);
                        var percentNewAwards = (totalAwards/scmDataList.length)*100;
                        var percentLoss = (lost.length/scmDataList.length)*100;
                        var percentNoEffects = (noEffect.length/scmDataList.length)*100;
                        var percentOpen = (open.length/scmDataList.length)*100;
                        totalObj.totalAwards = totalAwards;
                        totalObj.percentNewAwards = percentNewAwards;
                        totalObj.percentLoss = percentLoss;
                        totalObj.percentNoEffects = percentNoEffects;
                        totalObj.percentOpen = percentOpen;
                        totalObj.priceVariance = parseInt(totalPriceVariance);
                        totalObj.volumeVariance = parseInt(totalVolumeVariance);
                        totalObj.totalPreviousQty = parseInt(totalPreviousQty);
                        totalObj.totalAwardedQty = parseInt(totalAwardedQty);
                        /*totalObj.totalPreviousQty = parseInt(totalPreviousQty);
                        totalObj.totalAwardedQty = parseInt(totalPreviousQty);*/
                        /*totalObj.totalPreviousTotal = parseInt(totalPreviousTotal);
                        totalObj.totalCurrentTotal = parseInt(totalCurrentTotal);
                        totalObj.totalAnnualImpact = parseInt((totalCurrentTotal - totalPreviousTotal));
                        totalObj.change = totalObj.totalAnnualImpact;
                        totalObj.totalBusinessImpact = parseInt(totalBusinessImpact);
                        totalObj.totalCurrentTPT = parseInt(totalCurrentTPT);
                        totalObj.totalPreviousTPT = parseInt(totalPreviousTPT);
                        totalObj.totalPriceVariance = parseInt(totalPriceVariance);
                        totalObj.totalVolumeVariance = parseInt(totalVolumeVariance);
                        totalObj.currentTPTPer = (!isFinite(totalObj.totalCurrentTPT/totalObj.totalCurrentTotal) ? 0 : (totalObj.totalCurrentTPT/totalObj.totalCurrentTotal));
                        totalObj.previousTPTPer = (!isFinite(totalObj.totalPreviousTPT/totalObj.totalPreviousTotal) ? 0 : (totalObj.totalPreviousTPT/totalObj.totalPreviousTotal));
                        */
                        component.set("v.gainedList", gain);
                        component.set("v.lossList", lost);
                        component.set("v.openStatusList", open);
                        component.set("v.noEffectList", noEffect);
                        component.set("v.totalFamilySummaryMap",totalFamilySummaryMap);
                        component.set("v.totalMap",Object.entries(totalMap));
                        component.set("v.scmDataList", scmDataList);
                        component.set("v.categoryTotals", totalObj);
                        console.log('totalObj: '+JSON.stringify(totalObj));
                        var gainValues = [];
                        if(gain != null) {
                            for(var i=0; i<gain.length; i++){
                                gainValues.push(gain[i].currentContractTotal);
                            }
                        }
                    } 
                    else{
                        var gainedMap = {};
                        var gainedFamilySummaryMap = {}; var totalPreviousQtyBG = 0; var totalAwardedQtyBG = 0;
                        var totalPreviousQty = 0; var totalAwardedQty = 0; var totalPreviousTotal = 0; var totalCurrentTotal = 0;
                        var totalAnnualImpact = 0; var totalBusinessImpact = 0; var totalCurrentTPT = 0; var totalPreviousTPT = 0;
                        var totalCurrentTPTPer = 0; var totalPreviousTPTPer = 0;
                        var totalPriceVariance = 0; var totalVolumeVariance = 0; var total = 0; var totalTPT = 0;
                        gainedList.forEach(function(rec){
                            if(rec.productFamily == 'Fluconazole Tabs'){
                                console.log('Analysis by Filter - Product: '+rec.productName);
                            }	
                            totalPriceVariance += ((isNaN(rec.priceVariance) ? 0 : parseFloat(rec.priceVariance)));
                            totalVolumeVariance += ((isNaN(rec.volumeVariance) ? 0 : parseFloat(rec.volumeVariance)));
                            totalAwardedQty += ((isNaN(rec.awardedQty) ? 0 : parseFloat(rec.awardedQty)));
                            totalPreviousQty += ((isNaN(rec.previousQty) ? 0 : parseFloat(rec.previousQty)));
                            totalAwardedQtyBG += ((isNaN(rec.awardedQty) ? 0 : parseFloat(rec.awardedQty)));
                            totalPreviousQtyBG += ((isNaN(rec.previousQty) ? 0 : parseFloat(rec.previousQty)));
                            if(gainedMap.hasOwnProperty(rec.productFamily)){
                                var relatedList = gainedMap[rec.productFamily]; var summary = [];
                                relatedList.push(rec);
                                gainedMap[rec.productFamily] = relatedList;
                                var previousTotal = 0; var currentTotal = 0; var annualImapact = 0; var businessImpact = 0; var previousTPT = 0; var currentTPT = 0;
                                var previousTPTFamilySummary = 0; var currentTPTFamilySummary = 0; var priceVarianceFamilySummary = 0; var volumeVarianceFamilySummary = 0;
                                var totalVarianceFamilySummary = 0; var tptVarianceFamilySummary = 0;var totalPreviousAwdQtySummary = 0; var totalAwdQtySummary = 0;
                                for(var i=0; i<relatedList.length; i++){
                                    previousTotal += ((isNaN(relatedList[i].previousContractTotal) ? 0 : relatedList[i].previousContractTotal));
                                    currentTotal += ((isNaN(relatedList[i].currentContractTotal) ? 0 : relatedList[i].currentContractTotal));
                                    annualImapact += ((isNaN(relatedList[i].annualImpact) ? 0 : relatedList[i].annualImpact));
                                    businessImpact += ((isNaN(relatedList[i].businessImpact) ? 0 : relatedList[i].businessImpact));   
                                    previousTPT += ((isNaN(relatedList[i].previousTPT) ? 0 : relatedList[i].previousTPT));
                                    currentTPT += ((isNaN(relatedList[i].currentTPT) ? 0 : relatedList[i].currentTPT));
                                    priceVarianceFamilySummary += ((isNaN(relatedList[i].priceVariance) ? 0 : relatedList[i].priceVariance));
                                    volumeVarianceFamilySummary += ((isNaN(relatedList[i].volumeVariance) ? 0 : relatedList[i].volumeVariance));
                                    totalPreviousAwdQtySummary += ((isNaN(relatedList[i].previousQty) ? 0 : relatedList[i].previousQty));
                                    totalAwdQtySummary += ((isNaN(relatedList[i].awardedQty) ? 0 : relatedList[i].awardedQty));
                                }
                                /*totalPreviousQtyBG += totalPreviousAwdQtySummary;
                                totalAwardedQtyBG += totalAwdQtySummary;*/
                                summary[0] = parseInt(previousTotal);
                                summary[1] = parseInt(currentTotal);
                                summary[2] = parseInt(annualImapact);
                                summary[3] = parseInt(businessImpact);
                                summary[4] = parseInt(previousTPT);
                                summary[5] = parseInt(currentTPT);
                                summary[6] = parseInt(parseFloat(currentTPT) - parseFloat(previousTPT));
                                summary[7] = parseInt(priceVarianceFamilySummary);
                                summary[8] = parseInt(volumeVarianceFamilySummary);
                                summary[9] = ((!isFinite(previousTPT/previousTotal) ? 0 : (previousTPT/previousTotal)));
                                summary[10] = ((!isFinite(currentTPT/currentTotal) ? 0 : (currentTPT/currentTotal)));
                                summary[11] = parseInt(totalPreviousAwdQtySummary);
                                summary[12] = parseInt(totalAwdQtySummary);
                                gainedFamilySummaryMap[rec.productFamily] = summary;
                            } else{
                                var relatedList = [];var summary = [];
                                relatedList.push(rec);
                                gainedMap[rec.productFamily] = relatedList;
                                var previousTotal = ((isNaN(rec.previousContractTotal) ? 0 : rec.previousContractTotal));
                                var currentTotal = ((isNaN(rec.currentContractTotal) ? 0 : rec.currentContractTotal));
                                var annualImapact = ((isNaN(rec.annualImpact) ? 0 : rec.annualImpact));
                                var businessImpact = ((isNaN(rec.businessImpact) ? 0 : rec.businessImpact));
                                var previousTPT = ((isNaN(rec.previousTPT) ? 0 : rec.previousTPT));
                                var currentTPT = ((isNaN(rec.currentTPT) ? 0 : rec.currentTPT));
                                var priceVarianceFamilySummary = ((isNaN(rec.priceVariance) ? 0 : rec.priceVariance));
                                var volumeVarianceFamilySummary = ((isNaN(rec.volumeVariance) ? 0 : rec.volumeVariance));
                                var totalPreviousAwdQtySummary = ((isNaN(rec.previousQty) ? 0 : rec.previousQty));
                                var totalAwdQtySummary = ((isNaN(rec.awardedQty) ? 0 : rec.awardedQty));
                                /*totalPreviousQtyBG += totalPreviousAwdQtySummary;
                                totalAwardedQtyBG += totalAwdQtySummary;*/
                                summary[0] = parseInt(previousTotal);
                                summary[1] = parseInt(currentTotal);
                                summary[2] = parseInt(annualImapact);
                                summary[3] = parseInt(businessImpact);
                                summary[4] = parseInt(previousTPT);
                                summary[5] = parseInt(currentTPT);
                                summary[6] = parseInt(parseFloat(currentTPT) - parseFloat(previousTPT));
                                summary[7] = parseInt(priceVarianceFamilySummary);
                                summary[8] = parseInt(volumeVarianceFamilySummary);
                                summary[9] = ((!isFinite(previousTPT/previousTotal) ? 0 : (previousTPT/previousTotal)));
                                summary[10] = ((!isFinite(currentTPT/currentTotal) ? 0 : (currentTPT/currentTotal)));
                                summary[11] = parseInt(totalPreviousAwdQtySummary);
                                summary[12] = parseInt(totalAwdQtySummary);
                                gainedFamilySummaryMap[rec.productFamily] = summary;
                            }
                        });
                        
                        var tempObj = {};
                        let keys = Object.keys(gainedFamilySummaryMap);
                        keys.sort(function(a, b) { return gainedFamilySummaryMap[b][2] - gainedFamilySummaryMap[a][2] });
                        for(var i=0; i<keys.length; i++){
                            tempObj[keys[i]] = gainedFamilySummaryMap[keys[i]];
                        }
                        gainedFamilySummaryMap = tempObj;
                        tempObj = {};
                        
                        let sortedKeys = Object.keys(gainedFamilySummaryMap);
                        for(var i=0; i<sortedKeys.length; i++){
                            tempObj[sortedKeys[i]] = gainedMap[sortedKeys[i]];
                        }
                        gainedMap = tempObj;
                        component.set("v.gainedFamilySummaryMap",gainedFamilySummaryMap);
                        component.set("v.gainedMap",Object.entries(gainedMap));
                        component.set("v.gainedList", gainedList);
                        tempObj = {};
                        
                        var gainValues = [];
                        if(gainedList != null) {
                            for(var i=0; i<gainedList.length; i++){
                                gainValues.push(gainedList[i].currentContractTotal);
                            }
                        }
                        
                        var retainedGainMap = {};
                        var retainedGainFamilySummaryMap = {}; var totalPreviousQtyBGG = 0; var totalAwardedQtyBGG = 0;
                        retainedGainList.forEach(function(rec){
                            totalPriceVariance += ((isNaN(rec.priceVariance) ? 0 : parseFloat(rec.priceVariance)));
                            totalVolumeVariance += ((isNaN(rec.volumeVariance) ? 0 : parseFloat(rec.volumeVariance)));
                            totalAwardedQty += ((isNaN(rec.awardedQty) ? 0 : parseFloat(rec.awardedQty)));
                            totalPreviousQty += ((isNaN(rec.previousQty) ? 0 : parseFloat(rec.previousQty)));
                            totalAwardedQtyBGG += ((isNaN(rec.awardedQty) ? 0 : parseFloat(rec.awardedQty)));
                            totalPreviousQtyBGG += ((isNaN(rec.previousQty) ? 0 : parseFloat(rec.previousQty)));
                            if(retainedGainMap.hasOwnProperty(rec.productFamily)){
                                var relatedList = retainedGainMap[rec.productFamily]; var summary = [];
                                relatedList.push(rec);
                                retainedGainMap[rec.productFamily] = relatedList;
                                var previousTotal = 0; var currentTotal = 0; var annualImapact = 0; var businessImpact = 0; var previousTPT = 0; var currentTPT = 0;
                                var previousTPTFamilySummary = 0; var currentTPTFamilySummary = 0; var priceVarianceFamilySummary = 0; var volumeVarianceFamilySummary = 0;
                                var totalVarianceFamilySummary = 0; var tptVarianceFamilySummary = 0;var totalPreviousAwdQtySummary = 0; var totalAwdQtySummary = 0;
                                for(var i=0; i<relatedList.length; i++){
                                    previousTotal += ((isNaN(relatedList[i].previousContractTotal) ? 0 : relatedList[i].previousContractTotal));
                                    currentTotal += ((isNaN(relatedList[i].currentContractTotal) ? 0 : relatedList[i].currentContractTotal));
                                    annualImapact += ((isNaN(relatedList[i].annualImpact) ? 0 : relatedList[i].annualImpact));
                                    businessImpact += ((isNaN(relatedList[i].businessImpact) ? 0 : relatedList[i].businessImpact));   
                                    previousTPT += ((isNaN(relatedList[i].previousTPT) ? 0 : relatedList[i].previousTPT));
                                    currentTPT += ((isNaN(relatedList[i].currentTPT) ? 0 : relatedList[i].currentTPT));
                                    priceVarianceFamilySummary += ((isNaN(relatedList[i].priceVariance) ? 0 : relatedList[i].priceVariance));
                                    volumeVarianceFamilySummary += ((isNaN(relatedList[i].volumeVariance) ? 0 : relatedList[i].volumeVariance));
                                    totalPreviousAwdQtySummary += ((isNaN(relatedList[i].previousQty) ? 0 : relatedList[i].previousQty));
                                    totalAwdQtySummary += ((isNaN(relatedList[i].awardedQty) ? 0 : relatedList[i].awardedQty));
                                }
                                /*totalPreviousQtyBGG += totalPreviousAwdQtySummary;
                                totalAwardedQtyBGG += totalAwdQtySummary;*/
                                summary[0] = parseInt(previousTotal);
                                summary[1] = parseInt(currentTotal);
                                summary[2] = parseInt(annualImapact);
                                summary[3] = parseInt(businessImpact);
                                summary[4] = parseInt(previousTPT);
                                summary[5] = parseInt(currentTPT);
                                summary[6] = parseInt(parseFloat(currentTPT) - parseFloat(previousTPT));
                                summary[7] = parseInt(priceVarianceFamilySummary);
                                summary[8] = parseInt(volumeVarianceFamilySummary);
                                summary[9] = ((!isFinite(previousTPT/previousTotal) ? 0 : (previousTPT/previousTotal)));
                                summary[10] = ((!isFinite(currentTPT/currentTotal) ? 0 : (currentTPT/currentTotal)));
                                summary[11] = parseInt(totalPreviousAwdQtySummary);
                                summary[12] = parseInt(totalAwdQtySummary);
                                retainedGainFamilySummaryMap[rec.productFamily] = summary;
                            } else{
                                var relatedList = [];var summary = [];
                                relatedList.push(rec);
                                retainedGainMap[rec.productFamily] = relatedList;
                                var previousTotal = ((isNaN(rec.previousContractTotal) ? 0 : rec.previousContractTotal));
                                var currentTotal = ((isNaN(rec.currentContractTotal) ? 0 : rec.currentContractTotal));
                                var annualImapact = ((isNaN(rec.annualImpact) ? 0 : rec.annualImpact));
                                var businessImpact = ((isNaN(rec.businessImpact) ? 0 : rec.businessImpact));
                                var previousTPT = ((isNaN(rec.previousTPT) ? 0 : rec.previousTPT));
                                var currentTPT = ((isNaN(rec.currentTPT) ? 0 : rec.currentTPT));
                                var priceVarianceFamilySummary = ((isNaN(rec.priceVariance) ? 0 : rec.priceVariance));
                                var volumeVarianceFamilySummary = ((isNaN(rec.volumeVariance) ? 0 : rec.volumeVariance));
                                var totalPreviousAwdQtySummary = ((isNaN(rec.previousQty) ? 0 : rec.previousQty));
                                var totalAwdQtySummary = ((isNaN(rec.awardedQty) ? 0 : rec.awardedQty));
                                /*totalPreviousQtyBGG += totalPreviousAwdQtySummary;
                                totalAwardedQtyBGG += totalAwdQtySummary;*/
                                summary[0] = parseInt(previousTotal);
                                summary[1] = parseInt(currentTotal);
                                summary[2] = parseInt(annualImapact);
                                summary[3] = parseInt(businessImpact);
                                summary[4] = parseInt(previousTPT);
                                summary[5] = parseInt(currentTPT);
                                summary[6] = parseInt(parseFloat(currentTPT) - parseFloat(previousTPT));
                                summary[7] = parseInt(priceVarianceFamilySummary);
                                summary[8] = parseInt(volumeVarianceFamilySummary);
                                summary[9] = ((!isFinite(previousTPT/previousTotal) ? 0 : (previousTPT/previousTotal)));
                                summary[10] = ((!isFinite(currentTPT/currentTotal) ? 0 : (currentTPT/currentTotal)));
                                summary[11] = parseInt(totalPreviousAwdQtySummary);
                                summary[12] = parseInt(totalAwdQtySummary);
                                retainedGainFamilySummaryMap[rec.productFamily] = summary;
                            }
                        });
                        
                        keys = Object.keys(retainedGainFamilySummaryMap);
                        keys.sort(function(a, b) { return retainedGainFamilySummaryMap[b][2] - retainedGainFamilySummaryMap[a][2] });
                        for(var i=0; i<keys.length; i++){
                            tempObj[keys[i]] = retainedGainFamilySummaryMap[keys[i]];
                        }
                        retainedGainFamilySummaryMap = tempObj;
                        tempObj = {};
                        
                        sortedKeys = Object.keys(retainedGainFamilySummaryMap);
                        for(var i=0; i<sortedKeys.length; i++){
                            tempObj[sortedKeys[i]] = retainedGainMap[sortedKeys[i]];
                        }
                        retainedGainMap = tempObj;
                        
                        tempObj = {};
                        
                        
                        component.set("v.retainedGainList", retainedGainList);
                        component.set("v.retainedGainFamilySummaryMap",retainedGainFamilySummaryMap);
                        component.set("v.retainedGainMap",Object.entries(retainedGainMap));
                        
                        var retainedLossMap = {};
                        var retainedLossFamilySummaryMap = {}; var totalPreviousQtyBGL = 0; var totalAwardedQtyBGL = 0;
                        retainedLossList.forEach(function(rec){
                            totalPriceVariance += ((isNaN(rec.priceVariance) ? 0 : parseFloat(rec.priceVariance)));
                            totalVolumeVariance += ((isNaN(rec.volumeVariance) ? 0 : parseFloat(rec.volumeVariance)));
                            totalAwardedQty += ((isNaN(rec.awardedQty) ? 0 : parseFloat(rec.awardedQty)));
                            totalPreviousQty += ((isNaN(rec.previousQty) ? 0 : parseFloat(rec.previousQty)));
                            totalAwardedQtyBGL += ((isNaN(rec.awardedQty) ? 0 : parseFloat(rec.awardedQty)));
                            totalPreviousQtyBGL += ((isNaN(rec.previousQty) ? 0 : parseFloat(rec.previousQty)));
                            if(retainedLossMap.hasOwnProperty(rec.productFamily)){
                                var relatedList = retainedLossMap[rec.productFamily]; var summary = [];
                                relatedList.push(rec);
                                retainedLossMap[rec.productFamily] = relatedList;
                                var previousTotal = 0; var currentTotal = 0; var annualImapact = 0; var businessImpact = 0; var previousTPT = 0; var currentTPT = 0;
                                var previousTPTFamilySummary = 0; var currentTPTFamilySummary = 0; var priceVarianceFamilySummary = 0; var volumeVarianceFamilySummary = 0;
                                var totalVarianceFamilySummary = 0; var tptVarianceFamilySummary = 0;var totalPreviousAwdQtySummary = 0; var totalAwdQtySummary = 0;
                                for(var i=0; i<relatedList.length; i++){
                                    previousTotal += ((isNaN(relatedList[i].previousContractTotal) ? 0 : relatedList[i].previousContractTotal));
                                    currentTotal += ((isNaN(relatedList[i].currentContractTotal) ? 0 : relatedList[i].currentContractTotal));
                                    annualImapact += ((isNaN(relatedList[i].annualImpact) ? 0 : relatedList[i].annualImpact));
                                    businessImpact += ((isNaN(relatedList[i].businessImpact) ? 0 : relatedList[i].businessImpact));   
                                    previousTPT += ((isNaN(relatedList[i].previousTPT) ? 0 : relatedList[i].previousTPT));
                                    currentTPT += ((isNaN(relatedList[i].currentTPT) ? 0 : relatedList[i].currentTPT));
                                    priceVarianceFamilySummary += ((isNaN(relatedList[i].priceVariance) ? 0 : relatedList[i].priceVariance));
                                    volumeVarianceFamilySummary += ((isNaN(relatedList[i].volumeVariance) ? 0 : relatedList[i].volumeVariance));
                                    totalPreviousAwdQtySummary += ((isNaN(relatedList[i].previousQty) ? 0 : relatedList[i].previousQty));
                                    totalAwdQtySummary += ((isNaN(relatedList[i].awardedQty) ? 0 : relatedList[i].awardedQty));
                                }
                                /*totalPreviousQtyBGL += totalPreviousAwdQtySummary;
                                totalAwardedQtyBGL += totalAwdQtySummary;*/
                                summary[0] = parseInt(previousTotal);
                                summary[1] = parseInt(currentTotal);
                                summary[2] = parseInt(annualImapact);
                                summary[3] = parseInt(businessImpact);
                                summary[4] = parseInt(previousTPT);
                                summary[5] = parseInt(currentTPT);
                                summary[6] = parseInt(parseFloat(currentTPT) - parseFloat(previousTPT));
                                summary[7] = parseInt(priceVarianceFamilySummary);
                                summary[8] = parseInt(volumeVarianceFamilySummary);
                                summary[9] = ((!isFinite(previousTPT/previousTotal) ? 0 : (previousTPT/previousTotal)));
                                summary[10] = ((!isFinite(currentTPT/currentTotal) ? 0 : (currentTPT/currentTotal)));
                                summary[11] = parseInt(totalPreviousAwdQtySummary);
                                summary[12] = parseInt(totalAwdQtySummary);
                                retainedLossFamilySummaryMap[rec.productFamily] = summary;
                            } else{
                                var relatedList = [];var summary = [];
                                relatedList.push(rec);
                                retainedLossMap[rec.productFamily] = relatedList;
                                var previousTotal = ((isNaN(rec.previousContractTotal) ? 0 : rec.previousContractTotal));
                                var currentTotal = ((isNaN(rec.currentContractTotal) ? 0 : rec.currentContractTotal));
                                var annualImapact = ((isNaN(rec.annualImpact) ? 0 : rec.annualImpact));
                                var businessImpact = ((isNaN(rec.businessImpact) ? 0 : rec.businessImpact));
                                var previousTPT = ((isNaN(rec.previousTPT) ? 0 : rec.previousTPT));
                                var currentTPT = ((isNaN(rec.currentTPT) ? 0 : rec.currentTPT));
                                var priceVarianceFamilySummary = ((isNaN(rec.priceVariance) ? 0 : rec.priceVariance));
                                var volumeVarianceFamilySummary = ((isNaN(rec.volumeVariance) ? 0 : rec.volumeVariance));
                                var totalPreviousAwdQtySummary = ((isNaN(rec.previousQty) ? 0 : rec.previousQty));
                                var totalAwdQtySummary = ((isNaN(rec.awardedQty) ? 0 : rec.awardedQty));
                                /*totalPreviousQtyBGL += totalPreviousAwdQtySummary;
                                totalAwardedQtyBGL += totalAwdQtySummary;*/
                                summary[0] = parseInt(previousTotal);
                                summary[1] = parseInt(currentTotal);
                                summary[2] = parseInt(annualImapact);
                                summary[3] = parseInt(businessImpact);
                                summary[4] = parseInt(previousTPT);
                                summary[5] = parseInt(currentTPT);
                                summary[6] = parseInt(parseFloat(currentTPT) - parseFloat(previousTPT));
                                summary[7] = parseInt(priceVarianceFamilySummary);
                                summary[8] = parseInt(volumeVarianceFamilySummary);
                                summary[9] = ((!isFinite(previousTPT/previousTotal) ? 0 : (previousTPT/previousTotal)));
                                summary[10] = ((!isFinite(currentTPT/currentTotal) ? 0 : (currentTPT/currentTotal)));
                                summary[11] = parseInt(totalPreviousAwdQtySummary);
                                summary[12] = parseInt(totalAwdQtySummary);
                                retainedLossFamilySummaryMap[rec.productFamily] = summary;
                            }
                        });
                        
                        keys = Object.keys(retainedLossFamilySummaryMap);
                        keys.sort(function(a, b) { return retainedLossFamilySummaryMap[b][2] - retainedLossFamilySummaryMap[a][2] });
                        for(var i=0; i<keys.length; i++){
                            tempObj[keys[i]] = retainedLossFamilySummaryMap[keys[i]];
                        }
                        retainedLossFamilySummaryMap = tempObj;
                        tempObj = {};
                        
                        sortedKeys = Object.keys(retainedLossFamilySummaryMap);
                        for(var i=0; i<sortedKeys.length; i++){
                            tempObj[sortedKeys[i]] = retainedLossMap[sortedKeys[i]];
                        }
                        retainedLossMap = tempObj;
                        
                        tempObj = {};
                        component.set("v.retainedLossFamilySummaryMap",retainedLossFamilySummaryMap);
                        component.set("v.retainedLossMap",Object.entries(retainedLossMap));
                        component.set("v.retainedLossList", retainedLossList);
                        
                        
                        var RFPLossMap = {};
                        var RFPLossFamilySummaryMap = {}; var totalPreviousQtyBL = 0; var totalAwardedQtyBL = 0;
                        RFPLossList.forEach(function(rec){
                            totalPriceVariance += ((isNaN(rec.priceVariance) ? 0 : parseFloat(rec.priceVariance)));
                            totalVolumeVariance += ((isNaN(rec.volumeVariance) ? 0 : parseFloat(rec.volumeVariance)));
                            totalAwardedQty += ((isNaN(rec.awardedQty) ? 0 : parseFloat(rec.awardedQty)));
                            totalPreviousQty += ((isNaN(rec.previousQty) ? 0 : parseFloat(rec.previousQty)));
                            totalAwardedQtyBL += ((isNaN(rec.awardedQty) ? 0 : parseFloat(rec.awardedQty)));
                            totalPreviousQtyBL += ((isNaN(rec.previousQty) ? 0 : parseFloat(rec.previousQty)));
                            if(RFPLossMap.hasOwnProperty(rec.productFamily)){
                                var relatedList = RFPLossMap[rec.productFamily]; var summary = [];
                                relatedList.push(rec);
                                RFPLossMap[rec.productFamily] = relatedList;
                                var previousTotal = 0; var currentTotal = 0; var annualImapact = 0; var businessImpact = 0; var previousTPT = 0; var currentTPT = 0;
                                var previousTPTFamilySummary = 0; var currentTPTFamilySummary = 0; var priceVarianceFamilySummary = 0; var volumeVarianceFamilySummary = 0;
                                var totalVarianceFamilySummary = 0; var tptVarianceFamilySummary = 0;var totalPreviousAwdQtySummary = 0; var totalAwdQtySummary = 0;
                                for(var i=0; i<relatedList.length; i++){
                                    previousTotal += ((isNaN(relatedList[i].previousContractTotal) ? 0 : relatedList[i].previousContractTotal));
                                    currentTotal += ((isNaN(relatedList[i].currentContractTotal) ? 0 : relatedList[i].currentContractTotal));
                                    annualImapact += ((isNaN(relatedList[i].annualImpact) ? 0 : relatedList[i].annualImpact));
                                    businessImpact += ((isNaN(relatedList[i].businessImpact) ? 0 : relatedList[i].businessImpact));   
                                    previousTPT += ((isNaN(relatedList[i].previousTPT) ? 0 : relatedList[i].previousTPT));
                                    currentTPT += ((isNaN(relatedList[i].currentTPT) ? 0 : relatedList[i].currentTPT));
                                    priceVarianceFamilySummary += ((isNaN(relatedList[i].priceVariance) ? 0 : relatedList[i].priceVariance));
                                    volumeVarianceFamilySummary += ((isNaN(relatedList[i].volumeVariance) ? 0 : relatedList[i].volumeVariance));
                                    totalPreviousAwdQtySummary += ((isNaN(relatedList[i].previousQty) ? 0 : relatedList[i].previousQty));
                                    totalAwdQtySummary += ((isNaN(relatedList[i].awardedQty) ? 0 : relatedList[i].awardedQty));
                                }
                                /*totalPreviousQtyBGL += totalPreviousAwdQtySummary;
                                totalAwardedQtyBGL += totalAwdQtySummary;*/
                                summary[0] = parseInt(previousTotal);
                                summary[1] = parseInt(currentTotal);
                                summary[2] = parseInt(annualImapact);
                                summary[3] = parseInt(businessImpact);
                                summary[4] = parseInt(previousTPT);
                                summary[5] = parseInt(currentTPT);
                                summary[6] = parseInt(parseFloat(currentTPT) - parseFloat(previousTPT));
                                summary[7] = parseInt(priceVarianceFamilySummary);
                                summary[8] = parseInt(volumeVarianceFamilySummary);
                                summary[9] = ((!isFinite(previousTPT/previousTotal) ? 0 : (previousTPT/previousTotal)));
                                summary[10] = ((!isFinite(currentTPT/currentTotal) ? 0 : (currentTPT/currentTotal)));
                                summary[11] = parseInt(totalPreviousAwdQtySummary);
                                summary[12] = parseInt(totalAwdQtySummary);
                                RFPLossFamilySummaryMap[rec.productFamily] = summary;
                            } else{
                                var relatedList = [];var summary = [];
                                relatedList.push(rec);
                                RFPLossMap[rec.productFamily] = relatedList;
                                var previousTotal = ((isNaN(rec.previousContractTotal) ? 0 : rec.previousContractTotal));
                                var currentTotal = ((isNaN(rec.currentContractTotal) ? 0 : rec.currentContractTotal));
                                var annualImapact = ((isNaN(rec.annualImpact) ? 0 : rec.annualImpact));
                                var businessImpact = ((isNaN(rec.businessImpact) ? 0 : rec.businessImpact));
                                var previousTPT = ((isNaN(rec.previousTPT) ? 0 : rec.previousTPT));
                                var currentTPT = ((isNaN(rec.currentTPT) ? 0 : rec.currentTPT));
                                var priceVarianceFamilySummary = ((isNaN(rec.priceVariance) ? 0 : rec.priceVariance));
                                var volumeVarianceFamilySummary = ((isNaN(rec.volumeVariance) ? 0 : rec.volumeVariance));
                                var totalPreviousAwdQtySummary = ((isNaN(rec.previousQty) ? 0 : rec.previousQty));
                                var totalAwdQtySummary = ((isNaN(rec.awardedQty) ? 0 : rec.awardedQty));
                                /*totalPreviousQtyBGL += totalPreviousAwdQtySummary;
                                totalAwardedQtyBGL += totalAwdQtySummary;*/
                                summary[0] = parseInt(previousTotal);
                                summary[1] = parseInt(currentTotal);
                                summary[2] = parseInt(annualImapact);
                                summary[3] = parseInt(businessImpact);
                                summary[4] = parseInt(previousTPT);
                                summary[5] = parseInt(currentTPT);
                                summary[6] = parseInt(parseFloat(currentTPT) - parseFloat(previousTPT));
                                summary[7] = parseInt(priceVarianceFamilySummary);
                                summary[8] = parseInt(volumeVarianceFamilySummary);
                                summary[9] = ((!isFinite(previousTPT/previousTotal) ? 0 : (previousTPT/previousTotal)));
                                summary[10] = ((!isFinite(currentTPT/currentTotal) ? 0 : (currentTPT/currentTotal)));
                                summary[11] = parseInt(totalPreviousAwdQtySummary);
                                summary[12] = parseInt(totalAwdQtySummary);
                                RFPLossFamilySummaryMap[rec.productFamily] = summary;
                            }
                        });
                        
                        keys = Object.keys(RFPLossFamilySummaryMap);
                        keys.sort(function(a, b) { return RFPLossFamilySummaryMap[b][2] - RFPLossFamilySummaryMap[a][2] });
                        for(var i=0; i<keys.length; i++){
                            tempObj[keys[i]] = RFPLossFamilySummaryMap[keys[i]];
                        }
                        RFPLossFamilySummaryMap = tempObj;
                        tempObj = {};
                        
                        sortedKeys = Object.keys(RFPLossFamilySummaryMap);
                        for(var i=0; i<sortedKeys.length; i++){
                            tempObj[sortedKeys[i]] = RFPLossMap[sortedKeys[i]];
                        }
                        RFPLossMap = tempObj;
                        
                        tempObj = {};
                        component.set("v.RFPLossFamilySummaryMap",RFPLossFamilySummaryMap);
                        component.set("v.RFPLossMap",Object.entries(RFPLossMap));
                        component.set("v.RFPLossList", RFPLossList);
                        
                        
                        
                        
                        var openStatusMap = {};
                        var openStatusFamilySummaryMap = {}; var totalPreviousQtyOS = 0; var totalAwardedQtyOS = 0;
                        openStatusList.forEach(function(rec){
                            totalAwardedQtyOS += ((isNaN(rec.awardedQty) ? 0 : parseFloat(rec.awardedQty)));
                            totalPreviousQtyOS += ((isNaN(rec.previousQty) ? 0 : parseFloat(rec.previousQty)));
                            if(openStatusMap.hasOwnProperty(rec.productFamily)){
                                var relatedList = openStatusMap[rec.productFamily]; var summary = [];
                                relatedList.push(rec);
                                openStatusMap[rec.productFamily] = relatedList;
                                var previousTotal = 0; var currentTotal = 0; var annualImapact = 0; var businessImpact = 0; var previousTPT = 0; var currentTPT = 0;
                                var previousTPTFamilySummary = 0; var currentTPTFamilySummary = 0; var priceVarianceFamilySummary = 0; var volumeVarianceFamilySummary = 0;
                                var totalVarianceFamilySummary = 0; var tptVarianceFamilySummary = 0;var totalPreviousAwdQtySummary = 0; var totalAwdQtySummary = 0;
                                for(var i=0; i<relatedList.length; i++){
                                    previousTotal += ((isNaN(relatedList[i].previousContractTotal) ? 0 : relatedList[i].previousContractTotal));
                                    currentTotal += ((isNaN(relatedList[i].currentContractTotal) ? 0 : relatedList[i].currentContractTotal));
                                    annualImapact += ((isNaN(relatedList[i].annualImpact) ? 0 : relatedList[i].annualImpact));
                                    businessImpact += ((isNaN(relatedList[i].businessImpact) ? 0 : relatedList[i].businessImpact));   
                                    previousTPT += ((isNaN(relatedList[i].previousTPT) ? 0 : relatedList[i].previousTPT));
                                    currentTPT += ((isNaN(relatedList[i].currentTPT) ? 0 : relatedList[i].currentTPT));
                                    priceVarianceFamilySummary += ((isNaN(relatedList[i].priceVariance) ? 0 : relatedList[i].priceVariance));
                                    volumeVarianceFamilySummary += ((isNaN(relatedList[i].volumeVariance) ? 0 : relatedList[i].volumeVariance));
                                    totalPreviousAwdQtySummary += ((isNaN(relatedList[i].previousQty) ? 0 : relatedList[i].previousQty));
                                    totalAwdQtySummary += ((isNaN(relatedList[i].awardedQty) ? 0 : relatedList[i].awardedQty));
                                }
                                /*totalPreviousQtyOS += totalPreviousAwdQtySummary;
                                totalAwardedQtyOS += totalAwdQtySummary;*/
                                summary[0] = parseInt(previousTotal);
                                summary[1] = parseInt(currentTotal);
                                summary[2] = parseInt(annualImapact);
                                summary[3] = parseInt(businessImpact);
                                summary[4] = parseInt(previousTPT);
                                summary[5] = parseInt(currentTPT);
                                summary[6] = parseInt(parseFloat(currentTPT) - parseFloat(previousTPT));
                                summary[7] = parseInt(priceVarianceFamilySummary);
                                summary[8] = parseInt(volumeVarianceFamilySummary);
                                summary[9] = ((!isFinite(previousTPT/previousTotal) ? 0 : (previousTPT/previousTotal)));
                                summary[10] = ((!isFinite(currentTPT/currentTotal) ? 0 : (currentTPT/currentTotal)));
                                summary[11] = parseInt(totalPreviousAwdQtySummary);
                                summary[12] = parseInt(totalAwdQtySummary);
                                openStatusFamilySummaryMap[rec.productFamily] = summary;
                            } else{
                                var relatedList = [];var summary = [];
                                relatedList.push(rec);
                                openStatusMap[rec.productFamily] = relatedList;
                                var previousTotal = ((isNaN(rec.previousContractTotal) ? 0 : rec.previousContractTotal));
                                var currentTotal = ((isNaN(rec.currentContractTotal) ? 0 : rec.currentContractTotal));
                                var annualImapact = ((isNaN(rec.annualImpact) ? 0 : rec.annualImpact));
                                var businessImpact = ((isNaN(rec.businessImpact) ? 0 : rec.businessImpact));
                                var previousTPT = ((isNaN(rec.previousTPT) ? 0 : rec.previousTPT));
                                var currentTPT = ((isNaN(rec.currentTPT) ? 0 : rec.currentTPT));
                                var priceVarianceFamilySummary = ((isNaN(rec.priceVariance) ? 0 : rec.priceVariance));
                                var volumeVarianceFamilySummary = ((isNaN(rec.volumeVariance) ? 0 : rec.volumeVariance));
                                var totalPreviousAwdQtySummary = ((isNaN(rec.previousQty) ? 0 : rec.previousQty));
                                var totalAwdQtySummary = ((isNaN(rec.awardedQty) ? 0 : rec.awardedQty));
                                /*totalPreviousQtyOS += totalPreviousAwdQtySummary;
                                totalAwardedQtyOS += totalAwdQtySummary;*/
                                summary[0] = parseInt(previousTotal);
                                summary[1] = parseInt(currentTotal);
                                summary[2] = parseInt(annualImapact);
                                summary[3] = parseInt(businessImpact);
                                summary[4] = parseInt(previousTPT);
                                summary[5] = parseInt(currentTPT);
                                summary[6] = parseInt(parseFloat(currentTPT) - parseFloat(previousTPT));
                                summary[7] = parseInt(priceVarianceFamilySummary);
                                summary[8] = parseInt(volumeVarianceFamilySummary);
                                summary[9] = ((!isFinite(previousTPT/previousTotal) ? 0 : (previousTPT/previousTotal)));
                                summary[10] = ((!isFinite(currentTPT/currentTotal) ? 0 : (currentTPT/currentTotal)));
                                summary[11] = parseInt(totalPreviousAwdQtySummary);
                                summary[12] = parseInt(totalAwdQtySummary);
                                openStatusFamilySummaryMap[rec.productFamily] = summary;
                            }
                        });
                        
                        keys = Object.keys(openStatusFamilySummaryMap);
                        keys.sort(function(a, b) { return openStatusFamilySummaryMap[b][2] - openStatusFamilySummaryMap[a][2] });
                        for(var i=0; i<keys.length; i++){
                            tempObj[keys[i]] = openStatusFamilySummaryMap[keys[i]];
                        }
                        openStatusFamilySummaryMap = tempObj;
                        tempObj = {};
                        
                        sortedKeys = Object.keys(openStatusFamilySummaryMap);
                        for(var i=0; i<sortedKeys.length; i++){
                            tempObj[sortedKeys[i]] = openStatusMap[sortedKeys[i]];
                        }
                        openStatusMap = tempObj;
                        
                        tempObj = {};
                        
                        component.set("v.openStatusFamilySummaryMap",openStatusFamilySummaryMap);
                        component.set("v.openStatusMap",Object.entries(openStatusMap));
                        component.set("v.openStatusList", openStatusList);
                        
                        component.set("v.removalsLossList", removalsLossList);
                        component.set("v.discontinuationLossList", discontinuationLossList);
                        
                        
                        var noEffectMap = {};
                        var noEffectFamilySummaryMap = {}; var totalPreviousQtyNE = 0; var totalAwardedQtyNE = 0;
                        noEffectList.forEach(function(rec){
                            totalAwardedQtyNE += ((isNaN(rec.awardedQty) ? 0 : parseFloat(rec.awardedQty)));
                            totalPreviousQtyNE += ((isNaN(rec.previousQty) ? 0 : parseFloat(rec.previousQty)));
                            if(noEffectMap.hasOwnProperty(rec.productFamily)){
                                var relatedList = noEffectMap[rec.productFamily]; var summary = [];
                                relatedList.push(rec);
                                noEffectMap[rec.productFamily] = relatedList;
                                var previousTotal = 0; var currentTotal = 0; var annualImapact = 0; var businessImpact = 0; var previousTPT = 0; var currentTPT = 0;
                                var previousTPTFamilySummary = 0; var currentTPTFamilySummary = 0; var priceVarianceFamilySummary = 0; var volumeVarianceFamilySummary = 0;
                                var totalVarianceFamilySummary = 0; var tptVarianceFamilySummary = 0;var totalPreviousAwdQtySummary = 0; var totalAwdQtySummary = 0;
                                for(var i=0; i<relatedList.length; i++){
                                    previousTotal += ((isNaN(relatedList[i].previousContractTotal) ? 0 : relatedList[i].previousContractTotal));
                                    currentTotal += ((isNaN(relatedList[i].currentContractTotal) ? 0 : relatedList[i].currentContractTotal));
                                    annualImapact += ((isNaN(relatedList[i].annualImpact) ? 0 : relatedList[i].annualImpact));
                                    businessImpact += ((isNaN(relatedList[i].businessImpact) ? 0 : relatedList[i].businessImpact));   
                                    previousTPT += ((isNaN(relatedList[i].previousTPT) ? 0 : relatedList[i].previousTPT));
                                    currentTPT += ((isNaN(relatedList[i].currentTPT) ? 0 : relatedList[i].currentTPT));
                                    priceVarianceFamilySummary += ((isNaN(relatedList[i].priceVariance) ? 0 : relatedList[i].priceVariance));
                                    volumeVarianceFamilySummary += ((isNaN(relatedList[i].volumeVariance) ? 0 : relatedList[i].volumeVariance));
                                    totalPreviousAwdQtySummary += ((isNaN(relatedList[i].previousQty) ? 0 : relatedList[i].previousQty));
                                    totalAwdQtySummary += ((isNaN(relatedList[i].awardedQty) ? 0 : relatedList[i].awardedQty));
                                }
                                /*totalPreviousQtyNE += totalPreviousAwdQtySummary;
                                totalAwardedQtyNE += totalAwdQtySummary;*/
                                summary[0] = parseInt(previousTotal);
                                summary[1] = parseInt(currentTotal);
                                summary[2] = parseInt(annualImapact);
                                summary[3] = parseInt(businessImpact);
                                summary[4] = parseInt(previousTPT);
                                summary[5] = parseInt(currentTPT);
                                summary[6] = parseInt(parseFloat(currentTPT) - parseFloat(previousTPT));
                                summary[7] = parseInt(priceVarianceFamilySummary);
                                summary[8] = parseInt(volumeVarianceFamilySummary);
                                summary[9] = ((!isFinite(previousTPT/previousTotal) ? 0 : (previousTPT/previousTotal)));
                                summary[10] = ((!isFinite(currentTPT/currentTotal) ? 0 : (currentTPT/currentTotal)));
                                summary[11] = parseInt(totalPreviousAwdQtySummary);
                                summary[12] = parseInt(totalAwdQtySummary);
                                noEffectFamilySummaryMap[rec.productFamily] = summary;
                            } else{
                                var relatedList = [];var summary = [];
                                relatedList.push(rec);
                                noEffectMap[rec.productFamily] = relatedList;
                                var previousTotal = ((isNaN(rec.previousContractTotal) ? 0 : rec.previousContractTotal));
                                var currentTotal = ((isNaN(rec.currentContractTotal) ? 0 : rec.currentContractTotal));
                                var annualImapact = ((isNaN(rec.annualImpact) ? 0 : rec.annualImpact));
                                var businessImpact = ((isNaN(rec.businessImpact) ? 0 : rec.businessImpact));
                                var previousTPT = ((isNaN(rec.previousTPT) ? 0 : rec.previousTPT));
                                var currentTPT = ((isNaN(rec.currentTPT) ? 0 : rec.currentTPT));
                                var priceVarianceFamilySummary = ((isNaN(rec.priceVariance) ? 0 : rec.priceVariance));
                                var volumeVarianceFamilySummary = ((isNaN(rec.volumeVariance) ? 0 : rec.volumeVariance));
                                var totalPreviousAwdQtySummary = ((isNaN(rec.previousQty) ? 0 : rec.previousQty));
                                var totalAwdQtySummary = ((isNaN(rec.awardedQty) ? 0 : rec.awardedQty));
                                /*totalPreviousQtyNE += totalPreviousAwdQtySummary;
                                totalAwardedQtyNE += totalAwdQtySummary;*/
                                summary[0] = parseInt(previousTotal);
                                summary[1] = parseInt(currentTotal);
                                summary[2] = parseInt(annualImapact);
                                summary[3] = parseInt(businessImpact);
                                summary[4] = parseInt(previousTPT);
                                summary[5] = parseInt(currentTPT);
                                summary[6] = parseInt(parseFloat(currentTPT) - parseFloat(previousTPT));
                                summary[7] = parseInt(priceVarianceFamilySummary);
                                summary[8] = parseInt(volumeVarianceFamilySummary);
                                summary[9] = ((!isFinite(previousTPT/previousTotal) ? 0 : (previousTPT/previousTotal)));
                                summary[10] = ((!isFinite(currentTPT/currentTotal) ? 0 : (currentTPT/currentTotal)));
                                summary[11] = parseInt(totalPreviousAwdQtySummary);
                                summary[12] = parseInt(totalAwdQtySummary);
                                noEffectFamilySummaryMap[rec.productFamily] = summary;
                            }
                        });
                        
                        keys = Object.keys(noEffectFamilySummaryMap);
                        keys.sort(function(a, b) { return noEffectFamilySummaryMap[b][2] - noEffectFamilySummaryMap[a][2] });
                        for(var i=0; i<keys.length; i++){
                            tempObj[keys[i]] = noEffectFamilySummaryMap[keys[i]];
                        }
                        noEffectFamilySummaryMap = tempObj;
                        tempObj = {};
                        
                        sortedKeys = Object.keys(noEffectFamilySummaryMap);
                        for(var i=0; i<sortedKeys.length; i++){
                            tempObj[sortedKeys[i]] = noEffectMap[sortedKeys[i]];
                        }
                        noEffectMap = tempObj;
                        
                        tempObj = {};
                        
                        component.set("v.noEffectFamilySummaryMap",noEffectFamilySummaryMap);
                        component.set("v.noEffectMap",Object.entries(noEffectMap));
                        component.set("v.noEffectList", noEffectList);
                        
                        var totalAwards = (component.get("v.gainedList") != null ? component.get("v.gainedList").length : 0);
                        var percentNewAwards = (totalAwards/scmDataList.length)*100;
                        var percentLoss = (lossList.length/scmDataList.length)*100;
                        var percentNoEffects = (noEffectList.length/scmDataList.length)*100;
                        var percentOpen = (openStatusList.length/scmDataList.length)*100;
                        totalObj.totalAwards = totalAwards;
                        totalObj.percentNewAwards = percentNewAwards;
                        totalObj.percentLoss = percentLoss;
                        totalObj.percentNoEffects = percentNoEffects;
                        totalObj.percentOpen = percentOpen;
                        totalObj.priceVariance = parseInt(totalPriceVariance);
                        totalObj.volumeVariance = parseInt(totalVolumeVariance);
                        totalObj.totalAwardedQty = parseInt(totalAwardedQty);
                        totalObj.totalPreviousQty = parseInt(totalPreviousQty);
                        console.log('Total Awarded Qty: '+totalAwardedQty);
                        console.log('Total Previous Qty: '+totalPreviousQty);
                        /*component.set("v.categoryTotals.totalAwards", totalAwards);
                        component.set("v.categoryTotals.percentNewAwards", percentNewAwards);
                        component.set("v.categoryTotals.percentLoss", percentLoss);
                        component.set("v.categoryTotals.percentNoEffects", percentNoEffects);*/
                    }
                    /*var totalAwards = (component.get("v.gainedList") != null ? component.get("v.gainedList").length : 0);
                    var percentNewAwards = (totalAwards/total)*100;
                    var percentLoss = (component.get("v.lossList").length/total)*100;
                    var percentNoEffects = (component.get("v.noEffectList").length/total)*100;
                    component.set("v.categoryTotals.totalAwards", totalAwards);
                    component.set("v.categoryTotals.percentNewAwards", percentNewAwards);
                    component.set("v.categoryTotals.percentLoss", percentLoss);
                    component.set("v.categoryTotals.percentNoEffects", percentNoEffects);*/
                    component.set("v.lossList", lossList);
                    var lostKeys = Object.keys(removalsDataFormattingObjProductRemovals);
                    var lostListToSort = {};
                    for(var i=0; i<lostKeys.length; i++){
                        var products = removalsDataFormattingObjProductRemovals[lostKeys[i]];
                        var totalAnnualImpact = 0;
                        for(var j=0; j<products.length; j++){
                            totalAnnualImpact += products[j].annualImpact;
                        }
                        lostListToSort[lostKeys[i]] = totalAnnualImpact;
                    }
                    lostKeys = Object.keys(lostListToSort);
                    lostKeys.sort(function(a, b) { return lostListToSort[b] - lostListToSort[a] });
                    for(var i=0; i<lostKeys.length; i++){
                        tempObj[lostKeys[i]] = removalsDataFormattingObjProductRemovals[lostKeys[i]];
                    }
                    removalsDataFormattingObjProductRemovals = tempObj;
                    tempObj = {};
                    component.set("v.lossDataRemovals", Object.entries(removalsDataFormattingObjProductRemovals));
                    
                    var lostKeysDiscontinuation = Object.keys(removalsDataFormattingObjProductDiscontinuation);
                    var lostListToSortDiscontinuation = {};
                    for(var i=0; i<lostKeysDiscontinuation.length; i++){
                        var products = removalsDataFormattingObjProductDiscontinuation[lostKeysDiscontinuation[i]];
                        var totalAnnualImpact = 0;
                        for(var j=0; j<products.length; j++){
                            totalAnnualImpact += products[j].annualImpact;
                        }
                        lostListToSortDiscontinuation[lostKeysDiscontinuation[i]] = totalAnnualImpact;
                    }
                    lostKeysDiscontinuation = Object.keys(lostListToSortDiscontinuation);
                    lostKeysDiscontinuation.sort(function(a, b) { return lostListToSortDiscontinuation[b] - lostListToSortDiscontinuation[a] });
                    for(var i=0; i<lostKeysDiscontinuation.length; i++){
                        tempObj[lostKeysDiscontinuation[i]] = removalsDataFormattingObjProductDiscontinuation[lostKeysDiscontinuation[i]];
                    }
                    removalsDataFormattingObjProductDiscontinuation = tempObj;
                    tempObj = {};
                    component.set("v.lossDataDiscontinuation", Object.entries(removalsDataFormattingObjProductDiscontinuation));
                    
                    var lostKeysRFP = Object.keys(removalsDataFormattingObjRFP);
                    var lostListToSortRFP = {};
                    for(var i=0; i<lostKeysRFP.length; i++){
                        var products = removalsDataFormattingObjRFP[lostKeysRFP[i]];
                        var totalAnnualImpact = 0;
                        for(var j=0; j<products.length; j++){
                            totalAnnualImpact += products[j].annualImpact;
                        }
                        lostListToSortRFP[lostKeysRFP[i]] = totalAnnualImpact;
                    }
                    lostKeysRFP = Object.keys(lostListToSortRFP);
                    lostKeysRFP.sort(function(a, b) { return lostListToSortRFP[b] - lostListToSortRFP[a] });
                    for(var i=0; i<lostKeysRFP.length; i++){
                        tempObj[lostKeysRFP[i]] = removalsDataFormattingObjRFP[lostKeysRFP[i]];
                    }
                    removalsDataFormattingObjRFP = tempObj;
                    tempObj = {};
                    component.set("v.lossDataRFP", Object.entries(removalsDataFormattingObjRFP));
                    
                    totalObj.totalPreviousQtyBG = totalPreviousQtyBG;
                    totalObj.totalAwardedQtyBG = totalAwardedQtyBG;
                    totalObj.totalPreviousQtyBGG = totalPreviousQtyBGG;
                    totalObj.totalAwardedQtyBGG = totalAwardedQtyBGG;
                    totalObj.totalPreviousQtyBGL = totalPreviousQtyBGL;
                    totalObj.totalAwardedQtyBGL = totalAwardedQtyBGL;
                    totalObj.totalPreviousQtyNE = totalPreviousQtyNE;
                    totalObj.totalAwardedQtyNE = totalAwardedQtyNE;
                    totalObj.totalPreviousQtyOS = totalPreviousQtyOS;
                    totalObj.totalAwardedQtyOS = totalAwardedQtyOS;
                    component.set("v.categoryTotals", totalObj);
                    
                    var formatter = new Intl.NumberFormat('en-US', { style: 'currency', currency: 'USD', minimumFractionDigits: 0, maximumFractionDigits: 0,});
                    component.set("v.businessGained", 'Business Gained'+' ('+formatter.format(totalObj.totalAnnualImpactBG.toFixed())+', '+formatter.format(totalObj.totalBusinessImpactBG.toFixed())+')');
                    component.set("v.retainedGain", 'Business Retained with Gains'+' ('+formatter.format(totalObj.totalAnnualImpactBGG.toFixed())+', '+formatter.format(totalObj.totalBusinessImpactBGG.toFixed())+')');
                    component.set("v.retainedLoss", 'Business Retained with Loss'+' ('+formatter.format(totalObj.totalAnnualImpactBGL.toFixed())+', '+formatter.format(totalObj.totalBusinessImpactBGL.toFixed())+')');
                    component.set("v.lost", 'Business Lost'+' ('+formatter.format(totalObj.totalAnnualImpactBL.toFixed())+', '+formatter.format(totalObj.totalBusinessImpactBL.toFixed())+')');
                    component.set("v.removalsLostLabel", 'Lost by Product Removals'+' ('+formatter.format(totalObj.totalAnnualImpactBLRemovals.toFixed())+', '+formatter.format(totalObj.totalBusinessImpactBLRemovals.toFixed())+')');
                    component.set("v.discontinuationLostLabel", 'Lost by Discontinuation'+' ('+formatter.format(totalObj.totalAnnualImpactBLDiscontinuation.toFixed())+', '+formatter.format(totalObj.totalBusinessImpactBLDiscontinuation.toFixed())+')');
                    component.set("v.RFPLostLabel", 'RFP Lost'+' ('+formatter.format(totalObj.totalAnnualImpactBLRFP.toFixed())+', '+formatter.format(totalObj.totalBusinessImpactBLRFP.toFixed())+')');
                    component.set("v.noEffect", 'No Effect Bids'+' ('+formatter.format(totalObj.totalAnnualImpactNE.toFixed())+', '+formatter.format(totalObj.totalBusinessImpactNE.toFixed())+')');
                    if(scmDataList[0].bidRecord.Phoenix_Bid_Type__c == 'OTC New Product' || scmDataList[0].bidRecord.Phoenix_Bid_Type__c == 'OTC OTB Good Dated' || scmDataList[0].bidRecord.Phoenix_Bid_Type__c == 'OTC OTB Short Dated' || scmDataList[0].bidRecord.Phoenix_Bid_Type__c == 'OTC Price Change'
                       || scmDataList[0].bidRecord.Phoenix_Bid_Type__c == 'OTC Product Addition' || scmDataList[0].bidRecord.Phoenix_Bid_Type__c == 'OTC Rebate Change' || scmDataList[0].bidRecord.Phoenix_Bid_Type__c == 'OTC RFP' || scmDataList[0].bidRecord.Phoenix_Bid_Type__c == 'OTC Volume Review'){
                        scmDataList[0].bidRecord.isOTCType = true;
                    } else{
                        scmDataList[0].bidRecord.isOTCType = false;
                    }
                    component.set("v.bidRecord",scmDataList[0].bidRecord);
                    component.set("v.templateType",scmDataList[0].templateType);
                }              
                component.set("v.scmData", scmDataList);
                component.set("v.isSpinnerLoad", false);
            }else{
                component.set("v.isSpinnerLoad", false);
                var exception = response.getError()[0].exceptionType;
                if(exception == 'System.LimitException'){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Info',
                        message:'Unable to load large data set. Try again with smaller duration (Start and End Date). Run the report with 2 months duration.',
                        mode: 'sticky',
                        key: 'info_alt'
                    });
                    toastEvent.fire();
                    component.set("v.currentTabId", "tabOne");
                    component.set("v.onLoad", true);
                }
                console.log("Error "+JSON.stringify(response.getError()));
                console.log('Exception Type: '+response.getError()[0].exceptionType);
            }
        });
        $A.enqueueAction(action);
    }
})