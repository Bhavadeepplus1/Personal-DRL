({
    doInit: function(component, event, helper){
    },
    
    removeRow : function(component, event, helper){
     // fire the DeleteRowEvt Lightning Event and pass the deleted Row Index to Event parameter/attribute
       component.getEvent("DeleteRowEvt").setParams({"indexVar" : component.get("v.rowIndex") }).fire();
    },
    
    inlineEditNewPHSPrice: function (component, event, helper) {
        component.set("v.NewPHSPriceEditMode", true);
        setTimeout(function () {
            component.find("inputNewPHSPrice").focus();
        }, 100);
    },
    inlineEditRemarks: function (component, event, helper) {
        component.set("v.RemarksEditMode", true);
        setTimeout(function () {
            component.find("inputRemarks").focus();
        }, 100);
    },
    closeNewPHSPriceBox: function (component, event, helper) {
        component.set("v.NewPHSPriceEditMode", false);
    },
    closeRemarksBox: function (component, event, helper) {
        component.set("v.RemarksEditMode", false);
    },
    onNewPHSPriceChange: function (component, event, helper) {
        var lineInstance = component.get("v.lineInstance");
        var val = event.getSource().get('v.value');
        var oldPHS = lineInstance.Phoenix_Old_PHS_Price__c;
        var units = lineInstance.Phoenix_Last_90_days_PHS_Units__c;
        var priceInApexus = lineInstance.Price_in_Apexus_Sub_Ceiling_Contract__c;
        if(val == null || val == undefined){
            var myCmp = component.find("inputNewPHSPriceId");
            $A.util.removeClass(myCmp, "cellColor");
            component.set("v.lineInstance.ChangeInPrice", '');
            component.set("v.lineInstance.Phoenix_Change_in_Price__c", '');
            component.set("v.lineInstance.Phoenix_Sales_Difference__c", '');
            component.set("v.lineInstance.Phoenix_Diff_in_Apexus_Sub_Ceiling_Price__c", '');
            component.set("v.lineInstance.Apexus_Sub_Ceiling_Price_Change_Required__c", '');  
        } else{
            var myCmp = component.find("inputNewPHSPriceId");
            $A.util.addClass(myCmp, "cellColor");
            var changeInPrice = (val - oldPHS)/oldPHS;
            var salesDifference = (val - oldPHS)*units;
            var priceChangeRequired = '';
            if(priceInApexus == null || priceInApexus == undefined){
                component.set("v.lineInstance.Phoenix_Diff_in_Apexus_Sub_Ceiling_Price__c", '');
                component.set("v.lineInstance.Apexus_Sub_Ceiling_Price_Change_Required__c", '');
            } else{
                var diffInApexus = priceInApexus - val;   
                component.set("v.lineInstance.Phoenix_Diff_in_Apexus_Sub_Ceiling_Price__c", diffInApexus);
                if(Math.sign(diffInApexus) == '-1'){
                    component.set("v.lineInstance.Apexus_Sub_Ceiling_Price_Change_Required__c", 'No');
                } else {
                    component.set("v.lineInstance.Apexus_Sub_Ceiling_Price_Change_Required__c", 'Yes');
                }
            }
            component.set("v.lineInstance.ChangeInPrice", changeInPrice);
            component.set("v.lineInstance.Phoenix_Change_in_Price__c", changeInPrice*100);
            component.set("v.lineInstance.Phoenix_Sales_Difference__c", salesDifference);
           // component.set("v.lineInstance.Phoenix_Diff_in_Apexus_Sub_Ceiling_Price__c", diffInApexus);
           // component.set("v.lineInstance.Apexus_Sub_Ceiling_Price_Change_Required__c", priceChangeRequired);
            component.set("v.lineInstance.Phoenix_PHS_Price_Change__c", component.get("v.recordId")); 
            var compEvent = component.getEvent("WACChangeEvent");
            compEvent.setParams({"isValueChanged" : true });
            compEvent.fire();
        }
    },
    onRemarksChange: function (component, event, helper) {
        var val = event.getSource().get('v.value');
        if(val == '' || val == null || val == undefined){
        } else{
            var myCmp = component.find("inputRemarksId");
            $A.util.addClass(myCmp, "cellColor"); 
            var compEvent = component.getEvent("WACChangeEvent");
            compEvent.setParams({"isValueChanged" : true });
            compEvent.fire();
        }
    },
    
    handleChange: function (component, event) {
        var instance = component.get("v.lineInstance");
        var newPrice = instance.Phoenix_New_PHS_Price__c;
        instance.Phoenix_PHS_Price_Change__c = component.get("v.recordId");
        var oldPrice = instance.Phoenix_Old_PHS_Price__c;
        var units = instance.Phoenix_Last_90_days_PHS_Units__c;
        var priceInApexus = instance.Price_in_Apexus_Sub_Ceiling_Contract__c;      
        if(newPrice){
            var changeInPrice = ((newPrice - oldPrice)/oldPrice)*100;
            var salesDifference = (newPrice - oldPrice)*units;
            var diffInApexus = priceInApexus - newPrice;
            instance.Phoenix_Change_in_Price__c = changeInPrice;
            instance.Phoenix_Sales_Difference__c = salesDifference;
            instance.Phoenix_Diff_in_Apexus_Sub_Ceiling_Price__c = diffInApexus;
            if(Math.sign(diffInApexus) == '-1'){
                instance.Apexus_Sub_Ceiling_Price_Change_Required__c = 'No';
            } else {
                instance.Apexus_Sub_Ceiling_Price_Change_Required__c = 'Yes';
            } 
        } else{
            instance.Phoenix_Change_in_Price__c = '';
            instance.Phoenix_Sales_Difference__c = '';
            instance.Phoenix_Diff_in_Apexus_Sub_Ceiling_Price__c = '';
            instance.Apexus_Sub_Ceiling_Price_Change_Required__c = '';
        }
        component.set("v.lineInstance", instance);
    },
    editMode: function(component, event, helper){
        component.set("v.enableEdit", false);
    }
})