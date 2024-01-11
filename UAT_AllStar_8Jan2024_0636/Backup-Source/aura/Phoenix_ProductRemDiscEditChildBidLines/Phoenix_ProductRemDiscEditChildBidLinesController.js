({
    doInit: function(component, event, helper) {
       var status=component.get("v.singleRec.Phoenix_Approval_Status__c");
       var financeapprover=component.get("v.isFinanceApprovePerson");
       var Phoenixfinalstatus=component.get("v.singleRec.Phoenix_Final_Finance_Approval__c");
        console.log('status-----'+status);
         console.log('financeapprover-----'+financeapprover);
         console.log('Phoenixfinalstatus-----'+Phoenixfinalstatus);
        
        
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
    inlineEditMarketing: function(component,event,helper){  
        component.set("v.MarketingEditMode", true);
        setTimeout(function(){
            component.find("inputMarketingId").focus();
        }, 100);
       component.set("v.showSaveCancelBtn",true);   
    },
    inlineEditMarketingLead :function(component,event,helper){ 
      component.set("v.MarketingLeadEditMode", true);
        setTimeout(function(){
            component.find("inputMarketingleadId").focus();
        }, 100);
       component.set("v.showSaveCancelBtn",true);      
    },
    closeMarketingBox :  function (component, event, helper) {
        component.set("v.MarketingEditMode", false);
          
    },
      closeMarketingLeadBox :  function (component, event, helper) {
        component.set("v.MarketingLeadEditMode", false);
          
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
     closeNotesleadBox :  function (component, event, helper) {
        component.set("v.NotesLeadEditMode", false);
         
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
     inlineEditMass: function(component,event,helper){  
        component.set("v.MassEditMode", true);
        setTimeout(function(){
            component.find("inputMassId").focus();
        }, 100);
       component.set("v.showSaveCancelBtn",true);   
    },
    closeMassBox :  function (component, event, helper) {
        component.set("v.MassEditMode", false);
        
    },
     inlineEditDisc: function(component,event,helper){  
        component.set("v.DiscEditMode", true);
        setTimeout(function(){
            component.find("inputDiscId").focus();
        }, 100);
          component.set("v.showSaveCancelBtn",true);  
    },
    closeDiscBox :  function (component, event, helper) {
        component.set("v.DiscEditMode", false);
         
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