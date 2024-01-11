({
    initRecords : function(component, event, helper) {
        var recordId = component.get("v.recordId");
        var isExclude = false;
        var excludeAccItem = $A.get("$Label.c.NotIncludeAccForAnalysis");
        if(excludeAccItem != undefined){
            if(excludeAccItem.includes(',')){
                var exAccList = excludeAccItem.split(',');
                exAccList.forEach(function(obj){
                    if(obj.replace(/\s/g, '') == recordId)
                        isExclude = true;
                });
            }
            else{
                if(excludeAccItem.replace(/\s/g, '') == recordId)
                    isExclude = true;
            }
        }
        if(isExclude)
            component.set("v.excludeAccountError",true);
        else if(component.get("v.record").Name == 'Red Oak Sourcing' || component.get("v.record").AccountNumber == '153363')
            helper.getAllCustomersData(component, event, helper);
            else
                helper.getAllDataForAnalysis(component, event, helper);
    },
    
    searchSrxRxOttc : function(component, event, helper){
        /*var picliList = component.get('v.RxSrxList');        
        if(component.get("v.isRxChecked") && !picliList.includes('Rx')){
            console.log('I am Rx')
            picliList.push('Rx');
        }
        if(component.get("v.isSRxChecked") && !picliList.includes('SRx')){
            picliList.push('SRx');
        }
        if(component.get("v.isOtcChecked") && !picliList.includes('OTC')){
            picliList.push('OTC');
        }
        if(component.get("v.isRxChecked") == false && picliList.includes('Rx')){
            var ind = picliList.indexOf('Rx')
            picliList.splice(ind, 1);
        }
        if(component.get("v.isSRxChecked") == false && picliList.includes('SRx')){
            var ind = picliList.indexOf('SRx')
            picliList.splice(ind, 1);
        }
        if(component.get("v.isOtcChecked") == false && picliList.includes('OTC')){
            var ind = picliList.indexOf('OTC')
            picliList.splice(ind, 1);
        }
        component.set("v.RxSrxList",picliList);
        component.set("v.doNotSort",true);
        var a = component.get('c.initRecords');
        $A.enqueueAction(a);*/
        component.set('v.isSpinnerLoad', true);
        var action=component.get("c.updateAccWithNewFilter");
            action.setParams({accObj:component.get("v.accObj")});
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS"){
                    component.set("v.accObj",response.getReturnValue());
                    //var a = component.get('c.initRecords');
                    //$A.enqueueAction(a);
                    helper.getItemsAfterFilter(component, event, helper);
                }
                else{
                    component.set("v.isSpinnerLoad",false);
                    console.log('ERROR from updateNdcLineItem --> '+JSON.stringify(response.getError()));
                }
            });
        $A.enqueueAction(action);
    },
    allCheckBoxChanged : function(component, event, helper){
        component.set("v.isTrueOptyChecked",true);
        component.set("v.isAwardedChecked",true);
        component.set("v.isInBidChecked",true);
        component.set("v.isnotOptyChecked",true);
        component.set("v.isPriceConChecked",true);
        component.set("v.isSupplyConChecked",true);
        var a = component.get('c.searchPositionFilter');
        $A.enqueueAction(a);
    },
    searchPositionFilter : function(component, event, helper){
        var picliList = component.get('v.posFilterList');
        if(component.get("v.isTrueOptyChecked") && !picliList.includes('True Opportunity')){
            picliList.push('True Opportunity');
        }
        if(component.get("v.isAwardedChecked") && !picliList.includes('Awarded')){
            picliList.push('Awarded');
        }
        if(component.get("v.isInBidChecked") && !picliList.includes('In Bid')){
            picliList.push('In Bid');
        }
        if(component.get("v.isnotOptyChecked") && !picliList.includes('Not An Opportunity')){
            picliList.push('Not An Opportunity');
        }
        if(component.get("v.isPriceConChecked") && !picliList.includes('Price Constraint')){
            picliList.push('Price Constraint');
        }
        if(component.get("v.isSupplyConChecked") && !picliList.includes('Supply Constraint')){
            picliList.push('Supply Constraint');
        }
        if(component.get("v.isTrueOptyChecked") == false && picliList.includes('True Opportunity')){
            var ind = picliList.indexOf('True Opportunity')
            picliList.splice(ind, 1);
        }
        if(component.get("v.isAwardedChecked") == false && picliList.includes('Awarded')){
            var ind = picliList.indexOf('Awarded')
            picliList.splice(ind, 1);
        }
        if(component.get("v.isInBidChecked") == false && picliList.includes('In Bid')){
            var ind = picliList.indexOf('In Bid')
            picliList.splice(ind, 1);
        }
        if(component.get("v.isnotOptyChecked") == false && picliList.includes('Not An Opportunity')){
            var ind = picliList.indexOf('Not An Opportunity')
            picliList.splice(ind, 1);
        }
        if(component.get("v.isPriceConChecked") == false && picliList.includes('Price Constraint')){
            var ind = picliList.indexOf('Price Constraint')
            picliList.splice(ind, 1);
        }
        if(component.get("v.isSupplyConChecked") == false && picliList.includes('Supply Constraint')){
            var ind = picliList.indexOf('Supply Constraint')
            picliList.splice(ind, 1);
        }
        if(picliList.length<6)
            component.set("v.isShowAllChecked",false);
        else 
            component.set("v.isShowAllChecked",true);
        component.set("v.posFilterList",picliList);
        component.set("v.doNotSort",true);
        var a = component.get('c.initRecords');
        $A.enqueueAction(a);
    },
    cancel : function(component, event, helper) {   
        component.set("v.showSaveCancelBtn",false);
    },
    showSaveButton : function(component, event, helper) {   
        component.set("v.showSaveCancelBtn",true);
    },
    onRecordSubmit : function(component, event, helper) {   
        event.preventDefault(); 
        var eventFields = event.getParam("fields");
        component.find("customerForm").submit(eventFields);
    },
    onRecordSuccess : function(component, event, helper) {   
        console.log('records submitted successfully..');
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "SUCCESS",
            "message":'Header Defaults Saved Successfully!',
            "type":"SUCCESS",
            "mode":"dismissible"
        });
        toastEvent.fire();
        component.set("v.showSaveCancelBtn",false);
        component.set("v.doNotSort",true);
        var a = component.get('c.initRecords');
        $A.enqueueAction(a);
        //$A.get('e.force:refreshView').fire();
    },
    goBack : function(component, event, helper) {   
        component.find("navigationService").navigate({
            type: "standard__recordPage",
            attributes: {
                recordId: component.get("v.accId"),
                actionName: "view"
            }
        }, false);
    },
    refreshData : function(component, event, helper) {  
        var message = event.getParam("isRefreshRecs");
        if(message == 'REFRESH'){
            component.set("v.doNotSort",true);
            if(component.get("v.record").Name == 'Red Oak Sourcing' || component.get("v.record").AccountNumber == '153363'){
                component.set('v.isSpinnerLoad', true);
                helper.getOnlyItems(component, event, helper);
            }
            else{
                var a = component.get('c.initRecords');
                $A.enqueueAction(a);
            }
        }
        else{
            var gcpRec = event.getParam("gcpRec");
            var indexVal = event.getParam("indexVal");
            var gcpList = component.get("v.gcpList");
            gcpList[indexVal] = gcpRec;
            component.set("v.gcpList",gcpList);
            component.set("v.doNotSort",true);
            var a = component.get('c.updateHeaderValues');
            $A.enqueueAction(a);
        }
    },
    sortByProdFamily : function(component, event, helper){
        component.set('v.isSpinnerLoad', true);
        if(component.get("v.filterName") != 'Product Family')
            component.set("v.isAsc", true);
        component.set("v.filterName",'Product Family');
        component.set("v.sortField",'GCP_Product_Family__c');
        helper.sortBy(component, 'GCP_Product_Family__c');
    },
    sortByVolEu : function(component, event, helper){
        component.set('v.isSpinnerLoad', true);
        if(component.get("v.filterName") != 'Vol (EU)')
            component.set("v.isAsc", false);
        component.set("v.filterName",'Vol (EU)');
        component.set("v.sortField",'Phoenix_Drl_Act_Volume_Eu__c');
        helper.sortByVolEu(component, 'Phoenix_Drl_Act_Volume_Eu__c');
    },
    sortByTotDrlMktSales : function(component, event, helper){
        component.set('v.isSpinnerLoad', true);
        if(component.get("v.filterName") != 'Total DRL Market Sales')
            component.set("v.isAsc", false);
        component.set("v.filterName",'Total DRL Market Sales');
        component.set("v.sortField",'Phoenix_Drl_Act_Sales__c');
        helper.sortByVolEu(component, 'Phoenix_Drl_Act_Sales__c');
    }, 
    sortByTotDrlMktPrice : function(component, event, helper){
        component.set('v.isSpinnerLoad', true);
        if(component.get("v.filterName") != 'Total DRL Market Price')
            component.set("v.isAsc", false);
        component.set("v.filterName",'Total DRL Market Price');
        component.set("v.sortField",'Phoenix_Drl_Act_Price__c');
        helper.sortByVolEu(component, 'Phoenix_Drl_Act_Price__c');
    }, 
    sortByTotDrlMktTpt : function(component, event, helper){
        component.set('v.isSpinnerLoad', true);
        if(component.get("v.filterName") != 'Total DRL Market TPT')
            component.set("v.isAsc", false);
        component.set("v.filterName",'Total DRL Market TPT');
        component.set("v.sortField",'Phoenix_DRL_Actual_TPT__c');
        helper.sortByVolEu(component, 'Phoenix_DRL_Actual_TPT__c');
    }, 
    sortByDrlMktVol : function(component, event, helper){
        component.set('v.isSpinnerLoad', true);
        if(component.get("v.filterName") != 'DRL Market Volume')
            component.set("v.isAsc", false);
        component.set("v.filterName",'DRL Market Volume');
        component.set("v.sortField",'Phoenix_Total_Market_Vol_MAT_EU__c');
        helper.sortByVolEu(component, 'Phoenix_Total_Market_Vol_MAT_EU__c');
    }, 
    sortByDrlMktSales : function(component, event, helper){
        component.set('v.isSpinnerLoad', true);
        if(component.get("v.filterName") != 'DRL Market Sales')
            component.set("v.isAsc", false);
        component.set("v.filterName",'DRL Market Sales');
        component.set("v.sortField",'Phoenix_Total_Market_Sales__c');
        helper.sortByVolEu(component, 'Phoenix_Total_Market_Sales__c');
    }, 
    sortByEstAccTotVol : function(component, event, helper){
        component.set('v.isSpinnerLoad', true);
        if(component.get("v.filterName") != 'Estimate Account Total Volume')
            component.set("v.isAsc", false);
        component.set("v.filterName",'Estimate Account Total Volume');
        component.set("v.sortField",'Phoenix_Est_Acct_Total_Vol_EU__c');
        helper.sortByVolEu(component, 'Phoenix_Est_Acct_Total_Vol_EU__c');
    }, 
    sortByEstAccTotSales : function(component, event, helper){
        component.set('v.isSpinnerLoad', true);
        if(component.get("v.filterName") != 'Estimate Account Total Sales')
            component.set("v.isAsc", false);
        component.set("v.filterName",'Estimate Account Total Sales');
        component.set("v.sortField",'Phoenix_Est_Acct_Sales__c');
        helper.sortByVolEu(component, 'Phoenix_Est_Acct_Sales__c');
    }, 
    sortByDrlCustActVol : function(component, event, helper){
        component.set('v.isSpinnerLoad', true);
        if(component.get("v.filterName") != 'DRL Customer Actual Volume')
            component.set("v.isAsc", false);
        component.set("v.filterName",'DRL Customer Actual Volume');
        component.set("v.sortField",'Phoenix_Cust_Act_Volume_Mat_Eu__c');
        helper.sortByVolEu(component, 'Phoenix_Cust_Act_Volume_Mat_Eu__c');
    }, 
    sortByDrlCustActSales : function(component, event, helper){
        component.set('v.isSpinnerLoad', true);
        if(component.get("v.filterName") != 'DRL Customer Actual Sales')
            component.set("v.isAsc", false);
        component.set("v.filterName",'DRL Customer Actual Sales');
        component.set("v.sortField",'Cust_Act_Sales_Mat__c');
        helper.sortByVolEu(component, 'Cust_Act_Sales_Mat__c');
    },
    sortByOptySales : function(component, event, helper){
        component.set('v.isSpinnerLoad', true);
        if(component.get("v.filterName") != 'Opportunity Sales')
            component.set("v.isAsc", false);
        component.set("v.filterName",'Opportunity Sales');
        component.set("v.sortField",'Phoenix_Customer_Opp_Sales__c');
        helper.sortByVolEu(component, 'Phoenix_Customer_Opp_Sales__c');
    }, 
    sortByOptyTpt : function(component, event, helper){
        component.set('v.isSpinnerLoad', true);
        if(component.get("v.filterName") != 'Opportunity TPT$')
            component.set("v.isAsc", false);
        component.set("v.filterName",'Opportunity TPT$');
        component.set("v.sortField",'Phoenix_Customer_Opp_TPT__c');
        helper.sortByVolEu(component, 'Phoenix_Customer_Opp_TPT__c');
    }, 
    sortByProdPos : function(component, event, helper){
        component.set('v.isSpinnerLoad', true);
        if(component.get("v.filterName") != 'Product Status')
            component.set("v.isAsc", false);
        component.set("v.filterName",'Product Status');
        component.set("v.sortField",'Product_Status__c');
        helper.sortBy(component, 'Product_Status__c');
    }, 
    updateHeaderValues: function(component, event, helper){
        console.log('*************** invoked change event **************');
        var gcpOptyTrcList = component.get("v.gcpList");
        var totalTrueOptyCount = 0,notOptyCount = 0,PriceConCount = 0,supplyConCount = 0,awardedCount = 0,inBidCount = 0, sentToPanoramaCount=0;
        var totalSalesTrueOpty = 0,totalSalesNotTrueOpty = 0,totalSalesPriceCons = 0, totalSalesSupplyCons =0, totalSalesCons=0;
        if(gcpOptyTrcList.length>0){
            gcpOptyTrcList.forEach(function(gcpObj){
                if(gcpObj.Product_Status__c == 'True Opportunity'){
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
                        else if(gcpObj.Product_Status__c == 'Supply Constraint' ){
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
                    sentToPanoramaCount++; 
            });
            component.set("v.totalTrueOptyCount",totalTrueOptyCount);
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
            console.log('totalSalesTrueOpty :: '+totalSalesTrueOpty);
            console.log('totalSalesTrueOptyStr :: '+totalSalesTrueOptyStr);
            
            component.set("v.totalSalesTrueOpty",totalSalesTrueOptyStr);
            component.set("v.totalSalesNotTrueOpty",totalSalesNotTrueOptyStr);
            component.set("v.totalSalesPriceCons",totalSalesPriceConsStr);
            component.set("v.totalSalesSupplyCons",totalSalesSupplyConsStr);
            component.set("v.totalSalesCons",totalSalesConsStr);
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
        }
    },
    loadChart : function(component, chartSection, componentName, params){
        console.log('*****load chart called'+chartSection);
        $A.createComponent(
            componentName, 
            params,
            function(chartBox) {
                //Add the dynamic chart to div
                if (component.isValid()) {
                    console.log('****creating the chart component');
                    var targetCmp = component.find(chartSection);
                    targetCmp.set("v.body",[]);
                    var body = targetCmp.get("v.body");
                    body.push(chartBox);
                    targetCmp.set("v.body", body);
                }
            }
        );
    },
    
    closeProdStatChart: function(component, event, helper){
        component.set("v.showProdStatChart",false);
        component.set("v.combineConstraintVals",false);
        component.set("v.showReviewProductsPopup",true);
        component.set("v.ndcListFromPieChart",[]);
    },
    showExternalFam : function(component, event, helper){
        var reviewProductsObj = component.get("v.reviewProductsObj");
        var jsonData = [];
        jsonData.push({label:'True Opportunity',count:''+reviewProductsObj.totalTrueOptyFam, dollar:''+reviewProductsObj.trueOptyDollar});//,totalVal:''+component.get("v.totalSalesTrueOpty")});//
        jsonData.push({label:'Awarded',count:''+reviewProductsObj.totalAwardedFam, dollar:''+reviewProductsObj.awardedDollar});//,totalVal:''+component.get("v.totalSalesAwarded")});
        jsonData.push({label:'In Bid',count:''+reviewProductsObj.totalInbidFam, dollar:''+reviewProductsObj.notOptyDollar});//,totalVal:''+component.get("v.totalSalesInBid")});
        jsonData.push({label:'Not An Oportunity',count:''+reviewProductsObj.totalNotOptyFam, dollar:''+reviewProductsObj.notOptyDollar});//,totalVal:''+component.get("v.totalSalesNotTrueOpty")});
        var countOfCon = parseInt(reviewProductsObj.totalPriceConFam)+parseInt(reviewProductsObj.totalSupplyConFam);
        var conDollar = parseInt(reviewProductsObj.PriceConDollar)+parseInt(reviewProductsObj.supplyConCount);
        jsonData.push({label:'DRL Constraint',count:''+countOfCon, dollar:''+conDollar});//,totalVal:''+component.get("v.totalSalesCons")});
        component.set("v.showNdcList",false);
        component.set("v.isProdFamSelectedForReview",true);
        component.set("v.internalView",false);
        component.set("v.ltngChartData",jsonData);
        component.set("v.showProdStatChart",true);
        component.set("v.showReviewProductsPopup",false);
    },
    showInternalFam : function(component, event, helper){
        var reviewProductsObj = component.get("v.reviewProductsObj");
        var jsonData = [];
        jsonData.push({label:'True Opportunity',count:''+reviewProductsObj.totalTrueOptyFam, dollar:''+reviewProductsObj.trueOptyDollar});//,totalVal:''+component.get("v.totalSalesTrueOpty")});//
        jsonData.push({label:'Awarded',count:''+reviewProductsObj.totalAwardedFam, dollar:''+reviewProductsObj.awardedDollar});//,totalVal:''+component.get("v.totalSalesAwarded")});
        jsonData.push({label:'In Bid',count:''+reviewProductsObj.totalInbidFam, dollar:''+reviewProductsObj.notOptyDollar});//,totalVal:''+component.get("v.totalSalesInBid")});
        jsonData.push({label:'Not An Oportunity',count:''+reviewProductsObj.totalNotOptyFam, dollar:''+reviewProductsObj.notOptyDollar});//,totalVal:''+component.get("v.totalSalesNotTrueOpty")});
        jsonData.push({label:'Price Constraint',count:''+reviewProductsObj.totalPriceConFam, dollar:''+reviewProductsObj.PriceConDollar});//,totalVal:''+component.get("v.totalSalesPriceCons")});
        jsonData.push({label:'Supply Constraint',count:''+reviewProductsObj.totalSupplyConFam, dollar:''+reviewProductsObj.SupplyConDollar});//,totalVal:''+component.get("v.totalSalesSupplyCons")});
        component.set("v.ltngChartData",jsonData);
        component.set("v.isProdFamSelectedForReview",true);
        component.set("v.showProdStatChart",true);
        component.set("v.showNdcList",false);
        component.set("v.internalView",true);
        component.set("v.showReviewProductsPopup",false);
    },
    showInternalSRx : function(component, event, helper){
        component.set("v.showNdcList",false);
        var reviewProductsObj = component.get("v.reviewProductsObj");
        var jsonData = [];
        jsonData.push({label:'True Opportunity',count:''+reviewProductsObj.prodStatusTrueOpty, dollar:''+reviewProductsObj.trueOptyDollar});//,totalVal:''+component.get("v.totalSalesTrueOpty")});//
        jsonData.push({label:'Awarded',count:''+reviewProductsObj.prodStatusAwarded, dollar:''+reviewProductsObj.awardedDollar});//,totalVal:''+component.get("v.totalSalesAwarded")});
        jsonData.push({label:'Not An Oportunity',count:''+reviewProductsObj.prodStatusNotTrueOpty, dollar:''+reviewProductsObj.notOptyDollar});//,totalVal:''+component.get("v.totalSalesNotTrueOpty")});
        jsonData.push({label:'Price Constraint',count:''+reviewProductsObj.prodStatusPriceCons, dollar:''+reviewProductsObj.PriceConDollar});//,totalVal:''+component.get("v.totalSalesPriceCons")});
        jsonData.push({label:'Supply Constraint',count:''+reviewProductsObj.prodStatusSupplyCons, dollar:''+reviewProductsObj.SupplyConDollar});//,totalVal:''+component.get("v.totalSalesSupplyCons")});
        jsonData.push({label:'Both',count:''+reviewProductsObj.bothConCount, dollar:''+reviewProductsObj.bothConDollar});
        component.set("v.internalView",true);
        component.set("v.isProdFamSelectedForReview",true);
        component.set("v.ltngChartData",jsonData);
        component.set("v.showDollar",false);
        component.set("v.showProdStatChart",true);
        component.set("v.showReviewProductsPopup",false);
    },
    showExternalSRx : function(component, event, helper){
        component.set("v.showNdcList",false);
        var reviewProductsObj = component.get("v.reviewProductsObj");
        var jsonData = [];
        jsonData.push({label:'True Opportunity',count:''+reviewProductsObj.prodStatusTrueOpty, dollar:''+reviewProductsObj.trueOptyDollar});//,totalVal:''+component.get("v.totalSalesTrueOpty")});//
        jsonData.push({label:'Awarded',count:''+reviewProductsObj.prodStatusAwarded, dollar:''+reviewProductsObj.awardedDollar});//,totalVal:''+component.get("v.totalSalesAwarded")});
        jsonData.push({label:'Not An Oportunity',count:''+reviewProductsObj.prodStatusNotTrueOpty, dollar:''+reviewProductsObj.notOptyDollar});//,totalVal:''+component.get("v.totalSalesNotTrueOpty")});
        var countOfCon = parseInt(reviewProductsObj.prodStatusPriceCons)+parseInt(reviewProductsObj.prodStatusSupplyCons);
        var conDollar = parseInt(reviewProductsObj.PriceConDollar)+parseInt(reviewProductsObj.supplyConCount);
        jsonData.push({label:'DRL Constraint',count:''+countOfCon, dollar:''+conDollar});//,totalVal:''+component.get("v.totalSalesCons")});
        jsonData.push({label:'Both',count:''+reviewProductsObj.bothConCount, dollar:''+reviewProductsObj.bothConDollar});
        component.set("v.internalView",false);
        component.set("v.isProdFamSelectedForReview",true);
        component.set("v.ltngChartData",jsonData);
        component.set("v.showDollar",false);
        component.set("v.showProdStatChart",true);
        component.set("v.showReviewProductsPopup",false);
    },
    showExternalNDC : function(component, event, helper){
        var reviewProductsObj = component.get("v.reviewProductsObj");
        var jsonData = [];
        jsonData.push({label:'True Opportunity',count:''+reviewProductsObj.totalTrueOptyCount, dollar:''+reviewProductsObj.trueOptyDollar});//,totalVal:''+component.get("v.totalSalesTrueOpty")});//
        jsonData.push({label:'Awarded',count:''+reviewProductsObj.awardedCount, dollar:''+reviewProductsObj.awardedDollar});//,totalVal:''+component.get("v.totalSalesAwarded")});
        if(!component.get("v.accObj").Vision_is_SRx_Account__c)
            jsonData.push({label:'In Bid',count:''+reviewProductsObj.inBidCount, dollar:0});//,totalVal:''+component.get("v.totalSalesInBid")});
        jsonData.push({label:'Not An Oportunity',count:''+reviewProductsObj.notOptyCount, dollar:''+reviewProductsObj.notOptyDollar});//,totalVal:''+component.get("v.totalSalesTrueOpty")});//
        var countOfCon = parseInt(reviewProductsObj.PriceConCount)+parseInt(reviewProductsObj.supplyConCount);
        if(component.get("v.accObj").Vision_is_SRx_Account__c){
            var conDollar = parseInt(reviewProductsObj.PriceConDollar)+parseInt(reviewProductsObj.supplyConCount);
            component.set("v.showDollar",true);
            component.set("v.showNdcList",true);
        }
        else
            var conDollar = 0;
        jsonData.push({label:'DRL Constraint',count:''+countOfCon, dollar:''+conDollar});//,totalVal:''+component.get("v.totalSalesCons")});
        component.set("v.internalView",false);
        component.set("v.isProdFamSelectedForReview",false);
        component.set("v.ltngChartData",jsonData);
        component.set("v.showProdStatChart",true);
        component.set("v.showReviewProductsPopup",false);
    },
    showInternalNDC : function(component, event, helper){
        var reviewProductsObj = component.get("v.reviewProductsObj");
        var jsonData = [];
        jsonData.push({label:'True Opportunity',count:''+reviewProductsObj.totalTrueOptyCount, dollar:''+reviewProductsObj.trueOptyDollar});//,totalVal:''+component.get("v.totalSalesTrueOpty")});//
        jsonData.push({label:'Awarded',count:''+reviewProductsObj.awardedCount, dollar:''+reviewProductsObj.awardedDollar});//,totalVal:''+component.get("v.totalSalesAwarded")});
        if(!component.get("v.accObj").Vision_is_SRx_Account__c)
            jsonData.push({label:'In Bid',count:''+reviewProductsObj.inBidCount, dollar:0});//,totalVal:''+component.get("v.totalSalesInBid")});
        else{
            component.set("v.showDollar",true);
            component.set("v.showNdcList",true);
        }
        jsonData.push({label:'Not An Oportunity',count:''+reviewProductsObj.notOptyCount, dollar:''+reviewProductsObj.notOptyDollar});//,totalVal:''+component.get("v.totalSalesNotTrueOpty")});
        jsonData.push({label:'Price Constraint',count:''+reviewProductsObj.PriceConCount, dollar:''+reviewProductsObj.PriceConDollar});//,totalVal:''+component.get("v.totalSalesPriceCons")});
        jsonData.push({label:'Supply Constraint',count:''+reviewProductsObj.supplyConCount, dollar:''+reviewProductsObj.SupplyConDollar});//,totalVal:''+component.get("v.totalSalesSupplyCons")});
        component.set("v.ltngChartData",jsonData);
        component.set("v.internalView",true);
        component.set("v.isProdFamSelectedForReview",false);
        component.set("v.showProdStatChart",true);
        component.set("v.showReviewProductsPopup",false);
    },
    combineConstraint : function(component, event, helper){
        console.log('combineConstraintVals :: '+component.get("v.combineConstraintVals"));
        var jsonData = [];
        jsonData.push({label:'True Opportunity',count:''+component.get("v.totalTrueOptyCount")});//,totalVal:''+component.get("v.totalSalesTrueOpty")});//
        jsonData.push({label:'Awarded',count:''+component.get("v.awardedCount")});//,totalVal:''+component.get("v.totalSalesAwarded")});
        jsonData.push({label:'In Bid',count:''+component.get("v.inBidCount")});//,totalVal:''+component.get("v.totalSalesInBid")});
        jsonData.push({label:'Not An Oportunity',count:''+component.get("v.notOptyCount")});//,totalVal:''+component.get("v.totalSalesNotTrueOpty")});
        if(component.get("v.combineConstraintVals")){
            console.log(' ::inside combine:: ');
            var countOfCon = parseInt(component.get("v.PriceConCount"))+parseInt(component.get("v.supplyConCount"));
            jsonData.push({label:'Price/Supply Constraint',count:''+countOfCon});//,totalVal:''+component.get("v.totalSalesCons")});
        }
        else{
            console.log(' ::inside NOT combine:: ');
            jsonData.push({label:'Price Constraint',count:''+component.get("v.PriceConCount")});//,totalVal:''+component.get("v.totalSalesPriceCons")});
            jsonData.push({label:'Supply Constraint',count:''+component.get("v.supplyConCount")});//,totalVal:''+component.get("v.totalSalesSupplyCons")});
        }
        component.set("v.ltngChartData",jsonData);
        component.set("v.showCombineConstraintVals",component.get("v.combineConstraintVals"));
    },
    showHideMktItems : function(component, event, helper){
        component.set("v.hideMarketingItems",component.get("v.hideMarketingItems")?false:true);
    },
    
    openRelevancePopup : function(component, event, helper){
        var picliList = [];
        if(component.get("v.isRxCheckedForRel"))
            picliList.push('Rx');
        if(component.get("v.isSRxCheckedForRel"))
            picliList.push('SRx');
        if(component.get("v.isOtcCheckedForRel"))
            picliList.push('OTC');
        component.set('v.isSpinnerLoad', true);
        var action = component.get("c.getGCPFamList");
        action.setParams({
            accId: component.get("v.recordId")//,rxSrxOtcList : picliList
        });
        action.setCallback(this, function (response) {
            console.log('State from getGCPFamList :: '+response.getState());
            if (response.getState() == "SUCCESS") {
                component.set('v.isSpinnerLoad', false);
                var respMap = response.getReturnValue();
                var relNumber = 0;
                var gcpOptyTrcList = [];
                var rxRelCount = 0;
                var srxRelCount = 0;
                var otcRelCount = 0;
                
                respMap.forEach(function(item){
                    if(item.isSelected){
                        relNumber++;
                        if(item.segment == 'Rx')
                            rxRelCount++;
                        else if(item.segment == 'SRx')
                            srxRelCount++;
                            else if(item.segment == 'OTC')
                                otcRelCount++;
                    }
                });
                component.set("v.rxRelCount",rxRelCount);
                component.set("v.srxRelCount",srxRelCount);
                component.set("v.otcRelCount",otcRelCount);
                respMap.sort((a,b) => (a.familyName > b.familyName) ? 1 : ((b.familyName > a.familyName) ? -1 : 0))
                console.log('ProdList --> '+JSON.stringify(respMap));
                component.set("v.gcpPodFamList",respMap);
                component.set("v.relNumber",relNumber);
                component.set("v.showRelevancePopup",true);
                var a = component.get('c.searchForRelList');
                $A.enqueueAction(a);
            }
            else {
                console.log('error from famFetch --> '+JSON.stringify(response.getError()));
                component.set('v.isSpinnerLoad', false);
            }
        });
        $A.enqueueAction(action);
    },
    closeRelevancePopup : function(component, event, helper){
        component.set("v.showRelevancePopup",false);
    },
    relSegChanged : function(component,event,helper){
        component.set("v.disableRelev",true);
        var action=component.get("c.updateAccWithNewFilter");
        action.setParams({accObj:component.get("v.accObj")});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                component.set("v.accObj",response.getReturnValue());
                var a = component.get('c.searchForRelList');
                $A.enqueueAction(a);
                component.set("v.disableRelev",false);
            }
            else{
                component.set("v.disableRelev",false);
                console.log('ERROR from updateAccWithNewFilter --> '+JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);
    },
    searchForRelList : function(component, event, helper){
        var picliList = [];
        var accObj = component.get("v.accObj");
        if(accObj.Vision_Rx_Filtered_in_Relevance__c)
            picliList.push('Rx');
        if(accObj.Vision_SRx_Filtered_in_Relevance__c)
            picliList.push('SRx');
        if(accObj.Vision_OTC_Filtered_in_Relevance__c)
            picliList.push('OTC');
        /*if(component.get("v.isRxCheckedForRel"))
            picliList.push('Rx');
        if(component.get("v.isSRxCheckedForRel"))
            picliList.push('SRx');
        if(component.get("v.isOtcCheckedForRel"))
            picliList.push('OTC');*/
        var gcpFamList = component.get("v.gcpPodFamList");
        var searchName = component.get("v.serachInputForRel");
        var newList = [];
        gcpFamList.forEach(function(obj){
            if(picliList.includes(obj.segment)){
                if(searchName == '' || searchName == undefined)
                    obj.isFiltered = true;
                else if(obj.familyName.toLowerCase().includes(searchName.toLowerCase()))
                    obj.isFiltered = true;
                    else
                        obj.isFiltered = false;
            }
            else
                obj.isFiltered = false;
            newList.push(obj);
        });
        component.set("v.gcpPodFamList",newList);
    },
    
    relevanceCheckBoxChanged : function(component, event, helper){
        var gcpList = component.get("v.gcpPodFamList");
        var rxRelCount = 0;
        var srxRelCount = 0;
        var otcRelCount = 0;
        var relNumber = 0;
        gcpList.forEach(function(item){
            if(item.isSelected){
                relNumber++;
                if(item.segment == 'Rx')
                    rxRelCount++;
                else if(item.segment == 'SRx')
                    srxRelCount++;
                    else if(item.segment == 'OTC')
                        otcRelCount++;
            }
        });
        component.set("v.rxRelCount",rxRelCount);
        component.set("v.srxRelCount",srxRelCount);
        component.set("v.otcRelCount",otcRelCount);
        component.set("v.relNumber",relNumber);
    },
    allProdsChanged : function(component, event, helper){
        console.log('inside allProdChanged and val :: '+component.get("v.selectAllFamilies"));
        var gcpList = component.get("v.gcpPodFamList");
        var updatedGcpList = [];
        gcpList.forEach(function(item){
            if(item.isFiltered)
                item.isSelected = component.get("v.selectAllFamilies") ? true : false;
            updatedGcpList.push(item);
        });
        var rxRelCount = 0;
        var srxRelCount = 0;
        var otcRelCount = 0;
        var relNumber = 0;
        updatedGcpList.forEach(function(item){
            if(item.isSelected){
                relNumber++;
                if(item.segment == 'Rx')
                    rxRelCount++;
                else if(item.segment == 'SRx')
                    srxRelCount++;
                    else if(item.segment == 'OTC')
                        otcRelCount++;
            }
        });
        component.set("v.rxRelCount",rxRelCount);
        component.set("v.srxRelCount",srxRelCount);
        component.set("v.otcRelCount",otcRelCount);
        component.set("v.gcpPodFamList",updatedGcpList);
        component.set("v.relNumber",relNumber);//updatedGcpList.length);
    },
    saveRelevanceList : function(component, event, helper){
        component.set("v.disableRelev",true);
        var gcpList = component.get("v.gcpPodFamList");
        var relList = [];
        gcpList.forEach(function(item){
            if(item.isSelected){
                relList.push(item.familyName);
                if(item.segment == 'Rx')
                    console.log('RX prod --> '+item.familyName);
                else if(item.segment == 'SRx')
                    console.log('SRX prod --> '+item.familyName);
                    else if(item.segment == 'OTC')
                        console.log('OTC prod --> '+item.familyName);
            }
        });
        console.log('relList.size() ---> '+relList.length);
        var action = component.get("c.updateGcpListWithNewRelevance");
        action.setParams({
            accId : component.get("v.recordId"),
            relList: relList
        });
        action.setCallback(this, function (response) {
            console.log('State from updateGcpListWithNewRelevance :: '+response.getState());
            if (response.getState() == "SUCCESS"){
                if(component.get("v.record").Name == 'Red Oak Sourcing')
                    helper.getAllCustomersData(component, event, helper);
                else
                    helper.getAllDataForAnalysis(component, event, helper);
                component.set("v.showRelevancePopup",false);
            }
            else {
                //var errorList = response.getError();
                //var message = errorList[0].message;
                //console.log('errorMessage :: '+message);
                console.log('ERROR WHILE updating New Relevance :: '+JSON.stringify(response.getError()));
            }
            component.set("v.disableRelev",false);
        });
        $A.enqueueAction(action);
    },
    
    openReviewProduts : function(component, event, helper){
        /*component.set("v.totalNdcNumber",0);
        component.set("v.totalTrueOptyCount",0);
        component.set("v.notOptyCount",0);
        component.set("v.supplyConCount",0);
        component.set("v.PriceConCount",0);
        component.set("v.awardedCount",0);
        component.set("v.inBidCount",0);
        component.set("v.sentToPanoramaCount",0);
        component.set("v.totalTrueOptyFam",0);
        component.set("v.totalNotOptyFam",0);
        component.set("v.totalSupplyConFam",0);
        component.set("v.totalPriceConFam",0);
        component.set("v.totalAwardedFam",0);
        component.set("v.totalInbidFam",0);*/
        
        var reviewProductsObj = {};
        reviewProductsObj.notOptyCount = 0;
        reviewProductsObj.totalTrueOptyCount = 0;
        reviewProductsObj.PriceConCount = 0;
        reviewProductsObj.supplyConCount = 0;
        reviewProductsObj.bothConCount = 0;
        
        reviewProductsObj.awardedCount = 0;
        reviewProductsObj.inBidCount = 0;
        
        reviewProductsObj.totalTrueOptyFam = 0;
        reviewProductsObj.totalNotOptyFam = 0;
        reviewProductsObj.totalPriceConFam = 0;
        reviewProductsObj.totalSupplyConFam = 0;
        reviewProductsObj.totalAwardedFam = 0;
        reviewProductsObj.totalInbidFam = 0;
        
        reviewProductsObj.sentToPanoramaCount = 0;
        reviewProductsObj.totalNdcNumber = 0;
        reviewProductsObj.PriceConDollar = 0;
        reviewProductsObj.SupplyConDollar = 0;
        reviewProductsObj.bothConDollar = 0;
        reviewProductsObj.notOptyDollar = 0;
        reviewProductsObj.trueOptyDollar = 0;
        reviewProductsObj.awardedDollar = 0;
        
        reviewProductsObj.PriceConInBidCount = 0;
        reviewProductsObj.SupplyConInBidCount = 0;
        reviewProductsObj.bothConInBidCount = 0;
        reviewProductsObj.notOptyInBidCount = 0;
        reviewProductsObj.trueOptyInBidCount = 0;
        reviewProductsObj.awardedInBidCount = 0;
        reviewProductsObj.totalNdcNumber = 0;
        
        reviewProductsObj.prodStatusTrueOpty = 0;
        reviewProductsObj.prodStatusNotTrueOpty = 0;
        reviewProductsObj.prodStatusPriceCons = 0;
        reviewProductsObj.prodStatusSupplyCons = 0;
        reviewProductsObj.prodStatusBothCons = 0;
        
        reviewProductsObj.prodStatusCons = 0;
        reviewProductsObj.prodStatusAwarded = 0;
        reviewProductsObj.prodStatusInBid =  0;
        reviewProductsObj.prodStatusNdcNumber = 0;
        component.set("v.reviewProductsObj",reviewProductsObj);
        
        helper.getStatusCount(component, event, helper, 0);
    },
    
    AwardedStatusToPullListChanged : function(component, event, helper){
        var summaryObj = {};
        summaryObj.totalsOfEa = 0;
        summaryObj.totalsOfEu = 0;
        summaryObj.custVol = 0;
        summaryObj.custSales = 0;
        component.set("v.summaryObj",summaryObj);
        component.set("v.ndcListFromPieChart",[]);
        component.set("v.selectedTabInPieChart",'Awarded');
        helper.getNDCListForPieChartController(component, event, helper);
    },
    TrueOptyStatusToPullListChanged : function(component, event, helper){
        var summaryObj = {};
        summaryObj.totalsOfEa = 0;
        summaryObj.totalsOfEu = 0;
        summaryObj.custVol = 0;
        summaryObj.custSales = 0;
        component.set("v.summaryObj",summaryObj);
        component.set("v.ndcListFromPieChart",[]);
        component.set("v.selectedTabInPieChart",'True Opportunity');
        helper.getNDCListForPieChartController(component, event, helper);
    },
    ScStatusToPullListChanged : function(component, event, helper){
        var summaryObj = {};
        summaryObj.totalsOfEa = 0;
        summaryObj.totalsOfEu = 0;
        summaryObj.custVol = 0;
        summaryObj.custSales = 0;
        component.set("v.summaryObj",summaryObj);
        component.set("v.ndcListFromPieChart",[]);
        component.set("v.selectedTabInPieChart",'Supply Constraint');
        helper.getNDCListForPieChartController(component, event, helper);
    },
    PcStatusToPullListChanged : function(component, event, helper){
        var summaryObj = {};
        summaryObj.totalsOfEa = 0;
        summaryObj.totalsOfEu = 0;
        summaryObj.custVol = 0;
        summaryObj.custSales = 0;
        component.set("v.summaryObj",summaryObj);
        component.set("v.ndcListFromPieChart",[]);
        component.set("v.selectedTabInPieChart",'Price Constraint');
        helper.getNDCListForPieChartController(component, event, helper);
    },
    NotOptyStatusToPullListChanged : function(component, event, helper){
        var summaryObj = {};
        summaryObj.totalsOfEa = 0;
        summaryObj.totalsOfEu = 0;
        summaryObj.custVol = 0;
        summaryObj.custSales = 0;
        component.set("v.summaryObj",summaryObj);
        component.set("v.ndcListFromPieChart",[]);
        component.set("v.selectedTabInPieChart",'Not An Opportunity');
        helper.getNDCListForPieChartController(component, event, helper);
    },
    inBidStatusToPullListChanged : function(component, event, helper){
        var summaryObj = {};
        summaryObj.totalsOfEa = 0;
        summaryObj.totalsOfEu = 0;
        summaryObj.custVol = 0;
        summaryObj.custSales = 0;
        component.set("v.summaryObj",summaryObj);
        component.set("v.ndcListFromPieChart",[]);
        component.set("v.selectedTabInPieChart",'In Bid');
        helper.getNDCListForPieChartController(component, event, helper);
    },
    bothStatusToPullListChanged : function(component, event, helper){
        var summaryObj = {};
        summaryObj.totalsOfEa = 0;
        summaryObj.totalsOfEu = 0;
        summaryObj.custVol = 0;
        summaryObj.custSales = 0;
        component.set("v.summaryObj",summaryObj);
        component.set("v.ndcListFromPieChart",[]);
        component.set("v.selectedTabInPieChart",'Both');
        helper.getNDCListForPieChartController(component, event, helper);
    },
    closeProductReviewPopup : function(component, event, helper){
        component.set("v.showReviewProductsPopup",false);
    },
    drlConStatusToPullListChanged : function(component, event, helper){
        component.set("v.ndcListFromPieChart",[]);
        component.set("v.selectedTabInPieChart",'DRL Constraint');
        helper.getNDCListForPieChartController(component, event, helper);
    },
    
    checkRelavant : function(component, event, helper){
        var showRelevant = component.get("v.showRelevant");
        if(showRelevant){
            
        }
    },
    updatedSelectedProds : function(component, event, helper){
        var selectedNdcs = event.getParam("selectedNdcs");
        if(selectedNdcs != undefined && selectedNdcs.length > 0){ 
            component.set("v.selectedNdcs", selectedNdcs);  
        }
        else if(selectedNdcs.length == 0)
            component.set("v.selectedNdcs", []);  
    },
    createOptyWithSelectedProds : function(component, event, helper){
        try{
            var accObj = component.get("v.accObj");
            var action = component.get("c.getCommentsOfPrds");
            action.setParams({
                prodIds : component.get("v.selectedNdcs"),
                accId: accObj.Id
            });
            action.setCallback(this, function (response) {
                console.log('State from getCommentsOfPrds :: '+response.getState());
                console.log('comment --> '+ response.getReturnValue());
                if (response.getState() == "SUCCESS"){
                    var newDate = new Date();
                    var n = newDate.toDateString();
                    var timeStr = newDate.toLocaleTimeString();
                    var datetimeStr = n +' - '+ timeStr;
                    var reDirEvnt = $A.get("e.force:navigateToComponent");
                    reDirEvnt.setParams({
                        componentDef: "c:Phoenix_OpportunityEditPage",
                        componentAttributes: {
                            selectedNdcs : component.get("v.selectedNdcs"),
                            isFromAnalysis : true,
                            name : ''+accObj.Name+' '+datetimeStr,
                            source : '100% Analysis',
                            type : 'Proactive',
                            isAccSel : true,
                            customerLkp : accObj.Id,
                            actualTemplate : accObj.Phoenix_Customer_Class_Bid_Template__c,
                            comments : response.getReturnValue()
                        }
                    });
                    reDirEvnt.fire();
                }
                else {
                    console.log('ERROR WHILE getCommentsOfPrds :: '+JSON.stringify(response.getError()));
                }
                component.set("v.disableRelev",false);
            });
            $A.enqueueAction(action);
        }
        catch(e){
            console.log('Exception : '+e.message);
        }
    },
    openSelectedProducts : function(component, event, helper){
        var selectedNdcs = component.get("v.selectedNdcs");
        if(selectedNdcs.length > 0){
            var action = component.get("c.getProdListWithIds");
            action.setParams({
                prodIds : component.get("v.selectedNdcs")
            });
            action.setCallback(this, function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    component.set('v.loading', false);
                    component.set("v.selectedProdList",response.getReturnValue());
                    component.set("v.showSelectedProdList",true);
                }
                else if (state === "ERROR") {
                    console.log("Error: "+JSON.stringify(response.getError()));
                }
            });
            $A.enqueueAction(action);
        }
        else{
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "ERROR",
                "message": 'No products are selected to preview.',
                "type":"ERROR",
                "mode":"dismissible"
            });
            toastEvent.fire();
        }
    },
    closeShowSelectedProds : function(component, event, helper){
        component.set("v.showSelectedProdList",false);
    },
     closeModel: function(component, event, helper) {
        // Set isModalOpen attribute to true
        component.set("v.isModalOpen", false);
           component.set("v.isManualOpen", false);
    },
    openModal: function(component, event, helper) {
        // Set isModalOpen attribute to true
        component.set("v.isModalOpen", true);
        
    },
    openManual: function(component, event, helper) {
        // Set isModalOpen attribute to true
        component.set("v.isManualOpen", true);
    },
    exportReviewItems : function(component, event, helper){
        
        var action=component.get("c.getNDCListForPieChart");
        action.setParams({accId:component.get("v.recordId"),
                          prodStatus:'',
                          isCon:component.get("v.showNdcList")});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                var ndcListFromPieChart = response.getReturnValue();
                var accObj = component.get("v.accObj");
                var csv = helper.convertArrayOfObjectsToCSV(component,event,helper, ndcListFromPieChart);   
                if (csv == null){return;} 
                var hiddenElement = document.createElement('a');
                hiddenElement.href = 'data:text/csv;charset=utf-8,' + encodeURI(csv);
                hiddenElement.target = '_self';    
                var date = new Date(); 
                var hours = date.getHours(); 
                var minutes = date.getMinutes(); 
                var newformat = hours >= 12 ? 'PM' : 'AM';  
                hours = hours % 12;  
                hours = hours ? hours : 12;  
                minutes = minutes < 10 ? '0' + minutes : minutes;        
                var Now=(date.getMonth()+1)+'/'+date.getDate()+'/'+date.getFullYear()+' '+hours+':'+minutes+' '+newformat;
                hiddenElement.download = 'Review Products - '+accObj.Name+'-'+Now+'.csv';//'+component.get("v.selectedTabInPieChart")+'
                document.body.appendChild(hiddenElement); 
                hiddenElement.click();
            }
            else{
                component.set("v.isSpinnerLoad",false);
                console.log('ERROR from updateNdcLineItem --> '+JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);
        
        
    }
})