({
    getData: function(component, event, helper){
        component.set('v.loaded', true);
        var selections = component.get("v.selections");
        if(component.get("v.selections") != undefined && component.get("v.selections").length > 0){
            selections = component.get('v.selections');
        }
        console.log('Selections:: '+component.get("v.selections"));
        console.log('selectedComparison:: '+component.get("v.comparison"));
        console.log('customerId:: '+component.get("v.accId"));
        var action = component.get("c.getDRLSalesRelatedList");
        action.setParams({
            selections: selections,
            selectedComparison: component.get("v.comparison"),
            customerId: component.get("v.accId")
        });
        action.setCallback(this, function(response) 
                           {
                               if(response.getState()=="SUCCESS"){
                                   component.set("v.loaded", false);
                                   var response= response.getReturnValue();
                                   console.log('Response:::: '+JSON.stringify(response));
                                   component.set("v.GCPUpdateDate", response.GCPUpdateDate);
                                   component.set("v.VisionUpdateDate", response.VisionUpdateDate);
                                   component.set("v.DataAvailableTill", response.DataAvailableTill);
                                   if(response.accWrapMap.length != 0){
                                       console.log('Response:::: '+JSON.stringify(response));
                                       component.set("v.noData", false);
                                       component.set("v.customerName", response.customerName);
                                       /*var selections = response.selections;
                                       var filteredBy = '';
                                       //console.log('selections ::: '+selections);
                                       if(selections.includes('Rx')){
                                           component.set("v.isRxChecked",true);
                                           filteredBy = filteredBy != '' ? filteredBy+',Rx' : 'Rx';
                                       }
                                       else
                                           component.set("v.isRxChecked",false);
                                       if(selections.includes('SRx')){
                                           component.set("v.isSRxChecked",true);
                                           filteredBy = filteredBy != '' ? filteredBy+', SRx' : 'SRx';
                                       }
                                       else
                                           component.set("v.isSRxChecked",false);
                                       if(selections.includes('OTC')){
                                           component.set("v.isOtcChecked",true);
                                           filteredBy = filteredBy != '' ? filteredBy+', OTC' : 'OTC';
                                       }
                                       else
                                           component.set("v.isOtcChecked",false);
                                       component.set("v.selections",selections);*/
                                       var salesdlSummary =[]; var unitsSummary =[]; var tptSummary =[]; var tptPercentSummary =[]; var salesdlPrevSummary =[];
                                       var unitsPrevSummary =[]; var tptPrevSummary =[]; var tptPercentPrevSummary =[]; var sumOfPrevSales =[]; var sumOfRecentSales =[]; var sumOfPrevUnits=[]; var sumOfRecentUnits =[]; var sumOfPrevTPTDl =[]; var sumOfRecentTPTDl =[]; var sumOfPrevTPTPerc =[]; var sumOfRecentTPTPerc =[]; var xAxisLabelsSummary = [];
                                       var comparison = component.get("v.comparison");
                                       var l1 = []; var l2 = []; var sumofSales = 0; var sumofunits = 0; var sumoftptdl = 0; var sumoftptperc = 0;
                                       for (var key in response.finalPrevMapSummary){
                                           salesdlPrevSummary.push(response.finalPrevMapSummary[key]['prevsalesMonthlySummary']);
                                           unitsPrevSummary.push(response.finalPrevMapSummary[key]['prevunitsMonthlySummary']);
                                           tptPrevSummary.push(response.finalPrevMapSummary[key]['prevtptdollarMonthlySummary']);
                                           tptPercentPrevSummary.push(response.finalPrevMapSummary[key]['prevtptpercMonthlySummary']);
                                           if(comparison != 'lastquartervspreviousquarter'){
                                               var label = key.split('-');
                                               xAxisLabelsSummary.push(label[0]); 
                                           } else{
                                               sumofSales += response.finalPrevMapSummary[key]['prevsalesMonthlySummary'];
                                               sumofunits += response.finalPrevMapSummary[key]['prevunitsMonthlySummary'];
                                               sumoftptdl += response.finalPrevMapSummary[key]['prevtptdollarMonthlySummary'];
                                           }
                                       }
                                       sumOfPrevSales.push(sumofSales);
                                       sumOfPrevUnits.push(sumofunits);
                                       sumOfPrevTPTDl.push(sumoftptdl);
                                       sumOfPrevTPTPerc.push((sumoftptdl/sumofSales)*100);
                                       component.set("v.sumOfPrevSales",sumOfPrevSales);
                                       component.set("v.sumOfPrevUnits",sumOfPrevUnits);
                                       component.set("v.sumOfPrevTPTDl",sumOfPrevTPTDl);
                                       component.set("v.sumOfPrevTPTPerc",sumOfPrevTPTPerc);
                                       var sumofSalesRecent = 0; var somofUnitsRecent = 0; var sumofTPTDlRecent = 0; var sumofTPTPercRecent = 0;
                                       for (var key in response.finalRecentMapSummary){
                                           salesdlSummary.push(response.finalRecentMapSummary[key]['salesMonthlySummary']);
                                           unitsSummary.push(response.finalRecentMapSummary[key]['unitsMonthlySummary']);
                                           tptSummary.push(response.finalRecentMapSummary[key]['tptdollarMonthlySummary']);
                                           tptPercentSummary.push(response.finalRecentMapSummary[key]['tptpercMonthlySummary']);
                                           if(comparison != 'lastquartervspreviousquarter'){
                                               var label = key.split('-');
                                               if(!xAxisLabelsSummary.includes(label[0])){
                                                   xAxisLabelsSummary.push(label[0]);
                                               }  
                                           } else{
                                               sumofSalesRecent += response.finalRecentMapSummary[key]['salesMonthlySummary'];
                                               somofUnitsRecent +=response.finalRecentMapSummary[key]['unitsMonthlySummary'];
                                               sumofTPTDlRecent += response.finalRecentMapSummary[key]['tptdollarMonthlySummary'];
                                           }
                                       }
                                       
                                       sumOfRecentSales.push(sumofSalesRecent);
                                       sumOfRecentUnits.push(somofUnitsRecent);
                                       sumOfRecentTPTDl.push(sumofTPTDlRecent);
                                       sumOfRecentTPTPerc.push((sumofTPTDlRecent/sumofSalesRecent)*100);
                                       component.set("v.sumOfRecentSales",sumOfRecentSales);
                                       component.set("v.sumOfRecentUnits",sumOfRecentUnits);
                                       component.set("v.sumOfRecentTPTDl",sumOfRecentTPTDl);
                                       component.set("v.sumOfRecentTPTPerc",sumOfRecentTPTPerc);
                                       component.set("v.salesdlSummary",salesdlSummary);
                                       component.set("v.unitsSummary",unitsSummary);
                                       component.set("v.tptSummary",tptSummary);
                                       component.set("v.tptPercentSummary",tptPercentSummary);                                  
                                       component.set("v.xAxisLabelsSummary", xAxisLabelsSummary);
                                       component.set("v.salesdlPrevSummary",salesdlPrevSummary);
                                       component.set("v.unitsPrevSummary",unitsPrevSummary);
                                       component.set("v.tptPrevSummary",tptPrevSummary);
                                       component.set("v.tptPercentPrevSummary",tptPercentPrevSummary);
                                       if(component.get("v.filterName") == undefined || component.get("v.filterName") == ''){
                                           component.set("v.filterName",'Recent Sales');
                                           component.set("v.isAsc", false);
                                       } 
                                       helper.buildData(component, event, helper, response);   
                                   } else{
                                       component.set("v.noData", true);
                                   }
                               } else{
                                   component.set("v.loaded", false);
                                   console.log("Error "+JSON.stringify(response.getError()));
                               }
                           });
        $A.enqueueAction(action);  
        
    },
    
    buildData : function(component, event, helper, response) {
        var headers = response.dynamicHeaders;
        component.set("v.monthlyData", response.custmonthly);
        var headersList = [];
        component.set("v.headers", headers);
        headersList.push(headers.two);
        headersList.push(headers.one);
        component.set("v.headersList", headersList);
        var responseValue = response.accWrapMap;
        var summaryObj = {};
        var tableData = component.get("v.tableData");
        var showOnlyTenRecords = component.get("v.showOnlyTenRecords");
        console.log('showOnlyTenRecords-->'+showOnlyTenRecords);
        var [salesPrevSummary, salesSummary, salesTrendingSummary, volumePrevSummary, volumeSummary, volumeTrendingSummary, 
             tptPrevSummary, tptSummary, tptTrendingSummary, tptPPrevSummary, tptPSummary, tptPTrendingSummary]= [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
        var sortedResponse = responseValue.sort((a, b) => {
            if (a.salesdl > b.salesdl)
            return -1;
            if (a.salesdl < b.salesdl)
            return 1;
            return 0;
        });
        var productFamilies = component.get("v.productFamilies");
        if(sortedResponse.length >= 10){
            for(var i=0; i<10; i++){
                console.log(':::::: '+sortedResponse[i].pfamily);
                if(!productFamilies.includes(sortedResponse[i].pfamily)){
                    productFamilies.push(sortedResponse[i].pfamily);
                } 
            }   
        } else{
            for(var i=0; i<sortedResponse.length; i++){
                if(!productFamilies.includes(sortedResponse[i].pfamily)){
                    productFamilies.push(sortedResponse[i].pfamily);
                }  
            }                
        }
        var allProductFamilies = component.get("v.allProductFamilies");
        console.log('1 OK');
        for(var i=0; i<sortedResponse.length; i++){
            if(!allProductFamilies.includes(sortedResponse[i].pfamily)){
                allProductFamilies.push(sortedResponse[i].pfamily);
            }
        }
        component.set("v.productFamilies", productFamilies);
        console.log('productFamilies::: '+productFamilies);
        component.set("v.allProductFamilies", allProductFamilies);
        for(var i=0; i<responseValue.length; i++){
            var trendingSales;
            var trendingVolume;
            var trendingTPT;
            var trendingTPTPercent;
            if(responseValue[i].SalesDollarPrev == 0 || responseValue[i].salesdl == 0){
                trendingSales = 0;
            } else{
                trendingSales = (responseValue[i].salesdl/responseValue[i].SalesDollarPrev)-1;
            }
            if(responseValue[i].UnitsPrev ==0 || responseValue[i].units == 0){
                trendingVolume = 0;
            } else{
                trendingVolume = (responseValue[i].units/responseValue[i].UnitsPrev)-1;
            }
            if(responseValue[i].TPTDollarPrev ==0 || responseValue[i].tptdollar == 0){
                trendingTPT = 0;
            } else{
                trendingTPT = (responseValue[i].tptdollar/responseValue[i].TPTDollarPrev)-1;
            }
            trendingTPTPercent = (responseValue[i].tptpct - responseValue[i].TPTPctPrev);
            if(trendingTPT != null || trendingTPT != undefined) responseValue[i].trendingSales = trendingSales;
            if(trendingVolume != null || trendingVolume != undefined) responseValue[i].trendingVolume = trendingVolume;
            if(trendingTPT != null || trendingTPT != undefined) responseValue[i].trendingTPT = trendingTPT;
            if(trendingTPTPercent != null || trendingTPTPercent != undefined) responseValue[i].trendingTPTPercent = trendingTPTPercent;
            salesPrevSummary = salesPrevSummary + responseValue[i].SalesDollarPrev;
            salesSummary = salesSummary + responseValue[i].salesdl;
            salesTrendingSummary = (salesSummary/salesPrevSummary)-1;
            volumePrevSummary = volumePrevSummary + responseValue[i].UnitsPrev;
            volumeSummary = volumeSummary + responseValue[i].units;
            volumeTrendingSummary = (volumeSummary/volumePrevSummary)-1;
            tptPrevSummary = tptPrevSummary + responseValue[i].TPTDollarPrev;
            tptSummary = tptSummary + responseValue[i].tptdollar;
            tptTrendingSummary = (tptSummary/tptPrevSummary)-1;
            tptPPrevSummary = (tptPrevSummary/salesPrevSummary)*100;
            tptPSummary = (tptSummary/salesSummary)*100;
            tptPTrendingSummary = (tptPSummary - tptPPrevSummary);
        }
        summaryObj.salesPrevSummary = salesPrevSummary;
        summaryObj.salesSummary = salesSummary;
        summaryObj.salesTrendingSummary = salesTrendingSummary;
        summaryObj.volumePrevSummary = volumePrevSummary;
        summaryObj.volumeSummary = volumeSummary;
        summaryObj.volumeTrendingSummary = volumeTrendingSummary;
        summaryObj.tptPrevSummary = tptPrevSummary;
        summaryObj.tptSummary = tptSummary;
        summaryObj.tptTrendingSummary = tptTrendingSummary;
        summaryObj.tptPPrevSummary = tptPPrevSummary;
        summaryObj.tptPSummary = tptPSummary;
        summaryObj.tptPTrendingSummary = tptPTrendingSummary;
        if(salesSummary > salesPrevSummary){
            component.set("v.classS", 'green');
        } else if(salesSummary < salesPrevSummary){
            component.set("v.classS", 'red');
        } else{
            component.set("v.classS", 'yellow');
        }
        if(volumeSummary > volumePrevSummary){
            component.set("v.classV", 'green');
        } else if(volumeSummary < volumePrevSummary){
            component.set("v.classV", 'red');
        } else{
            component.set("v.classV", 'yellow');
        }
        if(tptSummary > tptPrevSummary){
            component.set("v.classT", 'green');
        } else if(tptSummary < tptPrevSummary){
            component.set("v.classT", 'red');
        } else{
            component.set("v.classT", 'yellow');
        }
        if(tptPSummary > tptPPrevSummary){
            component.set("v.classP", 'green');
        } else if(tptPSummary < tptPPrevSummary){
            component.set("v.classP", 'red');
        } else{
            component.set("v.classP", 'yellow');
        }
        
        if(salesTrendingSummary < 0){
            component.set("v.isSalesLessThanZero", true);
        } else{
            component.set("v.isSalesLessThanZero", false);
        }
        if(volumeTrendingSummary < 0){
            component.set("v.isUnitsLessThanZero", true);
        } else{
            component.set("v.isUnitsLessThanZero", false);
		}
        if(tptTrendingSummary < 0){
            component.set("v.isTPTLessThanZero", true);
        } else{
            component.set("v.isTPTLessThanZero", false);
		}
        if(tptPTrendingSummary < 0){
            component.set("v.isTPTPercentLessThanZero", true);
        } else{
            component.set("v.isTPTPercentLessThanZero", false);
		}
        component.set("v.summaryObj", summaryObj);
        component.set("v.responseList",sortedResponse);
        if(sortedResponse.length > 10){
            component.set("v.showMoreButton", true);
        } else{
            component.set("v.showMoreButton", false);
        }
        component.set("v.countOfAccountsOwned", sortedResponse.length);
        var showTPT =component.get("v.showTPT");
        if(showTPT){
            var chartobj5 = component.get("v.chartobj6");
            var chartobj6 = component.get("v.chartobj5");
        }
        else{
            var chartobj1 = component.get("v.chartobj1");
            var chartobj2 = component.get("v.chartobj2");
            var chartobj3 = component.get("v.chartobj3");
            var chartobj4 = component.get("v.chartobj4");
        }
        var chartLabels = component.get("v.headersList");
         if(showTPT){
             var el5 = component.find('andeeChart5').getElement();
        	 var el6 = component.find('andeeChart6').getElement();
         }
        else{
            var el1 = component.find('andeeChart1').getElement();
        	var el2 = component.find('andeeChart2').getElement();
        	var el3 = component.find('andeeChart3').getElement();
       		var el4 = component.find('andeeChart4').getElement();  
        }
       if(showTPT){
           var ctx5 = el5.getContext('2d'); 
            var ctx6 = el6.getContext('2d'); 
       }
        else{
            var ctx1 = el1.getContext('2d'); 
            var ctx2 = el2.getContext('2d'); 
            var ctx3 = el3.getContext('2d'); 
            var ctx4 = el4.getContext('2d');
        }
        
        //if chartobj is not empty, then destory the chart in the view
        if(showTPT){
            if(chartobj5){
                chartobj5.destroy();
            }
            if(chartobj6){
                chartobj6.destroy();
            }
        }else{
            if(chartobj1){
                chartobj1.destroy();
            }
            if(chartobj2){
                chartobj2.destroy();
            }
            if(chartobj3){
                chartobj3.destroy();
            }
            if(chartobj4){
                chartobj4.destroy();
            }
        }
        var comparison = component.get("v.comparison");
        if(comparison == 'lastquartervspreviousquarter'){
            var QuarterLabelList = [];
            QuarterLabelList.push(component.get("v.headers.two")+'/'+component.get("v.headers.one"));
            component.set("v.QuarterLableList",QuarterLabelList );
             if(showTPT){
                   chartobj5 = new Chart(ctx6, {
                type: 'bar',
                data: {
                    labels: QuarterLabelList,
                    datasets: [
                        {
                            label: component.get("v.headers.two"),
                            backgroundColor:'rgba(237, 125, 49)',
                            borderColor: 'rgba(237, 125, 49)',
                            data: component.get("v.sumOfPrevSales"),
                        },
                       {
                            label: component.get("v.headers.one"),
                            backgroundColor: 'rgb(63, 37, 133)',
                            borderColor: 'rgb(63, 37, 133)',
                            data: component.get("v.sumOfRecentSales"),
                        }
                    ]
                },
                options: {
                    hover: {
                        mode: "none"
                    },
                    legend: {
                        labels:{
                            fontStyle: 'bold'
                        }
                    },
                    tooltips: {
                        callbacks: {
                            label: function(tooltipItems) {
                                let label = new Intl.NumberFormat('en-US', {
                                    style: 'currency',
                                    currency:"USD",
                                    minimumFractionDigits: 0,
                                    maximumFractionDigits: 0
                                }).format(tooltipItems.yLabel);
                                return label;
                            },
                        }
                    },
                    title: {
                        display: true,
                        text: 'Sales ($)',
                        fontSize: 14
                    },
                    scales: {
                        yAxes: [{
                            ticks: {
                                beginAtZero:true,
                                callback: function(value, index, values) {
                                    return value / 1e6 + 'M';
                                },
                                fontStyle: 'bold'
                            },
                            scaleLabel: {
                                display: true,
                                labelString: 'Sales ($)',
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
                }
            });
            chartobj6 = new Chart(ctx5, {
                type: 'bar',
                data: {
                    labels: QuarterLabelList,
                    //component.get("v.xAxisLabelsSummary"),
                    datasets: [
                        {
                            label: component.get("v.headers.two"),
                            backgroundColor: 'rgba(237, 125, 49)',
                            borderColor: 'rgba(237, 125, 49)',
                            data: component.get("v.sumOfPrevUnits")
                        },
                        {
                            label: component.get("v.headers.one"),
                            backgroundColor: 'rgb(63, 37, 133)',
                            borderColor: 'rgb(63, 37, 133)',
                            data: component.get("v.sumOfRecentUnits")
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
                    title: {
                        display: true,
                        text: 'Quantity (EU)',
                        fontSize: 14
                    },
                    scales: {
                        yAxes: [{
                            ticks: {
                                beginAtZero:true,
                                callback: function(value, index, values) {
                                    return value / 1e6 + 'M';
                                },
                                fontStyle: 'bold'
                            },
                            scaleLabel: {
                                display: true,
                                labelString: 'Quantity (EU)',
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
                }
            });
             }else{
            chartobj1 = new Chart(ctx2, {
                type: 'bar',
                data: {
                    labels: QuarterLabelList,
                    datasets: [
                        {
                            label: component.get("v.headers.two"),
                            backgroundColor:'rgba(237, 125, 49)',
                            borderColor: 'rgba(237, 125, 49)',
                            data: component.get("v.sumOfPrevSales"),
                        },
                       {
                            label: component.get("v.headers.one"),
                            backgroundColor: 'rgb(63, 37, 133)',
                            borderColor: 'rgb(63, 37, 133)',
                            data: component.get("v.sumOfRecentSales"),
                        }
                    ]
                },
                options: {
                    hover: {
                        mode: "none"
                    },
                    legend: {
                        labels:{
                            fontStyle: 'bold'
                        }
                    },
                    tooltips: {
                        callbacks: {
                            label: function(tooltipItems) {
                                let label = new Intl.NumberFormat('en-US', {
                                    style: 'currency',
                                    currency:"USD",
                                    minimumFractionDigits: 0,
                                    maximumFractionDigits: 0
                                }).format(tooltipItems.yLabel);
                                return label;
                            },
                        }
                    },
                    title: {
                        display: true,
                        text: 'Sales ($)',
                        fontSize: 14
                    },
                    scales: {
                        yAxes: [{
                            ticks: {
                                beginAtZero:true,
                                callback: function(value, index, values) {
                                    return value / 1e6 + 'M';
                                },
                                fontStyle: 'bold'
                            },
                            scaleLabel: {
                                display: true,
                                labelString: 'Sales ($)',
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
                }
            });
            chartobj2 = new Chart(ctx1, {
                type: 'bar',
                data: {
                    labels: QuarterLabelList,
                    //component.get("v.xAxisLabelsSummary"),
                    datasets: [
                        {
                            label: component.get("v.headers.two"),
                            backgroundColor: 'rgba(237, 125, 49)',
                            borderColor: 'rgba(237, 125, 49)',
                            data: component.get("v.sumOfPrevUnits")
                        },
                        {
                            label: component.get("v.headers.one"),
                            backgroundColor: 'rgb(63, 37, 133)',
                            borderColor: 'rgb(63, 37, 133)',
                            data: component.get("v.sumOfRecentUnits")
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
                    title: {
                        display: true,
                        text: 'Quantity (EU)',
                        fontSize: 14
                    },
                    scales: {
                        yAxes: [{
                            ticks: {
                                beginAtZero:true,
                                callback: function(value, index, values) {
                                    return value / 1e6 + 'M';
                                },
                                fontStyle: 'bold'
                            },
                            scaleLabel: {
                                display: true,
                                labelString: 'Quantity (EU)',
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
                }
            });
            chartobj3 = new Chart(ctx3, {
                type: 'bar',
                data: {
                    labels: QuarterLabelList,
                    //component.get("v.xAxisLabelsSummary"),    //[Sep, Oct]
                    datasets: [
                        {
                            label: component.get("v.headers.two"),
                            backgroundColor: 'rgba(237, 125, 49)',
                            borderColor: 'rgba(237, 125, 49)',
                            data: component.get("v.sumOfPrevTPTDl")   //[12, 13]
                        },
                        {
                            label: component.get("v.headers.one"),
                            backgroundColor: 'rgb(63, 37, 133)',
                            borderColor: 'rgb(63, 37, 133)',
                            data: component.get("v.sumOfRecentTPTDl")		  //[3lac5, 60]
                        }
                    ]
                },
                options: {
                    hover: {
                        mode: "none"
                    },
                    legend: {
                        labels:{
                            fontStyle: 'bold'   
                        }
                    },
                    title: {
                        display: true,
                        text: 'TPT ($)',
                        fontSize: 14
                    },
                    tooltips: {
                        callbacks: {
                            label: function(tooltipItems) {
                                let label = new Intl.NumberFormat('en-US', {
                                    style: 'currency',
                                    currency:"USD",
                                    minimumFractionDigits: 0,
                                    maximumFractionDigits: 0
                                }).format(tooltipItems.yLabel);
                                return label;
                            },
                        }
                    },
                    scales: {
                        yAxes: [{
                            ticks: {
                                beginAtZero:true,
                                callback: function(value, index, values) {
                                    return value / 1e6 + 'M';
                                },
                                fontStyle: 'bold'
                            },
                            scaleLabel: {
                                display: true,
                                labelString: 'TPT ($)',
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
                }
            });
            chartobj4 = new Chart(ctx4, {
                type: 'bar',
                data: {
                    labels: QuarterLabelList,
                    //component.get("v.xAxisLabelsSummary"),
                    datasets: [
                        {
                            label: component.get("v.headers.two"),
                            backgroundColor: 'rgba(237, 125, 49)',
                            borderColor: 'rgba(237, 125, 49)',
                            data: component.get("v.sumOfPrevTPTPerc")
                        },
                        {
                            label: component.get("v.headers.one"),
                            backgroundColor: 'rgb(63, 37, 133)',
                            borderColor: 'rgb(63, 37, 133)',
                            data: component.get("v.sumOfRecentTPTPerc")
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
                                    style: 'percent',
                                    minimumFractionDigits: 0,
                                    maximumFractionDigits: 2
                                }).format(tooltipItems.yLabel/100);
                                return label;
                            },
                        }
                    },
                    legend: {
                        labels:{
                            fontStyle: 'bold'
                        }
                    },
                    title: {
                        display: true,
                        text: 'TPT %',
                        fontSize: 14
                    },
                    scales: {
                        yAxes: [{
                            ticks: {
                                beginAtZero:true,
                                fontStyle: 'bold',
                                max: 100
                            },
                            scaleLabel: {
                                display: true,
                                labelString: 'TPT %',
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
                }
            });   
             }
        } 
        else{
            if(showTPT){
                chartobj5 = new Chart(ctx6, {
                type: 'line',
                data: {
                    labels: component.get("v.xAxisLabelsSummary"),
                    //plugins:  [pluginTrendlineLinear],
                    datasets: [
                        {
                            label: component.get("v.headers.two"),
                            borderColor: 'rgba(237, 125, 49)',
                            backgroundColor:'rgba(237, 125, 49)',
                            fill: false,
                            data: component.get("v.salesdlPrevSummary") ,
                        },
                        {
                            label: component.get("v.headers.one"),
                            backgroundColor:'rgba(63, 37, 133)',
                            borderColor: 'rgb(63, 37, 133)',        
                            fill: false,
                            data: component.get("v.salesdlSummary"),
                        }
                    ]
                },
                options: {
                    hover: {
                        mode: "none"
                    },
                    legend: {
                        labels:{
                            fontStyle: 'bold'
                        }
                    },
                    tooltips: {
                        callbacks: {
                            label: function(tooltipItems) {
                                let label = new Intl.NumberFormat('en-US', {
                                    style: 'currency',
                                    currency:"USD",
                                    minimumFractionDigits: 0,
                                    maximumFractionDigits: 0
                                }).format(tooltipItems.yLabel);
                                return label;
                            },
                        }
                    },
                    title: {
                        display: true,
                        text: 'Sales ($)',
                        fontSize: 14
                    },
                    scales: {
                        yAxes: [{
                            ticks: {
                                beginAtZero:true,
                                callback: function(value, index, values) {
                                    return value / 1e6 + 'M';
                                },
                                fontStyle: 'bold'
                            },
                            scaleLabel: {
                                display: true,
                                labelString: 'Sales ($)',
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
            chartobj6 = new Chart(ctx5, {
                type: 'line',
                data: {
                    labels: component.get("v.xAxisLabelsSummary"),
                    datasets: [
                        {
                            label: component.get("v.headers.two"),
                            borderColor: 'rgba(237, 125, 49)',  
                            backgroundColor:'rgba(237, 125, 49)',
                            fill: false,
                            data: component.get("v.unitsPrevSummary")
                        },
                        {
                            label: component.get("v.headers.one"),
                            backgroundColor:'rgba(63, 37, 133)',
                            borderColor: 'rgba(63, 37, 133)', 
                            fill: false,
                            data: component.get("v.unitsSummary")
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
                    title: {
                        display: true,
                        text: 'Quantity (EU)',
                        fontSize: 14
                    },
                    scales: {
                        yAxes: [{
                            ticks: {
                                beginAtZero:true,
                                callback: function(value, index, values) {
                                    return value / 1e6 + 'M';
                                },
                                fontStyle: 'bold'
                            },
                            scaleLabel: {
                                display: true,
                                labelString: 'Quantity (EU)',
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
                }
            });
                
            }else{
            chartobj1 = new Chart(ctx2, {
                type: 'line',
                data: {
                    labels: component.get("v.xAxisLabelsSummary"),
                    //plugins:  [pluginTrendlineLinear],
                    datasets: [
                        {
                            label: component.get("v.headers.two"),
                            borderColor: 'rgba(237, 125, 49)',
                            backgroundColor:'rgba(237, 125, 49)',
                            fill: false,
                            data: component.get("v.salesdlPrevSummary") , 
                        },
                        {
                            label: component.get("v.headers.one"),
                            backgroundColor:'rgba(63, 37, 133)',
                            borderColor: 'rgb(63, 37, 133)',        
                            fill: false,
                            data: component.get("v.salesdlSummary"),
                        }
                    ]
                },
                options: {
                    hover: {
                        mode: "none"
                    },
                    legend: {
                        labels:{
                            fontStyle: 'bold'
                        }
                    },
                    tooltips: {
                        callbacks: {
                            label: function(tooltipItems) {
                                let label = new Intl.NumberFormat('en-US', {
                                    style: 'currency',
                                    currency:"USD",
                                    minimumFractionDigits: 0,
                                    maximumFractionDigits: 0
                                }).format(tooltipItems.yLabel);
                                return label;
                            },
                        }
                    },
                    title: {
                        display: true,
                        text: 'Sales ($)',
                        fontSize: 14
                    },
                    scales: {
                        yAxes: [{
                            ticks: {
                                beginAtZero:true,
                                callback: function(value, index, values) {
                                    return value / 1e6 + 'M';
                                },
                                fontStyle: 'bold'
                            },
                            scaleLabel: {
                                display: true,
                                labelString: 'Sales ($)',
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
            chartobj2 = new Chart(ctx1, {
                type: 'line',
                data: {
                    labels: component.get("v.xAxisLabelsSummary"),
                    datasets: [
                        {
                            label: component.get("v.headers.two"),
                            borderColor: 'rgba(237, 125, 49)',  
                            backgroundColor:'rgba(237, 125, 49)',
                            fill: false,
                            data: component.get("v.unitsPrevSummary")
                        },
                        {
                            label: component.get("v.headers.one"),
                            backgroundColor:'rgba(63, 37, 133)',
                            borderColor: 'rgba(63, 37, 133)', 
                            fill: false,
                            data: component.get("v.unitsSummary")
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
                    title: {
                        display: true,
                        text: 'Quantity (EU)',
                        fontSize: 14
                    },
                    scales: {
                        yAxes: [{
                            ticks: {
                                beginAtZero:true,
                                callback: function(value, index, values) {
                                    return value / 1e6 + 'M';
                                },
                                fontStyle: 'bold'
                            },
                            scaleLabel: {
                                display: true,
                                labelString: 'Quantity (EU)',
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
                }
            });
            chartobj3 = new Chart(ctx3, {
                type: 'line',
                data: {
                    labels: component.get("v.xAxisLabelsSummary"),    //[Sep, Oct]
                    datasets: [
                        {
                            label: component.get("v.headers.two"),
                            backgroundColor:'rgba(237, 125, 49)',
                            borderColor: 'rgba(237, 125, 49)',                 
                            fill: false,
                            data: component.get("v.tptPrevSummary")   //[12, 13]
                        },
                        {
                            label: component.get("v.headers.one"),
                            backgroundColor:'rgba(63, 37, 133)',
                            borderColor: 'rgba(63, 37, 133)',
                            fill: false,
                            data: component.get("v.tptSummary")		  //[3lac5, 60]
                        }
                    ]
                },
                options: {
                    hover: {
                        mode: "none"
                    },
                    legend: {
                        labels:{
                            fontStyle: 'bold'   
                        }
                    },
                    title: {
                        display: true,
                        text: 'TPT ($)',
                        fontSize: 14
                    },
                    tooltips: {
                        callbacks: {
                            label: function(tooltipItems) {
                                let label = new Intl.NumberFormat('en-US', {
                                    style: 'currency',
                                    currency:"USD",
                                    minimumFractionDigits: 0,
                                    maximumFractionDigits: 0
                                }).format(tooltipItems.yLabel);
                                return label;
                            },
                        }
                    },
                    scales: {
                        yAxes: [{
                            ticks: {
                                beginAtZero:true,
                                callback: function(value, index, values) {
                                    return value / 1e6 + 'M';
                                },
                                fontStyle: 'bold'
                            },
                            scaleLabel: {
                                display: true,
                                labelString: 'TPT ($)',
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
                }
            });
            chartobj4 = new Chart(ctx4, {
                type: 'line',
                data: {
                    labels: component.get("v.xAxisLabelsSummary"),
                    datasets: [
                        {
                            label: component.get("v.headers.two"),
                            backgroundColor:'rgba(237, 125, 49)',
                            borderColor: 'rgba(237, 125, 49)',          
                            fill: false,
                            data: component.get("v.tptPercentPrevSummary")
                        },
                        {
                            label: component.get("v.headers.one"),
                            backgroundColor:'rgba(63, 37, 133)',
                            borderColor: 'rgba(63, 37, 133)',   
                            fill: false,
                            data: component.get("v.tptPercentSummary")
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
                                    style: 'percent',
                                    minimumFractionDigits: 0,
                                    maximumFractionDigits: 2
                                }).format(tooltipItems.yLabel/100);
                                return label;
                            },
                        }
                    },
                    legend: {
                        labels:{
                            fontStyle: 'bold'
                        }
                    },
                    title: {
                        display: true,
                        text: 'TPT %',
                        fontSize: 14
                    },
                    scales: {
                        yAxes: [{
                            ticks: {
                                beginAtZero:true,
                                fontStyle: 'bold'
                            },
                            scaleLabel: {
                                display: true,
                                labelString: 'TPT %',
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
                }
            });
            }
        }
        if(showTPT){
            component.set("v.chartobj5",chartobj5);
            component.set("v.chartobj6",chartobj6);
        }else{
            component.set("v.chartobj1",chartobj1);
            component.set("v.chartobj2",chartobj2);
            component.set("v.chartobj3",chartobj3);
            component.set("v.chartobj4",chartobj4);
        }
        helper.getChartData(component, event, helper); 
    },
    
    getChartData: function(component, event, helper){
        component.set('v.loaded', true);
        var selectedComparison = component.get("v.comparison");
        var action;
        if(selectedComparison == 'last12monthsvsprevious12months'){
            action = component.get("c.getLasttwmonthsVsPrevtwmonthsData");
        } else if(selectedComparison == 'lastquartervspreviousquarter'){
            action = component.get("c.getLastQuarterVsPrevQuarterData");
            console.log('selections :: '+component.get("v.selections"));
            console.log('selectedComparison :: '+component.get("v.comparison"));
            console.log('customerId :: '+component.get("v.accId"));
            console.log('Families in Quarterly:: '+component.get("v.productFamilies"));
        } else if(selectedComparison == 'fytdvspreviousfytd'){
            action = component.get("c.getfytdData");
            console.log('Families in FYTD:: '+component.get("v.productFamilies"));
        }
        console.log('Families: '+component.get("v.productFamilies"));
        action.setParams({
            selections: component.get("v.selections"),
            selectedComparison: component.get("v.comparison"),
            customerId: component.get("v.accId"),
            productFamilies: component.get("v.productFamilies")
        });
        action.setCallback(this, function(response) 
                           {
                               if(response.getState()=="SUCCESS"){
                                   var response= response.getReturnValue();
                                   console.log('selections :: '+component.get("v.selections"));
                                   console.log('selectedComparison :: '+component.get("v.comparison"));
                                   console.log('customerId :: '+component.get("v.accId"));
                                   console.log('Families in Quarterly:: '+component.get("v.productFamilies"));
                                   component.set("v.allAccountsChartData", response.AllAccountsData);
                                   console.log('Sales Records:::ChartData '+JSON.stringify(response));
                                   component.set("v.loaded", false);
                               } else{
                                   component.set("v.loaded", false);
                                   console.log("Error "+JSON.stringify(response.getError()));
                               }
                           });
        $A.enqueueAction(action); 
    },
    
    convertArrayOfObjectsToCSV: function (component, objectRecords,showTPTValue, reportName) {
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
        myMap.set("Product Family", "pfamily");
        myMap.set(component.get('v.headers.two')+' '+'(Quantity (EU))', "UnitsPrev");
        myMap.set(component.get('v.headers.one')+' '+'(Quantity (EU))', "units");
        myMap.set("Trending"+' '+'(Quantity (EU))', "trendingVolume");
        myMap.set(component.get('v.headers.two')+' '+'(Sales ($))', "SalesDollarPrev");      
        myMap.set(component.get('v.headers.one')+' '+'(Sales ($))', "salesdl");
        myMap.set('Trending'+' '+'(Sales ($))', "trendingSales");
        if(!showTPTValue){
        myMap.set(component.get('v.headers.two')+' '+'(TPT ($)))', "TPTDollarPrev");
        myMap.set(component.get('v.headers.one')+' '+'(TPT ($))', "tptdollar");
        myMap.set("Trending"+' '+'(TPT ($))', "trendingTPT");
        myMap.set(component.get('v.headers.two')+' '+'(TPT %)', "TPTPctPrev");
        myMap.set(component.get('v.headers.one')+' '+'(TPT %)', "tptpct");
        myMap.set("Trending"+' '+'(TPT %)', "trendingTPTPercent");
        }
        csvStringResult += Array.from(myMap.keys()).join(columnDivider);
        csvStringResult += lineDivider;
        
        
        for (var i = 0; i < objectRecords.length; i++) {
            counter = 0;
            for (let [key, value] of myMap) {
                if (counter > 0) {
                    csvStringResult += columnDivider;
                }
                if(value == 'trendingSales'){
                    var trending_Sales=objectRecords[i]['trendingSales'];
                    if(trending_Sales != null){
                        var sales_rounded_le=((trending_Sales) * 100).toFixed(2);
                        csvStringResult += '"'+ sales_rounded_le +'"';
                    }
                    else{
                        csvStringResult += '"'+''+'"';
                        
                    }
                }
                else if(value == 'trendingVolume'){
                    var trending_volume=objectRecords[i]['trendingVolume'];
                    if(trending_volume != null){
                        var volume_rounded_le=((trending_volume) * 100).toFixed(2);
                        csvStringResult += '"'+ volume_rounded_le +'"';
                    }
                    else{
                        csvStringResult += '"'+''+'"';
                        
                    }
                }
                    else if(value == 'trendingTPT'){
                        var trending_TPT=objectRecords[i]['trendingTPT'];
                        if(trending_TPT != null){
                            var tpt_rounded_le=((trending_TPT) * 100).toFixed(2);
                            csvStringResult += '"'+ tpt_rounded_le +'"';
                        }
                        else{
                            csvStringResult += '"'+''+'"';
                            
                        }
                    }
                 else if(value == 'trendingTPTPercent'){
                    var trending_TPTPer=objectRecords[i]['trendingTPTPercent'];
                    if(trending_TPTPer != null){
                        var sales_rounded_le=((trending_TPTPer)).toFixed(2);
                        csvStringResult += '"'+ sales_rounded_le +'"';
                    }
                    else{
                        csvStringResult += '"'+''+'"';
                        
                    }
                }
                        else  if (objectRecords[i][value] == undefined) {
                            csvStringResult += '"' + '' + '"';
                        } else {
                            csvStringResult += '"' + objectRecords[i][value] + '"';
                        }
                
                counter++;
            }
            csvStringResult += lineDivider;
        }   
        
        return csvStringResult;
    },
    sortBy: function(component, field, helper) {
        var sortAsc = component.get("v.isAsc"),
            sortField = component.get("v.sortField"),
            records = component.get("v.responseList");
        console.log('records-->'+JSON.stringify(records))
        sortAsc = field == sortField? !sortAsc: true;
        records.sort(function(a,b){
            var t1 = a[field] == b[field],
                t2 = (!a[field] && b[field]) || (a[field] < b[field]);
            return t1? 0: (sortAsc?-1:1)*(t2?1:-1);
        });
        component.set("v.isAsc", sortAsc);
        component.set("v.responseList", records);
        component.set('v.loaded', false);
        component.set("v.customerId", null);
        component.set("v.productFamilies", []);
        component.set("v.allProductFamilies", []);
        var productFamilies = component.get("v.productFamilies");
        if(records.length >= 10){
            for(var i=0; i<10; i++){
                console.log(':::::: '+records[i].pfamily);
                if(!productFamilies.includes(records[i].pfamily)){
                    productFamilies.push(records[i].pfamily);
                } 
            }   
        } else{
            for(var i=0; i<records.length; i++){
                if(!productFamilies.includes(records[i].pfamily)){
                    productFamilies.push(records[i].pfamily);
                }  
            }                
        }
        var allProductFamilies = component.get("v.allProductFamilies");
        console.log('1 OK');
        for(var i=0; i<records.length; i++){
            if(!allProductFamilies.includes(records[i].pfamily)){
                allProductFamilies.push(records[i].pfamily);
            }
        }
        component.set("v.productFamilies", productFamilies);
        console.log('drlSales Ids length::: '+productFamilies.length);
        component.set("v.allProductFamilies", allProductFamilies);
        if(records.length > 10){
            component.set("v.showMoreButton", true);
        } else{
            component.set("v.showMoreButton", false);
        }
        this.getChartData(component, event, helper);
    }
})