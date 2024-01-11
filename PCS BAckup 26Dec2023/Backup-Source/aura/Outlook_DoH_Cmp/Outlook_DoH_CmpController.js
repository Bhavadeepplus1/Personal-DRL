({
   doInit : function(component, event, helper) {
        var getBidInfoAction = component.get("c.getAccountGroups");
        component.set('v.loaded',true);
        
        getBidInfoAction.setCallback(this, function (response) {
            var actState = response.getState();
            if (actState == 'SUCCESS') {
                var responseWrapper=response.getReturnValue();
                console.log('accGroupList-----'+JSON.stringify(responseWrapper));
                component.set('v.loaded',false);
                var pickList =  [];
                var picklistValues = responseWrapper.accgrpList;
                //   console.log('picklistValues-----'+picklistValues[0]);
                if(picklistValues.length>0 && picklistValues[0] != undefined){
                    component.set('v.selectedId',picklistValues[0]); 
                    //component.set('v.selectedI
                }
                
                var i = 1;
                var newLine = 1;
                picklistValues.forEach(function(user){
                    var isNewLine = false;
                    if(newLine == 5){
                        isNewLine = true;
                        newLine =1;
                    }
                    pickList.push({userId:''+user,isSelected: i==1?true:false,isNewLine:isNewLine});
                    i++;
                    newLine++;
                });
                //  console.log('picklist-----'+JSON.stringify(pickList));
                component.set("v.pickList",pickList);
                component.set("v.lowInvRecords",responseWrapper.lowInvRecords);
                component.set("v.highInvRecords",responseWrapper.highInvRecords);
                component.set("v.highValueRecords",responseWrapper.highValueRecords);
            }
            else{
                console.log("Error "+JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(getBidInfoAction);
        
    }, 
	 onSelectUser : function(component, event, helper) {
        var getBidInfoAction = component.get("c.getDoHRecords");
                 var selectedId =  component.get('v.selectedId');
        component.set('v.loaded',true);
        getBidInfoAction.setParams({
            customerName : selectedId
            
        });
        getBidInfoAction.setCallback(this, function (response) {
            var actState = response.getState();
            if (actState == 'SUCCESS') {
                var responseWrapper=response.getReturnValue();
                
               component.set("v.DoHList",responseWrapper);
                component.set("v.lowInvRecords",responseWrapper.lowInvRecords);
                component.set("v.highInvRecords",responseWrapper.highInvRecords);
                component.set("v.highValueRecords",responseWrapper.highValueRecords);
                var lowInvRecords = component.get("v.lowInvRecords");
                console.log('lowInvRecords>>'+JSON.stringify(lowInvRecords));
                              component.set('v.loaded',false);

         
        }
             else{
                console.log("Error "+JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(getBidInfoAction);
        
    }, 
      redirectDoH: function(component, event, helper){
                  window.open('/lightning/n/DoH_Report');

    }
})