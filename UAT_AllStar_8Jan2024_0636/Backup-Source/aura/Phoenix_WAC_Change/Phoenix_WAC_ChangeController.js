({
	doInit : function(component, event, helper) {
        component.set("v.selectedFilter", 'None');
        let pageReference = component.get("v.pageReference");
        let recordId = pageReference.state.c__recordId;
        if (recordId != null && recordId != undefined && recordId != '') {
            component.set("v.loaded", true);
            component.set("v.recordId", recordId);
            component.set("v.enableButton", false);
            var action = component.get("c.getActiveBidProductFamilies");
            var opts = [];
            action.setCallback(this, function(response) 
                               {
                                   if(response.getState()=="SUCCESS"){
                                       var resp = response.getReturnValue();
                                       component.set("v.activeBidProductFamilies", resp);
                                       for(var i=0;i< resp.length;i++){
                                           var familyKey = Object.keys(resp[i]);
                                           opts.push({"class": "optionClass", label: resp[i][familyKey], value: familyKey.toString()});
                                       }
                                       component.set("v.ProductFamilyOptions", opts);
                                       helper.loadInstance(component, event);
                                   }
                               });
            $A.enqueueAction(action);
        } else{
            component.set("v.recordId", null);
            var action = component.get("c.getActiveBidProductFamilies");
            var opts = [];
            action.setCallback(this, function(response) 
                               {
                                   if(response.getState()=="SUCCESS"){
                                       var resp = response.getReturnValue();
                                       component.set("v.activeBidProductFamilies", resp);
                                       for(var i=0;i< resp.length;i++){
                                           var familyKey = Object.keys(resp[i]);
                                           opts.push({"class": "optionClass", label: resp[i][familyKey], value: familyKey.toString()});
                                       }
                                       component.set("v.ProductFamilyOptions", opts);
                                   }
                               });
            $A.enqueueAction(action);   
        }
	},
    handleUploadFinished: function(component, event, helper){
		helper.handleUpload(component, event) ;
    },
    showImport: function(component, event, helper){
    	component.set("v.showImportModal", true);
    },
    
    reInit : function(component, event, helper) {
        $A.get('e.force:refreshView').fire();
    },
    
    handleChange: function (component, event, helper) {
        var selectedOptionValue = event.getParam("value");
        var data = component.get("v.wacData");
        var UnfilteredData = component.get("v.UnfilteredData");
        var updatedData = [];
        if(selectedOptionValue == 'syswacvsuploadedwac'){
            for(var i=0; i<UnfilteredData.length; i++){
                if(UnfilteredData[i].Phoenix_SysWAC_Vs_UploadedWAC__c != 0 && UnfilteredData[i].Phoenix_SysWAC_Vs_UploadedWAC__c != null && UnfilteredData[i].Phoenix_SysWAC_Vs_UploadedWAC__c != ''){
                    updatedData.push(UnfilteredData[i]);
                }
            }
			helper.customBuildData(component, event, updatedData);
        } else if(selectedOptionValue == 'syscpvsuploadedcp'){
            for(var i=0; i<UnfilteredData.length; i++){
                if(UnfilteredData[i].Phoenix_SysContPrice_Vs_UploadContrPrice__c != 0 && UnfilteredData[i].Phoenix_SysContPrice_Vs_UploadContrPrice__c != null && UnfilteredData[i].Phoenix_SysContPrice_Vs_UploadContrPrice__c != ''){
                    updatedData.push(UnfilteredData[i]);
                }
            }
            helper.customBuildData(component, event, updatedData);
        } else if(selectedOptionValue == 'syswacvsproposedwac'){
            for(var i=0; i<UnfilteredData.length; i++){
                if(UnfilteredData[i].Phoenix_Sys_WAC_Vs_Proposed_WAC__c != 0 && UnfilteredData[i].Phoenix_Sys_WAC_Vs_Proposed_WAC__c != null && UnfilteredData[i].Phoenix_Sys_WAC_Vs_Proposed_WAC__c != ''){
                    updatedData.push(UnfilteredData[i]);
                }
            }
            helper.customBuildData(component, event, updatedData);
        } else if(selectedOptionValue == 'syscpvsproposedcp'){
            for(var i=0; i<UnfilteredData.length; i++){
                if(UnfilteredData[i].Phoenix_SysContrPrice_Vs_PropContrPrice__c != 0 && UnfilteredData[i].Phoenix_SysContrPrice_Vs_PropContrPrice__c != null && UnfilteredData[i].Phoenix_SysContrPrice_Vs_PropContrPrice__c != ''){
                    updatedData.push(UnfilteredData[i]);
                }
            }
            helper.customBuildData(component, event, updatedData);
        } else if(selectedOptionValue == 'unmatched'){
            for(var i=0; i<UnfilteredData.length; i++){
                if(UnfilteredData[i].Phoenix_NPR__c){
                }else{
                    updatedData.push(UnfilteredData[i]);
                }
            }
            helper.customBuildData(component, event, updatedData);
        } else if(selectedOptionValue == 'none'){
            helper.customBuildData(component, event, UnfilteredData);
        }
    },
    
    filterTable: function(component, event, helper){
        helper.filterTableData(component, event, helper);
    },
    
    
    handleImport: function(component, event, helper){
        var uploadedFiles = event.getParam("files");
        var updatedLinesList = [];
        component.set("v.showImportModal", false);
        component.set("v.loaded", true);
        component.set("v.documentId", uploadedFiles[0].documentId);
        var action = component.get("c.csvFileRead");
        action.setParams({
            "contentDocumentId": uploadedFiles[0].documentId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state == "SUCCESS") {
                var resp = response.getReturnValue();
                var data = [];
                var Material_ContractsList = [];
                for(var i=0; i<resp.length; i++){
                    var instance = {};
                    var respInstance = resp[i];
                    var Matr_Contract = respInstance[0]+'_'+respInstance[3];
                    instance.Phoenix_Contr_Number__c = respInstance[0];
                    instance.Phoenix_Contr_IntDesc__c = respInstance[1];
                    instance.Phoenix_Cust_Number__c = respInstance[2];
                    instance.Phoenix_Matl_No__c = respInstance[3];
                    instance.Phoenix_Description__c = respInstance[4];
                    instance.Phoenix_NDC11__c = respInstance[5];
                    instance.Phoenix_Uploaded_WAC__c = respInstance[6].replace('$', '');
                    instance.Phoenix_Uploaded_Contr_Price__c = respInstance[7].replace('$', '');
                    instance.Phoenix_Proposed_WAC__c = respInstance[8].replace('$', '');
                    instance.Phoenix_Proposed_Contr_Price__c = respInstance[9].replace('$', '');
                    instance.Phoenix_Comments__c = respInstance[10];
                    instance.Mat_Contract_Ref = Matr_Contract;
                    Material_ContractsList.push(Matr_Contract);
                    data.push(instance);
                }
                component.set("v.disableSave", false);
                component.set("v.wacData", data);
                component.set("v.Material_ContractsList", Material_ContractsList);
                helper.getNPRData(component, event);
            } else{
                console.log("Error "+JSON.stringify(response.getError()));
            }
        });
        // enqueue the server side action  
        $A.enqueueAction(action);
    },
     proceedToSubmit: function (component, event, helper) {
        if (component.get("v.ApprovalStatus") == 'Draft') {
            component.set('v.showSubmitModal', false);
            //var LineItemtable = component.find("LineTable");
           // $A.util.addClass(LineItemtable, "maintable");
            helper.getBidInfoForValids(component, event, helper);
        }
    },
    saveWACLineItems: function(component, event, helper){
        component.set("v.loaded", true);
        var updateWACLineItemsaction = component.get("c.updateWACLineItems");
        var wac = [];
      wac  = component.get("v.wacData");
        console.log('wac length is '+component.get("v.recordId"));
        console.log('recordId is '+JSON.stringify(wac));
        updateWACLineItemsaction.setParams({
            'recordId': component.get("v.recordId"),
            'lineItems': wac
        });
        updateWACLineItemsaction.setCallback(this, function(response){
            if(response.getState() == 'SUCCESS'){
                component.set("v.disableExportImportBtn", false);
                var message = "WAC Change Line items created";
                helper.showSuccessToast(component, event, message);
                var resp = response.getReturnValue();
                var ProductFamily = component.get("v.ProductFamily");
                var SelectedProductFamilyName = component.get("v.SelectedProductFamilyName");
                var data = [];
                console.log('Response: '+JSON.stringify(resp));
                for(var i=0; i<resp.length; i++){
                    if(resp[i].Phoenix_NPR__c){
                        if(resp[i].Phoenix_Product__c == null || resp[i].Phoenix_Product__c == undefined || resp[i].Phoenix_Product__c == ''){
                            resp[i].Phoenix_Product_Name__c = '';
                            resp[i].Phoenix_Product__c = '';
                            resp[i].Phoenix_Product_Family__c = '';
                            resp[i].isProductFamilyMatched = '';
                        } else{
                            resp[i].Phoenix_Product_Name__c = resp[i].Phoenix_Product__r.Name;
                            resp[i].Phoenix_Product__c = resp[i].Phoenix_Product__c;
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
                component.set("v.wacData", data);
                component.set("v.UnfilteredData", data);
                component.set("v.checkWACFilter", false);
                component.set("v.checkCPFilter", false);
                component.set("v.disableSubmit", true);
                if(data.length > 10){
                    component.set("v.pageSize", 10);
                } else{
                    component.set("v.pageSize", data.length);
                }
                component.set("v.totalPages", Math.ceil(component.get("v.wacData").length/component.get("v.pageSize")));
                helper.buildData(component, event);
                component.set("v.loaded", false);
                component.set("v.disableSave", true);
            } else{
                console.log("Error "+JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(updateWACLineItemsaction);
    },
    
    disableSaveButton: function(component, event, helper){
        var isValueChanged = event.getParam("isValueChanged");
        if(isValueChanged == true){
            component.set("v.disableSave", false);
            component.set("v.disableSubmit", false);   
        } else{
            component.set("v.disableSave", true);
            component.set("v.disableSubmit", false);
        }
    },
    
    openSubmitModal: function(component, event, helper){
        component.set("v.showSubmitModal", true);
        var tableDiv = component.find('LineTable');
        $A.util.removeClass(tableDiv, 'customtable')
    },
    
    hideSubmitModel: function(component, event, helper){
        helper.closeModal(component, event);
        var tableDiv = component.find('LineTable');
        $A.util.addClass(tableDiv, 'customtable')
    },
    
    backToSObject: function(component, event, helper){
        var recordId = component.get("v.recordId");
        if(recordId == null || recordId == '' || recordId == undefined){
            var navService = component.find("navService");
            var pageReference = {
                type: 'standard__objectPage',
                attributes: {
                    objectApiName: 'Phoenix_WAC_Change__c',
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
    
    handleSelectedProductFamily: function (component, event) {
        // Get the string of the "value" attribute on the selected option
        var selectedOptionValue = event.getParam("value");
        var selectedOptionName = event.getParam("name");
        component.set("v.SelectedProductFamily", selectedOptionValue);
        var ProductFamilyOptions = component.get("v.ProductFamilyOptions");
        for(var i=0; i<ProductFamilyOptions.length; i++){
            if(ProductFamilyOptions[i].value == selectedOptionValue){
                component.set("v.ProductFamily", ProductFamilyOptions[i].value);
                component.set("v.SelectedProductFamilyName", ProductFamilyOptions[i].label);
                console.log('Selected Product Family Name: '+component.get("v.SelectedProductFamilyName"));
                break;
            }
        }
    },
    handleSuccess : function(component, event, helper) {
        var record = event.getParam("response");
        var apiName = record.apiName;
        var myRecordId = record.id; // ID of updated or created record
        component.set("v.recordId", myRecordId);
        component.find("navService").navigate({
            type: "standard__component",
            attributes: {
                componentName: "c__Phoenix_WAC_Change" },
            state: {
                c__recordId: myRecordId
               
            }
        }, true); // replace = true
        component.set("v.loaded", false);
        component.set("v.showLineItems", true);
        component.set("v.disableImport", false);
        component.set("v.disableUpload", false);
    },
    SaveWACChange: function(component, event, helper){
        component.set("v.loaded", true);
        var Name = component.get("v.Name");
        var Date = component.get("v.Date");
        var Summary = component.get("v.Summary");
        var MedicaidRelease = component.get("v.MedicaidRelease");
        var SalesRelease = component.get("v.SalesIncrease");
        var PHSHit = component.get("v.PHSHit");
        var WACFinanceImpact = component.get("v.WACFinanceImpact");
        var WorkingCapitalBenefit = component.get("v.WorkingCapitalBenefit");
        var TotalNetBenefit = component.get("v.TotalNetBenefit");
        if(Name == '' || Name == undefined || Name == null 
           || Date == '' || Date == undefined || Date == null
          || MedicaidRelease == '' || MedicaidRelease == undefined || MedicaidRelease == null
          || SalesRelease == '' || SalesRelease == undefined || SalesRelease == null
          || PHSHit == '' || PHSHit == undefined || PHSHit == null
          || WACFinanceImpact == '' || WACFinanceImpact == undefined || WACFinanceImpact == null
          || WorkingCapitalBenefit == '' || WorkingCapitalBenefit == undefined || WorkingCapitalBenefit == null){
            var message = "Please fill all the required fields";
            component.set("v.loaded", false);
            helper.showErrorToast(component, event, message);
        } else {
            component.find("recordEditForm").submit();
        }
    },
    
    addCSS: function(component, event, helper){
        var filterDiv = component.find('filterId');
        $A.util.addClass(filterDiv, 'filterCSS');   
    },
    removeCSS: function(component, event, helper){
        var filterDiv = component.find('filterId');
        $A.util.removeClass(filterDiv, 'filterCSS');    
    },
    
    showFileUploadModal: function(component, event, helper){
        component.set("v.showFileUpload", true);
        var tableDiv = component.find('LineTable');
        $A.util.removeClass(tableDiv, 'customtable')
        /*var filterDiv = component.find('filterId');
        $A.util.removeClass(filterDiv, 'filterCSS');*/
    },
    closeModal: function(component, event, helper){
        component.set("v.showFileUpload", false);
        component.set("v.showImportModal", false);
        component.set("v.openDeletePopupModal", false);
        var tableDiv = component.find('LineTable');
        $A.util.addClass(tableDiv, 'customtable')
    },
    openDeletePopup: function(component, event, helper){
        component.set("v.openDeletePopupModal", true);
        var tableDiv = component.find('LineTable');
        $A.util.removeClass(tableDiv, 'customtable');
        /*var filterDiv = component.find('filterId');
        $A.util.removeClass(filterDiv, 'filterCSS');*/
    },
    deleteLineItems: function(component, event, helper){
        component.set("v.loaded", true);
        var data = component.get("v.wacData");
        var dataToBeDeletedFromDB = [];
        var dataToBeDeletedFromState = [];
        component.set("v.openDeletePopupModal", false);
        for(var i=0; i<data.length; i++){
            if(data[i].Id){
                dataToBeDeletedFromDB.push(data[i].Id);
            } else{
                dataToBeDeletedFromState.push(data[i]);
            }
        }
        component.set("v.itemsToBeDeletedFromDB", dataToBeDeletedFromDB);
        if(dataToBeDeletedFromDB.length > 0){
            helper.deleteLines(component, event);
            component.set("v.disableSubmit", false);
        } else if(dataToBeDeletedFromState.length > 0){
            component.set("v.wacData", []);
            component.set("v.UnfilteredData", []);
            component.set("v.data", []);
            component.set("v.disableExportImportBtn", true);
            component.set("v.loaded", false);
            component.set("v.disableImport", false);
            component.set("v.disableSubmit", false);
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
    
    //Sorting logic
    sortByWACChangeLineReference: function(component, event, helper) {
        helper.sortBy(component, "Name");
    },
    sortByContractNumber: function(component, event, helper) {
        helper.sortBy(component, "Phoenix_Contr_Number__c");
    },
    sortByContractInternalDescription: function(component, event, helper) {
        helper.sortBy(component, "Phoenix_Contr_IntDesc__c");
    },
    sortByCustomerName: function(component, event, helper) {
        helper.sortBy(component, "Phoenix_Cust_Name__c");
    },
    sortByCustomerNumber: function(component, event, helper) {
        helper.sortBy(component, "Phoenix_Cust_Number__c");
    },
    sortByMaterialNumber: function(component, event, helper) {
        helper.sortBy(component, "Phoenix_Matl_No__c");
    },
    sortByDescription: function(component, event, helper) {
        helper.sortBy(component, "Phoenix_Description__c");
    },
    sortByProduct: function(component, event, helper) {
        helper.sortBy(component, "Phoenix_Product_Name__c");
    },
    sortByProductFamily: function(component, event, helper){
        helper.sortBy(component, 'Phoenix_Product_Family__c');
    },
    sortByNDC11: function(component, event, helper) {
        helper.sortBy(component, "Phoenix_NDC11__c");
    },
    sortByAccount: function(component, event, helper) {
        helper.sortBy(component, "Phoenix_Account_Name__c");
    },
    sortByNPR: function(component, event, helper) {
        helper.sortBy(component, "Phoenix_NPR_Name__c");
    },
    sortBySystemWAC: function(component, event, helper) {
        helper.sortBy(component, "Phoenix_System_WAC__c");
    },
    sortBySystemContractPrice: function(component, event, helper) {
        helper.sortBy(component, "Phoenix_System_Contract_price__c");
    },
    sortByUploadedWAC: function(component, event, helper) {
        helper.sortBy(component, "Phoenix_Uploaded_WAC__c");
    },
    sortByUploadedContractPrice: function(component, event, helper) {
        helper.sortBy(component, "Phoenix_Uploaded_Contr_Price__c");
    },
    sortBySystemWACVsUploadedWAC: function(component, event, helper) {
        helper.sortBy(component, "Phoenix_SysWAC_Vs_UploadedWAC__c");
    },
    sortBySysContrPriceVsUploadedContrPrice: function(component, event, helper) {
        helper.sortBy(component, "Phoenix_SysContPrice_Vs_UploadContrPrice__c");
    },
    sortByProposedWAC: function(component, event, helper) {
        helper.sortBy(component, "Phoenix_Proposed_WAC__c");
    },
    sortByProposedContractPrice: function(component, event, helper) {
        helper.sortBy(component, "Phoenix_Proposed_Contr_Price__c");
    },
    sortByComments: function(component, event, helper) {
        helper.sortBy(component, "Phoenix_Comments__c");
    },
    sortByContractsComments: function(component, event, helper) {
        helper.sortBy(component, "Phoenix_Contracts_Comments__c");
    },
    sortByOfferLetterSent: function(component, event, helper) {
        helper.sortBy(component, "Phoenix_Offer_Letter_Sent__c");
    },
    sortByDateOfferSent: function(component, event, helper) {
        helper.sortBy(component, "Phoenix_Date_Offer_Sent__c");
    },
    sortByCustomerResponseDate: function(component, event, helper) {
        helper.sortBy(component, "Phoenix_Customer_Response_Date__c");
    },
    sortByCustomerResponseStatus: function(component, event, helper) {
        helper.sortBy(component, "Phoenix_Customer_Update_Approval__c");
    },
    sortByDatePostedInVistex: function(component, event, helper) {
        helper.sortBy(component, "Phoenix_Date_Posted_in_Vistex__c");
    },
    sortByVistexRemarks: function(component, event, helper) {
        helper.sortBy(component, "Phoenix_Vistex_Remarks__c");
    },
    
    doFilter: function(component, event, helper) {  
        //calling helper  
        helper.FilterRecords(component);  
    }, 
    
    
    onsearch: function(component, event, helper){
        var searchText = component.get("v.searchText"); 
        if(searchText == null || searchText == '' || searchText == undefined){
            component.set("v.pageSize", 10);
            component.set("v.wacData",component.get("v.UnfilteredData"));
            component.set("v.totalPages", Math.ceil(component.get("v.wacData").length/component.get("v.pageSize")));
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
                component.set("v.wacData",component.get("v.UnfilteredData"));
                component.set("v.totalPages", Math.ceil(component.get("v.wacData").length/component.get("v.pageSize")));
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
            component.set("v.wacData",component.get("v.UnfilteredData"));
            component.set("v.totalPages", Math.ceil(component.get("v.wacData").length/component.get("v.pageSize")));
            component.set("v.currentPageNumber",1);
            component.set("v.searchResults", []);
            component.set("v.filteredData", []);
            helper.buildData(component, event);
        }
    },
    downloadCsv: function (component, event, helper) {

        var ResultData = component.get("v.UnfilteredData");
        // call the helper function which "return" the CSV data as a String   
        var csv = helper.convertArrayOfObjectsToCSV(component, ResultData);
        if (csv == null) {
            return;
        }
        // ####--code for create a temp. <a> html tag [link tag] to download the CSV file--####     
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
        hiddenElement.download = 'WAC Export '+ '-' + Now + '.csv'; // CSV file Name* you can change it.[only name not .csv] 
        document.body.appendChild(hiddenElement); // Required for FireFox browser
        hiddenElement.click(); // using click() js function to download csv file
    },
    
    handleError:  function(component, event, helper) {
        //Get the error
        var error = event.getParams();
        console.log("Error : " + JSON.stringify(error));
        //Get the error message
        var errorMessage = event.getParam("message");
        console.log("Error Message : " + errorMessage);
    }
})