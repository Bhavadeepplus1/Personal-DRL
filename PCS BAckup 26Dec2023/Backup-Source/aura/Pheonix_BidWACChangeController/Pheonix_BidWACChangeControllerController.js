({
    pageReferenceChangeHandler: function(component, event, helper){
        let pageReference = component.get("v.pageReference");
        console.log('---------pageReference--------'+pageReference);
        let recordId = pageReference.state.c__recordId;
        component.set("v.recordId",recordId);
        if (recordId != null && recordId!=undefined && recordId!='') {
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
            helper.getBidDetailsViewPage(component,event, helper); 
            
        }
    },
    
    doInit : function(component,event,helper) {
        component.set("v.showProducts", false);
        component.set("v.showRecordView", true);
               // component.set("v.showNoRecMsg", true);

        console.log('------1----');
        helper.getBidDetailsViewPage(component,event,helper); 
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
        
    
    addProduct : function(component,event,helper) {
        component.set("v.showRecordView", false);   
        component.set("v.showProducts", true); 
        helper.getBidDetails(component, helper);
    },
    
    intialLoad : function(component,event,helper) {
        component.set("v.showRecordView", true);   
        component.set("v.showProducts", false);           
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
        // component.set("v.showSpinnerSelProds",false);
        
        
    },
    onsearchDirector: function (component, event, helper) {
       
          var SearchKeyWordPD = component.get("v.lstSelectedPDRecords");
        console.log('SearchKeyWordPD----'+SearchKeyWordPD);
        if(SearchKeyWordPD!=null && SearchKeyWordPD!='' && SearchKeyWordPD!=undefined){
            
            helper.onsearchDirectorhelper(component,helper);   
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
        // component.set("v.showSpinnerSelProds",false);
       
         
        /*if (searchFamily=== null ||searchFamily === 'undefined' || searchFamily === ' '|| searchFamily === undefined ||searchFamily === ''){
        if (( searchName===null||  searchName==='undefined' ||searchName===' ' ||searchName===undefined || searchName==='') && (! SearchKeyWordPD.length>0)&& (! RxSrxList.length>0))
        {
            
           console.log('Hi');
                  var resposeData=component.get("v.Allproduct");
            component.set("v.totalPages", Math.ceil(resposeData.length / component.get("v.pageSize")));
                            component.set("v.allData", resposeData);
                            
                            component.set("v.currentPageNumber", 1);
                            helper.buildData(component, helper); 
                
        }   
        else 
        {
             console.log('Bye');
          helper.onsearchFamilyhelper(component, helper); 
            
            
        }
        }*/
        
        
    },
    
    searchTable: function (component, event, helper) {
        
        var searchName=component.get("v.searchText");
        if(searchName!=null && searchName!='' && searchName!=undefined){
            
            helper.searchTablehelper(component,helper);
        }
        
        
    },
    
    showProdList: function (component, event, helper) {
        
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
    
    
    
    
    closeModal: function (component, event, helper) {
        component.set("v.showSelectedProducts", false);
        component.set("v.showProducts", false);
        component.set("v.showuploadFile", false);
        component.set("v.showNoRecMsg", false);
        component.set("v.noData",false);
        
        
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
         component.set("v.isRxChecked",false);
        component.set("v.isSRxChecked",false);
        component.set("v.isOtcChecked",false);
        component.set("v.searchFamily",searchText);
        component.set("v.searchText",searchText);
        for(var i=0;i<alldata.length;i++){
            if (alldata[i].isSelected==false)
            {
                count++;     
                
            }
            
        }
        
        
        
        
        
        
        
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
                            if (arry[i].prdlist.Id === ProductList[j].prdlist.Id) {
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
                        if (arry[i].prdlist.Id === prodId) {
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
        component.set("v.showSelectedProducts", true);
        component.set("v.isQLlistempty",false);
        var allProducts=component.get("v.Allproduct");
        var selectedProductsIds = component.get("v.selectedProductsIds");
        var data=[];
         var pData;
        for(let j = 0; j < allProducts.length; j++){
            pData=allProducts[j];
             if (selectedProductsIds.includes(pData.prdlist.Id)) {
                    
                    pData.isSelected = true;
                     data.push(pData); 
                }
                
        }
        
        component.set("v.QLlist",data);
        
    },
    
    insertProducts: function (component, event, helper) {
        
        var quoteId =component.get("v.recordId");
        var  saveitems1=[];
        saveitems1=component.get("v.QLlist");
        
        let res = component.find("newWAC");
        if(res!= null && res.length>1){
            for(let i = 0; i < res.length; i++){
                component.set("v.wacToast",false);
                let val = res[i].get("v.value"); 
                console.log("val-----------"+val);
               if(val==undefined || val=='' || val==null){
                  //  if(val==0){
                    console.log("-----1-----");
                    component.set("v.wacToast",true);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        message:'Please Enter New WAC',
                        duration:' 4000',
                        key: 'info_alt',
                        type: 'error',
                        mode: 'dismissible'
                    });
                    toastEvent.fire();  
                    break;
                   // if(component.get("v.wacToast")==true){
                     //   console.log("----2---");
                     //   break;    
                    //}
                }
            }
        }
        
        if(res.length==1 || res.length==undefined){
            let res1 = Array.isArray(res);
            if(res1==false){
                 component.set("v.wacToast",false);
                var nwWAC=component.find('newWAC').get("v.value");    
                if(nwWAC==null || nwWAC==undefined || nwWAC==''){
                    component.set("v.wacToast",true);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        message:'Please Enter New WAC',
                        duration:' 4000',
                        key: 'info_alt',
                        type: 'error',
                        mode: 'dismissible'
                    });
                    toastEvent.fire();        
                }    
            }
            if(res1==true){
                for(let i = 0; i < res.length; i++){
                     console.log('---------1---2---');
                   // component.set("v.wacToast",false);
                    let val34 = res[i].get("v.value"); 
                   // console.log("val34-----------"+val34);
                    let val = res[i].get("v.value"); 
                    console.log("val-----------"+val);
                    if(val34==undefined || val34==' ' || val34==null){
                     console.log('---------1-----3-');
                        component.set("v.wacToast",true);
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            message:'Please Enter New WAC',
                            duration:' 4000',
                            key: 'info_alt',
                            type: 'error',
                            mode: 'dismissible'
                        });
                        toastEvent.fire();   
                        if(component.get("v.wacToast")==true){
                            break;    
                        }
                    } 
                    else{
                         console.log('---------1----4');
                        component.set("v.wacToast",false); 
                    }
                }   
            }
        }
        
      
        
        
        
        
     /*   let resDate = component.find("effDate");
        if(resDate!= null && resDate.length>1){
            for(let i = 0; i < resDate.length; i++){
                component.set("v.effDateToast",false);
                
                let valDate = resDate[i].get("v.value"); 
              
                if(valDate==undefined || valDate==' ' || valDate==null){
                    console.log("-----1-----");
                    component.set("v.effDateToast",true);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        message:'Please Enter Effective Date',
                        duration:' 4000',
                        key: 'info_alt',
                        type: 'error',
                        mode: 'dismissible'
                    });
                    toastEvent.fire();   
                    if(component.get("v.effDateToast")==true){
                        console.log("----2---");
                        break;    
                    }
                }
            }
        }
        
        if(resDate.length==1 || resDate.length==undefined){
            let resp = Array.isArray(resDate);
            if(resp==false){
                   component.set("v.effDateToast",false);
                var effctDate=component.find('effDate').get("v.value");    
                if(effctDate==null || effctDate==undefined || effctDate==' '){
                    component.set("v.effDateToast",true);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        message:'Please Enter Effective Date',
                        duration:' 4000',
                        key: 'info_alt',
                        type: 'error',
                        mode: 'dismissible'
                    });
                    toastEvent.fire();        
                }    
            }
            
            if(resp==true){
                for(let i = 0; i < resDate.length; i++){
                   // component.set("v.effDateToast",false);
                    
                    let val2 = resDate[i].get("v.value"); 
                    console.log("val-----------"+val2);
                    if(val2==undefined || val2=='' || val2==null){
                        console.log("-----1-----");
                        component.set("v.effDateToast",true);
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            message:'Please Enter Effective Date',
                            duration:' 4000',
                            key: 'info_alt',
                            type: 'error',
                            mode: 'dismissible'
                        });
                        toastEvent.fire();   
                        if(component.get("v.effDateToast")==true){
                            break;    
                        }
                    }
                    else{
                       component.set("v.effDateToast",false);  
                    }
                    
                }   
            }
        }
      */
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        var wac= component.get("v.wacToast");
       // var effdate= component.get("v.effDateToast");
        
      //  if(wac==false && effdate==false){
                    if(wac==false ){

            
            component.set("v.showSpinnerSelProds",true);
            var action = component.get("c.saveQuoteItems");
            var wrap=component.get("v.wrap");
            // console.log('JSON.stringify(wrap)---------'+JSON.stringify(wrap));
            //  console.log('saveitems1---------'+saveitems1);
            //  console.log('saveitems1--JSON.stringify-------'+JSON.stringify(saveitems1));
            action.setParams({ "saveitems": saveitems1, "bidWrapper": component.get("v.wrap") });
            action.setCallback(this, function (response) {
                var actState = response.getState();
                console.log('actState' + actState)
                var error= response.getError();
                console.log('-------------error-------'+error[0]);
                if (actState === 'SUCCESS') {
                    component.set("v.showSpinnerSelProds",false);
                    var resposeData = response.getReturnValue();
                    component.set("v.showSelectedProducts", false);
                    component.set("v.showProducts", false);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type": 'success',
                        "message": "New Line Items has been added successfully."
                    });
                    toastEvent.fire();
                    $A.get('e.force:refreshView').fire();
                    var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                    "url": "/lightning/cmp/c__Phoenix_BidWACEditLineItems?c__recordId="+component.get("v.recordId")
                });
                urlEvent.fire();
                     $A.get('e.force:refreshView').fire();
                    /*var pageReference = {
                        type: "standard__recordPage",
                        attributes: {
                            recordId: component.get("v.recordId"),
                            objectApiName: "Phoenix_Bid__c",
                            actionName: "view"
                        }
                    };
                    var navService = component.find("navigationService");
                    navService.navigate(pageReference);*/
                }
                else{
                    component.set("v.showSpinnerSelProds",false);
                }
            });
            $A.enqueueAction(action);  
            
            
        }
        
        
        
        
        //  }
        
    },
    
    removeDeletedRowProd: function (component, event, helper) {
        var selectedRec = event.getSource().get("v.name");
        var AllRowsList = component.get("v.QLlist");
        if (AllRowsList.length === 1) {
            console.log('AllRowsList.length === 1');
        }
        for (let i = 0; i < AllRowsList.length; i++) {
            var pItem = AllRowsList[i];
            if (pItem.prdlist.Id == selectedRec) {
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
                    if (alldata[j].prdlist.Id == AllRowsList[i].prdlist.Id)
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
        //  $A.get('e.force:refreshView').fire(); 
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
    
    fileUpload: function (component, event, helper) {
        component.set("v.showProducts", false);
        component.set("v.showSelectedProducts", true);
        component.set("v.showbutton",false);
        var quoteId =component.get("v.recordId");
        var  saveitems1=[];
        saveitems1=component.get("v.QLlist");
     var quoteId =component.get("v.recordId");
        var  saveitems1=[];
        saveitems1=component.get("v.QLlist");
        
        let res = component.find("newWAC");
        if(res!= null && res.length>1){
            for(let i = 0; i < res.length; i++){
                component.set("v.wacToast",false);
                let val = res[i].get("v.value"); 
                console.log("val-----------"+val);
               if(val==undefined || val=='' || val==null){
                  //  if(val==0){
                    console.log("-----1-----");
                    component.set("v.wacToast",true);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        message:'Please Enter New WAC',
                        duration:' 4000',
                        key: 'info_alt',
                        type: 'error',
                        mode: 'dismissible'
                    });
                    toastEvent.fire();  
                    break;
                   // if(component.get("v.wacToast")==true){
                     //   console.log("----2---");
                     //   break;    
                    //}
                }
            }
        }
        
        if(res.length==1 || res.length==undefined){
            let res1 = Array.isArray(res);
            if(res1==false){
                 component.set("v.wacToast",false);
                var nwWAC=component.find('newWAC').get("v.value");    
                if(nwWAC==null || nwWAC==undefined || nwWAC==''){
                    component.set("v.wacToast",true);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        message:'Please Enter New WAC',
                        duration:' 4000',
                        key: 'info_alt',
                        type: 'error',
                        mode: 'dismissible'
                    });
                    toastEvent.fire();        
                }    
            }
            if(res1==true){
                console.log('---------1------');
                for(let i = 0; i < res.length; i++){
                     console.log('---------1---2---');
                   // component.set("v.wacToast",false);
                    let val34 = res[i].get("v.value"); 
                   // console.log("val34-----------"+val34);
                    let val = res[i].get("v.value"); 
                    console.log("val-----------"+val);
                    if(val34==undefined || val34==' ' || val34==null){
                     console.log('---------1-----3-');
                        component.set("v.wacToast",true);
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            message:'Please Enter New WAC',
                            duration:' 4000',
                            key: 'info_alt',
                            type: 'error',
                            mode: 'dismissible'
                        });
                        toastEvent.fire();   
                        if(component.get("v.wacToast")==true){
                            break;    
                        }
                    } 
                    else{
                         console.log('---------1----4');
                        component.set("v.wacToast",false); 
                    }
                }   
            }
        }
        
      
        
        
        
        
