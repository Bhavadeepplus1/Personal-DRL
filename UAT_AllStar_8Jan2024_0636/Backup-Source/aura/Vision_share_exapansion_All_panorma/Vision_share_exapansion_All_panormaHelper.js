({
    sortBy: function(component, field) {
        var sortAsc = component.get("v.isAsc"),
            sortField = component.get("v.sortField"),
            records = component.get("v.shareExpansionList");
        
        console.log('--isAsc--'+sortAsc);
        console.log('--sortField--'+sortField);
        //console.log('--records--'+JSON.stringify(records));
        sortAsc = field == sortField? !sortAsc: true;
        console.log('--sortAsc--'+sortAsc);
        /*records.forEach(function(wrapObj){
            if(wrapObj['expnList'].length > 0){
                wrapObj['expnList'].sort(function(a,b){
                    var t1 = a[field] == b[field],
                        t2 = (!a[field] && b[field]) || (a[field] < b[field]);
                    console.log(' -- res --- ',t1? 0: (sortAsc?-1:1)*(t2?1:-1));
                    return t1? 0: (sortAsc?-1:1)*(t2?1:-1);
                });
            }
            
        });*/
        /*records.sort(function(a,b){
            var t1 = a[field] == b[field],
                t2 = (!a[field] && b[field]) || (a[field] < b[field]);
            console.log(' -- res --- ',t1? 0: (sortAsc?-1:1)*(t2?1:-1));
            return t1? 0: (sortAsc?-1:1)*(t2?1:-1);
        });*/
        console.log('--records--'+JSON.stringify(records));
        component.set("v.isAsc", sortAsc);
        component.set("v.shareExpansionList", records);
        component.set('v.isSpinner', false);
    },
     sortHelper: function(component, event, sortFieldName) {
        var currentDir = component.get("v.isAscend");
        component.set("v.isAscend",!currentDir);

        this.onSortResult(component, event, sortFieldName);
    },
        onSortResult: function(component, event, sortField) {
        //call apex class method
        //component.set("v.showSpinnerSelProds",true);
       // var prodName = component.get("v.productName");
        //var  selectedId = component.get("v.selectedId");
       // console.log('sortField: '+sortField);
      //  console.log('prodName: '+prodName);  
       // console.log('isAsc: '+ component.get("v.isAsc"));
        var action = component.get("c.fetchSortResults");
        component.set("v.isSpinner",true);
        //var Allaccount = component.get("v.Allaccount");
        action.setParams({
            'sortField': sortField,
            'isAsc': component.get("v.isAscend"),
            picliList :component.get('v.TaskStatusList')
            
        });
        action.setCallback(this, function(response) {
            //store state of response
            if (response.getState() === "SUCCESS") {
            component.set("v.isSpinner",false);
                console.log('successsss');
                var responseWrapper=response.getReturnValue();
                console.log('responseWrapper>>'+JSON.stringify(responseWrapper));
  
                component.set("v.shareExpansionList", responseWrapper); 

       
            } else{
                component.set("v.isSpinner",false);
                console.log("Error "+JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);
    },
    
})