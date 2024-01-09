({
    init :function(component, event, helper) {
       // alert('calling BidEditLineRedirect init()');
        console.log('BidEditLineRedirect init()');
        var recordId = component.get("v.recordId");
        console.log('recordId in BidEditRedirect: ' + recordId);
        //$A.get('e.force:refreshView').fire();

        component.find("navigationService").navigate({
            type: "standard__component",
            attributes: {
                componentName: "c__Phoenix_BidEditLineItems" 
            },
            state: {
                c__recordId: recordId,
                c__isClone:false
            }
        }, true); // replace = true
        
    }
})