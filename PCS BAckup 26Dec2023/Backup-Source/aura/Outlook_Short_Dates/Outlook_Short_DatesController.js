({
    doInit : function(component, event, helper) {
        var getBidInfoAction = component.get("c.getAccountGroups");
        component.set('v.loaded',true);
        
        getBidInfoAction.setCallback(this, function (response) {
            var actState = response.getState();
            if (actState == 'SUCCESS') {
                var responseWrapper=response.getReturnValue();
                
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
   pickList.push({userId:''+user.accGroupName,
                                   acc3Mon:''+user.totalInValue3MonthsAcc,
                                   acc9Mon:''+user.totalInValue9MonthsAcc,
                                   writeOffQtyAcc3MonPW:''+user.writeOffQtyAcc3MonPW,
                                   writeOffDollarAcc3MonPW:''+user.writeOffDollarAcc3MonPW,
                                   writeOffQtyAcc9MonPW:''+user.writeOffQtyAcc9MonPW,
                                   writeOffDollarAcc9MonPW:''+user.writeOffDollarAcc9MonPW,
                                   writeOffQtyAccShowAll:''+user.writeOffQtyAccShowAll,
                                   writeOffDollarAccShowAll:''+user.writeOffDollarAccShowAll,
                                   isSelected: i==1?true:false,
                                   isNewLine:isNewLine});                    i++;
                    newLine++;
                });
                console.log('picklist-----'+JSON.stringify(pickList));
                component.set("v.pickList",pickList);
                                 component.set("v.response",responseWrapper);
                component.set('v.loaded', false);

                  component.set("v.totalInValue",responseWrapper.accList.totalInValue);
                component.set("v.noOfCustGrps",responseWrapper.accgrpList.noOfCustGrps);                
            }
            else{
                console.log("Error "+JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(getBidInfoAction);
        
    }, 
    onSelectUser : function(component, event, helper){
        var selectedId =  component.get('v.selectedId');
                        component.set('v.loaded', true);

        //event.getSource().get("v.name");
        console.log('Id Name---'+selectedId);
        var getBidInfoAction = component.get("c.getShortDateData");
        console.log('onselect version'+component.get("v.isVersion"));
        console.log('onselect isPWO'+component.get("v.isPWO"));
        getBidInfoAction.setParams({
            customer : component.get("v.selectedId")
        });
        getBidInfoAction.setCallback(this, function (response) {
            var actState = response.getState();
            if (actState == 'SUCCESS') {
                component.set('v.loaded', false);
                var responseWrapper=response.getReturnValue();
                component.set("v.backBool",false);
                console.log('responseWrapper onselect-----'+JSON.stringify(responseWrapper.accList));
                component.set("v.accGroupList",responseWrapper.accList);
                responseWrapper.accList.forEach(function(item){
                    item.productFamily.forEach(function(item1){
                        item1.sdpfist.forEach(function(item2){
                            console.log('item2-----'+typeof item2.Vision_M2_Potential_Write_Off__c);
                        });
                    });
                });
              
                component.set("v.shortDateList",responseWrapper.gcpShortDates);  
                console.log('totalInValue3MonthsAcc-----'+responseWrapper.totalInValue3MonthsAcc);
                console.log('totalInValue3MonthsAcc-----'+responseWrapper.totalInValue3MonthsAcc)
            }
        });
        $A.enqueueAction(getBidInfoAction); 
    },
    handleClick  : function(component, event, helper){
        var selectedId = 'Select Customer';
        component.set("v.backBool",true);
        component.set('v.selectedId',selectedId);
    },
     gotoShortDates : function(component, event, helper) {
        window.open('/lightning/n/OTC_Short_Dates');
    },
})