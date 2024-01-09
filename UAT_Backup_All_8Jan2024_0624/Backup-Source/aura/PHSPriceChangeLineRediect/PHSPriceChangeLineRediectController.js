({
    init : function(component, event, helper) {
        var recordId = component.get("v.recordId");
        console.log('recordId: ' + recordId);

        component.find("navigationService").navigate({
            type: "standard__component",
            attributes: {
                componentName: "c__PHSPriceLineItemsCmp" },
            state: {
                c__recordId: recordId
               
            }
        }, true); // replace = true
        
    }
})