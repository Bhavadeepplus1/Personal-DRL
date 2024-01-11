({
    doInit : function(component, event, helper) {
        var getBidInfoAction = component.get("c.getAccountGroups");
        component.set('v.loaded',true);
        var data = component.get("v.shortDateList");
        // //console.log('data---'+data);
        getBidInfoAction.setCallback(this, function (response) {
            var actState = response.getState();
            if (actState == 'SUCCESS') {
                var responseWrapper=response.getReturnValue();
                component.set("v.accGroupList",responseWrapper.accList);
                component.set("v.DoHSummaryList",responseWrapper.accList);
                var doh= component.get("v.DoHSummaryList");
                component.set("v.isProcessed",responseWrapper.isProcessed);  
                //console.log('dohLine15>>'+JSON.stringify(doh.dohRecords));
                // var dohData=doh[0].dohRecords;
                //console.log('dohDataLine17>>'+JSON.stringify(dohData));
                
                //  component.set("v.ProductName",dohData);
                var prodName=component.get("v.ProductName");
                //console.log('prodNameLine21>>'+JSON.stringify(prodName));
                
                component.set("v.noOfRecords",responseWrapper.noOfRecords); 
                component.set("v.tradeGroupList",responseWrapper.dohRecords);
                component.set("v.visionUpdateDate",responseWrapper.visionUpdateDate);
                component.set("v.gcpUpdateDate",responseWrapper.gcpUpdateDate);
                
                //console.log('dohRecordsLine26-----'+JSON.stringify(responseWrapper));
                //  component.set("v.shortDateList",responseWrapper.sdRecords);
                //  //console.log('shortDateList cxCodeWrapList-----'+JSON.stringify(responseWrapper.accList));
                component.set('v.loaded',false);
                var pickList =  [];
                var picklistValues = responseWrapper.accgrpList;
                //   //console.log('picklistValues-----'+picklistValues[0]);
                if(picklistValues.length>0 && picklistValues[0] != undefined){
                    component.set('v.selectedId',picklistValues[0]);   
                }
                
                var i = 1;
                var newLine = 1;
                picklistValues.forEach(function(user){
                    var isNewLine = false;
                    if(newLine == 5){
                        isNewLine = true;
                        newLine =1;
                    }
                    pickList.push({userId:''+user,isSelected: i==1?true:false,isNewLine:isNewLine});
                    i++;
                    newLine++;
                });
                //  //console.log('picklist-----'+JSON.stringify(pickList));
                component.set("v.pickList",pickList);
            }
            else{
                //console.log("Error "+JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(getBidInfoAction);
        
    }, 
    onSelectUser : function(component, event, helper){
        ////console.log('Id Name---'+event.getSource().get("v.name"));
        var picliList = component.get('v.RxSrxList');
        //console.log('picliList---'+picliList);
        var selectedId =  event.currentTarget.dataset.id;//event.getSource().get("v.name");
        //   //console.log('Id Name---'+selectedId);
        component.set('v.selectedId',selectedId);
        var listOfusers = component.get("v.pickList");
        listOfusers.forEach(function(user){
            if(user.userId == selectedId){
                user.isSelected = true;
            }
            else{
                user.isSelected = false;
            }
        });
        component.set("v.pickList",listOfusers);
        console.log('onselect name'+component.get("v.selectedId"));
        component.set("v.DoHSummaryList", null);
        component.set("v.noOfRecords",0); 
              component.set("v.searchText", null);
  
        
        //console.log('onselect isPWO'+component.get("v.isPWO"));
        
    },
    onsearch: function (component, event, helper) {
        //console.log('Hi search')
        console.log('Hi search-----'+component.get("v.searchText"))
        component.set("v.noData",false);
        var searchName=component.get("v.searchText");
        var selectedId = component.get("v.selectedId");
        component.set('v.loaded',true);
        
        var action = component.get("c.getFilterDoHData");
        console.log('Hi search method-----'+component.get("v.selectedId"))
        action.setParams({
            tradePartnerName : component.get("v.selectedId"),
            searchText : searchName,
            
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                //console.log('hi search')
                var responseWrapper = response.getReturnValue();
                component.set('v.loaded',false);
                component.set('v.searchText',searchName);
                console.log('searchText respone wrapper'+JSON.stringify(responseWrapper));
                if(searchName != null && searchName != undefined){
                    component.set("v.DoHSummaryList", responseWrapper.dohRecordsList);
                    var doh= component.get("v.DoHSummaryList");
                    var modalMessage;
                    if(responseWrapper.dohRecordsList.length == 0){
                      modalMessage = '"'+searchName+'" is not matching any products on IntegriChain data for "'+selectedId+'" ';  
                   component.set('v.modalMessage',modalMessage);
                    }
                    if(searchName == null || searchName == "undefined" || searchName ==''){
                      modalMessage = 'Search by Ndc or Product in the search bar.';  
                   component.set('v.modalMessage',modalMessage);    
                    }
                    //console.log('doh>>'+JSON.stringify(doh[0].dohRecords));
                    //   var dohData=doh[0].dohRecords;
                    //console.log('dohDataLine158>>'+JSON.stringify(dohData));
                    
                    //  component.set("v.ProductName",dohData);
                    var prodName=component.get("v.ProductName");
                    //console.log('prodNameLine162>>'+JSON.stringify(prodName));
                    component.set("v.noOfRecords",responseWrapper.noOfRecords); }
                
                else{
                    component.set("v.DoHSummaryList", responseWrapper.accList);
                    component.set("v.noOfRecords",responseWrapper.noOfRecords);}
                var doh= component.get("v.DoHSummaryList");
                
                //console.log('doh>>'+JSON.stringify(doh[0].dohRecords));
                // var dohData=doh[0].dohRecords;
                //console.log('dohDataLine172>>'+JSON.stringify(dohData));
                
                //  component.set("v.ProductName",dohData);
                var prodName=component.get("v.ProductName");
                //console.log('prodName>>'+JSON.stringify(prodName));
                
            }  else{
                //console.log("Error "+JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);
        
    },
    closeModel: function(component, event, helper) {
        // Set isModalOpen attribute to true
        component.set("v.isModalOpen", false);
        component.set("v.isModalOpenAwrdPosition", false);
        
        
    },
    openModal: function(component, event, helper) {
        // Set isModalOpen attribute to true
        component.set("v.isModalOpen", true);
        
    },
    openModalAwardPosition: function(component, event, helper) {
        // Set isModalOpen attribute to true
        
        component.set('v.loaded',true);
        var recId = event.currentTarget.dataset.id;
        console.log('someVal1 --> '+event.currentTarget.dataset.name);
        //event.target.value;//event.getSource().get("v.value");//
        console.log('sku code----'+recId);
        // console.log('acc code----'+component.get("v.recordId"));
        var getBidInfoAction = component.get("c.getAwardedPositionData");
        getBidInfoAction.setParams({
            
            // customerId :component.get("v.recordId"),
            Id :recId
        });
        console.log('Hiiii');
        getBidInfoAction.setCallback(this, function (response) {
            var actState = response.getState();
            if (actState == 'SUCCESS') {
                console.log('success');
                component.set('v.loaded',false);
                var responseWrapper=response.getReturnValue();
                console.log('awardedPosition-->'+JSON.stringify(responseWrapper));
                component.set("v.awardedPosition",responseWrapper.awardedPositionList);
                component.set("v.ProdName",responseWrapper.ProdName);
                component.set("v.Ndc",responseWrapper.Ndc);
                component.set("v.isModalOpenAwrdPosition", true);
            }
            else{
                component.set('v.loaded',false);
                console.log('errot---'+JSON.stringify(response.getError()));
            }
            
        });
        $A.enqueueAction(getBidInfoAction);
        
    },
      sortByDOH1: function(component, event, helper) {
        console.log('inside sortByDOh1');
        component.set('v.loaded',true);
        // set current selected header field on selectedTabsoft attribute.    
        //component.set("v.selectedTabsoft", 'Segment');
        // call the helper function with pass sortField Name  
        
        helper.sortHelper(component, event, 'Vision_GCP_W1_DOH__c');
    },
    sortByDOH2: function(component, event, helper) {
        console.log('inside sortByDOh1');
        component.set('v.loaded',true);
        // set current selected header field on selectedTabsoft attribute.    
        //component.set("v.selectedTabsoft", 'Segment');
        // call the helper function with pass sortField Name  
        
        helper.sortHelper(component, event, 'Vision_GCP_W2_DOH__c');
    },
    sortByDOH3: function(component, event, helper) {
        console.log('inside sortByDOh1');
        component.set('v.loaded',true);
        // set current selected header field on selectedTabsoft attribute.    
        //component.set("v.selectedTabsoft", 'Segment');
        // call the helper function with pass sortField Name  
        
        helper.sortHelper(component, event, 'Vision_GCP_W3_DOH__c');
    },
    sortByDOH4: function(component, event, helper) {
        component.set('v.loaded',true)
        helper.sortHelper(component, event, 'Vision_GCP_W4_DOH__c');
    },
     sortByDOH5: function(component, event, helper) {
        component.set('v.loaded',true)
        helper.sortHelper(component, event, 'Vision_GCP_W5_DOH__c');
    },
     sortByDOH6: function(component, event, helper) {
        component.set('v.loaded',true)
        helper.sortHelper(component, event, 'Vision_GCP_W6_DOH__c');
    },
     sortByDOH7: function(component, event, helper) {
        component.set('v.loaded',true)
        helper.sortHelper(component, event, 'Vision_GCP_W7_DOH__c');
    },
     sortByDOH8: function(component, event, helper) {
        component.set('v.loaded',true)
        helper.sortHelper(component, event, 'Vision_GCP_W8_DOH__c');
    },
    sortByQOH1: function(component, event, helper) {
        console.log('inside sortByDOh1');
        component.set('v.loaded',true);
        // set current selected header field on selectedTabsoft attribute.    
        //component.set("v.selectedTabsoft", 'Segment');
        // call the helper function with pass sortField Name  
        
        helper.sortHelper(component, event, 'Vision_GCP_W1_QOH__c');
    },
    sortByQOH2: function(component, event, helper) {
        console.log('inside sortByDOh1');
        component.set('v.loaded',true);
        // set current selected header field on selectedTabsoft attribute.    
        //component.set("v.selectedTabsoft", 'Segment');
        // call the helper function with pass sortField Name  
        
        helper.sortHelper(component, event, 'Vision_GCP_W2_QOH__c');
    },
    sortByQOH3: function(component, event, helper) {
        console.log('inside sortByDOh1');
        component.set('v.loaded',true);
        // set current selected header field on selectedTabsoft attribute.    
        //component.set("v.selectedTabsoft", 'Segment');
        // call the helper function with pass sortField Name  
        
        helper.sortHelper(component, event, 'Vision_GCP_W3_QOH__c');
    },
    sortByQOH4: function(component, event, helper) {
        component.set('v.loaded',true);
        helper.sortHelper(component, event, 'Vision_Gcp_W4_QOH__c');
    },
    sortByQOH5: function(component, event, helper) {
        component.set('v.loaded',true);
        helper.sortHelper(component, event, 'Vision_Gcp_W5_QOH__c');
    },
    sortByQOH6: function(component, event, helper) {
        component.set('v.loaded',true);
        helper.sortHelper(component, event, 'Vision_Gcp_W6_QOH__c');
    },
    sortByQOH7: function(component, event, helper) {
        component.set('v.loaded',true);
        helper.sortHelper(component, event, 'Vision_Gcp_W7_QOH__c');
    },
    sortByQOH8: function(component, event, helper) {
        component.set('v.loaded',true);
        helper.sortHelper(component, event, 'Vision_Gcp_W8_QOH__c');
    },
    sortByValue1: function(component, event, helper) {
        console.log('inside sortByDOh1');
        component.set('v.loaded',true);
        // set current selected header field on selectedTabsoft attribute.    
        //component.set("v.selectedTabsoft", 'Segment');
        // call the helper function with pass sortField Name  
        
        helper.sortHelper(component, event, 'Value_W1__c');
    },
    sortByValue2: function(component, event, helper) {
        console.log('inside sortByDOh1');
        component.set('v.loaded',true);
        // set current selected header field on selectedTabsoft attribute.    
        //component.set("v.selectedTabsoft", 'Segment');
        // call the helper function with pass sortField Name  
        
        helper.sortHelper(component, event, 'Value_W2__c');
    },
    sortByValue3: function(component, event, helper) {
        component.set('v.loaded',true) 
        helper.sortHelper(component, event, 'Value_W3__c');
    },
    sortByValue4: function(component, event, helper) {
        component.set('v.loaded',true);
        helper.sortHelper(component, event, 'Value_W4__c');
    },
    sortByValue5: function(component, event, helper) {
        component.set('v.loaded',true);
        helper.sortHelper(component, event, 'Value_W5__c');
    },
    sortByValue6: function(component, event, helper) {
        component.set('v.loaded',true);
        helper.sortHelper(component, event, 'Value_W6__c');
    },
    sortByValue7: function(component, event, helper) {
        component.set('v.loaded',true);
        helper.sortHelper(component, event, 'Value_W7__c');
    },
    sortByValue8: function(component, event, helper) {
        component.set('v.loaded',true);
        helper.sortHelper(component, event, 'Value_W8__c');
    },
    sortByQtySold1: function(component, event, helper) {
        console.log('inside sortByDOh1');
        component.set('v.loaded',true);
        // set current selected header field on selectedTabsoft attribute.    
        //component.set("v.selectedTabsoft", 'Segment');
        // call the helper function with pass sortField Name  
        
        helper.sortHelper(component, event, 'vision_gcp_w1_quantity_sold__c');
    },
    sortByQtySold2: function(component, event, helper) {
        console.log('inside sortByDOh1');
        component.set('v.loaded',true);
        // set current selected header field on selectedTabsoft attribute.    
        //component.set("v.selectedTabsoft", 'Segment');
        // call the helper function with pass sortField Name  
        
        helper.sortHelper(component, event, 'vision_gcp_w2_quantity_sold__c');
    },
    sortByQtySold3: function(component, event, helper) {
        console.log('inside sortByDOh1');
        component.set('v.loaded',true);
        // set current selected header field on selectedTabsoft attribute.    
        //component.set("v.selectedTabsoft", 'Segment');
        // call the helper function with pass sortField Name  
        
        helper.sortHelper(component, event, 'vision_gcp_w3_quantity_sold__c');
    },
    sortByQtySold4: function(component, event, helper) {
        component.set('v.loaded',true);
        helper.sortHelper(component, event, 'vision_gcp_w4_quantity_sold__c');
    },
     sortByQtySold5: function(component, event, helper) {
        component.set('v.loaded',true);
        helper.sortHelper(component, event, 'vision_gcp_w5_quantity_sold__c');
    },
     sortByQtySold6: function(component, event, helper) {
        component.set('v.loaded',true);
        helper.sortHelper(component, event, 'vision_gcp_w6_quantity_sold__c');
    },
     sortByQtySold7: function(component, event, helper) {
        component.set('v.loaded',true);
        helper.sortHelper(component, event, 'vision_gcp_w7_quantity_sold__c');
    },
     sortByQtySold8: function(component, event, helper) {
        component.set('v.loaded',true);
        helper.sortHelper(component, event, 'vision_gcp_w8_quantity_sold__c');
    },
    sortByItem: function(component, event, helper) {
        console.log('inside sortByDOh1');
        component.set('v.loaded',true);
        // set current selected header field on selectedTabsoft attribute.    
        //component.set("v.selectedTabsoft", 'Segment');
        // call the helper function with pass sortField Name  
        
        helper.sortHelper(component, event, 'vision_gcp_package_description__c');
    },
     sortByNDC: function(component, event, helper) {
        console.log('inside sortByDOh1');
        component.set('v.loaded',true);
        // set current selected header field on selectedTabsoft attribute.    
        //component.set("v.selectedTabsoft", 'Segment');
        // call the helper function with pass sortField Name  
        
        helper.sortHelper(component, event, 'vision_gcp_ndc__c');
    },
})