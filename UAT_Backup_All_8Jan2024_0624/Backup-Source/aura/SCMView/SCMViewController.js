({
    doInit : function(component, event, helper) {
        helper.getScmData(component, event, helper);
    },
    handleChange : function(component, event, helper){
        var selectedPlannerId = component.get("v.supplyChainPlannerId");
        if(selectedPlannerId != null){
            var scmData = component.get("v.scmData");
            var updatedData = [];
            scmData.forEach(function(obj){
                if(obj.scmApproverId == selectedPlannerId)
                    updatedData.push(obj);
            });
            component.set("v.updatedData",updatedData);
        }
        else
            component.set("v.updatedData",component.get("v.scmData"));
    },
    onClose: function (component, event, helper){
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": component.get("v.recordId"),
            
        });
        navEvt.fire();
    },
    onScmApprovalChange: function (component, event, helper){
        component.set("v.isClicked", true);
        var recordId = event.getSource().get('v.name');
        var val = event.getSource().get('v.value');
        var title = event.getSource().get('v.title');
        console.log('currentRecordID---->'+recordId);
        let auraIds = component.find('comment');
        let leadTimeIds = component.find('estimatedTime');
        let rejectionReaonList = component.find('rejectionReason');
        let revisitedDateList = component.find('revisitedDate');
        
        console.log('boolean---->'+$A.util.isArray(auraIds))
        if($A.util.isArray(auraIds)){
            if(auraIds != null && auraIds.length > 0){
                component.find("comment").forEach(function(eachInput){
                    if(eachInput.get("v.name") == recordId){
                        if(val == 'Y- Only Current Monthly Demand Approved'){
                            eachInput.set("v.value", '0');
                            if(revisitedDateList != null){
                                revisitedDateList.forEach(function(scmQty){
                                    if(scmQty.get("v.labelClass") == recordId){
                                        scmQty.set("v.disabled", true); 
                                        scmQty.set("v.value", null); 
                                    }
                                });
                            }
                            
                            if(auraIds != null){
                                auraIds.forEach(function(scmQty){
                                    if(scmQty.get("v.name") == recordId){
                                        scmQty.set("v.disabled", true); 
                                    }
                                });
                            }
                            if(rejectionReaonList != null){
                                rejectionReaonList.forEach(function(eachInput){
                                    if(eachInput.get("v.name") == recordId){
                                        eachInput.set("v.disabled", true); 
                                    }
                                });
                            }
                            if(leadTimeIds != null){
                                leadTimeIds.forEach(function(scmQty){
                                    if(scmQty.get("v.name") == recordId){
                                        scmQty.set("v.disabled", false); 
                                        
                                    }
                                });
                            }
                            
                        }
                        else if(val == 'Y- Current + Inc Demand Approved'){
                            eachInput.set("v.value", '100');
                            let auraIds = component.find('comment');
                            let rejectionReaonList = component.find('rejectionReason');
                            let revisitedDateList = component.find('revisitedDate');
                            if(revisitedDateList != null){
                                revisitedDateList.forEach(function(scmQty){
                                    if(scmQty.get("v.labelClass") == recordId){
                                        scmQty.set("v.disabled", true); 
                                        scmQty.set("v.value", null); 
                                    }
                                });
                            }
                            
                            if(auraIds != null){
                                auraIds.forEach(function(scmQty){
                                    if(scmQty.get("v.name") == recordId){
                                        scmQty.set("v.disabled", false); 
                                    }
                                });
                            }
                            if(rejectionReaonList != null){
                                rejectionReaonList.forEach(function(eachInput){
                                    if(eachInput.get("v.name") == recordId){
                                        eachInput.set("v.disabled", true); 
                                    }
                                });
                            }
                            if(leadTimeIds != null){
                                leadTimeIds.forEach(function(scmQty){
                                    if(scmQty.get("v.name") == recordId){
                                        scmQty.set("v.disabled", false); 
                                        
                                    }
                                });
                            }
                            
                            
                        }
                            else{
                                eachInput.set("v.value",null);
                                let auraIds = component.find('comment');
                                let rejectionReaonList = component.find('rejectionReason');
                                let revisitedDateList = component.find('revisitedDate');
                                if(revisitedDateList != null){
                                    revisitedDateList.forEach(function(scmQty){
                                        if(scmQty.get("v.labelClass") == recordId){
                                            scmQty.set("v.disabled", false); 
                                        }
                                    });
                                }
                                
                                if(auraIds != null){
                                    auraIds.forEach(function(scmQty){
                                        if(scmQty.get("v.name") == recordId){
                                            scmQty.set("v.disabled", true); 
                                        }
                                    });
                                }
                                if(leadTimeIds != null){
                                    leadTimeIds.forEach(function(scmQty){
                                        if(scmQty.get("v.name") == recordId){
                                            scmQty.set("v.disabled", true); 
                                            scmQty.set("v.value", '0'); 
                                        }
                                    });
                                }
                                
                                if(rejectionReaonList != null){
                                    rejectionReaonList.forEach(function(eachInput){
                                        if(eachInput.get("v.name") == recordId){
                                            eachInput.set("v.disabled", false); 
                                        }
                                    });
                                }
                            }
                        
                    }
                });
                var fieldList = new Map();
                var bidLinesMap = component.get("v.SCMApprovalQtyMap") != null ? component.get("v.SCMApprovalQtyMap") : new Map();
                fieldList['SCM Approved % Quantity'] = val == 'Y- Only Current Monthly Demand Approved' ? '0' : val == 'Y- Current + Inc Demand Approved' ? '100' : 'notValid';
                if(!bidLinesMap.has(recordId)){
                    bidLinesMap[recordId] = fieldList;
                }else{
                    if(fieldList.has('SCM Approved % Quantity')){
                        fieldList.delete('SCM Approved % Quantity');
                        bidLinesMap[recordId] = fieldList;
                    }else{
                        bidLinesMap[recordId] = fieldList;
                    }
                }
                component.set("v.SCMApprovalQtyMap", bidLinesMap);
                console.log('SCMApprovalQtyMap---->'+JSON.stringify(bidLinesMap));
                
            } 
        }
        else{
            if(val == 'None'){
                auraIds.set("v.value", '0');
                auraIds.set("v.disabled", true);
                revisitedDateList.set("v.disabled", true); 
                revisitedDateList.set("v.value", null);
                rejectionReaonList.set("v.disabled", true); 
                leadTimeIds.set("v.disabled", true);
            }
            else if(val == 'Y- Only Current Monthly Demand Approved'){
                auraIds.set("v.value", '0');
                auraIds.set("v.disabled", true);
                revisitedDateList.set("v.disabled", true); 
                revisitedDateList.set("v.value", null);
                rejectionReaonList.set("v.disabled", true); 
                leadTimeIds.set("v.disabled", false);
            }
            else if(val == 'Y- Current + Inc Demand Approved'){
                auraIds.set("v.value", '100');
                auraIds.set("v.disabled", false);
                revisitedDateList.set("v.disabled", true); 
                revisitedDateList.set("v.value", null);
                rejectionReaonList.set("v.disabled", true);
                leadTimeIds.set("v.disabled", false);
                
            }else{
                auraIds.set("v.value",null);
                auraIds.set("v.disabled", true);
                revisitedDateList.set("v.disabled", false); 
                rejectionReaonList.set("v.disabled", false);
                leadTimeIds.set("v.disabled", true);
                
            }
            var fieldList = new Map();
            var bidLinesMap = component.get("v.SCMApprovalQtyMap") != null ? component.get("v.SCMApprovalQtyMap") : new Map();
            fieldList['SCM Approved % Quantity'] = val == 'Y- Only Current Monthly Demand Approved' ? '0' : val == 'Y- Current + Inc Demand Approved' ? '100' : 'notValid';
            if(!bidLinesMap.has(recordId)){
                bidLinesMap[recordId] = fieldList;
            }else{
                if(fieldList.has('SCM Approved % Quantity')){
                    fieldList.delete('SCM Approved % Quantity');
                    bidLinesMap[recordId] = fieldList;
                }else{
                    bidLinesMap[recordId] = fieldList;
                }
            }
            component.set("v.SCMApprovalQtyMap", bidLinesMap);
            
        }
        
        
        var fieldList = new Map();
        var bidLinesMap = component.get("v.SCMApprovalMap") != null ? component.get("v.SCMApprovalMap") : new Map();
        fieldList[title] = val;
        if(!bidLinesMap.has(recordId)){
            bidLinesMap[recordId] = fieldList;
        }else{
            if(fieldList.has(title)){
                fieldList.delete(title);
                bidLinesMap[recordId] = fieldList;
            }else{
                bidLinesMap[recordId] = fieldList;
            }
        }
        component.set("v.SCMApprovalMap", bidLinesMap);
        console.log('SCMApprovalMap---->'+JSON.stringify(bidLinesMap));
        
        
    },
    onestimatedTime: function (component, event, helper){
        component.set("v.isClicked", true);
        var recordId = event.getSource().get('v.name');
        var val = event.getSource().get('v.value');
        var title = event.getSource().get('v.title');
        console.log('currentRecordID---->'+recordId);
        var fieldList = new Map();
        var bidLinesMap = component.get("v.EstimatedDaysMap") != null ? component.get("v.EstimatedDaysMap") : new Map();
        fieldList[title] = val;
        if(!bidLinesMap.has(recordId)){
            bidLinesMap[recordId] = fieldList;
        }else{
            if(fieldList.has(title)){
                fieldList.delete(title);
                bidLinesMap[recordId] = fieldList;
            }else{
                bidLinesMap[recordId] = fieldList;
            }
        }
        component.set("v.EstimatedDaysMap", bidLinesMap);
        console.log('EstimatedDaysMap---->'+JSON.stringify(bidLinesMap));
        
        
    },
    onscmrejectionReasonChange : function (component, event, helper){
        component.set("v.isClicked", true);
        var recordId = event.getSource().get('v.name');
        var val = event.getSource().get('v.value');
        var title = event.getSource().get('v.title');
        console.log('currentRecordID---->'+recordId);
        var fieldList = new Map();
        var bidLinesMap = component.get("v.SCMReJMap") != null ? component.get("v.SCMReJMap") : new Map();
        fieldList[title] = val;
        if(!bidLinesMap.has(recordId)){
            bidLinesMap[recordId] = fieldList;
        }else{
            if(fieldList.has(title)){
                fieldList.delete(title);
                bidLinesMap[recordId] = fieldList;
            }else{
                bidLinesMap[recordId] = fieldList;
            }
        }
        component.set("v.SCMReJMap", bidLinesMap);
        console.log('SCMReJMap---->'+JSON.stringify(bidLinesMap));
        
        
    },
    onScmCommentChange : function (component, event, helper){
        component.set("v.isClicked", true);
        var recordId = event.getSource().get('v.name');
        var val = event.getSource().get('v.value');
        var title = event.getSource().get('v.title');
        console.log('currentRecordID---->'+recordId);
        var fieldList = new Map();
        var bidLinesMap = component.get("v.SCMCommentsMap") != null ? component.get("v.SCMCommentsMap") : new Map();
        fieldList[title] = val;
        if(!bidLinesMap.has(recordId)){
            bidLinesMap[recordId] = fieldList;
        }else{
            if(fieldList.has(title)){
                fieldList.delete(title);
                bidLinesMap[recordId] = fieldList;
            }else{
                bidLinesMap[recordId] = fieldList;
            }
        }
        component.set("v.SCMCommentsMap", bidLinesMap);
        console.log('SCMCommentsMap---->'+JSON.stringify(bidLinesMap));
        
        
    },
    onscmAprQtyPercent : function (component, event, helper){
        component.set("v.isClicked", true);
        var recordId = event.getSource().get('v.name');
        var val = event.getSource().get('v.value');
        var title = event.getSource().get('v.title');
        console.log('currentRecordID---->'+recordId);
        var fieldList = new Map();
        var bidLinesMap = component.get("v.SCMApprovalQtyMap") != null ? component.get("v.SCMApprovalQtyMap") : new Map();
        fieldList[title] = val;
        if(!bidLinesMap.has(recordId)){
            bidLinesMap[recordId] = fieldList;
        }else{
            if(fieldList.has(title)){
                fieldList.delete(title);
                bidLinesMap[recordId] = fieldList;
            }else{
                bidLinesMap[recordId] = fieldList;
            }
        }
        component.set("v.SCMApprovalQtyMap", bidLinesMap);
        //console.log('SCMApprovalQtyMap---->'+JSON.stringify(bidLinesMap));
        /* var scmData = component.get("v.scmData");
        var scmQtys = component.find("scmApprovedQty");
        var scmqty;     
        if(scmData != null && scmData.length > 0){
            scmData.forEach(function(eachLine){
                scmQtys.forEach(function(eachRow){
                    if(eachLine.currentRecordId == recordId){
                        var scmQty = eachLine.monthlyDemand + (eachLine.additionalReq * val/100) ;
                        eachRow.set("v.value",scmQty);
                        console.log("currentRecordId--->"+eachLine.currentRecordId);
                        console.log("recordId--->"+recordId);
                        console.log("scmQty--->"+eachRow.get("v.value"))
                    }
                });
                
            });
        }
        
        */
    },
    onInitialVolumeChange : function (component, event, helper){
        component.set("v.isClicked", true);
        var recordId = event.getSource().get('v.name');
        var val = event.getSource().get('v.value');
        var title = event.getSource().get('v.title');
        console.log('currentRecordID---->'+recordId);
        var fieldList = new Map();
        var bidLinesMap = component.get("v.initailOrderVolumeMap") != null ? component.get("v.initailOrderVolumeMap") : new Map();
        fieldList[title] = val;
        if(!bidLinesMap.has(recordId)){
            bidLinesMap[recordId] = fieldList;
        }else{
            if(fieldList.has(title)){
                fieldList.delete(title);
                bidLinesMap[recordId] = fieldList;
            }else{
                bidLinesMap[recordId] = fieldList;
            }
        }
        component.set("v.initailOrderVolumeMap", bidLinesMap);
        console.log('SCMApprovalQtyMap---->'+JSON.stringify(bidLinesMap));
        
        
    },
    onInitialCommentChange : function (component, event, helper){
        component.set("v.isClicked", true);
        var recordId = event.getSource().get('v.name');
        var val = event.getSource().get('v.value');
        var title = event.getSource().get('v.title');
        console.log('currentRecordID---->'+recordId);
        var fieldList = new Map();
        var bidLinesMap = component.get("v.initailOrderCommentsMap") != null ? component.get("v.initailOrderCommentsMap") : new Map();
        fieldList[title] = val;
        if(!bidLinesMap.has(recordId)){
            bidLinesMap[recordId] = fieldList;
        }else{
            if(fieldList.has(title)){
                fieldList.delete(title);
                bidLinesMap[recordId] = fieldList;
            }else{
                bidLinesMap[recordId] = fieldList;
            }
        }
        component.set("v.initailOrderCommentsMap", bidLinesMap);
        console.log('SCMApprovalQtyMap---->'+JSON.stringify(bidLinesMap));
        
        
    },
    
    saveClick: function (component, event, helper){
        component.set("v.isSpinnerLoad", true);
        var scamData = component.get("v.scmData");
        console.log('scamData'+JSON.stringify(scamData) );
        var isEstimatedDay = false;
        var percenteInput = false;
        var isRejectionReasinNeeded = false;
        let approvalIds = component.find("scmApprovalselect");
        let estimatedIds = component.find("estimatedTime");
        let quantityPercentaages = component.find("comment");        
        let rejectionReasonIds = component.find("rejectionReason");
        if(scamData.length > 1){
            if(Array.isArray(approvalIds) && Array.isArray(estimatedIds) && approvalIds != null && approvalIds.length > 0 && estimatedIds != null && estimatedIds.length > 0){
                approvalIds.forEach(function(eachApproval){
                    estimatedIds.forEach(function(eachEstimatedDays){
                        if(eachApproval.get("v.name") == eachEstimatedDays.get("v.name") && (eachApproval.get("v.value") == 'Y- Only Current Monthly Demand Approved' || eachApproval.get("v.value") == 'Y- Current + Inc Demand Approved') && (eachEstimatedDays.get("v.value") == null || eachEstimatedDays.get("v.value") == '') ){
                            isEstimatedDay = true;
                        }
                    });
                    
                });
            }
            else{
                if(approvalIds.get("v.name") == estimatedIds.get("v.name") && (approvalIds.get('v.value') == 'Y- Only Current Monthly Demand Approved' || approvalIds.get('v.value') == 'Y- Current + Inc Demand Approved') && (estimatedIds.get("v.value") == null || estimatedIds.get("v.value")=='')){
                    
                    isEstimatedDay = true;
                }
            }
            if(quantityPercentaages !=null && approvalIds != null && Array.isArray(quantityPercentaages)){
                approvalIds.forEach(function(eachApproval){
                    quantityPercentaages.forEach(function(eachInput){
                        if( eachApproval.get("v.name") == eachInput.get("v.name") && eachApproval.get("v.value") == 'Y- Current + Inc Demand Approved' && (eachInput.get("v.value") == null || eachInput.get("v.value") == '' || eachInput.get("v.value") == 0) ){
                            percenteInput = true;
                        }
                    });
                });
           
            }
            else{
             if(approvalIds.get("v.name") == quantityPercentaages.get("v.name") && approvalIds.get("v.value") == 'Y- Current + Inc Demand Approved' && (quantityPercentaages.get("v.value") == null || quantityPercentaages.get("v.value") == '' || quantityPercentaages.get("v.value") == 0) ){
                    percenteInput = true;
                }
                
            }
            
            if(rejectionReasonIds !=null && approvalIds != null && Array.isArray(rejectionReasonIds)){
                approvalIds.forEach(function(eachApproval){
                    rejectionReasonIds.forEach(function(eachInput){
                        console.log('approval status-->'+eachApproval.get("v.value"))
                        console.log('rejection reason--->'+eachInput.get("v.value"))
                        if( eachApproval.get("v.name") == eachInput.get("v.name") && eachApproval.get("v.value") == 'N- Not Approved' && (eachInput.get("v.value") == null || eachInput.get("v.value") == 'None' ) ){
                            isRejectionReasinNeeded = true;
                        }
                    });
                });
           
            }
            else{
             if(approvalIds.get("v.name") == quantityPercentaages.get("v.name") && approvalIds.get("v.value") == 'N- Not Approved' && (quantityPercentaages.get("v.value") == null || quantityPercentaages.get("v.value") == 'None')){
                    isRejectionReasinNeeded = true;
                }
                
            }
        }
        
        if(scamData.length == 1){           
            if(Array.isArray(approvalIds)){
                approvalIds=approvalIds[0];
            }
            if(Array.isArray(estimatedIds)){
                estimatedIds=estimatedIds[0];
            }
            if(Array.isArray(quantityPercentaages)){
                quantityPercentaages=quantityPercentaages[0];
            }
            if(Array.isArray(rejectionReasonIds)){
                rejectionReasonIds=rejectionReasonIds[0];
            }
            if((approvalIds.get('v.value') == 'Y- Only Current Monthly Demand Approved' || approvalIds.get('v.value') == 'Y- Current + Inc Demand Approved') && (estimatedIds.get("v.value") == null || estimatedIds.get("v.value")=='')){
                console.log("estimatted lead time-->"+(estimatedIds.get("v.value")));
                isEstimatedDay = true;
            }
            if(approvalIds.get("v.name") == quantityPercentaages.get("v.name") && approvalIds.get("v.value") == 'Y- Current + Inc Demand Approved' && (quantityPercentaages.get("v.value") == null || quantityPercentaages.get("v.value") == '' || quantityPercentaages.get("v.value") == 0) ){
                percenteInput = true;
            }
            if(approvalIds.get("v.name") == quantityPercentaages.get("v.name") && approvalIds.get("v.value") == 'N- Not Approved' && (rejectionReasonIds.get("v.value") == null || rejectionReasonIds.get("v.value") == 'None' ) ){
                isRejectionReasinNeeded = true;
            }
        }
        if(isEstimatedDay){
            component.set("v.isSpinnerLoad", false);
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type":"warning",
                "title": "Failed!",
                "message": 'Please add Estimated Lead Time to save the line item.'
            });
            toastEvent.fire();
            component.set("v.isClicked", true);
            
        }
        else if(percenteInput){
            component.set("v.isSpinnerLoad", false);
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type":"warning",
                "title": "Failed!",
                "message": 'Please Enter SCM Approved - % of Incremental greater than 0'
            });
            toastEvent.fire();
            component.set("v.isClicked", true);
            
        }else if(isRejectionReasinNeeded){
             component.set("v.isSpinnerLoad", false);
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type":"warning",
                "title": "Failed!",
                "message": 'Please add the Rejection Reason for rejected line items'
            });
            toastEvent.fire();
            component.set("v.isClicked", true);
        }
            else{
                var action = component.get("c.updateLineItems");
                var scmApproval;
                var scmApprovaltype = component.find("headerSCMApproval");
                if(scmApprovaltype != null ){
                    scmApproval = scmApprovaltype.get("v.value");
                }else{
                    scmApproval = '';
                }
                
                action.setParams({
                    bidId : component.get("v.recordId"),
                    scmApprovalMap : component.get("v.SCMApprovalMap"),
                    scmApprovalQtyMap : component.get("v.SCMApprovalQtyMap"),
                    estimatedDaysMap : component.get("v.EstimatedDaysMap"),
                    scmRejReason : component.get("v.SCMReJMap"),
                    scmCommentsMap: component.get("v.SCMCommentsMap"),
                    initialVolumeMap: component.get("v.initailOrderVolumeMap"),
                    initialCommentsMap: component.get("v.initailOrderCommentsMap"),
                    revisitedDateMap: component.get("v.revisitedDateMap"),
                    //nextReviewDateMap: component.get("v.nextReviewDateMap"),
                    scmApproval : scmApproval,
                    isSCMApproved : component.get("v.isSCMApproved")
                    
                    
                    
                });
                action.setCallback(this, function(response){
                    if(response.getState() === 'SUCCESS'){
                        var dataList = response.getReturnValue();
                        component.set("v.scmData", dataList);
                        var toastEvent = $A.get("e.force:showToast");
                        component.set("v.isSpinnerLoad" , false);
                        component.set("v.isClicked", false);
                        component.set("v.SCMApprovalMap", null),
                            component.set("v.SCMApprovalQtyMap", null),
                            component.set("v.EstimatedDaysMap", null),
                            component.set("v.SCMReJMap", null),
                            component.set("v.SCMCommentsMap", null)
                        helper.getScmData(component, event, helper);
                        toastEvent.setParams({
                            "type": "success",
                            "title": "Success!",
                            "message": "Record Updated Successfully."
                        });
                        toastEvent.fire();
                    }
                    
                    
                });
                $A.enqueueAction(action);
            }
        
        
    },
    onApprovalSubmit: function(component,event,helper){
        component.set("v.isSpinnerLoad",true);
        component.set("v.isSubmit",true);
        var listOfItems = component.get("v.scmData");
        var isApproved = false;
        var isEstimatedLeadTime = false;
        listOfItems.forEach(function(line){
            if((line.scmApproval == 'None' || line.scmApproval == '' || line.scmApproval == null) && line.isSCMApprovePerson)
                isApproved = true;
            
            if(line.estimatedTime == ''  || line.estimatedTime == null)
                isEstimatedLeadTime = true;
        });
        
        if(isApproved == true){
            //var msg = isApproved ?  : 'Please confirm Estimated Lead Time to proceed further'
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type":"warning",
                "title": "Failed!",
                "message": 'Please confirm each approval to proceed further'
            });
            toastEvent.fire();
            component.set("v.isSpinnerLoad",false);
        }else{
            if(!component.get("v.winnabilityIgnored")){
                var bidTemplate = component.get("v.bidTemplate");
                var bidRecord = component.get("v.bidRecord");
                var approvalStatus = bidRecord.Phoenix_Approval_Status__c;
                if(bidTemplate == 'Walgreens' && bidRecord.Phoenix_Bid_Type__c == 'RFP Bids' && ((approvalStatus.includes('SCM') && approvalStatus.includes('Marketing')) || bidRecord.Phoenix_Approval_Status__c == 'Marketing')){
                    component.set('v.winnabilityPopup',true);
                    component.set("v.isSpinnerLoad",false);
                    var lowWinnabilityScoreList = []; var totalCOLO = 0;
                    var BidLineItemListAll = component.get("v.updatedData");
                    if(BidLineItemListAll != null){
                        for(var i=0; i<BidLineItemListAll.length; i++){
                            if(BidLineItemListAll[i].bidLineObj.Phoenix_Product__r.Winnability__c != null && BidLineItemListAll[i].bidLineObj.Phoenix_Product__r.Winnability__c < 80){
                                lowWinnabilityScoreList.push(BidLineItemListAll[i]);
                                totalCOLO += (BidLineItemListAll[i].bidLineObj.Phoenix_Net_Sales_Internal__c != null ? BidLineItemListAll[i].bidLineObj.Phoenix_Net_Sales_Internal__c : 0);
                            }
                        }
                    }
                    component.set("v.lowWinnabilityScoreList", lowWinnabilityScoreList);
                    component.set("v.totalCOLO", totalCOLO);
                } else{
                    console.log("--- INSIDE PROCCESS APPROVALS--1->");
                    var action = component.get("c.makeApprovals");
                    action.setParams({
                        bidId : component.get("v.recordId")
                    });
                    action.setCallback(this, function (response){
                        console.log("response.getState() from makeApprovals --> "+response.getState());
                        if(response.getState() === "SUCCESS"){
                            helper.getScmData(component, event, helper);
                            if(component.get("v.scmData[0].bidRecord.Phoenix_Customer_Type__c") == 'ROS')
                                 component.set("v.isSpinnerLoad",false);
                            helper.updateLineItems(component,event,helper);
                        }
                        else{
                            console.log("ERROR from makeApprovals --> "+JSON.stringify(response.getError()));
                            component.set("v.isSpinnerLoad",false);
                        }
                    });
                    $A.enqueueAction(action);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type":"success",
                        "title": "Success",
                        "message": "Your Approvals are submitted successfully."
                    });
                    toastEvent.fire();
                }  
            } else{
                    console.log("--- INSIDE PROCCESS APPROVALS-2-->");
                    var action = component.get("c.makeApprovals");
                    action.setParams({
                        bidId : component.get("v.recordId")
                    });
                    action.setCallback(this, function (response){
                        console.log("response.getState() from makeApprovals --> "+response.getState());
                        if(response.getState() === "SUCCESS"){
                            helper.getScmData(component, event, helper);
                            if(component.get("v.scmData[0].bidRecord.Phoenix_Customer_Type__c") == 'ROS')
                                 component.set("v.isSpinnerLoad",false);
                            helper.updateLineItems(component,event,helper);
                        }
                        else{
                            console.log("ERROR from makeApprovals --> "+JSON.stringify(response.getError()));
                            component.set("v.isSpinnerLoad",false);
                        }
                    });
                    $A.enqueueAction(action);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type":"success",
                        "title": "Success",
                        "message": "Your Approvals are submitted successfully."
                    });
                    toastEvent.fire();
            }
        }
        
    },
    ignoreAndSubmit: function(component, event, helper){
		component.set("v.winnabilityPopup", false);
        component.set("v.winnabilityIgnored", true);
        console.log("--- INSIDE PROCCESS APPROVALS--->");
        var action = component.get("c.makeApprovals");
        action.setParams({
            bidId : component.get("v.recordId")
        });
        action.setCallback(this, function (response){
            console.log("response.getState() from makeApprovals --> "+response.getState());
            if(response.getState() === "SUCCESS"){
                helper.getScmData(component, event, helper);
                if(component.get("v.scmData[0].bidRecord.Phoenix_Customer_Type__c") == 'ROS')
                    component.set("v.isSpinnerLoad",false);
                helper.updateLineItems(component,event,helper);
            }
            else{
                console.log("ERROR from makeApprovals --> "+JSON.stringify(response.getError()));
                component.set("v.isSpinnerLoad",false);
            }
        });
        $A.enqueueAction(action);
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type":"success",
            "title": "Success",
            "message": "Your Approvals are submitted successfully."
        });
        toastEvent.fire();
    },
    reconsideAndModify: function(component, event, helper){
		component.set("v.winnabilityPopup", false);
    },
    closeWinnabilityPopup: function(component, event, helper){
        component.set("v.winnabilityPopup", false);
    },
    revistedDateChange : function (component, event, helper){
        component.set("v.isClicked", true);
        var recordId = event.getSource().get('v.labelClass');
        var val = event.getSource().get('v.value');
        var title = 'revisitedDate';
        var fieldList = new Map();
        var bidLinesMap = component.get("v.revisitedDateMap") != null ? component.get("v.revisitedDateMap") : new Map();
        fieldList[title] = val;
        if(!bidLinesMap.has(recordId)){
            bidLinesMap[recordId] = fieldList;
        }else{
            if(fieldList.has(title)){
                fieldList.delete(title);
                bidLinesMap[recordId] = fieldList;
            }else{
                bidLinesMap[recordId] = fieldList;
            }
        }
        component.set("v.revisitedDateMap", bidLinesMap);
        console.log('revisitedDateMap---->'+JSON.stringify(bidLinesMap));
        
    },
    nextReviewDateChange :function (component, event, helper){
        component.set("v.isClicked", true);
        var recordId = event.getSource().get('v.labelClass');
        var val = event.getSource().get('v.value');
        var title = 'nextReviewDate';
        var fieldList = new Map();
        var bidLinesMap = component.get("v.nextReviewDateMap") != null ? component.get("v.nextReviewDateMap") : new Map();
        fieldList[title] = val;
        if(!bidLinesMap.has(recordId)){
            bidLinesMap[recordId] = fieldList;
        }else{
            if(fieldList.has(title)){
                fieldList.delete(title);
                bidLinesMap[recordId] = fieldList;
            }else{
                bidLinesMap[recordId] = fieldList;
            }
        }
        component.set("v.nextReviewDateMap", bidLinesMap);
        console.log('revisitedDateMap---->'+JSON.stringify(bidLinesMap));
        
    },
    refreshSCM : function (component, event, helper){
        /* component.set("v.SCMApprovalMap",null);
        component.set("v.SCMApprovalQtyMap",null);
        component.set("v.EstimatedDaysMap",null);
        component.set("v.SCMReJMap",null);
        component.set("v.SCMCommentsMap",null);
        component.set("v.initailOrderVolumeMap",null);
        component.set("v.initailOrderVolumeMap",null);*/
        helper.getScmData(component, event, helper);
    },
    onApprovalChange : function(component,event,helper){
        component.set("v.isClicked", true);
        component.set("v.isSCMApproved", true);
        var val = event.getSource().get('v.value');
        let rejectionList = component.find('rejectionReason');
        let estimatedList = component.find('estimatedTime');
        let revisitedDateList = component.find('revisitedDate');
        console.log('rejectionList-->'+(rejectionList.length == 1));
        console.log('rejectionList-->'+(rejectionList.length != undefined));
        
        if((val == 'Y- Only Current Monthly Demand Approved' || val == 'Y- Current + Inc Demand Approved') && revisitedDateList != null && revisitedDateList.length != undefined && revisitedDateList.length > 0){
            revisitedDateList.forEach(function(eachInput){
                eachInput.set("v.disabled", true);
            });
        }else if (revisitedDateList.length == undefined || revisitedDateList.length == 1){
            if(revisitedDateList.length == 1)
                revisitedDateList[0].set("v.disabled", true);
            else
                revisitedDateList.set("v.disabled", true);
        }
        if((val == 'N- Not Approved' || val == 'None') && (revisitedDateList != null) && (revisitedDateList.length != undefined) && revisitedDateList.length > 0){
            revisitedDateList.forEach(function(eachInput){
                eachInput.set("v.disabled", false);
            });
        }
        else if ((val == 'N- Not Approved' || val == 'None') && (revisitedDateList != null) && (revisitedDateList.length == undefined) ){
            if(revisitedDateList.length == 1)
                revisitedDateList[0].set("v.disabled", false);
            else
                revisitedDateList.set("v.disabled", false);
        }
        
        
        // disable rejectionlist
        if((val == 'Y- Only Current Monthly Demand Approved' || val == 'Y- Current + Inc Demand Approved') && rejectionList != null && rejectionList.length != undefined && rejectionList.length > 0){
            rejectionList.forEach(function(eachInput){
                eachInput.set("v.disabled", true);
            });
        }else if (rejectionList.length == undefined || rejectionList.length == 1){
            if(rejectionList.length == 1)
                rejectionList[0].set("v.disabled", true);
            else
                rejectionList.set("v.disabled", true);
        }
        if((val == 'N- Not Approved' || val == 'None') && (rejectionList != null) && (rejectionList.length != undefined) && rejectionList.length > 0){
            rejectionList.forEach(function(eachInput){
                eachInput.set("v.disabled", false);
            });
        }
        else if ((val == 'N- Not Approved' || val == 'None') && (rejectionList != null) && (rejectionList.length == undefined) ){
            if(rejectionList.length == 1)
                rejectionList[0].set("v.disabled", false);
            else
                rejectionList.set("v.disabled", false);
        }
        //estimeted disable
        if((val == 'Y- Only Current Monthly Demand Approved' || val == 'Y- Current + Inc Demand Approved') && (estimatedList != null) && (estimatedList.length != undefined) && estimatedList.length >0 ){
            estimatedList.forEach(function(eachInput){
                eachInput.set("v.disabled", false);
            });
        }else if (estimatedList.length == undefined || estimatedList.length == 1){
            if(estimatedList.length == 1)
                estimatedList[0].set("v.disabled", false);
            else
                estimatedList.set("v.disabled", false);
        }
        if((val == 'N- Not Approved' || val == 'None') && (estimatedList != null) && (estimatedList.length != undefined) && estimatedList.length > 0){
            estimatedList.forEach(function(eachInput){
                eachInput.set("v.disabled", true);
            });
        }else if ((val == 'N- Not Approved' || val == 'None') && (estimatedList != null) && (estimatedList.length == undefined) && estimatedList.length > 0 ){
            if(estimatedList.length == 1)
                estimatedList[0].set("v.disabled", true);
            else
                estimatedList.set("v.disabled", true);
        }
        
        
        let auraIds = [];
        auraIds = component.find('comment');
        let approvalIds = [] ;
        approvalIds = component.find('scmApprovalselect');
        if(component.get("v.scmData").length == 1 && auraIds.length == 'undefined'){
            if(val == 'Y- Only Current Monthly Demand Approved'){
                auraIds.set("v.value", '0');
            }
            else if(val == 'N- Not Approved'){
                auraIds.set("v.value", null);
            }
                else{
                    auraIds.set("v.value", '100');
                    
                }
            approvalIds.set("v.value", val);
            
        }
        if((val == 'Y- Only Current Monthly Demand Approved' || val == 'Y- Current + Inc Demand Approved' || val == 'N- Not Approved') && auraIds != null && auraIds.length > 0){
            console.log('inside the headerApproval')
            component.find("comment").forEach(function(eachInput){
                if(val == 'Y- Only Current Monthly Demand Approved'){
                    eachInput.set("v.value", '0');
                    let auraIds = component.find('comment');
                    if(auraIds != null){
                        auraIds.forEach(function(scmQty){
                            scmQty.set("v.disabled", true); 
                        });
                    }
                }
                else if(val == 'N- Not Approved'){
                    eachInput.set("v.value", null);
                    let auraIds = component.find('comment');
                    if(auraIds != null){
                        auraIds.forEach(function(scmQty){
                            scmQty.set("v.disabled", true); 
                        });
                    }
                }
                    else{
                        eachInput.set("v.value", '100');
                        let auraIds = component.find('comment');
                        if(auraIds != null){
                            auraIds.forEach(function(scmQty){
                                scmQty.set("v.disabled", false); 
                            });
                        }
                        
                    }
                
                
            });
        }
        if(approvalIds != null && approvalIds.length > 0){
            approvalIds.forEach(function(eachInput){
                eachInput.set("v.value", val);
            });
        }
        
        
    },
    
    downloadCsv : function(component,event,helper){    
        
        var ResultData = component.get("v.scmData");
        var template=component.get("v.templateType");
        
        var title=component.get("v.title");
        /*var est=component.get("v.recordId");
        console.log("est---->"+est);*/
        // call the helper function which "return" the CSV data as a String   
        var csv = helper.convertArrayOfObjectsToCSV(component,ResultData,template);   
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
        hiddenElement.download = 'SCM View'+'-'+title+'-'+Now+'.csv';  // CSV file Name* you can change it.[only name not .csv] 
        document.body.appendChild(hiddenElement); // Required for FireFox browser
        hiddenElement.click(); // using click() js function to download csv file
    },
    showSAdetails : function(component, event, helper){
        var listValues = event.currentTarget.id;
        document.getElementById(listValues+'contact').style.display="";
    },
    hideSAdetails : function(component, event, helper){
        var listValues = event.currentTarget.id;
        document.getElementById(listValues+"contact").style.display="none";
    },
})