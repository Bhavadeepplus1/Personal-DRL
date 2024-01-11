({
    doInit : function(component, event, helper) {
        component.set("v.isSpinner",true);
        var picliList = component.get('v.TaskStatusList');
        picliList.push('New');
        picliList.push('Sent to OPPORTUNITY');
        picliList.push('Sent to BRIGHT');
        component.set("v.TaskStatusList",picliList);
        console.log('--- picliList ---'+JSON.stringify(picliList));
       // var accId = component.get("v.Account.Id");
        var action = component.get("c.getExpansionData");
        action.setParams({picliList:picliList});
        action.setCallback(this, function (response) {
            console.log('State from getGcpRelatedList :: '+response.getState());
            if (response.getState() == "SUCCESS") {
                var wrapperList = response.getReturnValue();
                if(wrapperList.length > 0)
                    component.set("v.accObj",wrapperList[0].accObj);
                console.log('--- shareExpansionList ---'+JSON.stringify(response.getReturnValue()));
                component.set("v.shareExpansionList",response.getReturnValue());
                component.set('v.isSpinner', false);
            }
            else {
                component.set('v.isSpinner', false);
            }
        });
        $A.enqueueAction(action);
    },
    handleChange : function(component, event, helper){
        var selectedStatus = component.find("dateId").get("v.value");
        console.log('selectedStatus -->'+selectedStatus);
    },
    searchTaskStatus : function(component, event, helper){
        component.set("v.isSpinner",true);
        var picliList = component.get('v.TaskStatusList');        
        if(component.get("v.isNewChecked") && !picliList.includes('New')){
            console.log('I am New')
            picliList.push('New');
        }
        if(component.get("v.isSentToOptyChecked") && !picliList.includes('Sent to OPPORTUNITY')){
            picliList.push('Sent to OPPORTUNITY');
        }
        if(component.get("v.isSentToBrightChecked") && !picliList.includes('Sent to BRIGHT')){
            picliList.push('Sent to BRIGHT');
        }
        if(component.get("v.isNewChecked") == false && picliList.includes('New')){
            var ind = picliList.indexOf('New')
            picliList.splice(ind, 1);
        }
        if(component.get("v.isSentToOptyChecked") == false && picliList.includes('Sent to OPPORTUNITY')){
            var ind = picliList.indexOf('Sent to OPPORTUNITY')
            picliList.splice(ind, 1);
        }
        if(component.get("v.isSentToBrightChecked") == false && picliList.includes('Sent to BRIGHT')){
            var ind = picliList.indexOf('Sent to BRIGHT')
            picliList.splice(ind, 1);
        }
        console.log('--- picliList ---'+JSON.stringify(picliList));
        component.set("v.TaskStatusList",picliList);
        
      //  var accId = component.get("v.recordId");
        var action = component.get("c.getExpansionData");
        action.setParams({picliList:picliList});
        action.setCallback(this, function (response) {
            console.log('State from getGcpRelatedList :: '+response.getState());
            if (response.getState() == "SUCCESS") {
                component.set('v.isSpinner', false);
                //console.log('--- shareExpansionList ---'+JSON.stringify(response.getReturnValue()));
                component.set("v.shareExpansionList",response.getReturnValue());
                
            }
            else {
                component.set('v.isSpinner', false);
            }
        });
        $A.enqueueAction(action);
    },
    sortByProdPos : function(component, event, helper){
        console.log('Sorting called');
        component.set('v.isSpinner', true);
        if(component.get("v.filterName") != 'Task Status')
            component.set("v.isAsc", false);
        component.set("v.filterName",'Task Status');
        component.set("v.sortField",'Task_Status__c');
        helper.sortBy(component, 'Task_Status__c');
        component.set('v.isSpinner', false);
    },
    sortByCustomerName : function(component, event, helper){
        console.log('inside customerName');
         
        helper.sortHelper(component, event, 'Vision_Customer__r.Name');
    },
    sortByBaselineVolume: function(component, event, helper){
        console.log('inside BaselineVolume');
         
        helper.sortHelper(component, event, 'Baseline_Volume__c');
    },
    sortByBaselineDollar: function(component, event, helper){
        console.log('inside BaselineVolume');
         
        helper.sortHelper(component, event, 'Baseline_Dollar__c');
    },
     sortByTargetVolume: function(component, event, helper){
        console.log('inside BaselineVolume');
         
        helper.sortHelper(component, event, 'Target_Volume__c');
    },
    sortByTargetDollar: function(component, event, helper){
        console.log('inside BaselineVolume');
         
        helper.sortHelper(component, event, 'Target_Dollar__c');
    },
})