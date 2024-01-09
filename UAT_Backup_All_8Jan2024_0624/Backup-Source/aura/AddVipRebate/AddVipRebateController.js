({
    handleChange: function(component, event, helper){
        if(component.get("v.division") != 'None'){
            console.log('handle change called vip rebate controller');
            component.set("v.bidRebateCurrentList", null);
            helper.getData(component, event, helper);   
        }
    },
    doInit : function(component, event, helper) {
        //if(component.get("v.division") != 'None')
        	helper.getData(component, event, helper);
    },
    confirmDelete : function(component, event, helper){
        
    },
    deleteVip : function(component, event, helper){
        console.log('deletevip button pressed. selectedTabId :: '+component.get("v.selectedTabId"));
        var deleteEvent = component.getEvent("deleteEvent");
        deleteEvent.setParams({"selectedTabId" : component.get("v.selectedTabId")});
        deleteEvent.fire();
    },
    handleSaveOnChange: function(component, event, helper) {
        component.set("v.showSaveCancelBtn2",true);
    },
    
    onCheckExclusions: function(component, event, helper) {
        component.set("v.showSaveCancelBtn2",true);
        
    },
    closeModal: function (component, event, helper) {
        
        $A.get('e.force:refreshView').fire();
        
    },
    downloadCsv: function (component, event, helper) {
        var objectRecords = component.get("v.bidRebateCurrentList");
        var ResultName2 = component.get("v.bidRebateProposedList2");  
        
        if((objectRecords == undefined || objectRecords.length == 0) && (ResultName2 == undefined || ResultName2.length == 0)){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type":"ERROR",
                "title": "ERROR",
                "message": "There are no Current or Proposed VIP rebate lines found to download."
            });
            toastEvent.fire();
            return;
        }
        
        
        var csv1 = helper.convertArrayOfObjectsToCSV(component, objectRecords,ResultName2);
        if (csv1 == null) {
            return;
        }
        var hiddenElement1 = document.createElement('a');
        hiddenElement1.href = 'data:text/csv;charset=utf-8,' + encodeURI(csv1);
        hiddenElement1.target = '_self'; //
        var date = new Date();
        var hours = date.getHours();
        var minutes = date.getMinutes();
        var newformat = hours >= 12 ? 'PM' : 'AM';
        hours = hours % 12;
        hours = hours ? hours : 12;
        minutes = minutes < 10 ? '0' + minutes : minutes;
        var Now = (date.getMonth() + 1) + '/' + date.getDate() + '/' + date.getFullYear() + ' ' + hours + ':' + minutes + ' ' + newformat;
        hiddenElement1.download = 'VIP Rebate '+ '-' + Now + '.csv'; // CSV file Name* you can change it.[only name not .csv] 
        document.body.appendChild(hiddenElement1); // Required for FireFox browser
        hiddenElement1.click(); // using click() js function to download csv file
        
    },
    rebateTypeChange: function(component, event, helper) {
        var rebate=component.find("headerRebateType234").get("v.value");
        component.set("v.rebateType",rebate);
        component.set("v.isRebTypeChanged",true);
        component.set("v.isRebTypeChangedPopup",true); 
        component.set("v.showSaveCancelBtn2",true);
        var proposedRebate = component.get("v.bidRebateProposedList2");
        if(rebate == 'Currency'){
            proposedRebate.forEach(function(propRebate){
                propRebate.Phoenix_Dollar_Value_From__c = null;
                propRebate.Phoenix_Dollar_Value_To__c = null;
            });
        }
        else{
            proposedRebate.forEach(function(propRebate){
                propRebate.Phoenix_Unit_Volume_From__c = null;
                propRebate.Phoenix_Unit_Volume_To__c = null;
            });
        }
        component.set("v.bidRebateProposedList2",proposedRebate);
        /* var childCmp = component.find('proposedComp');          
            [].concat(childCmp)[0].callChild();*/
    },
    
    /*
    receiveVipObject : function(component, event){
        console.log(' --- inside receiveVipObject --- ');
        var vipRebate = event.getParam("vipRebate");
        var customerLkp = event.getParam("customerLkp");
        console.log('customerLkp inside receiveVipObject --- '+customerLkp);
        component.get("v.customerLkp",customerLkp);
        component.set("v.vipRebate",vipRebate);
        if(event.getParam("bidRebateProposedList2") != undefined){
            var bidRebateProposedList2 = event.getParam("bidRebateProposedList2");
            component.set("v.bidRebateProposedList2",bidRebateProposedList2);
        }
        component.set("v.isVipRebateExist",false);
    }, */
    
    getCustomerVIP: function(component, event, helper){
        var errorMessage = '';
        var isCustExists = false;
        var customerId = component.get("v.customerLkp");
        var custIdList = component.get("v.customerIdList");
        for(var i in custIdList){
            if(customerId == custIdList[i].custId){
                console.log(' ::INSIDE MATCHING IDS:: ');
                isCustExists = true;
                errorMessage = 'View "VIP Rebate Change - '+custIdList[i].custName+'" to view the VIP rebate for selected customer.';
                break;
            }
        }
        if(isCustExists){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "type":"error",
                "message":errorMessage
            });
            toastEvent.fire();
        }
        else{
            console.log("CustomerId---->"+customerId);
            var action = component.get("c.getCustomerVIPRebate");
            action.setParams({
                customerId : customerId
            });
            action.setCallback(this, function(response) 
                               {
                                   if(response.getState()=="SUCCESS"){
                                       var result = response.getReturnValue();
                                       component.set("v.vipRebate",result);
                                       component.set('v.showSearchResult',true);
                                       /*var compEvent = component.getEvent("processedVipRebate");
                                       compEvent.setParams({"canCloseTab" : false});
                                       compEvent.setParams({"vipRebate" : result});
                                       compEvent.setParams({"customerLkp" : component.get("v.customerLkp")});
                                       if(component.find("excDetails").get("v.value")!=undefined)
                                           compEvent.setParams({"excDetails" : component.find("excDetails").get("v.value")});
                                       if(component.find("headerRebateType234").get("v.value")!=undefined)
                                           compEvent.setParams({"headerRebateType234" : component.find("headerRebateType234").get("v.value")});
                                       if(component.find("endDate").get("v.value")!=undefined)
                                           compEvent.setParams({"endDate" : component.find("endDate").get("v.value")});
                                       if(component.find("startDate").get("v.value")!=undefined)
                                           compEvent.setParams({"excDetails" : component.find("startDate").get("v.value")});
                                       
                                       compEvent.fire();*/
                                       //console.log("result--->"+JSON.stringify(result));
                                   }
                                   
                               });
            $A.enqueueAction(action);
        }
    },
    saveProposedRebateList: function(component, event, helper) {
        console.log('save');
        var rebType = component.get("v.rebateType");
        var rebateListCopy1 = component.get("v.bidRebateProposedList2");
        var noErrorsInCalc = true;
        if(rebateListCopy1.length>0){
            rebateListCopy1.forEach(function(lineItem){
                if(rebType=='Currency' && lineItem.Phoenix_Dollar_Value_From__c==null){
                    noErrorsInCalc = false;
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        message:'Please enter the Dollar Value for Proposed rebate.',
                        duration:' 5000',
                        key: 'info_alt',
                        type: 'error',
                        mode: 'dismissible'
                    });
                    toastEvent.fire();
                    return;
                }
                else if(rebType=='Quantity' && lineItem.Phoenix_Unit_Volume_From__c==null){
                    noErrorsInCalc = false;
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        message:'Please enter the Unit Volume for Proposed rebate.',
                        duration:' 5000',
                        key: 'info_alt',
                        type: 'error',
                        mode: 'dismissible'
                    });
                    toastEvent.fire();
                    return;
                } 
            });
            if(noErrorsInCalc)
                noErrorsInCalc = helper.reCalculateHelper(component, event, helper);
        }
        else{
            noErrorsInCalc = false;
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                message:'Please Enter at least 1 Proposed Rebate value.',
                duration:' 8000',
                key: 'info_alt',
                type: 'error',
                mode: 'dismissible'
            });
            toastEvent.fire();
        }
        console.log('noErrorsInCalc :: '+noErrorsInCalc);
        if(noErrorsInCalc){
            console.log('inside noErrors');
            var recordId = component.get("v.bidId");//component.get("v.recordId");
            console.log('recordId-----'+recordId);
            var exclusion= component.get('v.checkBoxField'); 
            if(exclusion==undefined){
                exclusion=false;
            }
            if(component.find("excDetails").get("v.value")!=undefined){
                var excDetails= component.find("excDetails").get("v.value");  
                console.log('excDetails-----'+excDetails);
            }
            if(component.find("headerRebateType234").get("v.value")!=undefined){
                var rebateType= component.find("headerRebateType234").get("v.value"); 
                console.log('rebateType-----'+rebateType);
            }
            else{
                var rebateType= 'Currency';    
                
            }
            if(component.find("endDate").get("v.value")!=''){
                var endDateRebate= component.find("endDate").get("v.value");    
                console.log('endDateRebate-----'+endDateRebate);
            }
            var StDate=component.get("v.strtDateRebate");
            if(component.find("startDate").get("v.value")!='' ){
                var strtDate= component.find("startDate").get("v.value");
                console.log('strtDate-----'+strtDate);
            }
            var rebateListCopy = component.get("v.bidRebateProposedList2");
            console.log('rebateListCopy-----'+rebateListCopy);
            if(rebateListCopy1!=''){
                for (let i = 0; i <rebateListCopy.length; i++) {
                    var j=i+1
                    var k=j+1;
                    if(((rebateListCopy[i].Phoenix_Discount_Rebate__c==null || rebateListCopy[i].Phoenix_Discount_Rebate__c== '' || rebateListCopy[i].Phoenix_Discount_Rebate__c==undefined))
                       &&(rebateListCopy[i].Phoenix_Discount_Rebate__c!=0)){
                        component.set("v.isSpinnerLoad",false);
                        component.set("v.discRebate",true);
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            message:'Please enter the Tier '+j+' Discount Rebate',
                            duration:' 8000',
                            key: 'info_alt',
                            type: 'error',
                            mode: 'dismissible'
                        });
                        toastEvent.fire();
                    }
                    else if(rebateListCopy[i].Phoenix_Discount_Rebate__c<0){
                        component.set("v.discRebate",true);
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            message:'Please enter the valid Discount Rebate for Tier '+j,
                            duration:' 8000',
                            key: 'info_alt',
                            type: 'error',
                            mode: 'dismissible'
                        });
                        toastEvent.fire();    
                    }
                        else{
                            //  component.set("v.inputDiscReb",false);  
                        }
                }
            }
            if((strtDate==null)){
                component.set('v.isSpinnerLoad',false);
                component.set("v.showDateMsgStrt",true);
                var toastEvent = $A.get("e.force:showToast");
                
                toastEvent.setParams({
                    message: 'Please enter Start Date',
                    duration:' 8000',
                    key: 'info_alt',
                    type: 'error',
                    mode: 'dismissible'
                });
                toastEvent.fire();       
                component.set("v.showDateMsgStrt",false);
            }
            else if((endDateRebate==null)){
                component.set('v.isSpinnerLoad',false);
                component.set("v.showDateMsgEnd",true);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    message: 'Please enter End Date',
                    duration:' 8000',
                    key: 'info_alt',
                    type: 'error',
                    mode: 'dismissible'
                });
                toastEvent.fire();       
                component.set("v.showDateMsgEnd",false);
            }
                else if((strtDate>endDateRebate)){
                    component.set('v.isSpinnerLoad',false);
                    component.set("v.showDateMsg",true);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        message: 'End Date should be greater than Start Date',
                        duration:' 8000',
                        key: 'info_alt',
                        type: 'error',
                        mode: 'dismissible'
                    });
                    toastEvent.fire();
                }
                    else{
                        if((exclusion==true) && ((component.find("excDetails").get("v.value")=='')|| (component.find("excDetails").get("v.value")==undefined))){
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                message:'Please enter the Exclusion Details',
                                duration:' 8000',
                                key: 'info_alt',
                                type: 'error',
                                mode: 'dismissible'
                            });
                            toastEvent.fire();    
                        }
                        else{
                            var showReCalToast= component.get("v.reCalculateToast");
                            var showRebateToast=component.get("v.discRebate");
                            if(showReCalToast==false && showRebateToast==false){
                                component.set('v.isSpinnerLoad',true);
                                var customerId = '';
                                customerId = component.get("v.selectedCustId")
                                var action = component.get("c.saveLineItemsInTab");
                                action.setParams({
                                    'LineItemList': component.get("v.bidRebateProposedList2"),
                                    'recId': component.get("v.bidId"),
                                    'excsnDetails':excDetails,
                                    'stDate':strtDate,
                                    'endDate':endDateRebate,
                                    'exclusions':exclusion,
                                    'rebType':rebateType,
                                    'customerId':customerId,
                                    'paymentFrequency': component.get("v.proposedPaymentFrequency"),
                                    'netGross': component.get("v.proposedNetGross"),
                                    'division': component.get("v.division"),
                                });
                                action.setCallback(this, function(response) {
                                    var state = response.getState();
                                    console.log('---state----'+state);
                                    var errors = response.getReturnValue();
                                    console.log('---errors----'+errors);
                                    if (errors) {
                                        if (errors[0] && errors[0].message) {
                                            console.log("Error message: -----------------------" +
                                                        errors[0].message);
                                        }
                                    }
                                    var storeResponse = response.getReturnValue();
                                    if (state === "SUCCESS") {
                                        component.set("v.disableDivision", true);
                                        var storeResponse = response.getReturnValue();
                                        component.set('v.isSpinnerLoad',false);
                                        var toastEvent = $A.get("e.force:showToast");
                                        toastEvent.setParams({
                                            "type":"success",
                                            "title": "Success",
                                            "message": "Record has been Updated successfully."
                                        });
                                        toastEvent.fire();
                                        
                                        $A.get('e.force:refreshView').fire();
                                    }
                                    else if (state === "ERROR") {
                                        var errors = response.getError();
                                        if (errors) {
                                            if (errors[0] && errors[0].message) {
                                                console.log("Error message: -----------------------" +
                                                            errors[0].message);
                                            }
                                        }
                                        component.set('v.isSpinnerLoad',false);
                                    } 
                                        else{
                                            component.set("v.showSaveCancelBtn",false);
                                            component.set('v.isSpinnerLoad',false);
                                        }
                                });
                                $A.enqueueAction(action);   
                                
                            }
                        }
                    }
        }
    },
    addNewProposedRebateRow: function(component, event, helper) {
        var validFromValue=  component.get("v.validFrom");
        if(validFromValue==false){
            var accountList = component.get("v.bidRebateProposedList2");
            console.log('accountList----->'+JSON.stringify(accountList))
            var OutDiv = component.find("mainDiv1");
            if(accountList.length<4){
                $A.util.addClass(OutDiv,"noheightClass");
            }
            else{
                $A.util.removeClass(OutDiv,"noheightClass");
                //  $A.util.addClass(OutDiv,"heightClass");
            }
            accountList.push({
                'sobjectType': 'Phoenix_VIP_Rebate_Line__c',
                'Phoenix_Tier__c': ' ',
                'Phoenix_Dollar_Value_From__c': null,
                'Phoenix_Dollar_Value_To__c': null,
                'Phoenix_Unit_Volume_From__c': null,
                'Phoenix_Unit_Volume_To__c': null,
                'Phoenix_Discount_Rebate__c': 0,
                'Phoenix_Remarks__c': ' ',
                'Phoenix_VIP_Rebate__c' : null
            }); 
            component.set("v.bidRebateProposedList2",accountList); 
            var rebateType= component.find("headerRebateType234").get("v.value");  
            if(rebateType==undefined){
                component.set("v.rebateType",'Currency');    
            }
            else{
                component.set("v.rebateType",rebateType);  
            }
            /* var compEvent = component.getEvent("processedVipRebate");
            if(component.find("excDetails").get("v.value")!=undefined)
                compEvent.setParams({"excDetails" : component.find("excDetails").get("v.value")});
            if(component.find("headerRebateType234").get("v.value")!=undefined)
                compEvent.setParams({"headerRebateType234" : component.find("headerRebateType234").get("v.value")});
            else
                compEvent.setParams({"headerRebateType234" : 'Currency'});
            if(component.find("endDate").get("v.value")!=undefined)
                compEvent.setParams({"endDate" : component.find("endDate").get("v.value")});
            if(component.find("startDate").get("v.value")!=undefined)
                compEvent.setParams({"excDetails" : component.find("startDate").get("v.value")});
            
            compEvent.fire(); */
        }
        else{
            console.log('inside else of validFromValue');
        }
    },
    reCalculate: function(component, event, helper) {
        var rebType = component.get("v.rebateType");
        var rebateListCopy1 = component.get("v.bidRebateProposedList2");
        var noErrorsInCalc = true;
        if(rebateListCopy1.length>0){
            rebateListCopy1.forEach(function(lineItem){
                if(rebType=='Currency' && lineItem.Phoenix_Dollar_Value_From__c==null){
                    noErrorsInCalc = false;
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        message:'Please enter the Dollar Value for Proposed rebate.',
                        duration:' 5000',
                        key: 'info_alt',
                        type: 'error',
                        mode: 'dismissible'
                    });
                    toastEvent.fire();
                    return;
                }
                else if(rebType=='Quantity' && lineItem.Phoenix_Unit_Volume_From__c==null){
                    noErrorsInCalc = false;
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        message:'Please enter the Unit Volume for Proposed rebate.',
                        duration:' 5000',
                        key: 'info_alt',
                        type: 'error',
                        mode: 'dismissible'
                    });
                    toastEvent.fire();
                    return;
                } 
            });
            if(noErrorsInCalc)
                noErrorsInCalc = helper.reCalculateHelper(component, event, helper);
        }
    },
    handleUploadFinished: function (component, event, helper) {
        helper.handleUploadFinished(component, event);
    },    
    handleEvent: function(component, event, helper) {
        var message = event.getParam("message");
        var fromWhichCmp = event.getParam("fromWhichCmp");
        if(fromWhichCmp == 'childCmp'){
            var AllRowsList = component.get("v.bidRebateProposedList2");
            // console.log('----message---'+message);
            for (let i = 0; i < AllRowsList.length; i++) {
                var index = message-1;
                if (index > -1) {
                    var allRowsListRemove=AllRowsList[index];
                    AllRowsList.splice(index, 1);  
                    break;
                }
                
            }
            var OutDiv = component.find("mainDiv1");
            if(AllRowsList.length<4){
                $A.util.addClass(OutDiv,"noheightClass");
            }
            else{
                $A.util.removeClass(OutDiv,"noheightClass");
            }         
            
            component.set("v.bidRebateProposedList2",AllRowsList);
            if(allRowsListRemove.Id!=undefined){
                var action = component.get("c.deleteRebate");
                action.setParams({
                    LineItemId :allRowsListRemove
                });
                action.setCallback(this,function(response) {
                    var state = response.getState();
                    if(state=='SUCCESS'){
                    }
                    
                });
                $A.enqueueAction(action);    
            }
        }
    },
    pullChangedTyeRecord : function(component, event, helper){
        var selectedType = component.get("v.typeRebate");//component.get("v.vipRebate.vipRebateList.Phoenix_Type__c");
        var customerId = component.get("v.selectedCustId");//component.get("v.customerLkp");
        var recordId = component.get("v.bidId");//component.get("v.c__recordId");
        var action = component.get("c.getVipRebateByType");
        if(customerId != null && customerId != ''){
            var action = component.get("c.getVipAndRelatedListByType");
            action.setParams({
                selectedType : selectedType,
                bidId : recordId,
                customerId : customerId
            });
            action.setCallback(this, function(response){
                if(response.getState()=="SUCCESS"){
                    component.set("v.isVipRebateExist",true);
                    var wrapperObj =  response.getReturnValue();
                    var rebatesList = wrapperObj.rebatesList;
                    var rebatesListProposed = wrapperObj.rebatesListProposed;
                    var columnList = wrapperObj.columnList;
                    var bidRecord = wrapperObj.bidRecord;
                    var startDate=wrapperObj.strtDate;
                    var endDate=wrapperObj.endDate;
                    var type=wrapperObj.type;
                    var exclusions=wrapperObj.exclusions;
                    var excDetails=wrapperObj.excDetails;
                    var startDatePro=wrapperObj.strtDatePro;
                    var endDatePro=wrapperObj.endDatePro;
                    var typePro=wrapperObj.typePro;
                    var exclusionsPro=wrapperObj.exclusionsPro;
                    var excDetailsPro=wrapperObj.excDetailsPro;
                    var bidType=wrapperObj.bidType;
                    var customerName=wrapperObj.custName;
                    var currentRebRec=wrapperObj.currentRebate;
                    var currentRebName=wrapperObj.currentRebateName;
                    var proposedRebRec=wrapperObj.proposedRebate;
                    var proposedRebName=wrapperObj.proposedRebateName;
                    var approvalState=wrapperObj.approvalStatus;
                    var loggedInUserId=wrapperObj.loggedInUserId;
                    
                    var fileList=[];
                    var totalFiles=[];
                    var checked=false;
                    totalFiles=wrapperObj.conDocLink;
                    if(totalFiles!=undefined&&totalFiles!=null)
                    {
                        for(var i=0;i<totalFiles.length;i++)
                        {
                            fileList.push({"Id":totalFiles[i].ContentDocumentId,"Title":totalFiles[i].ContentDocument.Title+'.'+totalFiles[i].ContentDocument.FileExtension,"checked":checked});
                        }
                    }
                    component.set("v.fileList",fileList);
                    component.set("v.loggedInUserName",loggedInUserId);
                    
                    component.set("v.approvalStatus",approvalState);
                    if(approvalState!='Draft'){
                        component.set("v.doNotEdit",true); 
                        component.set("v.disableInApproval",true);    
                    }
                    else{
                        component.set("v.doNotEdit",false); 
                        component.set("v.disableInApproval",false);
                    }
                    component.set("v.currentRec",currentRebRec);
                    component.set("v.currentRecName",currentRebName);
                    component.set("v.proposedRec",proposedRebRec);
                    component.set("v.proposedRecName",proposedRebName);
                    component.set("v.strtDateRebate",startDate);
                    component.set("v.endDateRebate",endDate);
                    if(startDate == undefined || startDate == null)
                        component.set("v.typeRebate",selectedType);
                    else
                        component.set("v.typeRebate",type);
                    
                    component.set("v.checkBoxFieldCurrent",exclusions);
                    component.set("v.excDetailsRebate",excDetails);
                    component.set("v.strtDateRebatePro",startDatePro);
                    component.set("v.endDateRebatePro",endDatePro);
                    component.set("v.typeRebatePro",typePro);
                    component.set("v.checkBoxField",exclusionsPro);
                    component.set("v.excDetailsRebatePro",excDetailsPro);
                    component.set("v.custName",customerName);
                    component.set("v.bidType",bidType);
                    var rebate=typePro;
                    component.set("v.rebateType",rebate);
                    component.set("v.isRebTypeChanged",true);
                    if(rebatesList!=undefined){
                        console.log('allocating the CurrentList -----');
                        component.set("v.bidRebateCurrentList",rebatesList);   
                    }
                    else
                        component.set("v.bidRebateCurrentList",[]);
                    if(rebatesListProposed!=undefined){
                        console.log('allocating the proposedlist -----');
                        component.set("v.bidRebateProposedList2",rebatesListProposed);
                    }
                    else{
                        component.set("v.bidRebateProposedList2",[]);
                    }
                    component.set("v.bidRecords",bidRecord);
                    component.set("v.busStatus",bidRecord.Phoenix_Business_Approval__c);
                    component.set("v.busCom",bidRecord.Phoenix_Business_Approval_Comments__c);
                    component.set("v.finStatus",bidRecord.Phoenix_Finance_Approval__c);
                    component.set("v.finCom",bidRecord.Phoenix_Finance_Approval_Comments__c);
                    component.set("v.contrStatus",bidRecord.Phoenix_Contracts_Approval__c);
                    component.set("v.contrCom",bidRecord.Phoenix_Contracts_Approval_Comments__c);
                    component.set("v.custStatus",bidRecord.Phoenix_Customer_Approval__c);
                    component.set("v.custCom",bidRecord.Phoenix_Customer_Approval_Comments__c);
                    component.set("v.vistStatus",bidRecord.Phoenix_Vistex_Update__c);
                    component.set("v.vistCom",bidRecord.Phoenix_Vistex_Update_Comments__c);
                    component.set('v.showSearchResult',true);
                    component.set('v.isSpinnerLoad',false);
                    
                    if(approvalState=='Business Head'){
                        
                        if(bidRecord.Phoenix_Business_Approval__c=='--None--'){
                            component.set("v.showProceedBtn",false);          
                        }
                        else if(bidRecord.Phoenix_Business_Approval__c==undefined){
                            component.set("v.showProceedBtn",false);          
                        }
                            else{
                                component.set("v.showProceedBtn",true);          
                                
                            }    
                    }
                    
                    if(approvalState=='Finance'){
                        if(bidRecord.Phoenix_Finance_Approval__c=='--None--'){
                            component.set("v.showProceedBtn",false);          
                        }
                        else if(bidRecord.Phoenix_Finance_Approval__c==undefined){
                            component.set("v.showProceedBtn",false);          
                        }
                        
                            else{
                                component.set("v.showProceedBtn",true);          
                                
                            }  
                    }
                    
                    
                    if(approvalState=='Contracts'){ 
                        if(bidRecord.Phoenix_Contracts_Approval__c=='--None--'){
                            component.set("v.showProceedBtn",false);          
                        }
                        else if(bidRecord.Phoenix_Contracts_Approval__c==undefined){
                            component.set("v.showProceedBtn",false);          
                        }
                            else{
                                component.set("v.showProceedBtn",true);          
                                
                            }
                    }
                    
                    
                    
                    if(approvalState=='Customer Pending'){ 
                        if(bidRecord.Phoenix_Customer_Approval__c=='--None--'){
                            component.set("v.showProceedBtn",false);          
                        }
                        else if(bidRecord.Phoenix_Customer_Approval__c==undefined){
                            component.set("v.showProceedBtn",false);          
                        }
                            else{
                                component.set("v.showProceedBtn",true);          
                                
                            } 
                    }
                    
                    
                    if(approvalState=='Vistex Update'){
                        if(bidRecord.Phoenix_Vistex_Update__c=='--None--'){
                            component.set("v.showProceedBtn",false);          
                        }
                        else if(bidRecord.Phoenix_Vistex_Update__c==undefined){
                            component.set("v.showProceedBtn",false);          
                        }
                            else{
                                component.set("v.showProceedBtn",true);          
                                
                            }    
                    }
                    
                    
                    
                    
                    component.set("v.bidNumber",bidRecord.Name);    
                    component.set("v.bidName",bidRecord.Phoenix_Bid_Name__c);
                    if( bidRecord.Phoenix_Bid_Type__c!=null && bidRecord.Phoenix_Bid_Type__c!=undefined){
                        component.set("v.BidTypeVal",bidRecord.Phoenix_Bid_Type__c);
                    }
                    else{
                        component.set('v.isSpinnerLoad',false);
                    }
                    
                    var OutDiv = component.find("mainDiv1");
                    if(rebatesListProposed==undefined){
                        $A.util.addClass(OutDiv,"noheightClass");
                    }
                    else if(rebatesListProposed.length<4){
                        $A.util.addClass(OutDiv,"noheightClass");
                        
                    }
                        else{
                            $A.util.removeClass(OutDiv,"noheightClass");
                            //  $A.util.addClass(OutDiv,"heightClass");
                        }
                }
                
            });
            $A.enqueueAction(action);
        }
        else{
            component.set("v.showErrorMessage",true);
            component.set("v.messageType",'No Account Selected.');
            component.set("v.errorMessage",'Please select a contact first before searching based on type.');
        }
    },
    deletePropRebate : function(component, event, helper){
        component.set('v.isSpinnerLoad',true);
                
        var customerId = component.get("v.selectedCustId");
        var bidId = component.get("v.bidId");
        var action = component.get("c.deleteProposedRebate");
        action.setParams({
            bidId : bidId,
            customerId : customerId
        });
        action.setCallback(this, function(response){
            if(response.getState()=="SUCCESS"){
                var storeResponse = response.getReturnValue();
                if(storeResponse.includes('ERROR')){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type":"Error",
                        "title": "Error",
                        "message": storeResponse
                    });
                    toastEvent.fire();
                }
                else{
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type":"success",
                        "title": "Success",
                        "message": "Record has been Deleted."
                    });
                    toastEvent.fire();
                    $A.get('e.force:refreshView').fire();
                }
                component.set('v.isSpinnerLoad',false);
            }
            else{
                var errors = response.getError();
                    console.log("Error message: -----------------------" +
                                errors[0].message);
            }
        });
        $A.enqueueAction(action);
    }
})