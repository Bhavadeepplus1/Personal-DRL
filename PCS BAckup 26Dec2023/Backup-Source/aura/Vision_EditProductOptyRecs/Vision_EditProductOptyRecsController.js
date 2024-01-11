({
    doInit : function(component, event, helper) {
        let recordId;
        if(component.get("v.recordId")){
            recordId = component.get("v.recordId");
        }
        else{
            let pageReference = component.get("v.pageReference");
            recordId = pageReference.state.c__recordId;
        }
        component.set("v.optyId", recordId);
        var action = component.get("c.fetchPrdOptyRecs");
        console.log('recordId Edit Page : '+recordId);
        //console.log('recordId Edit Page 2 : '+recordId);
        action.setParams({
            'optyId': recordId
        });
        action.setCallback(this, function(response){
            if(response.getState() == 'SUCCESS'){
                component.set("v.showSpinnerSelProds",false);
                console.log('recordId : '+recordId);
                var resp = JSON.parse(response.getReturnValue());
                console.log('Response when record is saved for first time:: '+JSON.stringify(resp));
                if(resp.oppIdData.OppId != null){
                    component.set("v.showSelectedProducts", false);
                    component.set("v.showSavedSelectedProducts", true);
                    component.set("v.isRecordSaved", true);
                    component.set("v.QLlistSaved", resp.savedProducts);
                    component.set("v.listOfCompetitors", resp.competitorObjInfo);
                    console.log('QLList Saved::: '+JSON.stringify(component.get("v.QLlistSaved")));
                } else{
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type": "Error",
                        "title": "Error!",
                        "message": "Something went wrong."
                    });
                    toastEvent.fire();
                }
            } else{
                component.set("v.showSpinnerSelProds",false);
                console.log("Failed inserting Products "+JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);
        
    },
    saveProducts: function(component, event, helper){
        console.log('list to be saved::: '+JSON.stringify(component.get("v.QLlistSaved")));
        var isRecordSaved = component.get("v.isRecordSaved");
        component.set("v.showSpinnerSelProds",true);
        try{
            console.log('1');
            let callToastMsgResp = helper.proposedUnitValidation(component,helper,false);
            console.log('callToastMsg Else :'+callToastMsgResp);
            if(!callToastMsgResp.isCallMsg){
                var action1 = component.get("c.saveOptyExtProductsManual");
                action1.setParams({
                    'optyId': component.get("v.optyId"),
                    'saveitems': JSON.stringify(component.get("v.QLlistSaved"))
                });
                console.log('2');
                action1.setCallback(this, function(response){
                    if(response.getState() == 'SUCCESS'){
                        console.log('3');
                        var resp = JSON.parse(response.getReturnValue());
                        console.log('Response inside IsRecordSaved:: '+JSON.stringify(resp));
                        if(resp.oppIdData.OppId != null){
                            component.set("v.showSpinnerSelProds",false);
                            component.set("v.showSelectedProducts", false);
                            component.set("v.showSavedSelectedProducts", true);
                            component.set("v.isRecordSaved", true);
                            component.set("v.QLlistSaved", resp.savedProducts);
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                "type": "Success",
                                "title": "Success!",
                                "message": "Records saved successfully."
                            });
                            toastEvent.fire();
                        } else{
                            component.set("v.showSpinnerSelProds",false);
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                "type": "Error",
                                "title": "Error!",
                                "message": "Something went wrong."
                            });
                            toastEvent.fire();
                        }
                    } else{
                        component.set("v.showSpinnerSelProds",false);
                        console.log("Failed inserting Products ");
                    }
                });
                $A.enqueueAction(action1); 
            }
            else{
                console.log('Toast Message called');
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": "Warning",
                    "title": "Warning!",
                    "message": "Please enter Proposed Units for : " + callToastMsgResp.prdName
                });
                component.set("v.showSpinnerSelProds",false);
                component.set("v.showSelectedProducts", false);
                component.set("v.showSavedSelectedProducts", true);
                toastEvent.fire();
            }
        } catch(e){
            console.log('Error::: '+e);
        }
    },
    
    insertProducts: function (component, event, helper) {
        component.set("v.showSpinnerSelProds",true);
        let callToastMsgResp = helper.proposedUnitValidation(component,helper,false);
        console.log('callToastMsg Else :'+callToastMsgResp);
        if(!callToastMsgResp.isCallMsg){
            var action1 = component.get("c.saveOptyExtProductsManual");
            action1.setParams({
                'optyId': component.get("v.optyId"),
                'saveitems': JSON.stringify(component.get("v.QLlistSaved"))
            });
            action1.setCallback(this, function(response){
                if(response.getState() == 'SUCCESS'){
                    component.set("v.showSpinnerSelProds",false);
                    var resp = JSON.parse(response.getReturnValue());
                    if(resp.oppIdData.OppId != null){
                        component.find("navigationService").navigate({
                            type: "standard__recordPage",
                            attributes: {
                                recordId: resp.oppIdData.OppId,
                                actionName: "view"
                            }
                        }, false);   
                    } else{
                        component.set("v.showSpinnerSelProds",false);
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "type": "Error",
                            "title": "Error!",
                            "message": "Something went wrong."
                        });
                        toastEvent.fire();
                    }
                } else{
                    component.set("v.showSpinnerSelProds",false);
                    console.log("Failed inserting Products "+JSON.stringify(response.getError()));
                }
            });
            $A.enqueueAction(action1);
        }
        else{
            console.log('Toast Message called');
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type": "Warning",
                "title": "Warning!",
                "message": "Please enter Proposed Units for : " + callToastMsgResp.prdName
            });
            component.set("v.showSpinnerSelProds",false);
            component.set("v.showSelectedProducts", false);
            component.set("v.showSavedSelectedProducts", true);
            toastEvent.fire();
        }
    },
    closeQuickActionPanel : function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    },
    editLineItem : function(component, event, helper) {
        component.set("v.showUserInputs",component.get("v.showUserInputs")?false:true);
        //console.log('Single Rec:::Child '+JSON.stringify(component.get("v.singleRec")));
        if(!component.get("v.showUserInputs")){
            if(component.get("v.isRecordSaved")){
                component.set("v.singleSavedRec", component.get("v.singleSavedRec"));
            } else{
                component.set("v.singleRec", component.get("v.singleRec"));   
            }
        }
    },
    removeDeletedRow: function (component, event, helper) {
        var recordIdToDelete = event.getParam("recordIdToDelete");
        var selectedRec;
        if(recordIdToDelete){
            selectedRec = recordIdToDelete;
        } else{
            selectedRec = event.getSource().get("v.name");   
        }
        
        var AllRowsList = component.get("v.QLlistSaved");
        console.log('Checking --- '+JSON.stringify(AllRowsList));
        
        if (AllRowsList.length === 1) {
            console.log('AllRowsList.length === 1');
            
        }
        
        
        
        for (let i = 0; i < AllRowsList.length; i++) {
            
            var pItem = AllRowsList[i];
            
            if (pItem.Product__r.Id == selectedRec) {
                
                var index = AllRowsList.indexOf(pItem);
                if (index > -1) {
                    
                    AllRowsList.splice(index, 1);
                    var AllRowsList1 = AllRowsList;
                    
                }
                
            }
        }
        
        component.set("v.QLlistSaved",[]);
        component.set("v.QLlistSaved", AllRowsList);
    },
    closeModal: function(component, event, helper){
        var recordId = component.get("v.optyId");
        if (recordId != null && recordId != undefined && recordId != '') {
            // Go to record
            
            component.find("navigationService").navigate({
                type: "standard__recordPage",
                attributes: {
                    recordId: recordId,
                    actionName: "view"
                }
            }, false); 
        } 
    }
    
})