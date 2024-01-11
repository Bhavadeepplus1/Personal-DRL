({
    convertArrayOfObjectsToCSV : function(component,objectRecords,template,bidtype){
        // declare variables
        var csvStringResult, counter, keys,columnDivider, lineDivider;
        var Bid_Type =bidtype;
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
        myMap.set("Product Name", "Phoenix_Product__r.Name");
        myMap.set("SAP Number", "Phoenix_Product_Code1__c");
        myMap.set("Product Family", "Product_Family_Name__c");
        myMap.set("Product Director", "Phoenix_Product_Director1__c");
        myMap.set("NDC", "Phoenix_NDC__c");
          myMap.set("WAC", "Phoenix_WAC1__c");
        myMap.set("IPA Floor Price", "Phoenix_IPA_Floor_Price1__c");
        myMap.set("Proposed IPA Price", "Phoenix_Proposed_IPA_Price__c");
        myMap.set("IDN Usage", "Phoenix_IDN_Usage__c");
        if(Bid_Type == 'SRx IPA Price Change' || Bid_Type == 'SRx IPA Product Addition'){
          myMap.set("Contract", "Phoenix_Contract__r.Name");
          myMap.set("Customer", "Phoenix_Customer__r.Name");   
        } 
        
         myMap.set("Marketing Approval", "Phoenix_Marketing_Approval__c");   
         myMap.set("Marketing Comments", "Phoenix_Marketing_Notes__c"); 
         myMap.set("Finance Approval", "Phoenix_Finance_Approval__c");   
         myMap.set("Finance Comments", "Phoenix_Finance_Comments__c"); 
         myMap.set("Contract Approval", "Phoenix_Contract_Approval__c");   
         myMap.set("Contract Comments", "Phoenix_Contract_Comments__c"); 
        csvStringResult += Array.from(myMap.keys()).join(columnDivider);
        csvStringResult += lineDivider;
        for(var i=0; i < objectRecords.length; i++){  
            counter = 0;
            for (let [key, value] of myMap) {
                if(counter > 0){ 
                    csvStringResult += columnDivider; 
                }
                console.log('testing result--->'+JSON.stringify(objectRecords[i]));
               if('Phoenix_Product__r' in objectRecords[i]){
                    if(value == "Phoenix_Product__r.Name" && objectRecords[i]["Phoenix_Product__r"]["Name"] != undefined){
                     csvStringResult += '"'+ objectRecords[i]['Phoenix_Product__r']['Name']+'"';  
					}
                 }
                if('Phoenix_Contract__r' in objectRecords[i]){
                    if(value == "Phoenix_Contract__r.Name" && objectRecords[i]["Phoenix_Contract__r"]["Name"] != undefined){
                     csvStringResult += '"'+ objectRecords[i]['Phoenix_Contract__r']['Name']+'"';  
					}
                 }
                if('Phoenix_Customer__r' in objectRecords[i]){
                    if(value == "Phoenix_Customer__r.Name" && objectRecords[i]["Phoenix_Customer__r"]["Name"] != undefined){
                     csvStringResult += '"'+ objectRecords[i]['Phoenix_Customer__r']['Name']+'"';  
					}
                 }
           		if(value != 'Phoenix_Product__r.Name' && value != 'Phoenix_Contract__r.Name' && value != 'Phoenix_Customer__r.Name'){

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