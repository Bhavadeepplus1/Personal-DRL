({
    initCharts: function(component, event, helper){
        console.log('HighCharts loaded')  ;
        var pieChartData = []; var highChartCategories = [];
        var jsonData = component.get("v.ltngChartData");
        var totalVal = 0;
        jsonData.forEach(function(item){
            totalVal += parseInt(item.count);
        });
        for(var i=0; i<jsonData.length; i++){
            var letters = '0123456789ABCDEF'.split('');
            var color = '#';
            var obj = {};
            for (var j = 0; j < 6; j++ ) {
                color += letters[Math.floor(Math.random() * 16)];
            }
            obj.name = jsonData[i].label;
            obj.color = color;
            obj.y = parseInt(jsonData[i].count);
            obj.x = parseInt(jsonData[i].totalVal);
            obj.perc = Math.round(((parseInt(jsonData[i].count)/totalVal))*100);
            
            if(component.get("v.showDollar")){
                function numberWithCommas(x) {
                    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
                }
                obj.dollar = '$ '+numberWithCommas(jsonData[i].dollar);                
                //obj.dollar= '$ '+parseInt(jsonData[i].dollar).toFixed().toLocaleString('en-US');
            }
            pieChartData.push(obj);
        }
        console.log('pieChartData: '+JSON.stringify(pieChartData));
        new Highcharts.Chart({
            chart: {
                renderTo: component.find("chart").getElement(),
                type: 'pie',
            },
            title: {
                text: ''
            },
            xAxis: {
                type: 'category',
                crosshair: true,
                title: {
                    text: "100% Customer Analysis",
                    textAlign: "left",
                    style: {
                        fontWeight: 'bold'
                    }
                }
            },
            yAxis: {
                min: 0,
                title: {
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
                pointFormat: '<b>{point.y}</b>'
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
                        format: component.get("v.showDollar") ? '<b>{point.name}</b>: {point.y}, ({point.dollar})' : '<b>{point.name}</b>: {point.y}',
                    },
                    showInLegend: true
                }
            },
            series: [{
                type: 'pie',
                colorByPoint: true,
                data: pieChartData
            }],
            navigation: {
                buttonOptions: {
                    enabled: true
                }
            }
        }); 
    },
    
    
    generateChart : function(component, event, helper) {
        console.log('INSIDE THE CHART COMPONENT ------_____-----');
        var jsonData = component.get("v.ltngChartData");
        console.log('ltngChartData: '+JSON.stringify(jsonData));
        var labelset=[] ;
        var dataset=[] ;
        var toolTips=[];
        var coloR = [];
        
        var dynamicColors = function() {
            var r = Math.floor(Math.random() * 255);
            var g = Math.floor(Math.random() * 255);
            var b = Math.floor(Math.random() * 255);
            return "rgb(" + r + "," + g + "," + b + ")";
        };
        
        var totalCount = 0;
        
        jsonData.forEach(function(key) {
            console.log('key.label :: -- '+key.label+' || key.count :: -- '+key.count+' key.totalVal :: -- '+key.totalVal);
            labelset.push(key.label+' ('+key.count+'): $ '+key.totalVal); 
            dataset.push(key.count); 
            totalCount = totalCount+parseInt(key.count);
            toolTips.push(key.totalVal);
            coloR.push(dynamicColors());
        });
        
        new Chart(document.getElementById("pie-chart"), {
            type: 'pie',
            data: {
                labels:labelset,
                datasets: [{
                    label: "Status",
                    backgroundColor: ['#49ffb6','#c2ff49','#ffc949','#49c6ff','#7a49ff','#ff498c'],
                    data: dataset
                }]
            },
            options : {
                legend: {
                    display: true,
                    position: "bottom"
                },
                tooltips: {
                    titleFontSize: 15,
                    bodyFontSize: 15,
                    callbacks: {
                        label: function(tooltipItems, data) { 
                            //var percentVal = ((parseInt(jsonData[tooltipItems.index].count)/totalCount)*100).toFixed(2)+'%';
                            var multistringText = [jsonData[tooltipItems.index].label+'('+jsonData[tooltipItems.index].count+')'];// : $ '+jsonData[tooltipItems.index].totalVal];
                            //multistringText.push(percentVal);
                            return multistringText;
                        }
                    }
                },
                onAnimationComplete: function(tooltipItems, data) { 
                    //var percentVal = ((parseInt(jsonData[tooltipItems.index].count)/totalCount)*100).toFixed(2)+'%';
                    //var multistringText = [jsonData[tooltipItems.index].label+'('+jsonData[tooltipItems.index].count+') : $ '+jsonData[tooltipItems.index].totalVal];
                    //multistringText.push(percentVal);
                    return parseInt(jsonData[tooltipItems.index].count);//multistringText;
                },
                tooltipEvents: []
            }
        });
     },
    chartJsOnLoad : function(component, event, helper){
        console.log('IN chartJsOnLoad');
        var a = component.get('c.generateChart');
        $A.enqueueAction(a);
    },
    chartJsLabelOnLoad : function(component, event, helper){
        console.log('IN chartJsLabelOnLoad');
        component.set("v.chartJsLabelExecuted",true);
        component.set("v.rendererBoolean",true);
    },
	
})