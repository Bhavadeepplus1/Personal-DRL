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
    convertArrayOfObjectsToCSV: function (component, objectRecords, template) {
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
        csvStringResult = '';
        var selling_unit = '1';
        var myMap = new Map();
        myMap.set("NDC", "Phoenix_NDC_National_Drug_Code__c");
        myMap.set("Product Name", "Phoenix_Product__r.Name");
        myMap.set("SAP Number", "Phoenix_Product_Code__c");
        myMap.set("Pkg Size", "Phoenix_Pkg_Size__c");
        myMap.set("Case Pack", "Phoenix_Case_Pack__c");
        myMap.set("MOQ", "Phoenix_MOQ__c");
        myMap.set("Product Family", "Product_Family_Name__c");
        myMap.set("Compare To (Brand Name)", "Phoenix_Compare_To_Brand_Name1__c");
        myMap.set("Product Director", "Phoenix_Product_Director__c");
        myMap.set("Orange Book Rating", "Phoenix_Orange_Book_Rating__c");
        myMap.set("Throughput Cost", "Phoenix_Throughput_cost__c");
        myMap.set("WAC", "Phoenix_WAC__c");
        myMap.set("Latest Estimate", "Phoenix_Latest_Estimate__c");
        myMap.set("IMS Market Share", "Phoenix_IMS_Market_Share__c");
        myMap.set("REMS Programme", "Phoenix_REMS__c");
        myMap.set("Doses", "Phoenix_Doses__c");
        myMap.set("Proposed Direct Selling Unit", "Phoenix_Proposed_Direct_Selling_Unit__c");
        myMap.set("Final Annual Extended Units", "Phoenix_Final_Annual_Extended_Units__c");
        myMap.set("Direct Order Price", "Phoenix_Direct_Order_Price__c");
        //myMap.set("Proposed Contract Bid Price (Sales)", "Phoenix_ProposedContract_Bid_Price_Sales__c");
        myMap.set("Proposed Contract Bid Price (Marketing)", "Phoenix_ProposedContractBidPriceMktng__c");
        myMap.set("Fee (G/N)", "Phoenix_Fee_G_N__c");
        myMap.set("Admin Fee %", "Phoenix_Current_Admin_Fee__c");
        myMap.set("Admin Fee in $", "Phoenix_Admin_Fee_in__c");
        myMap.set("CD Per Unit $", "Phoenix_CD_Per_Unit_in__c");
        myMap.set("Estimated Medicaid and Returns", "Phoenix_Estimated_Medicaid_Returns1__c");
        myMap.set("Internal Dead Net Price", "Phoenix_Internal_Dead_Net_Price__c");
        myMap.set("Net Sales (Internal", "Phoenix_Net_Sales_Internal__c");
        myMap.set("Th. Put Margin $$$", "Phoenix_Th_Put_Margin__c");
        
        myMap.set("TP Margin %", "Phoenix_TP_Margin__c");
        myMap.set("Budgeted ASP", "Phoenix_Budgeted_ASP__c");
        myMap.set("Lowest Price /SKU", "Phoenix_Lowest_Price_SKU__c");
        //myMap.set("Sales Notes", "Phoenix_Sales_Notes__c");
        myMap.set("Dating", "Phoenix_Current_MCK_Position__c");
        myMap.set("Batch ID", "Phoenix_Current_Supplier__c");
        myMap.set("Expiration", "Phoenix_Expiry_Date__c");
        
        myMap.set("Marketing Notes", "Phoenix_Marketing_Notes__c");
        myMap.set("Finance Approval", "Phoenix_Finance_Approval__c");
        myMap.set("Finance Approval", "Phoenix_Finance_Comments__c");
        myMap.set("Finance Comments", "Phoenix_Finance_Comments__c");
        myMap.set("WAC Check", "Phoenix_WAC_Check__c");
        myMap.set("Comm. Exps %", "Phoenix_Comm_Exps1__c");
        myMap.set("Commercial Cost", "Phoenix_Commercial_Cost__c");
        myMap.set("Profit Available For Distribution", "Phoenix_Profit_available_fr_distribution__c");
        myMap.set("PS Partner 1", "Phoenix_PS_Partner_Name1__c");
        myMap.set("PS % -Partner 1", "Phoenix_PS_Partner_1percent__c");
        myMap.set("Min Profit Share - Partner 1", "Phoenix_Min_profit_share_Partner_1__c");
        myMap.set("Profit Share To Partner 1", "Phoenix_Profit_share_to_partner1__c");
        myMap.set("PS Partner 2", "Phoenix_PS_Partner_21__c");
        myMap.set("PS % -Partner 2", "Phoenix_PS_Partner_2percent__c");
        myMap.set("Min Profit Share - Partner 2", "Phoenix_Min_profit_share_Partner_2__c");
        myMap.set("Profit Share To partner 2", "Phoenix_Profit_share_to_partner2__c");
        myMap.set("Total Profit Share", "Phoenix_Total_Profit_share__c");
        myMap.set("Value Total Profit Share", "Phoenix_Value_Total_Profit_Share__c");
        myMap.set("Royalty Partner Name", "Phoenix_Royalty_Partner_Name1__c");
        myMap.set("Royalty %", "Phoenix_Royaltypercent__c");
        myMap.set("Royalty", "Phoenix_Royalty1__c");
        myMap.set("Value Royalty", "Phoenix_Value_Royalty__c");
        myMap.set("DRL Share", "Phoenix_DRL_Share__c");
        myMap.set("Total DRL Share", "Phoenix_Total_DRL_Share__c");
        myMap.set("DRL Margin %", "Phoenix_DRL_Margin_DRL__c");
        myMap.set("Current Royalty", "Phoenix_Current_Royalty__c");
        myMap.set("Current Profit Available For Distribution", "Phoenix_Current_Profit_Available_For_Dis__c");
        myMap.set("Current Profit Share To Partner 1", "Phoenix_Current_Profit_Share_To_Partner1__c");
        myMap.set("Current Profit Share To Partner 2", "Phoenix_Current_Profit_Share_To_Partner2__c");
        myMap.set("Current DRL Share", "Phoenix_Current_DRL_Share__c");
        myMap.set("DRL Share Impact", "Phoenix_DRL_Share_Impact__c");
        myMap.set("TP/GM Impact Before PS + SSA Hit", "Phoenix_Annualized_TP_Impact__c");
        myMap.set("TP/GM Impact After PS + SSA Hit", "Phoenix_Annualized_GM_Impact__c");
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
                } else if(value=='Product_Family_Name__c' && objectRecords[i]["Product_Family_Name__c"] == null){
                    csvStringResult += '"'+ objectRecords[i]["Phoenix_Product_Family__c"]+'"';
                } else if (value == 'Phoenix_REMS__c') {
                    var remsValue = objectRecords[i]["Phoenix_REMS__c"] ? 'YES': 'NO';
                    csvStringResult += '"' + remsValue + '"';
                } else if (value == 'Phoenix_Proposed_Direct_Selling_Unit__c') {
                    csvStringResult += '"' + selling_unit + '"';
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
    }
})