({
     initRecords: function(component, event, helper) { 
       
        component.set('v.isSpinnerLoad',true);
        component.set('v.showSaveCancelBtn',false);
        component.set("v.showPriceMsg",false);
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
                                   var loggedinUserName=wrapperObj.loggedInUserName;
                                   var isSRxApprovePerson=wrapperObj.isSRxApprovePerson;
                                    var loggedInUserId=wrapperObj.loggedInUserId;
                               	var isMarketingApprovePerson=wrapperObj.isMarketingApprovePerson;
                                     var isVistexApprovePerson=wrapperObj.isVistexApprovePerson;
                                     console.log('isMarketingApprovePerson-----'+isMarketingApprovePerson);
                                     console.log('loggedinUserName-----'+loggedinUserName);
                                   var isFinanceApprovePerson=wrapperObj.isFinanceApprovePerson;
                                    console.log('isFinanceApprovePerson-----'+isFinanceApprovePerson);
                                     var showProceedBtn=wrapperObj.showProceedBtn;
                                     var conditionApproval=wrapperObj.conditionApproval;
                                   console.log('conditionApproval-----'+conditionApproval);
                                     component.set("v.conditionApproval",conditionApproval);
                                    component.set("v.loggedInUserName",loggedinUserName);
                                     component.set("v.showProceedBtn",showProceedBtn);
                                    console.log('showProceedBtn-----'+showProceedBtn);
                                     component.set("v.loggedInUserId",loggedInUserId);
                                  
                                   component.set("v.isMarketingApprovePerson",isMarketingApprovePerson);
                                     component.set("v.isFinanceApprovePerson",isFinanceApprovePerson);
                                    component.set("v.isVistexApprovePerson",isVistexApprovePerson);
                                    component.set("v.isSRxApprovePerson",isSRxApprovePerson);
                                   component.set("v.BidLineItemListAll",lineItemsList);
                                   component.set('v.isSpinnerLoad',false);                                  
                                  component.set("v.bidNumber",bidRecord.Name);                                 
                                   component.set("v.bidName",bidRecord.Phoenix_Bid_Name__c);
                                   
                                console.log('isSRxApprovePerson-----'+isSRxApprovePerson);
                                   
                                   if( bidRecord.Phoenix_Bid_Type__c!=null && bidRecord.Phoenix_Bid_Type__c!=undefined){
                                        component.set("v.BidTypeVal",bidRecord.Phoenix_Bid_Type__c);
                                   }
                                   if( bidRecord.Phoenix_Approval_Status__c!=null && bidRecord.Phoenix_Approval_Status__c!=undefined){
                                        component.set("v.BidAprrovalStatus",bidRecord.Phoenix_Approval_Status__c);
                                   }
                                   
                                   
                                     console.log('BidAprrovalStatus-----'+bidRecord.Phoenix_Approval_Status__c);
                               
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
         component.set("v.showPriceMsg",false);
       
       var count=0;
        var countrec=0;
       var saveditems=component.get("v.BidLineItemListAll");
        for(var i=0;i<saveditems.length;i++){
           
            if(saveditems[i].Phoenix_Proposed_IPA_Price__c==undefined ||saveditems[i].Phoenix_Proposed_IPA_Price__c=='' || saveditems[i].Phoenix_Proposed_IPA_Price__c==null){
                count=count+1;
                
            }
            if(component.get("v.BidTypeVal")=='SRx IPA Product Addition'){
            if(saveditems[i].Phoenix_IDN_Usage__c==undefined ||saveditems[i].Phoenix_IDN_Usage__c=='' ||saveditems[i].Phoenix_IDN_Usage__c==null){
                countrec=countrec+1;
                
            }
            }
            
            
        }
        if(count>0){
            component.set("v.showProposedMsg",true);
        }
        else{
            component.set("v.showProposedMsg",false);  
        }
        if(countrec>0){
            component.set("v.showIDNMsg",true);  
        }
        else{
            component.set("v.showIDNMsg",false);   
        }
         var showProposedMsg=component.get("v.showProposedMsg");
        var showIDNMsg=component.get("v.showIDNMsg");
        if(showIDNMsg==false && showProposedMsg==false){
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
     showSaveCancel: function (component, event, helper) {
        component.set("v.showSaveCancel",true);  
    },
    closeApproval:  function (component, event, helper) {
         $A.get('e.force:refreshView').fire();
        component.set("v.showSaveCancel",false);  
    },
     initRejectedStatus : function(component, event, helper) {
        var rejectedStatus = component.find('RejectedStatusChildCmp');
        rejectedStatus.IPArejectedStatusRefresh();
    },
    saveApproval: function (component, event, helper) {
        var finComm=component.find("contrComments").get("v.value");

        var finAppStatus=component.find("contrAppStatus").get("v.value");
          
      
        var approvalStatus=component.get("v.BidAprrovalStatus");
        var action = component.get("c.saveTobid");
        action.setParams({
            'bidId' : component.get("v.recordId"),
            'comments':finComm,
            'status':finAppStatus
           
        });
        action.setCallback(this, function (response){
            if(response.getState() === "SUCCESS"){
                component.set("v.bidwrap",response.getReturnValue());
               // component.set("v.showProceedBtn",true);
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
        hiddenElement.download = 'Edit IPA Line Items'+'-'+bidNumber+'-'+bidName+'-'+Now+'.csv';  // CSV file Name* you can change it.[only name not .csv] 
        document.body.appendChild(hiddenElement); // Required for FireFox browser
        hiddenElement.click(); // using click() js function to download csv file
    },
    onMarketingChange :function(component,event, helper){
        component.set("v.showSaveCancelBtn",true);
        component.set("v.isMarketingChanged",true);
          var LineItemList= component.get("v.BidLineItemListAll");
         var marketingType = component.find("headerMarketingApproval");
          var loggedInUserName=component.get("v.loggedInUserName");
        console.log('marketingType--'+marketingType);
        var marketingHeader;
        if(marketingType != null){
            marketingHeader = marketingType.get("v.value");
            console.log('marketingHeader---'+marketingHeader);
        }else{
            marketingHeader= '';
        }
         if(marketingHeader!=null && marketingHeader!='' && marketingHeader!=undefined){
             LineItemList.forEach(function(line){ if(line['Phoenix_Conditional_Approval_Req_for_Flo__c']==true && line['Phoenix_Product_Director1__c']==loggedInUserName){
                 line['Phoenix_Marketing_Approval__c'] = marketingHeader;
             }
                                                  
                                               
                                              
                                           });
         } 
         component.set("v.BidLineItemListAll",LineItemList);
         
         
    },
      onApprovalChange:  function(component,event, helper){
        component.set("v.showSaveCancelBtn",true);
        component.set("v.isApprovalChanged",true);
           var LineItemList= component.get("v.BidLineItemListAll");
          var contractApproval;
           var contractApprovaltype = component.find("headerContractApproval");
          if(contractApprovaltype != null){
            contractApproval = contractApprovaltype.get("v.value");
        }else{
            contractApproval= '';
        }
           if(contractApproval!=null && contractApproval!='' && contractApproval!=undefined){
          LineItemList.forEach(function(line){
              
                                               line['Phoenix_Contract_Approval__c'] = contractApproval;
                                                  
                                               
                                              
                                           });
         }
          component.set("v.BidLineItemListAll",LineItemList);
          
    },
    onFinanceApprovalChange :  function(component,event, helper){
        component.set("v.showSaveCancelBtn",true);
       
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
     onApprovalVistexChange:  function(component,event, helper){
        component.set("v.showSaveCancelBtn",true);
        
        var LineItemList= component.get("v.BidLineItemListAll");
        var vistexApproval;
        var headerVistexApproval = component.find("headerVistexApproval");
        if(headerVistexApproval != null){
            vistexApproval = headerVistexApproval.get("v.value");
        }else{
            vistexApproval= '';
        }
        if(vistexApproval!=null && vistexApproval!='' && vistexApproval!=undefined){
            LineItemList.forEach(function(line){
                
                line['Phoenix_Vistex_Status__c'] = vistexApproval;
                
                
                
            });
        }
        component.set("v.BidLineItemListAll",LineItemList);
        
    },
    saveToProceedContracts: function(component,event,helper){
        var isContracts=true;
        var isMarketing=false;
        var isFinance=false;
        helper.submitForProceed(component,event,helper,isMarketing,isFinance,isContracts);
    },
    saveToProceedMarketing:function(component,event,helper){
      var isContracts=false;
        var isMarketing=true;
        var isFinance=false;

        helper.submitForProceed(component,event,helper,isMarketing,isFinance,isContracts);
    },
    saveToProceedFinance:function(component,event,helper){
       
       var isContracts=false;
        var isMarketing=false;
        var isFinance=true;
        
        helper.submitForProceed(component,event,helper,isMarketing,isFinance,isContracts);
    },
    
     saveToProceedVistex: function(component,event,helper){
        helper.submitForProceedVistex(component,event,helper);    
    },
    
})