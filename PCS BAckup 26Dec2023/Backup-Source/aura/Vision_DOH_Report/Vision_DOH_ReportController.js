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
                 component.set("v.accGroupList",responseWrapper.accList);
                 component.set("v.isProcessed",responseWrapper.isProcessed); 
                 component.set("v.DoHSummaryList",responseWrapper.dohSummary);
                 component.set("v.tradeGroupList",responseWrapper.dohRecords);
                component.set("v.visionUpdateDate",responseWrapper.visionUpdateDate);
                console.log('dohRecords-----'+JSON.stringify(responseWrapper.dohRecords));
              //  component.set("v.shortDateList",responseWrapper.sdRecords);
              console.log('shortDateList DoH-----'+JSON.stringify(responseWrapper.dohSummary));
                component.set('v.loaded',false);
                 var pickList =  [];
                var picklistValues = responseWrapper.accgrpList;
                //   console.log('picklistValues-----'+picklistValues[0]);
                if(picklistValues.length>0 && picklistValues[0] != undefined){
                    component.set('v.selectedId',picklistValues[0]);   
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
        }
             else{
                console.log("Error "+JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(getBidInfoAction);
        
    }, 
    onSelectUser : function(component, event, helper){
        //console.log('Id Name---'+event.getSource().get("v.name"));
        var picliList = component.get('v.RxSrxList');
        console.log('picliList---'+picliList);
        component.set('v.loaded', true);
               // var action=component.get("c.handleComponentEvent");
        //$A.enqueueAction(action);
        console.log('showRecords'+component.get("v.showRecords"));
         component.set("v.showRecords", false);
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
        var getBidInfoAction = component.get("c.getRxDoHData");
       console.log('onselect version'+component.get("v.isVersion"));
          console.log('onselect isPWO'+component.get("v.isPWO"));
        getBidInfoAction.setParams({
            "productType": component.get("v.RxSrxList"),
            searchText : component.get("v.searchText"),
            customer : component.get("v.selectedId")
   });
        getBidInfoAction.setCallback(this, function (response) {
            var actState = response.getState();
            if (actState == 'SUCCESS') {
                component.set('v.loaded', false);
                component.set('v.searchText', null);
                var responseWrapper=response.getReturnValue();
                console.log('responseWrapper onselect-----'+JSON.stringify(responseWrapper));
                component.set("v.accGroupList",responseWrapper.accList);
                component.set("v.shortDateList",responseWrapper.gcpShortDates);  
  component.set("v.DoHSummaryList",responseWrapper.dohSummary);
                console.log('dohSummary-----'+JSON.stringify(responseWrapper.dohSummary))
            }
             else{
                console.log("Error "+JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(getBidInfoAction);

    },
    searchSrxRxOttc : function(component,event,helper){
        component.set('v.searchText', null);
        helper.searchRx(component, helper);
    },
  
	 /*     doInit : function(component, event, helper) {
        var getDOHAction = component.get("c.getTradePartnerGroups");
        component.set('v.loaded',true);
                  var data = component.get("v.dohList");
                  console.log('data---'+data);
        getDOHAction.setCallback(this, function (response) {
            var actState = response.getState();
            if (actState == 'SUCCESS') {
                var responseWrapper=response.getReturnValue();
                 component.set("v.tradeGroupList",responseWrapper.tradePartnerList);
              //  component.set("v.shortDateList",responseWrapper.sdRecords);
            //  console.log('shortDateList cxCodeWrapList-----'+JSON.stringify(responseWrapper.accList));
                component.set('v.loaded',false);
                 var pickList =  [];
                var picklistValues = responseWrapper.tradepartnergrpList;
                //   console.log('picklistValues-----'+picklistValues[0]);
                if(picklistValues.length>0 && picklistValues[0] != undefined){
                    component.set('v.selectedId',picklistValues[0]);   
                }
                
                var i = 1;
                var newLine = 1;
                picklistValues.forEach(function(user){
                    var isNewLine = false;
                    if(newLine == 4){
                        isNewLine = true;
                        newLine =1;
                    }
                    pickList.push({userId:''+user,isSelected: i==1?true:false,isNewLine:isNewLine});
                    i++;
                    newLine++;
                });
              //  console.log('picklist-----'+JSON.stringify(pickList));
                component.set("v.pickList",pickList);
        }
        });
        $A.enqueueAction(getDOHAction);
        
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
        var getDOHAction = component.get("c.getDOHData");
       //console.log('onselect version'+component.get("v.isVersion"));
          //console.log('onselect isPWO'+component.get("v.isPWO"));
        getDOHAction.setParams({
            customer : component.get("v.selectedId")
   });
        getDOHAction.setCallback(this, function (response) {
            var actState = response.getState();
            if (actState == 'SUCCESS') {
                component.set('v.loaded', false);
                var responseWrapper=response.getReturnValue();
             //   console.log('responseWrapper onselect-----'+JSON.stringify(responseWrapper.shortDateRecords));
                component.set("v.tradeGroupList",responseWrapper.tradePartnerList);
                component.set("v.dohList",responseWrapper.dohReportData);  
 
            }
        });
        $A.enqueueAction(getDOHAction); 
    },*/
    onsearch: function (component, event, helper) {
        console.log('Hi search')
        console.log('Hi search-----'+component.get("v.searchText"))
        component.set("v.noData",false);
        var searchName=component.get("v.searchText");
        component.set('v.loaded',true);
        
        var action = component.get("c.getFilterDoHData");
        
        action.setParams({
            searchText : searchName,
            customer : component.get("v.selectedId"),
            productType: component.get("v.RxSrxList")
            
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
                 if (state === "SUCCESS") {
                console.log('hi search')
                  component.set("v.showRecords", false);
                var responseWrapper = response.getReturnValue();
                console.log('responseWrapper'+JSON.stringify(responseWrapper));
                component.set('v.loaded',false);
                if(searchName != null && searchName != undefined)
                    component.set("v.DoHSummaryList",responseWrapper.dohSummary);
                else
                     component.set("v.DoHSummaryList",responseWrapper.dohSummary);
            }  else{
                console.log("Error "+JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);
        
    },
    searchSrxRxOttc : function(component,event,helper){
        component.set('v.searchText', null);
        // var action=component.get("c.handleComponentEvent");
     //   $A.enqueueAction(action);
        helper.searchRx(component, helper);
       

    } ,

    handleComponentEvent : function(component, event, helper) {
        var valueFromChild = event.getParam("showRecords");
      // alert(valueFromChild);
        component.set("v.showRecords", valueFromChild);
    },
     closeModel: function(component, event, helper) {
        // Set isModalOpen attribute to true
        component.set("v.isModalOpen", false);
      
    },
     openModal: function(component, event, helper) {
        // Set isModalOpen attribute to true
        component.set("v.isModalOpen", true);
      
    },

      
})