/**
 * @description       : 
 * @author            : Suseela (Dhruvsoft)
 * @group             : 
 * @last modified on  : 09-12-2020
 * @last modified by  : Suseela(Dhruvsoft)
 * Modifications Log 
 * Ver   Date         Author                       Modification
 * 1.0   25-11-2020   Suseela (Dhruvsoft)   Initial Version
**/
({
    closeActionPanel: function (component, event, helper) {
        
    },
    
    getBidDetails: function (component, helper) {
        
        let pageReference = component.get("v.pageReference");
        let recordId = pageReference.state.c__recordId;
        
        if (recordId != null && recordId != undefined && recordId != '') {
            component.set("v.recordId", recordId);
        }
        var bidId = component.get("v.recordId");
        
        var getQuoteInfo = component.get("c.getBidInfo");
        getQuoteInfo.setParams({ "bidId": bidId });
        getQuoteInfo.setCallback(this, function (response) {
            var actState = response.getState();
            
            if (actState === 'SUCCESS') {
                
                if(response.getReturnValue().bid.Id!=undefined && response.getReturnValue().bid.Id!=null && response.getReturnValue().bid.Id!='')
                {
                    component.set("v.wrap", response.getReturnValue());
                    if(component.get('v.wrap.bid.Phoenix_Approval_Status__c') != 'Draft') {
                        component.set('v.showDraftView',false);
                    }
                    console.log('response.getReturnValue()=='+JSON.stringify(response.getReturnValue()));
                    var bidType = component.get('v.wrap.bid.Phoenix_Bid_Type__c');
                   	var templatetype = component.get('v.wrap.bid.Phoenix_Customer_Type__c');
       				 	component.set('v.bidType',bidType);
                    	component.set('v.templateType',templatetype);
                    var bidTypeList = ['Price Change','Customer Rebate Change','Sales Out Rebate','OTC Price Change','Volume Review Only','OTC Volume Review','OTC Rebate Change'];
                    if(bidTypeList.includes(bidType)) {
                        console.log('Phoenix_Approval_Status__c=='+component.get('v.wrap.bid.Phoenix_Approval_Status__c'));
                        component.set('v.isContractSelectionNeeded',true);
                        component.set('v.allContractsChecked',false);
                        component.set('v.showContracts',true);
                       
                        
                        component.set('v.navigateToComponent',false);
                        var bidCustomerId = component.get('v.wrap.bid.Phoenix_Customer__c');
                        component.set('v.bidCustomerId',bidCustomerId);
                        var searchInput='';//component.find("cntInput").get("v.value");
                        console.log('--searchInput--'+searchInput);
                        console.log('--bidCustomerId--'+bidCustomerId);
                        if(bidCustomerId != null && bidCustomerId != undefined){
                            helper.fetchContratcs(component, event,helper,bidCustomerId,searchInput);
                        } else{
                            component.set("v.PaginationList",null);
                        }   
                    }
                    else {
                        component.set('v.showContracts',false);
                        component.set('v.isContractSelectionNeeded',false);
                        component.set('v.showProducts',true);
                    	helper.loadProducts(component,helper);
                    }
                    
                }
            }
        });
        $A.enqueueAction(getQuoteInfo);
        
        
    },
    loadProducts: function (component, helper) {
        
        var quotewrap = component.get("v.wrap");
        
        var searchText = component.get("v.searchText");
        
        var getProductsAction = component.get("c.getproducts1");
        getProductsAction.setParams({ "quotewrap": quotewrap });
        getProductsAction.setCallback(this, function (response) {
            var actState = response.getState();
            if (actState === 'SUCCESS') {
               
                var resposeData = response.getReturnValue();
                
              
                
                
                
                if(resposeData!=undefined && resposeData!='' && resposeData!=null ){
                    if (resposeData.length > 0) {
                        component.set("v.showProducts", true);
                    }
                    else {
                        component.set("v.noProducts", true);
                    }
                    
                    
                    component.set("v.Allproduct", resposeData);
                    component.set("v.totalPages", Math.ceil(response.getReturnValue().length / component.get("v.pageSize")));
                    component.set("v.allData", response.getReturnValue());
                    
                    component.set("v.totalRecordsCount", response.getReturnValue().length);
                    
                    if(component.get("v.totalRecordsCount")==0)
                        component.set("v.noProducts",true);
                    else{
                        component.set("v.noProducts",false); 
                    }
                    
                    
                    
                    component.set("v.currentPageNumber", 1);
                    helper.buildData(component, helper);
                    
                    
                    
                    
                }
            }
        });
        $A.enqueueAction(getProductsAction);
    },
    
    /*
     * this function will build table data
     * based on current page selection
     * */
    buildData: function (component, helper) {
         //window.scroll(0,0);
         var scrollOptions = {
        left: 0,
        top: 0,
        
             
        behavior: 'smooth'
    }
    window.scrollTo(scrollOptions);
        var data = [];
        let selectedProductsIds = component.get("v.selectedProductsIds");
        console.log("%c--------selectedProductsIds-------" + selectedProductsIds, "background-color:red;color:white;");
        var pageNumber = component.get("v.currentPageNumber");
        var pageSize = component.get("v.pageSize");
        var allData = component.get("v.allData");
        var x = (pageNumber - 1) * pageSize;
        var pData;
        var copyList=[];
        component.set("v.ProductCopyList",copyList);
        
        //creating data-table data
        for (; x < (pageNumber) * pageSize; x++) {
            pData = allData[x];
            if (pData) {
                pData.isSelected = false;
                if (selectedProductsIds.includes(pData.prdlist.Id)) {
                    
                    pData.isSelected = true;
                }
                data.push(pData);
            }
        }
        component.set("v.ProductList", data);
        
        
        if(data.length>0){
            var selectCount=0;
            for(var i=0;i<data.length;i++){
                if(data[i].isSelected==true){
                    selectCount++;
                }
            }
            
            if(selectCount==pageSize ||selectCount==i){
                component.set("v.selectAll",true);  
                
            }
            else{
                component.set("v.selectAll",false); 
            }
        }
        
        
        
        helper.generatePageList(component, pageNumber, false);
    },
    
    /*
     * this function generate page list
     * */
    generatePageList: function (component, pageNumber, isFromContractView) {
        pageNumber = parseInt(pageNumber);
        var pageList = [];
        var totalPages = isFromContractView ? component.get("v.totalPagesCount") : component.get("v.totalPages");
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
      searchHelperProdDir : function(component,event,getInputkeyWord) {
           
          var Action = component.get("c.getProductDirectorList");
          Action.setParams({ "bidwrap":component.get("v.wrap")});  
            
            
            
            Action.setCallback(this, function (response) {
                var actState = response.getState();
                if (actState === 'SUCCESS') {
                  
                    var resposeData = response.getReturnValue();
                   component.set("v.defaultlistOfProductDirectors", resposeData);
                   var li = component.get("v.defaultlistOfProductDirectors");
        console.log('list of pro dirs-->'+li);
        var excludelist=component.get("v.lstSelectedPDRecords");
        console.log('excludelist---'+excludelist);
        console.log('getInputkeyWord--'+getInputkeyWord);
        var final=[];
        let difference = li.filter(x => !excludelist.includes(x) && x.toLowerCase().startsWith(getInputkeyWord.toLowerCase()));
        console.log(difference);
        if(difference.length>0){
            component.set("v.listOfSearchPDRecords", difference); 
            component.set("v.MessagePD", '');
        }else{
            component.set("v.MessagePD", 'No Records Found...');
            component.set("v.listOfSearchPDRecords", null); 
               }
                }
               
            });
            $A.enqueueAction(Action);
        
    },
    onsearchDirectorhelper: function (component, helper) {
        var allRecords = component.get("v.Allproduct");
        var searchFamily = component.get("v.searchFamily");
        var searchText=component.get("v.searchText");
        var SearchKeyWordPD = component.get("v.lstSelectedPDRecords");
        var selectedRecords = [];
        if(allRecords != undefined && allRecords.length > 0){
            allRecords.forEach(function(wr){
                if(wr.isSelected)
                	selectedRecords.push(wr);
            });
        }
        
        console.log('SearchKeyWordPD in helper--->'+SearchKeyWordPD)
        if ((SearchKeyWordPD != null && SearchKeyWordPD != undefined &&SearchKeyWordPD != '' )) {
            var constractsIdList;
            if(component.get("v.isContractSelectionNeeded")){
                constractsIdList= component.get('v.selectedContratcsIdList');
			}
            else{
                constractsIdList=[];
            }
            component.set("v.showSpinnerSelProds",true);
            var getProductsAction = component.get("c.finalSearchResult");
           
            
            getProductsAction.setParams({ pItem: selectedRecords, 
                                         SearchKeyWordPD:SearchKeyWordPD,
                                         Family: searchFamily,
                                         searchName:searchText,
                                         RxSrxList:component.get("v.RxSrxList"),
                                         "quotewrap": component.get("v.wrap"),
                                          constractsIdList:constractsIdList
                                        });  
            
            
            
            
            getProductsAction.setCallback(this, function (response) {
                var actState = response.getState();
                
                
                if (actState === 'SUCCESS') {
                   console.log('in success')
                    var resposeData = response.getReturnValue();
                    if(resposeData==null ||resposeData==undefined||resposeData==''){
                        component.set("v.noData",true);  
                        console.log('no data true---')
                    }
                    
                    component.set("v.ProductList", resposeData);
                    component.set("v.allData", resposeData);
                    console.log('resposeData--->'+JSON.stringify(resposeData))
                    if (resposeData != null && resposeData!=undefined && resposeData!='') {
                        if(resposeData.length > 0){
                            component.set("v.noData",false);   
                            component.set("v.totalPages", Math.ceil(resposeData.length / component.get("v.pageSize")));
                            component.set("v.allData", resposeData);
                            
                            component.set("v.currentPageNumber", 1);
                            helper.buildData(component, helper);
                        }
                    }
                     component.set("v.showSpinnerSelProds",false);
                }
                else{
                    console.log('director error issue--'+response.getError())
                    component.set("v.showSpinnerSelProds",false); 
                }
            });
            $A.enqueueAction(getProductsAction);
        }
        else{
            var resposeData=component.get("v.Allproduct");
            component.set("v.totalPages", Math.ceil(resposeData.length / component.get("v.pageSize")));
            component.set("v.allData", resposeData);
            
            component.set("v.currentPageNumber", 1);
            helper.buildData(component, helper);
        }
    },
    onsearchFamilyhelper: function (component, helper) {
        component.set("v.showSpinnerSelProds",true);
        var allRecords = component.get("v.Allproduct");
        var searchFilter = component.get("v.searchFamily");
        var searchName=component.get("v.searchText");
        var SearchKeyWordPD = component.get("v.lstSelectedPDRecords");
        var RxSrxList=component.get("v.RxSrxList");
        var selectedRecords = [];
        if(allRecords != undefined && allRecords.length > 0){
            allRecords.forEach(function(wr){
                if(wr.isSelected)
                    selectedRecords.push(wr);
            });
        }
        console.log('SearchKeyWordPD in search helper'+SearchKeyWordPD);
                console.log('searchFilter in search helper'+searchFilter);
                console.log('searchName in search helper'+searchName);
               
      
                    if ((searchFilter != null && searchFilter != undefined && searchFilter != '' )) {
                    
                        var constractsIdList;
            if(component.get("v.isContractSelectionNeeded")){
              
                constractsIdList= component.get('v.selectedContratcsIdList');
			}
            else{
                constractsIdList=[];
            }

            
            var getProductsAction = component.get("c.finalSearchResult");
            
            
            getProductsAction.setParams({ "pItem": selectedRecords, 
                                         "SearchKeyWordPD":SearchKeyWordPD,
                                         "search": searchFilter,
                                         "searchName":searchName,
                                         "RxSrxList":component.get("v.RxSrxList"),
                                         "quotewrap": component.get("v.wrap"),
                                         constractsIdList:constractsIdList
                                        });  
                      
            
            
            
            getProductsAction.setCallback(this, function (response) {
                var actState = response.getState();
                console.log('actState'+actState);
                
                if (actState === 'SUCCESS') {
                   
                    var resposeData = response.getReturnValue();
                    if(resposeData==null ||resposeData==undefined||resposeData==''){
                        component.set("v.noData",true);  
                    }
                    
                    component.set("v.ProductList", resposeData);
                    component.set("v.allData", resposeData);
                     console.log('resposeData'+JSON.stringify(resposeData));
                    if (resposeData != null && resposeData!=undefined && resposeData!='') {
                        if(resposeData.length > 0){
                            component.set("v.noData",false);   
                            component.set("v.totalPages", Math.ceil(resposeData.length / component.get("v.pageSize")));
                            component.set("v.allData", resposeData);
                            
                            component.set("v.currentPageNumber", 1);
                            helper.buildData(component, helper);
                        }
                    }
                   component.set("v.showSpinnerSelProds",false);  
                }
                else{
                    component.set("v.showSpinnerSelProds",false); 
                }
            });
            $A.enqueueAction(getProductsAction);
                    }
        else{
            var resposeData=component.get("v.Allproduct");
            component.set("v.totalPages", Math.ceil(resposeData.length / component.get("v.pageSize")));
            component.set("v.allData", resposeData);
            
            component.set("v.currentPageNumber", 1);
            helper.buildData(component, helper);
        }
        
        
        
    },
    
    searchTablehelper: function (component,helper,size) {
        
        var allRecords = component.get("v.Allproduct");
        var searchFamily = component.get("v.searchFamily");
        var searchText=component.get("v.searchText");
        var SearchKeyWordPD = component.get("v.lstSelectedPDRecords");
        var selectedRecords = [];
        if(allRecords != undefined && allRecords.length > 0){
            allRecords.forEach(function(wr){
                if(wr.isSelected)
                	selectedRecords.push(wr);
            });
        }
        
        
        if ((searchText != null && searchText != undefined && searchText != '' )) {
            
            var constractsIdList;
            if(component.get("v.isContractSelectionNeeded")){
               
                constractsIdList= component.get('v.selectedContratcsIdList');
			}
            else{
                constractsIdList=[];
            }
            component.set("v.showSpinnerSelProds",true);
            var getProductsAction = component.get("c.finalSearchResult");
            //var allData=component.get("v.allData").slice(0,100);
            
            getProductsAction.setParams({ pItem: selectedRecords, 
                                         SearchKeyWordPD:SearchKeyWordPD,
                                         Family: searchFamily,
                                         searchName:searchText,
                                         RxSrxList:component.get("v.RxSrxList"),
                                         "quotewrap": component.get("v.wrap"),
                                          constractsIdList:constractsIdList
                                         
                                        }); 
           
            
            
            
            getProductsAction.setCallback(this, function (response) {
                var actState = response.getState();
                console.log('actState searchFilter--->'+actState)
                
                if (actState === 'SUCCESS') {
                    console.log('in success searchFilter')
                  
                    var resposeData = response.getReturnValue();
                    if(resposeData==null ||resposeData==undefined||resposeData==''){
                        component.set("v.noData",true);  
                    }
                    
                    component.set("v.ProductList", resposeData);
                    component.set("v.allData", resposeData);
                    
                    if (resposeData != null && resposeData!=undefined && resposeData!='' ) {
                        if(resposeData.length > 0){
                            component.set("v.noData",false);    
                            component.set("v.totalPages", Math.ceil(resposeData.length / component.get("v.pageSize")));
                            component.set("v.allData", resposeData);
                            
                            component.set("v.currentPageNumber", 1);
                            helper.buildData(component, helper);
                        }
                    }
                     component.set("v.showSpinnerSelProds",false); 
                }
                else{
                     if (response.getState() === "ERROR"){

                    var errors = getProductsAction.getError();
                    
                    if (errors) {
                    
                    if (errors[0] && errors[0].message) {
                    
                    //cmp.set(“v.message”, errors[0].message);
                    console.log('error message'+errors[0].message);
                    
                    }
                    
                    }
                    
                    }
                    component.set("v.showSpinnerSelProds",false);
                }
            });
            $A.enqueueAction(getProductsAction);
        }
        else{
            var resposeData=component.get("v.Allproduct");
            component.set("v.totalPages", Math.ceil(resposeData.length / component.get("v.pageSize")));
            component.set("v.allData", resposeData);
            
            component.set("v.currentPageNumber", 1);
            helper.buildData(component, helper);
        }
        
    },
    sortHelper: function(component, event, sortFieldName) {
        var currentDir = component.get("v.arrowDirection");
        
        if (currentDir == 'arrowdown') {
            // set the arrowDirection attribute for conditionally rendred arrow sign  
            component.set("v.arrowDirection", 'arrowup');
            // set the isAsc flag to true for sort in Assending order.  
            component.set("v.isAsc", true);
        } else {
            component.set("v.arrowDirection", 'arrowdown');
            component.set("v.isAsc", false);
        }
        // call the onLoad function for call server side method with pass sortFieldName
        this.onSortResult(component, event, sortFieldName);
    },
    
    onSortResult: function(component, event, sortField) {
        //call apex class method
        component.set("v.showSpinnerSelProds",true);
        
        var action = component.get('c.fetchSortResults');
        var productList=[];
        //var productIds=[];
        productList=component.get("v.ProductList");
        //for(var i=0;i<productList.length;i++){
        
        //productIds.push(productList[i].prdlist.Id);
        // }
        
        
        // pass the apex method parameters to action
        action.setParams({
            'sortField': sortField,
            'isAsc': component.get("v.isAsc"),
            'productList':productList
        });
        action.setCallback(this, function(response) {
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") {
               
                
                //set response value in ListOfContact attribute on component.
                component.set("v.ProductList", response.getReturnValue());
                 component.set("v.showSpinnerSelProds",false);
            }
        });
        $A.enqueueAction(action);
    },
    searchRx: function (component,helper) {
        var picliList = component.get('v.RxSrxList');        
        if(component.get("v.isRxChecked") && !picliList.includes('Rx')){
            
            picliList.push('Rx');
        }
        if(component.get("v.isSRxChecked") && !picliList.includes('SRx')){
            picliList.push('SRx');
        }
        if(component.get("v.isOtcChecked") && !picliList.includes('OTC')){
            picliList.push('OTC');
        }
        if(component.get("v.isRxChecked") == false && picliList.includes('Rx')){
            var ind = picliList.indexOf('Rx')
            picliList.splice(ind, 1);
        }
        if(component.get("v.isSRxChecked") == false && picliList.includes('SRx')){
            var ind = picliList.indexOf('SRx')
            picliList.splice(ind, 1);
        }
        if(component.get("v.isOtcChecked") == false && picliList.includes('OTC')){
            var ind = picliList.indexOf('OTC')
            picliList.splice(ind, 1);
        }
        component.set("v.RxSrxList",picliList);
       component.set("v.showSpinnerSelProds",true);
        var searchFamily = component.get("v.searchFamily");
        var searchName=component.get("v.searchText");
        var SearchKeyWordPD = component.get("v.lstSelectedPDRecords");
        var allRecords = component.get("v.Allproduct");
        var selectedRecords = [];
        if(allRecords != undefined && allRecords.length > 0){
            allRecords.forEach(function(wr){
                if(wr.isSelected)
                    selectedRecords.push(wr);
            });
        }
        if(component.get("v.RxSrxList").length > 0 ){
            
             var constractsIdList;
            if(component.get("v.isContractSelectionNeeded")){
              constractsIdList= component.get('v.selectedContratcsIdList');
			}
            else{
                constractsIdList=[];
            }
            
            
            var action = component.get("c.finalSearchResult");
            action.setParams({ pItem: selectedRecords, 
                              SearchKeyWordPD:SearchKeyWordPD,
                              Family: searchFamily,
                              searchName:searchName,
                              RxSrxList:component.get("v.RxSrxList"),
                              "quotewrap": component.get("v.wrap"),
                               constractsIdList:constractsIdList
                             });
            //allData:JSON.stringify(component.get("v.allData"))
            action.setCallback(this, function(a) {
               
                var resposeData =a.getReturnValue();
                component.set("v.noData",false);  
                component.set("v.ProductList", resposeData);
                //console.log('resposeData------'+resposeData);
                if(resposeData!=null && resposeData!='' && resposeData!=undefined){
                    
                    
                    component.set("v.totalPages", Math.ceil(resposeData.length / component.get("v.pageSize")));
                    component.set("v.allData", resposeData);
                    
                    component.set("v.currentPageNumber", 1);
                    helper.buildData(component, helper); 
                }
                else{
                    console.log('resposeData in else------'+resposeData);
                    component.set("v.showSpinnerSelProds",false);
                    
                    component.set("v.noData",true);  
                    
                }
                 component.set("v.showSpinnerSelProds",false);
            });
            $A.enqueueAction(action);
        }
        else{
            
          
            component.set("v.noData",false);
            var searchFamily = component.get("v.searchFamily");
        var searchName=component.get("v.searchText");
        console.log('searchName-------'+searchName);
          var SearchKeyWordPD = component.get("v.lstSelectedPDRecords");
          var RxSrxList = component.get("v.RxSrxList");
        
            //component.set("v.showSpinnerSelProds",true);
              if(!RxSrxList.length>0){
        if(searchName!=null && searchName!='undefined' && searchName!=''){
            helper.searchTablehelper(component,helper); 
        }
        else if(searchFamily!=null && searchFamily!='undefined' && searchFamily!=''){
             helper.onsearchFamilyhelper(component, helper);  
        }
        else if(SearchKeyWordPD.length>0){
            helper.onsearchDirectorhelper(component,helper);   
        }
            else if(RxSrxList.length>0){
                helper.searchRx(component, helper);
            }
                else{
                   var resposeData=component.get("v.Allproduct");
            component.set("v.totalPages", Math.ceil(resposeData.length / component.get("v.pageSize")));
                            component.set("v.allData", resposeData);
                            
                            component.set("v.currentPageNumber", 1);
                            helper.buildData(component, helper); 
                      component.set("v.showSpinnerSelProds",false);
                }
        // component.set("v.showSpinnerSelProds",false);
         
            
            
        }
        }
    },
    
    //JS Helper for Contracts View
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
                        rec.isChecked = false;
                    }
                    resList.push(rec);
        		}
                
                component.set('v.allDataCV', resList);
                component.set('v.filteredData', resList);
                this.doInitHelper(component, resList,helper);
                component.set('v.isSpinnerLoad',false);
            }
        });
        $A.enqueueAction(action);
    },
    
    /*setPageDataAsPerPagination: function(component, start, end) {
        let data = [];
        let pageNumber = component.get("v.currentPage");
        let pageSize = component.get("v.pageSizeCV");
        let filteredData = component.get('v.filteredData');
        let x = (pageNumber - 1) * pageSize;
        for (; x < (pageNumber) * pageSize; x++){
            if (filteredData[x]) {
                data.push(filteredData[x]);
            }
        }
        console.log('start',start);
        console.log('end',end);
        component.set("v.startPage",start);
        component.set("v.endPage",end);
        component.set("v.PaginationList", data);
    },*/
    
    getContractProducts: function(component, event, helper) {
        component.set('v.isSpinnerLoad',true);       
        var action = component.get("c.getContractProducts");
        var quotewrap = component.get("v.wrap");
        console.log('selectedContratcsIdList::'+component.get('v.selectedContratcsIdList'));
        action.setParams({
            quotewrap: quotewrap,
            constractsIdList: component.get('v.selectedContratcsIdList')
        });
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                var responseList = response.getReturnValue();
                console.log('---Products responseList---'+responseList.length);
                component.set('v.showContracts', false);
                component.set('v.showProducts', true);
                //component.set('v.productsList', responseList);
                component.set('v.isSpinnerLoad',false);
                component.set('v.navigateToComponent',true);
                helper.loadProductsForContractsView(component,helper,responseList);
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
    
    // navigate to next pagination record set   
    next : function(component,event,sObjectList,end,start,pageSize){
		var Paginationlist = [];
        var counter = 0;
        for(var i = end + 1; i < end + pageSize + 1; i++){
            if(sObjectList.length > i){ 
                if(component.find("selectAllId").get("v.value")){
                    Paginationlist.push(sObjectList[i]);
                }else{
                    Paginationlist.push(sObjectList[i]);  
                }
            }
            counter ++ ;
        }
        start = start + counter;
        end = end + counter;
        console.log('start last'+start);
        console.log('end last'+end);
        component.set("v.startPage",start);
        component.set("v.endPage",end);
        component.set('v.PaginationList', Paginationlist);
    },
    
   // navigate to previous pagination record set   
    previous : function(component,event,sObjectList,end,start,pageSize){
        var Paginationlist = [];
        var counter = 0;
        for(var i= start-pageSize; i < start ; i++){
            if(i > -1){
                if(component.find("selectAllId").get("v.value")){
                    Paginationlist.push(sObjectList[i]);
                }else{
                    Paginationlist.push(sObjectList[i]); 
                }
                counter ++;
            }else{
                start++;
            }
        }
        start = start - counter;
        end = end - counter;
        component.set("v.startPage",start);
        component.set("v.endPage",end);
        component.set('v.PaginationList', Paginationlist);
    },
    
    processPageNumber: function(component,event,sObjectList,end,start,pageSize){
		var Paginationlist = [];
        var counter = 0;
        for(var i = start; i < end + 1; i++){
            if(sObjectList.length > i){ 
                if(component.find("selectAllId").get("v.value")){
                    Paginationlist.push(sObjectList[i]);
                }else{
                    Paginationlist.push(sObjectList[i]);  
                }
            }
            //counter ++ ;
        }
        //start = start + counter;
        //end = end + counter;
        console.log('start last'+start);
        console.log('end last'+end);
        component.set("v.startPage",start);
        component.set("v.endPage",end);
        component.set('v.PaginationList', Paginationlist);
        component.set('v.currentPage', component.get('v.currentPage'));
    },
    
    loadProductsForContractsView: function (component, helper, responseList) {
        var quotewrap = component.get("v.wrap");
        var searchText = component.get("v.searchText");
        if(responseList!=undefined && responseList!='' && responseList!=null ){
            if (responseList.length > 0) {
                component.set("v.showProducts", true);
            }
            else {
                component.set("v.noProducts", true);
            }
            component.set("v.Allproduct", responseList);
            component.set("v.totalPages", Math.ceil(responseList.length / component.get("v.pageSize")));
            component.set("v.allData", responseList);
            component.set("v.totalRecordsCount", responseList.length);
            
            if(component.get("v.totalRecordsCount")==0)
                component.set("v.noProducts",true);
            else{
                component.set("v.noProducts",false);
 
            }
            
            component.set("v.currentPageNumber", 1);
            helper.buildData(component, helper);
            component.set("v.selectedCount",0);
            component.set("v.isRxChecked",false);
            component.set("v.isSRxChecked",false);
            component.set("v.isOtcChecked",false);
            component.set("v.searchText",'');
            component.set("v.SearchKeyWordPD",'');
            var lstSelectedPDRecords=[];
             component.set("v.lstSelectedPDRecords",lstSelectedPDRecords);
        }
    	component.set('v.isSpinnerLoad',true); 
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
    
    
})