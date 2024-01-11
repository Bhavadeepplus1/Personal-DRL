({
	 handleUploadFinished : function(component, event) {
        let pageReference = component.get("v.pageReference");
        let recordId = pageReference.state.c__recordId;
        component.set("v.recordId",recordId);
        var action = component.get('c.getDocs');
        action.setParams({'bidId' : component.get("v.recordId")});
         console
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log(state)
            console.log(state)
            if (state === "SUCCESS") {
                var fileList=[];
                var totalFiles=[];
                var checked=false;
               totalFiles=response.getReturnValue();
                if(totalFiles!=undefined&&totalFiles!=null)
                {
                    for(var i=0;i<totalFiles.length;i++)
                    {
                         console.log('---33333333---1-----');
                      fileList.push({"Id":totalFiles[i].ContentDocumentId,"Title":totalFiles[i].ContentDocument.Title+'.'+totalFiles[i].ContentDocument.FileExtension,"checked":checked});
                    }
                }
                console.log('------1-----');
               component.set("v.fileList",fileList);
                console.log('------1--2---'+JSON.stringify(response.getReturnValue()));
            }  
            if(state === "ERROR"){
               // component.set("v.isTSNotCreated","true");
            } 
            
        });
        $A.enqueueAction(action);
     } 
})