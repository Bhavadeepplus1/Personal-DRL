({
    handleOnload : function(component, event, helper) {
        //var bidRecordId = component.find("bidId").get('v.value');
        //component.set('v.bidRecordId',bidRecordId);
        component.set('v.isLoginUserAbleToPerform',false);
        component.set('v.isLoginUserAbleToPerformVU',false);
        helper.getBidId(component,event, helper);
    },
    onRecordSubmit : function(component, event, helper){
        event.preventDefault(); 
        var slctCntrcts=component.get("v.selectedCntrcts");
        var eventFields = event.getParam("fields");
        eventFields["Phoenix_Affected_Contract_s__c"] = slctCntrcts.toString();
        component.find("CRForm").submit(eventFields);
    },
    handleOnSuccess : function(component, event, helper) {
        var crRec = event.getParams().response;
        var vistexStatus;
        if(component.find('vistexId')!=null){
           vistexStatus = component.find('vistexId').get('v.value');  
        }        
        console.log('vistexStatus::'+vistexStatus);
        if(component.get('v.isBidLISubmitted') && vistexStatus == 'Updated'){
            console.log('doing updateBidLineItemsWithVistex');
			helper.updateBidLineItemsWithVistex(component,event, helper);
        }
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": crRec.id,
            "slideDevName": "related"
        });
        navEvt.fire();
        component.find('notifLib').showToast({
            "variant": "success",
            "message": "Record Updated Successfully."
        });
        
    },  
    
    showModel: function(component, event, helper) {
        component.set("v.showModal", true);
        component.set("v.isSpinner", true);
        component.set('v.mycolumns', [
            {label: 'Name', fieldName: 'Phoenix_Contract_Number__c', type: 'text'},
            {label: 'Customer', fieldName: 'Phoenix_Customer__c', type: 'text'},
            {label: 'Internal Description', fieldName: 'Phoenix_Contract_Internal_Description__c', type: 'text'},
            {label: 'External Description', fieldName: 'Phoenix_Contract_External_Description__c', type: 'Text'}
        ]); 
        var searchInput=component.find("cntInput").get("v.value");
        
        var bidCustomer=component.get("v.bidCustomerId");
        
        if(bidCustomer!=null && bidCustomer!=undefined){
            helper.fetchContratcs(component, event,helper,bidCustomer,searchInput);
        } else{
            component.set("v.contratcsList",null);
            component.set("v.isSpinner", false);
        }      
    },  
    
    searchContracts : function(component, event, helper) {
        component.set("v.isSpinner", true);
        var searchInput=component.find("cntInput").get("v.value");
        
        var checkToggle=component.find("tgleCntrct").get("v.checked");            
        var bidCustomer=component.get("v.bidRecordId");
        
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
    },  
    
    saveDetails : function(component, event, helper) {
        var selectrcs=component.find('linesTable').getSelectedRows(); 
        var selectedCntrcts=component.get("v.selectedCntrcts");
        for(var i=0;i<selectrcs.length;i++){
            selectedCntrcts.push(selectrcs[i].Phoenix_Contract_Number__c);
        }    
        component.set("v.selectedCntrcts",selectedCntrcts);
        component.set("v.showModal", false);
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
    hideContractModel: function(component, event, helper) {
        component.set("v.showModal", false);
    }, 
    
    doCancel : function(component, event, helper) {
        var crRecId = component.get('v.recordId');
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": crRecId,
            "slideDevName": "related"
        });
        navEvt.fire();
    },
    //----<!--code by Rama-->
   onChangeNew:function(component, event, helper)  
    {
        var ProductFamilyid=component.find('ChooseProductFamilyidNew').get('v.value');
        //alert('-----'+ProductFamilyid)
        //-------
        var actionp = component.get('c.CompetitorInfoPFNew');
        actionp.setParams({
            "bidid" : component.get("v.recordId"),
            "pf" : ProductFamilyid
        });
        actionp.setCallback(this, function(response) {
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") 
            {
                var result=response.getReturnValue();
                
                component.set('v.CompetitorInfowrapperNew', response.getReturnValue());
            }
        });
        $A.enqueueAction(actionp);
    },
    doInit : function(component, event, helper) {
	var actionfu = component.get("c.fetchUser");
        actionfu.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
               // set current user information on userInfo attribute
                component.set("v.userInfo", storeResponse);
            }
        });
        $A.enqueueAction(actionfu);
    },
    customerName : function(component, event, helper) {
        var actioncn = component.get("c.fetchBidCustomerName");
         actioncn.setParams({
            "bidCustName" : component.get("v.recordId")
        });
        actioncn.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                // set current user information on userInfo attribute
                component.set("v.AccountName", storeResponse);
            }
        });
        $A.enqueueAction(actioncn);
    },
    WinningCompetitorInfobuttion:function(component, event, helper) 
    {
     //--calling apex CompetitorMethod for ProductFamilyNames
        var actionp = component.get('c.collectProductFamilyNames');
        actionp.setParams({
            "CustomerResponseid" : component.get("v.recordId")
        });
        actionp.setCallback(this, function(response) {
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") 
            {
               component.set('v.ProductFamilyNames', response.getReturnValue());
            }
        });      
        
        //alert(component.get("v.recordId"));
        //***************call apex class method for records*****************
        var action = component.get('c.WinningCompetitorInfomethod');
         action.setParams({
            "CustomerResponseid" : component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") 
            {
                var result=response.getReturnValue();
             //  alert(result.length) 
                if(result.length>0)
                {
                
                    component.set('v.CompetitorInfowrapper', response.getReturnValue());
                    component.set("v.navigate",true);
                    component.set('v.newrec', false);
                }
                if(result.length===0)
                {
                    component.set("v.navigate",false);
                    component.set('v.newrec', true);
                }
                           
            }
        });     
//#####################calling apex CompetitorMethod for ProductFamilyNames for drop down #############################
       //alert(component.get("v.recordId")) 
       var actionpw = component.get('c.collectProductFamilyNamesNew');
        actionpw.setParams({
            "bidid" : component.get("v.recordId")
        });
        actionpw.setCallback(this, function(response) {
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") 
            {
              // var rec=response.getReturnValue();
              //for(var i in rec) 
             // alert(rec[i].Phoenix_Product_Family1__c)  
              component.set('v.ProductFamilyNamesNew', response.getReturnValue());
            }
        });
  //#####################call apex class method for records############################################################
        var actionNew = component.get('c.CompetitorInfoMethodnew');
        actionNew.setParams({
            "bidid" : component.get("v.recordId")
        });
        actionNew.setCallback(this, function(response) {
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") 
            {
                component.set('v.CompetitorInfowrapperNew', response.getReturnValue());
                var result=response.getReturnValue();            
            }
        });   
        $A.enqueueAction(actionp);     
        $A.enqueueAction(action);
        $A.enqueueAction(actionpw); 
        $A.enqueueAction(actionNew);          
    },
    CompetitorCancel: function(component, event, helper) 
    {
        component.set("v.navigate",false);
        component.set('v.newrec', false);
    },
    CompetitorinfoSave: function(component, event, helper) 
    {
        let journal = [];
       // var ProductNames= component.find('ProductNameauarid');
        var selectId = event.target.id;
        var BidNos=component.find('BidNoauarid');
        var ProductNames=component.find('ProductNameauarid');
        var IncumbentCompetitorName=component.find('IncumbentCompetitorNameid');
        var IncumbentPriceRanges=component.find('IncumbentPriceRangeid');
        var IncumbentCompetitorName2=component.find('IncumbentCompetitorName2id');//Adding Incumbent Values
        var IncumbentPriceRanges2=component.find('IncumbentPriceRange2id');
        var IncumbentCompetitorName3=component.find('IncumbentCompetitorName3id');//Adding Incumbent Values
        var IncumbentPriceRanges3=component.find('IncumbentPriceRange3id');
        var IncumbentCompetitorName4=component.find('IncumbentCompetitorName4id');//Adding Incumbent Values
        var IncumbentPriceRanges4=component.find('IncumbentPriceRange4id');
        var IncumbentCompetitorName5=component.find('IncumbentCompetitorName5id');//Adding Incumbent Values
        var IncumbentPriceRanges5=component.find('IncumbentPriceRange5id');
        
        var WinningCompetitoraura=component.find('WinningCompetitorauraid');
        var WinningPriceRangeaura=component.find('WinningPriceRangeauraid');
        var WinningCompetitoraura2=component.find('WinningCompetitoraura2id');//Adding Winning Values
        var WinningPriceRangeaura2=component.find('WinningPriceRangeaura2id');
        var WinningCompetitoraura3=component.find('WinningCompetitoraura3id');//Adding Winning Values
        var WinningPriceRangeaura3=component.find('WinningPriceRangeaura3id');
        var WinningCompetitoraura4=component.find('WinningCompetitoraura4id');//Adding Winning Values
        var WinningPriceRangeaura4=component.find('WinningPriceRangeaura4id');
        var WinningCompetitoraura5=component.find('WinningCompetitoraura5id');//Adding Winning Values
        var WinningPriceRangeaura5=component.find('WinningPriceRangeaura5id');
        

        if(ProductNames.length>=2 || component.find('ChooseProductFamilyid').get('v.value')!='ChooseProductFamily')
        {
        for(var i=0; i<ProductNames.length; i++) 
           {
                journal.push(
                    {
                        BidNos:component.get("v.recordId") ,
                        ProductNames: ProductNames[i].get("v.value"),
                        IncumbentCompetitorName: IncumbentCompetitorName[i].get("v.value"),
                        IncumbentPriceRanges: IncumbentPriceRanges[i].get("v.value"),
                        IncumbentCompetitorName2: IncumbentCompetitorName2[i].get("v.value"), //Adding Incumbent Values
                        IncumbentPriceRanges2: IncumbentPriceRanges2[i].get("v.value"),
                        IncumbentCompetitorName3: IncumbentCompetitorName3[i].get("v.value"), //Adding Incumbent Values
                        IncumbentPriceRanges3: IncumbentPriceRanges3[i].get("v.value"),
                        IncumbentCompetitorName4: IncumbentCompetitorName4[i].get("v.value"), //Adding Incumbent Values
                        IncumbentPriceRanges4: IncumbentPriceRanges4[i].get("v.value"),
                        IncumbentCompetitorName5: IncumbentCompetitorName5[i].get("v.value"), //Adding Incumbent Values
                        IncumbentPriceRanges5: IncumbentPriceRanges5[i].get("v.value"),
                        WinningCompetitoraura: WinningCompetitoraura[i].get("v.value"),
                        WinningPriceRangeaura: WinningPriceRangeaura[i].get("v.value"),
                        WinningCompetitoraura2: WinningCompetitoraura2[i].get("v.value"), //Adding Winning Values
                        WinningPriceRangeaura2: WinningPriceRangeaura2[i].get("v.value"),
                        WinningCompetitoraura3: WinningCompetitoraura3[i].get("v.value"),
                        WinningPriceRangeaura3: WinningPriceRangeaura3[i].get("v.value"),
                        WinningCompetitoraura4: WinningCompetitoraura4[i].get("v.value"),
                        WinningPriceRangeaura4: WinningPriceRangeaura4[i].get("v.value"),
                        WinningCompetitoraura5: WinningCompetitoraura5[i].get("v.value"),
                        WinningPriceRangeaura5: WinningPriceRangeaura5[i].get("v.value"),                      
                    }
                );
           }
        }
        else
        {
            journal.push(
                    {
                        BidNos:component.get("v.recordId") ,
                        ProductNames:component.find('ProductNameauarid').get("v.value"),
                        IncumbentCompetitorName:component.find('IncumbentCompetitorNameid').get("v.value"),
                        IncumbentPriceRanges:component.find('IncumbentPriceRangeid').get("v.value"),
                        IncumbentCompetitorName2:component.find('IncumbentCompetitorName2id').get("v.value"),
                        IncumbentPriceRanges2:component.find('IncumbentPriceRange2id').get("v.value"),
                        IncumbentCompetitorName3:component.find('IncumbentCompetitorName3id').get("v.value"),
                        IncumbentPriceRanges3:component.find('IncumbentPriceRange3id').get("v.value"),
                        IncumbentCompetitorName4:component.find('IncumbentCompetitorName4id').get("v.value"),
                        IncumbentPriceRanges4:component.find('IncumbentPriceRange4id').get("v.value"),
                        IncumbentCompetitorName5:component.find('IncumbentCompetitorName5id').get("v.value"),
                        IncumbentPriceRanges5:component.find('IncumbentPriceRange5id').get("v.value"),                      
                        WinningCompetitoraura:component.find('WinningCompetitorauraid').get("v.value"),
                        WinningPriceRangeaura:component.find('WinningPriceRangeauraid').get("v.value"),
                        WinningCompetitoraura2:component.find('WinningCompetitoraura2id').get("v.value"),
                        WinningPriceRangeaura2:component.find('WinningPriceRangeaura2id').get("v.value"),
                        WinningCompetitoraura3:component.find('WinningCompetitoraura3id').get("v.value"),
                        WinningPriceRangeaura3:component.find('WinningPriceRangeaura3id').get("v.value"),
                        WinningCompetitoraura4:component.find('WinningCompetitoraura4id').get("v.value"),
                        WinningPriceRangeaura4:component.find('WinningPriceRangeaura4id').get("v.value"),
                        WinningCompetitoraura5:component.find('WinningCompetitoraura5id').get("v.value"),
                        WinningPriceRangeaura5:component.find('WinningPriceRangeaura5id').get("v.value"),
                    }
                );
        }
         //------calling apex method to save records 
        var action = component.get('c.CompetitorInfoMethodsave');
        action.setParams({
            "resultobjs" : journal,
        });
        action.setCallback(this, function(response) {
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") 
            {
                component.set("v.navigate",false);
                
                // alert('Success records r imported successfully ')
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "type" : "success",
                    "message": "The records has been Updated successfully."
                });
                toastEvent.fire();
                window.history.go(0);
                $A.get('e.force:refreshView').fire();
                $A.get('e.force:refreshView').fire();
                $A.get('e.force:refreshView').fire();
                $A.get('e.force:refreshView').fire();
                $A.get('e.force:refreshView').fire();
                $A.get('e.force:refreshView').fire();
                
              /*  var getcodata = response.getReturnValue();
                //alert(getcodata)
                var navEvt = $A.get("e.force:navigateToSObject");
                navEvt.setParams({
                    "recordId": getcodata,
                    "slideDevName": "related"
                });
                navEvt.fire(); */              
            }            
        });
        $A.enqueueAction(action);
    },
    onChange:function(component, event, helper)  
    {
        var ProductFamilyid=component.find('ChooseProductFamilyid').get('v.value');
        //alert('-----'+ProductFamilyid)
       //-------
        var actionp = component.get('c.WinningCompetitorInfoPF');
        actionp.setParams({
            "CustomerResponseid" : component.get("v.recordId"),
            "pf" : ProductFamilyid
        });
        actionp.setCallback(this, function(response) {
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") 
            {
                var result=response.getReturnValue();
                
               component.set('v.CompetitorInfowrapper', response.getReturnValue());
            }
        });
        $A.enqueueAction(actionp);
    },
    NumSplCharsCheck: function(component, event, helper){
        var specialKeys = new Array();
        specialKeys.push(8); //Backspace
        specialKeys.push(9); //Tab
        specialKeys.push(32); //Tab
        specialKeys.push(46); //Delete
        specialKeys.push(36); //Home
        specialKeys.push(35); //End
        specialKeys.push(37); //Left
        specialKeys.push(39); //Right
        var keyCode = event.keyCode == 0 ? event.charCode : event.keyCode;
        if ((keyCode >= 65 && keyCode <= 90) || (keyCode >= 97 && keyCode <= 122) || (specialKeys.indexOf(event.keyCode) != -1 && event.charCode != event.keyCode)){
            alert("Price Range accepts only numbers and special characters. \r\n e.g: +10%, 52.5 - 56.5");
            if (event.preventDefault) {
                event.preventDefault();
            } else { 
              event.returnValue = false;
            } 
        }
    },
  CompetitorinfoSaveNew: function(component, event, helper) 
    {
        let journal = [];
       // var ProductNames= component.find('ProductNameauarid');
        var selectId = event.target.id;
        var BidNos=component.find('BidNoauarid');
        var ProductNames=component.find('ProductNameauaridNew');
        var BidLineItemNos=component.find('BidLineItemNoauraidNew');
        var Ndcs=component.find('NdcauaridNew');
        var Productfamilies=component.find('productfamilyauaridNew');
        var IncumbentCompetitorName=component.find('IncumbentCompetitorNameidNew');
        var IncumbentPriceRanges=component.find('IncumbentPriceRangeidNew');
        var IncumbentCompetitorName2=component.find('IncumbentCompetitorName2idNew');//Adding Incumbent Values
        var IncumbentPriceRanges2=component.find('IncumbentPriceRange2idNew');
        var IncumbentCompetitorName3=component.find('IncumbentCompetitorName3idNew');//Adding Incumbent Values
        var IncumbentPriceRanges3=component.find('IncumbentPriceRange3idNew');
        var IncumbentCompetitorName4=component.find('IncumbentCompetitorName4idNew');//Adding Incumbent Values
        var IncumbentPriceRanges4=component.find('IncumbentPriceRange4idNew');
        var IncumbentCompetitorName5=component.find('IncumbentCompetitorName5idNew');//Adding Incumbent Values
        var IncumbentPriceRanges5=component.find('IncumbentPriceRange5idNew');
        
        var WinningCompetitoraura=component.find('WinningCompetitorauraidNew');
        var WinningPriceRangeaura=component.find('WinningPriceRangeauraidNew');
        var WinningCompetitoraura2=component.find('WinningCompetitoraura2idNew');//Adding Winning Values
        var WinningPriceRangeaura2=component.find('WinningPriceRangeaura2idNew');
        var WinningCompetitoraura3=component.find('WinningCompetitoraura3idNew');//Adding Winning Values
        var WinningPriceRangeaura3=component.find('WinningPriceRangeaura3idNew');
        var WinningCompetitoraura4=component.find('WinningCompetitoraura4idNew');//Adding Winning Values
        var WinningPriceRangeaura4=component.find('WinningPriceRangeaura4idNew');
        var WinningCompetitoraura5=component.find('WinningCompetitoraura5idNew');//Adding Winning Values
        var WinningPriceRangeaura5=component.find('WinningPriceRangeaura5idNew');
        

        if(ProductNames.length>=2 || component.find('ChooseProductFamilyidNew').get('v.value')!='ChooseProductFamily')
        {
        for(var i=0; i<ProductNames.length; i++) 
           {
                journal.push(
                    {
                        BidNos:component.get("v.recordId") ,
                        ProductNames: ProductNames[i].get("v.value"),
                        BidLineItemNos: BidLineItemNos[i].get("v.value"),
 						Ndcs: Ndcs[i].get("v.value"),
                        Productfamilies: Productfamilies[i].get("v.value"),
                        IncumbentCompetitorName: IncumbentCompetitorName[i].get("v.value"),
                        IncumbentPriceRanges: IncumbentPriceRanges[i].get("v.value"),
                        IncumbentCompetitorName2: IncumbentCompetitorName2[i].get("v.value"), //Adding Incumbent Values
                        IncumbentPriceRanges2: IncumbentPriceRanges2[i].get("v.value"),
                        IncumbentCompetitorName3: IncumbentCompetitorName3[i].get("v.value"), //Adding Incumbent Values
                        IncumbentPriceRanges3: IncumbentPriceRanges3[i].get("v.value"),
                        IncumbentCompetitorName4: IncumbentCompetitorName4[i].get("v.value"), //Adding Incumbent Values
                        IncumbentPriceRanges4: IncumbentPriceRanges4[i].get("v.value"),
                        IncumbentCompetitorName5: IncumbentCompetitorName5[i].get("v.value"), //Adding Incumbent Values
                        IncumbentPriceRanges5: IncumbentPriceRanges5[i].get("v.value"),
                        WinningCompetitoraura: WinningCompetitoraura[i].get("v.value"),
                        WinningPriceRangeaura: WinningPriceRangeaura[i].get("v.value"),
                        WinningCompetitoraura2: WinningCompetitoraura2[i].get("v.value"), //Adding Winning Values
                        WinningPriceRangeaura2: WinningPriceRangeaura2[i].get("v.value"),
                        WinningCompetitoraura3: WinningCompetitoraura3[i].get("v.value"),
                        WinningPriceRangeaura3: WinningPriceRangeaura3[i].get("v.value"),
                        WinningCompetitoraura4: WinningCompetitoraura4[i].get("v.value"),
                        WinningPriceRangeaura4: WinningPriceRangeaura4[i].get("v.value"),
                        WinningCompetitoraura5: WinningCompetitoraura5[i].get("v.value"),
                        WinningPriceRangeaura5: WinningPriceRangeaura5[i].get("v.value"),                      
                    }
                );
           }
        }
        else
        {
            journal.push(
                    {
                        BidNos:component.get("v.recordId") ,
                        ProductNames:component.find('ProductNameauaridNew').get("v.value"),
                        BidLineItemNos: component.find('BidLineItemNoauraidNew').get("v.value"),
 						Ndcs: component.find('NdcauaridNew').get("v.value"),
                   		Productfamilies: component.find('productfamilyauaridNew').get("v.value"),
                        IncumbentCompetitorName:component.find('IncumbentCompetitorNameidNew').get("v.value"),
                        IncumbentPriceRanges:component.find('IncumbentPriceRangeidNew').get("v.value"),
                        IncumbentCompetitorName2:component.find('IncumbentCompetitorName2idNew').get("v.value"),
                        IncumbentPriceRanges2:component.find('IncumbentPriceRange2idNew').get("v.value"),
                        IncumbentCompetitorName3:component.find('IncumbentCompetitorName3idNew').get("v.value"),
                        IncumbentPriceRanges3:component.find('IncumbentPriceRange3idNew').get("v.value"),
                        IncumbentCompetitorName4:component.find('IncumbentCompetitorName4idNew').get("v.value"),
                        IncumbentPriceRanges4:component.find('IncumbentPriceRange4idNew').get("v.value"),
                        IncumbentCompetitorName5:component.find('IncumbentCompetitorName5idNew').get("v.value"),
                        IncumbentPriceRanges5:component.find('IncumbentPriceRange5idNew').get("v.value"),                      
                        WinningCompetitoraura:component.find('WinningCompetitorauraidNew').get("v.value"),
                        WinningPriceRangeaura:component.find('WinningPriceRangeauraidNew').get("v.value"),
                        WinningCompetitoraura2:component.find('WinningCompetitoraura2idNew').get("v.value"),
                        WinningPriceRangeaura2:component.find('WinningPriceRangeaura2idNew').get("v.value"),
                        WinningCompetitoraura3:component.find('WinningCompetitoraura3idNew').get("v.value"),
                        WinningPriceRangeaura3:component.find('WinningPriceRangeaura3idNew').get("v.value"),
                        WinningCompetitoraura4:component.find('WinningCompetitoraura4idNew').get("v.value"),
                        WinningPriceRangeaura4:component.find('WinningPriceRangeaura4idNew').get("v.value"),
                        WinningCompetitoraura5:component.find('WinningCompetitoraura5idNew').get("v.value"),
                        WinningPriceRangeaura5:component.find('WinningPriceRangeaura5idNew').get("v.value"),
                    }
                );
        }
         //------calling apex method to save records 
        var action = component.get('c.CompetitorInfoMethodsaveNew');
        action.setParams({
            "resultobjs" : journal,
        });
        action.setCallback(this, function(response) {
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") 
            {
                component.set("v.newrec",false);
                
                // alert('Success records r imported successfully ')
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "type" : "success",
                    "message": "The records has been Created successfully."
                });
                toastEvent.fire();
                window.history.go(0);
                $A.get('e.force:refreshView').fire();
                $A.get('e.force:refreshView').fire();
                $A.get('e.force:refreshView').fire();
                $A.get('e.force:refreshView').fire();
                $A.get('e.force:refreshView').fire();
                $A.get('e.force:refreshView').fire();
                
              /*  var getcodata = response.getReturnValue();
                //alert(getcodata)
                var navEvt = $A.get("e.force:navigateToSObject");
                navEvt.setParams({
                    "recordId": getcodata,
                    "slideDevName": "related"
                });
                navEvt.fire(); */              
            }            
        });
        $A.enqueueAction(action);
    }
 //-----<!--code end by Rama-->
})