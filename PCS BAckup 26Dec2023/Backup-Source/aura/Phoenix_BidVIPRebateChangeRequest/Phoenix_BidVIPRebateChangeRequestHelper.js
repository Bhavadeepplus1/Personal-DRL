({
    getData: function(component, event, helper){
        component.set('v.isSpinnerLoad',true);
        var recordId = component.get("v.c__recordId");//pageReference.state.c__recordId;
        console.log('recordId :: '+recordId);
        
        component.set("v.recordId",recordId);
        var action = component.get("c.getBidVipRebateCount");
        action.setParams({bidId: recordId, divisionTab: component.get("v.division")});
        action.setCallback(this, function(response){
            console.log('doInit resturn sate :: '+response.getState());
            if(response.getState() == 'SUCCESS'){
                var wrapObjList = response.getReturnValue();
                console.log('wrapObjList: '+JSON.stringify(wrapObjList));
                console.log('wrapObjList.length in DOINIT :: '+wrapObjList.length);
                var bidRecord = wrapObjList[0].bidRecord;
                component.set("v.bidRecord",bidRecord);
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
                if(wrapObjList != null && wrapObjList[0].hasOwnProperty('vipRebate')){
                 	component.set("v.proposedRec", wrapObjList[0].vipRebate.Id);
                    component.set("v.agreementNo", wrapObjList[0].vipRebate.Vistex_Agreement__c);
                    console.log('proposedRec: '+wrapObjList[0].vipRebate.Id);
                }
                var bidType=wrapObjList[0].bidType;
                var approvalState=wrapObjList[0].approvalStatus;
                var loggedInUserId=wrapObjList[0].loggedInUserId;
                var isBusinessApprovePerson=wrapObjList[0].isBusinessApprovePerson;
                var isFinanceApprovePerson=wrapObjList[0].isFinanceApprovePerson;
                var isContractsApprovePerson=wrapObjList[0].isContractsApprovePerson;
                var isCustomerApprovePerson=wrapObjList[0].isCustomerApprovePerson;
                var isVistexApprovePerson=wrapObjList[0].isVistexApprovePerson;
                component.set("v.wrapList",wrapObjList);
                component.set("v.bidType",bidType);
                component.set("v.loggedInUserName",loggedInUserId);
                component.set("v.isBusinessApprovePerson",isBusinessApprovePerson);
                component.set("v.isFinanceApprovePerson",isFinanceApprovePerson);
                component.set("v.isContractsApprovePerson",isContractsApprovePerson);
                component.set("v.isCustomerApprovePerson",isCustomerApprovePerson);
                component.set("v.isVistexApprovePerson",isVistexApprovePerson);
                component.set("v.approvalStatus",approvalState);
                
                var custIdList = [];
                wrapObjList.forEach(function(wrapObj){
                    console.log('adding custIds to MAP ID :: '+wrapObj.customerId+' Customer Name :: '+wrapObj.customerName);
                    custIdList.push({custId:''+wrapObj.customerId,custName:''+wrapObj.customerName});
                });
                
                var fileList=[];
                var totalFiles=[];
                var checked=false;
                totalFiles=wrapObjList[0].conDocLink;
                if(totalFiles!=undefined&&totalFiles!=null){
                    for(var i=0;i<totalFiles.length;i++){
                        fileList.push({"Id":totalFiles[i].ContentDocumentId,"Title":totalFiles[i].ContentDocument.Title+'.'+totalFiles[i].ContentDocument.FileExtension,"checked":checked});
                    }
                }
                component.set("v.fileList",fileList);
                
                console.log('custIdList in doInit ::: '+custIdList);
                component.set("v.customerIdList",custIdList);
                
                component.find("Tabset").set("v.selectedTabId",0); 
                component.set('v.isSpinnerLoad',false);
            } else{
                console.log('Exception: '+JSON.stringify(response.getError()))   ;
            }
        });
        $A.enqueueAction(action); 
    },
    //--------This is the helper method used for recalculation in Proposed Rebate table------->
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
        //let pageReference = component.get("v.pageReference");
        let recordId = component.get("v.c__recordId");//pageReference.state.c__recordId;
        component.set("v.recordId",recordId);
        var action = component.get('c.getDocs');
        action.setParams({'bidId' : component.get("v.recordId")});
        
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