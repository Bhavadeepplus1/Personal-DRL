({
	doInit : function(component, event, helper) {
         component.set('v.isSpinnerLoad',true);
        component.set('v.showSaveCancelBtn',false);
        let pageReference = component.get("v.pageReference");
        let recordId = pageReference.state.c__recordId;
        console.log('RecordID is:: '+recordId);
        component.set("v.recordId", recordId);
        var action = component.get("c.getRelatedList");
        action.setParams({
            "recordId": component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var data = [];
            if (state == "SUCCESS") {
              
                
                
                  var wrapperObj =  response.getReturnValue();
                                   var lineItemsList = wrapperObj.lineItemsList;
                                   var bidRecord = wrapperObj.bidRecord;
                                   var loggedinUserName=wrapperObj.loggedInUserName;
                                   var loggedInUserId=wrapperObj.loggedInUserId;
                                   var isFinanceApprovePerson=wrapperObj.isFinanceApprovePerson;
                                   var isVistexApprovePerson=wrapperObj.isVistexApprovePerson;
                                
                                    
                                
                                   component.set("v.isFinanceApprovePerson",isFinanceApprovePerson);
                                   component.set("v.isVistexApprovePerson",isVistexApprovePerson);
                                   component.set("v.NDCLineItemList",lineItemsList);
                                   component.set('v.isSpinnerLoad',false);                                  
                                   component.set("v.bidNumber",bidRecord.Name);                                 
                                   
                                   
                                
                                   
                                  
                                   if( bidRecord.Phoenix_Approval_Status__c!=null && bidRecord.Phoenix_Approval_Status__c!=undefined){
                                       component.set("v.BidAprrovalStatus",bidRecord.Phoenix_Approval_Status__c);
                                   }
                if( bidRecord.RecordType.Name!=null && bidRecord.RecordType.Name!=undefined){
                                       component.set("v.recordTypeName",bidRecord.RecordType.Name);
                                   }
                                 
                                   if( loggedinUserName!=null && loggedinUserName!=undefined){
                                       component.set("v.loggedInUserName",loggedinUserName);
                                   }
                                  if( loggedInUserId!=null && loggedInUserId!=undefined){
                                       component.set("v.loggedInUserId",loggedInUserId);
                                   }
                              
                                  
                                  var OutDiv = component.find("mainDiv");
                                   if(lineItemsList.length<10){
                                       console.log('--no-hight---');
                                       $A.util.addClass(OutDiv, "noheightClass");
                                   }else{
                                       $A.util.removeClass(OutDiv, "noheightClass");
                                   }
            } else {
                console.log("Error "+JSON.stringify(response.getError()));
            }
        });
        // enqueue the server side action  
        $A.enqueueAction(action); 
	},
    handleEvent: function(component, event, helper) {
        component.set('v.isSpinnerLoad',true);
     
        var message = event.getParam("message");
        var action = component.get("c.getRelatedList");
        action.setParams
        ({
            recordId: component.get("v.recordId")
        });
        action.setCallback(this, function(response) 
                           {
                               var wrapperObj =  response.getReturnValue();
                               var lineItemsList = wrapperObj.lineItemsList;
                               component.set("v.NDCLineItemList",lineItemsList);
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
     initRejectedStatus : function(component, event, helper) {
        var rejectedStatus = component.find('RejectedStatusChildCmp');
        rejectedStatus.IPArejectedStatusRefresh();
    },
    Save: function(component, event, helper) {
        
        
        
       
        var saveditems = component.get("v.NDCLineItemList");
        
      
        var showStartDate=false;
          var recordTypeName=component.get('v.recordTypeName');
        var showEndDate=false;
         var showStartEndDate=false;
         var today = new Date();
        var dd = String(today.getDate()).padStart(2, '0');
        var mm = String(today.getMonth() + 1).padStart(2, '0'); //January is 0!
        var yyyy = today.getFullYear();
        today = yyyy + '-' + mm + '-' +dd;
        if(recordTypeName=='Provisional PHS Price Change'){
        for(var i=0;i<saveditems.length;i++){
           
            if(saveditems[i].Phoenix_Price_Start_Date__c < today && saveditems[i].Phoenix_Price_Start_Date__c!='' && saveditems[i].Phoenix_Price_Start_Date__c!=null && saveditems[i].Phoenix_Price_Start_Date__c!=undefined){
             showStartDate=true;
                
            }
              else if(saveditems[i].Phoenix_Price_End_Date__c < today && saveditems[i].Phoenix_Price_End_Date__c!='' && saveditems[i].Phoenix_Price_End_Date__c!=null && saveditems[i].Phoenix_Price_End_Date__c!=undefined){
             showEndDate=true;
                
            }
             else if(saveditems[i].Phoenix_Price_End_Date__c < saveditems[i].Phoenix_Price_Start_Date__c){
             showStartEndDate=true;
                
            }
           
         }
        if(showStartDate){
            
 var toastEvent = $A.get("e.force:showToast");
                                       toastEvent.setParams({
                                           "type":"error",
                                           "title": "Failed!",
                                           "message": "Price Start Date should be greater than Today's Date"
                                       });
                                       toastEvent.fire();            
        }
        else if(showEndDate){
            var toastEvent = $A.get("e.force:showToast");
                                       toastEvent.setParams({
                                           "type":"error",
                                           "title": "Failed!",
                                           "message": "Price End Date should be greater than Today's Date"
                                       });
                                       toastEvent.fire();        
            
        }
         else if(showStartEndDate){
            var toastEvent = $A.get("e.force:showToast");
                                       toastEvent.setParams({
                                           "type":"error",
                                           "title": "Failed!",
                                           "message": "Price End Date should not be lesser than Price Start Date"
                                       });
                                       toastEvent.fire();        
            
        }
        }
      
         if(showStartDate==false &&  showEndDate==false && showStartEndDate==false ){
              component.set('v.isSpinnerLoad',true);
        var action = component.get("c.updatePHSChangeLineItems");
        action.setParams({
            'listLineItems': component.get("v.NDCLineItemList")
            
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                 component.set("v.showSaveCancelBtn",false);
                    component.set('v.isSpinnerLoad',false);
                    component.set('v.NDCLineItemList',storeResponse);
                //alert('Updated...');
                 var toastEvent = $A.get("e.force:showToast");
                                       toastEvent.setParams({
                                           "type":"Success",
                                           "title": "Success",
                                           "message": "Records are saved successfully"
                                       });
                                       toastEvent.fire();   
            } else {
                 component.set("v.showSaveCancelBtn",false);
                    component.set('v.isSpinnerLoad',false);
                console.log("Error "+JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);
          }
    },
   
    downloadCsv: function (component, event, helper) {
     
       var action = component.get("c.getupdatedforExport");
        action.setParams({
            "bidId" : component.get("v.recordId")
        });
        action.setCallback(this, function(a) {
         
            var ResultData =a.getReturnValue();        
         
            var bidNumber=component.get("v.bidNumber");
             var recordType=component.get("v.recordTypeName");
          
       
            // call the helper function which "return" the CSV data as a String   
            var csv = helper.convertArrayOfObjectsToCSV(component,ResultData,recordType);   
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
            hiddenElement.download = 'Input View'+'-'+bidNumber+'-'+Now+'.csv';  // CSV file Name* you can change it.[only name not .csv] 
            document.body.appendChild(hiddenElement); // Required for FireFox browser
            hiddenElement.click(); // using click() js function to download csv file
        });
        $A.enqueueAction(action);
        
    },
    
     backToBid : function(component, event, helper){
         
         console.log('recordId-----'+component.get("v.recordId"));
        component.find("navService").navigate({
            type: "standard__recordPage",
            attributes: {
                recordId: component.get("v.recordId"),
                actionName: "view"
            }
        }, false);
     },
     
    
    onFinanceApprovalChange :  function(component,event, helper){
        component.set("v.showSaveCancelBtn",true);
        //component.set("v.isFinanceApprovalChanged",true);
          var LineItemList= component.get("v.NDCLineItemList");
         var financeApproval;
        var headerFinanceApproval = component.find("headerFinanceApproval");
          if(headerFinanceApproval != null){
            financeApproval = headerFinanceApproval.get("v.value");
        }else{
            financeApproval= '';
        }
         if(financeApproval!=null && financeApproval!='' && financeApproval!=undefined){
          LineItemList.forEach(function(line){
                                               line['Phoenix_Finance_Approval__c'] = financeApproval;
          
                                                  
                                               
                                              
                                           });
         } 
         component.set("v.NDCLineItemList",LineItemList);
        
    },
    
    onApprovalVistexChange:  function(component,event, helper){
        component.set("v.showSaveCancelBtn",true);
     
           var LineItemList= component.get("v.NDCLineItemList");
          var vistexApproval;
           var headerVistexApproval = component.find("headerVistexApproval");
          if(headerVistexApproval != null){
            vistexApproval = headerVistexApproval.get("v.value");
        }else{
            vistexApproval= '';
        }
           if(vistexApproval!=null && vistexApproval!='' && vistexApproval!=undefined){
          LineItemList.forEach(function(line){
              
                                               line['Phoenix_Vistex_Approval__c'] = vistexApproval;
                                                  
                                               
                                              
                                           });
         }
          component.set("v.NDCLineItemList",LineItemList);
          
    },
    onFinanceRemarksChange:  function(component,event, helper){
        component.set("v.showSaveCancelBtn",true);
       // component.set("v.isSCMApprovalChanged",true);
          var LineItemList= component.get("v.NDCLineItemList");
         var financeRemarks;
        var headerFinanceRemarks = component.find("headerFinanceRemarks");
          if(headerFinanceRemarks != null){
            financeRemarks = headerFinanceRemarks.get("v.value");
        }else{
            financeRemarks= '';
        }
         //if(financeRemarks!=null && financeRemarks!='' && financeRemarks!=undefined){
          LineItemList.forEach(function(line){
                                               line['Phoenix_Finance_Approval_Remarks__c'] = financeRemarks;
                                                  
                                               
                                              
                                           });
         //} 
         component.set("v.NDCLineItemList",LineItemList);
        
    },
     onVistexRemarksChange:  function(component,event, helper){
        component.set("v.showSaveCancelBtn",true);
      
          var LineItemList= component.get("v.NDCLineItemList");
         var vistexRemarks;
        var headerVistexRemarks = component.find("headerVistexRemarks");
          if(headerVistexRemarks != null){
            vistexRemarks = headerVistexRemarks.get("v.value");
        }else{
            vistexRemarks= '';
        }
         
          LineItemList.forEach(function(line){
                                               line['Phoenix_Vistex_Approval_Remarks__c'] = vistexRemarks;
                                                  
                                               
                                              
                                           });
       
         component.set("v.NDCLineItemList",LineItemList);
        
    },
     
   
    saveToProceedFinance:function(component,event,helper){
       
       
       var isFinance=true;
       var isVistex=false;
        
        helper.submitForProceed(component,event,helper,isFinance,isVistex);
    },
    
   
    saveToProceedVistex: function(component,event,helper){
        
       var isFinance=false;
       var isVistex=true;
     helper.submitForProceed(component,event,helper,isFinance,isVistex);    
    },
   
    cancel : function(component,event,helper){
        $A.get('e.force:refreshView').fire();
         // component.set("v.showPriceMsg",false);
    },
    
    
})