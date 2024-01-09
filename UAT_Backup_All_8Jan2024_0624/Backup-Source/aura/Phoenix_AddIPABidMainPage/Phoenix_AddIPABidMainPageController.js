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
                                   var loggedinUserName=wrapperObj.loggedInUserName;
                                   var BidContractPerson=wrapperObj.BidContractPerson;
                                   var isContractsApprovePerson=wrapperObj.isContractsApprovePerson;
                                   var isCustomerServiceApprovePerson=wrapperObj.isCustomerServiceApprovePerson;
                                   var showProceedBtn=wrapperObj.showProceedBtn;
                                   var showProceedContrBtn=wrapperObj.showProceedContrBtn;
                                   var showProceedVistexBtn=wrapperObj.showProceedVistexBtn;
                                   console.log('showProceedVistexBtn-->'+showProceedVistexBtn);
                                   var showProceedCusServcBtn=wrapperObj.showProceedCusServcBtn;
                                   console.log('showProceedCusServcBtn-->'+showProceedCusServcBtn);
                                   var loggedInUserId=wrapperObj.loggedInUserId;
                                   var isVistexApprovePerson=wrapperObj.isVistexApprovePerson;
                                   var isSCMApprovePerson=wrapperObj.isSCMApprovePerson;
                                   var conditionApproval=wrapperObj.conditionApproval;
                                   console.log('conditionApproval----'+conditionApproval);
                                   var isMarketingApprovePerson=wrapperObj.isMarketingApprovePerson;
                                   var isFinanceApprovePerson=wrapperObj.isFinanceApprovePerson;
                                   console.log('showProceedBtn'+showProceedBtn);
                                   console.log('isMarketingApprovePerson'+isMarketingApprovePerson);
                                   console.log('BidContractPerson'+BidContractPerson);
                                   console.log('isContractsApprovePerson'+isContractsApprovePerson);
                                    console.log('isCustomerServiceApprovePerson'+isCustomerServiceApprovePerson);
                                   component.set("v.isSCMApprovePerson",isSCMApprovePerson);
                                   component.set("v.isMarketingApprovePerson",isMarketingApprovePerson);
                                   component.set("v.isFinanceApprovePerson",isFinanceApprovePerson);
                                   
                                   component.set("v.showProceedContrBtn",showProceedContrBtn);
                                   component.set("v.isVistexApprovePerson",isVistexApprovePerson);
                                   component.set("v.isCustomerServiceApprovePerson",isCustomerServiceApprovePerson);
                                   component.set("v.conditionApproval",conditionApproval);
                                   component.set("v.showProceedBtn",showProceedBtn);
                                   component.set("v.showProceedVistexBtn",showProceedVistexBtn);
                                   component.set("v.showProceedCusServcBtn",showProceedCusServcBtn);
                                   
                                   component.set("v.BidLineItemListAll",lineItemsList);
                                   component.set('v.isSpinnerLoad',false);                                  
                                   component.set("v.bidNumber",bidRecord.Name);                                 
                                   component.set("v.bidName",bidRecord.Phoenix_Bid_Name__c);
                                   component.set("v.bidRec",bidRecord);
                                   
                                   
                                   
                                   if( bidRecord.Phoenix_Bid_Type__c!=null && bidRecord.Phoenix_Bid_Type__c!=undefined){
                                       component.set("v.BidTypeVal",bidRecord.Phoenix_Bid_Type__c);
                                   }
                                   if( bidRecord.Phoenix_Approval_Status__c!=null && bidRecord.Phoenix_Approval_Status__c!=undefined){
                                       component.set("v.BidAprrovalStatus",bidRecord.Phoenix_Approval_Status__c);
                                   }
                                   console.log('loggedinUserName--'+loggedinUserName);
                                   console.log('loggedInUserId--'+loggedInUserId);
                                   if( loggedinUserName!=null && loggedinUserName!=undefined){
                                       component.set("v.loggedInUserName",loggedinUserName);
                                   }
                                   if( loggedInUserId!=null && loggedInUserId!=undefined){
                                       component.set("v.loggedInUserId",loggedInUserId);
                                   }
                                   if( isContractsApprovePerson!=null && isContractsApprovePerson!=undefined){
                                       component.set("v.isContractsApprovePerson",isContractsApprovePerson);
                                   }
                                   if( BidContractPerson!=null && BidContractPerson!=undefined && BidContractPerson!=''){
                                       component.set("v.BidContractPerson",BidContractPerson);
                                   }
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
    onCustomerDateChange:  function(component,event, helper){
        component.set("v.showSaveCancelBtn",true);
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
    onPriceEffDateChange: function(component,event, helper){
        component.set("v.showSaveCancelBtn",true);
        component.set("v.isApprovalChanged",true);
        var LineItemList= component.get("v.BidLineItemListAll");
      
        var priceEffectiveDate = component.get("v.priceEffectiveDate");
        
        if(priceEffectiveDate!=null && priceEffectiveDate!='' && priceEffectiveDate!=undefined){
            LineItemList.forEach(function(line){
                
                line['Phoenix_Price_Effective_Date__c'] = priceEffectiveDate;
                
                
                
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
    onVistexApprovalChange:  function(component,event, helper){
        component.set("v.showSaveCancelBtn",true);
        
        var LineItemList= component.get("v.BidLineItemListAll");
        var vistexApproval;
        var headerVistexApproval = component.find("vistexHeaderApproval");
        if(headerVistexApproval != null){
            vistexApproval = headerVistexApproval.get("v.value");
        }else{
            vistexApproval= '';
        }
        if(vistexApproval!=null && vistexApproval!='' && vistexApproval!=undefined){
            LineItemList.forEach(function(line){
                
                line['Vistex_Customer_Code_Update_Status__c'] = vistexApproval;
                
                
                
            });
        }
        component.set("v.BidLineItemListAll",LineItemList);
        
    },
    onApprovalCustomerServiceChange:  function(component,event, helper){
        component.set("v.showSaveCancelBtn",true);
        
        var LineItemList= component.get("v.BidLineItemListAll");
        var customerserviceApproval;
        var headerCustomerServiceApproval = component.find("headerCustomerServiceApproval");
        if(headerCustomerServiceApproval != null){
            customerserviceApproval = headerCustomerServiceApproval.get("v.value");
        }else{
            customerserviceApproval= '';
        }
        // if(customerserviceApproval!=null && customerserviceApproval!='' && customerserviceApproval!=undefined){
        LineItemList.forEach(function(line){
            
            line['Phoenix_Customer_Service_Status__c'] = customerserviceApproval;
            
            
            
        });
        //}
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
        rejectedStatus.IPAContractsViewRefresh();
    },
    initRejectedStatus : function(component, event, helper) {
        var rejectedStatus = component.find('RejectedStatusChildCmp');
        rejectedStatus.IPArejectedStatusRefresh();
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
            
            if(saveditems[i].Phoenix_IDN_Usage__c==undefined ||saveditems[i].Phoenix_IDN_Usage__c=='' ||saveditems[i].Phoenix_IDN_Usage__c==null){
                countrec=countrec+1;
                
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
        var marketingType = component.find("headerMarketingApproval");
        var contractApprovaltype = component.find("headerContractApproval");
        console.log('marketingType--'+marketingType);
        var marketingHeader , contractApproval;
        if(marketingType != null){
            marketingHeader = marketingType.get("v.value");
            console.log('marketingHeader---'+marketingHeader);
        }else{
            marketingHeader= '';
        }
        if(contractApprovaltype != null){
            contractApproval = contractApprovaltype.get("v.value");
        }else{
            contractApproval= '';
        }
        var showProposedMsg=component.get("v.showProposedMsg");
        var showIDNMsg=component.get("v.showIDNMsg");
        if(showIDNMsg==false && showProposedMsg==false){
            component.set('v.isSpinnerLoad',true);
            
            var action = component.get("c.saveLineItems");
            action.setParams({
                'LineItemList': component.get("v.BidLineItemListAll"),
                bidRecord : component.get("v.bidRec")
                //"bidId":component.get("v.recordId"),
                //"marketingHeader": marketingHeader,
                //"isMarketingChanged": component.get("v.isMarketingChanged"),
                // "contractApproval": contractApproval,
                //"isApprovalChanged": component.get("v.isApprovalChanged"),
                //"approvalStatus": component.get("v.BidAprrovalStatus")
                
                
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var storeResponse = response.getReturnValue();
                    
                    component.set("v.showSaveCancelBtn",false);
                    component.set('v.isSpinnerLoad',false);
                    component.set('v.BidLineItemListAll',storeResponse);
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
        hiddenElement.download = 'Marketing & Contracts'+'-'+bidNumber+'-'+bidName+'-'+Now+'.csv';  // CSV file Name* you can change it.[only name not .csv] 
        document.body.appendChild(hiddenElement); // Required for FireFox browser
        hiddenElement.click(); // using click() js function to download csv file
    },
    saveToProceedContracts: function(component,event,helper){
        var isContracts=true;
        
        if(component.get("v.bidRec").Phoenix_Sent_to_Customer_Date__c == undefined || component.get("v.bidRec").Phoenix_Sent_to_Customer_Date__c == null){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type":"Error",
                "title": "Failed!",
                "message": "Please Enter Sent to Customer Date.."
            });
            toastEvent.fire();
        }else{
            helper.submitForProceed(component,event,helper,isContracts);
        }
        
    },
    saveToProceedMarketing:function(component,event,helper){
        var isContracts=false;
        
        helper.submitForProceed(component,event,helper,isContracts);
    },
    saveToProceedVistex: function(component,event,helper){
        var approvalStatus = component.get("v.BidAprrovalStatus");
        helper.submitForProceedVistex(component,event,helper,approvalStatus);    
    },
     saveToProceedCustomerService: function(component,event,helper){
        helper.submitForProceedCustomer(component,event,helper);    
    }
    
})