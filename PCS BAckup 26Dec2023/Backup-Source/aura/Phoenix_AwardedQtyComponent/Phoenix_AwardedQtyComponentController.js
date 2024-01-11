({
    doInit: function (component, event, helper) {
        console.log('awarded component..');
        var custresId=component.get("v.CustResLineId");
        var action = component.get("c.getPositions");
        action.setParams({
            'custresId':custresId   
        });
        action.setCallback(this, function (response) {
            if (response.getState() === "SUCCESS") {
                var responseList = response.getReturnValue();
                
                
                var list=[];
                var sumofAllAwardedQty=0;
                responseList.forEach(function(eachRecord) {
                    var eachRecAwaQty=eachRecord.Phoenix_Awarded_Quantity__c;
                    if(eachRecAwaQty == null){
                        eachRecAwaQty=0;
                    }
                    sumofAllAwardedQty=sumofAllAwardedQty+eachRecAwaQty;
                    list.push(eachRecAwaQty);
                });
                console.log('list'+list);
                console.log('sumofAllAwardedQty'+sumofAllAwardedQty);
                
                component.set("v.sumofAllAwardedQty",sumofAllAwardedQty);
                component.set("v.responseList",responseList);
                
                
                component.set("v.responseLen",responseList.length);
                // component.set("v.responseList",responseList);
                var slctpositions;
                /*if (component.get('v.singleRec.Phoenix_Proposed_Position__c') != null) {
                    slctpositions = component.get('v.singleRec.Phoenix_Proposed_Position__c').split(',');
                    console.log('slctpositions--' + slctpositions);
                   
                }
                for (var i = 0; i < responseList.length; i++) {
                    var row = responseList[i];
                    //if (row.Phoenix_Customer__c) {
                      //  row.Phoenix_Customer__c = row.Phoenix_Customer__r.Name;
                    //}
                }
                //component.set("v.LinepositionsList", responseList);
                */
            }
            
            
        });
        $A.enqueueAction(action);
        helper.getTotalQtyData(component, event, helper);
        
    },
    showSelectedproducts: function (component, event, helper) {
        component.set("v.isModalOpen", true);
        
    },
    closePopup: function (component, event, helper) {
        //component.set("v.isModalOpen", false);
        component.set("v.bindBoolean", false);
    },
    onChildAttrChange: function(cmp, evt) {
        console.log("childAttr has changed");
        console.log("old value: " + evt.getParam("oldValue"));
        console.log("current value: " + evt.getParam("value"));
    },
    
    
    inlineEditOverrideUnits : function(component,event,helper){  
        component.set("v.OverrideUnitsEditMode", true);
        //setTimeout(function(){
        //  component.find("OverrideUnits").focus();
        //}, 100);
    },
    closeOverrideUnits: function (component, event, helper) {       
        component.set("v.OverrideUnitsEditMode", false);        
    },
    handleSaveEdition: function (component, event, helper) {
        var draftValues = component.get("v.responseList");
        var err;
        var picklistsize=component.get("v.getPicklistValues");
        
        console.log('picklistsize'+picklistsize);
        console.log(draftValues);
        if(picklistsize != null ){
            for(var i = 0; i < draftValues.length; i++){
                console.log('draftValues[i].Phoenix_Awarded_Quantity__c ::: '+draftValues[i].Phoenix_Awarded_Quantity__c);
                if(draftValues[i].Phoenix_Awarded_Quantity__c != 0 && ( draftValues[i].Phoenix_Awarded_Quantity__c == '' || draftValues[i].Phoenix_Awarded_Quantity__c == undefined ||  draftValues[i].Phoenix_Awarded_Quantity__c == null)){
                    console.log(':::: inside validation ::::');
                    err="error";
                    var errMsg = 'Please enter Awarded quantity to each contract to proceed furthur.';
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error",
                        "message":errMsg,
                        "type":"Error",
                        "mode":"dismissible"
                    });
                    toastEvent.fire();
                }
                if(draftValues[i].Phoenix_Awarded_Position__c == '' || draftValues[i].Phoenix_Awarded_Position__c == 'None'){
                    err="error";
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error",
                        "message":"Please confirm each position to proceed furthur.",
                        "type":"Error",
                        "mode":"dismissible"
                    });
                    toastEvent.fire();
                }
            }
        }
        if(err != "error"){
            var RemainingAllocationQTY=component.get("v.remQtyToAward");
            if(RemainingAllocationQTY == 0)
            {
                var action = component.get("c.updateAccount");
                action.setParams({"AwardedQtyRec" : draftValues});
                action.setCallback(this, function(response) {
                    var state = response.getState();
                    if(state="Success"){
                        component.set("v.isModalOpen", false);
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Success!",
                            "message":"Awarded quantity records created/updated successfully.",
                            "type":"success",
                            "mode":"dismissible"
                        });
                        toastEvent.fire();
                        component.set("v.bindBoolean", false);
                        //$A.get('e.force:refreshView').fire();
                    }
                });
                $A.enqueueAction(action);
                
                
            }
            else
            {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error",
                    "message":"Please check the awarded quantity distribution.",
                    "type":"Error",
                    "mode":"dismissible"
                });
                toastEvent.fire();
                
            }
        }
    }
    
})