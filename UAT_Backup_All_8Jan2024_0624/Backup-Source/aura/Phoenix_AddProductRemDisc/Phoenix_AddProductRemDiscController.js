({
    
doInit : function(component,event,helper) {
    var bidId = component.get("v.recordId");
    console.log('bidId-----'+bidId);
        
    var getQuoteInfo = component.get("c.getbidInfo");
    getQuoteInfo.setParams({ "bidId": bidId });
    getQuoteInfo.setCallback(this, function (response) {
        var actState = response.getState();
            
        if (actState === 'SUCCESS') {
                 
              component.set("v.showSpinnerSelProds",true);
            component.set("v.wrap", response.getReturnValue());
            if(component.get('v.wrap.bid.Phoenix_Approval_Status__c') != 'Draft' && component.get('v.wrap.bid.Phoenix_Approval_Status__c') != '' && component.get('v.wrap.bid.Phoenix_Approval_Status__c') != null && component.get('v.wrap.bid.Phoenix_Approval_Status__c') !=undefined) {
                    component.set('v.showDraftView',false);
                }
            console.log("wrap-----"+JSON.stringify(response.getReturnValue()));
            helper.loadProducts(component,helper);
                
                
        }
    });
    $A.enqueueAction(getQuoteInfo);
/*Selected records count*/
        var action = component.get("c.showselectedProducts");
        action.setParams({ "bidId": component.get("v.recordId") });
        action.setCallback(this, function (response) {
            var actState = response.getState();
            console.log('actState' + actState)
            if (actState === 'SUCCESS') {
                var resposeData = response.getReturnValue();
                component.set("v.selectedProductsCount",resposeData.length);  
                console.log('---count--'+resposeData.length);
                //alert(component.get('v.selectedProductsCount'));
            }
                
        });
        $A.enqueueAction(action);
},
onsearchDirector: function (component, event, helper) {
       
      var SearchKeyWordPD = component.get("v.lstSelectedPDRecords");
    console.log('SearchKeyWordPD----'+SearchKeyWordPD);
    if(SearchKeyWordPD!=null && SearchKeyWordPD!='' && SearchKeyWordPD!=undefined){
            
        helper.onsearchDirectorhelper(component,helper);   
    }
        
},
 onblurProDir : function(component,event,helper){
    // on mouse leave clear the listOfSeachRecords & hide the search result component
    var toggleclass = component.find("zvalue");      
    $A.util.addClass(toggleclass, "zindex");  
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
clearProdDir :function(component,event,helper){
    var selectedPillId = event.getSource().get("v.name");
    var AllPillsList = component.get("v.lstSelectedPDRecords"); 
        
    for(var i = 0; i < AllPillsList.length; i++){
        if(AllPillsList[i] == selectedPillId){
            AllPillsList.splice(i, 1);
            component.set("v.lstSelectedPDRecords", AllPillsList);
        }  
    }
    component.set("v.SearchKeyWordPD",null);
      // component.set("v.showSpinnerSelProds",true);
    component.set("v.listOfSearchPDRecords", null ); 
    component.set("v.noData",false);
    var searchFamily = component.get("v.searchFamily");
    var searchName=component.get("v.searchText");
    console.log('searchName-------'+searchName);
      var SearchKeyWordPD = component.get("v.lstSelectedPDRecords");
      var RxSrxList = component.get("v.RxSrxList");
     if(!SearchKeyWordPD.length>0){
       
    if(searchName!=null && searchName!='undefined' && searchName!=''){
        helper.searchTablehelper(component,helper); 
    }
    else if(searchFamily!=null && searchFamily!='undefined' && searchFamily!=''){
         helper.onsearchFamilyhelper(component, helper);  
    }
    else if(SearchKeyWordPD.length>0){
        helper.onsearchDirectorhelper(component,helper);   
    }
        else if(RxSrxList.length>0){
            helper.searchRx(component, helper);
        }
            else{
                component.set("v.showSpinnerSelProds",true);
               var resposeData=component.get("v.Allproduct");
        component.set("v.totalPages", Math.ceil(resposeData.length / component.get("v.pageSize")));
                        component.set("v.allData", resposeData);
                            
                        component.set("v.currentPageNumber", 1);
                        helper.buildData(component, helper);
                component.set("v.showSpinnerSelProds",false);
            }
     }
    else{
      if(SearchKeyWordPD.length>0){
        helper.onsearchDirectorhelper(component,helper);   
    }   
    }
}, 
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
    
    
onsearch: function (component, event, helper) {
        
    component.set("v.noData",false);
    var searchFamily = component.get("v.searchFamily");
    var searchName=component.get("v.searchText");
    console.log('searchName-------'+searchName);
      var SearchKeyWordPD = component.get("v.lstSelectedPDRecords");
      var RxSrxList = component.get("v.RxSrxList");
        
    //component.set("v.showSpinnerSelProds",true);
    if(searchName==null || searchName=='undefined' || searchName==''){
    if(searchName!=null && searchName!='undefined' && searchName!=''){
        helper.searchTablehelper(component,helper); 
    }
    else if(searchFamily!=null && searchFamily!='undefined' && searchFamily!=''){
         helper.onsearchFamilyhelper(component, helper);  
    }
    else if(SearchKeyWordPD.length>0){
        helper.onsearchDirectorhelper(component,helper);   
    }
        else if(RxSrxList.length>0){
            helper.searchRx(component, helper);
        }
            else{
                component.set("v.showSpinnerSelProds",true);
               var resposeData=component.get("v.Allproduct");
        component.set("v.totalPages", Math.ceil(resposeData.length / component.get("v.pageSize")));
                        component.set("v.allData", resposeData);
                            
                        component.set("v.currentPageNumber", 1);
                        helper.buildData(component, helper); 
                component.set("v.showSpinnerSelProds",false);
            }
    }
        
        
},
onsearchFamily: function (component, event, helper) {
        
    component.set("v.noData",false);
    var searchFamily = component.get("v.searchFamily");
     var searchName=component.get("v.searchText");
     var SearchKeyWordPD = component.get("v.lstSelectedPDRecords");
      var RxSrxList = component.get("v.RxSrxList");
        if(searchFamily!=null && searchFamily!='' && searchFamily!=undefined){
        helper.onsearchFamilyhelper(component,helper);   
        }
    else if(searchName!=null && searchName!='' && searchName!=undefined){
          helper.searchTablehelper(component,helper);
    }
     else if(SearchKeyWordPD.length>0){
           helper.onsearchDirectorhelper(component,helper);   
    }
    else if(RxSrxList.length>0){
            helper.searchRx(component, helper);   
    }
        
},
onchangeFamily:  function (component, event, helper) {
      var searchFamily = component.get("v.searchFamily");
    var searchName=component.get("v.searchText");
    console.log('searchName-------'+searchName);
   component.set("v.noData",false);
      var SearchKeyWordPD = component.get("v.lstSelectedPDRecords");
     console.log('searchFamily-------'+searchFamily);
     console.log('SearchKeyWordPD-------'+SearchKeyWordPD);
      var RxSrxList = component.get("v.RxSrxList");
     console.log('RxSrxList-------'+RxSrxList);
     if(searchFamily==null || searchFamily=='undefined' || searchFamily==''){
    if(searchName!=null && searchName!='undefined' && searchName!=''){
        helper.searchTablehelper(component,helper); 
    }
    else if(searchFamily!=null && searchFamily!='undefined' && searchFamily!=''){
         helper.onsearchFamilyhelper(component, helper);  
    }
    else if(SearchKeyWordPD.length>0){
        helper.onsearchDirectorhelper(component,helper);   
    }
        else if(RxSrxList.length>0){
            helper.searchRx(component, helper);
        }
            else{
                component.set("v.showSpinnerSelProds",true);
               var resposeData=component.get("v.Allproduct");
        component.set("v.totalPages", Math.ceil(resposeData.length / component.get("v.pageSize")));
                        component.set("v.allData", resposeData);
                            
                        component.set("v.currentPageNumber", 1);
                        helper.buildData(component, helper); 
                component.set("v.showSpinnerSelProds",false);
            }
     }
},
    
    
searchTable: function (component, event, helper) {
        
    var searchName=component.get("v.searchText");
    if(searchName!=null && searchName!='' && searchName!=undefined){
            
        helper.searchTablehelper(component,helper);
    }
        
        
},
    
ShowBackContractList: function (component, event, helper) {
        
    component.set("v.showProducts", false);
    component.set("v.showSelectedProducts", false);
    component.set("v.showuploadFile", false);
    component.set("v.showselectedContracts", true);
        
    //var qt = component.get("v.QLlist");
    //component.set("v.QLlist1", qt);
        
        
        
},
ShowFileUpload: function (component, event, helper) {
    component.set("v.showProducts", false);
    component.set("v.showSelectedProducts", false);
    component.set("v.showuploadFile", true);
    component.set("v.showselectedContracts", false);
    component.set("v.showApprovals", false);
        
},
submitForApproval:function (component, event, helper) {
        
},
    
clickApproval: function (component, event, helper) {
     var fileList=component.get("v.fileList");
    console.log('fileList--------'+JSON.stringify(fileList));
    //if(fileList!=null && fileList!=undefined && fileList!=''){
    component.set("v.showApprovals", false); 
    component.set("v.showuploadFile", false);
    component.set("v.showProducts", false);
    component.set("v.showselectedContracts", false);
     /*var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
                "type": 'success',
                "message": "File was added to the Bid."
            }); 
         toastEvent.fire();   */ 
    var dismissActionPanel = $A.get("e.force:closeQuickAction");
    dismissActionPanel.fire();
var urlEvent = $A.get("e.force:navigateToURL");
    urlEvent.setParams({
        "url": "/lightning/cmp/c__Phoenix_ProductremDiscEditBidLines?c__recordId="+component.get("v.recordId")
    }); 
    urlEvent.fire();
   // }
    /*else{
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
                "type": 'error',
                "message": "Please upload the files."
            }); 
         toastEvent.fire();
    }*/
},
fileUpload: function (component, event, helper) {
    component.set("v.showSpinnerSelProds",true);
    component.set("v.showProducts", false);
    component.set("v.showSelectedProducts", false);
    component.set("v.showuploadFile", true);
    component.set("v.showselectedContracts", false); 
    component.set("v.showbutton",false);
    var savecontrs=new Array();
    var quoteId =component.get("v.recordId");
    var contractList=component.get("v.allContracts");
    var selectedContractIds=component.get("v.selectedContractIds");
        
    for(var j=0;j<contractList.length;j++){
        if(selectedContractIds.includes(contractList[j].npr.Id)){
            savecontrs.push(contractList[j]); 
        }
            
    }
        
        
    console.log('saveContracts----'+JSON.stringify(savecontrs));
        
        
    component.set("v.ContrItems",savecontrs);
        
        
    var savecontract=component.get("v.ContrItems");
    var action = component.get('c.insertContrProducts');
        
        
        
    action.setParams({"savecontrs":savecontract,"bidId": quoteId });
        
    action.setCallback(this, function (response) {
            
        var actState = response.getState();
        console.log('actState' + actState)
        if (actState === 'SUCCESS') {
            component.set("v.showSpinnerSelProds",false);
            var resposeData = response.getReturnValue();
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type": 'success',
                "message": "New Line Items has been added successfully."
            });
            toastEvent.fire();
               
            console.log('resposeData--------'+resposeData);
            helper.getDocumentForBid(component,helper);
                
                
            component.set("v.showSpinnerSelProds",false);
                
                
        }
        else{
            component.set("v.showSpinnerSelProds",false);
        }
    });
    $A.enqueueAction(action);
},
    
    
    
closeModal: function (component, event, helper) {
    component.set("v.showSelectedProducts", false);
    component.set("v.showProducts", false);
        
        
        
    let recordId =component.get("v.recordId");
    var selIds=component.get("v.selectedProductsIds");
    var alldata=component.get("v.allData");
    var UpdateAllData=[];
    for(var i=0;i<alldata.length;i++){
        if (selIds.includes(alldata[i].prdlist.Id)) 
        {
                
            alldata[i].isSelected = false;
            UpdateAllData.push(alldata[i]);
        }
            
    }
        
    component.set("v.allData",UpdateAllData);
    var selectedProducts=[];
    component.set("v.selectedProductsIds",selectedProducts);
    var getSelectedNumber = 0;
    component.set("v.selectedCount",getSelectedNumber);
    var count=0;
    var searchText='';
    component.set("v.searchText",searchText);
    for(var i=0;i<alldata.length;i++){
        if (alldata[i].isSelected==false)
        {
            count++;     
                
        }
            
    }
        
        
        
        
        
        
        
    if (recordId != null && recordId != undefined && recordId != '') {
        // Go to record
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
            
    } 
        
        
        
},
selectAllCheckbox : function (component, event, helper){
        
            component.set("v.showSpinnerSelProds",true);//showSpinnerSelProds

    var selectedHeaderCheck = event.getSource().get("v.checked");
    console.log('selectedHeaderCheck &&&&&'+selectedHeaderCheck);
    console.log('showSpinnerSelProds &&&&&'+component.get("v.showSpinnerSelProds"));
    var allRecords=component.get("v.allData");
    var updatedAllRecords=[];
    var updatedPageList=[];
        
    var ProductList=component.get("v.ProductList");
    var getSelectedNumber = component.get("v.selectedCount");
        
    var selIds=component.get("v.selectedProductsIds");
    for(var j=0;j<allRecords.length;j++){
        if(selectedHeaderCheck==true){
            component.set("v.showSpinnerSelProds",true);
    console.log('showSpinnerSelProds &&&&&'+component.get("v.showSpinnerSelProds"));
            allRecords[j].isSelected=selectedHeaderCheck;
            if(selIds.includes(allRecords[j].prdlist.Id)){
                continue; 
            }
                
            selIds.push(allRecords[j].prdlist.Id);
                
        }
        else{
                
                
            const index = selIds.indexOf(allRecords[j].prdlist.Id);
            if (index > -1) {
                selIds.splice(index, 1);
            }
                
            allRecords[j].isSelected=selectedHeaderCheck;
            var arry = component.get("v.QLlist1");
                
            if(arry!=null && arry!=undefined && arry!=''){
                    
                    
                if (arry.length > 0) {
                        
                    for (var i = 0; i < arry.length; i++) {
                        if (arry[i].npr.Phoenix_Product__c === allRecords[j].prdlist.Id) {
                            arry.splice(i, 1);
                                
                        }
                    }
                    component.set("v.QLlist1", arry);
                        
                }
            }
                
                
        }
            
    }
    for(var j=0;j<ProductList.length;j++){
        if(selectedHeaderCheck==true){
                
            ProductList[j].isSelected=selectedHeaderCheck;
            if(selIds.includes(ProductList[j].prdlist.Id)){
                continue; 
            }
                
            selIds.push(ProductList[j].prdlist.Id);
                
        }
        else{
                
                
            const index = selIds.indexOf(ProductList[j].prdlist.Id);
            if (index > -1) {
                selIds.splice(index, 1);
            }
                
            ProductList[j].isSelected=selectedHeaderCheck;
            var arry = component.get("v.QLlist1");
                
            if(arry!=null && arry!=undefined && arry!=''){
                    
                    
                if (arry.length > 0) {
                        
                    for (var i = 0; i < arry.length; i++) {
                        if (arry[i].npr.Phoenix_Product__c === allRecords[j].prdlist.Id) {
                            arry.splice(i, 1);
                                
                        }
                    }
                    component.set("v.QLlist1", arry);
                        
                }
            }
                
                
        }
            
    }
    helper.buildData(component, helper);
        
    component.set("v.selectedProductsIds",selIds);
    var selectedProdcount=component.get("v.selectedProductsIds").length;
        
    component.set("v.selectedCount", selectedProdcount);
    var count = component.get("v.selectedCount")
    if (count > 0) {
        component.set("v.showbutton", false);
    }
    else if (count == 0) {
        component.set("v.showbutton", true);
    }
    component.set("v.showSpinnerSelProds",false);
    console.log('showSpinnerSelProds &&&&&'+component.get("v.showSpinnerSelProds"));
        
},
checkBoxChangeHandler: function (component, event, helper) {
    var selectedRec = event.getSource().get("v.checked");
    var selectedRec1 = event.getSource().get("v.name");
        
        
    var getSelectedNumber = component.get("v.selectedCount");
    var allProds = component.get("v.Allproduct");
    var selIds = [];
        
    if (selectedRec == true) {
        getSelectedNumber++;
        var selProds = component.get("v.selectedProductsIds");
            
        selIds = selProds;
        selIds.push(selectedRec1);
        var arry = component.get("v.QLlist1");
            
            
            
    }
        
    else {
        getSelectedNumber--;
        var selProds = component.get("v.selectedProductsIds");
        selIds = selProds;
        var prodId = event.getSource().get("v.name");
            
        const index = selIds.indexOf(prodId);
        if (index > -1) {
            selIds.splice(index, 1);
        }
        var arry = component.get("v.QLlist1");
            
        if(arry!=null && arry !=undefined && arry!=''){
                
                
            if (arry.length > 0) {
                    
                for (var i = 0; i < arry.length; i++) {
                    if (arry[i].npr.Phoenix_Product__c === prodId) {
                        arry.splice(i, 1);
                            
                    }
                }
                component.set("v.QLlist1", arry);
                    
            }
        }
            
            
    }
        
        
    component.set("v.selectedProductsIds", selIds);
        
    component.set("v.selectedCount", getSelectedNumber);
    var count = component.get("v.selectedCount");
    if (count > 0) {
        component.set("v.showbutton", false);
    }
    else if (count == 0) {
        component.set("v.showbutton", true);
    }
    //helper.buildData(component, helper); 
},
    
processProducts: function (component, event, helper) {
    component.set("v.showProducts", false);
    //component.set("v.showSpinnerSelProds",true);
    component.set("v.showContracts", true);
    component.set("v.isQLlistempty",false);
    component.set("v.noContrData",false); 
    component.set("v.showbutton",false);
    var data;
    var contrData=[];
    var selectedContractIds=component.get("v.selectedContractIds");
    //component.set("v.showContracts",true);
    component.set("v.showSelectedProducts", false);
    component.set("v.showSpinnerSelProds",true);
        
    var prdlist1 = component.get("v.selectedProductsIds");
        
        
    var getProductsAction = component.get("c.getQuoteLineItems");
        
    getProductsAction.setParams({ "prdlist": prdlist1,
                                 "bidId":component.get("v.recordId")});
        
    getProductsAction.setCallback(this, function (response) {
        var actState = response.getState();
        //var arry = component.get("v.QLlist1");
            
        if (actState === "SUCCESS") {
                
                
            var response=response.getReturnValue();
            console.log('response -----'+response); 
                
            //component.set("v.showContracts",true);
            component.set("v.showSpinnerSelProds",false);
            if(response!=null && response!=undefined && response!=''){
                component.set("v.noContrData",false);  
                var quotewrap=component.get("v.wrap");
                if(quotewrap.bid.Phoenix_Bid_Type__c=='Mass Product Removals'){
                    component.set("v.showbidType",true);
                }
                else{
                    component.set("v.showbidType",false);  
                }
                    
                component.set("v.totalPages1", Math.ceil(response.length/ component.get("v.pageSize")));
                console.log('totalPages1 -----'+component.get("v.totalPages1"));
                component.set("v.allContracts", response);
                component.set("v.allContractCopy",response);
                component.set("v.currentPageNumber1", 1);
                helper.buildContractData(component, helper);
                    
            }
            else{
                var res=[];
                component.set("v.noContrData",true); 
                component.set("v.contractList",res);
            }
            console.log('noContrData -----'+component.get("v.noContrData"));
                
                
                
        }
        else{
            component.set("v.showSpinnerSelProds",false);
        }
    });
    $A.enqueueAction(getProductsAction);
},
    
    
    
insertProducts: function (component, event, helper) {
        
    component.set("v.showSpinnerSelProds",true);
    component.set("v.showbutton",false);
    var quoteId =component.get("v.recordId");
    console.log('quoteId-------'+quoteId);
    var  saveitems1=[];
    saveitems1=component.get("v.QLlist");
    var contractList=component.get("v.allContracts");
    var ids=new Array();
    var savecontrs=new Array();
    var selectedContractIds=component.get("v.selectedContractIds");
        
    for(var j=0;j<contractList.length;j++){
        if(selectedContractIds.includes(contractList[j].npr.Id)){
            savecontrs.push(contractList[j]); 
        }
            
    }
        
        
        
    component.set("v.ContrItems",savecontrs);
        
        
    var savecontract=component.get("v.ContrItems");
    var action = component.get('c.insertContrProducts');
        
        
        
    action.setParams({"savecontrs":savecontract,"bidId": component.get("v.recordId") });
        
    action.setCallback(this, function (response) {
            
        var actState = response.getState();
        console.log('actState' + actState)
        if (actState === 'SUCCESS') {
            component.set("v.showSpinnerSelProds",false);
            var resposeData = response.getReturnValue();
                
            console.log('resposeData----'+resposeData);
                
                
            component.set("v.showSelectedProducts", false);
            component.set("v.showProducts", false);
            component.set("v.showContracts", false);
                
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type": 'success',
                "message": "New Line Items has been added successfully."
            });
            toastEvent.fire();
            var dismissActionPanel = $A.get("e.force:closeQuickAction");
            dismissActionPanel.fire();
            var urlEvent = $A.get("e.force:navigateToURL");
            urlEvent.setParams({
                "url": "/lightning/cmp/c__Phoenix_ProductremDiscEditBidLines?c__recordId="+component.get("v.recordId")
            }); 
            urlEvent.fire();
                
        }
        else{
            component.set("v.showSpinnerSelProds",false);
        }
    });
    $A.enqueueAction(action);
        
        
},
    
