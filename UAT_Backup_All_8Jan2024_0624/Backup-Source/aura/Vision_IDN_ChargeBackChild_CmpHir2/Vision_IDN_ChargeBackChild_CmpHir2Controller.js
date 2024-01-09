({
    doInit: function(component, event, helper){
         component.set("v.xAxisLabels2",component.get("v.xAxisLabels"));
         helper.getAllTotalsforIndividual(component,event,helper);
        var idnchargebackList = component.get("v.record.idnchargebackList");
        component.set("v.idnchargebackList",idnchargebackList);
        var previdnchargebackList = component.get("v.prevSixMnthschargebackList");//component.get("v.prevrecord.idnchargebackList");
        
        console.log('record idnchargebackList==>'+JSON.stringify(component.get("v.record.hospitalName")))
        console.log('childcmp idnchargebackList==>'+JSON.stringify(previdnchargebackList))
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
              console.log('in idnchargebackList loop')
              var salesPrice = (rec.T2_Contract_Sales_Indirect_Price__c != null || rec.T2_Contract_Sales_Indirect_Price__c != undefined) ? rec.T2_Contract_Sales_Indirect_Price__c : 0;
               var units = (rec.T2_contract_units_paid_qty__c != null || rec.T2_contract_units_paid_qty__c != undefined) ? rec.T2_contract_units_paid_qty__c : 0;
                                       if(rec.T2_Month_Year__c == component.get("v.firstColumnKey")){
                                           firstColSalesSummary += Math.round((salesPrice + Number.EPSILON) * 100) / 100;
                                           firstColUnitsSummary +=  Math.round(units);
                                           currentfirstc1productFamilyList.push(rec.T2_revised_product_family__c);
                                           
                                       }
                                       if(rec.T2_Month_Year__c == component.get("v.secondColumnKey")){
                                           secColSalesSummary += Math.round((salesPrice + Number.EPSILON) * 100) / 100;
                                           secColUnitsSummary +=  Math.round(units);
                                           currentsecc2productFamilyList.push(rec.T2_revised_product_family__c);
                                           
                                       }
                                       if(rec.T2_Month_Year__c == component.get("v.thirdColumnKey")){
                                           thirdColSalesSummary += Math.round((salesPrice + Number.EPSILON) * 100) / 100;
                                           thirdColUnitsSummary +=  Math.round(units);
                                           currentthirdc3productFamilyList.push(rec.T2_revised_product_family__c);
                                           
                                       }
                                       if(rec.T2_Month_Year__c == component.get("v.fourthColumnKey")){
                                           fourthColSalesSummary += Math.round((salesPrice + Number.EPSILON) * 100) / 100;
                                           fourthColUnitsSummary +=  Math.round(units);
                                           currentfourthc4productFamilyList.push(rec.T2_revised_product_family__c);
                                           
                                       }
                                       if(rec.T2_Month_Year__c == component.get("v.fifthColumnKey")){
                                           fifthColSalesSummary += Math.round((salesPrice + Number.EPSILON) * 100) / 100;
                                           fifthColUnitsSummary +=  Math.round(units);
                                           currentfifthc5productFamilyList.push(rec.T2_revised_product_family__c);
                                          
                                       }
                                       if(rec.T2_Month_Year__c == component.get("v.sixthColumnKey")){
                                           sixthColSalesSummary += Math.round((salesPrice + Number.EPSILON) * 100) / 100;
                                           sixthColUnitsSummary +=  Math.round(units);
                                           currentsixthc6productFamilyList.push(rec.T2_revised_product_family__c);
                                           
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
            /*for highliting hospital*/
            console.log('salesListMonthWise==>'+salesListMonthWise.length)
            for(var i=0;i<salesListMonthWise.length;i++){
                if(salesListMonthWise[i] == 0 && salesListMonthWise[i+1] ==0){
                    component.set("v.highlightHsptl",true);
                }
            }
            /*end for highliting hospital*/
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
            var yAxisLabelsSales =[firstColSalesSummary,secColSalesSummary,thirdColSalesSummary,fourthColSalesSummary,fifthColSalesSummary,sixthColSalesSummary];
   		var yAxisLabelsUnits =[firstColUnitsSummary,secColUnitsSummary,thirdColUnitsSummary,fourthColUnitsSummary,fifthColUnitsSummary,sixthColUnitsSummary];

        component.set("v.yAxisLabelsSales",yAxisLabelsSales);
        component.set("v.yAxisLabelsUnits",yAxisLabelsUnits);
		/*for dual graph*/
           
        /*for dual graph*/  
        }
    },
	handleClick1: function(component, event, helper){
        component.set("v.expandHospital", true);
        component.set("v.record.showItem", false);
        var hospitalrelatedList = component.get("v.record.idnchargebackList");
        
        var child1mapObj ={};
        var allData= [];
        hospitalrelatedList.forEach(function(rec){
            console.log('test==>'+rec.T2_Child1_Name__c);
            if(child1mapObj.hasOwnProperty(rec.T2_Child1_Name__c)){
                console.log('inside if==>'+rec.T2_Child1_Name__c);
                var relatedList = child1mapObj[rec.T2_Child1_Name__c];
                relatedList.push(rec);
                child1mapObj[rec.T2_Child1_Name__c] = relatedList;
                
            }
            else{
                console.log('inside else==>');
                var relatedList =[];
                relatedList.push(rec);
                child1mapObj[rec.T2_Child1_Name__c] = relatedList;
                
            }
            
        });
        var keys = Object.keys(child1mapObj);
        var allData = [];
        for(var i=0; i<keys.length; i++){
            var obj = {};
            var relatedList = child1mapObj[keys[i]];
            obj.showChild1= true;
            obj.showChild= true;
            obj.child1 = keys[i];
            obj.child1RelatedList = relatedList;
            
            allData.push(obj);
        }
        component.set("v.child1List",allData);
         console.log('child1 allData===>'+JSON.stringify(allData));
        /* for sorting*/
        var testREc = component.get("v.child1List");
        console.log('testREc==>'+JSON.stringify(testREc));
        var hospitialMap = new Map();
        var SalesList = new Array();
        var listOfWrappers=[];
        testREc.forEach(function(eachRec){
            var relatedList = eachRec.child1RelatedList;
            var totalVal=0;
            relatedList.forEach(function(chargeBackRec){
                var salesPrice = (chargeBackRec.T2_Contract_Sales_Indirect_Price__c != null && chargeBackRec.T2_Contract_Sales_Indirect_Price__c != undefined) ? chargeBackRec.T2_Contract_Sales_Indirect_Price__c : 0;
                totalVal= totalVal + salesPrice;
                
            });
            totalVal=Math.round(((totalVal/6) + Number.EPSILON) * 100) / 100;//Math.round(totalVal/6);
            
            
            var mainWrap = {'AverageSales':totalVal,
                            'eachChild1':eachRec
                           };
            listOfWrappers.push(mainWrap);
            
        });
        
        listOfWrappers.sort((a,b) => (a.AverageSales > b.AverageSales) ? -1 : ((b.AverageSales > a.AverageSales) ? 1 : 0));
        var finaList = [];
        listOfWrappers.forEach(function(eachREc){
            finaList.push(eachREc.eachChild1);
            
        });
        component.set("v.child1List",finaList);
        /*end for sorting*/
    },
     handleClick2: function(component, event, helper){
        console.log("indexxx==>"+component.get("v.index"))
        component.set("v.expandHospital", false);
        component.set("v.record.showItem", true);
    },
    displayChart: function(component, event, helper){
        component.set("v.isModalOpen", true);
        component.set("v.showChart", true);
        component.set("v.chartType", 'Bar');
        var selectedHospital = event.getSource().get("v.value");
        console.log('selectedHospital: '+selectedHospital);
        var parentComponent = component.get("v.parent");                         
		parentComponent.greetingMethod("displayChart")
        
        var idnchargebackList = component.get("v.record.idnchargebackList");
         console.log('idnchargebackList in child??==>'+JSON.stringify(idnchargebackList));
        
        console.log('y axis labels==>'+component.get("v.yAxisLabelsSales"));
        var yaxisLabels = component.get("v.yAxisLabelsSales");
        var xaxisLabels = ['Oct-22','Nov-22','Dec-22','Jan-23','Feb-23','Mar-23'];
         var highChartData = [];
      
        for(var i=0; i<xaxisLabels.length; i++){
              var obj = {};
         obj.name = xaxisLabels[i];
                //obj.color = color;
                obj.data = [{name: xaxisLabels[i], y: yaxisLabels[i], x: i}];
          highChartData.push(obj);
         }
        console.log('highChartData'+JSON.stringify(highChartData));
       component.set("v.highChartData",highChartData);
    
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
        
        console.log('y axis labels==>'+component.get("v.yAxisLabelsSales"));
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
       component.set("v.highChartData",highChartData);
     
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
    handleClick: function (component, event, helper) {
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": component.get("v.record.accountId")
        });
        navEvt.fire();
    },
    comparingSales:function (component, event, helper) {
         var total12monthsales = component.get("v.twmonthsSalesTotal")
        var current6monthsales = component.get("v.totalofSalesSummary")
        var prev6monthsSales = component.get("v.twmonthsSalesTotal") - component.get("v.totalofSalesSummary") ;
       //console.log('prev6monthsSales===??'+prev6monthsSales);
        var salesPercentage = prev6monthsSales != 0 ? (( current6monthsales - prev6monthsSales )/prev6monthsSales) *100 : 0;
        component.set("v.prev6monthsSales",prev6monthsSales);
        component.set("v.salesPercentage",Math.round(salesPercentage * 100) / 100); 
    },
    comparingUnits:function (component, event, helper) {
       var total12monthunits = component.get("v.twmonthsUnitsTotal")
        var current6monthunits = component.get("v.totalofUnitsSummary")
        var prev6monthsUnits = component.get("v.twmonthsUnitsTotal") - component.get("v.totalofUnitsSummary") ;
       var unitsPercentage = prev6monthsUnits != 0 ? (( current6monthunits - prev6monthsUnits )/prev6monthsUnits) *100 : 0;
         console.log('unitsPercentage==>'+unitsPercentage);
        component.set("v.prev6monthsUnits",prev6monthsUnits);
        component.set("v.unitsPercentage",Math.round(unitsPercentage * 100) / 100);

	}
})