({
	
    init : function(component, event, helper) {
       // alert('BidWACChangeController init()');
        var recordId = component.get("v.recordId");
        console.log('recordId: ' + recordId);
        //$A.get('e.force:refreshView').fire();

        component.find("navigationService").navigate({
            type: "standard__component",
            attributes: {
                componentName: "c__Phoenix_BidWACEditLineItems"},
            state: {
                c__recordId: recordId
                
            }
        }, true); // replace = true
        // helper.delayedRefresh();
   console.log(' ----------------test&&&&&&&&&&&&&&&');    
    }
    
    

})