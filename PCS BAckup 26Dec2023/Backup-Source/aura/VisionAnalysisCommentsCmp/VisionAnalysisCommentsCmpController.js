({
    doInit : function(component, event, helper) {
		
	},
    closeConfirm : function(component, event, helper) {
        component.set("v.isConfirmToDelete",false);
        component.set("v.editCommentMode",false);
	},
    saveComment : function(component, event, helper) {
        var action = component.get("c.updateComment");
            action.setParams({
                commentObj : component.get("v.commentObj")
            });
            action.setCallback(this, function (response) {
                console.log('State from saveComment :: '+response.getState());
                if (response.getState() == "SUCCESS") {
                    var respObj = response.getReturnValue();
                    component.set("v.commentObj",respObj);
                    component.set("v.isConfirmToDelete",false);
                    component.set("v.editCommentMode",false);
                }
                else {
                    console.log('Error while storing Comment.');
                }
            });
        $A.enqueueAction(action);
    },
    deleteCommentMethod : function(component, event, helper) {
        var action = component.get("c.deleteComment");
        action.setParams({
            commentObj : component.get("v.commentObj")
        });
        action.setCallback(this, function (response) {
            console.log('State from saveComment :: '+response.getState());
            if (response.getState() == "SUCCESS") {
                component.set("v.refreshComments",'REFRESH COMMENTS');
            }
            else {
                console.log('Error while storing Comment.');
            }
        });
        $A.enqueueAction(action);
    },
    editComment : function(component, event, helper) {
        component.set("v.editCommentMode",true);
    },
    askToDeleteComment : function(component, event, helper) {
        component.set("v.isConfirmToDelete",true);
    },
})