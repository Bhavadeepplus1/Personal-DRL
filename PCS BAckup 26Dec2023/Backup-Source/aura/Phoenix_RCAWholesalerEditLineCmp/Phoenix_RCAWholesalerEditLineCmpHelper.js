({
    
    convertArrayOfObjectsToCSV : function(component,objectRecords){
        var csvStringResult, counter, keys,columnDivider, lineDivider;
        console.log('Results--->'+JSON.stringify(objectRecords));
        var json_keyslist=[];
        if (objectRecords == null || !objectRecords.length)
        {
            return null;
        }
        columnDivider = ',';
        lineDivider =  '\n';
        csvStringResult = '';
        var myMap = new Map();
        myMap.set("Date", "Phoenix_RCA_Change_Date__c");
        myMap.set("RCA/IPA Contract", "Phoenix_RCA_Agreement__r.Name");
        myMap.set("RCA/IPA Customer", "Phoenix_Customer__r.Name");
          myMap.set("Customer", "Phoenix_Parent_IPA_Customer__r.Name");
          myMap.set("Street Number/Name", "Phoenix_Street_Name__c");
        myMap.set("City", "Phoenix_City__c");
        myMap.set("State", "Phoenix_State__c");
        myMap.set("ZIP", "Phoenix_Zip__c");
        myMap.set("DEA", "Phoenix_DEA__c");
        myMap.set("New RCA/IPA Contract No.", "Phoenix_New_RCA_Agreement__r.Name");
        myMap.set("Current GPO", "Phoenix_Current_GPO__c");
        myMap.set("New GPO", "Phoenix_New_GPO__c");
        myMap.set("Current Wholesaler", "Phoenix_Current_Wholesaler__c");
        myMap.set("New Wholesaler Name", "Phoenix_Wholesaler__c");
        myMap.set("New Wholesaler Location", "Phoenix_Wholesaler_Location__c");
        myMap.set("RAM", "Phoenix_RAM__r.Name");
        csvStringResult += Array.from(myMap.keys()).join(columnDivider);
        csvStringResult += lineDivider;
        for(var i=0; i < objectRecords.length; i++){  
            counter = 0;
            
            for (let [key, value] of myMap)
            {
                
                if(counter > 0){
                    csvStringResult += columnDivider;
                }
                if('Phoenix_RCA_Change_Date__c' in objectRecords[i]){
                    if(value=='Phoenix_RCA_Change_Date__c' && objectRecords[i]["Phoenix_RCA_Change_Date__c"]!= undefined){
                        var effectiveDate=objectRecords[i]["Phoenix_RCA_Change_Date__c"];
                        var dt = new Date(effectiveDate);
                        var month = dt.getMonth() + 1;
                        var day = dt.getDate();
                        var year = dt.getFullYear();
                        var formatteddate = month + "-" + day + "-" + year;
                        csvStringResult += '"'+formatteddate+'"'
                        console.log('formatteddate--->'+formatteddate);
                    }
                }
                if('Phoenix_RCA_Agreement__r' in objectRecords[i]){
                    if(value=='Phoenix_RCA_Agreement__r.Name' &&  objectRecords[i]["Phoenix_RCA_Agreement__r"]["Name"] != undefined){
                        csvStringResult += '"'+ objectRecords[i]["Phoenix_RCA_Agreement__r"]["Name"]+'"';
                    }
                }
                if('Phoenix_Customer__r' in objectRecords[i]){
                    if(value=='Phoenix_Customer__r.Name' && objectRecords[i]["Phoenix_Customer__r"]["Name"]!=undefined){
                        csvStringResult += '"'+ objectRecords[i]["Phoenix_Customer__r"]["Name"]+'"';
                    } 
                }
                 if('Phoenix_Parent_IPA_Customer__r' in objectRecords[i]){
                    if(value=='Phoenix_Parent_IPA_Customer__r.Name' && objectRecords[i]["Phoenix_Parent_IPA_Customer__r"]["Name"]!=undefined){
                        csvStringResult += '"'+ objectRecords[i]["Phoenix_Parent_IPA_Customer__r"]["Name"]+'"';
                    } 
                }
                if('Phoenix_New_RCA_Agreement__r' in objectRecords[i]){
                    
                    if(value=='Phoenix_New_RCA_Agreement__r.Name' && objectRecords[i]["Phoenix_New_RCA_Agreement__r"]["Name"]!=undefined ){
                        
                        csvStringResult += '"'+ objectRecords[i]["Phoenix_New_RCA_Agreement__r"]["Name"]+'"';
                    }
                }
                
                if('Phoenix_RAM__r' in objectRecords[i]){
                    
                    if(value=='Phoenix_RAM__r.Name' && objectRecords[i]["Phoenix_RAM__r"]["Name"]!=undefined){
                        csvStringResult += '"'+ objectRecords[i]["Phoenix_RAM__r"]["Name"]+'"';
                    }
                }
            if(value != 'Phoenix_RCA_Agreement__r.Name' && value != 'Phoenix_Customer__r.Name'  && value != 'Phoenix_Parent_IPA_Customer__r.Name' && value != 'Phoenix_New_RCA_Agreement__r.Name' && value != 'Phoenix_RAM__r.Name' && value != 'Phoenix_RCA_Change_Date__c'){
  
               	 if(objectRecords[i][value]==undefined)
                {
                    console.log('valuess-->'+objectRecords[i][value]);
                    csvStringResult += '"'+''+'"';
                }
                else 
                {
                        csvStringResult += '"'+ objectRecords[i][value]+'"';
                    }
                }
                
                
                counter++;
            }
            csvStringResult += lineDivider;
        }
        return csvStringResult;        
    },
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
    
})