({
    getRecordTypeIds : function(component, event,helper){
        var action = component.get("c.getRecordTypeDetails");      
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") { 
                component.set("v.recordTypesValues",response.getReturnValue());
            }           
        });
        $A.enqueueAction(action);  
    },
    loadInstance: function(component, helper){
         component.set('v.isSpinnerLoad',false);
         component.set('v.fileList',[]);
        component.set("v.custReadonly",false);
        let pageReference = component.get("v.pageReference");
        console.log(pageReference);
        let recordId = pageReference.state.c__recordId;
        console.log("loadInstance recordId in loadInstance: " + recordId);
        
        if (recordId != null && recordId != undefined && recordId != '') {
            component.set("v.recordId", recordId);
            component.set("v.isCreate",false);
            /*var OutDiv1=component.find("model");
            $A.util.addClass(OutDiv1, "hideposi");*/
            console.log('in if condition');
        }
        else{
            component.set("v.recordId", null);
            component.set("v.isCreate",true); 
            console.log('in else condition');
              /*var OutDiv=component.find("mdCont");
        $A.util.addClass(OutDiv, "hidescroll");*/
        }
        
        
        var action = component.get("c.getbidInfo");
        
        action.setParams({
            "recordId": recordId          
        });
        
        
        action.setCallback(this, function (response) {
            var state = response.getState();
            console.log('state---------'+state);
            if (state === "SUCCESS") {  
                 component.set('v.loading', false);
                
                var wrapperObject = response.getReturnValue();
                var aprovalStatus=wrapperObject.bid.Phoenix_Approval_Status__c;
                if(aprovalStatus!=null && aprovalStatus!='Draft'){
                    component.set("v.bidSubmitted",true);
                }else{
                   component.set("v.bidSubmitted",false); 
                }
                if(wrapperObject.bid.Phoenix_Bid_Type__c!=undefined && wrapperObject.bid.Phoenix_Bid_Type__c!=null){
                    component.set("v.BidType",wrapperObject.bid.Phoenix_Bid_Type__c);
                }                            
                component.set("v.WrapperObect",wrapperObject);
                console.log('haslines--'+wrapperObject.hasLines);
                component.set("v.hasLines",wrapperObject.hasLines);
                 component.set("v.bidCreated",wrapperObject.bidCreated);
                var isCreate=component.get("v.isCreate");
                var bidtypeVal=component.get("v.BidType");
                if(bidtypeVal != undefined && bidtypeVal != null && bidtypeVal.includes('OTC')){
                    component.set("v.isOTCBid",true);
                    console.log('OTC')
                }
                console.log("---bidtypeVal-----"+bidtypeVal);
                if(wrapperObject.bid.Phoenix_Customer_Type__c!=undefined && wrapperObject.bid.Phoenix_Customer_Type__c!=null){
                console.log("---customer type-----"+wrapperObject.bid.Phoenix_Customer_Type__c);
                component.set("v.BidTemplate",wrapperObject.bid.Phoenix_Customer_Type__c)
                }
                if(bidtypeVal=='IPA Floor Pricing Update' || bidtypeVal=='Mass Product Removals'|| bidtypeVal=='Product Discontinuation Process' || bidtypeVal=='SRx IPA Price Change' || bidtypeVal=='SRx IPA Product Addition' || bidtypeVal=='RCA/IPA Member GPO or Wholesaler Change'|| bidtypeVal=='WAC Change Submissions' || bidtypeVal=='Direct Order Form Pricing Update' || bidtypeVal=='RCA Member Addition' || bidtypeVal=='IPA Member Addition'){
                    component.set("v.NoCustContact",false);
                }else{
                    component.set("v.NoCustContact",true);
                }
                console.log('NoCustContact--'+component.get("v.NoCustContact"));
                if( bidtypeVal=='SRx IPA Product Addition' || bidtypeVal=='SRx IPA Price Change' ||  bidtypeVal=='RCA Member Addition' || bidtypeVal=='IPA Member Addition' || bidtypeVal=='Direct Order Form Pricing Update' || bidtypeVal=='IPA Floor Pricing Update' || bidtypeVal=='RCA/IPA Member GPO or Wholesaler Change' || bidtypeVal=='WAC Change Submissions' || bidtypeVal=='Product Discontinuation Process' || bidtypeVal=='Mass Product Removals') {
                    component.set("v.deadLineValue",false);
                }else{
                    component.set("v.deadLineValue",true);
                }
               if(bidtypeVal=='Direct Order Form Pricing Update' || bidtypeVal=='WAC Change Submissions' || bidtypeVal=='RCA Member Addition' || bidtypeVal=='IPA Member Addition' || bidtypeVal=='RCA/IPA Member GPO or Wholesaler Change' || bidtypeVal=='SRx IPA Price Change' || bidtypeVal=='SRx IPA Product Addition' ||  bidtypeVal =='IPA Floor Pricing Update'|| bidtypeVal=='Product Discontinuation Process' || bidtypeVal=='Mass Product Removals'){
                    component.set("v.hasInternalDate",true);
                }else{
                    component.set("v.hasInternalDate",false);
                }
               
               
                if(bidtypeVal!=undefined && component.find("contractLookup")!=null){
                   component.find("contractLookup").fireChanging(wrapperObject.bid.Phoenix_RCA_Agreement__c);
                   component.set("v.RcaAgreement",wrapperObject.bid.Phoenix_RCA_Agreement__c);
                   
                }
                if(bidtypeVal!=undefined && component.find("contactLookup")!=null ){
                    console.log('wrapperObject.bid.Phoenix_Customer__c--'+wrapperObject.bid.Phoenix_Customer__c);
                   component.set("v.customerRecord",wrapperObject.bid.Phoenix_Customer__c);
                   component.find("contactLookup").fireChanging(wrapperObject.bid.Phoenix_Contact__c);
                   component.set("v.cntcLkp",wrapperObject.bid.Phoenix_Contact__c);   
                   
                }
                 if(bidtypeVal!=undefined && component.find("customerLookup")!=null){
                    component.set("v.customerLkp",wrapperObject.bid.Phoenix_Customer__c);
                       console.log('customerLkp--'+component.get("v.customerLkp"));
                   component.find("customerLookup").fireChanging(wrapperObject.bid.Phoenix_Customer__c);
                   console.log('wrapperObject.bid.Phoenix_Customer__c--'+wrapperObject.bid.Phoenix_Customer__c);
                     
                }
                
				              
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
            console.log('hasLines--'+component.get("v.hasLines")+'NoCustContact--'+component.get("v.hasLines")+'--'+'isCreate--'+component.get("v.isCreate")+'BidType--'+component.get("v.BidType"));
            if((component.get("v.hasLines") && component.get("v.NoCustContact")) || (component.get("v.isCreate") && component.get("v.BidType"))||component.get("v.bidCreated")==true){
                component.set("v.custReadonly",true);
            }
        });
        
        $A.enqueueAction(action);
       
    },
    handleFormSubmit: function(component, event, helper) {
      
        var showValidationError = false;
       
       // var fields = component.find("fieldLableId");
        var vaildationFailReason = '';
        //var currentDate = new Date().toJSON().slice(0,10);
        /*let fieldsMap = new Map();
        fields.forEach(function (field) {
            fieldsMap.set(field.get("v.fieldName"), field);
            
        });*/
        
       // var BidDeadlineTime= fieldsMap.get("Phoenix_Bid_Deadline_Date__c").get("v.value");
      // var TimeZone =fieldsMap.get("Phoenix_Customer_Bid_Deadline_Time_zone__c").get("v.value");
      /*  if(BidDeadlineTime!=null && BidDeadlineTime!='' && BidDeadlineTime!=undefined &&(TimeZone==null ||TimeZone==undefined ||TimeZone=='')){
            
            window.scroll(0,0);
            
            showValidationError = true;
            //vaildationFailReason = "Please select Customer Bid Deadline Time Zone";
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Warning!",
                "message":"Please select Customer Bid Deadline Time Zone.",
                "type":"error",
                "mode":"dismissible"
            });
            toastEvent.fire();  
        }
        else if(TimeZone!=null && TimeZone!=''&& TimeZone!=undefined &&(BidDeadlineTime==null ||BidDeadlineTime==undefined ||BidDeadlineTime=='')){
            showValidationError = true;
            vaildationFailReason = "Please select Customer Bid Deadline Date/Time";  
            window.scroll(0,0);
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Warning!",
                "message":"Please select Customer Bid Deadline Date.",
                "type":"error",
                "mode":"dismissible"
            });
            toastEvent.fire();  
        }*/
          var eventFields = event.getParam("fields");
        if(component.find("contractLookup")!=null){
            var rcaContract=component.get("v.RcaAgreement"); 
            
            if(rcaContract==null ||  rcaContract=='' || rcaContract==undefined){
                
                //  window.scroll(0,0);
                
                showValidationError = true;
                //vaildationFailReason = "Please select Customer Bid Deadline Time Zone";
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Warning!",
                    "message":"Please select RCA/IPA Contract.",
                    "type":"error"                
                });
                toastEvent.fire();  
            }
        }
        if(component.find("customerLookup")!=null && component.get("v.custReadonly")==false){
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
            }
            else if(eventFields["Phoenix_Approval_Status__c"] == undefined && (inTrgtDate<today && (WrapperObect.bid.Phoenix_Approval_Status__c == undefined || WrapperObect.bid.Phoenix_Approval_Status__c == 'Draft'))){
                showValidationError = true;
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Warning!",
                    "message":"Internal Target Date should be greater then or equal to Today's Date",
                    "type":"error"                
                });
                toastEvent.fire();  
            }
            else if((eventFields["Phoenix_Approval_Status__c"] == undefined || eventFields["Phoenix_Approval_Status__c"] == "Draft") && inTrgtDate>eventFields["Phoenix_Bid_Deadline_Date__c"]){
                showValidationError = true;
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Warning!",
                    "message":"Customer Bid Deadline Date should be greater than Internal Target Date",
                    "type":"error"                
                });
                toastEvent.fire();  
            }
        if(eventFields["Phoenix_Bid_Type__c"]=='Customer Rebate Change' &&  (component.get('v.BidTemplate')=='RXSS' || component.get('v.BidTemplate')=='Net Indirect Pricing' || component.get('v.BidTemplate')=='Sams Club')){
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
        
         if(eventFields["Phoenix_Template_Type_Humana__c"]=='Humana Indirect retail'|| eventFields["Phoenix_Template_Type_Humana__c"]=='Humana Indirect CII'){
            if(eventFields["Phoenix_Bid_Type__c"]=='Customer Rebate Change' || eventFields["Phoenix_Bid_Type__c"]=='New Customer' ||eventFields["Phoenix_Bid_Type__c"]=='Sales Out Rebate'){
               showValidationError=true;
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!", 
                    "message":"We can not create "+eventFields["Phoenix_Bid_Type__c"]+" for this customer template",
                    "type":"error"                
                });
                toastEvent.fire(); 
            }   
            
        }
            
            
        
        
      
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
         
        var bidType=eventFields["Phoenix_Bid_Type__c"];
        var recordtypes=component.get("v.recordTypesValues");
        var assignRecTypeId;
        recordtypes.forEach(function(recTypeOnj) {
            console.log('rectypename---'+recTypeOnj['Name']);
             console.log('bidType---'+bidType);
            if(recTypeOnj['Name'].toLowerCase()==bidType.toLowerCase()){
                assignRecTypeId=recTypeOnj['Id'];
                console.log('rectypename--'+recTypeOnj['Name']);
                 console.log('rectypename Id--'+recTypeOnj['Id']);
            };
        });
        console.log('deadline--'+eventFields["Phoenix_Bid_Deadline_Date__c"]);
        eventFields["Phoenix_Bid_Owner__c"]=eventFields["OwnerId"];
        eventFields["Phoenix_is_OTC_Bid__c"]=component.get("v.isOTCBid");
           console.log("rcaContract---"+rcaContract);
        eventFields["Phoenix_RCA_Agreement__c"]=rcaContract;
        eventFields["Phoenix_Contact__c"]=component.get("v.cntcLkp");
           if(component.get("v.custReadonly")==false){
               eventFields["Phoenix_Customer__c"]=component.get("v.customerLkp");  
           }
		      
          // if(component.get("v.customerLkp")!=null){eventFields["Phoenix_Customer__c"]=component.get("v.customerLkp");}  
        component.find("recordEditFormForNewBid").set("v.recordTypeId",assignRecTypeId);        
       
            component.set('v.loading', true);
            component.find("recordEditFormForNewBid").submit(eventFields);  
        } else {
            //component.find('BidMessage').setError(vaildationFailReason);
            component.set('v.loading', false); 
        }
    },
    /*Upload documnet section */
    handleUploadFinished : function(component, event,myRecordId) {
        console.log('v.recordId1::'+myRecordId);
        var fileList = component.get('v.fileList');
        var contentDCIdList = [];
        for(var i=0; i<fileList.length; i++) {
            contentDCIdList.push(fileList[i].documentId);
        }
        var action = component.get('c.createContentDCLink');
        action.setParams({
            'crId' : myRecordId,
            'contentDCIdList' : contentDCIdList
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var response = response.getReturnValue();
            }  
        });
        $A.enqueueAction(action);
    }
})