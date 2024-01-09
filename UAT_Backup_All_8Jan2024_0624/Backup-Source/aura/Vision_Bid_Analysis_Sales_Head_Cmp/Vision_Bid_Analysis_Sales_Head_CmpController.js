({
    doInit : function(component, event, helper) {
        console.log('welcome');
        var getBidInfoAction = component.get("c.getTeamMembers");
        
        var id = component.get("v.recordId");
        console.log('id-->'+id);
        component.set('v.isSpinnerLoad', true);
        getBidInfoAction.setCallback(this, function (response) {
            var actState = response.getState();
            if (actState == 'SUCCESS') {
                var responseWrapper=response.getReturnValue();
                component.set("v.mainWrapper",responseWrapper);
                var aaccName = component.get("v.customerName");
                console.log('accName-->'+JSON.stringify(responseWrapper));
                component.set('v.isSpinnerLoad', false);
                console.log('test->'+JSON.stringify(responseWrapper.picklistValues));
                var pickList =  [];
                var picklistValues = responseWrapper.picklistValues;
                if(picklistValues.length>0 && picklistValues[0].Id != undefined){
                    component.set('v.selectedId',picklistValues[0].Id);   
                }
                
                var i = 1;
                var newLine = 1;
                picklistValues.forEach(function(user){
                    var isNewLine = false;
                    if(newLine == 5){
                        isNewLine = true;
                        newLine =1;
                    }
                    pickList.push({userId:''+user.Id,userName:''+user.Name,isSelected: i==1?true:false,isNewLine:isNewLine});
                    i++;
                    newLine++;
                });
                component.set("v.pickList",pickList);
            }
        });
        $A.enqueueAction(getBidInfoAction);
        
    },
    onSelectUser : function(component, event, helper){
        //console.log('Id Name---'+event.getSource().get("v.name"));
        component.set('v.isSpinnerLoad', true);
        var selectedId =  event.currentTarget.dataset.id;//event.getSource().get("v.name");
        console.log('Id Name---'+selectedId);
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
        var getBidInfoAction = component.get("c.bidDetails");
        var selectedRange = component.find("rangeId").get("v.value");
        var selectedDate = component.find("dateId").get("v.value");
        console.log('selectedRange onselect-->'+selectedRange);
        console.log('selectedDate onselect-->'+selectedDate);
        getBidInfoAction.setParams({
            teamMemberId : selectedId,
            selectedRange : selectedRange,
            selectedDate : selectedDate
            
        });
        getBidInfoAction.setCallback(this, function (response) {
            var actState = response.getState();
            if (actState == 'SUCCESS') {
                component.set('v.isSpinnerLoad', false);
                var responseWrapper=response.getReturnValue();
                component.set("v.mainWrapper",responseWrapper);
                
            }
        });
        $A.enqueueAction(getBidInfoAction); 
    },
    callTiles : function(component, event, helper) {
        component.set("v.tile" , true);
        component.set("v.chart" , false);
    },
    callchart : function(component, event, helper){
        component.set("v.tile" , false);
        component.set("v.chart" , true);
    },
    handleChange : function(component, event, helper){
        console.log('handleChange called-->');
      
        component.set('v.isSpinnerLoad', true);
        var selectedRange = component.find("rangeId").get("v.value");
        var selectedDate = component.find("dateId").get("v.value");
        component.set('v.selectedRange',selectedRange);
        component.set('v.selectedDate',selectedDate);
        console.log('selectedRange-->'+selectedRange);
        console.log('selectedId handle change-->'+component.get("v.selectedId"));
        if(selectedRange != 'Custom'){
              console.log('hi custom date null');
            component.set("v.startDate",null);
        component.set("v.endDate",null);
        }
        var getBidInfoAction = component.get("c.bidDetails");
        getBidInfoAction.setParams({
            teamMemberId : component.get("v.selectedId"),
            selectedRange : selectedRange,
            selectedDate : selectedDate,
           
        });
        getBidInfoAction.setCallback(this, function (response) {
            var actState = response.getState();
            if (actState == 'SUCCESS') {
                var responseWrapper=response.getReturnValue();
                component.set("v.mainWrapper",responseWrapper);
                var aaccName = component.get("v.customerName");
                component.set('v.isSpinnerLoad', false);
                console.log('Bid analysis handle change-->'+JSON.stringify(responseWrapper));
                
            }
        });
        $A.enqueueAction(getBidInfoAction);
        
},
    handleStartDateChange: function(component, event, helper) {
        var date1 = component.get("v.startDate");
        var date2 = component.get("v.endDate");
        console.log('Start: '+date1+' End: '+date2);
    },
    handleEndDateChange: function(component, event, helper) {
        var date1 = component.get("v.startDate");
        var date2 =  new Date(component.get("v.endDate"));
        // date2.setDate(date2.getDate() + 1);
        console.log('Start: '+date1+' End: '+date2);
        
    },  
    
    filterData: function(component, event, helper){
        component.set("v.isSpinnerLoad", true);
        var date1 = component.get("v.startDate");
        var date2 =  new Date(component.get("v.endDate"));
        //  date2.setDate(date2.getDate() + 1);
        
        if(date1 == null || date2 == null || date1 == undefined || date2 == undefined || date1 == '' || date2 == ''){
            console.log('Null');
            component.set("v.isSpinnerLoad", false);
            
            var message = 'Please choose both Start Date and End Date';
            helper.showErrorToast(component, event, message);
        } else{
            console.log('error');
            
            var getBidInfoAction = component.get("c.bidDetails");
            getBidInfoAction.setParams({
                'startDate': date1,
                'endDate': date2,
                teamMemberId : component.get("v.selectedId"),
                selectedRange : component.get("v.selectedRange"),
                selectedDate :component.get("v.selectedDate") 
            });
            getBidInfoAction.setCallback(this, function (response) {
                var actState = response.getState();
                if (actState == 'SUCCESS') {
                    component.set('v.isSpinnerLoad', false);
                    var responseWrapper=response.getReturnValue();
                    component.set("v.mainWrapper",responseWrapper);
                    
                }
            });
            $A.enqueueAction(getBidInfoAction);        
        }
    },
    resetData: function(component, event, helper){
        component.set("v.startDate", '');
        component.set("v.endDate", '');
        component.set("v.showReport", false);
    },
    
})