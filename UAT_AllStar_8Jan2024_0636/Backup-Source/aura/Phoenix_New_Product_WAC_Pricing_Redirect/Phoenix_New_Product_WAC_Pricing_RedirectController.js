({
    init : function(component, event, helper) {
        var recordId = component.get("v.recordId");

        component.find("navigationService").navigate({
            type: "standard__component",
            attributes: {
                componentName: "c__Phoenix_New_Product_WAC_Pricing" },
            state: {
                c__recordId: recordId
               
            }
        }, true); // replace = true
        
    }
})