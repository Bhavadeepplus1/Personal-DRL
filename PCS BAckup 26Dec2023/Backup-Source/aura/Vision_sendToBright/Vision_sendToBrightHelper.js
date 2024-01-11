({
    getNprForOptyProds : function(component, event, helper, offsetVal){
        var optyProdList = component.get("v.optyProdList");
        var contractList = component.get("v.conList");
        if(offsetVal < optyProdList.length && contractList.length > 0){
            component.set("v.loadingMessage",'Fetching NPR data... '+(offsetVal>optyProdList.length?optyProdList.length:offsetVal)+ ' Out of '+optyProdList.length+'...');
            var shortOptyList = optyProdList.slice(offsetVal, offsetVal+20);
            var action = component.get("c.fetchNprtData");
            /*optyProdList.forEach(function(optyProd){
                if(optyProd.optyProdObj){
                    if(optyProd.optyProdObj.Product__r.Phoenix_Rx_SRx_OTC__c == 'OTC' && 
                       optyProd.optyProdObj.Product__r.Phoenix_Is_Private_Label_OTC__c && !component.get("v.isOtcProdFam"))
                        component.set("v.isOtcProdFam",true);
                }
            });*/
            action.setParams({
                optyProdList : shortOptyList,
                contractList : contractList,
                templateType : component.get('v.isOtcProdFam') ? 'otcCx' : component.get('v.templateType')
            });
            action.setCallback(this, function(response){
                if(response.getState() == 'SUCCESS'){
                    //var respList = response.getReturnValue();
                    console.log('resp from npr ---> '+response.getReturnValue());
                    //var listItems = component.get("v.dataListWithNpr")
                    //listItems.push(respList);
                    //component.set("v.dataListWithNpr",respList);
                    helper.getNprForOptyProds(component, event, helper, offsetVal+20);
                } else{
                    console.log("Error "+JSON.stringify(response.getError()));
                }
            });
            $A.enqueueAction(action);
        }
        else{
            component.set("v.loadingMessage",'Getting updated NPR data...');
            helper.getProdInfo(component, event, helper);
        }
    },
    getProdInfo : function(component, event, helper){
        var action = component.get("c.getOptyProd");
        action.setParams({
            opportunityId: component.get('v.recordId')
        });
        action.setCallback(this, function(response){
            if(response.getState() == 'SUCCESS'){
                var optyProdList = response.getReturnValue();
                if(optyProdList.length > 0){
                    if(optyProdList[0].isError){
                        component.set("v.isError",true);
                        component.set("v.errormsg",''+optyProdList[0].errorMessage);
                        component.set("v.showProductsloading",false);
                    }
                    else{
                        console.log('inside else of getOpty');
                        component.set("v.optyObj",optyProdList[0].oppObj);
                        component.set('v.optyVal',optyProdList[0].oppObj.Vision_Opportunity_Value__c);
                        component.set('v.optyBidType',optyProdList[0].oppObj.Bid_Type__c);
                        component.set('v.templateType',optyProdList[0].oppObj.Vision_Bid_Template__c);
                        component.set("v.isPanMove",optyProdList[0].isPanMove);
                        component.set("v.showAddToBidButton",optyProdList[0].showAddToBidButton != undefined ? optyProdList[0].showAddToBidButton : false);
                        var noOfProdSentToBright = 0;
                        var awardedList = [];
                        var nonAwardedList = [];
                        console.log('before forEach');
                        var optyProdLength = 0;
                        if(optyProdList[0].oppObj.Account.Name.includes('Private Label'))
                            component.set("v.isOtcProdFam",true);
                        optyProdList.forEach(function(optyProd){
                            if(optyProd.optyProdObj){
                                optyProdLength++;
                                /*if(optyProd.optyProdObj.Product__r.Phoenix_Rx_SRx_OTC__c == 'OTC' && 
                                   optyProd.optyProdObj.Product__r.Phoenix_Is_Private_Label_OTC__c && !component.get("v.isOtcProdFam"))
                                    component.set("v.isOtcProdFam",true);*/
                                if(optyProd.hasBidLineItem)
                                    noOfProdSentToBright++;
                                else
                                    component.set("v.showSendButton",true);
                                if(optyProd.isAwarded)
                                    awardedList.push(optyProd);
                                else
                                    nonAwardedList.push(optyProd);
                            }
                        });
                        component.set("v.awardedListdata",awardedList);
                        component.set("v.nonAwardedListdata",nonAwardedList);
                        component.set("v.optyProdsCount",optyProdLength);
                        component.set("v.noOfProdSentToBright",noOfProdSentToBright);
                        component.set("v.wrapperList",optyProdList);
                        //optyProdLength = 0;
                        if(optyProdList.length == 0){
                            component.set("v.doesOptyProdsExists",false);
                            component.set("v.showProductsloading",false);
                            component.set("v.loadingMessage",'');
                        }
                        else if(optyProdList.length < 50){
                            component.set('v.pagedListdata',optyProdList);
                            component.set("v.showProductsloading",false);
                            component.set("v.loadingMessage",'');
                        }
                            else{
                                var noOfPages = optyProdList.length/50;
                                console.log('noOfPages -->'+noOfPages);
                                var pageNumbers = [];
                                var j=1;
                                for(var i=0;i<noOfPages;i++){
                                    pageNumbers.push(j);
                                    j++;
                                }
                                component.set("v.pageNumberList",pageNumbers);
                                helper.pageController(component, event, helper);
                            }
                        //component.set("v.showProductsloading",false);
                        //if(awardedList.length > 0){
                        //    component.set("v.showSectionName",'Awarded Products');
                        //    component.set("v.isShowingTabName",'award');
                        //}
                        //else if(nonAwardedList.length > 0){
                        //    component.set("v.showSectionName",'Non-Awarded Products');
                        //    component.set("v.isShowingTabName",'nonAward');
                        // }
                        //if(awardedList.length < 50)
                        //   component.set('v.awardedPagedListdata',awardedList);
                        /*else{
                            var pageNumberListAwarded = [];
                            var noOfPages = awardedList.length/50;
                            for(var i=0;i<noOfPages;i++){
                                pageNumberListAwarded.push(i+1);
                            }
                            component.set("v.pageNumberListAwarded",pageNumberListAwarded);
                            helper.paginateAwarded(component, event, helper);
                        }*/
                        }
                    }
                    else{
                        component.set("v.isError",true);
                        component.set("v.errormsg",'Products are not added to this Opportunity.');
                        component.set("v.showProductsloading",false);
                    }
                } else{
                    console.log("Error "+JSON.stringify(response.getError()));
                    component.set("v.showProductsloading",false);
                }
            });
        $A.enqueueAction(action);
    },
	pageController : function(component, event, helper) {
        var selectedPageNumber = component.get("v.selectedPageNumber");
        var wrapperList = component.get("v.wrapperList");
        var selectedList = wrapperList.slice((selectedPageNumber-1)*50,selectedPageNumber*50);
        component.set('v.pagedListdata',selectedList);
        component.set("v.loadingMessage",'');
        component.set("v.showProductsloading",false);
    },
    
    paginateAwarded : function(component, event, helper) {
        var selectedPageNumber = component.get("v.selectedAwardedPageNumber");
        var awardedListdata = component.get("v.awardedListdata");
        console.log('awardedListdata.length ---> '+awardedListdata.length);
        var selectedList = awardedListdata.slice((selectedPageNumber-1)*50,selectedPageNumber*50);
        component.set('v.awardedPagedListdata',selectedList);
    },
    
    paginateNonAwarded : function(component, event, helper) {
        var selectedPageNumber = component.get("v.selectedNonAwardedPageNumber");
        var nonAwardedListdata = component.get("v.nonAwardedListdata");
        console.log('nonAwardedListdata.length ---> '+nonAwardedListdata.length);
        var selectedList = nonAwardedListdata.slice((selectedPageNumber-1)*50,selectedPageNumber*50);
        component.set('v.nonAwardedPagedListdata',selectedList);
    },
    
    createNewBid : function(component, event, helper){
        component.set("v.loadingMessage",'Creating a new bid in Bright....');
        
        component.set('v.showProductsloading', true);
        var action = component.get("c.sendToBrightFunc");
        action.setParams({
            opportunityId: component.get('v.recordId'),
            wraplist : JSON.stringify(component.get("v.wrapperList")),
            bidType : component.get("v.selectedBidType"),
            isOtcProdFam : component.get("v.isOtcProdFam")
        });
        action.setCallback(this, function(response){
            if(response.getState() == 'SUCCESS'){
                var resp = response.getReturnValue();
                //console.log('resp --->'+JSON.stringify(resp));
                //console.log('resp.Phoenix_Customer_Type__c --->'+resp.Phoenix_Customer_Type__c);
                var selectedProdList = [];
                component.get("v.wrapperList").forEach(function(wrapObj){
                    if(wrapObj.isSelected)
                        selectedProdList.push(wrapObj.optyProdObj);
                });
                component.set("v.selectedProdList",selectedProdList);
                helper.insertBidLineItems(component, event, helper, resp, 0);
            } else{
                console.log("Error "+JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);
    },
    
    insertBidLineItems : function(component, event, helper, bidRec, offsetVal){
        var sendingList = component.get("v.selectedProdList").slice(offsetVal, offsetVal+50);
        var selectedProdListSize = component.get("v.noOfSelectedProd");
        component.set("v.loadingMessage",'Adding Selected Products to the Bid. '+(offsetVal>selectedProdListSize?selectedProdListSize:offsetVal)+ ' Out of '+selectedProdListSize+'.....');
        console.log('Adding Selected Products to Bid. '+offsetVal+ ' Out of '+selectedProdListSize);
        var action = component.get("c.addBidLinesToBid");
        action.setParams({
            bidRec : bidRec,
            optyProdList : sendingList,
            bidType : component.get("v.selectedBidType")
        });
        action.setCallback(this, function(response){
            if(response.getState() == 'SUCCESS'){
                var respMessage = response.getReturnValue();
                if(!respMessage.includes('ERROR')){
                    if(offsetVal > selectedProdListSize){
                        var urlEvent = $A.get("e.force:navigateToURL");
                        if(bidRec.Phoenix_Customer_Type__c == 'OTC Customer'){
                            urlEvent.setParams({
                                "url": "/lightning/n/OTC_Template?c__id="+bidRec.Id
                            }); 
                        }
                        else{
                            if(bidRec.Phoenix_Customer_Type__c=='Walgreens'||bidRec.Phoenix_Customer_Type__c=='ABC Progen'){
                                urlEvent.setParams({
                                    "url": "/lightning/n/Walgreens_View?c__id="+bidRec.Id
                                }); 
                            }  
                            else if(bidRec.Phoenix_Customer_Type__c=='Econdisc'){
                                urlEvent.setParams({
                                    "url": "/lightning/n/Econdisc?c__id="+bidRec.Id
                                });
                            }
                                else if(bidRec.Phoenix_Customer_Type__c=='Sams Club'){
                                    urlEvent.setParams({
                                        "url": "/lightning/n/SamsClub?c__id="+bidRec.Id
                                    });
                                }
                                    else if(bidRec.Phoenix_Customer_Type__c=='Government Pricing'){
                                        urlEvent.setParams({
                                            "url": "/lightning/n/GovernmentPricing?c__id="+bidRec.Id
                                        });
                                    }
                                        else if(bidRec.Phoenix_Customer_Type__c=='Net Indirect Pricing'){
                                            urlEvent.setParams({
                                                "url": "/lightning/n/NetIndirectView?c__id="+bidRec.Id
                                            });
                                        }
                                            else if(bidRec.Phoenix_Customer_Type__c=='RXSS'){
                                                urlEvent.setParams({
                                                    "url": "/lightning/n/RXSS?c__id="+bidRec.Id
                                                });
                                            }
                                                else if(bidRec.Phoenix_Customer_Type__c=='BASE/DSH'){
                                                    urlEvent.setParams({
                                                        "url": "/lightning/n/DSH?c__id="+bidRec.Id
                                                    });
                                                }
                                                    else if(bidRec.Phoenix_Customer_Type__c=='Costco'){
                                                        urlEvent.setParams({
                                                            "url": "/lightning/n/Costco?c__id="+bidRec.Id
                                                        });
                                                    }
                                                        else if(bidRec.Phoenix_Customer_Type__c=='ABC Pharmagen'){
                                                            urlEvent.setParams({
                                                                "url": "/lightning/n/ABCPharmagen?c__id="+bidRec.Id
                                                            });
                                                        }
                                                            else if(bidRec.Phoenix_Customer_Type__c=='ClarusOne'){
                                                                urlEvent.setParams({
                                                                    "url": "/lightning/n/ClarusOne?c__id="+bidRec.Id
                                                                });
                                                            }
                                                                else if(bidRec.Phoenix_Customer_Type__c=='ROS'){
                                                                    urlEvent.setParams({
                                                                        "url": "/lightning/n/ROS?c__id="+bidRec.Id+"&c__fetchNprData=true"
                                                                    });
                                                                }
                                                                    else
                                                                    {
                                                                        console.log('test type--'+bidRec.Phoenix_Bid_Type__c);
                                                                        //added by srimayee
                                                                         if(bidRec.Phoenix_Bid_Type__c=='Platform OTB'){
                                                                                urlEvent.setParams({
                                                                                    "url": "/lightning/n/Platform_OTB?c__id="+bidRec.Id
                                                                                }); 
                                                                            }
                                                                       else if(bidRec.Phoenix_Bid_Type__c=='IPA Floor Pricing Update'){
                                                                            urlEvent.setParams({
                                                                                "url": "/lightning/n/Bid_Floor_Price_Change?c__id="+bidRec.Id
                                                                            }); 
                                                                        }
                                                                        else if(bidRec.Phoenix_Bid_Type__c=='Direct Order Form Pricing Update'){
                                                                            urlEvent.setParams({
                                                                                "url": "/lightning/n/Direct_Order_Price_Update?c__id="+bidRec.Id
                                                                            }); 
                                                                        }
                                                                            else if(bidRec.Phoenix_Bid_Type__c=='Short Dated OTB' || bidRec.Phoenix_Bid_Type__c=='Good Dated OTB' || bidRec.Phoenix_Bid_Type__c=='OTB' ){
                                                                                urlEvent.setParams({
                                                                                    "url": "/lightning/n/OneTimeBuy?c__id="+bidRec.Id
                                                                                }); 
                                                                            }
                                                                       
                                                                              else{
                                                                                    urlEvent.setParams({
                                                                                        "url": "/lightning/n/Edit_Bid_Line_Items?c__id="+bidRec.Id
                                                                                    }); 
                                                                                }
                                                                    }
                        }
                        
                        urlEvent.fire();
                        component.set("v.showOpenBids",false);
                        component.set('v.showProductsloading', false);
                    }
                    else{
                        helper.insertBidLineItems(component, event, helper, bidRec, offsetVal+50);
                    }
                } 
                else{
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type": "Error",
                        "title": "Error!",
                        "message": respMessage
                    });
                    toastEvent.fire();
                    component.set('v.showProductsloading', false);
                }
            } else{
                console.log("Error "+JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);
    },
    
    addToBid : function(component, event, helper){
        component.set('v.showProductsloading', true);
        var selectedBidId = component.get("v.selectedBidId");
        component.set("v.loadingMessage",'Getting Bid data from Bright...');
        
        var action = component.get("c.sendToBrightExistingBid");
        action.setParams({
            opportunityId: component.get('v.recordId'),
            wraplist : JSON.stringify(component.get("v.wrapperList")),
            selectedBidId : selectedBidId
        });
        action.setCallback(this, function(response){
            if(response.getState() == 'SUCCESS'){
                console.log('Success: '+response.getReturnValue());
                var resp = response.getReturnValue();
                var selectedProdList = [];
                component.get("v.wrapperList").forEach(function(wrapObj){
                    if(wrapObj.isSelected)
                        selectedProdList.push(wrapObj.optyProdObj);
                });
                component.set("v.selectedProdList",selectedProdList);
                helper.insertBidLineItems(component, event, helper, resp, 0);
                /*} else{
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type": "Error",
                        "title": "Error!",
                        "message": "Selected Customer is not a Bid Account."
                    });
                    toastEvent.fire();
                }
                component.set('v.showProductsloading', false);*/
            } else{
                console.log("Error "+JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);
    },
    getOpenBidList : function(component, event, helper, bidType){
        component.set("v.sendToBrightType",'toBid');
        component.set('v.showProductsloading', true);
        component.set("v.showBidTypeSelection",false);
        component.set("v.showOpenBids",true);
        var action = component.get("c.getOpenBids");
        console.log('component.get(v.optyObj).AccountId --> ' + component.get("v.optyObj").AccountId);
        action.setParams({
            customerId : component.get("v.optyObj").AccountId,
            bidType : bidType
        });
        action.setCallback(this, function(response){
            if(response.getState() == 'SUCCESS'){
                var bidList = response.getReturnValue();
                console.log('bidList.length ---> '+bidList.length);
                var bidWrapList = [];
                bidList.forEach(function(bidObj){
                    var bidWrapObj = {};
                    bidWrapObj.isSelected = false;
                    bidWrapObj.bidRec = bidObj;
                    bidWrapList.push(bidWrapObj);
                });
                console.log('bidWrapList.length ---> '+bidWrapList.length);
                component.set("v.openBidList",bidWrapList);
                component.set('v.showProductsloading', false);
            }
            else{
                console.log("Error "+JSON.stringify(response.getError()));
                component.set('v.showProductsloading', false);
            }
        });
        $A.enqueueAction(action);
    },
    
    getContractList : function(component, event, helper){
        component.set("v.showProductsloading", true);
        component.set("v.showModal", true);
        component.set('v.mycolumns', [
            {label: 'Name', fieldName: 'Phoenix_Contract_Number__c', type: 'text'},
            {label: 'Customer', fieldName: 'Phoenix_Customer__c', type: 'text'},
            {label: 'Internal Description', fieldName: 'Phoenix_Contract_Internal_Description__c', type: 'text'},
            {label: 'External Description', fieldName: 'Phoenix_Contract_External_Description__c', type: 'Text'}
        ]); 
        
        var bidCustomer=component.get("v.optyObj").Account.Id;
        console.log("bidCustomer in getContractList---> "+bidCustomer);
        var action = component.get("c.getContracts");
        action.setParams({customerID: bidCustomer}); 
        action.setCallback(this, function(response){
            if (response.getState() === "SUCCESS") {
                var responseList = response.getReturnValue();
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
                component.set("v.showProductsloading", false);
                component.set("v.showConfirmation", false);
                component.set("v.contratcsList",finalContratcs);
            }
            else{
                console.log('ERROR ---> '+JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);
    },
    
    validatePropUnits : function(component, event, helper){
        var respObj = {};
        respObj.isError = false;
        respObj.errorMessage = '';
        var selectedProdList = [];
        var templateType = component.get("v.isOtcProdFam") ? 'otcProds' : component.get("v.templateType");
        component.get("v.wrapperList").forEach(function(wrapObj){
            if(wrapObj.isSelected)
                selectedProdList.push(wrapObj.optyProdObj);
        });
        selectedProdList.forEach(function(item){
            if(templateType == 'otcProds'){
                if($A.util.isUndefinedOrNull(item.Vision_Proposed_Units__c) || item.Vision_Proposed_Units__c == 0){
                    respObj.isError = true;
                    respObj.errorMessage = 'Please Enter Proposed Units for '+item.Product__r.Name;
                }
                if(($A.util.isUndefinedOrNull(item.Vision_Proposed_Share_Percentage__c) || item.Vision_Proposed_Share_Percentage__c == 0) && !respObj.isError){
                    respObj.isError = true;
                    respObj.errorMessage = 'Please Enter Proposed Share Percentage for '+item.Product__r.Name;
                }
            }
            else if(templateType == 'Indirect' || templateType == 'Direct and Indirect' ||
               templateType == 'Net Indirect Pricing' || templateType == 'Walgreens' || templateType == 'ABC progen' || 
               templateType == 'Costco' || templateType == 'Sams Club' || templateType == 'Government Pricing'){
                if($A.util.isUndefinedOrNull(item.Proposed_Indirect_Selling_Units__c) || item.Proposed_Indirect_Selling_Units__c == 0){
                    respObj.isError = true;
                    respObj.errorMessage = 'Please Enter Indirect Selling Units for '+item.Product__r.Name;
                }
            }
            else if(templateType == 'Direct' || templateType == 'Direct and Indirect' ||
                    templateType == 'Net Indirect Pricing'){
                if($A.util.isUndefinedOrNull(item.Proposed_Direct_Selling_Units__c) || item.Proposed_Direct_Selling_Units__c == 0){
                    respObj.isError = true;
                    respObj.errorMessage = 'Please Enter Direct Selling Units for '+item.Product__r.Name;
                }
            }
                else if(templateType == 'RXSS'){
                    if($A.util.isUndefinedOrNull(item.Vision_Proposed_Smith_Drug_Units__c)){
                        respObj.isError = true;
                        respObj.errorMessage = 'Please Enter Proposed Smith Drug Units for '+item.Product__r.Name;
                    }
                    if($A.util.isUndefinedOrNull(item.Vision_Proposed_Anda_Units__c)){
                        respObj.isError = true;
                        respObj.errorMessage = 'Please Enter Proposed Anda Units for '+item.Product__r.Name;
                    }
                    if($A.util.isUndefinedOrNull(item.Vision_Proposed_DirectAholdDelhaizeUnits__c)){
                        respObj.isError = true;
                        respObj.errorMessage = 'Please Enter Proposed Ahold Delhaize Units for '+item.Product__r.Name;
                    }
                    if($A.util.isUndefinedOrNull(item.Vision_Proposed_Direct_Gaint_Eagle_Units__c)){
                        respObj.isError = true;
                        respObj.errorMessage = 'Please Enter Proposed Direct Gaint Eagle Units for '+item.Product__r.Name;
                    }
                    if($A.util.isUndefinedOrNull(item.Vision_Proposed_TotalRetailIndirectUnits__c)){
                        respObj.isError = true;
                        respObj.errorMessage = 'Please Enter Proposed Retail Indirect Units for '+item.Product__r.Name;
                    }
                    if($A.util.isUndefinedOrNull(item.Proposed_Direct_Selling_Units__c)){
                        respObj.isError = true;
                        respObj.errorMessage = 'Please Enter Proposed Direct Units for '+item.Product__r.Name;
                    }
                    if($A.util.isUndefinedOrNull(item.Proposed_Indirect_Selling_Units__c)){
                        respObj.isError = true;
                        respObj.errorMessage = 'Please Enter Proposed Indirect Units for '+item.Product__r.Name;
                    }
                    if(item.Vision_Proposed_TotalRetailIndirectUnits__c == 0 && item.Vision_Proposed_Direct_Gaint_Eagle_Units__c == 0 && item.Vision_Proposed_DirectAholdDelhaizeUnits__c == 0 && 
                       item.Vision_Proposed_Smith_Drug_Units__c == 0 && item.Vision_Proposed_Anda_Units__c == 0
                       && item.Proposed_Direct_Selling_Units__c == 0 && item.Proposed_Indirect_Selling_Units__c ==0){
                        respObj.isError = true;
                        respObj.errorMessage = 'Please Enter at least one proposed units for '+item.Product__r.Name;
                    }
                }
                    else if(templateType == 'BASE/DSH'){
                        if($A.util.isUndefinedOrNull(item.Vision_Proposed_BASE_Units__c)){
                            respObj.isError = true;
                            respObj.errorMessage = 'Please Enter Proposed Base Units for '+item.Product__r.Name;
                        }
                        if($A.util.isUndefinedOrNull(item.Vision_Proposed_DSH_Units__c)){
                            respObj.isError = true;
                            respObj.errorMessage = 'Please Enter Proposed DSH Units for '+item.Product__r.Name;
                        }
                        if($A.util.isUndefinedOrNull(item.Vision_Proposed_AutoSub_Units__c)){
                            respObj.isError = true;
                            respObj.errorMessage = 'Please Enter Proposed Autosub Units for '+item.Product__r.Name;
                        }
                        if(item.Vision_Proposed_AutoSub_Units__c == 0 && item.Vision_Proposed_DSH_Units__c == 0 && item.Vision_Proposed_BASE_Units__c == 0){
                            respObj.isError = true;
                            respObj.errorMessage = 'Please Enter at least one Proposed units for '+item.Product__r.Name;
                        }
                    }
                        else if(templateType == 'ClarusOne'){
                            if($A.util.isUndefinedOrNull(item.Vision_Proposed_OS_Units__c)){
                                respObj.isError = true;
                                respObj.errorMessage = 'Please Enter Proposed OS Units for '+item.Product__r.Name;
                            }
                            if($A.util.isUndefinedOrNull(item.Vision_Proposed_RAD_Units__c)){
                                respObj.isError = true;
                                respObj.errorMessage = 'Please Enter Proposed RAD Units for '+item.Product__r.Name;
                            }
                            if($A.util.isUndefinedOrNull(item.Vision_Proposed_WMT_Units__c)){
                                respObj.isError = true;
                                respObj.errorMessage = 'Please Enter Proposed WMT Units for '+item.Product__r.Name;
                            }
                            if(item.Vision_Proposed_WMT_Units__c == 0 && item.Vision_Proposed_RAD_Units__c == 0 && item.Vision_Proposed_OS_Units__c == 0){
                                respObj.isError = true;
                                respObj.errorMessage = 'Please Enter At least one Proposed units for '+item.Product__r.Name;
                            }
                        }
                            else if(templateType == 'Econdisc'){
                                if($A.util.isUndefinedOrNull(item.Vision_Proposed_Direct_ESI_Units__c)){
                                    respObj.isError = true;
                                    respObj.errorMessage = 'Please Enter Proposed Direct ESI Units for '+item.Product__r.Name;
                                }
                                if($A.util.isUndefinedOrNull(item.Vision_Proposed_Indirect_ESI_Units__c)){
                                    respObj.isError = true;
                                    respObj.errorMessage = 'Please Enter Proposed Indirect ESI Units for '+item.Product__r.Name;
                                }
                                if($A.util.isUndefinedOrNull(item.Vision_Proposed_Direct_Kroger_Units__c)){
                                    respObj.isError = true;
                                    respObj.errorMessage = 'Please Enter Proposed Direct Kroger Units for '+item.Product__r.Name;
                                }
                                if($A.util.isUndefinedOrNull(item.Vision_Proposed_Indirect_Kroger_Units__c)){
                                    respObj.isError = true;
                                    respObj.errorMessage = 'Please Enter Proposed Indirect Kroger Units for '+item.Product__r.Name;
                                }
                                if($A.util.isUndefinedOrNull(item.Vision_Proposed_Direct_Rx_Outreach_Units__c)){
                                    respObj.isError = true;
                                    respObj.errorMessage = 'Please Enter Proposed Direct Rx Outreach Units for '+item.Product__r.Name;
                                }
                                if($A.util.isUndefinedOrNull(item.Vision_Proposed_IndirectRxOutreach_Units__c)){
                                    respObj.isError = true;
                                    respObj.errorMessage = 'Please Enter Proposed Indirect Rx Outreach Units for '+item.Product__r.Name;
                                }
                                if($A.util.isUndefinedOrNull(item.Vision_Proposed_Direct_Supervalu_Units__c)){
                                    respObj.isError = true;
                                    respObj.errorMessage = 'Please Enter Proposed Direct Supervalu Units for '+item.Product__r.Name;
                                }
                                if($A.util.isUndefinedOrNull(item.Vision_Proposed_Indirect_Supervalu_Units__c)){
                                    respObj.isError = true;
                                    respObj.errorMessage = 'Please Enter Proposed Indirect Supervalu Units for '+item.Product__r.Name;
                                }
                                if($A.util.isUndefinedOrNull(item.Vision_Proposed_Direct_Cordant_Units__c)){
                                    respObj.isError = true;
                                    respObj.errorMessage = 'Please Enter Proposed Direct Cordant Units for '+item.Product__r.Name;
                                }
                                if($A.util.isUndefinedOrNull(item.Vision_Proposed_Indirect_Cordant_Units__c)){
                                    respObj.isError = true;
                                    respObj.errorMessage = 'Please Enter Proposed Indirect Cordant Units for '+item.Product__r.Name;
                                }
                                if($A.util.isUndefinedOrNull(item.Vision_Proposed_Direct_Accerodo_Units__c)){
                                    respObj.isError = true;
                                    respObj.errorMessage = 'Please Enter Proposed Direct Accerodo Units for '+item.Product__r.Name;
                                }
                                if($A.util.isUndefinedOrNull(item.Vision_Proposed_Indirect_Accerodo_Units__c)){
                                    respObj.isError = true;
                                    respObj.errorMessage = 'Please Enter Proposed Indirect Accerodo Units for '+item.Product__r.Name;
                                }
                                if(item.Vision_Proposed_Direct_ESI_Units__c == 0 && item.Vision_Proposed_Indirect_Accerodo_Units__c == 0 && item.Vision_Proposed_Direct_Accerodo_Units__c == 0 && 
                                   item.Vision_Proposed_Indirect_Cordant_Units__c == 0 && item.Vision_Proposed_Direct_Cordant_Units__c == 0 && item.Vision_Proposed_Indirect_Supervalu_Units__c == 0 && 
                                   item.Vision_Proposed_Direct_Supervalu_Units__c == 0 && item.Vision_Proposed_IndirectRxOutreach_Units__c == 0 && item.Vision_Proposed_Direct_Rx_Outreach_Units__c &&
                                   item.Vision_Proposed_Indirect_Kroger_Units__c == 0 && item.Vision_Proposed_Direct_Kroger_Units__c == 0 && item.Vision_Proposed_Direct_ESI_Units__c == 0 && item.Vision_Proposed_Indirect_ESI_Units__c == 0){
                                    respObj.isError = true;
                                    respObj.errorMessage = 'Please Enter At least one Proposed units for '+item.Product__r.Name;
                                }
                            }
                                else if(templateType == 'ROS'){
                                    if($A.util.isUndefinedOrNull(item.Vision_Proposed_CVS_Direct_Units__c)){
                                        respObj.isError = true;
                                        respObj.errorMessage = 'Please Enter Proposed CVS Direct Units for '+item.Product__r.Name;
                                    }
                                    if($A.util.isUndefinedOrNull(item.Vision_Proposed_CVS_Indirect_Units__c)){
                                        respObj.isError = true;
                                        respObj.errorMessage = 'Please Enter Proposed CVS Indirect Units for '+item.Product__r.Name;
                                    }
                                    if($A.util.isUndefinedOrNull(item.Vision_Proposed_Cardinal_Units__c)){
                                        respObj.isError = true;
                                        respObj.errorMessage = 'Please Enter Proposed Cardinal Units for '+item.Product__r.Name;
                                    }
                                    if($A.util.isUndefinedOrNull(item.Vision_Proposed_Major_Units__c)){
                                        respObj.isError = true;
                                        respObj.errorMessage = 'Please Enter Proposed Major Units for '+item.Product__r.Name;
                                    }
                                    if(item.Vision_Proposed_CVS_Direct_Units__c == 0 && item.Vision_Proposed_CVS_Indirect_Units__c == 0 && 
                                       item.Vision_Proposed_Cardinal_Units__c == 0 && item.Vision_Proposed_Major_Units__c == 0 ){
                                        respObj.isError = true;
                                        respObj.errorMessage = 'Please Enter At least one Proposed units for '+item.Product__r.Name;
                                    }
                                }
            
        });
        return respObj;
    }
})