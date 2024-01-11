({
    handleUploadFinished: function (component, event, helper) {
        //helper.handleUploadFinished(component, event);
        var uploadedFiles = event.getParam("files");
        console.log('uploadedFiles'+JSON.stringify(uploadedFiles));
        //component.set('v.fileList',uploadedFiles);
        var fieleListUpdated = [];
        fieleListUpdated = uploadedFiles;
        var fileList = component.get('v.fileList');
        //console.log('fileList'+JSON.stringify(fileList));
        //console.log('fileList'+fileList.length);
        if(fileList.length>0) {
            fieleListUpdated.push.apply(fieleListUpdated, fileList);
        }
        //console.log('fieleListUpdated'+JSON.stringify(fieleListUpdated));
        component.set('v.fileList',fieleListUpdated);
    },
    deleteAttachment: function (component, event, helper) {
        component.set('v.isSpinnerLoad',true);
        var LineItemIds = [];
        var selectedRec = event.getSource().get("v.name");
        console.log('selectedRec::'+selectedRec);
        LineItemIds.push(selectedRec);
        var action = component.get("c.deleteAttachmentList");
        action.setParams({
            'LineItemIds' : LineItemIds
        });
        action.setCallback(this,function(response) {
            var state = response.getState();
            if(state=='SUCCESS'){
                component.set('v.isSpinnerLoad',false);
                console.log('response::'+response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
        var AllRowsList = component.get("v.fileList");
        for (let i = 0; i < AllRowsList.length; i++) {
            var pItem = AllRowsList[i];
            if (pItem.documentId == selectedRec) {
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
    handleOnload : function(component,event,helper){
        var deadlinedate;
        var recUi = event.getParam("recordUi"); 
        if(recUi.record.fields["Phoenix_Bid_Deadline_Date__c"]!=undefined){
            deadlinedate= recUi.record.fields["Phoenix_Bid_Deadline_Date__c"].value;
        }
    },
    delayTypeChange : function(component, event, helper) {
        console.log('test==>'+event.getParam("value"))
        //added by satya//
        if(event.getParam("value") == 'Controllable' || event.getParam("value") == 'Uncontrollable'){
            component.set("v.delayType",true);
        }  
        else{
            component.set("v.delayType",false);
        }
    },

    handleChange : function(component, event, helper) {
        
        var custId= component.get("v.customerLkp");
        console.log('custId'+custId);
          var compId=event.getParam("cmpId");
        console.log("oldvalue--"+event.getParam("oldValue"));
        component.set("v.customerRecord",custId);
        if(custId!=null && custId!=undefined && custId!=''){
            component.set('v.isSpinnerLoad',true);
            var action = component.get("c.getcustomerOwner");
            
            action.setParams({
                "custID": custId          
            });
            action.setCallback(this, function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var excludeBidTypeList = ['Good Dated OTB','Platform PO OTB','Platform OTB','Short Dated OTB','NEW Individual Pricing Agreement (IPA)','VIP Rebate','Initial Order Discount for WAC Customers (No-Contract Price Offering)'];
                    console.log('response.getReturnValue()--'+JSON.stringify(response.getReturnValue()));
                    var responseWrapper=response.getReturnValue();
                   
                    if(component.find('salesperson')!=null){
                        component.find('salesperson').set('v.value',responseWrapper.Ownerid);
                    }  
                    var custName=responseWrapper.AccNumber;
                    //responseWrapper.AccName;                
                    component.set('v.custName',responseWrapper.AccName);
                    
                    component.set('v.BidTemplate',responseWrapper.template);
                    console.log("template---->"+responseWrapper.template)
                    var bidType = component.get("v.BidType");
                    //added by joga for golden state
                    if(responseWrapper.template == 'Direct or Indirect' && bidType != undefined && !excludeBidTypeList.includes(bidType)){
                        component.set("v.isBothTemplate",true);
                    }else{
                        component.set("v.isBothTemplate",false);
                    }
                    if(responseWrapper.template == 'ROS' && bidType != undefined && !excludeBidTypeList.includes(bidType)){
                        component.set("v.isROSTemplate",true);
                    }else{
                        component.set("v.isROSTemplate",false);
                    }
                    if(responseWrapper.template == 'Humana' && bidType != undefined && !excludeBidTypeList.includes(bidType)){
                        component.set("v.isHumanaTemplate",true);
                    }else{
                        component.set("v.isHumanaTemplate",false);
                    }
                    if(custName == '370260' && bidType != undefined && !excludeBidTypeList.includes(bidType)){  //
                        console.log("customer is Amerisource");
                        component.set('v.isABCCustomer',true);
                    }               
                     if(event.getParam("oldValue")==custId && compId=="customerLookup"){
            
            
             component.set('v.customerHireachyListString','()'); 
                            console.log('accString-->'+component.get('v.customerHireachyListString'));
           }
                    else{
                    
              
                    var accountIds=responseWrapper.Acchirarchy;
                    console.log('accountIds--'+accountIds);
                    
                    
                    
                    
                    
                    
                    var accString ;
                    if(accountIds.length>0 && accountIds[0]!=null) {
                        accString= '( AccountId = '+ '\''+accountIds[0] +'\'';
                    } 
                    accountIds.forEach(function(accId){
                        accString += ' OR AccountId = ' + '\''+accId +'\'';
                        
                    });
                    accString += ' )';
                    console.log('accString-->'+accString);
                    
                    component.set('v.customerHireachyListString',accString); 
                    }
                    component.set('v.isSpinnerLoad',false);
                }else{
                    component.set('v.isSpinnerLoad',false);
                }
                
            });
            $A.enqueueAction(action);    
        }
        // component.set("v.RcaAgreement2",custId)	
        // component.set('v.isSpinnerLoad',false);
    },
    customerChange : function(component,event,helper){
        let customer=component.find("customerVal").get("v.value");
        console.log('customer---'+customer);
        component.set("v.customerRecord",customer);
    },
    
    bidTypeChange : function(component,event,helper){
        /* var OutDiv=component.find("mdCont");
        $A.util.removeClass(OutDiv, "hidescroll");
        var OutDiv1=component.find("model");
        $A.util.addClass(OutDiv1, "hideposi");*/
        var bidtypeVal=event.getParam("value");
        component.set("v.BidType",bidtypeVal);
        if(bidtypeVal != undefined && bidtypeVal != null && bidtypeVal.includes('OTC')){
            component.set("v.isOTCBid",true);
            console.log('OTC')
        }else{
            component.set("v.isOTCBid",false);
        }
        console.log('change type--'+event.getParam("value"));
        if(bidtypeVal=='IPA Floor Pricing Update' || bidtypeVal=='Mass Product Removals'|| bidtypeVal=='Product Discontinuation Process' || bidtypeVal=='SRx IPA Price Change' || bidtypeVal=='SRx IPA Product Addition' || bidtypeVal=='RCA/IPA Member GPO or Wholesaler Change'|| bidtypeVal=='WAC Change Submissions' || bidtypeVal=='Direct Order Form Pricing Update' || bidtypeVal=='RCA Member Addition' || bidtypeVal=='IPA Member Addition'){
            component.set("v.NoCustContact",false);
        }else{
            component.set("v.NoCustContact",true);
        }
        console.log('NoCustContact--'+component.get("v.NoCustContact"));
        if( bidtypeVal=='SRx IPA Product Addition' || bidtypeVal=='SRx IPA Price Change' || bidtypeVal=='RCA Member Addition' || bidtypeVal=='IPA Member Addition' || bidtypeVal=='Direct Order Form Pricing Update' || bidtypeVal=='IPA Floor Pricing Update' || bidtypeVal=='RCA/IPA Member GPO or Wholesaler Change' || bidtypeVal=='WAC Change Submissions' || bidtypeVal=='Product Discontinuation Process' || bidtypeVal=='Mass Product Removals') {
            component.set("v.deadLineValue",false);
        }else{
            component.set("v.deadLineValue",true);
        }
        if(bidtypeVal=='Direct Order Form Pricing Update' || bidtypeVal=='WAC Change Submissions' || bidtypeVal=='RCA Member Addition' || bidtypeVal=='IPA Member Addition' || bidtypeVal=='RCA/IPA Member GPO or Wholesaler Change' || bidtypeVal=='SRx IPA Price Change' || bidtypeVal=='SRx IPA Product Addition' ||  bidtypeVal =='IPA Floor Pricing Update'|| bidtypeVal=='Product Discontinuation Process' || bidtypeVal=='Mass Product Removals'){
            component.set("v.hasInternalDate",true);
        }else{
            component.set("v.hasInternalDate",false);
        }
        /* var today = new Date();
        var dd = String(today.getDate()).padStart(2, '0');
        var mm = String(today.getMonth() + 1).padStart(2, '0'); //January is 0!
        var yyyy = today.getFullYear();
        today = yyyy + '-' + mm + '-' +dd;       
        if(component.find("deadLineDate")!=null &&(component.find("deadLineDate").get("v.value")==null || component.find("deadLineDate").get("v.value")==undefined)){
            component.find("deadLineDate").set("v.value",today);
        }*/
    },
    
    Onload: function(component,event,helper){
        $A.get('e.force:refreshView').fire();
    },
    pageReferenceChangeHandler: function(component, event, helper){
        let pageReference = component.get("v.pageReference");
        console.log('pageReference'+ pageReference);
        let recordId = pageReference.state.c__recordId;
        console.log("pageReferenceChangeHandler: recordId: " + recordId);
        if (recordId != null && recordId!=undefined && recordId!='') {
            
            helper.loadInstance(component, helper);  
            
        }else{
            //console.log("else part");
            
            component.set("v.recordId", null);
            component.set("v.isCreate",true); 
            $A.get('e.force:refreshView').fire();
        }
        
        
    },
    doInit : function(component,event,helper) {
        console.log("---doInit()-----");
        component.set('v.fileList',[]);
        helper.loadInstance(component, helper); 
        helper.getRecordTypeIds(component, event,helper); 
        /*  var OutDiv1=component.find("model");
        $A.util.addClass(OutDiv1, "hideposi");*/
        
    },
    closeQuickActionPanel: function (component, event, helper) {
        // console.log("---BidEdit---returnToRecord()-------"+component.get("v.recordId"));
        try {
            //$A.get('e.force:refreshView').fire();
            let recordId = component.get("v.recordId");
            if (recordId != null ) {
                // Go to record
                component.find("navigationService").navigate({
                    type: "standard__recordPage",
                    attributes: {
                        recordId: recordId,
                        actionName: "view"
                    }
                }, false); // replace
            } 
            else {
                // Go to Initiative Home
                component.find("navigationService").navigate({
                    type: "standard__objectPage",
                    attributes: {
                        objectApiName: "Phoenix_Bid__c",
                        actionName: "home"
                    }
                }, false); // replace
            }
        } catch (ex) {
            console.log(ex);
        }
        
    },
    redirectToDetailPage: function (component, event, helper) {
        
        
        
        var record = event.getParam("response");
        var apiName = record.apiName;
        console.log('apiName-->'+apiName)
        var myRecordId = record.id; 
        console.log('myRecordId: '+myRecordId);
        component.set("v.recordId1",myRecordId);
        helper.handleUploadFinished(component, event,myRecordId);
        
        var message;
        if(component.get("v.recordId")  == null|| component.get("v.recordId")  ==''||component.get("v.recordId")  == undefined){
            message = 'created';
            console.log('in if , record saved')
            
        }else{
            message = 'updated';
        }
        console.log('message------'+message);
        try{
            if(message=='updated'){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type" : "success",
                    "title": "Success!",
                    "message": "The record has been "+message+ " successfully."
                });
                toastEvent.fire();
                
                
                component.find("navigationService").navigate({
                    type: "standard__recordPage",
                    attributes: {
                        recordId: component.get("v.recordId"),
                        actionName: "view"
                    }
                }, false); // replace
                
                // $A.get('e.force:refreshView').fire();
                
            }
            else{
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type" : "success",
                    "title": "Success!",
                    "message": "The record has been "+message+ " successfully."
                });
                toastEvent.fire();
                
                
                component.find("navigationService").navigate({
                    type: "standard__recordPage",
                    attributes: {
                        recordId:myRecordId ,
                        actionName: "view"
                    }
                }, false);
                //$A.get('e.force:refreshView').fire();
                
            }
        }
        catch(ex){
            console.log('exception'+ex);
        }
        
        
        
    },
    getErrorMessage: function (component, event, helper) {
        //console.log('errormessage---->'+event.getParam("output").fieldErrors);
    },
    
    onSaveNext: function (component, event, helper) {
        
    },
    
    handleSubmit: function(component, event, helper) {         
        helper.handleFormSubmit(component, event, helper);
    }
    
    
})