({
    searchTablehelper : function(component, event, helper) {
        var action;
        if(component.get("v.bidType") == 'RFP Bids'){
            action = component.get("c.getRFPBids");
        } else{
         	action = component.get("c.getBids");   
        }
        action.setParams({
            'searchText': component.get("v.searchText")
        });
        action.setCallback(this, function(response){
            if(response.getState() == 'SUCCESS'){
                var response = response.getReturnValue();
                var selIds = component.get("v.selectedBidIds");
                if(response != null){
                    for(var i=0; i<response.length; i++){
                        if(response[i].Phoenix_Bid_Submitted_Date__c){
                            response[i].formattedSubmittedDate = new Date(response[i].Phoenix_Bid_Submitted_Date__c).toLocaleDateString("en-US", { year: "numeric", month: "2-digit", day: "2-digit" });
                        }   
                        if(selIds.includes(response[i].Id)){
                            response[i].isSelected = true;
                            continue; 
                        } else{
                            response[i].isSelected = false;
                        }
                    }
                }
                component.set("v.BidList", response);
                component.set("v.totalPages", Math.ceil(response.length / component.get("v.pageSize")));
                component.set("v.allData", response);
                component.set("v.totalRecordsCount", response.length);
                component.set("v.currentPageNumber", 1);
                component.set("v.showProducts", true);
                component.set("v.showSpinnerSelProds", false);
                this.buildData(component, event, helper);
            } else{
                component.set("v.showSpinnerSelProds", false);
                console.log("Error: "+JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);
    },
    buildData: function (component, event, helper) {
        var scrollOptions = {
            left: 0,
            top: 0,
            behavior: 'smooth'
        }
        window.scrollTo(scrollOptions);
        var data = [];
        let selectedBidIds = component.get("v.selectedBidIds");
        var pageNumber = component.get("v.currentPageNumber");
        var pageSize = component.get("v.pageSize");
        var allData = component.get("v.allData");
        var x = (pageNumber - 1) * pageSize;
        var pData;
        var copyList=[];
        component.set("v.BidCopyList",copyList);
        //creating data-table data
        for (; x < (pageNumber) * pageSize; x++) {
            pData = allData[x];
            if (pData) {
                pData.isSelected = false;
                if (selectedBidIds.includes(pData.Id)) {
                    pData.isSelected = true;
                }
                data.push(pData);
            }
        }
        component.set("v.BidList", data);
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
        this.generatePageList(component, pageNumber, false);
    },
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
        var BidList=component.get("v.BidList");
        // pass the apex method parameters to action
        action.setParams({
            'sortField': sortField,
            'isAsc': component.get("v.isAsc"),
            'bidList':BidList
        });
        action.setCallback(this, function(response) {
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") {
                //set response value in ListOfContact attribute on component.
                var response = response.getReturnValue();
                if(response != null){
                    for(var i=0; i<response.length; i++){
                        if(response[i].Phoenix_Bid_Submitted_Date__c){
                            response[i].formattedSubmittedDate = new Date(response[i].Phoenix_Bid_Submitted_Date__c).toLocaleDateString("en-US", { year: "numeric", month: "2-digit", day: "2-digit" });
                        }   
                    }
                }
                component.set("v.BidList", response);
                component.set("v.showSpinnerSelProds",false);
            }
        });
        $A.enqueueAction(action);
    },
})