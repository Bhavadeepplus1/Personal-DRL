({
	init : function(component, event, helper) {
        console.log('BidRedirect init()');
        var recordId = component.get("v.recordId");
        console.log('recordId: ' + recordId);
        
        var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef: "c:Vision_sendToBright",
            componentAttributes: {
                recordId: recordId
            }
        });
        evt.fire();
        
       // $A.get('e.force:refreshView').fire();

        /*component.find("navigationService").navigate({
            type: "standard__component",
            attributes: {
                componentName: "c__Vision_sendToBright" },
            state: {
                c__recordId: recordId
               
            }
        }, true); // replace = true*/
        
    }
})