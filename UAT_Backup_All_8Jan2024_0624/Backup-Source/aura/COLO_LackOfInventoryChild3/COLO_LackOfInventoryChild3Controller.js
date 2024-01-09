({
    doInit : function(component, event, helper) {
        var product = component.get("v.product");
        if(product.Phoenix_SCM_Rejection_Reason1__c != null){
            component.set("v.scmRejectionReasons", product.Phoenix_SCM_Rejection_Reason1__c);
            component.set("v.updatedRejectionReasons", product.Phoenix_SCM_Rejection_Reason1__c);
        }
    },
	onReasonChange : function(component, event, helper) {
		var scmRejectionReasons = component.get("v.scmRejectionReasons");
	},
    openSCMRejectionReasonsPopup : function(component, event, helper) {
		component.set("v.showSCMRejectionCommentPopup", !component.get("v.showSCMRejectionCommentPopup"));
	},
    saveSCMRejectionReason: function(component, event, helper) {
		component.set("v.scmRejectionReasons", component.get("v.updatedRejectionReasons"));
		component.set("v.showSCMRejectionCommentPopup", !component.get("v.showSCMRejectionCommentPopup"));
	},
})