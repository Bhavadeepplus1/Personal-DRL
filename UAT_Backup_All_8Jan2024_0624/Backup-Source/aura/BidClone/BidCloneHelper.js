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
    showToast: function (params) {
        var toastEvent = $A.get("e.force:showToast");
        if (toastEvent) {
            toastEvent.setParams(params);
            toastEvent.fire();
        } else {
            alert(params.message);
        }
    },

    closeActionPanel: function (component, event, helper) {

    },


    getBidPicklistVals: function (component, helper) {
        var timeZone = component.get("c.getDeadLineTimeZone");
        timeZone.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                var timeZoneMap = [];
                for (var key in result) {
                    timeZoneMap.push({
                        key: key,
                        value: result[key]
                    });
                }
                component.set("v.timeZoneMap", timeZoneMap);
            }
        });

        var deadLineTime = component.get("c.getDeadLineTime");
        deadLineTime.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                var deadLineTimeMap = [];
                for (var key in result) {
                    deadLineTimeMap.push({
                        key: key,
                        value: result[key]
                    });
                }
                component.set("v.deadLineTimeMap", deadLineTimeMap);
            }
        });
        $A.enqueueAction(timeZone);
        $A.enqueueAction(deadLineTime);
    },

    getBidDetails: function (component, helper) {

        var bidId = component.get("v.recordId");

        console.log('bidId==' + bidId);
        var getQuoteInfo = component.get("c.getbidInfo");
        getQuoteInfo.setParams({
            "recordId": bidId
        });
        getQuoteInfo.setCallback(this, function (response) {
            var actState = response.getState();

            if (actState === 'SUCCESS') {
                console.log('response.getReturnValue()==' + JSON.stringify(response.getReturnValue()));
                if (response.getReturnValue().bid.Id != undefined && response.getReturnValue().bid.Id != null && response.getReturnValue().bid.Id != '') {
                    component.set("v.wrap", response.getReturnValue());
                    var bidType = component.get('v.wrap.bid.Phoenix_Bid_Type__c');

                    //component.set('v.showProducts',true);
                    helper.loadProducts(component, helper);
                }

            }

        });
        $A.enqueueAction(getQuoteInfo);


    },
    loadProducts: function (component, helper) {
        component.set("v.showSpinnerSelProds", true);
        var quotewrap = component.get("v.wrap");

        var getProductsAction = component.get("c.getproducts1");
        getProductsAction.setParams({
            "quotewrap": quotewrap
        });
        getProductsAction.setCallback(this, function (response) {
            var actState = response.getState();
            if (actState === 'SUCCESS') {

                var resposeData = response.getReturnValue();
                console.log('resposeData--------' + JSON.stringify(resposeData));
                component.set("v.showSpinnerSelProds", false);
                if (resposeData != undefined && resposeData != '' && resposeData != null) {
                    console.log('Hi');
                    if (resposeData.length > 0) {
                        component.set("v.showProducts", true);
                    }

                    component.set("v.Allproduct", resposeData);
                    component.set("v.totalPages", Math.ceil(response.getReturnValue().length / component.get("v.pageSize")));
                    component.set("v.allData", response.getReturnValue());

                    component.set("v.totalRecordsCount", response.getReturnValue().length);

                    component.set("v.currentPageNumber", 1);
                    helper.buildData(component, helper);
                    /*var OutDiv = component.find("productDiv");
                    if(resposeData.length<5){
                        console.log('--no-hight---');
                        $A.util.addClass(OutDiv, "noheightClass");
                        //$A.util.removeClass(OutDiv, "heightClass");
                    }else{
                        $A.util.addClass(OutDiv, "heightClass");
                       // $A.util.removeClass(OutDiv, "noheightClass");
                    }*/

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
        var copyList = [];
        component.set("v.ProductCopyList", copyList);

        //creating data-table data
        for (; x < (pageNumber) * pageSize; x++) {
            pData = allData[x];
            if (pData) {
                pData.isSelected = false;
                if (selectedProductsIds.includes(pData.qlItem.Id)) {

                    pData.isSelected = true;
                }
                data.push(pData);
            }
        }
        component.set("v.ProductList", data);


        if (data.length > 0) {
            var selectCount = 0;
            for (var i = 0; i < data.length; i++) {
                if (data[i].isSelected == true) {
                    selectCount++;
                }
            }

            if (selectCount == pageSize || selectCount == i) {
                component.set("v.selectAll", true);

            } else {
                component.set("v.selectAll", false);
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
    searchHelperProdDir: function (component, event, getInputkeyWord) {

        var Action = component.get("c.getProductDirectorList");
        Action.setParams({
            "bidwrap": component.get("v.wrap")
        });



        Action.setCallback(this, function (response) {
            var actState = response.getState();
            if (actState === 'SUCCESS') {

                var resposeData = response.getReturnValue();
                component.set("v.defaultlistOfProductDirectors", resposeData);
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
            
            component.set("v.showSpinnerSelProds",true);
            var getProductsAction = component.get("c.finalSearchResult");
            
            
            getProductsAction.setParams({ pItem: selectedRecords, SearchKeyWordPD:SearchKeyWordPD,Family: searchFamily,searchName:searchText,RxSrxList:component.get("v.RxSrxList"),"quotewrap": component.get("v.wrap")});  
            
            
            
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

            
            var getProductsAction = component.get("c.finalSearchResult");
            
            
            getProductsAction.setParams({ "pItem": selectedRecords, 
                                         "SearchKeyWordPD":SearchKeyWordPD,
                                         "search": searchFilter,
                                         "searchName":searchName,
                                         "RxSrxList":component.get("v.RxSrxList"),
                                         "quotewrap": component.get("v.wrap")});  
            
            
            
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
    
    searchTablehelper: function (component,helper) {
        
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
            
            component.set("v.showSpinnerSelProds",true);
            var getProductsAction = component.get("c.finalSearchResult");
            
            
            getProductsAction.setParams({ pItem: selectedRecords, SearchKeyWordPD:SearchKeyWordPD,Family: searchFamily,searchName:searchText,RxSrxList:component.get("v.RxSrxList"),"quotewrap": component.get("v.wrap")});  
            
            
            
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
    sortHelper: function (component, event, sortFieldName) {
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
    sortHelperSelected: function (component, event, sortFieldName) {
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
        this.onSortResultSelected(component, event, sortFieldName);
	},
    onSortResultSelected: function (component, event, sortField) {
        console.log('sortField===>'+sortField);
          component.set("v.showSpinnerSelProds", true);
       var resList =[];
        resList = component.get("v.modalProductList");
        console.log('testing==>'+JSON.stringify(resList))
        var currentDir = component.get("v.isAsc");
        component.set("v.isAsc",!currentDir);
        console.log('sort console---'+!currentDir);
        //var key;
        if(sortField == 'Phoenix_Product__r.Name'){
            //sortField= ["qlItem"]["Phoenix_Product__r"]["Name"];
           var key = function(a) { return a["qlItem"]["Phoenix_Product__r"]["Name"] }
            
        }else if(sortField == 'Phoenix_Product_Code1__c'){
            console.log('in else statement')
          var  key = function(a) { return a["qlItem"]["Phoenix_Product__r"]["ProductCode"] }
        }
        else if(sortField == 'Phoenix_NDC__c'){
          var  key = function(a) { return a["qlItem"]["Phoenix_NDC__c"] }
        }
        else if(sortField == 'Product_Family__Name__c'){
          var  key = function(a) { return a["qlItem"]["Product_Family__Name__c"] }
        }
        var reverse = currentDir ? 1: -1;
        resList.sort(function(a,b){
                    var a = key(a) ? key(a) : '';
                    var b = key(b) ? key(b) : '';
                    return reverse * ((a>b) - (b>a));
                });
        component.set("v.modalProductList", resList);
        component.set("v.showSpinnerSelProds",false);
        
    },

    onSortResult: function (component, event, sortField) {
        //call apex class method
        component.set("v.showSpinnerSelProds", true);

        var action = component.get('c.fetchSortResults');
        var productList = [];
        //var productIds=[];
        productList = component.get("v.ProductList");
        //for(var i=0;i<productList.length;i++){

        //productIds.push(productList[i].prdlist.Id);
        // }


        // pass the apex method parameters to action
        action.setParams({
            'sortField': sortField,
            'isAsc': component.get("v.isAsc"),
            'productList': productList
        });
        action.setCallback(this, function (response) {
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.showSpinnerSelProds", false);

                //set response value in ListOfContact attribute on component.
                component.set("v.ProductList", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    searchRx: function (component, helper) {
        var picliList = component.get('v.RxSrxList');
        if (component.get("v.isRxChecked") && !picliList.includes('Rx')) {

            picliList.push('Rx');
        }
        if (component.get("v.isSRxChecked") && !picliList.includes('SRx')) {
            picliList.push('SRx');
        }
        if (component.get("v.isOtcChecked") && !picliList.includes('OTC')) {
            picliList.push('OTC');
        }
        if (component.get("v.isRxChecked") == false && picliList.includes('Rx')) {
            var ind = picliList.indexOf('Rx')
            picliList.splice(ind, 1);
        }
        if (component.get("v.isSRxChecked") == false && picliList.includes('SRx')) {
            var ind = picliList.indexOf('SRx')
            picliList.splice(ind, 1);
        }
        if (component.get("v.isOtcChecked") == false && picliList.includes('OTC')) {
            var ind = picliList.indexOf('OTC')
            picliList.splice(ind, 1);
        }
        component.set("v.RxSrxList", picliList);
        component.set("v.showSpinnerSelProds", true);
        var searchFamily = component.get("v.searchFamily");
        var searchName = component.get("v.searchText");
        var SearchKeyWordPD = component.get("v.lstSelectedPDRecords");
        if (component.get("v.RxSrxList").length > 0) {

            var action = component.get("c.findBySrxOtc");
            action.setParams({
                "searchKey": component.get("v.RxSrxList"),
                "SearchKeyWordPD": SearchKeyWordPD,
                "searchName": searchName,
                "family": searchFamily,
                "productList": component.get("v.Allproduct"),
                "quotewrap": component.get("v.wrap")
            });
            action.setCallback(this, function (a) {
                component.set("v.showSpinnerSelProds", false);
                var resposeData = a.getReturnValue();
                component.set("v.noData", false);
                component.set("v.ProductList", resposeData);
                //console.log('resposeData------'+resposeData);
                if (resposeData != null && resposeData != '' && resposeData != undefined) {

                    component.set("v.totalPages", Math.ceil(resposeData.length / component.get("v.pageSize")));
                    component.set("v.allData", resposeData);

                    component.set("v.currentPageNumber", 1);
                    helper.buildData(component, helper);
                } else {
                    console.log('resposeData in else------' + resposeData);
                    component.set("v.showSpinnerSelProds", false);

                    component.set("v.noData", true);

                }
            });
            $A.enqueueAction(action);
        } else {

            component.set("v.noData", false);
            var searchFamily = component.get("v.searchFamily");
            var searchName = component.get("v.searchText");
            console.log('searchName-------' + searchName);
            var SearchKeyWordPD = component.get("v.lstSelectedPDRecords");
            var RxSrxList = component.get("v.RxSrxList");

            //component.set("v.showSpinnerSelProds",true);
            if (!RxSrxList.length > 0) {
                if (searchName != null && searchName != 'undefined' && searchName != '') {
                    helper.searchTablehelper(component, helper);
                } else if (searchFamily != null && searchFamily != 'undefined' && searchFamily != '') {
                    helper.onsearchFamilyhelper(component, helper);
                } else if (SearchKeyWordPD.length > 0) {
                    helper.onsearchDirectorhelper(component, helper);
                } else if (RxSrxList.length > 0) {
                    helper.searchRx(component, helper);
                } else {
                    var resposeData = component.get("v.Allproduct");
                    component.set("v.totalPages", Math.ceil(resposeData.length / component.get("v.pageSize")));
                    component.set("v.allData", resposeData);

                    component.set("v.currentPageNumber", 1);
                    helper.buildData(component, helper);
                    component.set("v.showSpinnerSelProds", false);
                }
            }
        }
    },

})