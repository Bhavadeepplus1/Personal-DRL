({
    doInit: function (component, event, helper){
        console.log('Chart INIT');
    },
    initCharts: function(component, event, helper){
        console.log('selectedContract: '+component.get("v.selectedContract"));
        component.set("v.isExportJSLoaded",true);
        component.set("v.needToProcessReRenderLogic",true);
        var chartType = component.get("v.chartType");
        var selectedContract = component.get("v.selectedContract");
        var contracts = component.get("v.contracts");
        var isOTCCustomer = component.get("v.isOTCCustomer");
        for(var i=0; i<contracts.length; i++){
            if(contracts[i].Phoenix_Contract_External_Description__c == selectedContract){
                component.set("v.contractNumber", contracts[i].Phoenix_Contract_Number__c);
            }
        }
        var randomBgColors = [];
        var selectedPositions = Object.keys(component.get("v.selectedContractPositionsCount"));
        var selectedContractPositionsCount = component.get("v.selectedContractPositionsCount");
        console.log('selectedContractPositionsCount: '+JSON.stringify(selectedContractPositionsCount));
        console.log(':::: '+JSON.stringify(component.get("v.missingCounts")));
        let sortable = [];
        for (var position in selectedContractPositionsCount) {
            if(isOTCCustomer){
                sortable.push([((Number(position))*100).toFixed(), selectedContractPositionsCount[position]]);
            } else{
             	sortable.push([position, selectedContractPositionsCount[position]]);   
            }
        }
        sortable.sort(function(a, b) {
            var returnVal;
            if(isOTCCustomer){
                returnVal = Number(b[0]) - Number(a[0]);
            } else{
             	returnVal = b[1] - a[1];   
            }
            return returnVal;
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
            if(isOTCCustomer){
                pieChartData.push([sortable[i][0]+'%',sortable[i][1]]);
                highChartCategories.push(sortable[i][0]+'%');
                var rec = sortable[i];
                obj.name = sortable[i][0]+'%';
                obj.color = color;
                obj.data = [{name: sortable[i][0]+'%', y: sortable[i][1], x: i}];   
            } else{
                pieChartData.push([sortable[i][0],sortable[i][1]]);
                highChartCategories.push(sortable[i][0]);
                var rec = sortable[i];
                obj.name = sortable[i][0];
                obj.color = color;
                obj.data = [{name: sortable[i][0], y: sortable[i][1], x: i}];
            }
            highChartData.push(obj);
            console.log('Start');
            console.log('Object for Chart: '+JSON.stringify(obj));
            console.log('End');
        }
        console.log('Pie Chart Data: '+JSON.stringify(pieChartData));
        if(chartType == 'Bar'){
            console.log('high Chart Data: '+JSON.stringify(highChartData));
            new Highcharts.Chart({
                chart: {
                    renderTo: component.find("chart").getElement(),
                    type: 'bar',
                    height: '500px' // 16:9 ratio
                },
                title: {
                    text: component.get("v.selectedContract")+' - '+component.get("v.contractNumber")
                },
                xAxis: {
                    type: 'category',
                    categories: highChartCategories,
                    allowDecimals: false,
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
                    allowDecimals: false,
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
                tooltip: 
                {
                    headerFormat: '<span style="font-size:10px">{point.key}</span><table>',
                    pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' +
                        '<td style="padding:0"><b>{point.y}</b></td></tr>',
                    footerFormat: '</table>',
                    shared: true,
                    useHTML: true
                },
                credits:{
                    enabled: false
                },
                plotOptions: {
                    column: {
                        pointPadding: 2,
                        borderWidth: 2
                    },
                    bar: {
                        grouping: false,
                        dataLabels: {
                            enabled: true
                        }
                    }
                },
                series: highChartData,
                navigation: {
                    buttonOptions: {
                        enabled: true
                    }
                }
            });   
        } 
        else if(chartType == 'Pie'){
            new Highcharts.Chart({
                chart: {
                    renderTo: component.find("chart").getElement(),
                    type: 'pie',
                    height: '500px'
                },
                title: {
                    text: component.get("v.selectedContract")+' - '+component.get("v.contractNumber")
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
        console.log('pieChartData: '+JSON.stringify(pieChartData));
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