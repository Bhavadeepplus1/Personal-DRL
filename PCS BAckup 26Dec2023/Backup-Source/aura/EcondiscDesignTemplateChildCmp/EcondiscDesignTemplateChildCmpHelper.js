({
    fetchPickListVal: function(component, fieldName, picklistOptsAttributeName) {
        var action = component.get("c.getselectOptions");
        action.setParams({
            "objObject": component.get("v.objInfoForPicklistValues"),
            "fld": fieldName
        });
        var opts = [];
        $A.enqueueAction(action);
    }, 
    getCalculations : function(component,event,helper, currentValue, fieldName,isGuidancePrice,isMarketingPrice,isSalesPrice){  
        // component.set("v.isSpinner",true);
        var LineItem=component.get("v.singleRec");
        var bidType=component.get("v.bidType");
        var LineItemId=LineItem.Id;
        var WAC = LineItem.Phoenix_WAC__c;
        var proposedPriceSales = LineItem.Phoenix_ProposedContract_Bid_Price_Sales__c;
        var proposedPriceMarketing = LineItem.Phoenix_ProposedContractBidPriceMktng__c;
        var diffPriceIndirect=LineItem.Phoenix_Wholesaler_Diff_Price_Indirect__c;
        var msg= isMarketingPrice ? 'Marketing Price can not be greater than WAC ($'+LineItem.Phoenix_WAC__c+')' : isSalesPrice ? 'Sales Price can not be greater than WAC ($'+LineItem.Phoenix_WAC__c+')' : ''; 
        if(((WAC < proposedPriceSales || WAC < proposedPriceMarketing) && (WAC != 0 && WAC != undefined)) && !isGuidancePrice){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type":"Error",
                "title": "Error",
                "message": msg
            });
            toastEvent.fire();
            if(WAC < proposedPriceSales)
            	component.set("v.singleRec.Phoenix_ProposedContract_Bid_Price_Sales__c", null);
            if(WAC < proposedPriceMarketing)
                component.set("v.singleRec.Phoenix_ProposedContractBidPriceMktng__c", null);
          
        }
        else if(WAC != 0 && WAC != undefined && WAC<diffPriceIndirect && bidType!='Volume Review Only'){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type":"Error",
                "title": "Error",
                "message": 'Wholesaler Diff Price can not be greater than WAC ($'+LineItem.Phoenix_WAC__c+')'
            });
            toastEvent.fire();
            component.set("v.singleRec.Phoenix_Wholesaler_Diff_Price_Indirect__c", null);
        }
            else if(diffPriceIndirect<proposedPriceMarketing && bidType!='Volume Review Only'){
              var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type":"Error",
                "title": "Error",
                "message": 'Wholesaler Diff Price can not be less than Marketing Price'
            });
            toastEvent.fire();
            component.set("v.singleRec.Phoenix_Wholesaler_Diff_Price_Indirect__c", null);
        }
        //else{
            var action = component.get("c.getCalcs");
            action.setParams({
                LineItem: LineItem,
                LineItemId: LineItemId,
                currentValue: currentValue,
                fieldLabel : fieldName
            });
            action.setCallback(this, function(response) 
                               {
                                   if(response.getState()==='SUCCESS'){
                                       console.log('calc response--'+JSON.stringify(response.getReturnValue()));
                                       component.set("v.singleRec",response.getReturnValue());
                                       var event = component.getEvent("calcEvent");
                                       var latestEstimate = component.get("v.singleRec.Phoenix_Latest_Estimate__c") != null ? component.get("v.singleRec.Phoenix_Latest_Estimate__c") : 0;
                                       var BudgetedASP = component.get("v.singleRec.Phoenix_Budgeted_ASP1__c") != null ? component.get("v.singleRec.Phoenix_Budgeted_ASP1__c") : 0;
                                       var Deadnet = component.get("v.singleRec.Phoenix_Internal_Dead_Net_Price__c") != null ? component.get("v.singleRec.Phoenix_Internal_Dead_Net_Price__c") : 0;
                                       Deadnet = (Math.round(Deadnet * 100) / 100).toFixed(2);
                                       component.set("v.Deadnet",Deadnet);
                                       if(latestEstimate > 0){
                                           var isAccpetable= ((latestEstimate/100)*10 + latestEstimate) < Deadnet ? true : false;
                                           var isNotAccpetable= (latestEstimate - (latestEstimate/100)*10) < Deadnet ? true : false;
                                           component.set("v.isAccpetable",isAccpetable);
                                           component.set("v.isNotAccpetable",isNotAccpetable);
                                       }
                                       else if(BudgetedASP > 0){
                                           var isAccpetable= ((BudgetedASP/100)*10 + BudgetedASP) < Deadnet ? true : false;
                                           var isNotAccpetable= (BudgetedASP - (BudgetedASP/100)*10) < Deadnet ? true : false;
                                           component.set("v.isAccpetable",isAccpetable);
                                           component.set("v.isNotAccpetable",isNotAccpetable);
                                       }else{
                                           console.log('else condition--->')
                                           component.set("v.isAccpetable",false);
                                           component.set("v.isNotAccpetable",false);
                                       }
                                       
                                       event.fire();
                                       //component.set("v.isSpinner",false);
                                   } else{
                                       //component.set("v.isSpinner",false);
                                   }
                                   
                               });      
            $A.enqueueAction(action);
        //}
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