({
	doInit : function(component, event, helper) {
        let pageReference = component.get("v.pageReference");
        let recordId = pageReference.state.c__recordId;
        console.log('Do Init');
        if (recordId != null && recordId != undefined && recordId != '') {
            console.log('Record Id is not null: '+recordId);
            component.set("v.recordId", recordId);
            component.set("v.loaded", true);
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
            console.log('RecordID:: '+component.get("v.recordId"));
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
     onRecordSubmit: function (component, event, helper) {
        event.preventDefault();
        var eventFields = event.getParam("fields");
          eventFields["Phoenix_Marketing_Head__c"] = component.get("v.MarketingHeadUser");
          component.find("recordEditForm").submit(eventFields);
     },
    handleSuccess : function(component, event, helper) {
        var record = event.getParam("response");
     
        /* added by satya*/
        console.log('handle success response-->'+JSON.stringify(record));
        var gmperc =  component.get("v.GM");
        console.log('gmperc-->'+gmperc);
        var tpperc = component.get("v.TPT");
        console.log('tpperc-->'+tpperc);
        var revenue =component.get("v.NetSales");
           console.log('revenue-->'+revenue);
        if((gmperc >25 || tpperc > 40) && revenue<= 1000000){
        component.set("v.IsconditionMet", true);
        }
        
         console.log('IsconditionMet-->'+ component.get("v.IsconditionMet"));
        /* end by satya*/
        var apiName = record.apiName;
        var myRecordId = record.id;
        component.set("v.recordId", myRecordId); 
        console.log('Record Id::: '+myRecordId);
        var message = 'Record has been saved!';
        helper.showSuccessToast(component, event, message);
        if(myRecordId){
            component.set("v.showWACLines", true);
            component.find("navService").navigate({
                type: "standard__component",
                attributes: {
                    componentName: "c__Phoenix_New_Product_WAC_Pricing" },
                state: {
                    c__recordId: myRecordId
                    
                }
            }, true); // replace = true
            component.set("v.disableAllFields", true);
            component.set("v.disableUpload", false);
            component.set("v.isNoteAccept", true);
            component.set("v.disableSave", true);
            component.set("v.disableMarketingLeadSubmit", false);
            component.set("v.disableMarketingHeadSubmit", false);
            var data = component.get("v.productsData");
            if(data.length == 0){
                helper.getProducts(component, event);   
            }
        }
    },
    
    valueChangeAction: function(component, event, helper){
        component.set("v.disableSave", false);
    },
    
    reInit : function(component, event, helper) {
        $A.get('e.force:refreshView').fire();
    },
    
    acceptNote: function(component, event, helper){
        component.set("v.disableNoteButton", false);
        component.set("v.isNoteAccept", true);
    },
    
    disableSaveButton: function(component, event, helper){
        var isValueChanged = event.getParam("isValueChanged");
        if(isValueChanged == true){
            component.set("v.disableSaveLines", false);
            component.set("v.disableSubmit", false);   
        } else{
            component.set("v.disableSaveLines", true);
            component.set("v.disableSubmit", false);
        }
    },   
    
    handleSelectedProductFamily: function (component, event, helper) {
        // Get the string of the "value" attribute on the selected option
        var selectedOptionValue = event.getParam("value");
        var selectedOptionName = event.getParam("name");
        component.set("v.SelectedProductFamily", selectedOptionValue);
        helper.getProductInfo(component, event);
    },
    
    back: function(component, event, helper){
        var recordId = component.get("v.recordId");
        if(recordId == null || recordId == '' || recordId == undefined){
            var navService = component.find("navService");
            var pageReference = {
                type: 'standard__objectPage',
                attributes: {
                    objectApiName: 'New_Product_WAC_Pricing__c',
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
    
    saveLines: function(component, event, helper){
        var productsData = component.get("v.productsData");
        var containsEmptyRecord = '';
        for(var i=0; i<productsData.length; i++){
            if(productsData[i].Phoenix_WAC__c == '' || productsData[i].Phoenix_WAC__c == null || productsData[i].Phoenix_WAC__c == undefined
              || productsData[i].Phoenix_Lowest_Price__c == '' || productsData[i].Phoenix_Lowest_Price__c == null || productsData[i].Phoenix_Lowest_Price__c == undefined
              || productsData[i].Phoenix_TPT_GM__c == '' || productsData[i].Phoenix_TPT_GM__c == null || productsData[i].Phoenix_TPT_GM__c == undefined
              || ((productsData[i].Phoenix_Brand_WAC__c == '' || productsData[i].Phoenix_Brand_WAC__c == null || productsData[i].Phoenix_Brand_WAC__c == undefined) && productsData[i].Phoenix_Brand_WAC__c !=0)){
                containsEmptyRecord = true;
                var message = 'Please enter WAC, Brand WAC, Lowest Price and Margin';
                helper.showErrorToast(component, event, message);  
            }
            if(productsData[i].Phoenix_WAC__c < productsData[i].Phoenix_Lowest_Price__c){
                containsEmptyRecord = true;
                var message = 'Lowest Price should not be greater than WAC';
                helper.showErrorToast(component, event, message);                
            }
        }
        if(containsEmptyRecord != true){
            var action = component.get("c.saveLineItems");
            component.set("v.saveSpinner", true);
            action.setParams({
                'recordId': component.get("v.recordId"),
                'lineItems': component.get("v.productsData")
            });
            action.setCallback(this, function(response){
                if(response.getState() == 'SUCCESS'){
                    component.set("v.saveSpinner", false);
                    component.set("v.disableSubmit", true);
                    component.set("v.disableSaveLines", true);
                    var resp = response.getReturnValue();
                    var updatedData = [];
                    for(var i=0; i<resp.length; i++){
                        resp[i].ProductName = resp[i].Phoenix_Product__r.Name;
                        resp[i].TPT_GM = resp[i].Phoenix_TPT_GM__c / 100;
                        updatedData.push(resp[i]);
                    }
                    component.set("v.productsData", updatedData);
                    component.set("v.totalPages", Math.ceil(updatedData.length/component.get("v.pageSize")));
                    component.set("v.currentPageNumber",1);
                    helper.buildData(component, event);
                } else{
                    component.set("v.loaded", false);
                    console.log("Error "+JSON.stringify(response.getError()));
                }
            });
            $A.enqueueAction(action);   
        }
    },
    
    showFileUploadModal: function(component, event, helper){
        helper.showUploadModal(component, event, helper);
    },
    
    closeModal: function(component, event, helper){
        helper.closeModal(component, event, helper);
    },
    handleUploadFinished: function(component, event, helper){
		helper.handleUpload(component, event) ;
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
    
    sortByLineNumber: function(component, event, helper) {
        helper.sortBy(component, "Name");
    },
    sortByMaterialNumber: function(component, event, helper) {
        helper.sortBy(component, "Phoenix_Material_Number__c");
    },
    sortByNDC: function(component, event, helper) {
        helper.sortBy(component, "Phoenix_NDC_11__c");
    },
    sortByProduct: function(component, event, helper) {
        helper.sortBy(component, "Phoenix_Product__c");
    },
    sortByPackSize: function(component, event, helper) {
        helper.sortBy(component, "Phoenix_Pkg_Size__c");
    },
    sortByWAC: function(component, event, helper) {
        helper.sortBy(component, "Phoenix_WAC__c");
    },
    sortByBrandWAC: function(component, event, helper) {
        helper.sortBy(component, "Phoenix_Brand_WAC__c");
    },
    sortByLowestPrice: function(component, event, helper) {
        helper.sortBy(component, "Phoenix_Lowest_Price__c");
    },
    sortByTPTGM: function(component, event, helper){
        helper.sortBy(component, "Phoenix_TPT_GM__c");
    },
    
    openDeletePopup: function(component, event, helper){
        component.set("v.openDeletePopupModal", true);
    },
    /*deleteLines: function(component, event, helper){
        component.set("v.openDeletePopupModal", false);
        var data = component.get("v.productsData");
        var dataToBeDeletedFromDB = [];
        var dataToBeDeletedFromState = [];
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
        } else if(dataToBeDeletedFromState.length > 0){
            component.set("v.productsData", []);
            component.set("v.data", []);
            component.set("v.disableSaveLines", true);
            component.set("v.disableSubmit", false);
        }
    },*/
    
    removeDeletedRow: function(component, event, helper) {
        component.set("v.openDeletePopupModal", true);
        var index = event.getParam("indexVar"); 
        component.set("v.indexVar", index);
    },
    
    deleteLines: function(component, event, helper){
        var index = component.get("v.indexVar");    
        var AllLinesList = component.get("v.productsData");
        var rowToDelete = AllLinesList[index];
        if(rowToDelete){
         	component.set('v.deleteWACPricingLineId', rowToDelete.Id);   
            helper.deleteWACPricingLine(component, event);
        }
    },
    openSubmitModal: function(component, event, helper){
        component.set("v.showSubmitModal", true);
    },
    
    hideSubmitModel: function(component, event, helper){
    helper.closeModal(component, event);
},
     proceedToSubmit: function (component, event, helper) {
        if (component.get("v.ApprovalStatus") == 'Draft') {
            component.set('v.showSubmitModal', false);
            //var LineItemtable = component.find("LineTable");
           // $A.util.addClass(LineItemtable, "maintable");
            helper.getBidInfoForValids(component, event, helper);
        }
    },
    processMarketingLead: function (component, event, helper) {
        
      var finAppStatus=component.get("v.HeadOfMarketingApproval");
           console.log('finAppStatus----'+finAppStatus);
         if(finAppStatus!=null && finAppStatus!=undefined && finAppStatus!=''){
        //var approvalStatus=component.get("v.BidAprrovalStatus");
        var action = component.get("c.makeLeadApprovals");
        action.setParams({
            'bidId' : component.get("v.recordId"),
             'status':finAppStatus,
            'IsconditionMet': component.get("v.IsconditionMet"),
            'approveThruEmail': false,
            'currentUserDetails': null
           
           /* 'bidId' : component.get("v.recordId"),
             'status':finAppStatus,
            'IsconditionMet': component.get("v.IsconditionMet")*/
           
        });
        action.setCallback(this, function (response){
            if(response.getState() === "SUCCESS"){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type":"success",
                    "title": "Success",
                    "message": "Your Approvals are submitted successfully."
                });
                toastEvent.fire();
                
            }
            else{
                var errors = response.getError();
                console.log("Error message: -----------------------" +
                            errors[0].message);
            }
            
            component.find("navService").navigate({
                type: "standard__recordPage",
                attributes: {
                    recordId: component.get("v.recordId"),
                    actionName: "view"
                }
            }, false);
            $A.get('e.force:refreshView').fire();  
        });
        $A.enqueueAction(action);
         }
         else{
              var toastEvent = $A.get("e.force:showToast");
                                       toastEvent.setParams({
                                           "type":"warning",
                                           "title": "Failed!",
                                           "message": "Please confirm approval to proceed further"
                                       });
                                       toastEvent.fire(); 
         }
   
    
},
    
     processMarketingHead: function (component, event, helper) {
         var finAppStatus=component.get("v.HeadOfPMGrpApproval");
           console.log('finAppStatus----'+finAppStatus);
         if(finAppStatus!=null && finAppStatus!=undefined && finAppStatus!=''){
       
        var action = component.get("c.makeHeadApprovals");
        action.setParams({
               'bidId' : component.get("v.recordId"),
             'status':finAppStatus,
             'approveThruEmail': false,
            'currentUserDetails': null
           
           /* 'bidId' : component.get("v.recordId"),
             'status':finAppStatus*/
           
        });
        action.setCallback(this, function (response){
            if(response.getState() === "SUCCESS"){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type":"success",
                    "title": "Success",
                    "message": "Your Approvals are submitted successfully."
                });
                toastEvent.fire();
                
            }
            else{
                var errors = response.getError();
                console.log("Error message: -----------------------" +
                            errors[0].message);
            }
            
            component.find("navService").navigate({
                type: "standard__recordPage",
                attributes: {
                    recordId: component.get("v.recordId"),
                    actionName: "view"
                }
            }, false);
            $A.get('e.force:refreshView').fire();  
        });
        $A.enqueueAction(action);
         }
         else{
              var toastEvent = $A.get("e.force:showToast");
                                       toastEvent.setParams({
                                           "type":"warning",
                                           "title": "Failed!",
                                           "message": "Please confirm approval to proceed further"
                                       });
                                       toastEvent.fire(); 
         }
    
},
    
})