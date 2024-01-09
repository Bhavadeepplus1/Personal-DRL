({
    doInit : function(component, event, helper) {
        var accObj = component.get("v.accObj");
        if(accObj.Name.includes('Private Label'))
            component.set("v.isOtcProdFam",true);
        console.log('NDC List: '+JSON.stringify(component.get("v.ndcList")));
        var ndcList = component.get("v.ndcList");
        var disableCreateBtn = false;
        var newItems = 0;
        ndcList.forEach(function(item){
            if(item.Task_Status__c == 'New' && item.Vision_isAccepted__c)
                newItems++;
        });
        if(newItems == 0)
            disableCreateBtn = true;
        component.set("v.disableCreateBtn",disableCreateBtn);
        
        /*var ndcList = component.get("v.shareItem.expnList");
        component.set("v.ndcList",ndcList);
        ndcList.forEach(function(ndcObj){
            if(ndcObj.Vision_Product__r.Phoenix_Rx_SRx_OTC__c == 'OTC' && ndcObj.Vision_Product__r.Phoenix_Is_Private_Label_OTC__c){
                console.log('making isOtcProdFam true --> ');
                component.set("v.isOtcProdFam",true);
                return;
            }
        });*/
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
                    component.set("v.rejectionComment",ndcObj.Vision_Task_Rejection_Reason__c);
                    component.set("v.changedId",changedShareId);
                    component.set("v.showAddCommentsOnRej",true);
                    component.set("v.showNdcs",false);
                    return;
                }
            }
        });
        console.log('NDC List: '+JSON.stringify(ndcList));
    },
    isAcceptedChanged : function(component, event, helper){
        let changedShareId = event.target.dataset.recordId;
        console.log( "indexVal is " + JSON.stringify( changedShareId ) );
        var ndcList = component.get("v.ndcList");
        var isAccepted = true;
        var disableCreateBtn = false;
        var newItems = 0;
        ndcList.forEach(function(ndcObj){
            if(ndcObj.Task_Status__c == 'New' && ndcObj.Vision_isAccepted__c)
                newItems++;
            if(ndcObj.Id == changedShareId){
                if(ndcObj.Vision_isAccepted__c){
                    ndcObj.Vision_Task_Rejection_Reason__c = '';
                }
                else{
                    isAccepted = false;
                    component.set("v.rejectionComment",ndcObj.Vision_Task_Rejection_Reason__c);
                }
            }
        });
        if(!isAccepted){
            component.set("v.changedId",changedShareId);
            component.set("v.showAddCommentsOnRej",true);
            component.set("v.showNdcs",false);
        }
        if(newItems == 0)
            disableCreateBtn = true;
        component.set("v.disableCreateBtn",disableCreateBtn);
        console.log('NDC List: '+JSON.stringify(ndcList));
        var a = component.get('c.updateGrandTotal');
        $A.enqueueAction(a);
    },
    rejectionCommentChanged : function(component, event, helper){
        var comment = component.find("rejReason").get("v.value");
        console.log('comment - '+comment);
        component.set("v.rejectionComment",comment);
    },
    closeCommentSection : function(component, event, helper){
        component.set("v.showAddCommentsOnRej",false);
        component.set("v.showNdcs",true);
    },
    updateRejectionComment : function(component, event, helper){
        component.set("v.isSpinner",true);
        console.log('updating Rejection Comments. Comment - '+component.get("v.rejectionComment"));
        var ndcComment = component.get("v.rejectionComment");
        if(ndcComment == undefined || ndcComment == ''){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type" : "ERROR",
                "title": "ERROR",
                "message": "Rejection Comment can not be empty."
            });
            toastEvent.fire();
            component.set("v.isSpinner",false);
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
                    if(respString.isError){
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "type" : "ERROR",
                            "title": "ERROR",
                            "message": ""+respString.errorMessage
                        });
                        toastEvent.fire();
                        component.set("v.isSpinner",false);
                    }
                    else{
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "type" : "Success!",
                            "title": "Success!",
                            "message": "Rejection Reason has been added."
                        });
                        toastEvent.fire();
                        var updatedRec = respString.shareExpanObj;
                        var updatedList = [];
                        ndcList.forEach(function(ndcObj){
                            if(selectedNdcId == ndcObj.Id)
                                updatedList.push(updatedRec);
                            else
                                updatedList.push(ndcObj);
                        });
                        component.set("v.ndcList",updatedList);
                        component.set("v.isSpinner",false);
                        component.set("v.showAddCommentsOnRej",false);
                        var disableCreateBtn = false;
                        var newItems = 0;
                        updatedList.forEach(function(item){
                            if(item.Task_Status__c == 'New' && item.Vision_isAccepted__c)
                                newItems++;
                        });
                        if(newItems == 0)
                            disableCreateBtn = true;
                        component.set("v.disableCreateBtn",disableCreateBtn);
                        component.set("v.showNdcs",true);
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
    
    handleChangeInBidTemplate : function(component, event, helper){
        var selectedBidTemplate = component.find("bidTemplate").get("v.value");
        component.set("v.templateType",selectedBidTemplate);
    },
    
    saveTemplate : function(component, event, helper){
        component.set("v.showNdcs",false);
        component.set("v.isSpinner",true);
        var ndcValues = component.get("v.ndcList");
        var templateType = component.get("v.templateType");
        var updatedList = [];
        ndcValues.forEach(function(prodObj){
            prodObj.Vision_Customer_Template__c = templateType;
            updatedList.push(prodObj);
        });
        var action = component.get("c.saveNdcWithBidTemplate");
        action.setParams({ndcValues : updatedList,
                          accId : component.get("v.accObj.Id")}); 
        action.setCallback(this, function(response){
            if (response.getState() === "SUCCESS") {
                var ndcList = response.getReturnValue();
                console.log('ndcList response==>'+JSON.stringify(ndcList))
                component.set("v.showCxTemplateSelection",false);
                component.set("v.ndcList",ndcList);
                var a = component.get('c.saveDetails');
                $A.enqueueAction(a);
            }
            else{
                console.log('ERROR from saving bidTemplate --> '+JSON.stringify(response.getError()));
            }
        }); $A.enqueueAction(action);
    },
    
    showNdcList : function(component, event, helper){
        component.set("v.showNdcs",component.get("v.showNdcs") ? false : true);
        if(component.get("v.showNdcs")){
            var accObj = component.get("v.accObj");
            var templateString = accObj.Phoenix_Customer_Class_Bid_Template__c != undefined ? accObj.Phoenix_Customer_Class_Bid_Template__c : '';
            var ndcValues = component.get("v.ndcList");//component.get("v.shareItem.expnList");
            if(ndcValues[0].Vision_Customer_Template__c == undefined
               && templateString != 'Direct or Indirect'
               && templateString != 'ROS' && templateString != 'ABC Progen'
               && templateString != 'ABC Pharmagen' && templateString != 'Humana'){
                ndcValues[0].Vision_Customer_Template__c = templateString;
            }
            if(ndcValues[0].Vision_Customer_Template__c == undefined
               && (templateString == 'Direct or Indirect' || templateString == 'ROS' || templateString == 'Humana'
                   || templateString == 'ABC Progen' || templateString == 'ABC Pharmagen')){
                if(templateString == 'Direct or Indirect')
                    component.set("v.templateType",'Direct');
                else if(templateString == 'ROS')
                    component.set("v.templateType",'ROS');
                    else if(templateString == 'ABC Progen'
                            || templateString == 'ABC Pharmagen')
                    component.set("v.templateType",'ABC Progen');
                        else if (templateString == 'Humana')
                            component.set("v.templateType",'Direct');
                component.set("v.showCxTemplateSelection",true);
            }
            else{
                var accObj = component.get("v.accObj");
                if(accObj.Name.includes('Private Label')){
                    component.set("v.isOtcProdFam",true);
                    component.set("v.templateType",'OTC Customer');
                }
                else
                    component.set("v.templateType",ndcValues[0].Vision_Customer_Template__c);
                var totalVol = ndcValues[0].Target_Volume__c;
                component.set("v.targetVol",totalVol);
                var totalVal = ndcValues[0].Target_Price__c;
                component.set("v.totalVal",totalVal);
                var targetDate = ndcValues[0].Plan_Contract_Effective_Date__c;
                component.set('v.internalTargetDate', targetDate);
                var newNdcList = [];
                ndcValues.forEach(function(prodObj){
                    prodObj.Proposed_Direct_Selling_Units__c = (prodObj.Proposed_Direct_Selling_Units__c != '' && prodObj.Proposed_Direct_Selling_Units__c != undefined) ? prodObj.Proposed_Direct_Selling_Units__c : 0;
                    prodObj.Proposed_Indirect_Selling_Units__c = (prodObj.Proposed_Indirect_Selling_Units__c != '' && prodObj.Proposed_Indirect_Selling_Units__c != undefined) ? prodObj.Proposed_Indirect_Selling_Units__c : 0;
                    prodObj.Vision_Proposed_OS_Units__c = (prodObj.Vision_Proposed_OS_Units__c != '' && prodObj.Vision_Proposed_OS_Units__c != undefined) ? prodObj.Vision_Proposed_OS_Units__c : 0;
                    prodObj.Vision_Proposed_RAD_Units__c = (prodObj.Vision_Proposed_RAD_Units__c != '' && prodObj.Vision_Proposed_RAD_Units__c != undefined) ? prodObj.Vision_Proposed_RAD_Units__c : 0;
                    prodObj.Vision_Proposed_WMT_Units__c = (prodObj.Vision_Proposed_WMT_Units__c != '' && prodObj.Vision_Proposed_WMT_Units__c != undefined) ? prodObj.Vision_Proposed_WMT_Units__c : 0;
                    prodObj.Vision_Proposed_BASE_Units__c = (prodObj.Vision_Proposed_BASE_Units__c != '' && prodObj.Vision_Proposed_BASE_Units__c != undefined) ? prodObj.Vision_Proposed_BASE_Units__c : 0;
                    prodObj.Vision_Proposed_DSH_Units__c = (prodObj.Vision_Proposed_DSH_Units__c != '' && prodObj.Vision_Proposed_DSH_Units__c != undefined) ? prodObj.Vision_Proposed_DSH_Units__c : 0;
                    prodObj.Vision_Proposed_AutoSub_Units__c = (prodObj.Vision_Proposed_AutoSub_Units__c != '' && prodObj.Vision_Proposed_AutoSub_Units__c != undefined) ? prodObj.Vision_Proposed_AutoSub_Units__c : 0;
                    prodObj.Vision_Proposed_Smith_Drug_Units__c = (prodObj.Vision_Proposed_Smith_Drug_Units__c != '' && prodObj.Vision_Proposed_Smith_Drug_Units__c != undefined) ? prodObj.Vision_Proposed_Smith_Drug_Units__c : 0;
                    prodObj.Vision_Proposed_Anda_Units__c = (prodObj.Vision_Proposed_Anda_Units__c != '' && prodObj.Vision_Proposed_Anda_Units__c != undefined) ? prodObj.Vision_Proposed_Anda_Units__c : 0;
                    prodObj.Vision_Proposed_DirectAholdDelhaizeUnits__c = (prodObj.Vision_Proposed_DirectAholdDelhaizeUnits__c != '' && prodObj.Vision_Proposed_DirectAholdDelhaizeUnits__c != undefined) ? prodObj.Vision_Proposed_DirectAholdDelhaizeUnits__c : 0;
                    prodObj.Vision_Proposed_Direct_Gaint_Eagle_Units__c = (prodObj.Vision_Proposed_Direct_Gaint_Eagle_Units__c != '' && prodObj.Vision_Proposed_Direct_Gaint_Eagle_Units__c != undefined) ? prodObj.Vision_Proposed_Direct_Gaint_Eagle_Units__c : 0;
                    prodObj.Vision_Proposed_TotalRetailIndirectUnits__c = (prodObj.Vision_Proposed_TotalRetailIndirectUnits__c != '' && prodObj.Vision_Proposed_TotalRetailIndirectUnits__c != undefined) ? prodObj.Vision_Proposed_TotalRetailIndirectUnits__c : 0;
                    
                    prodObj.Vision_Proposed_Direct_ESI_Units__c = (prodObj.Vision_Proposed_Direct_ESI_Units__c != '' && prodObj.Vision_Proposed_Direct_ESI_Units__c != undefined) ? prodObj.Vision_Proposed_Direct_ESI_Units__c : 0;
                    prodObj.Vision_Proposed_Indirect_ESI_Units__c = (prodObj.Vision_Proposed_Indirect_ESI_Units__c != '' && prodObj.Vision_Proposed_Indirect_ESI_Units__c != undefined) ? prodObj.Vision_Proposed_Indirect_ESI_Units__c : 0;
                    prodObj.Vision_Proposed_Direct_Kroger_Units__c = (prodObj.Vision_Proposed_Direct_Kroger_Units__c != '' && prodObj.Vision_Proposed_Direct_Kroger_Units__c != undefined) ? prodObj.Vision_Proposed_Direct_Kroger_Units__c : 0;
                    prodObj.Vision_Proposed_Indirect_Kroger_Units__c = (prodObj.Vision_Proposed_Indirect_Kroger_Units__c != '' && prodObj.Vision_Proposed_Indirect_Kroger_Units__c != undefined) ? prodObj.Vision_Proposed_Indirect_Kroger_Units__c : 0;
                    prodObj.Vision_Proposed_Direct_Rx_Outreach_Units__c = (prodObj.Vision_Proposed_Direct_Rx_Outreach_Units__c != '' && prodObj.Vision_Proposed_Direct_Rx_Outreach_Units__c != undefined) ? prodObj.Vision_Proposed_Direct_Rx_Outreach_Units__c : 0;
                    prodObj.Vision_Proposed_IndirectRxOutreach_Units__c = (prodObj.Vision_Proposed_IndirectRxOutreach_Units__c != '' && prodObj.Vision_Proposed_IndirectRxOutreach_Units__c != undefined) ? prodObj.Vision_Proposed_IndirectRxOutreach_Units__c : 0;
                    prodObj.Vision_Proposed_Direct_Supervalu_Units__c = (prodObj.Vision_Proposed_Direct_Supervalu_Units__c != '' && prodObj.Vision_Proposed_Direct_Supervalu_Units__c != undefined) ? prodObj.Vision_Proposed_Direct_Supervalu_Units__c : 0;
                    prodObj.Vision_Proposed_Indirect_Supervalu_Units__c = (prodObj.Vision_Proposed_Indirect_Supervalu_Units__c != '' && prodObj.Vision_Proposed_Indirect_Supervalu_Units__c != undefined) ? prodObj.Vision_Proposed_Indirect_Supervalu_Units__c : 0;
                    prodObj.Vision_Proposed_Direct_Cigna_Units__c = (prodObj.Vision_Proposed_Direct_Cigna_Units__c != '' && prodObj.Vision_Proposed_Direct_Cigna_Units__c != undefined) ? prodObj.Vision_Proposed_Direct_Cigna_Units__c : 0;
                    prodObj.Vision_Proposed_Indirect_Cigna_Units__c = (prodObj.Vision_Proposed_Indirect_Cigna_Units__c != '' && prodObj.Vision_Proposed_Indirect_Cigna_Units__c != undefined) ? prodObj.Vision_Proposed_Indirect_Cigna_Units__c : 0;
                    prodObj.Vision_Proposed_Direct_Cordant_Units__c = (prodObj.Vision_Proposed_Direct_Cordant_Units__c != '' && prodObj.Vision_Proposed_Direct_Cordant_Units__c != undefined) ? prodObj.Vision_Proposed_Direct_Cordant_Units__c : 0;
                    prodObj.Vision_Proposed_Direct_Accerodo_Units__c = (prodObj.Vision_Proposed_Direct_Accerodo_Units__c != '' && prodObj.Vision_Proposed_Direct_Accerodo_Units__c != undefined) ? prodObj.Vision_Proposed_Direct_Accerodo_Units__c : 0;
                    prodObj.Vision_Proposed_Indirect_Accerodo_Units__c = (prodObj.Vision_Proposed_Indirect_Accerodo_Units__c != '' && prodObj.Vision_Proposed_Indirect_Accerodo_Units__c != undefined) ? prodObj.Vision_Proposed_Indirect_Accerodo_Units__c : 0;
                    prodObj.Vision_Proposed_Indirect_Cordant_Units__c = (prodObj.Vision_Proposed_Indirect_Cordant_Units__c != '' && prodObj.Vision_Proposed_Indirect_Cordant_Units__c != undefined) ? prodObj.Vision_Proposed_Indirect_Cordant_Units__c : 0;
                    prodObj.Vision_Total_Proposed_Units_EU__c = (prodObj.Vision_Total_Proposed_Units_EU__c != '' && prodObj.Vision_Total_Proposed_Units_EU__c != undefined) ? prodObj.Vision_Total_Proposed_Units_EU__c : 0;
                    prodObj.Vision_Proposed_Value_EA__c = (prodObj.Vision_Proposed_Value_EA__c != '' && prodObj.Vision_Proposed_Value_EA__c != undefined) ? prodObj.Vision_Proposed_Value_EA__c : 0;
                    
                    prodObj.Vision_Proposed_CVS_Direct_Units__c = (prodObj.Vision_Proposed_CVS_Direct_Units__c != '' && prodObj.Vision_Proposed_CVS_Direct_Units__c != undefined) ? prodObj.Vision_Proposed_CVS_Direct_Units__c : 0;
                    prodObj.Vision_Proposed_CVS_Indirect_Units__c = (prodObj.Vision_Proposed_CVS_Indirect_Units__c != '' && prodObj.Vision_Proposed_CVS_Indirect_Units__c != undefined) ? prodObj.Vision_Proposed_CVS_Indirect_Units__c : 0;
                    prodObj.Vision_Proposed_Cardinal_Units__c = (prodObj.Vision_Proposed_Cardinal_Units__c != '' && prodObj.Vision_Proposed_Cardinal_Units__c != undefined) ? prodObj.Vision_Proposed_Cardinal_Units__c : 0;
                    prodObj.Vision_Proposed_Major_Units__c = (prodObj.Vision_Proposed_Major_Units__c != '' && prodObj.Vision_Proposed_Major_Units__c != undefined) ? prodObj.Vision_Proposed_Major_Units__c : 0;
                    prodObj.Vision_Proposed_Volume__c = (prodObj.Vision_Proposed_Volume__c != '' && prodObj.Vision_Proposed_Volume__c != undefined) ? prodObj.Vision_Proposed_Volume__c : 0;
                    prodObj.Vision_Proposed_Share_Percentage__c = (prodObj.Vision_Proposed_Share_Percentage__c != '' && prodObj.Vision_Proposed_Share_Percentage__c != undefined) ? prodObj.Vision_Proposed_Share_Percentage__c : 0;
                    
                    if(prodObj.Vision_Task_Rejection_Reason__c == null || prodObj.Vision_Task_Rejection_Reason__c == undefined)
                        prodObj.Vision_isAccepted__c = true;
                    //if(prodObj.Vision_Product__r.Phoenix_Rx_SRx_OTC__c == 'OTC' && prodObj.Vision_Product__r.Phoenix_Is_Private_Label_OTC__c && !component.get("v.isOtcProdFam"))
                    //    component.set("v.isOtcProdFam",true);
                    newNdcList.push(prodObj);
                });
                component.set("v.ndcList",newNdcList);
                var disableCreateBtn = false;
                var newItems = 0;
                newNdcList.forEach(function(item){
                    if(item.Task_Status__c == 'New' && item.Vision_isAccepted__c)
                        newItems++;
                });
                if(newItems == 0)
                    disableCreateBtn = true;
                component.set("v.disableCreateBtn",disableCreateBtn);
                var a = component.get('c.updateGrandTotal');
                $A.enqueueAction(a);
                /*var today = new Date();
            var date = today.getDate();
            var month = today.getMonth()+1;
            var year = today.getFullYear();
            var result = year+'-'+month+'-'+date;
            component.set('v.internalTargetDate', result);*/
            }
            component.set("v.isSpinner",false);
        }
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
        var updatedList = [];
        var accObj = component.get("v.accObj");
        var isOtcProdFam = component.get("v.isOtcProdFam");
        prodList.forEach(function(prodObj){
            if(prodObj.Vision_isAccepted__c && prodObj.Vision_Product__r.Phoenix_Pkg_Size__c != undefined && prodObj.Target_Price__c != undefined){
                var totalProposedUnits = 0;
                if(isOtcProdFam){
                    prodObj.Vision_Proposed_Volume__c = (prodObj.Vision_Proposed_Volume__c != '' && prodObj.Vision_Proposed_Volume__c != undefined) ? prodObj.Vision_Proposed_Volume__c : 0;
                    prodObj.Vision_Proposed_Share_Percentage__c = (prodObj.Vision_Proposed_Share_Percentage__c != '' && prodObj.Vision_Proposed_Share_Percentage__c != undefined) ? prodObj.Vision_Proposed_Share_Percentage__c : 0;
                    totalProposedUnits = parseInt(prodObj.Vision_Proposed_Volume__c * (prodObj.Vision_Proposed_Share_Percentage__c/100));
                }
                else{
                    prodObj.Proposed_Direct_Selling_Units__c = (prodObj.Proposed_Direct_Selling_Units__c != '' && prodObj.Proposed_Direct_Selling_Units__c != undefined) ? prodObj.Proposed_Direct_Selling_Units__c : 0;
                    prodObj.Proposed_Indirect_Selling_Units__c = (prodObj.Proposed_Indirect_Selling_Units__c != '' && prodObj.Proposed_Indirect_Selling_Units__c != undefined) ? prodObj.Proposed_Indirect_Selling_Units__c : 0;
                    prodObj.Vision_Proposed_OS_Units__c = (prodObj.Vision_Proposed_OS_Units__c != '' && prodObj.Vision_Proposed_OS_Units__c != undefined) ? prodObj.Vision_Proposed_OS_Units__c : 0;
                    prodObj.Vision_Proposed_RAD_Units__c = (prodObj.Vision_Proposed_RAD_Units__c != '' && prodObj.Vision_Proposed_RAD_Units__c != undefined) ? prodObj.Vision_Proposed_RAD_Units__c : 0;
                    prodObj.Vision_Proposed_WMT_Units__c = (prodObj.Vision_Proposed_WMT_Units__c != '' && prodObj.Vision_Proposed_WMT_Units__c != undefined) ? prodObj.Vision_Proposed_WMT_Units__c : 0;
                    prodObj.Vision_Proposed_BASE_Units__c = (prodObj.Vision_Proposed_BASE_Units__c != '' && prodObj.Vision_Proposed_BASE_Units__c != undefined) ? prodObj.Vision_Proposed_BASE_Units__c : 0;
                    prodObj.Vision_Proposed_DSH_Units__c = (prodObj.Vision_Proposed_DSH_Units__c != '' && prodObj.Vision_Proposed_DSH_Units__c != undefined) ? prodObj.Vision_Proposed_DSH_Units__c : 0;
                    prodObj.Vision_Proposed_AutoSub_Units__c = (prodObj.Vision_Proposed_AutoSub_Units__c != '' && prodObj.Vision_Proposed_AutoSub_Units__c != undefined) ? prodObj.Vision_Proposed_AutoSub_Units__c : 0;
                    prodObj.Vision_Proposed_Smith_Drug_Units__c = (prodObj.Vision_Proposed_Smith_Drug_Units__c != '' && prodObj.Vision_Proposed_Smith_Drug_Units__c != undefined) ? prodObj.Vision_Proposed_Smith_Drug_Units__c : 0;
                    prodObj.Vision_Proposed_Anda_Units__c = (prodObj.Vision_Proposed_Anda_Units__c != '' && prodObj.Vision_Proposed_Anda_Units__c != undefined) ? prodObj.Vision_Proposed_Anda_Units__c : 0;
                    prodObj.Vision_Proposed_DirectAholdDelhaizeUnits__c = (prodObj.Vision_Proposed_DirectAholdDelhaizeUnits__c != '' && prodObj.Vision_Proposed_DirectAholdDelhaizeUnits__c != undefined) ? prodObj.Vision_Proposed_DirectAholdDelhaizeUnits__c : 0;
                    prodObj.Vision_Proposed_Direct_Gaint_Eagle_Units__c = (prodObj.Vision_Proposed_Direct_Gaint_Eagle_Units__c != '' && prodObj.Vision_Proposed_Direct_Gaint_Eagle_Units__c != undefined) ? prodObj.Vision_Proposed_Direct_Gaint_Eagle_Units__c : 0;
                    prodObj.Vision_Proposed_TotalRetailIndirectUnits__c = (prodObj.Vision_Proposed_TotalRetailIndirectUnits__c != '' && prodObj.Vision_Proposed_TotalRetailIndirectUnits__c != undefined) ? prodObj.Vision_Proposed_TotalRetailIndirectUnits__c : 0;
                    
                    prodObj.Vision_Proposed_Direct_ESI_Units__c = (prodObj.Vision_Proposed_Direct_ESI_Units__c != '' && prodObj.Vision_Proposed_Direct_ESI_Units__c != undefined) ? prodObj.Vision_Proposed_Direct_ESI_Units__c : 0;
                    prodObj.Vision_Proposed_Indirect_ESI_Units__c = (prodObj.Vision_Proposed_Indirect_ESI_Units__c != '' && prodObj.Vision_Proposed_Indirect_ESI_Units__c != undefined) ? prodObj.Vision_Proposed_Indirect_ESI_Units__c : 0;
                    prodObj.Vision_Proposed_Direct_Kroger_Units__c = (prodObj.Vision_Proposed_Direct_Kroger_Units__c != '' && prodObj.Vision_Proposed_Direct_Kroger_Units__c != undefined) ? prodObj.Vision_Proposed_Direct_Kroger_Units__c : 0;
                    prodObj.Vision_Proposed_Indirect_Kroger_Units__c = (prodObj.Vision_Proposed_Indirect_Kroger_Units__c != '' && prodObj.Vision_Proposed_Indirect_Kroger_Units__c != undefined) ? prodObj.Vision_Proposed_Indirect_Kroger_Units__c : 0;
                    prodObj.Vision_Proposed_Direct_Rx_Outreach_Units__c = (prodObj.Vision_Proposed_Direct_Rx_Outreach_Units__c != '' && prodObj.Vision_Proposed_Direct_Rx_Outreach_Units__c != undefined) ? prodObj.Vision_Proposed_Direct_Rx_Outreach_Units__c : 0;
                    prodObj.Vision_Proposed_IndirectRxOutreach_Units__c = (prodObj.Vision_Proposed_IndirectRxOutreach_Units__c != '' && prodObj.Vision_Proposed_IndirectRxOutreach_Units__c != undefined) ? prodObj.Vision_Proposed_IndirectRxOutreach_Units__c : 0;
                    prodObj.Vision_Proposed_Direct_Supervalu_Units__c = (prodObj.Vision_Proposed_Direct_Supervalu_Units__c != '' && prodObj.Vision_Proposed_Direct_Supervalu_Units__c != undefined) ? prodObj.Vision_Proposed_Direct_Supervalu_Units__c : 0;
                    prodObj.Vision_Proposed_Indirect_Supervalu_Units__c = (prodObj.Vision_Proposed_Indirect_Supervalu_Units__c != '' && prodObj.Vision_Proposed_Indirect_Supervalu_Units__c != undefined) ? prodObj.Vision_Proposed_Indirect_Supervalu_Units__c : 0;
                    prodObj.Vision_Proposed_Direct_Cigna_Units__c = (prodObj.Vision_Proposed_Direct_Cigna_Units__c != '' && prodObj.Vision_Proposed_Direct_Cigna_Units__c != undefined) ? prodObj.Vision_Proposed_Direct_Cigna_Units__c : 0;
                    prodObj.Vision_Proposed_Indirect_Cigna_Units__c = (prodObj.Vision_Proposed_Indirect_Cigna_Units__c != '' && prodObj.Vision_Proposed_Indirect_Cigna_Units__c != undefined) ? prodObj.Vision_Proposed_Indirect_Cigna_Units__c : 0;
                    prodObj.Vision_Proposed_Direct_Cordant_Units__c = (prodObj.Vision_Proposed_Direct_Cordant_Units__c != '' && prodObj.Vision_Proposed_Direct_Cordant_Units__c != undefined) ? prodObj.Vision_Proposed_Direct_Cordant_Units__c : 0;
                    prodObj.Vision_Proposed_Direct_Accerodo_Units__c = (prodObj.Vision_Proposed_Direct_Accerodo_Units__c != '' && prodObj.Vision_Proposed_Direct_Accerodo_Units__c != undefined) ? prodObj.Vision_Proposed_Direct_Accerodo_Units__c : 0;
                    prodObj.Vision_Proposed_Indirect_Accerodo_Units__c = (prodObj.Vision_Proposed_Indirect_Accerodo_Units__c != '' && prodObj.Vision_Proposed_Indirect_Accerodo_Units__c != undefined) ? prodObj.Vision_Proposed_Indirect_Accerodo_Units__c : 0;
                    prodObj.Vision_Proposed_Indirect_Cordant_Units__c = (prodObj.Vision_Proposed_Indirect_Cordant_Units__c != '' && prodObj.Vision_Proposed_Indirect_Cordant_Units__c != undefined) ? prodObj.Vision_Proposed_Indirect_Cordant_Units__c : 0;
                    prodObj.Vision_Total_Proposed_Units_EU__c = (prodObj.Vision_Total_Proposed_Units_EU__c != '' && prodObj.Vision_Total_Proposed_Units_EU__c != undefined) ? prodObj.Vision_Total_Proposed_Units_EU__c : 0;
                    prodObj.Vision_Proposed_Value_EA__c = (prodObj.Vision_Proposed_Value_EA__c != '' && prodObj.Vision_Proposed_Value_EA__c != undefined) ? prodObj.Vision_Proposed_Value_EA__c : 0;
                    
                    prodObj.Vision_Proposed_CVS_Direct_Units__c = (prodObj.Vision_Proposed_CVS_Direct_Units__c != '' && prodObj.Vision_Proposed_CVS_Direct_Units__c != undefined) ? prodObj.Vision_Proposed_CVS_Direct_Units__c : 0;
                    prodObj.Vision_Proposed_CVS_Indirect_Units__c = (prodObj.Vision_Proposed_CVS_Indirect_Units__c != '' && prodObj.Vision_Proposed_CVS_Indirect_Units__c != undefined) ? prodObj.Vision_Proposed_CVS_Indirect_Units__c : 0;
                    prodObj.Vision_Proposed_Cardinal_Units__c = (prodObj.Vision_Proposed_Cardinal_Units__c != '' && prodObj.Vision_Proposed_Cardinal_Units__c != undefined) ? prodObj.Vision_Proposed_Cardinal_Units__c : 0;
                    prodObj.Vision_Proposed_Major_Units__c = (prodObj.Vision_Proposed_Major_Units__c != '' && prodObj.Vision_Proposed_Major_Units__c != undefined) ? prodObj.Vision_Proposed_Major_Units__c : 0;
                    
                    totalProposedUnits = parseInt(prodObj.Proposed_Direct_Selling_Units__c)+parseInt(prodObj.Proposed_Indirect_Selling_Units__c)+parseInt(prodObj.Vision_Proposed_OS_Units__c)
                    +parseInt(prodObj.Vision_Proposed_RAD_Units__c)+parseInt(prodObj.Vision_Proposed_WMT_Units__c)+parseInt(prodObj.Vision_Proposed_BASE_Units__c)+parseInt(prodObj.Vision_Proposed_DSH_Units__c)
                    +parseInt(prodObj.Vision_Proposed_AutoSub_Units__c)+parseInt(prodObj.Vision_Proposed_Smith_Drug_Units__c)+parseInt(prodObj.Vision_Proposed_Anda_Units__c)+parseInt(prodObj.Vision_Proposed_DirectAholdDelhaizeUnits__c)
                    +parseInt(prodObj.Vision_Proposed_Direct_Gaint_Eagle_Units__c)+parseInt(prodObj.Vision_Proposed_TotalRetailIndirectUnits__c)+parseInt(prodObj.Vision_Proposed_Direct_ESI_Units__c)
                    +parseInt(prodObj.Vision_Proposed_Indirect_ESI_Units__c)+parseInt(prodObj.Vision_Proposed_Direct_Kroger_Units__c)+parseInt(prodObj.Vision_Proposed_Indirect_Kroger_Units__c)
                    +parseInt(prodObj.Vision_Proposed_Direct_Rx_Outreach_Units__c)+parseInt(prodObj.Vision_Proposed_IndirectRxOutreach_Units__c)+parseInt(prodObj.Vision_Proposed_Direct_Supervalu_Units__c)
                    +parseInt(prodObj.Vision_Proposed_Indirect_Supervalu_Units__c)+parseInt(prodObj.Vision_Proposed_Direct_Cigna_Units__c)+parseInt(prodObj.Vision_Proposed_Indirect_Cigna_Units__c)
                    +parseInt(prodObj.Vision_Proposed_Direct_Cordant_Units__c)+parseInt(prodObj.Vision_Proposed_Indirect_Cordant_Units__c)+parseInt(prodObj.Vision_Proposed_Direct_Accerodo_Units__c)
                    +parseInt(prodObj.Vision_Proposed_Indirect_Accerodo_Units__c)+parseInt(prodObj.Vision_Proposed_CVS_Direct_Units__c)+parseInt(prodObj.Vision_Proposed_CVS_Indirect_Units__c)+parseInt(prodObj.Vision_Proposed_Cardinal_Units__c)+parseInt(prodObj.Vision_Proposed_Major_Units__c);
                }
                
                var pkgSize = (prodObj.Vision_Product__r.Phoenix_Pkg_Size__c != undefined || prodObj.Vision_Product__r.Phoenix_Pkg_Size__c != null) ? prodObj.Vision_Product__r.Phoenix_Pkg_Size__c : 1;
                console.log('Pack Size: '+pkgSize);
                console.log('totalProposedUnits: '+totalProposedUnits);
                prodObj.Vision_Total_Proposed_Units_EU__c = pkgSize * totalProposedUnits;
                //prodObj.Vision_Proposed_Value_EA__c = totalProposedUnits * (prodObj.Target_Price__c != undefined ? prodObj.Target_Price__c : 0);
                prodObj.Vision_Proposed_Value_EA__c = prodObj.Vision_Total_Proposed_Units_EU__c * (prodObj.Target_Price__c != undefined ? prodObj.Target_Price__c : 0);//(prodObj.Vision_Product__r.Phoenix_Lowest_Price_SKU__c != undefined ? prodObj.Vision_Product__r.Phoenix_Lowest_Price_SKU__c : 0);
                proposedVal = proposedVal + (prodObj.Vision_Proposed_Value_EA__c != undefined ? prodObj.Vision_Proposed_Value_EA__c : 0);
                gTotalEU = gTotalEU + prodObj.Vision_Total_Proposed_Units_EU__c;
                gTotal = gTotal + totalProposedUnits;
            }
            updatedList.push(prodObj);
        });
        component.set("v.totalVolEA",gTotal);
        component.set("v.totalVolEU",gTotalEU);
        var totalVal = component.get("v.totalVal");
        //var proposedVal = gTotal * totalVal;
        component.set("v.proposedVal",proposedVal);
        component.set("v.ndcList",updatedList);
    },
    handleChange : function(component,event,helper){
        var selectedStatus = component.find("bidTypeId").get("v.value");
        component.set("v.bidType",selectedStatus);
    },
    createOpty : function(component, event, helper){     
        component.set("v.showNdcs",false);
        component.set("v.isSpinner",true);
        var prodList = component.get("v.ndcList");
        var accObj = component.get("v.accObj");
        var errorMessage = '';
        var isOtcProdFam = component.get("v.isOtcProdFam");
        prodList.forEach(function(prodObj){
            if(prodObj.Vision_isAccepted__c && prodObj.Vision_Product__r.Phoenix_Pkg_Size__c != undefined && prodObj.Target_Price__c != undefined){
                if(isOtcProdFam){
                    prodObj.Vision_Proposed_Share_Percentage__c = (prodObj.Vision_Proposed_Share_Percentage__c != '' && prodObj.Vision_Proposed_Share_Percentage__c != undefined) ? prodObj.Vision_Proposed_Share_Percentage__c : 0;
                    if(prodObj.Vision_Proposed_Share_Percentage__c>100)
                        errorMessage = 'Proposed Share % should not be grater than 100% for Product: '+prodObj.Vision_Product__r.Name;
                }
            }
        });
        if(errorMessage != ''){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type" : "ERROR",
                "title": "ERROR",
                "message": ""+errorMessage
            });
            toastEvent.fire();
            component.set("v.isSpinner",false);
            component.set("v.showNdcs",true);
        }
        else{
            var bidType = component.get("v.bidType");
            var allRecords = component.get("v.listOfAllAccounts");
            var selectedCntrcts = [];
            for (var i = 0; i < allRecords.length; i++) {
                if (allRecords[i].isChecked) {
                    selectedCntrcts.push(allRecords[i].Phoenix_Contract_Number__c);
                }
            }
            selectedCntrcts.forEach(function(con){console.log('con ---> '+con)});
            if(selectedCntrcts.length == 0){
                var conString = component.get("v.conString");
                var selectedCntrcts = [];
                if(conString.includes(',')){
                    conString.split(',').forEach(function(conItem){
                        selectedCntrcts.push(conItem);
                    });
                }
                else
                    selectedCntrcts.push(conString);
            }
            var action = component.get("c.createOptyCntl");
            action.setParams({prodList : prodList, bidType : bidType,
                              totalVol : component.get("v.totalVol"),
                              internalTargetDate:component.get("v.internalTargetDate"),
                              selectrcs : selectedCntrcts,
                              templateType : component.get("v.templateType")
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
                        component.set("v.showNdcs",true);
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
                    component.set("v.showNdcs",true);
                }
            });
            $A.enqueueAction(action);
        }
    },
    
    closeModal : function(component, event, helper){
        component.set("v.showContracts",false);
    },
    
    showContracts : function(component, event, helper){
        component.set("v.isSpinner",true);
        var ndcList = component.get("v.shareItem.expnList");
        component.set("v.ndcList",ndcList);
        for(var i=0; i<ndcList.length; i++){
            console.log('Target Price is: '+ndcList[i].Target_Price__c);
        }
        var fetchCons = false;
        var conString = '';
        ndcList.forEach(function(ndcObj){
            if(!fetchCons && ndcObj.Vision_Reference_Contracts__c != undefined){
                fetchCons = true;
                conString = ndcObj.Vision_Reference_Contracts__c;
            }
        });
        if(fetchCons){
            component.set("v.conString",conString);
            var selectedCntrcts = [];
            if(conString.includes(',')){
                conString.split(',').forEach(function(conItem){
                    selectedCntrcts.push(conItem);
                });
            }
            else
                selectedCntrcts.push(conString);
            var action = component.get("c.saveShareExpWithContracts");
            action.setParams({selectrcs: selectedCntrcts,
                              ndcValues : ndcList,
                              accId : component.get("v.accObj.Id")}); 
            action.setCallback(this, function(response){
                if (response.getState() === "SUCCESS") {
                    var ndcList = response.getReturnValue();
                    component.set("v.ndcList",ndcList);
                    var a = component.get('c.showNdcList');
                    console.log('Inner NDC List: '+JSON.stringify(ndcList));
                    $A.enqueueAction(a);
                }
                else{
                    console.log('ERROR from saving Opty --> '+JSON.stringify(response.getError()));
                }
            }); $A.enqueueAction(action);
        }
        else{
            component.set("v.showContracts",true);
            helper.fetchContratcs(component, event,helper,component.get("v.recordId"),'');
        }
        /*component.set('v.mycolumns', [
            {label: 'Name', fieldName: 'Phoenix_Contract_Number__c', type: 'text'},
            {label: 'Customer', fieldName: 'Phoenix_Customer__c', type: 'text'},
            {label: 'Internal Description', fieldName: 'Phoenix_Contract_Internal_Description__c', type: 'text'},
            {label: 'External Description', fieldName: 'Phoenix_Contract_External_Description__c', type: 'Text'}
        ]); 

        var action = component.get("c.getContracts");
        action.setParams({customerID: component.get("v.recordId")}); 
        action.setCallback(this, function(response){
            if (response.getState() === "SUCCESS") {
                component.set("v.showModal", true);
                var responseList = response.getReturnValue();
                var sltcntcntrcs=component.get('v.selectedCntrcts');
                var finalContratcs = responseList.filter(comparer(sltcntcntrcs)); 
                function comparer(otherArray){
                    return function(current){
                        return otherArray.filter(function(other){                                               
                            return other == current.Phoenix_Contract_Number__c 
                        }).length == 0;
                    }
                }
                for (var i = 0; i < finalContratcs.length; i++) {
                    var row = finalContratcs[i];
                    if(row.Phoenix_Customer__c){
                        row.Phoenix_Customer__c=row.Phoenix_Customer__r.Name;                                           
                    }                                      
                }
                component.set("v.isSpinner", false);
                component.set("v.contratcsList",finalContratcs);
            }
            else{
                component.set("v.isSpinner", false);
                console.log('ERROR ---> '+JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);*/
    },
    
    
    // JS Controller for Contract View
    searchContracts: function(component, event, helper) {
        component.set("v.currentPage",1);
        var searchInput=component.find("cntInput").get("v.value");
        console.log('searchInput---'+searchInput);
        var checkToggle=component.find("tgleCntrct").get("v.checked");            
        var bidCustomerId=component.get("v.recordId");
        console.log('--bidCustomerId--'+bidCustomerId); 
        if(checkToggle==true){
            helper.fetchContratcs(component, event, helper, null, searchInput);
        }
        else{
            if(bidCustomerId != null && bidCustomerId != undefined){
                helper.fetchContratcs(component, event, helper, bidCustomerId, searchInput);
            }else{
                component.set("v.contratcsList",null);
            }
        }
        
    }, 
    
    showAllContracts: function(component, event, helper) {
        component.set("v.selectedRowsCount",0);
        component.set("v.currentPage",1);
        var searchInput=component.find("cntInput").get("v.value");
        console.log('searchInput---'+searchInput);
        var checkToggle=component.find("tgleCntrct").get("v.checked");
        console.log('--checkToggle--'+checkToggle); 
        var bCustomerId=component.get('v.recordId');
        console.log('--showAllContracts bCustomerId --'+bCustomerId);
        if(checkToggle==true){
            helper.fetchContratcs(component, event, helper, null, searchInput);
        }
        else{
            if(bCustomerId != null && bCustomerId != undefined){
                helper.fetchContratcs(component, event, helper, bCustomerId, searchInput);
            }else{
                component.set("v.PaginationList",null);
            }
        }
    },
    
    /* javaScript function for pagination */
    navigation: function(component, event, helper) {
        var sObjectList = component.get("v.listOfAllAccounts");
        var end = component.get("v.endPage");
        var start = component.get("v.startPage");
        var pageSize = component.get("v.pageSizeCV");
        var whichBtn = event.getSource().get("v.name");
        // check if whichBtn value is 'next' then call 'next' helper method
        if (whichBtn == 'next') {
            component.set("v.currentPage", component.get("v.currentPage") + 1);
            helper.next(component, event, sObjectList, end, start, pageSize);
        }
        // check if whichBtn value is 'previous' then call 'previous' helper method
        else if (whichBtn == 'previous') {
            component.set("v.currentPage", component.get("v.currentPage") - 1);
            helper.previous(component, event, sObjectList, end, start, pageSize);
        }
        // check if whichBtn value is 'First' then call 'First' helper method
            else if (whichBtn == 'first') {
                var starting = pageSize;
                var lastPage = pageSize - 1;
                component.set("v.currentPage", 1);
                helper.previous(component, event, sObjectList, lastPage, starting, pageSize);
            }
        // check if whichBtn value is 'Last' then call 'Last' helper method
                else if (whichBtn == 'last') {
                    var tPageCount = component.get("v.totalPagesCount");
                    var starting = (tPageCount-2)* pageSize;
                    var lastPage = (tPageCount - 1)* pageSize - 1;
                    component.set("v.currentPage", component.get("v.totalPagesCount"));
                    helper.next(component, event, sObjectList, lastPage, starting, pageSize);
                }
        
        var curPage = component.get("v.currentPage");
        var totalPC = component.get("v.totalPagesCount");
        
        if(curPage == 1) component.set('v.isFirstPage', true);
        else component.set('v.isFirstPage', false);
        
        if(curPage == totalPC) component.set('v.isLastPage', true);
        else component.set('v.isLastPage', false);
        
        var elmnt = document.getElementById("tableDiv");
        elmnt.scrollTop=0;
        
        helper.getPaginationList(component, helper);
    },
    
    processMeCV: function(component, event, helper) {
        var sObjectList = component.get("v.listOfAllAccounts");
        var pageSize = component.get("v.pageSizeCV");
        var whichPage = event.target.name;
        var totalPC = component.get("v.totalPagesCount");
        var curPage = component.get('v.currentPage');
        console.log('totalPC::'+totalPC);
        
        if(whichPage == 1) component.set('v.isFirstPage', true);
        else component.set('v.isFirstPage', false);
        
        if(whichPage == totalPC) component.set('v.isLastPage', true);
        else component.set('v.isLastPage', false);
        
        component.set('v.isSelectedNo', whichPage);
        
        console.log('whichPage::'+whichPage);
        
        console.log('isSelectedNo::'+component.get('v.isSelectedNo'));
        
        if (whichPage) {
            var start = (whichPage - 1) * pageSize;
            var end = (start + pageSize) - 1;
            console.log('end::'+end);
            component.set('v.currentPage', parseInt(whichPage));
            helper.processPageNumber(component, event, sObjectList, end, start, pageSize);
        }
        var elmnt = document.getElementById("tableDiv");
        elmnt.scrollTop=0;
        
        helper.getPaginationList(component, helper);
    },
    
    selectAllCheckboxes: function(component, event, helper) {
        var selectedHeaderCheck = event.getSource().get("v.value");
        var updatedAllRecords = [];
        var updatedPaginationList = [];
        var listOfAllAccounts = component.get("v.listOfAllAccounts");
        var PaginationList = component.get("v.PaginationList");
        var selectedRowsCount = component.get("v.selectedRowsCount");
        var selectedContId = component.get('v.selectedContId');
        for (var i = 0; i < PaginationList.length; i++) {
            console.log('PaginationList length::'+PaginationList.length);
            if (selectedHeaderCheck == true) {
                if(!PaginationList[i].isChecked) {
                    PaginationList[i].isChecked = true;
                    selectedContId.push(PaginationList[i].Id);
                    selectedRowsCount++;
                }
            } else {
                if(PaginationList[i].isChecked && selectedContId.includes(PaginationList[i].Id)) {
                    selectedContId.pop(PaginationList[i].Id);
                }
                PaginationList[i].isChecked = false;
                selectedRowsCount--;
            }
            updatedPaginationList.push(PaginationList[i]);
        }
        component.set('v.selectedContId',selectedContId);
        if(selectedRowsCount > 0) component.set("v.selectedRowsCount",selectedRowsCount);
        else component.set("v.selectedRowsCount",0);
        //component.set("v.listOfAllAccounts", updatedAllRecords);
        component.set("v.PaginationList", updatedPaginationList);
    },
    
    checkboxSelect: function(component, event, helper) {
        // on each checkbox selection update the selected record count 
        var selectedRec = event.getSource().get("v.value");
        var selectedRecId = event.getSource().get("v.text");
        console.log('selectedRecId::'+selectedRecId);
        var selectedContId = component.get('v.selectedContId');
        var getSelectedNumber = component.get("v.selectedRowsCount");
        if (selectedRec == true) {
            if (!selectedContId.includes(selectedContId)) {
                getSelectedNumber++;
                selectedContId.push(selectedRecId);
            }
            
        } else {
            selectedContId.pop(selectedRecId);
            getSelectedNumber--;
            component.find("selectAllId").set("v.value", false);
        }
        component.set("v.selectedRowsCount", getSelectedNumber);
        component.set('v.selectedContId',selectedContId);
        // if all checkboxes are checked then set header checkbox with true   
        if (getSelectedNumber == component.get("v.totalRecordsCountCV")) {
            component.find("selectAllId").set("v.value", true);
        }
        helper.getPaginationList(component, helper);
    },
    
    saveDetails : function(component, event, helper){
        component.set("v.isSpinner",true);
        component.set("v.showContracts",false);
        var allRecords = component.get("v.listOfAllAccounts");
        var selectedCntrcts = [];
        for (var i = 0; i < allRecords.length; i++) {
            if (allRecords[i].isChecked) {
                selectedCntrcts.push(allRecords[i].Phoenix_Contract_Number__c);
            }
        }
        var conString = selectedCntrcts.join(',');
        component.set("v.conString",conString);
        //selectedCntrcts.forEach(function(con){console.log('con ---> '+con)});
        var ndcValues = component.get("v.ndcList");//component.get("v.shareItem.expnList");
        var action = component.get("c.saveShareExpWithContracts");
        action.setParams({selectrcs: selectedCntrcts,
                          ndcValues : ndcValues,
                          accId : component.get("v.accObj.Id")}); 
        action.setCallback(this, function(response){
            if (response.getState() === "SUCCESS") {
                var ndcList = response.getReturnValue();
                component.set("v.ndcList",ndcList);
                var a = component.get('c.showNdcList');
                $A.enqueueAction(a);
            }
            else{
                console.log('ERROR from saving Opty --> '+JSON.stringify(response.getError()));
            }
        }); $A.enqueueAction(action);
    },
    showSAdetails : function(component, event, helper){
        var listValues = event.currentTarget.id;
        document.getElementById(listValues+'contact').style.display="";
    },
    hideSAdetails : function(component, event, helper){
        var listValues = event.currentTarget.id;
        document.getElementById(listValues+"contact").style.display="none";
    },
})