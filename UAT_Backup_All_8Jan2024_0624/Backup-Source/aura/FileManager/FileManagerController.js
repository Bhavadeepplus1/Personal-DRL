({ 
    doInit: function(component, event, helper) {
        var action = component.get("c.getRecords");
        action.setCallback(this, result => helper.parse(component, result));
        $A.enqueueAction(action);
    },
    
    handleSelect: function (component, event, helper) {   
        var params = event.getParams();
        var selId = event.getParam('name');
       component.set('v.spinner',true);

        if(selId!=undefined)
            component.set("v.selectedItem",selId);
        component.set("v.uploadedFiles",null);

        helper.openSelectedItems(component,event,selId);
                       component.set('v.spinner',false);

        // alert(component.get("v.pathData"));
    },
    
    handleRefresh: function (component, event, helper) {
        var selId=component.get("v.selectedItem");
        if(selId!=undefined && selId!='' && selId!=null)
            helper.openSelectedItems(component,event,selId);
    },
    
    handleSelectFromPath: function (component, event, helper) {
        var openFileId=event.currentTarget.getAttribute("data-name");
        component.set("v.selectedItem",openFileId);
        component.set("v.uploadedFiles",null);
        helper.openSelectedItems(component,event,openFileId);
    },
    
    handleOpenFiles:function (component, event, helper) {
        //don't remove this method
    },
    
    openFolderPopUp: function(component,event,helper){
        
        var action = component.get("c.checkLibraryAccess");
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                var access = response.getReturnValue();
                if(access==true)
                    component.set("v.folWindow",true);
                else
                {
                    component.set("v.folWindow",false);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message":"You don't have enough permissions, please contact Admistrator",
                        "type":"error"
                    });
                    toastEvent.fire();
                }
                
            }
            else
            {
                component.set("v.folWindow",false);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message":"You don't have enough permissions, please contact Admistrator",
                    "type":"error"
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
        
    },
    
    closeFolder: function(component,event,helper){
        component.set("v.folWindow",false);
    },
    
    
    openE:function(component, event, helper) {
      // Set isModalOpen attribute to true
      component.set("v.openEmailWindow", true);
   },
  
    
    openMailPopUp: function(component,event,helper){
        var toastEvent = $A.get("e.force:showToast");
        var docVal=event.getSource().get("v.value")
        component.set("v.emailRecordId",docVal);
        var subject="Dr.Reddy's-Salesforce File Link";
        var body="Hi,<br/><br/>Please find Salesforce file from the below link :";
        component.set("v.subject",subject);
        component.set("v.body",body);
        component.set("v.openEmailWindow",true);
        component.set("v.lstSelectedRecords" , []); 
        component.set("v.lstSelectedRecordsCC" , []); 
        
        var action=component.get("c.getEmailStatus");
        action.setParams({docId:docVal});
        action.setCallback(this,function(response){
            
            var state=response.getState();
            if(state=='SUCCESS')
            {
                var result=response.getReturnValue();
                console.log('result--->'+JSON.stringify(result));
                if(result.cversion.Last_Time_Public_Link_Sent_on_Email__c==undefined)
                    component.set("v.mailTimeHeader",false);
                else
                    component.set("v.mailTimeHeader",true);
                component.set("v.cv",result.cversion);
                if(result.conDis!=null&&result.conDis.DistributionPublicUrl!=undefined&&result.conDis.Password!=undefined){
                    body=body+'<br/> <br/>File Link: <br/><a href='+result.conDis.DistributionPublicUrl+' target="_blank" style="font-family: arial, sans-serif;">'+result.conDis.DistributionPublicUrl+'</a><br/>'+'Password : '+result.conDis.Password+'</br> </br>This link will expire after 1 year.</br> ';    
                }
                component.set("v.body",body);
            }
            else
            {
                component.set("v.mailTimeHeader",false);
                toastEvent.setParams({
                    "title": "Error!",
                    "message":"You don't have enough permissions, please contact Admistrator",
                    "type":"error"
                });
                toastEvent.fire();
            }
            
        });
        
        $A.enqueueAction(action);
        
    },
    
    sendMailWithPL: function(component,event,helper){
        
        var selRecords=component.get("v.lstSelectedRecords");
        var selectedEmailIds = [];
        var selCCRecords=component.get("v.lstSelectedRecordsCC");
        var selectedCCEmailIds = [];
        
        if(selRecords != null && selRecords != undefined && selRecords.length > 0){
            [].forEach.call(selRecords, function(file) {
                if(file.Email!=undefined&&file.Email!=''&&file.Email!=null)
                    selectedEmailIds.push(file.Email);
            });
        }
        
        if(selCCRecords != null && selCCRecords != undefined && selCCRecords.length > 0){
            [].forEach.call(selCCRecords, function(file) {
                if(file.Email!=undefined&&file.Email!=''&&file.Email!=null)
                    selectedCCEmailIds.push(file.Email);
            });
        }
        
        var contentDocId=component.get("v.emailRecordId");
        var toMail=component.get("v.email");
        var ccMail=component.get("v.emailCC");
        var subject=component.get("v.subject");
        var body=component.get("v.body");
        var action=component.get("c.getPublicLink");
        action.setParams({contentDocId:contentDocId,toMail:JSON.stringify(selectedEmailIds),ccMail:JSON.stringify(selectedCCEmailIds),subject:subject,body:body});
        action.setCallback(this,function(response){
            var state=response.getState();
            if(state=='SUCCESS')
            {
                var result=response.getReturnValue();
                component.set("v.mailTimeHeader",false);
                component.set("v.openEmailWindow",false);
                component.set("v.email",'');
                component.set("v.emailCC",'');
                component.set("v.body",'');
                component.set("v.subject",'');
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "Mail has been sent successfully.",
                    "type":"success"
                });
                toastEvent.fire();
                
            }
            else
            {
                component.set("v.mailTimeHeader",false);
                component.set("v.openEmailWindow",false);
                component.set("v.email",'');
                component.set("v.emailCC",'');
                component.set("v.body",'');
                component.set("v.subject",'');
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message":"Mail sent failed",
                    "type":"error"
                });
                toastEvent.fire();
            }
            
            
        });
        
        $A.enqueueAction(action); 
    },
    
    closeMailPopUp: function(component,event,helper){
        component.set("v.openEmailWindow",false);
        component.set("v.mailTimeHeader",false);
        component.set("v.lstSelectedRecords" , []); 
        component.set("v.lstSelectedRecordsCC" , []);
        component.set("v.SearchContact" , null);
        component.set("v.SearchContactCC" , null);
    },
    
    createNewFolder: function(component,event,helper){
        var selVal=component.get("v.selectedItem");
        var folName=component.get("v.folderName");
        var folData=component.get("v.data");
        var action = component.get("c.getRecordsUpdated");
        action.setParams({parentFolId:selVal,folName:folName});//getRecordsUpdated(String parentFolId)
        action.setCallback(this, result => helper.parseUpd(component, result,selVal));
        $A.enqueueAction(action);
        component.set("v.folWindow",false);
        component.set("v.folderName",'');
    },
    
    uploadFiles: function(component,event,helper){
        
        component.get("v.uploadedFiles",'');
        component.set("v.sObjectAttachedFiles",null);
        //component.set("v.uploadFiles",true);
        var action = component.get("c.checkLibraryAccess");
           
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                var access = response.getReturnValue();
                //alert(access);
                if(access==true){
                    component.set("v.uploadFiles",true);
                }
                 
                else
                {
                    component.set("v.uploadFiles",false);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message":"You don't have enough permissions, please contact Admistrator",
                        "type":"error"
                    });
                    toastEvent.fire();
                }
                
            }
            else
            {
                component.set("v.uploadFiles",false);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message":"You don't have enough permissions, please contact Admistrator",
                    "type":"error"
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
        
    },
    
    handleUploadFinished : function (component, event, helper) {
        helper.handleUploadFinished(component, event);
    },
    
    handleCancelUpload : function(component, event, helper){
        helper.handleCancelUpload(component);
    },
    
    handleSaveClick : function(component, event, helper){
        helper.handleSaveClick(component);
    },
    
    openFile:function(component,event,helper){
        var openFileId=event.currentTarget.getAttribute("data-name");
        var res = openFileId.substring(0, 3);
        if(res=='07H')
        {
            component.set("v.uploadedFiles",null);
            component.set("v.selectedItem",openFileId);
            helper.openSelectedItems(component,event,openFileId);
        }
        if(res=='069')
        {
            if(component.get("v.formFactor")=='DESKTOP'){
                var navLink = component.find("navLink");
                var pageRef = {
                    type: 'standard__namedPage',
                    attributes: {
                        pageName: 'filePreview',
                    },
                    state : {
                        recordIds: openFileId,
                        selectedRecordId: openFileId
                    }
                };
                navLink.navigate(pageRef, true);
            }
            else{
                $A.get('e.lightning:openFiles').fire({
                    recordIds: [openFileId],
                    selectedRecordId: openFileId
                });
            }
        }
    },
    
    searchFiles:function(component,event,helper){
        component.set("v.spinnerForSearch", false); 
       // var searchVal=component.get("v.searchKeyword");
        //helper.getSearchFiles(component,event,component.get("v.selectedItem"),searchVal); 
        helper.getSearchFiles(component,event);
    },
    
    showSpinner: function(component, event, helper) {
        var spSearch=component.get("v.spinnerForSearch");
        if(spSearch==true)
            component.set("v.spinner", false); 
        if(spSearch==false)
            component.set("v.spinnerForSearch", true); 
    },
    
    hideSpinner : function(component,event,helper){
        component.set("v.spinner", false);
    },
    
    expandDropDown: function(component,event,helper) {
        var infos = component.find("hwDiv");
        var index = event.target.closest("[data-index]").dataset.index;
        /*
		 var infos = component.find("hwDiv"),
    	// Get the index value
    	index = event.target.closest("[data-index]").dataset.index;
		// Normalize to array
		infos = infos.length? infos: [infos];
		$A.util.toggleClass(infos[index], 'slds-is-open');
        */
        //infos = infos.length? infos: [infos];
        for(var i=0;i<infos.length;i++)
        {
            if(index==i)
                $A.util.toggleClass(infos[i], 'slds-is-open');
            else
                $A.util.removeClass(infos[i], 'slds-is-open');
        }
        event.stopPropagation();
    },
    
    closeDropDown:function(component,event,helper) {
        var infos = component.find("hwDiv");
        if(infos!=undefined){
            for(var i=0;i<infos.length;i++)
                $A.util.removeClass(infos[i], 'slds-is-open');
        }    
    },
    
    deleteSFDoc:function(component,event,helper) {
        var docId=event.currentTarget.getAttribute("data-name");
        var selId=component.get("v.selectedItem");
        //alert(selId+'=='+docId);
        //var selVal=component.get("v.selectedItem");
        //var folName=component.get("v.folderName");
        //var folData=component.get("v.data");
        var action = component.get("c.getRecordsDeleted");
        action.setParams({parentFolId:selId,docId:docId});//getRecordsUpdated(String parentFolId)
        action.setCallback(this, result => helper.parseUpd(component, result,selId));
        $A.enqueueAction(action);
        
    },
    
    deleteSFDocItem:function(component,event,helper) {
        var docId=event.currentTarget.getAttribute("data-id");
        var selId=component.get("v.selectedItem");
        //alert(selId+'=='+docId);
        //var selVal=component.get("v.selectedItem");
        //var folName=component.get("v.folderName");
        //var folData=component.get("v.data");
        var action = component.get("c.getDocItemDeleted");
        action.setParams({parentFolId:selId,docId:docId});//getRecordsUpdated(String parentFolId)
        action.setCallback(this, result => helper.parseUpd(component, result,selId));
        $A.enqueueAction(action);
        
    },
    
    editSFDoc:function(component,event,helper){
        var docId=event.currentTarget.getAttribute("data-id");
        var editRecordEvent = $A.get("e.force:editRecord");
        editRecordEvent.setParams({
            "recordId": docId
        });
        editRecordEvent.fire();  
    },
    
    cancelRenameFolder: function(component,event,helper){
        var renameFol=component.get("v.renamefolWindow");
        if(renameFol==false){
            var fileName=event.currentTarget.getAttribute("data-title");
            var fileId=event.currentTarget.getAttribute("data-name");
            component.set("v.folderNameRename",fileName);
            component.set("v.folderRenameId",fileId);
            component.set("v.renamefolWindow",true);
        }
        else{
            component.set("v.renamefolWindow",false);
            component.set("v.folderNameRename",'');
            component.set("v.folderRenameId",'');
        }
    },
    
    updateFolderName:function(component,event,helper){
        var action=component.get("c.updateName");
        action.setParams({cfId:component.get("v.folderRenameId"),newFolName:component.get("v.folderNameRename")});
        action.setCallback(this,function(response){
            var state=response.getState();
            if(state=='SUCCESS')
            {
                component.set("v.renamefolWindow",false);
                component.set("v.folderRenameId",'');
                component.set("v.folderNameRename",'');
                var result=response.getReturnValue();
                var cfolItems=component.get("v.contentFolItems");
                if(cfolItems.length>0)
                {
                    for(var i=0;i<cfolItems.length;i++)
                    {
                        if(cfolItems[i].cfi.Id==result.Id)
                            cfolItems[i].cfi.Title=result.Name;
                    }
                    component.set("v.contentFolItems",cfolItems);
                }
            }
            else
            {
                component.set("v.renamefolWindow",false);
                component.set("v.folderRenameId",'');
                component.set("v.folderNameRename",'');
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message":"You don't have enough permissions, please contact Admistrator",
                    "type":"error"
                });
                toastEvent.fire();
            }
            
            
        });
        
        $A.enqueueAction(action);
    },
    
    onblur : function(component,event,helper){
        component.set("v.listOfSearchRecords", null );
        // component.set("v.SearchContact", '');
        var forclose = component.find("searchRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
    },
    
    onblurCC : function(component,event,helper){
        //component.set("v.listOfSearchRecordsCC", null );
        // component.set("v.SearchContactCC", '');
        var forclose = component.find("searchResCC");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
    },
    
    onfocus : function(component,event,helper){
        $A.util.addClass(component.find("mySpinner"), "slds-show");
        component.set("v.listOfSearchRecords", null ); 
        var forOpen = component.find("searchRes");
        $A.util.addClass(forOpen, 'slds-is-open');
        $A.util.removeClass(forOpen, 'slds-is-close');
        var getInputkeyWord = '';
        helper.searchHelper(component,event,getInputkeyWord);
    },
    
    keyPressController : function(component, event, helper) {
        $A.util.addClass(component.find("mySpinner"), "slds-show");
        var getInputkeyWord = component.get("v.SearchContact");
        if(getInputkeyWord.length > 0){
            var forOpen = component.find("searchRes");
            $A.util.addClass(forOpen, 'slds-is-open');
            $A.util.removeClass(forOpen, 'slds-is-close');
            helper.searchHelper(component,event,getInputkeyWord);
        }
        else{  
            component.set("v.listOfSearchRecords", null ); 
            var forclose = component.find("searchRes");
            $A.util.addClass(forclose, 'slds-is-close');
            $A.util.removeClass(forclose, 'slds-is-open');
        }
    },
    
    keyPressControllerCC : function(component, event, helper) {
        $A.util.addClass(component.find("mySpinnerCC"), "slds-show");
        var getInputkeyWord = component.get("v.SearchContactCC");
        if(getInputkeyWord.length > 0){
            var forOpen = component.find("searchResCC");
            $A.util.addClass(forOpen, 'slds-is-open');
            $A.util.removeClass(forOpen, 'slds-is-close');
            helper.searchHelperCC(component,event,getInputkeyWord);
        }
        else{  
            //component.set("v.listOfSearchRecordsCC", null ); 
            var forclose = component.find("searchResCC");
            $A.util.addClass(forclose, 'slds-is-close');
            $A.util.removeClass(forclose, 'slds-is-open');
        }
    },
    
    clear :function(component,event,heplper){
        var selectedPillId = event.getSource().get("v.name");
        var selectedPillEmailId = event.getSource().get("v.title");
        var AllPillsList = component.get("v.lstSelectedRecords");
        var AllPillsList1 = component.get("v.lstSelectedRecordsCon");
        
        
        for(var i = 0; i < AllPillsList.length; i++){
            
            if(AllPillsList[i].Id == selectedPillId && AllPillsList[i].Email==selectedPillEmailId){
                AllPillsList.splice(i, 1);
                component.set("v.lstSelectedRecords", AllPillsList);
            }  
        }
        
        /* for(var i = 0; i < AllPillsList1.length; i++){
            if(AllPillsList1[i].Id == selectedPillId){
                AllPillsList1.splice(i, 1);
                component.set("v.lstSelectedRecordsCon", AllPillsList1);
            }  
        } */
        
        
        component.set("v.SearchContact",null);
        component.set("v.listOfSearchRecords", null );
        
    },
    
    clearCC :function(component,event,heplper){
        var selectedPillId = event.getSource().get("v.name");
        var selectedPillEmailId = event.getSource().get("v.title");
        var AllPillsList = component.get("v.lstSelectedRecordsCC");
        var AllPillsList1 = component.get("v.lstSelectedRecordsCon");
        
        for(var i = 0; i < AllPillsList.length; i++){
            if(AllPillsList[i].Id == selectedPillId && AllPillsList[i].Email==selectedPillEmailId){
                AllPillsList.splice(i, 1);
                component.set("v.lstSelectedRecordsCC", AllPillsList);
            }  
        }
        
        /* for(var i = 0; i < AllPillsList1.length; i++){
            if(AllPillsList1[i].Id == selectedPillId){
                AllPillsList1.splice(i, 1);
                component.set("v.lstSelectedRecordsCon", AllPillsList1);
            }  
        } */
        
        
        component.set("v.SearchContactCC",null);
        component.set("v.listOfSearchRecords", null );
        
    },
    
    handleComponentEvent : function(component, event, helper) {
        //component.set("v.SearchKeyWord",null);
        var listSelectedItems =  component.get("v.lstSelectedRecords");
        var selectedAccountGetFromEvent = event.getParam("recordByEvent");
        listSelectedItems.push(selectedAccountGetFromEvent);
        component.set("v.lstSelectedRecords" , listSelectedItems); 
        component.set("v.SearchContact" , ''); 
        
        var forclose = component.find("lookup-pill");
        $A.util.addClass(forclose, 'slds-show');
        $A.util.removeClass(forclose, 'slds-hide');
        
        var forclose = component.find("searchRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open'); 
    },
    
    handleComponentCCEvent : function(component, event, helper) {
        //component.set("v.SearchKeyWord",null);
        var listSelectedItems =  component.get("v.lstSelectedRecordsCC");
        var selectedAccountGetFromEvent = event.getParam("ccContact");
        listSelectedItems.push(selectedAccountGetFromEvent);
        component.set("v.lstSelectedRecordsCC" , listSelectedItems); 
        component.set("v.SearchContactCC" , ''); 
        
        var forclose = component.find("lookup-pillCC");
        $A.util.addClass(forclose, 'slds-show');
        $A.util.removeClass(forclose, 'slds-hide');
        
        var forclose = component.find("searchResCC");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open'); 
    },
    
    openReport : function(component, event, helper) {
        
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "/lightning/r/Report/00O3a000005Nq65EAC/view"
        });
        urlEvent.fire();
    }
    
    
})