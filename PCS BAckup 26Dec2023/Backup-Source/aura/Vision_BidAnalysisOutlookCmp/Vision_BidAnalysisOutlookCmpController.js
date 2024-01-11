({
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
                        component.set("v.bidData", null);
                        component.set("v.onLoad", true);
                        component.set("v.loaded", false);
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
        console.log('Search Text: After select '+searchText);
        if(searchText){
            var searchRelatedData = component.get("v.searchRelatedData");
            for(var i=0; i<searchRelatedData.length; i++){
                if(searchRelatedData[i].Name == searchText){
                    component.set("v.searchText", searchRelatedData[i].Name);
                }
            }
            component.set("v.searchRelatedData", []);
            var action = component.get("c.getSelectedData");
            action.setParams({
                'searchText': searchText
            });
            action.setCallback(this, function(response){
                if(response.getState() == 'SUCCESS'){
                    console.log('Response:1 '+JSON.stringify(response.getReturnValue()));
                    component.set("v.loaded", false);
                    component.set("v.bidData", response.getReturnValue());
                    component.set("v.onLoad", false);
                    if(response.getReturnValue().length == 0){
                        component.set("v.noSearchData", true);
                    } else{
                        component.set("v.noSearchData", false);
                    }
                } else{
                    component.set("v.loaded", false);
                    component.set("v.onLoad", true);
                }
            });
            $A.enqueueAction(action);
        } else{
            component.set("v.bidData", null);
            component.set("v.onLoad", true);
            component.set("v.loaded", false);
            component.set("v.searchText", null);
            component.set("v.noSearchData", false);
        }
    },
    gotoBid: function(component, event, helper) {
        var bid = component.get("v.bidData");
        console.log('Bid Id: '+bid[0].Id);
        window.open('/lightning/r/Phoenix_Bid__c/'+bid[0].Id+'/view');
    },
    onSearchTextChange: function(component, event, helper){
        var searchText = component.get("v.searchText");
        console.log('Search Text changed');
        if(!searchText){
            component.set("v.bidData", null);
            component.set("v.onLoad", true);
            component.set("v.loaded", false);
            component.set("v.searchText", null);
            component.set("v.noSearchData", false);
        }
    }
})