({
    helperMethod : function() {
        
    },
    convertArrayOfObjectsToCSV: function (component, objectRecords,recordType) {
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
         myMap.set("Product Name", "Phoenix_Product_Name__r.Name");
           myMap.set("Material Code", "Phoenix_Material_Code__c"); 
        myMap.set("NDC-11", "Phoenix_NDC_11__c");
        if(recordType=='Provisional PHS Price Change'){
         myMap.set("Provisional PHS Price", "Phoenix_Provisional_PHS_Price__c");
              myMap.set("Price Start Date", "Phoenix_Price_Start_Date__c");
          myMap.set("Price End Date", "Phoenix_Price_End_Date__c");
        }
          if(recordType=='Quarterly PHS Price Change'){
        myMap.set("Old PHS Price $", "Phoenix_Old_PHS_Price__c");
   
        myMap.set("New PHS Price $", "Phoenix_New_PHS_Price__c");
         myMap.set("%Change in Price", "Phoenix_Change_in_Price__c");
        myMap.set("Last 90 days PHS Units", "Phoenix_Last_90_days_PHS_Units__c");
        myMap.set("Sales Difference $", "Phoenix_Sales_Difference__c");
       
          myMap.set("Price in Apexus Sub-Ceiling Contract", "Price_in_Apexus_Sub_Ceiling_Contract__c");
          myMap.set("Diff in Apexus Sub-Ceiling Price", "Phoenix_Diff_in_Apexus_Sub_Ceiling_Price__c");
          myMap.set("Apexus Sub-Ceiling Price Change Required", "Apexus_Sub_Ceiling_Price_Change_Required__c");
       }
           myMap.set("Submitter Remarks", "Phoenix_Remarks__c");
         
        
         
          myMap.set("Finance Head Approval", "Phoenix_Finance_Approval__c");
          myMap.set("Finance Head Remarks", "Phoenix_Finance_Approval_Remarks__c");
        
           myMap.set("Vistex Approval", "Phoenix_Vistex_Approval__c");
           myMap.set("Vistex Remarks", "Phoenix_Vistex_Approval_Remarks__c");
     
           
       
       csvStringResult += Array.from(myMap.keys()).join(columnDivider);
        csvStringResult += lineDivider;
        for(var i=0; i < objectRecords.length; i++){  
            counter = 0;
            for (let [key, value] of myMap) {
                if(counter > 0){ 
                    csvStringResult += columnDivider; 
                }
               
                
                 if(value=='Phoenix_Product_Name__r.Name'){
                    csvStringResult += '"' + objectRecords[i]["Phoenix_Product_Name__r"]["Name"]+ '"';
                   
                     
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
    submitForProceed : function(component,event,helper,isFinance,isVistex){ 
        component.set('v.isSpinnerLoad',true);
         
        var action = component.get("c.submitToProceddStep1");      
        action.setParams
        ({
            bidId:component.get("v.recordId")
           
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
                                   
                                   var approveStatusFlag=false;//for step staus ==>false:'rejected' ;true:'approved'
                                   if(resultlength==0){
                                       isApproved = true;
                                   }
                                 
                                   
                                   else{                                
                                     
                                        if(isFinance){
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
                                      
                                      
                                           
                                           else {
                                               if(isVistex){
                                             ResultData.forEach(function(line){
                                               if(line['Phoenix_Vistex_Approval__c'] == 'None' || line['Phoenix_Vistex_Approval__c'] == '' || line['Phoenix_Vistex_Approval__c'] == null || line['Phoenix_Vistex_Approval__c'] == 'undefined'){
                                                   isApproved = true;
                                                   console.log("Phoenix_Vistex_Approval__c--->"+line['Phoenix_Vistex_Approval__c']);
                                               }
                                               if(line['Phoenix_Vistex_Approval__c']=='Updated' || line['Phoenix_Vistex_Approval__c']=='Pending' ){
                                                   approveStatusFlag=true;  
                                               }
                                                
                                                 
                                           });  
                                           }
                                   }
                                       }
                                 
                                   if(isApproved == true ){
                                       var toastEvent = $A.get("e.force:showToast");
                                       toastEvent.setParams({
                                           "type":"warning",
                                           "title": "Failed!",
                                           "message": "Please confirm each approval to proceed further"
                                       });
                                       toastEvent.fire();
                                       
                                   }
                                  
                                   else{
                                    
                                     
                                           helper.MarkApprovals(component,event,helper,ResultData,approveStatusFlag,isFinance,isVistex);  
                                   
                                    
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
    
   
     MarkApprovals: function(component,event,helper,ResultData,approveStatusFlag,isFinance,isVistex){
        var action = component.get("c.makeApprovals");
        action.setParams({
            bidId : component.get("v.recordId"),
            bidlines:ResultData,
            approveStatusFlag:approveStatusFlag,
            isFinance:isFinance,
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
              
                    helper.UpdateNextSteps(component,event,helper,marketStepLsit,vistexNextStepFlag,isFinance,isVistex); 
             
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
  
    UpdateNextSteps :function(component,event,helper,marketStepLsit, vistexNextStepFlag,isFinance,isVistex){
     
       var lineItems=component.get("v.NDCLineItemList");
      
        
        
        var action = component.get("c.updateNextProcesSteps");
        action.setParams({
            bidId : component.get("v.recordId"),
            processStepLsit: marketStepLsit,
            vistexNextStepFlag: vistexNextStepFlag,
            isFinance: isFinance,
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
                
                toastEvent.fire();//updateNextProcessSteps
             
                $A.get('e.force:refreshView').fire();
            }
        });
        $A.enqueueAction(action);
    
         
        
    },
    
})