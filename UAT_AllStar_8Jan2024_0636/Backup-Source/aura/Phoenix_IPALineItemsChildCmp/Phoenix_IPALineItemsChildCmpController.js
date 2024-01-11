({
    doInit: function(component, event, helper) {
        console.log('logged in username'+component.get("v.loggedInUserName"));
        console.log('product director'+component.get("v.singleRec.Phoenix_Product_Director1__c"));
         console.log('bid approval status'+component.get("v.BidAprrovalStatus"));
         console.log('conditional approval floor price'+component.get("v.singleRec.Phoenix_Conditional_Approval_Req_for_Flo__c"));
         console.log('marketing final approval'+component.get("v.singleRec.Phoenix_Marketing_Final_Approval__c"));
        
        
       //console.log('condition State'+(and(and(component.get("v.loggedInUserName")==component.get("v.singleRec.Phoenix_Product_Director1__c"),component.get("v.BidAprrovalStatus")=='Marketing'),and(component.get("v.singleRec.Phoenix_Conditional_Approval_Req_for_Flo__c")==true,component.get("v.singleRec.Phoenix_Marketing_Final_Approval__c")==false))));
    },
     inlineEditPIP: function(component,event,helper){  
        component.set("v.PIPEditMode", true);
        setTimeout(function(){
            component.find("inputPIPId").focus();
        }, 100);
       component.set("v.showSaveCancelBtn",true);   
    },
    closePIPBox :  function (component, event, helper) {
        component.set("v.PIPEditMode", false);
          
    },
     inlineEditIDN: function(component,event,helper){  
        component.set("v.IDNEditMode", true);
        setTimeout(function(){
            component.find("inputIDNId").focus();
        }, 100);
          component.set("v.showSaveCancelBtn",true);  
    },
    closeIDNBox :  function (component, event, helper) {
        component.set("v.IDNEditMode", false);
         
    },
    inlineEditMarketing: function(component,event,helper){  
        component.set("v.MarketingEditMode", true);
        setTimeout(function(){
            component.find("inputMarketingId").focus();
        }, 100);
       component.set("v.showSaveCancelBtn",true);   
    },
    closeMarketingBox :  function (component, event, helper) {
        component.set("v.MarketingEditMode", false);
          
    },
     inlineEditNotes: function(component,event,helper){  
        component.set("v.NotesEditMode", true);
        setTimeout(function(){
            component.find("inputNotesId").focus();
        }, 100);
          component.set("v.showSaveCancelBtn",true);  
    },
    closeNotesBox :  function (component, event, helper) {
        component.set("v.NotesEditMode", false);
         
    },
     inlineEditContracts: function(component,event,helper){  
        component.set("v.ContractsEditMode", true);
        setTimeout(function(){
            component.find("inputContractId").focus();
        }, 100);
       component.set("v.showSaveCancelBtn",true);   
    },
    closeContractBox :  function (component, event, helper) {
        component.set("v.ContractsEditMode", false);
          
    },
     inlineEditComments: function(component,event,helper){  
        component.set("v.CommentsEditMode", true);
        setTimeout(function(){
            component.find("inputCommentsId").focus();
        }, 100);
          component.set("v.showSaveCancelBtn",true);  
    },
    closeCommentsBox :  function (component, event, helper) {
        component.set("v.CommentsEditMode", false);
         
    },
     
     inlineEditFinance: function(component,event,helper){  
        component.set("v.FinanceEditMode", true);
        setTimeout(function(){
            component.find("inputFinanceId").focus();
        }, 100);
       component.set("v.showSaveCancelBtn",true);   
    },
    closeFinanceBox :  function (component, event, helper) {
        component.set("v.FinanceEditMode", false);
          
    },
     inlineEditFinanceNotes: function(component,event,helper){  
        component.set("v.FinanceNotesEditMode", true);
        setTimeout(function(){
            component.find("inputFinanceNotesId").focus();
        }, 100);
          component.set("v.showSaveCancelBtn",true);  
    },
    closeFinanceNotesBox :  function (component, event, helper) {
        component.set("v.FinanceNotesEditMode", false);
         
    }, 
      inlineEditVistex: function(component,event,helper){  
        component.set("v.VistexEditMode", true);
        setTimeout(function(){
            component.find("inputVistexId").focus();
        }, 100);
       component.set("v.showSaveCancelBtn",true);   
    },
    closeVistexBox :  function (component, event, helper) {
        component.set("v.VistexEditMode", false);
          
    },
     inlineEditVisComments: function(component,event,helper){  
        component.set("v.VisCommentsEditMode", true);
        setTimeout(function(){
            component.find("inputVisCommentsId").focus();
        }, 100);
          component.set("v.showSaveCancelBtn",true);  
    },
    closeVisCommentsBox :  function (component, event, helper) {
        component.set("v.VisCommentsEditMode", false);
         
    },
    getCalculate: function (component, event, helper) {
     component.set("v.showPriceMsg",false);
     var lineItem=component.get("v.singleRec");
      
        if(lineItem.Phoenix_Proposed_IPA_Price__c < lineItem.Phoenix_IPA_Floor_Price1__c && lineItem.Phoenix_Proposed_IPA_Price__c!=null && lineItem.Phoenix_Proposed_IPA_Price__c!=undefined ){
          component.set("v.showPriceMsg",true);  
        }
    },
    getCalIDN:  function (component, event, helper) {
    component.set("v.showPriceMsg",false);
    },
	deleteLineItem : function(component, event, helper){
        var target = event.target;
        var rowIndex = target.getAttribute("name");
        console.log('rowIndex--->'+rowIndex);
        var action = component.get("c.deleteLineItems");
        action.setParams({
            'LineItemId' : rowIndex
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('state--->'+state);
        });
        $A.enqueueAction(action);
        var event = component.getEvent("lightningEvent");
        event.setParam("message", "the message to send" );
        event.fire();
    }
})