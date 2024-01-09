({
	doInit : function(component, event, helper) {
        var singlerec = component.get("v.singlerec")
		//console.log('m4----'+singlerec.M4ActualQuantity);
	},
     openModal: function(component, event, helper) {
        // Set isModalOpen attribute to true
        
        component.set('v.loaded',true);
        console.log('sku code----'+component.get("v.singlerec.Vision_Product__r.ProductCode"));
        console.log('acc code----'+component.get("v.recordId"));
        var getBidInfoAction = component.get("c.getAwardedPositionData");
        getBidInfoAction.setParams({
            
            customerId :component.get("v.recordId"),
            ProductCode :component.get("v.singlerec.Vision_Product__r.ProductCode")
        });
        console.log('Hiiii');
        getBidInfoAction.setCallback(this, function (response) {
            var actState = response.getState();
            if (actState == 'SUCCESS') {
                console.log('success');
                component.set('v.loaded',false);
                var responseWrapper=response.getReturnValue();
                console.log('awardedPosition-->'+JSON.stringify(responseWrapper));
                component.set("v.awardedPosition",responseWrapper.awardedPositionList);
                component.set("v.isModalOpen", true);
            }
            else{
                component.set('v.loaded',false);
                console.log('errot---'+JSON.stringify(response.getError()));
            }
            
        });
        $A.enqueueAction(getBidInfoAction);
        
    },
    closeModel: function(component, event, helper) {
        // Set isModalOpen attribute to true
        component.set("v.isModalOpen", false);
        
    },
   onRecChange : function(component, event, helper){
        console.log('on record change method.. ');
        var nameofEditfield = event.getSource().get('v.name');
        var val = event.getSource().get('v.value');
        console.log('nameofEditfield :: '+nameofEditfield);
        console.log('value :: '+val);
        if(nameofEditfield == 'opptyProbChange'){
            component.set("v.gcpLineItem.Phoenix_Opportunity_Probability__c",val);
        }
        if(nameofEditfield == 'prodStatusChange'){
            component.set("v.gcpLineItem.Product_Status__c",val);
        }
        
        var action = component.get("c.updateGcpLineItem");
        action.setParams({
            gcpLineItem : component.get("v.gcpLineItem")
        });
        action.setCallback(this, function (response) {
            console.log('State from updateGcpLineItem :: '+response.getState());
            if (response.getState() == "SUCCESS") {
                var gcpLineItem = response.getReturnValue();
                component.set("v.gcpLineItem",gcpLineItem);
                component.set("v.showSaveComntButton",false);
                component.set("v.showComments",false);
                if(nameofEditfield == 'prodStatusChange')
                    component.set("v.doRefresh",component.get("v.doRefresh")?false:true);
                else{
                    var a = component.get('c.doInit');
                    $A.enqueueAction(a);
                }
            }
            else {
                console.log('Error while updating line Item.');
            }
        });
        $A.enqueueAction(action);
    },
     onSaveCmnt : function(component, event, helper){
        var cmnt = component.get("v.visionComment");
        if(component.get("v.selectedStatusVal") == 'Price Constraint' || component.get("v.selectedStatusVal") == 'Supply Constraint'){
            cmnt = component.get("v.selectedStatusVal")+': \n'+cmnt;
        }
        if(cmnt != undefined && cmnt != ''){
            var action = component.get("c.saveComment");
            action.setParams({
                newComment : cmnt,
                selectedLineId : component.get("v.singlerec.Id"),
                Product : component.get("v.ProdIdForComment"),
                Account : component.get("v.recordId")
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
                        helper.getCommentsHelper(component, event, helper, component.get("v.selectedLine"));
                    }
                }
                else {
                    console.log('Error while storing Comment.');
                }
            });
            $A.enqueueAction(action);
        }
        else{
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "ERROR",
                "message":'Vision comments are not added.',
                "type":"ERROR",
                "mode":"dismissible"
            });
            toastEvent.fire();
        }
    },
     inlineEditComments : function(component, event, helper){
        //component.set("v.commentsEditMode",true);
        console.log('in inlineEditComments');
        component.set("v.showSaveComntButton",false);
         var val = event.getSource().get("v.value");
        console.log('valuee----'+val);   
     component.set("v.ProdIdForComment",val);
        helper.getCommentsHelper(component, event, helper);
    },
     closeCommentPopup : function(component, event, helper){
       /* var compEvent = component.getEvent("refreshEvent");
        compEvent.setParams({
            "isRefreshRecs" : 'changeHeader',
            "gcpRec" : component.get("v.gcpLineItem"),
            "indexVal" : component.get("v.indexVal")
            
        });
        compEvent.fire();*/
        component.set("v.showComments",false);
    },
})