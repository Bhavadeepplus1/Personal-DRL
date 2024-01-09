({
    pageReferenceChangeHandler: function(component, event, helper){
        let pageReference = component.get("v.pageReference");
        let recordId = pageReference.state.c__recordId;
        component.set("v.recordId",recordId);
        if (recordId != null && recordId!=undefined && recordId!='') {
            helper.getBidDetailsViewPage(component, helper);  
        }
    },
    
    doInit : function(component,event,helper) {
        
        helper.getBidDetailsViewPage(component, helper);    
    },
    effDateToastDisplay : function(component,event,helper) {
        
         var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                message:'Please Enter Effective Date',
                                duration:' 4000',
                                key: 'info_alt',
                                type: 'error',
                                mode: 'dismissible'
                            });
                            toastEvent.fire();     
    },
    
    backToBid : function(component, event, helper){
        let pageReference = component.get("v.pageReference");
        let recordId = pageReference.state.c__recordId;
        component.set("v.recordId",recordId);
        component.find("navigationService").navigate({
            type: "standard__recordPage",
            attributes: {
                recordId: component.get("v.recordId"),
                actionName: "view"
            }
        }, false);
        $A.get('e.force:refreshView').fire();
    }, 
    
    backForBidLineEdit : function(component,event,helper) {
        component.set("v.showuploadFile", false);
        component.set("v.showRecordView", true);
        $A.get('e.force:refreshView').fire();
        helper.getBidDetailsViewPage(component, helper);    
    },
    
    closeModal: function (component, event, helper) {
        /* if (recordId != null && recordId != undefined && recordId != '') {
                component.find("navigationService").navigate({
                    type: "standard__recordPage",
                    attributes: {
                        recordId: recordId,
                        actionName: "view"
                    }
                }, false); 
            } */
        $A.get('e.force:refreshView').fire();
    },
    
    
    removeDeletedRowLineItem: function (component, event, helper) {
        var selectedRec = event.getSource().get("v.name");
        var target = event.target;
        var rowIndex = selectedRec;
        console.log('rowIndex--->'+rowIndex);
        var action = component.get("c.deleteLineItems");
        action.setParams({
            'LineItemId' : rowIndex
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('state--->'+state);
        });
        $A.enqueueAction(action);
        var event = component.getEvent("lightningEvent");
        event.setParam("message", "the message to send" );
        event.fire();
        
        var AllRowsList = component.get("v.allProductRelatedToBid");
        if (AllRowsList.length === 1) {
            console.log('AllRowsList.length === 1');
        }
        for (let i = 0; i < AllRowsList.length; i++) {
            var pItem = AllRowsList[i];
            if (pItem.qlItem.Id == selectedRec) {
                var index = AllRowsList.indexOf(pItem);
                if (index > -1) {
                    AllRowsList.splice(index, 1);
                    var AllRowsList1 = AllRowsList;
                }
                
            }
        }
        component.set("v.allProductRelatedToBid",[]);
        component.set("v.allProductRelatedToBid", AllRowsList);
        var saveditems = component.get("v.allProductRelatedToBid");
        var alldata=component.get("v.allData");
        var prdlist1=[];
        var count=0;
        if(AllRowsList!=undefined && AllRowsList!=null && AllRowsList!='' && AllRowsList.length>0)
        {
            for (let i = 0; i < AllRowsList.length; i++) {
                for (let j = 0; j < alldata.length; j++) {
                    if (alldata[j].qlItem.Id == AllRowsList[i].qlItem.Id)
                    {
                        count=count+1;
                        prdlist1.push(alldata[j].qlItem.Id);
                        break;
                    }                                   
                }
            }
        }
        component.set("v.selectedCount",count);
        if(count==0)
            component.set("v.showbutton",true);
        else
            component.set("v.showbutton",false);
        
         var allRowsAfterDel = component.get("v.allProductRelatedToBid");
        if(allRowsAfterDel.length==0){
          component.set("v.showNoRecMsg", true);       
        }
        helper.buildData(component, helper);
    },
    
    insertProducts: function (component, event, helper) {
        var quoteId =component.get("v.recordId");
        var  saveitems1=[];
        saveitems1=component.get("v.allProductRelatedToBid");
        
        let res = component.find("newWAC");
        
        if(res!=undefined){
            if(res!= null && res.length>1){
                for(let i = 0; i < res.length; i++){
                    component.set("v.wacToast",false);
                    let val = res[i].get("v.value"); 
                    console.log("val-----------"+val);
                    if(val==undefined || val=='' || val==null){
                        console.log("-----1-----");
                        component.set("v.wacToast",true);
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            message:'Please Enter New WAC',
                            duration:' 4000',
                            key: 'info_alt',
                            type: 'error',
                            mode: 'dismissible'
                        });
                        toastEvent.fire();  
                        break;
                    }
                }
            }
            if(res.length==1 || res.length==undefined){
                let res1 = Array.isArray(res);
                if(res1==false){
                    component.set("v.wacToast",false);
                    var nwWAC=component.find('newWAC').get("v.value");    
                    if(nwWAC==null || nwWAC==undefined || nwWAC==''){
                        component.set("v.wacToast",true);
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            message:'Please Enter New WAC',
                            duration:' 4000',
                            key: 'info_alt',
                            type: 'error',
                            mode: 'dismissible'
                        });
                        toastEvent.fire();        
                    }    
                }
                if(res1==true){
                    for(let i = 0; i < res.length; i++){
                        let val34 = res[0].get("v.value"); 
                        console.log("val34-----------"+val34);
                        let val = res[i].get("v.value"); 
                        console.log("val-----------"+val);
                        if(val34==undefined || val34=='' || val34==null){
                            console.log("-----1-----");
                            component.set("v.wacToast",true);
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                message:'Please Enter New WAC',
                                duration:' 4000',
                                key: 'info_alt',
                                type: 'error',
                                mode: 'dismissible'
                            });
                            toastEvent.fire();   
                            if(component.get("v.wacToast")==true){
                                break;    
                            }
                        } 
                        else{
                            component.set("v.wacToast",false); 
                        }
                    }   
                }
            }
        }
        else{
            component.set("v.wacToast",false);  
        }
        /*  let resDate = component.find("effDate");
        if(resDate!=undefined){
            if(resDate!= null && resDate.length>1){
                for(let i = 0; i < resDate.length; i++){
                    component.set("v.effDateToast",false);
                    let valDate = resDate[i].get("v.value"); 
                    if(valDate==undefined || valDate==' ' || valDate==null){
                        console.log("-----1-----");
                        component.set("v.effDateToast",true);
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            message:'Please Enter Effective Date',
                            duration:' 4000',
                            key: 'info_alt',
                            type: 'error',
                            mode: 'dismissible'
                        });
                        toastEvent.fire();   
                        if(component.get("v.effDateToast")==true){
                            console.log("----2---");
                            break;    
                        }
                    }
                }
            }
            if(resDate.length==1 || resDate.length==undefined){
                let resp = Array.isArray(resDate);
                if(resp==false){
                    component.set("v.effDateToast",false);
                    var effctDate=component.find('effDate').get("v.value");    
                    if(effctDate==null || effctDate==undefined || effctDate==' '){
                        component.set("v.effDateToast",true);
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            message:'Please Enter Effective Date',
                            duration:' 4000',
                            key: 'info_alt',
                            type: 'error',
                            mode: 'dismissible'
                        });
                        toastEvent.fire();        
                    }    
                }
                if(resp==true){
                    for(let i = 0; i < resDate.length; i++){
                        let val2 = resDate[i].get("v.value"); 
                        if(val2==undefined || val2==' ' || val2==null){
                            component.set("v.effDateToast",true);
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                message:'Please Enter Effective Date',
                                duration:' 4000',
                                key: 'info_alt',
                                type: 'error',
                                mode: 'dismissible'
                            });
                            toastEvent.fire();   
                            if(component.get("v.effDateToast")==true){
                                break;    
                            }
                        }
                        else{
                            component.set("v.effDateToast",false);  
                        }
                    }   
                }
            }
        }
        else{
            component.set("v.effDateToast",false);     
        }*/
        
        let resDate = component.find("effDate").get("v.value");
        console.log('--------resDate--------'+resDate);
        if(resDate==null || resDate==undefined || resDate==''){
            component.set("v.effDateToast",true);
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                message:'Please Enter Effective Date',
                duration:' 4000',
                key: 'info_alt',
                type: 'error',
                mode: 'dismissible'
            });
            toastEvent.fire();     
        }
        else{
                    component.set("v.effDateToast",false);
    
        }
        
        var wac=  component.get("v.wacToast");
        var effdate= component.get("v.effDateToast");
       
        if(wac==false && effdate==false){
                console.log('saveitems1--JSON.stringify-------');
            component.set("v.showSpinnerSelProds",true);   
            var action = component.get("c.editQuoteItems");
            var wrap=component.get("v.wrap");
            console.log('saveitems1--JSON.stringify-------'+JSON.stringify(saveitems1));
            action.setParams({ "saveitems": saveitems1,
                              "bidWrapper": component.get("v.wrap"),
                              "effDt":resDate
                             });
            action.setCallback(this, function (response) {
                var actState = response.getState();
                 console.log('actState-'+actState);
                if (actState === 'SUCCESS') {
                    console.log('--1--');
                    
                    component.set("v.showSpinnerSelProds",false);
                     component.set("v.isEffDateExists",true);
                    var resposeData = response.getReturnValue();
                    //component.set("v.showProducts", false);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type": 'success',
                        "message": "Line Item(s) has been Updated successfully."
                    });
                    toastEvent.fire();
                    $A.get('e.force:refreshView').fire();
                    /*  var pageReference = {
                            type: "standard__recordPage",
                            attributes: {
                                recordId: component.get("v.recordId"),
                                objectApiName: "Phoenix_Bid__c",
                                actionName: "view"
                            }
                        };
                        var navService = component.find("navigationService");
                        navService.navigate(pageReference);*/
                }
                else{
                    component.set("v.showSpinnerSelProds",false);
                }
            });
            $A.enqueueAction(action);    
        }      
    },
    
    handleUploadFinished: function (component, event, helper) {
        helper.handleUploadFinished(component, event);
    },
    
    deleteAttachment: function (component, event, helper) {
        let pageReference = component.get("v.pageReference");
        let recordId = pageReference.state.c__recordId;
        component.set("v.recordId",recordId);
        var selectedRec = event.getSource().get("v.name");
        var target = event.target;
        var action = component.get("c.deleteAttachments");
        action.setParams({
            'LineItemId' :selectedRec,
            'bidId':recordId
        });
        action.setCallback(this,function(response) {
            var state = response.getState();
            if(state=='SUCCESS'){
            }
            
        });
        $A.enqueueAction(action);
        var event = component.getEvent("lightningEvent");
        event.setParam("message", "the message to send" );
        event.fire();
        
        var AllRowsList = component.get("v.fileList");
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
    showSaveCancelForEdit: function (component, event, helper) {
        component.set("v.showSaveCancelBtn1",true); 
        
    },
    showSaveCancel: function (component, event, helper) {
        var bus= component.find("businessAppStatus");
        var country=component.find("countryAppStatus");
        var fin= component.find("financeAppStatus");
        var contr= component.find("contrAppStatus");
        var busCom= component.find("businessComments");
        var finCom= component.find("financeComments");
        var contrCom= component.find("contrComments");
        var countryCom=component.find("countryComments");
        
        if(bus!=undefined && component.find("businessAppStatus").get("v.value")!=''){
            component.set("v.showSaveCancelBtn",true); 
            component.set("v.showProceedBtn",false);
        }
        else if(fin!=undefined && component.find("financeAppStatus").get("v.value")!=''){
            component.set("v.showSaveCancelBtn",true);  
            component.set("v.showProceedBtn",false);
        }
            else if(contr!=undefined && component.find("contrAppStatus").get("v.value")!=''){
                component.set("v.showSaveCancelBtn",true);  
            }
                else if(country!=undefined && component.find("countryAppStatus").get("v.value")!=''){
                    component.set("v.showSaveCancelBtn",true);  
                }
                    else if(busCom!=undefined && component.find("businessComments").get("v.value")!=''){
                        component.set("v.showSaveCancelBtn",true); 
                        component.set("v.showProceedBtn",false);
                    }
                        else if(finCom!=undefined && component.find("financeComments").get("v.value")!=''){
                            component.set("v.showSaveCancelBtn",true); 
                            component.set("v.showProceedBtn",false);
                        }
                            else if(contrCom!=undefined && component.find("contrComments").get("v.value")!=''){
                                component.set("v.showSaveCancelBtn",true); 
                                component.set("v.showProceedBtn",false);
                            }
                                else if(countryCom!=undefined && component.find("countryComments").get("v.value")!=''){
                                    component.set("v.showSaveCancelBtn",true);  
                                }
                                    else{
                                        component.set("v.showSaveCancelBtn",false);
                                    } 
    },
    
    //-------This is for rendering the Proceed Button------>
    
    
    saveApprovalBus: function (component, event, helper) {
        let pageReference = component.get("v.pageReference");
        let recordId = pageReference.state.c__recordId;
        component.set("v.recordId",recordId);
        var value= component.find("businessAppStatus");
        var value2= component.find("businessComments");
        if(value!=undefined){
            var busStatus=component.find("businessAppStatus").get("v.value");
        }
        if(value2!=undefined){
            var busCom=component.find("businessComments").get("v.value");
        }
        var action = component.get("c.saveToBidBus");
        action.setParams({
            'bidId': recordId,
            'busStatus':busStatus,
            'busCom':busCom
            
        });
        action.setCallback(this, function (response){
            if(response.getState() === "SUCCESS"){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type":"success",
                    "title": "Success",
                    "message": "Record has been Updated successfully."
                });
                toastEvent.fire();
                component.set("v.showProceedBtn",true);
                component.set("v.showSaveCancelBtn",false);
            }
            else{
                var errors = response.getError();
                console.log("Error message: -----------------------" +
                            errors[0].message);
            }
        });
        $A.enqueueAction(action);
    },
    
    saveApprovalCountry: function (component, event, helper) {
        let pageReference = component.get("v.pageReference");
        let recordId = pageReference.state.c__recordId;
        component.set("v.recordId",recordId);
        var value= component.find("countryAppStatus");
        var value2= component.find("countryComments");
        if(value!=undefined){
            var countryStatus=component.find("countryAppStatus").get("v.value");
        }
        if(value2!=undefined){
            var countryCom=component.find("countryComments").get("v.value");
        }
        console.log('--------1-----1------');
        var action = component.get("c.saveToBidCountry");
        console.log('--------1-----2------');
        action.setParams({
            'bidId': recordId,
            'countryStatus':countryStatus,
            'countryCom':countryCom
            
        });
        action.setCallback(this, function (response){
            if(response.getState() === "SUCCESS"){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type":"success",
                    "title": "Success",
                    "message": "Record has been Updated successfully."
                });
                toastEvent.fire();
                component.set("v.showProceedBtn",true);
                component.set("v.showSaveCancelBtn",false);
            }
            else{
                var errors = response.getError();
                console.log("Error message: -----------------------" +
                            errors[0].message);
            }
        });
        $A.enqueueAction(action);
    }, 
    
    saveApprovalFin: function (component, event, helper) {
        let pageReference = component.get("v.pageReference");
        let recordId = pageReference.state.c__recordId;
        component.set("v.recordId",recordId);
        var value= component.find("financeAppStatus");
        var value2= component.find("financeComments");
        if(value!=undefined){
            var finStatus=component.find("financeAppStatus").get("v.value");
        }
        if(value2!=undefined){
            var finCom=component.find("financeComments").get("v.value");
        }
        console.log('--------1-----1------');
        var action = component.get("c.saveToBidFin");
        console.log('--------1-----2------');
        action.setParams({
            'bidId': recordId,
            'finStatus':finStatus,
            'finCom':finCom
        });
        action.setCallback(this, function (response){
            if(response.getState() === "SUCCESS"){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type":"success",
                    "title": "Success",
                    "message": "Record has been Updated successfully."
                });
                toastEvent.fire();
                component.set("v.showProceedBtn",true);
                component.set("v.showSaveCancelBtn",false);
            }
            else{
                var errors = response.getError();
                console.log("Error message: -----------------------" +
                            errors[0].message);
            }
        });
        $A.enqueueAction(action);
    },
    saveApprovalContr: function (component, event, helper) {
        let pageReference = component.get("v.pageReference");
        let recordId = pageReference.state.c__recordId;
        component.set("v.recordId",recordId);
        var value= component.find("contrAppStatus");
        var value2= component.find("contrComments");
        if(value!=undefined){
            var contrStatus=component.find("contrAppStatus").get("v.value");
        }
        if(value2!=undefined){
            var contrCom=component.find("contrComments").get("v.value");
        }
        var action = component.get("c.saveToBidContr");
        action.setParams({
            'bidId': recordId,
            'contrStatus':contrStatus,
            'contrCom':contrCom
            
        });
        action.setCallback(this, function (response){
            if(response.getState() === "SUCCESS"){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type":"success",
                    "title": "Success",
                    "message": "Record has been Updated successfully."
                });
                toastEvent.fire();
                component.set("v.showProceedBtn",true);
                component.set("v.showSaveCancelBtn",false);
            }
            else{
                var errors = response.getError();
                console.log("Error message: -----------------------" +
                            errors[0].message);
            }
        });
        $A.enqueueAction(action);
    },
    
    saveToProceedBusiness: function (component, event, helper) {
        
        let pageReference = component.get("v.pageReference");
        let recordId = pageReference.state.c__recordId;
        component.set("v.recordId",recordId);
        var finComm=component.find("businessComments").get("v.value");
        var finAppStatus=component.find("businessAppStatus").get("v.value");
        var approvalStatus=component.get("v.approvalStatus");
        if(finAppStatus==null || finAppStatus==''){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                message:'Please select a valid Approval Status to proceed further',
                duration:' 8000',
                key: 'info_alt',
                type: 'error',
                mode: 'dismissible'
            });
            toastEvent.fire();      
        }
        else{
            var action = component.get("c.makeApprovalsBusiness");
            action.setParams({
                'bidId' : component.get("v.recordId"),
                'finaceCom':finComm,
                'financeAppStatus':finAppStatus,
                'approvStatus':approvalStatus
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
                let pageReference = component.get("v.pageReference");
                let recordId = pageReference.state.c__recordId;
                component.set("v.recordId",recordId);
                component.find("navigationService").navigate({
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
    },
    
    
    saveToProceedCountry: function (component, event, helper) {
        let pageReference = component.get("v.pageReference");
        let recordId = pageReference.state.c__recordId;
        component.set("v.recordId",recordId);
        var finComm=component.find("countryComments").get("v.value");
        var finAppStatus=component.find("countryAppStatus").get("v.value");
        
        var approvalStatus=component.get("v.approvalStatus");
        if(finAppStatus==null || finAppStatus==''){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                message:'Please select a valid Approval Status to proceed further',
                duration:' 8000',
                key: 'info_alt',
                type: 'error',
                mode: 'dismissible'
            });
            toastEvent.fire();      
        }
        else{
            var action = component.get("c.makeApprovalsCountry");
            action.setParams({
                'bidId' : component.get("v.recordId"),
                'finaceCom':finComm,
                'financeAppStatus':finAppStatus,
                'approvStatus':approvalStatus
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
                let pageReference = component.get("v.pageReference");
                let recordId = pageReference.state.c__recordId;
                component.set("v.recordId",recordId);
                component.find("navigationService").navigate({
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
    },
    
    //-------This is used for  Finance Approval----->
    
    saveToProceedFinance: function (component, event, helper) {
        
        let pageReference = component.get("v.pageReference");
        let recordId = pageReference.state.c__recordId;
        component.set("v.recordId",recordId);
        var finance=component.get("v.isFinanceApprovePerson");
        var finComm=component.find("financeComments").get("v.value");
        var finAppStatus=component.find("financeAppStatus").get("v.value");
        var approvalStatus=component.get("v.approvalStatus");
        if(finAppStatus==null || finAppStatus==''){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                message:'Please select a valid Approval Status to proceed further',
                duration:' 8000',
                key: 'info_alt',
                type: 'error',
                mode: 'dismissible'
            });
            toastEvent.fire();      
        }
        else{
            var action = component.get("c.makeApprovalsFinance");
            action.setParams({
                'bidId' : component.get("v.recordId"),
                'finaceCom':finComm,
                'financeAppStatus':finAppStatus,
                'approvStatus':approvalStatus
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
                let pageReference = component.get("v.pageReference");
                let recordId = pageReference.state.c__recordId;
                component.set("v.recordId",recordId);
                component.find("navigationService").navigate({
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
    },
    
    //-------This is used for  Contracts Approval----->
    
    saveToProceedCont: function (component, event, helper) {
        let pageReference = component.get("v.pageReference");
        let recordId = pageReference.state.c__recordId;
        component.set("v.recordId",recordId);
        var contr=component.get("v.isContractsApprovePerson");
        var finComm=component.find("contrComments").get("v.value");
        var finAppStatus=component.find("contrAppStatus").get("v.value");
        console.log('-----------finAppStatus-----------'+finAppStatus);
        var approvalStatus=component.get("v.approvalStatus");
        if(finAppStatus==null || finAppStatus==''){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                message:'Please select a valid Approval Status to proceed further',
                duration:' 8000',
                key: 'info_alt',
                type: 'error',
                mode: 'dismissible'
            });
            toastEvent.fire();      
        }
        else{
            var action = component.get("c.makeApprovalsContracts");
            action.setParams({
                'bidId' : component.get("v.recordId"),
                'finaceCom':finComm,
                'financeAppStatus':finAppStatus,
                'approvStatus':approvalStatus
            });
            action.setCallback(this, function (response){
                if(response.getState() === "SUCCESS"){
                    console.log('--contr------');
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
                let pageReference = component.get("v.pageReference");
                let recordId = pageReference.state.c__recordId;
                component.set("v.recordId",recordId);
                component.find("navigationService").navigate({
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
    },
    
    downloadCsv : function(component,event,helper){    
        
        var ResultData = component.get("v.allProductRelatedToBid");
        // console.log('JSON.stringify(ResultData)---------'+JSON.stringify(ResultData));
        var csv = helper.convertArrayOfObjectsToCSV(component,ResultData);  
        var bidNumber=component.get("v.bidNumber");
        var bidName=component.get("v.bidName");
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
        hiddenElement.download = 'WAC Change Submissions'+'-'+bidNumber+'-'+bidName+Now+'.csv';  // CSV file Name* you can change it.[only name not .csv] 
        document.body.appendChild(hiddenElement); // Required for FireFox browser
        hiddenElement.click(); // using click() js function to download csv file
        
    }
    
})