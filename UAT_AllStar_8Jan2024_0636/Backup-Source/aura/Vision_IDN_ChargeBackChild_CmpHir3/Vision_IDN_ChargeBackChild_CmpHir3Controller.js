({
	doInit: function(component, event, helper){
        component.set("v.xAxisLabels2",component.get("v.xAxisLabels"));
      // helper.getAllTotals(component,event,helper);
        //console.log('each record contractDescName==>'+JSON.stringify(component.get("v.record.contractNumber")))
           var idnchargebackList = component.get("v.record.idnchargebackList");
        component.set("v.idnchargebackList",idnchargebackList);
        component.set("v.contractDescName",component.get("v.record.contractDescName"))
        /*for summary of each contract*/
        var currentfirstc1productFamilyList = [];
        var currentsecc2productFamilyList = [];
        var currentthirdc3productFamilyList = [];
        var currentfourthc4productFamilyList = [];
        var currentfifthc5productFamilyList = [];
        var currentsixthc6productFamilyList = [];
        var firstColSalesSummary = 0;
        var firstColUnitsSummary = 0;
        var secColSalesSummary = 0;
        var secColUnitsSummary = 0;
        var thirdColSalesSummary = 0;
        var thirdColUnitsSummary = 0;
        var fourthColSalesSummary = 0;
        var fourthColUnitsSummary = 0;
        var fifthColSalesSummary = 0;
        var fifthColUnitsSummary = 0;
        var sixthColSalesSummary = 0;
        var sixthColUnitsSummary = 0;
        var totalofSalesSummary = 0;
        var totalofUnitsSummary =0;
        var avgofSalesSummary;
        var avgofUnitsSummary ;
          var salesListMonthWise =[];
         var unitsListMonthWise =[];
          if(idnchargebackList != null){
               idnchargebackList.forEach(function(rec){
              //console.log('in idnchargebackList loop')
              var salesPrice = (rec.Contract_Sales_Indirect_Price__c != null || rec.Contract_Sales_Indirect_Price__c != undefined) ? rec.Contract_Sales_Indirect_Price__c : 0;
               var units = (rec.contract_units_paid_qty__c != null || rec.contract_units_paid_qty__c != undefined) ? rec.contract_units_paid_qty__c : 0;
              	 if(rec.Month_Year__c == component.get("v.firstColumnKey")){
                                           firstColSalesSummary += Math.round((salesPrice + Number.EPSILON) * 100) / 100;
                                           firstColUnitsSummary +=  Math.round(units);
                                           currentfirstc1productFamilyList.push(rec.revised_product_family__c);
                                           
                                       }
                                       if(rec.Month_Year__c == component.get("v.secondColumnKey")){
                                           secColSalesSummary += Math.round((salesPrice + Number.EPSILON) * 100) / 100;
                                           secColUnitsSummary +=  Math.round(units);
                                           currentsecc2productFamilyList.push(rec.revised_product_family__c);
                                           
                                       }
                                       if(rec.Month_Year__c == component.get("v.thirdColumnKey")){
                                           thirdColSalesSummary += Math.round((salesPrice + Number.EPSILON) * 100) / 100;
                                           thirdColUnitsSummary +=  Math.round(units);
                                           currentthirdc3productFamilyList.push(rec.revised_product_family__c);
                                           
                                       }
                                       if(rec.Month_Year__c == component.get("v.fourthColumnKey")){
                                           fourthColSalesSummary += Math.round((salesPrice + Number.EPSILON) * 100) / 100;
                                           fourthColUnitsSummary +=  Math.round(units);
                                           currentfourthc4productFamilyList.push(rec.revised_product_family__c);
                                           
                                       }
                                       if(rec.Month_Year__c == component.get("v.fifthColumnKey")){
                                           fifthColSalesSummary += Math.round((salesPrice + Number.EPSILON) * 100) / 100;
                                           fifthColUnitsSummary +=  Math.round(units);
                                           currentfifthc5productFamilyList.push(rec.revised_product_family__c);
                                          
                                       }
                                       if(rec.Month_Year__c == component.get("v.sixthColumnKey")){
                                           sixthColSalesSummary += Math.round((salesPrice + Number.EPSILON) * 100) / 100;
                                           sixthColUnitsSummary +=  Math.round(units);
                                           currentsixthc6productFamilyList.push(rec.revised_product_family__c);
                                           
                                       }
               });
               /*for dual graph*/
            salesListMonthWise.push(firstColSalesSummary);
            salesListMonthWise.push(secColSalesSummary);
            salesListMonthWise.push(thirdColSalesSummary);
            salesListMonthWise.push(fourthColSalesSummary);
             salesListMonthWise.push(fifthColSalesSummary);
            salesListMonthWise.push(sixthColSalesSummary);
            unitsListMonthWise.push(firstColUnitsSummary);
            unitsListMonthWise.push(secColUnitsSummary);
            unitsListMonthWise.push(thirdColUnitsSummary);
            unitsListMonthWise.push(fourthColUnitsSummary);
             unitsListMonthWise.push(fifthColUnitsSummary);
            unitsListMonthWise.push(sixthColUnitsSummary);
            /*end for dual graph*/
              /*for highliting contract*/
            console.log('salesListMonthWise==>'+salesListMonthWise.length)
            for(var i=0;i<salesListMonthWise.length;i++){
                if(salesListMonthWise[i] == 0 && salesListMonthWise[i+1] ==0){
                    component.set("v.highlightcontract",true);
                }
            }
            /*end for highliting contract*/
              totalofSalesSummary = firstColSalesSummary + secColSalesSummary + thirdColSalesSummary + fourthColSalesSummary +fifthColSalesSummary +sixthColSalesSummary; 
              totalofUnitsSummary = firstColUnitsSummary + secColUnitsSummary + thirdColUnitsSummary + fourthColUnitsSummary + fifthColUnitsSummary + sixthColUnitsSummary;
              avgofSalesSummary =  Math.round(((totalofSalesSummary / 6) + Number.EPSILON) * 100) / 100;//Math.round(totalofSalesSummary / 6);
              avgofUnitsSummary =  Math.round(totalofUnitsSummary / 6);
              component.set("v.firstColSalesSummary",firstColSalesSummary);
              component.set("v.firstColUnitsSummary",firstColUnitsSummary);
              component.set("v.secColSalesSummary",secColSalesSummary);
              component.set("v.secColUnitsSummary",secColUnitsSummary);
              component.set("v.thirdColSalesSummary",thirdColSalesSummary);
              component.set("v.thirdColUnitsSummary",thirdColUnitsSummary);
              component.set("v.fourthColSalesSummary",fourthColSalesSummary);
              component.set("v.fourthColUnitsSummary",fourthColUnitsSummary);
              component.set("v.fifthColSalesSummary",fifthColSalesSummary);
              component.set("v.fifthColUnitsSummary",fifthColUnitsSummary);
              component.set("v.sixthColSalesSummary",sixthColSalesSummary);
              component.set("v.sixthColUnitsSummary",sixthColUnitsSummary);
              component.set("v.totalofSalesSummary",totalofSalesSummary);
              component.set("v.totalofUnitsSummary",totalofUnitsSummary);
              component.set("v.avgofSalesSummary",avgofSalesSummary);
              component.set("v.avgofUnitsSummary",avgofUnitsSummary);
              /*for stacked graph with pfamily*/
              component.set("v.currentfirstc1productFamilyList",currentfirstc1productFamilyList);
              component.set("v.currentsecc2productFamilyList",currentsecc2productFamilyList);
              component.set("v.currentthirdc3productFamilyList",currentthirdc3productFamilyList);
              component.set("v.currentfourthc4productFamilyList",currentfourthc4productFamilyList);
              component.set("v.currentfifthc5productFamilyList",currentfifthc5productFamilyList);
              component.set("v.currentsixthc6productFamilyList",currentsixthc6productFamilyList);
              /*for stacked graph with pfamily*/
              /*for dual graph*/
              component.set("v.salesListMonthWise",salesListMonthWise);
              component.set("v.unitsListMonthWise",unitsListMonthWise);
              /*for dual graph*/
              /*for highliting hospital*/
            console.log('salesListMonthWise==>'+salesListMonthWise.length)
            for(var i=0;i<salesListMonthWise.length;i++){
                if(salesListMonthWise[i] == 0 && salesListMonthWise[i+1] ==0){
                    component.set("v.highlightHsptl",true);
                }
            }
            /*end for highliting hospital*/
              var yAxisLabelsSales =[firstColSalesSummary,secColSalesSummary,thirdColSalesSummary,fourthColSalesSummary,fifthColSalesSummary,sixthColSalesSummary];
              var yAxisLabelsUnits =[firstColUnitsSummary,secColUnitsSummary,thirdColUnitsSummary,fourthColUnitsSummary,fifthColUnitsSummary,sixthColUnitsSummary];
              
              component.set("v.yAxisLabelsSales",yAxisLabelsSales);
              component.set("v.yAxisLabelsUnits",yAxisLabelsUnits);
              helper.getAllTotalsforIndividual(component,event,helper); 
          }
    },
    handleClick1: function(component, event, helper){
        component.set("v.expandContract", true);
        component.set("v.record.showItem", false);
        var contractrelatedList = component.get("v.record.idnchargebackList");
        
        var hospitalmapObj ={};
        var allData= [];
        contractrelatedList.forEach(function(rec){
            console.log('test==>'+rec.Hospital_Name__c);
            if(hospitalmapObj.hasOwnProperty(rec.Hospital_Name__c)){
                console.log('inside if==>'+rec.Hospital_Name__c);
                var relatedList = hospitalmapObj[rec.Hospital_Name__c];
                relatedList.push(rec);
                hospitalmapObj[rec.Hospital_Name__c] = relatedList;
                
            }
            else{
                console.log('inside else==>');
                var relatedList =[];
                relatedList.push(rec);
                hospitalmapObj[rec.Hospital_Name__c] = relatedList;
                
            }
            
        });
        var keys = Object.keys(hospitalmapObj);
        var allData = [];
        for(var i=0; i<keys.length; i++){
            var obj = {};
            var relatedList = hospitalmapObj[keys[i]];
            obj.showChild1= true;
            obj.showChild= true;
            obj.hospitalName = keys[i];
            obj.hospitalrelatedList = relatedList;
            
            allData.push(obj);
}
         
        // console.log('length==>'+hospitalrelatedList.length);
       console.log('hospitalmapObj===>'+JSON.stringify(hospitalmapObj));
        component.set("v.child1List",allData);
         console.log('child1 allData===>'+JSON.stringify(allData));
        /* for sorting*/
        var testREc = component.get("v.child1List");
        console.log('testREc==>'+JSON.stringify(testREc));
        var hospitialMap = new Map();
        var SalesList = new Array();
        var listOfWrappers=[];
        testREc.forEach(function(eachRec){
            var relatedList = eachRec.hospitalrelatedList;
            var totalVal=0;
            relatedList.forEach(function(chargeBackRec){
                var salesPrice = (chargeBackRec.Contract_Sales_Indirect_Price__c != null && chargeBackRec.Contract_Sales_Indirect_Price__c != undefined) ? chargeBackRec.Contract_Sales_Indirect_Price__c : 0;
                totalVal= totalVal + salesPrice;
                
            });
            totalVal=Math.round(totalVal/6);
            
            
            var mainWrap = {'AverageSales':totalVal,
                            'eachHospital':eachRec
                           };
            listOfWrappers.push(mainWrap);
            
        });
        
        listOfWrappers.sort((a,b) => (a.AverageSales > b.AverageSales) ? -1 : ((b.AverageSales > a.AverageSales) ? 1 : 0));
        var finaList = [];
        listOfWrappers.forEach(function(eachREc){
            finaList.push(eachREc.eachHospital);
          
            
        });
        component.set("v.child1List",finaList);
        /*end for sorting*/
    },
      handleClick2: function(component, event, helper){
        //console.log("indexxx==>"+component.get("v.index"))
        component.set("v.expandContract", false);
        component.set("v.record.showItem", true);
      },
     comparingSales:function(component, event, helper){
        var total12monthsales = component.get("v.twmonthsSalesTotal")
        var current6monthsales = component.get("v.totalofSalesSummary")
        var prev6monthsSales = component.get("v.twmonthsSalesTotal") - component.get("v.totalofSalesSummary") ;
        var salesPercentage = prev6monthsSales != 0 ? (( current6monthsales - prev6monthsSales )/prev6monthsSales) *100 : 0;
        component.set("v.prev6monthsSales",prev6monthsSales);
        component.set("v.salesPercentage",Math.round(salesPercentage * 100) / 100); 
    },
     comparingUnits:function(component, event, helper){
        var total12monthunits = component.get("v.twmonthsUnitsTotal")
        var current6monthunits = component.get("v.totalofUnitsSummary")
        var prev6monthsUnits = component.get("v.twmonthsUnitsTotal") - component.get("v.totalofUnitsSummary") ;
       var unitsPercentage = prev6monthsUnits != 0 ? (( current6monthunits - prev6monthsUnits )/prev6monthsUnits) *100 : 0;
         console.log('unitsPercentage==>'+unitsPercentage);
        component.set("v.prev6monthsUnits",prev6monthsUnits);
        component.set("v.unitsPercentage",Math.round(unitsPercentage * 100) / 100);
     },
     displayChart: function(component, event, helper){
        component.set("v.isModalOpen", true);
        component.set("v.showChart", true);
        component.set("v.chartType", 'Bar');
        var selectedContract = event.getSource().get("v.value");
        console.log('selectedHospital: '+selectedContract);
          var parentComponent = component.get("v.parent");                         
		parentComponent.greetingMethod("displayChart")
     },
     displayChartUnits:function(component, event, helper){
        component.set("v.isModalOpenUnits", true);
        component.set("v.showChart", true);
        component.set("v.chartType", 'Bar');
        component.set("v.dualChart", 'Hospital');
        var selectedHospital = event.getSource().get("v.value");
        console.log('selectedHospital: '+selectedHospital);
          var parentComponent = component.get("v.parent");                         
		parentComponent.greetingMethod("displayChart")
        
        var idnchargebackList = component.get("v.record.idnchargebackList");
         console.log('idnchargebackList in child??==>'+JSON.stringify(idnchargebackList));
        
      /*  console.log('y axis labels==>'+component.get("v.yAxisLabelsSales"));
        var yaxisLabels = component.get("v.yAxisLabelsUnits");
        var xaxisLabels = ['Mar-23','Feb-23','Jan-23','Dec-22','Nov-22','Oct-22'];
         var highChartData = [];
      
        for(var i=0; i<xaxisLabels.length; i++){
              var obj = {};
         obj.name = xaxisLabels[i];
                //obj.color = color;
                obj.data = [{name: xaxisLabels[i], y: yaxisLabels[i], x: i}];
          highChartData.push(obj);
         }
        console.log('highChartData'+JSON.stringify(highChartData));
       component.set("v.highChartData",highChartData);*/
     
    },
    closeModal: function(component, event, helper){
        component.set("v.isModalOpen", false);
          var parentComponent = component.get("v.parent");                         
		parentComponent.greetingMethod("closeChart")
         
    },
     closeModalUnits: function(component, event, helper){
        component.set("v.isModalOpenUnits", false);
           var parentComponent = component.get("v.parent");                         
		parentComponent.greetingMethod("closeChart")
         
    },
})