({
    convertArrayOfObjectsToCSV : function(component,objectRecords,recordType){
        // declare variables
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
        myMap.set("Product Name", "Phoenix_Product_Name__r.Name");
           myMap.set("Material Code", "Phoenix_Material_Code__c"); 
        myMap.set("NDC-11", "Phoenix_NDC_11__c");
        if(recordType=='Provisional PHS Price Change'){
         myMap.set("Provisional PHS Price", "Phoenix_Provisional_PHS_Price__c");
              myMap.set("Price Start Date", "Phoenix_Price_Start_Date__c");
          myMap.set("Price End Date", "Phoenix_Price_End_Date__c");
        }
         if(recordType=='Quarterly PHS Price Change'){
        myMap.set("Old PHS Price $", "Phoenix_Old_PHS_Price__c");
    
        myMap.set("New PHS Price $", "Phoenix_New_PHS_Price__c");
         myMap.set("%Change in Price", "Phoenix_Change_in_Price__c");
        myMap.set("Last 90 days PHS Units", "Phoenix_Last_90_days_PHS_Units__c");
        myMap.set("Sales Difference $", "Phoenix_Sales_Difference__c");
       
          myMap.set("Price in Apexus Sub-Ceiling Contract", "Price_in_Apexus_Sub_Ceiling_Contract__c");
          myMap.set("Diff in Apexus Sub-Ceiling Price", "Phoenix_Diff_in_Apexus_Sub_Ceiling_Price__c");
          myMap.set("Apexus Sub-Ceiling Price Change Required", "Apexus_Sub_Ceiling_Price_Change_Required__c");
       }
           myMap.set("Submitter Remarks", "Phoenix_Remarks__c");
         
        
         
          myMap.set("Finance Head Approval", "Phoenix_Finance_Approval__c");
          myMap.set("Finance Head Remarks", "Phoenix_Finance_Approval_Remarks__c");
        
          /* myMap.set("Vistex Approval", "Phoenix_Vistex_Approval__c");
           myMap.set("Vistex Remarks", "Phoenix_Vistex_Approval_Remarks__c");*/
     
           
       
        csvStringResult += Array.from(myMap.keys()).join(columnDivider);
        csvStringResult += lineDivider;
        for(var i=0; i < objectRecords.length; i++){  
            counter = 0;
            for (let [key, value] of myMap) {
                if(counter > 0){ 
                    csvStringResult += columnDivider; 
                }
                console.log('testing result--->'+JSON.stringify(objectRecords[i]));
               if(value=='Phoenix_Product_Name__r.Name'){
                    csvStringResult += '"' + objectRecords[i]["Phoenix_Product_Name__r"]["Name"]+ '"';
                   
               }
               
                else{
                    if(objectRecords[i][value]==undefined){
                        csvStringResult += '"'+''+'"';
                    }else{
                        csvStringResult += '"'+ objectRecords[i][value]+'"';
                    }
                }                
                counter++;
            }
            csvStringResult += lineDivider;
        }
        return csvStringResult;        
    }
    
})