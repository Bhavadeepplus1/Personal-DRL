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
        var LineItem=component.get("v.singleRec");
        var bidType=component.get("v.bidType");
        var LineItemId=LineItem.Id;
        var WAC = LineItem.Phoenix_WAC__c;
        var proposedPriceSales = LineItem.Phoenix_ProposedContract_Bid_Price_Sales__c;
        var proposedPriceMarketing = LineItem.Phoenix_ProposedContractBidPriceMktng__c;
        var diffPriceIndirect=LineItem.Phoenix_Wholesaler_Diff_Price_Indirect__c;
        console.log('WAC :: --> '+WAC+'   || diffPriceIndirect :: --> '+diffPriceIndirect);
        var msg= isMarketingPrice ? 'Marketing Price can not be greater than WAC ($'+LineItem.Phoenix_WAC__c+')' : isSalesPrice ? 'Sales Price can not be greater than WAC ($'+LineItem.Phoenix_WAC__c+')' : ''; 
        if( (WAC != 0 && WAC != undefined) && (WAC < proposedPriceSales || WAC < proposedPriceMarketing) && !isGuidancePrice){
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
          /*  var action = component.get("c.getCalcs");
            action.setParams({
                LineItem: LineItem,
                LineItemId: LineItemId,
                currentValue: currentValue,
                fieldLabel : fieldName
            });
            action.setCallback(this, function(response){
                if(response.getState()==='SUCCESS'){
                    console.log('calc response--'+JSON.stringify(response.getReturnValue()));
                    var singleRec = response.getReturnValue();
                    var childRec = singleRec.BidLineItemsExtn__r[0];
                    component.set("v.singleRec",response.getReturnValue());
                    component.set("v.childRec",childRec);
                    
                    var latestEstimate = component.get("v.singleRec.Phoenix_Latest_Estimate__c") != null ? component.get("v.singleRec.Phoenix_Latest_Estimate__c") : 0;
                    var BudgetedASP = component.get("v.singleRec.Phoenix_Budgeted_ASP1__c") != null ? component.get("v.singleRec.Phoenix_Budgeted_ASP1__c") : 0;
                    var Deadnet = component.get("v.singleRec.Phoenix_Internal_Dead_Net_Price__c") != null ? component.get("v.singleRec.Phoenix_Internal_Dead_Net_Price__c") : 0;
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
                    
                    
                    var event = component.getEvent("calcEvent");                                 
                    event.fire();
                    component.set("v.isSpinner",false);
                } else{
                    component.set("v.isSpinner",false);
                }
                
            });      
            $A.enqueueAction(action);
        }
        /*else if(WAC<diffPriceIndirect && bidType!='Volume Review Only'){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type":"Error",
                "title": "Error",
                "message": 'Wholesaler Diff Price can not be greater than WAC ($'+LineItem.Phoenix_WAC__c+')'
            });
            toastEvent.fire();
            component.set("v.singleRec.Phoenix_Wholesaler_Diff_Price_Indirect__c", null);
        } */
        //else{
        var action = component.get("c.getCalcs");
        action.setParams({
            LineItem: LineItem,
            LineItemId: LineItemId,
            currentValue: currentValue,
            fieldLabel : fieldName
        });
        action.setCallback(this, function(response){
            if(response.getState()==='SUCCESS'){
                console.log('calc response--'+JSON.stringify(response.getReturnValue()));
                var singleRec = response.getReturnValue();
                var childRec = singleRec.BidLineItemsExtn__r[0];
                component.set("v.singleRec",response.getReturnValue());
                component.set("v.childRec",childRec);
                var latestEstimate = component.get("v.singleRec.Phoenix_Latest_Estimate__c") != null ? component.get("v.singleRec.Phoenix_Latest_Estimate__c") : 0;
                var BudgetedASP = component.get("v.singleRec.Phoenix_Budgeted_ASP1__c") != null ? component.get("v.singleRec.Phoenix_Budgeted_ASP1__c") : 0;
                var dirDeadnet = component.get("v.singleRec.Phoenix_Direct_Dead_Net__c") != null ? component.get("v.singleRec.Phoenix_Direct_Dead_Net__c") : 0;
                var indDeadNet = component.get("v.singleRec.Phoenix_Indirect_Dead_Net__c") != null ? component.get("v.singleRec.Phoenix_Indirect_Dead_Net__c") : 0 ;
                var cardDeadNet = component.get("v.singleRec.Phoenix_Customer_Dead_Net1__c") != null ? component.get("v.singleRec.Phoenix_Customer_Dead_Net1__c") : 0 ;
                
                var majorDeadNet = component.get("v.childRec.Phoenix_Internal_Major_Dead_Net__c") != null ? component.get("v.childRec.Phoenix_Internal_Major_Dead_Net__c") : 0 ;
                
                //checking for highlights...
                if(latestEstimate > 0){
                    var isAccpetable= ((latestEstimate/100)*10 + latestEstimate) < dirDeadnet ? true : false;
                    var isNotAccpetable= (latestEstimate - (latestEstimate/100)*10) < dirDeadnet ? true : false;
                    var isAccpetable1= ((latestEstimate/100)*10 + latestEstimate) < indDeadNet ? true : false;
                    var isNotAccpetable1= (latestEstimate - (latestEstimate/100)*10) < indDeadNet ? true : false;
                    var isAccpetable2= ((latestEstimate/100)*10 + latestEstimate) < cardDeadNet ? true : false;
                    var isNotAccpetable2= (latestEstimate - (latestEstimate/100)*10) < cardDeadNet ? true : false;
                    var isAccpetable3= ((latestEstimate/100)*10 + latestEstimate) < majorDeadNet ? true : false;
                    var isNotAccpetable3= (latestEstimate - (latestEstimate/100)*10) < majorDeadNet ? true : false;
                    component.set("v.isAccpetable",isAccpetable);
                    component.set("v.isNotAccpetable",isNotAccpetable);
                    component.set("v.isAccpetable1",isAccpetable1);
                    component.set("v.isNotAccpetable1",isNotAccpetable1);
                    component.set("v.isAccpetable2",isAccpetable2);
                    component.set("v.isNotAccpetable2",isNotAccpetable2);
                    component.set("v.isAccpetable3",isAccpetable3);
                    component.set("v.isNotAccpetable3",isNotAccpetable3);
                }
                else if(BudgetedASP > 0){
                    var isAccpetable= ((BudgetedASP/100)*10 + BudgetedASP) < dirDeadnet ? true : false;
                    var isNotAccpetable= (BudgetedASP - (BudgetedASP/100)*10) < dirDeadnet ? true : false;
                    var isAccpetable1= ((BudgetedASP/100)*10 + BudgetedASP) < indDeadNet ? true : false;
                    var isNotAccpetable1= (BudgetedASP - (BudgetedASP/100)*10) < indDeadNet ? true : false;
                    var isAccpetable2= ((BudgetedASP/100)*10 + BudgetedASP) < cardDeadNet ? true : false;
                    var isNotAccpetable2= (BudgetedASP - (BudgetedASP/100)*10) < cardDeadNet ? true : false;
                    var isAccpetable3= ((BudgetedASP/100)*10 + BudgetedASP) < majorDeadNet ? true : false;
                    var isNotAccpetable3= (BudgetedASP - (BudgetedASP/100)*10) < majorDeadNet ? true : false;
                    component.set("v.isAccpetable",isAccpetable);
                    component.set("v.isNotAccpetable",isNotAccpetable);
                    component.set("v.isAccpetable1",isAccpetable1);
                    component.set("v.isNotAccpetable1",isNotAccpetable1);
                    component.set("v.isAccpetable2",isAccpetable2);
                    component.set("v.isNotAccpetable2",isNotAccpetable2);
                    component.set("v.isAccpetable3",isAccpetable3);
                    component.set("v.isNotAccpetable3",isNotAccpetable3);
                }else{
                    console.log('else condition--->')
                    component.set("v.isAccpetable",false);
                    component.set("v.isNotAccpetable",false);
                    component.set("v.isAccpetable1",false);
                    component.set("v.isNotAccpetable1",false);
                    component.set("v.isAccpetable2",false);
                    component.set("v.isNotAccpetable2",false);
                    component.set("v.isAccpetable3",false);
                    component.set("v.isNotAccpetable3",false);
                }							
                component.set("v.isSpinner",false);
                /*var action = component.get("c.getChildExtnRecord");
                    action.setParams({
                        bliId : LineItemId
                    });
                    action.setCallback(this, function(response){
                        console.log('response.getState() from getUpdatedLineItemRec  -- '+response.getState());
                        if(response.getState()==='SUCCESS'){
                            component.set("v.childRec",response.getReturnValue());
                        }
                        else{
                            component.set("v.isSpinner",false);
                        }
                    });      
                    $A.enqueueAction(action);*/
                var event = component.getEvent("calcEvent");
                event.fire();
                //component.set("v.isSpinner",false);
            } else{
                component.set("v.isSpinner",false);
            }
            
        });      
        $A.enqueueAction(action);
    //}
    },
    
    updateChild : function(component, event, helper, val){
        
        var action = component.get("c.updateChildRec");
        var lineItem = component.get("v.childRec");
        var parentLineItem = component.get("v.singleRec");
        var WAC = parentLineItem.Phoenix_WAC__c;
        var cardinalProposedPrice = lineItem.Phoenix_Proposed_Cardinal_Sales_Price__c;
        var majorProposedPrice = lineItem.Phoenix_Proposed_Major_Sales_Price__c;
        console.log('Phoenix_PropMarktCvsCardinalAcquisitCost__c :: '+lineItem.Phoenix_PropMarktCvsCardinalAcquisitCost__c);
        if(WAC != 0 && WAC != undefined && WAC < cardinalProposedPrice || WAC < majorProposedPrice){
            var msg = 'Marketing Price can not be greater than WAC ($'+parentLineItem.Phoenix_WAC__c+')';
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type":"Error",
                "title": "Error",
                "message": msg
            });
            toastEvent.fire();
            if(WAC < cardinalProposedPrice)
                component.set("v.childRec.Phoenix_Proposed_Cardinal_Sales_Price__c", null);
            if(WAC < majorProposedPrice)
                component.set("v.childRec.Phoenix_Proposed_Major_Sales_Price__c", null)
                }
        console.log('lineItem.Id -- '+lineItem.Id+'  Val -- '+val);
        action.setParams({
            lineItem: lineItem,
            currentValue: val
        });
        action.setCallback(this, function(response){
            console.log('response.getState() -- '+response.getState());
            if(response.getState()==='SUCCESS'){
                //component.set("v.childRec",response.getReturnValue());
                var singleRec = response.getReturnValue();
                var childRec = singleRec.BidLineItemsExtn__r[0];
                component.set("v.singleRec",response.getReturnValue());
                component.set("v.childRec",childRec);
                console.log('Phoenix_PropMarktCvsCardinalAcquisitCost__c in response : '+component.get("v.childRec").Phoenix_PropMarktCvsCardinalAcquisitCost__c);
                var latestEstimate = component.get("v.singleRec.Phoenix_Latest_Estimate__c") != null ? component.get("v.singleRec.Phoenix_Latest_Estimate__c") : 0;
                var BudgetedASP = component.get("v.singleRec.Phoenix_Budgeted_ASP1__c") != null ? component.get("v.singleRec.Phoenix_Budgeted_ASP1__c") : 0;
                var dirDeadnet = component.get("v.singleRec.Phoenix_Direct_Dead_Net__c") != null ? component.get("v.singleRec.Phoenix_Direct_Dead_Net__c") : 0;
                var indDeadNet = component.get("v.singleRec.Phoenix_Indirect_Dead_Net__c") != null ? component.get("v.singleRec.Phoenix_Indirect_Dead_Net__c") : 0 ;
                var cardDeadNet = component.get("v.singleRec.Phoenix_Customer_Dead_Net1__c") != null ? component.get("v.singleRec.Phoenix_Customer_Dead_Net1__c") : 0 ;
                var majorDeadNet = component.get("v.childRec.Phoenix_Internal_Major_Dead_Net__c") != null ? component.get("v.childRec.Phoenix_Internal_Major_Dead_Net__c") : 0 ;
                dirDeadnet = (Math.round(dirDeadnet * 100) / 100).toFixed(2);
                indDeadNet = (Math.round(indDeadNet * 100) / 100).toFixed(2);
                cardDeadNet = (Math.round(cardDeadNet * 100) / 100).toFixed(2);
                majorDeadNet = (Math.round(majorDeadNet * 100) / 100).toFixed(2);
        		component.set("v.majorDeadNet",majorDeadNet);
                component.set("v.dirDeadnet",dirDeadnet);
                component.set("v.indDeadNet",indDeadNet);
                component.set("v.cardDeadNet",cardDeadNet);
                //checking for highlights...
                if(latestEstimate > 0){
                    var isAccpetable= ((latestEstimate/100)*10 + latestEstimate) < dirDeadnet ? true : false;
                    var isNotAccpetable= (latestEstimate - (latestEstimate/100)*10) < dirDeadnet ? true : false;
                    var isAccpetable1= ((latestEstimate/100)*10 + latestEstimate) < indDeadNet ? true : false;
                    var isNotAccpetable1= (latestEstimate - (latestEstimate/100)*10) < indDeadNet ? true : false;
                    var isAccpetable2= ((latestEstimate/100)*10 + latestEstimate) < cardDeadNet ? true : false;
                    var isNotAccpetable2= (latestEstimate - (latestEstimate/100)*10) < cardDeadNet ? true : false;
                    var isAccpetable3= ((latestEstimate/100)*10 + latestEstimate) < majorDeadNet ? true : false;
                    var isNotAccpetable3= (latestEstimate - (latestEstimate/100)*10) < majorDeadNet ? true : false;
                    component.set("v.isAccpetable",isAccpetable);
                    component.set("v.isNotAccpetable",isNotAccpetable);
                    component.set("v.isAccpetable1",isAccpetable1);
                    component.set("v.isNotAccpetable1",isNotAccpetable1);
                    component.set("v.isAccpetable2",isAccpetable2);
                    component.set("v.isNotAccpetable2",isNotAccpetable2);
                    component.set("v.isAccpetable3",isAccpetable3);
                    component.set("v.isNotAccpetable3",isNotAccpetable3);
                }
                else if(BudgetedASP > 0){
                    var isAccpetable= ((BudgetedASP/100)*10 + BudgetedASP) < dirDeadnet ? true : false;
                    var isNotAccpetable= (BudgetedASP - (BudgetedASP/100)*10) < dirDeadnet ? true : false;
                    var isAccpetable1= ((BudgetedASP/100)*10 + BudgetedASP) < indDeadNet ? true : false;
                    var isNotAccpetable1= (BudgetedASP - (BudgetedASP/100)*10) < indDeadNet ? true : false;
                    var isAccpetable2= ((BudgetedASP/100)*10 + BudgetedASP) < cardDeadNet ? true : false;
                    var isNotAccpetable2= (BudgetedASP - (BudgetedASP/100)*10) < cardDeadNet ? true : false;
                    var isAccpetable3= ((BudgetedASP/100)*10 + BudgetedASP) < majorDeadNet ? true : false;
                    var isNotAccpetable3= (BudgetedASP - (BudgetedASP/100)*10) < majorDeadNet ? true : false;
                    component.set("v.isAccpetable",isAccpetable);
                    component.set("v.isNotAccpetable",isNotAccpetable);
                    component.set("v.isAccpetable1",isAccpetable1);
                    component.set("v.isNotAccpetable1",isNotAccpetable1);
                    component.set("v.isAccpetable2",isAccpetable2);
                    component.set("v.isNotAccpetable2",isNotAccpetable2);
                    component.set("v.isAccpetable3",isAccpetable3);
                    component.set("v.isNotAccpetable3",isNotAccpetable3);
                }else{
                    console.log('else condition--->')
                    component.set("v.isAccpetable",false);
                    component.set("v.isNotAccpetable",false);
                    component.set("v.isAccpetable1",false);
                    component.set("v.isNotAccpetable1",false);
                    component.set("v.isAccpetable2",false);
                    component.set("v.isNotAccpetable2",false);
                    component.set("v.isAccpetable3",false);
                    component.set("v.isNotAccpetable3",false);
                }						
                component.set("v.isSpinner",false);
                /*var action = component.get("c.getUpdatedLineItemRec");
                action.setParams({
                    lineItemId : component.get("v.singleRec").Id
                });
                action.setCallback(this, function(response){
                    console.log('response.getState() from getUpdatedLineItemRec  -- '+response.getState());
                    if(response.getState()==='SUCCESS'){
                        component.set("v.singleRec",response.getReturnValue());
                        
                    }
                });      
                $A.enqueueAction(action); */
                var event = component.getEvent("calcEvent");
                event.fire();
            }
            if(response.getState()==='ERROR'){
                var errorMsg = action.getError()[0].message;
                console.log(errorMsg);
                component.set("v.isSpinner",false);
            }
        });      
        $A.enqueueAction(action);
    },
    getPositions: function (component, event, helper, customerRecId) {
        var action = component.get("c.getPositions");
        action.setParams({
            customerID: customerRecId
        });
        action.setCallback(this, function (response) {
            if (response.getState() === "SUCCESS") {
                var responseList = response.getReturnValue();
                console.log('---responseList---' + responseList.length);
                //below code is for remove seleceted while fetch contracts in table
                var slctpositions;
                if (component.get('v.singleRec.Phoenix_Proposed_Position__c') != null) {
                    slctpositions = component.get('v.singleRec.Phoenix_Proposed_Position__c').split(',');
                    console.log('slctpositions--' + slctpositions);
                }
                for (var i = 0; i < responseList.length; i++) {
                    var row = responseList[i];
                    if (row.Phoenix_Customer__c) {
                        row.Phoenix_Customer__c = row.Phoenix_Customer__r.Name;
                    }
                }
                component.set("v.LinepositionsList", responseList);
                component.set("v.isSpinner",false);
            }
        });
        $A.enqueueAction(action);
    },
    getCardinalPositions: function (component, event, helper, customerRecId) {
        var action = component.get("c.getPositions");
        action.setParams({
            customerID: customerRecId
        });
        action.setCallback(this, function (response) {
            if (response.getState() === "SUCCESS") {
                var responseList = response.getReturnValue();
                console.log('---responseList---' + responseList.length);
                //below code is for remove seleceted while fetch contracts in table
                var slctpositions;
                if (component.get('v.singleRec.Phoenix_Proposed_Cardinal_Position__c') != null) {
                    slctpositions = component.get('v.childRec.Phoenix_Proposed_Cardinal_Position__c').split(',');
                    console.log('slctpositions--' + slctpositions);
                }
                for (var i = 0; i < responseList.length; i++) {
                    var row = responseList[i];
                    if (row.Phoenix_Customer__c) {
                        row.Phoenix_Customer__c = row.Phoenix_Customer__r.Name;
                    }
                }
                component.set("v.LineCardinalpositionsList", responseList);
                component.set("v.isSpinner",false);
            }
        });
        $A.enqueueAction(action);
    },
    getMajorPositions: function (component, event, helper, customerRecId) {
        var action = component.get("c.getPositions");
        action.setParams({
            customerID: customerRecId
        });
        action.setCallback(this, function (response) {
            if (response.getState() === "SUCCESS") {
                var responseList = response.getReturnValue();
                console.log('---responseList---' + responseList.length);
                //below code is for remove seleceted while fetch contracts in table
                var slctpositions;
                if (component.get('v.singleRec.Phoenix_Proposed_Position__c') != null) {
                    slctpositions = component.get('v.singleRec.Phoenix_Proposed_Position__c').split(',');
                    console.log('slctpositions--' + slctpositions);
                }
                for (var i = 0; i < responseList.length; i++) {
                    var row = responseList[i];
                    if (row.Phoenix_Customer__c) {
                        row.Phoenix_Customer__c = row.Phoenix_Customer__r.Name;
                    }
                }
                component.set("v.LineMajorpositionsList", responseList);
                component.set("v.isSpinner",false);
            }
        });
        $A.enqueueAction(action);
    }
})