removeDeletedRow: function (component, event, helper) {
        
    var selectedRec = event.getSource().get("v.name");
        
    var AllRowsList = component.get("v.selectedContracts");
        
    if (AllRowsList.length === 1) {
        console.log('AllRowsList.length === 1');
            
    }
        
        
        
    for (let i = 0; i < AllRowsList.length; i++) {
            
        var pItem = AllRowsList[i];
            
        if (pItem.npr.Id == selectedRec) {
                
            var index = AllRowsList.indexOf(pItem);
            if (index > -1) {
                    
                AllRowsList.splice(index, 1);
                var AllRowsList1 = AllRowsList;
                    
            }
                
        }
    }
        
    component.set("v.selectedContracts",[]);
    component.set("v.selectedContracts", AllRowsList);
        
    if (AllRowsList.length === 0) {
        component.set("v.isQLlistempty", true);
    }
    else
        component.set("v.isQLlistempty", false);
        
        
        
        
    //var saveditems = component.get("v.QLlist");
    var contractList=component.get("v.contractList");
    var allContracts=component.get("v.allContracts");
        
    var prdlist1=[];
    component.set("v.selectedContractIds",[]);
        
    var count=0;
        
        
    if(AllRowsList!=undefined && AllRowsList!=null && AllRowsList!='' && AllRowsList.length>0)
    {
            
            
        for (let i = 0; i < AllRowsList.length; i++) {
                
            for (let j = 0; j < allContracts.length; j++) {
                if (allContracts[j].npr.Id == AllRowsList[i].npr.Id)
                {
                        
                        
                    count=count+1;
                    allContracts[j].contrFlag=true;
                        
                    prdlist1.push(allContracts[j].npr.Id);
                    break;
                }                                   
            }
                
        }
    }
        
    component.set("v.contractCount",count);
    if(count==0)
        component.set("v.showbutton",true);
    else
        component.set("v.showbutton",false);
        
    component.set("v.selectedContractIds",prdlist1);
    console.log('selectedContractIds length'+prdlist1.length);
        
    helper.buildContractData(component, helper);
},
    
