({
    convertArrayOfObjectsToCSV : function(component,objectRecords,template,bidtype){
        // declare variables
        var csvStringResult, counter, keys,columnDivider, lineDivider;
        var Bid_Type =bidtype;
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
        myMap.set("Product Name", "Phoenix_Product__r.Name");
        myMap.set("SAP Number", "Phoenix_Product_Code1__c");
        myMap.set("Product Family", "Product_Family_Name__c");
        myMap.set("Product Director", "Phoenix_Product_Director1__c");
        myMap.set("NDC", "Phoenix_NDC__c");
        myMap.set("WAC", "Phoenix_WAC1__c");
        myMap.set("IPA Floor Price", "Phoenix_IPA_Floor_Price__c");
        myMap.set("Proposed IPA Price", "Phoenix_Proposed_IPA_Price__c");
        myMap.set("IDN Usage", "Phoenix_IDN_Usage__c");
        if(Bid_Type == 'SRx IPA Price Change' || Bid_Type == 'SRx IPA Product Addition'){
          myMap.set("Contract", "Phoenix_Contract__r.Name");
          myMap.set("Customer", "Phoenix_Customer__r.Name");   
        } 
      /*  myMap.set("SCM Approval", "Phoenix_SCM_Approval_Y_N__c");
        myMap.set("SCM Rejection Reason", "Phoenix_SCM_Rejection_Reason1__c");
        myMap.set("SCM Comments", "Phoenix_SCM_Notes__c");*/
        myMap.set("Finance Approval", "Phoenix_Finance_Approval__c");
        myMap.set("Finance Comments", "Phoenix_Finance_Comments__c");
        csvStringResult += Array.from(myMap.keys()).join(columnDivider);
        csvStringResult += lineDivider;
        for(var i=0; i < objectRecords.length; i++){  
            counter = 0;
            for (let [key, value] of myMap) {
                if(counter > 0){ 
                    csvStringResult += columnDivider; 
                }
                console.log('testing result--->'+JSON.stringify(objectRecords[i]));
                if('Phoenix_Product__r' in objectRecords[i]){
                    if(value == "Phoenix_Product__r.Name" && objectRecords[i]["Phoenix_Product__r"]["Name"] != undefined){
                     csvStringResult += '"'+ objectRecords[i]['Phoenix_Product__r']['Name']+'"';  
					}
                 }
                if('Phoenix_Contract__r' in objectRecords[i]){
                    if(value == "Phoenix_Contract__r.Name" && objectRecords[i]["Phoenix_Contract__r"]["Name"] != undefined){
                     csvStringResult += '"'+ objectRecords[i]['Phoenix_Contract__r']['Name']+'"';  
					}
                 }
                if('Phoenix_Customer__r' in objectRecords[i]){
                    if(value == "Phoenix_Customer__r.Name" && objectRecords[i]["Phoenix_Customer__r"]["Name"] != undefined){
                     csvStringResult += '"'+ objectRecords[i]['Phoenix_Customer__r']['Name']+'"';  
					}
                 }
            if(value != 'Phoenix_Product__r.Name' && value != 'Phoenix_Contract__r.Name' && value != 'Phoenix_Customer__r.Name'){

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
    
      submitForProceed : function(component,event,helper,isSCM,isFinance){ 
        component.set('v.isSpinnerLoad',true);
         
        var action = component.get("c.submitToProceddStep");      
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
                                   else if(isSCM){
                                      
                                       
                                           ResultData.forEach(function(line){
                                               if(line['Phoenix_SCM_Approval_Y_N__c'] == 'None' || line['Phoenix_SCM_Approval_Y_N__c'] == '' || line['Phoenix_SCM_Approval_Y_N__c'] == null || line['Phoenix_SCM_Approval_Y_N__c'] == 'undefined'){
                                                   isApproved = true;
                                                   console.log("Phoenix_SCM_Approval_Y_N__c--->"+line['Phoenix_SCM_Approval_Y_N__c']);
                                               }
                                               if(line['Phoenix_SCM_Approval_Y_N__c']=='Y- Only Current Monthly Demand Approved'||line['Phoenix_SCM_Approval_Y_N__c']=='Y- Current + Inc Demand Approved'){
                                                   approveStatusFlag=true;  
                                                   console.log("Phoenix_SCM_Approval_Y_N__c--->"+line['Phoenix_SCM_Approval_Y_N__c']);
                                               } 
                                           });
                                       
                                   }
                                       else if (isFinance){
                                           ResultData.forEach(function(line){
                                               if((line['Phoenix_Finance_Approval__c'] == 'None' || line['Phoenix_Finance_Approval__c'] == '' || line['Phoenix_Finance_Approval__c'] == null || line['Phoenix_Finance_Approval__c'] == 'undefined' )&&(line['Phoenix_Conditional_Approval_Req_for_Flo__c']==true )){
                                                   isApproved = true;
                                                   console.log("Phoenix_Finance_Approval__c--->"+line['Phoenix_Finance_Approval__c']);
                                               }
                                               if(line['Phoenix_Finance_Approval__c']=='Approved'){
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
                                   else if(isSCM ||isFinance){
                                     
                                           helper.MarkApprovalsSCM(component,event,helper,ResultData,approveStatusFlag,isSCM,isFinance);  
                                      
                                       
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
   
    MarkApprovalsSCM : function(component,event,helper,ResultData,approveStatusFlag,isSCM,isFinance){
        console.log('MarkApprovalsContracts--');
        var action = component.get("c.makeApprovalsContracts");
        
        action.setParams({
            bidId : component.get("v.recordId"),
            bidlines:ResultData,
            approveStatusFlag:approveStatusFlag,
            isSCM:isSCM,
           
            isFinance:isFinance
        });
        action.setCallback(this, function (response){
            if(response.getState() === "SUCCESS"){
                var responseList=response.getReturnValue();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type":"success",
                    "title": "Success",
                    "message": "Your Approvals are submitted successfully."
                });
                toastEvent.fire();//updateNextProcessSteps
                if(isSCM){
                   helper.UpdateNextStepsSCM(component,event,helper,responseList);  
                }
              
                if(isFinance){
                  helper.UpdateNextStepsFinance(component,event,helper,responseList);   
                }
                
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
    
    UpdateNextStepsSCM :function(component,event,helper,Stepsist){
        console.log('UpdateNextStepsSCM--');
         var lineItems=component.get("v.BidLineItemListAll");
        var conditionalApproval=false;
        lineItems.forEach(function(line){
                                              if(line['Phoenix_Conditional_Approval_Req_for_Flo__c']==true){
                                                   conditionalApproval=true;  
                                               } 
                                           });
        var action = component.get("c.updateNextSCMProcessSteps");
        action.setParams({
            bidId : component.get("v.recordId"),
            conditionalApproval:conditionalApproval,
            bidName:component.get("v.bidName"),
            processStepLsit: Stepsist
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
   
     UpdateNextStepsFinance :function(component,event,helper,Stepsist){
        console.log('UpdateNextStepsMarketing--');
        /* var lineItems=component.get("v.BidLineItemListAll");
        var conditionalApproval=false;
        lineItems.forEach(function(line){
                                              if(line['Phoenix_Conditional_Approval_Req_for_Flo__c']==true){
                                                   conditionalApproval=true;  
                                               } 
                                           });*/
        var action = component.get("c.updateNextFinanceProcessSteps");
        action.setParams({
            bidId : component.get("v.recordId"),
            bidName:component.get("v.bidName"),
            processStepLsit: Stepsist
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