({
    loadInstance: function(component, event) {
        var action = component.get("c.getNDCChangeProductInfo");
        action.setParams({
            "recordId": component.get("v.recordId")
        });
        action.setCallback(this, function(response) 
                           {
                               if(response.getState()=="SUCCESS"){
                                   var onLoadData = response.getReturnValue();
                                   var productList = [];
                                   var selectedProducts = [];
                                   if(onLoadData.length > 0){
                                       for(var i=0; i<onLoadData.length; i++){
                                           var productInstance = {
                                               'sobjectType' : 'Phoenix_NDC_Change_Product__c',
                                               'Id': onLoadData[i].Id,
                                               'Phoenix_NDC_Change_Name__c' : onLoadData[i].Phoenix_NDC_Change_Name__c,
                                               'Phoenix_Current_Product__c' : onLoadData[i].Phoenix_Current_Product__c,
                                               'Phoenix_Current_Product_Name__c' : onLoadData[i].Phoenix_Current_Product__r.Name,
                                               'Phoenix_Current_NDC__c' : onLoadData[i].Phoenix_Current_NDC__c,
                                               'Phoenix_Current_SAP_Number__c' : onLoadData[i].Phoenix_Current_SAP_Number__c,
                                               'Phoenix_Current_Pack_Size__c' : onLoadData[i].Phoenix_Current_Pack_Size__c,
                                               'Phoenix_Proposed_Product__c': onLoadData[i].Phoenix_Proposed_Product__c,
                                               'Phoenix_Proposed_Product_Name__c': onLoadData[i].Phoenix_Proposed_Product__r.Name,
                                               'Phoenix_Proposed_NDC__c': onLoadData[i].Phoenix_Proposed_NDC__c,
                                               'Phoenix_Proposed_SAP_Number__c' : onLoadData[i].Phoenix_Proposed_SAP_Number__c,
                                               'Phoenix_Proposed_Pack_Size__c': onLoadData[i].Phoenix_Proposed_Pack_Size__c
                                           };
                                           selectedProducts.push(onLoadData[i].Phoenix_Current_Product__c);
                                           productList.push(productInstance);
                                       }
                                       component.set("v.recordId", onLoadData[0].Phoenix_NDC_Change_Name__r.Id);
                                       component.set("v.productList", productList); 
                                       component.set("v.selectedProducts", selectedProducts);
                                       var lengthOfList = component.get("v.productList").length;
                                       var compEvent = component.getEvent("productInstancesLength");
                                       compEvent.setParams({"productInstanceLength" : lengthOfList});
                                       compEvent.fire();
                                   }
                                   //component.set("v.CurrentProductFamily", onLoadData[0].Phoenix_NDC_Change_Name__r.Phoenix_Current_Product_Family__c);
                                   //component.set("v.ProposedProductFamily", onLoadData[0].Phoenix_NDC_Change_Name__r.Phoenix_Proposed_Product_Family__c);
                                   //component.set("v.selectedCurrentProduct", productInstance.Phoenix_Current_Product_Name__c);
                                   //component.set("v.selectedProposedProduct", productInstance.Phoenix_Proposed_Product_Name__c);
                                   this.getChangeProductData(component, event);
                                   this.getNDCLineItems(component, event);
                               } else{
                                   console.log(response.response.getError().message());
                               }
                           });
        $A.enqueueAction(action);
    },
    deleteNDCChangeProduct: function(component, event){
      var action = component.get("c.deleteNDCProduct");
      var rowIdToDelete = component.get("v.removeChangeProductId");
        this.getLineItemIds(component, event);
        action.setParams({
            'recordId': rowIdToDelete
        });
        action.setCallback(this, function(response) {
            if(response.getState()=="SUCCESS"){
                console.log('Record Deleted Successfully');
                this.deleteNDCLineItems(component, event);
                this.getNDCLineItems(component, event);
            } else{
                console.log(response.getError().message());
            }
        });
        $A.enqueueAction(action);
    },
    
    getLineItemIds: function(component, event){
        var action = component.get("c.getLineItemIdsToDelete");
        action.setParams({
            'recordId': component.get("v.removeChangeProductId")
        });
        action.setCallback(this, function(response){
            if(response.getState() == 'SUCCESS'){
                var resp = response.getReturnValue();
                var ids = [];
                for(var i=0; i<resp.length; i++){
                    ids.push(resp[i].Id);
                }
                component.set("v.deleteLineItems", ids);
            }
        });
        $A.enqueueAction(action);
    },
    
	openModal : function(component, event, helper) {
        this.getNPRData(component, event);
		component.set("v.isModalOpen", true);
        component.set("v.popupLoaded", true);
	},
    
    getNDCLineItems: function(component, event){
        var action = component.get("c.getNDCLineItems");
        var mydata = [];
        var nprIds = [];
        action.setParams({
            'recordId': component.get("v.recordId")
        });
        action.setCallback(this, function(response) 
                           {
                               if(response.getState()=="SUCCESS"){
                                   var resp = response.getReturnValue();
                                   if(resp.length > 0){
                                       for(var i=0; i<resp.length; i++){
                                           var respVar={};
                                           respVar.Id = resp[i].Id;
                                           respVar.Phoenix_Proposed_Product_Name__c = resp[i].Phoenix_Proposed_Product__r.Name;
                                           respVar.Phoenix_Proposed_Product__c = resp[i].Phoenix_Proposed_Product__c;
                                           respVar.Phoenix_Proposed_Product_Pack_Size__c = resp[i].Phoenix_Proposed_Product_Pack_Size__c;
                                           respVar.Phoenix_Proposed_Product_NDC__c = resp[i].Phoenix_Proposed_Product_NDC__c;
                                           respVar.Account = resp[i].Phoenix_Account__r.Name;
                                           respVar.Phoenix_Account__c = resp[i].Phoenix_Account__c;
                                           respVar.Account_Url = '/'+resp[i].Phoenix_Account__c;
                                           respVar.Contract = resp[i].Phoenix_Contract__r.Name;
                                           respVar.Phoenix_Contract__c = resp[i].Phoenix_Contract__c;
                                           respVar.Contract_Url = '/'+resp[i].Phoenix_Contract__c;
                                           respVar.Phoenix_Contract_Internal_Description__c = resp[i].Phoenix_Contract_Internal_Description__c;
                                           respVar.NPR = resp[i].Phoenix_Current_NPR__r.Name;
                                           respVar.NPR_URL = '/'+resp[i].Phoenix_Current_NPR__r.Id;
                                           respVar.Phoenix_Current_NPR__c = resp[i].Phoenix_Current_NPR__c;
                                           respVar.Phoenix_Current_Product_Name__c = resp[i].Phoenix_Current_Product__r.Name;
                                           respVar.Phoenix_Current_Product__c = resp[i].Phoenix_Current_Product__c;
                                           respVar.Phoenix_Current_Product_Pack_Size__c = resp[i].Phoenix_Current_Product_Pack_Size__c;
                                           respVar.Phoenix_Current_Product_NDC__c = resp[i].Phoenix_Current_Product_NDC__c;
                                           respVar.Phoenix_Contract_Price__c = resp[i].Phoenix_Contract_Price__c;
                                           respVar.Phoenix_Material_Code__c = resp[i].Phoenix_Material_Code__c;
                                             respVar.Phoenix_Awarded_Position__c = resp[i].Phoenix_Awarded_Position__c;
                                           respVar.Phoenix_Awarded_Quantity__c = resp[i].Phoenix_Awarded_Quantity__c;
                                           respVar.Phoenix_3_Months_Annualized_Quantity__c = resp[i].Phoenix_3_Months_Annualized_Quantity__c;
                                           respVar.Phoenix_Actual_Quantity_Last_12m__c = resp[i].Phoenix_Actual_Quantity_Last_12m__c;
                                           respVar.isChecked = false;
                                           nprIds.push(resp[i].Phoenix_Current_NPR__c);
                                           mydata.push(respVar);
                                       }
                                       component.set("v.mydata", mydata);
                                       component.set("v.selectedLineItems", mydata);
                                       component.set("v.existingNPRIds", nprIds);
                                   } else{
                                       component.set("v.mydata", []);
                                       component.set("v.selectedLineItems", []);
                                       component.set("v.existingNPRIds", []);   
                                   }
                               }
                           });
        $A.enqueueAction(action);
        
    },
    
    getChangeProductData: function(component, event) {
        var action = component.get("c.getProductsInfo");
        var currentProductOpts = [];
        var proposedProductOpts = [];
        action.setParams({ 
            "CurrentProductFamily": component.get("v.CurrentProductFamily"),
            "ProposedProductFamily": component.get("v.ProposedProductFamily")
        });
        action.setCallback(this, function(response) 
                           {
                               if(response.getState()=="SUCCESS"){
                                   var wrapperObj = response.getReturnValue();
                                   for(var i=0;i< wrapperObj.productData.length;i++){
                                       currentProductOpts.push({"class": "optionClass", label: wrapperObj.productData[i].Name, value: wrapperObj.productData[i].Id});
                                   }
                                   for(var i=0; i<wrapperObj.products.length; i++) {
                                       proposedProductOpts.push({"class": "optionClass", label: wrapperObj.products[i].Name, value: wrapperObj.products[i].Id});
                                   }
                                   component.set("v.currentProducts", currentProductOpts);
                                   component.set("v.proposedProducts", proposedProductOpts);
                                   component.set("v.loaded", false);
                               }
                           });
        $A.enqueueAction(action);
    },
        
    getNPRData: function(component){
        var productList = component.get("v.productList");
        var productIds = component.get("v.selectedProductIds");
        var existingNPRIds = component.get("v.existingNPRIds");
        for(var i=0; i<productList.length; i++) {
            if(!productIds.includes(productList[i].Phoenix_Current_Product__c)){
                productIds.push(productList[i].Phoenix_Current_Product__c);   
            }
        }
        var action = component.get("c.getNPRData");
        action.setParams({
            "recordIds": productIds,
            "existingNPRIds": existingNPRIds
        });
        // set call back 
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state == "SUCCESS") {
                var respData = response.getReturnValue();
                var popupData = [];
                var ndcChangeProductIds = component.get("v.ndcChangeProductIds");
                for(var i = 0; i < respData.length; i++){
                    var resp = {};
                    for(var j = 0; j<productList.length; j++) {
                        if(productList[j].Phoenix_Current_Product__c == respData[i].Phoenix_Product__c) {
                            resp.Phoenix_Proposed_Product_Name__c = productList[j].Phoenix_Proposed_Product_Name__c;
                            resp.Phoenix_Proposed_Product__c = productList[j].Phoenix_Proposed_Product__c;
                            resp.Phoenix_Proposed_Product_Pack_Size__c = productList[j].Phoenix_Proposed_Pack_Size__c;
                            resp.Phoenix_Proposed_Product_NDC__c = productList[j].Phoenix_Proposed_NDC__c;
                            //break;
                        }
                    }
                    resp.Phoenix_NDC_Change__c = component.get("v.recordId");
                    resp.Phoenix_SCM_Approval__c = respData[i].Phoenix_SCM_Approval__c;
                    resp.Account = respData[i].Phoenix_Account__r.Name;
                    resp.Phoenix_Account__c = respData[i].Phoenix_Account__c;
                    resp.Account_Url = '/'+respData[i].Phoenix_Account__c;
                    resp.Contract = respData[i].Phoenix_Contract__r.Name;
                    resp.Phoenix_Contract__c = respData[i].Phoenix_Contract__c;
                    resp.Contract_Url = '/'+respData[i].Phoenix_Contract__c;
                    resp.Phoenix_Contract_Internal_Description__c = respData[i].Phoenix_Contract__r.Phoenix_Contract_Internal_Description__c;
                    resp.NPR = respData[i].Name;
                    resp.NPR_URL = '/'+respData[i].Id;
                    resp.Phoenix_Current_NPR__c = respData[i].Id;
                    resp.Phoenix_Current_Product_Name__c = respData[i].Phoenix_Product__r.Name;
                    resp.Phoenix_Current_Product__c = respData[i].Phoenix_Product__r.Id;
                    resp.Phoenix_Current_Product_Pack_Size__c = respData[i].Phoenix_Product__r.Phoenix_Pkg_Size__c;
                    resp.Phoenix_Current_Product_NDC__c = respData[i].Phoenix_Product__r.Phoenix_NDC_11_Dashes__c;
                    resp.Phoenix_Material_Code__c = respData[i].Phoenix_Material_Number__c;
                    resp.Phoenix_Contract_Price__c = respData[i].Phoenix_Contract_Price__c;
                    resp.Phoenix_Awarded_Quantity__c = respData[i].Phoenix_Awarded_Quantity__c;;
                    resp.Phoenix_Actual_Quantity_Last_12m__c = respData[i].Phoenix_12Months_Actual_Sales_Unit__c;
                    resp.Phoenix_Awarded_Position__c = respData[i].Phoenix_Product_Position__c;
                    resp.Phoenix_3_Months_Annualized_Quantity__c = respData[i].Phoenix_12Months_Sales_Unit__c;
                    resp.Phoenix_Lead_Time__c = '';
                    resp.Phoenix_Remarks__c = '';
                    resp.isChecked = false;
					popupData.push(resp);
                }
                component.set("v.popupData", popupData);
                component.set("v.searchList", popupData);
                component.set("v.originalData", popupData);
                component.set("v.popupLoaded", false);
                component.set("v.selectedLineItemsDuplicates", []);
            } else if(state == "ERROR"){
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        // enqueue the server side action  
        $A.enqueueAction(action);
    },
    
    deleteData: function(component, event){
        var mydata = component.get("v.mydata");
        var selectedItems = component.get("v.selectedLineItems");
        var existingNPRIds = component.get("v.existingNPRIds");
        var deleteNPRIds = component.get("v.deleteNPRIds");   
        var deleteAllRows = component.get("v.deleteAllRows");
        if(deleteNPRIds.length != 0){
            var updatedData = [];
            var deleteRecordIds = [];
            for(var i=0; i<mydata.length; i++){
                if(!deleteNPRIds.includes(mydata[i].Phoenix_Current_NPR__c)){
                    updatedData.push(mydata[i]);
                } else{
                    if(mydata[i].Id){
                        deleteRecordIds.push(mydata[i].Id);
                    }
                    existingNPRIds.pop(mydata[i].Phoenix_Current_NPR__c);
                }
            }
            component.set("v.disableDelete", true);
            component.set("v.deleteLineItems", deleteRecordIds);
            if(deleteRecordIds.length != 0){
                this.deleteNDCLineItems(component, event);
            }
            component.set("v.mydata", updatedData);
            component.set("v.selectedLineItems", updatedData);
            component.set("v.deleteNPRIds", []);
            component.set("v.existingNPRIds", existingNPRIds);
        }
        if(deleteAllRows == true){
            var deleteRecordIds = [];
            var data = component.get("v.mydata");
            for(var i=0; i<data.length; i++){
                if(mydata[i].Id){
                    deleteRecordIds.push(data[i].Id);
                }
            }
            component.set("v.deleteLineItems", deleteRecordIds);
            component.set("v.selectedLineItems", []);
            component.set("v.mydata", []);
            component.set("v.deleteNPRIds", []);
            component.set("v.existingNPRIds", []);
            component.set("v.selectAllCheckbox", false);
            if(deleteRecordIds.length != 0){
             	this.deleteNDCLineItems(component, event);   
            }
        }
    },

    updateData: function(component, event) {
        var mydata = component.get("v.mydata");
        var selectedItems = component.get("v.selectedLineItems");
        var existingNPRIds = component.get("v.existingNPRIds");
        if(mydata == null){
            var newData = [];
            var newNPRIds = [];
            for(var i=0; i<selectedItems.length; i++){
                newData.push(selectedItems[i]);
                newNPRIds.push(selectedItems[i].Phoenix_Current_NPR__c);
            }
            component.set("v.mydata", newData);
            component.set("v.existingNPRIds", newNPRIds);
            component.set("v.selectedItems", selectedItems);
        } else{
            for(var i=0; i<selectedItems.length; i++){
                mydata.push(selectedItems[i]);
                existingNPRIds.push(selectedItems[i].Phoenix_Current_NPR__c);
            }
            component.set("v.mydata", mydata);
            component.set("v.selectedItems", selectedItems);
            component.set("v.existingNPRIds", existingNPRIds);   
        }
    },
    
    deleteNDCLineItems: function(component, event){
      var action = component.get("c.deleteNDCLineItems");
      var deleteLineItems = component.get("v.deleteLineItems");
        action.setParams({
            'recordIds': deleteLineItems
        });
        action.setCallback(this, function(response) {
            if(response.getState()=="SUCCESS"){
                console.log('Record Deleted Successfully');
            } else if(response.getState() == "ERROR"){
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    sortData: function (component, fieldName, sortDirection) {
        var modal = component.get("v.isModalOpen");
        var fname = fieldName;
        if(modal == true){
         	var data = component.get("v.popupData");   
        } else {
            var data = component.get("v.mydata");
        }
        var reverse = sortDirection !== 'asc';
        if(data) {
         	data.sort(this.sortBy(fieldName, reverse));   
            if(modal == true){
                component.set("v.popupData", data);
            } else {
                component.set("v.mydata", data);
            }
        } else {
            console.log('No data exist');
        }
    },
    sortBy: function (field, reverse) {
        var key = function(x) {return x[field]};
        reverse = !reverse ? 1 : -1;
        return function (a, b) {
            return a = key(a), b = key(b), reverse * ((a > b) - (b > a));
        }
    }
})