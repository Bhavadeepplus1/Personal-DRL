({
     doInit : function(component, event, helper) {
            component.set("v.showSpinner",true);
        var bidId = component.get("v.recordId");
        var getBidInfoAction = component.get("c.getBidInfo");
        getBidInfoAction.setParams({ "bidId": bidId });
        getBidInfoAction.setCallback(this, function (response) {
            var actState = response.getState();
            if (actState === 'SUCCESS') {
                component.set("v.isError",false);
                var responseWarapper=response.getReturnValue();
                component.set("v.wrap",responseWarapper);
                var wrap = component.get("v.wrap");
                console.log('wrap--->'+JSON.stringify(wrap.bid));
                console.log('BidType--->'+wrap.bid.Phoenix_Bid_Type__c);
                component.set("v.bidType",wrap.bid.Phoenix_Bid_Type__c);
                if(wrap.bid.Phoenix_Approval_Status__c =='Customer\'\s Update')
                component.set("v.ApprovalStatus",'Customer Update');
                else  component.set("v.ApprovalStatus",wrap.bid.Phoenix_Approval_Status__c);
                var bidType =component.get("v.bidType");
                var ApprovalStatus = component.get("v.ApprovalStatus");
                console.log('ApprovalStatus'+ApprovalStatus);
                var count =  component.get("v.wrap.bidItemCount");
                console.log('count--->'+count);
                 if(bidType!='Price Change' && bidType!='Product Addition' && bidType!='RFP Bids' && bidType!='Volume Review Only' && bidType!='Sales Out Rebate' && bidType!='Customer Rebate Change' && bidType!='Good Dated OTB' && bidType!='One Time Buy Good Dated Shelf Life for New Product Launch' && bidType!='Short Dated OTB'  && bidType!='New Product Launch' && bidType!='New Customer'&& bidType!='Initial Order Discount for WAC Customers (No-Contract Price Offering)' && bidType!='SRx IPA Price Change'  && bidType!='SRx IPA Product Addition'  && bidType!='NEW Individual Pricing Agreement (IPA)'){
                     component.set("v.showNextScreen",false);
                    component.set("v.ScreenClose",true);
        }
                  console.log('BidType--->'+bidType);
               if( ApprovalStatus == 'On Hold' ){
                    component.set("v.isError",true);
                    component.set("v.errorMessage",'You can not Recall this bid as it is on hold.');
                    
                }
                else if(ApprovalStatus == 'Draft' || ApprovalStatus == 'Closed-Draft'){
                     component.set("v.isError",true);
                    component.set("v.errorMessage",'You can not Recall bid in draft and closed-draft stage.');
                }
                 else if(ApprovalStatus == 'Closed'){
                    console.log('entered here');
                     component.set("v.isError",true);
                    component.set("v.errorMessage",'You can not Recall bid in Closed stage.');
                }
                 else if(count<=0){
                      component.set("v.isError",true);
                      component.set("v.errorMessage",'You can not Recall this bid.');

                    
                }
                         else if(bidType =='Customer Rebate Change' ||bidType =='Good Dated OTB' ||bidType =='One Time Buy Good Dated Shelf Life for New Product Launch' ||bidType =='New Customer'||bidType =='New Product Launch'||bidType =='Price Change'||bidType =='Product Addition'||bidType =='RFP Bids'||bidType =='Sales Out Rebate'||bidType =='Short Dated OTB'||bidType =='Volume Review Only'||bidType =='Initial Order Discount for WAC Customers (No-Contract Price Offering)'||bidType =='Platform PO OTB'){
                             if(ApprovalStatus =='Vistex Update' || ApprovalStatus =='Closed'||ApprovalStatus =='Customer Service Update' || ApprovalStatus =='Customer Rejected' || ApprovalStatus =='Customer Service Rejected'){
                             component.set("v.isError",true);
                             component.set("v.errorMessage",'You can not Recall the bid after Customer\'\s Update stage.');
                         }
                         
                         
                     }
                         else if((bidType =='OTC New Product' ||bidType =='OTC OTB Good Dated'||bidType =='OTC OTB Short Dated'||bidType =='OTC Price Change'||bidType =='OTC Product Addition'||bidType =='OTC Rebate Change'||bidType =='OTC RFP'||bidType =='OTC Volume Review'||bidType =='Platform OTB')&&(ApprovalStatus =='Vistex Update'||ApprovalStatus =='Closed')){
                             component.set("v.isError",true);
                             component.set("v.errorMessage",'You can not Recall the bid after Contract\'\s stage.');
                         }
                
            }
            component.set("v.showSpinner",false);
        });
        $A.enqueueAction(getBidInfoAction);
        
    },
    closeQuickActionPanel: function (component, event, helper) {
        
        helper.closeActionPanel();
        
    },
    
    recallTheBid : function(component, event, helper) {
        component.set("v.showSpinner",true);
        var bidId = component.get("v.recordId");
        var stepName = component.get("v.selectedStep");
        console.log('stepName---->'+stepName);
        var bidType = component.get("v.bidType");
        if(bidType!='Price Change' && bidType!='Product Addition' && bidType!='RFP Bids' && bidType!='Volume Review Only' && bidType!='Sales Out Rebate' && bidType!='Customer Rebate Change' && bidType!='Good Dated OTB' && bidType!='One Time Buy Good Dated Shelf Life for New Product Launch' && bidType!='Short Dated OTB'  && bidType!='New Product Launch' && bidType!='New Customer' &&  bidType!='Initial Order Discount for WAC Customers (No-Contract Price Offering)' && bidType!='SRx IPA Price Change'  && bidType!='SRx IPA Product Addition'  && bidType!='NEW Individual Pricing Agreement (IPA)'){
           stepName = 'Draft';
           console.log('stepName is---->'+stepName);
       }
        
        console.log(bidId);
        var recallTheBidAction = component.get("c.recallBid");
        recallTheBidAction.setParams({ "bidId": bidId ,"stepName":stepName });
        

        recallTheBidAction.setCallback(this, function (response) {
            var actState = response.getState();
            if (actState === 'SUCCESS'){
                component.set("v.showSpinner",false);
                var res = response.getReturnValue();
                if(res == 'Success'){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "message":"Bid Approval is Recalled.",
                        "type":"success",
                        "mode":"dismissible"
                    });
                    toastEvent.fire();
                    
                    helper.closeActionPanel(); 
                    window.location.reload();
                }
                else{
                    console.log('see res=>'+JSON.stringify(res));
                    component.set("v.isError",true);
                    component.set("v.errorMessage",res);
                } 
            }
        });
        $A.enqueueAction(recallTheBidAction);
        
    },
    
    showTheScreen: function(component, event, helper){
        component.set("v.showNextScreen",false);
        component.set("v.ScreenClose",true);
        var boolean = component.get("v.showNextScreen");
         console.log('showTheScreen action called.');
        console.log('showNextScreen'+boolean);
    },
    
    enableContinue: function(component, event, helper){
      var stepName = component.get("v.selectedStep");
        if(stepName!='None'){
        console.log('stepName---->'+stepName);
        component.set("v.ShowContinue",true);
        }
        else {
              component.set("v.ShowContinue",false);
        }
           //var stepName = component.get("v.selectedStep");
        console.log('stepName---->'+stepName);
        console.log('ShowContinue--->'+component.get("v.ShowContinue"));
    },
    
})