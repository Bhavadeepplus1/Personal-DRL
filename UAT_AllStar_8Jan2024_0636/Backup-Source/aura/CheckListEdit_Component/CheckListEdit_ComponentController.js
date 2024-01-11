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
                var getres = response.getReturnValue().checklist.Checklist_Type__c;
                component.set("v.bid",response.getReturnValue().checklist.Bid__c);
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
            navEvt.fire();
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
        var currentrecID=component.find('recordid').get("v.value");
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": currentrecID,
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
        
    }
})