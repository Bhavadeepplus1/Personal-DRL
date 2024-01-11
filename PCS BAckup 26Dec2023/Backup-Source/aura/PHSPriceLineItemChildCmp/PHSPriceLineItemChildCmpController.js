({
	doInit : function(component, event, helper) {
        var singleRec = component.get("v.singleRec");
        console.log('Single Rec::: '+JSON.stringify(singleRec));
       
     
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
    inlineEditNewPHSPrice : function(component,event,helper){   
        // show the name edit field popup 
        component.set("v.NewPHSPricePEditMode", true); 
        // after the 100 millisecond set focus to input field   
         
        setTimeout(function(){ 
            component.find("NewPHSPrice").focus();
        }, 100);
         //component.set("v.showSaveCancelBtn",true); 
    },
     inlineEditProviPHSPrice : function(component,event,helper){   
        // show the name edit field popup 
        component.set("v.ProviPHSPriceEditMode", true); 
        // after the 100 millisecond set focus to input field   
         
        setTimeout(function(){ 
            component.find("ProviPHSPrice").focus();
        }, 100);
         //component.set("v.showSaveCancelBtn",true); 
    },
     inlineEditRemarks : function(component,event,helper){   
        // show the name edit field popup 
        component.set("v.RemarksEditMode", true); 
        // after the 100 millisecond set focus to input field   
         
        setTimeout(function(){ 
            component.find("Remarks").focus();
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
   
    
    inlineEditFinanceRemarks : function(component,event,helper){   
        // show the name edit field popup 
        component.set("v.financeRemarksEditMode", true); 
        // after the 100 millisecond set focus to input field   
        setTimeout(function(){ 
            component.find("financeRemarks").focus();
        }, 100);
        // component.set("v.showSaveCancelBtn",true); 
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
      
      
        component.set("v.financeRemarksEditMode", false); 
         component.set("v.vistexRemarksEditMode", false); 
          component.set("v.AwrdQtyEditMode", false);
          component.set("v.NDCEffDateEditMode", false);
        component.set("v.NewPHSPricePEditMode", false);
         component.set("v.ProviPHSPriceEditMode", false);
         component.set("v.RemarksEditMode", false);
    }, 
    
    closeRatingBox : function (component, event, helper) {
       // on focus out, close the input section by setting the 'ratingEditMode' att. as false
    
        component.set("v.financeEditMode", false); 
      component.set("v.vistexEditMode", false); 
        
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