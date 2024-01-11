({
    doInit: function(component, event, helper) {
       
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

    
    //added by vandana
    inlineEditVistexUpdate: function(component,event,helper){  
        component.set("v.VistexUpdateEditMode", true);
        setTimeout(function(){
            component.find("inputVistexUpdateId").focus();
        }, 100);
        component.set("v.showSaveCancelBtn",true);   
    },
    
    inlineEditVisUpdateComments: function(component,event,helper){  
        component.set("v.VisUpdateCommentsEditMode", true);
        setTimeout(function(){
            component.find("inputVisUpdateCommentsId").focus();
        }, 100);
        component.set("v.showSaveCancelBtn",true);  
    },
    
    closeVistexUpdateBox :  function (component, event, helper) {
        component.set("v.VistexUpdateEditMode", false);
        
    },
    
    closeVisUpdateCommentsBox :  function (component, event, helper) {
        component.set("v.VisUpdateCommentsEditMode", false);
        
    },
    
    // added by vandana end.
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
    
    inlineEditCustomerService: function(component,event,helper){  
        component.set("v.CustomerServiceEditMode ", true);
        setTimeout(function(){
            component.find("inputCustomerServiceId").focus();
        }, 100);
       component.set("v.showSaveCancelBtn",true);   
    },
    
     inlineEditCustomerSerComments: function(component,event,helper){  
        component.set("v.CustomerSerCommentsEditMode ", true);
        setTimeout(function(){
            component.find("inputCustomerSerCommentsId").focus();
        }, 100);
       component.set("v.showSaveCancelBtn",true);   
    },
    closeCustomerServiceBox :  function (component, event, helper) {
        component.set("v.CustomerServiceEditMode", false);
         
    },
    closeCustomerSerCommentsBox :  function (component, event, helper) {
        component.set("v.CustomerSerCommentsEditMode", false);
         
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
    },
    onCISUChange: function(component, event, helper){
        component.set("v.PEDEditMode",false);
    },
    editPED: function(component,event,helper){  
            component.set("v.PEDEditMode", true);
            setTimeout(function(){
                component.find("inputPEDId").focus();
            }, 100);
        component.set("v.showSaveCancelBtn",true);   
    },
  
})