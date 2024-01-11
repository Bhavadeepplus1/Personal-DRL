/**
 * @description       : 
 * @author            : Surender Patel (Dhruvsoft)
 * @group             : 
 * @last modified on  : 29-05-2021
 * @last modified by  : Surender Patel (Dhruvsoft)
 * Modifications Log 
 * Ver   Date         Author                       Modification
 * 1.0   29-05-2021   Surender Patel (Dhruvsoft)   Initial Version
**/
({
    getBidDetails: function (component, event) {
        var action = component.get("c.getbidRecordDetails");
        action.setParams({
            bidId: component.get("v.recordId")
        });
        action.setCallback(this, function (response) {
            if (response.getState() === "SUCCESS") {
                var bidRecord = response.getReturnValue();
            }
        })
    },
    requiredValidation: function (component, event) {
        var allRecords = component.get("v.BidLineItemListAll");
        var isValid = true;
        for (var i = 0; i < allRecords.length; i++) {
            if (allRecords[i].Name == null || allRecords[i].Name.trim() == '') {
                alert('Complete this field : Row No ' + (i + 1) + ' Name is null');
                isValid = false;
            }
        }
        return isValid;
    },
    searchHelper: function (component, event, getInputkeyWord) {
        var li = component.get("v.defaultlistOfProductFamily");
        console.log('list of pro family-->' + li);
        var excludelist = component.get("v.lstSelectedRecords");
        console.log('excludelist---' + excludelist);
        console.log('getInputkeyWord--' + getInputkeyWord);
        var final = [];
        let difference = li.filter(x => !excludelist.includes(x) && x.toLowerCase().startsWith(getInputkeyWord.toLowerCase()));
        console.log(difference);
        if (difference.length > 0) {
            component.set("v.listOfSearchRecords", difference);
            component.set("v.Message", '');
        } else {
            component.set("v.Message", 'No Records Found...');
            component.set("v.listOfSearchRecords", null);
        }
    },
    searchHelperProdDir: function (component, event, getInputkeyWord) {
        var li = component.get("v.defaultlistOfProductDirectors");
        console.log('list of pro dirs-->' + li);
        var excludelist = component.get("v.lstSelectedPDRecords");
        console.log('excludelist---' + excludelist);
        console.log('getInputkeyWord--' + getInputkeyWord);
        var final = [];
        let difference = li.filter(x => !excludelist.includes(x) && x.toLowerCase().startsWith(getInputkeyWord.toLowerCase()));
        console.log(difference);
        if (difference.length > 0) {
            component.set("v.listOfSearchPDRecords", difference);
            component.set("v.MessagePD", '');
        } else {
            component.set("v.MessagePD", 'No Records Found...');
            component.set("v.listOfSearchPDRecords", null);
        }
    },
    searchProductFamilyChange: function (component, event, helper) {
        component.set('v.isSpinnerLoad', true);
        var action = component.get("c.findByProductFamily");
        console.log("listOfPD----->" + component.get("v.lstSelectedPDRecords"))
        action.setParams({
            "searchKey": component.get("v.lstSelectedRecords"),
            "lineItemId": component.get("v.recordId"),
            "sRxOtcList": component.get("v.RxSrxList"),
            "searchPDList": component.get("v.lstSelectedPDRecords")
        });
        action.setCallback(this, function (a) {
            var lineItemsList = a.getReturnValue();
            component.set("v.BidLineItemListAll", lineItemsList);
            component.set('v.isSpinnerLoad', false);
            var OutDiv = component.find("mainDiv");
            if (lineItemsList.length < 10) {
                console.log('--no-hight---');
                $A.util.addClass(OutDiv, "noheightClass");
            } else {
                $A.util.removeClass(OutDiv, "noheightClass");
            }
        });
        $A.enqueueAction(action);
    },
    fetchContratcs: function (component, event, helper, bidCustomer, searchInput) {
        console.log('bidCustomer---' + bidCustomer);
        var action = component.get("c.getContracts");
        action.setParams({
            customerID: bidCustomer,
            searchInput: searchInput

        });
        action.setCallback(this, function (response) {
            if (response.getState() === "SUCCESS") {
                var responseList = response.getReturnValue();
                console.log('---responseList---' + responseList.length);
                //component.set("v.contratcsList",responseList);

                //below code is for remove seleceted while fetch contracts in table
                var sltcntcntrcs = component.get('v.selectedCntrcts');
                var finalContratcs = responseList.filter(comparer(sltcntcntrcs));

                function comparer(otherArray) {
                    return function (current) {
                        return otherArray.filter(function (other) {
                            console.log('other---' + JSON.stringify(other));
                            console.log('current---' + JSON.stringify(current));
                            return other == current.Name
                        }).length == 0;
                    }
                }
                component.set("v.contratcsList", finalContratcs);
            }

        });
        $A.enqueueAction(action);
    },
    getNPRDataOfContracts: function (component, event, helper, selectrcs, templateType) {

        var action = component.get("c.getNPRData");
        action.setParams({
            selectrcs: selectrcs,
            // currentCd : currentCd,
            BidId: component.get("v.recordId"),
            templateType: templateType

        });
        action.setCallback(this, function (response) {
            if (response.getState() === "SUCCESS") {
                helper.searchProductFamilyChange(component, event, helper);
            }

        });
        $A.enqueueAction(action);
    },
    convertArrayOfObjectsToCSV: function (component, objectRecords, template, BidType) {
        // declare variables
        var csvStringResult, counter, keys, columnDivider, lineDivider;
        var BidType = BidType;
        var temp = template;
        console.log('bid type is--->' + BidType);

        var specific_customer = component.get('v.isSpecificCustomer');
        console.log('specific_customer is--->' + specific_customer);
        // check if "objectRecords" parameter is null, then return from function
        if (objectRecords == null || !objectRecords.length) {
            return null;
        }
        // store ,[comma] in columnDivider variabel for sparate CSV values and 
        // for start next line use '\n' [new line] in lineDivider varaible  
        columnDivider = ',';
        lineDivider = '\n';

        // in the keys valirable store fields API Names as a key 
        // this labels use in CSV file header 
        csvStringResult = '';
        var myMap = new Map();
        myMap.set("NDC (Dashes)", "Phoenix_NDC__c");
        myMap.set("NDC", "Phoenix_NDC_Without_Dashes__c");
        myMap.set("SAP Number", "Phoenix_Product_Code1__c");
        myMap.set("Product Name", "Phoenix_Product__r.Name");
        myMap.set("Pkg Size", "Phoenix_Pkg_Size__c");
        myMap.set("Case Pack", "Phoenix_Case_Pack__c");
        myMap.set("MOQ", "Phoenix_MOQ__c");
        myMap.set("Product Family", "Product_Family_Name__c");
        myMap.set("Compare To (Brand Name)", "Phoenix_Compare_to_Brand_Name__c");
        myMap.set("WAC", "Phoenix_WAC__c");
         myMap.set("Current Floor Price", "Phoenix_IPA_Floor_Price1__c");
        myMap.set("Proposed Contract Bid Price (Sales)", "Phoenix_ProposedContract_Bid_Price_Sales__c");
        myMap.set("Final Approved Pricing (Contracts)", "Phoenix_Current_Price_Calc__c");
        myMap.set("Internal Dead Net Price", "Phoenix_Internal_Dead_Net_Price__c");
        
        if (BidType == 'Sales Out Rebate') {
            myMap.set("Sales Out Promotion Per Unit $", "Phoenix_Sales_Out_Promotion_Per_unit_in__c");
        }
          
      
        
       /* if (BidType != 'Sales Out Promotional Discount' && BidType != 'Sales Out Rebate' && BidType != "Customer Rebate Change" && BidType != "Price Change") {
            myMap.set("SCM Approval (Y/N)", "Phoenix_SCM_Approval_Y_N__c");
            myMap.set("Total SCM Approved Qty", "Phoenix_Total_SCM_Approved_Qty__c");
            myMap.set("Estimated Lead Time", "Phoenix_Estimated_Lead_Time_Days__c");
            //myMap.set("SCM Rejection Reason","Phoenix_SCM_Rejection_Reason1__c");
            myMap.set("SCM Comments", "Phoenix_SCM_Notes__c");
        }*/
        myMap.set("Sales Notes", "Phoenix_Sales_Notes__c");
       if(BidType != 'Volume Review Only' ){
               myMap.set("Marketing Approval", "Phoenix_Marketing_Approval__c");
              }
       
        myMap.set("Marketing Notes", "Phoenix_Marketing_Notes__c");
       
        if(BidType != 'Volume Review Only' ){
            myMap.set("Finance Approval", "Phoenix_Finance_Approval__c");
            myMap.set("Finance Comments", "Phoenix_Finance_Comments__c");
        }
        myMap.set("Contract Status", "Phoenix_Contract_Approval__c");
        myMap.set("Contract Comments", "Phoenix_Contract_Comments__c");
        
        if( BidType == 'RFP Bids' || BidType == 'Product Addition' || BidType=='New Product Launch'){
            
            myMap.set("IOD Qty (rounded to MOQ)", "Phoenix_IOD_Qty__c");
        }
        
        csvStringResult += Array.from(myMap.keys()).join(columnDivider);
        csvStringResult += lineDivider;
        //new logic start 
        for (var i = 0; i < objectRecords.length; i++) {
            counter = 0;
            for (let [key, value] of myMap) {
                if (counter > 0) {
                    csvStringResult += columnDivider;
                }
                console.log('testing result--->' + JSON.stringify(objectRecords[i]));
                if (value == 'Phoenix_Product__r.Name') {
                    csvStringResult += '"' + objectRecords[i]["Phoenix_Product__r"]["Name"] + '"';
                } else if (value == 'Phoenix_Wholesaler_Diff_Price_Indirect__c') {
                    var wholesalerprice = objectRecords[i]['Phoenix_Wholesaler_Diff_Price_Indirect__c'];
                    if (wholesalerprice != null) {
                        csvStringResult += '"' + objectRecords[i]["Phoenix_Wholesaler_Diff_Price_Indirect__c"] + '"';
                    } else {
                        csvStringResult += '"' + objectRecords[i]["Phoenix_Current_Indirect_Price__c"] + '"';

                    }
                } else if (value == 'Phoenix_Proposed_McK_OS_And_RAD_NCP__c') {
                    var salesoutpromotion = objectRecords[i]['Phoenix_Proposed_McK_OS_And_RAD_NCP__c'];
                    var salesoutpromotion1 = objectRecords[i]['Phoenix_Sales_Proposed_NCP_McK_And_RAD__c'];
                    if (salesoutpromotion != null) {
                        var rounded_salesoutpromotion = Math.round((salesoutpromotion + Number.EPSILON) * 100) / 100
                        console.log('rounded value-->' + rounded_salesoutpromotion);
                        csvStringResult += '"' + salesoutpromotion + '"';
                    } else if(salesoutpromotion1 != null){
                        csvStringResult += '"' + salesoutpromotion1 + '"';
                    }else {
                        csvStringResult += '"' + '' + '"';

                    }
                } else if (value == 'Phoenix_Proposed_WMT_Direct_NCP__c') {
                    var salesoutpromotion = objectRecords[i]['Phoenix_Proposed_WMT_Direct_NCP__c'];
                    var salesoutpromotion1 = objectRecords[i]['Phoenix_ProposedContract_Bid_Price_Sales__c'];
                    if (salesoutpromotion != null) {
                        var rounded_salesoutpromotion = Math.round((salesoutpromotion + Number.EPSILON) * 100) / 100
                        console.log('rounded value-->' + rounded_salesoutpromotion);
                        csvStringResult += '"' + salesoutpromotion + '"';
                    } else if(salesoutpromotion1 != null){
                        csvStringResult += '"' + salesoutpromotion1 + '"';
                    }else {
                        csvStringResult += '"' + '' + '"';

                    }
                } else if (value == 'Phoenix_Proposed_WMT_Indirect_NCP__c') {
                    var salesoutpromotion = objectRecords[i]['Phoenix_Proposed_WMT_Indirect_NCP__c'];
                    var salesoutpromotion1 = objectRecords[i]['Phoenix_ProposedContract_Bid_Price_Sales__c'];
                    if (salesoutpromotion != null) {
                        var rounded_salesoutpromotion = Math.round((salesoutpromotion + Number.EPSILON) * 100) / 100
                        console.log('rounded value-->' + rounded_salesoutpromotion);
                        csvStringResult += '"' + salesoutpromotion + '"';
                    } else if(salesoutpromotion1 != null){
                        csvStringResult += '"' + salesoutpromotion1 + '"';
                    }else {
                        csvStringResult += '"' + '' + '"';

                    }
                } 
                    else if (value == 'Phoenix_Sales_Out_Promotion_Per_unit_in__c') {
                    var salesoutpromotion = objectRecords[i]['Phoenix_Sales_Out_Promotion_Per_unit_in__c'];
                    if (salesoutpromotion != null) {
                        var rounded_salesoutpromotion = Math.round((salesoutpromotion + Number.EPSILON) * 100) / 100
                        console.log('rounded value-->' + rounded_salesoutpromotion);
                        csvStringResult += '"' + rounded_salesoutpromotion + '"';
                    } else {
                        csvStringResult += '"' + '' + '"';

                    }
                } else if (value == 'Phoenix_Total_SCM_Approved_Qty__c' || value == 'Phoenix_Estimated_Lead_Time_Days__c' || value == 'Phoenix_SCM_Rejection_Reason1__c' || value == 'Phoenix_SCM_Approval_Y_N__c' || value == 'Phoenix_SCM_Notes__c') {
                    if (objectRecords[i]["Phoenix_SCM_Final_Approval__c"] == true && objectRecords[i]["Phoenix_SCM_Approval_Y_N__c"] != 'N- Not Approved' && objectRecords[i]["Phoenix_SCM_Approval_Y_N__c"] != '') {
                        // console.log('scm approval status is true');
                        if (objectRecords[i][value] == undefined) {
                            //console.log('Iam in last ELSEE if---->');
                            csvStringResult += '"' + '' + '"';
                        } else {
                            csvStringResult += '"' + objectRecords[i][value] + '"';
                        }
                    } else {
                        csvStringResult += '"' + '' + '"';
                        // console.log('scm approval status is false');
                    }
                } 
                    else if (value == 'Phoenix_Finance_Approval__c' || value == 'Phoenix_Finance_Comments__c') {
                    if (objectRecords[i]["Phoenix_Final_Finance_Approval__c"] == true) {
                        if (objectRecords[i][value] == undefined) {
                            //console.log('Iam in last ELSEE if---->');
                            csvStringResult += '"' + '' + '"';
                        } else {
                            csvStringResult += '"' + objectRecords[i][value] + '"';
                        }
                    }
                }
                
                 else if(value == 'Phoenix_Retail_Direct_Price__c'){
                   
                     
                          var retailDirectP= (objectRecords[i]["Phoenix_Retail_Direct_Price__c"]!=null && objectRecords[i]["Phoenix_Retail_Direct_Price__c"]!=undefined)?objectRecords[i]["Phoenix_Retail_Direct_Price__c"]:(objectRecords[i]["Phoenix_Retail_Direct_Sales_Price__c"]!=null && objectRecords[i]["Phoenix_Retail_Direct_Sales_Price__c"]!=undefined)?objectRecords[i]["Phoenix_Retail_Direct_Sales_Price__c"]:(objectRecords[i]["Phoenix_Current_Retail_Direct_Price__c"]!=null && objectRecords[i]["Phoenix_Current_Retail_Direct_Price__c"]!=undefined)?objectRecords[i]["Phoenix_Current_Retail_Direct_Price__c"]:0;
                          if(retailDirectP>0){
                              csvStringResult += '"'+ retailDirectP+'"';  
                          }
                         
                          else{
                               	csvStringResult += '"'+''+'"';
                          }
                      
                    
                 }
                 else if(value == 'Phoenix_Retail_Indirect_Price__c'){
                   
                     
                          var retailInDirectP= (objectRecords[i]["Phoenix_Retail_Indirect_Price__c"]!=null && objectRecords[i]["Phoenix_Retail_Indirect_Price__c"]!=undefined)?objectRecords[i]["Phoenix_Retail_Indirect_Price__c"]:(objectRecords[i]["Phoenix_Wholesaler_Sales_Price__c"]!=null && objectRecords[i]["Phoenix_Wholesaler_Sales_Price__c"]!=undefined)?objectRecords[i]["Phoenix_Wholesaler_Sales_Price__c"]:(objectRecords[i]["Phoenix_Current_Retail_Indirect_Price__c"]!=null && objectRecords[i]["Phoenix_Current_Retail_Indirect_Price__c"]!=undefined)?objectRecords[i]["Phoenix_Current_Retail_Indirect_Price__c"]:0;
                          if(retailInDirectP>0){
                              csvStringResult += '"'+ retailInDirectP+'"';  
                          }
                         
                          else{
                               	csvStringResult += '"'+''+'"';
                          }
                      
                    
                 }
                
                        else if (objectRecords[i][value] == undefined) {
                    csvStringResult += '"' + '' + '"';
                } else {
                    csvStringResult += '"' + objectRecords[i][value] + '"';
                }

                counter++;
            }
            csvStringResult += lineDivider;
        }
        //new logic end 
        return csvStringResult;
    },
    submitForProceed: function (component, event, helper, isContracts) {
        component.set('v.isSpinnerLoad', true);
        var action = component.get("c.submitToProceddStep");
        action.setParams({
            bidId: component.get("v.recordId"),
            isContracts: isContracts,
            ismarketingDeligator: false,
            deligatedUserName: ''
        });
        action.setCallback(this, function (response) {
            if (response.getState() === "SUCCESS") {
                component.set('v.isSpinnerLoad', false);
                var ResultData = response.getReturnValue();
                var resultlength = ResultData.length;
                console.log('resultslength--' + resultlength);
                var isApproved = false;
                var approveStatusFlag = false; //for step staus ==>false:'rejected' ;true:'approved'
                if (resultlength == 0) {
                    isApproved = true;
                } else {
                    if (isContracts == false) {
                        ResultData.forEach(function (line) {
                            if (line['Phoenix_Marketing_Approval__c'] == 'None' || line['Phoenix_Marketing_Approval__c'] == '' || line['Phoenix_Marketing_Approval__c'] == null || line['Phoenix_Marketing_Approval__c'] == 'undefined') {
                                isApproved = true;
                                console.log("marketingApproval--->" + line['Phoenix_Marketing_Approval__c']);
                            }
                            if (line['Phoenix_Marketing_Approval__c'] == 'Approved') {
                                approveStatusFlag = true;
                            }
                        });
                    } else {
                        ResultData.forEach(function (line) {
                            if (line['Phoenix_Contract_Approval__c'] == 'Pending' || line['Phoenix_Contract_Approval__c'] == '' || line['Phoenix_Contract_Approval__c'] == null || line['Phoenix_Contract_Approval__c'] == 'undefined') {
                                isApproved = true;
                                console.log("Phoenix_Contract_Approval__c--->" + line['Phoenix_Contract_Approval__c']);
                            }
                            if (line['Phoenix_Contract_Approval__c'] == 'Sent to Customer') {
                                approveStatusFlag = true;
                            }
                        });
                    }
                }
                if (isApproved == true) {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type": "warning",
                        "title": "Failed!",
                        "message": "Please confirm each approval to proceed further"
                    });
                    toastEvent.fire();

                } else {
                    if (isContracts) {
                        helper.MarkApprovalsContracts(component, event, helper, ResultData, approveStatusFlag, isContracts);
                    } else {
                        helper.MarkApprovals(component, event, helper, ResultData, approveStatusFlag);
                    }

                }
            } else {
                component.set('v.isSpinnerLoad', false);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": "error",
                    "title": "error!",
                    "message": "Something went wrong,please contact admin."
                });
                toastEvent.fire();
            }

        });
        $A.enqueueAction(action);
    },
    MarkApprovals: function (component, event, helper, ResultData, approveStatusFlag) {
        var action = component.get("c.makeApprovals");
        action.setParams({
            bidId: component.get("v.recordId"),
            bidlines: ResultData,
            approveStatusFlag: approveStatusFlag
        });
        action.setCallback(this, function (response) {
            if (response.getState() === "SUCCESS") {
                var wrapNextSteps = response.getReturnValue();
                var marketStepLsit = wrapNextSteps.updateProcessStepList;
                var flagSCMStop = wrapNextSteps.flagSCMStop;
                var flagMarketStop = wrapNextSteps.flagMarketStop;
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": "success",
                    "title": "Success",
                    "message": "Your Approvals are submitted successfully."
                });
                toastEvent.fire(); //updateNextProcessSteps
                if (flagSCMStop == false && flagMarketStop == false) {
                    helper.UpdateNextSteps(component, event, helper, marketStepLsit, flagSCMStop, flagMarketStop);
                }
                $A.get('e.force:refreshView').fire();
            } else {
                toastEvent.setParams({
                    "type": "error",
                    "title": "error!",
                    "message": "Something went wrong,please contact admin."
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);

    },
    MarkApprovalsContracts: function (component, event, helper, ResultData, approveStatusFlag, isContracts) {
        console.log('MarkApprovalsContracts--');
        var action = component.get("c.makeApprovalsContracts");
        action.setParams({
            bidId: component.get("v.recordId"),
            bidlines: ResultData,
            approveStatusFlag: approveStatusFlag,
            isContracts: isContracts
        });
        action.setCallback(this, function (response) {
            if (response.getState() === "SUCCESS") {
                var responseList = response.getReturnValue();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": "success",
                    "title": "Success",
                    "message": "Your Approvals are submitted successfully."
                });
                toastEvent.fire(); //updateNextProcessSteps
                helper.UpdateNextStepsContracts(component, event, helper, responseList);
                $A.get('e.force:refreshView').fire();
            } else {
                toastEvent.setParams({
                    "type": "error",
                    "title": "error!",
                    "message": "Something went wrong,please contact admin."
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);

    },
    UpdateNextStepsContracts: function (component, event, helper, Stepsist) {
        console.log('UpdateNextStepsContracts--');
        var action = component.get("c.updateNextContractProcessSteps");
        action.setParams({
            bidId: component.get("v.recordId"),
            bidName: component.get("v.bidName"),
            processStepLsit: Stepsist
        });
        action.setCallback(this, function (response) {
            if (response.getState() === "SUCCESS") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": "success",
                    "title": "Success",
                    "message": "Your Approvals are submitted successfully."
                });
                toastEvent.fire(); //updateNextProcessSteps
                //helper.UpdateNextSteps(component,event,helper);
                $A.get('e.force:refreshView').fire();
            }
        });
        $A.enqueueAction(action);
    },

    UpdateNextSteps: function (component, event, helper, marketStepLsit, flagSCMStop, flagMarketStop) {
        var action = component.get("c.updateNextProcessSteps");
        action.setParams({
            bidId: component.get("v.recordId"),
            bidName: component.get("v.bidName"),
            processStepLsit: marketStepLsit,
            flagSCMStop: flagSCMStop,
            flagMarketStop: flagMarketStop
        });
        action.setCallback(this, function (response) {
            if (response.getState() === "SUCCESS") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": "success",
                    "title": "Success",
                    "message": "Your Approvals are submitted successfully."
                });
                toastEvent.fire(); //updateNextProcessSteps
                //helper.UpdateNextSteps(component,event,helper);
                $A.get('e.force:refreshView').fire();
            }
        });
        $A.enqueueAction(action);
    }

})