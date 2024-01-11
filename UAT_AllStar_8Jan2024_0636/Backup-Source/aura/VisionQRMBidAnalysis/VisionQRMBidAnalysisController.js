({
    doInit: function(component, event, helper){
        var today = new Date();
        today = today.toLocaleString('en-US', {
                timeZone: 'America/New_York',
            });
        today = new Date(today);
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
        var qList = [];
        //qList.push(currentPreviousQuarter);
        for(var i=parseInt(currentPreviousQuarter[1]); i<=4; i++){
            var quarterString = 'Q'+i;
            qList.push(quarterString);
        }
        for(var i=0; i<parseInt(currentPreviousQuarter[1]); i++){
            var quarterString = 'Q'+(i+1);
            qList.push(quarterString);
        }
        var foundQ4 = false; var finalList = [];
        for(var i=(qList.length-1); i>=0; i--){
            var obj ={};
            var yearString;
            if(foundQ4 == false && String(qList[i])[1] == 4){
                foundQ4 = true;
                yearString = String(year);
                obj.label = qList[i]+' FY'+yearString.charAt(yearString.length-2)+yearString.charAt(yearString.length-1);
                obj.value = qList[i]+' FY'+yearString;
                finalList.push(obj);
            } else if(foundQ4 && String(qList[i])[1] == 4){
                yearString = String(year-1);
                obj.label = qList[i]+' FY'+yearString.charAt(yearString.length-2)+yearString.charAt(yearString.length-1);
                obj.value = qList[i]+' FY'+yearString;
                finalList.push(obj);
            } else if((i == (qList.length-1)) || foundQ4 == false) {
                yearString = String(year+1);
                obj.label = qList[i]+' FY'+yearString.charAt(yearString.length-2)+yearString.charAt(yearString.length-1);
                obj.value = qList[i]+' FY'+yearString;
                finalList.push(obj);                 
            } else{
                yearString = String(year);
                obj.label = qList[i]+' FY'+yearString.charAt(yearString.length-2)+yearString.charAt(yearString.length-1);
                obj.value = qList[i]+' FY'+yearString;
                finalList.push(obj);                
            }
        }
        
        console.log('Final List: '+JSON.stringify(finalList));
        console.log('Final List Reversed: '+JSON.stringify(finalList.reverse()));
        component.set("v.quarters", finalList.reverse());
        
        // Get the current date
        const currentDate1 = new Date();
        
        // Determine the current fiscal year and quarter
        let fiscalYear1, currentQuarter1;
        
        if (currentDate1.getMonth() < 3) {
            fiscalYear1 = currentDate1.getFullYear() - 1;
            currentQuarter1 = Math.ceil((currentDate1.getMonth() + 1 + 9) / 3);
        } else {
            fiscalYear1 = currentDate1.getFullYear();
            currentQuarter1 = Math.ceil((currentDate1.getMonth() + 1 - 3) / 3);
        }
        
        // Calculate the starting quarter for the last five fiscal quarters
        let startQuarter = currentQuarter1 - 5;
        let startYear = currentDate1.getFullYear();
        
        // Adjust the starting quarter and year if necessary
        if (startQuarter <= 0) {
            startQuarter += 4;
            startYear--;
        }
        
        // Store the last five fiscal quarters
        const lastFiveQuarters = [];
        
        for (let i = 0; i < 5; i++) {
            var tempStringYear = String(startYear);
            lastFiveQuarters.push({
                label: 'Q'+startQuarter+' FY'+tempStringYear.charAt(tempStringYear.length-2)+tempStringYear.charAt(tempStringYear.length-1),
                value: 'Q'+startQuarter+' FY'+startYear,
            });
            
            // Update the starting quarter and year for the next iteration
            startQuarter++;
            if (startQuarter > 4) {
                startQuarter = 1;
                startYear++;
            }
        }
        component.set("v.quarters", lastFiveQuarters);
        console.log('lastFiveQuarters:'+JSON.stringify(lastFiveQuarters));
        
    },
    timeSeriesData: function(component, event, helper){
        component.set("v.Quarter1", null);
        component.set("v.Quarter2", null);
        component.set("v.Quarter3", null);
        component.set("v.Quarter4", null);
        component.set("v.Quarter5", null);
        var quartersList = component.get("v.quarters");
        for(var i=0; i<quartersList.length; i++){
            var quarter = quartersList[i].value;
            var QuarterSplit = quarter.split(' ')[0];
            var QuarterYear = (quarter.split(' ')[1]).split('FY')[1];
            var FromDate; var ToDate;
            if(QuarterSplit == 'Q1'){
                FromDate = new Date(parseInt(QuarterYear-1), 3, 1);
                ToDate = new Date(parseInt(QuarterYear-1), 5, 30);
            } else if(QuarterSplit == 'Q2'){
                FromDate = new Date(parseInt(QuarterYear-1), 6, 1);
                ToDate = new Date(parseInt(QuarterYear-1), 8, 30);
            } else if(QuarterSplit == 'Q3'){
                FromDate = new Date(parseInt(QuarterYear-1), 9, 1);
                ToDate = new Date(parseInt(QuarterYear-1), 11, 31);
            } else if(QuarterSplit == 'Q4'){
                FromDate = new Date(parseInt(QuarterYear), 0, 1);
                ToDate = new Date(parseInt(QuarterYear), 2, 31);
            }
            FromDate = FromDate.toLocaleString('en-US', {
                timeZone: 'America/New_York',
            });
            FromDate = new Date(FromDate);
            const timezone = Intl.DateTimeFormat().resolvedOptions().timeZone;
            if(timezone == 'Asia/Calcutta'){
                FromDate.setDate(FromDate.getDate() + 1);
            } else{
                FromDate.setDate(FromDate.getDate());
            }
            ToDate = ToDate.toLocaleString('en-US', {
                timeZone: 'America/New_York',
            });
            ToDate = new Date(ToDate);
            if(timezone == 'Asia/Calcutta'){
                ToDate.setDate(ToDate.getDate() + 1);
            } else{
                ToDate.setDate(ToDate.getDate());
            }
            helper.getTimeSeriesData(component, event, FromDate, ToDate, i, quartersList[i].label);
        }
        
    },
    openModal: function(component, event, helper){
      	component.set("v.isModalOpen", !component.get("v.isModalOpen"));
    },
    closeModal: function(component, event, helper){
      	component.set("v.isModalOpen", false)  ;
    },
    handleClick : function(component, event, helper) {
        component.set("v.isSpinnerLoad", true);
        var selectedQ1 = component.get("v.selectedQ1");
        var selectedQ2 = component.get("v.selectedQ2");
        var q1Split = selectedQ1.split(' ')[0];
        var q1Year = (selectedQ1.split(' ')[1]).split('FY')[1];
        var q2Split = selectedQ2.split(' ')[0];
        var q2Year = (selectedQ2.split(' ')[1]).split('FY')[1];
        var q1FromDate; var q1ToDate; var q2FromDate; var q2ToDate;
        if(q1Split == 'Q1'){
            q1FromDate = new Date(parseInt(q1Year-1), 3, 1);
            q1ToDate = new Date(parseInt(q1Year-1), 5, 30);
        } else if(q1Split == 'Q2'){
            q1FromDate = new Date(parseInt(q1Year-1), 6, 1);
            q1ToDate = new Date(parseInt(q1Year-1), 8, 30);
        } else if(q1Split == 'Q3'){
            q1FromDate = new Date(parseInt(q1Year-1), 9, 1);
            q1ToDate = new Date(parseInt(q1Year-1), 11, 31);
        } else if(q1Split == 'Q4'){
            q1FromDate = new Date(parseInt(q1Year), 0, 1);
            q1ToDate = new Date(parseInt(q1Year), 2, 31);
        }
        if(q2Split == 'Q1'){
            q2FromDate = new Date(parseInt(q2Year-1), 3, 1);
            q2ToDate = new Date(parseInt(q2Year-1), 5, 30);
        } else if(q2Split == 'Q2'){
            q2FromDate = new Date(parseInt(q2Year-1), 6, 1);
            q2ToDate = new Date(parseInt(q2Year-1), 8, 30);
        } else if(q2Split == 'Q3'){
            q2FromDate = new Date(parseInt(q2Year-1), 9, 1);
            q2ToDate = new Date(parseInt(q2Year-1), 11, 31);
        } else if(q2Split == 'Q4'){
            q2FromDate = new Date(parseInt(q2Year), 0, 1);
            q2ToDate = new Date(parseInt(q2Year), 2, 31);
        }
        var action = component.get("c.getBids");
        
        var q1FromDate = q1FromDate.toLocaleString('en-US', {
            timeZone: 'America/New_York',
        });
        q1FromDate = new Date(q1FromDate);
        const timezone = Intl.DateTimeFormat().resolvedOptions().timeZone;
        if(timezone == 'Asia/Calcutta'){
         	q1FromDate.setDate(q1FromDate.getDate() + 1);   
        } else{
            q1FromDate.setDate(q1FromDate.getDate());
        }
        var q1ToDate = q1ToDate.toLocaleString('en-US', {
            timeZone: 'America/New_York',
        });
        q1ToDate = new Date(q1ToDate);
        if(timezone == 'Asia/Calcutta'){
         	q1ToDate.setDate(q1ToDate.getDate() + 1);   
        } else{
            q1ToDate.setDate(q1ToDate.getDate());
        }
        var q2FromDate = q2FromDate.toLocaleString('en-US', {
            timeZone: 'America/New_York',
        });
        q2FromDate = new Date(q2FromDate);
        if(timezone == 'Asia/Calcutta'){
         	q2FromDate.setDate(q2FromDate.getDate() + 1);
        } else{
            q2FromDate.setDate(q2FromDate.getDate());
        }
        var q2ToDate = q2ToDate.toLocaleString('en-US', {
            timeZone: 'America/New_York',
        });
        q2ToDate = new Date(q2ToDate);
        if(timezone == 'Asia/Calcutta'){
         	q2ToDate.setDate(q2ToDate.getDate() + 1);
        } else{
            q2ToDate.setDate(q2ToDate.getDate());
        }
        console.log('q1FromDate: '+q1FromDate);
        console.log('q1ToDate: '+q1ToDate);
        console.log('q2FromDate: '+q2FromDate);
        console.log('q2ToDate: '+q2ToDate);
        action.setParams({
            'q1FromDate': q1FromDate,
            'q1ToDate': q1ToDate,
            'q2FromDate': q2FromDate,
            'q2ToDate': q2ToDate,
            'basedOn': component.get("v.basedOn")
        });
        action.setCallback(this, function(response){
            if(response.getState() == 'SUCCESS'){
                var wrapper = response.getReturnValue();
                if(wrapper != null){
                    component.set("v.Q1NewProductLaunchList", wrapper.Q1NewProductLaunchList);
                    component.set("v.Q2NewProductLaunchList", wrapper.Q2NewProductLaunchList);
                    var temp1 = [];
                    var temp2 = [];
                    var data = wrapper.Q2NewProductLaunchList;
                    for(var i=0;i<data.length; i++){
                        if(data[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Awarded'){
                            if(!temp1.includes(data[i].Phoenix_Bid__r.Name)){
                                temp1.push(data[i].Phoenix_Bid__r.Name);
                            }   
                        } else{
                            if(!temp2.includes(data[i].Phoenix_Bid__r.Name)){
                                temp2.push(data[i].Phoenix_Bid__r.Name);
                            }
                        }
                    }
                    component.set("v.Q1ProActiveList", wrapper.Q1ProActiveList);
                    component.set("v.Q2ProActiveList", wrapper.Q2ProActiveList);
                    component.set("v.Q1ReActiveList", wrapper.Q1ReActiveList);
                    component.set("v.Q2ReActiveList", wrapper.Q2ReActiveList);
                    component.set("v.Q1ROFRsList", wrapper.Q1ROFRsList);
                    component.set("v.Q2ROFRsList", wrapper.Q2ROFRsList);
                    var BidsCountObj = {};
                    BidsCountObj.Q1NPLBidsCount = wrapper.Q1NPLBidsCount;
                    BidsCountObj.Q1ProActiveBidsCount = wrapper.Q1ProActiveBidsCount;
                    BidsCountObj.Q1ReActiveBidsCount = wrapper.Q1ReActiveBidsCount;
                    BidsCountObj.Q1ROFRBidsCount = wrapper.Q1ROFRBidsCount;
                    BidsCountObj.Q2NPLBidsCount = wrapper.Q2NPLBidsCount;
                    BidsCountObj.Q2ProActiveBidsCount = wrapper.Q2ProActiveBidsCount;
                    BidsCountObj.Q2ReActiveBidsCount = wrapper.Q2ReActiveBidsCount;
                    BidsCountObj.Q2ROFRBidsCount = wrapper.Q2ROFRBidsCount;
                    component.set("v.BidsCountObj", BidsCountObj);
                    
                    var mapOfAwarded = wrapper.mapOfAwarded;
                    
                    var awardedObj = {};

                    var q1TotalLineItemsCount = wrapper.Q1NPLBidsCount+wrapper.Q1ProActiveBidsCount+wrapper.Q1ReActiveBidsCount+wrapper.Q1ROFRBidsCount;
                    var q2TotalLineItemsCount = wrapper.Q2NPLBidsCount+wrapper.Q2ProActiveBidsCount+wrapper.Q2ReActiveBidsCount+wrapper.Q2ROFRBidsCount;

                    var Q1NPLList = wrapper.Q1NewProductLaunchList; var Q1NewProductList = []; var Q1totalNPL = 0;
                    var Q2NPLList = wrapper.Q2NewProductLaunchList; var Q2NewProductList = []; var Q2totalNPL = 0;                    
                    if(Q1NPLList != null){
                        for(var i=0; i<Q1NPLList.length; i++){
                            if(Q1NPLList[i].Phoenix_Bid__r.Phoenix_Bid_Type__c == 'New Product Launch' || Q1NPLList[i].Phoenix_Bid__r.Phoenix_Bid_Type__c == 'OTC New Product'){
                                if(!Q1NewProductList.includes(Q1NPLList[i].Phoenix_Bid__c)){
                                    if(Q1NPLList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Awarded'){
                                        Q1totalNPL += 1;
                                    }
                                    Q1NewProductList.push(Q1NPLList[i].Phoenix_Bid__c);
                                }
                            }
                        }
                    }
                    if(Q2NPLList != null){
                        for(var i=0; i<Q2NPLList.length; i++){
                            if(Q2NPLList[i].Phoenix_Bid__r.Phoenix_Bid_Type__c == 'New Product Launch' || Q2NPLList[i].Phoenix_Bid__r.Phoenix_Bid_Type__c == 'OTC New Product'){
                                if(!Q2NewProductList.includes(Q2NPLList[i].Phoenix_Bid__c)){
                                    if(Q2NPLList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Awarded'){
                                        Q2totalNPL += 1;
                                    }
                                    Q2NewProductList.push(Q2NPLList[i].Phoenix_Bid__c);
                                }
                            }
                        }
                    }
                    var Q1ProActiveList = wrapper.Q1ProActiveList; var Q1NewCustomerList=[]; var Q1totalNewCustomer=0; var Q1ProductAdditionList=[]; var Q1totalProductAddition=0; 
                    var Q2ProActiveList = wrapper.Q2ProActiveList; var Q2NewCustomerList=[]; var Q2totalNewCustomer=0; var Q2ProductAdditionList=[]; var Q2totalProductAddition=0;                     
                    
                    if(Q1ProActiveList != null){
                        for(var i=0; i<Q1ProActiveList.length; i++){
                            if(Q1ProActiveList[i].Phoenix_Bid__r.Phoenix_Bid_Type__c == 'New Customer'){
                                if(!Q1NewCustomerList.includes(Q1ProActiveList[i].Phoenix_Bid__c)){
                                    if(Q1ProActiveList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Awarded'){
                                        Q1totalNewCustomer += 1;
                                    }  
                                    Q1NewCustomerList.push(Q1ProActiveList[i].Phoenix_Bid__c);
                                }
                            } else if(Q1ProActiveList[i].Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Product Addition' || Q1ProActiveList[i].Phoenix_Bid__r.Phoenix_Bid_Type__c == 'OTC Product Addition'){
                                if(!Q1ProductAdditionList.includes(Q1ProActiveList[i].Phoenix_Bid__c)){
                                    if(Q1ProActiveList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Awarded'){
                                        Q1totalProductAddition += 1;
                                    } 
                                    Q1ProductAdditionList.push(Q1ProActiveList[i].Phoenix_Bid__c);
                                }
                            } 
                        }
                    }
                    console.log('Q1 Pro active Awarded: '+(Q1totalNewCustomer+Q1totalProductAddition));
                    if(Q2ProActiveList != null){
                        for(var i=0; i<Q2ProActiveList.length; i++){
                            if(Q2ProActiveList[i].Phoenix_Bid__r.Phoenix_Bid_Type__c == 'New Customer'){
                                if(!Q2NewCustomerList.includes(Q2ProActiveList[i].Phoenix_Bid__c)){
                                    if(Q2ProActiveList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Awarded'){
                                        Q2totalNewCustomer += 1;
                                    }   
                                    Q2NewCustomerList.push(Q2ProActiveList[i].Phoenix_Bid__c);
                                }
                            } else if(Q2ProActiveList[i].Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Product Addition' || Q2ProActiveList[i].Phoenix_Bid__r.Phoenix_Bid_Type__c == 'OTC Product Addition'){
                                if(!Q2ProductAdditionList.includes(Q2ProActiveList[i].Phoenix_Bid__c)){
                                    if(Q2ProActiveList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Awarded'){
                                        Q2totalProductAddition += 1;
                                    } 
                                    Q2ProductAdditionList.push(Q2ProActiveList[i].Phoenix_Bid__c);
                                }
                            } 
                        }
                    }
                    var Q1ReActiveList = wrapper.Q1ReActiveList; var Q1ReActiveRFPList=[]; var Q1ReActivetotalRFP=0; var Q1OTBList=[]; var Q1totalOTBs =0; var Q1VolumeReviewList=[]; var Q1totalVolumeReview=0;
                    var Q2ReActiveList = wrapper.Q2ReActiveList; var Q2ReActiveRFPList=[]; var Q2ReActivetotalRFP=0; var Q2OTBList=[]; var Q2totalOTBs =0; var Q2VolumeReviewList=[]; var Q2totalVolumeReview=0;
                    if(Q1ReActiveList != null){
                        for(var i=0; i<Q1ReActiveList.length; i++){
                            var currentSales = ((Q1ReActiveList[i].Phoenix_Current_Sales_Finance__c != null) ? Q1ReActiveList[i].Phoenix_Current_Sales_Finance__c : 0);
                            var awardedQty = ((Q1ReActiveList[i].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c != null) ? Q1ReActiveList[i].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c : 0);
                            var proposedASP = ((Q1ReActiveList[i].Phoenix_Proposed_ASP_Dose__c != null) ? Q1ReActiveList[i].Phoenix_Proposed_ASP_Dose__c : 0);
                            var proposedQty = ((Q1ReActiveList[i].Phoenix_Final_Total_Selling_Unit__c != null) ? Q1ReActiveList[i].Phoenix_Final_Total_Selling_Unit__c : 0);
                            var awardedSales = awardedQty*proposedASP;
                            var proposedSales = proposedQty*proposedASP;
                            if((Q1ReActiveList[i].Phoenix_Bid__r.Phoenix_Bid_Type__c == 'RFP Bids' || Q1ReActiveList[i].Phoenix_Bid__r.Phoenix_Bid_Type__c == 'OTC RFP') && ((((awardedQty * proposedASP) >= currentSales)) || (((proposedSales) > currentSales))) ){
                                if(!Q1ReActiveRFPList.includes(Q1ReActiveList[i].Phoenix_Bid__c)){
                                    if(Q1ReActiveList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Awarded'){
                                        Q1ReActivetotalRFP += 1;
                                    }
                                    Q1ReActiveRFPList.push(Q1ReActiveList[i].Phoenix_Bid__c);   
                                }
                            }else if(Q1ReActiveList[i].Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Good Dated OTB' || Q1ReActiveList[i].Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Short Dated OTB' || Q1ReActiveList[i].Phoenix_Bid__r.Phoenix_Bid_Type__c == 'OTC OTB Good Dated' ||
                                     Q1ReActiveList[i].Phoenix_Bid__r.Phoenix_Bid_Type__c == 'OTC OTB Short Dated'){
                                if(!Q1OTBList.includes(Q1ReActiveList[i].Phoenix_Bid__c)){
                                    if(Q1ReActiveList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Awarded'){
                                        Q1totalOTBs += 1;
                                    }   
                                    Q1OTBList.push(Q1ReActiveList[i].Phoenix_Bid__c);
                                }
                            } else if(Q1ReActiveList[i].Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Volume Review Only' || Q1ReActiveList[i].Phoenix_Bid__r.Phoenix_Bid_Type__c == 'OTC Volume Review'){
                                if(!Q1VolumeReviewList.includes(Q1ReActiveList[i].Phoenix_Bid__c)){
                                    if(Q1ReActiveList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Awarded'){
                                        Q1totalVolumeReview += 1;
                                    }
                                    Q1VolumeReviewList.push(Q1ReActiveList[i].Phoenix_Bid__c);
                                }
                            } 
                        }
                        console.log('Outer Q1ReActiveRFPList: '+Q1ReActiveRFPList);
                    }
                    if(Q2ReActiveList != null){
                        for(var i=0; i<Q2ReActiveList.length; i++){
                            var currentSales = ((Q2ReActiveList[i].Phoenix_Current_Sales_Finance__c != null) ? Q2ReActiveList[i].Phoenix_Current_Sales_Finance__c : 0);
                            var awardedQty = ((Q2ReActiveList[i].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c != null) ? Q2ReActiveList[i].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c : 0);
                            var proposedASP = ((Q2ReActiveList[i].Phoenix_Proposed_ASP_Dose__c != null) ? Q2ReActiveList[i].Phoenix_Proposed_ASP_Dose__c : 0);
                            var proposedQty = ((Q2ReActiveList[i].Phoenix_Final_Total_Selling_Unit__c != null) ? Q2ReActiveList[i].Phoenix_Final_Total_Selling_Unit__c : 0);
                            var awardedSales = awardedQty*proposedASP;
                            var proposedSales = proposedQty*proposedASP;
                            if((Q2ReActiveList[i].Phoenix_Bid__r.Phoenix_Bid_Type__c == 'RFP Bids' || Q2ReActiveList[i].Phoenix_Bid__r.Phoenix_Bid_Type__c == 'OTC RFP') && ((((awardedQty * proposedASP) >= currentSales)) || (((proposedSales) > currentSales))) ){
                                if(!Q2ReActiveRFPList.includes(Q2ReActiveList[i].Phoenix_Bid__c)){
                                    if(Q2ReActiveList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Awarded'){
                                        Q2ReActivetotalRFP += 1;
                                    }
                                    Q2ReActiveRFPList.push(Q2ReActiveList[i].Phoenix_Bid__c);   
                                }
                            }else if(Q2ReActiveList[i].Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Good Dated OTB' || Q2ReActiveList[i].Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Short Dated OTB' || Q2ReActiveList[i].Phoenix_Bid__r.Phoenix_Bid_Type__c == 'OTC OTB Good Dated' ||
                                     Q2ReActiveList[i].Phoenix_Bid__r.Phoenix_Bid_Type__c == 'OTC OTB Short Dated'){
                                if(!Q2OTBList.includes(Q2ReActiveList[i].Phoenix_Bid__c)){
                                    if(Q2ReActiveList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Awarded'){
                                        Q2totalOTBs += 1;
                                    }   
                                    Q2OTBList.push(Q2ReActiveList[i].Phoenix_Bid__c);
                                }
                            } else if(Q2ReActiveList[i].Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Volume Review Only' || Q2ReActiveList[i].Phoenix_Bid__r.Phoenix_Bid_Type__c == 'OTC Volume Review'){
                                if(!Q2VolumeReviewList.includes(Q2ReActiveList[i].Phoenix_Bid__c)){
                                    if(Q2ReActiveList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Awarded'){
                                        Q2totalVolumeReview += 1;
                                    }
                                    Q2VolumeReviewList.push(Q2ReActiveList[i].Phoenix_Bid__c);
                                }
                            } 
                        }
                    }
                    var Q1ROFRsList = wrapper.Q1ROFRsList; var Q1ROFRRFPList=[];var Q1ROFRtotalRFP=0; var Q1PriceChangeList=[]; var Q1totalPriceChange=0;
                    var Q2ROFRsList = wrapper.Q2ROFRsList; var Q2ROFRRFPList=[];var Q2ROFRtotalRFP=0; var Q2PriceChangeList=[]; var Q2totalPriceChange=0;
                    if(Q1ROFRsList != null){
                        for(var i=0; i<Q1ROFRsList.length; i++){
                            var currentSales = ((Q1ROFRsList[i].Phoenix_Current_Sales_Finance__c != null) ? Q1ROFRsList[i].Phoenix_Current_Sales_Finance__c : 0);
                            var awardedQty = ((Q1ROFRsList[i].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c != null) ? Q1ROFRsList[i].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c : 0);
                            var proposedASP = ((Q1ROFRsList[i].Phoenix_Proposed_ASP_Dose__c != null) ? Q1ROFRsList[i].Phoenix_Proposed_ASP_Dose__c : 0);
                            var proposedQty = ((Q1ROFRsList[i].Phoenix_Final_Total_Selling_Unit__c != null) ? Q1ROFRsList[i].Phoenix_Final_Total_Selling_Unit__c : 0);
                            var awardedSales = awardedQty*proposedASP;
                            var proposedSales = proposedQty*proposedASP;
                            if((Q1ROFRsList[i].Phoenix_Bid__r.Phoenix_Bid_Type__c == 'RFP Bids' || Q1ROFRsList[i].Phoenix_Bid__r.Phoenix_Bid_Type__c == 'OTC RFP') && ((((awardedQty * proposedASP) < currentSales) && currentSales > 0) || ((proposedSales <= currentSales) && currentSales > 0))){
                                if(!Q1ROFRRFPList.includes(Q1ROFRsList[i].Phoenix_Bid__c)){
                                    if(Q1ROFRsList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Awarded'){
                                        Q1ROFRtotalRFP += 1;
                                    }
                                    Q1ROFRRFPList.push(Q1ROFRsList[i].Phoenix_Bid__c);
                                }
                            } else if(Q1ROFRsList[i].Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Price Change' || Q1ROFRsList[i].Phoenix_Bid__r.Phoenix_Bid_Type__c == 'OTC Price Change'){
                                if(!Q1PriceChangeList.includes(Q1ROFRsList[i].Phoenix_Bid__c)){
                                    if(Q1ROFRsList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Awarded'){
                                        Q1totalPriceChange += 1;
                                    }
                                    Q1PriceChangeList.push(Q1ROFRsList[i].Phoenix_Bid__c);
                                }
                            } 
                        }
                    }
                    if(Q2ROFRsList != null){
                        for(var i=0; i<Q2ROFRsList.length; i++){
                            var currentSales = ((Q2ROFRsList[i].Phoenix_Current_Sales_Finance__c != null) ? Q2ROFRsList[i].Phoenix_Current_Sales_Finance__c : 0);
                            var awardedQty = ((Q2ROFRsList[i].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c != null) ? Q2ROFRsList[i].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c : 0);
                            var proposedASP = ((Q2ROFRsList[i].Phoenix_Proposed_ASP_Dose__c != null) ? Q2ROFRsList[i].Phoenix_Proposed_ASP_Dose__c : 0);
                            var proposedQty = ((Q2ROFRsList[i].Phoenix_Final_Total_Selling_Unit__c != null) ? Q2ROFRsList[i].Phoenix_Final_Total_Selling_Unit__c : 0);
                            var awardedSales = awardedQty*proposedASP;
                            var proposedSales = proposedQty*proposedASP;
                            if((Q2ROFRsList[i].Phoenix_Bid__r.Phoenix_Bid_Type__c == 'RFP Bids' || Q2ROFRsList[i].Phoenix_Bid__r.Phoenix_Bid_Type__c == 'OTC RFP') && ((((awardedQty * proposedASP) < currentSales) && currentSales > 0) || ((proposedSales <= currentSales) && currentSales > 0))){
                                if(!Q2ROFRRFPList.includes(Q2ROFRsList[i].Phoenix_Bid__c)){
                                    if(Q2ROFRsList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Awarded'){
                                        Q2ROFRtotalRFP += 1;
                                    }
                                    Q2ROFRRFPList.push(Q2ROFRsList[i].Phoenix_Bid__c);
                                }
                            } else if(Q2ROFRsList[i].Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Price Change' || Q2ROFRsList[i].Phoenix_Bid__r.Phoenix_Bid_Type__c == 'OTC Price Change'){
                                if(!Q2PriceChangeList.includes(Q2ROFRsList[i].Phoenix_Bid__c)){
                                    if(Q2ROFRsList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Awarded'){
                                        Q2totalPriceChange += 1;
                                    }
                                    Q2PriceChangeList.push(Q2ROFRsList[i].Phoenix_Bid__c);
                                }
                            } 
                        }
                    }
                    
                    awardedObj.Q1NPLWinRate = Q1totalNPL/wrapper.Q1NPLBidsCount;
                    awardedObj.Q2NPLWinRate = Q2totalNPL/wrapper.Q2NPLBidsCount;
                    awardedObj.Q1ProActiveWinRate = (Q1totalNewCustomer+Q1totalProductAddition)/wrapper.Q1ProActiveBidsCount;
                    awardedObj.Q2ProActiveWinRate = (Q2totalNewCustomer+Q2totalProductAddition)/wrapper.Q2ProActiveBidsCount;
                    awardedObj.Q1ReActiveWinRate = (Q1ReActivetotalRFP+Q1totalOTBs+Q1totalVolumeReview)/wrapper.Q1ReActiveBidsCount;
                    awardedObj.Q2ReActiveWinRate = (Q2ReActivetotalRFP+Q2totalOTBs+Q2totalVolumeReview)/wrapper.Q2ReActiveBidsCount;
                    awardedObj.Q1ROFRsWinRate = (Q1ROFRtotalRFP+Q1totalPriceChange)/wrapper.Q1ROFRBidsCount;
                    awardedObj.Q2ROFRsWinRate = (Q2ROFRtotalRFP+Q2totalPriceChange)/wrapper.Q2ROFRBidsCount;
                    var q1AwardedLineItemsCount = Q1totalNPL+(Q1totalNewCustomer+Q1totalProductAddition)+(Q1ReActivetotalRFP+Q1totalOTBs+Q1totalVolumeReview)+(Q1ROFRtotalRFP+Q1totalPriceChange);
                    var q2AwardedLineItemsCount = Q2totalNPL+(Q2totalNewCustomer+Q2totalProductAddition)+(Q2ReActivetotalRFP+Q2totalOTBs+Q2totalVolumeReview)+(Q2ROFRtotalRFP+Q2totalPriceChange);
                    
                    if((awardedObj.Q1NPLWinRate > awardedObj.Q2NPLWinRate) && ((awardedObj.Q1NPLWinRate - awardedObj.Q2NPLWinRate) > 0.1 || (awardedObj.Q1NPLWinRate - awardedObj.Q2NPLWinRate) < -0.1)){
                        awardedObj.greaterNPL = true;
                        awardedObj.hoverNPLMessage = '% Win Rate of '+selectedQ1+' is higher than that of '+selectedQ2;
                    } else if((awardedObj.Q1NPLWinRate < awardedObj.Q2NPLWinRate) && ((awardedObj.Q1NPLWinRate - awardedObj.Q2NPLWinRate) > 0.1 || (awardedObj.Q1NPLWinRate - awardedObj.Q2NPLWinRate) < -0.1)){
                        awardedObj.lesserNPL = true;
                        awardedObj.hoverNPLMessage = '% Win Rate of '+selectedQ1+' is lesser than that of '+selectedQ2;
                    } else{
                        if(isNaN(awardedObj.Q1NPLWinRate) || isNaN(awardedObj.Q2NPLWinRate)){
                            awardedObj.isNaNNPL = true;
                        }
                        awardedObj.equalNPL = true;
                        awardedObj.hoverNPLMessage = '% Win Rate of '+selectedQ1+' is equal/near to that of '+selectedQ2;
                    }
                    if((awardedObj.Q1ProActiveWinRate > awardedObj.Q2ProActiveWinRate) && ((awardedObj.Q1ProActiveWinRate - awardedObj.Q2ProActiveWinRate) > 0.1 || (awardedObj.Q1ProActiveWinRate - awardedObj.Q2ProActiveWinRate) < -0.1)){
                        awardedObj.greaterProActive = true;
                        awardedObj.hoverProActiveMessage = '% Win Rate of '+selectedQ1+' is higher than that of '+selectedQ2;
                    } else if((awardedObj.Q1ProActiveWinRate < awardedObj.Q2ProActiveWinRate) && ((awardedObj.Q1ProActiveWinRate - awardedObj.Q2ProActiveWinRate) > 0.1 || (awardedObj.Q1ProActiveWinRate - awardedObj.Q2ProActiveWinRate) < -0.1)){
                        awardedObj.lesserProActive = true;
                        awardedObj.hoverProActiveMessage = '% Win Rate of '+selectedQ1+' is lesser than that of '+selectedQ2;
                    } else{
                        if(isNaN(awardedObj.Q1ProActiveWinRate) || isNaN(awardedObj.Q2ProActiveWinRate)){
                            awardedObj.isNaNProActive = true;
                        }
                        awardedObj.equalProActiveL = true;
                        awardedObj.hoverProActiveMessage = '% Win Rate of '+selectedQ1+' is equal/near to that of '+selectedQ2;
                    }
                    if((awardedObj.Q1ReActiveWinRate > awardedObj.Q2ReActiveWinRate) && ((awardedObj.Q1ReActiveWinRate - awardedObj.Q2ReActiveWinRate) > 0.1 || (awardedObj.Q1ReActiveWinRate - awardedObj.Q2ReActiveWinRate) < -0.1)){
                        awardedObj.greaterReActive = true;
                        awardedObj.hoverReActiveMessage = '% Win Rate of '+selectedQ1+' is higher than that of '+selectedQ2;
                    } else if((awardedObj.Q1ReActiveWinRate < awardedObj.Q2ReActiveWinRate) && ((awardedObj.Q1ReActiveWinRate - awardedObj.Q2ReActiveWinRate) > 0.1 || (awardedObj.Q1ReActiveWinRate - awardedObj.Q2ReActiveWinRate) < -0.1)){
                        awardedObj.lesserReActive = true;
                        awardedObj.hoverReActiveMessage = '% Win Rate of '+selectedQ1+' is lesser than that of '+selectedQ2;
                    } else{
                        if(isNaN(awardedObj.Q1ReActiveWinRate) || isNaN(awardedObj.Q2ReActiveWinRate)){
                            awardedObj.isNaNReActive = true;
                        }
                        awardedObj.equalReActive = true;
                        awardedObj.hoverReActiveMessage = '% Win Rate of '+selectedQ1+' is equal/near to that of '+selectedQ2;
                    }
                    if((awardedObj.Q1ROFRsWinRate > awardedObj.Q2ROFRsWinRate) && ((awardedObj.Q1ROFRsWinRate - awardedObj.Q2ROFRsWinRate) > 0.1 || (awardedObj.Q1ROFRsWinRate - awardedObj.Q2ROFRsWinRate) < -0.1)){
                        awardedObj.greaterROFRs = true;
                        awardedObj.hoverROFRsMessage = '% Win Rate of '+selectedQ1+' is higher than that of '+selectedQ2;
                    } else if((awardedObj.Q1ROFRsWinRate < awardedObj.Q2ROFRsWinRate) && ((awardedObj.Q1ROFRsWinRate - awardedObj.Q2ROFRsWinRate) > 0.1 || (awardedObj.Q1ROFRsWinRate - awardedObj.Q2ROFRsWinRate) < -0.1)){
                        awardedObj.lesserROFRs = true;
                        awardedObj.hoverROFRsMessage = '% Win Rate of '+selectedQ1+' is lesser than that of '+selectedQ2;
                    } else{
                        if(isNaN(awardedObj.Q1ROFRsWinRate) || isNaN(awardedObj.Q2ROFRsWinRate)){
                            awardedObj.isNaNROFRs = true;
                        }
                        awardedObj.equalROFRs = true;
                        awardedObj.hoverROFRsMessage = '% Win Rate of '+selectedQ1+' is equal/near to that of '+selectedQ2;
                    }
                    component.set("v.awardedObj", awardedObj);
                    var obj = {};
                    obj.Q1SalesNPL = ((isNaN(wrapper.Q1SalesNPL) ? 0 : wrapper.Q1SalesNPL));
                    obj.Q2SalesNPL = ((isNaN(wrapper.Q2SalesNPL) ? 0 : wrapper.Q2SalesNPL));
                    obj.Q1SalesProActive = ((isNaN(wrapper.Q1SalesProActive) ? 0 : wrapper.Q1SalesProActive));
                    obj.Q2SalesProActive = ((isNaN(wrapper.Q2SalesProActive) ? 0 : wrapper.Q2SalesProActive));
                    obj.Q1SalesReActive = ((isNaN(wrapper.Q1SalesReActive) ? 0 : wrapper.Q1SalesReActive));
                    obj.Q2SalesReActive = ((isNaN(wrapper.Q2SalesReActive) ? 0 : wrapper.Q2SalesReActive));
                    obj.Q1SalesROFRs = ((isNaN(wrapper.Q1SalesROFRs) ? 0 : wrapper.Q1SalesROFRs));
                    obj.Q2SalesROFRs = ((isNaN(wrapper.Q2SalesROFRs) ? 0 : wrapper.Q2SalesROFRs));
                    obj.q1AwardedLineItemsCount = q1AwardedLineItemsCount;
                    obj.q2AwardedLineItemsCount = q2AwardedLineItemsCount;
                    obj.q1TotalLineItemsCount = q1TotalLineItemsCount;
                    obj.q2TotalLineItemsCount = q2TotalLineItemsCount;
                    obj.Q1WinRate = q1AwardedLineItemsCount/q1TotalLineItemsCount;
                    obj.Q2WinRate = q2AwardedLineItemsCount/q2TotalLineItemsCount;
                    obj.Q1Sales = parseInt(obj.Q1SalesNPL) + parseInt(obj.Q1SalesProActive) + parseInt(obj.Q1SalesReActive) + parseInt(obj.Q1SalesROFRs);
                    obj.Q2Sales = parseInt(obj.Q2SalesNPL) + parseInt(obj.Q2SalesProActive) + parseInt(obj.Q2SalesReActive) + parseInt(obj.Q2SalesROFRs);
                    if((obj.Q1WinRate > obj.Q2WinRate) && ((obj.Q1WinRate - obj.Q2WinRate) > 0.1 || (obj.Q1WinRate - obj.Q2WinRate) < -0.1)){
                        obj.greaterRate = true;
                        obj.hoverTotalMessage = 'Total % Win Rate of '+selectedQ1+' is higher than that of '+selectedQ2;
                    } else if((obj.Q1WinRate < obj.Q2WinRate) && ((obj.Q1WinRate - obj.Q2WinRate) > 0.1 || (obj.Q1WinRate - obj.Q2WinRate) < -0.1)){
                        obj.lesserRate = true;
                        obj.hoverTotalMessage = 'Total % Win Rate of '+selectedQ1+' is lesser than that of '+selectedQ2;
                    } else{
                        if(isNaN(obj.Q1WinRate) || isNaN(obj.Q2WinRate)){
                            obj.isNaNTotal = true;
                        }
                        obj.equalRate = true;
                        obj.hoverTotalMessage = 'Total % Win Rate of '+selectedQ1+' is equal/near to that of '+selectedQ2;
                    }
                    component.set("v.salesObj", obj);
                    /*component.set("v.NPLBidsList", wrapper.NPLBids);
                    component.set("v.NewCustomerBidsList", wrapper.NewCustomerBids);
                    component.set("v.ProductAdditionBidsList", wrapper.NewProductLaunchList);*/
                    component.set("v.dataLoaded", true);
                }
                component.set("v.isSpinnerLoad", false);
            } else{
                console.log("Exception "+JSON.stringify(response.getError()));
                component.set("v.isSpinnerLoad", false);
            }
        });
        $A.enqueueAction(action);
    },
    handleQ1Change: function (component, event) {
        var selectedQ1 = component.get("v.selectedQ1");
        var quarters = component.get("v.quarters");
        for(var i=0; i<quarters.length; i++){
            if(selectedQ1 == quarters[i].value){
                component.set("v.Q1Label", quarters[i].label);
            }
        }
    },
    handleQ2Change: function (component, event) {
        var selectedQ2 = component.get("v.selectedQ2");
        var quarters = component.get("v.quarters");
        for(var i=0; i<quarters.length; i++){
            if(selectedQ2 == quarters[i].value){
                component.set("v.Q2Label", quarters[i].label);
            }
        }
    },
    
    toggleChange: function(component, event, helper){
		var isChecked = component.get("v.isChecked");
        if(isChecked){
            component.set("v.viewName", 'E-2');
        } else{
            component.set("v.viewName", 'E-1');
        }
    },
    handleYearChange: function (component, event) {
        var selectedYear = component.get("v.selectedYear");
        var quarterStrings = ['Q1', 'Q2', 'Q3', 'Q4'];
        var quarters = [];
        for(var i=0; i<quarterStrings.length; i++){
            var obj = {};
            obj.label = quarterStrings[i]+' FY'+selectedYear.charAt(selectedYear.length-2)+selectedYear.charAt(selectedYear.length-1);
            obj.value = quarterStrings[i]+' FY'+selectedYear.charAt(selectedYear.length-2)+selectedYear.charAt(selectedYear.length-1);
            quarters.push(obj);
        }
        component.set("v.quarters", quarters);
    },
    showAwarded: function(component, event, helper){
      	component.set("v.showAwarded", !component.get("v.showAwarded"));
    },
    showDeclined: function(component, event, helper){
        component.set("v.showDeclined", !component.get("v.showDeclined"));
    },
    
    NPLQ1Click: function(component, event, helper){
        component.set("v.selectedOption", 'New Product Launchs (NPLs)');
        var NPLList = component.get("v.Q1NewProductLaunchList");
        component.set("v.popupData", NPLList);
        var familyMap = {}; var declinedFamilyMap = {};
        var awardedCurrentSales = 0; var awardedProposedSales = 0; var awardedAwardedSales = 0;
        var declinedCurrentSales = 0; var declinedProposedSales = 0; var declinedAwardedSales = 0;
        var awardedFamilySummaryObj = {}; var declinedFamilySummaryObj = {}; var awardedNPLList = []; var numbers = [];
        if(NPLList != null){
            for(var i=0; i<NPLList.length;i++){
                if(NPLList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Awarded'){
                    if(familyMap.hasOwnProperty(NPLList[i].Product_Family_Name__c)){
                        var relatedList = familyMap[NPLList[i].Product_Family_Name__c];
                        relatedList.push(NPLList[i]);
                        familyMap[NPLList[i].Product_Family_Name__c] = relatedList;
                    } else{
                        var relatedList = [];
                        relatedList.push(NPLList[i]);
                        familyMap[NPLList[i].Product_Family_Name__c] = relatedList;
                    }
                    var awardedQty = ((NPLList[i].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c != null) ? NPLList[i].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c : 0);
                    var proposedASP = ((NPLList[i].Phoenix_Proposed_ASP_Dose__c != null) ? NPLList[i].Phoenix_Proposed_ASP_Dose__c : 0);
                    var currentSales = ((NPLList[i].Phoenix_Current_Sales_Finance__c != null) ? NPLList[i].Phoenix_Current_Sales_Finance__c : 0);
                    var proposedQty = ((NPLList[i].Phoenix_Final_Total_Selling_Unit__c != null) ? NPLList[i].Phoenix_Final_Total_Selling_Unit__c : 0);
                    var awardedSales = awardedQty*proposedASP; 
                    var proposedSales = proposedQty*proposedASP;
                    awardedCurrentSales += currentSales;
                    awardedProposedSales += proposedSales;
                    awardedAwardedSales += awardedSales;
                } else if(NPLList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Declined by Customer'){
                    if(declinedFamilyMap.hasOwnProperty(NPLList[i].Product_Family_Name__c)){
                        var relatedList = declinedFamilyMap[NPLList[i].Product_Family_Name__c];
                        relatedList.push(NPLList[i]);
                        declinedFamilyMap[NPLList[i].Product_Family_Name__c] = relatedList;
                    } else{
                        var relatedList = [];
                        relatedList.push(NPLList[i]);
                        declinedFamilyMap[NPLList[i].Product_Family_Name__c] = relatedList;
                    }
                    var awardedQty = ((NPLList[i].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c != null) ? NPLList[i].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c : 0);
                    var proposedASP = ((NPLList[i].Phoenix_Proposed_ASP_Dose__c != null) ? NPLList[i].Phoenix_Proposed_ASP_Dose__c : 0);
                    var currentSales = ((NPLList[i].Phoenix_Current_Sales_Finance__c != null) ? NPLList[i].Phoenix_Current_Sales_Finance__c : 0);
                    var proposedQty = ((NPLList[i].Phoenix_Final_Total_Selling_Unit__c != null) ? NPLList[i].Phoenix_Final_Total_Selling_Unit__c : 0);
                    var awardedSales = awardedQty*proposedASP; 
                    var proposedSales = proposedQty*proposedASP;
                    declinedCurrentSales += currentSales;
                    declinedProposedSales += proposedSales;
                    declinedAwardedSales += awardedSales;
                }
            }   
        }
        var familyMapKeys = Object.keys(familyMap);
        var declinedFamilyMapKeys = Object.keys(declinedFamilyMap);
        for(var i=0; i<familyMapKeys.length; i++){
            var relatedList = familyMap[familyMapKeys[i]];
            var awardedSales = 0;
            for(var j=0; j<relatedList.length; j++){
                var awardedQty = ((relatedList[j].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c != null) ? relatedList[j].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c : 0);
                var proposedASP = ((relatedList[j].Phoenix_Proposed_ASP_Dose__c != null) ? relatedList[j].Phoenix_Proposed_ASP_Dose__c : 0);
                awardedSales += awardedQty*proposedASP;
            }
            awardedFamilySummaryObj[familyMapKeys[i]] = awardedSales;
        }
        for(var i=0; i<declinedFamilyMapKeys.length; i++){
            var relatedList = declinedFamilyMap[declinedFamilyMapKeys[i]];
            var proposedSales = 0;
            for(var j=0; j<relatedList.length; j++){
                var proposedASP = ((relatedList[j].Phoenix_Proposed_ASP_Dose__c != null) ? relatedList[j].Phoenix_Proposed_ASP_Dose__c : 0);
                var proposedQty = ((relatedList[j].Phoenix_Final_Total_Selling_Unit__c != null) ? relatedList[j].Phoenix_Final_Total_Selling_Unit__c : 0);
                proposedSales += proposedQty*proposedASP;
            }
            declinedFamilySummaryObj[declinedFamilyMapKeys[i]] = proposedSales;
        }
        
        let keys = Object.keys(awardedFamilySummaryObj);
        keys.sort(function(a, b) { return awardedFamilySummaryObj[b] - awardedFamilySummaryObj[a] });
        component.set("v.familyKeys", keys);
        
        let declinedKeys = Object.keys(declinedFamilySummaryObj);
        declinedKeys.sort(function(a, b) { return declinedFamilySummaryObj[b] - declinedFamilySummaryObj[a] });
        component.set("v.declinedFamilyKeys", declinedKeys);
        
        var finalAwardedSummaryObj = {};
        finalAwardedSummaryObj.awardedCurrentSales = awardedCurrentSales;
        finalAwardedSummaryObj.awardedProposedSales = awardedProposedSales;
        finalAwardedSummaryObj.awardedAwardedSales = awardedAwardedSales;
        var finalDeclinedSummaryObj = {};
        finalDeclinedSummaryObj.declinedCurrentSales = declinedCurrentSales;
        finalDeclinedSummaryObj.declinedProposedSales = declinedProposedSales;
        finalDeclinedSummaryObj.declinedAwardedSales = declinedAwardedSales;
        
        component.set("v.finalAwardedSummaryObj", finalAwardedSummaryObj);
        component.set("v.finalDeclinedSummaryObj", finalDeclinedSummaryObj);
        
        
        var NewProductList = []; var OTCNewProductList = [];
        var obj = {}; var totalNPL = 0; var totalOTCNPL = 0; var awardedSalesNPL = 0; var declinedSalesNPL = 0; var awardedSalesOTCNPL = 0; var declinedSalesOTCNPL = 0;
        if(NPLList != null){
            for(var i=0; i<NPLList.length; i++){
                var currentSales = ((NPLList[i].Phoenix_Current_Sales_Finance__c != null) ? NPLList[i].Phoenix_Current_Sales_Finance__c : 0);
                var awardedQty = ((NPLList[i].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c != null) ? NPLList[i].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c : 0);
                var proposedASP = ((NPLList[i].Phoenix_Proposed_ASP_Dose__c != null) ? NPLList[i].Phoenix_Proposed_ASP_Dose__c : 0);
                var proposedQty = ((NPLList[i].Phoenix_Final_Total_Selling_Unit__c != null) ? NPLList[i].Phoenix_Final_Total_Selling_Unit__c : 0);
                var awardedSales = awardedQty*proposedASP;
                var proposedSales = proposedQty*proposedASP;
                if(NPLList[i].Phoenix_Bid__r.Phoenix_Bid_Type__c == 'New Product Launch' || NPLList[i].Phoenix_Bid__r.Phoenix_Bid_Type__c == 'OTC New Product'){
                    if(!NewProductList.includes(NPLList[i].Phoenix_Bid__c)){
                        if(NPLList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Awarded'){
                            totalNPL += 1;
                        }
                        NewProductList.push(NPLList[i].Phoenix_Bid__c);
                    }
                    if(NPLList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Awarded'){
                        if(!awardedNPLList.includes(NPLList[i].Phoenix_Bid__r.Name)){
                            awardedNPLList.push(NPLList[i].Phoenix_Bid__r.Name);
                        }
                        awardedSalesNPL += (awardedSales-currentSales);
                    } else if(NPLList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Declined by Customer'){
                        declinedSalesNPL += (proposedSales-currentSales);                            
                    }
                } 
                /*else if(NPLList[i].Phoenix_Bid__r.Phoenix_Bid_Type__c == 'OTC New Product'){
                    if(!OTCNewProductList.includes(NPLList[i].Phoenix_Bid__c)){
                        if(NPLList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Awarded'){
                            totalOTCNPL += 1;
                        }
                        OTCNewProductList.push(NPLList[i].Phoenix_Bid__c);   
                    }
                    if(NPLList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Awarded'){
                        awardedSalesOTCNPL += awardedSales;
                    } else if(NPLList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Declined by Customer'){
                        declinedSalesOTCNPL += proposedSales;                            
                    }
                }*/
            }
        }
        obj.NewProductList = NewProductList;
        obj.OTCNewProductList = OTCNewProductList;
        obj.totalNPL = totalNPL;
        obj.totalOTCNPL = totalOTCNPL;
        obj.totalAwarded = totalNPL+totalOTCNPL;
        obj.totalDeclined = (NewProductList.length-obj.totalNPL)+(OTCNewProductList.length-obj.totalOTCNPL);
        obj.totalBids = obj.totalAwarded + obj.totalDeclined;
        obj.awardedSalesNPL = awardedSalesNPL; obj.declinedSalesNPL = declinedSalesNPL; 
        obj.awardedSalesOTCNPL = awardedSalesOTCNPL; obj.declinedSalesOTCNPL = declinedSalesOTCNPL;
        obj.totalAwardedSales = awardedSalesNPL+awardedSalesOTCNPL;
        obj.totalDeclinedSales = declinedSalesNPL+declinedSalesOTCNPL;
        obj.instance = 'NPL';
        component.set("v.E1Object", obj);
        component.set("v.showE1View", true);
        component.set("v.selectedQuarter", component.get("v.Q1Label"));
        component.set("v.selectedCategory", 'NPL');
    },
    ProActiveQ1Click: function(component, event, helper){
        component.set("v.selectedOption", 'Proactive Bids');
        var ProActiveList = component.get("v.Q1ProActiveList");
        component.set("v.popupData", ProActiveList);
        var familyMap = {}; var declinedFamilyMap = {};
        var awardedCurrentSales = 0; var awardedProposedSales = 0; var awardedAwardedSales = 0;
        var declinedCurrentSales = 0; var declinedProposedSales = 0; var declinedAwardedSales = 0;
        var awardedFamilySummaryObj = {}; var declinedFamilySummaryObj = {};
        if(ProActiveList != null){
            for(var i=0; i<ProActiveList.length;i++){
                if(ProActiveList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Awarded'){
                    if(familyMap.hasOwnProperty(ProActiveList[i].Product_Family_Name__c)){
                        var relatedList = familyMap[ProActiveList[i].Product_Family_Name__c];
                        relatedList.push(ProActiveList[i]);
                        familyMap[ProActiveList[i].Product_Family_Name__c] = relatedList;
                    } else{
                        var relatedList = [];
                        relatedList.push(ProActiveList[i]);
                        familyMap[ProActiveList[i].Product_Family_Name__c] = relatedList;
                    }
                    var awardedQty = ((ProActiveList[i].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c != null) ? ProActiveList[i].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c : 0);
                    var proposedASP = ((ProActiveList[i].Phoenix_Proposed_ASP_Dose__c != null) ? ProActiveList[i].Phoenix_Proposed_ASP_Dose__c : 0);
                    var currentSales = ((ProActiveList[i].Phoenix_Current_Sales_Finance__c != null) ? ProActiveList[i].Phoenix_Current_Sales_Finance__c : 0);
                    var proposedQty = ((ProActiveList[i].Phoenix_Final_Total_Selling_Unit__c != null) ? ProActiveList[i].Phoenix_Final_Total_Selling_Unit__c : 0);
                    var awardedSales = awardedQty*proposedASP; 
                    var proposedSales = proposedQty*proposedASP;
                    awardedCurrentSales += currentSales;
                    awardedProposedSales += proposedSales;
                    awardedAwardedSales += awardedSales;
                } else if(ProActiveList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Declined by Customer'){
                    if(declinedFamilyMap.hasOwnProperty(ProActiveList[i].Product_Family_Name__c)){
                        var relatedList = declinedFamilyMap[ProActiveList[i].Product_Family_Name__c];
                        relatedList.push(ProActiveList[i]);
                        declinedFamilyMap[ProActiveList[i].Product_Family_Name__c] = relatedList;
                    } else{
                        var relatedList = [];
                        relatedList.push(ProActiveList[i]);
                        declinedFamilyMap[ProActiveList[i].Product_Family_Name__c] = relatedList;
                    }
                    var awardedQty = ((ProActiveList[i].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c != null) ? ProActiveList[i].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c : 0);
                    var proposedASP = ((ProActiveList[i].Phoenix_Proposed_ASP_Dose__c != null) ? ProActiveList[i].Phoenix_Proposed_ASP_Dose__c : 0);
                    var currentSales = ((ProActiveList[i].Phoenix_Current_Sales_Finance__c != null) ? ProActiveList[i].Phoenix_Current_Sales_Finance__c : 0);
                    var proposedQty = ((ProActiveList[i].Phoenix_Final_Total_Selling_Unit__c != null) ? ProActiveList[i].Phoenix_Final_Total_Selling_Unit__c : 0);
                    var awardedSales = awardedQty*proposedASP; 
                    var proposedSales = proposedQty*proposedASP;
                    declinedCurrentSales += currentSales;
                    declinedProposedSales += proposedSales;
                    declinedAwardedSales += awardedSales;
                }
            }   
        }
        
        var familyMapKeys = Object.keys(familyMap);
        var declinedFamilyMapKeys = Object.keys(declinedFamilyMap);
        for(var i=0; i<familyMapKeys.length; i++){
            var relatedList = familyMap[familyMapKeys[i]];
            var awardedSales = 0;
            for(var j=0; j<relatedList.length; j++){
                var awardedQty = ((relatedList[j].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c != null) ? relatedList[j].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c : 0);
                var proposedASP = ((relatedList[j].Phoenix_Proposed_ASP_Dose__c != null) ? relatedList[j].Phoenix_Proposed_ASP_Dose__c : 0);
                awardedSales += awardedQty*proposedASP;
            }
            awardedFamilySummaryObj[familyMapKeys[i]] = awardedSales;
        }
        for(var i=0; i<declinedFamilyMapKeys.length; i++){
            var relatedList = declinedFamilyMap[declinedFamilyMapKeys[i]];
            var proposedSales = 0;
            for(var j=0; j<relatedList.length; j++){
                var proposedASP = ((relatedList[j].Phoenix_Proposed_ASP_Dose__c != null) ? relatedList[j].Phoenix_Proposed_ASP_Dose__c : 0);
                var proposedQty = ((relatedList[j].Phoenix_Final_Total_Selling_Unit__c != null) ? relatedList[j].Phoenix_Final_Total_Selling_Unit__c : 0);
                proposedSales += proposedQty*proposedASP;
            }
            declinedFamilySummaryObj[declinedFamilyMapKeys[i]] = proposedSales;
        }
        
        let keys = Object.keys(awardedFamilySummaryObj);
        keys.sort(function(a, b) { return awardedFamilySummaryObj[b] - awardedFamilySummaryObj[a] });
        component.set("v.familyKeys", keys);
        
        let declinedKeys = Object.keys(declinedFamilySummaryObj);
        declinedKeys.sort(function(a, b) { return declinedFamilySummaryObj[b] - declinedFamilySummaryObj[a] });
        component.set("v.declinedFamilyKeys", declinedKeys);
        
        var finalAwardedSummaryObj = {};
        finalAwardedSummaryObj.awardedCurrentSales = awardedCurrentSales;
        finalAwardedSummaryObj.awardedProposedSales = awardedProposedSales;
        finalAwardedSummaryObj.awardedAwardedSales = awardedAwardedSales;
        var finalDeclinedSummaryObj = {};
        finalDeclinedSummaryObj.declinedCurrentSales = declinedCurrentSales;
        finalDeclinedSummaryObj.declinedProposedSales = declinedProposedSales;
        finalDeclinedSummaryObj.declinedAwardedSales = declinedAwardedSales;
        
        component.set("v.finalAwardedSummaryObj", finalAwardedSummaryObj);
        component.set("v.finalDeclinedSummaryObj", finalDeclinedSummaryObj);        

        var NewCustomerList = []; var ProductAdditionList = [];
        var OTCProductAdditionList = []; var totalNewCustomer = 0; var totalProductAddition = 0; var totalOTCProductAddition = 0;
        var awardedSalesNewCustomer = 0; var declinedSalesNewCustomer = 0; var awardedSalesProductAddition = 0; var declinedSalesProductAddition = 0;
        var awardedSalesOTCProductAddition = 0; var declinedSalesOTCProductAddition = 0;
        var obj = {};
        if(ProActiveList != null){
            for(var i=0; i<ProActiveList.length; i++){
                var currentSales = ((ProActiveList[i].Phoenix_Current_Sales_Finance__c != null) ? ProActiveList[i].Phoenix_Current_Sales_Finance__c : 0);
                var awardedQty = ((ProActiveList[i].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c != null) ? ProActiveList[i].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c : 0);
                var proposedASP = ((ProActiveList[i].Phoenix_Proposed_ASP_Dose__c != null) ? ProActiveList[i].Phoenix_Proposed_ASP_Dose__c : 0);
                var proposedQty = ((ProActiveList[i].Phoenix_Final_Total_Selling_Unit__c != null) ? ProActiveList[i].Phoenix_Final_Total_Selling_Unit__c : 0);
                var awardedSales = awardedQty*proposedASP;
                var proposedSales = proposedQty*proposedASP;
                if(ProActiveList[i].Phoenix_Bid__r.Phoenix_Bid_Type__c == 'New Customer'){
                    if(!NewCustomerList.includes(ProActiveList[i].Phoenix_Bid__c)){
                        if(ProActiveList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Awarded'){
                            totalNewCustomer += 1;
                        }
                        NewCustomerList.push(ProActiveList[i].Phoenix_Bid__c);   
                    }
                    if(ProActiveList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Awarded'){
                        awardedSalesNewCustomer += (awardedSales-currentSales);
                    } else if(ProActiveList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Declined by Customer'){
                        declinedSalesNewCustomer += (proposedSales-currentSales);                            
                    }
                } else if(ProActiveList[i].Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Product Addition' || ProActiveList[i].Phoenix_Bid__r.Phoenix_Bid_Type__c == 'OTC Product Addition'){
                    if(!ProductAdditionList.includes(ProActiveList[i].Phoenix_Bid__c)){
                        if(ProActiveList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Awarded'){
                            totalProductAddition += 1;
                        }
                        ProductAdditionList.push(ProActiveList[i].Phoenix_Bid__c);   
                    }
                    if(ProActiveList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Awarded'){
                        awardedSalesProductAddition += (awardedSales-currentSales);
                    } else if(ProActiveList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Declined by Customer'){
                        declinedSalesProductAddition += (proposedSales-currentSales);                      
                    }
                } 
                    /*else if(ProActiveList[i].Phoenix_Bid__r.Phoenix_Bid_Type__c == 'OTC Product Addition'){
                    if(!OTCProductAdditionList.includes(ProActiveList[i].Phoenix_Bid__c)){
                        if(ProActiveList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Awarded'){
                            totalOTCProductAddition += 1;
                        }
                        OTCProductAdditionList.push(ProActiveList[i].Phoenix_Bid__c);   
                    }
                    if(ProActiveList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Awarded'){
                        awardedSalesOTCProductAddition += (awardedSales-currentSales);
                    } else if(ProActiveList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Declined by Customer'){
                        declinedSalesOTCProductAddition += (proposedSales-currentSales);                            
                    }
                }*/
            }
        }
        obj.NewCustomerList = NewCustomerList;
        obj.ProductAdditionList = ProductAdditionList;
        obj.OTCProductAdditionList = OTCProductAdditionList;
        obj.totalNewCustomer = totalNewCustomer;
        obj.totalProductAddition = totalProductAddition;
        obj.totalOTCProductAddition = totalOTCProductAddition;
        obj.totalAwarded = totalNewCustomer+totalProductAddition+totalOTCProductAddition;
        obj.totalDeclined = (NewCustomerList.length-obj.totalNewCustomer)+(ProductAdditionList.length-obj.totalProductAddition)+(OTCProductAdditionList.length-obj.totalOTCProductAddition);
        obj.totalBids = obj.totalAwarded + obj.totalDeclined;
        
        obj.awardedSalesNewCustomer = awardedSalesNewCustomer; obj.declinedSalesNewCustomer = declinedSalesNewCustomer;
        obj.awardedSalesProductAddition = awardedSalesProductAddition; obj.declinedSalesProductAddition = declinedSalesProductAddition;
        obj.awardedSalesOTCProductAddition = awardedSalesOTCProductAddition; obj.declinedSalesOTCProductAddition = declinedSalesOTCProductAddition;
        
        obj.totalAwardedSales = awardedSalesNewCustomer+awardedSalesProductAddition+awardedSalesOTCProductAddition;
        obj.totalDeclinedSales = declinedSalesNewCustomer+declinedSalesProductAddition+declinedSalesOTCProductAddition;
        obj.instance = 'ProActive';
        component.set("v.E1Object", obj);
        component.set("v.showE1View", true);
        component.set("v.selectedQuarter", component.get("v.Q1Label"));
        component.set("v.selectedCategory", 'Proactive');
    },
    ReActiveQ1Click: function(component, event, helper){
        component.set("v.selectedOption", 'Reactive Bids');
        var ReActiveList = component.get("v.Q1ReActiveList");
        component.set("v.popupData", ReActiveList);
        var familyMap = {}; var declinedFamilyMap = {};
        var awardedCurrentSales = 0; var awardedProposedSales = 0; var awardedAwardedSales = 0;
        var declinedCurrentSales = 0; var declinedProposedSales = 0; var declinedAwardedSales = 0;
        var awardedFamilySummaryObj = {}; var declinedFamilySummaryObj = {};
        if(ReActiveList != null){
            for(var i=0; i<ReActiveList.length;i++){
                if(ReActiveList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Awarded'){
                    if(familyMap.hasOwnProperty(ReActiveList[i].Product_Family_Name__c)){
                        var relatedList = familyMap[ReActiveList[i].Product_Family_Name__c];
                        relatedList.push(ReActiveList[i]);
                        familyMap[ReActiveList[i].Product_Family_Name__c] = relatedList;
                    } else{
                        var relatedList = [];
                        relatedList.push(ReActiveList[i]);
                        familyMap[ReActiveList[i].Product_Family_Name__c] = relatedList;
                    }
                    var awardedQty = ((ReActiveList[i].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c != null) ? ReActiveList[i].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c : 0);
                    var proposedASP = ((ReActiveList[i].Phoenix_Proposed_ASP_Dose__c != null) ? ReActiveList[i].Phoenix_Proposed_ASP_Dose__c : 0);
                    var currentSales = ((ReActiveList[i].Phoenix_Current_Sales_Finance__c != null) ? ReActiveList[i].Phoenix_Current_Sales_Finance__c : 0);
                    var proposedQty = ((ReActiveList[i].Phoenix_Final_Total_Selling_Unit__c != null) ? ReActiveList[i].Phoenix_Final_Total_Selling_Unit__c : 0);
                    var awardedSales = awardedQty*proposedASP; 
                    var proposedSales = proposedQty*proposedASP;
                    awardedCurrentSales += currentSales;
                    awardedProposedSales += proposedSales;
                    awardedAwardedSales += awardedSales;
                } else if(ReActiveList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Declined by Customer'){
                    if(declinedFamilyMap.hasOwnProperty(ReActiveList[i].Product_Family_Name__c)){
                        var relatedList = declinedFamilyMap[ReActiveList[i].Product_Family_Name__c];
                        relatedList.push(ReActiveList[i]);
                        declinedFamilyMap[ReActiveList[i].Product_Family_Name__c] = relatedList;
                    } else{
                        var relatedList = [];
                        relatedList.push(ReActiveList[i]);
                        declinedFamilyMap[ReActiveList[i].Product_Family_Name__c] = relatedList;
                    }
                    var awardedQty = ((ReActiveList[i].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c != null) ? ReActiveList[i].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c : 0);
                    var proposedASP = ((ReActiveList[i].Phoenix_Proposed_ASP_Dose__c != null) ? ReActiveList[i].Phoenix_Proposed_ASP_Dose__c : 0);
                    var currentSales = ((ReActiveList[i].Phoenix_Current_Sales_Finance__c != null) ? ReActiveList[i].Phoenix_Current_Sales_Finance__c : 0);
                    var proposedQty = ((ReActiveList[i].Phoenix_Final_Total_Selling_Unit__c != null) ? ReActiveList[i].Phoenix_Final_Total_Selling_Unit__c : 0);
                    var awardedSales = awardedQty*proposedASP; 
                    var proposedSales = proposedQty*proposedASP;
                    declinedCurrentSales += currentSales;
                    declinedProposedSales += proposedSales;
                    declinedAwardedSales += awardedSales;
                }
            }   
        }
        
        var familyMapKeys = Object.keys(familyMap);
        var declinedFamilyMapKeys = Object.keys(declinedFamilyMap);
        for(var i=0; i<familyMapKeys.length; i++){
            var relatedList = familyMap[familyMapKeys[i]];
            var awardedSales = 0;
            for(var j=0; j<relatedList.length; j++){
                var awardedQty = ((relatedList[j].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c != null) ? relatedList[j].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c : 0);
                var proposedASP = ((relatedList[j].Phoenix_Proposed_ASP_Dose__c != null) ? relatedList[j].Phoenix_Proposed_ASP_Dose__c : 0);
                awardedSales += awardedQty*proposedASP;
            }
            awardedFamilySummaryObj[familyMapKeys[i]] = awardedSales;
        }
        for(var i=0; i<declinedFamilyMapKeys.length; i++){
            var relatedList = declinedFamilyMap[declinedFamilyMapKeys[i]];
            var proposedSales = 0;
            for(var j=0; j<relatedList.length; j++){
                var proposedASP = ((relatedList[j].Phoenix_Proposed_ASP_Dose__c != null) ? relatedList[j].Phoenix_Proposed_ASP_Dose__c : 0);
                var proposedQty = ((relatedList[j].Phoenix_Final_Total_Selling_Unit__c != null) ? relatedList[j].Phoenix_Final_Total_Selling_Unit__c : 0);
                proposedSales += proposedQty*proposedASP;
            }
            declinedFamilySummaryObj[declinedFamilyMapKeys[i]] = proposedSales;
        }
        
        let keys = Object.keys(awardedFamilySummaryObj);
        keys.sort(function(a, b) { return awardedFamilySummaryObj[b] - awardedFamilySummaryObj[a] });
        component.set("v.familyKeys", keys);
        
        let declinedKeys = Object.keys(declinedFamilySummaryObj);
        declinedKeys.sort(function(a, b) { return declinedFamilySummaryObj[b] - declinedFamilySummaryObj[a] });
        component.set("v.declinedFamilyKeys", declinedKeys);
        
        var finalAwardedSummaryObj = {};
        finalAwardedSummaryObj.awardedCurrentSales = awardedCurrentSales;
        finalAwardedSummaryObj.awardedProposedSales = awardedProposedSales;
        finalAwardedSummaryObj.awardedAwardedSales = awardedAwardedSales;
        var finalDeclinedSummaryObj = {};
        finalDeclinedSummaryObj.declinedCurrentSales = declinedCurrentSales;
        finalDeclinedSummaryObj.declinedProposedSales = declinedProposedSales;
        finalDeclinedSummaryObj.declinedAwardedSales = declinedAwardedSales;
        
        component.set("v.finalAwardedSummaryObj", finalAwardedSummaryObj);
        component.set("v.finalDeclinedSummaryObj", finalDeclinedSummaryObj);
        
        
        var RFPList = []; var OTCRFPList = [];
        var OTBList = [];var VolumeReviewList = []; var OTCVolumeReviewList = [];
        var totalRFP = 0; var totalOTCRFP = 0; var totalOTBs = 0; var totalVolumeReview = 0; var totalOTCVolumeReview = 0;
        var awardedSalesRFP = 0; var declinedSalesRFP = 0; var awardedSalesOTCRFP = 0; var declinedSalesOTCRFP = 0; 
        var awardedSalesOTB = 0; var declinedSalesOTB = 0;  var awardedSalesVolumeReview = 0; var declinedSalesVolumeReview = 0; 
        var awardedSalesOTCVolumeReview = 0; var declinedSalesOTCVolumeReview = 0; 
        var obj = {}; var awardedRFPBidsList = []; var declinedRFPBidsList = [];
        if(ReActiveList != null){
            for(var i=0; i<ReActiveList.length; i++){
                var currentSales = ((ReActiveList[i].Phoenix_Current_Sales_Finance__c != null) ? ReActiveList[i].Phoenix_Current_Sales_Finance__c : 0);
                var awardedQty = ((ReActiveList[i].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c != null) ? ReActiveList[i].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c : 0);
                var proposedASP = ((ReActiveList[i].Phoenix_Proposed_ASP_Dose__c != null) ? ReActiveList[i].Phoenix_Proposed_ASP_Dose__c : 0);
                var proposedQty = ((ReActiveList[i].Phoenix_Final_Total_Selling_Unit__c != null) ? ReActiveList[i].Phoenix_Final_Total_Selling_Unit__c : 0);
                var awardedSales = awardedQty*proposedASP;
                var proposedSales = proposedQty*proposedASP;
                if((ReActiveList[i].Phoenix_Bid__r.Phoenix_Bid_Type__c == 'RFP Bids' || ReActiveList[i].Phoenix_Bid__r.Phoenix_Bid_Type__c == 'OTC RFP') && ((((awardedQty * proposedASP) >= currentSales)) || (((proposedSales) > currentSales))) ){
                    if(!RFPList.includes(ReActiveList[i].Phoenix_Bid__c)){
                        if(ReActiveList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Awarded'){
                            totalRFP += 1;
                        }
                        RFPList.push(ReActiveList[i].Phoenix_Bid__c);   
                    }
                    if(ReActiveList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Awarded'){
                        if(!awardedRFPBidsList.includes(ReActiveList[i].Phoenix_Bid__r.Name)){
                            awardedRFPBidsList.push(ReActiveList[i].Phoenix_Bid__r.Name);
                        }
                        awardedSalesRFP += (awardedSales-currentSales);
                    } else if(ReActiveList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Declined by Customer'){
                        declinedSalesRFP += (proposedSales-currentSales);                            
                    }
                } 
                /*else if(ReActiveList[i].Phoenix_Bid__r.Phoenix_Bid_Type__c == 'OTC RFP'){
                    if(!OTCRFPList.includes(ReActiveList[i].Phoenix_Bid__c)){
                        if(ReActiveList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Awarded'){
                            totalOTCRFP += 1;
                        }
                        OTCRFPList.push(ReActiveList[i].Phoenix_Bid__c);   
                    }
                    if(ReActiveList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Awarded'){
                        awardedSalesOTCRFP += (awardedSales-currentSales);
                    } else if(ReActiveList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Declined by Customer'){
                        declinedSalesOTCRFP += (proposedSales-currentSales);                                       
                    }
                } */
                else if(ReActiveList[i].Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Good Dated OTB' || ReActiveList[i].Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Short Dated OTB' || ReActiveList[i].Phoenix_Bid__r.Phoenix_Bid_Type__c == 'OTC OTB Good Dated' ||
                        ReActiveList[i].Phoenix_Bid__r.Phoenix_Bid_Type__c == 'OTC OTB Short Dated'){
                    if(!OTBList.includes(ReActiveList[i].Phoenix_Bid__c)){
                        if(ReActiveList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Awarded'){
                            totalOTBs += 1;
                        }
                        OTBList.push(ReActiveList[i].Phoenix_Bid__c);   
                    }
                    if(ReActiveList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Awarded'){
                        awardedSalesOTB += (awardedSales-currentSales);
                    } else if(ReActiveList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Declined by Customer'){
                        declinedSalesOTB += (proposedSales-currentSales);                                
                    }
                } else if(ReActiveList[i].Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Volume Review Only' || ReActiveList[i].Phoenix_Bid__r.Phoenix_Bid_Type__c == 'OTC Volume Review'){
                    if(!VolumeReviewList.includes(ReActiveList[i].Phoenix_Bid__c)){
                        if(ReActiveList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Awarded'){
                            totalVolumeReview += 1;
                        }
                        VolumeReviewList.push(ReActiveList[i].Phoenix_Bid__c);   
                    }
                    if(ReActiveList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Awarded'){
                        awardedSalesVolumeReview += (awardedSales-currentSales);
                    } else if(ReActiveList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Declined by Customer'){
                        declinedSalesVolumeReview += (proposedSales-currentSales);                                
                    }
                } 
                    /*else if(ReActiveList[i].Phoenix_Bid__r.Phoenix_Bid_Type__c == 'OTC Volume Review'){
                    if(!OTCVolumeReviewList.includes(ReActiveList[i].Phoenix_Bid__c)){
                        if(ReActiveList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Awarded'){
                            totalOTCVolumeReview += 1;
                        }
                        OTCVolumeReviewList.push(ReActiveList[i].Phoenix_Bid__c);   
                    }
                    if(ReActiveList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Awarded'){
                        awardedSalesOTCVolumeReview += (awardedSales-currentSales);
                    } else if(ReActiveList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Declined by Customer'){
                        declinedSalesOTCVolumeReview += (proposedSales-currentSales);                                  
                    }
                }*/
            }
            /*if(awardedRFPBidsList != null){
                totalRFP = awardedRFPBidsList.length;
            }*/
        }
        obj.RFPList = RFPList;  obj.OTCRFPList = OTCRFPList; obj.OTBList = OTBList;
        obj.VolumeReviewList = VolumeReviewList; obj.OTCVolumeReviewList = OTCVolumeReviewList;
        obj.totalRFP = totalRFP; obj.totalOTCRFP = totalOTCRFP; 
        obj.totalOTBs = totalOTBs; obj.totalVolumeReview = totalVolumeReview; 
        obj.totalOTCVolumeReview = totalOTCVolumeReview;
        
        obj.totalAwarded = totalRFP+totalOTCRFP+totalOTBs+totalVolumeReview+totalOTCVolumeReview;
        obj.totalDeclined = (RFPList.length-obj.totalRFP)+(OTCRFPList.length-obj.totalOTCRFP)+(OTBList.length-obj.totalOTBs)+(VolumeReviewList.length-obj.totalVolumeReview)+(OTCVolumeReviewList.length-obj.totalOTCVolumeReview);
        obj.totalBids = obj.totalAwarded + obj.totalDeclined;
        
        obj.awardedSalesRFP = awardedSalesRFP; obj.declinedSalesRFP = declinedSalesRFP;
        obj.awardedSalesOTCRFP = awardedSalesOTCRFP; obj.declinedSalesOTCRFP = declinedSalesOTCRFP;
        obj.awardedSalesOTB = awardedSalesOTB; obj.declinedSalesOTB = declinedSalesOTB;
        obj.awardedSalesVolumeReview = awardedSalesVolumeReview; obj.declinedSalesVolumeReview = declinedSalesVolumeReview;
        obj.awardedSalesOTCVolumeReview = awardedSalesOTCVolumeReview; obj.declinedSalesOTCVolumeReview = declinedSalesOTCVolumeReview;
        
        obj.totalAwardedSales = awardedSalesRFP+awardedSalesOTCRFP+awardedSalesOTB+awardedSalesVolumeReview+awardedSalesOTCVolumeReview;
        obj.totalDeclinedSales = declinedSalesRFP+declinedSalesOTCRFP+declinedSalesOTB+declinedSalesVolumeReview+declinedSalesOTCVolumeReview;
        
        obj.instance = 'ReActive';
        component.set("v.E1Object", obj);
        component.set("v.showE1View", true);
        component.set("v.selectedQuarter", component.get("v.Q1Label"));
        component.set("v.selectedCategory", 'Reactive');
    },
    ROFRQ1Click: function(component, event, helper){
        component.set("v.selectedOption", 'Right of First Refusals (ROFRs)');
        var ROFRList = component.get("v.Q1ROFRsList");
        component.set("v.popupData", ROFRList);
        var familyMap = {}; var declinedFamilyMap = {};
        var awardedCurrentSales = 0; var awardedProposedSales = 0; var awardedAwardedSales = 0;
        var declinedCurrentSales = 0; var declinedProposedSales = 0; var declinedAwardedSales = 0;
        var awardedFamilySummaryObj = {}; var declinedFamilySummaryObj = {};
        if(ROFRList != null){
            for(var i=0; i<ROFRList.length;i++){
                if(ROFRList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Awarded'){
                    if(familyMap.hasOwnProperty(ROFRList[i].Product_Family_Name__c)){
                        var relatedList = familyMap[ROFRList[i].Product_Family_Name__c];
                        relatedList.push(ROFRList[i]);
                        familyMap[ROFRList[i].Product_Family_Name__c] = relatedList;
                    } else{
                        var relatedList = [];
                        relatedList.push(ROFRList[i]);
                        familyMap[ROFRList[i].Product_Family_Name__c] = relatedList;
                    }
                    var awardedQty = ((ROFRList[i].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c != null) ? ROFRList[i].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c : 0);
                    var proposedASP = ((ROFRList[i].Phoenix_Proposed_ASP_Dose__c != null) ? ROFRList[i].Phoenix_Proposed_ASP_Dose__c : 0);
                    var currentSales = ((ROFRList[i].Phoenix_Current_Sales_Finance__c != null) ? ROFRList[i].Phoenix_Current_Sales_Finance__c : 0);
                    var proposedQty = ((ROFRList[i].Phoenix_Final_Total_Selling_Unit__c != null) ? ROFRList[i].Phoenix_Final_Total_Selling_Unit__c : 0);
                    var awardedSales = awardedQty*proposedASP; 
                    var proposedSales = proposedQty*proposedASP;
                    awardedCurrentSales += currentSales;
                    awardedProposedSales += proposedSales;
                    awardedAwardedSales += awardedSales;
                } else if(ROFRList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Declined by Customer'){
                    if(declinedFamilyMap.hasOwnProperty(ROFRList[i].Product_Family_Name__c)){
                        var relatedList = declinedFamilyMap[ROFRList[i].Product_Family_Name__c];
                        relatedList.push(ROFRList[i]);
                        declinedFamilyMap[ROFRList[i].Product_Family_Name__c] = relatedList;
                    } else{
                        var relatedList = [];
                        relatedList.push(ROFRList[i]);
                        declinedFamilyMap[ROFRList[i].Product_Family_Name__c] = relatedList;
                    }
                    var awardedQty = ((ROFRList[i].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c != null) ? ROFRList[i].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c : 0);
                    var proposedASP = ((ROFRList[i].Phoenix_Proposed_ASP_Dose__c != null) ? ROFRList[i].Phoenix_Proposed_ASP_Dose__c : 0);
                    var currentSales = ((ROFRList[i].Phoenix_Current_Sales_Finance__c != null) ? ROFRList[i].Phoenix_Current_Sales_Finance__c : 0);
                    var proposedQty = ((ROFRList[i].Phoenix_Final_Total_Selling_Unit__c != null) ? ROFRList[i].Phoenix_Final_Total_Selling_Unit__c : 0);
                    var awardedSales = awardedQty*proposedASP; 
                    var proposedSales = proposedQty*proposedASP;
                    declinedCurrentSales += currentSales;
                    declinedProposedSales += proposedSales;
                    declinedAwardedSales += awardedSales;
                }
            }   
        }
        
        var familyMapKeys = Object.keys(familyMap);
        var declinedFamilyMapKeys = Object.keys(declinedFamilyMap);
        for(var i=0; i<familyMapKeys.length; i++){
            var relatedList = familyMap[familyMapKeys[i]];
            var awardedSales = 0;
            for(var j=0; j<relatedList.length; j++){
                var awardedQty = ((relatedList[j].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c != null) ? relatedList[j].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c : 0);
                var proposedASP = ((relatedList[j].Phoenix_Proposed_ASP_Dose__c != null) ? relatedList[j].Phoenix_Proposed_ASP_Dose__c : 0);
                awardedSales += awardedQty*proposedASP;
            }
            awardedFamilySummaryObj[familyMapKeys[i]] = awardedSales;
        }
        for(var i=0; i<declinedFamilyMapKeys.length; i++){
            var relatedList = declinedFamilyMap[declinedFamilyMapKeys[i]];
            var proposedSales = 0;
            for(var j=0; j<relatedList.length; j++){
                var proposedASP = ((relatedList[j].Phoenix_Proposed_ASP_Dose__c != null) ? relatedList[j].Phoenix_Proposed_ASP_Dose__c : 0);
                var proposedQty = ((relatedList[j].Phoenix_Final_Total_Selling_Unit__c != null) ? relatedList[j].Phoenix_Final_Total_Selling_Unit__c : 0);
                proposedSales += proposedQty*proposedASP;
            }
            declinedFamilySummaryObj[declinedFamilyMapKeys[i]] = proposedSales;
        }
        
        let keys = Object.keys(awardedFamilySummaryObj);
        keys.sort(function(a, b) { return awardedFamilySummaryObj[b] - awardedFamilySummaryObj[a] });
        component.set("v.familyKeys", keys);
        
        let declinedKeys = Object.keys(declinedFamilySummaryObj);
        declinedKeys.sort(function(a, b) { return declinedFamilySummaryObj[b] - declinedFamilySummaryObj[a] });
        component.set("v.declinedFamilyKeys", declinedKeys);
        
        var finalAwardedSummaryObj = {};
        finalAwardedSummaryObj.awardedCurrentSales = awardedCurrentSales;
        finalAwardedSummaryObj.awardedProposedSales = awardedProposedSales;
        finalAwardedSummaryObj.awardedAwardedSales = awardedAwardedSales;
        var finalDeclinedSummaryObj = {};
        finalDeclinedSummaryObj.declinedCurrentSales = declinedCurrentSales;
        finalDeclinedSummaryObj.declinedProposedSales = declinedProposedSales;
        finalDeclinedSummaryObj.declinedAwardedSales = declinedAwardedSales;
        
        component.set("v.finalAwardedSummaryObj", finalAwardedSummaryObj);
        component.set("v.finalDeclinedSummaryObj", finalDeclinedSummaryObj);
        
        
        var RFPList = []; var OTCRFPList = [];
        var PriceChangeList = [];var OTCPriceChangeList = [];
        var totalRFP = 0; var totalOTCRFP = 0; var totalPriceChange = 0; var totalOTCPriceChange = 0;
        var awardedSalesRFP = 0; var declinedSalesRFP = 0; var awardedSalesOTCRFP = 0; var declinedSalesOTCRFP = 0;
        var awardedSalesPriceChange = 0; var declinedSalesPriceChange = 0; var awardedSalesOTCPriceChange = 0; var declinedSalesOTCPriceChange = 0;
        var obj = {};
        if(ROFRList != null){
            for(var i=0; i<ROFRList.length; i++){
                var currentSales = ((ROFRList[i].Phoenix_Current_Sales_Finance__c != null) ? ROFRList[i].Phoenix_Current_Sales_Finance__c : 0);
                var awardedQty = ((ROFRList[i].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c != null) ? ROFRList[i].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c : 0);
                var proposedASP = ((ROFRList[i].Phoenix_Proposed_ASP_Dose__c != null) ? ROFRList[i].Phoenix_Proposed_ASP_Dose__c : 0);
                var proposedQty = ((ROFRList[i].Phoenix_Final_Total_Selling_Unit__c != null) ? ROFRList[i].Phoenix_Final_Total_Selling_Unit__c : 0);
                var awardedSales = awardedQty*proposedASP;
                var proposedSales = proposedQty*proposedASP;
                
                if((ROFRList[i].Phoenix_Bid__r.Phoenix_Bid_Type__c == 'RFP Bids' || ROFRList[i].Phoenix_Bid__r.Phoenix_Bid_Type__c == 'OTC RFP') && ((((awardedQty * proposedASP) < currentSales) && currentSales > 0) || ((proposedSales <= currentSales) && currentSales > 0))){
                    if(!RFPList.includes(ROFRList[i].Phoenix_Bid__c)){
                        if(ROFRList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Awarded'){
                            totalRFP += 1;
                        }
                        RFPList.push(ROFRList[i].Phoenix_Bid__c); 
                    }
                    if(ROFRList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Awarded'){
                        awardedSalesRFP += (awardedSales-currentSales);
                    } else if(ROFRList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Declined by Customer'){
                        //declinedSalesRFP += (awardedSales-currentSales);             
                        declinedSalesRFP += (awardedSales-currentSales);
                    }
                } 
                /*else if(ROFRList[i].Phoenix_Bid__r.Phoenix_Bid_Type__c == 'OTC RFP'){
                    if(!OTCRFPList.includes(ROFRList[i].Phoenix_Bid__c)){
                        if(ROFRList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Awarded'){
                            totalOTCRFP += 1;
                        }
                        OTCRFPList.push(ROFRList[i].Phoenix_Bid__c);   
                    }
                    if(ROFRList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Awarded'){
                        awardedSalesOTCRFP += (awardedSales-currentSales);
                    } else if(ROFRList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Declined by Customer'){
                        declinedSalesOTCRFP += currentSales;                                      
                    }
                } */
                else if(ROFRList[i].Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Price Change' || ROFRList[i].Phoenix_Bid__r.Phoenix_Bid_Type__c == 'OTC Price Change'){
                    if(!PriceChangeList.includes(ROFRList[i].Phoenix_Bid__c)){
                        if(ROFRList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Awarded'){
                            totalPriceChange += 1;
                        }
                        PriceChangeList.push(ROFRList[i].Phoenix_Bid__c);   
                    }
                    if(ROFRList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Awarded'){
                        awardedSalesPriceChange += (awardedSales-currentSales);
                    } else if(ROFRList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Declined by Customer'){
                        declinedSalesPriceChange += (awardedSales-currentSales);
                    }
                } 
                    /*else if(ROFRList[i].Phoenix_Bid__r.Phoenix_Bid_Type__c == 'OTC Price Change'){
                    if(!OTCPriceChangeList.includes(ROFRList[i].Phoenix_Bid__c)){
                        if(ROFRList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Awarded'){
                            totalOTCPriceChange += 1;
                        }
                        OTCPriceChangeList.push(ROFRList[i].Phoenix_Bid__c);   
                    }
                    if(ROFRList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Awarded'){
                        awardedSalesOTCPriceChange += (awardedSales-currentSales);
                    } else if(ROFRList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Declined by Customer'){
                        declinedSalesOTCPriceChange += currentSales;                                      
                    }
                }*/
            }
        }
        obj.RFPList = RFPList;  obj.OTCRFPList = OTCRFPList;
        obj.PriceChangeList = PriceChangeList; obj.OTCPriceChangeList = OTCPriceChangeList;
        obj.totalRFP = totalRFP; obj.totalOTCRFP = totalOTCRFP; obj.totalPriceChange = totalPriceChange; obj.totalOTCPriceChange = totalOTCPriceChange;
        
        obj.totalAwarded = totalRFP+totalOTCRFP+totalPriceChange+totalOTCPriceChange;
        obj.totalDeclined = (RFPList.length-obj.totalRFP)+(OTCRFPList.length-obj.totalOTCRFP)+(PriceChangeList.length-obj.totalPriceChange)+(OTCPriceChangeList.length-obj.totalOTCPriceChange);
        obj.totalBids = obj.totalAwarded + obj.totalDeclined;
        
        obj.awardedSalesRFP = awardedSalesRFP; obj.declinedSalesRFP = declinedSalesRFP;
        obj.awardedSalesOTCRFP = awardedSalesOTCRFP; obj.declinedSalesOTCRFP = declinedSalesOTCRFP;
        obj.awardedSalesPriceChange = awardedSalesPriceChange; obj.declinedSalesPriceChange = declinedSalesPriceChange;
        obj.awardedSalesOTCPriceChange = awardedSalesOTCPriceChange; obj.declinedSalesOTCPriceChange = declinedSalesOTCPriceChange;
        
        obj.totalAwardedSales = awardedSalesRFP+awardedSalesOTCRFP+awardedSalesPriceChange+awardedSalesOTCPriceChange;
        obj.totalDeclinedSales = declinedSalesRFP+declinedSalesOTCRFP+declinedSalesPriceChange+declinedSalesOTCPriceChange;
        
        obj.instance = 'ROFR';
        component.set("v.E1Object", obj);
        component.set("v.showE1View", true);
        component.set("v.selectedQuarter", component.get("v.Q1Label"));
        component.set("v.selectedCategory", 'ROFR');
    },
    NPLQ2Click: function(component, event, helper){
        component.set("v.selectedOption", 'New Product Launchs (NPLs)');
        var NPLList = component.get("v.Q2NewProductLaunchList");
        component.set("v.popupData", NPLList);
        var familyMap = {}; var declinedFamilyMap = {};
        var awardedCurrentSales = 0; var awardedProposedSales = 0; var awardedAwardedSales = 0;
        var declinedCurrentSales = 0; var declinedProposedSales = 0; var declinedAwardedSales = 0;
        var awardedFamilySummaryObj = {}; var declinedFamilySummaryObj = {};
        if(NPLList != null){
            for(var i=0; i<NPLList.length;i++){
                if(NPLList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Awarded'){
                    if(familyMap.hasOwnProperty(NPLList[i].Product_Family_Name__c)){
                        var relatedList = familyMap[NPLList[i].Product_Family_Name__c];
                        relatedList.push(NPLList[i]);
                        familyMap[NPLList[i].Product_Family_Name__c] = relatedList;
                    } else{
                        var relatedList = [];
                        relatedList.push(NPLList[i]);
                        familyMap[NPLList[i].Product_Family_Name__c] = relatedList;
                    }
                    var awardedQty = ((NPLList[i].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c != null) ? NPLList[i].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c : 0);
                    var proposedASP = ((NPLList[i].Phoenix_Proposed_ASP_Dose__c != null) ? NPLList[i].Phoenix_Proposed_ASP_Dose__c : 0);
                    var currentSales = ((NPLList[i].Phoenix_Current_Sales_Finance__c != null) ? NPLList[i].Phoenix_Current_Sales_Finance__c : 0);
                    var proposedQty = ((NPLList[i].Phoenix_Final_Total_Selling_Unit__c != null) ? NPLList[i].Phoenix_Final_Total_Selling_Unit__c : 0);
                    var awardedSales = awardedQty*proposedASP; 
                    var proposedSales = proposedQty*proposedASP;
                    awardedCurrentSales += currentSales;
                    awardedProposedSales += proposedSales;
                    awardedAwardedSales += awardedSales;
                } else if(NPLList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Declined by Customer'){
                    if(declinedFamilyMap.hasOwnProperty(NPLList[i].Product_Family_Name__c)){
                        var relatedList = declinedFamilyMap[NPLList[i].Product_Family_Name__c];
                        relatedList.push(NPLList[i]);
                        declinedFamilyMap[NPLList[i].Product_Family_Name__c] = relatedList;
                    } else{
                        var relatedList = [];
                        relatedList.push(NPLList[i]);
                        declinedFamilyMap[NPLList[i].Product_Family_Name__c] = relatedList;
                    }
                    var awardedQty = ((NPLList[i].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c != null) ? NPLList[i].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c : 0);
                    var proposedASP = ((NPLList[i].Phoenix_Proposed_ASP_Dose__c != null) ? NPLList[i].Phoenix_Proposed_ASP_Dose__c : 0);
                    var currentSales = ((NPLList[i].Phoenix_Current_Sales_Finance__c != null) ? NPLList[i].Phoenix_Current_Sales_Finance__c : 0);
                    var proposedQty = ((NPLList[i].Phoenix_Final_Total_Selling_Unit__c != null) ? NPLList[i].Phoenix_Final_Total_Selling_Unit__c : 0);
                    var awardedSales = awardedQty*proposedASP; 
                    var proposedSales = proposedQty*proposedASP;
                    declinedCurrentSales += currentSales;
                    declinedProposedSales += proposedSales;
                    declinedAwardedSales += awardedSales;
                }
            }   
        }
        
        var familyMapKeys = Object.keys(familyMap);
        var declinedFamilyMapKeys = Object.keys(declinedFamilyMap);
        for(var i=0; i<familyMapKeys.length; i++){
            var relatedList = familyMap[familyMapKeys[i]];
            var awardedSales = 0;
            for(var j=0; j<relatedList.length; j++){
                var awardedQty = ((relatedList[j].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c != null) ? relatedList[j].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c : 0);
                var proposedASP = ((relatedList[j].Phoenix_Proposed_ASP_Dose__c != null) ? relatedList[j].Phoenix_Proposed_ASP_Dose__c : 0);
                awardedSales += awardedQty*proposedASP;
            }
            awardedFamilySummaryObj[familyMapKeys[i]] = awardedSales;
        }
        for(var i=0; i<declinedFamilyMapKeys.length; i++){
            var relatedList = declinedFamilyMap[declinedFamilyMapKeys[i]];
            var proposedSales = 0;
            for(var j=0; j<relatedList.length; j++){
                var proposedASP = ((relatedList[j].Phoenix_Proposed_ASP_Dose__c != null) ? relatedList[j].Phoenix_Proposed_ASP_Dose__c : 0);
                var proposedQty = ((relatedList[j].Phoenix_Final_Total_Selling_Unit__c != null) ? relatedList[j].Phoenix_Final_Total_Selling_Unit__c : 0);
                proposedSales += proposedQty*proposedASP;
            }
            declinedFamilySummaryObj[declinedFamilyMapKeys[i]] = proposedSales;
        }
        
        let keys = Object.keys(awardedFamilySummaryObj);
        keys.sort(function(a, b) { return awardedFamilySummaryObj[b] - awardedFamilySummaryObj[a] });
        component.set("v.familyKeys", keys);
        
        let declinedKeys = Object.keys(declinedFamilySummaryObj);
        declinedKeys.sort(function(a, b) { return declinedFamilySummaryObj[b] - declinedFamilySummaryObj[a] });
        component.set("v.declinedFamilyKeys", declinedKeys);
        
        var finalAwardedSummaryObj = {};
        finalAwardedSummaryObj.awardedCurrentSales = awardedCurrentSales;
        finalAwardedSummaryObj.awardedProposedSales = awardedProposedSales;
        finalAwardedSummaryObj.awardedAwardedSales = awardedAwardedSales;
        var finalDeclinedSummaryObj = {};
        finalDeclinedSummaryObj.declinedCurrentSales = declinedCurrentSales;
        finalDeclinedSummaryObj.declinedProposedSales = declinedProposedSales;
        finalDeclinedSummaryObj.declinedAwardedSales = declinedAwardedSales;
        
        component.set("v.finalAwardedSummaryObj", finalAwardedSummaryObj);
        component.set("v.finalDeclinedSummaryObj", finalDeclinedSummaryObj);
        
        
        var NewProductList = []; var OTCNewProductList = [];
        var obj = {}; var totalNPL = 0; var totalOTCNPL = 0; var awardedSalesNPL = 0; var declinedSalesNPL = 0; var awardedSalesOTCNPL = 0; var declinedSalesOTCNPL = 0;
        if(NPLList != null){
            for(var i=0; i<NPLList.length; i++){
                var currentSales = ((NPLList[i].Phoenix_Current_Sales_Finance__c != null) ? NPLList[i].Phoenix_Current_Sales_Finance__c : 0);
                var awardedQty = ((NPLList[i].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c != null) ? NPLList[i].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c : 0);
                var proposedASP = ((NPLList[i].Phoenix_Proposed_ASP_Dose__c != null) ? NPLList[i].Phoenix_Proposed_ASP_Dose__c : 0);
                var proposedQty = ((NPLList[i].Phoenix_Final_Total_Selling_Unit__c != null) ? NPLList[i].Phoenix_Final_Total_Selling_Unit__c : 0);
                var awardedSales = awardedQty*proposedASP;
                var proposedSales = proposedQty*proposedASP;
                if(NPLList[i].Phoenix_Bid__r.Phoenix_Bid_Type__c == 'New Product Launch' || NPLList[i].Phoenix_Bid__r.Phoenix_Bid_Type__c == 'OTC New Product'){
                    if(!NewProductList.includes(NPLList[i].Phoenix_Bid__c)){
                        if(NPLList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Awarded'){
                            totalNPL += 1;
                        }
                        NewProductList.push(NPLList[i].Phoenix_Bid__c);
                    }
                    if(NPLList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Awarded'){
                        awardedSalesNPL += (awardedSales-currentSales);
                    } else if(NPLList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Declined by Customer'){
                        declinedSalesNPL += (proposedSales-currentSales);                            
                    }
                } 
                /*else if(NPLList[i].Phoenix_Bid__r.Phoenix_Bid_Type__c == 'OTC New Product'){
                    if(!OTCNewProductList.includes(NPLList[i].Phoenix_Bid__c)){
                        if(NPLList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Awarded'){
                            totalOTCNPL += 1;
                        }
                        OTCNewProductList.push(NPLList[i].Phoenix_Bid__c);   
                    }
                    if(NPLList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Awarded'){
                        awardedSalesOTCNPL += awardedSales;
                    } else if(NPLList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Declined by Customer'){
                        declinedSalesOTCNPL += proposedSales;                            
                    }
                }*/
            }
        }
        obj.NewProductList = NewProductList;
        obj.OTCNewProductList = OTCNewProductList;
        obj.totalNPL = totalNPL;
        obj.totalOTCNPL = totalOTCNPL;
        obj.totalAwarded = totalNPL+totalOTCNPL;
        obj.totalDeclined = (NewProductList.length-obj.totalNPL)+(OTCNewProductList.length-obj.totalOTCNPL);
        obj.totalBids = obj.totalAwarded + obj.totalDeclined;
        obj.awardedSalesNPL = awardedSalesNPL; obj.declinedSalesNPL = declinedSalesNPL; 
        obj.awardedSalesOTCNPL = awardedSalesOTCNPL; obj.declinedSalesOTCNPL = declinedSalesOTCNPL;
        
        obj.totalAwardedSales = awardedSalesNPL+awardedSalesOTCNPL;
        obj.totalDeclinedSales = declinedSalesNPL+declinedSalesOTCNPL;
        
        obj.instance = 'NPL';
        component.set("v.E1Object", obj);
        component.set("v.showE1View", true);
        component.set("v.selectedQuarter", component.get("v.Q2Label"));
        component.set("v.selectedCategory", 'NPL');
    },
    ProActiveQ2Click: function(component, event, helper){
        component.set("v.selectedOption", 'Proactive Bids');
        var ProActiveList = component.get("v.Q2ProActiveList");
        component.set("v.popupData", ProActiveList);
        var familyMap = {}; var declinedFamilyMap = {};
        var awardedCurrentSales = 0; var awardedProposedSales = 0; var awardedAwardedSales = 0;
        var declinedCurrentSales = 0; var declinedProposedSales = 0; var declinedAwardedSales = 0;
        var awardedFamilySummaryObj = {}; var declinedFamilySummaryObj = {};
        if(ProActiveList != null){
            for(var i=0; i<ProActiveList.length;i++){
                if(ProActiveList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Awarded'){
                    if(familyMap.hasOwnProperty(ProActiveList[i].Product_Family_Name__c)){
                        var relatedList = familyMap[ProActiveList[i].Product_Family_Name__c];
                        relatedList.push(ProActiveList[i]);
                        familyMap[ProActiveList[i].Product_Family_Name__c] = relatedList;
                    } else{
                        var relatedList = [];
                        relatedList.push(ProActiveList[i]);
                        familyMap[ProActiveList[i].Product_Family_Name__c] = relatedList;
                    }
                    var awardedQty = ((ProActiveList[i].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c != null) ? ProActiveList[i].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c : 0);
                    var proposedASP = ((ProActiveList[i].Phoenix_Proposed_ASP_Dose__c != null) ? ProActiveList[i].Phoenix_Proposed_ASP_Dose__c : 0);
                    var currentSales = ((ProActiveList[i].Phoenix_Current_Sales_Finance__c != null) ? ProActiveList[i].Phoenix_Current_Sales_Finance__c : 0);
                    var proposedQty = ((ProActiveList[i].Phoenix_Final_Total_Selling_Unit__c != null) ? ProActiveList[i].Phoenix_Final_Total_Selling_Unit__c : 0);
                    var awardedSales = awardedQty*proposedASP; 
                    var proposedSales = proposedQty*proposedASP;
                    awardedCurrentSales += currentSales;
                    awardedProposedSales += proposedSales;
                    awardedAwardedSales += awardedSales;
                } else if(ProActiveList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Declined by Customer'){
                    if(declinedFamilyMap.hasOwnProperty(ProActiveList[i].Product_Family_Name__c)){
                        var relatedList = declinedFamilyMap[ProActiveList[i].Product_Family_Name__c];
                        relatedList.push(ProActiveList[i]);
                        declinedFamilyMap[ProActiveList[i].Product_Family_Name__c] = relatedList;
                    } else{
                        var relatedList = [];
                        relatedList.push(ProActiveList[i]);
                        declinedFamilyMap[ProActiveList[i].Product_Family_Name__c] = relatedList;
                    }
                    var awardedQty = ((ProActiveList[i].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c != null) ? ProActiveList[i].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c : 0);
                    var proposedASP = ((ProActiveList[i].Phoenix_Proposed_ASP_Dose__c != null) ? ProActiveList[i].Phoenix_Proposed_ASP_Dose__c : 0);
                    var currentSales = ((ProActiveList[i].Phoenix_Current_Sales_Finance__c != null) ? ProActiveList[i].Phoenix_Current_Sales_Finance__c : 0);
                    var proposedQty = ((ProActiveList[i].Phoenix_Final_Total_Selling_Unit__c != null) ? ProActiveList[i].Phoenix_Final_Total_Selling_Unit__c : 0);
                    var awardedSales = awardedQty*proposedASP; 
                    var proposedSales = proposedQty*proposedASP;
                    declinedCurrentSales += currentSales;
                    declinedProposedSales += proposedSales;
                    declinedAwardedSales += awardedSales;
                }
            }   
        }
        
        var familyMapKeys = Object.keys(familyMap);
        var declinedFamilyMapKeys = Object.keys(declinedFamilyMap);
        for(var i=0; i<familyMapKeys.length; i++){
            var relatedList = familyMap[familyMapKeys[i]];
            var awardedSales = 0;
            for(var j=0; j<relatedList.length; j++){
                var awardedQty = ((relatedList[j].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c != null) ? relatedList[j].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c : 0);
                var proposedASP = ((relatedList[j].Phoenix_Proposed_ASP_Dose__c != null) ? relatedList[j].Phoenix_Proposed_ASP_Dose__c : 0);
                awardedSales += awardedQty*proposedASP;
            }
            awardedFamilySummaryObj[familyMapKeys[i]] = awardedSales;
        }
        for(var i=0; i<declinedFamilyMapKeys.length; i++){
            var relatedList = declinedFamilyMap[declinedFamilyMapKeys[i]];
            var proposedSales = 0;
            for(var j=0; j<relatedList.length; j++){
                var proposedASP = ((relatedList[j].Phoenix_Proposed_ASP_Dose__c != null) ? relatedList[j].Phoenix_Proposed_ASP_Dose__c : 0);
                var proposedQty = ((relatedList[j].Phoenix_Final_Total_Selling_Unit__c != null) ? relatedList[j].Phoenix_Final_Total_Selling_Unit__c : 0);
                proposedSales += proposedQty*proposedASP;
            }
            declinedFamilySummaryObj[declinedFamilyMapKeys[i]] = proposedSales;
        }
        
        let keys = Object.keys(awardedFamilySummaryObj);
        keys.sort(function(a, b) { return awardedFamilySummaryObj[b] - awardedFamilySummaryObj[a] });
        component.set("v.familyKeys", keys);
        
        let declinedKeys = Object.keys(declinedFamilySummaryObj);
        declinedKeys.sort(function(a, b) { return declinedFamilySummaryObj[b] - declinedFamilySummaryObj[a] });
        component.set("v.declinedFamilyKeys", declinedKeys);
        
        var finalAwardedSummaryObj = {};
        finalAwardedSummaryObj.awardedCurrentSales = awardedCurrentSales;
        finalAwardedSummaryObj.awardedProposedSales = awardedProposedSales;
        finalAwardedSummaryObj.awardedAwardedSales = awardedAwardedSales;
        var finalDeclinedSummaryObj = {};
        finalDeclinedSummaryObj.declinedCurrentSales = declinedCurrentSales;
        finalDeclinedSummaryObj.declinedProposedSales = declinedProposedSales;
        finalDeclinedSummaryObj.declinedAwardedSales = declinedAwardedSales;
        
        component.set("v.finalAwardedSummaryObj", finalAwardedSummaryObj);
        component.set("v.finalDeclinedSummaryObj", finalDeclinedSummaryObj);
        
        
        var NewCustomerList = []; var ProductAdditionList = [];
        var OTCProductAdditionList = []; var totalNewCustomer = 0; var totalProductAddition = 0; var totalOTCProductAddition = 0;
        var awardedSalesNewCustomer = 0; var declinedSalesNewCustomer = 0; var awardedSalesProductAddition = 0; var declinedSalesProductAddition = 0;
        var awardedSalesOTCProductAddition = 0; var declinedSalesOTCProductAddition = 0;
        var obj = {};
        if(ProActiveList != null){
            for(var i=0; i<ProActiveList.length; i++){
                var currentSales = ((ProActiveList[i].Phoenix_Current_Sales_Finance__c != null) ? ProActiveList[i].Phoenix_Current_Sales_Finance__c : 0);
                var awardedQty = ((ProActiveList[i].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c != null) ? ProActiveList[i].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c : 0);
                var proposedASP = ((ProActiveList[i].Phoenix_Proposed_ASP_Dose__c != null) ? ProActiveList[i].Phoenix_Proposed_ASP_Dose__c : 0);
                var proposedQty = ((ProActiveList[i].Phoenix_Final_Total_Selling_Unit__c != null) ? ProActiveList[i].Phoenix_Final_Total_Selling_Unit__c : 0);
                var awardedSales = awardedQty*proposedASP;
                var proposedSales = proposedQty*proposedASP;
                if(ProActiveList[i].Phoenix_Bid__r.Phoenix_Bid_Type__c == 'New Customer'){
                    if(!NewCustomerList.includes(ProActiveList[i].Phoenix_Bid__c)){
                        if(ProActiveList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Awarded'){
                            totalNewCustomer += 1;
                        }
                        NewCustomerList.push(ProActiveList[i].Phoenix_Bid__c);   
                    }
                    if(ProActiveList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Awarded'){
                        awardedSalesNewCustomer += (awardedSales-currentSales);
                    } else if(ProActiveList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Declined by Customer'){
                        declinedSalesNewCustomer += (proposedSales-currentSales);                            
                    }
                } else if(ProActiveList[i].Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Product Addition' || ProActiveList[i].Phoenix_Bid__r.Phoenix_Bid_Type__c == 'OTC Product Addition'){
                    if(!ProductAdditionList.includes(ProActiveList[i].Phoenix_Bid__c)){
                        if(ProActiveList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Awarded'){
                            totalProductAddition += 1;
                        }
                        ProductAdditionList.push(ProActiveList[i].Phoenix_Bid__c);   
                    }
                    if(ProActiveList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Awarded'){
                        awardedSalesProductAddition += (awardedSales-currentSales);
                    } else if(ProActiveList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Declined by Customer'){
                        declinedSalesProductAddition += (proposedSales-currentSales);                      
                    }
                } 
                    /*else if(ProActiveList[i].Phoenix_Bid__r.Phoenix_Bid_Type__c == 'OTC Product Addition'){
                    if(!OTCProductAdditionList.includes(ProActiveList[i].Phoenix_Bid__c)){
                        if(ProActiveList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Awarded'){
                            totalOTCProductAddition += 1;
                        }
                        OTCProductAdditionList.push(ProActiveList[i].Phoenix_Bid__c);   
                    }
                    if(ProActiveList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Awarded'){
                        awardedSalesOTCProductAddition += (awardedSales-currentSales);
                    } else if(ProActiveList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Declined by Customer'){
                        declinedSalesOTCProductAddition += (proposedSales-currentSales);                            
                    }
                }*/
            }
        }
        obj.NewCustomerList = NewCustomerList;
        obj.ProductAdditionList = ProductAdditionList;
        obj.OTCProductAdditionList = OTCProductAdditionList;
        obj.totalNewCustomer = totalNewCustomer;
        obj.totalProductAddition = totalProductAddition;
        obj.totalOTCProductAddition = totalOTCProductAddition;
        obj.totalAwarded = totalNewCustomer+totalProductAddition+totalOTCProductAddition;
        obj.totalDeclined = (NewCustomerList.length-obj.totalNewCustomer)+(ProductAdditionList.length-obj.totalProductAddition)+(OTCProductAdditionList.length-obj.totalOTCProductAddition);
        obj.totalBids = obj.totalAwarded + obj.totalDeclined;
        
        obj.awardedSalesNewCustomer = awardedSalesNewCustomer; obj.declinedSalesNewCustomer = declinedSalesNewCustomer;
        obj.awardedSalesProductAddition = awardedSalesProductAddition; obj.declinedSalesProductAddition = declinedSalesProductAddition;
        obj.awardedSalesOTCProductAddition = awardedSalesOTCProductAddition; obj.declinedSalesOTCProductAddition = declinedSalesOTCProductAddition;
        
        obj.totalAwardedSales = awardedSalesNewCustomer+awardedSalesProductAddition+awardedSalesOTCProductAddition;
        obj.totalDeclinedSales = declinedSalesNewCustomer+declinedSalesProductAddition+declinedSalesOTCProductAddition;
        
        obj.instance = 'ProActive';
        component.set("v.E1Object", obj);
        component.set("v.showE1View", true);
        component.set("v.selectedQuarter", component.get("v.Q2Label"));
        component.set("v.selectedCategory", 'Proactive');
    },
    ReActiveQ2Click: function(component, event, helper){
        component.set("v.selectedOption", 'Reactive Bids');
        var ReActiveList = component.get("v.Q2ReActiveList");
        component.set("v.popupData", ReActiveList);
        var familyMap = {}; var declinedFamilyMap = {};
        var awardedCurrentSales = 0; var awardedProposedSales = 0; var awardedAwardedSales = 0;
        var declinedCurrentSales = 0; var declinedProposedSales = 0; var declinedAwardedSales = 0;
        var awardedFamilySummaryObj = {}; var declinedFamilySummaryObj = {};
        if(ReActiveList != null){
            for(var i=0; i<ReActiveList.length;i++){
                if(ReActiveList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Awarded'){
                    if(familyMap.hasOwnProperty(ReActiveList[i].Product_Family_Name__c)){
                        var relatedList = familyMap[ReActiveList[i].Product_Family_Name__c];
                        relatedList.push(ReActiveList[i]);
                        familyMap[ReActiveList[i].Product_Family_Name__c] = relatedList;
                    } else{
                        var relatedList = [];
                        relatedList.push(ReActiveList[i]);
                        familyMap[ReActiveList[i].Product_Family_Name__c] = relatedList;
                    }
                    var awardedQty = ((ReActiveList[i].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c != null) ? ReActiveList[i].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c : 0);
                    var proposedASP = ((ReActiveList[i].Phoenix_Proposed_ASP_Dose__c != null) ? ReActiveList[i].Phoenix_Proposed_ASP_Dose__c : 0);
                    var currentSales = ((ReActiveList[i].Phoenix_Current_Sales_Finance__c != null) ? ReActiveList[i].Phoenix_Current_Sales_Finance__c : 0);
                    var proposedQty = ((ReActiveList[i].Phoenix_Final_Total_Selling_Unit__c != null) ? ReActiveList[i].Phoenix_Final_Total_Selling_Unit__c : 0);
                    var awardedSales = awardedQty*proposedASP; 
                    var proposedSales = proposedQty*proposedASP;
                    awardedCurrentSales += currentSales;
                    awardedProposedSales += proposedSales;
                    awardedAwardedSales += awardedSales;
                } else if(ReActiveList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Declined by Customer'){
                    if(declinedFamilyMap.hasOwnProperty(ReActiveList[i].Product_Family_Name__c)){
                        var relatedList = declinedFamilyMap[ReActiveList[i].Product_Family_Name__c];
                        relatedList.push(ReActiveList[i]);
                        declinedFamilyMap[ReActiveList[i].Product_Family_Name__c] = relatedList;
                    } else{
                        var relatedList = [];
                        relatedList.push(ReActiveList[i]);
                        declinedFamilyMap[ReActiveList[i].Product_Family_Name__c] = relatedList;
                    }
                    var awardedQty = ((ReActiveList[i].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c != null) ? ReActiveList[i].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c : 0);
                    var proposedASP = ((ReActiveList[i].Phoenix_Proposed_ASP_Dose__c != null) ? ReActiveList[i].Phoenix_Proposed_ASP_Dose__c : 0);
                    var currentSales = ((ReActiveList[i].Phoenix_Current_Sales_Finance__c != null) ? ReActiveList[i].Phoenix_Current_Sales_Finance__c : 0);
                    var proposedQty = ((ReActiveList[i].Phoenix_Final_Total_Selling_Unit__c != null) ? ReActiveList[i].Phoenix_Final_Total_Selling_Unit__c : 0);
                    var awardedSales = awardedQty*proposedASP; 
                    var proposedSales = proposedQty*proposedASP;
                    declinedCurrentSales += currentSales;
                    declinedProposedSales += proposedSales;
                    declinedAwardedSales += awardedSales;
                }
            }   
        }
        
        var familyMapKeys = Object.keys(familyMap);
        var declinedFamilyMapKeys = Object.keys(declinedFamilyMap);
        for(var i=0; i<familyMapKeys.length; i++){
            var relatedList = familyMap[familyMapKeys[i]];
            var awardedSales = 0;
            for(var j=0; j<relatedList.length; j++){
                var awardedQty = ((relatedList[j].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c != null) ? relatedList[j].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c : 0);
                var proposedASP = ((relatedList[j].Phoenix_Proposed_ASP_Dose__c != null) ? relatedList[j].Phoenix_Proposed_ASP_Dose__c : 0);
                awardedSales += awardedQty*proposedASP;
            }
            awardedFamilySummaryObj[familyMapKeys[i]] = awardedSales;
        }
        for(var i=0; i<declinedFamilyMapKeys.length; i++){
            var relatedList = declinedFamilyMap[declinedFamilyMapKeys[i]];
            var proposedSales = 0;
            for(var j=0; j<relatedList.length; j++){
                var proposedASP = ((relatedList[j].Phoenix_Proposed_ASP_Dose__c != null) ? relatedList[j].Phoenix_Proposed_ASP_Dose__c : 0);
                var proposedQty = ((relatedList[j].Phoenix_Final_Total_Selling_Unit__c != null) ? relatedList[j].Phoenix_Final_Total_Selling_Unit__c : 0);
                proposedSales += proposedQty*proposedASP;
            }
            declinedFamilySummaryObj[declinedFamilyMapKeys[i]] = proposedSales;
        }
        
        let keys = Object.keys(awardedFamilySummaryObj);
        keys.sort(function(a, b) { return awardedFamilySummaryObj[b] - awardedFamilySummaryObj[a] });
        component.set("v.familyKeys", keys);
        
        let declinedKeys = Object.keys(declinedFamilySummaryObj);
        declinedKeys.sort(function(a, b) { return declinedFamilySummaryObj[b] - declinedFamilySummaryObj[a] });
        component.set("v.declinedFamilyKeys", declinedKeys);
        
        var finalAwardedSummaryObj = {};
        finalAwardedSummaryObj.awardedCurrentSales = awardedCurrentSales;
        finalAwardedSummaryObj.awardedProposedSales = awardedProposedSales;
        finalAwardedSummaryObj.awardedAwardedSales = awardedAwardedSales;
        var finalDeclinedSummaryObj = {};
        finalDeclinedSummaryObj.declinedCurrentSales = declinedCurrentSales;
        finalDeclinedSummaryObj.declinedProposedSales = declinedProposedSales;
        finalDeclinedSummaryObj.declinedAwardedSales = declinedAwardedSales;
        
        component.set("v.finalAwardedSummaryObj", finalAwardedSummaryObj);
        component.set("v.finalDeclinedSummaryObj", finalDeclinedSummaryObj);
        
        
        var RFPList = []; var OTCRFPList = [];
        var OTBList = [];var VolumeReviewList = []; var OTCVolumeReviewList = [];
        var totalRFP = 0; var totalOTCRFP = 0; var totalOTBs = 0; var totalVolumeReview = 0; var totalOTCVolumeReview = 0;
        var awardedSalesRFP = 0; var declinedSalesRFP = 0; var awardedSalesOTCRFP = 0; var declinedSalesOTCRFP = 0; 
        var awardedSalesOTB = 0; var declinedSalesOTB = 0;  var awardedSalesVolumeReview = 0; var declinedSalesVolumeReview = 0; 
        var awardedSalesOTCVolumeReview = 0; var declinedSalesOTCVolumeReview = 0; 
        var obj = {};
        if(ReActiveList != null){
            for(var i=0; i<ReActiveList.length; i++){
                var currentSales = ((ReActiveList[i].Phoenix_Current_Sales_Finance__c != null) ? ReActiveList[i].Phoenix_Current_Sales_Finance__c : 0);
                var awardedQty = ((ReActiveList[i].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c != null) ? ReActiveList[i].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c : 0);
                var proposedASP = ((ReActiveList[i].Phoenix_Proposed_ASP_Dose__c != null) ? ReActiveList[i].Phoenix_Proposed_ASP_Dose__c : 0);
                var proposedQty = ((ReActiveList[i].Phoenix_Final_Total_Selling_Unit__c != null) ? ReActiveList[i].Phoenix_Final_Total_Selling_Unit__c : 0);
                var awardedSales = awardedQty*proposedASP;
                var proposedSales = proposedQty*proposedASP;
                if((ReActiveList[i].Phoenix_Bid__r.Phoenix_Bid_Type__c == 'RFP Bids' || ReActiveList[i].Phoenix_Bid__r.Phoenix_Bid_Type__c == 'OTC RFP') && ((((awardedQty * proposedASP) >= currentSales)) || (((proposedSales) > currentSales))) ){
                    if(!RFPList.includes(ReActiveList[i].Phoenix_Bid__c)){
                        if(ReActiveList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Awarded'){
                            totalRFP += 1;
                        }
                        RFPList.push(ReActiveList[i].Phoenix_Bid__c);   
                    }
                    if(ReActiveList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Awarded'){
                        awardedSalesRFP += (awardedSales-currentSales);
                    } else if(ReActiveList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Declined by Customer'){
                        declinedSalesRFP += (proposedSales-currentSales);                            
                    }
                } 
                /*else if(ReActiveList[i].Phoenix_Bid__r.Phoenix_Bid_Type__c == 'OTC RFP'){
                    if(!OTCRFPList.includes(ReActiveList[i].Phoenix_Bid__c)){
                        if(ReActiveList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Awarded'){
                            totalOTCRFP += 1;
                        }
                        OTCRFPList.push(ReActiveList[i].Phoenix_Bid__c);   
                    }
                    if(ReActiveList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Awarded'){
                        awardedSalesOTCRFP += (awardedSales-currentSales);
                    } else if(ReActiveList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Declined by Customer'){
                        declinedSalesOTCRFP += (proposedSales-currentSales);                                       
                    }
                }*/ 
                    else if(ReActiveList[i].Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Good Dated OTB' || ReActiveList[i].Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Short Dated OTB' || ReActiveList[i].Phoenix_Bid__r.Phoenix_Bid_Type__c == 'OTC OTB Good Dated' ||
                          ReActiveList[i].Phoenix_Bid__r.Phoenix_Bid_Type__c == 'OTC OTB Short Dated'){
                    if(!OTBList.includes(ReActiveList[i].Phoenix_Bid__c)){
                        if(ReActiveList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Awarded'){
                            totalOTBs += 1;
                        }
                        OTBList.push(ReActiveList[i].Phoenix_Bid__c);   
                    }
                    if(ReActiveList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Awarded'){
                        awardedSalesOTB += (awardedSales-currentSales);
                    } else if(ReActiveList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Declined by Customer'){
                        declinedSalesOTB += (proposedSales-currentSales);                                
                    }
                } else if(ReActiveList[i].Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Volume Review Only' || ReActiveList[i].Phoenix_Bid__r.Phoenix_Bid_Type__c == 'OTC Volume Review'){
                    if(!VolumeReviewList.includes(ReActiveList[i].Phoenix_Bid__c)){
                        if(ReActiveList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Awarded'){
                            totalVolumeReview += 1;
                        }
                        VolumeReviewList.push(ReActiveList[i].Phoenix_Bid__c);   
                    }
                    if(ReActiveList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Awarded'){
                        awardedSalesVolumeReview += (awardedSales-currentSales);
                    } else if(ReActiveList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Declined by Customer'){
                        declinedSalesVolumeReview += (proposedSales-currentSales);                                
                    }
                } 
                    /*else if(ReActiveList[i].Phoenix_Bid__r.Phoenix_Bid_Type__c == 'OTC Volume Review'){
                    if(!OTCVolumeReviewList.includes(ReActiveList[i].Phoenix_Bid__c)){
                        if(ReActiveList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Awarded'){
                            totalOTCVolumeReview += 1;
                        }
                        OTCVolumeReviewList.push(ReActiveList[i].Phoenix_Bid__c);   
                    }
                    if(ReActiveList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Awarded'){
                        awardedSalesOTCVolumeReview += (awardedSales-currentSales);
                    } else if(ReActiveList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Declined by Customer'){
                        declinedSalesOTCVolumeReview += (proposedSales-currentSales);                                  
                    }
                }*/
            }
        }
        obj.RFPList = RFPList;  obj.OTCRFPList = OTCRFPList; obj.OTBList = OTBList;
        obj.VolumeReviewList = VolumeReviewList; obj.OTCVolumeReviewList = OTCVolumeReviewList;
        obj.totalRFP = totalRFP; obj.totalOTCRFP = totalOTCRFP; obj.totalOTBs = totalOTBs; obj.totalVolumeReview = totalVolumeReview; obj.totalOTCVolumeReview = totalOTCVolumeReview;
        
        obj.totalAwarded = totalRFP+totalOTCRFP+totalOTBs+totalVolumeReview+totalOTCVolumeReview;
        obj.totalDeclined = (RFPList.length-obj.totalRFP)+(OTCRFPList.length-obj.totalOTCRFP)+(OTBList.length-obj.totalOTBs)+(VolumeReviewList.length-obj.totalVolumeReview)+(OTCVolumeReviewList.length-obj.totalOTCVolumeReview);
        obj.totalBids = obj.totalAwarded + obj.totalDeclined;
        
        obj.awardedSalesRFP = awardedSalesRFP; obj.declinedSalesRFP = declinedSalesRFP;
        obj.awardedSalesOTCRFP = awardedSalesOTCRFP; obj.declinedSalesOTCRFP = declinedSalesOTCRFP;
        obj.awardedSalesOTB = awardedSalesOTB; obj.declinedSalesOTB = declinedSalesOTB;
        obj.awardedSalesVolumeReview = awardedSalesVolumeReview; obj.declinedSalesVolumeReview = declinedSalesVolumeReview;
        obj.awardedSalesOTCVolumeReview = awardedSalesOTCVolumeReview; obj.declinedSalesOTCVolumeReview = declinedSalesOTCVolumeReview;
        
        obj.totalAwardedSales = awardedSalesRFP+awardedSalesOTCRFP+awardedSalesOTB+awardedSalesVolumeReview+awardedSalesOTCVolumeReview;
        obj.totalDeclinedSales = declinedSalesRFP+declinedSalesOTCRFP+declinedSalesOTB+declinedSalesVolumeReview+declinedSalesOTCVolumeReview;
        
        obj.instance = 'ReActive';
        component.set("v.E1Object", obj);
        component.set("v.showE1View", true);
        component.set("v.selectedQuarter", component.get("v.Q2Label"));
        component.set("v.selectedCategory", 'Reactive');
    },
    ROFRQ2Click: function(component, event, helper){
        component.set("v.selectedOption", 'Right of First Refusals (ROFRs)');
        var ROFRList = component.get("v.Q2ROFRsList");
        component.set("v.popupData", ROFRList);
        var familyMap = {}; var declinedFamilyMap = {};
        var awardedCurrentSales = 0; var awardedProposedSales = 0; var awardedAwardedSales = 0;
        var declinedCurrentSales = 0; var declinedProposedSales = 0; var declinedAwardedSales = 0;
        var awardedFamilySummaryObj = {}; var declinedFamilySummaryObj = {};
        if(ROFRList != null){
            for(var i=0; i<ROFRList.length;i++){
                if(ROFRList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Awarded'){
                    if(familyMap.hasOwnProperty(ROFRList[i].Product_Family_Name__c)){
                        var relatedList = familyMap[ROFRList[i].Product_Family_Name__c];
                        relatedList.push(ROFRList[i]);
                        familyMap[ROFRList[i].Product_Family_Name__c] = relatedList;
                    } else{
                        var relatedList = [];
                        relatedList.push(ROFRList[i]);
                        familyMap[ROFRList[i].Product_Family_Name__c] = relatedList;
                    }
                    var awardedQty = ((ROFRList[i].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c != null) ? ROFRList[i].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c : 0);
                    var proposedASP = ((ROFRList[i].Phoenix_Proposed_ASP_Dose__c != null) ? ROFRList[i].Phoenix_Proposed_ASP_Dose__c : 0);
                    var currentSales = ((ROFRList[i].Phoenix_Current_Sales_Finance__c != null) ? ROFRList[i].Phoenix_Current_Sales_Finance__c : 0);
                    var proposedQty = ((ROFRList[i].Phoenix_Final_Total_Selling_Unit__c != null) ? ROFRList[i].Phoenix_Final_Total_Selling_Unit__c : 0);
                    var awardedSales = awardedQty*proposedASP; 
                    var proposedSales = proposedQty*proposedASP;
                    awardedCurrentSales += currentSales;
                    awardedProposedSales += proposedSales;
                    awardedAwardedSales += awardedSales;
                } else if(ROFRList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Declined by Customer'){
                    if(declinedFamilyMap.hasOwnProperty(ROFRList[i].Product_Family_Name__c)){
                        var relatedList = declinedFamilyMap[ROFRList[i].Product_Family_Name__c];
                        relatedList.push(ROFRList[i]);
                        declinedFamilyMap[ROFRList[i].Product_Family_Name__c] = relatedList;
                    } else{
                        var relatedList = [];
                        relatedList.push(ROFRList[i]);
                        declinedFamilyMap[ROFRList[i].Product_Family_Name__c] = relatedList;
                    }
                    var awardedQty = ((ROFRList[i].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c != null) ? ROFRList[i].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c : 0);
                    var proposedASP = ((ROFRList[i].Phoenix_Proposed_ASP_Dose__c != null) ? ROFRList[i].Phoenix_Proposed_ASP_Dose__c : 0);
                    var currentSales = ((ROFRList[i].Phoenix_Current_Sales_Finance__c != null) ? ROFRList[i].Phoenix_Current_Sales_Finance__c : 0);
                    var proposedQty = ((ROFRList[i].Phoenix_Final_Total_Selling_Unit__c != null) ? ROFRList[i].Phoenix_Final_Total_Selling_Unit__c : 0);
                    var awardedSales = awardedQty*proposedASP; 
                    var proposedSales = proposedQty*proposedASP;
                    declinedCurrentSales += currentSales;
                    declinedProposedSales += proposedSales;
                    declinedAwardedSales += awardedSales;   
                }
            }   
        }
        
        var familyMapKeys = Object.keys(familyMap);
        var declinedFamilyMapKeys = Object.keys(declinedFamilyMap);
        for(var i=0; i<familyMapKeys.length; i++){
            var relatedList = familyMap[familyMapKeys[i]];
            var awardedSales = 0;
            for(var j=0; j<relatedList.length; j++){
                var awardedQty = ((relatedList[j].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c != null) ? relatedList[j].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c : 0);
                var proposedASP = ((relatedList[j].Phoenix_Proposed_ASP_Dose__c != null) ? relatedList[j].Phoenix_Proposed_ASP_Dose__c : 0);
                awardedSales += awardedQty*proposedASP;
            }
            awardedFamilySummaryObj[familyMapKeys[i]] = awardedSales;
        }
        for(var i=0; i<declinedFamilyMapKeys.length; i++){
            var relatedList = declinedFamilyMap[declinedFamilyMapKeys[i]];
            var proposedSales = 0;
            for(var j=0; j<relatedList.length; j++){
                var proposedASP = ((relatedList[j].Phoenix_Proposed_ASP_Dose__c != null) ? relatedList[j].Phoenix_Proposed_ASP_Dose__c : 0);
                var proposedQty = ((relatedList[j].Phoenix_Final_Total_Selling_Unit__c != null) ? relatedList[j].Phoenix_Final_Total_Selling_Unit__c : 0);
                proposedSales += proposedQty*proposedASP;
            }
            declinedFamilySummaryObj[declinedFamilyMapKeys[i]] = proposedSales;
        }
        
        let keys = Object.keys(awardedFamilySummaryObj);
        keys.sort(function(a, b) { return awardedFamilySummaryObj[b] - awardedFamilySummaryObj[a] });
        component.set("v.familyKeys", keys);
        
        let declinedKeys = Object.keys(declinedFamilySummaryObj);
        declinedKeys.sort(function(a, b) { return declinedFamilySummaryObj[b] - declinedFamilySummaryObj[a] });
        component.set("v.declinedFamilyKeys", declinedKeys);
        
        var finalAwardedSummaryObj = {};
        finalAwardedSummaryObj.awardedCurrentSales = awardedCurrentSales;
        finalAwardedSummaryObj.awardedProposedSales = awardedProposedSales;
        finalAwardedSummaryObj.awardedAwardedSales = awardedAwardedSales;
        var finalDeclinedSummaryObj = {};
        finalDeclinedSummaryObj.declinedCurrentSales = declinedCurrentSales;
        finalDeclinedSummaryObj.declinedProposedSales = declinedProposedSales;
        finalDeclinedSummaryObj.declinedAwardedSales = declinedAwardedSales;
        
        component.set("v.finalAwardedSummaryObj", finalAwardedSummaryObj);
        component.set("v.finalDeclinedSummaryObj", finalDeclinedSummaryObj);
        
        
        var RFPList = []; var OTCRFPList = [];
        var PriceChangeList = [];var OTCPriceChangeList = [];
        var totalRFP = 0; var totalOTCRFP = 0; var totalPriceChange = 0; var totalOTCPriceChange = 0;
        var awardedSalesRFP = 0; var declinedSalesRFP = 0; var awardedSalesOTCRFP = 0; var declinedSalesOTCRFP = 0;
        var awardedSalesPriceChange = 0; var declinedSalesPriceChange = 0; var awardedSalesOTCPriceChange = 0; var declinedSalesOTCPriceChange = 0;
        var obj = {};
        if(ROFRList != null){
            for(var i=0; i<ROFRList.length; i++){
                var currentSales = ((ROFRList[i].Phoenix_Current_Sales_Finance__c != null) ? ROFRList[i].Phoenix_Current_Sales_Finance__c : 0);
                var awardedQty = ((ROFRList[i].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c != null) ? ROFRList[i].Customer_Response_Lines__r[0].Phoenix_Awarded_Quantity__c : 0);
                var proposedASP = ((ROFRList[i].Phoenix_Proposed_ASP_Dose__c != null) ? ROFRList[i].Phoenix_Proposed_ASP_Dose__c : 0);
                var proposedQty = ((ROFRList[i].Phoenix_Final_Total_Selling_Unit__c != null) ? ROFRList[i].Phoenix_Final_Total_Selling_Unit__c : 0);
                var awardedSales = awardedQty*proposedASP;
                var proposedSales = proposedQty*proposedASP;
                
                if((ROFRList[i].Phoenix_Bid__r.Phoenix_Bid_Type__c == 'RFP Bids' || ROFRList[i].Phoenix_Bid__r.Phoenix_Bid_Type__c == 'OTC RFP') && ((((awardedQty * proposedASP) < currentSales) && currentSales > 0) || ((proposedSales <= currentSales) && currentSales > 0))){
                    if(!RFPList.includes(ROFRList[i].Phoenix_Bid__c)){
                        if(ROFRList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Awarded'){
                            totalRFP += 1;
                        }
                        RFPList.push(ROFRList[i].Phoenix_Bid__c); 
                    }
                    if(ROFRList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Awarded'){
                        awardedSalesRFP += (awardedSales-currentSales);
                    } else if(ROFRList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Declined by Customer'){
                        //declinedSalesRFP += (awardedSales-currentSales);             
                        declinedSalesRFP += (awardedSales-currentSales);
                    }
                } 
                /*else if(ROFRList[i].Phoenix_Bid__r.Phoenix_Bid_Type__c == 'OTC RFP'){
                    if(!OTCRFPList.includes(ROFRList[i].Phoenix_Bid__c)){
                        if(ROFRList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Awarded'){
                            totalOTCRFP += 1;
                        }
                        OTCRFPList.push(ROFRList[i].Phoenix_Bid__c);   
                    }
                    if(ROFRList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Awarded'){
                        awardedSalesOTCRFP += (awardedSales-currentSales);
                    } else if(ROFRList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Declined by Customer'){
                        declinedSalesOTCRFP += currentSales;                                      
                    }
                } */
                else if(ROFRList[i].Phoenix_Bid__r.Phoenix_Bid_Type__c == 'Price Change' || ROFRList[i].Phoenix_Bid__r.Phoenix_Bid_Type__c == 'OTC Price Change'){
                    if(!PriceChangeList.includes(ROFRList[i].Phoenix_Bid__c)){
                        if(ROFRList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Awarded'){
                            totalPriceChange += 1;
                        }
                        PriceChangeList.push(ROFRList[i].Phoenix_Bid__c);   
                    }
                    if(ROFRList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Awarded'){
                        awardedSalesPriceChange += (awardedSales-currentSales);
                    } else if(ROFRList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Declined by Customer'){
                        declinedSalesPriceChange += (awardedSales-currentSales);
                    }
                } 
                    /*else if(ROFRList[i].Phoenix_Bid__r.Phoenix_Bid_Type__c == 'OTC Price Change'){
                    if(!OTCPriceChangeList.includes(ROFRList[i].Phoenix_Bid__c)){
                        if(ROFRList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Awarded'){
                            totalOTCPriceChange += 1;
                        }
                        OTCPriceChangeList.push(ROFRList[i].Phoenix_Bid__c);   
                    }
                    if(ROFRList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Awarded'){
                        awardedSalesOTCPriceChange += (awardedSales-currentSales);
                    } else if(ROFRList[i].Customer_Response_Lines__r[0].Phoenix_Bid_Status__c == 'Declined by Customer'){
                        declinedSalesOTCPriceChange += currentSales;                                      
                    }
                }*/
            }
        }
        obj.RFPList = RFPList;  obj.OTCRFPList = OTCRFPList;
        obj.PriceChangeList = PriceChangeList; obj.OTCPriceChangeList = OTCPriceChangeList;
        obj.totalRFP = totalRFP; obj.totalOTCRFP = totalOTCRFP; obj.totalPriceChange = totalPriceChange; obj.totalOTCPriceChange = totalOTCPriceChange;
        
        obj.totalAwarded = totalRFP+totalOTCRFP+totalPriceChange+totalOTCPriceChange;
        obj.totalDeclined = (RFPList.length-obj.totalRFP)+(OTCRFPList.length-obj.totalOTCRFP)+(PriceChangeList.length-obj.totalPriceChange)+(OTCPriceChangeList.length-obj.totalOTCPriceChange);
        obj.totalBids = obj.totalAwarded + obj.totalDeclined;
        
        obj.awardedSalesRFP = awardedSalesRFP; obj.declinedSalesRFP = declinedSalesRFP;
        obj.awardedSalesOTCRFP = awardedSalesOTCRFP; obj.declinedSalesOTCRFP = declinedSalesOTCRFP;
        obj.awardedSalesPriceChange = awardedSalesPriceChange; obj.declinedSalesPriceChange = declinedSalesPriceChange;
        obj.awardedSalesOTCPriceChange = awardedSalesOTCPriceChange; obj.declinedSalesOTCPriceChange = declinedSalesOTCPriceChange;
        
        obj.totalAwardedSales = awardedSalesRFP+awardedSalesOTCRFP+awardedSalesPriceChange+awardedSalesOTCPriceChange;
        obj.totalDeclinedSales = declinedSalesRFP+declinedSalesOTCRFP+declinedSalesPriceChange+declinedSalesOTCPriceChange;
        
        obj.instance = 'ROFR';
        component.set("v.E1Object", obj);
        component.set("v.showE1View", true);
        component.set("v.selectedQuarter", component.get("v.Q2Label"));
        component.set("v.selectedCategory", 'ROFR');
    },
    closePopup: function(component, event, helper){
        component.set("v.showE1View", false);
        component.set("v.isChecked", false);
    }
})