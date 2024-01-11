({
    getAllContractsList: function(component, event, helper){
        component.set("v.isShowProducts",false);
        component.set('v.isSpinnerLoad',true);
        component.set("v.loadingMessage",'Loading Contracts...');
        //var message = event.getParam("message");
        console.log('bCustomerId::'+component.get("v.customerLkp"));
        var templateType = component.get("v.templateType");
        var action = component.get("c.getContracts");
        var searchInput = '';
        action.setParams({
            customerID: component.get("v.customerLkp"),
            searchInput: searchInput,
            templateType:component.get("v.AccTemplate")
        });
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                var responseList = response.getReturnValue();
                var selectedContId = component.get('v.selectedContId');
                var resList = [];
                for (var i = 0; i < responseList.length; i++) {
                    var rec = responseList[i]
                    if (selectedContId.includes(rec.Id)) {
                        rec.isChecked = true;
                    }
                    resList.push(rec);
                }
                component.set('v.allDataCV', resList);
                component.set('v.filteredData', resList);
                component.set('v.isSpinnerLoad',false);
                component.set('v.isShowUploadedProducts',false);
                component.set("v.showContracts",true);
                
            }
        });
        $A.enqueueAction(action);
    },
    getRecordTypeIds: function (component, event, helper) {
        var action = component.get("c.getRecordTypeDetails");
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.recordTypesValues", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    loadInstance: function (component, helper) {
        component.set('v.isSpinnerLoad', false);
        component.set('v.fileList', []);
        component.set("v.custReadonly", false);
        let pageReference = component.get("v.pageReference");
        let recordId = pageReference.state.c__recordId != undefined ? pageReference.state.c__recordId : component.get("v.recordId");
        
        if(component.get("v.isFromAnalysis")){
            var action = component.get("c.getProdListWithIds");
            action.setParams({
                prodIds : component.get("v.selectedNdcs"),
                accId:component.get("v.customerLkp")
            });
            action.setCallback(this, function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    component.set('v.loading', false);
                    console.log('optyList ---> '+JSON.stringify(response.getReturnValue()));
                    component.set("v.optyProdList",response.getReturnValue());
                    var optyName = component.get("v.name");
                    if(optyName.includes('Red Oak Sourcing')){
                        component.set("v.isRosCustomer",true);
                        component.set("v.customerLkp",'');
                    }
                }
                else if (state === "ERROR") {
                    console.log("Error: "+JSON.stringify(response.getError()));
                }
            });
            $A.enqueueAction(action);
        }
        else if(component.get("v.isBidClone")){
            var action = component.get("c.getProdListForBidClone");
            action.setParams({
                prodIds : component.get("v.selectedNdcs"),
                bidId:component.get("v.oldBidId")
            });
            action.setCallback(this, function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    component.set('v.loading', false);
                    component.set("v.optyProdList",response.getReturnValue());
                    var optyName = component.get("v.name");
                    if(optyName.includes('Red Oak Sourcing')){
                        component.set("v.isRosCustomer",true);
                        component.set("v.customerLkp",'');
                    }
                }
                else if (state === "ERROR") {
                    console.log("Error from getProdListForBidClone: "+JSON.stringify(response.getError()));
                }
            });
            $A.enqueueAction(action);
        }
        if (recordId != null && recordId != undefined && recordId != '') {
            component.set("v.recordId", recordId);
            component.set("v.isCreate", false);
            
            var action = component.get("c.getoptyInfo");
            action.setParams({
                "recordId": recordId
            });
            action.setCallback(this, function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    component.set('v.loading', false);
                    console.log('inside getOptyInfo');
                    var wrapperObject = response.getReturnValue();
                    var aprovalStatus = wrapperObject.opty.Phoenix_Approval_Status__c;
                    //if (aprovalStatus != null && aprovalStatus != 'Draft') {
                    //   component.set("v.bidSubmitted", true);
                    //} else {
                    //  component.set("v.bidSubmitted", false);
                    //}
                    if (wrapperObject.opty.Bid_Type__c != undefined && wrapperObject.opty.Bid_Type__c != null) {
                        component.set("v.BidType", wrapperObject.opty.Bid_Type__c);
                    }
                    console.log('wrapperObject.opty.AccountId :: --> '+wrapperObject.opty.AccountId);
                    console.log('wrapperObject.opty.Contact__c :: --> '+wrapperObject.opty.Contact__c);
                    console.log('wrapperObject.opty.Vision_Opportunity_Source__c :: --> '+wrapperObject.opty.Vision_Opportunity_Source__c);
                    component.set("v.WrapperObect", wrapperObject);
                    component.set("v.hasLines", wrapperObject.hasLines);
                    component.set("v.bidCreated", wrapperObject.optyCreated);
                    var isCreate = component.get("v.isCreate");
                    var bidtypeVal = component.get("v.BidType");
                    component.set("v.optyObj",wrapperObject.opty);
                    component.set("v.name", wrapperObject.opty.Name);
                    component.set("v.source", wrapperObject.opty.Vision_Opportunity_Source__c);
                    component.find("optySourceInput").set("v.value", wrapperObject.opty.Vision_Opportunity_Source__c);
                    component.set("v.type", wrapperObject.opty.Vision_Type__c);
                    component.set("v.stage", wrapperObject.opty.StageName);
                    //component.set("v.customerName", wrapperObject.opty.AccountId);
                    //component.set("v.contactName", wrapperObject.opty.Contact__c);
                    component.set("v.bidTypeFromForm", wrapperObject.opty.Bid_Type__c);
                    component.set("v.internalTargetDate", wrapperObject.opty.Vision_Internal_Closing_Date__c);
                    component.set("v.customerDeadlineDate", wrapperObject.opty.Vision_Customer_Closing_Date__c);
                    component.set("v.comments", wrapperObject.opty.Vision_Comments__c);
                    component.set("v.notes", wrapperObject.opty.Vision_Notes__c);
                    //component.set("v.customerLkp", wrapperObject.opty.AccountId);
                    //component.set("v.cntcLkp",wrapperObject.opty.Contact__c);
                    // assign account val
                    component.set("v.customerName", wrapperObject.opty.AccountId);
                    component.find("customerLookup").fireChanging();
                    // assign contact val
                    component.set("v.contactName", wrapperObject.opty.Contact__c);
                    component.find("contactLookup").fireChanging();
                    
                    /*if (wrapperObject.opty.Phoenix_Customer_Type__c != undefined && wrapperObject.opty.Phoenix_Customer_Type__c != null) {
                    component.set("v.BidTemplate", wrapperObject.opty.Phoenix_Customer_Type__c);
                }
                if (bidtypeVal == 'IPA Floor Pricing Update' || bidtypeVal == 'Mass Product Removals' 
                    || bidtypeVal == 'Product Discontinuation Process' || bidtypeVal == 'SRx IPA Price Change' 
                    || bidtypeVal == 'SRx IPA Product Addition' || bidtypeVal == 'RCA/IPA Member GPO or Wholesaler Change' 
                    || bidtypeVal == 'WAC Change Submissions' || bidtypeVal == 'Direct Order Form Pricing Update' 
                    || bidtypeVal == 'RCA Member Addition' || bidtypeVal == 'IPA Member Addition') {
                    component.set("v.NoCustContact", false);
                } else {
                    component.set("v.NoCustContact", true);
                }
                if (bidtypeVal == 'SRx IPA Product Addition' || bidtypeVal == 'SRx IPA Price Change' 
                    || bidtypeVal == 'RCA Member Addition' || bidtypeVal == 'IPA Member Addition' 
                    || bidtypeVal == 'Direct Order Form Pricing Update' || bidtypeVal == 'IPA Floor Pricing Update'
                    || bidtypeVal == 'RCA/IPA Member GPO or Wholesaler Change' || bidtypeVal == 'WAC Change Submissions' 
                    || bidtypeVal == 'Product Discontinuation Process' || bidtypeVal == 'Mass Product Removals') {
                    component.set("v.deadLineValue", false);
                } else {
                    component.set("v.deadLineValue", true);
                }
                if (bidtypeVal == 'Direct Order Form Pricing Update' || bidtypeVal == 'WAC Change Submissions' 
                    || bidtypeVal == 'RCA Member Addition' || bidtypeVal == 'IPA Member Addition' 
                    || bidtypeVal == 'RCA/IPA Member GPO or Wholesaler Change' || bidtypeVal == 'SRx IPA Price Change' 
                    || bidtypeVal == 'SRx IPA Product Addition' || bidtypeVal == 'IPA Floor Pricing Update' 
                    || bidtypeVal == 'Product Discontinuation Process' || bidtypeVal == 'Mass Product Removals') {
                    component.set("v.hasInternalDate", true);
                } else {
                    component.set("v.hasInternalDate", false);
                }


                if (bidtypeVal != undefined && component.find("contractLookup") != null) {
                    component.find("contractLookup").fireChanging(wrapperObject.opty.Phoenix_RCA_Agreement__c);
                    component.set("v.RcaAgreement", wrapperObject.opty.Phoenix_RCA_Agreement__c);

                }
                if (bidtypeVal != undefined && component.find("contactLookup") != null) {
                    component.set("v.customerRecord", wrapperObject.opty.Phoenix_Customer__c);
                    component.find("contactLookup").fireChanging(wrapperObject.opty.ContactId);
                    component.set("v.cntcLkp", wrapperObject.opty.Phoenix_Contact__c);

                }
                if (bidtypeVal != undefined && component.find("customerLookup") != null) {
                    component.set("v.customerLkp", wrapperObject.opty.AccountId);
                    component.find("customerLookup").fireChanging(wrapperObject.opty.AccountId);
                }*/
                    
                    /*  if(isCreate==true){

                      window.setTimeout(
                          $A.getCallback(function() {

                              let fieldsMap = new Map();
                              let allFields = component.find("fieldLableId");
                              var ownerId;

                              allFields.forEach(function(eachInput){

                                  fieldsMap.set(eachInput.get("v.fieldName"), eachInput);
                              });
                              if(fieldsMap.get("OwnerId")!=null && fieldsMap.get("OwnerId")!=undefined){
                                  ownerId= fieldsMap.get("OwnerId").get("v.value");
                              fieldsMap.get("Phoenix_Bid_Owner__c").set("v.value",ownerId);
                              }


                           //   var BidDeadlineTime= fieldsMap.get("Phoenix_Customer_Bid_Deadline_Date_Time__c").get("v.value");
                           //   var BidDeadlineMonth= fieldsMap.get("Phoenix_Customer_Bid_Deadline_Month__c").get("v.value");
                            //  var BidDeadlineYear= fieldsMap.get("Phoenix_Customer_Bid_Deadline_Year__c").get("v.value");
                              var BidDeadlineTimePick= fieldsMap.get("Phoenix_Customer_Bid_Deadline_Time__c").get("v.value");
                            //  var BidDeadlineDate= fieldsMap.get("Phoenix_Customer_Bid_Deadline_Date__c").get("v.value");
                           //   var TimeZone =fieldsMap.get("Phoenix_Customer_Bid_Deadline_Time_zone__c").get("v.value");
                              var bidDate =fieldsMap.get("Phoenix_Bid_Deadline_Date__c").get("v.value");

                              var today = new Date();
                              var dd = String(today.getDate()).padStart(2, '0');
                              var mm = String(today.getMonth() + 1).padStart(2, '0'); //January is 0!
                              var yyyy = today.getFullYear();
                              //var time = String(today.setHours(6));
                           today = yyyy + '-' + mm + '-' +dd;
                              console.log('-----------'+today);
                            /// today1=today.setTime(6);
                              const formattedDate = new Date();
                              const monthNames = ["January", "February", "March", "April", "May", "June",
                                                  "July", "August", "September", "October", "November", "Dec"
                                                 ];
                                  const d = new Date();
                           //  today = monthNames[d.getMonth()]+' '+ dd +','+' '+ yyyy;
                           // today1 = monthNames[d.getMonth()]+' '+ dd +','+' '+ yyyy;
                              console.log('-----formattedDate-----'+formattedDate);

                            //  fieldsMap.get("Phoenix_Customer_Bid_Deadline_Date__c").set("v.value",dd);
                            //  fieldsMap.get("Phoenix_Customer_Bid_Deadline_Month__c").set("v.value",monthNames[d.getMonth()]);
                          //    fieldsMap.get("Phoenix_Customer_Bid_Deadline_Year__c").set("v.value",JSON.stringify(yyyy));
                      //        fieldsMap.get("Phoenix_Customer_Bid_Deadline_Date_Time__c").set("v.value",formattedDate.toISOString());
                          fieldsMap.get("Phoenix_Bid_Deadline_Date__c").set("v.value",today);



                          }), 4000

                      );



                  }
                       */
                }
                else if (state === "INCOMPLETE") {
                    console.log("No response from server or client is offline.")
                    
                }
                    else if (state === "ERROR") {
                        console.log("Error: ");
                    }
                if ((component.get("v.hasLines") && component.get("v.NoCustContact")) 
                    || (component.get("v.isCreate") && component.get("v.BidType")) || component.get("v.bidCreated") == true) {
                    component.set("v.custReadonly", true);
                }
            });
            
            $A.enqueueAction(action);
        }
        else {
            component.set("v.recordId", null);
            component.set("v.isCreate", true);
        }
    },
    
    validateInputsHelper : function(component, event, helper){
        if(component.get("v.customerLkp") && component.get("v.name")){
            if(component.get("v.source") != null && component.get("v.internalTargetDate") != null){
                component.set("v.hideUploadButton",false);
            }
        }
        else
            component.set("v.hideUploadButton",true);
    },
    
    handleFormSubmit: function (component, event, helper) {
        
        var showValidationError = false;
        
        var vaildationFailReason = '';
        var eventFields = event.getParam("fields");
        console.log('eventFields '+JSON.stringify(eventFields));
        var inTrgtDate = eventFields["Vision_Internal_Closing_Date__c"];
        var today = new Date();
        var dd = String(today.getDate()).padStart(2, '0');
        var mm = String(today.getMonth() + 1).padStart(2, '0'); //January is 0!
        var yyyy = today.getFullYear();
        today = yyyy + '-' + mm + '-' + dd;
        
        /*if(component.find("customerLookup")!=null && component.get("v.custReadonly")==false){
            var customerlkp=component.get("v.customerLkp");

            if(customerlkp==null ||  customerlkp=='' || customerlkp==undefined){

                //  window.scroll(0,0);

                showValidationError = true;
                //vaildationFailReason = "Please select Customer Bid Deadline Time Zone";
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Warning!",
                    "message":"Please select a Customer.",
                    "type":"error"
                });
                toastEvent.fire();
            }
        }

            var inTrgtDate=eventFields["Phoenix_Internal_Target_Date__c"];
            console.log('inTrgtDate---'+inTrgtDate);
            var today = new Date();
            var dd = String(today.getDate()).padStart(2, '0');
            var mm = String(today.getMonth() + 1).padStart(2, '0'); //January is 0!
            var yyyy = today.getFullYear();
            today = yyyy + '-' + mm + '-' +dd;
            var deadLine=eventFields["Phoenix_Bid_Deadline_Date__c"];
            if(deadLine){
                console.log('deadLine--'+deadLine);
            }
        console.log('eventFields["Phoenix_Approval_Status__c"]-->'+eventFields["Phoenix_Approval_Status__c"]);
        var WrapperObect = component.get("v.WrapperObect");
        console.log('Approval Status---->'+WrapperObect.bid.Phoenix_Approval_Status__c)
            if(eventFields["Phoenix_Approval_Status__c"] == undefined && eventFields["Phoenix_Bid_Deadline_Date__c"]<today){
                showValidationError = true;
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Warning!",
                    "message":"Customer Bid Deadline Date should be greater than Today's Date",
                    "type":"error"
                });
                toastEvent.fire();
            }*/
        if (inTrgtDate < today) {
            showValidationError = true;
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Warning!",
                "message": "Internal Target Date should be greater then or equal to Today's Date",
                "type": "error"
            });
            toastEvent.fire();
        }
        else if (inTrgtDate > eventFields["Vision_Customer_Closing_Date__c"]) {
            showValidationError = true;
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Warning!",
                "message": "Customer Bid Deadline Date should be greater than Internal Target Date",
                "type": "error"
            });
            toastEvent.fire();
        }
        /*if(eventFields["Phoenix_Bid_Type__c"]=='Customer Rebate Change' &&  (component.get('v.BidTemplate')=='RXSS' || component.get('v.BidTemplate')=='Net Indirect Pricing' || component.get('v.BidTemplate')=='Sams Club')){
            showValidationError = true;
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message":"We can not create "+eventFields["Phoenix_Bid_Type__c"]+" for this customer",
                "type":"error"
            });
            toastEvent.fire();
        }
          if(eventFields["Phoenix_Bid_Type__c"]=='Sales Out Rebate'  &&  (eventFields["Phoenix_Template_Type__c"] == 'ABC Pharmagen' || component.get('v.BidTemplate')=='ABC Pharmagen' || component.get('v.BidTemplate')=='ROS' || component.get('v.BidTemplate')=='RXSS' || component.get('v.BidTemplate')=='ClarusOne' || component.get('v.BidTemplate')=='Net Indirect Pricing' || component.get('v.BidTemplate')=='Costco' || component.get('v.BidTemplate')=='Sams Club' || component.get('v.BidTemplate')=='BASE/DSH'	|| component.get('v.BidTemplate')=='Government Pricing') ){
            showValidationError = true;
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message":"We can not create "+eventFields["Phoenix_Bid_Type__c"]+" for this customer",
                "type":"error"
            });
            toastEvent.fire();
        }
        if(eventFields["Phoenix_Bid_Type__c"]=='New Customer'  &&  (eventFields["Phoenix_Template_Type__c"] == 'ABC Progen' || eventFields["Phoenix_Template_Type__c"] == 'ABC Pharmagen' || component.get('v.BidTemplate')=='ABC Pharmagen' || component.get('v.BidTemplate')=='Walgreens' || (component.get('v.BidTemplate')=='ROS' && eventFields["Phoenix_Template_Type_ROS__c"] == 'ROS') || component.get('v.BidTemplate')=='RXSS' || component.get('v.BidTemplate')=='ClarusOne' ||  component.get('v.BidTemplate')=='Costco' || component.get('v.BidTemplate')=='Sams Club'	|| component.get('v.BidTemplate')=='Government Pricing' ||  component.get('v.BidTemplate')=='Econdisc' || component.get('v.BidTemplate')=='Net Indirect Pricing' ) ){
            showValidationError = true;
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message":"We can not create "+eventFields["Phoenix_Bid_Type__c"]+" for this customer",
                "type":"error"
            });
            toastEvent.fire();
        }

        if(component.get('v.BidTemplate')==null ||component.get('v.BidTemplate')=='' ||component.get('v.BidTemplate')==undefined){


           if(eventFields["Phoenix_Bid_Type__c"]=='Customer Rebate Change'||eventFields["Phoenix_Bid_Type__c"]=='Sales Out Rebate'||eventFields["Phoenix_Bid_Type__c"]=='RFP Bids'||eventFields["Phoenix_Bid_Type__c"]=='Price Change'||eventFields["Phoenix_Bid_Type__c"]=='Product Addition'||eventFields["Phoenix_Bid_Type__c"]=='New Customer'||eventFields["Phoenix_Bid_Type__c"]=='New Product Launch'||eventFields["Phoenix_Bid_Type__c"]=='Volume Review Only'){
                   showValidationError = true;
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message":"Please assign bid template for the selected customer",
                "type":"error"
            });
            toastEvent.fire();
               }


        }

              */
        
        
        
        /* if(component.find("customerLookup")!=null){
             var customer=component.get("v.customerLkp");
             if(customer==null ||  customer=='' || customer==undefined){

                 //  window.scroll(0,0);

                 showValidationError = true;
                 //vaildationFailReason = "Please select Customer Bid Deadline Time Zone";
                 var toastEvent = $A.get("e.force:showToast");
                 toastEvent.setParams({
                     "title": "Warning!",
                     "message":"Please select a Customer",
                     "type":"error"
                 });
                 toastEvent.fire();
             }
         }*/
        event.preventDefault();
        if (!showValidationError) {
            
            var bidType = eventFields["Bid_Type__c"];
            var recordtypes = component.get("v.recordTypesValues");
            var assignRecTypeId;
            recordtypes.forEach(function (recTypeOnj) {
                if (recTypeOnj['Name'].toLowerCase() == bidType.toLowerCase()) {
                    assignRecTypeId = recTypeOnj['Id'];
                };
            });
            //eventFields["Contact__c"]=component.get("v.cntcLkp");
            if (component.get("v.custReadonly") == false) {
                //eventFields["AccountId"]=component.get("v.customerLkp");
            }
            
            // if(component.get("v.customerLkp")!=null){eventFields["Phoenix_Customer__c"]=component.get("v.customerLkp");}
            //component.find("recordEditFormForNewBid").set("v.recordTypeId",assignRecTypeId);
            component.set('v.loading', true);
            component.find("recordEditFormForNewBid").submit(eventFields);
        } else {
            //component.find('BidMessage').setError(vaildationFailReason);
            component.set('v.loading', false);
        }
        
    },
    /*Upload documnet section */
    handleUploadFinished: function (component, event, myRecordId) {
        var fileList = component.get('v.fileList');
        var contentDCIdList = [];
        for (var i = 0; i < fileList.length; i++) {
            contentDCIdList.push(fileList[i].documentId);
        }
        var action = component.get('c.createContentDCLink');
        action.setParams({
            'crId': myRecordId,
            'contentDCIdList': contentDCIdList
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var response = response.getReturnValue();
            }
        });
        $A.enqueueAction(action);
    },
    
    saveOptyLineItems: function (component, event, myRecordId) {
        var action = component.get("c.saveOptyProducts");
        var matchRecords = component.get("v.totalMatchdata");
        var unmatchRecords = component.get("v.totalUnmatchdata");
        console.log('myRecordId --> '+myRecordId);
        matchRecords.forEach(function(item){
            console.log('item.Product__c ---> '+item.Product__c);
        });
        action.setParams({
            "opportunityId": myRecordId,
            "matchData": JSON.stringify(matchRecords),
            "unmatchData": JSON.stringify(unmatchRecords)
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log("success " + response.getReturnValue());
            }
            else {
                console.log("failed " + JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);
        
    },
    /*showProducts: function (component, event, helper) {
        
        var uploadedData = component.get("v.uploadeddata");
        var matchData = component.get('v.matchdata');
        var unmatchData = component.get('v.unmatchdata');
        var arrData = [];
        var arrData2 = [];
        var i=1;
        uploadedData.forEach(function (record) {
            arrData.push(record);
            i++;
            if(i==100){
                var action = component.get("c.processProductMatching");
                action.setParams({
                    "prdOptyRecs": JSON.stringify(arrData)
                });
                action.setCallback(this, function (response) {
                    var state = response.getState();
                    if (state === "SUCCESS") {
                        //console.log('Success Resp ', response.getReturnValue());
                        var wrapperObject = JSON.parse(response.getReturnValue());
                        console.log('--Records -- '+JSON.stringify(wrapperObject.totalRecordsInfo.totalRecCount));
                        console.log('--Count Records -- '+wrapperObject.totalRecordsInfo.totalRecCount);
                        //component.set("v.TotalRecords", wrapperObject.totalRecordsInfo.totalRecCount);
                        //component.set("v.matchedRowsCount", wrapperObject.totalRecordsInfo.matchedRecCount);
                        //component.set("v.unmatchedRowsCount", wrapperObject.totalRecordsInfo.unmatchedRecCount);
                        wrapperObject.matchedRecords.forEach(function (record) {
                            record.Product__c = '/' + record.Product__c;
                            record.ProductName = record.Name;
                            matchData.push(record);
                        });
                        //component.set('v.matchdata', wrapperObject.matchedRecords);
                        //component.set('v.unmatchdata', wrapperObject.unMatchedRecords);
                        wrapperObject.unMatchedRecords.forEach(function (record) {
                            unmatchData.push(record);
                        });
                        component.set("v.TotalRecords",matchData.length + unmatchData.length);
                        component.set("v.matchedRowsCount",matchData.length);
                        component.set("v.unmatchedRowsCount",unmatchData.length);
                        component.set('v.showProductsloading', false);
                        component.set('v.isSpinnerLoad', false);
                    }
                    else {
                        component.set('v.showProductsloading', false);
                        component.set('v.isSpinnerLoad', false);
                        console.log("failed " + JSON.stringify(response.getError()));
                    }
                });
                $A.enqueueAction(action);
                arrData = [];
                arrData2 = [];
                i = 1;
            }
            else{
                arrData2.push(record);
            }
        });
        if(arrData2.length > 0){
           var action = component.get("c.processProductMatching");
                action.setParams({
                    "prdOptyRecs": JSON.stringify(arrData2)
                });
                action.setCallback(this, function (response) {
                    var state = response.getState();
                    if (state === "SUCCESS") {
                        //console.log('Success Resp ', response.getReturnValue());
                        var wrapperObject = JSON.parse(response.getReturnValue());
                        console.log('--Records -- '+JSON.stringify(wrapperObject.totalRecordsInfo.totalRecCount));
                        console.log('--Count Records -- '+wrapperObject.totalRecordsInfo.totalRecCount);
                        //component.set("v.TotalRecords", wrapperObject.totalRecordsInfo.totalRecCount);
                        //component.set("v.matchedRowsCount", wrapperObject.totalRecordsInfo.matchedRecCount);
                        //component.set("v.unmatchedRowsCount", wrapperObject.totalRecordsInfo.unmatchedRecCount);
                        wrapperObject.matchedRecords.forEach(function (record) {
                            record.Product__c = '/' + record.Product__c;
                            record.ProductName = record.Name;
                            matchData.push(record);
                        });
                        //component.set('v.matchdata', wrapperObject.matchedRecords);
                        //component.set('v.unmatchdata', wrapperObject.unMatchedRecords);
                        wrapperObject.unMatchedRecords.forEach(function (record) {
                            unmatchData.push(record);
                        });
                        component.set("v.TotalRecords",matchData.length + unmatchData.length);
                        component.set("v.matchedRowsCount",matchData.length);
                        component.set("v.unmatchedRowsCount",unmatchData.length);
                        component.set('v.showProductsloading', false);
                        component.set('v.isSpinnerLoad', false);
                    }
                    else {
                        component.set('v.showProductsloading', false);
                        component.set('v.isSpinnerLoad', false);
                        console.log("failed " + JSON.stringify(response.getError()));
                    }
                });
                $A.enqueueAction(action); 
        }

    },
    showUploadedProducts: function (component, event, helper) {
        component.set('v.showProductsloading', true);

        var fileContentId = component.get("v.fileContentId");
        var action2 = component.get("c.productCountRecords2");
        action2.setParams({
            "contentDocumentId": fileContentId
        });
        action2.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                //console.log('Success Resp ', response.getReturnValue());
                var wrapperObject = JSON.parse(response.getReturnValue());
                console.log('--Records -- '+JSON.stringify(wrapperObject));
                console.log('--Count Records -- '+wrapperObject.totalRecordsInfo.totalRecCount);
                component.set("v.TotalRecords", wrapperObject.totalRecordsInfo.totalRecCount);
                //component.set("v.unmatchedRowsCount", wrapperObject.totalRecordsInfo.unmatchedRecCount);
                component.set('v.uploadeddata', wrapperObject.unMatchedRecords);
                component.set('v.showProductsloading', false);
            }
            else {
                component.set('v.showProductsloading', false);
                console.log("failed " + JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action2);

    },
    showProducts: function (component, event, helper) {
        component.set('v.showProductsloading', true);

        var fileContentId = component.get("v.fileContentId");
        var action = component.get("c.productCountRecords");
        action.setParams({
            "contentDocumentId": fileContentId
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                //console.log('Success Resp ', response.getReturnValue());
                var wrapperObject = JSON.parse(response.getReturnValue());
                component.set("v.TotalRecords", wrapperObject.totalRecordsInfo.totalRecCount);
                component.set("v.matchedRowsCount", wrapperObject.totalRecordsInfo.matchedRecCount);
                component.set("v.unmatchedRowsCount", wrapperObject.totalRecordsInfo.unmatchedRecCount);
                wrapperObject.matchedRecords.forEach(function (record) {
                    record.Product__c = '/' + record.Product__c;
                    record.ProductName = record.Name;
                });
                component.set('v.matchdata', wrapperObject.matchedRecords);
                component.set('v.unmatchdata', wrapperObject.unMatchedRecords);
                component.set('v.showProductsloading', false);
            }
            else {
                component.set('v.showProductsloading', false);
                console.log("failed " + JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);

    },
    // saveChangeData: function (cmp, draftValues) {
    //     //console.log('<< draftValues >> ' + JSON.stringify(draftValues));
    //     console.log('saveChangeData helper called ...');
    //     var unmatchRecords = cmp.get("v.unmatchdata");
    //     console.log('draftValues >><<', JSON.stringify(draftValues));
    //     //console.log('<< unmatchRecords >> ' + JSON.stringify(unmatchRecords));
    //     for (let i = 0; i < draftValues.length; i++) {
    //         var rowVal = draftValues[i].id;
    //         //console.log('<< rowVal >> ' + JSON.stringify(rowVal));
    //         var rowNo = parseInt(rowVal.split("row-")[1]);
    //         //console.log('<< rowNo >> ' + JSON.stringify(rowNo));
    //         var draftKeys = Object.keys(draftValues[i]);
    //         //console.log('<< draftKeys >> ' + draftKeys);
    //         for (let j = 0; j < draftKeys.length; j++) {
    //             //console.log('<< draftKeydata >> ' + draftKeys[j]);
    //             if (draftKeys[j] != 'id') {
    //                 unmatchRecords[rowNo][draftKeys[j]] = draftValues[i][draftKeys[j]];
    //             }
    //         }
    //     }
    //     console.log('unMatch Data <><><><> ', JSON.stringify(unmatchRecords));
    //     console.log('Records saved');
    //     cmp.set('v.successVal', 'Record(s) Saved');
    },*/
    
    matchUploadedProducts : function(component, event, helper, offSetVal){
        var matchData = component.get('v.matchdata');
        var unmatchData = component.get('v.unmatchdata');
        var offsetMessageVal = offSetVal < component.get("v.totalData").length ? offSetVal : component.get("v.totalData").length;
        component.set("v.loadingMessage",'Matching The Uploaded Products with Our Product Master. '+offsetMessageVal+' Out of '+component.get("v.totalData").length+' ....');
        console.log('Matching The Uploaded Products with Our Product Master. '+offsetMessageVal+' Out of '+component.get("v.totalData").length+' ....');
        
        var slicedData = component.get("v.totalData").slice(offSetVal, offSetVal+100);
        var action = component.get("c.processProductMatching");
        action.setParams({
            "prdOptyRecs": JSON.stringify(slicedData),
            "accId": component.get("v.customerLkp")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var wrapperObject = JSON.parse(response.getReturnValue());
                console.log('--Count Records -- ' + wrapperObject.totalRecordsInfo.totalRecCount);
                console.log('--before matchData--'+matchData.length);
                wrapperObject.matchedRecords.forEach(function (record) {
                    //record.Product__c = //'/' + record.Product__c;
                    record.ProductName = record.Name;
                    matchData.push(record);
                });
                console.log('--after matchData--'+matchData.length);
                wrapperObject.unMatchedRecords.forEach(function (record) {
                    unmatchData.push(record);
                });
                component.set('v.matchdata', matchData);
                component.set('v.unmatchdata', unmatchData);
                component.set("v.TotalRecords", matchData.length + unmatchData.length);
                component.set("v.matchedRowsCount", matchData.length);
                component.set("v.unmatchedRowsCount", unmatchData.length);
                console.log('--If unmatchData.length--'+unmatchData.length);
                if(offSetVal < component.get("v.totalData").length)
                {
                    helper.matchUploadedProducts(component, event, helper, offSetVal+100);
                }
                else{
                    if(component.get("v.AccountNumber") == '164498'){
                    component.set('v.isShowUploadedProducts', false);
                    component.set('v.isShowProducts', false);
                    component.set('v.showSelectedProdOpty', false);
                    component.set("v.showContracts",false);
                    component.set('v.isSaveUploadProducts', true);
                    }
                    console.log('-------- Inside else condition of offset is gtN of overall Size ---------');
                    var matchDataCount = component.get("v.matchedRowsCount");
                    var noOfMatchedPages = matchDataCount/100;
                    var pageNumbers = [];
                    var j=1;
                    for(var i=0;i<noOfMatchedPages;i++){
                        pageNumbers.push(j);
                        j++;
                    }
                    component.set("v.pageNumberListMatched",pageNumbers);
                    
                    var unmatchDataCount = component.get("v.unmatchedRowsCount");
                    var noOfUnmatchedPages = unmatchDataCount/100;
                    var pageNumbersUnmat = [];
                    j=1;
                    for(var i=0;i<noOfUnmatchedPages;i++){
                        pageNumbersUnmat.push(j);
                        j++;
                    }
                    component.set("v.pageNumberListUnmatched",pageNumbersUnmat);
                    
                    component.set("v.totalMatchdata", matchData);
                    component.set("v.totalUnmatchdata", unmatchData);
                    
                    helper.paginateRecords(component,event);
                    component.set('v.isSpinnerLoad', false);
                    component.set("v.showProductsloading",false);
                }
            }
            else {
                component.set('v.showProductsloading', false);
                component.set('v.isSpinnerLoad', false);
                console.log("failed " + JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);
    },
    
    showProducts: function (component, event, helper) {
        var uploadedData = component.get("v.totalData");
        console.log('--uploadedData.length--'+uploadedData.length);
        var matchData = component.get('v.matchdata');
        var unmatchData = component.get('v.unmatchdata');
        var arrData = [];
        var arrData2 = [];
        var i = 1;
        var totalRecProcessed = 0;
        uploadedData.forEach(function (record) {
            arrData.push(record);
            i++;
            totalRecProcessed++;
            if (i == 100 || totalRecProcessed == uploadedData.length) {
                var action = component.get("c.processProductMatching");
                action.setParams({
                    "prdOptyRecs": JSON.stringify(arrData)
                });
                action.setCallback(this, function (response) {
                    var state = response.getState();
                    if (state === "SUCCESS") {
                        //console.log('Success Resp ', response.getReturnValue());
                        var wrapperObject = JSON.parse(response.getReturnValue());
                        console.log('--Count Records -- ' + wrapperObject.totalRecordsInfo.totalRecCount);
                        //component.set("v.TotalRecords", wrapperObject.totalRecordsInfo.totalRecCount);
                        //component.set("v.matchedRowsCount", wrapperObject.totalRecordsInfo.matchedRecCount);
                        //component.set("v.unmatchedRowsCount", wrapperObject.totalRecordsInfo.unmatchedRecCount);
                        console.log('--before matchData--'+matchData.length);
                        wrapperObject.matchedRecords.forEach(function (record) {
                            //record.Product__c = '/' + record.Product__c;
                            record.ProductName = record.Name;
                            matchData.push(record);
                        });
                        console.log('--after matchData--'+matchData.length);
                        //component.set('v.matchdata', wrapperObject.matchedRecords);
                        //component.set('v.unmatchdata', wrapperObject.unMatchedRecords);
                        wrapperObject.unMatchedRecords.forEach(function (record) {
                            unmatchData.push(record);
                        });
                        component.set("v.TotalRecords", matchData.length + unmatchData.length);
                        component.set("v.matchedRowsCount", matchData.length);
                        component.set("v.unmatchedRowsCount", unmatchData.length);
                        console.log('--If unmatchData.length--'+unmatchData.length);
                        component.set('v.showProductsloading', false);
                        if(totalRecProcessed == uploadedData.length)
                        {
                            console.log('--calling Pagination--');
                            window.postMessage('reloadPaginationGenerator',window.origin); 
                        }
                    }
                    else {
                        component.set('v.showProductsloading', false);
                        component.set('v.isSpinnerLoad', false);
                        console.log("failed " + JSON.stringify(response.getError()));
                    }
                });
                $A.enqueueAction(action);
                arrData = [];
                arrData2 = [];
                i = 1;
            }
            /*else {
            arrData2.push(record);
            console.log('--arrData2.length--'+arrData2.length);
            if(totalRecProcessed == uploadedData.length)
            {
                console.log('--calling reloadLeftOverRecs--');
                window.postMessage('reloadLeftOverRecs',window.origin); 
            }
        }*/
            console.log('--totalRecProcessed--'+totalRecProcessed+'--uploadedData.length--'+uploadedData.length);
        });
        
        /* window.addEventListener('message', (event) => {
            if(event.data === 'reloadPaginationGenerator'){
            var matchDataCount = component.get("v.matchedRowsCount");
            console.log('matchedRowsCount -->'+matchDataCount);
            var noOfMatchedPages = matchDataCount/100;
            console.log('noOfMatchedPages -->'+noOfMatchedPages);
            var pageNumbers = [];
            var j=1;
            for(var i=0;i<noOfMatchedPages;i++){
            pageNumbers.push(j);
            j++;
        }
                                component.set("v.pageNumberListMatched",pageNumbers);
        
        var unmatchDataCount = component.get("v.unmatchedRowsCount");
        console.log('unmatchedRowsCount -->'+unmatchDataCount);
        var noOfUnmatchedPages = unmatchDataCount/100;
        console.log('noOfUnmatchedPages -->'+noOfUnmatchedPages);
        var pageNumbersUnmat = [];
        j=1;
        for(var i=0;i<noOfUnmatchedPages;i++){
            pageNumbersUnmat.push(j);
            j++;
        }
        component.set("v.pageNumberListUnmatched",pageNumbersUnmat);
        
        component.set("v.totalMatchdata", matchData);
        component.set("v.totalUnmatchdata", unmatchData);
        
        helper.paginateRecords(component,event);
        component.set('v.isSpinnerLoad', false);
        component.set("v.showProductsloading",false);
    }
},false); */
        //component.set('v.showProductsloading', false);
        //component.set('v.isShowProducts', true);
        
        /*var fileContentId = component.get("v.fileContentId");
    var action = component.get("c.productCountRecords");
    action.setParams({
        "contentDocumentId": fileContentId
    });
    action.setCallback(this, function (response) {
        var state = response.getState();
        if (state === "SUCCESS") {
            //console.log('Success Resp ', response.getReturnValue());
            var wrapperObject = JSON.parse(response.getReturnValue());
            console.log('--Count Records -- '+wrapperObject.totalRecordsInfo.totalRecCount);
            component.set("v.TotalRecords", wrapperObject.totalRecordsInfo.totalRecCount);
            component.set("v.matchedRowsCount", wrapperObject.totalRecordsInfo.matchedRecCount);
            component.set("v.unmatchedRowsCount", wrapperObject.totalRecordsInfo.unmatchedRecCount);
            wrapperObject.matchedRecords.forEach(function (record) {
                record.Product__c = '/' + record.Product__c;
                record.ProductName = record.Name;
            });
            component.set('v.matchdata', wrapperObject.matchedRecords);
            component.set('v.unmatchdata', wrapperObject.unMatchedRecords);
            component.set('v.showProductsloading', false);
        }
        else {
            component.set('v.showProductsloading', false);
            console.log("failed " + JSON.stringify(response.getError()));
        }
    });
    $A.enqueueAction(action);*/
        
    },
    processedDataFormation : function(component, event, helper, matchData, unmatchData){
        console.log('INSIDE processedDataFormation');
        var matchDataCount = matchData.length;
        var unmatchDataCount = unmatchData.length;
        console.log('matched data size :: '+matchDataCount);
        console.log('unmatchData data size :: '+unmatchDataCount);
        component.set("v.TotalRecords", matchDataCount + unmatchDataCount);
        component.set("v.matchedRowsCount", matchDataCount);
        component.set("v.unmatchedRowsCount", unmatchDataCount);
        var noOfMatchedPages = matchDataCount/100;
        var pageNumbers = [];
        var j=1;
        for(var i=0;i<noOfMatchedPages;i++){
            pageNumbers.push(j);
            j++;
        }
        component.set("v.pageNumberListMatched",pageNumbers);
        var noOfUnmatchedPages = unmatchDataCount/100;
        var pageNumbersUnmat = [];
        j=1;
        for(var i=0;i<noOfUnmatchedPages;i++){
            pageNumbersUnmat.push(j);
            j++;
        }
        component.set("v.pageNumberListUnmatched",pageNumbersUnmat);
        
        component.set("v.totalMatchdata", matchData);
        component.set("v.totalUnmatchdata", unmatchData);
        
        helper.paginateRecords(component,event);
        
        component.set('v.isSpinnerLoad', false);
        component.set('v.showProductsloading', false);
        component.set('v.isShowProducts', true);
    },
    
    showUploadedProducts: function (component, event, helper) {
        component.set('v.showProductsloading', true);
        
        var fileContentId = component.get("v.fileContentId");
        console.log('my written text'+fileContentId);
        var action2 = component.get("c.productCountRecords2");
        action2.setParams({
            "contentDocumentId": fileContentId
        });
        action2.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var wrapperObject = JSON.parse(response.getReturnValue());
                var contentDataRows = wrapperObject.contentDataRows;
                var totalRecords = (contentDataRows.length)-1;
                var headerMap = wrapperObject.headerMap;
                component.set("v.csvRowData",contentDataRows.slice(1,contentDataRows.length));
                component.set("v.TotalRecords", totalRecords);
                component.set("v.loadingMessage",'Reading products from uploaded file.');
                helper.readDataFromUploadedFile(component, event, helper, 0, headerMap);
                //component.set("v.totalData", wrapperObject.unMatchedRecords);
                //component.set('v.uploadeddata', wrapperObject.unMatchedRecords);
                
                /* console.log('totalRowsCount -->'+wrapperObject.totalRecordsInfo.totalRecCount);
                var noOfTotalPages = wrapperObject.totalRecordsInfo.totalRecCount/100;
                console.log('noOfTotalPages -->'+noOfTotalPages);
                var pageNumbers = [];
                var j=1;
                for(var i=0;i<noOfTotalPages;i++){
                    pageNumbers.push(j);
                    j++;
                }
                component.set("v.pageNumberTotalRecs",pageNumbers);
                component.set("v.totalData", wrapperObject.unMatchedRecords);
                helper.paginateRecords2(component,event);
                component.set('v.showProductsloading', false);*/
            }
            else {
                component.set('v.showProductsloading', false);
                console.log("failed " + JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action2);
        
    },
    readDataFromUploadedFile: function(component, event, helper, offsetVal, headerMap){
        component.set("v.loadingMessage",'Reading products from uploaded file. '+(offsetVal<component.get("v.TotalRecords") ? offsetVal : component.get("v.TotalRecords"))+' out of '+component.get("v.TotalRecords"));
        var csvRowData = component.get("v.csvRowData");
        var processData = csvRowData.slice(offsetVal,offsetVal+50);
        var action = component.get("c.prepareRecords");
        action.setParams({
            csvRecordsList : processData,
            headerMap : headerMap
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var returnDataList = response.getReturnValue();
                var addedData = component.get("v.totalData");
                returnDataList.forEach(function(retObj){addedData.push(retObj);});
                component.set("v.totalData",addedData);
                if(component.get("v.TotalRecords")>offsetVal){
                    helper.readDataFromUploadedFile(component, event, helper, offsetVal+50, headerMap);
                }
                else{
                    if(component.get("v.AccountNumber") == '164498'){
                        helper.matchUploadedProducts(component, event, helper, 0);
                    }
                    else{
                        component.set('v.showProductsloading', false);
                        component.set("v.loadingMessage",'');
                        component.set("v.csvRowData",[]);
                        var noOfTotalPages = component.get("v.TotalRecords")/100;
                        var pageNumbers = [];
                        var j=1;
                        for(var i=0;i<noOfTotalPages;i++){
                            pageNumbers.push(j);
                            j++;
                        }
                        component.set("v.pageNumberTotalRecs",pageNumbers);
                        helper.paginateRecords2(component,event);
                    }
                }
            }
            else {
                component.set('v.showProductsloading', false);
                console.log("failed " + JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);
    },
    mapUnMatchRecords: function (component, event) {
        component.set('v.showProductsloading', true);
        var action = component.get("c.mapUnmatchedProducts");
        var matchRecords = component.get("v.matchdata");
        var unmatchRecords = component.get("v.unmatchdata");
        //var unmatchSelRecords = component.get("v.selectedUnmatchedRowsList");
        /*for (var i = 0; i < unmatchSelRecords.length; i++) {
            unmatchRecords.pop(unmatchSelRecords[i]);
        }*/
        action.setParams({
            "matchData": JSON.stringify(matchRecords),
            "unmatchData": JSON.stringify(unmatchRecords),
            //"unmatchSelectedList": JSON.stringify(unmatchSelRecords),
            
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state == "SUCCESS") {
                var wrapperObject = JSON.parse(response.getReturnValue());
                component.set("v.matchedRowsCount", wrapperObject.totalRecordsInfo.matchedRecCount);
                component.set("v.unmatchedRowsCount", wrapperObject.totalRecordsInfo.unmatchedRecCount);
                wrapperObject.matchedRecords.forEach(function (record) {
                    //record.Product__c = '/' + record.Product__c;
                    record.ProductName = record.Name;
                });
                component.set('v.matchdata', wrapperObject.matchedRecords);
                component.set('v.unmatchdata', wrapperObject.unMatchedRecords);
                component.set("v.selectedUnmatchedRowsList", []);
                component.set('v.selectedUnmatchedRowsCount', 0);
                component.set('v.successVal', '');
                //component.set(event.getParam('draftValues'), []);
                component.set('v.showProductsloading', false);
            }
            else {
                component.set('v.showProductsloading', false);
                console.log("failed " + response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
        
    },
    addSelectedPrdLkp: function (component, event, unMatchRecs, matchRecs) {
        
        component.set('v.showProductsloading', true);
        var action = component.get("c.addSelectedProductLKP");
        
        action.setParams({
            
            "matchData": JSON.stringify(matchRecs),
            "unmatchData": JSON.stringify(unMatchRecs),
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var prdIdsToIgnore = JSON.parse(response.getReturnValue());
                //console.log('state : ' + JSON.stringify(wrapperObject));
                if(prdIdsToIgnore.length>0 && prdIdsToIgnore[0]!=null) {
                    prdString= 'Id NOT IN ( '+"'"+prdIdsToIgnore[0]+"'";
                    prdIdsToIgnore.forEach(function(prdId){
                        prdString += ' , ' +"'"+prdId +"'";
                        
                    });
                    prdString += ' )';
                }
                else{
                    prdString = '()';
                }
                component.set('v.customerHireachyListString',prdString);
                component.set('v.showProductsloading', false);
            }
            else {
                component.set('v.showProductsloading', false);
                console.log("failed " + response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
        
    },
    
    validateOptyName: function (component, event, helper) {
        console.log('Opty Name :: '+component.get("v.name"));
        var action = component.get("c.validateOptyNameCtrl");
        action.setParams({
            "Name": component.get("v.name")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                //console.log('Success Resp ', response.getReturnValue());
                var validOpResp = JSON.parse(response.getReturnValue());
                if(validOpResp){
                    var obj = {};
                    obj.Name = component.get("v.name");
                    obj.Vision_Opportunity_Source__c = component.get("v.source");
                    obj.Vision_Type__c = component.get("v.type");
                    obj.StageName = component.get("v.stage");
                    obj.AccountId = component.get("v.customerLkp");
                    obj.Contact__c = component.get("v.cntcLkp");
                    obj.Bid_Type__c = component.get("v.bidTypeFromForm");
                    obj.Vision_Internal_Closing_Date__c = component.get("v.internalTargetDate");
                    obj.Vision_Customer_Closing_Date__c = component.get("v.customerDeadlineDate");
                    obj.Vision_Comments__c = component.get("v.comments");
                    obj.Vision_Notes__c = component.get("v.notes");
                    component.set("v.optyObj", obj);
                    var evt = $A.get("e.force:navigateToComponent");
                    evt.setParams({
                        componentDef: "c:Vision_AddOpportunityLines",
                        componentAttributes: {
                            showContracts: false,
                            optyObj: obj
                            //recordId: component.get("v.recordId")
                        }
                    });
                    evt.fire();
                }
                else{
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type": "Error",
                        "title": "Error!",
                        "message": component.get("v.name") + " : opportunity name already exists."
                    });
                    toastEvent.fire();
                }
                
            }
            else {
                console.log("failed " + response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
        
    },
    restrictPastDates: function (component, event, helper) {
        console.log('Date checker Called');
        /*var today = new Date();
        var dd = String(today.getDate()).padStart(2, '0');
        var mm = String(today.getMonth() + 1).padStart(2, '0'); //January is 0!
        var yyyy = today.getFullYear();
        today = yyyy + '-' + mm + '-' + dd;
        console.log('Date checker Called',today);
        component.set("v.internalTargetDate",today);*/
        var j$ = jQuery.noConflict();
        //Assigning SLDS Static Resource Path To A Variable To Use It With ALJS Initialization
        var assetsLoc = '{!URLFOR($Resource.CI)}';
        console.log('Date checker Called 2');
        //ALJS Initialization   
        
        j$.aljsInit({
            assetsLocation: assetsLoc, //SLDS Static Resource Path
            scoped: true
        });
        console.log('Date checker Called 3');
        j$(document).ready(function() {
            
            //Initializing Datepicker with options To The SLDS Input on document ready.
            
            j$('#date').datepicker({
                initDate: moment(), //Today Date
                format: 'YYYY/MM/DD', //Date Format Of Datepicker Input Field
                onChange: function(datepicker) {
                    j$('#SelectedDate').html('Selected Date: <strong>'+moment(datepicker.selectedFullDate._d).format('YYYY/MM/DD')+'</strong>');
                }
            });
        });
        console.log('Date checker Called 4');
    },
    redirectToDetailPage: function (component, event, helper, optyId) {
        console.log('Helper Redirect Called');
        //var record = event.getParam("response");
        //var apiName = record.apiName;
        var myRecordId = component.get('v.recordId');
        //component.set("v.recordId1", myRecordId);
        
        var message;
        var optyRecId = '';
        if (component.get("v.recordId") == null || component.get("v.recordId") == '' || component.get("v.recordId") == undefined) {
            message = 'created';
            optyRecId=optyId
        } else {
            message = 'updated';
            optyRecId = component.get("v.recordId");
        }
        helper.handleUploadFinished(component, event,optyRecId);
        
        try {
            var matchRecords = [];
            var unmatchRecords = [];
            var action = component.get("c.saveOptyProducts");
            matchRecords = component.get("v.totalMatchdata");
            unmatchRecords = component.get("v.totalUnmatchdata");
            /*console.log(JSON.stringify(matchRecords));
            
            if(component.get("v.isBidClone")){
                var optyItems = component.get("v.optyProdList");
                console.log('optyItems --> '+JSON.stringify(optyItems));
            
                optyItems.forEach(function(obj){
                    matchRecords.push(optyItems);
                });
            }*/
            console.log('optyRecId --> '+optyRecId);
            matchRecords.forEach(function(item){
                console.log('item.Product__c ---> '+item.Product__c);
            });
            console.log();
            action.setParams({
                "opportunityId": optyRecId,
                "matchData": JSON.stringify(matchRecords),
                "unmatchData": JSON.stringify(unmatchRecords)
            });
            action.setCallback(this, function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    console.log("success " + JSON.stringify(response.getReturnValue()));
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type": "success",
                        "title": "Success!",
                        "message": "The record has been " + message + " successfully."
                    });
                    toastEvent.fire();
                    
                    var navEvt = $A.get("e.force:navigateToSObject");
                    navEvt.setParams({
                        "recordId": optyRecId,
                        "slideDevName": "View Selected Products"
                    });
                    navEvt.fire();
                    //$A.get('e.force:refreshView').fire();
                }
                else {
                    console.log("failed " + JSON.stringify(response.getError()));
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type": "ERROR",
                        "title": "Failed to save the Opportunity",
                        "message": ''+JSON.stringify(response.getError())
                    });
                    toastEvent.fire();
                }
            });
            $A.enqueueAction(action);
            
            /* if (message == 'updated') {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": "success",
                    "title": "Success!",
                    "message": "The record has been " + message + " successfully."
                });
                toastEvent.fire();
                
                component.find("navigationService").navigate({
                    type: "standard__recordPage",
                    attributes: {
                        recordId: component.get("v.recordId"),
                        actionName: "view"
                    }
                }, false);
                // replace
                $A.get('e.force:refreshView').fire();
                
            }
            else {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": "success",
                    "title": "Success!",
                    "message": "The record has been " + message + " successfully."
                });
                toastEvent.fire();
                
                var navEvt = $A.get("e.force:navigateToSObject");
                navEvt.setParams({
                    "recordId": myRecordId,
                    "slideDevName": "View Selected Products"
                });
                navEvt.fire();
                $A.get('e.force:refreshView').fire();
                
            } */
        }
        catch (ex) {
            console.log('exception' + ex);
        }
        //helper.saveOptyLineItems(component, event, myRecordId);
    },
    paginateRecords : function(component, event){
        var selectedTabName = component.get("v.selTabId");
        console.log('---selTabId---'+selectedTabName);
        if(selectedTabName == 'matchPrds'){
            var selectedPageNum = component.get("v.selectedPageNumberMatched");
            var matchedRecs = component.get("v.totalMatchdata");
            console.log('matchedRecs.length ---> '+matchedRecs.length);
            var selectedList = matchedRecs.slice((selectedPageNum-1)*100,selectedPageNum*100);
            component.set('v.matchdata',selectedList);
            console.log('---Match selectedList---'+selectedList.length);
        }
        else if(selectedTabName == 'unmatchPrds'){
            var selectedPageNum = component.get("v.selectedPageNumberUnmatched");
            var unmatchedRecs = component.get("v.totalUnmatchdata");
            console.log('unmatchedRecs.length ---> '+unmatchedRecs.length);
            var selectedList = unmatchedRecs.slice((selectedPageNum-1)*100,selectedPageNum*100);
            component.set('v.unmatchdata',selectedList);
            console.log('---UnMatch unmatchdata---'+JSON.stringify(component.get('v.unmatchdata')));
        }
    },
    paginateRecords2 : function(component, event){
        var totalRecs = component.get("v.totalData");
        var selectedPageNum = component.get("v.selectedPageNumber");
        console.log('totalRecs.length ---> '+totalRecs.length);
        var selectedList = totalRecs.slice((selectedPageNum-1)*100,selectedPageNum*100);
        console.log('selectedList.length ---> '+selectedList.length);
        component.set('v.uploadeddata',selectedList);
    },
    paginateRecords3 : function(component, event){
        var selectedPageNum = component.get("v.selectedPageNumberMatched");
        var matchedRecs = component.get("v.totalMatchdata");
        console.log('matchedRecs.length ---> '+matchedRecs.length);
        var selectedList = matchedRecs.slice((selectedPageNum-1)*100,selectedPageNum*100);
        component.set('v.matchdata',selectedList);
        console.log('---Match selectedList---'+selectedList.length);
    },
    
})