({
    doInit: function(component, event, helper){
        var singleRec = component.get("v.singleRec");
        console.log('Single Rec: '+JSON.stringify(singleRec));
        if(singleRec.isProductFamilyMatched == false){
            var tableCell = component.find('familyCell');
            $A.util.addClass(tableCell, 'highlightFamily')
        } else{
            var tableCell = component.find('familyCell');
            $A.util.removeClass(tableCell, 'highlightFamily')            
        }
    },
    inlineEditWAC: function (component, event, helper) {
        component.set("v.WACEditMode", true);
        setTimeout(function () {
            component.find("inputWAC").focus();
        }, 100);
    },
    closeWACBox: function (component, event, helper) {
        component.set("v.WACEditMode", false);
    },
    onWACChange: function (component, event, helper) {
        var val = event.getSource().get('v.value');
        var singleRec = component.get("v.singleRec");
        var oldWAC = singleRec.Phoenix_System_WAC__c;
        var WACDiff = oldWAC-val;
        component.set("v.singleRec.Phoenix_Uploaded_WAC__c", val);
        component.set("v.singleRec.Phoenix_SysWAC_Vs_UploadedWAC__c", WACDiff);
        var myCmp = component.find("inlineInputWAC");
        $A.util.addClass(myCmp, "cellColor");
        var compEvent = component.getEvent("WACChangeEvent");
        compEvent.setParams({"isValueChanged" : true });
        compEvent.fire();
    },
    
    inlineEditContractPrice: function (component, event, helper) {
        component.set("v.ContractPriceEditMode", true);
        setTimeout(function () {
            component.find("inputContractPrice").focus();
        }, 100);
    },
    closeContractPriceBox: function (component, event, helper) {
        component.set("v.ContractPriceEditMode", false);
    },
    onContractPriceChange: function (component, event, helper) {
        var val = event.getSource().get('v.value');
        var singleRec = component.get("v.singleRec");
        var oldContractPrice = singleRec.Phoenix_System_Contract_price__c;
        if(val == null || val == undefined){
            var myCmp = component.find("inlineInputContractPrice");
            $A.util.removeClass(myCmp, "cellColor");
            component.set("v.singleRec.Phoenix_Uploaded_Contr_Price__c", '');
            component.set("v.singleRec.Phoenix_SysContPrice_Vs_UploadContrPrice__c", '');
        } else{
            component.set("v.singleRec.Phoenix_Uploaded_Contr_Price__c", val);
            var ContractPriceDiff = oldContractPrice-val;
            component.set("v.singleRec.Phoenix_SysContPrice_Vs_UploadContrPrice__c", ContractPriceDiff);
            var myCmp = component.find("inlineInputContractPrice");
            $A.util.addClass(myCmp, "cellColor");
            var compEvent = component.getEvent("WACChangeEvent");
            compEvent.setParams({"isValueChanged" : true });
            compEvent.fire();   
        }
    },
    inlineEditProposedWAC: function (component, event, helper) {
        component.set("v.ProposedWACEditMode", true);
        setTimeout(function () {
            component.find("inputProposedWAC").focus();
        }, 100);
    },
    closeProposedWACBox: function (component, event, helper) {
        component.set("v.ProposedWACEditMode", false);
    },
    onProposedWACChange: function (component, event, helper) {
        var val = event.getSource().get('v.value');
        console.log('Value is::: '+val);
        var singleRec = component.get("v.singleRec");
        var oldWAC = singleRec.Phoenix_System_WAC__c;
        if(val == null || val == undefined){
            var myCmp = component.find("inlineInputProposedWAC");
            $A.util.removeClass(myCmp, "cellColor");
            component.set("v.singleRec.Phoenix_Proposed_WAC__c", '');
            component.set("v.singleRec.Phoenix_Sys_WAC_Vs_Proposed_WAC__c", ''); 
        } else{
            var myCmp = component.find("inlineInputProposedWAC");
            $A.util.addClass(myCmp, "cellColor");
            var oldWACVsProposedWAC = oldWAC - val;
            component.set("v.singleRec.Phoenix_Proposed_WAC__c", val);
            component.set("v.singleRec.Phoenix_Sys_WAC_Vs_Proposed_WAC__c", oldWACVsProposedWAC);
        }
        var compEvent = component.getEvent("WACChangeEvent");
        compEvent.setParams({"isValueChanged" : true });
        compEvent.fire();
    },
    
    inlineEditProposedContractPrice: function (component, event, helper) {
        component.set("v.ProposedContractPriceEditMode", true);
        setTimeout(function () {
            component.find("inputProposedContractPrice").focus();
        }, 100);
    },
    closeProposedContractPriceBox: function (component, event, helper) {
        component.set("v.ProposedContractPriceEditMode", false);
    },
    onProposedContractPriceChange: function (component, event, helper) {
        var val = event.getSource().get('v.value');
        console.log('Value is::: '+val);
        var singleRec = component.get("v.singleRec");
        var oldContractPrice = singleRec.Phoenix_System_Contract_price__c;
        if(val == null || val == undefined){
            var myCmp = component.find("inlineInputProposedContractPrice");
            $A.util.removeClass(myCmp, "cellColor");
            //component.set("v.singleRec.Phoenix_Proposed_Contr_Price__c", '');
            //component.set("v.singleRec.Phoenix_SysContrPrice_Vs_PropContrPrice__c", '');            
        } else{
            var oldContractPriceVsProposedContractPrice = oldContractPrice-val;
            component.set("v.singleRec.Phoenix_Proposed_Contr_Price__c", val);
            component.set("v.singleRec.Phoenix_SysContrPrice_Vs_PropContrPrice__c", oldContractPriceVsProposedContractPrice);
            var myCmp = component.find("inlineInputProposedContractPrice");
            $A.util.addClass(myCmp, "cellColor");
            var compEvent = component.getEvent("WACChangeEvent");
            compEvent.setParams({"isValueChanged" : true });
            compEvent.fire();   
        }
    },
    
    inlineEditComments: function (component, event, helper) {
        component.set("v.CommentsEditMode", true);
        setTimeout(function () {
            component.find("inputComments").focus();
        }, 100);
    },
    closeCommentsBox: function (component, event, helper) {
        component.set("v.CommentsEditMode", false);
    },
    onCommentsChange: function (component, event, helper) {
        var val = event.getSource().get('v.value');
        console.log('Value is::: '+val);
        var myCmp = component.find("inlineInputComments");
        $A.util.addClass(myCmp, "cellColor");
        var compEvent = component.getEvent("WACChangeEvent");
        compEvent.setParams({"isValueChanged" : true });
        compEvent.fire();
    },
})