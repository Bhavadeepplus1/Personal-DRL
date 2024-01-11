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
        console.log('---------currentrecID-----' + currentrecID);
        // component.find("bid").set("v.value",currentrecID);
        console.log('---------currentrecID--*********---');

        // calling server side action 
        var accountdata = component.get("c.getBid");
        accountdata.setParams({
            bidId: currentrecID
        });
        accountdata.setCallback(this, function (response) {
            console.log('---------currentrecID---&&&&&&&&&&--');
            var getstate = response.getState();
            console.log('---getstate------' + getstate);
            if (getstate == 'SUCCESS') {
                console.log(response.getReturnValue().bidRecord.Phoenix_Is_Checklist_Exist__c);
                if (response.getReturnValue().bidRecord.Phoenix_Is_Checklist_Exist__c == false) {


                    component.set("v.isChecklistExists", false);
                    console.log('---------currentrecID-00000000000-' + component.get("v.isChecklistExists"));

                    var wrapperObj = response.getReturnValue();
                    var bidRecord = wrapperObj.bidRecord;
                    var accountId = wrapperObj.bidRecord.Phoenix_Customer__c;
                    component.find("bid").set("v.value", bidRecord.Id);
                    var bidType = wrapperObj.bidRecord.Phoenix_Bid_Type__c;
                    var contrType = wrapperObj.bidRecord.Phoenix_Contract_Workflow_Type__c;
                    var contrNum = wrapperObj.bidRecord.Phoenix_Current_Contract__c;
                    if (bidType == 'Contracts Only') {
                        component.set("v.bidType", bidType);
                        component.set("v.contrType", contrType);
                        component.set("v.contrNum", contrNum);

                    }
                    // var getresult = response.getReturnValue();
                    //alert(getresult);
                    component.find("accid").set("v.value", accountId);
                    //  component.find("accid").set("v.value",accountId);
                    var conDocument = wrapperObj.conDocLink;
                    var fileList = [];
                    var totalFiles = [];
                    var checked = false;
                    totalFiles = wrapperObj.conDocLink;
                    if (totalFiles != undefined && totalFiles != null) {
                        for (var i = 0; i < totalFiles.length; i++) {
                            fileList.push({
                                "Id": totalFiles[i].ContentDocumentId,
                                "Title": totalFiles[i].ContentDocument.Title + '.' + totalFiles[i].ContentDocument.FileExtension,
                                "checked": checked
                            });
                        }
                    }
                    component.set("v.fileList", fileList);
                    console.log('---1------');
                } else {
                    component.set("v.isChecklistExists", true);


                }


            }

        });
        $A.enqueueAction(accountdata);

    },
    Saverecord: function (component, event, helper) {
        var currentrecID = component.find('recordid').get("v.value");
        component.find("bid").set("v.value", currentrecID);
        component.find("ChecklistForm").submit();


    },
    handleOnSubmit: function (component, event, helper) {
        var currentrecID = component.find('recordid').get("v.value");
        component.find("bid").set("v.value", currentrecID);

    },
    handleOnSuccess: function (component, event, helper) {
        var params = event.getParams(); //get event params
        var checklistrecordId = params.response.id; //get record id


        if (checklistrecordId != null) {

            var currentrecID = component.get("v.recordId");
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
                "message": "The record has been created successfully."
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
            "message": "The record has not been Created."
        });
        toastEvent.fire();

    },
    Cancelrecord: function (component, event, helper) {
        // Close the action panel
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
    },
    ChecklistTypeChange: function (component, event, helper) {
        var changevalue = event.getSource().get("v.value");
        if (changevalue == 'Rebate')
            component.set("v.ChecklistTypeboolean", true);

        else
            component.set("v.ChecklistTypeboolean", false);

        //alert("&&&&&&&&&"+component.get("v.ChecklistTypeboolean"));
    },

    //-------------handling after completion of upload------------
    handleUploadFinished: function (component, event) {
        var action = component.get('c.getDocs');
        action.setParams({
            'bidId': component.get("v.recordId")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var fileList = [];
                var totalFiles = [];
                var checked = false;
                totalFiles = response.getReturnValue();
                if (totalFiles != undefined && totalFiles != null) {
                    for (var i = 0; i < totalFiles.length; i++) {
                        fileList.push({
                            "Id": totalFiles[i].ContentDocumentId,
                            "Title": totalFiles[i].ContentDocument.Title + '.' + totalFiles[i].ContentDocument.FileExtension,
                            "checked": checked
                        });
                    }
                }
                component.set("v.fileList", fileList);
            }
        });
        $A.enqueueAction(action);
    },

    //-------------deletion of uploaded document------------

    deleteAttachment: function (component, event, helper) {
        // let pageReference = component.get("v.pageReference");
        let recordId = component.get("v.recordId");
        // component.set("v.recordId",recordId);
        var selectedRec = event.getSource().get("v.name");
        console.log('selectedRec--->' + selectedRec);
        var target = event.target;
        var action = component.get("c.deleteAttachments");
        console.log('action--->');
        action.setParams({
            'selAttachId': selectedRec,
            'bidId': recordId
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state == 'SUCCESS') {}

        });
        $A.enqueueAction(action);
        var event = component.getEvent("lightningEvent");
        event.setParam("message", "the message to send");
        event.fire();

        var AllRowsList = component.get("v.fileList");
        if (AllRowsList.length === 1) {
            console.log('AllRowsList.length === 1');
        }
        for (let i = 0; i < AllRowsList.length; i++) {
            var pItem = AllRowsList[i];
            if (pItem.Id == selectedRec) {
                var index = AllRowsList.indexOf(pItem);
                if (index > -1) {
                    AllRowsList.splice(index, 1);
                    var AllRowsList1 = AllRowsList;
                }
            }
        }
        component.set("v.fileList", []);
        component.set("v.fileList", AllRowsList);

    }
})