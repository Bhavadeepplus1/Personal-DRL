({
	 init : function(component, event, helper) {
       
        var recordId = component.get("v.recordId");
        console.log('recordId: ');
        component.find("navigationService").navigate({
            type: "standard__component",
            attributes: {
                componentName: "c__RCAIPAMemberAdditionCmp" },
            state: {
                c__recordId: recordId
                
            }
        }, true);
       
    }
})