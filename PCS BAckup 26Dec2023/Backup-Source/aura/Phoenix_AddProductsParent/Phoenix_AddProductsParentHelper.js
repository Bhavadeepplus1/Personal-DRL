({
    fetchContratcs : function(component, event, helper, bidCustomerId, searchInput) {
        component.set('v.isSpinnerLoad',true);       
        var message = event.getParam("message");
        console.log('bidCustomerId'+bidCustomerId);
        var action = component.get("c.getContracts");
        action.setParams({
            customerID: bidCustomerId,
            searchInput: searchInput
        });
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                var responseList = response.getReturnValue();
                console.log('---responseList---'+responseList.length);
                
                //below code is for remove seleceted while fetch contracts in table
                /*var sltcntcntrcs=component.get('v.selectedCntrcts');
                var finalContratcs = responseList.filter(comparer(sltcntcntrcs)); 
                function comparer(otherArray){
                    return function(current){
                        return otherArray.filter(function(other){
                            console.log('other---'+JSON.stringify(other));
                            console.log('current---'+JSON.stringify(current));
                            return other == current.Name 
                        }).length == 0;
                    }
                }
                component.set("v.contratcsList",finalContratcs);*/
                //component.set("v.contratcsList",responseList);
                component.set('v.filteredData', responseList);
                this.preparePagination(component, responseList);
                component.set('v.isSpinnerLoad',false);
            }
        });
        $A.enqueueAction(action);
    },
    
    getContractProducts: function(component, event, helper) {
        component.set('v.isSpinnerLoad',true);       
        var message = event.getParam("message");
        //console.log('bidCustomerId'+bidCustomerId);
        var action = component.get("c.getContractProducts");
        action.setParams({
            constractsIdList: component.get('v.selectedContratcsIdList')
        });
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                var responseList = response.getReturnValue();
                console.log('---responseList---'+responseList.length);
                
                //below code is for remove seleceted while fetch contracts in table
                /*var sltcntcntrcs=component.get('v.selectedCntrcts');
                var finalContratcs = responseList.filter(comparer(sltcntcntrcs)); 
                function comparer(otherArray){
                    return function(current){
                        return otherArray.filter(function(other){
                            console.log('other---'+JSON.stringify(other));
                            console.log('current---'+JSON.stringify(current));
                            return other == current.Name 
                        }).length == 0;
                    }
                }
                component.set("v.contratcsList",finalContratcs);*/
                //component.set("v.contratcsList",responseList);
                component.set('v.productsList', responseList);
                component.set('v.isSpinnerLoad',false);
            }
        });
        $A.enqueueAction(action);
    },
    
    preparePagination: function (component, responseList) {
        let countTotalPage = Math.ceil(responseList.length/component.get("v.pageSize"));
        let totalPage = countTotalPage > 0 ? countTotalPage : 1;
        component.set("v.totalPages", totalPage);
        component.set("v.currentPageNumber", 1);
        this.setPageDataAsPerPagination(component);
    },
 
    setPageDataAsPerPagination: function(component) {
        let data = [];
        let pageNumber = component.get("v.currentPageNumber");
        let pageSize = component.get("v.pageSize");
        let filteredData = component.get('v.filteredData');
        let x = (pageNumber - 1) * pageSize;
        for (; x < (pageNumber) * pageSize; x++){
            if (filteredData[x]) {
                data.push(filteredData[x]);
            }
        }
        component.set("v.contratcsList", data);
    },
    
    searchRecordsBySearchPhrase : function (component) {
        let searchPhrase = component.get("v.searchPhrase");
        if (!$A.util.isEmpty(searchPhrase)) {
            let allData = component.get("v.allData");
            let filteredData = allData.filter(record => record.title.includes(searchPhrase));
            component.set("v.filteredData", filteredData);
            this.preparePagination(component, filteredData);
        }
    },
})