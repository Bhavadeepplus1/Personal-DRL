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
                component.set("v.customerMap", null);
                component.set("v.customerIds", null);
                component.set("v.onLoad", false);
                var responseWrapper = response.getReturnValue();
                var scmDataList = responseWrapper.scmWrapperList;
                var actualSales = responseWrapper.actualSales;
                component.set("v.actualSales", actualSales);
                component.set("v.totalBids", responseWrapper.bids);
                component.set("v.openLineItemsCount", responseWrapper.openLineItemsCount);
                component.set("v.duration", responseWrapper.startDate+' - '+responseWrapper.endDate);
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
                var previousTotal = 0; var currentTotal = 0;
                if(scmDataList.length>0){
                    var totalAnnualImpactBG = 0; var totalBusinessImpactBG = 0; var totalPreviousQtyBG = 0; var totalQtyBG = 0; var totalSCMApprovedQtyBG = 0; var currentTotalBG = 0; var previousTotalBG = 0; var previousTPTBG = 0; var currentTPTBG = 0; var priceVarianceBG = 0; var volumeVarianceBG = 0; var totalVarianceBG = 0; var tptVarianceBG = 0;
                    var totalAnnualImpactBGG = 0; var totalBusinessImpactBGG = 0; var totalPreviousQtyBGG = 0; var totalQtyBGG = 0; var totalSCMApprovedQtyBGG = 0; var currentTotalBGG = 0; var previousTotalBGG = 0; var previousTPTBGG = 0; var currentTPTBGG = 0; var priceVarianceBGG = 0; var volumeVarianceBGG = 0; var totalVarianceBGG = 0; var tptVarianceBGG = 0;
                    var totalAnnualImpactBGL = 0; var totalBusinessImpactBGL = 0; var totalPreviousQtyBGL = 0; var totalQtyBGL = 0; var totalSCMApprovedQtyBGL = 0; var currentTotalBGL = 0; var previousTotalBGL = 0; var previousTPTBGL = 0; var currentTPTBGL = 0; var priceVarianceBGL = 0; var volumeVarianceBGL = 0; var totalVarianceBGL = 0; var tptVarianceBGL = 0;
                    var totalAnnualImpactNE = 0; var totalBusinessImpactNE = 0; var totalPreviousQtyNE = 0; var totalQtyNE = 0; var totalSCMApprovedQtyNE = 0; var currentTotalNE = 0; var previousTotalNE = 0; var previousTPTNE = 0; var currentTPTNE = 0; var priceVarianceNE = 0; var volumeVarianceNE = 0; var totalVarianceNE = 0; var tptVarianceNE = 0;
                    var totalAnnualImpactOS = 0; var totalBusinessImpactOS = 0; var totalPreviousQtyOS = 0; var totalQtyOS = 0; var totalSCMApprovedQtyOS = 0; var currentTotalOS = 0; var previousTotalOS = 0; var previousTPTOS = 0; var currentTPTOS = 0; var priceVarianceOS = 0; var volumeVarianceOS = 0; var totalVarianceOS = 0; var tptVarianceOS = 0;
                    var totalAnnualImpactBL = 0; var totalBusinessImpactBL = 0; var currentTotalBL = 0; var previousTotalBL = 0; var tptVariance =0; var priceVariance =0; var volumeVariance =0;var currentTotalBL = 0; var previousTotalBL = 0; var previousTPTBL = 0; var currentTPTBL = 0; var priceVarianceBL = 0; var volumeVarianceBL = 0; var totalVarianceBL = 0; var tptVarianceBL = 0;
                    var totalPreviousQtyBLRFP = 0; var totalQtyBLRFP = 0; var currentTotalBLRFP = 0; var previousTotalBLRFP = 0; var tptVarianceBLRFP =0; var priceVarianceBLRFP =0; var volumeVarianceBLRFP =0;var previousTPTBLRFP = 0; var currentTPTBLRFP = 0; var priceVarianceBLRFP = 0; var volumeVarianceBLRFP = 0; var totalVarianceBLRFP = 0; var tptVarianceBLRFP = 0;
                    var totalAnnualImpactBLRemovals = 0; var totalPreviousQtyBL=0; var totalQtyBL=0; var totalSCMApprovedQtyBL=0; var totalBusinessImpactBLRemovals = 0;var totalAnnualImpactBLDiscontinuation = 0; var totalBusinessImpactBLDiscontinuation = 0;var totalAnnualImpactBLRFP = 0; var totalBusinessImpactBLRFP = 0;
                    let removalsDataFormattingObjProductRemovals = new Map(); var totalCurrentFiscalImpact = 0; var totalProposedFiscalImpact = 0; var totalCurrentFiscalQuarterImpact = 0; var totalProposedFiscalQuarterImpact = 0; var totalCurrentTPTFiscalImpact = 0; var totalProposedTPTFiscalImpact = 0; var totalCurrentTPTFiscalQuarterImpact = 0; var totalProposedTPTFiscalQuarterImpact = 0;
                    let removalsDataFormattingObjProductDiscontinuation = new Map(); let removalsDataFormattingObjRFP = new Map(); let removalsDataFormattingObj = new Map();
                    for(var i=0; i<scmDataList.length; i++){
                        if(scmDataList[i].previousQty == null){
                            scmDataList[i].previousQty = 0;
                        }
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
                        } else if(scmDataList[i].customerResponseDate){
                            d = new Date(scmDataList[i].customerResponseDate);
                            scmDataList[i].dateUsed = 'CRD';
                            scmDataList[i].date = 'Customer Response Date';
                        } else if(scmDataList[i].bidSubmittedDate){
                            d = new Date(scmDataList[i].bidSubmittedDate);
                            scmDataList[i].dateUsed = 'BSD';
                            scmDataList[i].date = 'Bid Submitted Date';
                        }
                        scmDataList[i].showTPTDiff = true;
                        scmDataList[i].showTotalVariance = true;
                        if(d != null && !isNaN(d)){
                            var effectiveDateFiscalYear = '';
                            var currentDate = d;
                            var daysLeft = 0; var daysRemainingInQuarter = 0;
                            // Check if the currentDate is a valid Date object
                            if (currentDate instanceof Date && !isNaN(currentDate)) {
                                var fiscalYearStartMonth = 4;
                                var fiscalYear = currentDate.getFullYear();
                                var currentQuarter = Math.floor((currentDate.getMonth() + 1 - fiscalYearStartMonth) / 3) + 1;
                                var lastDayOfQuarter = new Date(fiscalYear, fiscalYearStartMonth - 1 + currentQuarter * 3, 0);
                                daysLeft = Math.ceil((lastDayOfQuarter - currentDate) / (1000 * 60 * 60 * 24));
                                daysRemainingInQuarter = (daysLeft/365)*12;
                            } else {
                                console.error("Invalid date format");
                            }
                            
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
                            days_difference = parseFloat(days_difference).toFixed(2);
                            scmDataList[i].daysDifference = days_difference;
                            scmDataList[i].impactedTitle = '((Fiscal Year End Date - '+scmDataList[i].date+')/365)*12  '+'[(('+days_difference+')/365)*12]';
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
                            scmDataList[i].monthsRemaining = monthsRemaining;
                            if(scmDataList[i].previousContractTotal == 0 && scmDataList[i].businessCategory == 'Business Lost' && (scmDataList[i].bidType == 'Price Change' || scmDataList[i].bidType == 'OTC Price Change')){
                                scmDataList[i].businessCategory = 'No Effect';
                            }
                            var currentQuarterImpact = 0;
                            currentQuarterImpact = (annualImpact * daysRemainingInQuarter)/12;
                            scmDataList[i].currentQuarterImpact = currentQuarterImpact;
                            scmDataList[i].annualTitle = 'Current Contract Total - Previous Contract Total  ('+scmDataList[i].currentContractTotal+' - '+(isNaN(scmDataList[i].previousContractTotal)?0:scmDataList[i].previousContractTotal)+')'; 
                            scmDataList[i].monthsRemaining = monthsRemaining;
                            if(scmDataList[i].businessCategory == 'No Effect'){
                                annualImpact = 0;
                                scmDataList[i].annualTitle = '';
                                businessImpact = 0;
                                scmDataList[i].previousContractTotal = 0;
                            }
                            scmDataList[i].businessImpact = businessImpact;
                            scmDataList[i].annualImpact = annualImpact; 
                            if(scmDataList[i].businessCategory == 'Business Gained'){
                                //scmDataList[i].showTPTDiff = false;
                                //scmDataList[i].showTotalVariance = false;
                                scmDataList[i].previousIndirectPrice = null;
                                scmDataList[i].previousDeadnet = null;
                                scmDataList[i].previousQty = null;
                                scmDataList[i].category = 'Business Gained';
                                if(scmDataList[i].bidType != 'Good Dated OTB' && scmDataList[i].bidType != 'Short Dated OTB' && scmDataList[i].bidType != 'OTC OTB Good Dated' && scmDataList[i].bidType != 'OTC OTB Short Dated'){
                                    totalCurrentFiscalImpact +=(scmDataList[i].previousContractTotal * monthsRemaining)/12;
                                    totalProposedFiscalImpact += (scmDataList[i].currentContractTotal * monthsRemaining)/12;
                                    totalCurrentFiscalQuarterImpact +=(scmDataList[i].previousContractTotal * daysRemainingInQuarter)/12;
                                    totalProposedFiscalQuarterImpact += (scmDataList[i].currentContractTotal * daysRemainingInQuarter)/12;
                                    totalCurrentTPTFiscalImpact +=(scmDataList[i].previousTPT * monthsRemaining)/12;
                                    totalProposedTPTFiscalImpact += (scmDataList[i].currentTPT * monthsRemaining)/12;
                                    totalCurrentTPTFiscalQuarterImpact +=(scmDataList[i].previousTPT * daysRemainingInQuarter)/12;
                                    totalProposedTPTFiscalQuarterImpact += (scmDataList[i].currentTPT * daysRemainingInQuarter)/12;   
                                }
                                gainedList.push(scmDataList[i]);
                                totalAnnualImpactBG += ((isNaN(annualImpact) ? 0 : annualImpact));
                                totalBusinessImpactBG += ((isNaN(businessImpact) ? 0 : businessImpact));
                                totalPreviousQtyBG += ((isNaN(scmDataList[i].previousQty) ? 0 : parseFloat(scmDataList[i].previousQty)));
                                totalQtyBG += ((isNaN(scmDataList[i].awardedQty) ? 0 : parseFloat(scmDataList[i].awardedQty)));
                                totalSCMApprovedQtyBG += ((isNaN(scmDataList[i].proposedBottles) ? 0 : parseFloat(scmDataList[i].proposedBottles)));
                                previousTotalBG += ((isNaN(scmDataList[i].previousContractTotal) ? 0 : parseFloat(scmDataList[i].previousContractTotal)));
                                currentTotalBG += ((isNaN(scmDataList[i].currentContractTotal) ? 0 : parseFloat(scmDataList[i].currentContractTotal)));   
                                currentTPTBG += ((isNaN(scmDataList[i].currentTPT) ? 0 : parseFloat(scmDataList[i].currentTPT)));
                                previousTPTBG += ((isNaN(scmDataList[i].previousTPT) ? 0 : parseFloat(scmDataList[i].previousTPT)));
                                priceVarianceBG += ((isNaN(scmDataList[i].priceVariance) ? 0 : parseFloat(scmDataList[i].priceVariance)));
                                volumeVarianceBG += ((isNaN(scmDataList[i].volumeVariance) ? 0 : parseFloat(scmDataList[i].volumeVariance)));
                            }
                            else if(scmDataList[i].businessCategory == 'Business Retained'){
                                totalCurrentFiscalImpact +=(scmDataList[i].previousContractTotal * monthsRemaining)/12;
                                totalProposedFiscalImpact += (scmDataList[i].currentContractTotal * monthsRemaining)/12;
                                totalCurrentFiscalQuarterImpact +=(scmDataList[i].previousContractTotal * daysRemainingInQuarter)/12;
                                totalProposedFiscalQuarterImpact += (scmDataList[i].currentContractTotal * daysRemainingInQuarter)/12;
                                totalCurrentTPTFiscalImpact +=(scmDataList[i].previousTPT * monthsRemaining)/12;
                                totalProposedTPTFiscalImpact += (scmDataList[i].currentTPT * monthsRemaining)/12;
                                totalCurrentTPTFiscalQuarterImpact +=(scmDataList[i].previousTPT * daysRemainingInQuarter)/12;
                                totalProposedTPTFiscalQuarterImpact += (scmDataList[i].currentTPT * daysRemainingInQuarter)/12;
                                if(scmDataList[i].businessImpact > 0){
                                    scmDataList[i].category = 'Business Retained with Gains';
                                    retainedGainList.push(scmDataList[i]);   
                                    totalAnnualImpactBGG += ((isNaN(annualImpact) ? 0 : annualImpact));
                                    totalBusinessImpactBGG += ((isNaN(businessImpact) ? 0 : businessImpact));
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
                                    totalAnnualImpactBGL += ((isNaN(annualImpact) ? 0 : annualImpact));
                                    totalBusinessImpactBGL += ((isNaN(businessImpact) ? 0 : businessImpact));
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
                                    if(scmDataList[i].bidRecord.Phoenix_Bid_Type__c == 'RFP Bids' || scmDataList[i].bidRecord.Phoenix_Bid_Type__c == 'Price Change' || scmDataList[i].bidRecord.Phoenix_Bid_Type__c == 'OTC Price Change'){
                                        totalCurrentFiscalImpact +=(scmDataList[i].previousContractTotal * monthsRemaining)/12;
                                        totalCurrentFiscalQuarterImpact +=(scmDataList[i].previousContractTotal * daysRemainingInQuarter)/12;
                                        totalCurrentTPTFiscalImpact +=(scmDataList[i].previousTPT * monthsRemaining)/12;
                                        totalCurrentTPTFiscalQuarterImpact +=(scmDataList[i].previousTPT * daysRemainingInQuarter)/12;
                                        totalAnnualImpactBL += ((isNaN(scmDataList[i].annualImpact) ? 0 : scmDataList[i].annualImpact));
                                        totalBusinessImpactBL += ((isNaN(scmDataList[i].businessImpact) ? 0 : scmDataList[i].businessImpact));
                                        totalAnnualImpactBLRFP += ((isNaN(scmDataList[i].annualImpact) ? 0 : scmDataList[i].annualImpact));
                                        totalBusinessImpactBLRFP += ((isNaN(scmDataList[i].businessImpact) ? 0 : scmDataList[i].businessImpact));
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
                                    } else if(scmDataList[i].bidRecord.Phoenix_Bid_Type__c == 'Price Change' || scmDataList[i].bidRecord.Phoenix_Bid_Type__c == 'OTC Price Change'){
                                        totalCurrentFiscalImpact +=(scmDataList[i].previousContractTotal * monthsRemaining)/12;
                                        totalCurrentFiscalQuarterImpact +=(scmDataList[i].previousContractTotal * daysRemainingInQuarter)/12;
                                        totalCurrentTPTFiscalImpact +=(scmDataList[i].previousTPT * monthsRemaining)/12;
                                        totalCurrentTPTFiscalQuarterImpact +=(scmDataList[i].previousTPT * daysRemainingInQuarter)/12;
                                        totalAnnualImpactBL += ((isNaN(scmDataList[i].annualImpact) ? 0 : scmDataList[i].annualImpact));
                                        totalBusinessImpactBL += ((isNaN(scmDataList[i].businessImpact) ? 0 : scmDataList[i].businessImpact));
                                        totalPreviousQtyBL += ((isNaN(scmDataList[i].previousQty) ? 0 : parseFloat(scmDataList[i].previousQty)));
                                        totalQtyBL += ((isNaN(scmDataList[i].awardedQty) ? 0 : parseFloat(scmDataList[i].awardedQty)));
                                        totalSCMApprovedQtyBL += ((isNaN(scmDataList[i].proposedBottles) ? 0 : parseFloat(scmDataList[i].proposedBottles)));
                                        previousTotalBL += ((isNaN(scmDataList[i].previousContractTotal) ? 0 : parseFloat(scmDataList[i].previousContractTotal)));
                                        currentTotalBL += ((isNaN(scmDataList[i].currentContractTotal) ? 0 : parseFloat(scmDataList[i].currentContractTotal)));
                                        currentTPTBL += ((isNaN(scmDataList[i].currentTPT) ? 0 : parseFloat(scmDataList[i].currentTPT)));
                                        previousTPTBL += ((isNaN(scmDataList[i].previousTPT) ? 0 : parseFloat(scmDataList[i].previousTPT)));
                                        priceVarianceBL += ((isNaN(scmDataList[i].priceVariance) ? 0 : parseFloat(scmDataList[i].priceVariance)));
                                        volumeVarianceBL += ((isNaN(scmDataList[i].volumeVariance) ? 0 : parseFloat(scmDataList[i].volumeVariance)));
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
                                    } 
                                    else {
                                        var listOfProducts = removalsDataFormattingObj[scmDataList[i].customer];
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
                                            previousTotalBL += scmDataList[i].previousContractTotal;
                                            currentTotalBL += 0;
                                            removalsDataFormattingObj[scmDataList[i].customer] = listOfProducts;                                    
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
                                            previousTotalBL += scmDataList[i].previousContractTotal;
                                            currentTotalBL += 0;
                                            removalsDataFormattingObj[scmDataList[i].customer] = listOfProducts;                                    
                                        }
                                        totalCurrentFiscalImpact += (scmDataList[i].previousContractTotal * monthsRemaining)/12;
                                        totalCurrentFiscalQuarterImpact +=(scmDataList[i].previousContractTotal * daysRemainingInQuarter)/12;
                                        scmDataList[i].category = 'Business Lost';
                                        scmDataList[i].monthsRemaining = monthsRemaining;
                                        lossList.push(scmDataList[i]);
                                    }
                                } 
                                    else if(scmDataList[i].businessCategory == 'No Effect'){
                                        scmDataList[i].currentContractTotal = isNaN(scmDataList[i].awardedQty * scmDataList[i].currentDeadnet)? 0 :(scmDataList[i].awardedQty * scmDataList[i].currentDeadnet);
                                        scmDataList[i].previousContractTotal = isNaN(scmDataList[i].previousQty * scmDataList[i].previousDeadnet)? 0 :(scmDataList[i].previousQty * scmDataList[i].previousDeadnet);
                                        scmDataList[i].contractTotalCurrentTitle = 'Awarded Qty * Current Deadnet ('+scmDataList[i].awardedQty+'*'+scmDataList[i].currentDeadnet+')';
                                        scmDataList[i].contractTotalPreviousTitle = 'Previous Qty * Previous Deadnet ('+scmDataList[i].previousQty+'*'+((scmDataList[i].previousDeadnet != undefined)?scmDataList[i].previousDeadnet:0)+')';
                                        //annualImpact = (scmDataList[i].currentContractTotal-(isNaN(scmDataList[i].previousContractTotal)?0:scmDataList[i].previousContractTotal));
                                        annualImpact = 0;
                                        businessImpact = 0;
                                        scmDataList[i].businessImpact = 0;
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
                                if(scmDataList[i].bidRecord.Phoenix_Bid_Type__c == 'RFP Bids' || scmDataList[i].bidRecord.Phoenix_Bid_Type__c == 'Price Change' || scmDataList[i].bidRecord.Phoenix_Bid_Type__c == 'OTC Price Change'){
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
                                    totalCurrentFiscalQuarterImpact +=(scmDataList[i].previousContractTotal * daysRemainingInQuarter)/12;
                                    lossList.push(scmDataList[i]);
                                    RFPLossList.push(scmDataList[i]);   
                                } else if(scmDataList[i].bidRecord.Phoenix_Bid_Type__c == 'RFP Bids' || scmDataList[i].bidRecord.Phoenix_Bid_Type__c == 'Price Change' || scmDataList[i].bidRecord.Phoenix_Bid_Type__c == 'OTC Price Change'){
                                    scmDataList[i].currentContractTotal = isNaN(scmDataList[i].awardedQty * scmDataList[i].currentDeadnet)? 0 :(scmDataList[i].awardedQty * scmDataList[i].currentDeadnet);
                                    scmDataList[i].previousContractTotal = isNaN(scmDataList[i].previousQty * scmDataList[i].previousDeadnet)? 0 :(scmDataList[i].previousQty * scmDataList[i].previousDeadnet);
                                    scmDataList[i].contractTotalCurrentTitle = 'Awarded Qty * Current Deadnet ('+scmDataList[i].awardedQty+'*'+scmDataList[i].currentDeadnet+')';
                                    scmDataList[i].contractTotalPreviousTitle = 'Previous Qty * Previous Deadnet ('+scmDataList[i].previousQty+'*'+((scmDataList[i].previousDeadnet != undefined)?scmDataList[i].previousDeadnet:0)+')';
                                    annualImpact = (scmDataList[i].currentContractTotal-(isNaN(scmDataList[i].previousContractTotal)?0:scmDataList[i].previousContractTotal));
                                    scmDataList[i].businessTitle = '(Annual Impact * Impacted Months)/12 [('+annualImpact+' * '+monthsRemaining.toFixed(2)+')/12]';
                                    scmDataList[i].annualImpact = parseFloat(annualImpact);
                                    previousTotalBL += ((isNaN(scmDataList[i].previousContractTotal) ? 0 : scmDataList[i].previousContractTotal));
                                    currentTotalBL += ((isNaN(scmDataList[i].currentContractTotal) ? 0 : scmDataList[i].currentContractTotal));
                                    totalAnnualImpactBL += ((isNaN(annualImpact) ? 0 : parseFloat(annualImpact)));
                                    totalBusinessImpactBL += ((isNaN(businessImpact) ? 0 : parseFloat(businessImpact)));
                                    currentTPTBL += ((isNaN(scmDataList[i].currentTPT) ? 0 : scmDataList[i].currentTPT));
                                    previousTPTBL += ((isNaN(scmDataList[i].previousTPT) ? 0 : scmDataList[i].previousTPT));
                                    priceVarianceBL += ((isNaN(scmDataList[i].priceVariance) ? 0 : scmDataList[i].priceVariance));
                                    volumeVarianceBL += ((isNaN(scmDataList[i].volumeVariance) ? 0 : scmDataList[i].volumeVariance));
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
                                    totalCurrentFiscalQuarterImpact +=(scmDataList[i].previousContractTotal * daysRemainingInQuarter)/12;
                                    lossList.push(scmDataList[i]); 
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
                                    totalCurrentFiscalQuarterImpact +=(scmDataList[i].previousContractTotal * daysRemainingInQuarter)/12;
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
                                    totalCurrentFiscalQuarterImpact +=(scmDataList[i].previousContractTotal * daysRemainingInQuarter)/12;
                                    lossList.push(scmDataList[i]);
                                    discontinuationLossList.push(scmDataList[i]);
                                }
                            } else if(scmDataList[i].businessCategory == 'No Effect'){
                                scmDataList[i].currentContractTotal = isNaN(scmDataList[i].awardedQty * scmDataList[i].currentDeadnet)? 0 :(scmDataList[i].awardedQty * scmDataList[i].currentDeadnet);
                                scmDataList[i].previousContractTotal = isNaN(scmDataList[i].previousQty * scmDataList[i].previousDeadnet)? 0 :(scmDataList[i].previousQty * scmDataList[i].previousDeadnet);
                                scmDataList[i].contractTotalCurrentTitle = 'Awarded Qty * Current Deadnet ('+scmDataList[i].awardedQty+'*'+scmDataList[i].currentDeadnet+')';
                                scmDataList[i].contractTotalPreviousTitle = 'Previous Qty * Previous Deadnet ('+scmDataList[i].previousQty+'*'+((scmDataList[i].previousDeadnet != undefined)?scmDataList[i].previousDeadnet:0)+')';
                                //annualImpact = (scmDataList[i].currentContractTotal-(isNaN(scmDataList[i].previousContractTotal)?0:scmDataList[i].previousContractTotal));
                                annualImpact = 0;
                                businessImpact = 0;
                                scmDataList[i].businessImpact = 0;
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
                    
                    totalObj.totalCurrentFiscalQuarterImpact = parseFloat(totalCurrentFiscalQuarterImpact);
                    totalObj.totalProposedFiscalQuarterImpact = parseFloat(totalProposedFiscalQuarterImpact);
                    totalObj.salesFiscalQuarterVar = parseInt(totalProposedFiscalQuarterImpact-totalCurrentFiscalQuarterImpact);
                    totalObj.salesFiscalQuarterVarPer = parseFloat((totalObj.salesFiscalQuarterVar/totalObj.totalCurrentFiscalQuarterImpact)*100).toFixed(2);
                    
                    totalObj.totalCurrentTPTFiscalImpact = parseFloat(totalCurrentTPTFiscalImpact);
                    totalObj.totalProposedTPTFiscalImpact = parseFloat(totalProposedTPTFiscalImpact);
                    totalObj.tptFiscalVar = parseInt(totalProposedTPTFiscalImpact-totalCurrentTPTFiscalImpact);
                    totalObj.tptFiscalVarPer = parseFloat((totalObj.tptFiscalVar/totalObj.totalCurrentTPTFiscalImpact)*100).toFixed(2);
                    
                    totalObj.totalCurrentTPTFiscalQuarterImpact = parseFloat(totalCurrentTPTFiscalQuarterImpact);
                    totalObj.totalProposedTPTFiscalQuarterImpact = parseFloat(totalProposedTPTFiscalQuarterImpact);
                    totalObj.tptFiscalQuarterVar = parseInt(totalProposedTPTFiscalQuarterImpact-totalCurrentTPTFiscalQuarterImpact);
                    totalObj.tptFiscalQuarterVarPer = parseFloat((totalObj.tptFiscalQuarterVar/totalObj.totalCurrentTPTFiscalQuarterImpact)*100).toFixed(2);
                    
                    totalObj.awardedQtyChangesCount = volumeChangeList.length;
                    totalObj.deadnetChangesCount = priceChangeList.length;
                    totalObj.bothPriceAndVolumeChangesCount = bothList.length;
                    
                    totalObj.bothListRetainedWithGains = bothListRetainedWithGains.length;
                    totalObj.percentBothListRetainedWithGains = (totalObj.bothListRetainedWithGains/scmDataList.length)*100;
                    totalObj.bothListRetainedWithLoss = bothListRetainedWithLoss.length;
                    totalObj.percentBothListRetainedWithLoss = (totalObj.bothListRetainedWithLoss/scmDataList.length)*100;
                    
                    totalObj.priceChangeListRetainedWithGains = priceChangeListRetainedWithGains.length;
                    totalObj.percentPriceChangeListRetainedWithGains = (totalObj.priceChangeListRetainedWithGains/scmDataList.length)*100;
                    totalObj.priceChangeListRetainedWithLoss = priceChangeListRetainedWithLoss.length;
                    totalObj.percentPriceChangeListRetainedWithLoss = (totalObj.priceChangeListRetainedWithLoss/scmDataList.length)*100;
                    
                    totalObj.volumeChangeListRetainedWithGains = volumeChangeListRetainedWithGains.length;
                    totalObj.percentVolumeChangeListRetainedWithGains = (totalObj.volumeChangeListRetainedWithGains/scmDataList.length)*100;
                    totalObj.volumeChangeListRetainedWithLoss = volumeChangeListRetainedWithLoss.length;
                    totalObj.percentVolumeChangeListRetainedWithLoss = (totalObj.volumeChangeListRetainedWithLoss/scmDataList.length)*100;
                    
                    /*var totalAwards = (component.get("v.gainedList") != null ? component.get("v.gainedList").length : 0);
                    var percentNewAwards = (totalAwards/total)*100;
                    var percentLoss = (component.get("v.lossList").length/total)*100;
                    var percentNoEffects = (component.get("v.noEffectList").length/total)*100;
                    totalObj.totalAwards = totalAwards;
                    totalObj.percentNewAwards = percentNewAwards;
                    totalObj.percentLoss = percentLoss;
                    totalObj.percentNoEffects = percentNoEffects;*/
                    
                    totalObj.currentTotal = currentTotal;
                    totalObj.previousTotal = previousTotal;
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
                    totalObj.change = parseFloat((totalObj.totalCurrentTotal - totalObj.totalPreviousTotal));
                    console.log('previousTPTBG: '+previousTPTBG);
                    console.log('previousTPTBGG: '+previousTPTBGG);
                    console.log('previousTPTBGL: '+previousTPTBGL);
                    console.log('previousTPTBLRFP: '+previousTPTBLRFP);
                    console.log('currentTPTBG: '+currentTPTBG);
                    console.log('currentTPTBGG: '+currentTPTBGG);
                    console.log('currentTPTBGL: '+currentTPTBGL);
                    console.log('currentTPTBLRFP: '+currentTPTBLRFP);
                    totalObj.previousTPT = previousTPTBG + previousTPTBGG + previousTPTBGL + previousTPTBL;
                    totalObj.currentTPT = currentTPTBG + currentTPTBGG + currentTPTBGL + currentTPTBL;
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
                    component.set("v.totalSummary", totalObj);
                    //component.set("v.categoryTotals", totalObj);
                    
                    component.set("v.gainedList", []);
                    component.set("v.removalsLossList", []);
                    component.set("v.discontinuationLossList", []);
                    component.set("v.RFPLossList", []);
                    component.set("v.noEffectList", []);
                    
                    var currentTabId = component.get("v.currentTabId");
                    var gain = []; var lost = []; var open = []; var noEffect = [];
                    var customerMap = {}; var totalMap = {};
                    var totalFamilySummaryMap = {}; var totalPreviousQty = 0; var totalAwardedQty = 0; var totalPreviousTotal = 0; var totalCurrentTotal = 0;
                    var totalAnnualImpact = 0; var totalBusinessImpact = 0; var totalCurrentQuarterImpact = 0; var totalCurrentTPT = 0; var totalPreviousTPT = 0; var totalCurrentTPTPer = 0; var totalPreviousTPTPer = 0;
                    var totalPriceVariance = 0; var totalVolumeVariance = 0; var total = 0; var totalTPT = 0;
                    scmDataList.forEach(function(rec){
                        if(rec.businessCategory == 'Business Gained'){
                            gain.push(rec);
                        } else if(rec.businessCategory == 'Business Lost'){
                            lost.push(rec);
                        } else if(rec.businessCategory == 'Open Status'){
                            open.push(rec);
                        } else if(rec.businessCategory == 'No Effect'){
                            noEffect.push(rec);
                        }
						var customerName;
                        if(rec.bidRecord.hasOwnProperty('Phoenix_Customer__r')){
                            customerName = rec.bidRecord.Phoenix_Customer__r.Name;
                        } else if(rec.bidLineItem.hasOwnProperty('Phoenix_Customer__r')){
                            customerName = rec.bidLineItem.Phoenix_Customer__r.Name;
                        }
                        if(customerMap.hasOwnProperty(customerName)){
                            var customerRelatedList = customerMap[customerName];
                            customerRelatedList.push(rec);
                            customerMap[customerName] = customerRelatedList;                            
                        } else{
                            var customerRelatedList = [];
                            customerRelatedList.push(rec);
                            customerMap[customerName] = customerRelatedList;
                        }
                        if(customerMap != null){
                            var obj = {}; var previousContractTotal = 0; var currentContractTotal = 0; var annualImpact = 0; var businessImpact = 0; var currentQuarterImpact = 0;
                            var previousQty = 0; var awardedQty = 0; var previousTPT = 0; var currentTPT = 0; var priceVariance = 0; var volumeVariance = 0;
                            var totalVariance = 0; var totalTPTVariance= 0;
                            var customerKeys = Object.keys(customerMap);
                            for(var i=0; i<customerKeys.length; i++){
                                var relatedCustomerList = customerMap[customerKeys[i]];
                                for(var j=0; j<relatedCustomerList.length; j++){
                                    if((relatedCustomerList[j].bidType != 'RFP Bids' && (relatedCustomerList[j].bidStatus == 'Declined by Customer' || relatedCustomerList[j].bidStatus == 'DRL Rescinded' || relatedCustomerList[j].bidStatus == 'DRL submitting under New Bid Number')) || relatedCustomerList[j].businessCategory == 'No Effect'){
                                        
                                    }/* else if(relatedCustomerList[j].bidType == 'RFP Bids' && (relatedCustomerList[j].bidStatus == 'Declined by Customer' || relatedCustomerList[j].bidStatus == 'DRL Rescinded')){
                                        previousContractTotal -= (isNaN(relatedCustomerList[j].previousContractTotal) ? 0: relatedCustomerList[j].previousContractTotal);
                                        currentContractTotal -= (isNaN(relatedCustomerList[j].currentContractTotal) ? 0: relatedCustomerList[j].currentContractTotal);
                                        annualImpact -= (isNaN(relatedCustomerList[j].annualImpact) ? 0: relatedCustomerList[j].annualImpact);
                                        businessImpact -= (isNaN(relatedCustomerList[j].businessImpact) ? 0: relatedCustomerList[j].businessImpact);
                                        previousQty -= (isNaN(relatedCustomerList[j].previousQty) ? 0: relatedCustomerList[j].previousQty);
                                        awardedQty -= (isNaN(relatedCustomerList[j].awardedQty) ? 0: relatedCustomerList[j].awardedQty);
                                        previousTPT -= (isNaN(relatedCustomerList[j].previousTPT) ? 0: relatedCustomerList[j].previousTPT);
                                        currentTPT -= (isNaN(relatedCustomerList[j].currentTPT) ? 0: relatedCustomerList[j].currentTPT);
                                        priceVariance -= (isNaN(relatedCustomerList[j].priceVariance) ? 0: relatedCustomerList[j].priceVariance);
                                        volumeVariance -= (isNaN(relatedCustomerList[j].volumeVariance) ? 0: relatedCustomerList[j].volumeVariance);
                                        totalVariance -= (isNaN(relatedCustomerList[j].totalVariance) ? 0: relatedCustomerList[j].totalVariance);
                                        totalTPTVariance -= (isNaN(relatedCustomerList[j].totalTPTVariance) ? 0: relatedCustomerList[j].totalTPTVariance);                                       
                                    }*/ else{
                                        if(relatedCustomerList[j].bidStatus != 'DRL submitting under New Bid Number'){
                                            previousContractTotal += (isNaN(relatedCustomerList[j].previousContractTotal) ? 0: parseFloat(relatedCustomerList[j].previousContractTotal));
                                            currentContractTotal += (isNaN(relatedCustomerList[j].currentContractTotal) ? 0: parseFloat(relatedCustomerList[j].currentContractTotal));
                                            annualImpact += (isNaN(relatedCustomerList[j].annualImpact) ? 0: parseFloat(relatedCustomerList[j].annualImpact));
                                            businessImpact += (isNaN(relatedCustomerList[j].businessImpact) ? 0: parseFloat(relatedCustomerList[j].businessImpact));
                                            currentQuarterImpact += (isNaN(relatedCustomerList[j].currentQuarterImpact) ? 0: parseFloat(relatedCustomerList[j].currentQuarterImpact));
                                            if(relatedCustomerList[j].previousQty != null){
                                                previousQty += (isNaN(relatedCustomerList[j].previousQty) ? 0: parseFloat(relatedCustomerList[j].previousQty));   
                                            } else{
                                                relatedCustomerList[j].previousQty = 0;
                                                previousQty += 0;
                                            }
                                            awardedQty += (isNaN(relatedCustomerList[j].awardedQty) ? 0: parseFloat(relatedCustomerList[j].awardedQty));
                                            previousTPT += (isNaN(relatedCustomerList[j].previousTPT) ? 0: parseFloat(relatedCustomerList[j].previousTPT));
                                            currentTPT += (isNaN(relatedCustomerList[j].currentTPT) ? 0: parseFloat(relatedCustomerList[j].currentTPT));
                                            priceVariance += (isNaN(relatedCustomerList[j].priceVariance) ? 0: parseFloat(relatedCustomerList[j].priceVariance));
                                            volumeVariance += (isNaN(relatedCustomerList[j].volumeVariance) ? 0: parseFloat(relatedCustomerList[j].volumeVariance));
                                            totalVariance += (isNaN(relatedCustomerList[j].totalVariance) ? 0: parseFloat(relatedCustomerList[j].totalVariance));
                                            totalTPTVariance += (isNaN(relatedCustomerList[j].totalTPTVariance) ? 0: parseFloat(relatedCustomerList[j].totalTPTVariance));   
                                        }
                                    }
                                }
                            }
                            obj.previousContractTotal = parseFloat(previousContractTotal);
                            obj.currentContractTotal = parseFloat(currentContractTotal);
                            obj.change = obj.currentContractTotal - obj.previousContractTotal;
                            obj.changeTitle = '('+obj.currentContractTotal.toFixed()+' - '+obj.previousContractTotal.toFixed()+')';
                            obj.annualImpact = parseFloat(annualImpact);
                            obj.businessImpact = parseFloat(businessImpact);
                            obj.currentQuarterImpact = parseFloat(currentQuarterImpact);
                            obj.previousQty = parseFloat(previousQty);
                            obj.awardedQty = parseFloat(awardedQty);
                            obj.previousTPT = parseFloat(previousTPT);
                            obj.currentTPT = parseFloat(currentTPT);
                            obj.previousTPTPer = obj.previousTPT/(obj.previousContractTotal);
                            obj.currentTPTPer = obj.currentTPT/(obj.currentContractTotal);
                            obj.priceVariance = parseFloat(priceVariance);
                            obj.volumeVariance = parseFloat(volumeVariance);
                            obj.totalVariance = parseFloat(totalVariance);
                            obj.totalTPTVariance = parseFloat(totalTPTVariance);
                            //component.set("v.totalSummary", obj);
                        }
                        if((rec.bidType != 'RFP Bids' && (rec.bidStatus == 'Declined by Customer' || rec.bidStatus == 'DRL Rescinded' || rec.bidStatus == 'DRL submitting under New Bid Number')) || rec.businessCategory == 'No Effect'){
                        
                        }else{
                            if(rec.bidStatus != 'DRL submitting under New Bid Number'){
                                totalPreviousQty += ((isNaN(rec.previousQty) ? 0 : parseFloat(rec.previousQty)));
                                totalAwardedQty += ((isNaN(rec.awardedQty) ? 0 : parseFloat(rec.awardedQty)));
                                totalPreviousTotal += ((isNaN(rec.previousContractTotal) ? 0 : parseFloat(rec.previousContractTotal)));
                                totalCurrentTotal += ((isNaN(rec.currentContractTotal) ? 0 : parseFloat(rec.currentContractTotal)));
                                totalAnnualImpact += ((isNaN(rec.annualImpact) ? 0 : parseFloat(rec.annualImpact)));
                                totalBusinessImpact += ((isNaN(rec.businessImpact) ? 0 : parseFloat(rec.businessImpact)));
                                totalCurrentQuarterImpact += ((isNaN(rec.currentQuarterImpact) ? 0 : parseFloat(rec.currentQuarterImpact)));
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
                            var previousTotal = 0; var currentTotal = 0; var annualImapact = 0; var businessImpact = 0; var currentQuarterImpact = 0; var previousTPT = 0; var currentTPT = 0;
                            var previousTPTFamilySummary = 0; var currentTPTFamilySummary = 0; var priceVarianceFamilySummary = 0; var volumeVarianceFamilySummary = 0;
                            var totalVarianceFamilySummary = 0; var tptVarianceFamilySummary = 0;var totalPreviousAwdQtySummary = 0; var totalAwdQtySummary = 0;
                            for(var i=0; i<relatedList.length; i++){
                                if((relatedList[i].bidType != 'RFP Bids' && (relatedList[i].bidStatus == 'Declined by Customer' || relatedList[i].bidStatus == 'DRL Rescinded' || relatedList[i].bidStatus == 'DRL submitting under New Bid Number')) || relatedList[i].businessCategory == 'No Effect'){
                                    
                                } else{
                                    if(relatedList[i].bidStatus != 'DRL submitting under New Bid Number'){
                                        previousTotal += ((isNaN(relatedList[i].previousContractTotal) ? 0 : parseFloat(relatedList[i].previousContractTotal)));
                                        currentTotal += ((isNaN(relatedList[i].currentContractTotal) ? 0 : parseFloat(relatedList[i].currentContractTotal)));
                                        annualImapact += ((isNaN(relatedList[i].annualImpact) ? 0 : parseFloat(relatedList[i].annualImpact)));
                                        businessImpact += ((isNaN(relatedList[i].businessImpact) ? 0 : parseFloat(relatedList[i].businessImpact)));   
                                        currentQuarterImpact += ((isNaN(relatedList[i].currentQuarterImpact) ? 0 : parseFloat(relatedList[i].currentQuarterImpact)));
                                        previousTPT += ((isNaN(relatedList[i].previousTPT) ? 0 : parseFloat(relatedList[i].previousTPT)));
                                        currentTPT += ((isNaN(relatedList[i].currentTPT) ? 0 : parseFloat(relatedList[i].currentTPT)));
                                        priceVarianceFamilySummary += ((isNaN(relatedList[i].priceVariance) ? 0 : parseFloat(relatedList[i].priceVariance)));
                                        volumeVarianceFamilySummary += ((isNaN(relatedList[i].volumeVariance) ? 0 : parseFloat(relatedList[i].volumeVariance)));
                                        totalPreviousAwdQtySummary += ((isNaN(relatedList[i].previousQty) ? 0 : parseFloat(relatedList[i].previousQty)));
                                        totalAwdQtySummary += ((isNaN(relatedList[i].awardedQty) ? 0 : parseFloat(relatedList[i].awardedQty)));      
                                    }
                                }
                            }
                            /*totalPreviousQty += parseFloat(totalPreviousAwdQtySummary);
                            totalAwardedQty += parseFloat(totalAwdQtySummary);
                            totalPreviousTotal += parseFloat(previousTotal);
                            totalCurrentTotal += parseFloat(currentTotal);
                            totalAnnualImpact += parseFloat(annualImpact);
                            totalBusinessImpact += parseFloat(businessImpact);
                            totalCurrentTPT += parseFloat(currentTPT);
                            totalPreviousTPT += parseFloat(previousTPT);*/
                            /*totalPriceVariance += parseFloat(priceVarianceFamilySummary);
                            totalVolumeVariance += parseFloat(volumeVarianceFamilySummary);*/
                            total += parseFloat(annualImpact);
                            totalTPT = parseFloat(currentTPT) - parseFloat(previousTPT);
                            summary[0] = parseFloat(previousTotal);
                            summary[1] = parseFloat(currentTotal);
                            summary[2] = parseFloat(annualImapact);
                            summary[3] = parseFloat(businessImpact);
                            summary[4] = parseFloat(previousTPT);
                            summary[5] = parseFloat(currentTPT);
                            summary[6] = parseFloat(currentTPT) - parseFloat(previousTPT);
                            summary[7] = parseFloat(priceVarianceFamilySummary);
                            summary[8] = parseFloat(volumeVarianceFamilySummary);
                            summary[9] = ((!isFinite(previousTPT/previousTotal) ? 0 : (previousTPT/previousTotal)));
                            summary[10] = ((!isFinite(currentTPT/currentTotal) ? 0 : (currentTPT/currentTotal)));
                            summary[11] = parseFloat(totalPreviousAwdQtySummary);
                            summary[12] = parseFloat(totalAwdQtySummary);
                            summary[13] = parseFloat(currentQuarterImpact);
                            totalFamilySummaryMap[rec.productFamily] = summary;
                        } 
                        else{
                            var relatedList = [];var summary = [];
                            relatedList.push(rec);
                            totalMap[rec.productFamily] = relatedList;
                            var previousTotal = ((isNaN(rec.previousContractTotal) ? 0 : parseFloat(rec.previousContractTotal)));
                            var currentTotal = ((isNaN(rec.currentContractTotal) ? 0 : parseFloat(rec.currentContractTotal)));
                            var annualImapact = ((isNaN(rec.annualImpact) ? 0 : parseFloat(rec.annualImpact)));
                            var businessImpact = ((isNaN(rec.businessImpact) ? 0 : parseFloat(rec.businessImpact)));
                            var currentQuarterImpact = ((isNaN(rec.currentQuarterImpact) ? 0 : parseFloat(rec.currentQuarterImpact)));
                            var previousTPT = ((isNaN(rec.previousTPT) ? 0 : parseFloat(rec.previousTPT)));
                            var currentTPT = ((isNaN(rec.currentTPT) ? 0 : parseFloat(rec.currentTPT)));
                            var priceVarianceFamilySummary = ((isNaN(rec.priceVariance) ? 0 : parseFloat(rec.priceVariance)));
                            var volumeVarianceFamilySummary = ((isNaN(rec.volumeVariance) ? 0 : parseFloat(rec.volumeVariance)));
                            var totalPreviousAwdQtySummary = ((isNaN(rec.previousQty) ? 0 : parseFloat(rec.previousQty)));
                            var totalAwdQtySummary = ((isNaN(rec.awardedQty) ? 0 : parseFloat(rec.awardedQty)));
                            if((rec.bidType != 'RFP Bids' && (rec.bidStatus == 'Declined by Customer' || rec.bidStatus == 'DRL Rescinded' || rec.bidStatus == 'DRL submitting under New Bid Number')) || rec.businessCategory == 'No Effect'){
                                
                            } else{
                                if(rec.bidStatus != 'DRL submitting under New Bid Number'){
                                    /*totalPreviousQty += parseFloat(totalPreviousAwdQtySummary);
                                    totalAwardedQty += parseFloat(totalAwdQtySummary);
                                    totalPreviousQty += parseFloat(totalPreviousAwdQtySummary);
                                    totalAwardedQty += parseFloat(totalAwdQtySummary);
                                    totalPreviousTotal += parseFloat(previousTotal);
                                    totalCurrentTotal += parseFloat(currentTotal);
                                    totalAnnualImpact += parseFloat(annualImpact);
                                    totalBusinessImpact += parseFloat(businessImpact);
                                    totalCurrentTPT += parseFloat(currentTPT);
                                    totalPreviousTPT += parseFloat(previousTPT);*/
                                    /*totalPriceVariance += parseFloat(priceVarianceFamilySummary);
                                    totalVolumeVariance += parseFloat(volumeVarianceFamilySummary);*/
                                    total += parseFloat(annualImpact);
                                    totalTPT = parseFloat(currentTPT) - parseFloat(previousTPT);   
                                }
                            }
                            summary[0] = parseFloat(previousTotal);
                            summary[1] = parseFloat(currentTotal);
                            summary[2] = parseFloat(annualImapact);
                            summary[3] = parseFloat(businessImpact);
                            summary[4] = parseFloat(previousTPT);
                            summary[5] = parseFloat(currentTPT);
                            summary[6] = parseFloat(currentTPT) - parseFloat(previousTPT);
                            summary[7] = parseFloat(priceVarianceFamilySummary);
                            summary[8] = parseFloat(volumeVarianceFamilySummary);
                            summary[9] = ((!isFinite(previousTPT/previousTotal) ? 0 : (previousTPT/previousTotal)));
                            summary[10] = ((!isFinite(currentTPT/currentTotal) ? 0 : (currentTPT/currentTotal)));
                            summary[11] = parseFloat(totalPreviousAwdQtySummary);
                            summary[12] = parseFloat(totalAwdQtySummary);
                            summary[13] = parseFloat(currentQuarterImpact);
                            totalFamilySummaryMap[rec.productFamily] = summary;
                        }
                    });
                    component.set("v.customerMap", customerMap);
                    component.set("v.customerIds", Object.keys(customerMap));
                    var tempObj = {};
                    let keys = Object.keys(totalFamilySummaryMap);
                    keys.sort(function(a, b) { return totalFamilySummaryMap[b][2] - totalFamilySummaryMap[a][2] });
                    var totalPreviousTotalFinal = 0; var totalCurrentTotalFinal = 0; var totalAnnualImpactFinal = 0; var totalFiscalImpactFinal = 0; var totalCurrentQuarterImpact = 0;
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
                        totalCurrentQuarterImpact += totalFamilySummaryMap[keys[i]][13];
                    }
                    totalFamilySummaryMap = tempObj;
                    tempObj = {};
                    
                    let sortedKeys = Object.keys(totalFamilySummaryMap);
                    for(var i=0; i<sortedKeys.length; i++){
                        tempObj[sortedKeys[i]] = totalMap[sortedKeys[i]];
                    }
                    totalMap = tempObj;
                    
                    /*totalObj.totalPreviousQty = totalPreviousQtyFinal;
                    totalObj.totalAwardedQty = totalAwardedQtyFinal;
                    totalObj.totalPreviousTotal = totalPreviousTotal;
                    totalObj.totalCurrentTotal = totalCurrentTotal;
                    totalObj.totalCurrentTPT = parseFloat(totalCurrentTPTFinal);
                    totalObj.totalPreviousTPT =  parseFloat(totalPreviousTPTFinal);
                    totalObj.totalPriceVariance =  parseFloat(totalPriceVarianceFinal);
                    totalObj.totalVolumeVariance =  parseFloat(totalVolumeVarianceFinal);
                    totalObj.currentTPTPer = (!isFinite(totalObj.totalCurrentTPT/totalObj.totalCurrentTotal) ? 0 : (totalObj.totalCurrentTPT/totalObj.totalCurrentTotal));
                    totalObj.previousTPTPer = (!isFinite(totalObj.totalPreviousTPT/totalObj.totalPreviousTotal) ? 0 : (totalObj.totalPreviousTPT/totalObj.totalPreviousTotal));
                   */
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
                    
                    //totalObj.priceVariance = parseInt(totalPriceVariance);
                    //totalObj.volumeVariance = parseInt(totalVolumeVariance);
                    totalObj.totalPreviousQty = parseInt(totalPreviousQty);
                    totalObj.totalAwardedQty = parseInt(totalAwardedQty);                                    
                    /*totalObj.totalPreviousTotal = parseInt(totalPreviousTotal);
                    totalObj.totalCurrentTotal = parseInt(totalCurrentTotal);*/
                    totalObj.totalAnnualImpact = parseInt(totalAnnualImpact);
                    totalObj.totalBusinessImpact = parseInt(totalBusinessImpact);
                    totalObj.totalCurrentQuarterImpact = parseInt(totalCurrentQuarterImpact);
                    
                    component.set("v.gainedList", gain);
                    component.set("v.lossList", lost);
                    component.set("v.openStatusList", open);
                    component.set("v.noEffectList", noEffect);
                    
                    component.set("v.totalFamilySummaryMap",totalFamilySummaryMap);
                    component.set("v.totalMap",Object.entries(totalMap));
                    component.set("v.scmDataList", scmDataList);
                    component.set("v.categoryTotals", totalObj);
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
                    
                    var formatter = new Intl.NumberFormat('en-US', { style: 'currency', currency: 'USD', minimumFractionDigits: 0, maximumFractionDigits: 0,});
                    component.set("v.businessGained", 'Business Gained'+' ('+formatter.format(totalObj.totalAnnualImpactBG.toFixed())+', '+formatter.format(totalObj.totalBusinessImpactBG.toFixed())+')');
                    component.set("v.retainedGain", 'Business Retained with Gains'+' ('+formatter.format(totalObj.totalAnnualImpactBGG.toFixed())+', '+formatter.format(totalObj.totalBusinessImpactBGG.toFixed())+')');
                    component.set("v.retainedLoss", 'Business Retained with Loss'+' ('+formatter.format(totalObj.totalAnnualImpactBGL.toFixed())+', '+formatter.format(totalObj.totalBusinessImpactBGL.toFixed())+')');
                    component.set("v.lost", 'Business Lost'+' ('+formatter.format(totalObj.totalAnnualImpactBL.toFixed())+', '+formatter.format(totalObj.totalBusinessImpactBL.toFixed())+')');
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
    },
    convertArrayOfObjectsToCSV: function (component, objectRecords) {
        // declare variables
        var csvStringResult, counter, keys, columnDivider, lineDivider;
        // check if "objectRecords" parameter is null, then return from function
        if (objectRecords == null || !objectRecords.length) {
            return null;
        }
        columnDivider = ',';
        lineDivider = '\n';
        var myMap = new Map();
        csvStringResult = '';
        myMap.set("Product Name", "productName");
        myMap.set("Customer", "customer");
        myMap.set("Current Sales", "previousContractTotal");
        myMap.set("Awarded/Proposed Sales", "currentContractTotal");
        myMap.set("Annual Impact", "annualImpact");
        myMap.set("FY Business Impact", "businessImpact");
        myMap.set("Current FY Qaurter Impact", "currentQuarterImpact");
        myMap.set("Current Quantity", "previousQty");
        myMap.set("Awarded/Proposed Quantity", "awardedQty");
        myMap.set("Current Deadnet", "previousDeadnet");
        myMap.set("Proposed Deadnet", "currentDeadnet");
        myMap.set("Current TPT($)", "previousTPT");
        myMap.set("Awarded/Proposed TPT($)", "currentTPT");
        myMap.set("Current TPT(%)", "previousTPTPercent");
        myMap.set("Awarded/Proposed TPT(%)", "currentTPTPercent");
        myMap.set("Price Variance($)", "priceVariance");
        myMap.set("Volume Variance($)", "volumeVariance");
        myMap.set("Total Variance($)", "totalVariance");
        myMap.set("TPT Variance($)", "totalTPTVariance");
        var scmData = component.get("v.scmData");
        csvStringResult += Array.from(myMap.keys()).join(columnDivider);
        csvStringResult += lineDivider;
        
        for (var i = 0; i < objectRecords.length; i++) {
            counter = 0;
            for (let [key, value] of myMap) {
                if (counter > 0) {
                    csvStringResult += columnDivider;
                }
                if(value == 'productName' || value == 'customer'){
                    var record = objectRecords[i];
                    if(record != null){
                        if(objectRecords[i][value] != null)
                            csvStringResult += '"'+ objectRecords[i][value]+'"';
                        else
                            csvStringResult += '"'+''+'"';
                    }
                    else{
                        csvStringResult += '"'+''+'"';
                    }
                }
                else if(value == 'previousTPTPercent' || value == 'currentTPTPercent'){
                    var record = objectRecords[i];
                    if(record != null){
                        if(objectRecords[i][value] != null){
                            var percentValue = objectRecords[i][value] * 100;
                            csvStringResult += '"'+ percentValue.toFixed(0)+'"';
                        }
                        else
                            csvStringResult += '"'+''+'"';
                    }
                    else{
                        csvStringResult += '"'+''+'"';
                    }
                }
                else if (objectRecords[i][value] == undefined) {
                    csvStringResult += '"' + '' + '"';
                } else {
                    var record = objectRecords[i];
                    if(record != null){
                        console.log('value: '+value);
                        if(objectRecords[i][value] != null){
                            var recordValue = objectRecords[i][value];
                            recordValue = parseFloat(recordValue);
                            csvStringResult += '"'+ recordValue.toFixed(0)+'"';
                        }
                        else
                            csvStringResult += '"'+''+'"';
                    }
                    else{
                        csvStringResult += '"'+''+'"';
                    }
                }
                counter++;
            }
            csvStringResult += lineDivider;
        }   
        
        return csvStringResult;
    },
})