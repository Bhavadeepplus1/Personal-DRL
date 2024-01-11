({
	doInit : function(component, event, helper) {
        var singleRec = component.get("v.singleRec");
        console.log('Single Rec::: '+JSON.stringify(singleRec));
       
       console.log('LeadPicklistOpts::: '+component.get("v.LeadPicklistOpts"));
	},
    
    inlineEditSCMLeadTime : function(component,event,helper){   
        // show the name edit field popup 
        component.set("v.scmLeadTimeEditMode", true); 
        // after the 100 millisecond set focus to input field   
         //component.find("scmLeadTime").set("v.options" , component.get("v.LeadPicklistOpts"));
        setTimeout(function(){ 
            component.find("scmLeadTime").focus();
        }, 100);
         //component.set("v.showSaveCancelBtn",true); 
    },
    inlineEditAwrdQty : function(component,event,helper){   
        // show the name edit field popup 
        component.set("v.AwrdQtyEditMode", true); 
        // after the 100 millisecond set focus to input field   
         
        setTimeout(function(){ 
            component.find("AwardedQty").focus();
        }, 100);
         //component.set("v.showSaveCancelBtn",true); 
    },
     inlineEditNDCEffDate : function(component,event,helper){   
        // show the name edit field popup 
        component.set("v.NDCEffDateEditMode", true); 
        // after the 100 millisecond set focus to input field   
         
        setTimeout(function(){ 
            component.find("NDCEffDate").focus();
        }, 100);
         //component.set("v.showSaveCancelBtn",true); 
    },
    inlineEditSCMRemarks : function(component,event,helper){   
        // show the name edit field popup 
        component.set("v.scmRemarksEditMode", true); 
        // after the 100 millisecond set focus to input field   
        setTimeout(function(){ 
            component.find("scmRemarks").focus();
        }, 100);
         //component.set("v.showSaveCancelBtn",true); 
    },
    inlineEditSubmitterRemarks : function(component,event,helper){   
        // show the name edit field popup 
        component.set("v.SubmitterRemarksEditMode", true); 
        // after the 100 millisecond set focus to input field   
        setTimeout(function(){ 
            component.find("SubmitterRemarks").focus();
        }, 100);
         //component.set("v.showSaveCancelBtn",true); 
    },
    
    inlineEditFinanceRemarks : function(component,event,helper){   
        // show the name edit field popup 
        component.set("v.financeRemarksEditMode", true); 
        // after the 100 millisecond set focus to input field   
        setTimeout(function(){ 
            component.find("financeRemarks").focus();
        }, 100);
        // component.set("v.showSaveCancelBtn",true); 
    },
    
    inlineEditContractsRemarks : function(component,event,helper){   
        // show the name edit field popup 
        component.set("v.contractsRemarksEditMode", true); 
        // after the 100 millisecond set focus to input field   
        setTimeout(function(){ 
            component.find("contractsRemarks").focus();
        }, 100);
         //component.set("v.showSaveCancelBtn",true); 
    },
    
    inlineEditCustomerRemarks : function(component,event,helper){   
        // show the name edit field popup 
        component.set("v.customerRemarksEditMode", true); 
        // after the 100 millisecond set focus to input field   
        setTimeout(function(){ 
            component.find("customerRemarks").focus();
        }, 100);
         //component.set("v.showSaveCancelBtn",true); 
    },
    
    inlineEditVistexRemarks : function(component,event,helper){   
        // show the name edit field popup 
        component.set("v.vistexRemarksEditMode", true); 
        // after the 100 millisecond set focus to input field   
        setTimeout(function(){ 
            component.find("vistexRemarks").focus();
        }, 100);
         //component.set("v.showSaveCancelBtn",true); 
    },
    
    inlineEditSCM : function(component,event,helper){   
        // show the rating edit field popup 
        component.set("v.scmEditMode", true); 
        // after set ratingEditMode true, set picklist options to picklist field 
        //component.find("scmOpt").set("v.options" , component.get("v.SCMPicklistOpts"));
        // after the 100 millisecond set focus to input field   
        setTimeout(function(){ 
            component.find("scmOpt").focus();
        }, 100);
         //component.set("v.showSaveCancelBtn",true); 
    },
    
    inlineEditFinance : function(component,event,helper){   
        // show the rating edit field popup 
        component.set("v.financeEditMode", true); 
        // after set ratingEditMode true, set picklist options to picklist field 
       // component.find("financeOpt").set("v.options" , component.get("v.FinancePicklistOpts"));
        // after the 100 millisecond set focus to input field   
        setTimeout(function(){ 
            component.find("financeOpt").focus();
        }, 100);
         //component.set("v.showSaveCancelBtn",true); 
    },
    
    inlineEditContracts : function(component,event,helper){   
        // show the rating edit field popup 
        component.set("v.contractsEditMode", true); 
        // after set ratingEditMode true, set picklist options to picklist field 
       // component.find("contractsOpt").set("v.options" , component.get("v.ContractsPicklistOpts"));
        // after the 100 millisecond set focus to input field   
        setTimeout(function(){ 
            component.find("contractsOpt").focus();
        }, 100);
        // component.set("v.showSaveCancelBtn",true); 
    },
    
    inlineEditCustomer : function(component,event,helper){   
        // show the rating edit field popup 
        component.set("v.customerEditMode", true); 
        // after set ratingEditMode true, set picklist options to picklist field 
        //component.find("customerOpt").set("v.options" , component.get("v.CustomerPicklistOpts"));
        // after the 100 millisecond set focus to input field   
        setTimeout(function(){ 
            component.find("customerOpt").focus();
        }, 100);
        // component.set("v.showSaveCancelBtn",true); 
    },
    
    inlineEditVistex : function(component,event,helper){   
        // show the rating edit field popup 
        component.set("v.vistexEditMode", true); 
        // after set ratingEditMode true, set picklist options to picklist field 
        //component.find("vistexOpt").set("v.options" , component.get("v.VistexPicklistOpts"));
        // after the 100 millisecond set focus to input field   
        setTimeout(function(){ 
            component.find("vistexOpt").focus();
        }, 100);
         //component.set("v.showSaveCancelBtn",true); 
    },
    
     onNameChange : function(component,event,helper){ 
        // if edit field value changed and field not equal to blank,
        // then show save and cancel button by set attribute to true
         if(event.getSource().get("v.value")!=null && event.getSource().get("v.value")!='' ){ 
             if(event.getSource().get("v.value").trim()!= ''){
            component.set("v.showSaveCancelBtn",true);
             }
             
        }
         
        
    },
 
    onRatingChange : function(component,event,helper){ 
        // if picklist value change,
        // then show save and cancel button by set attribute to true
        component.set("v.AwrdQtyEditMode", false);
          component.set("v.NDCEffDateEditMode", false);
        component.set("v.showSaveCancelBtn",true);
    },     
    
    closeNameBox : function (component, event, helper) {
      // on focus out, close the input section by setting the 'nameEditMode' att. as false   
      
        component.set("v.scmRemarksEditMode", false); 
        component.set("v.financeRemarksEditMode", false); 
        component.set("v.contractsRemarksEditMode", false); 
        component.set("v.customerRemarksEditMode", false); 
        component.set("v.vistexRemarksEditMode", false); 
          component.set("v.AwrdQtyEditMode", false);
          component.set("v.NDCEffDateEditMode", false);
         component.set("v.SubmitterRemarksEditMode", false);
    }, 
    
    closeRatingBox : function (component, event, helper) {
       // on focus out, close the input section by setting the 'ratingEditMode' att. as false
        component.set("v.scmEditMode", false); 
        component.set("v.financeEditMode", false); 
        component.set("v.contractsEditMode", false); 
        component.set("v.customerEditMode", false); 
        component.set("v.vistexEditMode", false); 
          component.set("v.scmLeadTimeEditMode", false); 
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