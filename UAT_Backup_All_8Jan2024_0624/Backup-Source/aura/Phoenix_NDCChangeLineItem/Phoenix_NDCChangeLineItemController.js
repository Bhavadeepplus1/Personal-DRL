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
                                   var leadValues = wrapperObj.leadValues;
                                   var bidRecord = wrapperObj.bidRecord;
                                   var loggedinUserName=wrapperObj.loggedInUserName;
                                
                                 
                               
                                   var loggedInUserId=wrapperObj.loggedInUserId;
                                 var vistexCompleted=wrapperObj.vistexCompleted;
                                   var isSCMApprovePerson=wrapperObj.isSCMApprovePerson;
                                   var isFinanceApprovePerson=wrapperObj.isFinanceApprovePerson;
                                   var isContractsApprovePerson=wrapperObj.isContractsApprovePerson;
                                var isVistexApprovePerson=wrapperObj.isVistexApprovePerson;
                                
                                     component.set("v.vistexCompleted",vistexCompleted);
                                   component.set("v.isSCMApprovePerson",isSCMApprovePerson);
                                   component.set("v.isFinanceApprovePerson",isFinanceApprovePerson);
                                   if( isContractsApprovePerson!=null && isContractsApprovePerson!=undefined){
                                       component.set("v.isContractsApprovePerson",isContractsApprovePerson);
                                   }
                                   component.set("v.isVistexApprovePerson",isVistexApprovePerson);
                                   
                                   component.set("v.leadValues",leadValues);
                                   component.set("v.NDCLineItemList",lineItemsList);
                					component.set("v.NDCLineItemListDuplicates", lineItemsList);
            
                                   component.set('v.isSpinnerLoad',false);                                  
                                  component.set("v.bidNumber",bidRecord.Name);                                 
                                   component.set("v.bidName",bidRecord.Phoenix_NDC_Change_Name__c);
                                   
                                
                                   
                                  
                                   if( bidRecord.Phoenix_Approval_Status__c!=null && bidRecord.Phoenix_Approval_Status__c!=undefined){
                                       component.set("v.BidAprrovalStatus",bidRecord.Phoenix_Approval_Status__c);
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
    openModel: function (component, event, helper) {
        var appStatus = component.get("v.BidAprrovalStatus");
        console.log('Approval Status:::: ' + appStatus);
        if (appStatus == 'Contracts' || appStatus == 'Customer' || appStatus == "Customer's Update" || appStatus == 'Vistex Update' || appStatus == 'Closed') {
            component.set("v.isOpen", true);
        } else {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title: 'Error',
                message: 'You can only generate offer document when in Contracts stage or later stage',
                duration: ' 5000',
                key: 'info_alt',
                type: 'error'
            });
            toastEvent.fire();
        }
    },
    Save: function(component, event, helper) {
        
        
        
         //component.set("v.showLeadTime",false);
         //component.set("v.showAwardedQty",false);
        var saveditems = component.get("v.NDCLineItemList");
        
      
        var IsshowLeadTime=false;
       var IsshowAwardedQty=false;
     
        for(var i=0;i<saveditems.length;i++){
           
            if(saveditems[i].Phoenix_SCM_Approval_Y_N__c=='Approved' && (saveditems[i].Phoenix_Lead_Time__c=='' || saveditems[i].Phoenix_Lead_Time__c==null ||saveditems[i].Phoenix_Lead_Time__c==undefined)){
             IsshowLeadTime=true;
                
            }
           
           
            
            /*if(saveditems[i].Pheonix_Customer_Approval__c=='Approved' && (saveditems[i].Phoenix_Awarded_Quantity__c==null || saveditems[i].Phoenix_Awarded_Quantity__c==undefined)){
               IsshowAwardedQty=true;
                
            }*/
            
            
        }
        if(IsshowLeadTime){
            
 var toastEvent = $A.get("e.force:showToast");
                                       toastEvent.setParams({
                                           "type":"error",
                                           "title": "Failed!",
                                           "message": "Please select Lead Time"
                                       });
                                       toastEvent.fire();            
        }
       /* else if(IsshowAwardedQty){
            var toastEvent = $A.get("e.force:showToast");
                                       toastEvent.setParams({
                                           "type":"error",
                                           "title": "Failed!",
                                           "message": "Please enter Awarded Quantity"
                                       });
                                       toastEvent.fire();        
            
        }*/
        
      
          if(IsshowLeadTime==false){
                component.set('v.isSpinnerLoad',true);
        var action = component.get("c.updateNDCChangeLineItems");
        action.setParams({
            'listLineItems': component.get("v.NDCLineItemList"),
              "recordId": component.get("v.recordId")
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
            hiddenElement.download = 'Input View'+'-'+bidNumber+'-'+bidName+'-'+Now+'.csv';  // CSV file Name* you can change it.[only name not .csv] 
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
     onApprovalChange:  function(component,event, helper){
        component.set("v.showSaveCancelBtn",true);
        //component.set("v.isApprovalChanged",true);
           var LineItemList= component.get("v.NDCLineItemList");
          var contractApproval;
           var contractApprovaltype = component.find("headerContractApproval");
          if(contractApprovaltype != null){
            contractApproval = contractApprovaltype.get("v.value");
        }else{
            contractApproval= '';
        }
           if(contractApproval!=null && contractApproval!='' && contractApproval!=undefined){
          LineItemList.forEach(function(line){
              
                                               line['Phoenix_Contracts_Approval__c'] = contractApproval;
                                                  
                                               
                                              
                                           });
         }
          component.set("v.NDCLineItemList",LineItemList);
          
    },
    onCustomerApprovalChange:  function(component,event, helper){
        component.set("v.showSaveCancelBtn",true);
        //component.set("v.isApprovalChanged",true);
           var LineItemList= component.get("v.NDCLineItemList");
          var contractApproval;
           var contractApprovaltype = component.find("headerCustomerApproval");
          if(contractApprovaltype != null){
            contractApproval = contractApprovaltype.get("v.value");
        }else{
            contractApproval= '';
        }
           if(contractApproval!=null && contractApproval!='' && contractApproval!=undefined){
          LineItemList.forEach(function(line){
              
                                               line['Pheonix_Customer_Approval__c'] = contractApproval;
                                                  
                                               
                                              
                                           });
         }
          component.set("v.NDCLineItemList",LineItemList);
          
    },
     onSCMApprovalChange:  function(component,event, helper){
        component.set("v.showSaveCancelBtn",true);
       // component.set("v.isSCMApprovalChanged",true);
          var LineItemList= component.get("v.NDCLineItemList");
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
         component.set("v.NDCLineItemList",LineItemList);
        
    },
     onSCMRemarksChange:  function(component,event, helper){
        component.set("v.showSaveCancelBtn",true);
       // component.set("v.isSCMApprovalChanged",true);
          var LineItemList= component.get("v.NDCLineItemList");
         var scmRemarks;
        var headerSCMRemarks = component.find("headerSCMRemarks");
          if(headerSCMRemarks != null){
            scmRemarks = headerSCMRemarks.get("v.value");
        }else{
            scmRemarks= '';
        }
         //if(scmRemarks!=null && scmRemarks!='' && scmRemarks!=undefined){
          LineItemList.forEach(function(line){
                                               line['Phoenix_Remarks__c'] = scmRemarks;
                                                  
                                               
                                              
                                           });
        // } 
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
     onLeadTimeChange:  function(component,event, helper){
        component.set("v.showSaveCancelBtn",true);
       // component.set("v.isSCMApprovalChanged",true);
          var LineItemList= component.get("v.NDCLineItemList");
         var leadTime;
        var headerLeadTime = component.find("headerLeadTime");
          if(headerLeadTime != null){
            leadTime = headerLeadTime.get("v.value");
        }else{
            leadTime= '';
        }
         if(leadTime!=null && leadTime!='' && leadTime!=undefined){
          LineItemList.forEach(function(line){
                                               line['Phoenix_Lead_Time__c'] = leadTime;
                                                  
                                               
                                              
                                           });
         } 
         component.set("v.NDCLineItemList",LineItemList);
        
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
     saveToProceedSCM : function(component,event,helper){
        var isSCM=true;
       var isFinance=false;
          var isContracts=false;
          var isCustomer=false;
          var isVistex=false;
     

        helper.submitForProceed(component,event,helper,isSCM,isFinance,isContracts,isCustomer,isVistex);
    },
   
    saveToProceedFinance:function(component,event,helper){
       
        var isSCM=false;
       var isFinance=true;
          var isContracts=false;
          var isCustomer=false;
          var isVistex=false;
        
        helper.submitForProceed(component,event,helper,isSCM,isFinance,isContracts,isCustomer,isVistex);
    },
    saveToProceedContracts: function(component,event,helper){
         var isSCM=false;
       var isFinance=false;
          var isContracts=true;
          var isCustomer=false;
          var isVistex=false;
        
        helper.submitForProceed(component,event,helper,isSCM,isFinance,isContracts,isCustomer,isVistex);
    },
   
    saveToProceedVistex: function(component,event,helper){
          var isSCM=false;
       var isFinance=false;
          var isContracts=false;
          var isCustomer=false;
          var isVistex=true;
     helper.submitForProceed(component,event,helper,isSCM,isFinance,isContracts,isCustomer,isVistex);    
    },
    saveToProceedCustomer: function(component,event,helper){
          var isSCM=false;
       var isFinance=false;
          var isContracts=false;
          var isCustomer=true;
          var isVistex=false;
     helper.submitForProceed(component,event,helper,isSCM,isFinance,isContracts,isCustomer,isVistex);    
    },
    cancel : function(component,event,helper){
        $A.get('e.force:refreshView').fire();
         // component.set("v.showPriceMsg",false);
    },
    
   
    
    keyCheck: function(component, event, helper){
        if(event.which == 13){
          console.log('keychek');
            var searchName=component.get("v.searchText"); 
            if(searchName!=null && searchName!='undefined' && searchName!=''){
                 component.set("v.IsSearch",true);
                helper.searchTablehelper(component,helper); 
            }
        }
    },
    
    onsearch: function(component, event, helper){
        var searchName=component.get("v.searchText"); 
        console.log('searchName---'+searchName);
        if(searchName!=null && searchName!='undefined' && searchName!=''){
            component.set("v.IsSearch",true);
            helper.searchTablehelper(component,helper); 
        }
        else{
            var lineItems=component.get("v.NDCLineItemListDuplicates");
              component.set("v.NDCLineItemList",lineItems);
             var OutDiv = component.find("mainDiv");
                                   if(lineItems.length<10){
                                       console.log('--no-hight---');
                                       $A.util.addClass(OutDiv, "noheightClass");
                                   }else{
                                       $A.util.removeClass(OutDiv, "noheightClass");
                                   }
        }
    },
    onClear:function(component, event, helper){
         var searchName=component.get("v.searchText"); 
          if(searchName==null || searchName=='undefined'|| searchName==''){
              var lineItems=component.get("v.NDCLineItemListDuplicates");
              component.set("v.NDCLineItemList",lineItems); 
               var OutDiv = component.find("mainDiv");
                                   if(lineItems.length<10){
                                       console.log('--no-hight---');
                                       $A.util.addClass(OutDiv, "noheightClass");
                                   }else{
                                       $A.util.removeClass(OutDiv, "noheightClass");
                                   }
          }
    },
    
    //Sorting logic
    sortByNDCChangeLineReference: function(component, event, helper) {
        helper.sortHelper(component, event, 'Name');
    },
    sortByAccount: function(component, event, helper) {
        helper.sortHelper(component, event, 'Phoenix_Account__r.Name');
    },
    sortByContract: function(component, event, helper) {
        helper.sortHelper(component, event, "Phoenix_Contract__r.Name");
    },
    sortByContractDescription: function(component, event, helper) {
        helper.sortHelper(component, event, "Phoenix_Contract_Internal_Description__c");
    },
    sortByNPR: function(component, event, helper) {
        helper.sortHelper(component, event, "Phoenix_Current_NPR__r.Name");
    },
    sortByCurrentProductNDC: function(component, event, helper) {
        helper.sortHelper(component, event, "Phoenix_Current_Product_NDC__c");
    },
    sortByCurrentProduct: function(component, event, helper) {
        helper.sortHelper(component, event, "Phoenix_Current_Product__r.Name");
    },
    sortByCurrentProductPackSize: function(component, event, helper) {
        helper.sortHelper(component, event, "Phoenix_Current_Product_Pack_Size__c");
    },
    sortByProposedProductNDC: function(component, event, helper) {
        helper.sortHelper(component, event, "Phoenix_Proposed_Product_NDC__c");
    },
    sortByProposedProduct: function(component, event, helper) {
        helper.sortHelper(component, event, "Phoenix_Proposed_Product__r.Name");
    },
    sortByProposedProductPackSize: function(component, event, helper) {
        helper.sortHelper(component, event, "Phoenix_Proposed_Product_Pack_Size__c");
    },
    sortByContractPrice: function(component, event, helper) {
        helper.sortHelper(component, event, "Phoenix_Contract_Price__c");
    },
    sortByAwardedPosition: function(component, event, helper) {
        helper.sortHelper(component, event, "Phoenix_Awarded_Position__c");
    },
    sortByAwardedQuantity: function(component, event, helper) {
        helper.sortHelper(component, event, "Phoenix_Awarded_Quantity__c");
    },
    sortBy3MonthsAnnualizedQuantity: function(component, event, helper) {
        helper.sortHelper(component, event, "Phoenix_3_Months_Annualized_Quantity__c");
    },
    sortByActualQty12m: function(component, event, helper) {
        helper.sortHelper(component, event, "Phoenix_Actual_Quantity_Last_12m__c");
    },
    sortByVarAwardedVs3mAnnualizedQty: function(component, event, helper) {
        helper.sortHelper(component, event, "Phoenix_Var_Awarded_vs_3m_Annualized_Qty__c");
    },
    sortByVarAwardedVs12mActualQty: function(component, event, helper) {
        helper.sortHelper(component, event, "Phoenix_Var_Awarded_vs_12m_Actual_Qty__c");
    },
    sortByMonthlyVarAwardedVs3mAnnualizedQty: function(component, event, helper) {
        helper.sortHelper(component, event, "Phoenix_Monthly_Var_Awarded_v_s_3m_Annua__c");
    },
    sortByMonthlyVarAwardedVs12mActualQty: function(component, event, helper) {
        helper.sortHelper(component, event, "Phoenix_Monthly_Var_Awarded_v_s_12m_Actu__c");
    },
    sortBySCMApproval: function(component, event, helper) {
        helper.sortHelper(component, event, "Phoenix_SCM_Approval_Y_N__c");
    },
     sortBySubmitterRemarks: function(component, event, helper) {
        helper.sortHelper(component, event, "Phoenix_Submitter_Remarks__c");
    },
    sortByLeadTimeSCM: function(component, event, helper) {
        helper.sortHelper(component, event, "Phoenix_Lead_Time__c");
    },
    sortBySCMRemarks: function(component, event, helper) {
        helper.sortHelper(component, event, "Phoenix_Remarks__c");
    },
    sortByFinanceApproval: function(component, event, helper) {
        helper.sortHelper(component, event, "Phoenix_Finance_Approval__c");
    },
    sortByFinanceRemarks: function(component, event, helper) {
        helper.sortHelper(component, event, "Phoenix_Finance_Approval_Remarks__c");
    },
    sortByContractsSentToCustomer: function(component, event, helper) {
        helper.sortHelper(component, event, "Phoenix_Contracts_Approval__c");
    },
    sortBySentToCustomerDate: function(component, event, helper) {
        helper.sortHelper(component, event, "Phoenix_Sent_to_Customer_Date__c");
    },
    sortByContractsRemarks: function(component, event, helper) {
        helper.sortHelper(component, event, "Phoenix_Contracts_Approval_Remarks__c");
    },
    sortByCustomerApproval: function(component, event, helper) {
        helper.sortHelper(component, event, "Pheonix_Customer_Approval__c");
    },
    sortByNewNDCEffectiveDate: function(component, event, helper) {
        helper.sortHelper(component, event, "Phoenix_New_NDC_Effective_Date__c");
    },
    sortByCustomerRemarks: function(component, event, helper) {
        helper.sortHelper(component, event, "Phoenix_Customer_Acceptance_Remarks__c");
    },
    sortByVistexApproval: function(component, event, helper) {
        helper.sortHelper(component, event, "Phoenix_Vistex_Final_Approval__c");
    },    
    sortByVistexApprovalRemarks: function(component, event, helper) {
        helper.sortHelper(component, event, "Phoenix_Vistex_Approval_Remarks__c");
    },
    
})