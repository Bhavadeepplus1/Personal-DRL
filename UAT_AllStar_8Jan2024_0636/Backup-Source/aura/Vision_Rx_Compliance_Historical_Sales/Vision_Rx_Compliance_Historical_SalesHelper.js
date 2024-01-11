({
    getData: function(component, event, responseWrapper) {
               component.set("v.noOfRecords",responseWrapper.noOfRecords);
                     component.set("v.isProcessed",responseWrapper.isProcessed);
                component.set("v.RxComplianceObject",responseWrapper.ProductFamilyWrapperList);
                console.log('RxComplianceObject-->'+JSON.stringify(responseWrapper.ProductFamilyWrapperList));
                component.set("v.Month1",responseWrapper.Month1);
                component.set("v.Month2",responseWrapper.Month2);
                component.set("v.Month3",responseWrapper.Month3);
                component.set("v.Month4",responseWrapper.Month4);
                component.set("v.Month5",responseWrapper.Month5);
                component.set("v.Month6",responseWrapper.Month6);
         //component.set("v.currentMonth",responseWrapper.Month7);
                if(responseWrapper.Month1 != undefined &&  responseWrapper.Month1 != null){
                    component.set("v.Mon1",responseWrapper.Month1.charAt(0));
                    component.set("v.Mon2",responseWrapper.Month2.charAt(0));
                    component.set("v.Mon3",responseWrapper.Month3.charAt(0));
                    component.set("v.Mon4",responseWrapper.Month4.charAt(0));
                    component.set("v.Mon5",responseWrapper.Month5.charAt(0));
                    component.set("v.Mon6",responseWrapper.Month6.charAt(0));
                                     //   component.set("v.currentMon",responseWrapper.Month7.charAt(0));

                }
                   component.set('v.loaded',false);
         },
	 sortHelper: function(component, event, sortFieldName) {
      //  var currentDir = component.get("v.isAsc");
     //   component.set("v.isAsc",!currentDir);
        this.onSortResult(component, event, sortFieldName);
    },
    
   /* onSortResult: function(component, event, sortField) {
        console.log('onSortResult');
      var RxComplianceObject = component.get("v.RxComplianceObject");
     
         var currentDir = component.get("v.isAsc");
        component.set("v.isAsc",!currentDir);
        console.log('sort console---'+!currentDir);
        var key = function(a) { 
            console.log('Vision_Product__c==='+a["Vision_Product__r"]["Name"]);
            return a["Vision_Product__r"]["Name"];
                              
                              }
            var reverse = currentDir ? 1: -1;
        RxComplianceObject.sort(function(a,b){
                    var a = key(a) ? key(a) : '';
                    var b = key(b) ? key(b) : '';
                    return reverse * ((a>b) - (b>a));
                });
        component.set("v.RxComplianceObject", RxComplianceObject);
            if(RxComplianceObject.length > 50){
                    function calculatePagesCount(pageSize, totalCount) {
                        return totalCount < pageSize ? 1 : Math.ceil(totalCount / pageSize);
                    }
                    
                    var pageSize = 50;
                    var itemsCount = RxComplianceObject.length;
                    var pagesCount = calculatePagesCount(pageSize, itemsCount);
                    var pageNumbers = [];
                    for(var i=0;i<pagesCount;i++){
                        pageNumbers.push(i+1);
                    }
                    component.set("v.pageNumbers",pageNumbers);
                    var pagedLineItems = RxComplianceObject.slice(0,50);
                    component.set("v.pagedLineItems",pagedLineItems);
                }
                else{
                    component.set("v.pagedLineItems",RxComplianceObject);
                    var pageNum=[];
                    component.set("v.pageNumbers",pageNum);
                }
                component.set("v.selectedPageNumber",'1');
        component.set("v.loaded",false);
        
        
      
    }, */
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
        
         myMap.set("Act"+'-'+component.get("v.Month6"), "M7_Total_Quantity__c");  
         myMap.set("Avg"+'-'+component.get("v.Month6"), "M7_Total_Avg_Quantity__c"); 
         myMap.set("C%"+'-'+component.get("v.Month6"), "M7_Total_Avg_Qty_Compliance__c");
             
              myMap.set("Act"+'-'+component.get("v.Month5"), "M6_Total_Quantity__c");  
         myMap.set("Avg"+'-'+component.get("v.Month5"), "M6_Total_Avg_Quantity__c"); 
         myMap.set("C%"+'-'+component.get("v.Month5"), "M6_Total_Avg_Qty_Compliance__c");
         
             
          myMap.set("Act"+'-'+component.get("v.Month4"), "M5_Total_Quantity__c");  
         myMap.set("Avg"+'-'+component.get("v.Month4"), "M5_Total_Avg_Quantity__c"); 
         myMap.set("C%"+'-'+component.get("v.Month4"), "M5_Total_Avg_Qty_Compliance__c");
         
          myMap.set("Act"+'-'+component.get("v.Month3"), "M4_Total_Quantity__c");  
         myMap.set("Avg"+'-'+component.get("v.Month3"), "M4_Total_Avg_Quantity__c"); 
         myMap.set("C%"+'-'+component.get("v.Month3"), "M4_Total_Avg_Qty_Compliance__c");
             
          myMap.set("Act"+'-'+component.get("v.Month2"), "M3_Total_Quantity__c");  
         myMap.set("Avg"+'-'+component.get("v.Month2"), "M3_Total_Avg_Quantity__c"); 
         myMap.set("C%"+'-'+component.get("v.Month2"), "M3_Total_Avg_Qty_Compliance__c");
             
          myMap.set("Act"+'-'+component.get("v.Month1"), "M2_Total_Quantity__c");  
         myMap.set("Avg"+'-'+component.get("v.Month1"), "M2_Total_Avg_Quantity__c"); 
         myMap.set("C%"+'-'+component.get("v.Month1"), "M2_Total_Avg_Qty_Compliance__c");
         
         
         
   
         }
         if(component.get("v.isDirect")== true){
         
         myMap.set("Act"+'-'+component.get("v.Month6"), "M7_Quantity__c");  
         myMap.set("Avg"+'-'+component.get("v.Month6"), "M7_Direct_Avg_Quantity__c"); 
         myMap.set("C%"+'-'+component.get("v.Month6"), "M7_Direct_Avg_Qty_Compliance__c");
             
         myMap.set("Act"+'-'+component.get("v.Month5"), "M6_Quantity__c");  
         myMap.set("Avg"+'-'+component.get("v.Month5"), "M6_Direct_Avg_Quantity__c"); 
         myMap.set("C%"+'-'+component.get("v.Month5"), "M6_Direct_Avg_Qty_Compliance__c");
             
         myMap.set("Act"+'-'+component.get("v.Month4"), "M5_Quantity__c");  
         myMap.set("Avg"+'-'+component.get("v.Month4"), "M5_Direct_Avg_Quantity__c"); 
         myMap.set("C%"+'-'+component.get("v.Month4"), "M5_Direct_Avg_Qty_Compliance__c");
             
         myMap.set("Act"+'-'+component.get("v.Month3"), "M4_Quantity__c");  
         myMap.set("Avg"+'-'+component.get("v.Month3"), "M4_Direct_Avg_Quantity__c"); 
         myMap.set("C%"+'-'+component.get("v.Month3"), "M4_Direct_Avg_Qty_Compliance__c");
             
         myMap.set("Act"+'-'+component.get("v.Month2"), "M3_Quantity__c");  
         myMap.set("Avg"+'-'+component.get("v.Month2"), "M3_Direct_Avg_Quantity__c"); 
         myMap.set("C%"+'-'+component.get("v.Month2"), "M3_Direct_Avg_Qty_Compliance__c");
             
         myMap.set("Act"+'-'+component.get("v.Month1"), "M2_Quantity__c");  
         myMap.set("Avg"+'-'+component.get("v.Month1"), "M2_Direct_Avg_Quantity__c"); 
         myMap.set("C%"+'-'+component.get("v.Month1"), "M2_Direct_Avg_Qty_Compliance__c");
        
             
             
         }
          if(component.get("v.isIndirect")== true){
         myMap.set("Act"+'-'+component.get("v.Month6"), "M7_Indirect_Quantity__c");  
         myMap.set("Avg"+'-'+component.get("v.Month6"), "M7_Indirect_Avg_Quantity__c"); 
         myMap.set("C%"+'-'+component.get("v.Month6"), "M7_Indirect_Avg_Qty_Compliance__c");
              
         myMap.set("Act"+'-'+component.get("v.Month5"), "M6_Indirect_Quantity__c");  
         myMap.set("Avg"+'-'+component.get("v.Month5"), "M6_Indirect_Avg_Quantity__c"); 
         myMap.set("C%"+'-'+component.get("v.Month5"), "M6_Indirect_Avg_Qty_Compliance__c");
              
              
         myMap.set("Act"+'-'+component.get("v.Month4"), "M5_Indirect_Quantity__c");  
         myMap.set("Avg"+'-'+component.get("v.Month4"), "M5_Indirect_Avg_Quantity__c"); 
         myMap.set("C%"+'-'+component.get("v.Month4"), "M5_Indirect_Avg_Qty_Compliance__c");
              
         myMap.set("Act"+'-'+component.get("v.Month3"), "M4_Indirect_Quantity__c");  
         myMap.set("Avg"+'-'+component.get("v.Month3"), "M4_Indirect_Avg_Quantity__c"); 
         myMap.set("C%"+'-'+component.get("v.Month3"), "M4_Indirect_Avg_Qty_Compliance__c");
              
         myMap.set("Act"+'-'+component.get("v.Month2"), "M3_Indirect_Quantity__c");  
         myMap.set("Avg"+'-'+component.get("v.Month2"), "M3_Indirect_Avg_Quantity__c"); 
         myMap.set("C%"+'-'+component.get("v.Month2"), "M3_Indirect_Avg_Qty_Compliance__c");
              
         myMap.set("Act"+'-'+component.get("v.Month1"), "M2_Indirect_Quantity__c");  
         myMap.set("Avg"+'-'+component.get("v.Month1"), "M2_Indirect_Avg_Quantity__c"); 
         myMap.set("C%"+'-'+component.get("v.Month1"), "M2_Indirect_Avg_Qty_Compliance__c");
              
              
              
              
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
                csvStringResult += JSON.stringify(objectRecords[i]["Vision_Product__r"]["Family"])+columnDivider+columnDivider+columnDivider
                +columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M7DirectAct)+columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M7DirectAvg).toFixed(0)+columnDivider+((familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M7DirectAct)/(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M7DirectAvg)*100).toFixed(0)
                +columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M6DirectAct)+columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M6DirectAvg).toFixed(0)+columnDivider+((familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M6DirectAct)/(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M6DirectAvg)*100).toFixed(0)
                +columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M5DirectAct)+columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M5DirectAvg).toFixed(0)+columnDivider+((familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M5DirectAct)/(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M5DirectAvg)*100).toFixed(0)
                +columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M4DirectAct)+columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M4DirectAvg).toFixed(0)+columnDivider+((familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M4DirectAct)/(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M4DirectAvg)*100).toFixed(0)
                +columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M3DirectAct)+columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M3DirectAvg.toFixed(0))+columnDivider+((familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M3DirectAct)/(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M3DirectAvg)*100).toFixed(0)
                +columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M2DirectAct)+columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M2DirectAvg).toFixed(0)+columnDivider+((familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M2DirectAct)/(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M2DirectAvg)*100).toFixed(0)
                +lineDivider;
                }
                 if(component.get("v.isTotal")){
                csvStringResult += JSON.stringify(objectRecords[i]["Vision_Product__r"]["Family"])+columnDivider+columnDivider+columnDivider
                +columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M7TotalAct)+columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M7TotalAvg).toFixed(0)+columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M7TotalAct)/((familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M7TotalAvg)*100).toFixed(0)
                +columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M6TotalAct)+columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M6TotalAvg).toFixed(0)+columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M6TotalAct)/((familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M6TotalAvg)*100).toFixed(0)
                +columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M5TotalAct)+columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M5TotalAvg).toFixed(0)+columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M5TotalAct)/((familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M5TotalAvg)*100).toFixed(0)
                +columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M4TotalAct)+columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M4TotalAvg).toFixed(0)+columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M4TotalAct)/((familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M4TotalAvg)*100).toFixed(0)
                +columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M3TotalAct)+columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M3TotalAvg).toFixed(0)+columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M3TotalAct)/((familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M3TotalAvg)*100).toFixed(0)
                +columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M2TotalAct)+columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M2TotalAvg).toFixed(0)+columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M2TotalAct)/((familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M2TotalAvg)*100).toFixed(0)
                +lineDivider;
                }
                 if(component.get("v.isIndirect")){
                csvStringResult += JSON.stringify(objectRecords[i]["Vision_Product__r"]["Family"])+columnDivider+columnDivider+columnDivider
                +columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M7InDirectAct)+columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M7InDirectAvg).toFixed(0)+columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M7InDirectAct)/((familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M7InDirectAvg)*100).toFixed(0)
                +columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M6InDirectAct)+columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M6InDirectAvg).toFixed(0)+columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M6InDirectAct)/((familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M6InDirectAvg)*100).toFixed(0)
                +columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M5InDirectAct)+columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M5InDirectAvg).toFixed(0)+columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M5InDirectAct)/((familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M5InDirectAvg)*100).toFixed(0)
                +columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M4InDirectAct)+columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M4InDirectAvg).toFixed(0)+columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M4InDirectAct)/((familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M4InDirectAvg)*100).toFixed(0)
                +columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M3InDirectAct)+columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M3InDirectAvg).toFixed(0)+columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M3InDirectAct)/((familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M3InDirectAvg)*100).toFixed(0)
                +columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M2InDirectAct)+columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M2InDirectAvg).toFixed(0)+columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M2InDirectAct)/((familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M2InDirectAvg)*100).toFixed(0)
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
    convertArrayOfObjectsToCSVEx : function(component,objectRecords,familyTotalsMap){
        // declare variables
        var csvStringResult, counter, keys,columnDivider, lineDivider,linesResult;
        
        // check if "objectRecords" parameter is null, then return from function
        if (objectRecords == null || !objectRecords.length) {
            return null;
        }
        // store ,[comma] in columnDivider variabel for sparate CSV values and 
        // for start next line use '\n' [new line] in lineDivider varaible  
        columnDivider = ',';
        lineDivider =  '\n';
        
        // in the keys valirable store fields API Names as a key 
        // this labels use in CSV file header 
         csvStringResult = '';
         linesResult = '';
         csvStringResult += "SKU's"+columnDivider+"SKU's"+columnDivider+"SKU's"+columnDivider+'Awarded Information'+columnDivider+'Awarded Information';//+columnDivider+component.get("v.Month6")+columnDivider+component.get("v.Month6")+columnDivider+component.get("v.Month5")+columnDivider+ component.get("v.Month5")+columnDivider+component.get("v.Month4")+columnDivider+component.get("v.Month4")+columnDivider+component.get("v.Month3")+columnDivider+component.get("v.Month3")+columnDivider+component.get("v.Month2")+columnDivider+component.get("v.Month2")+columnDivider+component.get("v.Month1")+columnDivider+component.get("v.Month1");  
         csvStringResult += lineDivider;
         var myMap = new Map();
         myMap.set("Item Description", "Vision_Product__r.Name");
         myMap.set("NDC", "Vision_Product__r.Phoenix_NDC_11__c");
         myMap.set("Pkg Size", "Vision_Product__r.Phoenix_Pkg_Size__c");
         if(component.get("v.isTotal")== true){
        
         myMap.set("Act"+'-'+component.get("v.Month6"), "M7_Total_Quantity__c");  
         myMap.set("Avg"+'-'+component.get("v.Month6"), "M7_Total_Avg_Quantity__c"); 
         myMap.set("C%"+'-'+component.get("v.Month6"), "M7_Total_Avg_Qty_Compliance__c");
             
              myMap.set("Act"+'-'+component.get("v.Month5"), "M6_Total_Quantity__c");  
         myMap.set("Avg"+'-'+component.get("v.Month5"), "M6_Total_Avg_Quantity__c"); 
         myMap.set("C%"+'-'+component.get("v.Month5"), "M6_Total_Avg_Qty_Compliance__c");
         
             
          myMap.set("Act"+'-'+component.get("v.Month4"), "M5_Total_Quantity__c");  
         myMap.set("Avg"+'-'+component.get("v.Month4"), "M5_Total_Avg_Quantity__c"); 
         myMap.set("C%"+'-'+component.get("v.Month4"), "M5_Total_Avg_Qty_Compliance__c");
         
          myMap.set("Act"+'-'+component.get("v.Month3"), "M4_Total_Quantity__c");  
         myMap.set("Avg"+'-'+component.get("v.Month3"), "M4_Total_Avg_Quantity__c"); 
         myMap.set("C%"+'-'+component.get("v.Month3"), "M4_Total_Avg_Qty_Compliance__c");
             
          myMap.set("Act"+'-'+component.get("v.Month2"), "M3_Total_Quantity__c");  
         myMap.set("Avg"+'-'+component.get("v.Month2"), "M3_Total_Avg_Quantity__c"); 
         myMap.set("C%"+'-'+component.get("v.Month2"), "M3_Total_Avg_Qty_Compliance__c");
             
          myMap.set("Act"+'-'+component.get("v.Month1"), "M2_Total_Quantity__c");  
         myMap.set("Avg"+'-'+component.get("v.Month1"), "M2_Total_Avg_Quantity__c"); 
         myMap.set("C%"+'-'+component.get("v.Month1"), "M2_Total_Avg_Qty_Compliance__c");
         
         
         
   
         }
         if(component.get("v.isDirect")== true){
         
         myMap.set("Act"+'-'+component.get("v.Month6"), "M7_Quantity__c");  
         myMap.set("Avg"+'-'+component.get("v.Month6"), "M7_Direct_Avg_Quantity__c"); 
         myMap.set("C%"+'-'+component.get("v.Month6"), "M7_Direct_Avg_Qty_Compliance__c");
             
         myMap.set("Act"+'-'+component.get("v.Month5"), "M6_Quantity__c");  
         myMap.set("Avg"+'-'+component.get("v.Month5"), "M6_Direct_Avg_Quantity__c"); 
         myMap.set("C%"+'-'+component.get("v.Month5"), "M6_Direct_Avg_Qty_Compliance__c");
             
         myMap.set("Act"+'-'+component.get("v.Month4"), "M5_Quantity__c");  
         myMap.set("Avg"+'-'+component.get("v.Month4"), "M5_Direct_Avg_Quantity__c"); 
         myMap.set("C%"+'-'+component.get("v.Month4"), "M5_Direct_Avg_Qty_Compliance__c");
             
         myMap.set("Act"+'-'+component.get("v.Month3"), "M4_Quantity__c");  
         myMap.set("Avg"+'-'+component.get("v.Month3"), "M4_Direct_Avg_Quantity__c"); 
         myMap.set("C%"+'-'+component.get("v.Month3"), "M4_Direct_Avg_Qty_Compliance__c");
             
         myMap.set("Act"+'-'+component.get("v.Month2"), "M3_Quantity__c");  
         myMap.set("Avg"+'-'+component.get("v.Month2"), "M3_Direct_Avg_Quantity__c"); 
         myMap.set("C%"+'-'+component.get("v.Month2"), "M3_Direct_Avg_Qty_Compliance__c");
             
         myMap.set("Act"+'-'+component.get("v.Month1"), "M2_Quantity__c");  
         myMap.set("Avg"+'-'+component.get("v.Month1"), "M2_Direct_Avg_Quantity__c"); 
         myMap.set("C%"+'-'+component.get("v.Month1"), "M2_Direct_Avg_Qty_Compliance__c");
        
             
             
         }
          if(component.get("v.isIndirect")== true){
         myMap.set("Act"+'-'+component.get("v.Month6"), "M7_Indirect_Quantity__c");  
         myMap.set("Avg"+'-'+component.get("v.Month6"), "M7_Indirect_Avg_Quantity__c"); 
         myMap.set("C%"+'-'+component.get("v.Month6"), "M7_Indirect_Avg_Qty_Compliance__c");
              
         myMap.set("Act"+'-'+component.get("v.Month5"), "M6_Indirect_Quantity__c");  
         myMap.set("Avg"+'-'+component.get("v.Month5"), "M6_Indirect_Avg_Quantity__c"); 
         myMap.set("C%"+'-'+component.get("v.Month5"), "M6_Indirect_Avg_Qty_Compliance__c");
              
              
         myMap.set("Act"+'-'+component.get("v.Month4"), "M5_Indirect_Quantity__c");  
         myMap.set("Avg"+'-'+component.get("v.Month4"), "M5_Indirect_Avg_Quantity__c"); 
         myMap.set("C%"+'-'+component.get("v.Month4"), "M5_Indirect_Avg_Qty_Compliance__c");
              
         myMap.set("Act"+'-'+component.get("v.Month3"), "M4_Indirect_Quantity__c");  
         myMap.set("Avg"+'-'+component.get("v.Month3"), "M4_Indirect_Avg_Quantity__c"); 
         myMap.set("C%"+'-'+component.get("v.Month3"), "M4_Indirect_Avg_Qty_Compliance__c");
              
         myMap.set("Act"+'-'+component.get("v.Month2"), "M3_Indirect_Quantity__c");  
         myMap.set("Avg"+'-'+component.get("v.Month2"), "M3_Indirect_Avg_Quantity__c"); 
         myMap.set("C%"+'-'+component.get("v.Month2"), "M3_Indirect_Avg_Qty_Compliance__c");
              
         myMap.set("Act"+'-'+component.get("v.Month1"), "M2_Indirect_Quantity__c");  
         myMap.set("Avg"+'-'+component.get("v.Month1"), "M2_Indirect_Avg_Quantity__c"); 
         myMap.set("C%"+'-'+component.get("v.Month1"), "M2_Indirect_Avg_Qty_Compliance__c");
              
              
              
              
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
                    csvStringResult += JSON.stringify(objectRecords[i]["Vision_Product__r"]["Family"])+columnDivider+columnDivider+
                        +columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M7DirectAct)+columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M7DirectAvg)+columnDivider+((familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M7DirectAct)/(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M7DirectAvg)*100).toFixed(0)
                    +columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M6DirectAct)+columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M6DirectAvg)+columnDivider+((familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M6DirectAct)/(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M6DirectAvg)*100).toFixed(0)
                    +columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M5DirectAct)+columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M5DirectAvg)+columnDivider+((familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M5DirectAct)/(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M5DirectAvg)*100).toFixed(0)
                    +columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M4DirectAct)+columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M4DirectAvg)+columnDivider+((familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M4DirectAct)/(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M4DirectAvg)*100).toFixed(0)
                    +columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M3DirectAct)+columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M3DirectAvg)+columnDivider+((familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M3DirectAct)/(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M3DirectAvg)*100).toFixed(0)
                    +columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M2DirectAct)+columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M2DirectAvg)+columnDivider+((familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M2DirectAct)/(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M2DirectAvg)*100).toFixed(0)
                    +lineDivider;
                }
                 if(component.get("v.isTotal")){
                 csvStringResult += JSON.stringify(objectRecords[i]["Vision_Product__r"]["Family"])+columnDivider+columnDivider+
                        +columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M7TotalAct)+columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M7TotalAvg)+columnDivider+((familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M7TotalAct)/(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M7TotalAvg)*100).toFixed(0)
                +lineDivider;
                }
                 if(component.get("v.isIndirect")){
                csvStringResult += JSON.stringify(objectRecords[i]["Vision_Product__r"]["Family"])+columnDivider+columnDivider+columnDivider+columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].IndirectAwardedQuantity)
                 +columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].QTDIndirectAwardedQty)+columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].QTDIndirectAct)+columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].QTDIndirectAct)/(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].QTDIndirectAwardedQty)*100
                +columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].FTDIndirectAwardedQty)+columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].FTDIndirectAct)+columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].FTDIndirectAct)/(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].FTDIndirectAwardedQty)*100
                +columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].CTDIndirectAwardedQty)+columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].CTDIndirectAct)+columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].CTDIndirectAct)/(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].CTDIndirectAwardedQty)*100
                +columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].IndirectAwardedQtyMonthly)
                +columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M7InDirectAct)+columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M7InDirectAct)/(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].IndirectAwardedQtyMonthly)*100
                +columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M6InDirectAct)+columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M6InDirectAct)/(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].IndirectAwardedQtyMonthly)*100
                +columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M5InDirectAct)+columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M5InDirectAct)/(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].IndirectAwardedQtyMonthly)*100
                +columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M4InDirectAct)+columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M4InDirectAct)/(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].IndirectAwardedQtyMonthly)*100
                +columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M3InDirectAct)+columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M3InDirectAct)/(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].IndirectAwardedQtyMonthly)*100
                +columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M2InDirectAct)+columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M2InDirectAct)/(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].IndirectAwardedQtyMonthly)*100
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