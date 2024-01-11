({
    doInit: function(component, event, helper) {
       console.log('isContractsApprovePerson'+component.get("v.isContractsApprovePerson"));
       console.log('BidAprrovalStatus'+component.get("v.BidAprrovalStatus"));
        
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
         var lineItem= component.get("v.singleRec");
       console.log('lineItem'+lineItem.Phoenix_SCM_Approval_Y_N__c);
           console.log('lineItem--- Phoenix_SCM_Rejection_Reason1__c'+lineItem.Phoenix_SCM_Rejection_Reason1__c);
           var approvalStatus=component.get("v.BidAprrovalStatus");
          if(approvalStatus=='Supply Chain'){
         if((lineItem.Phoenix_SCM_Rejection_Reason1__c==null ||lineItem.Phoenix_SCM_Rejection_Reason1__c=='None' || lineItem.Phoenix_SCM_Rejection_Reason1__c=='' || lineItem.Phoenix_SCM_Rejection_Reason1__c==undefined )&& lineItem.Phoenix_SCM_Approval_Y_N__c=='N- Not Approved'){
         console.log('Hi');
             var toastEvent = $A.get("e.force:showToast");
                                       toastEvent.setParams({
                                           "type":"error",
                                           "title": "Failed!",
                                           "message": "Please select the SCM Rejection Reason"
                                       });
                                       toastEvent.fire();   
        }
        if(lineItem.Phoenix_SCM_Approval_Y_N__c=='Y- Only Current Monthly Demand Approved' || lineItem.Phoenix_SCM_Approval_Y_N__c=='Y- Current + Inc Demand Approved'){
           component.set("v.showRejectionbutton",false); 
        }
        }
        
          
    },
     inlineEditReason: function(component,event,helper){  
        component.set("v.ReasonEditMode", true);
        setTimeout(function(){
            component.find("inputReasonId").focus();
        }, 100);
       component.set("v.showSaveCancelBtn",true);   
    },
    closeReasonBox :  function (component, event, helper) {
        component.set("v.ReasonEditMode", false);
          
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
    clickSCMRejection :  function (component, event, helper) {
        var lineItem= component.get("v.singleRec");
        var approvalStatus=component.get("v.BidAprrovalStatus");
          if(approvalStatus=='Supply Chain'){
        if(lineItem.Phoenix_SCM_Rejection_Reason1__c!=null && lineItem.Phoenix_SCM_Rejection_Reason1__c!='' && lineItem.Phoenix_SCM_Rejection_Reason1__c!='None'&& lineItem.Phoenix_SCM_Rejection_Reason1__c!=undefined &&( lineItem.Phoenix_SCM_Approval_Y_N__c=='Y- Only Current Monthly Demand Approved' || lineItem.Phoenix_SCM_Approval_Y_N__c=='Y- Current + Inc Demand Approved')){
          var toastEvent = $A.get("e.force:showToast");
                                       toastEvent.setParams({
                                           "type":"error",
                                           "title": "Failed!",
                                           "message": "SCM Rejection Reason is not required"
                                       });
                                       toastEvent.fire();   
        }
        console.log('lineItem'+lineItem.Phoenix_SCM_Approval_Y_N__c);
           console.log('lineItem--- Phoenix_SCM_Rejection_Reason1__c'+lineItem.Phoenix_SCM_Rejection_Reason1__c);
         if((lineItem.Phoenix_SCM_Rejection_Reason1__c==null || lineItem.Phoenix_SCM_Rejection_Reason1__c=='' || lineItem.Phoenix_SCM_Rejection_Reason1__c=='None'|| lineItem.Phoenix_SCM_Rejection_Reason1__c==undefined )&& lineItem.Phoenix_SCM_Approval_Y_N__c=='N- Not Approved'){
         console.log('Please select the SCM Rejection Reason');
             var toastEvent1 = $A.get("e.force:showToast");
                                       toastEvent1.setParams({
                                           "type":"error",
                                           "title": "Failed!",
                                           "message": "Please select the SCM Rejection Reason"
                                       });
                                       toastEvent1.fire();   
        }
          }
        
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