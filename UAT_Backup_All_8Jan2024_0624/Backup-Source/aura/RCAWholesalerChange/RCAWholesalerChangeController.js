({
	doInit : function(component,event,helper) {
        var bidId = component.get("v.recordId");
        console.log('bidId-----'+bidId);
        
        var getQuoteInfo = component.get("c.getbidInfo");
        getQuoteInfo.setParams({ "bidId": bidId });
        getQuoteInfo.setCallback(this, function (response) {
            var actState = response.getState();
            
            if (actState === 'SUCCESS') {
                
                
                component.set("v.wrap", response.getReturnValue());
                console.log("wrap-----"+JSON.stringify(response.getReturnValue()));
               helper.loadRCAContracts(component,helper);
                
                
            }
        });
        $A.enqueueAction(getQuoteInfo);
   
      },
    
     closeModal: function (component, event, helper) {
      component.set("v.showProducts", false);
      // Go to record
       var dismissActionPanel = $A.get("e.force:closeQuickAction");
       dismissActionPanel.fire();
      
 },
    removeDeletedRow: function (component, event, helper) {
        
        var selectedRec = event.getSource().get("v.name");
        console.log('selectedRec'+selectedRec);
        
        var AllRowsList = component.get("v.rcaList");
        
       
        
        
       
        for (let i = 0; i < AllRowsList.length; i++) {
            
            var rca = AllRowsList[i];
            if(rca.flag){
              var index = selectedRec-1;
                if (index > -1) {
                    console.log('index---'+index);
                    
                    AllRowsList.splice(index, 1);  
                    break;
            }
            }
                else{
            if (rca.acc.Id == selectedRec) {
                
                var index = AllRowsList.indexOf(rca);
                if (index > -1) {
                      console.log('index---'+index);
                    AllRowsList.splice(index, 1);
                    //var AllRowsList1 = AllRowsList;
                    
                }
                
            }
        }
        }
        
        component.set("v.rcaList",[]);
        component.set("v.rcaList", AllRowsList);
        
        if (AllRowsList.length === 0) 
            component.set("v.isQLlistempty", true);
       
        else
            component.set("v.isQLlistempty", false);
        console.log('isQLlistempty'+component.get("v.isQLlistempty"));
    },
    insertRCALines: function (component, event, helper) {
           component.set("v.showSpinnerSelProds",true);
         var getProductsAction = component.get("c.createRCALines");
        getProductsAction.setParams({ "rcaList": component.get("v.rcaList"),"recordId":component.get("v.recordId") });
        getProductsAction.setCallback(this, function (response) {
            var actState = response.getState();
            if (actState === 'SUCCESS') {
                component.set("v.showSpinnerSelProds",false);
                var resposeData = response.getReturnValue();
               var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": 'success',
                    "message": "RCA Lines has been added successfully."
                });
                toastEvent.fire();
                //$A.get('e.force:refreshView').fire();
                var dismissActionPanel = $A.get("e.force:closeQuickAction");
                dismissActionPanel.fire();
               
            }
        
        });
        $A.enqueueAction(getProductsAction);
    },
    
    processNewRCALine: function (component, event, helper) {
        component.set("v.showSpinnerSelProds",true);
          component.set("v.isQLlistempty", false);
        var rcaUpdateList=component.get("v.rcaList");
         var getProductsAction = component.get("c.processRCALine");
        getProductsAction.setParams({"recordId":component.get("v.recordId")});
        getProductsAction.setCallback(this, function (response) {
            var actState = response.getState();
            if (actState === 'SUCCESS') {
                component.set("v.showSpinnerSelProds",false);
                var resposeData = response.getReturnValue();
                rcaUpdateList.push(resposeData);
                console.log('resposeData--------'+resposeData);
                component.set("v.rcaList",rcaUpdateList);
               
            }
        
        });
        $A.enqueueAction(getProductsAction);
        
    },
    getupdateCustomer: function (component, event, helper) {
           var accId = event.getSource().get("v.value");
           var index=event.getSource().get("v.label"); 
           console.log('accId'+accId);
         console.log('index---------'+index);
        component.set("v.accountId",accId);
       helper.getCustomerInfo(component,helper);
        
    },
        

})