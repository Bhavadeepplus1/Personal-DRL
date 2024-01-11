({
    doInit : function(component, event, helper){
        console.log('CHART INIT');
    },
	initCharts : function(component, event, helper) {
        console.log('categoryList --> '+JSON.stringify(component.get("v.categoryList")));
        console.log('pieChartData --> '+JSON.stringify(component.get("v.pieChartData")));
        new Highcharts.Chart({
            chart: {
                renderTo: component.find("chart").getElement(),
                type: 'pie',
                height: '180px'
            },
            title: {
                text: 'Status of Relevant Products'
            },
            /*xAxis: {
                type: 'category',
                categories: component.set("v.categoryList"),//['Awarded','True Opportunity','Supply Constraint','Price Constraint'],
                crosshair: true,
                title: {
                    text: "Product Status",
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
            },*/
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
                data: component.set("v.pieChartData")
            }],
            navigation: {
                buttonOptions: {
                    enabled: true
                }
            }
        });
	}
})