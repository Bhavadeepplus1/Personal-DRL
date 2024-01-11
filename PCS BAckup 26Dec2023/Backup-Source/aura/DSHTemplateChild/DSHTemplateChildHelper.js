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
    getCalculations: function (component, event, helper, currentValue, fieldName, isGuidancePrice1, isMarketingPrice1, isMarketingPrice2, isSalesPrice1,isSalesPrice2,MarketingDSHPrice,DSHSalesPrice) {
        console.log('currentValue---' + currentValue);
        console.log('fieldName---' + fieldName);
        // component.set("v.isSpinner",true);
        var LineItem = component.get("v.singleRec");
        var bidType = component.get("v.bidType");
        var LineItemId = LineItem.Id;
        var WAC = LineItem.Phoenix_WAC__c;
        var proposedPriceSales1 = LineItem.Phoenix_Retail_Direct_Sales_Price__c;
        var proposedPriceSales2 = LineItem.Phoenix_Wholesaler_Sales_Price__c;
           var proposedPriceSales3 = LineItem.Phoenix_WMT_Indirect_Current_Sales__c;
        
        var proposedPriceMarketing1 = LineItem.Phoenix_Retail_Direct_Price__c;
        var proposedPriceMarketing2 = LineItem.Phoenix_Retail_Indirect_Price__c;
         var proposedPriceMarketing3 = LineItem.Phoenix_Retail_Indirect_Net__c;

        //var diffPriceIndirect=LineItem.Phoenix_Wholesaler_Diff_Price_Indirect__c;
        var msg1 = isMarketingPrice1 ? 'Proposed BASE Contract Price can not be greater than WAC ($' + LineItem.Phoenix_WAC__c + ')' : isSalesPrice1 ? 'BASE Sales Price can not be greater than WAC ($' + LineItem.Phoenix_WAC__c + ')' : '';
        var msg2= isMarketingPrice2 ? 'Proposed AutoSub Contract Price can not be greater than WAC ($'+LineItem.Phoenix_WAC__c+')' : isSalesPrice2 ? 'AUTO SUB Sales Price can not be greater than WAC ($'+LineItem.Phoenix_WAC__c+')' : ''; 
       var msg3= MarketingDSHPrice ? 'Proposed DSH Contract Price can not be greater than WAC ($'+LineItem.Phoenix_WAC__c+')' : DSHSalesPrice ? 'DSH Sales Price can not be greater than WAC ($'+LineItem.Phoenix_WAC__c+')' : ''; 

        if (WAC != 0 && WAC != undefined && (WAC < proposedPriceSales1 || WAC < proposedPriceMarketing1) || (WAC < proposedPriceSales2 || WAC < proposedPriceMarketing2)|| (WAC < proposedPriceSales3 || WAC < proposedPriceMarketing3)) {

            if ((WAC < proposedPriceSales1 || WAC < proposedPriceMarketing1)) {
                var toastEvent1 = $A.get("e.force:showToast");
                toastEvent1.setParams({
                    "type": "Error",
                    "title": "Error",
                    "message": msg1
                });

                toastEvent1.fire();
            }
            if((WAC < proposedPriceSales2 || WAC < proposedPriceMarketing2)){
                var toastEvent2 = $A.get("e.force:showToast");
                toastEvent2.setParams({
                    "type":"Error",
                    "title": "Error",
                    "message": msg2
                });
                
                toastEvent2.fire();
            }
            
            if((WAC < proposedPriceSales3 || WAC < proposedPriceMarketing3)){
                var toastEvent3 = $A.get("e.force:showToast");
                toastEvent3.setParams({
                    "type":"Error",
                    "title": "Error",
                    "message": msg3
                });
                
                toastEvent3.fire();
            }
            

            if (WAC < proposedPriceSales1) {
                component.set("v.singleRec.Phoenix_Retail_Direct_Sales_Price__c", null);
            }

            if(WAC < proposedPriceSales2){	component.set("v.singleRec.Phoenix_Wholesaler_Sales_Price__c", null);}
               if(WAC < proposedPriceSales3){	component.set("v.singleRec.Phoenix_WMT_Indirect_Current_Sales__c", null);}

            if (WAC < proposedPriceMarketing1) {
                component.set("v.singleRec.Phoenix_Retail_Direct_Price__c", null)
            }

            if(WAC < proposedPriceMarketing2){   component.set("v.singleRec.Phoenix_Retail_Indirect_Price__c", null)}
                 if(WAC < proposedPriceMarketing3){   component.set("v.singleRec.Phoenix_Retail_Indirect_Net__c", null)}

            var action = component.get("c.getCalcs");
            console.log('LineItem---' + LineItem + '--LineItemId--' + currentValue);
            console.log('nameofEditfield---' + fieldName + '--currentValue--' + currentValue);
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
                    var latestEstimate = component.get("v.singleRec.Phoenix_Latest_Estimate__c") != null ? component.get("v.singleRec.Phoenix_Latest_Estimate__c") : 0;
                    var BudgetedASP = component.get("v.singleRec.Phoenix_Budgeted_ASP1__c") != null ? component.get("v.singleRec.Phoenix_Budgeted_ASP1__c") : 0;
                     var Deadnet = component.get("v.singleRec.Phoenix_Wholesaler_DRL_Net_Price__c") != null ? component.get("v.singleRec.Phoenix_Wholesaler_DRL_Net_Price__c") : 0;
        var WHLSDRLPrice = component.get("v.singleRec.Phoenix_Anda_DRL_Net_price__c") != null ? component.get("v.singleRec.Phoenix_Anda_DRL_Net_price__c") : 0;
        var AndaDRLPrice = component.get("v.singleRec.Phoenix_Wholesaler_DRL_TPT__c") != null ? component.get("v.singleRec.Phoenix_Wholesaler_DRL_TPT__c") : 0;
        Deadnet = (Math.round(Deadnet * 100) / 100).toFixed(2);
        WHLSDRLPrice = (Math.round(WHLSDRLPrice * 100) / 100).toFixed(2);
        AndaDRLPrice = (Math.round(AndaDRLPrice * 100) / 100).toFixed(2);
        component.set("v.Deadnet",Deadnet);
        component.set("v.WHLSDRLPrice",WHLSDRLPrice);
        component.set("v.AndaDRLPrice",AndaDRLPrice);
        console.log('Deadnet----' + Deadnet);
        console.log('latestEstimate----' + ((latestEstimate / 100) * 10 + latestEstimate));
        if (latestEstimate > 0) {
            var isAccpetable = ((latestEstimate / 100) * 10 + latestEstimate) < Deadnet ? true : false;
            var isNotAccpetable = (latestEstimate - (latestEstimate / 100) * 10) < Deadnet ? true : false;
            component.set("v.isAccpetable", isAccpetable);
            component.set("v.isNotAccpetable", isNotAccpetable)

            var isAccpetable1 = ((latestEstimate / 100) * 10 + latestEstimate) < WHLSDRLPrice ? true : false;
            var isNotAccpetable1 = (latestEstimate - (latestEstimate / 100) * 10) < WHLSDRLPrice ? true : false;
            component.set("v.isAccpetable1", isAccpetable1);
            component.set("v.isNotAccpetable1", isNotAccpetable1)

            var isAccpetable2 = ((latestEstimate / 100) * 10 + latestEstimate) < AndaDRLPrice ? true : false;
            var isNotAccpetable2 = (latestEstimate - (latestEstimate / 100) * 10) < AndaDRLPrice ? true : false;
            component.set("v.isAccpetable2", isAccpetable2);
            component.set("v.isNotAccpetable2", isNotAccpetable2)

        } else if (BudgetedASP > 0) {
            var isAccpetable = ((BudgetedASP / 100) * 10 + BudgetedASP) < Deadnet ? true : false;
            var isNotAccpetable = (BudgetedASP - (BudgetedASP / 100) * 10) < Deadnet ? true : false;
            component.set("v.isAccpetable", isAccpetable);
            component.set("v.isNotAccpetable", isNotAccpetable)

            var isAccpetable1 = ((BudgetedASP / 100) * 10 + BudgetedASP) < WHLSDRLPrice ? true : false;
            var isNotAccpetable1 = (BudgetedASP - (BudgetedASP / 100) * 10) < WHLSDRLPrice ? true : false;
            component.set("v.isAccpetable1", isAccpetable1);
            component.set("v.isNotAccpetable1", isNotAccpetable1)

            var isAccpetable2 = ((BudgetedASP / 100) * 10 + BudgetedASP) < AndaDRLPrice ? true : false;
            var isNotAccpetable2 = (BudgetedASP - (BudgetedASP / 100) * 10) < AndaDRLPrice ? true : false;
            component.set("v.isAccpetable2", isAccpetable2);
            component.set("v.isNotAccpetable2", isNotAccpetable2)

        } else {
            console.log('else condition--->')
            component.set("v.isAccpetable", false);
            component.set("v.isNotAccpetable", false);
            component.set("v.isAccpetable1", false);
            component.set("v.isNotAccpetable1", false);
            component.set("v.isAccpetable2", false);
            component.set("v.isNotAccpetable2", false);
        }


                    var event = component.getEvent("calcEvent");
                    event.fire();
                    //component.set("v.isSpinner",false);
                } else {
                    //component.set("v.isSpinner",false);
                }

            });
            $A.enqueueAction(action);
        } 
        /*else if (WAC < proposedPriceMarketing2 && bidType != 'Volume Review Only' && bidType != 'Sales Out Rebate') {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type": "Error",
                "title": "Error",
                "message": 'Proposed AutoSub Contract Price can not be greater than WAC ($' + LineItem.Phoenix_WAC__c + ')'
            });
            toastEvent.fire();
            component.set("v.singleRec.Phoenix_Retail_Indirect_Price__c", null);
        } 
        */
       /* else if (proposedPriceMarketing2 < proposedPriceMarketing1 && bidType != 'Volume Review Only' && bidType != 'Sales Out Rebate') {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type": "Error",
                "title": "Error",
                "message": 'Proposed AutoSub Contract Price can not be less than Proposed BASE Contract Price'
            });
            toastEvent.fire();
            component.set("v.singleRec.Phoenix_Retail_Indirect_Price__c", null);
        }
        */
        else {
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
                    var event = component.getEvent("calcEvent");
                    var latestEstimate = component.get("v.singleRec.Phoenix_Latest_Estimate__c") != null ? component.get("v.singleRec.Phoenix_Latest_Estimate__c") : 0;
                    var BudgetedASP = component.get("v.singleRec.Phoenix_Budgeted_ASP1__c") != null ? component.get("v.singleRec.Phoenix_Budgeted_ASP1__c") : 0;
                    var Deadnet = component.get("v.singleRec.Phoenix_Wholesaler_DRL_Net_Price__c") != null ? component.get("v.singleRec.Phoenix_Wholesaler_DRL_Net_Price__c") : 0;
                    var WHLSDRLPrice = component.get("v.singleRec.Phoenix_Anda_DRL_Net_price__c") != null ? component.get("v.singleRec.Phoenix_Anda_DRL_Net_price__c") : 0;
                    var AndaDRLPrice = component.get("v.singleRec.Phoenix_Wholesaler_DRL_TPT__c") != null ? component.get("v.singleRec.Phoenix_Wholesaler_DRL_TPT__c") : 0;
                    Deadnet = (Math.round(Deadnet * 100) / 100).toFixed(2);
                    WHLSDRLPrice = (Math.round(WHLSDRLPrice * 100) / 100).toFixed(2);
                    AndaDRLPrice = (Math.round(AndaDRLPrice * 100) / 100).toFixed(2);
                    component.set("v.Deadnet",Deadnet);
                    component.set("v.WHLSDRLPrice",WHLSDRLPrice);
                    component.set("v.AndaDRLPrice",AndaDRLPrice);
                    
                    console.log('Deadnet----' + Deadnet);
                    console.log('latestEstimate----' + ((latestEstimate / 100) * 10 + latestEstimate));
                    if (latestEstimate > 0) {
                        var isAccpetable = ((latestEstimate / 100) * 10 + latestEstimate) < Deadnet ? true : false;
                        var isNotAccpetable = (latestEstimate - (latestEstimate / 100) * 10) < Deadnet ? true : false;
                        component.set("v.isAccpetable", isAccpetable);
                        component.set("v.isNotAccpetable", isNotAccpetable)

                        var isAccpetable1 = ((latestEstimate / 100) * 10 + latestEstimate) < WHLSDRLPrice ? true : false;
                        var isNotAccpetable1 = (latestEstimate - (latestEstimate / 100) * 10) < WHLSDRLPrice ? true : false;
                        component.set("v.isAccpetable1", isAccpetable1);
                        component.set("v.isNotAccpetable1", isNotAccpetable1)

                        var isAccpetable2 = ((latestEstimate / 100) * 10 + latestEstimate) < AndaDRLPrice ? true : false;
                        var isNotAccpetable2 = (latestEstimate - (latestEstimate / 100) * 10) < AndaDRLPrice ? true : false;
                        component.set("v.isAccpetable2", isAccpetable2);
                        component.set("v.isNotAccpetable2", isNotAccpetable2)

                    } else if (BudgetedASP > 0) {
                        var isAccpetable = ((BudgetedASP / 100) * 10 + BudgetedASP) < Deadnet ? true : false;
                        var isNotAccpetable = (BudgetedASP - (BudgetedASP / 100) * 10) < Deadnet ? true : false;
                        component.set("v.isAccpetable", isAccpetable);
                        component.set("v.isNotAccpetable", isNotAccpetable)

                        var isAccpetable1 = ((BudgetedASP / 100) * 10 + BudgetedASP) < WHLSDRLPrice ? true : false;
                        var isNotAccpetable1 = (BudgetedASP - (BudgetedASP / 100) * 10) < WHLSDRLPrice ? true : false;
                        component.set("v.isAccpetable1", isAccpetable1);
                        component.set("v.isNotAccpetable1", isNotAccpetable1)

                        var isAccpetable2 = ((BudgetedASP / 100) * 10 + BudgetedASP) < AndaDRLPrice ? true : false;
                        var isNotAccpetable2 = (BudgetedASP - (BudgetedASP / 100) * 10) < AndaDRLPrice ? true : false;
                        component.set("v.isAccpetable2", isAccpetable2);
                        component.set("v.isNotAccpetable2", isNotAccpetable2)

                    } else {
                        console.log('else condition--->')
                        component.set("v.isAccpetable", false);
                        component.set("v.isNotAccpetable", false);
                        component.set("v.isAccpetable1", false);
                        component.set("v.isNotAccpetable1", false);
                        component.set("v.isAccpetable2", false);
                        component.set("v.isNotAccpetable2", false);
                    }

                    event.fire();
                    //component.set("v.isSpinner",false);
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