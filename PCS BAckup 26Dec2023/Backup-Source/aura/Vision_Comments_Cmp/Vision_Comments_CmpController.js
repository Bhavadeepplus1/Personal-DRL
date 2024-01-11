({
    doInit : function(component, event, helper) {
        component.set("v.showSpinner",true);
        component.set("v.showComments",true);
        var prodId = component.get("v.prodId");
        var action = component.get("c.getProdBidLineItemComments");
        action.setParams({
            prodId : prodId,
            accObj : component.get("v.accObj")
        });
        action.setCallback(this, function (response) {
            console.log('response.getState() from getProdBidLineItemComments :: '+response.getState());
            if (response.getState() === "SUCCESS") {
                var doesCmntsExist = false;
                var responseList = response.getReturnValue();
                var cmnts = [];
                var brightCmnts = [];
                responseList.forEach(function(cmntObj){
                    console.log('cmntObj.cmntCat ::: '+cmntObj.cmntCat);
                    if(cmntObj.cmntCat == 'Panorama Comments')
                        doesCmntsExist = true;
                    if(cmntObj.cmntCat == 'Vision Comments')
                        doesCmntsExist = true;
                    if(cmntObj.cmntCat == 'Bright Comments'){
                        for(var key in cmntObj.cmntWrapMap){
                            if(cmntObj.cmntWrapMap[key] != undefined && cmntObj.cmntWrapMap[key].length > 0){
                                brightCmnts.push({key:key,value:cmntObj.cmntWrapMap[key], bidId:cmntObj.cmntWrapMap[key][0].bidId});
                            }
                        }
                    }
                });
                if(brightCmnts.length > 0)
                    doesCmntsExist = true;
                component.set("v.doesCmntsExist",doesCmntsExist);
                component.set("v.brightCmnts",brightCmnts);
                component.set("v.listOfCmnts", responseList);
                component.set("v.showSpinner",false);
            }
            else{
                console.log('ERROR --- > '+JSON.stringify(response.getError()));
                component.set("v.showSpinner",false);
            }
        });
        $A.enqueueAction(action);
    },
    onSaveCmnt : function(component, event, helper){
        component.set("v.showSpinnerInCommentPop",true);
        var cmnt = component.get("v.visionComment");
        if(cmnt != undefined && cmnt != ''){
            var action = component.get("c.saveComment");
            var prodId = component.get("v.prodId");
            action.setParams({
                newComment : cmnt,
                prodId : prodId,
                accObj : component.get("v.accObj")
            });
            action.setCallback(this, function (response) {
                console.log('State from saveComment :: '+response.getState());
                if (response.getState() == "SUCCESS") {
                    var respObj = response.getReturnValue();
                    if(respObj.isErrorFromServer){
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "ERROR",
                            "message":''+respObj.errorMessageFromServer,
                            "type":"ERROR",
                            "mode":"dismissible"
                        });
                        toastEvent.fire();
                        component.set("v.showSpinnerInCommentPop",false);
                    }
                    else{
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Saved!",
                            "message":'Comment Added Successfully.',
                            "type":"SUCCESS",
                            "mode":"dismissible"
                        });
                        toastEvent.fire();
                        component.set("v.visionComment",'');
                        component.set("v.showSpinnerInCommentPop",false);
                        var a = component.get('c.doInit');
                        $A.enqueueAction(a);
                    }
                }
                else {
                    console.log('Error while storing Comment. Exception --> '+JSON.stringify(response.getErrors()));
                    component.set("v.showSpinnerInCommentPop",false);
                }
            });
            $A.enqueueAction(action);
        }
        else{
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "ERROR",
                "message":'Comment can not be Blank.',
                "type":"ERROR",
                "mode":"dismissible"
            });
            toastEvent.fire();
        }
    },
    closeCommentPopup : function(component, event, helper){
        component.set("v.showComments",false);
    }
})