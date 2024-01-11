({
	
    //JS Helper for Contracts View
    fetchContratcs : function(component, event, helper, bCustomerId, searchInput) {
        component.set('v.isSpinnerLoad',true);       
        //var message = event.getParam("message");
        console.log('bCustomerId::'+bCustomerId);
        var templateType = component.get("v.templateType");//("v.accObj.Phoenix_Customer_Class_Bid_Template__c");
        var action = component.get("c.getContracts");
        action.setParams({
            customerID: component.get("v.accObj.Id"),
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
                this.doInitHelper(component, resList,helper);
                component.set('v.isSpinner',false);
            }
            else{
                console.log('ERROR ---> '+JSON.stringify(response.getError()));
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
})