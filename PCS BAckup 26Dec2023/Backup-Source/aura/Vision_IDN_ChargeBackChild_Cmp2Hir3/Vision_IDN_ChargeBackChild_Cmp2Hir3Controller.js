({
    doInit:function(component, event, helper){
        
       var hospitalrelatedList = component.get("v.record.hospitalrelatedList");
      //  console.log('Hospital Name==>'+child1relatedList[0].Hospital_Name__c);
       // component.set("v.hospital",child1relatedList[0].Hospital_Name__c);
        component.set("v.hospitalrelatedList",hospitalrelatedList);
       // console.log('doInit child1relatedList==>'+JSON.stringify(component.get("v.record")));
      //  console.log('child1relatedList length===>'+child1relatedList.length)
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
        var hospitalPFamilyList =[];
        var salesListMonthWise =[];
         var unitsListMonthWise =[];
        hospitalrelatedList.forEach(function(rec){
                                      console.log('Success month year==>'+rec.Month_Year__c);
                                       if(rec.Month_Year__c == component.get("v.firstColumnKey")){
                                           firstColSalesSummary += Math.round(rec.Contract_Sales_Indirect_Price__c);
                                           firstColUnitsSummary +=  Math.round(rec.contract_units_paid_qty__c);
                                           hospitalPFamilyList.push(rec.revised_product_family__c);
                                       }
                                       if(rec.Month_Year__c == component.get("v.secondColumnKey")){
                                           secColSalesSummary += Math.round(rec.Contract_Sales_Indirect_Price__c);
                                           secColUnitsSummary +=  Math.round(rec.contract_units_paid_qty__c);
                                            hospitalPFamilyList.push(rec.revised_product_family__c);
                                       }
                                       if(rec.Month_Year__c == component.get("v.thirdColumnKey")){
                                           thirdColSalesSummary += Math.round(rec.Contract_Sales_Indirect_Price__c);
                                           thirdColUnitsSummary +=  Math.round(rec.contract_units_paid_qty__c);
                                            hospitalPFamilyList.push(rec.revised_product_family__c);
                                       }
                                       if(rec.Month_Year__c == component.get("v.fourthColumnKey")){
                                           fourthColSalesSummary += Math.round(rec.Contract_Sales_Indirect_Price__c);
                                           fourthColUnitsSummary +=  Math.round(rec.contract_units_paid_qty__c);
                                            hospitalPFamilyList.push(rec.revised_product_family__c);
                                       }
                                       if(rec.Month_Year__c == component.get("v.fifthColumnKey")){
                                           fifthColSalesSummary += Math.round(rec.Contract_Sales_Indirect_Price__c);
                                           fifthColUnitsSummary +=  Math.round(rec.contract_units_paid_qty__c);
                                            hospitalPFamilyList.push(rec.revised_product_family__c);
                                       }
                                       if(rec.Month_Year__c == component.get("v.sixthColumnKey")){
                                           sixthColSalesSummary += Math.round(rec.Contract_Sales_Indirect_Price__c);
                                           sixthColUnitsSummary +=  Math.round(rec.contract_units_paid_qty__c);
                                            hospitalPFamilyList.push(rec.revised_product_family__c);
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
                    component.set("v.highlightHospital",true);
                }
            }
            /*end for highliting Hospital*/
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
        component.set("v.hospitalPFamilyList",hospitalPFamilyList);
         /*for dual graph*/
            component.set("v.salesListMonthWise",salesListMonthWise);
            component.set("v.unitsListMonthWise",unitsListMonthWise);
            /*for dual graph*/
        helper.getAllTotals(component,event,helper); 
        
    },
	handleClick1: function(component, event, helper){
        component.set("v.expandHospital", true);
        component.set("v.record.showChild1", false);
       
       // component.set("v.showChild1",showChild1)
       var hospitalrelatedList = component.get("v.record.hospitalrelatedList");
        console.log('child1relatedList==>'+JSON.stringify(hospitalrelatedList));
        var child1mapObj ={};
        var allData= [];
       hospitalrelatedList.forEach(function(rec){
           console.log('test child cmp2==>'+rec.Child1_Name__c);
           if(child1mapObj.hasOwnProperty(rec.Child1_Name__c)){
                 
               var relatedList = child1mapObj[rec.Child1_Name__c];
               relatedList.push(rec);
               child1mapObj[rec.Child1_Name__c] = relatedList;
              
           }
           else{
              console.log('inside else productFamilyList child cmp2==>');
               var relatedList =[];
               relatedList.push(rec);
              child1mapObj[rec.Child1_Name__c] = relatedList;
              
           }
          
       });
        console.log('child cmp2 child1mapObj===>'+JSON.stringify(child1mapObj));
        var keys = Object.keys(child1mapObj);
         console.log('child cmp2 keys==>'+keys);
        var allData = [];
        for(var i=0; i<keys.length; i++){
            console.log('keyyy child cmp2==>'+keys[i]);
            var obj = {};
            var relatedList = child1mapObj[keys[i]];
            obj.showChild1Name= true;
            obj.child1Name = keys[i];
            obj.child1RelatedList = relatedList;
            /*
    obj = {
        child1: 'None',
        child1RelatedList: relatedList
    }
    */    
    allData.push(obj);
}
         
         //console.log('length==>'+child1RelatedList.length);
       
        component.set("v.child1List",allData);
         console.log('allData child1 with family===>'+JSON.stringify(allData));
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
          
            
        });
        component.set("v.child1List",finaList);
        /*end for sorting*/
    },
     handleClick2: function(component, event, helper){
        console.log("indexxx==>"+component.get("v.index"))
        component.set("v.expandHospital", false);
        component.set("v.record.showChild1", true);
     },
    displayChart: function(component, event, helper){
        component.set("v.isModalOpen", true);
        component.set("v.showChart", true);
        component.set("v.chartType", 'Bar');
         var selectedHospital = event.getSource().get("v.value");
        console.log('selectedHospital: '+selectedHospital);
    },
      displayChartUnits:function(component, event, helper){
        component.set("v.isModalOpenUnits", true);
        component.set("v.showChart", true);
        component.set("v.chartType", 'Bar');
        var selectedHospital = event.getSource().get("v.value");
        console.log('selectedHospital: '+selectedHospital);
       component.set("v.dualChart", 'Child1');
     
    },
    closeModal: function(component, event, helper){
        component.set("v.isModalOpen", false);
         
    },
     closeModalUnits: function(component, event, helper){
        component.set("v.isModalOpenUnits", false);
         
    },
    comparingSales:function(component, event, helper){
        var total12monthsales = component.get("v.twmonthsSalesTotal")
        var current6monthsales = component.get("v.totalofSalesSummary")
        var prev6monthsSales = component.get("v.twmonthsSalesTotal") - component.get("v.totalofSalesSummary") ;
       //console.log('prev6monthsSales===??'+prev6monthsSales);
        var salesPercentage = prev6monthsSales != 0 ? (( current6monthsales - prev6monthsSales )/prev6monthsSales) *100 : 0;
      /*  if(current6monthsales > prev6monthsSales || current6monthsales == prev6monthsSales){
        var salesPercentage = (prev6monthsSales !=0 && prev6monthsSales !=null) ? ( prev6monthsSales/current6monthsales)*100 : 0
        }
        else{
            var salesPercentage = (prev6monthsSales !=0 && prev6monthsSales !=null) ? ( prev6monthsSales/current6monthsales - 1)*100 : 0
 
        } if(currentTotalSales > prevTotalSales){
            component.set("v.showColor",true);
        }else {
            component.set("v.showColor",false);
        }*/
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