/*        let resDate = component.find("effDate");
        if(resDate!= null && resDate.length>1){
            for(let i = 0; i < resDate.length; i++){
                component.set("v.effDateToast",false);
                
                let valDate = resDate[i].get("v.value"); 
              
                if(valDate==undefined || valDate==' ' || valDate==null){
                    console.log("-----1-----");
                    component.set("v.effDateToast",true);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        message:'Please Enter Effective Date',
                        duration:' 4000',
                        key: 'info_alt',
                        type: 'error',
                        mode: 'dismissible'
                    });
                    toastEvent.fire();   
                    if(component.get("v.effDateToast")==true){
                        console.log("----2---");
                        break;    
                    }
                }
            }
        }
        
        if(resDate.length==1 || resDate.length==undefined){
            let resp = Array.isArray(resDate);
            if(resp==false){
                   component.set("v.effDateToast",false);
                var effctDate=component.find('effDate').get("v.value");    
                if(effctDate==null || effctDate==undefined || effctDate==' '){
                    component.set("v.effDateToast",true);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        message:'Please Enter Effective Date',
                        duration:' 4000',
                        key: 'info_alt',
                        type: 'error',
                        mode: 'dismissible'
                    });
                    toastEvent.fire();        
                }    
            }
            
            if(resp==true){
                for(let i = 0; i < resDate.length; i++){
                   // component.set("v.effDateToast",false);
                    
                    let val2 = resDate[i].get("v.value"); 
                    console.log("val-----------"+val2);
                    if(val2==undefined || val2=='' || val2==null){
                        console.log("-----1-----");
                        component.set("v.effDateToast",true);
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            message:'Please Enter Effective Date',
                            duration:' 4000',
                            key: 'info_alt',
                            type: 'error',
                            mode: 'dismissible'
                        });
                        toastEvent.fire();   
                        if(component.get("v.effDateToast")==true){
                            break;    
                        }
                    }
                    else{
                       component.set("v.effDateToast",false);  
                    }
                    
                }   
            }
        }*/
      
        var wac= component.get("v.wacToast");
      //  var effdate= component.get("v.effDateToast");
        
       // if(wac==false && effdate==false){
              if(wac==false ){
            
          
            component.set("v.showuploadFile", true);
            // component.set("v.showSelectedProducts", true);
            //component.set("v.showSpinnerSelProds",true);
            var action = component.get("c.saveQuoteItems");
            var wrap=component.get("v.wrap");
            console.log('JSON.stringify(wrap)---------'+JSON.stringify(wrap));
            console.log('saveitems1---------'+saveitems1);
            console.log('saveitems1--JSON.stringify-------'+JSON.stringify(saveitems1));
            action.setParams({ "saveitems": saveitems1, "bidWrapper": component.get("v.wrap") });
            action.setCallback(this, function (response) {
                var actState = response.getState();
                console.log('actState' + actState)
                if (actState === 'SUCCESS') {
                    
                    
                    component.set("v.showSpinnerSelProds",false);
                    var resposeData = response.getReturnValue();
                    component.set("v.showSelectedProducts", false);
                    component.set("v.showProducts", false);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type": 'success',
                        "message": "New Line Items has been added successfully."
                    });
                    toastEvent.fire();
                    
                }
                else{
                    component.set("v.showSpinnerSelProds",false);
                }
            });
            $A.enqueueAction(action);  
            
            
        }
        
        //  }
        
        
    },
    
    showSelectedProd: function (component, event, helper) {
        component.set("v.showuploadFile", false);
        component.set("v.showProducts", false);
        component.set("v.showSelectedProducts", true);
        component.set("v.isQLlistempty",false);
        var allProducts=component.get("v.Allproduct");
        var selectedProductsIds = component.get("v.selectedProductsIds");
        var data=[];
        var pData;
        for(let j = 0; j < allProducts.length; j++){
            pData=allProducts[j];
            if (selectedProductsIds.includes(pData.prdlist.Id)) {
                
                pData.isSelected = true;
                data.push(pData); 
            }
        }
        component.set("v.QLlist",data);
    },
    
    removeDeletedRowLineItem: function (component, event, helper) {
        var selectedRec = event.getSource().get("v.name");
        var AllRowsList = component.get("v.allProductRelatedToBid");
        if (AllRowsList.length === 1) {
        }
        for (let i = 0; i < AllRowsList.length; i++){
            var pItem = AllRowsList[i];
            if (pItem.qlItem.Id == selectedRec) {
                var index = AllRowsList.indexOf(pItem);
                if (index > -1) {
                    AllRowsList.splice(index, 1);
                    var AllRowsList1 = AllRowsList;
                }
                
            }
        }
        component.set("v.allProductRelatedToBid",[]);
        component.set("v.allProductRelatedToBid", AllRowsList);
        var saveditems = component.get("v.allProductRelatedToBid");
        var alldata=component.get("v.allData");
        var prdlist1=[];
        component.set("v.selectedProductsIds",[]);
        var count=0;
        if(AllRowsList!=undefined && AllRowsList!=null && AllRowsList!='' && AllRowsList.length>0)
        {
            for (let i = 0; i < AllRowsList.length; i++) {
                for (let j = 0; j < alldata.length; j++) {
                    if (alldata[j].qlItem.Id == AllRowsList[i].qlItem.Id)
                    {
                        count=count+1;
                        prdlist1.push(alldata[j].qlItem.Id);
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
        
        console.log('-----AllRowsList1-----'+AllRowsList1.length);
    },
    handleUploadFinished: function (component, event, helper) {
        var uploadedFiles = event.getParam("files");
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Success',
            message: 'The document(s) uploaded successfully',
            duration:' 5000',
            key: 'info_alt',
            type: 'success',
            mode: 'dismissible'
        });
        toastEvent.fire();
       var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                    "url": "/lightning/cmp/c__Phoenix_BidWACEditLineItems?c__recordId="+component.get("v.recordId")
                });
                urlEvent.fire();
                     $A.get('e.force:refreshView').fire();
    },
     /* javaScript function for pagination */
    navigation: function(component, event, helper) {
        var sObjectList = component.get("v.listOfAllAccounts");
        var end = component.get("v.endPage");
        var start = component.get("v.startPage");
        var pageSize = component.get("v.pageSizeCV");
        var whichBtn = event.getSource().get("v.name");
        // check if whichBtn value is 'next' then call 'next' helper method
        if (whichBtn == 'next') {
            component.set("v.currentPage", component.get("v.currentPage") + 1);
            helper.next(component, event, sObjectList, end, start, pageSize);
        }
        // check if whichBtn value is 'previous' then call 'previous' helper method
        else if (whichBtn == 'previous') {
            component.set("v.currentPage", component.get("v.currentPage") - 1);
            helper.previous(component, event, sObjectList, end, start, pageSize);
        }
        // check if whichBtn value is 'First' then call 'First' helper method
        else if (whichBtn == 'first') {
            var starting = pageSize;
            var lastPage = pageSize - 1;
            component.set("v.currentPage", 1);
            helper.previous(component, event, sObjectList, lastPage, starting, pageSize);
        }
        // check if whichBtn value is 'Last' then call 'Last' helper method
        else if (whichBtn == 'last') {
            var tPageCount = component.get("v.totalPagesCount");
            var starting = (tPageCount-2)* pageSize;
            var lastPage = (tPageCount - 1)* pageSize - 1;
            component.set("v.currentPage", component.get("v.totalPagesCount"));
            helper.next(component, event, sObjectList, lastPage, starting, pageSize);
        }
        
        var curPage = component.get("v.currentPage");
        var totalPC = component.get("v.totalPagesCount");
        
        if(curPage == 1) component.set('v.isFirstPage', true);
        else component.set('v.isFirstPage', false);
        
        if(curPage == totalPC) component.set('v.isLastPage', true);
        else component.set('v.isLastPage', false);
        
        var elmnt = document.getElementById("tableDiv");
 		elmnt.scrollTop=0;
        //console.log('Next');
    },
    
    processMeCV: function(component, event, helper) {
        var sObjectList = component.get("v.listOfAllAccounts");
        var pageSize = component.get("v.pageSizeCV");
        var whichPage = event.target.name;
        var totalPC = component.get("v.totalPagesCount");
        var curPage = component.get('v.currentPage');
        console.log('totalPC::'+totalPC);
        
        if(whichPage == 1) component.set('v.isFirstPage', true);
        else component.set('v.isFirstPage', false);
        
        if(whichPage == totalPC) component.set('v.isLastPage', true);
        else component.set('v.isLastPage', false);
        
        component.set('v.isSelectedNo', whichPage);
        
        console.log('whichPage::'+whichPage);
        
        console.log('isSelectedNo::'+component.get('v.isSelectedNo'));
        
        if (whichPage) {
            var start = (whichPage - 1) * pageSize;
            var end = (start + pageSize) - 1;
            console.log('end::'+end);
            component.set('v.currentPage', parseInt(whichPage));
            helper.processPageNumber(component, event, sObjectList, end, start, pageSize);
        }
        var elmnt = document.getElementById("tableDiv");
 		elmnt.scrollTop=0;
    },
 
    selectAllCheckboxes: function(component, event, helper) {
        var selectedHeaderCheck = event.getSource().get("v.value");
        var updatedAllRecords = [];
        var updatedPaginationList = [];
        var listOfAllAccounts = component.get("v.listOfAllAccounts");
        var PaginationList = component.get("v.PaginationList");
        // play a for loop on all records list 
        for (var i = 0; i < listOfAllAccounts.length; i++) {
            // check if header checkbox is 'true' then update all checkbox with true and update selected records count
            // else update all records with false and set selectedCount with 0  
            if (selectedHeaderCheck == true) {
                listOfAllAccounts[i].isChecked = true;
                component.set("v.selectedRowsCount", listOfAllAccounts.length);
            } else {
                listOfAllAccounts[i].isChecked = false;
                component.set("v.selectedRowsCount", 0);
            }
            updatedAllRecords.push(listOfAllAccounts[i]);
        }
        // update the checkbox for 'PaginationList' based on header checbox 
        for (var i = 0; i < PaginationList.length; i++) {
            if (selectedHeaderCheck == true) {
                PaginationList[i].isChecked = true;
            } else {
                PaginationList[i].isChecked = false;
            }
            updatedPaginationList.push(PaginationList[i]);
        }
        component.set("v.listOfAllAccounts", updatedAllRecords);
        component.set("v.PaginationList", updatedPaginationList);
    },
 
    checkboxSelect: function(component, event, helper) {
        // on each checkbox selection update the selected record count 
        var selectedRec = event.getSource().get("v.value");
        var getSelectedNumber = component.get("v.selectedRowsCount");
        if (selectedRec == true) {
            getSelectedNumber++;
        } else {
            getSelectedNumber--;
            component.find("selectAllId").set("v.value", false);
        }
        component.set("v.selectedRowsCount", getSelectedNumber);
        // if all checkboxes are checked then set header checkbox with true   
        if (getSelectedNumber == component.get("v.totalRecordsCountCV")) {
            component.find("selectAllId").set("v.value", true);
        }
    },
     backToBid : function(component, event, helper){
        let pageReference = component.get("v.pageReference");
        let recordId = pageReference.state.c__recordId;
        component.set("v.recordId",recordId);
        component.find("navigationService").navigate({
            type: "standard__recordPage",
            attributes: {
                recordId: component.get("v.recordId"),
                actionName: "view"
            }
        }, false);
        $A.get('e.force:refreshView').fire();
    }, 

 
    
})