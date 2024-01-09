({
    closeActionPanel: function (component, event, helper) {
        
    },
    
    getBidDetailsViewPage: function (component, helper) {
        
        
        component.set("v.showRecordView", true);
        let pageReference = component.get("v.pageReference");
        let recordId = pageReference.state.c__recordId;
        if (recordId != null && recordId != undefined && recordId != '') {
            component.set("v.recordId", recordId);
        }
        var bidId = component.get("v.recordId");
        var getQuoteInfo = component.get("c.getBidInfo");
        getQuoteInfo.setParams({ "bidId": bidId });
        getQuoteInfo.setCallback(this, function (response) {
            var actState = response.getState();
            if (actState === 'SUCCESS') {
                if(response.getReturnValue().bid.Id!=undefined && response.getReturnValue().bid.Id!=null && response.getReturnValue().bid.Id!='')
                {
                    
                    
                    component.set("v.recordId", recordId);                    
                    component.set("v.bidNumber", response.getReturnValue().bid.Name);    
                    component.set("v.bidName",response.getReturnValue().bid.Phoenix_Bid_Name__c);
                    component.set("v.wrap", response.getReturnValue());                               
                    component.set("v.approvalStatus",response.getReturnValue().bid.Phoenix_Approval_Status__c);
                    component.set("v.busStatus",response.getReturnValue().bid.Phoenix_Business_Approval__c);
                    console.log('---------response.getReturnValue().bid.Phoenix_Business_Approval__c-------'+response.getReturnValue().bid.Phoenix_Business_Approval__c);
                    component.set("v.busCom",response.getReturnValue().bid.Phoenix_Business_Approval_Comments__c);
                    component.set("v.countryStatus",response.getReturnValue().bid.Phoenix_Country_Head_Approval__c);
                    component.set("v.countryCom",response.getReturnValue().bid.Phoenix_Country_Head_Comments__c);
                    component.set("v.finStatus",response.getReturnValue().bid.Phoenix_Finance_Approval__c);
                    component.set("v.finCom",response.getReturnValue().bid.Phoenix_Finance_Approval_Comments__c);
                    component.set("v.contrStatus",response.getReturnValue().bid.Phoenix_Contracts_Approval__c);
                    component.set("v.contrCom",response.getReturnValue().bid.Phoenix_Contracts_Approval_Comments__c);
                    
                    if(response.getReturnValue().bid.Phoenix_Approval_Status__c=='Business Head'){
                        console.log('-----------1---------');
                        if(response.getReturnValue().bid.Phoenix_Business_Approval__c==undefined){
                            component.set("v.showProceedBtn",false);          
                        }
                        else if(response.getReturnValue().bid.Phoenix_Business_Approval__c==''){
                            component.set("v.showProceedBtn",false);          
                        }
                            else{
                                component.set("v.showProceedBtn",true); 
                            }
                        
                    }
                    
                    if(response.getReturnValue().bid.Phoenix_Approval_Status__c=='Finance'){
                        if(response.getReturnValue().bid.Phoenix_Finance_Approval__c==''){
                            component.set("v.showProceedBtn",false);       
                        }
                        else if(response.getReturnValue().bid.Phoenix_Finance_Approval__c==undefined){
                            component.set("v.showProceedBtn",false);          
                        }
                            else{
                                component.set("v.showProceedBtn",true); 
                            }
                    }
                    
                    
                    if(response.getReturnValue().bid.Phoenix_Approval_Status__c=='Contracts'){
                        if(response.getReturnValue().bid.Phoenix_Contracts_Approval__c==''){
                            component.set("v.showProceedBtn",false);          
                        }
                        else if(response.getReturnValue().bid.Phoenix_Contracts_Approval__c==undefined){
                            component.set("v.showProceedBtn",false);          
                        }
                            else{
                                component.set("v.showProceedBtn",true); 
                            }
                        
                    }
                    
                    if(response.getReturnValue().bid.Phoenix_Approval_Status__c=='Country Head'){
                        if(response.getReturnValue().bid.Phoenix_Country_Head_Approval__c==''){
                            component.set("v.showProceedBtn",false);          
                        }
                        else if(response.getReturnValue().bid.Phoenix_Business_Approval__c==undefined){
                            component.set("v.showProceedBtn",false);          
                        }
                            else{
                                component.set("v.showProceedBtn",true); 
                            }
                        
                    }
                    var fileList=[];
                    var totalFiles=[];
                    var checked=false;
                    totalFiles=response.getReturnValue().conDocLink
                    if(totalFiles!=undefined&&totalFiles!=null)
                    {
                        for(var i=0;i<totalFiles.length;i++)
                        {
                            console.log('---33333333---1-----');
                            fileList.push({"Id":totalFiles[i].ContentDocumentId,"Title":totalFiles[i].ContentDocument.Title+'.'+totalFiles[i].ContentDocument.FileExtension,"checked":checked});
                        }
                    }
                    component.set("v.fileList",fileList);
                    component.set("v.loggedInUserName",response.getReturnValue().loggedInUserId);
                    component.set("v.isBusinessApprovePerson",response.getReturnValue().isBusinessApprovePerson);
                    component.set("v.isCountryApprovePerson",response.getReturnValue().isCountryApprovePerson);
                    component.set("v.isFinanceApprovePerson",response.getReturnValue().isFinanceApprovePerson);
                    component.set("v.isContractsApprovePerson",response.getReturnValue().isContractsApprovePerson);
                    helper.loadBidRelatedLineItems(component,helper);
                }
            }
        });
        $A.enqueueAction(getQuoteInfo);
    },
    
    loadBidRelatedLineItems: function (component, helper) {
        var quotewrap = component.get("v.wrap");
        var getProductsAction = component.get("c.getproductsrelatedtoBid");
        getProductsAction.setParams({
            "quotewrap": quotewrap 
        });
        getProductsAction.setCallback(this, function (response) {
            var actState = response.getState();
            if (actState === 'SUCCESS') {
                var resposeData = response.getReturnValue();
                component.set("v.allProductRelatedToBid",resposeData);
                console.log('-----------resposeData------'+JSON.stringify(resposeData));
                if(resposeData.length>0){
                    component.set("v.showNoRecMsg", false);    
                    console.log('-----------resposeData-***-----'+resposeData[0].qlItem.Phoenix_Effective_Date__c);
                    component.set("v.effectiveDate",resposeData[0].qlItem.Phoenix_Effective_Date__c); 
                    if(resposeData[0].qlItem.Phoenix_Effective_Date__c!=undefined){
                        component.set("v.isEffDateExists",true);
                        
                        
                    }
                }
                else{
                              component.set("v.showNoRecMsg", true);    
      
                }
                
                component.set("v.showRecordView", true);
                var OutDiv = component.find("mainDiv1");
                if(resposeData==undefined){
                    console.log('------1----------');
                    $A.util.addClass(OutDiv,"noheightClass");
                }
                else if(resposeData.length<4){
                    $A.util.addClass(OutDiv,"noheightClass");
                    
                }
                    else{
                        $A.util.removeClass(OutDiv,"noheightClass");
                        console.log('------1------2----');
                        //  $A.util.addClass(OutDiv,"heightClass");
                    }
            }
            
        });
        $A.enqueueAction(getProductsAction);
    },
    
    /*
     * this function will build table data
     * based on current page selection
     * */
    buildData: function (component, helper) {
        var data = [];
        let selectedProductsIds = component.get("v.selectedProductsIds");
        var pageNumber = component.get("v.currentPageNumber");
        var pageSize = component.get("v.pageSize");
        var allData = component.get("v.allData");
        var x = (pageNumber - 1) * pageSize;
        var pData;
        var copyList=[];
        component.set("v.ProductCopyList",copyList);
        
        //creating data-table data
        for (; x < (pageNumber) * pageSize; x++) {
            pData = allData[x];
            if (pData) {
                pData.isSelected = false;
                if (selectedProductsIds.includes(pData.prdlist.Id)) {
                    
                    pData.isSelected = true;
                }
                data.push(pData);
            }
        }
        component.set("v.ProductList", data);
        var searchName=component.get("v.searchText");
        var searchFamily=component.get("v.searchFamily");
        
        if(searchName!=null && searchName!=''&&searchName!=undefined&&searchFamily!=null &&searchFamily!=''&&searchFamily!=undefined&&data!=null&&data!=''&&data!=undefined){
            component.set("v.ProductCopyList",data);  
        }
        console.log('ProductCopyList length--'+component.get("v.ProductCopyList").length);
        if(data.length>0){
            var selectCount=0;
            for(var i=0;i<data.length;i++){
                if(data[i].isSelected==true){
                    selectCount++;
                }
            }
            
            if(selectCount==pageSize ||selectCount==i){
                component.set("v.selectAll",true);  
                
            }
            else{
                component.set("v.selectAll",false); 
            }
        }
        
        helper.generatePageList(component, pageNumber);
    },
    
    /*
     * this function generate page list
     * */
    generatePageList: function (component, pageNumber) {
        pageNumber = parseInt(pageNumber);
        var pageList = [];
        var totalPages = component.get("v.totalPages");
        if (totalPages > 1) {
            if (totalPages <= 10) {
                var counter = 2;
                for (; counter < (totalPages); counter++) {
                    pageList.push(counter);
                }
            } else {
                if (pageNumber < 5) {
                    pageList.push(2, 3, 4, 5, 6);
                } else {
                    if (pageNumber > (totalPages - 5)) {
                        pageList.push(totalPages - 5, totalPages - 4, totalPages - 3, totalPages - 2, totalPages - 1);
                    } else {
                        pageList.push(pageNumber - 2, pageNumber - 1, pageNumber, pageNumber + 1, pageNumber + 2);
                    }
                }
            }
        }
        component.set("v.pageList", pageList);
    },
    convertArrayOfObjectsToCSV : function(component,objectRecords){
        // console.log('JSON.stringify(objectrecords)---------'+JSON.stringify(objectRecords));
        // declare variables
        var csvStringResult, counter, keys,columnDivider, lineDivider;
        
        // check if "objectRecords" parameter is null, then return from function
        if (objectRecords == null || !objectRecords.length) {
            return null;
        }
        // store ,[comma] in columnDivider variabel for sparate CSV values and 
        // for start next line use '\n' [new line] in lineDivider varaible  
        columnDivider = ',';
        lineDivider =  '\n';
        csvStringResult = '';
        var myMap = new Map();
        myMap.set("Product Name", "qlItem.Phoenix_Product__r.Name");
        myMap.set("Product Code", "Phoenix_Product_Code__c");
        myMap.set("NDC - 11", "Phoenix_NDC_National_Drug_Code__c");
        myMap.set("Product Family", "qlItem.Phoenix_Product__r.Product_Family__r.Name");
        myMap.set("Current WAC", "Phoenix_WAC__c");
        myMap.set("New WAC", "Phoenix_New_WAC__c");
        myMap.set("Effective Date", "qlItem.Phoenix_Effective_Date__c");
        csvStringResult += Array.from(myMap.keys()).join(columnDivider);
        csvStringResult += lineDivider;
        for(var i=0; i < objectRecords.length; i++){  
            counter = 0;
            for (let [key, value] of myMap) {
                if(counter > 0){ 
                    csvStringResult += columnDivider; 
                }
                //console.log('JSON.stringify(Result)---------'+JSON.stringify(objectRecords[i]["qlItem"]["Phoenix_Product_Code__c"]));
                if(value=='qlItem.Phoenix_Product__r.Name'){
                    csvStringResult += '"'+ objectRecords[i]["qlItem"]["Phoenix_Product__r"]["Name"]+'"';
                }
                else if(value == "qlItem.Phoenix_Effective_Date__c"){
                    var effectiveDate=objectRecords[i]["qlItem"]["Phoenix_Effective_Date__c"];
                    var dt = new Date(effectiveDate);
                    var month = dt.getMonth() + 1;
                    var day = dt.getDate();
                    var year = dt.getFullYear();
                    var formatteddate = month + "-" + day + "-" + year;
                    csvStringResult += '"'+formatteddate+'"'
                    console.log('formatteddate--->'+formatteddate);
                }
                    else if(objectRecords[i]["qlItem"][value]==undefined){
                        csvStringResult += '"'+''+'"';
                    }
                        else{
                            csvStringResult += '"'+ objectRecords[i]["qlItem"][value]+'"';
                        }
                
                counter++;
            }
            csvStringResult += lineDivider;
        }
        //new logic end 
        return csvStringResult;  
    },
    handleUploadFinished : function(component, event) {
        let pageReference = component.get("v.pageReference");
        let recordId = pageReference.state.c__recordId;
        component.set("v.recordId",recordId);
        console.log('------recordId-----'+recordId);
        var action = component.get('c.getDocs');
        action.setParams({'bidId' : component.get("v.recordId")});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var fileList=[];
                var totalFiles=[];
                var checked=false;
                totalFiles=response.getReturnValue();
                if(totalFiles!=undefined&&totalFiles!=null)
                {
                    for(var i=0;i<totalFiles.length;i++)
                    {
                        fileList.push({"Id":totalFiles[i].ContentDocumentId,"Title":totalFiles[i].ContentDocument.Title+'.'+totalFiles[i].ContentDocument.FileExtension,"checked":checked});
                    }
                }
                component.set("v.fileList",fileList);
            }  
        });
        $A.enqueueAction(action);
    } 
    
})