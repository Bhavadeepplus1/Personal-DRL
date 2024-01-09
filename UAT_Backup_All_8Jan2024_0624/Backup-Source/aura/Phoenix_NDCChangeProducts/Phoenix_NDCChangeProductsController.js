({
    doInit: function(component, event, helper) {
        console.log('Disable add row::: '+component.get("v.disableAddRow"));
        let pageReference = component.get("v.pageReference");
        //let recordId = pageReference;
        var recordId = component.get("v.recordId");
        if (recordId != null && recordId != undefined && recordId != '') {
            component.set("v.recordId", recordId);
            component.set("v.loaded", true);
            helper.loadInstance(component, event);
        } else {
            component.set("v.recordId", null);
            helper.getChangeProductData(component, event);
        }  
        component.set('v.popupColumns', [
            {
                label: 'Account',
                fieldName: 'Account',
                type: 'text',
                sortable: true
            },
            {
                label: 'Contract #',
                fieldName: 'Contract',
                type: 'text',
                sortable: true
            },
            {
                label: 'Contract Description',
                fieldName: 'Phoenix_Contract_Internal_Description__c',
                type: 'text',
                sortable: true
            },
            {
                label: 'NPR Record',
                fieldName: 'NPR_URL',
                type: 'url',
                sortable: true,
                typeAttributes: {
                    label: {
                        fieldName: 'NPR',
                        target:'_blank'
                    },
                }
            },
            {
                label: 'Current Product',
                fieldName: 'Phoenix_Current_Product_Name__c',
                type: 'text',
                sortable: true
            },
            {
                label: 'Current Product Pack Size',
                fieldName: 'Phoenix_Current_Product_Pack_Size__c',
                type: 'text',
                sortable: true
            },
            {
                label: 'Current Product NDC',
                fieldName: 'Phoenix_Current_Product_NDC__c',
                type: 'text',
                sortable: true
            },
            {
                label: 'Contract Price',
                fieldName: 'Phoenix_Contract_Price__c',
                type: 'text',
                sortable: true
            },
            {
                label: 'Proposed Product',
                fieldName: 'Phoenix_Proposed_Product_Name__c',
                type: 'text',
                sortable: true
            },
            {
                label: 'Proposed Product Pack Size',
                fieldName: 'Phoenix_Proposed_Product_Pack_Size__c',
                type: 'text',
                sortable: true
            },
            {
                label: 'Proposed Product NDC',
                fieldName: 'Phoenix_Proposed_Product_NDC__c',
                type: 'text',
                sortable: true
            },
            {
                label: 'Awarded Quantity',
                fieldName: 'Phoenix_Awarded_Quantity__c',
                type: 'text',
                sortable: true
            }
        ]);
        component.set('v.mycolumns', [
            {
                label: 'Account',
                fieldName: 'Account_Url',
                type: 'url',
                sortable: true,
                typeAttributes: {
                    label: {
                        fieldName: 'Account',
                        target:'_blank'
                    },
                }
            },
            {
                label: 'Contract #',
                fieldName: 'Contract_Url',
                type: 'url',
                sortable: true,
                typeAttributes: {
                    label: {
                        fieldName: 'Contract',
                        target:'_blank'
                    },
                }
            },
            {
                label: 'Contract Description',
                fieldName: 'Phoenix_Contract_Internal_Description__c',
                type: 'text',
                sortable: true
            },
            {
                label: 'NPR Record',
                fieldName: 'NPR_URL',
                type: 'url',
                sortable: true,
                typeAttributes: {
                    label: {
                        fieldName: 'NPR',
                        target:'_blank'
                    },
                }
            },
            {
                label: 'Current Product',
                fieldName: 'CurrentProduct',
                type: 'text',
                sortable: true
            },
            {
                label: 'Current Product Pack Size',
                fieldName: 'Phoenix_Current_Product_Pack_Size__c',
                type: 'text',
                sortable: true
            },
            {
                label: 'Current Product NDC',
                fieldName: 'Phoenix_Current_Product_NDC__c',
                type: 'text',
                sortable: true
            },
            {
                label: 'Contract Price',
                fieldName: 'Phoenix_Contract_Price__c',
                type: 'text',
                sortable: true
            },
            {
                label: 'Proposed Product',
                fieldName: 'ProposedProduct',
                type: 'text',
                sortable: true
            },
            {
                label: 'Proposed Product Pack Size',
                fieldName: 'Phoenix_Proposed_Product_Pack_Size__c',
                type: 'text',
                sortable: true
            },
            {
                label: 'Proposed Product NDC',
                fieldName: 'Phoenix_Proposed_Product_NDC__c',
                type: 'text',
                sortable: true
            },
            {
                label: 'Awarded Quantity',
                fieldName: 'Phoenix_Awarded_Quantity__c',
                type: 'text',
                sortable: true
            },
            {
                label: 'Actual Qty 12m',
                fieldName: 'Phoenix_Actual_Quantity_Last_12m__c',
                type: 'text',
                sortable: true
            },
            {
                label: 'Lead Time (SCM)',
                fieldName: 'Phoenix_Lead_Time__c',
                type: 'text',
                editable: true,
                sortable: true
            },
            {
                label: 'Remarks',
                fieldName: 'Phoenix_Remarks__c',
                type: 'text',
                editable: true,
                sortable: true
            }
        ]);
    },
	openModal : function(component, event, helper) {
        helper.openModal(component, event);
	},
    closeModal: function(component, event, helper) {
        component.set("v.isModalOpen", false);
    },
    displaySelectedNDCLineItems: function(component, event, helper){
        var popupData = component.get("v.popupData");
        if(popupData.length != 0){
            var items = component.get("v.selectedLineItemsDuplicates");
            if(items.length == 0){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Error',
                    message:'Please select the contracts',
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'error'
                });
                toastEvent.fire();
            } else{
                component.set("v.isModalOpen", false);
                helper.updateData(component, event);
            }           
        } else{
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title : 'Error',
                message:'No contracts to add',
                duration:' 5000',
                key: 'info_alt',
                type: 'error'
            });
            toastEvent.fire();   
        }
    },
    backToNDCChange: function(component, event, helper) {
        component.set("v.selectedProducts", []);
        component.getEvent("NDCChangeToLineItems").setParams({"isProductsSelected" : false }).fire();
        component.set("v.isProductsSelected", false);
        component.set("v.isProductNotSelected", true);
    },
    
    backToDetailPage: function(component, event, helper){
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": component.get("v.recordId"),
            "slideDevName": "detail"
        });
        navEvt.fire();
        $A.get('e.force:refreshView').fire();
    },
    
    searchTable: function(component, event, helper){
        var searchList = component.get("v.searchList");
        var searchKey = event.getSource().get("v.value").toUpperCase();
        var tempArray = [];
        for(var i=0; i<searchList.length; i++){
            if((searchList[i].Account && searchList[i].Account.toUpperCase().indexOf(searchKey) != -1) || 
               (searchList[i].Contract && searchList[i].Contract.toUpperCase().indexOf(searchKey) != -1)){
                tempArray.push(searchList[i]);
            }
        }
        component.set("v.popupData",tempArray);
    },
    
    AddNewRow: function(component, event, helper) {
        // call the comman "createObjectData" helper method for add new Object Row to List  
        var productInstance = {
            'sobjectType' : 'Phoenix_NDC_Change_Product__c',
            'Phoenix_NDC_Change_Name__c' : component.get("v.recordId"),
            'Phoenix_Current_Product__c' : '',
            'Phoenix_Current_Product_Name__c' : '',
            'Phoenix_Current_NDC__c' : '',
            'Phoenix_Current_SAP_Number__c' : '',
            'Phoenix_Current_Pack_Size__c' : '',
            'Phoenix_Proposed_Product__c': '',
            'Phoenix_Proposed_Product_Name__c': '',
            'Phoenix_Proposed_NDC__c': '',
            'Phoenix_Proposed_SAP_Number__c' : '',
            'Phoenix_Proposed_Pack_Size__c': ''
        };
        var prodInstance = component.get("v.productList");
        var currentSelectedProducts = [];
        for(var i=0; i<prodInstance.length; i++){
            if(!currentSelectedProducts.includes(prodInstance[i].Phoenix_Current_Product__c)){
                currentSelectedProducts.push(prodInstance[i].Phoenix_Current_Product__c);
            }
        }
        component.set("v.selectedProducts", currentSelectedProducts);
        var isEmptyRecord = '';
        for(var i=0; i<prodInstance.length; i++){
            if(prodInstance[i].Phoenix_Current_Product__c == '' || prodInstance[i].Phoenix_Proposed_Product__c == ''){
                isEmptyRecord = true;
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Warning!',
                    message: 'Please fill all the fields to add row',
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'error'
                });
                toastEvent.fire();
            }
        }
        if(isEmptyRecord != true){
            prodInstance.push(productInstance);
            component.set("v.productList", prodInstance);
            var index = event.getParam("indexVar");
            if(index == 0) {
                component.set("v.disableBackButton", false);
            } else {
                component.set("v.disableBackButton", true);
            }
            var lengthOfList = component.get("v.productList").length;
            var compEvent = component.getEvent("productInstancesLength");
            compEvent.setParams({"productInstanceLength" : lengthOfList});
            compEvent.fire();   
        }
    },
    // function for delete the row 
    removeDeletedRow: function(component, event, helper) {
        // get the selected row Index for delete, from Lightning Event Attribute  
        var index = event.getParam("indexVar");
        if((index - 1) == 0) {
            component.set("v.disableBackButton", false);
        } else {
            component.set("v.disableBackButton", true);
        }
        // get the all List (List attribute) and remove the Object Element Using splice method    
        var AllRowsList = component.get("v.productList");
        var rowToDelete = AllRowsList[index];
        AllRowsList.splice(index, 1);
        if(rowToDelete){
         	component.set('v.removeChangeProductId', rowToDelete.Id);   
            helper.deleteNDCChangeProduct(component, event);
        }
        // set the List after remove selected row element  
        component.set("v.productList", AllRowsList);
        var lengthOfList = component.get("v.productList").length;
        var compEvent = component.getEvent("productInstancesLength");
        compEvent.setParams({"productInstanceLength" : lengthOfList});
        compEvent.fire();
    },
    
    updateSorting: function (component, event, helper) {
        var fieldName = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');
        component.set("v.sortedBy", fieldName);
        component.set("v.sortedDirection", sortDirection);
        helper.sortData(component, fieldName, sortDirection);
    },
    
    // function to save the Records 
    Save: function(component, event, helper) {
        var action = component.get("c.saveNDCChangeProducts");
        var prodInstance = component.get("v.productList");
        var productData = [];
        for(var i=0; i<prodInstance.length; i++){
            prodInstance[i].Phoenix_NDC_Change_Name__c = component.get("v.recordId");
            productData.push(prodInstance[i]);
        }
        var isNull = "";
        if(productData.length > 0){
            for(var i=0; i<productData.length;i++){
                if(productData[i].Phoenix_Current_Product__c == "" || productData[i].Phoenix_Proposed_Product__c == ""){
                    isNull = true;
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Error',
                        message:'Please select Current Product and Proposed Product',
                        duration:' 5000',
                        key: 'info_alt',
                        type: 'error'
                    });
                    toastEvent.fire();
                } else {
                    isNull = false;
                }
            }            
        } else{
            isNull = true;
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title : 'Error',
                message:'Please add products to save',
                duration:' 5000',
                key: 'info_alt',
                type: 'error'
            });
            toastEvent.fire();
        }

        if(isNull == false){
            action.setParams({
                "listProducts": productData
            });
            // set call back 
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state == "SUCCESS") {
                    var response = response.getReturnValue();
                    component.set("v.productList", response);
                    component.set("v.ndcChangeProductIds", response);
                    component.set("v.isProductNotSelected", false);
                    component.set("v.isProductSelected", true);
                    component.getEvent("NDCChangeToLineItems").setParams({"isProductsSelected" : true }).fire();
                    component.set("v.isProductsSelected", true);
                    component.set("v.isProductNotSelected", false);
                    var data = component.get("v.mydata");
                    if(data == null || data.length == 0){
                        helper.openModal(component, event, helper);   
                    }
                } else{
                    console.log("Error "+JSON.stringify(response.getError()));
                }
            });
            // enqueue the server side action  
            $A.enqueueAction(action);
            //helper.getNDCLineItems(component, event);
        }
    },
    
    getSelectedContracts: function(component, event, helper) {
        var selectedRec = event.getSource().get("v.text");
        var isChecked = event.getSource().get("v.value");
        var existingNPRIds = component.get("v.existingNPRIds");
        var deleteNPRIds = component.get("v.deleteNPRIds");
        if(isChecked == true) {
            component.set("v.disableDelete", false);
         	//existingNPRIds.pop(selectedRec);
            deleteNPRIds.push(selectedRec);
        } else {
            component.set("v.disableDelete", true);
            //existingNPRIds.push(selectedRec);
            deleteNPRIds.pop(selectedRec);
        }
        //component.set("v.existingNPRIds", existingNPRIds);
        component.set("v.deleteNPRIds", deleteNPRIds);
        /*if(existingNPRIds.length == 0){
            component.set("v.disableDelete", true);
        } else {
            component.set("v.disableDelete", false);
        }*/
        //console.log('Existing NPRIDs'+component.get("v.existingNPRIds")+' Length:: '+component.get("v.existingNPRIds").length);
        
      /*var selectedRows = event.getParam('selectedRows');
        component.set("v.rowsToDelete", selectedRows);
        var selectedRows = event.getParam('selectedRows');
        if(selectedRows.length == 0){
            component.set("v.disableDelete", true);
            component.set("v.disableBack", false);
        } else {
            component.set("v.disableDelete", false);
            component.set("v.disableBack", true);
        }*/
    },
    
    checkboxAll:function(component, event, helper) {
        var isChecked = event.getSource().get("v.value") ? true : false;
        var selectedRows = component.get("v.rowsToDelete");
        var allData = component.get("v.mydata");
        var removedLineItems = component.get("v.removedLineItems");
        var mydata =  component.get("v.mydata");
        var deleteNPRIds = component.get("v.deleteNPRIds");
        if(isChecked == true){
            var updatedData = [];
            var allRowsDelete = [];
            for(var i=0; i<mydata.length; i++){
                mydata[i].isChecked = true;
                updatedData.push(mydata[i]);
            }
            component.set("v.mydata", updatedData);
            component.set("v.disableDelete", false);
            for(var i=0; i<allData.length; i++){
                allRowsDelete.push(allData[i].Phoenix_Current_NPR__c);
                deleteNPRIds.push(allData[i].Phoenix_Current_NPR__c);
            }
            /*var checkboxes = component.find("checkbox");
            for(var i=0; i<checkboxes.length; i++){
                console.log('---'+checkboxes[i].get("v.value"));
            }*/
            component.set("v.deleteAllRows", true);
            component.set("v.deleteNPRIds", deleteNPRIds);
            component.set("v.rowsToDelete", allRowsDelete);
        } else {
            component.set("v.disableDelete", true);
            var updatedData = [];
            var allRowsDelete = [];
            for(var i=0; i<mydata.length; i++){
                mydata[i].isChecked = false;
                updatedData.push(mydata[i]);
            }
            component.set("v.mydata", updatedData);
            component.set("v.deleteNPRIds", []);
            component.set("v.deleteAllRows", false);
            component.set("v.rowsToDelete", allRowsDelete);
        }
        if(allRowsDelete.length == 0){
            component.set("v.disableDelete", true);
        } else {
            component.set("v.disableDelete", false);
        }  
    },
    
    removeSelectedContracts: function(component, event, helper) {
        /*var selectedItems = component.get("v.selectedLineItems");
        var mydata = component.get("v.mydata");
        var selectedRows = component.get("v.rowsToDelete");
        var lineItemsData = [];
        var updatedNPRData = [];
        var updatedData = [];
        var removedLineItems = component.get("v.removedLineItems");
        for(var i =0; i<selectedItems.length; i++) {
            if(selectedRows.includes(selectedItems[i].NPR)){
                removedLineItems.push(selectedItems[i]);
            } else {
                updatedData.push(selectedItems[i]);
                updatedNPRData.push(selectedItems[i].NPR);
            }
        }
        component.set("v.selectedLineItems", updatedData);
        component.set("v.existingData", updatedNPRData);
        console.log('Remoed LineiTem'+removedLineItems);
        component.set("v.removedLineItems", removedLineItems);*/
        helper.deleteData(component, event);
    },
    
    getSelectedName: function (component, event) {
        var selectedLineItems = component.get("v.selectedLineItems");
        var items = [];
        var selectedRows = event.getParam('selectedRows');
        var setRows = [];
        var selectedItems = [];
        var existingNPRIds = component.get("v.existingNPRIds");
        for(var i=0; i<selectedRows.length; i++){
            selectedItems.push(selectedRows[i]);
            items.push(selectedRows[i]);
        }
        component.set("v.selectedLineItems", selectedItems);
        component.set("v.selectedLineItemsDuplicates", items);
        /*console.log('Selected Rows::: '+JSON.stringify(selectedRows));
        for(var i=0; i<selectedRows.length; i++){
            existingNPRIds.push(selectedRows[i].Phoenix_Current_NPR__c);
        }
        component.set("v.existingNPRIds", existingNPRIds);
        var existingLineItems = [];
        if(selectedLineItems.length != 0){
            for(var i = 0; i<selectedLineItems.length; i++) {
                existingLineItems.push(selectedLineItems[i].NPR);
            }
            for(var i=0; i<selectedRows.length; i++) {
                if(existingLineItems.includes(selectedRows[i].NPR)){
                } else {
                    //selectedRows[i].isChecked = true;
                    selectedLineItems.push(selectedRows[i]);
                    existingLineItems.push(selectedRows[i].NPR);
                }
            }
            component.set("v.selectedLineItems", selectedLineItems);
            component.set("v.existingData", existingLineItems);
        } else {
            for(var i=0; i<selectedRows.length;i++){
               // selectedRows[i].isChecked = true;
                setRows.push(selectedRows[i]);
            }
            component.set("v.selectedLineItems", setRows);
        }*/
    },
    
    checkboxSelect: function(component, event, helper) {
      	var selectedRec = event.getSource().get("v.text");
    },
    
    getInputValue: function(component, event, helper) {
      var val = event.getSource().get("v.value")  ;
        component.set("v.inputLeadTime", val);
    },
    saveSelectedRows: function(component, event, helper) {
        var action = component.get("c.saveNDCChangeLineItems");
        var lineItems = component.get("v.mydata");
        var ndcChangeProductIds = component.get("v.ndcChangeProductIds");
        var data = [];
        console.log('recordNew----'+component.get("v.recordIdNew"));
         console.log('recordId----'+component.get("v.recordId"));
        var updatedLineItems = [];
        for(var i=0; i<lineItems.length; i++){
            var productId = lineItems[i].Phoenix_Current_Product__c;
            var ndcId = '';
            try{
                for(var j=0; j<ndcChangeProductIds.length ; j++){
                    if(ndcChangeProductIds[j].Phoenix_Current_Product__c == productId){
                        ndcId = ndcChangeProductIds[j].Id;
                    }
                }   
            }catch(e){
                console.log('Error here');
            }
            lineItems[i].Phoenix_NDC_Change_Product__c = ndcId;
            updatedLineItems.push(lineItems[i]);
        }
        console.log('Updated LineItems:: '+JSON.stringify(updatedLineItems));

        if(updatedLineItems.length != 0){
            action.setParams({
                "selectedProducts": updatedLineItems
            });
            // set call back 
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state == "SUCCESS") {
                    var navEvt = $A.get("e.force:navigateToSObject");
                    navEvt.setParams({
                        "recordId": component.get("v.recordId"),
                        "slideDevName": "detail"
                    });
                    navEvt.fire();
                    $A.get('e.force:refreshView').fire();
                } else{
                    console.log("Error "+JSON.stringify(response.getError()));
                }
            });
            // enqueue the server side action  
            $A.enqueueAction(action);   
        } else {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title : 'Error',
                message:'No contracts selected',
                duration:' 5000',
                key: 'info_alt',
                type: 'error'
            });
            toastEvent.fire();
        }
    }
})