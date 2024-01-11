({
    loadProducts: function (component, helper) {
        
        
        
        var getProductsAction = component.get("c.getIPAproducts");
        getProductsAction.setParams({ "recordId": component.get("v.recordId") });
        getProductsAction.setCallback(this, function (response) {
            var actState = response.getState();
            if (actState === 'SUCCESS') {
                component.set("v.showSpinnerSelProds",false);
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
                    if(wrap.bid.Phoenix_Bid_Type__c=='SRx IPA Price Change'||wrap.bid.Phoenix_Bid_Type__c=='SRx IPA Product Addition'){
                        component.set("v.noProd",true);    
                    }
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
        
        var searchText=component.get("v.searchText");
        var SearchKeyWordPD = component.get("v.lstSelectedPDRecords");
        
        
        
        if (SearchKeyWordPD != null && SearchKeyWordPD != undefined &&SearchKeyWordPD != '' ) {
            
            component.set("v.showSpinnerSelProds",true);
            var getProductsAction = component.get("c.getsearchDirectorResult");
            
            
            getProductsAction.setParams({ pItem: allRecords, 
                                         SearchKeyWordPD:SearchKeyWordPD,
                                         
                                         searchName:searchText,
                                         
                                         "quotewrap": component.get("v.wrap")});  
            
            
            
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
    searchTablehelper: function (component,helper) {
        
        var allRecords = component.get("v.Allproduct");
        
        
        var SearchKeyWordPD = component.get("v.lstSelectedPDRecords");
        var searchFilter = component.get("v.searchText");
        
        
        if (searchFilter != null && searchFilter != undefined &&searchFilter != '' ) {
            
            component.set("v.showSpinnerSelProds",true);
            var getProductsAction = component.get("c.getSearch");
            
            getProductsAction.setParams({ pItem: allRecords,
                                         SearchKeyWordPD:SearchKeyWordPD,
                                         search: searchFilter,
                                         quotewrap:component.get("v.wrap")
                                        });  
            
            
            
            getProductsAction.setCallback(this, function (response) {
                var actState = response.getState();
                
                
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
       // contractList=component.get("v.contractList");
         contractList=component.get("v.allContracts");
        
        
        
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
                //component.set("v.contractList", response.getReturnValue());
                var response=response.getReturnValue();
                component.set("v.allContracts", response);
                component.set("v.totalPages1", Math.ceil(response.length/ component.get("v.pageSize")));
                this.buildContractData(component, helper);
            
            
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
        console.log('pageNumber'+pageNumber);
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
                if (selectedContractIds.includes(pData.contrt.Id)) {
                    
                    pData.contrFlag = true;
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
        
        
        
        this.generateContrPageList(component, pageNumber);
        
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
})