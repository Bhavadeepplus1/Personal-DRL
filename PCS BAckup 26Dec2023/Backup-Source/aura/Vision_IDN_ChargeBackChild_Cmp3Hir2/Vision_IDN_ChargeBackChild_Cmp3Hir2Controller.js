({
    doInit:function(component, event, helper){
        helper.getAllTotals(component,event,helper);
        console.log("child2 test===>"+JSON.stringify(component.get("v.record.showChild2Name")))
        
       var child2RelatedList = component.get("v.record.child2RelatedList");
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
         var salesListMonthWise =[];
        child2RelatedList.forEach(function(rec){
                                      console.log('Success month year==>'+rec.Month_Year__c);
            pFamilyList.push(rec.revised_product_family__c);
                                       if(rec.Month_Year__c == component.get("v.firstColumnKey")){
                                           firstColSalesSummary += Math.round(rec.Contract_Sales_Indirect_Price__c);
                                           firstColUnitsSummary +=  Math.round(rec.contract_units_paid_qty__c);
                                       }
                                       if(rec.Month_Year__c == component.get("v.secondColumnKey")){
                                           secColSalesSummary += Math.round(rec.Contract_Sales_Indirect_Price__c);
                                           secColUnitsSummary +=  Math.round(rec.contract_units_paid_qty__c);
                                       }
                                       if(rec.Month_Year__c == component.get("v.thirdColumnKey")){
                                           thirdColSalesSummary += Math.round(rec.Contract_Sales_Indirect_Price__c);
                                           thirdColUnitsSummary +=  Math.round(rec.contract_units_paid_qty__c);
                                       }
                                       if(rec.Month_Year__c == component.get("v.fourthColumnKey")){
                                           fourthColSalesSummary += Math.round(rec.Contract_Sales_Indirect_Price__c);
                                           fourthColUnitsSummary +=  Math.round(rec.contract_units_paid_qty__c);
                                       }
                                       if(rec.Month_Year__c == component.get("v.fifthColumnKey")){
                                           fifthColSalesSummary += Math.round(rec.Contract_Sales_Indirect_Price__c);
                                           fifthColUnitsSummary +=  Math.round(rec.contract_units_paid_qty__c);
                                       }
                                       if(rec.Month_Year__c == component.get("v.sixthColumnKey")){
                                           sixthColSalesSummary += Math.round(rec.Contract_Sales_Indirect_Price__c);
                                           sixthColUnitsSummary +=  Math.round(rec.contract_units_paid_qty__c);
                                       }
                                   });
        salesListMonthWise.push(firstColSalesSummary);
            salesListMonthWise.push(secColSalesSummary);
            salesListMonthWise.push(thirdColSalesSummary);
            salesListMonthWise.push(fourthColSalesSummary);
             salesListMonthWise.push(fifthColSalesSummary);
            salesListMonthWise.push(sixthColSalesSummary);
        
        totalofSalesSummary = firstColSalesSummary + secColSalesSummary + thirdColSalesSummary + fourthColSalesSummary +fifthColSalesSummary +sixthColSalesSummary; 
        totalofUnitsSummary = firstColUnitsSummary + secColUnitsSummary + thirdColUnitsSummary + fourthColUnitsSummary + fifthColUnitsSummary + sixthColUnitsSummary;
        avgofSalesSummary =  Math.round(totalofSalesSummary / 6);
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
        var yAxisLabelsSales =[firstColSalesSummary,secColSalesSummary,thirdColSalesSummary,fourthColSalesSummary,fifthColSalesSummary,sixthColSalesSummary];
   		var yAxisLabelsUnits =[firstColUnitsSummary,secColUnitsSummary,thirdColUnitsSummary,fourthColUnitsSummary,fifthColUnitsSummary,sixthColUnitsSummary];
		
        component.set("v.yAxisLabelsSales",yAxisLabelsSales);
        component.set("v.yAxisLabelsUnits",yAxisLabelsUnits);
        component.set("v.pFamilyList",pFamilyList);
         /*for highliting child2*/
            console.log('salesListMonthWise==>'+salesListMonthWise.length)
            for(var i=0;i<salesListMonthWise.length;i++){
                if(salesListMonthWise[i] == 0 && salesListMonthWise[i+1] ==0){
                    component.set("v.highlightChild2",true);
                }
            }
            /*end for highliting child2*/
        
    },
	handleClick1: function(component, event, helper){
        component.set("v.expandChild2", true);
        component.set("v.record.showChild2Name", false);
       
       // component.set("v.showChild1",showChild1)
       var child2RelatedList = component.get("v.record.child2RelatedList");
        console.log('child2RelatedList==>'+JSON.stringify(child2RelatedList));
        var contractmapObj ={};
        var allData= [];
       child2RelatedList.forEach(function(rec){
           console.log('test child cmp2==>'+rec.Contact_Description__c);
           if(contractmapObj.hasOwnProperty(rec.Contact_Description__c)){
                 
               var relatedList = contractmapObj[rec.Contact_Description__c];
               relatedList.push(rec);
               contractmapObj[rec.Contact_Description__c] = relatedList;
              
           }
           else{
              console.log('inside else productFamilyList child cmp2==>');
               var relatedList =[];
               relatedList.push(rec);
              contractmapObj[rec.Contact_Description__c] = relatedList;
              
           }
          
       });
        console.log('child cmp2 contractmapObj===>'+JSON.stringify(contractmapObj));
        var keys = Object.keys(contractmapObj);
         console.log('child cmp2 keys==>'+keys);
        var allData = [];
        for(var i=0; i<keys.length; i++){
            console.log('keyyy child cmp2==>'+keys[i]);
            var obj = {};
            var relatedList = contractmapObj[keys[i]];
            obj.showProductFamily= true;
            obj.contractDesc = keys[i];
            obj.contractDescRelatedList = relatedList;
            /*
    obj = {
        child1: 'None',
        child1RelatedList: relatedList
    }
    */    
    allData.push(obj);
}
         
         console.log('allData==>'+JSON.stringify(allData));
       
        //component.set("v.productFamilyList",allData);
        component.set("v.contractDescriptionList",allData);
         console.log('allData contractDescriptionList===>'+JSON.stringify(allData));
         /* for sorting*/
        var testREc = component.get("v.contractDescriptionList");
        console.log('testREc==>'+JSON.stringify(testREc));
        var hospitialMap = new Map();
        var SalesList = new Array();
        var listOfWrappers=[];
        testREc.forEach(function(eachRec){
            var relatedList = eachRec.contractDescRelatedList;
            var totalVal=0;
            relatedList.forEach(function(chargeBackRec){
                var salesPrice = (chargeBackRec.Contract_Sales_Indirect_Price__c != null && chargeBackRec.Contract_Sales_Indirect_Price__c != undefined) ? chargeBackRec.Contract_Sales_Indirect_Price__c : 0;
                totalVal= totalVal + salesPrice;
                
            });
            totalVal=Math.round(totalVal/6);
            
            
            var mainWrap = {'AverageSales':totalVal,
                            'eachContract':eachRec
                           };
            listOfWrappers.push(mainWrap);
            
        });
        
        listOfWrappers.sort((a,b) => (a.AverageSales > b.AverageSales) ? -1 : ((b.AverageSales > a.AverageSales) ? 1 : 0));
        var finaList = [];
        listOfWrappers.forEach(function(eachREc){
            finaList.push(eachREc.eachContract);
            
        });
        component.set("v.contractDescriptionList",finaList);
        /*end for sorting*/
    },
     handleClick2: function(component, event, helper){
        console.log("indexxx==>"+component.get("v.index"))
        component.set("v.expandChild2", false);
        component.set("v.record.showChild2Name", true);
     },
    displayChart: function(component, event, helper){
        component.set("v.isModalOpen", true);
        component.set("v.showChart", true);
        component.set("v.chartType", 'Bar');
        var selectedHospital = event.getSource().get("v.value");
        console.log('selectedHospital: '+selectedHospital);
        var idnchargebackList = component.get("v.record.idnchargebackList");
         console.log('idnchargebackList in child??==>'+JSON.stringify(idnchargebackList));
        
        console.log('y axis labels==>'+component.get("v.yAxisLabelsSales"));
         console.log('pFamilyList??'+component.get("v.pFamilyList"));
        
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