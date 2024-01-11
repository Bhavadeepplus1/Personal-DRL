({
    getMarketShareData : function(component, event, helper, record) {
        var action = component.get("c.IMSData");
        var marketShareList = component.get("v.marketShareList");
        var userRelatedLineItems = component.get("v.userRelatedLineItems");
        action.setParams({
            'userRelatedLineItems' : userRelatedLineItems
        });
        action.setCallback(this, function(response) {
            if(response.getState() == 'SUCCESS'){
                var response = response.getReturnValue();
                var filteredBidLineItems = component.get("v.filteredBidLineItems");
                var familyMap = {}; var approvedLineItems = 0; var rejectedLineItems = 0; var noActionLineItems = 0;
                if(filteredBidLineItems != null){
                    for(var i=0; i<filteredBidLineItems.length; i++){
                        if(response != null){
                            for(var j=0; j<response.length; j++){
                                if(response[j].ndc == filteredBidLineItems[i].Phoenix_NDC_Without_Dashes__c){
                                    filteredBidLineItems[i].overallMark = response[j].overallMark;
                                    filteredBidLineItems[i].drlMarkShare = response[j].drlMarkShare;
                                    filteredBidLineItems[i].custMarkShare = response[j].custMarkShare;
                                    filteredBidLineItems[i].custVol = response[j].custVol;
                                    break;
                                }
                            }
                            if(familyMap.hasOwnProperty(filteredBidLineItems[i].Product_Family_Name__c)){
                                var relatedList = familyMap[filteredBidLineItems[i].Product_Family_Name__c];
                                relatedList.push(filteredBidLineItems[i]);
                                familyMap[filteredBidLineItems[i].Product_Family_Name__c] = relatedList;
                            } else{
                                var relatedList = [];
                                relatedList.push(filteredBidLineItems[i]);
                                familyMap[filteredBidLineItems[i].Product_Family_Name__c] = relatedList;
                            }
                            if(filteredBidLineItems[i].Phoenix_Marketing_Approval__c == 'Approved'){
                                approvedLineItems += 1;
                            } else if(filteredBidLineItems[i].Phoenix_Marketing_Approval__c == 'Not Approved'){
                                rejectedLineItems += 1;
                            } else{
                                noActionLineItems += 1;
                            }
                        }
                    }
                }
                component.set("v.approvedLineItems", approvedLineItems);
                component.set("v.rejectedLineItems", rejectedLineItems);
                component.set("v.noActionLineItems", noActionLineItems);
                if(familyMap != null){
                    var bid = component.get("v.bidRecord");
                    component.set("v.familyList", Object.keys(familyMap));
                    var families = Object.keys(familyMap);
                    var summaryList = []; var totalSummaryObj = {};
                    totalSummaryObj.currentUnitsEA = 0; totalSummaryObj.currentUnitsEU = 0; totalSummaryObj.currentSales = 0; totalSummaryObj.currentTPMargin = 0; totalSummaryObj.currentTPMarginPer = 0;
                    totalSummaryObj.proposedUnitsEA = 0; totalSummaryObj.proposedUnitsEU = 0; totalSummaryObj.proposedSales = 0; totalSummaryObj.proposedTPMargin = 0; totalSummaryObj.proposedTPMarginPer = 0;
                    totalSummaryObj.scmUnitsEA = 0; totalSummaryObj.scmUnitsEU = 0; totalSummaryObj.scmSales = 0; totalSummaryObj.scmTPMargin = 0; totalSummaryObj.scmTPMarginPer = 0;
                    for(var i=0; i<families.length; i++){
                        var summaryObj = {}; 
                        summaryObj.currentUnitsEA = 0; summaryObj.currentUnitsEU = 0; summaryObj.currentSales = 0; summaryObj.currentTPMargin = 0; summaryObj.currentTPMarginPer = 0;
                        summaryObj.proposedUnitsEA = 0; summaryObj.proposedUnitsEU = 0; summaryObj.proposedSales = 0; summaryObj.proposedTPMargin = 0; summaryObj.proposedTPMarginPer = 0;
                        summaryObj.scmUnitsEA = 0; summaryObj.scmUnitsEU = 0; summaryObj.scmSales = 0; summaryObj.scmTPMargin = 0; summaryObj.scmTPMarginPer = 0;
                        summaryObj.overallMark = 0; summaryObj.custVol = 0;
                        var relatedList = familyMap[families[i]];
                        summaryObj.family = families[i]; summaryObj.relatedList = relatedList; summaryObj.familyId = relatedList[0].Product_Family__c;
                        console.log('Family: '+families[i]);
                        for(var j=0; j<relatedList.length; j++){
                            console.log('Template: '+relatedList[j].Phoenix_Bid_Template_Refrence__c);
                            if(relatedList[j].Phoenix_Bid_Template_Refrence__c == 'Walgreens' || relatedList[j].Phoenix_Bid_Template_Refrence__c == 'ABC Progen' || relatedList[j].Phoenix_Bid_Template_Refrence__c == 'ABC Pharmagen'
                               || relatedList[j].Phoenix_Bid_Template_Refrence__c == 'Costco' || relatedList[j].Phoenix_Bid_Template_Refrence__c == 'Sams Club' || relatedList[j].Phoenix_Bid_Template_Refrence__c == 'Government Pricing'
                               || relatedList[j].Phoenix_Bid_Template_Refrence__c == 'Indirect' || relatedList[j].Phoenix_Bid_Template_Refrence__c == 'Humana Indirect retail' || relatedList[j].Phoenix_Bid_Template_Refrence__c == 'Humana Indirect CII'){
                                relatedList[j].units = relatedList[j].Phoenix_Proposed_Indirect_Selling_Unit__c;
                            } else if(relatedList[j].Phoenix_Bid_Template_Refrence__c == 'Direct'){
                                relatedList[j].units = relatedList[j].Phoenix_Proposed_Direct_Selling_Unit__c;
                                relatedList[j].sales = relatedList[j].Phoenix_Net_Sales_Internal__c;
                                console.log('Walgreen Sales: '+relatedList[j].sales);
                                relatedList[j].tpMargin = relatedList[j].Phoenix_Th_Put_Margin__c;
                                relatedList[j].tpMarginPer = relatedList[j].Phoenix_TP_Margin__c;
                            } else if(relatedList[j].Phoenix_Bid_Template_Refrence__c == 'Direct and Indirect'){
                                relatedList[j].units = relatedList[j].Phoenix_Proposed_Direct_Selling_Unit__c + relatedList[j].Phoenix_Proposed_Indirect_Selling_Unit__c;
                                relatedList[j].sales = relatedList[j].Phoenix_WMT_Indirect_Net_Sales__c;
                                relatedList[j].tpMargin = relatedList[j].Phoenix_Costco_TPT__c;
                                relatedList[j].tpMarginPer = relatedList[j].Phoenix_Anda_DRL_TPT_Percent__c;
                            } else if(bid.Phoenix_Bid_Type__c == 'OTC New Product' || bid.Phoenix_Bid_Type__c == 'OTC OTB Good Dated' || bid.Phoenix_Bid_Type__c == 'OTC OTB Short Dated'
                                      || bid.Phoenix_Bid_Type__c == 'OTC Price Change' || bid.Phoenix_Bid_Type__c == 'OTC Product Addition' || bid.Phoenix_Bid_Type__c == 'OTC RFP'
                                      || bid.Phoenix_Bid_Type__c == 'OTC Volume Review'){
                                relatedList[j].units = relatedList[j].Phoenix_Proposed_Direct_Selling_Unit__c;
                                relatedList[j].sales = relatedList[j].Phoenix_Net_Sales_Internal__c;
                                relatedList[j].tpMargin = relatedList[j].Phoenix_Th_Put_Margin__c;
                                relatedList[j].tpMarginPer = relatedList[j].Phoenix_Th_Put_Margin__c/relatedList[j].Phoenix_Net_Sales_Internal__c;
                            } else if(bid.Phoenix_Bid_Type__c == 'Good Dated OTB' || bid.Phoenix_Bid_Type__c == 'Short Dated OTB' || bid.Phoenix_Bid_Type__c == 'One Time Buy Good Dated Shelf Life for New Product Launch'){
                                relatedList[j].units = relatedList[j].Phoenix_Proposed_Direct_Selling_Unit__c + relatedList[j].Phoenix_Proposed_Indirect_Selling_Unit__c;
                                relatedList[j].sales = relatedList[j].Proposed_Net_Sales_Direct__c + relatedList[j].Proposed_Net_Sales_Indirect__c;
                                relatedList[j].tpMargin = relatedList[j].Proposed_TPT_Direct__c + relatedList[j].Proposed_TPT_Indirect__c;
                                relatedList[j].tpMarginPer = (relatedList[j].Proposed_TPT_Direct__c + relatedList[j].Proposed_TPT_Indirect__c)/(relatedList[j].Proposed_Net_Sales_Direct__c + relatedList[j].Proposed_Net_Sales_Indirect__c);
                            } else if(relatedList[j].Phoenix_Bid_Template_Refrence__c == 'Econdisc'){
                                relatedList[j].units = (relatedList[j].Phoenix_Direct_ESI__c+relatedList[j].Phoenix_Indirect_ESI__c+relatedList[j].Phoenix_Direct_Kroger__c+relatedList[j].Phoenix_Indirect_Kroger__c+relatedList[j].Phoenix_Direct_Rx_Outreach__c+relatedList[j].Phoenix_Indirect_Rx_Outreach__c+relatedList[j].Phoenix_Direct_Supervalu__c+relatedList[j].Phoenix_Indirect_Supervalu__c+relatedList[j].Phoenix_Direct_Cigna__c+relatedList[j].Phoenix_Indirect_Cigna__c+relatedList[j].Phoenix_Direct_Cordant__c+relatedList[j].Phoenix_Indirect_Cordant__c+relatedList[j].Phoenix_Direct_Accerodo__c+relatedList[j].Phoenix_Indirect_Accerodo__c);
                                relatedList[j].sales = relatedList[j].Phoenix_Net_Sales_Internal__c;
                                relatedList[j].tpMargin = relatedList[j].Phoenix_Th_Put_Margin__c;
                                relatedList[j].tpMarginPer = relatedList[j].Phoenix_TP_Margin__c;
                            } else if(relatedList[j].Phoenix_Bid_Template_Refrence__c == 'RXSS'){
                                relatedList[j].units = (relatedList[j].Phoenix_Proposed_Smith_Drug_Units__c+relatedList[j].Phoenix_Proposed_Anda_Units__c+relatedList[j].Phoenix_ProposedDirectAholdDelhaizeUnits__c+relatedList[j].Phoenix_ProposedDirectGaintEagleUnits__c+relatedList[j].Phoenix_ProposedIndirectAholdDelhaizeUni__c);
                                relatedList[j].sales = relatedList[j].Phoenix_Net_Sales_Internal__c;
                                relatedList[j].tpMargin = relatedList[j].Phoenix_Th_Put_Margin__c;
                                relatedList[j].tpMarginPer = relatedList[j].Phoenix_TP_Margin__c;
                            } else if(relatedList[j].Phoenix_Bid_Template_Refrence__c == 'ClarusOne'){
                                relatedList[j].units = (relatedList[j].Phoenix_Proposed_OS_Units__c+relatedList[j].Phoenix_Proposed_RAD_Units__c+relatedList[j].Phoenix_Proposed_WMT_Units__c);
                                relatedList[j].sales = relatedList[j].Phoenix_ProposedDirectGaintEagleUnits__c;
                                relatedList[j].tpMargin = relatedList[j].Phoenix_ProposedDirectAholdDelhaizeUnits__c;
                                relatedList[j].tpMarginPer = relatedList[j].Phoenix_Retail_Indirect_DRL_TPT_Percent__c;
                            } else if(relatedList[j].Phoenix_Bid_Template_Refrence__c == 'Net Indirect Pricing'){
                                relatedList[j].units = relatedList[j].Phoenix_Proposed_Direct_Selling_Unit__c + relatedList[j].Phoenix_Proposed_Indirect_Selling_Unit__c;
                                relatedList[j].sales = relatedList[j].Phoenix_Net_Sales_Internal__c;
                                relatedList[j].tpMargin = relatedList[j].Phoenix_Th_Put_Margin__c;
                                relatedList[j].tpMarginPer = relatedList[j].Phoenix_TP_Margin__c;
                            } else if(relatedList[j].Phoenix_Bid_Template_Refrence__c == 'BASE/DSH'){
                                relatedList[j].units = (relatedList[j].Phoenix_Proposed_Smith_Drug_Units__c + relatedList[j].Phoenix_Proposed_Anda_Units__c + relatedList[j].Phoenix_ProposedDirectAholdDelhaizeUnits__c);
                                relatedList[j].sales = (relatedList[j].Phoenix_Retail_IOD_overall_amount__c + relatedList[j].Phoenix_Retail_Direct_Net_sales__c + relatedList[j].Phoenix_Wholesaler_Net_Sales__c);
                                relatedList[j].tpMargin = (relatedList[j].Phoenix_Wholesaler_IOD_overall_amount__c + relatedList[j].Phoenix_Anda_Net_Model_Sales__c + relatedList[j].Phoenix_Wholesaler_Guidance_Price__c);
                                relatedList[j].tpMarginPer = relatedList[j].tpMargin/relatedList[j].sales;   
                            } else if(relatedList[j].Phoenix_Bid_Template_Refrence__c == 'ROS'){
                                relatedList[j].units = (relatedList[j].BidLineItemsExtn__r[0].Phoenix_Proposed_CVS_DirSellingUnits__c + relatedList[j].BidLineItemsExtn__r[0].Phoenix_Proposed_CVS_IndirSellingUnits__c + relatedList[j].BidLineItemsExtn__r[0].Phoenix_Proposed_Cardinal_Units__c + relatedList[j].BidLineItemsExtn__r[0].Phoenix_Proposed_Major_Units__c);
                                relatedList[j].sales = relatedList[j].Phoenix_Net_Sales_Internal__c;
                                relatedList[j].tpMargin = relatedList[j].BidLineItemsExtn__r[0].Phoenix_Total_RedOak_TPT__c ;
                                relatedList[j].tpMarginPer = relatedList[j].BidLineItemsExtn__r[0].Phoenix_Total_RedOak_TPT_Per__c;
                            }
                            if(bid.Phoenix_Bid_Type__c == 'Price Change' || bid.Phoenix_Bid_Type__c == 'Customer Rebate Change'
                               || bid.Phoenix_Bid_Type__c == 'OTC Price Change' || bid.Phoenix_Bid_Type__c == 'OTC Rebate Change'
                               || bid.Phoenix_Bid_Type__c == 'Sales Out Rebate'){
                                relatedList[j].units = relatedList[j].Phoenix_Final_Total_Selling_Unit__c;
                            }
                            console.log('Sales: '+relatedList[j].sales);
                            console.log('Units: '+relatedList[j].units);
                            relatedList[j].proposedASP = isNaN(relatedList[j].sales/relatedList[j].units) ? 0: relatedList[j].sales/relatedList[j].units; // Proposed ASP for Proposed Section
                            relatedList[j].proposedSales = relatedList[j].units * relatedList[j].proposedASP;
                            relatedList[j].proposedTpMargin = relatedList[j].proposedSales - (relatedList[j].Phoenix_Throughput_cost__c * relatedList[j].units);
                            relatedList[j].proposedTpMarginPer = (relatedList[j].proposedTpMargin/relatedList[j].proposedSales)*100;
                            summaryObj.currentUnitsEA += parseFloat(relatedList[j].Phoenix_Total_Selling_Unit__c);
                            summaryObj.currentUnitsEU += parseFloat(relatedList[j].Phoenix_Total_Selling_Unit__c * relatedList[j].Phoenix_Pkg_Size1__c);
                            summaryObj.currentSales += parseFloat(relatedList[j].Finance_Current_Sales__c);
                            summaryObj.currentTPMargin += parseFloat(relatedList[j].Phoenix_Current_TP_Margin__c);
                            summaryObj.proposedUnitsEA += parseFloat(relatedList[j].units);
                            summaryObj.proposedUnitsEU += parseFloat(relatedList[j].units * relatedList[j].Phoenix_Pkg_Size1__c);
                            summaryObj.proposedSales += parseFloat(relatedList[j].proposedSales);
                            summaryObj.proposedTPMargin += parseFloat(relatedList[j].proposedTpMargin);
                            if(relatedList[j].Phoenix_SCM_Approval_Y_N__c != 'N- Not Approved' && relatedList[j].Phoenix_SCM_Final_Approval__c && relatedList[j].Phoenix_SCM_Approval_Y_N__c != null){
                                relatedList[j].scmUnitsEA = parseFloat(relatedList[j].Phoenix_Total_SCM_Approved_Qty__c);
                                relatedList[j].scmUnitsEU = parseFloat(relatedList[j].Phoenix_Total_SCM_Approved_Qty__c * relatedList[j].Phoenix_Pkg_Size1__c);
                                relatedList[j].scmProposedASP = isNaN(relatedList[j].sales/relatedList[j].scmUnitsEA)?0: (relatedList[j].sales/relatedList[j].scmUnitsEA);
                                relatedList[j].scmSales = parseFloat(relatedList[j].scmUnitsEA*relatedList[j].Phoenix_Proposed_ASP_Dose__c);
                                summaryObj.scmUnitsEA += parseFloat(relatedList[j].Phoenix_Total_SCM_Approved_Qty__c);
                                summaryObj.scmUnitsEU += parseFloat(relatedList[j].Phoenix_Total_SCM_Approved_Qty__c * relatedList[j].Phoenix_Pkg_Size1__c);
                                summaryObj.scmSales += parseFloat(relatedList[j].scmUnitsEA*relatedList[j].Phoenix_Proposed_ASP_Dose__c); //parseFloat(relatedList[j].Phoenix_Total_SCM_Approved_Qty__c*relatedList[j].Phoenix_Proposed_ASP_Dose__c);
                                summaryObj.scmTPMargin += parseFloat(relatedList[j].scmSales-(relatedList[j].Phoenix_Total_SCM_Approved_Qty__c*relatedList[j].Phoenix_Throughput_cost__c));   
                            }    
                        }
                        totalSummaryObj.currentUnitsEA += parseFloat(summaryObj.currentUnitsEA);
                        totalSummaryObj.currentUnitsEU += parseFloat(summaryObj.currentUnitsEU);
                        totalSummaryObj.currentSales += parseFloat(summaryObj.currentSales);
                        totalSummaryObj.currentTPMargin += parseFloat(summaryObj.currentTPMargin);
                        totalSummaryObj.proposedUnitsEA += parseFloat(summaryObj.proposedUnitsEA);
                        totalSummaryObj.proposedUnitsEU += parseFloat(summaryObj.proposedUnitsEU);
                        totalSummaryObj.proposedSales += parseFloat(summaryObj.proposedSales);
                        totalSummaryObj.proposedTPMargin += parseFloat(summaryObj.proposedTPMargin);
                        totalSummaryObj.scmUnitsEA += parseFloat(summaryObj.scmUnitsEA);
                        totalSummaryObj.scmUnitsEU += parseFloat(summaryObj.scmUnitsEU);
                        totalSummaryObj.scmSales += parseFloat(summaryObj.scmSales);
                        totalSummaryObj.scmTPMargin += parseFloat(summaryObj.scmTPMargin);
                        summaryList.push(summaryObj);
                    }
                    component.set("v.summaryList", summaryList);
                    component.set("v.totalSummaryObj", totalSummaryObj);
                }
            } else{
                console.log("Exception: "+JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);
    },
    buildData: function(component, event, helper){
        var filteredBidLineItems = component.get("v.filteredBidLineItems");
        var familyMap = {}; var approvedLineItems = 0; var rejectedLineItems = 0; var noActionLineItems = 0;
        if(filteredBidLineItems != null){
            for(var i=0; i<filteredBidLineItems.length; i++){
                if(familyMap.hasOwnProperty(filteredBidLineItems[i].Product_Family_Name__c)){
                    var relatedList = familyMap[filteredBidLineItems[i].Product_Family_Name__c];
                    relatedList.push(filteredBidLineItems[i]);
                    familyMap[filteredBidLineItems[i].Product_Family_Name__c] = relatedList;
                } else{
                    var relatedList = [];
                    relatedList.push(filteredBidLineItems[i]);
                    familyMap[filteredBidLineItems[i].Product_Family_Name__c] = relatedList;
                }
                if(filteredBidLineItems[i].Phoenix_Marketing_Approval__c == 'Approved'){
                    approvedLineItems += 1;
                } else if(filteredBidLineItems[i].Phoenix_Marketing_Approval__c == 'Not Approved'){
                    rejectedLineItems += 1;
                } else{
                    noActionLineItems += 1;
                }
            }
        }
        component.set("v.approvedLineItems", approvedLineItems);
        component.set("v.rejectedLineItems", rejectedLineItems);
        component.set("v.noActionLineItems", noActionLineItems);
        if(familyMap != null){
            var bid = component.get("v.bidRecord");
            component.set("v.familyList", Object.keys(familyMap));
            var families = Object.keys(familyMap);
            var summaryList = []; var totalSummaryObj = {};
            totalSummaryObj.currentUnitsEA = 0; totalSummaryObj.currentUnitsEU = 0; totalSummaryObj.currentSales = 0; totalSummaryObj.currentTPMargin = 0; totalSummaryObj.currentTPMarginPer = 0;
            totalSummaryObj.proposedUnitsEA = 0; totalSummaryObj.proposedUnitsEU = 0; totalSummaryObj.proposedSales = 0; totalSummaryObj.proposedTPMargin = 0; totalSummaryObj.proposedTPMarginPer = 0;
            totalSummaryObj.scmUnitsEA = 0; totalSummaryObj.scmUnitsEU = 0; totalSummaryObj.scmSales = 0; totalSummaryObj.scmTPMargin = 0; totalSummaryObj.scmTPMarginPer = 0;
            for(var i=0; i<families.length; i++){
                var summaryObj = {}; 
                summaryObj.currentUnitsEA = 0; summaryObj.currentUnitsEU = 0; summaryObj.currentSales = 0; summaryObj.currentTPMargin = 0; summaryObj.currentTPMarginPer = 0;
                summaryObj.proposedUnitsEA = 0; summaryObj.proposedUnitsEU = 0; summaryObj.proposedSales = 0; summaryObj.proposedTPMargin = 0; summaryObj.proposedTPMarginPer = 0;
                summaryObj.scmUnitsEA = 0; summaryObj.scmUnitsEU = 0; summaryObj.scmSales = 0; summaryObj.scmTPMargin = 0; summaryObj.scmTPMarginPer = 0;
                var relatedList = familyMap[families[i]];
                summaryObj.family = families[i]; summaryObj.relatedList = relatedList;
                console.log('Family: '+families[i]);
                for(var j=0; j<relatedList.length; j++){
                    console.log('Template: '+relatedList[j].Phoenix_Bid_Template_Refrence__c);
                    console.log('Bid Type: '+bid.Phoenix_Bid_Type__c);
                    if(relatedList[j].Phoenix_Bid_Template_Refrence__c == 'Walgreens' || relatedList[j].Phoenix_Bid_Template_Refrence__c == 'ABC Progen' || relatedList[j].Phoenix_Bid_Template_Refrence__c == 'ABC Pharmagen'
                       || relatedList[j].Phoenix_Bid_Template_Refrence__c == 'Costco' || relatedList[j].Phoenix_Bid_Template_Refrence__c == 'Sams Club' || relatedList[j].Phoenix_Bid_Template_Refrence__c == 'Government Pricing'
                       || relatedList[j].Phoenix_Bid_Template_Refrence__c == 'Indirect' || relatedList[j].Phoenix_Bid_Template_Refrence__c == 'Humana Indirect retail' || relatedList[j].Phoenix_Bid_Template_Refrence__c == 'Humana Indirect CII'){
                        relatedList[j].units = relatedList[j].Phoenix_Proposed_Indirect_Selling_Unit__c;
                        relatedList[j].sales = relatedList[j].Phoenix_Net_Sales_Internal__c;
                        relatedList[j].tpMargin = relatedList[j].Phoenix_Th_Put_Margin__c;
                        relatedList[j].tpMarginPer = relatedList[j].Phoenix_TP_Margin__c;
                    } else if(relatedList[j].Phoenix_Bid_Template_Refrence__c == 'Direct'){
                        relatedList[j].units = relatedList[j].Phoenix_Proposed_Direct_Selling_Unit__c;
                        relatedList[j].sales = relatedList[j].Phoenix_Net_Sales_Internal__c;
                        relatedList[j].tpMargin = relatedList[j].Phoenix_Th_Put_Margin__c;
                        relatedList[j].tpMarginPer = relatedList[j].Phoenix_TP_Margin__c;
                    } else if(relatedList[j].Phoenix_Bid_Template_Refrence__c == 'Direct and Indirect'){
                        relatedList[j].units = relatedList[j].Phoenix_Proposed_Direct_Selling_Unit__c + relatedList[j].Phoenix_Proposed_Indirect_Selling_Unit__c;
                        relatedList[j].sales = relatedList[j].Phoenix_WMT_Indirect_Net_Sales__c;
                        relatedList[j].tpMargin = relatedList[j].Phoenix_Costco_TPT__c;
                        relatedList[j].tpMarginPer = relatedList[j].Phoenix_Anda_DRL_TPT_Percent__c;
                    } else if(bid.Phoenix_Bid_Type__c == 'OTC New Product' || bid.Phoenix_Bid_Type__c == 'OTC OTB Good Dated' || bid.Phoenix_Bid_Type__c == 'OTC OTB Short Dated'
                              || bid.Phoenix_Bid_Type__c == 'OTC Price Change' || bid.Phoenix_Bid_Type__c == 'OTC Product Addition' || bid.Phoenix_Bid_Type__c == 'OTC RFP'
                              || bid.Phoenix_Bid_Type__c == 'OTC Volume Review'){
                        relatedList[j].units = relatedList[j].Phoenix_Proposed_Direct_Selling_Unit__c;
                        relatedList[j].sales = relatedList[j].Phoenix_Net_Sales_Internal__c;
                        relatedList[j].tpMargin = relatedList[j].Phoenix_Th_Put_Margin__c;
                        relatedList[j].tpMarginPer = relatedList[j].Phoenix_Th_Put_Margin__c/relatedList[j].Phoenix_Net_Sales_Internal__c;
                    } else if(bid.Phoenix_Bid_Type__c == 'Good Dated OTB' || bid.Phoenix_Bid_Type__c == 'Short Dated OTB' || bid.Phoenix_Bid_Type__c == 'One Time Buy Good Dated Shelf Life for New Product Launch'){
                        relatedList[j].units = relatedList[j].Phoenix_Proposed_Direct_Selling_Unit__c + relatedList[j].Phoenix_Proposed_Indirect_Selling_Unit__c;
                        relatedList[j].sales = relatedList[j].Proposed_Net_Sales_Direct__c + relatedList[j].Proposed_Net_Sales_Indirect__c;
                        relatedList[j].tpMargin = relatedList[j].Proposed_TPT_Direct__c + relatedList[j].Proposed_TPT_Indirect__c;
                        relatedList[j].tpMarginPer = (relatedList[j].Proposed_TPT_Direct__c + relatedList[j].Proposed_TPT_Indirect__c)/(relatedList[j].Proposed_Net_Sales_Direct__c + relatedList[j].Proposed_Net_Sales_Indirect__c);
                    } else if(relatedList[j].Phoenix_Bid_Template_Refrence__c == 'Econdisc'){
                        relatedList[j].units = (relatedList[j].Phoenix_Direct_ESI__c+relatedList[j].Phoenix_Indirect_ESI__c+relatedList[j].Phoenix_Direct_Kroger__c+relatedList[j].Phoenix_Indirect_Kroger__c+relatedList[j].Phoenix_Direct_Rx_Outreach__c+relatedList[j].Phoenix_Indirect_Rx_Outreach__c+relatedList[j].Phoenix_Direct_Supervalu__c+relatedList[j].Phoenix_Indirect_Supervalu__c+relatedList[j].Phoenix_Direct_Cigna__c+relatedList[j].Phoenix_Indirect_Cigna__c+relatedList[j].Phoenix_Direct_Cordant__c+relatedList[j].Phoenix_Indirect_Cordant__c+relatedList[j].Phoenix_Direct_Accerodo__c+relatedList[j].Phoenix_Indirect_Accerodo__c);
                        relatedList[j].sales = relatedList[j].Phoenix_Net_Sales_Internal__c;
                        relatedList[j].tpMargin = relatedList[j].Phoenix_Th_Put_Margin__c;
                        relatedList[j].tpMarginPer = relatedList[j].Phoenix_TP_Margin__c;
                    } else if(relatedList[j].Phoenix_Bid_Template_Refrence__c == 'RXSS'){
                        relatedList[j].units = (relatedList[j].Phoenix_Proposed_Smith_Drug_Units__c+relatedList[j].Phoenix_Proposed_Anda_Units__c+relatedList[j].Phoenix_ProposedDirectAholdDelhaizeUnits__c+relatedList[j].Phoenix_ProposedDirectGaintEagleUnits__c+relatedList[j].Phoenix_ProposedIndirectAholdDelhaizeUni__c);
                        relatedList[j].sales = relatedList[j].Phoenix_Net_Sales_Internal__c;
                        relatedList[j].tpMargin = relatedList[j].Phoenix_Th_Put_Margin__c;
                        relatedList[j].tpMarginPer = relatedList[j].Phoenix_TP_Margin__c;
                    } else if(relatedList[j].Phoenix_Bid_Template_Refrence__c == 'ClarusOne'){
                        relatedList[j].units = (relatedList[j].Phoenix_Proposed_OS_Units__c+relatedList[j].Phoenix_Proposed_RAD_Units__c+relatedList[j].Phoenix_Proposed_WMT_Units__c);
                        relatedList[j].sales = relatedList[j].Phoenix_ProposedDirectGaintEagleUnits__c;
                        relatedList[j].tpMargin = relatedList[j].Phoenix_ProposedDirectAholdDelhaizeUnits__c;
                        relatedList[j].tpMarginPer = relatedList[j].Phoenix_Retail_Indirect_DRL_TPT_Percent__c;
                    } else if(relatedList[j].Phoenix_Bid_Template_Refrence__c == 'Net Indirect Pricing'){
                        relatedList[j].units = relatedList[j].Phoenix_Proposed_Direct_Selling_Unit__c + relatedList[j].Phoenix_Proposed_Indirect_Selling_Unit__c;
                        relatedList[j].sales = relatedList[j].Phoenix_Net_Sales_Internal__c;
                        relatedList[j].tpMargin = relatedList[j].Phoenix_Th_Put_Margin__c;
                        relatedList[j].tpMarginPer = relatedList[j].Phoenix_TP_Margin__c;
                    } else if(relatedList[j].Phoenix_Bid_Template_Refrence__c == 'BASE/DSH'){
                        relatedList[j].units = (relatedList[j].Phoenix_Proposed_Smith_Drug_Units__c + relatedList[j].Phoenix_Proposed_Anda_Units__c + relatedList[j].Phoenix_ProposedDirectAholdDelhaizeUnits__c);
                        relatedList[j].sales = (relatedList[j].Phoenix_Retail_IOD_overall_amount__c + relatedList[j].Phoenix_Retail_Direct_Net_sales__c + relatedList[j].Phoenix_Wholesaler_Net_Sales__c);
                        relatedList[j].tpMargin = (relatedList[j].Phoenix_Wholesaler_IOD_overall_amount__c + relatedList[j].Phoenix_Anda_Net_Model_Sales__c + relatedList[j].Phoenix_Wholesaler_Guidance_Price__c);
                        relatedList[j].tpMarginPer = relatedList[j].tpMargin/relatedList[j].sales;   
                    } else if(relatedList[j].Phoenix_Bid_Template_Refrence__c == 'ROS'){
                        relatedList[j].units = (relatedList[j].BidLineItemsExtn__r[0].Phoenix_Proposed_CVS_DirSellingUnits__c + relatedList[j].BidLineItemsExtn__r[0].Phoenix_Proposed_CVS_IndirSellingUnits__c + relatedList[j].BidLineItemsExtn__r[0].Phoenix_Proposed_Cardinal_Units__c + relatedList[j].BidLineItemsExtn__r[0].Phoenix_Proposed_Major_Units__c);
                        relatedList[j].sales = relatedList[j].Phoenix_Net_Sales_Internal__c;
                        relatedList[j].tpMargin = relatedList[j].BidLineItemsExtn__r[0].Phoenix_Total_RedOak_TPT__c ;
                        relatedList[j].tpMarginPer = relatedList[j].BidLineItemsExtn__r[0].Phoenix_Total_RedOak_TPT_Per__c;
                    }
                    if(bid.Phoenix_Bid_Type__c == 'Price Change' || bid.Phoenix_Bid_Type__c == 'Customer Rebate Change'
                       || bid.Phoenix_Bid_Type__c == 'OTC Price Change' || bid.Phoenix_Bid_Type__c == 'OTC Rebate Change'
                       || bid.Phoenix_Bid_Type__c == 'Sales Out Rebate'|| bid.Phoenix_Bid_Type__c == 'OTC OTB Short Dated'|| bid.Phoenix_Bid_Type__c == 'OTC OTB Good Dated'
                      || bid.Phoenix_Bid_Type__c == 'One Time Buy Good Dated Shelf Life for New Product Launch'|| bid.Phoenix_Bid_Type__c == 'New Product Launch'){
                        relatedList[j].units = relatedList[j].Phoenix_Final_Total_Selling_Unit__c;
                    }
                    
                    
                    relatedList[j].proposedASP = isNaN(relatedList[j].Phoenix_Proposed_Sales__c/relatedList[j].Phoenix_Final_Total_Selling_Unit__c) ? 0: relatedList[j].Phoenix_Proposed_Sales__c/relatedList[j].Phoenix_Final_Total_Selling_Unit__c; // Proposed ASP for Proposed Section
                    relatedList[j].proposedSales = relatedList[j].units * relatedList[j].proposedASP;
                    relatedList[j].proposedTpMargin = relatedList[j].proposedSales - (relatedList[j].Phoenix_Throughput_cost__c * relatedList[j].units);
                    relatedList[j].proposedTpMarginPer = (relatedList[j].proposedTpMargin/relatedList[j].proposedSales)*100;
                    
                    
                    summaryObj.currentUnitsEA += parseFloat(relatedList[j].Phoenix_Total_Selling_Unit__c);
                    summaryObj.currentUnitsEU += parseFloat(relatedList[j].Phoenix_Total_Selling_Unit__c * relatedList[j].Phoenix_Pkg_Size1__c);
                    summaryObj.currentSales += parseFloat(relatedList[j].Finance_Current_Sales__c);
                    summaryObj.currentTPMargin += parseFloat(relatedList[j].Phoenix_Current_TP_Margin__c);
                    summaryObj.proposedUnitsEA += parseFloat(relatedList[j].units);
                    summaryObj.proposedUnitsEU += parseFloat(relatedList[j].units * relatedList[j].Phoenix_Pkg_Size1__c);
                    summaryObj.proposedSales += parseFloat(relatedList[j].proposedSales);
                    summaryObj.proposedTPMargin += parseFloat(relatedList[j].proposedTpMargin);
                    
                    
                    if(relatedList[j].Phoenix_SCM_Approval_Y_N__c != 'N- Not Approved' && relatedList[j].Phoenix_SCM_Final_Approval__c && relatedList[j].Phoenix_SCM_Approval_Y_N__c != null){
                        relatedList[j].scmUnitsEA = parseFloat(relatedList[j].Phoenix_Total_SCM_Approved_Qty__c);
                        relatedList[j].scmUnitsEU = parseFloat(relatedList[j].Phoenix_Total_SCM_Approved_Qty__c * relatedList[j].Phoenix_Pkg_Size1__c);
                        //relatedList[j].scmProposedASP = isNaN(relatedList[j].sales/relatedList[j].scmUnitsEA)?0: (relatedList[j].sales/relatedList[j].scmUnitsEA);
                        relatedList[j].scmSales = parseFloat(relatedList[j].Phoenix_Proposed_Sales__c); //parseFloat(relatedList[j].proposedASP * relatedList[j].scmUnitsEA);//parseFloat(relatedList[j].scmUnitsEA*relatedList[j].Phoenix_Proposed_ASP_Dose__c);
                        relatedList[j].scmTPMargin = parseFloat(relatedList[j].Phoenix_Proposed_TP_Margin__c); //relatedList[j].scmSales - (relatedList[j].Phoenix_Throughput_cost__c * relatedList[j].units);
                        summaryObj.scmUnitsEA += parseFloat(relatedList[j].Phoenix_Total_SCM_Approved_Qty__c);
                        summaryObj.scmUnitsEU += parseFloat(relatedList[j].Phoenix_Total_SCM_Approved_Qty__c * relatedList[j].Phoenix_Pkg_Size1__c);
                        summaryObj.scmSales += relatedList[j].scmSales; //parseFloat(relatedList[j].scmUnitsEA*relatedList[j].Phoenix_Proposed_ASP_Dose__c); //parseFloat(relatedList[j].Phoenix_Total_SCM_Approved_Qty__c*relatedList[j].Phoenix_Proposed_ASP_Dose__c);
                        summaryObj.scmTPMargin += parseFloat(relatedList[j].scmTPMargin);   
                    }    
                }
                totalSummaryObj.currentUnitsEA += parseFloat(summaryObj.currentUnitsEA);
                totalSummaryObj.currentUnitsEU += parseFloat(summaryObj.currentUnitsEU);
                totalSummaryObj.currentSales += parseFloat(summaryObj.currentSales);
                totalSummaryObj.currentTPMargin += parseFloat(summaryObj.currentTPMargin);
                totalSummaryObj.proposedUnitsEA += parseFloat(summaryObj.proposedUnitsEA);
                totalSummaryObj.proposedUnitsEU += parseFloat(summaryObj.proposedUnitsEU);
                totalSummaryObj.proposedSales += parseFloat(summaryObj.proposedSales);
                totalSummaryObj.proposedTPMargin += parseFloat(summaryObj.proposedTPMargin);
                totalSummaryObj.scmUnitsEA += parseFloat(summaryObj.scmUnitsEA);
                totalSummaryObj.scmUnitsEU += parseFloat(summaryObj.scmUnitsEU);
                totalSummaryObj.scmSales += parseFloat(summaryObj.scmSales);
                totalSummaryObj.scmTPMargin += parseFloat(summaryObj.scmTPMargin);
                summaryList.push(summaryObj);
            }
            component.set("v.summaryList", summaryList);
            component.set("v.totalSummaryObj", totalSummaryObj);
        }
    }
})