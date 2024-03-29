({
	getAllTotalsforIndividual : function(component,event,helper) {
        var action = component.get("c.getAllTotalsforIndividual");
        action.setParams({
            "salesTerritory":component.get("v.selectedUserId"),
            "userRegion":component.get("v.userRegion"),
            "userCategory":component.get("v.selectedCategory"),
            "hospitalName" : component.get("v.hospitalName"),
            "child1Name" : component.get("v.child1Name"),
             "child2Name" : component.get("v.record.child2Name"),
            "productFamily" : component.get("v.selectedProductFamilies"),
            "productDescription":component.get("v.selectedProducts"),
            "accountId":component.get("v.selectedaccountId"),
            "contractDescription":component.get("v.selectedContractDesc"),
            "selectedMemberCity" :component.get("v.selectedMemberCity"),
            "selectedMemberState" :component.get("v.selectedMemberState"),
            "submitterName" :component.get("v.selectedSubmitterName"),
        });
         action.setCallback(this,function(response){
              console.log("response state hir2"+response.getState());
             if(response.getState() == 'SUCCESS'){
                 	var totalsResponse = response.getReturnValue();
                 console.log("totalsResponse cmp2 hir2???"+JSON.stringify(totalsResponse));
                 console.log("sales price cmp2 hir2???==>"+Math.round(totalsResponse[0].salesPrice));
                 console.log("units cmp2 hir2???==>"+totalsResponse[0].units);
                 component.set("v.twmonthsSalesTotal",Math.round(((totalsResponse[0].salesPrice) + Number.EPSILON) * 100) / 100)//Math.round(totalsResponse[0].salesPrice)
                  component.set("v.twmonthsUnitsTotal",totalsResponse[0].units)
                   /*for comparision Sales*/
                  var total12monthsales = component.get("v.twmonthsSalesTotal")
                  console.log('total12monthsales===??'+component.get("v.twmonthsSalesTotal"));
                 var current6monthsales = component.get("v.totalofSalesSummary")
                 console.log('current6monthsales===??'+current6monthsales);
                 var prev6monthsSales = component.get("v.twmonthsSalesTotal") - component.get("v.totalofSalesSummary") ;
                 console.log('prev6monthsSales===??'+prev6monthsSales);
                 var isValue = total12monthsales != null ? true : false;
                 console.log('isValue===>'+isValue);
                 component.set("v.isValue",isValue);
                 component.set("v.prev6monthsSales",prev6monthsSales)
        			var salesPercentage = prev6monthsSales != 0 ? (( current6monthsales - prev6monthsSales )/prev6monthsSales) *100 : 0;
                 if(salesPercentage >0){
                     component.set("v.showColor",true)
                 }else{
                     component.set("v.showColor",false)
                 }
                 console.log('showColor===>'+component.get("v.showColor"));
                 /*end for comparision Sales*/
                 /*for comparision Units*/
                  var total12monthunits = component.get("v.twmonthsUnitsTotal")
                 var current6monthunits = component.get("v.totalofUnitsSummary")
                 var prev6monthsUnits = component.get("v.twmonthsUnitsTotal") - component.get("v.totalofUnitsSummary") ;
                 console.log('prev6monthsUnits===??'+prev6monthsUnits);
                 var isUnitsValue = total12monthunits != null ? true : false;
                 component.set("v.isUnitsValue",isUnitsValue);
                 component.set("v.prev6monthsUnits",prev6monthsUnits)
        			var unitsPercentage = prev6monthsUnits != 0 ? (( current6monthunits - prev6monthsUnits )/prev6monthsUnits) *100 : 0;
                 if(unitsPercentage >0){
                     component.set("v.showColorUnits",true)
                 }else{
                     component.set("v.showColorUnits",false)
                 }
                 console.log('showColorUnits===>'+component.get("v.showColorUnits"));
                 /*end for comparision Units*/
                 component.set("v.isSpinnerLoad", false);
             }else{
                               console.log('Error'+JSON.stringify(response.getError())); 
                                 component.set("v.isSpinnerLoad", false);
                            }
         });
         $A.enqueueAction(action);
	},
})