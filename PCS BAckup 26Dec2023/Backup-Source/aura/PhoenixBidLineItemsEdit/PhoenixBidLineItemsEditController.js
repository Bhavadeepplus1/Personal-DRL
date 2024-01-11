({
    initRecords: function(component, event, helper) {
        component.set('v.recordId', component.get("v.pageReference").state.c__id);
        console.log('---record--id--from url-'+component.get('v.recordId')); 
        var action = component.get("c.getRelatedList");
        action.setParams
        ({
            bidId: component.get("v.recordId")
        });
        action.setCallback(this, function(response) 
                            {
                                var wrapperObj =  response.getReturnValue();
                                var lineItemsList = wrapperObj.lineItemsList;
                                var columnList = wrapperObj.columnList;
                                if(lineItemsList.length == 0 || component.get("v.recordId") == null){
                                    component.set("v.isRelatedLineItemsEmpty", false);
                                }
                                
                                component.set('v.defaultlistOfProductFamily', wrapperObj.productfamilyList);
                                component.set("v.BidLineItemListAll",lineItemsList);
                                var OutDiv = component.find("mainDiv");
                                if(lineItemsList.length<10){
                                     $A.util.addClass(OutDiv, "noheightClass");
                                }else{
                                     $A.util.removeClass(OutDiv, "noheightClass");
                                }
                            });
        $A.enqueueAction(action);
    }, 
    
    Save: function(component, event, helper) {
        component.find("bidForm").submit();
        component.set('v.isSpinnerLoad',true);
        console.log('after success return')
        if (helper.requiredValidation(component, event)){
            var action = component.get("c.saveAccount");
            action.setParams({
                'lstAccount': component.get("v.BidLineItemListAll")
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var storeResponse = response.getReturnValue();
                    component.set("v.BidLineItemListAll", storeResponse);
                    component.set("v.showSaveCancelBtn",false);
                    component.set('v.isSpinnerLoad',false);
                    console.log('after success return');
                }
            });
            $A.enqueueAction(action);
        }
    },
    
    cancel : function(component,event,helper){
        $A.get('e.force:refreshView').fire();
    },
    showSaveCancel : function(component,event,helper){
       component.set("v.showSaveCancelBtn",true);
    },
    SaveAndNavigate:  function(component,event,helper){
        $A.enqueueAction(component.get('c.Save'));
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
    },
    searchProFamilyChange: function(component, event) {
        component.set('v.isSpinnerLoad',true);
        if(component.get("v.lstSelectedRecords").length > 0 || component.get("v.RxSrxList").length > 0){
             var action = component.get("c.findByProductFamily");
        action.setParams({
            "searchKey": component.get("v.lstSelectedRecords"),
            "lineItemId" : component.get("v.recordId"),
            "sRxOtcList" : component.get("v.RxSrxList"),
        });
        action.setCallback(this, function(a) {
             var lineItemsList =a.getReturnValue();
            component.set("v.BidLineItemListAll", lineItemsList);
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
   
            
        }else{
            component.set('v.isSpinnerLoad',false);
            $A.enqueueAction(component.get('c.initRecords'));
        }
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
    },
    
 })