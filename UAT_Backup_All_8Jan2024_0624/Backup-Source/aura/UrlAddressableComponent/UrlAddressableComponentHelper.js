/**
 * @description       : 
 * @author            : Surender Patel (Dhruvsoft)
 * @group             : 
 * @last modified on  : 05-08-2020
 * @last modified by  : Surender Patel (Dhruvsoft)
 * Modifications Log 
 * Ver   Date         Author                       Modification
 * 1.0   04-08-2020   Surender Patel (Dhruvsoft)   Initial Version
**/
({
    closeActionPanel: function (component, event, helper) {
        
    },
    getDetails: function (component, helper) {
       
        let pageReference = component.get("v.pageReference");
        console.log(pageReference);
        let recordId = pageReference.state.c__recordId;
        console.log("loadInstance recordId: " + recordId);
        
        if (recordId != null && recordId != undefined && recordId != '') {
            component.set("v.recordId", recordId);
        }
        var bidId = component.get("v.recordId");
        console.log('  var recordId ---->'+bidId);
    },
    
    getBidDetails: function (component, helper) {
         alert('getBidDetails');
         // $A.get('e.force:refreshView').fire();
        /*let pageReference = component.get("v.pageReference");
        console.log(pageReference);
        let recordId = pageReference.state.c__recordId;
        console.log("loadInstance recordId: " + recordId);*/
        
        var recordId=component.get("v.recordId");
        if (recordId != null && recordId != undefined && recordId != '') {
            component.set("v.recordId", recordId);
        }
        var bidId = component.get("v.recordId");
        console.log('  var recordId ---->'+bidId);
        
        var getQuoteInfo = component.get("c.getBidInfo");
        getQuoteInfo.setParams({ "bidId": bidId });
        getQuoteInfo.setCallback(this, function (response) {
            var actState = response.getState();
            
            if (actState === 'SUCCESS') {
                
                if(response.getReturnValue().bid.Id!=undefined && response.getReturnValue().bid.Id!=null && response.getReturnValue().bid.Id!='')
                {
                    if(true)//response.getReturnValue().quote.PQT_Status__c=='Draft' && component.get("v.userId")==response.getReturnValue().bid.OwnerId 
                    {
                        component.set("v.isQuoteEditable",true);
                        component.set("v.hideQuoteButtons",false);
                    } 
                    else
                    {
                        component.set("v.isQuoteEditable",false);
                        component.set("v.hideQuoteButtons",true);
                    }
                    
                }
                else
                    component.set("v.hideQuoteButtons",false);
                
                component.set("v.wrap", response.getReturnValue());
                helper.loadProducts(component,helper);
                component.set("v.showSaveItems", false);
            }
        });
        $A.enqueueAction(getQuoteInfo);
        
        
    },
    loadProducts: function (component, helper) {
        
        var quotewrap = component.get("v.wrap");
        console.log('wrap---'+JSON.stringify(quotewrap));
        var searchText = component.get("v.searchText");
        
        var getProductsAction = component.get("c.getproducts1");
        getProductsAction.setParams({ "quotewrap": quotewrap });
        getProductsAction.setCallback(this, function (response) {
            var actState = response.getState();
            if (actState === 'SUCCESS') {
                component.set("v.showSpinnerSelProds",false);
                var resposeData = response.getReturnValue();
                console.log('resposeData-------------->' + resposeData);
                var i = 0;
                var prd = []
                for (i = 0; i < 50; i++) {
                    prd.push(resposeData[i]);
                }
                
                //component.set("v.ProductList",prd);
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
                    console.log('totalPages' + component.get("v.totalPages"));
                    console.log('allData length' + Math.ceil(response.getReturnValue().length));
                    console.log('currentPageNumber' + component.get("v.currentPageNumber"));
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
        var data = [];
        let selectedProductsIds = component.get("v.selectedProductsIds");
        console.log("%c--------selectedProductsIds-------" + selectedProductsIds, "background-color:red;color:white;");
        var pageNumber = component.get("v.currentPageNumber");
        var pageSize = component.get("v.pageSize");
        var allData = component.get("v.allData");
        var x = (pageNumber - 1) * pageSize;
        var pData;
        console.log('selectAll-----------'+component.get("v.selectAll"));
        
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
        
        
        
        helper.generatePageList(component, pageNumber);
    },
    
    /*
     * this function generate page list
     * */
    generatePageList: function (component, pageNumber) {
        pageNumber = parseInt(pageNumber);
        var pageList = [];
        var totalPages = component.get("v.totalPages");
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
    onsearchFamilyhelper: function (component, helper) {
        var allRecords = component.get("v.Allproduct");
        var allRecords1 = component.get("v.ProductList");
        
        var searchFilter = component.get("v.searchFamily");
        var searchName=component.get("v.searchText");
        
        console.log('searchName' + searchName);
        console.log('searchfilter' + searchFilter);
        if ((searchFilter != null && searchFilter != undefined &&searchFilter != '' )||(searchName != null && searchName != undefined && searchName != '')) {
            
            component.set("v.showSpinnerSelProds",true);
            var getProductsAction = component.get("c.getSearchFamily");
            if(searchName!=null && searchName!=undefined && searchName!=''){
                
                if(searchFilter==''||searchFilter==undefined||searchFilter==null){
                    getProductsAction.setParams({ pItem: allRecords, search: searchName });
                }
                else{
                    
                    getProductsAction.setParams({ pItem: allRecords1, search: searchFilter });
                }
            }
            
            
            else{
                
                getProductsAction.setParams({ pItem: allRecords, search: searchFilter });  
            }
            
            
            getProductsAction.setCallback(this, function (response) {
                var actState = response.getState();
                
                console.log('state' + actState);
                if (actState === 'SUCCESS') {
                    component.set("v.showSpinnerSelProds",false);
                    var resposeData = response.getReturnValue();
                    if(resposeData==null){
                        component.set("v.noData",true);  
                    }
                    
                    component.set("v.ProductList", resposeData);
                    
                    
                    if (resposeData != null && resposeData!=undefined && resposeData!='') {
                        if(resposeData.length > 0){
                            component.set("v.noData",false);   
                            component.set("v.totalPages", Math.ceil(resposeData.length / component.get("v.pageSize")));
                            component.set("v.allData", resposeData);
                            
                            component.set("v.currentPageNumber", 1);
                            helper.buildData(component, helper);
                        }
                    }
                    
                }
                else{
                    component.set("v.showSpinnerSelProds",false); 
                }
            });
            $A.enqueueAction(getProductsAction);
        }
        else{
            helper.loadProducts(component, helper);  
        }
        
    },
    
    searchTablehelper: function (component,helper) {
        
        var allRecords = component.get("v.Allproduct");
        var allRecords1 = component.get("v.ProductList");
        
        
        var searchFilter = component.get("v.searchText");
        var searchFamily = component.get("v.searchFamily");
        console.log('searchfilter' + searchFilter);
        if ((searchFilter != null && searchFilter != undefined &&searchFilter != '' )||(searchFamily != null && searchFamily != undefined && searchFamily != '')) {
            
            component.set("v.showSpinnerSelProds",true);
            var getProductsAction = component.get("c.getSearch");
            if(searchFamily!=null && searchFamily!=undefined && searchFamily!=''){
                
                if(searchFilter==''||searchFilter==undefined||searchFilter==null){
                    getProductsAction.setParams({ pItem: allRecords, search: searchFamily });
                }
                else{
                    
                    getProductsAction.setParams({ pItem: allRecords1, search: searchFilter });
                }
            }
            
            
            else{
                
                getProductsAction.setParams({ pItem: allRecords, search: searchFilter });  
            }
            
            
            getProductsAction.setCallback(this, function (response) {
                var actState = response.getState();
                
                console.log('state' + actState);
                if (actState === 'SUCCESS') {
                    
                    component.set("v.showSpinnerSelProds",false);
                    var resposeData = response.getReturnValue();
                    if(resposeData==null ||resposeData==undefined||resposeData==''){
                        component.set("v.noData",true);  
                    }
                    
                    component.set("v.ProductList", resposeData);
                    
                    
                    if (resposeData != null && resposeData!=undefined && resposeData!='' ) {
                        if(resposeData.length > 0){
                            component.set("v.noData",false);    
                            component.set("v.totalPages", Math.ceil(resposeData.length / component.get("v.pageSize")));
                            component.set("v.allData", resposeData);
                            
                            component.set("v.currentPageNumber", 1);
                            helper.buildData(component, helper);
                        }
                    }
                    
                }
                else{
                    component.set("v.showSpinnerSelProds",false);
                }
            });
            $A.enqueueAction(getProductsAction);
        }
        else{
            helper.loadProducts(component, helper);  
        }
        
    },
})