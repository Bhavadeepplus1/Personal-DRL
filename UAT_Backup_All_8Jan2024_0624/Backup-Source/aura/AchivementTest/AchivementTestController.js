({
	init : function(component, event, helper) {
        
        alert('success');
        var action = component.get("c.getAnnualWestData");
        
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state=='SUCCESS')
            {
                component.set("v.WestSalesRepData",response.getReturnValue());
            }
            
        });
        $A.enqueueAction(action);
        
        
        var action1 = component.get("c.getAnnualEastData");
        
        action1.setCallback(this,function(response){
            var state = response.getState();
            if(state=='SUCCESS')
            {
                component.set("v.EastSalesRepData",response.getReturnValue());
            }
            
        });
        $A.enqueueAction(action1);
        
	},
    
    
    myAction : function(component, event, helper) {
		
	}
    
})