({
    doInit : function(component, event, helper) {
        
        var recentData = component.get("v.data.finalMap");
        console.log('recentData-->'+JSON.stringify(recentData))
        var previousData = component.get("v.data.finalPreviousMap");
        console.log('previousData--->'+JSON.stringify(previousData));
        var comparison = component.get("v.comparison");
        var salesdl =[];
        var units =[];
        var tpt =[];
        var tptPercent =[];
        var salesdlPrev =[];
        var unitsPrev =[];
        var tptPrev =[];
        var tptPercentPrev =[];
        var val=[];
        var l1 = [];
        var l2 = [];
        var xaxizLables = [];
        var xaxizLablesPrevious = [];
        if(comparison == 'lastquartervspreviousquarter'){
            console.log('hello')
            var salesRecent = 0, unitsRecent = 0, tptRecent = 0, salesPrevious = 0, unitsPrevious = 0, tptPrevious = 0;
            for (var key in recentData){
                salesRecent = salesRecent + recentData[key]['salesMonthly'];
                console.log('unitsRecent1: '+unitsRecent);
                unitsRecent = unitsRecent + recentData[key]['unitsMonthly'];
                 console.log('unitsRecent2: '+unitsRecent);
                tptRecent = tptRecent + recentData[key]['tptdollarMonthly'];
                if(comparison != 'lastquartervspreviousquarter'){
                    var label = key.split('-');
                    xaxizLables.push(label[0]);
                } else{
                    l1.push(key);
                }
            }
            salesdl.push(salesRecent);
            units.push(unitsRecent);
            tpt.push(tptRecent);
            tptPercent.push((tptRecent/salesRecent)*100);
            for(var key in previousData){
                salesPrevious = salesPrevious + previousData[key]['salesMonthlyPrev'];
                unitsPrevious = unitsPrevious + previousData[key]['unitsMonthlyPrev'];
                tptPrevious = tptPrevious + previousData[key]['tptdollarMonthlyPrev'];
                if(comparison != 'lastquartervspreviousquarter'){
                    var label = key.split('-');
                    if(!xaxizLables.includes(label[0])){
                        xaxizLables.push(label[0]);  
                    }
                } else{
                    l1.push(key);
                }
            }
            salesdlPrev.push(salesPrevious);
            unitsPrev.push(unitsPrevious);
            tptPrev.push(tptPrevious);
            tptPercentPrev.push((tptPrevious/salesPrevious)*100);
        } else {
            for (var key in recentData){
                console.log('keys--->'+key);
                salesdl.push(recentData[key]['salesMonthly']);
                units.push(recentData[key]['unitsMonthly']);
                tpt.push(recentData[key]['tptdollarMonthly']);
                tptPercent.push((recentData[key]['tptdollarMonthly']/recentData[key]['salesMonthly'])*100);
                if(comparison != 'lastquartervspreviousquarter'){
                    var label = key.split('-');
                    xaxizLables.push(label[0]);
                } else{
                    l1.push(key);
                }
            }
            console.log('xaxizLables--->'+xaxizLables);
            for(var key in previousData){
                salesdlPrev.push(previousData[key]['salesMonthlyPrev']);
                unitsPrev.push(previousData[key]['unitsMonthlyPrev']);
                tptPrev.push(previousData[key]['tptdollarMonthlyPrev']);
                tptPercentPrev.push((previousData[key]['tptdollarMonthlyPrev']/previousData[key]['salesMonthlyPrev'])*100);
                if(comparison != 'lastquartervspreviousquarter'){
                    var label = key.split('-');
                     xaxizLablesPrevious.push(label[0]);
                    if(!xaxizLables.includes(label[0])){
                        xaxizLables.push(label[0]); 
                       
                    }
                } else{
                    l1.push(key);
                }
            }
        }
        console.log('xaxizLablesPrevious--->'+xaxizLablesPrevious)
        var showTPT = component.get("v.isINTChecked");
        if(component.get("v.data.customerName") != null && component.get("v.data.customerName") != ''){
            if(showTPT){
                 var chartobj5 = component.get("v.chartobj5");
                var chartobj6 = component.get("v.chartobj6");
            }else{
                var chartobj1 = component.get("v.chartobj1");
                var chartobj2 = component.get("v.chartobj2");
                var chartobj3 = component.get("v.chartobj3");
                var chartobj4 = component.get("v.chartobj4");
            }
            if(showTPT){
                var el5 = component.find('chart5').getElement();
                var el6 = component.find('chart6').getElement();
            }else{
                var el1 = component.find('chart1').getElement();
                var el2 = component.find('chart2').getElement();
                var el3 = component.find('chart3').getElement();
                var el4 = component.find('chart4').getElement();
            }
        }
        /*var ctx1 = el1.getContext('2d');
        var ctx2 = el2.getContext('2d');
        var ctx3 = el3.getContext('2d');
        var ctx4 = el4.getContext('2d');*/
       
        //if chartobj is not empty, then destory the chart in the view
        if(component.get("v.data.customerName") != null && component.get("v.data.customerName") != ''){
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
        }
        if(comparison == 'lastquartervspreviousquarter'){
            if(component.get("v.data.customerName") != null && component.get("v.data.customerName") != ''){
                if(showTPT){
                    chartobj5 = new Chart(el5, {
                        type: 'bar',
                        data: {
                            labels: [component.get("v.headers.two")+'/'+component.get("v.headers.one")],
                            datasets: [
                                {
                                    label: component.get("v.headers.two"),
                                    borderColor: 'rgba(237, 125, 49)',
                                    backgroundColor:'rgba(237, 125, 49)',
                                    data: unitsPrev
                                },
                                {
                                    label: component.get("v.headers.one"),
                                    backgroundColor: 'rgb(63, 37, 133)',
                                    borderColor: 'rgb(63, 37, 133)',
                                    data: units
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
                    chartobj6 = new Chart(el6, {
                        type: 'bar',
                        data: {
                            labels: [component.get("v.headers.two")+'/'+component.get("v.headers.one")],
                            datasets: [
                                {
                                    label: component.get("v.headers.two"),
                                    borderColor: 'rgba(237, 125, 49)',
                                    backgroundColor:'rgba(237, 125, 49)',
                                    data: salesdlPrev
                                },
                                {
                                    label: component.get("v.headers.one"),
                                    backgroundColor: 'rgb(63, 37, 133)',
                                    borderColor: 'rgb(63, 37, 133)',
                                    data: salesdl
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
                                            style: 'currency',
                                            currency:"USD",
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
                }else{
                    chartobj1 = new Chart(el1, {
                        type: 'bar',
                        data: {
                            labels: [component.get("v.headers.two")+'/'+component.get("v.headers.one")],
                            datasets: [
                                {
                                    label: component.get("v.headers.two"),
                                    borderColor: 'rgba(237, 125, 49)',
                                    backgroundColor:'rgba(237, 125, 49)',
                                    data: unitsPrev
                                },
                                {
                                    label: component.get("v.headers.one"),
                                    backgroundColor: 'rgb(63, 37, 133)',
                                    borderColor: 'rgb(63, 37, 133)',
                                    data: units
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
                    chartobj2 = new Chart(el2, {
                        type: 'bar',
                        data: {
                            labels: [component.get("v.headers.two")+'/'+component.get("v.headers.one")],
                            datasets: [
                                {
                                    label: component.get("v.headers.two"),
                                    borderColor: 'rgba(237, 125, 49)',
                                    backgroundColor:'rgba(237, 125, 49)',
                                    data: salesdlPrev
                                },
                                {
                                    label: component.get("v.headers.one"),
                                    backgroundColor: 'rgb(63, 37, 133)',
                                    borderColor: 'rgb(63, 37, 133)',
                                    data: salesdl
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
                                            style: 'currency',
                                            currency:"USD",
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
                   
                    chartobj3 = new Chart(el3, {
                        type: 'bar',
                        data: {
                            labels: [component.get("v.headers.two")+'/'+component.get("v.headers.one")],
                            datasets: [
                                {
                                    label: component.get("v.headers.two"),
                                    borderColor: 'rgba(237, 125, 49)',
                                    backgroundColor:'rgba(237, 125, 49)',
                                    data: tptPrev
                                },
                                {
                                    label: component.get("v.headers.one"),
                                    backgroundColor: 'rgb(63, 37, 133)',
                                    borderColor: 'rgb(63, 37, 133)',
                                    data: tpt
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
                                            style: 'currency',
                                            currency:"USD",
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
                                text: 'TPT ($)',
                                fontSize: 14
                            },
                            scales: {
                                yAxes: [{
                                    ticks: {
                                        beginAtZero:true,
                                        fontStyle: 'bold',
                                        callback: function(value, index, values) {
                                            return value / 1e6 + 'M';
                                        }
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
                   
                    chartobj4 = new Chart(el4, {
                        type: 'bar',
                        data: {
                            labels: [component.get("v.headers.two")+'/'+component.get("v.headers.one")],
                            datasets: [
                                {
                                    label: component.get("v.headers.two"),
                                    borderColor: 'rgba(237, 125, 49)',
                                    backgroundColor:'rgba(237, 125, 49)',
                                    data: tptPercentPrev
                                },
                                {
                                    label: component.get("v.headers.one"),
                                    backgroundColor: 'rgb(63, 37, 133)',
                                    borderColor: 'rgb(63, 37, 133)',
                                    data: tptPercent
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
        } 
        else{
            console.log('Customer Name Naseer::: '+component.get("v.data.customerName"));
            if(component.get("v.data.customerName") != null && component.get("v.data.customerName") != ''){
                 if(showTPT){
                      chartobj5 = new Chart(el6, {
                        type: 'line',
                        data: {
                            labels: xaxizLables,
                            datasets: [
                                {
                                    label: component.get("v.headers.two"),
                                    borderColor: 'rgba(237, 125, 49)',
                                    backgroundColor:'rgba(237, 125, 49)',
                                    fill: false,
                                    data: salesdlPrev
                                },
                                {
                                    label: component.get("v.headers.one"),
                                    backgroundColor:'rgba(63, 37, 133)',
                                    borderColor: 'rgba(63, 37, 133)',
                                    fill: false,
                                    data: salesdl
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
                                            style: 'currency',
                                            currency:"USD",
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
                   
                    chartobj6 = new Chart(el5, {
                        type: 'line',
                        data: {
                            labels: xaxizLables,
                            datasets: [
                                {
                                    label: component.get("v.headers.two"),
                                    borderColor: 'rgba(237, 125, 49)',
                                    backgroundColor:'rgba(237, 125, 49)',
                                    fill: false,
                                    data: unitsPrev
                                },
                                {
                                    label: component.get("v.headers.one"),
                                    backgroundColor:'rgba(63, 37, 133)',
                                    borderColor: 'rgba(63, 37, 133)',
                                    fill: false,
                                    data: units
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
                    chartobj1 = new Chart(el2, {
                        type: 'line',
                        data: {
                            labels: xaxizLables,
                            datasets: [
                                {
                                    label: component.get("v.headers.two"),
                                    borderColor: 'rgba(237, 125, 49)',
                                    backgroundColor:'rgba(237, 125, 49)',
                                    fill: false,
                                    data: salesdlPrev
                                },
                                {
                                    label: component.get("v.headers.one"),
                                    backgroundColor:'rgba(63, 37, 133)',
                                    borderColor: 'rgba(63, 37, 133)',
                                    fill: false,
                                    data: salesdl
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
                                            style: 'currency',
                                            currency:"USD",
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
                   
                    chartobj2 = new Chart(el1, {
                        type: 'line',
                        data: {
                            labels: xaxizLables,
                            datasets: [
                                {
                                    label: component.get("v.headers.two"),
                                    borderColor: 'rgba(237, 125, 49)',
                                    backgroundColor:'rgba(237, 125, 49)',
                                    fill: false,
                                    data: unitsPrev
                                },
                                {
                                    label: component.get("v.headers.one"),
                                    backgroundColor:'rgba(63, 37, 133)',
                                    borderColor: 'rgba(63, 37, 133)',
                                    fill: false,
                                    data: units
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
                   
                    chartobj3 = new Chart(el3, {
                        type: 'line',
                        data: {
                            labels: xaxizLables,
                            datasets: [
                                {
                                    label: component.get("v.headers.two"),
                                    borderColor: 'rgba(237, 125, 49)',
                                    backgroundColor:'rgba(237, 125, 49)',
                                    fill: false,
                                    data: tptPrev
                                },
                                {
                                    label: component.get("v.headers.one"),
                                    backgroundColor:'rgba(63, 37, 133)',
                                    borderColor: 'rgba(63, 37, 133)',
                                    fill: false,
                                    data: tpt
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
                                            style: 'currency',
                                            currency:"USD",
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
                                text: 'TPT ($)',
                                fontSize: 14
                            },
                            scales: {
                                yAxes: [{
                                    ticks: {
                                        beginAtZero:true,
                                        fontStyle: 'bold',
                                        callback: function(value, index, values) {
                                            return value / 1e6 + 'M';
                                        }
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
                   
                    chartobj4 = new Chart(el4, {
                        type: 'line',
                        data: {
                            labels: xaxizLables,
                            datasets: [
                                {
                                    label: component.get("v.headers.two"),
                                    borderColor: 'rgba(237, 125, 49)',
                                    backgroundColor:'rgba(237, 125, 49)',
                                    fill: false,
                                    data: tptPercentPrev
                                },
                                {
                                    label: component.get("v.headers.one"),
                                    backgroundColor:'rgba(63, 37, 133)',
                                    borderColor: 'rgba(63, 37, 133)',
                                    fill: false,
                                    data: tptPercent
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
        }
        if(component.get("v.data.customerName") != null && component.get("v.data.customerName") != ''){
            if(showTPT){
                component.set("v.chartobj5",chartobj5);
                component.set("v.chartobj6",chartobj6);
                
            }else{
                component.set("v.chartobj1",chartobj1);
                component.set("v.chartobj2",chartobj2);
                component.set("v.chartobj3",chartobj3);
                component.set("v.chartobj4",chartobj4);
            }
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