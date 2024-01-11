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
                                    var loggedinUserName=wrapperObj.loggedInUserName;
                                   var isSRxApprovePerson=wrapperObj.isSRxApprovePerson;
                                    var loggedInUserId=wrapperObj.loggedInUserId;
                                    var isMarketingApprovePerson=wrapperObj.isMarketingApprovePerson;
                                     var isFinanceApprovePerson=wrapperObj.isFinanceApprovePerson;
                                     var showProceedBtn=wrapperObj.showProceedBtn;
                                   var showproceedlead = wrapperObj.showproceedlead;
                                      var isMarketingLeadrx = wrapperObj.showproceedleadrx;
                                      var isMarketingLeadsrx = wrapperObj.showproceedleadsrx;
                                      var isMarketingLeadotc = wrapperObj.showproceedleadotc;
                                   var isMarketingLeadrxApprovePerson = wrapperObj.isMarketingLeadrxApprovePerson; 
                                             var isMarketingLeadsrxApprovePerson = wrapperObj.isMarketingLeadsrxApprovePerson; 
                                             var isMarketingLeadotcApprovePerson = wrapperObj.isMarketingLeadotcApprovePerson; 
                                  var isdelegationUserrx =wrapperObj.isdelegationUserrx; 
                                       var isdelegationUsersrx =wrapperObj.isdelegationUsersrx;
                                       var isdelegationUserotc =wrapperObj.isdelegationUserotc;
                                   var delagationuser1 = wrapperObj.delagationuser1; 
                                    var delagationuser = wrapperObj.delagationuser; 
                                  console.log('delagrtion user...'+JSON.stringify(delagationuser1));
                                    console.log('delagrtion user...'+JSON.stringify(delagationuser));
                                   	var isVistexApprovePerson=wrapperObj.isVistexApprovePerson;
                                    component.set("v.loggedInUserName",loggedinUserName);
                                     component.set("v.showProceedBtn",showProceedBtn);
                                    console.log('show proceed..'+JSON.stringify(showProceedBtn));
                                    component.set("v.delagationuser1",delagationuser1);
                                    component.set("v.delagationuser",delagationuser);
                                       component.set("v.isdelegationUserrx",isdelegationUserrx);
                                       component.set("v.isdelegationUsersrx",isdelegationUsersrx);
                                       component.set("v.isdelegationUserotc",isdelegationUserotc);
                                  component.set("v.loggedInUserId",loggedInUserId);
                                   console.log('srx approved..'+JSON.stringify(isdelegationUsersrx));
                                   console.log('issrx perosn..'+JSON.stringify(isMarketingLeadsrxApprovePerson));
                                    console.log('userinfo..'+JSON.stringify(loggedInUserId));
                                   // component.set("v.isdelegationUser",isdelegationUser);
                                     component.set("v.isVistexApprovePerson",isVistexApprovePerson);
                                   component.set("v.isMarketingApprovePerson",isMarketingApprovePerson);
                                     component.set("v.isMarketingLeadrxApprovePerson",isMarketingLeadrxApprovePerson);
                                    component.set("v.isMarketingLeadsrxApprovePerson",isMarketingLeadsrxApprovePerson);
                                    component.set("v.isMarketingLeadotcApprovePerson",isMarketingLeadotcApprovePerson);
                                     component.set("v.isFinanceApprovePerson",isFinanceApprovePerson);
                                 component.set("v.isSRxApprovePerson",isSRxApprovePerson);
                                    component.set("v.BidLineItemListAll",lineItemsList);
                                   component.set('v.isSpinnerLoad',false);                                  
                                  component.set("v.bidNumber",bidRecord.Name);                                 
                                      component.set("v.showproceedlead",showproceedlead); 
                                      component.set("v.isMarketingLeadotc",isMarketingLeadotc);  
                                      component.set("v.isMarketingLeadsrx",isMarketingLeadsrx);  
                                      component.set("v.isMarketingLeadrx",isMarketingLeadrx);  
                                   component.set("v.bidName",bidRecord.Phoenix_Bid_Name__c);
                                  if( bidRecord.Phoenix_Approval_Status__c!=null && bidRecord.Phoenix_Approval_Status__c!=undefined){
                                        component.set("v.BidAprrovalStatus",bidRecord.Phoenix_Approval_Status__c);
                                   }
                                   var fileList=[];
                                   var totalFiles=[];
                                   var checked=false;
                                   totalFiles=wrapperObj.conDocLink;
                                   if(totalFiles!=undefined&&totalFiles!=null)
                                   {
                                       for(var i=0;i<totalFiles.length;i++)
                                       {
                                           fileList.push({"Id":totalFiles[i].ContentDocumentId,"Title":totalFiles[i].ContentDocument.Title+'.'+totalFiles[i].ContentDocument.FileExtension,"checked":checked});
                                       }
                                   }
                                   component.set("v.fileList",fileList);
                                
                                   
                                   if( bidRecord.Phoenix_Bid_Type__c!=null && bidRecord.Phoenix_Bid_Type__c!=undefined){
                                        component.set("v.BidTypeVal",bidRecord.Phoenix_Bid_Type__c);
                                   }
                                   
                                   
                                  
                                   var OutDiv = component.find("mainDiv");
                                   if(lineItemsList.length<8){
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
     initRejectedStatus : function(component, event, helper) {
        var rejectedStatus = component.find('RejectedStatusChildCmp');
        rejectedStatus.IPArejectedStatusRefresh();
    },
    handleEvent: function(component, event, helper) {
        component.set('v.isSpinnerLoad',true);
       
        var message = event.getParam("message");
        var action = component.get("c.getRelatedList");
        console.log('recordId--------'+component.get("v.recordId"));
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
                               if(lineItemsList.length<8){
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
        var Bidtype=component.get("v.BidTypeVal");
        // call the helper function which "return" the CSV data as a String   
        var csv = helper.convertArrayOfObjectsToCSV(component,ResultData,template,Bidtype);   
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
        hiddenElement.download = 'Edit Line Items'+'-'+bidNumber+'-'+bidName+'-'+Now+'.csv';  // CSV file Name* you can change it.[only name not .csv] 
        document.body.appendChild(hiddenElement); // Required for FireFox browser
        hiddenElement.click(); // using click() js function to download csv file
    },
    handleUploadFinished: function (component, event, helper) {
        helper.handleUploadFinished(component, event);
    },
    deleteAttachment: function (component, event, helper) {
        
         var target = event.target;
        //var rowIndex = target.getAttribute("name")
        var selectedRec = target.getAttribute("name");
        console.log('selectedRec--->'+selectedRec);
         console.log('recordId--------'+component.get("v.recordId"));
        
        var action = component.get("c.deleteAttachments");
        console.log('action--->');
        action.setParams({
            'LineItemId' :selectedRec,
            'bidId':component.get("v.recordId")
        });
        action.setCallback(this,function(response) {
            var state = response.getState();
            if(state=='SUCCESS'){
            }
            
        });
        $A.enqueueAction(action);
        //var event = component.getEvent("lightningEvent");
        //event.setParam("message", "the message to send" );
        //event.fire();
        
        var AllRowsList = component.get("v.fileList");
        if (AllRowsList.length === 1) {
            console.log('AllRowsList.length === 1');
        }
        for (let i = 0; i < AllRowsList.length; i++) {
            var pItem = AllRowsList[i];
            if (pItem.Id == selectedRec) {
                var index = AllRowsList.indexOf(pItem);
                if (index > -1) {
                    AllRowsList.splice(index, 1);
                    var AllRowsList1 = AllRowsList;
                }
            }
        }
        component.set("v.fileList",[]);
        component.set("v.fileList", AllRowsList);
        
    },
     handleUploadFinished: function (component, event, helper) {
        helper.handleUploadFinished(component, event);
    },
    onMarketingLeadChange :function(component,event, helper){
        component.set("v.showSaveCancelBtn",true);
        component.set("v.isMarketingChanged",true);
          var LineItemList= component.get("v.BidLineItemListAll");
         var marketingType = component.find("headerMarketingLeadApproval");
          var loggedInUserName=component.get("v.loggedInUserName");
        console.log('marketingType--'+marketingType);
        var marketingHeader;
        if(marketingType != null){
            marketingHeader = marketingType.get("v.value");
            console.log('marketingHeaderlead---'+marketingHeader);
        }else{
            marketingHeader= '';
        }
         if(marketingHeader!=null && marketingHeader!='' && marketingHeader!=undefined){
             LineItemList.forEach(function(line){ if( line['Marketing_Lead__c']==loggedInUserName){
                 line['Phoenix_MarketingLead_Approver__c'] = marketingHeader;
             }
                                                  
           });
            /* LineItemList.forEach(function(line){
         		line['Phoenix_MarketingLead_Approver__c'] = marketingHeader;
             });*/
         } 
         component.set("v.BidLineItemListAll",LineItemList);
         
         
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
             LineItemList.forEach(function(line){ if( line['Phoenix_Product_Director1__c']==loggedInUserName){
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
          LineItemList.forEach(function(line){
                                               line['Phoenix_Finance_Approval__c'] = financeApproval;
          
                                                  
                                               
                                              
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
        var isMarketingLead=false;
        var isdelegationuser2=false;
        helper.submitForProceed(component,event,helper,isMarketing,isFinance,isContracts,isMarketingLead,isdelegationuser2);
    },
    saveToProceedMarketing:function(component,event,helper){
      var isContracts=false;
        var isMarketing=true;
        var isFinance=false;
         var isMarketingLead = false;
            var isdelegationuser2=false;
        helper.submitForProceed(component,event,helper,isMarketing,isFinance,isContracts,isMarketingLead,isdelegationuser2);
    },
    saveToProceedMarketingLead:function(component,event,helper){
      var isContracts=false;
        var isMarketing=false;
        var isFinance=false;
       var isMarketingLead= true;
        var isdelegationuser2=false;
       var delegationuser2= component.get("v.delegationuser");
        

        helper.submitForProceed(component,event,helper,isMarketing,isFinance,isContracts,isMarketingLead,isdelegationuser2);
    },
      saveToProceedMarketingLeadDelegation:function(component,event,helper){
      var isContracts=false;
        var isMarketing=false;
        var isFinance=false;
       var isMarketingLead= false;
      //  var isdelegationuser2=false;
          var isdelegationuser2=true;
        

        helper.submitForProceed(component,event,helper,isMarketing,isFinance,isContracts,isMarketingLead,isdelegationuser2);
    },
    saveToProceedFinance:function(component,event,helper){
       
       var isContracts=false;
        var isMarketing=false;
        var isFinance=true;
        var isMarketingLead = false;
            var isdelegationuser2=false;
        helper.submitForProceed(component,event,helper,isMarketing,isFinance,isContracts,isMarketingLead,isdelegationuser2);
    },
     saveToProceedVistex: function(component,event,helper){
     helper.submitForProceedVistex(component,event,helper);    
    },
    submitFor : function(component, event, helper) { 
        component.set("v.submitPopUp",true);
    }
    
})