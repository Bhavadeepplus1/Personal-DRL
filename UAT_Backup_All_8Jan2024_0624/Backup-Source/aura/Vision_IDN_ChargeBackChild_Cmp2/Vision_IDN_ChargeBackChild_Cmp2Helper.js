({
	 getAllTotalsforIndividual : function(component,event,helper) {
		console.log('in get all totals child')
        var action = component.get("c.getAllTotalsforIndividual");
        console.log('salesTerritory==>'+component.get("v.selectedUserId"));
         console.log('userRegion==>'+component.get("v.userRegion"));
          console.log('userCategory==>'+component.get("v.userCategory")),
              console.log('hospitalList==>'+component.get("v.hospitalList")),
        console.log('child1Name'+component.get("v.record.child1"));
        console.log('child2Name'+component.get("v.child2Name"));
        console.log('productFamily'+component.get("v.productFamily"));
         console.log('productDescription'+component.get("v.productDescription"));
        console.log('contractDescription'+component.get("v.selectedContractDesc"));
        console.log('selectedMemberCity'+component.get("v.selectedMemberCity"));
        console.log('selectedMemberState'+component.get("v.selectedMemberState"));
        console.log('submitterName'+component.get("v.submitterName"));
        action.setParams({
            "salesTerritory":component.get("v.selectedUserId"),
            "userRegion":component.get("v.userRegion"),
            "userCategory":component.get("v.selectedCategory"),
            "hospitalName" : component.get("v.hospital"),
            "child1Name" : component.get("v.record.child1"),
             "child2Name" : component.get("v.child2Name"),
            "productFamily" : component.get("v.selectedProductFamilies"),
            "productDescription":component.get("v.selectedProducts"),
            "accountId":component.get("v.selectedaccountId"),
            "contractDescription":component.get("v.selectedContractDesc"),
            "selectedMemberCity" :component.get("v.selectedMemberCity"),
            "selectedMemberState" :component.get("v.selectedMemberState"),
            "submitterName" :component.get("v.selectedSubmitterName"),
        });
         action.setCallback(this,function(response){
              console.log("response state"+response.getState());
             if(response.getState() == 'SUCCESS'){
                 	var totalsResponse = response.getReturnValue();
                 console.log("totalsResponse!!!"+JSON.stringify(totalsResponse));
                 console.log("sales price!!!==>"+Math.round(totalsResponse[0].salesPrice));
                 console.log("units!!!==>"+totalsResponse[0].units);
                 component.set("v.twmonthsSalesTotal",Math.round(((totalsResponse[0].salesPrice) + Number.EPSILON ) * 100) / 100)//Math.round(totalsResponse[0].salesPrice))
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
                 /*end for comparision Sales*/
                 component.set("v.isSpinnerLoad", false);
             }else{
                               console.log('Error'+JSON.stringify(response.getError())); 
                                 component.set("v.isSpinnerLoad", false);
                            }
         });
         $A.enqueueAction(action);
	},
})