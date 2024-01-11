({
    doInit : function(component, event, helper) {
        var QH1=[];
        var salesMonthlyrec=[];
        var salesMonthlyPrevrec=[];
        var unitsMonthlyPrevrec=[];
        var unitsMonthlyrec=[];
        var QH2=[];
        var recentData = component.get("v.data.finalMap");
        for (var key in recentData){          
            QH1.push(key);
            salesMonthlyrec.push(Math.round(recentData[key]['salesMonthly']));
            
            unitsMonthlyrec.push(Math.round(recentData[key]['unitsMonthly']));
            
        }
        
        component.set("v.QuadrantHeader",QH1);
        
        var previousData = component.get("v.data.finalPreviousMap");
        for (var key in previousData){          
            QH2.push(key);
            salesMonthlyPrevrec.push(Math.round(previousData[key]['salesMonthlyPrev']));
            unitsMonthlyPrevrec.push(Math.round(previousData[key]['unitsMonthlyPrev']));
        }
        component.set("v.QuadrantHeader2",QH2);
        component.set("v.salesMonthlyrec",salesMonthlyrec);
        component.set("v.salesMonthlyPrevrec",salesMonthlyPrevrec);
        component.set("v.unitsMonthlyPrevrec",unitsMonthlyPrevrec);
        component.set("v.unitsMonthlyrec",unitsMonthlyrec);
        
        console.log('previousData--->'+JSON.stringify(previousData));
        component.set("v.prevQuadrant",previousData);
        component.set("v.Quadrant",recentData);
        var comparison = component.get("v.comparison");
        console.log('test satya-->'+component.get("v.keySetPrev"));
        console.log('test satya-->'+component.get("v.keySetPrev").length);
        var keySet = component.get("v.keySet");
        var keySetPrev = component.get("v.keySetPrev");
        
        if(keySetPrev.length > 12 && comparison == "last12monthsvsprevious12months"){
            keySetPrev.pop();
        }
        component.set("v.keySetPrev",keySetPrev);
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
        var recentKeys = Object.keys(recentData);
        var prevKeys = Object.keys(previousData);
        var test=[];
        if(comparison == 'lastquartervspreviousquarter'){
            console.log('hello')
            var salesRecent = 0, unitsRecent = 0, tptRecent = 0, salesPrevious = 0, unitsPrevious = 0, tptPrevious = 0;
            for (var key in recentData){
                salesRecent = salesRecent + Math.round(recentData[key]['salesMonthly']);
                console.log('salesRecent: '+salesRecent);
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
            console.log('salesdl==>'+salesdl);
            for(var key in previousData){
                salesPrevious = parseInt(salesPrevious) + parseInt(previousData[key]['salesMonthlyPrev']);
                unitsPrevious = parseInt(unitsPrevious) + parseInt(previousData[key]['unitsMonthlyPrev']);
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
        } 
        else if(comparison == 'last12monthsvsprevious12months'){
            /*for lables*/
            for(var k=0;k<keySet.length;k++){
                if(comparison == 'last12monthsvsprevious12months'){
                    var label = keySet[k].split('-');
                    xaxizLables.push(label[0]);
                }
            }
            /*end for lables*/
            var s;
            var u;
            var t;
            var tp;
            console.log('keySET LAST KEY rec--'+recentKeys[11])
            var keysLength = recentKeys.length-1;
            var keysLengthPrev = prevKeys.length-1;
            
            console.log('in if test')
            for(var k=0;k<keySet.length;k++){
                var length = keySet.length-1;
                
                for (var key in recentData){
                    
                    if(key==keySet[k]){
                        s= recentData[key]['salesMonthly'];
                        u = recentData[key]['unitsMonthly'];
                        t= recentData[key]['tptdollarMonthly']
                        tp= (recentData[key]['tptdollarMonthly']/recentData[key]['salesMonthly'])*100;
                    }else{
                        var s1 ='';
                        var u1='';
                        var t1='';
                        var tp1='';
                    }
                    
                }
                var sldl= s !=null && s !=0? s:s1;
                var vl= u !=null && u !=0? u:u1;
                var tpdl= t !=null && t !=0? t:t1;
                var tppct= tp !=null && tp !=0? tp:tp1;
                
                salesdl.push(sldl);
                units.push(vl);
                tpt.push(tpdl);
                tptPercent.push(tppct);
                s='';
                u='';
                t='';
                tp='';
                console.log('testrec-->'+salesdl)   
                
            }
            
            console.log('keySetPrev--->'+keySetPrev);
            var s_pr;
            var u_pr;
            var t_pr;
            var tp_pr;
            for(var k=0;k<keySetPrev.length;k++){
                for (var key in previousData){
                    if(key==keySetPrev[k]){
                        s_pr= previousData[key]['salesMonthlyPrev'];
                        u_pr = previousData[key]['unitsMonthlyPrev'];
                        t_pr= previousData[key]['tptdollarMonthlyPrev']
                        tp_pr= (previousData[key]['tptdollarMonthlyPrev']/previousData[key]['salesMonthlyPrev'])*100;
                    }else{
                        var s1_pr ='';
                        var u1_pr='';
                        var t1_pr='';
                        var tp1_pr='';
                    }
                    
                }
                var sldl_pr= s_pr !=null && s_pr !=0? s_pr:s1_pr;
                var vl_pr= u_pr !=null && u_pr !=0? u_pr:u1_pr;
                var tpdl_pr= t_pr !=null && t_pr !=0? t_pr:t1_pr;
                var tppct_pr= tp_pr !=null && tp_pr !=0? tp_pr:tp1_pr;
                
                salesdlPrev.push(sldl_pr);
                unitsPrev.push(vl_pr);
                tptPrev.push(tpdl_pr);
                tptPercentPrev.push(tppct_pr);
                s_pr='';
                u_pr='';
                t_pr='';
                tp_pr='';
                console.log('testrecprev-->'+salesdlPrev)   
                
            }
            console.log('xaxizLablesPrevious--->'+xaxizLablesPrevious)
            console.log('salesdl-->'+salesdl);
            console.log('xaxizLables--->'+xaxizLables);
        }
            else if(comparison == 'fytdvspreviousfytd'){
                console.log('in fytd');
                console.log('keySet-->'+keySet);
                console.log('keySetPrev-->'+keySetPrev);
                var keysetLength = keySet.length-1;
                console.log('keyset length-test->'+keySet[keysetLength])
                /*for lables*/
                for(var k=0;k<keySet.length;k++){
                    if(comparison == 'fytdvspreviousfytd'){
                        var label = keySet[k].split('-');
                        xaxizLables.push(label[0]);
                    }
                }
                /*end for lables*/
                var s;
                var u;
                var t;
                var tp;
                console.log('keySET LAST KEY rec--'+recentKeys[10])
                
                for(var k=0;k<keySet.length;k++){
                    var length = keySet.length-1;
                    
                    for (var key in recentData){
                        
                        if(key==keySet[k]){
                            s= recentData[key]['salesMonthly'];
                            u = recentData[key]['unitsMonthly'];
                            t= recentData[key]['tptdollarMonthly']
                            tp= (recentData[key]['tptdollarMonthly']/recentData[key]['salesMonthly'])*100;
                        }else{
                            var s1 ='';
                            var u1='';
                            var t1='';
                            var tp1='';
                        }
                        
                    }
                    var sldl= s !=null && s !=0? s:s1;
                    var vl= u !=null && u !=0? u:u1;
                    var tpdl= t !=null && t !=0? t:t1;
                    var tppct= tp !=null && tp !=0? tp:tp1;
                    
                    salesdl.push(sldl);
                    units.push(vl);
                    tpt.push(tpdl);
                    tptPercent.push(tppct);
                    s='';
                    u='';
                    t='';
                    tp='';
                    console.log('testrec-->'+salesdl)   
                    
                }
                
                console.log('keySetPrev--->'+keySetPrev);
                var s_pr;
                var u_pr;
                var t_pr;
                var tp_pr;
                for(var k=0;k<keySetPrev.length;k++){
                    for (var key in previousData){
                        if(key==keySetPrev[k]){
                            s_pr= previousData[key]['salesMonthlyPrev'];
                            u_pr = previousData[key]['unitsMonthlyPrev'];
                            t_pr= previousData[key]['tptdollarMonthlyPrev']
                            tp_pr= (previousData[key]['tptdollarMonthlyPrev']/previousData[key]['salesMonthlyPrev'])*100;
                        }else{
                            var s1_pr ='';
                            var u1_pr='';
                            var t1_pr='';
                            var tp1_pr='';
                        }
                        
                    }
                    var sldl_pr= s_pr !=null && s_pr !=0? s_pr:s1_pr;
                    var vl_pr= u_pr !=null && u_pr !=0? u_pr:u1_pr;
                    var tpdl_pr= t_pr !=null && t_pr !=0? t_pr:t1_pr;
                    var tppct_pr= tp_pr !=null && tp_pr !=0? tp_pr:tp1_pr;
                    
                    salesdlPrev.push(sldl_pr);
                    unitsPrev.push(vl_pr);
                    tptPrev.push(tpdl_pr);
                    tptPercentPrev.push(tppct_pr);
                    s_pr='';
                    u_pr='';
                    t_pr='';
                    tp_pr='';
                    console.log('testrecprev-->'+salesdlPrev)   
                    
                }
                
                console.log('xaxizLablesPrevious--->'+xaxizLablesPrevious)
                console.log('salesdl-->'+salesdl);
                console.log('xaxizLables--->'+xaxizLables);
                
            }
        var showTPT = component.get("v.isEXTChecked");
        if(showTPT){
            var chartobj5 = component.get("v.chartobj5");
            var chartobj6 = component.get("v.chartobj6");
            console.log('chartobj5 graphs cmp-----'+JSON.stringify(chartobj5));
        }
        /*else{
            var chartobj1 = component.get("v.chartobj1");
            var chartobj2 = component.get("v.chartobj2");
            var chartobj3 = component.get("v.chartobj3");
            var chartobj4 = component.get("v.chartobj4");
        }*/
        if(showTPT){
            var el5 = component.find('chart5').getElement();
            var el6 = component.find('chart6').getElement();
        }
        /*else{
            var el1 = component.find('chart1').getElement();
            var el2 = component.find('chart2').getElement();
            var el3 = component.find('chart3').getElement();
            var el4 = component.find('chart4').getElement();
        }*/
        /*var ctx1 = el1.getContext('2d');
        var ctx2 = el2.getContext('2d');
        var ctx3 = el3.getContext('2d');
        var ctx4 = el4.getContext('2d');*/
        
        //if chartobj is not empty, then destory the chart in the view
        if(showTPT){
            if(chartobj5){
                chartobj5.destroy();
            }
            if(chartobj6){
                chartobj6.destroy();
            }
        }
        /*else{
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
        }*/
        component.set("v.salesdlPrev",salesdlPrev);
        component.set("v.salesdl",salesdl);
        component.set("v.unitsPrev",unitsPrev);
        component.set("v.units",units);
        console.log('salesdlPrev sri====='+salesdlPrev);
        console.log('xaxizLables sri====='+xaxizLables.length);
        if(comparison == 'lastquartervspreviousquarter'){
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
            }
            
        } 
        else{
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
            }
            
        }
        if(showTPT){
            component.set("v.chartobj5",chartobj5);
            component.set("v.chartobj6",chartobj6);
            
        }
        var summarysalesdl=0;
        var summarysalesdlPrev=0;
        var summaryunits=0;
        var summaryunitsPrev=0;
        console.log('salesdl salesdl salesdl $$'+salesdl);
        for(var i=0;i<salesdl.length;i++){
            summarysalesdl = (parseFloat(summarysalesdl) + ((salesdl[i] != undefined && salesdl[i] != NaN && salesdl[i] != "") ? parseFloat(salesdl[i]) :0));
        }
        for(var i=0;i<salesdlPrev.length;i++){
            summarysalesdlPrev = (parseFloat(summarysalesdlPrev) + ((salesdlPrev[i] != undefined && salesdlPrev[i] != NaN && salesdlPrev[i] != "") ? parseFloat(salesdlPrev[i]) :0));
        }
        for(var i=0;i<units.length;i++){
            summaryunits = (parseFloat(summaryunits) + ((units[i] != undefined && units[i] != NaN && units[i] != "") ? parseFloat(units[i]) :0));
        }
        for(var i=0;i<unitsPrev.length;i++){
            summaryunitsPrev = (parseFloat(summaryunitsPrev) + ((unitsPrev[i] != undefined && unitsPrev[i] != NaN && unitsPrev[i] != "") ? parseFloat(unitsPrev[i]) :0));
            
        }  
        var Q1sumSales=0;
        var Q1sumUnits=0;
        console.log('summarysalesdlg======'+summarysalesdl);
        console.log('summarysalesdlPrevg======'+summarysalesdlPrev);
        Q1sumSales = summarysalesdl +summarysalesdlPrev;
        Q1sumUnits = summaryunits+summaryunitsPrev;
        component.set("v.Q1sumSales",Q1sumSales);
        component.set("v.Q1sumUnits",Q1sumUnits);
        component.set("v.summarysalesdl",summarysalesdl);
        component.set("v.summarysalesdlPrev",summarysalesdlPrev);
        component.set("v.summaryunits",summaryunits);
        component.set("v.summaryunitsPrev",summaryunitsPrev);
        
        console.log("v.summaryObject",component.get("v.summaryObject"));
        /*else{
            component.set("v.chartobj1",chartobj1);
            component.set("v.chartobj2",chartobj2);
            component.set("v.chartobj3",chartobj3);
            component.set("v.chartobj4",chartobj4);
        }*/
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