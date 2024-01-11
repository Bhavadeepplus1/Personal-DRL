({
    
    initRecords: function(component, event, helper) {
        component.find("Tabset").set("v.selectedTabId",'EBLI');   
        let pageReference = component.get("v.pageReference");
        let recordId = pageReference.state.c__recordId;
        component.set("v.recordId",recordId);
        component.set('v.recordId', component.get("v.pageReference").state.c__id);
        var action = component.get("c.getBid"); 
        
        action.setParams
        ({
            bidId: recordId
        });
        action.setCallback(this, function(response) 
                           {
                               if(response.getState()=="SUCCESS"){
                                   console.log('--------recordId------'+recordId);
                                   component.set("v.recordId",recordId);
                                   var wrapperObj =  response.getReturnValue();
                                   var bidRecord = wrapperObj.bidRecord;
                              component.set("v.accountName",wrapperObj.account.Name);   
                                   var approvalState=wrapperObj.approvalStatus;
                                   var account=wrapperObj.account;
                                   var loggedInUserId=wrapperObj.loggedInUserId;
                                   var isBusinessApprovePerson=wrapperObj.isBusinessApprovePerson;
                                   console.log('-------isBusinessApprovePerson-------'+isBusinessApprovePerson);
                                    console.log('-------loggedInUserId-------'+loggedInUserId);
                                   var isContractsApprovePerson=wrapperObj.isContractsApprovePerson;
                                   var conDocument=wrapperObj.conDocLink;
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
                                   component.set("v.approvalStatus",approvalState);
                                   if(approvalState!='Draft'){
                                       component.set("v.reviewDetailsHide",true);
                                   }
                                   else{
                                       component.set("v.reviewDetailsHide",false);
                                   }
                                   component.set("v.bidRecord",bidRecord);
                                   component.set("v.bidNumber",bidRecord.Name); 
                                   component.set("v.bidType",bidRecord.Phoenix_Bid_Type__c); 
                                   component.set("v.bidName",bidRecord.Phoenix_Bid_Name__c);
                                   component.set("v.reviewDetails",bidRecord.Phoenix_Review_Details__c);
                                   component.set("v.busStatus",bidRecord.Phoenix_Marketing_Head_Approval__c);
                                   component.set("v.busCom",bidRecord.Phoenix_Marketing_Head_Comments__c);
                                   component.set("v.contrStatus",bidRecord.Phoenix_Contracts_Approval__c);
                                   component.set("v.contrCom",bidRecord.Phoenix_Contracts_Approval_Comments__c);
                                   console.log('--------wrapperObj.account.Name-------'+wrapperObj.account.Name);
                                   component.set("v.accountId",account.Id);
                                   component.set("v.loggedInUserName",loggedInUserId);
                                   component.set("v.isBusinessApprovePerson",isBusinessApprovePerson);
                                   component.set("v.isContractsApprovePerson",isContractsApprovePerson);
                                   if(approvalState=='Marketing Head'){
                                       if(bidRecord.Phoenix_Marketing_Head_Approval__c==''){
                                           component.set("v.showProceedBtn",false);          
                                       }
                                       else if(bidRecord.Phoenix_Marketing_Head_Approval__c==undefined){
                                           component.set("v.showProceedBtn",false);          
                                       }
                                           else{
                                               component.set("v.showProceedBtn",true);          
                                               
                                           }     
                                       
                                   }
                                   
                                   
                                   if(approvalState=='Contracts'){ 
                                       if(bidRecord.Phoenix_Contracts_Approval__c==''){
                                           component.set("v.showProceedBtn",false);          
                                       }
                                       else if(bidRecord.Phoenix_Contracts_Approval__c==undefined){
                                           component.set("v.showProceedBtn",false);          
                                       }
                                           else{
                                               component.set("v.showProceedBtn",true);          
                                               
                                           }
                                   }
                                   
                               }
                               else{
                               }
                           });
        $A.enqueueAction(action);
        
    },
    backToBid : function(component, event, helper){
        let pageReference = component.get("v.pageReference");
        let recordId = pageReference.state.c__recordId;
        component.set("v.recordId",recordId);
        component.find("navService").navigate({
            type: "standard__recordPage",
            attributes: {
                recordId: component.get("v.recordId"),
                actionName: "view"
            }
        }, false);
        $A.get('e.force:refreshView').fire();
    }, 
    
    saveToProceedBusiness: function (component, event, helper) {
        let pageReference = component.get("v.pageReference");
        let recordId = pageReference.state.c__recordId;
        component.set("v.recordId",recordId);
        var finComm=component.find("businessComments").get("v.value");
        var finAppStatus=component.find("businessAppStatus").get("v.value");
        var approvalStatus=component.get("v.approvalStatus");
        console.log('--------finAppStatus-----'+finAppStatus);
        if(finAppStatus==null || finAppStatus==''){
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
                let pageReference = component.get("v.pageReference");
                let recordId = pageReference.state.c__recordId;
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
    saveToProceedContr: function (component, event, helper) {
        let pageReference = component.get("v.pageReference");
        let recordId = pageReference.state.c__recordId;
        component.set("v.recordId",recordId);
        var finComm=component.find("contrComments").get("v.value");
        var finAppStatus=component.find("contrAppStatus").get("v.value");
        var approvalStatus=component.get("v.approvalStatus");
        console.log('--------finAppStatus-----'+finAppStatus);
        if(finAppStatus==null || finAppStatus==''){
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
                    console.log('------contr success-------');
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
                let pageReference = component.get("v.pageReference");
                let recordId = pageReference.state.c__recordId;
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
    closeModal: function (component, event, helper) {
        /* if (recordId != null && recordId != undefined && recordId != '') {
            component.find("navigationService").navigate({
                type: "standard__recordPage",
                attributes: {
                    recordId: recordId,
                    actionName: "view"
                }
            }, false); 
        } */
        $A.get('e.force:refreshView').fire();
        
    },
    
    uploadDocument: function(component, event, helper) {
        let pageReference = component.get("v.pageReference");
        let recordId = pageReference.state.c__recordId;
        component.set("v.recordId",recordId);
    },  
    
    //-------This is used for manipulating the actions after file upload is done for the the Bid ------>
    
    handleUploadFinished: function (component, event, helper) {
        helper.handleUploadFinished(component, event);
    },
    
    //-------This is for rendering the Save & Cancel buttons------>
    closeTab: function(component, event, helper) {
        let pageReference = component.get("v.pageReference");
        let recordId = pageReference.state.c__recordId;
        component.set("v.recordId",recordId);
        component.find("navService").navigate({
            type: "standard__recordPage",
            attributes: {
                recordId: component.get("v.recordId"),
                actionName: "view"
            }
        }, false);
        $A.get('e.force:refreshView').fire();
    },
    showSaveCancel: function (component, event, helper) {
        var value= component.find("businessAppStatus");
        var value1= component.find("contrAppStatus");
        var value2= component.find("businessComments");
        var value3= component.find("contrComments");
        
        if(value!=undefined && component.find("businessAppStatus").get("v.value")!=''){
            component.set("v.showSaveCancelBtn",true); 
            component.set("v.showProceedBtn",false);
            
            
        }
        else  if(value1!=undefined && component.find("contrAppStatus").get("v.value")!=''){
            component.set("v.showSaveCancelBtn",true);  
            component.set("v.showProceedBtn",false);
            
            
        }
            else  if(value2!=undefined && component.find("businessComments").get("v.value")!=''){
                component.set("v.showSaveCancelBtn",true);
                component.set("v.showProceedBtn",false);
                
                
            }
                else  if(value3!=undefined && component.find("contrComments").get("v.value")!=''){
                    component.set("v.showSaveCancelBtn",true); 
                    component.set("v.showProceedBtn",false);
                    
                    
                }
                    else{
                        component.set("v.showSaveCancelBtn",false);  
                        
                    }
    },
    showSaveCancelDetails: function (component, event, helper) {
        component.set("v.showSaveCancelDetailsBtn",true);  
    },
    //-------This is for rendering the Proceed Button------>
    
    saveApprovalBus: function (component, event, helper) {
        let pageReference = component.get("v.pageReference");
        let recordId = pageReference.state.c__recordId;
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
    
    saveApprovalContr: function (component, event, helper) {
        let pageReference = component.get("v.pageReference");
        let recordId = pageReference.state.c__recordId;
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
    
    //-------This is used for  Business Head Approval----->
    
    saveToBidRec: function(component, event, helper) {
        let pageReference = component.get("v.pageReference");
        let recordId = pageReference.state.c__recordId;
        component.set("v.recordId",recordId);
        console.log('-----recordId-------'+component.get("v.recordId"));
        var pricingDetailsBid=component.find("pricingDetails").get("v.value");
        var action = component.get("c.saveToBid");
        
        action.setParams({
            'bidId': recordId,
            'pricingDetails':pricingDetailsBid
            
        });
        
        action.setCallback(this, function (response){
            if(response.getState() === "SUCCESS"){
                component.set("v.showSaveCancelDetailsBtn",false);  
                
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type":"success",
                    "title": "Success",
                    "message": "Record has been Updated successfully."
                });
                toastEvent.fire();
                
            }
            else{
                var errors = response.getError();
                console.log("Error message: -----------------------" +
                            errors[0].message);
            }
        });
        $A.enqueueAction(action);
    },
    
    deleteAttachment: function (component, event, helper) {
        let pageReference = component.get("v.pageReference");
        let recordId = pageReference.state.c__recordId;
        component.set("v.recordId",recordId);
        var selectedRec = event.getSource().get("v.name");
        console.log('selectedRec--->'+selectedRec);
        var target = event.target;
        var action = component.get("c.deleteAttachments");
        console.log('action--->');
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
        var event = component.getEvent("lightningEvent");
        event.setParam("message", "the message to send" );
        event.fire();
        
        var AllRowsList = component.get("v.fileList");
        if (AllRowsList.length === 1) {
            console.log('AllRowsList.length === 1');
        }
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
        
    }
})