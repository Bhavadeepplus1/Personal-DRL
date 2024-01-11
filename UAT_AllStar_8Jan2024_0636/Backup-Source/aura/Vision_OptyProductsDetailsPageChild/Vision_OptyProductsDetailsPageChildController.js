({
	doInit : function(component, event, helper) {
        var itemObj = component.get("v.prodItem");
        if(itemObj.Product__c == undefined || itemObj.Product__c == null)
            component.set("v.isSearchProd",true);
	},
    handleChange : function(component, event, helper){
        console.log('changeFired');
        var itemObj = component.get("v.prodItem");
        if(itemObj.Product__c != undefined && itemObj.Product__c != null){
            var selectedId = itemObj.Product__c;
            var action = component.get("c.getProductDetails");
            action.setParams({
                productId : selectedId.replace('/',''),
                OptyProductId:itemObj.Id
            });
            action.setCallback(this,function(response){
                var state = response.getState();
                console.log('state-->'+state);
                if(state == 'SUCCESS'){
                    var wrapperObj = response.getReturnValue();
                    component.set("v.isShowprdOtyAnnualData",wrapperObj.isPacksizeNotMatched);
                    component.set("v.annualUnitsData",wrapperObj);
                    
                }else{
                    console.log('Error--->');
                }
                
            });
            $A.enqueueAction(action);
        }
    },
    saveOptyProduct: function(component, event, helper) {
        component.set("v.showSpinner",true);
        component.set("v.isShowprdOtyAnnualData",false);
        var selectedId = component.get("v.selectedOptyProductId");
        var warpperData = component.get("v.annualUnitsData");
        var action = component.get("c.saveProductData");
        action.setParams({
            wrapperObj : JSON.stringify(warpperData),optyId : component.get("v.recordId")
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state =='SUCCESS'){
                var optyProd = response.getReturnValue();
                component.set("v.prodItem",optyProd);
                component.set("v.showSpinner",false);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type":"success",
                    "title": "Success!",
                    "message": "The record has been updated successfully."
                });
                toastEvent.fire();
                
            }
        });
        $A.enqueueAction(action);
    },
    openSearch : function(component, event, helper){
        component.set("v.isSearchProd",true);
    },
    closeSearch : function(component, event, helper){
        component.set("v.isSearchProd",false);
    },
    closePopUpModal1 : function(component, event, helper){
        component.set("v.isShowprdOtyAnnualData",false);
    },
    onProductChange: function(component, event, helper) {
        var target = event.target;
        var rowIndex = target.getAttribute("data-row-index");
        //var titleName = event.getParam("title")
        console.log("Row No : " + rowIndex);
        //console.log("NAme : " + JSON.stringify(target));
    },
    onblur : function(component,event,helper){      
        component.set("v.listOfSearchResults", null );
        var forclose = component.find("searchRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
    },
    orderSearchKeyEntered: function(component, event, helper){
        var searchKey = event.target.value;
        console.log('searchKey:: '+searchKey);
        component.set("v.searchResultMessage",'');
        $A.util.addClass(component.find("mySpinner"), "slds-show");
        var forOpen = component.find("searchRes");
        $A.util.addClass(forOpen, 'slds-is-open');
        $A.util.removeClass(forOpen, 'slds-is-close');
        var action = component.get("c.getProductListSearch");
        action.setParams({
            searchKeyWord : searchKey,
            filterIds : component.get("v.existingProducts")
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            console.log('state from getProductListSearch-->'+state);
            if(state == 'SUCCESS'){
                var respList = response.getReturnValue();
                if(respList.length == 0){
                    component.set("v.searchResultMessage",'There are No Products found...');
                }
                else{
                    component.set("v.listOfSearchResults",respList);
                }
            }else{
                console.log('Error--->');
            }
            $A.util.addClass(component.find("mySpinner"), "slds-hide");
        });
        $A.enqueueAction(action);
    },
    selectedRecordFromSearch : function(component, event, helper){
        var selectedPlanId = event.currentTarget.dataset.id;
        console.log('selectedPlanId --> '+selectedPlanId);
        var action = component.get("c.getProductDetails");
        action.setParams({
            productId : selectedPlanId.replace('/',''),
            OptyProductId:component.get("v.prodItem").Id
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            console.log('state getProductDetails-->'+state);
            if(state == 'SUCCESS'){
                var wrapperObj = response.getReturnValue();
                if(wrapperObj.isPacksizeNotMatched){
                    component.set("v.isShowprdOtyAnnualData",wrapperObj.isPacksizeNotMatched);
                    component.set("v.annualUnitsData",wrapperObj);
                }
                else{
                    component.set("v.prodItem",wrapperObj.optyProdObj);
                    component.set("v.isSearchProd",false);
                }
            }else{
                console.log('Error--->');
            }
            
        });
        $A.enqueueAction(action);
    },
    removeProdLookup : function(component, event, helper){
        var action = component.get("c.removeProductLookup");
        var itemObj = component.get("v.prodItem");
        action.setParams({
            optyProdId : itemObj.Id
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            console.log('state from remove ---> '+state);
            if(state =='SUCCESS'){
                itemObj.Product__c = null;
                component.set("v.prodItem",itemObj);
                component.set("v.isSearchProd",true);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type":"success",
                    "title": "Success!",
                    "message": "The record has been updated successfully."
                });
                toastEvent.fire();
            }
            else{
                console.log('error ---> '+JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);
    },
    moveToMatch : function(component, event, helper){
        component.set("v.smallSpinnerWhileMatch",true);
        var action = component.get("c.moveToMatched");
        var itemObj = component.get("v.prodItem");
        action.setParams({
            optyProdObj : JSON.stringify(itemObj)
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            console.log('state from moveToMatch ---> '+state);
            if(state =='SUCCESS'){
                component.set("v.smallSpinnerWhileMatch",false);
                var respUpdatedItem = response.getReturnValue();
                component.set("v.prodItem",respUpdatedItem);
                /*var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type":"success",
                    "title": "Success!",
                    "message": "The record has been Moved to matched products."
                });
                toastEvent.fire();*/
                var cmpEvent = component.getEvent("sampleCmpEvent"); 
                cmpEvent.setParams({optyProdObj : respUpdatedItem,
                                    prodStatus : 'Unmatched'}); 
                cmpEvent.fire(); 
            }
            else{
                component.set("v.smallSpinnerWhileMatch",false);
                console.log('error ---> '+JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);
    }
})