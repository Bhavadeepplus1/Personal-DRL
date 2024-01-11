({
	  initRecords: function(component, event, helper) { 
        component.set("v.isSpecificCustomer",false);
        component.set("v.templateType","");
        component.set('v.isSpinnerLoad',true);
        component.set('v.selectedCntrcts',[]);
        component.set('v.lstSelectedRecords',[]);
        component.set('v.lstSelectedPDRecords',[]);
        component.set('v.showSaveCancelBtn',false);
        component.set('v.isRxChecked',false);
        component.set('v.isSRxChecked',false);
        component.set('v.isOtcChecked',false); 
        component.set('v.RxSrxList',[]); 
        component.set("v.BidTypeVal","");
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
                                   console.log('----------lineItemsList---------'+lineItemsList);
                                   var columnList = wrapperObj.columnList;
                                   var bidRecord = wrapperObj.bidRecord;
                                   
                                   if(lineItemsList.length == 0 || component.get("v.recordId") == null){
                                       component.set("v.isRelatedLineItemsEmpty", false);
                                   }
                                   
                                   component.set('v.defaultlistOfProductFamily', wrapperObj.productfamilyList);
                                   if( wrapperObj.productDirectorList!=null){
                                       component.set('v.defaultlistOfProductDirectors', wrapperObj.productDirectorList);
                                   }
                                   
                                   component.set("v.BidLineItemListAll",lineItemsList);
                                   component.set('v.isSpinnerLoad',false);                                  
                                   component.set("v.templateType",bidRecord.Phoenix_Customer_Type__c);
                                   component.set("v.bidNumber",bidRecord.Name);                                 
                                   component.set("v.bidName",bidRecord.Phoenix_Bid_Name__c);
                                   console.log('refcontrcts--'+bidRecord.Phoenix_Reference_Contracts__c);
                                   if( bidRecord.Phoenix_Reference_Contracts__c!=null && bidRecord.Phoenix_Reference_Contracts__c!=undefined){
                                       var refContracts=bidRecord.Phoenix_Reference_Contracts__c;
                                       component.set("v.selectedCntrcts",refContracts.split(','));
                                   }
                                   console.log('bidRecord.Phoenix_Bid_Type__c---'+bidRecord.Phoenix_Bid_Type__c);
                                   if( bidRecord.Phoenix_Bid_Type__c!=null && bidRecord.Phoenix_Bid_Type__c!=undefined){
                                       component.set("v.BidTypeVal",bidRecord.Phoenix_Bid_Type__c);
                                   }
                                   if( bidRecord.Phoenix_Is_Re_Bid__c!=null && bidRecord.Phoenix_Is_Re_Bid__c!=undefined && bidRecord.Phoenix_Is_Re_Bid__c==true){
                                       component.set("v.isReBid",true);
                                   }
                                   var LineItemtable = component.find("LineTable");
                                    component.set("v.tableRef",LineItemtable);
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
        component.find("navigationService").navigate({
            type: "standard__recordPage",
            attributes: {
                recordId: component.get("v.recordId"),
                actionName: "view"
            }
        }, false);
        
    },
     downloadCsv : function(component,event,helper){    
        var action = component.get("c.getupdatedforExport");
        action.setParams({
            "bidId": component.get("v.recordId")
        });
        action.setCallback(this, function (a) {
            var isReBid = component.get("v.isReBid");
            console.log('isReBid--->' + isReBid);
            var ResultData = a.getReturnValue();
        
		var bidType=component.get("v.BidTypeVal");
        var template=component.get("v.templateType");
        var bidNumber =component.get("v.bidNumber");
        var bidName =component.get("v.bidName");
        // call the helper function which "return" the CSV data as a String   
        var csv = helper.convertArrayOfObjectsToCSV(component,ResultData,template,bidType,isReBid);   
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
        var Now=(date.getMonth()+1)+'_'+date.getDate()+'_'+date.getFullYear()+' '+hours+'_'+minutes+' '+newformat;
        hiddenElement.download = 'Rejected Status'+'-'+bidNumber+'-'+bidName+'-'+Now+'.csv';  // CSV file Name* you can change it.[only name not .csv] 
        document.body.appendChild(hiddenElement); // Required for FireFox browser
        hiddenElement.click(); // using click() js function to download csv file
        });
         $A.enqueueAction(action);
    },
    
   
   
  })