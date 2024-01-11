({
    init : function(component, event, helper) {
        console.log('TermMatrixRedirect init()');
        var recordId = component.get("v.recordId");
        console.log('recordId: ' + recordId);
        //$A.get('e.force:refreshView').fire();

        component.find("navigationService").navigate({
            type: "standard__component",
            attributes: {
                componentName: "c__TermMatrixEdit" },
            state: {
                c__recordId: recordId,
                c__isClone: false
            }
        }, true); // replace = true
        
    }
})