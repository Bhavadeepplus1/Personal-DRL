({
	initRecords : function(component, event, helper) {
        component.set("v.xAxisLabels2",component.get("v.xAxisLabels"));
        console.log('november 22 child_cmp4==>'+component.get("v.firstColumnKey"));
		console.log('init records==>'+JSON.stringify(component.get("v.record")))
        var productFamilyRelatedList = component.get("v.record.productFamilyRelatedList");
        component.set("v.productFamilyRelatedList",productFamilyRelatedList);
        console.log('productRelatedList==>'+JSON.stringify(productFamilyRelatedList))
        //var hospitalName = productRelatedList[0].Hospital_Name__c;
        //var child1Name =  productRelatedList[0].Child1_Name__c;
         //var child2Name =  productRelatedList[0].Child2_Name__c;
        //var productFamily = productRelatedList[0].revised_product_family__c;
        //component.set("v.hospitalName",hospitalName);
        // component.set("v.child1Name",child1Name);
         //component.set("v.child2Name",child2Name);
        //component.set("v.productFamily",productFamily);
         var monthyearmapObj ={};
        var allData= [];
         productFamilyRelatedList.forEach(function(rec){
          
           if(monthyearmapObj.hasOwnProperty(rec.Month_Year__c)){
                 
               var relatedList = monthyearmapObj[rec.Month_Year__c];
               relatedList.push(rec);
               monthyearmapObj[rec.Month_Year__c] = relatedList;
              
           }
           else{
              console.log('inside else productFamilyList child cmp2==>');
               var relatedList =[];
               relatedList.push(rec);
              monthyearmapObj[rec.Month_Year__c] = relatedList;
              
           }
          
       });
        console.log('child cmp4 monthyearmapObj===>'+JSON.stringify(monthyearmapObj));
        var keys = Object.keys(monthyearmapObj);
        console.log('child cmp2 keys==>'+keys);
        var allData = [];
        var keyList = [];
        for(var i=0; i<keys.length; i++){
            keyList.push(keys[i]);
           
            var obj = {};
            var relatedList = monthyearmapObj[keys[i]];
            obj.monthyear = keys[i];
            obj.monthyearRelatedList = relatedList;
            /*
    obj = {
        child1: 'None',
        child1RelatedList: relatedList
    }
    */    
            allData.push(obj);
        }
         //console.log('length==>'+productRelatedList.length);
       
        component.set("v.monthyearList",allData);
         console.log('in cmp4 allData product  with related===>'+JSON.stringify(allData));
         console.log('length of the data===>'+allData.length);
        var octchargeBackAmount =0;
        var janchargeBackAmount =0;
        var novchargeBackAmount = 0;
        var decchargeBackAmount = 0;
         var febchargeBackAmount = 0;
        var marchchargeBackAmount = 0;
        var avgsalesofSixMonth;
        var totalSalesofSixMonth;
        // for units
         var col1Units =0;
        var col2Units =0;
        var col3Units = 0;
        var col4Units = 0;
         var col5Units = 0;
        var col6Units = 0;
        var avgunitsofSixMonth;
        var totalunitsofSixMonth;
        // end for units
        var allmaterialDescriptionlist = [];
         var salesListMonthWise =[];
         var unitsListMonthWise =[];
        for(var i=0 ; i<allData.length ; i++){
             console.log('keyyy child cmp4==>'+keyList);
            var sampleList = allData[i]['monthyearRelatedList'];
            if(keyList[i] == component.get("v.firstColumnKey")){
                sampleList.forEach(function(rec){
                octchargeBackAmount = octchargeBackAmount+Math.round(((rec.Contract_Sales_Indirect_Price__c) + Number.EPSILON) * 100) / 100;//Math.round(rec.Contract_Sales_Indirect_Price__c);
                col1Units = col1Units+Math.round(rec.contract_units_paid_qty__c);
                    allmaterialDescriptionlist.push(rec.material_description__c);
                 });
            }
            if(keyList[i] == component.get("v.secondColumnKey")){
                sampleList.forEach(function(rec){
                novchargeBackAmount = novchargeBackAmount+Math.round(((rec.Contract_Sales_Indirect_Price__c) + Number.EPSILON) * 100) / 100;
                    col2Units = col2Units+Math.round(rec.contract_units_paid_qty__c);
                     allmaterialDescriptionlist.push(rec.material_description__c);
                 });
            }
             if(keyList[i] == component.get("v.thirdColumnKey")){
                sampleList.forEach(function(rec){
                decchargeBackAmount = decchargeBackAmount+Math.round(((rec.Contract_Sales_Indirect_Price__c) + Number.EPSILON) * 100) / 100;
                    col3Units = col3Units+Math.round(rec.contract_units_paid_qty__c);
                     allmaterialDescriptionlist.push(rec.material_description__c);
                 });
            }
            if(keyList[i] == component.get("v.fourthColumnKey")){
                
                 sampleList.forEach(function(rec){
                     janchargeBackAmount = janchargeBackAmount+Math.round(((rec.Contract_Sales_Indirect_Price__c) + Number.EPSILON) * 100) / 100;
                     col4Units = col4Units+Math.round(rec.contract_units_paid_qty__c);
                      allmaterialDescriptionlist.push(rec.material_description__c);
                 });
            }
            if(keyList[i] == component.get("v.fifthColumnKey")){
                sampleList.forEach(function(rec){
                febchargeBackAmount = febchargeBackAmount+Math.round(((rec.Contract_Sales_Indirect_Price__c) + Number.EPSILON) * 100) / 100;
                    col5Units = col5Units+Math.round(rec.contract_units_paid_qty__c);
                      allmaterialDescriptionlist.push(rec.material_description__c);
                 });
            }
            if(keyList[i] == component.get("v.sixthColumnKey")){
                sampleList.forEach(function(rec){
                marchchargeBackAmount = marchchargeBackAmount+Math.round(((rec.Contract_Sales_Indirect_Price__c) + Number.EPSILON) * 100) / 100;
                    col6Units = col6Units+Math.round(rec.contract_units_paid_qty__c);
                      allmaterialDescriptionlist.push(rec.material_description__c);
                 });
            }
           avgsalesofSixMonth = (octchargeBackAmount + novchargeBackAmount + decchargeBackAmount + janchargeBackAmount+febchargeBackAmount+marchchargeBackAmount);
        	avgsalesofSixMonth = Math.round(((avgsalesofSixMonth / 6) + Number.EPSILON) * 100) / 100;
            totalSalesofSixMonth = Math.round((octchargeBackAmount + novchargeBackAmount + decchargeBackAmount + janchargeBackAmount+febchargeBackAmount+marchchargeBackAmount));
        	avgunitsofSixMonth = Math.round((col1Units + col2Units + col3Units + col4Units+col5Units+col6Units)/6);
            totalunitsofSixMonth = Math.round((col1Units + col2Units + col3Units + col4Units+col5Units+col6Units));
        }
         /*for dual graph*/
            salesListMonthWise.push(octchargeBackAmount);
            salesListMonthWise.push(novchargeBackAmount);
            salesListMonthWise.push(decchargeBackAmount);
            salesListMonthWise.push(janchargeBackAmount);
             salesListMonthWise.push(febchargeBackAmount);
            salesListMonthWise.push(marchchargeBackAmount);
            unitsListMonthWise.push(col1Units);
            unitsListMonthWise.push(col2Units);
            unitsListMonthWise.push(col3Units);
            unitsListMonthWise.push(col4Units);
             unitsListMonthWise.push(col5Units);
            unitsListMonthWise.push(col6Units);
            /*end for dual graph*/
         /*for highliting Child2*/
            console.log('salesListMonthWise==>'+salesListMonthWise.length)
            for(var i=0;i<salesListMonthWise.length;i++){
                if(salesListMonthWise[i] == 0 && salesListMonthWise[i+1] ==0){
                    component.set("v.highlightprodFamily",true);
                }
            }
            /*end for highliting Child2*/
        console.log('total charge back amount==>'+janchargeBackAmount);
        component.set("v.janchargeBackAmount",janchargeBackAmount);
        component.set("v.octchargeBackAmount",octchargeBackAmount);
        component.set("v.novchargeBackAmount",novchargeBackAmount);
        component.set("v.decchargeBackAmount",decchargeBackAmount);
        component.set("v.febchargeBackAmount",febchargeBackAmount);
        component.set("v.marchchargeBackAmount",marchchargeBackAmount);
        component.set("v.avgsalesofSixMonth",avgsalesofSixMonth);
         component.set("v.totalSalesofSixMonth",totalSalesofSixMonth); 
        /*for Units*/
        component.set("v.col1Units",col1Units);
        component.set("v.col2Units",col2Units);
        component.set("v.col3Units",col3Units);
        component.set("v.col4Units",col4Units);
        component.set("v.col5Units",col5Units);
        component.set("v.col6Units",col6Units);
        component.set("v.avgunitsofSixMonth",avgunitsofSixMonth);
         component.set("v.totalunitsofSixMonth",totalunitsofSixMonth); 
        /*end for Units*/
         component.set("v.allmaterialDescriptionlist",allmaterialDescriptionlist);
         /*for dual graph*/
            component.set("v.salesListMonthWise",salesListMonthWise);
            component.set("v.unitsListMonthWise",unitsListMonthWise);
            /*for dual graph*/
          helper.getAllTotalsforIndividual(component,event,helper); 
	},
    handleClick1: function(component, event, helper){
       var productFamilyRelatedList = component.get("v.record.productFamilyRelatedList");
         component.set("v.record.showproductFamily", false);
        component.set("v.expandPFamily", true);
        var productmapObj ={};
        var allData= [];
        productFamilyRelatedList.forEach(function(rec){
       
           if(productmapObj.hasOwnProperty(rec.material_description__c)){
                
               var relatedList = productmapObj[rec.material_description__c];
               relatedList.push(rec);
               productmapObj[rec.material_description__c] = relatedList;
              
           }
           else{
            
               var relatedList =[];
               relatedList.push(rec);
              productmapObj[rec.material_description__c] = relatedList;
              
           }
          
       });
        console.log('child cmp4 productmapObj===>'+JSON.stringify(productmapObj));
        var keys = Object.keys(productmapObj);
       
        var allData = [];
        for(var i=0; i<keys.length; i++){
          
            var obj = {};
            var relatedList = productmapObj[keys[i]];
            obj.material_description__c = keys[i];
            obj.ndcRelatedList = relatedList;
     
            allData.push(obj);
        }
         component.set("v.productList",allData);
        /* for sorting*/
        var testREc = component.get("v.productList");
        console.log('testREc==>'+JSON.stringify(testREc));
        var hospitialMap = new Map();
        var SalesList = new Array();
        var listOfWrappers=[];
        testREc.forEach(function(eachRec){
            var relatedList = eachRec.ndcRelatedList;
            var totalVal=0;
            relatedList.forEach(function(chargeBackRec){
                var salesPrice = (chargeBackRec.Contract_Sales_Indirect_Price__c != null && chargeBackRec.Contract_Sales_Indirect_Price__c != undefined) ? chargeBackRec.Contract_Sales_Indirect_Price__c : 0;
                totalVal= totalVal + salesPrice;
                
            });
            totalVal=Math.round(totalVal/6);
            
            
            var mainWrap = {'AverageSales':totalVal,
                            'eachProduct':eachRec
                           };
            listOfWrappers.push(mainWrap);
            
        });
        
        listOfWrappers.sort((a,b) => (a.AverageSales > b.AverageSales) ? -1 : ((b.AverageSales > a.AverageSales) ? 1 : 0));
        var finaList = [];
        listOfWrappers.forEach(function(eachREc){
            finaList.push(eachREc.eachProduct);
          
            
        });
        component.set("v.productList",finaList);
        /*end for sorting*/
    },
    handleClick2: function(component, event, helper){
        component.set("v.expandPFamily", false);
        component.set("v.record.showproductFamily", true);
     },
     displayChart: function(component, event, helper){
         component.set("v.isModalOpen", true);
        component.set("v.showChart", true);
        component.set("v.chartType", 'Bar');
        var selectedHospital = event.getSource().get("v.value");
        console.log('selectedHospital: '+selectedHospital);
         //for closing summary//
        var compEvent = component.getEvent("compEvent");
        compEvent.setParams({
            "message" : "displayChildChart"
             });
        compEvent.fire();
        //end for closing summary//
     },
     displayChartUnits:function(component, event, helper){
        component.set("v.isModalOpenUnits", true);
        component.set("v.showChart", true);
        component.set("v.chartType", 'Bar');
        component.set("v.dualChart", 'Hospital');
        var selectedHospital = event.getSource().get("v.value");
         //for closing summary//
        var compEvent = component.getEvent("compEvent");
        compEvent.setParams({
            "message" : "displayDualChart"
             });
        compEvent.fire();
        //end for closing summary//
    },
      closeModal: function(component, event, helper){
        component.set("v.isModalOpen", false);
         
    },
     closeModalUnits: function(component, event, helper){
        component.set("v.isModalOpenUnits", false);
         
    },
    comparingSales:function(component, event, helper){
        var total12monthsales = component.get("v.twmonthsSalesTotal")
        var current6monthsales = component.get("v.totalSalesofSixMonth")
        var prev6monthsSales = component.get("v.twmonthsSalesTotal") - component.get("v.totalSalesofSixMonth") ;
       //console.log('prev6monthsSales===??'+prev6monthsSales);
        var salesPercentage = prev6monthsSales != 0 ? (( current6monthsales - prev6monthsSales )/prev6monthsSales) *100 : 0;
        component.set("v.prev6monthsSales",prev6monthsSales);
        component.set("v.salesPercentage",Math.round(salesPercentage * 100) / 100); 
    },
     comparingUnits:function(component, event, helper){
        var total12monthunits = component.get("v.twmonthsUnitsTotal")
        var current6monthunits = component.get("v.totalunitsofSixMonth")
        var prev6monthsUnits = component.get("v.twmonthsUnitsTotal") - component.get("v.totalunitsofSixMonth") ;
       var unitsPercentage = prev6monthsUnits != 0 ? (( current6monthunits - prev6monthsUnits )/prev6monthsUnits) *100 : 0;
         console.log('unitsPercentage==>'+unitsPercentage);
        component.set("v.prev6monthsUnits",prev6monthsUnits);
        component.set("v.unitsPercentage",Math.round(unitsPercentage * 100) / 100);
     }

})