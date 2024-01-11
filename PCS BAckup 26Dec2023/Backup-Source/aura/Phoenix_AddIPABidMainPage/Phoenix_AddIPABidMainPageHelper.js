({
    convertArrayOfObjectsToCSV : function(component,objectRecords,template,bidtype){
        // declare variables
        var csvStringResult, counter, keys,columnDivider, lineDivider;
        var Bid_Type =bidtype;
        console.log('bid type is-->'+Bid_Type);
        // check if "objectRecords" parameter is null, then return from function
        if (objectRecords == null || !objectRecords.length) {
            return null;
        }
        // store ,[comma] in columnDivider variabel for sparate CSV values and 
        // for start next line use '\n' [new line] in lineDivider varaible  
        columnDivider = ',';
        lineDivider =  '\n';
        // in the keys valirable store fields API Names as a key 
        // this labels use in CSV file header 
        csvStringResult = '';
        var myMap = new Map();
        if(Bid_Type =='NEW Individual Pricing Agreement (IPA)'){
        myMap.set("Product Name", "Phoenix_Product__r.Name");
        myMap.set("SAP Number", "Phoenix_Product_Code1__c");
        myMap.set("Product Family", "Product_Family_Name__c");
        myMap.set("Product Director", "Phoenix_Product_Director1__c");
        myMap.set("NDC", "Phoenix_NDC__c");
        myMap.set("WAC", "Phoenix_WAC1__c");
        myMap.set("IPA Floor Price", "Phoenix_IPA_Floor_Price__c");
        myMap.set("Proposed IPA Price", "Phoenix_Proposed_IPA_Price__c");
        myMap.set("IDN Usage", "Phoenix_IDN_Usage__c");
        myMap.set("Marketing Approval", "Phoenix_Marketing_Approval__c");
        myMap.set("Marketing Comments", "Phoenix_Marketing_Notes__c");
        myMap.set("Price Effective Date", "Phoenix_Price_Effective_Date__c");    
        myMap.set("Contract Approval", "Phoenix_Contract_Approval__c");
        myMap.set("Contract Comments", "Phoenix_Contract_Comments__c");
        myMap.set("Vistex Status", "Phoenix_Vistex_Status__c");
        myMap.set("Vistex Comments", "Phoenix_Vistex_Comments__c");
             myMap.set("Customer Service Status", "Phoenix_Customer_Service_Status__c");
        myMap.set("Customer Service Comments", "Phoenix_Customer_Service_Comments__c");
        }
       /*if(Bid_Type == 'SRx IPA Price Change' || Bid_Type == 'SRx IPA Product Addition'){
        myMap.set("Product Name", "Phoenix_Product__r.Name");
        myMap.set("Product Family", "Phoenix_Product_Family__c");
        myMap.set("NDC", "Phoenix_NDC_National_Drug_Code__c");
        myMap.set("IPA Floor Price", "Phoenix_IPA_Floor_Price__c");
        myMap.set("Proposed IPA Price", "Phoenix_Proposed_IPA_Price__c");
        myMap.set("IDN Usage", "Phoenix_IDN_Usage__c");
        myMap.set("Marketing Approval", "Phoenix_Marketing_Approval__c");
        myMap.set("Marketing Comments", "Phoenix_Marketing_Notes__c");
        myMap.set("Contract Approval", "Phoenix_Contract_Approval__c");
        myMap.set("Contract Comments", "Phoenix_Contract_Comments__c");
        myMap.set("Contract", "Phoenix_Contract__r.Name");
        myMap.set("Customer", "Phoenix_Customer__r.Name");     
        }*/
        csvStringResult += Array.from(myMap.keys()).join(columnDivider);
        csvStringResult += lineDivider;
        for(var i=0; i < objectRecords.length; i++){  
            counter = 0;
            for (let [key, value] of myMap) {
                if(counter > 0){ 
                    csvStringResult += columnDivider; 
                }
              
                if('Phoenix_Product__r' in objectRecords[i]){
                      if(value == "Phoenix_Product__r.Name" && objectRecords[i]["Phoenix_Product__r"]["Name"] != undefined){
                   csvStringResult += '"'+ objectRecords[i]["Phoenix_Product__r"]["Name"]+'"';
                      }
                    
                }
               if(value != 'Phoenix_Product__r.Name'){

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
        return csvStringResult;        
    },
    submitForProceedVistex:function(component,event,helper,approvalStatus){ 
          component.set('v.isSpinnerLoad',true);
         
        var action = component.get("c.submitToProceedVistex");      
        action.setParams
        ({
            bidId:component.get("v.recordId"),
           // approvalStatus:approvalStatus
           
        });
        action.setCallback(this, function(response) 
                           {
                               if (response.getState() === "SUCCESS") {
                                   component.set('v.isSpinnerLoad',false);
                                   var ResultData = response.getReturnValue();
                                   var resultlength=ResultData.length;
                                   console.log('resultslength--'+resultlength);
                                   var isApproved = false;
                                     //console.log('isContracts-------'+isContracts);
                                   var approveStatusFlag=false;//for step staus ==>false:'rejected' ;true:'approved'
                                   if(resultlength==0){
                                       isApproved = true;
                                   }
                                 
                                   
                                   else{                                
                                       if(approvalStatus == 'Vistex Update'){
                                           ResultData.forEach(function(line){
                                               if(line['Phoenix_Vistex_Status__c'] == 'None' || line['Phoenix_Vistex_Status__c'] == '' || line['Phoenix_Vistex_Status__c'] == null || line['Phoenix_Vistex_Status__c'] == 'undefined'){
                                                   isApproved = true;
                                                   console.log("Phoenix_Vistex_Status__c--->"+line['Phoenix_Vistex_Status__c']);
                                               }
                                               if(line['Phoenix_Vistex_Status__c']=='Updated'){
                                                   approveStatusFlag=true;  
                                               } 
                                           }); 
                                       }
                                       else if(approvalStatus == 'Vistex Customer Code Update'){
                                           ResultData.forEach(function(line){
                                               if(line['Vistex_Customer_Code_Update_Status__c'] == 'None' || line['Vistex_Customer_Code_Update_Status__c'] == '' || line['Vistex_Customer_Code_Update_Status__c'] == null || line['Vistex_Customer_Code_Update_Status__c'] == undefined){
                                                   isApproved = true;
                                                   console.log("Vistex_Customer_Code_Update_Status__c--->"+line['Vistex_Customer_Code_Update_Status__c']);
                                               }
                                               if(line['Vistex_Customer_Code_Update_Status__c']=='Updated'){
                                                   approveStatusFlag=true;  
                                               } 
                                           }); 
                                       }
                                       
                                       
                                       
                                      
                                       }
                                 
                                   if(isApproved == true){
                                       var toastEvent = $A.get("e.force:showToast");
                                       toastEvent.setParams({
                                           "type":"warning",
                                           "title": "Failed!",
                                           "message": "Please confirm each approval to proceed further"
                                       });
                                       toastEvent.fire();
                                       
                                   }
                                   else{
                                     
                                     
                                           helper.MarkApprovalsVistex(component,event,helper,ResultData,approveStatusFlag);  
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
    
     submitForProceedCustomer:function(component,event,helper){ 
          component.set('v.isSpinnerLoad',true);
         
        var action = component.get("c.submitToProceedVistex");      
        action.setParams
        ({
            bidId:component.get("v.recordId"),
           
        });
        action.setCallback(this, function(response) 
                           {
                               if (response.getState() === "SUCCESS") {
                                   component.set('v.isSpinnerLoad',false);
                                   var ResultData = response.getReturnValue();
                                   var resultlength=ResultData.length;
                                   console.log('resultslength--'+resultlength);
                                   var isApproved = false;
                                   
                                   var approveStatusFlag=false;//for step staus ==>false:'rejected' ;true:'approved'
                                   if(resultlength==0){
                                       isApproved = true;
                                   }
                                 
                                   
                                   else{                                
                                       
                                           ResultData.forEach(function(line){
                                               if(line['Phoenix_Customer_Service_Status__c'] == 'None' || line['Phoenix_Customer_Service_Status__c'] == '' || line['Phoenix_Customer_Service_Status__c'] == null || line['Phoenix_Customer_Service_Status__c'] == 'undefined'){
                                                   isApproved = true;
                                                   console.log("Phoenix_Customer_Service_Status__c--->"+line['Phoenix_Customer_Service_Status__c']);
                                               }
                                               if(line['Phoenix_Customer_Service_Status__c']=='Processed'){
                                                   approveStatusFlag=true;  
                                               } 
                                           });
                                           
                                       
                                      
                                       }
                                 
                                   if(isApproved == true){
                                       var toastEvent = $A.get("e.force:showToast");
                                       toastEvent.setParams({
                                           "type":"warning",
                                           "title": "Failed!",
                                           "message": "Please confirm each approval to proceed further"
                                       });
                                       toastEvent.fire();
                                       
                                   }
                                   else{
                                     
                                     
                                           helper.MarkApprovalsCustomer(component,event,helper,ResultData,approveStatusFlag);  
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
      submitForProceed : function(component,event,helper,isContracts){ 
        component.set('v.isSpinnerLoad',true);
         
        var action = component.get("c.submitToProceddStep1");      
        action.setParams
        ({
            bidId:component.get("v.recordId"),
            isContracts:isContracts
        });
        action.setCallback(this, function(response) 
                           {
                               if (response.getState() === "SUCCESS") {
                                   component.set('v.isSpinnerLoad',false);
                                   var ResultData = response.getReturnValue();
                                   console.log('submitToProceddStep1_marketing stage response-->'+JSON.stringify(ResultData))
                                   var resultlength=ResultData.length;
                                   console.log('resultslength--'+resultlength);
                                   var isDatesEntered = false;
                                   var isApproved = false;
                                     console.log('isContracts-------'+isContracts);
                                   var approveStatusFlag=false;//for step staus ==>false:'rejected' ;true:'approved'
                                   var qtyError;
                                   if(resultlength==0){
                                       isApproved = true;
                                   }
                                   else{                                
                                       if (isContracts){
                                           ResultData.forEach(function(line){
                                               if(line['Phoenix_Contract_Approval__c'] == 'None' || line['Phoenix_Contract_Approval__c'] == '' || line['Phoenix_Contract_Approval__c'] == null || line['Phoenix_Contract_Approval__c'] == 'undefined' ||line['Phoenix_Contract_Approval__c'] == 'Pending'){
                                                   isApproved = true;
                                                   qtyError = 'Please confirm each approval to proceed further';
                                                   console.log("Phoenix_Contract_Approval__c--->"+line['Phoenix_Contract_Approval__c']);
                                               }
                                               if((line['Phoenix_Price_Effective_Date__c'] == '' || line['Phoenix_Price_Effective_Date__c'] == undefined || line['Phoenix_Price_Effective_Date__c'] == null) && line['Phoenix_Contract_Approval__c']=='Sent to Customer'){
                                                   isDatesEntered = true;
                                                   qtyError='Please enter the price effective date for '+line.Phoenix_Product__r.Name;
                                               }
                                               if(line['Phoenix_Contract_Approval__c']=='Sent to Customer'){
                                                   approveStatusFlag=true;  
                                               } 
                                           });
                                           
                                       }
                                       else {
                                             ResultData.forEach(function(line){
                                               if((line['Phoenix_Marketing_Approval__c'] == 'None' || line['Phoenix_Marketing_Approval__c'] == '' || line['Phoenix_Marketing_Approval__c'] == null || line['Phoenix_Marketing_Approval__c'] == 'undefined')&& (line['Phoenix_Conditional_Approval_Req_for_Flo__c']==true)){
                                                   isApproved = true;
                                                   console.log("Phoenix_Marketing_Approval__c--->"+line['Phoenix_Marketing_Approval__c']);
                                               }
                                               if(line['Phoenix_Marketing_Approval__c']=='Approved'){
                                                   approveStatusFlag=true;  
                                               } 
                                           });  
                                           }
                                       }
                                 
                                   if(qtyError){
                                       var toastEvent = $A.get("e.force:showToast");
                                       toastEvent.setParams({
                                           "type":"warning",
                                           "title": "Failed!",
                                           "message": qtyError
                                       });
                                       toastEvent.fire();
                                       
                                   }
                                   else{
                                       if(isContracts){
                                     
                                           helper.MarkApprovalsSCM(component,event,helper,ResultData,approveStatusFlag,isContracts);  
                                     }
                                      else{
                                           helper.MarkApprovals(component,event,helper,ResultData,approveStatusFlag);  
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
    MarkApprovalsVistex: function(component,event,helper,ResultData,approveStatusFlag){
     
        var action = component.get("c.makeApprovalsVistex");
          console.log('approveStatusFlag--'+approveStatusFlag);
        
           console.log('ResultData--'+JSON.stringify(ResultData));
        
        console.log('component.get("v.recordId")--'+component.get("v.recordId"));
        
        action.setParams({
            bidId : component.get("v.recordId"),
            bidlines:ResultData,
            approveStatusFlag:approveStatusFlag
         });
         console.log('Hi--');
        action.setCallback(this, function (response){
              console.log('state--'+response.getState());
            if(response.getState() === "SUCCESS"){
                var responseList=response.getReturnValue();
                var wrapNextSteps=response.getReturnValue();
                var marketStepLsit=wrapNextSteps.updateProcessStepList;
                console.log('market steps list-->'+JSON.stringify(marketStepLsit))
                var vistexNextStepFlag=wrapNextSteps.contractNextStepFlag;
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type":"success",
                    "title": "Success",
                    "message": "Your Approvals are submitted successfully."
                });
                toastEvent.fire();//updateNextProcessSteps
                
                if(vistexNextStepFlag==false && component.get("v.BidAprrovalStatus")=='Vistex Update'){
                    helper.UpdateNextStepsVistex(component,event,helper,marketStepLsit,vistexNextStepFlag);   
                }
               
                
                
                $A.get('e.force:refreshView').fire();
            }
            else if (response.getState() === "ERROR") {
               var errors = response.getError();
                console.log('errors----'+errors);
               if (errors) {
                   if (errors[0] && errors[0].message) {
                       console.log("Error message: " +
                                errors[0].message);
                   }
               }
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
     MarkApprovalsCustomer: function(component,event,helper,ResultData,approveStatusFlag){
     
        var action = component.get("c.makeApprovalsCustomer");
          console.log('approveStatusFlag--'+approveStatusFlag);
        
           console.log('ResultData--'+JSON.stringify(ResultData));
        
        console.log('component.get("v.recordId")--'+component.get("v.recordId"));
        
        action.setParams({
            bidId : component.get("v.recordId"),
            bidlines:ResultData,
            approveStatusFlag:approveStatusFlag
         });
         console.log('Hi--');
        action.setCallback(this, function (response){
              console.log('state--'+response.getState());
            if(response.getState() === "SUCCESS"){
                var responseList=response.getReturnValue();
                var wrapNextSteps=response.getReturnValue();
                //var marketStepLsit=wrapNextSteps.updateProcessStepList;
                
                //var vistexNextStepFlag=wrapNextSteps.contractNextStepFlag;
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type":"success",
                    "title": "Success",
                    "message": "Your Approvals are submitted successfully."
                });
                toastEvent.fire();//updateNextProcessSteps
                
                //if(vistexNextStepFlag==false){
                    helper.UpdateNextStepsCustomer(component,event,helper,wrapNextSteps);   
                //}
               
                
                
                $A.get('e.force:refreshView').fire();
            }
            else if (response.getState() === "ERROR") {
               var errors = response.getError();
                console.log('errors----'+errors);
               if (errors) {
                   if (errors[0] && errors[0].message) {
                       console.log("Error message: " +
                                errors[0].message);
                   }
               }
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
    MarkApprovalsSCM : function(component,event,helper,ResultData,approveStatusFlag,isContracts){
        console.log('MarkApprovalsContracts--');
        var action = component.get("c.makeApprovalsRCAContracts");
          console.log('approveStatusFlag--'+approveStatusFlag);
        
           console.log('ResultData--'+JSON.stringify(ResultData));
           console.log('isContracts--'+isContracts);
        console.log('component.get("v.recordId")--'+component.get("v.recordId"));
        
        action.setParams({
            bidId : component.get("v.recordId"),
            bidlines:ResultData,
            approveStatusFlag:approveStatusFlag
         });
         console.log('Hi--');
        action.setCallback(this, function (response){
              console.log('state--'+response.getState());
            if(response.getState() === "SUCCESS"){
                var responseList=response.getReturnValue();
                var wrapNextSteps=response.getReturnValue();
                var marketStepLsit=wrapNextSteps.updateProcessStepList;
                
                var contractNextStepFlag=wrapNextSteps.contractNextStepFlag;
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type":"success",
                    "title": "Success",
                    "message": "Your Approvals are submitted successfully."
                });
                toastEvent.fire();//updateNextProcessSteps
                
                if(contractNextStepFlag==false){
                    helper.UpdateNextStepsContracts(component,event,helper,marketStepLsit,contractNextStepFlag);   
                }
               
                
                
                $A.get('e.force:refreshView').fire();
            }
            else if (response.getState() === "ERROR") {
               var errors = response.getError();
                console.log('errors----'+errors);
               if (errors) {
                   if (errors[0] && errors[0].message) {
                       console.log("Error message: " +
                                errors[0].message);
                   }
               }
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
     MarkApprovals: function(component,event,helper,ResultData,approveStatusFlag){
        var action = component.get("c.makeApprovals");
         console.log('approveStatusFlag--'+approveStatusFlag);
        action.setParams({
            bidId : component.get("v.recordId"),
            bidlines:ResultData,
            approveStatusFlag:approveStatusFlag
        });
        action.setCallback(this, function (response){
            console.log('test response-->'+JSON.stringify(response))
            console.log('response status-->'+response.getState())
            if(response.getState() === "SUCCESS"){
                var wrapNextSteps=response.getReturnValue();
                console.log('test-->'+JSON.stringify(wrapNextSteps))
                var marketStepLsit=wrapNextSteps.updateProcessStepList;
                
                var flagMarketStop=wrapNextSteps.flagMarketStop;
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type":"success",
                    "title": "Success",
                    "message": "Your Approvals are submitted successfully."
                });
                toastEvent.fire();//updateNextProcessSteps
                if(flagMarketStop==false){
                    helper.UpdateNextSteps(component,event,helper,marketStepLsit,flagMarketStop); 
                }
                $A.get('e.force:refreshView').fire();
            }
            else{
                console.log('we are in else')
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
    UpdateNextSteps :function(component,event,helper,marketStepLsit,flagMarketStop){
        console.log('UpdateNextStepsMarketing--');
       var lineItems=component.get("v.BidLineItemListAll");
        var conditionalApproval=false;
        lineItems.forEach(function(line){
                                              if(line['Phoenix_Conditional_Approval_Req_for_Flo__c']==true){
                                                   conditionalApproval=true;  
                                               } 
                                           });
        var action = component.get("c.updateNextMarketingProcessSteps");
        action.setParams({
            bidId : component.get("v.recordId"),
            bidName:component.get("v.bidName"),
            processStepLsit: marketStepLsit,
           
            flagMarketStop:flagMarketStop
        });
        action.setCallback(this, function (response){
            if(response.getState() === "SUCCESS"){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type":"success",
                    "title": "Success",
                    "message": "Your Approvals are submitted successfully."
                });
                toastEvent.fire();//updateNextProcessSteps
                //helper.UpdateNextSteps(component,event,helper);
                $A.get('e.force:refreshView').fire();
            }
        });
        $A.enqueueAction(action);
    
         
        
    },
    UpdateNextStepsVistex : function(component,event,helper,marketStepLsit,vistexNextStepFlag){
      console.log('UpdateNextStepsContracts--');
       
        var action = component.get("c.updateNextVistexProcessSteps");
        action.setParams({
            bidId : component.get("v.recordId"),
            bidName:component.get("v.bidName"),
            processStepLsit: marketStepLsit,
            vistexNextStepFlag:vistexNextStepFlag
        });
        action.setCallback(this, function (response){
            if(response.getState() === "SUCCESS"){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type":"success",
                    "title": "Success",
                    "message": "Your Approvals are submitted successfully."
                });
                toastEvent.fire();//updateNextProcessSteps
                //helper.UpdateNextSteps(component,event,helper);
                $A.get('e.force:refreshView').fire();
                
            }
        });
        $A.enqueueAction(action);  
    },
     UpdateNextStepsCustomer : function(component,event,helper,wrapNextSteps){
      console.log('UpdateNextStepsContracts--');
       
        var action = component.get("c.updateNextCustomerProcessSteps");
        action.setParams({
            bidId : component.get("v.recordId"),
            bidName:component.get("v.bidName"),
            processStepLsit: wrapNextSteps,
            
        });
        action.setCallback(this, function (response){
            if(response.getState() === "SUCCESS"){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type":"success",
                    "title": "Success",
                    "message": "Your Approvals are submitted successfully."
                });
                toastEvent.fire();//updateNextProcessSteps
                //helper.UpdateNextSteps(component,event,helper);
                $A.get('e.force:refreshView').fire();
                
                
            
            }
        });
        $A.enqueueAction(action);  
    },
    UpdateNextStepsContracts :function(component,event,helper,marketStepLsit,contractNextStepFlag){
        console.log('UpdateNextStepsContracts--');
        /* var lineItems=component.get("v.BidLineItemListAll");
        var conditionalApproval=false;
        lineItems.forEach(function(line){
                                              if(line['Phoenix_Conditional_Approval_Req_for_Flo__c']==true){
                                                   conditionalApproval=true;  
                                               } 
                                           });*/
        var action = component.get("c.updateNextContractsProcessSteps");
        action.setParams({
            bidId : component.get("v.recordId"),
            bidName:component.get("v.bidName"),
            processStepLsit: marketStepLsit,
            contractNextStepFlag:contractNextStepFlag
        });
        action.setCallback(this, function (response){
            if(response.getState() === "SUCCESS"){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type":"success",
                    "title": "Success",
                    "message": "Your Approvals are submitted successfully."
                });
                toastEvent.fire();//updateNextProcessSteps
                //helper.UpdateNextSteps(component,event,helper);
                $A.get('e.force:refreshView').fire();
              
            }
        });
        $A.enqueueAction(action);
    },
     
    
})