({
    getData: function(component, event, helper){
        component.set('v.isSpinnerLoad',true);
        var bidId = component.get("v.bidId");
        component.set("v.recordId",bidId);
        console.log('bidId in AddVipRebateController ---- '+bidId);
        
        var action = component.get("c.getVipAndRelatedList");  
        action.setParams
        ({
            bidId : bidId,
            divisionTab: component.get("v.division"),
            customerId : component.get("v.selectedCustId"),
            'selectedType': component.get("v.typeRebate")
        });
        action.setCallback(this, function(response) 
                           {
                               if(response.getState()=="SUCCESS"){
                                   component.set("v.isVipRebateExist",true);
                                   var wrapperObj =  response.getReturnValue();
                                   var rebatesList = wrapperObj.rebatesList;
                                   var rebatesListProposed = wrapperObj.rebatesListProposed;
                                   var columnList = wrapperObj.columnList;
                                   var bidRecord = wrapperObj.bidRecord;
                                   var startDate=wrapperObj.strtDate;
                                   var endDate=wrapperObj.endDate;
                                   var type=wrapperObj.type;
                                   var exclusions=wrapperObj.exclusions;
                                   var excDetails=wrapperObj.excDetails;
                                   var startDatePro=wrapperObj.strtDatePro;
                                   var endDatePro=wrapperObj.endDatePro;
                                   var typePro=wrapperObj.typePro;
                                   var exclusionsPro=wrapperObj.exclusionsPro;
                                   var excDetailsPro=wrapperObj.excDetailsPro;
                                   var bidType=wrapperObj.bidType;
                                   var customerName=wrapperObj.custName;
                                   var currentRebRec=wrapperObj.currentRebate;
                                   var currentRebName=wrapperObj.currentRebateName;
                                   var proposedRebRec=wrapperObj.proposedRebate;
                                   var proposedRebName=wrapperObj.proposedRebateName;
                                   var approvalState=wrapperObj.approvalStatus;
                                   var loggedInUserId=wrapperObj.loggedInUserId;
                                   //console.log('Response: '+JSON.stringify(wrapperObj));
                                   component.set("v.paymentFrequency", wrapperObj.paymentFrequency);
                                   component.set("v.netGross", wrapperObj.netGross);
                                   component.set("v.proposedPaymentFrequency", wrapperObj.proposedPaymentFrequency);
                                   component.set("v.proposedNetGross", wrapperObj.proposedNetGross);
                                   console.log('Wrapper Division: '+wrapperObj.division);
                                   if(wrapperObj.division != undefined){
                                    	component.set("v.division", wrapperObj.division);   
                                   }
                                   if(wrapperObj.proposedNetGross != null){
                                       component.set("v.disableDivision", true);
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
                                   component.set("v.loggedInUserName",loggedInUserId);
                                   
                                   component.set("v.approvalStatus",approvalState);
                                   if(approvalState!='Draft'){
                                       component.set("v.doNotEdit",true); 
                                       component.set("v.disableInApproval",true);    
                                   }
                                   else{
                                       component.set("v.doNotEdit",false); 
                                       component.set("v.disableInApproval",false);
                                   }
                                   component.set("v.currentRec",currentRebRec);
                                   component.set("v.currentRecName",currentRebName);
                                   component.set("v.proposedRec",proposedRebRec);
                                   component.set("v.proposedRecName",proposedRebName);
                                   component.set("v.strtDateRebate",startDate);
                                   component.set("v.endDateRebate",endDate);
                                   component.set("v.typeRebate",type);
                                   component.set("v.checkBoxFieldCurrent",exclusions);
                                   component.set("v.excDetailsRebate",excDetails);
                                   component.set("v.strtDateRebatePro",startDatePro);
                                   component.set("v.endDateRebatePro",endDatePro);
                                   component.set("v.typeRebatePro",typePro);
                                   component.set("v.checkBoxField",exclusionsPro);
                                   component.set("v.excDetailsRebatePro",excDetailsPro);
                                   component.set("v.custName",customerName);
                                   component.set("v.bidType",bidType);
                                   var rebate=typePro;
                                   component.set("v.rebateType",rebate);
                                   component.set("v.isRebTypeChanged",true);
                                   if(rebatesList!=undefined){
                                       console.log('allocating the CurrentList -----');
                                       component.set("v.bidRebateCurrentList",rebatesList);   
                                   }
                                   if(rebatesListProposed!=undefined){
                                       console.log('allocating the proposedlist -----');
                                       component.set("v.bidRebateProposedList2",rebatesListProposed);
                                   }
                                   else{
                                       component.set("v.bidRebateProposedList2",[]);
                                   }
                                   component.set("v.bidRecords",bidRecord);
                                   component.set("v.busStatus",bidRecord.Phoenix_Business_Approval__c);
                                   component.set("v.busCom",bidRecord.Phoenix_Business_Approval_Comments__c);
                                   component.set("v.finStatus",bidRecord.Phoenix_Finance_Approval__c);
                                   component.set("v.finCom",bidRecord.Phoenix_Finance_Approval_Comments__c);
                                   component.set("v.contrStatus",bidRecord.Phoenix_Contracts_Approval__c);
                                   component.set("v.contrCom",bidRecord.Phoenix_Contracts_Approval_Comments__c);
                                   component.set("v.custStatus",bidRecord.Phoenix_Customer_Approval__c);
                                   component.set("v.custCom",bidRecord.Phoenix_Customer_Approval_Comments__c);
                                   component.set("v.vistStatus",bidRecord.Phoenix_Vistex_Update__c);
                                   component.set("v.vistCom",bidRecord.Phoenix_Vistex_Update_Comments__c);
                                   component.set('v.showSearchResult',true);
                                   component.set('v.isSpinnerLoad',false);
                                   
                                   if(approvalState=='Business Head'){
                                       
                                       if(bidRecord.Phoenix_Business_Approval__c=='--None--'){
                                           component.set("v.showProceedBtn",false);          
                                       }
                                       else if(bidRecord.Phoenix_Business_Approval__c==undefined){
                                           component.set("v.showProceedBtn",false);          
                                       }
                                           else{
                                               component.set("v.showProceedBtn",true);          
                                               
                                           }    
                                   }
                                   
                                   if(approvalState=='Finance'){
                                       if(bidRecord.Phoenix_Finance_Approval__c=='--None--'){
                                           component.set("v.showProceedBtn",false);          
                                       }
                                       else if(bidRecord.Phoenix_Finance_Approval__c==undefined){
                                           component.set("v.showProceedBtn",false);          
                                       }
                                       
                                           else{
                                               component.set("v.showProceedBtn",true);          
                                               
                                           }  
                                   }
                                   
                                   
                                   if(approvalState=='Contracts'){ 
                                       if(bidRecord.Phoenix_Contracts_Approval__c=='--None--'){
                                           component.set("v.showProceedBtn",false);          
                                       }
                                       else if(bidRecord.Phoenix_Contracts_Approval__c==undefined){
                                           component.set("v.showProceedBtn",false);          
                                       }
                                           else{
                                               component.set("v.showProceedBtn",true);          
                                               
                                           }
                                   }
                                   
                                   
                                   
                                   if(approvalState=='Customer Pending'){ 
                                       if(bidRecord.Phoenix_Customer_Approval__c=='--None--'){
                                           component.set("v.showProceedBtn",false);          
                                       }
                                       else if(bidRecord.Phoenix_Customer_Approval__c==undefined){
                                           component.set("v.showProceedBtn",false);          
                                       }
                                           else{
                                               component.set("v.showProceedBtn",true);          
                                               
                                           } 
                                   }
                                   
                                   
                                   if(approvalState=='Vistex Update'){
                                       if(bidRecord.Phoenix_Vistex_Update__c=='--None--'){
                                           component.set("v.showProceedBtn",false);          
                                       }
                                       else if(bidRecord.Phoenix_Vistex_Update__c==undefined){
                                           component.set("v.showProceedBtn",false);          
                                       }
                                           else{
                                               component.set("v.showProceedBtn",true);          
                                               
                                           }    
                                   }
                                   
                                   
                                   
                                   
                                   component.set("v.bidNumber",bidRecord.Name);    
                                   component.set("v.bidName",bidRecord.Phoenix_Bid_Name__c);
                                   if( bidRecord.Phoenix_Bid_Type__c!=null && bidRecord.Phoenix_Bid_Type__c!=undefined){
                                       component.set("v.BidTypeVal",bidRecord.Phoenix_Bid_Type__c);
                                   }
                                   else{
                                       component.set('v.isSpinnerLoad',false);
                                   }
                                   
                                   var OutDiv = component.find("mainDiv1");
                                   if(rebatesListProposed==undefined){
                                       $A.util.addClass(OutDiv,"noheightClass");
                                   }
                                   else if(rebatesListProposed.length<4){
                                       $A.util.addClass(OutDiv,"noheightClass");
                                       
                                   }
                                       else{
                                           $A.util.removeClass(OutDiv,"noheightClass");
                                           //  $A.util.addClass(OutDiv,"heightClass");
                                       }
                               } else{
                                   console.log('Exception: '+JSON.stringify(response.getError()))   ;
                               }
                               
                           });
        $A.enqueueAction(action);
    },
    reCalculateHelper: function(component, event, helper) {
        let rebType = component.get("v.rebateType");
        var rebateListCopy = component.get("v.bidRebateProposedList2");
        if((rebateListCopy.length)<2){
            if(rebateListCopy[0].Phoenix_Unit_Volume_From__c!=undefined){
                rebateListCopy[0].Phoenix_Unit_Volume_To__c=null;    
            }
            if(rebateListCopy[0].Phoenix_Dollar_Value_From__c!=undefined){
                rebateListCopy[0].Phoenix_Dollar_Value_To__c=null;
            }        
        }
        
        else{
            for (let i = 0; i < (rebateListCopy.length)-1; i++) {
                console.log('rebateListCopy[i].Phoenix_Dollar_Value_From__c :: '+rebateListCopy[i].Phoenix_Dollar_Value_From__c);
                if((rebateListCopy[i].Phoenix_Dollar_Value_From__c>=rebateListCopy[i+1].Phoenix_Dollar_Value_From__c) &&(rebateListCopy[i+1].Phoenix_Dollar_Value_From__c!=null)&& (rebateListCopy[i].Phoenix_Dollar_Value_From__c!=null) && rebType=='Currency'){
                    var j=i+1
                    var k=j+1;
                    component.set('v.validFrom',true);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        
                        message:'Tier '+k+' Dollar Value should be greater than the Tier '+j+' Dollar Value',
                        duration:' 5000',
                        key: 'info_alt',
                        type: 'error',
                        mode: 'dismissible'
                    });
                    toastEvent.fire();
                    rebateListCopy[i].Phoenix_Dollar_Value_To__c=null;
                    return false;
                }
                
                else if((rebateListCopy[i].Phoenix_Unit_Volume_From__c>=rebateListCopy[i+1].Phoenix_Unit_Volume_From__c) &&(rebateListCopy[i+1].Phoenix_Unit_Volume_From__c!=null)&& (rebateListCopy[i].Phoenix_Unit_Volume_From__c!=null) && rebType=='Quantity'){
                    var j=i+1
                    var k=j+1;
                    component.set('v.validFrom',true);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        
                        message:'Tier '+k+' Unit Volume should be greater than the Tier '+j+' Unit Volume',
                        duration:' 5000',
                        key: 'info_alt',
                        type: 'error',
                        mode: 'dismissible'
                    });
                    toastEvent.fire();
                    rebateListCopy[i].Phoenix_Unit_Volume_To__c==null;  
                    return false;
                }
                
                    else{
                        component.set('v.validFrom',false);
                        if((rebateListCopy[(rebateListCopy.length)-1].Phoenix_Dollar_Value_From__c!==undefined) && (rebType=='Currency')){
                            rebateListCopy[(rebateListCopy.length)-1].Phoenix_Dollar_Value_To__c=null;
                        }
                        if((rebateListCopy[(rebateListCopy.length)-1].Phoenix_Unit_Volume_From__c!==undefined)&& (rebType=='Quantity')){
                            rebateListCopy[(rebateListCopy.length)-1].Phoenix_Unit_Volume_To__c=null;
                        }
                        if(rebateListCopy[i+1].Phoenix_Unit_Volume_From__c!==null && rebType=='Quantity'){
                            //if(rebType=='Quantity'){
                            if(rebateListCopy[i].Phoenix_Unit_Volume_From__c==null){
                                var j=i+1;
                                var k=j+1;
                                component.set('v.validFrom',true);
                                var toastEvent = $A.get("e.force:showToast");
                                toastEvent.setParams({
                                    message:'Please enter the Tier '+j+' Unit Volume',
                                    duration:' 5000',
                                    key: 'info_alt',
                                    type: 'error',
                                    mode: 'dismissible'
                                });
                                toastEvent.fire();
                                rebateListCopy[i].Phoenix_Unit_Volume_To__c==null;
                                return false;
                            }
                            
                            else{
                                if(rebateListCopy[i+1].Phoenix_Unit_Volume_From__c==null){
                                    var j=i+1;
                                    var k=j+1;
                                    component.set('v.validFrom',true);
                                    var toastEvent = $A.get("e.force:showToast");
                                    toastEvent.setParams({
                                        
                                        message:'Please enter the Tier '+k+' Unit Volume',
                                        duration:' 5000',
                                        key: 'info_alt',
                                        type: 'error',
                                        mode: 'dismissible'
                                    });
                                    toastEvent.fire(); 
                                    rebateListCopy[i+1].Phoenix_Unit_Volume_From__c==null;
                                    return false;
                                }
                                else{
                                    rebateListCopy[i].Phoenix_Unit_Volume_To__c=(rebateListCopy[i+1].Phoenix_Unit_Volume_From__c)-1;     
                                }
                            }        
                            
                            
                            
                        }
                        if(rebateListCopy[i+1].Phoenix_Dollar_Value_From__c!==null  && rebType=='Currency'){
                            //if(rebType=='Currency'){  
                            if(rebateListCopy[i].Phoenix_Dollar_Value_From__c==null){
                                var j=i+1;
                                var k=j+1;
                                component.set('v.validFrom',true);
                                var toastEvent = $A.get("e.force:showToast");
                                toastEvent.setParams({
                                    
                                    message:'Please enter the Tier '+j+' Dollar Value',
                                    duration:' 5000',
                                    key: 'info_alt',
                                    type: 'error',
                                    mode: 'dismissible'
                                });
                                toastEvent.fire();
                                rebateListCopy[i].Phoenix_Dollar_Value_To__c==null;
                                return false;
                            }
                            
                            else{
                                if(rebateListCopy[i+1].Phoenix_Dollar_Value_From__c==null){
                                    var j=i+1;
                                    var k=j+1;
                                    component.set('v.validFrom',true);
                                    var toastEvent = $A.get("e.force:showToast");
                                    toastEvent.setParams({
                                        
                                        message:'Please enter the Tier '+k+' Dollar Value',
                                        duration:' 5000',
                                        key: 'info_alt',
                                        type: 'error',
                                        mode: 'dismissible'
                                    });
                                    toastEvent.fire(); 
                                    rebateListCopy[i+1].Phoenix_Dollar_Value_To__c==null;
                                    return false;
                                }
                                else{
                                    rebateListCopy[i].Phoenix_Dollar_Value_To__c=(rebateListCopy[i+1].Phoenix_Dollar_Value_From__c)-1;     
                                }
                            }       
                        }
                        if(rebateListCopy[i].Phoenix_Unit_Volume_To__c==-1){
                            rebateListCopy[i].Phoenix_Unit_Volume_To__c=null;  
                        }
                        if(rebateListCopy[i].Phoenix_Dollar_Value_To__c==-1){
                            rebateListCopy[i].Phoenix_Dollar_Value_To__c=null;  
                        }
                    }
            }  
        }
        var rebateListCopy1=rebateListCopy;
        component.set('v.bidRebateProposedList2',rebateListCopy1); 
        return true;
    },
    handleUploadFinished : function(component, event) {
        
        //   let pageReference = component.get("v.pageReference");
        let recordId =component.get("v.bidId");//component.get("v.recordId");
        //    let recordId = pageReference.state.c__recordId;
        component.set("v.recordId",recordId);
        var action = component.get('c.getDocs');
        action.setParams({'bidId' : component.get("v.recordId")});
        console
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log(state)
            console.log(state)
            if (state === "SUCCESS") {
                var fileList=[];
                var totalFiles=[];
                var checked=false;
                totalFiles=response.getReturnValue();
                if(totalFiles!=undefined&&totalFiles!=null)
                {
                    for(var i=0;i<totalFiles.length;i++)
                    {
                        console.log('---33333333---1-----');
                        fileList.push({"Id":totalFiles[i].ContentDocumentId,"Title":totalFiles[i].ContentDocument.Title+'.'+totalFiles[i].ContentDocument.FileExtension,"checked":checked});
                    }
                }
                console.log('------1-----');
                component.set("v.fileList",fileList);
                console.log('------1--2---'+JSON.stringify(response.getReturnValue()));
            }  
            if(state === "ERROR"){
                // component.set("v.isTSNotCreated","true");
            } 
            
        });
        $A.enqueueAction(action);
    },
    convertArrayOfObjectsToCSV : function(component,objectRecords,ResultData2){
        //  var bidType = component.get("v.bidType");
        // declare variables
        var csvStringResult, counter, keys,columnDivider, lineDivider;
        console.log('testing result--->'+JSON.stringify(objectRecords));
        // check if "objectRecords" parameter is null, then return from function
        /*if (objectRecords == null || !objectRecords.length) {
            return null;
        }*/
        // store ,[comma] in columnDivider variabel for sparate CSV values and 
        // for start next line use '\n' [new line] in lineDivider varaible  
        columnDivider = ',';
        lineDivider =  '\n';
        csvStringResult = '';
        var myMap1 = new Map();
        myMap1.set("Current Rebate", "");          
        csvStringResult += Array.from(myMap1.keys()).join(columnDivider);
        csvStringResult += lineDivider;
        var myMap = new Map();
        
        myMap.set("Tier", "Phoenix_Tier__c");
        myMap.set("Dollar Value From", "Phoenix_Dollar_Value_From__c");
        myMap.set("Dollar Value To", "Phoenix_Dollar_Value_To__c");
        myMap.set("Unit Volume From", "Phoenix_Unit_Volume_From__c");
        myMap.set("Unit Volume To", "Phoenix_Unit_Volume_To__c");
        myMap.set("Discount Rebate (%)", "Phoenix_Discount_Rebate__c");
        myMap.set("Remarks", "Phoenix_Remarks__c");
        
        
        csvStringResult += Array.from(myMap.keys()).join(columnDivider);
        csvStringResult += lineDivider;
        //new logic start 
        for (var i = 0; i < objectRecords.length; i++) {
            counter = 0;
            for (let [key, value] of myMap) {
                if (counter > 0) {
                    csvStringResult += columnDivider;
                }
                console.log('testing result--->' + JSON.stringify(objectRecords[i]));
                if (objectRecords[i][value] == undefined) {
                    csvStringResult += '"' + '' + '"';
                } else {
                    csvStringResult += '"' + objectRecords[i][value] + '"';
                }
                
                counter++;
            }
            csvStringResult += lineDivider;
        }   
        csvStringResult += lineDivider;
        //new logic end 
        var myMap3 = new Map();
        myMap3.set("Proposed Rebate", ""); 
        csvStringResult += Array.from(myMap3.keys()).join(columnDivider);
        csvStringResult += lineDivider;
        var myMap2 = new Map();
        
        myMap2.set("Tier", "Phoenix_Tier__c");
        myMap2.set("Dollar Value From", "Phoenix_Dollar_Value_From__c");
        myMap2.set("Dollar Value To", "Phoenix_Dollar_Value_To__c");
        myMap2.set("Unit Volume From", "Phoenix_Unit_Volume_From__c");
        myMap2.set("Unit Volume To", "Phoenix_Unit_Volume_To__c");
        myMap2.set("Discount Rebate (%)", "Phoenix_Discount_Rebate__c");
        myMap2.set("Remarks", "Phoenix_Remarks__c");
        
        
        csvStringResult += Array.from(myMap2.keys()).join(columnDivider);
        csvStringResult += lineDivider;
        //new logic start 
        for (var i = 0; i < ResultData2.length; i++) {
            counter = 0;
            for (let [key, value] of myMap) {
                if (counter > 0) {
                    csvStringResult += columnDivider;
                }
                console.log('testing result--->' + JSON.stringify(ResultData2[i]));
                if (ResultData2[i][value] == undefined) {
                    csvStringResult += '"' + '' + '"';
                } else {
                    csvStringResult += '"' + ResultData2[i][value] + '"';
                }
                
                counter++;
            }
            csvStringResult += lineDivider;
            
        }   
        
        return csvStringResult;     
    }    
})