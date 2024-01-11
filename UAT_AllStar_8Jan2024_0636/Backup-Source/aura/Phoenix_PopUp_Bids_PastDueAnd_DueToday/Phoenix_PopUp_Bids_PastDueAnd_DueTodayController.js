({
    doInit: function (component, event, helper) {
        component.set("v.isSpinnerLoad",false);
        var action = component.get("c.popUPBidsDue");    
        action.setCallback(this, function (response) {  
            if(response.getState() == "SUCCESS"){  
                component.set("v.isSpinnerLoad",false);
                var bidsdueToday=response.getReturnValue().bidsdueToday;
                var bidsPastDue=response.getReturnValue().bidsPastDue;
                var bidsdueTodaylength=response.getReturnValue().bidsdueTodaylength;
                var bidsPastDuelength=response.getReturnValue().bidsPastDuelength;
                var today=response.getReturnValue().today;
                component.set("v.bidsdueTodayList",bidsdueToday); 
                component.set("v.bidsPastDueList",bidsPastDue); 
                component.set("v.bidsdueTodaylength",bidsdueTodaylength); 
                component.set("v.bidsPastDuelength",bidsPastDuelength); 
            }
            
        });
        $A.enqueueAction(action);  
    },
    openModel: function(component, event, helper) {
        component.set("v.isModalOpen", false);
        var LineItemtable = component.get("v.tableRef");
        $A.util.addClass(LineItemtable, "maintable");
    }
})