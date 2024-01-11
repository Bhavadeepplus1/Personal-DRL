({	
    doInit: function(component, event, helper){
        //console.log('component.get("v.optyObj") IN lineChild----> '+JSON.stringify(component.get("v.optyObj")));
        //console.log('templateType in child ---> '+component.get("v.templateType"));
        //console.log('Row Index:: '+component.get("v.rowIndex"));
        helper.doCalcs(component,event,helper);
        if(component.get("v.isRecordSaved")){
            console.log('singleRec.prdlist.Phoenix_Lowest_Price_SKU__c :: ---> '+component.get("v.singleSavedRec.Lowest_Price_SKU__c"));
            component.set("v.lowestPriceVal",component.get("v.singleSavedRec.Lowest_Price_SKU__c"));
            
            /*var action = component.get("c.getCompetitorInfoObjData");
            action.setParams({ "ndcWithDashes": component.get("v.singleSavedRec.NDC_11__c"),
                                "ndc": component.get("v.singleSavedRec.NDC_11__c")});
            action.setCallback(this, function(response){
                if(response.getState() == 'SUCCESS'){
                    console.log('Response::1 '+JSON.stringify(response.getReturnValue()));
                    var resp = response.getReturnValue();
                    console.log('Length: '+typeof resp);
                    /*var key;
                    if(component.get("v.isRecordSaved")){
                        key = component.get("v.singleSavedRec.Product__r.Name");
                    } else{
                        key = component.get("v.singleRec.prdlist.Name");   
                    }
                    console.log('Key'+ key);*/
                    /*if (component.get("v.singleSavedRec.NDC_11__c") in resp){
                        console.log(':::: Competitor Info Matched Record:: '+JSON.stringify(resp));
                        component.set("v.competitorData", resp[component.get("v.singleSavedRec.NDC_11__c")]);
                    } else{
                        console.log(':::: Competitor Info Unmatched Record :: ');   
                    }
                } else{
                    console.log('Error::: ');
                }
            });
            $A.enqueueAction(action);*/
        }
        else{
            //console.log('singleRec.prdlist.Phoenix_Lowest_Price_SKU__c :: ---> '+component.get("v.singleRec.prdlist.Phoenix_Lowest_Price_SKU__c"));
            component.set("v.lowestPriceVal",component.get("v.singleRec.prdlist.Phoenix_Lowest_Price_SKU__c"));
            /*var action = component.get("c.getCompetitorInfoObjData");
            action.setParams({ "ndcWithDashes": component.get("v.singleRec.prdlist.Phoenix_NDC_11_Dashes__c"),
                                "ndc": component.get("v.singleRec.prdlist.Phoenix_NDC_11__c")});
            action.setCallback(this, function(response){
                if(response.getState() == 'SUCCESS'){
                    //console.log('Response::1 '+JSON.stringify(response.getReturnValue()));
                    var resp = response.getReturnValue();
                    console.log('Length: '+typeof resp);
                    //var key;
                    //if(component.get("v.isRecordSaved")){
                    //    key = component.get("v.singleSavedRec.Product__r.Name");
                    //} else{
                    //    key = component.get("v.singleRec.prdlist.Name");   
                    //}
                    //console.log('Key'+ key);
                    if (component.get("v.singleRec.prdlist.Phoenix_NDC_11_Dashes__c") in resp){
                        //console.log(':::: Competitor Info Matched Record:: '+JSON.stringify(resp));
                        component.set("v.competitorData", resp[component.get("v.singleRec.prdlist.Phoenix_NDC_11_Dashes__c")]);
                    } else if(component.get("v.singleRec.prdlist.Phoenix_NDC_11__c") in resp){
                        //console.log(':::: Competitor Info Matched Record:: '+JSON.stringify(resp));
                        component.set("v.competitorData", resp[component.get("v.singleRec.prdlist.Phoenix_NDC_11__c")]);
                    }
                        else{
                            //console.log(':::: Competitor Info Unmatched Record :: '); 
                        }
                } else{
                    //console.log('Error::: ');
                }
            });
            $A.enqueueAction(action);*/
        }
    },
    onChangeCompetitor: function(component, event, helper){
        console.log('Selected Competitor::: '+component.find('Competitorauraid').get('v.value'))
    },
    removeDeletedRow: function(component, event, helper){
        console.log('Delete Row');
        if(component.get("v.isRecordSaved")){
            component.getEvent("DeleteRowEvt").setParams({"recordIdToDelete" : component.get("v.singleSavedRec.Product__r.Id") }).fire();
        } else{
            component.getEvent("DeleteRowEvt").setParams({"recordIdToDelete" : component.get("v.singleRec.prdlist.Id") }).fire();
		}
    },
    editLineItem : function(component, event, helper) {
        console.log('Called Edit Line Item');
        component.set("v.showUserInputs",component.get("v.showUserInputs")?false:true);
        if(!component.get("v.showUserInputs")){
            if(component.get("v.isRecordSaved")){
                component.set("v.singleSavedRec", component.get("v.singleSavedRec"));
            } else{
             	component.set("v.singleRec", component.get("v.singleRec"));   
            }
        }
    },
    handleOnClick : function(component, event, helper) {
        $A.util.toggleClass(component.find("divHelp"), 'slds-hide');
    },
    handleMouseLeave : function(component, event, helper) {
        $A.util.addClass(component.find("divHelp"), 'slds-hide');
        /*var timer = component.get("v.timer");
        clearTimeout(timer);
        timer = setTimeout(function(){
            $A.util.addClass(component.find("divHelp"), 'slds-hide');
            clearTimeout(timer);
        }, 300);
        component.set("v.timer", timer);*/
    },
    handleMouseEnter : function(component, event, helper) {
        $A.util.removeClass(component.find("divHelp"), 'slds-hide');
    },
    handleMouseHover: function(component, event, helper) {
        console.log('handleMouseHover Called');
        var my = event.srcElement.id;
        component.set("v.reId",my);
        component.set("v.hoverRow", component.get("v.rowIndex"));
        component.set("v.togglehover",true);
        console.log('Index:: '+component.get("v.rowIndex"));
        console.log('Hover Row:: '+component.get("v.hoverRow"));
        console.log('togglehover:: '+component.get("v.togglehover"));

    },
    handleMouseOut: function(component, event, helper) {
        component.set("v.hoverRow",-1);
        component.set("v.togglehover",false);

    },
    handleMouseOut: function(component, event, helper) {
        component.set("v.hoverRow",-1);
        component.set("v.togglehover",false);

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
    },
    inlineEditGuidancePrice : function(component, event, helper){
        component.set("v.GDPEditMode",true);
    },
    closeGDPBox : function(component, event, helper){
        component.set("v.GDPEditMode",false);
    },
    inlineEditProposedUnits : function(component, event, helper){
        component.set("v.unitsEditMode",true);
    },
    closePropUnitsBox : function(component, event, helper){
        component.set("v.unitsEditMode",false);
    },
    inlineEditDirProposedUnits : function(component, event, helper){
        component.set("v.dirunitsEditMode",true);
    },
    closeDirPropUnitsBox : function(component, event, helper){
        component.set("v.dirunitsEditMode",false);
    },
    getProUnits: function (component, event, helper) {
        component.set("v.singleRec.proposedUnitsVal", component.get("v.proposedUnitsVal"));
        helper.doCalcs(component,event,helper);
        /*if(component.get("v.isRecordSaved")){
            console.log('Is Record Saved called');
            var val = component.get("v.singleSavedRec.Vision_Proposed_Units__c");
            if(val){
                var guidancePrice = component.get("v.singleSavedRec.Vision_Guidance_Price__c");
                console.log('inside proposed vals');
                if(guidancePrice){
                    console.log('inside guidancePrice vals');
                    component.set("v.singleSavedRec.Vision_Opportunity_Value__c", Math.round(val * guidancePrice));
                } 
                else{
                    component.set("v.singleSavedRec.Vision_Opportunity_Value__c", Math.round(val * component.get("v.singleSavedRec.Lowest_Price_SKU__c")));
                }
            } 
            else{
                component.set("v.singleSavedRec.Vision_Opportunity_Value__c", null);
            }
        }
        else{
            console.log('Proposed Units::: '+component.get("v.proposedUnitsVal"));
            var val = component.get("v.proposedUnitsVal");
            var guidancePrice = component.get("v.guidancePriceVal");
            
            component.set("v.singleRec.proposedUnitsVal", val);
            console.log('lowestPriceVal:: '+component.get("v.lowestPriceVal"));
            if(val){
                console.log('inside proposed vals');
                if(guidancePrice){
                    console.log('inside guidancePrice vals');
                    component.set("v.singleRec.opportunityVal", Math.round(val * guidancePrice));
                } 
                else{
                    component.set("v.singleRec.opportunityVal", Math.round(val * component.get("v.lowestPriceVal")));
                }
            } 
            else{
                component.set("v.singleRec.opportunityVal", null);
            }
        }*/
    },
    getDirProUnits : function (component, event, helper) {
        component.set("v.singleRec.proposedDirectUnits",component.get("v.proposedDirectUnits"));
        helper.doCalcs(component,event,helper);
    },
    getGuiPrice: function (component, event, helper) {
        component.set("v.singleRec.guidancePriceVal", component.get("v.guidancePriceVal"));
        helper.doCalcs(component,event,helper);
        /*if(component.get("v.isRecordSaved")){
            console.log('Guidance Price::: '+component.get("v.singleSavedRec.Vision_Guidance_Price__c"));
            console.log('Proposed Units::: '+component.get("v.singleSavedRec.Vision_Proposed_Units__c"));
            // var salesPrice = component.get("v.salesPriceVal");
            var proposedUnitVal = component.get("v.singleSavedRec.Vision_Proposed_Units__c");
            var val = component.get("v.singleSavedRec.Vision_Guidance_Price__c");
            
            if(proposedUnitVal){
                console.log('inside proposed vals');
                if(val){
                    console.log('inside guidancePrice vals');
                    console.log('proposedUnitVal * val :: '+(proposedUnitVal * val));
                    component.set("v.singleSavedRec.Vision_Opportunity_Value__c", proposedUnitVal * val);
                }
                else{
                    component.set("v.singleSavedRec.Vision_Opportunity_Value__c", proposedUnitVal * component.get("v.singleSavedRec.Lowest_Price_SKU__c"));
                }
            }
        }
        else{
            console.log('Guidance Price::: '+component.get("v.guidancePriceVal"));
            console.log('Proposed Units::: '+component.get("v.proposedUnitsVal"));
            // var salesPrice = component.get("v.salesPriceVal");
            var proposedUnitVal = component.get("v.proposedUnitsVal");
            var singleRec = component.get("v.singleRec");
            console.log('lowestPriceVal:: '+component.get("v.lowestPriceVal"));
            console.log('singleRec.guidancePriceVal :: '+singleRec.guidancePriceVal);
            var val = component.get("v.guidancePriceVal");
            if(val){
                component.set("v.singleRec.guidancePriceVal", val);
            }
            if(proposedUnitVal){
                console.log('inside proposed vals');
                if(val){
                    console.log('inside guidancePrice vals');
                    console.log('proposedUnitVal * val :: '+(proposedUnitVal * val));
                    component.set("v.singleRec.opportunityVal", proposedUnitVal * val);
                }
                else{
                    component.set("v.singleRec.opportunityVal", proposedUnitVal * component.get("v.lowestPriceVal"));
                }
            }
        }*/
    },
    inlineEditBaseUnits : function(component, event, helper){
        component.set("v.baseUnitsEditMode",true);
    },
    closeBaseUnitsBox : function(component, event, helper){
        component.set("v.baseUnitsEditMode",false);
    },
    inlineEditdshUnits : function(component, event, helper){
        component.set("v.dshUnitsEditMode",true);
    },
    closeDshUnitsBox : function(component, event, helper){
        component.set("v.dshUnitsEditMode",false);
    },
    inlineEditAutoSubUnits : function(component, event, helper){
        component.set("v.autoSubUnitsEditMode",true);
    },
    closeAutoSubUnitsBox : function(component, event, helper){
        component.set("v.autoSubUnitsEditMode",false);
    },
    inlineEditSmithDrugUnits : function(component, event, helper){
        component.set("v.smithDrugUnitsEditMode",true);
    },
    closeSmithDrugUnitsEditMode : function(component, event, helper){
        component.set("v.smithDrugUnitsEditMode",false);
    },
    inlineEditAndaUnits : function(component, event, helper){
        component.set("v.andaUnitsEditMode",true);
    },
    closeAndaUnitsEditMode : function(component, event, helper){
        component.set("v.andaUnitsEditMode",false);
    },
    inlineEditAholdUnits : function(component, event, helper){
        component.set("v.aholdUnitsEditMode",true);
    },
    closeAholdUnitsEditMode : function(component, event, helper){
        component.set("v.aholdUnitsEditMode",false);
    },
    inlineEditGaintEagleUnits : function(component, event, helper){
        component.set("v.gaintEagleUnitsEditMode",true);
    },
    closeGaintEagleUnitsEditMode : function(component, event, helper){
        component.set("v.gaintEagleUnitsEditMode",false);
    },
    inlineEditTotalRetailUnits : function(component, event, helper){
        component.set("v.totalRetailUnitsEditMode",true);
    },
    closeTotalRetailUnitsEditMode : function(component, event, helper){
        component.set("v.totalRetailUnitsEditMode",false);
    },
    
    closePropUnitsBox : function(component, event, helper){
        component.set("v.unitsEditMode",false);
    },
    closeIndirectPropUnitsBox : function(component, event, helper){
        component.set("v.inDirectUnitsEditMode",false);
    },
    closeOsPropUnitsBox : function(component, event, helper){
        component.set("v.osUnitsEditMode",false);
    },
    closeRadPropUnitsBox : function(component, event, helper){
        component.set("v.radUnitsEditMode",false);
    },
    closeWmtPropUnitsBox : function(component, event, helper){
        component.set("v.wmtUnitsEditMode",false);
    },
    
    inlineEditOsProposedUnits : function(component, event, helper){
            component.set("v.osUnitsEditMode",true);
    },
    inlineEditRadProposedUnits : function(component, event, helper){
            component.set("v.radUnitsEditMode",true);
    },
    inlineEditWmtProposedUnits : function(component, event, helper){
            component.set("v.wmtUnitsEditMode",true);
    },
    getProOsUnits: function (component, event, helper) {
        helper.doCalcs(component,event,helper);
    },
    getProRadUnits: function (component, event, helper) {
        helper.doCalcs(component,event,helper);
    },
    getProWmtUnits: function (component, event, helper) {
        helper.doCalcs(component,event,helper);
    },
    updateRecordCtrl : function (component, event, helper) {
        helper.doCalcs(component,event,helper);
    },
})