({
    convertArrayOfObjectsToCSV : function(component,objectRecords){
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
         myMap.set(" NDC Change Line Reference", "Name");
           myMap.set("Account", "Phoenix_Account__r.Name"); 
        myMap.set("Contract", "Phoenix_Contract__r.Name");
         myMap.set("Contract Description", "Phoenix_Contract_Internal_Description__c");
              myMap.set("NPR Record", "Phoenix_Current_NPR__r.Name");
        myMap.set("Current Product", "Phoenix_Current_Product__r.Name");
      
        myMap.set("Current Product Pack Size", "Phoenix_Current_Product_Pack_Size__c");
        myMap.set("Current Product NDC", "Phoenix_Current_Product_NDC__c");
        myMap.set("Proposed Product", "Phoenix_Proposed_Product__r.Name");
        myMap.set("Proposed Product Pack Size", "Phoenix_Proposed_Product_Pack_Size__c");
          myMap.set("Proposed Product NDC", "Phoenix_Proposed_Product_NDC__c");
          myMap.set("Contract Price", "Phoenix_Contract_Price__c");
          myMap.set("Awarded Quantity", "Phoenix_Awarded_Quantity__c");
          myMap.set("Actual Qty 12m", "Phoenix_Actual_Quantity_Last_12m__c");
            myMap.set("Submitter Remarks", "Phoenix_Submitter_Remarks__c");
          myMap.set("SCM Approval", "Phoenix_SCM_Approval_Y_N__c");
           myMap.set("Lead Time (SCM)", "Phoenix_Lead_Time__c");
           myMap.set("SCM Remarks", "Phoenix_Remarks__c");
          myMap.set("Finance Approval", "Phoenix_Finance_Approval__c");
          myMap.set("Finance Remarks", "Phoenix_Finance_Approval_Remarks__c");
         myMap.set("Contracts Sent to Customer", "Phoenix_Contracts_Approval__c");
          myMap.set("Sent to Customer Date", "Phoenix_Sent_to_Customer_Date__c");
           myMap.set("Contracts Remarks", "Phoenix_Contracts_Approval_Remarks__c");
           myMap.set("Customer Approval", "Pheonix_Customer_Approval__c");
         myMap.set("New NDC Effective Date", "Phoenix_New_NDC_Effective_Date__c");
         
           myMap.set("Customer Remarks", "Phoenix_Customer_Acceptance_Remarks__c");
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
                if(value=='Phoenix_Account__r.Name'){
                    csvStringResult += '"'+ objectRecords[i]["Phoenix_Account__r"]["Name"]+'"';
                }
                else if(value=='Phoenix_Contract__r.Name'){
                   csvStringResult += '"'+ objectRecords[i]["Phoenix_Contract__r"]["Name"]+'"';
                }
               else if(value=='Phoenix_Current_NPR__r.Name'){
                    csvStringResult += '"'+ objectRecords[i]["Phoenix_Current_NPR__r"]["Name"]+'"';
                }
                 else if(value=='Phoenix_Current_Product__r.Name'){
                    csvStringResult += '"'+ objectRecords[i]["Phoenix_Current_Product__r"]["Name"]+'"';
                }
                 else if(value=='Phoenix_Proposed_Product__r.Name'){
                    csvStringResult += '"'+ objectRecords[i]["Phoenix_Proposed_Product__r"]["Name"]+'"';
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