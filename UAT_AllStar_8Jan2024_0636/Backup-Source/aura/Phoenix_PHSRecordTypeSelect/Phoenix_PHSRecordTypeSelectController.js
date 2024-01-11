({
    doInit: function(component, event, helper) {  
        //Fetching Record Type Id  
        helper.getCustomSettingData(component, event);
        var recordTypeId = component.get("v.pageReference").state.recordTypeId;
        let recordId = component.get("v.recordId")
        if (recordId != null && recordId != undefined && recordId != '') {
            component.set("v.isCreate", false);
            component.set("v.recordId", recordId);
            component.set("v.loaded", true);
            var action = component.get("c.getPriceChangeData");
            action.setParams({
                "recordId": recordId
            });
            action.setCallback(this, function(response) {
                if(response.getState()=="SUCCESS"){
                    component.set("v.disableSave", true);
                    component.set("v.disableEdit", false);
                    var resp = response.getReturnValue();
                    var selectedRecord = {};
                    component.set("v.Name", resp[0].Phoenix_PHS_Price_Change_Name__c);
                    component.set("v.ApprovalStatus", resp[0].Phoenix_Approval_Status__c);
                    var newVal = resp[0].Phoenix_Contract__c;
                    component.find("contractLookup").fireChanging(newVal);
                    var recordTypeId = resp[0].RecordTypeId;
                    component.set("v.changeTo", resp[0].Phoenix_Contract__c);
                    component.set("v.contractLookupReadOnly", true);
                    component.set("v.selectedRecordTypeId", recordTypeId);
                    component.set("v.selectedRecordTypeName", resp[0].Phoenix_Record_Type__c);
                    component.set("v.StartDate", resp[0].Phoenix_Price_Start_Date__c);
                    component.set("v.EndDate", resp[0].Phoenix_Price_End_Date__c);
                }
            });
            $A.enqueueAction(action);
            helper.getPriceChangeLines(component, event);
        } else{
            component.set("v.isCreate", true);
            component.set("v.disableSave", false);
            component.set("v.contractLookupReadOnly", false);
            component.set("v.disableEdit", true);
            component.set("v.recordId", null);
            //component.set("v.pageSize", 10); 
            component.set("v.selectedRecordTypeId", recordTypeId);
            helper.fetchListOfRecordTypes(component, event);
            $A.util.removeClass(component.find('resultsDiv'),'slds-is-open');   
        }
    },
  hideSubmitModel: function (component, event, helper) {
        component.set('v.showSubmitModal', false);
        //var LineItemtable = component.find("LineTable");
        //$A.util.addClass(LineItemtable, "maintable");
    },
    proceedToSubmit: function (component, event, helper) {
        if (component.get("v.ApprovalStatus") == 'Draft') {
            component.set('v.showSubmitModal', false);
            //var LineItemtable = component.find("LineTable");
           // $A.util.addClass(LineItemtable, "maintable");
            helper.getBidInfoForValids(component, event, helper);
        }
    },
    openSubmitModal: function (component, event, helper) {
        var linesList = component.get("v.linesList");
        var selectedRecordTypeId = component.get("v.selectedRecordTypeId");
        var isEmptyRecord = '';
        var ProvisionalRecordTypeId = component.get("v.ProvisionalRecordTypeId");
        var QuarterlyRecordTypeId = component.get("v.QuarterlyRecordTypeId");
        if(selectedRecordTypeId == ProvisionalRecordTypeId){
            for(var i=0; i<linesList.length; i++){
                if(linesList[i].Phoenix_Product_Name__c == '' || linesList[i].Phoenix_Product_Name__c == null ||
                   linesList[i].Phoenix_Provisional_PHS_Price__c == '' || linesList[i].Phoenix_Provisional_PHS_Price__c == null ||
                   linesList[i].Phoenix_Price_Start_Date__c == '' || linesList[i].Phoenix_Price_Start_Date__c == '' ||
                   linesList[i].Phoenix_Price_End_Date__c == '' || linesList[i].Phoenix_Price_End_Date__c == ''){
                    var message = 'Enter all the fields and save to submit';
                    isEmptyRecord = true;
                    helper.showErrorToast(component, event, message);
                }
            }
            if(isEmptyRecord != true){
                component.set("v.showSubmitModal", true);
            }
        } else if(selectedRecordTypeId == QuarterlyRecordTypeId){
            component.set("v.showSubmitModal", true);
        }
        /*var ndcChangeId = component.get("v.recordId");
        var getBidInfoAction = component.get("c.getBidInfo");
        getBidInfoAction.setParams({ "bidId": ndcChangeId });
        getBidInfoAction.setCallback(this, function (response) {
            var actState = response.getState();
            if (actState === 'SUCCESS') {
                var responseWarapper=response.getReturnValue();
                component.set("v.wrap",responseWarapper);
                if(responseWarapper.error!=null){
                    component.set("v.isError",true);
                    component.set("v.errorMessage",responseWarapper.error);
                    
                }
            }
        });
        $A.enqueueAction(getBidInfoAction);*/
    },
    
    closeSubmitModal: function (component, event, helper) {
        component.set("v.showSubmitModal", false);
    },
    
    enableEdit: function(component, event, helper){
        component.set("v.disableSave", false);
        component.set("v.contractLookupReadOnly", false);
        component.set("v.disableEdit", true);
    },
    handleContractChange: function(component, event, helper){
      	var selectedContractId= component.get("v.selectedRecordId");  
        component.set("v.loaded", false);
    },
    
    savePriceChange: function(component, event, helper){
        var recordTypeId = component.get("v.selectedRecordTypeId");
        var Name = component.get("v.Name");
        var Contract = component.get("v.selectedRecordId");
        var ProvisionalRecordTypeId = component.get("v.ProvisionalRecordTypeId");
        var QuarterlyRecordTypeId = component.get("v.QuarterlyRecordTypeId");
        var today = new Date();
        var dd = String(today.getDate()).padStart(2, '0');
        var mm = String(today.getMonth() + 1).padStart(2, '0'); //January is 0!
        var yyyy = today.getFullYear();
        today = yyyy + '-' + mm + '-' +dd;
        if(recordTypeId == ProvisionalRecordTypeId){
            if(Name == '' || Name == undefined || Name == null 
               || Contract == '' || Contract == undefined || Contract == null){
                var message = "Please fill all the required fields";
                helper.showErrorToast(component, event, message);
            } else {
                component.find("editForm").submit();
                /*component.set("v.disableSave", true);
                component.set("v.contractLookupReadOnly", true);
                component.set("v.disableEdit", false);
                helper.getProducts(component, event);*/
            }
        } else if(recordTypeId == QuarterlyRecordTypeId) {
            var StartDate = component.get("v.StartDate");
            var EndDate =  component.get("v.EndDate");
            if(Name == '' || Name == undefined || Name == null 
               || Contract == '' || Contract == undefined || Contract == null
              || StartDate == '' || StartDate == undefined || StartDate == null 
               || EndDate == '' || EndDate == undefined || EndDate == null){
                var message = "Please fill all the required fields";
                helper.showErrorToast(component, event, message);
            } else{
                if(StartDate < today){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Warning!",
                        "message":"Price Start Date should be greater than Today's Date",
                        "type":"error"                
                    });
                    toastEvent.fire(); 
                } else if(EndDate < today){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Warning!",
                        "message":"Price End Date should not be lesser than Price Start Date",
                        "type":"error"                
                    });
                    toastEvent.fire(); 
                } else if(EndDate < StartDate){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Warning!",
                        "message":"Price End Date should not be lesser than Price Start Date",
                        "type":"error"                
                    });
                    toastEvent.fire();
                } else{
                    component.find("editForm").submit();
                    component.set("v.disableSave", true);
                    component.set("v.contractLookupReadOnly", true);
                    component.set("v.disableEdit", false);
                    var recordId = component.get("v.recordId");
                    if(component.get("v.linesList").length == 0){
                        helper.getNPRData(component, event); 
                    }   
                }
            }
        }
    },
    
    
    handleSuccess : function(component, event, helper) {
        var record = event.getParam("response");
        var apiName = record.apiName;
        var myRecordId = record.id; // ID of updated or created record
        if(myRecordId){
            component.set("v.isSaved", true);
            component.set("v.recordId", myRecordId);
            component.set("v.disableSave", true);
            component.set("v.contractLookupReadOnly", true);
            component.set("v.disableEdit", false);
            helper.getProducts(component, event);   
        }
    },
    
    sortByProductName: function(component, event, helper) {
        helper.sortBy(component, "ProductName__c");
    },
    sortByMaterialCode: function(component, event, helper) {
        helper.sortBy(component, "Phoenix_Material_Code__c");
    },
    sortByNDC: function(component, event, helper) {
        helper.sortBy(component, "Phoenix_NDC_11__c");
    },
    sortByOldPHS: function(component, event, helper) {
        helper.sortBy(component, "Phoenix_Old_PHS_Price__c");
    },
    sortByNewPHS: function(component, event, helper) {
        helper.sortBy(component, "Phoenix_New_PHS_Price__c");
    },
    sortByChangeInPrice: function(component, event, helper) {
        helper.sortBy(component, "Phoenix_Change_in_Price__c");
    },
    sortByPHSUnits: function(component, event, helper) {
        helper.sortBy(component, "Phoenix_Last_90_days_PHS_Units__c");
    },
    sortBySalesDifference: function(component, event, helper) {
        helper.sortBy(component, "Phoenix_Sales_Difference__c");
    },
    sortByApexusPrice: function(component, event, helper) {
        helper.sortBy(component, "Price_in_Apexus_Sub_Ceiling_Contract__c");
    },
    sortByDiffApexusPrice: function(component, event, helper) {
        helper.sortBy(component, "Phoenix_Diff_in_Apexus_Sub_Ceiling_Price__c");
    },
    sortByApexusPriceChangeRequired: function(component, event, helper) {
        helper.sortBy(component, "Apexus_Sub_Ceiling_Price_Change_Required__c");
    },
    sortByRemarks: function(component, event, helper) {
        helper.sortBy(component, "Phoenix_Remarks__c");
    },
    
    doFilter: function(component, event, helper) {  
        //calling helper  
        helper.FilterRecords(component);  
    }, 
    
    showUploadFile: function(component, event, helper){
      component.set("v.fileUpload", true);
    },
    
    handleUploadFinished: function(component, event, helper){
		helper.handleUpload(component, event) ;
    },
    showImport: function(component, event, helper){
    	component.set("v.showImportModal", true);
    },
    
    
    onsearch: function(component, event, helper){
        var searchText = component.get("v.searchText"); 
        if(searchText == null || searchText == '' || searchText == undefined){
            component.set("v.pageSize", 10);
            component.set("v.linesList",component.get("v.UnfilteredData"));
            component.set("v.totalPages", Math.ceil(component.get("v.linesList").length/component.get("v.pageSize")));
            component.set("v.currentPageNumber",1);
            component.set("v.searchResults", []);
            component.set("v.filteredData", []);
            helper.buildData(component, event);
        } else{
            helper.searchTableRecords(component, event);
        }
    },
    
    onKeyCheck: function(component, event, helper){
        var searchText = component.get("v.searchText");
        if(event.which == 13){
            if(searchText == null || searchText == '' || searchText == undefined){
                component.set("v.pageSize", 10);
                component.set("v.linesList",component.get("v.UnfilteredData"));
                component.set("v.totalPages", Math.ceil(component.get("v.linesList").length/component.get("v.pageSize")));
                component.set("v.currentPageNumber",1);
                component.set("v.searchResults", []);
                component.set("v.filteredData", []);
                helper.buildData(component, event);
            } else{
                helper.searchTableRecords(component, event);
            }
        }
    },
    
    onInputSearchChange: function(component, event, helper){
        var searchText = component.get("v.searchText");
        if(searchText == ''){
            component.set("v.pageSize", 10);
            component.set("v.linesList",component.get("v.UnfilteredData"));
            component.set("v.totalPages", Math.ceil(component.get("v.linesList").length/component.get("v.pageSize")));
            component.set("v.currentPageNumber",1);
            component.set("v.searchResults", []);
            component.set("v.filteredData", []);
            helper.buildData(component, event);
        }
    },
    
    handleImport: function(component, event, helper){
        var uploadedFiles = event.getParam("files");
        var linesList = component.get("v.linesList");
        var updatedLinesList = [];
        component.set("v.documentId", uploadedFiles[0].documentId);
        var action = component.get("c.csvFileRead");
        action.setParams({
            "contentDocumentId": uploadedFiles[0].documentId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state == "SUCCESS") {
                var resp = response.getReturnValue();
                for(var i=0; i<linesList.length; i++){
                    var LineId = linesList[i].Id;
                    if(resp[LineId] != undefined){
                        linesList[i].Phoenix_New_PHS_Price__c = resp[LineId];
                        var newPrice = linesList[i].Phoenix_New_PHS_Price__c;
                        var oldPrice = linesList[i].Phoenix_Old_PHS_Price__c;
                        var units = linesList[i].Phoenix_Last_90_days_PHS_Units__c;
                        var priceInApexus = linesList[i].Price_in_Apexus_Sub_Ceiling_Contract__c;
                        if(newPrice){
                            var changeInPrice = (newPrice - oldPrice)/oldPrice;
                            var salesDifference = (newPrice - oldPrice)*units;
                            if(priceInApexus == null || priceInApexus == undefined){
                                linesList[i].Phoenix_Diff_in_Apexus_Sub_Ceiling_Price__c = '';
                                linesList[i].Apexus_Sub_Ceiling_Price_Change_Required__c = '';
                            } else{
                             	var diffInApexus = priceInApexus - newPrice;   
                                linesList[i].Phoenix_Diff_in_Apexus_Sub_Ceiling_Price__c = diffInApexus;
                                if(Math.sign(diffInApexus) == '-1'){
                                    linesList[i].Apexus_Sub_Ceiling_Price_Change_Required__c = 'No';
                                } else {
                                    linesList[i].Apexus_Sub_Ceiling_Price_Change_Required__c = 'Yes';
                                }
                            }
                            linesList[i].ChangeInPrice = changeInPrice;
                            linesList[i].Phoenix_Change_in_Price__c = changeInPrice*100;
                            linesList[i].Phoenix_Sales_Difference__c = salesDifference;   
                        } else{
                            linesList[i].Phoenix_Change_in_Price__c = '';
                            linesList[i].Phoenix_Sales_Difference__c = '';
                            linesList[i].Phoenix_Diff_in_Apexus_Sub_Ceiling_Price__c = '';
                            linesList[i].Apexus_Sub_Ceiling_Price_Change_Required__c = '';
                        }
                    } else {
                     	linesList[i].Phoenix_New_PHS_Price__c = '';   
                    }
                    updatedLinesList.push(linesList[i]);
                }
                component.set("v.linesList", updatedLinesList);
                component.set("v.duplicateLinesList", updatedLinesList);
                component.set("v.showImportModal", false);
                component.set("v.disableSaveLines", false);
                component.set("v.disableSubmit", false);
                helper.buildData(component, event);
            } else{
                console.log("Error "+JSON.stringify(response.getError()));
            }
        });
        // enqueue the server side action  
        $A.enqueueAction(action); 
    },
    
    closeModal: function(component, event, helper){
        component.set("v.fileUpload", false);
        component.set("v.showImportModal", false);
    },
    
     deleteAttachment: function (component, event, helper) {
        var target = event.target;
        var selectedRec = target.getAttribute("name");
        var target = event.target;
        var action = component.get("c.deleteAttachments");
        action.setParams({
            'attachId' :selectedRec
        });
        action.setCallback(this,function(response) {
            var state = response.getState();
            if(state=='SUCCESS'){
            }
            
        });
        $A.enqueueAction(action);        
        var AllRowsList = component.get("v.fileList");
        if (AllRowsList.length === 1) {
            console.log('AllRowsList.length === 1');
        }
        for (let i = 0; i < AllRowsList.length; i++) {
            var pItem = AllRowsList[i];
            if (pItem.Id == selectedRec) {
                var index = AllRowsList.indexOf(pItem);
                if (index > -1) {
                    AllRowsList.splice(index, 1);
                    var AllRowsList1 = AllRowsList;
                }
            }
        }
        component.set("v.fileList",[]);
        component.set("v.fileList", AllRowsList);
        
    },
    
    downloadCsv: function (component, event, helper) {

        var ResultData = component.get("v.linesList");
        // call the helper function which "return" the CSV data as a String   
        var csv = helper.convertArrayOfObjectsToCSV(component, ResultData);
        if (csv == null) {
            return;
        }

        // ####--code for create a temp. <a> html tag [link tag] for download the CSV file--####     
        var hiddenElement = document.createElement('a');
        hiddenElement.href = 'data:text/csv;charset=utf-8,' + encodeURI(csv);
        hiddenElement.target = '_self'; //      
        var date = new Date();
        var hours = date.getHours();
        var minutes = date.getMinutes();
        var newformat = hours >= 12 ? 'PM' : 'AM';
        hours = hours % 12;
        hours = hours ? hours : 12;
        minutes = minutes < 10 ? '0' + minutes : minutes;
        var Now = (date.getMonth() + 1) + '/' + date.getDate() + '/' + date.getFullYear() + ' ' + hours + ':' + minutes + ' ' + newformat;
        hiddenElement.download = 'PHS Export '+ '-' + Now + '.csv'; // CSV file Name* you can change it.[only name not .csv] 
        document.body.appendChild(hiddenElement); // Required for FireFox browser
        hiddenElement.click(); // using click() js function to download csv file
    },
    
    backToRecordDetail: function(component, event, helper) {
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": component.get("v.recordId"),
            "slideDevName": "detail"
        });
        navEvt.fire();
        $A.get('e.force:refreshView').fire();
    },
    
    backToSObject: function(component, event, helper){
        var recordId = component.get("v.recordId");
        if(recordId == null || recordId == '' || recordId == undefined){
            var navService = component.find("navService");
            var pageReference = {
                type: 'standard__objectPage',
                attributes: {
                    objectApiName: 'Phoenix_PHS_Price_Change__c',
                    actionName: 'list'
                },
                state: {
                    filterName: "Recent"
                }
            };
            component.set("v.pageReference", pageReference);
            // Set the URL on the link or use the default if there's an error
            var defaultUrl = "#";
            navService.generateUrl(pageReference)
            .then($A.getCallback(function(url) {
                component.set("v.url", url ? url : defaultUrl);
            }), $A.getCallback(function(error) {
                component.set("v.url", defaultUrl);
            }));
            navService.navigate(pageReference);   
            $A.get('e.force:refreshView').fire();
        } else{
            var navEvt = $A.get("e.force:navigateToSObject");
            navEvt.setParams({
                "recordId": recordId,
                "slideDevName": "detail"
            });
            navEvt.fire();
            $A.get('e.force:refreshView').fire();

        }
    },

    // function for delete the row 
    removeDeletedRow: function(component, event, helper) {
        var index = event.getParam("indexVar");    
        var AllLinesList = component.get("v.linesList");
        var AllDuplicateLinesList = component.get("v.duplicateLinesList");
        var AllRowsList = component.get("v.data");
        var rowToDelete = AllLinesList[index];
        var selectedRecordTypeId = component.get("v.selectedRecordTypeId");
        var ProvisionalRecordTypeId = component.get("v.ProvisionalRecordTypeId");
        var QuarterlyRecordTypeId = component.get("v.QuarterlyRecordTypeId");
        if(selectedRecordTypeId == QuarterlyRecordTypeId){
            AllRowsList.splice(index, 1);
        }
        AllLinesList.splice(index, 1);
        AllDuplicateLinesList.splice(index, 1);
        component.set("v.linesList", AllLinesList);
          component.set("v.linesList1", AllLinesList);
        component.set("v.duplicateLinesList", AllDuplicateLinesList);
        component.set("v.totalPages", Math.ceil(component.get("v.linesList").length/component.get("v.pageSize")));
        component.set("v.currentPageNumber",1);
        console.log('Count of records while deleting:: '+component.get("v.linesList").length);
        helper.buildData(component);
        if(rowToDelete){
         	component.set('v.deletePHSLine', rowToDelete.Id);   
            helper.deletePHSLine(component, event);
        }
        var linesList = component.get("v.linesList");
        if(linesList.length == 0){
            component.set("v.disableEdit", false);
        }
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
    },
    addRow: function(component, event, helper) {  
        var linesList = component.get("v.linesList");
        var isEmptyRecord = '';
        var today = new Date();
        var dd = String(today.getDate()).padStart(2, '0');
        var mm = String(today.getMonth() + 1).padStart(2, '0'); //January is 0!
        var yyyy = today.getFullYear();
        today = yyyy + '-' + mm + '-' +dd; 
        if(linesList.length == 0){
            helper.addRow(component, event);
        }
        else if(linesList.length !=0){
            for(var i=0; i<linesList.length; i++){
                if(linesList[i].Phoenix_Product_Name__c == '' || linesList[i].Phoenix_Provisional_PHS_Price__c == ''
                   || linesList[i].Phoenix_Price_Start_Date__c == '' 
                   || linesList[i].Phoenix_Price_End_Date__c == ''){
                    var message = 'Enter all the fields';
                    isEmptyRecord = true;
                    helper.showErrorToast(component, event, message);
                } else if(linesList[i].Phoenix_Price_Start_Date__c < today){
                    var toastEvent = $A.get("e.force:showToast");
                    isEmptyRecord = true;
                    toastEvent.setParams({
                        "title": "Warning!",
                        "message":"Price Start Date should be greater than Today's Date",
                        "type":"error"                
                    });
                    toastEvent.fire(); 
                } else if(linesList[i].Phoenix_Price_End_Date__c < linesList[i].Phoenix_Price_Start_Date__c){
                    var toastEvent = $A.get("e.force:showToast");
                    isEmptyRecord = true;
                    toastEvent.setParams({
                        "title": "Warning!",
                        "message":"Price End Date should not be lesser than Price Start Date",
                        "type":"error"                
                    });
                    toastEvent.fire();
                }            
            } 
            if(isEmptyRecord != true){
                helper.addRow(component, event);
            }
        }        
    },
    
    disableSaveButton: function(component, event, helper){
        component.set("v.disableSaveLines", false);
        component.set("v.disableSubmit", false);
    },
    Save: function(component, event, helper){
        var linesList = component.get("v.linesList");
        var selectedRecordTypeId = component.get("v.selectedRecordTypeId");
        var isEmptyRecord = '';
        var ProvisionalRecordTypeId = component.get("v.ProvisionalRecordTypeId");
        var QuarterlyRecordTypeId = component.get("v.QuarterlyRecordTypeId");
        var today = new Date();
        var dd = String(today.getDate()).padStart(2, '0');
        var mm = String(today.getMonth() + 1).padStart(2, '0'); //January is 0!
        var yyyy = today.getFullYear();
        console.log('LinesList:: '+JSON.stringify(linesList));
        today = yyyy + '-' + mm + '-' +dd; 
        if(selectedRecordTypeId == ProvisionalRecordTypeId){
            if(linesList.length != 0){
                for(var i=0; i<linesList.length; i++){
                    if(linesList[i].Phoenix_Product_Name__c == '' || linesList[i].Phoenix_Product_Name__c == null ||
                       linesList[i].Phoenix_Provisional_PHS_Price__c == '' || linesList[i].Phoenix_Provisional_PHS_Price__c == null ||
                       linesList[i].Phoenix_Price_Start_Date__c == '' || linesList[i].Phoenix_Price_Start_Date__c == '' ||
                       linesList[i].Phoenix_Price_End_Date__c == '' || linesList[i].Phoenix_Price_End_Date__c == ''){
                        var message = 'Enter all the fields';
                        isEmptyRecord = true;
                        helper.showErrorToast(component, event, message);
                    } else if(linesList[i].Phoenix_Price_Start_Date__c < today){
                        var toastEvent = $A.get("e.force:showToast");
                        isEmptyRecord = true;
                        toastEvent.setParams({
                            "title": "Warning!",
                            "message":"Price Start Date should be greater than Today's Date",
                            "type":"error"                
                        });
                        toastEvent.fire(); 
                    } else if(linesList[i].Phoenix_Price_End_Date__c < linesList[i].Phoenix_Price_Start_Date__c){
                        var toastEvent = $A.get("e.force:showToast");
                        isEmptyRecord = true;
                        toastEvent.setParams({
                            "title": "Warning!",
                            "message":"Price End Date should not be lesser than Price Start Date",
                            "type":"error"                
                        });
                        toastEvent.fire();
                    }
                }
                if(isEmptyRecord != true){
                    component.set("v.loaded", true);
                    helper.savePriceChangeLine(component, event);
                }
           } else{
               var message = 'No records to save';
               helper.showErrorToast(component, event, message);
           }
        } else if(selectedRecordTypeId == QuarterlyRecordTypeId){
            component.set("v.saveSpinnerLoad", true);
            helper.savePriceChangeLine(component, event);
        }
    },
    
    handleChange: function (component, event, helper) {
        var selectedOptionValue = event.getParam("value");
        var linesList = component.get("v.linesList");
        var duplicateLinesList = component.get("v.duplicateLinesList");
        var yesFilterData = [];
        var noFilterData = [];
        component.set('v.linesList', duplicateLinesList);
        linesList = duplicateLinesList;
        helper.buildData(component, event);
        if(selectedOptionValue == 'All'){
            component.set("v.pageSize", 10);
            component.set('v.linesList', duplicateLinesList);
            component.set("v.totalPages", Math.ceil(component.get("v.linesList").length/component.get("v.pageSize")));
            helper.buildData(component, event);
        } else if(selectedOptionValue == 'Yes'){
            component.set('v.linesList', duplicateLinesList);
            for(var i=0; i<linesList.length; i++){
                if(linesList[i].Apexus_Sub_Ceiling_Price_Change_Required__c == 'Yes'){
                    yesFilterData.push(linesList[i]);
                } else{}
            }
            component.set("v.linesList", yesFilterData);
            if(yesFilterData.length < 10){
                component.set("v.pageSize", yesFilterData.length);
            } else{
                component.set("v.pageSize", 10);
            }
            if(yesFilterData.length == 0){
                component.set("v.totalPages", 1);
            } else{
                component.set("v.totalPages", Math.ceil(component.get("v.linesList").length/component.get("v.pageSize")));   
            }
            component.set("v.currentPageNumber",1);
            helper.buildData(component, event);
        } else if(selectedOptionValue == 'No'){
            component.set('v.linesList', duplicateLinesList); 
            for(var i=0; i<linesList.length; i++){
                if(linesList[i].Apexus_Sub_Ceiling_Price_Change_Required__c == 'No'){
                    noFilterData.push(linesList[i]);
                } else{}
            }
            component.set("v.linesList", noFilterData);
            if(noFilterData.length < 10){
                component.set("v.pageSize", noFilterData.length);
            } else{
                component.set("v.pageSize", 10);
            }
            if(noFilterData.length == 0){
                component.set("v.totalPages", 1);
            } else{
                component.set("v.totalPages", Math.ceil(component.get("v.linesList").length/component.get("v.pageSize")));   
            }
            component.set("v.currentPageNumber",1);
            helper.buildData(component, event);
        } else{
            component.set("v.pageSize", 10);
            component.set('v.linesList', duplicateLinesList);
            component.set("v.totalPages", Math.ceil(component.get("v.linesList").length/component.get("v.pageSize")));
            helper.buildData(component, event);
        }
    },
    
    //Pagination action code
    onNext : function(component, event, helper) {        
        var pageNumber = component.get("v.currentPageNumber");
        component.set("v.currentPageNumber", pageNumber+1);
        helper.buildData(component, helper);
    },
    
    onPrev : function(component, event, helper) {        
        var pageNumber = component.get("v.currentPageNumber");
        component.set("v.currentPageNumber", pageNumber-1);
        helper.buildData(component, helper);
    },
    
    processMe : function(component, event, helper) {
        component.set("v.currentPageNumber", parseInt(event.target.name));
        helper.buildData(component, helper);
    },
    
    onFirst : function(component, event, helper) {     
        component.set("v.currentPageNumber", 1);
        helper.buildData(component, helper);
    },
    
    onLast : function(component, event, helper) {
        component.set("v.currentPageNumber", component.get("v.totalPages"));
        helper.buildData(component, helper);
    },

})