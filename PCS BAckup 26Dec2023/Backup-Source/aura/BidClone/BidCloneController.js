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
    doInit: function (component, event, helper) {
        console.log('>>>>>>>Call DO INIT>>>>>>');
        var Status = component.get("v.simpleRecord").Phoenix_Approval_Status__c;
        var recTypeName = component.get("v.simpleRecord").Phoenix_Bid_Type__c;
        component.set("v.bidType", recTypeName);
        console.log('>>>>>>>Status>>>>>>', Status);
        console.log('>>>>>>>recTypeName>>>>>>', recTypeName);
        if ((Status == 'Customer' || Status == 'Customer\'s Update' || Status == 'Closed') && (recTypeName == 'New Customer' || recTypeName == 'RFP Bids' || recTypeName == 'Product Addition' || recTypeName == 'Price Change' || recTypeName == 'Short Dated OTB' || recTypeName == 'Good Dated OTB' ||recTypeName == 'New Product Launch' || recTypeName == 'One Time Buy Good Dated Shelf Life for New Product Launch')) {
            helper.getBidPicklistVals(component, helper);
            helper.getBidDetails(component, helper);
            //  helper.fetchBLI(component, event, helper);
            component.set("v.isPopup", true);
        } else {
            console.log('>>>>>>>>>>>>DoINIT Else>>>>>>>>>>>>>>>');
            var errorMsg = 'Error: You can not create a Rebid for this record.';
            component.set("v.errorMessage", errorMsg)
        }
    },


    duplicateBid: function (component, event, helper) {
        component.set("v.showSpinnerSelProds1",true);

        var recId = component.get("v.recordId");
        console.log('>>>>recId>>>>>' + recId);
        var bidName = component.get("v.bidName");
        var interTargetD = component.get("v.interTargetD");
        var deadLineDate = component.get("v.deadLineDate");
        var deadLineTimeZone = component.get("v.deadLineTZone");
        var deadLineTim = component.get("v.deadLineTim");


        var allData = component.get("v.Allproduct");
        var bidlines = [];
        for (var x = 0; x < allData.length; x++) {
            var pData = allData[x];
            if (pData) {
                if (pData.isSelected == true)
                    bidlines.push(pData.qlItem);
            }
        }

        console.log('>>>>bidlines>>>>>' + JSON.stringify(bidlines));

        var DupAction = component.get("c.processRebid");
        DupAction.setParams({
            bidId: recId,
            SelectedbidLIItem: bidlines,
            reBidName: bidName,
            internalTD: interTargetD,
            deadLineDate: deadLineDate,
            deadLineTimeZ: deadLineTimeZone,
            deadLineT: deadLineTim
        });

        DupAction.setCallback(this, function (dupres) {
            console.log('===duplicate state======' + dupres.getState());
            var dupState = dupres.getState();
            var reslist = dupres.getReturnValue();
            console.log('===duplicate respones result======' + JSON.stringify(reslist));
            if (dupState === "SUCCESS") {
                if (reslist[0] == "false") {
                    helper.showToast({
                        "type": "success",
                        "message": 'Rebid record create successfully.'
                    });

                    var navEvt = $A.get("e.force:navigateToSObject");
                    navEvt.setParams({
                        "recordId": reslist[1],
                        "slideDevName": "detail"
                    });
                    navEvt.fire();
                } else if (reslist[0] == "true") {
                    helper.showToast({
                        "title": "Error!!",
                        "type": "error",
                        "message": reslist[1]
                    });
                }
                component.set("v.showSpinnerSelProds1",false);

            } else {
                component.set("v.showSpinnerSelProds1",false);
                console.log('>>>>>> Error >>>>>>>>>>', dupres.getError()[0].message);
                var errors = dupres.getError();
                helper.showToast({
                    "title": "Error!!",
                    "type": "error",
                    "message": errors[0].message
                });
            }

        });

        $A.enqueueAction(DupAction);
    },
    
    createOpty : function(component, event, helper){
        var allData = component.get("v.Allproduct");
        var bidlines = [];
        for (var x = 0; x < allData.length; x++) {
            var pData = allData[x];
            if (pData) {
                if (pData.isSelected == true)
                    bidlines.push(pData.qlItem.Phoenix_Product__c);
            }
        }
        var contractsList = component.get("v.simpleRecord").Phoenix_Reference_Contracts__c; 
        var conItems = [];
        if(contractsList != undefined){
            if(contractsList.includes(','))
                conItems = contractsList.split(',');
            else
                conItems.push(contractsList);
        }
        var reDirEvnt = $A.get("e.force:navigateToComponent");
        reDirEvnt.setParams({
            componentDef: "c:Phoenix_OpportunityEditPage",
            componentAttributes: {
                selectedNdcs : bidlines,
                isBidClone : true,
                name : component.get("v.bidName"),
                source : 'Bid Clone',
                type : 'Proactive',
                isAccSel : true,
                customerLkp : component.get("v.simpleRecord").Phoenix_Customer__c,
                oldBidId:component.get("v.recordId"),
                actualTemplate : component.get("v.simpleRecord").Phoenix_Customer_Type__c,
                comments : component.get("v.simpleRecord").Phoenix_Comments__c,
                internalTargetDate : component.get("v.interTargetD"),
                customerDeadlineDate : component.get("v.deadLineDate"),
                selectedContractNumberList : conItems
            }
        });
        reDirEvnt.fire();
    },
    
    onsearchFamily: function (component, event, helper) {
        console.log('on search family--')
        component.set("v.noData",false);
        var searchFamily = component.get("v.searchFamily");
        var searchName=component.get("v.searchText");
        var SearchKeyWordPD = component.get("v.lstSelectedPDRecords");
        var RxSrxList = component.get("v.RxSrxList");
        console.log('searchFamily--->'+searchFamily)
        console.log('searchName--->'+searchName)
        console.log('SearchKeyWordPD--->'+SearchKeyWordPD)
        console.log('RxSrxList--->'+RxSrxList)
        if(searchFamily!=null && searchFamily!='' && searchFamily!=undefined){
            helper.onsearchFamilyhelper(component,helper);   
        }
        else if(searchName!=null && searchName!='' && searchName!=undefined){
            helper.searchTablehelper(component,helper);
        }
            else if(SearchKeyWordPD.length>0){
                helper.onsearchDirectorhelper(component,helper);   
            }
                else if(RxSrxList.length>0){
                    helper.searchTablehelper(component, helper);   
                }
        
        
        
        //component.set("v.showProducts",false);  
    },
    onsearch: function (component, event, helper) {

        component.set("v.noData", false);
        var searchFamily = component.get("v.searchFamily");
        var searchName = component.get("v.searchText");
        console.log('searchName-------' + searchName);
        var SearchKeyWordPD = component.get("v.lstSelectedPDRecords");
        var RxSrxList = component.get("v.RxSrxList");

        //component.set("v.showSpinnerSelProds",true);
        if (searchName == null || searchName == 'undefined' || searchName == '') {
            if (searchName != null && searchName != 'undefined' && searchName != '') {
                helper.searchTablehelper(component, helper);
            } else if (searchFamily != null && searchFamily != 'undefined' && searchFamily != '') {
                helper.onsearchFamilyhelper(component, helper);
            } else if (SearchKeyWordPD.length > 0) {
                helper.onsearchDirectorhelper(component, helper);
            } else if (RxSrxList.length > 0) {
                helper.searchRx(component, helper);
            } else {
                component.set("v.showSpinnerSelProds", true);
                var resposeData = component.get("v.Allproduct");
                component.set("v.totalPages", Math.ceil(resposeData.length / component.get("v.pageSize")));
                component.set("v.allData", resposeData);

                component.set("v.currentPageNumber", 1);
                helper.buildData(component, helper);
                component.set("v.showSpinnerSelProds", false);
            }
        }
        // component.set("v.showSpinnerSelProds",false);

    },

    ShowProdList: function (component, event, helper) {

        component.set("v.showProducts", true);
        component.set("v.showSelectedProducts", false);

        var qt = component.get("v.QLlist");
        component.set("v.QLlist1", qt);


    },
    onblurProDir: function (component, event, helper) {
        // on mouse leave clear the listOfSeachRecords & hide the search result component
        var toggleclass = component.find("zvalue");
        $A.util.addClass(toggleclass, "zindex");
        component.set("v.listOfSearchPDRecords", null);
        component.set("v.SearchKeyWordPD", '');
        var forclose = component.find("searchResPD");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
    },

    keyPressControllerProdDir: function (component, event, helper) {
        var toggleclass = component.find("zvalue");
        $A.util.removeClass(toggleclass, "zindex");
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
    clearProdDir: function (component, event, helper) {
        var selectedPillId = event.getSource().get("v.name");
        var AllPillsList = component.get("v.lstSelectedPDRecords");

        for (var i = 0; i < AllPillsList.length; i++) {
            if (AllPillsList[i] == selectedPillId) {
                AllPillsList.splice(i, 1);
                component.set("v.lstSelectedPDRecords", AllPillsList);
            }
        }
        component.set("v.SearchKeyWordPD", null);
        //component.set("v.showSpinnerSelProds",true);
        component.set("v.listOfSearchPDRecords", null);
        component.set("v.noData", false);
        var searchFamily = component.get("v.searchFamily");
        var searchName = component.get("v.searchText");
        console.log('searchName-------' + searchName);
        var SearchKeyWordPD = component.get("v.lstSelectedPDRecords");
        var RxSrxList = component.get("v.RxSrxList");
        if (!SearchKeyWordPD.length > 0) {

            if (searchName != null && searchName != 'undefined' && searchName != '') {
                helper.searchTablehelper(component, helper);
            } else if (searchFamily != null && searchFamily != 'undefined' && searchFamily != '') {
                helper.onsearchFamilyhelper(component, helper);
            } else if (SearchKeyWordPD.length > 0) {
                helper.onsearchDirectorhelper(component, helper);
            } else if (RxSrxList.length > 0) {
                helper.searchRx(component, helper);
            } else {
                component.set("v.showSpinnerSelProds", true);
                var resposeData = component.get("v.Allproduct");
                component.set("v.totalPages", Math.ceil(resposeData.length / component.get("v.pageSize")));
                component.set("v.allData", resposeData);

                component.set("v.currentPageNumber", 1);
                helper.buildData(component, helper);
                component.set("v.showSpinnerSelProds", false);
            }
        } else {
            if (SearchKeyWordPD.length > 0) {
                helper.onsearchDirectorhelper(component, helper);
            }
        }

    },
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

    closeModal: function (component, event, helper) {
        component.set("v.showSelectedProducts", false);
        component.set("v.showProducts", false);
        component.set("v.noData", false);
        component.set("v.selectAllSCM", false);


        let recordId = component.get("v.recordId");
        var selIds = component.get("v.selectedProductsIds");

        var alldata = component.get("v.allData");
        var UpdateAllData = [];
        for (var i = 0; i < alldata.length; i++) {
            if (selIds.includes(alldata[i].qlItem.Id)) {

                alldata[i].isSelected = false;
                UpdateAllData.push(alldata[i]);
            }

        }

        var selectedProducts = [];
        component.set("v.selectedProductsIds", selectedProducts);

        var getSelectedNumber = 0;
        //component.set("v.selectedRowsCount",getSelectedNumber);
        component.set("v.selectedCount", getSelectedNumber);
        var count = 0;
        var searchText = '';
        //component.set("v.isContractSelectionNeeded",false);
        component.set("v.isRxChecked", false);
        component.set("v.isSRxChecked", false);
        component.set("v.isOtcChecked", false);
        component.set("v.searchFamily", searchText);
        component.set("v.searchText", searchText);
        for (var i = 0; i < alldata.length; i++) {
            if (alldata[i].isSelected == false) {
                count++;

            }

        }

        if (recordId != null && recordId != undefined && recordId != '') {
            // Go to record

            component.find("navigationService").navigate({
                type: "standard__recordPage",
                attributes: {
                    recordId: recordId,
                    actionName: "view"
                }
            }, false);
        }

    },
    selectAllCheckbox: function (component, event, helper) {
        var selectedHeaderCheck = event.getSource().get("v.checked");
        var allRecords = component.get("v.allData");
        var updatedAllRecords = [];
        var updatedPageList = [];

        var ProductList = component.get("v.ProductList");
        var getSelectedNumber = component.get("v.selectedCount");

        var selIds = component.get("v.selectedProductsIds");
        for (var j = 0; j < ProductList.length; j++) {
            if (selectedHeaderCheck == true) {

                ProductList[j].isSelected = selectedHeaderCheck;
                if (selIds.includes(ProductList[j].qlItem.Id)) {
                    continue;
                }

                selIds.push(ProductList[j].qlItem.Id);

            } else {


                const index = selIds.indexOf(ProductList[j].qlItem.Id);
                if (index > -1) {
                    selIds.splice(index, 1);
                }

                ProductList[j].isSelected = selectedHeaderCheck;
                var arry = component.get("v.QLlist1");

                if (arry != null && arry != undefined && arry != '') {


                    if (arry.length > 0) {

                        for (var i = 0; i < arry.length; i++) {
                            if (arry[i].qlItem.Id === ProductList[j].qlItem.Id) {
                                arry.splice(i, 1);

                            }
                        }
                        component.set("v.QLlist1", arry);

                    }
                }


            }

        }
        helper.buildData(component, helper);

        component.set("v.selectedProductsIds", selIds);
        var selectedProdcount = component.get("v.selectedProductsIds").length;

        component.set("v.selectedCount", selectedProdcount);
        var count = component.get("v.selectedCount")
        if (count > 0) {
            component.set("v.showbutton", false);
        } else if (count == 0) {
            component.set("v.showbutton", true);
        }

    },
    selectAllSCMCheckbox: function (component, event, helper) {
        var selectedHeaderSCMCheck = event.getSource().get("v.value");
        var updatedAllRecords = [];
        var ProductList = component.get("v.QLlist");



        for (var j = 0; j < ProductList.length; j++) {
            if (selectedHeaderSCMCheck == true) {

                ProductList[j].qlItem.Phoenix_SCM_Review__c = selectedHeaderSCMCheck;


                updatedAllRecords.push(ProductList[j]);

            } else {

                ProductList[j].qlItem.Phoenix_SCM_Review__c = selectedHeaderSCMCheck;
                updatedAllRecords.push(ProductList[j]);

            }
        }
        component.set("v.QLlist", updatedAllRecords);
        /*var arry = component.get("v.QLlist1");
                
                if(arry!=null && arry!=undefined && arry!=''){
                    
                    
                    if (arry.length > 0) {
                        
                        for (var i = 0; i < arry.length; i++) {
                            if (arry[i].qlItem.Id === ProductList[j].qlItem.Id) {
                                arry.splice(i, 1);
                                
                            }
                        }
                        component.set("v.QLlist1", arry);
                        
                    }
                }
                
                
            }
            
        }
        helper.buildData(component, helper);
        
        component.set("v.selectedProductsIds",selIds);
        var selectedProdcount=component.get("v.selectedProductsIds").length;
        
        component.set("v.selectedCount", selectedProdcount);
        var count = component.get("v.selectedCount")
        if (count > 0) {
            component.set("v.showbutton", false);
        }
        else if (count == 0) {
            component.set("v.showbutton", true);
        }*/

    },
    checkBoxChangeHandler: function (component, event, helper) {
        var selectedRec = event.getSource().get("v.checked");
        var selectedRec1 = event.getSource().get("v.name");


        var getSelectedNumber = component.get("v.selectedCount");
        var allProds = component.get("v.Allproduct");
        var selIds = [];

        if (selectedRec == true) {
            getSelectedNumber++;
            var selProds = component.get("v.selectedProductsIds");

            selIds = selProds;
            selIds.push(selectedRec1);
            var arry = component.get("v.QLlist1");

        } else {
            getSelectedNumber--;
            var selProds = component.get("v.selectedProductsIds");
            selIds = selProds;
            var prodId = event.getSource().get("v.name");

            const index = selIds.indexOf(prodId);
            if (index > -1) {
                selIds.splice(index, 1);
            }
            var arry = component.get("v.QLlist1");

            if (arry != null && arry != undefined && arry != '') {
                if (arry.length > 0) {

                    for (var i = 0; i < arry.length; i++) {
                        if (arry[i].qlItem.Id === prodId) {
                            arry.splice(i, 1);

                        }
                    }
                    component.set("v.QLlist1", arry);

                }
            }

        }

        component.set("v.selectedProductsIds", selIds);

        component.set("v.selectedCount", getSelectedNumber);
        var count = component.get("v.selectedCount");
        if (count > 0) {
            component.set("v.showbutton", false);
        } else if (count == 0) {
            component.set("v.showbutton", true);
        }
        //helper.buildData(component, helper); 
    },
    checkSCMReview: function (component, event, helper) {
        var checkedvalue = event.getSource().get("v.value");
        console.log('checkedvalue-----' + checkedvalue);
        var allProducts = component.get("v.QLlist");
        var count = 0;


        if (checkedvalue == true) {
            for (let j = 0; j < allProducts.length; j++) {
                var pData = allProducts[j];
                if (pData.qlItem.Phoenix_SCM_Review__c == true) {
                    count++;
                }

            }
            if (count == allProducts.length) {
                component.set("v.selectAllSCM", true);
            }

        } else {
            for (let j = 0; j < allProducts.length; j++) {
                var pData = allProducts[j];
                if (pData.qlItem.Phoenix_SCM_Review__c == false) {
                    count++;
                }

            }
            if (count == allProducts.length) {
                component.set("v.selectAllSCM", false);
            }

        }
        //component.set("v.QLlist",data);

    },

    processProducts: function (component, event, helper) {

        var bidN = component.find("RebidName").get("v.value");
        //console.log('>>>>bidName>>>>>'+bidN);
        var interTD = component.find("interTargetDate").get("v.value");
        var deadLDate = component.find("CBDLD").get("v.value");
        var today = new Date();
        var dd = String(today.getDate()).padStart(2, '0');
        var mm = String(today.getMonth() + 1).padStart(2, '0'); //January is 0!
        var yyyy = today.getFullYear();
        today = yyyy + '-' + mm + '-' + dd;

        console.log('>>>>bidName>>>>>' + bidN);
        console.log('>>>>interTD>>>>>' + interTD);
        console.log('>>>>deadLDate>>>>>' + deadLDate);
        console.log('>>>>today>>>>>' + today);

        if (bidN == null || bidN == '' || bidN == undefined) {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type": "error",
                "title": "Error!!",
                "message": "Name is required"
            });
            toastEvent.fire();
        } else if (interTD == null || interTD == '' || interTD == undefined) {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type": "error",
                "title": "Error!!",
                "message": "Internal Target Date is required"
            });
            toastEvent.fire();
        } else if (interTD < today) {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!!",
                "message": "Internal Target Date should be greater than Today's Date",
                "type": "error"
            });
            toastEvent.fire();
        } else if (deadLDate < today) {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!!",
                "message": "Customer Bid Deadline Date should be greater than Today's Date",
                "type": "error"
            });
            toastEvent.fire();
        } else if (interTD > deadLDate) {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!!",
                "message": "Customer Bid Deadline Date should be greater than Internal Target Date",
                "type": "error"
            });
            toastEvent.fire();
        } else {
            component.set("v.showProducts", false);
            //console.log('>>>>showProducts>>>>>'+component.get("v.showProducts"));
            component.set("v.showSelectedProducts", true);
            // console.log('>>>>showSelectedProducts>>>>>'+component.get("v.showSelectedProducts"));
            component.set("v.showSpinnerSelProds", true);
            // console.log('>>>>showSpinnerSelProds>>>>>'+component.get("v.showSpinnerSelProds"));


            // console.log('>>>>interTargetD>>>>>'+interTD);

            // console.log('>>>>deadLineDate>>>>>'+deadLDate);
            var deadLTZ = component.find("DeadLineTZ").get("v.value");
            // console.log('>>>>deadLineTim>>>>>'+deadLTZ);
            var deadLineT = component.find("DeadLineTime").get("v.value");
            // console.log('>>>>deadLineTimeZone>>>>>'+deadLineT);
            // console.log('>>>>bidType>>>>>'+component.get("v.bidType"));

            component.set('v.bidName', bidN);
            component.set('v.interTargetD', interTD);
            component.set('v.deadLineDate', deadLDate);
            component.set('v.deadLineTZone', deadLTZ);
            component.set('v.deadLineTim', deadLineT);

            component.set("v.isQLlistempty", false);
            var qt = component.get("v.QLlist1");
            var selReBidProductIds = [];

            for (var j = 0; j < qt.length; j++) {
                selReBidProductIds.push(qt[j].qlItem.Id);
            }
            var allProducts = component.get("v.Allproduct");
            var selectedProductsIds = component.get("v.selectedProductsIds");
            var data = [];
            var pData;
            for (let j = 0; j < allProducts.length; j++) {
                pData = allProducts[j];
                if (selectedProductsIds.includes(pData.qlItem.Id)) {
                    if (selReBidProductIds.includes(pData.qlItem.Id)) {

                    } else {
                        pData.qlItem.Phoenix_SCM_Review__c = false;
                    }

                    pData.isSelected = true;
                    data.push(pData);
                }
            }
            component.set("v.QLlist", data);
            var countSelect = 0;
            for (let j = 0; j < data.length; j++) {
                var pData = data[j];
                if (pData.qlItem.Phoenix_SCM_Review__c == true) {
                    countSelect++;
                }

            }

            if (countSelect == data.length) {
                component.set("v.selectAllSCM", true);
            } else {
                component.set("v.selectAllSCM", false);
            }
            component.set("v.showSpinnerSelProds", false);
            console.log('>>>>showSpinnerSelProds>>>>>' + component.get("v.showSpinnerSelProds"));
        }
    },


    removeDeletedRow: function (component, event, helper) {

        var selectedRec = event.getSource().get("v.name");

        var AllRowsList = component.get("v.QLlist");

        if (AllRowsList.length === 1) {
            console.log('AllRowsList.length === 1');
        }

        for (let i = 0; i < AllRowsList.length; i++) {

            var pItem = AllRowsList[i];

            if (pItem.qlItem.Id == selectedRec) {

                var index = AllRowsList.indexOf(pItem);
                if (index > -1) {

                    AllRowsList.splice(index, 1);
                    var AllRowsList1 = AllRowsList;

                }

            }
        }

        component.set("v.QLlist", []);
        component.set("v.QLlist", AllRowsList);
        var countSelect = 0;
        for (let j = 0; j < AllRowsList.length; j++) {
            var pData = AllRowsList[j];
            if (pData.qlItem.Phoenix_SCM_Review__c == true) {
                countSelect++;
            }

        }
        //console.log('AllRowsList.length----------'+AllRowsList.length);
        //console.log('countSelect.length----------'+countSelect);
        if (countSelect == AllRowsList.length) {
            component.set("v.selectAllSCM", true);
        } else {
            component.set("v.selectAllSCM", false);
        }


        if (AllRowsList.length === 0) {
            component.set("v.isQLlistempty", true);
        } else
            component.set("v.isQLlistempty", false);


        var saveditems = component.get("v.QLlist");
        var productList = component.get("v.ProductList");
        var alldata = component.get("v.allData");

        var prdlist1 = [];
        component.set("v.selectedProductsIds", []);

        var count = 0;


        if (AllRowsList != undefined && AllRowsList != null && AllRowsList != '' && AllRowsList.length > 0) {

            for (let i = 0; i < AllRowsList.length; i++) {

                for (let j = 0; j < alldata.length; j++) {
                    if (alldata[j].qlItem.Id == AllRowsList[i].qlItem.Id) {
                        count = count + 1;
                        alldata[j].isSelected = true;

                        prdlist1.push(alldata[j].qlItem.Id);
                        break;
                    }
                }

            }
        }

        component.set("v.selectedCount", count);
        if (count == 0)
            component.set("v.showbutton", true);
        else
            component.set("v.showbutton", false);

        component.set("v.selectedProductsIds", prdlist1);

        helper.buildData(component, helper);
    },

    onNext: function (component, event, helper) {
        var elmnt = document.getElementById("myDIV");
        elmnt.scrollTop = 0;
        var pageNumber = component.get("v.currentPageNumber");
        component.set("v.currentPageNumber", pageNumber + 1);
        helper.buildData(component, helper);
    },

    onPrev: function (component, event, helper) {
        var elmnt = document.getElementById("myDIV");
        elmnt.scrollTop = 0;
        var pageNumber = component.get("v.currentPageNumber");
        component.set("v.currentPageNumber", pageNumber - 1);
        helper.buildData(component, helper);
    },

    processMe: function (component, event, helper) {
        var elmnt = document.getElementById("myDIV");
        elmnt.scrollTop = 0;
        component.set("v.currentPageNumber", parseInt(event.target.name));
        helper.buildData(component, helper);
    },

    onFirst: function (component, event, helper) {
        var elmnt = document.getElementById("myDIV");
        elmnt.scrollTop = 0;
        component.set("v.currentPageNumber", 1);
        helper.buildData(component, helper);
    },

    onLast: function (component, event, helper) {
        var elmnt = document.getElementById("myDIV");
        elmnt.scrollTop = 0;
        component.set("v.currentPageNumber", component.get("v.totalPages"));
        helper.buildData(component, helper);
    },



    showSelectedproducts: function (component, event, helper) {
        component.set("v.isModalOpen", true);

        var showselectedIds = component.get("v.selectedProductsIds");
        var alldata = component.get("v.Allproduct");
        var modalProductList = [];
        for (var x = 0; x < alldata.length; x++) {


            if (showselectedIds.includes(alldata[x].qlItem.Id)) {

                modalProductList.push(alldata[x]);
            }

        }
        component.set("v.modalProductList", modalProductList);



    },
    closePopup: function (component, event, helper) {
        component.set("v.isModalOpen", false);
    },
    sortName: function (component, event, helper) {
        // set current selected header field on selectedTabsoft attribute.    
        component.set("v.selectedTabsoft", 'LineItemNo');
        // call the helper function with pass sortField Name  
        helper.sortHelper(component, event, 'Name');
    },
    sortProductName: function (component, event, helper) {
        // set current selected header field on selectedTabsoft attribute.    
        component.set("v.selectedTabsoft", 'ProductName');
        // call the helper function with pass sortField Name  
        helper.sortHelper(component, event, 'Phoenix_Product__r.Name');
    },
	sortProductNameSelected: function (component, event, helper) {
        // set current selected header field on selectedTabsoft attribute.    
        component.set("v.selectedTabsoft", 'ProductName');
        // call the helper function with pass sortField Name  
        helper.sortHelperSelected(component, event, 'Phoenix_Product__r.Name');
    },
    sortProductCode: function (component, event, helper) {
        // set current selected header field on selectedTabsoft attribute.    
        component.set("v.selectedTabsoft", 'ProductCode');
        // call the helper function with pass sortField Name  
        helper.sortHelper(component, event, 'Phoenix_Product_Code1__c');
    },
    sortProductCodeSelected: function (component, event, helper) {
        component.set("v.selectedTabsoft", 'ProductCode');
        helper.sortHelperSelected(component, event, 'Phoenix_Product_Code1__c');
    },
    sortProductFamily: function (component, event, helper) {
        // set current selected header field on selectedTabsoft attribute.        
        component.set("v.selectedTabsoft", 'ProductFamily');
        // call the helper function with pass sortField Name      
        helper.sortHelper(component, event, 'Product_Family__Name__c');
    },
    sortProductFamilySelected: function (component, event, helper) {
        component.set("v.selectedTabsoft", 'ProductFamily');
        helper.sortHelperSelected(component, event, 'Product_Family__Name__c');
    },
    sortProductDirector: function (component, event, helper) {
        // set current selected header field on selectedTabsoft attribute.    
        component.set("v.selectedTabsoft", 'ProductDirector');
        // call the helper function with pass sortField Name  
        helper.sortHelper(component, event, 'Phoenix_Product_Director1__c');
    },

    sortGPI: function (component, event, helper) {
        // set current selected header field on selectedTabsoft attribute.    
        component.set("v.selectedTabsoft", 'GPI');
        // call the helper function with pass sortField Name  
        helper.sortHelper(component, event, 'Phoenix_GPI_Generic_Product_Identifier__c');
    },
    sortGCN: function (component, event, helper) {
        // set current selected header field on selectedTabsoft attribute.    
        component.set("v.selectedTabsoft", 'GCN');
        // call the helper function with pass sortField Name  
        helper.sortHelper(component, event, 'Phoenix_GCN_Generic_Code_Number__c');
    },


    sortNDC11: function (component, event, helper) {
        // set current selected header field on selectedTabsoft attribute.        
        component.set("v.selectedTabsoft", 'NDC11');
        // call the helper function with pass sortField Name      
        helper.sortHelper(component, event, 'Phoenix_NDC__c');
    },
    sortNDC11Selected: function (component, event, helper) {
        component.set("v.selectedTabsoft", 'NDC11');
        helper.sortHelperSelected(component, event, 'Phoenix_NDC__c');
    },
    sortUPC: function (component, event, helper) {
        // set current selected header field on selectedTabsoft attribute.        
        component.set("v.selectedTabsoft", 'UPC');
        // call the helper function with pass sortField Name      
        helper.sortHelper(component, event, 'Phoenix_UPC_Universal_Product_Code__c');
    },
    sortStrength: function (component, event, helper) {
        // set current selected header field on selectedTabsoft attribute.        
        component.set("v.selectedTabsoft", 'Strength');
        // call the helper function with pass sortField Name      
        helper.sortHelper(component, event, 'Phoenix_Strength__c');
    },
    sortPackSize: function (component, event, helper) {
        // set current selected header field on selectedTabsoft attribute.        
        component.set("v.selectedTabsoft", 'PackSize');
        // call the helper function with pass sortField Name      
        helper.sortHelper(component, event, 'Phoenix_Pkg_Size1__c');
    },
    sortWAC: function (component, event, helper) {
        // set current selected header field on selectedTabsoft attribute.        
        component.set("v.selectedTabsoft", 'WAC');
        // call the helper function with pass sortField Name      
        helper.sortHelper(component, event, 'Phoenix_WAC1__c');
    },
    sortBrandName: function (component, event, helper) {
        // set current selected header field on selectedTabsoft attribute.        
        component.set("v.selectedTabsoft", 'BrandName');
        // call the helper function with pass sortField Name      
        helper.sortHelper(component, event, 'Phoenix_Compare_to_Brand_Name__c');
    },
    sortDiscontinuation: function (component, event, helper) {
        // set current selected header field on selectedTabsoft attribute.        
        component.set("v.selectedTabsoft", 'Discontinuation');
        // call the helper function with pass sortField Name      
        helper.sortHelper(component, event, 'Phoenix_Date_of_Discontinuation__c');
    },
    searchSrxRxOttc: function (component, event, helper) {
        helper.searchRx(component, helper);
    },

    keyCheck: function (component, event, helper) {
        if (event.which == 13) {
            component.set("v.noData", false);
            var searchFamily = component.get("v.searchFamily");
            var searchName = component.get("v.searchText");
            console.log('---searchName---' + searchName);
            var SearchKeyWordPD = component.get("v.lstSelectedPDRecords");
            var RxSrxList = component.get("v.RxSrxList");
            if (searchFamily != null && searchFamily != '' && searchFamily != undefined) {
                helper.onsearchFamilyhelper(component, helper);
            } else if (searchName != null && searchName != '' && searchName != undefined) {
                console.log('---searchName in search helper---' + searchName);
                helper.searchTablehelper(component, helper);
            } else if (SearchKeyWordPD.length > 0) {
                helper.onsearchDirectorhelper(component, helper);
            } else if (RxSrxList.length > 0) {
                helper.searchRx(component, helper);
            }

        }
    }

})