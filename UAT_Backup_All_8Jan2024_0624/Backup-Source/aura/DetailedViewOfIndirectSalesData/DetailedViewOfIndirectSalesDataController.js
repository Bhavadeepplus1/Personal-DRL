({
	init : function(component, event, helper) {
         
         var pageReference = component.get("v.pageReference");
       
        if (pageReference && pageReference.state) {
        component.set("v.salesRepName",pageReference.state.c__salesRepName);
        component.set("v.selectedQuarter",pageReference.state.c__quarter);
        
        }
         console.log('in init==>'+component.get("v.salesRepName"))
         if(component.get("v.selectedQuarter").includes('Quarter 1')){
            component.set('v.Quarter','Quarter1')
        }else if(component.get("v.selectedQuarter").includes('Quarter 2')){
            component.set('v.Quarter','Quarter2')
        }else if(component.get("v.selectedQuarter").includes('Quarter 3')){
            component.set('v.Quarter','Quarter3')
        }else if(component.get("v.selectedQuarter").includes('Quarter 4')){
            component.set('v.Quarter','Quarter4')
        }else if(component.get("v.selectedQuarter").includes('Annual')){
             component.set('v.Quarter','Annual')
        }
        component.set("v.isSpinnerLoad", true);
        helper.getContractsName(component, event, helper);
        helper.getCustomerName(component, event, helper);
        helper.getProducts(component, event, helper);
         //helper.getData(component, event, helper)
	},
    searchbbyCustomer:function(component, event, helper){
         var customer = component.find("searchCustomer").get("v.value");
        component.set("v.customerName",customer);
        console.log('customer:::::'+customer);
    },
     searchMethod : function(component, event, helper){
        //component.set("v.isSpinnerLoad",true);
        helper.getData(component, event, helper);
    },
    
    redirectToLeaderboard : function(component, event, helper) {
        component.set('v.loaded', true);
      var navService = component.find("navService");
        var pageReference = {
            "type": "standard__component",
            "attributes": {
                "componentName": "c__LeaderBoardMainCmp"  // c__YourComponentName
            }
            
        }
     
        navService.navigate(pageReference);
         component.set('v.loaded', false);
         component.set("v.salesRepName",'');
    },
    
})