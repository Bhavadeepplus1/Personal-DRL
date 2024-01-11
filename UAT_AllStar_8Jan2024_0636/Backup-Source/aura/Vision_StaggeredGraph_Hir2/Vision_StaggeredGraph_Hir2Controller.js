({
	 initCharts: function(component, event, helper){
          component.set("v.isExportJSLoaded",true);
        var child1List = component.get("v.child1List");
         console.log('child1List==>'+JSON.stringify(child1List))
          console.log('yAxisLabelsSales==>'+component.get("v.yAxisLabelsSales"))
          console.log('pfamily list==>'+component.get("v.currentfirstc1productFamilyList"))
          console.log('idnchargebackList==>'+JSON.stringify(component.get("v.idnchargebackList")))
          var currentfirstc1productFamilyList = component.get("v.currentfirstc1productFamilyList");
         var idnchargebackList = component.get("v.idnchargebackList");
         /*family wise data*/
         var pfamilymapObj ={};
        var allData= [];
        idnchargebackList.forEach(function(rec){
            
            if(pfamilymapObj.hasOwnProperty(rec.T2_revised_product_family__c)){
                console.log('inside if==>'+rec.T2_revised_product_family__c);
                var relatedList = pfamilymapObj[rec.T2_revised_product_family__c];
                relatedList.push(rec);
                pfamilymapObj[rec.T2_revised_product_family__c] = relatedList;
                
            }
            else{
                console.log('inside else==>');
                var relatedList =[];
                relatedList.push(rec);
                pfamilymapObj[rec.T2_revised_product_family__c] = relatedList;
                
            }
            
        });
         var keys = Object.keys(pfamilymapObj);
        var allData = [];
        for(var i=0; i<keys.length; i++){
            var obj = {};
            var relatedList = pfamilymapObj[keys[i]];
            obj.pfamily = keys[i];
            obj.pfamilyRelatedList = relatedList;
            
            allData.push(obj);
        }
         console.log('all data==>'+JSON.stringify(allData))
          
          var currentKeysList = component.get("v.xAxisLabels");
         let uniqueFamilies = [];
          currentfirstc1productFamilyList.forEach(function(rec){
              if (!uniqueFamilies.includes(rec)) {
                uniqueFamilies.push(rec);
            }
          })
          console.log('uniqueFamilies===>'+uniqueFamilies[0])
         var tempList = [];
         for(var i=0;i<allData.length;i++){
             console.log('allData[i].pfamilyRelatedList'+JSON.stringify(allData[i].pfamilyRelatedList))
             var pfam1Summary = 0; 
             var tempObj = {}; var familyMap = {};
             allData[i].pfamilyRelatedList.forEach(function(rec){
                 if(tempObj.hasOwnProperty(rec.T2_Month_Year__c)){
                     var salesPrice = tempObj[rec.T2_Month_Year__c];
                     salesPrice += Math.round(rec.T2_Contract_Sales_Indirect_Price__c);
                     tempObj[rec.T2_Month_Year__c] = salesPrice;
                 } else{
                     var salesPrice = Math.round(rec.T2_Contract_Sales_Indirect_Price__c);
                     tempObj[rec.T2_Month_Year__c] = salesPrice;
                 }
                 var salesPrice = (rec.T2_Contract_Sales_Indirect_Price__c != null || rec.T2_Contract_Sales_Indirect_Price__c != undefined) ? rec.T2_Contract_Sales_Indirect_Price__c : 0;
                 var units = (rec.T2_contract_units_paid_qty__c != null || rec.T2_contract_units_paid_qty__c != undefined) ? rec.T2_contract_units_paid_qty__c : 0;
                 console.log('allData[i].pfamily'+allData[i].pfamily)
                 
                 for(var j=0;j<uniqueFamilies.length;j++){
                     if(allData[i].pfamily == uniqueFamilies[j]){
                         for(var k=0;k<currentKeysList.length;k++){
                             if(rec.Month_Year__c == currentKeysList[k]){
                                 console.log('currentKeysList'+currentKeysList[k]);
                                 pfam1Summary += Math.round(salesPrice);
                             }
                         }
                     }
                 } 
                 
         });
             console.log('pfam1Summary==satya==>'+pfam1Summary);
             familyMap.family = allData[i].pfamily;
             familyMap.dataValues = tempObj;
             tempList.push(familyMap);
         }
         console.log('templist==>'+JSON.stringify(tempList));
      	var seriesData = [];
         
         for(var i=0; i<tempList.length; i++){
             var seriesObj = {};
             var monthwiseValues = tempList[i].dataValues;
              var keys = Object.keys(monthwiseValues);
             var values = [];
             for(var j=0; j<currentKeysList.length; j++){
             if(monthwiseValues.hasOwnProperty(currentKeysList[j])){
                 values.push(monthwiseValues[currentKeysList[j]]);
             } else{
                 values.push(0);
             }
         }
             seriesObj.name =tempList[i].family;
             seriesObj.data =values;
             seriesData.push(seriesObj);
         console.log('keys??=='+keys)
         console.log('values==>??'+values);
             
     }
          console.log('seriesData==>??'+JSON.stringify(seriesData));
          component.set("v.seriesData",seriesData);
         /* end family wise data*/
        
        
         var data1=[]
         
        
         
         
        /*  for(var i=0;i< uniqueFamilies.length ; i++){   
         	idnchargebackList.forEach(function(rec){
             var salesPrice = (rec.Contract_Sales_Indirect_Price__c != null || rec.Contract_Sales_Indirect_Price__c != undefined) ? rec.Contract_Sales_Indirect_Price__c : 0;
               var units = (rec.contract_units_paid_qty__c != null || rec.contract_units_paid_qty__c != undefined) ? rec.contract_units_paid_qty__c : 0;

             	
                 if(rec.revised_product_family__c == uniqueFamilies[i]){
                     
                     if(rec.Month_Year__c == currentKeysList[0]){
                         console.log('rec.Month_Year__c'+rec.Month_Year__c);
                     console.log('currentKeysList[0]'+currentKeysList[0]);
                          pfam1Summary += Math.round(salesPrice);
                     }
                 }
                
             })
            console.log('pfam1Summary==>'+pfam1Summary);
         }*/
          
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
                     
                     events: {
                         legendItemClick: function (event) {
                             event.preventDefault()
                             return
                         }
                     },
                 },
                title: {
                    text: component.get("v.hospitalName"),
                    style: {
                            fontWeight: 'bold'
                        }
                },
                subtitle: {
                    text: 'Sales by Months'
                },
                xAxis: {
                   // type: 'category',
                    categories: component.get("v.xAxisLabels"),
                    //allowDecimals: false,
                    //crosshair: true,
                    textAlign: 'center',
                    title: {
                        text: "Month",
                        style: {
                            fontWeight: 'bold'
                        }
                    },
                    
                },
                yAxis: {
                    min: 0,
                    //allowDecimals: false,
                    title: {
                        text: "Sales in $",
                        style: {
                            fontWeight: 'bold'
                        }
                    },
                    stackLabels: {
                        enabled: true,
                      
                        formatter: function () {
                            return '$' + Highcharts.numberFormat(this.total,0, '.', ',');
                            //return '$' + Highcharts.numberFormat(this.total, 1, '.', ',');
                        }
                        
                    },
                  
                },
               
                stackLabels: {
                    enabled: true,
                    style: {
                        fontWeight: 'bold',
                        color: ( // theme
                            Highcharts.defaultOptions.title.style &&
                            Highcharts.defaultOptions.title.style.color
                        ) || 'gray',
                        textOutline: 'none'
                    }
                },
            
                legend: {
                    align: 'right',
                    verticalAlign: 'middle',
                    layout: 'vertical',
                    itemDistance: 100
                },
                tooltip: {
                    headerFormat: '<b>{point.x}</b><br/>',
                    pointFormat: '{series.name}: {point.y}',
                    //<br/>Total: ${point.stackTotal}
                
                    valuePrefix: '$',
                    lang: {
                        decimalPoint: '.',
                        thousandsSep: ',',
                    },
                    
                    
                },
                /*tooltip: 
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
                },*/
                plotOptions: {
                    column: {
                        stacking: 'normal',
                        dataLabels: {
                            enabled: true,
                           // format: '$ {y}', // your label's value plus the percentage sign
        					format: '${y:,.0f}',
                        }
                    },
                     series: {
                        events: {
                            legendItemClick: function () {
                                console.log('this.visible==>'+this.visible)
                               if (!this.visible){
                                    console.log('yess')
                                    return true;
                                }
                              
                                var seriesIndex = this.index;
                                var series = this.chart.series;
                                var isAllOpen= true;
                                for (var i = 0; i < series.length; i++){
                                    if(!series[i].visible){
                                        isAllOpen=false;
                                    }
                                }
                                for (var i = 0; i < series.length; i++)
                                {
                                    if (series[i].index == seriesIndex){
                                        if(!isAllOpen){
                                            if(!series[i].visible){
                                                series[i].show();
                                            }else{
                                                series[i].hide();
                                            }
                                        }
                                           
                                        }else{
                                            if(isAllOpen){
                                                if(!series[i].visible){
                                                    series[i].show();
                                                }else{
                                                    series[i].hide();
                                                }
                                            }
                                            
                                             //series[i].hide();
                                        }
                                     
                                }
                              
                               return false;
                                //return false; // <== returning false will cancel the default action
                            }
                        },
                        
                        showInLegend: true
                        
                    }
                    
                    
                },
                series:  component.get("v.seriesData"),
              /*  [{
                    name: 'Thiotepa',
                    data: [29280, 7056, 37092, 2880, 13672, 14997 ]
                }, {
                    name: 'Clofarabine',
                    data: [0, 0, 6000, 0, 0, 0]
                }, {
                    name: 'Desmopressin',
                    data: [3292, 0, 400, 1935, 2200, 0]
                },
                  {
                    name: 'Pemetrexed',
                    data: [2400, 945, 2535, 3750, 2100, 105]
                },
                 {
                    name: 'Phytoniadone',
                    data: [3564, 1188, 2376, 1782, 3564, 1188]
                },
                {
                    name: 'Propofol',
                    data: [1300, 0, 1200, 0, 0, 100]
                },
                 {
                    name: 'Azacitidine',
                    data: [0, 0, 1353, 1198, 655, 0]
                },
                          
                        ],
               
                series: 
                [
                    {
                        name: 'Oct-22',
                        data: [
                            {
                                "y": yAxisLabelsSales[0],
                                "x": 0
                            },
                            
                        ]
                     },
                      {
                        name: 'Nov-22',
                        data: [
                            {
                                "y": yAxisLabelsSales[1],
                                "x": 1
                            },
                            
                        ]
                     },
                    {
                        name: 'Dec-22',
                        data: [
                            {
                                "y": yAxisLabelsSales[2],
                                "x": 2
                            },
                            
                        ]
                     },
                      {
                        name: 'Jan-23',
                        data: [
                            {
                                "y": yAxisLabelsSales[3],
                                "x": 3
                            },
                            
                        ]
                     },
                    {
                        name: 'Feb-23',
                        data: [
                            {
                                "y": yAxisLabelsSales[4],
                                "x": 4
                            },
                            
                        ]
                     },
                             {
                      name: 'Mar-23',
                        data: [
                            {
                                "y": yAxisLabelsSales[5],
                                "x": 5
                            },
                            
                        ]
                     },
                 
             
                        ],*/
              /*  navigation: {
                    buttonOptions: {
                        enabled: true
                    }
                }*/
            });   
        } 
     }
})