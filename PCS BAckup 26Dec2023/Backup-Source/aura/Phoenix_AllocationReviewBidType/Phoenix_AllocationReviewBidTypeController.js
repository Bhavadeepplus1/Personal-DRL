({
    doInit : function(component,event,helper) {
        var bidId = component.get("v.recordId");
        console.log('bidId-----'+bidId);
        var getQuoteInfo = component.get("c.getbidInfo");
        getQuoteInfo.setParams({ "bidId": bidId });
        getQuoteInfo.setCallback(this, function (response) {
            var actState = response.getState();
            if (actState === 'SUCCESS') {
                component.set("v.wrap",response.getReturnValue());
                var test=component.get("v.wrap");
                var abc=JSON.stringify(test);
                console.log("test-----"+JSON.stringify(test));
                console.log("test-1----"+abc.Phoenix_Bid_Type__c);

                
            }
        });
        $A.enqueueAction(getQuoteInfo);
    },
    closeModal : function(component,event,helper) {
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
    },
    handleUploadFinished: function (component, event) {
        // Get the list of uploaded files
        var uploadedFiles = event.getParam("files");
        //  console.log("Files uploaded : " + uploadedFiles.length);
        
        // Get the file name
        uploadedFiles.forEach(file => console.log(file.name));
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "type" : "success",
            "message": uploadedFiles.length+" file(s) has been uploaded successfully!"
        });
        toastEvent.fire();
        
        //  $A.get('e.force:refreshView').fire();
    }
})