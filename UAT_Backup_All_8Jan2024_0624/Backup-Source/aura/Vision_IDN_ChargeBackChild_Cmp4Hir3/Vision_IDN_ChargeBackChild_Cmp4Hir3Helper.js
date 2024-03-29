({
    getAllTotalsforIndividual : function(component,event,helper) {
        console.log('in cpm 4 get all totals')
        console.log("salesTerritory==>"+component.get("v.selectedUserId"))
        console.log("userRegion==>"+component.get("v.userRegion"))
        console.log("userCategory==>"+component.get("v.selectedCategory"))
        console.log("contractDescName==>"+component.get("v.contractDescName"))
        console.log("hospitalName==>"+component.get("v.hospitalName"))
        console.log("child1Name==>"+component.get("v.child1Name"))
        var action = component.get("c.getAllTotalsforIndividual");
        action.setParams({
             "salesTerritory":component.get("v.selectedUserId"),
            "userRegion":component.get("v.userRegion"),
            "userCategory": component.get("v.selectedCategory"),
            "contractDescName":component.get("v.contractDescName"),
            "hospitalName" : component.get("v.hospitalName"),
            "child1Name" : component.get("v.child1Name"),
            "child2Name" : component.get("v.record.child2Name"),
            "productFamily" : component.get("v.selectedProductFamilies"),
            "productDescription":component.get("v.selectedProducts"),
            "contractDescription":component.get("v.selectedContractDesc"),
            "selectedMemberCity" :component.get("v.selectedMemberCity"),
            "selectedMemberState" :component.get("v.selectedMemberState"),
            "submitterName" :component.get("v.selectedSubmitterName"),
        });
         action.setCallback(this,function(response){
             if(response.getState() == 'SUCCESS'){
                 var totalsResponse = response.getReturnValue();
                 console.log("totalsResponse hir3???"+JSON.stringify(totalsResponse));
                 console.log("sales price hir3???==>"+Math.round(totalsResponse[0].salesPrice));
                 console.log("units hir3???==>"+totalsResponse[0].units);
                  component.set("v.twmonthsSalesTotal",Math.round(((totalsResponse[0].salesPrice) + Number.EPSILON) * 100) / 100)//Math.round(totalsResponse[0].salesPrice)
                  component.set("v.twmonthsUnitsTotal",totalsResponse[0].units)
                 /*for comparision Sales*/
                  var total12monthsales = component.get("v.twmonthsSalesTotal")
                  console.log('total12monthsales===??'+component.get("v.twmonthsSalesTotal"));
                 var current6monthsales = component.get("v.totalofSalesSummary")
                 console.log('current6monthsales===??'+current6monthsales);
                 var prev6monthsSales = component.get("v.twmonthsSalesTotal") - component.get("v.totalofSalesSummary") ;
                 console.log('prev6monthsSales===??'+prev6monthsSales);
                 var isValue = (total12monthsales != null && total12monthsales != 'undefined') ? true : false;
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
	sortBy: function(component, field, helper) {
        var currentDir = component.get("v.isDesc"),
            sortField = component.get("v.sortField"),
            records = component.get("v.record.prodFamilyRelatedList");
        console.log('response in helper==>'+JSON.stringify(records))
        if(sortField == 'ProductSalesDollar'){
             var key = function(a) { return a["Contract_Sales_Indirect_Price__c"] }
        }
        var reverse = currentDir ? 1: -1;
        records.sort(function(a,b){
            var a = key(a) ? key(a) : '';
             var b = key(b) ? key(b) : '';
             return reverse * ((a>b) - (b>a));
        });
        component.set("v.isDesc", currentDir);
        component.set("v.responseList", records);
        console.log('response in helper22==>'+JSON.stringify(component.get("v.responseList")))
        component.set('v.loaded', false);
        
    }
})