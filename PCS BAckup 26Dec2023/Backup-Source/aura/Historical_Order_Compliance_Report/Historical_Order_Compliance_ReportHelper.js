({
    getData: function(component, event, responseWrapper) {
               component.set("v.noOfRecords",responseWrapper.noOfRecords);
                     component.set("v.isProcessed",responseWrapper.isProcessed);
                component.set("v.orderComplianceList",responseWrapper.ProductFamilyWrapperList);
                console.log('orderComplianceList-->'+JSON.stringify(responseWrapper.ProductFamilyWrapperList));
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
        // var currentDir = component.get("v.isAsc");
        // component.set("v.isAsc",!currentDir);
        console.log('sortHelper');
        this.onSortResult(component, event, sortFieldName);
    },
    
    onSortResult: function(component, event, sortField) {
        console.log('onSortResult');
        var orderComplianceList = component.get("v.orderComplianceList");
        
        var currentDir = component.get("v.isAsc");
        component.set("v.isAsc",!currentDir);
        console.log('sort console---'+!currentDir);
        var records = component.get("v.orderComplianceList");
        
        var key = function(a) { 
            console.log('a[name]===>'+a["prodFamName"])
            return a["prodFamName"];
            
        }
        var reverse = currentDir ? 1: -1;
        orderComplianceList.sort(function(a,b){
            var a = key(a) ? key(a) : '';
            var b = key(b) ? key(b) : '';
            return reverse * ((a>b) - (b>a));
        });
        component.set("v.orderComplianceList", orderComplianceList);
        
        component.set("v.loaded",false);
        
        
        
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
         myMap.set("Act"+'-'+component.get("v.Month6"), "M7_Quantity__c");  
         myMap.set("Avg"+'-'+component.get("v.Month6"), "M7_Avg_Quantity__c"); 
         myMap.set("C%"+'-'+component.get("v.Month6"), "M7_Avg_Compliance__c");
             
         myMap.set("Act"+'-'+component.get("v.Month5"), "M6_Quantity__c");  
         myMap.set("Avg"+'-'+component.get("v.Month5"), "M6_Avg_Quantity__c"); 
         myMap.set("C%"+'-'+component.get("v.Month5"), "M6_Avg_Compliance__c");
             
         myMap.set("Act"+'-'+component.get("v.Month4"), "M5_Quantity__c");  
         myMap.set("Avg"+'-'+component.get("v.Month4"), "M5_Avg_Quantity__c"); 
         myMap.set("C%"+'-'+component.get("v.Month4"), "M5_Avg_Compliance__c");
             
         myMap.set("Act"+'-'+component.get("v.Month3"), "M4_Quantity__c");  
         myMap.set("Avg"+'-'+component.get("v.Month3"), "M4_Avg_Quantity__c"); 
         myMap.set("C%"+'-'+component.get("v.Month3"), "M4_Avg_Compliance__c");
             
         myMap.set("Act"+'-'+component.get("v.Month2"), "M3_Quantity__c");  
         myMap.set("Avg"+'-'+component.get("v.Month2"), "M3_Avg_Quantity__c"); 
         myMap.set("C%"+'-'+component.get("v.Month2"), "M3_Avg_Compliance__c");
             
         myMap.set("Act"+'-'+component.get("v.Month1"), "M2_Quantity__c");  
         myMap.set("Avg"+'-'+component.get("v.Month1"), "M2_Avg_Quantity__c"); 
         myMap.set("C%"+'-'+component.get("v.Month1"), "M2_Avg_Compliance__c");
        
             
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
                csvStringResult += JSON.stringify(objectRecords[i]["Vision_Product__r"]["Family"])+columnDivider+columnDivider+columnDivider
                +columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M7DirectAct)+columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M7DirectAvg).toFixed(0)+columnDivider+((familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M7DirectAct)/(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M7DirectAvg)*100).toFixed(0)
                +columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M6DirectAct)+columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M6DirectAvg).toFixed(0)+columnDivider+((familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M6DirectAct)/(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M6DirectAvg)*100).toFixed(0)
                +columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M5DirectAct)+columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M5DirectAvg).toFixed(0)+columnDivider+((familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M5DirectAct)/(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M5DirectAvg)*100).toFixed(0)
                +columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M4DirectAct)+columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M4DirectAvg).toFixed(0)+columnDivider+((familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M4DirectAct)/(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M4DirectAvg)*100).toFixed(0)
                +columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M3DirectAct)+columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M3DirectAvg.toFixed(0))+columnDivider+((familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M3DirectAct)/(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M3DirectAvg)*100).toFixed(0)
                +columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M2DirectAct)+columnDivider+(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M2DirectAvg).toFixed(0)+columnDivider+((familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M2DirectAct)/(familyTotalsMap[objectRecords[i]["Vision_Product__r"]["Family"]].M2DirectAvg)*100).toFixed(0)
                +lineDivider;
             
               
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