({
	doInit : function(component, event, helper) {
        console.log('Single Record: '+JSON.stringify(component.get("v.singleRec")));
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
        var lowestPrice = component.get("v.singleRec").Phoenix_Lowest_Price__c;
        if(val < lowestPrice){
            var message = 'Lowest Price should not be greater than WAC';
            helper.showErrorToast(component, event, message);
            var myCmp = component.find("inlineInputWAC");
            $A.util.addClass(myCmp, "cellColor");
            $A.util.addClass(myCmp, "slds-cell-edit slds-has-error");
        } else{
            var myCmp = component.find("inlineInputWAC");
            $A.util.addClass(myCmp, "cellColor");
            $A.util.removeClass(myCmp, "slds-cell-edit slds-has-error");
        }
    },
    
    inlineEditLowestPrice: function (component, event, helper) {
        component.set("v.LowestPriceEditMode", true);
        setTimeout(function () {
            component.find("inputLowestPrice").focus();
        }, 100);
    },
    closeLowestPriceBox: function (component, event, helper) {
        component.set("v.LowestPriceEditMode", false);
    },
    onLowestPriceChange: function (component, event, helper) {
        var val = event.getSource().get('v.value');
        var wac = component.get("v.singleRec").Phoenix_WAC1__c;
        if(val > wac){
            var message = 'Lowest Price should not be greater than WAC';
            helper.showErrorToast(component, event, message);
            var myCmp = component.find("inlineInputLowestPrice");
            $A.util.addClass(myCmp, "cellColor");
            $A.util.addClass(myCmp, "slds-cell-edit slds-has-error");
        } else{
            var myCmp = component.find("inlineInputLowestPrice");
            $A.util.addClass(myCmp, "cellColor");
            $A.util.removeClass(myCmp, "slds-cell-edit slds-has-error");
        }
    },
    
    inlineEditTPTGM: function (component, event, helper) {
        component.set("v.TPTGMEditMode", true);
        setTimeout(function () {
            component.find("inputTPTGM").focus();
        }, 100);
    },
    closeTPTGMBox: function (component, event, helper) {
        component.set("v.TPTGMEditMode", false);
    },
    onTPTGMChange: function (component, event, helper) {
        var val = event.getSource().get('v.value');
        if(val == '' || val == null || val == undefined){
            component.set("v.singleRec.TPT_GM", '');
            component.set("v.singleRec.Phoenix_TPT_GM__c", '');
            var myCmp = component.find("inlineInputTPTGM");
            $A.util.addClass(myCmp, "cellColor");
        } else{
            var newVal = val/100;
            component.set("v.singleRec.TPT_GM", newVal);
            component.set("v.singleRec.Phoenix_TPT_GM__c", val);
            var myCmp = component.find("inlineInputTPTGM");
            $A.util.addClass(myCmp, "cellColor");
        }
    },
    removeRow : function(component, event, helper){
     // fire the DeleteRowEvt Lightning Event and pass the deleted Row Index to Event parameter/attribute
       component.getEvent("DeleteRowEvt").setParams({"recordIdToDelete" : component.get("v.singleRec.Id") }).fire();
    },
    inlineEditBrandWAC: function (component, event, helper) {
        component.set("v.BrandWACEditMode", true);
        setTimeout(function () {
            component.find("inputBrandWAC").focus();
        }, 100);
    },
    closeBrandWACBox: function (component, event, helper) {
        component.set("v.BrandWACEditMode", false);
    },
    onBrandWACChange: function (component, event, helper) {
        var val = event.getSource().get('v.value');
        var myCmp = component.find("inlineInputBrandWAC");
        $A.util.addClass(myCmp, "cellColor");
        $A.util.removeClass(myCmp, "slds-cell-edit slds-has-error");
    },
    
})