({
	updateData : function(component, event, helper) {
        var family = component.get("v.family");
        var familyIdMap = component.get("v.familyIdMap");
        component.set("v.familySummaryObj.familyId", familyIdMap[family]);
        var action = component.get("c.upsertRecords");
        console.log('Input: '+JSON.stringify(component.get("v.supplyIssue")));
        action.setParams({
            'supplyIssue': component.get("v.supplyIssue")//JSON.stringify(component.get("v.familySummaryObj"))
        });
        action.setCallback(this, function(response){
            if(response.getState() == 'SUCCESS'){
                console.log('Response: '+JSON.stringify(response.getReturnValue()));
                var response = response.getReturnValue();
                var supplyIssue = component.get("v.supplyIssue");
                supplyIssue.TPT__c = parseInt(response.TPT__c);
                supplyIssue.COLO_Adjusted__c = parseInt(response.COLO_Adjusted__c);
                supplyIssue.Selected_Month__c = response.Selected_Month__c;
                supplyIssue.capacityConstraint = (response.Capacity_Constraint__c == 'Yes'? true: false);
                supplyIssue.Capacity_Constraint__c = (response.Capacity_Constraint__c ? 'Yes' : 'No');
                supplyIssue.Product_Family__c = response.Product_Family__c;
                supplyIssue.SCM_Rejection_Reasons__c = response.SCM_Rejection_Reasons__c;
                supplyIssue.Mitigation_Plan_s__c = response.Mitigation_Plan_s__c;
                supplyIssue.Id = response.Id;
                component.set("v.supplyIssue", supplyIssue);
                
                /*var familySummaryObj = component.get("v.familySummaryObj");
                familySummaryObj.finalCOLO = response.COLO_Adjusted__c;
                familySummaryObj.finalTPTDollar = response.TPT__c;
                familySummaryObj.capacityConstraint = (response.Capacity_Constraint__c =='Yes' ? true : false);
                familySummaryObj.selectedMonth = response.Selected_Month__c;
                familySummaryObj.familyId = response.Product_Family__c;
                component.set("v.familySummaryObj", familySummaryObj);*/
            } else{
                console.log("Exception: "+JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);
	}
})