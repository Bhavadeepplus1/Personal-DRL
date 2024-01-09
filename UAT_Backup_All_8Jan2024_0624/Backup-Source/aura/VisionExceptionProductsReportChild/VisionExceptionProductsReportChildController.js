({
    doInit: function(component, event, helper){
        var data = component.get("v.data");
        var family = component.get("v.family");
        var relatedList = data[family].wrapper;
        var familyIds = component.get("v.familyIds");
        console.log('Family Ids: '+JSON.stringify(familyIds));
        component.set("v.familyId", familyIds[family]);
        component.set("v.summaryMap", data[family].summaryMap);
        component.set("v.isSalesNull", data[family].isSalesNull);
        if(component.get("v.isAsc")){
            relatedList = relatedList.sort((a, b) => parseFloat(a.daysSinceLastBid) - parseFloat(b.daysSinceLastBid));
        } else{
         	relatedList = relatedList.sort((a, b) => parseFloat(b.daysSinceLastBid) - parseFloat(a.daysSinceLastBid));   
        }
        component.set("v.relatedList", relatedList);
    },
    showDropDown: function(component, event, helper){
        var expandFamily = component.get("v.expandFamily");
        if(expandFamily){
            component.set("v.expandFamily", false);
            component.set("v.showDrawer", false);
        } else{
            component.set("v.expandFamily", true);
            component.set("v.showDrawer", true);
        }
    },
    handleClick: function(component, event, helper){
        var val = event.getSource().get("v.value");
        var relatedList = component.get("v.relatedList");
        if(relatedList != null){
            for(var i=0; i<relatedList.length; i++){
                if(relatedList[i].product.Id == val){
                    if(relatedList[i].showDrawer){
                        relatedList[i].showDrawer = false;
                    } else{
                        relatedList[i].showDrawer = true;
                    }
                }
            }
        }
        relatedList.sort((a, b) => parseFloat(b.daysSinceLastBid) - parseFloat(a.daysSinceLastBid));
        component.set("v.relatedList", relatedList);
    }
})