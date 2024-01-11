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
                var targetApp =response.getReturnValue().targetApp;
                var eastSalesData =response.getReturnValue().eastData;
                helper.getEastSalesData(component, event, helper,eastSalesData);
                var westSalesData =response.getReturnValue().westData;
                helper.getWestSalesData(component, event, helper,westSalesData);
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
             else{
                
                console.log('errot---'+JSON.stringify(response.getError()));
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
    preparePagination: function (component, acRecs, draftRecs, historyRecs, pendingRecs) {
        let countTotalPage = Math.ceil(acRecs.length / component.get("v.pageSize"));
        let totalPage = countTotalPage > 0 ? countTotalPage : 1;
        component.set("v.totalPages", totalPage);
        console.log('totalPages-->>',totalPage);
        component.set("v.currentPageNumber", 1);
        component.set("v.totalRecords", acRecs.length);
        this.setPaginateAcceptedData(component);
        
        let countTotalPage1 = Math.ceil(draftRecs.length / component.get("v.pageSize1"));
        let totalPage1 = countTotalPage1 > 0 ? countTotalPage1 : 1;
        console.log('draftRecs.length-->>',draftRecs.length);
        component.set("v.totalPages1", totalPage1);
        console.log('totalPages1-->>',totalPage1);
        component.set("v.currentPageNumber1", 1);
        component.set("v.totalRecords1", draftRecs.length);
        this.setPaginateDraftData(component);
        
        let countTotalPage2 = Math.ceil(historyRecs.length / component.get("v.pageSize2"));
        let totalPage2 = countTotalPage2 > 0 ? countTotalPage2 : 1;
        component.set("v.totalPages2", totalPage2);
        console.log('totalPages2-->>',totalPage2);
        component.set("v.currentPageNumber2", 1);
        component.set("v.totalRecords2", historyRecs.length);
        this.setPaginateHistoryData(component);
        
        let countTotalPage3 = Math.ceil(pendingRecs.length / component.get("v.pageSize3"));
        let totalPage3 = countTotalPage3 > 0 ? countTotalPage3 : 1;
        component.set("v.totalPages3", totalPage3);
        console.log('totalPages3-->>',totalPage3);
        component.set("v.currentPageNumber3", 1);
        component.set("v.totalRecords3", pendingRecs.length);
        this.setPaginatePendingData(component);
        
    },
    setPaginateAcceptedData: function(component){
        let data = [];
        let pageNumber = component.get("v.currentPageNumber");
        console.log('pageNumber----',pageNumber);
        let pageSize = component.get("v.pageSize");
        console.log('pageSize----',pageSize);
        let accountData = component.get('v.acceptedRecs');
        component.set("v.totalRecs1", accountData.length);
        let currentPageCount = 0;
        let x = (pageNumber - 1) * pageSize;
        console.log('x----',x);
        component.set("v.startIndex1", x+1);
        console.log('startIndex1-->', x+1);
        //currentPageCount = x;
        let cumulativeIndex = x;
        
        for(let j = 0 ; j< accountData.length;j++)
        {
            accountData[j].sno = j+1;
        }
        
         for (; x < (pageNumber -1) * pageSize +5; x++){
            if (accountData[x]) {
                data.push(accountData[x]);
                cumulativeIndex++;
            }
        }
        console.log('cumulativeIndex----',cumulativeIndex);
        console.log('currentPageCount----',data.length);
        component.set("v.endIndex1", cumulativeIndex);
        component.set("v.pagedLineItemsAccepted", data);
        component.set("v.currentPageRecords",cumulativeIndex);
    },
    setPaginateDraftData: function(component){
        let data = [];
        let pageNumber1 = component.get("v.currentPageNumber1");
        let pageSize1 = component.get("v.pageSize1");
        let draftRecs = component.get('v.draftRecs');
        console.log('draftRecs-->>',draftRecs);
        component.set("v.totalRecs2", draftRecs.length);
        let currentPageCount1 = 0;
        let x = (pageNumber1 - 1) * pageSize1;
        component.set("v.startIndex2", x+1);
        currentPageCount1 = x;
        
        for(let j = 0 ; j< draftRecs.length;j++)
        {
            draftRecs[j].sno = j+1;
        }
        for (; x < (pageNumber1 -1) * pageSize1 +5; x++){
            if (draftRecs[x]) {
                data.push(draftRecs[x]);
                currentPageCount1++;
            }
        }
        component.set("v.endIndex2", currentPageCount1);
        component.set("v.pagedLineItemsDraft", data);
        component.set("v.currentPageRecords1", currentPageCount1);
    },
    setPaginateHistoryData: function(component){
        let data = [];
        let pageNumber2 = component.get("v.currentPageNumber2");
        let pageSize2 = component.get("v.pageSize2");
        let historyRecs = component.get('v.historyRecs');
        component.set("v.totalRecs3", historyRecs.length);
        let currentPageCount2 = 0;
        let x = (pageNumber2 - 1) * pageSize2;
        component.set("v.startIndex3", x+1);
        currentPageCount2 = x;
        
        for(let j = 0 ; j< historyRecs.length;j++)
        {
            historyRecs[j].sno = j+1;
        }
        
        for (; x < (pageNumber2 -1) * pageSize2 +5; x++){
            if (historyRecs[x]) {
                data.push(historyRecs[x]);
                currentPageCount2++;
            }
        }
        component.set("v.endIndex3", currentPageCount2);
        component.set("v.pagedLineItemsHistory", data);
        component.set("v.currentPageRecords2", currentPageCount2);
    },
    setPaginatePendingData: function(component){
        let data = [];
        let pageNumber3 = component.get("v.currentPageNumber3");
        let pageSize3 = component.get("v.pageSize3");
        let pendingRecs = component.get('v.pendingRecs');
        component.set("v.totalRecs4", pendingRecs.length);
        let currentPageCount3 = 0;
        let x = (pageNumber3 - 1) * pageSize3;
        component.set("v.startIndex4", x+1);
        currentPageCount3 = x;
        
        for(let j = 0 ; j< pendingRecs.length;j++)
        {
            pendingRecs[j].sno = j+1;
        }
        
        for (; x < (pageNumber3 -1) * pageSize3 +5; x++){
            if (pendingRecs[x]) {
                data.push(pendingRecs[x]);
                currentPageCount3++;
            }
        }
        component.set("v.endIndex4", currentPageCount3);
        component.set("v.pagedLineItemsPending", data);
        component.set("v.currentPageRecords3", currentPageCount3);
    },
    redirectToTarget: function (component, event, helper,accrecordId) {
        console.log('accrecordId---',accrecordId);
        var ericEmail = $A.get("$Label.c.Eric_Email");
        var daveEmail = $A.get("$Label.c.Dave_Email");
        var action = component.get("c.viewTarget");
        action.setParams({
            recordId : accrecordId
        });
        action.setCallback(this, function (response) {
            var actState = response.getState();
            if (actState == 'SUCCESS') {
                component.set("v.newScreen",false);
                var responseWrapper=response.getReturnValue();
                console.log('responseWrapper-->'+JSON.stringify(responseWrapper)); 
                component.set("v.recordId",responseWrapper.targetApp.Id);
                var targetApp =response.getReturnValue().targetApp;
                helper.getTargetAppData(component, event, helper,targetApp);
                var eastSalesData =response.getReturnValue().eastData;
                helper.getEastSalesData(component, event, helper,eastSalesData);
                var westSalesData =response.getReturnValue().westData;
                helper.getWestSalesData(component, event, helper,westSalesData);
               
                if(responseWrapper.targetApp.Initiator_Status__c == 'Completed'){
                    component.set("v.targetSubmitted",true);    
                    component.set("v.afterSubmitHideTrName",false); 
                    component.set("v.inProcessBackBtn",false);
                }
                if(responseWrapper.targetApp.Initiator_Status__c == 'In Process'){
                    //component.set("v.inProcessBackBtn",true); 
                    component.set("v.afterSubmitHideTrName",true); 
                    component.set("v.disableSubmitButton",false);
                    component.set("v.disableHeadIcon", false); 
                    //component.set('v.disableIconEastChild',false);
                    //component.set('v.disableIconWestChild',false);
                    if(targetApp.Head_Target__c > 0){
                        component.set("v.disableIcon", false);
                    }
                    var userEmail = $A.get("$SObjectType.CurrentUser.Email");
                    if (userEmail === daveEmail || userEmail === ericEmail){
                        if(targetApp.East_Region_Target__c > 0 ){
                            component.set('v.disableIconEastChild',false);
                        }
                         
                    }else 
                        component.set('v.disableIconEastChild',true);
                    
                    if (userEmail === daveEmail || userEmail === ericEmail) {
                        if(targetApp.West_Region_Target__c > 0){
                            component.set('v.disableIconWestChild',false); 
                        }
                            
                    }else
                        component.set('v.disableIconWestChild',true);
                    
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
        var ericName = $A.get("$Label.c.Eric_Sutherland");
        
       // var eastRegionName = $A.get("$Label.c.Eric_Sutherland");
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
                Initiator_Head_Comments__c : record.Initiator_Head_Comments__c,
               
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
         if(customFieldList[0].Intial_Approver__c == ericName){
            component.set('v.rsmApprover', $A.get("$Label.c.West_Region_email"));
        }else{
            component.set('v.rsmApprover',$A.get("$Label.c.East_region_Email"));  
        }
        component.set("v.targetApprovalObj",customFieldList[0]); 
        console.log('rsmApprover-->'+component.get("v.rsmApprover"));
        console.log('customFieldList-->'+JSON.stringify(component.get("v.targetApprovalObj")));
          component.set("v.isSpinnerLoad", false);
    },
    getEastSalesData: function(component, event, helper,eastSalesData){
        //component.set('v.disableIconEastChild',false);
        console.log('getEastSalesData-->');
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
        console.log('getWestSalesData-->');
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
    updateTableData: function (component, event, helper) {
        component.set("v.isSpinnerLoad", true);
        var action = component.get("c.getRecords");
        action.setCallback(this, function (response) {
            console.log('Response--'+JSON.stringify(response.getReturnValue()));
            var actState = response.getState();
            if (actState == 'SUCCESS') {
                
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
            }
        });
        $A.enqueueAction(action);
    },
    formatRevenue: function(annualRevenue) {
        console.log("formatRevenue---->>>");
        if (annualRevenue >= 1000000) {
            return '$'+(annualRevenue / 1000000).toFixed(1) + 'M';
        } else if (annualRevenue >= 1000) {
            return '$'+(annualRevenue / 1000).toFixed(1) + 'k';
        } else {
            return '$'+annualRevenue;
        }
    },
    getCurrentFiscalYear: function(component) {
         var fiscalStartMonth = 4;
         var currentDate = new Date();
         var currentMonth = currentDate.getMonth() + 1;
         console.log('currentMonth=='+currentMonth);
         console.log('currentDate.getFullYear()=='+currentDate.getFullYear());
         var fiscalYear = currentMonth >= fiscalStartMonth ? currentDate.getFullYear() : currentDate.getFullYear()-1;
         console.log('fiscalYear=='+fiscalYear);
         return fiscalYear;
    },
    saveInlineEdit: function(component, recordId) {
        console.log('Inside saveInlineEdit');
        var action = component.get("c.renameTargets");
        var changedName = component.get("v.changedTargetName");
        console.log('changedName-->>',changedName);
        action.setParams({
            recordIds : recordId,
            newNames : changedName
            
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state == 'SUCCESS') {
                var returnData = response.getReturnValue();
                console.log('returnData-->',JSON.stringify(returnData));
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "type":"success",
                    "message":'Target name was updated successfully'
                });
                toastEvent.fire();
                component.set("v.editableRecordId",null);
                component.set('v.nameEditable',false);
            } else {
                console.log('Error calling Apex method: ' + updateState);
            }
        });
        $A.enqueueAction(action);
    }
     
                           
})