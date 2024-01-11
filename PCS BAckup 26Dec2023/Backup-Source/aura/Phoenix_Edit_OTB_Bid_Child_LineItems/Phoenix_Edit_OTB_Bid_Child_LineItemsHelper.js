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
                                       var otbDirIndir=component.get("v.otbDirIndirect");
        console.log('----------otbDirIndir-----'+otbDirIndir);
        if(otbDirIndir=='Indirect'){
            component.set("v.singleRec.Phoenix_ProposedContractBidPriceMktng__c",null);
            component.set("v.singleRec.Phoenix_ProposedContract_Bid_Price_Sales__c",null);
            component.set("v.singleRec.Phoenix_Proposed_Direct_Selling_Unit__c",null);
            component.set("v.CDSUTotal",null);
            
        }
        else  if(otbDirIndir=='Direct'){
            component.set("v.singleRec.Phoenix_Wholesaler_Diff_Price_Indirect__c",null);
            component.set("v.singleRec.Phoenix_Wholesaler_Sales_Price__c",null);
            component.set("v.singleRec.Phoenix_Proposed_Indirect_Selling_Unit__c",null);
            component.set("v.CISUTotal",null);
        }
            else{
              //  
            }
        // component.set("v.isSpinner",true);
        console.log('currentValue'+currentValue);
        console.log('currentValue'+currentValue);
        console.log('currentValue'+currentValue);
        console.log('currentValue'+currentValue);
        
        var LineItem=component.get("v.singleRec");
        var bidType=component.get("v.bidType");
        var LineItemId=LineItem.Id;
        var WAC = LineItem.Phoenix_WAC__c;
        var proposedPriceSales = LineItem.Phoenix_ProposedContract_Bid_Price_Sales__c;
        var proposedPriceMarketing = LineItem.Phoenix_ProposedContractBidPriceMktng__c;
        var diffPriceIndirect=LineItem.Phoenix_Wholesaler_Sales_Price__c;
         var diffPriceIndirectMkg=LineItem.Phoenix_Wholesaler_Diff_Price_Indirect__c;
        console.log('--------LineItemId---1-------'+LineItemId.Phoenix_ProposedContract_Bid_Price_Sales__c);
         console.log('-------otbDirIndir-----'+otbDirIndir);
          var msg= isMarketingPrice ? 'Marketing Price can not be greater than WAC ($'+LineItem.Phoenix_WAC__c+')' : isSalesPrice ? 'Sales Price can not be greater than WAC ($'+LineItem.Phoenix_WAC__c+')' : ''; 
        if((WAC < proposedPriceSales || WAC < proposedPriceMarketing) && !isGuidancePrice){
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
                component.set("v.singleRec.Phoenix_ProposedContractBidPriceMktng__c", null)   
            
       
        
       
                var action = component.get("c.getCalcs");
            action.setParams({
                LineItem: LineItem,
                LineItemId: LineItemId,
                currentValue: currentValue,
                fieldLabel : fieldName,
                otbDirectIndir :otbDirIndir
            });
            action.setCallback(this, function(response) 
                               {
                                   if(response.getState()==='SUCCESS'){
                                       console.log('calc response--'+JSON.stringify(response.getReturnValue()));
                                       component.set("v.singleRec",response.getReturnValue());
                                       var latestEstimate = component.get("v.singleRec.Phoenix_Latest_Estimate__c") != null ? component.get("v.singleRec.Phoenix_Latest_Estimate__c") : 0;
                                       var BudgetedASP = component.get("v.singleRec.Phoenix_Budgeted_ASP1__c") != null ? component.get("v.singleRec.Phoenix_Budgeted_ASP1__c") : 0;
                                      /* var directDeadnet = component.get("v.singleRec.Phoenix_Direct_Dead_Net__c") != null ? component.get("v.singleRec.Phoenix_Direct_Dead_Net__c") : 0;
                                       if(latestEstimate > 0){
                                           var isAccpetable= ((latestEstimate/100)*10 + latestEstimate) < directDeadnet ? true : false;
                                           var isNotAccpetable= (latestEstimate - (latestEstimate/100)*10) < directDeadnet ? true : false;
                                           component.set("v.isAccpetable",isAccpetable);
                                           component.set("v.isNotAccpetable",isNotAccpetable);
                                       }
                                       else if(BudgetedASP > 0){
                                           var isAccpetable= ((BudgetedASP/100)*10 + BudgetedASP) < directDeadnet ? true : false;
                                           var isNotAccpetable= (BudgetedASP - (BudgetedASP/100)*10) < directDeadnet ? true : false;
                                           component.set("v.isAccpetable",isAccpetable);
                                           component.set("v.isNotAccpetable",isNotAccpetable);
                                       }else{
                                           console.log('else condition--->')
                                           component.set("v.isAccpetable",false);
                                           component.set("v.isNotAccpetable",false);
                                       }*/
                              
                                       var directDeadnet = component.get("v.singleRec.Phoenix_Direct_Dead_Net__c") != null ? component.get("v.singleRec.Phoenix_Direct_Dead_Net__c") : 0;
                                       var indirectDeadnet = component.get("v.singleRec.Phoenix_Indirect_Dead_Net__c") != null ? component.get("v.singleRec.Phoenix_Indirect_Dead_Net__c") : 0;
                                       directDeadnet = (Math.round(directDeadnet * 100) / 100).toFixed(2);
                                       indirectDeadnet = (Math.round(indirectDeadnet * 100) / 100).toFixed(2);
                                       component.set("v.directDeadnet",directDeadnet);
                                       component.set("v.indirectDeadnet",indirectDeadnet);
                                       if(otbDirIndir=='Direct'){
                                           
                                           if(latestEstimate > 0){
                                               var isAccpetable= ((latestEstimate/100)*10 + latestEstimate) < directDeadnet ? true : false;
                                               var isNotAccpetable= (latestEstimate - (latestEstimate/100)*10) < directDeadnet ? true : false;
                                               component.set("v.isAccpetable",isAccpetable);
                                               component.set("v.isNotAccpetable",isNotAccpetable)
                                           }
                                           else if(BudgetedASP > 0){
                                               var isAccpetable= ((BudgetedASP/100)*10 + BudgetedASP) < directDeadnet ? true : false;
                                               var isNotAccpetable= (BudgetedASP - (BudgetedASP/100)*10) < directDeadnet ? true : false;
                                               component.set("v.isAccpetable",isAccpetable);
                                               component.set("v.isNotAccpetable",isNotAccpetable)
                                           }else{
                                               console.log('else condition--->')
                                               component.set("v.isAccpetable",false);
                                               component.set("v.isNotAccpetable",false);
                                           }     
                                           
                                           
                                       }
                                       else if(otbDirIndir=='Indirect'){
                                           
                                           if(latestEstimate > 0){
                                               var isAccpetable= ((latestEstimate/100)*10 + latestEstimate) < indirectDeadnet ? true : false;
                                               var isNotAccpetable= (latestEstimate - (latestEstimate/100)*10) < indirectDeadnet ? true : false;
                                               component.set("v.isIndirAccpetable",isAccpetable);
                                               component.set("v.isIndirNotAccpetable",isNotAccpetable)
                                           }
                                           else if(BudgetedASP > 0){
                                               var isAccpetable= ((BudgetedASP/100)*10 + BudgetedASP) < indirectDeadnet ? true : false;
                                               var isNotAccpetable= (BudgetedASP - (BudgetedASP/100)*10) < indirectDeadnet ? true : false;
                                               component.set("v.isIndirAccpetable",isAccpetable);
                                               component.set("v.isIndirNotAccpetable",isNotAccpetable)
                                           }else{
                                               console.log('else condition--->')
                                               component.set("v.isIndirAccpetable",false);
                                               component.set("v.isIndirNotAccpetable",false);
                                           }     
                                           
                                       }
                                           else{
                                               
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
         else if(WAC<diffPriceIndirect){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type":"Error",
                "title": "Error",
                "message": 'Sales Price can not be greater than WAC ($'+LineItem.Phoenix_WAC__c+')'
            });
            toastEvent.fire();
            component.set("v.singleRec.Phoenix_Wholesaler_Sales_Price__c", null);
        }
        else if(WAC<diffPriceIndirectMkg){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type":"Error",
                "title": "Error",
                "message": 'Marketing Price can not be greater than WAC ($'+LineItem.Phoenix_WAC__c+')'
            });
            toastEvent.fire();
            component.set("v.singleRec.Phoenix_Wholesaler_Diff_Price_Indirect__c", null);
        }
            else if(diffPriceIndirect<proposedPriceMarketing && bidType!='Volume Review Only' && diffPriceIndirect!=null){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type":"Error",
                "title": "Error",
                "message": 'Wholesaler Diff Price can not be less than Marketing Price'
            });
            toastEvent.fire();
            component.set("v.singleRec.Phoenix_Wholesaler_Diff_Price_Indirect__c", null);
        }
            else{
                var action = component.get("c.getCalcs");
                action.setParams({
                    LineItem: LineItem,
                    LineItemId: LineItemId,
                    currentValue: currentValue,
                   fieldLabel : fieldName,
                otbDirectIndir :otbDirIndir
                });
                action.setCallback(this, function(response) 
                                   {
                                       if(response.getState()==='SUCCESS'){
                                           console.log('calc response--'+JSON.stringify(response.getReturnValue()));
                                           component.set("v.singleRec",response.getReturnValue());
                                           var event = component.getEvent("calcEvent");
                                           var latestEstimate = component.get("v.singleRec.Phoenix_Latest_Estimate__c") != null ? component.get("v.singleRec.Phoenix_Latest_Estimate__c") : 0;
                                           var BudgetedASP = component.get("v.singleRec.Phoenix_Budgeted_ASP1__c") != null ? component.get("v.singleRec.Phoenix_Budgeted_ASP1__c") : 0;
                                           var directDeadnet = component.get("v.singleRec.Phoenix_Direct_Dead_Net__c") != null ? component.get("v.singleRec.Phoenix_Direct_Dead_Net__c") : 0;
                                           var indirectDeadnet = component.get("v.singleRec.Phoenix_Indirect_Dead_Net__c") != null ? component.get("v.singleRec.Phoenix_Indirect_Dead_Net__c") : 0;
                                           var otbDirIndir=component.get("v.otbDirIndirect");
                                           if(otbDirIndir=='Direct'){
                                               if(latestEstimate > 0){
                                                   var isAccpetable= ((latestEstimate/100)*10 + latestEstimate) < directDeadnet ? true : false;
                                                   var isNotAccpetable= (latestEstimate - (latestEstimate/100)*10) < directDeadnet ? true : false;
                                                   component.set("v.isAccpetable",isAccpetable);
                                                   component.set("v.isNotAccpetable",isNotAccpetable)
                                               }
                                               else if(BudgetedASP > 0){
                                                   var isAccpetable= ((BudgetedASP/100)*10 + BudgetedASP) < directDeadnet ? true : false;
                                                   var isNotAccpetable= (BudgetedASP - (BudgetedASP/100)*10) < directDeadnet ? true : false;
                                                   component.set("v.isAccpetable",isAccpetable);
                                                   component.set("v.isNotAccpetable",isNotAccpetable)
                                               }else{
                                                   console.log('else condition--->')
                                                   component.set("v.isAccpetable",false);
                                                   component.set("v.isNotAccpetable",false);
                                               }     
                                               
                                               
                                           }
                                           else if(otbDirIndir=='Indirect'){
                                               
                                               if(latestEstimate > 0){
                                                   var isAccpetable= ((latestEstimate/100)*10 + latestEstimate) < indirectDeadnet ? true : false;
                                                   var isNotAccpetable= (latestEstimate - (latestEstimate/100)*10) < indirectDeadnet ? true : false;
                                                   component.set("v.isIndirAccpetable",isAccpetable);
                                                   component.set("v.isIndirNotAccpetable",isNotAccpetable)
                                               }
                                               else if(BudgetedASP > 0){
                                                   var isAccpetable= ((BudgetedASP/100)*10 + BudgetedASP) < indirectDeadnet ? true : false;
                                                   var isNotAccpetable= (BudgetedASP - (BudgetedASP/100)*10) < indirectDeadnet ? true : false;
                                                   component.set("v.isIndirAccpetable",isAccpetable);
                                                   component.set("v.isIndirNotAccpetable",isNotAccpetable)
                                               }else{
                                                   console.log('else condition--->')
                                                   component.set("v.isIndirAccpetable",false);
                                                   component.set("v.isIndirNotAccpetable",false);
                                               }     
                                               
                                           }
                                               else{
                                                   
                                               } 
                                           
                                           
                                           
                                           event.fire();
                                           //component.set("v.isSpinner",false);
                                       } else{
                                           //component.set("v.isSpinner",false);
                                       }
                                       
                                   });      
                $A.enqueueAction(action);
            }
    }
    
})