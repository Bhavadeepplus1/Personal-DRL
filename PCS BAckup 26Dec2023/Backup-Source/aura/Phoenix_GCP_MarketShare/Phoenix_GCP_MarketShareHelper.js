({
    getAllCustomersData : function(component, event, helper){
        component.set('v.isSpinnerLoad', true);
        var picliList;// = component.get("v.RxSrxList");
        console.log('component.get("v.RxSrxList") :: '+component.get("v.RxSrxList"));
        if(component.get("v.RxSrxList") != undefined && component.get("v.RxSrxList").length > 0){
            picliList = component.get('v.RxSrxList');
        }
        var action = component.get("c.getAllAccList");
        action.setParams({
            parentAccId: component.get("v.recordId"),
            rxSrxOtcList : picliList,
            showRelevant : component.get("v.showRelevant")
        });
        action.setCallback(this, function (response) {
            console.log('State from getAllAccList :: '+response.getState());
            if (response.getState() == "SUCCESS") {
                var wrapper = response.getReturnValue();
                var accList = wrapper.accList;
                var gcpList = wrapper.famList;
                component.set("v.accObj",wrapper.accObj);
                if(gcpList.length>0)
                    helper.getDataOfAcc(component, helper, accList, gcpList, 0);
                else{
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "No Line Items",
                        "message":'There are no relevant products for this account to show analysis.',
                        "type":"ERROR",
                        "mode":"dismissible"
                    });
                    toastEvent.fire();
                    component.set('v.isSpinnerLoad', false);
                }
            }
            else {
                component.set('v.isSpinnerLoad', false);
                console.log('ERROR while getAllAccList : '+JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);
    },
    
    getDataOfAcc : function(component, helper, accList, gcpList, count){
        console.log('acc length -> '+accList.length+' count -> '+count);
        component.set("v.loadingMessage",'Pulling data of '+accList[count].Name+' Account... '+(count+1)+' out of '+accList.length);
        var action = component.get("c.getIndvAccData");
        action.setParams({
            parentId : component.get("v.recordId"), accId: accList[count].Id, gcpItems : gcpList
        });
        action.setCallback(this, function (response) {
            console.log('State from getIndvAccData :: '+response.getState());
            if (response.getState() == "SUCCESS") {
                var wrapper = response.getReturnValue();
                //console.log('RESPONSE--> '+JSON.stringify(wrapper));
                if(accList.length == count+1)
                    helper.getItemsAfterFilter(component, event, helper);
                else{
                    var updatedGcpList = wrapper.gcpList != undefined ? wrapper.gcpList : gcpList; 
                    helper.getDataOfAcc(component, helper, accList, updatedGcpList, count+1);
                }
            }
            else {
                component.set('v.isSpinnerLoad', false);
                console.log('ERROR while getIndvAccData : '+JSON.stringify(response.getError()));
                component.set("v.loadingMessage",'');
            }
        });
        $A.enqueueAction(action);
    },
    
    getItemsAfterFilter : function(component, event, helper){
        component.set('v.isSpinnerLoad', true);
        var accId = '';
        if(component.get("v.recordId")!= undefined)
            accId = component.get("v.recordId");
        else if(component.get("v.accId") != undefined)
            accId = component.get("v.accId");
        console.log('record Id :: '+accId);
        var posFilterList = component.get("v.posFilterList");
        if(posFilterList == undefined || posFilterList.length == 0){
            posFilterList = ['True Opportunity','Awarded','In Bid','Not An Opportunity','Price Constraint','Supply Constraint'];
            component.set("v.posFilterList",posFilterList);
        }
        var picliList = component.get("v.RxSrxList");
        console.log('component.get("v.RxSrxList") :: '+component.get("v.RxSrxList"));
        if(component.get("v.RxSrxList") != undefined && component.get("v.RxSrxList").length > 0){
            picliList = component.get('v.RxSrxList');
        }
        
        var action = component.get("c.getFilteredGCPItems");
        action.setParams({
            accId: accId,
            rxSrxOtcList : picliList,
            posFilterList : posFilterList,
            showRelevant : component.get("v.showRelevant")
        });
        action.setCallback(this, function (response) {
            console.log('State from getFilteredGCPItems :: '+response.getState());
            if (response.getState() == "SUCCESS") {
                var wrapper = response.getReturnValue();
                helper.finalRecordsReceived(component, helper, wrapper);
                component.set('v.isSpinnerLoad', false);
            }
            else {
                component.set('v.isSpinnerLoad', false);
                console.log('ERROR while getFilteredGCPItems : '+JSON.stringify(response.getError()));
                component.set("v.loadingMessage",'');
            }
        });
        $A.enqueueAction(action);
    },
    
    finalRecordsReceived : function(component, helper, wrapObj){
        component.set("v.loadingMessage",'');
        var today = new Date();
        var month = [];
        month[0] = "Jan";
        month[1] = "Feb";
        month[2] = "Mar";
        month[3] = "Apr";
        month[4] = "May";
        month[5] = "Jun";
        month[6] = "Jul";
        month[7] = "Aug";
        month[8] = "Sep";
        month[9] = "Oct";
        month[10] = "Nov";
        month[11] = "Dec";
        month[-1] = "Jan";
        
        var last12M = ''+month[today.getMonth()]+' '+(today.getFullYear()-1)+' - '+month[today.getMonth()-1]+' '+(today.getFullYear());
        component.set("v.last12M",last12M);
        var lastMonth = ''+month[today.getMonth()-1];
        lastMonth += ' '+(today.getMonth() == 0 ? today.getFullYear()-1 : today.getFullYear());
        component.set("v.lastMonth",lastMonth);
        
        var accObj = wrapObj.accObj;
        component.set("v.marketShare", accObj.Phoenix_Customer_Est_Market_Share__c);
        component.set("v.wallet", accObj.Phoenix_Customer_Max_Est_Share_of_Wallet__c);
        component.set("v.coolingPeriod", accObj.Phoenix_Account_Cooling_Period__c);
        var totalCxOpty = '';
        var drlCurrentSales = '';
        var drlOpptySales = '';
        var drlTotEstActSales = '';
        var drlShareOfWallet = '';
        var drlShareOfWalletVol = '';
        
        function roundUpNumber(num){
            var roundedNum = '';
            if(num > 0){
                if(num > 1000000000){
                    roundedNum = ''+Math.round((num/1000000000) * 100) / 100+'B';
                }
                else if(num > 1000000){
                    roundedNum = ''+Math.round((num/1000000) * 100) / 100+'M';
                }
                    else if(num > 1000){
                        roundedNum = ''+Math.round((num/1000) * 100) / 100+'K';
                    }
                        else{
                            roundedNum = num != undefined ? ''+Math.round((num) * 100) / 100 : '0';
                        }
            }
            else{
                if(num < -1000000000){
                    roundedNum = ''+Math.round((num/1000000000) * 100) / 100+'B';
                }
                else if(num < -1000000){
                    roundedNum = ''+Math.round((num/1000000) * 100) / 100+'M';
                }
                    else if(num < -1000){
                        roundedNum = ''+Math.round((num/1000) * 100) / 100+'K';
                    }
                        else{
                            roundedNum = num != undefined ? ''+Math.round((num) * 100) / 100 : '0';
                        }
            }
            return roundedNum;
        }
        
        totalCxOpty = roundUpNumber(accObj.Phoenix_Total_Customer_Opportunity__c);
        drlCurrentSales = roundUpNumber(accObj.Phoenix_DRL_Current_Sales__c);
        drlOpptySales = roundUpNumber(accObj.Phoenix_DRL_Opportunity_Sales__c);
        drlTotEstActSales = roundUpNumber(accObj.Phoenix_DRL_Total_Est_Account_Sales__c);
        drlShareOfWallet = roundUpNumber(accObj.Phoenix_DRL_Share_of_Wallet__c);
        drlShareOfWalletVol = roundUpNumber(accObj.Phoenix_DRL_Share_of_Wallet_Vol__c);
        
        component.set("v.totalCxOpty", totalCxOpty);
        component.set("v.drlCurrentSales", drlCurrentSales);
        component.set("v.drlOpptySales", drlOpptySales);
        component.set("v.drlTotEstActSales", drlTotEstActSales);
        component.set("v.drlShareOfWallet", drlShareOfWallet);
        component.set("v.drlShareOfWalletVol", drlShareOfWalletVol);
        var gcpOptyTrcList = wrapObj.gcpList;
        component.set("v.accObj",accObj);
        component.set("v.gcpList",gcpOptyTrcList);
        component.set("v.totalGcpRecords",gcpOptyTrcList.length);
        
        var actTotal = 0; var shareOfWallet = 0; var drlAccVol = 0; var drlAccSales = 0; var drlAccPrice = 0;
        var drlAccTpt = 0; var totalMktVol = 0; var drlActMktShare = 0; var totalMktShares = 0;
        var custActMktShare = 0; var custActOppTpt = 0; var custActVol = 0;
        
        var totalTrueOptyCount = 0,notOptyCount = 0,PriceConCount = 0,supplyConCount = 0,awardedCount = 0,inBidCount = 0, sentToPanoramaCount=0;
        var totalSalesTrueOpty = 0,totalSalesNotTrueOpty = 0,totalSalesPriceCons = 0, totalSalesSupplyCons =0, totalSalesCons=0,
            totalSalesAwarded = wrapObj.awardedTotalSales,totalSalesInBid = wrapObj.inBidTotalSales;
        if(gcpOptyTrcList.length>0){
            var monthRange = '';
            var last12M = '';
            var continueLoop = true;
            gcpOptyTrcList.forEach(function(gcpObj){
                if(gcpObj.Phoenix_Est_Acct_Total_Vol_EU__c != undefined)
                    actTotal = actTotal + gcpObj.Phoenix_Est_Acct_Total_Vol_EU__c;
                if(gcpObj.Phoenix_Est_Acct_Share_of_Wallet__c != undefined)
                    shareOfWallet = shareOfWallet + gcpObj.Phoenix_Est_Acct_Share_of_Wallet__c;
                if(gcpObj.Phoenix_Drl_Act_Volume_Eu__c != undefined)
                    drlAccVol = drlAccVol + gcpObj.Phoenix_Drl_Act_Volume_Eu__c;
                if(gcpObj.Phoenix_Drl_Act_Sales__c != undefined)
                    drlAccSales = drlAccSales + gcpObj.Phoenix_Drl_Act_Sales__c;
                
                if(gcpObj.Phoenix_Drl_Act_Price__c != undefined)
                    drlAccPrice = drlAccPrice + gcpObj.Phoenix_Drl_Act_Price__c;
                if(gcpObj.Phoenix_DRL_Actual_TPT__c != undefined)
                    drlAccTpt = drlAccTpt + gcpObj.Phoenix_DRL_Actual_TPT__c;
                if(gcpObj.Phoenix_Total_Market_Vol_MAT_EU__c != undefined)
                    totalMktVol = totalMktVol + gcpObj.Phoenix_Total_Market_Vol_MAT_EU__c;
                if(gcpObj.Phoenix_Total_Market_Sales__c != undefined)
                    totalMktShares = totalMktShares + gcpObj.Phoenix_Total_Market_Sales__c;
                
                if(gcpObj.Phoenix_Cust_Act_Volume_Mat_Eu__c != undefined)
                    custActVol = custActVol + gcpObj.Phoenix_Cust_Act_Volume_Mat_Eu__c;
                if(gcpObj.Phoenix_Cust_Act_Mkt_Sh__c != undefined)
                    custActMktShare = custActMktShare + gcpObj.Phoenix_Cust_Act_Mkt_Sh__c;
                if(gcpObj.Phoenix_Customer_Opp_TPT__c != undefined)
                    custActOppTpt = custActOppTpt + gcpObj.Phoenix_Customer_Opp_TPT__c;
                
                if(continueLoop){
                    monthRange = gcpObj.Phoenix_Ims_Qtr_Month_Range__c != undefined && gcpObj.Phoenix_Ims_Qtr_Month_Range__c != null ? gcpObj.Phoenix_Ims_Qtr_Month_Range__c : '';
                    
                    last12M = gcpObj.Phoenix_Prof_Month_Range__c != undefined ? gcpObj.Phoenix_Prof_Month_Range__c : '';
                    if(monthRange != '' && last12M != ''){
                        continueLoop = false;
                    }
                }
            });
            component.set("v.lastMonth",monthRange.includes('-') ? monthRange.split('-')[1] : monthRange.trim());
            component.set("v.last12M",last12M);
        }
        
        component.set("v.actTotal",actTotal);
        component.set("v.shareOfWallet",shareOfWallet);
        component.set("v.drlAccVol",drlAccVol);
        component.set("v.drlAccSales",drlAccSales);
        component.set("v.drlAccPrice",drlAccPrice);
        component.set("v.drlAccTpt",drlAccTpt);
        component.set("v.totalMktVol",totalMktVol);
        component.set("v.totalMktShares",totalMktShares);
        component.set("v.custActVol",custActVol);
        component.set("v.custActMktShare",custActMktShare);
        component.set("v.custActOppTpt",custActOppTpt);
        
        
        var drlAccTptPerc = drlAccSales != 0 ? (drlAccTpt/drlAccSales)*100 : 0;
        component.set("v.drlAccTptPerc",drlAccTptPerc);
        var drlActMktShare = totalMktVol != 0 ? (accObj.Phoenix_DRL_Current_Sales__c/totalMktVol)*100 : 0;
        component.set("v.drlActMktShare",wrapObj.drlActMktShare);
        if(component.get("v.filterName") == undefined || component.get("v.filterName") == ''){
            component.set("v.filterName",'Product Family');
            component.set("v.isAsc",true);
        }  
        component.set("v.isAsc",!component.get("v.isAsc"));  
       
        if(component.get("v.filterName") == 'Product Status')
            helper.sortBy(component, 'Product_Status__c');
        if(component.get("v.filterName") == 'Product Family')
            helper.sortBy(component, 'GCP_Product_Family__c');
        if(component.get("v.filterName") == 'Vol (EU)')
            helper.sortByVolEu(component, 'Phoenix_Drl_Act_Volume_Eu__c');
        if(component.get("v.filterName") == 'Total DRL Market Sales')
            helper.sortByVolEu(component, 'Phoenix_Drl_Act_Sales__c'); 
        if(component.get("v.filterName") == 'Total DRL Market TPT')
            helper.sortByVolEu(component, 'Phoenix_DRL_Actual_TPT__c'); 
        if(component.get("v.filterName") == 'DRL Market Volume')
            helper.sortByVolEu(component, 'Phoenix_Total_Market_Vol_MAT_EU__c'); 
        if(component.get("v.filterName") == 'DRL Market Sales')
            helper.sortByVolEu(component, 'Phoenix_Total_Market_Sales__c');
        if(component.get("v.filterName") == 'Estimate Account Total Volume')
            helper.sortByVolEu(component, 'Phoenix_Est_Acct_Total_Vol_EU__c'); 
        if(component.get("v.filterName") == 'Estimate Account Total Sales')
            helper.sortByVolEu(component, 'Phoenix_Est_Acct_Sales__c');
        if(component.get("v.filterName") == 'DRL Customer Actual Volume')
            helper.sortByVolEu(component, 'Phoenix_Cust_Act_Volume_Mat_Eu__c');
        if(component.get("v.filterName") == 'DRL Customer Actual Sales')
            helper.sortByVolEu(component, 'Cust_Act_Sales_Mat__c');  
        if(component.get("v.filterName") == 'Opportunity Sales')
            helper.sortByVolEu(component, 'Phoenix_Customer_Opp_Sales__c'); 
        if(component.get("v.filterName") == 'Opportunity TPT$')
            helper.sortByVolEu(component, 'Phoenix_Customer_Opp_TPT__c'); 
        
    },
    
    getAllDataForAnalysis : function(component, event, helper){
        var today = new Date();
        var month = [];
        month[0] = "Jan";
        month[1] = "Feb";
        month[2] = "Mar";
        month[3] = "Apr";
        month[4] = "May";
        month[5] = "Jun";
        month[6] = "Jul";
        month[7] = "Aug";
        month[8] = "Sep";
        month[9] = "Oct";
        month[10] = "Nov";
        month[11] = "Dec";
        month[-1] = "Jan";
        
        var last12M = ''+month[today.getMonth()]+' '+(today.getFullYear()-1)+' - '+month[today.getMonth()-1]+' '+(today.getFullYear());
        console.log('last12M -- '+last12M);
        component.set("v.last12M",last12M);
        var lastMonth = ''+month[today.getMonth()-1];
        lastMonth += ' '+(today.getMonth() == 0 ? today.getFullYear()-1 : today.getFullYear());
        console.log('lastMonth :: '+lastMonth);
        component.set("v.lastMonth",lastMonth);
        console.log('in InitRecords method');
        component.set('v.isSpinnerLoad', true);
        
        var accId = '';
        if(component.get("v.recordId")!= undefined)
            accId = component.get("v.recordId");
        else if(component.get("v.accId") != undefined)
            accId = component.get("v.accId");
        console.log('record Id :: '+accId);
        //component.set('v.recordId', accId);
        
        var posFilterList = component.get("v.posFilterList");
        if(posFilterList == undefined || posFilterList.length == 0){
            posFilterList = ['True Opportunity','Awarded','In Bid','Not An Opportunity','Price Constraint','Supply Constraint'];
            component.set("v.posFilterList",posFilterList);
        }
        console.log('posFilterList.length --->'+posFilterList.length);
        
        var picliList = component.get("v.RxSrxList");
        console.log('component.get("v.RxSrxList") :: '+component.get("v.RxSrxList"));
        if(component.get("v.RxSrxList") != undefined && component.get("v.RxSrxList").length > 0){
            picliList = component.get('v.RxSrxList');
        }
        
        var action = component.get("c.getGcpRelatedList");
        action.setParams({
            accId: accId,
            rxSrxOtcList : picliList,
            posFilterList : posFilterList,
            showRelevant : component.get("v.showRelevant")
        });
        action.setCallback(this, function (response) {
            console.log('State from getGcpRelatedList :: '+response.getState());
            if (response.getState() == "SUCCESS") {
                var wrapObj = response.getReturnValue();
                if(wrapObj.isErrorFromServer){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "ERROR",
                        "message":wrapObj.errorMessageFromServer,
                        "type":"ERROR",
                        "mode":"dismissible"
                    });
                    toastEvent.fire();
                    component.set('v.isSpinnerLoad', false);
                }
                else if(wrapObj.isJobRunning){
                    component.set("v.isJobRunning",true);
                    component.set('v.isSpinnerLoad', false);
                }
                    else{
                        var accObj = wrapObj.accObj;
                        component.set("v.marketShare", accObj.Phoenix_Customer_Est_Market_Share__c);
                        component.set("v.wallet", accObj.Phoenix_Customer_Max_Est_Share_of_Wallet__c);
                        component.set("v.coolingPeriod", accObj.Phoenix_Account_Cooling_Period__c);
                        var totalCxOpty = '';
                        var drlCurrentSales = '';
                        var drlOpptySales = '';
                        var drlTotEstActSales = '';
                        var drlShareOfWallet = '';
                        var drlShareOfWalletVol = '';
                        
                        function roundUpNumber(num){
                            var roundedNum = '';
                            if(num > 0){
                                if(num > 1000000000){
                                    roundedNum = ''+Math.round((num/1000000000) * 100) / 100+'B';
                                }
                                else if(num > 1000000){
                                    roundedNum = ''+Math.round((num/1000000) * 100) / 100+'M';
                                }
                                    else if(num > 1000){
                                        roundedNum = ''+Math.round((num/1000) * 100) / 100+'K';
                                    }
                                        else{
                                            roundedNum = num != undefined ? ''+Math.round((num) * 100) / 100 : '0';
                                        }
                            }
                            else{
                                if(num < -1000000000){
                                    roundedNum = ''+Math.round((num/1000000000) * 100) / 100+'B';
                                }
                                else if(num < -1000000){
                                    roundedNum = ''+Math.round((num/1000000) * 100) / 100+'M';
                                }
                                    else if(num < -1000){
                                        roundedNum = ''+Math.round((num/1000) * 100) / 100+'K';
                                    }
                                        else{
                                            roundedNum = num != undefined ? ''+Math.round((num) * 100) / 100 : '0';
                                        }
                            }
                            return roundedNum;
                        }
                        
                        totalCxOpty = roundUpNumber(accObj.Phoenix_Total_Customer_Opportunity__c);
                        drlCurrentSales = roundUpNumber(accObj.Phoenix_DRL_Current_Sales__c);
                        drlOpptySales = roundUpNumber(accObj.Phoenix_DRL_Opportunity_Sales__c);
                        drlTotEstActSales = roundUpNumber(accObj.Phoenix_DRL_Total_Est_Account_Sales__c);
                        drlShareOfWallet = roundUpNumber(accObj.Phoenix_DRL_Share_of_Wallet__c);
                        drlShareOfWalletVol = roundUpNumber(accObj.Phoenix_DRL_Share_of_Wallet_Vol__c);
                        
                        component.set("v.totalCxOpty", totalCxOpty);
                        component.set("v.drlCurrentSales", drlCurrentSales);
                        component.set("v.drlOpptySales", drlOpptySales);
                        component.set("v.drlTotEstActSales", drlTotEstActSales);
                        component.set("v.drlShareOfWallet", drlShareOfWallet);
                        component.set("v.drlShareOfWalletVol", drlShareOfWalletVol);
                        var gcpOptyTrcList = wrapObj.gcpList;
                        component.set("v.accObj",accObj);
                        component.set("v.gcpList",gcpOptyTrcList);
                        component.set("v.totalGcpRecords",gcpOptyTrcList.length);
                        var rxSrxOtcList = wrapObj.segmentList;
                        var filteredBy = '';
                        console.log('rxSrxOtcList ::: '+rxSrxOtcList);
                        if(rxSrxOtcList.includes('Rx')){
                            component.set("v.isRxChecked",true);
                            filteredBy = filteredBy != '' ? filteredBy+',Rx' : 'Rx';
                        }
                        else
                            component.set("v.isRxChecked",false);
                        if(rxSrxOtcList.includes('SRx')){
                            component.set("v.isSRxChecked",true);
                            filteredBy = filteredBy != '' ? filteredBy+', SRx' : 'SRx';
                        }
                        else
                            component.set("v.isSRxChecked",false);
                        if(rxSrxOtcList.includes('OTC')){
                            component.set("v.isOtcChecked",true);
                            filteredBy = filteredBy != '' ? filteredBy+', OTC' : 'OTC';
                        }
                        else
                            component.set("v.isOtcChecked",false);
                        component.set("v.filterDetails",filteredBy);
                        component.set("v.RxSrxList",rxSrxOtcList);
                        
                        var actTotal = 0; var shareOfWallet = 0; var drlAccVol = 0; var drlAccSales = 0; var drlAccPrice = 0;
                        var drlAccTpt = 0; var totalMktVol = 0; var drlActMktShare = 0; var totalMktShares = 0;
                        var custActMktShare = 0; var custActOppTpt = 0; var custActVol = 0;
                        
                        var totalTrueOptyCount = 0,notOptyCount = 0,PriceConCount = 0,supplyConCount = 0,awardedCount = 0,inBidCount = 0, sentToPanoramaCount=0;
                        var totalSalesTrueOpty = 0,totalSalesNotTrueOpty = 0,totalSalesPriceCons = 0, totalSalesSupplyCons =0, totalSalesCons=0,
                            totalSalesAwarded = wrapObj.awardedTotalSales,totalSalesInBid = wrapObj.inBidTotalSales;
                        if(gcpOptyTrcList.length>0){
                            var monthRange = '';
                            var last12M = '';
                            var continueLoop = true;
                            gcpOptyTrcList.forEach(function(gcpObj){
                                if(gcpObj.Phoenix_Est_Acct_Total_Vol_EU__c != undefined)
                                    actTotal = actTotal + gcpObj.Phoenix_Est_Acct_Total_Vol_EU__c;
                                if(gcpObj.Phoenix_Est_Acct_Share_of_Wallet__c != undefined)
                                    shareOfWallet = shareOfWallet + gcpObj.Phoenix_Est_Acct_Share_of_Wallet__c;
                                if(gcpObj.Phoenix_Drl_Act_Volume_Eu__c != undefined)
                                    drlAccVol = drlAccVol + gcpObj.Phoenix_Drl_Act_Volume_Eu__c;
                                if(gcpObj.Phoenix_Drl_Act_Sales__c != undefined)
                                    drlAccSales = drlAccSales + gcpObj.Phoenix_Drl_Act_Sales__c;
                                
                                if(gcpObj.Phoenix_Drl_Act_Price__c != undefined)
                                    drlAccPrice = drlAccPrice + gcpObj.Phoenix_Drl_Act_Price__c;
                                if(gcpObj.Phoenix_DRL_Actual_TPT__c != undefined)
                                    drlAccTpt = drlAccTpt + gcpObj.Phoenix_DRL_Actual_TPT__c;
                                if(gcpObj.Phoenix_Total_Market_Vol_MAT_EU__c != undefined)
                                    totalMktVol = totalMktVol + gcpObj.Phoenix_Total_Market_Vol_MAT_EU__c;
                                if(gcpObj.Phoenix_Total_Market_Sales__c != undefined)
                                    totalMktShares = totalMktShares + gcpObj.Phoenix_Total_Market_Sales__c;
                                
                                if(gcpObj.Phoenix_Cust_Act_Volume_Mat_Eu__c != undefined)
                                    custActVol = custActVol + gcpObj.Phoenix_Cust_Act_Volume_Mat_Eu__c;
                                if(gcpObj.Phoenix_Cust_Act_Mkt_Sh__c != undefined)
                                    custActMktShare = custActMktShare + gcpObj.Phoenix_Cust_Act_Mkt_Sh__c;
                                if(gcpObj.Phoenix_Customer_Opp_TPT__c != undefined)
                                    custActOppTpt = custActOppTpt + gcpObj.Phoenix_Customer_Opp_TPT__c;
                                
                                if(continueLoop){
                                    monthRange = gcpObj.Phoenix_Ims_Qtr_Month_Range__c != undefined && gcpObj.Phoenix_Ims_Qtr_Month_Range__c != null ? gcpObj.Phoenix_Ims_Qtr_Month_Range__c : '';
                                    
                                    last12M = gcpObj.Phoenix_Prof_Month_Range__c != undefined ? gcpObj.Phoenix_Prof_Month_Range__c : '';
                                    if(monthRange != '' && last12M != ''){
                                        continueLoop = false;
                                    }
                                }
                                /* if(gcpObj.Product_Status__c == 'True Opportunity'){
                                totalTrueOptyCount++;
                                totalSalesTrueOpty = parseInt(totalSalesTrueOpty) + parseInt(gcpObj.Phoenix_Customer_Opp_Sales__c != undefined ? gcpObj.Phoenix_Customer_Opp_Sales__c : 0);
                            }
                            else if(gcpObj.Product_Status__c == 'Not An Opportunity'){
                                notOptyCount++;
                                totalSalesNotTrueOpty = parseInt(totalSalesNotTrueOpty) + parseInt(gcpObj.Phoenix_Customer_Opp_Sales__c != undefined ? gcpObj.Phoenix_Customer_Opp_Sales__c : 0);
                            }
                                else if(gcpObj.Product_Status__c == 'Price Constraint'){
                                    PriceConCount++;
                                    totalSalesPriceCons = parseInt(totalSalesPriceCons) + parseInt(gcpObj.Phoenix_Customer_Opp_Sales__c != undefined ? gcpObj.Phoenix_Customer_Opp_Sales__c : 0);
                                    totalSalesCons = parseInt(totalSalesCons) + parseInt(gcpObj.Phoenix_Customer_Opp_Sales__c != undefined ? gcpObj.Phoenix_Customer_Opp_Sales__c : 0);
                                }
                                    else if(gcpObj.Product_Status__c == 'Supply Constraint'){
                                        supplyConCount++;
                                        totalSalesSupplyCons = parseInt(totalSalesSupplyCons) + parseInt(gcpObj.Phoenix_Customer_Opp_Sales__c != undefined ? gcpObj.Phoenix_Customer_Opp_Sales__c : 0);
                                        totalSalesCons = parseInt(totalSalesCons) + parseInt(gcpObj.Phoenix_Customer_Opp_Sales__c != undefined ? gcpObj.Phoenix_Customer_Opp_Sales__c : 0);
                                    }
                                        else if(gcpObj.Product_Status__c == 'Awarded'){
                                            awardedCount++;
                                        }
                                            else if(gcpObj.Product_Status__c == 'In Bid'){
                                                inBidCount++;
                                            }
                            if(gcpObj.Vision_isSentToPanorama__c)
                                sentToPanoramaCount++; */
                        });
                        /*component.set("v.totalTrueOptyCount",totalTrueOptyCount);
                        component.set("v.notOptyCount",notOptyCount);
                        component.set("v.supplyConCount",supplyConCount);
                        component.set("v.PriceConCount",PriceConCount);
                        component.set("v.awardedCount",awardedCount);
                        component.set("v.inBidCount",inBidCount);
                        component.set("v.sentToPanoramaCount",sentToPanoramaCount);
                        
                        var totalSalesTrueOptyStr = roundUpNumber(totalSalesTrueOpty);
                        var totalSalesNotTrueOptyStr = roundUpNumber(totalSalesNotTrueOpty);
                        var totalSalesPriceConsStr = roundUpNumber(totalSalesPriceCons);
                        var totalSalesSupplyConsStr = roundUpNumber(totalSalesSupplyCons);
                        var totalSalesConsStr = roundUpNumber(totalSalesCons);
                        var totalSalesAwardedStr = roundUpNumber(totalSalesAwarded);
                        var totalSalesInBidStr = roundUpNumber(totalSalesInBid);
                        
                        component.set("v.totalSalesTrueOpty",totalSalesTrueOptyStr);
                        component.set("v.totalSalesNotTrueOpty",totalSalesNotTrueOptyStr);
                        component.set("v.totalSalesPriceCons",totalSalesPriceConsStr);
                        component.set("v.totalSalesSupplyCons",totalSalesSupplyConsStr);
                        component.set("v.totalSalesCons",totalSalesConsStr);
                        component.set("v.totalSalesAwarded",totalSalesAwardedStr);
                        component.set("v.totalSalesInBid",totalSalesInBidStr);*/
                        
                            component.set("v.lastMonth",monthRange.includes('-') ? monthRange.split('-')[1] : monthRange.trim());
                            component.set("v.last12M",last12M);
                        }
                        
                        component.set("v.actTotal",actTotal);
                        component.set("v.shareOfWallet",shareOfWallet);
                        component.set("v.drlAccVol",drlAccVol);
                        component.set("v.drlAccSales",drlAccSales);
                        component.set("v.drlAccPrice",drlAccPrice);
                        component.set("v.drlAccTpt",drlAccTpt);
                        component.set("v.totalMktVol",totalMktVol);
                        component.set("v.totalMktShares",totalMktShares);
                        component.set("v.custActVol",custActVol);
                        component.set("v.custActMktShare",custActMktShare);
                        component.set("v.custActOppTpt",custActOppTpt);
                        
                        
                        var drlAccTptPerc = drlAccSales != 0 ? (drlAccTpt/drlAccSales)*100 : 0;
                        component.set("v.drlAccTptPerc",drlAccTptPerc);
                        var drlActMktShare = totalMktVol != 0 ? (accObj.Phoenix_DRL_Current_Sales__c/totalMktVol)*100 : 0;
                        component.set("v.drlActMktShare",wrapObj.drlActMktShare);
                        if(component.get("v.filterName") == undefined || component.get("v.filterName") == ''){
                            component.set("v.filterName",'Product Family');
                            component.set("v.isAsc",true);
                        }  
                        component.set("v.isAsc",!component.get("v.isAsc")); 
                        
                        if(component.get("v.filterName") == 'Product Status')
                            helper.sortBy(component, 'Product_Status__c');
                        if(component.get("v.filterName") == 'Product Family')
                            helper.sortBy(component, 'GCP_Product_Family__c');
                        if(component.get("v.filterName") == 'Vol (EU)')
                            helper.sortByVolEu(component, 'Phoenix_Drl_Act_Volume_Eu__c');
                        if(component.get("v.filterName") == 'Total DRL Market Sales')
                            helper.sortByVolEu(component, 'Phoenix_Drl_Act_Sales__c'); 
                        if(component.get("v.filterName") == 'Total DRL Market TPT')
                            helper.sortByVolEu(component, 'Phoenix_DRL_Actual_TPT__c'); 
                        if(component.get("v.filterName") == 'DRL Market Volume')
                            helper.sortByVolEu(component, 'Phoenix_Total_Market_Vol_MAT_EU__c'); 
                        if(component.get("v.filterName") == 'DRL Market Sales')
                            helper.sortByVolEu(component, 'Phoenix_Total_Market_Sales__c');
                        if(component.get("v.filterName") == 'Estimate Account Total Volume')
                            helper.sortByVolEu(component, 'Phoenix_Est_Acct_Total_Vol_EU__c'); 
                        if(component.get("v.filterName") == 'Estimate Account Total Sales')
                            helper.sortByVolEu(component, 'Phoenix_Est_Acct_Sales__c');
                        if(component.get("v.filterName") == 'DRL Customer Actual Volume')
                            helper.sortByVolEu(component, 'Phoenix_Cust_Act_Volume_Mat_Eu__c');
                        if(component.get("v.filterName") == 'DRL Customer Actual Sales')
                            helper.sortByVolEu(component, 'Cust_Act_Sales_Mat__c');  
                        if(component.get("v.filterName") == 'Opportunity Sales')
                            helper.sortByVolEu(component, 'Phoenix_Customer_Opp_Sales__c'); 
                        if(component.get("v.filterName") == 'Opportunity TPT$')
                            helper.sortByVolEu(component, 'Phoenix_Customer_Opp_TPT__c'); 
                           
                        
                        
                        /*if(!component.get("v.doNotSort")){
                            if(component.get("v.filterName") == undefined || component.get("v.filterName") == ''){
                                component.set("v.filterName",'Product Family');
                                component.set("v.isAsc",true);
                            } 
                            component.set("v.sortByDetails",' by '+component.get("v.filterName"));
                        }
                        else
                            component.set("v.doNotSort",false);
                        component.set('v.isSpinnerLoad', false);*/
                    }
            }
            else {
                component.set('v.isSpinnerLoad', false);
            }
        });
        $A.enqueueAction(action);
    },
    
    sortNumber : function(component, field){
        
    },
    sortByVolEu : function(component, field){
        var sortAsc = component.get("v.isAsc"),
            sortField = component.get("v.sortField"),
            records = component.get("v.gcpList");
        sortAsc = field == sortField? !sortAsc: true;
        if(sortAsc)
            records.sort(function(a, b){return (a[field] - b[field]);});
        else
            records.sort(function(a, b){return (b[field] - a[field]);});
        component.set("v.isAsc", sortAsc); 
        component.set("v.gcpList", records);
        component.set('v.isSpinnerLoad', false);
    },
    
	sortBy: function(component, field) {
        var sortAsc = component.get("v.isAsc"),
            sortField = component.get("v.sortField"),
            records = component.get("v.gcpList");
        sortAsc = field == sortField? !sortAsc: true;
        records.sort(function(a,b){
            var t1 = a[field] == b[field],
                t2 = (!a[field] && b[field]) || (a[field] < b[field]);
            return t1? 0: (sortAsc?-1:1)*(t2?1:-1);
        });
        component.set("v.isAsc", sortAsc);
        component.set("v.gcpList", records);
        component.set('v.isSpinnerLoad', false);
    },
    /*pullNdcLevelInfo : function(component, event, helper, offsetVal){
        var totalList = component.get("v.gcpList");
        component.set("v.loadingMessage",'Fetching NDC level info from product families. '+offsetVal+' out of '+totalList.length);
        var processingItem = totalList[offsetVal];//.slice(offsetVal, totalList.length);
        var action=component.get("c.getProdStatusInfoNdcLevel");
        action.setParams({processingGcpRec:processingItem});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                var wrapperObj = response.getReturnValue();
                
                var totalTrueOptyCount = component.get("v.totalTrueOptyCount"),
                    notOptyCount = component.get("v.notOptyCount"),
                    PriceConCount = component.get("v.PriceConCount"),
                    supplyConCount = component.get("v.supplyConCount"),
                    awardedCount = component.get("v.awardedCount"),
                    inBidCount = component.get("v.inBidCount"),
                    sentToPanoramaCount = component.get("v.sentToPanoramaCount");
                
                component.set("v.totalTrueOptyCount",totalTrueOptyCount+wrapperObj.totalTrueOptyCount);
                component.set("v.notOptyCount",notOptyCount+wrapperObj.notOptyCount);
                component.set("v.supplyConCount",supplyConCount+wrapperObj.supplyConCount);
                component.set("v.PriceConCount",PriceConCount+wrapperObj.PriceConCount);
                component.set("v.awardedCount",awardedCount+wrapperObj.awardedCount);
                component.set("v.inBidCount",inBidCount+wrapperObj.inBidCount);
                component.set("v.sentToPanoramaCount",sentToPanoramaCount+wrapperObj.sentToPanoramaCount);
if(offsetVal+1 == totalList.length){
                    component.set("v.loadingMessage",'');
                    component.set("v.combineConstraintVals",false);
                    console.log(' :: inside openProdStatChart :: combineConstraintVals -->'+component.get("v.combineConstraintVals"));
                    var jsonData = [];
                    jsonData.push({label:'True Opportunity',count:''+component.get("v.totalTrueOptyCount"),totalVal:''+component.get("v.totalSalesTrueOpty")});
                    jsonData.push({label:'Awarded',count:''+component.get("v.awardedCount"),totalVal:''+component.get("v.totalSalesAwarded")});
                    jsonData.push({label:'In Bid',count:''+component.get("v.inBidCount"),totalVal:''+component.get("v.totalSalesInBid")});
                    jsonData.push({label:'Not An Oportunity',count:''+component.get("v.notOptyCount"),totalVal:''+component.get("v.totalSalesNotTrueOpty")});
                    jsonData.push({label:'Price Constraint',count:''+component.get("v.PriceConCount"),totalVal:''+component.get("v.totalSalesPriceCons")});
                    jsonData.push({label:'Supply Constraint',count:''+component.get("v.supplyConCount"),totalVal:''+component.get("v.totalSalesSupplyCons")});
                    component.set("v.ltngChartData",jsonData);
                    component.set("v.combineConstraintVals",false);
                    component.set("v.isSpinnerLoad",false);
                    component.set("v.showProdStatChart",true);
                }
                else{
                    helper.pullNdcLevelInfo(component, event, helper, offsetVal+1);
                }
            }
            else{
                component.set("v.isSpinnerLoad",false);
                console.log('ERROR from updateNdcLineItem --> '+JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);
    },*/
    getStatusCount: function(component, event, helper, offsetVal){
        var relNumber = 0;
        var gcpList = component.get("v.gcpList");
        gcpList.forEach(function(item){
            if(item.Vision_isRelevance__c)
                relNumber++;
        });
        component.set("v.relNumber",relNumber);
        component.set("v.isSpinnerLoad",true);
        
        helper.getTheCount(component, event, helper, gcpList, 0);
    },
    getTheCount : function(component, event, helper, gcpList, offsetVal){
        component.set("v.loadingMessage",'Fetching NDC level info from product families. '+offsetVal+' out of '+gcpList.length);
        var processingItem = gcpList[offsetVal];
        if(processingItem.Vision_isRelevance__c){
            if(component.get("v.accObj.Vision_is_SRx_Account__c"))
                var action=component.get("c.getStatusCountSRx");
            else
                var action=component.get("c.getStatusCount");
            action.setParams({processingGcpRec:processingItem});
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS"){
                    var wrapperObj = response.getReturnValue();
                    var reviewProductsObj = component.get("v.reviewProductsObj");
                    //var totalTrueOptyCount = component.get("v.totalTrueOptyCount"), notOptyCount = component.get("v.notOptyCount"),
                    //    PriceConCount = component.get("v.PriceConCount"), supplyConCount = component.get("v.supplyConCount"),
                    //    awardedCount = component.get("v.awardedCount"), inBidCount = component.get("v.inBidCount"),
                    //    sentToPanoramaCount = component.get("v.sentToPanoramaCount"), totalNdcNumber = component.get("v.totalNdcNumber");
                    if(component.get("v.accObj").Vision_is_SRx_Account__c){
                        /*var PriceConDollar = component.get("v.PriceConDollar"), SupplyConDollar = component.get("v.SupplyConDollar"),
                            notOptyDollar = component.get("v.notOptyDollar"), trueOptyDollar = component.get("v.trueOptyDollar"), awardedDollar = component.get("v.awardedDollar");
                        component.set("v.PriceConDollar",PriceConDollar+wrapperObj.PriceConDollar);
                        component.set("v.SupplyConDollar",SupplyConDollar+wrapperObj.SupplyConDollar);
                        component.set("v.awardedDollar",awardedDollar+wrapperObj.awardedDollar);
                        component.set("v.trueOptyDollar",trueOptyDollar+wrapperObj.trueOptyDollar);
                        component.set("v.notOptyDollar",notOptyDollar+wrapperObj.notOptyDollar);
                        component.set("v.PriceConDollar",PriceConDollar+wrapperObj.PriceConDollar);
                        component.set("v.SupplyConDollar",SupplyConDollar+wrapperObj.SupplyConDollar);
                        component.set("v.awardedDollar",awardedDollar+wrapperObj.awardedDollar);
                        component.set("v.trueOptyDollar",trueOptyDollar+wrapperObj.trueOptyDollar);
                        component.set("v.notOptyDollar",notOptyDollar+wrapperObj.notOptyDollar);*/
                        reviewProductsObj.prodStatusTrueOpty = reviewProductsObj.prodStatusTrueOpty + wrapperObj.prodStatusTrueOpty;
                        reviewProductsObj.prodStatusNotTrueOpty = reviewProductsObj.prodStatusNotTrueOpty + wrapperObj.prodStatusNotTrueOpty;
                        reviewProductsObj.prodStatusPriceCons = reviewProductsObj.prodStatusPriceCons + wrapperObj.prodStatusPriceCons;
                        reviewProductsObj.prodStatusSupplyCons = reviewProductsObj.prodStatusSupplyCons + wrapperObj.prodStatusSupplyCons;
                        reviewProductsObj.prodStatusAwarded = reviewProductsObj.prodStatusAwarded + wrapperObj.prodStatusAwarded;
                        reviewProductsObj.prodStatusNdcNumber = reviewProductsObj.prodStatusNdcNumber+wrapperObj.prodStatusNdcNumber;
                        reviewProductsObj.prodStatusInBid = reviewProductsObj.prodStatusInBid+wrapperObj.prodStatusInBid;
                        
                        reviewProductsObj.PriceConDollar = reviewProductsObj.PriceConDollar + wrapperObj.PriceConDollar;
                        reviewProductsObj.SupplyConDollar = reviewProductsObj.SupplyConDollar + wrapperObj.SupplyConDollar;
                        reviewProductsObj.notOptyDollar = reviewProductsObj.notOptyDollar + wrapperObj.notOptyDollar;
                        reviewProductsObj.trueOptyDollar = reviewProductsObj.trueOptyDollar + wrapperObj.trueOptyDollar;
                        reviewProductsObj.awardedDollar = reviewProductsObj.awardedDollar + wrapperObj.awardedDollar;
                        reviewProductsObj.PriceConInBidCount = reviewProductsObj.PriceConInBidCount + wrapperObj.PriceConInBidCount;
                        reviewProductsObj.SupplyConInBidCount = reviewProductsObj.SupplyConInBidCount + wrapperObj.SupplyConInBidCount;
                        reviewProductsObj.notOptyInBidCount = reviewProductsObj.notOptyInBidCount + wrapperObj.notOptyInBidCount;
                        reviewProductsObj.trueOptyInBidCount = reviewProductsObj.trueOptyInBidCount + wrapperObj.trueOptyInBidCount;
                        reviewProductsObj.awardedInBidCount = reviewProductsObj.awardedInBidCount + wrapperObj.awardedInBidCount;
                        
                    }  
                    reviewProductsObj.totalNdcNumber = reviewProductsObj.totalNdcNumber + wrapperObj.totalCountOfNDC;
                        //component.set("v.totalNdcNumber",totalNdcNumber+wrapperObj.totalCountOfNDC);
                    if(wrapperObj.totalTrueOptyCount>0){
                        reviewProductsObj.totalTrueOptyCount = reviewProductsObj.totalTrueOptyCount + wrapperObj.totalTrueOptyCount;
                        reviewProductsObj.totalTrueOptyFam = reviewProductsObj.totalTrueOptyFam + 1;
                        //component.set("v.totalTrueOptyCount",totalTrueOptyCount+wrapperObj.totalTrueOptyCount);
                        //component.set("v.totalTrueOptyFam",component.get("v.totalTrueOptyFam")+1);
                    }
                    if(wrapperObj.notOptyCount>0){
                        reviewProductsObj.notOptyCount = reviewProductsObj.notOptyCount + wrapperObj.notOptyCount;
                        reviewProductsObj.totalNotOptyFam = reviewProductsObj.totalNotOptyFam + 1;
                        //component.set("v.notOptyCount",notOptyCount+wrapperObj.notOptyCount);
                        //component.set("v.totalNotOptyFam",component.get("v.totalNotOptyFam")+1);
                    }
                    if(wrapperObj.supplyConCount>0){
                        reviewProductsObj.supplyConCount = reviewProductsObj.supplyConCount + wrapperObj.supplyConCount;
                        reviewProductsObj.totalSupplyConFam = reviewProductsObj.totalSupplyConFam + 1;
                        //component.set("v.supplyConCount",supplyConCount+wrapperObj.supplyConCount);
                        //component.set("v.totalSupplyConFam",component.get("v.totalSupplyConFam")+1);
                    }
                    if(wrapperObj.PriceConCount>0){
                        reviewProductsObj.PriceConCount = reviewProductsObj.PriceConCount + wrapperObj.PriceConCount;
                        reviewProductsObj.totalPriceConFam = reviewProductsObj.totalPriceConFam + 1;
                        //component.set("v.PriceConCount",PriceConCount+wrapperObj.PriceConCount);
                        //component.set("v.totalPriceConFam",component.get("v.totalPriceConFam")+1);
                    }
                    if(wrapperObj.awardedCount>0){
                        reviewProductsObj.awardedCount = reviewProductsObj.awardedCount + wrapperObj.awardedCount;
                        reviewProductsObj.totalAwardedFam = reviewProductsObj.totalAwardedFam + 1;
                        //component.set("v.awardedCount",awardedCount+wrapperObj.awardedCount);
                        //component.set("v.totalAwardedFam",component.get("v.totalAwardedFam")+1);
                    }
                    if(wrapperObj.inBidCount>0){
                        reviewProductsObj.inBidCount = reviewProductsObj.inBidCount + wrapperObj.inBidCount;
                        reviewProductsObj.totalInbidFam = reviewProductsObj.totalInbidFam + 1;
                        //component.set("v.inBidCount",inBidCount+wrapperObj.inBidCount);
                        //component.set("v.totalInbidFam",component.get("v.totalInbidFam")+1);
                    }
                    component.set("v.reviewProductsObj",reviewProductsObj);
                    if(offsetVal+1 == gcpList.length){
                        component.set("v.selectedTabInPieChart",'Awarded');
                        helper.getNDCListForPieChartController(component, event, helper);
                        component.set("v.isSpinnerLoad",false);
                        component.set("v.showReviewProductsPopup",true);
                    }
                    else
                        helper.getTheCount(component, event, helper, gcpList, offsetVal+1);
                }
                else{
                    component.set("v.isSpinnerLoad",false);
                    console.log('ERROR from getStatusCount --> '+JSON.stringify(response.getError()));
                }
            });
            $A.enqueueAction(action);
        }
        else if(offsetVal+1 == gcpList.length){
            component.set("v.selectedTabInPieChart",'Awarded');
            helper.getNDCListForPieChartController(component, event, helper);
            component.set("v.isSpinnerLoad",false);
            component.set("v.showReviewProductsPopup",true);
        }
            else
                helper.getTheCount(component, event, helper, gcpList, offsetVal+1);
    },
    getNDCListForPieChartController : function(component, event, helper){
        var action=component.get("c.getNDCListForPieChart");
        action.setParams({accId:component.get("v.recordId"),prodStatus:component.get("v.selectedTabInPieChart"),isCon:component.get("v.showNdcList")});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                component.set("v.ndcListFromPieChart",response.getReturnValue());
            }
            else{
                component.set("v.isSpinnerLoad",false);
                console.log('ERROR from updateNdcLineItem --> '+JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);
    }
})