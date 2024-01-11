({
	doInit : function(component, event, helper) {
		
	},
    internalTargetDateChaged : function(component, event, helper){
        console.log('internalTargetDate ---> '+component.get("v.internalTargetDate"));
    },
    addRejectionComment : function(component, event, helper){
        let changedShareId = event.target.dataset.recordId;
            //event.getSource().get("v.name");//event.target.closest("[data-id]").dataset.id;
        //event.target.dataset.recordId;
        console.log( "indexVal is " + JSON.stringify( changedShareId ) );
        
        var ndcList = component.get("v.ndcList");
        ndcList.forEach(function(ndcObj){
            if(changedShareId == ndcObj.Id){
                if(ndcObj.Vision_isAccepted__c){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type" : "Info",
                        "title": "Accepted Product!",
                        "message": "You can not add rejection Comment to Accepted Product."
                    });
                    toastEvent.fire();
                    return;
                }
                else{
                    component.set("v.changedId",changedShareId);
                    component.set("v.showAddCommentsOnRej",true);
                    component.set("v.showNdcs",false);
                    return;
                }
            }
        });
    },
    isAcceptedChanged : function(component, event, helper){
        let changedShareId = event.target.dataset.recordId;
        console.log( "indexVal is " + JSON.stringify( changedShareId ) );
        var ndcList = component.get("v.ndcList");
        var isAccepted = true;
        ndcList.forEach(function(ndcObj){
            console.log('ndcObj.Vision_isAccepted__c -> '+ndcObj.Vision_isAccepted__c+' for -> '+ndcObj.Vision_Product__r.Name)
            if(ndcObj.Id == changedShareId){
                if(ndcObj.Vision_isAccepted__c){
                    ndcObj.Vision_Task_Rejection_Reason__c = '';
                }
                else{
                    console.log('inside else');
                    isAccepted = false;
                    component.set("v.rejectionComment",ndcObj.Vision_Task_Rejection_Reason__c);
                }
                return;
            }
        });
        if(!isAccepted){
            component.set("v.changedId",changedShareId);
            component.set("v.showAddCommentsOnRej",true);
            component.set("v.showNdcs",false);
        }
    },
    closeCommentSection : function(component, event, helper){
        component.set("v.showAddCommentsOnRej",false);
        component.set("v.showNdcs",true);
    },
    updateRejectionComment : function(component, event, helper){
        console.log('updating Rejection Comments.');
        var ndcComment = component.get("v.rejectionComment");
        if(ndcComment == undefined || ndcComment == ''){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type" : "ERROR",
                "title": "ERROR",
                "message": "Rejection Comment can not be null."
            });
            toastEvent.fire();
        }
        else{
            var action = component.get("c.updateShareExpansionComment");
            var changedNdc = {};
            var ndcList = component.get("v.ndcList");
            var selectedNdcId = component.get("v.changedId");
            ndcList.forEach(function(ndcObj){
                if(selectedNdcId == ndcObj.Id){
                    changedNdc = ndcObj;
                    return;
                }
            });
            action.setParams({ndcItem : changedNdc,
                              ndcComment : ndcComment});
            action.setCallback(this, function (response) {
                console.log('State from updateShareExpansionComment :: '+response.getState());
                if (response.getState() == "SUCCESS") {
                    var respString = response.getReturnValue();
                    if(respString.includes('ERROR')){
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "type" : "ERROR",
                            "title": "ERROR",
                            "message": ""+respString
                        });
                        toastEvent.fire();
                        component.set("v.isSpinner",false);
                    }
                    else{
                        component.set("v.showNdcs",false);
                        window.open('/' +respString,'_blank');
                        $A.get('e.force:refreshView').fire();
                        component.set("v.isSpinner",false);
                    }
                }
                else {
                    console.log('ERROR WHILE creating Opty ---> '+JSON.stringify(response.getError()));
                    component.set('v.isSpinner', false);
                }
            });
            $A.enqueueAction(action);
        }
    },
    showNdcList : function(component, event, helper){
        component.set("v.showNdcs",component.get("v.showNdcs") ? false : true);
        if(component.get("v.showNdcs")){
            var ndcValues = component.get("v.shareItem.expnList");
            var totalVol = ndcValues[0].Target_Volume__c;
            component.set("v.targetVol",totalVol);
            var totalVal = ndcValues[0].Target_Price__c;
            component.set("v.totalVal",totalVal);
            var newNdcList = [];
            ndcValues.forEach(function(ndcObj){
                ndcObj.Vision_Proposed_Volume__c = 0;
                ndcObj.Proposed_Direct_Selling_Units__c = 0;
                ndcObj.Proposed_Indirect_Selling_Units__c = 0;
                ndcObj.Vision_Proposed_OS_Units__c = 0;
                ndcObj.Vision_Proposed_RAD_Units__c = 0;
                ndcObj.Vision_Proposed_WMT_Units__c = 0;
                ndcObj.Vision_Proposed_BASE_Units__c = 0;
                ndcObj.Vision_Proposed_DSH_Units__c = 0;
                ndcObj.Vision_Proposed_AutoSub_Units__c = 0;
                ndcObj.Vision_Proposed_Smith_Drug_Units__c = 0;
                ndcObj.Vision_Proposed_Anda_Units__c = 0;
                ndcObj.Vision_Proposed_DirectAholdDelhaizeUnits__c = 0;
                ndcObj.Vision_Proposed_Direct_Gaint_Eagle_Units__c = 0;
                ndcObj.Vision_Proposed_TotalRetailIndirectUnits__c = 0;
                if(ndcObj.Vision_Task_Rejection_Reason__c == null || ndcObj.Vision_Task_Rejection_Reason__c == undefined)
                    ndcObj.Vision_isAccepted__c = true;
                newNdcList.push(ndcObj);
            });
            component.set("v.ndcList",newNdcList);
            
            var today = new Date();
            var date = today.getDate();
            var month = today.getMonth()+1;
            var year = today.getFullYear();
            var result = year+'-'+month+'-'+date;
            component.set('v.internalTargetDate', result);
        }
    },
    handleClick: function(component, event, helper) {
        
     var accId = component.get("v.accObj");
      console.log('thisssssss isssss account id'+accObj);
    var urlEvent = $A.get("e.force:navigateToURL");
    urlEvent.setParams({
        "url": "accId"
    });

    urlEvent.fire();
},
    handleMouseLeave : function(component, event, helper) {
        //$A.util.addClass(component.find("divHelp"), 'slds-hide');
    },
    handleMouseEnter : function(component, event, helper) {
        //$A.util.removeClass(component.find("divHelp"), 'slds-hide');
    },
    updateGrandTotal : function(component,event,helper){
        var prodList = component.get("v.ndcList");
        var gTotal = 0;
        var gTotalEU = 0;
        var proposedVal = 0;
        prodList.forEach(function(prodObj){
            if(prodObj.Vision_isAccepted__c){
                var pkgSize = (prodObj.Vision_Product__r.Phoenix_Pkg_Size__c != undefined || prodObj.Vision_Product__r.Phoenix_Pkg_Size__c != null) ? prodObj.Vision_Product__r.Phoenix_Pkg_Size__c : 1;
                var totalProposedUnits = parseInt(prodObj.Proposed_Direct_Selling_Units__c)+parseInt(prodObj.Proposed_Indirect_Selling_Units__c)+parseInt(prodObj.Vision_Proposed_OS_Units__c)
                +parseInt(prodObj.Vision_Proposed_RAD_Units__c)+parseInt(prodObj.Vision_Proposed_WMT_Units__c)+parseInt(prodObj.Vision_Proposed_BASE_Units__c)+parseInt(prodObj.Vision_Proposed_DSH_Units__c)
                +parseInt(prodObj.Vision_Proposed_AutoSub_Units__c)+parseInt(prodObj.Vision_Proposed_Smith_Drug_Units__c)+parseInt(prodObj.Vision_Proposed_Anda_Units__c)+parseInt(prodObj.Vision_Proposed_DirectAholdDelhaizeUnits__c)
                +parseInt(prodObj.Vision_Proposed_Direct_Gaint_Eagle_Units__c)+parseInt(prodObj.Vision_Proposed_TotalRetailIndirectUnits__c);
                prodObj.Vision_Total_Proposed_Units_EU__c = pkgSize * totalProposedUnits;
                prodObj.Vision_Proposed_Value_EA__c = totalProposedUnits * prodObj.Vision_Product__r.Phoenix_Lowest_Price_SKU__c;
                proposedVal = proposedVal + prodObj.Vision_Proposed_Value_EA__c;
                gTotalEU = gTotalEU + prodObj.Vision_Total_Proposed_Units_EU__c;
                gTotal = gTotal + totalProposedUnits;
            }
        });
        component.set("v.totalVolEA",gTotal);
        component.set("v.totalVolEU",gTotalEU);
        var totalVal = component.get("v.totalVal");
        //var proposedVal = gTotal * totalVal;
        component.set("v.proposedVal",proposedVal);
        component.set("v.ndcList",prodList);
    },
    handleChange : function(component,event,helper){
        var selectedStatus = component.find("bidTypeId").get("v.value");
        component.set("v.bidType",selectedStatus);
    },
    createOpty : function(component, event, helper){
       	component.set("v.isSpinner",true);
        var prodList = component.get("v.ndcList");
        var bidType = component.get("v.bidType");
        var action = component.get("c.createOptyCntl");
        action.setParams({prodList : prodList,
                          bidType : bidType,
                          totalVol : component.get("v.totalVol"),
                          internalTargetDate:component.get("v.internalTargetDate")
                         });
        action.setCallback(this, function (response) {
            console.log('State from getGcpRelatedList :: '+response.getState());
            if (response.getState() == "SUCCESS") {
                var respString = response.getReturnValue();
                if(respString.includes('ERROR')){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type" : "ERROR",
                        "title": "ERROR",
                        "message": ""+respString
                    });
                    toastEvent.fire();
                    component.set("v.isSpinner",false);
                }
                else{
                    component.set("v.showNdcs",false);
                    window.open('/' +respString,'_blank');
                    $A.get('e.force:refreshView').fire();
                    component.set("v.isSpinner",false);
                }
            }
            else {
                console.log('ERROR WHILE creating Opty ---> '+JSON.stringify(response.getError()));
                component.set('v.isSpinner', false);
            }
        });
        $A.enqueueAction(action);
    }
})