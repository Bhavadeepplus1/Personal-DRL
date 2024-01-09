({
    	 getData: function(component, event, responseWrapper) {
             component.set("v.isProcessed",responseWrapper.isProcessed); 
               component.set("v.noOfRecords",responseWrapper.noOfRecords);
                component.set("v.RxComplianceObject",responseWrapper.ProductFamilyWrapperList);
                console.log('RxComplianceObject-->'+JSON.stringify(responseWrapper.ProductFamilyWrapperList));
                component.set("v.Month1",responseWrapper.Month1);
                component.set("v.Month2",responseWrapper.Month2);
                component.set("v.Month3",responseWrapper.Month3);
                component.set("v.Month4",responseWrapper.Month4);
                component.set("v.Month5",responseWrapper.Month5);
                component.set("v.Month6",responseWrapper.Month6);
             component.set("v.currentMonth",responseWrapper.Month7);
                if(responseWrapper.Month1 != undefined &&  responseWrapper.Month1 != null)
                    component.set("v.Mon1",responseWrapper.Month1.charAt(0));
               if(responseWrapper.Month1 != undefined &&  responseWrapper.Month2 != null)
                    component.set("v.Mon2",responseWrapper.Month2.charAt(0));
               if(responseWrapper.Month1 != undefined &&  responseWrapper.Month3 != null)
                    component.set("v.Mon3",responseWrapper.Month3.charAt(0));
               if(responseWrapper.Month1 != undefined &&  responseWrapper.Month4 != null)
                    component.set("v.Mon4",responseWrapper.Month4.charAt(0));
               if(responseWrapper.Month1 != undefined &&  responseWrapper.Month5 != null)
                    component.set("v.Mon5",responseWrapper.Month5.charAt(0));
               if(responseWrapper.Month1 != undefined &&  responseWrapper.Month6 != null)
                    component.set("v.Mon6",responseWrapper.Month6.charAt(0));
               if(responseWrapper.Month1 != undefined &&  responseWrapper.Month7 != null)
                     component.set("v.currentMon",responseWrapper.Month7.charAt(0));
      			//    console.log('Selected Director: '+component.get("v.userId"));

                
                   component.set('v.loaded',false);
         },
	 sortHelper: function(component, event, sortFieldName) {
       // var currentDir = component.get("v.isAsc");
       // component.set("v.isAsc",!currentDir);
       console.log('sortHelper');
        this.onSortResult(component, event, sortFieldName);
    },
    
    onSortResult: function(component, event, sortField) {
        console.log('onSortResult');
        var RxComplianceObject = component.get("v.RxComplianceObject");
        
        var currentDir = component.get("v.isAsc");
        component.set("v.isAsc",!currentDir);
        console.log('sort console---'+!currentDir);
        var records = component.get("v.RxComplianceObject");
       
        var key = function(a) { 
            console.log('a[name]===>'+a["prodFamName"])
            return a["prodFamName"];
            
        }
        var reverse = currentDir ? 1: -1;
        RxComplianceObject.sort(function(a,b){
            var a = key(a) ? key(a) : '';
            var b = key(b) ? key(b) : '';
            return reverse * ((a>b) - (b>a));
        });
        component.set("v.RxComplianceObject", RxComplianceObject);
           
        component.set("v.loaded",false);
        /*  var sortAsc = component.get("v.isAsc"),
            sortField = 'prodFamName',
            records = component.get("v.responseObj");
        sortAsc = field == sortField? !sortAsc: true;
        records.sort(function(a,b){
            var t1 = parseFloat(a[field]) == parseFloat(b[field]),
                t2 = (!parseFloat(a[field]) && parseFloat(b[field])) || (parseFloat(a[field]) < parseFloat(b[field]));
            console.log('a-----',+a[field]);
            console.log('b-----',+b[field]);
            console.log('t2----',+t2);
            console.log('return----'+t1? 0: (sortAsc?-1:1)*(t2?1:-1));
            return t1? 0: (sortAsc?-1:1)*(t2?1:-1);
        });
     
        component.set("v.isAsc", sortAsc);
          for(var i=0;i<records.length;i++){
                for(var j=0; j<(records[i].rxComplianceList).length; j++){
                   var key = function(a) { return a[sortField]; }
            var reverse = sortAsc ? 1: -1;
        records[i].rxComplianceList.sort(function(a,b){
                    var a = key(a) ? parseFloat(key(a)) : '';
                    var b = key(b) ? parseFloat(key(b)) : '';
                    return reverse * ((a>b) - (b>a));
                });  
             
                }
       }
        component.set("v.responseObj", records);
        console.log('records==>'+JSON.stringify(records))
        component.set('v.loaded', false);*/
     
      
    },
     convertArrayOfObjectsToCSV: function(component,objectRecords,familyTotalsMap){
        // declare variables
        var selectedRec2 = component.get("v.columndata");
        console.log('checked OTC>>  '+ component.get("v.columndata"));
        var csvStringResult, counter, keys,columnDivider, lineDivider,linesResult;
        // check if "objectRecords" parameter is null, then return from function
        if (objectRecords == null || !objectRecords.length) {
            return null;
        }
                console.log('seg bool export otc=====',component.get("v.Vision_Segment__c"));

        // store ,[comma] in columnDivider variabel for sparate CSV values and 
        // for start next line use '\n' [new line] in lineDivider varaible  
        columnDivider = ',';
        lineDivider =  '\n';
        
        // in the keys valirable store fields API Names as a key 
        // this labels use in CSV file header 
         csvStringResult = '';
         linesResult = '';
         
         var myMap = new Map();
        myMap.set("Product Family", "Vision_Product__r.Family");
         myMap.set("Item Description", "Vision_Product__r.Name");
         myMap.set("NDC", "Vision_Product__r.Phoenix_NDC_11__c");
         myMap.set("Pkg Size", "Vision_Product__r.Phoenix_Pkg_Size__c");
         if(component.get("v.isTotal")== true){
         myMap.set("Annual", "Total_Awarded_Information__c");  
             myMap.set("Target Qtr", "QTD_Total_Awarded_Quantity__c");  
             myMap.set("Act QTD", "QTD_Total_Quantity__c"); 
             myMap.set("QTD C%", "QTD_Total_Complaince__c");  
             myMap.set("Target FTD", "FTD_Total_Awarded_Quantity__c");  
             myMap.set("Act FTD", "FTD_Total_Quantity__c"); 
             myMap.set("FTD C%", "FTD_Total_Compliance__c");  
             myMap.set("Target CTD", "CTD_Total_Awarded_Quantity__c");  
             myMap.set("Act CTD", "CTD_Total_Quantity__c"); 
             myMap.set("CTD C%", "CTD_Total_Compliance__c");  
              myMap.set("Target MTD", "MTD_Total_Awarded_Quantity__c");  
             myMap.set("Act MTD", "M1_Total_Quantity__c"); 
             myMap.set("MTD C%", "MTD_Total_Compliance__c");  
         myMap.set("Monthly", "Total_Awarded_Information_Monthly__c"); 
         myMap.set("Act"+'-'+component.get("v.Month6"), "M7_Total_Quantity__c");  
         myMap.set("C%"+'-'+component.get("v.Month6"), "M7_Total_Compliance__c"); 
         myMap.set("Act"+'-'+component.get("v.Month5"), "M6_Total_Quantity__c");  
         myMap.set("C%"+'-'+component.get("v.Month5"), "M6_Total_Compliance__c"); 
         myMap.set("Act"+'-'+component.get("v.Month4"), "M5_Total_Quantity__c");  
         myMap.set("C%"+'-'+component.get("v.Month4"), "M5_Total_Compliance__c"); 
         myMap.set("Act"+'-'+component.get("v.Month3"), "M4_Total_Quantity__c");  
         myMap.set("C%"+'-'+component.get("v.Month3"), "M4_Total_Compliance__c"); 
         myMap.set("Act"+'-'+component.get("v.Month2"), "M3_Total_Quantity__c");  
         myMap.set("C%"+'-'+component.get("v.Month2"), "M3_Total_Compliance__c"); 
         myMap.set("Act"+'-'+component.get("v.Month1"), "M2_Total_Quantity__c");  
         myMap.set("C%"+'-'+component.get("v.Month1"), "M2_Total_Compliance__c"); 
         
   
         }
         if(component.get("v.isDirect")== true){
         myMap.set("Annual", "Awarded_Information__c");  
             myMap.set("Target Qtr", "QTD_Direct_Awarded_Quantity__c");  
             myMap.set("Act QTD", "QTD_Direct_Quantity__c"); 
             myMap.set("QTD C%", "QTD_Direct_Compliance__c");  
             myMap.set("Target FTD", "FTD_Direct_Awarded_Quantity__c");  
             myMap.set("Act FTD", "FTD_Direct_Quantity__c"); 
             myMap.set("FTD C%", "FTD_Direct_Compliance__c");  
             myMap.set("Target CTD", "CTD_Direct_Awarded_Quantity__c");  
             myMap.set("Act CTD", "CTD_Direct_Quantity__c"); 
             myMap.set("CTD C%", "CTD_Direct_Complaince__c");  
             myMap.set("Target Monthly", "MTD_Direct_Awarded_Quantity__c");  
             myMap.set("Act MTD", "M1_Quantity__c"); 
             myMap.set("MTD C%", "MTD_Direct_Complaince__c");  
         myMap.set("Monthly", "Direct_Awarded_Quantity_Monthly__c"); 
         myMap.set("Act"+'-'+component.get("v.Month6"), "M7_Quantity__c");  
         myMap.set("C%"+'-'+component.get("v.Month6"), "M7_Direct_Qty_Compliance__c"); 
         myMap.set("Act"+'-'+component.get("v.Month5"), "M6_Quantity__c");  
         myMap.set("C%"+'-'+component.get("v.Month5"), "M6_Direct_Qty_Compliance__c"); 
         myMap.set("Act"+'-'+component.get("v.Month4"), "M5_Quantity__c");  
         myMap.set("C%"+'-'+component.get("v.Month4"), "M5_Direct_Qty_Compliance__c"); 
         myMap.set("Act"+'-'+component.get("v.Month3"), "M4_Quantity__c");  
         myMap.set("C%"+'-'+component.get("v.Month3"), "M4_Direct_Qty_Compliance__c"); 
         myMap.set("Act"+'-'+component.get("v.Month2"), "M3_Quantity__c");  
         myMap.set("C%"+'-'+component.get("v.Month2"), "M3_Direct_Qty_Compliance__c"); 
         myMap.set("Act"+'-'+component.get("v.Month1"), "M2_Quantity__c");  
         myMap.set("C%"+'-'+component.get("v.Month1"), "M2_Direct_Qty_Compliance__c"); 
         }
          if(component.get("v.isIndirect")== true){
         myMap.set("Annual", "Indirect_Awarded_Information__c");  
               myMap.set("Target Qtr", "QTD_Indirect_Awarded_Quantity__c");  
             myMap.set("Act QTD", "QTD_Indirect_Quantity__c"); 
             myMap.set("QTD C%", "QTD_Indirect_Complaince__c");  
             myMap.set("Target FTD", "FTD_Indirect_Awarded_Quantity__c");  
             myMap.set("Act FTD", "FTD_Indirect_Quantity__c"); 
             myMap.set("FTD C%", "FTD_Indirect_Complaince__c");  
             myMap.set("Target CTD", "CTD_Indirect_Awarded_Quantity__c");  
             myMap.set("Act CTD", "CTD_Indirect_Quantity__c"); 
             myMap.set("CTD C%", "CTD_Indirect_Compliance__c");  
               myMap.set("Target Month", "MTD_Indirect_Awarded_Quantity__c");  
             myMap.set("Act MTD", "M1_Indirect_Quantity__c"); 
             myMap.set("MTD C%", "MTD_Indirect_Compliance__c");  
         myMap.set("Monthly", "Indirect_Awarded_Quantity_Monthly__c"); 
         myMap.set("Act"+'-'+component.get("v.Month6"), "M7_Indirect_Quantity__c");  
         myMap.set("C%"+'-'+component.get("v.Month6"), "M7_Indirect_Qty_Compliance__c"); 
         myMap.set("Act"+'-'+component.get("v.Month5"), "M6_Indirect_Quantity__c");  
         myMap.set("C%"+'-'+component.get("v.Month5"), "M6_Indirect_Qty_Compliance__c"); 
         myMap.set("Act"+'-'+component.get("v.Month4"), "M5_Indirect_Quantity__c");  
         myMap.set("C%"+'-'+component.get("v.Month4"), "M5_Indirect_Qty_Compliance__c"); 
         myMap.set("Act"+'-'+component.get("v.Month3"), "M4_Indirect_Quantity__c");  
         myMap.set("C%"+'-'+component.get("v.Month3"), "M4_Indirect_Qty_Compliance__c"); 
         myMap.set("Act"+'-'+component.get("v.Month2"), "M3_Indirect_Quantity__c");  
         myMap.set("C%"+'-'+component.get("v.Month2"), "M3_Indirect_Qty_Compliance__c"); 
         myMap.set("Act"+'-'+component.get("v.Month1"), "M2_Indirect_Quantity__c");  
         myMap.set("C%"+'-'+component.get("v.Month1"), "M2_Indirect_Qty_Compliance__c"); 
         }
         csvStringResult += Array.from(myMap.keys()).join(columnDivider);
         csvStringResult += lineDivider;
         

        //new logic start 
      for(var i=0; i < objectRecords.length; i++){  
            counter = 0;
          if(JSON.stringify(objectRecords[i]["Vision_Product__r"]["Family"]) != linesResult)
            {
                console.log('Inside if objectRecords '+i+''+JSON.stringify(objectRecords[i].Vision_Product__r.Family));
                console.log('before lines result is '+linesResult+'The length is '+linesResult.length);
                console.log(linesResult);
                if(component.get("v.isDirect")){
                csvStringResult += JSON.stringify(objectRecords[i]["Vision_Product__r"]["Family"])+columnDivider+columnDivider+columnDivider+columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].DirectAwardedQuantity)
                +columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].QTDDirectAwardedQty)+columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].QTDDirectAct)+columnDivider+((familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].QTDDirectAct)/(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].QTDDirectAwardedQty)*100).toFixed(0)
                +columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].FTDDirectAwardedQty)+columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].FTDDirectAct)+columnDivider+((familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].FTDDirectAct)/(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].FTDDirectAwardedQty)*100).toFixed(0)
                +columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].CTDDirectAwardedQty)+columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].CTDDirectAct)+columnDivider+((familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].CTDDirectAct)/(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].CTDDirectAwardedQty)*100).toFixed(0)
                +columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].MTDDirectAwardedQty)+columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].MTDDirectAct)+columnDivider+((familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].MTDDirectAct)/(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].MTDDirectAwardedQty)*100).toFixed(0)
                +columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].DirectAwardedQtyMonthly).toFixed(0)
                +columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M7DirectAct)+columnDivider+((familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M7DirectAct)/(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].DirectAwardedQtyMonthly)*100).toFixed(0)
                +columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M6DirectAct)+columnDivider+((familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M6DirectAct)/(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].DirectAwardedQtyMonthly)*100).toFixed(0)
                +columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M5DirectAct)+columnDivider+((familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M5DirectAct)/(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].DirectAwardedQtyMonthly)*100).toFixed(0)
                +columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M4DirectAct)+columnDivider+((familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M4DirectAct)/(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].DirectAwardedQtyMonthly)*100).toFixed(0)
                +columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M3DirectAct)+columnDivider+((familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M3DirectAct)/(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].DirectAwardedQtyMonthly)*100).toFixed(0)
                +columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M2DirectAct)+columnDivider+((familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M2DirectAct)/(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].DirectAwardedQtyMonthly)*100).toFixed(0)
                +lineDivider;
                }
                 if(component.get("v.isTotal")){
                csvStringResult += JSON.stringify(objectRecords[i]["Vision_Product__r"]["Family"])+columnDivider+columnDivider+columnDivider+columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].TotalAwardedQuantity)
                 +columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].QTDTotalAwardedQty)+columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].QTDTotalAct)+columnDivider+((familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].QTDTotalAct)/(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].QTDTotalAwardedQty)*100).toFixed(0)
                +columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].FTDTotalAwardedQty)+columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].FTDTotalAct)+columnDivider+((familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].FTDTotalAct)/(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].FTDTotalAwardedQty)*100).toFixed(0)
                +columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].CTDTotalAwardedQty)+columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].CTDTotalAct)+columnDivider+((familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].CTDTotalAct)/(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].CTDTotalAwardedQty)*100).toFixed(0)
                                +columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].MTDTotalAwardedQty)+columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].MTDTotalAct)+columnDivider+((familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].MTDTotalAct)/(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].MTDTotalAwardedQty)*100).toFixed(0)
+columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].TotalAwardedQtyMonthly).toFixed(0)
                +columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M7TotalAct)+columnDivider+((familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M7TotalAct)/(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].TotalAwardedQtyMonthly)*100).toFixed(0)
                +columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M6TotalAct)+columnDivider+((familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M6TotalAct)/(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].TotalAwardedQtyMonthly)*100).toFixed(0)
                +columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M5TotalAct)+columnDivider+((familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M5TotalAct)/(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].TotalAwardedQtyMonthly)*100).toFixed(0)
                +columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M4TotalAct)+columnDivider+((familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M4TotalAct)/(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].TotalAwardedQtyMonthly)*100).toFixed(0)
                +columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M3TotalAct)+columnDivider+((familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M3TotalAct)/(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].TotalAwardedQtyMonthly)*100).toFixed(0)
                +columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M2TotalAct)+columnDivider+((familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M2TotalAct)/(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].TotalAwardedQtyMonthly)*100).toFixed(0)
                +lineDivider;
                }
                 if(component.get("v.isIndirect")){
                csvStringResult += JSON.stringify(objectRecords[i]["Vision_Product__r"]["Family"])+columnDivider+columnDivider+columnDivider+columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].IndirectAwardedQuantity)
                 +columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].QTDIndirectAwardedQty)+columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].QTDIndirectAct)+columnDivider+((familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].QTDIndirectAct)/(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].QTDIndirectAwardedQty)*100).toFixed(0)
                +columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].FTDIndirectAwardedQty)+columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].FTDIndirectAct)+columnDivider+((familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].FTDIndirectAct)/(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].FTDIndirectAwardedQty)*100).toFixed(0)
                +columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].CTDIndirectAwardedQty)+columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].CTDIndirectAct)+columnDivider+((familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].CTDIndirectAct)/(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].CTDIndirectAwardedQty)*100).toFixed(0)
                +columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].MTDIndirectAwardedQty)+columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].MTDIndirectAct)+columnDivider+((familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].MTDIndirectAct)/(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].MTDIndirectAwardedQty)*100).toFixed(0)
+columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].IndirectAwardedQtyMonthly).toFixed(0)
                +columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M7InDirectAct)+columnDivider+((familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M7InDirectAct)/(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].IndirectAwardedQtyMonthly)*100).toFixed(0)
                +columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M6InDirectAct)+columnDivider+((familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M6InDirectAct)/(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].IndirectAwardedQtyMonthly)*100).toFixed(0)
                +columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M5InDirectAct)+columnDivider+((familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M5InDirectAct)/(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].IndirectAwardedQtyMonthly)*100).toFixed(0)
                +columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M4InDirectAct)+columnDivider+((familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M4InDirectAct)/(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].IndirectAwardedQtyMonthly)*100).toFixed(0)
                +columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M3InDirectAct)+columnDivider+((familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M3InDirectAct)/(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].IndirectAwardedQtyMonthly)*100).toFixed(0)
                +columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M2InDirectAct)+columnDivider+((familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M2InDirectAct)/(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].IndirectAwardedQtyMonthly)*100).toFixed(0)
                +lineDivider;
                }
                //csvStringResult += +columnDivider+columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M7DirectAct)+columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].DirectAwardedQuantity)+columnDivider+columnDivider+columnDivider+columnDivider+columnDivider+columnDivider+columnDivider+columnDivider+columnDivider+columnDivider+columnDivider+columnDivider+columnDivider+columnDivider+columnDivider+lineDivider;
                console.log('Now the csvStringResult is '+csvStringResult);
                // csvStringResult +=  lineDivider;
                linesResult=null;
                linesResult='';
                //linesResult+=objectRecords[i].Phoenix_Product__r.Family;
                console.log('Now the lines result is '+linesResult+'The length is '+linesResult.length);
            }
            for (let [key, value] of myMap) {
                if(counter > 0 ){ 
                    csvStringResult += columnDivider;   
                }
                console.log('testing result--->'+JSON.stringify(objectRecords[i]));
                if (value == 'Vision_Product__r.Family') {
                  //  csvStringResult += '"' + objectRecords[i]["Vision_Product__r"]["Family"] + '"';
                    csvStringResult += '"' + '' + '"';
                    linesResult=null;
                    linesResult='';
                    linesResult += '"' + objectRecords[i]["Vision_Product__r"]["Family"] + '"';
                    console.log('Iniside if the lines result is '+linesResult);
                }
                else if(value=='Vision_Product__r.Name'){
                    csvStringResult += '"'+ objectRecords[i]["Vision_Product__r"]["Name"]+'"';
                }
             
                else if(value=='Vision_Product__r.Phoenix_NDC_11__c'){
                    csvStringResult += '"'+ objectRecords[i]["Vision_Product__r"]["Phoenix_NDC_11__c"]+'"';
                }
                else if(value=='Vision_Product__r.Phoenix_Pkg_Size__c'){
                    csvStringResult += '"'+ objectRecords[i]["Vision_Product__r"]["Phoenix_Pkg_Size__c"]+'"';
                }
                else if(value == 'QTD_Direct_Awarded_Quantity__c'){
                   var cmfeeperunit = objectRecords[i]['QTD_Direct_Awarded_Quantity__c'];
                   // console.log("cmfeeperunit--->"+cmfeeperunit);
                    if(cmfeeperunit != null){
                    var roundecmfeeperunit=Math.round(cmfeeperunit)
                    csvStringResult += '"'+roundecmfeeperunit+'"';  
                    }
                    else{
                        csvStringResult += '"'+''+'"';
                    }       
                 }
                else if(value == 'FTD_Direct_Awarded_Quantity__c'){
                   var ftdaq = objectRecords[i]['FTD_Direct_Awarded_Quantity__c'];
                   // console.log("cmfeeperunit--->"+cmfeeperunit);
                    if(ftdaq != null){
                    var roundftdaq =Math.round(ftdaq)
                    csvStringResult += '"'+roundftdaq+'"';  
                    }
                    else{
                        csvStringResult += '"'+''+'"';
                    }       
                 }
                else if(value == 'CTD_Direct_Awarded_Quantity__c'){
                   var ctdaq = objectRecords[i]['CTD_Direct_Awarded_Quantity__c'];
                   // console.log("cmfeeperunit--->"+cmfeeperunit);
                    if(ctdaq != null){
                    var roundctdaq =Math.round(ctdaq)
                    csvStringResult += '"'+roundctdaq+'"';  
                    }
                    else{
                        csvStringResult += '"'+''+'"';
                    }       
                 }
                 else if(value == 'MTD_Direct_Awarded_Quantity__c'){
                   var mtdaq = objectRecords[i]['MTD_Direct_Awarded_Quantity__c'];
                   // console.log("cmfeeperunit--->"+cmfeeperunit);
                    if(mtdaq != null){
                    var roundmtdaq =Math.round(mtdaq)
                    csvStringResult += '"'+roundmtdaq+'"';  
                    }
                    else{
                        csvStringResult += '"'+''+'"';
                    }       
                 }
                 else if(value == 'QTD_Total_Awarded_Quantity__c'){
                   var cmfeeperunitTotal = objectRecords[i]['QTD_Total_Awarded_Quantity__c'];
                   // console.log("cmfeeperunit--->"+cmfeeperunit);
                    if(cmfeeperunitTotal != null){
                    var roundecmfeeperunitTotal=Math.round(cmfeeperunitTotal)
                    csvStringResult += '"'+roundecmfeeperunitTotal+'"';  
                    }
                    else{
                        csvStringResult += '"'+''+'"';
                    }       
                 }
                else if(value == 'FTD_Total_Awarded_Quantity__c'){
                   var ftdaqTotal = objectRecords[i]['FTD_Total_Awarded_Quantity__c'];
                   // console.log("cmfeeperunit--->"+cmfeeperunit);
                    if(ftdaqTotal != null){
                    var roundftdaqTotal =Math.round(ftdaqTotal)
                    csvStringResult += '"'+roundftdaqTotal+'"';  
                    }
                    else{
                        csvStringResult += '"'+''+'"';
                    }       
                 }
                else if(value == 'CTD_Total_Awarded_Quantity__c'){
                   var ctdaqTotal = objectRecords[i]['CTD_Total_Awarded_Quantity__c'];
                   // console.log("cmfeeperunit--->"+cmfeeperunit);
                    if(ctdaqTotal != null){
                    var roundctdaqTotal =Math.round(ctdaqTotal)
                    csvStringResult += '"'+roundctdaqTotal+'"';  
                    }
                    else{
                        csvStringResult += '"'+''+'"';
                    }       
                 }
                 else if(value == 'MTD_Total_Awarded_Quantity__c'){
                   var mtdaqTotal = objectRecords[i]['MTD_Total_Awarded_Quantity__c'];
                   // console.log("cmfeeperunit--->"+cmfeeperunit);
                    if(ctdaqTotal != null){
                    var roundmtdaqTotal =Math.round(mtdaqTotal)
                    csvStringResult += '"'+roundmtdaqTotal+'"';  
                    }
                    else{
                        csvStringResult += '"'+''+'"';
                    }       
                 }
                else if(value == 'QTD_Indirect_Awarded_Quantity__c'){
                   var cmfeeperunitIndirect = objectRecords[i]['QTD_Indirect_Awarded_Quantity__c'];
                   // console.log("cmfeeperunit--->"+cmfeeperunit);
                    if(cmfeeperunitIndirect != null){
                    var roundecmfeeperunitIndirect=Math.round(cmfeeperunitIndirect)
                    csvStringResult += '"'+roundecmfeeperunitIndirect+'"';  
                    }
                    else{
                        csvStringResult += '"'+''+'"';
                    }       
                 }
                else if(value == 'FTD_Indirect_Awarded_Quantity__c'){
                   var ftdaqIndirect = objectRecords[i]['FTD_Indirect_Awarded_Quantity__c'];
                   // console.log("cmfeeperunit--->"+cmfeeperunit);
                    if(ftdaqIndirect != null){
                    var roundftdaqIndirect =Math.round(ftdaqIndirect)
                    csvStringResult += '"'+roundftdaqIndirect+'"';  
                    }
                    else{
                        csvStringResult += '"'+''+'"';
                    }       
                 }
                else if(value == 'CTD_Indirect_Awarded_Quantity__c'){
                   var ctdaqIndirect = objectRecords[i]['CTD_Indirect_Awarded_Quantity__c'];
                   // console.log("cmfeeperunit--->"+cmfeeperunit);
                    if(ctdaqIndirect != null){
                    var roundctdaqIndirect =Math.round(ctdaqIndirect)
                    csvStringResult += '"'+roundctdaqIndirect+'"';  
                    }
                    else{
                        csvStringResult += '"'+''+'"';
                    }       
                 }
                  else if(value == 'MTD_Indirect_Awarded_Quantity__c'){
                   var mtdaqIndirect = objectRecords[i]['MTD_Indirect_Awarded_Quantity__c'];
                   // console.log("cmfeeperunit--->"+cmfeeperunit);
                    if(mtdaqIndirect != null){
                    var roundmtdaqIndirect =Math.round(mtdaqIndirect)
                    csvStringResult += '"'+roundmtdaqIndirect+'"';  
                    }
                    else{
                        csvStringResult += '"'+''+'"';
                    }       
                 }
                else if(objectRecords[i][value]==undefined){
                        //console.log('Iam in last ELSEE if---->');
                       	csvStringResult += '"'+''+'"';
                    	}   
                      else{
                          csvStringResult += '"'+ objectRecords[i][value]+'"'; 
                      }
           
                  counter++;
            }
            csvStringResult += lineDivider;
        }  
            
        
           
        //new logic end 
        return csvStringResult;        
    },
    
})