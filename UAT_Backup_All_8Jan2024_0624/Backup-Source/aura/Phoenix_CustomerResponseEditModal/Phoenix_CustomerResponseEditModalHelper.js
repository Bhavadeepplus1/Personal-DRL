({
     getBidLastActivity : function(component,event,helper){
        var action = component.get("c.getLastBidActivity");
        console.log('bid id test'+component.get("v.recordId"))
         action.setParams
            ({
                bidId: component.get('v.bidRecordId'),
            });
        action.setCallback(this, function(response) 
                           {
                               if(response.getState()=="SUCCESS"){
                                   console.log('record created successfully')
                               }else{
                                   console.log('error in bid last activity')
                               }
                           });
                             $A.enqueueAction(action);
    },
    getBidId: function(component, event, helper) {
        //component.set('v.isSpinnerLoad',true);       
        var action = component.get("c.getBid");
        action.setParams
        ({
            crId: component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var bid = response.getReturnValue();
                component.set('v.bidRecordId',bid.Phoenix_Bid_No__c);
                component.set('v.bidCustomerId',bid.Phoenix_Customer__c);
                component.set('v.bidType',bid.Phoenix_Bid_No__r.Phoenix_Bid_Type__c);
                if( bid.Phoenix_Affected_Contract_s__c!=null && bid.Phoenix_Affected_Contract_s__c!=undefined){
                    var refContracts=bid.Phoenix_Affected_Contract_s__c;
                    component.set("v.selectedCntrcts",refContracts.split(','));
                }
                //console.log('bidId'+bidId);
                //component.set('v.isSpinnerLoad',false);
                helper.getLoginUserDetails(component,event, helper);
            }
        });
        $A.enqueueAction(action);
    },
    
    getLoginUserDetails: function(component, event, helper) {
        //component.set('v.isSpinnerLoad',true);       
        console.log('bidRecordId'+component.get("v.bidRecordId"));
        var action = component.get("c.getLoginUserDetails");
        action.setParams
        ({
            bidId: component.get("v.bidRecordId")
        });
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var isLoginUserAbleToPerform =  response.getReturnValue();
                component.set('v.isLoginUserAbleToPerform',isLoginUserAbleToPerform);
                isLoginUserAbleToPerform = component.get('v.isLoginUserAbleToPerform');
                console.log('isLoginUserAbleToPerform'+isLoginUserAbleToPerform);
                //if(isLoginUserAbleToPerform) {
                helper.getBidLineItems(component,event, helper);
                //}
                //component.set('v.isSpinnerLoad',false);
            }
        });
        $A.enqueueAction(action);
    },
    fetchContratcs : function(component,event,helper,bidCustomer,searchInput) {
        console.log('bidCustomer---'+bidCustomer);
        var action = component.get("c.getContracts");
        action.setParams
        ({
            customerID: bidCustomer,
            searchInput:searchInput
            
        }); 
        action.setCallback(this, function(response) 
                           {
                               if (response.getState() === "SUCCESS") {
                                   var responseList = response.getReturnValue();
                                   console.log('---responseList---'+responseList.length);
                                   //component.set("v.contratcsList",responseList);
                                   
                                   //below code is for remove seleceted while fetch contracts in table
                                   var sltcntcntrcs=component.get('v.selectedCntrcts');
                                   var finalContratcs = responseList.filter(comparer(sltcntcntrcs)); 
                                   function comparer(otherArray){
                                       return function(current){
                                           return otherArray.filter(function(other){                                               
                                               return other == current.Phoenix_Contract_Number__c 
                                           }).length == 0;
                                       }
                                   }
                                   
                                   for (var i = 0; i < finalContratcs.length; i++) {
                                       var row = finalContratcs[i];
                                       if(row.Phoenix_Customer__c){
                                           row.Phoenix_Customer__c=row.Phoenix_Customer__r.Name;                                           
                                       }                                      
                                   }
                                   component.set("v.contratcsList",finalContratcs);
                                   component.set("v.isSpinner", false);
                               }
                               
                               
                           });
        $A.enqueueAction(action);
    },
    getBidLineItems: function(component, event, helper) {
        //component.set('v.isSpinnerLoad',true);       
        var message = event.getParam("message");
        console.log('recordId'+component.get("v.recordId"));
        var action = component.get("c.isCustomerResponseSubmitted");
        action.setParams
        ({
            crId: component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var isCRAdded =  response.getReturnValue();
                if(isCRAdded) {
                    component.set("v.isBidLISubmitted",true);
                    if(component.get("v.isBidLISubmitted")) {
                        helper.getLoginUserDetailsForVU(component, event, helper);
                        
                    }
                    console.log('isFromEditButton::'+component.get('v.isFromEditButton'));
                }
                //component.set('v.isSpinnerLoad',false);
            }
        });
        $A.enqueueAction(action);
    },
    
    getLoginUserDetailsForVU: function(component, event, helper) {
        //component.set('v.isSpinnerLoad',true);       
        console.log('bidRecordId'+component.get("v.bidRecordId"));
        var action = component.get("c.getLoginUserDetailsVU");
        action.setParams
        ({
            bidId: component.get("v.bidRecordId")
        });
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var isLoginUserAbleToPerformVU =  response.getReturnValue();
                component.set('v.isLoginUserAbleToPerformVU',isLoginUserAbleToPerformVU);
                var isLoginUserDetailsForVU = component.get('v.isLoginUserAbleToPerformVU');
                var vistexStatus;
                if(component.find('vistexId')!=null){
                    vistexStatus  = component.find('vistexId').get('v.value');
                }
                console.log('isLoginUserDetailsForVU::'+isLoginUserDetailsForVU);
                if(vistexStatus != 'Updated' && isLoginUserDetailsForVU) {
                    component.set('v.isVistexPending',true);
                }
                console.log('vistexStatus on load::'+vistexStatus);
                //component.set('v.isSpinnerLoad',false);
            }
        });
        $A.enqueueAction(action);
    },
    
    updateBidLineItemsWithVistex: function(component, event, helper) {
        component.set('v.isSpinnerLoad',true);       
        var message = event.getParam("message");
        console.log('recordId'+component.get("v.recordId"));
        var action = component.get("c.updateBidLineItemsWithVistex");
        action.setParams
        ({
            crId: component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var response =  response.getReturnValue();
                component.set('v.isSpinnerLoad',false);
            }
        });
        $A.enqueueAction(action);
    },
})