onNext: function (component, event, helper) {
     var elmnt = document.getElementById("myDIV");
  elmnt.scrollTop=0;
    var pageNumber = component.get("v.currentPageNumber");
    component.set("v.currentPageNumber", pageNumber + 1);
    helper.buildData(component, helper);
},
    
onPrev: function (component, event, helper) {
     var elmnt = document.getElementById("myDIV");
elmnt.scrollTop=0;
    var pageNumber = component.get("v.currentPageNumber");
    component.set("v.currentPageNumber", pageNumber - 1);
    helper.buildData(component, helper);
},
    
processMe: function (component, event, helper) {
     var elmnt = document.getElementById("myDIV");
elmnt.scrollTop=0;
    component.set("v.currentPageNumber", parseInt(event.target.name));
    helper.buildData(component, helper);
},
    
onFirst: function (component, event, helper) {
     var elmnt = document.getElementById("myDIV");
elmnt.scrollTop=0;
    component.set("v.currentPageNumber", 1);
    helper.buildData(component, helper);
},
    
onLast: function (component, event, helper) {
     var elmnt = document.getElementById("myDIV");
elmnt.scrollTop=0;
    component.set("v.currentPageNumber", component.get("v.totalPages"));
    helper.buildData(component, helper);
},
onPageNext: function (component, event, helper) {
     var elmnt = document.getElementById("mycontrDIV");
elmnt.scrollTop=0;
    var pageNumber = component.get("v.currentPageNumber1");
    component.set("v.currentPageNumber1", pageNumber + 1);
    helper.buildContractData(component, helper);
},
    
