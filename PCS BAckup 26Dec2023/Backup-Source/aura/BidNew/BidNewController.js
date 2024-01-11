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
        console.log('BidRedirect init()');
        var recordId = component.get("v.recordId");
        console.log('recordId: ' + recordId);
        var pageRef = component.get("v.pageReference");
        var state = pageRef.state;
        var base64Context = state.inContextOfRef;
        if (base64Context.startsWith("1\.")) {
            base64Context = base64Context.substring(2);
        }
        var addressableContext = JSON.parse(window.atob(base64Context));
        alert(JSON.stringify(addressableContext));
        component.set("v.ParentrecordId", addressableContext.attributes.recordId);
        // $A.get('e.force:refreshView').fire();

        /*component.find("navigationService").navigate({
            type: "standard__component",
            attributes: {
                componentName: "c__Phoenix_BidEdit" },
            state: {
                c__recordId: recordId
               
            }
        }, true); // replace = true*/

    }
})