({
	 initCharts: function(component, event, helper){
          component.set("v.isExportJSLoaded",true);
        var child1List = component.get("v.child1List");
         console.log('child1List==>'+JSON.stringify(child1List))
          console.log('yAxisLabelsSales==>'+component.get("v.yAxisLabelsSales"))
          var yAxisLabelsSales = component.get("v.yAxisLabelsSales");
        var chartType = component.get("v.chartType");
            if(chartType == 'Bar'){
               Highcharts.setOptions({
                    lang: {
                        thousandsSep: ','
                    }
                })
            new Highcharts.Chart({
                 chart: {
                    renderTo: component.find("chart").getElement(),
                    type: 'column',
                    height: '500px', // 16:9 ratio
                },
                title: {
                    text: component.get("v.hospitalName")
                },
                xAxis: {
                   // type: 'category',
                    categories: component.get("v.xAxisLabels"),
                    //allowDecimals: false,
                    crosshair: true,
                    textAlign: 'center',
                },
                yAxis: {
                    min: 0,
                    //allowDecimals: false,
                    title: {
                        text: "Sales in $",
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
                tooltip: 
                {
                    headerFormat: '<span style="font-size:10px">{point.key}</span><table>',
                    pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' +
                        '<td style="padding:0"><b>{point.y}</b></td></tr>',
                    footerFormat: '</table>',
                    shared: true,
                    useHTML: true,
                  
                    valuePrefix: '$',
          
                },
                credits:{
                    enabled: false
                },
                plotOptions: {
                    column: {
                        pointPadding: -2,
                        borderWidth: 10
                    },
                    bar: {
                        grouping: false,
                        dataLabels: {
                            enabled: true
                        }
                    }
                },
                //component.get("v.highChartData"),
             
              /*  navigation: {
                    buttonOptions: {
                        enabled: true
                    }
                }*/
            });   
        } 
     }
})