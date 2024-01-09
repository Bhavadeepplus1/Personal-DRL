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
    collpase: function (component, event, helper) {
        var LineItemtable = component.find("LineTable");
        $A.util.toggleClass(LineItemtable, "fixedtable");
    },
    hideSubmitModel: function (component, event, helper) {
        component.set('v.submitModel', false);
        var LineItemtable = component.find("LineTable");
        $A.util.addClass(LineItemtable, "maintable");
    },
    proceedToSubmit: function (component, event, helper) {
        if (component.get("v.BidAprrovalStatus") == 'Draft') {
            component.set('v.submitModel', false);
            var LineItemtable = component.find("LineTable");
            $A.util.addClass(LineItemtable, "maintable");
            helper.getBidInfoForValids(component, event, helper);
        }
    },
    showSummaryPopup: function(component, event, helper){
        component.set("v.showSummaryPopup", !component.get("v.showSummaryPopup"));
    },
    submitFor: function (component, event, helper) {
        component.set('v.isSpinnerLoad', true);
        var contrcts=component.get('v.selectedCntrcts');
        var bidType=component.get("v.BidTypeVal");
        var bidrecord=component.get("v.bidRecord");
        var bidStatus = component.get("v.BidAprrovalStatus");
        var isBidNotValid;
        console.log('bidRecord--->'+JSON.stringify(bidrecord))
        if(bidrecord.Phoenix_Reference_Contracts__c==undefined){
            isBidNotValid= "Please Select a Contract";          
        }else if((bidStatus == 'Customer\'\s Update') && (bidrecord.Phoenix_Sent_to_Customer_Date__c == null || bidrecord.Phoenix_Sent_to_Customer_Date__c == undefined )){
            isBidNotValid= "Please Enter Sent to Customer Date";
        }
        if(isBidNotValid){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "type":"error",
                "message":isBidNotValid
            });
            toastEvent.fire();
            component.set('v.isSpinnerLoad',false);  
        }           
        else {
            component.set('v.isSpinnerLoad', true);
            var qtyError;
            var templateType = component.get("v.templateType");
            var delegatedUser = component.get("v.deligatedUserName");
            var action = component.get("c.getupdatedforExport");
            action.setParams({
                bidId: component.get("v.recordId")
            });
            action.setCallback(this, function (response) {
                if (response.getState() == "SUCCESS") {
                    var bidlines = response.getReturnValue();
                    for (var i = 0; i < bidlines.length; i++) {
                        if (bidType != 'OTC Price Change' && bidType != 'OTC Rebate Change' && bidlines[i].Phoenix_12_Months_IndirectSaleUnit__c == null) {
                            qtyError = 'Please Enter Total Units for '+bidlines[i].Phoenix_Product__r.Name;
                            console.log('direct');
                            break;
                        }else if (bidType != 'OTC Price Change' && bidType != 'OTC Rebate Change' && bidlines[i].Phoenix_Date_Fee__c == null) {
                            qtyError = 'Please Enter Proposed Share % for '+bidlines[i].Phoenix_Product__r.Name;
                            console.log('in direct');
                            break;
                        } else if (bidType != 'OTC Rebate Change' && bidlines[i].Phoenix_Supply_Type__c == null) {
                            qtyError = 'Please Select Supply Type for '+bidlines[i].Phoenix_Product__r.Name;
                            console.log('in direct');
                            break;
                        }
                        
                            
                    }
                }
                if (qtyError) {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "type": "error",
                        "message": qtyError
                    });
                    toastEvent.fire();
                    component.set('v.isSpinnerLoad', false);
                } else {
                    component.set('v.isSpinnerLoad', false);
                    component.set('v.submitModel', true);
                    var LineItemtable = component.find("LineTable");
                    $A.util.removeClass(LineItemtable, "maintable");
                    console.log(component.get('v.submitModel'));
                    
                    
                   /* if (component.get("v.BidAprrovalStatus") == 'Draft') {
                        helper.getBidInfoForValids(component, event, helper);
                    }*/
                }
            });
            $A.enqueueAction(action);
        }
    },
    handleCalcEvent: function (component, event, helper) {
        helper.getAllTotalValues(component, event, helper);
        //helper.handleCalcEventHelper(component, event, helper);
    },
    initRecords: function (component, event, helper) {
        component.find("Tabset").set("v.selectedTabId", 'EBLI');
        component.set("v.isSpecificCustomer", false);
        component.set("v.templateType", "");
        component.set('v.isSpinnerLoad', true);
        component.set('v.selectedCntrcts', []);
        component.set("v.selectedPosistions",[]);
        component.set('v.lstSelectedRecords', []);
        component.set('v.lstSelectedPDRecords', []);
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
                var isMarketLeadApprovePerson = wrapperObj.isMarketLeadApprovePerson;
                var isCustomersApprovePerson = wrapperObj.isCustomersApprovePerson;
                var ismarketingDeligator = wrapperObj.ismarketingDeligator;
                var deligatedUserName = wrapperObj.deligatedUserName;
                var showProceedBtn = wrapperObj.showProceedBtn;
                var hasDirectorLines = wrapperObj.hasDirectorLines;
                component.set("v.isMarketingApprovePerson", isMarketingApprovePerson);
                component.set("v.isCustomersApprovePerson", isCustomersApprovePerson);
                component.set("v.isMarketLeadApprovePerson", isMarketLeadApprovePerson);
                component.set("v.ismarketingDeligator", ismarketingDeligator);
                component.set("v.deligatedUserName", deligatedUserName);
                component.set("v.showProceedBtn", showProceedBtn);
                component.set("v.hasDirectorLines",hasDirectorLines);
                component.set("v.customerId", bidRecord.Phoenix_Customer__c);
                console.log('isCustomersApprovePerson----->' + isCustomersApprovePerson);
                component.set("v.crntVipVal", bidRecord.Phoenix_Current_Value_Est_VIP__c);
                if (lineItemsList.length == 0 || component.get("v.recordId") == null) {
                    component.set("v.isRelatedLineItemsEmpty", false);
                }

                component.set('v.defaultlistOfProductFamily', wrapperObj.productfamilyList);
                if (wrapperObj.productDirectorList != null) {
                    component.set('v.defaultlistOfProductDirectors', wrapperObj.productDirectorList);
                }
                if( wrapperObj.productDirectorList!=null){
                                       component.set('v.defaultlistOfProductDirectors', wrapperObj.productDirectorList);
                                   } 
                                   if(lineItemsList.length > 50){
                                       function calculatePagesCount(pageSize, totalCount) {
                                           return totalCount < pageSize ? 1 : Math.ceil(totalCount / pageSize);
                                       }
                                       
                                       var pageSize = 50;
                                       var itemsCount = lineItemsList.length;
                                       var pagesCount = calculatePagesCount(pageSize, itemsCount);
                                       console.log("totalCount--->"+pagesCount)
                                       var pageNumbers = [];
                                       for(var i=1;i<pagesCount;i++){
                                           pageNumbers.push(i);
                                       }
                                       component.set("v.pageNumbers",pageNumbers);
                                       var pagedLineItems = lineItemsList.slice(0,50);
                                       component.set("v.pagedLineItems",pagedLineItems);
                                   }
                                   else{
                                       component.set("v.pagedLineItems",lineItemsList);
                                   }
                                       
                                   
                component.set("v.BidLineItemListAll", lineItemsList);
                component.set("v.ItemsLength", lineItemsList.length);
                component.set('v.isSpinnerLoad', false);
                component.set("v.templateType", bidRecord.Phoenix_Customer_Type__c);
                component.set("v.bidNumber", bidRecord.Name);
                component.set("v.bidName", bidRecord.Phoenix_Bid_Name__c);
                component.set("v.bidRecord", bidRecord);
                console.log('refcontrcts--' + bidRecord.Phoenix_Reference_Contracts__c);
                if (bidRecord.Phoenix_Reference_Contracts__c != null && bidRecord.Phoenix_Reference_Contracts__c != undefined) {
                    var refContracts = bidRecord.Phoenix_Reference_Contracts__c;
                    component.set("v.selectedCntrcts", refContracts.split(','));
                }
                console.log('bidRecord.Phoenix_Bid_Type__c---' + bidRecord.Phoenix_Bid_Type__c);
                if (bidRecord.Phoenix_Bid_Type__c != null && bidRecord.Phoenix_Bid_Type__c != undefined) {
                    component.set("v.BidTypeVal", bidRecord.Phoenix_Bid_Type__c);
                    console.log('initbidType---->'+bidRecord.Phoenix_Bid_Type__c)
                }
                console.log('bidRecord.Phoenix_Approval_Status__c---' + bidRecord.Phoenix_Approval_Status__c);
                if (bidRecord.Phoenix_Approval_Status__c != null && bidRecord.Phoenix_Approval_Status__c != undefined) {
                    component.set("v.BidAprrovalStatus", bidRecord.Phoenix_Approval_Status__c);
                }
                console.log('loggedinUserName--' + loggedinUserName);
                if (loggedinUserName != null && loggedinUserName != undefined) {
                    component.set("v.loggedInUserName", loggedinUserName);
                }
                console.log('isReBid----->'+bidRecord.Phoenix_Is_Re_Bid__c)
                if( bidRecord.Phoenix_Is_Re_Bid__c!=null && bidRecord.Phoenix_Is_Re_Bid__c!=undefined && bidRecord.Phoenix_Is_Re_Bid__c==true){
                    component.set("v.isReBid",true);
                }else{
                    component.set("v.isReBid",false);
                }
                /*Product Position Logic*/
                if (bidRecord.Phoenix_Bid_Proposed_Position__c != null && bidRecord.Phoenix_Bid_Proposed_Position__c != undefined) {
                    var refPositions = bidRecord.Phoenix_Bid_Proposed_Position__c;
                    component.set("v.selectedPosistions", refPositions.split(','));
                }
                /*Product Position Logic*/
                
                
                var OutDiv = component.find("mainDiv");
                if (lineItemsList.length < 7) {
                    console.log('--no-hight---');
                    $A.util.addClass(OutDiv, "noheightClass");
                } else {
                    $A.util.removeClass(OutDiv, "noheightClass");
                }

                helper.getAllTotalValues(component, event, helper);
                var LineItemtable = component.find("LineTable");
                component.set("v.tableRef", LineItemtable);
            } else {
                component.set('v.isSpinnerLoad', false);
            }
        });
        $A.enqueueAction(action);

    },
    initDetailView: function (component, event, helper) {
        var detailTab = component.find('detailTab');
        detailTab.DetailViewRefresh();
    },
    initCompactView: function (component, event, helper) {
        var CompactView = component.find('CompactView');
        CompactView.scmRefresh();
    },
    initFinnaceCmp: function (component, event, helper) {
        var financeCmp = component.find('financeChildCmp');
        financeCmp.financeRefresh();
    },
    initSCMCmp: function (component, event, helper) {
        var SCMCmp = component.find('SCMChildCmp');
        SCMCmp.scmRefresh();
    },
    initNDCFinanceCmp: function (component, event, helper) {
        var NDCFinance = component.find('NDCFinance');
        NDCFinance.scmRefresh();
    },
    initMDMMethod: function (component, event, helper) {
        var MDMView = component.find('MdmViewId');
        MDMView.mdmViewRefresh();
    },
    initManagementCmp : function(component, event, helper) {
        var NDCFinance = component.find('ApprovalGrid');
        NDCFinance.scmRefresh();
    },
    initRejectedStatus: function (component, event, helper) {
        var rejectedStatus = component.find('RejectedStatusChildCmp');
        rejectedStatus.rejectedStatusRefresh();
    },
    initContractsView: function (component, event, helper) {
        var rejectedStatus = component.find('ContractsTab');
        rejectedStatus.ContractsViewRefresh();
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
        /*var pVip = recUi.record.fields["Phoenix_Proposed_Value_Est_VIP__c"].value;
        console.log('pVip--' + pVip);
        var crntVip = recUi.record.fields["Phoenix_Current_Value_Est_VIP__c"].value;
        console.log('crntVip--' + crntVip);
        var crntvipvalue;
        if (crntVip != null && crntVip != undefined) {
            crntvipvalue = crntVip;
        }
        console.log('crntvipvalue--' + component.get("v.crntVipVal"));
        if (component.get("v.BidTypeVal") != 'New Customer' && (crntvipvalue == 0 || crntvipvalue == null)) {
            component.set("v.VipReadOnly", true);
        } else {
            component.set("v.VipReadOnly", false);
        }
        console.log('vipreadonly--' + component.get("v.VipReadOnly"));*/
    },
    onRecordSubmit: function (component, event, helper) {
        event.preventDefault();
        var eventFields = event.getParam("fields");
        var slctCntrcts=component.get("v.selectedCntrcts");
        /* var cntrctstring='';
        for(var i=0;i<slctCntrcts.length;i++){
            if(i==0){
                cntrctstring=slctCntrcts[i].Name;
            }else{
                cntrctstring+=','+slctCntrcts[i].Name;
            }
        }*/
        var bidType = component.get("v.BidTypeVal");
        console.log('isRFp or Product Addition-->'+(bidType == 'RFP Bids' || bidType == 'Product Addition'));
        if(slctCntrcts.length==0 && component.get("v.BidTypeVal")!='New Customer'){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "type":"error",
                "message": "Please Select a Contract"
            });
            toastEvent.fire();
        }else if(bidType == 'Sales Out Rebate' && (eventFields["Phoenix_Sales_Out_Promotion_of_Days__c"] == null || eventFields["Phoenix_Sales_Out_Promotion_of_Days__c"] == '' || eventFields["Phoenix_Sales_Out_Promotion_of_Days__c"] == 0 )){
            var msg = eventFields["Phoenix_Sales_Out_Promotion_of_Days__c"] == 0 ? 'Sales Out Promotion # of Days must be greater than 0' :'Please Enter Sales Out Promotion # of Days';
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "type":"error",
                "message": msg
            });
            toastEvent.fire();
        }else if(bidType == 'Sales Out Rebate' && (eventFields["Phoenix_Proposed_Sales_Out_Promotion__c"] == null || eventFields["Phoenix_Proposed_Sales_Out_Promotion__c"] == '' || eventFields["Phoenix_Proposed_Sales_Out_Promotion__c"] == 0) ){
            var msg = eventFields["Phoenix_Proposed_Sales_Out_Promotion__c"] == 0 ? 'Proposed Sales Out Promotion % must be greater than 0' :'Please Enter Proposed Sales Out Promotion %';
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "type":"error",
                "message": msg
            });
            toastEvent.fire();
        }else if((bidType == 'Product Addition' || bidType == 'Price Change') && (eventFields["Phoenix_Proactive_Reactive__c"] == null || eventFields["Phoenix_Proactive_Reactive__c"] == '')){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "type":"error",
                "message": "Please Select Proactive/Reactive"
            });
            toastEvent.fire();
        }else if((bidType == 'RFP Bids' || bidType == 'Product Addition' || bidType == 'New Customer') && (eventFields["Phoenix_Initial_Order_Discount_Type__c"] == null || eventFields["Phoenix_Initial_Order_Discount_Type__c"] == '')){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "type":"error",
                "message": "Please Select Initial Order Discount Type"
            });
            toastEvent.fire();
        }else if((bidType == 'RFP Bids' || bidType == 'Product Addition' || bidType == 'New Customer') && (eventFields["Phoenix_Initial_Order_Discount_of_Days__c"] == null || eventFields["Phoenix_Initial_Order_Discount_of_Days__c"] == '' || eventFields["Phoenix_Initial_Order_Discount_of_Days__c"] == 0 ) && eventFields["Phoenix_Initial_Order_Discount_Type__c"] != 'None'){
            var InitialOrderDays = eventFields["Phoenix_Initial_Order_Discount_of_Days__c"] ;
            var msg;
            if(InitialOrderDays=='' || InitialOrderDays==null){
               msg= 'Please Enter Initial Order Discount # of Days';
            }else{
             msg=InitialOrderDays == 0  ? 'Initial Order Discount # of Days must be greater than 0' : 'Please Enter Initial Order Discount # of Days';
            }
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "type":"error",
                "message": msg
            });
            toastEvent.fire();
        }else if((bidType == 'RFP Bids' || bidType == 'Product Addition' || bidType == 'New Customer') && (eventFields["Phoenix_Proposed_Initial_Order_Discount__c"] == null || eventFields["Phoenix_Proposed_Initial_Order_Discount__c"] == '' || eventFields["Phoenix_Proposed_Initial_Order_Discount__c"] == 0) && eventFields["Phoenix_Initial_Order_Discount_Type__c"] != 'None'){
            var iodPerc=eventFields["Phoenix_Proposed_Initial_Order_Discount__c"];
            var msg;
            if(iodPerc==null || iodPerc==''){
                msg='Please Enter Proposed Initial Order Discount %';
            }else{
                msg= iodPerc < 1 ? 'Proposed Initial Order Discount % must be greater than 0' : 'Please Enter Proposed Initial Order Discount %';
            }
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "type":"error",
                "message": msg
            });
            toastEvent.fire();
        } else {
            var bid = component.get("v.bidRecord");
            var exstingContracts;
            if(bid !=null){
                exstingContracts = bid.Phoenix_Reference_Contracts__c;
                if(exstingContracts != null){
                    exstingContracts = exstingContracts.toString();
                }
            }
            console.log('is contracts modifoed-->'+(exstingContracts !== slctCntrcts.toString()))
            eventFields["Phoenix_Reference_Contracts__c"] = slctCntrcts.toString();
            var currentCd = eventFields["Phoenix_Current_CD__c"];
            var pvip = eventFields["Phoenix_Proposed_Value_Est_VIP__c"];
            if (pvip == null || pvip == undefined || pvip == '') {
                eventFields["Phoenix_Proposed_Value_Est_VIP__c"] = eventFields["Phoenix_Current_Value_Est_VIP__c"];
            }
            eventFields["Phoenix_Bid_Proposed_Position__c"] = component.get("v.selectedPosistions").toString();
            component.find("bidForm").submit(eventFields);

            if (component.get("v.BidTypeVal") != 'OTC OTB Short Dated' && component.get("v.BidTypeVal") != 'OTC New Product' && component.get("v.BidTypeVal") != 'OTC OTB Good Dated' && exstingContracts !== slctCntrcts.toString()) {
                helper.getNPRDataOfContracts(component, event, helper, slctCntrcts, component.get("v.templateType"));
            }
        }
    },
    onRecordSuccess: function (component, event, helper) {
        console.log('sucess----' + event.getParam("response").id);
        component.set('v.isSpinnerLoad', true);
        console.log('after success return');
        var rebateHeader, feeHeader, marketingHeader,supplyDateHeaderValue,priceDateHeaderValue;
        var rebatetype = component.find("headerRebateType");
        if($A.util.isArray(rebatetype)){
            rebatetype=rebatetype[0];
        }
        var feetype = component.find("headerFeeType");
         if($A.util.isArray(feetype)){
            feetype=feetype[0];
        }
        var marketingType = component.find("headerMarketingApproval");
        var supplyDateType = component.find("supplyDateHeader");
        var priceDateType = component.find("priceDateHeader");
        if($A.util.isArray(marketingType)){
            marketingType=marketingType[0];
        }
         if($A.util.isArray(supplyDateType)){
            supplyDateType=supplyDateType[0];
        }
        if($A.util.isArray(priceDateType)){
            priceDateType=priceDateType[0];
        }
        console.log('marketingType--' + marketingType);
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
            console.log('marketingHeader---' + marketingHeader);
        } else {
            marketingHeader = '';
        }
        if (supplyDateType != null) {
            supplyDateHeaderValue = supplyDateType.get("v.value");
            console.log('supplyDateHeaderValue---' + supplyDateHeaderValue);
        } else {
            supplyDateHeaderValue = null;
        }
        if (priceDateType != null) {
            priceDateHeaderValue = priceDateType.get("v.value");
            console.log('priceDateHeaderValue---' + priceDateHeaderValue);
        } else {
            priceDateHeaderValue = null;
        }


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
                'isMarketingChanged': component.get("v.isMarketingChanged"),
                'productPositions': component.get("v.selectedPosistions").toString(),
                'issupplyDateChanged': component.get("v.issupplyDateChanged"),
                'supplyDateHeaderValue':supplyDateHeaderValue,
                 'ispriceDateChanged': component.get("v.ispriceDateChanged"),
                'priceDateHeaderValue':priceDateHeaderValue
            });
            action.setCallback(this, function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var storeResponse = response.getReturnValue();
                    component.set("v.bidRecord",storeResponse);
                    console.log("bid Record--->"+JSON.stringify(storeResponse))
                    //var loadPage = component.get('c.initRecords');
                    //$A.enqueueAction(loadPage);
                    component.set("v.showSaveCancelBtn", false);
                    component.set('v.isSpinnerLoad', false);
                    helper.searchProductFamilyChange(component, event, helper);
                    helper.getAllTotalValues(component, event, helper);
                    component.set("v.bidRecord", storeResponse);
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
        $A.util.removeClass(LineItemtable, "maintable");
        component.set("v.showModal", true);
        component.set('v.mycolumns', [{
                label: 'Contract',
                fieldName: 'Phoenix_Contract_Number__c',
                type: 'text'
            },
            {
                label: 'Customer',
                fieldName: 'Phoenix_Customer__c',
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
        var bidCustomer = component.get("v.customerId");
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
        var bidCustomer = component.get("v.customerId");
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
            selectedCntrcts.push(selectrcs[i].Phoenix_Contract_Number__c);
        }
        component.set("v.selectedCntrcts", selectedCntrcts);
        component.set("v.showModal", false);
        var LineItemtable = component.find("LineTable");
        $A.util.addClass(LineItemtable, "maintable");
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
        component.set("v.showPositionsModal", false);
        var LineItemtable = component.find("LineTable");
        $A.util.addClass(LineItemtable, "maintable");
    },
    cancel: function (component, event, helper) {
        $A.get('e.force:refreshView').fire();
    },
    showSaveCancel: function (component, event, helper) {
        component.set("v.showSaveCancelBtn", true);
    },
    iodTypeChange : function(component, event, helper){
        component.set("v.showSaveCancelBtn",true);
        var iodIDS = component.find("iodDays");
        var ProValIds =  component.find("iodDiscount");
        if($A.util.isArray(iodIDS)){
            iodIDS= iodIDS[0];
        }
        if($A.util.isArray(ProValIds)){
            ProValIds=ProValIds[0];
        }
        if(event.getSource().get("v.value")=='None' || event.getSource().get("v.value")==''){
            iodIDS.set("v.value",null);
            ProValIds.set("v.value",null);
            iodIDS.set("v.disabled",true);
            ProValIds.set("v.disabled",true);
        }else{
            iodIDS.set("v.disabled",false);
            ProValIds.set("v.disabled",false);
        }
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
    updateFields : function (component, event, heplper){
       component.set('v.isSpinnerLoad', true);
        var action = component.get("c.saveLineItemsNewPL");
        action.setParams({
            bidId: component.get("v.recordId"),
           LineItemList: component.get("v.BidLineItemListAll")
        });
        action.setCallback(this, function (response) {
            if (response.getState() == "SUCCESS") {
               var storeResponse = response.getReturnValue();
                component.set("v.BidLineItemListAll", storeResponse);
                console.log('updated response-->'+JSON.stringify(storeResponse));
              var callinitrecords = component.get('c.initRecords');
       				 $A.enqueueAction(callinitrecords);
                  var toastEvent = $A.get("e.force:showToast");
    			toastEvent.setParams({
       				 "title": "Success!",
        			"message": "WAC and Lowest Price/SKU have been updated successfully.",
                     "type": "success"
    				});
    			toastEvent.fire();
                component.set("v.showSaveCancelBtn", false);
                component.set('v.isSpinnerLoad', false);
            }
            else {
                    component.set("v.showSaveCancelBtn", false);
                    component.set('v.isSpinnerLoad', false);
                }
        });
       $A.enqueueAction(action);
        	
	},
    handleEvent: function (component, event, helper) {
        component.set('v.isSpinnerLoad', true);
        var message = event.getParam("message");
        /*var action = component.get("c.getRelatedList");
        action.setParams
        ({
            bidId: component.get("v.recordId")
        });
        action.setCallback(this, function(response) 
                           {
                               var wrapperObj =  response.getReturnValue();
                               var lineItemsList = wrapperObj.lineItemsList;
                               component.set("v.BidLineItemListAll",lineItemsList);
                               component.set('v.isSpinnerLoad',false);
                               var OutDiv = component.find("mainDiv");
                               
                               if(lineItemsList.length<10){
                                   console.log('--no-hight---');
                                   $A.util.addClass(OutDiv, "noheightClass");                                   
                               }else{
                                   $A.util.removeClass(OutDiv, "noheightClass");
                               } 
                               
                           });*/
        //$A.enqueueAction(action);
        helper.searchProductFamilyChange(component, event, helper);
        window.setTimeout(
            $A.getCallback(function () {
                helper.getAllTotalValues(component, event, helper);
            }), 2000
        );
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
        var toggleclass = component.find("zvalue");
        $A.util.addClass(toggleclass, "zindex");
        var toggleclasspkg = component.find("zvaluePkg");
        $A.util.addClass(toggleclasspkg, "zindexPkg");
        var toggleclassPrd = component.find("zvaluePrd");
        $A.util.addClass(toggleclassPrd, "zindexPrd");
        component.set("v.listOfSearchPDRecords", null);
        component.set("v.SearchKeyWordPD", '');
        var forclose = component.find("searchResPD");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
    },
    onfocusProdDir: function (component, event, helper) {
        // show the spinner,show child search result component and call helper function
        /* $A.util.addClass(component.find("mySpinner"), "slds-show");
        component.set("v.listOfSearchPDRecords", null ); 
        var forOpen = component.find("searchResPD");
        $A.util.addClass(forOpen, 'slds-is-open');
        $A.util.removeClass(forOpen, 'slds-is-close');
        // Get Default 5 Records order by createdDate DESC 
        var getInputkeyWord = '';
        helper.searchHelperProdDir(component,event,getInputkeyWord);*/
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
                if (lineItemsList.length < 7) {
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
      onSupplyDateChange: function (component, event, helper) {
        component.set("v.showSaveCancelBtn", true);
        component.set("v.issupplyDateChanged", true);
    },
     onPriceDateChange: function (component, event, helper) {
        component.set("v.showSaveCancelBtn", true);
        component.set("v.ispriceDateChanged", true);
    },
    downloadCsv: function (component, event, helper) {
        var action = component.get("c.getupdatedforExport");
        action.setParams({
            "bidId": component.get("v.recordId")
        });
        action.setCallback(this, function (a) {
            var ResultData = a.getReturnValue();
            var template = component.get("v.templateType");
            var bidNumber = component.get("v.bidNumber");
            var bidName = component.get("v.bidName");
            var bidType = component.get("v.BidTypeVal");
            // call the helper function which "return" the CSV data as a String   
            var csv = helper.convertArrayOfObjectsToCSV(component, ResultData, template, bidType);
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
            hiddenElement.download = 'Input View' + '-' + bidNumber + '-' + bidName + '-' + Now + '.csv'; // CSV file Name* you can change it.[only name not .csv] 
            document.body.appendChild(hiddenElement); // Required for FireFox browser
            hiddenElement.click(); // using click() js function to download csv file
        });
        $A.enqueueAction(action);
    },
    saveToProceed: function (component, event, helper) {
        var isCustomer = false;
        helper.submitForProceed(component, event, helper, isCustomer,false);
    },
    saveToProceedCustomerStep: function (component, event, helper) {
        var isCustomer = true;
        helper.submitForProceed(component, event, helper, isCustomer,false);
    }, 
    saveToProceedMarketingLead: function (component, event, helper) {
        var isCustomer = false;
        var isMarketingLead=true;
        helper.submitForProceed(component, event, helper, isCustomer,isMarketingLead);
    },
     showProductPositionModel: function (component, event, helper) {
        var LineItemtable = component.find("LineTable");
        console.log('modalstart---' + LineItemtable);
        $A.util.removeClass(LineItemtable, "maintable");
        component.set("v.showPositionsModal", true);
        component.set('v.positionColumns', [{
                label: 'Name',
                fieldName: 'Name',
                type: 'text'
            },
            {
                label: 'Customer',
                fieldName: 'Phoenix_Customer__c',
                type: 'text'
            },
            {
                label: 'Group Name',
                fieldName: 'Phoenix_Group_Name__c',
                type: 'text'
            },
            {
                label: 'Position Comments',
                fieldName: 'Phoenix_Position_Comments__c',
                type: 'Text'
            }
        ]);
        // var searchInput=component.find("cntInput").get("v.value");
        // console.log('--searchInput--'+searchInput);
        var bidCustomer = component.get("v.customerId");
        console.log('--bidCustomer--' + bidCustomer);
        if (bidCustomer != null && bidCustomer != undefined) {
            helper.fetchPositions(component, event, helper, bidCustomer);
        } else {
            component.set("v.positionsList", null);
        }
    },
    
   
    savePosDetails: function (component, event, helper) {
        var selectrcs = component.find('PoslinesTable').getSelectedRows();
        var selectedCntrcts = component.get("v.selectedPosistions");
        for (var i = 0; i < selectrcs.length; i++) {
            selectedCntrcts.push(selectrcs[i].Name);
        }
        component.set("v.selectedPosistions", selectedCntrcts);
        component.set("v.showPositionsModal", false);
        var LineItemtable = component.find("LineTable");
        $A.util.addClass(LineItemtable, "maintable");
        component.set("v.showSaveCancelBtn", true);
        //helper.getNPRDataOfContracts(component, event, helper,selectrcs);
    },
    
     clearPosition: function (component, event, heplper) {
        var selectedPillId = event.getSource().get("v.name");
        var AllPillsList = component.get("v.selectedPosistions");

        for (var i = 0; i < AllPillsList.length; i++) {
            if (AllPillsList[i] == selectedPillId) {
                AllPillsList.splice(i, 1);
                component.set("v.selectedPosistions", AllPillsList);
            }
        }
        component.set("v.showSaveCancelBtn", true);
    },
    openPage : function(component, event, helper){
        var selectedPageNumber = event.getSource('').get('v.label');
        if(selectedPageNumber != component.get("v.selectedPageNumber")){
            var bidLineItems = component.get("v.BidLineItemListAll");
            var pagedLineItems = bidLineItems.slice((selectedPageNumber-1)*50,((selectedPageNumber-1)*50)+50);
            component.set("v.pagedLineItems",pagedLineItems);
            component.set("v.selectedPageNumber",selectedPageNumber);
            var LineItemtable = component.find("LineTable");
            $A.util.addClass(LineItemtable, "maintable");
        }
    },
    navigate : function(component, event, helper) 
    {
        var navigateEvent = $A.get("e.force:navigateToComponent");
        navigateEvent.setParams({
            componentDef: "c:CompetitorInfo",
            componentAttributes: {
            bidId : component.get("v.recordId")
        }
            //You can pass attribute value from Component1 to Component2
            //componentAttributes :{ }
        });
        navigateEvent.fire();
    },
    doInit : function(component, event, helper) {
	var actionfu = component.get("c.fetchUser");
        actionfu.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
               // set current user information on userInfo attribute
                component.set("v.userInfo", storeResponse);
            }
        });
        $A.enqueueAction(actionfu);
    } 

})