onPagePrev: function (component, event, helper) {
     var elmnt = document.getElementById("mycontrDIV");
elmnt.scrollTop=0;
    var pageNumber = component.get("v.currentPageNumber1");
    component.set("v.currentPageNumber1", pageNumber - 1);
    helper.buildContractData(component, helper);
},
    
PageprocessMe: function (component, event, helper) {
     var elmnt = document.getElementById("mycontrDIV");
elmnt.scrollTop=0;
    component.set("v.currentPageNumber1", parseInt(event.target.name));
    helper.buildContractData(component, helper);
},
    
onPageFirst: function (component, event, helper) {
     var elmnt = document.getElementById("mycontrDIV");
elmnt.scrollTop=0;
    component.set("v.currentPageNumber1", 1);
    helper.buildContractData(component, helper);
},
    
onPageLast: function (component, event, helper) {
     var elmnt = document.getElementById("mycontrDIV");
elmnt.scrollTop=0;
    component.set("v.currentPageNumber1", component.get("v.totalPages1"));
    helper.buildContractData(component, helper);
},
    
    
showSelectedproducts:function(component,event,helper){
    component.set("v.isModalOpen",true);
        
    var showselectedIds=component.get("v.selectedProductsIds");
    var alldata=component.get("v.allData");
    var modalProductList=[];
        
    var action = component.get("c.showselectedProducts");
    console.log('hI');
   action.setParams({ "bidId": component.get("v.recordId") });
        
    action.setCallback(this, function (response) {
            
        var actState = response.getState();
        console.log('actState' + actState)
        if (actState === 'SUCCESS') {
            component.set("v.showSpinnerSelProds",false);
            var resposeData = response.getReturnValue();
            console.log('respose-------Data'+JSON.stringify(resposeData));
              
                
                
         component.set("v.modalProductList",resposeData);  
                
            }
            
    });
    $A.enqueueAction(action);
        
},
closePopup:function(component,event,helper){
    component.set("v.isModalOpen",false);    
},
sortProductName: function(component, event, helper) {
    // set current selected header field on selectedTabsoft attribute.    
    component.set("v.selectedTabsoft", 'ProductName');
    // call the helper function with pass sortField Name  
    helper.sortHelper(component, event, 'Name');
},
    
