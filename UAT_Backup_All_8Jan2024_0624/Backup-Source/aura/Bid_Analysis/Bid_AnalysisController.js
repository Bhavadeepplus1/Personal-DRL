({
    doInit : function(component, event, helper) {
        var getBidInfoAction = component.get("c.bidDetails");
        
        var id = component.get("v.recordId");
        console.log('id-->'+id);
        component.set('v.isSpinnerLoad', true);
        var selectedRange = 'THIS_FISCAL_YEAR';
        getBidInfoAction.setParams({
            'startDate': null,
            'endDate': null,
            accountId :component.get("v.recordId"),
            selectedRange : selectedRange,
            selectedDate : "Submitted Date"
        });
        getBidInfoAction.setCallback(this, function (response) {
            var actState = response.getState();
            if (actState == 'SUCCESS') {
                console.log('Hi');
                var responseWrapper=response.getReturnValue();
                component.set("v.mainWrapper",responseWrapper);
                var aaccName = component.get("v.customerName");
                component.set('v.isSpinnerLoad', false);
                console.log('Bid analysis-->'+JSON.stringify(responseWrapper));
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
    searchIntExt : function(component, event, helper){
        
        var getAttributeValue = component.get("v.isINTChecked");
        if(getAttributeValue=="true"){
            component.set("v.checkThis","false");
        }
        else{
            component.set("v.checkThis","true");
        }
        
    },
    handleChange : function(component, event, helper){
        console.log('handleChange called-->');
        /*   var selectedDate=event.getParam("value");
         var selectedRange=event.getParam("value");
        console.log('selectedDate-->'+selectedDate);
        console.log('selectedRange-->'+selectedRange);*/
        component.set('v.isSpinnerLoad', true);
        var selectedRange = component.find("rangeId").get("v.value");
        var selectedDate = component.find("dateId").get("v.value");
        console.log('selectedRange-->'+selectedRange);
        console.log('selectedDate-->'+selectedDate);
        component.set('v.selectedRange',selectedRange);
        component.set('v.selectedDate',selectedDate);
        var getBidInfoAction = component.get("c.bidDetails");
        
        if(selectedRange != 'Custom'){
            console.log('hi custom date null');
            component.set("v.startDate",null);
            component.set("v.endDate",null);
        }
          if(selectedDate == 'Submitted Date' || selectedDate == 'Sent to Customer Date'){
           
            component.set("v.startDate",null);
            component.set("v.endDate",null);
        }
        getBidInfoAction.setParams({
            accountId :component.get("v.recordId"),
            selectedRange : selectedRange,
            selectedDate : selectedDate
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
                accountId :component.get("v.recordId"),
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