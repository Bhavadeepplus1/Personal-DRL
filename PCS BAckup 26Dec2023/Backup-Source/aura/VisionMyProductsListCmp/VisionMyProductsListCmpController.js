({
    doInit : function(component, event, helper) {
        const today = new Date();
        const year = today.getFullYear();
        const month = today.getMonth();
        var quarterStrings = ['Q1', 'Q2', 'Q3', 'Q4'];
        const quartersMap = new Map();
        quartersMap[3] = 'Q1'; quartersMap[4] = 'Q1'; quartersMap[5] = 'Q1';
        quartersMap[6] = 'Q2'; quartersMap[7] = 'Q2'; quartersMap[8] = 'Q2';
        quartersMap[9] = 'Q3'; quartersMap[10] = 'Q3'; quartersMap[11] = 'Q3';
        quartersMap[0] = 'Q4'; quartersMap[1] = 'Q4';  quartersMap[2] = 'Q4';
        
        var currentQuarter = quartersMap[month];
        var currentPreviousQuarter = ((quarterStrings.indexOf(currentQuarter)-1 < 0) ? quarterStrings[quarterStrings.length-1] : quarterStrings[quarterStrings.indexOf(currentQuarter)-1]);
        console.log('currentPreviousQuarter: '+currentPreviousQuarter);
        var FromDate; var ToDate;
        
        if(currentPreviousQuarter == 'Q1'){
            FromDate = new Date(parseInt(year), 3, 1);
            ToDate = new Date(parseInt(year), 5, 30);
        } else if(currentPreviousQuarter == 'Q2'){
            FromDate = new Date(parseInt(year), 6, 1);
            ToDate = new Date(parseInt(year), 8, 30);
        } else if(currentPreviousQuarter == 'Q3'){
            FromDate = new Date(parseInt(year), 9, 1);
            ToDate = new Date(parseInt(year), 11, 31);
        } else if(currentPreviousQuarter == 'Q4'){
            FromDate = new Date(parseInt(year), 0, 1);
            ToDate = new Date(parseInt(year), 2, 31);
        }
        component.set("v.startDate", new Date(FromDate).getFullYear()+'-'+(parseInt(new Date(FromDate).getMonth())+1)+'-'+'1');
        component.set("v.endDate", new Date(ToDate).getFullYear()+'-'+(parseInt(new Date(ToDate).getMonth())+1)+'-'+new Date(ToDate).getDate());
        
        console.log('Start Date: '+component.get("v.startDate"));
        console.log('End Date: '+component.get("v.endDate"));
        
    },
    collectData: function(component, event, helper){
        component.set("v.isSpinnerLoad", true);
        var action = component.get("c.getData");
        console.log('Start Date: '+component.get("v.startDate"));
        console.log('End Date: '+component.get("v.endDate"));
        var userId = $A.get("$SObjectType.CurrentUser.Id");
        console.log('User Id: '+userId);
        action.setParams({
            'AccountDirector': '0051K000008fQUuQAM',
            'Customer': '',
            'selections': ['Rx', 'SRx', 'OTC'],
            'startDate': new Date(component.get("v.startDate")),
            'endDate': new Date(component.get("v.endDate")),
            'selectedDivision': 'All',
            'dateBasedOn': component.get("v.selectedDate"),
            'directorType': 'Product Director'
        });
        action.setCallback(this, function(response){
            if(response.getState() === "SUCCESS"){
                console.log('Response: '+JSON.stringify(response.getReturnValue()));
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
                var previousTotal = 0; var currentTotal = 0;
                if(scmDataList.length>0){
                    var totalAnnualImpactBG = 0; var totalBusinessImpactBG = 0; var totalPreviousQtyBG = 0; var totalQtyBG = 0; var totalSCMApprovedQtyBG = 0; var currentTotalBG = 0; var previousTotalBG = 0; var previousTPTBG = 0; var currentTPTBG = 0; var priceVarianceBG = 0; var volumeVarianceBG = 0; var totalVarianceBG = 0; var tptVarianceBG = 0;
                    var totalAnnualImpactBGG = 0; var totalBusinessImpactBGG = 0; var totalPreviousQtyBGG = 0; var totalQtyBGG = 0; var totalSCMApprovedQtyBGG = 0; var currentTotalBGG = 0; var previousTotalBGG = 0; var previousTPTBGG = 0; var currentTPTBGG = 0; var priceVarianceBGG = 0; var volumeVarianceBGG = 0; var totalVarianceBGG = 0; var tptVarianceBGG = 0;
                    var totalAnnualImpactBGL = 0; var totalBusinessImpactBGL = 0; var totalPreviousQtyBGL = 0; var totalQtyBGL = 0; var totalSCMApprovedQtyBGL = 0; var currentTotalBGL = 0; var previousTotalBGL = 0; var previousTPTBGL = 0; var currentTPTBGL = 0; var priceVarianceBGL = 0; var volumeVarianceBGL = 0; var totalVarianceBGL = 0; var tptVarianceBGL = 0;
                    var totalAnnualImpactNE = 0; var totalBusinessImpactNE = 0; var totalPreviousQtyNE = 0; var totalQtyNE = 0; var totalSCMApprovedQtyNE = 0; var currentTotalNE = 0; var previousTotalNE = 0; var previousTPTNE = 0; var currentTPTNE = 0; var priceVarianceNE = 0; var volumeVarianceNE = 0; var totalVarianceNE = 0; var tptVarianceNE = 0;
                    var totalAnnualImpactOS = 0; var totalBusinessImpactOS = 0; var totalPreviousQtyOS = 0; var totalQtyOS = 0; var totalSCMApprovedQtyOS = 0; var currentTotalOS = 0; var previousTotalOS = 0; var previousTPTOS = 0; var currentTPTOS = 0; var priceVarianceOS = 0; var volumeVarianceOS = 0; var totalVarianceOS = 0; var tptVarianceOS = 0;
                    var totalAnnualImpactBL = 0; var totalBusinessImpactBL = 0; var currentTotalBL = 0; var previousTotalBL = 0; var tptVariance =0; var priceVariance =0; var volumeVariance =0;
                    var totalAnnualImpactBLRemovals = 0; var totalBusinessImpactBLRemovals = 0;var totalAnnualImpactBLDiscontinuation = 0; var totalBusinessImpactBLDiscontinuation = 0;var totalAnnualImpactBLRFP = 0; var totalBusinessImpactBLRFP = 0;
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
                            var fiscalyear = '';
                            if ((d.getMonth() + 1) <= 3)
                                fiscalyear = d.getFullYear();
                            else
                                fiscalyear = d.getFullYear() + 1;
                            var endDateOfFiscalYear = new Date(fiscalyear, 2, 31);
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
                                totalCurrentFiscalImpact +=(scmDataList[i].currentContractTotal * monthsRemaining)/12;
                                totalProposedFiscalImpact += (scmDataList[i].previousContractTotal * monthsRemaining)/12;
                                totalCurrentTPTFiscalImpact +=(scmDataList[i].currentTPT * monthsRemaining)/12;
                                totalProposedTPTFiscalImpact += (scmDataList[i].previousTPT * monthsRemaining)/12;
                                if(scmDataList[i].annualImpact >= 0){
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
                            }
                            else if(scmDataList[i].businessCategory == 'Business Retained'){
                                totalCurrentFiscalImpact +=(scmDataList[i].currentContractTotal * monthsRemaining)/12;
                                totalProposedFiscalImpact += (scmDataList[i].previousContractTotal * monthsRemaining)/12;
                                totalCurrentTPTFiscalImpact +=(scmDataList[i].currentTPT * monthsRemaining)/12;
                                totalProposedTPTFiscalImpact += (scmDataList[i].previousTPT * monthsRemaining)/12;
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
                                } 
                                else{
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
                                        var listOfProducts = removalsDataFormattingObjRFP[scmDataList[i].customer];
                                        scmDataList[i].annualTitle = 'Deadnet Price * Quantity  ('+scmDataList[i].previousQty+' * '+scmDataList[i].previousIndirectPrice+')';
                                        if(listOfProducts != null){ 
                                            if(scmDataList[i].removalEffectiveDate != null){
                                                scmDataList[i].removalEffectiveDate = new Date(scmDataList[i].removalEffectiveDate).toLocaleDateString("en-US", { year: "numeric", month: "2-digit", day: "2-digit" });   
                                            }
                                            var annualImpact = parseInt(scmDataList[i].previousQty * scmDataList[i].previousIndirectPrice);
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
                                            totalAnnualImpactBLRFP += ((isNaN(scmDataList[i].annualImpact) ? 0 : scmDataList[i].annualImpact));
                                            totalBusinessImpactBLRFP += ((isNaN(scmDataList[i].businessImpact) ? 0 : scmDataList[i].businessImpact));
                                            previousTotalBL += Math.abs(scmDataList[i].annualImpact);
                                            currentTotalBL += 0;
                                            removalsDataFormattingObjRFP[scmDataList[i].customer] = listOfProducts;                                    
                                        } 
                                        else{
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
                                            totalAnnualImpactBLRFP += ((isNaN(scmDataList[i].annualImpact) ? 0 : scmDataList[i].annualImpact));
                                            totalBusinessImpactBLRFP += ((isNaN(scmDataList[i].businessImpact) ? 0 : scmDataList[i].businessImpact));
                                            previousTotalBL += Math.abs(scmDataList[i].annualImpact);
                                            currentTotalBL += 0;
                                            removalsDataFormattingObjRFP[scmDataList[i].customer] = listOfProducts;                                    
                                        }
                                        totalCurrentFiscalImpact += businessImpact;
                                        scmDataList[i].monthsRemaining = monthsRemaining;
                                        lossList.push(scmDataList[i]);
                                        RFPLossList.push(scmDataList[i]);
                                    } else if(scmDataList[i].bidRecord.Phoenix_Bid_Type__c == 'Product Discontinuation Process'){
                                        console.log('Date Yes I:::: '+i);
                                        var listOfProducts = removalsDataFormattingObjProductDiscontinuation[scmDataList[i].customer];
                                        scmDataList[i].annualTitle = 'Deadnet Price * Quantity  ('+scmDataList[i].previousQty+' * '+scmDataList[i].previousIndirectPrice+')';
                                        if(listOfProducts != null){ 
                                            if(scmDataList[i].removalEffectiveDate != null){
                                                scmDataList[i].removalEffectiveDate = new Date(scmDataList[i].removalEffectiveDate).toLocaleDateString("en-US", { year: "numeric", month: "2-digit", day: "2-digit" });   
                                            }
                                            var annualImpact = parseInt(scmDataList[i].previousQty * scmDataList[i].previousIndirectPrice);
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
                                            totalAnnualImpactBLDiscontinuation += ((isNaN(scmDataList[i].annualImpact) ? 0 : scmDataList[i].annualImpact));
                                            totalBusinessImpactBLDiscontinuation += ((isNaN(scmDataList[i].businessImpact) ? 0 : scmDataList[i].businessImpact));
                                            previousTotalBL += Math.abs(scmDataList[i].annualImpact);
                                            currentTotalBL += 0;
                                            removalsDataFormattingObjProductDiscontinuation[scmDataList[i].customer] = listOfProducts;                                    
                                        } 
                                        else{
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
                                            totalAnnualImpactBLDiscontinuation += ((isNaN(scmDataList[i].annualImpact) ? 0 : scmDataList[i].annualImpact));
                                            totalBusinessImpactBLDiscontinuation += ((isNaN(scmDataList[i].businessImpact) ? 0 : scmDataList[i].businessImpact));
                                            previousTotalBL += Math.abs(scmDataList[i].annualImpact);
                                            currentTotalBL += 0;
                                            removalsDataFormattingObjProductDiscontinuation[scmDataList[i].customer] = listOfProducts;                                    
                                        }
                                        totalCurrentFiscalImpact += businessImpact;
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
                                            var annualImpact = parseInt(scmDataList[i].previousQty * scmDataList[i].previousIndirectPrice);
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
                                            totalAnnualImpactBLRemovals += ((isNaN(scmDataList[i].annualImpact) ? 0 : scmDataList[i].annualImpact));
                                            totalBusinessImpactBLRemovals += ((isNaN(scmDataList[i].businessImpact) ? 0 : scmDataList[i].businessImpact));
                                            previousTotalBL += Math.abs(scmDataList[i].annualImpact);
                                            currentTotalBL += 0;
                                            removalsDataFormattingObjProductRemovals[scmDataList[i].customer] = listOfProducts;                                    
                                        } 
                                        else{
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
                                            totalAnnualImpactBLRemovals += ((isNaN(scmDataList[i].annualImpact) ? 0 : scmDataList[i].annualImpact));
                                            totalBusinessImpactBLRemovals += ((isNaN(scmDataList[i].businessImpact) ? 0 : scmDataList[i].businessImpact));
                                            previousTotalBL += Math.abs(scmDataList[i].annualImpact);
                                            currentTotalBL += 0;
                                            removalsDataFormattingObjProductRemovals[scmDataList[i].customer] = listOfProducts;                                    
                                        }
                                        totalCurrentFiscalImpact += businessImpact;
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
                                    console.log('RFP Bids:: '+scmDataList[i].bidRecord.Phoenix_Bid_Type__c);
                                    scmDataList[i].annualTitle = 'Deadnet Price * Quantity  ('+scmDataList[i].previousQty+' * '+scmDataList[i].previousIndirectPrice+')';
                                    var listOfProducts = removalsDataFormattingObjRFP[scmDataList[i].customer];
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
                                        totalAnnualImpactBLRFP += ((isNaN(scmDataList[i].annualImpact) ? 0 : scmDataList[i].annualImpact));
                                        totalBusinessImpactBLRFP += ((isNaN(scmDataList[i].businessImpact) ? 0 : scmDataList[i].businessImpact));
                                        previousTotalBL += Math.abs(scmDataList[i].annualImpact);
                                        currentTotalBL += 0;
                                        removalsDataFormattingObjRFP[scmDataList[i].customer] = listOfProducts;                                    
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
                                        totalAnnualImpactBLRFP += ((isNaN(scmDataList[i].annualImpact) ? 0 : scmDataList[i].annualImpact));
                                        totalBusinessImpactBLRFP += ((isNaN(scmDataList[i].businessImpact) ? 0 : scmDataList[i].businessImpact));
                                        previousTotalBL += Math.abs(scmDataList[i].annualImpact);
                                        currentTotalBL += 0;
                                        removalsDataFormattingObjRFP[scmDataList[i].customer] = listOfProducts;                                    
                                    }
                                    totalCurrentFiscalImpact += scmDataList[i].businessImpact;
                                    lossList.push(scmDataList[i]);
                                    RFPLossList.push(scmDataList[i]);   
                                } else if(scmDataList[i].bidRecord.Phoenix_Bid_Type__c == 'Mass Product Removals'){
                                    console.log('scmDataList[i].bidRecord.Phoenix_Bid_Type__c: '+scmDataList[i].bidRecord.Phoenix_Bid_Type__c);
                                    scmDataList[i].annualTitle = 'Deadnet Price * Quantity  ('+scmDataList[i].previousQty+' * '+scmDataList[i].previousIndirectPrice+')';
                                    var listOfProducts = removalsDataFormattingObjProductRemovals[scmDataList[i].customer];
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
                                        totalAnnualImpactBLRemovals += ((isNaN(scmDataList[i].annualImpact) ? 0 : scmDataList[i].annualImpact));
                                        totalBusinessImpactBLRemovals += ((isNaN(scmDataList[i].businessImpact) ? 0 : scmDataList[i].businessImpact));
                                        previousTotalBL += Math.abs(scmDataList[i].annualImpact);
                                        currentTotalBL += 0;
                                        removalsDataFormattingObjProductRemovals[scmDataList[i].customer] = listOfProducts;                                    
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
                                        totalAnnualImpactBLRemovals += ((isNaN(scmDataList[i].annualImpact) ? 0 : scmDataList[i].annualImpact));
                                        totalBusinessImpactBLRemovals += ((isNaN(scmDataList[i].businessImpact) ? 0 : scmDataList[i].businessImpact));
                                        previousTotalBL += Math.abs(scmDataList[i].annualImpact);
                                        currentTotalBL += 0;
                                        removalsDataFormattingObjProductRemovals[scmDataList[i].customer] = listOfProducts;                                    
                                    }
                                    totalCurrentFiscalImpact += scmDataList[i].businessImpact;
                                    lossList.push(scmDataList[i]);
                                    removalsLossList.push(scmDataList[i]);
                                } else if(scmDataList[i].bidRecord.Phoenix_Bid_Type__c == 'Product Discontinuation Process'){
                                    console.log('scmDataList[i].bidRecord.Phoenix_Bid_Type__c: '+scmDataList[i].bidRecord.Phoenix_Bid_Type__c);
                                    scmDataList[i].annualTitle = 'Deadnet Price * Quantity  ('+scmDataList[i].previousQty+' * '+scmDataList[i].previousIndirectPrice+')';
                                    var listOfProducts = removalsDataFormattingObjProductDiscontinuation[scmDataList[i].customer];
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
                                        totalAnnualImpactBLDiscontinuation += ((isNaN(scmDataList[i].annualImpact) ? 0 : scmDataList[i].annualImpact));
                                        totalBusinessImpactBLDiscontinuation += ((isNaN(scmDataList[i].businessImpact) ? 0 : scmDataList[i].businessImpact));
                                        previousTotalBL += Math.abs(scmDataList[i].annualImpact);
                                        currentTotalBL += 0;
                                        removalsDataFormattingObjProductDiscontinuation[scmDataList[i].customer] = listOfProducts;                                    
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
                                        totalAnnualImpactBLDiscontinuation += ((isNaN(scmDataList[i].annualImpact) ? 0 : scmDataList[i].annualImpact));
                                        totalBusinessImpactBLDiscontinuation += ((isNaN(scmDataList[i].businessImpact) ? 0 : scmDataList[i].businessImpact));
                                        previousTotalBL += Math.abs(scmDataList[i].annualImpact);
                                        currentTotalBL += 0;
                                        removalsDataFormattingObjProductDiscontinuation[scmDataList[i].customer] = listOfProducts;                                    
                                    }
                                    totalCurrentFiscalImpact += scmDataList[i].businessImpact;
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
                            console.log('scmDataList[i].businessCategory: '+scmDataList[i].businessCategory);
                            if(scmDataList[i].businessCategory != 'No Effect' && scmDataList[i].currentDeadnet != scmDataList[i].previousDeadnet && scmDataList[i].awardedQty != scmDataList[i].previousQty)
                                bothList.push(scmDataList[i].bidLineItem.Id);
                            if(scmDataList[i].businessCategory != 'No Effect' && scmDataList[i].currentDeadnet != scmDataList[i].previousDeadnet){
                                if(!bothList.includes(scmDataList[i].bidLineItem.Id))
                                    priceChangeList.push(scmDataList[i].bidLineItem.Id);
                            }
                            if(scmDataList[i].businessCategory != 'No Effect' && scmDataList[i].awardedQty != scmDataList[i].previousQty){
                                if(!bothList.includes(scmDataList[i].bidLineItem.Id))
                                    volumeChangeList.push(scmDataList[i].bidLineItem.Id);
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
                        scmDataList[i].totalVariance = parseInt(((isNaN(scmDataList[i].currentContractTotal) ? 0 : scmDataList[i].currentContractTotal))) - parseInt(((isNaN(scmDataList[i].previousContractTotal) ? 0 : scmDataList[i].previousContractTotal)));
                        scmDataList[i].totalTPTVariance = parseInt(scmDataList[i].currentTPT-scmDataList[i].previousTPT);
                    }
                    
                    totalObj.totalCurrentFiscalImpact = parseInt(totalCurrentFiscalImpact);
                    totalObj.totalProposedFiscalImpact = parseInt(totalProposedFiscalImpact);
                    totalObj.totalCurrentTPTFiscalImpact = parseInt(totalCurrentTPTFiscalImpact);
                    totalObj.totalProposedTPTFiscalImpact = parseInt(totalProposedTPTFiscalImpact);
                    
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
                    
                    totalObj.currentTotal = currentTotal;
                    totalObj.previousTotal = previousTotal;
                    totalObj.totalAnnualImpactBG = parseInt(totalAnnualImpactBG); totalObj.totalBusinessImpactBG = parseInt(totalBusinessImpactBG); totalObj.totalPreviousQtyBG = parseInt(totalPreviousQtyBG); totalObj.totalQtyBG = parseInt(totalQtyBG); totalObj.totalSCMApprovedQtyBG = totalSCMApprovedQtyBG; totalObj.previousTotalBG = previousTotalBG;totalObj.currentTotalBG = currentTotalBG;totalObj.currentTPTBG = parseInt(currentTPTBG);totalObj.previousTPTBG =  parseInt(previousTPTBG);totalObj.priceVarianceBG =  parseInt(priceVarianceBG);totalObj.volumeVarianceBG =  parseInt(volumeVarianceBG);totalObj.currentTPTPerBG = (!isFinite(totalObj.currentTPTBG/totalObj.currentTotalBG) ? 0 : (totalObj.currentTPTBG/totalObj.currentTotalBG));totalObj.previousTPTPerBG = (!isFinite(totalObj.previousTPTBG/totalObj.previousTotalBG) ? 0 : (totalObj.previousTPTBG/totalObj.previousTotalBG));
                    totalObj.totalAnnualImpactBGG = parseInt(totalAnnualImpactBGG); totalObj.totalBusinessImpactBGG = parseInt(totalBusinessImpactBGG); totalObj.totalPreviousQtyBGG = parseInt(totalPreviousQtyBGG); totalObj.totalQtyBGG = parseInt(totalQtyBGG); totalObj.totalSCMApprovedQtyBGG = totalSCMApprovedQtyBGG; totalObj.previousTotalBGG = previousTotalBGG;totalObj.currentTotalBGG = currentTotalBGG;totalObj.currentTPTBGG =  parseInt(currentTPTBGG);totalObj.previousTPTBGG =  parseInt(previousTPTBGG);totalObj.priceVarianceBGG =  parseInt(priceVarianceBGG);totalObj.volumeVarianceBGG = parseInt(volumeVarianceBGG);totalObj.currentTPTPerBGG = (!isFinite(totalObj.currentTPTBGG/currentTotalBGG) ? 0 : (totalObj.currentTPTBGG/currentTotalBGG));totalObj.previousTPTPerBGG = (!isFinite(totalObj.previousTPTBGG/previousTotalBGG) ? 0 : (totalObj.previousTPTBGG/previousTotalBGG));
                    totalObj.totalAnnualImpactBGL = parseInt(totalAnnualImpactBGL); totalObj.totalBusinessImpactBGL = parseInt(totalBusinessImpactBGL); totalObj.totalPreviousQtyBGL = parseInt(totalPreviousQtyBGL); totalObj.totalQtyBGL = parseInt(totalQtyBGL); totalObj.totalSCMApprovedQtyBGL = totalSCMApprovedQtyBGL; totalObj.previousTotalBGL = previousTotalBGL;totalObj.currentTotalBGL = currentTotalBGL;totalObj.currentTPTBGL =  parseInt(currentTPTBGL);totalObj.previousTPTBGL =  parseInt(previousTPTBGL);totalObj.priceVarianceBGL =  parseInt(priceVarianceBGL);totalObj.volumeVarianceBGL =  parseInt(volumeVarianceBGL);totalObj.currentTPTPerBGL = (!isFinite(totalObj.currentTPTBGL/currentTotalBGL) ? 0 : (totalObj.currentTPTBGL/currentTotalBGL));totalObj.previousTPTPerBGL = (!isFinite(totalObj.previousTPTBGL/previousTotalBGL) ? 0 : (totalObj.previousTPTBGL/previousTotalBGL));
                    totalObj.totalAnnualImpactNE = parseInt(totalAnnualImpactNE); totalObj.totalBusinessImpactNE = parseInt(totalBusinessImpactNE); totalObj.totalPreviousQtyNE = parseInt(totalPreviousQtyNE); totalObj.totalQtyNE = parseInt(totalQtyNE); totalObj.totalSCMApprovedQtyNE = totalSCMApprovedQtyNE; totalObj.previousTotalNE = previousTotalNE;totalObj.currentTotalNE = currentTotalNE;totalObj.currentTPTNE =  parseInt(currentTPTNE);totalObj.previousTPTNE =  parseInt(previousTPTNE);totalObj.priceVarianceNE =  parseInt(priceVarianceNE);totalObj.volumeVarianceNE =  parseInt(volumeVarianceNE);totalObj.currentTPTPerNE = (!isFinite(totalObj.currentTPTNE/currentTotalNE) ? 0 : (totalObj.currentTPTNE/currentTotalNE));totalObj.previousTPTPerNE = (!isFinite(totalObj.previousTPTNE/previousTotalNE) ? 0 : (totalObj.previousTPTNE/previousTotalNE));
                    totalObj.totalAnnualImpactOS = parseInt(totalAnnualImpactOS); totalObj.totalBusinessImpactOS = parseInt(totalBusinessImpactOS); totalObj.totalPreviousQtyOS = parseInt(totalPreviousQtyOS); totalObj.totalQtyOS = parseInt(totalQtyOS); totalObj.totalSCMApprovedQtyOS = totalSCMApprovedQtyOS; totalObj.previousTotalOS = previousTotalOS;totalObj.currentTotalOS = currentTotalOS;totalObj.currentTPTOS =  parseInt(currentTPTOS);totalObj.previousTPTOS =  parseInt(previousTPTOS);totalObj.priceVarianceOS =  parseInt(priceVarianceOS);totalObj.volumeVarianceOS =  parseInt(volumeVarianceOS);totalObj.currentTPTPerOS = (!isFinite(totalObj.currentTPTOS/currentTotalOS) ? 0 : (totalObj.currentTPTOS/currentTotalOS));totalObj.previousTPTPerOS = (!isFinite(totalObj.previousTPTOS/previousTotalOS) ? 0 : (totalObj.previousTPTOS/previousTotalOS));
                    totalObj.totalAnnualImpactBL = parseInt(totalAnnualImpactBL); totalObj.totalBusinessImpactBL = parseInt(totalBusinessImpactBL);
                    totalObj.totalAnnualImpactBLRFP = parseInt(totalAnnualImpactBLRFP); totalObj.totalBusinessImpactBLRFP = parseInt(totalBusinessImpactBLRFP);
                    totalObj.totalAnnualImpactBLRemovals = parseInt(totalAnnualImpactBLRemovals); totalObj.totalBusinessImpactBLRemovals = parseInt(totalBusinessImpactBLRemovals);
                    totalObj.totalAnnualImpactBLDiscontinuation = parseInt(totalAnnualImpactBLDiscontinuation); totalObj.totalBusinessImpactBLDiscontinuation = parseInt(totalBusinessImpactBLDiscontinuation);
                    totalObj.totalAnnualImpact = parseInt((isNaN(totalAnnualImpactBG) ? 0: totalAnnualImpactBG) + (isNaN(totalAnnualImpactBGG) ? 0: totalAnnualImpactBGG) + (isNaN(totalAnnualImpactBGL) ? 0: totalAnnualImpactBGL) + (isNaN(totalAnnualImpactBL) ? 0: totalAnnualImpactBL)); // + (isNaN(totalAnnualImpactNE) ? 0: totalAnnualImpactNE)
                    console.log('Total Annual Impact: '+totalObj.totalAnnualImpact);
                    totalObj.totalBusinessImpact = parseInt((isNaN(totalBusinessImpactBG) ? 0: totalBusinessImpactBG) + (isNaN(totalBusinessImpactBGG) ? 0: totalBusinessImpactBGG) + (isNaN(totalBusinessImpactBGL) ? 0: totalBusinessImpactBGL) + (isNaN(totalBusinessImpactBL) ? 0: totalBusinessImpactBL)); // + (isNaN(totalBusinessImpactNE) ? 0: totalBusinessImpactNE)
                    totalObj.totalPreviousTotal = parseInt((isNaN(previousTotalBG) ? 0: previousTotalBG) + (isNaN(previousTotalBGG) ? 0: previousTotalBGG) + (isNaN(previousTotalBGL) ? 0: previousTotalBGL) + (isNaN(previousTotalBL) ? 0: previousTotalBL)); // + (isNaN(previousTotalNE) ? 0: previousTotalNE)
                    console.log('Total Previous Total: '+totalObj.totalPreviousTotal);
                    component.set("v.actualSales", totalObj.totalPreviousTotal);
                    totalObj.totalCurrentTotal = parseInt((isNaN(currentTotalBG) ? 0: currentTotalBG) + (isNaN(currentTotalBGG) ? 0: currentTotalBGG) + (isNaN(currentTotalBGL) ? 0: currentTotalBGL) + (isNaN(currentTotalBL) ? 0: currentTotalBL)); // + (isNaN(currentTotalNE) ? 0: currentTotalNE)
                    console.log('Total Current Total: '+totalObj.totalCurrentTotal);
                    totalObj.totalCurrentTotalTitle = '('+(isNaN(currentTotalBG) ? 0: currentTotalBG.toFixed())+') + (' + (isNaN(currentTotalBGG) ? 0: currentTotalBGG.toFixed())+') + (' + (isNaN(currentTotalBGL) ? 0: currentTotalBGL.toFixed())+') + ('+ (isNaN(currentTotalBL) ? 0: currentTotalBL.toFixed())+')';
                    totalObj.totalPreviousTotalTitle = '('+(isNaN(previousTotalBG) ? 0: previousTotalBG.toFixed())+') + (' + (isNaN(previousTotalBGG) ? 0: previousTotalBGG.toFixed())+') + (' + (isNaN(previousTotalBGL) ? 0: previousTotalBGL.toFixed())+') + ('+ (isNaN(previousTotalBL) ? 0: previousTotalBL.toFixed())+')'; // + (' + (isNaN(previousTotalNE) ? 0: previousTotalNE.toFixed())+')';
                    totalObj.percentageChange = (((totalObj.totalCurrentTotal - totalObj.totalPreviousTotal) / totalObj.totalPreviousTotal)*100).toFixed(2);
                    totalObj.change = parseInt((totalObj.totalCurrentTotal - totalObj.totalPreviousTotal));
                    totalObj.previousTPT = previousTPTBG + previousTPTBGG + previousTPTBGL;
                    totalObj.currentTPT = currentTPTBG + currentTPTBGG + currentTPTBGL;
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
                    totalObj.priceVariance = priceVariance;
                    totalObj.volumeVariance = volumeVariance;
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
                    if(scmDataList[0].businessCategory == 'Business Lost'){
                        component.set("v.totalLineItems", 0);
                    } else{
                        component.set("v.totalLineItems", scmDataList.length);
                        totalObj.totalAnnualImpactTitle = '('+(isNaN(totalAnnualImpactBG) ? 0: totalAnnualImpactBG.toFixed())+') + (' + (isNaN(totalAnnualImpactBGG) ? 0: totalAnnualImpactBGG.toFixed())+') + (' + (isNaN(totalAnnualImpactBGL) ? 0: totalAnnualImpactBGL.toFixed())+')'; // + (' + (isNaN(totalAnnualImpactNE) ? 0: totalAnnualImpactNE.toFixed())+')
                        totalObj.totalBusinessImpactTitle = '('+(isNaN(totalBusinessImpactBG) ? 0: totalBusinessImpactBG.toFixed())+') + (' + (isNaN(totalBusinessImpactBGG) ? 0: totalBusinessImpactBGG.toFixed())+') + (' + (isNaN(totalBusinessImpactBGL) ? 0: totalBusinessImpactBGL.toFixed())+')'; // + (' + (isNaN(totalBusinessImpactNE) ? 0: totalBusinessImpactNE.toFixed())+')
                    }
                    var total = component.get("v.totalLineItems");
                    totalObj.percentPriceChanges = (totalObj.deadnetChangesCount/total)*100;
                    totalObj.percentQtyChanges = (totalObj.awardedQtyChangesCount/total)*100;
                    totalObj.percentBothChanges = (totalObj.bothPriceAndVolumeChangesCount/total)*100;
                    
                    //component.set("v.categoryTotals", totalObj);
                    
                    component.set("v.gainedList", []);
                    component.set("v.removalsLossList", []);
                    component.set("v.discontinuationLossList", []);
                    component.set("v.RFPLossList", []);
                    component.set("v.noEffectList", []);
                    var gain = []; var lost = []; var open = []; var noEffect = [];
                    var totalMap = {};
                    var totalFamilySummaryMap = {}; var totalPreviousQty = 0; var totalAwardedQty = 0; var totalPreviousTotal = 0; var totalCurrentTotal = 0;
                    var totalAnnualImpact = 0; var totalBusinessImpact = 0; var totalCurrentTPT = 0; var totalPreviousTPT = 0; var totalCurrentTPTPer = 0; var totalPreviousTPTPer = 0;
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
                        if(totalMap.hasOwnProperty(rec.productFamily)){
                            var relatedList = totalMap[rec.productFamily]; var summary = [];
                            relatedList.push(rec);
                            totalMap[rec.productFamily] = relatedList;
                            var previousTotal = 0; var currentTotal = 0; var annualImpact = 0; var businessImpact = 0; var previousTPT = 0; var currentTPT = 0;
                            var previousTPTFamilySummary = 0; var currentTPTFamilySummary = 0; var priceVarianceFamilySummary = 0; var volumeVarianceFamilySummary = 0;
                            var totalVarianceFamilySummary = 0; var tptVarianceFamilySummary = 0;var totalPreviousAwdQtySummary = 0; var totalAwdQtySummary = 0;
                            for(var i=0; i<relatedList.length; i++){
                                if(relatedList[i].bidType != 'RFP Bids' && (relatedList[i].bidStatus == 'Declined by Customer' || relatedList[i].bidStatus == 'DRL Rescinded' || relatedList[i].bidStatus == 'DRL submitting under New Bid Number')){
                                    
                                } else if(relatedList[i].bidType == 'RFP Bids' && (relatedList[i].bidStatus == 'Declined by Customer' || relatedList[i].bidStatus == 'DRL Rescinded')){
                                    previousTotal -= ((isNaN(relatedList[i].previousContractTotal) ? 0 : relatedList[i].previousContractTotal));
                                    currentTotal -= ((isNaN(relatedList[i].currentContractTotal) ? 0 : relatedList[i].currentContractTotal));
                                    annualImpact -= ((isNaN(relatedList[i].annualImpact) ? 0 : relatedList[i].annualImpact));
                                    businessImpact -= ((isNaN(relatedList[i].businessImpact) ? 0 : relatedList[i].businessImpact));   
                                    previousTPT -= ((isNaN(relatedList[i].previousTPT) ? 0 : relatedList[i].previousTPT));
                                    currentTPT -= ((isNaN(relatedList[i].currentTPT) ? 0 : relatedList[i].currentTPT));
                                    priceVarianceFamilySummary -= ((isNaN(relatedList[i].priceVariance) ? 0 : relatedList[i].priceVariance));
                                    volumeVarianceFamilySummary -= ((isNaN(relatedList[i].volumeVariance) ? 0 : relatedList[i].volumeVariance));
                                    totalPreviousAwdQtySummary -= ((isNaN(relatedList[i].previousQty) ? 0 : relatedList[i].previousQty));
                                    totalAwdQtySummary -= ((isNaN(relatedList[i].awardedQty) ? 0 : relatedList[i].awardedQty));   
                                }
                                    else{
                                        previousTotal += ((isNaN(relatedList[i].previousContractTotal) ? 0 : relatedList[i].previousContractTotal));
                                        currentTotal += ((isNaN(relatedList[i].currentContractTotal) ? 0 : relatedList[i].currentContractTotal));
                                        annualImpact += ((isNaN(relatedList[i].annualImpact) ? 0 : relatedList[i].annualImpact));
                                        businessImpact += ((isNaN(relatedList[i].businessImpact) ? 0 : relatedList[i].businessImpact));   
                                        previousTPT += ((isNaN(relatedList[i].previousTPT) ? 0 : relatedList[i].previousTPT));
                                        currentTPT += ((isNaN(relatedList[i].currentTPT) ? 0 : relatedList[i].currentTPT));
                                        priceVarianceFamilySummary += ((isNaN(relatedList[i].priceVariance) ? 0 : relatedList[i].priceVariance));
                                        volumeVarianceFamilySummary += ((isNaN(relatedList[i].volumeVariance) ? 0 : relatedList[i].volumeVariance));
                                        totalPreviousAwdQtySummary += ((isNaN(relatedList[i].previousQty) ? 0 : relatedList[i].previousQty));
                                        totalAwdQtySummary += ((isNaN(relatedList[i].awardedQty) ? 0 : relatedList[i].awardedQty));   
                                    }
                            }
                            totalPreviousQty += totalPreviousAwdQtySummary;
                            totalAwardedQty += totalAwdQtySummary;
                            totalPreviousTotal += previousTotal;
                            totalCurrentTotal += currentTotal;
                            totalAnnualImpact += annualImpact;
                            totalBusinessImpact += businessImpact;
                            totalCurrentTPT += currentTPT;
                            totalPreviousTPT += previousTPT;
                            totalPriceVariance += priceVarianceFamilySummary;
                            totalVolumeVariance += volumeVarianceFamilySummary;
                            total += annualImpact;
                            totalTPT = parseInt(currentTPT) - parseInt(previousTPT);
                            summary[0] = parseInt(previousTotal);
                            summary[1] = parseInt(currentTotal);
                            summary[2] = parseInt(annualImpact);
                            summary[3] = parseInt(businessImpact);
                            summary[4] = parseInt(previousTPT);
                            summary[5] = parseInt(currentTPT);
                            summary[6] = parseInt(currentTPT) - parseInt(previousTPT);
                            summary[7] = parseInt(priceVarianceFamilySummary);
                            summary[8] = parseInt(volumeVarianceFamilySummary);
                            summary[9] = ((!isFinite(previousTPT/previousTotal) ? 0 : (previousTPT/previousTotal)));
                            summary[10] = ((!isFinite(currentTPT/currentTotal) ? 0 : (currentTPT/currentTotal)));
                            summary[11] = parseInt(totalPreviousAwdQtySummary);
                            summary[12] = parseInt(totalAwdQtySummary);
                            totalFamilySummaryMap[rec.productFamily] = summary;
                        } else{
                            var relatedList = [];var summary = [];
                            relatedList.push(rec);
                            totalMap[rec.productFamily] = relatedList;
                            var previousTotal = ((isNaN(rec.previousContractTotal) ? 0 : rec.previousContractTotal));
                            var currentTotal = ((isNaN(rec.currentContractTotal) ? 0 : rec.currentContractTotal));
                            var annualImpact = ((isNaN(rec.annualImpact) ? 0 : rec.annualImpact));
                            var businessImpact = ((isNaN(rec.businessImpact) ? 0 : rec.businessImpact));
                            var previousTPT = ((isNaN(rec.previousTPT) ? 0 : rec.previousTPT));
                            var currentTPT = ((isNaN(rec.currentTPT) ? 0 : rec.currentTPT));
                            var priceVarianceFamilySummary = ((isNaN(rec.priceVariance) ? 0 : rec.priceVariance));
                            var volumeVarianceFamilySummary = ((isNaN(rec.volumeVariance) ? 0 : rec.volumeVariance));
                            var totalPreviousAwdQtySummary = ((isNaN(rec.previousQty) ? 0 : rec.previousQty));
                            var totalAwdQtySummary = ((isNaN(rec.awardedQty) ? 0 : rec.awardedQty));
                            if(rec.bidType != 'RFP' && (rec.bidStatus == 'Declined by Customer' || rec.bidStatus == 'DRL Rescinded' || rec.bidStatus == 'DRL submitting under New Bid Number')){
                            } else if(rec.bidType == 'RFP Bids' && (rec.bidStatus == 'Declined by Customer' || rec.bidStatus == 'DRL Rescinded')){
                                totalPreviousQty -= totalPreviousAwdQtySummary;
                                totalAwardedQty -= totalAwdQtySummary;
                                totalPreviousQty -= totalPreviousAwdQtySummary;
                                totalAwardedQty -= totalAwdQtySummary;
                                totalPreviousTotal -= previousTotal;
                                totalCurrentTotal -= currentTotal;
                                totalAnnualImpact -= annualImpact;
                                totalBusinessImpact -= businessImpact;
                                totalCurrentTPT -= currentTPT;
                                totalPreviousTPT -= previousTPT;
                                totalPriceVariance -= priceVarianceFamilySummary;
                                totalVolumeVariance -= volumeVarianceFamilySummary;
                                total -= annualImpact;
                                totalTPT = parseInt(currentTPT) - parseInt(previousTPT);  
                            }
                                else{
                                    totalPreviousQty += totalPreviousAwdQtySummary;
                                    totalAwardedQty += totalAwdQtySummary;
                                    totalPreviousQty += totalPreviousAwdQtySummary;
                                    totalAwardedQty += totalAwdQtySummary;
                                    totalPreviousTotal += previousTotal;
                                    totalCurrentTotal += currentTotal;
                                    totalAnnualImpact += annualImpact;
                                    totalBusinessImpact += businessImpact;
                                    totalCurrentTPT += currentTPT;
                                    totalPreviousTPT += previousTPT;
                                    totalPriceVariance += priceVarianceFamilySummary;
                                    totalVolumeVariance += volumeVarianceFamilySummary;
                                    total += annualImpact;
                                    totalTPT = parseInt(currentTPT) - parseInt(previousTPT);   
                                }
                            summary[0] = parseInt(previousTotal);
                            summary[1] = parseInt(currentTotal);
                            summary[2] = parseInt(annualImpact);
                            summary[3] = parseInt(businessImpact);
                            summary[4] = parseInt(previousTPT);
                            summary[5] = parseInt(currentTPT);
                            summary[6] = parseInt(currentTPT) - parseInt(previousTPT);
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
                    for(var i=0; i<keys.length; i++){
                        tempObj[keys[i]] = totalFamilySummaryMap[keys[i]];
                    }
                    totalFamilySummaryMap = tempObj;
                    tempObj = {};
                    
                    let sortedKeys = Object.keys(totalFamilySummaryMap);
                    for(var i=0; i<sortedKeys.length; i++){
                        tempObj[sortedKeys[i]] = totalMap[sortedKeys[i]];
                    }
                    totalMap = tempObj;
                    totalObj.totalPreviousQty = totalPreviousQty;
                    totalObj.totalAwardedQty = totalAwardedQty;
                    totalObj.totalPreviousTotal = totalPreviousTotal;
                    totalObj.totalCurrentTotal = totalCurrentTotal;
                    totalObj.totalCurrentTPT = parseInt(totalCurrentTPT);
                    totalObj.totalPreviousTPT =  parseInt(totalPreviousTPT);
                    totalObj.totalPriceVariance =  parseInt(totalPriceVariance);
                    totalObj.totalVolumeVariance =  parseInt(totalVolumeVariance);
                    totalObj.currentTPTPer = (!isFinite(totalObj.totalCurrentTPT/totalObj.totalCurrentTotal) ? 0 : (totalObj.totalCurrentTPT/totalObj.totalCurrentTotal));
                    totalObj.previousTPTPer = (!isFinite(totalObj.totalPreviousTPT/totalObj.totalPreviousTotal) ? 0 : (totalObj.totalPreviousTPT/totalObj.totalPreviousTotal));
                    
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
                    
                    /*component.set("v.gainedList", gain);
                component.set("v.lossList", lost);
                component.set("v.openStatusList", open);
                component.set("v.noEffectList", noEffect);*/
                    
                    component.set("v.totalFamilySummaryMap",totalFamilySummaryMap);
                    component.set("v.totalMap",Object.entries(totalMap));
                    component.set("v.scmDataList", scmDataList);
                    component.set("v.categoryTotals", totalObj);
                    component.set("v.isSpinnerLoad", false);
                    
                }
            }
            else{
                component.set("v.isSpinnerLoad", false);
                console.log("Error "+JSON.stringify(response.getError()));
                console.log('Exception Type: '+response.getError()[0].exceptionType);
            }
        });
        $A.enqueueAction(action);
    },
    dateBasedOn: function (component, event, helper){
        var selectedDate = event.getParam("value");
        component.set("v.selectedDate", selectedDate);
    },
})