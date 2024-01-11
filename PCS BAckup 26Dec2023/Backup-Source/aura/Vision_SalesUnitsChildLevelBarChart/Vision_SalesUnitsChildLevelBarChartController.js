({
	 initCharts: function(component, event, helper){
          component.set("v.isExportJSLoaded",true);
        var child1relatedList = component.get("v.child1relatedList");
         var child1PFamilyList =  component.get("v.child1PFamilyList");
         /*family wise data*/
         var pfamilymapObj ={};
        var allData= [];
        child1relatedList.forEach(function(rec){
            
            if(pfamilymapObj.hasOwnProperty(rec.revised_product_family__c)){
                console.log('inside if==>'+rec.revised_product_family__c);
                var relatedList = pfamilymapObj[rec.revised_product_family__c];
                relatedList.push(rec);
                pfamilymapObj[rec.revised_product_family__c] = relatedList;
                
            }
            else{
                console.log('inside else==>');
                var relatedList =[];
                relatedList.push(rec);
                pfamilymapObj[rec.revised_product_family__c] = relatedList;
                
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
          child1PFamilyList.forEach(function(rec){
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
                 if(tempObj.hasOwnProperty(rec.Month_Year__c)){
                     var salesPrice = tempObj[rec.Month_Year__c];
                     salesPrice += Math.round(rec.Contract_Sales_Indirect_Price__c);
                     tempObj[rec.Month_Year__c] = salesPrice;
                 } else{
                     var salesPrice = Math.round(rec.Contract_Sales_Indirect_Price__c);
                     tempObj[rec.Month_Year__c] = salesPrice;
                 }
                 var salesPrice = (rec.Contract_Sales_Indirect_Price__c != null || rec.Contract_Sales_Indirect_Price__c != undefined) ? rec.Contract_Sales_Indirect_Price__c : 0;
                 var units = (rec.contract_units_paid_qty__c != null || rec.contract_units_paid_qty__c != undefined) ? rec.contract_units_paid_qty__c : 0;
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
          
          component.set("v.seriesData",seriesData);
         console.log('seriesData==>??test'+JSON.stringify(component.get("v.seriesData")));
         /* end family wise data*/
console.log('seriesData lables=>??'+component.get("v.xAxisLabels"));
          var yAxisLabelsSales = component.get("v.yAxisLabelsSales");
        var chartType = component.get("v.chartType");
             if(chartType == 'Bar'){
            new Highcharts.Chart({
                 chart: {
                    renderTo: component.find("childLevelchart").getElement(),
                    type: 'column',
                    height: '500px', // 16:9 ratio
                },
                title: {
                    text: component.get("v.child1Name"),
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
                    }
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
                    pointFormat: '{series.name}: {point.y}<br/>Total: ${point.stackTotal}',
                    valuePrefix: '$',
                },
               
                plotOptions: {
                    column: {
                        stacking: 'normal',
                        dataLabels: {
                            enabled: true
                        }
                    }
                },
                series: component.get("v.seriesData"),
               /* [{
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
               */
              
            });   
        } 
     }
})