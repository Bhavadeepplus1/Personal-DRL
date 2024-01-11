({
	loadInstance : function(component, helper) {
        component.set("v.isNoteAccept", false);
        var recordId = component.get("v.recordId");
        var action = component.get("c.getNDCChangeInfo");
        action.setParams({
            "recordId": recordId          
        });
        action.setCallback(this, function(response) 
                           {
                               if(response.getState()=="SUCCESS"){
                                   var onLoadData = response.getReturnValue();
                                   component.set("v.Name", onLoadData[0].Phoenix_NDC_Change_Name__c);
                                   component.set("v.Date", onLoadData[0].Phoenix_Date__c);
                                   component.set("v.Description", onLoadData[0].Phoenix_Description__c);
                                   console.log('On Load Data: '+JSON.stringify(onLoadData));
                                   component.set("v.CurrentProductFamilyName", onLoadData[0].Phoenix_Current_Product_Family__c);
                                   component.set("v.ProposedProductFamilyName", onLoadData[0].Phoenix_Proposed_Product_Family__c);
                                   component.set("v.CurrentProductFamily", onLoadData[0].Current_Product_Family__c);
                                   component.set("v.ProposedProductFamily", onLoadData[0].Proposed_Product_Family__c);
                                   component.set("v.ApprovalStatus", onLoadData[0].Phoenix_Approval_Status__c);
                                   component.set("v.disabled", false);
                                   var activeBidProductFamilies = component.get("v.activeBidProductFamilies");
                                   var currentProductFamilies = [];
                                   var proposedProductFamilies = [];
                                   for(var i=0;i< activeBidProductFamilies.length;i++){
                                       var familyKey = Object.keys(activeBidProductFamilies[i]);
                                       currentProductFamilies.push({"class": "optionClass", label: activeBidProductFamilies[i][familyKey], value: familyKey.toString()});
                                       proposedProductFamilies.push({"class": "optionClass", label: activeBidProductFamilies[i][familyKey], value: familyKey.toString()});
                                   }
                                   component.set("v.currentFamilyOptions", currentProductFamilies);
                                   
                                   /*for(var i=0;i< activeBidProductFamilies.length;i++){
                                       if(activeBidProductFamilies[i] != component.get("v.CurrentProductFamily")) {
                                           proposedProductFamilies.push({"class": "optionClass", label: activeBidProductFamilies[i], value: activeBidProductFamilies[i]});
                                       }
                                   }*/
                                   component.set("v.proposedFamilyOptions", proposedProductFamilies);
                                   component.set("v.showChangeProducts", true);
                                   component.set("v.loaded", false);
                                   component.set("v.disableButton", true);
                               } else{
                                   console.log(response.response.getError().message());
                               }
                           });
        $A.enqueueAction(action);
        //this.getNDCLineItems(component, event);
	},
    
    /*getNDCLineItems: function(component, event){
        var action = component.get("c.getNDCLineItems");
        action.setParams({
            'recordId': component.get("v.recordId")
        });
        action.setCallback(this, function(response){
            if(response.getState() == "SUCCESS"){
                var resp = response.getReturnValue();
                component.set("v.productList", resp);
                console.log("response:: "+JSON.stringify(resp));
                component.set("v.showChangeProducts", true);
                component.set("v.isNoteAccept", true);
                component.set("v.disabled", true);
            }
        })
    },*/
})