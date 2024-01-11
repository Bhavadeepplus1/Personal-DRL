({
    /**
     * Get page reference and set record id, object name attribute
     * @author Manish Choudhari
     * */
	doInit: function(component, event, helper) {
        //getting page reference from pageReference attribute supplied by lightning:isUrlAddressable interface
        var myPageRef = component.get("v.pageReference");
        //get parameter from state
        var recordId = myPageRef.state.c__recordId;
        //var objectName = myPageRef.state.c__objectName;
        component.set("v.recordId", recordId);
		//component.set("v.objectName", objectName);
		 helper.getBidDetails(component, helper);  
        
    },
  
    
    
  //  Onload: function(component,event,helper){
   // $A.get('e.force:refreshView').fire();
   // },
   /* pageReferenceChangeHandler: function(component, event, helper){
         alert('pageReferenceChangeHandler');
        let pageReference = component.get("v.pageReference");
        console.log(pageReference);
        let recordId = pageReference.state.c__recordId;
        component.set("v.recordId",recordId);
        
        console.log("pageReferenceChangeHandler: recordId: " + recordId);
        if (recordId != null && recordId!=undefined && recordId!='') {
            helper.getBidDetails(component, helper);  
            
        }
        
    },*/
    /*doInit : function(component,event,helper) {
         alert('doinit');
        console.log('recordId-----'+component.get("v.recordId"));
        helper.getBidDetails(component, helper);            
    },*/
    
    
    toggleEditpanelItems: function (component, event, helper){
        var wrap = component.get("v.QLlist");
        component.set("v.showSaveItems", false);
        component.set("v.QLlist",wrap);
    },
    
    closeActionPanel: function (component, event, helper) {
       
    },
    onsearchFamily: function (component, event, helper) {
      
        var searchFamily = component.get("v.searchFamily");
        if(searchFamily!=null && searchFamily!='' && searchFamily!=undefined){
            helper.onsearchFamilyhelper(component,helper);   
        }
        
    },
    onsearch: function (component, event, helper) {
        
        var searchFamily = component.get("v.searchFamily");
        var searchName=component.get("v.searchText");
        console.log('var searchFamily ---->' + searchFamily);
        console.log('var searchName ---->' + searchName);
        
        if ((searchFamily=== null || searchFamily === undefined ||searchFamily === '')&& ( searchName===null||  searchName===undefined || searchName==='')) {
            component.set("v.noData",false);
            component.set("v.showSpinnerSelProds",true);
            console.log(' InLoop var searchFilter ---->' + searchName);
            helper.loadProducts(component, helper);
        }   
        else if(searchFamily!=null && searchFamily!=undefined && searchFamily!=''){
            if(searchName==null ||searchName==undefined ||searchName==''){
                console.log(helper.onsearchFamilyhelper);
                helper.onsearchFamilyhelper(component, helper); 
            }
            
        }
        
        
    },
    onchangeFamily:  function (component, event, helper) {
        var searchFamily = component.get("v.searchFamily");
        var searchName=component.get("v.searchText");
        console.log('var searchFamily ---->' + searchFamily);
        console.log('var searchName ---->' + searchName);
        
        if ((searchFamily=== null || searchFamily === undefined || searchFamily === '')&& (searchName === null || searchName===undefined ||searchName==='')) {
            component.set("v.noData",false);
            component.set("v.showSpinnerSelProds",true);
            console.log(' InLoop var searchFilter ---->' + searchFamily);
            helper.loadProducts(component, helper);
        }   
        else if(searchName!=null && searchName!=undefined && searchName!=''){
            if(searchFamily==null ||searchFamily==undefined||searchFamily==''){
                console.log('helper.searchTablehelper');
                helper.searchTablehelper(component, helper);  
            }
        }
    },
    
    searchTable: function (component, event, helper) {
       
        var searchName=component.get("v.searchText");
        if(searchName!=null && searchName!='' && searchName!=undefined){
            helper.searchTablehelper(component,helper);
        }
        
        
    },
    
    ShowProdList: function (component, event, helper) {
        
        component.set("v.showProducts", true);
        component.set("v.showSelectedProducts", false);
        component.set("v.err", false);
        component.set("v.save", false);
        component.set("v.errPrice", false);
        var qt = component.get("v.QLlist");
        component.set("v.QLlist1", qt);
        //helper.buildData(component, helper);
        console.log('QLlist1----------->' + JSON.stringify(component.get("v.QLlist1")));
    },
    
    handleclick: function (component, event, helper) {
        
        var index = event.getSource().get("v.name");
        var data = component.get('v.QLlist');
        var item = data[index];
        
        if (item.icon == "utility:chevronright") {
            
            item.icon = "utility:chevronright" ? "utility:chevrondown" : "utility:chevronright";
        }
        else {
            
            item.icon = "utility:chevrondown" ? "utility:chevronright" : "utility:chevrondown";
        }
        
        
        component.set("v.QLlist", data);
    },
    
    
    
    closeModal: function (component, event, helper) {
        component.set("v.showSelectedProducts", false);
        component.set("v.showProducts", false);
        component.set("v.showAddProducts", false);
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
        for(var i=0;i<alldata.length;i++){
          if (alldata[i].isSelected==false)
          {
               count++;     
              
           }
            
        }
        console.log('var count cancel-----'+count);
        
        
        
        
        console.log('recordId in closeModal'+ recordId);
        if (recordId != null && recordId != undefined && recordId != '') {
            // Go to record
            component.find("navigationService").navigate({
                type: "standard__recordPage",
                attributes: {
                    recordId: recordId,
                    actionName: "view"
                }
            }, false); 
        } 
        
        
        
    },
    selectAllCheckbox : function (component, event, helper){
        var selectedHeaderCheck = event.getSource().get("v.checked");
        var allRecords=component.get("v.allData");
        var updatedAllRecords=[];
        var updatedPageList=[];
        console.log('selectedHeaderCheck------'+selectedHeaderCheck);
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
        console.log('cheked productid' + selectedRec1);
        
        var getSelectedNumber = component.get("v.selectedCount");
        var allProds = component.get("v.Allproduct");
        var selIds = [];
        
        if (selectedRec == true) {
            getSelectedNumber++;
            var selProds = component.get("v.selectedProductsIds");
            
            selIds = selProds;
            selIds.push(selectedRec1);
            var arry = component.get("v.QLlist1");
           
            console.log('Inserted  array '+arry);
            console.log('ProductList-----After-----search' + JSON.stringify(component.get("v.Allproduct")));
        }
        
        else {
            getSelectedNumber--;
            var selProds = component.get("v.selectedProductsIds");
            selIds = selProds;
            var prodId = event.getSource().get("v.name");
            console.log('Deletig->'+prodId);
            const index = selIds.indexOf(prodId);
            if (index > -1) {
                selIds.splice(index, 1);
            }
            var arry = component.get("v.QLlist1");
            console.log('QLlist1--- BEFORE SPLICE' + JSON.stringify(component.get("v.QLlist1")));
            if (arry.length > 0) {
                console.log('arry.length---->' + arry.length);
                for (var i = 0; i < arry.length; i++) {
                    if (arry[i].qlItem.Phoenix_Product__c === prodId) {
                        arry.splice(i, 1);
                        console.log('array-splice12----' + arry);
                    }
                }
                component.set("v.QLlist1", arry);
                console.log('QLlist1--- AFTER SPLICE' + JSON.stringify(component.get("v.QLlist1")));
            }
            console.log('ProductList-----After-----search1' + JSON.stringify(component.get("v.Allproduct")));
            
        }
        
        console.log('selectedProductsIds-----' + selIds);
        component.set("v.selectedProductsIds", selIds);
        console.log('selectedProductsIds-----' + component.get("v.selectedProductsIds"));
        component.set("v.selectedCount", getSelectedNumber);
        var count = component.get("v.selectedCount")
        if (count > 0) {
            component.set("v.showbutton", false);
        }
        else if (count == 0) {
            component.set("v.showbutton", true);
        }
        helper.buildData(component, helper); 
    },
    
    processProducts: function (component, event, helper) {
        component.set("v.showProducts", false);
        component.set("v.showSpinnerSelProds",true);
        component.set("v.showSelectedProducts", true);
        component.set("v.isQLlistempty",false);
        component.set("v.showSaveItems", true);
        var prdlist1 = component.get("v.selectedProductsIds");
        console.log('selectedProductsIds------------'+prdlist1.length);
       
        var getProductsAction = component.get("c.getQuoteLineItems");
        
        getProductsAction.setParams({ "prdlist": prdlist1});
        
        getProductsAction.setCallback(this, function (response) {
            var actState = response.getState();
            var arry = component.get("v.QLlist1");
            
            if (actState === 'SUCCESS') {
                component.set("v.showSpinnerSelProds",false);
                var resposeData = response.getReturnValue();
                console.log('resposeData length------------->' + resposeData.length);
                
                
              
                component.set("v.QLlist", resposeData);
                
            }
            else{
                component.set("v.showSpinnerSelProds",false);
            }
        });
        $A.enqueueAction(getProductsAction);
    },
    
    calculateProducts: function (component, event, helper) {
        
    },
    
    insertProducts: function (component, event, helper) {
        
        component.set("v.showSpinnerSelProds",true);
        var quoteId =component.get("v.recordId");
        console.log('insertProducts---quoteId' + quoteId);
        var  saveitems1=[];
        saveitems1=component.get("v.QLlist");
       
        var ids=new Array();
        for (var i= 0 ; i < saveitems1.length ; i++){
            ids.push(saveitems1[i].qlItem);
            }
        
        
       
        
        component.set("v.QLlineItems",ids);
        var errMsg=component.get("v.err");
        var errMsg1=component.get("v.errPrice");
        if (errMsg == false && errMsg1 == false) {
            
            var saveitems = component.get("v.QLlineItems");
            var action = component.get("c.savequoteitems");
            console.log('saveitems-------' + JSON.stringify(saveitems1).length);
            console.log('quoteId-------' + quoteId);
            
            action.setParams({ "saveitems": saveitems, "bidId": quoteId });
            
            action.setCallback(this, function (response) {
                console.log('In Callback');
                var actState = response.getState();
                console.log('actState' + actState)
                if (actState === 'SUCCESS') {
                    component.set("v.showSpinnerSelProds",false);
                    var resposeData = response.getReturnValue();
                    console.log('resposeData' + JSON.stringify(resposeData));
                    
                    component.set("v.showSelectedProducts", false);
                    component.set("v.showProducts", false);
                    
                   var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type": 'success',
                        "message": "New Line Items has been added successfully."
                    });
                    toastEvent.fire();
                    $A.get('e.force:refreshView').fire();
                    
                   
                    var pageReference = {
                        type: "standard__recordPage",
                        attributes: {
                            recordId: component.get("v.recordId"),
                            objectApiName: "Phoenix_Bid__c",
                            actionName: "view"
                        }
                    };
                    var navService = component.find("navigationService");
                    navService.navigate(pageReference);
                }
                else{
                    component.set("v.showSpinnerSelProds",false);
                }
            });
            $A.enqueueAction(action);
        }
        else{
            component.set("v.showSpinnerSelProds",false);
        }
       
    },
    
    removeDeletedRow: function (component, event, helper) {
        console.log('In removeDeletedRow');
        var selectedRec = event.getSource().get("v.name");
        console.log('selectedRec-------'+selectedRec);
        var AllRowsList = component.get("v.QLlist");
        console.log('AllRowsList.length === '+ AllRowsList.length);
        if (AllRowsList.length === 1) {
            console.log('AllRowsList.length === 1');
            component.set("v.showSaveItems", true);
        }
        
        component.set("v.err", false);
        component.set("v.errPrice", false);
        
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
            component.set("v.isQLlistempty", true);
        }
        else
            component.set("v.isQLlistempty", false);
        
      
        
        var qItemsTotal = 0.00;
        var saveditems = component.get("v.QLlist");
        
        
        
        var productList=component.get("v.ProductList");
        var alldata=component.get("v.allData");
        console.log('productList----------'+JSON.stringify(productList));
        var prdlist1=[];
        component.set("v.selectedProductsIds",[]);
        
        var count=0;
        
        
        
        
        if(AllRowsList!=undefined && AllRowsList!=null && AllRowsList!='' && AllRowsList.length>0)
        {
            
            
            for (let i = 0; i < AllRowsList.length; i++) {
                
                for (let j = 0; j < alldata.length; j++) {
                    if (alldata[j].prdlist.Id == AllRowsList[i].qlItem.Phoenix_Product__c)
                    {
                        console.log('productList[j].prdlist.Id=='+alldata[j].prdlist.Id);
                        console.log('AllRowsList[i].prdlist.Id=='+AllRowsList[i].qlItem.Phoenix_Product__c);
                        count=count+1;
                        alldata[j].isSelected=true;
                        console.log('productList[j].isSelected=='+alldata[j].isSelected);
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
        var pageNumber = component.get("v.currentPageNumber");
        component.set("v.currentPageNumber", pageNumber + 1);
        helper.buildData(component, helper);
    },
    
    onPrev: function (component, event, helper) {
        var pageNumber = component.get("v.currentPageNumber");
        component.set("v.currentPageNumber", pageNumber - 1);
        helper.buildData(component, helper);
    },
    
    processMe: function (component, event, helper) {
        component.set("v.currentPageNumber", parseInt(event.target.name));
        helper.buildData(component, helper);
    },
    
    onFirst: function (component, event, helper) {
        component.set("v.currentPageNumber", 1);
        helper.buildData(component, helper);
    },
    
    onLast: function (component, event, helper) {
        component.set("v.currentPageNumber", component.get("v.totalPages"));
        helper.buildData(component, helper);
    },
    
    closeActionPanel2: function (component, event, helper) {
        
        let recordId =component.get("v.recordId");
        console.log('recordId in closeModal'+ recordId);
        if (recordId != null && recordId != undefined && recordId != '') {
            // Go to record
            component.find("navigationService").navigate({
                type: "standard__recordPage",
                attributes: {
                    recordId: recordId,
                    actionName: "view"
                }
            }, false); // replace
        } 
        $A.get('e.force:refreshView').fire();
    },
    
 showSelectedproducts:function(component,event,helper){
        component.set("v.isModalOpen",true);
       
        var showselectedIds=component.get("v.selectedProductsIds");
        var alldata=component.get("v.allData");
        var modalProductList=[];
        for(var i=0;i<alldata.length;i++){
            
            if(showselectedIds.includes(alldata[i].prdlist.Id)){
                modalProductList.push(alldata[i]); 
            }
            
        }
        component.set("v.modalProductList",modalProductList);
    },
    closePopup:function(component,event,helper){
        component.set("v.isModalOpen",false);    
    }
    

    
})