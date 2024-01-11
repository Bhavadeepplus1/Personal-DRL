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
       
           myMap.set("Account", "Phoenix_Account__r.Name"); 
        myMap.set("Contract", "Phoenix_Contract__r.Name");
          myMap.set("Current Product", "Phoenix_Current_Product__r.Name");
         myMap.set("Proposed Product", "Phoenix_Proposed_Product__r.Name");
           myMap.set("Awarded Position", "Phoenix_Awarded_Position__c");
         myMap.set("Contract Description", "Phoenix_Contract_Internal_Description__c");
           
          myMap.set("Current Product NDC", "Phoenix_Current_Product_NDC__c");
      
      
        myMap.set("Current Product Pack Size", "Phoenix_Current_Product_Pack_Size__c");
         myMap.set("Proposed Product NDC", "Phoenix_Proposed_Product_NDC__c");
       
        myMap.set("Proposed Product Pack Size", "Phoenix_Proposed_Product_Pack_Size__c");
       
          myMap.set("Contract Price", "Phoenix_Contract_Price__c");
       
          myMap.set("Awarded Quantity", "Phoenix_Awarded_Quantity__c");
           myMap.set("3 Months Annualized Quantity", "Phoenix_3_Months_Annualized_Quantity__c");
          myMap.set("Actual Qty 12m", "Phoenix_Actual_Quantity_Last_12m__c");
         myMap.set("Var (Awarded v/s 3m Annualized Qty)", "Phoenix_Var_Awarded_vs_3m_Annualized_Qty__c");
         myMap.set("Var (Awarded v/s 12m Actual Qty)", "Phoenix_Var_Awarded_vs_12m_Actual_Qty__c");
         myMap.set("Monthly Var (Awarded v/s 3m Annualized Qty)", "Phoenix_Monthly_Var_Awarded_v_s_3m_Annua__c");
         myMap.set("Monthly Var (Awarded v/s 12m Actual Qty)", "Phoenix_Monthly_Var_Awarded_v_s_12m_Actu__c");
        
         myMap.set("Submitter Remarks", "Phoenix_Submitter_Remarks__c");
          myMap.set("SCM Approval", "Phoenix_SCM_Approval_Y_N__c");
           myMap.set("Lead Time (SCM)", "Phoenix_Lead_Time__c");
           myMap.set("SCM Remarks", "Phoenix_Remarks__c");
          myMap.set("Finance Approval", "Phoenix_Finance_Approval__c");
          myMap.set("Finance Remarks", "Phoenix_Finance_Approval_Remarks__c");
         myMap.set("Contracts Sent to Customer", "Phoenix_Contracts_Approval__c");
         myMap.set("Sent to Customer Date", "Phoenix_Sent_to_Customer_Date__c");
           myMap.set("Contracts Remarks", "Phoenix_Contracts_Approval_Remarks__c");
           myMap.set("Customer Approval", "Pheonix_Customer_Approval__c");
           myMap.set("New NDC Effective Date", "Phoenix_New_NDC_Effective_Date__c");
           myMap.set("Customer Remarks", "Phoenix_Customer_Acceptance_Remarks__c");
           myMap.set("Vistex Approval", "Phoenix_Vistex_Approval__c");
           myMap.set("Vistex Remarks", "Phoenix_Vistex_Approval_Remarks__c");
           myMap.set("NPR Record", "Phoenix_Current_NPR__r.Name");
       myMap.set(" NDC Change Line Reference", "Name");
           
       
       csvStringResult += Array.from(myMap.keys()).join(columnDivider);
        csvStringResult += lineDivider;
        for(var i=0; i < objectRecords.length; i++){  
            counter = 0;
            for (let [key, value] of myMap) {
                if(counter > 0){ 
                    csvStringResult += columnDivider; 
                }
                console.log('testing result--->'+JSON.stringify(objectRecords[i]));
                
                 if(value=='Phoenix_Account__r.Name'){
                    csvStringResult += '"' + objectRecords[i]["Phoenix_Account__r"]["Name"]+ '"';
                    console.log('csvStringResult---------'+csvStringResult);
                      console.log('objectRecords[i]["Phoenix_Account__r"]["Name"]---------'+objectRecords[i]["Phoenix_Account__r"]["Name"]);
                }
                
               else if(value=='Phoenix_Contract__r.Name'){
                   csvStringResult += '"' + objectRecords[i]["Phoenix_Contract__r"]["Name"]+ '"';
                }
                else if(value=='Phoenix_Current_NPR__r.Name'){
                    csvStringResult += '"' + objectRecords[i]["Phoenix_Current_NPR__r"]["Name"]+ '"';
                }
                 else if(value=='Phoenix_Current_Product__r.Name'){
                    csvStringResult += '"' + objectRecords[i]["Phoenix_Current_Product__r"]["Name"]+ '"';
                }
                else if(value=='Phoenix_Proposed_Product__r.Name'){
                    csvStringResult += '"' + objectRecords[i]["Phoenix_Proposed_Product__r"]["Name"]+ '"';
                }
                else if(objectRecords[i][value]==undefined){
                        //console.log('Iam in last ELSEE if---->');
                        csvStringResult += '"' +''+ '"';
                    }
                    else{
                        csvStringResult += '"' + objectRecords[i][value]+ '"';
                    }            
               
                counter++;
            }
            csvStringResult += lineDivider;
        }
        //new logic end 
        return csvStringResult;
    },
    submitForProceed : function(component,event,helper,isSCM,isFinance,isContracts,isCustomer,isVistex){ 
        component.set('v.isSpinnerLoad',true);
         
        var action = component.get("c.submitToProceddStep1");      
        action.setParams
        ({
            bidId:component.get("v.recordId")
            //isContracts:isContracts
        });
        action.setCallback(this, function(response) 
                           {
                               if (response.getState() === "SUCCESS") {
                                   component.set('v.isSpinnerLoad',false);
                                   var ResultData = response.getReturnValue();
                                   var resultlength=ResultData.length;
                                   console.log('resultslength--'+resultlength);
                                   var isApproved = false;
                                    var isApproved1 = false;
                                     console.log('isContracts-------'+isContracts);
                                   var approveStatusFlag=false;//for step staus ==>false:'rejected' ;true:'approved'
                                   if(resultlength==0){
                                       isApproved = true;
                                   }
                                 
                                   
                                   else{                                
                                       if (isSCM){
                                          
                                        ResultData.forEach(function(line){
                                              console.log('line--'+line['Phoenix_SCM_Approval_Y_N__c']);
                                               if(line['Phoenix_SCM_Approval_Y_N__c'] == 'None' || line['Phoenix_SCM_Approval_Y_N__c'] == '' || line['Phoenix_SCM_Approval_Y_N__c'] == null || line['Phoenix_SCM_Approval_Y_N__c'] == 'undefined'){
                                                   isApproved = true;
                                                   console.log("Phoenix_SCM_Approval_Y_N__c--->"+line['Phoenix_SCM_Approval_Y_N__c']);
                                               }
                                               if(line['Phoenix_SCM_Approval_Y_N__c']=='Approved'){
                                                   approveStatusFlag=true;  
                                                   console.log("Phoenix_SCM_Approval_Y_N__c--->"+line['Phoenix_SCM_Approval_Y_N__c']);
                                               } 
                                           });    
                                       }
                                       else if(isFinance){
                                            ResultData.forEach(function(line){
                                                  console.log('line-FINANCE-'+line['Phoenix_Finance_Approval__c']);
                                               if(line['Phoenix_Finance_Approval__c'] == 'None' || line['Phoenix_Finance_Approval__c'] == '' || line['Phoenix_Finance_Approval__c'] == null || line['Phoenix_Finance_Approval__c'] == 'undefined' ){
                                                   isApproved = true;
                                                   console.log("Phoenix_Finance_Approval__c--->"+line['Phoenix_Finance_Approval__c']);
                                               }
                                               if(line['Phoenix_Finance_Approval__c']=='Approved'){
                                                   approveStatusFlag=true;  
                                               } 
                                           });
                                           
                                       }
                                       else if(isContracts){
                                            ResultData.forEach(function(line){
                                               if(line['Phoenix_Contracts_Approval__c'] == 'None' || line['Phoenix_Contracts_Approval__c'] == '' || line['Phoenix_Contracts_Approval__c'] == null || line['Phoenix_Contracts_Approval__c'] == 'undefined'){
                                                   isApproved = true;
                                                   console.log("Phoenix_Contracts_Approval__c--->"+line['Phoenix_Contracts_Approval__c']);
                                               }
                                               if(line['Phoenix_Contracts_Approval__c']=='Yes'){
                                                   approveStatusFlag=true;  
                                               } 
                                                 if(line['Phoenix_Contracts_Approval__c']=='Yes' || line['Phoenix_Contracts_Approval__c']=='No'){
                                                       isApproved1=true;
                                                 }
                                              
                                           });
                                           
                                       }
                                       else if(isCustomer){
                                            ResultData.forEach(function(line){
                                               if(line['Pheonix_Customer_Approval__c'] == 'None' || line['Pheonix_Customer_Approval__c'] == '' || line['Pheonix_Customer_Approval__c'] == null || line['Pheonix_Customer_Approval__c'] == 'undefined' ){
                                                   isApproved = true;
                                                   console.log("Pheonix_Customer_Approval__c--->"+line['Pheonix_Customer_Approval__c']);
                                               }
                                               if(line['Pheonix_Customer_Approval__c']=='Approved' || line['Pheonix_Customer_Approval__c']=='Not Required'){
                                                   approveStatusFlag=true;  
                                               } 
                                                if(line['Pheonix_Customer_Approval__c']=='Approved' || line['Pheonix_Customer_Approval__c']=='Not Required' ||line['Pheonix_Customer_Approval__c']=='Not Approved' ){
                                                  isApproved1=true;
                                               } 
                                           });
                                           
                                       }
                                           
                                           else {
                                               if(isVistex){
                                             ResultData.forEach(function(line){
                                               if(line['Phoenix_Vistex_Approval__c'] == 'None' || line['Phoenix_Vistex_Approval__c'] == '' || line['Phoenix_Vistex_Approval__c'] == null || line['Phoenix_Vistex_Approval__c'] == 'undefined' ){
                                                   isApproved = true;
                                                   console.log("Phoenix_Vistex_Approval__c--->"+line['Phoenix_Vistex_Approval__c']);
                                               }
                                               if(line['Phoenix_Vistex_Approval__c']=='Updated' ||line['Phoenix_Vistex_Approval__c']=='Pending' ){
                                                   approveStatusFlag=true;  
                                               }
                                                 if(line['Phoenix_Vistex_Approval__c']=='Updated' || line['Phoenix_Vistex_Approval__c']=='Pending' ){
                                                   isApproved1=true;  
                                               }
                                                 
                                           });  
                                           }
                                   }
                                       }
                                 
                                   if(isApproved == true &&  !isContracts && !isCustomer ){
                                       var toastEvent = $A.get("e.force:showToast");
                                       toastEvent.setParams({
                                           "type":"warning",
                                           "title": "Failed!",
                                           "message": "Please confirm each approval to proceed further"
                                       });
                                       toastEvent.fire();
                                       
                                   }
                                   else if (isApproved1==false &&  !isSCM && !isFinance && !isVistex ){
                                        var toastEvent1 = $A.get("e.force:showToast");
                                       toastEvent1.setParams({
                                           "type":"warning",
                                           "title": "Failed!",
                                           "message": "Please confirm at least one approval to proceed further"
                                       });
                                       toastEvent1.fire();
                                       
                                       
                                   }
                                   else{
                                       if(isSCM || isFinance || isApproved==false ){
                                     console.log('In MarkApprovals');
                                           helper.MarkApprovals(component,event,helper,ResultData,approveStatusFlag,isSCM,isFinance,isContracts,isCustomer,isVistex);  
                                     }
                                     else{
                                           helper.MarkContractApprovals(component,event,helper,ResultData,approveStatusFlag);  
                                       }
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
    
   
     MarkApprovals: function(component,event,helper,ResultData,approveStatusFlag,isSCM,isFinance,isContracts,isCustomer,isVistex){
        var action = component.get("c.makeApprovals");
        action.setParams({
            bidId : component.get("v.recordId"),
            bidlines:ResultData,
            approveStatusFlag:approveStatusFlag,
             isSCM:isSCM,
             isFinance:isFinance,
             isContracts:isContracts,
             isCustomer:isCustomer,
             isVistex:isVistex
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
              
                    helper.UpdateNextSteps(component,event,helper,ResultData,marketStepLsit,vistexNextStepFlag,isSCM,isFinance,isContracts,isCustomer,isVistex); 
             
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
    UpdateNextSteps :function(component,event,helper,ResultData,marketStepLsit, vistexNextStepFlag,isSCM,isFinance,isContracts,isCustomer,isVistex){
     
       var lineItems=component.get("v.NDCLineItemList");
      
           console.log('isSCM-------'+isSCM);
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
            isSCM: isSCM,
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
                //helper.UpdateNextSteps(component,event,helper);
                $A.get('e.force:refreshView').fire();
            }
        });
        $A.enqueueAction(action);
    
         
        
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

    sortHelper: function(component, event, sortFieldName) {
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
        var action = component.get('c.fetchSortResults');
        var productList=[];
        productList=component.get("v.NDCLineItemList");
        action.setParams({
            'sortField': sortField,
            'isAsc': component.get("v.sortAsc"),
            'productList':productList
        });
        action.setCallback(this, function(response) {
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('Resp:: '+JSON.stringify(response.getReturnValue()));
                component.set("v.NDCLineItemList", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
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
                    console.log('Search Results::: '+JSON.stringify(resposeData));
                       console.log('Search Results length::: '+resposeData.length);
                   
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