sortProductCode: function(component, event, helper) {
    // set current selected header field on selectedTabsoft attribute.    
    component.set("v.selectedTabsoft", 'ProductCode');
    // call the helper function with pass sortField Name  
    helper.sortHelper(component, event, 'ProductCode');
},
    
sortProductFamily: function(component, event, helper) {
    // set current selected header field on selectedTabsoft attribute.        
    component.set("v.selectedTabsoft", 'ProductFamily');
    // call the helper function with pass sortField Name      
    helper.sortHelper(component, event, 'Family');
},
sortProductDirector: function(component, event, helper) {
    // set current selected header field on selectedTabsoft attribute.    
    component.set("v.selectedTabsoft", 'ProductDirector');
    // call the helper function with pass sortField Name  
    helper.sortHelper(component, event, 'Phoenix_Product_Director__c');
},
    
sortGPI: function(component, event, helper) {
    // set current selected header field on selectedTabsoft attribute.    
    component.set("v.selectedTabsoft", 'GPI');
    // call the helper function with pass sortField Name  
    helper.sortHelper(component, event, 'Phoenix_GPI_Generic_Product_Identifier__c');
},
sortGCN: function(component, event, helper) {
    // set current selected header field on selectedTabsoft attribute.    
    component.set("v.selectedTabsoft", 'GCN');
    // call the helper function with pass sortField Name  
    helper.sortHelper(component, event, 'Phoenix_GCN_Generic_Code_Number__c');
},
    
