({
     doInit:function(component, event, helper){
          helper.getAllTotals(component,event,helper);
         console.log('november 22 child_cmp3==>'+component.get("v.firstColumnKey"));
        var contractDescriptionList = component.get("v.record.contractDescRelatedList");
         console.log('contract json resp==>'+JSON.stringify(contractDescriptionList))
         component.set("v.contractDescriptionList",contractDescriptionList);
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
        var allmaterialDescriptionlist = [];
           var salesListMonthWise =[];
         var unitsListMonthWise =[];
        contractDescriptionList.forEach(function(rec){
                                      console.log('Success month year==>'+rec.Month_Year__c);
                                       if(rec.Month_Year__c == component.get("v.firstColumnKey")){
                                           firstColSalesSummary += Math.round(rec.Contract_Sales_Indirect_Price__c);
                                           firstColUnitsSummary +=  Math.round(rec.contract_units_paid_qty__c);
                                           allmaterialDescriptionlist.push(rec.material_description__c);
                                       }
                                       if(rec.Month_Year__c == component.get("v.secondColumnKey")){
                                           secColSalesSummary += Math.round(rec.Contract_Sales_Indirect_Price__c);
                                           secColUnitsSummary +=  Math.round(rec.contract_units_paid_qty__c);
                                           allmaterialDescriptionlist.push(rec.material_description__c);
                                       }
                                       if(rec.Month_Year__c == component.get("v.thirdColumnKey")){
                                           thirdColSalesSummary += Math.round(rec.Contract_Sales_Indirect_Price__c);
                                           thirdColUnitsSummary +=  Math.round(rec.contract_units_paid_qty__c);
                                           allmaterialDescriptionlist.push(rec.material_description__c);
                                       }
                                       if(rec.Month_Year__c == component.get("v.fourthColumnKey")){
                                           fourthColSalesSummary += Math.round(rec.Contract_Sales_Indirect_Price__c);
                                           fourthColUnitsSummary +=  Math.round(rec.contract_units_paid_qty__c);
                                           allmaterialDescriptionlist.push(rec.material_description__c);
                                       }
                                       if(rec.Month_Year__c == component.get("v.fifthColumnKey")){
                                           fifthColSalesSummary += Math.round(rec.Contract_Sales_Indirect_Price__c);
                                           fifthColUnitsSummary +=  Math.round(rec.contract_units_paid_qty__c);
                                           allmaterialDescriptionlist.push(rec.material_description__c);
                                       }
                                       if(rec.Month_Year__c == component.get("v.sixthColumnKey")){
                                           sixthColSalesSummary += Math.round(rec.Contract_Sales_Indirect_Price__c);
                                           sixthColUnitsSummary +=  Math.round(rec.contract_units_paid_qty__c);
                                           allmaterialDescriptionlist.push(rec.material_description__c);
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
         component.set("v.allmaterialDescriptionlist",allmaterialDescriptionlist);
         console.log('all material description list==='+component.get("v.allmaterialDescriptionlist"))
          /*for dual graph*/
            component.set("v.salesListMonthWise",salesListMonthWise);
            component.set("v.unitsListMonthWise",unitsListMonthWise);
            /*for dual graph*/
          /*for highliting contract*/
            console.log('salesListMonthWise==>'+salesListMonthWise.length)
            for(var i=0;i<salesListMonthWise.length;i++){
                if(salesListMonthWise[i] == 0 && salesListMonthWise[i+1] ==0){
                    component.set("v.highlightContract",true);
                }
            }
            /*end for highliting contract*/
    },
	handleClick1: function(component, event, helper){
       // component.set("v.expandHospital", true);
        component.set("v.record.showProductFamily", false);
         component.set("v.expandProductFamily", true);
        //component.set("v.record.showItem", true);
       var contractDescRelatedList = component.get("v.record.contractDescRelatedList");
        var productFamilymapObj ={};
        var allData= [];
       contractDescRelatedList.forEach(function(rec){
            //console.log('productlist==>'+rec.Product__r.Name);
           console.log('test child cmp2==>'+rec.revised_product_family__c);
           if(productFamilymapObj.hasOwnProperty(rec.revised_product_family__c)){
                 console.log('inside if child cmp2==>'+rec.revised_product_family__c);
               var relatedList = productFamilymapObj[rec.revised_product_family__c];
               relatedList.push(rec);
               productFamilymapObj[rec.revised_product_family__c] = relatedList;
              
           }
           else{
              console.log('inside else productFamilyList child cmp2==>');
               var relatedList =[];
               relatedList.push(rec);
              productFamilymapObj[rec.revised_product_family__c] = relatedList;
              
           }
          
       });
        console.log('child cmp2 productFamilymapObj===>'+JSON.stringify(productFamilymapObj));
        var keys = Object.keys(productFamilymapObj);
        console.log('child cmp2 keys==>'+keys);
        var allData = [];
        for(var i=0; i<keys.length; i++){
            console.log('keyyy child cmp2==>'+keys[i]);
            var obj = {};
            var relatedList = productFamilymapObj[keys[i]];
            obj.showcontractDescription= true;
            obj.productFamily = keys[i];
            obj.productFamilyRelatedList = relatedList;
            /*
    obj = {
        child1: 'None',
        child1RelatedList: relatedList
    }
    */    
            allData.push(obj);
        }
         
         //console.log('length==>'+prodFamilyRelatedList.length);
       
        component.set("v.productFamilyList",allData);
         console.log('allData product family with related===>'+JSON.stringify(allData));
        /* for sorting*/
        var testREc = component.get("v.productFamilyList");
        console.log('testREc==>'+JSON.stringify(testREc));
        var hospitialMap = new Map();
        var SalesList = new Array();
        var listOfWrappers=[];
        testREc.forEach(function(eachRec){
            var relatedList = eachRec.productFamilyRelatedList;
            var totalVal=0;
            relatedList.forEach(function(chargeBackRec){
                var salesPrice = (chargeBackRec.Contract_Sales_Indirect_Price__c != null && chargeBackRec.Contract_Sales_Indirect_Price__c != undefined) ? chargeBackRec.Contract_Sales_Indirect_Price__c : 0;
                totalVal= totalVal + salesPrice;
                
            });
            totalVal=Math.round(totalVal/6);
            
            
            var mainWrap = {'AverageSales':totalVal,
                            'eachProductFamily':eachRec
                           };
            listOfWrappers.push(mainWrap);
            
        });
        
        listOfWrappers.sort((a,b) => (a.AverageSales > b.AverageSales) ? -1 : ((b.AverageSales > a.AverageSales) ? 1 : 0));
        var finaList = [];
        listOfWrappers.forEach(function(eachREc){
            finaList.push(eachREc.eachProductFamily);
            
        });
        component.set("v.productFamilyList",finaList);
        /*end for sorting*/
    },
    displayChart: function(component, event, helper){
       /*    var prodFamilyRelatedList1 = component.get("v.record.prodFamilyRelatedList");
        var productmapObj ={};
        var allData= [];
        var proudslist=[];
      
       // var xaxisLabels = [];
        const xaxisLabels = new Set();
        prodFamilyRelatedList1.forEach(function(rec){
              console.log('productslist...........==='+JSON.stringify(rec.Product__r.Name));
             xaxisLabels.add(rec.Product__r.Name);
        });*/
        component.set("v.isModalOpen", true);
        component.set("v.showChart", true);
        component.set("v.chartType", 'Bar');
        var selectedHospital = event.getSource().get("v.value");
        console.log('selectedHospital: '+selectedHospital);
        var idnchargebackList = component.get("v.record.idnchargebackList");
         console.log('idnchargebackList in child??==>'+JSON.stringify(idnchargebackList));
        
        console.log('y axis labels==>'+component.get("v.yAxisLabelsSales"));
        var yaxisLabels = component.get("v.yAxisLabelsSales");
   
        

   
        var xaxisLabels1=[...xaxisLabels];
       component.set("v.xAxisLabels",xaxisLabels1);
         console.log('productslist...........==='+JSON.stringify(xaxisLabels));
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
         
    },
     closeModalUnits: function(component, event, helper){
        component.set("v.isModalOpenUnits", false);
         
    },
    
    handleClick2: function(component, event, helper){
        console.log("indexxx==>"+component.get("v.index"))
        //component.set("v.expandChild1", false);
        component.set("v.expandProductFamily", false);
        component.set("v.record.showProductFamily", true);
     },
    sortByProductsSales : function(component, event, helper){
        component.set('v.loaded', true);
       // if(component.get("v.filterName") != 'Previous Sales')
         //   component.set("v.isAsc", false);
      //  component.set("v.filterName",'Previous Sales');
        component.set("v.sortField",'ProductSalesDollar');
        helper.sortBy(component, 'ProductSalesDollar', helper);
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