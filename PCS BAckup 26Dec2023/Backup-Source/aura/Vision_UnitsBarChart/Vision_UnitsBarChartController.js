({
	 initCharts: function(component, event, helper){
         console.log('units for 6 months==>'+component.get("v.unitsListMonthWise"));
          component.set("v.isExportJSLoaded",true);
        var child1List = component.get("v.child1List");
         console.log('yAxisLabelsUnits==>'+component.get("v.yAxisLabelsUnits"))
         var yAxisLabelsUnits = component.get("v.yAxisLabelsUnits");
        // var dualChartLevel = component.get("dualChart");
         var titleName = component.get("v.titleName");;
         /*if(dualChartLevel == 'Hospital'){
             titleName = component.get("v.titleName");
         }*/
        var chartType = component.get("v.chartType");
            if(chartType == 'Bar'){
            new Highcharts.Chart({
                chart: {
                renderTo: component.find("chart_unit").getElement(),
                type: 'column'
            },
               
            
            title: {
                text: titleName, //,Monthly Average Rainfall'
                style: {
                            fontWeight: 'bold'
                        }
            },
            subtitle: {
                text: 'Sales and Units by Months'
            },
            xAxis: {
                categories: component.get("v.xAxisLabels"),
                title: {
                        text: 'Month'
                    },
                /*[
                    
                    'Nov',
                    'Dec',
                    'Jan',
                    'Feb',
                    'Mar',
                    'Apr',
                ]*/
            },
            yAxis: [{
                    min: 0,
                    title: {
                        text: 'Sales in $'
                    },
               
                }, {
                    min: 0,
                    opposite: true, //optional, you can have it on the same side.
                    title: {
                        text: 'Units'
                    },
                   
                }],
           /* tooltip: {
                headerFormat: '<span style="font-size:10px">{point.key}</span><table>',
                pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' +
                    '<td style="padding:0"><b>{point.y:.1f} $</b></td></tr>',
                footerFormat: '</table>',
                shared: true,
                useHTML: true
            },*/
            plotOptions: {
                column: {
                    pointPadding: 0.2,
                    borderWidth: 0
                }
            },
                
            series: [{
                name: 'Sales',
                yAxis: 0, //if using primary (0) yAxis can leave this out.
                data: component.get("v.salesListMonthWise"),//[49.9, 71.5, 106.4, 129.2, 144.0, 176.0],
                tooltip: {
                                valueSuffix: '$',
                    			pointFormat: '<span>{point.y:,f}</span>',
                    
                            },
                
                
                   
    
            }, {
                name: 'Units',
                yAxis: 1, //use new yAxis on right side.
                data: component.get("v.unitsListMonthWise"),//[83.6, 78.8, 98.5, 93.4, 106.0, 84.5],
                tooltip: {
                                valueSuffix: ''
                            },
               
               
    
            }, ]
        });
               
              
           
        } 
     }
})