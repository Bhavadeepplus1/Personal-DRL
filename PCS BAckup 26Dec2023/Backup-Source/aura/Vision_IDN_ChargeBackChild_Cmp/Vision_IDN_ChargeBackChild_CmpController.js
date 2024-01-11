({
    doInit: function(component, event, helper){
         helper.getAllTotals(component,event,helper);
        var idnchargebackList = component.get("v.record.idnchargebackList");
        component.set("v.idnchargebackList",idnchargebackList);
        var previdnchargebackList = component.get("v.prevSixMnthschargebackList");//component.get("v.prevrecord.idnchargebackList");
        
       // console.log('record idnchargebackList==>'+JSON.stringify(component.get("v.idnchargebackList")))
        //console.log('childcmp idnchargebackList==>'+JSON.stringify(previdnchargebackList))
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
        var highlightcolorlist= [];
        if(idnchargebackList != null){
            
          idnchargebackList.forEach(function(rec){
              //console.log('in idnchargebackList loop')
              var salesPrice = (rec.Contract_Sales_Indirect_Price__c != null || rec.Contract_Sales_Indirect_Price__c != undefined) ? rec.Contract_Sales_Indirect_Price__c : 0;
               var units = (rec.contract_units_paid_qty__c != null || rec.contract_units_paid_qty__c != undefined) ? rec.contract_units_paid_qty__c : 0;
                                       if(rec.Month_Year__c == component.get("v.firstColumnKey")){
                                           firstColSalesSummary += Math.round(salesPrice);
                                           firstColUnitsSummary +=  Math.round(units);
                                           currentfirstc1productFamilyList.push(rec.revised_product_family__c);
                                           
                                       }
                                       if(rec.Month_Year__c == component.get("v.secondColumnKey")){
                                           secColSalesSummary += Math.round(salesPrice);
                                           secColUnitsSummary +=  Math.round(units);
                                           currentsecc2productFamilyList.push(rec.revised_product_family__c);
                                           
                                       }
                                       if(rec.Month_Year__c == component.get("v.thirdColumnKey")){
                                           thirdColSalesSummary += Math.round(salesPrice);
                                           thirdColUnitsSummary +=  Math.round(units);
                                           currentthirdc3productFamilyList.push(rec.revised_product_family__c);
                                           
                                       }
                                       if(rec.Month_Year__c == component.get("v.fourthColumnKey")){
                                           fourthColSalesSummary += Math.round(salesPrice);
                                           fourthColUnitsSummary +=  Math.round(units);
                                           currentfourthc4productFamilyList.push(rec.revised_product_family__c);
                                           
                                       }
                                       if(rec.Month_Year__c == component.get("v.fifthColumnKey")){
                                           fifthColSalesSummary += Math.round(salesPrice);
                                           fifthColUnitsSummary +=  Math.round(units);
                                           currentfifthc5productFamilyList.push(rec.revised_product_family__c);
                                          
                                       }
                                       if(rec.Month_Year__c == component.get("v.sixthColumnKey")){
                                           sixthColSalesSummary += Math.round(salesPrice);
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
            /*for highliting hospital*/
            console.log('salesListMonthWise==>'+salesListMonthWise.length)
            for(var i=0;i<salesListMonthWise.length;i++){
                if(salesListMonthWise[i] == 0 && salesListMonthWise[i+1] ==0){
                    component.set("v.highlightHsptl",true);
                    highlightcolorlist.push(salesListMonthWise[i]);
                      highlightcolorlist.push(salesListMonthWise[i+1]);
                }
            }
            /*end for highliting hospital*/
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
      
      /*  if(previdnchargebackList !=null && previdnchargebackList.length >0 && previdnchargebackList.length > previdnchargebackList[component.get("v.index")]){
            var eachprevHospitalList = previdnchargebackList[component.get("v.index")];
          
     
       
        var prevfirstColSalesSummary = 0;
        var prevfirstColUnitsSummary =0;
        var prevsecColSalesSummary = 0;
        var prevsecColUnitsSummary = 0;
        var prevthirdColSalesSummary = 0;
        var prevthirdColUnitsSummary = 0;
        var prevfourthColSalesSummary = 0;
        var prevfourthColUnitsSummary = 0;
        var prevfifthColSalesSummary = 0;
        var prevfifthColUnitsSummary = 0;
        var prevsixthColSalesSummary = 0;
        var prevsixthColUnitsSummary = 0;
         var prevtotalofSalesSummary = 0;
        var prevtotalofUnitsSummary =0;
         component.set("v.prevtotalofUnitsSummary",300);
        eachprevHospitalList.forEach(function(rec){
            console.log('firstColumnKey??? outer if==>'+component.get("v.prevfirstColumnKey"))
             var salesPrice = (rec.Contract_Sales_Indirect_Price__c != null || rec.Contract_Sales_Indirect_Price__c != undefined) ? rec.Contract_Sales_Indirect_Price__c : 0;
               var units = (rec.contract_units_paid_qty__c != null || rec.contract_units_paid_qty__c != undefined) ? rec.contract_units_paid_qty__c : 0;
                                       if(rec.Month_Year__c == component.get("v.prevfirstColumnKey")){
                                            console.log('firstColumnKey???==>'+component.get("v.prevfirstColumnKey"))
                                           prevfirstColSalesSummary += Math.round(salesPrice);
                                           prevfirstColUnitsSummary +=  Math.round(units);
                                           
                                       }
            						  if(rec.Month_Year__c == component.get("v.prevsecondColumnKey")){
                                           prevsecColSalesSummary += Math.round(salesPrice);
                                           prevsecColUnitsSummary +=  Math.round(units);
                                       }
                                       if(rec.Month_Year__c == component.get("v.prevthirdColumnKey")){
                                           prevthirdColSalesSummary += Math.round(salesPrice);
                                           prevthirdColUnitsSummary +=  Math.round(units);
                                       }
                                       if(rec.Month_Year__c == component.get("v.prevfourthColumnKey")){
                                           prevfourthColSalesSummary += Math.round(salesPrice);
                                           prevfourthColUnitsSummary +=  Math.round(units);
                                       }
                                       if(rec.Month_Year__c == component.get("v.prevfifthColumnKey")){
                                           prevfifthColSalesSummary += Math.round(salesPrice);
                                           prevfifthColUnitsSummary +=  Math.round(units);
                                       }
                                       if(rec.Month_Year__c == component.get("v.prevsixthColumnKey")){
                                           prevsixthColSalesSummary += Math.round(salesPrice);
                                           prevsixthColUnitsSummary +=  Math.round(units);
                                       }
        });
        prevtotalofSalesSummary = prevfirstColSalesSummary + prevsecColSalesSummary + prevthirdColSalesSummary + prevfourthColSalesSummary +prevfifthColSalesSummary +prevsixthColSalesSummary;
        prevtotalofUnitsSummary = prevfirstColUnitsSummary + prevsecColUnitsSummary + prevthirdColUnitsSummary + prevfourthColUnitsSummary + prevfifthColUnitsSummary + prevsixthColUnitsSummary;
       component.set("v.prevtotalofSalesSummary",prevtotalofSalesSummary);
            component.set("v.prevtotalofUnitsSummary",prevtotalofUnitsSummary);
           
       
             console.log('prevtotalofUnitsSummary????=='+component.get("v.prevtotalofUnitsSummary"));
          
        }
        
        var currentTotalSales = component.get("v.totalofSalesSummary");
        var prevTotalSales =component.get("v.prevtotalofUnitsSummary");
       	var currentTotalUnits = component.get("v.totalofUnitsSummary");
        var prevTotalUnits = component.get("v.prevtotalofUnitsSummary");
        
        console.log('currentTotalSales==>'+currentTotalSales)
        console.log('prevTotalSales==>'+prevTotalSales)
        if(currentTotalSales > prevTotalSales){
            component.set("v.showColor",true);
        }else {
            component.set("v.showColor",false);
        }  
       if(currentTotalSales > prevTotalSales){
            component.set("v.showColorUnits",true);
        }else {
            component.set("v.showColorUnits",false);
        }  */
       
    },
	handleClick1: function(component, event, helper){
        component.set("v.expandHospital", true);
        component.set("v.record.showItem", false);
        var hospitalrelatedList = component.get("v.record.idnchargebackList");
        
        var child1mapObj ={};
        var allData= [];
        hospitalrelatedList.forEach(function(rec){
            console.log('test==>'+rec.Child1_Name__c);
            if(child1mapObj.hasOwnProperty(rec.Child1_Name__c)){
                console.log('inside if==>'+rec.Child1_Name__c);
                var relatedList = child1mapObj[rec.Child1_Name__c];
                relatedList.push(rec);
                child1mapObj[rec.Child1_Name__c] = relatedList;
                
            }
            else{
                console.log('inside else==>');
                var relatedList =[];
                relatedList.push(rec);
                child1mapObj[rec.Child1_Name__c] = relatedList;
                
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
         
         console.log('length==>'+hospitalrelatedList.length);
       console.log('child1mapObj===>'+JSON.stringify(child1mapObj));
        component.set("v.child1List",allData);
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
                var salesPrice = (chargeBackRec.Contract_Sales_Indirect_Price__c != null && chargeBackRec.Contract_Sales_Indirect_Price__c != undefined) ? chargeBackRec.Contract_Sales_Indirect_Price__c : 0;
                totalVal= totalVal + salesPrice;
                
            });
            totalVal=Math.round(totalVal/6);
            
            
            var mainWrap = {'AverageSales':totalVal,
                            'eachChild1':eachRec
                           };
            listOfWrappers.push(mainWrap);
            
        });
        
        listOfWrappers.sort((a,b) => (a.AverageSales > b.AverageSales) ? -1 : ((b.AverageSales > a.AverageSales) ? 1 : 0));
        var finaList = [];
        listOfWrappers.forEach(function(eachREc){
            finaList.push(eachREc.eachChild1);
            console.log('AvgSlaes---->'+eachREc.AverageSales)
            console.log('AvgSlaes---->'+eachREc.eachChild1.child1);
            
        });
        component.set("v.child1List",finaList);
        /*end for sorting*/
         console.log('child1 allData===>'+JSON.stringify(allData));
    },
     handleClick2: function(component, event, helper){
        console.log("indexxx==>"+component.get("v.index"))
        component.set("v.expandHospital", false);
        component.set("v.record.showItem", true);
       /*  var i=0;
         var setshowItemList = component.get("v.child1List");
         var objec={};
         setshowItemList.forEach(function(recordData){
             if(i==component.get("v.index")){
                 console.log('indexxx-->'+component.get("v.index")+'i----'+i);
                 recordData.showChild = false;
               objec= recordData;
             }
             i++;
             console.log('i value--->'+i);
	     })
         console.log('objec-->'+JSON.stringify(objec));
         console.log('showChild-->'+JSON.stringify(setshowItemList));
         //setshowItemList[component.get("v.index")].showChild = false;
         component.set("v.child1List",setshowItemList);*/
         
    },
    displayChart: function(component, event, helper){
        var LineItemtable = component.find("LineTable");
       // $A.util.removeClass(LineItemtable, "summaryheaderSticky");
        //$A.util.removeClass(component.find("LineTable"), 'slds-hide');
         var parentComponent = component.get("v.parent");                         
		parentComponent.greetingMethod("displayChart")
		//parentComponent.childToParentMethod();
        
        component.set("v.isModalOpen", true);
        component.set("v.showChart", true);
        component.set("v.chartType", 'Bar');
        var selectedHospital = event.getSource().get("v.value");
        console.log('selectedHospital: '+selectedHospital);
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
        //var LineItemtable = component.find("LineTable");
        //$A.util.removeClass(LineItemtable, "summaryheaderSticky");
        var parentComponent = component.get("v.parent");                         
		parentComponent.greetingMethod("displayChart")
        component.set("v.isModalOpenUnits", true);
        component.set("v.showChart", true);
        component.set("v.chartType", 'Bar');
        component.set("v.dualChart", 'Hospital');
        var selectedHospital = event.getSource().get("v.value");
        console.log('selectedHospital: '+selectedHospital);
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
     },
   /*  getMessage : function(component, event) {
        //get method paramaters
        var params = event.getParam('arguments');
        if (params) {
            var param1 = params.GreetingParam;
            if(param1 == 'displayChart'){
            $A.util.removeClass(component.find("LineTable"), 'summaryheaderSticky');
            }else{
             $A.util.addClass(component.find("LineTable"), 'summaryheaderSticky');   
            }
            //alert(param1);
        }
    }*/
})