({
    initRecords: function(component, event, helper) {
        //component.set('v.recordId', component.get("v.pageReference").state.c__id);
       // console.log('---record--id--from url-'+component.get('v.recordId')); 
         var action = component.get("c.getRelatedList");
        action.setParams
        ({
            bidId: "a070m000004Ydtp"
        });
        
        action.setCallback(this, function(response) 
                            {
                                var wrapperObj =  response.getReturnValue();
                                var lineItemsList = wrapperObj.lineItemsList;
                                var columnList = wrapperObj.columnList;
                                if(lineItemsList.length == 0 || component.get("v.recordId") == null){
                                    component.set("v.isRelatedLineItemsEmpty", false);
                                }
                                //component.set('v.columns', columnList);
                                console.log('columnList length----->'+columnList.length)
                                component.set("v.BidLineItemListAll",lineItemsList);
                                console.log('lineItemsList length----->'+lineItemsList.length);
                                 console.log('lineItemsList----->'+JSON.stringify(lineItemsList.length));
                            });
        //$A.enqueueAction(action);
    },
	showAllFirst : function(component, event, helper) {
		var flag = component.get("v.expandAllFirst");
        var flagExp=  component.get("v.expandFirst");
        component.set("v.expandFirst",!flagExp);
        component.set("v.expandAllFirst",!flag);
	},
    showAllSecond : function(component, event, helper) {
		var flag = component.get("v.expandAllSecond");
        var flagExp=  component.get("v.expandSecond");
        component.set("v.expandSecond",!flagExp);
        component.set("v.expandAllSecond",!flag);
	},
    showAllThird : function(component, event, helper) {
		var flag = component.get("v.expandAllThird");
        var flagExp=  component.get("v.expandThird");
        component.set("v.expandThird",!flagExp);
        component.set("v.expandAllThird",!flag);
	}
})