({  
    buildData: function(component, event, helper){
        component.set("v.loaded", true);
        component.set("v.showConfetti", false);
        component.set("v.finalTier", null);
        component.set("v.showMessage", null);
        component.set("v.messageParam1", null);
        component.set("v.messageParam2", null);
        component.set("v.message", null);
        component.set("v.showInactiveMessage", false);
        component.set("v.currentRate", null);
        var action = component.get("c.getVIPRebateData");
        action.setParams({
            'customerId': component.get("v.recordId"),
            'rebateId': component.get("v.selectedVIPRebateRecord.Id")
        });
        action.setCallback(this, function(response){
            if(response.getState() == 'SUCCESS'){
                if(!response.getReturnValue().isProcessed){
                    component.set("v.isProcessed", true);
                    component.set("v.loaded", false);
                }
                else if(response.getReturnValue().isNull == false){
                    var wrapperObj = response.getReturnValue();
                    console.log('WrapperObj: '+JSON.stringify(wrapperObj));
                    console.log('::lostLineITems: '+JSON.stringify(wrapperObj.lostLineItems));
                    component.set("v.vipRebateData", wrapperObj.vipRebateData);
                    var vipRebateData = wrapperObj.vipRebateData;
                    var vipRebateDataSingle = wrapperObj.vipRebateDataSingle[0];
                    var rebateLinesData = wrapperObj.rebateLinesData;
                    if(rebateLinesData != null){
                        var finalTier = rebateLinesData[(rebateLinesData.length)-1];
                        component.set("v.finalTier", finalTier.Phoenix_Tier__c);
                        component.set("v.showConfetti", false);
                    }
                    component.set("v.selectedVIPRebate", vipRebateDataSingle.Id);
                    component.set('v.currentType', vipRebateDataSingle.Phoenix_Type__c);
                    component.set('v.frequency', vipRebateDataSingle.Payment_Frequency__c);
                    component.set("v.selectedVIPRebateRecord", vipRebateDataSingle);
                    component.set("v.startDate", new Date(vipRebateDataSingle.Phoenix_Start_Date__c).toLocaleDateString("en-US", { year: "numeric", month: "2-digit", day: "2-digit" }));
                    component.set("v.endDate", new Date(vipRebateDataSingle.Phoenix_End_Date__c).toLocaleDateString("en-US", { year: "numeric", month: "2-digit", day: "2-digit" }));
                    component.set("v.vipRebateTierData", rebateLinesData);
                    component.set("v.GCPUpdateDate", new Date(wrapperObj.gcpVIRRecord.Vision_GCP_Update_Date__c).toLocaleDateString("en-US", { year: "numeric", month: "2-digit", day: "2-digit" }));   
                    component.set("v.DataAvailableTill", new Date(wrapperObj.gcpVIRRecord.Vision_Data_Available_Till__c).toLocaleDateString("en-US", { year: "numeric", month: "2-digit", day: "2-digit" }));
                    component.set("v.VisionUpdateDate", new Date(wrapperObj.gcpVIRRecord.Vision_Update_Date__c).toLocaleDateString("en-US", { year: "numeric", month: "2-digit", day: "2-digit" }));
                    var frequency = component.get("v.frequency");
                    var currentType = component.get("v.currentType");
                    var actualSales = 0;
                    var actualUnits = 0;
                    component.set("v.loaded", false);
                    var items = [];
                    for (var i = 0; i < vipRebateData.length; i++) {
                        var option = {
                            "label": vipRebateData[i].Vision_Rebate_Contract__c,
                            "value": vipRebateData[i].Id
                        };
                        items.push(option);
                    }
                    component.set("v.options", items);
                    var data = wrapperObj.listOfFinalRecords;
                    var instanceBeforeNA = {}; var tierToHighlight;
                    let tiersMap = new Map();
                    if(data.length > 0){
                        var gcpDate; var DataAvailableTill; var VisionUpdateDate;
                        for(var i=0; i<data.length; i++){
                            if(data[i].GCPUpdateDate != null){
                                gcpDate = data[i].GCPUpdateDate;
                                DataAvailableTill = data[i].DataAvailableTill;
                                VisionUpdateDate = data[i].VisionUpdateDate;
                            }
                            actualSales = actualSales+data[i].sales;
                            data[i].actualSales = actualSales;
                            if(frequency == 'Annual'){
                                data[i].projectedSales = (actualSales*12)/(i+1);
                                data[i].frequency = 12;
                                /*if(i == (data.length)-1){
                                    data[i].projectedSales = data[i].projectedSales - 2000000;
                                }*/
                            } else if(frequency == 'Quarterly'){
                                data[i].projectedSales = (actualSales*3)/(i+1);
                                data[i].frequency = 3;
                            } else if(frequency == '6 Months'){
                                data[i].projectedSales = (actualSales*6)/(i+1);
                                data[i].frequency = 6;
                            }
                            for(var j=0; j<rebateLinesData.length; j++){
                                tiersMap[rebateLinesData[j].Phoenix_Tier__c] = rebateLinesData[j];
                                //tiersMap.set(rebateLinesData[j].Phoenix_Tier__c, rebateLinesData[j]);
                                if(data[i].projectedSales >= rebateLinesData[j].Phoenix_Dollar_Value_From__c){
                                    if(rebateLinesData[j].Phoenix_Dollar_Value_To__c != null && data[i].projectedSales <= rebateLinesData[j].Phoenix_Dollar_Value_To__c){
                                        data[i].projectedAttainment = rebateLinesData[j].Phoenix_Discount_Rebate__c;
                                        data[i].tier = rebateLinesData[j].Phoenix_Tier__c;
                                        data[i].isApplicableCurrent = true;
                                        break;
                                    } else {
                                        data[i].projectedAttainment = rebateLinesData[j].Phoenix_Discount_Rebate__c;
                                        data[i].tier = rebateLinesData[j].Phoenix_Tier__c;
                                        data[i].isApplicableCurrent = true;
                                    }
                                }
                                /*if(data[i].projectedSales >= rebateLinesData[j].Phoenix_Dollar_Value_From__c && data[i].projectedSales <= rebateLinesData[j].Phoenix_Dollar_Value_To__c){
                                //if(currentType == 'Currency' && data[i].projectedSales >= rebateLinesData[j].Phoenix_Dollar_Value_From__c && data[i].projectedSales <= rebateLinesData[j].Phoenix_Dollar_Value_To__c){
                                    data[i].projectedAttainment = rebateLinesData[j].Phoenix_Discount_Rebate__c;
                                    data[i].tier = rebateLinesData[j].Phoenix_Tier__c;
                                    data[i].isApplicableCurrent = true;
                                }
                                else if(currentType == 'Quantity' && data[i].projectedUnits >= rebateLinesData[j].Phoenix_Unit_Volume_From__c && data[i].projectedUnits <= rebateLinesData[j].Phoenix_Unit_Volume_To__c){
                                    data[i].projectedAttainment = rebateLinesData[j].Phoenix_Discount_Rebate__c;
                                    data[i].tier = rebateLinesData[j].Phoenix_Tier__c;
                                    data[i].isApplicableCurrent = true;
                                }*/ else{
                                    data[i].projectedAttainment = 'N/A';
                                    data[i].tier = 'N/A';
                                    data[i].isApplicableCurrent = false;
                                }
                            }
                            var finalTier = component.get("v.finalTier");
                            if(data[(data.length)-1].tier == finalTier){
                                component.set("v.showConfetti", true);
                            }
                        }
                        var tiers = [];
                        for(var i=(data.length)-1; i>=0;i--){
                            if(data[i].tier == 'N/A'){
                             	tiers.push(data[i].tier);   
                            }
                            if(data[i].tier != 'N/A' && i!= (data.length)-1 && data[i+1].tier == 'N/A'){
                                instanceBeforeNA.tier = data[i].tier;
                                instanceBeforeNA.projectedSales = data[i].projectedSales;
                                tierToHighlight = data[i].tier;
                                if(vipRebateDataSingle.Vision_Contract_Status__c == 'Active'){
                                    var dollarFrom = tiersMap[parseInt(data[i].tier)+1];
                                    var fromValue = dollarFrom.Phoenix_Dollar_Value_From__c;
                                    var calculationOne = (((fromValue*(i+1))/data[i].frequency) - data[i].actualSales) - data[i+1].sales;
                                    instanceBeforeNA.tier = data[i].tier;
                                    instanceBeforeNA.projectedSales = data[i].projectedSales;
                                    component.set("v.showMessage", true);
                                    component.set("v.messageParam1", calculationOne.toFixed(0));
                                    component.set("v.messageParam2", String((parseInt(instanceBeforeNA.tier) + 1)));
                                    component.set("v.currentRate", (calculationOne/4));
                                } else{
                                    component.set("v.showInactiveMessage", true);
                                    component.set("v.message", 'This contract is no more active.');
                                }
                                break;
                            } else if(data[i].tier == 'N/A' && i==0){
                                if(vipRebateDataSingle.Vision_Contract_Status__c == 'Active'){
                                    var fromValue = tiersMap[rebateLinesData[0].Phoenix_Tier__c].Phoenix_Dollar_Value_From__c;
                                    var calculationOne = (((fromValue*(i+1))/data[i].frequency) - 0) - data[i].sales;
                                    instanceBeforeNA.tier = data[i].tier;
                                    instanceBeforeNA.projectedSales = data[i].projectedSales;
                                    component.set("v.showMessage", true);
                                    component.set("v.messageParam1", calculationOne.toFixed(0));
                                    component.set("v.messageParam2", 'Tier 1');  
                                    component.set("v.currentRate", (calculationOne/4));
                                } 
                                else{
                                    component.set("v.showInactiveMessage", true);
                                    component.set("v.message", 'This contract is no more active.');
                                }
                                break;
                            } else if(data[i].tier != 'N/A' && i == (data.length)-1){
                                tierToHighlight = data[i].tier;
                                if(vipRebateDataSingle.Vision_Contract_Status__c != 'Active'){
                                    component.set("v.showInactiveMessage", true);
                                    component.set("v.message", 'This contract is no more active.');
                                }
                                break;
                            } else{
                                if(vipRebateDataSingle.Vision_Contract_Status__c != 'Active'){
                                    component.set("v.showInactiveMessage", true);
                                    component.set("v.message", 'This contract is no more active.');
                                }
                                //break;
                            }
                        }
                        if(tiers != null && (tiers.length == data.length)){
                            if(vipRebateDataSingle.Vision_Contract_Status__c == 'Active'){
                                var fromValue = tiersMap[rebateLinesData[0].Phoenix_Tier__c].Phoenix_Dollar_Value_From__c;
                                var calculationOne;
                                if(data[(data.length)-2] == undefined){
                                    calculationOne = (((fromValue*((data.length)+1))/12) - 0) - data[(data.length)-1].sales;
                                } else{
                                    calculationOne = (((fromValue*((data.length)+1))/12) - data[(data.length)-2].actualSales) - data[(data.length)-1].sales;   
                                }
                                component.set("v.showMessage", true);
                                component.set("v.messageParam1", calculationOne.toFixed(0));
                                component.set("v.messageParam2", 'Tier 1');
                                component.set("v.currentRate", (calculationOne/4));
                            } else{
                                component.set("v.showInactiveMessage", true);
                                component.set("v.message", 'This contract is no more active.');
                            }
                        }
                        var tierData = component.get("v.vipRebateTierData");
                        for(var i=0; i<tierData.length; i++){
                            if(tierData[i].Phoenix_Tier__c == tierToHighlight){
                                tierData[i].highlightTier = true;
                            } else{
                                tierData[i].highlightTier = false;
                            }
                        }
                        component.set("v.vipRebateTierData", tierData);
                        /*if(vipRebateDataSingle.Vision_Contract_Status__c == 'Inactive'){
                            for(var i=0; i<data.length;i++){
                                console.log('Ok: '+JSON.stringify(data[i]));
                                if(data[i].tier == 'N/A' && i!=0){
                                    instanceBeforeNA.tier = data[i-1].tier;
                                    instanceBeforeNA.projectedSales = data[i-1].projectedSales;
                                    break;
                                } else{
                                    console.log('You have not reached tier 1 yet');
                                    instanceBeforeNA.tier = 'No Tier';
                                    instanceBeforeNA.projectedSales = data[i].projectedSales;
                                    break;
                                }
                            }
                            if(instanceBeforeNA.tier != 'No Tier'){
                                var diff = tiersMap[parseInt(instanceBeforeNA.tier)+1].Phoenix_Dollar_Value_From__c - instanceBeforeNA.projectedSales;
                                component.set("v.showMessage", true);
                                component.set("v.message", 'You need '+diff+' more to reach the next tier('+(instanceBeforeNA.tier + 1)+')');   
                            } else{
                                var diff = tiersMap['1'].Phoenix_Dollar_Value_From__c - instanceBeforeNA.projectedSales;
                                component.set("v.showMessage", true);
                                component.set("v.message", 'You need '+diff+' more to reach Tier 1');
                            }
                        } else{
                            component.set("v.showMessage", true);
                            component.set("v.message", 'This contract is no more active.');                            
                        }*/
                    }
                    component.set("v.tableData", data);
                    if(data != null){
                        var updatedData = [];
                        console.log('Data: '+JSON.stringify(data));
                        for(var i=0; i<data.length; i++){
                            var record = data[i];
                            var totalPA = 0; var totalPC = 0; var totalVRO = 0; var totalNPL = 0; var totalLoss = 0;
                            var listPA = record.listOfPA;
                            var listPC = record.listOfPC;
                            var listVRO = record.listOfVRO;
                            var listNPL = record.listOfNPL;
                            var listLoss = record.listOfProductLoss;
                            if(listPA != null){
                                for(var j=0; j<listPA.length; j++){
                                    if(listPA[j].lineItem.hasOwnProperty('Customer_Response_Lines__r') && listPA[j].lineItem.Customer_Response_Lines__r){
                                        var d;
                                        if(listPA[j].lineItem.hasOwnProperty('Phoenix_Estimated_Lead_Time_Days__c') && listPA[j].lineItem.Phoenix_Estimated_Lead_Time_Days__c != null){
                                            //console.log('Product: '+listPA[j].lineItem.Phoenix_Product__r.Name);
                                            //console.log('Supply Effective Date: '+listPA[j].lineItem.Customer_Response_Lines__r[0].Phoenix_Supply_Effective_Date__c);
                                            d = new Date(String(listPA[j].lineItem.Customer_Response_Lines__r[0].Phoenix_Supply_Effective_Date__c));
                                        } else if(listPA[j].lineItem.Customer_Response_Lines__r[0].Phoenix_Price_Effective_Date__c != null){
                                            d = new Date(String(listPA[j].lineItem.Customer_Response_Lines__r[0].Phoenix_Price_Effective_Date__c));
                                        } else{
                                            d = new Date(String(listPA[j].lineItem.Customer_Response_Lines__r[0].Phoenix_Customer_Reponse_Date__c));
                                        }
                                        listPA[j].lineItem.formattedEffectiveDate = new Date(d).toLocaleDateString("en-US", { year: "numeric", month: "2-digit", day: "2-digit" });
                                        var fiscalyear = '';
                                        if ((d.getMonth() + 1) <= 3) {
                                            fiscalyear = d.getFullYear();
                                        } else {
                                            fiscalyear = d.getFullYear() + 1;
                                        }
                                        //var endDate = new Date();
                                        //var date = new Date(endDate.setMonth(remainingMnths+1));
                                        //console.log('fiscalyear: '+fiscalyear);
                                        var endDateOfFiscalYear = new Date(fiscalyear, 2, 31);
                                        //console.log('endDateOfFiscalYear: '+endDateOfFiscalYear);
                                        var monthsRemaining = 0;
                                        //calculate time difference  
                                        var time_difference = endDateOfFiscalYear.getTime() - d.getTime(); 
                                        
                                        //calculate days difference by dividing total milliseconds in a day  
                                        var days_difference = time_difference / (1000 * 60 * 60 * 24);
                                        //console.log('days_difference: '+days_difference);
                                        monthsRemaining = (days_difference/365)*12;
                                        
                                        var annualImpact = 0;
                                        listPA[j].currentDeadnet = 0;
                                        listPA[j].previousQty = 0;
                                        var previousSales = (listPA[j].currentDeadnet * listPA[j].previousQty);
                                        var proposedSales = (listPA[j].proposedDeadnet * listPA[j].awardedQty);
                                        listPA[j].previousSales = ((isNaN(previousSales)) ? 0 : previousSales);
                                        listPA[j].proposedSales = ((isNaN(proposedSales)) ? 0 : proposedSales);
                                        annualImpact = (listPA[j].proposedSales - listPA[j].previousSales);
                                        totalPA += ((isNaN(annualImpact)) ? 0 : annualImpact);
                                    }
                                }
                            }
                            if(listPC != null){
                                for(var j=0; j<listPC.length; j++){
                                    if(listPC[j].lineItem.hasOwnProperty('Customer_Response_Lines__r') && listPC[j].lineItem.Customer_Response_Lines__r){
                                        var d;
                                        if(listPC[j].lineItem.hasOwnProperty('Phoenix_Estimated_Lead_Time_Days__c') && listPC[j].lineItem.Phoenix_Estimated_Lead_Time_Days__c != null){
                                            d = new Date(listPC[j].lineItem.Customer_Response_Lines__r[0].Phoenix_Supply_Effective_Date__c);   
                                        } else if(listPC[j].lineItem.Customer_Response_Lines__r[0].Phoenix_Price_Effective_Date__c != null){
                                            d = new Date(listPC[j].lineItem.Customer_Response_Lines__r[0].Phoenix_Price_Effective_Date__c);
                                        } else{
                                            d = new Date(listPC[j].lineItem.Customer_Response_Lines__r[0].Phoenix_Customer_Reponse_Date__c);
                                        }
                                        listPC[j].lineItem.formattedEffectiveDate = new Date(d).toLocaleDateString("en-US", { year: "numeric", month: "2-digit", day: "2-digit" });
                                        var fiscalyear = '';
                                        if ((d.getMonth() + 1) <= 3) {
                                            fiscalyear = d.getFullYear();
                                        } else {
                                            fiscalyear = d.getFullYear() + 1;
                                        }
                                        //var endDate = new Date();
                                        //var date = new Date(endDate.setMonth(remainingMnths+1));
                                        var endDateOfFiscalYear = new Date(fiscalyear, 2, 31);
                                        var monthsRemaining = 0;
                                        //calculate time difference  
                                        var time_difference = endDateOfFiscalYear.getTime() - d.getTime(); 
                                        
                                        //calculate days difference by dividing total milliseconds in a day  
                                        var days_difference = time_difference / (1000 * 60 * 60 * 24);
                                        monthsRemaining = (days_difference/365)*12;
                                        var annualImpact = 0;
                                        var previousSales = (listPC[j].currentDeadnet * listPC[j].previousQty);
                                        var proposedSales = (listPC[j].proposedDeadnet * listPC[j].awardedQty);
                                        listPC[j].previousSales = ((isNaN(previousSales)) ? 0 : previousSales);
                                        listPC[j].proposedSales = ((isNaN(proposedSales)) ? 0 : proposedSales);
                                        annualImpact = (listPC[j].proposedSales - listPC[j].previousSales);
                                        totalPC += ((isNaN(annualImpact)) ? 0 : annualImpact);
                                    }
                                }
                            }
                            if(listVRO != null){
                                for(var j=0; j<listVRO.length; j++){
                                    if(listVRO[j].lineItem.hasOwnProperty('Customer_Response_Lines__r') && listVRO[j].lineItem.Customer_Response_Lines__r){
                                        var d;
                                        if(listVRO[j].lineItem.hasOwnProperty('Phoenix_Estimated_Lead_Time_Days__c') && listVRO[j].lineItem.Phoenix_Estimated_Lead_Time_Days__c != null){
                                            d = new Date(listVRO[j].lineItem.Customer_Response_Lines__r[0].Phoenix_Supply_Effective_Date__c);   
                                        } else if(listVRO[j].lineItem.Customer_Response_Lines__r[0].Phoenix_Price_Effective_Date__c != null){
                                            d = new Date(listVRO[j].lineItem.Customer_Response_Lines__r[0].Phoenix_Price_Effective_Date__c);
                                        } else{
                                            d = new Date(listVRO[j].lineItem.Customer_Response_Lines__r[0].Phoenix_Customer_Reponse_Date__c);
                                        }
                                        listVRO[j].lineItem.formattedEffectiveDate = new Date(d).toLocaleDateString("en-US", { year: "numeric", month: "2-digit", day: "2-digit" });
                                        var fiscalyear = '';
                                        if ((d.getMonth() + 1) <= 3) {
                                            fiscalyear = d.getFullYear();
                                        } else {
                                            fiscalyear = d.getFullYear() + 1;
                                        }
                                        //var endDate = new Date();
                                        //var date = new Date(endDate.setMonth(remainingMnths+1));
                                        var endDateOfFiscalYear = new Date(fiscalyear, 2, 31);
                                        var monthsRemaining = 0;
                                        //calculate time difference  
                                        var time_difference = endDateOfFiscalYear.getTime() - d.getTime(); 
                                        
                                        //calculate days difference by dividing total milliseconds in a day  
                                        var days_difference = time_difference / (1000 * 60 * 60 * 24);
                                        monthsRemaining = (days_difference/365)*12;
                                        
                                        var annualImpact = 0;
                                        var previousSales = (listVRO[j].currentDeadnet * listVRO[j].previousQty);
                                        var proposedSales = (listVRO[j].proposedDeadnet * listVRO[j].awardedQty);
                                        listVRO[j].previousSales = ((isNaN(previousSales)) ? 0 : previousSales);
                                        listVRO[j].proposedSales = ((isNaN(proposedSales)) ? 0 : proposedSales);
                                        annualImpact = (listVRO[j].proposedSales - listVRO[j].previousSales);
                                        totalVRO += ((isNaN(annualImpact)) ? 0 : annualImpact);
                                    }
                                }
                            }
                            if(listNPL != null){
                                for(var j=0; j<listNPL.length; j++){
                                    if(listNPL[j].lineItem.hasOwnProperty('Customer_Response_Lines__r') && listNPL[j].lineItem.Customer_Response_Lines__r){
                                        var d;
                                        if(listNPL[j].lineItem.hasOwnProperty('Phoenix_Estimated_Lead_Time_Days__c') && listNPL[j].lineItem.Phoenix_Estimated_Lead_Time_Days__c != null){
                                            d = new Date(listNPL[j].lineItem.Customer_Response_Lines__r[0].Phoenix_Supply_Effective_Date__c);   
                                        } else if(listNPL[j].lineItem.Customer_Response_Lines__r[0].Phoenix_Price_Effective_Date__c != null){
                                            d = new Date(listNPL[j].lineItem.Customer_Response_Lines__r[0].Phoenix_Price_Effective_Date__c);
                                        } else{
                                            d = new Date(listNPL[j].lineItem.Customer_Response_Lines__r[0].Phoenix_Customer_Reponse_Date__c);
                                        }
                                        listNPL[j].lineItem.formattedEffectiveDate = new Date(d).toLocaleDateString("en-US", { year: "numeric", month: "2-digit", day: "2-digit" });
                                        var fiscalyear = '';
                                        if ((d.getMonth() + 1) <= 3) {
                                            fiscalyear = d.getFullYear();
                                        } else {
                                            fiscalyear = d.getFullYear() + 1;
                                        }
                                        //var endDate = new Date();
                                        //var date = new Date(endDate.setMonth(remainingMnths+1));
                                        var endDateOfFiscalYear = new Date(fiscalyear, 2, 31);
                                        var monthsRemaining = 0;
                                        //calculate time difference  
                                        var time_difference = endDateOfFiscalYear.getTime() - d.getTime(); 
                                        
                                        //calculate days difference by dividing total milliseconds in a day  
                                        var days_difference = time_difference / (1000 * 60 * 60 * 24);
                                        monthsRemaining = (days_difference/365)*12;
                                        
                                        var annualImpact = 0;
                                        var previousSales = (listNPL[j].currentDeadnet * listNPL[j].previousQty);
                                        var proposedSales = (listNPL[j].proposedDeadnet * listNPL[j].awardedQty);
                                        listNPL[j].previousSales = ((isNaN(previousSales)) ? 0 : previousSales);
                                        listNPL[j].proposedSales = ((isNaN(proposedSales)) ? 0 : proposedSales);
                                        annualImpact = (listNPL[j].proposedSales - listNPL[j].previousSales);
                                        totalNPL += ((isNaN(annualImpact)) ? 0 : annualImpact);
                                    }
                                }
                            }
                            if(listLoss != null){
                                for(var j=0; j<listLoss.length; j++){
                                    if(listLoss[j].lineItem.hasOwnProperty('BidLineItemsExtn__r') && listLoss[j].lineItem.BidLineItemsExtn__r){
                                        var d = new Date(listLoss[j].removalEffectiveDate);
                                        console.log('Ddate: '+listLoss[j].removalEffectiveDate);
                                        listLoss[j].lineItem.formattedEffectiveDate = new Date(d).toLocaleDateString("en-US", { year: "numeric", month: "2-digit", day: "2-digit" });
                                        var fiscalyear = '';
                                        if ((d.getMonth() + 1) <= 3) {
                                            fiscalyear = d.getFullYear();
                                        } else {
                                            fiscalyear = d.getFullYear() + 1;
                                        }
                                        //var endDate = new Date();
                                        //var date = new Date(endDate.setMonth(remainingMnths+1));
                                        var endDateOfFiscalYear = new Date(fiscalyear, 2, 31);
                                        var monthsRemaining = 0;
                                        //calculate time difference  
                                        var time_difference = endDateOfFiscalYear.getTime() - d.getTime(); 
                                        
                                        //calculate days difference by dividing total milliseconds in a day  
                                        var days_difference = time_difference / (1000 * 60 * 60 * 24);
                                        monthsRemaining = (days_difference/365)*12;
                                        
                                        var annualImpact = 0;
                                        var previousSales = (listLoss[j].previousDeadnet * listLoss[j].previousQty);
                                        listLoss[j].previousSales = ((isNaN(previousSales)) ? 0 : previousSales);
                                        listLoss[j].proposedSales = 0;
                                        listLoss[j].lineItem.monthsRemaining = monthsRemaining;
                                        annualImpact = (listLoss[j].proposedSales - listLoss[j].previousSales);
                                        totalLoss += ((isNaN(annualImpact)) ? 0 : annualImpact);
                                        listLoss[j].lineItem.annualImpact = parseInt(annualImpact);
                                        listLoss[j].lineItem.businessImpact = ((annualImpact*monthsRemaining)/12);
                                    }
                                }
                            }
                            record.countOfPA = parseInt(totalPA);
                            record.countOfPC= parseInt(totalPC);
                            record.countOfNPL = parseInt(totalNPL);
                            record.countOfVRO = parseInt(totalVRO);
                            record.countOfLoss = parseInt(totalLoss);
                            var totalProjectedSales = data[i].projectedSales + record.countOfPA + record.countOfPC + record.countOfNPL + record.countOfVRO + record.countOfLoss;
                            record.totalProjectedSales = totalProjectedSales;
                                                     
                            
                            for(var j=0; j<rebateLinesData.length; j++){
                                if(data[i].totalProjectedSales >= rebateLinesData[j].Phoenix_Dollar_Value_From__c){
                                    if(rebateLinesData[j].Phoenix_Dollar_Value_To__c != null && data[i].totalProjectedSales <= rebateLinesData[j].Phoenix_Dollar_Value_To__c){
                                        data[i].tier2 = rebateLinesData[j].Phoenix_Tier__c;
                                        break;
                                    } else{
                                        data[i].tier2 = rebateLinesData[j].Phoenix_Tier__c;;
                                    }
                                } else{
                                    data[i].tier2 = 'N/A';
                                }
                            }
                            updatedData.push(record);
                        }
                        component.set("v.tableData", updatedData);
                    }   
                } else{
                    component.set("v.noRebates", true);
                    component.set("v.loaded", false);
                }
            } 
            else{
                component.set("v.noRebates", true);
                component.set("v.loaded", false);
                console.log("Error "+JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);
    },
    
    calculationHelper: function(component, event, helper, record){
        var totalPA = 0; var totalPC = 0; var totalVRO = 0; var totalNPL = 0; var totalLoss = 0;
        var listPA = record.listOfPA;
        var listPC = record.listOfPC;
        var listVRO = record.listOfVRO;
        var listNPL = record.listOfNPL;
        var listLoss = record.listOfProductLoss;
        if(listPA != null){
            for(var j=0; j<listPA.length; j++){
                if(listPA[j].lineItem.Customer_Response_Lines__r){
                    var d;
                    if(listPA[j].lineItem.hasOwnProperty('Phoenix_Estimated_Lead_Time_Days__c') && listPA[j].lineItem.Phoenix_Estimated_Lead_Time_Days__c != null){
                        d = new Date(listPA[j].lineItem.Customer_Response_Lines__r[0].Phoenix_Supply_Effective_Date__c);   
                    } else if(listPA[j].lineItem.Customer_Response_Lines__r[0].Phoenix_Price_Effective_Date__c != null){
                        d = new Date(listPA[j].lineItem.Customer_Response_Lines__r[0].Phoenix_Price_Effective_Date__c);
                    } else{
                        d = new Date(listPA[j].lineItem.Customer_Response_Lines__r[0].Phoenix_Customer_Reponse_Date__c);
                    }
                    listPA[j].lineItem.formattedEffectiveDate = new Date(d).toLocaleDateString("en-US", { year: "numeric", month: "2-digit", day: "2-digit" });
                    var fiscalyear = '';
                    if ((d.getMonth() + 1) <= 3) {
                        fiscalyear = d.getFullYear();
                    } else {
                        fiscalyear = d.getFullYear() + 1;
                    }
                    //var endDate = new Date();
                    //var date = new Date(endDate.setMonth(remainingMnths+1));
                    var endDateOfFiscalYear = new Date(fiscalyear, 2, 31);
                    var monthsRemaining = 0;
                    //calculate time difference  
                    var time_difference = endDateOfFiscalYear.getTime() - d.getTime(); 
                    
                    //calculate days difference by dividing total milliseconds in a day  
                    var days_difference = time_difference / (1000 * 60 * 60 * 24);
                    monthsRemaining = (days_difference/365)*12;
                    
                    var annualImpact = 0;
                    listPA[j].previousDeadnet = 0;
                    listPA[j].previousQty = 0;
                    var previousSales = (listPA[j].previousDeadnet * listPA[j].previousQty);
                    var proposedSales = (listPA[j].proposedDeadnet * listPA[j].awardedQty);
                    listPA[j].previousSales = previousSales;
                    listPA[j].proposedSales = proposedSales;
                    annualImpact = (proposedSales - previousSales);
                    totalPA += ((isNaN(annualImpact)) ? 0 : annualImpact);
                }
            }
        }
        if(listPC != null){
            for(var j=0; j<listPC.length; j++){
                if(listPC[j].lineItem.Customer_Response_Lines__r){
                    var d;
                    if(listPC[j].lineItem.hasOwnProperty('Phoenix_Estimated_Lead_Time_Days__c') && listPC[j].lineItem.Phoenix_Estimated_Lead_Time_Days__c != null){
                        d = new Date(listPC[j].lineItem.Customer_Response_Lines__r[0].Phoenix_Supply_Effective_Date__c);   
                    } else if(listPC[j].lineItem.Customer_Response_Lines__r[0].Phoenix_Price_Effective_Date__c != null){
                        d = new Date(listPC[j].lineItem.Customer_Response_Lines__r[0].Phoenix_Price_Effective_Date__c);
                    } else{
                        d = new Date(listPC[j].lineItem.Customer_Response_Lines__r[0].Phoenix_Customer_Reponse_Date__c);
                    }
                    listPC[j].lineItem.formattedEffectiveDate = new Date(d).toLocaleDateString("en-US", { year: "numeric", month: "2-digit", day: "2-digit" });
                    var fiscalyear = '';
                    if ((d.getMonth() + 1) <= 3) {
                        fiscalyear = d.getFullYear();
                    } else {
                        fiscalyear = d.getFullYear() + 1;
                    }
                    //var endDate = new Date();
                    //var date = new Date(endDate.setMonth(remainingMnths+1));
                    var endDateOfFiscalYear = new Date(fiscalyear, 2, 31);
                    var monthsRemaining = 0;
                    //calculate time difference  
                    var time_difference = endDateOfFiscalYear.getTime() - d.getTime(); 
                    
                    //calculate days difference by dividing total milliseconds in a day  
                    var days_difference = time_difference / (1000 * 60 * 60 * 24);
                    monthsRemaining = (days_difference/365)*12;
                    var annualImpact = 0;
                    var previousSales = (listPC[j].previousDeadnet * listPC[j].previousQty);
                    var proposedSales = (listPC[j].proposedDeadnet * listPC[j].awardedQty);
                    listPC[j].previousSales = previousSales;
                    listPC[j].proposedSales = proposedSales;
                    annualImpact = (proposedSales - previousSales);
                    totalPC += ((isNaN(annualImpact)) ? 0 : annualImpact);
                }
            }
        }
        if(listVRO != null){
            for(var j=0; j<listVRO.length; j++){
                if(listVRO[j].lineItem.Customer_Response_Lines__r){
                    var d;
                    if(listVRO[j].lineItem.hasOwnProperty('Phoenix_Estimated_Lead_Time_Days__c') && listVRO[j].lineItem.Phoenix_Estimated_Lead_Time_Days__c != null){
                        d = new Date(listVRO[j].lineItem.Customer_Response_Lines__r[0].Phoenix_Supply_Effective_Date__c);   
                    } else if(listVRO[j].lineItem.Customer_Response_Lines__r[0].Phoenix_Price_Effective_Date__c != null){
                        d = new Date(listVRO[j].lineItem.Customer_Response_Lines__r[0].Phoenix_Price_Effective_Date__c);
                    } else{
                        d = new Date(listVRO[j].lineItem.Customer_Response_Lines__r[0].Phoenix_Customer_Reponse_Date__c);
                    }
                    listVRO[j].lineItem.formattedEffectiveDate = new Date(d).toLocaleDateString("en-US", { year: "numeric", month: "2-digit", day: "2-digit" });
                    var fiscalyear = '';
                    if ((d.getMonth() + 1) <= 3) {
                        fiscalyear = d.getFullYear();
                    } else {
                        fiscalyear = d.getFullYear() + 1;
                    }
                    //var endDate = new Date();
                    //var date = new Date(endDate.setMonth(remainingMnths+1));
                    var endDateOfFiscalYear = new Date(fiscalyear, 2, 31);
                    var monthsRemaining = 0;
                    //calculate time difference  
                    var time_difference = endDateOfFiscalYear.getTime() - d.getTime(); 
                    
                    //calculate days difference by dividing total milliseconds in a day  
                    var days_difference = time_difference / (1000 * 60 * 60 * 24);
                    monthsRemaining = (days_difference/365)*12;
                    
                    var annualImpact = 0;
                    var previousSales = (listVRO[j].previousDeadnet * listVRO[j].previousQty);
                    var proposedSales = (listVRO[j].proposedDeadnet * listVRO[j].awardedQty);
                    listVRO[j].previousSales = previousSales;
                    listVRO[j].proposedSales = proposedSales;
                    annualImpact = (proposedSales - previousSales);
                    totalVRO += ((isNaN(annualImpact)) ? 0 : annualImpact);
                }
            }
        }
        if(listNPL != null){
            for(var j=0; j<listNPL.length; j++){
                if(listNPL[j].lineItem.Customer_Response_Lines__r){
                    var d;
                    if(listNPL[j].lineItem.hasOwnProperty('Phoenix_Estimated_Lead_Time_Days__c') && listNPL[j].lineItem.Phoenix_Estimated_Lead_Time_Days__c != null){
                        d = new Date(listNPL[j].lineItem.Customer_Response_Lines__r[0].Phoenix_Supply_Effective_Date__c);   
                    } else if(listNPL[j].lineItem.Customer_Response_Lines__r[0].Phoenix_Price_Effective_Date__c != null){
                        d = new Date(listNPL[j].lineItem.Customer_Response_Lines__r[0].Phoenix_Price_Effective_Date__c);
                    } else{
                        d = new Date(listNPL[j].lineItem.Customer_Response_Lines__r[0].Phoenix_Customer_Reponse_Date__c);
                    }
                    listNPL[j].lineItem.formattedEffectiveDate = new Date(d).toLocaleDateString("en-US", { year: "numeric", month: "2-digit", day: "2-digit" });
                    var fiscalyear = '';
                    if ((d.getMonth() + 1) <= 3) {
                        fiscalyear = d.getFullYear();
                    } else {
                        fiscalyear = d.getFullYear() + 1;
                    }
                    //var endDate = new Date();
                    //var date = new Date(endDate.setMonth(remainingMnths+1));
                    var endDateOfFiscalYear = new Date(fiscalyear, 2, 31);
                    var monthsRemaining = 0;
                    //calculate time difference  
                    var time_difference = endDateOfFiscalYear.getTime() - d.getTime(); 
                    
                    //calculate days difference by dividing total milliseconds in a day  
                    var days_difference = time_difference / (1000 * 60 * 60 * 24);
                    monthsRemaining = (days_difference/365)*12;
                    
                    var annualImpact = 0;
                    var previousSales = (listNPL[j].previousDeadnet * listNPL[j].previousQty);
                    var proposedSales = (listNPL[j].proposedDeadnet * listNPL[j].awardedQty);
                    listNPL[j].previousSales = previousSales;
                    listNPL[j].proposedSales = proposedSales;
                    annualImpact = (proposedSales - previousSales);
                    totalNPL += ((isNaN(annualImpact)) ? 0 : annualImpact);
                }
            }
        }
        if(listLoss != null){
            for(var j=0; j<listLoss.length; j++){
                if(listLoss[j].lineItem.hasOwnProperty('BidLineItemsExtn__r') && listLoss[j].lineItem.BidLineItemsExtn__r){
                    var d = new Date(listLoss[j].removalEffectiveDate);
                    console.log('Ddate: '+listLoss[j].removalEffectiveDate);
                    listLoss[j].lineItem.formattedEffectiveDate = new Date(d).toLocaleDateString("en-US", { year: "numeric", month: "2-digit", day: "2-digit" });
                    var fiscalyear = '';
                    if ((d.getMonth() + 1) <= 3) {
                        fiscalyear = d.getFullYear();
                    } else {
                        fiscalyear = d.getFullYear() + 1;
                    }
                    //var endDate = new Date();
                    //var date = new Date(endDate.setMonth(remainingMnths+1));
                    var endDateOfFiscalYear = new Date(fiscalyear, 2, 31);
                    var monthsRemaining = 0;
                    //calculate time difference  
                    var time_difference = endDateOfFiscalYear.getTime() - d.getTime(); 
                    
                    //calculate days difference by dividing total milliseconds in a day  
                    var days_difference = time_difference / (1000 * 60 * 60 * 24);
                    monthsRemaining = (days_difference/365)*12;
                    
                    var annualImpact = 0;
                    var previousSales = (listLoss[j].previousDeadnet * listLoss[j].previousQty);
                    listLoss[j].previousSales = ((isNaN(previousSales)) ? 0 : previousSales);
                    listLoss[j].proposedSales = 0;
                    listLoss[j].monthsRemaining = monthsRemaining;
                    annualImpact = (listLoss[j].proposedSales - listLoss[j].previousSales);
                    totalLoss += ((isNaN(annualImpact)) ? 0 : annualImpact);
                    listLoss[j].lineItem.annualImpact = parseInt(annualImpact);
                    listLoss[j].lineItem.businessImpact = ((annualImpact*monthsRemaining)/12);
                    totalLoss += ((isNaN(annualImpact)) ? 0 : annualImpact);
                }
            }
        }
        record.totalPA = totalPA;
        record.totalPC= totalPC;
        record.totalNPL = totalNPL;
        record.totalVRO = totalVRO;
        record.totalLoss = totalLoss;
        return record;
    }
    /*generateChart: function(component, event, helper, labels, maxVal){
        var chartObj = component.get("v.chartObj");
        var el = component.find('chart1').getElement();
        var ctx1 = el.getContext('2d');
        if(chartObj){
            chartObj.destroy();
        }
        chartObj = new Chart(ctx1, {
            type: 'line',
            data: {
                labels: labels,
                datasets: [
                    {
                        label: component.get("v.label1"),
                        borderColor: 'rgba(237, 125, 49)',
                        backgroundColor:'rgba(237, 125, 49, 0.2)',
                        fill: false,
                        data: component.get("v.chartDataCurrent"),
                    },
                    {
                        label: component.get("v.label2"),
                        backgroundColor:'rgba(63, 37, 133, 0.2)',
                        borderColor: 'rgb(63, 37, 133)',
                        fill: false,
                        data: component.get("v.chartDataPrevious") 
                    }
                ]
            },
            options: {
                hover: {
                    mode: "none"
                },
                tooltips: {
                    callbacks: {
                        label: function(tooltipItems) {
                            let label = new Intl.NumberFormat('en-US', {
                                minimumFractionDigits: 0,
                                maximumFractionDigits: 0
                            }).format(tooltipItems.yLabel);
                            return label;
                        },
                    }
                },
                legend: {
                    labels:{
                        fontStyle: 'bold'
                    }
                },
                scales: {
                    yAxes: [{
                        ticks: {
                            beginAtZero:true,
                            fontStyle: 'bold'
                        },
                        scaleLabel: {
                            display: true,
                            labelString: component.get("v.label"),
                            fontStyle: 'bold',
                            fontSize: 14
                        }
                    }],
                    xAxes: [{
                        ticks: {
                            beginAtZero:true,
                            fontStyle: 'bold'
                        },
                        scaleLabel: {
                            display: true,
                            labelString: 'Months',
                            fontStyle: 'bold',
                            fontSize: 14
                        }
                    }]
                    
                }
            },
            //plugins:[pluginTrendlineLinear],
        });
        component.set("v.chartObj",chartObj);
    }*/
})