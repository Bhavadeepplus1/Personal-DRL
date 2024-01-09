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
                                   var isContractsApprovePerson=wrapperObj.isContractsApprovePerson;
                                     var BidContractPerson=wrapperObj.BidContractPerson;
                                      var showProceedContrBtn=wrapperObj.showProceedContrBtn;
                                   
                                 
                                   component.set("v.BidLineItemListAll",lineItemsList);
                                   component.set('v.isSpinnerLoad',false);                                  
                                  component.set("v.bidNumber",bidRecord.Name);                                 
                                   component.set("v.bidName",bidRecord.Phoenix_Bid_Name__c);
                                     component.set("v.showProceedContrBtn",showProceedContrBtn);
                                   
                                
                                   
                                   if( bidRecord.Phoenix_Bid_Type__c!=null && bidRecord.Phoenix_Bid_Type__c!=undefined){
                                        component.set("v.BidTypeVal",bidRecord.Phoenix_Bid_Type__c);
                                   }
                                   if( bidRecord.Phoenix_Approval_Status__c!=null && bidRecord.Phoenix_Approval_Status__c!=undefined){
                                       component.set("v.BidAprrovalStatus",bidRecord.Phoenix_Approval_Status__c);
                                   }
                                    console.log('BidAprrovalStatus--'+component.get("v.BidAprrovalStatus"));
                                   console.log('loggedinUserName--'+loggedinUserName);
                                   if( loggedinUserName!=null && loggedinUserName!=undefined){
                                       component.set("v.loggedInUserName",loggedinUserName);
                                   }
                                    if( isContractsApprovePerson!=null && isContractsApprovePerson!=undefined){
                                       component.set("v.isContractsApprovePerson",isContractsApprovePerson);
                                   }
                                   if( BidContractPerson!=null && BidContractPerson!=undefined){
                                       component.set("v.BidContractPerson",BidContractPerson);
                                   }
                                  console.log('BidContractPerson--'+component.get("v.BidContractPerson"));
                                    console.log('isContractsApprovePerson--'+component.get("v.isContractsApprovePerson"));
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
                                               line['Phoenix_Contract_Status__c'] = contractApproval;
                                                  
                                               
                                              
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
                                       hiddenElement.download = 'Edit IPA Members'+'-'+bidNumber+'-'+bidName+'-'+Now+'.csv';  // CSV file Name* you can change it.[only name not .csv] 
                                       document.body.appendChild(hiddenElement); // Required for FireFox browser
                                       hiddenElement.click(); // using click() js function to download csv file
                                       console.log("response--->"+JSON.stringify(ResultData));
                                   }
          });
         $A.enqueueAction(action);
        
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
     saveToProceedContracts: function(component,event,helper){
       
        
        helper.submitForProceed(component,event,helper);
    },
    
})