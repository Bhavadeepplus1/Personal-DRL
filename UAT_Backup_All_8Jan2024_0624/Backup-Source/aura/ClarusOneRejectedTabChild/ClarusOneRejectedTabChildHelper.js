/**
 * @description       : 
 * @author            : Surender Patel (Dhruvsoft)
 * @group             : 
 * @last modified on  : 29-05-2021
 * @last modified by  : Surender Patel (Dhruvsoft)
 * Modifications Log 
 * Ver   Date         Author                       Modification
 * 1.0   29-05-2021   Surender Patel (Dhruvsoft)   Initial Version
**/
({
    fetchPickListVal: function (component, fieldName, picklistOptsAttributeName) {
        var action = component.get("c.getselectOptions");
        action.setParams({
            "objObject": component.get("v.objInfoForPicklistValues"),
            "fld": fieldName
        });
        var opts = [];
        $A.enqueueAction(action);
    },
    getCalculations: function (component, event, helper, currentValue, fieldName, isGuidancePrice, isWMTDirectPrice, isWMTindirectPrice, isMacRADOSPrice) {
        var LineItem = component.get("v.singleRec");
        var bidType = component.get("v.bidType");
        var LineItemId = LineItem.Id;
        var WAC = LineItem.Phoenix_WAC__c;
        var proposedWMTDirectPrice = LineItem.Phoenix_Proposed_WMT_Direct_NCP__c;
        var proposedWMTIndirectPrice = LineItem.Phoenix_Proposed_WMT_Indirect_NCP__c;
        var proposedMckOSRADProce = LineItem.Phoenix_Proposed_McK_OS_And_RAD_NCP__c;
        var msg = isWMTDirectPrice ? 'WMT Direct Price can not be greater than WAC ($' + LineItem.Phoenix_WAC__c + ')' : isWMTindirectPrice ? 'WMT Indirect Price can not be greater than WAC ($' + LineItem.Phoenix_WAC__c + ')' : isMacRADOSPrice ? 'Mack OS RAD Price can not be greater than WAC ($' + LineItem.Phoenix_WAC__c + ')' : '';
        if ((WAC < proposedWMTDirectPrice || WAC < proposedWMTIndirectPrice || WAC < proposedMckOSRADProce) && !isGuidancePrice) {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type": "Error",
                "title": "Error",
                "message": msg
            });
            toastEvent.fire();
            if (WAC < proposedWMTDirectPrice)
                component.set("v.singleRec.Phoenix_Proposed_WMT_Direct_NCP__c", null);
            if (WAC < proposedWMTIndirectPrice)
                component.set("v.singleRec.Phoenix_Proposed_WMT_Indirect_NCP__c", null)
            if (WAC < proposedMckOSRADProce)
                component.set("v.singleRec.Phoenix_Proposed_McK_OS_And_RAD_NCP__c", null)
            var action = component.get("c.getCalcs");
            action.setParams({
                LineItem: LineItem,
                LineItemId: LineItemId,
                currentValue: currentValue,
                fieldLabel: fieldName
            });
            action.setCallback(this, function (response) {
                if (response.getState() === 'SUCCESS') {
                    console.log('calc response--' + JSON.stringify(response.getReturnValue()));
                    component.set("v.singleRec", response.getReturnValue());
                    var latestEstimate = component.get("v.singleRec.Phoenix_Latest_Estimate__c") != null ? component.get("v.singleRec.Phoenix_Latest_Estimate__c") : 0;
                    var BudgetedASP = component.get("v.singleRec.Phoenix_Budgeted_ASP1__c") != null ? component.get("v.singleRec.Phoenix_Budgeted_ASP1__c") : 0;
                    var Deadnet = component.get("v.singleRec.Phoenix_Internal_Dead_Net_Price__c") != null ? component.get("v.singleRec.Phoenix_Internal_Dead_Net_Price__c") : 0;
                    if (latestEstimate > 0) {
                        var isAccpetable = ((latestEstimate / 100) * 10 + latestEstimate) < Deadnet ? true : false;
                        var isNotAccpetable = (latestEstimate - (latestEstimate / 100) * 10) < Deadnet ? true : false;
                        component.set("v.isAccpetable", isAccpetable);
                        component.set("v.isNotAccpetable", isNotAccpetable);
                    } else if (BudgetedASP > 0) {
                        var isAccpetable = ((BudgetedASP / 100) * 10 + BudgetedASP) < Deadnet ? true : false;
                        var isNotAccpetable = (BudgetedASP - (BudgetedASP / 100) * 10) < Deadnet ? true : false;
                        component.set("v.isAccpetable", isAccpetable);
                        component.set("v.isNotAccpetable", isNotAccpetable);
                    } else {
                        console.log('else condition--->')
                        component.set("v.isAccpetable", false);
                        component.set("v.isNotAccpetable", false);
                    }


                    var event = component.getEvent("calcEvent");
                    event.fire();
                    //component.set("v.isSpinner",false);
                } else {
                    //component.set("v.isSpinner",false);
                }

            });
            $A.enqueueAction(action);
        }

        var action = component.get("c.getCalcs");
        action.setParams({
            LineItem: LineItem,
            LineItemId: LineItemId,
            currentValue: currentValue,
            fieldLabel: fieldName
        });
        action.setCallback(this, function (response) {
            if (response.getState() === 'SUCCESS') {
                console.log('calc response--' + JSON.stringify(response.getReturnValue()));
                component.set("v.singleRec", response.getReturnValue());
                var event = component.getEvent("calcEvent");
                var latestEstimate = component.get("v.singleRec.Phoenix_Latest_Estimate__c") != null ? component.get("v.singleRec.Phoenix_Latest_Estimate__c") : 0;
                var BudgetedASP = component.get("v.singleRec.Phoenix_Budgeted_ASP1__c") != null ? component.get("v.singleRec.Phoenix_Budgeted_ASP1__c") : 0;
                var Deadnet = component.get("v.singleRec.Phoenix_Internal_Dead_Net_Price__c") != null ? component.get("v.singleRec.Phoenix_Internal_Dead_Net_Price__c") : 0;
                if (latestEstimate > 0) {
                    var isAccpetable = ((latestEstimate / 100) * 10 + latestEstimate) < Deadnet ? true : false;
                    var isNotAccpetable = (latestEstimate - (latestEstimate / 100) * 10) < Deadnet ? true : false;
                    component.set("v.isAccpetable", isAccpetable);
                    component.set("v.isNotAccpetable", isNotAccpetable);
                } else if (BudgetedASP > 0) {
                    var isAccpetable = ((BudgetedASP / 100) * 10 + BudgetedASP) < Deadnet ? true : false;
                    var isNotAccpetable = (BudgetedASP - (BudgetedASP / 100) * 10) < Deadnet ? true : false;
                    component.set("v.isAccpetable", isAccpetable);
                    component.set("v.isNotAccpetable", isNotAccpetable);
                } else {
                    console.log('else condition--->')
                    component.set("v.isAccpetable", false);
                    component.set("v.isNotAccpetable", false);
                }

                event.fire();
                //component.set("v.isSpinner",false);
            } else {
                //component.set("v.isSpinner",false);
            }

        });
        $A.enqueueAction(action);

    }
})