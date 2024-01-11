({
    doInit : function(component, event, helper)
    {
        var currentrecID=component.find('recordid').get("v.value");
        //var changevalue=component.find("ChecklistType").get("v.value");
        //alert(component.find("ChecklistType").get("v.value"))
        
        // calling server side action 
        var Getcondata = component.get("c.checkListRec");
        Getcondata.setParams({
            checklistid : currentrecID
        });
        Getcondata.setCallback(this, function(response){
            
            var getstate=response.getState();
            if(getstate == 'SUCCESS')
            {
                
                if(response.getReturnValue().bidRecord!=undefined){
                 if(response.getReturnValue().bidRecord.Phoenix_Is_Checklist_Exist__c==true){
                    component.set("v.isChecklistExists",true); 
                    var getres = response.getReturnValue().checklist.Checklist_Type__c;
                    component.set("v.bid",response.getReturnValue().checklist.Bid__c);
                    component.set("v.recordId1",response.getReturnValue().checklist.Id);
                    
                    var conDocument=response.getReturnValue().conDocLink;
                    component.set("v.approvalStatus",response.getReturnValue().approvalStatus);
                    var loggedInUserId=response.getReturnValue().loggedInUserId;
                    component.set("v.loggedInUserName",loggedInUserId);
                    var isBusinessApprovePerson=response.getReturnValue().isVistexApprovePerson;
                    console.log('--------isBusinessApprovePerson-----------'+isBusinessApprovePerson);
                    console.log('--------loggedInUserId-----------'+loggedInUserId);
                    component.set("v.isBusinessApprovePerson",isBusinessApprovePerson);
                    component.set("v.vistStatus",response.getReturnValue().bidRecord.Phoenix_Vistex_Update__c);
                    component.set("v.vistCom",response.getReturnValue().bidRecord.Phoenix_Vistex_Update_Comments__c); 
                }
                    else{
                    var OutDiv = component.find("mainDiv");
                    
                    $A.util.addClass(OutDiv,"noheightClass");
                    component.set("v.isChecklistExists",false);    
                }
                }
                else{
                 var OutDiv = component.find("mainDiv");
                    
                    $A.util.addClass(OutDiv,"noheightClass");
                    component.set("v.isChecklistExists",false);        
                }
               
                
                if(getres=='Rebate')
                    component.set("v.ChecklistTypeboolean",true);
                
                else
                    component.set("v.ChecklistTypeboolean",false);
                //alert('-=-=-=-'+getcodata);
                var conDocument=response.getReturnValue().conDocLink;
                var fileList=[];
                var totalFiles=[];
                var checked=false;
                totalFiles=response.getReturnValue().conDocLink;
                if(totalFiles!=undefined&&totalFiles!=null)
                {
                    for(var i=0;i<totalFiles.length;i++)
                    {
                        fileList.push({"Id":totalFiles[i].ContentDocumentId,"Title":totalFiles[i].ContentDocument.Title+'.'+totalFiles[i].ContentDocument.FileExtension,"checked":checked});
                    }
                }
                component.set("v.fileList",fileList);    
            }
            component.set("v.approvalStatus",response.getReturnValue().approvalStatus);
            if(response.getReturnValue().approvalStatus!='Draft'){
                component.set("v.isDisableField",true);  
                var OutDiv = component.find("mainDiv");
                
                $A.util.addClass(OutDiv,"noheightClass");
                
                /*  else if(rebatesListProposed.length<4){
                                       $A.util.addClass(OutDiv,"noheightClass");
                                       
                                   }
                                       else{
                                           $A.util.removeClass(OutDiv,"noheightClass");
                                           //  $A.util.addClass(OutDiv,"heightClass");
                                       }*/
            }
            else{
                
            }
            
            
            
        });
        $A.enqueueAction(Getcondata);
        
        
        
        /* */
        
    },
    
    Saverecord : function(component, event, helper)
    {
        //var currentrecID=component.find('recordid').get("v.value");
        // component.find("bid").set("v.value",currentrecID);
        
        component.find("ChecklistForm").submit();
        
        
    },
    
    handleOnSubmit : function(component, event, helper)
    {
        // var currentrecID=component.find('recordid').get("v.value");
        // component.find("bid").set("v.value",currentrecID);
        
    },
    
    handleOnSuccess : function(component, event, helper)
    {
        var params = event.getParams(); //get event params
        var checklistrecordId = params.response.id; //get record id
        
        if(checklistrecordId != null)
        {
            
            var currentrecID=component.find('recordid').get("v.value");
            var navEvt = $A.get("e.force:navigateToSObject");
            navEvt.setParams({
                "recordId": currentrecID,
                "slideDevName": "related"
            });
           // navEvt.fire();
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Success!",
                "type" : "success",
                "message": "The record has been Updated successfully."
            });
            toastEvent.fire();
            
            // alert('Record Id success -checklistrecordId==== ' + checklistrecordId); 
        }
        
        
    },
    
    handleOnError : function(component, event, helper)
    {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Error!",
            "type" : "error",
            "message": "The record has not been Updated."
        });
        toastEvent.fire();
        
    },
    
    Cancelrecord : function(component, event, helper)
    {
        // var currentrecID=component.find('recordid').get("v.value");
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": component.get("v.recordId"),
            "slideDevName": "related"
        });
        navEvt.fire();
    }
    ,
    ChecklistTypeChange : function(component, event, helper)
    {
        var changevalue=event.getSource().get("v.value");
        if(changevalue=='Rebate')
            component.set("v.ChecklistTypeboolean",true);
        
        else
            component.set("v.ChecklistTypeboolean",false);
        
        //alert("&&&&&&&&&"+component.get("v.ChecklistTypeboolean"));
    },
    
    //-------------handling after completion of upload------------
    handleUploadFinished : function(component, event) {
        var action = component.get('c.getDocs');
        action.setParams({'bidId' : component.get("v.bid")});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var fileList=[];
                var totalFiles=[];
                var checked=false;
                totalFiles=response.getReturnValue();
                if(totalFiles!=undefined&&totalFiles!=null)
                {
                    for(var i=0;i<totalFiles.length;i++)
                    {
                        fileList.push({"Id":totalFiles[i].ContentDocumentId,"Title":totalFiles[i].ContentDocument.Title+'.'+totalFiles[i].ContentDocument.FileExtension,"checked":checked});
                    }
                }
                component.set("v.fileList",fileList);
            }  
        });
        $A.enqueueAction(action); 
    },
    
    //-------------deletion of uploaded document------------
    
    deleteAttachment: function (component, event, helper) {
        // let pageReference = component.get("v.pageReference");
        let recordId = component.get("v.recordId");
        // component.set("v.recordId",recordId);
        var selectedRec = event.getSource().get("v.name");
        console.log('selectedRec--->'+selectedRec);
        var target = event.target;
        var action = component.get("c.deleteAttachments");
        console.log('action--->');
        action.setParams({
            'selAttachId' :selectedRec,
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
        
    },
    showSaveCancel: function (component, event, helper) {
        var value= component.find("vistAppStatus");
        var value1= component.find("vistComments");
        
        if( (value!=undefined) && (component.find("vistAppStatus").get("v.value"))!=''){
            component.set("v.showSaveCancelBtn",true); 
            component.set("v.showProceedBtn",false);
        }
        else  if(value1!=undefined && component.find("vistComments").get("v.value")!=''){
            component.set("v.showSaveCancelBtn",true);
            component.set("v.showProceedBtn",false);
            
            
        }
            else{
                component.set("v.showSaveCancelBtn",false);  
                
            }
    },
    
    saveApprovalBus: function (component, event, helper) {
        
        var value= component.find("vistAppStatus");
        var value2= component.find("vistComments");
        if(value!=undefined){
            var busStatus=component.find("vistAppStatus").get("v.value");
        }
        if(value2!=undefined){
            var busCom=component.find("vistComments").get("v.value");
        }
        var action = component.get("c.saveToBidBus");
        action.setParams({
            'bidId': component.get("v.recordId"),
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
    delRec: function (component, event, helper) {
        let recordId = component.get("v.recordId");
         var action = component.get("c.delChecklist");
            action.setParams({
                'bidId' : recordId
               
            });
            action.setCallback(this, function (response){
                if(response.getState() === "SUCCESS"){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type":"success",
                        "title": "Success",
                        "message": "Record has been deleted successfully."
                    });
                    toastEvent.fire();
                    component.find("navService").navigate({
                    type: "standard__recordPage",
                    attributes: {
                        recordId: component.get("v.recordId"),
                        actionName: "view"
                    }
                }, false);
                $A.get('e.force:refreshView').fire();      
              }
            });
           $A.enqueueAction(action); 
                  
    },
    
    
    
    
    saveToProceedBusiness: function (component, event, helper) {
        var finComm=component.find("vistComments").get("v.value");
        var finAppStatus=component.find("vistAppStatus").get("v.value");
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
                'bidId' :  component.get("v.recordId"),
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
        
    }
})