({
	init : function(component, event, helper) {
         
          var pageReference = component.get("v.pageReference");
        //alert('called');
        if (pageReference && pageReference.state) {
        component.set("v.salesRepName",pageReference.state.c__salesRepName);
        component.set("v.selectedQuarter",pageReference.state.c__quarter);
        
        }
        
        
        console.log('salesrepname=='+component.get("v.salesRepName"));
        console.log('selected quarter=='+component.get("v.selectedQuarter"));
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
        helper.getCustomerName(component, event, helper);
        helper.getProducts(component, event, helper);
        if(pageReference.state.c__salesRepName != null){
           // helper.getData(component, event, helper)
        }
		 //component.set("v.isSpinnerLoad", true);
       
        
	},
     handleChange : function(component, event, helper) {
         console.log('Lookup component Id: ' + event.getParam("cmpId"));
       //cmp.set("v.chargebackList",'');
        var newId = component.get("v.selectedUserId");
         console.log('newId: ' + newId);
        component.set("v.UserId", newId);
       
         //helper.getData(component, event, helper)
          
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
    } ,
     searchbbyCustomer:function(component, event, helper){
         var customer = component.find("searchCustomer").get("v.value");
        component.set("v.customerName",customer);
        console.log('customer:::::'+customer);
    },
    collectData:function(component, event, helper){
         component.set("v.isSpinnerLoad",true)
         component.set("v.DirectSalesData",'');
       
       
    },
    ChangeDirectIndirect:function(component, event, helper){
        
        var selectval = component.get("v.selectedValue");
        if(selectval =='Direct Sales'){
            component.set("v.showDirectData",true);
            component.set("v.showIndirectData",false)
        }
        else
        {
            component.set("v.showDirectData",false);
            component.set("v.showIndirectData",true)
        }
        
    },
    searchMethod : function(component, event, helper){
        component.set("v.isSpinnerLoad",true);
        helper.getData(component, event, helper);
    }
    
})