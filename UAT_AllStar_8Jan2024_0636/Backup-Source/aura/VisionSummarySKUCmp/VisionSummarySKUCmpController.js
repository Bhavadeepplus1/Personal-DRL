({
    doInit: function(component, event, helper){
        var userId = $A.get("$SObjectType.CurrentUser.Id");
        var action = component.get("c.getName");
        action.setParams({
            'userId': userId
        });
        action.setCallback(this, function(response){
            if(response.getState() == 'SUCCESS') {
                var userName = response.getReturnValue();
                component.get("v.userName", userName);
                var BidLineItemListAll = component.get("v.BidLineItemListAll");
                var familyMap = {}; var summaryMap = {};
                var approvedLineItems = 0; var rejectedLineItems = 0; var noActionLineItems = 0;
                var userRelatedLineItems = []; var filteredBidLineItems = [];
                component.set("v.productDirector", userName);
                if(BidLineItemListAll != null){
                    for(var i=0; i<BidLineItemListAll.length; i++){
                        if(BidLineItemListAll[i].Phoenix_Product_Director__c == userName){
                            userRelatedLineItems.push(BidLineItemListAll[i].Id);
                            filteredBidLineItems.push(BidLineItemListAll[i]);
                            /*if(familyMap.hasOwnProperty(BidLineItemListAll[i].Phoenix_Product_Family__c)){
                                var relatedList = familyMap[BidLineItemListAll[i].Phoenix_Product_Family__c];
                                relatedList.push(BidLineItemListAll[i]);
                                familyMap[BidLineItemListAll[i].Phoenix_Product_Family__c] = relatedList;
                            } else{
                                var relatedList = [];
                                relatedList.push(BidLineItemListAll[i]);
                                familyMap[BidLineItemListAll[i].Phoenix_Product_Family__c] = relatedList;
                            }
                            if(BidLineItemListAll[i].Phoenix_Marketing_Approval__c == 'Approved'){
                                approvedLineItems += 1;
                            } else if(BidLineItemListAll[i].Phoenix_Marketing_Approval__c == 'Not Approved'){
                                rejectedLineItems += 1;
                            } else{
                                noActionLineItems += 1;
                            }*/
                        }
                        /*component.set("v.approvedLineItems", approvedLineItems);
                        component.set("v.rejectedLineItems", rejectedLineItems);
                        component.set("v.noActionLineItems", noActionLineItems);
                        component.set("v.familyList", Object.keys(familyMap));
                        var families = Object.keys(familyMap);
                        var summaryList = []; var totalSummaryObj = {}; totalSummaryObj.currentBottles = 0; totalSummaryObj.currentSales = 0; totalSummaryObj.proposedSales = 0;
                        for(var i=0; i<families.length; i++){
                            var summaryObj = {}; summaryObj.currentBottles = 0; summaryObj.currentSales = 0; summaryObj.proposedSales = 0;
                            summaryObj.overallMark = 0; summaryObj.custVol = 0;
                            var relatedList = familyMap[families[i]];
                            summaryObj.family = families[i]; summaryObj.relatedList = relatedList;
                            for(var j=0; j<relatedList.length; j++){
                                //var marketShareData = helper.getMarketShareData(component, event, helper, relatedList[j]);  
                                summaryObj.currentBottles += relatedList[j].Phoenix_Total_Selling_Unit__c;
                                summaryObj.currentSales += relatedList[j].Finance_Current_Sales__c;
                                summaryObj.proposedSales += relatedList[j].Phoenix_Proposed_Sales__c;
                                //console.log('marketShareData: '+JSON.stringify(marketShareData));
                            }
                            totalSummaryObj.currentBottles += summaryObj.currentBottles;
                            totalSummaryObj.currentSales += summaryObj.currentSales;
                            totalSummaryObj.proposedSales += summaryObj.proposedSales;
                            summaryList.push(summaryObj);
                        }
                        component.set("v.summaryList", summaryList);
                        component.set("v.totalSummaryObj", totalSummaryObj);*/
                    }
                    component.set("v.userRelatedLineItems", userRelatedLineItems);
                    component.set("v.filteredBidLineItems", filteredBidLineItems);
                    helper.buildData(component, event, helper);
                }
            } else{
                console.log("Exception: "+JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);
    },
    showSummaryPopup: function(component, event, helper){
        component.set("v.showSummaryPopup", !component.get("v.showSummaryPopup"));
    },
})