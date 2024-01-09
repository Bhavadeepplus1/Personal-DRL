({
    loadInstance: function(component, event){
        var action = component.get("c.getRelatedList");
        action.setParams({
            'recordId': component.get("v.recordId")
        });
        action.setCallback(this, function(response){
            if(response.getState() == 'SUCCESS'){
                component.set("v.isNoteAccept", true);
                var responseWrap = response.getReturnValue();
                console.log('json response==>'+JSON.stringify(responseWrap))
                var lineItems = responseWrap.lineItemsList;
                component.set("v.isMarketingApprovePerson", responseWrap.isMarketingHeadApprovePerson);
                component.set("v.IsMarketingLeadUser", responseWrap.IsMarketingLeadUser);
                component.set("v.MarketingHeadUser", responseWrap.MarketingHeadUser);
                console.log('Wrapper Response::: '+JSON.stringify(responseWrap));
                 console.log('MarketingHeadUser::: '+ component.get("v.MarketingHeadUser"));
                component.set("v.Name", responseWrap.bidRecord.Phoenix_WAC_Price_for_New_Launch_Name__c);
                component.set("v.ProductFamily", responseWrap.bidRecord.Product_Family__c);
                component.set("v.SelectedProductFamily", responseWrap.bidRecord.Phoenix_Product_Family__c);
                component.set("v.Summary", responseWrap.bidRecord.Phoenix_Summary__c);
                component.set("v.ProductType", responseWrap.bidRecord.Phoenix_Product_Type__c);
                component.set("v.ApprovalStatus", responseWrap.bidRecord.Phoenix_Approval_Status__c);
                //component.set("v.ApprovalStatus", 'Draft1');
                component.set("v.NetSales", responseWrap.bidRecord.Phoenix_Net_sales_annualized__c);
                component.set("v.TPT", responseWrap.bidRecord.Phoenix_TPT__c);
                component.set("v.GM", responseWrap.bidRecord.Phoenix_GM__c);
                component.set("v.ProductDirector", responseWrap.bidRecord.Phoenix_Product_Director__c);
                console.log('test market lead==>'+responseWrap.bidRecord.Phoenix_Marketing_Lead__c)
                component.set("v.MarketingLead", responseWrap.bidRecord.Phoenix_Marketing_Lead__c);
                component.set("v.HeadOfMarketingApproval", responseWrap.bidRecord.Phoenix_Head_of_Marketing_Approval__c);
                component.set("v.HeadOfMarketingComments", responseWrap.bidRecord.Phoenix_Head_of_Marketing_Comments__c);
                component.set("v.HeadOfPMGrp", responseWrap.bidRecord.Phoenix_Marketing_Head__c);
                  console.log('MarketingHeadUser1::: '+ responseWrap.bidRecord.Phoenix_Marketing_Head__c);
                component.set("v.HeadOfPMGrpApproval", responseWrap.bidRecord.Phoenix_Head_of_PM_Grp_Approval__c);
                component.set("v.HeadOfPMGrpComments", responseWrap.bidRecord.Phoenix_Head_of_PM_Grp_Comments__c);
                component.set("v.showWACLines", true);
                component.set("v.loaded", false);
                component.set("v.loggedInUserId", responseWrap.loggedInUserId);
                var marketingLead = responseWrap.bidRecord.Phoenix_Marketing_Lead__c;
                var marketingHead = responseWrap.bidRecord.Phoenix_Marketing_Head__c;
                var loggedInUser = responseWrap.loggedInUserId;
                
                var LeadApproval=component.get("v.HeadOfMarketingApproval");
        var HeadApproval=component.get("v.HeadOfPMGrpApproval"); 
         var ApprovalStatus=component.get("v.ApprovalStatus"); 
     
           
        if((LeadApproval=='Approved' || LeadApproval=='Not Approved')&& ApprovalStatus!='Draft'){
              component.set("v.disableMarketingLeadSubmit", false);
            console.log('disableMarketingLeadSubmit---');
}
         if((HeadApproval=='Approved' || HeadApproval=='Not Approved')&& ApprovalStatus!='Draft'){
            component.set("v.disableMarketingHeadSubmit", false);
               console.log('disableMarketingHeadSubmit---');
}
                if(loggedInUser == marketingLead){
                    component.set("v.isMarketingLead", true);
                }
                if(loggedInUser == marketingHead){
                    component.set("v.isMarketingHead", true);
                }
                var productsData = [];
                for(var i=0; i<lineItems.length; i++){
                    lineItems[i].ProductName = lineItems[i].Phoenix_Product__r.Name;
                    lineItems[i].TPT_GM = lineItems[i].Phoenix_TPT_GM__c / 100;
                    productsData.push(lineItems[i]);
                }
                component.set("v.productsData", productsData);
                if(productsData.length == 0){
                    component.set("v.totalPages", 1);
                } else{
                    component.set("v.totalPages", Math.ceil(productsData.length/component.get("v.pageSize")));
                    component.set("v.disableSubmit", true);
                    component.set("v.disableSaveLines", true);
                }
                component.set("v.currentPageNumber",1);
                this.buildData(component, event);
                this.handleUpload(component, event);
            }
        });
        $A.enqueueAction(action);
    },
   
	getProducts : function(component, event) {
		var action = component.get("c.getProducts");
        console.log('Selected Family '+component.get("v.SelectedProductFamily"));
        action.setParams({
            'productFamily': component.get("v.ProductFamily")
        });
        action.setCallback(this,function(response) {
            var state = response.getState();
            if(state=='SUCCESS'){
                var resp = response.getReturnValue();
                console.log('Resp:: '+JSON.stringify(resp));
                var buildData = [];
                for(var i=0; i<resp.length; i++){
                    var instance = {};
                    instance.Name = '';
                    instance.Phoenix_Material_Number__c = resp[i].ProductCode;
                    instance.Phoenix_NDC_11__c = resp[i].Phoenix_NDC_11__c;
                    instance.Phoenix_Product__c = resp[i].Id;
                    instance.ProductName = resp[i].Name;
                    instance.Phoenix_Pkg_Size__c = resp[i].Phoenix_Pkg_Size__c;
                    instance.Phoenix_New_Product_WAC_Pricing__c = component.get("v.recordId");
                    instance.TPT_GM = '';
                    buildData.push(instance);
                }
                component.set("v.productsData", buildData);
                if(buildData.length == 0){
                    component.set("v.totalPages", 1);   
                    component.set("v.disableSaveLines", true);
                } else{
                    component.set("v.totalPages", Math.ceil(buildData.length/component.get("v.pageSize")));
                    component.set("v.disableSaveLines", false);
                }
                component.set("v.currentPageNumber",1);
                component.set("v.disableSubmit", false);
                this.buildData(component, event);
            } else{
                console.log("Error "+JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action); 
	},
    
    
    showUploadModal: function(component, event){
        component.set("v.showFileUpload", true);
    },
    
    closeModal: function(component, event){
        component.set("v.showFileUpload", false);
        component.set("v.openDeletePopupModal", false);
        component.set("v.showSubmitModal", false);
    },
    
    handleUpload: function(component, event){
        var action = component.get("c.getDocs");
        action.setParams({
            "recordId": component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var fileList=[];
                var totalFiles=[];
                var checked=false;
                totalFiles=response.getReturnValue();
                if(totalFiles!=undefined&&totalFiles!=null && totalFiles!='')
                {
                    for(var i=0;i<totalFiles.length;i++)
                    {
                        fileList.push({"Id":totalFiles[i].ContentDocumentId,"Title":totalFiles[i].ContentDocument.Title+'.'+totalFiles[i].ContentDocument.FileExtension,"checked":checked});
                    }
                }
                component.set("v.fileList",fileList);
            } else{
                console.log("Error "+JSON.stringify(response.getError()));
            } 
            
        });
        $A.enqueueAction(action);
    },
    
    //pagination code
    buildData : function(component) {
        var data = [];
        var pageNumber = component.get("v.currentPageNumber");
        var pageSize = component.get("v.pageSize");
        var allData = component.get("v.productsData");
        var x = (pageNumber-1)*pageSize;
        
        //creating data-table data
        for(; x<(pageNumber)*pageSize; x++){
            if(allData[x]){
            	data.push(allData[x]);
            }
        }
        component.set("v.data", data);
        
        this.generatePageList(component, pageNumber);
    },
    
    /*
     * this function generate page list
     * */
    generatePageList : function(component, pageNumber){
        pageNumber = parseInt(pageNumber);
        var pageList = [];
        var totalPages = component.get("v.totalPages");
        if(totalPages > 1){
            if(totalPages <= 10){
                var counter = 2;
                for(; counter < (totalPages); counter++){
                    pageList.push(counter);
                } 
            } else{
                if(pageNumber < 5){
                    pageList.push(2, 3, 4, 5, 6);
                } else{
                    if(pageNumber>(totalPages-5)){
                        pageList.push(totalPages-5, totalPages-4, totalPages-3, totalPages-2, totalPages-1);
                    } else{
                        pageList.push(pageNumber-2, pageNumber-1, pageNumber, pageNumber+1, pageNumber+2);
                    }
                }
            }
        }
        component.set("v.pageList", pageList);
    },
    getProductInfo: function(component, event){
        var action = component.get("c.getProductInfo");
        action.setParams({
            'productFamily': component.get("v.SelectedProductFamily")
        });
        action.setCallback(this, function(response){
            if(response.getState() == 'SUCCESS'){
                var resp = response.getReturnValue();
                var productDirector = '';
                var marketingLead = '';
                var productType = '';
                for(var i=0; i<resp.length; i++){
                    if(resp[i].Phoenix_Product_Director__c == null || resp[i].Phoenix_Product_Director__c == '' || resp[i].Phoenix_Product_Director__c == undefined){
                    } else{
                        productDirector = resp[i].Phoenix_Product_Director__c;
                    }
                    if(resp[i].Phoenix_Marketing_Lead__c == null || resp[i].Phoenix_Marketing_Lead__c == '' || resp[i].Phoenix_Marketing_Lead__c == undefined){
                    } else{
                        marketingLead = resp[i].Phoenix_Marketing_Lead__c;
                    }
                    if(resp[i].Phoenix_Is_partner_product__c == null || resp[i].Phoenix_Is_partner_product__c == '' || resp[i].Phoenix_Is_partner_product__c == undefined){
                    } else{
                        productType = resp[i].Phoenix_Is_partner_product__c;
                    }
                }
                component.set("v.ProductDirector", productDirector);
                 console.log('test2 market lead==>'+marketingLead)

                component.set("v.MarketingLead", marketingLead);
                if(productType == true){
                 	component.set("v.ProductType", 'Partner');
                    component.set("v.TPT", '');
                    component.set("v.GM", '');
                } else{
                    component.set("v.ProductType", 'DRL');
                    component.set("v.TPT", '');
                    component.set("v.GM", '');
                }
            } else{
                console.log("Error "+JSON.stringify(response.getError()));
            } 
        });
        $A.enqueueAction(action);
    },
    
    sortBy: function(component, field) {
        var sortAsc = component.get("v.sortAsc"),
            sortField = component.get("v.sortField"),
            records = component.get("v.productsData");
        sortAsc = field == sortField? !sortAsc: true;
        records.sort(function(a,b){
            var t1 = a[field] == b[field],
                t2 = (!a[field] && b[field]) || (a[field] < b[field]);
                //t2 = a[field] > b[field];
            return t1? 0: (sortAsc?-1:1)*(t2?-1:1);
        });
        if(sortAsc == true){
            component.set("v.arrowDirection", 'arrowup');
        } else {
            component.set("v.arrowDirection", 'arrowdown');
        }
        component.set("v.sortAsc", sortAsc);
        component.set("v.sortField", field);
        component.set("v.productsData", records);
        this.buildData(component, event);
    },
    
    deleteLines: function(component, event){
        var action = component.get("c.deleteLineItems");
        console.log('Items to delete:: '+component.get("v.itemsToBeDeletedFromDB"));
        action.setParams({
            'recordIds': component.get("v.itemsToBeDeletedFromDB")
        });
        action.setCallback(this, function(response){
            if(response.getState()=="SUCCESS"){
                component.set("v.loaded", false);
                var resp = response.getReturnValue();
                console.log('Deleted Items');
                component.set("v.productsData", []);
                component.set("v.data", []);
                component.set("v.disableSaveLines", true);
                component.set("v.disableSubmit", false);
                var message = 'Line items deleted';
                this.showSuccessToast(component, event, message);
            } else{
                console.log("Error "+JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);
    },
    
    showSuccessToast : function(component, event, message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Success!',
            message: message,
            duration:' 5000',
            key: 'info_alt',
            type: 'success'
        });
        toastEvent.fire();
    },
    
    showErrorToast : function(component, event, message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Warning!',
            message: message,
            duration:' 5000',
            key: 'info_alt',
            type: 'error'
        });
        toastEvent.fire();
    },  
    deleteWACPricingLine: function(component, event){
        var AllLinesList = component.get("v.productsData");
        var AllRowsList = component.get("v.data");
        var index = component.get("v.indexVar");
        var action = component.get("c.deleteWACPricingLine");
        var lineId = component.get("v.deleteWACPricingLineId");
        action.setParams({
            'recordId': lineId
        });
        action.setCallback(this, function(response) {
            if(response.getState()=="SUCCESS"){
                console.log('Successfully deleted');
                this.closeModal(component, event);
                AllRowsList.splice(index, 1);
                AllLinesList.splice(index, 1);
                component.set("v.productsData", AllLinesList);
                if(AllLinesList.length == 0){
                    component.set("v.totalPages", 1);   
                } else{
                    component.set("v.totalPages", Math.ceil(component.get("v.productsData").length/component.get("v.pageSize")));
                }
                component.set("v.currentPageNumber",1);
                this.buildData(component, event);
            } else{
                console.log("Error "+JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);
    },
    
     getBidInfoForValids: function (component, event, helper) {
        component.set('v.loaded', true);
        var action = component.get("c.getSubmitBidInfo");
        action.setParams({
            bidId: component.get("v.recordId")
        });
        action.setCallback(this, function (response) {
            if (response.getState() == "SUCCESS") {
                var resposneString = response.getReturnValue();
                console.log(resposneString);
                if (resposneString == 'Success') {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "message": "This record is sent for approval.",
                        "type": "success",
                        "mode": "dismissible"
                    });
                    toastEvent.fire();
                    component.set('v.loaded', false);
                    component.find("navService").navigate({
                        type: "standard__recordPage",
                        attributes: {
                            recordId: component.get("v.recordId"),
                            actionName: "view"
                        }
                    }, false);
                } else {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": resposneString,
                        "type": "error",
                        "mode": "dismissible"
                    });
                    toastEvent.fire();
                    component.set('v.loaded', false);
                }
            }
        });
        $A.enqueueAction(action);
    },
})