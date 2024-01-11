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
        component.find("Tabset").set("v.selectedTabId", 'EBLI');
        component.set("v.isSpecificCustomer", false);
        component.set("v.templateType", "");
        component.set('v.isSpinnerLoad', true);
        component.set('v.lstSelectedPDRecords', []);
        // component.set('v.selectedCntrcts',[]);
        component.set('v.lstSelectedRecords', []);
        component.set('v.showSaveCancelBtn', false);
        component.set('v.isRxChecked', false);
        component.set('v.isSRxChecked', false);
        component.set('v.isOtcChecked', false);
        component.set('v.RxSrxList', []);
        component.set("v.BidTypeVal", "");
        console.log('---' + component.find("bidCntrcts"));
        component.set('v.recordId', component.get("v.pageReference").state.c__id);
        console.log('---record--id--from url-' + component.get('v.recordId'));
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
                if (wrapperObj.productDirectorList != null) {
                    console.log("defaultlistOfProductDirectors----->" + wrapperObj.productDirectorList)
                    component.set('v.defaultlistOfProductDirectors', wrapperObj.productDirectorList);
                }
                component.set('v.defaultlistOfProductFamily', wrapperObj.productfamilyList);
                component.set("v.BidLineItemListAll", lineItemsList);
                component.set('v.isSpinnerLoad', false);
                component.set('v.hasDirectorLines', wrapperObj.hasDirectorLines);
                component.set("v.templateType", bidRecord.Phoenix_Customer_Type__c);
                component.set("v.bidNumber", bidRecord.Name);
                component.set("v.bidName", bidRecord.Phoenix_Bid_Name__c);
                component.set("v.bidType", bidRecord.Phoenix_Bid_Type__c);
                component.set("v.ItemsLength", lineItemsList.length);
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
                //var a= component.get("v.bidType");
                //console.log('checking-->'+a);
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
    initFinnaceCmp: function (component, event, helper) {
        var financeCmp = component.find('financeChildCmp');
        financeCmp.financeRefresh();
    },
    initSCMCmp: function (component, event, helper) {
        var SCMCmp = component.find('SCMChildCmp');
        SCMCmp.scmRefresh();
    },
	 hideSubmitModel : function(component, event, helper) { 
         component.set('v.submitModel',false);
        var LineItemtable = component.find("LineTable");
        $A.util.addClass(LineItemtable, "maintable");
    },
    proceedToSubmit : function(component, event, helper) { 
        if(component.get("v.BidAprrovalStatus")=='Draft'){
            component.set('v.submitModel',false);
            var LineItemtable = component.find("LineTable");
        $A.util.addClass(LineItemtable, "maintable");
            helper.getBidInfoForValids(component,event,helper);
        }
    },
    submitFor : function(component, event, helper) { 
           component.set('v.isSpinnerLoad',true);
            var qtyError;
            var action = component.get("c.getupdatedforExport");      
            action.setParams
            ({
                bidId: component.get("v.recordId")
            });
            action.setCallback(this, function(response) 
                               {
                                   if(response.getState()=="SUCCESS"){
                                       var bidlines =  response.getReturnValue();
                                       for(var i=0;i<bidlines.length;i++){
                                          if(component.get("v.isMarketingApprovePerson")==component.get("v.loggedInUserName") && (component.get("v.loggedInUserName")== bidlines[i].Phoenix_Product_Director1__c) &&  bidlines[i].Phoenix_ProposedContractBidPriceMktng__c==null ){
                                               qtyError='Please Enter Marketing Price';
                                               console.log('marketing Price');
                                               break;
                                           }
                                         
                                       }
                                   }
                                   if(qtyError){
                                       var toastEvent = $A.get("e.force:showToast");
                                       toastEvent.setParams({
                                           "title": "Error!",
                                           "type":"error",
                                           "message":qtyError
                                       });
                                       toastEvent.fire();
                                       component.set('v.isSpinnerLoad',false);
                                   }else{
                                       component.set('v.isSpinnerLoad',false);
                                       component.set('v.submitModel',true);
                                       var LineItemtable = component.find("LineTable");
                                       $A.util.removeClass(LineItemtable, "maintable");
                                       console.log(component.get('v.submitModel'));
                                       
                                   }
                               });
            $A.enqueueAction(action);
        
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

    },
    onRecordSubmit: function (component, event, helper) {
        event.preventDefault();
        component.find("bidForm").submit();

    },
    onRecordSuccess: function (component, event, helper) {
        console.log('sucess----' + event.getParam("response").id);
        component.set('v.isSpinnerLoad', true);
        console.log('after success return');
        var rebateHeader, feeHeader, marketingHeader;
        var rebatetype = component.find("headerRebateType");
        var feetype = component.find("headerFeeType");
        var marketingType = component.find("headerMarketingApproval");
        if (rebatetype != null) {
            rebateHeader = rebatetype.get("v.value");
        } else {
            rebateHeader = '';
        }
        if (feetype != null) {
            feeHeader = feetype.get("v.value");
        } else {
            feeHeader = '';
        }
        if (marketingType != null) {
            marketingHeader = marketingType.get("v.value");
        } else {
            marketingHeader = '';
        }

		console.log('marketingHeader-->'+marketingHeader)
        if (helper.requiredValidation(component, event)) {
            var action = component.get("c.saveLineItems");
            action.setParams({
                'LineItemList': component.get("v.BidLineItemListAll"),
                'LineItemId': component.get("v.recordId"),
                'rebateHeader': rebateHeader,
                'feeHeader': feeHeader,
                'isRebateChanged': component.get("v.isRebateChanged"),
                'isFeeChanged': component.get("v.isFeeChanged"),
                'marketingHeader': marketingHeader,
                'isMarketingChanged': component.get("v.isMarketingChanged")
            });
            action.setCallback(this, function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var storeResponse = response.getReturnValue();
                    //component.set("v.BidLineItemListAll", storeResponse);
                    component.set("v.showSaveCancelBtn", false);
                    component.set('v.isSpinnerLoad', false);
                    component.set("v.isRebateChanged", false);
                    component.set("v.isFeeChanged", false);
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
    saveDetails: function (component, event, helper) {
        var selectrcs = component.find('linesTable').getSelectedRows();
        var selectedCntrcts = component.get("v.selectedCntrcts");
        for (var i = 0; i < selectrcs.length; i++) {
            selectedCntrcts.push(selectrcs[i].Name);
        }
        component.set("v.selectedCntrcts", selectedCntrcts);
        component.set("v.showModal", false);
        var LineItemtable = component.find("LineTable");
        $A.util.addClass(LineItemtable, "maintable");
        component.set("v.showSaveCancelBtn", true);
        //helper.getNPRDataOfContracts(component, event, helper,selectrcs);
    },
    hideModel: function (component, event, helper) {
        component.set("v.showModal", false);
        var LineItemtable = component.find("LineTable");
        $A.util.addClass(LineItemtable, "maintable");
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
    onMarketingChange: function (component, event, helper) {
        component.set("v.showSaveCancelBtn", true);
        component.set("v.isMarketingChanged", true);
    },
    downloadCsv: function (component, event, helper) {

        var ResultData = component.get("v.BidLineItemListAll");
        var template = component.get("v.templateType");
        console.log("teplate--->" + template);
        var bidNumber = component.get("v.bidNumber");
        var bidName = component.get("v.bidName");
        var bidtype = component.get("v.bidType");

        // call the helper function which "return" the CSV data as a String   
        var csv = helper.convertArrayOfObjectsToCSV(component, ResultData, template, bidtype);
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
        hiddenElement.download = 'Sales & Marketing' + '-' + bidNumber + '-' + bidName + '-' + Now + '.csv'; // CSV file Name* you can change it.[only name not .csv] 
        document.body.appendChild(hiddenElement); // Required for FireFox browser
        hiddenElement.click(); // using click() js function to download csv file
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
    onblurProDir: function (component, event, helper) {
        var toggleclass = component.find("zvalue");
        $A.util.addClass(toggleclass, "zindex");
        var toggleclasspkg = component.find("zvaluePkg");
        $A.util.addClass(toggleclasspkg, "zindexPkg");
        var toggleclassPrd = component.find("zvaluePrd");
        $A.util.addClass(toggleclassPrd, "zindexPrd");
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
        var toggleclass = component.find("zvalue");
        $A.util.removeClass(toggleclass, "zindex");
        var toggleclasspkg = component.find("zvaluePkg");
        $A.util.removeClass(toggleclasspkg, "zindexPkg");
        var toggleclassPrd = component.find("zvaluePrd");
        $A.util.removeClass(toggleclassPrd, "zindexPrd");
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
    initContractsView: function (component, event, helper) {
        var rejectedStatus = component.find('ContractsTab');
        rejectedStatus.ContractsViewRefresh();
    },
    saveToProceedContracts: function (component, event, helper) {
        var isContracts = true;
        helper.submitForProceed(component, event, helper, isContracts);
    },
    saveToProceed: function (component, event, helper) {
        var isContracts = false;
        helper.submitForProceed(component, event, helper, isContracts);
    },
    initRejectedView: function (component, event, helper) {
        var rejectedStatus = component.find('RejectedStatusTab');
        rejectedStatus.refreshRejectedTab();
    },
})