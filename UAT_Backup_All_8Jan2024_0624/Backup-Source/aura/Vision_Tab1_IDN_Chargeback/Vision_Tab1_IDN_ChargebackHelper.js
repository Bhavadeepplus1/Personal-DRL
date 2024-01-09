({
    getUser: function(component, event, helper){
        var action = component.get("c.getuser");
        action.setCallback(this,function(response){
            if(response.getState() == 'SUCCESS'){
                var userId = response.getReturnValue();
                console.log('userId.....'+userId);
                component.set("v.selectedUserId",userId);
                component.set("v.isLoggedinUser",true);
                console.log('responseList1. after set....'+component.get("v.selectedUserId"));
            }
            else{
                console.log('Error'+JSON.stringify(response.getError())); 
                component.set("v.isSpinnerLoad", false);
            }
        });
        $A.enqueueAction(action);
    },
    getKeys:function(component, event, helper){
         var action = component.get("c.getKeys");
        action.setCallback(this,function(response){
            if(response.getState() == 'SUCCESS'){
                var keysList = response.getReturnValue();
                console.log('keysList.....'+JSON.stringify(keysList));
                /*for keys*/
                component.set("v.firstColumnKey",keysList[5]);
                component.set("v.secondColumnKey",keysList[4]);
                component.set("v.thirdColumnKey",keysList[3]);
                component.set("v.fourthColumnKey",keysList[2]);
                component.set("v.fifthColumnKey",keysList[1]);
                component.set("v.sixthColumnKey",keysList[0]);
                /*end for keys*/
                
            }
            else{
                console.log('Error'+JSON.stringify(response.getError())); 
                component.set("v.isSpinnerLoad", false);
            }
        });
        $A.enqueueAction(action);
    },
    getAVG_Total: function(component, event, helper){
        var action = component.get("c.getAVG_Total");
         action.setParams({
            "salesTerritory":component.get("v.selectedUserId"),
         });
        action.setCallback(this,function(response){
            if(response.getState() == 'SUCCESS'){
                var responseList = response.getReturnValue();
                console.log('response.....'+responseList[0].avgunits);
                component.set("v.totalofSalesSummary",responseList[0].totalsalesPrice);
                component.set("v.totalofUnitsSummary",responseList[0].totalunits)
                 component.set("v.avgofSalesSummary",responseList[0].avgsalesPrice);
                component.set("v.avgofUnitsSummary",Math.round(responseList[0].avgunits));
                //component.set("v.selectedUserId",userId);
            }
            else{
                console.log('Error'+JSON.stringify(response.getError())); 
                component.set("v.isSpinnerLoad", false);
            }
        });
        $A.enqueueAction(action);
    },
    getFullData : function(component, event, helper) {
        //var salesTerritory =  component.get("v.salesTerritory");
        console.log('contractslist===>'+component.get("v.contractslist"));
       
      
       component.set("v.isSpinnerLoad", true);
        var offsetVal = 0;
		var action = component.get("c.getData");
        action.setParams({
            "salesTerritory":component.get("v.selectedUserId"),
            "userRegion":component.get("v.userRegion"),
            "userCategory": component.get("v.selectedcategory3"),//component.get("v.userCategory"),
            "hospitalName" : component.get("v.selectedValues"),
            "child1Name" : component.get("v.child1Name"),
             "child2Name" : component.get("v.child2Name"),
            "productFamily" : component.get("v.Productfamilylist"),//component.get("v.productFamily"),
            "productDescription":component.get("v.productslist"),//component.get("v.productDescription"),
            "accountId":component.get("v.selectedaccountId"),
            "contractDescription":component.get("v.contractslist"),
            "selectedMemberCity" :component.get("v.membercitylist"),
            "selectedMemberState" :component.get("v.memberstatelist"),
            "submitterName" :component.get("v.submitname"),//component.get("v.submitterName"),
           
        });
         action.setCallback(this,function(response){
             	 console.log('Status==>'+response.getState() );
                            if(response.getState() == 'SUCCESS'){
             					var responseList = response.getReturnValue();
                                console.log('response length==>'+responseList.length); 
                                 console.log('Success==>'+JSON.stringify(responseList));
                                   component.set("v.loadingMessage",'Fetching Hospitals. '+offsetVal+' out of '+responseList.length);

                                if(responseList.length == 0){
                                    component.set("v.noData", true);
                                } else{
                                    component.set("v.noData", false);
                                }
                                var hospitalList = [];
                                var hospitalCount = responseList.length;
                             
                                var firstColSalesSummary = 0;
                                var firstColUnitsSummary = 0;
                                var secColSalesSummary = 0;
                                var secColUnitsSummary = 0;
                                var thirdColSalesSummary = 0;
                                var thirdColUnitsSummary = 0;
                               	var fourthColSalesSummary = 0;
                                var fourthColUnitsSummary = 0;
                                var fifthColSalesSummary = 0;
                                var fifthColUnitsSummary = 0;
                                 var sixthColSalesSummary = 0;
                                var sixthColUnitsSummary = 0;
                                var totalofSalesSummary = 0;
                                var totalofUnitsSummary =0;
                                var avgofSalesSummary;
                                var avgofUnitsSummary ;
                                var userRegion='';
                               
                                var firstColumnKey = '';
                               	var secondColumnKey = '';
                                var thirdColumnKey = '';
                                var fourthColumnKey = '';
                                var fifthColumnKey = '';
                                var sixthColumnKey = '';
                                var categoryList =[];
                                for(var i=0;i<responseList.length;i++){
                                // console.log('Success idnchargebackList==>'+ JSON.stringify((responseList[i])));
                                  // console.log('Success currentSixMonthKeys==>'+responseList[i].currentSixMonthKeys[0]);
                                    hospitalList.push(responseList[i].hospitalName);
                                    firstColumnKey = responseList[i].currentSixMonthKeys[5];
                                       secondColumnKey = responseList[i].currentSixMonthKeys[4];
                                        thirdColumnKey = responseList[i].currentSixMonthKeys[3];
                                       fourthColumnKey = responseList[i].currentSixMonthKeys[2];
                                       fifthColumnKey = responseList[i].currentSixMonthKeys[1];
                                       sixthColumnKey = responseList[i].currentSixMonthKeys[0];
                                   responseList[i].idnchargebackList.forEach(function(rec){
                                      //userRegion = rec.Region__c;
                                    	categoryList.push(rec.Category__c);
                                       if(rec.Month_Year__c == responseList[i].currentSixMonthKeys[5]){//oct-22
                                          
                                           firstColSalesSummary += Math.round(rec.Contract_Sales_Indirect_Price__c);
                                           firstColUnitsSummary +=  Math.round(rec.contract_units_paid_qty__c);
                                       }
                                       if(rec.Month_Year__c == responseList[i].currentSixMonthKeys[4]){
                                           secColSalesSummary += Math.round(rec.Contract_Sales_Indirect_Price__c);
                                           secColUnitsSummary +=  Math.round(rec.contract_units_paid_qty__c);
                                       }
                                       if(rec.Month_Year__c == responseList[i].currentSixMonthKeys[3]){
                                           thirdColSalesSummary += Math.round(rec.Contract_Sales_Indirect_Price__c);
                                           thirdColUnitsSummary +=  Math.round(rec.contract_units_paid_qty__c);
                                       }
                                       if(rec.Month_Year__c == responseList[i].currentSixMonthKeys[2]){
                                           fourthColSalesSummary += Math.round(rec.Contract_Sales_Indirect_Price__c);
                                           fourthColUnitsSummary +=  Math.round(rec.contract_units_paid_qty__c);
                                       }
                                       if(rec.Month_Year__c == responseList[i].currentSixMonthKeys[1]){
                                           fifthColSalesSummary += Math.round(rec.Contract_Sales_Indirect_Price__c);
                                           fifthColUnitsSummary +=  Math.round(rec.contract_units_paid_qty__c);
                                       }
                                       if(rec.Month_Year__c == responseList[i].currentSixMonthKeys[0]){
                                           sixthColSalesSummary += Math.round(rec.Contract_Sales_Indirect_Price__c);
                                           sixthColUnitsSummary +=  Math.round(rec.contract_units_paid_qty__c);
                                       }
                                   });
                                  
                                }
                                totalofSalesSummary = firstColSalesSummary + secColSalesSummary + thirdColSalesSummary + fourthColSalesSummary +fifthColSalesSummary +sixthColSalesSummary; 
                                totalofUnitsSummary = firstColUnitsSummary + secColUnitsSummary + thirdColUnitsSummary + fourthColUnitsSummary + fifthColUnitsSummary + sixthColUnitsSummary;
                                avgofSalesSummary =  Math.round(totalofSalesSummary / 6);
                                avgofUnitsSummary =  Math.round(totalofUnitsSummary / 6);
                                
                                component.set("v.categoryList",categoryList);
                                console.log('categoryList==>'+categoryList.length);
                                console.log('hospital list==>'+hospitalList);
                                console.log('hospital list length==>'+hospitalList.length);
                                
                                component.set("v.firstColSalesSummary",firstColSalesSummary);
                                component.set("v.firstColUnitsSummary",firstColUnitsSummary);
                                component.set("v.secColSalesSummary",secColSalesSummary);
                                component.set("v.secColUnitsSummary",secColUnitsSummary);
                                 component.set("v.thirdColSalesSummary",thirdColSalesSummary);
                                component.set("v.thirdColUnitsSummary",thirdColUnitsSummary);
                                  component.set("v.fourthColSalesSummary",fourthColSalesSummary);
                                component.set("v.fourthColUnitsSummary",fourthColUnitsSummary);
                                 component.set("v.fifthColSalesSummary",fifthColSalesSummary);
                                component.set("v.fifthColUnitsSummary",fifthColUnitsSummary);
                                component.set("v.sixthColSalesSummary",sixthColSalesSummary);
                                component.set("v.sixthColUnitsSummary",sixthColUnitsSummary);
                                component.set("v.totalofSalesSummary",totalofSalesSummary);
                                component.set("v.totalofUnitsSummary",totalofUnitsSummary);
                                component.set("v.avgofSalesSummary",avgofSalesSummary);
                                component.set("v.avgofUnitsSummary",avgofUnitsSummary);
                               
                                component.set("v.hospitalCount",hospitalCount)
                                /*for keys*/
                                component.set("v.firstColumnKey",firstColumnKey);
                                console.log('satya??++>'+component.get("v.firstColumnKey"));
                                component.set("v.secondColumnKey",secondColumnKey);
                                component.set("v.thirdColumnKey",thirdColumnKey);
                                component.set("v.fourthColumnKey",fourthColumnKey);
                                component.set("v.fifthColumnKey",fifthColumnKey);
                                component.set("v.sixthColumnKey",sixthColumnKey);
                                /*end for keys*/
                                 component.set("v.chargebackList",responseList);
                                 component.set("v.duplicatechargebackList",responseList);
                                 component.set("v.hospitalList",hospitalList);
                                //component.set("v.userRegion",userRegion);
                                 //this.helper.gettwelMonthsData(component, event, helper);
                                /*Sorting for Avg of Sales*/
                                var testREc = component.get("v.chargebackList");
                                console.log('controller recordsdff-->');
                                var hospitialMap = new Map();
                                var SalesList = new Array();
                                var listOfWrappers=[];
                                testREc.forEach(function(eachRec){
                                    var relatedList = eachRec.idnchargebackList;
                                    var totalVal=0;
                                    relatedList.forEach(function(chargeBackRec){
                                        var salesPrice = (chargeBackRec.Contract_Sales_Indirect_Price__c != null && chargeBackRec.Contract_Sales_Indirect_Price__c != undefined) ? chargeBackRec.Contract_Sales_Indirect_Price__c : 0;
                                        totalVal= totalVal + salesPrice;
                                        
                                    });
                                    totalVal=Math.round(totalVal/6);
                                    
                                    //console.log('sum---->'+eachRec.hospitalName+'---Summ===>' +totalVal);
                                    var mainWrap = {'AverageSales':totalVal,
                                                    'eachHsptl':eachRec
                                                   };
                                    listOfWrappers.push(mainWrap);
                                    
                                });
                                
                                listOfWrappers.sort((a,b) => (a.AverageSales > b.AverageSales) ? -1 : ((b.AverageSales > a.AverageSales) ? 1 : 0));
                                var finaList = [];
                                listOfWrappers.forEach(function(eachREc){
                                    finaList.push(eachREc.eachHsptl);
                                    console.log('AvgSlaes---->'+eachREc.AverageSales)
                                    console.log('AvgSlaes---->'+eachREc.eachHsptl.hospitalName);
                                    
                                });
                                component.set("v.chargebackList",finaList);
                                var currentDir = component.get("v.isDesc");
                                
                                console.log('sort console---'+currentDir);
                                component.set("v.isDesc",!currentDir);
                              
                                /*end Sorting for AVG of Sales*/
                                
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