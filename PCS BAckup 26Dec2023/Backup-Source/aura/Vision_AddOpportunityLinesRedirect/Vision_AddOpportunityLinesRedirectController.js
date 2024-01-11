({
	
    init : function(component, event, helper) {
        //alert('AddProductRedirect init()');
        var recordId = component.get("v.recordId");
        console.log('recordId:: ' + recordId);
        //$A.get('e.force:refreshView').fire();
        component.find("navigationService").navigate({
            type: "standard__component",
            attributes: {
                componentName: "c__Vision_AddOpportunityLines" },
            state: {
                c__recordId: recordId,
                c__addProduct: true
            }
        }, true); // replace = true
        // helper.delayedRefresh();
       
    }
    
    

})