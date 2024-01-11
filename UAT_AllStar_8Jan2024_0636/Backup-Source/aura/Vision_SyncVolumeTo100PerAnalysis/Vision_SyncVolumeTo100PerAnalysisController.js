({
    doInit : function(component, event, helper){
        if(component.get("v.bidType") == 'RFP Bids')
            component.set("v.isFullLineConfirm",true);
        else
            component.set("v.askToPopInAnalysis",true);
    }, 
	askToPopulateNo : function(component, event, helper){
        component.set("v.isFullLineRfpBid",false);
        component.set("v.isFullLineConfirm",false);
        component.set("v.askToPopInAnalysis",true);
    },
    askToPopulate : function(component, event, helper){
        component.set("v.isFullLineRfpBid",true);
        component.set("v.isFullLineConfirm",false);
        component.set("v.askToPopInAnalysis",true);
    },
    notSyncSelected : function(component, event, helper){
        component.set("v.syncConfirmed",'CONFIRMED');
    },
    fullLineSelected : function(component, event, helper){
        var action = component.get("c.syncVolToAnalysis");
        action.setParams({
            bidId: component.get("v.bidId"),
            accId:component.get("v.accId"),
            isFullLineRfp: component.get("v.isFullLineRfpBid")
        });
        action.setCallback(this, function(response) {
            component.set("v.syncConfirmed",'CONFIRMED');
        });
        $A.enqueueAction(action);
    },
    closeSync : function(component, event, helper){
        component.set("v.showSyncPopup",false);
    }
})