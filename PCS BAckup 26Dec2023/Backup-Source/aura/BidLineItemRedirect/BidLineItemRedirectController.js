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
    init: function (component, event, helper) {
        console.log('BidLineItemEditDemoCmpredirect init()');
        var recordId = component.get("v.recordId");
        console.log('recordId: ' + recordId);
        //$A.get('e.force:refreshView').fire();

        component.find("navigationService").navigate({
            type: "standard__component",
            attributes: {
                componentName: "c__BidLineItemEditDemoCmp"
            },
            state: {
                c__recordId: recordId,
                c__isClone: false
            }
        }, true); // replace = true

    }
})