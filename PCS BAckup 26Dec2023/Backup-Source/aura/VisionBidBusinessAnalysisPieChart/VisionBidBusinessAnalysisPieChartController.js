({
    doInit: function (component, event, helper){
        console.log('Chart INIT');
    },
    initCharts: function(component, event, helper){
        component.set("v.isExportJSLoaded",true);
        component.set("v.needToProcessReRenderLogic",true);
        var chartType = component.get("v.chartType");
        var categoryTotals = component.get("v.categoryTotals");
        var maxVal = 0; var projectedSales = 0;
        if(categoryTotals != null){
            if(parseInt(categoryTotals.totalAnnualImpactBG) >= 0){
                maxVal += parseInt(categoryTotals.totalAnnualImpactBG);  
            }
            if(parseInt(categoryTotals.totalAnnualImpactBGG) >= 0){
                maxVal += parseInt(categoryTotals.totalAnnualImpactBGG); 
            }
            if(parseInt(categoryTotals.totalAnnualImpactBGL) >= 0){
                maxVal += parseInt(categoryTotals.totalAnnualImpactBGL);  
            }
            if(parseInt(categoryTotals.totalAnnualImpactBL) >= 0){
                maxVal += parseInt(categoryTotals.totalAnnualImpactBL);   
            }
            if(parseInt(component.get("v.actualSales")) >= 0){
                maxVal += parseInt(component.get("v.actualSales"));
            }
            projectedSales = (isNaN(parseInt(categoryTotals.totalAnnualImpactBG)) ? 0: parseInt(categoryTotals.totalAnnualImpactBG)) + (isNaN(parseInt(categoryTotals.totalAnnualImpactBGL)) ? 0: parseInt(categoryTotals.totalAnnualImpactBGL)) + (isNaN(parseInt(categoryTotals.totalAnnualImpactBGG)) ? 0: parseInt(categoryTotals.totalAnnualImpactBGG)) + (isNaN(parseInt(categoryTotals.totalAnnualImpactBL)) ? 0: parseInt(categoryTotals.totalAnnualImpactBL)) + (isNaN(parseInt(parseInt(component.get("v.actualSales")))) ? 0: parseInt(parseInt(component.get("v.actualSales"))));
            console.log('projectedSales: '+projectedSales); 
            if(projectedSales >= 0){
                maxVal += projectedSales;
            }
        }
        console.log('maxVal: '+maxVal);
        if(chartType == 'Pie'){
            var newAwards = component.get("v.newAwards");
            var productsLost = component.get("v.productsLost");
            var noEffects = component.get("v.noEffects");
            var randomBgColors = [];
            let sortable = [];
            sortable.push(['New Awards'+' ('+categoryTotals.percentNewAwards.toFixed(2)+'%)', newAwards]);
            sortable.push(['Price Changes'+' ('+categoryTotals.percentPriceChanges.toFixed(2)+'%)', categoryTotals.deadnetChangesCount]);
            sortable.push(['Volume Changes'+' ('+categoryTotals.percentQtyChanges.toFixed(2)+'%)', categoryTotals.awardedQtyChangesCount]);
            sortable.push(['Price &amp; Volume Changes'+' ('+categoryTotals.percentBothChanges.toFixed(2)+'%)', categoryTotals.bothPriceAndVolumeChangesCount]);
            sortable.push(['Products Lost'+' ('+categoryTotals.percentLoss.toFixed(2)+'%)', productsLost]);
            sortable.push(['No Effects'+' ('+categoryTotals.percentNoEffects.toFixed(2)+'%)', noEffects]);
            sortable.sort(function(a, b) {
                return b[1] - a[1];
            });
            console.log('Sortable: '+JSON.stringify(sortable));
            var highChartData = []; var highChartCategories = []; var pieChartData = [];
            for(var i=0; i<sortable.length; i++){
                var letters = '0123456789ABCDEF'.split('');
                var color = '#';
                for (var j = 0; j < 6; j++ ) {
                    color += letters[Math.floor(Math.random() * 16)];
                }
                var obj = {};
                pieChartData.push([sortable[i][0],sortable[i][1]]);
                highChartCategories.push(sortable[i][0]);
                var rec = sortable[i];
                obj.name = sortable[i][0];
                obj.color = color;
                obj.data = [{name: sortable[i][0], y: sortable[i][1], x: i}];
                highChartData.push(obj);
            }
            console.log('Pie Chart Data: '+JSON.stringify(pieChartData));
            new Highcharts.Chart({
                chart: {
                    renderTo: component.find("chart").getElement(),
                    type: 'pie',
                    height: '500px'
                },
                title: {
                    text: ''
                },
                xAxis: {
                    type: 'category',
                    categories: highChartCategories,
                    crosshair: true,
                    title: {
                        text: "Formulary Positions",
                        textAlign: "left",
                        style: {
                            fontWeight: 'bold'
                        }
                    }
                },
                yAxis: {
                    min: 0,
                    title: {
                        text: "Count",
                        style: {
                            fontWeight: 'bold'
                        }
                    }
                },
                legend: {
                    align: 'right',
                    verticalAlign: 'middle',
                    layout: 'vertical',
                    itemDistance: 100
                },
                tooltip: {
                    pointFormat: '{series.name}: <b>{point.y}</b>'
                },
                credits:{
                    enabled: false
                },
                plotOptions: {
                    pie: {
                        allowPointSelect: true,
                        cursor: 'pointer',
                        dataLabels: {
                            enabled: true,
                            format: '<b>{point.name}</b>: {point.y}',
                        },
                        showInLegend: true
                    }
                },
                series: [{
                    type: 'pie',
                    name: 'Count',
                    colorByPoint: true,
                    data: pieChartData
                }],
                navigation: {
                    buttonOptions: {
                        enabled: true
                    }
                }
            });      
        }
        else if (chartType == 'Waterfall'){
            new Highcharts.Chart({
                chart: {
                    renderTo: component.find("chart").getElement(),
                    height: '500px',
                    type: 'waterfall'
                },
                
                title: {
                    text: 'Bid Business Analysis'
                },
                
                xAxis: {
                    type: 'category'
                },
                
                yAxis: {
                    min: 0,
                    title: {
                        text: ''
                    },
                    max: maxVal,
                },
                credits:{
                    enabled: false
                },
                legend: {
                    enabled: false
                },
                
                tooltip: {
                    pointFormat: '<b>${point.y:,.0f}</b>'
                },
                
                series: [{
                    upColor: "#64b5f6",
                    color: "#d60501",
                    data: [{
                        name: 'Actual Sales',
                        y: parseInt(component.get("v.actualSales"))
                    }, {
                        name: 'Business Gained',
                        y: categoryTotals.totalAnnualImpactBG
                    }, {
                        name: 'Business Retained with Gains',
                        y: categoryTotals.totalAnnualImpactBGG
                    }, {
                        name: 'Business Retained with Loss',
                        y: categoryTotals.totalAnnualImpactBGL
                    }, {
                        name: 'Product Lost',
                        y: categoryTotals.totalAnnualImpactBL
                    }, {
                        name: 'Projected Annual Sales',
                        y: projectedSales,
                        isSum: true,
                    }],
                    dataLabels: {
                        enabled: true,
                        inside: false,
                        formatter: function () {
                            return  '$'+ Highcharts.numberFormat(this.y, 0, '.',',');  //Highcharts.numberFormat(this.y / 1000, 0, ',') + 'k';
                        },
                    },
                    pointPadding: 0
                }]
            }); 
        }
    },
    scrollToTop : function(component, event, helper) {
        var scrollOptions = {
            left: 0,
            top: 0,
            behavior: 'smooth'
        }
        window.scrollTo(scrollOptions);
    }
})