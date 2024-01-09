({
    sortBy: function(component, field) {
        var sortAsc = component.get("v.isAsc"),
            sortField = component.get("v.sortField"),
            records = component.get("v.shareExpansionList");
        sortAsc = field == sortField? !sortAsc: true;
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
        component.set("v.isAsc", sortAsc);
        component.set("v.shareExpansionList", records);
        component.set('v.isSpinner', false);
    }
})