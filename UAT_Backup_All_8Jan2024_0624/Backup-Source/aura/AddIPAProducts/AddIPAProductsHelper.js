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
    loadProducts: function (component, helper) {



        var getProductsAction = component.get("c.getIPAproducts");
        getProductsAction.setParams({
            "recordId": component.get("v.recordId")
        });
        getProductsAction.setCallback(this, function (response) {
            var actState = response.getState();
            if (actState === 'SUCCESS') {
                component.set("v.showSpinnerSelProds", false);
                var resposeData = response.getReturnValue();

                var i = 0;



                if (resposeData != undefined && resposeData != '' && resposeData != null) {
                    if (resposeData.length > 0) {
                        component.set("v.showProducts", true);
                    } else {
                        component.set("v.noProducts", true);
                    }

                    console.log('showProduct-------' + component.get("v.showProducts"));
                    component.set("v.Allproduct", resposeData);
                    component.set("v.totalPages", Math.ceil(response.getReturnValue().length / component.get("v.pageSize")));
                    component.set("v.allData", response.getReturnValue());

                    component.set("v.totalRecordsCount", response.getReturnValue().length);

                    if (component.get("v.totalRecordsCount") == 0)
                        component.set("v.noProducts", true);
                    else {
                        component.set("v.noProducts", false);
                    }



                    component.set("v.currentPageNumber", 1);
                    helper.buildData(component, helper);




                } else {
                    component.set("v.showNoProdcuts", true);
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
        var copyList = [];
        component.set("v.ProductCopyList", copyList);

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
        //var searchName=component.get("v.searchText");
        //var searchFamily=component.get("v.searchFamily");

        // if(searchName!=null && searchName!=''&&searchName!=undefined&&searchFamily!=null &&searchFamily!=''&&searchFamily!=undefined&&data!=null&&data!=''&&data!=undefined){
        // component.set("v.ProductCopyList",data);  
        //}
        //console.log('ProductCopyList length--'+component.get("v.ProductCopyList").length);
        //else{
        //component.set("v.ProductCopyList",[]);    
        //}

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


    searchTablehelper: function (component, helper) {

        var allRecords = component.get("v.Allproduct");
        var allRecords1 = component.get("v.ProductList");

        var productCopyList = [];
        var searchFilter = component.get("v.searchText");
        var searchFamily = component.get("v.searchFamily");

        if ((searchFilter != null && searchFilter != undefined && searchFilter != '') || (searchFamily != null && searchFamily != undefined && searchFamily != '')) {

            component.set("v.showSpinnerSelProds", true);
            var getProductsAction = component.get("c.getSearch");
            if (searchFamily != null && searchFamily != undefined && searchFamily != '') {

                if (searchFilter == '' || searchFilter == undefined || searchFilter == null) {
                    getProductsAction.setParams({
                        pItem: allRecords,
                        search: searchFamily
                    });
                } else {
                    productCopyList = component.get("v.ProductCopyList");
                    if (allRecords1 == null || allRecords1 == '' || allRecords1 == undefined) {
                        console.log('ProductCopyList len' + productCopyList.length);
                        getProductsAction.setParams({
                            pItem: productCopyList,
                            search: searchFilter
                        });
                    } else {
                        getProductsAction.setParams({
                            pItem: allRecords1,
                            search: searchFilter
                        });
                    }

                }
            } else {

                getProductsAction.setParams({
                    pItem: allRecords,
                    search: searchFilter
                });
            }


            getProductsAction.setCallback(this, function (response) {
                var actState = response.getState();


                if (actState === 'SUCCESS') {

                    component.set("v.showSpinnerSelProds", false);
                    var resposeData = response.getReturnValue();
                    if (resposeData == null || resposeData == undefined || resposeData == '') {
                        component.set("v.noData", true);
                    }

                    component.set("v.ProductList", resposeData);


                    if (resposeData != null && resposeData != undefined && resposeData != '') {
                        if (resposeData.length > 0) {
                            component.set("v.noData", false);
                            component.set("v.totalPages", Math.ceil(resposeData.length / component.get("v.pageSize")));
                            component.set("v.allData", resposeData);

                            component.set("v.currentPageNumber", 1);
                            helper.buildData(component, helper);
                        }
                    }

                } else {
                    component.set("v.showSpinnerSelProds", false);
                }
            });
            $A.enqueueAction(getProductsAction);
        } else {
            helper.loadProducts(component, helper);
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
    sortContrHelper: function (component, event, sortFieldName) {
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

    onSortContrResult: function (component, event, sortField) {
        //call apex class method
        component.set("v.showSpinnerSelProds", true);

        var action = component.get('c.fetchContrSortResults');
        var contractList = [];
        //var productIds=[];
        contractList = component.get("v.contractList");
        //for(var i=0;i<productList.length;i++){

        //productIds.push(productList[i].prdlist.Id);
        // }


        // pass the apex method parameters to action
        action.setParams({
            'sortField': sortField,
            'isAsc': component.get("v.isAsc"),
            'contractList': contractList
        });
        action.setCallback(this, function (response) {
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.showSpinnerSelProds", false);

                //set response value in ListOfContact attribute on component.
                component.set("v.contractList", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    getContractData: function (component, helper) {
        var action = component.get('c.getContractData');
        component.set("v.noContrData", false);
        var data;
        var contrData = [];
        var selectedContractIds = component.get("v.selectedContractIds");
        component.set("v.showSpinnerSelProds", true);
        var arry = component.get("v.contractCopyList");
        action.setParams({
            "prodIds": component.get("v.selectedProductsIds"),
            "quotewrap": component.get("v.wrap")


        });
        action.setCallback(this, function (response) {

            var state = response.getState();
            if (state === "SUCCESS") {


                var response = response.getReturnValue();
                console.log('response -----' + response);

                component.set("v.showContracts", true);
                component.set("v.showSpinnerSelProds", false);
                if (response != null && response != undefined && response != '') {
                    component.set("v.noContrData", false);
                    console.log('noContrData -----' + component.get("v.noContrData"));


                    component.set("v.contractList", response);

                } else {
                    var res = [];
                    component.set("v.noContrData", true);
                    component.set("v.contractList", res);
                }
                console.log('noContrData -----' + component.get("v.noContrData"));
                var contrList = component.get("v.contractList");
                for (var x = 0; x < contrList.length; x++) {
                    data = contrList[x];
                    data.contrFlag = false;
                    if (selectedContractIds.includes(data.contrt.Id)) {

                        data.contrFlag = true;

                    }
                    contrData.push(data);

                }
                component.set("v.contractList", contrData);


            } else {
                component.set("v.showSpinnerSelProds", false);
            }


        });
        $A.enqueueAction(action);


    },
})