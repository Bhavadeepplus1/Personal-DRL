({
    approveRejectTarget: function (component, event, helper,comment,status,fieldName) { 
        console.log('helper called--'+status);
        var action = component.get("c.updatestatus");
        action.setParams({
            recordId : component.get("v.recordId"),
            fieldName : fieldName,
            status : status,
            comment : comment
        });
        action.setCallback(this, function (response) {
            var actState = response.getState();
            if (actState == 'SUCCESS') {
                var responseWrapper=response.getReturnValue();
               // component.set("v.targetApprovalObj",responseWrapper);
                 var targetApp =response.getReturnValue();
                helper.getTargetAppData(component, event, helper,targetApp);
                console.log('status-->'+JSON.stringify(responseWrapper)); 
                if(status == 'Completed'){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "type":"success",
                        "message":'Target has been successfully approved.'
                    });
                    toastEvent.fire();
                    component.set("v.isSpinnerLoad", false);   
                }
                else{
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "type":"success",
                        "message":'Target has been successfully rejected.'
                    });
                    toastEvent.fire(); 
                }
                
            }
        });
        $A.enqueueAction(action);
    },
    showErrorMessage: function(component, message) {
        var messageArray = [];
        messageArray.push({
            severity: "error",
            message: message
        });
        component.find('requiredField').showHelpMessageIfInvalid();
        component.find('targetName').showHelpMessageIfInvalid();
    },
    showCloneErrorMessage: function(component, message) {
        var messageArray = [];
        messageArray.push({
            severity: "error",
            message: message
        });
        component.find('cloneTargetName').showHelpMessageIfInvalid();
    },
   
    redirectToTarget: function (component, event, helper,accrecordId) {
        console.log('accrecordId---',accrecordId);
        var action = component.get("c.viewTarget");
        action.setParams({
            recordId : accrecordId
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
               
                component.set("v.newScreen",false);  
                if(responseWrapper.targetApp.Approval_Status__c == 'Draft'){
                    component.set("v.afterSubmitHideTrName",true);    
                }
                if(responseWrapper.targetApp.Initiator_Status__c == 'Completed'){
                    component.set("v.targetSubmitted",true);    
                     component.set("v.afterSubmitHideTrName",false); 
                }
                if(responseWrapper.targetApp.Initiator_Status__c == 'In Process'){
                    component.set("v.disableHeadIcon", false);
                    if(targetApp.Head_Target__c > 0){
                        component.set("v.disableIcon", false);
                    }
                    component.set("v.afterSubmitHideTrName",true); 
                    if(targetApp.East_Region_Target__c > 0 ){
                        component.set('v.disableIconEastChild',false);     
                    }
                    if(targetApp.West_Region_Target__c > 0 ){
                        component.set('v.disableIconWestChild',false);     
                    }
                  /* var estValue = component.get("v.targetApprovalObj.East_Region_Target__c" );
                    console.log('estValue---->>>>'+estValue);
                   var wstValue = component.get("v.targetApprovalObj.West_Region_Target__c" );
                   console.log('wstValue---->>>>'+wstValue);
                    if(estValue != '' || estValue != null || estValue != undefined && wstValue != '' || wstValue != null || wstValue != undefined){
                        component.set('v.disableIconEastChild',false);
                        component.set('v.disableIconWestChild',false);
                    }else{
                        component.set('v.disableIconEastChild',true);
                        component.set('v.disableIconWestChild',true);
                    }*/
                   
                }
                component.set("v.targetScreen",true);
            }
            else{
                console.log('error---'+JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);
    },
    getTargetAppData: function(component, event, helper,targetApp){
        console.log('targetApp==>'+JSON.stringify(targetApp))
        var testList = [];
        testList.push(targetApp);
        var customFieldList = testList.map(function(record) {
            var East_Region_Target__c;
            if(record.East_Region_Target__c !=  undefined && record.East_Region_Target__c != null){
                East_Region_Target__c =helper.formatRevenue(record.East_Region_Target__c);
            }
            
            var Head_Target__c;
            if(record.Head_Target__c !=  undefined && record.Head_Target__c != null){
                Head_Target__c = helper.formatRevenue(record.Head_Target__c);
            }
            var West_Region_Target__c;
            if(record.West_Region_Target__c !=  undefined && record.West_Region_Target__c != null){
                West_Region_Target__c  = helper.formatRevenue(record.West_Region_Target__c );
            }
            return {
                Id : record.Id,
                headTargetStr  : Head_Target__c,
                eastTargetStr  : East_Region_Target__c,
                westtargetStr  : West_Region_Target__c,
                Head_Target__c : record.Head_Target__c,
                East_Region_Target__c : record.East_Region_Target__c,
                West_Region_Target__c : record.West_Region_Target__c,
                Financial_Year__c : record.Financial_Year__c,
                
                Initiator_Approval_Completed_Time_String__c : record.Initiator_Approval_Completed_Time_String__c,
                Initiator_Approval_Sent_Time_String__c : record.Initiator_Approval_Sent_Time_String__c,
                Initiator_Status__c : record.Initiator_Status__c,
                Intial_Approver__c : record.Intial_Approver__c,
               
                Marketing_Head_Approval_Completed_Str__c : record.Marketing_Head_Approval_Completed_Str__c,
                Marketing_Head_Approval_Sent_Time_String__c : record.Marketing_Head_Approval_Sent_Time_String__c,
                Marketing_Head_Comments__c : record.Marketing_Head_Comments__c,
                Marketing_Head_Status__c : record.Marketing_Head_Status__c,
                Marketing_Approver__c : record.Marketing_Approver__c,
               
                Name : record.Name,
                Re_Target__c : record.Re_Target__c,
                
                SRx_Head_Approval_Completed_Time_String__c : record.SRx_Head_Approval_Completed_Time_String__c,
                SRx_Head_Approval_Sent_Time_String__c : record.SRx_Head_Approval_Sent_Time_String__c,
                SRx_Head_Comments__c : record.SRx_Head_Comments__c,
                SRx_Head_Status__c : record.SRx_Head_Status__c,
                SRx_Approver__c : record.SRx_Approver__c,
                
                RSM_Head_Approval_Completed_Time_String__c : record.RSM_Head_Approval_Completed_Time_String__c,
                RSM_Head_Approval_Sent_Time_String__c : record.RSM_Head_Approval_Sent_Time_String__c,
                RSM_Head_Comments__c : record.RSM_Head_Comments__c,
                RSM_Head_Status__c : record.RSM_Head_Status__c,
                RSM_Approver__c : record.RSM_Approver__c
                
            };
        });
        component.set("v.targetApprovalObj",customFieldList[0]);   
        console.log('customFieldList-->'+JSON.stringify(component.get("v.targetApprovalObj")));
          component.set("v.isSpinnerLoad", false);
    },
    getEastSalesData: function(component, event, helper,eastSalesData){
        //component.set('v.disableIconEastChild',false);
        var customFieldList = eastSalesData.map(function(record) {
            var Annual__c;
            if(record.Annual__c !=  undefined && record.Annual__c != null){
                Annual__c =helper.formatRevenue(record.Annual__c);
            }
            
            var Quarter_1__c;
            if(record.Quarter_1__c !=  undefined && record.Quarter_1__c != null){
                Quarter_1__c = helper.formatRevenue(record.Quarter_1__c);
            }
            var Quarter_2__c;
            if(record.Quarter_2__c !=  undefined && record.Quarter_2__c != null){
                Quarter_2__c  = helper.formatRevenue(record.Quarter_2__c );
            }
            var Quarter_3__c;
            if(record.Quarter_3__c !=  undefined && record.Quarter_3__c != null){
                Quarter_3__c  = helper.formatRevenue(record.Quarter_3__c );
            }
            var Quarter_4__c;
            if(record.Quarter_4__c !=  undefined && record.Quarter_4__c != null){
                Quarter_4__c  = helper.formatRevenue(record.Quarter_4__c );
            }
            return {
                Id : record.Id,
                Financial_Year__c : record.Financial_Year__c,
                Regional_Manager__c : record.Regional_Manager__c,
                Region__c : record.Region__c,
                SRx_Target__c : record.SRx_Target__c,
                User_Name__c  : record.User_Name__c,
                Quarter_1__str  : Quarter_1__c,
                Quarter_2__str  : Quarter_2__c,
                Quarter_3__str  : Quarter_3__c,
                Quarter_4__str  : Quarter_4__c,
                Quarter_1__c  : record.Quarter_1__c,
                Quarter_2__c  : record.Quarter_2__c,
                Quarter_3__c  : record.Quarter_3__c,
                Quarter_4__c  : record.Quarter_4__c,
                Annual__str  : Annual__c,
                Annual__c  : record.Annual__c
            };
        });
        component.set("v.eastSalesData",customFieldList);   
        console.log('customFieldList-->'+JSON.stringify(component.get("v.eastSalesData"))); 
    },
    getWestSalesData: function(component, event, helper,westSalesData){
        
        var customFieldList = westSalesData.map(function(record) {
            var Annual__c;
            if(record.Annual__c !=  undefined && record.Annual__c != null){
                Annual__c =helper.formatRevenue(record.Annual__c);
            }
            
            var Quarter_1__c;
            if(record.Quarter_1__c !=  undefined && record.Quarter_1__c != null){
                Quarter_1__c = helper.formatRevenue(record.Quarter_1__c);
            }
            var Quarter_2__c;
            if(record.Quarter_2__c !=  undefined && record.Quarter_2__c != null){
                Quarter_2__c  = helper.formatRevenue(record.Quarter_2__c );
            }
            var Quarter_3__c;
            if(record.Quarter_3__c !=  undefined && record.Quarter_3__c != null){
                Quarter_3__c  = helper.formatRevenue(record.Quarter_3__c );
            }
            var Quarter_4__c;
            if(record.Quarter_4__c !=  undefined && record.Quarter_4__c != null){
                Quarter_4__c  = helper.formatRevenue(record.Quarter_4__c );
            }
            return {
                Id : record.Id,
                Financial_Year__c : record.Financial_Year__c,
                Regional_Manager__c : record.Regional_Manager__c,
                Region__c : record.Region__c,
                SRx_Target__c : record.SRx_Target__c,
                User_Name__c  : record.User_Name__c,
                Quarter_1__str  : Quarter_1__c,
                Quarter_2__str  : Quarter_2__c,
                Quarter_3__str  : Quarter_3__c,
                Quarter_4__str  : Quarter_4__c,
                Quarter_1__c  : record.Quarter_1__c,
                Quarter_2__c  : record.Quarter_2__c,
                Quarter_3__c  : record.Quarter_3__c,
                Quarter_4__c  : record.Quarter_4__c,
                Annual__str  : Annual__c,
                Annual__c  : record.Annual__c
                
            };
        });
        component.set("v.westSalesData",customFieldList);   
        console.log('customFieldList-->'+JSON.stringify(component.get("v.westSalesData"))); 
    },
    
    formatRevenue: function(annualRevenue) {
        if (annualRevenue >= 1000000) {
            return '$'+(annualRevenue / 1000000).toFixed(1) + 'M';
        } else if (annualRevenue >= 1000) {
            return '$'+(annualRevenue / 1000).toFixed(1) + 'k';
        } else {
            return '$'+annualRevenue;
        }
    },
})