({
	sortHelper: function(component, event, sortFieldName) {
        var currentDir = component.get("v.isAsc");
        component.set("v.isAsc",!currentDir);
        /*    if (currentDir == 'arrowdown') {
            // set the arrowDirection attribute for conditionally rendred arrow sign  
            component.set("v.arrowDirection", 'arrowup');
            // set the isAsc flag to true for sort in Assending order.  
            component.set("v.isAsc", true);
        } else {
            component.set("v.arrowDirection", 'arrowdown');
            component.set("v.isAsc", false);
        }*/
        // call the onLoad function for call server side method with pass sortFieldName
        this.onSortResult(component, event, sortFieldName);
    },
    
    onSortResult: function(component, event, sortField) {
        //call apex class method
        //component.set("v.showSpinnerSelProds",true);
        console.log('IN child component sorting');
        var prodName = component.get("v.productName");
        var  selectedId = component.get("v.selectedId");
        var  showRecords =  component.get("v.showAll");
        var searchName = component.get("v.searchText");
        
        var action = component.get("c.fetchSortResults");
        
        //var Allaccount = component.get("v.Allaccount");
        action.setParams({
            'sortField': sortField,
            'isAsc': component.get("v.isAsc"),          
            'customer' : selectedId,
            'showAll' : showRecords,
            'searchText' : searchName
            
        });
        action.setCallback(this, function(response) {
            //store state of response
            if (response.getState() === "SUCCESS") {
                component.set('v.loaded',false);
                console.log('successsss');
                var responseWrapper=response.getReturnValue();
                console.log('responseWrapper>>'+JSON.stringify(responseWrapper));
                component.set("v.accGroupList",responseWrapper.accList);
                var cmpEvent = component.getEvent("RxBackOrderComponentEvent"); 
                //Set event attribute value
                cmpEvent.setParams({"accGroupList" :responseWrapper.accList,
                                    "isAsc" : component.get("v.isAsc")}); 
                cmpEvent.fire(); 
            } else{
                console.log("Error "+JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);
    },
    
})