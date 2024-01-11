({
    
    initCharts : function(component, event, helper) {
        console.log('scriptsLoaded');
        component.set("v.isExportJSLoaded",true);
        component.set("v.needToProcessReRenderLogic",true);
        var getBidInfoAction = component.get("c.getGraphData");
        getBidInfoAction.setParams({
            customerId :component.get("v.recordId"),
            ndcCode :component.get("v.graphProductCode"),
            soldtocustCode:component.get("v.graphSoldToCust"),
            type:component.get("v.type")            
        });
        getBidInfoAction.setCallback(this, function (response) {
            var actState = response.getState();
            console.log('actState-----'+actState);
            if (actState == 'SUCCESS') {
                console.log('res====='+JSON.stringify(response.getReturnValue()));
                let val = response.getReturnValue().orderComplianceData;
                var labelset=[] ;
                var dataset=[] ;
                var obj = {};
                var highChartData = []; 
                var highChartCategories = [];
                // val.forEach(function(key) {
                //highChartCategories.push((val.Month1__c).toString()) ; 
                // highChartCategories.push((val.Month2__c).toString()) ; 
                //  highChartCategories.push((val.Month3__c).toString()) ; 
                //highChartCategories.push((val.Month4__c).toString()) ; 
                //highChartCategories.push((val.Month5__c).toString()) ; 
                //  labelset.push(key.Month6__c) ; 
                /// dataset.push((val.M2_Quantity__c).toString()) ; 
                // dataset.push((val.M3_Quantity__c).toString()) ; 
                // dataset.push((val.M4_Quantity__c).toString()) ; 
                //  dataset.push((val.M5_Quantity__c).toString()) ; 
                /*obj.name = val.Month2__c;
                obj.color = '#800080';
                obj.data = [val.M2_Quantity__c];
                 highChartData.push(obj);
                  obj.name = val.Month3__c;
                obj.color = '#800080';
                obj.data = [val.M3_Quantity__c];*/
                highChartData.push(obj);
                console.log('highChartCategories====='+JSON.stringify(highChartCategories));
                console.log('threeMonthsAvg====='+response.getReturnValue().threeMonthsAvg);
                console.log('sixMonthsAvg====='+response.getReturnValue().sixMonthsAvg);
                var threeMonthsAvg = response.getReturnValue().threeMonthsAvg;
                var sixMonthsAvg = response.getReturnValue().sixMonthsAvg;
                var twelveMonthsAvg = response.getReturnValue().twelveMonthsAvg;
                
                
                // });
                if(component.get("v.selectedId") == '12Month'){
                new Highcharts.Chart({
                    chart: {
                        
                        renderTo: component.find("chart").getElement(),
                        zoomType: 'xy',
                        height: '500px' // 16:9 ratio
                    },
                    title: {
                        text: '12 Months Order Compliance Analysis of '+response.getReturnValue().custName+' for '+response.getReturnValue().orderProdName,
                    },
                    
                    xAxis: [{
                        categories: response.getReturnValue().categories,
                        title: {
                            text: 'Order Month',
                            textAlign: 'center',
                            style: {
                                fontWeight: 'bold'
                            }
                        },
                        crosshair: true
                    }],
                    yAxis: [{ // Primary yAxis
                        /* labels: {
            format: '{value}°C',
            style: {
                color: Highcharts.getOptions().colors[1]
            }
        },*/
                        
                        title: {
                            text: 'Compliance %',
                            style: {
                                color: 'black',
                                fontWeight: 'bold'
                            }
                        },
                        
                    },
                            { // Secondary yAxis
                                title: {
                                    text: 'Order Quantity',
                                    style: {
                                        color: 'black',
                                        fontWeight: 'bold'
                                        
                                    }
                                },
                                /* labels: {
            format: '{value} mm',
            style: {
                color: Highcharts.getOptions().colors[0]
            }
        },*/
                plotLines: [
                    {
                        color: '#33CAFF',
                        value: response.getReturnValue().threeMonthsAvg,
                        width: '1',
                        dashStyle: 'shortdash',
                        zIndex: 4
                    },
                    {
                        color: 'orange',
                        value: response.getReturnValue().sixMonthsAvg,
                        width: '1',
                        dashStyle: 'shortdash',
                        zIndex: 4
                        
                    },
                    {
                        color: 'green',
                        value: response.getReturnValue().twelveMonthsAvg,
                        width: '1',
                        dashStyle: 'shortdash',
                        zIndex: 4
                    }],
                
                opposite: true
            }],
                    tooltip: {
                        shared: true
                    },
                    plotOptions: {
                        bar: {
                            dataLabels: {
                                enabled: true
                            }
                        }
                    },                
                    legend: {
                        layout: 'horizontal',
                        align: 'right',
                        verticalAlign: 'bottom',
                        //x: -40,
                       // y: 100,
                       // floating: true,
                       // borderWidth: 1,
                        backgroundColor: ((Highcharts.theme && Highcharts.theme.legendBackgroundColor) || '#FFFFFF'),
                        shadow: true,
                         
                    },
                    series: [
                         {
                            name: 'Order Quantity',
                            type: 'column',
                            color:'#6f30a0',
                            yAxis: 1,
                            data: response.getReturnValue().dataSet,
                            
                            
                        },
                        {
                            name: 'Compliance',
                            type: 'spline',
                            width: '0.25',
                            color:'black',
                            data: response.getReturnValue().compliancePercentDataSet,
                            tooltip: {
                                valueSuffix: '%'
                            }
                        },
                       
                     {
                            name: 'Avg of 3 Months Order Quantity',
                         color: '#33CAFF'
                            
                        },
                    {
                            name: 'Avg of 6 Months Order Quantity',
                         color: 'orange'
                            
                        },{
                            name: 'Avg of 12 Months Order Quantity',
                         color: 'green'
                            
                        }]
                });    
                }
               if(component.get("v.selectedId") == '3Month'){
                new Highcharts.Chart({
                    chart: {
                        
                        renderTo: component.find("chart").getElement(),
                        zoomType: 'xy',
                        height: '500px' // 16:9 ratio
                    },
                    title: {
                        text: '3 Months Order Compliance Analysis of '+response.getReturnValue().custName+' for '+response.getReturnValue().orderProdName,
                    },
                    
                    xAxis: [{
                        categories: response.getReturnValue().categories3,
                        title: {
                            text: 'Order Month',
                            textAlign: 'center',
                            style: {
                                fontWeight: 'bold'
                            }
                        },
                        crosshair: true
                    }],
                    yAxis: [{ // Primary yAxis
                        /* labels: {
            format: '{value}°C',
            style: {
                color: Highcharts.getOptions().colors[1]
            }
        },*/
                        
                        title: {
                            text: 'Compliance %',
                            style: {
                                color: 'black',
                                fontWeight: 'bold'
                            }
                        },
                        
                    },
                            { // Secondary yAxis
                                title: {
                                    text: 'Order Quantity',
                                    style: {
                                        color: 'black',
                                        fontWeight: 'bold'
                                        
                                    }
                                },
                                /* labels: {
            format: '{value} mm',
            style: {
                color: Highcharts.getOptions().colors[0]
            }
        },*/
                plotLines: [
                    {
                        color: '#33CAFF',
                        value: response.getReturnValue().threeMonthsAvg,
                        width: '1',
                        dashStyle: 'shortdash',
                        zIndex: 4
                    }
                   ],
                
                opposite: true
            }],
                    tooltip: {
                        shared: true
                    },
                    plotOptions: {
                        bar: {
                            dataLabels: {
                                enabled: true
                            }
                        }
                    },                
                    legend: {
                        layout: 'horizontal',
                        align: 'right',
                        verticalAlign: 'bottom',
                        //x: -40,
                       // y: 100,
                       // floating: true,
                       // borderWidth: 1,
                        backgroundColor: ((Highcharts.theme && Highcharts.theme.legendBackgroundColor) || '#FFFFFF'),
                        shadow: true,
                         
                    },
                    series: [
                         {
                            name: 'Order Quantity',
                            type: 'column',
                            color:'#6f30a0',
                            yAxis: 1,
                            data: response.getReturnValue().dataSet3,
                            
                            
                        },
                        {
                            name: 'Compliance',
                            type: 'spline',
                            width: '0.25',
                            color:'black',
                            data: response.getReturnValue().compliancePercentDataSet3,
                            tooltip: {
                                valueSuffix: '%'
                            }
                        },
                       
                     {
                            name: 'Avg of 3 Months Order Quantity',
                         color: '#33CAFF'
                            
                        },
                   ]
                });    
                }
              if(component.get("v.selectedId") == '6Month'){
                new Highcharts.Chart({
                    chart: {
                        
                        renderTo: component.find("chart").getElement(),
                        zoomType: 'xy',
                        height: '500px' // 16:9 ratio
                    },
                    title: {
                        text: '6 Months Order Compliance Analysis of '+response.getReturnValue().custName+' for '+response.getReturnValue().orderProdName,
                    },
                    
                    xAxis: [{
                        categories: response.getReturnValue().categories6,
                        title: {
                            text: 'Order Month',
                            textAlign: 'center',
                            style: {
                                fontWeight: 'bold'
                            }
                        },
                        crosshair: true
                    }],
                    yAxis: [{ // Primary yAxis
                        /* labels: {
            format: '{value}°C',
            style: {
                color: Highcharts.getOptions().colors[1]
            }
        },*/
                        
                        title: {
                            text: 'Compliance %',
                            style: {
                                color: 'black',
                                fontWeight: 'bold'
                            }
                        },
                        
                    },
                            { // Secondary yAxis
                                title: {
                                    text: 'Order Quantity',
                                    style: {
                                        color: 'black',
                                        fontWeight: 'bold'
                                        
                                    }
                                },
                                /* labels: {
            format: '{value} mm',
            style: {
                color: Highcharts.getOptions().colors[0]
            }
        },*/
                plotLines: [
                  {
                        color: '#33CAFF',
                        value: response.getReturnValue().threeMonthsAvg,
                        width: '1',
                        dashStyle: 'shortdash',
                        zIndex: 4
                    }, 
                    {
                        color: 'orange',
                        value: response.getReturnValue().sixMonthsAvg,
                        width: '1',
                        dashStyle: 'shortdash',
                        zIndex: 4
                        
                    }],
                
                opposite: true
            }],
                    tooltip: {
                        shared: true
                    },
                    plotOptions: {
                        bar: {
                            dataLabels: {
                                enabled: true
                            }
                        }
                    },                
                    legend: {
                        layout: 'horizontal',
                        align: 'right',
                        verticalAlign: 'bottom',
                        //x: -40,
                       // y: 100,
                       // floating: true,
                       // borderWidth: 1,
                        backgroundColor: ((Highcharts.theme && Highcharts.theme.legendBackgroundColor) || '#FFFFFF'),
                        shadow: true,
                         
                    },
                    series: [
                         {
                            name: 'Order Quantity',
                            type: 'column',
                            color:'#6f30a0',
                            yAxis: 1,
                            data: response.getReturnValue().dataSet6,
                            
                            
                        },
                        {
                            name: 'Compliance',
                            type: 'spline',
                            width: '0.25',
                            color:'black',
                            data: response.getReturnValue().compliancePercentDataSet6,
                            tooltip: {
                                valueSuffix: '%'
                            }
                        },
                       
                    {
                            name: 'Avg of 3 Months Order Quantity',
                         color: '#33CAFF'
                            
                        },
                    {
                            name: 'Avg of 6 Months Order Quantity',
                         color: 'orange'
                            
                        }]
                });    
                }  
            }
            else{
                
                console.log('error---'+JSON.stringify(response.getError()));
            }
            
        });
        
        $A.enqueueAction(getBidInfoAction);
        
        
    }
})