({
	 init : function(component, event, helper) {
       
        var recordId = component.get("v.recordId");
        console.log('recordId: ');
        component.find("navigationService").navigate({
            type: "standard__component",
            attributes: {
                componentName: "c__Phoenix_NewIPACmp" },
            state: {
                c__recordId: recordId
                
            }
        }, true);
       
    }
})