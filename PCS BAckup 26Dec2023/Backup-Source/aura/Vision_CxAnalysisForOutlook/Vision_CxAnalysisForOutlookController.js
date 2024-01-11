({
	doInit : function(component, event, helper) {
        helper.getCustomerDetails(component, event, helper, 'noAccSelected');
	},
    handleChange : function(component, event, helper){
        if(component.get("v.customerLkp")){
            helper.getCustomerDetails(component, event, helper, component.get("v.customerLkp"));
        }
        else{
            var a = component.get('c.doInit');
            $A.enqueueAction(a);
        }
    },
    onNext : function(component, event, helper) {   
        var a = component.get('c.doInit');
        $A.enqueueAction(a);
    },
    showSaveButton : function(component, event, helper) {   
        component.set("v.showSaveCancelBtn",true);
    },
    onRecordSubmit : function(component, event, helper) {   
        event.preventDefault(); 
        var eventFields = event.getParam("fields");
        component.find("customerForm").submit(eventFields);
    },
    onRecordSuccess : function(component, event, helper) {   
        console.log('records submitted successfully..');
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "SUCCESS",
            "message":'Header Defaults Saved Successfully!',
            "type":"SUCCESS",
            "mode":"dismissible"
        });
        toastEvent.fire();
        component.set("v.showSaveCancelBtn",false);
        var a = component.get('c.handleChange');
        $A.enqueueAction(a);
    },
    directToAccount : function(component, event, helper){
        window.open('/'+component.get("v.accObj.Id"));
    }
})