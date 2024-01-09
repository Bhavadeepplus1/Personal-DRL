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
                                   var isVistexSRxApprovePerson=wrapperObj.isVistexSRxApprovePerson;
                                  
                                   
                                 
                                   component.set("v.BidLineItemListAll",lineItemsList);
                                   component.set('v.isSpinnerLoad',false);                                  
                                  component.set("v.bidNumber",bidRecord.Name);                                 
                                   component.set("v.bidName",bidRecord.Phoenix_Bid_Name__c);
                                    component.set("v.isSRxApprovePerson",isSRxApprovePerson);
                                   component.set("v.isVistexSRxApprovePerson",isVistexSRxApprovePerson);
                                   
                                
                                   
                                   if( bidRecord.Phoenix_Bid_Type__c!=null && bidRecord.Phoenix_Bid_Type__c!=undefined){
                                        component.set("v.BidTypeVal",bidRecord.Phoenix_Bid_Type__c);
                                   }
                                   if( bidRecord.Phoenix_Approval_Status__c!=null && bidRecord.Phoenix_Approval_Status__c!=undefined){
                                       component.set("v.BidAprrovalStatus",bidRecord.Phoenix_Approval_Status__c);
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
    
     backToBid : function(component, event, helper){
         
         
        component.find("navService").navigate({
            type: "standard__recordPage",
            attributes: {
                recordId: component.get("v.recordId"),
                actionName: "view"
            }
        }, false);
     },
    
     downloadCsv : function(component,event,helper){    
        
        var ResultData = component.get("v.BidLineItemListAll");
         var action = component.get("c.getupdatedforExport");		
         action.setParams({		
             rcaLines : ResultData		
         });		
         action.setCallback(this, function(response)		
                            {		
                                if(response.getState()=="SUCCESS"){		
                                    ResultData = response.getReturnValue();
        var bidNumber=component.get("v.bidNumber");
        var bidName=component.get("v.bidName");
        var bidtype=component.get("v.BidTypeVal");
        // call the helper function which "return" the CSV data as a String   
        var csv = helper.convertArrayOfObjectsToCSV(component,ResultData,bidtype);   
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
                                    console.log("response--->"+JSON.stringify(ResultData));		
                                }		
                            });		
         $A.enqueueAction(action);
     },
    showSaveCancel: function (component, event, helper) {
        component.set("v.showSaveCancel",true);  
    },
    saveApproval: function (component, event, helper) {
        
        var getComments = component.find("contrComments");
        var finComm;
        if(component.find("contrComments")!= undefined && !$A.util.isArray(getComments)){
            finComm=getComments.get("v.value");
            console.log('is Array false');
        }else if(component.find("contrComments")!= undefined){
             finComm = getComments[0].get("v.value");
            console.log('is Array true');
        }
        var getfinAppStatus=component.find("contrAppStatus");
        var finAppStatus;
        if(component.find("contrAppStatus")!= undefined && !$A.util.isArray(getComments)){
            finAppStatus=getfinAppStatus.get("v.value");
        }else if(component.find("contrAppStatus")!= undefined){
             finAppStatus = getfinAppStatus[0].get("v.value");
        }
      
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
     vistsaveApproval: function (component, event, helper) {
        
        var getComments = component.find("vistComments");
        var finComm;
        if(component.find("vistComments")!= undefined && !$A.util.isArray(getComments)){
            finComm=getComments.get("v.value");
            console.log('is Array false');
        }else if(component.find("vistComments")!= undefined){
             finComm = getComments[0].get("v.value");
            console.log('is Array true');
        }
        var getfinAppStatus=component.find("vistAppStatus");
        var finAppStatus;
        if(component.find("vistAppStatus")!= undefined && !$A.util.isArray(getComments)){
            finAppStatus=getfinAppStatus.get("v.value");
        }else if(component.find("vistAppStatus")!= undefined){
             finAppStatus = getfinAppStatus[0].get("v.value");
        }
      
        var approvalStatus=component.get("v.BidAprrovalStatus");
        var action = component.get("c.vistsaveTobid");
        action.setParams({
            'bidId' : component.get("v.recordId"),
            'comments':finComm,
            'status':finAppStatus
           
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
                    "message": "Record has been Updated successfully."
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
    
     saveToProceedVistex: function (component, event, helper) {
       var bidRecord=component.get("v.bidwrap");
        var finComm=bidRecord.Phoenix_Vistex_Update_Comments__c;
       
        var finAppStatus=bidRecord.Phoenix_Vistex_Update__c;
           console.log('finAppStatus----'+finAppStatus);
         if(finAppStatus!=null && finAppStatus!=undefined && finAppStatus!=''){
        var approvalStatus=component.get("v.BidAprrovalStatus");
        var action = component.get("c.makeApprovalsIPAVistex");
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
    
    
    SaveAndNavigate: function(component, event, helper){
         component.set("v.showPriceMsg",false);
        component.set("v.showDEAMsg",false);
         component.set("v.showGPOMsg",false);
         component.set("v.showWholesalerMsg",false);
        var LineItemList=component.get("v.BidLineItemListAll");
       var countDEA=0;
        var countGPO=0;
        var countWholesaler=0;
        
     
         LineItemList.forEach(function(line){
             console.log('Phoenix_New_GPO__c-----'+line['Phoenix_New_GPO__c']);
             console.log('Phoenix_GLN__c-----'+line['Phoenix_GLN__c']);
             console.log('Phoenix_HIN__c-----'+line['Phoenix_HIN__c']);
             console.log('Phoenix_DEA__c-----'+line['Phoenix_DEA__c']);
             if((line['Phoenix_GLN__c']!=null && line['Phoenix_GLN__c']!=undefined && line['Phoenix_GLN__c']!='')|| (line['Phoenix_HIN__c']!=null && line['Phoenix_HIN__c']!=undefined && line['Phoenix_HIN__c']!='') || (line['Phoenix_DEA__c']!=null && line['Phoenix_DEA__c']!=undefined && line['Phoenix_DEA__c']!='')  ){
              console.log('IN DEA') ;
             }
             else{
                  console.log('IN count DEA') ;
                 countDEA++;
                  console.log('IN count DEA'+countDEA) ;
                
             }
             if((line['Phoenix_New_GPO__c']==null || line['Phoenix_New_GPO__c']==undefined || line['Phoenix_New_GPO__c']=='' || line['Phoenix_New_GPO__c']=='--None--' || line['Phoenix_New_GPO__c']==' '||line['Phoenix_New_GPO__c']==" " )){
                  
                  countGPO++;
                 console.log('hi in GPO');
             }
             
             if((line['Phoenix_Wholesaler__c']==null || line['Phoenix_Wholesaler__c']==undefined || line['Phoenix_Wholesaler__c']=='' || line['Phoenix_Wholesaler__c']=='-- None --')){
                  console.log('hi in Phoenix_Wholesaler__c');
                  countWholesaler++;
             } 
             if(line['Phoenix_Wholesaler_Location__c']==null || line['Phoenix_Wholesaler_Location__c']==undefined || line['Phoenix_Wholesaler_Location__c']=='' || line['Phoenix_Wholesaler_Location__c']=='-- None --'){
                //countWholesaler++; 
             }
            
            
             
             
 });
          
        
        if(countDEA>0){
           
          component.set("v.showDEAMsg",true);   
        }
        else{
          component.set("v.showDEAMsg",false);      
        }
        if(countGPO>0){
          component.set("v.showGPOMsg",true);   
        }
        else{
          component.set("v.showGPOMsg",false);      
        }
        if(countWholesaler>0){
          component.set("v.showWholesalerMsg",true);   
        }
        else{
          component.set("v.showWholesalerMsg",false);      
        }
         var showDEAMsg=component.get("v.showDEAMsg");
          var showGPOMsg=component.get("v.showGPOMsg");
         var showWholesalerMsg=component.get("v.showWholesalerMsg");
          if(showDEAMsg){
          var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": 'error',
                    "message": "Please enter a value for DEA or HIN or GLN"
                });
                toastEvent.fire();  
        }
        else if(showGPOMsg){
           var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": 'error',
                    "message": "Please select GPO"
                });
                toastEvent.fire(); 
        }
            else if(showWholesalerMsg){
               var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": 'error',
                    "message": "Please select Wholesaler Name"
                });
                toastEvent.fire(); 
            }       
          if(showDEAMsg==false && showGPOMsg==false && showWholesalerMsg==false){
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
        component.set("v.showPriceMsg",false);
        //component.set("v.showSaveCancelBtn",false);
        $A.get('e.force:refreshView').fire();
          
    },
     initContractsView : function(component, event, helper) {
        var rejectedStatus = component.find('ContractsTab');
        //rejectedStatus.ContractsViewRefresh();
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
    
})