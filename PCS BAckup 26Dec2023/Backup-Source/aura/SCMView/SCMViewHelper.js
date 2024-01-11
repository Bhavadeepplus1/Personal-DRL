({
	getScmData : function(component, event, helper) {
        var action = component.get("c.getScmData");
        component.set("v.SCMApprovalMap",null);
        component.set("v.SCMApprovalQtyMap",null);
        component.set("v.EstimatedDaysMap",null);
        component.set("v.SCMReJMap",null);
        component.set("v.SCMCommentsMap",null);
        component.set("v.initailOrderVolumeMap",null);
        component.set("v.initailOrderCommentsMap",null);
        component.set("v.revisitedDateMap",null);
        component.set("v.isClicked", false);
        component.set("v.isSpinnerLoad", true);
        component.set("v.isSCMApproved", false);
        //component.set("v.isSCMQtyDisadble", true);
        action.setParams({
            bidId : component.get("v.recordId")
        });
        action.setCallback(this, function (response){
            if(response.getState() === "SUCCESS"){
              
                var scmDataList = response.getReturnValue();
                component.set("v.scmData", scmDataList);
                component.set("v.updatedData",scmDataList);
              	
                //JSON.stringify(scmDataList)
               console.log('scmDataList'+JSON.stringify(scmDataList) );
                var totalList = [];
                //for(var i=0;i<scmDataList.length;i++){
                var skuLength=0;var approvedcount=0;var rejectedcount=0;var nullcount=0;var isAllRejSKU=0;
                if(scmDataList.length>0){
                    skuLength =scmDataList[0].skulength; //scmDataList.length;                   
                    approvedcount=scmDataList[0].skuapprovedcount;
                    rejectedcount = scmDataList[0].skurejeccount;
                    nullcount = scmDataList[0].skunullcount;
                    isAllRejSKU = scmDataList[0].isAllRejSKU;                 
                }                   
                //}
                component.set("v.skuLength",skuLength);
                /*for(var i=0;i<totalList.length;i++){
                    if(totalList[i].Phoenix_SCM_Approval_Y_N__c == 'Y- Current + Inc Demand Approved' || totalList[i].Phoenix_SCM_Approval_Y_N__c == 'Y- Only Current Monthly Demand Approved'){
                        approvedcount = approvedcount+1;
                    }
               		if(scmDataList[i].scmApproval == 'N- Not Approved'){
                        rejectedcount = rejectedcount+1;
                    }
                     if(scmDataList[i].scmApproval == ''||scmDataList[i].scmApproval == null){
                        nullcount = nullcount+1;
                    }
                }*/
                console.log("rejectedcount--->"+rejectedcount);
                component.set("v.isAllRejSKU",isAllRejSKU);
                component.set("v.approvedSKUSLen",approvedcount);
                component.set("v.rejectedSKUSLen",rejectedcount);
                component.set("v.noactionTakenCount",nullcount);
                component.set("v.isSpinnerLoad", false);
                if(scmDataList.length>0){
                    
                    component.set("v.bidType",scmDataList[0].bidRecord.Phoenix_Bid_Type__c);
                    let scmApprovalIds = component.find("scmApprovalselect");
                    let rejectionList = component.find('rejectionReason');
                    let auraIds = component.find('comment');
                    var listOfItems = component.get("v.scmData");
                    let leadTimeIds = component.find('estimatedTime');
                    let revisitedDateList = component.find('revisitedDate');
                    var isSCMApprovePerson = false;
                    var finalSCMApproval = false;
                    listOfItems.forEach(function(line){
                        if(line.isSCMApprovePerson && !isSCMApprovePerson){
                            isSCMApprovePerson = true;
                            finalSCMApproval = line.finalSCMApproval;
                        }
                        if((rejectionList != null) && (line.scmApproval == 'Y- Only Current Monthly Demand Approved' ||line.scmApproval == 'Y- Current + Inc Demand Approved') && ($A.util.isArray(rejectionList))){
                            console.log('scmApproval--->'+line.scmApproval)
                            component.find('rejectionReason').forEach(function(rejectionReason){
                                if(rejectionReason.get("v.name") == line.currentRecordId){
                                    rejectionReason.set("v.disabled", true); 
                                }
                            });
                        }else if((rejectionList != null) && (line.scmApproval == 'Y- Only Current Monthly Demand Approved' ||line.scmApproval == 'Y- Current + Inc Demand Approved') && ($A.util.isArray(rejectionList) == false)){
                            component.find('rejectionReason').set("v.disabled", true); 
                        }
                        if(auraIds != null && (line.scmApproval == 'Y- Only Current Monthly Demand Approved' || line.scmApproval == 'N- Not Approved'  || line.scmApproval == 'None') && $A.util.isArray(auraIds)){
                            auraIds.forEach(function(scmQty){
                                    if(scmQty.get("v.name") == line.currentRecordId){
                                       scmQty.set("v.disabled", true); 
                                    }
                                });
                        }
                        else if($A.util.isArray(auraIds) == false && auraIds != null){
                            if(line.scmApproval == 'Y- Only Current Monthly Demand Approved' || line.scmApproval == 'N- Not Approved' || line.scmApproval == 'None'){
                                auraIds.set("v.disabled", true);
                            }
                        }
                        if((leadTimeIds != null) && (line.scmApproval == 'N- Not Approved') && ($A.util.isArray(rejectionList))){
                            leadTimeIds.forEach(function(scmQty){
                                    if(scmQty.get("v.name") == line.currentRecordId){
                                       scmQty.set("v.disabled", true); 
                                       
                                    }
                                });
                        }else if((leadTimeIds != null) && (line.scmApproval == 'N- Not Approved') && !($A.util.isArray(rejectionList))){
                            leadTimeIds.set("v.disabled", true);
                        }
                        if((revisitedDateList != null) && (line.scmApproval != 'N- Not Approved') && ($A.util.isArray(revisitedDateList))){
                            revisitedDateList.forEach(function(scmQty){
                                    if(scmQty.get("v.labelClass") == line.currentRecordId){
                                       scmQty.set("v.disabled", true); 
                                       
                                    }
                                });
                        }else if((revisitedDateList != null) && (line.scmApproval != 'N- Not Approved') && !($A.util.isArray(rejectionList))){
                            revisitedDateList.set("v.disabled", true);
                        }
                    
                    });
                    
                    component.set("v.isSCMApprovePerson",isSCMApprovePerson);
                    component.set("v.finalSCMApproval",finalSCMApproval);
                    
                    
                    //console.log("scmDataList--->"+JSON.stringify(scmApprovalIds));
               /*     if(scmApprovalIds != null && scmApprovalIds != 'undefined'){
                        scmApprovalIds.forEach(function(eachInput){
                            console.log('eachInputValue-->'+eachInput.get("v.value"))
                            console.log('eachInputname-->'+eachInput.get("v.name"))
                            console.log('scmAPprovalvalues-->'+JSON.stringify(eachInput))
                            if(auraIds != null && auraIds != 'undefined'){// &&  eachInput.get("v.value") == 'Y- Only Current Monthly Demand Approved'
                                auraIds.forEach(function(scmQty){
                                    console.log('scmQTYvalues-->'+scmQty.get("v.value"))
                                    console.log('scmQtyname-->'+scmQty.get("v.name"))
                                    if(scmQty.get("v.name") == eachInput.get("v.name")){
                                        
                                       scmQty.set("v.disabled", true); 
                                    }
                                });
                            }
                        });
                        
                    } */
                }              
                
            }
        });
        $A.enqueueAction(action);
		
		
	},
     convertArrayOfObjectsToCSV : function(component,objectRecords,template){
         var bidType = component.get("v.bidType");
        // declare variables
        var csvStringResult, counter, keys,columnDivider, lineDivider;
        console.log('testing result--->'+JSON.stringify(objectRecords));
        // check if "objectRecords" parameter is null, then return from function
        if (objectRecords == null || !objectRecords.length) {
            return null;
        }
         // store ,[comma] in columnDivider variabel for sparate CSV values and 
        // for start next line use '\n' [new line] in lineDivider varaible  
        columnDivider = ',';
        lineDivider =  '\n';
        csvStringResult = '';
        var selling_unit='1';
        var myMap = new Map();
        myMap.set("SAP Number", "sapNumber");
        myMap.set("Product", "productName");
         myMap.set("Molecule", "productFamilyName");
         myMap.set("Pkg Size", "casePack");
         myMap.set("Monthly Demand", "monthlyDemand");
         if(bidType == 'Good Dated OTB' || bidType == 'Short Dated OTB'){
             myMap.set("Annual Total Demand", "finalsellingUnits");
         }
         myMap.set("Monthly Additonal Requirement", "additionalReq");
         myMap.set("Monthly Total Revised Requirement", "totalRevisedReq");
         myMap.set("Dollar Value", "dollarValue");
          myMap.set("SCM Approval (Y/N)", "scmApproval");
         myMap.set("SCM Approved - % of Incremental", "scmAprQtyPercent");
         myMap.set("Current/SCM Approved Qty", "scmAprQty");
         myMap.set("Estimated Lead Time", "estimatedTime");
         myMap.set("SCM Rejection Reason", "scmrejectionReason");
         myMap.set("Revisit Date", "revisitedDate");
         myMap.set("SCM Comments", "scmcomments");
         if(bidType != 'Good Dated OTB' && bidType != 'Short Dated OTB'){
         myMap.set("Initial Stocking Order Volume", "initialStockingOrderVolume");
         myMap.set("Initial Stocking Order Comments", "initialStockingOrderComments");
         }
         csvStringResult += Array.from(myMap.keys()).join(columnDivider);
        csvStringResult += lineDivider;
        //new logic start 
        for(var i=0; i < objectRecords.length; i++){  
            counter = 0;
            for (let [key, value] of myMap) {
                if(counter > 0){ 
                    csvStringResult += columnDivider; 
                }
               // console.log(JSON.stringify(objectRecords[i]["estimatedTime"]));
                /*if(value=='Phoenix_Product__r.Name'){
                    csvStringResult += '"'+ objectRecords[i]["Phoenix_Product__r"]["Name"]+'"';
                }*/
                 if(value == "revisitedDate"){
                     if(objectRecords[i]["revisitedDate"] != null){
                    var revisitDate=objectRecords[i]["revisitedDate"];
                     console.log("revisitDate--->"+revisitDate);
                    var dt = new Date(revisitDate);
                    var month = dt.getMonth() + 1;
                    var day = dt.getDate();
                    var year = dt.getFullYear();
                    var formatteddate = month + "/" + day + "/" + year;
                    csvStringResult += '"'+formatteddate+'"';
                    console.log('formatteddate--->'+formatteddate);
                     }
                     else{
                        csvStringResult += '"'+''+'"'; 
                     }
                } else if(value=='productFamilyName'){
                    if(objectRecords[i]['productFamilyName'] != null){
                        csvStringResult += '"'+ objectRecords[i]["productFamilyName"]+'"';
                    } else{
                        csvStringResult += '"'+ objectRecords[i]["productFamily"]+'"';
                    }
                }
                else if(value == 'dollarValue'){
                    var dollarvalue=objectRecords[i]['dollarValue'];
                        //console.log('dollarvalue-->'+dollarvalue);
                   if(dollarvalue != null){
                        var rounded_dollarvalue=Math.round(dollarvalue * 100)/100
                        csvStringResult += '"'+ rounded_dollarvalue +'"';
                   }
                   else{
                       csvStringResult += '"'+''+'"';
                   }
                }
                else if(objectRecords[i][value]==undefined){
                        csvStringResult += '"'+''+'"';
                    }
                else{
                        csvStringResult += '"'+ objectRecords[i][value]+'"';
                    }
                               
                counter++;
            }
            csvStringResult += lineDivider;
        }
        //new logic end 
         
        return csvStringResult;     
    },
    updateLineItems : function(component, event, helper){
        console.log('updating the line items..');
        var action = component.get("c.updatedLineItems");
        action.setParams({
            bidId : component.get("v.recordId")
        });
        action.setCallback(this, function (response){
            if(response.getState() === "SUCCESS"){
                console.log('Updated the lineItems::');
            }
        });
        $A.enqueueAction(action);
    }
})