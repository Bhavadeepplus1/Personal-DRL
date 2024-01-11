({
	convertArrayOfObjectsToCSV : function(component,objectRecords,bidtype){
        // declare variables
        var csvStringResult, counter, keys,columnDivider, lineDivider;
        var Bid_Type =bidtype;
        console.log('bid type is-->'+Bid_Type);
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
        myMap.set("Date", "Phoenix_RCA_Change_Date__c");
        myMap.set("Customer", "Phoenix_Customer__r.Name");
        myMap.set("Street Number/Name", "Phoenix_Street_Name__c");
        myMap.set("City", "Phoenix_City__c");
        myMap.set("State", "Phoenix_State__c");
        myMap.set("ZIP", "Phoenix_Zip__c");
        myMap.set("DEA", "Phoenix_DEA__c");
        myMap.set("HIN", "Phoenix_HIN__c");
        myMap.set("GLN", "Phoenix_GLN__c");
        myMap.set("GPO", "Phoenix_New_GPO__c");
        myMap.set("Wholesaler Name", "Phoenix_Wholesaler__c");
        myMap.set("Wholesaler Location", "Phoenix_Wholesaler_Location__c");
        myMap.set("Parent IPA Customer", "Phoenix_Parent_IPA_Customer__r.Name");
        myMap.set("Contract", "Phoenix_RCA_Agreement__r.Name");
        myMap.set("Contact", "Phoenix_Contact__r.Name");
        myMap.set("Contact Email", "Phoenix_Contact_Email__c");
        myMap.set("Contact Phone", "Phoenix_Contact_Phone__c");
        myMap.set("Contact Phone Ext", "Phoenix_Contact_Phone_External__c");
     
      
        
      console.log('1-->');
        csvStringResult += Array.from(myMap.keys()).join(columnDivider);
        csvStringResult += lineDivider;
        for(var i=0; i < objectRecords.length; i++){  
            counter = 0;
            for (let [key, value] of myMap) {
                if(counter > 0){ 
                    csvStringResult += columnDivider; 
                }
                if('Phoenix_RCA_Change_Date__c' in objectRecords[i]){
                if(value=='Phoenix_RCA_Change_Date__c'){
                    var effectiveDate=objectRecords[i]["Phoenix_RCA_Change_Date__c"];
                        var dt = new Date(effectiveDate);
                        var month = dt.getMonth() + 1;
                        var day = dt.getDate();
                        var year = dt.getFullYear();
                        var formatteddate = month + "-" + day + "-" + year;
                        csvStringResult += '"'+formatteddate+'"'
                        console.log('formatteddate--->'+formatteddate);
                }
                }
               
                 if('Phoenix_Parent_IPA_Customer__r' in objectRecords[i]){
                    if(value=='Phoenix_Parent_IPA_Customer__r.Name' && objectRecords[i]["Phoenix_Parent_IPA_Customer__r"]["Name"]!=undefined){
                        csvStringResult += '"'+ objectRecords[i]["Phoenix_Parent_IPA_Customer__r"]["Name"]+'"';
                    }
                }
             
                 if('Phoenix_RCA_Agreement__r' in objectRecords[i]){
                    if(value=='Phoenix_RCA_Agreement__r.Name' && objectRecords[i]["Phoenix_RCA_Agreement__r"]["Name"]!=undefined){
                       csvStringResult += '"'+ objectRecords[i]["Phoenix_RCA_Agreement__r"]["Name"]+'"';
                    } 
                }
                if('Phoenix_Customer__r' in objectRecords[i]){
                    if(value=='Phoenix_Customer__r.Name' && objectRecords[i]["Phoenix_Customer__r"]["Name"]!=undefined){
                          csvStringResult += '"'+ objectRecords[i]["Phoenix_Customer__r"]["Name"]+'"';
                    }
                   
                }
                 if('Phoenix_Contact__r' in objectRecords[i]){
                    if(value=='Phoenix_Contact__r.Name' && objectRecords[i]["Phoenix_Contact__r"]["Name"]!=undefined){  
                      csvStringResult += '"'+ objectRecords[i]["Phoenix_Contact__r"]["Name"]+'"';
                    }
                }
          if(value != 'Phoenix_Parent_IPA_Customer__r.Name' && value != 'Phoenix_Contract__r.Name' && value != 'Phoenix_Customer__r.Name' && value != 'Phoenix_RCA_Agreement__r.Name' && value != 'Phoenix_RCA_Change_Date__c'){
 
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
    },
})