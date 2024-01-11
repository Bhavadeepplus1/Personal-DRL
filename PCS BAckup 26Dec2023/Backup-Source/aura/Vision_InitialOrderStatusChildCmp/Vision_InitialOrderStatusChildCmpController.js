({
    inlineEditComments : function(component, event, helper){
        var showComments = component.get("v.showComments");
        if(showComments){
            component.set("v.showComments", false);	    
        } else{
            component.set("v.listOfCmnts", []);
            console.log('Record: '+component.get("v.item.Id")+'Comments initially: '+JSON.stringify(component.get("v.listOfCmnts")));
            component.set("v.showComments", true);
            var action = component.get("c.updateInitialOrderComments");
            action.setParams({
                'comment': '',
                'record': component.get("v.item")
            });
            action.setCallback(this, function(response){
                if(response.getState() == 'SUCCESS'){
                    var resp = response.getReturnValue();
                    component.set("v.listOfCmnts", resp);
                    console.log('Comments: '+JSON.stringify(resp));
                } else{
                    console.log("Error in saving comments: "+JSON.stringify(response.getError()));
                }
            });
            $A.enqueueAction(action);
        }	
        /*var index = event.currentTarget.id;
        helper.getCommentsHelper(component, event, helper);*/
    },
    closeCommentPopup: function(component, event, helper){
        component.set("v.showComments", false);
    },
    onSaveCmnt: function(component, event, helper){
        var comment = component.get("v.visionComment");
        console.log('Comment is: '+comment);
        if(comment){
            var action = component.get("c.updateInitialOrderComments");
            action.setParams({
                'comment': comment,
                'record': component.get("v.item")
            });
            action.setCallback(this, function(response){
                if(response.getState() == 'SUCCESS'){
                    var resp = response.getReturnValue();
                    component.set("v.listOfCmnts", resp);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "message": "Comment saved successfully.",
                        "type": "success",
                        "mode": "dismissible"
                    });
                    toastEvent.fire();
                    component.set("v.visionComment", '');
                } else{
                    console.log("Error in saving comments: "+JSON.stringify(response.getError()));
                }
            });
            $A.enqueueAction(action);   
        }
    }
})