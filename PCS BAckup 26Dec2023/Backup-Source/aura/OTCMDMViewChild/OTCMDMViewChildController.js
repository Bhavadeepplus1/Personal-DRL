({
	doInit : function(component, event, helper) {
		
	},
     onSAPNumberChange : function(component,event,helper){  
        component.set("v.SAPNumberEdit", true);
        setTimeout(function(){
            component.find("SAPNumber").focus();
        }, 100);
    },
    closeSAPNumber: function(component,event,helper){  
        component.set("v.SAPNumberEdit", false);
    },
    onRecordEdit:function(component,event,helper){  
        var nameofEditfield = event.getSource().get('v.name');
        var ItemStatus = event.getSource().get('v.value');
        var actionItem = component.get("v.mdmItem");
        if(nameofEditfield == 'Itemstatus' && ItemStatus != undefined && ItemStatus != null)
            actionItem.Status__c = ItemStatus;
        var productList = component.get("v.productList");
        var isDuplicateProductCode=false;
        if(productList != undefined && productList.length>0){
            productList.forEach(function(product){
                if(product.ProductCode == ItemStatus){
                    isDuplicateProductCode=true;
                }
            });
        }
        if(isDuplicateProductCode){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type": "Error",
                "title": "Error!",
                "message": "Duplicate Product Code Found. Please verify Product Code.."
            });
            toastEvent.fire();
        }
        else{
            var action = component.get("c.updateLineItem");
            action.setParams({
                bidId: component.get("v.recordId"),
                actionItem: actionItem
            });
            action.setCallback(this, function(response) 
                               {
                                   if(response.getState()==='SUCCESS'){
                                       var wrapper = response.getReturnValue(); 
                                       component.set("v.mdmItem",wrapper.updatedActoinItem);
                                       var compEvent = component.getEvent("mdmEvent");
                                       compEvent.setParams({
                                           "canHeSubmit" : wrapper.canHeSubmit
                                       });
                                       compEvent.fire();
                                   }else{
                                       console.log('error--')
                                   }
                               });
            $A.enqueueAction(action);
        }
        
    },
    inlineEditStatus:function(component,event,helper){
        component.set("v.statusEdit", true);
        setTimeout(function(){
            component.find("itemStatus").focus();
        }, 100);

    },
    onNDCChange:function(component,event,helper){
        component.set("v.NDCEdit", true);
        setTimeout(function(){
            component.find("NDCNumber").focus();
        }, 100);

    },
    closeStatusBox: function(component,event,helper){  
        component.set("v.statusEdit", false);
    },
    closeNDCNumber: function(component,event,helper){  
        component.set("v.NDCEdit", false);
    },
})