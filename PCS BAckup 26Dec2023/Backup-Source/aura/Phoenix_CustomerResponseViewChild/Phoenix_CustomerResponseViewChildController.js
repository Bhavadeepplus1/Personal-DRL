({
    doInit: function(component, event, helper) {
        console.log('isCRAddedToBidLineItem',component.get('v.isCRAddedToBidLineItem'));
        
        helper.fetchPickListVal(component, 'Phoenix_Bid_Status__c', 'bidStatusPicklistOpts');
        helper.fetchSecondPickListVal(component, event, helper);
        helper.getCustomer(component, event, helper);
        if(component.get("v.templateType") == 'ROS'){
            helper.getChildLineItemRec(component, event, helper);
        }
        console.log('child do Init');
        helper.checkAwardedQuantityRecords(component, event, helper);
        console.log('ext--positions--'+component.get("v.singleRec.Phoenix_Customer_Decline_Reasons__c"));
        console.log('customer line-->'+JSON.stringify(component.get("v.singleRec")));
        if(component.get("v.singleRec.Phoenix_Award_Position__c")!=null){
            component.set("v.LineselectedPosistions",component.get("v.singleRec.Phoenix_Award_Position__c").split(','));
        }
    },
    
    doAction : function(component, event, helper) {
        console.log('IN doAction');
        var params = event.getParam('arguments');
        if (params) {
            var showErrorClassBS = params.showErrorClassBS;
            component.set("v.showErrorClassBS",showErrorClassBS);
            var showErrorClassCDR = params.showErrorClassCDR;
            component.set("v.showErrorClassCDR",showErrorClassCDR);
            var showErrorClassAP = params.showErrorClassAP;
            component.set("v.showErrorClassAP",showErrorClassAP);
            var showErrorClassAQ = params.showErrorClassAQ;
            component.set("v.showErrorClassAQ",showErrorClassAQ);
            var showErrorClassPED = params.showErrorClassPED;
            component.set("v.showErrorClassPED",showErrorClassPED);
            var showErrorClassSED = params.showErrorClassSED;
            component.set("v.showErrorClassSED",showErrorClassSED);
        }
    },
    closeAwardedQuantity : function(component, event, helper) {
        console.log("INSIDE PARENT COMPONENT openAwardedQuantity has changed");
        console.log("old value: " + event.getParam("oldValue"));
        console.log("current value: " + event.getParam("value"));
        if(component.get("v.openAwardedQuantity") != false)
            helper.checkAwardedQuantityRecords(component, event, helper);
    },
    openAwardedQuantity : function(component, event, helper){
        console.log('Opening awarded quantity  Id :: '+component.get("v.singleRec.Id"));
        console.log('Opening awarded quantity  id :: '+component.get("v.singleRec.id"));
        component.set("v.openAwardedQuantity",true);
    },
    
    editBS: function(component,event,helper){
        if(component.get('v.isCRAddedToBidLineItem') == false) {
            component.set("v.BSEditMode", true);
            component.find("inputBSId").set("v.options" , component.get("v.bidStatusPicklistOpts"));
            setTimeout(function(){
                component.find("inputBSId").focus();
            }, 100);
            component.set("v.showAwardedQuantityIcon",false);
            component.set("v.showProceedButton",false);
        }
        
    },
    closeBS: function (component, event, helper) {
        helper.closeBS(component, event, helper);
    },
    
    onBSChange : function(component,event,helper){ 
        var compEvent = component.getEvent("toHideProceedButton");
        compEvent.setParams({
            "enableProceedButton" : false
        });
        compEvent.fire();
    },  
    
    onCDChange : function(component,event,helper){ 
        var compEvent = component.getEvent("toHideProceedButton");
        compEvent.setParams({
            "enableProceedButton" : false
        });
        compEvent.fire();
    },  
    
    onAQFieldChange: function(component,event,helper){ 
        console.log('onAQFieldChange======'+component.get('v.singleRec.Phoenix_Awarded_Quantity__c'));
        var compEvent = component.getEvent("toHideProceedButton");
      /*  var action = component.get("c.totalAwardedQtyValue");
        action.setParams
        ({
            crLineItemId: component.get('v.singleRec.Id')
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state=='SUCCESS'){
                var responseWrapper=response.getReturnValue();
                if(responseWrapper != component.get('v.singleRec.Phoenix_Awarded_Quantity__c')){
                    console.log('responseWrapper?????'+responseWrapper);
                    console.log('aqq?????'+component.get('v.singleRec.Phoenix_Awarded_Quantity__c'));
                    component.set('v.isAwardedQuantityExist',false);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Error',
                        message: 'Please allocate Awarded Quantity to the Contracts.',
                        duration:' 5000',
                        key: 'info_alt',
                        type: 'error',
                        mode: 'pester'
                    });
                    toastEvent.fire();
                }
                else if(responseWrapper == component.get('v.singleRec.Phoenix_Awarded_Quantity__c')){
                    console.log('responseWrapper else?????'+responseWrapper);
                    console.log('aqq else?????'+component.get('v.singleRec.Phoenix_Awarded_Quantity__c'));
                      component.set('v.isAwardedQuantityExist',true);
                }
                console.log('totalAwardedQtyValue====='+responseWrapper);
            }
        });
        $A.enqueueAction(action);*/
        compEvent.setParams({
            "enableProceedButton" : false,
          //  "changedAwardedQty" : component.get('v.singleRec.Phoenix_Awarded_Quantity__c')
        });
        compEvent.fire();
        //var bidStatus = component.find('inputBSId').get('v.value');
        //if(bidStatus == 'Awarded' || bidStatus == 'Pending')
        //component.set("v.showSaveCancelBtn",true);
    },
    
    editCDR: function(component,event,helper){
        var isCRAddedToBidLineItem = component.get('v.isCRAddedToBidLineItem');
        var isLoginUserAbleToPerform = component.get('v.isLoginUserAbleToPerform');
        var showErrorClassCDR = component.get('v.showErrorClassCDR');
        if(!isCRAddedToBidLineItem && isLoginUserAbleToPerform) {
            component.set("v.CDREditMode", true);
            component.find("inputCDRId").set("v.options" , component.get("v.customerDecPicklistOpts"));
            setTimeout(function(){
                component.find("inputCDRId").focus();
            }, 100);}
    },
    closeCDR: function (component, event, helper) {
        component.set("v.CDREditMode", false);
        var cdStatus = component.find('inputCDRId').get('v.value');
        var labelClass = component.find("inputCDRId").get("v.labelClass");
        console.log('labelClass'+labelClass);
        var records = component.get('v.CRLineItemListAll');
        var bsStatus = records[labelClass-1].Phoenix_Bid_Status__c;
        if(cdStatus == '' && bsStatus != 'Awarded' && bsStatus != 'Pending' && 	bsStatus != 'In Process'){
            component.set("v.showErrorClassCDR",true);
        }else{
            component.set("v.showErrorClassCDR",false);
        }
    },
    
    editAQ: function(component,event,helper){  
        var isCRAddedToBidLineItem = component.get('v.isCRAddedToBidLineItem');
        var isLoginUserAbleToPerform = component.get('v.isLoginUserAbleToPerform');
        var showEditModeAQ = component.get('v.showEditModeAQ');
        if(!isCRAddedToBidLineItem && isLoginUserAbleToPerform) {
            component.set("v.AQEditMode", true);
            setTimeout(function(){
                component.find("inputAQId").focus();
            }, 100);}
    },
    closeAQ: function (component, event, helper) {
        component.set("v.AQEditMode", false);
        var fValue = event.getSource().get("v.value");
        var labelClass = component.find("inputAQId").get("v.labelClass");
        console.log('labelClass'+labelClass);
        var records = component.get('v.CRLineItemListAll');
        var bsStatus = records[labelClass-1].Phoenix_Bid_Status__c;
        if((fValue == null || fValue == '') && (bsStatus == 'Awarded' || bsStatus == 'Pending')){
            component.set("v.showErrorClassAQ",true);
        }else{
            component.set("v.showErrorClassAQ",false);
        }
    },
    
    editAP: function(component,event,helper){  
        var isCRAddedToBidLineItem = component.get('v.isCRAddedToBidLineItem');
        var isLoginUserAbleToPerform = component.get('v.isLoginUserAbleToPerform');
        var showErrorClassAP = component.get('v.showErrorClassAP');
        if(!isCRAddedToBidLineItem && isLoginUserAbleToPerform) {
            
            component.set("v.isPositionsModalOpen", true);
            component.set("v.APEditMode", true);
            /*setTimeout(function(){
                component.find("inputAPId").focus();
            }, 100);}*/
        }
    },
    closeAP: function (component, event, helper) {
        component.set("v.APEditMode", false);
        var fValue = event.getSource().get("v.value");
        console.log('fValue closeAP'+fValue);
        var labelClass = component.find("inputAPId").get("v.labelClass");
        console.log('labelClass'+labelClass);
        var records = component.get('v.CRLineItemListAll');
        var bsStatus = records[labelClass-1].Phoenix_Bid_Status__c;
        if((fValue == null || event.getSource().get("v.value") == '') && (bsStatus == 'Awarded' || bsStatus == 'Pending')){
            component.set("v.showErrorClassAP",true);
        }else{
            component.set("v.showErrorClassAP",false);
        }
    },
    
    editSED: function(component,event,helper){  
        var isCRAddedToBidLineItem = component.get('v.isCRAddedToBidLineItem');
        var isLoginUserAbleToPerform = component.get('v.isLoginUserAbleToPerform');
        var showErrorClassSED = component.get('v.showErrorClassSED');
        if(!isCRAddedToBidLineItem && isLoginUserAbleToPerform) {
            component.set("v.SEDEditMode", true);
            console.log('inputSEDId',component.find("inputSEDId"));
            setTimeout(function(){
                component.find("inputSEDId").focus();
            }, 100);
        }
        component.set("v.showAwardedQuantityIcon",false);
        component.set("v.showProceedButton",false);
    },
    closeSED: function (component, event, helper) {
        component.set("v.SEDEditMode", false);
        /*var fValue = event.getSource().get("v.value");
        console.log('fValue closeSED'+fValue);
        var labelClass = component.find("inputSEDId").get("v.labelClass");
        console.log('labelClass'+labelClass);
        var records = component.get('v.CRLineItemListAll');
        var bsStatus = records[labelClass-1].Phoenix_Bid_Status__c;
		if(fValue && (bsStatus != 'Awarded' || bsStatus != 'Pending')){
            //component.set("v.showErrorClassSED",false);
            //records[labelClass-1].Phoenix_Supply_Effective_Date__c = fValue;
            component.set('v.CRLineItemListAll',records);
        }else{
            component.set("v.showErrorClassSED",true);
        }*/
    },
    
    changeSEDDate: function(component,event,helper){ 
        component.set("v.SEDEditMode", false);
        var date = component.find("inputSEDId").get('v.value');
        console.warn("date is: ", date);
        var fValue = event.getSource().get("v.value");
        console.log('fValue changeSEDDate'+fValue);
        var labelClass = component.find("inputSEDId").get("v.labelClass");
        console.log('labelClass'+labelClass);
        var records = component.get('v.CRLineItemListAll');
        var bsStatus = records[labelClass-1].Phoenix_Bid_Status__c;
        if(fValue && (bsStatus != 'Awarded' || bsStatus != 'Pending')){
            component.set("v.showErrorClassSED",false);
        }else{
            component.set("v.showErrorClassSED",true);
        }
        component.set("v.showAwardedQuantityIcon",false);
        component.set("v.showProceedButton",false);
        var compEvent = component.getEvent("toHideProceedButton");
        compEvent.setParams({
            "enableProceedButton" : false
        });
        compEvent.fire();
        //component.set("v.PEDEditMode", false);
    },
  
    changePEDDate: function(component,event,helper){ 
        component.set("v.PEDEditMode", false);
        var fValue = event.getSource().get("v.value");
        console.log('fValue changePEDate'+fValue);
        var labelClass = component.find("inputPEDId").get("v.labelClass");
        console.log('labelClass'+labelClass);
        var records = component.get('v.CRLineItemListAll');
        var bsStatus = records[labelClass-1].Phoenix_Bid_Status__c;
        if(fValue && (bsStatus != 'Awarded' || bsStatus != 'Pending')){
            component.set("v.showErrorClassPED",false);
        }else{
            if(component.get("v.BidTypeVal")!='Volume Review Only'){	
                component.set("v.showErrorClassPED",true);	
            }
        }
        component.set("v.showAwardedQuantityIcon",false);
        component.set("v.showProceedButton",false);
        //component.set("v.SEDEditMode", false);
        var compEvent = component.getEvent("toHideProceedButton");
        compEvent.setParams({
            "enableProceedButton" : false
        });
        compEvent.fire();
    },
    
    editPED: function(component,event,helper){  
        var isCRAddedToBidLineItem = component.get('v.isCRAddedToBidLineItem');
        var isLoginUserAbleToPerform = component.get('v.isLoginUserAbleToPerform');
        var showErrorClassPED = component.get('v.showErrorClassPED');
        if(!isCRAddedToBidLineItem && isLoginUserAbleToPerform) {
            component.set("v.PEDEditMode", true);
            setTimeout(function(){
                component.find("inputPEDId").focus();
            }, 100);
        }
        component.set("v.showAwardedQuantityIcon",false);
        component.set("v.showProceedButton",false);
    },
    
    closePED: function (component, event, helper) {
        component.set("v.PEDEditMode", false);
        /*var fValue = event.getSource().get("v.value");
        console.log('fValue closePED'+fValue);
        var labelClass = component.find("inputPEDId").get("v.labelClass");
        console.log('labelClass'+labelClass);
        var records = component.get('v.CRLineItemListAll');
        var bsStatus = records[labelClass-1].Phoenix_Bid_Status__c;
		if(fValue && (bsStatus != 'Awarded' || bsStatus != 'Pending')){
            component.set("v.showErrorClassPED",false);
            //records[labelClass-1].Phoenix_Price_Effective_Date__c = fValue;
            //component.set('v.CRLineItemListAll',records);
        }else{
            component.set("v.showErrorClassPED",true);
        }*/
    },
    
    askToConfirmDelete : function(component, event, helper){
        var target = event.target;
        var selectedId = target.getAttribute("name");
        component.set("v.selectedId",selectedId);
        component.set("v.showConfirmDelete",true);
    },
    
    closeConfirmDelete : function(component, event, helper){
        component.set("v.showConfirmDelete",false);
    },
    
    deleteLineItem : function(component, event, helper){
        /*var target = event.target;
        var rowIndex = target.getAttribute("name");
        console.log('rowIndex in deleteLineItem--->'+rowIndex);
        var sNo = target.getAttribute("id");
        console.log('sNo--->'+sNo);*/
        var lineItemId = component.get("v.selectedId");
        var action = component.get("c.deleteLineItems");
        action.setParams({
            'LineItemId' : lineItemId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('state--->'+state);
            if(state=='SUCCESS'){
                component.set("v.showConfirmDelete",false);
                var event = component.getEvent("lightningEvent");
                event.setParam("message", "the message to send" );
                event.fire();
            }
        });
        $A.enqueueAction(action);
        
    },
    /*Product Positions logic Start*/
    inlineEditPositions : function(component,event,helper){ 
        
        var isCRAddedToBidLineItem = component.get('v.isCRAddedToBidLineItem');
        var isLoginUserAbleToPerform = component.get('v.isLoginUserAbleToPerform');
        var showErrorClassAP = component.get('v.showErrorClassAP');
        if(!isCRAddedToBidLineItem && isLoginUserAbleToPerform) {
            component.set("v.isPositionsModalOpen", true);            
            var LineItemtable = component.get("v.tableRef");             
            $A.util.removeClass(LineItemtable, "maintable");        
            /* component.set("v.PositionsEditMode", true);
        setTimeout(function(){
            component.find("positions").focus();
        }, 100);*/  
            component.set('v.LinepositionColumns', [
                {label: 'Name', fieldName: 'Name', type: 'text'},
                {label: 'Customer', fieldName: 'Phoenix_Customer__c', type: 'text'},
                {label: 'Group Name', fieldName: 'Phoenix_Group_Name__c', type: 'text'},
                {label: 'Position Comments', fieldName: 'Phoenix_Position_Comments__c', type: 'Text'}
            ]); 
            // var searchInput=component.find("cntInput").get("v.value");
            // console.log('--searchInput--'+searchInput);
            var bidCustomer=component.get("v.customerId");
            console.log('--bidCustomer--'+bidCustomer);
            if(bidCustomer!=null && bidCustomer!=undefined){
                helper.getPositions(component, event,helper,bidCustomer);
            } else{
                component.set("v.LinepositionsList",null);
            } 
            component.set("v.showAwardedQuantityIcon",false);
            component.set("v.showProceedButton",false);
        }
    },
    inlineEditPositionsMck : function(component,event,helper){ 
        
        var isCRAddedToBidLineItem = component.get('v.isCRAddedToBidLineItem');
        var isLoginUserAbleToPerform = component.get('v.isLoginUserAbleToPerform');
        var showErrorClassAP = component.get('v.showErrorClassAP');
        if(!isCRAddedToBidLineItem && isLoginUserAbleToPerform) {
            component.set("v.isPositionsModalOpenMck", true);            
            var LineItemtable = component.get("v.tableRef");             
            $A.util.removeClass(LineItemtable, "maintable");        
            /* component.set("v.PositionsEditMode", true);
        setTimeout(function(){
            component.find("positions").focus();
        }, 100);*/  
            component.set('v.LinepositionColumnsMck', [
                {label: 'Name', fieldName: 'Name', type: 'text'},
                {label: 'Customer', fieldName: 'Phoenix_Customer__c', type: 'text'},
                {label: 'Group Name', fieldName: 'Phoenix_Group_Name__c', type: 'text'},
                {label: 'Position Comments', fieldName: 'Phoenix_Position_Comments__c', type: 'Text'}
            ]); 
            // var searchInput=component.find("cntInput").get("v.value");
            // console.log('--searchInput--'+searchInput);
            var bidCustomer=component.get("v.customerId");
            console.log('--bidCustomer--'+bidCustomer);
            if(bidCustomer!=null && bidCustomer!=undefined){
                helper.getPositionsMck(component, event,helper,bidCustomer);
            } else{
                component.set("v.LinepositionsListMck",null);
            } 
        }
    },
    closePositionsPopup : function(component,event,helper){
        component.set("v.isPositionsModalOpen", false);
        var LineItemtable = component.get("v.tableRef");
        $A.util.addClass(LineItemtable, "maintable");
    },
    closePositionsPopupMck : function(component,event,helper){
        component.set("v.isPositionsModalOpenMck", false);
        var LineItemtable = component.get("v.tableRef");
        $A.util.addClass(LineItemtable, "maintable");
    },
    savePositions :function(component,event,helper){
        var selectPos=component.find('PoslineLevelTable').getSelectedRows(); 
        var selectedPositions=[];//=component.get("v.LineselectedPosistions;
        for(var i=0;i<selectPos.length;i++){
            selectedPositions.push(selectPos[i].Name);
        }    
        component.set("v.LineselectedPosistions",selectedPositions);
        console.log('selectedPositions--'+selectedPositions);
        component.set("v.singleRec.Phoenix_Award_Position__c",selectedPositions.toString());
        //helper.getCalculations(component,event,helper, 'No Change', '',false,false,false);
        component.set("v.isPositionsModalOpen", false);
        var LineItemtable = component.get("v.tableRef");
        $A.util.addClass(LineItemtable, "maintable");
    },
    savePositionsMck :function(component,event,helper){
        var selectPos=component.find('PoslineLevelTableMck').getSelectedRows(); 
        var selectedPositions=[];//=component.get("v.LineselectedPosistions;
        for(var i=0;i<selectPos.length;i++){
            selectedPositions.push(selectPos[i].Name);
        }    
        component.set("v.LineselectedPosistionsMck",selectedPositions);
        console.log('selectedPositions--'+selectedPositions);
        component.set("v.singleRec.Phoenix_Mck_Proposed_Position__c",selectedPositions.toString());
        //helper.getCalculations(component,event,helper, 'No Change', '',false,false,false);
        component.set("v.isPositionsModalOpenMck", false);
        var LineItemtable = component.get("v.tableRef");
        $A.util.addClass(LineItemtable, "maintable");
    },
    
    /*Product Positions logic End*/
    
})