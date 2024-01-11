({
    doInit:function(component, event, helper){
        console.log('xAxisLabels child cmp3 in hir3==>'+component.get("v.xAxisLabels"))
        component.set("v.xAxisLabels2",component.get("v.xAxisLabels"));
        //console.log("child2 test===>"+JSON.stringify(component.get("v.record.showChild2Name")))
        console.log("child2 test??!!>"+JSON.stringify(component.get("v.record")))
       var child1RelatedList = component.get("v.record.child1RelatedList");
       // var hospitalName = child2RelatedList[0].Hospital_Name__c;
       // var child1Name =  child2RelatedList[0].Child1_Name__c;
      //  component.set("v.hospitalName",hospitalName);
       component.set("v.child1RelatedList",child1RelatedList);
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
        var pFamilyList =[];
         var child1PFamilyList =[];
         var salesListMonthWise =[];
         var unitsListMonthWise =[];
        child1RelatedList.forEach(function(rec){
var salesPrice = (rec.Contract_Sales_Indirect_Price__c != null || rec.Contract_Sales_Indirect_Price__c != undefined) ? rec.Contract_Sales_Indirect_Price__c : 0;
               var units = (rec.contract_units_paid_qty__c != null || rec.contract_units_paid_qty__c != undefined) ? rec.contract_units_paid_qty__c : 0;            pFamilyList.push(rec.revised_product_family__c);
                                       if(rec.Month_Year__c == component.get("v.firstColumnKey")){
                                           firstColSalesSummary += Math.round((salesPrice + Number.EPSILON) * 100) / 100;
                                           firstColUnitsSummary +=  Math.round(rec.contract_units_paid_qty__c);
                                            child1PFamilyList.push(rec.revised_product_family__c);
                                       }
                                       if(rec.Month_Year__c == component.get("v.secondColumnKey")){
                                           secColSalesSummary += Math.round((salesPrice + Number.EPSILON) * 100) / 100;
                                           secColUnitsSummary +=  Math.round(rec.contract_units_paid_qty__c);
                                            child1PFamilyList.push(rec.revised_product_family__c);
                                       }
                                       if(rec.Month_Year__c == component.get("v.thirdColumnKey")){
                                           thirdColSalesSummary += Math.round((salesPrice + Number.EPSILON) * 100) / 100;
                                           thirdColUnitsSummary +=  Math.round(rec.contract_units_paid_qty__c);
                                            child1PFamilyList.push(rec.revised_product_family__c);
                                       }
                                       if(rec.Month_Year__c == component.get("v.fourthColumnKey")){
                                           fourthColSalesSummary += Math.round((salesPrice + Number.EPSILON) * 100) / 100;
                                           fourthColUnitsSummary +=  Math.round(rec.contract_units_paid_qty__c);
                                            child1PFamilyList.push(rec.revised_product_family__c);
                                       }
                                       if(rec.Month_Year__c == component.get("v.fifthColumnKey")){
                                           fifthColSalesSummary += Math.round((salesPrice + Number.EPSILON) * 100) / 100;
                                           fifthColUnitsSummary +=  Math.round(rec.contract_units_paid_qty__c);
                                            child1PFamilyList.push(rec.revised_product_family__c);
                                       }
                                       if(rec.Month_Year__c == component.get("v.sixthColumnKey")){
                                           sixthColSalesSummary += Math.round((salesPrice + Number.EPSILON) * 100) / 100;
                                           sixthColUnitsSummary +=  Math.round(rec.contract_units_paid_qty__c);
                                            child1PFamilyList.push(rec.revised_product_family__c);
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
        /*for highliting Hospital*/
            console.log('salesListMonthWise==>'+salesListMonthWise.length)
            for(var i=0;i<salesListMonthWise.length;i++){
                if(salesListMonthWise[i] == 0 && salesListMonthWise[i+1] ==0){
                    component.set("v.highlightChild1",true);
                }
            }
            /*end for highliting Hospital*/
        totalofSalesSummary = firstColSalesSummary + secColSalesSummary + thirdColSalesSummary + fourthColSalesSummary +fifthColSalesSummary +sixthColSalesSummary; 
        totalofUnitsSummary = firstColUnitsSummary + secColUnitsSummary + thirdColUnitsSummary + fourthColUnitsSummary + fifthColUnitsSummary + sixthColUnitsSummary;
        avgofSalesSummary = Math.round(((totalofSalesSummary / 6) + Number.EPSILON) * 100) / 100;// Math.round(totalofSalesSummary / 6);
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
         component.set("v.child1PFamilyList",child1PFamilyList);
         /*for dual graph*/
            component.set("v.salesListMonthWise",salesListMonthWise);
            component.set("v.unitsListMonthWise",unitsListMonthWise);
            /*for dual graph*/
        var yAxisLabelsSales =[firstColSalesSummary,secColSalesSummary,thirdColSalesSummary,fourthColSalesSummary,fifthColSalesSummary,sixthColSalesSummary];
   		var yAxisLabelsUnits =[firstColUnitsSummary,secColUnitsSummary,thirdColUnitsSummary,fourthColUnitsSummary,fifthColUnitsSummary,sixthColUnitsSummary];
		
        component.set("v.yAxisLabelsSales",yAxisLabelsSales);
        component.set("v.yAxisLabelsUnits",yAxisLabelsUnits);
        component.set("v.pFamilyList",pFamilyList);
           helper.getAllTotalsforIndividual(component,event,helper); 
        
    },
	handleClick1: function(component, event, helper){
        component.set("v.expandChild2", true);
        component.set("v.record.showChild1Name", false);
       
       // component.set("v.showChild1",showChild1)
       var child2RelatedList = component.get("v.record.child1RelatedList");
        console.log('child2RelatedList==>'+JSON.stringify(child2RelatedList));
        var child2mapObj ={};
        var allData= [];
       child2RelatedList.forEach(function(rec){
           console.log('test child cmp2==>'+rec.Child2_Name__c);
           if(child2mapObj.hasOwnProperty(rec.Child2_Name__c)){
                 
               var relatedList = child2mapObj[rec.Child2_Name__c];
               relatedList.push(rec);
               child2mapObj[rec.Child2_Name__c] = relatedList;
              
           }
           else{
              console.log('inside else productFamilyList child cmp2==>');
               var relatedList =[];
               relatedList.push(rec);
              child2mapObj[rec.Child2_Name__c] = relatedList;
              
           }
          
       });
        console.log('child cmp2 child2mapObj===>'+JSON.stringify(child2mapObj));
        var keys = Object.keys(child2mapObj);
         console.log('child cmp2 keys==>'+keys);
        var allData = [];
        for(var i=0; i<keys.length; i++){
            console.log('keyyy child cmp2==>'+keys[i]);
            var obj = {};
            var relatedList = child2mapObj[keys[i]];
            obj.showChild2= true;
            obj.child2Name = keys[i];
            obj.child2RelatedList = relatedList;
            /*
    obj = {
        child1: 'None',
        child1RelatedList: relatedList
    }
    */    
    allData.push(obj);
}
         
         console.log('length==>'+child2RelatedList.length);
       
        component.set("v.child2List",allData);
         console.log('allData child1 with family===>'+JSON.stringify(allData));
         /* for sorting*/
        var testREc = component.get("v.child2List");
        console.log('testREc==>'+JSON.stringify(testREc));
        var hospitialMap = new Map();
        var SalesList = new Array();
        var listOfWrappers=[];
        testREc.forEach(function(eachRec){
            var relatedList = eachRec.child2RelatedList;
            var totalVal=0;
            relatedList.forEach(function(chargeBackRec){
                var salesPrice = (chargeBackRec.Contract_Sales_Indirect_Price__c != null && chargeBackRec.Contract_Sales_Indirect_Price__c != undefined) ? chargeBackRec.Contract_Sales_Indirect_Price__c : 0;
                totalVal= totalVal + salesPrice;
                
            });
            totalVal=Math.round(totalVal/6);
            
            
            var mainWrap = {'AverageSales':totalVal,
                            'eachChild2':eachRec
                           };
            listOfWrappers.push(mainWrap);
            
        });
        
        listOfWrappers.sort((a,b) => (a.AverageSales > b.AverageSales) ? -1 : ((b.AverageSales > a.AverageSales) ? 1 : 0));
        var finaList = [];
        listOfWrappers.forEach(function(eachREc){
            finaList.push(eachREc.eachChild2);
          
            
        });
        component.set("v.child2List",finaList);
        /*end for sorting*/
    },
     handleClick2: function(component, event, helper){
        console.log("indexxx==>"+component.get("v.index"))
        component.set("v.expandChild2", false);
        component.set("v.record.showChild1Name", true);
     },
    displayChart: function(component, event, helper){
        component.set("v.isModalOpen", true);
        component.set("v.showChart", true);
        component.set("v.chartType", 'Bar');
        var selectedHospital = event.getSource().get("v.value");
        console.log('selectedHospital: '+selectedHospital);
        var idnchargebackList = component.get("v.record.idnchargebackList");
         console.log('idnchargebackList in child??==>'+JSON.stringify(idnchargebackList));
         var compEvent = component.getEvent("compEvent");
        compEvent.setParams({
            "message" : "displayChildChart"
             });
        compEvent.fire();
    },
     displayChartUnits:function(component, event, helper){
        component.set("v.isModalOpenUnits", true);
        component.set("v.showChart", true);
        component.set("v.chartType", 'Bar');
        var selectedHospital = event.getSource().get("v.value");
        console.log('selectedHospital: '+selectedHospital);
       component.set("v.dualChart", 'Child1');
         var compEvent = component.getEvent("compEvent");
        compEvent.setParams({
            "message" : "displayDualChart"
             });
        compEvent.fire();
     
    },
     closeModal: function(component, event, helper){
        component.set("v.isModalOpen", false);
         var compEvent = component.getEvent("compEvent");
        compEvent.setParams({
            "message" : "closeChildChart"
          });
        compEvent.fire();
         
    },
     closeModalUnits: function(component, event, helper){
        component.set("v.isModalOpenUnits", false);
         var compEvent = component.getEvent("compEvent");
        compEvent.setParams({
            "message" : "closeDualChart"
          });
        compEvent.fire();
         
    },
     comparingSales:function(component, event, helper){
        var total12monthsales = component.get("v.twmonthsSalesTotal")
        var current6monthsales = component.get("v.totalofSalesSummary")
        var prev6monthsSales = component.get("v.twmonthsSalesTotal") - component.get("v.totalofSalesSummary") ;
       //console.log('prev6monthsSales===??'+prev6monthsSales);
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
     }
})