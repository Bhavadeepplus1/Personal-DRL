({
    doInit: function (component, event, helper) {
        component.set("v.loadingMessage",'Loading Opportunity Products...');
        component.set("v.isSpinnerLoad",true);
        component.set("v.showMergePopup",false);
        console.log("---doInit()-----");
        component.set("v.filteredDescData", []);  
        component.set("v.filteredUnMatchData", []);  
        component.set("v.filteredMatchData", []);          
        helper.showProducts(component, event, helper);
    },
    tabSelected : function(component,event, helper){
        helper.paginateRecords(component,event);
    },
    matchedProductsTabSelected : function(component,event, helper){
        component.set("v.selTabId",'matchPrds');
        helper.paginateRecords(component,event);
    },
    unmatchedProductsTabSelected : function(component,event, helper){
        
        var action = component.get("c.getUnMatchedProds");
        action.setParams({
            "opportunityId": component.get('v.recordId')
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.totalUnmatchdata",response.getReturnValue());
                component.set("v.selTabId",'unmatchPrds');
                component.set("v.isUnMatchAsc",false);
                helper.sortBy(component,helper, "Product_Description__c");
            }
            else {
                console.log("failed " + JSON.stringify(response.getError()));
                component.set('v.showProductsloading', false);
            }
        });
        $A.enqueueAction(action);
    },
    discrepancyProductsTabSelected : function(component,event, helper){
        /* console.log('autoCalcUnits  '+component.get("v.autoCalcUnits"));
        var discProdList = component.get("v.totalDiscdata");
        
        var dupPrdList = [];
        discProdList.forEach(function (record) {
            dupPrdList.push(record.Product__c);
        });
        dupPrdList = helper.findRepeatingProducts(dupPrdList, dupPrdList.length);
        
        var noUsageList = [];
        var prodMap = new Map();
        var prodListForMap = [];
        
        for(var i=0; i<discProdList.length; i++){
            if(!prodListForMap.includes(discProdList[i].Product__c))
                prodListForMap.push(discProdList[i].Product__c);
            if('GSN__c' in discProdList[i]){
            } else{
                discProdList[i].noGSN = true;
            }
            if('GPI_Generic_Product_Identifier__c' in discProdList[i]){
            } else{
                discProdList[i].noGPI = true;
            }
            if('SKU_Number__c' in discProdList[i]){
            } else{
                discProdList[i].noSKU = true;
            }
            if('NDC_11__c' in discProdList[i]){
            } else{
                discProdList[i].noNDC = true;
            }
            if('GCN_Generic_Code_Number__c' in discProdList[i]){
            } else{
                discProdList[i].noGCN = true;
            }
            if('Vision_Total_Annual_Units__c' in discProdList[i]){
            } else{
                discProdList[i].noUsage = true;
                //noUsageList.push(discProdList[i]);
            }
            if( discProdList[i].Vision_Total_Annual_Units__c == null 
               || discProdList[i].Vision_Total_Annual_Units__c < 0)
                discProdList[i].noUsage = true;
            //console.log('---wrapperObject Product ---'+discProdList[i].Product__c);
            if(dupPrdList.includes(discProdList[i].Product__c)){
                discProdList[i].isDuplicate = true;
            }
            if(!prodMap.has(discProdList[i].Product__c))
                prodMap.set(discProdList[i].Product__c,[]);
            prodMap.get(discProdList[i].Product__c).push(discProdList[i]);
        }
        
        //component.set("v.noUsageList",noUsageList);
        var duplicateProdList = [];
        var otherDupProdList = [];
        var bidonhighestpackList = [];
        var bidonalterpackList = [];
        var inActiveList = [];
        var inCorrectFormat = [];
        prodListForMap.forEach(function(prodId){
            if(prodMap.has(prodId)){
                var prodOptyList = prodMap.get(prodId);
                if(prodOptyList.length > 1){
                    var itemObj = {};
                    var otherDupList = {};
                    itemObj.produtId = prodId;
                    itemObj.prodOptyList = [];
                    prodOptyList.forEach(function(prodObj){
                        itemObj.prodOptyList.push(prodObj);
                    });          
                    if((!prodOptyList[0].Is_NDC_Matched__c && !prodOptyList[0].Is_SKU_Matched__c && !prodOptyList[0].Is_GCN_Pack_Size_Matched__c 
                        && !prodOptyList[0].Is_GSN_Pack_Size_Matched__c && !prodOptyList[0].Is_GPI_Pack_Size_Matched__c) && 
                       (prodOptyList[0].Is_GCN_Matched__c || prodOptyList[0].Is_GSN_Matched__c || prodOptyList[0].Is_GPI_Matched__c))
                        otherDupProdList.push(itemObj);
                    else
                        duplicateProdList.push(itemObj);
                }
                else if(prodOptyList[0].Vision_inActive__c){
                    var itemObj = {};
                    itemObj.produtId = prodId;
                    itemObj.prodOptyList = [];
                    itemObj.prodOptyList.push(prodOptyList[0]);
                    if((!prodOptyList[0].Is_NDC_Matched__c && !prodOptyList[0].Is_SKU_Matched__c && !prodOptyList[0].Is_GCN_Pack_Size_Matched__c 
                        && !prodOptyList[0].Is_GSN_Pack_Size_Matched__c && !prodOptyList[0].Is_GPI_Pack_Size_Matched__c) && 
                       (prodOptyList[0].Is_GCN_Matched__c || prodOptyList[0].Is_GSN_Matched__c || prodOptyList[0].Is_GPI_Matched__c))
                        otherDupProdList.push(itemObj);
                    else
                        duplicateProdList.push(itemObj);
                }
                    else if(!prodOptyList[0].Vision_inActive__c && (prodOptyList[0].Is_GCN_Matched__c || prodOptyList[0].Is_GSN_Matched__c || prodOptyList[0].Is_GPI_Matched__c))
                        inCorrectFormat.push(prodOptyList[0]);
                        else if(prodOptyList[0].Vision_Bid_on_Highest_Pack_Size__c)
                            bidonhighestpackList.push(prodOptyList[0]);
                            else if(prodOptyList[0].Vision_Bid_on_Alternative_Pack_Size__c)
                                bidonalterpackList.push(prodOptyList[0]);
            }
        });
        inCorrectFormat.forEach(function(item){
            console.log('OS proposed unit in Parent --> '+item.Vision_Proposed_OS_Units__c);
        });
        component.set("v.inCorrectFormat",inCorrectFormat);
        component.set("v.inActiveList",inActiveList);
        component.set("v.noUsageList",noUsageList);
        component.set("v.bidonhighestpackList",bidonhighestpackList);
        component.set("v.bidonalterpackList",bidonalterpackList);
        component.set("v.duplicateProdList",duplicateProdList);
        component.set("v.otherDupProdList",otherDupProdList);
        component.set("v.autoCalcUnits",true);*/
        component.set("v.selTabId",'discPrds');
        //helper.showProducts(component, event, helper);
        //helper.paginateRecords(component,event);
    },
    changePageForMatched : function(component,event, helper){
        console.log("--changePageForMatched--"); 
        component.set("v.selectedPageNumberMatched",event.getSource().get("v.value"));
        helper.paginateRecords(component,event);
    },
    changePageForUnmatched : function(component,event, helper){
        console.log("--changePageForUnmatched--"); 
        component.set("v.selectedPageNumberUnmatched",event.getSource().get("v.value"));
        helper.paginateRecords(component,event);
    },
    saveChangeRecords: function (component, event, helper) {
        console.log('Saving changed records ...');
        var unMatchRecs = component.get("v.totalUnmatchdata");
        var callmapunMatchMethod = false;
        unMatchRecs.forEach(function (record){
            if (record != null && 'Product__c' in record){
                if(record['Product__c'] != null && record['Product__c'] != undefined && record['Product__c'] != ''){
                    callmapunMatchMethod = true;
                }
            }
        });
        if(callmapunMatchMethod){
            console.log('Moving the records ...');
            helper.mapUnMatchRecords(component, event, helper);
        }
    },
    saveOptyLineItems: function (component, event, helper) {
        console.log('--saveOptyLineItems--');
        component.set('v.showProductsloading', true);
        var action = component.get("c.saveOptyProducts");
        //var matchRecords = component.get("v.matchdata");
        //var unmatchRecords = component.get("v.unmatchdata");
        var matchRecords = component.get("v.totalMatchdata");
        var unmatchRecords = component.get("v.totalUnmatchdata");
        var duplicateRecords = component.get("v.noUsageList");
        duplicateRecords.forEach(function (record) {
            matchRecords.push(record);
        });
        console.log('---matchRecords---'+JSON.stringify(matchRecords));
        action.setParams({
            "opportunityId": component.get('v.recordId'),
            "matchData": JSON.stringify(matchRecords),
            "unmatchData": JSON.stringify(unmatchRecords)
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": "success",
                    "title": "Success!",
                    "message": "Records saved successfully"
                });
                toastEvent.fire();
                helper.showProducts(component, event, helper);
                //component.set('v.showProductsloading', false);
            }
            else {
                console.log("failed " + JSON.stringify(response.getError()));
                component.set('v.showProductsloading', false);
            }
        });
        $A.enqueueAction(action);
        
    },
    moveToContracts:function (component, event, helper) {
        console.log('component.get("v.recordId") in moveToCon ::: '+component.get("v.recordId"));
        component.set("v.loadingMessage",'Please Wait, Loading the Contracts...');
        component.set('v.isSpinnerLoad',true);
        
        var action = component.get("c.getOptyRec");
        action.setParams({
            optyId: component.get("v.recordId")
        });
        action.setCallback(this, function(response){
            if(response.getState() == 'SUCCESS'){
                console.log('Success: '+JSON.stringify(response.getReturnValue()));
                var resp = response.getReturnValue();
                component.set("v.oppData",resp);
                console.log('resp.AccountId ::: --> '+resp.AccountId);
                var bidCustomerId = resp.AccountId;//component.get('v.oppData').AccountId;
                if(bidCustomerId != null && bidCustomerId != undefined){
                    helper.fetchContratcs(component, event, helper, bidCustomerId, '');
                }else{
                    component.set("v.contratcsList",null);
                }
                
            } else{
                console.log("Error "+JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);
    },
    keyCheckContracts:function (component, event, helper) {
        if (event.which == 13){ 
            var action = component.get('c.searchContracts');
            $A.enqueueAction(action);
            //this.searchContracts(component, event,helper);
        }
    },
    searchContracts: function(component, event, helper) {
        component.set("v.currentPage",1);
        var searchInput=component.find("cntInput").get("v.value");
        console.log('searchInput---'+searchInput);
        var checkToggle=component.find("tgleCntrct").get("v.checked");            
        var bidCustomerId=component.get("v.bidCustomerId");
        console.log('--bidCustomerId--'+bidCustomerId); 
        if(checkToggle==true){
            helper.fetchContratcs(component, event, helper, null, searchInput);
        }
        else{
            if(bidCustomerId != null && bidCustomerId != undefined){
                helper.fetchContratcs(component, event, helper, bidCustomerId, searchInput);
            }else{
                component.set("v.contratcsList",null);
            }
        }
        
    },
    closeModal :function(component,event, helper){
        component.set("v.isShowContracts",false);
    },
    showAllContracts: function(component, event, helper) {
        component.set("v.selectedRowsCount",0);
        component.set("v.currentPage",1);
        var searchInput=component.find("cntInput").get("v.value");
        console.log('searchInput---'+searchInput);
        var checkToggle=component.find("tgleCntrct").get("v.checked");
        console.log('--checkToggle--'+checkToggle); 
        var bCustomerId=component.get('v.bidCustomerId');
        console.log('--showAllContracts bCustomerId --'+bCustomerId);
        if(checkToggle==true){
            helper.fetchContratcs(component, event, helper, null, searchInput);
        }
        else{
            if(bCustomerId != null && bCustomerId != undefined){
                helper.fetchContratcs(component, event, helper, bCustomerId, searchInput);
            }else{
                component.set("v.PaginationList",null);
            }
        }
    },
    selectAllBoxes: function(component, event, helper) {
        console.log('check box : '+component.get("v.isSpinnerLoad")); 
        component.set("v.isSpinnerLoad",true);       
        var chk=component.find("chx"); 
        var checkvalue=component.find("selectAllId").get("v.value");
        console.log('checkvalue : '+checkvalue);
        console.log('check box : '+component.get("v.isSpinnerLoad"));  
        if(checkvalue==true){
            for(var i=0;i<chk.length;i++){
                chk[i].set("v.value",true);
            }
            component.set("v.isSpinnerLoad",false);
            console.log('check box : '+component.get("v.isSpinnerLoad"));
        }
        else{ 
            for(var i=0;i<chk.length;i++){
                chk[i].set("v.value",false);
            }
            component.set("v.isSpinnerLoad",false);
            console.log('check box : '+component.get("v.isSpinnerLoad"));
        }
        
    },
    checkboxSelected: function(component, event, helper) {
        //var checkvalue=component.find("chx").get("v.value");
        var selectedRecId = event.getSource().get("v.text");
        var selectedRec = event.getSource().get("v.value");
        //console.log('checkvalue : '+checkvalue);
        console.log('selectedRecId : '+selectedRecId);  
        console.log('selectedRec : '+selectedRec);   
    },
    selectAllCheckboxes: function(component, event, helper) {
        var selectedHeaderCheck = event.getSource().get("v.value");
        var updatedAllRecords = [];
        var updatedPaginationList = [];
        var listOfAllAccounts = component.get("v.listOfAllAccounts");
        var PaginationList = component.get("v.PaginationList");
        var selectedRowsCount = component.get("v.selectedRowsCount");
        var selectedContId = component.get('v.selectedContId');
        for (var i = 0; i < PaginationList.length; i++) {
            console.log('PaginationList length::'+PaginationList.length);
            if (selectedHeaderCheck == true) {
                if(!PaginationList[i].isChecked) {
                    PaginationList[i].isChecked = true;
                    selectedContId.push(PaginationList[i].Id);
                    selectedRowsCount++;
                }
            } else {
                if(PaginationList[i].isChecked && selectedContId.includes(PaginationList[i].Id)) {
                    selectedContId.pop(PaginationList[i].Id);
                }
                PaginationList[i].isChecked = false;
                selectedRowsCount--;
            }
            updatedPaginationList.push(PaginationList[i]);
        }
        component.set('v.selectedContId',selectedContId);
        if(selectedRowsCount > 0) component.set("v.selectedRowsCount",selectedRowsCount);
        else component.set("v.selectedRowsCount",0);
        //component.set("v.listOfAllAccounts", updatedAllRecords);
        component.set("v.PaginationList", updatedPaginationList);
    },
    checkboxSelect: function(component, event, helper) {
        // on each checkbox selection update the selected record count 
        var selectedRec = event.getSource().get("v.value");
        var selectedRecId = event.getSource().get("v.text");
        console.log('selectedRecId::'+selectedRecId);
        var selectedContId = component.get('v.selectedContId');
        var getSelectedNumber = component.get("v.selectedRowsCount");
        if (selectedRec == true) {
            if (!selectedContId.includes(selectedContId)) {
                getSelectedNumber++;
                selectedContId.push(selectedRecId);
            }
            
        } else {
            selectedContId.pop(selectedRecId);
            getSelectedNumber--;
            component.find("selectAllId").set("v.value", false);
        }
        component.set("v.selectedRowsCount", getSelectedNumber);
        component.set('v.selectedContId',selectedContId);
        // if all checkboxes are checked then set header checkbox with true   
        if (getSelectedNumber == component.get("v.totalRecordsCountCV")) {
            component.find("selectAllId").set("v.value", true);
        }
        helper.getPaginationList(component, helper);
    },
    navigation: function(component, event, helper) {
        var sObjectList = component.get("v.listOfAllAccounts");
        var end = component.get("v.endPage");
        var start = component.get("v.startPage");
        var pageSize = component.get("v.pageSizeCV");
        var whichBtn = event.getSource().get("v.name");
        // check if whichBtn value is 'next' then call 'next' helper method
        if (whichBtn == 'next') {
            component.set("v.currentPage", component.get("v.currentPage") + 1);
            helper.next(component, event, sObjectList, end, start, pageSize);
        }
        // check if whichBtn value is 'previous' then call 'previous' helper method
        else if (whichBtn == 'previous') {
            component.set("v.currentPage", component.get("v.currentPage") - 1);
            helper.previous(component, event, sObjectList, end, start, pageSize);
        }
        // check if whichBtn value is 'First' then call 'First' helper method
            else if (whichBtn == 'first') {
                var starting = pageSize;
                var lastPage = pageSize - 1;
                component.set("v.currentPage", 1);
                helper.previous(component, event, sObjectList, lastPage, starting, pageSize);
            }
        // check if whichBtn value is 'Last' then call 'Last' helper method
                else if (whichBtn == 'last') {
                    var tPageCount = component.get("v.totalPagesCount");
                    var starting = (tPageCount-2)* pageSize;
                    var lastPage = (tPageCount - 1)* pageSize - 1;
                    component.set("v.currentPage", component.get("v.totalPagesCount"));
                    helper.next(component, event, sObjectList, lastPage, starting, pageSize);
                }
        
        var curPage = component.get("v.currentPage");
        var totalPC = component.get("v.totalPagesCount");
        
        if(curPage == 1) component.set('v.isFirstPage', true);
        else component.set('v.isFirstPage', false);
        
        if(curPage == totalPC) component.set('v.isLastPage', true);
        else component.set('v.isLastPage', false);
        
        var elmnt = document.getElementById("tableDiv");
        elmnt.scrollTop=0;
        
        helper.getPaginationList(component, helper);
    },
    
    fetchProducts: function (component, event, helper) {
        var allRecords = component.get("v.listOfAllAccounts");
        var selectedRecords = [];
        var selectedCntrcts = [];
        for (var i = 0; i < allRecords.length; i++) {
            if (allRecords[i].isChecked) {
                selectedRecords.push(allRecords[i].Id);
                selectedCntrcts.push(allRecords[i].Phoenix_Contract_Number__c);
            }
        }
        console.log('selected contracts-->'+selectedCntrcts);
        var bidType = component.get("v.oppData.Bid_Type__c");
        console.log('bidType ::: --> '+bidType)
        if(bidType == 'Product Addition' || bidType == 'RFP'){
            component.set("v.loadingMessage",'Please Wait, Fetching Contract NPR Data to Opportunity Products...');
            component.set('v.isSpinnerLoad',true);
            
            var action = component.get("c.updateProdWithNRP");
            action.setParams({CustomerId : component.get("v.oppData.AccountId"),
                              contractIds : component.get("v.selectedContId"),
                              optyProd : JSON.stringify(component.get("v.totalMatchdata"))});
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS"){  
                    var resp = response.getReturnValue();
                    
                    component.set("v.isSpinnerLoad",false);
                    component.set("v.isShowContracts",false);
                    var toastEvent = $A.get("e.force:showToast");
                    if(resp.includes('ERROR')){
                        toastEvent.setParams({
                            "mode": 'sticky',
                            "title": "Error!",
                            "type":"error",
                            "message":resp
                        });
                    }
                    else{
                        toastEvent.setParams({
                            "mode": 'sticky',
                            "title": "SUCCESS!",
                            "type":"success",
                            "message":resp
                        });
                    }
                    toastEvent.fire(); 
                } else{
                    component.set("v.isSpinnerLoad",false);
                    console.log("Failed inserting Products -- > "+JSON.stringify(response.getError()));
                }
            });
            $A.enqueueAction(action);
        }
        
    },
    handleChange : function(component, event, helper) {
        var matchedRecords = component.get("v.totalMatchdata");
        var selectedProduct = component.find("ProductLookup");
        
        var existingIds = component.get("v.existingProducts");
        var selectedId ;
        var optyId ;
        
        if(selectedProduct != undefined && selectedProduct.length>0){
            selectedProduct.forEach(function(eachRecord){
                if(eachRecord.get("v.selectedRecordId")!=undefined && (!existingIds.includes('/'+eachRecord.get("v.selectedRecordId"))) ){
                    //selectedIds.push('/'+eachRecord.get("v.selectedRecordId"));
                    console.log('isExistingId-->'+existingIds.includes(eachRecord.get("v.selectedRecordId")))
                    selectedId = '/'+eachRecord.get("v.selectedRecordId"); 
                    optyId =eachRecord.get("v.styleClass");
                    component.set("v.selectedOptyProductId",optyId);
                    component.set("v.selectedProId",selectedId);
                }
                
            });
        }
        if(selectedId != undefined && selectedId != null)
            existingIds.push(selectedId);
        component.set("v.existingProducts",existingIds)
        console.log('existingIds-->'+existingIds)
        console.log('selected Id--->'+selectedId);
        if(selectedId != undefined && selectedId != null){
            var action = component.get("c.getProductDetails");
            action.setParams({
                productId : selectedId.replace('/',''),
                OptyProductId:optyId
            });
            action.setCallback(this,function(response){
                var state = response.getState();
                console.log('state-->'+state);
                if(state == 'SUCCESS'){
                    var wrapperObj = response.getReturnValue();
                    component.set("v.isShowPrdOtyAnnualData",wrapperObj.isPacksizeNotMatched);
                    component.set("v.annualUnitsData",wrapperObj);
                    
                }else{
                    console.log('Error--->');
                }
                
            });
            $A.enqueueAction(action);
            
        }
        
        /*var unmatchrecs= component.get('v.unmatchdata');
        //console.log('selectedId :: '+selectedId);
        unmatchrecs.forEach(function (record){
            if (record['Product__c'] && component.get("v.isRunOnce")){
                component.set("v.isSpinnerLoad",true);
            	console.log('unMatch ... ', record.Product__c);
                var action1 = component.get("c.handleSelPrdCol");
                action1.setParams({
                    OpportunityId:component.get('v.recordId'),
                    unmatchdata: JSON.stringify(unmatchrecs)
                });
                action1.setCallback(this, function(response){
                    if(response.getState() == 'SUCCESS'){
                        console.log('Success: '+response.getReturnValue());
                        //component.set("v.unmatchdata",JSON.parse(response.getReturnValue()));
                    } else{
                        console.log("Error "+JSON.stringify(response.getError()));
                    }
                component.set("v.isSpinnerLoad",false);
                component.set("v.isRunOnce",false);
                });
                $A.enqueueAction(action1);
                }
            
        });*/
    },
    
    updateAnnualUnitsInc : function(component, event, helper){
        component.set("v.isSpinnerLoad",true);
        component.set("v.loadingMessage",'Updating the record...');
        var action = component.get("c.updateOptyLineTotalAnnualUnits");
        action.setParams({
            optyProdList : JSON.stringify(component.get("v.inCorrectFormat"))
        });
        action.setCallback(this, function(response){
            if(response.getState() == 'SUCCESS'){
                console.log('UPDATED SUCCESSFULLY');
                component.set("v.isSpinnerLoad",false);
                component.set("v.loadingMessage",'');
            } 
            else{
                console.log("Error "+JSON.stringify(response.getError()));
                component.set("v.isSpinnerLoad",false);
                component.set("v.loadingMessage",'');
            }
        });
        $A.enqueueAction(action);
    },
    
    updateOptyLineFromTotAnVal : function(component, event, helper){
        component.set("v.isSpinnerLoad",true);
        component.set("v.loadingMessage",'Updating the record...');
        var noUsageList = component.get("v.noUsageList");
        noUsageList.forEach(function(item){
            if(item.Vision_Total_Annual_Units__c != undefined)
                console.log('annualUnits -- '+item.Vision_Total_Annual_Units__c);
        });
        
        var action = component.get("c.updateOptyLineTotalAnnualUnits");
        action.setParams({
            optyProdList : JSON.stringify(component.get("v.noUsageList"))
        });
        action.setCallback(this, function(response){
            if(response.getState() == 'SUCCESS'){
                var retList = response.getReturnValue();
                retList.forEach(function(item){
                    if(item.Vision_Total_Annual_Units__c != undefined)
                        console.log('annualUnits -- '+item.Vision_Total_Annual_Units__c);
                });
                component.set("v.noUsageList",retList);
                component.set("v.isSpinnerLoad",false);
            } 
            else{
                console.log("Error "+JSON.stringify(response.getError()));
                component.set("v.isSpinnerLoad",false);
            }
        });
        $A.enqueueAction(action);
    },
    
    updateOptyLineFromDupList : function(component, event, helper){
        console.log('updateOptyLineFromDupList');
        var wrapperList = component.get("v.duplicateProdList");
        var optyProdList = [];
        wrapperList.forEach(function(wrapObj){
            var prodList = wrapObj.prodOptyList;
            prodList.forEach(function(prodObj){
                optyProdList.push(prodObj);
            });
        });
        console.log('optyProdList.length ---> '+optyProdList.length);
        var action = component.get("c.updateOptyLineList");
        action.setParams({
            optyProdList : JSON.stringify(optyProdList)
        });
        action.setCallback(this, function(response){
            if(response.getState() == 'SUCCESS'){
                console.log('UPDATED SUCCESSFULLY');
            } 
            else{
                console.log("Error "+JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);
    },
    
    movePkgMisMatchToMatch : function(component, event, helper){
        component.set("v.loadingMessage",'Updating the Products...');
        var selectedId = event.currentTarget.dataset.id;
        var action = component.get("c.movePkgDisItemToMatchPrds");
        action.setParams({
            oppId:component.get('v.recordId'),
            optyProdId: selectedId
        });
        action.setCallback(this, function(response){
            if(response.getState() == 'SUCCESS'){
                console.log('Success: '+response.getReturnValue());
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": "success",
                    "title": "Success!",
                    "message": "Product has been Updated Successfully!"
                });
                toastEvent.fire();
                helper.showProducts(component, event, helper);
            } 
            else{
                console.log("Error "+JSON.stringify(response.getError()));
                component.set("v.isSpinnerLoad",false);
            }
            
        });
        $A.enqueueAction(action);
    },
    
    moveToMatch : function(component, event, helper){
        component.set("v.isSpinnerLoad",true);
        component.set("v.loadingMessage",'Updating the Products...');
        var selectedId = event.currentTarget.dataset.id;
        var action = component.get("c.moveDupToMatchPrds");
        action.setParams({
            oppId:component.get('v.recordId'),
            optyProdId: selectedId
        });
        action.setCallback(this, function(response){
            if(response.getState() == 'SUCCESS'){
                console.log('Success: '+response.getReturnValue());
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": "success",
                    "title": "Success!",
                    "message": "Product has been Updated Successfully!"
                });
                toastEvent.fire();
                helper.showProducts(component, event, helper);
            } 
            else{
                console.log("Error "+JSON.stringify(response.getError()));
                component.set("v.isSpinnerLoad",false);
            }
            
            //component.set("v.isRunOnce",false);
        });
        $A.enqueueAction(action);
    },
     moveToDiscrepancy : function(component, event, helper) {
         console.log('Hi');
          if(component.get("v.showDiscrepancyMsg") == false){
            component.set("v.showDiscrepancyMsg",true);
            component.set("v.discrepancyMessage","Do you want to move this product to Discrepancy?");
            var selectedId = event.getSource().get("v.value");
            console.log('selectedId :: '+selectedId);
            component.set("v.selMatchPrdId",selectedId);
        }
        else{
            var selectedId = component.get("v.selMatchPrdId");
            console.log('selectedId :: '+selectedId);
            if(selectedId){
                component.set("v.isSpinnerLoad",true);
                var action2 = component.get("c.moveToDiscrepancyPrds");
                action2.setParams({
                    //OpportunityId:component.get('v.recordId'),
                    prdOptyId: selectedId
                });
                action2.setCallback(this, function(response){
                    if(response.getState() == 'SUCCESS' && response.getReturnValue() == 'success'){
                        console.log('Success: '+response.getReturnValue());
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "type": "success",
                            "title": "Success!",
                            "message": "Successfully moved the Product to Discrepancy!"
                        });
                        toastEvent.fire();
                        helper.showProducts(component, event, helper);
                    } 
                    else{
                        console.log("Error "+JSON.stringify(response.getError()));
                    }
                    component.set("v.isSpinnerLoad",true);
                    //component.set("v.isRunOnce",false);
                });
                $A.enqueueAction(action2);
            }
            component.set("v.showDiscrepancyMsg",false);
        }

         
         
     },
    moveToUnMatchProceed : function(component, event, helper) {
         var selectedId = component.get("v.selPrdId");
         helper.moveToUnMatch(component,helper,selectedId);
    },
    
    moveToUnMatch : function(component, event, helper) {
         var selectedId = event.currentTarget.dataset.id;
        helper.moveToUnMatch(component,helper,selectedId);
       /* if(component.get("v.showConfirmation") == false){
            component.set("v.showConfirmation",true);
            component.set("v.confirmationMessage","Do you want to unmatch this product?");
            var selectedId = event.currentTarget.dataset.id;
            
            console.log('selectedId :: '+selectedId);
            component.set("v.selPrdId",selectedId);
        }
        else{
            var selectedId = component.get("v.selPrdId");
            console.log('selectedId :: '+selectedId);
            if(selectedId){
                component.set("v.isSpinnerLoad",true);
                var action2 = component.get("c.moveToUnMatchPrds");
                action2.setParams({
                    OpportunityId:component.get('v.recordId'),
                    prdOptyId: selectedId
                });
                action2.setCallback(this, function(response){
                    if(response.getState() == 'SUCCESS' && response.getReturnValue() == 'success'){
                        console.log('Success: '+response.getReturnValue());
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "type": "success",
                            "title": "Success!",
                            "message": "Successfully Unmatched the Product!"
                        });
                        toastEvent.fire();
                        helper.showProducts(component, event, helper);
                    } 
                    else{
                        console.log("Error "+JSON.stringify(response.getError()));
                    }
                    component.set("v.isSpinnerLoad",true);
                    //component.set("v.isRunOnce",false);
                });
                $A.enqueueAction(action2);
            }
            component.set("v.showConfirmation",false);
        }*/
    },
    moveToUnMatched : function(component, event, helper) {
           var selectedId=event.getSource().get("v.value");
           helper.moveToUnMatch(component,helper,selectedId);
        /*if(component.get("v.showConfirmation") == false){
            component.set("v.showConfirmation",true);
            component.set("v.confirmationMessage","Do you want to unmatch this product?");
            
          
               var selectedId=event.getSource().get("v.value");
          
            console.log('selectedId :: '+selectedId);
            component.set("v.selPrdId",selectedId);
        }
        else{
            var selectedId = component.get("v.selPrdId");
            console.log('selectedId :: '+selectedId);
            if(selectedId){
                component.set("v.isSpinnerLoad",true);
                var action2 = component.get("c.moveToUnMatchPrds");
                action2.setParams({
                    OpportunityId:component.get('v.recordId'),
                    prdOptyId: selectedId
                });
                action2.setCallback(this, function(response){
                    if(response.getState() == 'SUCCESS' && response.getReturnValue() == 'success'){
                        console.log('Success: '+response.getReturnValue());
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "type": "success",
                            "title": "Success!",
                            "message": "Successfully Unmatched the Product!"
                        });
                        toastEvent.fire();
                        helper.showProducts(component, event, helper);
                    } 
                    else{
                        console.log("Error "+JSON.stringify(response.getError()));
                    }
                    component.set("v.isSpinnerLoad",true);
                    //component.set("v.isRunOnce",false);
                });
                $A.enqueueAction(action2);
            }
            component.set("v.showConfirmation",false);
        }*/
    },
    handleInfoClick : function(component,event, helper){
        console.log("--handleInfoClick--"); 
        component.set("v.isShowPrdOptyInfo",true);
    },
    closePopUpModal: function (cmp, event, helper) {
        cmp.set('v.isShowPrdOptyInfo', false);
        cmp.set('v.showConfirmation', false);
        cmp.set("v.showConfirmation",false);
          cmp.set("v.showDiscrepancyMsg",false);
        
    },
    closePopUpModal1: function (component, event, helper) {
        component.set('v.isShowPrdOtyAnnualData', false);
        var selectedId = component.get('v.selectedProId');
        console.log('selected Id close---'+selectedId)
        var existingIds = component.get("v.existingProducts");
        var selectedProduct = component.find("ProductLookup");
        if(selectedProduct != undefined && selectedProduct.length>0){
            selectedProduct.forEach(function(eachRecord){
                if(eachRecord.get("v.selectedRecordId")!=undefined && eachRecord.get("v.selectedRecordId") == selectedId.replace('/','')){
                    eachRecord.set("v.selectedRecordId",null)
                    eachRecord.fireChanging(null);
                    
                }
                
            });
        }
        if(existingIds != undefined && existingIds.length>0){
            if(existingIds.includes(selectedId)){
                const index = existingIds.indexOf(selectedId);
                existingIds.splice(index, 1);
            }
        }
        component.set("v.existingProducts",existingIds);
        
        //cmp.set("v.showConfirmation",false);
        
    },
    
    //Added by Naseer starts here
    searchResults: function(component, event, helper){
        helper.searchHelperResults(component, event, helper);
    },
    onKeyUpHandler:function(component, event, helper) {
        
        /*window.setTimeout(
            $A.getCallback(function() {
                component.set("v.isSpinnerLoad",false);
                component.set("v.showProductsloading",false);
            }), 15000
        );*/
        
        let timer = setTimeout(
            $A.getCallback(
                helper.searchHelperResults.bind(component,event,helper)
            ), 10000) 
        component.set("v.timer", timer);
    },
    onKeyDownHandler:function(component) {
        let timer = component.get("v.timer");
        clearTimeout(timer);
        component.set("v.timer", null);
    },
    sortDecription:function(component, event, helper) {
        //var action = component.get("c.sortProducts");
        
        
    },
    sortName:function(component, event, helper) {
        console.log('recordId--->'+component.get("v.recordId"))
        var isAsc=component.get("v.isAsc");
        component.set("v.isAsc",!isAsc);
        var action = component.get('c.sortProducts');
        action.setParams({
            isAsc:!isAsc,
            fieldName:'Name',
            tabName:component.get("v.selTabId"),
            opptyId : component.get("v.recordId")
        });
        action.setCallback(this,function(response){
            var status = response.getState();
            if(status=='SUCCESS'){
                var mainWapper = response.getReturnValue();
                component.set("v.matchdata", mainWapper.matchedProducts);  
                //component.set("v.filteredMatchData", mainWapper.matchedProducts);  
                component.set("v.discdata", mainWapper.discrepanecyProducts);  
                mainWapper.discrepanecyProducts.forEach(function(eachrec){
                    console.log('eachrec Name-->'+eachrec.Name);                      
                });
                //component.set("v.filteredDescData", mainWapper.discrepanecyProducts);
                component.set("v.unmatchdata", mainWapper.unmatchedProducts);  
                // component.set("v.filteredUnMatchData", mainWapper.unmatchedProducts); 
                
            }
        });
        $A.enqueueAction(action);
    },
    sortByName: function(component, event, helper) {
        component.set("v.loadingMessage",'Sorting Opportunity Products...');
        component.set("v.isSpinnerLoad",true);
        component.set('v.showProductsloading', true);
        helper.sortBy(component,helper, "Name"); 
        var a=component.get("v.sortAsc");
        component.set("v.Name",a);
        
        component.set("v.isAsc",!a);
    },
    sortByNameUnMatched : function(component, event, helper){
        component.set("v.isSpinnerLoad",true);
        component.set('v.showProductsloading', true);
        helper.sortBy(component,helper, "Product_Description__c"); 
        component.set("v.isUnMatchAsc",component.get("v.isUnMatchAsc")?false:true);
    },
    sortByDescription: function(component, event, helper) {
        helper.sortBy(component,helper, "Product_Description__c"); 
        var a=component.get("v.isDescAsc");
        component.set("v.Product_Description__c",a);
        
        component.set("v.isDescAsc",a);
    },
    sortByUnmatchDescription: function(component, event, helper) {
        var field='Product_Description__c';
        var sortAsc = component.get("v.isAsc"),
            sortField = component.get("v.sortField"),
            currentTab = component.get("v.selTabId"),
            records = component.get("v.unmatchdata");
        sortAsc = sortField != field || !sortAsc;
        records.sort(function(a,b){
            var t1 = a[field] == b[field],
                t2 = (!a[field] && b[field]) || (a[field] < b[field]);
            return t1? 0: (sortAsc?-1:1)*(t2?1:-1);
        });
        component.set("v.isAsc", !sortAsc);
        component.set("v.sortField", field);
        component.set("v.unmatchdata",records)
        helper.paginateRecords(component,event);
        //component.set("v.isAsc",a);
    },
    onProductChange: function(component, event, helper) {
        var target = event.target;
        var rowIndex = target.getAttribute("data-row-index");
        //var titleName = event.getParam("title")
        console.log("Row No : " + rowIndex);
        //console.log("NAme : " + JSON.stringify(target));
    },
    saveOptyProduct: function(component, event, helper) {
        component.set('v.showProductsloading', true);
        component.set("v.isSpinnerLoad",true);
        component.set("v.isShowPrdOtyAnnualData",false);
        var selectedId = component.get("v.selectedOptyProductId");
        var warpperData = component.get("v.annualUnitsData");
        var action = component.get("c.saveProductData");
        action.setParams({
            wrapperObj : JSON.stringify(warpperData),optyId : component.get("v.recordId")
        });
        //action.setParams({ optyProductId : selectedId, expectedAnnualUnits : warpperData.expectedAnnualUnits,
        //    optyId : component.get("v.recordId"), productId : warpperData.productId });
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state =='SUCCESS'){
                var unMatchedRecords = response.getReturnValue();
                //component.set("v.unmatchdata",unMatchedRecords);
                component.set("v.totalUnmatchdata",unMatchedRecords);
                helper.paginateRecords(component,event);
                component.set("v.isSpinnerLoad",false);
                component.set('v.showProductsloading', false);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type":"success",
                    "title": "Success!",
                    "message": "The records have been moved to Matched Products successfully."
                });
                toastEvent.fire();
                
            }
        });
        $A.enqueueAction(action);
    },
    updateListOnChange : function(component, event, helper){
        //helper.showProducts(component, event, helper);
        //var rowNum = event.getParam("rowNumber");
        var prodStatus = event.getParam("prodStatus");
        var optyProdObj = event.getParam("optyProdObj");
        if(prodStatus == 'Unmatched'){
            var totalUnmatched = component.get("v.totalUnmatchdata");
            var newUnmatchList = [];
            totalUnmatched.forEach(function(item){
                if(optyProdObj.Id != item.Id)
                    newUnmatchList.push(item);
            });
            component.set("v.totalUnmatchdata",newUnmatchList);
            var totalMatchedData = component.get("v.totalMatchdata");
            totalMatchedData.push(optyProdObj);
            var unmatchedRowsCount = component.get("v.unmatchedRowsCount");
            var matchedRowsCount = component.get("v.matchedRowsCount");
            unmatchedRowsCount = parseInt(unmatchedRowsCount)-1;
            matchedRowsCount = parseInt(matchedRowsCount)+1;
            component.set("v.unmatchedRowsCount",unmatchedRowsCount);
            component.set("v.matchedRowsCount",matchedRowsCount);
        }
        else{
            var inCorrectFormat = component.get("v.inCorrectFormat");
            var inCorectNewList = [];
            var discNewList = [];
            inCorrectFormat.forEach(function(item){
                if(optyProdObj.Id != item.Id)
                    inCorectNewList.push(item);
            });
            var totalDiscData = component.get("v.totalDiscdata");
            inCorrectFormat.forEach(function(item){
                if(optyProdObj.Id != item.Id)
                    discNewList.push(item);
            });
            component.set("v.totalDiscdata",discNewList);
            //inCorrectFormat.splice(rowNum, 1);
            component.set("v.inCorrectFormat",inCorectNewList);
            inCorrectFormat = component.get("v.inCorrectFormat");
            var totalMatchedData = component.get("v.totalMatchdata");
            totalMatchedData.push(optyProdObj);
            var discRowsCount = component.get("v.discRowsCount");
            var matchedRowsCount = component.get("v.matchedRowsCount");
            discRowsCount = parseInt(discRowsCount)-1;
            matchedRowsCount = parseInt(matchedRowsCount)+1;
            component.set("v.discRowsCount",discRowsCount);
            component.set("v.matchedRowsCount",matchedRowsCount);
            //component.set("v.autoCalcUnits",true);
        }
          helper.showProducts(component, event, helper);
        
        var action = component.get("c.sortByName");
        var a = component.get('c.sortByName');
        $A.enqueueAction(a);
    },
    handleCheckboxEvent : function(component, event, helper){
        var productOpty = event.getParam("productOpty");
        console.log('productOpty======'+JSON.stringify(productOpty));
          console.log('productOpty=RAD Units====='+productOpty["Vision_Proposed_RAD_Units__c"]);
        var prodOptyIdList=component.get("v.prodOptyIdList");
        var productOptySelected=[];
        var prodOptyMap=new Map();
        if(component.get("v.prodOptyMap")!=null){
            prodOptyMap=  component.get("v.prodOptyMap");
        }
        if(productOpty["isFromInputChange"]){
        if(prodOptyMap.has(productOpty["Id"])){
                prodOptyMap.set(productOpty["Id"],productOpty);
                
          }
         }
        
        else{
            //productOpty["isFromInputChange"]){
        if(productOpty["isSelected"]){
            console.log('if condition');
            prodOptyMap.set(productOpty["Id"],productOpty);
            prodOptyIdList.push(productOpty["Id"]);
        }
        
        else{
            console.log('else condition');
            
            const objIdIndex = prodOptyIdList.indexOf(productOpty["Id"]);
            if (objIdIndex > -1) {
                prodOptyIdList.splice(objIdIndex, 1);
            }
            prodOptyMap.delete(productOpty["Id"]);
            
            
            
        }
        }
        
        for(var i=0; i<prodOptyIdList.length; i++){
             console.log('prodOptyMap==has key===='+prodOptyMap.has(prodOptyIdList[i]));
            if(prodOptyMap.has(prodOptyIdList[i])){
                productOptySelected.push(prodOptyMap.get(prodOptyIdList[i]));
                
            }
        }
        
        component.set("v.prodOptyMap",prodOptyMap);
        component.set("v.prodOptyIdList",prodOptyIdList);
        component.set("v.productOptySelected",productOptySelected);
        
        
        console.log('prodOptyMap======'+prodOptyMap.size);
        console.log('productOptySelected======'+productOptySelected.length);
        console.log('prodOptyIdList=length====='+prodOptyIdList.length);
        console.log('prodOptyIdList======'+prodOptyIdList);
        
    },
    moveToMatchHandler: function(component, event, helper){
        component.set("v.isSpinnerLoad",true);
        
        var action = component.get("c.updateProductOpportunity");
        action.setParams({
            prodOptyIds : component.get("v.prodOptyIdList"),
            prodOptyData:JSON.stringify(component.get("v.productOptySelected"))
            //prodOptyData:component.get("v.productOptySelected")
        });
        
        action.setCallback(this,function(response){
            
            var state = response.getState();
            if(state =='SUCCESS'){
                var msg = response.getReturnValue();
                
                if(msg!=null){
                    
                    component.set("v.prodOptyIdList",[]);
                    var newMap=new Map();
                    component.set("v.prodOptyMap",newMap);
                    helper.showProducts(component, event, helper);
                    component.set("v.isSpinnerLoad",false);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type":"success",
                        "title": "Success!",
                        "message": "Successfully moved the Product to Matched Products!"
                    });
                    toastEvent.fire();
                }
                
            }
            component.set("v.isSpinnerLoad",true);
        });
        
        $A.enqueueAction(action);
        
        
    },
    showHideUploadedItems : function(component, event, helper){
        component.set("v.hideUploadedItems",component.get("v.hideUploadedItems")?false:true);
    },
     showHideUploadedItemsUnMatch : function(component, event, helper){
        component.set("v.hideUploadedItemsUnMatch",component.get("v.hideUploadedItemsUnMatch")?false:true);
    },
    showHideUploadedDiscrepancy : function(component, event, helper){
        component.set("v.hideUploadedDiscrepancy",component.get("v.hideUploadedDiscrepancy")?false:true);
    },
    showHideDrlDiscrepancy : function(component, event, helper){
        component.set("v.hideDrlItems",component.get("v.hideDrlItems")?false:true);
    },
    changeMatchedViewItems : function(component, event, helper){
        console.log('value --> '+component.get("v.isViewAllMatched"));
    },
    mergeUnitsOfOtherDupList : function(component, event, helper){
        var selectedRowId = event.currentTarget.dataset.id;
        console.log('selectedRowId --> '+selectedRowId);
        var otherDupProdList = component.get("v.otherDupProdList");
        var selectedDupList = otherDupProdList[selectedRowId].prodOptyList;
        var mergeObj = {};
        mergeObj.descType = 'OtherDupItem';
        mergeObj.ind = selectedRowId;
        mergeObj.selectedDupList = selectedDupList;
        mergeObj.prodName = selectedDupList[0].Name;
        component.set("v.mergeObj",mergeObj);
        component.set("v.showMergePopup",true);
    },
    mergeUnitsOfDupList : function(component, event, helper){
        var selectedRowId = event.currentTarget.dataset.id;
        console.log('selectedRowId --> '+selectedRowId);
        var duplicateProdList = component.get("v.duplicateProdList");
        var selectedDupList = duplicateProdList[selectedRowId].prodOptyList;
        var mergeObj = {};
        mergeObj.descType = 'OtherDupItem';
        mergeObj.ind = selectedRowId;
        mergeObj.selectedDupList = selectedDupList;
        mergeObj.prodName = selectedDupList[0].Name;
        component.set("v.mergeObj",mergeObj);
        component.set("v.showMergePopup",true);
    },
    closeMergePopup : function(component, event, helper){
        component.set("v.showMergePopup",false);
    }
})