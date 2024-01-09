({
    doInit : function(component, event, helper) {
        component.set("v.loadSpinner", true);
        var pageNumber = component.get("v.PageNumber");  
        var pageSize = component.find("pageSize").get("v.value");
		helper.getData(component, pageNumber, pageSize);
    },
    openPendingTasksPopup: function(component, event, helper){
      	component.set("v.showPendingTasksPopup", !component.get("v.showPendingTasksPopup"));
        var selectedUser = event.getSource().get("v.name");
        console.log('Selected User: '+selectedUser);
        var selectedUserName = event.getSource().get("v.title");
        console.log('selectedUserName: '+selectedUserName);
        component.set("v.userName", selectedUserName);
        helper.fetchIPItems(component, event, helper, selectedUser);
    },
    closePendingTasksModal: function(component, event, helper){
      	component.set("v.showPendingTasksPopup", false);
        component.set("v.userName", '');
    },
    updateSorting : function(component, event, helper) {
          var fieldName = event.getParam('fieldName');
          var sortDirection = event.getParam('sortDirection');
          component.set("v.sortedBy", fieldName);
          component.set("v.sortedDirection", sortDirection);
          helper.sortData(component, fieldName, sortDirection);
    },
    openFilterPopup: function(component, event, helper){
      	component.set("v.showFilterPopup", !component.get("v.showFilterPopup"));
    },
    closeModal: function(component, event, helper){
        component.set("v.showFilterPopup", false);
    },
    resetFromOuterButton: function(component, event, helper) {
        $A.get('e.force:refreshView').fire();
    },
    reset: function(component, event, helper) {
        component.set("v.loadSpinner", true);
        component.set("v.changeTo", null);
        component.find("userLookup").fireChanging();
        component.find("delegatedUserLookup").fireChanging();   
        var action = component.get("c.getExistingDeleRecords");
        action.setParams({
            
            'userId': component.get("v.userLkp"),
            'deleUserId':component.get("v.deleUserLkp"),
            "pageNumber": component.get("v.PageNumber"),
            "pageSize": component.find("pageSize").get("v.value")
            
        });  
        action.setCallback(this, function(response) 
                           {
                               if(response.getState()=="SUCCESS"){
                                   var deleUsersList = response.getReturnValue().deleUsersList;
                                   component.set("v.excistingDeleList", deleUsersList);
                                   component.set("v.showFilterPopup", false);
                               }
                           });
        $A.enqueueAction(action);
        component.set("v.loadSpinner", false);
    },
    handleNext: function(component, event, helper) {
        var pageNumber = component.get("v.PageNumber");  
        var pageSize = component.find("pageSize").get("v.value");
        if(pageNumber != component.get("v.TotalPages")){
            pageNumber++;
            helper.getData(component, pageNumber, pageSize);
        }
    },
    handleFirst: function(component, event, helper) {
        var pageNumber = 1;  
        var pageSize = component.find("pageSize").get("v.value");
        helper.getData(component, pageNumber, pageSize);
    },
    handleLast: function(component, event, helper) {
        var pageNumber = component.get("v.TotalPages");  
        var pageSize = component.find("pageSize").get("v.value");
        helper.getData(component, pageNumber, pageSize);
    },
     
    handlePrev: function(component, event, helper) {
        var pageNumber = component.get("v.PageNumber");  
        var pageSize = component.find("pageSize").get("v.value");
        if(pageNumber != 1){
            pageNumber--;
            helper.getData(component, pageNumber, pageSize);
        }
    },
     
    onSelectChange: function(component, event, helper) {
        var pageNumber = 1
        var pageSize = component.find("pageSize").get("v.value");
        helper.getData(component, pageNumber, pageSize);
    },
    
})