({
	showProducts: function (component, event, helper) {
        component.set('v.showProductsloading', true);
        let recordId = component.get("v.recordId");
        var action = component.get("c.productCountRecordsDetailPage");
        action.setParams({
            "OpportunityId": recordId
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            console.log('state : ' + state);
            if (state === "SUCCESS") {
                component.set('v.showProductsloading', false);
                var wrapperObject = JSON.parse(response.getReturnValue());
                console.log('--wrapperObject--'+JSON.stringify(wrapperObject));
                component.set("v.TotalRecords", wrapperObject.totalRecordsInfo.totalRecCount);
                component.set("v.matchedRowsCount", wrapperObject.totalRecordsInfo.matchedRecCount);
                component.set("v.unmatchedRowsCount", wrapperObject.totalRecordsInfo.unmatchedRecCount);
                component.set("v.discRowsCount", wrapperObject.duplicateRecords.length);
                component.set("v.infoTable", wrapperObject.recsDetailedInfo);
                console.log('matchedRowsCount onLoad-->'+wrapperObject.totalRecordsInfo.matchedRecCount);
                var noOfMatchedPages = wrapperObject.totalRecordsInfo.matchedRecCount/100;
                console.log('noOfMatchedPages -->'+noOfMatchedPages);
                var pageNumbers = [];
                var j=1;
                for(var i=0;i<noOfMatchedPages;i++){
                    pageNumbers.push(j);
                    j++;
                }
                component.set("v.pageNumberListMatched",pageNumbers);
                
                var noOfUnmatchedPages = wrapperObject.totalRecordsInfo.unmatchedRecCount/100;
                console.log('noOfUnmatchedPages -->'+noOfUnmatchedPages);
                var pageNumbersUnmat = [];
                j=1;
                for(var i=0;i<noOfUnmatchedPages;i++){
                    pageNumbersUnmat.push(j);
                    j++;
                }
                component.set("v.pageNumberListUnmatched",pageNumbersUnmat);

                var noOfDiscPages = wrapperObject.duplicateRecords.length/100;
                console.log('noOfDiscPages -->'+noOfDiscPages);
                var pageNumbersDisc = [];
                j=1;
                for(var i=0;i<noOfDiscPages;i++){
                    pageNumbersDisc.push(j);
                    j++;
                }
                component.set("v.pageNumberListDiscrepancy",pageNumbersDisc);
                
                wrapperObject.matchedRecords.forEach(function (record) {
                    record.Product__c = '/' + record.Product__c;
                    record.ProductName = record.Name;
                });
                for(var i=0; i<wrapperObject.matchedRecords.length; i++){
                    if('GSN__c' in wrapperObject.matchedRecords[i]){
                    } else{
                        wrapperObject.matchedRecords[i].noGSN = true;
                    }
                    if('GPI_Generic_Product_Identifier__c' in wrapperObject.matchedRecords[i]){
                    } else{
                        wrapperObject.matchedRecords[i].noGPI = true;
                    }
                    if('SKU_Number__c' in wrapperObject.matchedRecords[i]){
                    } else{
                        wrapperObject.matchedRecords[i].noSKU = true;
                    }
                    if('NDC_11__c' in wrapperObject.matchedRecords[i]){
                    } else{
                        wrapperObject.matchedRecords[i].noNDC = true;
                    }
                    if('GCN_Generic_Code_Number__c' in wrapperObject.matchedRecords[i]){
                    } else{
                        wrapperObject.matchedRecords[i].noGCN = true;
                    }
                }
                for(var i=0; i<wrapperObject.unMatchedRecords.length; i++){
                    if('GSN__c' in wrapperObject.unMatchedRecords[i]){
                    } else{
                        wrapperObject.unMatchedRecords[i].noGSN = true;
                    }
                    if('GPI_Generic_Product_Identifier__c' in wrapperObject.unMatchedRecords[i]){
                    } else{
                        wrapperObject.unMatchedRecords[i].noGPI = true;
                    }
                    if('SKU_Number__c' in wrapperObject.unMatchedRecords[i]){
                    } else{
                        wrapperObject.unMatchedRecords[i].noSKU = true;
                    }
                    if('NDC_11__c' in wrapperObject.unMatchedRecords[i]){
                    } else{
                        wrapperObject.unMatchedRecords[i].noNDC = true;
                    }
                    if('GCN_Generic_Code_Number__c' in wrapperObject.unMatchedRecords[i]){
                    } else{
                        wrapperObject.unMatchedRecords[i].noGCN = true;
                    }
                }
                var dupPrdList = [];
                wrapperObject.duplicateRecords.forEach(function (record) {
                    dupPrdList.push(record.Product__c);
                });
                dupPrdList = this.findRepeatingProducts(dupPrdList, dupPrdList.length);
                //console.log('--dupPrdList--'+dupPrdList);
                var noUsageList = [];
                var prodMap = new Map();
                var prodListForMap = [];
                
                for(var i=0; i<wrapperObject.duplicateRecords.length; i++){
                    if(!prodListForMap.includes(wrapperObject.duplicateRecords[i].Product__c))
                        prodListForMap.push(wrapperObject.duplicateRecords[i].Product__c);
                    if('GSN__c' in wrapperObject.duplicateRecords[i]){
                    } else{
                        wrapperObject.duplicateRecords[i].noGSN = true;
                    }
                    if('GPI_Generic_Product_Identifier__c' in wrapperObject.duplicateRecords[i]){
                    } else{
                        wrapperObject.duplicateRecords[i].noGPI = true;
                    }
                    if('SKU_Number__c' in wrapperObject.duplicateRecords[i]){
                    } else{
                        wrapperObject.duplicateRecords[i].noSKU = true;
                    }
                    if('NDC_11__c' in wrapperObject.duplicateRecords[i]){
                    } else{
                        wrapperObject.duplicateRecords[i].noNDC = true;
                    }
                    if('GCN_Generic_Code_Number__c' in wrapperObject.duplicateRecords[i]){
                    } else{
                        wrapperObject.duplicateRecords[i].noGCN = true;
                    }
                    if('Vision_Total_Annual_Units__c' in wrapperObject.duplicateRecords[i]){
                    } else{
                        wrapperObject.duplicateRecords[i].noUsage = true;
                        //noUsageList.push(wrapperObject.duplicateRecords[i]);
                    }
                    if( wrapperObject.duplicateRecords[i].Vision_Total_Annual_Units__c == null 
                       || wrapperObject.duplicateRecords[i].Vision_Total_Annual_Units__c < 0)
                        wrapperObject.duplicateRecords[i].noUsage = true;
                    //console.log('---wrapperObject Product ---'+wrapperObject.duplicateRecords[i].Product__c);
                    if(dupPrdList.includes(wrapperObject.duplicateRecords[i].Product__c)){
                        wrapperObject.duplicateRecords[i].isDuplicate = true;
                    }
                    if(!prodMap.has(wrapperObject.duplicateRecords[i].Product__c))
                        prodMap.set(wrapperObject.duplicateRecords[i].Product__c,[]);
                    prodMap.get(wrapperObject.duplicateRecords[i].Product__c).push(wrapperObject.duplicateRecords[i]);
                    //if(wrapperObject.duplicateRecords[i].Vision_inActive__c)
                        //inActiveList.push(wrapperObject.duplicateRecords[i]);
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
                            if((!prodOptyList[0].Is_NDC_Matched__c && !prodOptyList[0].Is_SKU_Matched__c && !prodOptyList[0].Is_GCN_Pack_Size_Matched__c && !prodOptyList[0].Is_GSN_Pack_Size_Matched__c && !prodOptyList[0].Is_GPI_Pack_Size_Matched__c) && 
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
                            if((!prodOptyList[0].Is_NDC_Matched__c && !prodOptyList[0].Is_SKU_Matched__c && !prodOptyList[0].Is_GCN_Pack_Size_Matched__c && !prodOptyList[0].Is_GSN_Pack_Size_Matched__c && !prodOptyList[0].Is_GPI_Pack_Size_Matched__c) && 
                               (prodOptyList[0].Is_GCN_Matched__c || prodOptyList[0].Is_GSN_Matched__c || prodOptyList[0].Is_GPI_Matched__c))
                                otherDupProdList.push(itemObj);
                            else
                                duplicateProdList.push(itemObj);
                        }
                            /*else if((prodOptyList[0].Vision_Total_Annual_Units__c == null || prodOptyList[0].Vision_Total_Annual_Units__c == undefined
                                     || prodOptyList[0].Vision_Total_Annual_Units__c == 0) 
                                    && !prodOptyList[0].Vision_inActive__c && !prodOptyList[0].Vision_Bid_on_Highest_Pack_Size__c && !prodOptyList[0].Vision_Bid_on_Alternative_Pack_Size__c)
                                noUsageList.push(prodOptyList[0]);*/
                                else if(!prodOptyList[0].Vision_inActive__c && (prodOptyList[0].Is_GCN_Matched__c || prodOptyList[0].Is_GSN_Matched__c || prodOptyList[0].Is_GPI_Matched__c))
                                    inCorrectFormat.push(prodOptyList[0]);
                                    else if(prodOptyList[0].Vision_Bid_on_Highest_Pack_Size__c)
                                        bidonhighestpackList.push(prodOptyList[0]);
                                        else if(prodOptyList[0].Vision_Bid_on_Alternative_Pack_Size__c)
                                            bidonalterpackList.push(prodOptyList[0]);
                    }
                });
                component.set("v.inActiveList",inActiveList);
                component.set("v.noUsageList",noUsageList);
                component.set("v.bidonhighestpackList",bidonhighestpackList);
                component.set("v.bidonalterpackList",bidonalterpackList);
                component.set("v.duplicateProdList",duplicateProdList);
                component.set("v.otherDupProdList",otherDupProdList);
                component.set("v.totalMatchdata", wrapperObject.matchedRecords);
                component.set("v.totalUnmatchdata", wrapperObject.unMatchedRecords);
                component.set("v.totalDiscdata", wrapperObject.duplicateRecords);
                component.set("v.inCorrectFormat",inCorrectFormat);
                
                /* added by Jogarao*/
                var matchedProducts = wrapperObject.matchedRecords;
                var unmatchedRecords = wrapperObject.unMatchedRecords;
                var existingProductIds = [];
                existingProductIds.push('testId');
                var productsExclQury= '( IsActive = true' ;
                if(matchedProducts != undefined && matchedProducts.length>0){
                    matchedProducts.forEach(function(optyProduct){
                        existingProductIds.push(optyProduct.Product__c);
                        var productId = optyProduct.Product__c.replace('/','')
                        productsExclQury += ' AND Id != ' + '\''+productId+'\'';
                    })
                    productsExclQury += ' )';
                }
                component.set("v.productsExclQury",productsExclQury);
                if(unmatchedRecords != undefined && unmatchedRecords.length>0){
                     unmatchedRecords.forEach(function(optyProduct){
                         if(optyProduct.Product__c != undefined && optyProduct.Product__c!= null)
                         	existingProductIds.push(optyProduct.Product__c);
                    })
                }
                component.set("v.existingProducts",existingProductIds);
                //Added by Naseer
                component.set("v.allmatchdata", wrapperObject.matchedRecords);
                component.set("v.allunmatchdata", wrapperObject.unMatchedRecords);
                component.set("v.alldiscrepencydata", wrapperObject.duplicateRecords);
                //Added by Naseer
                
                //component.set('v.matchdata', wrapperObject.matchedRecords);
                //component.set('v.unmatchdata', wrapperObject.unMatchedRecords);
                
                component.set("v.stageName", wrapperObject.stageName);
                component.set("v.AccTemplate", wrapperObject.accTemplate);
                component.set("v.accId",wrapperObject.accId);
                console.log('AccTemplate ---> '+wrapperObject.accTemplate);
                //console.log('Matched Data::: '+JSON.stringify(wrapperObject.matchedRecords));
                //console.log('Unmatched Data::: '+JSON.stringify(wrapperObject.unMatchedRecords));
                if(wrapperObject.accTemplate == 'Direct' || wrapperObject.accTemplate == 'Direct and Indirect' || wrapperObject.accTemplate == 'Net Indirect Pricing'){
            		component.set("v.isShowDirectUnits",true);
            	}
                if(wrapperObject.accTemplate == 'Indirect' || wrapperObject.accTemplate == 'Direct and Indirect' || wrapperObject.accTemplate == 'Net Indirect Pricing' 
                   || wrapperObject.accTemplate == 'Walgreens' || wrapperObject.accTemplate == 'ABC Progen' || wrapperObject.accTemplate == 'Costco' || wrapperObject.accTemplate == 'Sams Club' 
                   || wrapperObject.accTemplate == 'Government Pricing' || wrapperObject.accTemplate == 'Humana Indirect retail' || wrapperObject.accTemplate == 'Humana Indirect CII'){
                	component.set("v.isShowInDirectUnits",true);
            	}
                component.set("v.isSpinnerLoad",false);
                helper.paginateRecords(component,event);
            }
            else {
                component.set('v.showProductsloading', false);
                console.log("failed " + JSON.stringify(response.getError()));
                component.set("v.isSpinnerLoad",false);
            }
        });
        $A.enqueueAction(action);

    },
    
    paginateRecords : function(component, event){
        console.log("--paginateRecords--");
        var searchKey = component.get("v.searchText");
        component.set('v.showProductsloading', true);
        console.log("--Loader--"+component.get('v.showProductsloading')); 
        var selectedTabName = component.get("v.selTabId");
        console.log("--selectedTabName--"+selectedTabName); 
        if(selectedTabName == 'matchPrds'){
            
            var selectedPageNum = component.get("v.selectedPageNumberMatched");
            var matchedRecs = (searchKey!=undefined && searchKey!='' && searchKey.length > 4) ? component.get("v.filteredMatchData"):component.get("v.totalMatchdata");
            console.log('matchedRecs.length ---> '+matchedRecs.length);
            var selectedList = matchedRecs.slice((selectedPageNum-1)*100,selectedPageNum*100);
            component.set('v.matchdata',selectedList);
            component.set('v.showProductsloading', false);
            //document.getElementById("content").scrollIntoView(true);
            //window.scrollTo(0, 0);
        }
        else if(selectedTabName == 'unmatchPrds'){
            console.log("--inside unmatchPrds--"); 
            var selectedPageNum = component.get("v.selectedPageNumberUnmatched");
            var unmatchedRecs = (searchKey!=undefined && searchKey!='' && searchKey.length > 4) ? component.get("v.filteredUnMatchData"): component.get("v.totalUnmatchdata");
            console.log('unmatchedRecs length --> '+unmatchedRecs.length);
            var selectedList = unmatchedRecs.slice((selectedPageNum-1)*100,selectedPageNum*100);
            component.set('v.unmatchdata',selectedList);
            
            component.set('v.showProductsloading', false);
        }
        else if(selectedTabName == 'discPrds'){
            var selectedPageNum = component.get("v.selectedPageNumberDiscrepancy");
            var discRecs = (searchKey!=undefined && searchKey!='' && searchKey.length > 4) ? component.get("v.filteredDescData"):component.get("v.totalDiscdata");
            var selectedList = discRecs.slice((selectedPageNum-1)*100,selectedPageNum*100);
            component.set('v.discdata',selectedList);
            component.set('v.showProductsloading', false);
        }
        
        console.log("--Loader--"+component.get('v.showProductsloading')); 
    },
    
    saveOptyLineItems: function (component, event, helper) {
        console.log('--saveOptyLineItems--');
        component.set('v.showProductsloading', true);
        var action = component.get("c.saveOptyProducts");
        //var matchRecords = component.get("v.matchdata");
        //var unmatchRecords = component.get("v.unmatchdata");
        var matchRecords = component.get("v.totalMatchdata");
        var unmatchRecords = component.get("v.totalUnmatchdata");
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
    mapUnMatchRecords: function (component, event, helper) {
        component.set('v.showProductsloading', true);
        var action = component.get("c.moveUnmatchedProducts");//mapUnmatchedProducts
        var matchRecords = component.get("v.totalMatchdata");
        var unmatchRecords = component.get("v.totalUnmatchdata");
        action.setParams({
            "matchData": JSON.stringify(matchRecords),
            "unmatchData": JSON.stringify(unmatchRecords)
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            console.log('state : ' + state);
            if (state === "SUCCESS") {
                var wrapperObject = JSON.parse(response.getReturnValue());
                //component.set("v.TotalRecords", wrapperObject.totalRecordsInfo.totalRecCount);
                component.set("v.matchedRowsCount", wrapperObject.totalRecordsInfo.matchedRecCount);
                component.set("v.unmatchedRowsCount", wrapperObject.totalRecordsInfo.unmatchedRecCount);
                var noOfMatchedPages = wrapperObject.totalRecordsInfo.matchedRecCount/100;
                var pageNumbers = [];
                var j=1;
                for(var i=0;i<noOfMatchedPages;i++){
                    pageNumbers.push(j);
                    j++;
                }
                component.set("v.pageNumberListMatched",pageNumbers);
                
                var noOfUnmatchedPages = wrapperObject.totalRecordsInfo.unmatchedRecCount/100;
                var pageNumbersUnmat = [];
                j=1;
                for(var i=0;i<noOfUnmatchedPages;i++){
                    pageNumbersUnmat.push(j);
                    j++;
                }
                component.set("v.pageNumberListUnmatched",pageNumbersUnmat);
                
                wrapperObject.matchedRecords.forEach(function (record) {
                    record.Product__c = '/' + record.Product__c;
                    record.ProductName = record.Name;
                });
                for(var i=0; i<wrapperObject.matchedRecords.length; i++){
                    if('GSN__c' in wrapperObject.matchedRecords[i]){
                    } else{
                        wrapperObject.matchedRecords[i].noGSN = true;
                    }
                    if('GPI_Generic_Product_Identifier__c' in wrapperObject.matchedRecords[i]){
                    } else{
                        wrapperObject.matchedRecords[i].noGPI = true;
                    }
                    if('SKU_Number__c' in wrapperObject.matchedRecords[i]){
                    } else{
                        wrapperObject.matchedRecords[i].noSKU = true;
                    }
                    if('NDC_11__c' in wrapperObject.matchedRecords[i]){
                    } else{
                        wrapperObject.matchedRecords[i].noNDC = true;
                    }
                    if('GCN_Generic_Code_Number__c' in wrapperObject.matchedRecords[i]){
                    } else{
                        wrapperObject.matchedRecords[i].noGCN = true;
                    }
                }
                for(var i=0; i<wrapperObject.unMatchedRecords.length; i++){
                    if('GSN__c' in wrapperObject.unMatchedRecords[i]){
                    } else{
                        wrapperObject.unMatchedRecords[i].noGSN = true;
                    }
                    if('GPI_Generic_Product_Identifier__c' in wrapperObject.unMatchedRecords[i]){
                    } else{
                        wrapperObject.unMatchedRecords[i].noGPI = true;
                    }
                    if('SKU_Number__c' in wrapperObject.unMatchedRecords[i]){
                    } else{
                        wrapperObject.unMatchedRecords[i].noSKU = true;
                    }
                    if('NDC_11__c' in wrapperObject.unMatchedRecords[i]){
                    } else{
                        wrapperObject.unMatchedRecords[i].noNDC = true;
                    }
                    if('GCN_Generic_Code_Number__c' in wrapperObject.unMatchedRecords[i]){
                    } else{
                        wrapperObject.unMatchedRecords[i].noGCN = true;
                    }
                }
                component.set("v.totalMatchdata", wrapperObject.matchedRecords);
                component.set("v.totalUnmatchdata", wrapperObject.unMatchedRecords);
                component.set("v.isSpinnerLoad",false);
                this.paginateRecords(component,event);
                /*var wrapperObject = JSON.parse(response.getReturnValue());
                console.log('state : ' + JSON.stringify(wrapperObject));
                component.set("v.matchedRowsCount", wrapperObject.totalRecordsInfo.matchedRecCount);
                component.set("v.unmatchedRowsCount", wrapperObject.totalRecordsInfo.unmatchedRecCount);
                wrapperObject.matchedRecords.forEach(function (record) {
                    record.Product__c = '/' + record.Product__c;
                    record.ProductName = record.Name;
                });
                component.set('v.matchdata', wrapperObject.matchedRecords);
                component.set('v.unmatchdata', wrapperObject.unMatchedRecords);
                component.set("v.stageName", wrapperObject.stageName);
                component.set("v.selectedUnmatchedRowsList", []);
                component.set('v.selectedUnmatchedRowsCount', 0);*/
                component.set('v.showProductsloading', false);
            }
            else {
                component.set('v.showProductsloading', false);
                console.log("Failed Response" + JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);

    },
    fetchContratcs : function(component, event, helper, bCustomerId, searchInput) {
        component.set('v.isSpinnerLoad',true);       
        //var message = event.getParam("message");
        console.log('bCustomerId::'+bCustomerId);
        var templateType = component.get("v.templateType");
        var action = component.get("c.getContracts");
        action.setParams({
            customerID: bCustomerId,
            searchInput: searchInput,
            templateType:templateType
        });
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                var responseList = response.getReturnValue();
                console.log('---Contracts responseList---'+responseList.length);
                var selectedContId = component.get('v.selectedContId');
                console.log('selectedContId::'+selectedContId.length);
                var resList = [];
                for (var i = 0; i < responseList.length; i++) {
                    var rec = responseList[i]
                    if (selectedContId.includes(rec.Id)) {
                        //console.log('rec.Id Inside::'+rec.Id);
                        rec.isChecked = true;
                    }
                    resList.push(rec);
                }
                
                component.set('v.allDataCV', resList);
                component.set('v.filteredData', resList);
                component.set('v.isShowContracts', true);
                this.doInitHelper(component, resList,helper);
                component.set('v.isSpinnerLoad',false);
            }
        });
        $A.enqueueAction(action);
    },
    doInitHelper : function(component,responseList,helper){ 
        if(responseList.length > 0){
            component.set('v.listOfAllAccounts', responseList);
            var pageSize = component.get("v.pageSizeCV");
            var totalRecordsList = responseList;
            var totalLength = totalRecordsList.length ;
            component.set("v.totalRecordsCountCV", totalLength);
            component.set("v.startPage",0);
            component.set("v.endPage",pageSize-1);
            
            var PaginationLst = [];
            for(var i=0; i < pageSize; i++){
                if(component.get("v.listOfAllAccounts").length > i){
                    PaginationLst.push(responseList[i]);    
                } 
            }
            component.set('v.PaginationList', PaginationLst);
            this.getPaginationList(component, helper);
            component.set("v.selectedRowCount" , 0);
            //use Math.ceil() to Round a number upward to its nearest integer
            component.set("v.totalPagesCount", Math.ceil(totalLength / pageSize));    
        }else{
            // if there is no records then display message
            component.set('v.PaginationList', null);
            component.set("v.bNoRecordsFound" , true);
        } 
        component.set('v.isFirstPage', true);
        this.generatePageList(component, 1, true);
    },
    
    /*
     * this function generate page list
     * */
    generatePageList: function (component, pageNumber, isFromContractView) {
        pageNumber = parseInt(pageNumber);
        var pageList = [];
        var totalPages = isFromContractView ? component.get("v.totalPagesCount") : component.get("v.totalPages");
        console.log('isFromContractView---->'+isFromContractView);
        console.log('pages count---->'+component.get("v.totalPages"));
        if (totalPages > 1) {
            if (totalPages <= 10) {
                var counter = 2;
                for (; counter < (totalPages); counter++) {
                    pageList.push(counter);
                }
            } else {
                if (pageNumber < 5) {
                    pageList.push(2, 3, 4, 5, 6);
                } else {
                    if (pageNumber > (totalPages - 5)) {
                        pageList.push(totalPages - 5, totalPages - 4, totalPages - 3, totalPages - 2, totalPages - 1);
                    } else {
                        pageList.push(pageNumber - 2, pageNumber - 1, pageNumber, pageNumber + 1, pageNumber + 2);
                    }
                }
            }
        }
        component.set("v.pageList", pageList);
    },
    getPaginationList: function (component, helper) {
        var PaginationList = component.get("v.PaginationList");
        var allRecordsSelected = true;
        for (var i = 0; i < PaginationList.length; i++) {
            if (!PaginationList[i].isChecked) {
                allRecordsSelected = false;
                break;
            } 
        }
        if(component.find("selectAllId")!=null){
            component.find("selectAllId").set("v.value",allRecordsSelected);
        }
    },
    findRepeatingProducts: function (arr, n){
    	var mp = new Map();
        var repPrdList = [];
        for (var i = 0; i < n; i++)
        {
            if(mp.has(arr[i]))
                mp.set(arr[i], mp.get(arr[i])+1)
            else   
                mp.set(arr[i], 1)
        }
     
        for (var i = 0; i < n; i++) {
        	if (mp.get(arr[i]) > 1) {
                repPrdList.push(arr[i]);
        	}
    	}
        return repPrdList;
    },
    
    searchHelperResults: function(component, event, helper){
        var matchdata = component.get("v.matchdata");
        console.log("Search fired: "+JSON.stringify(matchdata));
        var allmatchdata = component.get("v.allmatchdata");    
        var searchKey = component.get("v.searchText");
        if(searchKey.length > 4){
            var filteredMatchData = [];
            var filteredUnMatchData = [];
            var filteredDescData = [];
            component.set("v.pageNumberListUnmatched",[]);
            component.set("v.pageNumberListMatched",[]);
            component.set("v.pageNumberListDiscrepancy",[]);
            if(matchdata!=undefined || matchdata.length>0){
                for(var i=0; i<allmatchdata.length; i++) {
                    if(allmatchdata[i].Product_Description__c && allmatchdata[i].Product_Description__c.toLowerCase().indexOf(searchKey.toLowerCase()) > -1 ||
                       allmatchdata[i].Name && allmatchdata[i].Name.toLowerCase().indexOf(searchKey.toLowerCase()) > -1 ||
                       allmatchdata[i].NDC_11__c && allmatchdata[i].NDC_11__c.indexOf(searchKey.toLowerCase()) > -1              
                      ){
                        filteredMatchData.push(allmatchdata[i]);
                    }
                } 
            }  
            component.set("v.matchdata", filteredMatchData);  
            component.set("v.filteredMatchData", filteredMatchData);  
            
            var unmatchdata = component.get("v.unmatchdata");
            var allunmatchdata = component.get("v.allunmatchdata");    
            if(unmatchdata!=undefined || unmatchdata.length>0){  
                for(var i=0; i<allunmatchdata.length; i++) {
                    if(allunmatchdata[i].Product_Description__c && allunmatchdata[i].Product_Description__c.toLowerCase().indexOf(searchKey.toLowerCase()) > -1 ||
                       allunmatchdata[i].Name && allunmatchdata[i].Name.toLowerCase().indexOf(searchKey.toLowerCase()) > -1 ||
                       allunmatchdata[i].NDC_11__c && allunmatchdata[i].NDC_11__c.indexOf(searchKey.toLowerCase()) > -1              
                      ){
                        filteredUnMatchData.push(allunmatchdata[i]);
                    } 
                } 
            }
            component.set("v.unmatchdata", filteredUnMatchData);  
            component.set("v.filteredUnMatchData", filteredUnMatchData);  
            var descData = component.get("v.discdata");
            var alldiscrepencydata = component.get("v.alldiscrepencydata");    
            if(descData!=undefined || descData.length>0){ 
                for(var i=0; i<alldiscrepencydata.length; i++) {
                    if(alldiscrepencydata[i].Product_Description__c && alldiscrepencydata[i].Product_Description__c.toLowerCase().indexOf(searchKey.toLowerCase()) > -1 ||
                       alldiscrepencydata[i].Name && alldiscrepencydata[i].Name.toLowerCase().indexOf(searchKey.toLowerCase()) > -1 ||
                       alldiscrepencydata[i].NDC_11__c && alldiscrepencydata[i].NDC_11__c.indexOf(searchKey.toLowerCase()) > -1              
                      ){
                        filteredDescData.push(alldiscrepencydata[i]);
                    }
                }  
            }  
            component.set("v.descData", filteredDescData);  
            component.set("v.filteredDescData", filteredDescData);  
        }
        if(searchKey==''){ 
            helper.showProducts(component, event, helper);
            component.set("v.filteredDescData", []);  
            component.set("v.filteredUnMatchData", []);  
            component.set("v.filteredMatchData", []);  
        }
    },  
    sortBy: function(component,helper,field) {
        var sortField = component.get("v.sortField"),
            currentTab = component.get("v.selTabId"),
            records = (currentTab == 'unmatchPrds') ? component.get("v.totalUnmatchdata"): component.get("v.totalMatchdata"),
            sortAsc = (currentTab == 'unmatchPrds') ? component.get("v.isUnMatchAsc") : component.get("v.sortAsc"),
            isDescAsc = component.get("v.isDescAsc");
        console.log('currentTab-->'+currentTab);
        records.sort(function(a,b){
            /*var itm = a[field].toUpperCase();
            var oldItm = b[field].toUpperCase();
            if ( itm < oldItm ){
                return -1;
            }
            if ( itm > oldItm ){
                return 1;
            }
            return 0;*/
            var t1 = a[field] == b[field],
                t2 = (!a[field] && b[field]) || (a[field] < b[field]);
            return t1? 0: (!sortAsc?-1:1)*(t2?1:-1);
        });
        component.set("v.sortAsc", !sortAsc);
        component.set("v.isDescAsc", !isDescAsc);
        component.set("v.sortField", field);
        if(currentTab == 'unmatchPrds'){
            console.log('records-->'+records.length);
            component.set("v.totalUnmatchdata", records);
            component.set("v.isSpinnerLoad",false);
            component.set("v.showProductsloading",false);
            /*window.setTimeout(
                $A.getCallback(function() {
                    component.set("v.isSpinnerLoad",false);
                    component.set("v.showProductsloading",false);
                }), 15000
            );*/
            
        }else{
            component.set("v.matchdata", records);
            component.set("v.isSpinnerLoad",false);
            component.set("v.showProductsloading",false);
            /*window.setTimeout(
                $A.getCallback(function() {
                    component.set("v.isSpinnerLoad",false);
                    component.set("v.showProductsloading",false);
                }), 15000
            );*/
        }
        
         helper.paginateRecords(component,event);
    },
    moveToUnMatch: function(component,helper,selectedId){
        if(component.get("v.showConfirmation") == false){
            component.set("v.showConfirmation",true);
            component.set("v.confirmationMessage","Do you want to unmatch this product?");
            //var selectedId = event.currentTarget.dataset.id;
            
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
        }
    
   }
    
    
})