sortNDC11: function(component, event, helper) {
    // set current selected header field on selectedTabsoft attribute.        
    component.set("v.selectedTabsoft", 'NDC11');
    // call the helper function with pass sortField Name      
    helper.sortHelper(component, event, 'Phoenix_NDC_11__c');
},
sortUPC: function(component, event, helper) {
    // set current selected header field on selectedTabsoft attribute.        
    component.set("v.selectedTabsoft", 'UPC');
    // call the helper function with pass sortField Name      
    helper.sortHelper(component, event, 'Phoenix_UPC_Universal_Product_Code__c');
},
sortStrength: function(component, event, helper) {
    // set current selected header field on selectedTabsoft attribute.        
    component.set("v.selectedTabsoft", 'Strength');
    // call the helper function with pass sortField Name      
    helper.sortHelper(component, event, 'Phoenix_Strength__c');
},
sortPackSize: function(component, event, helper) {
    // set current selected header field on selectedTabsoft attribute.        
    component.set("v.selectedTabsoft", 'PackSize');
    // call the helper function with pass sortField Name      
    helper.sortHelper(component, event, 'Phoenix_Pkg_Size__c');
},
sortWAC: function(component, event, helper) {
    // set current selected header field on selectedTabsoft attribute.        
    component.set("v.selectedTabsoft", 'WAC');
    // call the helper function with pass sortField Name      
    helper.sortHelper(component, event, 'Phoenix_WAC__c');
},
sortBrandName: function(component, event, helper) {
    // set current selected header field on selectedTabsoft attribute.        
    component.set("v.selectedTabsoft", 'BrandName');
    // call the helper function with pass sortField Name      
    helper.sortHelper(component, event, 'Phoenix_Compare_to_Brand_Name__c');
},
    
sortDiscontinuation: function(component, event, helper) {
    // set current selected header field on selectedTabsoft attribute.        
    component.set("v.selectedTabsoft", 'Discontinuation');
    // call the helper function with pass sortField Name      
    helper.sortHelper(component, event, 'Phoenix_Date_of_Discontinuation__c');
},
searchSrxRxOttc : function(component,event,helper){
    helper.searchRx(component, helper);
},
    
sortContractNumber:function(component, event, helper){
    component.set("v.selectedTabsoft", 'ContractNumber');
    // call the helper function with pass sortField Name      
    helper.sortContrHelper(component, event, 'Phoenix_Contract__r.Phoenix_Contract_Number__c');
},
/* sortContractOwner:function(component, event, helper){
    component.set("v.selectedTabsoft", 'ContractOwner');
    // call the helper function with pass sortField Name      
    helper.sortContrHelper(component, event, 'Owner.Name');
},*/
    
