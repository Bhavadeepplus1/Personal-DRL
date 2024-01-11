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
    getCalculations : function(component,event,helper, currentValue, fieldName,isGuidancePrice,isSalesMckPrice,isWMTSalesPrice,isWMTDirectPrice,isWMTindirectPrice,isMacRADOSPrice,isGoalseekFired){  
        var LineItem=component.get("v.singleRec");
        var bidType=component.get("v.bidType");
        var LineItemId=LineItem.Id;
        var WAC = LineItem.Phoenix_WAC__c;
        var proposedMckSalesPrice = LineItem.Phoenix_Sales_Proposed_NCP_McK_And_RAD__c;
        var proposedWMTSalesPrice = LineItem.Phoenix_ProposedContract_Bid_Price_Sales__c;
        var proposedWMTDirectPrice = (LineItem.Phoenix_Proposed_WMT_Direct_NCP__c != null ? LineItem.Phoenix_Proposed_WMT_Direct_NCP__c : 0) ;
        var proposedWMTIndirectPrice = (LineItem.Phoenix_Proposed_WMT_Indirect_NCP__c != null ? LineItem.Phoenix_Proposed_WMT_Indirect_NCP__c : LineItem.Phoenix_Proposed_WMT_Direct_NCP__c);
        var proposedMckOSRADProce =LineItem.Phoenix_Proposed_McK_OS_And_RAD_NCP__c;
        var msg= isWMTDirectPrice ? 'WMT Direct Price can not be greater than WAC ($'+LineItem.Phoenix_WAC__c+')' : isWMTindirectPrice ? 'WMT Indirect Price can not be greater than WAC ($'+LineItem.Phoenix_WAC__c+')' : isMacRADOSPrice ?  'Mack OS RAD Price can not be greater than WAC ($'+LineItem.Phoenix_WAC__c+')' : isSalesMckPrice ? 'Mck Sales Price can not be greater than WAC ($'+LineItem.Phoenix_WAC__c+')': isWMTSalesPrice ? 'WMT Sales Price can not be greater than WAC ($'+LineItem.Phoenix_WAC__c+')': ''; 
        var priceError='WMT Indirect cannot be less than direct price for '+LineItem.Phoenix_Product__r.Name;
        if((proposedWMTDirectPrice > proposedWMTIndirectPrice ||  WAC < proposedMckSalesPrice  || WAC < proposedWMTSalesPrice  || WAC < proposedWMTDirectPrice || WAC < proposedWMTIndirectPrice || WAC<proposedMckOSRADProce || isGoalseekFired) && WAC != 0 && WAC != undefined && !isGuidancePrice){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type":"Error",
                "title": "Error",
                "message": ((proposedWMTDirectPrice > proposedWMTIndirectPrice) || isGoalseekFired) ? priceError: msg
            });
            toastEvent.fire();
            if(WAC < proposedWMTDirectPrice)
            	component.set("v.singleRec.Phoenix_Proposed_WMT_Direct_NCP__c", null);
            if(WAC < proposedWMTIndirectPrice)
                component.set("v.singleRec.Phoenix_Proposed_WMT_Indirect_NCP__c", null)
            if(WAC < proposedMckOSRADProce)
                component.set("v.singleRec.Phoenix_Proposed_McK_OS_And_RAD_NCP__c", null)
            if(WAC < proposedMckSalesPrice)
                component.set("v.singleRec.Phoenix_Sales_Proposed_NCP_McK_And_RAD__c", null)
            if(WAC < proposedWMTSalesPrice)
                component.set("v.singleRec.Phoenix_ProposedContract_Bid_Price_Sales__c", null)
            if(proposedWMTDirectPrice > proposedWMTIndirectPrice && isWMTDirectPrice){
                 component.set("v.singleRec.Phoenix_Proposed_WMT_Direct_NCP__c", null)   
             }
            if(proposedWMTDirectPrice > proposedWMTIndirectPrice && isWMTindirectPrice){
                 component.set("v.singleRec.Phoenix_Proposed_WMT_Indirect_NCP__c", null)   
             }
            
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
                                       var latestEstimate = component.get("v.singleRec.Phoenix_Latest_Estimate__c") != null ? component.get("v.singleRec.Phoenix_Latest_Estimate__c") : 0;
                                       var BudgetedASP = component.get("v.singleRec.Phoenix_Budgeted_ASP1__c") != null ? component.get("v.singleRec.Phoenix_Budgeted_ASP1__c") : 0;
                                       var WMTDirDeadnet = component.get("v.singleRec.Phoenix_WMT_Direct_Dead_Net_Proposed__c") != null ? component.get("v.singleRec.Phoenix_WMT_Direct_Dead_Net_Proposed__c") : 0;
                                       var WMTInDirDeadnet = component.get("v.singleRec.Phoenix_Current_Retail_Indirect_Price__c") != null ? component.get("v.singleRec.Phoenix_Current_Retail_Indirect_Price__c") : 0;
                                       var MckOSDeadnet = component.get("v.singleRec.Phoenix_Direct_Dead_Net__c") != null ? component.get("v.singleRec.Phoenix_Direct_Dead_Net__c") : 0;
                                       WMTDirDeadnet = (Math.round(WMTDirDeadnet * 100) / 100).toFixed(2);
                                       WMTInDirDeadnet = (Math.round(WMTInDirDeadnet * 100) / 100).toFixed(2);
                                       MckOSDeadnet = (Math.round(MckOSDeadnet * 100) / 100).toFixed(2);
                                       component.set("v.WMTDirDeadnet",WMTDirDeadnet);
                                       component.set("v.WMTInDirDeadnet",WMTInDirDeadnet);
                                       component.set("v.MckOSDeadnet",MckOSDeadnet);
        
                                       if(latestEstimate > 0){
                                           var isAccpetable= ((latestEstimate/100)*10 + latestEstimate) < WMTDirDeadnet ? true : false;
                                           var isNotAccpetable= (latestEstimate - (latestEstimate/100)*10) < WMTDirDeadnet ? true : false;
                                           var isAccpetable1= ((latestEstimate/100)*10 + latestEstimate) < WMTInDirDeadnet ? true : false;
                                           var isNotAccpetable1= (latestEstimate - (latestEstimate/100)*10) < WMTInDirDeadnet ? true : false;
                                           var isAccpetable2= ((latestEstimate/100)*10 + latestEstimate) < MckOSDeadnet ? true : false;
                                           var isNotAccpetable2= (latestEstimate - (latestEstimate/100)*10) < MckOSDeadnet ? true : false;
                                           component.set("v.isAccpetable",isAccpetable);
                                           component.set("v.isNotAccpetable",isNotAccpetable);
                                           component.set("v.isAccpetableWMTIndir",isAccpetable1);
                                           component.set("v.isNotAccpetableWMTIndir",isNotAccpetable1);
                                           component.set("v.isAccpetableMakOs",isAccpetable2);
                                           component.set("v.isNotAccpetableMakOs",isNotAccpetable2);
                                       }
                                       else if(BudgetedASP > 0){
                                           var isAccpetable= ((BudgetedASP/100)*10 + BudgetedASP) < WMTDirDeadnet ? true : false;
                                           var isNotAccpetable= (BudgetedASP - (BudgetedASP/100)*10) < WMTDirDeadnet ? true : false;
                                           var isAccpetable1= ((BudgetedASP/100)*10 + BudgetedASP) < WMTInDirDeadnet ? true : false;
                                           var isNotAccpetable1= (BudgetedASP - (BudgetedASP/100)*10) < WMTInDirDeadnet ? true : false;
                                           var isAccpetable2= ((BudgetedASP/100)*10 + BudgetedASP) < MckOSDeadnet ? true : false;
                                           var isNotAccpetable2= (BudgetedASP - (BudgetedASP/100)*10) < MckOSDeadnet ? true : false;
                                           component.set("v.isAccpetable",isAccpetable);
                                           component.set("v.isNotAccpetable",isNotAccpetable);
                                           component.set("v.isAccpetableWMTIndir",isAccpetable1);
                                           component.set("v.isNotAccpetableWMTIndir",isNotAccpetable1);
                                           component.set("v.isAccpetableMakOs",isAccpetable2);
                                           component.set("v.isNotAccpetableMakOs",isNotAccpetable2);
                                       }else{
                                           console.log('else condition--->')
                                           component.set("v.isAccpetable",false);
                                           component.set("v.isNotAccpetable",false);
                                           component.set("v.isAccpetableWMTIndir",false);
                                           component.set("v.isNotAccpetableWMTIndir",false);
                                           component.set("v.isAccpetableMakOs",false);
                                           component.set("v.isNotAccpetableMakOs",false);
                                       }
                                       
                                       var event = component.getEvent("calcEvent");                                 
                                       event.fire();
                                       //component.set("v.isSpinner",false);
                                   } else{
                                       //component.set("v.isSpinner",false);
                                   }
                                   
                               });      
            $A.enqueueAction(action);
        }
       
            var action = component.get("c.getCalcs");
        console.log("currentValue in helper-->"+currentValue)
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
                                       var WMTDirDeadnet = component.get("v.singleRec.Phoenix_WMT_Direct_Dead_Net_Proposed__c") != null ? component.get("v.singleRec.Phoenix_WMT_Direct_Dead_Net_Proposed__c") : 0;
                                       var WMTInDirDeadnet = component.get("v.singleRec.Phoenix_Current_Retail_Indirect_Price__c") != null ? component.get("v.singleRec.Phoenix_Current_Retail_Indirect_Price__c") : 0;
                                       var MckOSDeadnet = component.get("v.singleRec.Phoenix_Direct_Dead_Net__c") != null ? component.get("v.singleRec.Phoenix_Direct_Dead_Net__c") : 0;
                                       WMTDirDeadnet = (Math.round(WMTDirDeadnet * 100) / 100).toFixed(2);
                                       WMTInDirDeadnet = (Math.round(WMTInDirDeadnet * 100) / 100).toFixed(2);
                                       MckOSDeadnet = (Math.round(MckOSDeadnet * 100) / 100).toFixed(2);
                                       component.set("v.WMTDirDeadnet",WMTDirDeadnet);
                                       component.set("v.WMTInDirDeadnet",WMTInDirDeadnet);
                                       component.set("v.MckOSDeadnet",MckOSDeadnet);
                                       if(latestEstimate > 0){
                                           var isAccpetable= ((latestEstimate/100)*10 + latestEstimate) < WMTDirDeadnet ? true : false;
                                           var isNotAccpetable= (latestEstimate - (latestEstimate/100)*10) < WMTDirDeadnet ? true : false;
                                           var isAccpetable1= ((latestEstimate/100)*10 + latestEstimate) < WMTInDirDeadnet ? true : false;
                                           var isNotAccpetable1= (latestEstimate - (latestEstimate/100)*10) < WMTInDirDeadnet ? true : false;
                                           var isAccpetable2= ((latestEstimate/100)*10 + latestEstimate) < MckOSDeadnet ? true : false;
                                           var isNotAccpetable2= (latestEstimate - (latestEstimate/100)*10) < MckOSDeadnet ? true : false;
                                           component.set("v.isAccpetable",isAccpetable);
                                           component.set("v.isNotAccpetable",isNotAccpetable);
                                           component.set("v.isAccpetableWMTIndir",isAccpetable1);
                                           component.set("v.isNotAccpetableWMTIndir",isNotAccpetable1);
                                           component.set("v.isAccpetableMakOs",isAccpetable2);
                                           component.set("v.isNotAccpetableMakOs",isNotAccpetable2);
                                       }
                                       else if(BudgetedASP > 0){
                                           var isAccpetable= ((BudgetedASP/100)*10 + BudgetedASP) < WMTDirDeadnet ? true : false;
                                           var isNotAccpetable= (BudgetedASP - (BudgetedASP/100)*10) < WMTDirDeadnet ? true : false;
                                           var isAccpetable1= ((BudgetedASP/100)*10 + BudgetedASP) < WMTInDirDeadnet ? true : false;
                                           var isNotAccpetable1= (BudgetedASP - (BudgetedASP/100)*10) < WMTInDirDeadnet ? true : false;
                                           var isAccpetable2= ((BudgetedASP/100)*10 + BudgetedASP) < MckOSDeadnet ? true : false;
                                           var isNotAccpetable2= (BudgetedASP - (BudgetedASP/100)*10) < MckOSDeadnet ? true : false;
                                           component.set("v.isAccpetable",isAccpetable);
                                           component.set("v.isNotAccpetable",isNotAccpetable);
                                           component.set("v.isAccpetableWMTIndir",isAccpetable1);
                                           component.set("v.isNotAccpetableWMTIndir",isNotAccpetable1);
                                           component.set("v.isAccpetableMakOs",isAccpetable2);
                                           component.set("v.isNotAccpetableMakOs",isNotAccpetable2);
                                       }else{
                                           console.log('else condition--->')
                                           component.set("v.isAccpetable",false);
                                           component.set("v.isNotAccpetable",false);
                                           component.set("v.isAccpetableWMTIndir",false);
                                           component.set("v.isNotAccpetableWMTIndir",false);
                                           component.set("v.isAccpetableMakOs",false);
                                           component.set("v.isNotAccpetableMakOs",false);
                                       }
                                       event.fire();
                                       //component.set("v.isSpinner",false);
                                   } else{
                                       //component.set("v.isSpinner",false);
                                   }
                                   
                               });      
            $A.enqueueAction(action);
        
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
    },
      getMCKPositions: function (component, event, helper, customerRecId) {
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
                if (component.get('v.singleRec.Phoenix_Current_Position__c') != null) {
                    slctpositions = component.get('v.singleRec.Phoenix_Current_Position__c').split(',');
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
                component.set("v.MCKLinepositionsList", responseList);

            }


        });
        $A.enqueueAction(action);
    }


})