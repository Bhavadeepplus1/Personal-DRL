({
    doInit : function(component, event, helper) {
        component.set("v.showProductsloading",true);
        component.set("v.isError",false);
        var oppId = component.get("v.recordId");
        var err = component.get("v.isError");
        component.set("v.showZeroProds",false);
        var action = component.get("c.getOptyLinesAndCon");
        action.setParams({
            opportunityId: component.get('v.recordId')
        });
        action.setCallback(this, function(response){
            if(response.getState() == 'SUCCESS'){
                
                var wrapObj = response.getReturnValue();
                  component.set('v.AccountNumber',wrapObj.oppObj.Account.AccountNumber);
                //console.log('oppObj====='+wrapObj.optyProdList.length);
             /*   if(wrapObj.oppObj.Account.AccountNumber == '164498'){
                    component.set('v.selectAll',true);
                    component.set('v.noOfSelectedProd',wrapObj.optyProdList.length);
                }*/
                if(wrapObj.isError){
                    component.set("v.isError",true);
                    component.set("v.errormsg",''+wrapObj.errorMessage);
                    component.set("v.showProductsloading",false);
                }
                else{
                    if(wrapObj.refContractList == undefined || !component.get("v.pullNPRdata")){
                        
                        helper.getProdInfo(component, event, helper);
                    }
                    else{
                        component.set("v.optyProdList",wrapObj.optyProdList);
                        component.set("v.conList",wrapObj.refContractList);
                        if(wrapObj.oppObj.Account.Name.includes('Private Label'))
                            component.set("v.isOtcProdFam",true);
                       component.set('v.AccountNumber',wrapObj.oppObj.Account.AccountNumber);
                        component.set('v.templateType',wrapObj.oppObj.Vision_Bid_Template__c);
                        helper.getNprForOptyProds(component, event, helper, 0);
                    }
                }
            } else{
                console.log("Error "+JSON.stringify(response.getError()));
                component.set("v.showProductsloading",false);
            }
        });
        $A.enqueueAction(action);
    },
    handleComponentEvent : function(component, event, helper) {
        var valueFromChild = event.getParam("message");
    //    alert(valueFromChild)
        // component.set("v.enteredValue", valueFromChild);
    },
    goToAwarded : function(component, event, helper){
        component.set("v.showSectionName",'Awarded Products');
        component.set("v.isShowingTabName",'award');
    },
    
    goToNonAwarded : function(component, event, helper){
        component.set("v.showSectionName",'Non-Awarded Products');
        component.set("v.isShowingTabName",'nonAward');
        /*var yeldiv=document.getElementById('nonAwardedSection');
        yeldiv.style.display = "block";
        var offset=yeldiv.getBoundingClientRect();
        var scrollOptions = {
            left: offset.top,
            top: offset.left,
            behavior: 'smooth'
        }
        window.scrollTo(scrollOptions);*/
    },
    handleSectionToggle : function (component, event) {
        var openSections = event.getParam('openSections');

        if (openSections.length === 0) {
            component.set("v.isShowingTabName",'none');
        } else {
            var selectedCount = 0;
            openSections.forEach(function(sectionName){
                if(sectionName == 'Awarded Products'){
                    component.set("v.isShowingTabName",'award');
                    selectedCount++;
                }
                else if(sectionName == 'Non-Awarded Products'){
                    component.set("v.isShowingTabName",'nonAward');
                    selectedCount++;
                }
            });
            if(selectedCount == 2)
                component.set("v.isShowingTabName",'both');
        }
    },
    changePage : function(component, event, helper){
        component.set("v.selectedPageNumber",event.getSource().get("v.value"));
        helper.pageController(component, event, helper);
    },
    
    changeNonAwardedPage : function(component, event, helper){
        component.set("v.selectedNonAwardedPageNumber",event.getSource().get("v.value"));
        helper.paginateNonAwarded(component, event, helper);
    },
    
    changeAwardedPage : function(component, event, helper){
        component.set("v.selectedAwardedPageNumber",event.getSource().get("v.value"));
        helper.paginateAwarded(component, event, helper);
    },
    
    selectAllAwardedCheckbox : function(component, event, helper){
        var isSelectAllAwarded = component.get("v.isSelectAllAwarded");
        var awardedListdata = component.get("v.awardedListdata");
        var nonAwardedListdata = component.get("v.nonAwardedListdata");
        nonAwardedListdata.forEach(function(wrapObj){
            if(wrapObj.hasBidLineItem == false && wrapObj.optyProdObj){
                wrapObj.isSelected = false;
            }
        });
        component.set("v.nonAwardedListdata",nonAwardedListdata);
        component.set("v.isSelectAllNonAwarded",false);
        var noOfSelectedProd = 0;
        awardedListdata.forEach(function(wrapObj){
            if(wrapObj.hasBidLineItem == false && wrapObj.optyProdObj){
                wrapObj.isSelected = isSelectAllAwarded;
                noOfSelectedProd++;
            }
        });
        component.set("v.noOfSelectedProd", isSelectAllAwarded ? noOfSelectedProd : 0);
        component.set("v.awardedListdata",awardedListdata);
        helper.paginateAwarded(component, event, helper);
        helper.paginateNonAwarded(component, event, helper);
    },
    
    selectAllNonAwardedCheckbox : function(component, event, helper){
        var isSelectAllNonAwarded = component.get("v.isSelectAllNonAwarded");
        var nonAwardedListdata = component.get("v.nonAwardedListdata");
        var awardedListdata = component.get("v.awardedListdata");
        awardedListdata.forEach(function(wrapObj){
            if(wrapObj.hasBidLineItem == false && wrapObj.optyProdObj){
                wrapObj.isSelected = false;
            }
        });
        component.set("v.awardedListdata",awardedListdata);
        component.set("v.isSelectAllAwarded",false);
        var noOfSelectedProd = 0;
        nonAwardedListdata.forEach(function(wrapObj){
            if(wrapObj.hasBidLineItem == false && wrapObj.optyProdObj){
                wrapObj.isSelected = isSelectAllNonAwarded;
                noOfSelectedProd++;
            }
        });
        component.set("v.noOfSelectedProd", isSelectAllNonAwarded ? noOfSelectedProd : 0);
        component.set("v.nonAwardedListdata",nonAwardedListdata);
        helper.paginateAwarded(component, event, helper);
        helper.paginateNonAwarded(component, event, helper);
    },
    
    selectAllCheckbox : function(component, event, helper){
        console.log('on selectAllCheckbox');
        console.log('component.get("v.selectAll") --> '+component.get("v.selectAll"));
        var wrapperList = component.get("v.wrapperList");
        var isSelectAll = component.get("v.selectAll");
        var noOfSelectedProd = 0;
        wrapperList.forEach(function(wrapObj){
            if(wrapObj.hasBidLineItem == false && wrapObj.optyProdObj){
                if((component.get("v.isViewAllMatched") && wrapObj.optyProdObj.Vision_Uploaded_Pkg_Size__c == null) 
                   || (component.get("v.isViewPartialMatched") && wrapObj.optyProdObj.Vision_Uploaded_Pkg_Size__c != null)){
                wrapObj.isSelected = isSelectAll;
                noOfSelectedProd++;
            }
            }
        });
        component.set("v.noOfSelectedProd",isSelectAll ? noOfSelectedProd : 0);
        component.set("v.wrapperList",wrapperList);
        helper.pageController(component, event, helper);
    },
    
    checkBoxChangeHandler : function(component, event, helper){
        console.log('on checkBoxChangeHandler');
        console.log('component.get("v.selectAll") --> '+component.get("v.selectAll"));
        
        var wrapperList = component.get("v.pagedListdata");
        var noOfSelectedProd = 0;
        wrapperList.forEach(function(wrapObj){
            if(wrapObj.isSelected)
                noOfSelectedProd++;
            else
                component.set("v.selectAll",false);
        });
        component.set("v.noOfSelectedProd",noOfSelectedProd);
    },
    
    closeQuickActionPanel : function(component, event, helper) {
        //$A.get("e.force:closeQuickAction").fire();
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": component.get('v.recordId')
        });
        navEvt.fire();  
    },
    deleteLineItem : function(component, event, helper){
        var isDelete = event.getParam("isDelete");
        console.log('isDelete --> '+isDelete);
        if(isDelete){
            component.set("v.showProductsloading",true);
            console.log('inside delete row');
            var recordIdToDelete = event.getParam("recordIdToDelete");
            var action = component.get("c.deleteOptyProd");
            action.setParams({
                optyProdId: recordIdToDelete
            });
            action.setCallback(this, function(response){
                if(response.getState() == 'SUCCESS'){
                    console.log('call done and message :: '+response.getReturnValue());
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Info!",
                        "type":"info",
                        "message":response.getReturnValue()
                    });
                    toastEvent.fire(); 
                    component.set("v.pullNPRdata",false);
                    var a = component.get('c.doInit');
                    $A.enqueueAction(a);
                    component.set("v.showProductsloading",false);
                } else{
                    console.log("Error "+JSON.stringify(response.getError()));
                    component.set("v.showProductsloading",false);
                }
            });
            $A.enqueueAction(action);
        }
        else{
            var selectedProdId = event.getParam("checkedRecordId");
            var wrapperList = component.get("v.wrapperList");
            var noOfSelectedProd = 0;
            wrapperList.forEach(function(wrapObj){
                if(wrapObj.isSelected)
                    noOfSelectedProd++;
                else
                    component.set("v.selectAll",false);
            });
            component.set("v.noOfSelectedProd",noOfSelectedProd);
        }
    },
    closeBidSelectionPopup : function(component, event, helper){
        component.set("v.showOpenBids",false);
    },
    openBidSelectionPopUp : function(component, event, helper){
        /*if(component.get("v.optyObj").Bid_Type__c == 'RFP'){
            component.set("v.selectedBidType",'RFP Bids');
            component.set("v.showOpenBids",component.get("v.showOpenBids") ? false : true);
            if(component.get("v.showOpenBids")){
                helper.getOpenBidList(component, event, helper, 'RFP Bids');
            }
        }
        else{*/
        var isProceed = helper.validatePropUnits(component,event, helper);
        if(!isProceed.isError){
            component.set("v.sendToBrightType",'toBid');
            if(component.get("v.isOtcProdFam"))
                component.set("v.selectedBidType",'OTC Product Addition');
            else
                component.set("v.selectedBidType",'Product Addition');
            component.set("v.showBidTypeSelection",true);
        }
        else{
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Warning!",
                "type":"Warning",
                "message":""+isProceed.errorMessage
            });
            toastEvent.fire(); 
        }
    },
    closeBidTypeSelection : function(component, event, helper){
        component.set("v.showBidTypeSelection",false);
    },
    onBidTypeUpdate : function(component, event, helper){
        var val = event.getSource().get('v.value');
        if(val == null && val == undefined)
            val = component.get("v.selectedBidType");
        component.set("v.selectedBidType",val);
    },
    getBidTypeList : function(component, event, helper){
        helper.getOpenBidList(component, event, helper, component.get("v.selectedBidType"));
    },
    bidSelected : function(component, event, helper){
        var selectedId = event.getSource().get("v.name");//event.currentTarget.dataset.id;
        console.log('selectedId -->> '+selectedId);
        component.set("v.selectedBidId",selectedId);
        var bidWrapList = component.get("v.openBidList");
        bidWrapList.forEach(function(bidWrapRec){
            if(bidWrapRec.bidRec.Id == selectedId){
                bidWrapRec.isSelected = true;
            }
            else{
                bidWrapRec.isSelected = false;
            }
        });
        component.set("v.openBidList",bidWrapList);
    },
    
    closeConfirmation : function(component, event, helper){
        component.set("v.showConfirmation",false);
        if(component.get("v.sendToBrightType")=='toBid')
            component.set("v.showOpenBids",true);
    },
    
    hideModel : function(component, event, helper){
        component.set("v.showModal", false);
    },
    
    sendToBright: function(component, event, helper){
        var optyObj = component.get("v.optyObj");
        if(optyObj.Vision_Reference_Contract__c == undefined && component.get("v.selectedBidType") != 'New Customer' && component.get("v.selectedBidType") != 'Platform OTB'){
            helper.getContractList(component, event, helper);
        }
        else{
            component.set("v.showModal", false);
            component.set("v.showConfirmation",false);
            var sendToBrightType = component.get("v.sendToBrightType");
            var selectedProdList = [];
            component.get("v.wrapperList").forEach(function(wrapObj){
                if(wrapObj.isSelected)
                    selectedProdList.push(wrapObj.optyProdObj);
            });
            component.set("v.selectedProdList",selectedProdList);
            if(sendToBrightType == 'newBid'){
                component.set("v.loadingMessage",'Please Wait, Creating a new bid with selected Products ... ');
                helper.createNewBid(component, event, helper);
            }
            
            else if(sendToBrightType == 'toBid'){
                component.set("v.loadingMessage",'Please Wait, Adding Products to the Bid ... ');
                helper.addToBid(component, event, helper);
            }
        }
    },
    
    saveDetails : function(component, event, helper){
        var selectrcs=component.find('linesTable').getSelectedRows();
        var selectedCntrcts = [];
        for(var i=0;i<selectrcs.length;i++){
            selectedCntrcts.push(selectrcs[i].Phoenix_Contract_Number__c);
        } 
        if(selectedCntrcts.length>0){
            var action = component.get("c.saveOptyWithContracts");
            action.setParams({selectrcs: selectedCntrcts,optyId : component.get("v.recordId")}); 
            action.setCallback(this, function(response){
                if (response.getState() === "SUCCESS") {
                    var optyProd = response.getReturnValue();
                    component.set("v.optyObj",optyProd);
                    
                    var a = component.get('c.sendToBright');
                    $A.enqueueAction(a);
                }
                else{
                    console.log('ERROR from saving Opty --> '+JSON.stringify(response.getError()));
                }
            }); $A.enqueueAction(action);
        }
        else{
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "No Contract Selected!",
                "type":"Error",
                "message":"Please select atleast One Contract to save."
            });
            toastEvent.fire(); 
        }
    },
    
    confirmAddToBid : function(component, event, helper){
        component.set("v.confirmFinalItem",false);
        var selectedBidId = component.get("v.selectedBidId");
        var bidNum = '';
        var bidWrapList = component.get("v.openBidList");
        bidWrapList.forEach(function(bidWrapRec){
            if(bidWrapRec.bidRec.Id == selectedBidId){
                bidNum = bidWrapRec.bidRec.Name;
                return;
            }
        });
        component.set("v.confirmationMessage",'Do you want to add selected products to Bid# '+bidNum+'?');
        component.set("v.sendToBrightType",'toBid');
        component.set("v.showOpenBids",false);
        component.set("v.showConfirmation",true);
        console.log('component.get("v.selectedBidType") --> '+component.get("v.selectedBidType"));
        if(component.get("v.selectedBidType") == 'RFP Bids' || component.get("v.selectedBidType") == 'OTC RFP')
            component.set("v.isFullLineConfirm",true);//document.getElementById('isFullLineConfirm').style.display="";
        else
            component.set("v.confirmFinalItem",true);//document.getElementById('confirmFinalItem').style.display="";
    },
    askToPopulateNo : function(component, event, helper){
        component.set("v.confirmFinalItem",false);
        component.set("v.isFullLineRfpBid",false);
        component.set("v.isFullLineConfirm",false);
        component.set("v.askToPopInAnalysis",true);
    },
    askToPopulate : function(component, event, helper){
        component.set("v.confirmFinalItem",false);
        component.set("v.isFullLineRfpBid",true);
        component.set("v.isFullLineConfirm",false);//document.getElementById('isFullLineConfirm').style.display="none";
        component.set("v.askToPopInAnalysis",true);//document.getElementById('askToPopInAnalysis').style.display="";
    },
    notSyncSelected : function(component, event, helper){
        component.set("v.syncToAnalysis",false);
        component.set("v.askToPopInAnalysis",false);//document.getElementById('askToPopInAnalysis').style.display="none";
        component.set("v.confirmFinalItem",true);//document.getElementById('confirmFinalItem').style.display="";
    },
    fullLineSelected : function(component, event, helper){
        component.set("v.syncToAnalysis",true);
        component.set("v.askToPopInAnalysis",false);//document.getElementById('askToPopInAnalysis').style.display="none";
        component.set("v.confirmFinalItem",true);//document.getElementById('confirmFinalItem').style.display="";
    },
    showBidTypeSelection : function(component, event, helper){
        component.set("v.confirmFinalItem",false);
        component.set("v.sendToBrightType",'newBid');
        var isProceed = helper.validatePropUnits(component,event, helper);
        if(!isProceed.isError){
            if(component.get("v.optyObj").Vision_Previous_Bid__c != undefined){
                component.set("v.showConfirmation",true);
                component.set("v.isFullLineConfirm",true);
            }
            else{
                if(component.get("v.isOtcProdFam"))
                    component.set("v.selectedBidType",'OTC Product Addition');
                else
                    component.set("v.selectedBidType",'Product Addition');
                component.set("v.showBidTypeSelection",true);
            }
        }
        else{
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Warning!",
                "type":"Warning",
                "message":""+isProceed.errorMessage
            });
            toastEvent.fire(); 
        }
    },
    confirmCreateNewBid : function(component, event, helper){
        component.set("v.confirmFinalItem",false);
        component.set("v.sendToBrightType",'newBid');
        component.set("v.showBidTypeSelection",false);
        component.set("v.confirmationMessage",'Do you want to create a new bid for selected products?');
        component.set("v.showOpenBids",false);
        component.set("v.showConfirmation",true);
        
        var PharmaBidLabel = $A.get("$Label.c.PharmaBidLabel");
        if(PharmaBidLabel == component.get("v.AccountNumber"))
            component.set("v.selectedBidType",'Platform OTB');
        
        var bidType = component.get("v.selectedBidType");
        console.log('component.get("v.selectedBidType") --> '+bidType);
        if(bidType == 'RFP Bids' || bidType == 'OTC RFP')
            component.set("v.isFullLineConfirm",true);//document.getElementById('isFullLineConfirm').style.display="";
        else
            component.set("v.confirmFinalItem",true);//document.getElementById('confirmFinalItem').style.display="";
        
    },
    selectBidSelected : function(component, event, helper){
        component.set("v.sendToBrightType",'toBid');
    },
    createNewBidSelected : function(component, event, helper){
        component.set("v.sendToBrightType",'newBid');
    },
    showOptyCmntInput : function(component, event, helper){
        component.set("v.editOptyComment", component.get("v.editOptyComment")?false:true);
    },
    saveCmnt : function(component, event, helper){
        var optyObj = component.get("v.optyObj");
        console.log("comment --> "+optyObj.Vision_Comments__c);
        if(optyObj.Vision_Comments__c != undefined && optyObj.Vision_Comments__c != ''){
            var action = component.get("c.updateOptyCmnt");
            action.setParams({optyObj:optyObj}); 
            action.setCallback(this, function(response){
                if (response.getState() === "SUCCESS") {
                    var optyProd = response.getReturnValue();
                    component.set("v.optyObj",optyProd);
                    component.set("v.editOptyComment", component.get("v.editOptyComment")?false:true);
                }
                else{
                    console.log('ERROR from saving Opty --> '+JSON.stringify(response.getError()));
                }
            }); $A.enqueueAction(action);
        }
    },
    zeroAnualUnitsChanged : function(component, event, helper){
        component.set("v.pagedListdata",[]);
        component.set("v.showProductsloading",true);
        console.log('inside zeroAnualUnitsChanged');
        //var checkCmp = component.find("tglbtn");
        
        var getNoProposedUnitsProds = component.get("v.showZeroProds");//checkCmp.get("v.value");//
        console.log('showZeroProds --> '+getNoProposedUnitsProds);
        if(getNoProposedUnitsProds){
            console.log('inside if condition');
            var wrapList = component.get("v.wrapperList");
            console.log('wrapList.size --> '+wrapList.length);
            var noUsageList = [];
            wrapList.forEach(function(item){
                var optyProdObj = item.optyProdObj;
                console.log('inside forEach and optyProdObj.Proposed_Indirect_Selling_Units__c --> '+optyProdObj.Proposed_Indirect_Selling_Units__c);
                if(item.optyProdObj){
                    optyProdObj.Vision_Proposed_Volume__c = (optyProdObj.Vision_Proposed_Volume__c != '' && optyProdObj.Vision_Proposed_Volume__c != undefined) ? optyProdObj.Vision_Proposed_Volume__c : 0;
                    optyProdObj.Proposed_Direct_Selling_Units__c = (optyProdObj.Proposed_Direct_Selling_Units__c != '' && optyProdObj.Proposed_Direct_Selling_Units__c != undefined) ? optyProdObj.Proposed_Direct_Selling_Units__c : 0;
                    optyProdObj.Proposed_Indirect_Selling_Units__c = (optyProdObj.Proposed_Indirect_Selling_Units__c != '' && optyProdObj.Proposed_Indirect_Selling_Units__c != undefined) ? optyProdObj.Proposed_Indirect_Selling_Units__c : 0;
                    optyProdObj.Vision_Proposed_OS_Units__c = (optyProdObj.Vision_Proposed_OS_Units__c != '' && optyProdObj.Vision_Proposed_OS_Units__c != undefined) ? optyProdObj.Vision_Proposed_OS_Units__c : 0;
                    optyProdObj.Vision_Proposed_RAD_Units__c = (optyProdObj.Vision_Proposed_RAD_Units__c != '' && optyProdObj.Vision_Proposed_RAD_Units__c != undefined) ? optyProdObj.Vision_Proposed_RAD_Units__c : 0;
                    optyProdObj.Vision_Proposed_WMT_Units__c = (optyProdObj.Vision_Proposed_WMT_Units__c != '' && optyProdObj.Vision_Proposed_WMT_Units__c != undefined) ? optyProdObj.Vision_Proposed_WMT_Units__c : 0;
                    optyProdObj.Vision_Proposed_BASE_Units__c = (optyProdObj.Vision_Proposed_BASE_Units__c != '' && optyProdObj.Vision_Proposed_BASE_Units__c != undefined) ? optyProdObj.Vision_Proposed_BASE_Units__c : 0;
                    optyProdObj.Vision_Proposed_DSH_Units__c = (optyProdObj.Vision_Proposed_DSH_Units__c != '' && optyProdObj.Vision_Proposed_DSH_Units__c != undefined) ? optyProdObj.Vision_Proposed_DSH_Units__c : 0;
                    optyProdObj.Vision_Proposed_AutoSub_Units__c = (optyProdObj.Vision_Proposed_AutoSub_Units__c != '' && optyProdObj.Vision_Proposed_AutoSub_Units__c != undefined) ? optyProdObj.Vision_Proposed_AutoSub_Units__c : 0;
                    optyProdObj.Vision_Proposed_Smith_Drug_Units__c = (optyProdObj.Vision_Proposed_Smith_Drug_Units__c != '' && optyProdObj.Vision_Proposed_Smith_Drug_Units__c != undefined) ? optyProdObj.Vision_Proposed_Smith_Drug_Units__c : 0;
                    optyProdObj.Vision_Proposed_Anda_Units__c = (optyProdObj.Vision_Proposed_Anda_Units__c != '' && optyProdObj.Vision_Proposed_Anda_Units__c != undefined) ? optyProdObj.Vision_Proposed_Anda_Units__c : 0;
                    optyProdObj.Vision_Proposed_DirectAholdDelhaizeUnits__c = (optyProdObj.Vision_Proposed_DirectAholdDelhaizeUnits__c != '' && optyProdObj.Vision_Proposed_DirectAholdDelhaizeUnits__c != undefined) ? optyProdObj.Vision_Proposed_DirectAholdDelhaizeUnits__c : 0;
                    optyProdObj.Vision_Proposed_Direct_Gaint_Eagle_Units__c = (optyProdObj.Vision_Proposed_Direct_Gaint_Eagle_Units__c != '' && optyProdObj.Vision_Proposed_Direct_Gaint_Eagle_Units__c != undefined) ? optyProdObj.Vision_Proposed_Direct_Gaint_Eagle_Units__c : 0;
                    optyProdObj.Vision_Proposed_TotalRetailIndirectUnits__c = (optyProdObj.Vision_Proposed_TotalRetailIndirectUnits__c != '' && optyProdObj.Vision_Proposed_TotalRetailIndirectUnits__c != undefined) ? optyProdObj.Vision_Proposed_TotalRetailIndirectUnits__c : 0;
                    
                    optyProdObj.Vision_Proposed_Direct_ESI_Units__c = (optyProdObj.Vision_Proposed_Direct_ESI_Units__c != '' && optyProdObj.Vision_Proposed_Direct_ESI_Units__c != undefined) ? optyProdObj.Vision_Proposed_Direct_ESI_Units__c : 0;
                    optyProdObj.Vision_Proposed_Indirect_ESI_Units__c = (optyProdObj.Vision_Proposed_Indirect_ESI_Units__c != '' && optyProdObj.Vision_Proposed_Indirect_ESI_Units__c != undefined) ? optyProdObj.Vision_Proposed_Indirect_ESI_Units__c : 0;
                    optyProdObj.Vision_Proposed_Direct_Kroger_Units__c = (optyProdObj.Vision_Proposed_Direct_Kroger_Units__c != '' && optyProdObj.Vision_Proposed_Direct_Kroger_Units__c != undefined) ? optyProdObj.Vision_Proposed_Direct_Kroger_Units__c : 0;
                    optyProdObj.Vision_Proposed_Indirect_Kroger_Units__c = (optyProdObj.Vision_Proposed_Indirect_Kroger_Units__c != '' && optyProdObj.Vision_Proposed_Indirect_Kroger_Units__c != undefined) ? optyProdObj.Vision_Proposed_Indirect_Kroger_Units__c : 0;
                    optyProdObj.Vision_Proposed_Direct_Rx_Outreach_Units__c = (optyProdObj.Vision_Proposed_Direct_Rx_Outreach_Units__c != '' && optyProdObj.Vision_Proposed_Direct_Rx_Outreach_Units__c != undefined) ? optyProdObj.Vision_Proposed_Direct_Rx_Outreach_Units__c : 0;
                    optyProdObj.Vision_Proposed_IndirectRxOutreach_Units__c = (optyProdObj.Vision_Proposed_IndirectRxOutreach_Units__c != '' && optyProdObj.Vision_Proposed_IndirectRxOutreach_Units__c != undefined) ? optyProdObj.Vision_Proposed_IndirectRxOutreach_Units__c : 0;
                    optyProdObj.Vision_Proposed_Direct_Supervalu_Units__c = (optyProdObj.Vision_Proposed_Direct_Supervalu_Units__c != '' && optyProdObj.Vision_Proposed_Direct_Supervalu_Units__c != undefined) ? optyProdObj.Vision_Proposed_Direct_Supervalu_Units__c : 0;
                    optyProdObj.Vision_Proposed_Indirect_Supervalu_Units__c = (optyProdObj.Vision_Proposed_Indirect_Supervalu_Units__c != '' && optyProdObj.Vision_Proposed_Indirect_Supervalu_Units__c != undefined) ? optyProdObj.Vision_Proposed_Indirect_Supervalu_Units__c : 0;
                    optyProdObj.Vision_Proposed_Direct_Cigna_Units__c = (optyProdObj.Vision_Proposed_Direct_Cigna_Units__c != '' && optyProdObj.Vision_Proposed_Direct_Cigna_Units__c != undefined) ? optyProdObj.Vision_Proposed_Direct_Cigna_Units__c : 0;
                    optyProdObj.Vision_Proposed_Indirect_Cigna_Units__c = (optyProdObj.Vision_Proposed_Indirect_Cigna_Units__c != '' && optyProdObj.Vision_Proposed_Indirect_Cigna_Units__c != undefined) ? optyProdObj.Vision_Proposed_Indirect_Cigna_Units__c : 0;
                    optyProdObj.Vision_Proposed_Direct_Cordant_Units__c = (optyProdObj.Vision_Proposed_Direct_Cordant_Units__c != '' && optyProdObj.Vision_Proposed_Direct_Cordant_Units__c != undefined) ? optyProdObj.Vision_Proposed_Direct_Cordant_Units__c : 0;
                    optyProdObj.Vision_Proposed_Direct_Accerodo_Units__c = (optyProdObj.Vision_Proposed_Direct_Accerodo_Units__c != '' && optyProdObj.Vision_Proposed_Direct_Accerodo_Units__c != undefined) ? optyProdObj.Vision_Proposed_Direct_Accerodo_Units__c : 0;
                    optyProdObj.Vision_Proposed_Indirect_Accerodo_Units__c = (optyProdObj.Vision_Proposed_Indirect_Accerodo_Units__c != '' && optyProdObj.Vision_Proposed_Indirect_Accerodo_Units__c != undefined) ? optyProdObj.Vision_Proposed_Indirect_Accerodo_Units__c : 0;
                    optyProdObj.Vision_Proposed_Indirect_Cordant_Units__c = (optyProdObj.Vision_Proposed_Indirect_Cordant_Units__c != '' && optyProdObj.Vision_Proposed_Indirect_Cordant_Units__c != undefined) ? optyProdObj.Vision_Proposed_Indirect_Cordant_Units__c : 0;
                    optyProdObj.Vision_Total_Proposed_Units_EU__c = (optyProdObj.Vision_Total_Proposed_Units_EU__c != '' && optyProdObj.Vision_Total_Proposed_Units_EU__c != undefined) ? optyProdObj.Vision_Total_Proposed_Units_EU__c : 0;
                    optyProdObj.Vision_Proposed_Value_EA__c = (optyProdObj.Vision_Proposed_Value_EA__c != '' && optyProdObj.Vision_Proposed_Value_EA__c != undefined) ? optyProdObj.Vision_Proposed_Value_EA__c : 0;
                    
                    optyProdObj.Vision_Proposed_CVS_Direct_Units__c = (optyProdObj.Vision_Proposed_CVS_Direct_Units__c != '' && optyProdObj.Vision_Proposed_CVS_Direct_Units__c != undefined) ? optyProdObj.Vision_Proposed_CVS_Direct_Units__c : 0;
                    optyProdObj.Vision_Proposed_CVS_Indirect_Units__c = (optyProdObj.Vision_Proposed_CVS_Indirect_Units__c != '' && optyProdObj.Vision_Proposed_CVS_Indirect_Units__c != undefined) ? optyProdObj.Vision_Proposed_CVS_Indirect_Units__c : 0;
                    optyProdObj.Vision_Proposed_Cardinal_Units__c = (optyProdObj.Vision_Proposed_Cardinal_Units__c != '' && optyProdObj.Vision_Proposed_Cardinal_Units__c != undefined) ? optyProdObj.Vision_Proposed_Cardinal_Units__c : 0;
                    optyProdObj.Vision_Proposed_Major_Units__c = (optyProdObj.Vision_Proposed_Major_Units__c != '' && optyProdObj.Vision_Proposed_Major_Units__c != undefined) ? optyProdObj.Vision_Proposed_Major_Units__c : 0;
                    
                    var totalProposedUnits = parseInt(optyProdObj.Proposed_Direct_Selling_Units__c)+parseInt(optyProdObj.Proposed_Indirect_Selling_Units__c)+parseInt(optyProdObj.Vision_Proposed_OS_Units__c)
                    +parseInt(optyProdObj.Vision_Proposed_RAD_Units__c)+parseInt(optyProdObj.Vision_Proposed_WMT_Units__c)+parseInt(optyProdObj.Vision_Proposed_BASE_Units__c)+parseInt(optyProdObj.Vision_Proposed_DSH_Units__c)
                    +parseInt(optyProdObj.Vision_Proposed_AutoSub_Units__c)+parseInt(optyProdObj.Vision_Proposed_Smith_Drug_Units__c)+parseInt(optyProdObj.Vision_Proposed_Anda_Units__c)+parseInt(optyProdObj.Vision_Proposed_DirectAholdDelhaizeUnits__c)
                    +parseInt(optyProdObj.Vision_Proposed_Direct_Gaint_Eagle_Units__c)+parseInt(optyProdObj.Vision_Proposed_TotalRetailIndirectUnits__c)+parseInt(optyProdObj.Vision_Proposed_Direct_ESI_Units__c)
                    +parseInt(optyProdObj.Vision_Proposed_Indirect_ESI_Units__c)+parseInt(optyProdObj.Vision_Proposed_Direct_Kroger_Units__c)+parseInt(optyProdObj.Vision_Proposed_Indirect_Kroger_Units__c)
                    +parseInt(optyProdObj.Vision_Proposed_Direct_Rx_Outreach_Units__c)+parseInt(optyProdObj.Vision_Proposed_IndirectRxOutreach_Units__c)+parseInt(optyProdObj.Vision_Proposed_Direct_Supervalu_Units__c)
                    +parseInt(optyProdObj.Vision_Proposed_Indirect_Supervalu_Units__c)+parseInt(optyProdObj.Vision_Proposed_Direct_Cigna_Units__c)+parseInt(optyProdObj.Vision_Proposed_Indirect_Cigna_Units__c)
                    +parseInt(optyProdObj.Vision_Proposed_Direct_Cordant_Units__c)+parseInt(optyProdObj.Vision_Proposed_Indirect_Cordant_Units__c)+parseInt(optyProdObj.Vision_Proposed_Direct_Accerodo_Units__c)
                    +parseInt(optyProdObj.Vision_Proposed_Indirect_Accerodo_Units__c)+parseInt(optyProdObj.Vision_Proposed_CVS_Direct_Units__c)
                    +parseInt(optyProdObj.Vision_Proposed_CVS_Indirect_Units__c)+parseInt(optyProdObj.Vision_Proposed_Cardinal_Units__c)+parseInt(optyProdObj.Vision_Proposed_Major_Units__c);
                    console.log('totalProposedUnits --> '+totalProposedUnits);    
                    if(totalProposedUnits == 0){
                        console.log('inside total ZERO');
                        noUsageList.push(item);
                    }
                }
            });
            console.log('noUsageList.length -- > '+noUsageList.length);
            if(noUsageList.length == 0){
                component.set("v.doesOptyProdsExists",false);
                component.set("v.showProductsloading",false);
                component.set("v.loadingMessage",'');
            }
            else{
                console.log('assigning to list');
                component.set("v.showProductsloading",false);
                component.set("v.loadingMessage",'');
                component.set("v.pagedListdata",noUsageList);
                console.log('IT IS DONE');
                //component.set("v.pageNumberList",[]);
            }
        }
        else{
            console.log('<-- inside else -->');
            var optyProdList = component.get("v.wrapperList");
            console.log('optyProdList size -->'+optyProdList.length);
            if(optyProdList.length == 0){
                component.set("v.doesOptyProdsExists",false);
                component.set("v.showProductsloading",false);
                component.set("v.loadingMessage",'');
            }
            else if(optyProdList.length < 50){
                component.set("v.pagedListdata",optyProdList);
                component.set("v.doesOptyProdsExists",true);
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
        }
    }
})