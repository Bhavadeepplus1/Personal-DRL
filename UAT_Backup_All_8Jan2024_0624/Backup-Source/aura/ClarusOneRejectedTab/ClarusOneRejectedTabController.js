({
    collpase: function (component, event, helper) {
        var LineItemtable = component.find("LineTable");
        $A.util.toggleClass(LineItemtable, "fixedtable");
    },
    hideSubmitModel : function(component, event, helper) { 
         component.set('v.submitModel',false);
        var LineItemtable = component.find("LineTable");
        $A.util.addClass(LineItemtable, "maintable");
    },
    proceedToSubmit : function(component, event, helper) { 
        if(component.get("v.BidAprrovalStatus")=='Draft'){
            component.set('v.submitModel',false);
            var LineItemtable = component.find("LineTable");
        $A.util.addClass(LineItemtable, "maintable");
            helper.getBidInfoForValids(component,event,helper);
        }
    },
    submitFor : function(component, event, helper) { 
       
        
        component.set('v.isSpinnerLoad',true);
        var contrcts=component.get('v.selectedCntrcts');
        var bidType=component.get("v.BidTypeVal");
        var bidrecord=component.get("v.bidRecord");
        var isBidNotValid;
        if(bidrecord.Phoenix_Reference_Contracts__c==null && bidType!='New Customer'){
            isBidNotValid= "Please Select a Contract";          
        }//else if(bidType == 'Sales Out Rebate' && (bidrecord.Phoenix_Sales_Out_Promotion_of_Days__c == null || bidrecord.Phoenix_Sales_Out_Promotion_of_Days__c == '' )){
           // isBidNotValid= "Please Enter Sales Out Promotion # of Days";
        //}else if(bidType == 'Sales Out Rebate' && (bidrecord.Phoenix_Proposed_Sales_Out_Promotion__c == null || bidrecord.Phoenix_Proposed_Sales_Out_Promotion__c == '')){
          //  isBidNotValid="Please Enter Proposed Sales Out Promotion %";
        //}
        else if((bidType == 'Product Addition' || bidType == 'Price Change') && (bidrecord.Phoenix_Proactive_Reactive__c== null || bidrecord.Phoenix_Proactive_Reactive__c == '')){
            isBidNotValid= "Please Select Proactive/Reactive";
        }else if((bidType == 'Product Addition' || bidType == 'RFP Bids') && (bidrecord.Phoenix_Initial_Order_Discount_Type__c==null || bidrecord.Phoenix_Initial_Order_Discount_Type__c=='')){  
            isBidNotValid= "Please Select Initial Order Discount Type";
        }else if((bidType == 'Product Addition' || bidType == 'RFP Bids') && (bidrecord.Phoenix_Initial_Order_Discount_of_Days__c == null || bidrecord.Phoenix_Initial_Order_Discount_of_Days__c== '' || bidrecord.Phoenix_Initial_Order_Discount_of_Days__c == 0 ) && bidrecord.Phoenix_Initial_Order_Discount_Type__c != 'None' && bidrecord.Phoenix_Initial_Order_Discount_Type__c != 'Not Applicable'){
            var InitialOrderDays = bidrecord.Phoenix_Initial_Order_Discount_of_Days__c;
            isBidNotValid = InitialOrderDays == 0 ? 'Initial Order Discount # of Days must be greater than 0' : 'Please Enter Initial Order Discount # of Days';
        }else if((bidType == 'Product Addition' || bidType == 'RFP Bids') && (bidrecord.Phoenix_Proposed_Initial_Order_Discount__c == null || bidrecord.Phoenix_Proposed_Initial_Order_Discount__c== '' || bidrecord.Phoenix_Proposed_Initial_Order_Discount__c== 0) && bidrecord.Phoenix_Initial_Order_Discount_Type__c != 'None' && bidrecord.Phoenix_Initial_Order_Discount_Type__c != 'Not Applicable'){
            isBidNotValid = InitialOrderDays < 1 ? 'Proposed Initial Order Discount % must be greater than 0' : 'Please Enter Proposed Initial Order Discount %';
        }
        if(isBidNotValid){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "type":"error",
                "message":isBidNotValid
            });
            toastEvent.fire();
            component.set('v.isSpinnerLoad',false);  
        }           
            else{
            component.set('v.isSpinnerLoad',true);
            var qtyError;
            var templateType=component.get("v.templateType");
            var action = component.get("c.getupdatedforExport");      
            action.setParams
            ({
                bidId: component.get("v.recordId")
            });
            action.setCallback(this, function(response) 
                               {
                                   if(response.getState()=="SUCCESS"){
                                       var bidlines =  response.getReturnValue();
                                       var indirectCons = new Array();
                                       var DirectCons = new Array();
                                       indirectCons=contrcts.filter((contrcts) => contrcts.startsWith("3"));
                                       DirectCons=contrcts.filter((contrcts) => contrcts.startsWith("1"));
                                       console.log("indirectCons---->"+indirectCons.includes("3000000224"));
                                       console.log("indirectCons-type--->"+typeof(indirectCons));
                                       var isMacRADContract = (indirectCons != null && (indirectCons.includes("3000000224") || indirectCons.includes("3000000418") || indirectCons.includes("3000000047")));
                                       var isMacOSContract = (indirectCons != null && (indirectCons.includes("3000000071")));
                                       var isWMTIndirectContract = (indirectCons != null && indirectCons.includes("3000000143"));
                                       var isWMRDirectContract = (DirectCons != null && DirectCons.includes("1000000120"));
                                       for(var i=0;i<bidlines.length;i++){
                                           if(isMacRADContract && bidType!='Price Change' && bidType!='Customer Rebate Change' && bidType !='Sales Out Rebate' && (bidlines[i].Phoenix_Proposed_RAD_Units__c==null && bidlines[i].Phoenix_Proposed_OS_Units__c==null)){
                                               qtyError='Please Enter The Proposed OS/RAD Units for'+bidlines[i].Phoenix_Product__r.Name;
                                               break;
                                           }
                                           /*if(isMacOSContract && bidType!='Price Change' && bidType!='Customer Rebate Change' && bidType !='Sales Out Rebate' && (bidlines[i].Phoenix_Proposed_OS_Units__c==null )){
                                               qtyError='Please Enter The Proposed OS Units for'+bidlines[i].Phoenix_Product__r.Name;
                                               break;
                                           }*/
                                            if((isWMTIndirectContract || isWMRDirectContract) && bidType!='Price Change' && bidType!='Customer Rebate Change' && bidType !='Sales Out Rebate' && (bidlines[i].Phoenix_Proposed_WMT_Units__c ==null )){
                                               qtyError='Please Enter The Proposed WMT Units for'+bidlines[i].Phoenix_Product__r.Name;
                                               break;
                                           }
                                          
                                           if((isMacRADContract || isMacOSContract) && bidlines[i].Phoenix_Proposed_McK_OS_And_RAD_NCP__c==null && component.get("v.isMarketingApprovePerson")==component.get("v.loggedInUserName") && component.get("v.loggedInUserName")== bidlines[i].Phoenix_Product_Director1__c && bidType!='Customer Rebate Change' && bidType!='Volume Review Only' && bidType !='Sales Out Rebate'){
                                               qtyError='Please Enter Proposed NCP for McK OS And RAD';
                                               console.log('wholesaler Price');
                                               break;
                                           }
                                           else if(isWMTIndirectContract && component.get("v.isMarketingApprovePerson")==component.get("v.loggedInUserName") && bidlines[i].Phoenix_Proposed_WMT_Indirect_NCP__c==null && component.get("v.loggedInUserName")== bidlines[i].Phoenix_Product_Director1__c && bidType!='Customer Rebate Change' && bidType!='Volume Review Only'  && bidType !='Sales Out Rebate' ){
                                               qtyError='Please Enter Propsed WMT Indirect NCP';
                                               console.log('marketing Price');
                                               break;
                                           }
                                           else if(isWMRDirectContract && component.get("v.isMarketingApprovePerson")==component.get("v.loggedInUserName") && bidlines[i].Phoenix_Proposed_WMT_Direct_NCP__c==null && component.get("v.loggedInUserName")== bidlines[i].Phoenix_Product_Director1__c && bidType!='Customer Rebate Change' && bidType!='Volume Review Only'  && bidType !='Sales Out Rebate' ){
                                               qtyError='Please Enter Propsed WMT Direct NCP';
                                               console.log('marketing Price');
                                               break;
                                           }
                                           
                                       }
                                   }
                                   if(qtyError){
                                       var toastEvent = $A.get("e.force:showToast");
                                       toastEvent.setParams({
                                           "title": "Error!",
                                           "type":"error",
                                           "message":qtyError
                                       });
                                       toastEvent.fire();
                                       component.set('v.isSpinnerLoad',false);
                                   }else{
                                       component.set('v.isSpinnerLoad',false);
                                       component.set('v.submitModel',true);
                                       var LineItemtable = component.find("LineTable");
                                       $A.util.removeClass(LineItemtable, "maintable");
                                       console.log(component.get('v.submitModel'));
                                   }
                               });
            $A.enqueueAction(action);
        }
    },
    
    handleCalcEvent :function(component, event, helper) { 
        helper.getAllTotalValues(component,event,helper);
        //helper.handleCalcEventHelper(component, event, helper);
    },
    
    initRecords: function(component, event, helper) { 
        
        component.set("v.isSpecificCustomer",false);
        component.set("v.templateType","");
        component.set('v.isSpinnerLoad',true);
        component.set('v.selectedCntrcts',[]);
        component.set("v.selectedPosistions",[]);
        component.set("v.selectedMCKPosistions",[]);
        component.set('v.lstSelectedRecords',[]);
        component.set('v.lstSelectedPDRecords',[]);
        component.set('v.showSaveCancelBtn',false);
        component.set('v.isRxChecked',false);
        component.set('v.isSRxChecked',false);
        component.set('v.isOtcChecked',false); 
        component.set('v.RxSrxList',[]); 
        component.set("v.BidTypeVal","");
        console.log('---'+component.find("bidCntrcts"));
        
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
                                   var columnList = wrapperObj.columnList;
                                   var bidRecord = wrapperObj.bidRecord;
                                   component.set("v.bidRecord",bidRecord);
                                   var loggedinUserName=wrapperObj.loggedInUserName;
                                   var isMarketingApprovePerson=wrapperObj.isMarketingApprovePerson;
                                   var isContractsApprovePerson=wrapperObj.isContractsApprovePerson;
                                   var showProceedBtn=wrapperObj.showProceedBtn;
                                   var hasDirectorLines=wrapperObj.hasDirectorLines;                                   
                                   console.log('isContractsApprovePerson---'+isContractsApprovePerson);
                                   component.set("v.isMarketingApprovePerson",isMarketingApprovePerson); 
                                   component.set("v.isContractsApprovePerson",isContractsApprovePerson); 
                                   component.set("v.IODType",bidRecord.Phoenix_Initial_Order_Discount_Type__c);
                                   component.set("v.showProceedBtn",showProceedBtn);
                                   component.set("v.hasDirectorLines",hasDirectorLines);
                                   component.set("v.customerId",bidRecord.Phoenix_Customer__c);
                                   console.log('crnt--vip'+bidRecord.Phoenix_Current_Value_Est_VIP__c);
                                   component.set("v.crntVipVal",bidRecord.Phoenix_Current_Value_Est_VIP__c);
                                   if(lineItemsList.length == 0 || component.get("v.recordId") == null){
                                       component.set("v.isRelatedLineItemsEmpty", false);
                                   }
                                   
                                   component.set('v.defaultlistOfProductFamily', wrapperObj.productfamilyList);
                                   if( wrapperObj.productDirectorList!=null){
                                       component.set('v.defaultlistOfProductDirectors', wrapperObj.productDirectorList);
                                   }
                                   
                                   component.set("v.BidLineItemListAll",lineItemsList);
                                   component.set("v.ItemsLength",lineItemsList.length);
                                   component.set('v.isSpinnerLoad',false);                                  
                                   component.set("v.templateType",bidRecord.Phoenix_Customer_Type__c);
                                   component.set("v.bidNumber",bidRecord.Name);                                 
                                   component.set("v.bidName",bidRecord.Phoenix_Bid_Name__c);
                                   console.log('refcontrcts--'+bidRecord.Phoenix_Reference_Contracts__c);
                                   if( bidRecord.Phoenix_Reference_Contracts__c!=null && bidRecord.Phoenix_Reference_Contracts__c!=undefined){
                                       var refContracts=bidRecord.Phoenix_Reference_Contracts__c;
                                       component.set("v.selectedCntrcts",refContracts.split(','));
                                   }
                                   if (bidRecord.Phoenix_Bid_Proposed_Position__c != null && bidRecord.Phoenix_Bid_Proposed_Position__c != undefined) {
                                       var refPositions = bidRecord.Phoenix_Bid_Proposed_Position__c;
                                       component.set("v.selectedPosistions", refPositions.split(','));
                                   }
                                    if (bidRecord.Phoenix_Proposed_Position__c != null && bidRecord.Phoenix_Proposed_Position__c != undefined) {
                                       var refPositions = bidRecord.Phoenix_Proposed_Position__c;
                                       component.set("v.selectedMCKPosistions", refPositions.split(','));
                                   }
                                   console.log('bidRecord.Phoenix_Bid_Type__c---'+bidRecord.Phoenix_Bid_Type__c);
                                   if( bidRecord.Phoenix_Bid_Type__c!=null && bidRecord.Phoenix_Bid_Type__c!=undefined){
                                       component.set("v.BidTypeVal",bidRecord.Phoenix_Bid_Type__c);
                                   }
                                   console.log('bidRecord.Phoenix_Approval_Status__c---'+bidRecord.Phoenix_Approval_Status__c);
                                   if( bidRecord.Phoenix_Approval_Status__c!=null && bidRecord.Phoenix_Approval_Status__c!=undefined){
                                       component.set("v.BidAprrovalStatus",bidRecord.Phoenix_Approval_Status__c);
                                       /* if(bidRecord.Phoenix_Approval_Status__c=='Finance'){
                                           component.find("Tabset").set("v.selectedTabId",'FIV'); 
                                       }
                                       if(bidRecord.Phoenix_Approval_Status__c=='Contracts'){
                                           component.find("Tabset").set("v.selectedTabId",'Contracts'); 
                                       }*/
                                   }
                                   console.log('loggedinUserName--'+loggedinUserName);
                                   if( loggedinUserName!=null && loggedinUserName!=undefined){
                                       component.set("v.loggedInUserName",loggedinUserName);
                                   }
                                   if( bidRecord.Phoenix_Is_Re_Bid__c!=null && bidRecord.Phoenix_Is_Re_Bid__c!=undefined && bidRecord.Phoenix_Is_Re_Bid__c==true){
                                       component.set("v.isReBid",true);
                                   }else{
                                       component.set("v.isReBid",false);
                                   }

                                   
                                   var OutDiv = component.find("mainDiv");
                                   if(lineItemsList.length<10){
                                       console.log('--no-hight---');
                                       $A.util.addClass(OutDiv, "noheightClass");
                                   }else{
                                       $A.util.removeClass(OutDiv, "noheightClass");
                                   }
                                   helper.getAllTotalValues(component,event,helper);
                                   var LineItemtable = component.find("LineTable");                                  
                                   component.set("v.tableRef",LineItemtable);                                
                               }
                               else{
                                   component.set('v.isSpinnerLoad',false);
                               }
                           });
        $A.enqueueAction(action);
        
    }, 
    initFinnaceCmp : function(component, event, helper) {
        var financeCmp = component.find('financeChildCmp');
        financeCmp.financeRefresh();
    },
    initSCMCmp : function(component, event, helper) {
        var SCMCmp = component.find('SCMChildCmp');
        SCMCmp.scmRefresh();
    },    
    initNDCFinanceCmp : function(component, event, helper) {
        var NDCFinance = component.find('NDCFinance');
        NDCFinance.scmRefresh();
    },
    initRejectedStatus : function(component, event, helper) {
        var rejectedStatus = component.find('ClarusOneRejectedTab');
        rejectedStatus.rejectedStatusRefresh();
    },
    initContractsView : function(component, event, helper) {
        var rejectedStatus = component.find('ContractsTab');
        rejectedStatus.ContractsViewRefresh();
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
    handleOnload : function(component, event, helper) {      
        var recUi = event.getParam("recordUi");           
        //var pVip=recUi.record.fields["Phoenix_Proposed_Value_Est_VIP__c"].value;
        //console.log('pVip--'+pVip);
       // var crntVip=recUi.record.fields["Phoenix_Current_Value_Est_VIP__c"].value;
        //console.log('crntVip--'+crntVip);
        //var crntvipvalue;
        //if(crntVip != null && crntVip!=undefined){
        //    crntvipvalue= crntVip;
        //}
       // console.log('crntvipvalue--'+component.get("v.crntVipVal"));
        //if(component.get("v.BidTypeVal")!='New Customer' && (crntvipvalue==0 || crntvipvalue==null)){
         //   component.set("v.VipReadOnly",true);
       // }else{
        //    component.set("v.VipReadOnly",false);
        //}
        //console.log('vipreadonly--'+component.get("v.VipReadOnly"));
    },
    iodTypeChange : function(component, event, helper){
        component.set("v.showSaveCancelBtn",true);
        
        if(event.getSource().get("v.value")=='None' || event.getSource().get("v.value")=='' || event.getSource().get("v.value")=='Not Applicable'){
            component.find("iodDays").set("v.value",null);
            component.find("ProValIniId").set("v.value",null);
            component.find("iodDays").set("v.disabled",true);
            component.find("ProValIniId").set("v.disabled",true);
        }else{
            component.find("iodDays").set("v.disabled",false);
            component.find("ProValIniId").set("v.disabled",false);
        }       
    },
    onRecordSubmit : function(component, event, helper){
        event.preventDefault(); 
        var eventFields = event.getParam("fields");
        var slctCntrcts=component.get("v.selectedCntrcts");
        /* var cntrctstring='';
        for(var i=0;i<slctCntrcts.length;i++){
            if(i==0){
                cntrctstring=slctCntrcts[i].Name;
            }else{
                cntrctstring+=','+slctCntrcts[i].Name;
            }
        }*/
        var IODType = component.get("v.IODType");
        if(IODType!=null && IODType!=undefined && IODType!=''){
            eventFields["Phoenix_Initial_Order_Discount_Type__c"]=IODType;
        }
        var bidType = component.get("v.BidTypeVal");
        console.log('isRFp or Product Addition-->'+(bidType == 'RFP Bids' || bidType == 'Product Addition'));
        if(slctCntrcts.length==0 && component.get("v.BidTypeVal")!='New Customer'){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "type":"error",
                "message": "Please Select a Contract"
            });
            toastEvent.fire();
        }else if(bidType == 'Sales Out Rebate' && (eventFields["Phoenix_Sales_Out_Promotion_of_Days__c"] == null || eventFields["Phoenix_Sales_Out_Promotion_of_Days__c"] == '' || eventFields["Phoenix_Sales_Out_Promotion_of_Days__c"] == 0 )){
            var msg = eventFields["Phoenix_Sales_Out_Promotion_of_Days__c"] == 0 ? 'Sales Out Promotion # of Days must be greater than 0' :'Please Enter Sales Out Promotion # of Days';
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "type":"error",
                "message": msg
            });
            toastEvent.fire();
        }else if(bidType == 'Sales Out Rebate' && (eventFields["Phoenix_Proposed_Sales_Out_Promotion__c"] == null || eventFields["Phoenix_Proposed_Sales_Out_Promotion__c"] == '' || eventFields["Phoenix_Proposed_Sales_Out_Promotion__c"] == 0) ){
            var msg = eventFields["Phoenix_Proposed_Sales_Out_Promotion__c"] == 0 ? 'Proposed Sales Out Promotion % must be greater than 0' :'Please Enter Proposed Sales Out Promotion %';
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "type":"error",
                "message": msg
            });
            toastEvent.fire();
        }else if((bidType == 'Product Addition' || bidType == 'Price Change') && (eventFields["Phoenix_Proactive_Reactive__c"] == null || eventFields["Phoenix_Proactive_Reactive__c"] == '')){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "type":"error",
                "message": "Please Select Proactive/Reactive"
            });
            toastEvent.fire();
        }else if((bidType == 'RFP Bids' || bidType == 'Product Addition') && (eventFields["Phoenix_Initial_Order_Discount_Type__c"] == null || eventFields["Phoenix_Initial_Order_Discount_Type__c"] == '')){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "type":"error",
                "message": "Please Select Initial Order Discount Type"
            });
            toastEvent.fire();
        }else if((bidType == 'RFP Bids' || bidType == 'Product Addition') && (eventFields["Phoenix_Initial_Order_Discount_of_Days__c"] == null || eventFields["Phoenix_Initial_Order_Discount_of_Days__c"] == '' || eventFields["Phoenix_Initial_Order_Discount_of_Days__c"] == 0 ) && eventFields["Phoenix_Initial_Order_Discount_Type__c"] != 'None' && eventFields["Phoenix_Initial_Order_Discount_Type__c"] != 'Not Applicable'){
            var InitialOrderDays = eventFields["Phoenix_Initial_Order_Discount_of_Days__c"] ;
            var msg;
            if(InitialOrderDays=='' || InitialOrderDays==null){
               msg= 'Please Enter Initial Order Discount # of Days';
            }else{
             msg=InitialOrderDays == 0  ? 'Initial Order Discount # of Days must be greater than 0' : 'Please Enter Initial Order Discount # of Days';
            }
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "type":"error",
                "message": msg
            });
            toastEvent.fire();
        }else if((bidType == 'RFP Bids' || bidType == 'Product Addition') && (eventFields["Phoenix_Proposed_Initial_Order_Discount__c"] == null || eventFields["Phoenix_Proposed_Initial_Order_Discount__c"] == '' || eventFields["Phoenix_Proposed_Initial_Order_Discount__c"] == 0) && eventFields["Phoenix_Initial_Order_Discount_Type__c"] != 'None' && eventFields["Phoenix_Initial_Order_Discount_Type__c"] != 'Not Applicable'){
            var iodPerc=eventFields["Phoenix_Proposed_Initial_Order_Discount__c"];
            var msg;
            if(iodPerc==null || iodPerc==''){
                msg='Please Enter Proposed Initial Order Discount %';
            }else{
                msg= iodPerc < 1 ? 'Proposed Initial Order Discount % must be greater than 0' : 'Please Enter Proposed Initial Order Discount %';
            }
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "type":"error",
                "message": msg
            });
            toastEvent.fire();
        }else{
            eventFields["Phoenix_Reference_Contracts__c"] =slctCntrcts.toString(); 
            eventFields["Phoenix_Bid_Proposed_Position__c"] = component.get("v.selectedPosistions").toString();
            eventFields["Phoenix_Proposed_Position__c"] = component.get("v.selectedMCKPosistions").toString();
            console.log("slected MCKpositions-->"+component.get("v.selectedMCKPosistions").toString());
            var currentCd = eventFields["Phoenix_Current_CD__c"] ;
            var pvip=eventFields["Phoenix_Proposed_Value_Est_VIP__c"];
            if(pvip==null || pvip==undefined || pvip==''){
                eventFields["Phoenix_Proposed_Value_Est_VIP__c"]=eventFields["Phoenix_Current_Value_Est_VIP__c"];
            }
            component.find("bidForm").submit(eventFields);
            
            if(component.get("v.BidTypeVal")!='New Customer'){
                helper.getNPRDataOfContracts(component, event, helper,slctCntrcts,component.get("v.templateType"));
            }
        }
    },
    onRecordSuccess : function(component, event, helper) {
        console.log('sucess----'+event.getParam("response").id);
        component.set('v.isSpinnerLoad',true);
        console.log('after success return');
        var rebateHeader , feeHeader, marketingHeader;
        var rebatetype = component.find("headerRebateType");
        var feetype = component.find("headerFeeType");
        var marketingType = component.find("headerMarketingApproval");
        if(rebatetype != null){
            rebateHeader = rebatetype.get("v.value");
        }else{
            rebateHeader= '';
        }
        if(feetype != null){
            feeHeader = feetype.get("v.value");
        }else{
            feeHeader= '';
        }
        if(marketingType != null){
            marketingHeader = marketingType.get("v.value");
        }else{
            marketingHeader= '';
        }
        
        
        if (helper.requiredValidation(component, event)){
            var action = component.get("c.saveLineItems");
            action.setParams({
                'LineItemList': component.get("v.BidLineItemListAll"),
                'LineItemId':component.get("v.recordId"),
                'rebateHeader': rebateHeader,
                'feeHeader': feeHeader,
                'isRebateChanged': component.get("v.isRebateChanged"),
                'isFeeChanged': component.get("v.isFeeChanged"),
                'marketingHeader': marketingHeader,
                'isMarketingChanged': component.get("v.isMarketingChanged"),
                'productPositions': component.get("v.selectedPosistions").toString(),
                'productMCKPositions': component.get("v.selectedMCKPosistions").toString()
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var storeResponse = response.getReturnValue();
                    component.set("v.bidRecord",storeResponse);
                    //component.set("v.BidLineItemListAll", storeResponse);
                    component.set("v.showSaveCancelBtn",false);
                    component.set('v.isSpinnerLoad',false);
                    helper.searchProductFamilyChange(component, event,helper);
                    console.log('after success-return');
                }else{
                    component.set("v.showSaveCancelBtn",false);
                    component.set('v.isSpinnerLoad',false);
                }
                component.set("v.isRebateChanged",false);
            });
            $A.enqueueAction(action);
        }
          helper.getAllTotalValues(component, event, helper);
        // helper.searchProductFamilyChange(component, event,helper);
    },
    Save: function(component, event, helper) {
        // component.find("bidForm").submit();        
    },
    showModel: function(component, event, helper) {
        var LineItemtable = component.find("LineTable");
        console.log('modalstart---'+LineItemtable);
        $A.util.removeClass(LineItemtable, "maintable");
        component.set("v.showModal", true);
        component.set('v.mycolumns', [
            {label: 'Name', fieldName: 'Phoenix_Contract_Number__c', type: 'text'},
            {label: 'Customer', fieldName: 'Phoenix_Customer__c', type: 'text'},
            {label: 'Internal Description', fieldName: 'Phoenix_Contract_Internal_Description__c', type: 'text'},
            {label: 'External Description', fieldName: 'Phoenix_Contract_External_Description__c', type: 'Text'}
        ]); 
        var searchInput=component.find("cntInput").get("v.value");
        console.log('--searchInput--'+searchInput);
        var bidCustomer=component.get("v.customerId");
        console.log('--bidCustomer--'+bidCustomer);
        if(bidCustomer!=null && bidCustomer!=undefined){
            helper.fetchContratcs(component, event,helper,bidCustomer,searchInput);
        } else{
            component.set("v.contratcsList",null);
        }      
    },   
    searchContracts : function(component, event, helper) {
        var searchInput=component.find("cntInput").get("v.value");
        console.log('searchInput---'+searchInput);
        var checkToggle=component.find("tgleCntrct").get("v.checked");            
        var bidCustomer=component.get("v.customerId");
        console.log('--bidCustomer--'+bidCustomer); 
        if(checkToggle==true){
            helper.fetchContratcs(component, event,helper,null,searchInput);
        }
        else{
            if(bidCustomer!=null && bidCustomer!=undefined){
                helper.fetchContratcs(component, event,helper,bidCustomer,searchInput);
            }else{
                component.set("v.contratcsList",null);
            }
        }
        /* if(checkToggle==true && bidCustomer!=null && bidCustomer!=undefined){
            helper.fetchContratcs(component, event,helper,bidCustomer,searchInput);
        }
        else if(checkToggle==true && (bidCustomer==null ||  bidCustomer==undefined)){
            component.set("v.contratcsList",null);
        }else{
            helper.fetchContratcs(component, event,helper,null,searchInput);
        }*/
        
    },    
    saveDetails : function(component, event, helper) {
        var selectrcs=component.find('linesTable').getSelectedRows(); 
        var selectedCntrcts=component.get("v.selectedCntrcts");
        for(var i=0;i<selectrcs.length;i++){
            selectedCntrcts.push(selectrcs[i].Phoenix_Contract_Number__c);
        }    
        component.set("v.selectedCntrcts",selectedCntrcts);
        component.set("v.showModal", false);
        var LineItemtable = component.find("LineTable");
        $A.util.addClass(LineItemtable, "maintable");
        component.set("v.showSaveCancelBtn",true);
        //helper.getNPRDataOfContracts(component, event, helper,selectrcs);
    },
    clearCntract :function(component,event,heplper){
        var selectedPillId = event.getSource().get("v.name");
        var AllPillsList = component.get("v.selectedCntrcts"); 
        
        for(var i = 0; i < AllPillsList.length; i++){
            if(AllPillsList[i] == selectedPillId){
                AllPillsList.splice(i, 1);
                component.set("v.selectedCntrcts", AllPillsList);
            }  
        } 
        component.set("v.showSaveCancelBtn",true);
    },    
    hideModel: function(component, event, helper) {
        component.set("v.showModal", false);
        var LineItemtable = component.find("LineTable");
        $A.util.addClass(LineItemtable, "maintable");
    },    
    cancel : function(component,event,helper){
        $A.get('e.force:refreshView').fire();
    },
    showSaveCancel : function(component,event,helper){
        component.set("v.showSaveCancelBtn",true);
    },
    SaveAndNavigate:  function(component,event,helper){
        $A.enqueueAction(component.get('c.onRecordSubmit'));
        component.find("navigationService").navigate({
            type: "standard__recordPage",
            attributes: {
                recordId: component.get("v.recordId"),
                actionName: "view"
            }
        }, false);       
    },
    handleEvent: function(component, event, helper) {
        component.set('v.isSpinnerLoad',true);       
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
        window.setTimeout(
            $A.getCallback(function() {
                helper.getAllTotalValues(component, event, helper);
            }), 2000
        ); 
    },
    searchProFamilyChange: function(component, event,helper) {
        
        helper.searchProductFamilyChange(component, event,helper);
    },  
    onblur : function(component,event,helper){
        // on mouse leave clear the listOfSeachRecords & hide the search result component 
        component.set("v.listOfSearchRecords", null );
        component.set("v.SearchKeyWord", '');
        var forclose = component.find("searchRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
    },
    onfocus : function(component,event,helper){
        // show the spinner,show child search result component and call helper function
        $A.util.addClass(component.find("mySpinner"), "slds-show");
        component.set("v.listOfSearchRecords", null ); 
        var forOpen = component.find("searchRes");
        $A.util.addClass(forOpen, 'slds-is-open');
        $A.util.removeClass(forOpen, 'slds-is-close');
        // Get Default 5 Records order by createdDate DESC 
        var getInputkeyWord = '';
        helper.searchHelper(component,event,getInputkeyWord);
    },    
    keyPressController : function(component, event, helper) {
        $A.util.addClass(component.find("mySpinner"), "slds-show");
        // get the search Input keyword   
        var getInputkeyWord = component.get("v.SearchKeyWord");
        // check if getInputKeyWord size id more then 0 then open the lookup result List and 
        // call the helper 
        // else close the lookup result List part.   
        if(getInputkeyWord.length > 0){
            var forOpen = component.find("searchRes");
            $A.util.addClass(forOpen, 'slds-is-open');
            $A.util.removeClass(forOpen, 'slds-is-close');
            helper.searchHelper(component,event,getInputkeyWord);
        }
        else{  
            component.set("v.listOfSearchRecords", null ); 
            var forclose = component.find("searchRes");
            $A.util.addClass(forclose, 'slds-is-close');
            $A.util.removeClass(forclose, 'slds-is-open');
        }
    },    
    // function for clear the Record Selaction 
    clear :function(component,event,heplper){
        var selectedPillId = event.getSource().get("v.name");
        var AllPillsList = component.get("v.lstSelectedRecords"); 
        
        for(var i = 0; i < AllPillsList.length; i++){
            if(AllPillsList[i] == selectedPillId){
                AllPillsList.splice(i, 1);
                component.set("v.lstSelectedRecords", AllPillsList);
            }  
        }
        component.set("v.SearchKeyWord",null);
        component.set("v.listOfSearchRecords", null );      
    },    
    // This function call when the end User Select any record from the result list.   
    handleComponentEvent : function(component, event, helper) {
        component.set("v.SearchKeyWord",null);
        // get the selected object record from the COMPONENT event 	 
        var listSelectedItems =  component.get("v.lstSelectedRecords");
        var selectedAccountGetFromEvent = event.getParam("recordByEvent");
        console.log('selectedAccountGetFromEvent---'+selectedAccountGetFromEvent);
        listSelectedItems.push(selectedAccountGetFromEvent);
        component.set("v.lstSelectedRecords" , listSelectedItems); 
        
        var forclose = component.find("lookup-pill");
        $A.util.addClass(forclose, 'slds-show');
        $A.util.removeClass(forclose, 'slds-hide');
        
        var forclose = component.find("searchRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open'); 
    },
    onblurProDir : function(component,event,helper){
        // on mouse leave clear the listOfSeachRecords & hide the search result component
        var toggleclass = component.find("zvalue");      
        $A.util.addClass(toggleclass, "zindex"); 
        var toggleclasspkg = component.find("zvaluePkg");      
        $A.util.addClass(toggleclasspkg, "zindexPkg");
        var toggleclassPrd = component.find("zvaluePrd");      
        $A.util.addClass(toggleclassPrd, "zindexPrd");
        component.set("v.listOfSearchPDRecords", null );
        component.set("v.SearchKeyWordPD", '');
        var forclose = component.find("searchResPD");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
    },
    onfocusProdDir : function(component,event,helper){       
        // show the spinner,show child search result component and call helper function
        /* $A.util.addClass(component.find("mySpinner"), "slds-show");
        component.set("v.listOfSearchPDRecords", null ); 
        var forOpen = component.find("searchResPD");
        $A.util.addClass(forOpen, 'slds-is-open');
        $A.util.removeClass(forOpen, 'slds-is-close');
        // Get Default 5 Records order by createdDate DESC 
        var getInputkeyWord = '';
        helper.searchHelperProdDir(component,event,getInputkeyWord);*/
    },    
    keyPressControllerProdDir : function(component, event, helper) {
        var toggleclass = component.find("zvalue");      
        $A.util.removeClass(toggleclass, "zindex");
        var toggleclasspkg = component.find("zvaluePkg");      
        $A.util.removeClass(toggleclasspkg, "zindexPkg");
        var toggleclassPrd = component.find("zvaluePrd");      
        $A.util.removeClass(toggleclassPrd, "zindexPrd");
        $A.util.addClass(component.find("mySpinner"), "slds-show");
        // get the search Input keyword   
        var getInputkeyWord = component.get("v.SearchKeyWordPD");
        // check if getInputKeyWord size id more then 0 then open the lookup result List and 
        // call the helper 
        // else close the lookup result List part.   
        if(getInputkeyWord.length > 0){
            var forOpen = component.find("searchResPD");
            $A.util.addClass(forOpen, 'slds-is-open');
            $A.util.removeClass(forOpen, 'slds-is-close');
            helper.searchHelperProdDir(component,event,getInputkeyWord);
        }
        else{  
            component.set("v.listOfSearchPDRecords", null ); 
            var forclose = component.find("searchResPD");
            $A.util.addClass(forclose, 'slds-is-close');
            $A.util.removeClass(forclose, 'slds-is-open');
        }
    },    
    // function for clear the Record Selaction 
    clearProdDir :function(component,event,heplper){
        var selectedPillId = event.getSource().get("v.name");
        var AllPillsList = component.get("v.lstSelectedPDRecords"); 
        
        for(var i = 0; i < AllPillsList.length; i++){
            if(AllPillsList[i] == selectedPillId){
                AllPillsList.splice(i, 1);
                component.set("v.lstSelectedPDRecords", AllPillsList);
            }  
        }
        component.set("v.SearchKeyWordPD",null);
        component.set("v.listOfSearchPDRecords", null );      
    }, 
    // This function call when the end User Select any record from the result list.   
    handleComponentEventProdDir : function(component, event, helper) {
        component.set("v.SearchKeyWordPD",null);
        // get the selected object record from the COMPONENT event 	 
        var listSelectedItems =  component.get("v.lstSelectedPDRecords");
        var selectedAccountGetFromEvent = event.getParam("PDrecordByEvent");       
        listSelectedItems.push(selectedAccountGetFromEvent);
        component.set("v.lstSelectedPDRecords" , listSelectedItems); 
        
        var forclose = component.find("lookup-pill-PD");
        $A.util.addClass(forclose, 'slds-show');
        $A.util.removeClass(forclose, 'slds-hide');
        
        var forclose = component.find("searchResPD");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open'); 
    },
    searchSrxRxOttc : function(component,event,helper){
        var picliList = component.get('v.RxSrxList');        
        if(component.get("v.isRxChecked") && !picliList.includes('Rx')){
            console.log('I am Rx')
            picliList.push('Rx');
        }
        if(component.get("v.isSRxChecked") && !picliList.includes('SRx')){
            picliList.push('SRx');
        }
        if(component.get("v.isOtcChecked") && !picliList.includes('OTC')){
            picliList.push('OTC');
        }
        if(component.get("v.isRxChecked") == false && picliList.includes('Rx')){
            var ind = picliList.indexOf('Rx')
            picliList.splice(ind, 1);
        }
        if(component.get("v.isSRxChecked") == false && picliList.includes('SRx')){
            var ind = picliList.indexOf('SRx')
            picliList.splice(ind, 1);
        }
        if(component.get("v.isOtcChecked") == false && picliList.includes('OTC')){
            var ind = picliList.indexOf('OTC')
            picliList.splice(ind, 1);
        }
        component.set("v.RxSrxList",picliList);
        console.log('picliList----->'+picliList);
    },
    searchSRxOtc : function(component,event,helper){
        if(component.get("v.RxSrxList").length > 0 ){
            var action = component.get("c.findBySrxOtc");
            action.setParams({
                "searchKey": component.get("v.RxSrxList"),
                "lineItemId" : component.get("v.recordId")
            });
            action.setCallback(this, function(a) {
                var lineItemsList =a.getReturnValue();
                component.set("v.BidLineItemListAll", lineItemsList);
                var OutDiv = component.find("mainDiv");
                if(lineItemsList.length<10){
                    console.log('--no-hight---');
                    $A.util.addClass(OutDiv, "noheightClass");
                }else{
                    console.log('---hight---');
                    $A.util.removeClass(OutDiv, "noheightClass");
                }
            });
            $A.enqueueAction(action);
        }else{
            $A.enqueueAction(component.get('c.initRecords'));
        }
    },
    onRebateChange: function(component,event, helper){
        component.set("v.showSaveCancelBtn",true);
        component.set("v.isRebateChanged",true);
    },
    onFeeChange:  function(component,event, helper){
        component.set("v.showSaveCancelBtn",true);
        component.set("v.isFeeChanged",true);
    },
    onMarketingChange :function(component,event, helper){
        component.set("v.showSaveCancelBtn",true);
        component.set("v.isMarketingChanged",true);
    },
    downloadCsv : function(component,event,helper){    
        var action = component.get("c.getupdatedforExport");
        action.setParams({
            "bidId" : component.get("v.recordId")
        });
        action.setCallback(this, function(a) {
            var isReBid=component.get("v.isReBid");
            console.log('isReBid--->'+isReBid);
            var ResultData =a.getReturnValue();        
            var template=component.get("v.templateType");
            var bidNumber=component.get("v.bidNumber");
            var bidName=component.get("v.bidName");
            var bidType=component.get("v.BidTypeVal");
            var isScmapproved=false;
            // call the helper function which "return" the CSV data as a String   
            if(component.get("v.BidLineItemListAll") != null && component.get("v.BidLineItemListAll").length > 0)
            {
                 isScmapproved = component.get("v.BidLineItemListAll")[0].Phoenix_SCM_Final_Approval__c;
            }
            var csv = helper.convertArrayOfObjectsToCSV(component,ResultData,template,bidType,isReBid,isScmapproved);   
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
            hiddenElement.download = 'Rejected View'+'-'+bidNumber+'-'+bidName+'-'+Now+'.csv';  // CSV file Name* you can change it.[only name not .csv] 
            document.body.appendChild(hiddenElement); // Required for FireFox browser
            hiddenElement.click(); // using click() js function to download csv file
        });
        $A.enqueueAction(action);
    },
    saveToProceed :function(component,event,helper){
        var isContracts=false;
        helper.submitForProceed(component,event,helper,isContracts);
    },
    saveToProceedContracts : function(component,event,helper){
        var isContracts=true;
        helper.submitForProceed(component,event,helper,isContracts);
    },
     /*Product Position Logic*/
    showProductPositionModel: function (component, event, helper) {
        var LineItemtable = component.find("LineTable");
        console.log('modalstart---' + LineItemtable);
        $A.util.removeClass(LineItemtable, "maintable");
        component.set("v.showPositionsModal", true);
        component.set('v.positionColumns', [{
                label: 'Name',
                fieldName: 'Name',
                type: 'text'
            },
            {
                label: 'Customer',
                fieldName: 'Phoenix_Customer__c',
                type: 'text'
            },
            {
                label: 'Group Name',
                fieldName: 'Phoenix_Group_Name__c',
                type: 'text'
            },
            {
                label: 'Position Comments',
                fieldName: 'Phoenix_Position_Comments__c',
                type: 'Text'
            }
        ]);
        // var searchInput=component.find("cntInput").get("v.value");
        // console.log('--searchInput--'+searchInput);
        var bidCustomer = component.get("v.customerId");
        console.log('--bidCustomer--' + bidCustomer);
        if (bidCustomer != null && bidCustomer != undefined) {
            helper.fetchPositions(component, event, helper, bidCustomer);
        } else {
            component.set("v.positionsList", null);
        }
    },
    showMCKProductPositionModel: function (component, event, helper) {
        var LineItemtable = component.find("LineTable");
        console.log('modalstart---' + LineItemtable);
        $A.util.removeClass(LineItemtable, "maintable");
        component.set("v.showMCKPositionsModal", true);
        component.set('v.MCKpositionColumns', [{
                label: 'Name',
                fieldName: 'Name',
                type: 'text'
            },
            {
                label: 'Customer',
                fieldName: 'Phoenix_Customer__c',
                type: 'text'
            },
            {
                label: 'Group Name',
                fieldName: 'Phoenix_Group_Name__c',
                type: 'text'
            },
            {
                label: 'Position Comments',
                fieldName: 'Phoenix_Position_Comments__c',
                type: 'Text'
            }
        ]);
        // var searchInput=component.find("cntInput").get("v.value");
        // console.log('--searchInput--'+searchInput);
        var bidCustomer = component.get("v.customerId");
        console.log('--bidCustomer--' + bidCustomer);
        if (bidCustomer != null && bidCustomer != undefined) {
            helper.fetchMCKPositions(component, event, helper, bidCustomer);
        } else {
            component.set("v.MCKpositionsList", null);
        }
    },
   
    savePosDetails: function (component, event, helper) {
        var selectrcs = component.find('PoslinesTable').getSelectedRows();
        var selectedCntrcts = component.get("v.selectedPosistions");
        for (var i = 0; i < selectrcs.length; i++) {
            selectedCntrcts.push(selectrcs[i].Name);
        }
        component.set("v.selectedPosistions", selectedCntrcts);
        component.set("v.showPositionsModal", false);
        var LineItemtable = component.find("LineTable");
        $A.util.addClass(LineItemtable, "maintable");
        component.set("v.showSaveCancelBtn", true);
        //helper.getNPRDataOfContracts(component, event, helper,selectrcs);
    },
     saveMCKPosDetails: function (component, event, helper) {
        var selectrcs = component.find('PoslinesMCKTable').getSelectedRows();
        var selectedCntrcts = component.get("v.selectedMCKPosistions");
        for (var i = 0; i < selectrcs.length; i++) {
            selectedCntrcts.push(selectrcs[i].Name);
        }
        component.set("v.selectedMCKPosistions", selectedCntrcts);
        component.set("v.showMCKPositionsModal", false);
        var LineItemtable = component.find("LineTable");
        $A.util.addClass(LineItemtable, "maintable");
        component.set("v.showSaveCancelBtn", true);
        //helper.getNPRDataOfContracts(component, event, helper,selectrcs);
    },
     clearPosition: function (component, event, heplper) {
        var selectedPillId = event.getSource().get("v.name");
        var AllPillsList = component.get("v.selectedPosistions");

        for (var i = 0; i < AllPillsList.length; i++) {
            if (AllPillsList[i] == selectedPillId) {
                AllPillsList.splice(i, 1);
                component.set("v.selectedPosistions", AllPillsList);
            }
        }
        component.set("v.showSaveCancelBtn", true);
    },
    clearMCKPosition: function (component, event, heplper) {
        var selectedPillId = event.getSource().get("v.name");
        var AllPillsList = component.get("v.selectedMCKPosistions");

        for (var i = 0; i < AllPillsList.length; i++) {
            if (AllPillsList[i] == selectedPillId) {
                AllPillsList.splice(i, 1);
                component.set("v.selectedMCKPosistions", AllPillsList);
            }
        }
        component.set("v.showSaveCancelBtn", true);
    },
    hideModel: function(component, event, helper) {
        component.set("v.showModal", false);
        component.set("v.showPositionsModal", false);
        component.set("v.showMCKPositionsModal", false);
        var LineItemtable = component.find("LineTable");
        $A.util.addClass(LineItemtable, "maintable");
    },    

 /*Product Position Logic*/  
    
})