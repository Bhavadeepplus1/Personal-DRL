/**
 * @description       : 
 * @author            : Suseela (Dhruvsoft)
 * @group             : 
 * @last modified on  : 09-12-2020
 * @last modified by  : Suseela(Dhruvsoft)
 * Modifications Log 
 * Ver   Date         Author                       Modification
 * 1.0   25-11-2020   Suseela (Dhruvsoft)   Initial Version
**/
({
    convertArrayOfObjectsToCSVAllRec : function(component,rxPreviewList,objectRecords){
        // declare variables
        var selectedRec2 = component.get("v.columndata");
    
        var csvStringResult, counter, keys,columnDivider, lineDivider,linesResult;
        // check if "objectRecords" parameter is null, then return from function
        if (rxPreviewList == null || !rxPreviewList.length) {
            return null;
        }
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

        if(rxPreviewList.length > 0){
         var myMap = new Map();
         myMap.set("Generic Name", "Vision_Generic_Name__c");
               if(component.get("v.Vision_Segment__c") == true){
      	 myMap.set("Segment", "Vision_Segment__c");   
         }   
         if(component.get("v.Vision_Strength__c") == true){    
         myMap.set("Strength", "Vision_Strength__c");
         }
         if(component.get("v.Vision_Size__c") == true){
         myMap.set("Size", "Vision_Size__c");   
        }
        if(component.get("v.Vision_Dosage_Form__c") == true){
            myMap.set("Dosage Form", "Vision_Dosage_Form__c");  
        } 
        if(component.get("v.Vision_Reference_Brand__c") == true){
             myMap.set("Reference Brand", "Vision_Reference_Brand__c");
         }    
        if(component.get("v.Vision_Potential_Launch_date__c") == true){  
            myMap.set("Potential Launch Date*", "Vision_Potential_Launch_date__c");
         }
          if(component.get("v.Vision_Launch_Month__c") == true){  
            myMap.set("Potential Launch Month", "Vision_Launch_Month__c");
         }
          if(component.get("v.GCP_Launch_Year__c") == true){  
            myMap.set("Potential Launch Year", "GCP_Launch_Year__c");
         }
        if(component.get("v.Vision_Launch_Type__c") == true){
         myMap.set("Launch Type", "Vision_Launch_Type__c");  
        }      
        if(component.get("v.Vision_Api_Vertically_Integrated__c") == true){
         myMap.set("API VI", "Vision_Api_Vertically_Integrated__c");   
        }
        if(component.get("v.Vision_Authorized_Generic__c") == true){
         myMap.set("Authorized Generics", "Vision_Authorized_Generic__c");   
        }
        if(component.get("v.Vision_Unit_Dose__c") == true){
         myMap.set("Unit Dose", "Vision_Unit_Dose__c");   
        }
        if(component.get("v.Vision_Anda_Filed__c") == true){
         myMap.set("Anda Filed", "Vision_Anda_Filed__c");   
        }     
        if(component.get("v.Vision_GPI__c") == true){
         myMap.set("GPI", "Vision_GPI__c");   
        }
        if(component.get("v.Vision_GCN__c") == true){
         myMap.set("GCN", "Vision_GCN__c");   
        }
        if(component.get("v.Vision_Comments__c") == true){
         myMap.set("Additional Comments", "Vision_Comments__c");   
        }
        }
        
         csvStringResult += Array.from(myMap.keys()).join(columnDivider);
         csvStringResult += lineDivider;
        //new logic start 
        for(var i=0; i < rxPreviewList.length; i++){  
            counter = 0;
            for (let [key, value] of myMap) {
                if(counter > 0){ 
                    csvStringResult += columnDivider; 
                }
                console.log('testing result--->'+JSON.stringify(rxPreviewList[i]));
                	if(rxPreviewList[i][value]==undefined){
                        //console.log('Iam in last ELSEE if---->');
                       	csvStringResult += '"'+''+'"';
                    	}   
                      else{
                          csvStringResult += '"'+ rxPreviewList[i][value]+'"'; 
                      }
                  counter++;
            }
            csvStringResult += lineDivider;
        }
          var myMap1 = new Map();
         myMap1.set("therapeutic Area", "Vision_Therapeutic_Area__c"); 
         myMap1.set("Generic Name", "Vision_Generic_Name__c");
               if(component.get("v.Vision_Segment__c") == true){
      	 myMap1.set("Segment", "Vision_Segment__c");   
         }   
         if(component.get("v.Vision_Strength__c") == true){    
         myMap1.set("Strength", "Vision_Strength__c");
         }
         if(component.get("v.Vision_Size__c") == true){
         myMap1.set("Size", "Vision_Size__c");   
        }
        if(component.get("v.Vision_Dosage_Form__c") == true){
            myMap1.set("Dosage Form", "Vision_Dosage_Form__c");  
        } 
        if(component.get("v.Vision_Reference_Brand__c") == true){
             myMap1.set("Reference Brand", "Vision_Reference_Brand__c");
         }    
         if(component.get("v.Vision_Launch_Month__c") == true){  
            myMap1.set("Potential Launch Date*", "Vision_Potential_Launch_date__c");
         }
        if(component.get("v.Vision_Launch_Type__c") == true){
myMap1.set("Launch Type", "Vision_Launch_Type__c");  
        }      
        if(component.get("v.Vision_Api_Vertically_Integrated__c") == true){
         myMap1.set("API VI", "Vision_Api_Vertically_Integrated__c");   
        }
        if(component.get("v.Vision_Authorized_Generic__c") == true){
         myMap1.set("Authorized Generics", "Vision_Authorized_Generic__c");   
        }
        if(component.get("v.Vision_Unit_Dose__c") == true){
         myMap1.set("Unit Dose", "Vision_Unit_Dose__c");   
        }
        if(component.get("v.Vision_Anda_Filed__c") == true){
         myMap1.set("Anda Filed", "Vision_Anda_Filed__c");   
        }     
        if(component.get("v.Vision_GPI__c") == true){
         myMap1.set("GPI", "Vision_GPI__c");   
        }
        if(component.get("v.Vision_GCN__c") == true){
         myMap1.set("GCN", "Vision_GCN__c");   
        }
        if(component.get("v.Vision_Comments__c") == true){
         myMap1.set("Additional Comments", "Vision_Comments__c");   
        }        

         csvStringResult += Array.from(myMap.keys()).join(columnDivider);
         csvStringResult += lineDivider;
        //new logic start 
      for(var i=0; i < objectRecords.length; i++){  
            counter = 0;
          if(JSON.stringify(objectRecords[i]["Vision_Therapeutic_Area__c"]) != linesResult)
            {
                console.log('Inside if objectRecords '+i+''+JSON.stringify(objectRecords[i].Vision_Therapeutic_Area__c));
                console.log('before lines result is '+linesResult+'The length is '+linesResult.length);
                console.log(linesResult);
                csvStringResult += JSON.stringify(objectRecords[i]["Vision_Therapeutic_Area__c"])+columnDivider+columnDivider+columnDivider+columnDivider+columnDivider+columnDivider+columnDivider+columnDivider+columnDivider+columnDivider+columnDivider+columnDivider+columnDivider+columnDivider+columnDivider+columnDivider+lineDivider;
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
                if (value == 'Vision_Therapeutic_Area__c') {
                    // csvStringResult += '"' + objectRecords[i]["Phoenix_Product__r"]["Family"] + '"';
                    csvStringResult += '"' + '' + '"';
                    linesResult=null;
                    linesResult='';
                    linesResult += '"' + objectRecords[i]["Vision_Therapeutic_Area__c"] + '"';
                    console.log('Iniside if the lines result is '+linesResult);
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
     convertArrayOfObjectsToCSVAll : function(component,objectRecords){
        // declare variables
        var selectedRec2 = component.get("v.columndata");
    
        var csvStringResult, counter, keys,columnDivider, lineDivider;
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
         var myMap = new Map();
         //myMap.set("Brand", "Vision_Reference_Brand__c");
         myMap.set("Therapeutic Area", "Vision_Therapeutic_Area__c"); 
         myMap.set("Generic Name", "Vision_Generic_Name__c");
      //   if(component.get("v.selectAll")){
               if(component.get("v.Vision_Segment__c") == true){
      	 myMap.set("Segment", "Vision_Segment__c");   
         }   
         if(component.get("v.Vision_Strength__c") == true){    
         myMap.set("Strength", "Vision_Strength__c");
         }
         if(component.get("v.Vision_Size__c") == true){
         myMap.set("Size", "Vision_Size__c");   
        }
        if(component.get("v.Vision_Dosage_Form__c") == true){
            myMap.set("Dosage Form", "Vision_Dosage_Form__c");  
        } 
        if(component.get("v.Vision_Reference_Brand__c") == true){
             myMap.set("Reference Brand", "Vision_Reference_Brand__c");
         }    
         if(component.get("v.Vision_Potential_Launch_date__c") == true){  
            myMap.set("Potential Launch Date*", "Vision_Potential_Launch_date__c");
         }
          if(component.get("v.Vision_Launch_Month__c") == true){  
            myMap.set("Potential Launch Month", "Vision_Launch_Month__c");
         }
          if(component.get("v.GCP_Launch_Year__c") == true){  
            myMap.set("Potential Launch Year", "GCP_Launch_Year__c");
         }
        if(component.get("v.Vision_Launch_Type__c") == true){
         myMap.set("Launch Type", "Vision_Launch_Type__c");  
        }      
        if(component.get("v.Vision_Api_Vertically_Integrated__c") == true){
         myMap.set("API VI", "Vision_Api_Vertically_Integrated__c");   
        }
        if(component.get("v.Vision_Authorized_Generic__c") == true){
         myMap.set("Authorized Generics", "Vision_Authorized_Generic__c");   
        }
        if(component.get("v.Vision_Unit_Dose__c") == true){
         myMap.set("Unit Dose", "Vision_Unit_Dose__c");   
        }
        if(component.get("v.Vision_Anda_Filed__c") == true){
         myMap.set("Anda Filed", "Vision_Anda_Filed__c");   
        }     
        if(component.get("v.Vision_GPI__c") == true){
         myMap.set("GPI", "Vision_GPI__c");   
        }
        if(component.get("v.Vision_GCN__c") == true){
         myMap.set("GCN", "Vision_GCN__c");   
        }
        if(component.get("v.Vision_Comments__c") == true){
         myMap.set("Additional Comments", "Vision_Comments__c");   
        }
         csvStringResult += Array.from(myMap.keys()).join(columnDivider);
         csvStringResult += lineDivider;
        //new logic start 
        for(var i=0; i < objectRecords.length; i++){  
            counter = 0;
            for (let [key, value] of myMap) {
                if(counter > 0){ 
                    csvStringResult += columnDivider; 
                }
                console.log('testing result--->'+JSON.stringify(objectRecords[i]));
                	if(objectRecords[i][value]==undefined){
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
     convertArrayOfObjectsToCSV : function(component,objectRecords){
        // declare variables
        var selectedRec2 = component.get("v.columndata");
        console.log('checked Rx>>  '+ component.get("v.columndata"));
    
        var csvStringResult, counter, keys,columnDivider, lineDivider;
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
         var myMap = new Map();
         //myMap.set("Brand", "Vision_Reference_Brand__c");
         myMap.set("Generic Name", "Vision_Generic_Name__c");
      //   if(component.get("v.selectAll")){
               if(component.get("v.Vision_Segment__c") == true){
      	 myMap.set("Segment", "Vision_Segment__c");   
         }   
         if(component.get("v.Vision_Strength__c") == true){    
         myMap.set("Strength", "Vision_Strength__c");
         }
         if(component.get("v.Vision_Size__c") == true){
         myMap.set("Size", "Vision_Size__c");   
        }
        if(component.get("v.Vision_Dosage_Form__c") == true){
            myMap.set("Dosage Form", "Vision_Dosage_Form__c");  
        } 
        if(component.get("v.Vision_Reference_Brand__c") == true){
             myMap.set("Reference Brand", "Vision_Reference_Brand__c");
         }    
       if(component.get("v.Vision_Potential_Launch_date__c") == true){  
            myMap.set("Potential Launch Date*", "Vision_Potential_Launch_date__c");
         }
          if(component.get("v.Vision_Launch_Month__c") == true){  
            myMap.set("Potential Launch Month", "Vision_Launch_Month__c");
         }
          if(component.get("v.GCP_Launch_Year__c") == true){  
            myMap.set("Potential Launch Year", "GCP_Launch_Year__c");
         }
        if(component.get("v.Vision_Launch_Type__c") == true){
         myMap.set("Launch Type", "Vision_Launch_Type__c");  
        }      
        if(component.get("v.Vision_Api_Vertically_Integrated__c") == true){
         myMap.set("API VI", "Vision_Api_Vertically_Integrated__c");   
        }
        if(component.get("v.Vision_Authorized_Generic__c") == true){
         myMap.set("Authorized Generics", "Vision_Authorized_Generic__c");   
        }
        if(component.get("v.Vision_Unit_Dose__c") == true){
         myMap.set("Unit Dose", "Vision_Unit_Dose__c");   
        }
        if(component.get("v.Vision_Anda_Filed__c") == true){
         myMap.set("Anda Filed", "Vision_Anda_Filed__c");   
        }     
        if(component.get("v.Vision_GPI__c") == true){
         myMap.set("GPI", "Vision_GPI__c");   
        }
        if(component.get("v.Vision_GCN__c") == true){
         myMap.set("GCN", "Vision_GCN__c");   
        }
        if(component.get("v.Vision_Comments__c") == true){
         myMap.set("Additional Comments", "Vision_Comments__c");   
        }        
        // }
         //myMap.set("Potential Launch Date*", "Vision_Launch_Month__c");
         //myMap.set("Type", "Vision_Launch_Type__c");
         //myMap.set("Additional Comments", "Vision_Comments__c");
     /*    for (var i = 0; i < selectedRec2.length; i++ ){   
         if(selectedRec2[i] == 'Segment'){
         myMap.set("Segment", "Vision_Segment__c");   
         }   
         if(selectedRec2[i] == 'Strength'){    
         myMap.set("Strength", "Vision_Strength__c");
         }
         if(selectedRec2[i] == 'Size'){
         myMap.set("Size", "Vision_Size__c");   
        }
        if(selectedRec2[i] == 'Dosage Form'){
            myMap.set("Dosage Form", "Vision_Dosage_Form__c");  
        } 
        if(selectedRec2[i] == 'Reference Brand'){
             myMap.set("Brand", "Vision_Reference_Brand__c");
         }    
         if(selectedRec2[i] == 'Launch Month'){  
            myMap.set("Potential Launch Date*", "Vision_Launch_Month__c");
         }
        if(selectedRec2[i] == 'Launch Type'){
         myMap.set("Launch Type", "Vision_Launch_Type__c");  
        }      
        if(selectedRec2[i] == 'API VI'){
         myMap.set("API VI", "Vision_Api_Vertically_Integrated__c");   
        }
        if(selectedRec2[i] == 'Authorized Generic'){
         myMap.set("Authorized Generic", "Vision_Authorized_Generic__c");   
        }
        if(selectedRec2[i] == 'Unit Dose'){
         myMap.set("Unit Dose", "Vision_Unit_Dose__c");   
        }
        if(selectedRec2[i] == 'Anda Filed'){
         myMap.set("Anda Filed", "Vision_Anda_Filed__c");   
        }     
        if(selectedRec2[i] == 'GPI'){
         myMap.set("GPI", "Vision_GPI__c");   
        }
        if(selectedRec2[i] == 'GCN'){
         myMap.set("GCN", "Vision_GCN__c");   
        }
        if(selectedRec2[i] == 'Comments'){
         myMap.set("Additional Comments", "Vision_Comments__c");   
        }        
       } */   
         csvStringResult += Array.from(myMap.keys()).join(columnDivider);
         csvStringResult += lineDivider;
        //new logic start 
        for(var i=0; i < objectRecords.length; i++){  
            counter = 0;
            for (let [key, value] of myMap) {
                if(counter > 0){ 
                    csvStringResult += columnDivider; 
                }
                console.log('testing result--->'+JSON.stringify(objectRecords[i]));
                	if(objectRecords[i][value]==undefined){
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
     convertArrayOfObjectsToCSVSRX : function(component,objectRecords){
        // declare variables
        console.log('seg bool export srx=====',component.get("v.Vision_Segment__c"));

        var selectedRec2 = component.get("v.columndata");
        console.log('checked SRX>>  '+ component.get("v.columndata"));
        var csvStringResult, counter, keys,columnDivider, lineDivider;
        
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
         
         var myMap = new Map();
         //myMap.set("Brand", "Vision_Reference_Brand__c");
         myMap.set("Generic Name", "Vision_Generic_Name__c");
       //  if(component.get("v.selectAll")){
               if(component.get("v.Vision_Segment__c") == true){
      	 myMap.set("Segment", "Vision_Segment__c");   
         }   
         if(component.get("v.Vision_Strength__c") == true){    
         myMap.set("Strength", "Vision_Strength__c");
         }
         if(component.get("v.Vision_Size__c") == true){
         myMap.set("Size", "Vision_Size__c");   
        }
        if(component.get("v.Vision_Dosage_Form__c") == true){
            myMap.set("Dosage Form", "Vision_Dosage_Form__c");  
        } 
        if(component.get("v.Vision_Reference_Brand__c") == true){
             myMap.set("Reference Brand", "Vision_Reference_Brand__c");
         }    
        if(component.get("v.Vision_Potential_Launch_date__c") == true){  
            myMap.set("Potential Launch Date*", "Vision_Potential_Launch_date__c");
         }
          if(component.get("v.Vision_Launch_Month__c") == true){  
            myMap.set("Potential Launch Month", "Vision_Launch_Month__c");
         }
          if(component.get("v.GCP_Launch_Year__c") == true){  
            myMap.set("Potential Launch Year", "GCP_Launch_Year__c");
         }
        if(component.get("v.Vision_Launch_Type__c") == true){
         myMap.set("Launch Type", "Vision_Launch_Type__c");  
        }      
        if(component.get("v.Vision_Api_Vertically_Integrated__c") == true){
         myMap.set("API VI", "Vision_Api_Vertically_Integrated__c");   
        }
        if(component.get("v.Vision_Authorized_Generic__c") == true){
         myMap.set("Authorized Generics", "Vision_Authorized_Generic__c");   
        }
        if(component.get("v.Vision_Unit_Dose__c") == true){
         myMap.set("Unit Dose", "Vision_Unit_Dose__c");   
        }
        if(component.get("v.Vision_Anda_Filed__c") == true){
         myMap.set("Anda Filed", "Vision_Anda_Filed__c");   
        }     
        if(component.get("v.Vision_GPI__c") == true){
         myMap.set("GPI", "Vision_GPI__c");   
        }
        if(component.get("v.Vision_GCN__c") == true){
         myMap.set("GCN", "Vision_GCN__c");   
        }
        if(component.get("v.Vision_Comments__c") == true){
         myMap.set("Additional Comments", "Vision_Comments__c");   
        }        
      //   }
         //myMap.set("Potential Launch Date*", "Vision_Launch_Month__c");
         //myMap.set("Type", "Vision_Launch_Type__c");
        /* for (var i = 0; i < selectedRec2.length; i++ ){   
         if(selectedRec2[i] == 'Segment'){
         myMap.set("Segment", "Vision_Segment__c");   
         }   
         if(selectedRec2[i] == 'Strength'){    
         myMap.set("Strength", "Vision_Strength__c");
         }
         if(selectedRec2[i] == 'Size'){
         myMap.set("Size", "Vision_Size__c");   
        }
        if(selectedRec2[i] == 'Dosage Form'){
            myMap.set("Dosage Form", "Vision_Dosage_Form__c");  
        } 
        if(selectedRec2[i] == 'Reference Brand'){
             myMap.set("Brand", "Vision_Reference_Brand__c");
         }    
         if(selectedRec2[i] == 'Launch Month'){  
            myMap.set("Potential Launch Date*", "Vision_Launch_Month__c");
         }
        if(selectedRec2[i] == 'Launch Type'){
         myMap.set("Launch Type", "Vision_Launch_Type__c");  
        }      
        if(selectedRec2[i] == 'API VI'){
         myMap.set("API VI", "Vision_Api_Vertically_Integrated__c");   
        }
        if(selectedRec2[i] == 'Authorized Generic'){
         myMap.set("Approved Generic", "Vision_Authorized_Generic__c");   
        }
        if(selectedRec2[i] == 'Unit Dose'){
         myMap.set("Unit Dose", "Vision_Unit_Dose__c");   
        }
        if(selectedRec2[i] == 'Anda Filed'){
         myMap.set("Anda Filed", "Vision_Anda_Filed__c");   
        }     
        if(selectedRec2[i] == 'GPI'){
         myMap.set("GPI", "Vision_GPI__c");   
        }
        if(selectedRec2[i] == 'GCN'){
         myMap.set("GCN", "Vision_GCN__c");   
        }
        if(selectedRec2[i] == 'Comments'){
         myMap.set("Additional Comments", "Vision_Comments__c");   
        }        
       }    */
         csvStringResult += Array.from(myMap.keys()).join(columnDivider);
         csvStringResult += lineDivider;
        //new logic start 
        for(var i=0; i < objectRecords.length; i++){  
            counter = 0;
            for (let [key, value] of myMap) {
                if(counter > 0){ 
                    csvStringResult += columnDivider; 
                }
                console.log('testing result--->'+JSON.stringify(objectRecords[i]));
                	if(objectRecords[i][value]==undefined){
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
    convertArrayOfObjectsToCSVOTC : function(component,objectRecords){
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
         myMap.set("Therapeutic Area", "Vision_Therapeutic_Area__c"); 
         myMap.set("Generic Name", "Vision_Generic_Name__c");
               if(component.get("v.Vision_Segment__c") == true){
      	 myMap.set("Segment", "Vision_Segment__c");   
         }   
         if(component.get("v.Vision_Strength__c") == true){    
         myMap.set("Strength", "Vision_Strength__c");
         }
         if(component.get("v.Vision_Size__c") == true){
         myMap.set("Size", "Vision_Size__c");   
        }
        if(component.get("v.Vision_Dosage_Form__c") == true){
            myMap.set("Dosage Form", "Vision_Dosage_Form__c");  
        } 
        if(component.get("v.Vision_Reference_Brand__c") == true){
             myMap.set("Reference Brand", "Vision_Reference_Brand__c");
         }    
         if(component.get("v.Vision_Launch_Month__c") == true){  
            myMap.set("Potential Launch Date*", "Vision_Launch_Month__c");
         }
        if(component.get("v.Vision_Launch_Type__c") == true){
         myMap.set("Launch Type", "Vision_Launch_Type__c");  
        }      
        if(component.get("v.Vision_Api_Vertically_Integrated__c") == true){
         myMap.set("API VI", "Vision_Api_Vertically_Integrated__c");   
        }
        if(component.get("v.Vision_Authorized_Generic__c") == true){
         myMap.set("Authorized Generics", "Vision_Authorized_Generic__c");   
        }
        if(component.get("v.Vision_Unit_Dose__c") == true){
         myMap.set("Unit Dose", "Vision_Unit_Dose__c");   
        }
        if(component.get("v.Vision_Anda_Filed__c") == true){
         myMap.set("Anda Filed", "Vision_Anda_Filed__c");   
        }     
        if(component.get("v.Vision_GPI__c") == true){
         myMap.set("GPI", "Vision_GPI__c");   
        }
        if(component.get("v.Vision_GCN__c") == true){
         myMap.set("GCN", "Vision_GCN__c");   
        }
        if(component.get("v.Vision_Comments__c") == true){
         myMap.set("Additional Comments", "Vision_Comments__c");   
        }        
   
         csvStringResult += Array.from(myMap.keys()).join(columnDivider);
         csvStringResult += lineDivider;
        //new logic start 
 /*     for(var i=0; i < objectRecords.length; i++){  
            counter = 0;
          if(JSON.stringify(objectRecords[i]["Vision_Therapeutic_Area__c"]) != linesResult)
            {
                console.log('Inside if objectRecords '+i+''+JSON.stringify(objectRecords[i].Vision_Therapeutic_Area__c));
                console.log('before lines result is '+linesResult+'The length is '+linesResult.length);
                console.log(linesResult);
                csvStringResult += JSON.stringify(objectRecords[i]["Vision_Therapeutic_Area__c"])+columnDivider+columnDivider+columnDivider+columnDivider+columnDivider+columnDivider+columnDivider+columnDivider+columnDivider+columnDivider+columnDivider+columnDivider+columnDivider+columnDivider+columnDivider+columnDivider+lineDivider;
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
                if (value == 'Vision_Therapeutic_Area__c') {
                    // csvStringResult += '"' + objectRecords[i]["Phoenix_Product__r"]["Family"] + '"';
                    csvStringResult += '"' + '' + '"';
                    linesResult=null;
                    linesResult='';
                    linesResult += '"' + objectRecords[i]["Vision_Therapeutic_Area__c"] + '"';
                    console.log('Iniside if the lines result is '+linesResult);
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
        }  */
             for(var i=0; i < objectRecords.length; i++){  
            counter = 0;
            for (let [key, value] of myMap) {
                if(counter > 0){ 
                    csvStringResult += columnDivider; 
                }
                console.log('testing result--->'+JSON.stringify(objectRecords[i]));
                	if(objectRecords[i][value]==undefined){
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
    convertArrayOfObjectsToCSVSpecialty : function(component,objectRecords){
        // declare variables
        var selectedRec2 = component.get("v.columndata");
        console.log('checked Speciality>>  '+ component.get("v.columndata"));
        var csvStringResult, counter, keys,columnDivider, lineDivider;
        
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
         
         var myMap = new Map();
         //myMap.set("Brand", "Vision_Reference_Brand__c");
         myMap.set("Generic Name", "Vision_Generic_Name__c");
       // if(component.get("v.selectAll")){
               if(component.get("v.Vision_Segment__c") == true){
      	 myMap.set("Segment", "Vision_Segment__c");   
         }   
         if(component.get("v.Vision_Strength__c") == true){    
         myMap.set("Strength", "Vision_Strength__c");
         }
         if(component.get("v.Vision_Size__c") == true){
         myMap.set("Size", "Vision_Size__c");   
        }
        if(component.get("v.Vision_Dosage_Form__c") == true){
            myMap.set("Dosage Form", "Vision_Dosage_Form__c");  
        } 
        if(component.get("v.Vision_Reference_Brand__c") == true){
             myMap.set("Reference Brand", "Vision_Reference_Brand__c");
         }    
         if(component.get("v.Vision_Launch_Month__c") == true){  
            myMap.set("Potential Launch Date*", "Vision_Launch_Month__c");
         }
        if(component.get("v.Vision_Launch_Type__c") == true){
         myMap.set("Launch Type", "Vision_Launch_Type__c");  
        }      
        if(component.get("v.Vision_Api_Vertically_Integrated__c") == true){
         myMap.set("API VI", "Vision_Api_Vertically_Integrated__c");   
        }
        if(component.get("v.Vision_Authorized_Generic__c") == true){
         myMap.set("Authorized Generics", "Vision_Authorized_Generic__c");   
        }
        if(component.get("v.Vision_Unit_Dose__c") == true){
         myMap.set("Unit Dose", "Vision_Unit_Dose__c");   
        }
        if(component.get("v.Vision_Anda_Filed__c") == true){
         myMap.set("Anda Filed", "Vision_Anda_Filed__c");   
        }     
        if(component.get("v.Vision_GPI__c") == true){
         myMap.set("GPI", "Vision_GPI__c");   
        }
        if(component.get("v.Vision_GCN__c") == true){
         myMap.set("GCN", "Vision_GCN__c");   
        }
        if(component.get("v.Vision_Comments__c") == true){
         myMap.set("Additional Comments", "Vision_Comments__c");   
        }        
      //   }
         //myMap.set("Potential Launch Date*", "Vision_Launch_Month__c");
         //myMap.set("Type", "Vision_Launch_Type__c");
        /*  for (var i = 0; i < selectedRec2.length; i++ ){   
         if(selectedRec2[i] == 'Segment'){
         myMap.set("Segment", "Vision_Segment__c");   
         }   
         if(selectedRec2[i] == 'Strength'){    
         myMap.set("Strength", "Vision_Strength__c");
         }
         if(selectedRec2[i] == 'Size'){
         myMap.set("Size", "Vision_Size__c");   
        }
        if(selectedRec2[i] == 'Dosage Form'){
            myMap.set("Dosage Form", "Vision_Dosage_Form__c");  
        } 
        if(selectedRec2[i] == 'Reference Brand'){
             myMap.set("Brand", "Vision_Reference_Brand__c");
         }    
         if(selectedRec2[i] == 'Launch Month'){  
            myMap.set("Potential Launch Date*", "Vision_Launch_Month__c");
         }
        if(selectedRec2[i] == 'Launch Type'){
         myMap.set("Launch Type", "Vision_Launch_Type__c");  
        }      
        if(selectedRec2[i] == 'API VI'){
         myMap.set("API VI", "Vision_Api_Vertically_Integrated__c");   
        }
        if(selectedRec2[i] == 'Authorized Generic'){
         myMap.set("Approved Generic", "Vision_Authorized_Generic__c");   
        }
        if(selectedRec2[i] == 'Unit Dose'){
         myMap.set("Unit Dose", "Vision_Unit_Dose__c");   
        }
        if(selectedRec2[i] == 'Anda Filed'){
         myMap.set("Anda Filed", "Vision_Anda_Filed__c");   
        }     
        if(selectedRec2[i] == 'GPI'){
         myMap.set("GPI", "Vision_GPI__c");   
        }
        if(selectedRec2[i] == 'GCN'){
         myMap.set("GCN", "Vision_GCN__c");   
        }
        if(selectedRec2[i] == 'Comments'){
         myMap.set("Additional Comments", "Vision_Comments__c");   
        }        
       }    */
         csvStringResult += Array.from(myMap.keys()).join(columnDivider);
         csvStringResult += lineDivider;
        //new logic start 
        for(var i=0; i < objectRecords.length; i++){  
            counter = 0;
            for (let [key, value] of myMap) {
                if(counter > 0){ 
                    csvStringResult += columnDivider; 
                }
                console.log('testing result--->'+JSON.stringify(objectRecords[i]));
                	if(objectRecords[i][value]==undefined){
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
    loadProducts: function (component, helper) {
       //let pageReference = component.get("v.pageReference");
       //let recordId = pageReference.state.c__recordId;
        //console.log('recordId =='+recordId);
        var recordId =component.get("v.recordId");
        if (recordId != null && recordId != undefined && recordId != '') {
            component.set("v.recordId", recordId);
        }
        console.log('load productss--->')
        var quotewrap = component.get("v.wrap");
        
        var searchText = component.get("v.searchText");
        
        var getProductsAction = component.get("c.getProductPipelines");
        getProductsAction.setCallback(this, function (response) {
            var actState = response.getState();
            console.log('loading products state-->'+actState)
            if (actState === 'SUCCESS') {
                
                var resposeData = response.getReturnValue();
                console.log("response data in loadProducts-->"+JSON.stringify(resposeData))
                console.log('loading inside products state-->'+resposeData.length)
                
                
                
                if(resposeData!=undefined && resposeData!='' && resposeData!=null ){
                    if (resposeData.length > 0) {
                        component.set("v.showProducts", true);
                    }
                    else {
                        component.set("v.noProducts", true);
                    }
                    console.log('showProducts in pagination-->'+component.get("v.showProducts"));
                    
                    component.set("v.Allproduct", resposeData);
                    component.set("v.allData", response.getReturnValue());
                    
                    component.set("v.totalRecordsCount", response.getReturnValue().length);
                    
                    if(component.get("v.totalRecordsCount")==0)
                        component.set("v.noProducts",true);
                    else{
                        component.set("v.noProducts",false); 
                    }
                    component.set("v.showSpinnerSelProds",false);
                  //  this.buildData(component, helper);
                    
                    
                    
                    
                }
            }
            else{
                console.log("Error "+JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(getProductsAction);
    },
    buildData: function (component, helper) {
        //window.scroll(0,0);
        var scrollOptions = {
            left: 0,
            top: 0,
            
            
            behavior: 'smooth'
        }
        window.scrollTo(scrollOptions);
        var data = [];
        let selectedProductsIds = component.get("v.selectedProductsIds");
        console.log("%c--------selectedProductsIds-------" + selectedProductsIds, "background-color:red;color:white;");
        var pageNumber = component.get("v.currentPageNumber");
        var pageSize = component.get("v.pageSize");
        var allData = component.get("v.allData");
        var x = 0;//(pageNumber - 1) * pageSize;
        var pData;
        var copyList=[];
        component.set("v.ProductCopyList",copyList);
        var productLength = component.get("v.ProductList").length;
        //creating data-table data
        for (; x < productLength; x++) {
            pData = allData[x];
            if (pData) {
                pData.isSelected = false;
                if (selectedProductsIds.includes(pData.Id)) {
                    
                    pData.isSelected = true;
                }
                data.push(pData);
            }
        }
        component.set("v.ProductList", data);
        
        
        if(data.length>0){
            var selectCount=0;
            for(var i=0;i<data.length;i++){
                if(data[i].isSelected==true){
                    selectCount++;
                }
            }
            
            if(selectCount==pageSize ||selectCount==i){
                component.set("v.selectAll",true);  
                
            }
            else{
                component.set("v.selectAll",false); 
            }
        }
    }, 
    searchTablehelper: function (component,helper) {
        var allRecords = component.get("v.Allproduct");
        var searchFilter = component.get("v.searchText");
        if ((searchFilter != null && searchFilter != undefined && searchFilter != '' )) {
            console.log('Inside Search Filter If');
            component.set("v.showSpinnerSelProds",true);
            var getProductsAction = component.get("c.getSearch");
            getProductsAction.setParams({ pItem: allRecords, search: searchFilter,RxSrxList:component.get("v.RxSrxList")});  
            getProductsAction.setCallback(this, function (response) {
                var actState = response.getState();
                if (actState === 'SUCCESS') {
                    var resposeData = response.getReturnValue();
                    console.log('Response Search Data:: '+JSON.stringify(resposeData));
                    if(resposeData==null ||resposeData==undefined||resposeData==''){
                        component.set("v.noData",true);  
                    }
                    component.set("v.ProductList", resposeData);
                    component.set("v.allData", resposeData);
                    if (resposeData != null && resposeData!=undefined && resposeData!='' ) {
                        if(resposeData.length > 0){
                            component.set("v.noData",false);    
                            component.set("v.totalPages", Math.ceil(resposeData.length / component.get("v.pageSize")));
                            component.set("v.allData", resposeData);
                            component.set("v.currentPageNumber", 1);
                            helper.buildData(component, helper);
                        }
                    }
                    component.set("v.showSpinnerSelProds",false); 
                }
                else{
                    console.log('Error');
                    component.set("v.showSpinnerSelProds",false);
                }
            });
            $A.enqueueAction(getProductsAction);
        }
        else{
            console.log('Inside Search Filter Else');
            var resposeData=component.get("v.Allproduct");
            component.set("v.totalPages", Math.ceil(resposeData.length / component.get("v.pageSize")));
            component.set("v.allData", resposeData);
            
            component.set("v.currentPageNumber", 1);
            helper.buildData(component, helper);
        }
        
    },
    sortHelper: function(component, event, sortFieldName) {
       // var currentDir = component.get("v.isAsc");
       // component.set("v.isAsc",!currentDir);
    /*    if (currentDir == 'arrowdown') {
            // set the arrowDirection attribute for conditionally rendred arrow sign  
            component.set("v.arrowDirection", 'arrowup');
            // set the isAsc flag to true for sort in Assending order.  
            component.set("v.isAsc", true);
        } else {
            component.set("v.arrowDirection", 'arrowdown');
            component.set("v.isAsc", false);
        }*/
        // call the onLoad function for call server side method with pass sortFieldName
        this.onSortResult(component, event, sortFieldName);
    },
    onSortResult: function(component, event, sortField) {
        //call apex class method
        component.set("v.showSpinnerSelProds",true);
        //component.set("v.selectAll",true);
        console.log('sortField: '+sortField);
        console.log('isAsc: '+component.get("v.isAsc"));
      //  var action = component.get('c.fetchSortResults');
        var productList = component.get("v.ProductList");
     
         var currentDir = component.get("v.isAsc");
        component.set("v.isAsc",!currentDir);
        console.log('sort console---'+!currentDir);
        var key = function(a) { return a[sortField]; }
            var reverse = currentDir ? 1: -1;
        productList.sort(function(a,b){
                    var a = key(a) ? key(a) : '';
                    var b = key(b) ? key(b) : '';
                    return reverse * ((a>b) - (b>a));
                });
        component.set("v.ProductList", productList);
        component.set("v.showSpinnerSelProds",false);
        

    //    });
     //s   $A.enqueueAction(action);
    },
    searchRx: function (component,helper) {
        var picliList = component.get('v.RxSrxList');    
        console.log('picliList--->'+picliList)
        if(component.get("v.isRxChecked") && !picliList.includes('Rx')){
            
            picliList.push('Rx');
            console.log('Inside 546')
        }
        if(component.get("v.isSRxChecked") && !picliList.includes('SRx')){
            picliList.push('SRx');
            console.log('Inside 550')
        }
        if(component.get("v.isOtcChecked") && !picliList.includes('OTC')){
            picliList.push('OTC');
            console.log('Inside 554')
        }
        if(component.get("v.isSpecialtyChecked") && !picliList.includes('Specialty')){
            picliList.push('Specialty');
            console.log('Inside 673')
        }
        if(component.get("v.isRxChecked") == false && picliList.includes('Rx')){
            var ind = picliList.indexOf('Rx')
            picliList.splice(ind, 1);
            console.log('Inside 559')
        }
        if(component.get("v.isSRxChecked") == false && picliList.includes('SRx')){
            var ind = picliList.indexOf('SRx')
            picliList.splice(ind, 1);
            console.log('Inside 564')
        }
        if(component.get("v.isOtcChecked") == false && picliList.includes('OTC')){
            var ind = picliList.indexOf('OTC')
            picliList.splice(ind, 1);
            console.log('Inside 569')
        }
        if(component.get("v.isSpecialtyChecked") == false && picliList.includes('Specialty')){
            var ind = picliList.indexOf('Specialty')
            picliList.splice(ind, 1);
            console.log('Inside 693')
        }
        component.set("v.RxSrxList",picliList);
        console.log('picliList--->'+picliList)
        component.set("v.showSpinnerSelProds",true);
        var selectedProdList = component.get("v.DuplicateProductList");
        console.log('selectedProdList--->'+selectedProdList.length)
        var allProds = component.get("v.allData");
        console.log('allProds length--->'+allProds.length)
        var searchName=component.get("v.searchText");
            var selectedList=[];
             selectedProdList.forEach(function(item){
                 console.log('item.Vision_Segment__c-----'+item.Vision_Segment__c);
                    if(picliList.includes(item.Vision_Segment__c)){
                        selectedList.push(item);
                    } 
                });
                component.set("v.ProductList", selectedList);
               component.set("v.showSpinnerSelProds",false);
            if(picliList.length == 0){
            component.set("v.ProductList",component.get("v.DuplicateProductList"));
 
            }

      },      
})