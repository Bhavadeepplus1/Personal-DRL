/**
 * @description       : 
 * @author            : Surender Patel (Dhruvsoft)
 * @group             : 
 * @last modified on  : 29-05-2021
 * @last modified by  : Surender Patel (Dhruvsoft)
 * Modifications Log 
 * Ver   Date         Author                       Modification
 * 1.0   03-12-2020   Surender Patel (Dhruvsoft)   Initial Version
 **/
({
    doInit: function (component, event, currentRec) {
        var action = component.get("c.getTermsMatrix");
        action.setParams({
            "recordId": component.get("v.recordId")
        });

        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var wrapperObject = response.getReturnValue();
                component.set("v.WrapperObect", wrapperObject);
                // console.log("selected term matrixes--->" + component.find('select').get('v.value'));
                if (component.find('select').get('v.value') == 'none') {
                    component.set("v.isSelected", true);
                }
                //console.log("list of matrixes--->" + JSON.stringify(wrapperObject));


            } else if (state === "INCOMPLETE") {
                console.log("No response from server or client is offline.")

            } else if (state === "ERROR") {
                console.log("Error: ");
            }
        });
        $A.enqueueAction(action);
    },
    onChange: function (component, event, helper) {
        component.set("v.selectedTermMatrix", component.find('select').get('v.value'));
        if (component.find('select').get('v.value') == 'none') {
            component.set("v.isSelected", true);
        } else {
            component.set("v.isSelected", false);
        }

    },

})