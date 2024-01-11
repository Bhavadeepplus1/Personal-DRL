({
    Filter12Mts: function(component, event, helper) {
        $("#linechart").hide();
        $("#linechart2").show();
        console.log('-----4-------');
        component.set('v.isSpinnerLoad',true);
        var bidhist=component.get("v.displayHistPricing");
        component.set("v.displayHistPricing",true);
        var LineItemtable = component.get("v.tableRef");
        $A.util.removeClass(LineItemtable, "maintable");
        var rowIndex = component.get("v.bidLineItemId");
        var recId=component.get("v.recordId");
        var LastNMonths=component.find("lastMonths").get("v.value");
        if(LastNMonths=='Last 12 Months'){
            LastNMonths='12' ;
        }
        else{
            LastNMonths='24' ; 
        }
        var action = component.get("c.getHistoricalPricing");
        action.setParams({
            'LineItemId' : rowIndex,
            'recordId':recId,
            'LastMonths':LastNMonths
        });
        action.setCallback(this, function(response) {
            component.set("v.prodId",response.getReturnValue()[0].prodId);
            component.set("v.pricingHistList",response.getReturnValue());
            component.set("v.prodName",response.getReturnValue()[0].prodName);
            component.set("v.accId",response.getReturnValue()[0].accId);
            component.set("v.accName",response.getReturnValue()[0].accName);
            component.set("v.ndc",response.getReturnValue()[0].ndc);
            component.set("v.bucketCust",response.getReturnValue()[0].bucketCust);
                        console.log('---------response.getReturnValue()-------'+JSON.stringify(response.getReturnValue()));

            var ctx = component.find("linechart2").getElement();
            var model= component.get("v.pricingHistList");
            component.set('v.isSpinnerLoad',false);
            var chart=new Chart(ctx, {
                type: 'bar',
                data: {
                    labels:Object.keys(model[0].nprSnapAll),
                    datasets: [{
                        label: "Current Customer",
                        data: Object.values(model[0].nprSnapCurrent),
                        lineTension: 0,
                        fill: false,
                           pointRadius: 5,
                         pointHoverRadius: 5,
                        type: "line",
                        yAxisID: "y-axis-gravity",
                        xAxisID: "months",
                        borderColor: '#003153',
                        backgroundColor: '#003153'
                    },
                               {
                                   label: "Across All Customers",
                                   data: Object.values(model[0].nprSnapAll),
                                   lineTension: 0,
                                   fill: false,
                                   type: "line",
                                     pointRadius: 5,
                                    pointHoverRadius: 5,
                                   yAxisID: "y-axis-gravity",
                                   xAxisID: "months",
                                    borderColor: '#70AD47',
                                   backgroundColor: '#70AD47'
                               },
                               {
                                   label: "Bucket Customer",
                                   data: Object.values(model[0].nprSnapBucket),
                                   lineTension: 0,
                                   fill: false,
                                   type: "line",
                                     pointRadius: 5,
                                    pointHoverRadius: 5,
                                   yAxisID: "y-axis-gravity",
                                   xAxisID: "months",
                                   borderColor: '#a00000',
                                   backgroundColor: '#a00000'
                               },
                               {
                                   label: "Volume",
                                   data: Object.values(model[0].nprVolMap),
                                   barThickness:1,
                                   lineTension: 0,
                                   borderColor:"#DDEBF7",
                                   backgroundColor:"#DDEBF7",
                                   fill: false,
                                   barPercentage: 0.05,
                                   pointBackgroundColor: "blue",
                                   yAxisID: "y-axis-density",
                                   xAxisID: "months",
                                   type: "bar",
                               }
                              ]
                },
                options: {
                    title: {
                        display: true,
                    },
                    legend: { display: true },
                    responsive: true,
                    scales: {
                        xAxes: [{
                            id: "months",
                            scaleLabel: {
                                display: true,
                                labelString: "Month",
                                fontStyle: 'bold',
                                fontColor: '#2c2c2c'
                            },
                            ticks: {
                                fontColor: '#2c2c2c', // X-Axis font color
                                fontStyle: 'bold',    // X-Axis font style 
                            },
                        }],
                        yAxes: [{
                            id: "y-axis-density",
                            scaleLabel: {
                                display: true,
                                labelString: "Volume",
                                fontStyle: 'bold',
                                fontColor: '#2c2c2c'
                            },
                            ticks: {
                                fontColor: '#2c2c2c', // X-Axis font color
                                fontStyle: 'bold',    // X-Axis font style 
                            },
                            position: 'right'
                        }, {
                            id: "y-axis-gravity",
                            scaleLabel: {
                                display: true,
                                labelString: "Price ($)",
                                fontStyle: 'bold',
                                fontColor: '#2c2c2c'
                            },
                            ticks: {
                                fontColor: '#2c2c2c', // X-Axis font color
                                fontStyle: 'bold',    // X-Axis font style 
                            },
                        }]
                    }
                },
                tooltips: {
                    callbacks: {
                        label: function(tooltipItem, data) {
                            var dataset = data.datasets[tooltipItem.datasetIndex];
                            var index = tooltipItem.index;
                            return dataset.labels[index] + ': ' + dataset.data[index];
                        }
                    }
                }
            });
        });
        $A.enqueueAction(action);
    },
    
    Filter24Mts: function(component, event, helper) {
        $("#linechart2").hide();
        $("#linechart").show();
        var bidhist=component.get("v.displayHistPricing");
        component.set("v.displayHistPricing",true);
        var LineItemtable = component.get("v.tableRef");
        $A.util.removeClass(LineItemtable, "maintable");
        var rowIndex = component.get("v.bidLineItemId");
        var recId=component.get("v.recordId");
        var LastNMonths=component.find("lastMonths").get("v.value");
        if(LastNMonths=='Last 12 Months'){
            LastNMonths='12' ;
        }
        else{
            LastNMonths='24' ; 
        }
        var action = component.get("c.getHistoricalPricing");
        action.setParams({
            'LineItemId' : rowIndex,
            'recordId':recId,
            'LastMonths':LastNMonths
        });
        action.setCallback(this, function(response) {
            component.set("v.prodId",response.getReturnValue()[0].prodId);
            component.set("v.pricingHistList",response.getReturnValue());
            component.set("v.prodName",response.getReturnValue()[0].prodName);
            component.set("v.accId",response.getReturnValue()[0].accId);
            component.set("v.accName",response.getReturnValue()[0].accName);
            component.set("v.ndc",response.getReturnValue()[0].ndc);
            component.set("v.bucketCust",response.getReturnValue()[0].bucketCust);
                        console.log('---------response.getReturnValue()-------'+JSON.stringify(response.getReturnValue()));

            var ctx = component.find("linechart").getElement();
            var model= component.get("v.pricingHistList");
            var chart= new Chart(ctx, {
                type: 'bar',
                data: {
                    labels:Object.keys(model[0].nprSnapAll),
                    datasets: [{
                        label: "Current Customer",
                        data: Object.values(model[0].nprSnapCurrent),
                        lineTension: 0,
                        fill: false,
                        type: "line",
                        yAxisID: "y-axis-gravity",
                        xAxisID: "months",
                        borderColor: '#003153',
                         pointRadius: 5,
                         pointHoverRadius: 5,
                        backgroundColor: '#003153'
                    },
                               {
                                   label: "Across All Customers",
                                   data: Object.values(model[0].nprSnapAll),
                                   lineTension: 0,
                                   fill: false,
                                   type: "line",
                                   pointRadius: 5,
                                    pointHoverRadius: 5,
                                   yAxisID: "y-axis-gravity",
                                   xAxisID: "months",
                                  borderColor: '#70AD47',
                                   backgroundColor: '#70AD47'
                               },
                               {
                                   label: "Bucket Customer",
                                   data: Object.values(model[0].nprSnapBucket),
                                   lineTension: 0,
                                   fill: false,
                                   type: "line",
                                   yAxisID: "y-axis-gravity",
                                   xAxisID: "months",
                                   pointRadius: 5,
                                    pointHoverRadius: 5,
                                   borderColor: '#a00000',
                                   backgroundColor: '#a00000'
                               },
                               {
                                   label: "Volume",
                                   data: Object.values(model[0].nprVolMap),
                                   lineTension: 0,
                                   borderColor:"#DDEBF7",
                                   backgroundColor:"#DDEBF7",
                                   fill: false,
                                   barPercentage: 0.1,
                                   pointBackgroundColor: "blue",
                                   yAxisID: "y-axis-density",
                                   xAxisID: "months",
                                   type: "bar",
                               }
                              ]
                },
                options: {
                    title: {
                        display: true,
                    },
                    legend: { 
                        display: true
                    },
                    responsive: true,
                    scales: {
                        xAxes: [{
                            id: "months",
                            scaleLabel: {
                                display: true,
                                labelString: "Month",
                                fontStyle: 'bold',
                                fontColor: '#2c2c2c'
                            },
                            ticks: {
                                fontColor: '#2c2c2c', // X-Axis font color
                                fontStyle: 'bold',    // X-Axis font style 
                            },
                        }],
                        yAxes: [{
                            id: "y-axis-density",
                            scaleLabel: {
                                display: true,
                                labelString: "Volume",
                                fontStyle: 'bold',
                                fontColor: '#2c2c2c'
                            },
                            ticks: {
                                fontColor: '#2c2c2c', // X-Axis font color
                                fontStyle: 'bold',    // X-Axis font style 
                            },
                            position: 'right'
                        }, {
                            id: "y-axis-gravity",
                            scaleLabel: {
                                display: true,
                                labelString: "Price ($)",
                                fontStyle: 'bold',
                                fontColor: '#2c2c2c'
                            },
                            ticks: {
                                fontColor: '#2c2c2c', // X-Axis font color
                                fontStyle: 'bold',    // X-Axis font style 
                            },
                        }]
                    }
                },
                tooltips: {
                    callbacks: {
                        label: function(tooltipItem, data) {
                            var dataset = data.datasets[tooltipItem.datasetIndex];
                            var index = tooltipItem.index;
                            return dataset.labels[index] + ': ' + dataset.data[index];
                        }
                    }
                }
            });
        });
        $A.enqueueAction(action);
    }
})