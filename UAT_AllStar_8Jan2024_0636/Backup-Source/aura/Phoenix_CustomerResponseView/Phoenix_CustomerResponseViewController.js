({
    doInit: function(component, event, helper) { 
      //  component.set('v.BidLineItemListAll','');
        component.set('v.recordId', component.get("v.pageReference").state.c__id);
        console.log('---bidRecordId--id--from url-'+component.get('v.recordId'));
        component.set('v.crRecordId', component.get("v.pageReference").state.cr__id);
        console.log('---crRecordId--id--from url-'+component.get('v.crRecordId'));
        component.set('v.isSpinnerLoad',false);
        component.set("v.isBackCalled",false);
        component.set('v.isNotSelected',true);
        component.set('v.noBidLineItems',false);
        component.get('v.isFromBid',false);
        component.get('v.isCRAddedToBidLineItem',false);
        component.set('v.selectAll', false);
        component.set('v.isAllValidationSuccess', false);
        component.set('v.isLoginUserAbleToPerform', false);
        component.set('v.enableProceedButton', false);
        component.set('v.isPendingLineExist', true);
        component.set('v.isCustomerResponseSubmitted', false);
        component.set('v.disableCustomerDecPicklistOpts', false);
        component.set('v.bidStatusValue', '');
        component.set('v.showErrorClassCDR', false);
        component.set('v.showErrorClassAP', false);
        component.set('v.showErrorClassAQ', false);
        component.set('v.showErrorClassSED', false);
        component.set('v.showErrorClassPED', false);
        component.set('v.simpleCRRecord',[]);
        component.set('v.CRLineItemListAll','');
        var bRecId = component.get('v.recordId');
        var crRecId = component.get('v.crRecordId');
          
        if(bRecId) {
            component.set('v.isFromBid',true);
            component.set('v.isCRScreen',true);
            component.set('v.isBidLineItemScreen',false);
            component.set('v.isCRLineItemScreen',false);
            component.set('v.fileList',[]);
            component.set('v.bidRecordId',component.get('v.recordId'));
            helper.getLoginUserDetails(component, event, helper);
            helper.getBidType(component, event, helper);
            helper.getTemplateType(component, event, helper);
        }
        else if(crRecId) {
            component.set('v.isFromBid',false);
            console.log('v.crRecordId',component.get('v.crRecordId'));
            helper.getBidId(component,event, helper);
            helper.getTemplateTypeCr(component, event, helper);
        }
            else {
                component.set('v.isCRScreen',true);
                component.set('v.isBidLineItemScreen',false);
                component.set('v.isCRLineItemScreen',false);
                component.set('v.simpleRecord',[]);
                component.set('v.simpleCRRecord',[]);
                component.find('bidId').set('v.value','');
            }
       
        helper.fetchSecondPickListVal(component, event, helper);
         helper.getBidLastActivity(component, event, helper)
    },
    
    getBidInformation : function(component, event, helper) {
        let bidId = component.find('bidId').get('v.value');
        console.log('bid Id::'+bidId);
        component.set('v.bidRecordId',bidId);
        component.set('v.recordId',bidId);
        component.find("forceRecord").reloadRecord();
    },
    showModel: function(component, event, helper) {
        component.set("v.showModal", true);
        component.set("v.isSpinner", true);
        component.set('v.mycolumns', [
            {label: 'Name', fieldName: 'Phoenix_Contract_Number__c', type: 'text'},
            {label: 'Customer', fieldName: 'Phoenix_Customer__c', type: 'text'},
            {label: 'Internal Description', fieldName: 'Phoenix_Contract_Internal_Description__c', type: 'text'},
            {label: 'External Description', fieldName: 'Phoenix_Contract_External_Description__c', type: 'Text'}
        ]); 
        var searchInput=component.find("cntInput").get("v.value");
        
        var bidCustomer=component.get("v.bidCustomerId");
        
        if(bidCustomer!=null && bidCustomer!=undefined){
            helper.fetchContratcs(component, event,helper,bidCustomer,searchInput);
        } else{
            component.set("v.contratcsList",null);
            component.set("v.isSpinner", false);
        }      
    },  
    onRecordSubmit : function(component, event, helper){
        component.set('v.isSpinnerLoad',true);
        event.preventDefault(); 
        var slctCntrcts=component.get("v.selectedCntrcts");
        var eventFields = event.getParam("fields");
        eventFields["Phoenix_Customer__c"] =component.get('v.simpleRecord.Phoenix_Customer__c');
        eventFields["Phoenix_Affected_Contract_s__c"] = slctCntrcts.toString();//simpleRecord.Phoenix_Reference_Contracts__c');
        eventFields["Phoenix_Sent_to_Customer_Date__c"] = component.get('v.simpleRecord.Phoenix_Sent_to_Customer_Date__c'); 
		eventFields["Phoenix_Contracts_for_Vistex_Update__c"] = component.get('v.contractVistexUpdate');
        eventFields["Phoenix_Contract_Status__c"] = 'Not Completed';
        /*var positions = component.get("v.selectedPosistions").toString();
        eventFields["Phoenix_Mck_Proposed_Position__c"] = positions;*/
        var currentCd = eventFields["Phoenix_Current_CD__c"] ;
        component.find("CRForm").submit(eventFields);
        
    },
    
    onRecordSuccess : function(component, event, helper) {
        console.log('sucess----'+event.getParam("response").id);
        var crId = event.getParam("response").id;
        component.set('v.crRecordId',crId);
        helper.handleUploadFinished(component, event);
        component.find("forceCRRecord").reloadRecord();
        console.log('after success return');
        component.set('v.isCRScreen',false);
        component.set('v.isBidLineItemScreen',true);
        component.set('v.isCRLineItemScreen',false);
        var isFromEditCR = false;
        helper.getBidLineItems(component, event, helper,isFromEditCR);
    },
    
    searchContracts : function(component, event, helper) {
        component.set("v.isSpinner", true);
        var searchInput=component.find("cntInput").get("v.value");
        
        var checkToggle=component.find("tgleCntrct").get("v.checked");            
        var bidCustomer=component.get("v.bidCustomerId");
        
        if(checkToggle==true){
            helper.fetchContratcs(component, event,helper,null,searchInput);
        }
        else{
            if(bidCustomer!=null && bidCustomer!=undefined){
                helper.fetchContratcs(component, event,helper,bidCustomer,searchInput);
            }else{
                component.set("v.contratcsList",null);
            }
        }
    },  
    
    saveDetails : function(component, event, helper) {
        var selectrcs=component.find('linesTable').getSelectedRows(); 
        var selectedCntrcts=component.get("v.selectedCntrcts");
        for(var i=0;i<selectrcs.length;i++){
            selectedCntrcts.push(selectrcs[i].Phoenix_Contract_Number__c);
        }    
        component.set("v.selectedCntrcts",selectedCntrcts);
        component.set("v.showModal", false);
    },
    
    clearCntract :function(component,event,heplper){
        var selectedPillId = event.getSource().get("v.name");
        var AllPillsList = component.get("v.selectedCntrcts"); 
        
        for(var i = 0; i < AllPillsList.length; i++){
            if(AllPillsList[i] == selectedPillId){
                AllPillsList.splice(i, 1);
                component.set("v.selectedCntrcts", AllPillsList);
            }  
        } 
        component.set("v.showSaveCancelBtn",true);
    },
    hideContractModel: function(component, event, helper) {
        component.set("v.showModal", false);
    }, 
    onClickCheckbox: function(component, event, helper) {
        var allRecords = component.get("v.BidLineItemListAll");
        var selectedRecCheck = event.getSource().get("v.checked");
        if(selectedRecCheck) {
            component.set('v.isNotSelected',false);
        }
        for (var i = 0; i < allRecords.length; i++) {
            console.log('onClickCheckbox: 1');
            if (allRecords[i].isChecked) {
                component.set('v.isNotSelected',false);
                break;
            }
            else if(i == (allRecords.length)-1){
                component.set('v.isNotSelected',true);
            }
        }
        var recCount = 0;
        for (var i = 0; i < allRecords.length; i++) {
            if (allRecords[i].isChecked) {
                recCount = recCount+1;
            }
        }
        if(recCount < allRecords.length) {
            component.set('v.selectAll', false);
        }
        else if(recCount == allRecords.length) {
            component.set('v.selectAll', true); 
        }
    },
    
    selectAllCheckbox: function(component, event, helper) {
        var selectedHeaderCheck = event.getSource().get("v.checked");
        console.log('selectedHeaderCheck'+selectedHeaderCheck);
        var selectAll = component.get('v.selectAll');
        var allRecords = component.get("v.BidLineItemListAll");
        var bidLItems = [];
        if(selectedHeaderCheck) {
            for (var i = 0; i < allRecords.length; i++) {
                var rec = allRecords[i];
                rec.isChecked = selectedHeaderCheck;
                bidLItems.push(rec);
            }
            component.set('v.isNotSelected',false);
        }
        else {
            for (var i = 0; i < allRecords.length; i++) {
                var rec = allRecords[i];
                rec.isChecked = selectedHeaderCheck;
                bidLItems.push(rec);
            }
            component.set('v.isNotSelected',true);
        }
        component.set('v.BidLineItemListAll',bidLItems);
    },
    
    getSelectedRecords: function(component, event, helper) {
        var allRecords = component.get("v.BidLineItemListAll");
        var selectedRecords = [];
        for (var i = 0; i < allRecords.length; i++) {
            if (allRecords[i].isChecked) {
                selectedRecords.push(allRecords[i]);
            }
        }
        console.log(JSON.stringify(selectedRecords));
        component.set('v.selectedBidLineItems',selectedRecords);
        helper.getCRLineItems(component,event, helper);
    },
    
    goToBidLineItemScreen: function(component, event, helper) {
        var crLIList = component.get('v.CRLineItemListAll');
        var selectedBidLIIdList = [];
        for(var i =0; i<crLIList.length; i++){
            var rec = crLIList[i];
            selectedBidLIIdList.push(rec.Id);
        }
        component.set('v.selectedBidLIIdList',selectedBidLIIdList);
        helper.deleteLineItems(component, event, helper);
        //component.set('v.BidLineItemListAll',component.get("v.BidLineItemListAll"));
        if(component.get('v.selectAll'))
            component.set('v.selectAll',false);
        component.set('v.isCRScreen',false);
        component.set('v.isBidLineItemScreen',true);
        component.set('v.isCRLineItemScreen',false);
    },
    
    Save: function(component, event, helper) {

        if (helper.requiredValidation(component, event)){
            var isPendingLineExist = component.get('v.isPendingLineExist');
                   console.log('isPendingLineExist====='+isPendingLineExist);
            if(isPendingLineExist){
              if(component.get('v.bidType') != 'Initial Order Discount for WAC Customers (No-Contract Price Offering)'){
                   console.log('NOt Initial Order Discount for WAC Customers');
                    component.set('v.enableProceedButton',false);
                    
                }
                else{
                    component.set('v.enableProceedButton',true);
                }   
            }
          
               
          /*  if(component.get('v.bidType') == 'Initial Order Discount for WAC Customers (No-Contract Price Offering)'){
                component.set('v.enableProceedButton',false);
            }*/
            component.set('v.isAllValidationSuccess',true);
            component.set('v.isSpinnerLoad',true);       
            var action = component.get("c.updateCRLineItems");
            action.setParams
            ({
                crLineItemList: component.get("v.CRLineItemListAll")
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if(state=='SUCCESS'){
                    var wrapperObj =  response.getReturnValue();
                    var crLineItemsList = wrapperObj.crLineItemsList;
                    component.set("v.CRLineItemListAll",crLineItemsList);
                    if(component.get('v.bidType') != 'Initial Order Discount for WAC Customers (No-Contract Price Offering)'){
                    component.set('v.enableProceedButton',!wrapperObj.awardedQtyCheck);
                                  }
                    else{
                                            component.set('v.enableProceedButton',true);

                    }
                    if(wrapperObj.awardedQtyCheck && component.get('v.bidType') != 'Initial Order Discount for WAC Customers (No-Contract Price Offering)'){
                                      

                         var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Error',
                        message: 'Please allocate Awarded Quantity to the Contracts of ' +wrapperObj.awardedQtyCheckProdName+'.',
                        duration:' 5000',
                        key: 'info_alt',
                        type: 'error',
                        mode: 'pester'
                    });
                    toastEvent.fire();
                                      
                    }
                    component.set('v.isSpinnerLoad',false);
                    component.set('v.isCRScreen',false);
                    component.set('v.isBidLineItemScreen',false);
                    component.set('v.isCRLineItemScreen',true);
                    component.set('v.showRewardedQuantityIcon',true);
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
        }
        else {
            component.set('v.enableProceedButton',false);
            var msg = component.get('v.errorMessage');
            console.log('msg::'+msg);
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title : 'Error',
                message: msg,
                duration:' 5000',
                key: 'info_alt',
                type: 'error',
                mode: 'pester'
            });
            toastEvent.fire();
        }
    },
    
    navigateToCRPage : function (component, event, helper) {
        console.log('inside navigateToCRPage');
        if (helper.requiredValidation(component, event)){
            console.log('inside validation DONE');
            helper.checkAwardedQuantityRecs(component,event,helper);
        }
        else {
            var msg = component.get('v.errorMessage');
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title : 'Error',
                message: msg,//'You can not Proceed the step with Bid status as Pending in Customer Response Lines',
                duration:' 5000',
                key: 'info_alt',
                type: 'error',
                mode: 'pester'
            });
            toastEvent.fire();
        }
    },
    
    redirectToCRPage : function (component, event, helper) {
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": component.get('v.crRecordId'),
            "slideDevName": "related"
        });
        window.setTimeout(
            $A.getCallback(function() {
                navEvt.fire();
            }), 2000
        ); 
    },
      redirectToBid : function (component, event, helper) {
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": component.get('v.recordId'),
           // "slideDevName": "related"
        });
        window.setTimeout(
            $A.getCallback(function() {
                navEvt.fire();
            }), 2000
        ); 
    },
    redirectToBidPage: function(component, event, helper) {
        var isFromBid = component.get('v.isFromBid');
        if(isFromBid){
            helper.deleteAttachments(component, event, helper);
        }
        window.history.back();
        return false;
    },
    
    handleEvent: function(component, event, helper) {
        component.set('v.isSpinnerLoad',true);
        var message = event.getParam("message");
        helper.getCRLItems(component, event, helper);
    },
    
    handleRecordUpdated: function(component, event, helper) {
        var eventParams = event.getParams();
        if(eventParams.changeType === "LOADED") {
            // record is loaded (render other component which needs record data value)
            console.log("Record is loaded successfully in handleRecordUpdated");
            var isLoginUserAbleToPerform = component.get('v.isLoginUserAbleToPerform')
            if(isLoginUserAbleToPerform)
                helper.getBidLineItemsFromBid(component, event, helper);
        } else if(eventParams.changeType === "CHANGED") {
            // record is changed
        } else if(eventParams.changeType === "REMOVED") {
            // record is deleted
        } else if(eventParams.changeType === "ERROR") {
            // there’s an error while loading, saving, or deleting the record
        }
    },
    handleCRRecordUpdated: function(component, event, helper) {
        var eventParams = event.getParams();
        if(eventParams.changeType === "LOADED") {
            console.log("Record is loaded successfully.");
            //helper.getCRLItems(component, event, helper);
        } else if(eventParams.changeType === "CHANGED") {
            // record is changed
        } else if(eventParams.changeType === "REMOVED") {
            // record is deleted
        } else if(eventParams.changeType === "ERROR") {
            // there’s an error while loading, saving, or deleting the record
        }
    },
    
    /* Upload documnet section */
    handleUploadFinished: function (component, event, helper) {
          //helper.handleUploadFinished(component, event);
       var uploadedFiles = event.getParam("files");
       console.log('uploadedFiles'+JSON.stringify(uploadedFiles));
       //component.set('v.fileList',uploadedFiles);
       var fieleListUpdated = [];
       fieleListUpdated = uploadedFiles;
       var fileList = component.get('v.fileList');
       //console.log('fileList'+JSON.stringify(fileList));
       //console.log('fileList'+fileList.length);
       if(fileList.length>0) {
           fieleListUpdated.push.apply(fieleListUpdated, fileList);
       }
       //console.log('fieleListUpdated'+JSON.stringify(fieleListUpdated));
       component.set('v.fileList',fieleListUpdated);
    },
    
    deleteAttachment: function (component, event, helper) {
        component.set('v.isSpinnerLoad',true);
        var LineItemIds = [];
        var selectedRec = event.getSource().get("v.name");
        console.log('selectedRec::'+selectedRec);
        LineItemIds.push(selectedRec);
        var action = component.get("c.deleteAttachmentList");
        action.setParams({
            'LineItemIds' : LineItemIds
        });
        action.setCallback(this,function(response) {
            var state = response.getState();
            if(state=='SUCCESS'){
                component.set('v.isSpinnerLoad',false);
                console.log('response::'+response.getReturnValue());
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
        component.set("v.fileList",[]);
        component.set("v.fileList", AllRowsList);
    },
    downloadCsv : function(component,event,helper){    
        
        var ResultData = component.get("v.CRLineItemListAll");
        //console.log('results--->'+JSON.stringify(ResultData));
        var template=component.get("v.templateType");
        var crName=component.get("v.bidName");
        // var bidName=component.get("v.bidName");
        // call the helper function which "return" the CSV data as a String   
        var csv = helper.convertArrayOfObjectsToCSV(component,ResultData,template);   
        if (csv == null){return;} 
        
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
        var Now=(date.getMonth()+1)+'/'+date.getDate()+'/'+date.getFullYear()+' '+hours+':'+minutes+' '+newformat;
        hiddenElement.download = 'Customer Response Lines'+'-'+Now+'.csv';  // CSV file Name* you can change it.[only name not .csv] 
        document.body.appendChild(hiddenElement); // Required for FireFox browser
        hiddenElement.click(); // using click() js function to download csv file
    },
    onBSChange: function(component,event,helper){   
        var bsValue = component.find('bsId').get('v.value');
        console.log('bsValue::'+bsValue);
        //component.set('v.bidStatusValue',bidStatusValue);
		var CRLineItemListAll = component.get('v.CRLineItemListAll');
        if(bsValue == 'Awarded' || bsValue == 'Pending') {
            component.set('v.disableCustomerDecPicklistOpts',true);
            component.find('cdrId').set('v.value','');
            for (var i = 0; i < CRLineItemListAll.length; i++) {
            	CRLineItemListAll[i].Phoenix_Customer_Decline_Reasons__c = '';
        	}
            if(bsValue == 'Awarded' || bsValue=='Pending') {
                for (var i = 0; i < CRLineItemListAll.length; i++) {
                    if(CRLineItemListAll[i].Phoenix_Customer_Response_Date__c!=null && CRLineItemListAll[i].Phoenix_Lead_Time_Days__c!=null){
                        var customerDate=new Date(CRLineItemListAll[i].Phoenix_Customer_Response_Date__c);
                        customerDate.setDate(customerDate.getDate() + parseInt(CRLineItemListAll[i].Phoenix_Lead_Time_Days__c));
                        var dd = customerDate.getDate();            
                        var mm = customerDate.getMonth()+1; 
                        var yyyy = customerDate.getFullYear();
                        if(dd<10){dd='0'+dd;} 
                        if(mm<10){mm='0'+mm;} 
                        customerDate = yyyy+'-'+mm+'-'+dd;                
                        CRLineItemListAll[i].Phoenix_Supply_Effective_Date__c=customerDate;  
                    }                  
            		CRLineItemListAll[i].Phoenix_Awarded_Quantity__c = CRLineItemListAll[i].Phoenix_Final_Total_Selling_Unit__c;
        		}
            }
            else{
                for (var i = 0; i < CRLineItemListAll.length; i++) {
            		CRLineItemListAll[i].Phoenix_Awarded_Quantity__c = null;
        		}
            }
            component.set('v.showErrorClassBS', false);
            component.set('v.showErrorClassCDR', false);
            component.set('v.showErrorClassAP', true);
            component.set('v.showErrorClassAQ', true);
            console.log('type--'+component.get("v.bidType"));
            if(component.get("v.bidType")!='Price Change' && component.get("v.bidType")!='Sales Out Rebate' && component.get("v.bidType")!='Customer Rebate Change'){
                component.set('v.showErrorClassSED', true);
                console.log('ented');
            }
            if(component.get("v.bidType")!='Volume Review Only'){	
                component.set('v.showErrorClassPED', true);	
            }
        }
        else if(bsValue == '' || bsValue == '--- None ---') {
            for (var i = 0; i < CRLineItemListAll.length; i++) {
                CRLineItemListAll[i].Phoenix_Awarded_Quantity__c = null;
            }
            component.set('v.showErrorClassBS', true);
            component.set('v.showErrorClassCDR', false);
            component.set('v.showErrorClassAP', false);
            component.set('v.showErrorClassAQ', false);
            component.set('v.showErrorClassSED', false);
            component.set('v.showErrorClassPED', false);
        }
        else{
            component.set('v.disableCustomerDecPicklistOpts',false);
            component.set('v.showErrorClassBS', false);
            component.set('v.showErrorClassCDR', true);
            for (var i = 0; i < CRLineItemListAll.length; i++) {
            	CRLineItemListAll[i].Phoenix_Awarded_Quantity__c = null;
                CRLineItemListAll[i].Phoenix_Award_Position__c = null;
                CRLineItemListAll[i].Phoenix_Supply_Effective_Date__c = null;
                CRLineItemListAll[i].Phoenix_Supply_Effective_Date__c = null;
        	}
            component.set('v.showErrorClassAP', false);
            component.set('v.showErrorClassAQ', false);
            component.set('v.showErrorClassSED', false);
            component.set('v.showErrorClassPED', false);
        }
        for (var i = 0; i < CRLineItemListAll.length; i++) {
            CRLineItemListAll[i].Phoenix_Bid_Status__c = bsValue;
        }
        component.set('v.CRLineItemListAll',CRLineItemListAll);
        helper.onAction(component,event,helper);
    },
    onCDRChange: function(component,event,helper){   
        var cdrValue = component.find('cdrId').get('v.value');
        console.log('cdrValue::'+cdrValue);
        var CRLineItemListAll = component.get('v.CRLineItemListAll');
        for (var i = 0; i < CRLineItemListAll.length; i++) {
            CRLineItemListAll[i].Phoenix_Customer_Decline_Reasons__c = cdrValue;
        }
        component.set('v.CRLineItemListAll',CRLineItemListAll);
    },
     /*Product Position Logic*/
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
        var bidCustomer = component.get('v.bidCustomerId');
        console.log('--bidCustomer--' + bidCustomer);
        if (bidCustomer != null && bidCustomer != undefined) {
            helper.fetchPositions(component, event, helper, bidCustomer);
        } else {
            component.set("v.positionsList", null);
        }
    },
    showMCKProductPositionModel: function (component, event, helper) {
        var LineItemtable = component.find("LineTable");
        console.log('modalstart---' + LineItemtable);
        $A.util.removeClass(LineItemtable, "maintable");
        component.set("v.showMCKPositionsModal", true);
        component.set('v.MCKpositionColumns', [{
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
        var bidCustomer = component.get("v.bidCustomerId");
        console.log('--bidCustomer--' + bidCustomer);
        if (bidCustomer != null && bidCustomer != undefined) {
            helper.fetchMCKPositions(component, event, helper, bidCustomer);
        } else {
            component.set("v.MCKpositionsList", null);
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
        var positions = component.get("v.selectedPosistions").toString();
        console.log('positions::'+positions);
        var CRLineItemListAll = component.get('v.CRLineItemListAll');
        for (var i = 0; i < CRLineItemListAll.length; i++) {
            CRLineItemListAll[i].Phoenix_Award_Position__c = positions;
        }
        component.set('v.CRLineItemListAll',CRLineItemListAll);
        var LineItemtable = component.find("LineTable");
        $A.util.addClass(LineItemtable, "maintable");
        component.set("v.showSaveCancelBtn", true);
        //helper.getNPRDataOfContracts(component, event, helper,selectrcs);
    },
    saveMCKPosDetails: function (component, event, helper) {
        var selectrcs = component.find('PoslinesMCKTable').getSelectedRows();
        var selectedCntrcts = component.get("v.selectedMCKPosistions");
        for (var i = 0; i < selectrcs.length; i++) {
            selectedCntrcts.push(selectrcs[i].Name);
        }
        component.set("v.selectedMCKPosistions", selectedCntrcts);
        component.set("v.showMCKPositionsModal", false);
        var positions = component.get("v.selectedMCKPosistions").toString();
        console.log('positions::'+positions);
        var CRLineItemListAll = component.get('v.CRLineItemListAll');
        for (var i = 0; i < CRLineItemListAll.length; i++) {
            CRLineItemListAll[i].Phoenix_Mck_Proposed_Position__c = positions;
        }
        component.set('v.CRLineItemListAll',CRLineItemListAll);
        
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
         var positions = component.get("v.selectedPosistions").toString();
         console.log('positions::'+positions);
         var CRLineItemListAll = component.get('v.CRLineItemListAll');
         for (var i = 0; i < CRLineItemListAll.length; i++) {
             CRLineItemListAll[i].Phoenix_Award_Position__c = positions;
         }
         component.set('v.CRLineItemListAll',CRLineItemListAll);
       // component.set("v.showSaveCancelBtn", true);
    },
    clearMCKPosition: function (component, event, heplper) {
        var selectedPillId = event.getSource().get("v.name");
        var AllPillsList = component.get("v.selectedMCKPosistions");

        for (var i = 0; i < AllPillsList.length; i++) {
            if (AllPillsList[i] == selectedPillId) {
                AllPillsList.splice(i, 1);
                component.set("v.selectedMCKPosistions", AllPillsList);
            }
        }
        var positions = component.get("v.selectedPosistions").toString();
         console.log('positions::'+positions);
         var CRLineItemListAll = component.get('v.CRLineItemListAll');
         for (var i = 0; i < CRLineItemListAll.length; i++) {
             CRLineItemListAll[i].Phoenix_Award_Position__c = positions;
         }
         component.set('v.CRLineItemListAll',CRLineItemListAll);
        component.set("v.showSaveCancelBtn", true);
    },
    hideModel : function (component, event, heplper) {
         component.set("v.showPositionsModal", false);
        component.set("v.showMCKPositionsModal", false);
        var LineItemtable = component.find("LineTable");
        $A.util.addClass(LineItemtable, "maintable");
    },
    handleComponentEvent: function (component, event, heplper) {
        console.log('handleComponentEvent')
    	var valueFromChild = event.getParam("enableProceedButton");
            	var awardedQtyValue = event.getParam("changedAwardedQty");
        console.log('awardedQtyValue-->'+awardedQtyValue)
        component.set("v.enableProceedButton",valueFromChild);
         component.set("v.changedAwardedQty",awardedQtyValue);
    },
    backToCustResponse: function (component, event, heplper) {
        component.set('v.isCRScreen',true);
        component.set('v.isBidLineItemScreen',false);
        component.set('v.isCRLineItemScreen',false);
        component.set("v.isBackCalled",true);
        
        
    },
      onPriceEffDateChange: function(component,event,helper){   
       
        var priceEffValue = component.get("v.priceEffDate");
         var CRLineItemListAll = component.get('v.CRLineItemListAll');
        for (var i = 0; i < CRLineItemListAll.length; i++) {
            CRLineItemListAll[i].Phoenix_Price_Effective_Date__c = priceEffValue;
        }
              component.set('v.CRLineItemListAll',CRLineItemListAll);

    },  
     onSupplyEffDateChange: function(component,event,helper){   
       
        var supplyEffValue = component.get("v.supplyEffDate");
         var CRLineItemListAll = component.get('v.CRLineItemListAll');
        for (var i = 0; i < CRLineItemListAll.length; i++) {
            CRLineItemListAll[i].Phoenix_Supply_Effective_Date__c = supplyEffValue;
        }
              component.set('v.CRLineItemListAll',CRLineItemListAll);

    }, 
 /*Product Position Logic*/
})