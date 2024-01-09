({
     initRecords: function(component, event, helper) { 
       
        component.set('v.isSpinnerLoad',true);
        component.set('v.showSaveCancelBtn',false);
        
        component.set("v.BidTypeVal","");
       component.set('v.recordId',component.get("v.pageReference").state.c__recordId);
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
                                     component.set("v.bidwrap",bidRecord);
                                     var BidAprrovalStatus = wrapperObj.BidAprrovalStatus;
                                     var isSRxApprovePerson = wrapperObj.isSRxApprovePerson;
                                     var loggedInUserName = wrapperObj.loggedInUserName;
                                    var isVistexApprovePerson=wrapperObj.isVistexApprovePerson;
                                    console.log('after bidRecord-return'+JSON.stringify(bidRecord));
                                   component.set("v.isSRxApprovePerson",isSRxApprovePerson);
                                    component.set("v.loggedInUserName",loggedInUserName);
                                 component.set("v.isVistexApprovePerson",isVistexApprovePerson);
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
                                   
                                   
                                  console.log('after BidAprrovalStatus-return'+component.get("v.BidAprrovalStatus"));
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
    
     backToBid : function(component, event, helper){
         
         
        component.find("navService").navigate({
            type: "standard__recordPage",
            attributes: {
                recordId: component.get("v.recordId"),
                actionName: "view"
            }
        }, false);
     },
    SaveAndNavigate: function(component, event, helper){
      
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
        
    },
    cancel : function(component,event,helper){
        $A.get('e.force:refreshView').fire();
         
    },
    showSaveCancel: function (component, event, helper) {
        component.set("v.showSaveCancel",true);  
    },
    saveApproval: function (component, event, helper) {
      var finComm='';
        var finAppStatus='';
        var visComm='';
        var visAppStatus='';
        
        var approvalStatus=component.get("v.BidAprrovalStatus");
        if(approvalStatus == 'Contracts'){
           finComm=component.find("contrComments").get("v.value");
           finAppStatus=component.find("contrAppStatus").get("v.value");  
        }
        
        if(approvalStatus == 'Vistex Update'){
            visComm=component.find("vistexComments").get("v.value");
            visAppStatus=component.find("vistexAppStatus").get("v.value"); 
        }
        var action = component.get("c.saveTobid");
        action.setParams({
            'bidId' : component.get("v.recordId"),
            'comments':finComm,
            'status':finAppStatus,
            'visComm':visComm,
            'visAppStatus':visAppStatus,
            'approvalStatus':approvalStatus
           
        });
        action.setCallback(this, function (response){
            if(response.getState() === "SUCCESS"){
                component.set("v.bidwrap",response.getReturnValue());
                component.set("v.showProceedBtn",true);
         component.set("v.showSaveCancel",false);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type":"success",
                    "title": "Success",
                    "message": "Record has been Upadated successfully."
                });
                toastEvent.fire();
                
            }
            else{
                var errors = response.getError();
                console.log("Error message: -----------------------" +
                            errors[0].message);
            }
            
           
            //$A.get('e.force:refreshView').fire();  
        });
        $A.enqueueAction(action);
         
         
         
    },
    closeApproval:  function (component, event, helper) {
         //$A.get('e.force:refreshView').fire();
        component.set("v.showSaveCancel",false);  
    },
    saveToProceedContr: function (component, event, helper) {
       var bidRecord=component.get("v.bidwrap");
        var finComm=bidRecord.Phoenix_Contracts_Approval_Comments__c;
       
        var finAppStatus=bidRecord.Phoenix_Contracts_Approval__c;
           console.log('finAppStatus----'+finAppStatus);
         if(finAppStatus!=null && finAppStatus!=undefined && finAppStatus!=''){
        var approvalStatus=component.get("v.BidAprrovalStatus");
        var action = component.get("c.makeApprovalsIPAContracts");
        action.setParams({
            'bidId' : component.get("v.recordId"),
            'comments':finComm,
            'status':finAppStatus
           
        });
        action.setCallback(this, function (response){
            if(response.getState() === "SUCCESS"){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type":"success",
                    "title": "Success",
                    "message": "Your Approvals are submitted successfully."
                });
                toastEvent.fire();
                
            }
            else{
                var errors = response.getError();
                console.log("Error message: -----------------------" +
                            errors[0].message);
            }
            
            component.find("navService").navigate({
                type: "standard__recordPage",
                attributes: {
                    recordId: component.get("v.recordId"),
                    actionName: "view"
                }
            }, false);
            $A.get('e.force:refreshView').fire();  
        });
        $A.enqueueAction(action);
         }
         else{
              var toastEvent = $A.get("e.force:showToast");
                                       toastEvent.setParams({
                                           "type":"warning",
                                           "title": "Failed!",
                                           "message": "Please confirm approval to proceed further"
                                       });
                                       toastEvent.fire(); 
         }
    },
    submitToProceedVistex: function (component, event, helper) {
       var bidRecord=component.get("v.bidwrap");
        console.log('bidRecord----'+JSON.stringify(bidRecord));
        var finComm=bidRecord.Phoenix_Vistex_Update_Comments__c;
       
        var finAppStatus=bidRecord.Phoenix_Vistex_Update__c;
        
           console.log('finAppStatus----'+finAppStatus);
         if(finAppStatus!=null && finAppStatus!=undefined && finAppStatus!=''){
        var approvalStatus=component.get("v.BidAprrovalStatus");
        var action = component.get("c.makeApprovalsVistex");
        action.setParams({
            'bidId' : component.get("v.recordId"),
            'comments':finComm,
            'status':finAppStatus
           
        });
        action.setCallback(this, function (response){
            if(response.getState() === "SUCCESS"){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type":"success",
                    "title": "Success",
                    "message": "Your Approvals are submitted successfully."
                });
                toastEvent.fire();
                
            }
            else{
                var errors = response.getError();
                console.log("Error message: -----------------------" +
                            errors[0].message);
            }
            
            component.find("navService").navigate({
                type: "standard__recordPage",
                attributes: {
                    recordId: component.get("v.recordId"),
                    actionName: "view"
                }
            }, false);
            $A.get('e.force:refreshView').fire();  
        });
        $A.enqueueAction(action);
         }
         else{
              var toastEvent = $A.get("e.force:showToast");
                                       toastEvent.setParams({
                                           "type":"warning",
                                           "title": "Failed!",
                                           "message": "Please confirm approval to proceed further"
                                       });
                                       toastEvent.fire(); 
         }
    },
     initContractsView : function(component, event, helper) {
        var rejectedStatus = component.find('ContractsTab');
        //rejectedStatus.ContractsViewRefresh();
    },
    handleEvent: function(component, event, helper) {
        component.set('v.isSpinnerLoad',true);
       
        var message = event.getParam("message");
        var action = component.get("c.getRelatedList");
        action.setParams
        ({
            bidId: component.get("v.recordId")
        });
        action.setCallback(this, function(response) 
                           {     var state = response.getState();
                                   console.log('state--->'+state);
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
        var bidNumber=component.get("v.bidNumber");
        var bidName=component.get("v.bidName");
        // call the helper function which "return" the CSV data as a String   
        var csv = helper.convertArrayOfObjectsToCSV(component,ResultData);   
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
        hiddenElement.download = 'Edit RCA IPA Lines'+'-'+bidNumber+'-'+bidName+'-'+Now+'.csv';  // CSV file Name* you can change it.[only name not .csv] 
        document.body.appendChild(hiddenElement); // Required for FireFox browser
        hiddenElement.click(); // using click() js function to download csv file
    },
      saveToProceedVistex: function(component,event,helper){
     helper.submitForProceedVistex(component,event,helper);    
    }
    
})