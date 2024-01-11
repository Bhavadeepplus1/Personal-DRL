({
    getcategoryData:function(component, event, helper){
         var action7 = component.get("c.getcategory");
        action7.setParams({
            "salesTerritoryId":component.get("v.selectedUserId"),
        })
        action7.setCallback(this,function(response){
            if(response.getState() == 'SUCCESS'){
                var responseList = response.getReturnValue();
                console.log('response getcategoryData.....'+responseList.length);
                var title7=[];
                for (var i=0; i<responseList.length; i++) {
                    title7[i] = {
                        'label':responseList[i],
                        'value': responseList[i]
                        
                    };
                }
                component.set("v.options10",title7);   
                component.set("v.isSpinnerLoad", false);
            }else{
                console.log('Error'+JSON.stringify(response.getError())); 
                component.set("v.isSpinnerLoad", false);
            }
        });
        $A.enqueueAction(action7);
        
    },
    gethospitalName:function(component, event, helper){
        var action = component.get("c.getHospitalNames");
        action.setParams({
            "salesTerritoryId":component.get("v.selectedUserId"),
        })
        action.setCallback(this,function(response){
            if(response.getState() == 'SUCCESS'){
                var responseList = response.getReturnValue();
                console.log('response.....'+responseList.length);
                var title=[];
                for (var i=0; i<responseList.length; i++) {
                    title[i] = {
                        'label':responseList[i],
                        'value': responseList[i]
                        
                    };
                }
                component.set("v.options3",title);   
                
                //component.set("v.options2",responseList); 
                // helper.getFullData(component, event, helper);
                
                component.set("v.isSpinnerLoad", false);
            }else{
                console.log('Error'+JSON.stringify(response.getError())); 
                component.set("v.isSpinnerLoad", false);
            }
        });
        $A.enqueueAction(action);
     },
    getProductNames:function(component, event, helper){
         var action1 = component.get("c.getProductNames");
        action1.setParams({
            "salesTerritoryId":component.get("v.selectedUserId"),
        })
        action1.setCallback(this,function(response){
            if(response.getState() == 'SUCCESS'){
                var responseList = response.getReturnValue();
                console.log('response.....'+responseList.length);
                var title1=[];
                for (var i=0; i<responseList.length; i++) {
                    title1[i] = {
                        'label':responseList[i],
                        'value': responseList[i]
                        
                    };
                }
                component.set("v.options4",title1);   
                
                //component.set("v.options2",responseList); 
                // helper.getFullData(component, event, helper);
                
                component.set("v.isSpinnerLoad", false);
            }else{
                console.log('Error'+JSON.stringify(response.getError())); 
                component.set("v.isSpinnerLoad", false);
            }
        });
        $A.enqueueAction(action1);
    },
    getProducts:function(component, event, helper){
         var action2 = component.get("c.getProducts");
        action2.setParams({
            "salesTerritoryId":component.get("v.selectedUserId"),
        })
        action2.setCallback(this,function(response){
            if(response.getState() == 'SUCCESS'){
                var responseList = response.getReturnValue();
                console.log('response.....'+responseList.length);
                var title2=[];
                for (var i=0; i<responseList.length; i++) {
                    title2[i] = {
                        'label':responseList[i],
                        'value': responseList[i]
                        
                    };
                }
                component.set("v.options5",title2);   
                
                //component.set("v.options2",responseList); 
                // helper.getFullData(component, event, helper);
                
                component.set("v.isSpinnerLoad", false);
            }else{
                console.log('Error'+JSON.stringify(response.getError())); 
                component.set("v.isSpinnerLoad", false);
            }
        });
        $A.enqueueAction(action2);
                
    },
    getmembericty:function(component, event, helper){
        var action4 = component.get("c.getmembericty");
        action4.setParams({
            "salesTerritoryId":component.get("v.selectedUserId"),
        })
        action4.setCallback(this,function(response){
            if(response.getState() == 'SUCCESS'){
                var responseList = response.getReturnValue();
                console.log('response.....'+responseList.length);
                var title4=[];
                for (var i=0; i<responseList.length; i++) {
                    title4[i] = {
                        'label':responseList[i],
                        'value': responseList[i]
                        
                    };
                }
                component.set("v.options7",title4);   
                
                
                
                component.set("v.isSpinnerLoad", false);
            }else{
                console.log('Error'+JSON.stringify(response.getError())); 
                component.set("v.isSpinnerLoad", false);
            }
        });
        $A.enqueueAction(action4);
    },
    getmemberstate:function(component, event, helper){
        var action5 = component.get("c.getmemberstate");
        action5.setParams({
            "salesTerritoryId":component.get("v.selectedUserId"),
        })
        action5.setCallback(this,function(response){
            if(response.getState() == 'SUCCESS'){
                var responseList = response.getReturnValue();
                console.log('response.....'+responseList.length);
                var title5=[];
                for (var i=0; i<responseList.length; i++) {
                    title5[i] = {
                        'label':responseList[i],
                        'value': responseList[i]
                        
                    };
                }
                component.set("v.options8",title5);   
                
                
                
                component.set("v.isSpinnerLoad", false);
            }else{
                console.log('Error'+JSON.stringify(response.getError())); 
                component.set("v.isSpinnerLoad", false);
            }
        });
        $A.enqueueAction(action5);
    },
     getsubmitters:function(component, event, helper){
           var action6 = component.get("c.getsubmitters");
          action6.setParams({
            "salesTerritoryId":component.get("v.selectedUserId"),
        })
        action6.setCallback(this,function(response){
            if(response.getState() == 'SUCCESS'){
                var responseList = response.getReturnValue();
                console.log('response.....'+responseList.length);
                var title6=[];
                for (var i=0; i<responseList.length; i++) {
                    title6[i] = {
                        'label':responseList[i],
                        'value': responseList[i]
                        
                    };
                }
                component.set("v.options9",title6);   
                
                
                
                component.set("v.isSpinnerLoad", false);
            }else{
                console.log('Error'+JSON.stringify(response.getError())); 
                component.set("v.isSpinnerLoad", false);
            }
        });
        $A.enqueueAction(action6);
     },
	getFullData : function(component, event, helper) {
        //var salesTerritory =  component.get("v.salesTerritory");
        console.log('selectedCategory==??'+component.get("v.selectedcategory3"));
        console.log('selected values...'+JSON.stringify(component.get("v.selectedValues")));
      
       component.set("v.isSpinnerLoad", true);
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
                                console.log('response 6 months length==>'+responseList.length); 
                                 console.log('Success 6 months==>'+JSON.stringify(responseList));
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
                            }
            
                            });
         $A.enqueueAction(action);
        
	},
    gettwMonthsData : function(component, event, helper) {
        //var salesTerritory =  component.get("v.salesTerritory");
        console.log('selectedCategory12==??'+component.get("v.selectedcategory3"));
        console.log('selected values12...'+JSON.stringify(component.get("v.selectedValues")));
      console.log('in gettwMonthsData');
      component.set("v.isSpinnerLoad", true);
		var action = component.get("c.gettwmonthsFullData");
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
             	 console.log('Status 12months==>'+response.getState() );
                            if(response.getState() == 'SUCCESS'){
             					var responseList = response.getReturnValue();
                                console.log('response 12 months length==>'+responseList.length); 
                                 console.log('12 months resp==>'+JSON.stringify(responseList));
                                var twlMonthsSalesSummary = 0;
                                var twlMonthsUnitsSummary = 0;
                                for(var i=0;i<responseList.length;i++){
                                    responseList[i].idnchargebackList.forEach(function(rec){
                                        twlMonthsSalesSummary += Math.round(rec.Contract_Sales_Indirect_Price__c);
                                        twlMonthsUnitsSummary += Math.round(rec.contract_units_paid_qty__c);
                                    });
                                }   
                                var listOfWrappers=[];
                                responseList.forEach(function(eachRec){
                                    var relatedList = eachRec.idnchargebackList;
                                    var twMontsSalesVal=0;
                                    var twMontsUnitsVal = 0;
                                    relatedList.forEach(function(chargeBackRec){
                                        var salesPrice = (chargeBackRec.Contract_Sales_Indirect_Price__c != null && chargeBackRec.Contract_Sales_Indirect_Price__c != undefined) ? chargeBackRec.Contract_Sales_Indirect_Price__c : 0;
                                        twMontsSalesVal= twMontsSalesVal + salesPrice;
                                        var units = (chargeBackRec.contract_units_paid_qty__c != null && chargeBackRec.contract_units_paid_qty__c != undefined) ? chargeBackRec.contract_units_paid_qty__c : 0;
                                        twMontsUnitsVal= twMontsUnitsVal + units;
                                    });
                                  
                                    
                                    console.log('sum---->'+eachRec.hospitalName+'---Summ===>' +twMontsSalesVal);
                                    var mainWrap = {'TweleveMonthsSales':twMontsSalesVal,
                                                    'TweleveMonthsUnits':twMontsUnitsVal,
                                                    'eachHsptl':eachRec
                                                   };
                                    listOfWrappers.push(mainWrap);
                                   
                                    
                                });
      							console.log('listOfWrappers in Hir2==>'+JSON.stringify(listOfWrappers))
                               	//component.set("v.twMonthsList",responseList)
                                component.set("v.twmonthsSalesTotal",twlMonthsSalesSummary)
                                component.set("v.twmonthsUnitsTotal",twlMonthsUnitsSummary)
                                component.set("v.listOfWrappers",listOfWrappers)
                              
                              
                            }else{
                               console.log('Error'+JSON.stringify(response.getError())); 
                                 component.set("v.isSpinnerLoad", false);
                            }
            
                            });
         $A.enqueueAction(action);
        
	},
    getprevsixMonthsData : function(component, event, helper) {
        console.log('in gettwelMonthsData')
        console.log('in gettwelMonthsData salesTerritory==>'+component.get("v.selectedUserId"))
        component.set("v.isSpinnerLoad", true);
		var action = component.get("c.getprevsixMonthsData");
        action.setParams({
            "salesTerritory":component.get("v.selectedUserId"),
            "userRegion":component.get("v.userRegion"),
            "userCategory":component.get("v.userCategory"),
            "hospitalName" : component.get("v.hospitalName"),
            "child1Name" : component.get("v.child1Name"),
             "child2Name" : component.get("v.child2Name"),
            "productFamily" : component.get("v.productFamily"),
            "productDescription":component.get("v.productDescription"),
            "accountId":component.get("v.selectedaccountId"),
            "contractDescription":component.get("v.selectedContractDesc")
           
        });
        action.setCallback(this,function(response){
             console.log('Status==>'+response.getState() );
                            if(response.getState() == 'SUCCESS'){
             					var prevsixMonthsresponseList = response.getReturnValue();
                                console.log('gettwelMonthsData response length==>'+prevsixMonthsresponseList.length); 
                                 console.log('gettwelMonthsData Success==>'+JSON.stringify(prevsixMonthsresponseList));
                                var prevfirstColumnKey = '';
                               	var prevsecondColumnKey = '';
                                var prevthirdColumnKey = '';
                                var prevfourthColumnKey = '';
                                var prevfifthColumnKey = '';
                                var prevsixthColumnKey = '';
                                for(var i=0;i<prevsixMonthsresponseList.length;i++){
                                    console.log('Success previdnchargebackList==>'+ JSON.stringify((prevsixMonthsresponseList[i])));
                                    console.log('Success prevSixMonthKeys==>'+prevsixMonthsresponseList[i].prevSixMonthKeys[0]);
                                    prevfirstColumnKey = prevsixMonthsresponseList[i].prevSixMonthKeys[5];
                                    prevsecondColumnKey = prevsixMonthsresponseList[i].prevSixMonthKeys[4];
                                    prevthirdColumnKey = prevsixMonthsresponseList[i].prevSixMonthKeys[3];
                                    prevfourthColumnKey = prevsixMonthsresponseList[i].prevSixMonthKeys[2];
                                    prevfifthColumnKey = prevsixMonthsresponseList[i].prevSixMonthKeys[1];
                                    prevsixthColumnKey = prevsixMonthsresponseList[i].prevSixMonthKeys[0];
                                }
                                component.set("v.prevfirstColumnKey",prevfirstColumnKey);
                                component.set("v.prevsecondColumnKey",prevsecondColumnKey);
                                component.set("v.prevthirdColumnKey",prevthirdColumnKey);
                                component.set("v.prevfourthColumnKey",prevfourthColumnKey);
                                component.set("v.prevfifthColumnKey",prevfifthColumnKey);
                                component.set("v.prevsixthColumnKey",prevsixthColumnKey);
                                component.set("v.prevSixMnthschargebackList",prevsixMonthsresponseList);
                                //component.set("v.chargebackList",component.get("v.duplicatechargebackList"));
                                 //this.getFullData(component, event, helper);
                                
                                
                                component.set("v.isSpinnerLoad", false);
                                
                            }else{
                               console.log('Error'+JSON.stringify(response.getError())); 
                                 component.set("v.isSpinnerLoad", false);
                            }
            
        });
        
         $A.enqueueAction(action);
    },
    convertArrayOfObjectsToCSV: function(component,objectRecords){
       var csvStringResult, counter, keys, columnDivider, lineDivider;
         if (objectRecords == null || !objectRecords.length) {
            return null;
        }
         columnDivider = ',';
        lineDivider = '\n';

        // in the keys valirable store fields API Names as a key 
        // this labels use in CSV file header 
        csvStringResult = '';
          var myMap = new Map();
         myMap.set("Hospital Name","Hospital_Name__c");
         myMap.set("Child1","Child1_Name__c");
         myMap.set("Child2","Child2_Name__c");
         myMap.set("Contact Description","Contact_Description__c");
         myMap.set("Product Family","revised_product_family__c");
         myMap.set("Product","Product__r.Name");
           csvStringResult += Array.from(myMap.keys()).join(columnDivider);
        csvStringResult += lineDivider;
        //new logic start 
        for(var j = 0; j < objectRecords.length; j++){
           console.log('json....'+JSON.stringify(objectRecords[j]));
        for (var i = 0; i < objectRecords[j].length; i++) {
            
            counter = 0;
            for (let [key, value] of myMap) {
                if (counter > 0) {
                    csvStringResult += columnDivider;
                }
                console.log('testing result--->' + JSON.stringify(objectRecords[i]));
                if (value == 'Hospital_Name__c') {
                    csvStringResult += '"' + objectRecords[j][i]["hospitalName"]+ '"';
                }
                else if(value == 'Child1_Name__c'){
                      csvStringResult += '"' + objectRecords[j][i]["Child1_Name__c"]+ '"';
                }
                else if(value == 'Child2_Name__c'){
                      csvStringResult += '"' + objectRecords[j][i]["Child2_Name__c"]+ '"';
                }
                 else if(value == 'Contact_Description__c'){
                      csvStringResult += '"' + objectRecords[j][i]["Contact_Description__c"]+ '"';
                }
                else if(value == 'revised_product_family__c'){
                      csvStringResult += '"' + objectRecords[j][i]["revised_product_family__c"]+ '"';
                }
                 else if (objectRecords[i][value] == undefined) {
                    csvStringResult += '"' + '' + '"';
                } 
              else {
                    csvStringResult += '"' + objectRecords[i][value] + '"';
                }

                counter++;
            }
            csvStringResult += lineDivider;
        }
        }
        //new logic end 
        return csvStringResult;

    },
   /* getAllTotals : function(component,event,helper) {
		console.log('in get all totals')
        var action = component.get("c.getAllTotals");
        console.log('salesTerritory==>'+component.get("v.selectedUserId"));
         console.log('userRegion==>'+component.get("v.userRegion"));
          console.log('userCategory==>'+component.get("v.userCategory")),
              console.log('hospitalList==>'+component.get("v.hospitalList")),
        console.log('child1Name'+component.get("v.child1Name"));
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
            "userCategory":component.get("v.userCategory"),
            "hospitalList" : component.get("v.hospitalList"),
            "child1Name" : component.get("v.child1Name"),
             "child2Name" : component.get("v.child2Name"),
            "productFamily" : component.get("v.productFamily"),
            "productDescription":component.get("v.productDescription"),
            "accountId":component.get("v.selectedaccountId"),
            "contractDescription":component.get("v.selectedContractDesc"),
            "selectedMemberCity" :component.get("v.selectedMemberCity"),
            "selectedMemberState" :component.get("v.selectedMemberState"),
            "submitterName" :component.get("v.submitterName"),
        });
         action.setCallback(this,function(response){
              console.log("response state"+response.getState());
             if(response.getState() == 'SUCCESS'){
                 	var totalsResponse = response.getReturnValue();
                 console.log("totalsResponse???"+JSON.stringify(totalsResponse));
                 console.log("sales price???==>"+Math.round(totalsResponse[0].salesPrice));
                 console.log("units???==>"+totalsResponse[0].units);
                 component.set("v.twmonthsSalesTotal",Math.round(totalsResponse[0].salesPrice))
                  component.set("v.twmonthsUnitsTotal",totalsResponse[0].units)
                 component.set("v.isSpinnerLoad", false);
             }else{
                               console.log('Error'+JSON.stringify(response.getError())); 
                                 component.set("v.isSpinnerLoad", false);
                            }
         });
         $A.enqueueAction(action);
	},*/
    selectRegion:function(component,event,helper){
         console.log('userRegion==>' +component.get("v.userRegion"));
        component.set("v.isSpinnerLoad", false);
    },
    searchRecords : function(component, searchString) {
        var action = component.get("c.getFamilies");
        action.setParams({
            "searchString" : searchString
        });
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                const serverResult = response.getReturnValue();
                const results = [];
                serverResult.forEach(element => {
                    const result = {id : element, value : element};
                                     results.push(result);
            });
            component.set("v.results", results);
            if(serverResult.length>0){
                component.set("v.openDropDown", true);
            }
        } else{
         console.log("Error "+JSON.stringify(response.getError()));
        }
    });
    $A.enqueueAction(action);
    },
    sortBySales : function(component, field){
        console.log('recordsdff-->');
        var records = component.get("v.chargebackList");
        console.log('recordsdff-->'+JSON.stringify(records));
        var hospitalmapObj = new Map();
        var allData= [];
        var prevSum=0;
        
        records.forEach(function(rec){
            var relatedList = rec.idnchargebackList;
            var sum=0;
            relatedList.forEach(function(chargeBackRec){
                sum= sum+(chargeBackRec.Contract_Sales_Indirect_Price__c!=null?chargeBackRec.Contract_Sales_Indirect_Price__c:0);
            });
            hospitalmapObj['rechospitalName']=100;
            //hospitalmapObj.set("orange", 10);
          
        });
        console.log('hospitalmapObj250-->'+JSON.stringify(hospitalmapObj));
        // sort by value
		const mapSort1 = new Map([...hospitalmapObj.entries()].sort((a, b) => b[1] - a[1]));
        for (let [key, value] of hospitalmapObj) {     // get data sorted
            console.log('Key--->'+JSON.stringify(key) + '==== ' +value);
        }
        //component.set("v.chargebackList", mapSort1.entries());
        console.log('chargeBackListAfterSorting-->'+JSON.stringify(mapSort1.entries()));
        component.set('v.isSpinnerLoad', false);
    },
    sortHelper: function(component, event, sortFieldName) {
       // var currentDir = component.get("v.isAsc");
       // component.set("v.isAsc",!currentDir);
       console.log('sortHelper');
        this.onSortResult(component, event, sortFieldName);
    },
      onSortResult: function(component, event, sortField) {
        console.log('onSortResult');
        var chargebackList = component.get("v.chargebackList");
          
        console.log("respy list==>"+JSON.stringify(chargebackList))
        var currentDir = component.get("v.isAsc");
        component.set("v.isAsc",!currentDir);
        console.log('sort console---'+!currentDir);
        var records = component.get("v.chargebackList");
       
        var key = function(a) { 
            console.log('a[name]===>'+a["hospitalName"]["idnchargebackList"]["Contract_Sales_Indirect_Price__c"])
            return a["hospitalName"]["idnchargebackList"]["Contract_Sales_Indirect_Price__c"];
            
        }
        var reverse = currentDir ? 1: -1;
        chargebackList.sort(function(a,b){
            var a = key(a) ? key(a) : '';
            var b = key(b) ? key(b) : '';
            return reverse * ((a>b) - (b>a));
        });
        component.set("v.chargebackList", chargebackList);
           
        component.set("v.loaded",false);
     
    },
         fetchContratcs : function(component,event,helper,searchInput) {
         var action = component.get("c.getContrcts");
        action.setParams({
            "searchInput" : searchInput,
            "salesTerritoryId":component.get("v.selectedUserId"),
        })
         action.setCallback(this,function(response){
             if(response.getState() == 'SUCCESS'){
                  var responseList = response.getReturnValue();
                	console.log('response of contracts.....'+JSON.stringify(responseList));
                /* var resp=[];
                for (var i=0; i<responseList.length; i++) {
                    resp[i] = {
                        'label':responseList[i],
                        'value': responseList[i]
                        
                    };
                }*/
                 component.set("v.contratcsList",responseList);
             }else{
                 console.log('Error'+JSON.stringify(response.getError())); 
             }
         })
          $A.enqueueAction(action);
     }
})