sortNPR:function(component, event, helper){
    component.set("v.selectedTabsoft", 'NPR');
    // call the helper function with pass sortField Name      
    helper.sortContrHelper(component, event, 'Name');
},
sortProduct:function(component, event, helper){
    component.set("v.selectedTabsoft", 'Product');
    // call the helper function with pass sortField Name      
    helper.sortContrHelper(component, event, 'Phoenix_Product__r.Name');
},
sortCustomer:function(component, event, helper){
    component.set("v.selectedTabsoft", 'Customer');
    // call the helper function with pass sortField Name      
    helper.sortContrHelper(component, event, 'Phoenix_Contract__r.Phoenix_Customer__r.Name');
},
    
/*sortCustomerNumber:function(component, event, helper){
    component.set("v.selectedTabsoft", 'CustomerNumber');
    // call the helper function with pass sortField Name      
    helper.sortContrHelper(component, event, 'Phoenix_Customer_Number__c');
},*/
sortProductFamily:function(component, event, helper){
    component.set("v.selectedTabsoft", 'ProductFamily');
    // call the helper function with pass sortField Name      
    helper.sortContrHelper(component, event, 'Phoenix_Product__r.Family');
},
sortNDC:function(component, event, helper){
    component.set("v.selectedTabsoft", 'NDC');
    // call the helper function with pass sortField Name      
    helper.sortContrHelper(component, event, 'Phoenix_Product__r.Phoenix_NDC_11__c');
},
sortRequiredNoticePeriod:function(component, event, helper){
    component.set("v.selectedTabsoft", 'RequiredNoticePeriod');
    // call the helper function with pass sortField Name  
    if(component.get("v.showbidType")==true){     
        helper.sortContrHelper(component, event, 'Phoenix_Contract__r.Phoenix_Terms_Matrix__r.Phoenix_Days_Notice_for_Prod_Rem_Disco__c');
    }
    else{
        helper.sortContrHelper(component, event, 'Phoenix_Contract__r.Phoenix_Terms_Matrix__r.Phoenix_Days_Notice_Prod_Discontinuation__c');
    }
},
/*addToContracts:function(component, event, helper){
        
    component.set("v.showProducts", false);
    //component.set("v.showSelectedProducts", false);
    //component.set("v.showContracts",true);
    var saveditems = component.get("v.QLlist");
    var hightlightedItems=[];
    for(var i=0;i<saveditems.length;i++){
        if(saveditems[i].qlItem.Phoenix_Proposed_IPA_Price__c<saveditems[i].IPAPrice){
            hightlightedItems.push(saveditems[i].qlItem.Phoenix_Product__c);   
        } 
            
            
    }
    if(hightlightedItems.length>0){
        //component.set("v.showTooltip",true); 
            
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type": 'Info',
            "message": "The Hightlighted Line Items need to get approvals."
        });
        toastEvent.fire();
    }
        
    //if(!component.get("v.showTooltip")){
    helper.getContractData(component, helper);  
    // }
        
        
    console.log('hightlightedItems----------'+hightlightedItems);
        
        
},*/
closeTooltip: function(component, event, helper){
    component.set("v.showTooltip",false); 
},
ShowSelectedProdList:function(component, event, helper){
    component.set("v.showProducts", true);
    //component.set("v.showSelectedProducts", true);
    component.set("v.showContracts", false);
    component.set("v.noContractData",false);
    component.set("v.searchContract",'');
    var contractCopyList=component.get("v.contractList");
    component.set("v.contractCopyList",contractCopyList);
        
},
onselectAllContract: function(component, event, helper){
    var selectedHeaderFlag = event.getSource().get("v.checked");
    var allContracts=component.get("v.contractList"); 
    var selIds=component.get("v.selectedContractIds");
    for(var j=0;j<allContracts.length;j++){
        if(selectedHeaderFlag==true){
                
            allContracts[j].contrFlag=selectedHeaderFlag;
            if(selIds.includes(allContracts[j].npr.Id)){
                continue; 
            }
                
            selIds.push(allContracts[j].npr.Id);
                
        }
        else{
                
                
            const index = selIds.indexOf(allContracts[j].npr.Id);
            if (index > -1) {
                selIds.splice(index, 1);
            }
                
            allContracts[j].contrFlag=selectedHeaderFlag;
        }
            
            
    }
    component.set("v.contractCount",selIds.length);
    component.set("v.selectedContractIds",selIds);
    component.set("v.contractList",allContracts);
},
    
contractCheckBoxHandler: function(component, event, helper){
    var selectedFlag = event.getSource().get("v.checked");
    var selectedContrId = event.getSource().get("v.name");
    var selIds=[];
    var selectAllContr=component.get("v.selectAllContr");
    var getSelectedNumber;
    if (selectedFlag == true) {
        //getSelectedNumber++;
        var selProds = component.get("v.selectedContractIds");
            
        selIds = selProds;
        selIds.push(selectedContrId);
        //var arry = component.get("v.QLlist1");
            
            
            
    }
        
    else {
        //getSelectedNumber--;
        var selProds = component.get("v.selectedContractIds");
        selIds = selProds;
        var prodId = event.getSource().get("v.name");
            
        const index = selIds.indexOf(prodId);
        if (index > -1) {
            selIds.splice(index, 1);
        }
        if(selectAllContr){
            component.set("v.selectAllContr",false);
        }
            
            
            
    }
        
        
        
        
    console.log('selContractIds-------'+selIds);
    component.set("v.contractCount",selIds.length);
    component.set("v.selectedContractIds", selIds);
},
onContractsearch: function(component, event, helper){
    var searchContract = component.get("v.searchContract");
        
    console.log('searchContract-------'+searchContract);
        
        
        
    if (searchContract=== null || searchContract === undefined ||searchContract === '')
    {
            
        component.set("v.noContractData",false);
        component.set("v.showSpinnerSelProds",true);
        var response=component.get("v.allContractCopy");
        component.set("v.totalPages1", Math.ceil(response.length/ component.get("v.pageSize")));
        console.log('totalPages1 -----'+component.get("v.totalPages1"));
        component.set("v.allContracts", response);
        component.set("v.currentPageNumber1", 1);
        helper.buildContractData(component, helper);
        component.set("v.showSpinnerSelProds",false);
            
    }     
        
},
    
