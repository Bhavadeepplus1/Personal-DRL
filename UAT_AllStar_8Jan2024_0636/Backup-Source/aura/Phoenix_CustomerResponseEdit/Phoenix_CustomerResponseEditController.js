({
    doInit: function(component) {
        var strCRId = component.get("v.recordId");
        console.log('CR Id ====>'+strCRId);
        $A.createComponent("c:Phoenix_CustomerResponseEditModal", 
                           {
                               recordId : strCRId,
                               isFromEditButton : true
                           },
                           function(result, status) {
                               if (status === "SUCCESS") {
                                   component.find('overlayLibDemo').showCustomModal({
                                       header: "Edit Customer Response",
                                       body: result, 
                                       showCloseButton: false,
                                       cssClass: "mymodal, slds-modal_large", 
                                       closeCallback: function() {
                                           $A.get('e.force:refreshView').fire();
        								   console.log('event fired');
                                       }
                                   })
                               }   
                           });
    },
    handleChange: function(component) {
        var strCRId = component.get("v.recordId");
        console.log('CR Id ====>'+strCRId);
        $A.createComponent("c:Phoenix_CustomerResponseEditModal", 
                           {recordId : strCRId},
                           function(result, status) {
                               if (status === "SUCCESS") {
                                   component.find('overlayLibDemo').showCustomModal({
                                       header: "Edit Customer Response",
                                       body: result, 
                                       showCloseButton: false,
                                       cssClass: "mymodal, slds-modal_large", 
                                       closeCallback: function() {
                                           $A.get('e.force:refreshView').fire();
        								   console.log('event fired');
                                       }
                                   })
                               }   
                           });
    },
	    
})