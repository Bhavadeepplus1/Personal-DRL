({
     doInit:function(component, event, helper){
           helper.getAllTotals(component,event,helper);
       console.log('november 22 child_cmp5==>'+component.get("v.firstColumnKey")); 
        var ndcRelatedList = component.get("v.record.ndcRelatedList");
        console.log('child5 ndc related list==>'+JSON.stringify(ndcRelatedList));
         var monthyearmapObj ={};
        var allData= [];
         ndcRelatedList.forEach(function(rec){
           console.log('test Month_Year__c==>'+rec.Month_Year__c);
           if(monthyearmapObj.hasOwnProperty(rec.Month_Year__c)){
                 console.log('inside Month_Year__c==>'+rec.Month_Year__c);
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
         var salesListMonthWise =[];
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
        
        for(var i=0 ; i<allData.length ; i++){
             console.log('keyyy child cmp4==>'+keyList);
            var sampleList = allData[i]['monthyearRelatedList'];
            if(keyList[i] == component.get("v.firstColumnKey")){
                sampleList.forEach(function(rec){
                octchargeBackAmount = octchargeBackAmount+Math.round(rec.Contract_Sales_Indirect_Price__c);
                col1Units = col1Units+Math.round(rec.contract_units_paid_qty__c);
                    
                 });
            }
            if(keyList[i] == component.get("v.secondColumnKey")){
                sampleList.forEach(function(rec){
                novchargeBackAmount = novchargeBackAmount+Math.round(rec.Contract_Sales_Indirect_Price__c);
                    col2Units = col2Units+Math.round(rec.contract_units_paid_qty__c);
                 });
            }
             if(keyList[i] == component.get("v.thirdColumnKey")){
                sampleList.forEach(function(rec){
                decchargeBackAmount = decchargeBackAmount+Math.round(rec.Contract_Sales_Indirect_Price__c);
                    col3Units = col3Units+Math.round(rec.contract_units_paid_qty__c);
                 });
            }
            if(keyList[i] == component.get("v.fourthColumnKey")){
                
                 sampleList.forEach(function(rec){
                     console.log('testinggg charge back amount==>'+Math.round(rec.Contract_Sales_Indirect_Price__c));
                     janchargeBackAmount = janchargeBackAmount+Math.round(rec.Contract_Sales_Indirect_Price__c);
                     col4Units = col4Units+Math.round(rec.contract_units_paid_qty__c);
                 });
            }
            if(keyList[i] == component.get("v.fifthColumnKey")){
                sampleList.forEach(function(rec){
                febchargeBackAmount = febchargeBackAmount+Math.round(rec.Contract_Sales_Indirect_Price__c);
                    col5Units = col5Units+Math.round(rec.contract_units_paid_qty__c);
                 });
            }
            if(keyList[i] == component.get("v.sixthColumnKey")){
                sampleList.forEach(function(rec){
                marchchargeBackAmount = marchchargeBackAmount+Math.round(rec.Contract_Sales_Indirect_Price__c);
                    col6Units = col6Units+Math.round(rec.contract_units_paid_qty__c);
                 });
            }
           avgsalesofSixMonth = Math.round((octchargeBackAmount + novchargeBackAmount + decchargeBackAmount + janchargeBackAmount+febchargeBackAmount+marchchargeBackAmount)/6);
        	totalSalesofSixMonth = Math.round((octchargeBackAmount + novchargeBackAmount + decchargeBackAmount + janchargeBackAmount+febchargeBackAmount+marchchargeBackAmount));
        	avgunitsofSixMonth = Math.round((col1Units + col2Units + col3Units + col4Units+col5Units+col6Units)/6);
            totalunitsofSixMonth = Math.round((col1Units + col2Units + col3Units + col4Units+col5Units+col6Units));
        }
         salesListMonthWise.push(octchargeBackAmount);
            salesListMonthWise.push(novchargeBackAmount);
            salesListMonthWise.push(decchargeBackAmount);
            salesListMonthWise.push(janchargeBackAmount);
             salesListMonthWise.push(febchargeBackAmount);
            salesListMonthWise.push(marchchargeBackAmount);
         
         /*for highliting product*/
            console.log('salesListMonthWise==>'+salesListMonthWise.length)
            for(var i=0;i<salesListMonthWise.length;i++){
                if(salesListMonthWise[i] == 0 && salesListMonthWise[i+1] ==0){
                    component.set("v.highlightProduct",true);
                }
            }
            /*end for highliting product*/
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