({
	
    loadHistoricalData : function(component,helper) {
        var recordId=component.get("v.recordId");
        var isCustomerLink=component.get("v.isCustomerLink");
        var isCustomerGroupLink=component.get("v.isCustomerGroupLink");
       var getInfo = component.get("c.getHistoricalData");
        
          getInfo.setParams({ "recordId": recordId,
                             "isCustomerLink" :isCustomerLink,
                             "isCustomerGroupLink" :isCustomerGroupLink
                            });  
        getInfo.setCallback(this, function (response) {
            var actState = response.getState();
            
            if (actState === 'SUCCESS') {
                 var response=response.getReturnValue();
                console.log('method success');
                console.log('response-----------'+JSON.stringify(response));
               if(response!=null && response!=''&& response!=undefined){
                 var accName=response[0].customerName;
                 var prodName=response[0].productName;
                 var accountId=response[0].npr.Phoenix_Account__c;
                 var productId=response[0].npr.Phoenix_Product__c;  
                 console.log('accountname--------'+accName);
                  console.log('productNmae-----'+prodName); 
                   
                   component.set("v.accountId",accountId);  
                 component.set("v.productId",productId);
                 component.set("v.accountName",accName);  
                 component.set("v.productName",prodName);
                   
                 component.set("v.historicalData",[]);
                 component.set("v.historicalData",response);
                   console.log('historicalData-----------'+JSON.stringify(component.get("v.historicalData"))); 
                }
                else{
                    component.set("v.noData",true);
                }
               
            }
        });
        $A.enqueueAction(getInfo);
	},
})