searchcontractTable: function(component, event, helper){
    var searchContract = component.get("v.searchContract");
    var allRecords = component.get("v.allContracts");
        
    if (searchContract != null && searchContract != undefined &&searchContract != '' ) {
            
        component.set("v.showSpinnerSelProds",true);
        var getProductsAction = component.get("c.getContractSearch"); 
        getProductsAction.setParams({ pItem: allRecords, search: searchContract });
        getProductsAction.setCallback(this, function (response) {
            var actState = response.getState();
                
                
            if (actState === 'SUCCESS') {
                    
                component.set("v.showSpinnerSelProds",false);
                var resposeData = response.getReturnValue();
                if(resposeData==null ||resposeData==undefined||resposeData==''){
                    component.set("v.noContractData",true);  
                }
                component.set("v.contractList", resposeData);
                if (resposeData != null && resposeData!=undefined && resposeData!='' ) {
                    if(resposeData.length > 0){
                        component.set("v.noContractData",false);    
                        component.set("v.totalPages1", Math.ceil(resposeData.length / component.get("v.pageSize")));
                        component.set("v.allContracts", resposeData);
                            
                        component.set("v.currentPageNumber1", 1);
                        helper.buildContractData(component, helper);
                    }
                }
                    
            }
                
        });
        $A.enqueueAction(getProductsAction);
    }
},
showSelContracts: function(component, event, helper){
    component.set("v.showProducts", false);
    component.set("v.showContracts", false);
    component.set("v.isQLlistempty",false);
    component.set("v.noContrData",false);  
    component.set("v.showSelectedProducts", false);
    component.set("v.showSpinnerSelProds",true);
    component.set("v.showselectedContracts",true);
    component.set("v.showbutton",false);
    var selectedIds=component.get("v.selectedContractIds");  
    var contractList=component.get("v.allContracts");
    var selectedContracts=[];
    for(var i=0;i<contractList.length;i++){
        var data=contractList[i];
        if(selectedIds.includes(data.npr.Id)){
            selectedContracts.push(data); 
                
        }
            
    }
    component.set("v.selectedContracts",selectedContracts);
    component.set("v.showSpinnerSelProds",false);
    //component.set("v.totalPages1", Math.ceil(response.length/ component.get("v.pageSize")));
    //console.log('totalPages1 -----'+component.get("v.totalPages1"));
    //.set("v.allContracts", response);
    //component.set("v.currentPageNumber1", 1);
    //helper.buildContractData(component, helper);
},
ShowContractList:function(component, event, helper){
    component.set("v.showProducts", false);
    component.set("v.showContracts", true);
    component.set("v.isQLlistempty",false);
    component.set("v.noContrData",false);  
    component.set("v.showSelectedProducts", false);
    component.set("v.showselectedContracts",false);
        
},
 deleteAttachment: function (component, event, helper) {
    var target = event.target;
    //var rowIndex = target.getAttribute("name")
    var selectedRec = target.getAttribute("name");
    console.log('selectedRec--->'+selectedRec);
    var target = event.target;
    var action = component.get("c.deleteAttachments");
    console.log('action--->');
    action.setParams({
        'LineItemId' :selectedRec,
        'bidId':component.get("v.recordId")
    });
    action.setCallback(this,function(response) {
        var state = response.getState();
        if(state=='SUCCESS'){
        }
            
    });
    $A.enqueueAction(action);
    //var event = component.getEvent("lightningEvent");
   // event.setParam("message", "the message to send" );
   // event.fire();
        
    var AllRowsList = component.get("v.fileList");
    if (AllRowsList.length === 1) {
        console.log('AllRowsList.length === 1');
    }
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
 handleUploadFinished: function (component, event, helper) {
    helper.handleUploadFinished(component, event);
},
 keyCheck:function (component, event, helper) {
    if (event.which == 13){
    component.set("v.noData",false);
    var searchFamily = component.get("v.searchFamily");
     var searchName=component.get("v.searchText");
     var SearchKeyWordPD = component.get("v.lstSelectedPDRecords");
      var RxSrxList = component.get("v.RxSrxList");
        if(searchFamily!=null && searchFamily!='' && searchFamily!=undefined){
        helper.onsearchFamilyhelper(component,helper);   
        }
    else if(searchName!=null && searchName!='' && searchName!=undefined){
          helper.searchTablehelper(component,helper);
    }
     else if(SearchKeyWordPD.length>0){
           helper.onsearchDirectorhelper(component,helper);   
    }
    else if(RxSrxList.length>0){
            helper.searchRx(component, helper);   
    }
         
        
}  
},
})