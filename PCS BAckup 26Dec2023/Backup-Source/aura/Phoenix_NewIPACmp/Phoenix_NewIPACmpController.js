({
    initRecords: function(component, event, helper) { 
        
        component.set('v.showSpinner',true);
        component.set("v.BidTypeVal","");
        component.set('v.recordId',component.get("v.pageReference").state.c__recordId);
        console.log('---record--id--from url-'+component.get('v.recordId')); 
        var action = component.get("c.getIPAProducts");      
        action.setParams
        ({
            bidId: component.get("v.recordId")
        });
        action.setCallback(this, function(response) 
                           {
                               if(response.getState()=="SUCCESS"){
                                   var productData =  response.getReturnValue();
                                   if(productData.length>0){
                                   var bidRecord=productData[0].bidRecord;
                                   var recordCount=productData[0].recordCount;
                                   console.log('productData[0].recordCount'+recordCount);
                                   if(recordCount!=null&&recordCount!=undefined &&recordCount!=''){
                                       component.set("v.selectedProductsCount",recordCount); 
                                   }
                                  
                                   component.set("v.Allproduct",productData);
                                   component.set("v.allData",productData);
                                   component.set("v.showProducts",true);
                                   //console.log('bidRecord.Phoenix_Approval_Status__c'+bidRecord.Phoenix_Approval_Status__c);
                                    if(bidRecord.Phoenix_Approval_Status__c != 'Draft') {
                        component.set('v.showDraftView',false);
                    }
                                   component.set('v.showSpinner',false); 
                                   component.set("v.totalPages", Math.ceil(productData.length / component.get("v.pageSize")));
                 					component.set("v.currentPageNumber", 1);
                                  
                    			helper.buildData(component, helper);
                          }
                                   else{
                                       component.set("v.showNoProducts",true); 
                                   }
                                   
                     }
                              else{
                                   component.set('v.showSpinner',false);
                               }
                           });
        $A.enqueueAction(action);
        
    },
    
    backToBid : function(component, event, helper){
        
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
        component.set("v.QLlist",selectedProducts);
        component.set("v.QLlist1",selectedProducts);
        var getSelectedNumber = 0;
        component.set("v.selectedCount",getSelectedNumber);
        var count=0;
        var searchText='';
        component.set("v.searchText",searchText);
         component.set("v.selectAll",false);
         component.set("v.showPriceMsg",false);
         component.set("v.errPrice",false);
         component.set("v.errIDN",false);
         component.set("v.showApprovalMsg",false);
         component.set("v.showSpinner",false);
         component.set("v.showProducts",false);
          component.set("v.showSelectedProducts",false);
         component.set("v.isModalOpen",false);
        for(var i=0;i<alldata.length;i++){
            if (alldata[i].isSelected==false)
            {
                count++;     
                
            }
            
        }
        component.find("navService").navigate({
            type: "standard__recordPage",
            attributes: {
                recordId: component.get("v.recordId"),
                actionName: "view"
            }
        }, false);
    },
    onsearch: function (component, event, helper) {
        
       
        component.set("v.noData",false);
       
        var searchName=component.get("v.searchText");
       var SearchKeyWordPD = component.get("v.lstSelectedPDRecords");
       
        
        
        if(searchName==null || searchName=='undefined' || searchName==''){
        if(searchName!=null && searchName!='undefined' && searchName!=''){
            helper.searchTablehelper(component,helper); 
        }
       
        else if(SearchKeyWordPD.length>0){
            helper.onsearchDirectorhelper(component,helper);   
        }
            
                else{
                    component.set("v.showSpinner",true);
                   var resposeData=component.get("v.Allproduct");
            component.set("v.totalPages", Math.ceil(resposeData.length / component.get("v.pageSize")));
                            component.set("v.allData", resposeData);
                            
                            component.set("v.currentPageNumber", 1);
                            helper.buildData(component, helper);  
                    component.set("v.showSpinner",false);
                }
        }
      
        
        
    },
    
    
    searchTable: function (component, event, helper) {
        
        var searchName=component.get("v.searchText");
         var SearchKeyWordPD = component.get("v.lstSelectedPDRecords");
        if(searchName!=null && searchName!='' && searchName!=undefined){
            
            helper.searchTablehelper(component,helper);
        }
        
         else if(SearchKeyWordPD.length>0){
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
           
        component.set("v.listOfSearchPDRecords", null ); 
        component.set("v.noData",false);
       
        var searchName=component.get("v.searchText");
       
          var SearchKeyWordPD = component.get("v.lstSelectedPDRecords");
         
         if(!SearchKeyWordPD.length>0){
       
        if(searchName!=null && searchName!='undefined' && searchName!=''){
            helper.searchTablehelper(component,helper); 
        }
       
        else if(SearchKeyWordPD.length>0){
            helper.onsearchDirectorhelper(component,helper);   
        }
            
                else{
                    component.set("v.showSpinner",true);
                   var resposeData=component.get("v.Allproduct");
            component.set("v.totalPages", Math.ceil(resposeData.length / component.get("v.pageSize")));
                            component.set("v.allData", resposeData);
                            
                            component.set("v.currentPageNumber", 1);
                            helper.buildData(component, helper);
                    component.set("v.showSpinner",false);
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
    
    ShowProdList: function (component, event, helper) {
        
        component.set("v.showProducts", true);
        component.set("v.showSelectedProducts", false);
        
        var qt = component.get("v.QLlist");
        component.set("v.QLlist1", qt);
        
        
        
    },
    showPriceErMsghandler: function (component, event, helper) {
      var count=0;
        component.set("v.showApprovalMsg",false); 
        var saveitems1=component.get("v.QLlist");
        
        for(var i=0;i<saveitems1.length;i++){
            
            if(saveitems1[i].qlItem.Phoenix_Proposed_IPA_Price__c==undefined ||saveitems1[i].qlItem.Phoenix_Proposed_IPA_Price__c==''){
                count=count+1;
                
            }
            if(saveitems1[i].qlItem.Phoenix_Proposed_IPA_Price__c>0 && saveitems1[i].qlItem.Phoenix_Proposed_IPA_Price__c<saveitems1[i].IPAPrice){
               
              component.set("v.showApprovalMsg",true);   
            }
            
         }
        if(count>0){
            component.set("v.errPrice",true);
        }
        else{
            component.set("v.errPrice",false);  
        }
        
         
    },
    showIDNErMsghandler: function (component, event, helper) {
        
        var countrec=0;
        var saveitems1=component.get("v.QLlist");
        
        for(var i=0;i<saveitems1.length;i++){
            
            
            
            if(saveitems1[i].qlItem.Phoenix_IDN_Usage__c==undefined ||saveitems1[i].qlItem.Phoenix_IDN_Usage__c==''){
                countrec=countrec+1;
                
            }
            
            
        }
        
        if(countrec>0){
            component.set("v.errIDN",true);  
        }
        else{
            component.set("v.errIDN",false);   
        }
         
    },
    
    
    
   
    selectAllCheckbox : function (component, event, helper){
        var selectedHeaderCheck = event.getSource().get("v.checked");
        var allRecords=component.get("v.allData");
        var updatedAllRecords=[];
        var updatedPageList=[];
        
        var ProductList=component.get("v.ProductList");
        var getSelectedNumber = component.get("v.selectedCount");
        
        var selIds=component.get("v.selectedProductsIds");
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
                            if (arry[i].qlItem.Phoenix_Product__c === ProductList[j].prdlist.Id) {
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
                        if (arry[i].qlItem.Phoenix_Product__c === prodId) {
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
        
    },
    
    processProducts: function (component, event, helper) {
        
          component.set("v.showProducts", false);
         component.set("v.errIDN", false);
         component.set("v.errPrice", false);
          component.set("v.showSpinner",true);
         component.set("v.showApprovalMsg",false);  
        component.set("v.showSelectedProducts", true);
        var prdlist1 = component.get("v.selectedProductsIds");
        
        
        var getProductsAction = component.get("c.getQuoteLineItems");
        
        getProductsAction.setParams({ "prdlist": prdlist1,"bidId":component.get("v.recordId")});
        
        getProductsAction.setCallback(this, function (response) {
            var actState = response.getState();
            var arry = component.get("v.QLlist1");
            
            if (actState === 'SUCCESS') {
                component.set("v.showSpinner",false);
                var resposeData = response.getReturnValue();
                var resposeDataList=resposeData;
                
                if(arry!=null && arry!=undefined && arry!=''){
                    if(arry.length >0){
                        
                        
                        
                        for(var i=0; i < arry.length; i++){
                            
                            for(var j=0; j < resposeData.length; j++){
                                
                                if(resposeData[j].qlItem.Phoenix_Product__c===arry[i].qlItem.Phoenix_Product__c)
                                {
                                    resposeData.splice(j,1);
                                    
                                    
                                    
                                    
                                    
                                }
                                
                            }
                            
                        } 
                        if(resposeData.length>0)
                        {
                            arry=arry.concat(resposeData);
                            
                            component.set("v.QLlist",arry); 
                        }
                        else{
                            component.set("v.QLlist",arry);   
                        }
                    }
                }
                else{
                    component.set("v.QLlist",resposeData); 
                }
                
                
                
                
                
            }
            else{
                component.set("v.showSpinner",false);
            }
        });
        $A.enqueueAction(getProductsAction);
    },
    
    
    
    insertProducts: function (component, event, helper) {
        
        component.set("v.showSpinner",true);
       
        var ids=new Array();
        var count=0;
        var countrec=0;
        var saveitems1=component.get("v.QLlist");
        for (var i= 0 ; i < saveitems1.length ; i++){
            ids.push(saveitems1[i].qlItem);
        }
        
        for(var i=0;i<saveitems1.length;i++){
            
            if(saveitems1[i].qlItem.Phoenix_Proposed_IPA_Price__c==undefined ||saveitems1[i].qlItem.Phoenix_Proposed_IPA_Price__c==''){
                count=count+1;
                
            }
            
            if(saveitems1[i].qlItem.Phoenix_IDN_Usage__c==undefined ||saveitems1[i].qlItem.Phoenix_IDN_Usage__c==''){
                countrec=countrec+1;
                
            }
            
            
        }
        if(count>0){
            component.set("v.errPrice",true);
             component.set("v.showSpinner",false);
        }
        else{
            component.set("v.errPrice",false);  
        }
        if(countrec>0){
            component.set("v.errIDN",true);
             component.set("v.showSpinner",false);
        }
        else{
            component.set("v.errIDN",false);   
        }
       
         var errMsg=component.get("v.errIDN");
        var errMsg1=component.get("v.errPrice");
        if(errMsg==false && errMsg1==false){
        
        var action = component.get('c.insertLines');
        
        action.setParams({ "saveitems": ids });
        
        action.setCallback(this, function (response) {
            
            var actState = response.getState();
            console.log('actState' + actState)
            if (actState === 'SUCCESS') {
                 component.set("v.showProducts", false);
                component.set("v.showSelectedProducts",false);
                component.set("v.showSpinner",false);
                var resposeData = response.getReturnValue();
                
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": 'success',
                    "message": "New Line Items has been added successfully."
                });
                toastEvent.fire();
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
        component.set("v.QLlist",selectedProducts);
        component.set("v.QLlist1",selectedProducts);
        var getSelectedNumber = 0;
        component.set("v.selectedCount",getSelectedNumber);
        var count=0;
        var searchText='';
        component.set("v.searchText",searchText);
         component.set("v.selectAll",false);
         component.set("v.showPriceMsg",false);
         component.set("v.errPrice",false);
         component.set("v.errIDN",false);
         component.set("v.showSpinner",false);
         component.set("v.showProducts",false);
          component.set("v.showSelectedProducts",false);
         component.set("v.isModalOpen",false);
        for(var i=0;i<alldata.length;i++){
            if (alldata[i].isSelected==false)
            {
                count++;     
                
            }
            
        }
                //$A.get('e.force:refreshView').fire();
               /* component.find("navService").navigate({
            type: "standard__recordPage",
            attributes: {
                recordId: component.get("v.recordId"),
                actionName: "view"
            }
        }, false);*/
                var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                    "url": "/lightning/cmp/c__Phoenix_AddIPABidMainPage?c__recordId="+component.get("v.recordId")
                });
                urlEvent.fire();
                
            }
            else{
                component.set("v.showSpinner",false);
            }
        });
        $A.enqueueAction(action);
        
        }   
    },
    
    removeDeletedRow: function (component, event, helper) {
         component.set("v.showApprovalMsg",false); 
        var selectedRec = event.getSource().get("v.name");
        
        var AllRowsList = component.get("v.QLlist");
        
        if (AllRowsList.length === 1) {
            console.log('AllRowsList.length === 1');
            
        }
        
        
        
        for (let i = 0; i < AllRowsList.length; i++) {
            
            var pItem = AllRowsList[i];
            
            if (pItem.qlItem.Phoenix_Product__c == selectedRec) {
                
                var index = AllRowsList.indexOf(pItem);
                if (index > -1) {
                    
                    AllRowsList.splice(index, 1);
                    var AllRowsList1 = AllRowsList;
                    
                }
                
            }
        }
        
        component.set("v.QLlist",[]);
        component.set("v.QLlist", AllRowsList);
        
        if (AllRowsList.length === 0) {
             component.set("v.errPrice",false);
            component.set("v.errIDN",false);
            component.set("v.isQLlistempty", true);
        }
        else
            component.set("v.isQLlistempty", false);
        
         var saveditems = component.get("v.QLlist");
       
         var count=0;
        var countrec=0;
        for(var i=0;i<saveditems.length;i++){
            if(saveditems[i].qlItem.Phoenix_Proposed_IPA_Price__c==undefined ||saveditems[i].qlItem.Phoenix_Proposed_IPA_Price__c==''){
                count=count+1;
                
            }
            
            if(saveditems[i].qlItem.Phoenix_IDN_Usage__c==undefined ||saveditems[i].qlItem.Phoenix_IDN_Usage__c==''){
                countrec=countrec+1;
                
            }
             if(saveditems[i].qlItem.Phoenix_Proposed_IPA_Price__c>0 && saveditems[i].qlItem.Phoenix_Proposed_IPA_Price__c<saveditems[i].IPAPrice){
               
              component.set("v.showApprovalMsg",true);   
            }
            
            
            
        }
        if(count>0){
            component.set("v.errPrice",true);
        }
        else{
            component.set("v.errPrice",false);  
        }
        if(countrec>0){
            component.set("v.errIDN",true);  
        }
        else{
            component.set("v.errIDN",false);   
        }
        
        component.set("v.errPrice",false);
        component.set("v.errIDN",false);  
        var saveditems = component.get("v.QLlist");
        var productList=component.get("v.ProductList");
        var alldata=component.get("v.allData");
        
        var prdlist1=[];
        component.set("v.selectedProductsIds",[]);
        
        var count=0;
        
        
        if(AllRowsList!=undefined && AllRowsList!=null && AllRowsList!='' && AllRowsList.length>0)
        {
            
            
            for (let i = 0; i < AllRowsList.length; i++) {
                
                for (let j = 0; j < alldata.length; j++) {
                    if (alldata[j].prdlist.Id == AllRowsList[i].qlItem.Phoenix_Product__c)
                    {
                        
                        
                        count=count+1;
                        alldata[j].isSelected=true;
                        
                        prdlist1.push(alldata[j].prdlist.Id);
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
        
        component.set("v.selectedProductsIds",prdlist1);
        
        helper.buildData(component, helper);
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
                component.set("v.showSpinner",false);
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
    sortIPAFloorPrice:function(component, event, helper){
        component.set("v.selectedTabsoft", 'IPAFloorPrice');
        // call the helper function with pass sortField Name      
        helper.sortHelper(component, event, 'Phoenix_IPA_Floor_Price__c');
    },
	keyCheck:function (component, event, helper) {
        if (event.which == 13){ 
		var action = component.get('c.searchTable');
        $A.enqueueAction(action);
		//this.searchContracts(component, event,helper);
		}
	}
    
})