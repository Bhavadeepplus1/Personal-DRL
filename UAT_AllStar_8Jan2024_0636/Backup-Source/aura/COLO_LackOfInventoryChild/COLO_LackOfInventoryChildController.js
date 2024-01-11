({
    doInit : function(component, event, helper) {
        component.set("v.expandFamily", false);
        var family = component.get("v.family");
        var familyMap = component.get("v.familyMap");
        var familyIdMap = component.get("v.familyIdMap");
        var relatedList = familyMap[family];
        var supplyFamilyIssueMap = component.get("v.supplyFamilyIssueMap");
        var productsMap = {}; var familySummaryObj = {}; var totalCOLO = 0; var totalTPTDollar = 0;
        var customersList = []; var supplyIssueObj = {}; var displayObjectList = [];
        if(relatedList != null){
            for(var i=0; i<relatedList.length; i++){
                customersList.push(relatedList[i].Phoenix_Bid__r.Phoenix_Customer__c);
                totalCOLO += ((relatedList[i].netCOLO != null && !isNaN(relatedList[i].netCOLO)) ? parseFloat(relatedList[i].netCOLO) : 0);
                totalTPTDollar += ((relatedList[i].netTPTDollar != null && !isNaN(relatedList[i].netTPTDollar)) ? parseFloat(relatedList[i].netTPTDollar) : 0);
                if(productsMap.hasOwnProperty(relatedList[i].Phoenix_Product__r.Name)){
                    var tempRelatedList = productsMap[relatedList[i].Phoenix_Product__r.Name];
                    tempRelatedList.push(relatedList[i]);
                    productsMap[relatedList[i].Phoenix_Product__r.Name] = tempRelatedList;
                } else {
                    var tempRelatedList = [];
                    tempRelatedList.push(relatedList[i]);
                    productsMap[relatedList[i].Phoenix_Product__r.Name] = tempRelatedList;
                }      
            }
            var tptPercent = (totalTPTDollar/totalCOLO)*100;
            supplyIssueObj.TPT__c = parseInt(totalTPTDollar);
            supplyIssueObj.COLO_Adjusted__c = parseInt(totalCOLO);
            supplyIssueObj.Selected_Month__c = component.get("v.selectedMonth");
            console.log('Selected Month: '+component.get("v.selectedMonth"));
            supplyIssueObj.capacityConstraint = false;
            supplyIssueObj.Capacity_Constraint__c = (supplyIssueObj.capacityConstraint ? 'Yes' : 'No');
            supplyIssueObj.Product_Family__c = familyIdMap[family];
            supplyIssueObj.SCM_Rejection_Reasons__c = '';
            supplyIssueObj.Mitigation_Plan_s__c = '';
            supplyIssueObj.Product_Director__c = component.get("v.productDirectorId");   
            var splittedMonths = component.get("v.selectedMonth").split(', ');
            component.set("v.splittedMonths", splittedMonths);
            splittedMonths.sort(function(a, b) {
                var dateA = new Date(a);
                var dateB = new Date(b);
                return dateA - dateB;
            });
            /*for(var i=0; i<splittedMonths.length; i++){	
                var obj ={};
                var familyRelatedData; var supplyIssue;
                if(supplyFamilyIssueMap.hasOwnProperty(family)){
                    console.log('Family: '+family);
                	familyRelatedData = supplyFamilyIssueMap[family];
                    console.log('Family Related Data: '+JSON.stringify(familyRelatedData));
                    console.log('Month: '+splittedMonths[i]);
                    if(familyRelatedData.hasOwnProperty(splittedMonths[i])){
                        console.log('Monthly Data: '+JSON.stringify(familyRelatedData[splittedMonths[i]]));
                        supplyIssue = familyRelatedData[splittedMonths[i]];
                        supplyIssueObj.capacityConstraint = (supplyIssue.Capacity_Constraint__c == 'Yes' ? true : false);
                        supplyIssueObj.Capacity_Constraint__c = (supplyIssue.capacityConstraint ? 'Yes' : 'No');
                        supplyIssueObj.SCM_Rejection_Reasons__c = supplyIssue.SCM_Rejection_Reasons__c;
                        supplyIssueObj.Mitigation_Plan_s__c = supplyIssue.Mitigation_Plan_s__c;
                        if(supplyIssue.Get_Well_Date__c){
                            obj.formattedGetWellDate = new Date(supplyIssue.Get_Well_Date__c).toLocaleDateString("en-US", { year: "numeric", month: "2-digit", day: "2-digit" });
                        }
                    }    
                }
                obj.month = splittedMonths[i];
                obj.supplyIssue = supplyIssueObj;
                displayObjectList.push(obj);
            }*/
            if(supplyFamilyIssueMap.hasOwnProperty(family)){
                var familyRelatedData = supplyFamilyIssueMap[family];
                var keys = Object.keys(familyRelatedData);
                if(splittedMonths.length == 1){
                    if(keys.includes(splittedMonths[0])){
                        var obj = {};
                        supplyIssueObj = familyRelatedData[splittedMonths[0]];
                        supplyIssueObj.capacityConstraint = (supplyIssueObj.Capacity_Constraint__c == 'Yes' ? true : false);
                        supplyIssueObj.Capacity_Constraint__c = (supplyIssueObj.capacityConstraint ? 'Yes' : 'No');
                        obj.month = splittedMonths[0];
                        obj.supplyIssue = supplyIssueObj;
                        if(supplyIssueObj.Get_Well_Date__c){
                            obj.formattedGetWellDate = new Date(supplyIssueObj.Get_Well_Date__c).toLocaleDateString("en-US", { year: "numeric", month: "2-digit", day: "2-digit" });
                        }
                        displayObjectList.push(obj);
                    }
                } else{
                    for(var i=0; i<splittedMonths.length; i++){
                        var obj = {};
                        if(familyRelatedData.hasOwnProperty(splittedMonths[i])){
                            supplyIssueObj['month'+(i+1)] = familyRelatedData[splittedMonths[i]];   
                            obj.supplyIssue = familyRelatedData[splittedMonths[i]];
                            if(obj.supplyIssue.Get_Well_Date__c != null){
                                obj.formattedGetWellDate = new Date(obj.supplyIssue.Get_Well_Date__c).toLocaleDateString("en-US", { year: "numeric", month: "2-digit", day: "2-digit" });
                            }
                        }
                        obj.month = splittedMonths[i];
                        displayObjectList.push(obj);
                    }
                }
            } else{
                for(var i=0; i<splittedMonths.length; i++){
                    var obj = {};
                    obj.month = splittedMonths[i];
                    displayObjectList.push(obj);
                }
            }
            var selectedMonth = component.get("v.selectedMonth");
            var tempList = selectedMonth.split(' ');
            console.log('Temp List: '+JSON.stringify(tempList));
            if(tempList.length > 2){
             	component.set("v.isMultipleMonthsSelected", true);   
            }
            else {
             	component.set("v.isMultipleMonthsSelected", false);   
            }
            console.log('displayObjectList: '+JSON.stringify(displayObjectList));
            component.set("v.displayObjectList", displayObjectList);
            familySummaryObj.finalTPTDollar = parseInt(totalTPTDollar);
            familySummaryObj.finalCOLO = parseInt(totalCOLO);
            component.set("v.relatedList", relatedList); 
            component.set("v.productsList", Object.keys(productsMap));
            component.set("v.productsMap", productsMap);
            familySummaryObj.selectedMonth = component.get("v.selectedMonth");
            familySummaryObj.familyId = familyIdMap[family];
            familySummaryObj.updatedRejectionReasons = '';
            familySummaryObj.updatedMitigationPlan = '';
            component.set("v.familySummaryObj", familySummaryObj);
            let uniqueCustomers = [...new Set(customersList)];
            component.set("v.uniqueCustomersCount", uniqueCustomers.length);
            console.log('Selected Month: '+component.get("v.selectedMonth"));
            /*var action = component.get("c.getExistingSupplyIssue");
            action.setParams({
                'family': component.get("v.family"),
                'selectedMonth': component.get("v.selectedMonth")
            });
            action.setCallback(this, function(response){
                if(response.getState() == 'SUCCESS'){
                    var response = response.getReturnValue();
                    if(response != null){
                        component.set("v.supplyIssue", response);   
                    }
                } else{
                    console.log("Exception: "+JSON.stringify(response.getError()));
                }
            });
            $A.enqueueAction(action);*/
            component.set("v.supplyIssue", supplyIssueObj);
        }
    },
    toggle: function(component, event, helper) {
        //var toggleElement = component.find("toggle");
        //$A.util.toggleClass(toggleElement, "active");
        //var isToggled = $A.util.hasClass(toggleElement, "active");
        var capacityConstraint = component.get("v.supplyIssue.capacityConstraint");
        component.set("v.supplyIssue.capacityConstraint", !capacityConstraint);
        if(component.get("v.supplyIssue.capacityConstraint"))
            component.set("v.supplyIssue.Capacity_Constraint__c", 'Yes');
        else
            component.set("v.supplyIssue.Capacity_Constraint__c", 'No');
        helper.updateData(component, event, helper);
    },
    getWellDateChange: function(component, event, helper){
        var supplyIssue = component.get("V.supplyIssue");
        helper.updateData(component, event, helper);
    },
    showMultipleDisplayPopup: function(component, event, helper){
        component.set("v.showDisplayPopup", !component.get("v.showDisplayPopup"));
        console.log('displayObjectList: '+JSON.stringify(component.get("v.displayObjectList")));
    },
    expandFamilyList: function(component, event, helper){
        component.set("v.expandFamily", !component.get("v.expandFamily"));
    },
	onReasonChange : function(component, event, helper) {
		var scmRejectionReasons = component.get("v.familySummaryObj.scmRejectionReasons");
	},
    openSCMRejectionReasonsPopup : function(component, event, helper) {
        component.set("v.familySummaryObj.updatedRejectionReasons", component.get("v.supplyIssue.SCM_Rejection_Reasons__c"));
		component.set("v.showSCMRejectionCommentPopup", !component.get("v.showSCMRejectionCommentPopup"));
	},
    openMitigationPlanPopup: function(component, event, helper) {
        component.set("v.familySummaryObj.updatedMitigationPlan", component.get("v.supplyIssue.Mitigation_Plan_s__c"));
		component.set("v.showMitigationPlanPopup", !component.get("v.showMitigationPlanPopup"));
	},
    saveSCMRejectionReason: function(component, event, helper) {
		component.set("v.supplyIssue.SCM_Rejection_Reasons__c", component.get("v.familySummaryObj.updatedRejectionReasons"));
		component.set("v.showSCMRejectionCommentPopup", !component.get("v.showSCMRejectionCommentPopup"));
        helper.updateData(component, event, helper);
	},
    saveMitigationPlan: function(component, event, helper) {
		component.set("v.supplyIssue.Mitigation_Plan_s__c", component.get("v.familySummaryObj.updatedMitigationPlan"));
		component.set("v.showMitigationPlanPopup", !component.get("v.showMitigationPlanPopup"));
        helper.updateData(component, event, helper);
	},
    updateItems: function(component, event, helper) {
		console.log('Update Line Items');
	},
})