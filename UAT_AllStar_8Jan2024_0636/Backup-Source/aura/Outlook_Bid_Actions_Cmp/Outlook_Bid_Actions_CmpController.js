({
    doInit : function(component, event, helper) {
         component.set('v.loaded',true);
        var getBidInfoAction = component.get("c.getBidActions");
        getBidInfoAction.setCallback(this, function (response) {
            var actState = response.getState();
            if (actState == 'SUCCESS') {
                 component.set('v.loaded',false);
                var responseWrapper=response.getReturnValue();
                
                component.set("v.responseObj",responseWrapper);
                console.log('response---'+JSON.stringify(responseWrapper.BidPastActionList));
                
            }
            else{
                
                console.log('errot---'+JSON.stringify(response.getError()));
            }
            
        });
        $A.enqueueAction(getBidInfoAction);
        
    },
    handleClick : function(component, event, helper) {
        console.log('Id Name---'+event.getSource().get('v.name')); 
        var accId = event.getSource().get('v.name');
               console.log('Id Name accid---'+accId); 
 
     /*   var event = $A.get("e.force:navigateToComponent");
        event.setParams({
            componentDef : "c:Vision_Share_Expansion",
            componentAttributes: {
                accId : event.getSource().get('v.name')
              
            }
        });
        event.fire();*/
    /*     var navService = component.find("navService");
     var pageReference = {
                         "type": "standard__component",
                         "attributes": {
                                         "componentName": "c__Vision_Share_Expansion"
                        state: {
                c__accId:accId
               
            }
        }, true);
     navService.navigate(pageReference);*/
      component.find("navigationService").navigate({
            type: "standard__component",
            attributes: {
                componentName: "c__Vision_Share_Expansion" },
            state: {
                c__accId: '0011K00002RDd6lQAD'
               
            }
        }, true);
    },
})