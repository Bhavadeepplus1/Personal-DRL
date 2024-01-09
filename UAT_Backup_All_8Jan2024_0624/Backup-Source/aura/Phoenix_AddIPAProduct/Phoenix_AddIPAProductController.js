({
    
    doInit : function(component,event,helper) {
        var bidId = component.get("v.recordId");
        console.log('bidId-----'+bidId);
        
        var getQuoteInfo = component.get("c.getbidInfo");
        getQuoteInfo.setParams({ "bidId": bidId });
        getQuoteInfo.setCallback(this, function (response) {
            var actState = response.getState();
            
            if (actState === 'SUCCESS') {
                
                var responseData=response.getReturnValue();
                var recordCount=responseData.recordCount;
                 if(recordCount!=null&&recordCount!=undefined &&recordCount!=''){
                component.set("v.selectedProductsCount",responseData.recordCount);
                }
                component.set("v.wrap", response.getReturnValue());
                 if(component.get('v.wrap.bid.Phoenix_Approval_Status__c') != 'Draft' && component.get('v.wrap.bid.Phoenix_Approval_Status__c') != '' && component.get('v.wrap.bid.Phoenix_Approval_Status__c') != null && component.get('v.wrap.bid.Phoenix_Approval_Status__c') !=undefined) {
                        component.set('v.showDraftView',false);
                    }
                console.log();
                var bidRecord= component.get("v.wrap");
                component.set("v.bidType",bidRecord.bid.Phoenix_Bid_Type__c);
                console.log("bidTYpe-----"+bidRecord.bid.Phoenix_Bid_Type__c);
                console.log("wrap-----"+JSON.stringify(response.getReturnValue()));
                helper.loadProducts(component,helper);
                
                
            }
        });
        $A.enqueueAction(getQuoteInfo);
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
         var SearchKeyWordPD = component.get("v.lstSelectedPDRecords");
        if(searchName!=null && searchName!='' && searchName!=undefined){
            
            helper.searchTablehelper(component,helper);
        }
        
         else if(SearchKeyWordPD.length>0){
               helper.onsearchDirectorhelper(component,helper);   
        }
        
    },
    
    ShowProdList: function (component, event, helper) {
        
        component.set("v.showProducts", true);
        component.set("v.showSelectedProducts", false);
        
        var qt = component.get("v.QLlist");
        component.set("v.QLlist1", qt);
        
        
        
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
           //component.set("v.showSpinnerSelProds",true);
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
         component.set("v.showApprovalMsg",false);
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
        if (count > 0) {
            component.set("v.showbutton", false);
        }
        else if (count == 0) {
            component.set("v.showbutton", true);
        }
        
        
        
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
        //helper.buildData(component, helper); 
    },
    
    processProducts: function (component, event, helper) {
        component.set("v.showProducts", false);
         component.set("v.errIDN", false);
         component.set("v.errPrice", false);
        component.set("v.showSpinnerSelProds",true);
         component.set("v.showApprovalMsg",false);  
        component.set("v.showSelectedProducts", true);
        component.set("v.isQLlistempty",false);
        
        var prdlist1 = component.get("v.selectedProductsIds");
        
        
        var getProductsAction = component.get("c.getQuoteLineItems");
        
        getProductsAction.setParams({ "prdlist": prdlist1});
        
        getProductsAction.setCallback(this, function (response) {
            var actState = response.getState();
            var arry = component.get("v.QLlist1");
            
            if (actState === 'SUCCESS') {
                component.set("v.showSpinnerSelProds",false);
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
                component.set("v.showSpinnerSelProds",false);
            }
        });
        $A.enqueueAction(getProductsAction);
    },
    
    
    
    insertProducts: function (component, event, helper) {
        
        component.set("v.showSpinnerSelProds",true);
        var quoteId =component.get("v.recordId");
        console.log('quoteId-------'+quoteId);
        var  saveitems1=[];
        saveitems1=component.get("v.QLlist");
        var contractList=component.get("v.allContracts");
        var ids=new Array();
        var savecontrs=new Array();
        var selectedContractIds=component.get("v.selectedContractIds");
        if(saveitems1 != undefined && $A.util.isArray(saveitems1)){
            for (var i= 0 ; i < saveitems1.length ; i++){
                ids.push(saveitems1[i].qlItem);
            }
        }
        if(contractList != undefined && $A.util.isArray(contractList)){
            for(var j=0;j<contractList.length;j++){
                if(selectedContractIds.includes(contractList[j].contrt.Id)){
                    savecontrs.push(contractList[j].contrt); 
                }
                
            }
        }
        
        
        console.log('saveContracts----'+JSON.stringify(savecontrs));
        
        component.set("v.QLlineItems",ids);
        component.set("v.ContrItems",savecontrs);
        
        var saveitems = component.get("v.QLlineItems");
        var savecontract=component.get("v.ContrItems");
        var action = component.get('c.insertContrProducts');
        
        
        
        action.setParams({ "saveitems": saveitems, "savecontrs":savecontract,"bidId": quoteId });
        
        action.setCallback(this, function (response) {
            
            var actState = response.getState();
            console.log('actState' + actState)
            if (actState === 'SUCCESS') {
                component.set("v.showSpinnerSelProds",false);
                var resposeData = response.getReturnValue();
                
                
                component.set("v.showSelectedProducts", false);
                component.set("v.showProducts", false);
                component.set("v.showContracts", false);
                
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": 'success',
                    "message": "New Line Items has been added successfully."
                });
                toastEvent.fire();
                //$A.get('e.force:refreshView').fire();
                var dismissActionPanel = $A.get("e.force:closeQuickAction");
                dismissActionPanel.fire();
                var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                    "url": "/lightning/cmp/c__Phoenix_EditIPAlineItemsCmp?c__recordId="+component.get("v.recordId")
                });
                urlEvent.fire();
                //var urlEvent = $A.get("e.force:navigateToURL");
                //urlEvent.setParams({
                 //   "url": "lightning/n/c__Phoenix_EditIPAlineItemsCmp?c__recordId="+component.get("v.recordId")
                //});
                //urlEvent.fire();
                
                
            }
            else{
                component.set("v.showSpinnerSelProds",false);
            }
        });
        $A.enqueueAction(action);
        
        
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
       var bidRecord=component.get("v.wrap");
         var count=0;
        var countrec=0;
        for(var i=0;i<saveditems.length;i++){
            if(saveditems[i].qlItem.Phoenix_Proposed_IPA_Price__c==undefined ||saveditems[i].qlItem.Phoenix_Proposed_IPA_Price__c==''){
                count=count+1;
                
            }
             if(bidRecord.bid.Phoenix_Bid_Type__c=='SRx IPA Product Addition'){
            if(saveditems[i].qlItem.Phoenix_IDN_Usage__c==undefined ||saveditems[i].qlItem.Phoenix_IDN_Usage__c==''){
                countrec=countrec+1;
                
            }
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
    sortIPAFloorPrice:function(component, event, helper){
        component.set("v.selectedTabsoft", 'IPAFloorPrice');
        // call the helper function with pass sortField Name      
        helper.sortHelper(component, event, 'Phoenix_IPA_Floor_Price__c');
    },
    
    sortContractNumber:function(component, event, helper){
        component.set("v.selectedTabsoft", 'ContractNumber');
        // call the helper function with pass sortField Name      
        helper.sortContrHelper(component, event, 'Phoenix_Contract_Number__c');
    },
    sortContractOwner:function(component, event, helper){
        component.set("v.selectedTabsoft", 'ContractOwner');
        // call the helper function with pass sortField Name      
        helper.sortContrHelper(component, event, 'Owner.Name');
    },
    
    sortExternalDescription:function(component, event, helper){
        component.set("v.selectedTabsoft", 'ExternalDescription');
        // call the helper function with pass sortField Name      
        helper.sortContrHelper(component, event, 'Phoenix_Contract_External_Description__c');
    },
    sortInternalDescription:function(component, event, helper){
        component.set("v.selectedTabsoft", 'InternalDescription');
        // call the helper function with pass sortField Name      
        helper.sortContrHelper(component, event, 'Phoenix_Contract_Internal_Description__c');
    },
    sortCustomerName:function(component, event, helper){
        component.set("v.selectedTabsoft", 'CustomerName');
        // call the helper function with pass sortField Name      
        helper.sortContrHelper(component, event, 'Phoenix_Customer__r.Name');
    },
    
    sortCustomerNumber:function(component, event, helper){
        component.set("v.selectedTabsoft", 'CustomerNumber');
        // call the helper function with pass sortField Name      
        helper.sortContrHelper(component, event, 'Phoenix_Customer_Number__c');
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
        var bidRecord=component.get("v.wrap");
        
        for(var i=0;i<saveitems1.length;i++){
            
            
             if(bidRecord.bid.Phoenix_Bid_Type__c=='SRx IPA Product Addition'){
            if(saveitems1[i].qlItem.Phoenix_IDN_Usage__c==undefined ||saveitems1[i].qlItem.Phoenix_IDN_Usage__c==''){
                countrec=countrec+1;
                
            }
             }
            
            
        }
        
        if(countrec>0){
            component.set("v.errIDN",true);  
        }
        else{
            component.set("v.errIDN",false);   
        }
         
    },
    
    addToContracts:function(component, event, helper){
        
        component.set("v.showProducts", false);
        //component.set("v.showSelectedProducts", false);
        //component.set("v.showContracts",true);
        var saveditems = component.get("v.QLlist");
        var hightlightedItems=[];
         var count=0;
        var countrec=0;
        var bidRecord=component.get("v.wrap");
        ;
        for(var i=0;i<saveditems.length;i++){
            
            if(saveditems[i].qlItem.Phoenix_Proposed_IPA_Price__c==undefined ||saveditems[i].qlItem.Phoenix_Proposed_IPA_Price__c==''){
                count=count+1;
                
            }
            if(bidRecord.bid.Phoenix_Bid_Type__c=='SRx IPA Product Addition'){
            if(saveditems[i].qlItem.Phoenix_IDN_Usage__c==undefined ||saveditems[i].qlItem.Phoenix_IDN_Usage__c==''){
                countrec=countrec+1;
                
            }
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
        
         var errMsg=component.get("v.errIDN");
        var errMsg1=component.get("v.errPrice");
        if(errMsg==false && errMsg1==false){
          helper.getContractData(component, helper);     
        }
           
      
           
       
        console.log('hightlightedItems----------'+hightlightedItems);
       
        
    },
    closeTooltip: function(component, event, helper){
          component.set("v.showTooltip",false); 
    },
    ShowSelectedProdList:function(component, event, helper){
        component.set("v.showProducts", false);
        component.set("v.showSelectedProducts", true);
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
                if(selIds.includes(allContracts[j].contrt.Id)){
                    continue; 
                }
                
                selIds.push(allContracts[j].contrt.Id);
                
            }
            else{
                
                
                const index = selIds.indexOf(allContracts[j].contrt.Id);
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
            
            helper.getContractData(component, helper);
            
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
	keyCheck: function (component, event, helper) {
        if (event.which == 13){ 
		var action = component.get('c.searchTable');
        $A.enqueueAction(action);
		//this.searchContracts(component, event,helper);
		}
	}
    //priceChange: function(component, event, helper){
        
   // }
    
})