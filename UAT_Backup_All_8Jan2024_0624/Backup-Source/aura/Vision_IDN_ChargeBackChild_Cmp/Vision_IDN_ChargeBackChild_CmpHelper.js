({
	 getAllTotalsforIndividual : function(component,event,helper) {
		console.log('in get all totals child')
        var action = component.get("c.getAllTotalsforIndividual");
        action.setParams({
            "salesTerritory":component.get("v.selectedUserId"),
            "userRegion":component.get("v.userRegion"),
            "userCategory":component.get("v.selectedCategory"),
            "hospitalName" : component.get("v.record.hospitalName"),
            "child1Name" : component.get("v.child1Name"),
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
              console.log("CHILD response state"+response.getState());
             if(response.getState() == 'SUCCESS'){
                 	var totalsResponse = response.getReturnValue();
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
                 //component.set("v.isSpinnerLoad", false);
             }else{
                               console.log('Error'+JSON.stringify(response.getError())); 
                                 component.set("v.isSpinnerLoad", false);
                            }
         });
         $A.enqueueAction(action);
	},
     getFullDataIndividual : function(component, event, helper) {
       component.set("v.isSpinnerLoad", true);
        console.log('isSpinnerLoad===>'+component.get("v.isSpinnerLoad"));
        var offsetVal = 0;
		var action = component.get("c.getDataIndividual");
        action.setParams({
            "salesTerritory":component.get("v.selectedUserId"),
            "userRegion":component.get("v.userRegion"),
            "userCategory":component.get("v.selectedCategory"),
            "hospitalName" : component.get("v.record.hospitalName"),
            "child1Name" : component.get("v.child1Name"),
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
             console.log('Status==>'+response.getState() );
             if(response.getState() == 'SUCCESS'){
                 var eachrecresponseList = response.getReturnValue();
                 console.log('eachrecresponseList idnchargebackList==>'+eachrecresponseList[0].idnchargebackList); 
                 console.log('eachrecresponseList Success==>'+JSON.stringify(eachrecresponseList));
                 var hospitalrelatedList = eachrecresponseList[0].idnchargebackList;
                 var child1mapObj ={};
                 var allData= [];
                 hospitalrelatedList.forEach(function(rec){
                     console.log('test==>'+rec.Child1_Name__c);
                     if(child1mapObj.hasOwnProperty(rec.Child1_Name__c)){
                         console.log('inside if==>'+rec.Child1_Name__c);
                         var relatedList = child1mapObj[rec.Child1_Name__c];
                         relatedList.push(rec);
                         child1mapObj[rec.Child1_Name__c] = relatedList;
                         
                     }
                     else{
                         console.log('inside else==>');
                         var relatedList =[];
                         relatedList.push(rec);
                         child1mapObj[rec.Child1_Name__c] = relatedList;
                         
                     }
                     
                 });
                 var keys = Object.keys(child1mapObj);
                 var allData = [];
                 for(var i=0; i<keys.length; i++){
                     var obj = {};
                     var relatedList = child1mapObj[keys[i]];
                     obj.showChild1= true;
                     obj.showChild= true;
                     obj.child1 = keys[i];
                     obj.child1RelatedList = relatedList;
                     
                     allData.push(obj);
                 }
                 
                 console.log('length==>'+hospitalrelatedList.length);
                 console.log('child1mapObj===>'+JSON.stringify(child1mapObj));
                 component.set("v.child1List",allData);
        /* for sorting*/
        var testREc = component.get("v.child1List");
        console.log('testREc==>'+JSON.stringify(testREc));
        var hospitialMap = new Map();
        var SalesList = new Array();
        var listOfWrappers=[];
        testREc.forEach(function(eachRec){
            var relatedList = eachRec.child1RelatedList;
            var totalVal=0;
            relatedList.forEach(function(chargeBackRec){
                var salesPrice = (chargeBackRec.Contract_Sales_Indirect_Price__c != null && chargeBackRec.Contract_Sales_Indirect_Price__c != undefined) ? chargeBackRec.Contract_Sales_Indirect_Price__c : 0;
                totalVal= totalVal + salesPrice;
                
            });
            totalVal=Math.round(((totalVal/6) + Number.EPSILON) * 100) / 100;//Math.round(totalVal/6);
            
            
            var mainWrap = {'AverageSales':totalVal,
                            'eachChild1':eachRec
                           };
            listOfWrappers.push(mainWrap);
            
        });
        
        listOfWrappers.sort((a,b) => (a.AverageSales > b.AverageSales) ? -1 : ((b.AverageSales > a.AverageSales) ? 1 : 0));
        var finaList = [];
        listOfWrappers.forEach(function(eachREc){
            finaList.push(eachREc.eachChild1);
            console.log('AvgSlaes---->'+eachREc.AverageSales)
            console.log('AvgSlaes---->'+eachREc.eachChild1.child1);
            
        });
        component.set("v.child1List",finaList);
        /*end for sorting*/
                                
                                  component.set("v.isSpinnerLoad", false);
                            }else{
                               console.log('Error'+JSON.stringify(response.getError())); 
                                 component.set("v.isSpinnerLoad", false);
                                component.set("v.loadingMessage",'');
                            }
            
                            });
         $A.enqueueAction(action);
        
	},
})