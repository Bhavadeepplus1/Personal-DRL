({
    doInit: function(component, event, helper){
      $A.util.removeClass(component.find('resultsDiv'),'slds-is-open');
        var instance = component.get("v.lineInstance");
        instance.Phoenix_PHS_Price_Change__c = component.get("v.recordId");
        var productList = component.get("v.productList");
        for(var i=0; i<productList.length; i++){
            if(productList[i].Id == instance.Phoenix_Product_Name__c){
                instance.ProductName__c = productList[i].Name;
            }
        }
        var selectedRecord = {};
        if(instance.Phoenix_Product_Name__c == ''){
            selectedRecord = '';
        } else{
            selectedRecord.Id = instance.Phoenix_Product_Name__c;
            selectedRecord.Name = instance.ProductName__c;   
        }
        component.set("v.recordsList", productList);
        component.set('v.selectedRecord', selectedRecord);
        component.set("v.lineInstance", instance);
    },
    inlineEditProvisionalPrice: function (component, event, helper) {
        component.set("v.ProvisionalPriceEditMode", true);
        setTimeout(function () {
            component.find("inputProvisionalPrice").focus();
        }, 100);
    },
    inlineEditStartDate: function (component, event, helper) {
        component.set("v.StartDateEditMode", true);
        setTimeout(function () {
            component.find("inputStartDate").focus();
        }, 100);
    },
    inlineEditEndDate: function (component, event, helper) {
        component.set("v.EndDateEditMode", true);
        setTimeout(function () {
            component.find("inputEndDate").focus();
        }, 100);
    },
    inlineEditRemarks: function (component, event, helper) {
        component.set("v.RemarksEditMode", true);
        setTimeout(function () {
            component.find("inputRemarks").focus();
        }, 100);
    },
    inlineEditFinance : function(component,event,helper){ 
        component.set("v.financeEditMode", true); 
        setTimeout(function(){ 
            component.find("financeOpt").focus();
        }, 100);
    },
    closeProvisionalPriceBox: function (component, event, helper) {
        component.set("v.ProvisionalPriceEditMode", false);
    },
    closeStartDateBox: function (component, event, helper) {
        component.set("v.StartDateEditMode", false);
    },
    closeEndDateBox: function (component, event, helper) {
        component.set("v.EndDateEditMode", false);
    },
    closeRemarksBox: function (component, event, helper) {
        component.set("v.RemarksEditMode", false);
    },
    closeFinanceApprovalBox: function (component, event, helper) {
        component.set("v.financeEditMode", false);
    },
    onProvisionalPriceChange: function (component, event, helper) {
        var val = event.getSource().get('v.value');
        if(val == '' || val == null || val == undefined){
        } else{
            var compEvent = component.getEvent("WACChangeEvent");
            compEvent.setParams({"isValueChanged" : true });
            compEvent.fire();
        }
    },
    onStartDateChange: function (component, event, helper) {
        var val = component.get("v.lineInstance").Phoenix_Price_Start_Date__c;
        component.set("v.StartDateEditMode", false);
        if(val == '' || val == null || val == undefined){
        } else{
            var compEvent = component.getEvent("WACChangeEvent");
            compEvent.setParams({"isValueChanged" : true });
            compEvent.fire();
        }
    },
    onEndDateChange: function (component, event, helper) {
        var val = component.get("v.lineInstance").Phoenix_Price_End_Date__c;
        component.set("v.EndDateEditMode", false);
        if(val == '' || val == null || val == undefined){
        } else{
            var compEvent = component.getEvent("WACChangeEvent");
            compEvent.setParams({"isValueChanged" : true });
            compEvent.fire();
        }
    },
    onRemarksChange: function (component, event, helper) {
        var val = event.getSource().get('v.value');
        if(val == '' || val == null || val == undefined){
        } else{
            var compEvent = component.getEvent("WACChangeEvent");
            compEvent.setParams({"isValueChanged" : true });
            compEvent.fire();
        }
    },
    onFinanceApprovalChange: function(component,event,helper){ 
        // if picklist value change,
        // then show save and cancel button by set attribute to true
        component.set("v.showSaveCancelBtn",true);
    },  
    /*editMode: function(component, event, helper){
        component.set("v.enableEdit", false);
    },*/
    removeRow : function(component, event, helper){
     // fire the DeleteRowEvt Lightning Event and pass the deleted Row Index to Event parameter/attribute
       component.getEvent("DeleteRowEvt").setParams({"indexVar" : component.get("v.rowIndex") }).fire();
    }, 
    
    handleChange: function(component, event, helper) {
        var lookupId = event.getParam("value")[0];
        if(lookupId != undefined) {
            var action = component.get("c.getProductInfo");
            action.setParams({
                "productId": component.get("v.selectedRecord").Id
            });
            action.setCallback(this, function(response) 
                               {
                                   if(response.getState()=="SUCCESS"){
                                       var resp = response.getReturnValue();
                                       var instance = component.get("v.lineInstance");
                                       if(resp[0].Phoenix_NDC_11__c){
                                           instance.Phoenix_PHS_Price_Change__c = component.get("v.recordId");
                                           instance.Phoenix_NDC_11__c = resp[0].Phoenix_NDC_11__c;
                                           instance.Phoenix_Material_Code__c = resp[0].ProductCode;
                                       }
                                       component.set("v.lineInstance", instance);
                                   }
                               });
            $A.enqueueAction(action);   
        } else {
            var instance = component.get("v.lineInstance");
            instance.Phoenix_NDC_11__c = '';
            instance.Phoenix_Material_Code__c = '';
            component.set("v.lineInstance", instance);
        }
    },
    // When a keyword is entered in search box
    searchRecords : function( component, event, helper ) {
        var recordsList = component.get('v.productList');
        var recordsListDuplicates = component.get('v.productListDuplicates');
        if( !$A.util.isEmpty(component.get('v.searchString')) ) {
            var searchKey = component.get('v.searchString');
            var allData = component.get("v.productList");
            var filtereddata = allData.filter(word => (!searchKey) || word.Name.toUpperCase().indexOf(searchKey.toUpperCase()) > -1);
            component.set("v.recordsList", filtereddata);
            if(filtereddata.length == 0){
                component.set('v.message', "No Records Found for '" + searchKey + "'");
            }
        } else {
            $A.util.removeClass(component.find('resultsDiv'),'slds-is-open');
            component.set("v.recordsList", recordsListDuplicates);
            component.set('v.message', '');
        }
    },
    
    // When an item is selected
    selectItem : function( component, event, helper ) {
        if(!$A.util.isEmpty(event.currentTarget.id)) {
            var recordsList = component.get('v.productList');
            var instance = component.get("v.lineInstance");
            var index = recordsList.findIndex(x => x.Id === event.currentTarget.id)
            if(index != -1) {
                var selectedRecord = recordsList[index];
            }
            component.set('v.selectedRecord',selectedRecord);
            component.set('v.value',selectedRecord.Id);
            instance.Phoenix_Product_Name__c = selectedRecord.Id;
            instance.ProductName__c = selectedRecord.Name;
            instance.Phoenix_PHS_Price_Change__c = component.get("v.recordId");
            component.set("v.lineInstance", instance);
            $A.util.removeClass(component.find('resultsDiv'),'slds-is-open');
            var compEvent = component.getEvent("WACChangeEvent");
            compEvent.setParams({"isValueChanged" : true });
            compEvent.fire();
            helper.getProductInfo(component, event);
        }
    },
    
    showRecords : function( component, event, helper ) {
        if(!$A.util.isEmpty(component.get('v.productList')) && !$A.util.isEmpty(component.get('v.searchString'))) {
            $A.util.addClass(component.find('resultsDiv'),'slds-is-open');
        }
        $A.util.addClass(component.find('resultsDiv'),'slds-is-open');
    },
    
    // To remove the selected item.
    removeItem : function( component, event, helper ){
        component.set('v.selectedRecord','');
        component.set('v.value','');
        component.set('v.searchString','');
        var compEvent = component.getEvent("WACChangeEvent");
        compEvent.setParams({"isValueChanged" : true });
        compEvent.fire();
        setTimeout( function() {
            component.find( 'inputLookup' ).focus();
        }, 250);
    },
    
    // To close the dropdown if clicked outside the dropdown.
    blurEvent : function( component, event, helper ){
        $A.util.removeClass(component.find('resultsDiv'),'slds-is-open');
    },
})