({
    loadProducts: function (component, helper) {
        
        
         component.set("v.showSpinnerSelProds",true);
        var getProductsAction = component.get("c.getIPAproducts");
        getProductsAction.setParams({ "recordId": component.get("v.recordId") });
        getProductsAction.setCallback(this, function (response) {
            var actState = response.getState();
            if (actState === 'SUCCESS') {
               
                var resposeData = response.getReturnValue();
                
                var i = 0;
                
                
                
                if(resposeData!=undefined && resposeData!='' && resposeData!=null ){
                    if (resposeData.length > 0) {
                        component.set("v.showProducts", true);
                    }
                    else {
                        component.set("v.noProducts", true);
                    }
                    
                    console.log('showProduct-------'+component.get("v.showProducts"));
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
                else{
                    component.set("v.showNoProdcuts", true); 
                    var wrap=component.get("v.wrap");
                    if(wrap.bid.Phoenix_Bid_Type__c=='Mass Product Removals'||wrap.bid.Phoenix_Bid_Type__c=='Product Discontinuation Process'){
                        component.set("v.noProd",true);     
                    }
                }
              component.set("v.showSpinnerSelProds",false); 
            }
            else{
                  component.set("v.showSpinnerSelProds",false);
            }
        });
        $A.enqueueAction(getProductsAction);
    },
    
    /*
     * this function will build table data
     * based on current page selection
     * */
    buildData: function (component, helper) {
        
component.set("v.showSpinnerSelProds",true);
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
        
        
               component.set("v.showSpinner",false);
 
        helper.generatePageList(component, pageNumber);
    },
    
    /*
     * this function generate page list
     * */
    generatePageList: function (component, pageNumber) {
        window.scrollTo(0,0);
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
        
        
        if ((SearchKeyWordPD != null && SearchKeyWordPD != undefined &&SearchKeyWordPD != '' )) {
            
            component.set("v.showSpinnerSelProds",true);
            var getProductsAction = component.get("c.finalSearchResult");
            
            
           /* getProductsAction.setParams({ pItem: selectedRecords, SearchKeyWordPD:SearchKeyWordPD,Family: searchFamily,searchName:searchText,RxSrxList:component.get("v.RxSrxList"),"quotewrap": component.get("v.wrap")});  */
            getProductsAction.setParams({ pItem: selectedRecords,SearchKeyWordPD:SearchKeyWordPD,Family: searchFamily , searchName: searchText,RxSrxList:component.get("v.RxSrxList"),"quotewrap": component.get("v.wrap") });  

            
            
            getProductsAction.setCallback(this, function (response) {
                var actState = response.getState();
                
                
                if (actState === 'SUCCESS') {
                    component.set("v.showSpinnerSelProds",false);
                    var resposeData = response.getReturnValue();
                    if(resposeData==null ||resposeData==undefined||resposeData==''){
                        component.set("v.noData",true);  
                    }
                    
                    component.set("v.ProductList", resposeData);
                    component.set("v.allData", resposeData);
                    
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
            var resposeData=component.get("v.Allproduct");
            component.set("v.totalPages", Math.ceil(resposeData.length / component.get("v.pageSize")));
            component.set("v.allData", resposeData);
            
            component.set("v.currentPageNumber", 1);
            helper.buildData(component, helper);
        }
    },
   onsearchFamilyhelper: function (component, helper) {
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
        
       
            
            component.set("v.showSpinnerSelProds",true);
            var getProductsAction = component.get("c.finalSearchResult");
             if ((searchFilter != null && searchFilter != undefined && searchFilter != '' )) {
            
      /* getProductsAction.setParams({ pItem: selectedRecords,SearchKeyWordPD:SearchKeyWordPD, search: searchFilter,searchName:searchName,RxSrxList:component.get("v.RxSrxList"),
                                         "quotewrap": component.get("v.wrap")}); */
                 getProductsAction.setParams({ pItem: selectedRecords,SearchKeyWordPD:SearchKeyWordPD,Family: searchFamily , searchName: searchFilter,RxSrxList:component.get("v.RxSrxList"),"quotewrap": component.get("v.wrap") });  

          getProductsAction.setCallback(this, function (response) {
                var actState = response.getState();
                
                
                if (actState === 'SUCCESS') {
                    component.set("v.showSpinnerSelProds",false);
                    var resposeData = response.getReturnValue();
                    if(resposeData==null || resposeData==undefined || resposeData==''){
                        component.set("v.noData",true);  
                    }
                    
                    component.set("v.ProductList", resposeData);
                    component.set("v.allData", resposeData);
                    
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
            var resposeData=component.get("v.Allproduct");
            component.set("v.totalPages", Math.ceil(resposeData.length / component.get("v.pageSize")));
            component.set("v.allData", resposeData);
            
            component.set("v.currentPageNumber", 1);
            helper.buildData(component, helper);
        }
       
        
    },
    
    searchTablehelper: function (component,helper) {
        
        var allRecords = component.get("v.Allproduct");
        var searchFilter = component.get("v.searchText");
        var searchFamily = component.get("v.searchFamily");
        
           var SearchKeyWordPD = component.get("v.lstSelectedPDRecords");
         var selectedRecords = [];
        if(allRecords != undefined && allRecords.length > 0){
            allRecords.forEach(function(wr){
                if(wr.isSelected)
                	selectedRecords.push(wr);
            });
        }
        console.log('in searchTablehelper searchFilter-->'+selectedRecords)
        if ((searchFilter != null && searchFilter != undefined && searchFilter != '' )) {
            
            component.set("v.showSpinnerSelProds",true);
            var getProductsAction = component.get("c.finalSearchResult");
            
            
            getProductsAction.setParams({ pItem: selectedRecords,SearchKeyWordPD:SearchKeyWordPD,Family: searchFamily , searchName: searchFilter,RxSrxList:component.get("v.RxSrxList"),"quotewrap": component.get("v.wrap") });  
            
            
            
            getProductsAction.setCallback(this, function (response) {
                var actState = response.getState();
                
                
                if (actState === 'SUCCESS') {
                    
                    component.set("v.showSpinnerSelProds",false);
                    var resposeData = response.getReturnValue();
                    console.log('response -->'+JSON.stringify(resposeData))
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
                    
                }
                else{
                    component.set("v.showSpinnerSelProds",false);
                    console.log('error--')
                }
            });
            $A.enqueueAction(getProductsAction);
        }
        else{
            var resposeData=component.get("v.Allproduct");
            component.set("v.totalPages", Math.ceil(resposeData.length / component.get("v.pageSize")));
            component.set("v.allData", resposeData);
            component.set("v.showSpinnerSelProds",false);
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
                component.set("v.showSpinnerSelProds",false);
                
                //set response value in ListOfContact attribute on component.
                component.set("v.ProductList", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    sortContrHelper: function(component, event, sortFieldName) {
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
        this.onSortContrResult(component, event, sortFieldName);
    },
    
    onSortContrResult: function(component, event, sortField) {
        //call apex class method
        component.set("v.showSpinnerSelProds",true);
        
        var action = component.get('c.fetchContrSortResults');
        var contractList=[];
        //var productIds=[];
        contractList=component.get("v.contractList");
        
        
        
        // pass the apex method parameters to action
        action.setParams({
            'sortField': sortField,
            'isAsc': component.get("v.isAsc"),
            'contractList':contractList
        });
        action.setCallback(this, function(response) {
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.showSpinnerSelProds",false);
                
                //set response value in ListOfContact attribute on component.
                component.set("v.contractList", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    getContractData: function(component,helper) {
        var action = component.get('c.getContractData');
        component.set("v.noContrData",false);  
        var data;
        var contrData=[];
        var selectedContractIds=component.get("v.selectedContractIds");
        component.set("v.showContracts",true);
        component.set("v.showSelectedProducts", false);
        component.set("v.showSpinnerSelProds",true);
        var arry=component.get("v.contractCopyList");
        action.setParams({"prodIds":component.get("v.selectedProductsIds"),
                          "quotewrap":component.get("v.wrap")
                          
                          
                         });
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            if (state === "SUCCESS") {
                
                
                var response=response.getReturnValue();
                console.log('response -----'+response); 
                
                component.set("v.showContracts",true);
                component.set("v.showSpinnerSelProds",false);
                if(response!=null && response!=undefined && response!=''){
                    component.set("v.noContrData",false);  
                    console.log('noContrData -----'+component.get("v.noContrData"));
                    //component.set("v.contractList",response);
                    component.set("v.totalPages1", Math.ceil(response.length/ component.get("v.pageSize")));
                    console.log('totalPages1 -----'+component.get("v.totalPages1"));
                    component.set("v.allContracts", response);
                    component.set("v.currentPageNumber1", 1);
                    helper.buildContractData(component, helper);
                    
                }
                else{
                    var res=[];
                    component.set("v.noContrData",true); 
                    component.set("v.contractList",res);
                }
                console.log('noContrData -----'+component.get("v.noContrData"));
                
                
                
            }
            else{
                component.set("v.showSpinnerSelProds",false);
            }
            
            
        });
        $A.enqueueAction(action);
        
        
    },

    buildContractData: function (component, helper) {
        var data = [];
        let selectedContractIds = component.get("v.selectedContractIds");
        console.log("%c--------selectedContractIds-------" + selectedContractIds, "background-color:red;color:white;");
        var pageNumber = component.get("v.currentPageNumber1");
        var pageSize = component.get("v.pageSize");
        var allData = component.get("v.allContracts");
        var x = (pageNumber - 1) * pageSize;
        var pData;
        // var copyList=[];
        //component.set("v.ProductCopyList",copyList);
        
        //creating data-table data
        for (; x < (pageNumber) * pageSize; x++) {
            pData = allData[x];
            if (pData) {
                pData.contrFlag = false;
                if (selectedContractIds.includes(pData.npr.Id)) {
                    
                    pData.contrFlag = true;
                    console.log('pData.contrFlag'+pData.contrFlag);
                }
                data.push(pData);
            }
        }
        component.set("v.contractList", data);
        
        if(data.length>0){
            var selectCount=0;
            for(var i=0;i<data.length;i++){
                if(data[i].contrFlag==true){
                    selectCount++;
                }
            }
            
            if(selectCount==pageSize ||selectCount==i){
                component.set("v.selectAllContr",true);  
                
            }
            else{
                component.set("v.selectAllContr",false); 
            }
        }
        
        
        
        helper.generateContrPageList(component, pageNumber);
    },
    generateContrPageList: function (component, pageNumber) {
        pageNumber = parseInt(pageNumber);
        var pageList = [];
        var totalPages = component.get("v.totalPages1");
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
        component.set("v.pageList1", pageList);
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
         var allRecords = component.get("v.Allproduct");
        var searchFamily = component.get("v.searchFamily");
        var searchName=component.get("v.searchText");
         var SearchKeyWordPD = component.get("v.lstSelectedPDRecords");
         var selectedRecords = [];
        if(allRecords != undefined && allRecords.length > 0){
            allRecords.forEach(function(wr){
                if(wr.isSelected)
                    selectedRecords.push(wr);
            });
        }
        if(component.get("v.RxSrxList").length > 0 ){
            
            
            
              
            var action = component.get("c.finalSearchResult");
         /*   action.setParams({
                "searchKey": component.get("v.RxSrxList"),
                "SearchKeyWordPD":SearchKeyWordPD,
                "searchName":searchName,
                "family":searchFamily,
                "productList" :component.get("v.Allproduct")
            });*/
                        action.setParams({ pItem: selectedRecords, SearchKeyWordPD:SearchKeyWordPD,Family: searchFamily,searchName:searchName,RxSrxList:component.get("v.RxSrxList"),"quotewrap": component.get("v.wrap")});  

            action.setCallback(this, function(a) {
                component.set("v.showSpinnerSelProds",false);
                var resposeData =a.getReturnValue();
                component.set("v.noData",false);  
                component.set("v.ProductList", resposeData);
             
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
         component.set("v.showSpinnerSelProds",false);
            
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
    getDocumentForBid: function(component, helper) {
     var action = component.get('c.getExistingDocs');
        action.setParams({'bidId' : component.get("v.recordId")});
         
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log(state)
            console.log(state)
            if (state === "SUCCESS") {
                var fileList=[];
                var totalFiles=[];
                var checked=false;
               totalFiles=response.getReturnValue();
                if(totalFiles!=undefined&&totalFiles!=null && totalFiles!='')
                {
                    for(var i=0;i<totalFiles.length;i++)
                    {
                         console.log('---33333333---1-----');
                      fileList.push({"Id":totalFiles[i].ContentDocumentId,"Title":totalFiles[i].ContentDocument.Title+'.'+totalFiles[i].ContentDocument.FileExtension,"checked":checked});
                    }
                }
                console.log('------1-----');
               component.set("v.fileList",fileList);
                 component.set("v.showFiles",true);
                console.log('------1--2---'+JSON.stringify(response.getReturnValue()));
            }  
            if(state === "ERROR"){
               // component.set("v.isTSNotCreated","true");
            } 
            
        });
        $A.enqueueAction(action);
     } ,   
    
     handleUploadFinished : function(component, event) {
        
        var action = component.get('c.getDocs');
        action.setParams({'bidId' : component.get("v.recordId")});
         
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log(state)
            console.log(state)
            if (state === "SUCCESS") {
                var fileList=[];
                var totalFiles=[];
                var checked=false;
               totalFiles=response.getReturnValue();
                if(totalFiles!=undefined&&totalFiles!=null && totalFiles!='')
                {
                    for(var i=0;i<totalFiles.length;i++)
                    {
                         console.log('---33333333---1-----');
                      fileList.push({"Id":totalFiles[i].ContentDocumentId,"Title":totalFiles[i].ContentDocument.Title+'.'+totalFiles[i].ContentDocument.FileExtension,"checked":checked});
                    }
                }
                console.log('------1-----');
               component.set("v.fileList",fileList);
                 component.set("v.showFiles",true);
                console.log('------1--2---'+JSON.stringify(response.getReturnValue()));
            }  
            if(state === "ERROR"){
               // component.set("v.isTSNotCreated","true");
            } 
            
        });
        $A.enqueueAction(action);
     } ,
})