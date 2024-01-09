({
    getBidInfoForValids : function(component,event,helper){
        component.set('v.isSpinnerLoad',true);
        var action = component.get("c.getSubmitBidInfo");      
        action.setParams
        ({
            bidId: component.get("v.recordId")
        });
        action.setCallback(this, function(response) 
                           {
                               if(response.getState()=="SUCCESS"){
                                   var resposneString =  response.getReturnValue(); 
                                   console.log(resposneString);
                                   if(resposneString=='Success'){
                                       var toastEvent = $A.get("e.force:showToast");
                                       toastEvent.setParams({
                                           "title": "Success!",
                                           "message":"Bid is sent for approval.",
                                           "type":"success",
                                           "mode":"dismissible"
                                       });
                                       toastEvent.fire();
                                       component.set('v.isSpinnerLoad',false);
                                       component.find("navigationService").navigate({
                                           type: "standard__recordPage",
                                           attributes: {
                                               recordId: component.get("v.recordId"),
                                               actionName: "view"
                                           }
                                       }, false);
                                   }
                                   else{
                                       var toastEvent = $A.get("e.force:showToast");
                                       toastEvent.setParams({
                                           "title": "Error!",
                                           "message":resposneString,
                                           "type":"error",
                                           "mode":"dismissible"
                                       });
                                       toastEvent.fire(); 
                                       component.set('v.isSpinnerLoad',false);
                                   }
                               }
                           });
        $A.enqueueAction(action);
    },
    
    getAllTotalValues :function(component, event, helper) {
        var action = component.get("c.getAllTotals");      
        action.setParams
        ({
            bidId: component.get("v.recordId")
        });
        action.setCallback(this, function(response) 
                           {
                               if(response.getState()=="SUCCESS"){
                                   var responseValue= response.getReturnValue();
                                   console.log('responseValue.length :: :: '+responseValue.length);
                                   component.set("v.PISUTotal",responseValue[0].pisu);
                                   console.log('responseValue[0].OverrideTotalUnits :: '+responseValue[0].OverrideTotalUnits);
                                   
                                   component.set("v.PDSUTotal",responseValue[0].pdsu);
                                   component.set("v.CISUTotal",responseValue[0].cisu);
                                   component.set("v.CDSUTotal",responseValue[0].cdsu);
                                   component.set("v.netSalesIntTotal",responseValue[0].netsint);
                                   component.set("v.LCostTotal",responseValue[0].lesscost);
                                   component.set("v.ThptMrgnDTotal",responseValue[0].thptm);
                                   component.set("v.intDeadNetTotal",responseValue[0].intdead);
                                   component.set("v.proNetSaleDir",responseValue[0].pnsd);
                                   component.set("v.proNetSaleInd",responseValue[0].pnsInd);
                                   component.set("v.proTPTDir",responseValue[0].pTPTDir);
                                   component.set("v.proTPTInd",responseValue[0].pTPTInd);
                                   var ProposedTPTDir = responseValue[0].pnsd =! 0 ? (responseValue[0].pTPTDir/responseValue[0].pnsd)*100 : 0;
                                   var ProposedTPTInDir = responseValue[0].pnsd =! 0 ? (responseValue[0].pTPTInd/responseValue[0].pnsInd)*100 : 0;
                                   var BlendedTPMargin = responseValue[0].netsint =! 0 ? (responseValue[0].thptm/responseValue[0].netsint)*100 : 0;
                                   component.set("v.proTPTPerDir",ProposedTPTDir);
                                   component.set("v.proTPTPerIndir",ProposedTPTInDir);
                                   component.set("v.BlendedTPMargin",BlendedTPMargin);
                                   //for ROSS Added by satya
                                   component.set("v.ThAnCVSDirTotal",responseValue[0].rosthanualcvsdirect);
                                   component.set("v.ThAnCVSInDirTotal",responseValue[0].rosthanualcvsIndirect);
                                   component.set("v.ThAnCardSellTotal",responseValue[0].rostthanualcardselling);
                                   component.set("v.TwAnCVSDirectTotal",responseValue[0].rostwanualcvsdirect);
                                   component.set("v.TwAnCVSInDirectTotal",responseValue[0].rostwanualcvsIndirect);
                                   component.set("v.OverrideCVSDirectTotal",responseValue[0].rosoverCVSDirect);
                                   component.set("v.OverrideCVSInDirectTotal",responseValue[0].rosoverCVSInDirect);
                                   component.set("v.OverrideCardinalTotal",responseValue[0].OverrideTotalUnits);
                                   component.set("v.OverrideTotalUnits",responseValue[0].rosoverTotalUnits);
                                   component.set("v.totalUnits",responseValue[0].rostotalUnits);
                                   component.set("v.finalDirectSellTotal",responseValue[0].rosFinalDirSellUnits);
                                   component.set("v.finalInDirectSellTotal",responseValue[0].rosFinalInDirSellUnits);
                                   component.set("v.finalTotalSellingUnits",responseValue[0].rosFinalTotalSellUnits);
                                   
                                   component.set("v.scmDirUnits",responseValue[0].scmDirUnits);
                                   component.set("v.scmInDirUnits",responseValue[0].scmInDirUnits);
                                   component.set("v.scmCardinalUnits",responseValue[0].scmCardinalUnits);
                                   component.set("v.scmMajorUnits",responseValue[0].scmMajorUnits);
                                   component.set("v.scmTotalUnits",responseValue[0].scmTotalUnits);
                                   
                                   component.set("v.IODTotalAmount",responseValue[0].rosIODtotalAmount);
                                   component.set("v.MajorIODtotalAmount",responseValue[0].rosMajorIODtotalAmount);
                                   component.set("v.CVSDirNetSalTotal",responseValue[0].rosCVSdirectNetSales);
                                   component.set("v.CVSInDirNetSalTotal",responseValue[0].rosCVSIndirectNetSales);
                                   component.set("v.CardinalNetSalTotal",responseValue[0].rosCardinalNetSales);
                                   component.set("v.RedOakNetSalTotal",responseValue[0].rosTotalRedOakNetSales);
                                   //set extension fields
                                   component.set("v.PropCVSDirectSellTotal",responseValue[1].rospropcvsdirsell);
                                   console.log('responseValue[1].rospropcvsdirsell :: '+responseValue[1].rospropcvsdirsell);
                                   component.set("v.PropCVSInDirectSellTotal",responseValue[1].rospropcvsIndirsell);
                                   component.set("v.ThMAnuMjSellUnitsTotal",responseValue[1].ThMAnuMjSellUnits);
                                   component.set("v.TotThMAnuSellUnitsTotal",responseValue[1].TotThMAnuSellUnits);
                                   component.set("v.ActTwMCardnialSellUnitsTotal",responseValue[1].ActTwMCardnialSellUnits);
                                   component.set("v.ActTwMMajorSellUnitsTotal",responseValue[1].ActTwMMajorSellUnits);
                                   component.set("v.ActTwMTotalSellUnitsTotal",responseValue[1].ActTwMTotalSellUnits);
                                   component.set("v.OverrideMajorUnitsTotal",responseValue[1].OverrideMajorUnits);
                                   component.set("v.PropCardnialUnitsTotal",responseValue[1].PropCardnialUnits);
                                   component.set("v.PropMajorUnitsTotal",responseValue[1].PropMajorUnits);
                                   component.set("v.CVSTotNetSalesTotal",responseValue[1].CVSTotNetSales);
                                   component.set("v.CVSDirectTPTTotal",responseValue[1].CVSDirectTPT);
                                   component.set("v.CVSTotalTPTTotal",responseValue[1].CVSTotalTPT);
                                   component.set("v.CVSInDirectTPTTotal",responseValue[1].CVSInDirectTPT);
                                   component.set("v.CardinalTPTTotal",responseValue[1].CardinalTPT);
                                   component.set("v.MajorNetSalesTotal",responseValue[1].MajorNetSales);
                                   component.set("v.MajorTPTTotal",responseValue[1].MajorTPT);
                                   component.set("v.TotRedOakTPTTotal",responseValue[1].TotRedOakTPT);
                                   //end by satya
                                   var cvsDirPerTotal = responseValue[0].rosCVSdirectNetSales != null ? (responseValue[1].CVSDirectTPT/responseValue[0].rosCVSdirectNetSales)*100 : 0;
                                   component.set("v.CVSDirectTPTPerTotal",cvsDirPerTotal);
                                   var cvsIndirPerTotal = responseValue[0].rosCVSIndirectNetSales != null ? (responseValue[1].CVSInDirectTPT/responseValue[0].rosCVSIndirectNetSales)*100 : 0;
                                   component.set("v.CVSInDirectTPTPerTotal",cvsIndirPerTotal);
                                   var cvsCardinalPerTotal = responseValue[0].rosCardinalNetSales != null ? (responseValue[1].CardinalTPT/responseValue[0].rosCardinalNetSales)*100 : 0;
                                   component.set("v.CardinalTPTPerTotal",cvsCardinalPerTotal);
                                   var cvsMajorPerTotal = responseValue[1].MajorNetSales != null ? (responseValue[1].MajorTPT/responseValue[1].MajorNetSales)*100 : 0;
                                   component.set("v.MajorTPTPerTotal",cvsMajorPerTotal);
                                   var redOakPerTotal = responseValue[0].rosTotalRedOakNetSales != null ? (responseValue[1].TotRedOakTPT/responseValue[0].rosTotalRedOakNetSales)*100 : 0;
                                   component.set("v.TotRedOakTPTPerTotal",redOakPerTotal);
                                   var CVSTotalTPTPer = responseValue[1].CVSTotNetSales != null ? (responseValue[1].CVSTotalTPT/responseValue[1].CVSTotNetSales)*100 : 0;
                                   component.set("v.CVSTotalTPTPerTotal",CVSTotalTPTPer);
                                   /*for New Product Launch*/
                                   component.set("v.OpeningOrderCardinalTotal",responseValue[0].openingOrder);
                                   component.set("v.OpngOrderCrdnlNetSalesTotal",responseValue[0].openingOrderNetSales);
                                   component.set("v.OpngOrderTPTTotal",responseValue[0].openingOrderTPT);
                                   var OpngOrderTPTTotalPer = responseValue[0].openingOrderNetSales != null ? (responseValue[0].openingOrderTPT/responseValue[0].openingOrderNetSales)*100 : 0;
                                   component.set("v.OpngOrderTPTPerTotal",OpngOrderTPTTotalPer);
                                   component.set("v.OpngOrderMajorTotal",responseValue[1].openingOrderMajor);
                                   component.set("v.OpngOrderMajorNetSalesTotal",responseValue[1].opngOrderNetSalesMajor);
                                   component.set("v.OpngOrderMajorTPTTotal",responseValue[1].opngOrderTPTMajor);
                                   var OpngOrderMajorTPTTotalPer = responseValue[1].opngOrderNetSalesMajor != null ? (responseValue[1].opngOrderTPTMajor/responseValue[1].opngOrderNetSalesMajor)*100 : 0;
                                   component.set("v.OpngOrderMajorTPTPerTotal",OpngOrderMajorTPTTotalPer);
                                   component.set("v.OpngOrderCVSTotal",responseValue[1].openingOrderCVS);
                                   component.set("v.OpngOrderCVSNetSalesTotal",responseValue[1].opngOrderNetSalesCVS);
                                   component.set("v.OpngOrderCVSTPTTotal",responseValue[1].opngOrderTPTCVS);
                                   var OpngOrderCVSTPTTotalPer = responseValue[1].opngOrderNetSalesCVS != null ? (responseValue[1].opngOrderTPTCVS/responseValue[1].opngOrderNetSalesCVS)*100 : 0;
                                   component.set("v.OpngOrderCVSTPTPerTotal",OpngOrderCVSTPTTotalPer);
                                   /*End for New Product Launch*/
                               }
                               else{
                                   console.log('totals-errir-');
                               }
                           });
        $A.enqueueAction(action);
    },
    
    getBidDetails:function(component,event) {
        var action = component.get("c.getbidRecordDetails");
        action.setParams({
            bidId:component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                var bidRecord=response.getReturnValue();
            }
        })
    },
    requiredValidation : function(component,event) {
        var allRecords = component.get("v.BidLineItemListAll");
        var isValid = true;
        for(var i = 0; i < allRecords.length;i++){
            if(allRecords[i].Name == null || allRecords[i].Name.trim() == ''){
                alert('Complete this field : Row No ' + (i+1) + ' Name is null' );
                isValid = false;
            }
        }
        return isValid;
    },
    searchHelper : function(component,event,getInputkeyWord) {
        var li = component.get("v.defaultlistOfProductFamily");
        console.log('list of pro family-->'+li);
        var excludelist=component.get("v.lstSelectedRecords");
        console.log('excludelist---'+excludelist);
        console.log('getInputkeyWord--'+getInputkeyWord);
        var final=[];
        let difference = li.filter(x => !excludelist.includes(x) && x.toLowerCase().startsWith(getInputkeyWord.toLowerCase()));
        console.log(difference);
        if(difference.length>0){
            component.set("v.listOfSearchRecords", difference); 
            component.set("v.Message", '');
        }else{
            component.set("v.Message", 'No Records Found...');
            component.set("v.listOfSearchRecords", null); 
        }
    },
    searchHelperProdDir : function(component,event,getInputkeyWord) {
        var li = component.get("v.defaultlistOfProductDirectors");
        console.log('list of pro dirs-->'+li);
        var excludelist=component.get("v.lstSelectedPDRecords");
        console.log('excludelist---'+excludelist);
        console.log('getInputkeyWord--'+getInputkeyWord);
        var final=[];
        let difference = li.filter(x => !excludelist.includes(x) && x.toLowerCase().startsWith(getInputkeyWord.toLowerCase()));
        console.log(difference);
        if(difference.length>0){
            component.set("v.listOfSearchPDRecords", difference); 
            component.set("v.MessagePD", '');
        }else{
            component.set("v.MessagePD", 'No Records Found...');
            component.set("v.listOfSearchPDRecords", null); 
        }
    },
    searchProductFamilyChange: function(component, event,helper) {
        component.set('v.isSpinnerLoad',true);
        var action = component.get("c.findByProductFamily");
        console.log("listOfPD----->"+component.get("v.lstSelectedPDRecords"))
        action.setParams({
            "searchKey": component.get("v.lstSelectedRecords"),
            "lineItemId" : component.get("v.recordId"),
            "sRxOtcList" : component.get("v.RxSrxList"),
            "searchPDList" : component.get("v.lstSelectedPDRecords")
        });
        action.setCallback(this, function(a) {
            var lineItemsList =a.getReturnValue();
            component.set("v.BidLineItemListAll", lineItemsList);
            component.set('v.isSpinnerLoad',false);
            var OutDiv = component.find("mainDiv");
            if(lineItemsList.length<10){
                console.log('--no-hight---');
                $A.util.addClass(OutDiv, "noheightClass");
            }else{
                $A.util.removeClass(OutDiv, "noheightClass");
            }
        });
        $A.enqueueAction(action);
    },
    fetchPositions: function (component, event, helper, bidCustomer) {
        console.log('bidCustomer---' + bidCustomer);
        var action = component.get("c.getPositions");
        action.setParams({
            customerID: bidCustomer
        });
        action.setCallback(this, function (response) {
            if (response.getState() === "SUCCESS") {
                var responseList = response.getReturnValue();
                console.log('---responseList---' + responseList.length);
                //component.set("v.contratcsList",responseList);
                
                //below code is for remove seleceted while fetch contracts in table
                var slctpositions = component.get('v.selectedPosistions');
                var finalPositions = [];
                if(slctpositions != null)
                    finalPositions = responseList.filter(comparer(slctpositions));
                else 
                   finalPositions = responseList;
                function comparer(otherArray) {
                    return function (current) {
                        return otherArray.filter(function (other) {
                            console.log(other);
                            return other == current.Name
                        }).length == 0;
                    }
                }
                
                for (var i = 0; i < finalPositions.length; i++) {
                    var row = finalPositions[i];
                    if (row.Phoenix_Customer__c) {
                        row.Phoenix_Customer__c = row.Phoenix_Customer__r.Name;
                    }
                }
                component.set("v.positionsList", finalPositions);
                component.set("v.isSpinner",false);
        
            }
        });
        $A.enqueueAction(action);
        
    },
    fetchCardinalPositions: function (component, event, helper, bidCustomer) {
        console.log('bidCustomer---' + bidCustomer);
        var action = component.get("c.getPositions");
        action.setParams({
            customerID: bidCustomer
            // searchInput:searchInput
            
        });
        action.setCallback(this, function (response) {
            if (response.getState() === "SUCCESS") {
                var responseList = response.getReturnValue();
                console.log('---responseList---' + responseList.length);
                //component.set("v.contratcsList",responseList);
                
                //below code is for remove seleceted while fetch contracts in table
                var slctpositions = component.get('v.selectedCardinalPosistions');
                var finalPositions = responseList.filter(comparer(slctpositions));
                
                function comparer(otherArray) {
                    return function (current) {
                        return otherArray.filter(function (other) {
                            console.log(other);
                            return other == current.Name
                        }).length == 0;
                    }
                }
                
                for (var i = 0; i < finalPositions.length; i++) {
                    var row = finalPositions[i];
                    if (row.Phoenix_Customer__c) {
                        row.Phoenix_Customer__c = row.Phoenix_Customer__r.Name;
                    }
                }
                component.set("v.cardinalPositionsList", finalPositions);
                component.set("v.isSpinner", false);
            }
        });
        $A.enqueueAction(action);
    },
    fetchMajorPositions: function (component, event, helper, bidCustomer) {
        console.log('bidCustomer---' + bidCustomer);
        var action = component.get("c.getPositions");
        action.setParams({
            customerID: bidCustomer
            // searchInput:searchInput
            
        });
        action.setCallback(this, function (response) {
            if (response.getState() === "SUCCESS") {
                var responseList = response.getReturnValue();
                console.log('---responseList---' + responseList.length);
                //component.set("v.contratcsList",responseList);
                
                //below code is for remove seleceted while fetch contracts in table
                var slctpositions = component.get('v.selectedMajorPosistions');
                var finalPositions = responseList.filter(comparer(slctpositions));
                
                function comparer(otherArray) {
                    return function (current) {
                        return otherArray.filter(function (other) {
                            console.log(other);
                            return other == current.Name
                        }).length == 0;
                    }
                }
                
                for (var i = 0; i < finalPositions.length; i++) {
                    var row = finalPositions[i];
                    if (row.Phoenix_Customer__c) {
                        row.Phoenix_Customer__c = row.Phoenix_Customer__r.Name;
                    }
                }
                component.set("v.majorPositionsList", finalPositions);
                component.set("v.isSpinner", false);
            }
        });
        $A.enqueueAction(action);
    },
    
    fetchContratcs : function(component,event,helper,bidCustomer,searchInput) {
        console.log('bidCustomer---'+bidCustomer);
        var action = component.get("c.getContracts");
        action.setParams
        ({
            customerID: bidCustomer,
            searchInput:searchInput
            
        }); 
        action.setCallback(this, function(response) 
                           {
                               if (response.getState() === "SUCCESS") {
                                   var responseList = response.getReturnValue();
                                   console.log('---responseList---'+responseList.length);
                                   //component.set("v.contratcsList",responseList);
                                   
                                   //below code is for remove seleceted while fetch contracts in table
                                   var sltcntcntrcs=component.get('v.selectedCntrcts');
                                   var finalContratcs = responseList.filter(comparer(sltcntcntrcs)); 
                                   function comparer(otherArray){
                                       return function(current){
                                           return otherArray.filter(function(other){                                               
                                               return other == current.Phoenix_Contract_Number__c 
                                           }).length == 0;
                                       }
                                   }
                                   
                                   for (var i = 0; i < finalContratcs.length; i++) {
                                       var row = finalContratcs[i];
                                       if(row.Phoenix_Customer__c){
                                           row.Phoenix_Customer__c=row.Phoenix_Customer__r.Name;                                           
                                       }                                      
                                   }
                                   component.set("v.contratcsList",finalContratcs);
                                   component.set("v.isSpinner", false);
                               }
                               
                               
                           });
        $A.enqueueAction(action);
    },
    getNPRDataOfContracts :  function(component,event,helper,selectrcs,templateType) {
        
        var action = component.get("c.getNPRData");
        action.setParams
        ({
            selectrcs: selectrcs,
            // currentCd : currentCd,
            BidId:component.get("v.recordId"),
            templateType:templateType
            
        }); 
        action.setCallback(this, function(response) 
                           {
                               if (response.getState() === "SUCCESS") {
                                   helper.searchProductFamilyChange(component, event,helper);
                               }
                               
                           });
        $A.enqueueAction(action);
    },
    convertArrayOfObjectsToCSV : function(component,objectRecords,template,bidType,isReBid){
        // declare variables
        var csvStringResult, counter, keys,columnDivider, lineDivider;
        
        // check if "objectRecords" parameter is null, then return from function
        if (objectRecords == null || !objectRecords.length) {
            return null;
        }
        // store ,[comma] in columnDivider variabel for sparate CSV values and 
        // for start next line use '\n' [new line] in lineDivider varaible  
        columnDivider = ',';
        lineDivider =  '\n';
        
        // in the keys valirable store fields API Names as a key 
        // this labels use in CSV file header 
        csvStringResult = '';
        var myMap = new Map();
        myMap.set("NDC","Phoenix_NDC__c");
        myMap.set("SAP Number","Phoenix_Product_Code1__c");
        myMap.set("Product Family","Phoenix_Product_Family__c");
        myMap.set("Pkg Size","Phoenix_Pkg_Size__c");
        myMap.set("Product Name","Phoenix_Product__r.Name");
        if(isReBid == true){
            myMap.set("Previous Bid", "Phoenix_Previous_Bid__r.Name");
            myMap.set("Previous Bid Line Item", "Phoenix_Previous_LineItem__r.Name");
        }
        myMap.set("Case Pack","Phoenix_Case_Pack__c");
        myMap.set("MOQ","Phoenix_MOQ1__c");
        myMap.set("Compared to (Brand Name)","Phoenix_Compare_To_Brand_Name1__c");
        myMap.set("Product Director","Phoenix_Product_Director__c");
        myMap.set("Orange Book rating","Phoenix_Orange_Book_Rating1__c");
        myMap.set("Throughput Cost","Phoenix_Throughput_cost__c");
        myMap.set("WAC","Phoenix_WAC__c");
        myMap.set("REMS Program","Phoenix_REMS__c");
        if(bidType != 'New Product Launch'){
            myMap.set("Current CVS/Cardinal/Major Postion","Phoenix_Current_Position__c");
        }
            myMap.set("Proposed CVS/Cardinal/Major Position","Phoenix_Proposed_Position__c");
            //myMap.set("Proposed Cardinal Position","BidLineItemsExtn__r[0].Phoenix_Proposed_Cardinal_Position__c");
            //myMap.set("Proposed Major Position","BidLineItemsExtn__r[0].Phoenix_Proposed_Major_Position__c");
         if(bidType != 'New Product Launch'){
            myMap.set("3 Months Annualized CVS Direct Selling Unit","Phoenix_Current_Retail_Direct_Units__c");
            myMap.set("3 Months Annualized CVS Indirect Selling Unit","Phoenix_Current_Retail_Indirect_Units__c");
            myMap.set("3 Months Annualized Cardinal Selling Unit","Phoenix_Current_Wholesaler_Units__c");
            myMap.set("3 Months Annualized Major Selling Unit","BidLineItemsExtn__r[0].Phoenix_3MonAnnualMajorSellingUnits__c");
            myMap.set("Total 3 Months Annualized Selling Units","BidLineItemsExtn__r[0].Phoenix_Total3MonAnnualSellingUnits__c");
            myMap.set("Actual 12 Months CVS Direct Selling Unit","Phoenix_12_Months_Actual_Sales__c");
            myMap.set("Actual 12 Months  CVS Indirect Selling Unit","Phoenix_12_Months_IndirectSaleUnit__c");
            myMap.set("Actual 12 Months  Cardinal Selling Unit","BidLineItemsExtn__r[0].Phoenix_Actual12MonCardinalSelUnits__c");
            myMap.set("Actual 12 Months  Major Selling Unit","BidLineItemsExtn__r[0].Phoenix_Actual12MonMajorSelUnit__c");
            myMap.set("Actual 12 Months Total  Sales Units","BidLineItemsExtn__r[0].Phoenix_Actual12MonTotalSaleUnits__c");
            myMap.set("Override CVS Direct  Units","Phoenix_Override_Current_Direct_Units__c");
            myMap.set("Override CVS Indirect  Units","Phoenix_Override_Current_Indirect_Units__c");
            myMap.set("Override Cardinal  Units","Phoenix_Override_Current_Units__c");
            myMap.set("Override Major  Units","BidLineItemsExtn__r[0].Phoenix_OverrideMajorUnits__c");
            myMap.set("Override Total Units","Phoenix_Override_Total_units__c");
            myMap.set("Doses","Phoenix_Doses__c");
        }
        if(bidType != 'Price Change' && bidType != 'Sales Out Rebate' && bidType != 'Customer Rebate Change'){
            myMap.set("Proposed CVS Direct Units(Current + Increment)","BidLineItemsExtn__r[0].Phoenix_Proposed_CVS_DirSellingUnits__c");
            myMap.set("Proposed CVS Indirect Units(Current + Increment)","BidLineItemsExtn__r[0].Phoenix_Proposed_CVS_IndirSellingUnits__c");
            myMap.set("Proposed Cardinal Units(Current + Increment)","BidLineItemsExtn__r[0].Phoenix_Proposed_Cardinal_Units__c");
            myMap.set("Proposed Major Units(Current + Increment)","BidLineItemsExtn__r[0].Phoenix_Proposed_Major_Units__c");
            myMap.set("Proposed Total Selling Units(Current + Increment)","Phoenix_Total_Selling_Unit__c");
            myMap.set("Final Direct Selling Units","Phoenix_Final_Direct_Selling_Units_Calc__c");
            myMap.set("Final Indirect Selling Units","Phoenix_Final_Indirect_Selling_Units_Cal__c");
            myMap.set("Final Total Selling Units","Phoenix_Final_Total_Selling_Unit__c");
            if(bidType != 'New Product Launch'){
                if(objectRecords[0].Phoenix_SCM_Final_Approval__c === true){
                    myMap.set("SCM Approved CVS Direct Units","Phoenix_Current_Anda_Units__c");
                    myMap.set("SCM Approved CVS Indirect Units","Phoenix_Current_Indirect_Gaint_EagleUnit__c");
                    myMap.set("SCM Approved Cardinal Units","Phoenix_ProposedIndirectAholdDelhaizeUni__c");
                    myMap.set("SCM Approved Major Units","Phoenix_Proposed_IndirectGaintEagleUnits__c");
                    myMap.set(" Total SCM Approved Qty","Phoenix_Total_SCM_Approved_Qty__c");
                }
                else{
                    myMap.set("SCM Approved CVS Direct Units","");
                    myMap.set("SCM Approved CVS Indirect Units","");
                    myMap.set("SCM Approved Cardinal Units","");
                    myMap.set("SCM Approved Major Units","");
                    myMap.set(" Total SCM Approved Qty","");
                }
            }
        }
        if(bidType != 'New Product Launch'){
            myMap.set("Current CVS Direct Contract Price","Phoenix_Current_Direct_Price__c");
            myMap.set("CVS Cash Terms","BidLineItemsExtn__r[0].Phoenix_CVS_Cash_Terms__c");
            myMap.set("CVS Fees","BidLineItemsExtn__r[0].Phoenix_CVS_Fees__c");
            myMap.set("Current Cardinal Contract Price","Phoenix_Current_Wholesaler_Price__c");
            myMap.set("Cardinal Cash Terms","BidLineItemsExtn__r[0].Phoenix_Cardinal_Cash_Terms__c");
            myMap.set("Current Cardinal Rebates %","Phoenix_Current_Rebate__c");
            myMap.set("Cardinal Rebates","BidLineItemsExtn__r[0].Phoenix_Cardinal_Rebates__c");
            myMap.set("Current Major Contract Price","BidLineItemsExtn__r[0].Phoenix_Current_Major_Contract_Price__c");
            myMap.set("Major Cash Terms","BidLineItemsExtn__r[0].Phoenix_Major_Cash_Terms__c");
            myMap.set("Current Major Rebates %","Phoenix_Proposed_Current_Rebate__c");
            myMap.set("Major Rebates","BidLineItemsExtn__r[0].Phoenix_Major_Rebates__c");
            myMap.set("Current CVS Direct Acquisition Costs","Phoenix_Current_Anda_Acquisition_Costs__c");
            myMap.set("Current Cardinal Acquisition Costs","Phoenix_Anda_Old_Acqusition_Costs__c");
            myMap.set("Current Major Acquisition Costs","BidLineItemsExtn__r[0].Phoenix_Current_Major_Acquisition_Costs__c");
            myMap.set("Current CVS Indirect Contract Price","Phoenix_Current_Indirect_Price__c");
        }
        if(bidType != 'Volume Review Only' && bidType != 'Sales Out Rebate'){
            myMap.set("Guidance Price/Acquisition costs","Phoenix_Guidance_Price__c");
            myMap.set("Proposed Sales CVS/Cardinal/Major Acquisition Costs/CVS Deadnet","Phoenix_ProposedContract_Bid_Price_Sales__c");
            //myMap.set("Proposed Cardinal Sales Price","BidLineItemsExtn__r[0].Phoenix_Proposed_Cardinal_Sales_Price__c");
            //myMap.set("Proposed Major Sales Price","BidLineItemsExtn__r[0].Phoenix_Proposed_Major_Sales_Price__c");
        }
        if(bidType != 'New Product Launch' && bidType != 'Volume Review Only' && bidType != 'Sales Out Rebate'){
            myMap.set("% Reduction for Acquisition Costs","Phoenix_Reduction__c");
        }//myMap.set("Proposed Marketing Price","");
        if(bidType == 'New Product Launch'){
            //myMap.set("Current Supplier for Cardinal","Phoenix_Current_Supplier__c");
            //myMap.set("Current Supplier for Major","BidLineItemsExtn__r[0].Phoenix_Current_Supplier_Major__c");
            myMap.set("Brand WAC","Brand_WAC__c");
            myMap.set("% Brand WAC for CVS","BidLineItemsExtn__r[0].Phoenix_CVS_Brand_WAC_Perc__c");
            myMap.set("% Brand WAC for Cardinal","Phoenix_Brand_WAC_Per__c");
            myMap.set("% Brand WAC for Major","BidLineItemsExtn__r[0].Phoenix_Major_Brand_WAC_Per__c");
        }
        if(bidType != 'Volume Review Only' && bidType != 'Sales Out Rebate'){
            myMap.set("Proposed Marketing CVS/Cardinal/Major Acquisition Costs/CVS Deadnet","BidLineItemsExtn__r[0].Phoenix_PropMarktCvsCardinalAcquisitCost__c");
            myMap.set("Proposed CVS Direct  Contract Price","BidLineItemsExtn__r[0].Phoenix_Proposed_CvsDirectContractPrice__c");
            myMap.set("Proposed CVS Indirect Contract Price","Phoenix_ProposedContractBidPriceMktng__c");
            myMap.set("Proposed Cardinal Contract Price ","Phoenix_Wholesaler_Diff_Price_Indirect__c");
            myMap.set("Preferred Cardinal Rebate %","BidLineItemsExtn__r[0].Phoenix_Preferred_Cardinal_Rebate_per__c");
            myMap.set("Proposed Major Contract Price ","BidLineItemsExtn__r[0].Phoenix_Proposed_Major_Contract_Price__c");
            myMap.set("Preferred Major Rebate %","BidLineItemsExtn__r[0].Phoenix_Major_Rebate_per__c");
        }
        myMap.set("Cash Discount","Phoenix_Direct_CD__c");
        myMap.set("Service Fee (1.5%)","BidLineItemsExtn__r[0].Phoenix_Service_Fee__c");
        myMap.set("Wholesaler Controlled Substance Fee$", "Phoenix_Whlsr_Controlled_Substance_Fee__c");
        myMap.set("Internal CVS Direct Dead Net","Phoenix_Direct_Dead_Net__c");
        myMap.set("CVS Direct TPT $","Phoenix_Direct_TP_In__c");
        myMap.set("CVS Direct TPT %","Phoenix_Direct_TP__c");
        myMap.set("ZITD","BidLineItemsExtn__r[0].Phoenix_ZITD__c");
        myMap.set("CD","Phoenix_INDIRECT_CD__c");
        myMap.set("RDC Fees","Phoenix_RDC_NLC__c");
        myMap.set("CM Fees","Phoenix_Contract_Mngmnt_Fee_Wholesaler__c");
        myMap.set("Internal CVS Indirect Dead Net","Phoenix_Indirect_Dead_Net__c");
        myMap.set("CVS Indirect TPT $","Indirect_TP__c");
        myMap.set("CVS Indirect TPT %","Phoenix_Indirect_TP__c");
        myMap.set("Cash Discount on WAC","Phoenix_INDIRECT_CD__c");
        myMap.set("Cardinal Preferred Rebate $","Phoenix_Net_Price_after_Rebates_Terms__c");
        myMap.set(" NLC Fees ","Phoenix_NLC__c");
        myMap.set(" Cardinal Additional Rebate $ ","BidLineItemsExtn__r[0].Phoenix_CardinalAdditionalRebate__c");
        myMap.set(" Internal Cardinal Dead Net ","Phoenix_Customer_Dead_Net1__c");
        myMap.set(" Cardinal TPT $ ","BidLineItemsExtn__r[0].Phoenix_Cardinal_TPT_perUnit__c");
        myMap.set(" Cardinal TPT % ","BidLineItemsExtn__r[0].Phoenix_Cardinal_TPT_Per_perUnit__c");
        myMap.set("Major Preferred Rebate $","Phoenix_Net_Price_after_RebatesbeforeVIP__c");
        myMap.set(" Major Additional Rebate $ ","BidLineItemsExtn__r[0].Phoenix_Major_Additional_Rebate__c");
        myMap.set(" Internal Major Dead Net ","BidLineItemsExtn__r[0].Phoenix_Internal_Major_Dead_Net__c");
        myMap.set(" Major TPT $ ","BidLineItemsExtn__r[0].Phoenix_Major_TPT_perUnit__c");
        myMap.set(" Major TPT % ","BidLineItemsExtn__r[0].Phoenix_Major_TPT_Per_perUnit__c");
        if(bidType == 'RFP Bids' ||bidType == 'New Product Launch'|| bidType == 'Product Addition'){
            myMap.set(" Cardinal IOD per unit ","Phoenix_Retail_IOD_per_unit__c");
            myMap.set(" Major IOD per unit ","Phoenix_Wholesaler_IOD_per_unit__c");
            myMap.set(" Cardinal IOD overall amount $ ","Phoenix_IOD_Total_Amount__c");
            myMap.set(" Major IOD overall amount $ ","Phoenix_Wholesaler_IOD_overall_amount__c");
        }
        myMap.set(" Medicaid & Returns  per unit ","Phoenix_Estimated_Medicaid_Returns__c");
        myMap.set(" CVS Direct Net Sales ","Proposed_Net_Sales_Direct__c");
        myMap.set(" CVS Indirect Net Sales ","Proposed_Net_Sales_Indirect__c");
        myMap.set(" CVS Total Net Sales ","BidLineItemsExtn__r[0].Phoenix_CVS_Total_Net_Sales__c");
        myMap.set(" CVS Direct TPT $ ","BidLineItemsExtn__r[0].Phoenix_CVS_Direct_TPT__c");
        myMap.set(" CVS Indirect TPT $ ","BidLineItemsExtn__r[0].Phoenix_CVS_Indirect_TPT__c");
        myMap.set(" CVS Total  TPT $ ","BidLineItemsExtn__r[0].Phoenix_CVS_Total_TPT__c");
        myMap.set(" CVS Direct TPT % ","BidLineItemsExtn__r[0].Phoenix_CVS_Direct_TPT_Per__c");
        myMap.set(" CVS Indirect TPT % ","BidLineItemsExtn__r[0].Phoenix_CVS_Indirect_TPT_Per__c");
        myMap.set(" CVS Total  TPT % ","BidLineItemsExtn__r[0].Phoenix_CVS_Total_TPT_Per__c");
        if(bidType == 'New Product Launch'){
            myMap.set(" Opening Order for CVS ","BidLineItemsExtn__r[0].Opening_Order_CVS__c");
            myMap.set(" Opening Order Net Sales for CVS ","BidLineItemsExtn__r[0].Opening_Order_Net_Sales_for_CVS__c");
            myMap.set(" Opening Order TPT $ for CVS ","BidLineItemsExtn__r[0].Opening_Order_TPT_for_CVS__c");
            myMap.set(" Opening Order TPT % for CVS ","BidLineItemsExtn__r[0].Opening_Order_TPT_Perc_for_CVS__c");
        }
        myMap.set(" Cardinal Net Sales ","Phoenix_Wholesaler_Net_Sales__c");
        myMap.set("Cardinal TPT $","BidLineItemsExtn__r[0].Phoenix_Cardinal_TPT__c");
        myMap.set("Cardinal TPT %","BidLineItemsExtn__r[0].Phoenix_Cardinal_TPT_Per__c");
        if(bidType == 'New Product Launch'){
            myMap.set(" Opening Order for Cardinal ","Phoenix_Opening_Order__c");
            myMap.set(" Opening Order Net Sales for Cardinal ","Phoenix_Opening_Order_Net_sales__c");
            myMap.set(" Opening Order TPT $ for Cardinal ","Phoenix_Opening_Order_TPT__c");
            myMap.set(" Opening Order TPT % for Cardinal ","Phoenix_Opening_Order_TPT_Per__c");
        }
        myMap.set(" Major Net Sales ","BidLineItemsExtn__r[0].Phoenix_Major_Net_Sales__c");
        myMap.set("Major TPT $","BidLineItemsExtn__r[0].Phoenix_Major_TPT__c");
        myMap.set("Major TPT %","BidLineItemsExtn__r[0].Phoenix_Major_TPT_Per__c");
        if(bidType == 'New Product Launch'){
            myMap.set(" Opening Order for Major ","BidLineItemsExtn__r[0].Phoenix_Opening_Order_Major__c");
            myMap.set(" Opening Order Net Sales for Major ","BidLineItemsExtn__r[0].Phoenix_Opening_Order_Major_Net_sales__c");
            myMap.set(" Opening Order TPT $ for Major ","BidLineItemsExtn__r[0].Phoenix_Opening_Order_Major_TPT__c");
            myMap.set(" Opening Order TPT % for Major ","BidLineItemsExtn__r[0].Phoenix_Opening_Order_Major_TPT_Per__c");
        }
        myMap.set(" Total RedOak Net Sales ","Phoenix_Net_Sales_Internal__c");
        myMap.set(" Total RedOak TPT $ ","BidLineItemsExtn__r[0].Phoenix_Total_RedOak_TPT__c");
        myMap.set(" Total RedOak TPT % ","BidLineItemsExtn__r[0].Phoenix_Total_RedOak_TPT_Per__c");
        myMap.set(" Budgeted ASP ","Phoenix_Budgeted_ASP1__c");
        myMap.set(" Proposed as % of Budget ","Phoenix_Proposed_to_Budget__c");
        myMap.set(" Latest Estimate ASP ","Phoenix_Latest_Estimate__c");
        myMap.set(" Proposed as % of Latest Estimate ","Phoenix_Proposed_as_of_Latest_Estimate__c");
        myMap.set(" Lowest Price / SKU ","Phoenix_Lowest_Price_SKU__c");
        myMap.set("Approved Lowest Price /SKU","Phoenix_Approved_Lowest_Price_SKU__c");
        if(bidType != 'Price Change' && bidType != 'Sales Out Rebate' && bidType != 'Customer Rebate Change'){
            if(bidType != 'New Product Launch'){
                myMap.set("Initial Stocking Order Volume","Phoenix_Initial_Stocking_Order_Volume__c");
                myMap.set("Initial Stocking Order Comments","Phoenix_Initial_Stocking_Order_Comments__c");
                myMap.set("Estimated Lead time","Phoenix_Estimated_Lead_Time_Days__c");
                myMap.set("SCM Approval (Y/N)","Phoenix_SCM_Approval_Y_N__c");
            }
            else{
                myMap.set("Opening Order Comments","Phoenix_Initial_Stocking_Order_Comments__c");
                myMap.set("Estimated Lead time","Phoenix_Estimated_Lead_Time_Days__c");
            }
        }
        if(bidType != 'New Product Launch'){
            myMap.set(" SCM Comments ","Phoenix_SCM_Notes__c");
        }
        myMap.set(" Sales Notes ","Phoenix_Sales_Notes__c");
        if(bidType != 'Volume Review Only'){
            myMap.set(" Marketing Approval ","Phoenix_Marketing_Approval__c");
        }
        myMap.set(" Marketing Notes ","Phoenix_Marketing_Notes__c");
        if(bidType != 'Volume Review Only'){
            myMap.set(" Finance Approval ","Phoenix_Finance_Approval__c");
            myMap.set(" Finance Comments ","Phoenix_Finance_Comments__c");
        }
        myMap.set(" Contract Status ","Phoenix_Contract_Approval__c");
        myMap.set(" Contract Comments ","Phoenix_Contract_Comments__c");
        myMap.set(" WAC Check ","Phoenix_WAC_Check__c");
        if(bidType == 'RFP Bids' || bidType == 'New Product Launch'|| bidType == 'Product Addition'){
            myMap.set(" IOD Quantity (Runded to MOQ) ","Phoenix_IOD_Qty__c");
        }
        csvStringResult += Array.from(myMap.keys()).join(columnDivider);
        csvStringResult += lineDivider;
        //new logic start 
        for(var i=0; i < objectRecords.length; i++){  
            counter = 0;
            for (let [key, value] of myMap) {
                if(counter > 0){ 
                    csvStringResult += columnDivider; 
                }
                console.log('testing result--->'+JSON.stringify(objectRecords[i]));
                 //console.log('proposed cardinal uinits--->'+JSON.stringify(objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Proposed_Cardinal_Position__c))
                if(value=='Phoenix_Product__r.Name'){
                    csvStringResult += '"'+ objectRecords[i]["Phoenix_Product__r"]["Name"]+'"';
                }
                //objectRecords[i].BidLineItemsExtn__r[0][Phoenix_Proposed_Major_Units__c]
               
                else if(value=='Phoenix_Previous_Bid__r.Name'){	
                    if(objectRecords[i]['Phoenix_Is_Re_Bid_Line_Item__c']== true){
                        csvStringResult += '"'+ objectRecords[i]["Phoenix_Previous_Bid__r"]["Name"]+'"';
                    }
                    
                }
                    else if(value=='Phoenix_Previous_LineItem__r.Name') {
                        if(objectRecords[i]['Phoenix_Is_Re_Bid_Line_Item__c']== true){
                            csvStringResult += '"'+ objectRecords[i]["Phoenix_Previous_LineItem__r"]["Name"]+'"';
                        }
                    }
               /* else if(value=='Phoenix_Estimated_Lead_Time_Days__c') {
                    var estleadtime = objectRecords[i]["Phoenix_Estimated_Lead_Time_Days__c"];
                    if(estleadtime != null){
                      csvStringResult += '"'+estleadtime+'"';
                    }
                    else{
                       csvStringResult += '"'+''+'"'; 
                    }
                 
                }*/
                else if(value=='Phoenix_Proposed_Current_Rebate__c'){
                    csvStringResult += '"'+objectRecords[i]["Phoenix_Proposed_Current_Rebate__c"]+'"';   
                    }
                else if(value=='Phoenix_Current_Rebate__c'){
                    csvStringResult += '"'+objectRecords[i]["Phoenix_Current_Rebate__c"]+'"';   
                    }
                        else if(value=='Phoenix_Final_Direct_Selling_Units_Calc__c'){
                            var dirunits = objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Proposed_CVS_DirSellingUnits__c != undefined ? objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Proposed_CVS_DirSellingUnits__c : 0;
                            csvStringResult += '"'+dirunits+'"';    
                        }
                            else if(value=='Phoenix_Final_Indirect_Selling_Units_Cal__c'){
                                var indirUnits = objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Proposed_CVS_IndirSellingUnits__c != undefined ? 
                                    objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Proposed_CVS_IndirSellingUnits__c : 0;
                                var cardinalUnits = objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Proposed_Cardinal_Units__c != undefined ? 
                                    objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Proposed_Cardinal_Units__c : 0;
                                var majorUnits = objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Proposed_Major_Units__c != undefined ? 
                                    objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Proposed_Major_Units__c : 0;
                                var indireTotalUnits = indirUnits + cardinalUnits + majorUnits;
                                csvStringResult += '"'+indireTotalUnits+'"';    
                            }
                                else if(value=='Phoenix_Final_Total_Selling_Unit__c'){
                                    var dirunits = objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Proposed_CVS_DirSellingUnits__c != undefined ? objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Proposed_CVS_DirSellingUnits__c : 0;
                                    var indirUnits = objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Proposed_CVS_IndirSellingUnits__c != undefined ? 
                                        objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Proposed_CVS_IndirSellingUnits__c : 0;
                                    var cardinalUnits = objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Proposed_Cardinal_Units__c != undefined ? 
                                        objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Proposed_Cardinal_Units__c : 0;
                                    var majorUnits = objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Proposed_Major_Units__c != undefined ? 
                                        objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Proposed_Major_Units__c : 0;
                                    var totalUnits = dirunits + indirUnits + cardinalUnits + majorUnits;
                                    csvStringResult += '"'+totalUnits+'"';   
                                }
                /*Added by Satya*/
               
                else if(value=='BidLineItemsExtn__r[0].Phoenix_Proposed_Cardinal_Position__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Proposed_Cardinal_Position__c != undefined ) {
                        csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Proposed_Cardinal_Position__c+'"';    
                    }
                else if(value=='BidLineItemsExtn__r[0].Phoenix_Proposed_Major_Position__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Proposed_Major_Position__c != undefined) {
                        csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Proposed_Major_Position__c+'"';    
                    }
                 else if(value=='BidLineItemsExtn__r[0].Phoenix_3MonAnnualMajorSellingUnits__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_3MonAnnualMajorSellingUnits__c != undefined) {
                        csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_3MonAnnualMajorSellingUnits__c+'"';    
                    }
                else if(value=='BidLineItemsExtn__r[0].Phoenix_Total3MonAnnualSellingUnits__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Total3MonAnnualSellingUnits__c != undefined) {
                        csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Total3MonAnnualSellingUnits__c+'"';    
                    }
                 else if(value=='BidLineItemsExtn__r[0].Phoenix_Actual12MonCardinalSelUnits__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Actual12MonCardinalSelUnits__c !=undefined) {
                        csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Actual12MonCardinalSelUnits__c+'"';    
                    }
                else if(value=='BidLineItemsExtn__r[0].Phoenix_Actual12MonMajorSelUnit__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Actual12MonMajorSelUnit__c != undefined) {
                        csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Actual12MonMajorSelUnit__c+'"';    
                    }
                else if(value=='BidLineItemsExtn__r[0].Phoenix_Actual12MonTotalSaleUnits__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Actual12MonTotalSaleUnits__c != undefined) {
                        csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Actual12MonTotalSaleUnits__c+'"';    
                    }
                else if(value=='BidLineItemsExtn__r[0].Phoenix_OverrideMajorUnits__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_OverrideMajorUnits__c != undefined) {
                        csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_OverrideMajorUnits__c+'"';    
                    }
                
                else if(value=='BidLineItemsExtn__r[0].Phoenix_Proposed_Cardinal_Units__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Proposed_Cardinal_Units__c != undefined) {
                        csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Proposed_Cardinal_Units__c+'"';    
                    }
                else if(value=='BidLineItemsExtn__r[0].Phoenix_Proposed_CVS_DirSellingUnits__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Proposed_CVS_DirSellingUnits__c != undefined) {
                        csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Proposed_CVS_DirSellingUnits__c+'"';    
                    }
                else if(value=='BidLineItemsExtn__r[0].Phoenix_Proposed_CVS_IndirSellingUnits__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Proposed_CVS_IndirSellingUnits__c != undefined) {
                        csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Proposed_CVS_IndirSellingUnits__c+'"';    
                    }
                
                else if(value=='BidLineItemsExtn__r[0].Phoenix_Proposed_Major_Units__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Proposed_Major_Units__c !=undefined) {
                        csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Proposed_Major_Units__c+'"';    
                    }
                else if(value=='Phoenix_Total_Selling_Unit__c') {
                    var totalSellingUnits = (objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Proposed_CVS_DirSellingUnits__c !=null ? objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Proposed_CVS_DirSellingUnits__c : 0) + (objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Proposed_CVS_IndirSellingUnits__c != null ? objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Proposed_CVS_IndirSellingUnits__c : 0) + (objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Proposed_Cardinal_Units__c != null ? objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Proposed_Cardinal_Units__c : 0) + (objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Proposed_Major_Units__c != null? objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Proposed_Major_Units__c :0);
                        csvStringResult += '"'+totalSellingUnits+'"';    
                    }
                
                else if(value=='BidLineItemsExtn__r[0].Phoenix_CVS_Cash_Terms__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_CVS_Cash_Terms__c != undefined) {
                        csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_CVS_Cash_Terms__c+'"';    
                    }
                else if(value=='BidLineItemsExtn__r[0].Phoenix_CVS_Fees__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_CVS_Fees__c != undefined) {
                        csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_CVS_Fees__c+'"';    
                    }
                else if(value=='BidLineItemsExtn__r[0].Phoenix_Cardinal_Cash_Terms__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Cardinal_Cash_Terms__c != undefined) {
                        csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Cardinal_Cash_Terms__c+'"';    
                    }
                else if(value=='BidLineItemsExtn__r[0].Phoenix_Cardinal_Rebates__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Cardinal_Rebates__c !=undefined) {
                        csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Cardinal_Rebates__c+'"';    
                    }
                else if(value=='BidLineItemsExtn__r[0].Phoenix_Current_Major_Contract_Price__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Current_Major_Contract_Price__c != undefined) {
                        csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Current_Major_Contract_Price__c+'"';    
                    }
                else if(value=='BidLineItemsExtn__r[0].Phoenix_Major_Cash_Terms__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Major_Cash_Terms__c != undefined) {
                        csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Major_Cash_Terms__c+'"';    
                    }
                else if(value=='BidLineItemsExtn__r[0].Phoenix_Major_Rebates__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Major_Rebates__c != undefined) {
                        csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Major_Rebates__c+'"';    
                    }
                else if(value=='BidLineItemsExtn__r[0].Phoenix_Current_Major_Acquisition_Costs__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Current_Major_Acquisition_Costs__c != undefined) {
                        csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Current_Major_Acquisition_Costs__c+'"';    
                    }
              /*  else if(value=='BidLineItemsExtn__r[0].Phoenix_Proposed_Cardinal_Sales_Price__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Proposed_Cardinal_Sales_Price__c != undefined) {
                        csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Proposed_Cardinal_Sales_Price__c+'"';    
                    }
                else if(value=='BidLineItemsExtn__r[0].Phoenix_Proposed_Major_Sales_Price__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Proposed_Major_Sales_Price__c != undefined) {
                        csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Proposed_Major_Sales_Price__c+'"';    
                    }*/
                else if(value=='BidLineItemsExtn__r[0].Phoenix_Current_Supplier_Major__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Current_Supplier_Major__c != undefined) {
                        csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Current_Supplier_Major__c+'"';    
                    }
                else if(value=='BidLineItemsExtn__r[0].Phoenix_CVS_Brand_WAC_Perc__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_CVS_Brand_WAC_Perc__c != undefined) {
                        csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_CVS_Brand_WAC_Perc__c+'"';    
                    }
                else if(value=='BidLineItemsExtn__r[0].Phoenix_Major_Brand_WAC_Per__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Major_Brand_WAC_Per__c != undefined) {
                        csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Major_Brand_WAC_Per__c+'"';    
                    }
                else if(value=='BidLineItemsExtn__r[0].Phoenix_PropMarktCvsCardinalAcquisitCost__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_PropMarktCvsCardinalAcquisitCost__c != undefined) {
                        csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_PropMarktCvsCardinalAcquisitCost__c+'"';    
                    }
                else if(value=='BidLineItemsExtn__r[0].Phoenix_Proposed_CvsDirectContractPrice__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Proposed_CvsDirectContractPrice__c != undefined) {
                        csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Proposed_CvsDirectContractPrice__c+'"';    
                    }
                else if(value=='BidLineItemsExtn__r[0].Phoenix_Preferred_Cardinal_Rebate_per__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Preferred_Cardinal_Rebate_per__c != undefined) {
                        csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Preferred_Cardinal_Rebate_per__c+'"';    
                    }
                else if(value=='BidLineItemsExtn__r[0].Phoenix_Proposed_Major_Contract_Price__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Proposed_Major_Contract_Price__c != undefined) {
                        csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Proposed_Major_Contract_Price__c+'"';    
                    }
                else if(value=='BidLineItemsExtn__r[0].Phoenix_Major_Rebate_per__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Major_Rebate_per__c != undefined) {
                        csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Major_Rebate_per__c+'"';    
                    }
                else if(value=='BidLineItemsExtn__r[0].Phoenix_Service_Fee__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Service_Fee__c != undefined) {
                        csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Service_Fee__c+'"';    
                    }
                else if(value=='BidLineItemsExtn__r[0].Phoenix_ZITD__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_ZITD__c != undefined) {
                        csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_ZITD__c+'"';    
                    }
                else if(value=='BidLineItemsExtn__r[0].Phoenix_CardinalAdditionalRebate__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_CardinalAdditionalRebate__c != undefined) {
                        csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_CardinalAdditionalRebate__c+'"';    
                    }
                else if(value=='BidLineItemsExtn__r[0].Phoenix_Cardinal_TPT_perUnit__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Cardinal_TPT_perUnit__c != undefined) {
                        csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Cardinal_TPT_perUnit__c+'"';    
                    }
                else if(value=='BidLineItemsExtn__r[0].Phoenix_Cardinal_TPT_Per_perUnit__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Cardinal_TPT_Per_perUnit__c != undefined) {
                        csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Cardinal_TPT_Per_perUnit__c+'"';    
                    }
                else if(value=='BidLineItemsExtn__r[0].Phoenix_Major_Additional_Rebate__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Major_Additional_Rebate__c != undefined) {
                        csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Major_Additional_Rebate__c+'"';    
                    }
                else if(value=='BidLineItemsExtn__r[0].Phoenix_Internal_Major_Dead_Net__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Internal_Major_Dead_Net__c != undefined ) {
                        csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Internal_Major_Dead_Net__c+'"';    
                    }
                 else if(value=='BidLineItemsExtn__r[0].Phoenix_Major_TPT_perUnit__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Major_TPT_perUnit__c != undefined) {
                        csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Major_TPT_perUnit__c+'"';    
                    }
                else if(value=='BidLineItemsExtn__r[0].Phoenix_Major_TPT_Per_perUnit__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Major_TPT_Per_perUnit__c != undefined) {
                        csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Major_TPT_Per_perUnit__c+'"';    
                    }
                else if(value=='BidLineItemsExtn__r[0].Phoenix_CVS_Total_Net_Sales__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_CVS_Total_Net_Sales__c != undefined) {
                        csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_CVS_Total_Net_Sales__c+'"';    
                    }
                else if(value=='BidLineItemsExtn__r[0].Phoenix_CVS_Direct_TPT__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_CVS_Direct_TPT__c != undefined ) {
                        csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_CVS_Direct_TPT__c+'"';    
                    }
                else if(value=='BidLineItemsExtn__r[0].Phoenix_CVS_Indirect_TPT__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_CVS_Indirect_TPT__c != undefined) {
                        csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_CVS_Indirect_TPT__c+'"';    
                    }
                else if(value=='BidLineItemsExtn__r[0].Phoenix_CVS_Total_TPT__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_CVS_Total_TPT__c !=undefined ) {
                        csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_CVS_Total_TPT__c+'"';    
                    }
                else if(value=='BidLineItemsExtn__r[0].Phoenix_CVS_Direct_TPT_Per__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_CVS_Direct_TPT_Per__c != undefined) {
                        csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_CVS_Direct_TPT_Per__c+'"';    
                    }
                else if(value=='BidLineItemsExtn__r[0].Phoenix_CVS_Indirect_TPT_Per__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_CVS_Indirect_TPT_Per__c != undefined) {
                        csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_CVS_Indirect_TPT_Per__c+'"';    
                    }
                else if(value=='BidLineItemsExtn__r[0].Phoenix_CVS_Total_TPT_Per__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_CVS_Total_TPT_Per__c != undefined) {
                        csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_CVS_Total_TPT_Per__c+'"';    
                    }
                else if(value=='BidLineItemsExtn__r[0].Opening_Order_CVS__c' && objectRecords[i].BidLineItemsExtn__r[0].Opening_Order_CVS__c != undefined) {
                        csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Opening_Order_CVS__c+'"';    
                    }
                else if(value=='BidLineItemsExtn__r[0].Opening_Order_Net_Sales_for_CVS__c' && objectRecords[i].BidLineItemsExtn__r[0].Opening_Order_Net_Sales_for_CVS__c != undefined) {
                        csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Opening_Order_Net_Sales_for_CVS__c+'"';    
                    }
                else if(value=='BidLineItemsExtn__r[0].Opening_Order_TPT_for_CVS__c' && objectRecords[i].BidLineItemsExtn__r[0].Opening_Order_TPT_for_CVS__c != undefined) {
                        csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Opening_Order_TPT_for_CVS__c+'"';    
                    }
                else if(value=='BidLineItemsExtn__r[0].Opening_Order_TPT_Perc_for_CVS__c' && objectRecords[i].BidLineItemsExtn__r[0].Opening_Order_TPT_Perc_for_CVS__c != undefined) {
                        csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Opening_Order_TPT_Perc_for_CVS__c+'"';    
                    }
                else if(value=='BidLineItemsExtn__r[0].Phoenix_Cardinal_TPT__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Cardinal_TPT__c != undefined ) {
                        csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Cardinal_TPT__c+'"';    
                    }
                else if(value=='BidLineItemsExtn__r[0].Phoenix_Cardinal_TPT_Per__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Cardinal_TPT_Per__c != undefined) {
                        csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Cardinal_TPT_Per__c+'"';    
                    }
                else if(value=='BidLineItemsExtn__r[0].Phoenix_Major_Net_Sales__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Major_Net_Sales__c != undefined) {
                        csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Major_Net_Sales__c+'"';    
                    }
                else if(value=='BidLineItemsExtn__r[0].Phoenix_Major_TPT__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Major_TPT__c != undefined) {
                        csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Major_TPT__c+'"';    
                    }
                else if(value=='BidLineItemsExtn__r[0].Phoenix_Major_TPT_Per__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Major_TPT_Per__c != undefined) {
                        csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Major_TPT_Per__c+'"';    
                    }
                else if(value=='BidLineItemsExtn__r[0].Phoenix_Opening_Order_Major__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Opening_Order_Major__c != undefined ) {
                        csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Opening_Order_Major__c+'"';    
                    }
                else if(value=='BidLineItemsExtn__r[0].Phoenix_Opening_Order_Major_Net_sales__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Opening_Order_Major_Net_sales__c != undefined) {
                        csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Opening_Order_Major_Net_sales__c+'"';    
                    }
                else if(value=='BidLineItemsExtn__r[0].Phoenix_Opening_Order_Major_TPT__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Opening_Order_Major_TPT__c != undefined) {
                        csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Opening_Order_Major_TPT__c+'"';    
                    }
                else if(value=='BidLineItemsExtn__r[0].Phoenix_Opening_Order_Major_TPT_Per__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Opening_Order_Major_TPT_Per__c != undefined) {
                        csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Opening_Order_Major_TPT_Per__c+'"';    
                    }
                else if(value=='BidLineItemsExtn__r[0].Phoenix_Total_RedOak_TPT__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Total_RedOak_TPT__c != undefined) {
                        csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Total_RedOak_TPT__c+'"';    
                    }
                else if(value=='BidLineItemsExtn__r[0].Phoenix_Total_RedOak_TPT_Per__c' && objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Total_RedOak_TPT_Per__c != undefined ) {
                        csvStringResult += '"'+objectRecords[i].BidLineItemsExtn__r[0].Phoenix_Total_RedOak_TPT_Per__c+'"';    
                    }
                    
                else if(value == 'Phoenix_REMS__c' ){
                    var rems_value= objectRecords[i]['Phoenix_REMS__c'];
                    if(rems_value == true){
                       csvStringResult += '"'+ 'Yes'+'"'; 
                    }
                    else{
                        csvStringResult += '"'+ 'No'+'"'; 
                    }
                }
              /* else if(value == 'Phoenix_Total_SCM_Approved_Qty__c' || value == 'Phoenix_Estimated_Lead_Time_Days__c' || value == 'Phoenix_SCM_Rejection_Reason1__c' ||value == 'Phoenix_SCM_Approval_Y_N__c'||value == 'Phoenix_SCM_Notes__c'){
                  if(objectRecords[i]["Phoenix_SCM_Final_Approval__c"] == true && objectRecords[i]["Phoenix_SCM_Approval_Y_N__c"]!='N- Not Approved'&& objectRecords[i]["Phoenix_SCM_Approval_Y_N__c"]!=''){
                      console.log('scm approval status is true');
                      if(objectRecords[i][value]==undefined){
       
                       	csvStringResult += '"'+''+'"';
                    	}   
                      else{
                          csvStringResult += '"'+ objectRecords[i][value]+'"'; 
                      }
                  }
                   
                    else {
                        csvStringResult += '"'+''+'"';
                        console.log('scm approval status is false');
                    }                    
                 }*/
                else if (value == 'Phoenix_Total_SCM_Approved_Qty__c' || value == 'Phoenix_Estimated_Lead_Time_Days__c' || value == 'Phoenix_SCM_Rejection_Reason1__c' || value == 'Phoenix_SCM_Approval_Y_N__c' || value == 'Phoenix_SCM_Notes__c') {
                    if (objectRecords[i]["Phoenix_SCM_Final_Approval__c"] == true && objectRecords[i]["Phoenix_SCM_Approval_Y_N__c"] != 'N- Not Approved' && objectRecords[i]["Phoenix_SCM_Approval_Y_N__c"] != '') {
                        // console.log('scm approval status is true');
                        if (objectRecords[i][value] == undefined) {
                            //console.log('Iam in last ELSEE if---->');
                            csvStringResult += '"' + '' + '"';
                        } else {
                            csvStringResult += '"' + objectRecords[i][value] + '"';
                        }
                    } 
                    else {
                         if(bidType == "New Product Launch" && value == 'Phoenix_Estimated_Lead_Time_Days__c'){
                             if (objectRecords[i][value] == undefined) {
                                 csvStringResult += '"'+''+'"';
                             }
                             else{
                                 csvStringResult += '"'+ objectRecords[i][value]+'"';  
                                 
                             }
                            
                        }
                        else{
                              csvStringResult += '"'+''+'"';
                        }
                    }
                }
                else if(value == 'Phoenix_Finance_Approval__c'||value == 'Phoenix_Finance_Comments__c'){
                 	 if(objectRecords[i]["Phoenix_Final_Finance_Approval__c"]==true){
						if(objectRecords[i][value]==undefined){
                        //console.log('Iam in last ELSEE if---->');
                       	csvStringResult += '"'+''+'"';
                    	}   
                      else{
                          csvStringResult += '"'+ objectRecords[i][value]+'"'; 
                      }
                     }
                 }
               
                 /* else if(objectRecords[i].BidLineItemsExtn__r[0][value]==undefined){
                        console.log('boom');
                     	console.log('tes-->'+objectRecords[i].BidLineItemsExtn__r[0][value])
                        csvStringResult += '"'+''+'"';
                    }*/
                else if(objectRecords[i][value]==undefined){
                        console.log('Iam in last ELSEE if---->');
                        csvStringResult += '"'+''+'"';
                    }
                
                 else{
                        csvStringResult += '"'+ objectRecords[i][value]+'"';
                    }
                /*End by Satya*/
                        
                           
            counter++;
            }
            csvStringResult += lineDivider;
        }
        //new logic end 
        return csvStringResult;        
    },
    submitForProceed : function(component,event,helper,isContracts){ 
        component.set('v.isSpinnerLoad',true);
        var ismarketingDeligator = component.get("v.ismarketingDeligator");
        var deligatedUserName = component.get("v.deligatedUserName");
        var isOverrideUnitsavl = false;
        var action = component.get("c.submitToProceddStep");      
        action.setParams
        ({
            bidId:component.get("v.recordId"),
            isContracts:isContracts,
            ismarketingDeligator: ismarketingDeligator,
            deligatedUserName: deligatedUserName
        });
        action.setCallback(this, function(response){
            if (response.getState() === "SUCCESS") {
                var isBisCanSubmit = false;
                component.set('v.isSpinnerLoad',false);
                var ResultData = response.getReturnValue();
                var resultlength=ResultData.length;
                var delegatedUser = component.get("v.deligatedUserName");
                var bidtype=component.get("v.BidTypeVal");
                console.log('resultslength--'+resultlength);
                var qtyError;	
                for(var i=0;i<resultlength;i++){
                    ResultData[i].Phoenix_Proposed_Position__c = ResultData[i].Phoenix_Proposed_Position__c != null ? ResultData[i].Phoenix_Proposed_Position__c : '';
                    ResultData[i].Phoenix_Current_Position__c = ResultData[i].Phoenix_Current_Position__c != null ? ResultData[i].Phoenix_Current_Position__c : '';
                    if(bidtype!='Price Change' && bidtype!='Customer Rebate Change' && bidtype !='Sales Out Rebate' && 
                       (ResultData[i].BidLineItemsExtn__r[0].Phoenix_Proposed_CVS_DirSellingUnits__c ==null || 
                        ResultData[i].BidLineItemsExtn__r[0].Phoenix_Proposed_CVS_IndirSellingUnits__c==null || 
                        ResultData[i].BidLineItemsExtn__r[0].Phoenix_Proposed_Cardinal_Units__c ==null || 
                        ResultData[i].BidLineItemsExtn__r[0].Phoenix_Proposed_Major_Units__c == null)){
                        isBisCanSubmit = true;
                        break;
                    }
                    if(!isBisCanSubmit){
                        if(bidtype!='Price Change' && bidtype!='Customer Rebate Change' && bidtype !='Sales Out Rebate' 
                           && (ResultData[i].BidLineItemsExtn__r[0].Phoenix_Proposed_CVS_DirSellingUnits__c == 0 && 
                               ResultData[i].BidLineItemsExtn__r[0].Phoenix_Proposed_CVS_IndirSellingUnits__c== 0 && 
                               ResultData[i].BidLineItemsExtn__r[0].Phoenix_Proposed_Cardinal_Units__c == 0 &&
                               ResultData[i].BidLineItemsExtn__r[0].Phoenix_Proposed_Major_Units__c == 0)){
                            if(ResultData[i].Phoenix_Marketing_Approval__c !='Not Approved'){
                                qtyError='All Proposed units can not be "0". Please review again for Product: '+ResultData[i].Phoenix_Product__r.Name;
                                break;
                            }
                        }
                        if((ResultData[i].Phoenix_Proposed_Position__c.includes('Primary')
                            || ResultData[i].Phoenix_Current_Position__c.includes('Primary'))
                           && (ResultData[i].BidLineItemsExtn__r[0].Phoenix_Preferred_Cardinal_Rebate_per__c != 40
                               || ResultData[i].BidLineItemsExtn__r[0].Phoenix_Major_Rebate_per__c != 40)){
                            if(ResultData[i].Phoenix_Marketing_Approval__c !='Not Approved'){
                                qtyError='Primary position line items should have default 40% for rebate percentage for '+ResultData[i].Phoenix_Product__r.Name;
                                break;
                            }
                        }
                        
                        if(bidtype!='Price Change' 
                           && bidtype!='Customer Rebate Change' 
                           && bidtype !='Sales Out Rebate' 
                           && (ResultData[i].Phoenix_Product_Director__c==component.get("v.loggedInUserName") ||(delegatedUser != null && delegatedUser.includes(ResultData[i].Phoenix_Product_Director__c)))
                           && (ResultData[i].BidLineItemsExtn__r[0].Phoenix_Proposed_CVS_DirSellingUnits__c ==null )){
                            if(ResultData[i].Phoenix_Marketing_Approval__c !='Not Approved'){
                                qtyError='Please Enter The Proposed CVS Direct Units for '+ResultData[i].Phoenix_Product__r.Name;
                                break;
                            }
                        }
                        if(bidtype!='Price Change' 
                           && bidtype!='Customer Rebate Change' 
                           && bidtype !='Sales Out Rebate' 
                           && (ResultData[i].Phoenix_Product_Director__c==component.get("v.loggedInUserName") ||(delegatedUser != null && delegatedUser.includes(ResultData[i].Phoenix_Product_Director__c)))
                           && (ResultData[i].BidLineItemsExtn__r[0].Phoenix_Proposed_CVS_IndirSellingUnits__c ==null )){
                            if(ResultData[i].Phoenix_Marketing_Approval__c !='Not Approved'){
                                qtyError='Please Enter The Proposed CVS Indirect Units for '+ResultData[i].Phoenix_Product__r.Name;
                                break;
                            }
                        }
                        if(bidtype!='Price Change' 
                           && bidtype!='Customer Rebate Change' 
                           && bidtype !='Sales Out Rebate' 
                           && (ResultData[i].Phoenix_Product_Director__c==component.get("v.loggedInUserName") ||(delegatedUser != null && delegatedUser.includes(ResultData[i].Phoenix_Product_Director__c)))
                           && (ResultData[i].BidLineItemsExtn__r[0].Phoenix_Proposed_Cardinal_Units__c ==null )){
                            if(ResultData[i].Phoenix_Marketing_Approval__c !='Not Approved'){
                                qtyError='Please Enter The Proposed Cardinal Units for '+ResultData[i].Phoenix_Product__r.Name;
                                break;
                            }
                        }
                        if(bidtype!='Price Change' 
                           && bidtype!='Customer Rebate Change' 
                           && bidtype !='Sales Out Rebate' 
                           && (ResultData[i].Phoenix_Product_Director__c==component.get("v.loggedInUserName") ||(delegatedUser != null && delegatedUser.includes(ResultData[i].Phoenix_Product_Director__c)))
                           && (ResultData[i].BidLineItemsExtn__r[0].Phoenix_Proposed_Major_Units__c ==null )){
                            qtyError='Please Enter The Proposed Major Units for '+ResultData[i].Phoenix_Product__r.Name;
                            break;
                        }
                        
                        if(component.get("v.BidAprrovalStatus")!='Draft' 
                           && (ResultData[i].Phoenix_Product_Director__c==component.get("v.loggedInUserName") ||(delegatedUser != null && delegatedUser.includes(ResultData[i].Phoenix_Product_Director__c)))
                           && ResultData[i].Phoenix_ProposedContractBidPriceMktng__c == null 
                           && ResultData[i].BidLineItemsExtn__r[0].Phoenix_Proposed_CVS_IndirSellingUnits__c != 0
                           && bidtype != 'Customer Rebate Change' 
                           && bidtype != 'Price Change' 
                           && bidtype != 'Sales Out Rebate' ){	
                            if(ResultData[i].Phoenix_Marketing_Approval__c !='Not Approved'){
                                qtyError='Please Enter Proposed CVS Indirect Contract Price for '+ResultData[i].Phoenix_Product__r.Name;	
                                console.log('marketing Price');	
                                break;	  
                            } else{
                                break;
                            }
                        } 
                        if(component.get("v.BidAprrovalStatus")!='Draft' 
                           && (ResultData[i].Phoenix_Product_Director__c==component.get("v.loggedInUserName") ||(delegatedUser != null && delegatedUser.includes(ResultData[i].Phoenix_Product_Director__c)))
                           && ResultData[i].Phoenix_ProposedContractBidPriceMktng__c == null 
                           && ResultData[i].Phoenix_Current_Indirect_Price__c != 0
                           && (bidtype == 'Price Change' 
                               || bidtype == 'Customer Rebate Change')){
                            if(ResultData[i].Phoenix_Marketing_Approval__c !='Not Approved'){
                                qtyError='Please Enter Proposed CVS Indirect Contract Price for '+ResultData[i].Phoenix_Product__r.Name;	
                                console.log('marketing Price');	
                                break;	  
                            } else{
                                break;
                            }
                        }
                        
                        if(ResultData[i].BidLineItemsExtn__r[0].Phoenix_PropMarktCvsCardinalAcquisitCost__c == null 
                           && component.get("v.isMarketingApprovePerson")==component.get("v.loggedInUserName") 
                           && (component.get("v.loggedInUserName")== ResultData[i].Phoenix_Product_Director1__c ||(delegatedUser != null && delegatedUser.includes(ResultData[i].Phoenix_Product_Director__c)))
                           && bidtype!='Customer Rebate Change' 
                           && bidtype!='Volume Review Only' 
                           && bidtype !='Sales Out Rebate'){
                            if(ResultData[i].Phoenix_Marketing_Approval__c !='Not Approved'){
                                qtyError='Please Enter Proposed Marketing CVS/Cardinal Acquisition Costs';
                                console.log('wholesaler Price');
                                break;
                            }
                        }	
                        if(component.get("v.BidAprrovalStatus")!='Draft' 
                           && (ResultData[i].Phoenix_Product_Director__c==component.get("v.loggedInUserName") ||(delegatedUser != null && delegatedUser.includes(ResultData[i].Phoenix_Product_Director__c)))
                           && ResultData[i].BidLineItemsExtn__r[0].Phoenix_PropMarktCvsCardinalAcquisitCost__c==null 
                           && bidtype != 'Customer Rebate Change' 
                           && bidtype != 'Volume Review Only' 
                           && bidtype != 'Sales Out Rebate'){	
                            if(ResultData[i].Phoenix_Marketing_Approval__c !='Not Approved'){
                                qtyError='Please Enter Proposed Marketing CVS/Cardinal Acquisition Costs for '+ResultData[i].Phoenix_Product__r.Name;	
                                console.log('marketing Price');	
                                break;	  
                            } else{
                                break;
                            }
                        }
                        /* For New Product Launch*/
                     /*   else if (component.get("v.BidAprrovalStatus")!='Draft' && (ResultData[i].Phoenix_Product_Director__c==component.get("v.loggedInUserName") ||(delegatedUser != null && delegatedUser.includes(ResultData[i].Phoenix_Product_Director__c)))
                                 && bidtype == 'New Product Launch' 
                                 && ResultData[i].Phoenix_Customer_Dead_Net1__c < ResultData[i].Phoenix_Lowest_Price_SKU__c && ResultData[i].Phoenix_Customer_Dead_Net1__c != 0){
                            if (ResultData[i].Phoenix_Marketing_Approval__c != 'Not Approved') {   
                                qtyError='You cannot submit this Bid for Approval as Internal Cardinal Dead Net is less than Lowest Price/SKU: '+ResultData[i].Phoenix_Product__r.Name;
                                break;
                            }
                            else {
                                break;
                            }
                        }
                            else if (component.get("v.BidAprrovalStatus")!='Draft' && (ResultData[i].Phoenix_Product_Director__c==component.get("v.loggedInUserName") ||(delegatedUser != null && delegatedUser.includes(ResultData[i].Phoenix_Product_Director__c)))
                                     && bidtype == 'New Product Launch' 
                                     && ResultData[i].BidLineItemsExtn__r[0].Phoenix_Internal_Major_Dead_Net__c < ResultData[i].Phoenix_Lowest_Price_SKU__c && ResultData[i].BidLineItemsExtn__r[0].Phoenix_Internal_Major_Dead_Net__c !=0){
                                if (ResultData[i].Phoenix_Marketing_Approval__c != 'Not Approved') {   
                                    qtyError='You cannot submit this Bid for Approval as Internal Major Dead Net is less than Lowest Price/SKU: '+ResultData[i].Phoenix_Product__r.Name;
                                    break;
                                }
                                else {
                                    break;
                                }
                            }
                                else if (component.get("v.BidAprrovalStatus")!='Draft' && (ResultData[i].Phoenix_Product_Director__c==component.get("v.loggedInUserName") ||(delegatedUser != null && delegatedUser.includes(ResultData[i].Phoenix_Product_Director__c)))
                                         && bidtype == 'New Product Launch'
                                         && ResultData[i].Phoenix_Direct_Dead_Net__c < ResultData[i].Phoenix_Lowest_Price_SKU__c && ResultData[i].Phoenix_Direct_Dead_Net__c !=0
                                         && ( ResultData[i].BidLineItemsExtn__r[0].Phoenix_Proposed_CVS_DirSellingUnits__c > ResultData[i].BidLineItemsExtn__r[0].Phoenix_Proposed_CVS_IndirSellingUnits__c
                                             || ResultData[i].BidLineItemsExtn__r[0].Phoenix_Proposed_CVS_DirSellingUnits__c == ResultData[i].BidLineItemsExtn__r[0].Phoenix_Proposed_CVS_IndirSellingUnits__c)){
                                    if (ResultData[i].Phoenix_Marketing_Approval__c != 'Not Approved') {   
                                        qtyError='You cannot submit this Bid for Approval as Internal CVS Direct Dead Net is less than Lowest Price/SKU: '+ResultData[i].Phoenix_Product__r.Name;
                                        break;
                                    }
                                    else {
                                        break;
                                    }
                                }
                                    else if (component.get("v.BidAprrovalStatus")!='Draft' && (ResultData[i].Phoenix_Product_Director__c==component.get("v.loggedInUserName") ||(delegatedUser != null && delegatedUser.includes(ResultData[i].Phoenix_Product_Director__c)))
                                             && bidtype == 'New Product Launch' 
                                             && ResultData[i].Phoenix_Indirect_Dead_Net__c < ResultData[i].Phoenix_Lowest_Price_SKU__c
                                             && ResultData[i].BidLineItemsExtn__r[0].Phoenix_Proposed_CVS_IndirSellingUnits__c > ResultData[i].BidLineItemsExtn__r[0].Phoenix_Proposed_CVS_DirSellingUnits__c){
                                        if (ResultData[i].Phoenix_Marketing_Approval__c != 'Not Approved') {   
                                            qtyError='You cannot submit this Bid for Approval as Internal CVS Indirect Dead Net is less than Lowest Price/SKU: '+ResultData[i].Phoenix_Product__r.Name;
                                            break;
                                        }
                                        else {
                                            break;
                                        }
                                    }*/
                         /*End for New Product Launch*/
                        var directPrice = ResultData[i].BidLineItemsExtn__r[0].Phoenix_Proposed_CvsDirectContractPrice__c;
                        var indirectPrice = ResultData[i].Phoenix_ProposedContractBidPriceMktng__c;
                        directPrice = Math.round((directPrice) * 100) / 100;
                        indirectPrice = Math.round((indirectPrice) * 100) / 100;
                        if(component.get("v.BidAprrovalStatus")!='Draft'  
                           && (ResultData[i].Phoenix_Product_Director__c==component.get("v.loggedInUserName") ||(delegatedUser != null && delegatedUser.includes(ResultData[i].Phoenix_Product_Director__c)))
                           && directPrice > indirectPrice 
                           && bidtype != 'Customer Rebate Change' 
                           && bidtype != 'Volume Review Only' 
                           && bidtype != 'Sales Out Rebate'){
                            if(ResultData[i].Phoenix_Marketing_Approval__c !='Not Approved'){
                                qtyError='CVS Indirect price cannot be less than direct price for '+ResultData[i].Phoenix_Product__r.Name;	
                                console.log('marketing Price');	
                                break;	  
                            } else{
                                break;
                            }
                        }
                        
                        var keyValue = 0;
                        var prices = [];
                        var mapDeadNets = new Map();
                        if(ResultData[i].Phoenix_ProposedContractBidPriceMktng__c != null && ResultData[i].Phoenix_ProposedContractBidPriceMktng__c != 0){
                            prices.push(ResultData[i].Phoenix_ProposedContractBidPriceMktng__c);
                            mapDeadNets.set('CVS Indirect Contract Price',ResultData[i].Phoenix_ProposedContractBidPriceMktng__c);
                        }
                        if(ResultData[i].BidLineItemsExtn__r[0].Phoenix_Proposed_CvsDirectContractPrice__c != null && ResultData[i].BidLineItemsExtn__r[0].Phoenix_Proposed_CvsDirectContractPrice__c != 0){
                            prices.push(ResultData[i].BidLineItemsExtn__r[0].Phoenix_Proposed_CvsDirectContractPrice__c);
                            mapDeadNets.set('CVS Direct Contract Price',ResultData[i].BidLineItemsExtn__r[0].Phoenix_Proposed_CvsDirectContractPrice__c);
                        }
                        if(ResultData[i].Phoenix_Wholesaler_Diff_Price_Indirect__c != null && ResultData[i].Phoenix_Wholesaler_Diff_Price_Indirect__c != 0){
                            prices.push(ResultData[i].Phoenix_Wholesaler_Diff_Price_Indirect__c);
                            mapDeadNets.set('CVS Cardinal Contract Price',ResultData[i].Phoenix_Wholesaler_Diff_Price_Indirect__c);
                        }
                        if(ResultData[i].BidLineItemsExtn__r[0].Phoenix_Proposed_Major_Contract_Price__c != null && ResultData[i].BidLineItemsExtn__r[0].Phoenix_Proposed_Major_Contract_Price__c != 0){
                            prices.push(ResultData[i].BidLineItemsExtn__r[0].Phoenix_Proposed_Major_Contract_Price__c);
                            mapDeadNets.set('CVS Major Contract Price',ResultData[i].BidLineItemsExtn__r[0].Phoenix_Proposed_Major_Contract_Price__c);
                        }
                        
                        if(prices.length > 0){
                            prices.sort(function(a, b){return b-a});
                            if(prices[0]>ResultData[i].Phoenix_WAC__c){
                                keyValue = prices[0];
                                
                            }
                        }
                        if(keyValue != 0){
                            if(keyValue === ResultData[i].Phoenix_ProposedContractBidPriceMktng__c){
                                qtyError='Proposed CVS Indirect Contract Price can not be Greater than WAC for '+ResultData[i].Phoenix_Product__r.Name;
                                break;	
                            }
                            if(keyValue === ResultData[i].BidLineItemsExtn__r[0].Phoenix_Proposed_CvsDirectContractPrice__c){
                                qtyError='Proposed CVS Direct Contract Price can not be Greater than WAC for '+ResultData[i].Phoenix_Product__r.Name;
                                break;	
                            }
                            if(keyValue === ResultData[i].Phoenix_Wholesaler_Diff_Price_Indirect__c){
                                qtyError='Proposed Cardinal Contract Price can not be Greater than WAC for '+ResultData[i].Phoenix_Product__r.Name;
                                break;	
                            }
                            if(keyValue === ResultData[i].BidLineItemsExtn__r[0].Phoenix_Proposed_Major_Contract_Price__c){
                                qtyError='Proposed Major Contract Price can not be Greater than WAC for '+ResultData[i].Phoenix_Product__r.Name;
                                break;	
                            }
                            
                        }
                    }
                }
                for(var i=0;i<resultlength;i++){
                    // Override units popup start
                        if(component.get("v.BidAprrovalStatus")!='Draft' && ResultData[i].Phoenix_Product_Director__c==component.get("v.loggedInUserName") && bidtype !='New Product Launch' && ResultData[i].Phoenix_Override_Current_Direct_Units__c==null && (ResultData[i].Phoenix_Current_Retail_Direct_Units__c==null || ResultData[i].Phoenix_Current_Retail_Direct_Units__c==undefined || ResultData[i].Phoenix_Current_Retail_Direct_Units__c==0)){                                             
                                           isOverrideUnitsavl =true;
                                               break;
                                           }
                          else if(component.get("v.BidAprrovalStatus")!='Draft' && ResultData[i].Phoenix_Product_Director__c==component.get("v.loggedInUserName") && bidtype !='New Product Launch' && ResultData[i].Phoenix_Override_Current_Indirect_Units__c==null && (ResultData[i].Phoenix_Override_Current_Indirect_Units__c==null || ResultData[i].Phoenix_Override_Current_Indirect_Units__c==undefined || ResultData[i].Phoenix_Override_Current_Indirect_Units__c==0)){                                             
                                           isOverrideUnitsavl =true;
                                               break;
                                           }
                          else if(component.get("v.BidAprrovalStatus")!='Draft' && ResultData[i].Phoenix_Product_Director__c==component.get("v.loggedInUserName") && bidtype !='New Product Launch' && ResultData[i].Phoenix_Override_Current_Units__c==null && (ResultData[i].Phoenix_Current_Wholesaler_Units__c==null || ResultData[i].Phoenix_Current_Wholesaler_Units__c==undefined || ResultData[i].Phoenix_Current_Wholesaler_Units__c==0)){                                             
                                           isOverrideUnitsavl =true;
                                               break;
                                           }
                          else if(component.get("v.BidAprrovalStatus")!='Draft' && ResultData[i].Phoenix_Product_Director__c==component.get("v.loggedInUserName") && bidtype !='New Product Launch' && ResultData[i].BidLineItemsExtn__r[0].Phoenix_OverrideMajorUnits__c==null && (ResultData[i].BidLineItemsExtn__r[0].Phoenix_3MonAnnualMajorSellingUnits__c==null || ResultData[i].BidLineItemsExtn__r[0].Phoenix_3MonAnnualMajorSellingUnits__c==undefined || ResultData[i].BidLineItemsExtn__r[0].Phoenix_3MonAnnualMajorSellingUnits__c==0)){                                             
                                           isOverrideUnitsavl =true;
                                               break;
                                           }
                         // Override units popup end

                }
                  var modalMessage = isOverrideUnitsavl ? 'The 3 Months Annualized Selling Units is 0. Are you sure you want to submit this bid for approval?' : 'Are you sure you want to submit this bid for approval?';
                                       component.set('v.modalMessage',modalMessage);
                if(isBisCanSubmit){
                    component.set("v.fieldRequiredModel",true);
                }
                else{
                    if(qtyError){	
                        var toastEvent = $A.get("e.force:showToast");	
                        toastEvent.setParams({	
                            "title": "Error!",	
                            "type":"error",	
                            "message":qtyError	
                        });	
                        toastEvent.fire();	
                    }	
                    else{	
                        var isApproved = false;
                        var approveStatusFlag=false;//for step staus ==>false:'rejected' ;true:'approved'
                        if(resultlength==0){
                            isApproved = true;
                        }
                        else{
                            if(isContracts==false){
                                ResultData.forEach(function(line){
                                    if(line['Phoenix_Marketing_Approval__c'] == 'None' || line['Phoenix_Marketing_Approval__c'] == '' || line['Phoenix_Marketing_Approval__c'] == null || line['Phoenix_Marketing_Approval__c'] == 'undefined'){
                                        isApproved = true;
                                        //console.log("marketingApproval--->"+line['Phoenix_Marketing_Approval__c']);
                                    }
                                    if(line['Phoenix_Marketing_Approval__c']=='Approved'){
                                        approveStatusFlag=true;  
                                    } 
                                });  
                            }
                            else{
                                ResultData.forEach(function(line){
                                    if(line['Phoenix_Contract_Approval__c'] == 'None' || line['Phoenix_Contract_Approval__c'] == '' || line['Phoenix_Contract_Approval__c'] == null || line['Phoenix_Contract_Approval__c'] == 'undefined'){
                                        isApproved = true;
                                        console.log("Phoenix_Contract_Approval__c--->"+line['Phoenix_Contract_Approval__c']);
                                    }
                                    if(line['Phoenix_Contract_Approval__c']=='Approved'){
                                        approveStatusFlag=true;  
                                    } 
                                });
                            }
                        }
                        if(isApproved == true){
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                "type":"warning",
                                "title": "Failed!",
                                "message": "Please confirm each approval to proceed further"
                            });
                            toastEvent.fire();
                            
                        }
                        else{
                            if(isContracts){
                                helper.MarkApprovalsContracts(component,event,helper,ResultData,approveStatusFlag,isContracts);  
                            }else{
                                helper.MarkApprovals(component,event,helper,ResultData,approveStatusFlag);  
                            }
                            
                        }
                    }
                }
            }
            else{
                component.set('v.isSpinnerLoad',false);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type":"error",
                    "title": "error!",
                    "message": "Something went wrong,please contact admin."
                });
                toastEvent.fire();
            }
            
        });
        $A.enqueueAction(action);
    },
    MarkApprovals: function(component,event,helper,ResultData,approveStatusFlag){
        var action = component.get("c.makeApprovals");
        action.setParams({
            bidId : component.get("v.recordId"),
            bidlines:ResultData,
            approveStatusFlag:approveStatusFlag
        });
        action.setCallback(this, function (response){
            if(response.getState() === "SUCCESS"){
                var wrapNextSteps=response.getReturnValue();
                var marketStepLsit=wrapNextSteps.updateProcessStepList;
                var flagSCMStop= wrapNextSteps.flagSCMStop;
                var flagMarketStop=wrapNextSteps.flagMarketStop;
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type":"success",
                    "title": "Success",
                    "message": "Your Approvals are submitted successfully."
                });
                toastEvent.fire();//updateNextProcessSteps
                if(flagSCMStop==false && flagMarketStop==false){
                    helper.UpdateNextSteps(component,event,helper,marketStepLsit,flagSCMStop,flagMarketStop); 
                }
                $A.get('e.force:refreshView').fire();
            }
            else{
                toastEvent.setParams({
                    "type":"error",
                    "title": "error!",
                    "message": "Something went wrong,please contact admin."
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
        
    },
    MarkApprovalsContracts : function(component,event,helper,ResultData,approveStatusFlag,isContracts){
        console.log('MarkApprovalsContracts--');
        var action = component.get("c.makeApprovalsContracts");
        action.setParams({
            bidId : component.get("v.recordId"),
            bidlines:ResultData,
            approveStatusFlag:approveStatusFlag,
            isContracts:isContracts
        });
        action.setCallback(this, function (response){
            if(response.getState() === "SUCCESS"){
                var responseList=response.getReturnValue();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type":"success",
                    "title": "Success",
                    "message": "Your Approvals are submitted successfully."
                });
                toastEvent.fire();//updateNextProcessSteps
                helper.UpdateNextStepsContracts(component,event,helper,responseList); 
                $A.get('e.force:refreshView').fire();
            }
            else{
                toastEvent.setParams({
                    "type":"error",
                    "title": "error!",
                    "message": "Something went wrong,please contact admin."
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
        
    },
    UpdateNextStepsContracts :function(component,event,helper,Stepsist){
        console.log('UpdateNextStepsContracts--');
        var action = component.get("c.updateNextContractProcessSteps");
        action.setParams({
            bidId : component.get("v.recordId"),
            bidName:component.get("v.bidName"),
            processStepLsit: Stepsist
        });
        action.setCallback(this, function (response){
            if(response.getState() === "SUCCESS"){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type":"success",
                    "title": "Success",
                    "message": "Your Approvals are submitted successfully."
                });
                toastEvent.fire();//updateNextProcessSteps
                //helper.UpdateNextSteps(component,event,helper);
                $A.get('e.force:refreshView').fire();
            }
        });
        $A.enqueueAction(action);
    },
    
    UpdateNextSteps : function(component,event,helper,marketStepLsit,flagSCMStop,flagMarketStop){
        var action = component.get("c.updateNextProcessSteps");
        action.setParams({
            bidId : component.get("v.recordId"),
            bidName:component.get("v.bidName"),
            processStepLsit: marketStepLsit,
            flagSCMStop:flagSCMStop,
            flagMarketStop:flagMarketStop
        });
        action.setCallback(this, function (response){
            if(response.getState() === "SUCCESS"){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type":"success",
                    "title": "Success",
                    "message": "Your Approvals are submitted successfully."
                });
                toastEvent.fire();//updateNextProcessSteps
                //helper.UpdateNextSteps(component,event,helper);
                $A.get('e.force:refreshView').fire();
            }
        });
        $A.enqueueAction(action);
    },
    getUpdateLines: function(component,event,helper){
        var action = component.get("c.getUpdatedList");
        action.setParams
        ({
            lineItems : component.get("v.BidLineItemListAll"),
            bidId : component.get("v.recordId")
        });
        action.setCallback(this, function(response) 
                           {
                               if(response.getState()=="SUCCESS"){
                                   var lineItemsList =response.getReturnValue();
                                   if(lineItemsList.length > 50){
                                       var selectedPageNumber = component.get("v.selectedPageNumber");
                                       
                                       var pagedLineItems = lineItemsList.slice((selectedPageNumber-1)*50,((selectedPageNumber-1)*50)+50);
                                       component.set("v.pagedLineItems",pagedLineItems);
                                   }
                                   else
                                       component.set("v.pagedLineItems",lineItemsList);
                                   component.set("v.BidLineItemListAll",lineItemsList);
                                   var OutDiv = component.find("mainDiv");
                                   if(lineItemsList.length<10){
                                       console.log('--no-hight---');
                                       $A.util.addClass(OutDiv, "noheightClass");
                                   }else{
                                       $A.util.removeClass(OutDiv, "noheightClass");
                                   }
                                   component.set('v.isSpinnerLoad',false);
                               }
                           });
        $A.enqueueAction(action);
    }
})