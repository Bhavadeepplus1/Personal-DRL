({
	loadRCAContracts: function (component, helper) {
        
        
        
        var getProductsAction = component.get("c.getRCAContracts");
        getProductsAction.setParams({ "recordId": component.get("v.recordId") });
        getProductsAction.setCallback(this, function (response) {
            var actState = response.getState();
            if (actState === 'SUCCESS') {
                var wrap=component.get("v.wrap");
                component.set("v.showSpinnerSelProds",false);
                var resposeData = response.getReturnValue();
                if(resposeData!=undefined && resposeData!='' && resposeData!=null ){
                      component.set("v.rcaDate",resposeData[0].RCADate);
                    
                      component.set("v.rcaList",resposeData);
                    if (resposeData.length > 0) {
                        component.set("v.showProducts", true);
                    }
                    
                    }
                else if(wrap.bid.Phoenix_Bid_Type__c!='RCA/IPA Member GPO or Wholesaler Change'){
                    
                    component.set("v.showNoType", true);
                     console.log('hi');
      				}
                    else if(wrap.bid.Phoenix_RCA_Agreement__r.Phoenix_Contract_Status__c=='Expired' || wrap.bid.Phoenix_RCA_Agreement__r.Phoenix_Is_RCA_Contract__c==false){
                       component.set("v.showNoType", true);
                         console.log('hi1');
                       component.set("v.showContrStatus", true);  
                    }
               
                else {   console.log('hi2');
                        component.set("v.noProducts", true);
                    }
                
               
            }
        
        });
        $A.enqueueAction(getProductsAction);
    },
    getCustomerInfo: function (component, helper) {
        console.log('In helper');
          var getProductsAction = component.get("c.customerRCALine");
        console.log('In helper1');
        console.log('recordId--'+component.get("v.recordId"));
         console.log('accountId--'+component.get("v.accountId"));
        getProductsAction.setParams({"rcaList":component.get("v.rcaList"),"accountId":component.get("v.accountId")[0], "recordId":component.get("v.recordId")});
                                    
                                    
         console.log('In helper2');
        getProductsAction.setCallback(this, function (response) {
            var actState = response.getState();
            console.log('actState'+actState);
            if (actState === 'SUCCESS') {
                console.log('success');
                component.set("v.showSpinnerSelProds",false);
                var resposeData = response.getReturnValue();
               
                console.log('resposeData--------'+resposeData);
                component.set("v.rcaList",resposeData);
               
            }
            else if (actState === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } 
            }
        
        });
        $A.enqueueAction(getProductsAction);
    },
})