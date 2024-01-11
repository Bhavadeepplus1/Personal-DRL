({
    doInit : function(component, event, helper) {
        component.set('v.loaded',true);
                 var searchName=component.get("v.searchText");
 component.set("v.showNonCompliance",'ShowAll');
        var getBidInfoAction = component.get("c.getOnlyComplianceData");
       
        var id = component.get("v.recordId");
        console.log('id-->'+id);
        getBidInfoAction.setParams({
           searchText : searchName,
            customerId :component.get("v.recordId"),
            showNonCompliance :'ShowAll',
            showPrimary:component.get("v.showPrimary"),
            isDirect: component.get("v.isDirect"),
            isIndirect: component.get("v.isIndirect"),
            isTotal: component.get("v.isTotal")
           
        });
        getBidInfoAction.setCallback(this, function (response) {
            var actState = response.getState();
            if (actState == 'SUCCESS') {
                component.set('v.loaded',false);
                var responseWrapper=response.getReturnValue();
                component.set('v.ShowHide',responseWrapper.ShowHide);
                component.set("v.isProcessed",responseWrapper.isProcessed);
                component.set("v.responseObj",responseWrapper);
                helper.getData(component, event,responseWrapper);
                component.set('v.loaded',false);
              //  component.set("v.showNonCompliance","Month1");
               
               
            }
            else{
               
                console.log('errot---'+JSON.stringify(response.getError()));
            }
           
        });
        $A.enqueueAction(getBidInfoAction);
       
    },
    expandAll: function(component, event, helper){
       
        var data = component.get("v.RxComplianceObject");
        data.forEach(function(item){
            item.showProdFam = true;
            item.expandCollapse = true;
            component.set("v.expandCollapse",false);
           
        });
       
        component.set("v.RxComplianceObject", data);
       
    },
    collapseAll: function(component, event, helper){
       
        var data = component.get("v.RxComplianceObject");
        data.forEach(function(item){
            item.showProdFam = false;
            item.expandCollapse = false;
            component.set("v.expandCollapse",true);
           
        });
       
        component.set("v.RxComplianceObject", data);
       
    },
    handleClick1: function(component, event, helper){
        var pfName = event.getSource().get("v.name");
        console.log('pfName: '+pfName);
        var data = component.get("v.RxComplianceObject");
        console.log('Data pfName:: '+JSON.stringify(data));
        data.forEach(function(item){
            if(item.prodFamName == pfName && item != undefined ){
                console.log('prodFamName===='+item.prodFamName)
                item.showProdFam = false;
                item.expandCollapse = false;
                console.log('item===='+item)
            }
        });
       
        component.set("v.RxComplianceObject", data);
       
    },
    handleClick2: function(component, event, helper){
        var pfName = event.getSource().get("v.name");
        console.log('pfName: '+pfName);
        var data = component.get("v.RxComplianceObject");
        console.log('Data pfName:: '+JSON.stringify(data));
        data.forEach(function(item){
            if(item.prodFamName == pfName && item != undefined ){
                console.log('shoe pf --')      
                item.showProdFam = true;
                item.expandCollapse = true;
            }
        });
        component.set("v.RxComplianceObject", data);
       
    },
    downloadCsv : function(component,event,helper){    
       
        var exportList = [];
        var RxComplianceObject = component.get("v.RxComplianceObject");
        var familyTotalsMap = new Map();
        RxComplianceObject.forEach(function(item){
            familyTotalsMap[item.prodFamName] = item;
            item.rxComplianceList.forEach(function(item1){
                exportList.push(item1);
            });
        });
        console.log('exportList====='+JSON.stringify(exportList));
        // call the helper function which "return" the CSV data as a String  
        var csv = helper.convertArrayOfObjectsToCSV(component,exportList,familyTotalsMap);  
        if (csv == null){return;}
       
        // ####--code for create a temp. <a> html tag [link tag] for download the CSV file--####    
        var hiddenElement = document.createElement('a');
        hiddenElement.href = 'data:text/csv;charset=utf-8,' + encodeURI(csv);
        hiddenElement.target = '_self'; //      
        var date = new Date();
        var hours = date.getHours();
        var minutes = date.getMinutes();
        var newformat = hours >= 12 ? 'PM' : 'AM';  
        hours = hours % 12;  
        hours = hours ? hours : 12;  
        minutes = minutes < 10 ? '0' + minutes : minutes;        
        var Now=(date.getMonth()+1)+'/'+date.getDate()+'/'+date.getFullYear()+' '+hours+':'+minutes+' '+newformat;
        hiddenElement.download = 'Compliance based on Awarded Quantity'+'-'+Now+'.csv';  // CSV file Name* you can change it.[only name not .csv]
        document.body.appendChild(hiddenElement); // Required for FireFox browser
        hiddenElement.click(); // using click() js function to download csv file
       
    },
    onsearch: function (component, event, helper) {
       
        component.set("v.noData",false);
        var searchName=component.get("v.searchText");
        component.set('v.loaded',true);
        console.log('searchName====='+component.get("v.showNonCompliance"));
        var action = component.get("c.getOnlyComplianceData");
       
        action.setParams({
            searchText : searchName,
            customerId :component.get("v.recordId"),
            showAll: component.get("v.showAll"),
            showNonCompliance  :component.get("v.showNonCompliance"),
            showPrimary:component.get("v.showPrimary"),
            isDirect: component.get("v.isDirect"),
            isIndirect: component.get("v.isIndirect"),
            isTotal: component.get("v.isTotal"),
            productDirector: component.get("v.userId")
           
        });
        action.setCallback(this, function (response) {
            var actState = response.getState();
            if (actState == 'SUCCESS') {
                component.set('v.loaded',false);
                var responseWrapper=response.getReturnValue();
                component.set('v.ShowHide',responseWrapper.ShowHide);
                component.set("v.responseObj",responseWrapper);
                helper.getData(component, event,responseWrapper);
                component.set("v.expandCollapse",true);
               
                component.set('v.loaded',false);
            }
            else{
               
                console.log('errot---'+JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);
       
    },
    openPage : function(component, event, helper){
        component.set("v.loaded", true);
        var selectedPageNumber = event.getSource('').get('v.label');
        if(selectedPageNumber != component.get("v.selectedPageNumber")){
            var lineItems = component.get("v.RxComplianceObject");
            var pagedLineItems = lineItems.slice((selectedPageNumber-1)*50,((selectedPageNumber-1)*50)+50);
            component.set("v.pagedLineItems",pagedLineItems);
            component.set("v.selectedPageNumber",selectedPageNumber);
           
            //var LineItemtable = component.find("LineTable");
            // $A.util.addClass(LineItemtable, "maintable");
        }
        component.set("v.loaded", false);
    },
    /*directIndirect : function(component, event, helper) {
     var version = component.get("v.isDirectIndirect");
        console.log('test->'+component.get("v.isDirectIndirect"));
        var isCheck = component.get("v.isDirectIndirect");
        var trueValue = true;
        var falsevalue = false;
        if(isCheck == false){
            component.set("v.isDirectIndirect",falsevalue);
        }
        else{
            component.set("v.isDirectIndirect",trueValue);
        }
          component.set('v.loaded',true);
        var getBidInfoAction = component.get("c.getIndirectComplianceData");
       
        getBidInfoAction.setParams({
            isDirectIndirect :component.get("v.isDirectIndirect"),
            customerId :component.get("v.recordId")
           
        });
        getBidInfoAction.setCallback(this, function (response) {
            var actState = response.getState();
            if (actState == 'SUCCESS') {
                 component.set('v.loaded',false);
               
                var responseWrapper=response.getReturnValue();
                console.log('Bid analysis-->'+JSON.stringify(responseWrapper));
                component.set("v.customerProductList",responseWrapper.customerProductList);
                  component.set("v.noOfRecords",responseWrapper.noOfRecords);
            }
           
        });
        $A.enqueueAction(getBidInfoAction);
},*/
    QuantityValue : function(component, event, helper) {
        //var version = component.get("v.isQuantityValue");
        component.set('v.loaded',true);
        console.log('test->'+component.get("v.isQuantityValue"));
        var isCheck = component.get("v.isQuantityValue");
        var trueValue = true;
        var falsevalue = false;
        if(isCheck == false){      
            component.set("v.isQuantityValue",falsevalue);  
        }
        else{  
            component.set("v.isQuantityValue",trueValue);
        }
        //   component.set('v.ShowHide',ShowHide);
       
       
        var getBidInfoAction = component.get("c.getOnlyComplianceData");
       
       
        var id = component.get("v.recordId");
        console.log('id-->'+id);
        getBidInfoAction.setParams({
           
            customerId :component.get("v.recordId"),
            showAll: component.get("v.showAll"),
            showNonCompliance  :component.get("v.showNonCompliance"),
            isQuantityValue:component.get("v.isQuantityValue"),
            isDirect: component.get("v.isDirect"),
            isIndirect: component.get("v.isIndirect"),
            isTotal: component.get("v.isTotal"),
            productDirector: component.get("v.userId")
           
        });
        getBidInfoAction.setCallback(this, function (response) {
            var actState = response.getState();
            if (actState == 'SUCCESS') {
               
                var responseWrapper=response.getReturnValue();
                component.set('v.ShowHide',responseWrapper.ShowHide);
                console.log('Bid analysis-->'+JSON.stringify(responseWrapper));
                component.set("v.responseObj",responseWrapper);
                helper.getData(component, event,responseWrapper);
                component.set("v.expandCollapse",true);
               
                component.set('v.loaded',false);
            }
            else{
               
                console.log('errot---'+JSON.stringify(response.getError()));
            }
           
        });
        $A.enqueueAction(getBidInfoAction);
       
    },
    showPrimary : function(component, event, helper) {
        //var version = component.get("v.isQuantityValue");
        var searchName=component.get("v.searchText");
        component.set('v.loaded',true);
        console.log('test->'+component.get("v.showPrimary"));
        var isCheck = component.get("v.showPrimary");
        var trueValue = true;
        var falsevalue = false;
        if(isCheck == false){      
            component.set("v.showPrimary",falsevalue);  
        }
        else{  
            component.set("v.showPrimary",trueValue);
        }
        //   component.set('v.ShowHide',ShowHide);
       
       
        var getBidInfoAction = component.get("c.getOnlyComplianceData");
       
       
        var id = component.get("v.recordId");
        console.log('id-->'+id);
        getBidInfoAction.setParams({
            searchText : searchName,
            customerId :component.get("v.recordId"),
            showAll: component.get("v.showAll"),
            showNonCompliance  :component.get("v.showNonCompliance"),
            showPrimary:component.get("v.showPrimary"),
            isDirect: component.get("v.isDirect"),
            isIndirect: component.get("v.isIndirect"),
            isTotal: component.get("v.isTotal"),
            productDirector: component.get("v.userId")
           
        });
        getBidInfoAction.setCallback(this, function (response) {
            var actState = response.getState();
            if (actState == 'SUCCESS') {
               
                var responseWrapper=response.getReturnValue();
                component.set('v.ShowHide',responseWrapper.ShowHide);
                console.log('Bid analysis-->'+JSON.stringify(responseWrapper));
                component.set("v.responseObj",responseWrapper);
                helper.getData(component, event,responseWrapper);
                component.set("v.expandCollapse",true);
               
                component.set('v.loaded',false);
            }
            else{
               
                console.log('errot---'+JSON.stringify(response.getError()));
            }
           
        });
        $A.enqueueAction(getBidInfoAction);
       
    },
    showAll : function(component, event, helper) {
        var searchName=component.get("v.searchText");
        component.set('v.loaded',true);
        var version = component.get("v.showAll");
        console.log('test->'+component.get("v.showAll"));
        var isCheck = component.get("v.showAll");
        var trueValue = true;
        var falsevalue = false;
        if(isCheck == false){
            component.set("v.showAll",falsevalue);
        }
        else{
            component.set("v.showAll",trueValue);
        }
       
        var getBidInfoAction = component.get("c.getOnlyComplianceData");
       
       
        var id = component.get("v.recordId");
        console.log('id-->'+id);
        getBidInfoAction.setParams({
            searchText : searchName,
            customerId :component.get("v.recordId"),
            showAll: component.get("v.showAll"),
            showNonCompliance  :component.get("v.showNonCompliance"),
            showPrimary:component.get("v.showPrimary"),
            isDirect: component.get("v.isDirect"),
            isIndirect: component.get("v.isIndirect"),
            isTotal: component.get("v.isTotal"),
            productDirector: component.get("v.userId")
           
        });
        getBidInfoAction.setCallback(this, function (response) {
            var actState = response.getState();
            if (actState == 'SUCCESS') {
               
               
                var responseWrapper=response.getReturnValue();
                component.set('v.ShowHide',responseWrapper.ShowHide);
                console.log('Bid analysis-->'+JSON.stringify(responseWrapper));
                component.set("v.responseObj",responseWrapper);
                helper.getData(component, event,responseWrapper);
                component.set("v.expandCollapse",true);
               
                component.set('v.loaded',false);
            }
            else{
               
                console.log('errot---'+JSON.stringify(response.getError()));
            }
           
        });
        $A.enqueueAction(getBidInfoAction);
       
    },
    show6Months : function(component, event, helper) {
        var version = component.get("v.show6Months");
        console.log('test->'+component.get("v.show6Months"));
        var isCheck = component.get("v.show6Months");
        var trueValue = true;
        var falsevalue = false;
        if(isCheck == false){
            component.set("v.show6Months",falsevalue);
        }
        else{
            component.set("v.show6Months",trueValue);
        }
        //  component.set('v.ShowHide',ShowHide);
    },
    sortByprodDescription: function(component, event, helper) {
        console.log('inside sortByprodDescription');
        component.set('v.loaded',true);
       
        helper.sortHelper(component, event, 'Vision_Product__r.Name');
        //  component.set("v.loaded", true);
       
    },
    closeModel: function(component, event, helper) {
        // Set isModalOpen attribute to true
        component.set("v.isModalOpen", false);
       
    },
    openModal: function(component, event, helper) {
        // Set isModalOpen attribute to true
        component.set("v.isModalOpen", true);
       
    },
    handleChange : function(component, event, helper) {
        console.log('Selected Contract Id: '+component.get("v.selectedContract"));
        component.set("v.loaded", true);
        var getBidInfoAction = component.get("c.getselectedContractData");
       
       
        var id = component.get("v.recordId");
        console.log('id-->'+id);
        getBidInfoAction.setParams({
           
            customerId :component.get("v.recordId"),
            showAll :component.get("v.showAll")
           
           
        });
        getBidInfoAction.setCallback(this, function (response) {
            var actState = response.getState();
            if (actState == 'SUCCESS') {
               
                //  component.set('v.ShowHide',ShowHide);
                var responseWrapper=response.getReturnValue();
                console.log('response contract-->'+JSON.stringify(responseWrapper));
                component.set('v.ShowHide',responseWrapper.ShowHide);
                component.set("v.responseObj",responseWrapper);
                component.set("v.noOfRecords",responseWrapper.noOfRecords);
                component.set("v.RxComplianceObject",responseWrapper.rxComplianceList);
                component.set("v.expandCollapse",true);
               
                component.set('v.loaded',false);
            }
            else{
               
                console.log('errot---'+JSON.stringify(response.getError()));
            }
           
        });
        $A.enqueueAction(getBidInfoAction);
       
    },
    /*  isDirectView: function(component, event, helper) {
        component.set('v.loaded',true);
     var checkCmp = component.find("chkbox");
        // resultCmp = cmp.find("checkResult");
        console.log('chkbox----'+checkCmp.get("v.value"));
        component.set("v.isDirect",checkCmp.get("v.value"));
                    component.set("v.isTotal",false);

    },*/
    isDirectView: function(component, event, helper) {
        component.set('v.loaded',true);
        var isCheck = component.get("v.isDirect");
        var trueValue = true;
        var falsevalue = false;
        /*  if(isCheck == false){
            component.set("v.isDirect",falsevalue);
            component.set("v.isTotal",trueValue);
        }
        else{
            component.set("v.isDirect",trueValue);
            component.set("v.isTotal",falsevalue);
        }
       
        //component.set("v.isTotal",false);
        component.set("v.isIndirect",false);*/
        //  component.set("v.isDirect",!(component.get("v.isDirect")));
       var searchName=component.get("v.searchText");
        if(isCheck == false){
            component.set("v.isDirect",falsevalue);
        }
        else{
            component.set("v.isDirect",trueValue);
        }
        component.set("v.isTotal",false);
        component.set("v.isIndirect",false);
        var getBidInfoAction = component.get("c.getOnlyComplianceData");
       
       
        var id = component.get("v.recordId");
        console.log('id-->'+id);
        getBidInfoAction.setParams({
           searchText : searchName,
            customerId :component.get("v.recordId"),
            showAll: component.get("v.showAll"),
            showNonCompliance  :component.get("v.showNonCompliance"),
            showPrimary:component.get("v.showPrimary"),
            isDirect: component.get("v.isDirect"),
            isIndirect: component.get("v.isIndirect"),
            isTotal: component.get("v.isTotal"),
            productDirector: component.get("v.userId")
           
        });
        getBidInfoAction.setCallback(this, function (response) {
            var actState = response.getState();
            if (actState == 'SUCCESS') {
               
               
                var responseWrapper=response.getReturnValue();
                component.set('v.ShowHide',responseWrapper.ShowHide);
                console.log('Bid analysis-->'+JSON.stringify(responseWrapper));
                component.set("v.responseObj",responseWrapper);
                helper.getData(component, event,responseWrapper);  
                component.set("v.expandCollapse",true);
               
                component.set('v.loaded',false);
            }
            else{
               
                console.log('errot---'+JSON.stringify(response.getError()));
            }
           
        });
        $A.enqueueAction(getBidInfoAction);
       
    },
    isIndirectView: function(component, event, helper) {
        component.set('v.loaded',true);
        var isCheck = component.get("v.isIndirect");
        var trueValue = true;
        var falsevalue = false;
        /*   if(isCheck == false){
            component.set("v.isIndirect",falsevalue);
            component.set("v.isTotal",trueValue);
        }
        else{
            component.set("v.isIndirect",trueValue);
            component.set("v.isTotal",falsevalue);
        }
        // component.set("v.isTotal",false);
        component.set("v.isDirect",false);*/
        var searchName=component.get("v.searchText");
        if(isCheck == false){
            component.set("v.isIndirect",falsevalue);
        }
        else{
            component.set("v.isIndirect",trueValue);
        }
        component.set("v.isTotal",false);
        component.set("v.isDirect",false);
        var getBidInfoAction = component.get("c.getOnlyComplianceData");
       
       
        var id = component.get("v.recordId");
        console.log('id-->'+id);
        getBidInfoAction.setParams({
           searchText : searchName,
            customerId :component.get("v.recordId"),
            showAll: component.get("v.showAll"),
            showNonCompliance  :component.get("v.showNonCompliance"),
            showPrimary:component.get("v.showPrimary"),
            isDirect: component.get("v.isDirect"),
            isIndirect: component.get("v.isIndirect"),
            isTotal: component.get("v.isTotal"),
            productDirector: component.get("v.userId")
           
        });
        getBidInfoAction.setCallback(this, function (response) {
            var actState = response.getState();
            if (actState == 'SUCCESS') {
               
               
                var responseWrapper=response.getReturnValue();
                component.set('v.ShowHide',responseWrapper.ShowHide);
                console.log('Bid analysis-->'+JSON.stringify(responseWrapper));
                component.set("v.responseObj",responseWrapper);
                helper.getData(component, event,responseWrapper);
                component.set("v.expandCollapse",true);
               
                component.set('v.loaded',false);
            }
            else{
               
                console.log('errot---'+JSON.stringify(response.getError()));
            }
           
        });
        $A.enqueueAction(getBidInfoAction);
       
    },
    isTotalView: function(component, event, helper) {
        component.set('v.loaded',true);
        console.log('isTotal->'+component.get("v.isTotal"));
        var isCheck = component.get("v.isTotal");
        var trueValue = true;
        var falsevalue = false;
        /*   if(isCheck == false){
            component.set("v.isTotal",falsevalue);
            component.set("v.isDirect",trueValue);
        }
        else{
            component.set("v.isTotal",trueValue);
            component.set("v.isDirect",falsevalue);
        }
        component.set("v.isIndirect",false);*/
        var searchName=component.get("v.searchText");
        if(isCheck == false){
            component.set("v.isTotal",falsevalue);
        }
        else{
            component.set("v.isTotal",trueValue);
        }
        component.set("v.isIndirect",false);
        component.set("v.isDirect",false);
        var getBidInfoAction = component.get("c.getOnlyComplianceData");
       
       
        var id = component.get("v.recordId");
        console.log('id-->'+id);
        getBidInfoAction.setParams({
           searchText : searchName,
            customerId :component.get("v.recordId"),
            showAll: component.get("v.showAll"),
            showNonCompliance  :component.get("v.showNonCompliance"),
            showPrimary:component.get("v.showPrimary"),
            isDirect: component.get("v.isDirect"),
            isIndirect: component.get("v.isIndirect"),
            isTotal: component.get("v.isTotal"),
            productDirector: component.get("v.userId")
           
        });
        getBidInfoAction.setCallback(this, function (response) {
            var actState = response.getState();
            if (actState == 'SUCCESS') {
               
               
                var responseWrapper=response.getReturnValue();
                component.set('v.ShowHide',responseWrapper.ShowHide);
                // console.log('Bid analysis-->'+JSON.stringify(responseWrapper));
                component.set("v.responseObj",responseWrapper);
                helper.getData(component, event,responseWrapper);  
                component.set("v.expandCollapse",true);
               
                component.set('v.loaded',false);
            }
            else{
               
                console.log('errot---'+JSON.stringify(response.getError()));
            }
           
        });
        $A.enqueueAction(getBidInfoAction);
       
       
    },
    openModal: function(component, event, helper) {
        // Set isModalOpen attribute to true
        component.set("v.isModalOpen", true);
       
    },
   selectedVal: function(component, event, helper){
        console.log('Selected Director: '+component.get("v.userId"));
        var getBidInfoAction = component.get("c.getOnlyComplianceData");
                        var searchName=component.get("v.searchText");
        component.set('v.loaded',true);
       
        var id = component.get("v.recordId");
        console.log('id-->'+id);
        getBidInfoAction.setParams({
            searchText : searchName,
            customerId :component.get("v.recordId"),
            showAll: component.get("v.showAll"),
            showNonCompliance  :component.get("v.showNonCompliance"),
            showPrimary:component.get("v.showPrimary"),
            isDirect: component.get("v.isDirect"),
            isIndirect: component.get("v.isIndirect"),
            isTotal: component.get("v.isTotal"),
            productDirector: component.get("v.userId")
           
        });
        getBidInfoAction.setCallback(this, function (response) {
            var actState = response.getState();
            if (actState == 'SUCCESS') {
               
               
                var responseWrapper=response.getReturnValue();
                component.set('v.ShowHide',responseWrapper.ShowHide);
                // console.log('Bid analysis-->'+JSON.stringify(responseWrapper));
                component.set("v.responseObj",responseWrapper);
                helper.getData(component, event,responseWrapper);  
                component.set("v.expandCollapse",true);
               
                component.set('v.loaded',false);
            }
            else{
               
                console.log('errot---'+JSON.stringify(response.getError()));
            }
           
        });
        $A.enqueueAction(getBidInfoAction);
       
       
    },
    onChange: function (component, event, helper) {
         var searchName=component.get("v.searchText");
        component.set("v.showNonCompliance",component.find('select').get('v.value'));
        //  alert(component.find('select').get('v.value') + ' pie is good.');
        console.log('showNonCompliance====='+component.get("v.showNonCompliance"));
        var getBidInfoAction = component.get("c.getOnlyComplianceData");
       
        component.set('v.loaded',true);
       
        var id = component.get("v.recordId");
        console.log('id-->'+id);
        getBidInfoAction.setParams({
           searchText : searchName,
            customerId :component.get("v.recordId"),
            showAll: component.get("v.showAll"),
            showNonCompliance  :component.get("v.showNonCompliance"),
            showPrimary:component.get("v.showPrimary"),
            isDirect: component.get("v.isDirect"),
            isIndirect: component.get("v.isIndirect"),
            isTotal: component.get("v.isTotal"),
            productDirector: component.get("v.userId")
           
        });
        getBidInfoAction.setCallback(this, function (response) {
            var actState = response.getState();
            if (actState == 'SUCCESS') {
               
               
                var responseWrapper=response.getReturnValue();
                component.set('v.ShowHide',responseWrapper.ShowHide);
                // console.log('Bid analysis-->'+JSON.stringify(responseWrapper));
                component.set("v.responseObj",responseWrapper);
                helper.getData(component, event,responseWrapper);  
                component.set("v.expandCollapse",true);
               
                component.set('v.loaded',false);
            }
            else{
               
                console.log('errot---'+JSON.stringify(response.getError()));
            }
           
        });
        $A.enqueueAction(getBidInfoAction);
       
       
    },
    numSelected1: function (component, event, helper) {
        var currentValue = event.currentTarget.dataset.value;
        var firstSpan = component.find("downArrow1");
        $A.util.addClass(firstSpan, "firstArrow");
        $A.util.removeClass(component.find("downArrow2"), "firstArrow");
        $A.util.removeClass(component.find("downArrow3"), "firstArrow");
        $A.util.removeClass(component.find("downArrow4"), "firstArrow");
        $A.util.removeClass(component.find("downArrow5"), "firstArrow");
        $A.util.removeClass(component.find("downArrow6"), "firstArrow");
        $A.util.removeClass(component.find("showAll"), "firstArrow");
        var getBidInfoAction = component.get("c.getOnlyComplianceData");        
        component.set('v.loaded',true);
        getBidInfoAction.setParams({
           
            customerId :component.get("v.recordId"),
            showAll: component.get("v.showAll"),
            showNonCompliance  :'1Month',//component.get("v.showNonCompliance"),
            showPrimary:component.get("v.showPrimary"),
            isDirect: component.get("v.isDirect"),
            isIndirect: component.get("v.isIndirect"),
            isTotal: component.get("v.isTotal"),
            productDirector: component.get("v.userId")
           
        });
        getBidInfoAction.setCallback(this, function (response) {
            var actState = response.getState();
            if (actState == 'SUCCESS') {
                var responseWrapper=response.getReturnValue();
                component.set('v.ShowHide',responseWrapper.ShowHide);
                component.set("v.showNonCompliance",'1Month');
                // console.log('Bid analysis-->'+JSON.stringify(responseWrapper));
                component.set("v.responseObj",responseWrapper);
                helper.getData(component, event,responseWrapper);  
                component.set("v.expandCollapse",true);
                component.set('v.loaded',false);
            }
            else{
               
                console.log('errot---'+JSON.stringify(response.getError()));
            }
           
        });
        $A.enqueueAction(getBidInfoAction);
       
    },
    numSelected2: function (component, event, helper) {
        var currentValue = event.currentTarget.dataset.value;
        var firstSpan = component.find("downArrow2");
        $A.util.addClass(firstSpan, "firstArrow");
        $A.util.removeClass(component.find("downArrow1"), "firstArrow");
        $A.util.removeClass(component.find("downArrow3"), "firstArrow");
        $A.util.removeClass(component.find("downArrow4"), "firstArrow");
        $A.util.removeClass(component.find("downArrow5"), "firstArrow");
        $A.util.removeClass(component.find("downArrow6"), "firstArrow");
        $A.util.removeClass(component.find("showAll"), "firstArrow");
         var getBidInfoAction = component.get("c.getOnlyComplianceData");        
        component.set('v.loaded',true);
        getBidInfoAction.setParams({
           
            customerId :component.get("v.recordId"),
            showAll: component.get("v.showAll"),
            showNonCompliance  :'2Month',//component.get("v.showNonCompliance"),
            showPrimary:component.get("v.showPrimary"),
            isDirect: component.get("v.isDirect"),
            isIndirect: component.get("v.isIndirect"),
            isTotal: component.get("v.isTotal"),
            productDirector: component.get("v.userId")
           
        });
        getBidInfoAction.setCallback(this, function (response) {
            var actState = response.getState();
            if (actState == 'SUCCESS') {
                var responseWrapper=response.getReturnValue();
                component.set("v.showNonCompliance",'2Month');
                component.set('v.ShowHide',responseWrapper.ShowHide);
                // console.log('Bid analysis-->'+JSON.stringify(responseWrapper));
                component.set("v.responseObj",responseWrapper);
                helper.getData(component, event,responseWrapper);  
                component.set("v.expandCollapse",true);
                component.set('v.loaded',false);
            }
            else{
               
                console.log('errot---'+JSON.stringify(response.getError()));
            }
           
        });
        $A.enqueueAction(getBidInfoAction);
       
    },
    numSelected3: function (component, event, helper) {
        var currentValue = event.currentTarget.dataset.value;
        var firstSpan = component.find("downArrow3");
        $A.util.addClass(firstSpan, "firstArrow");
        $A.util.removeClass(component.find("downArrow1"), "firstArrow");
        $A.util.removeClass(component.find("downArrow2"), "firstArrow");
        $A.util.removeClass(component.find("downArrow4"), "firstArrow");
        $A.util.removeClass(component.find("downArrow5"), "firstArrow");
        $A.util.removeClass(component.find("downArrow6"), "firstArrow");
        $A.util.removeClass(component.find("showAll"), "firstArrow");
         var getBidInfoAction = component.get("c.getOnlyComplianceData");        
        component.set('v.loaded',true);
        getBidInfoAction.setParams({
           
            customerId :component.get("v.recordId"),
            showAll: component.get("v.showAll"),
            showNonCompliance  :'3Month',//component.get("v.showNonCompliance"),
            showPrimary:component.get("v.showPrimary"),
            isDirect: component.get("v.isDirect"),
            isIndirect: component.get("v.isIndirect"),
            isTotal: component.get("v.isTotal"),
            productDirector: component.get("v.userId")
           
        });
        getBidInfoAction.setCallback(this, function (response) {
            var actState = response.getState();
            if (actState == 'SUCCESS') {
                var responseWrapper=response.getReturnValue();
                component.set("v.showNonCompliance",'3Month');
                component.set('v.ShowHide',responseWrapper.ShowHide);
                // console.log('Bid analysis-->'+JSON.stringify(responseWrapper));
                component.set("v.responseObj",responseWrapper);
                helper.getData(component, event,responseWrapper);  
                component.set("v.expandCollapse",true);
                component.set('v.loaded',false);
            }
            else{
               
                console.log('errot---'+JSON.stringify(response.getError()));
            }
           
        });
        $A.enqueueAction(getBidInfoAction);
       
    },
    numSelected4: function (component, event, helper) {
        var currentValue = event.currentTarget.dataset.value;
        var firstSpan = component.find("downArrow4");
        $A.util.addClass(firstSpan, "firstArrow");
        $A.util.removeClass(component.find("downArrow1"), "firstArrow");
        $A.util.removeClass(component.find("downArrow2"), "firstArrow");
        $A.util.removeClass(component.find("downArrow3"), "firstArrow");
        $A.util.removeClass(component.find("downArrow5"), "firstArrow");
        $A.util.removeClass(component.find("downArrow6"), "firstArrow");
        $A.util.removeClass(component.find("showAll"), "firstArrow");
         var getBidInfoAction = component.get("c.getOnlyComplianceData");        
        component.set('v.loaded',true);
        getBidInfoAction.setParams({
           
            customerId :component.get("v.recordId"),
            showAll: component.get("v.showAll"),
            showNonCompliance  :'4Month',//component.get("v.showNonCompliance"),
            showPrimary:component.get("v.showPrimary"),
            isDirect: component.get("v.isDirect"),
            isIndirect: component.get("v.isIndirect"),
            isTotal: component.get("v.isTotal"),
            productDirector: component.get("v.userId")
           
        });
        getBidInfoAction.setCallback(this, function (response) {
            var actState = response.getState();
            if (actState == 'SUCCESS') {
                var responseWrapper=response.getReturnValue();
                component.set("v.showNonCompliance",'4Month');
                component.set('v.ShowHide',responseWrapper.ShowHide);
                // console.log('Bid analysis-->'+JSON.stringify(responseWrapper));
                component.set("v.responseObj",responseWrapper);
                helper.getData(component, event,responseWrapper);  
                component.set("v.expandCollapse",true);
                component.set('v.loaded',false);
            }
            else{
               
                console.log('errot---'+JSON.stringify(response.getError()));
            }
           
        });
        $A.enqueueAction(getBidInfoAction);
       
    },
    numSelected5: function (component, event, helper) {
        var currentValue = event.currentTarget.dataset.value;
        var firstSpan = component.find("downArrow5");
        $A.util.addClass(firstSpan, "firstArrow");
        $A.util.removeClass(component.find("downArrow1"), "firstArrow");
        $A.util.removeClass(component.find("downArrow2"), "firstArrow");
        $A.util.removeClass(component.find("downArrow3"), "firstArrow");
        $A.util.removeClass(component.find("downArrow4"), "firstArrow");
        $A.util.removeClass(component.find("downArrow6"), "firstArrow");
        $A.util.removeClass(component.find("showAll"), "firstArrow");
         var getBidInfoAction = component.get("c.getOnlyComplianceData");        
        component.set('v.loaded',true);
        getBidInfoAction.setParams({
           
            customerId :component.get("v.recordId"),
            showAll: component.get("v.showAll"),
            showNonCompliance  :'5Month',//component.get("v.showNonCompliance"),
            showPrimary:component.get("v.showPrimary"),
            isDirect: component.get("v.isDirect"),
            isIndirect: component.get("v.isIndirect"),
            isTotal: component.get("v.isTotal"),
            productDirector: component.get("v.userId")
           
        });
        getBidInfoAction.setCallback(this, function (response) {
            var actState = response.getState();
            if (actState == 'SUCCESS') {
                var responseWrapper=response.getReturnValue();
                component.set("v.showNonCompliance",'5Month');
                component.set('v.ShowHide',responseWrapper.ShowHide);
                // console.log('Bid analysis-->'+JSON.stringify(responseWrapper));
                component.set("v.responseObj",responseWrapper);
                helper.getData(component, event,responseWrapper);  
                component.set("v.expandCollapse",true);
                component.set('v.loaded',false);
            }
            else{
               
                console.log('errot---'+JSON.stringify(response.getError()));
            }
           
        });
        $A.enqueueAction(getBidInfoAction);
       
    },
    numSelected6: function (component, event, helper) {
        var currentValue = event.currentTarget.dataset.value;
        var firstSpan = component.find("downArrow6");
        $A.util.addClass(firstSpan, "firstArrow");
        $A.util.removeClass(component.find("downArrow1"), "firstArrow");
        $A.util.removeClass(component.find("downArrow2"), "firstArrow");
        $A.util.removeClass(component.find("downArrow3"), "firstArrow");
        $A.util.removeClass(component.find("downArrow4"), "firstArrow");
        $A.util.removeClass(component.find("downArrow5"), "firstArrow");
        $A.util.removeClass(component.find("showAll"), "firstArrow");
         var getBidInfoAction = component.get("c.getOnlyComplianceData");        
        component.set('v.loaded',true);
        getBidInfoAction.setParams({
           
            customerId :component.get("v.recordId"),
            showAll: component.get("v.showAll"),
            showNonCompliance  :'6Month',//component.get("v.showNonCompliance"),
            showPrimary:component.get("v.showPrimary"),
            isDirect: component.get("v.isDirect"),
            isIndirect: component.get("v.isIndirect"),
            isTotal: component.get("v.isTotal"),
            productDirector: component.get("v.userId")
           
        });
        getBidInfoAction.setCallback(this, function (response) {
            var actState = response.getState();
            if (actState == 'SUCCESS') {
                var responseWrapper=response.getReturnValue();
                component.set("v.showNonCompliance",'6Month');
                component.set('v.ShowHide',responseWrapper.ShowHide);
                // console.log('Bid analysis-->'+JSON.stringify(responseWrapper));
                component.set("v.responseObj",responseWrapper);
                helper.getData(component, event,responseWrapper);  
                component.set("v.expandCollapse",true);
                component.set('v.loaded',false);
            }
            else{
               
                console.log('errot---'+JSON.stringify(response.getError()));
            }
           
        });
        $A.enqueueAction(getBidInfoAction);
       
    },
    numSelected7: function (component, event, helper) {
        var currentValue = event.currentTarget.dataset.value;
        var firstSpan = component.find("showAll");
        $A.util.addClass(firstSpan, "firstArrow");
        $A.util.removeClass(component.find("downArrow1"), "firstArrow");
        $A.util.removeClass(component.find("downArrow2"), "firstArrow");
        $A.util.removeClass(component.find("downArrow3"), "firstArrow");
        $A.util.removeClass(component.find("downArrow4"), "firstArrow");
        $A.util.removeClass(component.find("downArrow5"), "firstArrow");
        $A.util.removeClass(component.find("downArrow6"), "firstArrow");
         var getBidInfoAction = component.get("c.getOnlyComplianceData");        
        component.set('v.loaded',true);
        getBidInfoAction.setParams({
           
            customerId :component.get("v.recordId"),
            showAll: component.get("v.showAll"),
            showNonCompliance  :'ShowAll',//component.get("v.showNonCompliance"),
            showPrimary:component.get("v.showPrimary"),
            isDirect: component.get("v.isDirect"),
            isIndirect: component.get("v.isIndirect"),
            isTotal: component.get("v.isTotal"),
            productDirector: component.get("v.userId")
           
        });
        getBidInfoAction.setCallback(this, function (response) {
            var actState = response.getState();
            if (actState == 'SUCCESS') {
                var responseWrapper=response.getReturnValue();
                component.set("v.showNonCompliance",'ShowAll');
                component.set('v.ShowHide',responseWrapper.ShowHide);
                // console.log('Bid analysis-->'+JSON.stringify(responseWrapper));
                component.set("v.responseObj",responseWrapper);
                helper.getData(component, event,responseWrapper);  
                component.set("v.expandCollapse",true);
                component.set('v.loaded',false);
            }
            else{
               
                console.log('errot---'+JSON.stringify(response.getError()));
            }
           
        });
        $A.enqueueAction(getBidInfoAction);
       
    },
    itemDescDroverMethod: function (component, event, helper) {
        //  var currentValue = event.currentTarget.dataset.value;
        var currentValue =component.find("itemDescDrover");
        if($A.util.isArray(currentValue)){  
            currentValue.forEach(function(item){
                if(item.get("v.alternativeText") == "itemDescDrover"){
                    component.set("v.itemDescDrover",!component.get("v.itemDescDrover"));
                    
                }  
                
                
            });  
        }
        else{
            var itemValue = component.find("itemDescDrover")!= undefined? component.find("itemDescDrover").get("v.alternativeText"): null;
            if(itemValue == "itemDescDrover"){
                component.set("v.itemDescDrover",!component.get("v.itemDescDrover"));
                
            }
        }
       
        
        console.log('currentValue====='+currentValue);
        
        
    },
    qtddroverMethod: function (component, event, helper) {
        //  var currentValue = event.currentTarget.dataset.value;
        var currentValue =component.find("QTDdrover");
        if($A.util.isArray(currentValue)){  
            currentValue.forEach(function(item){
                if(item.get("v.alternativeText") == "QTDdrover"){
                    component.set("v.QTDdrover",!component.get("v.QTDdrover"));
                    
                }  
                
                
            });  
        }
        else{
            var itemValue = component.find("QTDdrover")!= undefined? component.find("QTDdrover").get("v.alternativeText"): null;
            if(itemValue == "QTDdrover"){
                component.set("v.QTDdrover",!component.get("v.QTDdrover"));
                
            }
        }   
        
    },
    ctddroverMethod: function (component, event, helper) {
        //  var currentValue = event.currentTarget.dataset.value;
        var currentValue =component.find("CTDdrover");
        if($A.util.isArray(currentValue)){  
            currentValue.forEach(function(item){
                if(item.get("v.alternativeText") == "CTDdrover"){
                    component.set("v.CTDdrover",!component.get("v.CTDdrover"));
                    
                }  
                
                
            });  
        }
        else{
            var itemValue = component.find("CTDdrover")!= undefined? component.find("CTDdrover").get("v.alternativeText"): null;
            if(itemValue == "CTDdrover"){
                component.set("v.CTDdrover",!component.get("v.CTDdrover"));
                
            }
        }
        
        
        
        
        console.log('currentValue====='+currentValue);
        
        
    },
    ftddroverMethod: function (component, event, helper) {
        //  var currentValue = event.currentTarget.dataset.value;
        var currentValue =component.find("FTDdrower");
        if($A.util.isArray(currentValue)){  
            currentValue.forEach(function(item){
                if(item.get("v.alternativeText") == "FTDdrower"){
                    component.set("v.FTDdrower",!component.get("v.FTDdrower"));
                    
                }  
                
                
            });  
        }
        else{
            var itemValue = component.find("FTDdrower")!= undefined? component.find("FTDdrower").get("v.alternativeText"): null;
            if(itemValue == "FTDdrower"){
                component.set("v.FTDdrower",!component.get("v.FTDdrower"));
                
            }
        }
        
        
        
        
        console.log('currentValue====='+currentValue);
        
        
    },
    mtddroverMethod: function (component, event, helper) {
        //  var currentValue = event.currentTarget.dataset.value;
        var currentValue =component.find("MTDdrover");
        if($A.util.isArray(currentValue)){  
            currentValue.forEach(function(item){
                if(item.get("v.alternativeText") == "MTDdrover"){
                    component.set("v.MTDdrover",!component.get("v.MTDdrover"));
                    
                }  
                
                
            });  
        }
        else{
            var itemValue = component.find("MTDdrover")!= undefined? component.find("MTDdrover").get("v.alternativeText"): null;
            if(itemValue == "MTDdrover"){
                component.set("v.MTDdrover",!component.get("v.MTDdrover"));
                
            }
        }
        
        
        
        console.log('currentValue====='+currentValue);
        
        
    },
    sixMonthsdroverMethod: function (component, event, helper) {
        //  var currentValue = event.currentTarget.dataset.value;
        var currentValue =component.find("sixMonthsDrover");
        if($A.util.isArray(currentValue)){  
            currentValue.forEach(function(item){
                if(item.get("v.alternativeText") == "sixMonthsDrover"){
                    component.set("v.sixMonthsDrover",!component.get("v.sixMonthsDrover"));
                    
                }  
                
                
            });  
        }
        else{
            var itemValue = component.find("sixMonthsDrover")!= undefined? component.find("sixMonthsDrover").get("v.alternativeText"): null;
            if(itemValue == "sixMonthsDrover"){
                component.set("v.sixMonthsDrover",!component.get("v.sixMonthsDrover"));
                
            }
        }
        
        
        
        
        console.log('currentValue====='+currentValue);
        
        
    },
    expandAllDrover: function (component, event, helper) {
        
        component.set("v.itemDescDrover",true);
        component.set("v.drover",true);
        component.set("v.QTDdrover",true);
        component.set("v.FTDdrower",true);
        component.set("v.MTDdrover",true);
        component.set("v.CTDdrover",true);
        component.set("v.sixMonthsDrover",true);
        
    },
    collapseAllDrover: function (component, event, helper) {
        component.set("v.drover",false);
        component.set("v.itemDescDrover",false);
        component.set("v.QTDdrover",false);
        component.set("v.FTDdrower",false);
        component.set("v.MTDdrover",false);
        component.set("v.CTDdrover",false);
        component.set("v.sixMonthsDrover",false);
        
    }
    
})