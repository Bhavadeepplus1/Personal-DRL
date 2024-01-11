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
         myMap.set("Contr.Number", "Phoenix_Contr_Number__c"); 
        myMap.set("Contr.IntDesc", "Phoenix_Contr_IntDesc__c");
          myMap.set("Cust Name", "Phoenix_Cust_Name__c");
         myMap.set("Matl No", "Phoenix_Matl_No__c");
           myMap.set("Product", "Phoenix_Product__r.Name");
         myMap.set("Cust Number", "Phoenix_Cust_Number__c");
           
          myMap.set("Description", "Phoenix_Description__c");
      
      
        myMap.set("Product Family", "Phoenix_Product_Family__c");
         myMap.set("NDC11", "Phoenix_NDC11__c");
       
        myMap.set("Account Name", "Phoenix_Account__r.Name");
       
          myMap.set("NPR", "Phoenix_NPR__r.Name");
       
          myMap.set("System WAC", "Phoenix_System_WAC__c");
           myMap.set("System Contract Price", "Phoenix_System_Contract_price__c");
          myMap.set("Uploaded WAC", "Phoenix_Uploaded_WAC__c");
         myMap.set("Uploaded Contr.Price", "Phoenix_Uploaded_Contr_Price__c");
         myMap.set("Sys WAC Vs Uploaded WAC", "Phoenix_SysWAC_Vs_UploadedWAC__c");
         myMap.set("Sys Contr.Price Vs Uploaded Contr.Price", "Phoenix_SysContPrice_Vs_UploadContrPrice__c");
         myMap.set("Proposed WAC", "Phoenix_Proposed_WAC__c");
        
         myMap.set("Proposed Contr.Price", "Phoenix_Proposed_Contr_Price__c");
          myMap.set("Sys WAC Vs Proposed WAC", "Phoenix_Sys_WAC_Vs_Proposed_WAC__c");
           myMap.set("Sys Contr.Price Vs Proposed Contr.Price", "Phoenix_SysContrPrice_Vs_PropContrPrice__c");
           myMap.set("Comments", "Phoenix_Comments__c");
          myMap.set("Head of PM Group Approval", "Phoenix_Head_of_PM_Group_Approval__c");
          myMap.set("Head of PM Remarks", "Phoenix_Head_of_PM_Comments__c");
         myMap.set("Contracts Approval", "Phoenix_Contracts_Approval__c");
         myMap.set("Contracts Comments", "Phoenix_Contracts_Comments__c");
           myMap.set("Offer Letter Sent", "Phoenix_Offer_Letter_Sent__c");
           myMap.set("Date Offer Sent", "Phoenix_Date_Offer_Sent__c");
           myMap.set("Customer Approval", "Phoenix_Customer_Update_Approval__c");
           myMap.set("Customer Response Date", "Phoenix_Customer_Response_Date__c");
           myMap.set("Customer Remarks", "Phoenix_Customer_Update_Remarks__c");
          /* myMap.set("Vistex  Approval", "Phoenix_Vistex_Update_Approval__c");
           myMap.set("Date Posted in Vistex", "Phoenix_Date_Posted_in_Vistex__c");
          myMap.set("Vistex Remarks", "Phoenix_Vistex_Remarks__c");*/
        myMap.set("WAC Change Line Number", "Name");
     
           
       
        csvStringResult += Array.from(myMap.keys()).join(columnDivider);
        csvStringResult += lineDivider;
        for(var i=0; i < objectRecords.length; i++){  
            counter = 0;
            for (let [key, value] of myMap) {
                if(counter > 0){ 
                    csvStringResult += columnDivider; 
                }
                console.log('testing result--->'+JSON.stringify(objectRecords[i]));
               if('Phoenix_Account__r' in objectRecords[i]){
                if(value == "Phoenix_Account__r.Name" && objectRecords[i]["Phoenix_Account__r"]["Name"] != undefined){
                    csvStringResult += '"' + objectRecords[i]["Phoenix_Account__r"]["Name"]+ '"';
                    console.log('csvStringResult---------'+csvStringResult);
                      
                }
                 }
                
              
               if('Phoenix_NPR__r' in objectRecords[i]){
                if(value == "Phoenix_NPR__r.Name" && objectRecords[i]["Phoenix_NPR__r"]["Name"] != undefined){
                    csvStringResult += '"' + objectRecords[i]["Phoenix_NPR__r"]["Name"]+ '"';
                }
               }
                  if('Phoenix_Product__r' in objectRecords[i]){
                if(value == "Phoenix_Product__r.Name" && objectRecords[i]["Phoenix_Product__r"]["Name"] != undefined){
                    csvStringResult += '"' + objectRecords[i]["Phoenix_Product__r"]["Name"]+ '"';
                }
                  }
               
                if(value != 'Phoenix_Product__r.Name' && value != 'Phoenix_NPR__r.Name' && value != 'Phoenix_Account__r.Name'){
                    if(objectRecords[i][value]==undefined){
                            csvStringResult += '"'+''+'"';
                        }
                        else{
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