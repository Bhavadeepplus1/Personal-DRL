({
	 submitForProceed : function(component,event,helper){ 
        component.set('v.isSpinnerLoad',true);
         
        var action = component.get("c.submitToProceddStep1");      
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
                                               if(line['Phoenix_Contract_Status__c'] == 'None' || line['Phoenix_Contract_Status__c'] == '' || line['Phoenix_Contract_Status__c'] == null || line['Phoenix_Contract_Status__c'] == 'undefined' ||line['Phoenix_Contract_Status__c'] == 'Pending'){
                                                   isApproved = true;
                                                   console.log("Phoenix_Contract_Status__c--->"+line['Phoenix_Contract_Status__c']);
                                               }
                                               if(line['Phoenix_Contract_Status__c']=='Sent to Customer'){
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
                                     
                                    
                                           helper.MarkApprovals(component,event,helper,ResultData,approveStatusFlag);  
                                       
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
     MarkApprovals: function(component,event,helper,ResultData,approveStatusFlag){
        console.log('MarkApprovalsContracts--');
        var action = component.get("c.makeApprovalsContracts");
     
        action.setParams({
            bidId : component.get("v.recordId"),
            bidlines:ResultData,
            approveStatusFlag:approveStatusFlag,
           
            
        });
        action.setCallback(this, function (response){
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
     convertArrayOfObjectsToCSV : function(component,objectRecords,bidtype){
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
     
        myMap.set("Parent IPA Customer", "Phoenix_Parent_IPA_Customer__r.Name");
        myMap.set("Contract", "Phoenix_RCA_Agreement__r.Name");
        myMap.set("Customer", "Phoenix_Customer__r.Name");
        myMap.set("Street Number/Name", "Phoenix_Street_Name__c");
        myMap.set("City", "Phoenix_City__c");
        myMap.set("State", "Phoenix_State__c");
        myMap.set("ZIP", "Phoenix_Zip__c");
        myMap.set("DEA", "Phoenix_DEA__c");
        myMap.set("HIN", "Phoenix_HIN__c");
        myMap.set("GLN", "Phoenix_GLN__c");
        myMap.set("GPO", "Phoenix_New_GPO__c");
        myMap.set("Wholesaler Name", "Phoenix_Wholesaler__c");
        myMap.set("Wholesaler Location", "Phoenix_Wholesaler_Location__c");
        myMap.set("Contact", "Phoenix_Contact__r.Name");
        myMap.set("Contact Email", "Phoenix_Contact_Email__c");
        myMap.set("Contact Phone", "Phoenix_Contact_Phone__c");
        myMap.set("Contact Phone Ext", "Phoenix_Contact_Phone_External__c");
        myMap.set("Contract Status", "Phoenix_Contract_Status__c");
        myMap.set("Contract Comments", "Phoenix_Contract_Comments__c");
        
      console.log('1-->');
        csvStringResult += Array.from(myMap.keys()).join(columnDivider);
        csvStringResult += lineDivider;
        for(var i=0; i < objectRecords.length; i++){  
            counter = 0;
            for (let [key, value] of myMap) {
                if(counter > 0){ 
                    csvStringResult += columnDivider; 
                }
                //console.log('testing result--->'+JSON.stringify(objectRecords[i]));
                if('Phoenix_Parent_IPA_Customer__r' in objectRecords[i]){
                if(value == "Phoenix_Parent_IPA_Customer__r.Name" && objectRecords[i]["Phoenix_Parent_IPA_Customer__r"]["Name"] != undefined){
                     csvStringResult += '"'+ objectRecords[i]['Phoenix_Parent_IPA_Customer__r']['Name']+'"';  

                }
                }
                 if('Phoenix_RCA_Agreement__r' in objectRecords[i]){
                if(value == "Phoenix_RCA_Agreement__r.Name" && objectRecords[i]["Phoenix_RCA_Agreement__r"]["Name"] != undefined){
                     csvStringResult += '"'+ objectRecords[i]['Phoenix_RCA_Agreement__r']['Name']+'"';  

                }
                }
             	if('Phoenix_Customer__r' in objectRecords[i]){
                if(value == "Phoenix_Customer__r.Name" && objectRecords[i]["Phoenix_Customer__r"]["Name"] != undefined){
                     csvStringResult += '"'+ objectRecords[i]['Phoenix_Customer__r']['Name']+'"';  

                }
                }
                if('Phoenix_Contact__r' in objectRecords[i]){
                if(value == "Phoenix_Contact__r.Name" && objectRecords[i]["Phoenix_Contact__r"]["Name"] != undefined){
                     csvStringResult += '"'+ objectRecords[i]['Phoenix_Contact__r']['Name']+'"';  

                }
                }
               if(value != 'Phoenix_Parent_IPA_Customer__r.Name' && value != 'Phoenix_RCA_Agreement__r.Name' && value != 'Phoenix_Contract__r.Name' && value != 'Phoenix_Customer__r.Name'){

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
     
})