({
	initRecords : function(component, event, helper) {
        component.set("v.xAxisLabels2",component.get("v.xAxisLabels"));
        helper.getAllTotalsforIndividual(component,event,helper);
        console.log('november 22 child_cmp4==>'+component.get("v.firstColumnKey"));
		console.log('init records==>'+JSON.stringify(component.get("v.record")))
        var productFamilyRelatedList = component.get("v.record.productFamilyRelatedList");
        component.set("v.productFamilyRelatedList",productFamilyRelatedList);
        console.log('productRelatedList==>'+JSON.stringify(productFamilyRelatedList))
         var monthyearmapObj ={};
        var allData= [];
         productFamilyRelatedList.forEach(function(rec){
           console.log('test Month_Year__c==>'+rec.T2_Month_Year__c);
           if(monthyearmapObj.hasOwnProperty(rec.T2_Month_Year__c)){
                 console.log('inside Month_Year__c==>'+rec.T2_Month_Year__c);
               var relatedList = monthyearmapObj[rec.T2_Month_Year__c];
               relatedList.push(rec);
               monthyearmapObj[rec.T2_Month_Year__c] = relatedList;
              
           }
           else{
              console.log('inside else productFamilyList child cmp2==>');
               var relatedList =[];
               relatedList.push(rec);
              monthyearmapObj[rec.T2_Month_Year__c] = relatedList;
              
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
         console.log('length==>'+productFamilyRelatedList.length);
       
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
        var allcontractsDescriptionlist = [];
         var allmaterialDescriptionlist = [];
         var salesListMonthWise =[];
         var unitsListMonthWise =[];
        for(var i=0 ; i<allData.length ; i++){
             console.log('keyyy child cmp4==>'+keyList);
            var sampleList = allData[i]['monthyearRelatedList'];
            if(keyList[i] == component.get("v.firstColumnKey")){
                sampleList.forEach(function(rec){
                octchargeBackAmount = octchargeBackAmount+Math.round(((rec.T2_Contract_Sales_Indirect_Price__c) + Number.EPSILON) * 100) / 100;
                col1Units = col1Units+Math.round(rec.T2_contract_units_paid_qty__c);
                    //allcontractsDescriptionlist.push(rec.T2_Contact_Description__c);
                    allmaterialDescriptionlist.push(rec.T2_material_description__c);
                 });
            }
            if(keyList[i] == component.get("v.secondColumnKey")){
                sampleList.forEach(function(rec){
                novchargeBackAmount = novchargeBackAmount+Math.round(((rec.T2_Contract_Sales_Indirect_Price__c) + Number.EPSILON) * 100) / 100;
                    col2Units = col2Units+Math.round(rec.T2_contract_units_paid_qty__c);
                     //allcontractsDescriptionlist.push(rec.T2_Contact_Description__c);
                     allmaterialDescriptionlist.push(rec.T2_material_description__c);
                 });
            }
             if(keyList[i] == component.get("v.thirdColumnKey")){
                sampleList.forEach(function(rec){
                decchargeBackAmount = decchargeBackAmount+Math.round(((rec.T2_Contract_Sales_Indirect_Price__c) + Number.EPSILON) * 100) / 100;
                    col3Units = col3Units+Math.round(rec.T2_contract_units_paid_qty__c);
                     //allcontractsDescriptionlist.push(rec.T2_Contact_Description__c);
                     allmaterialDescriptionlist.push(rec.T2_material_description__c);
                 });
            }
            if(keyList[i] == component.get("v.fourthColumnKey")){
                
                 sampleList.forEach(function(rec){
                     janchargeBackAmount = janchargeBackAmount+Math.round(((rec.T2_Contract_Sales_Indirect_Price__c) + Number.EPSILON) * 100) / 100;
                     col4Units = col4Units+Math.round(rec.T2_contract_units_paid_qty__c);
                      //allcontractsDescriptionlist.push(rec.T2_Contact_Description__c);
                      allmaterialDescriptionlist.push(rec.T2_material_description__c);
                 });
            }
            if(keyList[i] == component.get("v.fifthColumnKey")){
                sampleList.forEach(function(rec){
                febchargeBackAmount = febchargeBackAmount+Math.round(((rec.T2_Contract_Sales_Indirect_Price__c) + Number.EPSILON) * 100) / 100;
                    col5Units = col5Units+Math.round(rec.T2_contract_units_paid_qty__c);
                    // allcontractsDescriptionlist.push(rec.T2_Contact_Description__c);
                    allmaterialDescriptionlist.push(rec.T2_material_description__c);
                 });
            }
            if(keyList[i] == component.get("v.sixthColumnKey")){
                sampleList.forEach(function(rec){
                marchchargeBackAmount = marchchargeBackAmount+Math.round(((rec.T2_Contract_Sales_Indirect_Price__c) + Number.EPSILON) * 100) / 100;
                    col6Units = col6Units+Math.round(rec.T2_contract_units_paid_qty__c);
                     //allcontractsDescriptionlist.push(rec.T2_Contact_Description__c);
                     allmaterialDescriptionlist.push(rec.T2_material_description__c);
                 });
            }
           	avgsalesofSixMonth = (octchargeBackAmount + novchargeBackAmount + decchargeBackAmount + janchargeBackAmount+febchargeBackAmount+marchchargeBackAmount)/6;
        	avgsalesofSixMonth = Math.round(((avgsalesofSixMonth) + Number.EPSILON) * 100) / 100;
            totalSalesofSixMonth = (octchargeBackAmount + novchargeBackAmount + decchargeBackAmount + janchargeBackAmount+febchargeBackAmount+marchchargeBackAmount);
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
         /*for highliting product family*/
            console.log('salesListMonthWise==>'+salesListMonthWise.length)
            for(var i=0;i<salesListMonthWise.length;i++){
                if(salesListMonthWise[i] == 0 && salesListMonthWise[i+1] ==0){
                    component.set("v.highlightprodFamily",true);
                }
            }
            /*end for highliting product family*/
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
         component.set("v.allcontractsDescriptionlist",allcontractsDescriptionlist);
        component.set("v.allmaterialDescriptionlist",allmaterialDescriptionlist);
         /*for dual graph*/
            component.set("v.salesListMonthWise",salesListMonthWise);
            component.set("v.unitsListMonthWise",unitsListMonthWise);
            /*for dual graph*/
	},
    handleClick1: function(component, event, helper){
       var prodFamilyRelatedList = component.get("v.record.productFamilyRelatedList");
         component.set("v.record.showcontractDescription", false);
        component.set("v.expandNDC", true);
        var ndcmapObj ={};
        var allData= [];
        prodFamilyRelatedList.forEach(function(rec){
       
           if(ndcmapObj.hasOwnProperty(rec.T2_material_description__c)){
                
               var relatedList = ndcmapObj[rec.T2_material_description__c];
               relatedList.push(rec);
               ndcmapObj[rec.T2_material_description__c] = relatedList;
              
           }
           else{
            
               var relatedList =[];
               relatedList.push(rec);
              ndcmapObj[rec.T2_material_description__c] = relatedList;
              
           }
          
       });
        console.log('child cmp4 ndcmapObj===>'+JSON.stringify(ndcmapObj));
        var keys = Object.keys(ndcmapObj);
       
        var allData = [];
        for(var i=0; i<keys.length; i++){
          
            var obj = {};
            var relatedList = ndcmapObj[keys[i]];
            obj.material_Description__c = keys[i];
            obj.ndcRelatedList = relatedList;
     
            allData.push(obj);
        }
         component.set("v.materialDescriptionList",allData);
         /* for sorting*/
        var testREc = component.get("v.materialDescriptionList");
        console.log('testREc==>'+JSON.stringify(testREc));
        var hospitialMap = new Map();
        var SalesList = new Array();
        var listOfWrappers=[];
        testREc.forEach(function(eachRec){
            var relatedList = eachRec.ndcRelatedList;
            var totalVal=0;
            relatedList.forEach(function(chargeBackRec){
                var salesPrice = (chargeBackRec.T2_Contract_Sales_Indirect_Price__c != null && chargeBackRec.T2_Contract_Sales_Indirect_Price__c != undefined) ? chargeBackRec.T2_Contract_Sales_Indirect_Price__c : 0;
                totalVal= totalVal + salesPrice;
                
            });
            totalVal=Math.round(((totalVal/6) + Number.EPSILON) * 100) / 100;//Math.round(totalVal/6);
            
            
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
        component.set("v.materialDescriptionList",finaList);
        /*end for sorting*/
    },
    handleClick2: function(component, event, helper){
        component.set("v.expandNDC", false);
        component.set("v.record.showcontractDescription", true);
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
        //end summary//
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
     },
})