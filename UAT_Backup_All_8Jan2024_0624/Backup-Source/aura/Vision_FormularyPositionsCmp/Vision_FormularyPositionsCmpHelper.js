({
	getData : function(component, event, helper) {
		var action = component.get("c.getProducts");
        action.setParams({
            'accountId': component.get("v.recordId"),
            'isAsc': component.get("v.isAsc"),
            'sortField': component.get("v.sortField"),
            'selections': component.get("v.selections")
        });
        action.setCallback(this, function(response){
            if(response.getState() == 'SUCCESS'){
                component.set("v.loaded", false);
                var resp = response.getReturnValue();
                component.set("v.contracts", resp.contracts);
                component.set("v.positionsCount", resp.mapOfPositions);
                component.set("v.isROSCustomer", resp.isROSCustomer);
                var isROSCustomer = resp.isROSCustomer; 
                var accRecord = resp.accountRec;
                var isOTCCustomer = false;
                if(String(accRecord.Name).includes('Private Label')){
                    component.set("v.isOTCCustomer", true);
                    isOTCCustomer = true;
                }
                var contracts = resp.contracts;
                if(contracts != null){
                    var randomBgColors = [];
                    for(var i=0; i<contracts.length; i++){
                        var letters = '0123456789ABCDEF'.split('');
                        var color = '#';
                        for (var j = 0; j < 6; j++ ) {
                            color += letters[Math.floor(Math.random() * 16)];
                        }
                        randomBgColors.push(color);
                    }
                    component.set("v.randomBgColors",randomBgColors);
                }
                var today = new Date();
                var keys = Object.keys(resp.finalData);
                var finalData = resp.finalData;
                var finalList = [];
                var RxCount = 0; var SRxCount = 0; var OTCCount = 0;
                var obj = {}; var cvsProductsData = []; var productGroupedData = {};
                if(keys != null){
                    for(var i=0; i<keys.length; i++){
                        var cvsObj = {};
                        var record = finalData[keys[i]];
                        var productData = record[0];
                        if(productData.Vision_Product__r.Phoenix_Rx_SRx_OTC__c == 'Rx'){
                            RxCount += 1;
                        } else if(productData.Vision_Product__r.Phoenix_Rx_SRx_OTC__c == 'SRx'){
                            SRxCount += 1;
                        } else if(productData.Vision_Product__r.Phoenix_Rx_SRx_OTC__c == 'OTC'){
                            OTCCount += 1;
                        }
                        var tempformularyA = []; var tempformularyB = []; var tempformularyC = []; var tempformularyD = [];
                        for(var j=0; j<record.length; j++){
                            var effDate = new Date(record[j].Vision_Supply_Effective_Date__c);
                            if(record[j].hasOwnProperty('Vision_Supply_Effective_Date__c') && effDate > today){
                                var month = effDate.getUTCMonth() + 1; //months from 1-12
                                var day = effDate.getUTCDate();
                                var year = effDate.getUTCFullYear();
                                var formattedDate = month + "-" + day + "-" + year;
                                record[j].showSED = true;
                                record[j].formattedDate = formattedDate;
                            }
                            if(isOTCCustomer){
                                var formattedStatus = (record[j].Vision_Current_Contract_Position_Status__c * 100);
                                if(!isNaN(formattedStatus)){
                                    record[j].Vision_Current_Contract_Position_Status__c = (record[j].Vision_Current_Contract_Position_Status__c * 100).toFixed()+'%';   
                                }
                            }
                            if(isROSCustomer && record[j].Vision_Account__r.Name == 'CVS/Caremark'){
                                var productObj = {}; productObj.formularyA = []; productObj.formularyB = []; productObj.formularyC = []; productObj.formularyD = [];
                                var position = record[j].Vision_Current_Product_Position__c;
                                var formularyA = []; var formularyB = []; var formularyC = []; var formularyD = [];
                                //var tempformularyA = []; var tempformularyB = []; var tempformularyC = []; var tempformularyD = [];
                                if(record[j].Vision_Product_Code__c == '300004846'){
                                    console.log('before position: '+position);
                                }
                                if(position != null && position != ''){
                                    position = position.replaceAll(',', ' ');
                                    if(record[j].Vision_Product_Code__c == '300004846'){
                                        console.log('after position: '+position);
                                    }
                                    if(position.includes('FORMULARY A -') || position.includes('Formulary A -')){
                                        formularyA = position.toLowerCase().split('formulary a -');
                                    }
                                    if(position.includes('FORMULARY B -') || position.includes('Formulary B -')){
                                        formularyB = position.toLowerCase().split('formulary b -');
                                    }
                                    if(position.includes('FORMULARY C -') || position.includes('Formulary C -')){
                                        formularyC = position.toLowerCase().split('formulary c -');
                                    }
                                    if(position.includes('FORMULARY D -') || position.includes('Formulary D -')){
                                        formularyD = position.toLowerCase().split('formulary d -');
                                    }
                                    if(record[j].Vision_Product_Code__c == '300004846'){
                                        console.log('Formulary A: '+formularyA);
                                        console.log('Formulary B: '+formularyB);
                                        console.log('Formulary C: '+formularyC);
                                        console.log('Formulary D: '+formularyD);
                                    }
                                    if(formularyA != null){
                                        var secondIndexValue = formularyA[1]; var finalValue = '';
                                        if(secondIndexValue != null && secondIndexValue != ''){
                                            var correctedPositionValue = secondIndexValue.trimStart();
                                            secondIndexValue = correctedPositionValue.split(' ')[0];
                                            if(record[j].Vision_Product_Code__c == '300004846'){
                                                console.log('correctedPositionValue: '+correctedPositionValue);
                                            }
                                            if(secondIndexValue.includes('formulary a -')){
                                                finalValue = secondIndexValue.replace('formulary a -', '');                                            
                                            } else if(secondIndexValue.includes('formulary b -')){
                                                finalValue = secondIndexValue.replace('formulary b -', '');                                            
                                            } else if(secondIndexValue.includes('formulary c -')){
                                                finalValue = secondIndexValue.replace('formulary c -', '');                                            
                                            } else if(secondIndexValue.includes('formulary d -')){
                                                finalValue = secondIndexValue.replace('formulary d -', '');                                            
                                            } else{
                                                finalValue = secondIndexValue;
                                            }   
                                        }
                                        if(finalValue != null && finalValue != ''){
                                            finalValue = finalValue.toUpperCase();
                                            finalValue = finalValue.trim();
                                            finalValue = finalValue.toString();
                                        }
                                        if(!tempformularyA.includes(finalValue)){
                                         	tempformularyA.push(finalValue);    
                                        }
                                    }
                                    if(formularyB != null){
                                        var secondIndexValue = formularyB[1]; var finalValue = '';
                                        if(secondIndexValue != null && secondIndexValue != ''){
                                            var correctedPositionValue = secondIndexValue.trimStart();
                                            secondIndexValue = correctedPositionValue.split(' ')[0];
                                            if(record[j].Vision_Product_Code__c == '300004846'){
                                                console.log('correctedPositionValue: '+correctedPositionValue);
                                            }
                                            if(secondIndexValue.includes('formulary a -')){
                                                finalValue = secondIndexValue.replace('formulary a -', '');                                            
                                            } else if(secondIndexValue.includes('formulary b -')){
                                                finalValue = secondIndexValue.replace('formulary b -', '');                                            
                                            } else if(secondIndexValue.includes('formulary c -')){
                                                finalValue = secondIndexValue.replace('formulary c -', '');                                            
                                            } else if(secondIndexValue.includes('formulary d -')){
                                                finalValue = secondIndexValue.replace('formulary d -', '');                                            
                                            } else{
                                                finalValue = secondIndexValue;
                                            }   
                                        }
                                        if(finalValue != null && finalValue != ''){
                                            finalValue = finalValue.toUpperCase();
                                            finalValue = finalValue.trim();
                                            finalValue = finalValue.toString();
                                        }
                                        if(!tempformularyB.includes(finalValue)){
                                         	tempformularyB.push(finalValue);    
                                        }
                                    }
                                    if(formularyC != null){
                                        var secondIndexValue = formularyC[1]; var finalValue = '';
                                        if(secondIndexValue != null && secondIndexValue != ''){
                                            var correctedPositionValue = secondIndexValue.trimStart();
                                            secondIndexValue = correctedPositionValue.split(' ')[0];
                                            if(record[j].Vision_Product_Code__c == '300004846'){
                                                console.log('correctedPositionValue: '+correctedPositionValue);
                                            }
                                            if(secondIndexValue.includes('formulary a -')){
                                                finalValue = secondIndexValue.replace('formulary a -', '');                                            
                                            } else if(secondIndexValue.includes('formulary b -')){
                                                finalValue = secondIndexValue.replace('formulary b -', '');                                            
                                            } else if(secondIndexValue.includes('formulary c -')){
                                                finalValue = secondIndexValue.replace('formulary c -', '');                                            
                                            } else if(secondIndexValue.includes('formulary d -')){
                                                finalValue = secondIndexValue.replace('formulary d -', '');                                            
                                            } else{
                                                finalValue = secondIndexValue;
                                            }   
                                        }
                                        if(finalValue != null && finalValue != ''){
                                            finalValue = finalValue.toUpperCase();
                                            finalValue = finalValue.trim();
                                            finalValue = finalValue.toString();
                                        }
                                        if(!tempformularyC.includes(finalValue)){
                                         	tempformularyC.push(finalValue);    
                                        }   
                                    }
                                    if(formularyD != null){
                                        var secondIndexValue = formularyD[1]; var finalValue = '';
                                        if(secondIndexValue != null && secondIndexValue != ''){
                                            var correctedPositionValue = secondIndexValue.trimStart();
                                            secondIndexValue = correctedPositionValue.split(' ')[0];
                                            if(record[j].Vision_Product_Code__c == '300004846'){
                                                console.log('correctedPositionValue: '+correctedPositionValue);
                                            }
                                            if(secondIndexValue.includes('formulary a -')){
                                                finalValue = secondIndexValue.replace('formulary a -', '');                                            
                                            } else if(secondIndexValue.includes('formulary b -')){
                                                finalValue = secondIndexValue.replace('formulary b -', '');                                            
                                            } else if(secondIndexValue.includes('formulary c -')){
                                                finalValue = secondIndexValue.replace('formulary c -', '');                                            
                                            } else if(secondIndexValue.includes('formulary d -')){
                                                finalValue = secondIndexValue.replace('formulary d -', '');                                            
                                            } else{
                                                finalValue = secondIndexValue;
                                            }   
                                        }
                                        if(finalValue != null && finalValue != ''){
                                            finalValue = finalValue.toUpperCase();
                                            finalValue = finalValue.trim();
                                            finalValue = finalValue.toString();
                                        }
                                        if(!tempformularyD.includes(finalValue)){
                                         	tempformularyD.push(finalValue);    
                                        }   
                                    }   
                                }
                                productObj.formularyA = tempformularyA;
                                productObj.formularyB = tempformularyB;
                                productObj.formularyC = tempformularyC;
                                productObj.formularyD = tempformularyD;
                                /*if(tempformularyA != null){
                                    let unique = [];
                                    tempformularyA.forEach(element => {
                                        if (!unique.includes(element)) {
                                        unique.push(element);
                                    }
                                                           });
                                 	productObj.formularyA = unique;   
                                }
                                if(tempformularyB != null){
                                    let unique = [];
                                    tempformularyB.forEach(element => {
                                        if (!unique.includes(element)) {
                                        unique.push(element);
                                    }
                                                           });
                                 	productObj.formularyB = unique;   
                                }
                                if(tempformularyC != null){
                                    let unique = [];
                                    tempformularyC.forEach(element => {
                                        if (!unique.includes(element)) {
                                        unique.push(element);
                                    }
                                                           });
                                 	productObj.formularyC = unique;   
                                }
                                if(tempformularyD != null){
                                    let unique = [];
                                    tempformularyD.forEach(element => {
                                        if (!unique.includes(element)) {
                                        unique.push(element);
                                    }
                                                           });
                                 	productObj.formularyD = unique;   
                                }*/
                                //console.log('productObj: '+JSON.stringify(productObj));
                                record[j].formularyObj = productObj;
                            }
                        }
                        finalList.push(record);
                    }
                    component.set("v.productData", finalList);
                    /*var finalFormularyList = [];
                    if(productGroupedData != null){
                        var keys = Object.keys(productGroupedData);
                        for(var i=0; i<keys.length; i++){
                            var relatedList = productGroupedData[keys[i]];
                            var productObj = {};
                            productObj.product = keys[i]; productObj.formularyA = []; productObj.formularyB = []; productObj.formularyC = []; productObj.formularyD = [];
                            for(var j=0; j<relatedList.length; j++){
                                if(relatedList[j].Vision_Current_Product_Position__c != null){
                                    var position = relatedList[j].Vision_Current_Product_Position__c;
                                    var formularyA = []; var formularyB = []; var formularyC = []; var formularyD = [];
                                    if(position.includes('FORMULARY A -') || position.includes('Formulary A -')){
                                        formularyA = position.toLowerCase().split('formulary a -');
                                    }
                                    if(position.includes('FORMULARY B -') || position.includes('Formulary B -')){
                                        formularyB = position.toLowerCase().split('formulary b -');
                                    }
                                    if(position.includes('FORMULARY C -') || position.includes('Formulary C -')){
                                        formularyC = position.toLowerCase().split('formulary c -');
                                    }
                                    if(position.includes('FORMULARY D -') || position.includes('Formulary D -')){
                                        formularyD = position.toLowerCase().split('formulary d -');
                                    }
                                    if(formularyA != null){
                                        var secondIndexValue = formularyA[1]; var finalValue = '';
                                        if(secondIndexValue != null && secondIndexValue != ''){
                                            if(secondIndexValue.includes('formulary a -')){
                                                finalValue = secondIndexValue.replace('formulary a -', '');                                            
                                            } else if(secondIndexValue.includes('formulary b -')){
                                                finalValue = secondIndexValue.replace('formulary b -', '');                                            
                                            } else if(secondIndexValue.includes('formulary c -')){
                                                finalValue = secondIndexValue.replace('formulary c -', '');                                            
                                            } else if(secondIndexValue.includes('formulary d -')){
                                                finalValue = secondIndexValue.replace('formulary d -', '');                                            
                                            } else{
                                                finalValue = secondIndexValue;
                                            }   
                                        }
                                        productObj.formularyA.push(finalValue);
                                    }
                                    if(formularyB != null){
                                        var secondIndexValue = formularyB[1]; var finalValue = '';
                                        if(secondIndexValue != null && secondIndexValue != ''){
                                            if(secondIndexValue.includes('formulary a -')){
                                                finalValue = secondIndexValue.replace('formulary a -', '');                                            
                                            } else if(secondIndexValue.includes('formulary b -')){
                                                finalValue = secondIndexValue.replace('formulary b -', '');                                            
                                            } else if(secondIndexValue.includes('formulary c -')){
                                                finalValue = secondIndexValue.replace('formulary c -', '');                                            
                                            } else if(secondIndexValue.includes('formulary d -')){
                                                finalValue = secondIndexValue.replace('formulary d -', '');                                            
                                            } else{
                                                finalValue = secondIndexValue;
                                            }   
                                        }
                                        productObj.formularyB.push(finalValue);
                                    }
                                    if(formularyC != null){
                                        var secondIndexValue = formularyC[1]; var finalValue = '';
                                        if(secondIndexValue != null && secondIndexValue != ''){
                                            if(secondIndexValue.includes('formulary a -')){
                                                finalValue = secondIndexValue.replace('formulary a -', '');                                            
                                            } else if(secondIndexValue.includes('formulary b -')){
                                                finalValue = secondIndexValue.replace('formulary b -', '');                                            
                                            } else if(secondIndexValue.includes('formulary c -')){
                                                finalValue = secondIndexValue.replace('formulary c -', '');                                            
                                            } else if(secondIndexValue.includes('formulary d -')){
                                                finalValue = secondIndexValue.replace('formulary d -', '');                                            
                                            } else{
                                                finalValue = secondIndexValue;
                                            }   
                                        }
                                        productObj.formularyC.push(finalValue);
                                    }
                                    if(formularyD != null){
                                        var secondIndexValue = formularyD[1]; var finalValue = '';
                                        if(secondIndexValue != null && secondIndexValue != ''){
                                            if(secondIndexValue.includes('formulary a -')){
                                                finalValue = secondIndexValue.replace('formulary a -', '');                                            
                                            } else if(secondIndexValue.includes('formulary b -')){
                                                finalValue = secondIndexValue.replace('formulary b -', '');                                            
                                            } else if(secondIndexValue.includes('formulary c -')){
                                                finalValue = secondIndexValue.replace('formulary c -', '');                                            
                                            } else if(secondIndexValue.includes('formulary d -')){
                                                finalValue = secondIndexValue.replace('formulary d -', '');                                            
                                            } else{
                                                finalValue = secondIndexValue;
                                            }   
                                        }
                                        productObj.formularyD.push(finalValue);
                                    }
                                }
                            }
                            finalFormularyList.push(productObj);
                        }
                    }
                    console.log('finalFormularyList: '+JSON.stringify(finalFormularyList));
                    component.set("v.finalFormularyList", finalFormularyList);*/
                    obj.RxCount = RxCount;
                    obj.SRxCount = SRxCount;
                    obj.OTCCount = OTCCount;
                    component.set("v.productTypeCount", obj);
                }
                if(finalList != null){
                    var productList = component.get("v.productData")[0];
                    var countOfPos = resp.countOfPos;
                    var awardedCount = resp.awardedCount;
                    var missingCount = resp.missingCount;
                    component.set("v.awardedCounts", awardedCount);
                    component.set("v.missingCounts", missingCount);
                    component.set("v.noContractCount", finalList.length);
                    var counts = [];
                    if(productList != null){
                        for(var i=0; i<productList.length; i++){
                            var obj = {};
                            if(!isROSCustomer && productList[i].Vision_Account__r.Name == 'CVS/Caremark'){
                                if(countOfPos.hasOwnProperty(productList[i].Vision_Contract__r.Phoenix_Contract_External_Description__c)){
                                    obj.totalCount = countOfPos[productList[i].Vision_Contract__r.Phoenix_Contract_External_Description__c];
                                }
                                if(awardedCount.hasOwnProperty(productList[i].Vision_Contract__r.Phoenix_Contract_External_Description__c)){
                                    obj.awardedCount = awardedCount[productList[i].Vision_Contract__r.Phoenix_Contract_External_Description__c];
                                }
                                if(missingCount.hasOwnProperty(productList[i].Vision_Contract__r.Phoenix_Contract_External_Description__c)){
                                    obj.missingCount = missingCount[productList[i].Vision_Contract__r.Phoenix_Contract_External_Description__c];
                                }
                                counts.push(obj);   
                            } else if(isROSCustomer && productList[i].Vision_Account__r.Name != 'CVS/Caremark'){
                                if(countOfPos.hasOwnProperty(productList[i].Vision_Contract__r.Phoenix_Contract_External_Description__c)){
                                    obj.totalCount = countOfPos[productList[i].Vision_Contract__r.Phoenix_Contract_External_Description__c];
                                }
                                if(awardedCount.hasOwnProperty(productList[i].Vision_Contract__r.Phoenix_Contract_External_Description__c)){
                                    obj.awardedCount = awardedCount[productList[i].Vision_Contract__r.Phoenix_Contract_External_Description__c];
                                }
                                if(missingCount.hasOwnProperty(productList[i].Vision_Contract__r.Phoenix_Contract_External_Description__c)){
                                    obj.missingCount = missingCount[productList[i].Vision_Contract__r.Phoenix_Contract_External_Description__c];
                                }
                                counts.push(obj);   
                            } else if(isROSCustomer && productList[i].Vision_Account__r.Name == 'CVS/Caremark'){   
                            } else{
                                if(countOfPos.hasOwnProperty(productList[i].Vision_Contract__r.Phoenix_Contract_External_Description__c)){
                                    obj.totalCount = countOfPos[productList[i].Vision_Contract__r.Phoenix_Contract_External_Description__c];
                                }
                                if(awardedCount.hasOwnProperty(productList[i].Vision_Contract__r.Phoenix_Contract_External_Description__c)){
                                    obj.awardedCount = awardedCount[productList[i].Vision_Contract__r.Phoenix_Contract_External_Description__c];
                                }
                                if(missingCount.hasOwnProperty(productList[i].Vision_Contract__r.Phoenix_Contract_External_Description__c)){
                                    obj.missingCount = missingCount[productList[i].Vision_Contract__r.Phoenix_Contract_External_Description__c];
                                }
                                counts.push(obj);
                            }
                        }
                        component.set("v.counts", counts);    
                    }  
                }
                if(resp.trackerData.length == 0){
                    component.set("v.noData", true);
                } else{
                    component.set("v.noData", false);
                }
            } else{
                console.log("Error "+JSON.stringify(response.getError()));
                component.set("v.loaded", false);
            }
        });
        $A.enqueueAction(action);
    },
    
    convertArrayOfObjectsToCSV: function (component, objectRecords,reportName) {
        // declare variables
        var csvStringResult, counter, keys, columnDivider, lineDivider;
        // check if "objectRecords" parameter is null, then return from function
        /*if (objectRecords == null || !objectRecords.length) {
            return null;
        }*/
        columnDivider = ',';
        lineDivider = '\n';
        var myMap = new Map();
        csvStringResult = '';
        myMap.set("Product Description", "Product");
        myMap.set("NDC / SKU", "NDC11");
        if(component.get("v.isROSCustomer")){
        	myMap.set("Formulary A", "formularyA");
            myMap.set("Formulary B", "formularyB");
            myMap.set("Formulary C", "formularyC");
            myMap.set("Formulary D", "formularyD");
        }
        var productData = component.get("v.productData")[0];
        for(var i=0; i<productData.length; i++){
            if(component.get("v.isROSCustomer") && productData[i].Vision_Account__r.Name == 'CVS/Caremark'){
                
            }
            else{
             	myMap.set(productData[i].Vision_Contract__r.Phoenix_Contract_External_Description__c, 'Vision_Current_Contract_Position_Status__c'+i);   
            }
        }
        csvStringResult += Array.from(myMap.keys()).join(columnDivider);
        csvStringResult += lineDivider;
        
        
        for (var i = 0; i < objectRecords.length; i++) {
            counter = 0;
            for (let [key, value] of myMap) {
                if (counter > 0) {
                    csvStringResult += columnDivider;
                }
                if(value == 'Product'){
                    var record = objectRecords[i][0];
                    if(record != null){
                        csvStringResult += '"'+ record.Vision_Product__r.Name +'"';
                    }
                    else{
                        csvStringResult += '"'+''+'"';
                    }
                }
                else if(value == 'NDC11'){
                    var record = objectRecords[i][0];
                    if(record != null && record.Vision_Product__r.Phoenix_NDC_11__c != null){
                        csvStringResult += '"'+ record.Vision_Product__r.Phoenix_NDC_11__c+' / '+record.Vision_Product_Code__c +'"';
                    }
                    else{
                        csvStringResult += '"'+record.Vision_Product_Code__c+''+'"';
                    }
                }
                else if(value.includes('Vision_Current_Contract_Position_Status__c')){
                    var recordsList = objectRecords[i];
                    var today = new Date();
                    if(recordsList != null){
                        for(var j=0; j<recordsList.length; j++) {
                            var contKey = 'Vision_Current_Contract_Position_Status__c'+j;
                            if(value == contKey){
                                var effDate = new Date(recordsList[j].Vision_Supply_Effective_Date__c);
                                if(effDate > today){
                                    var month = effDate.getUTCMonth() + 1; //months from 1-12
                                    var day = effDate.getUTCDate();
                                    var year = effDate.getUTCFullYear();
                                    var formattedDate = month + "-" + day + "-" + year;
                                    csvStringResult += '"'+ recordsList[j].Vision_Current_Contract_Position_Status__c +' ('+formattedDate+')"';   
                                } else{
                                 	csvStringResult += '"'+ recordsList[j].Vision_Current_Contract_Position_Status__c +'"';   
                                }
                            }
                        }   
                    }
                    else{
                        csvStringResult += '"'+''+'"';
                    }
                }
                    else if(component.get("v.isROSCustomer") && value.includes('formularyA')){
                        var record1 = objectRecords[i][0];
                        if(record1 != null){
                            var listOfRecords = record1.formularyObj.formularyA;
                            if(listOfRecords != null){
                                for(var j=0; j<listOfRecords.length; j++){
                             		csvStringResult += listOfRecords[j] + ' ';
                                }  
                            }
                        }
                        else{
                            csvStringResult += '"'+''+'"';
                        }
                        /*var record2 = objectRecords[i][1];
                        if(record2 != null){
                            var listOfRecords = record2.formularyObj.formularyA;
                            if(listOfRecords != null){
                                for(var j=0; j<listOfRecords.length; j++){
                             		csvStringResult += listOfRecords[j];
                                }   
                            }
                        }
                        else{
                            csvStringResult += '"'+''+'"';
                        }
                        var record3 = objectRecords[i][2];
                        if(record3 != null){
                            var listOfRecords = record3.formularyObj.formularyA;
                            if(listOfRecords != null){
                                for(var j=0; j<listOfRecords.length; j++){
                             		csvStringResult += listOfRecords[j];  
                                }   
                            }
                        }
                        else{
                            csvStringResult += '"'+''+'"';
                        }
                        var record4 = objectRecords[i][3];
                        if(record4 != null){
                            var listOfRecords = record4.formularyObj.formularyA;
                            if(listOfRecords != null){
                                for(var j=0; j<listOfRecords.length; j++){
                                    csvStringResult += listOfRecords[j];
                                }   
                            }
                        }
                        else{
                            csvStringResult += '"'+''+'"';
                        }*/
                    }
                    else if(component.get("v.isROSCustomer") && value.includes('formularyB')){
                        var record1 = objectRecords[i][0];
                        if(record1 != null){
                            var listOfRecords = record1.formularyObj.formularyB;
                            if(listOfRecords != null){
                                for(var j=0; j<listOfRecords.length; j++){
                             		csvStringResult += listOfRecords[j];
                                }  
                            }
                        }
                        else{
                            csvStringResult += '"'+''+'"';
                        }
                        /*var record2 = objectRecords[i][1];
                        if(record2 != null){
                            var listOfRecords = record2.formularyObj.formularyB;
                            if(listOfRecords != null){
                                for(var j=0; j<listOfRecords.length; j++){
                             		csvStringResult += listOfRecords[j];
                                }   
                            }
                        }
                        else{
                            csvStringResult += '"'+''+'"';
                        }
                        var record3 = objectRecords[i][2];
                        if(record3 != null){
                            var listOfRecords = record3.formularyObj.formularyB;
                            if(listOfRecords != null){
                                for(var j=0; j<listOfRecords.length; j++){
                             		csvStringResult += listOfRecords[j];  
                                }   
                            }
                        }
                        else{
                            csvStringResult += '"'+''+'"';
                        }
                        var record4 = objectRecords[i][3];
                        if(record4 != null){
                            var listOfRecords = record4.formularyObj.formularyB;
                            if(listOfRecords != null){
                                for(var j=0; j<listOfRecords.length; j++){
                                    csvStringResult += listOfRecords[j];
                                }   
                            }
                        }
                        else{
                            csvStringResult += '"'+''+'"';
                        }*/
                    }
                    else if(component.get("v.isROSCustomer") && value.includes('formularyC')){
                        var record1 = objectRecords[i][0];
                        if(record1 != null){
                            var listOfRecords = record1.formularyObj.formularyC;
                            if(listOfRecords != null){
                                for(var j=0; j<listOfRecords.length; j++){
                             		csvStringResult += listOfRecords[j];
                                }  
                            }
                        }
                        else{
                            csvStringResult += '"'+''+'"';
                        }
                        /*var record2 = objectRecords[i][1];
                        if(record2 != null){
                            var listOfRecords = record2.formularyObj.formularyC;
                            if(listOfRecords != null){
                                for(var j=0; j<listOfRecords.length; j++){
                             		csvStringResult += listOfRecords[j];
                                }   
                            }
                        }
                        else{
                            csvStringResult += '"'+''+'"';
                        }
                        var record3 = objectRecords[i][2];
                        if(record3 != null){
                            var listOfRecords = record3.formularyObj.formularyC;
                            if(listOfRecords != null){
                                for(var j=0; j<listOfRecords.length; j++){
                             		csvStringResult += listOfRecords[j];  
                                }   
                            }
                        }
                        else{
                            csvStringResult += '"'+''+'"';
                        }
                        var record4 = objectRecords[i][3];
                        if(record4 != null){
                            var listOfRecords = record4.formularyObj.formularyC;
                            if(listOfRecords != null){
                                for(var j=0; j<listOfRecords.length; j++){
                                    csvStringResult += listOfRecords[j];
                                }   
                            }
                        }
                        else{
                            csvStringResult += '"'+''+'"';
                        }*/
                    }
                    else if(component.get("v.isROSCustomer") && value.includes('formularyD')){
                        var record1 = objectRecords[i][0];
                        if(record1 != null){
                            var listOfRecords = record1.formularyObj.formularyD;
                            if(listOfRecords != null){
                                for(var j=0; j<listOfRecords.length; j++){
                             		csvStringResult += listOfRecords[j];
                                }  
                            }
                        }
                        else{
                            csvStringResult += '"'+''+'"';
                        }
                        /*var record2 = objectRecords[i][1];
                        if(record2 != null){
                            var listOfRecords = record2.formularyObj.formularyD;
                            if(listOfRecords != null){
                                for(var j=0; j<listOfRecords.length; j++){
                             		csvStringResult += listOfRecords[j];
                                }   
                            }
                        }
                        else{
                            csvStringResult += '"'+''+'"';
                        }
                        var record3 = objectRecords[i][2];
                        if(record3 != null){
                            var listOfRecords = record3.formularyObj.formularyD;
                            if(listOfRecords != null){
                                for(var j=0; j<listOfRecords.length; j++){
                             		csvStringResult += listOfRecords[j];  
                                }   
                            }
                        }
                        else{
                            csvStringResult += '"'+''+'"';
                        }
                        var record4 = objectRecords[i][3];
                        if(record4 != null){
                            var listOfRecords = record4.formularyObj.formularyD;
                            if(listOfRecords != null){
                                for(var j=0; j<listOfRecords.length; j++){
                                    csvStringResult += listOfRecords[j];
                                }   
                            }
                        }
                        else{
                            csvStringResult += '"'+''+'"';
                        }*/
                    }
                else  if (objectRecords[i][value] == undefined) {
                    csvStringResult += '"' + '' + '"';
                } else {
                    csvStringResult += '"' + objectRecords[i][value] + '"';
                }
                counter++;
            }
            csvStringResult += lineDivider;
        }   
        
        return csvStringResult;
    },
})