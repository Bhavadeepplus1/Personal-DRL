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
    getBidInfoForValids: function (component, event, helper) {
        component.set('v.isSpinnerLoad', true);
        var action = component.get("c.getSubmitBidInfo");
        action.setParams({
            bidId: component.get("v.recordId")
        });
        action.setCallback(this, function (response) {
            if (response.getState() == "SUCCESS") {
                var resposneString = response.getReturnValue();
                console.log(resposneString);
                if (resposneString == 'Success') {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "message": "Bid is sent for approval.",
                        "type": "success",
                        "mode": "dismissible"
                    });
                    toastEvent.fire();
                    component.set('v.isSpinnerLoad', false);
                    component.find("navigationService").navigate({
                        type: "standard__recordPage",
                        attributes: {
                            recordId: component.get("v.recordId"),
                            actionName: "view"
                        }
                    }, false);
                } else {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": resposneString,
                        "type": "error",
                        "mode": "dismissible"
                    });
                    toastEvent.fire();
                    component.set('v.isSpinnerLoad', false);
                }
            }
        });
        $A.enqueueAction(action);
    },

    getAllTotalValues: function (component, event, helper) {
        var action = component.get("c.getAllTotals");
        action.setParams({
            bidId: component.get("v.recordId")
        });
        action.setCallback(this, function (response) {
            if (response.getState() == "SUCCESS") {
                var responseValue = response.getReturnValue();
                //component.set("v.FISUTotal",responseValue[0].fisu);
                //component.set("v.FDSUTotal",responseValue[0].fdsu);
                //component.set("v.CISUTotal",responseValue[0].cisu);
                //component.set("v.CDSUTotal",responseValue[0].cdsu);
                //component.set("v.netSalesIntTotal",responseValue[0].netsint);
                component.set("v.TotalSellingUnits", responseValue[0].cdsu);
             
                //component.set("v.intDeadNetTotal",responseValue[0].intdead);
                component.set("v.RetailDirGuideP", responseValue[0].retaildirguidesales);
                //component.set("v.WHLSGuideP",responseValue[0].whslGuidesales);
                component.set("v.RetailGuideP", responseValue[0].retailguidesales);
                //component.set("v.WHLSP",responseValue[0].whslsales);
                component.set("v.currentDSHP", responseValue[0].currentDSHP);
                component.set("v.proposedDSHP", responseValue[0].proposedDSHP);
                component.set("v.ActualTotalUnits", responseValue[0].ActualTotalUnits);
                var OverrideDirUnits=0;
                var OverrideInDirUnits=0;
                var OverUnits=0;
                if(responseValue[0].OverrideDirUnits>0)
                 OverrideDirUnits=responseValue[0].OverrideDirUnits;
                  if(responseValue[0].OverrideInDirUnits>0)
                   OverrideInDirUnits=responseValue[0].OverrideInDirUnits;
                if(responseValue[0].OverUnits>0)
                   OverUnits=responseValue[0].OverUnits;
                var OverrideTotal=OverrideDirUnits+OverrideInDirUnits+OverUnits;
                
                 var proposedBase=0;
                var proposedDSH=0;
                var proposedAutoSub=0;
                if(responseValue[0].proposedBase>0)
                 proposedBase=responseValue[0].proposedBase;
                  if(responseValue[0].proposedDSH>0)
                   proposedDSH=responseValue[0].proposedDSH;
                if(responseValue[0].proposedAutoSub>0)
                   proposedAutoSub=responseValue[0].proposedAutoSub;
                var ProposedTotal=proposedBase+proposedDSH+proposedAutoSub;
                   component.set("v.FinalTotalSellingUnits", ProposedTotal);
                
                console.log('OverrideTotal-------'+OverrideTotal);
                component.set("v.OverrideTotalUnits", OverrideTotal);
                component.set("v.RetailDirP", responseValue[0].retailmarketing);
                component.set("v.RetailInDirP", responseValue[0].retailIndirectmrket);
                component.set("v.BASEDRLNetP", responseValue[0].BASEDRLNetP);
                component.set("v.DSHDRLNetP", responseValue[0].DSHDRLNetP);
                component.set("v.AutoSubDRLNetP", responseValue[0].AutoSubDRLNetP);
                
                
                
                  component.set("v.BASEAnnualUsage", responseValue[0].BASEAnnualUsage);
                component.set("v.BASEAnnualNetSales", responseValue[0].BASEAnnualNetSales);
                component.set("v.BASECOGS", responseValue[0].BASECOGS);
                component.set("v.BASETPbeforePS", responseValue[0].BASETPbeforePS);
                
                  component.set("v.DSHAnnualUsage", responseValue[0].DSHAnnualUsage);
                component.set("v.DSHAnnualNetSales", responseValue[0].DSHAnnualNetSales);
                component.set("v.DSHCOGS", responseValue[0].DSHCOGS);
                component.set("v.DSHTPbeforePS", responseValue[0].DSHTPbeforePS);
                
                  component.set("v.AUTOSUBAnnualUsage", responseValue[0].AUTOSUBAnnualUsage);
                component.set("v.AUTOSUBAnnualNetSales", responseValue[0].AUTOSUBAnnualNetSales);
                component.set("v.AUTOSUBCOGS", responseValue[0].AUTOSUBCOGS);
                component.set("v.AUTOSUBTPbeforePS", responseValue[0].AUTOSUBTPbeforePS);
                
                 component.set("v.BASEMonthlyUnits", responseValue[0].BASEMonthlyUnits);
                component.set("v.DSHMonthlyUnits", responseValue[0].DSHMonthlyUnits);
                component.set("v.AutoSubMonthlyUnits", responseValue[0].AutoSubMonthlyUnits);
                
                  component.set("v.baseSCMQty", responseValue[0].baseSCMQty);
                component.set("v.DSHSCMQty", responseValue[0].DSHSCMQty);
                component.set("v.AutoSubSCMQty", responseValue[0].AutoSubSCMQty);
                 component.set("v.TotalSCMQty", responseValue[0].scmAPQTY);
                
                 component.set("v.currentwholesalerUnits", responseValue[0].currentwholesalerUnits);
                component.set("v.currentAndaUnits", responseValue[0].currentAndaUnits);
                 component.set("v.currentRetailDirectUnits", responseValue[0].currentRetailDirectUnits);
                
                  component.set("v.actSalInd12months", responseValue[0].actSalInd12months);
                component.set("v.actSaDir12Months", responseValue[0].actSaDir12Months);
                 component.set("v.proposedDirGiantUnits", responseValue[0].proposedDirGiantUnits);
                
                   component.set("v.overRideDirectUnits", responseValue[0].overRideDirectUnits);
                component.set("v.overRideIndirectUnits", responseValue[0].overRideIndirectUnits);
                 component.set("v.OverUnits", responseValue[0].OverUnits);
                
                  component.set("v.proposedBase", responseValue[0].proposedBase);
                component.set("v.proposedDSH", responseValue[0].proposedDSH);
                 component.set("v.proposedAutoSub", responseValue[0].proposedAutoSub);
                
                
                //component.set("v.ProposedTpMargin",responseValue[0].propoTPmargin);
                console.log('responseValue[0].retailmarketing-----' + responseValue[0].retailmarketing);
                //var ProposedTPTDir = responseValue[0].pnsd =! 0 ? (responseValue[0].pTPTDir/responseValue[0].pnsd)*100 : 0;
                //var ProposedTPTInDir = responseValue[0].pnsd =! 0 ? (responseValue[0].pTPTInd/responseValue[0].pnsInd)*100 : 0;
                //var BlendedTPMargin = responseValue[0].netsint =! 0 ? (responseValue[0].thptm/responseValue[0].netsint)*100 : 0;
                //component.set("v.proTPTPerDir",ProposedTPTDir);
                //component.set("v.proTPTPerIndir",ProposedTPTInDir);
                //component.set("v.BlendedTPMargin",BlendedTPMargin);
               
                /*New Product Launch*/
                                   component.set("v.OpeningOrderTotal",responseValue[0].OpeningOrder);
                                   component.set("v.OpeningOrderNetSalesTotal",responseValue[0].OpeningOrderNetSales);
                                   component.set("v.OpeningOrderTPTTotal",responseValue[0].OpeningOrderTPT);
                                   var opntptPerc = responseValue[0].OpeningOrderNetSales =! 0 ? (responseValue[0].OpeningOrderTPT / responseValue[0].OpeningOrderNetSales)*100 :0;
									component.set("v.OpeningOrderTPTPercTotal",opntptPerc);
                   /*New Product Launch*/
          
            } else {
                console.log('totals-errir-');
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
            if (lineItemsList.length < 8) {
                console.log('--no-hight---');
                $A.util.addClass(OutDiv, "noheightClass");
            } else {
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
            // searchInput:searchInput

        });
        action.setCallback(this, function (response) {
            if (response.getState() === "SUCCESS") {
                var responseList = response.getReturnValue();
                console.log('---responseList---' + responseList.length);
                //component.set("v.contratcsList",responseList);

                //below code is for remove seleceted while fetch contracts in table
                var slctpositions = component.get('v.selectedPosistions');
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
                component.set("v.positionsList", finalPositions);
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
                            return other == current.Phoenix_Contract_Number__c
                        }).length == 0;
                    }
                }

                for (var i = 0; i < finalContratcs.length; i++) {
                    var row = finalContratcs[i];
                    if (row.Phoenix_Customer__c) {
                        row.Phoenix_Customer__c = row.Phoenix_Customer__r.Name;
                    }
                }
                component.set("v.contratcsList", finalContratcs);
            }


        });
        $A.enqueueAction(action);
    },
    getNPRDataOfContracts: function (component, event, helper, selectrcs, templateType) {

        var action = component.get("c.getNPRDataDSH");
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
    convertArrayOfObjectsToCSV: function (component, objectRecords, template, bidType, isReBid, isCalcView) {
        // declare variables
        var csvStringResult, counter, keys, columnDivider, lineDivider;

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
        
        myMap.set("NDC", "Phoenix_NDC__c");
        myMap.set("SAP Number", "Phoenix_Product_Code1__c");
        myMap.set("Product Family", "Product_Family_Name__c");
        myMap.set("Pkg Size", "Phoenix_Pkg_Size__c");
        myMap.set("Product Name", "Phoenix_Product__r.Name");
        
        
        /*if (isReBid == true) {
                myMap.set("Previous Bid", "Phoenix_Previous_Bid__r.Name");
                myMap.set("Previous Bid Line Item", "Phoenix_Previous_LineItem__r.Name");
            }*/
        myMap.set("Case Pack", "Phoenix_Case_Pack__c");
        myMap.set("MOQ", "Phoenix_MOQ1__c");
        myMap.set("Compare To (Brand Name)", "Phoenix_Compare_To_Brand_Name1__c");
        myMap.set("Product Director", "Phoenix_Product_Director__c");
        myMap.set("Orange Book Rating", "Phoenix_Orange_Book_Rating1__c");
        myMap.set("WAC", "Phoenix_WAC__c");
        myMap.set("Throughput Cost", "Phoenix_Throughput_cost__c");

        myMap.set("REMS Programme", "Phoenix_REMS__c");
        
        
        myMap.set("Proposed IOD Units", "Phoenix_Proposed_Anda_Units__c");
        myMap.set("IOD Per Unit $", "Phoenix_ANDA_IOD_Per_unit__c");
        myMap.set("IOD Overall Amount", "Phoenix_Retail_IOD_overall_amount__c");
        
        myMap.set("Budgeted ASP", "Phoenix_Budgeted_ASP1__c");
        
        myMap.set("Latest Estimate ASP", "Phoenix_Latest_Estimate__c");
        myMap.set("Lowest Price SKU", "Phoenix_Lowest_Price_SKU1__c");
        
        myMap.set("Marketing Notes", "Phoenix_Marketing_Notes__c");
        
        myMap.set("Finance Approval", "Phoenix_Finance_Approval__c");
        
        myMap.set("Finance Comments", "Phoenix_Finance_Comments__c");
        
        
        
        myMap.set("Contract Status", "Phoenix_Contract_Approval__c");
        myMap.set("Contract Comments", "Phoenix_Contract_Comments__c");
        myMap.set("WAC Check", "Phoenix_WAC_Check__c");   


        csvStringResult += Array.from(myMap.keys()).join(columnDivider);
        csvStringResult += lineDivider;
        //new logic start 
        for (var i = 0; i < objectRecords.length; i++) {
            counter = 0;
            for (let [key, value] of myMap) {
                if (counter > 0) {
                    csvStringResult += columnDivider;
                }
                //console.log('testing result--->'+JSON.stringify(objectRecords[i]));
                if (value == 'Phoenix_Product__r.Name') {
                    csvStringResult += '"' + objectRecords[i]["Phoenix_Product__r"]["Name"] + '"';
                } else if (value == 'Phoenix_Previous_Bid__r.Name') {
                    if (objectRecords[i]['Phoenix_Is_Re_Bid_Line_Item__c'] == true) {
                        csvStringResult += '"' + objectRecords[i]["Phoenix_Previous_Bid__r"]["Name"] + '"';
                    }

                } else if (value == 'Phoenix_Previous_LineItem__r.Name') {
                    if (objectRecords[i]['Phoenix_Is_Re_Bid_Line_Item__c'] == true) {
                        csvStringResult += '"' + objectRecords[i]["Phoenix_Previous_LineItem__r"]["Name"] + '"';
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
                
                
                    else if (value == 'Proposed_TPT_Per_Direct__c') {
                    var Proposed_tpt = objectRecords[i]['Proposed_TPT_Per_Direct__c'];
                    //console.log('Proposed_tpt direct initialvalue-->'+Proposed_tpt);
                    if (Proposed_tpt != null) {
                        var rounded_tpt = Math.round(Proposed_tpt * 100) / 100
                        //var rounded_tpt=Math.round((Proposed_tpt + Number.EPSILON) * 100) / 100
                        //console.log('Proposed_tpt direct rounded value-->'+rounded_tpt);
                        csvStringResult += '"' + rounded_tpt + '"';
                    } else {
                        csvStringResult += '"' + '' + '"';
                    }
                } else if (value == 'Proposed_TPT_Per_Indirect__c') {
                    var Proposed_tpt = objectRecords[i]['Proposed_TPT_Per_Indirect__c'];
                    //console.log('Proposed_tpt Indirect initialvalue-->'+Proposed_tpt);
                    if (Proposed_tpt != null) {
                        var rounded_tpt = Math.round(Proposed_tpt * 100) / 100
                        //console.log('Proposed_tpt indirect rounded value-->'+rounded_tpt);
                        csvStringResult += '"' + rounded_tpt + '"';
                    } else {
                        csvStringResult += '"' + '' + '"';
                    }
                } else if (value == 'Phoenix_Internal_Dead_Net_Price__c') {
                    var deadnetprice = objectRecords[i]['Phoenix_Internal_Dead_Net_Price__c'];
                    //console.log('deadnetprice initialvalue-->'+deadnetprice);
                    if (deadnetprice != null) {
                        var rounded_price = Math.round(deadnetprice * 100) / 100
                        //console.log('deadnetprice rounded value-->'+rounded_price);
                        csvStringResult += '"' + rounded_price + '"';
                    } else {
                        csvStringResult += '"' + '' + '"';
                    }
                } else if (value == 'Phoenix_Rebate_Perc_In__c') {
                    var rebateperindl = objectRecords[i]['Phoenix_Rebate_Perc_In__c'];
                    // console.log('rebateperindl-->'+rebateperindl);
                    if (rebateperindl != null) {
                        var rounded_rebateperindl = Math.round(rebateperindl * 100) / 100
                        //console.log('rebateperindl rounded value-->'+rounded_price);
                        csvStringResult += '"' + rounded_rebateperindl + '"';
                    } else {
                        csvStringResult += '"' + '' + '"';
                    }
                } else if (value == 'Phoenix_Admin_Fee_in__c') {
                    var adminfeeindl = objectRecords[i]['Phoenix_Admin_Fee_in__c'];
                    // console.log('adminfeeindl-->'+adminfeeindl);
                    if (adminfeeindl != null) {
                        var rounded_adminfeeindl = Math.round(adminfeeindl * 100) / 100
                        csvStringResult += '"' + rounded_adminfeeindl + '"';
                    } else {
                        csvStringResult += '"' + '' + '"';
                    }
                } else if (value == 'Direct_VIP_Per_Unit__c') {
                    var vipperunitdl = objectRecords[i]['Direct_VIP_Per_Unit__c'];
                    // console.log('vipperunitdl-->'+vipperunitdl);
                    if (vipperunitdl != null) {
                        var rounded_vipperunitdl = Math.round(vipperunitdl * 100) / 100
                        csvStringResult += '"' + rounded_vipperunitdl + '"';
                    } else {
                        csvStringResult += '"' + '' + '"';
                    }
                } else if (value == 'Phoenix_Sales_Out_Promotion_Per_unit_in__c') {
                    var salesoutpmpudl = objectRecords[i]['Phoenix_Sales_Out_Promotion_Per_unit_in__c'];
                    // console.log('salesoutpmpudl-->'+salesoutpmpudl);
                    if (salesoutpmpudl != null) {
                        var rounded_salesoutpmpudl = Math.round(salesoutpmpudl * 100) / 100
                        csvStringResult += '"' + rounded_salesoutpmpudl + '"';
                    } else {
                        csvStringResult += '"' + '' + '"';
                    }

                } else if (value == 'Phoenix_IOD_Per_Unit_in__c') {
                    var iodperunitindl = objectRecords[i]['Phoenix_IOD_Per_Unit_in__c'];
                    // console.log('iodperunitindl-->'+iodperunitindl);
                    if (iodperunitindl != null) {
                        var rounded_iodperunitindl = Math.round(iodperunitindl * 100) / 100
                        csvStringResult += '"' + rounded_iodperunitindl + '"';
                    } else {
                        csvStringResult += '"' + '' + '"';
                    }
                } else if (value == 'Phoenix_Direct_CD_Per_Unit__c') {
                    var cdperunitdirect = objectRecords[i]['Phoenix_Direct_CD_Per_Unit__c'];
                    // console.log('cdperunitdirect-->'+cdperunitdirect);
                    if (cdperunitdirect != null) {
                        var rounded_cdperunitdirect = Math.round(cdperunitdirect * 100) / 100
                        csvStringResult += '"' + rounded_cdperunitdirect + '"';
                    } else {
                        csvStringResult += '"' + '' + '"';
                    }
                } else if (value == 'Phoenix_RDC_NLC__c') {
                    var totalrdcnlcper = objectRecords[i]['Phoenix_RDC_NLC__c'];
                    // console.log('totalrdcnlcper-->'+totalrdcnlcper);
                    if (totalrdcnlcper != null) {
                        var rounded_totalrdcnlcper = Math.round(totalrdcnlcper * 100) / 100
                        csvStringResult += '"' + rounded_totalrdcnlcper + '"';
                    } else {
                        csvStringResult += '"' + '' + '"';
                    }
                } else if (value == 'Phoenix_RDC_NLC_Per_Unit_in__c') {
                    var rdcnlcperunitindl = objectRecords[i]['Phoenix_RDC_NLC_Per_Unit_in__c'];
                    // console.log('rdcnlcperunitindl-->'+rdcnlcperunitindl);
                    if (rdcnlcperunitindl != null) {
                        var rounded_rdcnlcperunitindl = Math.round(rdcnlcperunitindl * 100) / 100
                        csvStringResult += '"' + rounded_rdcnlcperunitindl + '"';
                    } else {
                        csvStringResult += '"' + '' + '"';
                    }
                } else if (value == 'Phoenix_Customer_Fees__c') {
                    var cmfeeperunit = objectRecords[i]['Phoenix_Customer_Fees__c'];
                    // console.log('cmfeeperunit-->'+cmfeeperunit);
                    if (cmfeeperunit != null) {
                        var rounded_cmfeeperunit = Math.round(cmfeeperunit * 100) / 100
                        csvStringResult += '"' + rounded_cmfeeperunit + '"';
                    } else {
                        csvStringResult += '"' + '' + '"';
                    }
                } else if (value == 'Phoenix_Medicaid_Returns_Per_Unit_in__c') {
                    var medicaidretperunit = objectRecords[i]['Phoenix_Medicaid_Returns_Per_Unit_in__c'];
                    // console.log('medicaidretperunit-->'+medicaidretperunit);
                    if (medicaidretperunit != null) {
                        var rounded_medicaidretperunit = Math.round(medicaidretperunit * 100) / 100
                        csvStringResult += '"' + rounded_medicaidretperunit + '"';
                    } else {
                        csvStringResult += '"' + '' + '"';
                    }
                } else if (value == 'Phoenix_Direct_Dead_Net__c') {
                    var directdeadnet = objectRecords[i]['Phoenix_Direct_Dead_Net__c'];
                    // console.log('directdeadnet-->'+directdeadnet);
                    if (directdeadnet != null) {
                        var rounded_directdeadnet = Math.round(directdeadnet * 100) / 100
                        csvStringResult += '"' + rounded_directdeadnet + '"';
                    } else {
                        csvStringResult += '"' + '' + '"';
                    }
                } else if (value == 'Phoenix_Proposed_ZITD__c') {
                    var proposedzitd = objectRecords[i]['Phoenix_Proposed_ZITD__c'];
                    // console.log('proposedzitd-->'+proposedzitd);
                    if (proposedzitd != null) {
                        var rounded_proposedzitd = Math.round(proposedzitd * 100) / 100
                        csvStringResult += '"' + rounded_proposedzitd + '"';
                    } else {
                        csvStringResult += '"' + '' + '"';
                    }
                } else if (value == 'Phoenix_Indirect_Dead_Net__c') {
                    var indirectdeadnet = objectRecords[i]['Phoenix_Indirect_Dead_Net__c'];
                    // console.log('indirectdeadnet-->'+indirectdeadnet);
                    if (indirectdeadnet != null) {
                        var rounded_indirectdeadnet = Math.round(indirectdeadnet * 100) / 100
                        csvStringResult += '"' + rounded_indirectdeadnet + '"';
                    } else {
                        csvStringResult += '"' + '' + '"';
                    }

                } else if (value == 'Phoenix_Net_Sales_Internal__c') {
                    var netsalesinternal = objectRecords[i]['Phoenix_Net_Sales_Internal__c'];
                    // console.log('netsalesinternal-->'+netsalesinternal);
                    if (netsalesinternal != null) {
                        var rounded_indirectdeadnet = Math.round(netsalesinternal)
                        csvStringResult += '"' + rounded_indirectdeadnet + '"';
                    } else {
                        csvStringResult += '"' + '' + '"';
                    }

                } else if (value == 'Phoenix_IOD_Total_Amount__c') {
                    var iodtotalamount = objectRecords[i]['Phoenix_IOD_Total_Amount__c'];
                    // console.log('iodtotalamount-->'+iodtotalamount);
                    if (iodtotalamount != null) {
                        var rounded_iodtotalamount = Math.round(iodtotalamount * 100) / 100
                        csvStringResult += '"' + rounded_iodtotalamount + '"';
                    } else {
                        csvStringResult += '"' + '' + '"';
                    }
                } else if (value == 'Phoenix_DRL_Dead_Net_After_IOD_w_o_MR__c') {
                    var drldaednetafteriod = objectRecords[i]['Phoenix_DRL_Dead_Net_After_IOD_w_o_MR__c'];
                    // console.log('drldaednetafteriod-->'+drldaednetafteriod);
                    if (drldaednetafteriod != null) {
                        var rounded_drldaednetafteriod = Math.round(drldaednetafteriod * 100) / 100
                        csvStringResult += '"' + rounded_drldaednetafteriod + '"';
                    } else {
                        csvStringResult += '"' + '' + '"';
                    }
                } else if (value == 'Phoenix_DRL_Dead_net_W_o_IOD_Med_Returns__c') {
                    var drldaednetafteriodwo = objectRecords[i]['Phoenix_DRL_Dead_net_W_o_IOD_Med_Returns__c'];
                    // console.log('drldaednetafteriodwo-->'+drldaednetafteriodwo);
                    if (drldaednetafteriodwo != null) {
                        var rounded_drldaednetafteriodwo = Math.round(drldaednetafteriodwo * 100) / 100
                        csvStringResult += '"' + rounded_drldaednetafteriodwo + '"';
                    } else {
                        csvStringResult += '"' + '' + '"';
                    }
                } else if (value == 'Phoenix_INDIRECT_CD__c') {
                    var indirectcdperundl = objectRecords[i]['Phoenix_INDIRECT_CD__c'];
                    // console.log('indirectcdperundl-->'+indirectcdperundl);
                    if (indirectcdperundl != null) {
                        var rounded_indirectcdperundl = Math.round(indirectcdperundl * 100) / 100
                        csvStringResult += '"' + rounded_indirectcdperundl + '"';
                    } else {
                        csvStringResult += '"' + '' + '"';
                    }
                } else if (value == 'Phoenix_Indirect_Dead_Net_w_o_Med_Retrns__c') {
                    var indirectdeadnetmedret = objectRecords[i]['Phoenix_Indirect_Dead_Net_w_o_Med_Retrns__c'];
                    // console.log('indirectdeadnetmedret-->'+indirectdeadnetmedret);
                    if (indirectdeadnetmedret != null) {
                        var rounded_indirectdeadnetmedret = Math.round(indirectdeadnetmedret * 100) / 100
                        csvStringResult += '"' + rounded_indirectdeadnetmedret + '"';
                    } else {
                        csvStringResult += '"' + '' + '"';
                    }
                } else if (value == 'Proposed_Net_Sales_Direct__c') {
                    var proposednetsalesdirect = objectRecords[i]['Proposed_Net_Sales_Direct__c'];
                    // console.log('proposednetsalesdirect-->'+proposednetsalesdirect);
                    if (proposednetsalesdirect != null) {
                        var rounded_proposednetsalesdirect = Math.round(proposednetsalesdirect * 100) / 100
                        csvStringResult += '"' + rounded_proposednetsalesdirect + '"';
                    } else {
                        csvStringResult += '"' + '' + '"';
                    }
                } else if (value == 'Proposed_Net_Sales_Indirect__c') {
                    var proposednetsalesindirect = objectRecords[i]['Proposed_Net_Sales_Indirect__c'];
                    // console.log('proposednetsalesindirect-->'+proposednetsalesindirect);
                    if (proposednetsalesindirect != null) {
                        var rounded_proposednetsalesindirect = Math.round(proposednetsalesindirect * 100) / 100
                        csvStringResult += '"' + rounded_proposednetsalesindirect + '"';
                    } else {
                        csvStringResult += '"' + '' + '"';
                    }
                } else if (value == 'Proposed_TPT_Direct__c') {
                    var proposedtpdldirect = objectRecords[i]['Proposed_TPT_Direct__c'];
                    // console.log('proposedtpdldirect-->'+proposedtpdldirect);
                    if (proposedtpdldirect != null) {
                        var rounded_proposedtpdldirect = Math.round(proposedtpdldirect * 100) / 100
                        csvStringResult += '"' + rounded_proposedtpdldirect + '"';
                    } else {
                        csvStringResult += '"' + '' + '"';
                    }
                } else if (value == 'Proposed_TPT_Indirect__c') {
                    var proposedtpdlindirect = objectRecords[i]['Proposed_TPT_Indirect__c'];
                    // console.log('proposedtpdlindirect-->'+proposedtpdlindirect);
                    if (proposedtpdlindirect != null) {
                        var rounded_proposedtpdlindirect = Math.round(proposedtpdlindirect * 100) / 100
                        csvStringResult += '"' + rounded_proposedtpdlindirect + '"';
                    } else {
                        csvStringResult += '"' + '' + '"';
                    }

                } else if (value == 'Phoenix_Latest_Estimate__c') {
                    var latestestimateasp = objectRecords[i]['Phoenix_Latest_Estimate__c'];
                    // console.log('latestestimateasp-->'+latestestimateasp);
                    if (latestestimateasp != null) {
                        var rounded_latestestimateasp = Math.round(latestestimateasp * 100) / 100
                        csvStringResult += '"' + rounded_latestestimateasp + '"';
                    } else {
                        csvStringResult += '"' + '' + '"';
                    }

                } else if (value == 'Phoenix_REMS__c') {
                    var rems_value = objectRecords[i]['Phoenix_REMS__c'];
                    // console.log("remss valuee-->"+rems_value);
                    if (rems_value == true) {
                        // console.log("yesss");
                        csvStringResult += '"' + 'Yes' + '"';
                    } else {
                        csvStringResult += '"' + 'No' + '"';
                    }
                }   else if (value == 'Phoenix_Finance_Approval__c' || value == 'Phoenix_Finance_Comments__c') {
                    if (objectRecords[i]["Phoenix_Final_Finance_Approval__c"] == true) {
                        if (objectRecords[i][value] == undefined) {
                            //console.log('Iam in last ELSEE if---->');
                            csvStringResult += '"' + '' + '"';
                        } else {
                            csvStringResult += '"' + objectRecords[i][value] + '"';
                        }
                    }
                }
                    else if (value == 'Phoenix_Override_Total_units__c') {
                 
                        if (objectRecords[i][value] == undefined) {
                            //console.log('Iam in last ELSEE if---->');
                            csvStringResult += '"' + '' + '"';
                        } else {
                            var override1=0;
                              var override2=0;
                              var override3=0;
                              if (objectRecords[i]["Phoenix_Override_Current_Direct_Units__c"] != undefined) override1=objectRecords[i]["Phoenix_Override_Current_Direct_Units__c"];
                                  if (objectRecords[i]["Phoenix_Override_Current_Indirect_Units__c"] != undefined) override2=objectRecords[i]["Phoenix_Override_Current_Indirect_Units__c"];
                                      if (objectRecords[i]["Phoenix_Override_Current_Units__c"] != undefined) override3=objectRecords[i]["Phoenix_Override_Current_Units__c"];
                            
                            var override4=override1+override2+override3;
                            csvStringResult += '"' + override4 + '"';
                        }
                    
                }
                else if(value == 'Phoenix_Approved_Lowest_Price_SKU__c'){
                        var isContractStepCmpted=objectRecords[i]['Phoenix_Contracts_Final_Approval__c'];
                        var approvedLowsetPrice=objectRecords[i]['Phoenix_Approved_Lowest_Price_SKU__c'];
                        //console.log('Proposed_tpt direct initialvalue-->'+Proposed_tpt);
                    if(isContractStepCmpted != null && isContractStepCmpted){
                        csvStringResult += '"'+ approvedLowsetPrice +'"';
                    }
                    else{
                        csvStringResult += '"'+''+'"';
                    }
                    }
                else if (value == 'Phoenix_Final_Total_Selling_Unit__c') {
                 
                        if (objectRecords[i][value] == undefined) {
                            //console.log('Iam in last ELSEE if---->');
                            csvStringResult += '"' + '' + '"';
                        } else {
                             var override1=0;
                              var override2=0;
                              var override3=0;
                              if (objectRecords[i]["Phoenix_Proposed_Smith_Drug_Units__c"] != undefined) override1=objectRecords[i]["Phoenix_Proposed_Smith_Drug_Units__c"];
                                  if (objectRecords[i]["Phoenix_Proposed_Anda_Units__c"] != undefined) override2=objectRecords[i]["Phoenix_Proposed_Anda_Units__c"];
                                      if (objectRecords[i]["Phoenix_ProposedDirectAholdDelhaizeUnits__c"] != undefined) override3=objectRecords[i]["Phoenix_ProposedDirectAholdDelhaizeUnits__c"];
                              var override4=override1+override2+override3;
                            csvStringResult += '"' +override4 + '"';
                        }
                    
                }
                        else if (objectRecords[i][value] == undefined) {
                    //console.log('Iam in last ELSEE if---->');
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
    submitForProceed: function (component, event, helper, isContracts,contrcts) {
        component.set('v.isSpinnerLoad', true);
        var ismarketingDeligator = component.get("v.ismarketingDeligator");
        var deligatedUserName = component.get("v.deligatedUserName");
        var action = component.get("c.submitToProceddStep");
        action.setParams({
            bidId:component.get("v.recordId"),
            isContracts:isContracts,
            ismarketingDeligator: ismarketingDeligator,
            deligatedUserName: deligatedUserName

        });
        action.setCallback(this, function (response) {
            if (response.getState() === "SUCCESS") {
                component.set('v.isSpinnerLoad', false);
                var ResultData = response.getReturnValue();
                var resultlength = ResultData.length;
                var bidtype = component.get("v.BidTypeVal");
                var delegatedUser = component.get("v.deligatedUserName");
                console.log('resultslength--' + resultlength);
                var qtyError;
                for (var i = 0; i < resultlength; i++) {
                        if((ResultData[i].Phoenix_Proposed_Anda_Units__c==null  )){
                                               qtyError='Please Enter Proposed IOD Units for '+ResultData[i].Phoenix_Product__r.Name;
                                               console.log('in AutoSub');
                                               break;
                                           }
                    if (contrcts.length>0 && (contrcts.includes("3000000634")|| contrcts.includes("3000000929")||contrcts.includes("3000000746")|| contrcts.includes("3000000767")|| contrcts.includes("3000000448") ||contrcts.includes("3000000447")|| contrcts.includes("3000000440")|| contrcts.includes("3000000441") ||contrcts.includes("3000000964")|| contrcts.includes("3000000963")|| contrcts.includes("3000000469") ||contrcts.includes("3000000468")|| 
                          contrcts.includes("3000000419")|| contrcts.includes("3000000351") || contrcts.includes("3000000352")|| contrcts.includes("3000000653")||contrcts.includes("3000000652")|| contrcts.includes("3000000911")|| contrcts.includes("3000000912")|| contrcts.includes("3000000859")|| contrcts.includes("3000001310")|| contrcts.includes("3000000383")||contrcts.includes("3000001088")|| contrcts.includes("3000001690")|| contrcts.includes("3000001691")||contrcts.includes("3000000762")|| contrcts.includes("3000000763") || contrcts.includes("3000001344")|| contrcts.includes("3000001548")||contrcts.includes("3000001541")|| contrcts.includes("3000001343"))&& component.get("v.BidAprrovalStatus") != 'Draft' && (ResultData[i].Phoenix_Product_Director__c == component.get("v.loggedInUserName") || (delegatedUser != null && delegatedUser.includes(ResultData[i].Phoenix_Product_Director__c))) && ResultData[i].Phoenix_Retail_Direct_Price__c == null && bidtype != 'Volume Review Only' && bidtype != 'Sales Out Rebate' && bidtype != 'Customer Rebate Change'  ) {
                        if (ResultData[i].Phoenix_Marketing_Approval__c != 'Not Approved') {
                            qtyError = 'Please Enter Proposed BASE Contract Price';
                            console.log('Proposed BASE Contract Price');
                            break;
                        } else {
                            break;
                        }
                    } else if (contrcts.length>0 && (contrcts.includes("3000000589"))&& component.get("v.BidAprrovalStatus") != 'Draft' && (ResultData[i].Phoenix_Product_Director__c == component.get("v.loggedInUserName") || (delegatedUser != null && delegatedUser.includes(ResultData[i].Phoenix_Product_Director__c))) && ResultData[i].Phoenix_Retail_Indirect_Price__c == null && bidtype != 'Volume Review Only' && bidtype != 'Sales Out Rebate' && bidtype != 'Customer Rebate Change' ) {
                        if (ResultData[i].Phoenix_Marketing_Approval__c != 'Not Approved') {
                            qtyError = 'Please Enter Proposed AutoSub Contract Price';
                            console.log('Proposed AutoSub Contract Price');
                            break;
                        } else {
                            break;
                        }
                    }
                    else if (component.get("v.BidAprrovalStatus")!='Draft' && ResultData[i].Phoenix_Product_Director__c==component.get("v.loggedInUserName") && bidtype == 'New Product Launch' && ResultData[i].Phoenix_Wholesaler_DRL_Net_Price__c < ResultData[i].Phoenix_Lowest_Price_SKU__c && ResultData[i].Phoenix_Wholesaler_DRL_Net_Price__c != 0){
                         					if (ResultData[i].Phoenix_Marketing_Approval__c != 'Not Approved') {   
                             				qtyError='You cannot submit this Bid for Approval as Dead Net is less than Lowest Price/SKU: '+ResultData[i].Phoenix_Product__r.Name;
                              				break;
                         					}
                          					else {
                            					break;
                        					}
                    }
                    /*For Delegation*/
                    else if (component.get("v.BidAprrovalStatus")!='Draft' && (ResultData[i].Phoenix_Product_Director__c==component.get("v.loggedInUserName") || (delegatedUser != null && delegatedUser.includes(ResultData[i].Phoenix_Product_Director1__c))) && bidtype == 'New Product Launch' && ResultData[i].Phoenix_Wholesaler_DRL_Net_Price__c < ResultData[i].Phoenix_Lowest_Price_SKU__c && ResultData[i].Phoenix_Wholesaler_DRL_Net_Price__c != 0){
                         					if (ResultData[i].Phoenix_Marketing_Approval__c != 'Not Approved') {   
                             				qtyError='You cannot submit this Bid for Approval as Dead Net is less than Lowest Price/SKU: '+ResultData[i].Phoenix_Product__r.Name;
                              				break;
                         					}
                          					else {
                            					break;
                        					}
                    }
                    /*End For Delegation*/
                }
                if (qtyError) {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "type": "error",
                        "message": qtyError
                    });
                    toastEvent.fire();
                } else {
                    var isApproved = false;
                    var approveStatusFlag = false; //for step staus ==>false:'rejected' ;true:'approved'
                    if (resultlength == 0) {
                        isApproved = true;
                    } else {
                        if (isContracts == false) {
                            ResultData.forEach(function (line) {
                                if (line['Phoenix_Marketing_Approval__c'] == 'None' || line['Phoenix_Marketing_Approval__c'] == '' || line['Phoenix_Marketing_Approval__c'] == null || line['Phoenix_Marketing_Approval__c'] == 'undefined') {
                                    isApproved = true;
                                    //console.log("marketingApproval--->"+line['Phoenix_Marketing_Approval__c']);
                                }
                                if (line['Phoenix_Marketing_Approval__c'] == 'Approved') {
                                    approveStatusFlag = true;
                                }
                            });
                        } else {
                            ResultData.forEach(function (line) {
                                if (line['Phoenix_Contract_Approval__c'] == 'None' || line['Phoenix_Contract_Approval__c'] == '' || line['Phoenix_Contract_Approval__c'] == null || line['Phoenix_Contract_Approval__c'] == 'undefined') {
                                    isApproved = true;
                                    console.log("Phoenix_Contract_Approval__c--->" + line['Phoenix_Contract_Approval__c']);
                                }
                                if (line['Phoenix_Contract_Approval__c'] == 'Approved') {
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