({
    parse: function(component, result) {
        var state = result.getState();
        if (state === "SUCCESS") {
            
            var folders = result.getReturnValue();
            var parents = { undefined: { items: [] }};
            //alert(parents);
            /* folders.forEach( folder => parents[folder.Id] = { items: [], name: folder.Id, label: "📁 "+folder.Name, expanded: false});*/
            for(var i=0;i<folders.length;i++)
            {
                parents[folders[i].Id] = { items: [], name: folders[i].Id, label: "📁  "+folders[i].Name, expanded: false,selected:false}
            }
            
            for(var i=0;i<folders.length;i++)
            {   
                var obj=parents[folders[i].ParentContentFolderId];
                if(obj!=undefined){
                    parents[folders[i].ParentContentFolderId].items.push(parents[folders[i].Id])}
            }  
            
            //alert(1);
            //folders.forEach(folder => parents[folder.ParentContentFolderId].items.push(parents[folder.Id]));
            component.set("v.data", parents[undefined].items);
           // component.set("v.openReport", true);
        }
        else{
            component.set("v.openReport", false);
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message":"You don't have enough permissions, please contact Admistrator",
                "type":"error"
            });
            toastEvent.fire();
        }
    },
    parseUpd: function(component, result,selVal) {
        var state = result.getState();
        if (state === "SUCCESS") {
            var resultItems=result.getReturnValue();
            var cwrapList=resultItems.cwrapList;
            if(cwrapList[0].cfi != null && cwrapList[0].cfi != undefined && cwrapList.length > 0){
                component.set("v.contentFolItems", cwrapList);
                console.log('==AA');
            }
            else{
                console.log('==BB');
                component.set("v.folderMessage", 'This folder is empty.');
                component.set("v.contentFolItems", '');
            }
            var folders = resultItems.cflist,
                parents = { undefined: { items: [] }};
            for(var i=0;i<folders.length;i++)
            {
                parents[folders[i].Id] = { items: [], name: folders[i].Id, label: "📁 "+folders[i].Name, expanded: false}
            }
            
            for(var i=0;i<folders.length;i++)
            {
                var obj=parents[folders[i].ParentContentFolderId];
                if(obj!=undefined){
                    parents[folders[i].ParentContentFolderId].items.push(parents[folders[i].Id])}
            }                  
            component.set("v.data", parents[undefined].items);
        }
        else{
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message":"You don't have enough permissions, please contact Admistrator",
                "type":"error"
            });
            toastEvent.fire();
        }
    },
    
    
    
    handleUploadFinished : function(component, event) {
        var uploadedFileArr = [];
        var sObjectAttachedFiles = component.get("v.sObjectAttachedFiles");
        var sObjectAttachedFilesArr = [];
        if(sObjectAttachedFiles != null && sObjectAttachedFiles != undefined && sObjectAttachedFiles.length > 0){
            [].forEach.call(sObjectAttachedFiles, function(file) {
                sObjectAttachedFilesArr.push({'Id' : file.Id,'Title': file.Title});
            });
        }
        
        var uploadedFiles = event.getParam("files");
        [].forEach.call(uploadedFiles, function(file) {
            uploadedFileArr.push({'Id' : file.documentId,'Name': file.name});
            sObjectAttachedFilesArr.push({'Id' : file.documentId,'Title': file.name});
        });
        
        component.set("v.sObjectAttachedFiles", sObjectAttachedFilesArr);
        
        var filesUploadedPreviously = component.get('v.uploadedFiles');
        if(filesUploadedPreviously != null && filesUploadedPreviously != undefined && filesUploadedPreviously.length > 0){
            [].forEach.call(filesUploadedPreviously, function(file) {
                uploadedFileArr.push({'Id' : file.Id,'Name': file.Name});
            });
        }
        component.set("v.uploadedFiles",uploadedFileArr); 
    },
    
    handleCancelUpload : function(component){
        component.set("v.uploadFiles",false);
        var sObjectFiles=component.get("v.sObjectAttachedFiles");
        if(sObjectFiles==null || sObjectFiles==undefined || sObjectFiles=='') 
            component.set("v.uploadedFiles",null);
        var uploadedFiles = component.get("v.sObjectAttachedFiles");
        var uploadedFileIdArr = [];
        if(uploadedFiles != null && uploadedFiles != undefined && uploadedFiles.length > 0){
            [].forEach.call(uploadedFiles, function(file) {
                uploadedFileIdArr.push(file.Id);
            });
        }
        var sObjectId = component.get("v.sObjectId");
        var sObjectName = component.get("v.sObjectName");
        
        var action = component.get("c.deleteFiles");
        action.setParams({
            filesIdArrStr : JSON.stringify(uploadedFileIdArr)
        });
        
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state=='SUCCESS')
            {component.get("v.upoadedFiles",null);
            component.get("v.sObjectAttachedFiles",null);
            }
        });
        $A.enqueueAction(action);
    },
    
    handleSaveClick : function(component){
        var sObjectId = component.get("v.sObjectId");
        var sObjectName = component.get("v.sObjectName");
        var uploadedFileIdArr = [];
        var uploadedFiles = component.get("v.uploadedFiles");
        if(uploadedFiles != null && uploadedFiles != undefined && uploadedFiles.length > 0){
            [].forEach.call(uploadedFiles, function(file) {
                uploadedFileIdArr.push(file.Id);
            });
            
            var selFolder = component.get("v.selectedItem");
            var sObjectName = component.get("v.sObjectName");
            
            var action = component.get("c.updateFolderMember");
            action.setParams({
                filesIdArrStr : JSON.stringify(uploadedFileIdArr),
                selFolder:selFolder
            });
            
            action.setCallback(this, function(response){
                var state = response.getState();
                
                if(state === "SUCCESS"){
                    var cFiles = response.getReturnValue();
                    if(cFiles != null && cFiles != undefined && cFiles.length > 0){
                        component.set("v.contentFolItems", cFiles);
                        component.set("v.uploadFiles",false);
                        component.get("v.uploadedFiles",'');
                        component.get("v.sObjectAttachedFiles",null);
                    }
                    else{
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Error!",
                            "message":"You don't have enough permissions, please contact Administrator",
                            "type":"error"
                        });
                        toastEvent.fire();
                        //component.set("v.contentFolItems", '');
                        component.set("v.uploadFiles",false);
                        component.get("v.uploadedFiles",'');
                        component.get("v.sObjectAttachedFiles",null);
                    }
                }
            });
            $A.enqueueAction(action);   
        }
        else{
            component.set("v.uploadFiles",false);
        }
    },
    
    openSelectedItems: function(component,event,selVal){
        component.set('v.spinner2',true);
        var action = component.get("c.getFolItems");
        action.setParams({
            parentFolId : selVal
        });
        
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                var cFiles = response.getReturnValue();
                
                if(cFiles[0].cfi != null && cFiles[0].cfi != undefined && cFiles.length > 0){
                    component.set("v.contentFolItems", cFiles);
                    component.set("v.rootFolderId", cFiles[0].rootFolder);
                    if(cFiles[0].fplist.length>0)
                    {
                        var pathFiles=[];
                        for(var i=cFiles[0].fplist.length-1;i>=0;i--)
                        {
                            pathFiles.push(cFiles[0].fplist[i]);
                        }
                        component.set("v.pathData",pathFiles);
                        component.set('v.spinner2',false);

                    }
                    else{
                        component.set("v.pathData",null);
                        component.set('v.spinner2',false);


                        
                    }
                }
                else{
                    component.set("v.folderMessage", 'This folder is empty.');
                    component.set("v.contentFolItems", '');
                    component.set("v.rootFolderId", cFiles[0].rootFolder);
                    if(cFiles[0].fplist.length>0)
                    {
                        var pathFiles=[];
                        for(var i=cFiles[0].fplist.length-1;i>=0;i--)
                        {
                            pathFiles.push(cFiles[0].fplist[i]);
                        }
                        component.set("v.pathData",pathFiles);
                        component.set('v.spinner2',false);

                    }
                    else{
                        component.set("v.pathData",null);
                        component.set('v.spinner2',false);

                    }
                }
            }
            else
            {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message":"You don't have enough permissions, please contact Administrator",
                    "type":"error"
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    },
    
    getSearchFiles: function(component,event)
    {
        var action = component.get("c.getSearchFolItems");
        var searchVal=component.get("v.searchKeyword");
        var parentFolId = component.get("v.selectedItem");
        action.setParams({
            "parentFolId" : parentFolId,
            "searchWord":searchVal
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                var cFiles = response.getReturnValue();
                if(cFiles != null && cFiles != undefined && cFiles.length > 0){
                    component.set("v.contentFolItems", cFiles);
                }
                else{
                    component.set("v.folderMessage", 'No files found');
                    component.set("v.contentFolItems", '');
                }
            }
            else
            {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message":"You don't have enough permissions, please contact Administrator",
                    "type":"error"
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    },
    
    searchHelper : function(component,event,getInputkeyWord) {
        var finalList=component.get("v.lstSelectedRecords");
        var finalList1=component.get("v.lstSelectedRecordsCon");
        var action = component.get("c.fetchLookUpValues");
        action.setParams({
            'searchKeyWord': getInputkeyWord,
            'ObjectName' : component.get("v.objectAPIName"),
            'ExcludeitemsList' : finalList,
            'existeditemsList' : finalList1
        });
        
        action.setCallback(this, function(response) {
            $A.util.removeClass(component.find("mySpinner"), "slds-show");
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                if (storeResponse.length == 0) {
                    component.set("v.Message", 'No Records Found...');
                } else {
                    component.set("v.Message", '');
                }
                component.set("v.listOfSearchRecords", storeResponse); 
            }
        });
        
        $A.enqueueAction(action);
    },
    
    searchHelperCC : function(component,event,getInputkeyWord) {
        
        var finalList=component.get("v.lstSelectedRecordsCC");
        var finalList1=component.get("v.lstSelectedRecordsCon");
        
        var action = component.get("c.fetchLookUpValues");
        action.setParams({
            'searchKeyWord': getInputkeyWord,
            'ObjectName' : component.get("v.objectAPIName"),
            'ExcludeitemsList' : finalList,
            'existeditemsList' : finalList1
        });
        action.setCallback(this, function(response) {
            $A.util.removeClass(component.find("mySpinner"), "slds-show");
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                if (storeResponse.length == 0) {
                    component.set("v.Message", 'No Records Found...');
                } else {
                    component.set("v.Message", '');
                }
                component.set("v.listOfSearchRecords", storeResponse); 
            }
        });
        $A.enqueueAction(action);
    },
    
})