({
	sortHelper: function(component, event, sortFieldName) {
       // var currentDir = component.get("v.isAsc");
       // component.set("v.isAsc",!currentDir);
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
        component.set("v.showSpinnerSelProds",true);
        //component.set("v.selectAll",true);
        console.log('sortField: '+sortField);
        console.log('isAsc: '+component.get("v.isAsc"));
      //  var action = component.get('c.fetchSortResults');
        var salesList = component.get("v.singleRec.childSalesList");
      
         var currentDir = component.get("v.isAsc");
        component.set("v.isAsc",!currentDir);
        console.log('sort console---'+!currentDir);
        var key = function(a) { return a[sortField]; }
            var reverse = currentDir ? 1: -1;
        salesList.sort(function(a,b){
                    var a = key(a) ? key(a) : '';
                    var b = key(b) ? key(b) : '';
                    return reverse * ((a>b) - (b>a));
                });
        component.set("v.singleRec.childSalesList", salesList);
        component.set("v.showSpinnerSelProds",false);
        

    //    });
     //s   $A.enqueueAction(action);
    },
})