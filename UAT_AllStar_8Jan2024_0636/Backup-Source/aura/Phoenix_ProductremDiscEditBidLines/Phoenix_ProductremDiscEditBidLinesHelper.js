({
	helperMethod : function() {
		
	},
    convertArrayOfObjectsToCSV : function(component,objectRecords,template,bidtype){
        // declare variables
        var csvStringResult, counter, keys,columnDivider, lineDivider;
        
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
        var bid_type=bidtype;
        console.log('Bid TYpe--->'+bid_type);
        myMap.set("Product Name", "Phoenix_Product__r.Name");
        myMap.set("Product Family", "Product_Family_Name__c");
          myMap.set("Product Director", "Phoenix_Product_Director1__c");
        myMap.set("NDC", "Phoenix_NDC__c");
        if(bid_type == "Product Discontinuation Process"){ 
        myMap.set("Days' Notice - Product Discontinuation", "Phoenix_Days_Notice_Product_Discontinuat__c");
        }
        if(bid_type == "Mass Product Removals"){ 
		myMap.set("Days' Notice - Product Removals", "Phoenix_Day_s_Notice_Product_removal__c");
        }
       
        myMap.set("Customer Requested Days", "Phoenix_Customer_Requested_Days__c");
        myMap.set("Contract", "Phoenix_Contract__r.Name");
        myMap.set("Customer", "Phoenix_Customer__r.Name");
     
          
        myMap.set("Marketing Approval", "Phoenix_Marketing_Approval__c");
         myMap.set("Marketing Notes", "Phoenix_Marketing_Notes__c");
         myMap.set("Marketing Lead Approval", "Phoenix_MarketingLead_Approver__c");
            myMap.set("Marketing Lead Notes", "Marketing_Lead_Notes__c");
        myMap.set("Finance Approval", "Phoenix_Finance_Approval__c");
         myMap.set("Finance Comments", "Phoenix_Finance_Comments__c");
        myMap.set("Contract Approval", "Phoenix_Contract_Approval__c");
        myMap.set("Contract Comments", "Phoenix_Contract_Comments__c");
       
         myMap.set("Vistex Update", "Phoenix_Vistex_Status__c");
        myMap.set("Vistex Comments", "Phoenix_Vistex_Comments__c");
      
         csvStringResult += Array.from(myMap.keys()).join(columnDivider);
        csvStringResult += lineDivider;
        for(var i=0; i < objectRecords.length; i++){  
            counter = 0;
            for (let [key, value] of myMap) {
                if(counter > 0){ 
                    csvStringResult += columnDivider; 
                }
               // console.log('testing result--->'+JSON.stringify(objectRecords[i]));
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
                   			console.log("heloo-->"+objectRecords[i][value])
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
     handleUploadFinished : function(component, event) {
       
        var action = component.get('c.getDocs');
        action.setParams({'bidId' : component.get("v.recordId")});
         console
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log(state)
            console.log(state)
            if (state === "SUCCESS") {
                var fileList=[];
                var totalFiles=[];
                var checked=false;
               totalFiles=response.getReturnValue();
                if(totalFiles!=undefined&&totalFiles!=null)
                {
                    for(var i=0;i<totalFiles.length;i++)
                    {
                         console.log('---33333333---1-----');
                      fileList.push({"Id":totalFiles[i].ContentDocumentId,"Title":totalFiles[i].ContentDocument.Title+'.'+totalFiles[i].ContentDocument.FileExtension,"checked":checked});
                    }
                }
                console.log('------1-----');
               component.set("v.fileList",fileList);
                 component.set("v.showFiles",true);
                console.log('------1--2---'+JSON.stringify(response.getReturnValue()));
            }  
            if(state === "ERROR"){
               // component.set("v.isTSNotCreated","true");
            } 
            
        });
        $A.enqueueAction(action);
     } ,
     handleUploadFinished : function(component, event) {
       
        var action = component.get('c.getDocs');
        action.setParams({'bidId' : component.get("v.recordId")});
         console
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log(state)
            console.log(state)
            if (state === "SUCCESS") {
                var fileList=[];
                var totalFiles=[];
                var checked=false;
               totalFiles=response.getReturnValue();
                if(totalFiles!=undefined&&totalFiles!=null)
                {
                    for(var i=0;i<totalFiles.length;i++)
                    {
                         console.log('---33333333---1-----');
                      fileList.push({"Id":totalFiles[i].ContentDocumentId,"Title":totalFiles[i].ContentDocument.Title+'.'+totalFiles[i].ContentDocument.FileExtension,"checked":checked});
                    }
                }
                console.log('------1-----');
               component.set("v.fileList",fileList);
                 component.set("v.showFiles",true);
                console.log('------1--2---'+JSON.stringify(response.getReturnValue()));
            }  
            if(state === "ERROR"){
               // component.set("v.isTSNotCreated","true");
            } 
            
        });
        $A.enqueueAction(action);
     } ,
     submitForProceedVistex:function(component,event,helper){ 
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
                                               if(line['Phoenix_Vistex_Status__c'] == 'None' || line['Phoenix_Vistex_Status__c'] == '' || line['Phoenix_Vistex_Status__c'] == null || line['Phoenix_Vistex_Status__c'] == 'undefined'){
                                                   isApproved = true;
                                                   console.log("Phoenix_Vistex_Status__c--->"+line['Phoenix_Vistex_Status__c']);
                                               }
                                               if(line['Phoenix_Vistex_Status__c']=='Updated'){
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
                
                var vistexNextStepFlag=wrapNextSteps.contractNextStepFlag;
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type":"success",
                    "title": "Success",
                    "message": "Your Approvals are submitted successfully."
                });
                toastEvent.fire();//updateNextProcessSteps
                
                if(vistexNextStepFlag==false){
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
     submitForProceed : function(component,event,helper,isMarketing,isFinance,isContracts,isMarketingLead,isdelegationuser2){ 
        component.set('v.isSpinnerLoad',true);
            console.log('marketing'+JSON.stringify(component.get("v.recordId")));
         console.log('marketing'+JSON.stringify(isdelegationuser2));
         console.log('marketing'+JSON.stringify(isMarketingLead));
        var action = component.get("c.submitToProceddStep1");
    
        action.setParams
        ({
            bidId:component.get("v.recordId"),
            isMarketing:isMarketing,
            isFinance:isFinance,
            isContracts:isContracts,
            isMarketingLead:isMarketingLead,
            isdelegationuser2:isdelegationuser2
          
        });
        action.setCallback(this, function(response) 
                           {
                               if (response.getState() === "SUCCESS") {
                                   component.set('v.isSpinnerLoad',false);
                                   var ResultData = response.getReturnValue();
                                   var resultlength=ResultData.length;
                                   console.log('resultslength--'+resultlength);
                                   var isApproved = false;
                                     console.log('isContracts-------'+isContracts);
                                   var approveStatusFlag=false;//for step staus ==>false:'rejected' ;true:'approved'
                                   if(resultlength==0){
                                       isApproved = true;
                                       console.log('approved. first..'+JSON.stringify(isApproved));
                                   }
                                 
                                   
                                   else{                                
                                       if (isContracts){
                                           ResultData.forEach(function(line){
                                               if(line['Phoenix_Contract_Approval__c'] == 'None' || line['Phoenix_Contract_Approval__c'] == '' || line['Phoenix_Contract_Approval__c'] == null || line['Phoenix_Contract_Approval__c'] == 'undefined' ||line['Phoenix_Contract_Approval__c'] == 'Pending'){
                                                   isApproved = true;
                                                   console.log("Phoenix_Contract_Approval__c--->"+line['Phoenix_Contract_Approval__c']);
                                               }
                                               if(line['Phoenix_Contract_Approval__c']=='Sent to Customer'){
                                                   approveStatusFlag=true;  
                                               } 
                                           });
                                           
                                       }
                                       
                                       else if(isMarketing){
                                             ResultData.forEach(function(line){
                                               if(line['Phoenix_Marketing_Approval__c'] == 'None' || line['Phoenix_Marketing_Approval__c'] == '' || line['Phoenix_Marketing_Approval__c'] == null || line['Phoenix_Marketing_Approval__c'] == 'undefined'){
                                                   isApproved = true;
                                                   console.log("Phoenix_Marketing_Approval__c--->"+line['Phoenix_Marketing_Approval__c']);
                                               }
                                               if(line['Phoenix_Marketing_Approval__c']=='Approved'){
                                                   approveStatusFlag=true;  
                                               } 
                                           });  
                                           }
                                        else if(isdelegationuser2){
                                             ResultData.forEach(function(line){
                                               if(line['Phoenix_MarketingLead_Approver__c'] == 'None' || line['Phoenix_MarketingLead_Approver__c'] == '' || line['Phoenix_MarketingLead_Approver__c'] == null || line['Phoenix_MarketingLead_Approver__c'] == 'undefined'){
                                                   isApproved = true;
                                                    console.log('delegation. lead..'+JSON.stringify(isApproved));
                                                   console.log("Phoenix_MarketingLead_Approver__c--->"+line['Phoenix_MarketingLead_Approver__c']);
                                               }
                                               if(line['Phoenix_MarketingLead_Approver__c']=='Approved'){
                                                   approveStatusFlag=true;  
                                               } 
                                           });  
                                           }
                                         else if(isMarketingLead){
                                             ResultData.forEach(function(line){
                                               if(line['Phoenix_MarketingLead_Approver__c'] == 'None' || line['Phoenix_MarketingLead_Approver__c'] == '' || line['Phoenix_MarketingLead_Approver__c'] == null || line['Phoenix_MarketingLead_Approver__c'] == 'undefined'){
                                                   isApproved = true;
                                                   
                                                    console.log('approved. lead..'+JSON.stringify(isApproved));
                                                   console.log("Phoenix_MarketingLead_Approver__c--->"+line['Phoenix_MarketingLead_Approver__c']);
                                               }
                                               if(line['Phoenix_MarketingLead_Approver__c']=='Approved'){
                                                   approveStatusFlag=true;  
                                               } 
                                           });  
                                           }
                                       else if(isFinance){
                                             ResultData.forEach(function(line){
                                               if(line['Phoenix_Finance_Approval__c'] == 'None' || line['Phoenix_Finance_Approval__c'] == '' || line['Phoenix_Finance_Approval__c'] == null || line['Phoenix_Finance_Approval__c'] == 'undefined'){
                                                   isApproved = true;
                                                   console.log("Phoenix_Finance_Approval__c--->"+line['Phoenix_Finance_Approval__c']);
                                               }
                                               if(line['Phoenix_Finance_Approval__c']=='Approved'){
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
                                       if(isContracts || isFinance){
                                     
                                           helper.MarkApprovalsContracts(component,event,helper,ResultData,approveStatusFlag,isFinance,isContracts);  
                                     }
                                      else if(isMarketing){
                                           helper.MarkApprovalsMarketing(component,event,helper,ResultData,approveStatusFlag);  
                                       }
                                       else if(isMarketingLead || isdelegationuser2){
                                         
                                           helper.MarkApprovalsMarketingLead(component,event,helper,ResultData,approveStatusFlag,isdelegationuser2);  
                                       }
                                       
                                   }
                                       
                               }
                               else{
                                   component.set('v.isSpinnerLoad',false);
                                   console.log('errro at 420');
                                   console.log('errror....'+JSON.stringify(response.getError()));
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
     MarkApprovalsMarketingLead: function(component,event,helper,ResultData,approveStatusFlag,isdelegationuser2){
         console.log('errror....'+JSON.stringify(ResultData));
           console.log('errror....'+JSON.stringify(approveStatusFlag));
         console.log('errror....'+JSON.stringify(component.get("v.recordId")));
        var action = component.get("c.makeApprovalsMarketingLead");
        action.setParams({
            bidId : component.get("v.recordId"),
            bidlines:ResultData,
            approveStatusFlag:approveStatusFlag,
            isdelegationuser2:isdelegationuser2
        });
        action.setCallback(this, function (response){
            if(response.getState() === "SUCCESS"){
               // console.log('wrapNextSteps'.JSON.stringify(wrapNextSteps));
                var wrapNextSteps=response.getReturnValue();
                var marketStepLsit=wrapNextSteps.updateProcessStepList;
                                console.log('entered updatenextmarketing lead process steps');
                var flagmarketingLeadstop=wrapNextSteps.flagmarketingLeadstop;
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type":"success",
                    "title": "Success",
                    "message": "Your Approvals are submitted successfully."
                });
                toastEvent.fire();//updateNextProcessSteps
                if(flagmarketingLeadstop==false){
                    console.log('entered here');
                    helper.UpdateNextStepsMarketingLead(component,event,helper,marketStepLsit,flagmarketingLeadstop); 
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
     MarkApprovalsMarketing: function(component,event,helper,ResultData,approveStatusFlag){
        var action = component.get("c.makeApprovals");
        action.setParams({
            bidId : component.get("v.recordId"),
            bidlines:ResultData,
            approveStatusFlag:approveStatusFlag
        });
        action.setCallback(this, function (response){
            if(response.getState() === "SUCCESS"){
                var wrapNextSteps=response.getReturnValue();
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
                 console.log('errro at 497');
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
    UpdateNextStepsMarketingLead :function(component,event,helper,marketStepLsit,flagmarketingLeadstop){
        console.log('UpdateNextStepsMarketing--');
       var lineItems=component.get("v.BidLineItemListAll");
      
        var action = component.get("c.updateNextMarketingLeadProcessSteps");
        action.setParams({
            bidId : component.get("v.recordId"),
            bidName:component.get("v.bidName"),
            processStepLsit: marketStepLsit,
           flagmarketingLeadstop:flagmarketingLeadstop
        });
        action.setCallback(this, function (response){
            if(response.getState() === "SUCCESS"){
                console.log('entered updatenextmarketing lead process steps');
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
     MarkApprovalsContracts : function(component,event,helper,ResultData,approveStatusFlag,isFinance,isContracts){
        console.log('MarkApprovalsContracts--');
        var action = component.get("c.makeApprovalsContracts");
        
        action.setParams({
            bidId : component.get("v.recordId"),
            bidlines:ResultData,
            approveStatusFlag:approveStatusFlag,
            isContracts:isContracts,
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
                if(isContracts){
                   helper.UpdateNextStepsContracts(component,event,helper,responseList);  
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
    
    UpdateNextStepsContracts :function(component,event,helper,Stepsist){
        console.log('UpdateNextStepsSCM--');
         var lineItems=component.get("v.BidLineItemListAll");
        var conditionalApproval=false;
       /* lineItems.forEach(function(line){
                                              if(line['Phoenix_Conditional_Approval_Req_for_Flo__c']==true){
                                                   conditionalApproval=true;  
                                               } 
                                           });*/
        var action = component.get("c.updateNextContractsProcessSteps");
        action.setParams({
            bidId : component.get("v.recordId"),
            bidType:component.get("v.BidTypeVal"),
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