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
    searchProductFamilyChange: function (component, event, helper) {
        component.set('v.isSpinnerLoad', true);
        var action = component.get("c.findByProductFamily");
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
        console.log('listOfSearchPDRecords---' + component.get("v.listOfSearchPDRecords"));
    },
    convertArrayOfObjectsToCSV: function (component, objectRecords, template, bidType) {
        // declare variables
        var csvStringResult, counter, keys, columnDivider, lineDivider;
        var temp = template;
        var bidtype = bidType;
        console.log('Bid TYpe--->' + bidtype);
        // check if "objectRecords" parameter is null, then return from function
        if (objectRecords == null || !objectRecords.length) {
            return null;
        }
        // store ,[comma] in columnDivider variabel for sparate CSV values and 
        // for start next line use '\n' [new line] in lineDivider varaible  
        columnDivider = ',';
        lineDivider = '\n';
        var proposed_value = '1';
        
        // in the keys valirable store fields API Names as a key 
        // this labels use in CSV file header 
        csvStringResult = '';
        var myMap = new Map();
        myMap.set("NDC", "Phoenix_NDC__c");
        myMap.set("SAP Number", "Phoenix_Product_Code1__c");
        myMap.set("Product Name", "Phoenix_Product__r.Name");
        myMap.set("Pkg Size", "Phoenix_Pkg_Size__c");
        myMap.set("Product Family", "Product_Family_Name__c");
        myMap.set("Case Pack", "Phoenix_Case_Pack__c");
        myMap.set("MOQ", "Phoenix_MOQ1__c");
        myMap.set("Compare To (Brand Name)", "Phoenix_Compare_To_Brand_Name1__c");
        myMap.set("Product Director", "Phoenix_Product_Director__c");
        myMap.set("Orange Book Rating", "Phoenix_Orange_Book_Rating1__c");
        myMap.set("Throughput Cost", "Phoenix_Throughput_cost__c");
        myMap.set("WAC", "Phoenix_WAC__c");
        myMap.set("Latest Estimate", "Phoenix_Latest_Estimate__c");
        myMap.set("IMS Market Share", "Phoenix_IMS_Market_Share__c");
        myMap.set("REMS Programme", "Phoenix_REMS__c");
        myMap.set("Proposed Indirect Selling Unit", "Phoenix_Proposed_Indirect_Selling_Unit__c");
        myMap.set("Current Floor Price", "Phoenix_IPA_Floor_Price1__c");
        myMap.set("Proposed Contract Bid Price (Sales)", "Phoenix_ProposedContract_Bid_Price_Sales__c");
         myMap.set("Proposed Contract Bid Price (Marketing)", "Phoenix_ProposedContractBidPriceMktng__c");
        // myMap.set("Proposed Current Rebate %", "Phoenix_Proposed_Current_Rebate__c");
        //myMap.set("Proposed Per Unit Rebate", "Phoenix_Proposed_Per_Unit_Rebate__c");
        // myMap.set("Current Per Unit Rebate", "Phoenix_Current_Per_Unit_Rebate__c");
        // myMap.set("Rebate (G/N)", "Phoenix_Rebate_G_N__c");
        //myMap.set("Rebate % In $", "Phoenix_Rebate_Perc_In__c");
        // myMap.set("Value Per Unit Rebate", "Phoenix_Value_Per_Unit_Rebate__c");
        myMap.set("Admin Fee (G/N)", "Phoenix_Fee_G_N__c");
        myMap.set("Admin Fee in $", "Phoenix_Admin_Fee_in__c");
        myMap.set("Value Admin Fee $", "Phoenix_Value_Admin_Fee__c");
        // myMap.set("Value Est VIP %", "Phoenix_Value_Est_VIP__c");
        // myMap.set("Sales Out Promotion", "Phoenix_Sales_Out_Promotion__c");
        //  myMap.set("Initial Order Discount", "Phoenix_Initial_Order_Discount__c");
        myMap.set("Value Cash Terms", "Phoenix_Value_Cash_Terms__c");
        myMap.set("CM Fee Per Unit", "Phoenix_CM_Fees_Per_Unit_in__c");
        myMap.set("Internal Dead Net Price", "Phoenix_Internal_Dead_Net_Price__c");
        myMap.set("Estimated Medicaid & Returns", "Phoenix_Estimated_Medicaid_Returns1__c");
        myMap.set("Net Sales (Internal)", "Phoenix_Net_Sales_Internal__c");
        myMap.set("Less Cost", "Phoenix_Less_Cost__c");
        myMap.set("Th. Put Margin $$$", "Phoenix_Th_Put_Margin__c");
        
        myMap.set("TP Margin %", "Phoenix_TP_Margin__c");
        myMap.set("Budgeted ASP", "Phoenix_Budgeted_ASP1__c");
        myMap.set("Lowest Price /SKU", "Phoenix_Lowest_Price_SKU__c");
         myMap.set("Sales Notes", "Phoenix_Sales_Notes__c");
         myMap.set("Marketing Approval", "Phoenix_Marketing_Approval__c");
        myMap.set("Marketing Notes", "Phoenix_Marketing_Notes__c");
        myMap.set("Finance Approval", "Phoenix_Finance_Approval__c");
        myMap.set("Finance Comments", "Phoenix_Finance_Comments__c");
        // myMap.set("Contract Approval", "Phoenix_Contract_Approval__c");
        myMap.set("Contract Approval", "Phoenix_Contract_Approval__c");
        myMap.set("Contract Comments", "Phoenix_Contract_Comments__c");
        myMap.set("WAC Check", "Phoenix_WAC_Check__c");
        /*
        myMap.set("Comm. Exps %", "Phoenix_Comm_Exps__c");
        myMap.set("Commercial Cost", "Phoenix_Commercial_Cost__c");
        myMap.set("Profit Available For Distribution", "Phoenix_Profit_available_fr_distribution__c");
        myMap.set("PS Partner 1", "Phoenix_PS_Partner_Name1__c");
        myMap.set("PS % -Partner 1", "Phoenix_PS_Partner_1__c");
        myMap.set("Profit Share To Partner 1", "Phoenix_Profit_share_to_partner1__c");
        myMap.set("PS Partner 2", "Phoenix_PS_Partner_Name2__c");
        myMap.set("PS % -Partner 2", "Phoenix_PS_Partner_2__c");
        myMap.set("Profit Share To partner 2", "Phoenix_Profit_share_to_partner2__c");
        myMap.set("Total Profit Share", "Phoenix_Total_Profit_share__c");
        myMap.set("Value Total Profit Share", "Phoenix_Value_Total_Profit_Share__c");
        myMap.set("Royalty Partner Name", "Phoenix_Royalty_Partner_Name__c");
        myMap.set("Royalty %", "Phoenix_Royalty__c");
        myMap.set("Royalty", "Phoenix_Royalty1__c");
        myMap.set("Value Royalty", "Phoenix_Value_Royalty__c");
        myMap.set("DRL Share", "Phoenix_DRL_Share__c");
        myMap.set("Total DRL Share", "Phoenix_Total_DRL_Share__c");
        myMap.set("DRL Margin", "Phoenix_DRL_Margin_DRL__c"); */
        csvStringResult += Array.from(myMap.keys()).join(columnDivider);
        csvStringResult += lineDivider;
        //new logic start 
        for (var i = 0; i < objectRecords.length; i++) {
            counter = 0;
            for (let [key, value] of myMap) {
                if (counter > 0) {
                    csvStringResult += columnDivider;
                }
                //console.log(JSON.stringify(objectRecords[i]));
                if (value == 'Phoenix_Product__r.Name') {
                    csvStringResult += '"' + objectRecords[i]["Phoenix_Product__r"]["Name"] + '"';
                } else if (value == 'Phoenix_Proposed_Indirect_Selling_Unit__c') {
                    csvStringResult += '"' + proposed_value + '"';
                } else if (value == 'Phoenix_REMS__c') {
                    var remsValue = objectRecords[i]["Phoenix_REMS__c"] ? 'YES': 'NO';
                    csvStringResult += '"' + remsValue + '"';
                } else if (objectRecords[i][value] == undefined) {
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
            isContracts: isContracts
        });
        action.setCallback(this, function (response) {
            if (response.getState() === "SUCCESS") {
                component.set('v.isSpinnerLoad', false);
                var ResultData = response.getReturnValue();
                var resultlength = ResultData.length;
                console.log('resultslength--' + resultlength);
                var isApproved = false;
                var qtyError;
                var approveStatusFlag = false; //for step staus ==>false:'rejected' ;true:'approved'
                if (resultlength == 0) {
                    isApproved = true;
                } else {
                    if (isContracts == false) {
                        ResultData.forEach(function (line) {
                           if(component.get("v.BidAprrovalStatus")!='Draft' && (line.Phoenix_Product_Director__c==component.get("v.loggedInUserName"))&& line.Phoenix_ProposedContractBidPriceMktng__c==null){	
                                if(line.Phoenix_Marketing_Approval__c !='Not Approved'){
                                    qtyError='Please Enter Marketing Price';	
                                    console.log('marketing Price');	
                                } 
                               
                            } else if (line['Phoenix_Marketing_Approval__c'] == 'None' || line['Phoenix_Marketing_Approval__c'] == '' || line['Phoenix_Marketing_Approval__c'] == null || line['Phoenix_Marketing_Approval__c'] == 'undefined') {
                                qtyError='Please confirm each approval to proceed further';	
                                console.log("marketingApproval--->"+line['Phoenix_Marketing_Approval__c']);
                            }  
                            if (line['Phoenix_Marketing_Approval__c'] == 'Approved') {
                                approveStatusFlag = true;
                            }
                        });
                    } else {
                        
                        ResultData.forEach(function (line) {
                            if (line['Phoenix_Contract_Approval__c'] == 'None' || line['Phoenix_Contract_Approval__c'] == '' || line['Phoenix_Contract_Approval__c'] == null || line['Phoenix_Contract_Approval__c'] == 'undefined') {
                                //qtyError='Please confirm each approval to proceed further';	
                                console.log("Phoenix_Contract_Approval__c--->" + line['Phoenix_Contract_Approval__c']);
                            }
                           
                            if (line['Phoenix_Contract_Approval__c'] == 'Approved') {
                                approveStatusFlag = true;
                            }
                        });
                    }
                }
                if (qtyError) {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type": "Error",
                        "title": "Failed!",
                        "message": qtyError
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
                if (flagMarketStop == false) {
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