({
	doInit : function(component,event,helper) {
        var recordId=component.get("v.recordId");
        
      
	},
                 
   
    getData:  function(component,event,helper) {
         console.log('selectedLookUpAccount-----'+component.get("v.accountId"));
         console.log('selectedLookUpProduct-----'+component.get("v.productId"));
        //helper.loadHistoricalData(component, helper);  
    },
    closePopup:function(component,event,helper){
        //var isCustomerLink=component.get("v.isCustomerLink");
        //var isCustomerGroupLink=component.get("v.isCustomerGroupLink");
       component.set("v.IsModalopen",false);
    },
    customerPricing: function(component,event,helper){
        component.set("v.noData",false);
          component.set("v.IsModalopen",true);
        console.log('IsModalopen'+component.get("v.IsModalopen"));
        component.set("v.isCustomerLink",true);
         console.log('isCustomerLink'+component.get("v.isCustomerLink"));
         component.set("v.isCustomerGroupLink",false);
        helper.loadHistoricalData(component,helper);
        
    },
    customerGroupPricing: function(component,event,helper){
           component.set("v.noData",false);
        component.set("v.IsModalopen",true);
        component.set("v.isCustomerGroupLink",true);
         component.set("v.isCustomerLink",false);
         helper.loadHistoricalData(component,helper);
    }
})