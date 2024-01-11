/**
 * @description       : 
 * @author            : Surender Patel (Dhruvsoft)
 * @group             : 
 * @last modified on  : 29-05-2021
 * @last modified by  : Surender Patel (Dhruvsoft)
 * Modifications Log 
 * Ver   Date         Author                       Modification
 * 1.0   29-05-2021   Surender Patel (Dhruvsoft)   Initial Version
**/
({

    initRecords: function (component, event, helper) {

        component.set("v.isSpecificCustomer", false);
        component.set("v.templateType", "");
        component.set('v.isSpinnerLoad', true);
        component.set('v.selectedCntrcts', []);
        component.set('v.lstSelectedRecords', []);
        component.set('v.lstSelectedPDRecords', []);
        component.set('v.showSaveCancelBtn', false);
        component.set('v.isRxChecked', false);
        component.set('v.isSRxChecked', false);
        component.set('v.isOtcChecked', false);
        component.set('v.RxSrxList', []);
        component.set("v.BidTypeVal", "");
        component.set("v.isOpen", false);
        console.log('---' + component.find("bidCntrcts"));
        var action = component.get("c.getRelatedList");
        action.setParams({
            bidId: component.get("v.recordId")
        });
        action.setCallback(this, function (response) {
            if (response.getState() == "SUCCESS") {
                var wrapperObj = response.getReturnValue();
                var lineItemsList = wrapperObj.lineItemsList;
                var columnList = wrapperObj.columnList;
                var bidRecord = wrapperObj.bidRecord;
                var loggedinUserName = wrapperObj.loggedInUserName;
                var isMarketingApprovePerson = wrapperObj.isMarketingApprovePerson;
                var isContractsApprovePerson = wrapperObj.isContractsApprovePerson;
                var showProceedBtn = wrapperObj.showProceedBtn;
                console.log('isContractsApprovePerson---' + isContractsApprovePerson);
                component.set("v.isMarketingApprovePerson", isMarketingApprovePerson);
                component.set("v.isContractsApprovePerson", isContractsApprovePerson);
                component.set("v.showProceedBtn", showProceedBtn);
                if (lineItemsList.length == 0 || component.get("v.recordId") == null) {
                    component.set("v.isRelatedLineItemsEmpty", false);
                }

                component.set('v.defaultlistOfProductFamily', wrapperObj.productfamilyList);
                if (wrapperObj.productDirectorList != null) {
                    component.set('v.defaultlistOfProductDirectors', wrapperObj.productDirectorList);
                }

                component.set("v.BidLineItemListAll", lineItemsList);
                component.set('v.isSpinnerLoad', false);
                component.set("v.templateType", bidRecord.Phoenix_Customer_Type__c);
                component.set("v.customerId", bidRecord.Phoenix_Customer__r.Id);
                component.set("v.approvalStatus", bidRecord.Phoenix_Approval_Status__c);
                component.set("v.bidType", bidRecord.Phoenix_Bid_Type__c);
                component.set("v.bidNumber", bidRecord.Name);
                component.set("v.bidName", bidRecord.Phoenix_Bid_Name__c);
                console.log('refcontrcts--' + bidRecord.Phoenix_Reference_Contracts__c);
                if (bidRecord.Phoenix_Reference_Contracts__c != null && bidRecord.Phoenix_Reference_Contracts__c != undefined) {
                    var refContracts = bidRecord.Phoenix_Reference_Contracts__c;
                    component.set("v.selectedCntrcts", refContracts.split(','));
                }
                console.log('bidRecord.Phoenix_Bid_Type__c---' + bidRecord.Phoenix_Bid_Type__c);
                if (bidRecord.Phoenix_Bid_Type__c != null && bidRecord.Phoenix_Bid_Type__c != undefined) {
                    component.set("v.BidTypeVal", bidRecord.Phoenix_Bid_Type__c);
                }
                console.log('bidRecord.Phoenix_Approval_Status__c---' + bidRecord.Phoenix_Approval_Status__c);
                if (bidRecord.Phoenix_Approval_Status__c != null && bidRecord.Phoenix_Approval_Status__c != undefined) {
                    component.set("v.BidAprrovalStatus", bidRecord.Phoenix_Approval_Status__c);
                }
                console.log('loggedinUserName--' + loggedinUserName);
                if (loggedinUserName != null && loggedinUserName != undefined) {
                    component.set("v.loggedInUserName", loggedinUserName);
                }

                var OutDiv = component.find("mainDiv");
                if (lineItemsList.length < 10) {
                    console.log('--no-hight---');
                    $A.util.addClass(OutDiv, "noheightClass");
                } else {
                    $A.util.removeClass(OutDiv, "noheightClass");
                }
            } else {
                component.set('v.isSpinnerLoad', false);
            }
        });
        $A.enqueueAction(action);

    },

    openModel: function (component, event, helper) {
        var appStatus = component.get("v.approvalStatus");
        console.log('Approval Status:::: ' + appStatus);
        if (appStatus == 'Contracts' || appStatus == 'Customer' || appStatus == "Customer's Update" || appStatus == 'Vistex Update' || appStatus == 'Closed') {
            component.set("v.isOpen", true);
        } else {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title: 'Error',
                message: 'You can only generate offer document when in Contracts stage or later stage',
                duration: ' 5000',
                key: 'info_alt',
                type: 'error'
            });
            toastEvent.fire();
        }
    },


    initFinnaceCmp: function (component, event, helper) {
        var financeCmp = component.find('financeChildCmp');
        financeCmp.financeRefresh();
    },
    AddFiles: function (component, event, helper) {
        component.set("v.showModal", true);
        component.set("v.fileList", []);
        var LineItemtable = component.find("LineTable");
        $A.util.removeClass(LineItemtable, "contractTable");
        var action = component.get('c.getExistingDocs');
        action.setParams({
            'bidId': component.get("v.recordId")
        });

        action.setCallback(this, function (response) {
            var state = response.getState();
            console.log(state)
            console.log(state)
            if (state === "SUCCESS") {
                var fileList = [];
                var totalFiles = [];
                var checked = false;
                totalFiles = response.getReturnValue();
                if (totalFiles != undefined && totalFiles != null && totalFiles != '') {
                    for (var i = 0; i < totalFiles.length; i++) {
                        console.log('totalFiles[i]------>' + totalFiles[i].ContentDocument.Title);
                        fileList.push({
                            "Id": totalFiles[i].ContentDocumentId,
                            "Title": totalFiles[i].ContentDocument.Title + '.' + totalFiles[i].ContentDocument.FileExtension,
                            "checked": checked
                        });
                    }
                }
                console.log('------1-----');
                component.set("v.RelatedFilesList", fileList);
                component.set("v.showFiles", true);
            }
            if (state === "ERROR") {
                // component.set("v.isTSNotCreated","true");
            }

        });
        $A.enqueueAction(action);

    },
    handleUploadFinished: function (component, event, helper) {
        var uploadedFiles = event.getParam("files");
        var fieleListUpdated = [];
        fieleListUpdated = uploadedFiles;
        var fileList = component.get('v.fileList');
        if (fileList.length > 0) {
            fieleListUpdated.push.apply(fieleListUpdated, fileList);
        }
        component.set('v.fileList', fieleListUpdated);
    },
    deleteAttachment: function (component, event, helper) {
        component.set('v.isSpinnerLoad', true);
        var LineItemIds = [];
        var selectedRec = event.getSource().get("v.name");
        console.log('selectedRec::' + selectedRec);
        LineItemIds.push(selectedRec);
        var action = component.get("c.deleteAttachmentList");
        action.setParams({
            'LineItemIds': LineItemIds
        });
        action.setCallback(this, function (response) {
            console.log('inside::-->deleteAttachmentList');
            var state = response.getState();
            if (state == 'SUCCESS') {
                component.set('v.isSpinnerLoad', false);
                console.log('response::' + response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
        var AllRowsList = component.get("v.fileList");
        for (let i = 0; i < AllRowsList.length; i++) {
            var pItem = AllRowsList[i];
            if (pItem.documentId == selectedRec) {
                var index = AllRowsList.indexOf(pItem);
                if (index > -1) {
                    AllRowsList.splice(index, 1);
                    var AllRowsList1 = AllRowsList;
                }
            }
        }
        component.set("v.fileList", []);
        component.set("v.fileList", AllRowsList);
    },
    hideModel: function (component, event, helper) {
        component.set("v.showModal", false);
        var LineItemtable = component.find("LineTable");
        $A.util.addClass(LineItemtable, "contractTable");

    },
    initSCMCmp: function (component, event, helper) {
        var SCMCmp = component.find('SCMChildCmp');
        SCMCmp.scmRefresh();
    },
    initRejectedStatus: function (component, event, helper) {
        var rejectedStatus = component.find('RejectedStatusChildCmp');
        rejectedStatus.rejectedStatusRefresh();
    },
    backToBid: function (component, event, helper) {
        component.find("navigationService").navigate({
            type: "standard__recordPage",
            attributes: {
                recordId: component.get("v.recordId"),
                actionName: "view"
            }
        }, false);

    },
    handleOnload: function (component, event, helper) {
        var recUi = event.getParam("recordUi");
        /* var customer= recUi.record.fields["Phoenix_Customer__c"].value;
          if(recUi.record.fields["Phoenix_Customer_Type__c"].value!=null && recUi.record.fields["Phoenix_Customer_Type__c"].value!=undefined){
             component.set("v.templateType",recUi.record.fields["Phoenix_Customer_Type__c"].value);
         }       
         component.set("v.bidNumber",recUi.record.fields["Name"].value);
         component.set("v.bidName",recUi.record.fields["Phoenix_Bid_Name__c"].value);      
         var selectedContractsLoad=recUi.record.fields["Phoenix_Reference_Contracts__c"].value; 
         if(selectedContractsLoad!=null){
             component.set("v.selectedCntrcts",selectedContractsLoad.split(','));  
         }*/
    },
    onRecordSubmit: function (component, event, helper) {
        event.preventDefault();
        var eventFields = event.getParam("fields");
        var slctCntrcts = component.get("v.selectedCntrcts");
        /* var cntrctstring='';
        for(var i=0;i<slctCntrcts.length;i++){
            if(i==0){
                cntrctstring=slctCntrcts[i].Name;
            }else{
                cntrctstring+=','+slctCntrcts[i].Name;
            }
        }*/
        eventFields["Phoenix_Reference_Contracts__c"] = slctCntrcts.toString();
        var currentCd = eventFields["Phoenix_Current_CD__c"];
        eventFields["Phoenix_Reference_Contracts__c"] = slctCntrcts.toString();
        var currentCd = eventFields["Phoenix_Current_CD__c"];
        var customerSentDate = eventFields["Phoenix_Sent_to_Customer_Date__c"];
        if(customerSentDate != null && customerSentDate != ''){
            component.find("bidForm").submit(eventFields);
            component.set("v.customerRespDateEntered",true);
        }else{
            component.set("v.customerRespDateEntered",false);
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title: 'Error',
                message: 'Please enter sent to customer date',
                duration: ' 5000',
                key: 'info_alt',
                type: 'error'
            });
            toastEvent.fire();

        }
        //component.find("bidForm").submit(eventFields);
        //helper.getNPRDataOfContracts(component, event, helper,slctCntrcts,component.get("v.templateType"));

    },
    onRecordSuccess: function (component, event, helper) {
        console.log('sucess----' + event.getParam("response").id);
        component.set('v.isSpinnerLoad', true);
        console.log('after success return');
        var rebateHeader, feeHeader, contractApproval;
        var rebatetype = component.find("headerRebateType");
        var feetype = component.find("headerFeeType");
        var contractApprovaltype = component.find("headerContractApproval");
        if (rebatetype != null) {
            console.log('rebatetype.get("v.value")-->' + rebatetype.get("v.value"))
            rebateHeader = rebatetype.get("v.value");
        } else {
            rebateHeader = '';
        }
        if (feetype != null) {
            feeHeader = feetype.get("v.value");
        } else {
            feeHeader = '';
        }
        if (contractApprovaltype != null) {
            contractApproval = contractApprovaltype.get("v.value");
        } else {
            contractApproval = '';
        }


        if (helper.requiredValidation(component, event)) {
            var action = component.get("c.saveLineItems");
            action.setParams({
                'LineItemList': component.get("v.BidLineItemListAll"),
                'LineItemId': component.get("v.recordId"),
                'rebateHeader': rebateHeader,
                'feeHeader': feeHeader,
                'contractApproval': contractApproval,
                'isRebateChanged': component.get("v.isRebateChanged"),
                'isFeeChanged': component.get("v.isFeeChanged"),
                'isApprovalChanged': component.get("v.isApprovalChanged")
            });
            action.setCallback(this, function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var storeResponse = response.getReturnValue();
                    //component.set("v.BidLineItemListAll", storeResponse);
                    component.set("v.showSaveCancelBtn", false);
                    component.set('v.isSpinnerLoad', false);
                    helper.searchProductFamilyChange(component, event, helper);
                    console.log('after success-return');
                } else {
                    component.set("v.showSaveCancelBtn", false);
                    component.set('v.isSpinnerLoad', false);
                }
            });
            $A.enqueueAction(action);
        }
        // helper.searchProductFamilyChange(component, event,helper);
    },
    Save: function (component, event, helper) {
        // component.find("bidForm").submit();        
    },
    showModel: function (component, event, helper) {
        var LineItemtable = component.find("LineTable");
        console.log('modalstart---' + LineItemtable);
        $A.util.removeClass(LineItemtable, "contractTable");
        component.set("v.showModal", true);
        component.set('v.mycolumns', [{
                label: 'Name',
                fieldName: 'Name',
                type: 'text'
            },
            {
                label: 'Internal Description',
                fieldName: 'Phoenix_Contract_Internal_Description__c',
                type: 'text'
            },
            {
                label: 'External Description',
                fieldName: 'Phoenix_Contract_External_Description__c',
                type: 'Text'
            }
        ]);
        var searchInput = component.find("cntInput").get("v.value");
        console.log('--searchInput--' + searchInput);
        var bidCustomer = component.find("bidCustm").get("v.value");
        console.log('--bidCustomer--' + bidCustomer);
        if (bidCustomer != null && bidCustomer != undefined) {
            helper.fetchContratcs(component, event, helper, bidCustomer, searchInput);
        } else {
            component.set("v.contratcsList", null);
        }
    },
    searchContracts: function (component, event, helper) {
        var searchInput = component.find("cntInput").get("v.value");
        console.log('searchInput---' + searchInput);
        var checkToggle = component.find("tgleCntrct").get("v.checked");
        var bidCustomer = component.find("bidCustm").get("v.value");
        console.log('--bidCustomer--' + bidCustomer);
        if (checkToggle == true) {
            helper.fetchContratcs(component, event, helper, null, searchInput);
        } else {
            if (bidCustomer != null && bidCustomer != undefined) {
                helper.fetchContratcs(component, event, helper, bidCustomer, searchInput);
            } else {
                component.set("v.contratcsList", null);
            }
        }
        /* if(checkToggle==true && bidCustomer!=null && bidCustomer!=undefined){
            helper.fetchContratcs(component, event,helper,bidCustomer,searchInput);
        }
        else if(checkToggle==true && (bidCustomer==null ||  bidCustomer==undefined)){
            component.set("v.contratcsList",null);
        }else{
            helper.fetchContratcs(component, event,helper,null,searchInput);
        }*/

    },
    saveDetails: function (component, event, helper) {
        var selectrcs = component.find('linesTable').getSelectedRows();
        var selectedCntrcts = component.get("v.selectedCntrcts");
        for (var i = 0; i < selectrcs.length; i++) {
            selectedCntrcts.push(selectrcs[i].Name);
        }
        component.set("v.selectedCntrcts", selectedCntrcts);
        component.set("v.showModal", false);
        var LineItemtable = component.find("LineTable");
        $A.util.addClass(LineItemtable, "contractTable");
        component.set("v.showSaveCancelBtn", true);
        //helper.getNPRDataOfContracts(component, event, helper,selectrcs);
    },
    clearCntract: function (component, event, heplper) {
        var selectedPillId = event.getSource().get("v.name");
        var AllPillsList = component.get("v.selectedCntrcts");

        for (var i = 0; i < AllPillsList.length; i++) {
            if (AllPillsList[i] == selectedPillId) {
                AllPillsList.splice(i, 1);
                component.set("v.selectedCntrcts", AllPillsList);
            }
        }
        component.set("v.showSaveCancelBtn", true);
    },
    hideModel: function (component, event, helper) {
        component.set("v.showModal", false);
        var LineItemtable = component.find("LineTable");
        $A.util.addClass(LineItemtable, "contractTable");
    },
    cancel: function (component, event, helper) {
        $A.get('e.force:refreshView').fire();
    },
    showSaveCancel: function (component, event, helper) {
        component.set("v.showSaveCancelBtn", true);
    },
    SaveAndNavigate: function (component, event, helper) {
        $A.enqueueAction(component.get('c.onRecordSubmit'));
        component.find("navigationService").navigate({
            type: "standard__recordPage",
            attributes: {
                recordId: component.get("v.recordId"),
                actionName: "view"
            }
        }, false);
    },
    handleEvent: function (component, event, helper) {
        component.set('v.isSpinnerLoad', true);
        var message = event.getParam("message");
        var action = component.get("c.getRelatedList");
        action.setParams({
            bidId: component.get("v.recordId")
        });
        action.setCallback(this, function (response) {
            var wrapperObj = response.getReturnValue();
            var lineItemsList = wrapperObj.lineItemsList;
            component.set("v.BidLineItemListAll", lineItemsList);
            component.set('v.isSpinnerLoad', false);
            var OutDiv = component.find("mainDiv");
            if (lineItemsList.length < 10) {
                console.log('--no-hight---');
                $A.util.addClass(OutDiv, "noheightClass");
            } else {
                $A.util.removeClass(OutDiv, "noheightClass");
            }
        });
        $A.enqueueAction(action);
    },
    searchProFamilyChange: function (component, event, helper) {

        helper.searchProductFamilyChange(component, event, helper);
    },
    onblur: function (component, event, helper) {
        // on mouse leave clear the listOfSeachRecords & hide the search result component 
        component.set("v.listOfSearchRecords", null);
        component.set("v.SearchKeyWord", '');
        var forclose = component.find("searchRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
    },
    onfocus: function (component, event, helper) {
        // show the spinner,show child search result component and call helper function
        $A.util.addClass(component.find("mySpinner"), "slds-show");
        component.set("v.listOfSearchRecords", null);
        var forOpen = component.find("searchRes");
        $A.util.addClass(forOpen, 'slds-is-open');
        $A.util.removeClass(forOpen, 'slds-is-close');
        // Get Default 5 Records order by createdDate DESC 
        var getInputkeyWord = '';
        helper.searchHelper(component, event, getInputkeyWord);
    },
    keyPressController: function (component, event, helper) {
        $A.util.addClass(component.find("mySpinner"), "slds-show");
        // get the search Input keyword   
        var getInputkeyWord = component.get("v.SearchKeyWord");
        // check if getInputKeyWord size id more then 0 then open the lookup result List and 
        // call the helper 
        // else close the lookup result List part.   
        if (getInputkeyWord.length > 0) {
            var forOpen = component.find("searchRes");
            $A.util.addClass(forOpen, 'slds-is-open');
            $A.util.removeClass(forOpen, 'slds-is-close');
            helper.searchHelper(component, event, getInputkeyWord);
        } else {
            component.set("v.listOfSearchRecords", null);
            var forclose = component.find("searchRes");
            $A.util.addClass(forclose, 'slds-is-close');
            $A.util.removeClass(forclose, 'slds-is-open');
        }
    },
    // function for clear the Record Selaction 
    clear: function (component, event, heplper) {
        var selectedPillId = event.getSource().get("v.name");
        var AllPillsList = component.get("v.lstSelectedRecords");

        for (var i = 0; i < AllPillsList.length; i++) {
            if (AllPillsList[i] == selectedPillId) {
                AllPillsList.splice(i, 1);
                component.set("v.lstSelectedRecords", AllPillsList);
            }
        }
        component.set("v.SearchKeyWord", null);
        component.set("v.listOfSearchRecords", null);
    },
    // This function call when the end User Select any record from the result list.   
    handleComponentEvent: function (component, event, helper) {
        component.set("v.SearchKeyWord", null);
        // get the selected object record from the COMPONENT event 	 
        var listSelectedItems = component.get("v.lstSelectedRecords");
        var selectedAccountGetFromEvent = event.getParam("recordByEvent");
        console.log('selectedAccountGetFromEvent---' + selectedAccountGetFromEvent);
        listSelectedItems.push(selectedAccountGetFromEvent);
        component.set("v.lstSelectedRecords", listSelectedItems);

        var forclose = component.find("lookup-pill");
        $A.util.addClass(forclose, 'slds-show');
        $A.util.removeClass(forclose, 'slds-hide');

        var forclose = component.find("searchRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
    },
    onblurProDir: function (component, event, helper) {
        // on mouse leave clear the listOfSeachRecords & hide the search result component 
        component.set("v.listOfSearchPDRecords", null);
        component.set("v.SearchKeyWordPD", '');
        var forclose = component.find("searchResPD");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
    },
    onfocusProdDir: function (component, event, helper) {
        // show the spinner,show child search result component and call helper function
        $A.util.addClass(component.find("mySpinner"), "slds-show");
        component.set("v.listOfSearchPDRecords", null);
        var forOpen = component.find("searchResPD");
        $A.util.addClass(forOpen, 'slds-is-open');
        $A.util.removeClass(forOpen, 'slds-is-close');
        // Get Default 5 Records order by createdDate DESC 
        var getInputkeyWord = '';
        helper.searchHelperProdDir(component, event, getInputkeyWord);
    },
    keyPressControllerProdDir: function (component, event, helper) {
        $A.util.addClass(component.find("mySpinner"), "slds-show");
        // get the search Input keyword   
        var getInputkeyWord = component.get("v.SearchKeyWordPD");
        // check if getInputKeyWord size id more then 0 then open the lookup result List and 
        // call the helper 
        // else close the lookup result List part.   
        if (getInputkeyWord.length > 0) {
            var forOpen = component.find("searchResPD");
            $A.util.addClass(forOpen, 'slds-is-open');
            $A.util.removeClass(forOpen, 'slds-is-close');
            helper.searchHelperProdDir(component, event, getInputkeyWord);
        } else {
            component.set("v.listOfSearchPDRecords", null);
            var forclose = component.find("searchResPD");
            $A.util.addClass(forclose, 'slds-is-close');
            $A.util.removeClass(forclose, 'slds-is-open');
        }
    },
    // function for clear the Record Selaction 
    clearProdDir: function (component, event, heplper) {
        var selectedPillId = event.getSource().get("v.name");
        var AllPillsList = component.get("v.lstSelectedPDRecords");

        for (var i = 0; i < AllPillsList.length; i++) {
            if (AllPillsList[i] == selectedPillId) {
                AllPillsList.splice(i, 1);
                component.set("v.lstSelectedPDRecords", AllPillsList);
            }
        }
        component.set("v.SearchKeyWordPD", null);
        component.set("v.listOfSearchPDRecords", null);
    },
    // This function call when the end User Select any record from the result list.   
    handleComponentEventProdDir: function (component, event, helper) {
        component.set("v.SearchKeyWordPD", null);
        // get the selected object record from the COMPONENT event 	 
        var listSelectedItems = component.get("v.lstSelectedPDRecords");
        var selectedAccountGetFromEvent = event.getParam("PDrecordByEvent");
        listSelectedItems.push(selectedAccountGetFromEvent);
        component.set("v.lstSelectedPDRecords", listSelectedItems);

        var forclose = component.find("lookup-pill-PD");
        $A.util.addClass(forclose, 'slds-show');
        $A.util.removeClass(forclose, 'slds-hide');

        var forclose = component.find("searchResPD");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
    },
    searchSrxRxOttc: function (component, event, helper) {
        var picliList = component.get('v.RxSrxList');
        if (component.get("v.isRxChecked") && !picliList.includes('Rx')) {
            console.log('I am Rx')
            picliList.push('Rx');
        }
        if (component.get("v.isSRxChecked") && !picliList.includes('SRx')) {
            picliList.push('SRx');
        }
        if (component.get("v.isOtcChecked") && !picliList.includes('OTC')) {
            picliList.push('OTC');
        }
        if (component.get("v.isRxChecked") == false && picliList.includes('Rx')) {
            var ind = picliList.indexOf('Rx')
            picliList.splice(ind, 1);
        }
        if (component.get("v.isSRxChecked") == false && picliList.includes('SRx')) {
            var ind = picliList.indexOf('SRx')
            picliList.splice(ind, 1);
        }
        if (component.get("v.isOtcChecked") == false && picliList.includes('OTC')) {
            var ind = picliList.indexOf('OTC')
            picliList.splice(ind, 1);
        }
        component.set("v.RxSrxList", picliList);
        console.log('picliList----->' + picliList);
    },
    searchSRxOtc: function (component, event, helper) {
        if (component.get("v.RxSrxList").length > 0) {
            var action = component.get("c.findBySrxOtc");
            action.setParams({
                "searchKey": component.get("v.RxSrxList"),
                "lineItemId": component.get("v.recordId")
            });
            action.setCallback(this, function (a) {
                var lineItemsList = a.getReturnValue();
                component.set("v.BidLineItemListAll", lineItemsList);
                var OutDiv = component.find("mainDiv");
                if (lineItemsList.length < 10) {
                    console.log('--no-hight---');
                    $A.util.addClass(OutDiv, "noheightClass");
                } else {
                    console.log('---hight---');
                    $A.util.removeClass(OutDiv, "noheightClass");
                }
            });
            $A.enqueueAction(action);
        } else {
            $A.enqueueAction(component.get('c.initRecords'));
        }
    },
    onRebateChange: function (component, event, helper) {
        component.set("v.showSaveCancelBtn", true);
        component.set("v.isRebateChanged", true);
    },
    onFeeChange: function (component, event, helper) {
        component.set("v.showSaveCancelBtn", true);
        component.set("v.isFeeChanged", true);
    },
    onApprovalChange: function (component, event, helper) {
        component.set("v.showSaveCancelBtn", true);
        component.set("v.isApprovalChanged", true);
    },
    downloadCsv: function (component, event, helper) {

        var action = component.get("c.getupdatedforExport");
        action.setParams({
            "bidId": component.get("v.recordId")
        });
        action.setCallback(this, function (a) {
            var isReBid = component.get("v.isReBid");
            console.log('isReBid--->' + isReBid);
            var ResultData = a.getReturnValue();
            
            var template = component.get("v.templateType");
            var BidType = component.get("v.BidTypeVal");
            var bidNumber = component.get("v.bidNumber");
            var bidName = component.get("v.bidName");
            // call the helper function which "return" the CSV data as a String   
            var csv = helper.convertArrayOfObjectsToCSV(component, ResultData, template, BidType);
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
            hiddenElement.download = 'Contracts View' + '-' + bidNumber + '-' + bidName + '-' + Now + '.csv'; // CSV file Name* you can change it.[only name not .csv] 
            document.body.appendChild(hiddenElement); // Required for FireFox browser
            hiddenElement.click(); // using click() js function to download csv file
        });
        $A.enqueueAction(action);
    },
    saveToProceed: function (component, event, helper) {
        var isContracts = false;
        helper.submitForProceed(component, event, helper, isContracts);
    },
    saveToProceedContracts: function (component, event, helper) {
        var customerDateEntered = component.get("v.customerRespDateEntered");
        if(customerDateEntered){
            var isContracts = true;
            helper.submitForProceed(component, event, helper, isContracts);
        }
        else{
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title: 'Error',
                message: 'Please enter sent to customer date',
                duration: ' 5000',
                key: 'info_alt',
                type: 'error'
            });
            toastEvent.fire();
        }
    }

})