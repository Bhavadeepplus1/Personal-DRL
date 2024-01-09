({
	/*loadInstance : function(component, event) {
		var recordId = component.get("v.recordId");
        var action = component.get("c.getWACChangeInfo");
        action.setParams({
            'recordId': recordId
        });
        action.setCallback(this, function(response){
            if(response.getState()=="SUCCESS"){
                var resp = response.getReturnValue();
                component.set("v.Name", resp[0].Phoenix_WAC_Change_Name__c);
                component.set("v.Date", resp[0].Phoenix_Effective_Date__c);
                component.set("v.ProductFamily", resp[0].Phoenix_Product_Family__c);
                component.set("v.Summary", resp[0].Phoenix_Summary__c);
                component.set("v.ApprovalStatus", resp[0].Phoenix_Approval_Status__c);
                component.set("v.SalesIncrease", resp[0].Phoenix_Sales_Increase__c);
                component.set("v.TotalNetBenefit", resp[0].Phoenix_Total_Net_Benefit__c);
                component.set("v.PHSHit", resp[0].Phoenix_PHS_hit__c);
                component.set("v.MedicaidRelease", resp[0].Phoenix_Medicaid_release__c);
                component.set("v.WorkingCapitalBenefit", resp[0].Working_capital_benefit__c);
                component.set("v.WACFinanceImpact", resp[0].Phoenix_WAC_finance_impact__c);
                this.getWACLineItems(component, event);
                this.getRelatedList(component, event);
            } else{
                console.log("Error "+JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);
	},*/
    
    loadInstance: function(component, event){
        var action = component.get("c.getRelatedList");
        action.setParams({
            'recordId': component.get("v.recordId")
        });
        action.setCallback(this, function(response){
            if(response.getState() == 'SUCCESS'){
                var wrapperResponse = response.getReturnValue();
                console.log('Wrapper response:: '+JSON.stringify(wrapperResponse));
                var bidRecord = wrapperResponse.bidRecord;
                component.set("v.Name", bidRecord.Phoenix_WAC_Change_Name__c);
                component.set("v.Date", bidRecord.Phoenix_Effective_Date__c);
                component.set("v.ProductFamily", bidRecord.Product_Family__c);
                component.set("v.SelectedProductFamilyName", bidRecord.Phoenix_Product_Family__c);
                component.set("v.Summary", bidRecord.Phoenix_Summary__c);
                component.set("v.ApprovalStatus", bidRecord.Phoenix_Approval_Status__c);
                component.set("v.SalesIncrease", bidRecord.Phoenix_Sales_Increase__c);
                component.set("v.TotalNetBenefit", bidRecord.Phoenix_Total_Net_Benefit__c);
                component.set("v.PHSHit", bidRecord.Phoenix_PHS_hit__c);
                component.set("v.MedicaidRelease", bidRecord.Phoenix_Medicaid_release__c);
                component.set("v.WorkingCapitalBenefit", bidRecord.Working_capital_benefit__c);
                component.set("v.WACFinanceImpact", bidRecord.Phoenix_WAC_finance_impact__c);
                this.handleUpload(component, event);
                component.set("v.loaded", false);
                var resp = wrapperResponse.lineItemsList;
                var ProductFamily = component.get("v.ProductFamily");
                var SelectedProductFamilyName = component.get("v.SelectedProductFamilyName");
                var data = [];
                for(var i=0; i<resp.length; i++){
                    if(resp[i].Phoenix_NPR__c){
                        if(resp[i].Phoenix_Product__c == null || resp[i].Phoenix_Product__c == undefined || resp[i].Phoenix_Product__c == ''){
                            resp[i].Phoenix_Product_Name__c = '';
                            resp[i].Phoenix_Product__c = '';
                            resp[i].Phoenix_Product_Family__c = '';
                            resp[i].isProductFamilyMatched = ''
                        } else{
                            resp[i].Phoenix_Product_Name__c = resp[i].Phoenix_Product__r.Name;
                            resp[i].Phoenix_Product__c = resp[i].Phoenix_Product__c;
                            //resp[i].Product_Family__c = ProductFamily;
                            //resp[i].Phoenix_Product_Family__c = SelectedProductFamilyName;
                            if(resp[i].Phoenix_Product_Family__c == SelectedProductFamilyName){
                                resp[i].isProductFamilyMatched = true;
                            } else{
                                resp[i].isProductFamilyMatched = false;
                            }
                        }
                        if(resp[i].Phoenix_Account__c == null || resp[i].Phoenix_Account__c == undefined || resp[i].Phoenix_Account__c == ''){
                            resp[i].Phoenix_Account_Name__c = '';
                            resp[i].Phoenix_Account__c = '';
                        } else{
                            resp[i].Phoenix_Account_Name__c = resp[i].Phoenix_Account__r.Name;
                            resp[i].Phoenix_Account__c = resp[i].Phoenix_Account__c;
                        }
                        resp[i].Phoenix_NPR_Name__c = resp[i].Phoenix_NPR__r.Name;
                        resp[i].Id = resp[i].Id;
                        data.push(resp[i]);   
                    } else{
                        resp[i].Phoenix_Product_Name__c = '';
                        resp[i].Phoenix_Account_Name__c = '';
                        resp[i].Phoenix_NPR_Name__c = '';
                        resp[i].isProductFamilyMatched = '';
                        resp[i].Phoenix_Product_Family__c = '';
                        resp[i].Id = resp[i].Id;
                        data.push(resp[i]);
                    }
                }
                if(data.length > 0){
                    component.set("v.disableExportImportBtn", false);
                }
                if(data.length == 0){
                    component.set("v.disableImport", false);
                }
                component.set("v.wacData", data);
                component.set("v.data", data);
                if(data.length == 0){
                    component.set("v.totalPages", 1);
                } else{
                    component.set("v.totalPages", Math.ceil(data.length/component.get("v.pageSize")));
                    component.set("v.disableSubmit", true);
                }
                component.set("v.currentPageNumber",1);
                this.buildData(component);
                component.set("v.UnfilteredData", data);
                component.set("v.showLineItems", true);
                component.set("v.noMatchRecords", false);
            } else{
                console.log("Error "+JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);
    },
    
   /* getWACLineItems: function(component, event){
        var action = component.get("c.getWACLineItemsList");
        action.setParams({
            'recordId': component.get("v.recordId")
        });
        action.setCallback(this, function(response){
            if(response.getState() == 'SUCCESS'){
                this.handleUpload(component, event);
                component.set("v.loaded", false);
                var resp = response.getReturnValue();
                var ProductFamily = component.get("v.ProductFamily");
                var data = [];
                for(var i=0; i<resp.length; i++){
                    if(resp[i].Phoenix_NPR__c){
                        if(resp[i].Phoenix_Product__c == null || resp[i].Phoenix_Product__c == undefined || resp[i].Phoenix_Product__c == ''){
                            resp[i].Phoenix_Product_Name__c = '';
                            resp[i].Phoenix_Product__c = '';
                            resp[i].Phoenix_Product_Family__c = '';
                            resp[i].isProductFamilyMatched = ''
                        } else{
                            resp[i].Phoenix_Product_Name__c = resp[i].Phoenix_Product__r.Name;
                            resp[i].Phoenix_Product__c = resp[i].Phoenix_Product__c;
                            if(resp[i].Phoenix_Product_Family__c == ProductFamily){
                                resp[i].isProductFamilyMatched = true;
                            } else{
                                resp[i].isProductFamilyMatched = false;
                            }
                        }
                        if(resp[i].Phoenix_Account__c == null || resp[i].Phoenix_Account__c == undefined || resp[i].Phoenix_Account__c == ''){
                            resp[i].Phoenix_Account_Name__c = '';
                            resp[i].Phoenix_Account__c = '';
                        } else{
                            resp[i].Phoenix_Account_Name__c = resp[i].Phoenix_Account__r.Name;
                            resp[i].Phoenix_Account__c = resp[i].Phoenix_Account__c;
                        }
                        resp[i].Phoenix_NPR_Name__c = resp[i].Phoenix_NPR__r.Name;
                        resp[i].Id = resp[i].Id;
                        data.push(resp[i]);   
                    } else{
                        resp[i].Phoenix_Product_Name__c = '';
                        resp[i].Phoenix_Account_Name__c = '';
                        resp[i].Phoenix_NPR_Name__c = '';
                        resp[i].isProductFamilyMatched = '';
                        resp[i].Phoenix_Product_Family__c = '';
                        resp[i].Id = resp[i].Id;
                        data.push(resp[i]);
                    }
                }
                if(data.length > 0){
                    component.set("v.disableExportImportBtn", false);
                }
                if(data.length == 0){
                    component.set("v.disableImport", false);
                }
                component.set("v.wacData", data);
                component.set("v.data", data);
                if(data.length == 0){
                    component.set("v.totalPages", 1);
                } else{
                    component.set("v.totalPages", Math.ceil(data.length/component.get("v.pageSize")));
                    component.set("v.disableSubmit", true);
                }
                component.set("v.currentPageNumber",1);
                this.buildData(component);
                component.set("v.UnfilteredData", data);
                component.set("v.showLineItems", true);
                component.set("v.noMatchRecords", false);
            } else{
                console.log("Error "+JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);
    },*/
    
    getWACChangeData: function(component, event){
        var action = component.get("c.getWACChangeInfo");
        action.setParams({
            'recordId': component.get("v.recordId")
        });
        action.setCallback(this, function(response){
            if(response.getState() == 'SUCCESS'){
                var resp = response.getReturnValue();
                component.set("v.TotalNetBenefit", resp[0].Phoenix_Total_Net_Benefit__c);
            }
        });
        $A.enqueueAction(action);
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
            } else{
                console.log("Error "+JSON.stringify(response.getError()));
            } 
            
        });
        $A.enqueueAction(action);
    },
    
    getNPRData: function(component, event){
        var action = component.get("c.getNPRData");
        var Material_ContractsList = component.get("v.Material_ContractsList");
        action.setParams({
            'Material_ContractsList': Material_ContractsList
        });
        action.setCallback(this, function(response){
            if(response.getState()=="SUCCESS"){
                var resp = response.getReturnValue();
                var wacData = component.get("v.wacData");
                var ProductFamily = component.get("v.ProductFamily");
                var SelectedProductFamilyName = component.get("v.SelectedProductFamilyName");
                var updatedWACData = [];
                for(var i=0; i<wacData.length; i++){
                    var prodInfo = wacData[i].Mat_Contract_Ref;
                    var respInstance = resp[prodInfo];
                    //console.log('Resp Instance: '+JSON.stringify(respInstance));
                    if(respInstance){
                        if(respInstance.Phoenix_Product__c == null || respInstance.Phoenix_Product__c == undefined || respInstance.Phoenix_Product__c == ''){
                            wacData[i].Phoenix_Product__c = '';
                            wacData[i].Phoenix_Product_Name__c = '';   
                            wacData[i].Phoenix_Product_Family__c = '';
                            wacData[i].isProductFamilyMatched = '';
                        } else{
                            wacData[i].Phoenix_Product__c = respInstance.Phoenix_Product__c;
                            wacData[i].Phoenix_Product_Name__c = respInstance.Phoenix_Product__r.Name;  
                            if(respInstance.Phoenix_Product__r){
                                if(respInstance.Phoenix_Product__r.hasOwnProperty('Product_Family__r')){
                                    wacData[i].Phoenix_Product_Family__c = respInstance.Phoenix_Product__r.Product_Family__r.Name;        
                                } else{
                                    wacData[i].Phoenix_Product_Family__c = '';   
                                }
                            }
                            wacData[i].Product_Family__c = respInstance.Phoenix_Product__r.Product_Family__c;
                            if(respInstance.Phoenix_Product__r.Family == SelectedProductFamilyName){
                                wacData[i].isProductFamilyMatched = true;
                            } else{
                                wacData[i].isProductFamilyMatched = false;
                            }
                        }
                        if(respInstance.Phoenix_Account__c == null || respInstance.Phoenix_Account__c == undefined ||
                           respInstance.Phoenix_Account__c == ''){
                            wacData[i].Phoenix_Account__c = '';
                            wacData[i].Phoenix_Account_Name__c = ''; 
                        } 
                        else{
                            wacData[i].Phoenix_Account__c = respInstance.Phoenix_Account__c;
                            wacData[i].Phoenix_Account_Name__c = respInstance.Phoenix_Account__r.Name;                           
                        }
                        wacData[i].Phoenix_NPR__c = respInstance.Id;
                        wacData[i].Phoenix_NPR_Name__c = respInstance.Name;
                        wacData[i].Phoenix_System_WAC__c = respInstance.Phoenix_WAC__c;
                        wacData[i].Phoenix_System_Contract_price__c = respInstance.Phoenix_Contract_Price__c;
                        wacData[i].Phoenix_Cust_Name__c = respInstance.Phoenix_NPR_Customer_Name__c;
                        wacData[i].Phoenix_WAC_Change__c = component.get("v.recordId");
                        var oldWAC = respInstance.Phoenix_WAC__c;
                        var uploadedWAC = wacData[i].Phoenix_Uploaded_WAC__c;
                        var oldContractPrice = respInstance.Phoenix_Contract_Price__c;
                        var uploadedContractPrice = wacData[i].Phoenix_Uploaded_Contr_Price__c;
                        var proposedWAC = wacData[i].Phoenix_Proposed_WAC__c;
                        var proposedContractPrice = wacData[i].Phoenix_Proposed_Contr_Price__c;
                        var WACDiff = oldWAC-uploadedWAC;
                        var SysWACVsProposedWAC = oldWAC-proposedWAC;
                        var SysContractPriceVsProposedContractPrice = oldContractPrice - proposedContractPrice;
                        var ContractPriceDiff = oldContractPrice-uploadedContractPrice;
                        wacData[i].Phoenix_SysWAC_Vs_UploadedWAC__c = WACDiff;
                        wacData[i].Phoenix_SysContPrice_Vs_UploadContrPrice__c = ContractPriceDiff;
                        wacData[i].Phoenix_Sys_WAC_Vs_Proposed_WAC__c = SysWACVsProposedWAC;
                        wacData[i].Phoenix_SysContrPrice_Vs_PropContrPrice__c = SysContractPriceVsProposedContractPrice;
                        updatedWACData.push(wacData[i]);
                    } else{
                        wacData[i].Phoenix_Product__c = '';
                        wacData[i].Phoenix_Product_Name__c = '';
                        wacData[i].Phoenix_Account__c = '';
                        wacData[i].Phoenix_Account_Name__c = '';
                        wacData[i].Phoenix_NPR__c = '';
                        wacData[i].Phoenix_NPR_Name__c = '';
                        wacData[i].Phoenix_System_WAC__c = '';
                        wacData[i].Phoenix_System_Contract_price__c = '';
                        wacData[i].Phoenix_SysWAC_Vs_UploadedWAC__c = '';
                        wacData[i].Phoenix_SysContPrice_Vs_UploadContrPrice__c = '';
                        wacData[i].Phoenix_WAC_Change__c = component.get("v.recordId");
                        wacData[i].ProductFamily = '';
                        wacData[i].isProductFamilyMatched = '';
                        updatedWACData.push(wacData[i]); 
                    }
                }
                component.set("v.wacData", updatedWACData);
                component.set("v.UnfilteredData", updatedWACData);
                component.set("v.loaded", false);
                component.set("v.totalPages", Math.ceil(updatedWACData.length/component.get("v.pageSize")));
                component.set("v.currentPageNumber",1);
                this.buildData(component);
            } else{
                console.log("Error "+JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);
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
    
    sortBy: function(component, field) {
        var sortAsc = component.get("v.sortAsc"),
            sortField = component.get("v.sortField"),
            records = component.get("v.wacData");
        sortAsc = field == sortField? !sortAsc: true;
        records.sort(function(a,b){
            var t1 = a[field] == b[field],
                t2 = (!a[field] && b[field]) || (a[field] < b[field]);
            return t1? 0: (sortAsc?-1:1)*(t2?-1:1);
        });
        if(sortAsc == true){
            component.set("v.arrowDirection", 'arrowup');
        } else {
            component.set("v.arrowDirection", 'arrowdown');
        }
        component.set("v.sortAsc", sortAsc);
        component.set("v.sortField", field);
        component.set("v.wacData", records);
        this.buildData(component, event);
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
                if((allRecords[k].Phoenix_Product_Name__c && allRecords[k].Phoenix_Product_Name__c.toUpperCase().indexOf(searchText.toUpperCase()) != -1) ||
                  (allRecords[k].Phoenix_Cust_Name__c && allRecords[k].Phoenix_Cust_Name__c.toUpperCase().indexOf(searchText.toUpperCase()) != -1)){
                    filteredData.push(allRecords[k]);
                }
            }
            if(filteredData.length == 0){
                for(var j=0; j<searchFilter.length; j++){
                    if(searchFilter[j] != null || searchFilter[j] != '' || searchFilter[j] != undefined){
                        for(i=0; i < allRecords.length; i++){
                            if((allRecords[i].Phoenix_Matl_No__c && allRecords[i].Phoenix_Matl_No__c.indexOf(searchFilter[j]) != -1 ) ||
                               (allRecords[i].Phoenix_Cust_Number__c && allRecords[i].Phoenix_Cust_Number__c.indexOf(searchFilter[j]) != -1 ) ||
                               (allRecords[i].Phoenix_Contr_Number__c && allRecords[i].Phoenix_Contr_Number__c.indexOf(searchFilter[j]) != -1 ) ||
                               (allRecords[i].Phoenix_NDC11__c && allRecords[i].Phoenix_NDC11__c.indexOf(searchFilter[j]) != -1 ) )
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
        
        component.set("v.wacData", filteredData);
        if(searchFilter == ''){
            // set unfiltered data to data in the table.  
            component.set("v.pageSize", 10);
            component.set("v.wacData",component.get("v.UnfilteredData"));
            component.set("v.totalPages", Math.ceil(component.get("v.wacData").length/component.get("v.pageSize")));
            component.set("v.currentPageNumber",1);
            component.set("v.searchResults", []);
            component.set("v.filteredData", []);
            component.set("v.saveSpinnerLoad", false);
            this.buildData(component, event);
        } else{
            if(filteredData.length < 10){
                component.set("v.pageSize", filteredData.length);
            }
            component.set("v.totalPages", Math.ceil(filteredData.length/component.get("v.pageSize")));
            component.set("v.currentPageNumber",1);
            component.set("v.saveSpinnerLoad", false);
            this.buildData(component);   
        }
    },
    deleteLines: function(component, event){
        var action = component.get("c.deleteWACLineItems");
        action.setParams({
            'recordIds': component.get("v.itemsToBeDeletedFromDB")
        });
        action.setCallback(this, function(response){
            if(response.getState()=="SUCCESS"){
                component.set("v.loaded", false);
                component.set("v.disableImport", false);
                var resp = response.getReturnValue();
                component.set("v.wacData", []);
                component.set("v.UnfilteredData", []);
                component.set("v.data", []);
                component.set("v.disableExportImportBtn", true);
                var message = 'Line items deleted';
                this.showSuccessToast(component, event, message);
            } else{
                console.log("Error "+JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);
    },

    //pagination code
    buildData : function(component) {
        var data = [];
        var pageNumber = component.get("v.currentPageNumber");
        var pageSize = component.get("v.pageSize");
        var allData = component.get("v.wacData");
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
        myMap.set("Contr.Number", "Phoenix_Contr_Number__c");
        myMap.set("Contr.IntDesc", "Phoenix_Contr_IntDesc__c");
        myMap.set("Cust Name", "Phoenix_Cust_Name__c");
        myMap.set("Matl No", "Phoenix_Matl_No__c");
        myMap.set("Product", "Phoenix_Product_Name__c");
        myMap.set("Cust Number", "Phoenix_Cust_Number__c");
        myMap.set("Description", "Phoenix_Description__c");
        myMap.set("Product Family", "Phoenix_Product_Family__c");
        myMap.set("NDC11", "Phoenix_NDC11__c");
        myMap.set("Account Name", "Phoenix_Account_Name__c");
        myMap.set("NPR", "Phoenix_NPR_Name__c");
        myMap.set("System WAC", "Phoenix_System_WAC__c");
        myMap.set("System Contract price", "Phoenix_System_Contract_price__c");
        myMap.set("Uploaded WAC", "Phoenix_Uploaded_WAC__c");
        myMap.set("Uploaded Contr.Price", "Phoenix_Uploaded_Contr_Price__c");
        myMap.set("Sys WAC Vs Uploaded WAC", "Phoenix_SysWAC_Vs_UploadedWAC__c");
        myMap.set("Sys Contr.Price Vs Uploaded Contr.Price", "Phoenix_SysContPrice_Vs_UploadContrPrice__c");
        myMap.set("Proposed WAC", "Phoenix_Proposed_WAC__c");
        myMap.set("Proposed Contr.Price", "Phoenix_Proposed_Contr_Price__c");
        myMap.set("Sys WAC Vs Proposed WAC", "Phoenix_Sys_WAC_Vs_Proposed_WAC__c");
        myMap.set("Sys Contr.Price Vs Proposed Contr.Price", "Phoenix_SysContrPrice_Vs_PropContrPrice__c");
        myMap.set("Comments", "Phoenix_Comments__c");
        myMap.set("Contracts Comments", "Phoenix_Contracts_Comments__c");
        myMap.set("Offer Letter Sent", "Phoenix_Offer_Letter_Sent__c");
        myMap.set("Date Offer Sent", "Phoenix_Date_Offer_Sent__c");
        myMap.set("Customer Response Date", "Phoenix_Customer_Response_Date__c");
        myMap.set("Customer Response Status", "Phoenix_Customer_Update_Approval__c");
        myMap.set("Date Posted in Vistex", "Phoenix_Date_Posted_in_Vistex__c");
        myMap.set("Vistex Remarks", "Phoenix_Vistex_Remarks__c");
        myMap.set("WAC Change Line Number", "Name");
        csvStringResult += Array.from(myMap.keys()).join(columnDivider);
        csvStringResult += lineDivider;
        for(var i=0; i < objectRecords.length; i++){  
            counter = 0;
            for (let [key, value] of myMap) {
                if(counter > 0){ 
                    csvStringResult += columnDivider; 
                }
                if(objectRecords[i][value]==undefined){
                    csvStringResult += '"' +''+ '"';
                }
                else{
                    csvStringResult += '"' + objectRecords[i][value]+ '"';
                }            
                counter++;
            }
            csvStringResult += lineDivider;
        }
        return csvStringResult;
    },
    
    customBuildData: function(component, event, updatedData){
        component.set("v.wacData", updatedData);
        if(updatedData.length > 10){
            component.set("v.pageSize", 10);
        } else{
            component.set("v.pageSize", updatedData.length);
        }
        component.set("v.totalPages", Math.ceil(component.get("v.wacData").length/component.get("v.pageSize")));
        this.buildData(component, event);
    },
    
    closeModal: function(component, event){
        component.set("v.showSubmitModal", false);
    },
    getBidInfoForValids: function (component, event, helper) {
        console.log('in getBidInfoForValids');
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
                        "message": "This record is sent for approval.",
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
})