({
    getScmData : function(component, event, helper) {
        var action = component.get("c.getData");
        component.set("v.isSpinnerLoad", true);
        action.setParams({
            bidId : component.get("v.recordId")
        });
        action.setCallback(this, function (response){
            if(response.getState() === "SUCCESS"){                
                var scmDataList = response.getReturnValue().scmWrapperList;
                component.set("v.openLineItemsCount", response.getReturnValue().openLineItemsCount);
                var gainedList = [];
                var retainedGainList = [];
                var retainedLossList = [];
                var lossList = [];
                var RFPLossList = [];
                var noEffectList = [];
                var openStatusList = [];
                var totalObj = {};
                var bothList = []; var priceChangeList = []; var volumeChangeList = [];
                var bothListRetainedWithGains = []; var bothListRetainedWithLoss = [];
                var priceChangeListRetainedWithGains = []; var priceChangeListRetainedWithLoss = [];
                var volumeChangeListRetainedWithGains = []; var volumeChangeListRetainedWithLoss = [];
                var previousTotal = 0; var currentTotal = 0;
                var formatter = new Intl.NumberFormat('en-US', { style: 'currency', currency: 'USD', minimumFractionDigits: 0, maximumFractionDigits: 0,});
                if(scmDataList.length>0){
                    var totalAnnualImpactBG = 0; var totalBusinessImpactBG = 0; var totalPreviousQtyBG = 0; var totalQtyBG = 0; var totalSCMApprovedQtyBG = 0; var currentTotalBG = 0; var previousTotalBG = 0; var previousTPTBG = 0; var currentTPTBG = 0; var priceVarianceBG = 0; var volumeVarianceBG = 0; var totalVarianceBG = 0; var tptVarianceBG = 0;
                    var totalAnnualImpactBGG = 0; var totalBusinessImpactBGG = 0; var totalPreviousQtyBGG = 0; var totalQtyBGG = 0; var totalSCMApprovedQtyBGG = 0; var currentTotalBGG = 0; var previousTotalBGG = 0; var previousTPTBGG = 0; var currentTPTBGG = 0; var priceVarianceBGG = 0; var volumeVarianceBGG = 0; var totalVarianceBGG = 0; var tptVarianceBGG = 0;
                    var totalAnnualImpactBGL = 0; var totalBusinessImpactBGL = 0; var totalPreviousQtyBGL = 0; var totalQtyBGL = 0; var totalSCMApprovedQtyBGL = 0; var currentTotalBGL = 0; var previousTotalBGL = 0; var previousTPTBGL = 0; var currentTPTBGL = 0; var priceVarianceBGL = 0; var volumeVarianceBGL = 0; var totalVarianceBGL = 0; var tptVarianceBGL = 0;
                    var totalAnnualImpactNE = 0; var totalBusinessImpactNE = 0; var totalPreviousQtyNE = 0; var totalQtyNE = 0; var totalSCMApprovedQtyNE = 0; var currentTotalNE = 0; var previousTotalNE = 0; var previousTPTNE = 0; var currentTPTNE = 0; var priceVarianceNE = 0; var volumeVarianceNE = 0; var totalVarianceNE = 0; var tptVarianceNE = 0;
                    var totalAnnualImpactOS = 0; var totalBusinessImpactOS = 0; var totalPreviousQtyOS = 0; var totalQtyOS = 0; var totalSCMApprovedQtyOS = 0; var currentTotalOS = 0; var previousTotalOS = 0; var previousTPTOS = 0; var currentTPTOS = 0; var priceVarianceOS = 0; var volumeVarianceOS = 0; var totalVarianceOS = 0; var tptVarianceOS = 0;
                    var totalAnnualImpactBL = 0; var totalBusinessImpactBL = 0; var currentTotalBL = 0; var previousTotalBL = 0; var tptVariance =0; var priceVariance =0; var volumeVariance =0;
                    var totalPreviousQtyBLRFP = 0; var totalSCMApprovedQtyBL = 0; var totalQtyBL = 0; var totalQtyBLRFP = 0; var currentTotalBLRFP = 0; var previousTotalBLRFP = 0; var tptVarianceBLRFP =0; var priceVarianceBLRFP =0; var volumeVarianceBLRFP =0;var previousTPTBLRFP = 0; var currentTPTBLRFP = 0; var priceVarianceBLRFP = 0; var volumeVarianceBLRFP = 0; var totalVarianceBLRFP = 0; var tptVarianceBLRFP = 0;
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
                    let removalsDataFormattingObj = new Map(); var totalCurrentFiscalImpact = 0; var totalProposedFiscalImpact = 0; var totalCurrentTPTFiscalImpact = 0; var totalProposedTPTFiscalImpact = 0;
                    var awards = 0; var noEffects = 0; var losts = 0;
                    for(var i=0; i<scmDataList.length; i++){
                        if(scmDataList[i].businessCategory == 'Business Gained'){
                            awards += 1;
                        } else if(scmDataList[i].businessCategory == 'No Effect'){
                            noEffects += 1;
                        } else if(scmDataList[i].businessCategory == 'Business Lost'){
                            losts += 1;
                        }
                        tptVariance+= isNaN(scmDataList[i].tptVariance)? 0 : scmDataList[i].tptVariance;
                        priceVariance+= isNaN(scmDataList[i].priceVariance)? 0 : scmDataList[i].priceVariance;
                        volumeVariance+= isNaN(scmDataList[i].volumeVariance)? 0 : scmDataList[i].volumeVariance;
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
                                endDateOfFiscalYear = currentFiscalYearEndDate; //new Date(d.getFullYear()+1, d.getMonth(), d.getDate()); //currentFiscalYearEndDate;
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
                            scmDataList[i].daysDifference = days_difference;
                            scmDataList[i].impactedTitle = '((Fiscal Year End Date - '+scmDataList[i].date+')/365)*12  '+'[(('+days_difference+')/365)*12]';
                            monthsRemaining = (days_difference/365)*12;
                            var annualImpact = 0;
                            var businessImpact = 0;
                            scmDataList[i].businessTitle = '(Annual Impact * Impacted Months)/12 [('+annualImpact+' * '+monthsRemaining.toFixed(2)+')/12]';
                            scmDataList[i].currentContractTotal = (isNaN(scmDataList[i].awardedQty * scmDataList[i].currentDeadnet)? 0 :(scmDataList[i].awardedQty * scmDataList[i].currentDeadnet));
                            scmDataList[i].previousContractTotal = (isNaN(scmDataList[i].previousQty * scmDataList[i].previousDeadnet)? 0 :(scmDataList[i].previousQty * scmDataList[i].previousDeadnet));
                            scmDataList[i].contractTotalCurrentTitle = 'Awarded Qty * Current Deadnet ('+scmDataList[i].awardedQty+'*'+scmDataList[i].currentDeadnet+')';
                            scmDataList[i].contractTotalPreviousTitle = 'Previous Qty * Previous Deadnet ('+scmDataList[i].previousQty+'*'+((scmDataList[i].previousDeadnet != undefined)?scmDataList[i].previousDeadnet:0)+')';
                            annualImpact = (scmDataList[i].currentContractTotal-(isNaN(scmDataList[i].previousContractTotal)?0:scmDataList[i].previousContractTotal));
                            businessImpact = (annualImpact * monthsRemaining)/12;
                            scmDataList[i].annualTitle = 'Current Contract Total - Previous Contract Total  ('+scmDataList[i].currentContractTotal+' - '+(isNaN(scmDataList[i].previousContractTotal)?0:scmDataList[i].previousContractTotal)+')';
                            scmDataList[i].businessImpact = businessImpact;
                            scmDataList[i].annualImpact = annualImpact;  
                            scmDataList[i].monthsRemaining = monthsRemaining;
                            if(scmDataList[i].businessCategory == 'Business Gained'){
                                /*scmDataList[i].showTPTDiff = true;
                                scmDataList[i].showTotalVariance = true;*/
                                scmDataList[i].previousIndirectPrice = null;
                                scmDataList[i].previousDeadnet = null;
                                scmDataList[i].previousQty = null;
                                scmDataList[i].category = 'Business Gained';
                                totalCurrentFiscalImpact +=(scmDataList[i].previousContractTotal * monthsRemaining)/12;
                                totalProposedFiscalImpact += (scmDataList[i].currentContractTotal * monthsRemaining)/12;
                                totalCurrentTPTFiscalImpact +=(scmDataList[i].previousTPT * monthsRemaining)/12;
                                totalProposedTPTFiscalImpact += (scmDataList[i].currentTPT * monthsRemaining)/12;
                                gainedList.push(scmDataList[i]);
                                totalAnnualImpactBG += ((isNaN(annualImpact) ? 0 : annualImpact));
                                totalBusinessImpactBG += ((isNaN(businessImpact) ? 0 : businessImpact));
                                totalPreviousQtyBG += ((isNaN(scmDataList[i].previousQty) ? 0 : scmDataList[i].previousQty));
                                totalQtyBG += ((isNaN(scmDataList[i].awardedQty) ? 0 : scmDataList[i].awardedQty));
                                totalSCMApprovedQtyBG += ((isNaN(scmDataList[i].proposedBottles) ? 0 : scmDataList[i].proposedBottles));
                                previousTotalBG += ((isNaN(scmDataList[i].previousContractTotal) ? 0 : scmDataList[i].previousContractTotal));
                                currentTotalBG += ((isNaN(scmDataList[i].currentContractTotal) ? 0 : scmDataList[i].currentContractTotal));
                                
                                currentTPTBG += ((isNaN(scmDataList[i].currentTPT) ? 0 : scmDataList[i].currentTPT));
                                previousTPTBG += ((isNaN(scmDataList[i].previousTPT) ? 0 : scmDataList[i].previousTPT));
                                priceVarianceBG += ((isNaN(scmDataList[i].priceVariance) ? 0 : scmDataList[i].priceVariance));
                                volumeVarianceBG += ((isNaN(scmDataList[i].volumeVariance) ? 0 : scmDataList[i].volumeVariance));
                            }
                            else if(scmDataList[i].businessCategory == 'Business Retained'){
                                totalCurrentFiscalImpact +=(scmDataList[i].previousContractTotal * monthsRemaining)/12;
                                totalProposedFiscalImpact += (scmDataList[i].currentContractTotal * monthsRemaining)/12;
                                totalCurrentTPTFiscalImpact +=(scmDataList[i].previousTPT * monthsRemaining)/12;
                                totalProposedTPTFiscalImpact += (scmDataList[i].currentTPT * monthsRemaining)/12;
                                if(scmDataList[i].businessImpact > 0){
                                    scmDataList[i].category = 'Business Retained with Gains';
                                    retainedGainList.push(scmDataList[i]);   
                                    totalAnnualImpactBGG += ((isNaN(annualImpact) ? 0 : annualImpact));
                                    totalBusinessImpactBGG += ((isNaN(businessImpact) ? 0 : businessImpact));
                                    totalPreviousQtyBGG += ((isNaN(scmDataList[i].previousQty) ? 0 : scmDataList[i].previousQty));
                                    totalQtyBGG += ((isNaN(scmDataList[i].awardedQty) ? 0 : scmDataList[i].awardedQty));
                                    totalSCMApprovedQtyBGG += ((isNaN(scmDataList[i].proposedBottles) ? 0 : scmDataList[i].proposedBottles));
                                    previousTotalBGG += ((isNaN(scmDataList[i].previousContractTotal) ? 0 : scmDataList[i].previousContractTotal));
                                    currentTotalBGG += ((isNaN(scmDataList[i].currentContractTotal) ? 0 : scmDataList[i].currentContractTotal));
                                    currentTPTBGG += ((isNaN(scmDataList[i].currentTPT) ? 0 : scmDataList[i].currentTPT));
                                    previousTPTBGG += ((isNaN(scmDataList[i].previousTPT) ? 0 : scmDataList[i].previousTPT));
                                    priceVarianceBGG += ((isNaN(scmDataList[i].priceVariance) ? 0 : scmDataList[i].priceVariance));
                                    volumeVarianceBGG += ((isNaN(scmDataList[i].volumeVariance) ? 0 : scmDataList[i].volumeVariance));
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
                                } else{
                                    scmDataList[i].category = 'Business Retained with Loss';
                                    retainedLossList.push(scmDataList[i]);
                                    totalAnnualImpactBGL += ((isNaN(annualImpact) ? 0 : annualImpact));
                                    totalBusinessImpactBGL += ((isNaN(businessImpact) ? 0 : businessImpact));
                                    totalPreviousQtyBGL += ((isNaN(scmDataList[i].previousQty) ? 0 : scmDataList[i].previousQty));
                                    totalQtyBGL += ((isNaN(scmDataList[i].awardedQty) ? 0 : scmDataList[i].awardedQty));
                                    totalSCMApprovedQtyBGL += ((isNaN(scmDataList[i].proposedBottles) ? 0 : scmDataList[i].proposedBottles));
                                    previousTotalBGL += ((isNaN(scmDataList[i].previousContractTotal) ? 0 : scmDataList[i].previousContractTotal));
                                    currentTotalBGL += ((isNaN(scmDataList[i].currentContractTotal) ? 0 : scmDataList[i].currentContractTotal));
                                    currentTPTBGL += ((isNaN(scmDataList[i].currentTPT) ? 0 : scmDataList[i].currentTPT));
                                    previousTPTBGL += ((isNaN(scmDataList[i].previousTPT) ? 0 : scmDataList[i].previousTPT));
                                    priceVarianceBGL += ((isNaN(scmDataList[i].priceVariance) ? 0 : scmDataList[i].priceVariance));
                                    volumeVarianceBGL += ((isNaN(scmDataList[i].volumeVariance) ? 0 : scmDataList[i].volumeVariance));
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
                                        totalCurrentFiscalImpact +=(scmDataList[i].previousContractTotal * monthsRemaining)/12;
                                        totalProposedFiscalImpact += (scmDataList[i].currentContractTotal * monthsRemaining)/12;
                                        totalCurrentTPTFiscalImpact +=(scmDataList[i].previousTPT * monthsRemaining)/12;
                                        totalProposedTPTFiscalImpact += (scmDataList[i].currentTPT * monthsRemaining)/12;
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
                                    } else{
                                        var listOfProducts = removalsDataFormattingObj[scmDataList[i].customer];
                                        scmDataList[i].annualTitle = 'Deadnet Price * Quantity  ('+scmDataList[i].previousIndirectPrice+' * '+scmDataList[i].previousQty+')';
                                        if(listOfProducts != null){ 
                                            if(scmDataList[i].removalEffectiveDate != null){
                                                scmDataList[i].removalEffectiveDate = new Date(scmDataList[i].removalEffectiveDate).toLocaleDateString("en-US", { year: "numeric", month: "2-digit", day: "2-digit" });   
                                            }
                                            var annualImpact = scmDataList[i].previousQty * scmDataList[i].previousIndirectPrice;
                                            if(annualImpact != 0 && annualImpact != null)
                                                scmDataList[i].annualImpact = parseInt(Math.abs(annualImpact) * -1);
                                            else 
                                                scmDataList[i].annualImpact = 0;
                                            scmDataList[i].businessTitle = '(Annual Impact * Impacted Months)/12 [('+(scmDataList[i].annualImpact).toFixed()+' * '+monthsRemaining.toFixed(2)+')/12]';
                                            scmDataList[i].businessImpact = (scmDataList[i].annualImpact * monthsRemaining)/12;
                                            if(scmDataList[i].businessImpact == 'Infinity' || isNaN(scmDataList[i].businessImpact) || scmDataList[i].businessImpact == null){
                                                scmDataList[i].businessImpact = 'N/A';
                                            }
                                            listOfProducts.push(scmDataList[i]);
                                            totalAnnualImpactBL += ((isNaN(scmDataList[i].annualImpact) ? 0 : scmDataList[i].annualImpact));
                                            totalBusinessImpactBL += ((isNaN(scmDataList[i].businessImpact) ? 0 : scmDataList[i].businessImpact));
                                            previousTotalBL += Math.abs(scmDataList[i].annualImpact);
                                            currentTotalBL += 0;
                                            removalsDataFormattingObj[scmDataList[i].customer] = listOfProducts;                                    
                                        } else{
                                            var listOfProducts = [];
                                            if(scmDataList[i].removalEffectiveDate != null){
                                                scmDataList[i].removalEffectiveDate = new Date(scmDataList[i].removalEffectiveDate).toLocaleDateString("en-US", { year: "numeric", month: "2-digit", day: "2-digit" });   
                                            }
                                            var annualImpact = scmDataList[i].previousQty * scmDataList[i].previousIndirectPrice;
                                            if(annualImpact != 0 && annualImpact != null)
                                                scmDataList[i].annualImpact = parseInt(Math.abs(annualImpact) * -1);
                                            else 
                                                scmDataList[i].annualImpact = 0;
                                            scmDataList[i].businessTitle = '(Annual Impact * Impacted Months)/12 [('+(scmDataList[i].annualImpact).toFixed()+' * '+monthsRemaining.toFixed(2)+')/12]';
                                            scmDataList[i].businessImpact = (scmDataList[i].annualImpact * monthsRemaining)/12;
                                            if(scmDataList[i].businessImpact == 'Infinity' || isNaN(scmDataList[i].businessImpact) || scmDataList[i].businessImpact == null){
                                                scmDataList[i].businessImpact = 'N/A';
                                            }
                                            listOfProducts.push(scmDataList[i]);
                                            totalAnnualImpactBL += ((isNaN(scmDataList[i].annualImpact) ? 0 : scmDataList[i].annualImpact));
                                            totalBusinessImpactBL += ((isNaN(scmDataList[i].businessImpact) ? 0 : scmDataList[i].businessImpact));
                                            previousTotalBL += Math.abs(scmDataList[i].annualImpact);
                                            currentTotalBL += 0;
                                            removalsDataFormattingObj[scmDataList[i].customer] = listOfProducts;                                    
                                        }
                                        scmDataList[i].category = 'Business Lost';
                                        scmDataList[i].monthsRemaining = monthsRemaining;
                                        lossList.push(scmDataList[i]);   
                                    }
                                } 
                                    else if(scmDataList[i].businessCategory == 'No Effect'){
                                        scmDataList[i].currentContractTotal = parseInt(isNaN(scmDataList[i].awardedQty * scmDataList[i].currentDeadnet)? 0 :(scmDataList[i].awardedQty * scmDataList[i].currentDeadnet));
                                        scmDataList[i].previousContractTotal = parseInt(isNaN(scmDataList[i].previousQty * scmDataList[i].previousDeadnet)? 0 :(scmDataList[i].previousQty * scmDataList[i].previousDeadnet));
                                        scmDataList[i].contractTotalCurrentTitle = 'Awarded Qty * Current Deadnet ('+scmDataList[i].awardedQty+'*'+scmDataList[i].currentDeadnet+')';
                                        scmDataList[i].contractTotalPreviousTitle = 'Previous Qty * Previous Deadnet ('+scmDataList[i].previousQty+'*'+((scmDataList[i].previousDeadnet != undefined)?scmDataList[i].previousDeadnet:0)+')';
                                        annualImpact = (scmDataList[i].currentContractTotal-(isNaN(scmDataList[i].previousContractTotal)?0:scmDataList[i].previousContractTotal));
                                        scmDataList[i].businessTitle = '(Annual Impact * Impacted Months)/12 [('+annualImpact+' * '+monthsRemaining.toFixed(2)+')/12]';
                                        scmDataList[i].annualImpact = annualImpact;
                                        previousTotalNE += ((isNaN(scmDataList[i].previousContractTotal) ? 0 : scmDataList[i].previousContractTotal));
                                        currentTotalNE += ((isNaN(scmDataList[i].currentContractTotal) ? 0 : scmDataList[i].currentContractTotal));
                                        totalAnnualImpactNE += ((isNaN(annualImpact) ? 0 : annualImpact));
                                        totalBusinessImpactNE += ((isNaN(businessImpact) ? 0 : businessImpact));
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
                                        scmDataList[i].category = 'No Effect';
                                        noEffectList.push(scmDataList[i]);
                                    }
                                        else if(scmDataList[i].businessCategory == 'Open Status'){
                                            scmDataList[i].currentContractTotal = parseInt(isNaN(scmDataList[i].awardedQty * scmDataList[i].currentDeadnet)? 0 :(scmDataList[i].awardedQty * scmDataList[i].currentDeadnet));
                                            scmDataList[i].previousContractTotal = parseInt(isNaN(scmDataList[i].previousQty * scmDataList[i].previousDeadnet)? 0 :(scmDataList[i].previousQty * scmDataList[i].previousDeadnet));
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
                                    totalCurrentFiscalImpact += isNaN(scmDataList[i].businessImpact)?0:parseFloat(scmDataList[i].businessImpact);
                                    lossList.push(scmDataList[i]);
                                    RFPLossList.push(scmDataList[i]);
                                }
                                else{
                                    scmDataList[i].annualTitle = 'Deadnet Price * Quantity  ('+scmDataList[i].previousIndirectPrice+' * '+scmDataList[i].previousQty+')';
                                    var listOfProducts = removalsDataFormattingObj[scmDataList[i].customer];
                                    if(listOfProducts != null){ 
                                        if(scmDataList[i].removalEffectiveDate != null){
                                            scmDataList[i].removalEffectiveDate = new Date(scmDataList[i].removalEffectiveDate).toLocaleDateString("en-US", { year: "numeric", month: "2-digit", day: "2-digit" });   
                                        }
                                        var annualImpact = scmDataList[i].previousQty * scmDataList[i].previousIndirectPrice;
                                        if(annualImpact != 0 && annualImpact != null)
                                            scmDataList[i].annualImpact = parseInt(Math.abs(annualImpact) * -1);
                                        else 
                                            scmDataList[i].annualImpact = 0;
                                        scmDataList[i].businessTitle = '(Annual Impact * Impacted Months)/12 [('+(scmDataList[i].annualImpact).toFixed()+' * '+monthsRemaining.toFixed(2)+')/12]';
                                        scmDataList[i].businessImpact = (scmDataList[i].annualImpact * monthsRemaining)/12;
                                        if(scmDataList[i].businessImpact == 'Infinity' || isNaN(scmDataList[i].businessImpact) || scmDataList[i].businessImpact == null){
                                            scmDataList[i].businessImpact = 'N/A';
                                        }
                                        listOfProducts.push(scmDataList[i]);
                                        totalAnnualImpactBL += ((isNaN(scmDataList[i].annualImpact) ? 0 : scmDataList[i].annualImpact));
                                        totalBusinessImpactBL += ((isNaN(scmDataList[i].businessImpact) ? 0 : scmDataList[i].businessImpact));
                                        previousTotalBL += Math.abs(scmDataList[i].annualImpact);
                                        currentTotalBL += 0;
                                        removalsDataFormattingObj[scmDataList[i].customer] = listOfProducts;                                    
                                    } else{
                                        var listOfProducts = [];
                                        if(scmDataList[i].removalEffectiveDate != null){
                                            scmDataList[i].removalEffectiveDate = new Date(scmDataList[i].removalEffectiveDate).toLocaleDateString("en-US", { year: "numeric", month: "2-digit", day: "2-digit" });   
                                        }
                                        var annualImpact = scmDataList[i].previousQty * scmDataList[i].previousIndirectPrice;
                                        if(annualImpact != 0 && annualImpact != null)
                                            scmDataList[i].annualImpact = parseInt(Math.abs(annualImpact) * -1);
                                        else 
                                            scmDataList[i].annualImpact = 0;
                                        scmDataList[i].businessTitle = '(Annual Impact * Impacted Months)/12 [('+(scmDataList[i].annualImpact).toFixed()+' * '+monthsRemaining.toFixed(2)+')/12]';
                                        scmDataList[i].businessImpact = (scmDataList[i].annualImpact * monthsRemaining)/12;
                                        if(scmDataList[i].businessImpact == 'Infinity' || isNaN(scmDataList[i].businessImpact) || scmDataList[i].businessImpact == null){
                                            scmDataList[i].businessImpact = 'N/A';
                                        }
                                        listOfProducts.push(scmDataList[i]);
                                        totalAnnualImpactBL += ((isNaN(scmDataList[i].annualImpact) ? 0 : scmDataList[i].annualImpact));
                                        totalBusinessImpactBL += ((isNaN(scmDataList[i].businessImpact) ? 0 : scmDataList[i].businessImpact));
                                        previousTotalBL += Math.abs(scmDataList[i].annualImpact);
                                        currentTotalBL += 0;
                                        removalsDataFormattingObj[scmDataList[i].customer] = listOfProducts;                                    
                                    }
                                    lossList.push(scmDataList[i]);   
                                }
                            } 
                            else if(scmDataList[i].businessCategory == 'No Effect'){
                                scmDataList[i].currentContractTotal = parseInt(isNaN(scmDataList[i].awardedQty * scmDataList[i].currentDeadnet)? 0 :(scmDataList[i].awardedQty * scmDataList[i].currentDeadnet));
                                scmDataList[i].previousContractTotal = parseInt(isNaN(scmDataList[i].previousQty * scmDataList[i].previousDeadnet)? 0 :(scmDataList[i].previousQty * scmDataList[i].previousDeadnet));
                                scmDataList[i].contractTotalCurrentTitle = 'Awarded Qty * Current Deadnet ('+scmDataList[i].awardedQty+'*'+scmDataList[i].currentDeadnet+')';
                                scmDataList[i].contractTotalPreviousTitle = 'Previous Qty * Previous Deadnet ('+scmDataList[i].previousQty+'*'+((scmDataList[i].previousDeadnet != undefined)?scmDataList[i].previousDeadnet:0)+')';
                                annualImpact = (scmDataList[i].currentContractTotal-(isNaN(scmDataList[i].previousContractTotal)?0:scmDataList[i].previousContractTotal));
                                scmDataList[i].businessTitle = '(Annual Impact * Impacted Months)/12 [('+annualImpact+' * '+monthsRemaining.toFixed(2)+')/12]';
                                scmDataList[i].annualImpact = annualImpact;
                                previousTotalNE += ((isNaN(scmDataList[i].previousContractTotal) ? 0 : scmDataList[i].previousContractTotal));
                                currentTotalNE += ((isNaN(scmDataList[i].currentContractTotal) ? 0 : scmDataList[i].currentContractTotal));
                                totalAnnualImpactNE += ((isNaN(annualImpact) ? 0 : annualImpact));
                                totalBusinessImpactNE += ((isNaN(businessImpact) ? 0 : businessImpact));
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
                                    scmDataList[i].currentContractTotal = parseInt(isNaN(scmDataList[i].awardedQty * scmDataList[i].currentDeadnet)? 0 :(scmDataList[i].awardedQty * scmDataList[i].currentDeadnet));
                                    scmDataList[i].previousContractTotal = parseInt(isNaN(scmDataList[i].previousQty * scmDataList[i].previousDeadnet)? 0 :(scmDataList[i].previousQty * scmDataList[i].previousDeadnet));
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
                    totalObj.previousTotalBLRFP = parseInt(previousTotalBLRFP);
                    totalObj.currentTotalBLRFP = parseInt(currentTotalBLRFP);
                    totalObj.totalAnnualImpactBLRFP = parseInt(totalAnnualImpactBLRFP);
                    totalObj.totalBusinessImpactBLRFP = parseInt(totalBusinessImpactBLRFP);
                    totalObj.totalPreviousQtyBLRFP = parseInt(totalPreviousQtyBLRFP);
                    totalObj.totalQtyBLRFP = parseInt(totalQtyBLRFP);
                    totalObj.previousTPTBLRFP = parseInt(previousTPTBLRFP);
                    totalObj.currentTPTBLRFP = parseInt(currentTPTBLRFP);
                    totalObj.previousTPTPerBLRFP = (!isFinite(totalObj.previousTPTBLRFP/totalObj.previousTotalBLRFP) ? 0 : (totalObj.previousTPTBLRFP/totalObj.previousTotalBLRFP));
                    totalObj.currentTPTPerBLRFP = (!isFinite(totalObj.currentTPTBLRFP/totalObj.currentTotalBLRFP) ? 0 : (totalObj.currentTPTBLRFP/totalObj.currentTotalBLRFP));
                    totalObj.priceVarianceBLRFP = parseInt(priceVarianceBLRFP);
                    totalObj.volumeVarianceBLRFP = parseInt(volumeVarianceBLRFP);
                    
                    
                    totalObj.totalCurrentFiscalImpact = totalCurrentFiscalImpact;
                    totalObj.totalProposedFiscalImpact = totalProposedFiscalImpact;
                    totalObj.salesFiscalVar = parseInt(totalProposedFiscalImpact-totalCurrentFiscalImpact);
                    totalObj.salesFiscalVarPer = parseFloat((totalObj.salesFiscalVar/totalObj.totalCurrentFiscalImpact)*100).toFixed(2);
                    totalObj.totalCurrentTPTFiscalImpact = totalCurrentTPTFiscalImpact;
                    totalObj.totalProposedTPTFiscalImpact = totalProposedTPTFiscalImpact;
                    totalObj.tptFiscalVar = parseInt(totalProposedTPTFiscalImpact-totalCurrentTPTFiscalImpact);
                    totalObj.tptFiscalVarPer = parseFloat((totalObj.tptFiscalVar/totalObj.totalCurrentTPTFiscalImpact)*100).toFixed(2);
                    
                    totalObj.awardedQtyChangesCount = volumeChangeList.length;
                    totalObj.deadnetChangesCount = priceChangeList.length;
                    totalObj.bothPriceAndVolumeChangesCount = bothList.length;
                    totalObj.currentTotal = currentTotal;
                    totalObj.previousTotal = previousTotal;
                    totalObj.totalAnnualImpactBG = totalAnnualImpactBG; totalObj.totalBusinessImpactBG = totalBusinessImpactBG; totalObj.totalPreviousQtyBG = totalPreviousQtyBG; totalObj.totalQtyBG = totalQtyBG; totalObj.totalSCMApprovedQtyBG = totalSCMApprovedQtyBG; totalObj.previousTotalBG = previousTotalBG;totalObj.currentTotalBG = currentTotalBG;totalObj.currentTPTBG = parseInt(currentTPTBG); totalObj.previousTPTBG =  parseInt(previousTPTBG);totalObj.priceVarianceBG =  parseInt(priceVarianceBG);totalObj.volumeVarianceBG =  parseInt(volumeVarianceBG);totalObj.currentTPTPerBG = (!isFinite(totalObj.currentTPTBG/totalObj.currentTotalBG) ? 0 : (totalObj.currentTPTBG/totalObj.currentTotalBG));totalObj.previousTPTPerBG = (!isFinite(totalObj.previousTPTBG/totalObj.previousTotalBG) ? 0 : (totalObj.previousTPTBG/totalObj.previousTotalBG));
                    totalObj.totalAnnualImpactBGG = totalAnnualImpactBGG; totalObj.totalBusinessImpactBGG = totalBusinessImpactBGG; totalObj.totalPreviousQtyBGG = totalPreviousQtyBGG; totalObj.totalQtyBGG = totalQtyBGG; totalObj.totalSCMApprovedQtyBGG = totalSCMApprovedQtyBGG; totalObj.previousTotalBGG = previousTotalBGG;totalObj.currentTotalBGG = currentTotalBGG;totalObj.currentTPTBGG =  parseInt(currentTPTBGG);totalObj.previousTPTBGG =  parseInt(previousTPTBGG);totalObj.priceVarianceBGG =  parseInt(priceVarianceBGG);totalObj.volumeVarianceBGG = parseInt(volumeVarianceBGG);totalObj.currentTPTPerBGG = (!isFinite(totalObj.currentTPTBGG/currentTotalBGG) ? 0 : (totalObj.currentTPTBGG/currentTotalBGG));totalObj.previousTPTPerBGG = (!isFinite(totalObj.previousTPTBGG/previousTotalBGG) ? 0 : (totalObj.previousTPTBGG/previousTotalBGG));
                    totalObj.totalAnnualImpactBGL = totalAnnualImpactBGL; totalObj.totalBusinessImpactBGL = totalBusinessImpactBGL; totalObj.totalPreviousQtyBGL = totalPreviousQtyBGL; totalObj.totalQtyBGL = totalQtyBGL; totalObj.totalSCMApprovedQtyBGL = totalSCMApprovedQtyBGL; totalObj.previousTotalBGL = previousTotalBGL;totalObj.currentTotalBGL = currentTotalBGL;totalObj.currentTPTBGL =  parseInt(currentTPTBGL);totalObj.previousTPTBGL =  parseInt(previousTPTBGL);totalObj.priceVarianceBGL =  parseInt(priceVarianceBGL);totalObj.volumeVarianceBGL =  parseInt(volumeVarianceBGL);totalObj.currentTPTPerBGL = (!isFinite(totalObj.currentTPTBGL/currentTotalBGL) ? 0 : (totalObj.currentTPTBGL/currentTotalBGL));totalObj.previousTPTPerBGL = (!isFinite(totalObj.previousTPTBGL/previousTotalBGL) ? 0 : (totalObj.previousTPTBGL/previousTotalBGL));
                    totalObj.totalAnnualImpactNE = totalAnnualImpactNE; totalObj.totalBusinessImpactNE = totalBusinessImpactNE; totalObj.totalPreviousQtyNE = totalPreviousQtyNE; totalObj.totalQtyNE = totalQtyNE; totalObj.totalSCMApprovedQtyNE = totalSCMApprovedQtyNE; totalObj.previousTotalNE = previousTotalNE;totalObj.currentTotalNE = currentTotalNE;totalObj.currentTPTNE =  parseInt(currentTPTNE);totalObj.previousTPTNE =  parseInt(previousTPTNE);totalObj.priceVarianceNE =  parseInt(priceVarianceNE);totalObj.volumeVarianceNE =  parseInt(volumeVarianceNE);totalObj.currentTPTPerNE = (!isFinite(totalObj.currentTPTNE/currentTotalNE) ? 0 : (totalObj.currentTPTNE/currentTotalNE));totalObj.previousTPTPerNE = (!isFinite(totalObj.previousTPTNE/previousTotalNE) ? 0 : (totalObj.previousTPTNE/previousTotalNE));
                    totalObj.totalAnnualImpactOS = totalAnnualImpactOS; totalObj.totalBusinessImpactOS = totalBusinessImpactOS; totalObj.totalPreviousQtyOS = totalPreviousQtyOS; totalObj.totalQtyOS = totalQtyOS; totalObj.totalSCMApprovedQtyOS = totalSCMApprovedQtyOS; totalObj.previousTotalOS = previousTotalOS;totalObj.currentTotalOS = currentTotalOS;totalObj.currentTPTOS =  parseInt(currentTPTOS);totalObj.previousTPTOS =  parseInt(previousTPTOS);totalObj.priceVarianceOS =  parseInt(priceVarianceOS);totalObj.volumeVarianceOS =  parseInt(volumeVarianceOS);totalObj.currentTPTPerOS = (!isFinite(totalObj.currentTPTOS/currentTotalOS) ? 0 : (totalObj.currentTPTOS/currentTotalOS));totalObj.previousTPTPerOS = (!isFinite(totalObj.previousTPTOS/previousTotalOS) ? 0 : (totalObj.previousTPTOS/previousTotalOS));
                    totalObj.totalAnnualImpactBL = totalAnnualImpactBL; totalObj.totalBusinessImpactBL = totalBusinessImpactBL;
                    totalObj.totalAnnualImpact = parseInt((isNaN(totalAnnualImpactBG) ? 0: totalAnnualImpactBG) + (isNaN(totalAnnualImpactBGG) ? 0: totalAnnualImpactBGG) + (isNaN(totalAnnualImpactBGL) ? 0: totalAnnualImpactBGL) + (isNaN(totalAnnualImpactBL) ? 0: totalAnnualImpactBL)); // + (isNaN(totalAnnualImpactNE) ? 0: totalAnnualImpactNE)
                    totalObj.totalBusinessImpact = parseInt((isNaN(totalBusinessImpactBG) ? 0: totalBusinessImpactBG) + (isNaN(totalBusinessImpactBGG) ? 0: totalBusinessImpactBGG) + (isNaN(totalBusinessImpactBGL) ? 0: totalBusinessImpactBGL) + (isNaN(totalBusinessImpactBL) ? 0: totalBusinessImpactBL)); // + (isNaN(totalBusinessImpactNE) ? 0: totalBusinessImpactNE)
                    totalObj.totalPreviousTotal = parseInt((isNaN(previousTotalBG) ? 0: previousTotalBG) + (isNaN(previousTotalBGG) ? 0: previousTotalBGG) + (isNaN(previousTotalBGL) ? 0: previousTotalBGL) + (isNaN(previousTotalBL) ? 0: previousTotalBL)); // + (isNaN(previousTotalNE) ? 0: previousTotalNE)
                    totalObj.totalCurrentTotal = parseInt((isNaN(currentTotalBG) ? 0: currentTotalBG) + (isNaN(currentTotalBGG) ? 0: currentTotalBGG) + (isNaN(currentTotalBGL) ? 0: currentTotalBGL) + (isNaN(currentTotalBL) ? 0: currentTotalBL)); // + (isNaN(currentTotalNE) ? 0: currentTotalNE)
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
                    totalObj.tptVariance = parseInt(totalObj.currentTPT - totalObj.previousTPT);
                    totalObj.tptVariancePer = (((totalObj.currentTPT - totalObj.previousTPT) / totalObj.previousTPT)*100).toFixed(2);
                    totalObj.priceVariance = parseInt(priceVarianceBG+priceVarianceBGG+priceVarianceBGL+priceVarianceBL);
                    totalObj.volumeVariance = parseInt(volumeVarianceBG+volumeVarianceBGG+volumeVarianceBGL+volumeVarianceBL);
                    if(removalsDataFormattingObj != null){
                        totalObj.totalPreviousTotalTitle = '('+ (isNaN(previousTotalBL) ? 0: previousTotalBL.toFixed())+')';    
                        totalObj.totalCurrentTotalTitle = '('+ (isNaN(currentTotalBL) ? 0: currentTotalBL.toFixed())+')';    
                    } else{
                        totalObj.totalPreviousTotalTitle = '('+(isNaN(previousTotalBG) ? 0: previousTotalBG.toFixed())+') + (' + (isNaN(previousTotalBGG) ? 0: previousTotalBGG.toFixed())+') + (' + (isNaN(previousTotalBGL) ? 0: previousTotalBGL.toFixed())+')';
                        totalObj.totalCurrentTotalTitle = '('+(isNaN(currentTotalBG) ? 0: currentTotalBG.toFixed())+') + (' + (isNaN(currentTotalBGG) ? 0: currentTotalBGG.toFixed())+') + (' + (isNaN(currentTotalBGL) ? 0: currentTotalBGL.toFixed())+')';
                    }
                    totalObj.percentageChange = (((totalObj.totalCurrentTotal - totalObj.totalPreviousTotal) / totalObj.totalPreviousTotal)*100).toFixed(2);
                    totalObj.change = parseInt((totalObj.totalCurrentTotal - totalObj.totalPreviousTotal));
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
                    totalObj.totalAwards = (component.get("v.gainedList") != null ? component.get("v.gainedList").length : 0);
                    component.set("v.isSCMApprovePerson",scmDataList[0].isSCMApprovePerson);
                    if(scmDataList[0].bidType != 'RFP Bids' && scmDataList[0].businessCategory == 'Business Lost'){
                        component.set("v.totalLineItems", lossList.length);
                    }
                    else{
                        component.set("v.totalLineItems", scmDataList.length);
                        totalObj.totalAnnualImpactTitle = '('+(isNaN(totalAnnualImpactBG) ? 0: totalAnnualImpactBG.toFixed())+') + (' + (isNaN(totalAnnualImpactBGG) ? 0: totalAnnualImpactBGG.toFixed())+') + (' + (isNaN(totalAnnualImpactBGL) ? 0: totalAnnualImpactBGL.toFixed())+')'; // + (' + (isNaN(totalAnnualImpactNE) ? 0: totalAnnualImpactNE.toFixed())+')
                        totalObj.totalBusinessImpactTitle = '('+(isNaN(totalBusinessImpactBG) ? 0: totalBusinessImpactBG.toFixed())+') + (' + (isNaN(totalBusinessImpactBGG) ? 0: totalBusinessImpactBGG.toFixed())+') + (' + (isNaN(totalBusinessImpactBGL) ? 0: totalBusinessImpactBGL.toFixed())+')'; // + (' + (isNaN(totalBusinessImpactNE) ? 0: totalBusinessImpactNE.toFixed())+')
                    }
                    var total = component.get("v.totalLineItems");
                    totalObj.percentNewAwards = (totalObj.totalAwards/total)*100;
                    totalObj.percentPriceChanges = (totalObj.deadnetChangesCount/total)*100;
                    totalObj.percentQtyChanges = (totalObj.awardedQtyChangesCount/total)*100;
                    totalObj.percentBothChanges = (totalObj.bothPriceAndVolumeChangesCount/total)*100;
                    totalObj.percentLoss = (lossList.length/total)*100;
                    totalObj.percentNoEffects = (noEffectList.length/total)*100;
                    totalObj.percentOpen = (openStatusList.length/total)*100;
                    
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
                    
                    component.set("v.categoryTotals", totalObj);
                    
                    var gainedMap = {};
                    var gainedFamilySummaryMap = {};
                    var totalPreviousTPT = 0;var totalCurrentTPT = 0;var totalPriceVariance = 0;var totalVolumeVariance = 0;
                    var totalVariance = 0;var totalTPTVariance = 0; var totalPreviousQtyBG = 0; var totalAwardedQtyBG = 0;
                    gainedList.forEach(function(rec){
                        if(gainedMap.hasOwnProperty(rec.productFamily)){
                            var relatedList = gainedMap[rec.productFamily]; var summary = [];
                            relatedList.push(rec);
                            gainedMap[rec.productFamily] = relatedList;
                            var previousTotal = 0; var currentTotal = 0; var annualImapact = 0; var businessImpact = 0; var previousTPT = 0; var currentTPT = 0;
                            var previousTPTFamilySummary = 0; var currentTPTFamilySummary = 0; var priceVarianceFamilySummary = 0; var volumeVarianceFamilySummary = 0;
                            var totalVarianceFamilySummary = 0; var tptVarianceFamilySummary = 0; var unit1 = 0; var unit2 = 0; var unit3 = 0; var unit4 = 0; var unit5=0; var unit6 = 0; var unit7=0; var unit8 = 0;
                            var totalPreviousAwdQtySummary = 0; var totalAwdQtySummary = 0;var unit10 = 0;
                            var totalSummary1 = 0; var totalSummary2 = 0; var totalSummary3 = 0; var totalSummary4 = 0; var totalSummary5 = 0;
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
                                unit1 += ((isNaN(relatedList[i].unit1) ? 0 : relatedList[i].unit1));
                                unit2 += ((isNaN(relatedList[i].unit2) ? 0 : relatedList[i].unit2));
                                unit3 += ((isNaN(relatedList[i].unit3) ? 0 : relatedList[i].unit3));
                                unit4 += ((isNaN(relatedList[i].unit4) ? 0 : relatedList[i].unit4));
                                unit5 += ((isNaN(relatedList[i].unit5) ? 0 : relatedList[i].unit5));
                                unit6 += ((isNaN(relatedList[i].unit6) ? 0 : relatedList[i].unit6));
                                unit7 += ((isNaN(relatedList[i].unit7) ? 0 : relatedList[i].unit7));
                                unit8 += ((isNaN(relatedList[i].unit8) ? 0 : relatedList[i].unit8));
                                unit10 += ((isNaN(relatedList[i].unit10) ? 0 : relatedList[i].unit10));
                                if(relatedList[i].bidRecord.Phoenix_Customer_Type__c == 'Net Indirect Pricing' || relatedList[i].bidRecord.Phoenix_Customer_Type__c == 'Direct and Indirect' || relatedList[i].bidRecord.Phoenix_Customer_Type__c == 'Econdisc'){
                                    totalSummary1 += ((isNaN(relatedList[i].bidLineItem.Phoenix_Final_Direct_Selling_Units_Calc__c) ? 0 : parseFloat(relatedList[i].bidLineItem.Phoenix_Final_Direct_Selling_Units_Calc__c)));
                                    totalSummary2 += ((isNaN(relatedList[i].bidLineItem.Phoenix_Final_Indirect_Selling_Units_Cal__c) ? 0 : parseFloat(relatedList[i].bidLineItem.Phoenix_Final_Indirect_Selling_Units_Cal__c)));
                                } else if(relatedList[i].bidRecord.Phoenix_Customer_Type__c == 'Direct'){
                                    totalSummary1 += ((isNaN(relatedList[i].bidLineItem.Phoenix_Total_SCM_Approved_Qty__c) ? 0 : parseFloat(relatedList[i].bidLineItem.Phoenix_Total_SCM_Approved_Qty__c)));
                                } else if(relatedList[i].bidRecord.Phoenix_Customer_Type__c == 'BASE/DSH'){
                                    totalSummary1 += ((isNaN(relatedList[i].bidLineItem.Phoenix_IDN_Usage__c) ? 0 : parseFloat(relatedList[i].bidLineItem.Phoenix_IDN_Usage__c)));
                                    totalSummary2 += ((isNaN(relatedList[i].bidLineItem.Phoenix_Days_Notice_Product_Discontinuat__c) ? 0 : parseFloat(relatedList[i].bidLineItem.Phoenix_Days_Notice_Product_Discontinuat__c)));
                                    totalSummary3 += ((isNaN(relatedList[i].bidLineItem.Phoenix_Day_s_Notice_Product_removal__c) ? 0 : parseFloat(relatedList[i].bidLineItem.Phoenix_Day_s_Notice_Product_removal__c)));
                                } else if(relatedList[i].bidRecord.Phoenix_Customer_Type__c == 'ROS'){
                                    totalSummary1 += ((isNaN(relatedList[i].bidLineItem.Phoenix_Current_Anda_Units__c) ? 0 : parseFloat(relatedList[i].bidLineItem.Phoenix_Current_Anda_Units__c)));
                                    totalSummary2 += ((isNaN(relatedList[i].bidLineItem.Phoenix_Current_Indirect_Gaint_EagleUnit__c) ? 0 : parseFloat(relatedList[i].bidLineItem.Phoenix_Current_Indirect_Gaint_EagleUnit__c)));
                                    totalSummary3 += ((isNaN(relatedList[i].bidLineItem.Phoenix_ProposedIndirectAholdDelhaizeUni__c) ? 0 : parseFloat(relatedList[i].bidLineItem.Phoenix_ProposedIndirectAholdDelhaizeUni__c)));
                                    totalSummary4 += ((isNaN(relatedList[i].bidLineItem.Phoenix_Proposed_IndirectGaintEagleUnits__c) ? 0 : parseFloat(relatedList[i].bidLineItem.Phoenix_Proposed_IndirectGaintEagleUnits__c)));
                                } else if(relatedList[i].bidRecord.Phoenix_Customer_Type__c == 'RXSS'){
                                    totalSummary1 += ((isNaN(relatedList[i].bidLineItem.Phoenix_Day_s_Notice_Product_removal__c) ? 0 : parseFloat(relatedList[i].bidLineItem.Phoenix_Day_s_Notice_Product_removal__c)));
                                    totalSummary2 += ((isNaN(relatedList[i].bidLineItem.Phoenix_Current_Indirect_Gaint_EagleUnit__c) ? 0 : parseFloat(relatedList[i].bidLineItem.Phoenix_Current_Indirect_Gaint_EagleUnit__c)));
                                    totalSummary3 += ((isNaN(relatedList[i].bidLineItem.Phoenix_Proposed_IndirectGaintEagleUnits__c) ? 0 : parseFloat(relatedList[i].bidLineItem.Phoenix_Proposed_IndirectGaintEagleUnits__c)));
                                    totalSummary4 += ((isNaN(relatedList[i].bidLineItem.Phoenix_IDN_Usage__c) ? 0 : parseFloat(relatedList[i].bidLineItem.Phoenix_IDN_Usage__c)));
                                    totalSummary5 += ((isNaN(relatedList[i].bidLineItem.Phoenix_Days_Notice_Product_Discontinuat__c) ? 0 : parseFloat(relatedList[i].bidLineItem.Phoenix_Days_Notice_Product_Discontinuat__c)));
                                } else if(relatedList[i].bidRecord.Phoenix_Customer_Type__c == 'OneTimeBuy'){
                                    totalSummary1 += ((isNaN(relatedList[i].bidLineItem.Phoenix_Total_SCM_Approved_Qty__c) ? 0 : parseFloat(relatedList[i].bidLineItem.Phoenix_Total_SCM_Approved_Qty__c)));
                                } else if(relatedList[i].bidRecord.Phoenix_Customer_Type__c == 'ClarusOne'){
                                    totalSummary1 += ((isNaN(relatedList[i].bidLineItem.Phoenix_ProposedIndirectAholdDelhaizeUni__c) ? 0 : parseFloat(relatedList[i].bidLineItem.Phoenix_ProposedIndirectAholdDelhaizeUni__c)));
                                    totalSummary2 += ((isNaN(relatedList[i].bidLineItem.Phoenix_Proposed_IndirectGaintEagleUnits__c) ? 0 : parseFloat(relatedList[i].bidLineItem.Phoenix_Proposed_IndirectGaintEagleUnits__c)));
                                    totalSummary3 += ((isNaN(relatedList[i].bidLineItem.Phoenix_Final_Direct_Selling_Units_Calc__c) ? 0 : parseFloat(relatedList[i].bidLineItem.Phoenix_Final_Direct_Selling_Units_Calc__c)));
                                } else if(relatedList[i].bidRecord.Phoenix_Customer_Type__c == 'Walgreens' || relatedList[i].bidRecord.Phoenix_Customer_Type__c == 'ABC Progen' || relatedList[i].bidRecord.Phoenix_Customer_Type__c == 'ABC Pharmagen' 
                                          || relatedList[i].bidRecord.Phoenix_Customer_Type__c == 'Costco' || relatedList[i].bidRecord.Phoenix_Customer_Type__c == 'Indirect' || relatedList[i].bidRecord.Phoenix_Customer_Type__c == 'Sams Club' 
                                          || relatedList[i].bidRecord.Phoenix_Customer_Type__c == 'Government Pricing'){
                                    totalSummary1 += ((isNaN(relatedList[i].proposedBottles) ? 0 : parseFloat(relatedList[i].proposedBottles)));
                                }
                            }
                            summary[0] = parseInt(previousTotal);
                            summary[1] = parseInt(currentTotal);
                            summary[2] = parseInt(annualImapact);
                            summary[3] = parseInt(businessImpact);
                            summary[4] = parseInt(previousTPT);
                            summary[5] = parseInt(currentTPT);
                            summary[6] = parseInt(currentTPT) - parseInt(previousTPT);
                            summary[7] = parseInt(priceVarianceFamilySummary);
                            summary[8] = parseInt(volumeVarianceFamilySummary);
                            summary[9] = ((!isFinite(previousTPT/previousTotal) ? 0 : (previousTPT/previousTotal)));
                            summary[10] = ((!isFinite(currentTPT/currentTotal) ? 0 : (currentTPT/currentTotal)));
                            summary[11] = parseInt(unit1);
                            summary[12] = parseInt(unit2);
                            summary[13] = parseInt(unit3);
                            summary[14] = parseInt(unit4);
                            summary[15] = parseInt(unit5);
                            summary[16] = parseInt(unit6);
                            summary[17] = parseInt(totalPreviousAwdQtySummary);
                            summary[18] = parseInt(totalAwdQtySummary);
                            summary[19] = parseInt(unit7);
                            summary[20] = parseInt(unit8);
                            summary[21] = totalSummary1;
                            summary[22] = totalSummary2;
                            summary[23] = totalSummary3;
                            summary[24] = totalSummary4;
                            summary[25] = totalSummary5;
                            summary[26] = parseInt(unit10);
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
                            var unit1 = ((isNaN(rec.unit1) ? 0 : rec.unit1));
                            var unit2 = ((isNaN(rec.unit2) ? 0 : rec.unit2));
                            var unit3 = ((isNaN(rec.unit3) ? 0 : rec.unit3));
                            var unit4 = ((isNaN(rec.unit4) ? 0 : rec.unit4));
                            var unit5 = ((isNaN(rec.unit5) ? 0 : rec.unit5));
                            var unit6 = ((isNaN(rec.unit6) ? 0 : rec.unit6));
                            var unit7 = ((isNaN(rec.unit7) ? 0 : rec.unit7));
                            var unit8 = ((isNaN(rec.unit8) ? 0 : rec.unit8));
                            var unit10 = ((isNaN(rec.unit10) ? 0 : rec.unit10));
                            summary[0] = parseInt(previousTotal);
                            summary[1] = parseInt(currentTotal);
                            summary[2] = parseInt(annualImapact);
                            summary[3] = parseInt(businessImpact);
                            summary[4] = parseInt(previousTPT);
                            summary[5] = parseInt(currentTPT);
                            summary[6] = parseInt(currentTPT) - parseInt(previousTPT);
                            summary[7] = parseInt(priceVarianceFamilySummary);
                            summary[8] = parseInt(volumeVarianceFamilySummary);
                            summary[9] = ((!isFinite(previousTPT/previousTotal) ? 0 : (previousTPT/previousTotal)));
                            summary[10] = ((!isFinite(currentTPT/currentTotal) ? 0 : (currentTPT/currentTotal)));
                            summary[11] = parseInt(unit1);
                            summary[12] = parseInt(unit2);
                            summary[13] = parseInt(unit3);
                            summary[14] = parseInt(unit4);
                            summary[15] = parseInt(unit5);
                            summary[16] = parseInt(unit6);
                            summary[17] = parseInt(totalPreviousAwdQtySummary);
                            summary[18] = parseInt(totalAwdQtySummary);
                            summary[19] = parseInt(unit7);
                            summary[20] = parseInt(unit8);
                            summary[26] = parseInt(unit10);
                            if(rec.bidRecord.Phoenix_Customer_Type__c == 'Net Indirect Pricing' || rec.bidRecord.Phoenix_Customer_Type__c == 'Direct and Indirect' || rec.bidRecord.Phoenix_Customer_Type__c == 'Econdisc' ){
                                var scmSummary1 = ((isNaN(rec.bidLineItem.Phoenix_Final_Direct_Selling_Units_Calc__c) ? 0 : parseFloat(rec.bidLineItem.Phoenix_Final_Direct_Selling_Units_Calc__c)));
                                var scmSummary2 = ((isNaN(rec.bidLineItem.Phoenix_Final_Indirect_Selling_Units_Cal__c) ? 0 : parseFloat(rec.bidLineItem.Phoenix_Final_Indirect_Selling_Units_Cal__c)));
                                summary[21] = scmSummary1;
                                summary[22] = scmSummary2;
                            } else if(rec.bidRecord.Phoenix_Customer_Type__c == 'Direct'){
                                var scmSummary1 = ((isNaN(rec.bidLineItem.Phoenix_Total_SCM_Approved_Qty__c) ? 0 : parseFloat(rec.bidLineItem.Phoenix_Total_SCM_Approved_Qty__c)));
                                summary[21] = parseFloat(scmSummary1);
                            } else if(rec.bidRecord.Phoenix_Customer_Type__c == 'BASE/DSH'){
                                var scmSummary1 = ((isNaN(rec.bidLineItem.Phoenix_IDN_Usage__c) ? 0 : parseFloat(rec.bidLineItem.Phoenix_IDN_Usage__c)));
                                var scmSummary2 = ((isNaN(rec.bidLineItem.Phoenix_Days_Notice_Product_Discontinuat__c) ? 0 : parseFloat(rec.bidLineItem.Phoenix_Days_Notice_Product_Discontinuat__c)));
                                var scmSummary3 = ((isNaN(rec.bidLineItem.Phoenix_Day_s_Notice_Product_removal__c) ? 0 : parseFloat(rec.bidLineItem.Phoenix_Day_s_Notice_Product_removal__c)));
                                summary[21] = scmSummary1;
                                summary[22] = scmSummary2;
                                summary[23] = scmSummary3;
                            } else if(rec.bidRecord.Phoenix_Customer_Type__c == 'ROS'){
                                var scmSummary1 = ((isNaN(rec.bidLineItem.Phoenix_Current_Anda_Units__c) ? 0 : parseFloat(rec.bidLineItem.Phoenix_Current_Anda_Units__c)));
                                var scmSummary2 = ((isNaN(rec.bidLineItem.Phoenix_Current_Indirect_Gaint_EagleUnit__c) ? 0 : parseFloat(rec.bidLineItem.Phoenix_Current_Indirect_Gaint_EagleUnit__c)));
                                var scmSummary3 = ((isNaN(rec.bidLineItem.Phoenix_ProposedIndirectAholdDelhaizeUni__c) ? 0 : parseFloat(rec.bidLineItem.Phoenix_ProposedIndirectAholdDelhaizeUni__c)));
                                var scmSummary4 = ((isNaN(rec.bidLineItem.Phoenix_Proposed_IndirectGaintEagleUnits__c) ? 0 : parseFloat(rec.bidLineItem.Phoenix_Proposed_IndirectGaintEagleUnits__c)));
                                summary[21] = scmSummary1;
                                summary[22] = scmSummary2;
                                summary[23] = scmSummary3;
                                summary[24] = scmSummary4;
                            } else if(rec.bidRecord.Phoenix_Customer_Type__c == 'RXSS'){
                                var scmSummary1 = ((isNaN(rec.bidLineItem.Phoenix_Day_s_Notice_Product_removal__c) ? 0 : parseFloat(rec.bidLineItem.Phoenix_Day_s_Notice_Product_removal__c)));
                                var scmSummary2 = ((isNaN(rec.bidLineItem.Phoenix_Current_Indirect_Gaint_EagleUnit__c) ? 0 : parseFloat(rec.bidLineItem.Phoenix_Current_Indirect_Gaint_EagleUnit__c)));
                                var scmSummary3 = ((isNaN(rec.bidLineItem.Phoenix_Proposed_IndirectGaintEagleUnits__c) ? 0 : parseFloat(rec.bidLineItem.Phoenix_Proposed_IndirectGaintEagleUnits__c)));
                                var scmSummary4 = ((isNaN(rec.bidLineItem.Phoenix_IDN_Usage__c) ? 0 : parseFloat(rec.bidLineItem.Phoenix_IDN_Usage__c)));
                                var scmSummary5 = ((isNaN(rec.bidLineItem.Phoenix_Days_Notice_Product_Discontinuat__c) ? 0 : parseFloat(rec.bidLineItem.Phoenix_Days_Notice_Product_Discontinuat__c)));
                                summary[21] = scmSummary1;
                                summary[22] = scmSummary2;
                                summary[23] = scmSummary3;
                                summary[24] = scmSummary4;
                                summary[25] = scmSummary5;
                            } else if(rec.bidRecord.Phoenix_Customer_Type__c == 'ClarusOne'){
                                var scmSummary1 = ((isNaN(rec.bidLineItem.Phoenix_ProposedIndirectAholdDelhaizeUni__c) ? 0 : parseFloat(rec.bidLineItem.Phoenix_ProposedIndirectAholdDelhaizeUni__c)));
                                var scmSummary2 = ((isNaN(rec.bidLineItem.Phoenix_Proposed_IndirectGaintEagleUnits__c) ? 0 : parseFloat(rec.bidLineItem.Phoenix_Proposed_IndirectGaintEagleUnits__c)));
                                var scmSummary3 = ((isNaN(rec.bidLineItem.Phoenix_Final_Direct_Selling_Units_Calc__c) ? 0 : parseFloat(rec.bidLineItem.Phoenix_Final_Direct_Selling_Units_Calc__c)));
                                summary[21] = scmSummary1;
                                summary[22] = scmSummary2;
                                summary[23] = scmSummary3;
                            } else if(rec.bidRecord.Phoenix_Customer_Type__c == 'OneTimeBuy'){
                                var scmSummary1 = ((isNaN(rec.bidLineItem.Phoenix_Total_SCM_Approved_Qty__c) ? 0 : parseFloat(rec.bidLineItem.Phoenix_Total_SCM_Approved_Qty__c)));
                                summary[21] = scmSummary1;
                            } else if(rec.bidRecord.Phoenix_Customer_Type__c == 'Walgreens' || rec.bidRecord.Phoenix_Customer_Type__c == 'ABC Progen' || rec.bidRecord.Phoenix_Customer_Type__c == 'ABC Pharmagen' 
                                      || rec.bidRecord.Phoenix_Customer_Type__c == 'Costco' || rec.bidRecord.Phoenix_Customer_Type__c == 'Indirect' || rec.bidRecord.Phoenix_Customer_Type__c == 'Sams Club' 
                                      || rec.bidRecord.Phoenix_Customer_Type__c == 'Government Pricing'){
                                var scmSummary1 = ((isNaN(rec.proposedBottles) ? 0 : parseFloat(rec.proposedBottles)));
                                summary[21] = scmSummary1;
                            }
                            gainedFamilySummaryMap[rec.productFamily] = summary;
                        }
                    });
                    
                    var tempObj = {};
                    let keys = Object.keys(gainedFamilySummaryMap);
                    keys.sort(function(a, b) { return gainedFamilySummaryMap[b][2] - gainedFamilySummaryMap[a][2] });
                    var gainSummary = [];
                    gainSummary[11] = 0;
                    gainSummary[12] = 0;
                    gainSummary[13] = 0;
                    gainSummary[14] = 0;
                    gainSummary[15] = 0;
                    gainSummary[16] = 0;
                    gainSummary[17] = 0;
                    gainSummary[18] = 0;
                    gainSummary[19] = 0;
                    gainSummary[20] = 0;
                    gainSummary[21] = 0;
                    gainSummary[22] = 0;
                    gainSummary[23] = 0;
                    gainSummary[24] = 0;
                    gainSummary[25] = 0;
                    gainSummary[26] = 0;
                    for(var i=0; i<keys.length; i++){
                        tempObj[keys[i]] = gainedFamilySummaryMap[keys[i]];
                        var tem = gainedFamilySummaryMap[keys[i]];
                        gainSummary[11] += parseFloat(tem[11]);
                        gainSummary[12] += parseFloat(tem[12]);
                        gainSummary[13] += parseFloat(tem[13]);
                        gainSummary[14] += parseFloat(tem[14]);
                        gainSummary[15] += parseFloat(tem[15]);
                        gainSummary[16] += parseFloat(tem[16]);
                        gainSummary[17] += parseFloat(tem[17]);
                        gainSummary[18] += parseFloat(tem[18]);
                        gainSummary[19] += parseFloat(tem[19]);
                        gainSummary[20] += parseFloat(tem[20]);
                        gainSummary[21] += parseFloat(tem[21]);
                        gainSummary[22] += parseFloat(tem[22]);
                        gainSummary[23] += parseFloat(tem[23]);
                        gainSummary[24] += parseFloat(tem[24]);
                        gainSummary[25] += parseFloat(tem[25]);  
                        gainSummary[26] += parseFloat(tem[26]);
                    }
                    component.set("v.gainSummary", gainSummary);
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

                    var retainedGainMap = {};
                    var retainedGainFamilySummaryMap = {}; var totalAwardedQtyBGG = 0; var totalPreviousQtyBGG = 0;
                    retainedGainList.forEach(function(rec){
                        if(retainedGainMap.hasOwnProperty(rec.productFamily)){
                            var relatedList = retainedGainMap[rec.productFamily]; var summary = [];
                            relatedList.push(rec);
                            retainedGainMap[rec.productFamily] = relatedList;
                            var previousTotal = 0; var currentTotal = 0; var annualImapact = 0; var businessImpact = 0; var previousTPT = 0; var currentTPT = 0;
                            var previousTPTFamilySummary = 0; var currentTPTFamilySummary = 0; var priceVarianceFamilySummary = 0; var volumeVarianceFamilySummary = 0;
                            var totalVarianceFamilySummary = 0; var tptVarianceFamilySummary = 0; var unit1 = 0; var unit2 = 0; var unit3 = 0; var unit4 = 0; var unit5=0;var totalPreviousAwdQtySummary = 0; var totalAwdQtySummary = 0;
                            var unit6 = 0; var unit7=0; var unit8 = 0;var unit10 = 0;
                            var totalSummary1 = 0; var totalSummary2 = 0; var totalSummary3 = 0; var totalSummary4 = 0; var totalSummary5 = 0;
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
                                unit1 += ((isNaN(relatedList[i].unit1) ? 0 : relatedList[i].unit1));
                                unit2 += ((isNaN(relatedList[i].unit2) ? 0 : relatedList[i].unit2));
                                unit3 += ((isNaN(relatedList[i].unit3) ? 0 : relatedList[i].unit3));
                                unit4 += ((isNaN(relatedList[i].unit4) ? 0 : relatedList[i].unit4));
                                unit5 += ((isNaN(relatedList[i].unit5) ? 0 : relatedList[i].unit5));
                                unit6 += ((isNaN(relatedList[i].unit6) ? 0 : relatedList[i].unit6));
                                unit7 += ((isNaN(relatedList[i].unit7) ? 0 : relatedList[i].unit7));
                                unit8 += ((isNaN(relatedList[i].unit8) ? 0 : relatedList[i].unit8));
                                unit10 += ((isNaN(relatedList[i].unit10) ? 0 : relatedList[i].unit10));
                                if(relatedList[i].bidRecord.Phoenix_Customer_Type__c == 'Net Indirect Pricing' || relatedList[i].bidRecord.Phoenix_Customer_Type__c == 'Direct and Indirect' || relatedList[i].bidRecord.Phoenix_Customer_Type__c == 'Econdisc'){
                                    totalSummary1 += ((isNaN(relatedList[i].bidLineItem.Phoenix_Final_Direct_Selling_Units_Calc__c) ? 0 : parseFloat(relatedList[i].bidLineItem.Phoenix_Final_Direct_Selling_Units_Calc__c)));
                                    totalSummary2 += ((isNaN(relatedList[i].bidLineItem.Phoenix_Final_Indirect_Selling_Units_Cal__c) ? 0 : parseFloat(relatedList[i].bidLineItem.Phoenix_Final_Indirect_Selling_Units_Cal__c)));
                                } else if(relatedList[i].bidRecord.Phoenix_Customer_Type__c == 'Direct'){
                                    totalSummary1 += ((isNaN(relatedList[i].bidLineItem.Phoenix_Total_SCM_Approved_Qty__c) ? 0 : parseFloat(relatedList[i].bidLineItem.Phoenix_Total_SCM_Approved_Qty__c)));
                                } else if(relatedList[i].bidRecord.Phoenix_Customer_Type__c == 'BASE/DSH'){
                                    totalSummary1 += ((isNaN(relatedList[i].bidLineItem.Phoenix_IDN_Usage__c) ? 0 : parseFloat(relatedList[i].bidLineItem.Phoenix_IDN_Usage__c)));
                                    totalSummary2 += ((isNaN(relatedList[i].bidLineItem.Phoenix_Days_Notice_Product_Discontinuat__c) ? 0 : parseFloat(relatedList[i].bidLineItem.Phoenix_Days_Notice_Product_Discontinuat__c)));
                                    totalSummary3 += ((isNaN(relatedList[i].bidLineItem.Phoenix_Day_s_Notice_Product_removal__c) ? 0 : parseFloat(relatedList[i].bidLineItem.Phoenix_Day_s_Notice_Product_removal__c)));
                                } else if(relatedList[i].bidRecord.Phoenix_Customer_Type__c == 'ROS'){
                                    totalSummary1 += ((isNaN(relatedList[i].bidLineItem.Phoenix_Current_Anda_Units__c) ? 0 : parseFloat(relatedList[i].bidLineItem.Phoenix_Current_Anda_Units__c)));
                                    totalSummary2 += ((isNaN(relatedList[i].bidLineItem.Phoenix_Current_Indirect_Gaint_EagleUnit__c) ? 0 : parseFloat(relatedList[i].bidLineItem.Phoenix_Current_Indirect_Gaint_EagleUnit__c)));
                                    totalSummary3 += ((isNaN(relatedList[i].bidLineItem.Phoenix_ProposedIndirectAholdDelhaizeUni__c) ? 0 : parseFloat(relatedList[i].bidLineItem.Phoenix_ProposedIndirectAholdDelhaizeUni__c)));
                                    totalSummary4 += ((isNaN(relatedList[i].bidLineItem.Phoenix_Proposed_IndirectGaintEagleUnits__c) ? 0 : parseFloat(relatedList[i].bidLineItem.Phoenix_Proposed_IndirectGaintEagleUnits__c)));
                                } else if(relatedList[i].bidRecord.Phoenix_Customer_Type__c == 'RXSS'){
                                    totalSummary1 += ((isNaN(relatedList[i].bidLineItem.Phoenix_Day_s_Notice_Product_removal__c) ? 0 : parseFloat(relatedList[i].bidLineItem.Phoenix_Day_s_Notice_Product_removal__c)));
                                    totalSummary2 += ((isNaN(relatedList[i].bidLineItem.Phoenix_Current_Indirect_Gaint_EagleUnit__c) ? 0 : parseFloat(relatedList[i].bidLineItem.Phoenix_Current_Indirect_Gaint_EagleUnit__c)));
                                    totalSummary3 += ((isNaN(relatedList[i].bidLineItem.Phoenix_Proposed_IndirectGaintEagleUnits__c) ? 0 : parseFloat(relatedList[i].bidLineItem.Phoenix_Proposed_IndirectGaintEagleUnits__c)));
                                    totalSummary4 += ((isNaN(relatedList[i].bidLineItem.Phoenix_IDN_Usage__c) ? 0 : parseFloat(relatedList[i].bidLineItem.Phoenix_IDN_Usage__c)));
                                    totalSummary5 += ((isNaN(relatedList[i].bidLineItem.Phoenix_Days_Notice_Product_Discontinuat__c) ? 0 : parseFloat(relatedList[i].bidLineItem.Phoenix_Days_Notice_Product_Discontinuat__c)));
                                } else if(relatedList[i].bidRecord.Phoenix_Customer_Type__c == 'OneTimeBuy'){
                                    totalSummary1 += ((isNaN(relatedList[i].bidLineItem.Phoenix_Total_SCM_Approved_Qty__c) ? 0 : parseFloat(relatedList[i].bidLineItem.Phoenix_Total_SCM_Approved_Qty__c)));
                                } else if(relatedList[i].bidRecord.Phoenix_Customer_Type__c == 'ClarusOne'){
                                    totalSummary1 += ((isNaN(relatedList[i].bidLineItem.Phoenix_ProposedIndirectAholdDelhaizeUni__c) ? 0 : parseFloat(relatedList[i].bidLineItem.Phoenix_ProposedIndirectAholdDelhaizeUni__c)));
                                    totalSummary2 += ((isNaN(relatedList[i].bidLineItem.Phoenix_Proposed_IndirectGaintEagleUnits__c) ? 0 : parseFloat(relatedList[i].bidLineItem.Phoenix_Proposed_IndirectGaintEagleUnits__c)));
                                    totalSummary3 += ((isNaN(relatedList[i].bidLineItem.Phoenix_Final_Direct_Selling_Units_Calc__c) ? 0 : parseFloat(relatedList[i].bidLineItem.Phoenix_Final_Direct_Selling_Units_Calc__c)));
                                } else if(relatedList[i].bidRecord.Phoenix_Customer_Type__c == 'Walgreens' || relatedList[i].bidRecord.Phoenix_Customer_Type__c == 'ABC Progen' || relatedList[i].bidRecord.Phoenix_Customer_Type__c == 'ABC Pharmagen' 
                                          || relatedList[i].bidRecord.Phoenix_Customer_Type__c == 'Costco' || relatedList[i].bidRecord.Phoenix_Customer_Type__c == 'Indirect' || relatedList[i].bidRecord.Phoenix_Customer_Type__c == 'Sams Club' 
                                          || relatedList[i].bidRecord.Phoenix_Customer_Type__c == 'Government Pricing'){
                                    totalSummary1 += ((isNaN(relatedList[i].proposedBottles) ? 0 : parseFloat(relatedList[i].proposedBottles)));
                                }
                            }
                            summary[0] = parseInt(previousTotal);
                            summary[1] = parseInt(currentTotal);
                            summary[2] = parseInt(annualImapact);
                            summary[3] = parseInt(businessImpact);
                            summary[4] = parseInt(previousTPT);
                            summary[5] = parseInt(currentTPT);
                            summary[6] = parseInt(currentTPT) - parseInt(previousTPT);
                            summary[7] = parseInt(priceVarianceFamilySummary);
                            summary[8] = parseInt(volumeVarianceFamilySummary);
                            summary[9] = ((!isFinite(previousTPT/previousTotal) ? 0 : (previousTPT/previousTotal)));
                            summary[10] = ((!isFinite(currentTPT/currentTotal) ? 0 : (currentTPT/currentTotal)));
                            summary[11] = parseInt(unit1);
                            summary[12] = parseInt(unit2);
                            summary[13] = parseInt(unit3);
                            summary[14] = parseInt(unit4);
                            summary[15] = parseInt(unit5);
                            summary[16] = parseInt(unit6);
                            summary[17] = parseInt(totalPreviousAwdQtySummary);
                            summary[18] = parseInt(totalAwdQtySummary);
                            summary[19] = parseInt(unit7);
                            summary[20] = parseInt(unit8);
                            summary[21] = totalSummary1;
                            summary[22] = totalSummary2;
                            summary[23] = totalSummary3;
                            summary[24] = totalSummary4;
                            summary[25] = totalSummary5;
                            summary[26] = parseInt(unit10);
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
                            var unit1 = ((isNaN(rec.unit1) ? 0 : rec.unit1));
                            var unit2 = ((isNaN(rec.unit2) ? 0 : rec.unit2));
                            var unit3 = ((isNaN(rec.unit3) ? 0 : rec.unit3));
                            var unit4 = ((isNaN(rec.unit4) ? 0 : rec.unit4));
                            var unit5 = ((isNaN(rec.unit5) ? 0 : rec.unit5));
                            var unit6 = ((isNaN(rec.unit6) ? 0 : rec.unit6));
                            var unit7 = ((isNaN(rec.unit7) ? 0 : rec.unit7));
                            var unit8 = ((isNaN(rec.unit8) ? 0 : rec.unit8));
                            var unit10 = ((isNaN(rec.unit10) ? 0 : rec.unit10));
                            summary[0] = parseInt(previousTotal);
                            summary[1] = parseInt(currentTotal);
                            summary[2] = parseInt(annualImapact);
                            summary[3] = parseInt(businessImpact);
                            summary[4] = parseInt(previousTPT);
                            summary[5] = parseInt(currentTPT);
                            summary[6] = parseInt(currentTPT) - parseInt(previousTPT);
                            summary[7] = parseInt(priceVarianceFamilySummary);
                            summary[8] = parseInt(volumeVarianceFamilySummary);
                            summary[9] = ((!isFinite(previousTPT/previousTotal) ? 0 : (previousTPT/previousTotal)));
                            summary[10] = ((!isFinite(currentTPT/currentTotal) ? 0 : (currentTPT/currentTotal)));
                            summary[11] = parseInt(unit1);
                            summary[12] = parseInt(unit2);
                            summary[13] = parseInt(unit3);
                            summary[14] = parseInt(unit4);
                            summary[15] = parseInt(unit5);
                            summary[16] = parseInt(unit6);
                            summary[17] = parseInt(totalPreviousAwdQtySummary);
                            summary[18] = parseInt(totalAwdQtySummary);
                            summary[19] = parseInt(unit7);
                            summary[20] = parseInt(unit8);
                            summary[26] = parseInt(unit10);
                            if(rec.bidRecord.Phoenix_Customer_Type__c == 'Net Indirect Pricing' || rec.bidRecord.Phoenix_Customer_Type__c == 'Direct and Indirect' || rec.bidRecord.Phoenix_Customer_Type__c == 'Econdisc' ){
                                var scmSummary1 = ((isNaN(rec.bidLineItem.Phoenix_Final_Direct_Selling_Units_Calc__c) ? 0 : parseFloat(rec.bidLineItem.Phoenix_Final_Direct_Selling_Units_Calc__c)));
                                var scmSummary2 = ((isNaN(rec.bidLineItem.Phoenix_Final_Indirect_Selling_Units_Cal__c) ? 0 : parseFloat(rec.bidLineItem.Phoenix_Final_Indirect_Selling_Units_Cal__c)));
                                summary[21] = scmSummary1;
                                summary[22] = scmSummary2;
                            } else if(rec.bidRecord.Phoenix_Customer_Type__c == 'Direct'){
                                var scmSummary1 = ((isNaN(rec.bidLineItem.Phoenix_Total_SCM_Approved_Qty__c) ? 0 : parseFloat(rec.bidLineItem.Phoenix_Total_SCM_Approved_Qty__c)));
                                summary[21] = parseInt(scmSummary1);
                            } else if(rec.bidRecord.Phoenix_Customer_Type__c == 'BASE/DSH'){
                                var scmSummary1 = ((isNaN(rec.bidLineItem.Phoenix_IDN_Usage__c) ? 0 : parseFloat(rec.bidLineItem.Phoenix_IDN_Usage__c)));
                                var scmSummary2 = ((isNaN(rec.bidLineItem.Phoenix_Days_Notice_Product_Discontinuat__c) ? 0 : parseFloat(rec.bidLineItem.Phoenix_Days_Notice_Product_Discontinuat__c)));
                                var scmSummary3 = ((isNaN(rec.bidLineItem.Phoenix_Day_s_Notice_Product_removal__c) ? 0 : parseFloat(rec.bidLineItem.Phoenix_Day_s_Notice_Product_removal__c)));
                                summary[21] = scmSummary1;
                                summary[22] = scmSummary2;
                                summary[23] = scmSummary3;
                            } else if(rec.bidRecord.Phoenix_Customer_Type__c == 'ROS'){
                                var scmSummary1 = ((isNaN(rec.bidLineItem.Phoenix_Current_Anda_Units__c) ? 0 : parseFloat(rec.bidLineItem.Phoenix_Current_Anda_Units__c)));
                                var scmSummary2 = ((isNaN(rec.bidLineItem.Phoenix_Current_Indirect_Gaint_EagleUnit__c) ? 0 : parseFloat(rec.bidLineItem.Phoenix_Current_Indirect_Gaint_EagleUnit__c)));
                                var scmSummary3 = ((isNaN(rec.bidLineItem.Phoenix_ProposedIndirectAholdDelhaizeUni__c) ? 0 : parseFloat(rec.bidLineItem.Phoenix_ProposedIndirectAholdDelhaizeUni__c)));
                                var scmSummary4 = ((isNaN(rec.bidLineItem.Phoenix_Proposed_IndirectGaintEagleUnits__c) ? 0 : parseFloat(rec.bidLineItem.Phoenix_Proposed_IndirectGaintEagleUnits__c)));
                                summary[21] = scmSummary1;
                                summary[22] = scmSummary2;
                                summary[23] = scmSummary3;
                                summary[24] = scmSummary4;
                            } else if(rec.bidRecord.Phoenix_Customer_Type__c == 'RXSS'){
                                var scmSummary1 = ((isNaN(rec.bidLineItem.Phoenix_Day_s_Notice_Product_removal__c) ? 0 : parseFloat(rec.bidLineItem.Phoenix_Day_s_Notice_Product_removal__c)));
                                var scmSummary2 = ((isNaN(rec.bidLineItem.Phoenix_Current_Indirect_Gaint_EagleUnit__c) ? 0 : parseFloat(rec.bidLineItem.Phoenix_Current_Indirect_Gaint_EagleUnit__c)));
                                var scmSummary3 = ((isNaN(rec.bidLineItem.Phoenix_Proposed_IndirectGaintEagleUnits__c) ? 0 : parseFloat(rec.bidLineItem.Phoenix_Proposed_IndirectGaintEagleUnits__c)));
                                var scmSummary4 = ((isNaN(rec.bidLineItem.Phoenix_IDN_Usage__c) ? 0 : parseFloat(rec.bidLineItem.Phoenix_IDN_Usage__c)));
                                var scmSummary5 = ((isNaN(rec.bidLineItem.Phoenix_Days_Notice_Product_Discontinuat__c) ? 0 : parseFloat(rec.bidLineItem.Phoenix_Days_Notice_Product_Discontinuat__c)));
                                summary[21] = scmSummary1;
                                summary[22] = scmSummary2;
                                summary[23] = scmSummary3;
                                summary[24] = scmSummary4;
                                summary[25] = scmSummary5;
                            } else if(rec.bidRecord.Phoenix_Customer_Type__c == 'ClarusOne'){
                                var scmSummary1 = ((isNaN(rec.bidLineItem.Phoenix_ProposedIndirectAholdDelhaizeUni__c) ? 0 : parseFloat(rec.bidLineItem.Phoenix_ProposedIndirectAholdDelhaizeUni__c)));
                                var scmSummary2 = ((isNaN(rec.bidLineItem.Phoenix_Proposed_IndirectGaintEagleUnits__c) ? 0 : parseFloat(rec.bidLineItem.Phoenix_Proposed_IndirectGaintEagleUnits__c)));
                                var scmSummary3 = ((isNaN(rec.bidLineItem.Phoenix_Final_Direct_Selling_Units_Calc__c) ? 0 : parseFloat(rec.bidLineItem.Phoenix_Final_Direct_Selling_Units_Calc__c)));
                                summary[21] = scmSummary1;
                                summary[22] = scmSummary2;
                                summary[23] = scmSummary3;
                            } else if(rec.bidRecord.Phoenix_Customer_Type__c == 'OneTimeBuy'){
                                var scmSummary1 = ((isNaN(rec.bidLineItem.Phoenix_Total_SCM_Approved_Qty__c) ? 0 : parseFloat(rec.bidLineItem.Phoenix_Total_SCM_Approved_Qty__c)));
                                summary[21] = scmSummary1;
                            } else if(rec.bidRecord.Phoenix_Customer_Type__c == 'Walgreens' || rec.bidRecord.Phoenix_Customer_Type__c == 'ABC Progen' || rec.bidRecord.Phoenix_Customer_Type__c == 'ABC Pharmagen' 
                                      || rec.bidRecord.Phoenix_Customer_Type__c == 'Costco' || rec.bidRecord.Phoenix_Customer_Type__c == 'Indirect' || rec.bidRecord.Phoenix_Customer_Type__c == 'Sams Club' 
                                      || rec.bidRecord.Phoenix_Customer_Type__c == 'Government Pricing'){
                                var scmSummary1 = ((isNaN(rec.proposedBottles) ? 0 : parseFloat(rec.proposedBottles)));
                                summary[21] = scmSummary1;
                            }
                            retainedGainFamilySummaryMap[rec.productFamily] = summary;
                        }
                    });
                    
                    keys = Object.keys(retainedGainFamilySummaryMap);
                    keys.sort(function(a, b) { return retainedGainFamilySummaryMap[b][2] - retainedGainFamilySummaryMap[a][2] });
                    var retainedGainSummary = [];
                    retainedGainSummary[11] = 0;
                    retainedGainSummary[12] = 0;
                    retainedGainSummary[13] = 0;
                    retainedGainSummary[14] = 0;
                    retainedGainSummary[15] = 0;
                    retainedGainSummary[16] = 0;
                    retainedGainSummary[17] = 0;
                    retainedGainSummary[18] = 0;
                    retainedGainSummary[19] = 0;
                    retainedGainSummary[20] = 0;
                    retainedGainSummary[21] = 0;
                    retainedGainSummary[22] = 0;
                    retainedGainSummary[23] = 0;
                    retainedGainSummary[24] = 0;
                    retainedGainSummary[25] = 0;
                    retainedGainSummary[26] = 0;
                    for(var i=0; i<keys.length; i++){
                        tempObj[keys[i]] = retainedGainFamilySummaryMap[keys[i]];
                        var tem = retainedGainFamilySummaryMap[keys[i]];
                        retainedGainSummary[11] += parseFloat(tem[11]);
                        retainedGainSummary[12] += parseFloat(tem[12]);
                        retainedGainSummary[13] += parseFloat(tem[13]);
                        retainedGainSummary[14] += parseFloat(tem[14]);
                        retainedGainSummary[15] += parseFloat(tem[15]);
                        retainedGainSummary[16] += parseFloat(tem[16]);
                        retainedGainSummary[17] += parseFloat(tem[17]);
                        retainedGainSummary[18] += parseFloat(tem[18]);
                        retainedGainSummary[19] += parseFloat(tem[19]);
                        retainedGainSummary[20] += parseFloat(tem[20]);
                        retainedGainSummary[21] += parseFloat(tem[21]);
                        retainedGainSummary[22] += parseFloat(tem[22]);
                        retainedGainSummary[23] += parseFloat(tem[23]);
                        retainedGainSummary[24] += parseFloat(tem[24]);
                        retainedGainSummary[25] += parseFloat(tem[25]);
                        retainedGainSummary[26] += parseFloat(tem[26]);
                    }
                    component.set("v.retainedGainSummary", retainedGainSummary);
                    retainedGainFamilySummaryMap = tempObj;
                    tempObj = {};
                    
                    sortedKeys = Object.keys(retainedGainFamilySummaryMap);
                    for(var i=0; i<sortedKeys.length; i++){
                        tempObj[sortedKeys[i]] = retainedGainMap[sortedKeys[i]];
                    }
                    retainedGainMap = tempObj;
                    
                    tempObj = {};
                    component.set("v.retainedGainFamilySummaryMap",retainedGainFamilySummaryMap);
                    component.set("v.retainedGainMap",Object.entries(retainedGainMap));
                    component.set("v.retainedGainList", retainedGainList);
                    
                    
                    var retainedLossMap = {};
                    var retainedLossFamilySummaryMap = {}; var totalPreviousQtyBGL = 0; var totalAwardedQtyBGL = 0;
                    retainedLossList.forEach(function(rec){
                        if(retainedLossMap.hasOwnProperty(rec.productFamily)){
                            var relatedList = retainedLossMap[rec.productFamily]; var summary = [];
                            relatedList.push(rec);
                            retainedLossMap[rec.productFamily] = relatedList;
                            var previousTotal = 0; var currentTotal = 0; var annualImapact = 0; var businessImpact = 0; var previousTPT = 0; var currentTPT = 0;
                            var previousTPTFamilySummary = 0; var currentTPTFamilySummary = 0; var priceVarianceFamilySummary = 0; var volumeVarianceFamilySummary = 0;
                            var totalVarianceFamilySummary = 0; var tptVarianceFamilySummary = 0; var unit1 = 0; var unit2 = 0; var unit3 = 0; var unit4 = 0; var unit5=0;var totalPreviousAwdQtySummary = 0; var totalAwdQtySummary = 0;
                            var unit6 = 0; var unit7=0; var unit8 = 0;var unit10 = 0;
                            var totalSummary1 = 0; var totalSummary2 = 0; var totalSummary3 = 0; var totalSummary4 = 0; var totalSummary5 = 0;
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
                                unit1 += ((isNaN(relatedList[i].unit1) ? 0 : relatedList[i].unit1));
                                unit2 += ((isNaN(relatedList[i].unit2) ? 0 : relatedList[i].unit2));
                                unit3 += ((isNaN(relatedList[i].unit3) ? 0 : relatedList[i].unit3));
                                unit4 += ((isNaN(relatedList[i].unit4) ? 0 : relatedList[i].unit4));
                                unit5 += ((isNaN(relatedList[i].unit5) ? 0 : relatedList[i].unit5));
                                unit6 += ((isNaN(relatedList[i].unit6) ? 0 : relatedList[i].unit6));
                                unit7 += ((isNaN(relatedList[i].unit7) ? 0 : relatedList[i].unit7));
                                unit8 += ((isNaN(relatedList[i].unit8) ? 0 : relatedList[i].unit8));
                                unit10 += ((isNaN(relatedList[i].unit10) ? 0 : relatedList[i].unit10));
                                if(relatedList[i].bidRecord.Phoenix_Customer_Type__c == 'Net Indirect Pricing' || relatedList[i].bidRecord.Phoenix_Customer_Type__c == 'Direct and Indirect' || relatedList[i].bidRecord.Phoenix_Customer_Type__c == 'Econdisc'){
                                    totalSummary1 += ((isNaN(relatedList[i].bidLineItem.Phoenix_Final_Direct_Selling_Units_Calc__c) ? 0 : parseFloat(relatedList[i].bidLineItem.Phoenix_Final_Direct_Selling_Units_Calc__c)));
                                    totalSummary2 += ((isNaN(relatedList[i].bidLineItem.Phoenix_Final_Indirect_Selling_Units_Cal__c) ? 0 : parseFloat(relatedList[i].bidLineItem.Phoenix_Final_Indirect_Selling_Units_Cal__c)));
                                } else if(relatedList[i].bidRecord.Phoenix_Customer_Type__c == 'Direct'){
                                    totalSummary1 += ((isNaN(relatedList[i].bidLineItem.Phoenix_Total_SCM_Approved_Qty__c) ? 0 : parseFloat(relatedList[i].bidLineItem.Phoenix_Total_SCM_Approved_Qty__c)));
                                } else if(relatedList[i].bidRecord.Phoenix_Customer_Type__c == 'BASE/DSH'){
                                    totalSummary1 += ((isNaN(relatedList[i].bidLineItem.Phoenix_IDN_Usage__c) ? 0 : parseFloat(relatedList[i].bidLineItem.Phoenix_IDN_Usage__c)));
                                    totalSummary2 += ((isNaN(relatedList[i].bidLineItem.Phoenix_Days_Notice_Product_Discontinuat__c) ? 0 : parseFloat(relatedList[i].bidLineItem.Phoenix_Days_Notice_Product_Discontinuat__c)));
                                    totalSummary3 += ((isNaN(relatedList[i].bidLineItem.Phoenix_Day_s_Notice_Product_removal__c) ? 0 : parseFloat(relatedList[i].bidLineItem.Phoenix_Day_s_Notice_Product_removal__c)));
                                } else if(relatedList[i].bidRecord.Phoenix_Customer_Type__c == 'ROS'){
                                    totalSummary1 += ((isNaN(relatedList[i].bidLineItem.Phoenix_Current_Anda_Units__c) ? 0 : parseFloat(relatedList[i].bidLineItem.Phoenix_Current_Anda_Units__c)));
                                    totalSummary2 += ((isNaN(relatedList[i].bidLineItem.Phoenix_Current_Indirect_Gaint_EagleUnit__c) ? 0 : parseFloat(relatedList[i].bidLineItem.Phoenix_Current_Indirect_Gaint_EagleUnit__c)));
                                    totalSummary3 += ((isNaN(relatedList[i].bidLineItem.Phoenix_ProposedIndirectAholdDelhaizeUni__c) ? 0 : parseFloat(relatedList[i].bidLineItem.Phoenix_ProposedIndirectAholdDelhaizeUni__c)));
                                    totalSummary4 += ((isNaN(relatedList[i].bidLineItem.Phoenix_Proposed_IndirectGaintEagleUnits__c) ? 0 : parseFloat(relatedList[i].bidLineItem.Phoenix_Proposed_IndirectGaintEagleUnits__c)));
                                } else if(relatedList[i].bidRecord.Phoenix_Customer_Type__c == 'RXSS'){
                                    totalSummary1 += ((isNaN(relatedList[i].bidLineItem.Phoenix_Day_s_Notice_Product_removal__c) ? 0 : parseFloat(relatedList[i].bidLineItem.Phoenix_Day_s_Notice_Product_removal__c)));
                                    totalSummary2 += ((isNaN(relatedList[i].bidLineItem.Phoenix_Current_Indirect_Gaint_EagleUnit__c) ? 0 : parseFloat(relatedList[i].bidLineItem.Phoenix_Current_Indirect_Gaint_EagleUnit__c)));
                                    totalSummary3 += ((isNaN(relatedList[i].bidLineItem.Phoenix_Proposed_IndirectGaintEagleUnits__c) ? 0 : parseFloat(relatedList[i].bidLineItem.Phoenix_Proposed_IndirectGaintEagleUnits__c)));
                                    totalSummary4 += ((isNaN(relatedList[i].bidLineItem.Phoenix_IDN_Usage__c) ? 0 : parseFloat(relatedList[i].bidLineItem.Phoenix_IDN_Usage__c)));
                                    totalSummary5 += ((isNaN(relatedList[i].bidLineItem.Phoenix_Days_Notice_Product_Discontinuat__c) ? 0 : parseFloat(relatedList[i].bidLineItem.Phoenix_Days_Notice_Product_Discontinuat__c)));
                                } else if(relatedList[i].bidRecord.Phoenix_Customer_Type__c == 'OneTimeBuy'){
                                    totalSummary1 += ((isNaN(relatedList[i].bidLineItem.Phoenix_Total_SCM_Approved_Qty__c) ? 0 : parseFloat(relatedList[i].bidLineItem.Phoenix_Total_SCM_Approved_Qty__c)));
                                } else if(relatedList[i].bidRecord.Phoenix_Customer_Type__c == 'ClarusOne'){
                                    totalSummary1 += ((isNaN(relatedList[i].bidLineItem.Phoenix_ProposedIndirectAholdDelhaizeUni__c) ? 0 : parseFloat(relatedList[i].bidLineItem.Phoenix_ProposedIndirectAholdDelhaizeUni__c)));
                                    totalSummary2 += ((isNaN(relatedList[i].bidLineItem.Phoenix_Proposed_IndirectGaintEagleUnits__c) ? 0 : parseFloat(relatedList[i].bidLineItem.Phoenix_Proposed_IndirectGaintEagleUnits__c)));
                                    totalSummary3 += ((isNaN(relatedList[i].bidLineItem.Phoenix_Final_Direct_Selling_Units_Calc__c) ? 0 : parseFloat(relatedList[i].bidLineItem.Phoenix_Final_Direct_Selling_Units_Calc__c)));
                                } else if(relatedList[i].bidRecord.Phoenix_Customer_Type__c == 'Walgreens' || relatedList[i].bidRecord.Phoenix_Customer_Type__c == 'ABC Progen' || relatedList[i].bidRecord.Phoenix_Customer_Type__c == 'ABC Pharmagen' 
                                          || relatedList[i].bidRecord.Phoenix_Customer_Type__c == 'Costco' || relatedList[i].bidRecord.Phoenix_Customer_Type__c == 'Indirect' || relatedList[i].bidRecord.Phoenix_Customer_Type__c == 'Sams Club' 
                                          || relatedList[i].bidRecord.Phoenix_Customer_Type__c == 'Government Pricing'){
                                    totalSummary1 += ((isNaN(relatedList[i].proposedBottles) ? 0 : parseFloat(relatedList[i].proposedBottles)));
                                }
                            }
                            summary[0] = parseInt(previousTotal);
                            summary[1] = parseInt(currentTotal);
                            summary[2] = parseInt(annualImapact);
                            summary[3] = parseInt(businessImpact);
                            summary[4] = parseInt(previousTPT);
                            summary[5] = parseInt(currentTPT);
                            summary[6] = parseInt(currentTPT) - parseInt(previousTPT);
                            summary[7] = parseInt(priceVarianceFamilySummary);
                            summary[8] = parseInt(volumeVarianceFamilySummary);
                            summary[9] = ((!isFinite(previousTPT/previousTotal) ? 0 : (previousTPT/previousTotal)));
                            summary[10] = ((!isFinite(currentTPT/currentTotal) ? 0 : (currentTPT/currentTotal)));
                            summary[11] = parseInt(unit1);
                            summary[12] = parseInt(unit2);
                            summary[13] = parseInt(unit3);
                            summary[14] = parseInt(unit4);
                            summary[15] = parseInt(unit5);
                            summary[16] = parseInt(unit6);
                            summary[17] = parseInt(totalPreviousAwdQtySummary);
                            summary[18] = parseInt(totalAwdQtySummary);
                            summary[19] = parseInt(unit7);
                            summary[20] = parseInt(unit8);
                            summary[21] = totalSummary1;
                            summary[22] = totalSummary2;
                            summary[23] = totalSummary3;
                            summary[24] = totalSummary4;
                            summary[25] = totalSummary5;
                            summary[26] = parseInt(unit10);
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
                            var unit1 = ((isNaN(rec.unit1) ? 0 : rec.unit1));
                            var unit2 = ((isNaN(rec.unit2) ? 0 : rec.unit2));
                            var unit3 = ((isNaN(rec.unit3) ? 0 : rec.unit3));
                            var unit4 = ((isNaN(rec.unit4) ? 0 : rec.unit4));
                            var unit5 = ((isNaN(rec.unit5) ? 0 : rec.unit5));
                            var unit6 = ((isNaN(rec.unit6) ? 0 : rec.unit6));
                            var unit7 = ((isNaN(rec.unit7) ? 0 : rec.unit7));
                            var unit8 = ((isNaN(rec.unit8) ? 0 : rec.unit8));
                            var unit10 = ((isNaN(rec.unit10) ? 0 : rec.unit10));
                            summary[0] = parseInt(previousTotal);
                            summary[1] = parseInt(currentTotal);
                            summary[2] = parseInt(annualImapact);
                            summary[3] = parseInt(businessImpact);
                            summary[4] = parseInt(previousTPT);
                            summary[5] = parseInt(currentTPT);
                            summary[6] = parseInt(currentTPT) - parseInt(previousTPT);
                            summary[7] = parseInt(priceVarianceFamilySummary);
                            summary[8] = parseInt(volumeVarianceFamilySummary);
                            summary[9] = ((!isFinite(previousTPT/previousTotal) ? 0 : (previousTPT/previousTotal)));
                            summary[10] = ((!isFinite(currentTPT/currentTotal) ? 0 : (currentTPT/currentTotal)));
                            summary[11] = parseInt(unit1);
                            summary[12] = parseInt(unit2);
                            summary[13] = parseInt(unit3);
                            summary[14] = parseInt(unit4);
                            summary[15] = parseInt(unit5);
                            summary[16] = parseInt(unit6);
                            summary[17] = parseInt(totalPreviousAwdQtySummary);
                            summary[18] = parseInt(totalAwdQtySummary);
                            summary[19] = parseInt(unit7);
                            summary[20] = parseInt(unit8);
                            summary[26] = parseInt(unit10);
                            if(rec.bidRecord.Phoenix_Customer_Type__c == 'Net Indirect Pricing' || rec.bidRecord.Phoenix_Customer_Type__c == 'Direct and Indirect' || rec.bidRecord.Phoenix_Customer_Type__c == 'Econdisc' ){
                                var scmSummary1 = ((isNaN(rec.bidLineItem.Phoenix_Final_Direct_Selling_Units_Calc__c) ? 0 : parseFloat(rec.bidLineItem.Phoenix_Final_Direct_Selling_Units_Calc__c)));
                                var scmSummary2 = ((isNaN(rec.bidLineItem.Phoenix_Final_Indirect_Selling_Units_Cal__c) ? 0 : parseFloat(rec.bidLineItem.Phoenix_Final_Indirect_Selling_Units_Cal__c)));
                                summary[21] = scmSummary1;
                                summary[22] = scmSummary2;
                            } else if(rec.bidRecord.Phoenix_Customer_Type__c == 'Direct'){
                                var scmSummary1 = ((isNaN(rec.bidLineItem.Phoenix_Total_SCM_Approved_Qty__c) ? 0 : parseFloat(rec.bidLineItem.Phoenix_Total_SCM_Approved_Qty__c)));
                                summary[21] = parseInt(scmSummary1);
                            } else if(rec.bidRecord.Phoenix_Customer_Type__c == 'BASE/DSH'){
                                var scmSummary1 = ((isNaN(rec.bidLineItem.Phoenix_IDN_Usage__c) ? 0 : parseFloat(rec.bidLineItem.Phoenix_IDN_Usage__c)));
                                var scmSummary2 = ((isNaN(rec.bidLineItem.Phoenix_Days_Notice_Product_Discontinuat__c) ? 0 : parseFloat(rec.bidLineItem.Phoenix_Days_Notice_Product_Discontinuat__c)));
                                var scmSummary3 = ((isNaN(rec.bidLineItem.Phoenix_Day_s_Notice_Product_removal__c) ? 0 : parseFloat(rec.bidLineItem.Phoenix_Day_s_Notice_Product_removal__c)));
                                summary[21] = scmSummary1;
                                summary[22] = scmSummary2;
                                summary[23] = scmSummary3;
                            } else if(rec.bidRecord.Phoenix_Customer_Type__c == 'ROS'){
                                var scmSummary1 = ((isNaN(rec.bidLineItem.Phoenix_Current_Anda_Units__c) ? 0 : parseFloat(rec.bidLineItem.Phoenix_Current_Anda_Units__c)));
                                var scmSummary2 = ((isNaN(rec.bidLineItem.Phoenix_Current_Indirect_Gaint_EagleUnit__c) ? 0 : parseFloat(rec.bidLineItem.Phoenix_Current_Indirect_Gaint_EagleUnit__c)));
                                var scmSummary3 = ((isNaN(rec.bidLineItem.Phoenix_ProposedIndirectAholdDelhaizeUni__c) ? 0 : parseFloat(rec.bidLineItem.Phoenix_ProposedIndirectAholdDelhaizeUni__c)));
                                var scmSummary4 = ((isNaN(rec.bidLineItem.Phoenix_Proposed_IndirectGaintEagleUnits__c) ? 0 : parseFloat(rec.bidLineItem.Phoenix_Proposed_IndirectGaintEagleUnits__c)));
                                summary[21] = scmSummary1;
                                summary[22] = scmSummary2;
                                summary[23] = scmSummary3;
                                summary[24] = scmSummary4;
                            } else if(rec.bidRecord.Phoenix_Customer_Type__c == 'RXSS'){
                                var scmSummary1 = ((isNaN(rec.bidLineItem.Phoenix_Day_s_Notice_Product_removal__c) ? 0 : parseFloat(rec.bidLineItem.Phoenix_Day_s_Notice_Product_removal__c)));
                                var scmSummary2 = ((isNaN(rec.bidLineItem.Phoenix_Current_Indirect_Gaint_EagleUnit__c) ? 0 : parseFloat(rec.bidLineItem.Phoenix_Current_Indirect_Gaint_EagleUnit__c)));
                                var scmSummary3 = ((isNaN(rec.bidLineItem.Phoenix_Proposed_IndirectGaintEagleUnits__c) ? 0 : parseFloat(rec.bidLineItem.Phoenix_Proposed_IndirectGaintEagleUnits__c)));
                                var scmSummary4 = ((isNaN(rec.bidLineItem.Phoenix_IDN_Usage__c) ? 0 : parseFloat(rec.bidLineItem.Phoenix_IDN_Usage__c)));
                                var scmSummary5 = ((isNaN(rec.bidLineItem.Phoenix_Days_Notice_Product_Discontinuat__c) ? 0 : parseFloat(rec.bidLineItem.Phoenix_Days_Notice_Product_Discontinuat__c)));
                                summary[21] = scmSummary1;
                                summary[22] = scmSummary2;
                                summary[23] = scmSummary3;
                                summary[24] = scmSummary4;
                                summary[25] = scmSummary5;
                            } else if(rec.bidRecord.Phoenix_Customer_Type__c == 'ClarusOne'){
                                var scmSummary1 = ((isNaN(rec.bidLineItem.Phoenix_ProposedIndirectAholdDelhaizeUni__c) ? 0 : parseFloat(rec.bidLineItem.Phoenix_ProposedIndirectAholdDelhaizeUni__c)));
                                var scmSummary2 = ((isNaN(rec.bidLineItem.Phoenix_Proposed_IndirectGaintEagleUnits__c) ? 0 : parseFloat(rec.bidLineItem.Phoenix_Proposed_IndirectGaintEagleUnits__c)));
                                var scmSummary3 = ((isNaN(rec.bidLineItem.Phoenix_Final_Direct_Selling_Units_Calc__c) ? 0 : parseFloat(rec.bidLineItem.Phoenix_Final_Direct_Selling_Units_Calc__c)));
                                summary[21] = scmSummary1;
                                summary[22] = scmSummary2;
                                summary[23] = scmSummary3;
                            } else if(rec.bidRecord.Phoenix_Customer_Type__c == 'OneTimeBuy'){
                                var scmSummary1 = ((isNaN(rec.bidLineItem.Phoenix_Total_SCM_Approved_Qty__c) ? 0 : parseFloat(rec.bidLineItem.Phoenix_Total_SCM_Approved_Qty__c)));
                                summary[21] = scmSummary1;
                            } else if(rec.bidRecord.Phoenix_Customer_Type__c == 'Walgreens' || rec.bidRecord.Phoenix_Customer_Type__c == 'ABC Progen' || rec.bidRecord.Phoenix_Customer_Type__c == 'ABC Pharmagen' 
                                      || rec.bidRecord.Phoenix_Customer_Type__c == 'Costco' || rec.bidRecord.Phoenix_Customer_Type__c == 'Indirect' || rec.bidRecord.Phoenix_Customer_Type__c == 'Sams Club' 
                                      || rec.bidRecord.Phoenix_Customer_Type__c == 'Government Pricing'){
                                var scmSummary1 = ((isNaN(rec.proposedBottles) ? 0 : parseFloat(rec.proposedBottles)));
                                summary[21] = scmSummary1;
                            }
                            retainedLossFamilySummaryMap[rec.productFamily] = summary;
                        }
                    });
                    
                    keys = Object.keys(retainedLossFamilySummaryMap);
                    keys.sort(function(a, b) { return retainedLossFamilySummaryMap[b][2] - retainedLossFamilySummaryMap[a][2] });
                    var retainedLossSummary = [];
                    retainedLossSummary[11] = 0;
                    retainedLossSummary[12] = 0;
                    retainedLossSummary[13] = 0;
                    retainedLossSummary[14] = 0;
                    retainedLossSummary[15] = 0;
                    retainedLossSummary[16] = 0;
                    retainedLossSummary[17] = 0;
                    retainedLossSummary[18] = 0;
                    retainedLossSummary[19] = 0;
                    retainedLossSummary[20] = 0;
                    retainedLossSummary[21] = 0;
                    retainedLossSummary[22] = 0;
                    retainedLossSummary[23] = 0;
                    retainedLossSummary[24] = 0;
                    retainedLossSummary[25] = 0;
                    retainedLossSummary[26] = 0;
                    for(var i=0; i<keys.length; i++){
                        tempObj[keys[i]] = retainedLossFamilySummaryMap[keys[i]];
                        var tem = retainedLossFamilySummaryMap[keys[i]];
                        retainedLossSummary[11] += parseFloat(tem[11]);
                        retainedLossSummary[12] += parseFloat(tem[12]);
                        retainedLossSummary[13] += parseFloat(tem[13]);
                        retainedLossSummary[14] += parseFloat(tem[14]);
                        retainedLossSummary[15] += parseFloat(tem[15]);
                        retainedLossSummary[16] += parseFloat(tem[16]);
                        retainedLossSummary[17] += parseFloat(tem[17]);
                        retainedLossSummary[18] += parseFloat(tem[18]);
                        retainedLossSummary[19] += parseFloat(tem[19]);
                        retainedLossSummary[20] += parseFloat(tem[20]);
                        retainedLossSummary[21] += parseFloat(tem[21]);
                        retainedLossSummary[22] += parseFloat(tem[22]);
                        retainedLossSummary[23] += parseFloat(tem[23]);
                        retainedLossSummary[24] += parseFloat(tem[24]);
                        retainedLossSummary[25] += parseFloat(tem[25]);
                        retainedLossSummary[26] += parseFloat(tem[26]);
                    }
                    component.set("v.retainedLossSummary", retainedLossSummary);
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
                    
                    var totalPreviousQty = 0; var totalAwardedQty = 0; var totalPreviousTotal = 0; var totalCurrentTotal = 0;
                    var totalAnnualImpact = 0; var totalBusinessImpact = 0; var totalCurrentTPT = 0; var totalPreviousTPT = 0;
                    var totalCurrentTPTPer = 0; var totalPreviousTPTPer = 0;
                    var totalPriceVariance = 0; var totalVolumeVariance = 0; var total = 0; var totalTPT = 0;                    
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
                        if(openStatusMap.hasOwnProperty(rec.productFamily)){
                            var relatedList = openStatusMap[rec.productFamily]; var summary = [];
                            relatedList.push(rec);
                            openStatusMap[rec.productFamily] = relatedList;
                            var previousTotal = 0; var currentTotal = 0; var annualImapact = 0; var businessImpact = 0; var previousTPT = 0; var currentTPT = 0;
                            var previousTPTFamilySummary = 0; var currentTPTFamilySummary = 0; var priceVarianceFamilySummary = 0; var volumeVarianceFamilySummary = 0;
                            var totalVarianceFamilySummary = 0; var tptVarianceFamilySummary = 0; var unit1 = 0; var unit2 = 0; var unit3 = 0; var unit4 = 0; var unit5=0;var totalPreviousAwdQtySummary = 0; var totalAwdQtySummary = 0;
                            var unit6 = 0; var unit7=0; var unit8 = 0; var unit10 = 0;
                            var totalSummary1 = 0; var totalSummary2 = 0; var totalSummary3 = 0; var totalSummary4 = 0; var totalSummary5 = 0;
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
                                unit1 += ((isNaN(relatedList[i].unit1) ? 0 : relatedList[i].unit1));
                                unit2 += ((isNaN(relatedList[i].unit2) ? 0 : relatedList[i].unit2));
                                unit3 += ((isNaN(relatedList[i].unit3) ? 0 : relatedList[i].unit3));
                                unit4 += ((isNaN(relatedList[i].unit4) ? 0 : relatedList[i].unit4));
                                unit5 += ((isNaN(relatedList[i].unit5) ? 0 : relatedList[i].unit5));
                                unit6 += ((isNaN(relatedList[i].unit6) ? 0 : relatedList[i].unit6));
                                unit7 += ((isNaN(relatedList[i].unit7) ? 0 : relatedList[i].unit7));
                                unit8 += ((isNaN(relatedList[i].unit8) ? 0 : relatedList[i].unit8));
                                unit10 += ((isNaN(relatedList[i].unit10) ? 0 : relatedList[i].unit10));
                                if(relatedList[i].bidRecord.Phoenix_Customer_Type__c == 'Net Indirect Pricing' || relatedList[i].bidRecord.Phoenix_Customer_Type__c == 'Direct and Indirect' || relatedList[i].bidRecord.Phoenix_Customer_Type__c == 'Econdisc'){
                                    totalSummary1 += ((isNaN(relatedList[i].bidLineItem.Phoenix_Final_Direct_Selling_Units_Calc__c) ? 0 : parseFloat(relatedList[i].bidLineItem.Phoenix_Final_Direct_Selling_Units_Calc__c)));
                                    totalSummary2 += ((isNaN(relatedList[i].bidLineItem.Phoenix_Final_Indirect_Selling_Units_Cal__c) ? 0 : parseFloat(relatedList[i].bidLineItem.Phoenix_Final_Indirect_Selling_Units_Cal__c)));
                                } else if(relatedList[i].bidRecord.Phoenix_Customer_Type__c == 'Direct'){
                                    totalSummary1 += ((isNaN(relatedList[i].bidLineItem.Phoenix_Total_SCM_Approved_Qty__c) ? 0 : parseFloat(relatedList[i].bidLineItem.Phoenix_Total_SCM_Approved_Qty__c)));
                                } else if(relatedList[i].bidRecord.Phoenix_Customer_Type__c == 'BASE/DSH'){
                                    totalSummary1 += ((isNaN(relatedList[i].bidLineItem.Phoenix_IDN_Usage__c) ? 0 : parseFloat(relatedList[i].bidLineItem.Phoenix_IDN_Usage__c)));
                                    totalSummary2 += ((isNaN(relatedList[i].bidLineItem.Phoenix_Days_Notice_Product_Discontinuat__c) ? 0 : parseFloat(relatedList[i].bidLineItem.Phoenix_Days_Notice_Product_Discontinuat__c)));
                                    totalSummary3 += ((isNaN(relatedList[i].bidLineItem.Phoenix_Day_s_Notice_Product_removal__c) ? 0 : parseFloat(relatedList[i].bidLineItem.Phoenix_Day_s_Notice_Product_removal__c)));
                                } else if(relatedList[i].bidRecord.Phoenix_Customer_Type__c == 'ROS'){
                                    totalSummary1 += ((isNaN(relatedList[i].bidLineItem.Phoenix_Current_Anda_Units__c) ? 0 : parseFloat(relatedList[i].bidLineItem.Phoenix_Current_Anda_Units__c)));
                                    totalSummary2 += ((isNaN(relatedList[i].bidLineItem.Phoenix_Current_Indirect_Gaint_EagleUnit__c) ? 0 : parseFloat(relatedList[i].bidLineItem.Phoenix_Current_Indirect_Gaint_EagleUnit__c)));
                                    totalSummary3 += ((isNaN(relatedList[i].bidLineItem.Phoenix_ProposedIndirectAholdDelhaizeUni__c) ? 0 : parseFloat(relatedList[i].bidLineItem.Phoenix_ProposedIndirectAholdDelhaizeUni__c)));
                                    totalSummary4 += ((isNaN(relatedList[i].bidLineItem.Phoenix_Proposed_IndirectGaintEagleUnits__c) ? 0 : parseFloat(relatedList[i].bidLineItem.Phoenix_Proposed_IndirectGaintEagleUnits__c)));
                                } else if(relatedList[i].bidRecord.Phoenix_Customer_Type__c == 'RXSS'){
                                    totalSummary1 += ((isNaN(relatedList[i].bidLineItem.Phoenix_Day_s_Notice_Product_removal__c) ? 0 : parseFloat(relatedList[i].bidLineItem.Phoenix_Day_s_Notice_Product_removal__c)));
                                    totalSummary2 += ((isNaN(relatedList[i].bidLineItem.Phoenix_Current_Indirect_Gaint_EagleUnit__c) ? 0 : parseFloat(relatedList[i].bidLineItem.Phoenix_Current_Indirect_Gaint_EagleUnit__c)));
                                    totalSummary3 += ((isNaN(relatedList[i].bidLineItem.Phoenix_Proposed_IndirectGaintEagleUnits__c) ? 0 : parseFloat(relatedList[i].bidLineItem.Phoenix_Proposed_IndirectGaintEagleUnits__c)));
                                    totalSummary4 += ((isNaN(relatedList[i].bidLineItem.Phoenix_IDN_Usage__c) ? 0 : parseFloat(relatedList[i].bidLineItem.Phoenix_IDN_Usage__c)));
                                    totalSummary5 += ((isNaN(relatedList[i].bidLineItem.Phoenix_Days_Notice_Product_Discontinuat__c) ? 0 : parseFloat(relatedList[i].bidLineItem.Phoenix_Days_Notice_Product_Discontinuat__c)));
                                } else if(relatedList[i].bidRecord.Phoenix_Customer_Type__c == 'OneTimeBuy'){
                                    totalSummary1 += ((isNaN(relatedList[i].bidLineItem.Phoenix_Total_SCM_Approved_Qty__c) ? 0 : parseFloat(relatedList[i].bidLineItem.Phoenix_Total_SCM_Approved_Qty__c)));
                                } else if(relatedList[i].bidRecord.Phoenix_Customer_Type__c == 'ClarusOne'){
                                    totalSummary1 += ((isNaN(relatedList[i].bidLineItem.Phoenix_ProposedIndirectAholdDelhaizeUni__c) ? 0 : parseFloat(relatedList[i].bidLineItem.Phoenix_ProposedIndirectAholdDelhaizeUni__c)));
                                    totalSummary2 += ((isNaN(relatedList[i].bidLineItem.Phoenix_Proposed_IndirectGaintEagleUnits__c) ? 0 : parseFloat(relatedList[i].bidLineItem.Phoenix_Proposed_IndirectGaintEagleUnits__c)));
                                    totalSummary3 += ((isNaN(relatedList[i].bidLineItem.Phoenix_Final_Direct_Selling_Units_Calc__c) ? 0 : parseFloat(relatedList[i].bidLineItem.Phoenix_Final_Direct_Selling_Units_Calc__c)));
                                } else if(relatedList[i].bidRecord.Phoenix_Customer_Type__c == 'Walgreens' || relatedList[i].bidRecord.Phoenix_Customer_Type__c == 'ABC Progen' || relatedList[i].bidRecord.Phoenix_Customer_Type__c == 'ABC Pharmagen' 
                                          || relatedList[i].bidRecord.Phoenix_Customer_Type__c == 'Costco' || relatedList[i].bidRecord.Phoenix_Customer_Type__c == 'Indirect' || relatedList[i].bidRecord.Phoenix_Customer_Type__c == 'Sams Club' 
                                          || relatedList[i].bidRecord.Phoenix_Customer_Type__c == 'Government Pricing'){
                                    totalSummary1 += ((isNaN(relatedList[i].proposedBottles) ? 0 : parseFloat(relatedList[i].proposedBottles)));
                                }
                            }
                            summary[0] = parseInt(previousTotal);
                            summary[1] = parseInt(currentTotal);
                            summary[2] = parseInt(annualImapact);
                            summary[3] = parseInt(businessImpact);
                            summary[4] = parseInt(previousTPT);
                            summary[5] = parseInt(currentTPT);
                            summary[6] = parseInt(currentTPT) - parseInt(previousTPT);
                            summary[7] = parseInt(priceVarianceFamilySummary);
                            summary[8] = parseInt(volumeVarianceFamilySummary);
                            summary[9] = ((!isFinite(previousTPT/previousTotal) ? 0 : (previousTPT/previousTotal)));
                            summary[10] = ((!isFinite(currentTPT/currentTotal) ? 0 : (currentTPT/currentTotal)));
                            summary[11] = parseInt(unit1);
                            summary[12] = parseInt(unit2);
                            summary[13] = parseInt(unit3);
                            summary[14] = parseInt(unit4);
                            summary[15] = parseInt(unit5);
                            summary[16] = parseInt(unit6);
                            summary[17] = parseInt(totalPreviousAwdQtySummary);
                            summary[18] = parseInt(totalAwdQtySummary);
                            summary[19] = parseInt(unit7);
                            summary[20] = parseInt(unit8);
                            summary[21] = totalSummary1;
                            summary[22] = totalSummary2;
                            summary[23] = totalSummary3;
                            summary[24] = totalSummary4;
                            summary[25] = totalSummary5;
                            summary[26] = parseInt(unit10);
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
                            var unit1 = ((isNaN(rec.unit1) ? 0 : rec.unit1));
                            var unit2 = ((isNaN(rec.unit2) ? 0 : rec.unit2));
                            var unit3 = ((isNaN(rec.unit3) ? 0 : rec.unit3));
                            var unit4 = ((isNaN(rec.unit4) ? 0 : rec.unit4));
                            var unit5 = ((isNaN(rec.unit5) ? 0 : rec.unit5));
                            var unit6 = ((isNaN(rec.unit6) ? 0 : rec.unit6));
                            var unit7 = ((isNaN(rec.unit7) ? 0 : rec.unit7));
                            var unit8 = ((isNaN(rec.unit8) ? 0 : rec.unit8));
                            var unit10 = ((isNaN(rec.unit10) ? 0 : rec.unit10));
                            summary[0] = parseInt(previousTotal);
                            summary[1] = parseInt(currentTotal);
                            summary[2] = parseInt(annualImapact);
                            summary[3] = parseInt(businessImpact);
                            summary[4] = parseInt(previousTPT);
                            summary[5] = parseInt(currentTPT);
                            summary[6] = parseInt(currentTPT) - parseInt(previousTPT);
                            summary[7] = parseInt(priceVarianceFamilySummary);
                            summary[8] = parseInt(volumeVarianceFamilySummary);
                            summary[9] = ((!isFinite(previousTPT/previousTotal) ? 0 : (previousTPT/previousTotal)));
                            summary[10] = ((!isFinite(currentTPT/currentTotal) ? 0 : (currentTPT/currentTotal)));
                            summary[11] = parseInt(unit1);
                            summary[12] = parseInt(unit2);
                            summary[13] = parseInt(unit3);
                            summary[14] = parseInt(unit4);
                            summary[15] = parseInt(unit5);
                            summary[16] = parseInt(unit6);
                            summary[17] = parseInt(totalPreviousAwdQtySummary);
                            summary[18] = parseInt(totalAwdQtySummary);
                            summary[19] = parseInt(unit7);
                            summary[20] = parseInt(unit8);
                            summary[26] = parseInt(unit10);
                            if(rec.bidRecord.Phoenix_Customer_Type__c == 'Net Indirect Pricing' || rec.bidRecord.Phoenix_Customer_Type__c == 'Direct and Indirect' || rec.bidRecord.Phoenix_Customer_Type__c == 'Econdisc' ){
                                var scmSummary1 = ((isNaN(rec.bidLineItem.Phoenix_Final_Direct_Selling_Units_Calc__c) ? 0 : parseFloat(rec.bidLineItem.Phoenix_Final_Direct_Selling_Units_Calc__c)));
                                var scmSummary2 = ((isNaN(rec.bidLineItem.Phoenix_Final_Indirect_Selling_Units_Cal__c) ? 0 : parseFloat(rec.bidLineItem.Phoenix_Final_Indirect_Selling_Units_Cal__c)));
                                summary[21] = scmSummary1;
                                summary[22] = scmSummary2;
                            } else if(rec.bidRecord.Phoenix_Customer_Type__c == 'Direct'){
                                var scmSummary1 = ((isNaN(rec.bidLineItem.Phoenix_Total_SCM_Approved_Qty__c) ? 0 : parseFloat(rec.bidLineItem.Phoenix_Total_SCM_Approved_Qty__c)));
                                summary[21] = parseInt(scmSummary1);
                            } else if(rec.bidRecord.Phoenix_Customer_Type__c == 'BASE/DSH'){
                                var scmSummary1 = ((isNaN(rec.bidLineItem.Phoenix_IDN_Usage__c) ? 0 : parseFloat(rec.bidLineItem.Phoenix_IDN_Usage__c)));
                                var scmSummary2 = ((isNaN(rec.bidLineItem.Phoenix_Days_Notice_Product_Discontinuat__c) ? 0 : parseFloat(rec.bidLineItem.Phoenix_Days_Notice_Product_Discontinuat__c)));
                                var scmSummary3 = ((isNaN(rec.bidLineItem.Phoenix_Day_s_Notice_Product_removal__c) ? 0 : parseFloat(rec.bidLineItem.Phoenix_Day_s_Notice_Product_removal__c)));
                                summary[21] = scmSummary1;
                                summary[22] = scmSummary2;
                                summary[23] = scmSummary3;
                            } else if(rec.bidRecord.Phoenix_Customer_Type__c == 'ROS'){
                                var scmSummary1 = ((isNaN(rec.bidLineItem.Phoenix_Current_Anda_Units__c) ? 0 : parseFloat(rec.bidLineItem.Phoenix_Current_Anda_Units__c)));
                                var scmSummary2 = ((isNaN(rec.bidLineItem.Phoenix_Current_Indirect_Gaint_EagleUnit__c) ? 0 : parseFloat(rec.bidLineItem.Phoenix_Current_Indirect_Gaint_EagleUnit__c)));
                                var scmSummary3 = ((isNaN(rec.bidLineItem.Phoenix_ProposedIndirectAholdDelhaizeUni__c) ? 0 : parseFloat(rec.bidLineItem.Phoenix_ProposedIndirectAholdDelhaizeUni__c)));
                                var scmSummary4 = ((isNaN(rec.bidLineItem.Phoenix_Proposed_IndirectGaintEagleUnits__c) ? 0 : parseFloat(rec.bidLineItem.Phoenix_Proposed_IndirectGaintEagleUnits__c)));
                                summary[21] = scmSummary1;
                                summary[22] = scmSummary2;
                                summary[23] = scmSummary3;
                                summary[24] = scmSummary4;
                            } else if(rec.bidRecord.Phoenix_Customer_Type__c == 'RXSS'){
                                var scmSummary1 = ((isNaN(rec.bidLineItem.Phoenix_Day_s_Notice_Product_removal__c) ? 0 : parseFloat(rec.bidLineItem.Phoenix_Day_s_Notice_Product_removal__c)));
                                var scmSummary2 = ((isNaN(rec.bidLineItem.Phoenix_Current_Indirect_Gaint_EagleUnit__c) ? 0 : parseFloat(rec.bidLineItem.Phoenix_Current_Indirect_Gaint_EagleUnit__c)));
                                var scmSummary3 = ((isNaN(rec.bidLineItem.Phoenix_Proposed_IndirectGaintEagleUnits__c) ? 0 : parseFloat(rec.bidLineItem.Phoenix_Proposed_IndirectGaintEagleUnits__c)));
                                var scmSummary4 = ((isNaN(rec.bidLineItem.Phoenix_IDN_Usage__c) ? 0 : parseFloat(rec.bidLineItem.Phoenix_IDN_Usage__c)));
                                var scmSummary5 = ((isNaN(rec.bidLineItem.Phoenix_Days_Notice_Product_Discontinuat__c) ? 0 : parseFloat(rec.bidLineItem.Phoenix_Days_Notice_Product_Discontinuat__c)));
                                summary[21] = scmSummary1;
                                summary[22] = scmSummary2;
                                summary[23] = scmSummary3;
                                summary[24] = scmSummary4;
                                summary[25] = scmSummary5;
                            } else if(rec.bidRecord.Phoenix_Customer_Type__c == 'ClarusOne'){
                                var scmSummary1 = ((isNaN(rec.bidLineItem.Phoenix_ProposedIndirectAholdDelhaizeUni__c) ? 0 : parseFloat(rec.bidLineItem.Phoenix_ProposedIndirectAholdDelhaizeUni__c)));
                                var scmSummary2 = ((isNaN(rec.bidLineItem.Phoenix_Proposed_IndirectGaintEagleUnits__c) ? 0 : parseFloat(rec.bidLineItem.Phoenix_Proposed_IndirectGaintEagleUnits__c)));
                                var scmSummary3 = ((isNaN(rec.bidLineItem.Phoenix_Final_Direct_Selling_Units_Calc__c) ? 0 : parseFloat(rec.bidLineItem.Phoenix_Final_Direct_Selling_Units_Calc__c)));
                                summary[21] = scmSummary1;
                                summary[22] = scmSummary2;
                                summary[23] = scmSummary3;
                            } else if(rec.bidRecord.Phoenix_Customer_Type__c == 'OneTimeBuy'){
                                var scmSummary1 = ((isNaN(rec.bidLineItem.Phoenix_Total_SCM_Approved_Qty__c) ? 0 : parseFloat(rec.bidLineItem.Phoenix_Total_SCM_Approved_Qty__c)));
                                summary[21] = scmSummary1;
                            } else if(rec.bidRecord.Phoenix_Customer_Type__c == 'Walgreens' || rec.bidRecord.Phoenix_Customer_Type__c == 'ABC Progen' || rec.bidRecord.Phoenix_Customer_Type__c == 'ABC Pharmagen' 
                                      || rec.bidRecord.Phoenix_Customer_Type__c == 'Costco' || rec.bidRecord.Phoenix_Customer_Type__c == 'Indirect' || rec.bidRecord.Phoenix_Customer_Type__c == 'Sams Club' 
                                      || rec.bidRecord.Phoenix_Customer_Type__c == 'Government Pricing'){
                                var scmSummary1 = ((isNaN(rec.proposedBottles) ? 0 : parseFloat(rec.proposedBottles)));
                                summary[21] = scmSummary1;
                            }
                            openStatusFamilySummaryMap[rec.productFamily] = summary;
                        }
                    });
                    
                    keys = Object.keys(openStatusFamilySummaryMap);
                    keys.sort(function(a, b) { return openStatusFamilySummaryMap[b][2] - openStatusFamilySummaryMap[a][2] });
                    var openStatusSummary = [];
                    openStatusSummary[11] = 0;
                    openStatusSummary[12] = 0;
                    openStatusSummary[13] = 0;
                    openStatusSummary[14] = 0;
                    openStatusSummary[15] = 0;
                    openStatusSummary[16] = 0;
                    openStatusSummary[17] = 0;
                    openStatusSummary[18] = 0;
                    openStatusSummary[19] = 0;
                    openStatusSummary[20] = 0;
                    openStatusSummary[21] = 0;
                    openStatusSummary[22] = 0;
                    openStatusSummary[23] = 0;
                    openStatusSummary[24] = 0;
                    openStatusSummary[25] = 0;
                    openStatusSummary[26] = 0;
                    for(var i=0; i<keys.length; i++){
                        tempObj[keys[i]] = openStatusFamilySummaryMap[keys[i]];
                        var tem = openStatusFamilySummaryMap[keys[i]];
                        openStatusSummary[11] += parseFloat(tem[11]);
                        openStatusSummary[12] += parseFloat(tem[12]);
                        openStatusSummary[13] += parseFloat(tem[13]);
                        openStatusSummary[14] += parseFloat(tem[14]);
                        openStatusSummary[15] += parseFloat(tem[15]);
                        openStatusSummary[16] += parseFloat(tem[16]);
                        openStatusSummary[17] += parseFloat(tem[17]);
                        openStatusSummary[18] += parseFloat(tem[18]);
                        openStatusSummary[19] += parseFloat(tem[19]);
                        openStatusSummary[20] += parseFloat(tem[20]);
                        openStatusSummary[21] += parseFloat(tem[21]);
                        openStatusSummary[22] += parseFloat(tem[22]);
                        openStatusSummary[23] += parseFloat(tem[23]);
                        openStatusSummary[24] += parseFloat(tem[24]);
                        openStatusSummary[25] += parseFloat(tem[25]);   
                        openStatusSummary[26] += parseFloat(tem[26]);
                    }
                    component.set("v.openStatusSummary", openStatusSummary);
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
                    
                    
                    component.set("v.lossList", lossList);
                    
                    
                    var noEffectMap = {};
                    var noEffectFamilySummaryMap = {}; var totalPreviousQtyNE = 0; var totalAwardedQtyNE = 0;
                    noEffectList.forEach(function(rec){
                        if(noEffectMap.hasOwnProperty(rec.productFamily)){
                            var relatedList = noEffectMap[rec.productFamily]; var summary = [];
                            relatedList.push(rec);
                            noEffectMap[rec.productFamily] = relatedList;
                            var previousTotal = 0; var currentTotal = 0; var annualImapact = 0; var businessImpact = 0; var previousTPT = 0; var currentTPT = 0;
                            var previousTPTFamilySummary = 0; var currentTPTFamilySummary = 0; var priceVarianceFamilySummary = 0; var volumeVarianceFamilySummary = 0;
                            var totalVarianceFamilySummary = 0; var tptVarianceFamilySummary = 0; var unit1 = 0; var unit2 = 0; var unit3 = 0; var unit4 = 0; var unit5=0; var unit6=0;
                            var totalPreviousAwdQtySummary = 0; var totalAwdQtySummary = 0; var unit7=0; var unit8 = 0;var unit10 = 0;
                            var totalSummary1 = 0; var totalSummary2 = 0; var totalSummary3 = 0; var totalSummary4 = 0; var totalSummary5 = 0;
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
                                unit1 += ((isNaN(relatedList[i].unit1) ? 0 : relatedList[i].unit1));
                                unit2 += ((isNaN(relatedList[i].unit2) ? 0 : relatedList[i].unit2));
                                unit3 += ((isNaN(relatedList[i].unit3) ? 0 : relatedList[i].unit3));
                                unit4 += ((isNaN(relatedList[i].unit4) ? 0 : relatedList[i].unit4));
                                unit5 += ((isNaN(relatedList[i].unit5) ? 0 : relatedList[i].unit5));
                                unit6 += ((isNaN(relatedList[i].unit6) ? 0 : relatedList[i].unit6));
                                unit7 += ((isNaN(relatedList[i].unit7) ? 0 : relatedList[i].unit7));
                                unit8 += ((isNaN(relatedList[i].unit8) ? 0 : relatedList[i].unit8));
                                unit10 += ((isNaN(relatedList[i].unit10) ? 0 : relatedList[i].unit10));
                                if(relatedList[i].bidRecord.Phoenix_Customer_Type__c == 'Net Indirect Pricing' || relatedList[i].bidRecord.Phoenix_Customer_Type__c == 'Direct and Indirect' || relatedList[i].bidRecord.Phoenix_Customer_Type__c == 'Econdisc'){
                                    totalSummary1 += ((isNaN(relatedList[i].bidLineItem.Phoenix_Final_Direct_Selling_Units_Calc__c) ? 0 : parseFloat(relatedList[i].bidLineItem.Phoenix_Final_Direct_Selling_Units_Calc__c)));
                                    totalSummary2 += ((isNaN(relatedList[i].bidLineItem.Phoenix_Final_Indirect_Selling_Units_Cal__c) ? 0 : parseFloat(relatedList[i].bidLineItem.Phoenix_Final_Indirect_Selling_Units_Cal__c)));
                                } else if(relatedList[i].bidRecord.Phoenix_Customer_Type__c == 'Direct'){
                                    totalSummary1 += ((isNaN(relatedList[i].bidLineItem.Phoenix_Total_SCM_Approved_Qty__c) ? 0 : parseFloat(relatedList[i].bidLineItem.Phoenix_Total_SCM_Approved_Qty__c)));
                                } else if(relatedList[i].bidRecord.Phoenix_Customer_Type__c == 'BASE/DSH'){
                                    totalSummary1 += ((isNaN(relatedList[i].bidLineItem.Phoenix_IDN_Usage__c) ? 0 : parseFloat(relatedList[i].bidLineItem.Phoenix_IDN_Usage__c)));
                                    totalSummary2 += ((isNaN(relatedList[i].bidLineItem.Phoenix_Days_Notice_Product_Discontinuat__c) ? 0 : parseFloat(relatedList[i].bidLineItem.Phoenix_Days_Notice_Product_Discontinuat__c)));
                                    totalSummary3 += ((isNaN(relatedList[i].bidLineItem.Phoenix_Day_s_Notice_Product_removal__c) ? 0 : parseFloat(relatedList[i].bidLineItem.Phoenix_Day_s_Notice_Product_removal__c)));
                                } else if(relatedList[i].bidRecord.Phoenix_Customer_Type__c == 'ROS'){
                                    totalSummary1 += ((isNaN(relatedList[i].bidLineItem.Phoenix_Current_Anda_Units__c) ? 0 : parseFloat(relatedList[i].bidLineItem.Phoenix_Current_Anda_Units__c)));
                                    totalSummary2 += ((isNaN(relatedList[i].bidLineItem.Phoenix_Current_Indirect_Gaint_EagleUnit__c) ? 0 : parseFloat(relatedList[i].bidLineItem.Phoenix_Current_Indirect_Gaint_EagleUnit__c)));
                                    totalSummary3 += ((isNaN(relatedList[i].bidLineItem.Phoenix_ProposedIndirectAholdDelhaizeUni__c) ? 0 : parseFloat(relatedList[i].bidLineItem.Phoenix_ProposedIndirectAholdDelhaizeUni__c)));
                                    totalSummary4 += ((isNaN(relatedList[i].bidLineItem.Phoenix_Proposed_IndirectGaintEagleUnits__c) ? 0 : parseFloat(relatedList[i].bidLineItem.Phoenix_Proposed_IndirectGaintEagleUnits__c)));
                                } else if(relatedList[i].bidRecord.Phoenix_Customer_Type__c == 'RXSS'){
                                    totalSummary1 += ((isNaN(relatedList[i].bidLineItem.Phoenix_Day_s_Notice_Product_removal__c) ? 0 : parseFloat(relatedList[i].bidLineItem.Phoenix_Day_s_Notice_Product_removal__c)));
                                    totalSummary2 += ((isNaN(relatedList[i].bidLineItem.Phoenix_Current_Indirect_Gaint_EagleUnit__c) ? 0 : parseFloat(relatedList[i].bidLineItem.Phoenix_Current_Indirect_Gaint_EagleUnit__c)));
                                    totalSummary3 += ((isNaN(relatedList[i].bidLineItem.Phoenix_Proposed_IndirectGaintEagleUnits__c) ? 0 : parseFloat(relatedList[i].bidLineItem.Phoenix_Proposed_IndirectGaintEagleUnits__c)));
                                    totalSummary4 += ((isNaN(relatedList[i].bidLineItem.Phoenix_IDN_Usage__c) ? 0 : parseFloat(relatedList[i].bidLineItem.Phoenix_IDN_Usage__c)));
                                    totalSummary5 += ((isNaN(relatedList[i].bidLineItem.Phoenix_Days_Notice_Product_Discontinuat__c) ? 0 : parseFloat(relatedList[i].bidLineItem.Phoenix_Days_Notice_Product_Discontinuat__c)));
                                } else if(relatedList[i].bidRecord.Phoenix_Customer_Type__c == 'OneTimeBuy'){
                                    totalSummary1 += ((isNaN(relatedList[i].bidLineItem.Phoenix_Total_SCM_Approved_Qty__c) ? 0 : parseFloat(relatedList[i].bidLineItem.Phoenix_Total_SCM_Approved_Qty__c)));
                                } else if(relatedList[i].bidRecord.Phoenix_Customer_Type__c == 'ClarusOne'){
                                    totalSummary1 += ((isNaN(relatedList[i].bidLineItem.Phoenix_ProposedIndirectAholdDelhaizeUni__c) ? 0 : parseFloat(relatedList[i].bidLineItem.Phoenix_ProposedIndirectAholdDelhaizeUni__c)));
                                    totalSummary2 += ((isNaN(relatedList[i].bidLineItem.Phoenix_Proposed_IndirectGaintEagleUnits__c) ? 0 : parseFloat(relatedList[i].bidLineItem.Phoenix_Proposed_IndirectGaintEagleUnits__c)));
                                    totalSummary3 += ((isNaN(relatedList[i].bidLineItem.Phoenix_Final_Direct_Selling_Units_Calc__c) ? 0 : parseFloat(relatedList[i].bidLineItem.Phoenix_Final_Direct_Selling_Units_Calc__c)));
                                } else if(relatedList[i].bidRecord.Phoenix_Customer_Type__c == 'Walgreens' || relatedList[i].bidRecord.Phoenix_Customer_Type__c == 'ABC Progen' || relatedList[i].bidRecord.Phoenix_Customer_Type__c == 'ABC Pharmagen' 
                                          || relatedList[i].bidRecord.Phoenix_Customer_Type__c == 'Costco' || relatedList[i].bidRecord.Phoenix_Customer_Type__c == 'Indirect' || relatedList[i].bidRecord.Phoenix_Customer_Type__c == 'Sams Club' 
                                          || relatedList[i].bidRecord.Phoenix_Customer_Type__c == 'Government Pricing'){
                                    totalSummary1 += ((isNaN(relatedList[i].proposedBottles) ? 0 : parseFloat(relatedList[i].proposedBottles)));
                                }
                            }
                            summary[0] = parseInt(previousTotal);
                            summary[1] = parseInt(currentTotal);
                            summary[2] = parseInt(annualImapact);
                            summary[3] = parseInt(businessImpact);
                            summary[4] = parseInt(previousTPT);
                            summary[5] = parseInt(currentTPT);
                            summary[6] = parseInt(currentTPT) - parseInt(previousTPT);
                            summary[7] = parseInt(priceVarianceFamilySummary);
                            summary[8] = parseInt(volumeVarianceFamilySummary);
                            summary[9] = ((!isFinite(previousTPT/previousTotal) ? 0 : (previousTPT/previousTotal)));
                            summary[10] = ((!isFinite(currentTPT/currentTotal) ? 0 : (currentTPT/currentTotal)));
                            summary[11] = parseInt(unit1);
                            summary[12] = parseInt(unit2);
                            summary[13] = parseInt(unit3);
                            summary[14] = parseInt(unit4);
                            summary[15] = parseInt(unit5);
                            summary[16] = parseInt(unit6);
                            summary[17] = parseInt(totalPreviousAwdQtySummary);
                            summary[18] = parseInt(totalAwdQtySummary);
                            summary[19] = parseInt(unit7);
                            summary[20] = parseInt(unit8);
                            summary[21] = totalSummary1;
                            summary[22] = totalSummary2;
                            summary[23] = totalSummary3;
                            summary[24] = totalSummary4;
                            summary[25] = totalSummary5;
                            summary[26] = parseInt(unit10);
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
                            var unit1 = ((isNaN(rec.unit1) ? 0 : rec.unit1));
                            var unit2 = ((isNaN(rec.unit2) ? 0 : rec.unit2));
                            var unit3 = ((isNaN(rec.unit3) ? 0 : rec.unit3));
                            var unit4 = ((isNaN(rec.unit4) ? 0 : rec.unit4));
                            var unit5 = ((isNaN(rec.unit5) ? 0 : rec.unit5));
                            var unit6 = ((isNaN(rec.unit6) ? 0 : rec.unit6));
                            var unit7 = ((isNaN(rec.unit7) ? 0 : rec.unit7));
                            var unit8 = ((isNaN(rec.unit8) ? 0 : rec.unit8));
                            var unit10 = ((isNaN(rec.unit10) ? 0 : rec.unit10));
                            summary[0] = parseInt(previousTotal);
                            summary[1] = parseInt(currentTotal);
                            summary[2] = parseInt(annualImapact);
                            summary[3] = parseInt(businessImpact);
                            summary[4] = parseInt(previousTPT);
                            summary[5] = parseInt(currentTPT);
                            summary[6] = parseInt(currentTPT) - parseInt(previousTPT);
                            summary[7] = parseInt(priceVarianceFamilySummary);
                            summary[8] = parseInt(volumeVarianceFamilySummary);
                            summary[9] = ((!isFinite(previousTPT/previousTotal) ? 0 : (previousTPT/previousTotal)));
                            summary[10] = ((!isFinite(currentTPT/currentTotal) ? 0 : (currentTPT/currentTotal)));
                            summary[11] = parseInt(unit1);
                            summary[12] = parseInt(unit2);
                            summary[13] = parseInt(unit3);
                            summary[14] = parseInt(unit4);
                            summary[15] = parseInt(unit5);
                            summary[16] = parseInt(unit6);
                            summary[17] = parseInt(totalPreviousAwdQtySummary);
                            summary[18] = parseInt(totalAwdQtySummary);
                            summary[19] = parseInt(unit7);
                            summary[20] = parseInt(unit8);
                            summary[26] = parseInt(unit10);
                            if(rec.bidRecord.Phoenix_Customer_Type__c == 'Net Indirect Pricing' || rec.bidRecord.Phoenix_Customer_Type__c == 'Direct and Indirect' || rec.bidRecord.Phoenix_Customer_Type__c == 'Econdisc' ){
                                var scmSummary1 = ((isNaN(rec.bidLineItem.Phoenix_Final_Direct_Selling_Units_Calc__c) ? 0 : parseFloat(rec.bidLineItem.Phoenix_Final_Direct_Selling_Units_Calc__c)));
                                var scmSummary2 = ((isNaN(rec.bidLineItem.Phoenix_Final_Indirect_Selling_Units_Cal__c) ? 0 : parseFloat(rec.bidLineItem.Phoenix_Final_Indirect_Selling_Units_Cal__c)));
                                summary[21] = scmSummary1;
                                summary[22] = scmSummary2;
                            } else if(rec.bidRecord.Phoenix_Customer_Type__c == 'Direct'){
                                var scmSummary1 = ((isNaN(rec.bidLineItem.Phoenix_Total_SCM_Approved_Qty__c) ? 0 : parseFloat(rec.bidLineItem.Phoenix_Total_SCM_Approved_Qty__c)));
                                summary[21] = parseInt(scmSummary1);
                            } else if(rec.bidRecord.Phoenix_Customer_Type__c == 'BASE/DSH'){
                                var scmSummary1 = ((isNaN(rec.bidLineItem.Phoenix_IDN_Usage__c) ? 0 : parseFloat(rec.bidLineItem.Phoenix_IDN_Usage__c)));
                                var scmSummary2 = ((isNaN(rec.bidLineItem.Phoenix_Days_Notice_Product_Discontinuat__c) ? 0 : parseFloat(rec.bidLineItem.Phoenix_Days_Notice_Product_Discontinuat__c)));
                                var scmSummary3 = ((isNaN(rec.bidLineItem.Phoenix_Day_s_Notice_Product_removal__c) ? 0 : parseFloat(rec.bidLineItem.Phoenix_Day_s_Notice_Product_removal__c)));
                                summary[21] = scmSummary1;
                                summary[22] = scmSummary2;
                                summary[23] = scmSummary3;
                            } else if(rec.bidRecord.Phoenix_Customer_Type__c == 'ROS'){
                                var scmSummary1 = ((isNaN(rec.bidLineItem.Phoenix_Current_Anda_Units__c) ? 0 : parseFloat(rec.bidLineItem.Phoenix_Current_Anda_Units__c)));
                                var scmSummary2 = ((isNaN(rec.bidLineItem.Phoenix_Current_Indirect_Gaint_EagleUnit__c) ? 0 : parseFloat(rec.bidLineItem.Phoenix_Current_Indirect_Gaint_EagleUnit__c)));
                                var scmSummary3 = ((isNaN(rec.bidLineItem.Phoenix_ProposedIndirectAholdDelhaizeUni__c) ? 0 : parseFloat(rec.bidLineItem.Phoenix_ProposedIndirectAholdDelhaizeUni__c)));
                                var scmSummary4 = ((isNaN(rec.bidLineItem.Phoenix_Proposed_IndirectGaintEagleUnits__c) ? 0 : parseFloat(rec.bidLineItem.Phoenix_Proposed_IndirectGaintEagleUnits__c)));
                                summary[21] = scmSummary1;
                                summary[22] = scmSummary2;
                                summary[23] = scmSummary3;
                                summary[24] = scmSummary4;
                            } else if(rec.bidRecord.Phoenix_Customer_Type__c == 'RXSS'){
                                var scmSummary1 = ((isNaN(rec.bidLineItem.Phoenix_Day_s_Notice_Product_removal__c) ? 0 : parseFloat(rec.bidLineItem.Phoenix_Day_s_Notice_Product_removal__c)));
                                var scmSummary2 = ((isNaN(rec.bidLineItem.Phoenix_Current_Indirect_Gaint_EagleUnit__c) ? 0 : parseFloat(rec.bidLineItem.Phoenix_Current_Indirect_Gaint_EagleUnit__c)));
                                var scmSummary3 = ((isNaN(rec.bidLineItem.Phoenix_Proposed_IndirectGaintEagleUnits__c) ? 0 : parseFloat(rec.bidLineItem.Phoenix_Proposed_IndirectGaintEagleUnits__c)));
                                var scmSummary4 = ((isNaN(rec.bidLineItem.Phoenix_IDN_Usage__c) ? 0 : parseFloat(rec.bidLineItem.Phoenix_IDN_Usage__c)));
                                var scmSummary5 = ((isNaN(rec.bidLineItem.Phoenix_Days_Notice_Product_Discontinuat__c) ? 0 : parseFloat(rec.bidLineItem.Phoenix_Days_Notice_Product_Discontinuat__c)));
                                summary[21] = scmSummary1;
                                summary[22] = scmSummary2;
                                summary[23] = scmSummary3;
                                summary[24] = scmSummary4;
                                summary[25] = scmSummary5;
                            } else if(rec.bidRecord.Phoenix_Customer_Type__c == 'ClarusOne'){
                                var scmSummary1 = ((isNaN(rec.bidLineItem.Phoenix_ProposedIndirectAholdDelhaizeUni__c) ? 0 : parseFloat(rec.bidLineItem.Phoenix_ProposedIndirectAholdDelhaizeUni__c)));
                                var scmSummary2 = ((isNaN(rec.bidLineItem.Phoenix_Proposed_IndirectGaintEagleUnits__c) ? 0 : parseFloat(rec.bidLineItem.Phoenix_Proposed_IndirectGaintEagleUnits__c)));
                                var scmSummary3 = ((isNaN(rec.bidLineItem.Phoenix_Final_Direct_Selling_Units_Calc__c) ? 0 : parseFloat(rec.bidLineItem.Phoenix_Final_Direct_Selling_Units_Calc__c)));
                                summary[21] = scmSummary1;
                                summary[22] = scmSummary2;
                                summary[23] = scmSummary3;
                            } else if(rec.bidRecord.Phoenix_Customer_Type__c == 'OneTimeBuy'){
                                var scmSummary1 = ((isNaN(rec.bidLineItem.Phoenix_Total_SCM_Approved_Qty__c) ? 0 : parseFloat(rec.bidLineItem.Phoenix_Total_SCM_Approved_Qty__c)));
                                summary[21] = scmSummary1;
                            } else if(rec.bidRecord.Phoenix_Customer_Type__c == 'Walgreens' || rec.bidRecord.Phoenix_Customer_Type__c == 'ABC Progen' || rec.bidRecord.Phoenix_Customer_Type__c == 'ABC Pharmagen' 
                                      || rec.bidRecord.Phoenix_Customer_Type__c == 'Costco' || rec.bidRecord.Phoenix_Customer_Type__c == 'Indirect' || rec.bidRecord.Phoenix_Customer_Type__c == 'Sams Club' 
                                      || rec.bidRecord.Phoenix_Customer_Type__c == 'Government Pricing'){
                                var scmSummary1 = ((isNaN(rec.proposedBottles) ? 0 : parseFloat(rec.proposedBottles)));
                                summary[21] = scmSummary1;
                            }
                            noEffectFamilySummaryMap[rec.productFamily] = summary;
                        }
                    });
                    
                    keys = Object.keys(noEffectFamilySummaryMap);
                    keys.sort(function(a, b) { return noEffectFamilySummaryMap[b][2] - noEffectFamilySummaryMap[a][2] });
                    var noEffectSummary = [];
                    noEffectSummary[11] = 0;
                    noEffectSummary[12] = 0;
                    noEffectSummary[13] = 0;
                    noEffectSummary[14] = 0;
                    noEffectSummary[15] = 0;
                    noEffectSummary[16] = 0;
                    noEffectSummary[17] = 0;
                    noEffectSummary[18] = 0;
                    noEffectSummary[19] = 0;
                    noEffectSummary[20] = 0;
                    noEffectSummary[21] = 0;
                    noEffectSummary[22] = 0;
                    noEffectSummary[23] = 0;
                    noEffectSummary[24] = 0;
                    noEffectSummary[25] = 0;
                    noEffectSummary[26] = 0;
                    for(var i=0; i<keys.length; i++){
                        tempObj[keys[i]] = noEffectFamilySummaryMap[keys[i]];
                        var tem = noEffectFamilySummaryMap[keys[i]];
                        noEffectSummary[11] += parseFloat(tem[11]);
                        noEffectSummary[12] += parseFloat(tem[12]);
                        noEffectSummary[13] += parseFloat(tem[13]);
                        noEffectSummary[14] += parseFloat(tem[14]);
                        noEffectSummary[15] += parseFloat(tem[15]);
                        noEffectSummary[16] += parseFloat(tem[16]);
                        noEffectSummary[17] += parseFloat(tem[17]);
                        noEffectSummary[18] += parseFloat(tem[18]);
                        noEffectSummary[19] += parseFloat(tem[19]);
                        noEffectSummary[20] += parseFloat(tem[20]);
                        noEffectSummary[21] += parseFloat(tem[21]);
                        noEffectSummary[22] += parseFloat(tem[22]);
                        noEffectSummary[23] += parseFloat(tem[23]);
                        noEffectSummary[24] += parseFloat(tem[24]);
                        noEffectSummary[25] += parseFloat(tem[25]);   
                        noEffectSummary[26] += parseFloat(tem[26]);
                    }
                    component.set("v.noEffectSummary", noEffectSummary);
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
                    
                    var lostKeys = Object.keys(removalsDataFormattingObj);
                    var lostListToSort = {};
                    for(var i=0; i<lostKeys.length; i++){
                        var products = removalsDataFormattingObj[lostKeys[i]];
                        var totalAnnualImpact = 0;
                        for(var j=0; j<products.length; j++){
                            totalAnnualImpact += products[j].annualImpact;
                        }
                        lostListToSort[lostKeys[i]] = totalAnnualImpact;
                    }
                    lostKeys = Object.keys(lostListToSort);
                    lostKeys.sort(function(a, b) { return lostListToSort[b] - lostListToSort[a] });
                    for(var i=0; i<lostKeys.length; i++){
                        tempObj[lostKeys[i]] = removalsDataFormattingObj[lostKeys[i]];
                    }
                    removalsDataFormattingObj = tempObj;
                    component.set("v.lossData", Object.entries(removalsDataFormattingObj));

                    component.set("v.businessGained", 'Business Gained'+' ('+formatter.format(totalObj.totalAnnualImpactBG.toFixed())+', '+formatter.format(totalObj.totalBusinessImpactBG.toFixed())+')');
                    component.set("v.retainedGain", 'Business Retained with Gains'+' ('+formatter.format(totalObj.totalAnnualImpactBGG.toFixed())+', '+formatter.format(totalObj.totalBusinessImpactBGG.toFixed())+')');
                    component.set("v.retainedLoss", 'Business Retained with Loss'+' ('+formatter.format(totalObj.totalAnnualImpactBGL.toFixed())+', '+formatter.format(totalObj.totalBusinessImpactBGL.toFixed())+')');
                    component.set("v.openStatus", 'Open Status'+' ('+formatter.format(totalObj.totalAnnualImpactOS.toFixed())+', '+formatter.format(totalObj.totalBusinessImpactOS.toFixed())+')');
                    if(scmDataList[0].bidRecord.Phoenix_Bid_Type__c == 'Product Discontinuation Process' || scmDataList[0].bidRecord.Phoenix_Bid_Type__c == 'Mass Product Removals'){
                        if(totalObj.totalAnnualImpactBL == null || totalObj.totalAnnualImpactBL == 0){
                            component.set("v.lost", 'Business Lost');
                        } else{
                            component.set("v.lost", 'Business Lost'+' ('+formatter.format(totalObj.totalAnnualImpactBL.toFixed())+', '+formatter.format(totalObj.totalBusinessImpactBL.toFixed())+')');      
                        }
                    }
                    component.set("v.noEffect", 'No Effect Bids'+' ('+formatter.format(totalObj.totalAnnualImpactNE.toFixed())+', '+formatter.format(totalObj.totalBusinessImpactNE.toFixed())+')');
                    if(scmDataList[0].bidRecord.Phoenix_Bid_Type__c == 'OTC New Product' || scmDataList[0].bidRecord.Phoenix_Bid_Type__c == 'OTC OTB Good Dated' || scmDataList[0].bidRecord.Phoenix_Bid_Type__c == 'OTC OTB Short Dated' || scmDataList[0].bidRecord.Phoenix_Bid_Type__c == 'OTC Price Change'
                       || scmDataList[0].bidRecord.Phoenix_Bid_Type__c == 'OTC Product Addition' || scmDataList[0].bidRecord.Phoenix_Bid_Type__c == 'OTC Rebate Change' || scmDataList[0].bidRecord.Phoenix_Bid_Type__c == 'OTC RFP' || scmDataList[0].bidRecord.Phoenix_Bid_Type__c == 'OTC Volume Review'){
                        scmDataList[0].bidRecord.isOTCType = true;
                    } else{
                        scmDataList[0].bidRecord.isOTCType = false;
                    }
                    component.set("v.bidRecord",scmDataList[0].bidRecord);
                    component.set("v.templateType",scmDataList[0].templateType);
                    var percentNewAwards = (component.get("v.gainedList").length/component.get("v.totalLineItems"))*100;
                    console.log('Gained list length: '+component.get("v.gainedList").length);
                    console.log('percentNewAwards: '+percentNewAwards);
                    component.set("v.categoryTotals.percentNewAwards", percentNewAwards);
                }              
                component.set("v.scmData", scmDataList);
                component.set("v.isSpinnerLoad", false);
            }else{
                component.set("v.isSpinnerLoad", false);
                console.log("Error "+JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);
        
        
    },
    convertArrayOfObjectsToCSV : function(component,objectRecords,template){
        // declare variables
        var csvStringResult, counter, keys,columnDivider, lineDivider;
        // check if "objectRecords" parameter is null, then return from function
        if (objectRecords == null || !objectRecords.length) {
            return null;
        }
        var bid = component.get("v.bidRecord");
        // store ,[comma] in columnDivider variabel for sparate CSV values and 
        // for start next line use '\n' [new line] in lineDivider varaible  
        columnDivider = ',';
        lineDivider =  '\n';
        csvStringResult = '';
        var selling_unit='1';
        var bidObj = component.get("v.bidRecord");
        var myMap = new Map();
        myMap.set("NDC", "ndc");
        myMap.set("SAP Number", "sapNumber");
        myMap.set("Product Name", "productName");
        myMap.set("Pkg Size", "pkgSize");
        myMap.set("Product Family", "productFamily");
        myMap.set("Case Pack", "casePack"); 
        myMap.set("MOQ", "moq"); 
        myMap.set("Compare To (Brand Name)", "comparetobrandName"); 
        myMap.set("Product Director", "productDirector");
        
        myMap.set("Old Throughput Cost", "oldthroughputCost");
        myMap.set("Throughput Cost Per Pack", "throughputCost");
        myMap.set("WAC", "wac");
        myMap.set("Doses", "doses");
        myMap.set("SSA Hit", "ssahit");
        myMap.set("LE Price Per Pack (Qtr)", "latestestimate");
        myMap.set("Current Bottles	", "monthlyDemand");
        //myMap.set("Current Doses", "currentDoses");
        myMap.set("Current Sales(Finance)", "currentsalesFinance");
        myMap.set("Current TP Margin $$$", "currentTPMargin");
        myMap.set("Current TP Margin %", "currentTPMarginprecent");
        myMap.set("Current ASP", "currentASPorDose");
        myMap.set("Proposed Bottles", "proposedBottles");
        // myMap.set("Proposed Doses", "proposedDoses");
        myMap.set("Proposed Sales", "proposedSales");
        myMap.set("Proposed TP Margin $$$", "proposedTPMargin");
        myMap.set("Proposed TP Margin %", "proposedTPMarginpercent");
        myMap.set("Proposed ASP", "proposedASPorDose");
        myMap.set("Budgeted ASP (Qtr)", "proposedBudgetASP");
        myMap.set("Proposed % to Budget", "ProposedpercenttoBudget");
        myMap.set("Difference Bottles", "differenceBottles");
        // myMap.set("Difference Doses", "differenceDoses");
        myMap.set("Volume Variance", "differenceVolume");
        myMap.set("Price variance", "differencePrice");
        myMap.set("Difference Sales", "differenceSales");
        myMap.set("Difference Margin", "differenceMargin");
        myMap.set("Difference ASP % Change", "differenceASPPercenttoChange");
        
        myMap.set("Bid Status", "bidStatus");
        myMap.set("Awarded Quantity", "awardedQty");
        myMap.set("Awarded Price", "awardedPrice");
        myMap.set("Award Position", "awardedPosition");
        myMap.set("Supply Effective Date", "supplyEffitiveDate");
        myMap.set("Price Effective Date", "priceEffitiveDate");
        
        myMap.set("Comm. Exps %", "commercialExpression");
        myMap.set("Commercial Cost", "commercialCost");
        myMap.set("Profit Available For Distribution", "profitavailableDistribution");
        myMap.set("PS Partner 1", "psPartner");
        myMap.set("PS % -Partner 1", "pspartnerPercent");
        myMap.set("Profit Share To Partner 1", "profitsharetoPartner");
        myMap.set("PS Partner 2", "psPartnertwo");
        myMap.set("PS % -Partner 2", "psPartnertwopercent");
        myMap.set("Profit Share To partner 2", "profitsharetoPartnertwo");
        myMap.set("Total Profit Share", "totalprofitShare");
        myMap.set("Total Value Profit Share", "valuetotalprofitShare");
        myMap.set("Royalty Partner Name", "royalitypartnerName");
        myMap.set("Royalty %", "royalitypercent");
        myMap.set("Royalty Per Unit", "royality");
        myMap.set("Total Value Royalty", "valueroyality");
        myMap.set("DRL Share Per Unit", "drlShare");
        myMap.set("Total DRL Share", "totaldrlShare");
        myMap.set("DRL Margin %", "drlMargin");
        myMap.set("Current Royalty", "currentRoyality");
        myMap.set("Current Profit Available For Distribution", "profitAvailability");
        myMap.set("Current Profit Share To Partner 1", "currentProfitPartnerOne");
        myMap.set("Current Profit Share To Partner 2", "currentProfitPartnerTwo");
        myMap.set("Current DRL Share", "currentDRLShare");
        myMap.set("DRL Share Impact ", "drlShareImpact");
        myMap.set("TP/GM Impact Before PS + SSA Hit", "annualizedTPImpact");
        myMap.set("TP/GM Impact After PS + SSA Hit", "annualizedGMImpact");
        csvStringResult += Array.from(myMap.keys()).join(columnDivider);
        csvStringResult += lineDivider;
        //new logic start 
        for(var i=0; i < objectRecords.length; i++){  
            counter = 0;
            for (let [key, value] of myMap) {
                if(counter > 0){ 
                    csvStringResult += columnDivider; 
                }
                //console.log(JSON.stringify(objectRecords[i]));
                if(value=='Phoenix_Product__r.Name'){
                    csvStringResult += '"'+ objectRecords[i]["Phoenix_Product__r"]["Name"]+'"';
                }
                else if(value=='Phoenix_Proposed_Direct_Selling_Unit__c'){
                    csvStringResult += '"'+selling_unit+'"';
                }
                    else if(value == 'throughputCost'){
                        var throughputCost = objectRecords[i]['throughputCost'];
                        // console.log("throughputCost--->"+throughputCost);
                        if(throughputCost != null){
                            var rounde_throughputCost=Math.round((throughputCost ) * 100) / 100
                            csvStringResult += '"'+rounde_throughputCost+'"';
                        }else{
                            csvStringResult += '"'+''+'"';
                        }      
                    }
                        else if(value == 'latestestimate'){
                            var latestEsimate = objectRecords[i]['latestestimate'];
                            // console.log("latest estimate--->"+latestEsimate);
                            if(latestEsimate != null){
                                var roundeEstimate=Math.round((latestEsimate ) * 100) / 100
                                csvStringResult += '"'+roundeEstimate+'"';
                            }else{
                                csvStringResult += '"'+''+'"';
                            }
                            
                        }
                            else if(value == 'commercialCost' ){
                                var commercialCost = objectRecords[i]['commercialCost'];
                                // console.log("commercialCost--->"+commercialCost);
                                if(commercialCost != null){
                                    var roundecc=Math.round((commercialCost ) * 100) / 100
                                    csvStringResult += '"'+roundecc+'"';
                                }
                                else{
                                    csvStringResult += '"'+''+'"';
                                }
                            }
                                else if(value == 'profitavailableDistribution'){
                                    var profitavailableDistribution = objectRecords[i]['profitavailableDistribution'];
                                    // console.log("profitavailableDistribution--->"+profitavailableDistribution);
                                    if(profitavailableDistribution != null){
                                        var roundepafd=Math.round((profitavailableDistribution ) * 100) / 100
                                        csvStringResult += '"'+roundepafd+'"';
                                    }
                                    else{
                                        csvStringResult += '"'+''+'"';
                                    }
                                }
                                    else if(value =='profitsharetoPartner'){
                                        var profitsharetoPartner = objectRecords[i]['profitsharetoPartner'];
                                        // console.log("profitsharetoPartner--->"+profitsharetoPartner);
                                        if(profitsharetoPartner != null){
                                            var roundepstp=Math.round((profitsharetoPartner ) * 100) / 100
                                            csvStringResult += '"'+roundepstp+'"';  
                                        }
                                        else{
                                            csvStringResult += '"'+''+'"';
                                        }
                                    }
                                        else if(value =='profitsharetoPartner'){
                                            var profitsharetoPartner = objectRecords[i]['profitsharetoPartner'];
                                            // console.log("profitsharetoPartner--->"+profitsharetoPartner);
                                            if(profitsharetoPartner != null){
                                                var roundepstp=Math.round((profitsharetoPartner ) * 100) / 100
                                                csvStringResult += '"'+roundepstp+'"'; 
                                            }
                                            else{
                                                csvStringResult += '"'+''+'"';
                                            }
                                        }
                                            else if(value =='profitsharetoPartnertwo'){
                                                var profitsharetoPartnertwo = objectRecords[i]['profitsharetoPartnertwo'];
                                                // console.log("profitsharetoPartnertwo--->"+profitsharetoPartnertwo);
                                                if(profitsharetoPartnertwo != null){
                                                    var roundepstpt=Math.round((profitsharetoPartnertwo ) * 100) / 100
                                                    csvStringResult += '"'+roundepstpt+'"'; 
                                                }
                                                else{
                                                    csvStringResult += '"'+''+'"';
                                                }
                                            }
                /*  else if(value == 'drlMargin'){
                    var drlMarginper = objectRecords[i]['drlMargin'];
                   console.log("drlMarginper--->"+drlMarginper);
                    var roundedrlm=Math.round((drlMarginper ) * 100) / 100
                    csvStringResult += '"'+roundedrlm+'"';     
                }*/
                                                else if(value == 'currentRoyality'){
                                                    var currentRoyality = objectRecords[i]['currentRoyality'];
                                                    // console.log("currentRoyality--->"+currentRoyality);
                                                    if(currentRoyality != null){
                                                        var roundecr=Math.round((currentRoyality ) * 100) / 100
                                                        csvStringResult += '"'+roundecr+'"';   
                                                    }
                                                    else{
                                                        csvStringResult += '"'+''+'"';
                                                    }
                                                }
                                                    else if(value == 'profitAvailability'){
                                                        var profitAvailability = objectRecords[i]['profitAvailability'];
                                                        // console.log("profitAvailability--->"+profitAvailability);
                                                        if(profitAvailability != null){
                                                            var roundepad=Math.round((profitAvailability )* 100) / 100
                                                            // var roundepad=Number(Math.round(profitAvailability+ "e2")+"e-2")
                                                            csvStringResult += '"'+roundepad+'"'; 
                                                        }
                                                        else{
                                                            csvStringResult += '"'+''+'"';
                                                        }
                                                    }
                                                        else if (value =='currentProfitPartnerOne'){
                                                            var currentProfitPartnerOne = objectRecords[i]['currentProfitPartnerOne'];
                                                            // console.log("currentProfitPartnerOne--->"+currentProfitPartnerOne);
                                                            if(currentProfitPartnerOne != null){
                                                                var roundecpstp=Math.round((currentProfitPartnerOne ) * 100) / 100
                                                                csvStringResult += '"'+roundecpstp+'"';
                                                            }
                                                            else{
                                                                csvStringResult += '"'+''+'"';
                                                            }
                                                        }
                                                            else if (value =='currentProfitPartnerTwo'){
                                                                var currentProfitPartnerTwo = objectRecords[i]['currentProfitPartnerTwo'];
                                                                // console.log("currentProfitPartnerTwo--->"+currentProfitPartnerTwo);
                                                                if(currentProfitPartnerTwo != null){
                                                                    var roundecpspt=Math.round((currentProfitPartnerTwo ) * 100) / 100
                                                                    csvStringResult += '"'+roundecpspt+'"'; 
                                                                }
                                                                else{
                                                                    csvStringResult += '"'+''+'"';
                                                                }
                                                            }
                                                                else if(value == 'currentDRLShare'){
                                                                    var currentDRLShare = objectRecords[i]['currentDRLShare'];
                                                                    // console.log("currentDRLShare--->"+currentDRLShare);
                                                                    if(currentDRLShare != null){
                                                                        var roundecdrls=Math.round((currentDRLShare ) * 100) / 100
                                                                        csvStringResult += '"'+roundecdrls+'"';   
                                                                    }
                                                                    else{
                                                                        csvStringResult += '"'+''+'"';
                                                                    }
                                                                }
                                                                    else if(value == 'totalprofitShare'){
                                                                        var totalprofitShare=objectRecords[i]['totalprofitShare'];
                                                                        //console.log("totalprofitShare--->"+totalprofitShare);
                                                                        if(totalprofitShare != null){
                                                                            var roundetps=Math.round(totalprofitShare )
                                                                            csvStringResult += '"'+roundetps+'"';
                                                                        }
                                                                        else{
                                                                            csvStringResult += '"'+''+'"';
                                                                        }
                                                                    }
                                                                        else if(value == 'valuetotalprofitShare'){
                                                                            var valuetotalprofitShare=objectRecords[i]['valuetotalprofitShare'];
                                                                            //console.log("valuetotalprofitShare--->"+valuetotalprofitShare);
                                                                            if(valuetotalprofitShare != null){
                                                                                var roundevtps=Math.round(valuetotalprofitShare )
                                                                                csvStringResult += '"'+roundevtps+'"';   
                                                                            }
                                                                            else{
                                                                                csvStringResult += '"'+''+'"';
                                                                            }
                                                                        }
                                                                            else if(value == 'royality'){
                                                                                var royality=objectRecords[i]['royality'];
                                                                                //console.log("royality--->"+royality);
                                                                                if(royality != null){
                                                                                    var rounderoyality=Math.round((royality )* 100) / 100
                                                                                    csvStringResult += '"'+rounderoyality+'"';
                                                                                }
                                                                                else{
                                                                                    csvStringResult += '"'+''+'"';
                                                                                }
                                                                            }
                
                                                                                else if(value == 'valueroyality'){
                                                                                    var valueroyality = objectRecords[i]['valueroyality'];
                                                                                    // console.log("valueroyality--->"+valueroyality);
                                                                                    if(valueroyality != null){
                                                                                        var roundetvr=Math.round(valueroyality )
                                                                                        csvStringResult += '"'+roundetvr+'"';  
                                                                                    }
                                                                                    else{
                                                                                        csvStringResult += '"'+''+'"';
                                                                                    }
                                                                                }
                                                                                    else if( value == 'drlShare'){
                                                                                        var drlShare = objectRecords[i]['drlShare'];
                                                                                        // console.log("valueroyality--->"+valueroyality);
                                                                                        if(drlShare != null){
                                                                                            var roundedrlShare=Math.round((drlShare )* 100) / 100
                                                                                            csvStringResult += '"'+roundedrlShare+'"';  
                                                                                        }
                                                                                        else{
                                                                                            csvStringResult += '"'+''+'"';
                                                                                        }
                                                                                    }
                                                                                        else if( value == 'totaldrlShare'){
                                                                                            var totaldrlShare = objectRecords[i]['totaldrlShare'];
                                                                                            // console.log("totaldrlShare--->"+totaldrlShare);
                                                                                            if(totaldrlShare != null){
                                                                                                var roundetds=Math.round(totaldrlShare )
                                                                                                csvStringResult += '"'+roundetds+'"'; 
                                                                                            }
                                                                                            else{
                                                                                                csvStringResult += '"'+''+'"';
                                                                                            }
                                                                                        }
                                                                                            else if(value == 'drlShareImpact'){
                                                                                                var drlShareImpact = objectRecords[i]['drlShareImpact'];
                                                                                                // console.log("drlShareImpact--->"+drlShareImpact);
                                                                                                if(drlShareImpact != null){
                                                                                                    var roundedsi=Math.round(drlShareImpact )
                                                                                                    csvStringResult += '"'+roundedsi+'"';  
                                                                                                }
                                                                                                else{
                                                                                                    csvStringResult += '"'+''+'"';
                                                                                                }
                                                                                            }
                                                                                                else if(value == 'annualizedTPImpact'){
                                                                                                    var annualizedTPImpact = objectRecords[i]['annualizedTPImpact'];
                                                                                                    // console.log("annualizedTPImpact--->"+annualizedTPImpact);
                                                                                                    if(annualizedTPImpact != null){
                                                                                                        var roundeatpi=Math.round(annualizedTPImpact )
                                                                                                        csvStringResult += '"'+roundeatpi+'"';
                                                                                                    }
                                                                                                    else{
                                                                                                        csvStringResult += '"'+''+'"';
                                                                                                    }
                                                                                                }
                                                                                                    else if(value == 'annualizedGMImpact'){
                                                                                                        var annualizedGMImpact = objectRecords[i]['annualizedGMImpact'];
                                                                                                        // console.log("annualizedGMImpact--->"+annualizedGMImpact);
                                                                                                        if(annualizedGMImpact != null){
                                                                                                            var roundeagmi=Math.round(annualizedGMImpact )
                                                                                                            csvStringResult += '"'+roundeagmi+'"';
                                                                                                        }
                                                                                                        else{
                                                                                                            csvStringResult += '"'+''+'"';
                                                                                                        }    
                                                                                                    }
                                                                                                        else if(value == 'differenceMargin'){
                                                                                                            var differenceMargin = objectRecords[i]['differenceMargin'];
                                                                                                            // console.log("differenceMargin--->"+differenceMargin);
                                                                                                            if(differenceMargin != null){
                                                                                                                var roundedifferenceMargin=Math.round(differenceMargin )
                                                                                                                csvStringResult += '"'+roundedifferenceMargin+'"';
                                                                                                            }
                                                                                                            else{
                                                                                                                csvStringResult += '"'+''+'"';
                                                                                                            }    
                                                                                                        }
                                                                                                            else if(value=='proposedSales'){
                                                                                                                var differenceMargin = objectRecords[i]['proposedSales'];
                                                                                                                // console.log("differenceMargin--->"+differenceMargin);
                                                                                                                if(differenceMargin != null){
                                                                                                                    var roundedifferenceMargin=Math.round(differenceMargin)
                                                                                                                    csvStringResult += '"'+roundedifferenceMargin+'"';
                                                                                                                }
                                                                                                                else{
                                                                                                                    csvStringResult += '"'+''+'"';
                                                                                                                }    
                                                                                                            }
                                                                                                                else if(objectRecords[i][value]==undefined){
                                                                                                                    csvStringResult += '"'+''+'"';
                                                                                                                }
                                                                                                                    else{
                                                                                                                        csvStringResult += '"'+ objectRecords[i][value]+'"';
                                                                                                                    }
                
                counter++;
            }
            csvStringResult += lineDivider;
        }
        //new logic end 
        
        return csvStringResult;     
    },
})