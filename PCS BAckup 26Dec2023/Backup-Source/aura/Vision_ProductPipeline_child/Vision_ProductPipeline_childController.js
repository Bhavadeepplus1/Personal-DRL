({
	doInit : function(component, event, helper) {
	var response = component.get("v.OTCGroupList");	
        component.set("v.OTCGroupList1",response);	
        
	var response1 = component.get("v.OTCGroupList1");	
        
       console.log('response child----- '+JSON.stringify(response));
               console.log('response child----- '+JSON.stringify(response));
                       console.log('response1 child----- '+JSON.stringify(response1));


	}
})