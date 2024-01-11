({
	doInit : function(component, event, helper) {
        //buiding a page reference for the component where we need to navigate
        var recordId=component.get("v.recordId");
        var pageReference = {
            type: 'standard__component',
            attributes: {
                componentName: 'c__UrlAddressableComponent',
            },
            state: {
                c__recordId: recordId
              }
        };
        component.set("v.pageReference", pageReference);
    var pageReference = component.get("v.pageReference");
        var navService = component.find("navService");
               
                navService.navigate(pageReference);
    },
})