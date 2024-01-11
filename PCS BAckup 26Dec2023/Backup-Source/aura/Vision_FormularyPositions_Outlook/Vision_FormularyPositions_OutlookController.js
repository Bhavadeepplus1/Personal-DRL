({
    getSelectedProduct: function(component, event, helper){
        console.log('Selected Row: '+JSON.stringify(event.currentTarget.dataset.productId));
    },
	getSearchData : function(component, event, helper) {
        component.set("v.loaded", true);
        var searchText = component.get("v.searchText");
        if(searchText){
            var action = component.get("c.getSearchRelatedData");
            action.setParams({
                'searchText': component.get("v.searchText")
            });
            action.setCallback(this, function(response){
                if(response.getState() == 'SUCCESS'){
                    console.log('Response:1 '+JSON.stringify(response.getReturnValue()));
                    component.set("v.loaded", false);
                    component.set("v.searchRelatedData", response.getReturnValue());
                    if(response.getReturnValue().length == 0){
                        component.set("v.noSearchData", true);
                    } else{
                        component.set("v.noSearchData", false);
                    }
                }
            });
            $A.enqueueAction(action);
        } else{
            component.set("v.searchRelatedData", []);
            component.set("v.searchText", null);
            component.set("v.loaded", false);
        }
	},
	filterData : function(component, event, helper) {
        component.set("v.loaded", true);
        var searchText = event.currentTarget.dataset.myid;
        console.log('Product Id: '+searchText);
        if(searchText){
            var searchRelatedData = component.get("v.searchRelatedData");
            for(var i=0; i<searchRelatedData.length; i++){
                if(searchRelatedData[i].Vision_Product__c == searchText){
                    component.set("v.searchText", searchRelatedData[i].Vision_Product__r.Name);
                }
            }
            component.set("v.searchRelatedData", []);
            var action = component.get("c.getPositions");
            action.setParams({
                'searchText': searchText
            });
            action.setCallback(this, function(response){
                if(response.getState() == 'SUCCESS'){
                    console.log('Response: '+JSON.stringify(response.getReturnValue()));
                    component.set("v.onLoad", false);
                    component.set("v.loaded", false);
                    component.set("v.positionsData", response.getReturnValue());
                }
            });
            $A.enqueueAction(action);
        } else{
            component.set("v.positionsData", []);
            component.set("v.onLoad", true);
            component.set("v.searchText", null);
            component.set("v.loaded", false);
        }
	},
    onSearchTextChange: function(component, event, helper){
        var searchText = component.get("v.searchText");
        if(!searchText){
            component.set("v.positionsData", []);
            component.set("v.onLoad", true);
            component.set("v.loaded", false);
            component.set("v.searchText", null);
            component.set("v.selectedProduct", null);
            component.set("v.searchRelatedData", []);
            component.set("v.noSearchData", false);
            console.log('Commit called');
        }
    }
})