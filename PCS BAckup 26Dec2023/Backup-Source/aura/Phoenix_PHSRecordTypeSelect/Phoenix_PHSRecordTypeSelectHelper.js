({
    fetchListOfRecordTypes: function(component, event, helper) {
        var action = component.get("c.fetchRecordTypeValues");
        action.setParams({
            "objectName" : "Phoenix_PHS_Price_Change__c"
        });
        action.setCallback(this, function(response) {
            var mapOfRecordTypes = response.getReturnValue();
            var selectedRecordTypeId = component.get("v.selectedRecordTypeId");
            //Creating recordTypeList from retrieved Map
            for(var key in mapOfRecordTypes){
                if(key == selectedRecordTypeId){
                    component.set("v.selectedRecordTypeName", mapOfRecordTypes[key]);
                }
            }
        });
        $A.enqueueAction(action);
        //this.getNPRData(component, event);
    },
     getBidInfoForValids: function (component, event, helper) {
        component.set('v.loaded', true);
        var action = component.get("c.getSubmitBidInfo");
        action.setParams({
            bidId: component.get("v.recordId")
        });
        action.setCallback(this, function (response) {
            if (response.getState() == "SUCCESS") {
                var resposneString = response.getReturnValue();
                console.log(resposneString);
                if (resposneString == 'Success') {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "message": "PHS Price Change is sent for approval.",
                        "type": "success",
                        "mode": "dismissible"
                    });
                    toastEvent.fire();
                    component.set('v.loaded', false);
                    component.find("navService").navigate({
                        type: "standard__recordPage",
                        attributes: {
                            recordId: component.get("v.recordId"),
                            actionName: "view"
                        }
                    }, false);
                } else {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": resposneString,
                        "type": "error",
                        "mode": "dismissible"
                    });
                    toastEvent.fire();
                    component.set('v.loaded', false);
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    getCustomSettingData: function(component, event){
        var action = component.get("c.getDataFromCustomSettings");
        action.setCallback(this, function(response){
            if(response.getState() == 'SUCCESS') {
                var resp=response.getReturnValue();
                for(var i=0; i<resp.PHSCustomData.length; i++){
                    if(resp.PHSCustomData[i].Name == 'PHSData01'){
                        component.set("v.ProvisionalRecordTypeId",  resp.PHSCustomData[i].Phoenix_Record_Type_Id__c);
                        component.set("v.AccountId", resp.PHSCustomData[i].Phoenix_Account_Id__c);
                    } else if(resp.PHSCustomData[i].Name == 'PHSData02'){
                        component.set("v.QuarterlyRecordTypeId",  resp.PHSCustomData[i].Phoenix_Record_Type_Id__c);
                        component.set("v.AccountId", resp.PHSCustomData[i].Phoenix_Account_Id__c);
                    } else{
                        component.set("v.ApexusContractId", resp.PHSCustomData[i].Phoenix_Apexus_Contract_Id__c);
                        console.log("Apexus Contract ID:: "+resp.PHSCustomData[i].Phoenix_Apexus_Contract_Id__c);
                    }
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    getPriceChangeLines: function(component, event){
        var action = component.get("c.getChangeLineQuarterly");
        action.setParams({
            "recordId" : component.get("v.recordId"),
            "apexusContractId": component.get("v.ApexusContractId")
        });
        action.setCallback(this, function(response) {
            if(response.getState()=="SUCCESS"){
                var resp = response.getReturnValue();
                var linesList = [];
                if(resp){
                    for(var i=0;i<resp.PHSLineData.length; i++){
                        var id = resp.PHSLineData[i].Phoenix_Product_Name__c;
                        /*if(resp.priceList[id] == undefined){
                            resp.PHSLineData[i].Price_in_Apexus_Sub_Ceiling_Contract__c = 0;
                        } else {
                            resp.PHSLineData[i].Price_in_Apexus_Sub_Ceiling_Contract__c = resp.priceList[id];   
                        }*/
                        var priceChangePercent = resp.PHSLineData[i].Phoenix_Change_in_Price__c;
                        resp.PHSLineData[i].ChangeInPrice = priceChangePercent/100;
                        linesList.push(resp.PHSLineData[i]);
                    }
                    component.set("v.linesList", linesList);
                      component.set("v.linesList1", linesList);
                    if(linesList.length > 0){
                        component.set('v.disableExportImportBtn', false);
                        component.set("v.disableEdit", true);   
                    } else{
                        component.set("v.disableEdit", false);
                        component.set('v.disableExportImportBtn', true);
                    }
                    if(linesList.length == 0){
                     	component.set("v.totalPages", 1);   
                    } else{
                        component.set("v.totalPages", Math.ceil(linesList.length/component.get("v.pageSize")));   
                    }
                    component.set("v.currentPageNumber",1);
                    this.buildData(component);
                    component.set("v.duplicateLinesList", linesList);
                    component.set("v.UnfilteredData", linesList); 
                    component.set("v.isSaved", true);  
                    component.set("v.isNewRowAdded", true);
                    component.set("v.disableSaveLines", true);
                    component.set("v.disableSubmit", true);
                }
            } else{
                console.log("Error "+JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);
        this.getProducts(component, event);
        this.handleUpload(component, event);
    },

    deletePHSLine: function(component, event){
      var action = component.get("c.deletePHSLine");
      var lineId = component.get("v.deletePHSLine");
        action.setParams({
            'recordId': lineId
        });
        action.setCallback(this, function(response) {
            if(response.getState()=="SUCCESS"){
                console.log('Successfully deleted');
                this.buildData(component, event);
            }
        });
        $A.enqueueAction(action);
    },
    
    getNPRData: function(component, event, helper) {
        var action = component.get("c.getNPRData");
        var selectedContract = component.get("v.selectedRecordId");
        action.setParams({
            "contractId": selectedContract,
            "apexusContractId": component.get("v.ApexusContractId")
        });
        action.setCallback(this, function(response) {
            if(response.getState()=="SUCCESS"){
                var linesList = [];
                var resp = response.getReturnValue();
                var recordTypeId = component.get("v.selectedRecordTypeId");
                var ProvisionalRecordTypeId = component.get("v.ProvisionalRecordTypeId");
                var QuarterlyRecordTypeId = component.get("v.QuarterlyRecordTypeId");
                for(var i=0; i<resp.products.length; i++){
                    if(recordTypeId == QuarterlyRecordTypeId){
                        var instance = {};
                        var id = resp.products[i].Phoenix_Product__c;
                        instance.Phoenix_Product_Name__c = resp.products[i].Phoenix_Product__c;
                        instance.Phoenix_PHS_Price_Change__c = component.get("v.recordId");
                        instance.ProductName__c = resp.products[i].Phoenix_Product__r.Name;
                        instance.Phoenix_Material_Code__c = resp.products[i].Phoenix_Product__r.ProductCode;
                        instance.Phoenix_NDC_11__c = resp.products[i].Phoenix_NDC_11__c;
                        instance.Phoenix_Old_PHS_Price__c = resp.products[i].Phoenix_Contract_Price__c;
                        instance.Phoenix_Last_90_days_PHS_Units__c = resp.products[i].Phoenix_SalesUnit_90__c;
                        if(resp.priceList[id] == undefined || resp.priceList[id] == null){
                            instance.Price_in_Apexus_Sub_Ceiling_Contract__c = '';
                        } else {
                         	instance.Price_in_Apexus_Sub_Ceiling_Contract__c = resp.priceList[id];   
                        }
                        linesList.push(instance);   
                    }   
                }
                component.set("v.linesList", linesList);
                component.set("v.duplicateLinesList", linesList);
                component.set("v.UnfilteredData", linesList);
                if(linesList.length > 0){
                    component.set("v.disableEdit", true);   
                    component.set("v.totalPages", Math.ceil(linesList.length/component.get("v.pageSize")));
                } else{
                    component.set("v.disableEdit", false);
                    component.set("v.totalPages", 1);
                }
                component.set("v.currentPageNumber",1);
                this.buildData(component);
            } else{
                console.log("Error "+JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);
        this.getProducts(component, event);
    },
    handleUpload: function(component, event){
        var action = component.get("c.getDocs");
        action.setParams({
            "recordId": component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var fileList=[];
                var totalFiles=[];
                var checked=false;
                totalFiles=response.getReturnValue();
                if(totalFiles!=undefined&&totalFiles!=null && totalFiles!='')
                {
                    for(var i=0;i<totalFiles.length;i++)
                    {
                        fileList.push({"Id":totalFiles[i].ContentDocumentId,"Title":totalFiles[i].ContentDocument.Title+'.'+totalFiles[i].ContentDocument.FileExtension,"checked":checked});
                    }
                }
                component.set("v.fileList",fileList);
            }  
            if(state === "ERROR"){
                // component.set("v.isTSNotCreated","true");
            } 
            
        });
        $A.enqueueAction(action);
    },
    
    getProducts: function(component, event){
    	var action = component.get("c.getProducts");
        action.setParams({
            'selectedProducts': component.get("v.listOfSelectedProducts") 
        });
        action.setCallback(this, function(response) {
            if(response.getState()=="SUCCESS"){
                var resp = response.getReturnValue();
                component.set("v.productList", resp);
            }
        });
        $A.enqueueAction(action);
    },
    
    convertArrayOfObjectsToCSV: function (component, objectRecords) {
        // declare variables
        var csvStringResult, counter, keys, columnDivider, lineDivider;
        // check if "objectRecords" parameter is null, then return from function
        if (objectRecords == null || !objectRecords.length) {
            return null;
        }
        // store ,[comma] in columnDivider variabel for sparate CSV values and 
        // for start next line use '\n' [new line] in lineDivider varaible  
        columnDivider = ',';
        lineDivider = '\n';

        // in the keys valirable store fields API Names as a key 
        // this labels use in CSV file header 
        csvStringResult = '';
        var myMap = new Map();
        myMap.set("PHS Line Id", "Id");
       	myMap.set("Product Name", "ProductName__c");
        myMap.set("Material Code", "Phoenix_Material_Code__c");
        myMap.set("NDC-11", "Phoenix_NDC_11__c");
        myMap.set("Old PHS Price $", "Phoenix_Old_PHS_Price__c");
        myMap.set("New PHS Price $", "Phoenix_New_PHS_Price__c");
        myMap.set("% Change in Price", "Phoenix_Change_in_Price__c");
        myMap.set("Last 90days PHS Units", "Phoenix_Last_90_days_PHS_Units__c");
        myMap.set("Sales Difference $", "Phoenix_Sales_Difference__c");
        myMap.set("Price in Apexus Sub-Ceiling Contract", "Price_in_Apexus_Sub_Ceiling_Contract__c");
        myMap.set("Diff in Apexus Sub-Ceiling Price", "Phoenix_Diff_in_Apexus_Sub_Ceiling_Price__c");
        myMap.set("Apexus Sub-Ceiling Price Change Required", "Apexus_Sub_Ceiling_Price_Change_Required__c");
        myMap.set("Remarks", "Phoenix_Remarks__c");
        csvStringResult += Array.from(myMap.keys()).join(columnDivider);
        csvStringResult += lineDivider;
        
        //new logic start 
        for (var i = 0; i < objectRecords.length; i++) {
            counter = 0;
            for (let [key, value] of myMap) {
                if (counter > 0) {
                    csvStringResult += columnDivider;
                }
                if (objectRecords[i][value] == undefined) {
                    csvStringResult += '"' + '' + '"';
                } else {
                    var stringValue = '"'+objectRecords[i][value]+'"';
                    if(stringValue.indexOf(',') == -1){
                     	csvStringResult += stringValue;   
                    } else{
                        var newVal = stringValue.replace(/,/g, '');
                        csvStringResult += newVal;
                    }
                }
                counter++;
            }
            csvStringResult += lineDivider;
        }
        return csvStringResult;
    },
    sortBy: function(component, field) {
        var sortAsc = component.get("v.sortAsc"),
            sortField = component.get("v.sortField"),
            records = component.get("v.linesList");
        sortAsc = field == sortField? !sortAsc: true;
        records.sort(function(a,b){
            var t1 = a[field] == b[field],
                t2 = (!a[field] && b[field]) || (a[field] < b[field]);
                //t2 = a[field] > b[field];
            return t1? 0: (sortAsc?-1:1)*(t2?-1:1);
        });
        if(sortAsc == true){
            component.set("v.arrowDirection", 'arrowup');
        } else {
            component.set("v.arrowDirection", 'arrowdown');
        }
        component.set("v.sortAsc", sortAsc);
        component.set("v.sortField", field);
        component.set("v.linesList", records);
        this.buildData(component, event);
    },

    
    createPaginationForSearchData: function(component, event){
        component.set("v.totalSize", component.get("v.UnfilteredData").length);
        var totalSize = component.get("v.totalSize");
        if(totalSize > 10){
            component.set("v.pageSize", 10);
        } else{
            component.set("v.pageSize", totalSize);
        }
        var pageSize = component.get("v.pageSize");
        component.set("v.start",0);
        component.set("v.end",pageSize-1);
        var UnfilteredData = component.get("v.UnfilteredData");
        var paginationList = [];
        for(var i=0; i< pageSize; i++)   
        {
            paginationList.push(UnfilteredData[i]);   
        }
        component.set("v.paginationList", paginationList);
    },
    
    
    searchTableRecords: function(component, event){
        var searchText = component.get("v.searchText");
        var searchFilter = searchText.split(" ");
        var allRecords = component.get("v.UnfilteredData");
        var filteredData = [];
        var i;
        component.set("v.filteredData", []);
        if(searchText != null || searchText != '' || searchText != undefined){
            for(var k=0; k<allRecords.length; k++){
                if((allRecords[k].ProductName__c && allRecords[k].ProductName__c.toUpperCase().indexOf(searchText.toUpperCase()) != -1)){
                    filteredData.push(allRecords[k]);
                }
            }
            if(filteredData.length == 0){
                for(var j=0; j<searchFilter.length; j++){
                    if(searchFilter[j] != null || searchFilter[j] != '' || searchFilter[j] != undefined){
                        for(i=0; i < allRecords.length; i++){
                            if((allRecords[i].Phoenix_Material_Code__c && allRecords[i].Phoenix_Material_Code__c.indexOf(searchFilter[j]) != -1 ) || 
                               (allRecords[i].Phoenix_NDC_11__c && allRecords[i].Phoenix_NDC_11__c.indexOf(searchFilter[j]) != -1 ) )
                            {
                                if(!filteredData.includes(allRecords[i])){
                                 	filteredData.push(allRecords[i]);   
                                }
                            }    
                            
                        }
                    }  
                }        
            }
        }
        
        component.set("v.linesList", filteredData);
        if(searchFilter == ''){
            // set unfiltered data to data in the table.  
            component.set("v.pageSize", 10);
            component.set("v.linesList",component.get("v.UnfilteredData"));
            component.set("v.totalPages", Math.ceil(component.get("v.linesList").length/component.get("v.pageSize")));
            component.set("v.currentPageNumber",1);
            component.set("v.searchResults", []);
            component.set("v.filteredData", []);
            component.set("v.saveSpinnerLoad", false);
            this.buildData(component, event);
        } else{
            if(filteredData.length < 10){
                component.set("v.pageSize", filteredData.length);
            }
            if(filteredData.length == 0){
             	component.set("v.totalPages", 1);   
            } else{
                component.set("v.totalPages", Math.ceil(filteredData.length/component.get("v.pageSize")));
            }
            component.set("v.currentPageNumber",1);
            component.set("v.saveSpinnerLoad", false);
            this.buildData(component);
            //component.set("v.filteredData",tempArray);   
        }
    },
    
    
    FilterRecords: function(component) {  
        //data showing in table  
        var data = component.get("v.linesList");  
        // all data featched from apex when component loaded  
        var allData = data;  
        //Search tems  
        var searchKey = component.get("v.filter");  
        // check is data is not undefined and its lenght is greater than 0  
        if(data!=undefined || data.length>0){  
            // filter method create a new array tha pass the test (provided as function)  
            var filtereddata = allData.filter(word => (!searchKey) || word.ProductName__c.toUpperCase().indexOf(searchKey.toUpperCase()) > -1);
            if(filtereddata == null || filtereddata == '' || filtereddata.length == 0){
                filtereddata = allData.filter(word => (!searchKey) || word.Phoenix_Material_Code__c.indexOf(searchKey) > -1);
                /*if(filtereddata == null || filtereddata == '' || filtereddata.length == 0){
                    console.log('Filtered Data:::Inner '+JSON.stringify(filtereddata));
                	filtereddata = allData.filter(word => (!searchKey) || word.Phoenix_NDC_11__c.indexOf(searchKey) > -1);    
                }*/
            }
        }  
        // set new filtered array value to data showing in the table.  
        component.set("v.linesList", filtereddata);
        // check if searchKey is blank  
        if(searchKey==''){  
            // set unfiltered data to data in the table.  
            component.set("v.pageSize", 10);
            component.set("v.linesList",component.get("v.UnfilteredData"));
            component.set("v.totalPages", Math.ceil(component.get("v.linesList").length/component.get("v.pageSize")));
            component.set("v.currentPageNumber",1);
            this.buildData(component, event);
        } else{
            if(filtereddata.length < 10){
                component.set("v.pageSize", filtereddata.length);
            }
            component.set("v.totalPages", Math.ceil(filtereddata.length/component.get("v.pageSize")));
            component.set("v.currentPageNumber",1);
            this.buildData(component);
        }  
    },
    
    showSuccessToast : function(component, event, message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Success!',
            message: message,
            duration:' 5000',
            key: 'info_alt',
            type: 'success'
        });
        toastEvent.fire();
    },

    showErrorToast : function(component, event, message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Warning!',
            message: message,
            duration:' 5000',
            key: 'info_alt',
            type: 'error'
        });
        toastEvent.fire();
    },  
    
    savePriceChangeLine: function(component, event){
        var action = component.get("c.savePriceChangeLine");
        var linesList = component.get("v.linesList");
        console.log('Count of records before saving:: '+linesList.length);
        action.setParams({
            "recordId": component.get("v.recordId"),
            "linesList": component.get("v.linesList")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state == "SUCCESS") {
                component.set("v.isNewRowAdded", true);
                component.set("v.disableSaveLines", true);
                component.set("v.disableSubmit", true);
                component.set("v.disableExportImportBtn", false);
                component.set("v.saveSpinnerLoad", false);
                component.set("v.loaded", false);
                var resp = response.getReturnValue();
                var linesList = [];
                try{
                    for(var i=0; i<resp.length;i++){
                        resp[i].ProductName__c = resp[i].Phoenix_Product_Name__r.Name;
                        var changeInPricePercent = resp[i].Phoenix_Change_in_Price__c;
                        resp[i].ChangeInPrice = changeInPricePercent/100;
                        linesList.push(resp[i]);
                    }   
                }catch(e){
                    console.log('Error: '+e);
                }
                component.set("v.linesList", linesList);
                 component.set("v.linesList1", linesList);
                console.log('Count of records after saving:: '+linesList.length);
                component.set("v.duplicateLinesList", linesList);
                component.set("v.UnfilteredData", linesList); 
                if(linesList.length > 10){
                    component.set("v.pageSize", 10);
                } else{
                    component.set("v.pageSize", linesList.length);
                }
                component.set("v.totalPages", Math.ceil(component.get("v.linesList").length/component.get("v.pageSize")));
                this.buildData(component, event);
                var message = 'PHS Change lines created';
                this.showSuccessToast(component, event, message);
            } else{
                console.log("Error "+JSON.stringify(response.getError()));
            }
        });
        // enqueue the server side action  
        $A.enqueueAction(action); 
    },
    
    
    //pagination code
    buildData : function(component) {
        var data = [];
        var pageNumber = component.get("v.currentPageNumber");
        var pageSize = component.get("v.pageSize");
        var allData = component.get("v.linesList");
        var x = (pageNumber-1)*pageSize;
        
        //creating data-table data
        for(; x<(pageNumber)*pageSize; x++){
            if(allData[x]){
            	data.push(allData[x]);
            }
        }
        component.set("v.data", data);
        
        this.generatePageList(component, pageNumber);
    },
    
    /*
     * this function generate page list
     * */
    generatePageList : function(component, pageNumber){
        pageNumber = parseInt(pageNumber);
        var pageList = [];
        var totalPages = component.get("v.totalPages");
        if(totalPages > 1){
            if(totalPages <= 10){
                var counter = 2;
                for(; counter < (totalPages); counter++){
                    pageList.push(counter);
                } 
            } else{
                if(pageNumber < 5){
                    pageList.push(2, 3, 4, 5, 6);
                } else{
                    if(pageNumber>(totalPages-5)){
                        pageList.push(totalPages-5, totalPages-4, totalPages-3, totalPages-2, totalPages-1);
                    } else{
                        pageList.push(pageNumber-2, pageNumber-1, pageNumber, pageNumber+1, pageNumber+2);
                    }
                }
            }
        }
        component.set("v.pageList", pageList);
    },
    addRow: function(component, event){
        var linesList = component.get("v.linesList");
        var productList = component.get("v.productList");
        var listOfSelectedProducts = [];
        var updatedProductsList = [];
        for(var i=0; i<linesList.length; i++){
            listOfSelectedProducts.push(linesList[i].Phoenix_Product_Name__c);
        }
        component.set("v.listOfSelectedProducts", listOfSelectedProducts);
        var action = component.get("c.getProducts");
        action.setParams({
            'selectedProducts': component.get("v.listOfSelectedProducts") 
        });
        action.setCallback(this, function(response) {
            if(response.getState()=="SUCCESS"){
                var resp = response.getReturnValue();
                component.set("v.productList", resp);
                this.addRowWithUpdatedProducts(component, event);
            }
        });
        $A.enqueueAction(action);
    },
    addRowWithUpdatedProducts: function(component, event){
        var linesList = component.get("v.linesList");
        linesList.push({
            'sobjectType': 'Phoenix_PHS_Price_Change_Line__c',
            'Phoenix_Product_Name__c': '',
            'ProductName__c': '',
            'Phoenix_PHS_Price_Change__c': component.get("v.recordId"),
            'Phoenix_Material_Code__c': '',
            'ChangeInPrice': '',
            'Phoenix_NDC_11__c': '',
            'Phoenix_Provisional_PHS_Price__c': '',
            'Phoenix_Price_Start_Date__c': '',
            'Phoenix_Price_End_Date__c': '',
            'Phoenix_Old_PHS_Price__c': '',
            'Phoenix_New_PHS_Price__c': '',
            'Phoenix_Change_in_Price__c': '',
            'Phoenix_Last_90_days_PHS_Units__c': '',
            'Phoenix_Sales_Difference__c': '',
            'Price_in_Apexus_Sub_Ceiling_Contract__c': '',
            'Phoenix_Diff_in_Apexus_Sub_Ceiling_Price__c': '',
            'Apexus_Sub_Ceiling_Price_Change_Required__c':'',
            'Phoenix_Remarks__c': ''
        });  
        component.set("v.linesList", linesList);
        component.set("v.duplicateLinesList", linesList);
        component.set("v.disableEdit", true);
        var isAllRecordsSaved = '';
        for(var i=0; i<linesList.length; i++){
            if(linesList[i].Id == null || linesList[i].Id == '' || linesList[i].Id == undefined){
                isAllRecordsSaved = false;
            } else{
                isAllRecordsSaved = true;
            }
        }
        if(isAllRecordsSaved == true){
         	component.set("v.isNewRowAdded", true);   
        } else{
            component.set("v.isNewRowAdded", false);
        }
    }
})