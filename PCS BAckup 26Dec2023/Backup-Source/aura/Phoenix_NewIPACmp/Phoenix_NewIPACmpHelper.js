({
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
          Action.setParams({ });  
            
            
            
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
            
            component.set("v.showSpinner",true);
            var getProductsAction = component.get("c.getsearchDirectorResult");
            
            
            getProductsAction.setParams({ pItem: allRecords, 
                                         SearchKeyWordPD:SearchKeyWordPD,
                                         
                                         searchName:searchText
                                         
                                        });  
            
            
            
            getProductsAction.setCallback(this, function (response) {
                var actState = response.getState();
                
                
                if (actState === 'SUCCESS') {
                    component.set("v.showSpinner",false);
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
                    component.set("v.showSpinner",false); 
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
            
            component.set("v.showSpinner",true);
            var getProductsAction = component.get("c.getSearch");
            
             getProductsAction.setParams({ pItem: allRecords,
                                          SearchKeyWordPD:SearchKeyWordPD,
                                          search: searchFilter });  
                  
            
            
            getProductsAction.setCallback(this, function (response) {
                var actState = response.getState();
                
                
                if (actState === 'SUCCESS') {
                    
                    component.set("v.showSpinner",false);
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
                    component.set("v.showSpinner",false);
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
        component.set("v.showSpinner",true);
        
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
                component.set("v.showSpinner",false);
                
                //set response value in ListOfContact attribute on component.
                component.set("v.ProductList", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
})