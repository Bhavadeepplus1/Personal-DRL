/**
 * @description       : 
 * @author            : Surender Patel (Dhruvsoft)
 * @group             : 
 * @last modified on  : 29-05-2021
 * @last modified by  : Surender Patel (Dhruvsoft)
 * Modifications Log 
 * Ver   Date         Author                       Modification
 * 1.0   29-05-2021   Surender Patel (Dhruvsoft)   Initial Version
**/
({
       
    fetchPickListVal: function (component, fieldName, picklistOptsAttributeName) {
        var action = component.get("c.getselectOptions");
        action.setParams({
            "objObject": component.get("v.objInfoForPicklistValues"),
            "fld": fieldName
        });
        var opts = [];
        $A.enqueueAction(action);
    },
    requiredValidation: function (component, event, helper) {
        var Record = component.get("v.singleRec");
        var templateType = component.get("v.templateType");
        console.log('Record--' + JSON.stringify(Record));
        var isValid = true;
        if (Record.Phoenix_Proposed_Indirect_Selling_Unit__c == null && (templateType == 'Indirect' || templateType == 'Direct and Indirect')) {
            isValid = false;
        }
        if (Record.Phoenix_Proposed_Direct_Selling_Unit__c == null && (templateType == 'Direct' || templateType == 'Direct and Indirect')) {
            isValid = false;
        }
        if (Record.Phoenix_ProposedContract_Bid_Price_Sales__c == null && (templateType == 'Direct' || templateType == 'Direct and Indirect' || templateType == 'Direct')) {
            isValid = false;
        }
        if (isValid == false) {
            alert('Please fill all required fields');
        }
        return isValid;
    },
    getCalculations: function (component, event, helper, currentValue, fieldName, isGuidancePrice,templateType) {
        // component.set("v.isSpinner",true);
        var LineItem = component.get("v.singleRec");
        var bidType = component.get("v.bidType");
        var LineItemId = LineItem.Id;
        var WAC = LineItem.Phoenix_WAC__c;
        var proposedPriceSales = LineItem.Phoenix_ProposedContract_Bid_Price_Sales__c;
        var proposedPriceMarketing = LineItem.Phoenix_ProposedContractBidPriceMktng__c;
        var diffPriceIndirect = LineItem.Phoenix_Wholesaler_Diff_Price_Indirect__c;
        console.log('proposedPriceMarketing'+proposedPriceMarketing);
        if (((WAC < proposedPriceSales || WAC < proposedPriceMarketing) && (WAC !=0 && WAC != undefined)) && !isGuidancePrice) {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type": "Error",
                "title": "Failed!",
                "message": 'Proposed price can not be greater than WAC ' + '($' + WAC + ')'
            });
            toastEvent.fire();
            if (WAC < proposedPriceSales)
                component.set("v.singleRec.Phoenix_ProposedContract_Bid_Price_Sales__c", null);
            if (WAC < proposedPriceMarketing)
                component.set("v.singleRec.Phoenix_ProposedContractBidPriceMktng__c", null)
            
        } else if (diffPriceIndirect < proposedPriceMarketing || diffPriceIndirect > WAC) {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type": "Error",
                "title": "Error",
                "message": 'The Proposed Indirect Contract Price should not be less than the Proposed Direct Contract Price and should not be more than WAC'
            });
            toastEvent.fire();
                        component.set("v.singleRec.Phoenix_Wholesaler_Diff_Price_Indirect__c", null);

        }
         /*else if (diffPriceIndirect < proposedPriceMarketing && bidType != 'Volume Review Only') {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type": "Error",
                "title": "Error",
                "message": 'Wholesaler Diff Price can not be less than Marketing Price'
            });
            toastEvent.fire();
            component.set("v.singleRec.Phoenix_Wholesaler_Diff_Price_Indirect__c", null);
        }
      */
        else{
            console.log('updating line')
            console.log('proposedPriceMarketing1--->'+LineItem.Phoenix_ProposedContractBidPriceMktng__c);
            var action = component.get("c.getCalcs");
            action.setParams({
                LineItem: LineItem,
                LineItemId: LineItemId,
                currentValue: currentValue,
                fieldLabel: fieldName
            });
        action.setCallback(this, function (response) {
            if (response.getState() === 'SUCCESS') {
                console.log('calc response--' + JSON.stringify(response.getReturnValue()));
                component.set("v.singleRec", response.getReturnValue());
                var singleRec = response.getReturnValue();
               
        
                    console.log('singleRec'+response.getReturnValue().Phoenix_Wholesaler_Diff_Price_Indirect__c);
                    var event = component.getEvent("calcEvent");
                    event.fire();
                    var latestEstimate = component.get("v.singleRec.Phoenix_Latest_Estimate__c") != null ? component.get("v.singleRec.Phoenix_Latest_Estimate__c") : 0;
                    var BudgetedASP = component.get("v.singleRec.Phoenix_Budgeted_ASP1__c") != null ? component.get("v.singleRec.Phoenix_Budgeted_ASP1__c") : 0;
                    var Deadnet = component.get("v.singleRec.Phoenix_Internal_Dead_Net_Price__c") != null ? component.get("v.singleRec.Phoenix_Internal_Dead_Net_Price__c") : 0;
                    Deadnet = (Math.round(Deadnet * 100) / 100).toFixed(2);
                    var DirectDeadNet = component.get("v.singleRec.Phoenix_Direct_Dead_Net__c") != null ? component.get("v.singleRec.Phoenix_Direct_Dead_Net__c") : 0;
                    DirectDeadNet = (Math.round(DirectDeadNet * 100) / 100).toFixed(2);
                    if(component.get("v.templateType") == 'Direct and Indirect'){
                        Deadnet= DirectDeadNet;
                    }
                    component.set("v.Deadnet",Deadnet);
                    console.log('BudgetedASP-------->' + BudgetedASP)
                    console.log('BudgetedASP-------->' + latestEstimate)
                    if (latestEstimate > 0) {
                        var isAccpetable = ((latestEstimate / 100) * 10 + latestEstimate) < Deadnet ? true : false;
                        var isNotAccpetable = (latestEstimate - (latestEstimate / 100) * 10) < Deadnet ? true : false;
                        component.set("v.isAccpetable", isAccpetable);
                        component.set("v.isNotAccpetable", isNotAccpetable);
                    } else if (BudgetedASP > 0) {

                        var isAccpetable = ((BudgetedASP / 100) * 10 + BudgetedASP) < Deadnet ? true : false;
                        var isNotAccpetable = (BudgetedASP - (BudgetedASP / 100) * 10) < Deadnet ? true : false;
                        component.set("v.isAccpetable", isAccpetable);
                        component.set("v.isNotAccpetable", isNotAccpetable);

                    } else {
                        console.log('else conditin--->')
                        component.set("v.isAccpetable", false);
                        component.set("v.isNotAccpetable", false);
                        console.log('isAccpetable---->' + component.get("v.isAccpetable"));
                        console.log('isNotAccpetable--->' + component.get("v.isNotAccpetable"))
                    }

                } else {
                    //component.set("v.isSpinner",false);
                }

            });
            $A.enqueueAction(action);
        }  
    },
    getPositions: function (component, event, helper, customerRecId) {
        var action = component.get("c.getPositions");
        action.setParams({
            customerID: customerRecId
            // searchInput:searchInput

        });
        action.setCallback(this, function (response) {
            if (response.getState() === "SUCCESS") {
                var responseList = response.getReturnValue();
                console.log('---responseList---' + responseList.length);
                //component.set("v.contratcsList",responseList);

                //below code is for remove seleceted while fetch contracts in table
                var slctpositions;
                if (component.get('v.singleRec.Phoenix_Proposed_Position__c') != null) {
                    slctpositions = component.get('v.singleRec.Phoenix_Proposed_Position__c').split(',');
                    console.log('slctpositions--' + slctpositions);
                    /* var finalPositions= responseList.filter(comparer(slctpositions)); 
                     function comparer(otherArray){
                         return function(current){
                             return otherArray.filter(function(other){
                                 console.log(other);
                                 return other == current.Name 
                             }).length == 0;
                         }
                     }*/
                }
                for (var i = 0; i < responseList.length; i++) {
                    var row = responseList[i];
                    if (row.Phoenix_Customer__c) {
                        row.Phoenix_Customer__c = row.Phoenix_Customer__r.Name;
                    }
                }
                component.set("v.LinepositionsList", responseList);

            }


        });
        $A.enqueueAction(action);
    }
 
})