({
	 init : function(component, event, helper) {
       
        var recordId = component.get("v.recordId");
        console.log('recordId:------**************---------- '+recordId);
       /* component.find("navigationService").navigate({
            type: "standard__component",
            attributes: {
                componentName: "c__Phoenix_BidVIPRebateChangeRequest" },
            state: {
                c__recordId: recordId
                
            }
        }, true); */
         var evt = $A.get("e.force:navigateToComponent");
         evt.setParams({
             componentDef: "c:Phoenix_BidVIPRebateChangeRequest",
             componentAttributes: {
                 c__recordId : recordId
             }
         });
         evt.fire();    
     },
    
    
    
   

})