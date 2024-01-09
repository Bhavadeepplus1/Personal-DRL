({
    doInit: function (component, event, helper) {
        component.set("v.isSpinnerLoad", true);
        var initialWestApprover = $A.get("$Label.c.West_Region_email");
        component.set('v.initialWestApprover', initialWestApprover);
        var initialEastApprover = $A.get("$Label.c.East_region_Email");
        component.set('v.initialEastApprover', initialEastApprover);
        var rsmApprover = $A.get("$Label.c.RSM_Head_Approver_Email");
        const rsmEmails = rsmApprover.split(",");
        console.log(rsmEmails);
        component.set('v.rsmApprover', rsmApprover);
        var srxApprover = $A.get("$Label.c.SRx_Head_Approver_Email");
        component.set('v.srxApprover', srxApprover);
        var marketingApprover = $A.get("$Label.c.Marketing_Head_Approval_Email");
        console.log("initialWestApprover=="+initialWestApprover);
        component.set('v.marketingApprover', marketingApprover);
        var westRegionName = $A.get("$Label.c.Dave_Smith");
        component.set("v.westRegionName",westRegionName);
        var eastRegionName = $A.get("$Label.c.Eric_Sutherland");
        component.set("v.eastRegionName",eastRegionName);
        var milanEmail = $A.get("$Label.c.Milan_Email");
        var userEmail = $A.get("$SObjectType.CurrentUser.Email");
        if(userEmail == milanEmail){
            component.set('v.loggedInUserEmail', 'mkalawadia@drreddys.com.invalid');             
        }
        else{
            component.set('v.loggedInUserEmail', userEmail);            
        }
        console.log("userEmail=="+userEmail);
        console.log("rsmApprover=="+rsmApprover);
        
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
                component.set("v.acceptedRecs",acRecs);
                component.set("v.historyRecs",historyRecs);
                component.set("v.pendingRecs",pendingRecs);
                component.set("v.isSpinnerLoad", false);
                helper.preparePaginationAccepted(component, acRecs, historyRecs, pendingRecs);
                //helper.preparePaginationHistory(component, historyRecs);
               // helper.preparePaginationPending(component, pendingRecs);
                if(component.get("v.recordId") != null && component.get("v.recordId") != undefined){
                            helper.redirectToTarget(component, event, helper,component.get("v.recordId"));
                }
            }
        });
        $A.enqueueAction(action);
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
        helper.updateTableData(component, event, helper);
    },
    handleRecordClick: function (component, event, helper) {
        component.set("v.afterRecordClick", true);
        component.set("v.backBtn", true);
        component.set("v.disableHeadIcon", true);
        var eastTableLabel = $A.get("$Label.c.East_Target_Value");
        component.set('v.eastHeader', eastTableLabel);
        var westTableLabel = $A.get("$Label.c.West_Target_Value");
        component.set('v.westHeader', westTableLabel);
        component.set("v.isSpinnerLoad", true);
        var accrecordId = event.currentTarget.dataset.acrecsid;
        console.log('recordId Records=='+accrecordId);
        helper.redirectToTarget(component, event, helper,accrecordId);
        //component.set("v.targetSubmitted", true);
        //
        
    },
    handleAllRecordClick: function (component, event, helper) {
        component.set("v.afterRecordClick", true);
        component.set("v.backBtn", false);
        component.set("v.disableHeadIcon", true);
        var eastTableLabel = $A.get("$Label.c.East_Target_Value");
        component.set('v.eastHeader', eastTableLabel);
        var westTableLabel = $A.get("$Label.c.West_Target_Value");
        component.set('v.westHeader', westTableLabel);
        component.set("v.isSpinnerLoad", true);
        var accrecordId = event.currentTarget.dataset.allrecsid;
        console.log('recordId Records=='+accrecordId);
        helper.redirectToTarget(component, event, helper,accrecordId);
        if("{!v.targetApprovalObj.Initiator_Status__c == 'In Process'}"){
            component.set('v.inProcessBackBtn', true);
        }
        
    },
    handlePendingRecordClick: function (component, event, helper) {
         component.set("v.afterRecordClick", true);
         component.set("v.backBtn", false);
       component.set("v.disableHeadIcon", true);
        var eastTableLabel = $A.get("$Label.c.East_Target_Value");
        component.set('v.eastHeader', eastTableLabel);
        var westTableLabel = $A.get("$Label.c.West_Target_Value");
        component.set('v.westHeader', westTableLabel);
        component.set("v.isSpinnerLoad", true);
        var accrecordId = event.currentTarget.dataset.pendingid;
        console.log('recordId Records=='+accrecordId);
        helper.redirectToTarget(component, event, helper,accrecordId);
        var userEmail = $A.get("$SObjectType.CurrentUser.Email");
       
    },
    
    handleChange: function (component, event) {
        // This will contain the string of the "value" attribute of the selected option
        var selectedOptionValue = event.getParam("value");
        component.set("v.selectedFinancialYear",selectedOptionValue);
        console.log('selectedFinancialYear',selectedOptionValue);
        
    },
    goBack: function (component, event, helper) {
        component.set("v.newScreen",true);
        component.set("v.backBtn",false);
    },
    mrktBackBtn: function (component, event, helper) {
        component.set("v.isSpinnerLoad", false);
        component.set("v.inProcessBackBtn", false);
        component.set("v.newScreen",true);
        component.set("v.marketingBackBtn", false);
        var targetNm = component.get("{!v.targetApprovalObj.Name}");
        component.set("v.targetNm",null);
        component.set("v.selectedFinancialYear",null);
        component.set('v.targetSubmitted',false);
        
    },
    intiatorBackBtn: function (component, event, helper) {
        component.set("v.isSpinnerLoad", false);
        component.set("v.newScreen",true);
        component.set("v.inProcessBackBtn", false);
        var targetNm = component.get("{!v.targetApprovalObj.Name}");
        component.set("v.targetNm",null);
        component.set("v.selectedFinancialYear",null);
        component.set("v.targetSubmitted",true);
        component.set('v.targetSubmitted',false);
    },
    srxtBackBtn: function (component, event, helper) {
        component.set("v.isSpinnerLoad", false);
        component.set("v.newScreen",false);
        component.set("v.inProcessBackBtn", false);
        component.set("v.inProcessBackBtn", false);
        component.set("v.afterSubmitHideTrName",true);
        component.set('v.targetSubmitted',false);
    },
    openapproveRSM: function (component, event, helper) { 
        component.set("v.approveRSMScreen",true);
        component.set("v.afterSubmitHideTrName",false);
        component.set("v.approveOrReject",'Approve');
        component.set("v.inProcessBackBtn", false);
    },
    openapproveRSMWest: function (component, event, helper) { 
        component.set("v.approveRSMWestScreen",true);
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
    openRejectRSMWest: function (component, event, helper) { 
        component.set("v.afterSubmitHideTrName",false);
        component.set("v.approveRSMWestScreen",true);
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
        component.set("v.approveRSMScreen",false);
        component.set("v.isSpinnerLoad", true);
        helper.approveRejectTarget(component, event, helper,comment,status,fieldName); 
    },
    approveRSMWest: function (component, event, helper) { 
        component.set("v.inProcessBackBtn", false);
        console.log('approveSRX');
        var fieldName = 'RSM_West_Head_Status__c';
        var status = 'Completed';
        var comment = component.get("v.targetApprovalObj.RSM_West_Head_Comments__c");
        component.set("v.approveRSMWestScreen",false);
        component.set("v.isSpinnerLoad", true);
        helper.approveRejectTarget(component, event, helper,comment,status,fieldName); 
    },
    rejectRSM: function (component, event, helper) { 
        component.set("v.inProcessBackBtn", false);
        console.log('rejetSRx');
        var fieldName = 'RSM_Head_Status__c';
        var status = 'East RSM Rejected';
        var comment = component.get("v.targetApprovalObj.RSM_Head_Comments__c");
        console.log('rejetRSM status=='+status);
        if(comment == undefined || comment == null){
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
     rejectRSMWest: function (component, event, helper) { 
        component.set("v.inProcessBackBtn", false);
        console.log('rejetSRx');
        var fieldName = 'RSM_West_Head_Status__c';
        var status = 'West RSM Rejected';
        var comment = component.get("v.targetApprovalObj.RSM_West_Head_Comments__c");
        console.log('rejetRSM status=='+status);
        if(comment == undefined || comment == null){
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
            component.set("v.approveRSMWestScreen",false);
            component.set("v.isSpinnerLoad", true);
            helper.approveRejectTarget(component, event, helper,comment,status,fieldName);              
        }
    },
  
    approveSRx: function (component, event, helper) { 
        component.set("v.inProcessBackBtn", false);
        console.log('approveSRX');
        var fieldName = 'SRx_Head_Status__c';
        var status = 'Completed';
        var comment = component.get("v.targetApprovalObj.SRx_Head_Comments__c");
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
        if(comment == undefined || comment == null){
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
        
        if(comment == undefined || comment == null){
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
        
    },
      closeRSMWestpopup: function (component, event, helper) { 
        component.set("v.marketingBackBtn",false);
        component.set("v.approveOrReject",null);
        component.set("v.approveRSMWestScreen",false);
        console.log('cancel');
        
    },
    closeSrxPopup: function (component, event, helper) { 
        component.set("v.marketingBackBtn",false);
        component.set("v.approveOrReject",null);
        component.set("v.approveSRxScreen",false);
        console.log('cancel');
        
    },
    closeMktgPopup: function (component, event, helper) { 
        component.set("v.marketingBackBtn",false);
        component.set("v.inProcessBackBtn", false);
        component.set("v.approveOrReject",null);
        component.set("v.approveMarketingScreen",false);
        console.log('cancel');
        
    },
    sortByQuarterOne : function(component, event, helper){
        console.log('in sortByQuarterOne');
        var isasc = component.get("v.isAscQ1");
        if(isasc) {
            component.set("v.isAscQ1", false);
        }else{
            component.set("v.isAscQ1", true);
        }
        component.set("v.sortField",'percentage_for_Q1');
        helper.sortByWestData(component,'percentage_for_Q1', helper,isasc);
    }, 
    sortByQuarterTwo : function(component, event, helper){
        console.log('in sortByQuarterTwo');
        var isasc = component.get("v.isAscQ2");
        if(isasc) {
            component.set("v.isAscQ2", false);
        }else{
            component.set("v.isAscQ2", true);
        }
        component.set("v.sortField",'percentage_for_Q2');
        helper.sortByWestData(component,'percentage_for_Q2', helper,isasc);
    }, 
    sortByQuarterThree : function(component, event, helper){
        console.log('in sortByQuarterThree');
        var isasc = component.get("v.isAscQ3");
        if(isasc) {
            component.set("v.isAscQ3", false);
        }else{
            component.set("v.isAscQ3", true);
        }
        component.set("v.sortField",'percentage_for_Q3');
        helper.sortByWestData(component,'percentage_for_Q3', helper,isasc);
    }, 
    sortByQuarterFour : function(component, event, helper){
        console.log('in sortByQuarterThree');
        var isasc = component.get("v.isAscQ4");
        if(isasc) {
            component.set("v.isAscQ4", false);
        }else{
            component.set("v.isAscQ4", true);
        }
        component.set("v.sortField",'percentage_for_Q4');
        helper.sortByWestData(component,'percentage_for_Q4', helper,isasc);
    },
    sortByAnnual : function(component, event, helper){
        var isasc = component.get("v.isAscAnnual");
        if(isasc) {
            component.set("v.isAscAnnual", false);
        }else{
            component.set("v.isAscAnnual", true);
        }
        component.set("v.sortField",'annualPercent');
        helper.sortByWestData(component,'annualPercent', helper,isasc);
    }, 
    sortByQuarterOneEast : function(component, event, helper){
        var isasc = component.get("v.isAscEastQ1");
        if(isasc) {
            component.set("v.isAscEastQ1", false);
        }else{
            component.set("v.isAscEastQ1", true);
        }
        component.set("v.sortField",'percentage_for_Q1');
        helper.sortByEastData(component,'percentage_for_Q1', helper,isasc);
    }, 
    sortByQuarterTwoEast : function(component, event, helper){
        console.log('in sortByQuarterTwo');
        var isasc = component.get("v.isAscEastQ2");
        if(isasc) {
            component.set("v.isAscEastQ2", false);
        }else{
            component.set("v.isAscEastQ2", true);
        }
        component.set("v.sortField",'percentage_for_Q2');
        helper.sortByEastData(component,'percentage_for_Q2', helper,isasc);
    }, 
    sortByQuarterThreeEast : function(component, event, helper){
        console.log('in sortByQuarterThree');
        var isasc = component.get("v.isAscEastQ3");
        if(isasc) {
            component.set("v.isAscEastQ3", false);
        }else{
            component.set("v.isAscEastQ3", true);
        }
        component.set("v.sortField",'percentage_for_Q3');
        helper.sortByEastData(component,'percentage_for_Q3', helper,isasc);
    }, 
    sortByQuarterFourEast : function(component, event, helper){
        var isasc = component.get("v.isAscEastQ4");
        if(isasc) {
            component.set("v.isAscEastQ4", false);
        }else{
            component.set("v.isAscEastQ4", true);
        }
        component.set("v.sortField",'percentage_for_Q4');
        helper.sortByEastData(component,'percentage_for_Q4', helper,isasc);
    },
    sortByAnnualEast : function(component, event, helper){
        var isasc = component.get("v.isAscEastAnnual");
        if(isasc) {
            component.set("v.isAscEastAnnual", false);
        }else{
            component.set("v.isAscEastAnnual", true);
        }
        component.set("v.sortField",'annualPercent');
        helper.sortByEastData(component,'annualPercent', helper,isasc);
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
      downloadCsv : function(component,event,helper){    
        console.log('downloadCsv called');
       // var exportList = [];
      //  var orderComplianceObject = component.get("v.orderComplianceObject");
       var targetApprovalObj = component.get("v.targetApprovalObj");
        var csv = helper.convertArrayOfObjectsToCSV(component,targetApprovalObj);
          console.log('csv=='+csv);
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
        hiddenElement.download = 'Compliance based on Awarded Quantity'+'-'+Now+'.csv';  // CSV file Name* you can change it.[only name not .csv] 
        document.body.appendChild(hiddenElement); // Required for FireFox browser
        hiddenElement.click(); // using click() js function to download csv file
        
    },
  
})