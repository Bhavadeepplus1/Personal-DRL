({
    initRecords : function(component,event,helper){
        var accountId=component.get("v.recordId");
        var action = component.get("c.getAccountPlanDetails");
        action.setParams({
            accountId: accountId
        });
        action.setCallback(this, function(response){
            if(response.getState()=="SUCCESS"){
                var response= response.getReturnValue();
                console.log('response'+JSON.stringify(response));
                component.set("v.accountPlanDetails",response);
                var accPlanValues=component.get("v.accountPlanDetails");
                console.log('accValuesOverview='+JSON.stringify(accPlanValues.Account_Overview__c));
                
                console.log('response.length ---> '+response.length);
                
                //component.set("v.accPlanExists",true);
                component.set("v.accountPlanDetails",response[0]);
                component.set('v.accountOverview',response[0].Account_Overview__c);
                component.set('v.pricingStrategy',response[0].Pricing_Strategy__c);
                component.set('v.customerBuyingStrategy',response[0].Customer_s_Buying_Strategy__c);
                component.set('v.accountStrategy',response[0].Account_Strategy__c);
                component.set('v.growthGoals',response[0].Growth_Goals__c);
                component.set('v.risksChallenges',response[0].Risks_and_Challenges__c);
                
                
            }
            
        });
        $A.enqueueAction(action);},
    
    saveChangetoAccPlan : function(component, event, helper){
        console.log('inside saveChangetoAccPlan');
        
        var action = component.get("c.sendDataAndSave");
        action.setParams({
            accountOverview : component.get("v.accountOverview"),
            pricingStrategy : component.get("v.pricingStrategy"),
            customerBuyingStrategy : component.get("v.customerBuyingStrategy"),
            accountStrategy : component.get("v.accountStrategy"),
            growthGoals : component.get("v.growthGoals"),
            risksChallenges : component.get("v.risksChallenges"),
            accId : component.get("v.recordId")
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('response from save/Update :: '+response.getReturnValue());
                var responseString = response.getReturnValue();
                if(responseString.includes('ERROR')){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type": 'ERROR',
                        "message": ""+responseString
                    });
                    toastEvent.fire();
                }
                else{
                   var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type": 'success',
                        "message": "Account Profile is updated successfully."
                    });
                    toastEvent.fire();
                }
            }
            else{
                console.log('JSON.stringify(response.getError()) ---> '+JSON.stringify(response.getError()));
                var errorInresp = JSON.stringify(response.getError());
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": 'ERROR',
                    "message": ""+errorInresp
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    },
    
})