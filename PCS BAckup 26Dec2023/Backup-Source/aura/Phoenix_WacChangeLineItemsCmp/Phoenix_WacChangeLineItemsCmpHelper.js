({
    helperMethod : function() {
        
    },
    convertArrayOfObjectsToCSV: function (component, objectRecords) {
        // declare variables
        var csvStringResult, counter, keys, columnDivider, lineDivider;
        
        // check if "objectRecords" parameter is null, then return from function
        if (objectRecords == null || !objectRecords.length) {
            return null;
        }
        // store ,[comma] in columnDivider variabel for sparate CSV values and 
        // for start next line use '\n' [new line] in lineDivider varaible  
        columnDivider = ',';
        lineDivider = '\n';
        
        // in the keys valirable store fields API Names as a key 
        // this labels use in CSV file header 
        csvStringResult = '';
        var myMap = new Map();
        
        myMap.set("Contr.Number", "Phoenix_Contr_Number__c"); 
        myMap.set("Contr.IntDesc", "Phoenix_Contr_IntDesc__c");
        
        myMap.set("Cust Name", "Phoenix_Cust_Name__c");
        myMap.set("Matl No", "Phoenix_Matl_No__c");
        
        myMap.set("Product", "Phoenix_Product__r.Name");
        myMap.set("Cust Number", "Phoenix_Cust_Number__c");
        myMap.set("Description", "Phoenix_Description__c");
        myMap.set("Product Family", "Phoenix_Product_Family__c");
        myMap.set("NDC11", "Phoenix_NDC11__c");
        
        
        
        
        myMap.set("Account Name", "Phoenix_Account__r.Name");
        
        myMap.set("NPR", "Phoenix_NPR__r.Name");
        
        myMap.set("System WAC", "Phoenix_System_WAC__c");
        myMap.set("System Contract Price", "Phoenix_System_Contract_price__c");
        myMap.set("Uploaded WAC", "Phoenix_Uploaded_WAC__c");
        myMap.set("Uploaded Contr.Price", "Phoenix_Uploaded_Contr_Price__c");
        myMap.set("Sys WAC Vs Uploaded WAC", "Phoenix_SysWAC_Vs_UploadedWAC__c");
        myMap.set("Sys Contr.Price Vs Uploaded Contr.Price", "Phoenix_SysContPrice_Vs_UploadContrPrice__c");
        myMap.set("Proposed WAC", "Phoenix_Proposed_WAC__c");
        
        myMap.set("Proposed Contr.Price", "Phoenix_Proposed_Contr_Price__c");
        myMap.set("Sys WAC Vs Proposed WAC", "Phoenix_Sys_WAC_Vs_Proposed_WAC__c");
        myMap.set("Sys Contr.Price Vs Proposed Contr.Price", "Phoenix_SysContrPrice_Vs_PropContrPrice__c");
        myMap.set("Comments", "Phoenix_Comments__c");
        myMap.set("Head of PM Group Approval", "Phoenix_Head_of_PM_Group_Approval__c");
        myMap.set("Head of PM Remarks", "Phoenix_Head_of_PM_Comments__c");
        myMap.set("Contracts Approval", "Phoenix_Contracts_Approval__c");
        myMap.set("Contracts Comments", "Phoenix_Contracts_Comments__c");
        myMap.set("Offer Letter Sent", "Phoenix_Offer_Letter_Sent__c");
        myMap.set("Date Offer Sent", "Phoenix_Date_Offer_Sent__c");
        
        myMap.set("Customer Approval", "Phoenix_Customer_Update_Approval__c");
        myMap.set("Customer Response Date", "Phoenix_Customer_Response_Date__c");
        myMap.set("Customer Remarks", "Phoenix_Customer_Update_Remarks__c");
        myMap.set("Vistex  Approval", "Phoenix_Vistex_Update_Approval__c");
        myMap.set("Date Posted in Vistex", "Phoenix_Date_Posted_in_Vistex__c");
        myMap.set("Vistex Remarks", "Phoenix_Vistex_Remarks__c");
        myMap.set("WAC Change Line Number", "Name");
        
        
        csvStringResult += Array.from(myMap.keys()).join(columnDivider);
        csvStringResult += lineDivider;
        for(var i=0; i < objectRecords.length; i++){  
            counter = 0;
            for (let [key, value] of myMap) {
                if(counter > 0){ 
                    csvStringResult += columnDivider; 
                }
                console.log('testing result--->'+JSON.stringify(objectRecords[i]));
                
                if('Phoenix_Account__r' in objectRecords[i]){
                    if(value == "Phoenix_Account__r.Name" && objectRecords[i]["Phoenix_Account__r"]["Name"] != undefined){
                        csvStringResult += '"' + objectRecords[i]["Phoenix_Account__r"]["Name"]+ '"';
                        console.log('csvStringResult---------'+csvStringResult);
                        
                    }
                }
                
                
                if('Phoenix_NPR__r' in objectRecords[i]){
                    if(value == "Phoenix_NPR__r.Name" && objectRecords[i]["Phoenix_NPR__r"]["Name"] != undefined){
                        csvStringResult += '"' + objectRecords[i]["Phoenix_NPR__r"]["Name"]+ '"';
                    }
                }
                if('Phoenix_Product__r' in objectRecords[i]){
                    if(value == "Phoenix_Product__r.Name" && objectRecords[i]["Phoenix_Product__r"]["Name"] != undefined){
                        csvStringResult += '"' + objectRecords[i]["Phoenix_Product__r"]["Name"]+ '"';
                    }
                }
                
                if(value != 'Phoenix_Product__r.Name' && value != 'Phoenix_NPR__r.Name' && value != 'Phoenix_Account__r.Name'){
                    if(objectRecords[i][value]==undefined){
                        csvStringResult += '"'+''+'"';
                    }
                    else{
                        csvStringResult += '"'+ objectRecords[i][value]+'"';
                    }
                }        
                
                counter++;
            }
            csvStringResult += lineDivider;
        }
        //new logic end 
        return csvStringResult;
    },
    submitForProceed : function(component,event,helper,isFinance,isContracts,isCustomer,isVistex){ 
        component.set('v.isSpinnerLoad',true);
        
        var action = component.get("c.submitToProceddStep1");      
        action.setParams
        ({
            bidId:component.get("v.recordId")
            
        });
        action.setCallback(this, function(response) 
                           {
                               if (response.getState() === "SUCCESS") {
                                   //component.set('v.isSpinnerLoad',false);
                                   var ResultData = response.getReturnValue();
                                   var resultlength=ResultData.length;
                                   console.log('resultslength--'+resultlength);
                                   var isApproved = false;
                                   
                                   
                                   var approveStatusFlag=false;//for step staus ==>false:'rejected' ;true:'approved'
                                   if(resultlength==0){
                                       isApproved = true;
                                   }
                                   
                                   
                                   else{                                
                                       
                                       if(isFinance){
                                           ResultData.forEach(function(line){
                                               
                                               if(line['Phoenix_Head_of_PM_Group_Approval__c'] == 'None' || line['Phoenix_Head_of_PM_Group_Approval__c'] == '' || line['Phoenix_Head_of_PM_Group_Approval__c'] == null || line['Phoenix_Head_of_PM_Group_Approval__c'] == 'undefined' ){
                                                   isApproved = true;
                                                   
                                               }
                                               if(line['Phoenix_Head_of_PM_Group_Approval__c']=='Approved'){
                                                   approveStatusFlag=true;  
                                               } 
                                           });
                                           
                                       }
                                       else if(isContracts){
                                           ResultData.forEach(function(line){
                                               if(line['Phoenix_Contracts_Approval__c'] == 'None' || line['Phoenix_Contracts_Approval__c'] == '' || line['Phoenix_Contracts_Approval__c'] == null || line['Phoenix_Contracts_Approval__c'] == 'undefined'){
                                                   isApproved = true;
                                                   
                                               }
                                               if(line['Phoenix_Contracts_Approval__c']=='Processed'){
                                                   approveStatusFlag=true;  
                                               } 
                                               
                                               
                                           });
                                           
                                       }
                                           else if(isCustomer){
                                               ResultData.forEach(function(line){
                                                   if(line['Phoenix_Customer_Update_Approval__c'] == 'None' || line['Phoenix_Customer_Update_Approval__c'] == '' || line['Phoenix_Customer_Update_Approval__c'] == null || line['Phoenix_Customer_Update_Approval__c'] == 'undefined' ){
                                                       isApproved = true;
                                                       
                                                   }
                                                   if(line['Phoenix_Customer_Update_Approval__c']=='Accepted'){
                                                       approveStatusFlag=true;  
                                                   } 
                                                   
                                               });
                                               
                                           }
                                       
                                               else {
                                                   if(isVistex){
                                                       ResultData.forEach(function(line){
                                                           if(line['Phoenix_Vistex_Update_Approval__c'] == 'None' || line['Phoenix_Vistex_Update_Approval__c'] == '' || line['Phoenix_Vistex_Update_Approval__c'] == null || line['Phoenix_Vistex_Update_Approval__c'] == 'undefined' ){
                                                               isApproved = true;
                                                               
                                                           }
                                                           if(line['Phoenix_Vistex_Update_Approval__c']=='Updated' ||line['Phoenix_Vistex_Update_Approval__c']=='Not updated' ){
                                                               approveStatusFlag=true;  
                                                           }
                                                           
                                                           
                                                       });  
                                                   }
                                               }
                                   }
                                   
                                   if(isApproved == true){
                                        component.set('v.isSpinnerLoad',false);
                                       var toastEvent = $A.get("e.force:showToast");
                                       toastEvent.setParams({
                                           "type":"warning",
                                           "title": "Failed!",
                                           "message": "Please confirm each approval to proceed further"
                                       });
                                       toastEvent.fire();
                                       
                                   }
                                   
                                   else{
                                       // if(isSCM || isFinance || isApproved==false ){
                                       //console.log('In MarkApprovals');
                                       helper.MarkApprovals(component,event,helper,ResultData,approveStatusFlag,isFinance,isContracts,isCustomer,isVistex);  
                                         component.set('v.isSpinnerLoad',false);
                                       //}
                                       //else{
                                       // helper.MarkContractApprovals(component,event,helper,ResultData,approveStatusFlag);  
                                       // }
                                   }
                                   
                               }
                               else{
                                   component.set('v.isSpinnerLoad',false);
                                   var toastEvent = $A.get("e.force:showToast");
                                   toastEvent.setParams({
                                       "type":"error",
                                       "title": "error!",
                                       "message": "Something went wrong,please contact admin."
                                   });
                                   toastEvent.fire();
                               }
                               
                           });
        $A.enqueueAction(action);
    },
    
    
    MarkApprovals: function(component,event,helper,ResultData,approveStatusFlag,isFinance,isContracts,isCustomer,isVistex){
        console.log('isFinance---'+isFinance);
        console.log('component.get("v.recordId")---'+component.get("v.recordId"));
        console.log('isContracts---'+isContracts);
        console.log('isCustomer---'+isCustomer);
        console.log('approveStatusFlag---'+approveStatusFlag);
        console.log('isVistex---'+isVistex);
        console.log('ResultData---'+JSON.stringify(ResultData));
        var action = component.get("c.makeApprovals");
        console.log('isFinance1---'+isFinance);
        action.setParams({
            bidId : component.get("v.recordId"),
            bidlines:ResultData,
            approveStatusFlag:approveStatusFlag,
            isFinance:isFinance,
            isContracts:isContracts,
            isCustomer:isCustomer,
            isVistex:isVistex
        });
        console.log('isFinance2---'+isFinance);
        action.setCallback(this, function (response){
            console.log('isFinance3---'+isFinance);
            if(response.getState() === "SUCCESS"){
                console.log('isFinance4---'+isFinance);
                var wrapNextSteps=response.getReturnValue();
                var marketStepLsit=wrapNextSteps.updateProcessStepList;
                
                var vistexNextStepFlag=wrapNextSteps.contractNextStepFlag;
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type":"success",
                    "title": "Success",
                    "message": "Your Approvals are submitted successfully."
                });
                toastEvent.fire();//updateNextProcessSteps
                
                helper.UpdateNextSteps(component,event,helper,ResultData,marketStepLsit,vistexNextStepFlag,isFinance,isContracts,isCustomer,isVistex); 
                
                $A.get('e.force:refreshView').fire();
            }
            else{
                toastEvent.setParams({
                    "type":"error",
                    "title": "error!",
                    "message": "Something went wrong,please contact admin."
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
        
    },
    MarkContractApprovals: function(component,event,helper,ResultData,approveStatusFlag){
        var action = component.get("c.makeContractsApprovals");
        action.setParams({
            bidId : component.get("v.recordId"),
            bidlines:ResultData,
            approveStatusFlag:approveStatusFlag
            
        });
        action.setCallback(this, function (response){
            if(response.getState() === "SUCCESS"){
                
                var wrapNextSteps=response.getReturnValue();
                var marketStepLsit=wrapNextSteps.updateProcessStepList;
                
                var vistexNextStepFlag=wrapNextSteps.contractNextStepFlag;
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type":"success",
                    "title": "Success",
                    "message": "Your Approvals are submitted successfully."
                });
                toastEvent.fire();//updateNextProcessSteps
                
                //helper.UpdateNextContractsSteps(component,event,helper,marketStepLsit,vistexNextStepFlag); 
                
                $A.get('e.force:refreshView').fire();
            }
            else{
                toastEvent.setParams({
                    "type":"error",
                    "title": "error!",
                    "message": "Something went wrong,please contact admin."
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
        
    },
    UpdateNextSteps :function(component,event,helper,ResultData,marketStepLsit, vistexNextStepFlag,isFinance,isContracts,isCustomer,isVistex){
        
        var lineItems=component.get("v.NDCLineItemList");
        
        
        console.log('vistexNextStepFlag-------'+vistexNextStepFlag);
        console.log('isFinance-------'+isFinance);  
        console.log('isContracts-------'+isContracts);
        console.log('isCustomer-------'+isCustomer);
        console.log('isVistex-------'+isVistex);
        var action = component.get("c.updateNextProcesSteps");
        action.setParams({
            bidId : component.get("v.recordId"),
            bidName:component.get("v.bidName"),
            processStepLsit: marketStepLsit,
            vistexNextStepFlag: vistexNextStepFlag,
            
            isFinance: isFinance,
            isContracts: isContracts,
            isCustomer: isCustomer,
            isVistex: isVistex
            
            
            
        });
        action.setCallback(this, function (response){
            if(response.getState() === "SUCCESS"){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type":"success",
                    "title": "Success",
                    "message": "Your Approvals are submitted successfully."
                });
                console.log('isVistex-------'+isVistex);
                toastEvent.fire();//updateNextProcessSteps
                $A.get('e.force:refreshView').fire();
                //helper.UpdateNextSteps(component,event,helper);
                
                
            }
        });
        $A.enqueueAction(action);
        
        component.find("navService").navigate({
            type: "standard__recordPage",
            attributes: {
                recordId: component.get("v.recordId"),
                actionName: "view"
            }
        }, false);
        
        
        
    },
    
    searchTableRecords: function(component, event){
        var searchText = component.get("v.searchText");
        var searchFilter = searchText.split(" ");
        var allRecords = component.get("v.NDCLineItemListDuplicates");
        var filteredData = [];
        var i;
        if(searchText != null || searchText != '' || searchText != undefined){
            for(var k=0; k<allRecords.length; k++){
                if((allRecords[k].Phoenix_Account__r.Name && allRecords[k].Phoenix_Account__r.Name.toUpperCase().indexOf(searchText.toUpperCase()) != -1)||
                   (allRecords[k].Phoenix_Contract__r.Name && allRecords[k].Phoenix_Contract__r.Name.toUpperCase().indexOf(searchText.toUpperCase()) != -1) ||
                   (allRecords[k].Phoenix_Current_Product__r.Name && allRecords[k].Phoenix_Current_Product__r.Name.toUpperCase().indexOf(searchText.toUpperCase()) != -1)||
                   (allRecords[k].Phoenix_Proposed_Product__r.Name && allRecords[k].Phoenix_Proposed_Product__r.Name.toUpperCase().indexOf(searchText.toUpperCase()) != -1)){
                    filteredData.push(allRecords[k]);
                }
            }
            if(filteredData.length == 0){
                for(var j=0; j<searchFilter.length; j++){
                    if(searchFilter[j] != null || searchFilter[j] != '' || searchFilter[j] != undefined){
                        for(i=0; i < allRecords.length; i++){
                            if((allRecords[i].Phoenix_Current_Product_NDC__c && allRecords[i].Phoenix_Current_Product_NDC__c.indexOf(searchFilter[j]) != -1 ) ||
                               //(allRecords[i].Phoenix_Contract__r.Name && allRecords[i].Phoenix_Contract__r.Name.indexOf(searchFilter[j]) != -1) ||
                               (allRecords[i].Phoenix_Proposed_Product_NDC__c && allRecords[i].Phoenix_Proposed_Product_NDC__c.indexOf(searchFilter[j]) != -1 ) ||
                               (allRecords[i].Phoenix_Material_Code__c && allRecords[i].Phoenix_Material_Code__c.indexOf(searchFilter[j]) != -1 ) )
                            {
                                if(!filteredData.includes(allRecords[i])){
                                    filteredData.push(allRecords[i]);   
                                }
                            }    
                            
                        }
                    }  
                }        
            }
        }
        
        component.set("v.NDCLineItemList", filteredData);
        if(searchFilter == ''){
            component.set("v.NDCLineItemList",component.get("v.NDCLineItemListDuplicates"));
            //component.set("v.filteredData", []);
        }
    },
    
    sortBy: function(component, event, sortFieldName) {
        var currentDir = component.get("v.arrowDirection");
        
        if (currentDir == 'arrowdown') {
            // set the arrowDirection attribute for conditionally rendred arrow sign  
            component.set("v.arrowDirection", 'arrowup');
            // set the isAsc flag to true for sort in Assending order.  
            component.set("v.sortAsc", true);
            component.set("v.sortField", sortFieldName);
        } else {
            component.set("v.arrowDirection", 'arrowdown');
            component.set("v.sortAsc", false);
            component.set("v.sortField", sortFieldName);
        }
        // call the onLoad function for call server side method with pass sortFieldName
        this.onSortResult(component, event, sortFieldName);
    },
    
    onSortResult: function(component, event, sortField) {
        console.log('sortField--->'+sortField)
        //var action = component.get('c.fetchSortResults');
        var productList=[];
        productList=component.get("v.NDCLineItemList");
        var key = function(a) {
            if(sortField == 'Phoenix_NPR__r.Name'){
                if(a['Phoenix_Product__r'] != null && a['Phoenix_Product__r'] != undefined){
                    return a['Phoenix_NPR__r']['Name']; 
                }else{
                    return null;
                }               
            }else if(sortField == 'Phoenix_Product__r.Name'){
                if(a['Phoenix_Product__r'] != null && a['Phoenix_Product__r'] != undefined){
                    return a['Phoenix_Product__r']['Name']; 
                }else{
                    return null;
                }
            }
                else if(sortField == 'Phoenix_Account__r.Name'){
                    // console.log('sorting--'+a['Phoenix_Account__r']['Name'])
                    if(a['Phoenix_Account__r'] != null && a['Phoenix_Account__r'] != undefined){
                        return a['Phoenix_Account__r']['Name']; 
                    }else{
                        return null;
                    }
                }
                    else{
                        return a[sortField]; 
                    }
            // console.log('sorting-->'+a[sortField])
            
        }
        var reverse = component.get("v.sortAsc") ? 1: -1;
        productList.sort(function(a,b){
            var a = key(a) ? key(a) : '';
            var b = key(b) ? key(b) : '';
            console.log('a====='+a);
            console.log('b====='+b);
                    return reverse * ((a>b) - (b>a));
                }); 
        if(productList.length > 50){
            var selectedPageNumber = component.get("v.selectedPageNumber");
            var pagedLineItems = productList.slice((selectedPageNumber-1)*50,((selectedPageNumber-1)*50)+50);
            component.set("v.pagedLineItems",pagedLineItems);
        }
        else{
            component.set("v.pagedLineItems",productList);
            var pageNum=[];
            component.set("v.pageNumbers",pageNum);
        }
      component.set("v.NDCLineItemList", productList);
        /*action.setParams({
            'sortField': sortField,
            'isAsc': component.get("v.sortAsc"),
            'productList':productList
        });
        action.setCallback(this, function(response) {
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('Resp:: '+JSON.stringify(response.getReturnValue()));
                var resposeData=response.getReturnValue();
                if(resposeData.length > 50){
                    var selectedPageNumber = component.get("v.selectedPageNumber");
                    
                    var pagedLineItems = resposeData.slice((selectedPageNumber-1)*50,((selectedPageNumber-1)*50)+50);
                    component.set("v.pagedLineItems",pagedLineItems);
                }
                else{
                    component.set("v.pagedLineItems",resposeData);
                    var pageNum=[];
                    component.set("v.pageNumbers",pageNum);
                }
                
                component.set("v.NDCLineItemList", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);*/
    },
    sortBySummaryView: function(component, event, sortFieldName) {
        var currentDir = component.get("v.arrowDirection");
        
        if (currentDir == 'arrowdown') {
            // set the arrowDirection attribute for conditionally rendred arrow sign  
            component.set("v.arrowDirection", 'arrowup');
            // set the isAsc flag to true for sort in Assending order.  
            component.set("v.sortAsc", true);
            component.set("v.sortField", sortFieldName);
        } else {
            component.set("v.arrowDirection", 'arrowdown');
            component.set("v.sortAsc", false);
            component.set("v.sortField", sortFieldName);
        }
        // call the onLoad function for call server side method with pass sortFieldName
        this.onSortResultSummaryView(component, event, sortFieldName);
    },
    
    onSortResultSummaryView: function(component, event, sortField) {
        //var action = component.get('c.fetchSortResults');
        var productList=[];
        productList=component.get("v.summaryViewList");
        var key = function(a) { return a[sortField]; }
        var reverse = component.get("v.sortAsc") ? 1: -1;
        productList.sort(function(a,b){
            var a = key(a) ? key(a) : '';
            var b = key(b) ? key(b) : '';
                    return reverse * ((a>b) - (b>a));
                }); 
        if(productList.length > 50){
            var selectedPageNumberSumView = component.get("v.selectedPageNumberSumView");
            var pagedSumView = productList.slice((selectedPageNumberSumView-1)*50,((selectedPageNumberSumView-1)*50)+50);
            component.set("v.pagedSumView",pagedSumView);
        }
        else{
            component.set("v.pagedSumView",productList);
            var pageNum=[];
            component.set("v.pageNumbersSumView",pageNum);
        }
      component.set("v.summaryViewList", productList);
        /*action.setParams({
            'sortField': sortField,
            'isAsc': component.get("v.sortAsc"),
            'productList':productList
        });
        action.setCallback(this, function(response) {
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('Resp:: '+JSON.stringify(response.getReturnValue()));
                var resposeData=response.getReturnValue();
                if(resposeData.length > 50){
                    var selectedPageNumber = component.get("v.selectedPageNumber");
                    
                    var pagedLineItems = resposeData.slice((selectedPageNumber-1)*50,((selectedPageNumber-1)*50)+50);
                    component.set("v.pagedLineItems",pagedLineItems);
                }
                else{
                    component.set("v.pagedLineItems",resposeData);
                    var pageNum=[];
                    component.set("v.pageNumbers",pageNum);
                }
                
                component.set("v.NDCLineItemList", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);*/
    },
    
    searchTablehelper: function (component,helper) {
        component.set('v.isSpinnerLoad',true);
        var allRecords = component.get("v.NDCLineItemList");
        var searchFilter = component.get("v.searchText");
        if ((searchFilter != null && searchFilter != undefined && searchFilter != '' )) {
            var getProductsAction = component.get("c.getSearch");
            getProductsAction.setParams({ pItem: allRecords, 
                                         ndcId:component.get("v.recordId"),
                                         search: searchFilter });  
            getProductsAction.setCallback(this, function (response) {
                var actState = response.getState();
                if (actState === 'SUCCESS') {
                    var resposeData = response.getReturnValue();
                    
                     if(resposeData.length > 50){
                    function calculatePagesCount(pageSize, totalCount) {
                        return totalCount < pageSize ? 1 : Math.ceil(totalCount / pageSize);
                    }
                    
                    var pageSize = 50;
                    var itemsCount = resposeData.length;
                    var pagesCount = calculatePagesCount(pageSize, itemsCount);
                    var pageNumbers = [];
                    for(var i=0;i<pagesCount;i++){
                        pageNumbers.push(i+1);
                    }
                    component.set("v.pageNumbers",pageNumbers);
                    var pagedLineItems = resposeData.slice(0,50);
                    component.set("v.pagedLineItems",pagedLineItems);
                }
                else
                {
                    component.set("v.pagedLineItems",resposeData);
                    var pageNum=[];
                    component.set("v.pageNumbers",pageNum);
                }
                    
                  
                    component.set("v.NDCLineItemList", response.getReturnValue());
                    var OutDiv = component.find("mainDiv");
                    if(resposeData.length<10){
                        console.log('--no-hight---');
                        $A.util.addClass(OutDiv, "noheightClass");
                    }else{
                        $A.util.removeClass(OutDiv, "noheightClass");
                    }
                    component.set('v.isSpinnerLoad',false);
                } else{
                    component.set('v.isSpinnerLoad',false);
                    console.log("Error "+JSON.stringify(response.getError()));
                }
            });
            $A.enqueueAction(getProductsAction);
        }
        
    },
    
})