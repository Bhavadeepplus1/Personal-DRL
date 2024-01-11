({
    doInit: function (component, event, helper) {
        component.set("v.isSpinnerLoad", true);
        var options = [];
        var fiscalStartMonth = 4;
        var currentFiscalYear = helper.getCurrentFiscalYear(component);
        console.log('currentFiscalYear=='+currentFiscalYear);
        for (var i = 1; i <= 2; i++) {
            var fiscalYearStart = currentFiscalYear + i;
            console.log('fiscalYearStart=='+fiscalYearStart);
            var label = 'FY' +' '+ (fiscalYearStart % 100);
            var value = 'FY' +' '+ (fiscalYearStart % 100);
            console.log('label=='+label);
            console.log('value=='+value);
            options.push({'label': label, 'value': value});
        }
        
        component.set("v.options", options);
        var ericEmail = $A.get("$Label.c.Eric_Email");
        var daveEmail = $A.get("$Label.c.Dave_Email");
        var milanEmail = $A.get("$Label.c.Milan_Email");
        var initialWestApprover = $A.get("$Label.c.West_Region_email");
        component.set('v.initialWestApprover', initialWestApprover);
        var initialEastApprover = $A.get("$Label.c.East_region_Email");
        component.set('v.initialEastApprover', initialEastApprover);
        var rsmApprover = $A.get("$Label.c.RSM_Head_Approver_Email");
        component.set('v.rsmApprover', rsmApprover);
        var srxApprover = $A.get("$Label.c.SRx_Head_Approver_Email");
        component.set('v.srxApprover', srxApprover);
        var marketingApprover = $A.get("$Label.c.Marketing_Head_Approval_Email");
        console.log("marketingApprover=="+marketingApprover);
        component.set('v.marketingApprover', marketingApprover);
        var userEmail = $A.get("$SObjectType.CurrentUser.Email");
        console.log('userEmail---'+userEmail);
        if(userEmail == milanEmail){
            //component.set('deleteDisable',true);
            component.set('v.loggedInUserEmail', 'mkalawadia@drreddys.com.invalid');             
        }
        else{
        component.set('v.loggedInUserEmail', userEmail);            
        }
        if(userEmail == daveEmail){
            component.set('v.fyYear',false);
            component.set('v.enterTargetName',false);
            component.set('v.deleteDisable',false);
            component.set('v.cloneDisable',false);
            component.set('v.editDisable',false);
        }
        if(userEmail == ericEmail){
            component.set('v.fyYear',false);
            component.set('v.enterTargetName',false);
            component.set('v.deleteDisable',false);
            component.set('v.cloneDisable',false);
            component.set('v.editDisable',false);
        }

         var action = component.get("c.getRecords");
        action.setCallback(this, function (response) {
            console.log('Response--'+JSON.stringify(response.getReturnValue()));
            var actState = response.getState();
            
            if (actState == 'SUCCESS') {
                
                var daveActivity =response.getReturnValue().daveActivity;
                component.set('v.daveActivity',daveActivity);
                console.log('daveActivity--->>'+daveActivity);
               
                var ericActivity =response.getReturnValue().ericActivity;
                component.set('v.ericActivity',ericActivity);
                console.log('ericActivity--->>'+ericActivity);
               
                var srimayeeActivity =response.getReturnValue().srimayeeActivity;
                console.log('srimayeeActivity--->>'+srimayeeActivity);
                component.set('v.srimayeeActivity',srimayeeActivity);
               
                var milanActivity =response.getReturnValue().milanActivity;
                 component.set('v.milanActivity',milanActivity);
                console.log('milanActivity--->>'+milanActivity);
                
                var rameshActivity =response.getReturnValue().rameshActivity;
                 component.set('v.rameshActivity',rameshActivity);
                
              /*  var srxActivity =response.getReturnValue().srxActivity;
                component.set('v.srxActivity',srxActivity);*/
                
                var acRecs = response.getReturnValue().acceptedRecs;
                console.log('accRecsList--->>'+JSON.stringify(acRecs));
               
                for (let i = 0; i < acRecs.length; i++){
                    console.log('50-->>'+acRecs[i].LastModifiedDate);
                    var dateTime = acRecs[i].LastModifiedDate;
                    var dateObject = new Date(dateTime);
                    var utcDate = new Date(dateObject.getUTCFullYear(), dateObject.getUTCMonth(), dateObject.getUTCDate(), 
                                           dateObject.getUTCHours(), dateObject.getUTCMinutes());
                    
                    
                    var formattedDate = new Intl.DateTimeFormat('en-US', {
                        year: 'numeric',
                        month: 'short',
                        day: 'numeric',
                        hour: 'numeric',
                        minute: 'numeric',
                        hour12: true
                    }).format(utcDate).replace(/,/g, '');
                    formattedDate += ' EST';
                    
                    console.log('StringTime-->>'+formattedDate);
                    acRecs[i].LastModifiedDate = formattedDate;
                    console.log('acRecs[i].LastModifiedDate-->>'+acRecs[i].LastModifiedDate);
                    
                }
                component.set("v.acceptedRecs",acRecs);
                
                var historyRecs = response.getReturnValue().historyRecs;
                console.log('historyRecs--'+JSON.stringify(historyRecs));
                for (let i = 0; i < historyRecs.length; i++){
                    var dateTime1 = historyRecs[i].LastModifiedDate;
                    var dateObject1 = new Date(dateTime1);
                    var utcDate1 = new Date(dateObject1.getUTCFullYear(), dateObject1.getUTCMonth(), dateObject1.getUTCDate(), 
                                            dateObject1.getUTCHours(), dateObject1.getUTCMinutes());
                    
                    var formattedDate1 = new Intl.DateTimeFormat('en-US', {
                        year: 'numeric',
                        month: 'short',
                        day: 'numeric',
                        hour: 'numeric',
                        minute: 'numeric',
                        hour12: true
                    }).format(utcDate1).replace(/,/g, '');
                    formattedDate1 += ' EST';
                    historyRecs[i].LastModifiedDate = formattedDate1;
                }
                
                var draftRecs = response.getReturnValue().draftRecs;
                
                for (let i = 0; i < draftRecs.length; i++){
                    var dateTime2 = draftRecs[i].LastModifiedDate;
                    var dateObject2 = new Date(dateTime2);
                    var utcDate2 = new Date(dateObject2.getUTCFullYear(), dateObject2.getUTCMonth(), dateObject2.getUTCDate(), 
                                            dateObject2.getUTCHours(), dateObject2.getUTCMinutes());
                    
                    
                    var formattedDate2 = new Intl.DateTimeFormat('en-US', {
                        year: 'numeric',
                        month: 'short',
                        day: 'numeric',
                        hour: 'numeric',
                        minute: 'numeric',
                        hour12: true
                    }).format(utcDate2).replace(/,/g, '');
                    formattedDate2 += ' EST';
                    console.log('StringTime-->>'+formattedDate2);
                    draftRecs[i].LastModifiedDate = formattedDate2;
                    console.log('acRecs[i].LastModifiedDate-->>'+draftRecs[i].LastModifiedDate);
                }
                
                var pendingRecs = response.getReturnValue().pendingRecs;
                for (let i = 0; i < pendingRecs.length; i++){
                    var dateTime3 = pendingRecs[i].LastModifiedDate;
                    var dateObject3 = new Date(dateTime3);
                    var utcDate3 = new Date(dateObject3.getUTCFullYear(), dateObject3.getUTCMonth(), dateObject3.getUTCDate(), 
                                            dateObject3.getUTCHours(), dateObject3.getUTCMinutes());
                    
                    
                    var formattedDate3 = new Intl.DateTimeFormat('en-US', {
                        year: 'numeric',
                        month: 'short',
                        day: 'numeric',
                        hour: 'numeric',
                        minute: 'numeric',
                        hour12: true
                    }).format(utcDate3).replace(/,/g, '');
                    formattedDate3 += ' EST';
                    pendingRecs[i].LastModifiedDate = formattedDate3;
                }
                component.set("v.historyRecs",historyRecs);
                component.set("v.draftRecs",draftRecs);
                component.set("v.pendingRecs",pendingRecs);
                component.set("v.isSpinnerLoad", false);
                helper.preparePagination(component, acRecs, draftRecs, historyRecs, pendingRecs);
                //helper.showLastLoggedIn(component, event, helper);
                console.log("recordId in doinit=="+component.get("v.recordId"));
                if(component.get("v.recordId") != null && component.get("v.recordId") != undefined){
                            helper.redirectToTarget(component, event, helper,component.get("v.recordId"));
                }
            }
        });
        $A.enqueueAction(action);
  
    },
    
    draftInlineEdit: function(component, event, helper){
        component.set('v.nameEditable',true);
        var recordId = event.getSource().get("v.value");
        component.set('v.draftEditRecordId',recordId);
        component.set("v.editableRecordId",recordId);
        
    },
    showEditIcon: function(component, event, helper) {
        var editIcon = component.find("editIcon");
        $A.util.removeClass(editIcon, "slds-hide");
    },

    hideEditIcon: function(component, event, helper) {
        var editIcon = component.find("editIcon");
        $A.util.addClass(editIcon, "slds-hide");
    },
    trNameChange: function(component, event, helper){
        var changedName = event.getSource().get("v.value");
        var auraId = event.getSource().get("v.name");
        console.log("Aura Id:", auraId);
        console.log('changedName--->>'+changedName);
        var draftRecs = component.get('v.pagedLineItemsDraft');
        console.log('draftRecs 151--'+JSON.stringify(draftRecs));
        component.set("v.changedTargetName",changedName);
        
    },
    cancelRetarName: function(component, event, helper){
        component.set('v.nameEditable',false);
        var recordId = component.get('v.draftEditRecordId');
        component.set("v.editableRecordId",null);
    },
    saveRetarName: function(component, event, helper){
        var recordId = component.get("v.editableRecordId");
        console.log('recordId---',recordId);
        helper.saveInlineEdit(component, recordId);
        helper.updateTableData(component, event, helper);
        
    },
    handleNextForAccepted: function(component, event, helper){        
        component.set("v.currentPageNumber", component.get("v.currentPageNumber") + 1);
        helper.setPaginateAcceptedData(component);
    },
    handlePreviousAccepted: function(component, event, helper){
       component.set("v.currentPageNumber", component.get("v.currentPageNumber") - 1);
       helper.setPaginateAcceptedData(component);
    },
    onFirstAccepted: function(component, event, helper) {        
        component.set("v.currentPageNumber", 1);
        helper.setPaginateAcceptedData(component);
    },
    onLastAccepted: function(component, event, helper) {  
        component.set("v.currentPageNumber", component.get("v.totalPages"));
        helper.setPaginateAcceptedData(component);
    },
  
    handleNextForDraft: function(component, event, helper){        
        component.set("v.currentPageNumber1", component.get("v.currentPageNumber1") + 1);
        helper.setPaginateDraftData(component);
    },
    handlePreviousForDraft: function(component, event, helper){
       component.set("v.currentPageNumber1", component.get("v.currentPageNumber1") - 1);
       helper.setPaginateDraftData(component);
    },
    onFirstDraft: function(component, event, helper) {        
        component.set("v.currentPageNumber1", 1);
        helper.setPaginateDraftData(component);
    },
    onLastDraft: function(component, event, helper) {  
        component.set("v.currentPageNumber1", component.get("v.totalPages1"));
        helper.setPaginateDraftData(component);
    },
    
    handleNextForHistory: function(component, event, helper){        
        component.set("v.currentPageNumber2", component.get("v.currentPageNumber2") + 1);
        helper.setPaginateHistoryData(component);
    },
    handlePreviousForHistory: function(component, event, helper){
       component.set("v.currentPageNumber2", component.get("v.currentPageNumber2") - 1);
       helper.setPaginateHistoryData(component);
    },
    onFirstHistory: function(component, event, helper) {        
        component.set("v.currentPageNumber2", 1);
        helper.setPaginateHistoryData(component);
    },
    onLastHistory: function(component, event, helper) {  
        component.set("v.currentPageNumber2", component.get("v.totalPages2"));
        helper.setPaginateHistoryData(component);
    },
    
    handleNextForPending: function(component, event, helper){        
        component.set("v.currentPageNumber3", component.get("v.currentPageNumber3") + 1);
        helper.setPaginatePendingData(component);
    },
    handlePreviousForPending: function(component, event, helper){
       component.set("v.currentPageNumber3", component.get("v.currentPageNumber3") - 1);
       helper.setPaginatePendingData(component);
    },
    onFirstPending: function(component, event, helper) {        
        component.set("v.currentPageNumber3", 1);
        helper.setPaginatePendingData(component);
    },
    onLastPending: function(component, event, helper) {  
        component.set("v.currentPageNumber3", component.get("v.totalPages3"));
        helper.setPaginatePendingData(component);
    },
    
    goToNewScn : function(component, event, helper) {
        console.log('goToNewScn');
        component.set("v.newScreen",true);
        component.set("v.targetSubmitted",false);
        helper.updateTableData(component, event, helper);
    },
    handleChildEvent : function(component, event, helper) {
        var message = event.getParam("message");
        component.set("v.message", message);
        alert("message--"+message);
    },
    editRecord: function (component, event, helper) {
        component.set("v.isSpinnerLoad", true);
        var recId = event.getSource().get("v.value");
        console.log('recordId---'+recId);
        helper.redirectToTarget(component, event, helper,recId);
        
    },
    deleteRecord : function(component, event, helper) {
        component.set('v.showConfirmDialog', true);
        var recordId = event.getSource().get("v.value");
        
        console.log('recordId--->>'+recordId);
        component.set('v.SrxRecDelId', recordId);
    },
    handleConfirmDialogNo : function(component, event, helper) {
        component.set('v.showConfirmDialog', false);
    },
    handleConfirmDialogYes: function (component, event, helper) {
        var recId = component.get("v.SrxRecDelId");
        component.set("v.isSpinnerLoad", true);
        //var recId = component.get("v.rowId")
        console.log('recId--->>'+recId);
        var action = component.get("c.srxDelete");
        action.setParams({
            recordId : recId
        });
        
        action.setCallback(this, function (response) {
            console.log('response---out'+response);
            var actState = response.getState();
            console.log('actState----'+actState);
            if (actState == 'SUCCESS') {
                console.log('SUCCESS');
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "type":"success",
                    "message":'Record was deleted successfully'
                });
                toastEvent.fire();
                component.set("v.draftRecs",response.getReturnValue().draftRecs);
                component.set("v.isSpinnerLoad", false);
            }else{
                console.log('Errorr---->>>'+JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);
        component.set('v.showConfirmDialog', false);
         helper.updateTableData(component, event, helper);
        
    },
    closeModel: function (component, event, helper) {
        component.set("v.isModalOpen", false);
        var targetName = component.get("v.cloneTargetName");
        component.set("v.targetName",null);
    },
    cloneRecord: function (component, event, helper) {
        component.set("v.isModalOpen", true);
        var cloneIconId = event.getSource().get("v.value");
        console.log('cloneIconId--->>>'+cloneIconId);
        component.set("v.reTargetName",cloneIconId);
    },
    submitDetails: function (component, event, helper) {
        console.log('submitDetails');
        component.set("v.isSpinnerLoad", false);
        var recId = component.get("v.reTargetName");
        console.log('cloneIconrecId--->>>'+recId);
        var action = component.get("c.cloneSRxTarget");
        action.setParams({
            recordId : recId
        });
        
        action.setCallback(this, function (response) {
            var actState = response.getState();
            console.log('returnValue---', JSON.stringify(response.getReturnValue()));
            console.log('actState-->>'+actState);
            if (actState == 'SUCCESS') {
                component.set('v.allTargetBackBtn',true);
                component.set('v.inProcessBackBtn',true);
                
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "type":"success",
                    "message":'Record was clone successfully'
                });
                toastEvent.fire();
                component.set("v.isModalOpen", false);
                
                component.set("v.disableIcon", false);
                component.set("v.disableHeadIcon", false);
                component.set("v.disableIconEastChild", true);
                component.set("v.disableIconWestChild", true);
                component.set("v.disableSubmitButton", false);
                var eastTableLabel = $A.get("$Label.c.East_Target_Value");
                component.set('v.eastHeader', eastTableLabel);
                var westTableLabel = $A.get("$Label.c.West_Target_Value");
                component.set('v.westHeader', westTableLabel);
                
                helper.redirectToTarget(component, event, helper,response.getReturnValue());
               
                component.set("v.newScreen",false);
            }
            else{
                console.log('Errorr-->>>>'+JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);
        
        
    },
    handleRecordClick: function (component, event, helper) {
        window.scrollTo(0, 0);
        component.set("v.inProcessBackBtn", false);
        component.set("v.allTargetBackBtn", true);
        component.set("v.disableHeadIcon", true);
        var eastTableLabel = $A.get("$Label.c.East_Target_Value");
        component.set('v.eastHeader', eastTableLabel);
        var westTableLabel = $A.get("$Label.c.West_Target_Value");
        component.set('v.westHeader', westTableLabel);
        component.set("v.isSpinnerLoad", true);
        var ericSuther = $A.get("$Label.c.Eric_Sutherland");
        component.set('v.ericSutherland', ericSuther);
        console.log('ericSutherland=='+ericSuther);
        var daveSmith = $A.get("$Label.c.Dave_Smith");
        component.set('v.daveSmith', daveSmith);
        var accrecordId = event.currentTarget.dataset.acrecsid;
        console.log('recordId Records=='+accrecordId);
        helper.redirectToTarget(component, event, helper,accrecordId);
        var ericEmail = $A.get("$Label.c.Eric_Email");
        var daveEmail = $A.get("$Label.c.Dave_Email");
        //component.set("v.targetSubmitted", true);
        var userEmail = $A.get("$SObjectType.CurrentUser.Email");
        if (userEmail === daveEmail || userEmail === ericEmail) {
            component.set('v.inProcessBackBtn', true);
            console.log('userEmail-->>>In false --', userEmail);
        } else {
            component.set('v.inProcessBackBtn', false);
            console.log('userEmail-->>>In true');
        }
        //helper.submitTargetData(component, event, helper);
    },
    handleAllRecordClick: function (component, event, helper) {
        window.scrollTo(0, 0);
        component.set("v.inProcessBackBtn", false);
        component.set("v.allTargetBackBtn", true);
        component.set("v.disableHeadIcon", true);
        var eastTableLabel = $A.get("$Label.c.East_Target_Value");
        component.set('v.eastHeader', eastTableLabel);
        var westTableLabel = $A.get("$Label.c.West_Target_Value");
        component.set('v.westHeader', westTableLabel);
        var ericSuther = $A.get("$Label.c.Eric_Sutherland");
        component.set('v.ericSutherland', ericSuther);
        console.log('ericSutherland=='+ericSuther);
        var daveSmith = $A.get("$Label.c.Dave_Smith");
        component.set('v.daveSmith', daveSmith);
        component.set("v.isSpinnerLoad", true);
        var accrecordId = event.currentTarget.dataset.allrecsid;
        console.log('recordId Records=='+accrecordId);
        helper.redirectToTarget(component, event, helper,accrecordId);
        var ericEmail = $A.get("$Label.c.Eric_Email");
        var daveEmail = $A.get("$Label.c.Dave_Email");
        var userEmail = $A.get("$SObjectType.CurrentUser.Email");
        if (userEmail === daveEmail || userEmail === ericEmail) {
            component.set('v.inProcessBackBtn', true);
            console.log('userEmail-->>>In');
            console.log('userEmail-->>>In false --', userEmail);
        } else {
            component.set('v.inProcessBackBtn', false);
            console.log('userEmail-->>>In true');
        }
       //helper.submitTargetData(component, event, helper);
    },
    handleDraftRecordClick: function (component, event, helper) {
        window.scrollTo(0, 0);
        component.set("v.targetSubmitted", false);
        component.set('v.allTargetBackBtn',true);
        component.set('v.disableIconEastChild',true);
        component.set('v.disableIconWestChild',true);
        var eastTableLabel = $A.get("$Label.c.East_Target_Value");
        component.set('v.eastHeader', eastTableLabel);
        var westTableLabel = $A.get("$Label.c.West_Target_Value");
        component.set('v.westHeader', westTableLabel);
       var ericSuther = $A.get("$Label.c.Eric_Sutherland");
        component.set('v.ericSutherland', ericSuther);
        console.log('ericSutherland=='+ericSuther);
        var daveSmith = $A.get("$Label.c.Dave_Smith");
        component.set('v.daveSmith', daveSmith);
        component.set("v.isSpinnerLoad", true);;
        var ericEmail = $A.get("$Label.c.Eric_Email");
        var daveEmail = $A.get("$Label.c.Dave_Email");
        var accrecordId = event.currentTarget.dataset.draftrecsid;
        console.log('recordId Records=='+accrecordId);
        helper.redirectToTarget(component, event, helper,accrecordId);
        //component.set('v.inProcessBackBtn', true);
        var userEmail = $A.get("$SObjectType.CurrentUser.Email");
        if (userEmail === daveEmail || userEmail === ericEmail) {
            component.set('v.inProcessBackBtn', true);
            console.log('userEmail-->>>In');
            console.log('userEmail-->>>In false --', userEmail);
        } else { 
            component.set('v.inProcessBackBtn', false);
            console.log('userEmail-->>>In true');
        }
    },
    handlePendingRecordClick: function (component, event, helper) {
        window.scrollTo(0, 0);
        component.set("v.inProcessBackBtn", false);
        component.set("v.allTargetBackBtn", true);
        component.set("v.disableHeadIcon", true);
        component.set('v.disableIconEastChild',true);
        component.set('v.disableIconWestChild',true);
        var eastTableLabel = $A.get("$Label.c.East_Target_Value");
        component.set('v.eastHeader', eastTableLabel);
        var westTableLabel = $A.get("$Label.c.West_Target_Value");
        component.set('v.westHeader', westTableLabel);
        var ericSuther = $A.get("$Label.c.Eric_Sutherland");
        component.set('v.ericSutherland', ericSuther);
        console.log('ericSutherland=='+ericSuther);
        var daveSmith = $A.get("$Label.c.Dave_Smith");
        component.set('v.daveSmith', daveSmith);
        component.set("v.isSpinnerLoad", true);
        var accrecordId = event.currentTarget.dataset.pendingid;
        console.log('recordId Records=='+accrecordId);
        var ericEmail = $A.get("$Label.c.Eric_Email");
        var daveEmail = $A.get("$Label.c.Dave_Email");
        helper.redirectToTarget(component, event, helper,accrecordId);
        var userEmail = $A.get("$SObjectType.CurrentUser.Email");
        if (userEmail === daveEmail || userEmail === ericEmail) {
            component.set('v.inProcessBackBtn', true);
            console.log('userEmail-->>>In');
            console.log('userEmail-->>>In false --', userEmail);
        } else {
            component.set('v.inProcessBackBtn', false);
            console.log('userEmail-->>>In true');
        }
        //helper.submitTargetData(component, event, helper);
    },
    
    handleChange: function (component, event) {
        // This will contain the string of the "value" attribute of the selected option
        var selectedOptionValue = event.getParam("value");
        component.set("v.selectedFinancialYear",selectedOptionValue);
        console.log('selectedFinancialYear',selectedOptionValue);
    
    },
    intiatorBackBtn: function (component, event, helper) {
        component.set("v.isSpinnerLoad", false);
        component.set("v.targetSubmitted", false);
        component.set("v.newScreen",true);
        component.set("v.inProcessBackBtn", false);
        component.get("v.targetName");
        component.set("v.targetName",'');
        component.set("v.selectedFinancialYear",null);
        component.get("v.pagedLineItemsDraft");
        console.log('pagedLineItemsDraft--->>',component.get("v.pagedLineItemsDraft"));
       helper.updateTableData(component, event, helper);
    },
    handleClick: function (component, event,helper) {
        //var draftRecs = component.get("v.draftRecs");
       // console.log('draftRecs-->',JSON.stringify(draftRecs));
        component.set('v.allTargetBackBtn',true);
        var userEmail = $A.get("$SObjectType.CurrentUser.Email");
        console.log('userEmail-->>>',userEmail);
        
        var financialYear = component.get("v.selectedFinancialYear");
        var targetName = component.get("v.targetName");
        
        var isValid = true;
        if (!financialYear) {
           helper.showErrorMessage(component, "Financial Year is required!");
            return;
        }
        else if (!targetName) {
            helper.showErrorMessage(component, "Target Value Name is required!");
            return;
        }
        
        component.set("v.disableIcon", true);
        //component.set("v.inProcessBackBtn", true);
        component.set("v.newScreen",false);
        component.set("v.isSpinnerLoad", true);
        var eastTableLabel = $A.get("$Label.c.East_Target_Value");
        component.set('v.eastHeader', eastTableLabel);
        console.log("eastTableLabel-->>>"+eastTableLabel);
        var westTableLabel = $A.get("$Label.c.West_Target_Value");
        component.set('v.westHeader', westTableLabel);
        console.log("westTableLabel-->>>"+westTableLabel);
        var davidMoulton = $A.get("$Label.c.Dave_Moulton");
        component.set('v.davidMoulton', davidMoulton);
        
        var ericSuther = $A.get("$Label.c.Eric_Sutherland");
        component.set('v.ericSutherland', ericSuther);
        
        var daveSmith = $A.get("$Label.c.Dave_Smith");
        component.set('v.daveSmith', daveSmith);
        var ericEmail = $A.get("$Label.c.Eric_Email");
        var daveEmail = $A.get("$Label.c.Dave_Email");
        
        console.log('targetName=='+component.get("v.targetName"));
        console.log('selectedFinancialYear=='+component.get("v.selectedFinancialYear"));
        var action = component.get("c.createTarget");
        action.setParams({
            financialYear : component.get("v.selectedFinancialYear"),
            name : component.get("v.targetName")
        });
        action.setCallback(this, function (response) {
            var actState = response.getState();
            if (actState == 'SUCCESS') {
                if (userEmail === daveEmail || userEmail === ericEmail) {
                    component.set('v.inProcessBackBtn', true);
                    console.log('userEmail-->>>In');
                    console.log('userEmail-->>>In false --', userEmail);
                } else {
                    component.set('v.inProcessBackBtn', false);
                    console.log('userEmail-->>>In true');
                }
                var responseWrapper=response.getReturnValue();
                
                console.log('responseWrapper-->'+JSON.stringify(responseWrapper)); 
                component.set("v.recordId",responseWrapper.targetApp.Id);
                var targetApp =response.getReturnValue().targetApp;
                helper.getTargetAppData(component, event, helper,targetApp);
                var eastSalesData =response.getReturnValue().eastData;
                helper.getEastSalesData(component, event, helper,eastSalesData);
                var westSalesData =response.getReturnValue().westData;
                helper.getWestSalesData(component, event, helper,westSalesData);
                //  component.set("v.targetApprovalObj",response.getReturnValue().targetApp);
                // component.set("v.eastSalesData",response.getReturnValue().eastData);
                // component.set("v.westSalesData",response.getReturnValue().westData);
               
            }
            else{
                console.log('errot---'+JSON.stringify(response.getError()));
            }
            
        });
        $A.enqueueAction(action);
        
    },
    inlineEditHeadTarget : function(component,event,helper){  
        component.set("v.OverrideHeadSales", true);
        
        setTimeout(function(){
            component.find("headSales").focus();
        }, 100);
    },
    closeheadTarget: function (component, event, helper) {       
        component.set("v.OverrideHeadSales", false);        
    },
    onHeadTargetChange : function(component,event,helper){
          component.set("v.isSpinnerLoad", true);
        //component.et("v.targetApprovalObj.East_Region_Target__c",null);
        
        
        component.set("v.targetApprovalObj.East_Region_Target__c",null);
        component.set("v.targetApprovalObj.West_Region_Target__c",null);
        var nameofEditfield = 'Head_Target__c';
        var val = event.getSource().get('v.value');
        if(val > 0){
            component.set("v.disableIcon", false);
        }else{
            component.set("v.disableIcon", true);
        }
        
        var currentValue, fieldName;
        var formattedVal = helper.formatRevenue(val);
        console.log('formattedVal is'+ formattedVal);
        currentValue = formattedVal;
       
        var action = component.get("c.saveheadTarget");
        action.setParams({
            targetValue : val,
            nameofEditfield : nameofEditfield,
            recordId : component.get("v.recordId")
        });
        action.setCallback(this, function (response) {
            var actState = response.getState();
            if (actState == 'SUCCESS') {
                var responseWrapper=response.getReturnValue();
                console.log('list--Head>>>'+JSON.stringify(responseWrapper)); 
                component.set("v.recordId",responseWrapper.Id);
                var targetApp = response.getReturnValue();
             
                helper.getTargetAppData(component, event, helper,targetApp);
            }
            else{
                console.log('errot---'+JSON.stringify(response.getError()));
            }
            
        });
        $A.enqueueAction(action);
    },
    inlineEditEastTarget : function(component,event,helper){  
        component.set("v.OverrideEastSales", true);
        setTimeout(function(){
            component.find("eastSales").focus();
        }, 100);
    },
    closeEastTarget: function (component, event, helper) {       
        component.set("v.OverrideEastSales", false);        
    },
    onEastTargetChange : function(component,event,helper){
     
        var eastSalData = component.get("v.eastSalesData");
          component.set("v.isSpinnerLoad", false);
        console.log('eastSalData='+JSON.stringify(eastSalData));
        console.log('eastSalData User_Name__c='+eastSalData[0].User_Name__c);
       
        
        var nameofEditfield = 'East_Region_Target__c';
        var val = event.getSource().get('v.value');
        if(val >0){
             component.set('v.disableIconEastChild',false);
        }else{
             component.set("v.targetApprovalObj.East_Region_Target__c",null);
             component.set('v.disableIconEastChild',true);
        }
        var currentValue, fieldName;
        currentValue = val;
        console.log('currentValue=='+currentValue);
        
        var eastRegion = component.get("v.targetApprovalObj.East_Region_Target__c");
        var westRegion = component.get("v.targetApprovalObj.West_Region_Target__c");
        console.log('eastRegion--parent'+eastRegion);
        var usName = component.get("v.targetApprovalObj.User_Name__c");
        console.log('eastRegion--usName'+usName);
        
        
        var headSales = component.get("v.targetApprovalObj.Head_Target__c");
        var westsales = (component.get("v.targetApprovalObj.West_Region_Target__c") != undefined && component.get("v.targetApprovalObj.West_Region_Target__c") != null) ? component.get("v.targetApprovalObj.West_Region_Target__c") : 0;
        var totalSales = currentValue + westsales;
        console.log('Debug headSales=='+headSales);
        console.log('Debug totalSales=='+totalSales);
        console.log('Debug West=='+westsales);
        var saveVal = true;
      
        //Two should have value and cmobination less than Head Sales
        //Two should have value and cmobination greater than Head Sales
        //East equals to null and west greater than Head sales
        //West equals to null and east greater than Head sales
        if(currentValue >0 && westsales >0 && totalSales > headSales){
            saveVal = false;
        }
        else if(currentValue >0 && westsales >0 && totalSales < headSales){
            saveVal = false;
        }
            else if(westsales == 0 && currentValue >headSales){
                saveVal = false;
            }
        
        console.log('saveVal=='+saveVal);
        if(saveVal){
            console.log('inside if');
            var action = component.get("c.saveEastTarget");
            action.setParams({
                targetValue : currentValue,
                nameofEditfield : nameofEditfield,
                recordId : component.get("v.recordId")
            });
            action.setCallback(this, function (response) {
                var actState = response.getState();
                if (actState == 'SUCCESS') {
                    var responseWrapper=response.getReturnValue();
                    console.log('list--East>>>'+JSON.stringify(responseWrapper)); 
                    //component.set("v.recordId",responseWrapper.Id);
                   var targetApp =response.getReturnValue().targetApp;
                helper.getTargetAppData(component, event, helper,targetApp);
                var eastSalesData =response.getReturnValue().eastData;
                helper.getEastSalesData(component, event, helper,eastSalesData);
                var westSalesData =response.getReturnValue().westData;
                helper.getWestSalesData(component, event, helper,westSalesData);
                //  component.set("v.targetApprovalObj",response.getReturnValue().targetApp);
                // component.set("v.eastSalesData",response.getReturnValue().eastData);
                // component.set("v.westSalesData",response.getReturnValue().westData);
                 }
                else{
                    console.log('errot---'+JSON.stringify(response.getError()));
                }
                
            });
            $A.enqueueAction(action);
        }
        else{
            console.log('inside else');
            //  component.set("v.targetApprovalObj.West_Region_Target__c",null);
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "type":"error",
                "message":'Combination of East and West region sales should be equal to Head sales'
            });
            toastEvent.fire();
            console.log('East_Region_Target__c-->>>',component.get("v.targetApprovalObj.East_Region_Target__c"));
            component.set("v.targetApprovalObj.East_Region_Target__c", '');
            //component.set("v.targetApprovalObj.East_Region_Target__c", Null);
        }
    },
   
    inlineEditWestTarget : function(component,event,helper){  
        component.set("v.OverrideWestSales", true);
        setTimeout(function(){
            component.find("WestSales").focus();
        }, 100);
    },
    closeWestTarget: function (component, event, helper) {       
        component.set("v.OverrideWestSales", false);        
    },
    onWestTargetChange : function(component,event,helper){
        var westSalData = component.get("v.westSalesData");
          component.set("v.isSpinnerLoad", false);
        var nameofEditfield = 'West_Region_Target__c';
        var val = event.getSource().get('v.value');
        if(val >0){
             component.set('v.disableIconWestChild',false);
        }else{
            component.set("v.targetApprovalObj.West_Region_Target__c",null);
            component.set('v.disableIconWestChild',true);
        }
        var currentValue, fieldName;
        currentValue = val;
        var headSales = component.get("v.targetApprovalObj.Head_Target__c");
        var eastValue = (component.get("v.targetApprovalObj.East_Region_Target__c") != undefined && component.get("v.targetApprovalObj.East_Region_Target__c") != null) ? component.get("v.targetApprovalObj.East_Region_Target__c") : 0;
        var totalSales = currentValue + eastValue;
        
        var saveVal = true;
      
        if(currentValue >0 && eastValue >0 && totalSales > headSales){
            saveVal = false;
        }
        else if(currentValue >0 && eastValue >0 && totalSales < headSales){
            saveVal = false;
        }
            else if(eastValue == 0 && currentValue >headSales){
                saveVal = false;
            }
        
        console.log('saveVal=='+saveVal);
        if(saveVal){            
            var action = component.get("c.saveWestTarget");
            action.setParams({
                targetValue : currentValue,
                nameofEditfield : nameofEditfield,
                recordId : component.get("v.recordId")
            });
            action.setCallback(this, function (response) {
                var actState = response.getState();
                if (actState == 'SUCCESS') {
                    var responseWrapper=response.getReturnValue();
                    console.log('list--west>>>'+JSON.stringify(responseWrapper)); 
                    // component.set("v.recordId",responseWrapper.Id);
                    var targetApp =response.getReturnValue().targetApp;
                    helper.getTargetAppData(component, event, helper,targetApp);
                    var eastSalesData =response.getReturnValue().eastData;
                    helper.getEastSalesData(component, event, helper,eastSalesData);
                    var westSalesData =response.getReturnValue().westData;
                    helper.getWestSalesData(component, event, helper,westSalesData);
                    //  component.set("v.targetApprovalObj",response.getReturnValue().targetApp);
                    // component.set("v.eastSalesData",response.getReturnValue().eastData);
                    // component.set("v.westSalesData",response.getReturnValue().westData);
                    
                }
                else{
                    console.log('errot---'+JSON.stringify(response.getError()));
                }
                
            });
            $A.enqueueAction(action);
        }else{
            console.log('inside else');
            // component.set("v.targetApprovalObj.West_Region_Target__c",null);
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "type":"error",
                "message":'Combination of East and West region sales should be equal to Head sales'
            });
            toastEvent.fire();
            component.set("v.targetApprovalObj.West_Region_Target__c", '');
           // component.set("v.westSalesData",null);
            
        }
    },
   /*
    validateTargetName: function (component, event, helper) {
         try{
             var targetName = component.get("v.targetName");
            var action = component.get("c.validateSRxTargetNameCtrl");
            action.setParams({
                "Name": targetName
            });
            action.setCallback(this, function (response) {
                try {
                    var state = response.getState();
                    if (state === "SUCCESS") {
                        var validOpResp = JSON.parse(response.getReturnValue());
                        component.set('v.checkingRequires', validOpResp);
                        var inputField = component.find('targetName');
                        if (validOpResp) {
                            inputField.set('v.validity', { valid: true, badInput: false });
                            inputField.setCustomValidity('');
                            component.set("v.createButton",false);
                        } else {
                            inputField.set('v.validity', { valid: false, badInput: true });
                            inputField.setCustomValidity('Target Name Already Exists!');
                            component.set("v.createButton",true);
                        }
                        inputField.reportValidity();
                    } else {
                        console.log("targetName ---- failed " + response.getError()[0].message);
                    }
            }catch (e) {
                console.log("Error in callback: " + e.message);
            }
        });
        $A.enqueueAction(action);
            
        }catch(e){
            console.log("targetNameFailed--->> " + e.getMessage());
        }
    },
    cloneValidateTargetName: function (component, event, helper) {
        try{
            console.log('target Name :: '+component.get("v.cloneTargetName"));
            var action = component.get("c.validateSRxTargetNameCtrl");
            var cloneTargetName = component.get("v.cloneTargetName");
            action.setParams({
                "Name": cloneTargetName
            });
            action.setCallback(this, function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var validOpResp = response.getReturnValue();
                    component.set('v.checkingRequires',validOpResp);
                    var inputField = component.find('cloneTargetName');
                        if (validOpResp) {
                            inputField.set('v.validity', { valid: true, badInput: false });
                            inputField.setCustomValidity('');
                            component.set("v.cloneButton",false);
                            
                        } else {
                            
                            inputField.set('v.validity', { valid: false, badInput: true });
                            inputField.setCustomValidity('Target Name Already Exists!');
                            component.set("v.cloneButton",true);
                           
                            
                        }
                        
                        inputField.reportValidity();
                }
                else {
                    console.log("targetName----failed " + response.getReturnValue());
                }
            });
            $A.enqueueAction(action);
            
        }catch(e){
            console.log("targetNameFailed--->> " + e.getMessage());
        }
        
    },*/
    openSubmitPopup : function (component, event,helper) {
        var action = component.get("c.validateSubmitButton");
        action.setParams({
            recordId : component.get("v.recordId"),
              });
        action.setCallback(this, function (response) {
            var actState = response.getState();
            if (actState == 'SUCCESS') {
                  var responseWrapper=response.getReturnValue();
                if(responseWrapper){
                    component.set("v.submitPopup",true);
                    component.set("v.afterSubmitHideTrName",false);
                }
                else{
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "type":"error",
                        "message":'Please fill all quaters for all sales reps.'
                    });
                    toastEvent.fire();
                }
                
            }
            else{
                console.log('errot---'+JSON.stringify(response.getError()));
            }
            
        });
        $A.enqueueAction(action);
        
    },
    closeSubmitPopup : function (component, event,helper) {
          component.set("v.submitPopup",false);
          component.set("v.inProcessBackBtn",true);
          component.set("v.afterSubmitHideTrName",true);
    },
    submitTarget: function (component, event,helper) {
        
        component.set("v.isSpinnerLoad", true);
        component.set("v.disableHeadIcon",true);
        component.set("v.disableIcon", true);
        component.set('v.disableIconEastChild',true);
        component.set('v.disableIconWestChild',true);
        //component.set('v.approveRSMScreen',true);
        var westTableLabel = $A.get("$Label.c.West_Target_Value");
        component.set('v.westHeader', westTableLabel);
        var eastTableLabel = $A.get("$Label.c.East_Target_Value");
        component.set('v.eastHeader', eastTableLabel);
        
        console.log('method called--'+component.get("v.recordId"));
        var action = component.get("c.updatestatus");
        action.setParams({
            recordId : component.get("v.recordId"),
            fieldName : "Initiator_Status__c",
            status : "Completed",
            comment : component.get("v.targetApprovalObj.Initiator_Head_Comments__c")
        });
        action.setCallback(this, function (response) {
            var actState = response.getState();
            if (actState == 'SUCCESS') {
                
                console.log('allTargetBackBtn-->',component.get('v.allTargetBackBtn'));
                component.set("v.submitPopup",false);
                component.set("v.targetSubmitted",true);
                var responseWrapper=response.getReturnValue();
                console.log('list--SubmitTarget>>>316'+JSON.stringify(responseWrapper)); 
                var targetApp =response.getReturnValue().targetApp;
                
                var eastSalesData =response.getReturnValue().eastData;
                helper.getEastSalesData(component, event, helper,eastSalesData);
                var westSalesData =response.getReturnValue().westData;
                helper.getWestSalesData(component, event, helper,westSalesData);
                helper.getTargetAppData(component, event, helper,targetApp);
               
                console.log('targetApp--->>'+JSON.stringify(targetApp));
                console.log('userDetails--->>'+JSON.stringify(response.getReturnValue().userActivity));
                console.log('eastSalesData--->>'+JSON.stringify(component.get("v.eastSalesData")));
                console.log('westSalesData--->>'+JSON.stringify(component.get("v.westSalesData")));

                console.log('errot---'+responseWrapper.SRx_Head_Status__c);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "type":"success",
                    "message":'Target submitted succesfully.'
                });
                toastEvent.fire();
                component.set("v.inProcessBackBtn",false);
            }
            else{
                console.log('errot---'+JSON.stringify(response.getError()));
            }
            
        });
        $A.enqueueAction(action);
        
    },
    openapproveRSM: function (component, event, helper) { 
        component.set("v.approveRSMScreen",true);
        component.set("v.afterSubmitHideTrName",false);
        component.set("v.approveOrReject",'Approve');
         component.set("v.inProcessBackBtn", false);
    },
    openapproveSRx: function (component, event, helper) { 
        component.set("v.approveSRxScreen",true);
        component.set("v.afterSubmitHideTrName",false);
        component.set("v.approveOrReject",'Approve');
         component.set("v.inProcessBackBtn", false);
    },
    openapproveMarketing: function (component, event, helper) {  
        component.set("v.marketingBackBtn",false);
        component.set("v.approveOrReject",'Approve');
         component.set("v.afterSubmitHideTrName",false);
        component.set("v.approveMarketingScreen",true);
         component.set("v.inProcessBackBtn", false);
    },
    openRejectRSM: function (component, event, helper) { 
          component.set("v.afterSubmitHideTrName",false);
        component.set("v.approveRSMScreen",true);
        component.set("v.approveOrReject",'Reject');
          component.set("v.inProcessBackBtn", false);
    },
     openRejectSRx: function (component, event, helper) { 
          component.set("v.afterSubmitHideTrName",false);
        component.set("v.approveSRxScreen",true);
        component.set("v.approveOrReject",'Reject');
          component.set("v.inProcessBackBtn", false);
    },
    openRejectMarketing: function (component, event, helper) { 
         component.set("v.afterSubmitHideTrName",false);
        component.set("v.approveOrReject",'Reject');
        component.set("v.approveMarketingScreen",true);
         component.set("v.inProcessBackBtn", false);
    },
    approveRSM: function (component, event, helper) { 
         component.set("v.inProcessBackBtn", false);
                console.log('approveSRX');
        var fieldName = 'RSM_Head_Status__c';
        var status = 'Completed';
        var comment = component.get("v.targetApprovalObj.RSM_Head_Comments__c");
       
            console.log('rejetSRx approve');
            component.set("v.approveRSMScreen",false);
             component.set("v.isSpinnerLoad", true);
            helper.approveRejectTarget(component, event, helper,comment,status,fieldName);              
        
    },
    rejectRSM: function (component, event, helper) { 
        
        component.set("v.inProcessBackBtn", false);
        console.log('rejetRSM');
        var fieldName = 'RSM_Head_Status__c';
        var status = 'RSM Head Rejected';
        var comment = component.get("v.targetApprovalObj.RSM_Head_Comments__c");
        console.log('rejetRSM status=='+status);
        if(comment == undefined || comment == null || comment == ''){
            console.log('rejetSRx null');
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "type":"error",
                "message":'Please enter rejection reason to reject the target.'
            });
            toastEvent.fire();
            
        }
        else{
            console.log('rejetSRx approve');
            component.set("v.approveRSMScreen",false);
             component.set("v.isSpinnerLoad", true);
            helper.approveRejectTarget(component, event, helper,comment,status,fieldName);              
        }
    },
    approveSRx: function (component, event, helper) { 
        console.log('comment');
         component.set("v.inProcessBackBtn", false);
        console.log('approveSRX');
        var fieldName = 'SRx_Head_Status__c';
        var status = 'Completed';
        var comment = component.get("v.targetApprovalObj.SRx_Head_Comments__c");
       
            console.log('rejetSRx approve');
            component.set("v.approveSRxScreen",false);
             component.set("v.isSpinnerLoad", true);
            helper.approveRejectTarget(component, event, helper,comment,status,fieldName);              
        
    },
    rejectSRx: function (component, event, helper) { 
         component.set("v.inProcessBackBtn", false);
        console.log('rejetSRx');
        var fieldName = 'SRx_Head_Status__c';
        var status = 'SRx Head Rejected';
        var comment = component.get("v.targetApprovalObj.SRx_Head_Comments__c");
        console.log('rejetSRx status=='+status);
        if(comment == undefined || comment == null || comment == ''){
            console.log('rejetSRx null');
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "type":"error",
                "message":'Please enter rejection reason to reject the target.'
            });
            toastEvent.fire();
            
        }
        else{
            console.log('rejetSRx approve');
            component.set("v.approveSRxScreen",false);
             component.set("v.isSpinnerLoad", true);
            helper.approveRejectTarget(component, event, helper,comment,status,fieldName);              
        }
    },
    approveMarketing: function (component, event, helper) { 
        component.set("v.marketingBackBtn",true);
         component.set("v.inProcessBackBtn", false);
      //  component.set("v.approveSRxScreen",true);
        console.log('approveMarketing');
        var fieldName = 'Marketing_Head_Status__c';
        var status = 'Completed';
        var comment = component.get("v.targetApprovalObj.Marketing_Head_Comments__c");
       
            component.set("v.approveMarketingScreen",false);
             component.set("v.isSpinnerLoad", true);
            helper.approveRejectTarget(component, event, helper,comment,status,fieldName);              
        
    },
    rejectMarketing: function (component, event, helper) { 
         component.set("v.inProcessBackBtn", false);
        var fieldName = 'Marketing_Head_Status__c';
        var status = 'Marketing Head Rejected';
        var comment = component.get("v.targetApprovalObj.Marketing_Head_Comments__c");
        
        if(comment == undefined || comment == null || comment == ''){
            
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "type":"error",
                "message":'Please enter rejection reason to reject the target.'
            });
            toastEvent.fire();
        }
        else{
            component.set("v.approveMarketingScreen",false);
             component.set("v.isSpinnerLoad", true);
            helper.approveRejectTarget(component, event, helper,comment,status,fieldName);              
        } 
    },
    closeRSMpopup: function (component, event, helper) { 
        component.set("v.marketingBackBtn",false);
        component.set("v.approveOrReject",null);
        component.set("v.approveRSMScreen",false);
        console.log('cancel');
        component.set("v.targetApprovalObj.RSM_Head_Comments__c",null);
      //  console.log('rsmCmt---->',rsmCmt);
        
    },
    closeSrxPopup: function (component, event, helper) { 
        component.set("v.marketingBackBtn",false);
        component.set("v.approveOrReject",null);
        component.set("v.approveSRxScreen",false);
        console.log('cancel');
        component.set("v.targetApprovalObj.SRx_Head_Comments__c",null);
        
    },
    closeMktgPopup: function (component, event, helper) { 
        component.set("v.marketingBackBtn",false);
         component.set("v.inProcessBackBtn", false);
        component.set("v.approveOrReject",null);
        component.set("v.approveMarketingScreen",false);
        console.log('cancel');
        component.set("v.targetApprovalObj.Marketing_Head_Comments__c",null);
        
    },
    refreshdisableSubmitButton: function (component, event, helper) { 
console.log("refreshdisableSubmitButton=="+component.get("v.refreshdisableSubmitButton"));
    },
    showLastLoggedIn:function (component, event, helper){
       var clickedCell = event.currentTarget;
       console.log('clickCell--',clickedCell);
        // Retrieve the value from the data-value attribute
       var value = clickedCell.dataset.value;
       console.log('value==>'+value);
        var showLastLoggedIn = component.get("c.getLastLoggedIn");
        showLastLoggedIn.setParams({
            "approverName": value
        });
        showLastLoggedIn.setCallback(this, function (response) {
            var status = response.getState();
            console.log('status===> in last'+status)
            if (status === 'SUCCESS') {
                let lastloginTime = response.getReturnValue();
                console.log('success in showLastLoggedIn==>'+lastloginTime) 
               var lastloginHoverMsg = 'Last BRIGHT log in: '+lastloginTime;
                
                component.set('v.lastloginHoverMsg',lastloginHoverMsg)
               /* helper.lastBidVisit(component, event, helper,value);*/
                
            }else{
                console.log('----error in last bright login---' + response.getError());
            }
        });
        $A.enqueueAction(showLastLoggedIn);
        
    },
})