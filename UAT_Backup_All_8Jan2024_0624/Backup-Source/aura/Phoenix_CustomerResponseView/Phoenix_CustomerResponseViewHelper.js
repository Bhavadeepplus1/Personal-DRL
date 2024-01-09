({
      getBidLastActivity : function(component,event,helper){
        var action = component.get("c.getLastBidActivity");
        console.log('bid id test'+component.get("v.recordId"))
         action.setParams
            ({
                bidId: component.get('v.bidRecordId'),
            });
        action.setCallback(this, function(response) 
                           {
                               if(response.getState()=="SUCCESS"){
                                   console.log('record created successfully')
                               }else{
                                   console.log('error in bid last activity')
                               }
                           });
                             $A.enqueueAction(action);
    },
    getBidId: function(component, event, helper) {
        component.set('v.isSpinnerLoad',true);       
        var action = component.get("c.getBid");
        action.setParams
        ({
            crId: component.get("v.crRecordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state=='SUCCESS'){
                var bid = response.getReturnValue();
                component.set('v.bidRecordId',bid.Phoenix_Bid_No__c);
                if(bid.Phoenix_Bid_No__r!=null){	
                    component.set('v.bidType',bid.Phoenix_Bid_No__r.Phoenix_Bid_Type__c);	
                    component.set('v.isOTCBid',bid.Phoenix_Bid_No__r.Phoenix_is_OTC_Bid__c);	
                }
                if(component.get("v.isOTCBid")){
                    helper.fetchPickListVal(component, 'Phoenix_OTC_Bid_Status__c', 'bidStatusPicklistOpts');
                }else{
                    console.log('not otc bid---')
                    helper.fetchPickListVal(component, 'Phoenix_Bid_Status__c', 'bidStatusPicklistOpts');
                }
                component.set('v.bidCustomerId',bid.Phoenix_Customer__c);
                console.log('bid.Phoenix_Customer__c--'+bid.Phoenix_Customer__c);
                component.set('v.isSpinnerLoad',false);
                helper.getLoginUserDetails(component,event, helper);
            }
        });
        $A.enqueueAction(action);
    },
    getBidType: function(component, event, helper) {
        var action = component.get("c.getBidType");
        action.setParams
        ({
            bidId: component.get('v.bidRecordId')
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state=='SUCCESS'){
                var bidRec = response.getReturnValue();
                component.set('v.bidType',bidRec.Phoenix_Bid_Type__c);
                component.set('v.bidCustomerId',bidRec.Phoenix_Customer__c);
                console.log('bidRec.Phoenix_Customer__c--'+bidRec.Phoenix_Customer__c);
                component.set('v.contractListFromBid',bidRec.Phoenix_Reference_Contracts__c);
                component.set('v.contractVistexUpdate',bidRec.Phoenix_Reference_Contracts__c);
                if( bidRec.Phoenix_Reference_Contracts__c!=null && bidRec.Phoenix_Reference_Contracts__c!=undefined){
                    var refContracts=bidRec.Phoenix_Reference_Contracts__c;
                    component.set("v.selectedCntrcts",refContracts.split(','));
                }
            }
        });
        $A.enqueueAction(action);
        
    },
    fetchContratcs : function(component,event,helper,bidCustomer,searchInput) {
        console.log('bidCustomer---'+bidCustomer);
        var action = component.get("c.getContracts");
        action.setParams
        ({
            customerID: bidCustomer,
            searchInput:searchInput
            
        }); 
        action.setCallback(this, function(response) 
                           {
                               if (response.getState() === "SUCCESS") {
                                   var responseList = response.getReturnValue();
                                   console.log('---responseList---'+responseList.length);
                                   //component.set("v.contratcsList",responseList);
                                   
                                   //below code is for remove seleceted while fetch contracts in table
                                   var sltcntcntrcs=component.get('v.selectedCntrcts');
                                   var finalContratcs = responseList.filter(comparer(sltcntcntrcs)); 
                                   function comparer(otherArray){
                                       return function(current){
                                           return otherArray.filter(function(other){                                               
                                               return other == current.Phoenix_Contract_Number__c 
                                           }).length == 0;
                                       }
                                   }
                                   
                                   for (var i = 0; i < finalContratcs.length; i++) {
                                       var row = finalContratcs[i];
                                       if(row.Phoenix_Customer__c){
                                           row.Phoenix_Customer__c=row.Phoenix_Customer__r.Name;                                           
                                       }                                      
                                   }
                                   component.set("v.contratcsList",finalContratcs);
                                   component.set("v.isSpinner", false);
                               }
                               
                               
                           });
        $A.enqueueAction(action);
    },
    getTemplateType: function(component, event, helper) {
        var action = component.get("c.getTempType");
        action.setParams
        ({
            bidId: component.get('v.recordId')
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state=='SUCCESS'){
                var tempType = response.getReturnValue();
                component.set('v.templateType',tempType);
            }
        });
        $A.enqueueAction(action);
        
    },
    getTemplateTypeCr : function(component, event, helper) {
        var action = component.get("c.getTempTypeCr");
        action.setParams
        ({
            crId: component.get('v.crRecordId')
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state=='SUCCESS'){
                var tempType = response.getReturnValue();
                component.set('v.templateType',tempType);
            }
        });
        $A.enqueueAction(action);
    },
    getLoginUserDetails: function(component, event, helper) {
        component.set('v.isSpinnerLoad',true);       
        console.log('bidRecordId'+component.get("v.bidRecordId"));
        var action = component.get("c.getLoginUserDetails");
        action.setParams
        ({
            bidId: component.get("v.bidRecordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state=='SUCCESS'){
                var isLoginUserAbleToPerform =  response.getReturnValue();
                component.set('v.isLoginUserAbleToPerform',isLoginUserAbleToPerform);
                console.log('isLoginUserAbleToPerform'+isLoginUserAbleToPerform);
                component.set('v.isSpinnerLoad',false);
                var isFromBid = component.get('v.isFromBid');
                console.log('isFromBid---->'+isFromBid)
                if(isLoginUserAbleToPerform){
                    component.find("forceRecord").reloadRecord();
                }
                else {
                    this.getBidStep(component, event, helper);
                }
                if(!isFromBid) {
                    component.find("forceCRRecord").reloadRecord();
                    helper.getCRLItems(component, event, helper);
                }
            }
            
        });
        $A.enqueueAction(action);
    },
    
    getBidStep: function(component, event, helper) {
        component.set('v.isSpinnerLoad',true);       
        console.log('bidRecordId'+component.get("v.bidRecordId"));
        var action = component.get("c.getBidStep");
        action.setParams
        ({
            bidId: component.get("v.bidRecordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state=='SUCCESS'){
                var isCustomerResponseSubmitted =  response.getReturnValue();
                component.set('v.isCustomerResponseSubmitted',isCustomerResponseSubmitted);
                console.log('isCustomerResponseSubmitted'+isCustomerResponseSubmitted);
                component.set('v.isSpinnerLoad',false);
            }
        });
        $A.enqueueAction(action);
    },
    
    getBidLineItems: function(component, event, helper, isFromEditCR) {
        component.set('v.isSpinnerLoad',true);       
        var message = event.getParam("message");
        console.log('bidRecordId'+component.get("v.bidRecordId"));
        var action = component.get("c.getRelatedList");
        action.setParams
        ({
            bidId: component.get("v.bidRecordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state=='SUCCESS'){
                var wrapperObj =  response.getReturnValue();
                if(wrapperObj.lineItemsList.length>0){
                    var lineItemsList = wrapperObj.lineItemsList;
                    var otbDirectIndirect=wrapperObj.otbDirIndir;
                    component.set("v.otbDirIndirect",otbDirectIndirect);
                    console.log('--------otbDirectIndirect------'+lineItemsList[0].Phoenix_Wholesaler_Diff_Price_Indirect__c);
                    
                    var lineItemsWithCheckbox = [];
                    var allRecords = component.get("v.BidLineItemListAll");
                    for(var i =0; i<lineItemsList.length; i++){
                        var rec = lineItemsList[i];
                        //if(allRecords != null && allRecords.length>0 && allRecords[i].isChecked && component.get("v.isBackCalled")){
                        if(allRecords != null && allRecords.length>0 && ('isChecked' in allRecords[i]) && allRecords[i].isChecked && component.get("v.isBackCalled")){ //Added ('isChecked' in allRecords[i]) to fix component error
                            rec.isChecked = true;
                            component.set('v.isNotSelected',false);
                        }else{
                            rec.isChecked = false;
                        }
                        lineItemsWithCheckbox.push(rec);
                    }
                    component.set("v.BidLineItemListAll",lineItemsWithCheckbox);
                    component.set('v.isSpinnerLoad',false);
                    var isFromCR = true;
                    if(isFromEditCR == false)
                        helper.showSuccess(component,event, helper,isFromCR);
                    var OutDiv = component.find("mainDiv");
                    
                    if(lineItemsList.length<10){
                        console.log('--no-hight---');
                        $A.util.addClass(OutDiv, "noheightClass");                                   
                    }else{
                        $A.util.removeClass(OutDiv, "noheightClass");
                    } 
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    
    getBidLineItemsFromBid: function(component, event, helper) {
        component.set('v.isSpinnerLoad',true);       
        var message = event.getParam("message");
        console.log('bidRecordId'+component.get("v.bidRecordId"));
        var action = component.get("c.getRelatedList");
        action.setParams({
            bidId: component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state=='SUCCESS'){
                var wrapperObj =  response.getReturnValue();
                var lineItemsList = wrapperObj.lineItemsList;
                //component.set('v.isSpinnerLoad',false);
                console.log('lineItemsList'+lineItemsList.length);
                if(lineItemsList.length == 0) {
                    helper.showMessagesSection(component, event, helper);
                }
                if(lineItemsList.length > 0) {
                    component.find('bidId').set('v.value',component.get('v.recordId'));                
                }
                component.set('v.isSpinnerLoad',false);
            }
        })
        $A.enqueueAction(action);
    },
    
    showMessagesSection: function(component, event, helper) {
        component.set('v.isSpinnerLoad',true);  
        var action = component.get("c.getBidRelatedList");
        action.setParams({
            bidId: component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state=='SUCCESS'){
                var wrapperObj =  response.getReturnValue();
                var lineItemsList = wrapperObj.lineItemsList;
                //component.set('v.isSpinnerLoad',false);
                console.log('lineItemsList'+lineItemsList.length);
                component.set('v.isSpinnerLoad',false); 
                var isPendingCRLItems = false;
                for(var i =0; i<lineItemsList.length; i++){
                    console.log('Phoenix_Customer_Response__c'+lineItemsList[i].Phoenix_Customer_Response__c);
                    if(lineItemsList[i].Phoenix_Customer_Response__c == undefined) { 
                        console.log('in undefined');
                        isPendingCRLItems = true;
                        break;
                    }
                }
                component.set('v.isPendingCRLItems', isPendingCRLItems);
                if(isPendingCRLItems == false)
                    component.set('v.noBidLineItems', true);
                if(lineItemsList.length == 0) {
                    component.set('v.noBidLineItems', true);
                }
            }
        })
        $A.enqueueAction(action);
    },
    
    getCRLineItems: function(component, event, helper) {
        component.set('v.isSpinnerLoad',true);
        var message = event.getParam("message");
        var action = component.get("c.createCRLineItems");
        action.setParams
        ({
            lineItemList: component.get('v.selectedBidLineItems'),
            crId: component.get('v.crRecordId')
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state=='SUCCESS'){
                helper.fetchPickListVal(component, 'Phoenix_Bid_Status__c', 'bidStatusPicklistOpts');
                console.log('status values-->'+component.get('v.bidStatusPicklistOpts'));
                var wrapperObj =  response.getReturnValue();
                var crLineItemsList = wrapperObj.crLineItemsList;
                console.log('rec crLineItemsList'+crLineItemsList.length);
                component.set("v.CRLineItemListAll",crLineItemsList);
                crLineItemsList.forEach(function(crLine){
                    console.log('EachLine-->'+JSON.stringify(crLine));
                });
                component.set('v.isSpinnerLoad',false);
                component.set('v.isCRScreen',false);
                component.set('v.isBidLineItemScreen',false);
                component.set('v.isCRLineItemScreen',true);
                component.set("v.selectedPosistions",[]); 
                var LineItemtable = component.find("LineTable");
                component.set("v.tableRef", LineItemtable); 
                var OutDiv = component.find("mainDiv");
                if(crLineItemsList.length<10){
                    console.log('--no-hight---');
                    $A.util.addClass(OutDiv, "noheightClass");                                   
                }else{
                    $A.util.removeClass(OutDiv, "noheightClass");
                } 
            }
              else{
                console.log('errot---'+JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);
    },
    
    getCRLItems: function(component, event, helper) {
        component.set('v.isSpinnerLoad',true);
        var action = component.get("c.getCRLineItems");
        action.setParams
        ({
            crId: component.get('v.crRecordId')
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state=='SUCCESS'){
                
                var wrapperObj =  response.getReturnValue();
                var crLineItemsList = wrapperObj.crLineItemsList;
                console.log('rec crLineItemsList'+crLineItemsList.length);
                for(var i =0; i<crLineItemsList.length; i++){
                    var rec = crLineItemsList[i];
                    crLineItemsList[i].Phoenix_Customer_Decline_Reasons__c = '';
                    console.log('rec'+JSON.stringify(rec));
                    console.log('rec Phoenix_Bid_Line_Item__r'+rec.Phoenix_Bid_Line_Item__r.Phoenix_Customer_Response__c);
                    console.log('rec Phoenix_Bid_Line_Item__r'+ 'undefined'==rec.Phoenix_Bid_Line_Item__r.Phoenix_Customer_Response__c);
                    if(rec.Phoenix_Bid_Line_Item__r.Phoenix_Customer_Response__c){
                        console.log('rec isCRAddedToBidLineItem');
                        component.set('v.isCRAddedToBidLineItem',true);
                        break;
                    }
                    else if(i == (crLineItemsList.length)-1) {
                        console.log('rec isCRAddedToBidLineItem false');
                        component.set('v.isCRAddedToBidLineItem',false);
                    }
                }
                component.set("v.CRLineItemListAll",crLineItemsList);
                component.set('v.isSpinnerLoad',false);
                component.set('v.isCRScreen',false);
                component.set('v.isBidLineItemScreen',false);
                component.set('v.isCRLineItemScreen',true);
                component.set("v.selectedPosistions",[]); 
                var LineItemtable = component.find("LineTable");
                component.set("v.tableRef", LineItemtable); 
                var OutDiv = component.find("mainDiv");
                if(crLineItemsList.length<10){
                    console.log('--no-hight---');
                    $A.util.addClass(OutDiv, "noheightClass");
                }else{
                    $A.util.removeClass(OutDiv, "noheightClass");
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    finalSubmit: function(component, event, helper) {
        component.set('v.isSpinnerLoad',true);
        var message = event.getParam("message");
        var action = component.get("c.updateCRLIRealatedBidLI");
        action.setParams
        ({
            crLineItemList: component.get('v.CRLineItemListAll'),
            bidId: component.get('v.bidRecordId')
        });
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                console.log('Success');
                var wrapperObj =  response.getReturnValue();
                var isFromCR = false;
                helper.showSuccess(component,event, helper,isFromCR);
            }
        });
        $A.enqueueAction(action);
        
    },
    
    showSuccess : function(component, event, helper,isFromCR) {
        console.log('showSuccess');
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Success',
            message: isFromCR ? 'Customer Response was created.' : 'Customer Response Line Items were saved.',
            duration:' 5000',
            key: 'info_alt',
            type: 'success',
            mode: 'pester'
        });
        toastEvent.fire();
    },
    
    checkAwardedQuantityRecs : function(component, event, helper){
        console.log('Inside checkAwardedQuantityRecs');
        var action = component.get("c.checkAwardedQuantityRecList");
        action.setParams
        ({
            crLineItemList: component.get('v.CRLineItemListAll')
        });
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                console.log('state from checkAwardedQuantityRecList :: Success');
                var prodList =  response.getReturnValue();
                console.log('testing**==>'+JSON.stringify(prodList))
                if(prodList == 'false' || component.get("v.bidType") == 'Initial Order Discount for WAC Customers (No-Contract Price Offering)'){
                    helper.finalSubmit(component, event, helper);
                    var navEvt = $A.get("e.force:navigateToSObject");
                    var isFromBid = component.get('v.isFromBid');
                    navEvt.setParams({
                        "recordId": isFromBid ? component.get('v.bidRecordId') : component.get('v.crRecordId'),
                        "slideDevName": "related"
                    });
                    
                    window.setTimeout(
                        $A.getCallback(function() {
                            navEvt.fire();
                        }), 2000
                    ); 
                }
                else{
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Error',
                        message: 'Awarded Quantity is not allocated for --'+prodList+' Products.',
                        duration:' 5000',
                        key: 'info_alt',
                        type: 'error',
                        mode: 'pester'
                    });
                    toastEvent.fire();
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    deleteLineItems : function(component, event, helper) {
        var action = component.get("c.deleteSelectedLineItems");
        action.setParams({
            'bidLIIdList' : component.get('v.selectedBidLIIdList')
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('state--->'+state);
        });
        $A.enqueueAction(action);
    },
    
    requiredValidation : function(component,event) {
        // get all records.. 	
        var allRecords = component.get("v.CRLineItemListAll");
        var isValid = true;
        for(var i = 0; i < allRecords.length;i++){
            console.log('inside for');
            var bidStatus = allRecords[i].Phoenix_Bid_Status__c;
            console.log('bidStatus----'+bidStatus);
            console.log('supply effe==='+allRecords[i].Phoenix_Supply_Effective_Date__c);
                        console.log('price effe==='+allRecords[i].Phoenix_Price_Effective_Date__c);
            console.log('decline reason==='+allRecords[i].Phoenix_Customer_Decline_Reasons__c);
console.log('cust decline reason====='+component.set("v.customerDecPicklistOpts"));
            console.log('cust decline reason bid====='+component.set("v.bidStatusPicklistOpts"));

            //console.log('Phoenix_Customer_Decline_Reasons__c::'+allRecords[i].Phoenix_Customer_Decline_Reasons__c === 'undefined');
            if(bidStatus == null || bidStatus == '' || bidStatus == '--- None ---') {
                var msg = 'Complete this field : Row No ' + (i+1) + ' Bid Status is blank'
                component.set('v.errorMessage',msg);
                isValid = false;
                break;
            }
            else if(bidStatus == 'Awarded' || bidStatus == 'Pending'){
                component.set('v.isPendingLineExist',false);
                if((!component.get("v.isOTCBid") && component.get("v.bidType") != 'Initial Order Discount for WAC Customers (No-Contract Price Offering)') &&(allRecords[i].Phoenix_Award_Position__c == null || allRecords[i].Phoenix_Award_Position__c.trim() == '')){
                    var msg = 'Complete this field : Row No ' + (i+1) + ' Award Position is blank'
                    component.set('v.errorMessage',msg);
                    isValid = false;
                    break;
                }
                else if(allRecords[i].Phoenix_Awarded_Quantity__c == null || (allRecords[i].Phoenix_Awarded_Quantity__c == '' && allRecords[i].Phoenix_Awarded_Quantity__c != 0)){
                    var msg = 'Complete this field : Row No ' + (i+1) + ' Award Quantity is blank'
                    component.set('v.errorMessage',msg);
                    isValid = false;
                    break;
                }
                    else if((allRecords[i].Phoenix_Supply_Effective_Date__c == null || allRecords[i].Phoenix_Supply_Effective_Date__c =='')&& component.get("v.bidType")!='Price Change' && component.get("v.bidType")!='Sales Out Rebate' && component.get("v.bidType")!='Customer Rebate Change' && component.get("v.bidType")!='New Product Launch'){
                       console.log('Supply Effective');
                        var msg = 'Complete this field : Row No ' + (i+1) + ' Supply Effective Date is blank'
                        component.set('v.errorMessage',msg);
                        isValid = false;
                        break;
                    }
                        else if((allRecords[i].Phoenix_Price_Effective_Date__c == null || allRecords[i].Phoenix_Price_Effective_Date__c == '') && component.get('v.bidType')!='Volume Review Only'){
                         console.log('Price Effective');
                            var msg = 'Complete this field : Row No ' + (i+1) + ' Price Effective Date is blank'
                            component.set('v.errorMessage',msg);
                            isValid = false;
                            break;
                        }
                            else if(allRecords[i].Phoenix_Customer_Decline_Reasons__c != '' && allRecords[i].Phoenix_Customer_Decline_Reasons__c != undefined){
                                console.log('Phoenix_Customer_Decline_Reasons__c::'+allRecords[i].Phoenix_Customer_Decline_Reasons__c);
                                var msg = 'Complete this field : Row No ' + (i+1) + ' Customer Decline Reasons should be none for this Bid Status'
                                component.set('v.errorMessage',msg);
                                isValid = false;
                                break;
                            }
                                else if(bidStatus == 'Pending') {
                                    component.set('v.isPendingLineExist',true);
                                    isValid = true;
                                    break;
                                }
            }
                else if(bidStatus == 'Pending'){
                    component.set('v.isPendingLineExist',true);
                    isValid = true;
                    break;
                }
                    else {
                        component.set('v.isPendingLineExist',false);
                        if(allRecords[i].Phoenix_Customer_Decline_Reasons__c == null || allRecords[i].Phoenix_Customer_Decline_Reasons__c == ''){
                            var msg = 'Complete this field : Row No ' + (i+1) + ' Customer Decline Reasons is blank'
                            component.set('v.errorMessage',msg);
                            isValid = false;
                            break;
                        }
                    }
        }
        if(!isValid && !component.get('v.isPendingLineExist')){
            component.set('v.isPendingLineExist',true); 
        }              
        return isValid;
    },
    
    requiredValidationForFinalSubmit : function(component,event) {
        // get all records.. 	
        var allRecords = component.get("v.CRLineItemListAll");
        var isValid = true;
        for(var i = 0; i < allRecords.length;i++){
            var bidStatus = allRecords[i].Phoenix_Bid_Status__c;
            if(bidStatus == 'Pending') {
                isValid = false;
                break;
            }
        }
        return isValid;
    },
    
    /*Upload documnet section */
    handleUploadFinished : function(component, event) {
        console.log('v.crRecordId::'+component.get('v.crRecordId'));
        var fileList = component.get('v.fileList');
        var contentDCIdList = [];
        for(var i=0; i<fileList.length; i++) {
            contentDCIdList.push(fileList[i].documentId);
        }
        var action = component.get('c.createContentDCLink');
        action.setParams({
            'crId' : component.get("v.crRecordId"),
            'contentDCIdList' : contentDCIdList
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var response = response.getReturnValue();
            }  
        });
        $A.enqueueAction(action);
    },
    
    deleteAttachments: function (component, event, helper) {
        component.set('v.isSpinnerLoad',true);
        var fileList = component.get('v.fileList');
        var contentDCIdList = [];
        for(var i=0; i<fileList.length; i++) {
            contentDCIdList.push(fileList[i].documentId);
        }
        if(contentDCIdList.length > 0){
            var action = component.get("c.deleteAttachmentList");
            action.setParams({
                'LineItemIds' : contentDCIdList
            });
            action.setCallback(this,function(response) {
                var state = response.getState();
                if(state=='SUCCESS'){
                    component.set('v.isSpinnerLoad',false);
                    console.log('response::'+response.getReturnValue());
                }
            });
            $A.enqueueAction(action);
        }
    },
    convertArrayOfObjectsToCSV : function(component,objectRecords,template){
        var otbDirIndir= component.get("v.otbDirIndirect");
        var bidtype=component.get("v.bidType");
        var otcBid = component.get("v.isOTCBid");
        // declare variables
        var csvStringResult, counter, keys,columnDivider, lineDivider;
        
        // check if "objectRecords" parameter is null, then return from function
        if (objectRecords == null || !objectRecords.length) {
            return null;
        }
        // store ,[comma] in columnDivider variabel for sparate CSV values and 
        // for start next line use '\n' [new line] in lineDivider varaible  
        columnDivider = ',';
        lineDivider =  '\n';
        csvStringResult = '';
        var selling_unit='1';
        var myMap = new Map();
        //myMap.set("Bid Line Item", "Phoenix_Bid_Line_Item__r.Name");
        myMap.set("NDC", "Phoenix_NDC_National_Drug_Code__c");
        myMap.set("Product Name", "Phoenix_Product_Name__c");
        myMap.set("SAP Number", "Phoenix_SAP_Number__c");
        myMap.set("Pkg Size", "Phoenix_Pkg_Size__c");
        myMap.set("Case Pack", "Phoenix_Case_Pack__c");
        myMap.set("Product Family", "Product_Family_Name__c");
        if(otcBid){
        myMap.set("Approved Total DRL Units", "Phoenix_Final_Total_Selling_Unit__c");   
        }
        else if(!otcBid){
        myMap.set("Final Total Selling Unit", "Phoenix_Final_Total_Selling_Unit__c");}
        if(template=='RXSS'){
            myMap.set("Retail Direct Marketing Price", "Phoenix_Retail_Direct_Marketing_Price__c");
            myMap.set("Retail Indirect Marketing Price", "Phoenix_Retail_Indirect_Marketing_Price__c");
            myMap.set("Retail Indirect Net (Marketing)", "Retail_Indirect_Net_Marketing__c");//Added code by Rama
            myMap.set("Wholesaler Price", "Wholesaler_Price__c");//Added code by Rama

        }
       else if(template=='ClarusOne'){
            myMap.set("Final Approved Pricing McK OS And RAD", "Phoenix_Bid_Line_Item__r.Phoenix_Proposed_McK_OS_And_RAD_NCP__c");
            myMap.set("Final Approved Pricing - WMT Direct", "Phoenix_Bid_Line_Item__r.Phoenix_Proposed_WMT_Direct_NCP__c");
            myMap.set("Final Approved Pricing - WMT Indirect", "Phoenix_Bid_Line_Item__r.Phoenix_Proposed_WMT_Indirect_NCP__c");
        }
        else if(template=='BASE/DSH'){
            myMap.set("Proposed BASE Contract Price", "Phoenix_Retail_Direct_Marketing_Price__c");
            myMap.set("Proposed DSH Contract Price", "Phoenix_Proposed_DSH_Contract_Price__c");
            myMap.set("Proposed AutoSub Contract Price", "Phoenix_Retail_Indirect_Marketing_Price__c");
            
        }
        else if(template=='Econdisc'){
               myMap.set("Wholesaler Diff Price (Indirect)", "Final_Indirect_Price__c");
               myMap.set("Proposed Contract Bid Price (Marketing)", "Final_Direct_Price__c");
            
        }
            else if(template=='OneTimeBuy' && otbDirIndir=='Direct'){
                myMap.set("Proposed Direct Contract Price (Marketing)", "Phoenix_CR_Direct_Mrktng_Price__c");
            }
                else if(template=='OneTimeBuy' && otbDirIndir=='Indirect'){
                    myMap.set("Proposed Indirect Contract Price (Marketing)", "Phoenix_CR_Indirect_Mrktng_Price__c");
                }
                    else if(template=='Sams Club'){
                        if(bidtype !='Volume Review Only'){
                            myMap.set("Final Direct Price", "Phoenix_CR_Direct_Mrktng_Price__c");
                            myMap.set("Final Indirect Price", "Phoenix_CR_Indirect_Mrktng_Price__c");
                        }
                        else{
                            myMap.set("Current Indirect Contract Price", "Final_Direct_Price__c");
                            myMap.set("Current Net Indirect Price", "Final_Indirect_Price__c");
                            
                        }
                    }
                        else if(template=='ROS'){
                            myMap.set("CVS Direct Contract Price", "Bid_Line_Item_Extn__r.Phoenix_Proposed_CvsDirectContractPrice__c");
                            myMap.set("CVS Indirect Contract Price", "Phoenix_Bid_Line_Item__r.Phoenix_ProposedContractBidPriceMktng__c");
                            myMap.set("CVS Cardinal Contract Price", "Phoenix_Bid_Line_Item__r.Phoenix_Wholesaler_Diff_Price_Indirect__c");
                            myMap.set("CVS Major Contract Price", "Bid_Line_Item_Extn__r.Phoenix_Proposed_Major_Contract_Price__c");
                            myMap.set("Cardinal Rebate %", "Phoenix_Cardinal_Rebate_Per__c");
                            myMap.set("major Rebate %", "Phoenix_Major_Rebate_per__c");
                        }
                        else {
                            if(bidtype != 'Platform PO OTB' && bidtype != 'Platform OTB' && bidtype !=' Initial Order Discount for WAC Customers (No-Contract Price Offering)'&&!otcBid){
                            myMap.set("Final Approved Pricing (Contracts)", "Phoenix_Final_Approvd_Pricing_Contracts__c");
                            }
                            else if(otcBid){
                             myMap.set("Approved Sell Price", "Phoenix_Final_Approvd_Pricing_Contracts__c");

                            }
                        }
        if(template!='RXSS' && template!='Sams Club'){
            myMap.set("Rebate %", "Phoenix_Rebate__c");
        }
        if(bidtype !='Price Change' && bidtype !='Sales Out Rebate' && bidtype !='Customer Rebate Change'){
            myMap.set("Lead Time", "Phoenix_Lead_Time_Days__c");
        }
        myMap.set("Bid Status", "Phoenix_Bid_Status__c");
        if(!otcBid){
        myMap.set("Customer Decline Reasons", "Phoenix_OTC_Customer_Comments__c");
        }
        else if(otcBid){
           myMap.set("Customer Comments", "Phoenix_Customer_Decline_Reasons__c");    
        }
        if(!otcBid && template!='ClarusOne' && bidtype != 'Platform PO OTB' && bidtype != 'Platform OTB' && bidtype != 'Initial Order Discount for WAC Customers (No-Contract Price Offering)'){
        myMap.set("Award Position", "Phoenix_Award_Position__c");
        }
        if(template=='ClarusOne' && bidtype != 'Platform PO OTB' && bidtype != 'Platform OTB'){
            myMap.set("WMT/MCK Award Position", "Phoenix_Award_Position__c");
            
        }
        myMap.set("Awarded Quantity", "Phoenix_Awarded_Quantity__c");
        myMap.set("Supply Effective Date", "Phoenix_Supply_Effective_Date__c");
        myMap.set("Price Effective Date", "Phoenix_Price_Effective_Date__c");
        csvStringResult += Array.from(myMap.keys()).join(columnDivider);
        csvStringResult += lineDivider;
        //new logic start 
        for(var i=0; i < objectRecords.length; i++){  
            counter = 0;
            
            for (let [key, value] of myMap) {
                if(counter > 0){ 
                    csvStringResult += columnDivider; 
                }
                //console.log(JSON.stringify(objectRecords[i]));
                if(value=='Phoenix_Bid_Line_Item__r.Name'){
                    csvStringResult += '"'+ objectRecords[i]["Phoenix_Bid_Line_Item__r"]["Name"]+'"';
                }
                else if(value=='Bid_Line_Item_Extn__r.Phoenix_Proposed_CvsDirectContractPrice__c' && objectRecords[i].Bid_Line_Item_Extn__r.Phoenix_Proposed_CvsDirectContractPrice__c != undefined){
                    csvStringResult += '"'+ objectRecords[i].Bid_Line_Item_Extn__r.Phoenix_Proposed_CvsDirectContractPrice__c+'"';
                }
                    else if(value=='Bid_Line_Item_Extn__r.Phoenix_Proposed_Major_Contract_Price__c' && objectRecords[i].Bid_Line_Item_Extn__r.Phoenix_Proposed_Major_Contract_Price__c != undefined){	
                        csvStringResult += '"'+ objectRecords[i].Bid_Line_Item_Extn__r.Phoenix_Proposed_Major_Contract_Price__c+'"';
                    }
                        else if(value=='Phoenix_Bid_Line_Item__r.Phoenix_Wholesaler_Diff_Price_Indirect__c' && objectRecords[i].Phoenix_Bid_Line_Item__r.Phoenix_Wholesaler_Diff_Price_Indirect__c != undefined){	
                            csvStringResult += '"'+ objectRecords[i].Phoenix_Bid_Line_Item__r.Phoenix_Wholesaler_Diff_Price_Indirect__c+'"';
                        }
                            else if(value=='Phoenix_Bid_Line_Item__r.Phoenix_ProposedContractBidPriceMktng__c' && objectRecords[i].Phoenix_Bid_Line_Item__r.Phoenix_ProposedContractBidPriceMktng__c != undefined){	
                                csvStringResult += '"'+ objectRecords[i].Phoenix_Bid_Line_Item__r.Phoenix_ProposedContractBidPriceMktng__c+'"';
                            }
                                else if(value=='Phoenix_Bid_Line_Item__r.Phoenix_Proposed_McK_OS_And_RAD_NCP__c'){	
                                    if(objectRecords[i]["Phoenix_Bid_Line_Item__r"]["Phoenix_Proposed_McK_OS_And_RAD_NCP__c"] != null){
                                        csvStringResult += '"'+ objectRecords[i]["Phoenix_Bid_Line_Item__r"]["Phoenix_Proposed_McK_OS_And_RAD_NCP__c"]+'"';
                                    }else{
                                        csvStringResult += '"'+ objectRecords[i]["Phoenix_Bid_Line_Item__r"]["Phoenix_Sales_Proposed_NCP_McK_And_RAD__c"]+'"';
                                    }
                                    
                                }
                else if(value=='Phoenix_Bid_Line_Item__r.Phoenix_Proposed_WMT_Direct_NCP__c'){	
                    if(objectRecords[i]["Phoenix_Bid_Line_Item__r"]["Phoenix_Proposed_WMT_Direct_NCP__c"] != null){
                        csvStringResult += '"'+ objectRecords[i]["Phoenix_Bid_Line_Item__r"]["Phoenix_Proposed_WMT_Direct_NCP__c"]+'"';
                    }else{
                        csvStringResult += '"'+ objectRecords[i]["Phoenix_Bid_Line_Item__r"]["Phoenix_ProposedContract_Bid_Price_Sales__c"]+'"';
                    }
                     
                }
                else if(value=='Phoenix_Bid_Line_Item__r.Phoenix_Proposed_WMT_Indirect_NCP__c'){
                    if(objectRecords[i]["Phoenix_Bid_Line_Item__r"]["Phoenix_Proposed_WMT_Indirect_NCP__c"] != null){
                     	csvStringResult += '"'+ objectRecords[i]["Phoenix_Bid_Line_Item__r"]["Phoenix_Proposed_WMT_Indirect_NCP__c"]+'"';   
                    }else{
                        csvStringResult += '"'+ objectRecords[i]["Phoenix_Bid_Line_Item__r"]["Phoenix_ProposedContract_Bid_Price_Sales__c"]+'"';
                    }
                     
                }
                else if(objectRecords[i][value]==undefined){
                    
                    csvStringResult += '"'+''+'"';
                }
                else if(value == 'Final_Direct_Price__c'){
                                        var VIPPerUnitdl = objectRecords[i]['Final_Direct_Price__c'];
                                        // console.log("VIPPerUnitdl--->"+VIPPerUnitdl);
                                        if(VIPPerUnitdl != null){
                                            var roundevipperudl=Math.round((VIPPerUnitdl ) * 100) / 100
                                            csvStringResult += '"'+roundevipperudl+'"';  
                                        }
                                        else{
                                            csvStringResult += '"'+''+'"';
                                        }
                                    }
                else if(value == 'Final_Indirect_Price__c'){
                                        var VIPPerUnitdl = objectRecords[i]['Final_Indirect_Price__c'];
                                        // console.log("VIPPerUnitdl--->"+VIPPerUnitdl);
                                        if(VIPPerUnitdl != null){
                                            var roundevipperudl=Math.round((VIPPerUnitdl ) * 100) / 100
                                            csvStringResult += '"'+roundevipperudl+'"';  
                                        }
                                        else{
                                            csvStringResult += '"'+''+'"';
                                        }
                                    }
                else if(value == 'Phoenix_CR_Direct_Mrktng_Price__c'){
                                        var VIPPerUnitdl = objectRecords[i]['Phoenix_CR_Direct_Mrktng_Price__c'];
                                        // console.log("VIPPerUnitdl--->"+VIPPerUnitdl);
                                        if(VIPPerUnitdl != null){
                                            var roundevipperudl=Math.round((VIPPerUnitdl ) * 100) / 100
                                            csvStringResult += '"'+roundevipperudl+'"';  
                                        }
                                        else{
                                            csvStringResult += '"'+''+'"';
                                        }
                                    }
                else if(value == 'Phoenix_CR_Indirect_Mrktng_Price__c'){
                                        var VIPPerUnitdl = objectRecords[i]['Phoenix_CR_Indirect_Mrktng_Price__c'];
                                        // console.log("VIPPerUnitdl--->"+VIPPerUnitdl);
                                        if(VIPPerUnitdl != null){
                                            var roundevipperudl=Math.round((VIPPerUnitdl ) * 100) / 100
                                            csvStringResult += '"'+roundevipperudl+'"';  
                                        }
                                        else{
                                            csvStringResult += '"'+''+'"';
                                        }
                                    }
                    else{
                        csvStringResult += '"'+ objectRecords[i][value]+'"';
                    }
                
                counter++;
            }
            csvStringResult += lineDivider;
        }
        //new logic end 
        
        return csvStringResult;        
    },
    
    fetchPickListVal: function(component, fieldName, picklistOptsAttributeName) {
        var action = component.get('c.getselectOptions');
        action.setParams({
            "objObject": component.get('v.objInfoForPicklistValues'),
            "fld": fieldName
        });
        var opts = [];
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var allValues = response.getReturnValue();
                console.log('allValues:'+allValues);
                
                if (allValues != undefined && allValues.length > 0) {
                    opts.push({
                        class: "optionClass",
                        label: "--- None ---",
                        value: "--- None ---",
                        key: ""
                    });
                }
                for (var i = 0; i < allValues.length; i++) {
                    opts.push({
                        class: "optionClass",
                        label: allValues[i],
                        value: allValues[i],
                        key: allValues[i]
                    });
                }
                component.set("v." + picklistOptsAttributeName, opts);
            }
        });
        $A.enqueueAction(action);
    },
    
    fetchSecondPickListVal: function(component, event, helper) {
        helper.fetchPickListVal(component, 'Phoenix_Customer_Decline_Reasons__c', 'customerDecPicklistOpts');
    },
    
    onAction : function(component, event, helper) {
        var objCompB = component.find('childCmp');
        console.log('objCompB'+objCompB.length);  
        var bs=component.get('v.showErrorClassBS');
        var cdr=component.get('v.showErrorClassCDR');
        var ap=component.get('v.showErrorClassAP');
        var aq=component.get('v.showErrorClassAQ');
        var sed=component.get('v.showErrorClassSED');
        var ped=component.get('v.showErrorClassPED');
        if(Array.isArray(objCompB)){            
            for(var i=0;i<objCompB.length;i++){                
                console.log(bs+'--'+cdr+'--'+ap+'--'+aq+'--'+sed+'--'+ped);
                objCompB[i].sampleMethod(bs,cdr,ap,aq,sed,ped);
            }
        }else{
            console.log(bs+'--'+cdr+'--'+ap+'--'+aq+'--'+sed+'--'+ped);
            objCompB.sampleMethod(bs,cdr,ap,aq,sed,ped);
        }
        
    },
    fetchPositions: function (component, event, helper, bidCustomer) {
        console.log('bidCustomer---' + bidCustomer);
        var action = component.get("c.getPositions");
        action.setParams({
            customerID: bidCustomer
            // searchInput:searchInput
            
        });
        action.setCallback(this, function (response) {
            if (response.getState() === "SUCCESS") {
                var responseList = response.getReturnValue();
                console.log('---responseList---' + responseList.length);
                //component.set("v.contratcsList",responseList);
                
                //below code is for remove seleceted while fetch contracts in table
                var slctpositions = component.get('v.selectedPosistions');
                var finalPositions = responseList.filter(comparer(slctpositions));
                
                function comparer(otherArray) {
                    return function (current) {
                        return otherArray.filter(function (other) {
                            console.log(other);
                            return other == current.Name
                        }).length == 0;
                    }
                }
                
                for (var i = 0; i < finalPositions.length; i++) {
                    var row = finalPositions[i];
                    if (row.Phoenix_Customer__c) {
                        row.Phoenix_Customer__c = row.Phoenix_Customer__r.Name;
                    }
                }
                component.set("v.positionsList", finalPositions);
            }
            
            
        });
        $A.enqueueAction(action);
    },
    fetchMCKPositions: function (component, event, helper, bidCustomer) {
        console.log('bidCustomer---' + bidCustomer);
        var action = component.get("c.getPositions");
        action.setParams({
            customerID: bidCustomer
            // searchInput:searchInput
            
        });
        action.setCallback(this, function (response) {
            if (response.getState() === "SUCCESS") {
                var responseList = response.getReturnValue();
                console.log('---responseList---' + responseList.length);
                //component.set("v.contratcsList",responseList);
                
                //below code is for remove seleceted while fetch contracts in table
                var slctpositions = component.get('v.selectedMCKPosistions');
                var finalPositions = responseList.filter(comparer(slctpositions));
                
                function comparer(otherArray) {
                    return function (current) {
                        return otherArray.filter(function (other) {
                            console.log(other);
                            return other == current.Name
                        }).length == 0;
                    }
                }
                
                for (var i = 0; i < finalPositions.length; i++) {
                    var row = finalPositions[i];
                    if (row.Phoenix_Customer__c) {
                        row.Phoenix_Customer__c = row.Phoenix_Customer__r.Name;
                    }
                }
                component.set("v.MCKpositionsList", finalPositions);
                
            }
            
            
        });
        $A.enqueueAction(action);
    },
    
    
    
})