({
    handleUploadFinished: function (component, event, helper) {
        var uploadedFiles = event.getParam("files");//event.getSource().get("v.files");//
        console.log('uploadedFiles' + JSON.stringify(uploadedFiles));
        var fieleListUpdated = [];
        fieleListUpdated = uploadedFiles;
        var fileList = component.get('v.fileList');
        console.log('fileList' + fileList.length);
        if (fileList.length > 0) {
            fieleListUpdated.push.apply(fieleListUpdated, fileList);
        }
        component.set('v.fileList', fieleListUpdated);
        component.set('v.isFileUploaded', true);
        component.set('v.isShowUploadedProducts', true);
        console.log('File Name ' + uploadedFiles[0]['name']);
        component.set("v.fileName", uploadedFiles[0]['name']);
        console.log('Content Id ' + uploadedFiles[0]['contentVersionId']);
        component.set('v.fileContentId', uploadedFiles[0]['contentVersionId']);
        //helper.showProducts(component, event, helper);
        helper.showUploadedProducts(component, event, helper);
        
    },
    inlineEditProdLookUp : function(component, event, helper){
        var target = event.target;
        var rowIndex = target.getAttribute("data-row-index");
        console.log('selected index var :: '+rowIndex);
        component.set("v.selecteRow",rowIndex);
        component.set("v.inlineProdLookUpEditMode",true);
    },
    handleBlur : function(component, event, helper){
        component.set("v.inlineProdLookUpEditMode",false);
        component.set("v.selecteRow",'None');
    },
    handleOnload: function (component, event, helper) {
        if(!component.get("v.isFromAnalysis")){
            var deadlinedate;
            var recUi = event.getParam("recordUi");
            component.set('v.oppStageNameVal', 'Opportunity in progress');
            if (recUi.record.fields["Phoenix_Bid_Deadline_Date__c"] != undefined) {
                deadlinedate = recUi.record.fields["Phoenix_Bid_Deadline_Date__c"].value;
            }
            if (recUi.record.fields["AccountId"] != undefined) {
                console.log('recUi.record.fields["AccountId"].value :---> '+recUi.record.fields["AccountId"].value);
                component.set("v.customerLkp",recUi.record.fields["AccountId"].value);
            }
            if (recUi.record.fields["Contact__c"] != undefined) {
                console.log('recUi.record.fields["Contact__c"].value :---> '+recUi.record.fields["Contact__c"].value);
                component.set("v.cntcLkp",recUi.record.fields["Contact__c"].value);
            }
            if (recUi.record.fields["Vision_Internal_Closing_Date__c"] != undefined) {
                component.set("v.internalTargetDate",recUi.record.fields["Vision_Internal_Closing_Date__c"].value);
            }
            if (recUi.record.fields["Vision_Customer_Closing_Date__c"] != undefined) {
                component.set("v.customerDeadlineDate",recUi.record.fields["Vision_Customer_Closing_Date__c"].value);
            }
        }
    },
    handleChangeInSource : function(component,event,helper){
        var selectedStatus = component.find("optySourceInput").get("v.value");
        console.log('selectedStatus --> '+selectedStatus);
        component.set("v.source",selectedStatus);
    },
    
    handleChangeInBidTemplate : function(component,event,helper){
        var selectedBidTemplate = component.find("bidTemplate").get("v.value");
        console.log('bidTemplate --> '+selectedBidTemplate);
        component.set("v.AccTemplate",selectedBidTemplate);
        if(selectedBidTemplate == 'Humana Indirect retail' || selectedBidTemplate == 'Humana Indirect CII'){
            component.set("v.isShowInDirectUnits",true);
        }
          if(component.get("v.AccTemplate") == 'Direct' && component.get("v.AccountNumber")=='164498'){
                            component.set("v.templateName", 'Download Pharmabid Direct Template');
                        }
                        else if( component.get("v.AccTemplate") == 'Indirect' && component.get("v.AccountNumber")=='164498'){
                            component.set("v.templateName", 'Download Pharmabid Indirect Template');
                        }
                            else{
                                   component.set("v.templateName",'Download '+selectedBidTemplate+' Template');
     
                            }
    },
    
    handleChange: function (component, event, helper) {
        if(component.get("v.customerLkp")){
            component.set('v.isSpinnerLoad', true);
            component.set("v.AccTemplate",'');
            component.set("v.templateName",'');
            component.set("v.loadingMessage",'');
            component.set("v.isShowDirectUnits",false);
            component.set("v.isShowInDirectUnits",false);
            component.set('v.isAccSel', true);
            var action2 = component.get("c.getAccRec");
            action2.setParams({
                "accId": component.get("v.customerLkp")
            });
            action2.setCallback(this, function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var respObj = response.getReturnValue();
                    component.set("v.accObj",respObj);
                    component.set("v.AccountNumber",respObj.AccountNumber);
                    console.log('AccTemplate====='+component.get("v.AccTemplate"));
                    if(respObj.Name.includes('OTC Private Label')){
                        component.set("v.AccTemplate",'OTC Customer');
                        component.set("v.templateName", 'Download OTC Template');
                    }
                    else{
                        var templateName = respObj.Phoenix_Customer_Class_Bid_Template__c;
                        component.set("v.actualTemplate",templateName);
                        if(templateName == 'Direct or Indirect'){
                            component.set("v.AccTemplate",'Direct');
                            component.set("v.templateName", 'Download Direct Template');
                        }
                        else if(templateName == 'Direct or Indirect'){
                            component.set("v.AccTemplate",'ROS');
                            component.set("v.templateName", 'Download ROS Template');
                        }
                            else if(templateName == 'ABC Progen' || templateName == 'ABC Pharmagen'){
                                component.set("v.AccTemplate",'ABC Progen');
                                component.set("v.templateName", 'Download ABC Progen Template');
                            }
                                else if(templateName == 'Humana'){
                                    component.set("v.AccTemplate",'Direct');
                                    component.set("v.templateName", 'Download Humana Template');
                                }
                                    else{
                                        component.set("v.AccTemplate",templateName);
                                        component.set("v.templateName", 'Download '+templateName+' Template');
                                    }
                        if(templateName == 'Direct or Indirect' && component.get("v.AccTemplate") == 'Direct' && respObj.AccountNumber=='164498'){
                            component.set("v.templateName", 'Download Pharmabid Direct Template');
                             component.set("v.isShowDirectUnits",true);
                        }
                        else if(templateName == 'Direct or Indirect' && component.get("v.AccTemplate") == 'Indirect' && respObj.AccountNumber=='164498'){
                            component.set("v.templateName", 'Download Pharmabid Indirect Template');
                              component.set("v.isShowInDirectUnits",true);
                        }
                        if(templateName == 'Direct' || templateName == 'Direct and Indirect' || templateName == 'Econdisc' || templateName == 'Net Indirect Pricing')
                            component.set("v.isShowDirectUnits",true);
                        if(templateName == 'Indirect' || templateName == 'Direct and Indirect' || templateName == 'Econdisc' || templateName == 'Net Indirect Pricing' 
                           || templateName == 'Walgreens' || templateName == 'ABC Progen' || templateName == 'Costco' || templateName == 'Sams Club' || templateName == 'Government Pricing')
                            component.set("v.isShowInDirectUnits",true);
                    }
                    helper.validateInputsHelper(component, event, helper);
                    //component.set("v.hideUploadButton",false);
                    component.set('v.isSpinnerLoad', false);
                }
                else {
                    component.set('v.isSpinnerLoad', false);
                    console.log("failed " + JSON.stringify(response.getError()));
                }
            });
            $A.enqueueAction(action2);
        }
        else
            helper.validateInputsHelper(component, event, helper);//component.set("v.hideUploadButton",true);
    },
    
    pageReferenceChangeHandler: function (component, event, helper) {
        let pageReference = component.get("v.pageReference");
        let recordId = pageReference.state.c__recordId != undefined ? pageReference.state.c__recordId : component.get("v.recordId");
        if (recordId != null && recordId != undefined && recordId != '') {
            helper.loadInstance(component, helper);
        } else {
            component.set("v.recordId", null);
            component.set("v.isCreate", true);
            $A.get('e.force:refreshView').fire();
        }
        
    },
    doInit: function (component, event, helper) {
        component.set('v.fileList', []);
        helper.loadInstance(component, helper);
        helper.getRecordTypeIds(component, event, helper);
        
    },
    closeQuickActionPanel: function (component, event, helper) {
        // console.log("---BidEdit---returnToRecord()-------"+component.get("v.recordId"));
        try {
            //$A.get('e.force:refreshView').fire();
            let recordId = component.get("v.recordId");
            if (recordId != null) {
                // Go to record
                component.find("navigationService").navigate({
                    type: "standard__recordPage",
                    attributes: {
                        recordId: recordId,
                        actionName: "view"
                    }
                }, false); // replace
            }
            else {
                // Go to Initiative Home
                component.find("navigationService").navigate({
                    type: "standard__objectPage",
                    attributes: {
                        objectApiName: "Opportunity",
                        actionName: "home"
                    }
                }, false); // replace
            }
        } catch (ex) {
            console.log(ex);
        }
        
    },
    onChangeInternalTargetDate : function(component, event, helper){
        var intTargetDate = component.find("internalTargetDate").get("v.value");
        component.set("v.internalTargetDate",intTargetDate);
        //let nxtInput = component.find("cxDeadLine");
        //nxtInput.focus();
        helper.validateInputsHelper(component, event, helper);
    },
    onChangecxDeadLineDate : function(component, event, helper){
        var cxDeadLineDate = component.find("cxDeadLine").get("v.value");
        component.set("v.customerDeadlineDate",cxDeadLineDate);
        helper.validateInputsHelper(component, event, helper);
    },
    redirectToDetailPage: function (component, event, helper) {
        
        var record = event.getParam("response");
        var apiName = record.apiName;
        var myRecordId = record.id;
        component.set("v.recordId1", myRecordId);
        helper.handleUploadFinished(component, event,myRecordId);
        
        var message;
        if (component.get("v.recordId") == null || component.get("v.recordId") == '' || component.get("v.recordId") == undefined) {
            message = 'created';
            
        } else {
            message = 'updated';
        }
        try {
            if (message == 'updated') {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": "success",
                    "title": "Success!",
                    "message": "The record has been " + message + " successfully."
                });
                toastEvent.fire();
                if (component.get("v.buttonName") == 'Save and Close') {
                    component.find("navigationService").navigate({
                        type: "standard__recordPage",
                        attributes: {
                            recordId: component.get("v.recordId"),
                            actionName: "view"
                        }
                    }, false);
                }
                // replace
                $A.get('e.force:refreshView').fire();
                
            }
            else {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": "success",
                    "title": "Success!",
                    "message": "The record has been " + message + " successfully."
                });
                toastEvent.fire();
                if (component.get("v.buttonName") == 'Save and Close') {
                    component.find("navigationService").navigate({
                        type: "standard__recordPage",
                        attributes: {
                            recordId: myRecordId,
                            actionName: "view"
                        }
                    }, false);
                }
                $A.get('e.force:refreshView').fire();
                
            }
        }
        catch (ex) {
            console.log('exception' + ex);
        }
        helper.saveOptyLineItems(component, event, myRecordId);
    },
    
    handleSubmit: function (component, event, helper) {
        console.log('Handle Submit Called');
        helper.handleFormSubmit(component, event, helper);
    },
    downloadCSVFile: function (component, event, helper) {
        let rowEnd = '\n';
        let csvString = '';
        let rowData = new Set();
        var accTemp = component.get("v.AccTemplate");
        var accObj = component.get("v.accObj");
        console.log('accTemp ---> '+accTemp);
        let cols = [];
        var tempName = 'Products Template';
        /*if(accObj.Phoenix_Is_OTC_Customer__c){
            cols = ['GCN', 'GSN', 'GPI', 'NDC 11', 'SKU NUMBER', 'PRODUCT FAMILY', 'STRENGTH', 'DOSAGE FORM', 'PACK SIZE', 'PRODUCT DESCRIPTION', 
                    'PROPOSED TOTAL UNITS', 'PROPOSED SHARE PERCENTAGE', 'GUIDANCE PRICE', 'UOM', 'CUSTOMER COMMENTS', 
                    'BID ON HIGHEST PACK SIZE', 'BID ON ALTERNATIVE PACK SIZE'];
            tempName = 'OTC Template';
        }
        else */
        
        if(accTemp == "ClarusOne"){
            cols = ['GCN', 'GSN', 'GPI', 'NDC 11', 'SKU NUMBER', 'PRODUCT FAMILY', 'STRENGTH', 'DOSAGE FORM', 'PACK SIZE', 'PRODUCT DESCRIPTION', 
                    'PROPOSED OS UNITS', 'PROPOSED RAD UNITS', 'PROPOSED WMT UNITS', 'GUIDANCE PRICE', 'UOM', 'CUSTOMER COMMENTS']; 
                    //'BID ON HIGHEST PACK SIZE', 'BID ON ALTERNATIVE PACK SIZE'];'TOTAL ANNUAL UNITS', 
            tempName = accTemp+' Template';
        }
        else{
            cols = ['GCN', 'GSN', 'GPI', 'NDC 11', 'SKU NUMBER', 'PRODUCT FAMILY', 'STRENGTH', 'DOSAGE FORM', 'PACK SIZE', 'PRODUCT DESCRIPTION'];//, 'GUIDANCE PRICE', 'UOM', 'CUSTOMER COMMENTS', 'BID ON HIGHEST PACK SIZE', 'BID ON ALTERNATIVE PACK SIZE'];
            if(accTemp == 'Direct' || accTemp == 'Direct and Indirect' || accTemp == 'Net Indirect Pricing'){
                cols.push('PROPOSED DIRECT UNITS');
                tempName = accTemp+' Template';
            }
            if(accTemp == 'Indirect' || accTemp == 'Direct and Indirect' || accTemp == 'Net Indirect Pricing' || accTemp == 'ABC Pharmagen' 
               || accTemp == 'Walgreens' || accTemp == 'ABC Progen' || accTemp == 'Costco' || accTemp == 'Sams Club' || accTemp == 'Government Pricing'
               || accTemp == 'Humana Indirect retail' || accTemp == 'Humana Indirect CII' ){
                cols.push('PROPOSED INDIRECT UNITS');
                tempName = accTemp+' Template';
            }
            if(accTemp == 'RXSS'){
                console.log('inside RXSS');
                let rxssItems = ['PROPOSED SMITH DRUG UNITS', 'PROPOSED ANDA UNITS', 'PROPOSED DIRECT AHOLD/DELHAIZE UNITS', 'PROPOSED DIRECT GAINT EAGLE UNITS', 
                                 'PROPOSED TOTAL RETAIL INDIRECT UNITS', 'OTHER DIRECT UNITS', 'OTHER INDIRECT UNITS'];
                rxssItems.forEach(function(itm){
                    cols.push(itm);
                });
                tempName = 'RXSS Template';
                //cols.concat(Array.from(rxssItems));
            }
            if(accTemp == 'BASE/DSH'){
                let dshItems = ['PROPOSED BASE UNITS', 'PROPOSED DSH UNITS', 'PROPOSED AUTOSUB UNITS'];
                dshItems.forEach(function(itm){
                    cols.push(itm);
                });
                tempName = 'BASE/DSH Template';
            }
            if(accTemp == 'Econdisc'){
                let econItems = ['PROPOSED DIRECT ESI UNITS', 'PROPOSED INDIRECT ESI UNITS', 'PROPOSED DIRECT KROGER UNITS', 'PROPOSED INDIRECT KROGER UNITS', 
                                 'PROPOSED DIRECT RX OUTREACH UNITS', 'PROPOSED INDIRECT RX OUTREACH UNITS', 'PROPOSED DIRECT SUPERVALU UNITS', 
                                 'PROPOSED INDIRECT SUPERVALU UNITS', 'PROPOSED DIRECT CIGNA UNITS', 'PROPOSED INDIRECT CIGNA UNITS', 'PROPOSED DIRECT CORDANT UNITS', 
                                 'PROPOSED INDIRECT CORDANT UNITS', 'PROPOSED DIRECT ACCERODO UNITS', 'PROPOSED INDIRECT ACCERODO UNITS', 'OTHER DIRECT UNITS', 
                                 'OTHER INDIRECT UNITS'];
                econItems.forEach(function(itm){
                    cols.push(itm);
                });
                tempName = 'Econdisc Template';
            }
            if(accTemp == 'ROS'){
                let dshItems = ['PROPOSED CVS DIRECT UNITS', 'PROPOSED CVS INDIRECT UNITS', 'PROPOSED CARDINAL UNITS', 'PROPOSED MAJOR UNITS'];
                dshItems.forEach(function(itm){
                    cols.push(itm);
                });
                tempName = 'ROS Template';
            }
            if(accTemp == 'OTC Customer'){
                let otcItems = ['PROPOSED SELLING UNITS', 'PROPOSED SHARE PERCENTAGE'];
                otcItems.forEach(function(itm){
                    cols.push(itm);
                });
                tempName = 'OTC Template';
            }
            if(accTemp == 'Direct' && component.get("v.AccountNumber") == '164498'){
                cols = ['NDC 11', 'SKU NUMBER', 'PRODUCT FAMILY', 'PRODUCT DESCRIPTION','PACK SIZE', 'STRENGTH', 'DOSAGE FORM','CASE PACK','MINIMUM ORDER QUANTITY','BATCH NUMBER','EXPIRY DATE','PROPOSED DIRECT UNITS','FLOOR PRICE','LISTING PRICE'];//, 'GUIDANCE PRICE', 'UOM', 'CUSTOMER COMMENTS', 'BID ON HIGHEST PACK SIZE', 'BID ON ALTERNATIVE PACK SIZE'];
               // cols.push('PROPOSED DIRECT UNITS');
                tempName = "Pharmabid Direct Template";
            }
            if(accTemp == 'Indirect' && component.get("v.AccountNumber") == '164498'){
                cols = ['NDC 11', 'SKU NUMBER', 'PRODUCT FAMILY', 'PRODUCT DESCRIPTION','PACK SIZE', 'STRENGTH', 'DOSAGE FORM','CASE PACK','MINIMUM ORDER QUANTITY','BATCH NUMBER','EXPIRY DATE','PROPOSED INDIRECT UNITS','FLOOR PRICE','LISTING PRICE'];//, 'GUIDANCE PRICE', 'UOM', 'CUSTOMER COMMENTS', 'BID ON HIGHEST PACK SIZE', 'BID ON ALTERNATIVE PACK SIZE'];
               // cols.push('PROPOSED INDIRECT UNITS');
                tempName = "Pharmabid Indirect Template";
            }
            //if(accTemp != 'Econdisc' && accTemp != 'RXSS')
            //    cols.push('TOTAL ANNUAL UNITS');
            let remainingItems = [];
            if(component.get("v.AccountNumber") == '164498'){
                remainingItems = ['GUIDANCE PRICE', 'CUSTOMER EXCLUSION'];//, 'BID ON HIGHEST PACK SIZE', 'BID ON ALTERNATIVE PACK SIZE'];   
            }
            else{
                remainingItems = ['GUIDANCE PRICE', 'UOM', 'CUSTOMER COMMENTS'];//, 'BID ON HIGHEST PACK SIZE', 'BID ON ALTERNATIVE PACK SIZE'];   
            }
            remainingItems.forEach(function(itm){
                if(component.get("v.AccountNumber") != '164498'){
                    cols.push(itm);
                }
                else{
                    if(itm == 'GUIDANCE PRICE'){
                        cols.push('FLOOR PRICE');
                    }
                    else{
                       cols.push(itm); 
                    }
                     
                }
               
            });
            console.log('--cols--'+JSON.stringify(cols));
        }
        cols.forEach(function(element){
            rowData.add(element);
        });
        
        rowData = Array.from(rowData);
        csvString += rowData.join(',');
        csvString += rowEnd;
        
        let downloadElement = document.createElement('a');
        downloadElement.href = 'data:text/csv;charset=utf-8,' + encodeURI(csvString);
        downloadElement.target = '_self';
        downloadElement.download = tempName + '.csv';
        document.body.appendChild(downloadElement);
        downloadElement.click();
    },
    // handleFilesChange: function (component, event, helper) {
    //     component.set('v.isFileUploaded', true);
    //     var fileName = 'No File Selected..';
    //     if (event.getSource().get("v.files").length > 0) {
    //         fileName = event.getSource().get("v.files")[0]['name'];
    //     }
    //     component.set("v.fileName", fileName);
    //     //component.set('v.fileName',fileName);
    //     component.set('v.fileContentId', uploadedFiles[0]["contentVersionId"]);
    // },
    
    onSaveRecord: function (component, event, helper) {
        component.set('v.buttonName', 'Save and Close');
    },
    validateInputs : function(component, event, helper){
        helper.validateInputsHelper(component, event, helper);
    },
    onSaveNext: function (component, event, helper) {
        component.set('v.buttonName', 'Save and Add Products');
        console.log('Add Products');
        console.log('component.get("v.customerLkp") --> '+component.get("v.customerLkp"));
        console.log('component.get("v.cntcLkp") --> '+component.get("v.cntcLkp"));
        console.log('component.get("v.name") --> '+component.get("v.name"));
        console.log('component.get("v.source") --> '+component.get("v.source"));
        //console.log('component.get("v.bidTypeFromForm") --> '+component.get("v.bidTypeFromForm"));
        console.log('component.get("v.internalTargetDate") --> '+component.get("v.internalTargetDate"));
        var inputField = component.find('optyName');
        var validityObj = inputField.get("v.validity");
        if(component.get("v.customerLkp") && component.get("v.name")
           && component.get("v.source") //&& component.get("v.bidTypeFromForm")
           && component.get("v.internalTargetDate") && validityObj.valid){
            //helper.validateOptyName(component, event, helper);
            var obj = {};
            obj.Name = component.get("v.name");
            obj.Vision_Opportunity_Source__c = component.get("v.source");
            obj.Vision_Type__c = component.get("v.type");
            obj.StageName = component.get("v.stage");
            obj.AccountId = component.get("v.customerLkp");
            obj.Contact__c = component.get("v.cntcLkp");
           // obj.AccountNumber= component.get("v.AccountNumber");
            if(component.get("v.AccountNumber") == '164498'){
                obj.Bid_Type__c = 'Pharmabid';//component.get("v.bidTypeFromForm");
            }
            else{
              obj.Bid_Type__c = 'Product Addition';//component.get("v.bidTypeFromForm");  
            }
            obj.Vision_Internal_Closing_Date__c = component.get("v.internalTargetDate");
            obj.Vision_Customer_Closing_Date__c = component.get("v.customerDeadlineDate");
            obj.Vision_Comments__c = component.get("v.comments");
            obj.Vision_Notes__c = component.get("v.notes");
            obj.Vision_Bid_Template__c = component.get("v.AccTemplate");
            component.set("v.optyObj", obj);
            var evt = $A.get("e.force:navigateToComponent");
            evt.setParams({
                componentDef: "c:Vision_AddOpportunityLines",
                componentAttributes: {
                    showContracts: false,
                    optyObj: obj
                }
            });
            evt.fire();
        }
        else{
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type": "Error",
                "title": "Error!",
                "message": "Please enter all the required field(s)."
            });
            toastEvent.fire();
        }
    },
    
    onEnterCheck : function(component, event, helper){
        var inputField = component.find('optyName');
        var validityObj = inputField.get("v.validity");
        
        console.log('validityObj.valid  :: --> ' +validityObj.valid);
        if (event.which == 13 || event.which == 9){
            console.log('inside enter validation');
            let nxtInput = component.find("optySource");
            nxtInput.focus();
        }  
    },
    
    moveToCustomer : function(component, event, helper){
        //let nxtInput = component.find("customerLookup");
        //nxtInput.focus();
    },
    moveToContact : function(component, event, helper){
        //let nxtInput = component.find("contactLookup");
        //nxtInput.focus();
    },
    moveToBidType : function(component, event, helper){
        let nxtInput = component.find("bidType");
        nxtInput.focus();
    }, 
    moveToTargetDate : function(component, event, helper){
        console.log('inside moveToTargetDate');
        let nxtInput = component.find("internalTargetDate");
        nxtInput.focus();
    }, 
    validateOptyName: function (component, event, helper) {
        console.log('Opty Name :: '+component.get("v.name"));
        //if (event.which == 13 || event.which == 9){
        var action = component.get("c.validateOptyNameCtrl");
        action.setParams({
            "Name": component.get("v.name")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                //console.log('Success Resp ', response.getReturnValue());
                var validOpResp = JSON.parse(response.getReturnValue());
                if(validOpResp){
                    var inputField = component.find('optyName');
                    inputField.set('v.validity', {valid:true, badInput :false});
                    inputField.setCustomValidity(''); 
                    inputField.showHelpMessageIfInvalid();
                    console.log(component.get("v.name") + ' is a valid Opportunity Name');
                    
                }
                else{
                    var inputField = component.find('optyName');
                    inputField.set('v.validity', {valid:false, badInput :true});
                    inputField.setCustomValidity('Opportunity Name Already Exist!'); 
                    inputField.showHelpMessageIfInvalid();
                    /*var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "type": "Error",
                            "title": "Error!",
                            "message": component.get("v.name") + " : opportunity name already exists."
                        });
                        toastEvent.fire();*/
                }
            }
            else {
                console.log("failed " + response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
        //}
    },
    // updateMatchedRowsSelectedText: function (cmp, event) {
    //     var selectedRows = event.getParam('selectedRows');
    //     cmp.set('v.selectedMatchRowsCount', selectedRows.length);
    //     cmp.set('v.selectedMatchedRowsList', selectedRows);
    //     console.log('?? selectedRows ?? ' + JSON.stringify(selectedRows));
    
    // },
    // updateUnmatchedSelectedText: function (cmp, event) {
    //     var selectedRows = event.getParam('selectedRows');
    //     cmp.set('v.selectedUnmatchedRowsCount', selectedRows.length);
    //     cmp.set('v.selectedUnmatchedRowsList', selectedRows);
    //     console.log('<< selectedRows >> ' + JSON.stringify(selectedRows));
    
    // },
    // moveRecToMatchList: function (component, event, helper) {
    //     console.log('Moving the records ...');
    //     helper.mapUnMatchRecords(component, event);
    // },
    saveChangeRecords: function (component, event, helper) {
        var unMatchRecs = component.get("v.unmatchdata");
        var callmapunMatchMethod = false;
        unMatchRecs.forEach(function (record){
            if (record != null && 'Product__c' in record){
                if(record['Product__c'] != null && record['Product__c'] != undefined && record['Product__c'] != ''){
                    callmapunMatchMethod = true;
                }
            }
        });
        if(callmapunMatchMethod){
            helper.mapUnMatchRecords(component, event);
        }
        // var draftValues = event.getParam('draftValues');
        // helper.saveChangeData(cmp, draftValues);
    },
    closePopUpModal: function (cmp, event, helper) {
        cmp.set('v.isShowUploadedProducts', false);
        cmp.set('v.isShowProducts', false);
        cmp.set('v.showSelectedProdOpty', false);
        cmp.set("v.showContracts",false);
        cmp.set('v.isSaveUploadProducts', true);
    },
    scriptsLoaded : function(component,event,helper){
        console.log('scripts loaded');
    },
    onSaveOptyRecord: function (component, event, helper) {
        component.set('v.isSpinnerLoad', true);
        component.set("v.loadingMessage",'Saving The Uploaded Data...');
        console.log('on Save Opty Called');
        console.log('is Record Exists : '+component.get('v.recordId'));
        if(component.get('v.recordId') != null && component.get('v.recordId') != undefined){
            console.log(component.get('v.recordId') + ' Record Already Exists');
            if(component.get('v.recordId')) {
                console.log('Record saved Successfully');
                //component.set("v.recordId", optyId);
                helper.redirectToDetailPage(component, event, helper, component.get('v.recordId'));
            }
            else{
                console.log("failed " + JSON.stringify(response.getError()));
            } 
        }
        else{
            if(component.get("v.customerLkp") && component.get("v.name")
               && component.get("v.source") //&& component.get("v.bidTypeFromForm")
               && component.get("v.internalTargetDate")){
                console.log('Record Does not exist Creating new');
                var obj = {};
                obj.Name = component.get("v.name");
                obj.Vision_Opportunity_Source__c = component.get("v.source");
                obj.Vision_Type__c = component.get("v.type");
                obj.StageName = "Opportunity in progress";
                obj.AccountId = component.get("v.customerLkp");
                obj.Contact__c = component.get("v.cntcLkp");
                obj.Bid_Type__c = 'RFP';//component.get("v.bidTypeFromForm");
                obj.Vision_Internal_Closing_Date__c = component.get("v.internalTargetDate");
                obj.Vision_Customer_Closing_Date__c = component.get("v.customerDeadlineDate");
                obj.Vision_Comments__c = component.get("v.comments");
                obj.Vision_Notes__c = component.get("v.notes");
                obj.closeDate = component.get("v.internalTargetDate");
                obj.Vision_Bid_Template__c = component.get("v.AccTemplate");
                var selectedContractNumberList = component.get("v.selectedContractNumberList");
                if(selectedContractNumberList.length > 0){
                    var commaSepratedList=selectedContractNumberList.join();
                    console.log('--Ref Contracts--'+commaSepratedList);
                    obj.Vision_Reference_Contract__c = commaSepratedList;
                }
                component.set("v.optyObj", obj);
                var action = component.get("c.saveOptyRec");
                action.setParams({
                    "optyData": JSON.stringify(obj),
                });
                action.setCallback(this, function (response) {
                    var state = response.getState();
                    console.log('state :: '+state);
                    if (state === "SUCCESS") {
                        console.log('optyId : ' + response.getReturnValue());
                        var optyId = response.getReturnValue();
                        
                        if(optyId!='null') {
                            console.log('Record saved Successfully');
                            //component.set("v.recordId", optyId);
                            helper.redirectToDetailPage(component, event, helper, optyId);
                        }
                        else{
                            console.log("failed " + JSON.stringify(response.getError()));
                        }
                    }
                    else {
                        console.log("failed " + JSON.stringify(response.getError()));
                    }
                });
                $A.enqueueAction(action);
            }
            else{
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": "Error",
                    "title": "Error!",
                    "message": "Please enter all the required field(s)."
                });
                toastEvent.fire();
                component.set('v.isSpinnerLoad', false);
            }
        }
        
    },
    openUploadPopup: function(component, event, helper){
        component.set("v.showUploadButton",true);
        document.getElementById('uploadButtonToFire').click();
    },
    handleMatchProcess: function (component, event, helper){
        console.log('handleMatchProcess');
        component.set('v.isShowUploadedProducts', false);
        component.set('v.isShowProducts', true);
        component.set("v.showProductsloading",true);
        helper.matchUploadedProducts(component, event, helper, 0);
        //helper.showProducts(component, event, helper);
    },
    handleManualProductAddition : function(component,event, helper){
        console.log('--Manual Addition called--');
    },
    changePageForTotal : function(component,event, helper){
        component.set("v.selectedPageNumber",event.getSource().get("v.value"));
        helper.paginateRecords2(component,event);
    },
    tabSelected : function(component,event, helper){
        helper.paginateRecords(component,event);
    },
    changePageForMatched : function(component,event, helper){
        component.set("v.selectedPageNumberMatched",event.getSource().get("v.value"));
        helper.paginateRecords(component,event);
    },
    changePageForMatchedNPRData : function(component,event, helper){
        component.set("v.selectedPageNumberMatched",event.getSource().get("v.value"));
        helper.paginateRecords3(component,event);
    },
    changePageForUnmatched : function(component,event, helper){
        component.set("v.selectedPageNumberUnmatched",event.getSource().get("v.value"));
        helper.paginateRecords(component,event);
    },
    fetchContracts : function(component, event, helper) {
        helper.getAllContractsList(component, event, helper);
    },
    showProductsList : function(component, event, helper){
        component.set("v.showContracts",false);
        component.set("v.isShowProducts",true);
    },
    closeContractsModal : function(component, event, helper){
        component.set("v.showContracts",false);
    },
    /* Contract Selection Functionality*/
    checkboxSelect: function(component, event, helper) {
        // on each checkbox selection update the selected record count 
        //var contractsList = component.get("v.allDataCV");
        console.log('---checkboxSelect---');
        var selectedRec = event.getSource().get("v.value");
        var selectedRecId = event.getSource().get("v.text");
        console.log('--selectedRecId--'+selectedRecId);
        console.log('--selectedRec--'+selectedRec);
        var selectedContractNumberList = component.get('v.selectedContractNumberList');
        var getSelectedNumber = component.get("v.selectedRowsCount");
        if (selectedRec == true) {
            if (!selectedContractNumberList.includes(selectedRecId)) {
                getSelectedNumber++;
                selectedContractNumberList.push(selectedRecId);
            }
            
        } else {
            selectedContractNumberList.pop(selectedRecId);
            getSelectedNumber--;
            component.find("selectAllId").set("v.value", false);
        }
        component.set("v.selectedRowsCount", getSelectedNumber);
        component.set('v.selectedContractNumberList',selectedContractNumberList);
        console.log('--selectedContractNumberList--'+JSON.stringify(component.get("v.selectedContractNumberList")));
    },
    
    selectAllCheckboxes: function(component, event, helper) {
        console.log('--allDataCV--'+JSON.stringify(component.get("v.allDataCV")));
        var contractsList = component.get("v.allDataCV");
        var selectedHeaderCheck = event.getSource().get("v.value");
        var selectedContractNumberList = [];
        var selectedContractsList = [];
        let selectedRowsCount = 0;
        console.log('--selectedHeaderCheck--'+selectedHeaderCheck);
        for (var i = 0; i < contractsList.length; i++) {
            if (selectedHeaderCheck == true) {
                contractsList[i].isChecked = true;
                selectedRowsCount = selectedRowsCount + 1;
                selectedContractsList.push(contractsList[i]);
                selectedContractNumberList.push(contractsList[i].Phoenix_Contract_Number__c );
            }
            else{
                contractsList[i].isChecked = false;
            }
        }
        component.set('v.selectedRowsCount',selectedRowsCount);
        component.set('v.allDataCV',selectedContractsList);
        component.set('v.selectedContractNumberList',selectedContractNumberList);
    },
    /* Showing Selected Product Opportunities Functionality*/
    fetchProducts : function(component, event, helper){
        console.log('--Acc Template--'+component.get("v.AccTemplate"));
        component.set("v.showContracts",false);
        component.set("v.isShowProducts",false);
        component.set('v.isSpinnerLoad',true);
        component.set("v.loadingMessage",'Loading Matched Products with NPR Data...');
        if(component.get("v.customerLkp")){
            var action = component.get("c.handleUpdateProdWithNRPForUpload");
            action.setParams({CustomerId : component.get("v.customerLkp"),
                              contractIds : component.get("v.selectedContractNumberList"),
                              optyProd : JSON.stringify(component.get("v.totalMatchdata"))
                             });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS"){  
                    var qList = response.getReturnValue();
                    if(qList == undefined || qList.length == 0)
                    {
                        component.set('v.isSpinnerLoad',false);
                        console.log("failed " + JSON.stringify(response.getError()));
                    }
                    else
                    {
                        component.set("v.totalMatchdata",JSON.parse(response.getReturnValue()));
                        helper.paginateRecords3(component,event);
                        component.set('v.isSpinnerLoad',false);
                        component.set("v.showSelectedProdOpty",true);
                    }
                } else{
                    component.set("v.isSpinnerLoad",false);
                    console.log("failed " + JSON.stringify(response.getError()));
                }
            });
            $A.enqueueAction(action);
        }
        
    },
    deleteFileAction: function(component, event, helper){
        var fileContentId = component.get("v.fileContentId");
        component.set("v.showDeleteFile",false);
        var action = component.get("c.deleteContentDoc");
        action.setParams({
            fileContentId:fileContentId
        });
        action.setCallback(this,function(response){
            console.log("state-->"+response.getState())
            if(response.getState()=='SUCCESS'){
                component.set("v.totalData",[]);
                component.set("v.totalUnmatchdata",[]);
                component.set("v.totalMatchdata",[]);
                component.set("v.fileName", '');
                component.set("v.isFileUploaded", false);
                component.set("v.isSaveUploadProducts", false);
                component.set('v.fileContentId', '');
                component.set("v.matchdata",[]);
                component.set("v.unmatchdata",[]);
                component.set("v.TotalRecords",0);
                component.set("v.matchedRowsCount",0);
                component.set("v.unmatchedRowsCount",0);
            }
        });
        $A.enqueueAction(action);
        console.log('fileContentId-->'+fileContentId)
    },
    closeModel: function(component, event, helper){
        component.set("v.showDeleteFile",false);
    },
    deleteFile: function(component, event, helper){
        component.set("v.showDeleteFile",true);
    },
    closeAndBackToAccount : function(component, event, helper){
        component.find("navigationService").navigate({
            type: "standard__recordPage",
            attributes: {
                recordId: component.get("v.customerLkp"),
                actionName: "view"
            }
        }, false); 
    },
    saveOptyWithProds : function(component, event, helper){
        
        var inputField = component.find('optyName');
        var validityObj = inputField.get("v.validity");
        if(component.get("v.customerLkp") && component.get("v.name")
           && component.get("v.source") && component.get("v.internalTargetDate") && validityObj.valid){
            var selectedContractNumberList = component.get("v.selectedContractNumberList");
            if(selectedContractNumberList.length>0){
                var obj = {};
                obj.Name = component.get("v.name");
                obj.Vision_Opportunity_Source__c = component.get("v.source");
                obj.Vision_Type__c = component.get("v.type");
                obj.StageName = component.get("v.stage");
                obj.AccountId = component.get("v.customerLkp");
                obj.Contact__c = component.get("v.cntcLkp");
                obj.Bid_Type__c = 'Product Addition';
                obj.Vision_Internal_Closing_Date__c = component.get("v.internalTargetDate");
                obj.Vision_Customer_Closing_Date__c = component.get("v.customerDeadlineDate");
                obj.CloseDate = component.get("v.internalTargetDate");
                obj.Vision_Comments__c = component.get("v.comments");
                obj.Vision_Notes__c = component.get("v.notes");
                obj.Vision_Bid_Template__c = component.get("v.AccTemplate");
                if(component.get("v.isBidClone"))
                    obj.Vision_Previous_Bid__c = component.get("v.oldBidId");
                if(selectedContractNumberList.length > 0){
                    var commaSepratedList=selectedContractNumberList.join();
                    console.log('--Ref Contracts--'+commaSepratedList);
                    obj.Vision_Reference_Contract__c = commaSepratedList;
                }
                component.set("v.optyObj", obj);
                var action = component.get("c.saveOptyAndLines");
                action.setParams({
                    optyObj : obj,
                    optyProdList : component.get("v.optyProdList")
                });
                action.setCallback(this, function (response) {
                    var state = response.getState();
                    if (state === "SUCCESS") {
                        if(component.get("v.isBidClone"))
                            helper.redirectToDetailPage(component, event, helper, response.getReturnValue());
                        else{
                            component.set('v.loading', false);
                            var navEvt = $A.get("e.force:navigateToSObject");
                            navEvt.setParams({
                                "recordId": response.getReturnValue(),
                                "slideDevName": "View Selected Products"
                            });
                            navEvt.fire();
                        }
                    }
                    else if (state === "ERROR") {
                        console.log("Error: "+JSON.stringify(response.getError()));
                    }
                });
                $A.enqueueAction(action);
            }
            else{
                helper.getAllContractsList(component, event, helper);
            }
        }
        else{
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type": "Error",
                "title": "Error!",
                "message": "Please enter all the required field(s)."
            });
            toastEvent.fire();
        }
    },
    showSelectedProducts : function(component, event, helper){
        component.set("v.showProductsFromBid",true);
    },
    closeProdPopup : function(component, event, helper){
        component.set("v.showProductsFromBid",false);
    },
})