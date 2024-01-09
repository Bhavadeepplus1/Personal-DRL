({
    doInit: function (component, event, helper) {
        component.set("v.isSpinnerLoad", true);
       
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
        if(userEmail == 'mkalawadia@drreddys.com'){
            component.set('v.loggedInUserEmail', 'mkalawadia@drreddys.com.invalid');             
        }
        else{
        component.set('v.loggedInUserEmail', userEmail);            
        }

        var action = component.get("c.getRecords");
        action.setCallback(this, function (response) {
            console.log('Response--'+JSON.stringify(response.getReturnValue()));
            var actState = response.getState();
            
            if (actState == 'SUCCESS') {
                
                var acRecs = response.getReturnValue().acceptedRecs;
                var historyRecs = response.getReturnValue().historyRecs;
                console.log('historyRecs--'+JSON.stringify(historyRecs));
                var draftRecs = response.getReturnValue().draftRecs;
                var pendingRecs = response.getReturnValue().pendingRecs;
               
                component.set("v.acceptedRecs",acRecs);
                var selectedPageNumber = 1;
                var lineItems = acRecs;
                var pagedLineItems = lineItems.slice((selectedPageNumber-1)*10,((selectedPageNumber-1)*10)+10);
                console.log('pagedLineItems===',pagedLineItems);
                component.set("v.pagedLineItems",pagedLineItems);
                 component.set("v.selectedPageNumber",'1');
                component.set("v.historyRecs",historyRecs);
                component.set("v.draftRecs",draftRecs);
                component.set("v.pendingRecs",pendingRecs);
                component.set("v.isSpinnerLoad", false);
            }
        });
        $A.enqueueAction(action);
    },
    openPage : function(component, event, helper){
        
        var selectedPageNumber = event.getSource('').get('v.label');
        if(selectedPageNumber != component.get("v.selectedPageNumber")){
            var lineItems = component.get("v.acceptedRecs");
            var pageNumbers = lineItems.length()/10;
            var pagedLineItems = lineItems.slice((selectedPageNumber-1)*10,((selectedPageNumber-1)*10)+10);
            console.log('pageNumbers===',pageNumbers);
            component.set("v.pagedLineItems",pagedLineItems);
            component.set("v.selectedPageNumber",selectedPageNumber);
            component.set("v.pageNumbers",pageNumbers);
           
            //var LineItemtable = component.find("LineTable");
            // $A.util.addClass(LineItemtable, "maintable");
        }
        component.set("v.loaded", false);
    },
    goToNewScn : function(component, event, helper) {
        component.set("v.newScreen",true);
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
        
        //  var targetName = event.getSource().get("v.value");
        var targetName = component.get("v.cloneTargetName");
        var recId = component.get("v.reTargetName");
         if (!targetName) {
            helper.showCloneErrorMessage(component, "Target Value Name is required!");
             component.set("v.isSpinnerLoad", false);
            return;
        }
        var action = component.get("c.cloneSRxTarget");
        action.setParams({
            recordId : recId,
            reBidName : targetName
        });
        
        action.setCallback(this, function (response) {
            var actState = response.getState();
            console.log('actState-->>'+actState);
            if (actState == 'SUCCESS') {
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
                component.set("v.disableIconEastChild", false);
                component.set("v.disableIconWestChild", false);
                component.set("v.disableSubmitButton", false);
                var eastTableLabel = $A.get("$Label.c.East_Target_Value");
                component.set('v.eastHeader', eastTableLabel);
                var westTableLabel = $A.get("$Label.c.West_Target_Value");
                component.set('v.westHeader', westTableLabel);
                
                helper.redirectToTarget(component, event, helper,response.getReturnValue());
               /* if(!v.targetApprovalObj.Initiator_Status__c == 'In Process'){
                    component.set('v.inProcessBackBtn', true);
                }
                */
                component.set("v.newScreen",false);
            }
            else{
                console.log('Errorr-->>>>'+JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);
        
        
    },
    handleRecordClick: function (component, event, helper) {
        component.set("v.marketingBackBtn", true);
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
    },
    handleAllRecordClick: function (component, event, helper) {
        
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
    handleDraftRecordClick: function (component, event, helper) {
       // component.set("v.disableHeadIcon", false);
        var eastTableLabel = $A.get("$Label.c.East_Target_Value");
        component.set('v.eastHeader', eastTableLabel);
        var westTableLabel = $A.get("$Label.c.West_Target_Value");
        component.set('v.westHeader', westTableLabel);
       
        component.set("v.isSpinnerLoad", true);;
        var accrecordId = event.currentTarget.dataset.draftrecsid;
        console.log('recordId Records=='+accrecordId);
        helper.redirectToTarget(component, event, helper,accrecordId);
        component.set('v.inProcessBackBtn', true);
    },
    
    handleChange: function (component, event) {
        // This will contain the string of the "value" attribute of the selected option
        var selectedOptionValue = event.getParam("value");
        component.set("v.selectedFinancialYear",selectedOptionValue);
        console.log('selectedFinancialYear',selectedOptionValue);
    
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
    handleClick: function (component, event,helper) {
        component.set('v.disableSubmitButton',true);
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
        component.set("v.inProcessBackBtn", true);
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
                console.log('list-->'+JSON.stringify(responseWrapper)); 
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
                    console.log('list-->'+JSON.stringify(responseWrapper)); 
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
            //component.get("v.targetApprovalObj.West_Region_Target__c");
            component.set("v.targetApprovalObj.East_Region_Target__c",null);
           // component.set("v.eastSalesData",null);            
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
                    console.log('list-->'+JSON.stringify(responseWrapper)); 
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
            component.set("v.targetApprovalObj.West_Region_Target__c",null);
           // component.set("v.westSalesData",null);
            
        }
    },
   
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
                           /* var hasSpaces = /\s/.test(cloneTargetName);
                            var isDisabled = hasSpaces;
                            component.set("v.cloneButton",isDisabled);*/
                            
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
        
    },
    openSubmitPopup : function (component, event,helper) {
        component.set("v.submitPopup",true);
        component.set("v.afterSubmitHideTrName",false);
    },
      closeSubmitPopup : function (component, event,helper) {
          component.set("v.submitPopup",false);
          component.set("v.inProcessBackBtn",true);
          component.set("v.afterSubmitHideTrName",true);
    },
    submitTarget: function (component, event,helper) {
        component.set("v.isSpinnerLoad", true);
        component.set("v.marketingBackBtn",true);
        component.set("v.disableHeadIcon",true);
        component.set("v.disableIcon", true);
        component.set('v.disableIconEastChild',true);
        component.set('v.disableIconWestChild',true);
        var westTableLabel = $A.get("$Label.c.West_Target_Value");
        component.set('v.westHeader', westTableLabel);
        var eastTableLabel = $A.get("$Label.c.East_Target_Value");
        component.set('v.eastHeader', eastTableLabel);
        
        console.log('method called--'+component.get("v.recordId"));
        var action = component.get("c.updatestatus");
        action.setParams({
            recordId : component.get("v.recordId"),
            fieldName : "Initiator_Status__c",
            status : "Completed"
        });
        action.setCallback(this, function (response) {
            var actState = response.getState();
            if (actState == 'SUCCESS') {
                component.set("v.submitPopup",false);
                component.set("v.targetSubmitted",true);
                var responseWrapper=response.getReturnValue();
                console.log('list-->316'+JSON.stringify(responseWrapper)); 
                var targetApp =response.getReturnValue();
                helper.getTargetAppData(component, event, helper,targetApp);
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
        component.set("v.approveRSMScreen",false);
         component.set("v.isSpinnerLoad", true);
        helper.approveRejectTarget(component, event, helper,comment,status,fieldName); 
    },
    rejectRSM: function (component, event, helper) { 
         component.set("v.inProcessBackBtn", false);
        console.log('rejetSRx');
        var fieldName = 'RSM_Head_Status__c';
        var status = 'RSM Head Rejected';
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
})