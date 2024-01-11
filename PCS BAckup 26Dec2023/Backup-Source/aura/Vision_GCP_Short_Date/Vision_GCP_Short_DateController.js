({
      doInit : function(component, event, helper) {
        var getBidInfoAction = component.get("c.getAccountGroups");
        component.set('v.loaded',true);
                  var data = component.get("v.shortDateList");
         console.log('data---'+data);
        getBidInfoAction.setCallback(this, function (response) {
            var actState = response.getState();
            if (actState == 'SUCCESS') {
                var responseWrapper=response.getReturnValue();
                 component.set("v.response",responseWrapper);
                 component.set("v.accGroupList",responseWrapper.accList);
                console.log('accgrpList-----'+JSON.stringify(responseWrapper.accgrpList));
              //  component.set("v.shortDateList",responseWrapper.sdRecords);
            //  console.log('shortDateList cxCodeWrapList-----'+JSON.stringify(responseWrapper.accList));
                component.set('v.loaded',false);
                 var pickList =  [];
                var picklistValues = responseWrapper.accgrpList;
                //   console.log('picklistValues-----'+picklistValues[0]);
                if(picklistValues.length>0 && picklistValues[0] != undefined){
                    component.set('v.selectedId',picklistValues[0].accGroupName);   
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
                                   isNewLine:isNewLine});
                    i++;
                    newLine++;
                });
              //  console.log('picklist-----'+JSON.stringify(pickList));
                component.set("v.pickList",pickList);
                //component.set("v.isVersion",true);
        }
        });
        $A.enqueueAction(getBidInfoAction);
        
    },
    onSelectUser : function(component, event, helper){
        //console.log('Id Name---'+event.getSource().get("v.name"));
        component.set('v.loaded', true);
        var selectedId =  event.currentTarget.dataset.id;//event.getSource().get("v.name");
     //   console.log('Id Name---'+selectedId);
        component.set('v.selectedId',selectedId);
        var listOfusers = component.get("v.pickList");
        listOfusers.forEach(function(user){
            if(user.userId == selectedId){
                user.isSelected = true;
            }
            else{
                user.isSelected = false;
            }
        });
        component.set("v.pickList",listOfusers);
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
  
    data : function(component, event, helper) {
        var getBidInfoAction = component.get("c.getShortDateData");
        component.set('v.loaded',true);
         
        getBidInfoAction.setCallback(this, function (response) {
            var actState = response.getState();
            if (actState == 'SUCCESS') {
                var responseWrapper=response.getReturnValue();
                component.set("v.accGroupList",responseWrapper.accList);
                console.log('response--->'+JSON.stringify(responseWrapper.accList))
                component.set('v.loaded',false);
                component.set("v.shortDateList",responseWrapper.gcpShortDates);  
        }
        });
        $A.enqueueAction(getBidInfoAction);
        
    },
    onsearch: function (component, event, helper) {
        console.log('Hi search')
        console.log('Hi search-----'+component.get("v.searchText"))
        component.set("v.noData",false);
        var searchName=component.get("v.searchText");
        component.set('v.loaded',true);
        
        var action = component.get("c.getFiltershortDate");
        
        action.setParams({
            searchText : searchName,
            customer : component.get("v.selectedId")
            
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('hi search')
                var responseWrapper = response.getReturnValue();
                component.set('v.loaded',false);
                if(searchName != null && searchName != undefined)
                    component.set("v.accGroupList", responseWrapper.accList);
                else
                    component.set("v.accGroupList", responseWrapper.accList);
            }  else{
                console.log("Error "+JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);
        
    },
    expandAll: function(component, event, helper){
        console.log('expand');
        
        var data = component.get("v.accGroupList");
        data.forEach(function(account){
            account.showAccount = !(component.get("v.collapse"));
             account.productFamily.forEach(function(pf){
               pf.showAccount = !(component.get("v.collapse"));  
        });
             });
        //var bool =component.get("v.collapse")
        component.set("v.collapse",!(component.get("v.collapse")));
         component.set("v.show",!(component.get("v.collapse")));
      //  data.showProdFam = true;
      //  data.showAccount = true;
        component.set("v.accGroupList",data);
        
    },
    shortVersion: function(component, event, helper){
     /*   component.set("v.loaded",true);
        
        window.setTimeout(
            $A.getCallback(function() {
                component.set("v.loaded",false);
            }), 5000
        ); */
        var version = component.get("v.isVersion");
        console.log('test->'+component.get("v.isVersion"));
        var isIntCheck = component.get("v.isVersion");
        var trueValue = true;
        var falsevalue = false;
        if(isIntCheck == false){
            component.set("v.isVersion",falsevalue);
        }
        else{
            component.set("v.isVersion",trueValue); 
        }
        
    },
    hasPWO: function(component, event, helper){
    /*    component.set("v.loaded",true);
        
        window.setTimeout(
            $A.getCallback(function() {
                component.set("v.loaded",false);
            }), 5000
        ); */
        var version = component.get("v.isPWO");
        console.log('test->'+component.get("v.isPWO"));
        var isCheck = component.get("v.isPWO");
        var trueValue = true;
        var falsevalue = false;
        if(isCheck == false){
            component.set("v.isPWO",falsevalue);
        }
        else{
            component.set("v.isPWO",trueValue); 
        }
        
    }
})