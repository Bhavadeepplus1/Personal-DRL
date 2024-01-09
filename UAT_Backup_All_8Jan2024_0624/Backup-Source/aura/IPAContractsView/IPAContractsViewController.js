({
     initRecords: function(component, event, helper) { 
       
        component.set('v.isSpinnerLoad',true);
        component.set('v.showSaveCancelBtn',false);
        component.set("v.showPriceMsg",false);
        component.set("v.BidTypeVal","");
      
        console.log('---record--id--from url-'+component.get('v.recordId')); 
        var action = component.get("c.getRelatedList");      
        action.setParams
        ({
            bidId: component.get("v.recordId")
        });
        action.setCallback(this, function(response) 
                           {
                               if(response.getState()=="SUCCESS"){
                                   var wrapperObj =  response.getReturnValue();
                                   var lineItemsList = wrapperObj.lineItemsList;
                                  
                                   var bidRecord = wrapperObj.bidRecord;
                                   var loggedinUserName=wrapperObj.loggedInUserName;
                                    var loggedInUserId=wrapperObj.loggedInUserId;
                               	  var isContractsApprovePerson=wrapperObj.isContractsApprovePerson;
                                   var isSCMApprovePerson=wrapperObj.isSCMApprovePerson;
                                    var isMarketingApprovePerson=wrapperObj.isMarketingApprovePerson;
                                   var isFinanceApprovePerson=wrapperObj.isFinanceApprovePerson;
                                   console.log('isSCMApprovePerson'+isSCMApprovePerson);
                                   component.set("v.isSCMApprovePerson",isSCMApprovePerson);
                                     component.set("v.isMarketingApprovePerson",isMarketingApprovePerson);
                                     component.set("v.isFinanceApprovePerson",isFinanceApprovePerson);
                                   
                                   var showProceedBtn=wrapperObj.showProceedBtn;
                                   console.log('showProceedBtn'+showProceedBtn);
                                    console.log('isMarketingApprovePerson'+isMarketingApprovePerson);
                                     console.log('loggedinUserName'+loggedinUserName);
                                    component.set("v.showProceedBtn",showProceedBtn);
                                   lineItemsList.forEach(function(line){
                                               if(line['Phoenix_Conditional_Approval_Req_for_Flo__c'] == true ){
                                                 component.set("v.conditionApproval",true);
                                                   
                                               }
                                              
                                           });
                                   
                                 
                                   component.set("v.BidLineItemListAll",lineItemsList);
                                   component.set('v.isSpinnerLoad',false);                                  
                                  component.set("v.bidNumber",bidRecord.Name);                                 
                                   component.set("v.bidName",bidRecord.Phoenix_Bid_Name__c);
                                   
                                   if( bidRecord.Phoenix_Bid_Type__c!=null && bidRecord.Phoenix_Bid_Type__c!=undefined){
                                        component.set("v.BidTypeVal",bidRecord.Phoenix_Bid_Type__c);
                                   }
                                   if( bidRecord.Phoenix_Approval_Status__c!=null && bidRecord.Phoenix_Approval_Status__c!=undefined){
                                       component.set("v.BidAprrovalStatus",bidRecord.Phoenix_Approval_Status__c);
                                   }
                                   console.log('loggedinUserName--'+loggedinUserName);
                                   if( loggedinUserName!=null && loggedinUserName!=undefined){
                                       component.set("v.loggedInUserName",loggedinUserName);
                                   }
                                   if( loggedInUserId!=null && loggedInUserId!=undefined){
                                       component.set("v.loggedInUserId",loggedInUserId);
                                   }
                                if( isContractsApprovePerson!=null && isContractsApprovePerson!=undefined){
                                       component.set("v.isContractsApprovePerson",isContractsApprovePerson);
                                   }
                                  // if( bidRecord.Phoenix_Customer__r.Phoenix_Contracts_Approver__r.Name!=null && bidRecord.Phoenix_Customer__r.Phoenix_Contracts_Approver__r.Name!=undefined){
                                      // component.set("v.BidContractPerson",bidRecord.Phoenix_Customer__r.Phoenix_Contracts_Approver__c);
                                   //}
                                  
                                  
                                   var OutDiv = component.find("mainDiv");
                                   if(lineItemsList.length<10){
                                       console.log('--no-hight---');
                                       $A.util.addClass(OutDiv, "noheightClass");
                                   }else{
                                       $A.util.removeClass(OutDiv, "noheightClass");
                                   }
                               }
                               else{
                                   component.set('v.isSpinnerLoad',false);
                               }
                           });
        $A.enqueueAction(action);
        
    },
     onApprovalChange:  function(component,event, helper){
        component.set("v.showSaveCancelBtn",true);
        component.set("v.isSCMApprovalChanged",true);
          var LineItemList= component.get("v.BidLineItemListAll");
         var scmApproval;
        var headerSCMApproval = component.find("headerSCMApproval");
          if(headerSCMApproval != null){
            scmApproval = headerSCMApproval.get("v.value");
        }else{
            scmApproval= '';
        }
         if(scmApproval!=null && scmApproval!='' && scmApproval!=undefined){
          LineItemList.forEach(function(line){
                                               line['Phoenix_SCM_Approval_Y_N__c'] = scmApproval;
                                                  
                                               
                                              
                                           });
         } 
         component.set("v.BidLineItemListAll",LineItemList);
        
    },
    onFinanceApprovalChange :  function(component,event, helper){
        component.set("v.showSaveCancelBtn",true);
        component.set("v.isFinanceApprovalChanged",true);
          var LineItemList= component.get("v.BidLineItemListAll");
         var financeApproval;
        var headerFinanceApproval = component.find("headerFinanceApproval");
          if(headerFinanceApproval != null){
            financeApproval = headerFinanceApproval.get("v.value");
        }else{
            financeApproval= '';
        }
         if(financeApproval!=null && financeApproval!='' && financeApproval!=undefined){
          LineItemList.forEach(function(line){if(line['Phoenix_Conditional_Approval_Req_for_Flo__c']==true){
                                               line['Phoenix_Finance_Approval__c'] = financeApproval;
          }
                                                  
                                               
                                              
                                           });
         } 
         component.set("v.BidLineItemListAll",LineItemList);
        
    },
     backToBid : function(component, event, helper){
         
         
        component.find("navService").navigate({
            type: "standard__recordPage",
            attributes: {
                recordId: component.get("v.recordId"),
                actionName: "view"
            }
        }, false);
     },
    initContractsView : function(component, event, helper) {
        var rejectedStatus = component.find('ContractsTab');
        rejectedStatus.ContractsViewRefresh();
    },
    SaveAndNavigate: function(component, event, helper){
         component.set("v.showPriceMsg",false);
        //component.set('v.isSpinnerLoad',true);
        var bidlines= component.get("v.BidLineItemListAll");
        var approvalStatus=component.get("v.BidAprrovalStatus");
        if(approvalStatus=='Supply Chain'){
       bidlines.forEach(function(line){
                                               if(line['Phoenix_SCM_Approval_Y_N__c'] == 'N- Not Approved' && (line['Phoenix_SCM_Rejection_Reason1__c']==null || line['Phoenix_SCM_Rejection_Reason1__c']=='' || line['Phoenix_SCM_Rejection_Reason1__c']==undefined ||line['Phoenix_SCM_Rejection_Reason1__c']=='None') )
                                               {   
                                            component.set("v.scmRejectionMsg",true);
              component.set('v.isSpinnerLoad',false);
                                               }
           else{
                component.set("v.scmRejectionMsg",false);
           }

           if((line['Phoenix_SCM_Approval_Y_N__c'] == 'Y- Only Current Monthly Demand Approved' || line['Phoenix_SCM_Approval_Y_N__c']=='Y- Current + Inc Demand Approved') && (line['Phoenix_SCM_Rejection_Reason1__c']!=null && line['Phoenix_SCM_Rejection_Reason1__c']!='' && line['Phoenix_SCM_Rejection_Reason1__c']!=undefined && line['Phoenix_SCM_Rejection_Reason1__c']!='None') )
                                               {   
                                                   console.log('Phoenix_SCM_Rejection_Reason1__c---'+line['Phoenix_SCM_Rejection_Reason1__c']);
                                            component.set("v.scmRejectionNotMsg",true);
              component.set('v.isSpinnerLoad',false);
                                               }
           else{
             component.set("v.scmRejectionNotMsg",false);  
           }
                                              
                                           });
        }
        if(component.get("v.scmRejectionMsg")){
         var toastEvent = $A.get("e.force:showToast");
                                       toastEvent.setParams({
                                           "type":"error",
                                           "title": "Failed!",
                                           "message": "Please select the SCM Rejection Reason when the SCM Approval is Not Approved "
                                       });
                                       toastEvent.fire();
        }
        else if(component.get("v.scmRejectionNotMsg")){
         var toastEvent = $A.get("e.force:showToast");
                                       toastEvent.setParams({
                                           "type":"error",
                                           "title": "Failed!",
                                           "message": "SCM Rejection Reason is not required when approved"
                                       });
                                       toastEvent.fire();
        }
        
        console.log('scmRejectionMsg-----'+component.get("v.scmRejectionMsg"));
         console.log('scmRejectionNotMsg'+component.get("v.scmRejectionNotMsg"));
        if(component.get("v.scmRejectionMsg")==false && component.get("v.scmRejectionNotMsg")==false){
            component.set('v.isSpinnerLoad',true);
       var action = component.get("c.saveLineItems");
            action.setParams({
                'LineItemList': component.get("v.BidLineItemListAll")
               
              
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var storeResponse = response.getReturnValue();
                  
                  	 component.set("v.showSaveCancelBtn",false);
                    component.set('v.isSpinnerLoad',false);
                    component.set('v.BidLineItemListAll',storeResponse);
                     var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type":"success",
                    "title": "Success",
                    "message": "Records have been Upadated successfully."
                });
                toastEvent.fire();
                    console.log('after success-return');
                }else{
                    component.set("v.showSaveCancelBtn",false);
                    component.set('v.isSpinnerLoad',false);
                }
            });
            $A.enqueueAction(action);
        }
        
    },
    cancel : function(component,event,helper){
        $A.get('e.force:refreshView').fire();
          component.set("v.showPriceMsg",false);
    },
    handleEvent: function(component, event, helper) {
        component.set('v.isSpinnerLoad',true);
        component.set("v.showPriceMsg",false);
        var message = event.getParam("message");
        var action = component.get("c.getRelatedList");
        action.setParams
        ({
            bidId: component.get("v.recordId")
        });
        action.setCallback(this, function(response) 
                           {
                               var wrapperObj =  response.getReturnValue();
                               var lineItemsList = wrapperObj.lineItemsList;
                               component.set("v.BidLineItemListAll",lineItemsList);
                               component.set('v.isSpinnerLoad',false);
                               var OutDiv = component.find("mainDiv");
                               if(lineItemsList.length<10){
                                   console.log('--no-hight---');
                                   $A.util.addClass(OutDiv, "noheightClass");
                               }else{
                                   $A.util.removeClass(OutDiv, "noheightClass");
                               }
                           });
        $A.enqueueAction(action);
    },
    downloadCsv : function(component,event,helper){    
        
        var ResultData = component.get("v.BidLineItemListAll");
        var template=component.get("v.templateType");
        var bidNumber=component.get("v.bidNumber");
        var bidName=component.get("v.bidName");
        var bidtype=component.get("v.BidTypeVal");
        // call the helper function which "return" the CSV data as a String   
        var csv = helper.convertArrayOfObjectsToCSV(component,ResultData,template,bidtype);   
        if (csv == null){return;} 
        
        // ####--code for create a temp. <a> html tag [link tag] for download the CSV file--####     
        var hiddenElement = document.createElement('a');
        hiddenElement.href = 'data:text/csv;charset=utf-8,' + encodeURI(csv);
        hiddenElement.target = '_self'; //      
        var date = new Date(); 
        var hours = date.getHours(); 
        var minutes = date.getMinutes(); 
        var newformat = hours >= 12 ? 'PM' : 'AM';  
        hours = hours % 12;  
        hours = hours ? hours : 12;  
        minutes = minutes < 10 ? '0' + minutes : minutes;        
        var Now=(date.getMonth()+1)+'/'+date.getDate()+'/'+date.getFullYear()+' '+hours+':'+minutes+' '+newformat;
        hiddenElement.download = 'SCM & Finance'+'-'+bidNumber+'-'+bidName+'-'+Now+'.csv';  // CSV file Name* you can change it.[only name not .csv] 
        document.body.appendChild(hiddenElement); // Required for FireFox browser
        hiddenElement.click(); // using click() js function to download csv file
    },
     saveToProceedSCM : function(component,event,helper){
        var isSCM=true;
      
     
         var isFinance=false;
        helper.submitForProceed(component,event,helper,isSCM,isFinance);
    },
   
    saveToProceedFinance:function(component,event,helper){
       
        var isSCM=false;
       
         var isFinance=true;
        
        helper.submitForProceed(component,event,helper,isSCM,isFinance);
    }
    
    
})