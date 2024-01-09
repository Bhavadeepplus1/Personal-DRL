({
	 initCharts: function(component, event, helper){
          component.set("v.isExportJSLoaded",true);
         var materialDescRelatedList = component.get("v.materialDescRelatedList");
		console.log('materialDescRelatedList<<<'+JSON.stringify(materialDescRelatedList))
         var allcontractsDescriptionlist = component.get("v.allcontractsDescriptionlist");
       
          /*family wise data*/
         var contractdescriptionmapObj ={};
        var allData= [];
        materialDescRelatedList.forEach(function(rec){
            
            if(contractdescriptionmapObj.hasOwnProperty(rec.Contact_Description__c)){
                console.log('inside if==>'+rec.material_description__c);
                var relatedList = contractdescriptionmapObj[rec.Contact_Description__c];
                relatedList.push(rec);
                contractdescriptionmapObj[rec.Contact_Description__c] = relatedList;
                
            }
            else{
                console.log('inside else==>');
                var relatedList =[];
                relatedList.push(rec);
                contractdescriptionmapObj[rec.Contact_Description__c] = relatedList;
                
            }
            
        });
         var keys = Object.keys(contractdescriptionmapObj);
        var allData = [];
        for(var i=0; i<keys.length; i++){
            var obj = {};
            var relatedList = contractdescriptionmapObj[keys[i]];
            obj.contractDesc= keys[i];
            obj.contractDescctRelatedList = relatedList;
            
            allData.push(obj);
        }
         console.log('all data==>'+JSON.stringify(allData))
          
          var currentKeysList = component.get("v.xAxisLabels");
         let uniqueContractDescptions = [];
          allcontractsDescriptionlist.forEach(function(rec){
              if (!uniqueContractDescptions.includes(rec)) {
                uniqueContractDescptions.push(rec);
            }
          })
          console.log('uniqueContractDescptions===>'+uniqueContractDescptions[0])
         var tempList = [];
         for(var i=0;i<allData.length;i++){
             console.log('allData[i].pfamilyRelatedList'+JSON.stringify(allData[i].contractDescctRelatedList))
             var contractDescSummary = 0; 
             var tempObj = {}; var contractdescMap = {};
             allData[i].contractDescctRelatedList.forEach(function(rec){
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
                 console.log('allData[i].materialDesc'+allData[i].contractDesc)
                 
                 for(var j=0;j<uniqueContractDescptions.length;j++){
                     if(allData[i].contractDesc == uniqueContractDescptions[j]){
                         for(var k=0;k<currentKeysList.length;k++){
                             if(rec.Month_Year__c == currentKeysList[k]){
                                 console.log('currentKeysList'+currentKeysList[k]);
                                 contractDescSummary += Math.round(salesPrice);
                             }
                         }
                     }
                 } 
                 
         });
             console.log('materailSummary==satya==>'+contractDescSummary);
             contractdescMap.contractDesc = allData[i].contractDesc;
             contractdescMap.dataValues = tempObj;
             tempList.push(contractdescMap);
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
             seriesObj.name =tempList[i].contractDesc;
             seriesObj.data =values;
             seriesData.push(seriesObj);
         console.log('keys??=='+keys)
         console.log('values==>??'+values);
             
     }
          console.log('seriesData==>??'+JSON.stringify(seriesData));
          component.set("v.seriesData",seriesData);
         /* end family wise data*/
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
                    renderTo: component.find("materialDescLevelChart").getElement(),
                    type: 'column',
                    height: '500px', // 16:9 ratio
                },
                title: {
                    text: component.get("v.materialDescName"),
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
                },
               
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
                series: component.get("v.seriesData"),
              
                 
               
              
            });   
        } 
     }
})