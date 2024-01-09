({
    //------------This is to handle onload actions------------>
    
    
    doInit : function(component, event, helper){
		helper.getData(component, event, helper);
    },
    
    initRecords: function(component, event, helper) {
        component.find("Tabset").set("v.selectedTabId",'EBLI'); console.log('Init Records');
        component.set('v.isSpinnerLoad',true);
        let rebType = component.get("v.rebateType");
        //let pageReference = component.get("v.pageReference");
        //let recordId = pageReference.state.c__recordId;
        var recordId = component.get("v.c__recordId");
        component.set("v.recordId",recordId);
        //component.set('v.recordId', component.get("v.pageReference").state.c__id);
        var action = component.get("c.getRelatedList");  
        action.setParams
        ({
            bidId: recordId
        });
        action.setCallback(this, function(response) 
                           {
                               if(response.getState()=="SUCCESS"){
                                   component.set("v.recordId",recordId);
                                   
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
                                   var isBusinessApprovePerson=wrapperObj.isBusinessApprovePerson;
                                   var isFinanceApprovePerson=wrapperObj.isFinanceApprovePerson;
                                   var isContractsApprovePerson=wrapperObj.isContractsApprovePerson;
                                   var isCustomerApprovePerson=wrapperObj.isCustomerApprovePerson;
                                   var isVistexApprovePerson=wrapperObj.isVistexApprovePerson;
                                   //console.log('Current Tab Name--->'+component.find("currentTab").get('v.label'))
                                   //component.find("currentTab").set('v.label','VIP Rebate Change Test');
                                   
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
                                   component.set("v.isBusinessApprovePerson",isBusinessApprovePerson);
                                   component.set("v.isFinanceApprovePerson",isFinanceApprovePerson);
                                   component.set("v.isContractsApprovePerson",isContractsApprovePerson);
                                   component.set("v.isCustomerApprovePerson",isCustomerApprovePerson);
                                   component.set("v.isVistexApprovePerson",isVistexApprovePerson);
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
                                   component.set("v.typeRebate",type);
                                   component.set("v.checkBoxFieldCurrent",exclusions);
                                   component.set("v.excDetailsRebate",excDetails);
                                   component.set("v.strtDateRebatePro",startDatePro);
                                   component.set("v.endDateRebatePro",endDatePro);
                                   component.set("v.typeRebatePro",typePro);
                                   component.set("v.checkBoxField",exclusionsPro);
                                   component.set("v.excDetailsRebatePro",excDetailsPro);
                                   component.set("v.custName",customerName);
                                   var tabName =  'VIP Rebate Change'+'-'+customerName;
                                   console.log('tabName----'+tabName)
                                   //component.set("v.tabName",tabName);
                                   //component.find("currentTab").set("v.label",tabName);
                                   component.set("v.bidType",bidType);
                                   var rebate=typePro;
                                   component.set("v.rebateType",rebate);
                                   component.set("v.isRebTypeChanged",true);
                                   if(rebatesList!=undefined){
                                       component.set("v.bidRebateCurrentList",rebatesList);   
                                   }
                                   if(rebatesListProposed!=undefined){
                                       component.set("v.bidRebateProposedList",rebatesListProposed);
                                   }
                                   else{
                                       component.set("v.bidRebateProposedList",[]);
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
    }, 
    closeModal: function (component, event, helper) {
        
        $A.get('e.force:refreshView').fire();
        
    },
    
    //------------This is used for navigating to Bid detail page when click on Back button on the top ------------->
    
    backToBid : function(component, event, helper){
        //let pageReference = component.get("v.pageReference");
        //let recordId = pageReference.state.c__recordId;
        var recordId = component.get("v.c__recordId");
        component.set("v.recordId",recordId);
        component.find("navService").navigate({
            type: "standard__recordPage",
            attributes: {
                recordId: component.get("v.c__recordId"),
                actionName: "view"
            }
        }, false);
        $A.get('e.force:refreshView').fire();
    }, 
    
    //------------This is used to hold the type in header fields ------------->
    
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
    handleSaveOnChange: function(component, event, helper) {
        component.set("v.showSaveCancelBtn2",true);
    },
    handleAgreementChange:function(component, event, helper) {
        var agreementNo = component.get("v.agreementNo");
        console.log('Agreement No.: '+agreementNo);
        component.set("v.showSaveCancelBtn",true);
    },
    //------------This is used to track the checkbox in header fields ------------->
    
    onCheckExclusions: function(component, event, helper) {
        component.set("v.showSaveCancelBtn2",true);
        
    },
    
    //----This is used for copying the Current Rebate table rows into Proposed Rebate table --CURRENTLY IT IS ON HOLD---->
    
    /* copyCurrentRebateList: function(component, event, helper) {
            var rebateListCopy = component.get("v.bidRebateCurrentList");
            var rebateProposed=component.get('v.typeRebatePro');
            for (let i = 0; i < (rebateListCopy.length)-1; i++) {
                if(rebateListCopy[i+1].Phoenix_Unit_Volume_From__c!==undefined){
                    rebateListCopy[i].Phoenix_Unit_Volume_To__c=(rebateListCopy[i+1].Phoenix_Unit_Volume_From__c)-1;     
                }
                if(rebateListCopy[i+1].Phoenix_Dollar_Value_From__c!==undefined){
                    rebateListCopy[i].Phoenix_Dollar_Value_To__c=(rebateListCopy[i+1].Phoenix_Dollar_Value_From__c)-1;     
                }
            }
            rebateListCopy[(rebateListCopy.length)-1].Phoenix_Dollar_Value_To__c=null;
            rebateListCopy[(rebateListCopy.length)-1].Phoenix_Unit_Volume_To__c=null;
            var rebateListCopy1=rebateListCopy;
            component.set('v.bidRebateProposedList',rebateListCopy1);
            component.set('v.showCopyButton',false);
            component.set('v.showProposedSection',true);
            var OutDiv = component.find("mainDiv1");
            if(rebateListCopy1.length>3){
                $A.util.addClass(OutDiv, "heightClass");
            }else{
                $A.util.removeClass(OutDiv, "noheightClass");
            }
        },*/
    
    //-------This is used for adding new rows into Proposed Rebate table ---------->
    
    addNewProposedRebateRow: function(component, event, helper) {
        var validFromValue=  component.get("v.validFrom");
        console.log('validFromValue IN addNewProposedRebateRow --- '+validFromValue);
        if(validFromValue==false){
            var accountList = component.get("v.bidRebateProposedList2");
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
            
        }
        else{
            //
        }
    },
    
    //--------This is used for recalculation in Proposed Rebate table------->
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
    //-----This is used for handling Delete Event ----->
    handleEvent: function(component, event, helper) {
        var message = event.getParam("message");
        var fromWhichCmp = event.getParam("fromWhichCmp");
        if(fromWhichCmp == 'parentCmp'){
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
    
    //------This is used for saving Proposed Rebate rows into database ------>
    
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
            //let pageReference = component.get("v.pageReference");
            let recordId = component.get("v.c__recordId");//pageReference.state.c__recordId;
            
            component.set("v.recordId",recordId);
            var exclusion= component.get('v.checkBoxField'); 
            if(exclusion==undefined){
                exclusion=false;
            }
            if(component.find("excDetails").get("v.value")!=undefined){
                var excDetails= component.find("excDetails").get("v.value");     
            }
            if(component.find("headerRebateType234").get("v.value")!=undefined){
                var rebateType= component.find("headerRebateType234").get("v.value");    
            }
            else{
                var rebateType= 'Currency';    
                
            }
            if(component.find("endDate").get("v.value")!=''){
                var endDateRebate= component.find("endDate").get("v.value");     
            }
            var StDate=component.get("v.strtDateRebate");
            if(component.find("startDate").get("v.value")!='' ){
                var strtDate= component.find("startDate").get("v.value");
            }
            var rebateListCopy = component.get("v.bidRebateProposedList2");
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
                                var canProceedToSave = true;
                                var selectedTabId = component.find("Tabset").get('v.selectedTabId');
                                if(selectedTabId == 'newVipRebate'){
                                    customerId = component.get("v.customerLkp");
                                    if(customerId != null || customerId != undefined){
                                        var action = component.get("c.saveLineItemsInTab");
                                    	console.log('Agreement No.: '+component.get("v.agreementNo"));   
                                    }
                                    else
                                        canProceedToSave = false;
                                }
                                else
                                    var action = component.get("c.saveLineItems");
                                console.log('Agreement No.: '+component.get("v.agreementNo"));
                                if(canProceedToSave){
                                    action.setParams({
                                        'LineItemList': component.get("v.bidRebateProposedList2"),
                                        'recId': component.get("v.c__recordId"),
                                        'excsnDetails':excDetails,
                                        'stDate':strtDate,
                                        'endDate':endDateRebate,
                                        'exclusions':exclusion,
                                        'rebType':rebateType,
                                        'customerId':customerId,
                                        'paymentFrequency': component.get("v.proposedPaymentFrequency"),
                                        'netGross': component.get("v.proposedNetGross"),
                                        'division': component.get("v.division"),
                                        'vistexAgreementNo': component.get("v.agreementNo")
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
                                            console.log('ok');
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
                                                console.log("Exception: "+JSON.stringify(response.getError()));
                                            var errors = response.getError();
                                            if (errors) {
                                                if (errors[0] && errors[0].message) {
                                                    console.log("Error message: -----------------------" +
                                                                errors[0].message);
                                                }
                                            }
                                        } 
                                            else{
                                                component.set("v.showSaveCancelBtn",false);
                                                component.set('v.isSpinnerLoad',false);
                                            }
                                    });
                                    $A.enqueueAction(action);     
                                }
                                else{
                                    var toastEvent = $A.get("e.force:showToast");
                                    toastEvent.setParams({
                                        message:'Please select a Customer under Current Rebate section to verify before saving proposed rebate.',
                                        duration:' 8000',
                                        key: 'info_alt',
                                        type: 'error',
                                        mode: 'dismissible'
                                    });
                                    toastEvent.fire();    
                                }
                            }
                        }
                    }
        }
    },
    
    //-----This is used for canceling the actions and redirect to the Bid detail page------>
    
    closeTab: function(component, event, helper) {
        //let pageReference = component.get("v.pageReference");
        let recordId = component.get("v.c__recordId");//pageReference.state.c__recordId;
        component.set("v.recordId",recordId);
        component.find("navService").navigate({
            type: "standard__recordPage",
            attributes: {
                recordId: component.get("v.c__recordId"),
                actionName: "view"
            }
        }, false);
        $A.get('e.force:refreshView').fire();
    },
    
    //-------This is used for upload documents for the Bid ------>
    
    uploadDocument: function(component, event, helper) {
        //let pageReference = component.get("v.pageReference");
        let recordId = component.get("v.c__recordId");//pageReference.state.c__recordId;
        component.set("v.recordId",recordId);
    },  
    
    //-------This is used for manipulating the actions after file upload is done for the the Bid ------>
    
    handleUploadFinished: function (component, event, helper) {
        helper.handleUploadFinished(component, event);
    },
    
    //-------This is for rendering the Save & Cancel buttons------>
    
    showSaveCancel: function (component, event, helper) {
        var bus= component.find("businessAppStatus");
        var fin= component.find("financeAppStatus");
        var contr= component.find("contrAppStatus");
        var cust= component.find("custAppStatus");
        var vist= component.find("vistAppStatus");
        var busCom= component.find("businessComments");
        var finCom= component.find("financeComments");
        var contrCom= component.find("contrComments");
        var custCom= component.find("custComments");
        var vistCom= component.find("vistComments");
        
        if(bus!=undefined && component.find("businessAppStatus").get("v.value")!='--None--'){
            component.set("v.showSaveCancelBtn",true); 
            component.set("v.showProceedBtn",false);
            
        }
        else if(fin!=undefined && component.find("financeAppStatus").get("v.value")!='--None--'){
            component.set("v.showSaveCancelBtn",true);  
            component.set("v.showProceedBtn",false);
            
        }
            else if(contr!=undefined && component.find("contrAppStatus").get("v.value")!='--None--'){
                component.set("v.showSaveCancelBtn",true);  
            }
                else if(cust!=undefined && component.find("custAppStatus").get("v.value")!='--None--'){
                    component.set("v.showSaveCancelBtn",true); 
                    component.set("v.showProceedBtn",false);
                    
                }
                    else if(vist!=undefined && component.find("vistAppStatus").get("v.value")!='--None--'){
                        component.set("v.showSaveCancelBtn",true); 
                        component.set("v.showProceedBtn",false);
                        
                    }
        
                        else if(busCom!=undefined && component.find("businessComments").get("v.value")!=''){
                            component.set("v.showSaveCancelBtn",true); 
                            component.set("v.showProceedBtn",false);
                            
                        }
                            else if(finCom!=undefined && component.find("financeComments").get("v.value")!=''){
                                component.set("v.showSaveCancelBtn",true); 
                                component.set("v.showProceedBtn",false);
                                
                            }
                                else if(contrCom!=undefined && component.find("contrComments").get("v.value")!=''){
                                    component.set("v.showSaveCancelBtn",true); 
                                    component.set("v.showProceedBtn",false);
                                    
                                }
                                    else if(custCom!=undefined && component.find("custComments").get("v.value")!=''){
                                        component.set("v.showSaveCancelBtn",true);
                                        component.set("v.showProceedBtn",false);
                                        
                                    }
                                        else if(vistCom!=undefined && component.find("vistComments").get("v.value")!=''){
                                            component.set("v.showSaveCancelBtn",true); 
                                            component.set("v.showProceedBtn",false);
                                            
                                        }
                                            else{
                                                component.set("v.showSaveCancelBtn",false);
                                                
                                            } 
    },
    
    //-------This is for rendering the Proceed Button------>
    
    saveApprovalBus: function (component, event, helper) {
        //let pageReference = component.get("v.pageReference");
        let recordId = component.get("v.c__recordId");//pageReference.state.c__recordId;
        component.set("v.recordId",recordId);
        var value= component.find("businessAppStatus");
        var value2= component.find("businessComments");
        if(value!=undefined){
            var busStatus=component.find("businessAppStatus").get("v.value");
        }
        if(value2!=undefined){
            var busCom=component.find("businessComments").get("v.value");
        }
        var action = component.get("c.saveToBidBus");
        action.setParams({
            'bidId': recordId,
            'busStatus':busStatus,
            'busCom':busCom
            
        });
        action.setCallback(this, function (response){
            if(response.getState() === "SUCCESS"){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type":"success",
                    "title": "Success",
                    "message": "Record has been Updated successfully."
                });
                toastEvent.fire();
                component.set("v.showProceedBtn",true);
                component.set("v.showSaveCancelBtn",false);
            }
            else{
                var errors = response.getError();
                console.log("Error message: -----------------------" +
                            errors[0].message);
            }
        });
        $A.enqueueAction(action);
    },
    
    
    saveApprovalFin: function (component, event, helper) {
        //let pageReference = component.get("v.pageReference");
        let recordId = component.get("v.c__recordId");//pageReference.state.c__recordId;
        component.set("v.recordId",recordId);
        var value= component.find("financeAppStatus");
        var value2= component.find("financeComments");
        if(value!=undefined){
            var finStatus=component.find("financeAppStatus").get("v.value");
        }
        if(value2!=undefined){
            var finCom=component.find("financeComments").get("v.value");
        }
        var action = component.get("c.saveToBidFin");
        action.setParams({
            'bidId': recordId,
            'finStatus':finStatus,
            'finCom':finCom
            
        });
        action.setCallback(this, function (response){
            if(response.getState() === "SUCCESS"){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type":"success",
                    "title": "Success",
                    "message": "Record has been Updated successfully."
                });
                toastEvent.fire();
                component.set("v.showProceedBtn",true);
                component.set("v.showSaveCancelBtn",false);
            }
            else{
                var errors = response.getError();
                console.log("Error message: -----------------------" +
                            errors[0].message);
            }
        });
        $A.enqueueAction(action);
    },
    saveApprovalContr: function (component, event, helper) {
        //let pageReference = component.get("v.pageReference");
        let recordId = component.get("v.c__recordId");//pageReference.state.c__recordId;
        component.set("v.recordId",recordId);
        var value= component.find("contrAppStatus");
        var value2= component.find("contrComments");
        if(value!=undefined){
            var contrStatus=component.find("contrAppStatus").get("v.value");
        }
        if(value2!=undefined){
            var contrCom=component.find("contrComments").get("v.value");
        }
        var action = component.get("c.saveToBidContr");
        action.setParams({
            'bidId': recordId,
            'contrStatus':contrStatus,
            'contrCom':contrCom
            
        });
        action.setCallback(this, function (response){
            if(response.getState() === "SUCCESS"){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type":"success",
                    "title": "Success",
                    "message": "Record has been Updated successfully."
                });
                toastEvent.fire();
                component.set("v.showProceedBtn",true);
                component.set("v.showSaveCancelBtn",false);
            }
            else{
                var errors = response.getError();
                console.log("Error message: -----------------------" +
                            errors[0].message);
            }
        });
        $A.enqueueAction(action);
    },
    
    saveApprovalCust: function (component, event, helper) {
        //let pageReference = component.get("v.pageReference");
        let recordId = component.get("v.c__recordId");//pageReference.state.c__recordId;
        component.set("v.recordId",recordId);
        var value= component.find("custAppStatus");
        var value2= component.find("custComments");
        if(value!=undefined){
            var custStatus=component.find("custAppStatus").get("v.value");
        }
        if(value2!=undefined){
            var custCom=component.find("custComments").get("v.value");
        }
        var action = component.get("c.saveToBidCust");
        action.setParams({
            'bidId': recordId,
            'custStatus':custStatus,
            'custCom':custCom
            
        });
        action.setCallback(this, function (response){
            if(response.getState() === "SUCCESS"){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type":"success",
                    "title": "Success",
                    "message": "Record has been Updated successfully."
                });
                toastEvent.fire();
                component.set("v.showProceedBtn",true);
                component.set("v.showSaveCancelBtn",false);
            }
            else{
                var errors = response.getError();
                console.log("Error message: -----------------------" +
                            errors[0].message);
            }
        });
        $A.enqueueAction(action);
    },
    
    
    
    saveApprovalVist: function (component, event, helper) {
        //let pageReference = component.get("v.pageReference");
        let recordId = component.get("v.c__recordId");//pageReference.state.c__recordId;
        component.set("v.recordId",recordId);
        var value= component.find("vistAppStatus");
        var value2= component.find("vistComments");
        if(value!=undefined){
            var vistStatus=component.find("vistAppStatus").get("v.value");
        }
        if(value2!=undefined){
            var vistCom=component.find("vistComments").get("v.value");
        }
        var action = component.get("c.saveToBidVist");
        console.log('Proposed Rebate Id: '+component.get("v.proposedRec"));
        action.setParams({
            'bidId': recordId,
            'vistStatus':vistStatus,
            'vistCom':vistCom,
            'recordId': component.get("v.proposedRec"),
            'agreementNo': component.get("v.agreementNo"),
            
        });
        action.setCallback(this, function (response){
            if(response.getState() === "SUCCESS"){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type":"success",
                    "title": "Success",
                    "message": "Record has been Updated successfully."
                });
                toastEvent.fire();
                component.set("v.showProceedBtn",true);
                component.set("v.showSaveCancelBtn",false);
            }
            else{
                var errors = response.getError();
                console.log("Error message: -----------------------" +
                            errors[0].message);
            }
        });
        $A.enqueueAction(action);
    },
    
    //-------This is used for  Business Head Approval----->
    
    saveToProceedBusiness: function (component, event, helper) {
        
        //let pageReference = component.get("v.pageReference");
        let recordId = component.get("v.c__recordId");//pageReference.state.c__recordId;
        component.set("v.recordId",recordId);
        var finComm=component.find("businessComments").get("v.value");
        var finAppStatus=component.find("businessAppStatus").get("v.value");
        var approvalStatus=component.get("v.approvalStatus");
        console.log('--------finAppStatus---------'+finAppStatus);
        if(finAppStatus==null || finAppStatus=='--None--'){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                message:'Please select a valid Approval Status to proceed further',
                duration:' 8000',
                key: 'info_alt',
                type: 'error',
                mode: 'dismissible'
            });
            toastEvent.fire();      
        }
        else{
            var action = component.get("c.makeApprovalsBusiness");
            action.setParams({
                'bidId' : component.get("v.recordId"),
                'finaceCom':finComm,
                'financeAppStatus':finAppStatus,
                'approvStatus':approvalStatus
            });
            action.setCallback(this, function (response){
                if(response.getState() === "SUCCESS"){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type":"success",
                        "title": "Success",
                        "message": "Your Approvals are submitted successfully."
                    });
                    toastEvent.fire();
                    
                }
                else{
                    var errors = response.getError();
                    console.log("Error message: -----------------------" +
                                errors[0].message);
                }
                //let pageReference = component.get("v.pageReference");
                let recordId = component.get("v.c__recordId");//pageReference.state.c__recordId;
                component.set("v.recordId",recordId);
                component.find("navService").navigate({
                    type: "standard__recordPage",
                    attributes: {
                        recordId: component.get("v.recordId"),
                        actionName: "view"
                    }
                }, false);
                $A.get('e.force:refreshView').fire();  
            });
            $A.enqueueAction(action);     
            
        }
    },
    
    //-------This is used for  Finance Approval----->
    
    saveToProceedFinance: function (component, event, helper) {
        
        //let pageReference = component.get("v.pageReference");
        let recordId = component.get("v.c__recordId");//pageReference.state.c__recordId;
        component.set("v.recordId",recordId);
        var finance=component.get("v.isFinanceApprovePerson");
        var finComm=component.find("financeComments").get("v.value");
        var finAppStatus=component.find("financeAppStatus").get("v.value");
        var approvalStatus=component.get("v.approvalStatus");
        if(finAppStatus==null || finAppStatus=='--None--'){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                message:'Please select a valid Approval Status to proceed further',
                duration:' 8000',
                key: 'info_alt',
                type: 'error',
                mode: 'dismissible'
            });
            toastEvent.fire();      
        }
        else{
            var action = component.get("c.makeApprovalsFinance");
            action.setParams({
                'bidId' : component.get("v.recordId"),
                'finaceCom':finComm,
                'financeAppStatus':finAppStatus,
                'approvStatus':approvalStatus
            });
            action.setCallback(this, function (response){
                if(response.getState() === "SUCCESS"){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type":"success",
                        "title": "Success",
                        "message": "Your Approvals are submitted successfully."
                    });
                    toastEvent.fire();
                    
                }
                else{
                    var errors = response.getError();
                    console.log("Error message: -----------------------" +
                                errors[0].message);
                }
                //let pageReference = component.get("v.pageReference");
                let recordId = component.get("v.c__recordId");//pageReference.state.c__recordId;
                component.set("v.recordId",recordId);
                component.find("navService").navigate({
                    type: "standard__recordPage",
                    attributes: {
                        recordId: component.get("v.recordId"),
                        actionName: "view"
                    }
                }, false);
                $A.get('e.force:refreshView').fire();
            });
            $A.enqueueAction(action);     
        }
    },
    
    //-------This is used for  Contracts Approval----->
    
    saveToProceedCont: function (component, event, helper) {
        //let pageReference = component.get("v.pageReference");
        let recordId = component.get("v.c__recordId");//pageReference.state.c__recordId;
        component.set("v.recordId",recordId);
        var contr=component.get("v.isContractsApprovePerson");
        var finComm=component.find("contrComments").get("v.value");
        var finAppStatus=component.find("contrAppStatus").get("v.value");
        var approvalStatus=component.get("v.approvalStatus");
        if(finAppStatus==null || finAppStatus=='--None--'){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                message:'Please select a valid Approval Status to proceed further',
                duration:' 8000',
                key: 'info_alt',
                type: 'error',
                mode: 'dismissible'
            });
            toastEvent.fire();      
        }
        else{
            var action = component.get("c.makeApprovalsContracts");
            action.setParams({
                'bidId' : component.get("v.recordId"),
                'finaceCom':finComm,
                'financeAppStatus':finAppStatus,
                'approvStatus':approvalStatus
            });
            action.setCallback(this, function (response){
                if(response.getState() === "SUCCESS"){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type":"success",
                        "title": "Success",
                        "message": "Your Approvals are submitted successfully."
                    });
                    toastEvent.fire();
                    
                }
                else{
                    var errors = response.getError();
                    console.log("Error message: -----------------------" +
                                errors[0].message);
                }
                //let pageReference = component.get("v.pageReference");
                let recordId = component.get("v.c__recordId");//pageReference.state.c__recordId;
                component.set("v.recordId",recordId);
                component.find("navService").navigate({
                    type: "standard__recordPage",
                    attributes: {
                        recordId: component.get("v.recordId"),
                        actionName: "view"
                    }
                }, false);
                $A.get('e.force:refreshView').fire();
            });
            $A.enqueueAction(action);
            
            
        }
        
    },
    
    //-------This is used for  Customer Approval----->
    
    saveToProceedCust: function (component, event, helper) {
        //let pageReference = component.get("v.pageReference");
        let recordId = component.get("v.c__recordId");//pageReference.state.c__recordId;
        component.set("v.recordId",recordId);
        var finComm=component.find("custComments").get("v.value");
        var finAppStatus=component.find("custAppStatus").get("v.value");
        var approvalStatus=component.get("v.approvalStatus");
        if(finAppStatus==null || finAppStatus=='--None--'){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                message:'Please select a valid Approval Status to proceed further',
                duration:' 8000',
                key: 'info_alt',
                type: 'error',
                mode: 'dismissible'
            });
            toastEvent.fire();      
        }
        else{
            var action = component.get("c.makeApprovalsCustomer");
            action.setParams({
                'bidId' : component.get("v.recordId"),
                'finaceCom':finComm,
                'financeAppStatus':finAppStatus,
                'approvStatus':approvalStatus
            });
            action.setCallback(this, function (response){
                if(response.getState() === "SUCCESS"){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type":"success",
                        "title": "Success",
                        "message": "Your Approvals are submitted successfully."
                    });
                    toastEvent.fire();
                    
                }
                else{
                    var errors = response.getError();
                    console.log("Error message: -----------------------" +
                                errors[0].message);
                }
                //let pageReference = component.get("v.pageReference");
                let recordId = component.get("v.c__recordId");//pageReference.state.c__recordId;
                component.set("v.recordId",recordId);
                component.find("navService").navigate({
                    type: "standard__recordPage",
                    attributes: {
                        recordId: component.get("v.recordId"),
                        actionName: "view"
                    }
                }, false);
                $A.get('e.force:refreshView').fire();
            });
            $A.enqueueAction(action);     
            
        }
    },
    
    //-------This is used for  Vistex Update----->
    
    saveToProceedVist: function (component, event, helper) {
        //let pageReference = component.get("v.pageReference");
        let recordId = component.get("v.c__recordId");//pageReference.state.c__recordId;
        var finComm=component.find("vistComments").get("v.value");
        var finAppStatus=component.find("vistAppStatus").get("v.value");
        var approvalStatus=component.get("v.approvalStatus");
        console.log('finComm ::  '+finComm);
        console.log('finAppStatus :: '+finAppStatus);
        console.log('approvalStatus :: '+approvalStatus);
        console.log('recordId :: '+recordId);
        if(finAppStatus==null || finAppStatus=='--None--'){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                message:'Please select a valid Approval Status to proceed further',
                duration:' 8000',
                key: 'info_alt',
                type: 'error',
                mode: 'dismissible'
            });
            toastEvent.fire();      
        }
        else{
            var action = component.get("c.makeApprovalsVistex");
            action.setParams({
                'bidId' : component.get("v.c__recordId"),
                'finaceCom':finComm,
                'financeAppStatus':finAppStatus,
                'approvStatus':approvalStatus
            });
            action.setCallback(this, function (response){
                if(response.getState() === "SUCCESS"){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type":"success",
                        "title": "Success",
                        "message": "Your Approvals are submitted successfully."
                    });
                    toastEvent.fire();
                    $A.get('e.force:refreshView').fire();
                    component.find("navService").navigate({
                        type: "standard__recordPage",
                        attributes: {
                            recordId: component.get("v.recordId"),
                            actionName: "view"
                        }
                    }, false);
                }
                else{
                    var errors = response.getError();
                    console.log("Error message: -----------------------" +
                                errors[0].message);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type":"ERROR",
                        "title": "Error",
                        "message": errors[0].message
                    });
                    toastEvent.fire();
                }
            });
            $A.enqueueAction(action);
            
        }
        
    },
    
    deleteAttachment: function (component, event, helper) {
        //let pageReference = component.get("v.pageReference");
        let recordId = component.get("v.c__recordId");//pageReference.state.c__recordId;
        component.set("v.recordId",recordId);
        var selectedRec = event.getSource().get("v.name");
        var target = event.target;
        var action = component.get("c.deleteAttachments");
        action.setParams({
            'LineItemId' :selectedRec,
            'bidId':recordId
        });
        action.setCallback(this,function(response) {
            var state = response.getState();
            if(state=='SUCCESS'){
            }
            
        });
        $A.enqueueAction(action);
        var event = component.getEvent("lightningEvent1");
        event.setParam("message", "the message to send" );
        event.fire();
        
        var AllRowsList = component.get("v.fileList");
        for (let i = 0; i < AllRowsList.length; i++) {
            var pItem = AllRowsList[i];
            if (pItem.Id == selectedRec) {
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
    
    downloadCsvCurrent : function(component,event,helper){    
        
        var ResultData = component.get("v.bidRebateCurrentList");
        var ResultName1='currentRebate';
        // var template=component.get("v.templateType");
        // var title=component.get("v.title");
        //   var est=component.get("v.recordId");
        // console.log("est---->"+est);
        // call the helper function which "return" the CSV data as a String   
        var csv = helper.convertArrayOfObjectsToCSV(component,ResultData,ResultName1);   
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
        hiddenElement.download = 'Current Rebate'+'-'+Now+'.csv';  // CSV file Name* you can change it.[only name not .csv] 
        document.body.appendChild(hiddenElement); // Required for FireFox browser
        hiddenElement.click(); // using click() js function to download csv file
    },
    downloadCsv: function (component, event, helper) {
        var vipRebate = component.get("v.vipRebate");
        if(vipRebate == undefined){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type":"ERROR",
                "title": "ERROR",
                "message": "Vip Rebate record not found to export."
            });
            toastEvent.fire();
            return;
        }
        var ResultName2 = component.get("v.bidRebateProposedList2");  
        var resultData1 = vipRebate.vipRebateLines;
        
        if((resultData1 == undefined || resultData1.length == 0) && (ResultName2 == undefined || ResultName2.length == 0)){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type":"ERROR",
                "title": "ERROR",
                "message": "There are no Current or Proposed VIP rebate lines to download."
            });
            toastEvent.fire();
            return;
        }
        
        
        var csv1 = helper.convertArrayOfObjectsToCSV(component, resultData1,ResultName2);
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
    
    removeTab : function(component, event, helper){
        var wrapList = component.get("v.wrapList");
        var wrapListSize = wrapList.length;
        console.log('wrapListSize :: -- '+wrapListSize);
        wrapList.splice((wrapListSize-1), 1);
        component.set("v.wrapList",wrapList);
        component.find("Tabset").set('v.selectedTabId','0');
        $A.get('e.force:refreshView').fire();
    },
    
    addTab: function(component, event) {
        console.log(' :::INSIDE ADD TAB METHOD::: ');
        var tabsList = component.get("v.moretabs");
        console.log('tabsList.length :: '+tabsList.length);
        if(tabsList.length>0){
            var tab = event.getSource();
            var tabNum = component.get("v.tabNum"); 
            var cuurentTab = 'new'+tabNum;
            component.find("Tabset").set('v.selectedTabId',cuurentTab);
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "type":"error",
                "message":'Please save the current rebate first before adding more VIP rebates.'
            });
            toastEvent.fire();
            
            return;
        }
        else{
            var tab = event.getSource();
            var tabNum = component.get("v.tabNum"); 
            var cuurentTab = 'new'+ (++tabNum);
            component.find("Tabset").set('v.selectedTabId',cuurentTab);
            
            $A.createComponent("lightning:tab", {
                "label": "New VIP Rebate",
                "id": cuurentTab,
                "onactive": component.getReference("c.addContent")
            }, function (newTab, status, error) {
                if (status === "SUCCESS") {
                    var body = component.get("v.moretabs");
                    tabsList.push(newTab);
                    component.set("v.moretabs", tabsList);
                    component.set("v.tabNum", tabNum);
                } else {
                    throw new Error(error);
                }
            });
        }
    },
    addContent : function(component, event) {
        var tabNum = component.get("v.tabNum"); 
        var tab = event.getSource();
        console.log('current Tab Id-->'+component.find("Tabset").get('v.selectedTabId'))
        console.log('tab Id--------'+tab.get('v.id')); 
        console.log('ui----Id--'+component.get("v.tabId"));
        switch (tab.get('v.id')){
                
                
            case 'new'+(tabNum):
                // Display a badge in the tab content.
                // You can replace lightning:badge with a custom component.
                $A.createComponent("c:AddVipRebate", {
                    "bidId":component.get("v.c__recordId"),
                    "customerIdList":component.get("v.customerIdList"),
                    "vipRebate":component.get("v.vipRebate")
                }, function (newContent, status, error) {
                    if (status === "SUCCESS") {
                        tab.set('v.body', newContent);
                    } else {
                        throw new Error(error);
                    }
                });
                break;
                
                
        }
    },
    closeTabSet : function(component, event, helper){
        var result = component.get("v.tabId");
        component.find(result).closeTab(result);
    },
    handleClick: function(component) {
        var tab = event.getSource();
        component.set("v.tabId",+tab.get('v.id'));
    },
    handleChange : function(component) {
        var canCloseTab = component.get("v.canCloseTab");
        console.log('canCloseTab value in handle change :: --- '+canCloseTab);
        if(!canCloseTab){
            component.set("v.showConfirmToChangeTab",true);
            component.set("v.leavingTabMessage",'');
        }
        else{
            console.log('Changed Tab:: Inside canCloseTab is true')
        }
    },
   /* handleTabChangeEvent : function(component, event){
        var canCloseTab = event.getParam("canCloseTab");
        var vipRebate = event.getParam("vipRebate");
        console.log('canCloseTab in handleTabChangeEvent : --- '+canCloseTab);
        var customerLkp = event.getParam("customerLkp");
        console.log('customerLkp ID in handleTabChangeEvent : --- '+customerLkp);
        var excDetails = event.getParam("excDetails");
        var headerRebateType234 = event.getParam("headerRebateType234");
        var endDate = event.getParam("endDate");
        var startDate = event.getParam("startDate");
        if(event.getParam("bidRebateProposedList2") != undefined){
            var bidRebateProposedList2 = event.getParam("bidRebateProposedList2");
            component.set("v.bidRebateProposedList2",bidRebateProposedList2);
            console.log("bidRebateProposedList2.size() :: "+bidRebateProposedList2.length);
        }
        component.set("v.canCloseTab",canCloseTab);
        component.set("v.vipRebate",vipRebate);
        component.set("v.customerLkp",customerLkp);
        component.set("v.excDetails",excDetails);
        component.set("v.headerRebateType234",headerRebateType234);
        component.set("v.endDate",endDate);
        component.set("v.startDate",startDate);
        
    },
    stayInTab :  function(component) {
        component.find("Tabset").set('v.selectedTabId','new1');
        var appEvent = $A.get("e.c:PassVIPObjectEvent");               
        appEvent.setParams({"vipRebate":component.get("v.vipRebate")});   
        appEvent.setParams({"customerLkp":component.get("v.customerLkp")});  
        appEvent.setParams({"excDetails":component.get("v.excDetails")}); 
        if(component.get("v.headerRebateType234") != undefined)
            appEvent.setParams({"headerRebateType234":component.get("v.headerRebateType234")});  
        appEvent.setParams({"endDate":component.get("v.endDate")});  
        appEvent.setParams({"startDate":component.get("v.startDate")}); 
        if(component.get("v.bidRebateProposedList2") != undefined)
            appEvent.setParams({"bidRebateProposedList2":component.get("v.bidRebateProposedList2")}); 
        
        appEvent.fire(); 
        component.set("v.showConfirmToChangeTab",false);
        component.set("v.canCloseTab",false);
    },
    leaveTab : function(component) {
        console.log('inside handle change of tabs :: tabId -- '+component.get("v.tabId"));
        component.set("v.showConfirmToChangeTab",false);
        var selected = component.get("v.tabId");
        component.set("v.selectedTabId", selected);
        component.set("v.showConfirmToChangeTab",false);
        component.set("v.canCloseTab",true);
    },
        */
    newTabAdded : function(component, event, helper){
        var errorExist = false;
        var recordId = component.get("v.c__recordId");
        var action = component.get("c.checkForProposedRebate");
        action.setParams({
            bidId : recordId
        });
        action.setCallback(this, function(response){
            if(response.getState()=="SUCCESS"){
                var result = response.getReturnValue();
                if(result<=0){
                    errorExist = true;
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "type":"error",
                        "message":'Please fill the Proposed Rebate units before a creating new VIP rebate.'
                    });
                    toastEvent.fire();
                }
                if(!errorExist){
                    var wrapList = component.get("v.wrapList");
                    wrapList.forEach(function(wrapObj){
                        if(!wrapObj.existingVIPrebate){
                            errorExist = true;
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                "title": "Error!",
                                "type":"error",
                                "message":'Please create VIP rebate under "New VIP Rebate" tab before creating another.'
                            });
                            toastEvent.fire();
                            return;
                        }
                    });
                    if(!errorExist){
                        var wrapObj = new Object();
                        wrapObj.existingVIPrebate = false;
                        wrapList.push(wrapObj);
                        component.set("v.wrapList",wrapList);
                        component.set("v.typeRebate",'Currency');
                        component.find("Tabset").set('v.selectedTabId','newVipRebate');
                    }
                    else{
                        component.find("Tabset").set('v.selectedTabId','newVipRebate');
                    }
                }
                else{
                    console.log(' :: settings first tab as default :: ');
                    component.find("Tabset").set('v.selectedTabId',0);
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    customerChangedCheckCurrent : function(component, event, helper){
        
    },
    
    getCustomerVIP: function(component, event, helper){
        var errorMessage = '';
        var isCustExists = false;
        var customerId = component.get("v.customerLkp");
        console.log('selected contact Id :: '+customerId);
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
            if(customerId != null && customerId != ''){
                var action = component.get("c.getCustomerVIPRebate");
                action.setParams({
                    customerId : customerId
                });
                action.setCallback(this, function(response) 
                                   {
                                       if(response.getState()=="SUCCESS"){
                                           var result = response.getReturnValue();
                                           component.set("v.vipRebate",result);
                                           console.log('Rebate: '+JSON.stringify(result));
                                           if(result.vipRebateList != undefined){
                                               component.set("v.typeRebate",result.vipRebateList.Phoenix_Type__c);
                                               component.set("v.netGross",result.vipRebateList.Net_Contract__c);
                                               component.set("v.paymentFrequency",result.vipRebateList.Payment_Frequency__c);
                                               if(result.vipRebateList.Rx_SRx_OTC__c != undefined && result.vipRebateList.Rx_SRx_OTC__c != null){
                                                	component.set("v.division",result.vipRebateList.Rx_SRx_OTC__c);   
                                               }
                                           }
                                           else
                                               component.set("v.typeRebate",'Currency');
                                           component.set('v.showSearchResult',true);
                                       }
                                       
                                   });
                $A.enqueueAction(action);
            }
            else
                component.set('v.showSearchResult',false);
        }
    },
    pullChangedTyeRecord : function(component, event, helper){
        console.log('inside pullChangedTyeRecord');
        var customerId = component.get("v.customerLkp");
        var recordId = component.get("v.c__recordId");
        var selectedType = component.get("v.typeRebate");
        console.log(' bid recordId :: '+recordId);
        if(customerId != null && customerId != undefined){
            console.log('inside customerId');
            //var action = component.get("c.getCustomerVIP");
            
            var action = component.get("c.getCustomerVIPRebateByType");
            action.setParams({
                selectedType : selectedType,
                bidId : recordId,
                customerId : customerId
            });
            action.setCallback(this, function(response){
                console.log('response.getState() :: '+response.getState());
                if(response.getState()=="SUCCESS"){
                    var result = response.getReturnValue();
                    component.set("v.vipRebate",result);
                    if(result.vipRebateList != undefined)
                        component.set("v.typeRebate",result.vipRebateList.Phoenix_Type__c);
                    else
                        component.set("v.typeRebate",selectedType);
                    component.set('v.showSearchResult',true);
                }
            });
            $A.enqueueAction(action);
        }
        else{
            component.set("v.showErrorMessage",true);
            component.set("v.messageType",'No Account Selected');
            component.set("v.errorMessage",'Please select an Account first before searching based on type.');
        }
    },
    closeMessage : function(component, event, helper){
        component.set("v.showErrorMessage",false);
        component.set("v.messageType",'');
        component.set("v.errorMessage",'');
    },
    
})