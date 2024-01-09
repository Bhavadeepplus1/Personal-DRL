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
    doInit: function (component, event, helper) {
        var currentrecID = component.find('recordid').get("v.value");
        //var changevalue=component.find("ChecklistType").get("v.value");
        //alert(component.find("ChecklistType").get("v.value"))
console.log('record id is-->'+currentrecID);
        // calling server side action 
        var Getcondata = component.get("c.checkListRec");
        Getcondata.setParams({
            checklistid: currentrecID
        });
        Getcondata.setCallback(this, function (response) {

            var getstate = response.getState();
            if (getstate == 'SUCCESS') {
                if (response.getReturnValue().checklist == undefined) {
                    component.set("v.isChecklistExists", true);
                } else {
                    component.set("v.isChecklistExists", false);
                    var getres = response.getReturnValue().checklist.Checklist_Type__c;
                    component.set("v.recordId1", response.getReturnValue().checklist.Id);
                    if (getres == 'Rebate')
                        component.set("v.ChecklistTypeboolean", true);

                    else
                        component.set("v.ChecklistTypeboolean", false);
                    //alert('-=-=-=-'+getcodata);

                }
            }



        });
        $A.enqueueAction(Getcondata);



        /* */

    },
    Saverecord: function (component, event, helper) {
        //var currentrecID=component.find('recordid').get("v.value");
        // component.find("bid").set("v.value",currentrecID);

        component.find("ChecklistForm").submit();


    },
    handleOnSubmit: function (component, event, helper) {
        // var currentrecID=component.find('recordid').get("v.value");
        // component.find("bid").set("v.value",currentrecID);

    },
    handleOnSuccess: function (component, event, helper) {
        var params = event.getParams(); //get event params
        var checklistrecordId = params.response.id; //get record id

        if (checklistrecordId != null) {

            var currentrecID = component.find('recordid').get("v.value");
            var navEvt = $A.get("e.force:navigateToSObject");
            navEvt.setParams({
                "recordId": currentrecID,
                "slideDevName": "related"
            });
            navEvt.fire();
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Success!",
                "type": "success",
                "message": "The record has been Updated successfully."
            });
            toastEvent.fire();

            // alert('Record Id success -checklistrecordId==== ' + checklistrecordId); 
        }


    },
    handleOnError: function (component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Error!",
            "type": "error",
            "message": "The record has not been Updated."
        });
        toastEvent.fire();

    },
    Cancelrecord: function (component, event, helper) {
        var currentrecID = component.find('recordid').get("v.value");
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": currentrecID,
            "slideDevName": "related"
        });
        navEvt.fire();
    },
    ChecklistTypeChange: function (component, event, helper) {
        var changevalue = event.getSource().get("v.value");
        if (changevalue == 'Rebate')
            component.set("v.ChecklistTypeboolean", true);

        else
            component.set("v.ChecklistTypeboolean", false);

        //alert("&&&&&&&&&"+component.get("v.ChecklistTypeboolean"));
    }
})